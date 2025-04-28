$PBExportHeader$w_pandora_tender_lead_time.srw
$PBExportComments$Retrieves Pandora delivery orders marked as tender lead time.
forward
global type w_pandora_tender_lead_time from w_master
end type
type cb_cancel from commandbutton within w_pandora_tender_lead_time
end type
type cb_ok from commandbutton within w_pandora_tender_lead_time
end type
type cb_retrieve from commandbutton within w_pandora_tender_lead_time
end type
type cb_add from commandbutton within w_pandora_tender_lead_time
end type
type cb_close from commandbutton within w_pandora_tender_lead_time
end type
type cb_save from commandbutton within w_pandora_tender_lead_time
end type
type dw_tender_lead_time from u_dw within w_pandora_tender_lead_time
end type
type dw_select from u_dw within w_pandora_tender_lead_time
end type
type cbx_candidates_only from checkbox within w_pandora_tender_lead_time
end type
end forward

global type w_pandora_tender_lead_time from w_master
integer width = 4091
integer height = 1932
string title = "Pandora Tender Lead Time"
cb_cancel cb_cancel
cb_ok cb_ok
cb_retrieve cb_retrieve
cb_add cb_add
cb_close cb_close
cb_save cb_save
dw_tender_lead_time dw_tender_lead_time
dw_select dw_select
cbx_candidates_only cbx_candidates_only
end type
global w_pandora_tender_lead_time w_pandora_tender_lead_time

type variables
CONSTANT int II_UPDATE_ORDERS = 1
CONSTANT int II_ADD_ORDERS = 2

CONSTANT String IS_UPDATE_ORDER_WINDOW_TITLE = "Pandora Tender Lead Time"
CONSTANT String IS_ADD_ORDER_WINDOW_TITLE = "Add Delivery Orders"

DataStore ids_original_values
end variables

forward prototypes
public subroutine wf_set_window_mode (integer ai_window_mode)
public function boolean wf_is_equal (any aa_first, any aa_second)
public function long wf_retrieve_select_dw ()
end prototypes

public subroutine wf_set_window_mode (integer ai_window_mode);if ai_window_mode = II_UPDATE_ORDERS then
	
	this.title = IS_UPDATE_ORDER_WINDOW_TITLE

	dw_tender_lead_time.Modify("select_order_to_add_cbx.visible = FALSE")

	dw_tender_lead_time.visible = TRUE
	cb_save.visible = TRUE
	cb_retrieve.visible = TRUE
	cb_add.visible = TRUE
	cb_close.visible = TRUE

	dw_select.visible = FALSE
	cb_ok.visible = FALSE
	cb_cancel.visible = FALSE
	
	cbx_candidates_only.visible = FALSE
	
elseif ai_window_mode = II_ADD_ORDERS then

	this.title = IS_ADD_ORDER_WINDOW_TITLE
	
	dw_select.Reset()

	// Remove previous filter
	dw_select.SetFilter("")
	dw_select.Filter()

	dw_select.Modify("select_order_to_add_cbx.visible = TRUE")
	dw_select.Modify("shipment_scheduled_cbx.visible = FALSE")
	dw_select.SetTabOrder ("consolidation_no", 0 )
	dw_select.SetTabOrder ("freight_eta", 0 )

	dw_tender_lead_time.visible = FALSE	
	cb_save.visible = FALSE
	cb_retrieve.visible = FALSE
	cb_add.visible = FALSE
	cb_close.visible = FALSE

	dw_select.visible = TRUE
	cb_ok.visible = TRUE
	cb_cancel.visible = TRUE

	cbx_candidates_only.visible = TRUE

	wf_retrieve_select_dw()

end if

end subroutine

public function boolean wf_is_equal (any aa_first, any aa_second);// Need to make this a generic function, but missed QA cutoff.
boolean lb_return

if IsNull(aa_first) or IsNull(aa_second) then
	// Either both are null or a mismatch exists
	lb_return = IsNull(aa_first) and IsNull(aa_second)
else
	lb_return = (aa_first = aa_second)
end if

// Treat Null and empty string as the same
if NOT lb_return then
	if 	(IsNull(aa_first) and Trim(String(aa_second)) = "") or (IsNull(aa_second) and Trim(String(aa_first)) = "") then
		lb_return = TRUE
	end if
end if

return lb_return

end function

public function long wf_retrieve_select_dw ();// Use same dwo, modify it to select non OTM orders in appropriate order status	
String ls_sql
ls_sql = dw_select.GetSQLSelect()

