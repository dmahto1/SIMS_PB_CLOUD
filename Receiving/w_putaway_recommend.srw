HA$PBExportHeader$w_putaway_recommend.srw
$PBExportComments$*Recomendations for SKU putaway locations
forward
global type w_putaway_recommend from window
end type
type st_put_recommdend_sku from statictext within w_putaway_recommend
end type
type cbx_show from checkbox within w_putaway_recommend
end type
type cb_put_recommend_help from commandbutton within w_putaway_recommend
end type
type st_remain from statictext within w_putaway_recommend
end type
type st_total from statictext within w_putaway_recommend
end type
type st_remaining_text from statictext within w_putaway_recommend
end type
type st_total_text from statictext within w_putaway_recommend
end type
type st_putaway_text from statictext within w_putaway_recommend
end type
type tab_1 from tab within w_putaway_recommend
end type
type tabpage_current from userobject within tab_1
end type
type dw_current from u_dw_ancestor within tabpage_current
end type
type tabpage_current from userobject within tab_1
dw_current dw_current
end type
type tabpage_empty from userobject within tab_1
end type
type dw_empty from u_dw_ancestor within tabpage_empty
end type
type tabpage_empty from userobject within tab_1
dw_empty dw_empty
end type
type tab_1 from tab within w_putaway_recommend
tabpage_current tabpage_current
tabpage_empty tabpage_empty
end type
type st_sku from statictext within w_putaway_recommend
end type
type cb_put_recommend_clear from commandbutton within w_putaway_recommend
end type
type cb_put_recommend_ok from commandbutton within w_putaway_recommend
end type
end forward

global type w_putaway_recommend from window
integer x = 823
integer y = 360
integer width = 2871
integer height = 1492
boolean titlebar = true
string title = "Putaway recommendations"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
event ue_postopen ( )
event ue_calc_remaining ( )
event ue_clear ( )
st_put_recommdend_sku st_put_recommdend_sku
cbx_show cbx_show
cb_put_recommend_help cb_put_recommend_help
st_remain st_remain
st_total st_total
st_remaining_text st_remaining_text
st_total_text st_total_text
st_putaway_text st_putaway_text
tab_1 tab_1
st_sku st_sku
cb_put_recommend_clear cb_put_recommend_clear
cb_put_recommend_ok cb_put_recommend_ok
end type
global w_putaway_recommend w_putaway_recommend

type variables
str_parms	istrparms
Decimal	idRemain
Window	iwCurrent

end variables

event ue_postopen();// 11/02 - PConkl - Qty Changed to Decimal

Long					llFindRow
Decimal				ldQty
String				lsFind
datawindowChild	ldwc
Boolean lb_gpn_serial_track_locs	// LTK 20151214  Pandora #1002
String ls_oracle_integrated, ls_owner_cd	// LTK 20151229  Pandora #1002

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
		//tab_1.tabpage_current.dw_current.Dataobject = 'd_putaway_recommend_pandora'
		// LTK 20151214  Pandora #1002 SOC and GPN serial tracked inventory segregation
		lb_gpn_serial_track_locs = ( f_retrieve_parm("PANDORA", "FLAG", "SOC_SERIAL_GPN_TRACK_ON") = 'Y' ) and &
			( Istrparms.String_arg[8] = 'B' or Istrparms.String_arg[8] = 'Y' or Istrparms.String_arg[8] = 'O' )

		// LTK 20151229  Pandora #1002  Add the Customer Oracle Integrated check
		if lb_gpn_serial_track_locs then

			lb_gpn_serial_track_locs = FALSE	// need to check 2 more indicators below

			ls_owner_cd = Istrparms.String_arg[9]

			if NOT IsNull( ls_owner_cd ) then		// shouldn't be null but let's check

				SELECT user_field5
				INTO :ls_oracle_integrated
				FROM Customer
				WHERE Project_ID = :gs_project
				AND Cust_Code = :ls_owner_cd
				USING SQLCA;

				if Upper( Trim( ls_oracle_integrated )) = 'Y' then
					// Customer is Oracle Integrated

					// Check the PND Serial indicator to determine if this rule is exercised
					if Upper( Trim( Istrparms.String_arg[8] )) = 'N' then
						// Skip this rule
					else
						lb_gpn_serial_track_locs = TRUE
					end if					
				end if
			end if
		end if

		if  lb_gpn_serial_track_locs then
			// adds po_no as a retrieval parameter
			tab_1.tabpage_current.dw_current.Dataobject = 'd_putaway_recommend_pandora_gpn'	
		else
			tab_1.tabpage_current.dw_current.Dataobject = 'd_putaway_recommend_pandora'
		end if
	else
		tab_1.tabpage_current.dw_current.Dataobject = 'd_putaway_recommend_by_owner'
	end if
	tab_1.tabpage_current.dw_current.SetTransObject(SQLCA)
	tab_1.tabpage_current.dw_current.GetChild('inventory_Type', ldwc)
	ldwc.SetTransobject(SQLCA)
	ldwc.Retrieve(gs_project)
