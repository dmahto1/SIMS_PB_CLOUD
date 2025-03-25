$PBExportHeader$w_pick_print_order.srw
$PBExportComments$- Prompt for Batch Pick Print Sort Order
forward
global type w_pick_print_order from w_response_ancestor
end type
type rb_zone from radiobutton within w_pick_print_order
end type
type rb_order from radiobutton within w_pick_print_order
end type
type st_1 from statictext within w_pick_print_order
end type
type rb_summary from radiobutton within w_pick_print_order
end type
type rb_cust_order_no from radiobutton within w_pick_print_order
end type
type cbx_zone from checkbox within w_pick_print_order
end type
type gb_1 from groupbox within w_pick_print_order
end type
end forward

global type w_pick_print_order from w_response_ancestor
integer width = 910
integer height = 872
string title = "Print Pick List"
rb_zone rb_zone
rb_order rb_order
st_1 st_1
rb_summary rb_summary
rb_cust_order_no rb_cust_order_no
cbx_zone cbx_zone
gb_1 gb_1
end type
global w_pick_print_order w_pick_print_order

on w_pick_print_order.create
int iCurrent
call super::create
this.rb_zone=create rb_zone
this.rb_order=create rb_order
this.st_1=create st_1
this.rb_summary=create rb_summary
this.rb_cust_order_no=create rb_cust_order_no
this.cbx_zone=create cbx_zone
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_zone
this.Control[iCurrent+2]=this.rb_order
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rb_summary
this.Control[iCurrent+5]=this.rb_cust_order_no
this.Control[iCurrent+6]=this.cbx_zone
this.Control[iCurrent+7]=this.gb_1
end on

on w_pick_print_order.destroy
call super::destroy
destroy(this.rb_zone)
destroy(this.rb_order)
destroy(this.st_1)
destroy(this.rb_summary)
destroy(this.rb_cust_order_no)
destroy(this.cbx_zone)
destroy(this.gb_1)
end on

event ue_postopen;call super::ue_postopen;
// 09/07 - PCONKL We will default to Summary for Coty
If gs_project = 'COTY' Then
	rb_Summary.Checked = True
Else
	rb_zone.Checked = True
End If

cbx_zone.enabled=FALSE //09-Oct-2015 :Madhu - Disable the "Page Break by Zone" option
end event

event closequery;call super::closequery;
If Not istrparms.cancelled Then
	
	If rb_zone.Checked = True Then
		istrparms.String_Arg[1] = 'Z'
	ElseIf rb_summary.Checked = True Then
		istrparms.String_Arg[1] = 'S'
	//06-Apr-2015 :Madhu- Added 'Customer Order No' -START	
	ElseIf rb_cust_order_no.Checked =True Then
		istrparms.String_arg[1]='C'
	//06-Apr-2015 :Madhu- Added 'Customer Order No' -END	
	Else
		istrparms.String_Arg[1] = 'O'
	End If
	
	istrparms.boolean_arg[1] =cbx_zone.checked //09-Oct-2015 :Madhu - Store the "Page Break by Zone" value
End IF

Message.PowerObjectParm = IstrParms
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_pick_print_order
integer x = 375
integer y = 676
integer height = 88
end type

type cb_ok from w_response_ancestor`cb_ok within w_pick_print_order
integer x = 96
integer y = 676
integer width = 224
integer height = 88
end type

type rb_zone from radiobutton within w_pick_print_order
integer x = 55
integer y = 192
integer width = 608
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Zone/Location"
end type

event clicked;cbx_zone.enabled =FALSE //09-Oct-2015 :Madhu- Disabled the "Page Break by Zone" Option
cbx_zone.checked=FALSE //09-Oct-2015 :Madhu - Un-Checked the "Page Break by Zone" Option
end event

type rb_order from radiobutton within w_pick_print_order
integer x = 55
integer y = 268
integer width = 608
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Order"
end type

event clicked;cbx_zone.enabled =TRUE //09-Oct-2015 :Madhu- Enabled the "Page Break by Zone" Option

end event

type st_1 from statictext within w_pick_print_order
integer x = 18
integer y = 40
integer width = 736
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sort and Group by:"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_summary from radiobutton within w_pick_print_order
integer x = 55
integer y = 424
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Summary"
end type

event clicked;cbx_zone.enabled =FALSE //09-Oct-2015 :Madhu- Disabled the "Page Break by Zone" Option
cbx_zone.checked=FALSE //09-Oct-2015 :Madhu - Un-Checked the "Page Break by Zone" Option
end event

type rb_cust_order_no from radiobutton within w_pick_print_order
integer x = 55
integer y = 500
integer width = 526
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Cust Order No"
end type

event clicked;cbx_zone.enabled =FALSE //09-Oct-2015 :Madhu- Disabled the "Page Break by Zone" Option
cbx_zone.checked=FALSE //09-Oct-2015 :Madhu - Un-Checked the "Page Break by Zone" Option
end event

type cbx_zone from checkbox within w_pick_print_order
integer x = 133
integer y = 352
integer width = 667
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Page Break by Zone"
end type

type gb_1 from groupbox within w_pick_print_order
integer x = 27
integer y = 112
integer width = 873
integer height = 536
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

