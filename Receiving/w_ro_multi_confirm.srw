HA$PBExportHeader$w_ro_multi_confirm.srw
$PBExportComments$Multiple receive order confirmations
forward
global type w_ro_multi_confirm from window
end type
type dw_print from u_dw_ancestor within w_ro_multi_confirm
end type
type cb_print from commandbutton within w_ro_multi_confirm
end type
type st_row_count from statictext within w_ro_multi_confirm
end type
type hpb_confirm from hprogressbar within w_ro_multi_confirm
end type
type ddlb_loc_code from dropdownlistbox within w_ro_multi_confirm
end type
type st_sub_inv_locs from statictext within w_ro_multi_confirm
end type
type st_l_code from statictext within w_ro_multi_confirm
end type
type sle_sub_inv_loc from singlelineedit within w_ro_multi_confirm
end type
type st_results from statictext within w_ro_multi_confirm
end type
type mle_results from multilineedit within w_ro_multi_confirm
end type
type cb_confirm from commandbutton within w_ro_multi_confirm
end type
type dw_receive_orders from u_dw_ancestor within w_ro_multi_confirm
end type
type st_orderno from statictext within w_ro_multi_confirm
end type
type sle_orderno from singlelineedit within w_ro_multi_confirm
end type
type gb_batch_confirm_id from groupbox within w_ro_multi_confirm
end type
type st_batch_confirm_id from statictext within w_ro_multi_confirm
end type
end forward

global type w_ro_multi_confirm from window
integer width = 3867
integer height = 2272
boolean titlebar = true
string title = "Multi-Confirm Receiving Order"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_print dw_print
cb_print cb_print
st_row_count st_row_count
hpb_confirm hpb_confirm
ddlb_loc_code ddlb_loc_code
st_sub_inv_locs st_sub_inv_locs
st_l_code st_l_code
sle_sub_inv_loc sle_sub_inv_loc
st_results st_results
mle_results mle_results
cb_confirm cb_confirm
dw_receive_orders dw_receive_orders
st_orderno st_orderno
sle_orderno sle_orderno
gb_batch_confirm_id gb_batch_confirm_id
st_batch_confirm_id st_batch_confirm_id
end type
global w_ro_multi_confirm w_ro_multi_confirm

type variables
String is_wh_code
boolean ib_find_loc_mode
datawindowchild idwc_coo
end variables

forward prototypes
public subroutine wf_enable_loc_controls (boolean ab_enabled)
public function boolean wf_validate_sub_inv_loc ()
public function string wf_get_batch_details (boolean ab_include_results)
public function long wf_populate_locations ()
public function boolean wf_validate_location ()
end prototypes

public subroutine wf_enable_loc_controls (boolean ab_enabled);ddlb_loc_code.enabled = ab_enabled

if ab_enabled = FALSE then
	sle_sub_inv_loc.text = ""
	ddlb_loc_code.text = ""
end if
end subroutine

public function boolean wf_validate_sub_inv_loc ();String ls_cust_code, ls_wh_code
long ll_count
boolean lb_return

ls_cust_code = Upper(Trim(sle_sub_inv_loc.Text))
ls_wh_code = dw_receive_orders.Object.wh_code[1]

SELECT  count(*)
INTO :ll_count
FROM customer
Where project_id = :gs_project
AND user_field2 = :ls_wh_code
AND ( NOT customer_type = 'IN') 
AND cust_code = :ls_cust_code;

if ll_count > 0 then
	// Customer found
	lb_return = true
else
	MessageBox(w_ro_multi_confirm.title, "Invalid Sub-Inv Loc.  Please enter a valid one.")
	sle_sub_inv_loc.SelectText(1, Len(sle_sub_inv_loc.Text))
end if

return lb_return
end function

public function string wf_get_batch_details (boolean ab_include_results);String ls_return
long i

for i = 1 to dw_receive_orders.RowCount()
	ls_return += nz(dw_receive_orders.Object.supp_invoice_no[ i ], "")
	if ab_include_results then
		ls_return += ': results=' + nz(dw_receive_orders.Object.confirm_results[ i ], "")
	end if
	ls_return += ', '
next
ls_return = 'l_code=' + ddlb_loc_code.text + '  sub-inv loc=' + sle_sub_inv_loc.text + ' orders=[ ' + ls_return + ']'

if ab_include_results then
	if Len(Trim(mle_results.text)) > 0 then
		ls_return += ', UI Putaway/Confirm Errors=' + nz(mle_results.text, "")
	end if
end if

return ls_return
end function

public function long wf_populate_locations ();long ll_rows

if dw_receive_orders.RowCount() > 0 then
	ib_find_loc_mode = TRUE

	if is_wh_code = dw_receive_orders.Object.wh_code[1] and ddlb_loc_code.totalitems( ) > 0 then
		// Already retrieved this warehouse
	else
		is_wh_code = dw_receive_orders.Object.wh_code[1]

		String ls_wh_code
		long i

		w_main.SetMicroHelp("Retrieving locations...")
		ls_wh_code = dw_receive_orders.Object.wh_code[1]
		
		datastore lds_locs
		lds_locs = CREATE datastore;
		lds_locs.dataobject = "d_putaway_avail"
		lds_locs.SetTransObject(SQLCA)

		ll_rows = lds_locs.Retrieve(dw_receive_orders.Object.wh_code[1], gs_project, 'NOTUSED', dw_receive_orders.Object.sku[1])

		w_main.SetMicroHelp("Ready")

		for i = 1 to ll_rows
			ddlb_loc_code.AddItem(lds_locs.Object.location_l_code[i])
		next

		if ll_rows = 0 then
			MessageBox(this.title, "No empty locations found for warehouse:  " + is_wh_code)
		end if

		return ll_rows

	end if	