int li_pos
li_pos = Pos(ls_sql, "WHERE")
ls_sql = Left(ls_sql, li_pos -1)

ls_sql += " WHERE project_id = '" + gs_project + "' and ord_status in ('N', 'P', 'I', 'A', 'R','L') " + " and (otm_status is null " + " or otm_status in ('', 'N') ) " // Dinesh - 05/08/2023- SIMS-53- Google - SIMS - Load Lock and New Loading Status - Added 'L' - Loading

if cbx_candidates_only.checked then
	// The following criteria are checked upon shipment consolidation

	long ll_row
	ll_row = dw_tender_lead_time.GetRow()
	
	if NOT IsNull(dw_tender_lead_time.Object.wh_code[ll_row]) and Trim(dw_tender_lead_time.Object.wh_code[ll_row]) <> "" then
		ls_sql += " and wh_code = '" + String(Trim(dw_tender_lead_time.Object.wh_code[ll_row])) + "' "
	end if
	
	if NOT IsNull(dw_tender_lead_time.Object.cust_name[ll_row]) and Trim(dw_tender_lead_time.Object.cust_name[ll_row]) <> "" then
		ls_sql += " and cust_name = '" + String(Trim(dw_tender_lead_time.Object.cust_name[ll_row])) + "' "
	end if

	if NOT IsNull(dw_tender_lead_time.Object.address_1[ll_row]) and Trim(dw_tender_lead_time.Object.address_1[ll_row]) <> "" then
		ls_sql += " and address_1 = '" + String(Trim(dw_tender_lead_time.Object.address_1[ll_row])) + "' "
	end if

	if NOT IsNull(dw_tender_lead_time.Object.address_2[ll_row]) and Trim(dw_tender_lead_time.Object.address_2[ll_row]) <> "" then
		ls_sql += " and address_2 = '" + String(Trim(dw_tender_lead_time.Object.address_2[ll_row])) + "' "
	end if

	if NOT IsNull(dw_tender_lead_time.Object.address_3[ll_row]) and Trim(dw_tender_lead_time.Object.address_3[ll_row]) <> "" then
		ls_sql += " and address_3 = '" + String(Trim(dw_tender_lead_time.Object.address_3[ll_row])) + "' "
	end if

	if NOT IsNull(dw_tender_lead_time.Object.address_4[ll_row]) and Trim(dw_tender_lead_time.Object.address_4[ll_row]) <> "" then
		ls_sql += " and address_4 = '" + String(Trim(dw_tender_lead_time.Object.address_4[ll_row])) + "' "
	end if

	if NOT IsNull(dw_tender_lead_time.Object.city[ll_row]) and Trim(dw_tender_lead_time.Object.city[ll_row]) <> "" then
		ls_sql += " and city = '" + String(Trim(dw_tender_lead_time.Object.city[ll_row])) + "' "
	end if

	if NOT IsNull(dw_tender_lead_time.Object.state[ll_row]) and Trim(dw_tender_lead_time.Object.state[ll_row]) <> "" then
		ls_sql += " and state = '" + String(Trim(dw_tender_lead_time.Object.state[ll_row])) + "' "
	end if

	if NOT IsNull(dw_tender_lead_time.Object.zip[ll_row]) and Trim(dw_tender_lead_time.Object.zip[ll_row]) <> "" then
		ls_sql += " and zip = '" + String(Trim(dw_tender_lead_time.Object.zip[ll_row])) + "' "
	end if

	if NOT IsNull(dw_tender_lead_time.Object.awb_bol_no[ll_row]) and Trim(dw_tender_lead_time.Object.awb_bol_no[ll_row]) <> "" then
		ls_sql += " and awb_bol_no = '" + String(Trim(dw_tender_lead_time.Object.awb_bol_no[ll_row])) + "' "
	end if

	if NOT IsNull(dw_tender_lead_time.Object.carrier_pro_no[ll_row]) and Trim(dw_tender_lead_time.Object.carrier_pro_no[ll_row]) <> "" then
		ls_sql += " and carrier_pro_no = '" + String(Trim(dw_tender_lead_time.Object.carrier_pro_no[ll_row])) + "' "
	end if
end if

// Exclude do_no(s) in the main dw
String ls_do_no_exclusion
Long ll_rows, i
ll_rows = dw_tender_lead_time.RowCount()

for i = 1 to ll_rows
	if Len(ls_do_no_exclusion) > 0 then
		ls_do_no_exclusion += ",  '" + dw_tender_lead_time.Object.do_no[i] + "' "
	else
		ls_do_no_exclusion += "  '" + dw_tender_lead_time.Object.do_no[i] + "' "
	end if
