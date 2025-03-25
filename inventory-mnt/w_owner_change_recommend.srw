HA$PBExportHeader$w_owner_change_recommend.srw
$PBExportComments$*Recomendations for SKU putaway locations
forward
global type w_owner_change_recommend from window
end type
type sle_pallet from singlelineedit within w_owner_change_recommend
end type
type cb_allocate_pallet from commandbutton within w_owner_change_recommend
end type
type cb_2 from commandbutton within w_owner_change_recommend
end type
type st_owner_cd from statictext within w_owner_change_recommend
end type
type st_po_no from statictext within w_owner_change_recommend
end type
type st_5 from statictext within w_owner_change_recommend
end type
type st_4 from statictext within w_owner_change_recommend
end type
type cb_1 from commandbutton within w_owner_change_recommend
end type
type dw_current from u_dw_ancestor within w_owner_change_recommend
end type
type cbx_show from checkbox within w_owner_change_recommend
end type
type st_remain from statictext within w_owner_change_recommend
end type
type st_total from statictext within w_owner_change_recommend
end type
type st_2 from statictext within w_owner_change_recommend
end type
type st_3 from statictext within w_owner_change_recommend
end type
type st_1 from statictext within w_owner_change_recommend
end type
type st_sku from statictext within w_owner_change_recommend
end type
type cb_clear from commandbutton within w_owner_change_recommend
end type
type cb_ok from commandbutton within w_owner_change_recommend
end type
end forward

global type w_owner_change_recommend from window
integer x = 823
integer y = 362
integer width = 4517
integer height = 1696
boolean titlebar = true
string title = "From Locations"
windowtype windowtype = response!
long backcolor = 79741120
event ue_postopen ( )
event ue_calc_remaining ( )
event ue_clear ( )
sle_pallet sle_pallet
cb_allocate_pallet cb_allocate_pallet
cb_2 cb_2
st_owner_cd st_owner_cd
st_po_no st_po_no
st_5 st_5
st_4 st_4
cb_1 cb_1
dw_current dw_current
cbx_show cbx_show
st_remain st_remain
st_total st_total
st_2 st_2
st_3 st_3
st_1 st_1
st_sku st_sku
cb_clear cb_clear
cb_ok cb_ok
end type
global w_owner_change_recommend w_owner_change_recommend

type variables
str_parms	istrparms
Decimal	idRemain
Window	iwCurrent

boolean ib_cancel = false

boolean ib_display_cc_error_msg
end variables

event ue_postopen();// 11/02 - PConkl - Qty Changed to Decimal

Long					llFindRow
Decimal				ldQty
String				lsFind
datawindowChild	ldwc



// 09/03 - PCONKL - added ability to show Inventory Type and Owner. Default to Checked for 3COMNASH.
// If checked, change DW

If upper(gs_Project) = '3COM_NASH' or upper(gs_Project) = 'PANDORA' Then
	cbx_show.Checked = True
	If upper(gs_Project) = 'PANDORA' Then
		cbx_show.visible = false
	end if
Else
	cbx_show.Checked = False
End If

If cbx_show.Checked Then
	If upper(gs_Project) = 'PANDORA' Then
		//adds parameters for Owner and Inv Type
		dw_current.Dataobject = 'd_owner_change_avail_content_locs'
	else
		dw_current.Dataobject = 'd_putaway_recommend_by_owner'
	end if
	dw_current.SetTransObject(SQLCA)
	dw_current.GetChild('inventory_Type', ldwc)
	ldwc.SetTransobject(SQLCA)
	ldwc.Retrieve(gs_project)
End If

//	st_owner_cd.text = ""
	st_po_no.text = Istrparms.String_arg[8]


	If upper(gs_Project) = 'PANDORA' Then
		dw_current.Retrieve(Istrparms.String_arg[1],Istrparms.String_arg[2],Istrparms.String_arg[3],Istrparms.Decimal_arg[2],Istrparms.String_arg[6], Istrparms.String_arg[7],  Istrparms.String_arg[8])  //2nd from last Istrparms.Decimal_arg[3],
	else
		dw_current.Retrieve(Istrparms.String_arg[1],Istrparms.String_arg[2],Istrparms.String_arg[3])
	end if