else
	MessageBox(this.title, "First, please add an order number.")
	sle_orderno.SetFocus()
end if

return ll_rows
end function

public function boolean wf_validate_location ();// Code below copied from w_ro.idw_putaway.itemChanged() event


String ls_l_code, lsProject, ls_LocType, lsWarehouse, lsInvTyp, lsSKU, lsFind
long llOwnerID, row, llFindRow

row = 1	// already validated only one detail row order
ls_l_code = ddlb_loc_code.text

lsWarehouse = w_ro.idw_main.GetItemString(1,"wh_code")
Select project_reserved, l_type
into :lsProject, :ls_LocType
From	location
Where wh_code = :lsWarehouse 
and l_code = :ls_l_code
Using SQLCA;
If sqlca.sqlcode = 0 Then
	//Check for project being reserved for a specific project
	If isnull(lsProject) or lsProject = '' Then
	Else
		If lsProject <> gs_project Then
			messagebox(this.title,"This Location (" + Trim(ddlb_loc_code.text) + ") is reserved by another project! ~r~rPlease enter a different location.",StopSign!)
			Return FALSE
		End If
	End If
	//TimA 02/12/14
	//Pandora #698 New MIX OWNER location type 6 to save multiple owners in one location
	if gs_Project = 'PANDORA' and ( ls_LocType <> '9' and  ls_LocType <> '6' ) then
		// dts - 2010-08-19, allowing multiple owners for cross-dock locations (where l_type = '9')
		/* NOTE!!! 
		What if a Pick is generated (emptying location of certain owner/inv_typ), 
		then a Put-away succeeds (because material of different owner has been picked)
		then the pick is un-done, placing the inventory back in content???  */

		//check that location is either empty or contains only material of like Owner and Inventory Type
		llOwnerID = w_ro.idw_putaway.getItemNumber(row, "owner_id", primary!, true)
		lsInvTyp = w_ro.idw_putaway.getItemString(row, "inventory_type", primary!, true)
		Select max(sku) 
		into :lsSKU
		From	content
		Where project_id = 'PANDORA'
		and wh_code = :lsWarehouse 
		and l_code = :ls_l_code
		and (owner_id <> :llOwnerID or Inventory_Type <> :lsInvTyp)
		Using SQLCA;

		If isnull(lsSKU) or lsSKU = '' Then
			//nothing in selected location that is a different Owner/InvType
		Else
			messagebox(this.title, "This Location (" + Trim(ddlb_loc_code.text) + ") already has material of a different Owner or Inventory Type! ~r~rPlease enter a different location.",StopSign!)
			Return FALSE
		End If					
		
		//dts - 8/30/2010 (not ready yet but need to check in....
		/* 9/29/10 - turned back on */
		If w_ro.idw_main.GetItemString(1, "crossdock_ind") = 'Y' Then
			if ls_LocType <> '9' then
				messagebox(this.title, "Cross-dock orders must be put-away in a cross-dock location! ~r~rPlease enter a different location.", StopSign!)
				Return FALSE
			end if
		End If	
	end if //Pandora and not a cross-dock location...
	
Else /* Location Not Found*/
	Messagebox(this.title,"Location Not Found!",StopSign!)
	Return FALSE
End If

//If a component, copy location to dependent records
If w_ro.idw_putaway.GetItemString(row,"component_ind") = 'Y' Then
	lsFind = "sku_parent = '" + w_ro.idw_putaway.GetItemString(row,"sku_parent") + "' and component_no = " + String(w_ro.idw_putaway.GetItemNumber(row,"component_no")) + " and line_item_no = " + String(w_ro.idw_putaway.GetITemNumber(row,'line_item_no'))
	//lsFind = "line_item_no = " + String(This.GetITemNumber(row,'line_item_no')) + " and l_code = '" + This.GetItemString(row,"l_code") + "'"
	llFindRow = w_ro.idw_putaway.Find(lsFind,1,w_ro.idw_putaway.RowCount())
	Do While llFindRow > 0
		w_ro.idw_putaway.SetItem(llFindRow,"l_code",ls_l_code)
		llFindRow = w_ro.idw_putaway.Find(lsFind,(llFindRow + 1),(w_ro.idw_putaway.RowCount() + 1))
	Loop
End If /*Component*/

return TRUE
end function

on w_ro_multi_confirm.create
this.dw_print=create dw_print
this.cb_print=create cb_print
this.st_row_count=create st_row_count
this.hpb_confirm=create hpb_confirm
this.ddlb_loc_code=create ddlb_loc_code
this.st_sub_inv_locs=create st_sub_inv_locs
this.st_l_code=create st_l_code
this.sle_sub_inv_loc=create sle_sub_inv_loc
this.st_results=create st_results
this.mle_results=create mle_results
this.cb_confirm=create cb_confirm
this.dw_receive_orders=create dw_receive_orders
this.st_orderno=create st_orderno
this.sle_orderno=create sle_orderno
this.gb_batch_confirm_id=create gb_batch_confirm_id
this.st_batch_confirm_id=create st_batch_confirm_id
this.Control[]={this.dw_print,&
this.cb_print,&
this.st_row_count,&
this.hpb_confirm,&
this.ddlb_loc_code,&
this.st_sub_inv_locs,&
this.st_l_code,&
this.sle_sub_inv_loc,&
this.st_results,&
this.mle_results,&
this.cb_confirm,&
this.dw_receive_orders,&
this.st_orderno,&
this.sle_orderno,&
this.gb_batch_confirm_id,&
this.st_batch_confirm_id}
end on