next

if Len(ls_do_no_exclusion) > 0 then
	ls_do_no_exclusion = " and do_no NOT in (" + ls_do_no_exclusion + ") "
end if

//ls_sql += " WHERE project_id = '" + gs_project + "' and ord_status in ('N', 'P', 'I', 'A', 'R') " + " and (otm_status is null " + " or otm_status in ('', 'N') ) " + " order by invoice_no "
ls_sql += ls_do_no_exclusion + " order by invoice_no "

String lsOrigSql, lsModify
lsModify = 'DataWindow.Table.Select="' + ls_sql + '"'
dw_select.Modify(lsModify)

ll_rows = dw_select.Retrieve(gs_project)

SetMicroHelp(String(ll_rows ) + " orders retrieved and available for add.")

return ll_rows

end function

on w_pandora_tender_lead_time.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cb_retrieve=create cb_retrieve
this.cb_add=create cb_add
this.cb_close=create cb_close
this.cb_save=create cb_save
this.dw_tender_lead_time=create dw_tender_lead_time
this.dw_select=create dw_select
this.cbx_candidates_only=create cbx_candidates_only
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_retrieve
this.Control[iCurrent+4]=this.cb_add
this.Control[iCurrent+5]=this.cb_close
this.Control[iCurrent+6]=this.cb_save
this.Control[iCurrent+7]=this.dw_tender_lead_time
this.Control[iCurrent+8]=this.dw_select
this.Control[iCurrent+9]=this.cbx_candidates_only
end on

on w_pandora_tender_lead_time.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cb_retrieve)
destroy(this.cb_add)
destroy(this.cb_close)
destroy(this.cb_save)
destroy(this.dw_tender_lead_time)
destroy(this.dw_select)
destroy(this.cbx_candidates_only)
end on

event ue_postopen;call super::ue_postopen;if f_retrieve_parm(gs_project, 'FLAG', 'TENDER_LEAD_TIME_ON') <> 'Y' then
	MessageBox("Future Functionality", "This functionality has been turned off for the moment.")
	Close(this)
	return
end if

SetRedraw(TRUE)

ids_original_values = CREATE datastore
ids_original_values.dataobject = 'd_pandora_tender_lead_time'

wf_set_window_mode(II_UPDATE_ORDERS)

dw_tender_lead_time.Trigger Event ue_retrieve()

f_method_trace_special(gs_project, this.ClassName() , 'Opened window: orders retrieved: ' + String(dw_tender_lead_time.RowCount()),'', '','','')

end event

event resize;call super::resize;int li_button_y_val
li_button_y_val = newheight - 140

dw_tender_lead_time.width = this.width - 130
dw_tender_lead_time.height = this.height -330

cb_save.x = newwidth - 1769
cb_save.y = li_button_y_val
cb_retrieve.x = newwidth - 1326
cb_retrieve.y = li_button_y_val
cb_add.x = newwidth - 882
cb_add.y = li_button_y_val
cb_close.x = newwidth - 439
cb_close.y = li_button_y_val

dw_select.width = this.width - 997
dw_select.height = this.height -530

cb_ok.x = newwidth - 2679
cb_ok.y = li_button_y_val
cb_cancel.x = newwidth - 2231
cb_cancel.y = li_button_y_val

cbx_candidates_only.y = this.height -420
end event

event ue_save;call super::ue_save;dw_tender_lead_time.Event Trigger ue_save()
return 1

end event

event close;call super::close;if dw_tender_lead_time.modifiedcount( ) > 0 then
	if MessageBox(this.title, "Changes have been made.  Do you wish to save changes?", Question!, YESNO!) = 1 then		
		dw_tender_lead_time.Event Trigger ue_save()
	end if
end if

f_method_trace_special(gs_project, this.ClassName() , 'Closing window','', '','','')
						
close (this)

end event

event ue_preopen;call super::ue_preopen;//SetRedraw(FALSE)
end event

type cb_cancel from commandbutton within w_pandora_tender_lead_time
integer x = 1824
integer y = 1688
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
end type

event clicked;wf_set_window_mode(II_UPDATE_ORDERS)

SetMicroHelp("Add canceled, 0 orders added.")
end event

type cb_ok from commandbutton within w_pandora_tender_lead_time
integer x = 1376
integer y = 1688
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;long i, ll_count, ll_current_count
String ls_null
SetNull(ls_null)