st_sku.text = 'SKU: ' + Istrparms.String_arg[3]

//MessageBox ("ok", istrparms.decimal_arg[1])

st_total.Text = String(istrparms.decimal_arg[1],'#######.#####')

idRemain = 0

//If location already exists as passed in parm, default location and amount to that loc
//Otherwise, Set to first row where Qty is available and default Qty
If dw_current.RowCOunt() > 0 Then
	
	If Istrparms.String_arg[4] > '' and Istrparms.String_arg[4] <> '*' /*location already exists for this sku */ Then
		
		lsFind = "content_l_code = '" + Istrparms.String_arg[4] + "'"
		llFindRow = dw_current.Find(lsFind,1,dw_current.RowCOunt())
		If llFindRow > 0 Then /*exists in Current*/
			dw_current.SetItem(llFindRow,"c_putaway_amt",istrparms.Decimal_arg[1])
			
			dw_current.Setfocus()
			dw_current.Setrow(llFindRow)
			
		Else /*check in empty*/

			
		End If
		
	Else /*no current Loc for sku */
		
//		ldQTY = dw_current.GetItemNumber(1,"c_space_avail")
//		If ldQty > 0 Then
//			If ldQty >= istrparms.decimal_arg[1] /*amt to putaway*/ Then
//				dw_current.SetItem(1,"c_putaway_amt",istrparms.Decimal_arg[1])
//			End If
//		End If
	
		dw_current.Setfocus()
		dw_current.Setrow(1)
		
	End If /*loc exists ?? */
	
Else /*no rows exist in Current (no existing storage for SKU) */
	
		
End IF


integer li_find, li_loc_find
string ls_inv_type_desc, ls_content_l_code
decimal ld_quantity

DO 

	li_Find = dw_current.Find( "in_trans = 1", 1, dw_current.RowCount())
	
	IF li_Find > 0 THEN
	
		ls_inv_type_desc = dw_current.GetItemString( li_Find, "inv_type_desc")
		ls_content_l_code = 	dw_current.GetItemString( li_Find, "content_l_code")
		ld_quantity = 	dw_current.GetItemDecimal( li_Find, "avail_qty")
	
	
		li_loc_find = dw_current.Find("content_l_code='"+ls_content_l_code+"' AND inv_type_desc = '"+ls_inv_type_desc+"' AND in_trans = 0 ", 1, dw_current.RowCount())
	
		IF li_loc_find > 0 THEN
			
			dw_current.SetItem( li_loc_find, "c_putaway_amt", ld_quantity)
			
			dw_current.SetItem( li_loc_find, "avail_qty", ld_quantity + dw_current.GetItemNumber( li_loc_find, "avail_qty"))
			
			dw_current.DeleteRow(li_Find)
			
		ELSE	
			
			dw_current.SetItem( li_Find, "c_putaway_amt", ld_quantity)
			dw_current.SetItem( li_Find, "in_trans", 0)
			
			
			
			
		END IF
	
	
	END IF
	
LOOP UNTIL li_find = 0	

dw_current.SetRedraw(true)


This.TriggerEvent("ue_calc_remaining")
end event

event ue_calc_remaining();Long	llRowPos,	&
		llRowCount

Decimal	 ldQty, ld_work
//Calc the remaining putaway based on amounts entered

ldQty = 0

//Current
llRowCount = dw_current.RowCount()
If llRowCount > 0 Then
	for llRowPos = 1 to llRowCount
//		ldQty = ldQty + dw_current.GetItemNumber(llRowPos,"c_putaway_amt")

		// LTK 20110201  Add null check for case when user deletes value in amount column
		if IsNull(dw_current.GetItemNumber(llRowPos,"c_putaway_amt")) then
			ld_work = 0
		else
			ld_work = dw_current.GetItemNumber(llRowPos,"c_putaway_amt")
		end if
		
		ldQty = ldQty + ld_work

	Next
End If