on w_ro_multi_confirm.destroy
destroy(this.dw_print)
destroy(this.cb_print)
destroy(this.st_row_count)
destroy(this.hpb_confirm)
destroy(this.ddlb_loc_code)
destroy(this.st_sub_inv_locs)
destroy(this.st_l_code)
destroy(this.sle_sub_inv_loc)
destroy(this.st_results)
destroy(this.mle_results)
destroy(this.cb_confirm)
destroy(this.dw_receive_orders)
destroy(this.st_orderno)
destroy(this.sle_orderno)
destroy(this.gb_batch_confirm_id)
destroy(this.st_batch_confirm_id)
end on

event open;if f_retrieve_parm(gs_project, 'FLAG', 'RO_BATCH_CONFIRM_ON') <> 'Y' then
	MessageBox(this.title, "This functionality has been turned off.")
	close(this)
end if


// This window will use W_RO to putaway and confirm orders so first ensure it is not open.
if IsValid(w_ro) then
	MessageBox(this.title, "Please close the Receiving Order Window before opening this window. ~rThe windows may not be used concurrently.")
	close(this)
end if

end event

event resize;//dw_receive_orders.width = newwidth - 124
//
//mle_results.width = newwidth - 124
//mle_results.height = newheight - 1860
//
//cb_confirm.x = newwidth -722
//
//hpb_confirm.width = newwidth - 850
//


// Working code above
// Height of window=2168
// Width of window=3831
dw_receive_orders.width = newwidth - 124
dw_receive_orders.height = newheight - 940

mle_results.width = newwidth - 124
mle_results.y = newheight - 344

st_results.y = newheight - 420

cb_confirm.x = newwidth -722
cb_confirm.y = newheight - 536

cb_print.x = newwidth -1180
cb_print.y = newheight - 536

gb_batch_confirm_id.x = newwidth - 969
st_batch_confirm_id.x = newwidth - 933

st_row_count.y = newheight - 540
//st_row_count.x = newwidth - 2258

hpb_confirm.width = newwidth - 1742
hpb_confirm.y = newheight - 528

end event

type dw_print from u_dw_ancestor within w_ro_multi_confirm
boolean visible = false
integer x = 1865
integer y = 72
integer width = 731
integer height = 404
integer taborder = 60
string dataobject = "d_multi_confirm_ro"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_print from commandbutton within w_ro_multi_confirm
integer x = 2651
integer y = 1632
integer width = 448
integer height = 96
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;long ll_white
ll_white = RGB(255,255,255)

dw_receive_orders.ShareData(dw_print)

dw_print.Modify("Background.Color = '" +  string(ll_white) + "'")

dw_print.Modify("supp_invoice_no.Background.Color = '" +  string(ll_white) + "'")
dw_print.Modify("supp_invoice_no_t.Background.Color = '" +  string(ll_white) + "'")

dw_print.Modify("rec_qty.Background.Color = '" +  string(ll_white) + "'")
dw_print.Modify("rec_qty_t.Background.Color = '" +  string(ll_white) + "'")

dw_print.Object.line_item_no.Visible = FALSE
dw_print.Object.line_item_no_t.Visible = FALSE

dw_print.Object.sku.Visible = FALSE
dw_print.Object.sku_t.Visible = FALSE

dw_print.Object.coo.Visible = FALSE
dw_print.Object.coo_t.Visible = FALSE

dw_print.Object.confirm_results.Visible = FALSE
dw_print.Object.confirm_results_t.Visible = FALSE

dw_print.Object.row_select.Visible = FALSE
dw_print.Object.select_row_t.Visible = FALSE

dw_print.Object.complete_date.Visible = TRUE
dw_print.Object.complete_date_t.Visible = TRUE
dw_print.Modify("complete_date_t.Background.Color = '" +  string(ll_white) + "'")
dw_print.Modify("complete_date.Background.Color = '" +  string(ll_white) + "'")

dw_print.Object.batch_confirm_id.Visible = TRUE
dw_print.Object.batch_confirm_id_t.Visible = TRUE
dw_print.Modify("batch_confirm_id.Background.Color = '" +  string(ll_white) + "'")
dw_print.Modify("batch_confirm_id_t.Background.Color = '" +  string(ll_white) + "'")

Openwithparm(w_dw_print_options,dw_print)

end event

type st_row_count from statictext within w_ro_multi_confirm
integer x = 50
integer y = 1628
integer width = 430
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rows:  0"
boolean focusrectangle = false
end type

type hpb_confirm from hprogressbar within w_ro_multi_confirm
boolean visible = false
integer x = 535
integer y = 1640
integer width = 2089
integer height = 80
unsignedinteger maxposition = 20
integer setstep = 1
boolean smoothscroll = true
end type