SetRedraw(FALSE)

dw_select.SetFilter("select_order_to_add_cbx = '1'" )
dw_select.Filter()
if dw_select.RowCount() > 0 then
	
	ll_current_count = dw_tender_lead_time.RowCount()
	
	dw_select.RowsCopy(1, dw_select.RowCount(), Primary!, dw_tender_lead_time, ll_current_count + 1, Primary!)
	
	// Set all copied rows status to not modified so insert statements are not created.  A two step process as the status cannot go from New! to NotModified!
	// Null out Shipment ID and carrier
	for i = (ll_current_count + 1) to dw_tender_lead_time.RowCount()
		
		dw_tender_lead_time.Object.consolidation_no[i] = ls_null
		dw_tender_lead_time.Object.carrier[i] = ls_null		
		
		dw_tender_lead_time.SetItemStatus(i, 0, Primary!, DataModified!)
		dw_tender_lead_time.SetItemStatus(i, 0, Primary!, NotModified!)
	next
	
end if

SetRedraw(TRUE)

f_method_trace_special(gs_project, parent.ClassName() , 'Added ' + String(dw_select.RowCount()) + ' orders.','', '','','')
SetMicroHelp(String(dw_select.RowCount()) + " orders added.")
	
dw_select.Reset()

wf_set_window_mode(II_UPDATE_ORDERS)

end event

type cb_retrieve from commandbutton within w_pandora_tender_lead_time
integer x = 2734
integer y = 1688
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
boolean default = true
end type

event clicked;dw_tender_lead_time.Trigger Event ue_retrieve()

end event

type cb_add from commandbutton within w_pandora_tender_lead_time
integer x = 3173
integer y = 1688
integer width = 421
integer height = 112
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Add Orders..."
end type

event clicked;wf_set_window_mode(II_ADD_ORDERS)
end event

type cb_close from commandbutton within w_pandora_tender_lead_time
integer x = 3616
integer y = 1688
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
boolean cancel = true
end type

event clicked;parent.Event Post close()
end event

type cb_save from commandbutton within w_pandora_tender_lead_time
integer x = 2286
integer y = 1688
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save"
end type

event clicked;dw_tender_lead_time.Event Trigger ue_save()
end event

type dw_tender_lead_time from u_dw within w_pandora_tender_lead_time
integer x = 37
integer y = 28
integer width = 3977
integer height = 1600
boolean bringtotop = true
string dataobject = "d_pandora_tender_lead_time"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;String ls_error_msg

if dwo.name = 'shipment_scheduled_cbx' then
	if data = '1' then
		String ls_wh_code
		ls_wh_code = this.Object.wh_code[row]

		if NOT IsNull(ls_wh_code) and Trim(ls_wh_code) <> '' then
			this.Object.schedule_date[row] = f_getlocalworldtime(ls_wh_code)
		end if
	end if
end if

