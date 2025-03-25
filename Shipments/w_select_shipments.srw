HA$PBExportHeader$w_select_shipments.srw
$PBExportComments$Select Shipments to add to Order (inbound/Outbound)
forward
global type w_select_shipments from w_response_ancestor
end type
type dw_orders from u_dw_ancestor within w_select_shipments
end type
type st_1 from statictext within w_select_shipments
end type
type st_2 from statictext within w_select_shipments
end type
type st_3 from statictext within w_select_shipments
end type
type st_zip from statictext within w_select_shipments
end type
type st_carrier from statictext within w_select_shipments
end type
type st_awb from statictext within w_select_shipments
end type
type st_4 from statictext within w_select_shipments
end type
type cb_selectall from commandbutton within w_select_shipments
end type
type cb_clear from commandbutton within w_select_shipments
end type
end forward

global type w_select_shipments from w_response_ancestor
integer width = 2935
integer height = 1400
string title = "Select Shipment Orders"
dw_orders dw_orders
st_1 st_1
st_2 st_2
st_3 st_3
st_zip st_zip
st_carrier st_carrier
st_awb st_awb
st_4 st_4
cb_selectall cb_selectall
cb_clear cb_clear
end type
global w_select_shipments w_select_shipments

on w_select_shipments.create
int iCurrent
call super::create
this.dw_orders=create dw_orders
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_zip=create st_zip
this.st_carrier=create st_carrier
this.st_awb=create st_awb
this.st_4=create st_4
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_orders
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_zip
this.Control[iCurrent+6]=this.st_carrier
this.Control[iCurrent+7]=this.st_awb
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.cb_selectall
this.Control[iCurrent+10]=this.cb_clear
end on

on w_select_shipments.destroy
call super::destroy
destroy(this.dw_orders)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_zip)
destroy(this.st_carrier)
destroy(this.st_awb)
destroy(this.st_4)
destroy(this.cb_selectall)
destroy(this.cb_clear)
end on

event open;call super::open;
IstrParms = Message.PowerobjectParm

end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc

If Istrparms.String_Arg[1] = 'I' Then
	
	This.Title = "Select Inbound Shipment Orders"
	//If Inbound, switch Dataobject for retrieving Inbound Orders
	dw_orders.Dataobject = 'd_select_Inbound_Orders'
	dw_orders.SetTransObject(SQLCA)
Else /*Outbound*/
	
	This.Title = "Select Outbound Shipment Orders"
	
End If

St_Carrier.Text = Istrparms.String_Arg[2]
St_Zip.Text = Istrparms.String_Arg[3]
St_awb.Text = Istrparms.String_Arg[4]

dw_orders.GetChild('ord_Type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)

//Retrieve available orders for carrier, zip, awb
dw_Orders.Retrieve(gs_Project,Istrparms.String_Arg[2], Istrparms.String_Arg[3], Istrparms.String_Arg[4])




end event

event closequery;call super::closequery;Str_parms	lstrParms
Long	llRowCOunt, llRowPos, llArrayPos

//Pass back the selected orders - either RO_NO or DO_NO

If Not Istrparms.Cancelled Then
	
	llRowCount = dw_Orders.RowCount()
	For llRowPos = 1 to llRowCount
		
		If dw_orders.GetITemString(llRowPos,'c_select_Ind') = 'Y' Then
			
			llArrayPos ++
			If Istrparms.String_arg[1] = 'I' Then /*Inbound -  RO_NO */
				Lstrparms.String_Arg[llArrayPos] = dw_orders.GetITemString(llRowPos,'ro_no')
			Else /*Outbound -  DO_NO */
				Lstrparms.String_Arg[llArrayPos] = dw_orders.GetITemString(llRowPos,'do_no')
			End If
		End If
		
	Next /* order row */
	
Else /*Cancelled by User */
	
	lstrparms.Cancelled = True
	
End If

Message.PowerObjectParm = Lstrparms

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_select_shipments
integer x = 2144
integer y = 1208
integer height = 92
integer textsize = -8
end type

type cb_ok from w_response_ancestor`cb_ok within w_select_shipments
integer x = 1307
integer y = 1208
integer height = 92
integer textsize = -8
end type

type dw_orders from u_dw_ancestor within w_select_shipments
integer x = 27
integer y = 116
integer width = 2862
integer height = 1020
boolean bringtotop = true
string dataobject = "d_select_outbound_orders"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type st_1 from statictext within w_select_shipments
integer x = 37
integer y = 4
integer width = 343
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Zip:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_select_shipments
integer x = 590
integer y = 4
integer width = 251
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Carrier:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_select_shipments
integer x = 1614
integer y = 4
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "AWB/BOL Nbr:"
boolean focusrectangle = false
end type

type st_zip from statictext within w_select_shipments
integer x = 142
integer y = 4
integer width = 361
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_carrier from statictext within w_select_shipments
integer x = 805
integer y = 4
integer width = 640
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_awb from statictext within w_select_shipments
integer x = 2002
integer y = 4
integer width = 640
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_4 from statictext within w_select_shipments
integer x = 41
integer y = 1148
integer width = 969
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Check Orders to add to Shipment"
boolean focusrectangle = false
end type

type cb_selectall from commandbutton within w_select_shipments
integer x = 59
integer y = 1220
integer width = 343
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All"
end type

event clicked;Long llRowCount, llRowPos

dw_orders.SetReDraw(False)

llRowCount = dw_orders.RowCount()
For llRowPos = 1 to llRowCount
	dw_orders.SetItem(llRowPos,'c_select_ind','Y')
Next

dw_orders.SetReDraw(True)
end event

type cb_clear from commandbutton within w_select_shipments
integer x = 480
integer y = 1220
integer width = 343
integer height = 80
integer taborder = 40
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
Long llRowCount, llRowPos

dw_orders.SetReDraw(False)

llRowCount = dw_orders.RowCount()
For llRowPos = 1 to llRowCount
	dw_orders.SetItem(llRowPos,'c_select_ind','N')
Next

dw_orders.SetReDraw(True)
end event