idRemain = Istrparms.Decimal_arg[1] - ldQty
st_remain.text = String(idRemain,'#######.#####')

end event

event ue_clear();
//Reset amts to 0

Long	llRowPos,	&
		llRowCount

//Current
llRowCount = dw_current.RowCount()
If llRowCount > 0 Then
	for llRowPos = 1 to llRowCount
		dw_current.SetItem(llRowPos,"c_putaway_amt",0)
	Next
End If


This.TriggerEvent("ue_calc_remaining")



end event

on w_owner_change_recommend.create
this.sle_pallet=create sle_pallet
this.cb_allocate_pallet=create cb_allocate_pallet
this.cb_2=create cb_2
this.st_owner_cd=create st_owner_cd
this.st_po_no=create st_po_no
this.st_5=create st_5
this.st_4=create st_4
this.cb_1=create cb_1
this.dw_current=create dw_current
this.cbx_show=create cbx_show
this.st_remain=create st_remain
this.st_total=create st_total
this.st_2=create st_2
this.st_3=create st_3
this.st_1=create st_1
this.st_sku=create st_sku
this.cb_clear=create cb_clear
this.cb_ok=create cb_ok
this.Control[]={this.sle_pallet,&
this.cb_allocate_pallet,&
this.cb_2,&
this.st_owner_cd,&
this.st_po_no,&
this.st_5,&
this.st_4,&
this.cb_1,&
this.dw_current,&
this.cbx_show,&
this.st_remain,&
this.st_total,&
this.st_2,&
this.st_3,&
this.st_1,&
this.st_sku,&
this.cb_clear,&
this.cb_ok}
end on

on w_owner_change_recommend.destroy
destroy(this.sle_pallet)
destroy(this.cb_allocate_pallet)
destroy(this.cb_2)
destroy(this.st_owner_cd)
destroy(this.st_po_no)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.dw_current)
destroy(this.cbx_show)
destroy(this.st_remain)
destroy(this.st_total)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.st_sku)
destroy(this.cb_clear)
destroy(this.cb_ok)
end on

event open;
dw_current.SetRedraw(false)

istrparms = message.PowerobjectParm
iwCurrent = This

This.PostEvent("ue_postOpen")

end event

event closequery;// 11/02 - PConkl - QTY fields changed to Decimal

if ib_cancel = true then return 0

str_parms	lstrparms

Long	llRowCount,	&
		llRowPos,	&
		llArrayPos
		
Decimal	ldQty
		
llArrayPos = 0
ldQty = 0

dw_current.AcceptText()


//Return array of locations and amts for this sku

//Current
llRowCount = dw_current.RowCount()
If llRowCount > 0 Then
	For llRowpos = 1 to llRowCount
		If	dw_current.GetItemNumber(llRowPos,"c_putaway_amt") > 0 Then
			llArrayPos++
			lstrparms.String_arg[llArrayPos] = dw_current.GetItemString(llRowPos,"content_l_code")

			lstrparms.Decimal_arg[llArrayPos] = dw_current.GetItemNumber(llRowPos,"c_putaway_amt")

			// LTK 20101228  SOC add lot_no change
			lstrparms.String_arg_2[llArrayPos] = dw_current.GetItemString(llRowPos,"lot_no")

//			lstrparms.string_arg_4[llArrayPos] = dw_current.GetItemString(llRowPos,"container_id")


			ldQty += dw_current.GetItemNumber(llRowPos,"c_putaway_amt")
		End If			
	Next
End If /*current rows exist*/

//// Cant putway more than on order!
//If ldQty > istrparms.Decimal_arg[1] Then
//	messagebox("Validation Error","You can not Put Away more than " + string(Istrparms.decimal_arg[1]) + " Units!")
//	tab_1.tabpage_current.dw_current.SetFocus()
//	Return 1
//Else
//	Message.PowerobjectParm = Lstrparms
//	Return 0
//End If



// LTK 20110127 SOC Enhancements
// Returning the entire datawindow via the datastore in the parms structure.
// An intermediate step was needed because of the datawindow scope
lstrparms.datastore_arg[1] = istrparms.datastore_arg[1]