// Ensure Shipment ID entered is in the list of original retrieved Shipment IDs
if dwo.name = 'consolidation_no' then
	long ll_found_row
	ll_found_row = ids_original_values.Find("consolidation_no = '" + data + "'", 1, ids_original_values.RowCount())
	if ll_found_row > 0 then

		// Ensure warehouses, destination, awb_bol_no and carrier_pro_no match on the orders being consolidated
		if NOT wf_is_equal(dw_tender_lead_time.Object.wh_code[row], ids_original_values.Object.wh_code[ll_found_row]) then
			ls_error_msg = "Warehouses NOT equal on the orders ~r"
		end if

		if NOT wf_is_equal(dw_tender_lead_time.Object.cust_name[row], ids_original_values.Object.cust_name[ll_found_row]) then
			ls_error_msg += "Customer Name NOT equal on the orders ~r"
		end if
		if NOT wf_is_equal(dw_tender_lead_time.Object.address_1[row], ids_original_values.Object.address_1[ll_found_row]) then
			ls_error_msg += "Address1 NOT equal on the orders ~r"
		end if
		if NOT wf_is_equal(dw_tender_lead_time.Object.address_2[row], ids_original_values.Object.address_2[ll_found_row]) then
			ls_error_msg += "Address2 NOT equal on the orders ~r"
		end if
		if NOT wf_is_equal(dw_tender_lead_time.Object.address_3[row], ids_original_values.Object.address_3[ll_found_row]) then
			ls_error_msg += "Address3 NOT equal on the orders ~r"
		end if
		if NOT wf_is_equal(dw_tender_lead_time.Object.address_4[row], ids_original_values.Object.address_4[ll_found_row]) then
			ls_error_msg += "Address4 NOT equal on the orders ~r"
		end if
		if NOT wf_is_equal(dw_tender_lead_time.Object.city[row], ids_original_values.Object.city[ll_found_row]) then
			ls_error_msg += "City NOT equal on the orders ~r"
		end if
		if NOT wf_is_equal(dw_tender_lead_time.Object.state[row], ids_original_values.Object.state[ll_found_row]) then
			ls_error_msg += "State NOT equal on the orders ~r"
		end if
		if NOT wf_is_equal(dw_tender_lead_time.Object.zip[row], ids_original_values.Object.zip[ll_found_row]) then
			ls_error_msg += "Zip NOT equal on the orders ~r"
		end if

		if NOT wf_is_equal(dw_tender_lead_time.Object.awb_bol_no[row], ids_original_values.Object.awb_bol_no[ll_found_row]) then
			ls_error_msg += "AWB/BOL Nbr NOT equal on the orders ~r"
		end if

		if NOT wf_is_equal(dw_tender_lead_time.Object.carrier_pro_no[row], ids_original_values.Object.carrier_pro_no[ll_found_row]) then
			ls_error_msg += "Pro Nbr NOT equal on the orders ~r"
		end if

		if Len(ls_error_msg) > 0 then
			ls_error_msg = "Validation error on orders:  " + nz(dw_tender_lead_time.Object.invoice_no[row],"null") + ", " + nz(ids_original_values.Object.invoice_no[ll_found_row], "null") + "~r~r" + ls_error_msg
			MessageBox("Validation Error", ls_error_msg, StopSign!)
			
			f_method_trace_special(gs_project, parent.ClassName() , 'Validation error on itemchanged: ' + ls_error_msg,'', '','','')
			Return 1
		end if

		// Validations passed, set the carrier
		dw_tender_lead_time.Object.carrier[row] = ids_original_values.Object.carrier[ll_found_row]		

	else
		ls_error_msg = "Invalid Shipment ID:  " + data + "~r~rPlease enter a Shipment ID that exists in the current window."
		f_method_trace_special(gs_project, parent.ClassName() , 'Validation error on itemchanged: ' + ls_error_msg,'', '','','')
		
		MessageBox("Validation Error", ls_error_msg, StopSign!)
		Return 1
	end if

end if

end event

event ue_save;call super::ue_save;String lsErrText, lsMsg
int li_return

li_return = this.update()

if li_return = 1 then
	SetMicroHelp("Record Saved!")
else
	lsErrText = SQLCA.SQLErrText
	lsMsg = "Unable to save Lead Time data!"
	
	If Not isnull(lsErrText) Then 
		lsMsg += "~r~r" + lsErrText
	End If

	MessageBox("Save Error", lsMsg)
	SetMicroHelp("Save failed!")
end if

if Len(lsMsg) = 0 then
	lsMsg = "Record Saved!"	
end if

f_method_trace_special(gs_project, parent.ClassName() , 'Closing window: ' + lsMsg,'', '','','')

end event

event ue_retrieve;call super::ue_retrieve;if dw_tender_lead_time.modifiedcount( ) > 0 then
	if MessageBox(Parent.title, "Changes have been made.  Do you wish to continue the retrieve, which will lose these changes?", Question!, YESNO!) = 2 then		
		return
	end if
end if

long ll_rows
ll_rows = this.Retrieve(gs_project)

if ll_rows > 0 then
	cb_add.enabled = true
	SetMicroHelp(String(ll_rows) + " OTM Tender Lead Time orders retrieved.")
	
	ids_original_values.Reset()
	dw_tender_lead_time.RowsCopy(1, ll_rows, Primary!, ids_original_values, 1, Primary!)

else
	MessageBox(Parent.title, "No OTM Tender Lead Time orders found.")
end if

end event

event itemerror;call super::itemerror;if dwo.name = 'consolidation_no' then
	return 1
end if
end event

type dw_select from u_dw within w_pandora_tender_lead_time
integer x = 475
integer y = 92
integer width = 3058
integer height = 1428
boolean bringtotop = true
string dataobject = "d_pandora_tender_lead_time"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cbx_candidates_only from checkbox within w_pandora_tender_lead_time
integer x = 475
integer y = 1540
integer width = 3470
integer height = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Consolidation Candidates Only (display only orders that can be consolidated with the highlighted order on the previous window)"
boolean checked = true
end type

event clicked;wf_retrieve_select_dw()

end event

