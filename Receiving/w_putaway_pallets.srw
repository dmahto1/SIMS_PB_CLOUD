HA$PBExportHeader$w_putaway_pallets.srw
$PBExportComments$Putaway Comcast pallets from ITH/ITD
forward
global type w_putaway_pallets from w_main_ancestor
end type
type st_info from statictext within w_putaway_pallets
end type
type st_1 from statictext within w_putaway_pallets
end type
type dw_pallet from datawindow within w_putaway_pallets
end type
type cb_copy from commandbutton within w_putaway_pallets
end type
type cb_clear from commandbutton within w_putaway_pallets
end type
type cb_search from commandbutton within w_putaway_pallets
end type
type dw_inquiry from datawindow within w_putaway_pallets
end type
type cb_selectall from commandbutton within w_putaway_pallets
end type
type cb_clearall from commandbutton within w_putaway_pallets
end type
type st_note from statictext within w_putaway_pallets
end type
end forward

global type w_putaway_pallets from w_main_ancestor
integer width = 3186
integer height = 1468
string title = "Pallet Association - ITH/ITD"
st_info st_info
st_1 st_1
dw_pallet dw_pallet
cb_copy cb_copy
cb_clear cb_clear
cb_search cb_search
dw_inquiry dw_inquiry
cb_selectall cb_selectall
cb_clearall cb_clearall
st_note st_note
end type
global w_putaway_pallets w_putaway_pallets

type variables
Datawindow   idw_main, idw_inquiry,idw_pallet
Datastore 	idsSKUs, ids_pp
w_putaway_pallets iw_window
String is_sku, is_lot_no, is_msg
integer il_curr, il_rows, il_set, il_cnt, il_cnt2,il_cnt3,il_pallet_cnt,il_lot_quantity



end variables

forward prototypes
public function integer uf_getpalletcnt (string as_pallet_id)
public function integer uf_getsku (string as_model_no)
public function boolean uf_validsku ()
public function string uf_get_po_no (string asattr1, string asattr2, string asattr3, string asattr4, string asattr5)
public function string uf_get_model (string assku, string assuppcode)
public function string uf_get_model (string assku)
public function boolean uf_alreadyassigned (string aslotno)
end prototypes

public function integer uf_getpalletcnt (string as_pallet_id);integer i_cnt = 0

		Select count(*)
		into :i_cnt
		From carton_serial
		Where project_id = 'Comcast' and pallet_id = :as_pallet_id
		Using SQLCA;
		If sqlca.sqlcode <> 0 Then
			i_cnt = 0
		end if
			
	return i_cnt
end function

public function integer uf_getsku (string as_model_no);/* Get SKU from Item_Master when entering model number as user_field10 */
String sql_syntax, errors
Integer li_RowCount

li_RowCount = 0

//Create the datastores dynamically (no physical datastore object)
idsSKUs = Create Datastore		
sql_syntax = "select distinct SKU, Supp_Code from item_master where Project_ID = 'Comcast' and user_field10 = '" + as_model_no + "'"

//messagebox("SQL Syntax", sql_syntax)
idsSKUs.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", Errors))
IF Len(Errors) > 0 THEN
	messagebox("SQL Syntax", "*** Unable to create datastore for Item Master Records.~r~r" + Errors)
    Return - 1
END IF

idsSKUs.SetTransObject(SQLCA)
li_RowCount = idsSKUs.Retrieve()
				
return li_RowCount
end function

public function boolean uf_validsku ();// Return true if is_sku is in datastore lds_SKUs
int li_cnt, li_row
boolean lb_ret

lb_ret = False

li_cnt = idsSKUs.RowCount()
for li_row = 1 to li_cnt
	if is_sku = idsSKUs.GetItemString(li_row,"SKU") then
		lb_ret = true
		exit
	end if
next

return lb_ret

end function

public function string uf_get_po_no (string asattr1, string asattr2, string asattr3, string asattr4, string asattr5);/***************************************************
* Concatenate attributes with slash '/' between them to 
* populate PO_NO in receive_putaway, content, * delivery_
* picking.  Carton serial contains all five attributes for each
* serial number.  Pallets cannot have multiple attributes.
* Initial implementation for Attribute Level Processing will only
* populate attributes 1 through 3.  Later upgrade will add
* attributes 4 and 5.
**************************************************/
string ls_return