End If

	If upper(gs_Project) = 'PANDORA' Then
		//tab_1.tabpage_current.dw_current.Retrieve(Istrparms.String_arg[1],Istrparms.String_arg[2],Istrparms.String_arg[3],Istrparms.Decimal_arg[2],Istrparms.String_arg[6])
		// LTK 20151214  Pandora #1002 SOC and GPN serial tracked inventory segregation
		if lb_gpn_serial_track_locs then
			tab_1.tabpage_current.dw_current.Retrieve(Istrparms.String_arg[1],Istrparms.String_arg[2],Istrparms.String_arg[3],Istrparms.Decimal_arg[2],Istrparms.String_arg[6], Istrparms.String_arg[7])
		else
			tab_1.tabpage_current.dw_current.Retrieve(Istrparms.String_arg[1],Istrparms.String_arg[2],Istrparms.String_arg[3],Istrparms.Decimal_arg[2],Istrparms.String_arg[6])			
		end if

	else
		tab_1.tabpage_current.dw_current.Retrieve(Istrparms.String_arg[1],Istrparms.String_arg[2],Istrparms.String_arg[3])
	end if

st_sku.text =  Istrparms.String_arg[3]

st_total.Text = String(istrparms.decimal_arg[1],'#######.#####')

idRemain = 0

//If location already exists as passed in parm, default location and amount to that loc
//Otherwise, Set to first row where Qty is available and default Qty
If tab_1.tabpage_current.dw_current.RowCOunt() > 0 Then
	
	If Istrparms.String_arg[4] > '' and Istrparms.String_arg[4] <> '*' /*location already exists for this sku */ Then
		
		lsFind = "content_l_code = '" + Istrparms.String_arg[4] + "'"
		llFindRow = tab_1.tabpage_current.dw_current.Find(lsFind,1,tab_1.tabpage_current.dw_current.RowCOunt())
		If llFindRow > 0 Then /*exists in Current*/
			tab_1.tabpage_current.dw_current.SetItem(llFindRow,"c_putaway_amt",istrparms.Decimal_arg[1])
			
			tab_1.tabpage_current.dw_current.Setfocus()
			tab_1.tabpage_current.dw_current.Setrow(llFindRow)
			
		Else /*check in empty*/
			
			tab_1.SelectTab(2) /*display second tab*/
			If tab_1.tabpage_empty.dw_empty.RowCount() = 0 Then
// Trey McClanahan - Added SKU as Parm to allow retrieval based on SKU_RESERVED = putaway_sku or SKU_RESERVED = null
				tab_1.tabpage_empty.dw_empty.Retrieve(Istrparms.String_arg[2],gs_project,Istrparms.String_arg[5],Istrparms.String_arg[3])
			End If
			
			lsFind = "location_l_code = '" + Istrparms.String_arg[4] + "'"
			llFindRow = tab_1.tabpage_empty.dw_empty.Find(lsFind,1,tab_1.tabpage_empty.dw_empty.RowCOunt())
			If llFindRow > 0 Then
				tab_1.tabpage_empty.dw_empty.SetItem(llFindRow,"c_putaway_amt",istrparms.Decimal_arg[1])
				tab_1.tabpage_empty.dw_empty.Setfocus()
				tab_1.tabpage_empty.dw_empty.Setrow(llFindRow)
			End If
			
		End If
		
	Else /*no current Loc for sku */
		
		ldQTY = tab_1.tabpage_current.dw_current.GetItemNumber(1,"c_space_avail")
		If ldQty > 0 Then
			If ldQty >= istrparms.decimal_arg[1] /*amt to putaway*/ Then
				tab_1.tabpage_current.dw_current.SetItem(1,"c_putaway_amt",istrparms.Decimal_arg[1])
			End If
		End If
	
		tab_1.tabpage_current.dw_current.Setfocus()
		tab_1.tabpage_current.dw_current.Setrow(1)
		
	End If /*loc exists ?? */
	