lstrparms.boolean_arg[1] = true

Message.PowerobjectParm = Lstrparms
Return 0

end event

type sle_pallet from singlelineedit within w_owner_change_recommend
integer x = 40
integer y = 1472
integer width = 603
integer height = 99
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_allocate_pallet from commandbutton within w_owner_change_recommend
integer x = 40
integer y = 1370
integer width = 410
integer height = 93
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Allocate Pallet:"
end type

event clicked;//note - this started as a copy of the 'Allocate All' code...
integer li_idx, li_st_total
decimal ld_avail_qty
string ls_Pallet, ls_CurPallet

// 2014-05-08 li_st_total = long(st_total.text)
li_st_total = long(st_remain.text)
ls_Pallet = sle_pallet.text
if ls_pallet = '' then
	messagebox("Owner Change", "You must enter a Pallet ID to allocate a Pallet.")
	return 0
end if

for li_idx = 1 to dw_current.RowCount()
	if li_st_total > 0 then
		ld_avail_qty = dw_current.GetItemDecimal( li_idx, "avail_qty")
		ls_CurPallet = dw_current.GetItemString( li_idx, "po_no2")
		if ls_CurPallet = ls_Pallet then
			if li_st_total >= ld_avail_qty then
				dw_current.SetItem( li_idx, "c_putaway_amt", ld_avail_qty)
				li_st_total = li_st_total - ld_avail_qty
			else
				dw_current.SetItem( li_idx, "c_putaway_amt", li_st_total)
				li_st_total = 0
			end if
		end if
	end if
next
st_remain.text = string(li_st_total)
sle_pallet.SetFocus()
sle_pallet.SelectText(1, Len(sle_pallet.Text))
if li_st_total = long(st_total.text) then
	messagebox("Owner Change", "Pallet ID Not found.")
end if

end event

type cb_2 from commandbutton within w_owner_change_recommend
integer x = 37
integer y = 1226
integer width = 402
integer height = 93
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Allocate All"
end type

event clicked;
integer li_idx

integer li_st_total

li_st_total = long(st_total.text)

decimal ld_avail_qty

for li_idx = 1 to dw_current.RowCount()
	
	if li_st_total > 0 then
	
		ld_avail_qty = dw_current.GetItemDecimal( li_idx, "avail_qty")
		
		if li_st_total >= ld_avail_qty then
			
			dw_current.SetItem( li_idx, "c_putaway_amt", ld_avail_qty)

			li_st_total = li_st_total - ld_avail_qty
			
		else
		
			dw_current.SetItem( li_idx, "c_putaway_amt", li_st_total)
	
			li_st_total = 0
			
	
		end if
			

	
	end if
	
next
end event

type st_owner_cd from statictext within w_owner_change_recommend
integer x = 2271
integer y = 16
integer width = 581
integer height = 77
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type st_po_no from statictext within w_owner_change_recommend
integer x = 2271
integer y = 90
integer width = 581
integer height = 77
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type st_5 from statictext within w_owner_change_recommend
boolean visible = false
integer x = 1997
integer y = 16
integer width = 271
integer height = 51
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
string text = "Owner CD::"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_owner_change_recommend
integer x = 1997
integer y = 90
integer width = 252
integer height = 77
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
string text = "PO NO:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_owner_change_recommend
integer x = 1360
integer y = 1226
integer width = 344
integer height = 93
integer taborder = 40
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
ib_cancel = true

Close(parent)


end event

type dw_current from u_dw_ancestor within w_owner_change_recommend
integer x = 26
integer y = 195
integer width = 4458
integer height = 912
integer taborder = 50
string dataobject = "d_owner_change_avail_content_locs"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;
//recalc remaining putaway
if dwo.name = "c_putaway_amt" Then
	iwCurrent.PostEvent("ue_calc_remaining")
	
	// LTK 20110201	New SOC business rule, if inventory is being cycle counted (content.inventory_type = '*'), 
	// do not allow the row to be used in the SOC.
	if Trim(this.Object.inventory_type[row]) = "*" then
		MessageBox ("Error", "Cannot select this SKU because it is being cylce counted!")
		ib_display_cc_error_msg = true
		return 1
	end if
	