type ddlb_loc_code from dropdownlistbox within w_ro_multi_confirm
event ue_x pbm_cbgetdroppedcontrolrect
event ue_dropping_down_list pbm_cbndropdown
integer x = 379
integer y = 128
integer width = 869
integer height = 1172
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_dropping_down_list;// Event fires when the drop down is opened (dropped down)

// Only retrieve locations if they have not already been retrieved for this warehouse...handled in the following method
wf_populate_locations()

end event

type st_sub_inv_locs from statictext within w_ro_multi_confirm
integer x = 41
integer y = 236
integer width = 329
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Sub-Inv Loc:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_l_code from statictext within w_ro_multi_confirm
integer x = 55
integer y = 136
integer width = 315
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Location:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_sub_inv_loc from singlelineedit within w_ro_multi_confirm
integer x = 379
integer y = 228
integer width = 869
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event modified;wf_validate_sub_inv_loc()

end event

type st_results from statictext within w_ro_multi_confirm
integer x = 59
integer y = 1748
integer width = 791
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Putaway and Confirm Errors:"
boolean focusrectangle = false
end type

type mle_results from multilineedit within w_ro_multi_confirm
integer x = 50
integer y = 1824
integer width = 3707
integer height = 308
integer taborder = 70
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cb_confirm from commandbutton within w_ro_multi_confirm
integer x = 3109
integer y = 1632
integer width = 649
integer height = 96
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Putaway and &Confirm"
end type

event clicked;// Scroll through dw rows calling W_RO putaway/save/confirm capturing any errors or messages

if dw_receive_orders.RowCount() = 0 then
	MessageBox(parent.title, "First, please add orders to the list by entering order numbers in Order Nbr: ")
	sle_orderno.SetFocus()
	return
end if

if dw_receive_orders.AcceptText() = -1 then
	return
end if

if IsNull(ddlb_loc_code.text) or Len(Trim(ddlb_loc_code.text)) = 0 then
	MessageBox(parent.title, "Please enter location code.")
	ddlb_loc_code.SetFocus()
	return
else
	String ls_wh_code, ls_l_code
	long ll_count
	ls_wh_code = dw_receive_orders.Object.wh_code[1]
	ls_l_code = ddlb_loc_code.Text

	// Validate location
	SELECT COUNT(*)
	INTO :ll_count
	FROM location
	WHERE wh_code = :ls_wh_code
	AND l_code = :ls_l_code;

	if ll_count = 0 then
		MessageBox(parent.title, "Please enter a valid location code.  The following location code was not found:  " + String(nz(ls_l_code, "")))
		if ib_find_loc_mode then
			ddlb_loc_code.SetFocus()
			ddlb_loc_code.SelectText(1, Len(ddlb_loc_code.Text))
		else
			ddlb_loc_code.SetFocus()
			ddlb_loc_code.SelectText(1, Len(ddlb_loc_code.Text))
		end if
		return
	end if
	
end if

if IsNull(sle_sub_inv_loc.text) or Len(Trim(sle_sub_inv_loc.text)) = 0 then
	MessageBox(parent.title, "Please enter Sub-Inv Loc.")
	return
end if

if IsValid(w_ro) then
	MessageBox(parent.title, "Please close Receive Order Window before taking this action.")
	return
end if


// Validate that all rows contain quantities
long ll_found_row
ll_found_row = dw_receive_orders.Find("rec_qty = 0 or IsNull(rec_qty)", 1, dw_receive_orders.RowCount())
if ll_found_row > 0 then
	MessageBox(parent.title, "Please set received quantities on all orders in the list.")
	dw_receive_orders.SetRow(ll_found_row)
	dw_receive_orders.ScrolltoRow(ll_found_row)
	dw_receive_orders.SetColumn("rec_qty")
	dw_receive_orders.SetFocus()
	return
end if

ll_found_row = dw_receive_orders.Find("Trim(coo) = '' or Trim(coo) = 'XX' or Trim(coo) = 'XXX'", 1, dw_receive_orders.RowCount())
if ll_found_row > 0 then
	MessageBox(parent.title, "Please enter a valid Country Of Origin for all orders in the list.")
	dw_receive_orders.SetRow(ll_found_row)
	dw_receive_orders.ScrolltoRow(ll_found_row)
	dw_receive_orders.SetColumn("coo")
	dw_receive_orders.SetFocus()
	return
end if

if NOT wf_validate_sub_inv_loc() then
	sle_sub_inv_loc.SetFocus()
	return
end if

Str_parms lStrparms
lStrparms.String_arg[1] = "W_ROD"
String ls_ord_status, ls_ro_no, ls_trace, ls_ship_ref
dec ld_batch_confirm_id
int li_return
long i, j

f_method_trace_special( gs_project,parent.ClassName() + ' - confirm','start multi-confirm, ' + wf_get_batch_details(false) ,'',' ',' ' ,'')

hpb_confirm.Visible = TRUE
hpb_confirm.SetRange( 1, dw_receive_orders.RowCount() )
hpb_confirm.MaxPosition =  dw_receive_orders.RowCount()
hpb_confirm.position = 0