Else /*no rows exist in Current (no existing storage for SKU) */
	
	tab_1.SelectTab(2) /*display second tab*/
	If tab_1.tabpage_empty.dw_empty.RowCount() = 0 Then
// Trey McClanahan - Added SKU as Parm to allow retrieval based on SKU_RESERVED = putaway_sku or SKU_RESERVED = null
		tab_1.tabpage_empty.dw_empty.Retrieve(Istrparms.String_arg[2],gs_project,Istrparms.String_arg[5],Istrparms.String_arg[3])
	End If
	
	If tab_1.tabpage_empty.dw_empty.RowCount() > 0 Then
		
		If Istrparms.String_arg[4] > '' /*location already exists for this sku */ Then
	
			lsFind = "location_l_code = '" + Istrparms.String_arg[4] + "'"
			llFindRow = tab_1.tabpage_empty.dw_empty.Find(lsFind,1,tab_1.tabpage_empty.dw_empty.RowCOunt())
			If llFindRow > 0 Then
				tab_1.tabpage_empty.dw_empty.SetItem(llFindRow,"c_putaway_amt",istrparms.Decimal_arg[1])
				tab_1.tabpage_empty.dw_empty.Setfocus()
				tab_1.tabpage_empty.dw_empty.Setrow(llFindRow)
			End If
		
		Else /*no current loc*/
		
			tab_1.tabpage_empty.dw_empty.SetItem(1,"c_putaway_amt",istrparms.Decimal_arg[1])
			tab_1.tabpage_empty.dw_empty.Setfocus()
			tab_1.tabpage_empty.dw_empty.Setrow(1)
		
		End If
		
	End If /*rows on empty*/
		
End IF


This.TriggerEvent("ue_calc_remaining")
end event

event ue_calc_remaining;Long	llRowPos,	&
		llRowCount

Decimal	 ldQty
//Calc the remaining putaway based on amounts entered

ldQty = 0

//Current
llRowCount = tab_1.tabpage_current.dw_current.RowCount()
If llRowCount > 0 Then
	for llRowPos = 1 to llRowCount
		ldQty = ldQty + tab_1.tabpage_current.dw_current.GetItemNumber(llRowPos,"c_putaway_amt")
	Next
End If

//Empty
llRowCount = tab_1.tabpage_empty.dw_empty.RowCount()
If llRowCount > 0 Then
	for llRowPos = 1 to llRowCount
		ldQty = ldQty + tab_1.tabpage_empty.dw_empty.GetItemNumber(llRowPos,"c_putaway_amt")
	Next
End If

idRemain = Istrparms.Decimal_arg[1] - ldQty
st_remain.text = String(idRemain,'#######.#####')

end event

event ue_clear;
//Reset amts to 0

Long	llRowPos,	&
		llRowCount

//Current
llRowCount = tab_1.tabpage_current.dw_current.RowCount()
If llRowCount > 0 Then
	for llRowPos = 1 to llRowCount
		tab_1.tabpage_current.dw_current.SetItem(llRowPos,"c_putaway_amt",0)
	Next
End If

//Empty
llRowCount = tab_1.tabpage_empty.dw_empty.RowCount()
If llRowCount > 0 Then
	for llRowPos = 1 to llRowCount
		tab_1.tabpage_empty.dw_empty.SetItem(llRowPos,"c_putaway_amt",0)
	Next
End If

This.TriggerEvent("ue_calc_remaining")



end event

on w_putaway_recommend.create
this.st_put_recommdend_sku=create st_put_recommdend_sku
this.cbx_show=create cbx_show
this.cb_put_recommend_help=create cb_put_recommend_help
this.st_remain=create st_remain
this.st_total=create st_total
this.st_remaining_text=create st_remaining_text
this.st_total_text=create st_total_text
this.st_putaway_text=create st_putaway_text
this.tab_1=create tab_1
this.st_sku=create st_sku
this.cb_put_recommend_clear=create cb_put_recommend_clear
this.cb_put_recommend_ok=create cb_put_recommend_ok
this.Control[]={this.st_put_recommdend_sku,&
this.cbx_show,&
this.cb_put_recommend_help,&
this.st_remain,&
this.st_total,&
this.st_remaining_text,&
this.st_total_text,&
this.st_putaway_text,&
this.tab_1,&
this.st_sku,&
this.cb_put_recommend_clear,&
this.cb_put_recommend_ok}
end on