ls_return = ""
if (Trim(asAttr1) = "" or isNull(asAttr1)) then asAttr1 = "-" 
if (Trim(asAttr2) = "" or isNull(asAttr2)) then asAttr2 = "-"
if (Trim(asAttr3) = "" or isNull(asAttr3)) then asAttr3 = "-"
if (Trim(asAttr4) = "" or isNull(asAttr4)) then asAttr4 = "-"
if (Trim(asAttr5) = "" or isNull(asAttr5)) then asAttr5 = "-"

ls_return = asAttr1 + "/" + asAttr2 + "/" + asAttr3
if asAttr4 <> "-" then
	ls_return += "/" + asAttr4
	if asAttr5 <> "-" then
		ls_return += "/" + asAttr5
	end if
end if


return ls_return
end function

public function string uf_get_model (string assku, string assuppcode);String retModel

retModel = ''

		Select user_field10
		into :retModel
		From Item_Master
		Where project_id = 'Comcast' and SKU = :asSKU and Supp_Code = :asSuppCode
		Using SQLCA;
		If sqlca.sqlcode <> 0 Then
			retModel = asSKU
		end if

return retModel

end function

public function string uf_get_model (string assku);String retModel

retModel = ''

		Select TOP 1 user_field10
		into :retModel
		From Item_Master
		Where project_id = 'Comcast' and SKU = :asSKU 
		Using SQLCA;
		If sqlca.sqlcode <> 0 Then
			retModel = asSKU
		end if

return retModel

end function

public function boolean uf_alreadyassigned (string aslotno);boolean retVal
int li_cnt, li_rows

retVal = false
li_rows = ids_pp.RowCount()
for li_cnt = 1 to li_rows
	if asLotNo = ids_pp.GetItemString(li_cnt, 'find_column') then
		retVal = true
	end if
next

return retVal

end function

on w_putaway_pallets.create
int iCurrent
call super::create
this.st_info=create st_info
this.st_1=create st_1
this.dw_pallet=create dw_pallet
this.cb_copy=create cb_copy
this.cb_clear=create cb_clear
this.cb_search=create cb_search
this.dw_inquiry=create dw_inquiry
this.cb_selectall=create cb_selectall
this.cb_clearall=create cb_clearall
this.st_note=create st_note
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_info
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_pallet
this.Control[iCurrent+4]=this.cb_copy
this.Control[iCurrent+5]=this.cb_clear
this.Control[iCurrent+6]=this.cb_search
this.Control[iCurrent+7]=this.dw_inquiry
this.Control[iCurrent+8]=this.cb_selectall
this.Control[iCurrent+9]=this.cb_clearall
this.Control[iCurrent+10]=this.st_note
end on

on w_putaway_pallets.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_info)
destroy(this.st_1)
destroy(this.dw_pallet)
destroy(this.cb_copy)
destroy(this.cb_clear)
destroy(this.cb_search)
destroy(this.dw_inquiry)
destroy(this.cb_selectall)
destroy(this.cb_clearall)
destroy(this.st_note)
end on

event open;call super::open;iw_window = This

idw_inquiry = dw_inquiry
idw_pallet = dw_pallet

idw_pallet.SetTransObject(Sqlca)
idw_inquiry.SetTransObject(Sqlca)
idw_inquiry.insertrow(0)
idw_pallet.Reset()

idw_pallet.Visible = False
cb_copy.Visible = False
cb_selectall.Visible = False
cb_clearall.Visible = False
st_info.Visible = False
st_note.Visible = False

iw_window.idw_inquiry.setfocus()

end event

event resize;call super::resize;this.dw_pallet.Resize(2491,workspaceHeight()-500)

end event

type cb_cancel from w_main_ancestor`cb_cancel within w_putaway_pallets
integer x = 2688
integer y = 360
integer width = 402
string text = "&Done"
end type

type cb_ok from w_main_ancestor`cb_ok within w_putaway_pallets
boolean visible = false
integer x = 2414
integer y = 1068
boolean enabled = false
boolean default = false
end type

type st_info from statictext within w_putaway_pallets
integer x = 64
integer y = 360
integer width = 1477
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217741
long backcolor = 67108864
string text = "Choose pallet(s) and press Copy"
boolean focusrectangle = false
end type

type st_1 from statictext within w_putaway_pallets
integer x = 1038
integer y = 24
integer width = 1138
integer height = 80
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "PutAway List Pallet Association"
boolean focusrectangle = false
end type

type dw_pallet from datawindow within w_putaway_pallets
integer x = 64
integer y = 440
integer width = 2491
integer height = 808
integer taborder = 40
boolean titlebar = true
string title = "Pallet List"
string dataobject = "d_putaway_pallets"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;il_curr=row
il_rows = this.rowcount()
il_set = 0

