HA$PBExportHeader$w_logitech_packing_list_print_preview.srw
forward
global type w_logitech_packing_list_print_preview from window
end type
type cb_3 from commandbutton within w_logitech_packing_list_print_preview
end type
type cb_2 from commandbutton within w_logitech_packing_list_print_preview
end type
type cb_1 from commandbutton within w_logitech_packing_list_print_preview
end type
type dw_packing_list_print_preview from datawindow within w_logitech_packing_list_print_preview
end type
end forward

global type w_logitech_packing_list_print_preview from window
integer width = 3575
integer height = 2040
boolean titlebar = true
string title = "Logitech Packing List"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_packing_list_print_preview dw_packing_list_print_preview
end type
global w_logitech_packing_list_print_preview w_logitech_packing_list_print_preview

type variables

string 	is_DO
end variables

on w_logitech_packing_list_print_preview.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_packing_list_print_preview=create dw_packing_list_print_preview
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.dw_packing_list_print_preview}
end on

on w_logitech_packing_list_print_preview.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_packing_list_print_preview)
end on

event open;
long ll_cnt
DatawindowChild	ldwc

is_DO = message.StringParm

//load Priority dropdown (to lookup table)
dw_packing_list_print_preview.GetChild('delivery_master_Priority',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_project,'DP')

dw_packing_list_print_preview.SetTransObject(SQLCA)
ll_cnt = dw_packing_list_print_preview.Retrieve(is_DO)

string ls_shipping_instructions

if ll_cnt > 0 then
	
	ls_shipping_instructions = dw_packing_list_print_preview.GetItemString( 1, "delivery_master_shipping_instructions")
	
	dw_packing_list_print_preview.object.t_shipping_instructions.text = ls_shipping_instructions
	
end if
end event

type cb_3 from commandbutton within w_logitech_packing_list_print_preview
integer x = 791
integer y = 1860
integer width = 402
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change FOB"
end type

event clicked;
string ls_fob

if dw_packing_list_print_preview.rowcount() > 0 then

	ls_fob = dw_packing_list_print_preview.GetItemString( 1, "delivery_master_user_field8")

else
	
	ls_fob = ""

end if

OpenWithParm (w_logitech_packing_change_fob, ls_fob)


if IsValid(message) then
	
	if message.StringParm <> "**CANCEL**" then
			


		ls_fob = Message.StringParm	

		
		dw_packing_list_print_preview.SetItem( 1, "delivery_master_user_field8", ls_fob)	
			
		UPDATE Delivery_Master SET User_Field8 = :ls_fob WHERE DO_NO = :is_DO USING SQLCA;
		
	end if

	
end if


end event

type cb_2 from commandbutton within w_logitech_packing_list_print_preview
integer x = 2062
integer y = 1860
integer width = 402
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
Close(parent)
end event

type cb_1 from commandbutton within w_logitech_packing_list_print_preview
integer x = 1595
integer y = 1860
integer width = 402
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
boolean default = true
end type

event clicked;
OpenWithParm(w_dw_print_options, dw_packing_list_print_preview) 


end event

type dw_packing_list_print_preview from datawindow within w_logitech_packing_list_print_preview
integer x = 5
integer y = 8
integer width = 3534
integer height = 1824
integer taborder = 10
string title = "none"
string dataobject = "d_logitech_packing_slip_prt"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

