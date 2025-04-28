HA$PBExportHeader$w_comcast_sik_order_reroute.srw
$PBExportComments$Allow reroute of SIK orders to another warehouse
forward
global type w_comcast_sik_order_reroute from w_response_ancestor
end type
type st_1 from statictext within w_comcast_sik_order_reroute
end type
type st_2 from statictext within w_comcast_sik_order_reroute
end type
type dw_1 from u_dw_ancestor within w_comcast_sik_order_reroute
end type
end forward

global type w_comcast_sik_order_reroute from w_response_ancestor
integer width = 1582
integer height = 1184
string title = "Select Orders for Warehouse Reroute"
st_1 st_1
st_2 st_2
dw_1 dw_1
end type
global w_comcast_sik_order_reroute w_comcast_sik_order_reroute

type variables
string is_msg = ""


end variables

on w_comcast_sik_order_reroute.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.dw_1
end on

on w_comcast_sik_order_reroute.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_1)
end on

event open;call super::open;
Str_Parms Lstrparm
long llOrderRows, llRow, lldw, llOrder
boolean lb_OVN = false
string lsOrder
datawindow ldw_temp

Lstrparm = Message.PowerObjectParm

ldw_temp = Create datawindow
ldw_temp = Lstrparm.datawindow_arg[1]

//IF UpperBound(Lstrparm.Datawindow_arg) > 0 THEN 
//	dw_1 = Lstrparm.Datawindow_arg[1]
//END IF	

llOrderRows = ldw_temp.RowCount()
st_1.Text = "Total orders:" + string(llOrderRows) 
st_2.Text = ldw_temp.GetItemString(1,"r_order")

//is_msg = "Should shipping be changed to Overnight?"

//If MessageBox("Reroute SIK orders ", is_msg, Question!,YesNo!,2) = 1 Then
//	lb_OVN = true
//end if

for llRow = 1 to llOrderRows
	lsOrder = ldw_temp.GetItemString(llRow,"r_order")
	is_msg += lsOrder + ","
	llOrder = dw_1.InsertRow(0)
	if lldw > 0 then
		dw_1.SetItem(llOrder,"r_order",lsOrder)
	end if
next

is_msg += "~ndw_1 RowCount:" + string(dw_1.RowCount())
MessageBox("Reroute Orders",is_msg)

end event

event ue_close;call super::ue_close;
Str_Parms Lstrparm

messagebox("Is dw_1 still valid?","No of records:"+string(dw_1.RowCount()))

Lstrparm.Datawindow_arg[1] = dw_1

Message.PowerObjectParm = Lstrparm

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_comcast_sik_order_reroute
integer x = 713
integer y = 952
end type

type cb_ok from w_response_ancestor`cb_ok within w_comcast_sik_order_reroute
integer x = 55
integer y = 948
end type

type st_1 from statictext within w_comcast_sik_order_reroute
integer x = 1065
integer y = 1000
integer width = 498
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Note"
boolean focusrectangle = false
end type

type st_2 from statictext within w_comcast_sik_order_reroute
integer x = 1070
integer y = 928
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Note"
boolean focusrectangle = false
end type

type dw_1 from u_dw_ancestor within w_comcast_sik_order_reroute
integer x = 64
integer y = 68
integer width = 1435
integer height = 848
boolean bringtotop = true
string dataobject = "d_comcast_sik_order_reroute"
boolean hscrollbar = true
boolean vscrollbar = true
end type