if dw_pallet.GetItemString(il_curr,"c_apply_ind") = "Y" then
	dw_pallet.SetItem(il_curr,"c_apply_ind","N")
else
	dw_pallet.SetItem(il_curr,"c_apply_ind","Y")
end if

for il_cnt = 1 to il_rows
	if dw_pallet.GetItemString(il_cnt,"c_apply_ind") = "Y" then
		il_set = il_set + 1
	end if
next

if il_set > 0 then
	cb_copy.Enabled = True
else 
	cb_copy.Enabled = False
end if


	


end event

type cb_copy from commandbutton within w_putaway_pallets
integer x = 2729
integer y = 580
integer width = 361
integer height = 92
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copy"
end type

event clicked;datawindow dw_putaway
integer i_putaway_cnt, li_sn_cnt, li_pallet_cnt, li_sku_cnt, li_error, li_row
String ls_model_no, ls_pallet_id,ls_new_model,ls_lot_quantity, ls_po_no, ls_putaway_model
String ls_pw_sku,ls_pw_model,ls_sku, ls_supp_code

il_set = 0
il_cnt3 = 0
li_error = 0
ids_pp = Create Datastore
ids_pp.DataObject = "d_find"

dw_putaway = w_ro.tab_main.tabpage_putaway.dw_putaway
il_rows = parent.dw_pallet.rowcount()
i_putaway_cnt = dw_putaway.rowcount()

for il_cnt = 1 to i_putaway_cnt
	is_lot_no = dw_putaway.GetItemString(il_cnt,'lot_no')
	if is_lot_no <> '-' or is_lot_no <> '' or not isnull(is_lot_no) then
		li_row = ids_pp.InsertRow(0)
		ids_pp.SetItem(li_row,'find_column',is_lot_no)
	end if
next

if il_rows > 0 then
	for il_cnt = 1 to i_putaway_cnt
		is_lot_no = dw_putaway.GetItemString(il_cnt,"lot_no")		// Only associate pallets not already associated
		if (is_lot_no = '-' or is_lot_no = '' or isnull(is_lot_no)) then
			ls_pw_sku = dw_putaway.GetItemString(il_cnt,'sku')
			ls_pw_model = uf_get_model(ls_pw_sku)
			li_sn_cnt = dw_putaway.GetItemNumber(il_cnt,'quantity')
			for il_cnt3 = 1 to il_rows			// Step through dw_pallet to pick a row to associate
				if dw_pallet.GetItemString(il_cnt3,'c_apply_ind') = 'Y' then
					ls_model_no = dw_pallet.GetItemString(il_cnt3,'comcast_itd_model_no')
					li_pallet_cnt = dw_pallet.GetItemNumber(il_cnt3,'nbrserial')
					if UPPER(ls_model_no) = UPPER(ls_pw_model) and li_pallet_cnt <> 0 then
						ls_pallet_id = dw_pallet.GetItemString(il_cnt3,'comcast_ith_pallet_id')
						ls_po_no = uf_get_po_no(dw_pallet.GetItemString(il_cnt3,"comcast_itd_attribute_1"), &
									dw_pallet.GetItemString(il_cnt3,"comcast_itd_attribute_2"), &
									dw_pallet.GetItemString(il_cnt3,"comcast_itd_attribute_3"), &
									dw_pallet.GetItemString(il_cnt3,"comcast_itd_attribute_4"), &
									dw_pallet.GetItemString(il_cnt3,"comcast_itd_attribute_5") &					
									)
						// If the pallet id has not been associated already then assign it here
						if not uf_alreadyAssigned(ls_pallet_id) then
							if li_pallet_cnt < li_sn_cnt then
								dw_pallet.ScrollToRow(il_cnt3)
								is_msg = "Putaway list Row# " + string(il_cnt) + " shows quantity " + string(li_sn_cnt) + " but ~n"
								is_msg += "Pallet ID " + ls_pallet_id + " for model " + ls_model_no + " shows  " + string(li_pallet_cnt) 
								is_msg += ".~n~nAssociate this pallet anyway?"
								if MessageBox("Pallet Association Warning",is_msg,Question!,YesNo!) = 1 then
									dw_putaway.SetItem(il_cnt,"lot_no",ls_pallet_id)
									dw_putaway.SetItem(il_cnt, "po_no",  ls_po_no)
									dw_putaway.SetItem(il_cnt,"inventory_type", "S")		// NoPallet/Serial (Short of SNs)
									dw_pallet.SetItem(il_cnt3,'nbrserial',0)						// This row will not be used again
								end if
								exit
							elseif li_pallet_cnt > li_sn_cnt then
								dw_pallet.ScrollToRow(il_cnt3)
								is_msg = "Putaway list Row# " + string(il_cnt) + " shows quantity " + string(li_sn_cnt) + " but ~n"
								is_msg += "Pallet ID " + ls_pallet_id + " for model " + ls_model_no + " shows  " + string(li_pallet_cnt) 
								is_msg += ".~n~nAssociate this pallet anyway?"
								if MessageBox("Pallet Association Warning",is_msg,Question!,YesNo!) = 1 then
									dw_putaway.SetItem(il_cnt,"lot_no",ls_pallet_id)
									dw_putaway.SetItem(il_cnt, "po_no",  ls_po_no)
									dw_pallet.SetItem(il_cnt3,'nbrserial',0)						// This row will not be used again
								end if
								exit
							else
								dw_putaway.SetItem(il_cnt,"lot_no",ls_pallet_id)
								dw_putaway.SetItem(il_cnt, "po_no",  ls_po_no)
								dw_pallet.SetItem(il_cnt3,'nbrserial',0)							// This row will not be used again
								exit
							end if
						end if
					end if
				end if
			next
		end if
	next