on w_putaway_recommend.destroy
destroy(this.st_put_recommdend_sku)
destroy(this.cbx_show)
destroy(this.cb_put_recommend_help)
destroy(this.st_remain)
destroy(this.st_total)
destroy(this.st_remaining_text)
destroy(this.st_total_text)
destroy(this.st_putaway_text)
destroy(this.tab_1)
destroy(this.st_sku)
destroy(this.cb_put_recommend_clear)
destroy(this.cb_put_recommend_ok)
end on

event open;
istrparms = message.PowerobjectParm
iwCurrent = This

This.PostEvent("ue_postOpen")

end event

event closequery;// 11/02 - PConkl - QTY fields changed to Decimal

str_parms	lstrparms

Long	llRowCount,	&
		llRowPos,	&
		llArrayPos
		
Decimal	ldQty
		
llArrayPos = 0
ldQty = 0

tab_1.tabpage_current.dw_current.AcceptText()
tab_1.tabpage_empty.dw_empty.AcceptText()

//Return array of locations and amts for this sku

//Current
llRowCount = tab_1.tabpage_current.dw_current.RowCount()
If llRowCount > 0 Then
	For llRowpos = 1 to llRowCount
		If	tab_1.tabpage_current.dw_current.GetItemNumber(llRowPos,"c_putaway_amt") > 0 Then
			llArrayPos++
			lstrparms.String_arg[llArrayPos] = tab_1.tabpage_current.dw_current.GetItemString(llRowPos,"content_l_code")
			lstrparms.Decimal_arg[llArrayPos] = tab_1.tabpage_current.dw_current.GetItemNumber(llRowPos,"c_putaway_amt")
			ldQty += tab_1.tabpage_current.dw_current.GetItemNumber(llRowPos,"c_putaway_amt")
		End If			
	Next
End If /*current rows exist*/

//Empty
llRowCount = tab_1.tabpage_Empty.dw_Empty.RowCount()
If llRowCount > 0 Then
	For llRowpos = 1 to llRowCount
		If	tab_1.tabpage_Empty.dw_Empty.GetItemNumber(llRowPos,"c_putaway_amt") > 0 Then
			llArrayPos++
			lstrparms.String_arg[llArrayPos] = tab_1.tabpage_Empty.dw_Empty.GetItemString(llRowPos,"location_l_code")
			lstrparms.Decimal_arg[llArrayPos] = tab_1.tabpage_Empty.dw_Empty.GetItemNumber(llRowPos,"c_putaway_amt")
			ldQty +=tab_1.tabpage_Empty.dw_Empty.GetItemNumber(llRowPos,"c_putaway_amt")
		End If			
	Next
End If /*Empty rows exist*/

//// Cant putway more than on order!
//If ldQty > istrparms.Decimal_arg[1] Then
//	messagebox("Validation Error","You can not Put Away more than " + string(Istrparms.decimal_arg[1]) + " Units!")
//	tab_1.tabpage_current.dw_current.SetFocus()
//	Return 1
//Else
//	Message.PowerobjectParm = Lstrparms
//	Return 0
//End If

Message.PowerobjectParm = Lstrparms
Return 0

end event

type st_put_recommdend_sku from statictext within w_putaway_recommend
integer y = 4
integer width = 133
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SKU:"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type cbx_show from checkbox within w_putaway_recommend
integer x = 1833
integer y = 28
integer width = 713
integer height = 72
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
	tab_1.tabpage_current.dw_current.Dataobject = 'd_putaway_recommend_by_owner'
	g.of_check_label(tab_1.tabpage_current.dw_current) 
	tab_1.tabpage_current.dw_current.GetChild('inventory_Type', ldwc)
	ldwc.SetTransobject(SQLCA)
	ldwc.Retrieve(gs_project)
Else
	tab_1.tabpage_current.dw_current.Dataobject = 'd_putaway_recommend'
	g.of_check_label(tab_1.tabpage_current.dw_current) 
End If