for i = 1 to dw_receive_orders.RowCount()
	
	ls_ro_no = dw_receive_orders.Object.ro_no[ i ]
	
	// Check once more that the order is in NEW status (was checked when order was added to the list but time has passed)
	SELECT ord_status
	INTO :ls_ord_status
	FROM receive_master
	WHERE ro_no = :ls_ro_no;

	if ls_ord_status <> 'N' then
		MessageBox(parent.title, "Order " + String( dw_receive_orders.Object.supp_invoice_no[ i ] ) + " is no longer in New status.")
		f_method_trace_special( gs_project,parent.ClassName() + ' - confirm','Validation error: ' +  "Order " + String( dw_receive_orders.Object.supp_invoice_no[ i ] ) + " is no longer in New status." + wf_get_batch_details(true) ,'',' ',' ' ,'')
		hpb_confirm.Visible = FALSE
		return
	end if

	if NOT IsValid(w_ro) then
		
		w_main.SetRedraw(FALSE)
		OpenSheetwithparm(w_ro,lStrparms, w_main, gi_menu_pos, Original!)
		w_ro.ib_batchconfirmmode = TRUE
		Yield()	// let w_ro.ue_postopen() complete
		w_main.SetRedraw(TRUE)
		w_ro.windowstate = Minimized!
		Yield()	// let w_ro minimize
		w_main.SetRedraw(TRUE)
		parent.SetFocus()

	else
		w_ro.TriggerEvent("ue_edit")
		Yield()	// let w_ro minimize
		parent.SetFocus()
	end if

//	w_ro.tab_main.tabpage_main.sle_orderno.text = dw_receive_orders.Object.ro_no[ i ]
//Nxjain: while  confirm the Order ;system could find duplicate Ro_no , thus we updated identical value to retrieve .
//27012017
	w_ro.tab_main.tabpage_main.sle_orderno.text = dw_receive_orders.Object.supp_invoice_no[ i ]
	w_ro.tab_main.tabpage_main.sle_orderno.TriggerEvent("modified")
	
	w_ro.tab_main.tabpage_putaway.cb_generate.TriggerEvent("Clicked")

	Yield()
	parent.SetFocus()

	if w_ro.tab_main.tabpage_putaway.dw_putaway.RowCount() <> 1 then
		// Shouldn't happen if no errors were returned from generate
		MessageBox(parent.title, "Error generating putaway.")
		f_method_trace_special( gs_project,parent.ClassName() + ' - confirm','Validation error: ' +  "Error generating putaway." + wf_get_batch_details(true) ,'',' ',' ' ,'')
		Close(w_ro)
		hpb_confirm.Visible = FALSE
		return
	end if

	// Set order's values
	w_ro.tab_main.tabpage_putaway.dw_putaway.Object.quantity[1] = dw_receive_orders.Object.rec_qty[ i ]

	if NOT wf_validate_location() then
		if w_ro.idw_putaway.RowCount() = 1 then
			w_ro.idw_putaway.DeleteRow(1)
		end if
		w_ro.ib_changed = FALSE
		Close(w_ro)
		f_method_trace_special( gs_project,parent.ClassName() + ' - confirm','Location validation error;  ' + wf_get_batch_details(true) ,'',' ',' ' ,'')
		ddlb_loc_code.SetFocus()
		ddlb_loc_code.SelectText(1, Len(ddlb_loc_code.Text))
		hpb_confirm.Visible = FALSE
		return
	else
		w_ro.tab_main.tabpage_putaway.dw_putaway.Object.l_code[1] = ddlb_loc_code.text
		w_ro.tab_main.tabpage_putaway.dw_putaway.Object.country_of_origin[1] = dw_receive_orders.Object.coo[ i ]
	end if

	w_ro.tab_main.tabpage_main.dw_main.Object.user_field2[1] = sle_sub_inv_loc.text
	w_ro.tab_main.tabpage_main.dw_main.Object.arrival_date[1] = f_getLocalWorldTime( dw_receive_orders.Object.wh_code[ i ] )
	w_ro.tab_main.tabpage_main.dw_main.Object.transport_mode[1] = "GROUND"
	w_ro.tab_main.tabpage_main.dw_main.Object.awb_bol_no[1] = "SHUTTLE"

	if IsNull(w_ro.tab_main.tabpage_main.dw_main.Object.ship_ref[1]) or Len(String(w_ro.tab_main.tabpage_main.dw_main.Object.ship_ref[1])) = 0 then
		w_ro.tab_main.tabpage_main.dw_main.Object.ship_ref[1] = " "	// Not needed per Mark D.
	end if

	// Save the order in w_ro
	li_return = w_ro.TriggerEvent("ue_save")
	
	Yield()
	parent.SetFocus()
	
	if li_return = -1 then
		MessageBox(parent.title, "Error saving the order after putaway generation.")
		Close(w_ro)
		f_method_trace_special( gs_project,parent.ClassName() + ' - confirm','Error saving the order after putaway generation.  ' + wf_get_batch_details(true) ,'',' ',' ' ,'')
		hpb_confirm.Visible = FALSE
		return
	end if
	
	// Confirm the order in w_ro
	w_ro.TriggerEvent("ue_confirm")

	Yield()
	parent.SetFocus()

	if UpperBound(w_ro.is_batch_message) = 0 then

		if ld_batch_confirm_id = 0 then
			ld_batch_confirm_id = g.of_next_db_seq(gs_project, "Receive_Master", "batch_confirm_id")
			st_batch_confirm_id.text = String( ld_batch_confirm_id )
			ls_ship_ref = 'Batch ' + String(ld_batch_confirm_id)
		end if

		dw_receive_orders.Object.confirm_results[ i ] = 'Confirmed'
		dw_receive_orders.Object.complete_date[ i ] = w_ro.tab_main.tabpage_main.dw_main.Object.complete_date[1]	// needed for printing this window
		dw_receive_orders.Object.batch_confirm_id[ i ] = String(ld_batch_confirm_id)

		UPDATE Receive_Master
		SET  	Batch_Confirm_Id = :ld_batch_confirm_id,
				Ship_Ref = :ls_ship_ref
		WHERE ro_no = :ls_ro_no;

	else
		// Confirmation errors occurred
		dw_receive_orders.Object.confirm_results[ i ] = 'Error'

		for j = 1 to UpperBound(w_ro.is_batch_message)
			mle_results.text = mle_results.text + "~r" + w_ro.is_batch_message[ j ]
		next
		Close(w_ro)
		MessageBox(parent.title, "Batch confirm errors were encountered.  Please see Putaway and Confirm Errors for details.")
		f_method_trace_special( gs_project,parent.ClassName() + ' - confirm','Batch confirm errors were encountered.' + wf_get_batch_details(true) ,'',' ',' ' ,'')
		hpb_confirm.Visible = FALSE
		return
	end if

	hpb_confirm.OffSetPos(1)
	Yield()