end if


end event

type cb_clear from commandbutton within w_putaway_pallets
integer x = 2688
integer y = 220
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
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
	
	idw_pallet.Visible = False
	cb_copy.Visible = False
	cb_selectall.Visible = False
	cb_clearall.Visible = False
	st_info.Visible = False
	st_note.Visible = False
	idw_pallet.Reset()

idw_inquiry.SetFocus()
end event

type cb_search from commandbutton within w_putaway_pallets
integer x = 2693
integer y = 80
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Search"
boolean default = true
end type

event clicked;string ls_ref_nbr,ls_bol_nbr,ls_waybill_nbr,ls_pallet_id, ls_Null
integer li_cnt

li_cnt = 0
idw_inquiry.AcceptText()

ls_ref_nbr=idw_inquiry.GetItemString(1,"ref_nbr")
ls_bol_nbr=idw_inquiry.GetItemString(1,"bol_nbr")
ls_waybill_nbr=idw_inquiry.GetItemString(1,"waybill_nbr")
ls_pallet_id=idw_inquiry.GetItemString(1,"pallet_id")

if ls_ref_nbr <> '' then li_cnt = li_cnt + 1 else SetNull(ls_ref_nbr)
if ls_bol_nbr  <> '' then li_cnt = li_cnt + 1 else SetNull(ls_bol_nbr)
if ls_waybill_nbr <> '' then li_cnt = li_cnt + 1 else SetNull(ls_waybill_nbr)
if ls_pallet_id <> '' then li_cnt = li_cnt + 1 else SetNull(ls_pallet_id)

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
	dw_pallet.Object.DataWindow.ReadOnly= False
	li_cnt = idw_pallet.Retrieve(ls_ref_nbr,ls_bol_nbr,ls_waybill_nbr,ls_pallet_id)
	If  li_cnt = 0 Then
		messagebox("Retrieve Results","No records found!")
	Else
		idw_pallet.Visible = True
		cb_copy.Visible = True
		st_info.Visible = True
		cb_copy.Enabled = False
		cb_selectall.Visible = True
		cb_clearall.Visible = True
		st_note.Visible = True
		st_note.Text = String(li_cnt) + " Pallets Found"
	End If


end if
end event

type dw_inquiry from datawindow within w_putaway_pallets
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

type cb_selectall from commandbutton within w_putaway_pallets
integer x = 2729
integer y = 728
integer width = 361
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;
il_rows = parent.dw_pallet.rowcount()

for il_cnt = 1 to il_rows
	parent.dw_pallet.SetItem(il_cnt,"c_apply_ind","Y")
next

parent.cb_copy.Enabled = True

end event

type cb_clearall from commandbutton within w_putaway_pallets
integer x = 2729
integer y = 876
integer width = 361
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;il_rows = parent.dw_pallet.rowcount()

for il_cnt = 1 to il_rows
	parent.dw_pallet.SetItem(il_cnt,"c_apply_ind","N")
next

parent.cb_copy.Enabled = False

end event

type st_note from statictext within w_putaway_pallets
integer x = 2615
integer y = 1044
integer width = 475
integer height = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pallets Found"
alignment alignment = right!
boolean focusrectangle = false
end type

