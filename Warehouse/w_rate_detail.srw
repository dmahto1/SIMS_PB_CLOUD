HA$PBExportHeader$w_rate_detail.srw
$PBExportComments$Stock Adjustment Program
forward
global type w_rate_detail from window
end type
type dw_1 from u_dw_ancestor within w_rate_detail
end type
type cb_done from commandbutton within w_rate_detail
end type
end forward

global type w_rate_detail from window
integer width = 2949
integer height = 1496
boolean titlebar = true
string title = "Rate Detail"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
windowtype windowtype = response!
long backcolor = 67108864
dw_1 dw_1
cb_done cb_done
end type
global w_rate_detail w_rate_detail

on w_rate_detail.create
this.dw_1=create dw_1
this.cb_done=create cb_done
this.Control[]={this.dw_1,&
this.cb_done}
end on

on w_rate_detail.destroy
destroy(this.dw_1)
destroy(this.cb_done)
end on

event open;//Here we are aaigning the values from stucture to a external datawindow
// String Parms value is being assigned in n_cst_gemini in function called of_orderrate()
integer i,li_cnt
string ls_str[19]
ls_str[1]='Total rate'
ls_str[2]='Dimensional Weight'
ls_str[3]='Air Fright Charges'
ls_str[4]='Air Fright Premium Charges'
ls_str[5]='Oversized Shipment Charge'
ls_str[6]='Advance Origin Charge'
ls_str[7]='Advance Desitination Charges'
ls_str[8]='Declare Value Charge'
ls_str[9]='Insurance value Charge'
ls_str[10]='Total Miscellaneous Charges'
ls_str[11]='Traffic Origin used for rating'
ls_str[12]='Traffic Destination used for rating'
ls_str[15]='Rated Weight'
ls_str[16]='Pickup Charges'
ls_str[17]='Delivery Charge'
ls_str[18]='Forward Charge'
ls_str[19]='Transport Service Charge'

FOR i=1 TO 19
	IF i = 13 or i = 14 THEN Continue //Skip the arrays
	IF g.istr_parms.string_arg[i] <> "" and g.istr_parms.string_arg[i] <> '0' THEN
		dw_1.insertrow(0)
		li_cnt=dw_1.RowCount()
		dw_1.object.label[li_cnt]=ls_str[i]
		dw_1.object.data_col[li_cnt]=g.istr_parms.string_arg[i]
	END IF	
NEXT
//Assign value of totoal charges at bottom
dw_1.object.total_chrges_t.text=g.istr_parms.string_arg[20]
end event

type dw_1 from u_dw_ancestor within w_rate_detail
integer x = 14
integer y = 28
integer width = 2811
integer height = 1124
string dataobject = "d_rate_detail"
boolean vscrollbar = true
boolean border = false
end type

type cb_done from commandbutton within w_rate_detail
integer x = 2359
integer y = 1184
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Done"
end type

event clicked;Close(Parent)
end event

