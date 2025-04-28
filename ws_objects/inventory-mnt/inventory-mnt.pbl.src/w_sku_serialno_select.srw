$PBExportHeader$w_sku_serialno_select.srw
forward
global type w_sku_serialno_select from window
end type
type cb_cancel from commandbutton within w_sku_serialno_select
end type
type mle_ops_info from multilineedit within w_sku_serialno_select
end type
type cb_return from commandbutton within w_sku_serialno_select
end type
type dw_sku_serialno_select from datawindow within w_sku_serialno_select
end type
end forward

global type w_sku_serialno_select from window
integer width = 3141
integer height = 1852
boolean titlebar = true
string title = "SKU -- Serial No Select"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_postopen ( )
cb_cancel cb_cancel
mle_ops_info mle_ops_info
cb_return cb_return
dw_sku_serialno_select dw_sku_serialno_select
end type
global w_sku_serialno_select w_sku_serialno_select

type variables
str_parms istr_parms

long il_return_code
end variables

event ue_postopen();// 01/03/2011 ujh: S/N_P   
// Return Codes
// 0 = ok, the parent was found and selected
// 1 = Cancel
// 2 = No Parent found for this component
//str_parms lstr_parms
string ls_owner_cd, ls_sku
long ll_return
istr_parms = message.PowerobjectParm 
ls_owner_cd = istr_parms.String_arg[1]
ls_sku = istr_parms.String_arg[2]
//ls_Serialno_entered = istr_parms.String_arg[3]

//dw_serial_no_add_delete.GetChild('Component_no',ldwc)
dw_sku_serialno_select.SetTransObject(SQLCA)

//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...I modified dw by removing Pandora hardcode.
ll_return = dw_sku_serialno_select.Retrieve(ls_owner_cd,ls_sku,gs_project)

if  ll_return > 0 then
	dw_sku_serialno_select.SelectRow(1,False)  // 01/03/2011 ujh: S/N_P: fix select on screen come up
	dw_sku_serialno_select.ScrollTorow(1)        // 01/03/2011 ujh: S/N_P: fix select on screen come up
	dw_sku_serialno_select.SelectRow(1,True)
	mle_ops_info.text = 'Please Select the SKU / Serial no combination of the parent for this item.'
	il_return_code = 0                                     // 01/03/2011 ujh: S/N_P:fix select on screen come up
	cb_return.visible = true
	cb_cancel.visible = true
else
//	mle_ops_info.text = 'No parent was found for this component.  Please check data entered'
//	il_return_code = 2
//	cb_cancel.visible = true
	istr_parms.String_arg[3] =  '2'
	CloseWithReturn(w_sku_serialno_select, istr_parms)
end if



end event

on w_sku_serialno_select.create
this.cb_cancel=create cb_cancel
this.mle_ops_info=create mle_ops_info
this.cb_return=create cb_return
this.dw_sku_serialno_select=create dw_sku_serialno_select
this.Control[]={this.cb_cancel,&
this.mle_ops_info,&
this.cb_return,&
this.dw_sku_serialno_select}
end on

on w_sku_serialno_select.destroy
destroy(this.cb_cancel)
destroy(this.mle_ops_info)
destroy(this.cb_return)
destroy(this.dw_sku_serialno_select)
end on

event open;
mle_ops_info.text = 'Please wait for data'
cb_return.visible = false
cb_cancel.visible = false
// 01/03/2011 ujh: S/N_P:   place the retrieve in this event so the window ill open quickly and not wait for the retrieve.
this.event post ue_postopen()

end event

event close;
// 01/03/2011 ujh: S/N_P fx2
//cb_cancel.triggerEvent(clicked!)
end event

type cb_cancel from commandbutton within w_sku_serialno_select
integer x = 2601
integer y = 132
integer width = 402
integer height = 144
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;
// 01/03/2011 ujh: S/N_P:  provide a way to return to parent window without taking an action


istr_parms.String_arg[3] =  '1'

CloseWithReturn(parent, istr_parms)
end event

type mle_ops_info from multilineedit within w_sku_serialno_select
integer x = 18
integer y = 128
integer width = 1938
integer height = 152
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

type cb_return from commandbutton within w_sku_serialno_select
integer x = 1984
integer y = 132
integer width = 571
integer height = 144
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Return w/ Selection"
end type

event clicked;
// 01/03/2011 ujh: S/N_P 
String ls_name
long current_row
//ls_name = DWO.NAME

current_row = dw_sku_serialno_select.Getrow()
//Choose Case upper(ls_name)
//	Case 'SKUSERIAL'
If current_row > 0  and il_return_code = 0 then
		istr_parms.String_arg[3] = '0'
		istr_parms.String_arg[4] = dw_sku_serialno_select.GetItemString(current_row, 'skuserial')
		 // 01/03/2011 ujh: S/N_Pd  Return parent sku in enhancement to force component to  match bom
		istr_parms.String_arg[5]  =dw_sku_serialno_select.GetItemString(current_row, 'SKU_parent')  
		istr_parms.String_arg[6] = dw_sku_serialno_select.GetItemString(current_row, 'Serial_no')
		istr_parms.String_arg[7] = String(dw_sku_serialno_select.GetItemNumber(current_row, 'Component_no'), '0')
		CloseWithReturn(parent, istr_parms)
	else
		messagebox('Select Info', 'Please select a row or select CANCEL to return to the parent window')
	end if
		
//End Choose




end event

type dw_sku_serialno_select from datawindow within w_sku_serialno_select
integer x = 14
integer y = 292
integer width = 3022
integer height = 1424
integer taborder = 10
string title = "Parent SKU / Serial No"
string dataobject = "d_sku_serial_select"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;// 01/03/2011 UJH: S/N_P:   Force selection of a row or cancel button.
long current_row

current_row = dw_sku_serialno_select.Getrow()
dw_sku_serialno_select.SelectRow(current_row,false)
if row > 0 then
	dw_sku_serialno_select.SelectRow(row,true)
	il_return_code  = 0
ELSE
	il_return_code  = -1
end if



end event

event doubleclicked;

//01/03/2011 ujh: S/N_Pfx2
cb_return.triggerEvent(clicked!)

end event