next

if IsValid(w_ro) then
	Close(w_ro)
end if

f_method_trace_special( gs_project,parent.ClassName() + ' - confirm','end multi-confirm, ' + 'batch_confirm_id=' + String(ld_batch_confirm_id) + ',  ' + wf_get_batch_details(true) ,'',' ',' ' ,'')

String ls_complete_message = "Multi-Confirm complete. "
if Len(Trim(mle_results.text)) > 0 then
	ls_complete_message += "~rErrors occurred, check Putaway and Confirm Errors for details."
end if
MessageBox(parent.title, ls_complete_message)
hpb_confirm.Visible = FALSE

end event

type dw_receive_orders from u_dw_ancestor within w_ro_multi_confirm
integer x = 50
integer y = 388
integer width = 3707
integer height = 1228
integer taborder = 40
string dataobject = "d_multi_confirm_ro"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;if dwo.name = 'row_select' and data = 'Y' then
	if MessageBox(parent.title, "Do you wish to delete the selected row?", Question!, YesNo!) = 1 then
		this.DeleteRow(row)
		st_row_count.text = "Rows:  " + String(dw_receive_orders.RowCount())
		if this.RowCount() = 0 then
			wf_enable_loc_controls(false)
			st_batch_confirm_id.text = ""
		end if
	else
		return 1
	end if
end if

if dwo.name = 'rec_qty' then
	if Integer(data) > Integer(this.Object.req_qty[row]) then
		MessageBox(parent.title, "Quantity entered is greater than the required quantity which is: " + String(this.Object.req_qty[row]) + "~rPlease retry.")
		return 1
	end if
	sle_orderno.Text = ""
	sle_orderno.SetFocus()	// Set focus back to order number
end if

end event

event itemerror;call super::itemerror;if dwo.name = 'row_select' then
	return 1
else
	return 2
end if

end event

event itemfocuschanged;call super::itemfocuschanged;choose case dwo.name
	case 'coo'

		this.GetChild ( "coo", idwc_coo )
		idwc_coo.SetTransObject(Sqlca)

		if gs_project = 'PANDORA' then
			//idwc_coo.Retrieve(gs_project,this.GetITemString(row,'sku'),this.GetITemString(row,'supp_code'))
			idwc_coo.Retrieve(gs_project,this.GetITemString(row,'sku'),'PANDORA' )
		end if

end choose

end event

type st_orderno from statictext within w_ro_multi_confirm
integer x = 73
integer y = 36
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Order Nbr:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_orderno from singlelineedit within w_ro_multi_confirm
integer x = 379
integer y = 28
integer width = 869
integer height = 92
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
integer limit = 30
borderstyle borderstyle = stylelowered!
end type

event modified;// This window will use W_RO to putaway and confirm orders so first ensure it is not open.
if IsValid(w_ro) then
	MessageBox(parent.title, "Please close the Receiving Order Window before processing these orders. ~rThe windows may not be used concurrently.")
	return
end if

String ls_ro_no, ls_supp_invoice_no, ls_sku, ls_wh_code, ls_order_status, ls_line_item_no, ls_find_str, ls_sub_inv_loc_aka_owner, ls_coo, ls_uf5, ls_supp_code
String ls_lot_controlled_ind, ls_po_no2_controlled_ind, ls_container_tracking_ind, ls_expiration_controlled_ind, ls_serialized_ind
Long ll_count, ll_row, ll_detail_count
Decimal ld_req_qty