tab_1.tabpage_current.dw_current.SetTransObject(SQLCA)

tab_1.tabpage_current.dw_current.Retrieve(Istrparms.String_arg[1],Istrparms.String_arg[2],Istrparms.String_arg[3])
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_put_recommend_help from commandbutton within w_putaway_recommend
integer x = 1330
integer y = 1224
integer width = 215
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Help"
end type

event clicked;
ShowHelp(g.is_helpfile,topic!,549)
end event

event constructor;
g.of_check_label_button(this)
end event

type st_remain from statictext within w_putaway_recommend
integer x = 1157
integer y = 72
integer width = 581
integer height = 76
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

type st_total from statictext within w_putaway_recommend
integer x = 1157
integer y = 16
integer width = 581
integer height = 76
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

type st_remaining_text from statictext within w_putaway_recommend
integer x = 882
integer y = 72
integer width = 251
integer height = 76
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

event constructor;
g.of_check_label_button(this)
end event

type st_total_text from statictext within w_putaway_recommend
integer x = 882
integer y = 16
integer width = 251
integer height = 76
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

event constructor;g.of_check_label_button(this)
end event

type st_putaway_text from statictext within w_putaway_recommend
integer x = 594
integer y = 36
integer width = 256
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
string text = "Put Away:"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type tab_1 from tab within w_putaway_recommend
event create ( )
event destroy ( )
integer x = 18
integer y = 132
integer width = 2821
integer height = 1052
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
integer selectedtab = 1
tabpage_current tabpage_current
tabpage_empty tabpage_empty
end type

on tab_1.create
this.tabpage_current=create tabpage_current
this.tabpage_empty=create tabpage_empty
this.Control[]={this.tabpage_current,&
this.tabpage_empty}
end on

on tab_1.destroy
destroy(this.tabpage_current)
destroy(this.tabpage_empty)
end on

event selectionchanged;
//Only retrieve empty if selecting tab
If newindex = 2 Then
	If tabpage_empty.dw_empty.RowCount() = 0 THen
		tabpage_empty.dw_empty.Retrieve(Istrparms.String_arg[2],gs_project,Istrparms.String_arg[5],Istrparms.String_arg[3])
	End If
End If
end event

type tabpage_current from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 2784
integer height = 932
long backcolor = 79741120
string text = "Current ~r~n"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_current dw_current
end type

on tabpage_current.create
this.dw_current=create dw_current
this.Control[]={this.dw_current}
end on

on tabpage_current.destroy
destroy(this.dw_current)
end on

type dw_current from u_dw_ancestor within tabpage_current
integer y = 4
integer width = 2775
integer height = 912
integer taborder = 20
string dataobject = "d_putaway_recommend"
boolean vscrollbar = true
end type

event itemchanged;
//recalc remaining putaway
if dwo.name = "c_putaway_amt" Then
	iwCurrent.PostEvent("ue_calc_remaining")
End If
end event

event sqlpreview;call super::sqlpreview;
// ("sqal", sqlsyntax )
end event

type tabpage_empty from userobject within tab_1
integer x = 18
integer y = 104
integer width = 2784
integer height = 932
long backcolor = 79741120
string text = "Empty"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_empty dw_empty
end type

on tabpage_empty.create
this.dw_empty=create dw_empty
this.Control[]={this.dw_empty}
end on

on tabpage_empty.destroy
destroy(this.dw_empty)
end on

type dw_empty from u_dw_ancestor within tabpage_empty
integer width = 2775
integer height = 916
integer taborder = 20
string dataobject = "d_putaway_avail"
boolean vscrollbar = true
end type

event itemchanged;
//recalc remaining putaway
if dwo.name = "c_putaway_amt" Then
	iwCurrent.PostEvent("ue_calc_remaining")
End If
end event

type st_sku from statictext within w_putaway_recommend
integer x = 146
integer y = 4
integer width = 421
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
boolean focusrectangle = false
end type

type cb_put_recommend_clear from commandbutton within w_putaway_recommend
integer x = 937
integer y = 1224
integer width = 215
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;
Parent.TriggerEvent("ue_clear")
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_put_recommend_ok from commandbutton within w_putaway_recommend
integer x = 686
integer y = 1224
integer width = 187
integer height = 92
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

event clicked;close(parent)
end event

event constructor;
g.of_check_label_button(this)
end event

