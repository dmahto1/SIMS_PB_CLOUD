HA$PBExportHeader$w_pallet_association.srw
forward
global type w_pallet_association from w_master
end type
type dw_pallet from datawindow within w_pallet_association
end type
type cb_copy from commandbutton within w_pallet_association
end type
type cb_clear from commandbutton within w_pallet_association
end type
type cb_search from commandbutton within w_pallet_association
end type
type dw_inquiry from datawindow within w_pallet_association
end type
end forward

global type w_pallet_association from w_master
integer width = 3186
string title = "Pallet Association"
dw_pallet dw_pallet
cb_copy cb_copy
cb_clear cb_clear
cb_search cb_search
dw_inquiry dw_inquiry
end type
global w_pallet_association w_pallet_association

type variables
Datawindow   idw_main, idw_inquiry,idw_pallet
//w_pallet_association iw_window

end variables

on w_pallet_association.create
int iCurrent
call super::create
this.dw_pallet=create dw_pallet
this.cb_copy=create cb_copy
this.cb_clear=create cb_clear
this.cb_search=create cb_search
this.dw_inquiry=create dw_inquiry
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pallet
this.Control[iCurrent+2]=this.cb_copy
this.Control[iCurrent+3]=this.cb_clear
this.Control[iCurrent+4]=this.cb_search
this.Control[iCurrent+5]=this.dw_inquiry
end on

on w_pallet_association.destroy
call super::destroy
destroy(this.dw_pallet)
destroy(this.cb_copy)
destroy(this.cb_clear)
destroy(this.cb_search)
destroy(this.dw_inquiry)
end on

event open;call super::open;//iw_window = This

idw_inquiry = dw_inquiry
idw_pallet = dw_pallet

idw_pallet.SetTransObject(Sqlca)
idw_inquiry.SetTransObject(Sqlca)
idw_inquiry.insertrow(0)

//iw_window.idw_inquiry.setfocus()

end event

type dw_pallet from datawindow within w_pallet_association
integer x = 78
integer y = 440
integer width = 1755
integer height = 808
integer taborder = 40
string title = "none"
string dataobject = "d_putaway_pallets"
boolean border = false
boolean livescroll = true
end type

type cb_copy from commandbutton within w_pallet_association
integer x = 1888
integer y = 448
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copy"
end type

type cb_clear from commandbutton within w_pallet_association
integer x = 2697
integer y = 268
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;	idw_inquiry.SetItem(1,"ref_nbr","")
	idw_inquiry.SetItem(1,"bol_nbr","")
	idw_inquiry.SetItem(1,"waybill_nbr","")
	idw_inquiry.SetItem(1,"pallet_id","")
	
	idw_inquiry.SetFocus()
end event

type cb_search from commandbutton within w_pallet_association
integer x = 2702
integer y = 128
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Search"
end type

event clicked;string ls_ref_nbr,ls_bol_nbr,ls_waybill_nbr,ls_pallet_id
integer li_cnt

li_cnt = 0
idw_inquiry.AcceptText()

ls_ref_nbr=idw_inquiry.GetItemString(1,"ref_nbr")
ls_bol_nbr=idw_inquiry.GetItemString(1,"bol_nbr")
ls_waybill_nbr=idw_inquiry.GetItemString(1,"waybill_nbr")
ls_pallet_id=idw_inquiry.GetItemString(1,"pallet_id")

if ls_ref_nbr <> '' then li_cnt = li_cnt + 1
if ls_bol_nbr  <> '' then li_cnt = li_cnt + 1
if ls_waybill_nbr <> '' then li_cnt = li_cnt + 1
if ls_pallet_id <> '' then li_cnt = li_cnt + 1

if li_cnt = 0 then
	MessageBox("Entry Error","Enter one search parameter")
elseif li_cnt > 1 then
	MessageBox("Entry Error","Enter only one search parameter")
	idw_inquiry.SetItem(1,"ref_nbr","")
	idw_inquiry.SetItem(1,"bol_nbr","")
	idw_inquiry.SetItem(1,"waybill_nbr","")
	idw_inquiry.SetItem(1,"pallet_id","")
	
	idw_inquiry.SetFocus()
else
	MessageBox("Entry passed","Search Entry Succeeded")

end if
end event

type dw_inquiry from datawindow within w_pallet_association
integer x = 64
integer y = 100
integer width = 2555
integer height = 224
integer taborder = 10
string title = "none"
string dataobject = "d_pallet_search"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

