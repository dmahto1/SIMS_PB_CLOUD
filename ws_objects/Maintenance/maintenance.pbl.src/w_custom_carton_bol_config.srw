$PBExportHeader$w_custom_carton_bol_config.srw
forward
global type w_custom_carton_bol_config from window
end type
type cb_delete from commandbutton within w_custom_carton_bol_config
end type
type cb_add from commandbutton within w_custom_carton_bol_config
end type
type dw_custom_carton_bol_config_edit from datawindow within w_custom_carton_bol_config
end type
type st_1 from statictext within w_custom_carton_bol_config
end type
type dw_customer_list from datawindow within w_custom_carton_bol_config
end type
end forward

global type w_custom_carton_bol_config from window
integer width = 4626
integer height = 3296
boolean titlebar = true
string title = "Customer Customize"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_delete cb_delete
cb_add cb_add
dw_custom_carton_bol_config_edit dw_custom_carton_bol_config_edit
st_1 st_1
dw_customer_list dw_customer_list
end type
global w_custom_carton_bol_config w_custom_carton_bol_config

event open;
dw_customer_list.SetTransObject(SQLCA)

dw_customer_list.Retrieve(gs_project)

dw_custom_carton_bol_config_edit.SetTransObject(SQLCA)
end event

on w_custom_carton_bol_config.create
this.cb_delete=create cb_delete
this.cb_add=create cb_add
this.dw_custom_carton_bol_config_edit=create dw_custom_carton_bol_config_edit
this.st_1=create st_1
this.dw_customer_list=create dw_customer_list
this.Control[]={this.cb_delete,&
this.cb_add,&
this.dw_custom_carton_bol_config_edit,&
this.st_1,&
this.dw_customer_list}
end on

on w_custom_carton_bol_config.destroy
destroy(this.cb_delete)
destroy(this.cb_add)
destroy(this.dw_custom_carton_bol_config_edit)
destroy(this.st_1)
destroy(this.dw_customer_list)
end on

type cb_delete from commandbutton within w_custom_carton_bol_config
integer x = 1897
integer y = 3060
integer width = 402
integer height = 104
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Delete"
end type

type cb_add from commandbutton within w_custom_carton_bol_config
integer x = 1454
integer y = 3060
integer width = 402
integer height = 104
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Add"
end type

type dw_custom_carton_bol_config_edit from datawindow within w_custom_carton_bol_config
integer x = 1440
integer y = 124
integer width = 3127
integer height = 2908
integer taborder = 10
string title = "none"
string dataobject = "d_custom_carton_bol_config_edit"
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_custom_carton_bol_config
integer x = 50
integer y = 20
integer width = 443
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Customer"
boolean focusrectangle = false
end type

type dw_customer_list from datawindow within w_custom_carton_bol_config
integer x = 46
integer y = 124
integer width = 1358
integer height = 2908
integer taborder = 10
string title = "none"
string dataobject = "d_custom_carton_bol_customer_list"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
string ls_Cust_Code


if row > 0 then
	
		
	This.SelectRow(0, false)
	
	This.SelectRow(row, true)
	
	SetRow(row)

	
	ls_Cust_Code = this.GetItemString( row, "Cust_Code")
	

	dw_custom_carton_bol_config_edit.Retrieve(gs_project, ls_Cust_Code)
	
end if	
	
end event