End If

end event

event sqlpreview;call super::sqlpreview;
// ("sqal", sqlsyntax )


end event

event itemerror;call super::itemerror;if ib_display_cc_error_msg then
	// Show unique cycle count error message when appropriate, else let the generic PowerBuilder message display.
	ib_display_cc_error_msg = false
	return 1
else
	return 0
end if

end event

type cbx_show from checkbox within w_owner_change_recommend
integer x = 1872
integer y = 1210
integer width = 713
integer height = 74
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show Owner/Inv. Type"
end type

event clicked;DatawindowChild	ldwc

If This.Checked Then
	dw_current.Dataobject = 'd_putaway_recommend_by_owner'
	dw_current.GetChild('inventory_Type', ldwc)
	ldwc.SetTransobject(SQLCA)
	ldwc.Retrieve(gs_project)
Else
	dw_current.Dataobject = 'd_putaway_recommend'
End If

dw_current.SetTransObject(SQLCA)

dw_current.Retrieve(Istrparms.String_arg[1],Istrparms.String_arg[2],Istrparms.String_arg[3])
end event

type st_remain from statictext within w_owner_change_recommend
integer x = 1156
integer y = 90
integer width = 581
integer height = 77
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type st_total from statictext within w_owner_change_recommend
integer x = 1156
integer y = 16
integer width = 581
integer height = 77
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type st_2 from statictext within w_owner_change_recommend
integer x = 881
integer y = 90
integer width = 252
integer height = 77
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
string text = "Remaining:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_owner_change_recommend
integer x = 881
integer y = 16
integer width = 252
integer height = 77
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
string text = "Total:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_owner_change_recommend
integer x = 578
integer y = 35
integer width = 256
integer height = 77
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
string text = "Quantity:"
boolean focusrectangle = false
end type

type st_sku from statictext within w_owner_change_recommend
integer x = 4
integer y = 3
integer width = 545
integer height = 112
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Sku:"
boolean focusrectangle = false
end type

type cb_clear from commandbutton within w_owner_change_recommend
integer x = 1002
integer y = 1226
integer width = 230
integer height = 93
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reset"
end type

event clicked;
Parent.TriggerEvent("ue_postopen")
end event

type cb_ok from commandbutton within w_owner_change_recommend
integer x = 688
integer y = 1226
integer width = 187
integer height = 93
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;
integer li_quantity, li_idx
long ll_c_putaway_amt, ll_avail_qty

IF dw_current.AcceptText() <> 1 THEN return -1


for li_idx =1 to dw_current.Rowcount()

	ll_c_putaway_amt = dw_current.GetItemNumber(li_idx, "c_putaway_amt")
	
	IF IsNull(ll_c_putaway_amt) THEN ll_c_putaway_amt = 0
	
	IF ll_c_putaway_amt > 0 THEN
		
		ll_avail_qty = dw_current.GetItemNumber(li_idx, "avail_qty")
		
		IF IsNull(ll_avail_qty) THEN ll_avail_qty = 0
		
		IF ll_c_putaway_amt > ll_avail_qty THEN
			
			MessageBox ("Error", "You are trying to use more than what is available.")
			dw_current.ScrollToRow(li_idx)			
			dw_current.SetFocus()
			RETURN -1
			
		END IF
		
	END IF

next 



parent.TriggerEvent ("ue_calc_remaining")

li_quantity = integer(st_remain.text)

IF li_quantity <> 0 THEN
	
	MessageBox ("Error", "Quantity Remaining is not 0.")
	RETURN -1
	
END IF


// LTK 20110127 SOC Enhancements
// Returning the entire datawindow via the datastore in the parms structure
istrparms.datastore_arg[1] = create Datastore
istrparms.datastore_arg[1].dataObject = 'd_owner_change_avail_content_locs'
dw_current.RowsCopy(1, dw_current.RowCount(), Primary!, istrparms.datastore_arg[1], 1, Primary!)

Close(parent)


end event