if Len(this.text) > 0 then

	this.text = Trim(this.Text)
	this.SelectText(1, Len(this.Text))

	if dw_receive_orders.RowCount() > 0 then
		
		ls_find_str = "supp_invoice_no = '" + this.text + "'"
		if dw_receive_orders.Find(ls_find_str, 1, dw_receive_orders.RowCount()) > 0 then
			MessageBox(parent.title, "Order number has already been added to the list.  ~rPlease try again.")
			return
		end if		
	end if

	SELECT 	Count(RM.RO_No)
	INTO		:ll_count
	FROM 	Receive_Master RM WITH (NOLOCK)
	WHERE 	RM.project_id = :gs_project
	AND 		RM.Supp_Invoice_No = :this.text;

	if ll_count = 1 then


		SELECT 	Count(*)
		INTO		:ll_detail_count
		FROM 	Receive_Master RM WITH (NOLOCK)
		INNER JOIN Receive_Detail RD WITH (NOLOCK) 
		ON 		RD.RO_No = RM.RO_No
		WHERE 	RM.project_id = :gs_project
		AND 		RM.Supp_Invoice_No = :this.text;

		if ll_detail_count = 1 then
	
			SELECT 	RD.sku, RD.req_qty, RM.RO_No, RM.Supp_Invoice_No, RM.wh_code, RM.ord_status, RD.line_item_no, RM.user_field2, RD.Country_Of_Origin, RD.Supp_Code
			INTO		:ls_sku, :ld_req_qty, :ls_ro_no, :ls_supp_invoice_no, :ls_wh_code, :ls_order_status, :ls_line_item_no, :ls_sub_inv_loc_aka_owner, :ls_coo, :ls_supp_code
			FROM 	Receive_Master RM WITH (NOLOCK)
			INNER JOIN Receive_Detail RD WITH (NOLOCK) 
			ON 		RD.RO_No = RM.RO_No
			WHERE 	RM.project_id = :gs_project
			AND 		RM.Supp_Invoice_No = :this.text;

			if SQLCA.SQLCode <> 0 then
				// Error upon retrieve
				MessageBox(parent.title, "Error retrieving receive order from database. Please contact support. ~r~rDB Error: " + SQLCA.SQLErrText)
				return				
			end if

			if ls_order_status <> 'N' then
				MessageBox(parent.title, "Order status must be New in order to batch confirm.  ~rThis order's status is:  " + ls_order_status + " ~rPlease try again.")
				return
			end if

		else
			
			MessageBox(parent.title, "Order must contain only one detail row for batch confirms.  ~rThis order contains " + String(ll_detail_count) + " detail rows. ~rPlease try again.")
			return
			
		end if
		
		
	elseif ll_count = 0 then

		// Determine if RO_NO was entered
		
		SELECT 	Count(RM.RO_No)
		INTO		:ll_count
		FROM 	Receive_Master RM WITH (NOLOCK)
		WHERE 	RM.project_id = :gs_project
		AND 		RM.RO_No = :this.text;

		if ll_count = 1 then

			SELECT 	count(*)
			INTO		:ll_detail_count
			FROM 	Receive_Master RM WITH (NOLOCK)
			INNER JOIN Receive_Detail RD WITH (NOLOCK) 
			ON 		RD.RO_No = RM.RO_No
			WHERE 	RM.project_id = :gs_project
			AND 		RM.RO_No = :this.text;

			if ll_detail_count = 1 then
			
				SELECT 	RD.sku, RD.req_qty, RM.RO_No, RM.Supp_Invoice_No, RM.wh_code, RM.ord_status, RD.line_item_no, RM.user_field2, RD.Country_Of_Origin, RD.Supp_Code
				INTO		:ls_sku, :ld_req_qty, :ls_ro_no, :ls_supp_invoice_no, :ls_wh_code, :ls_order_status, :ls_line_item_no, :ls_sub_inv_loc_aka_owner, :ls_coo, :ls_supp_code
				FROM 	Receive_Master RM WITH (NOLOCK)
				INNER JOIN Receive_Detail RD WITH (NOLOCK) 
				ON 		RD.RO_No = RM.RO_No
				WHERE 	RM.project_id = :gs_project
				AND 		RM.RO_No = :this.text;
		
				if SQLCA.SQLCode <> 0 then
					// Error upon retrieve
					MessageBox(parent.title, "Error retrieving receive order from database. Please contact support. ~r~rDB Error: " + SQLCA.SQLErrText)
					return
				end if

				// RO_NO was entered, now that we have supp_invoice_no check for duplicates
				if dw_receive_orders.RowCount() > 0 then
					ls_find_str = "supp_invoice_no = '" + ls_supp_invoice_no + "'"
					if dw_receive_orders.Find(ls_find_str, 1, dw_receive_orders.RowCount()) > 0 then
						MessageBox(parent.title, "Order number has already been added to the list.  ~rPlease try again.")
						return
					end if		
				end if

				if ls_order_status <> 'N' then
					MessageBox(parent.title, "Order status must be New in order to batch confirm.  ~rThis order's status is:  " + ls_order_status + " ~rPlease try again.")
					return
				end if

			else
			
				MessageBox(parent.title, "Order must contain only one detail row for batch confirms.  ~rThis order contains " + String(ll_detail_count) + " detail rows. ~rPlease try again.")
				return

			end if
	
		elseif ll_count = 0 then
			MessageBox(parent.title, "No orders exist for order number:  " + this.text + "~rPlease try again.")
			return
		else
			// Shouldn't happen
			MessageBox(parent.title, "Error retrieving order number:  " + this.text + "~rPlease try again.")
			return
		end if

	elseif 	ll_count > 1 then

		// Multiple orders exist for Supp_Invoice_No
		MessageBox(parent.title, "Multiple orders exist for order number:  " + this.text + "~rPlease enter the System Number.")
		return

	end if

	// Only one order exits for the invoice number or RO_NO

	// Validate that the order can be batch confirmed

	// Validate the order is a MIM order
	if Len(ls_supp_invoice_no) > 0 and Left(Upper(ls_supp_invoice_no), 1) = 'X' then
		// Is MIM
	else
		// Is Not MIM
		MessageBox(parent.title, "Order must a MIM order. ~rPlease try again.")
		return
	end if

	// Validate this warehouse matches the warehouse(s) in the datawindow
	if dw_receive_orders.RowCount() > 0 then
		if Upper(Trim(dw_receive_orders.Object.wh_code[1])) <> Upper(Trim(ls_wh_code)) then
			MessageBox(parent.title, "Order's warehouse (" + ls_wh_code + ") must be the same as the warehouse(s) in the current list (" + Trim(Upper(dw_receive_orders.Object.wh_code[1])) + ")")
			return
		end if
	end if

	// Validate that this sub-inventory location (owner) matches any in the list
	if dw_receive_orders.RowCount() > 0 then
		if Upper(Trim(dw_receive_orders.Object.sub_inv_loc[1])) <> Upper(Trim(ls_sub_inv_loc_aka_owner)) then
			MessageBox(parent.title, "Order's sub-inventory location (" + ls_sub_inv_loc_aka_owner + ") must be the same as the sub-inventory location(s) in the current list (" + Trim(Upper(dw_receive_orders.Object.sub_inv_loc[1])) + ")")
			return
		end if
	end if
	
//	// Validate that this is not a Hard Drive order per Tim
//	SELECT user_field5
//	INTO :ls_uf5
//	FROM ITEM_MASTER
//	WHERE PROJECT_ID = :gs_project
//	AND SKU = :ls_sku
//	AND SUPP_CODE = :ls_supp_code;
//	//AND owner_id = :ls_sub_inv_loc_aka_owner;
//
//	if SQLCA.SQLCode <> 0 then
//		// Error upon retrieve
//		MessageBox(parent.title, "Error retrieving item master from database. Please contact support. ~r~rDB Error: " + SQLCA.SQLErrText)
//		return
//	elseif NOT IsNull(ls_uf5) then
//		if Trim(Upper(ls_uf5)) = "HD" then
//			MessageBox(parent.title, "Order scanned is a Hard Drive order and not allowed on a multi-confirm at this time.")
//			return
//		end if
//	end if

	// Validate that this is not a Hard Drive order per Tim
	SELECT lot_controlled_ind, po_no2_controlled_ind, container_tracking_ind, expiration_controlled_ind, serialized_ind
	INTO :ls_lot_controlled_ind, :ls_po_no2_controlled_ind, :ls_container_tracking_ind, :ls_expiration_controlled_ind, :ls_serialized_ind
	FROM ITEM_MASTER
	WHERE PROJECT_ID = :gs_project
	AND SKU = :ls_sku
	AND SUPP_CODE = :ls_supp_code;

	if SQLCA.SQLCode <> 0 then
		// Error upon retrieve
		MessageBox(parent.title, "Error retrieving item master from database. Please contact support. ~r~rDB Error: " + SQLCA.SQLErrText)
		return
	else
		boolean lb_lotable_controlled
		lb_lotable_controlled = (NOT IsNull(ls_lot_controlled_ind) and  ls_lot_controlled_ind = 'Y' )  OR &
			(NOT IsNull(ls_po_no2_controlled_ind) and  ls_po_no2_controlled_ind = 'Y' ) OR &
			(NOT IsNull(ls_container_tracking_ind) and  ls_container_tracking_ind = 'Y' ) OR &
			(NOT IsNull(ls_expiration_controlled_ind) and  ls_expiration_controlled_ind = 'Y' ) OR &
			(NOT IsNull(ls_serialized_ind) and  ls_serialized_ind <> 'N' )

		if lb_lotable_controlled then
			MessageBox(parent.title, "The GPN on this order is lot-able tracked and is not allowed on a multi-confirm at this time.")
			return
		end if
	end if

	// Validations passed, add order to list
	ll_row = dw_receive_orders.InsertRow(1)
	st_row_count.text = "Rows:  " + String(dw_receive_orders.RowCount())
	dw_receive_orders.Object.ro_no[ll_row] = ls_ro_no
	dw_receive_orders.Object.supp_invoice_no[ll_row] = ls_supp_invoice_no
	dw_receive_orders.Object.line_item_no[ll_row] = ls_line_item_no
	dw_receive_orders.Object.sku[ll_row] = ls_sku
	dw_receive_orders.Object.req_qty[ll_row] = ld_req_qty
	dw_receive_orders.Object.wh_code[ll_row] = ls_wh_code
	dw_receive_orders.Object.coo[ll_row] = ls_coo
	dw_receive_orders.Object.sub_inv_loc[ll_row] = ls_sub_inv_loc_aka_owner

	if ll_row = 1 then
		sle_sub_inv_loc.text = ls_sub_inv_loc_aka_owner
		//wf_populate_locations()	// too long...5 to 6 seconds in TEST, only populate if drop down is opened (dropped down)
	end if

	// Enable location and sub-inv loc controls
	wf_enable_loc_controls(true)

	f_setfocus(dw_receive_orders, ll_row, 'rec_qty')	// Set focus to quantity after successful order number entry

end if

end event

type gb_batch_confirm_id from groupbox within w_ro_multi_confirm
integer x = 2862
integer y = 28
integer width = 901
integer height = 240
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Batch Confirm ID"
end type

type st_batch_confirm_id from statictext within w_ro_multi_confirm
integer x = 2898
integer y = 120
integer width = 841
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

