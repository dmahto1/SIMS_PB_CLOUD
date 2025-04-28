HA$PBExportHeader$w_resend_transactions.srw
$PBExportComments$Comcast - Resend Transactions
forward
global type w_resend_transactions from window
end type
type cbx_1 from checkbox within w_resend_transactions
end type
type rb_update from radiobutton within w_resend_transactions
end type
type cb_savetofile from commandbutton within w_resend_transactions
end type
type rb_order from radiobutton within w_resend_transactions
end type
type st_cnt2 from statictext within w_resend_transactions
end type
type st_cnt1 from statictext within w_resend_transactions
end type
type sle_refnbr from singlelineedit within w_resend_transactions
end type
type st_refnbr from statictext within w_resend_transactions
end type
type st_saveto from statictext within w_resend_transactions
end type
type sle_path from singlelineedit within w_resend_transactions
end type
type rb_tup from radiobutton within w_resend_transactions
end type
type rb_trc from radiobutton within w_resend_transactions
end type
type rb_tsu from radiobutton within w_resend_transactions
end type
type dw_results from datawindow within w_resend_transactions
end type
type st_note1 from statictext within w_resend_transactions
end type
type mle_serial from multilineedit within w_resend_transactions
end type
type st_serial from statictext within w_resend_transactions
end type
type sle_tosite from singlelineedit within w_resend_transactions
end type
type st_tosite from statictext within w_resend_transactions
end type
type st_fromsite from statictext within w_resend_transactions
end type
type sle_fromsite from singlelineedit within w_resend_transactions
end type
type cb_export from commandbutton within w_resend_transactions
end type
type cb_help from commandbutton within w_resend_transactions
end type
type cb_ok from commandbutton within w_resend_transactions
end type
type rb_pallet from radiobutton within w_resend_transactions
end type
type rb_serial from radiobutton within w_resend_transactions
end type
type cb_retrieve from commandbutton within w_resend_transactions
end type
type gb_1 from groupbox within w_resend_transactions
end type
type gb_2 from groupbox within w_resend_transactions
end type
type shl_help from statichyperlink within w_resend_transactions
end type
end forward

global type w_resend_transactions from window
string tag = "Resend Transactions Utility"
integer x = 823
integer y = 360
integer width = 4786
integer height = 1940
boolean titlebar = true
string title = "Comcast EIS Reconcilation/Search and Resend Transactions Utility"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = popup!
long backcolor = 67108864
cbx_1 cbx_1
rb_update rb_update
cb_savetofile cb_savetofile
rb_order rb_order
st_cnt2 st_cnt2
st_cnt1 st_cnt1
sle_refnbr sle_refnbr
st_refnbr st_refnbr
st_saveto st_saveto
sle_path sle_path
rb_tup rb_tup
rb_trc rb_trc
rb_tsu rb_tsu
dw_results dw_results
st_note1 st_note1
mle_serial mle_serial
st_serial st_serial
sle_tosite sle_tosite
st_tosite st_tosite
st_fromsite st_fromsite
sle_fromsite sle_fromsite
cb_export cb_export
cb_help cb_help
cb_ok cb_ok
rb_pallet rb_pallet
rb_serial rb_serial
cb_retrieve cb_retrieve
gb_1 gb_1
gb_2 gb_2
shl_help shl_help
end type
global w_resend_transactions w_resend_transactions

type variables

constant int success = 0
constant int failure = -1
constant string ls_detail_type = "S"

Datastore ids_list, ids_order, ids_recd, ids_content, ids_dlvd, ids_outb, ids_pallet, ids_serial

string is_text, is_append1, is_append2, is_append3, is_append4, is_append5  // 32k limit per string * 4 equals 128k file
string is_append6, is_append7, is_append8, is_append9, is_append10
String is_tran_type = "TSU"
String is_linefeed = "~r~n"
String is_status = ""
String is_refnbr = ""
String	is_msg
String is_path
String is_order
String is_po_no

string is_file, is_time
datetime idt_dtime 
string is_year

long il_rows = 0

int ii_filenum
int ii_result = 0
int ii_flg = 0

time start_time, end_time
long il_timing




end variables

forward prototypes
public function integer uf_load_result (string as_serial, string as_model)
public function integer uf_retrieve_serial ()
public function integer uf_valid_comcast_site (string assite)
public function integer uf_valid_menlo_site (string assite)
public function integer uf_add_transaction (string as_line)
public function integer uf_send_file (string as_pallet)
public function integer uf_retrieve_order ()
public function integer uf_get_content ()
public function integer uf_get_outbound ()
public function datetime f_datetime (string as_datetime)
public function integer uf_get_serials ()
public function string uf_get_product_model (string as_sku, string as_supplier)
public function integer uf_validate_from_to_site ()
public function integer uf_pallet_count (string as_pallet)
public function integer uf_get_avail_qty (string as_rono, string as_pallet)
public function integer uf_get_model ()
public function integer uf_retrieve_pallet ()
public function string uf_get_pallets (string as_order, string as_o_no, string as_c_dt, string as_status)
public function integer uf_get_sik (string as_pallet, string as_dono)
public function long uf_get_list ()
public function string uf_get_supplier (string as_owner_id)
public function string uf_get_serial_count (string as_serial)
public function string uf_get_eis_rollup_model (string as_model)
public function string uf_get_model (string as_sku, string as_supp_code)
protected function integer uf_get_pallet_serials (string as_pallet, string as_order, string as_wh, string as_compl_date, string as_status, string as_model, string as_bolid)
public function integer uf_get_workorder (integer ai_record)
public function integer uf_instock (string as_palletid)
public function integer uf_get_transferred ()
public function integer uf_get_transferred (string as_pallet)
end prototypes

public function integer uf_load_result (string as_serial, string as_model);int li_row
string ls_pallet, ls_addr1, ls_addr2, ls_addr3, ls_addr4, ls_addr5, ls_attr1, ls_attr2, ls_attr3, ls_attr4, ls_attr5
string ls_bolid

ls_bolid = ""

		// Get PalletID for Serial Number using carton_serial.serial_no field
		select  cs.pallet_id, cs.user_field1, cs.user_field2, cs.user_field3, cs.user_field4, cs.user_field5, cs.user_field6, cs.user_field7, cs.user_field8, cs.user_field9, cs.user_field10
		into :ls_pallet, :ls_addr1, :ls_addr2, :ls_addr3, :ls_addr4, :ls_addr5
		from carton_serial cs with (nolock)
		where cs.project_id = :gs_project
		and cs.serial_no = :as_serial;
		
	if isnull(ls_addr1) then ls_addr1 = ""
	if isnull(ls_addr2) then ls_addr2 = ""
	if isnull(ls_addr3) then ls_addr3 = ""
	if isnull(ls_addr4) then ls_addr4 = ""
	if isnull(ls_addr5) then ls_addr5 = ""
	if isnull(ls_attr1) then ls_attr1 = ""
	if isnull(ls_attr2) then ls_attr2 = ""
	if isnull(ls_attr3) then ls_attr3 = ""
	if isnull(ls_attr4) then ls_attr4 = ""
	if isnull(ls_attr5) then ls_attr5 = ""
	if isnull(ls_bolid) then ls_bolid = ""

	// Load dw_results
	li_row = dw_results.insertrow(0)
	dw_results.SetItem(li_row,'trantype', is_tran_type)
	dw_results.SetItem(li_row,'fromsite', sle_fromsite.text)
	dw_results.SetItem(li_row,'tosite', sle_tosite.text)
	dw_results.SetItem(li_row,'serialnbr', as_serial)
	dw_results.SetItem(li_row,'pallet', ls_pallet)
	dw_results.SetItem(li_row,'bolid', ls_bolid)
	dw_results.SetItem(li_row,'detailtype', ls_detail_type)
	dw_results.SetItem(li_row,'model', as_model)
	dw_results.SetItem(li_row,'addr1', ls_addr1)
	dw_results.SetItem(li_row,'addr2', ls_addr2)
	dw_results.SetItem(li_row,'addr3', ls_addr3)
	dw_results.SetItem(li_row,'addr4', ls_addr4)
	dw_results.SetItem(li_row,'addr5', ls_addr5)
	dw_results.SetItem(li_row,'attr1', ls_attr1)
	dw_results.SetItem(li_row,'attr2', ls_attr2)
	dw_results.SetItem(li_row,'attr3', ls_attr3)
	dw_results.SetItem(li_row,'attr4', ls_attr4)
	dw_results.SetItem(li_row,'attr5', ls_attr5)

return li_row

end function

public function integer uf_retrieve_serial ();int  li_serial_count, li_row, li_rows, li_pos1, li_pos2, li_len, li_flag, li_pallet, li_p_row, li_p_rows, li_p_count, li_c_count, li_s_row, li_s_rows
string ls_serial, ls_model, ls_serial_nbrs, ls_pallet, ls_last_pallet, ls_rono, ls_dono, ls_wh, ls_compl_date
string ls_sku, ls_supp_code, ls_status, ls_bolid

DECLARE r_pallet CURSOR FOR
select TOP 1 rm.ro_no, rm.supp_invoice_no, rm.complete_date, rm.wh_code, rtrim(rp.sku) + "^" + rp.supp_code, rp.po_no
from receive_master rm, receive_putaway rp with (nolock)
where rm.project_id = :gs_project and rp.ro_no = rm.ro_no
and rp.lot_no = :ls_pallet 
and rm.ord_status = 'C'
order by rm.complete_date desc
;

DECLARE w_pallet CURSOR FOR
select wm.wo_no, wm.workorder_number, wm.complete_date, wm.wh_code, rtrim(wp.sku) + "^" + wp.supp_code,
	wm.workorder_number
from workorder_master wm, workorder_putaway wp
where wm.project_id = 'Comcast' and wp.wo_no = wm.wo_no
and wp.lot_no = :ls_pallet
and wm.ord_status = 'C'
;

DECLARE i_serial CURSOR FOR
select dm.do_no, dm.invoice_no, dm.complete_date, dm.wh_code + "->" + dm.cust_code, dsd.serial_no, dpd.po_no 
from delivery_master dm, delivery_picking_detail dpd, delivery_serial_detail dsd with (NOLOCK)
where dm.project_id = :gs_project and dpd.do_no = dm.do_no 
and dsd.id_no = dpd.id_no and dpd.lot_no = :ls_pallet;

ii_result = 1
li_rows = 0
is_msg = ""
ls_bolid = ""
li_p_count = 0
li_c_count = 0

start_time = TIME(now())

li_serial_count = uf_get_model()

if li_serial_count > 0 then
	SetPointer(Hourglass!)
	w_main.setmicrohelp("Looking up serial numbers to process.  Please wait.")
	
	// Have all serial numbers loaded into dw_results.  Need recd/delv orders, wh, compldate info
	// Get individual pallet IDs and check for In Stock
	dw_results.SetSort("pallet, serialnbr")
	dw_results.Sort()
	li_rows = dw_results.RowCount()
	if li_rows > 0 then 
		ls_last_pallet = dw_results.GetItemString(1, "pallet") 
		ls_model = dw_results.GetItemString(1, "model")
		li_pallet = ids_pallet.InsertRow(0)
		ids_pallet.SetItem(li_pallet,"pallet", ls_last_pallet)
		ids_pallet.SetItem(li_pallet,"field3",ids_serial.GetItemString(li_pallet,"field2"))		// sku
		ids_pallet.SetItem(li_pallet,"field4",ids_serial.GetItemString(li_pallet,"field3"))		// supp code
		ids_pallet.SetItem(li_pallet,"field5", ls_model)
		ids_pallet.SetItem(li_pallet,"field6", ls_status)
		ids_pallet.SetItem(li_pallet,"field7", is_po_no)
		ids_pallet.SetItem(li_pallet,"field8", ls_bolid)
	end if
	
	for li_row = 1 to li_rows 
		ls_pallet = dw_results.GetItemString(li_row, "pallet")
		if ls_pallet <> ls_last_pallet then
			ls_last_pallet = ls_pallet
			li_pallet = ids_pallet.InsertRow(0)
			ids_pallet.SetItem(li_pallet,"pallet", ls_last_pallet)
			ids_pallet.SetItem(li_pallet,"field3",ids_serial.GetItemString(li_pallet,"field2"))
			ids_pallet.SetItem(li_pallet,"field4",ids_serial.GetItemString(li_pallet,"field3"))
			ids_pallet.SetItem(li_pallet,"field5", ls_model)
			ids_pallet.SetItem(li_pallet,"field6", ls_status)
			ids_pallet.SetItem(li_pallet,"field7", is_po_no)
		end if
	next
	
	ls_last_pallet = ""
	li_rows = ids_pallet.RowCount()
	
	w_main.setmicrohelp("Serial numbers lookup for inbound.  Please wait.")
	
	// Retrieve inbound order data
	for li_row = 1 to li_rows
		ls_pallet = ids_pallet.GetItemString(li_row,"pallet")
		ls_sku = ids_pallet.GetItemString(li_row,"field3")
		ls_supp_code = ids_pallet.GetItemString(li_row,"field4")
		is_po_no = ids_pallet.GetItemString(li_row,"field7")
		li_p_count = 0
		li_c_count = 0
		
		
		OPEN r_pallet;
		if SQLCA.SQLCODE <>0 then
			MessageBox("Error opening cursor r_pallet in uf_retrieve_serial",SQLCA.SQLErrText)
		else
			Fetch r_pallet Into :ls_rono, :is_order,:ls_compl_date, :ls_wh, :ls_model, :is_po_no;
			if SQLCA.SQLCODE <> 0 then
				ids_pallet.SetItem(li_row,"field6","W")		// Not found in inbound, check work orders
				ids_pallet.SetItem(li_row,"field3","")			// Reset wh
				OPEN w_pallet;
				if SQLCA.SQLCODE <> 0 then
					MessageBox("Error opening cursor w_pallet in uf_retrieve_serial",SQLCA.SQLErrText)
				else
					Fetch w_pallet Into :ls_rono, :is_order,:ls_compl_date, :ls_wh, :ls_model, :is_po_no;
					if SQLCA.SQLCODE <> 0 then
						ids_pallet.SetItem(li_row,"field6","X")		// Not found in inbound or work orders
					else
						ids_pallet.SetItem(li_row,"field1", is_order)
						ids_pallet.SetItem(li_row,"field2", ls_rono)
						ids_pallet.SetItem(li_row,"field3", string(DATE(f_datetime(ls_compl_date))))
						ids_pallet.SetItem(li_row,"field4", ls_wh)
						ids_pallet.SetItem(li_row,"field5", ls_model)
						ids_pallet.SetItem(li_row,"field7", is_po_no)
						ids_pallet.SetItem(li_row,"field6", "W")
					end if
					CLOSE w_pallet;
				end if
			else
				ids_pallet.SetItem(li_row,"field1", is_order)
				ids_pallet.SetItem(li_row,"field2", ls_rono)
				ids_pallet.SetItem(li_row,"field3", string(DATE(f_datetime(ls_compl_date))))
				ids_pallet.SetItem(li_row,"field4", ls_wh)
				ids_pallet.SetItem(li_row,"field5", ls_model)
				ids_pallet.SetItem(li_row,"field7", is_po_no)
				ids_pallet.SetItem(li_row,"field6", "R")
			end if
			
			if ids_pallet.GetItemString(li_row,"field6") <> "X" then
				// Receive order found, check for InStock
				w_main.setmicrohelp("Checking for In Stock orders.  Please wait.")
				li_p_count = uf_pallet_count(ls_pallet)
				li_c_count = uf_get_avail_qty(ls_rono, ls_pallet)
				if li_c_count = 0 then								// Not in stock, check delivery
					ids_pallet.SetItem(li_row,"field6","X")
				elseif li_c_count = li_p_count then
					ids_pallet.SetItem(li_row,"field6","I")
				else
					ids_pallet.SetItem(li_row,"field6","P")		// Partial pallet outbound
					w_main.setmicrohelp("Processing partial pallet delivery.  Please wait.")
					
					MessageBox("Checking for Partial Pallet","Serial number is part of PalletID: " + ls_pallet +", which is deemed partial pallet.~rPalletCount:" +string(li_p_count) + " - ContentSummaryQuantity:" + string(li_c_count))
					
					ids_serial.Reset()
					OPEN i_serial;
					if SQLCA.SQLCODE <> 0 then
						MessageBox("Error opening cursor i_serial in uf_retrieve_serial",SQLCA.SQLErrText)
					else
						Fetch i_serial Into :ls_dono, :is_order, :ls_compl_date, :ls_wh, :ls_serial, :is_po_no;
						DO WHILE SQLCA.SQLCODE <> 100
							li_s_row = ids_serial.InsertRow(0)
							ids_serial.SetItem(li_s_row,"pallet",ls_serial)		// Use pallet field to hold serialNo
							ids_serial.SetItem(li_s_row,"field4",ls_wh)
							ids_serial.SetItem(li_s_row,"field1",is_order)
							ids_serial.SetItem(li_s_row,"field3",ls_compl_date)
							ids_serial.SetItem(li_s_row,"field2",ls_dono)
							ids_serial.SetItem(li_s_row,"field7",is_po_no)
							Fetch i_serial Into  :ls_dono, :is_order, :ls_compl_date, :ls_wh, :ls_serial, :is_po_no;
						LOOP
					end if
					CLOSE i_serial;
					//messagebox("Pallet Count","Carton_Serial: " + string(li_p_count) + " - Content_Summary: " + string(li_c_count) + " - Count:" + string(li_s_row))
					li_s_row = ids_serial.RowCount()
				end if
			end if
		end if
		CLOSE r_pallet;
	next

	
	
	
	w_main.setmicrohelp("Checking SN pallet data for outbound orders.  Please wait.")
	li_p_rows = ids_pallet.RowCount()
	for li_p_row = 1 to li_p_rows
		if ids_pallet.GetItemString(li_p_row,"field6") = "X" then
			li_p_count = uf_get_outbound()
		elseif ids_pallet.GetItemString(li_p_row,"field6") = "I" then
			li_p_count = uf_get_transferred(ids_pallet.GetItemString(li_p_row,"pallet"))
		end if
	next
	
	w_main.setmicrohelp("Adding pallet data to dw_results.  Please wait.")
	
	// Add pallet/order date to dw_results
	li_p_rows = ids_pallet.RowCount()
	li_rows = dw_results.RowCount()
	li_pallet = 1
	li_flag = 0
	for li_row = 1 to li_rows
		ls_pallet = dw_results.GetItemString(li_row,"pallet")
		for li_p_row = 1 to li_p_rows
			if ids_pallet.GetItemString(li_p_row,"pallet") = ls_pallet then
				dw_results.SetItem(li_row,"warehouse",ids_pallet.GetItemString(li_p_row,"field4"))
				dw_results.SetItem(li_row,"tsorder",ids_pallet.GetItemString(li_p_row,"field1"))
				dw_results.SetItem(li_row,"bolid",ids_pallet.GetItemString(li_p_row,"field1"))		// Set BOL ID to order no
				dw_results.SetItem(li_row,"compldate",ids_pallet.GetItemString(li_p_row,"field3"))
				dw_results.SetItem(li_row,"po_no",ids_pallet.GetItemString(li_p_row,"field7"))
			end if
		next
	next
	
		w_main.setmicrohelp("Serial numbers: Checking for partial pallets.  Please wait.")
	//If partial pallet outbound, overlay serial data in dw_results
		li_s_rows = ids_serial.RowCount()
		for li_s_row = 1 to li_s_rows
			ls_serial = ids_serial.GetItemString(li_s_row,"pallet")
			li_p_rows = dw_results.RowCount()
			for li_p_row = 1 to li_p_rows
				if dw_results.GetItemString(li_p_row,"serialnbr") = ls_serial then
					ls_compl_date = string(DATE(f_datetime( ids_serial.GetItemString(li_s_row,"field3") )))
					dw_results.SetItem(li_p_row,"warehouse",ids_serial.GetItemString(li_s_row,"field4"))
					dw_results.SetItem(li_p_row,"tsorder",ids_serial.GetItemString(li_s_row,"field1"))
					dw_results.SetItem(li_p_row,"bolid",ids_serial.GetItemString(li_s_row,"field1"))		// Set BOL ID to order no
					dw_results.SetItem(li_p_row,"po_no",ids_serial.GetItemString(li_s_row,"field7"))
					dw_results.SetItem(li_p_row,"compldate",  ls_compl_date)
				end if
			next
		next
end if	
	
il_rows = ids_list.RowCount()
is_msg = ""
for li_row = 1 to il_rows
	ls_serial = ids_list.GetItemString(li_row,"find_column")
	ls_status = ids_list.GetItemString(li_row,"find_value")
	CHOOSE CASE ls_status
		CASE "N"
			is_msg += "SerialNo " + trim(ls_serial) + " was not found~n"
		CASE "M"
			is_msg += "SerialNo " + trim(ls_serial) + " has Carton/Serial data but Receive Order not found~n"
		CASE "E"
			is_msg += "Error found when searching for SerialNo " + ls_serial + "~n"
	END CHOOSE
next
		
SetPointer(Arrow!)
w_main.setmicrohelp("Ready")

end_time = TIME(now())
il_timing = secondsafter(start_time, end_time)
//MessageBox("Timing for function uf_get_outbound", "Start: " + string( start_time) + " -- Stop: " + string(end_time) + " -- Timing: " + string(il_timing))

return ii_result

end function

public function integer uf_valid_comcast_site (string assite);int li_return
String ls_vsite

li_return = 0

// Not a valid entry for a Comcast site
if asSite = 'DUMMY' or isNull(asSite) or asSite = '' then
	li_return = -1
else
	// Get valid Comcast site from customer.user_field3
	select user_field3 into :ls_vsite
	from customer
	where project_id = :gs_project
	and user_field3 = :asSite
	;
	
	if SQLCA.SQLCode <> 0 then
		li_return = -1
	else
		if SQLCA.SQLCode = 100 then
			li_return = 0
		else
			li_return = 1		// Passed
		end if
	end if
end if

return li_return
end function

public function integer uf_valid_menlo_site (string assite);int li_return
String ls_vsite

li_return = 0

if asSite = 'VMEN01' or asSite = 'VMEN02' or asSite = 'VMEN03' or asSite = 'VMEN04'  or asSite = 'VMEN05' or &
	asSite = 'VMES01' or asSite = 'VMES02' or asSite = 'VMES03' or asSite = 'VMES04' then
	li_return = 1
end if

return li_return

end function

public function integer uf_add_transaction (string as_line);integer li_return
li_return = 0

		// Allow five strings of 32,000 char each for 162k file size
		if len(is_append1) <= 32000 then
			is_append1 += as_line + is_linefeed
		elseif len(is_append1) > 32000 and len(is_append2) <= 32000 then
			is_append2 += as_line + is_linefeed
		elseif len(is_append1) > 32000 and len(is_append1) > 32000 and len(is_append3) <= 32000 then
			is_append3 += as_line + is_linefeed
		elseif len(is_append1) > 32000 and len(is_append2) > 32000 and len(is_append3) > 32000 and len(is_append4) <= 32000 then
			is_append4 += as_line + is_linefeed
		elseif len(is_append1) > 32000 and len(is_append2) > 32000 and len(is_append3) > 32000 and len(is_append4) > 32000 and len(is_append5) <= 32000 then
			is_append5 += as_line + is_linefeed
		elseif len(is_append1) > 32000 and len(is_append2) > 32000 and len(is_append3) > 32000 and len(is_append4) > 32000 and len(is_append5) > 32000 &
				and len(is_append6) <= 32000 then
			is_append6 += as_line + is_linefeed
		elseif len(is_append1) > 32000 and len(is_append2) > 32000 and len(is_append3) > 32000 and len(is_append4) > 32000 and len(is_append5) > 32000 &
				and len(is_append6) > 32000 and len(is_append7) <= 32000 then 
			is_append7 += as_line + is_linefeed
		elseif len(is_append1) > 32000 and len(is_append2) > 32000 and len(is_append3) > 32000 and len(is_append4) > 32000 and len(is_append5) > 32000 &
				and len(is_append6) > 32000 and len(is_append7) > 32000 and len(is_append8) <= 32000 then  
			is_append8 += as_line + is_linefeed
		elseif len(is_append1) > 32000 and len(is_append2) > 32000 and len(is_append3) > 32000 and len(is_append4) > 32000 and len(is_append5) > 32000 &
				and len(is_append6) > 32000 and len(is_append7) > 32000 and len(is_append8) > 32000 and len(is_append9) <= 32000 then  
			is_append9 += as_line + is_linefeed
		elseif len(is_append1) > 32000 and len(is_append2) > 32000 and len(is_append3) > 32000 and len(is_append4) > 32000 and len(is_append5) > 32000 &
				and len(is_append6) > 32000 and len(is_append7) > 32000 and len(is_append8) > 32000 and len(is_append9) > 32000 and len(is_append10) <= 32000 then  
			is_append10 += as_line + is_linefeed
		else
			MessageBox("File Size Limitation Reached!","File cannot exceed 320k.  " )	
			li_return = failure
		end if

return li_return

end function

public function integer uf_send_file (string as_pallet);int li_return, li_result
string ls_userid

ls_userid = right(gs_userid,len(gs_userid) - pos(gs_userid,"\"))

li_return = success
is_year = String(Today(), "yymmdd")
idt_dtime =  datetime(Today(), Now())
is_time = Left(String(Time(idt_dtime)),2) + Mid(String(Time(idt_dtime)),4,2) + right(String(Time(idt_dtime)),2)
is_file = 'GR' +is_year+is_time+"-"+trim(as_pallet)+"-" + UPPER(ls_userid) + ".DAT"


ii_filenum = FileOpen(is_path+is_file,StreamMode!,Write!,Shared!,Replace!)
If ii_filenum >= 0 then
	li_result = FileWrite(ii_filenum,is_append1)
	if li_result <= 0 then
		MessageBox("Error Writing File","Could not write data to " + is_path + is_file)
		li_return = failure
	else
		if len(is_append1) > 0 then
			FileClose(ii_filenum)
			ii_filenum = FileOpen(is_path+is_file,StreamMode!,Write!,Shared!,Append!)
			if ii_filenum >= 0 then
					li_result = FileWrite(ii_filenum,is_append2)
				if len(is_append2) > 0 then
						li_result = FileWrite(ii_filenum, is_append3)
					if len(is_append3) > 0 then
						li_result = FileWrite(ii_filenum, is_append4)
						if len(is_append4) > 0 then
							li_result = FileWrite(ii_filenum, is_append5)
							if len(is_append5) > 0 then
								li_result = FileWrite(ii_filenum, is_append6)
								if len(is_append6) > 0 then
									li_result = FileWrite(ii_filenum, is_append7)
									if len(is_append7) > 0 then
										li_result = FileWrite(ii_filenum, is_append8)
										if len(is_append8) > 0 then
											li_result = FileWrite(ii_filenum, is_append9)
											if len(is_append9) > 0 then
												li_result = FileWrite(ii_filenum, is_append10)
											end if
										end if
									end if
								end if
							end if
						end if
					end if
				end if
			end if
		end if
					
		// Success!
		is_msg += "Saved " + is_path+is_file + is_linefeed
		//MessageBox("Export file created and saved to:",is_path+is_file )
		FileClose(ii_filenum)
	end if
else
	MessageBox("Error Opening File","Trying to open " + is_file + " in folder: " + is_path)
end if
			
// Reset temp variables
is_append1 = '' 
is_append2 = ''
is_append3 = ''
is_append4 = ''
is_append5 = ''
is_append6 = '' 
is_append6 = ''
is_append8 = ''
is_append9 = ''
is_append10 = ''

return li_return

end function

public function integer uf_retrieve_order ();int li_row, li_r_row, li_d_row, li_p_row, li_s_row, li_s_rows, li_result
string ls_rono, ls_ro_cd, ls_lot_no, ls_wh_code, ls_d_flag, ls_do_no, ls_do_cd
string ls_pallet, ls_status

ids_order.Reset()
ids_recd.Reset()
ids_content.Reset()
ids_dlvd.Reset()
ids_outb.Reset()
ids_pallet.Reset()
// Take order list from ids_list and copy it to ids_order - reset ids_list and use it for pallets

il_rows = ids_list.RowCount()
for li_row = 1 to il_rows
	li_r_row = ids_order.InsertRow(0)
	ids_order.SetItem(li_r_row,'find_column',ids_list.GetItemString(li_row,'find_column'))
	ids_order.SetItem(li_r_row,'find_value',ids_list.GetItemString(li_row,'find_value'))
next

// Declare the cursor
DECLARE r_order CURSOR FOR 
select ro_no, MAX(complete_date) from receive_master
where project_id = :gs_project and supp_invoice_no = :is_order
group by ro_no;

DECLARE d_order CURSOR FOR
select rtrim(do_no), MAX(complete_date) from delivery_master with (nolock)
where project_id =:gs_project and invoice_no = :is_order
and ord_status = 'C'
group by do_no;

DECLARE d_outb CURSOR FOR
select dp.lot_no, rtrim(w.user_field1) + '->' + rtrim(c.user_field3) as wh
from delivery_master dm, delivery_picking dp, customer c, warehouse w with (nolock)
where dm.project_id = :gs_project and dp.do_no = dm.do_no
and c.cust_code = dm.cust_code and w.wh_code = dm.wh_code
and dm.do_no = :ls_do_no;

SetPointer(Hourglass!)
w_main.setmicrohelp("Looking up orders to process.  Please wait.")
start_time = TIME(now())

// First look in Receive Master to determine if this is an inbound order
il_rows = ids_order.RowCount()
for li_row = 1 to il_rows
	is_order = ids_order.GetItemString(li_row,'find_column')
	ls_rono = ''
	ls_ro_cd = ''
	OPEN r_order;
	
	if SQLCA.SQLCODE <>0 then
		MessageBox("Error opening cursor r_order",SQLCA.SQLErrText)
	else
		Fetch r_order Into :ls_rono, :ls_ro_cd;
		li_r_row = ids_recd.InsertRow(0)
		if SQLCA.SQLCODE = 100 then		// Not a receive order... Mark for outbound check
			ids_recd.SetItem(li_r_row,'find_column',ids_list.GetItemstring(li_r_row,'find_column'))
			ids_recd.SetItem(li_r_row,'find_value','None')
			ids_order.SetItem(li_r_row,'find_value','D')
				// Check delivery orders
				OPEN d_order;
				if SQLCA.SQLCODE <> 0 then
					MessageBox("Error opening cursor d_order",SQLCA.SQLErrText)
				else
					li_r_row = 1
					Fetch d_order Into :ls_do_no, :ls_do_cd;
					if SQLCA.SQLCODE = 100 then			// No content for this order..  Delivered?
						ids_recd.SetItem(li_row,'find_value','NoDelivery')
						ids_order.SetItem(li_row,'find_value','N')
					else
						DO WHILE SQLCA.SQLCODE <> 100
							li_r_row = ids_dlvd.InsertRow(0)
							ids_dlvd.SetItem(li_r_row,'find_column',ls_do_no)
							ids_dlvd.SetItem(li_r_row,'find_value',ls_do_cd)
							
							ls_status = uf_get_pallets(is_order, ls_do_no, ls_do_cd, 'D')	//Get pallets
							Fetch d_order Into :ls_do_no, :ls_do_cd;
							li_r_row = li_r_row + 1
						LOOP
					end if
				end if
				CLOSE d_order;

		else										// Found inbound order.... get pallets into ids_pallet
			ids_recd.SetItem(li_r_row,'find_column',ls_rono)
			ids_recd.SetItem(li_r_row,'find_value',ls_ro_cd)
			ls_status = uf_get_pallets(is_order, ls_rono, ls_ro_cd, 'R')		//Get pallets
		end if
	end if
	CLOSE r_order;
next

// Get outbound information for received order no longer in stock
if ls_status = "X" then
	// Get serial numbers for outbound orders
	li_p_row = uf_get_outbound()
end if

// Get serial data
li_p_row = uf_get_serials()

SetPointer(Hourglass!)
w_main.setmicrohelp("Processing pallets for serial number processing.  Please wait.")

il_rows = ids_pallet.RowCount()
if il_rows > 0 then
	is_msg = ''
	for li_row = 1 to il_rows
		is_msg = is_msg + "Order: " + ids_pallet.GetItemString(li_row,'field1') + &
		" - PalletID: " + ids_pallet.GetItemString(li_row,'pallet') + &
		", OrdNo: " + ids_pallet.GetItemString(li_row,'field2') + &
		", ComplDate: " +  string(DATE(f_datetime(ids_pallet.GetItemString(li_row,'field3')))) + &
		", WH: " + ids_pallet.GetItemString(li_row,'field4') + &
		", Status: " + ids_pallet.GetItemString(li_row,'field6') + &
		"~n"
	next
//	is_msg +="'~n~nDo you wish to save this pallet report?"
//	if messagebox("Pallet datastore",is_msg,Question!,yesNo!) = 1 then
//		
//		ids_pallet.SaveAs("c:\flatfileout\palletlist.xls",Excel!,TRUE)
//		
//	end if
end if

il_rows = ids_order.RowCount()
is_msg = ""
for li_row = 1 to il_rows
	is_order = ids_order.GetItemString(li_row,"find_column")
	ls_status = ids_order.GetItemString(li_row,"find_value")
	CHOOSE CASE ls_status
		CASE "N"
			is_msg += "OrderlNo " + trim(is_order) + " was not found~n"
		CASE "M"
			is_msg += "OrderNo " + trim(is_order) + " has Carton/Serial data but Receive Order not found~n"
		CASE "E"
			is_msg += "Error found when searching for OrderlNo " + is_order + "~n"
	END CHOOSE
next

end_time = TIME(now())
il_timing = secondsafter(start_time, end_time)
//MessageBox("Timing for function uf_get_outbound", "Start: " + string( start_time) + " -- Stop: " + string(end_time) + " -- Timing: " + string(il_timing))

SetPointer(Arrow!)
w_main.setmicrohelp("Ready")

return dw_results.RowCount()

end function

public function integer uf_get_content ();/**********************************************************
* All pallet records in r_pallet will be check to see if they are in content_summary.
* The status field will be modified to I for InStock or D to check for delivery.
**********************************************************/
int li_p_row, li_nbr_rows, li_X, li_I
string ls_pallet, ls_lot_no, is_order_no, ls_ro_no, ls_wh_cd

li_X = 0
li_I = 0

DECLARE r_content CURSOR FOR
select lot_no from content_summary with (NOLOCK)
where project_id = 'Comcast' and lot_no = :ls_pallet
and ro_no = :ls_ro_no;

SetPointer(Hourglass!)
w_main.setmicrohelp("Looking in content summary for pallets.  Please wait.")

// Get content for all received pallets
li_nbr_rows = ids_pallet.RowCount()
for li_p_row = 1 to li_nbr_rows
	ls_pallet = ids_pallet.GetItemString(li_p_row,'pallet')
	ls_ro_no = ids_pallet.GetItemString(li_p_row,'field2')
	OPEN r_content;
	if SQLCA.SQLCODE <> 0 then
		MessageBox("Error opening cursor r_content",SQLCA.SQLErrText)
	else
		Fetch r_content Into :ls_lot_no;
		if SQLCA.SQLCODE = 100 then			
			ids_pallet.SetItem(li_p_row,'field6','X')	// No content for this pallet... mark status X (check for delivery)
			li_X = li_X + 1
		else
			ids_pallet.SetItem(li_p_row,'field6','I')	// Pallet in stock... mark status I
			li_I = li_i + 1
		end if
	end if
	CLOSE r_content;
next

SetPointer(Arrow!)
w_main.setmicrohelp("Ready")

//messagebox("uf_get_content","Marked I: " + string(li_I) + " and number marked X: " + string(li_X))

return 0



end function

public function integer uf_get_outbound ();/*********************************************************
* Check outbound for receive order where pallet is not in stock.  If found, change 
* status to O, if not found leave status as X....(was received & instock but not
* deliver---error status).  The Status O will also change the compl date to be
* the delivery order complete date and warehouse will be Menlo Site ID -> EIS
* Site ID.   ** Check ids_pallet for status X ***
*********************************************************/
string ls_pallet, ls_o_no, ls_i_order, ls_compl_date, ls_wh_code, ls_dest, ls_status
string ls_sku, ls_supp_code, ls_model, ls_bolid
date ld_dt01, ls_dt02
int  li_o_row, li_o_rows, li_r_row, li_pos, li_len
datetime ldt_compl_date
date ld_cdate, ld_last_cdate

// This query takes to long.... rethink the process!!!
DECLARE o_pallet CURSOR FOR
select TOP 4 dp.lot_no, rtrim(dm.wh_code) + '->' + rtrim(dm.cust_code), 
		dm.complete_date, dm.do_no, dm.invoice_no, dm.cust_code, dp.po_no
from delivery_master dm, delivery_picking dp with (nolock)
where dm.project_id = :gs_project
//and dm.complete_date >= :ldt_compl_date 	(Not part of index)
and dp.do_no = dm.do_no 
and dp.lot_no = :ls_pallet 
//and dm.wh_code = :ls_warehouse   (Could not use warehouse for wh transfers)
and dp.sku = :ls_sku 
and dp.supp_code = :ls_supp_code;

DECLARE x_pallet CURSOR FOR
select TOP 4 dp.lot_no, rtrim(dm.wh_code) + '->' + rtrim(dm.cust_code), 
		dm.complete_date, dm.do_no, dm.invoice_no, dm.cust_code, dp.po_no
from delivery_master dm, delivery_picking dp with (nolock)
where dm.project_id = :gs_project
and dp.do_no = dm.do_no and dp.lot_no = :ls_pallet
and dp.sku = :ls_sku;


SetPointer(Hourglass!)

li_o_rows = ids_pallet.RowCount()
for li_o_row = 1 to li_o_rows
	ls_pallet = ids_pallet.GetItemString(li_o_row,'pallet')
	w_main.setmicrohelp("Record: " + string(li_o_row) + " - Lookup outbound order for PalletID: " + ls_pallet)
	ls_i_order = ids_pallet.GetItemString(li_o_row,'field1')
	ls_o_no = ids_pallet.GetItemString(li_o_row,'field2')
	ls_compl_date = ids_pallet.GetItemString(li_o_row,'field3')
	ls_wh_code = ids_pallet.GetItemString(li_o_row,'field4')
	ls_sku = ids_pallet.GetItemString(li_o_row,'field5')
	ls_status = ids_pallet.GetItemString(li_o_row,'field6')
	is_po_no = ids_pallet.GetItemString(li_o_row,"field7")
	ls_bolid = ids_pallet.GetItemString(li_o_row,"field8")
	
	if isnull(ls_compl_date) then ls_compl_date = "'01/01/1900 00:00:00"
	ldt_compl_date = f_datetime(ls_compl_date)
	li_len = Len(ls_sku)
	li_pos = Pos(ls_sku, "^")
	
	if li_pos > 0 then
		ls_supp_code = Mid(ls_sku,li_pos+1,li_len)
		ls_sku = Left(ls_sku,li_pos -1)
	else
		ls_supp_code = ls_o_no 	// From temporary holding
	end if
	
	if isnull(ls_o_no) then ls_status = "N" 		// Receive order not found.. check for outbound the hard way, or not at all
	
	if ls_status = 'X' then		// Process only received records no longer in stock or where no receive order is found
		if ls_o_no = "" then
			w_main.setmicrohelp("Looking up outbound orders by pallet without inbound data.  Please wait...  long wait!")
			OPEN x_pallet;
			if SQLCA.SQLCODE <> 0 then
				MessageBox("Error opening cursor o_pallet in uf_get_outbound",SQLCA.SQLErrText)
			else
				li_r_row = 1
				Fetch x_pallet Into :ls_pallet, :ls_wh_code, :ls_compl_date, :ls_o_no, :ls_i_order, :ls_dest, :is_po_no;
				if SQLCA.SQLCODE = 100 then			// No pallets for this order.. 
					//messagebox("Reading pallets for outbound order","No order associated with PalletID " + ls_pallet + ". Check for SIK outbound.")
					ids_pallet.SetItem(li_o_row,'field6','S')	//SIK-Customer
				else
					ld_last_cdate = DATE(f_datetime(ls_compl_date))
					DO WHILE SQLCA.SQLCODE <> 100
						if ld_last_cdate = ld_cdate then
							ids_pallet.SetItem(li_o_row,'field1',ls_i_order)
							ids_pallet.SetItem(li_o_row,'field2',ls_o_no)
							ids_pallet.SetItem(li_o_row,'field3',string(DATE(f_datetime(ls_compl_date))))
							ids_pallet.SetItem(li_o_row,'field4',ls_wh_code)
							if ls_dest = 'CUSTOMER' then
								ids_pallet.SetItem(li_o_row,'field6','S')	//SIK-Customer
							else
								ids_pallet.SetItem(li_o_row,'field6','O')	//Regular outbound
							end if
							ids_pallet.SetItem(li_o_row,'field7',is_po_no)
						end if
						Fetch x_pallet Into :ls_pallet, :ls_wh_code, :ls_compl_date, :ls_o_no, :ls_i_order, :ls_dest, :is_po_no;
						ld_cdate = DATE(f_datetime(ls_compl_date))
						if ld_cdate > ld_last_cdate then
							ld_cdate = ld_last_cdate
						end if
					LOOP
				end if
			end if
			CLOSE x_pallet;
		else
			w_main.setmicrohelp("Looking up outbound orders to process for received orders no longer in stock.  Please wait.")
			OPEN o_pallet;
			if SQLCA.SQLCODE <> 0 then
				MessageBox("Error opening cursor o_pallet in uf_get_outbound",SQLCA.SQLErrText)
			else
				li_r_row = 1
				Fetch o_pallet Into :ls_pallet, :ls_wh_code, :ls_compl_date, :ls_o_no, :ls_i_order, :ls_dest, :is_po_no;
				if SQLCA.SQLCODE = 100 then			// No pallets for this order.. 
					//messagebox("Reading pallets for outbound order","No order associated with PalletID " + ls_pallet + ". Check for SIK outbound.")
					ids_pallet.SetItem(li_o_row,'field6','S')	//SIK-Customer
				else
					ld_cdate = DATE(f_datetime(ls_compl_date))
					ld_last_cdate = ld_cdate
					DO WHILE SQLCA.SQLCODE <> 100
						if ld_last_cdate = ld_cdate then
							ids_pallet.SetItem(li_o_row,'field1',ls_i_order)
							ids_pallet.SetItem(li_o_row,'field2',ls_o_no)
							ids_pallet.SetItem(li_o_row,'field3',string(DATE(f_datetime(ls_compl_date))))
							ids_pallet.SetItem(li_o_row,'field4',ls_wh_code)
							ids_pallet.SetItem(li_o_row,"field5",uf_get_product_model(ls_sku,ls_supp_code))
							if ls_dest = 'CUSTOMER' then
								ids_pallet.SetItem(li_o_row,'field6','S')	//SIK-Customer
							else
								ids_pallet.SetItem(li_o_row,'field6','O')	//Regular outbound
							end if
							ids_pallet.SetItem(li_o_row,'field7',is_po_no)
						end if
						Fetch o_pallet Into :ls_pallet, :ls_wh_code, :ls_compl_date, :ls_o_no, :ls_i_order, :ls_dest, :is_po_no;
						ld_cdate = DATE(f_datetime(ls_compl_date))
						if ld_cdate > ld_last_cdate then
							ld_last_cdate = ld_cdate
						end if
					LOOP
				end if
			end if
			CLOSE o_pallet;
		end if
	end if
next

SetPointer(Arrow!)
w_main.setmicrohelp("Ready")

return 0

end function

public function datetime f_datetime (string as_datetime);/******************************************
* Function:  f_DateTime
*
* Parmeters: in - as_datetime:  Datetime value as a string
*
* Returns:  datetime, if input is valid and Null otherwise.
*****************************************/
DateTime ldtm_rc
Time     ltm_Time
long     ll_count, ll_Pos
string   ls_datetime[], ls_LDate, ls_LTime
boolean  lb_BadDateTime = False

ls_LTime = "00:00:000"

ll_Pos = Pos(as_datetime,' ')
IF ll_Pos>  0 THEN
	//Found the separator space
	ls_LDate = Trim(Left(as_datetime, ll_Pos))
	ls_LTime = Trim(Right(as_datetime, Len(as_datetime) - ll_Pos))
	
	ldtm_rc = datetime(Date(ls_LDate), Time(ls_LTime))
ELSE
	//ERROR in date time string value
	ldtm_rc = DateTime(Date(as_datetime), Time(ls_LTime))
 END IF

Return ldtm_rc

end function

public function integer uf_get_serials ();/********************************************************
* Loop through ids_pallet checking for Status S.  Pull all serial numbers for
* pallets/lot no from delivery_picking_detail & delivery_serial_detail and
* populate dw_results.
********************************************************/
int li_return, li_x_row, li_x_rows, li_s_rows, li_o_rows, li_i_rows, li_d_rows
string ls_status, ls_sku, ls_supp_code, ls_model

li_return = 0
li_s_rows = 0
li_i_rows = 0
li_o_rows = 0
li_d_rows = 0

//ids_pallet.SetFilter("Status = 'S'")
//ids_pallet.Filter()
li_x_rows = ids_pallet.RowCount()
for li_x_row = 1 to li_x_rows
	ls_status = ids_pallet.GetItemString(li_x_row,'field6')
	ls_model = ids_pallet.GetItemString(li_x_row,"field5")
	if Pos(ls_model,"^") > 0 then
		ls_sku = Left(ls_model,Pos(ls_model,"^") -1)
		ls_supp_code = Right(ls_model,Pos(ls_model,"^") +1)
		ls_model = uf_get_model(ls_sku, ls_supp_code)
	end if
	
	CHOOSE CASE ls_status 
		CASE 'S'
			li_s_rows = li_s_rows + 1
			// Get serial data into dw_results for SIK outbound orders
			w_main.setmicrohelp("Looking up SIK pallets.  Please wait.")

			li_return = uf_get_sik(ids_pallet.GetItemString(li_x_row,'pallet'), ids_pallet.GetItemString(li_x_row,"field2"))
			if li_return = -1 then
				ids_pallet.SetItem(li_x_row,'field6','N')		// Pallet not found - no record with the order
			end if
		CASE 'I'
			li_i_rows = li_i_rows + 1
			// Get serial data into dw_results for InStock pallets
			w_main.setmicrohelp("Looking up InStock pallets.  Please wait.")
			
			li_return = uf_get_pallet_serials(ids_pallet.GetItemString(li_x_row,'pallet'), &
							ids_pallet.GetItemString(li_x_row,'field1'),  &
							ids_pallet.GetItemString(li_x_row,'field4'), &
							ids_pallet.GetItemString(li_x_row,'field3'), &
							ids_pallet.GetItemString(li_x_row,'field6'), &
							ids_pallet.GetItemString(li_x_row,"field5"), &
							ids_pallet.GetItemString(li_x_row,"field8"))
			
		CASE 'O'
			li_o_rows = li_o_rows + 1
			// Get serial data into dw_results for outbound orders
			w_main.setmicrohelp("Looking up outbound pallets.  Please wait.")

			li_return = uf_get_pallet_serials(ids_pallet.GetItemString(li_x_row,'pallet'), &
							ids_pallet.GetItemString(li_x_row,'field1'),  &
							ids_pallet.GetItemString(li_x_row,'field4'), &
							ids_pallet.GetItemString(li_x_row,'field3'), &
							ids_pallet.GetItemString(li_x_row,'field6'), &
							ids_pallet.GetItemString(li_x_row,"field5"), &
							ids_pallet.GetItemString(li_x_row,"field8"))
			
		CASE 'D'
			li_d_rows = li_d_rows + 1
			// Get serial data into dw_results for delivery orders
			w_main.setmicrohelp("Looking up Delivery pallets.  Please wait.")

			li_return = uf_get_pallet_serials(ids_pallet.GetItemString(li_x_row,'pallet'), &
							ids_pallet.GetItemString(li_x_row,'field1'),  &
							ids_pallet.GetItemString(li_x_row,'field4'), &
							ids_pallet.GetItemString(li_x_row,'field3'), &
							ids_pallet.GetItemString(li_x_row,'field6'), &
							ids_pallet.GetItemString(li_x_row,"field5"), &
							ids_pallet.GetItemString(li_x_row,"field8"))

		CASE 'X'
			//messagebox("Get serial data","Status " + ls_status + ": Get serial!")
			w_main.setmicrohelp("Looking up Status X  pallets.  Please wait.")

			li_return = uf_get_pallet_serials(ids_pallet.GetItemString(li_x_row,'pallet'), &
							ids_pallet.GetItemString(li_x_row,'field1'),  &
							ids_pallet.GetItemString(li_x_row,'field4'), &
							ids_pallet.GetItemString(li_x_row,'field3'), &
							ids_pallet.GetItemString(li_x_row,'field6'), &
							ids_pallet.GetItemString(li_x_row,"field5"), &
							ids_pallet.GetItemString(li_x_row,"field8"))

		CASE ELSE
			messagebox("Get serial data","Status " + ls_status + " not covered in uf_get_serials!")
	END CHOOSE

next
	
//messagebox("Status from uf_get_serials","Status S: " + string(li_s_rows) + ", I:" + string(li_i_rows) + ", O:" + string(li_o_rows) + ", D:" + string(li_d_rows))

//ids_pallet.SetFilter("")
//ids_pallet.Filter()

return 0
end function

public function string uf_get_product_model (string as_sku, string as_supplier);
string ls_model

select user_field10 into :ls_model
from item_master im
where project_id = 'Comcast' and sku = :as_sku and supp_code = :as_supplier
;

if isnull(ls_model) then ls_model = ''

return ls_model

end function

public function integer uf_validate_from_to_site ();int li_return

li_return = 0

if sle_fromsite.text = "" and is_tran_type <> 'TRC' then
	MessageBox("Validation Error","From Site must be entered")
	sle_fromsite.SetFocus()
	return -1
end if
if sle_tosite.text = "" then
	MessageBox("Validation Error","To Site must be entered")
	sle_tosite.SetFocus()
	return -1
end if
// Validate TRC to site must be local Menlo site
if is_tran_type = 'TRC' and uf_valid_menlo_site(sle_tosite.text) <> 1 then
	MessageBox("Validation Error","TRC - Receive:  ToSite must be a valid Menlo site~n~n     Please Reenter")
	sle_tosite.text = ""
	sle_tosite.SetFocus()
	return -1
end if
/* Validate TRC from site must be from a valid Comcast site
if is_tran_type = 'TRC' and uf_valid_comcast_site(sle_fromsite.text) <> 1 then
	MessageBox("Validation Error","TRC - Receive:  FromSite must be a valid Comcast site~n~n     Please Reenter")
	sle_fromsite.text = ""
	sle_fromsite.SetFocus()
	return -1
end if */
// Validate TSU from site must be local Menlo site
if is_tran_type = 'TSU' and uf_valid_menlo_site(sle_fromsite.text) <> 1 then
	MessageBox("Validation Error","TSU - Transfer:  FromSite must be a valid Menlo site~n~n     Please Reenter")
	sle_fromsite.text = ""
	sle_fromsite.SetFocus()
	return -1
end if
// Validate TSU to site can be a valid Comcast site, if not ask to continue
if is_tran_type = 'TSU' and uf_valid_comcast_site(sle_tosite.text) <> 1 then
	if MessageBox("Not a valid Comcast Site","The ToSite is not a valid Comcast site.  Do you wish to continue?",Question!,YesNo!) <> 1 then
		sle_tosite.text = ""
		sle_tosite.SetFocus()
		return -1
	end if
end if
// Validate TUP from and to sites must be the same (Delete)
if (is_tran_type = 'TUP' and sle_fromsite.text <> sle_tosite.text) then
	MessageBox("Validation Error","From and To Sites must be the same for TUP~n~n     Please Reenter")
	sle_tosite.SetFocus()
	return -1
end if
/* Validate TUP from and to sites must be a valid Comcast site or a local Menlo stie
if (is_tran_type = 'TUP' and (uf_valid_comcast_site(sle_fromsite.text) = 1 or uf_valid_menlo_site(sle_fromsite.text) = 1)) then
else
	MessageBox("Validation Error","Site must be a valid Comcast or local site.~n~n     Please Reenter")
	sle_fromsite.SetFocus()
	return -1
end if */

return li_return

end function

public function integer uf_pallet_count (string as_pallet);int li_pallet_count

li_pallet_count = 0

select count(*) into :li_pallet_count
from carton_serial
where project_id = :gs_project
and pallet_id = :as_pallet
USING SQLCA;


return li_pallet_count

end function

public function integer uf_get_avail_qty (string as_rono, string as_pallet);/*******************************************************
* Return available quantity from content_summer for RO No.
******************************************************/
int li_return = 0

select (avail_qty + alloc_qty + SIT_qty + WIP_qty) into :li_return
from content_summary
where project_id = :gs_project
and ro_no = :as_rono and lot_no = :as_pallet
USING SQLCA;

return li_return
end function

public function integer uf_get_model ();
int li_l_row, li_l_rows, li_return, li_serial_cnt, li_N, li_M, li_S, li_m_row, li_m_rows
string ls_model, ls_SKU, ls_serial, ls_pallet, ls_supp_code, ls_bolid
string  ls_addr1, ls_addr2, ls_addr3, ls_addr4, ls_addr5
string  ls_attr1, ls_attr2, ls_attr3, ls_attr4, ls_attr5

li_return = 0
ii_result = 1		// Initialize result flag
ls_SKU = "error"		// Initialize SKU
ls_model = ""
ls_bolid = ""
li_N = 0
li_M = 0
li_S = 0

DECLARE  s_serial CURSOR FOR
	select  cs.pallet_id, cs.serial_no, cs.sku, cs.supp_code, 
			cs.user_field1, cs.user_field2, cs.user_field3, cs.user_field4, cs.user_field5,
			cs.user_field6, cs.user_field7, cs.user_field8, cs.user_field9, cs.user_field10
	from carton_serial cs with (nolock)
	where  cs.project_id = :gs_project and cs.serial_no = :ls_serial and cs.pallet_id = :ls_pallet
;
DECLARE  m_serial CURSOR FOR
	select  cs.pallet_id, cs.serial_no, cs.sku, cs.supp_code
	from carton_serial cs with (nolock)
	where  cs.project_id = :gs_project and cs.serial_no = :ls_serial
;

SetPointer(Hourglass!)
w_main.setmicrohelp("Looking up serial number(s) from CartonSerial... please wait.")

	// Loop through ids_list, populate both ids_serial and dw_results with serial data
	// Get Model for Serial Number using carton_serial.serial_no field

li_l_rows = ids_list.RowCount()
for li_l_row = 1 to li_l_rows
	ls_serial = ids_list.GetItemString(li_l_row, "find_column")
	
	ls_pallet = uf_get_serial_count(ls_serial)
	if ls_pallet = "None"  then
		ids_list.SetItem(li_l_row, "find_value","N")		// Serial No not found
		li_N = li_N + 1
	else
		ids_list.SetItem(li_l_row, "find_value","S")		// Returns only one palletID for the SN with latest receive
		li_S = li_S + 1
		
		OPEN s_serial;
		if SQLCA.SQLCODE <>0 then
			MessageBox("Error opening cursor r_pallet in uf_retrieve_serial",SQLCA.SQLErrText)
		else
			Fetch s_serial Into  :ls_pallet, :ls_serial, :ls_SKU, :ls_supp_code, :ls_addr1,: ls_addr2, :ls_addr3, :ls_addr4, :ls_addr5, :ls_attr1,: ls_attr2, :ls_attr3, :ls_attr4, :ls_attr5;
	
				// Check for record.  If no record get model by using carton_serial.user_field5  GXMOR: after model mapping this no longer applies
				if sqlca.sqlcode < 0 then
					MessageBox("Get Model Function DbError",sqlca.SQLerrtext + " - Row: " + string(li_l_row) + " - SerialNo: " + ls_serial )
				elseif sqlca.sqlcode = 100 then
					ids_list.SetItem(li_l_row, "find_value", "N") 		// Not Found -- will not be processed
					li_N = li_N + 1
				else
					ids_list.SetItem(li_l_row, "find_value", "C")		// Found SN in CartonSerial with valid SKU
					li_return = li_return + 1								// Send back number of SNs found
					// Load ids_serial for later order lookup
					ii_result = ids_serial.InsertRow(0)
					ids_serial.SetItem(ii_result,"pallet",ls_pallet)
					ids_serial.SetItem(ii_result,"field1",ls_serial)
					ids_serial.SetItem(ii_result,"field2",ls_sku)
					ids_serial.SetItem(ii_result,"field3",ls_supp_code)
					
					ls_model = uf_get_product_model(ls_sku, ls_supp_code)
					
					ids_serial.SetItem(ii_result,"field4",ls_model)
					
					// Load dw_results
					ii_result = dw_results.insertrow(0)
					dw_results.SetItem(ii_result,'trantype', is_tran_type)
					dw_results.SetItem(ii_result,'fromsite', sle_fromsite.text)
					dw_results.SetItem(ii_result,'tosite', sle_tosite.text)
					dw_results.SetItem(ii_result,'serialnbr', ls_serial)
					dw_results.SetItem(ii_result,'pallet', ls_pallet)
					dw_results.SetItem(ii_result,'bolid', ls_bolid)
					dw_results.SetItem(ii_result,'detailtype', ls_detail_type)
					dw_results.SetItem(ii_result,'model', ls_model)
					dw_results.SetItem(ii_result,'addr1', ls_addr1)
					dw_results.SetItem(ii_result,'addr2', ls_addr2)
					dw_results.SetItem(ii_result,'addr3', ls_addr3)
					dw_results.SetItem(ii_result,'addr4', ls_addr4)
					dw_results.SetItem(ii_result,'addr5', ls_addr5)
					dw_results.SetItem(ii_result,'attr1', ls_attr1)
					dw_results.SetItem(ii_result,'attr2', ls_attr2)
					dw_results.SetItem(ii_result,'attr3', ls_attr3)
					dw_results.SetItem(ii_result,'attr4', ls_attr4)
					dw_results.SetItem(ii_result,'attr5', ls_attr5)
				end if	
		end if

		CLOSE s_serial;
	end if
next

SetPointer(Arrow!)
w_main.setmicrohelp("Ready")

return li_return


end function

public function integer uf_retrieve_pallet ();int li_pallet_count, li_serial_count, li_row, li_record, li_quantity, li_avail_qty, li_outbound_flag, li_workorder_flag, i
int li_transferred_flag, li_serRow, li_dwRow
string ls_serial, ls_prev_serial, ls_pallet, ls_sku, ls_supp_code, ls_model, ls_status, ls_ro_supp_code, ls_owner_id, ls_owner_cd
string ls_rono, ls_compl_date, ls_wh_code, ls_bolid, ls_msg, ls_find

ii_result = 0
li_record = 0
li_pallet_count = 0
li_outbound_flag = 0
li_transferred_flag = 0
li_workorder_flag = 0
ls_bolid = ""
ls_msg = ""

SetPointer(Hourglass!)
w_main.setmicrohelp("Looking up pallet IDs.  Please wait.")

// Declare the cursor
DECLARE p_pallet CURSOR FOR 
select distinct rtrim(cs.pallet_id), cs.sku, Upper(cs.supp_code), im.user_field10 
from carton_serial cs, item_master im with (nolock)
where cs.project_id =:gs_project and im.project_id = :gs_project
and im.SKU = cs.SKU and cs.pallet_id = :ls_pallet;

DECLARE r_pallet CURSOR FOR
select TOP 1 rm.ro_no, rm.supp_invoice_no, rm.complete_date, rm.wh_code, rp.quantity,
			rp.supp_code, rp.owner_id
from receive_master rm, receive_putaway rp with (nolock)
where rm.project_id = :gs_project and rp.ro_no = rm.ro_no
and rp.lot_no = :ls_pallet and rp.sku = :ls_sku 
//and rp.supp_code = :ls_supp_code			Cannot trust that supplier will be the same between CartonSerial and DeliveryPutaway
order by rm.complete_date desc
;

start_time = TIME(now())
	
il_rows = ids_list.RowCount()
for li_row = 1 to il_rows
	ls_pallet = ids_list.GetItemString(li_row,'find_column')
		
	// Open the cursor
	OPEN p_pallet;
	if SQLCA.SQLCODE <> 0 then
		MessageBox("Error opening p_pallet cursor in function uf_retrieve_pallet",SQLCA.SQLErrText)
	else
		Fetch p_pallet Into :ls_pallet, :ls_sku, :ls_supp_code, :ls_model;
		If SQLCA.SQLCODE = 100 then
			ids_list.SetItem(li_row,"find_value", "N")			// Pallet not found
		else
			li_pallet_count = li_pallet_count + 1
			ids_list.SetItem(li_row,"find_value", "C")			// CartonSerial
			// Pallet found - get receive order
			OPEN r_pallet;
			if SQLCA.SQLCODE <> 0 then
				MessageBox("Error opening r_pallet cursor in function uf_retrieve_pallet",SQLCA.SQLErrText)
			else
				Fetch r_pallet Into :ls_rono, :is_order, :ls_compl_date, :ls_wh_code, :li_quantity, :ls_ro_supp_code, :ls_owner_id;
				If SQLCA.SQLCODE = 100 then
						li_record = ids_pallet.insertrow(0)
						ids_pallet.SetItem(li_record,"pallet", ls_pallet)
						ids_pallet.SetItem(li_record,"field1", is_order)
						ids_pallet.SetItem(li_record,"field2", ls_rono)
						ids_pallet.SetItem(li_record,"field3", string(DATE(f_datetime(ls_compl_date))))
						ids_pallet.SetItem(li_record,"field4", ls_wh_code)
						ids_pallet.SetItem(li_record,"field5", ls_model)
						ids_pallet.SetItem(li_record,"field7", is_po_no)
						ids_pallet.SetItem(li_record,"field8", is_order)		// Receive order number for BOL Id
						ids_pallet.SetItem(li_record,"field6", "W") 			// Carton_Serial
						ids_list.SetItem(li_row,"find_value", "W")			// Receive Order for pallet not found..Check workorder
						
						/* With no receive order for this pallet, check workorders for kits */
						ii_result = uf_get_workorder(li_record)

				else
					li_record = ids_pallet.insertrow(0)
					ids_pallet.SetItem(li_record,"pallet", ls_pallet)
					ids_pallet.SetItem(li_record,"field1", is_order)
					ids_pallet.SetItem(li_record,"field2", ls_rono)
					ids_pallet.SetItem(li_record,"field3", string(DATE(f_datetime(ls_compl_date))))
					ids_pallet.SetItem(li_record,"field4", ls_wh_code)
					
					if ls_ro_supp_code <> ls_supp_code then		// Supplier different between CartonSerial and ReceivePutaway
						ls_model = uf_get_product_model(ls_sku, ls_ro_supp_code)
						if ls_model = "" then
							ls_model = uf_get_product_model(ls_sku, ls_supp_code)
							if ls_model = "" then
								messagebox("uf_retrieve_pallet","Could not get product model for pallet ID: " + ls_pallet)
							end if
						end if
						ls_owner_cd = uf_get_supplier(ls_owner_id)
						if ls_supp_code <> ls_owner_cd or ls_ro_supp_code = "Pace uDTAs" then		// Data error with this product
							ls_supp_code = ls_ro_supp_code
						end if
						//ls_model = uf_get_product_model(ls_sku, ls_supp_code)
					end if
					
					ids_pallet.SetItem(li_record,"field5", ls_model)
					ids_pallet.SetItem(li_record,"field7", is_po_no)
					ids_pallet.SetItem(li_record,"field8", is_order)		// Receive order number as BOL Id
					
					ids_pallet.SetItem(li_record,"field6", "R") 			// Carton_Serial
					ids_list.SetItem(li_row,"find_value", "R")			// Receive order found
					
					li_avail_qty = uf_get_avail_qty(ls_rono, ls_pallet)
					if li_avail_qty = li_quantity then
						ids_list.SetItem(li_row,"find_value", "I")			// Whole pallet in stock
						ids_pallet.SetItem(li_record,"field6", "I")			// Pallet in stock
					elseif li_avail_qty = 0 then
						ids_list.SetItem(li_row,"find_value","X")			// Not in stock. Check delivery
						ids_pallet.SetItem(li_record,"field5",ls_sku + "^" + ls_supp_code)
						ids_pallet.SetItem(li_record,"field6","X")			// Pallet outbound?
						li_outbound_flag = 1
					elseif li_avail_qty < li_quantity then	// Either partial pallet or more serial numbers than pallet should have
						MessageBox("Pallet InStock Warning","Pallet " + ls_pallet + " has " + string(li_quantity) + " SNs but only " + string(li_avail_qty) + " available.  Please investigate")
						ids_list.SetItem(li_row,"find_value","P")			// Partial pallet outbound
						ids_pallet.SetItem(li_record,"field6","P")			// Check SIK
					else
						ids_list.SetItem(li_row,"find_value","E")			// Error.  Pallet cannot have more 
						ids_pallet.SetItem(li_record,"field6","E")			//            avail than records.
					end if
				end if
			end if
			CLOSE r_pallet;
		end if
	end if
	ii_result = li_pallet_count
	CLOSE p_pallet;
next

/* Completed initial check - Now only delivery */
for i = 1 to ids_pallet.RowCount()
	ls_status = ids_pallet.GetItemString(i, "field6")
	ls_pallet = ids_pallet.GetItemString(i, "pallet")
	CHOOSE CASE ls_status
		CASE "S"
			li_outbound_flag = 1
			ii_result = uf_get_outbound()
		CASE "T"
			li_transferred_flag = 1
			ii_result = uf_get_transferred(ls_pallet)
		CASE "X"
			li_outbound_flag = 1
			ii_result = uf_get_outbound()
	END CHOOSE
	ls_msg = ls_msg + "PalletID: " + ids_pallet.GetItemString(i,1) + ", status: " + ids_pallet.GetItemString(i, 7) + "~n~r"
next

//MessageBox("Report of pallets",ls_msg)
	
il_rows = ids_pallet.RowCount()
for li_row = 1 to il_rows
	ls_pallet = ids_pallet.GetItemString(li_row,"pallet")
	is_order = ids_pallet.GetItemString(li_row,"field1")
	ls_wh_code = ids_pallet.GetItemString(li_row,"field4")
	ls_compl_date = ids_pallet.GetItemString(li_row,"field3")
	ls_model = ids_pallet.GetItemString(li_row,"field5")
	ls_status = ids_pallet.GetItemString(li_row,"field6")
	is_po_no = ids_pallet.GetItemString(li_row,"field7")
	ls_bolid = ids_pallet.GetItemString(li_row,"field8")
	if Pos(ls_model,"^") > 0 then
		ls_sku = Left(ls_model,Pos(ls_model,"^") - 1)
		ls_supp_code = Mid(ls_model,Pos(ls_model,"^") + 1, Len(ls_model))
		ls_model = uf_get_model(ls_sku,ls_supp_code)
	end if
	
	ii_result = uf_get_pallet_serials(ls_pallet, is_order, ls_wh_code, ls_compl_date, ls_status, ls_model, ls_bolid)
	li_serial_count = ids_serial.rowcount()
	for li_serRow = 1 to li_serial_count
		ls_serial = ids_serial.GetItemString(li_serRow, 2)
		ls_find = "serialnbr = '" + ls_serial + "'"
		li_dwRow = dw_results.Find(ls_find,1,dw_results.rowcount())
		if li_dwRow > 0 then
			dw_results.SetItem(li_dwRow, 'warehouse', ids_serial.GetItemString(li_serRow, 3))
			dw_results.SetItem(li_dwRow, 'compldate', string(DATE(f_datetime(ids_serial.GetItemString(li_serRow, 4)))))
			dw_results.SetItem(li_dwRow, 'tsorder', ids_serial.GetItemString(li_serRow, 5))
			//dw_results.SetItem(li_dwRow, 6, ls_CustCode)
		end if
	next
next

	//MessageBox("Find pallet","Pallet:"+ids_pallet.GetItemString(1,"pallet") + " - Code:" + ids_pallet.GetItemString(1,"field6"))
il_rows = ids_list.RowCount()
is_msg = ""
for li_row = 1 to il_rows
	ls_pallet = ids_list.GetItemString(li_row,"find_column")
	ls_status = ids_list.GetItemString(li_row,"find_value")
	CHOOSE CASE ls_status
		CASE "N"
			is_msg += "PalletID " + trim(ls_pallet) + " was not found~n"
		CASE "M"
			is_msg += "PalletID " + trim(ls_pallet) + " has Carton/Serial data but Receive Order not found~n"
		CASE "E"
			is_msg += "Error found when searching for PalletID " + ls_pallet + "~n"
	END CHOOSE
next

ii_result = dw_results.RowCount()
		
end_time = TIME(now())
il_timing = secondsafter(start_time, end_time)
//MessageBox("Timing for function uf_get_outbound", "Start: " + string( start_time) + " -- Stop: " + string(end_time) + " -- Timing: " + string(il_timing))

SetPointer(Arrow!)
w_main.setmicrohelp("Ready")

return ii_result
end function

public function string uf_get_pallets (string as_order, string as_o_no, string as_c_dt, string as_status);/*********************************************************
* Order number entered for receive or deliver.  PalletIDs/LotNo put in datastore
* for further processing.
*********************************************************/
int li_r_row, li_d_row, li_p_row, li_o_row, li_o_rows
string ls_lot_no, ls_wh_code, ls_sku, ls_cust, ls_status

DECLARE r_pallet CURSOR FOR
select rp.lot_no, rm.wh_code, rtrim(rp.sku) + "^" + rtrim(rp.supp_code), rp.po_no
from receive_master rm, receive_putaway rp with (nolock)
where rm.project_id = 'Comcast' and rp.ro_no = rm.ro_no
and rm.ro_no = :as_o_no;

DECLARE d_pallet CURSOR FOR
select dp.lot_no, rtrim(w.user_field1) + '->' + rtrim(c.user_field3), rtrim(dp.sku) + "^" + 
		rtrim(dp.supp_code), c.user_field3, dp.po_no
from delivery_master dm, delivery_picking dp, warehouse w, customer c with (nolock)
where dm.project_id = 'Comcast' and dp.do_no = dm.do_no
and w.wh_code = dm.wh_code and c.cust_code = dm.cust_code
and dm.do_no = :as_o_no;

ls_status = as_status
// Get pallet numbers into ids_pallet
if as_status = 'R' then
	OPEN r_pallet;
	if SQLCA.SQLCODE <> 0 then
		MessageBox("Error opening cursor r_pallet in uf_get_pallets",SQLCA.SQLErrText)
	else
		li_r_row = 1
		Fetch r_pallet Into :ls_lot_no, :ls_wh_code, :ls_sku, :is_po_no;
		if SQLCA.SQLCODE = 100 then			// No pallets for this order.. 
			ls_status = "N"		
		else
			DO WHILE SQLCA.SQLCODE <> 100
				li_p_row = ids_pallet.InsertRow(0)
				ids_pallet.SetItem(li_p_row,'pallet',ls_lot_no)
				ids_pallet.SetItem(li_p_row,'field1',as_order)
				ids_pallet.SetItem(li_p_row,'field2',as_o_no)
				ids_pallet.SetItem(li_p_row,'field3',as_c_dt)
				ids_pallet.SetItem(li_p_row,'field4',ls_wh_code)
				ids_pallet.SetItem(li_p_row,'field5',ls_sku)
				ids_pallet.SetItem(li_p_row,'field6',as_status)
				ids_pallet.SetItem(li_p_row,'field7',is_po_no)
				ids_pallet.SetItem(li_p_row,'field8',as_order)		// Receive order number as BOL Id
				Fetch r_pallet Into :ls_lot_no, :ls_wh_code, :ls_sku, :is_po_no;
				li_r_row = li_r_row + 1
			LOOP
		end if
	end if
	CLOSE r_pallet;
	
	li_o_rows = uf_get_content()
	
	li_o_rows = uf_get_outbound()
else
	OPEN d_pallet;
	if SQLCA.SQLCODE <> 0 then
		MessageBox("Error opening cursor d_pallet in uf_get_pallets",SQLCA.SQLErrText)
	else
		li_d_row = 1
		Fetch d_pallet Into :ls_lot_no, :ls_wh_code, :ls_sku, :ls_cust, :is_po_no;
		if SQLCA.SQLCODE = 100 then			// No pallets for this order.. 
			ls_status = "N"
		else
			DO WHILE SQLCA.SQLCODE <> 100
				li_p_row = ids_pallet.InsertRow(0)
				ids_pallet.SetItem(li_p_row,'pallet',ls_lot_no)
				ids_pallet.SetItem(li_p_row,'field1',as_order)
				ids_pallet.SetItem(li_p_row,'field2',as_o_no)
				ids_pallet.SetItem(li_p_row,'field3',as_c_dt)
				ids_pallet.SetItem(li_p_row,'field4',ls_wh_code)
				ids_pallet.SetItem(li_p_row,'field5',ls_sku)
				if ls_cust = "CUSTOMER" then				// SIK Customer
					ids_pallet.SetItem(li_p_row,"field6","S")
					ls_status = "S"
				else
					ids_pallet.SetItem(li_p_row,'field6',as_status)
				end if
				ids_pallet.SetItem(li_p_row,'field7',is_po_no)
				ids_pallet.SetItem(li_p_row,'field8',as_order)		// Delivery order number as BOL Id
				Fetch d_pallet Into :ls_lot_no, :ls_wh_code, :ls_sku, :ls_cust, :is_po_no;
				li_d_row = li_d_row + 1
			LOOP
		end if	
	end if
	CLOSE d_pallet;
end if

is_msg = ''

return ls_status

end function

public function integer uf_get_sik (string as_pallet, string as_dono);/***************************************************************
* Get SIK orders/serial numbers from pallet ID
* Currently it took 6.5 minutes to query 3,654 serial numbers.  Can we get
* this down to manageable time?  Can we use SKU - complDate?
***************************************************************/
int li_s_row, li_s_rows, li_p_row, li_p_rows, li_return
string ls_dono, ls_o_no,ls_compl_date,ls_wh_code,ls_cust_code, ls_sku, ls_supp_code, ls_serial
string ls_model, ls_warehouse

li_return = 0

DECLARE s_pallet CURSOR FOR
select dm.do_no, dm.invoice_no, dm.complete_date, dm.wh_code, dm.cust_code,
	 dpd.sku, dpd.supp_code, dsd.serial_no
from delivery_master dm, delivery_picking dp, 
	delivery_picking_detail dpd, delivery_serial_detail dsd with (NOLOCK)
where dm.project_id = 'Comcast' and dp.do_no = dm.do_no
and dpd.do_no = dp.do_no and dsd.id_no = dpd.id_no
and dm.ord_type = 'S' and cust_code = 'SIK-CUSTOMER'
and dm.do_no = :as_dono and dp.lot_no = :as_pallet;

	OPEN s_pallet;
	
	if SQLCA.SQLCODE <> 0 then
		MessageBox("Error opening cursor s_pallet in uf_get_sik",SQLCA.SQLErrText)
	else
		li_s_row = 0
		Fetch s_pallet Into :ls_dono, :ls_o_no, :ls_compl_date, :ls_wh_code, :ls_cust_code, :ls_sku, :ls_supp_code, :ls_serial;
		if SQLCA.SQLCODE = 100 then			// No serial data for this pallet.. 
			//messagebox("Reading serial numbers for SIK order","No serial numbers associated with pallet ID " + as_pallet)
			li_return = -1	// No SIK - Code pallet as not found - Code N
		else
			// Assume the entire pallet has the same sku/supplier.  Get Model
			ls_model = uf_get_product_model(ls_sku, ls_supp_code)
			DO WHILE SQLCA.SQLCODE <> 100
				ls_compl_date = string(DATE(f_datetime(ls_compl_date)))
				ls_warehouse = trim(ls_wh_code) + '->' + trim(ls_cust_code)

				li_p_row = dw_results.InsertRow(0)
				dw_results.SetItem(li_p_row,'trantype', is_tran_type)
				dw_results.SetItem(li_p_row,'fromsite', sle_fromsite.text)
				dw_results.SetItem(li_p_row,'tosite', sle_tosite.text)
				dw_results.SetItem(li_p_row,'serialnbr', ls_serial)
				dw_results.SetItem(li_p_row,'pallet', as_pallet)
				dw_results.SetItem(li_p_row,'warehouse', ls_warehouse)
				dw_results.SetItem(li_p_row,'compldate', ls_compl_date)
				dw_results.SetItem(li_p_row,'detailtype', ls_detail_type)
				dw_results.SetItem(li_p_row,'model', ls_model)
				dw_results.SetItem(li_p_row,'tsorder', ls_o_no)
				dw_results.Setitem(li_p_row,'bolid', ls_o_no)
//				dw_results.SetItem(li_p_row,'addr1', ls_addr1)
//				dw_results.SetItem(li_p_row,'addr2', ls_addr2)
//				dw_results.SetItem(li_p_row,'addr3', ls_addr3)
//				dw_results.SetItem(li_p_row,'addr4', ls_addr4)
//				dw_results.SetItem(li_p_row,'addr5', ls_addr5)
				Fetch s_pallet Into :ls_dono, :ls_o_no, :ls_compl_date,:ls_wh_code, :ls_cust_code, :ls_sku, :ls_supp_code, :ls_serial;
				li_s_rows = li_s_rows + 1
				w_main.setmicrohelp("SIK lookup PalletID:"+as_pallet+" SN #:"+string(li_s_rows))
			LOOP
		end if
	end if

	CLOSE s_pallet;

return li_return

end function

public function long uf_get_list ();int  li_item_count, li_row, li_pos1, li_pos2, li_len, li_flag
string ls_item, ls_model, ls_item_nbrs
long li_result

// Reset datastore
ids_list.Reset()

li_result = 0

ls_item_nbrs = mle_serial.text
li_len = Len(ls_item_nbrs)
li_flag = Pos(ls_item_nbrs,"~n",li_len)  // Does item nbrs end with linefeed?

li_pos1 = 1
li_pos2 = Pos(ls_item_nbrs,"~n",li_pos1)

if li_pos2 = 0 then 	// One item number without linefeed 
	ls_item = Mid(ls_item_nbrs,li_pos1,li_len)
	li_row = ids_list.InsertRow(0)
	ids_list.SetItem(li_row,'find_column',ls_item)
	ids_list.SetItem(li_row,'find_value','R')
	li_result = 1
else 
	if li_pos2 = li_len then	// One item number with linefeed
		ls_item = Mid(ls_item_nbrs,li_pos1,li_len - 2)
		li_row = ids_list.InsertRow(0)
		ids_list.SetItem(li_row,'find_column',ls_item)
		ids_list.SetItem(li_row,'find_value','R')
		li_result = 1
	else
		DO WHILE li_pos2 <> 0  // Multiple item numbers with or without linefeed at the end
			ls_item = Mid(ls_item_nbrs,li_pos1,li_pos2 - li_pos1 - 1)
			li_row = ids_list.InsertRow(0)
			ids_list.SetItem(li_row,'find_column',ls_item)
			ids_list.SetItem(li_row,'find_value','R')
		
			li_pos1 = li_pos2 + 1
			li_pos2 = Pos(ls_item_nbrs,"~n",li_pos1)
			if li_pos2 = 0 and li_flag = 0 then 
				li_pos2 = li_len + 2
				li_flag = -1
			end if
			li_result = li_result +1
		LOOP
		//MessageBox("uf_get_list","Multi-LineEdit - Records: " + string(li_result) + " - Size: " + string(li_len))
	end if
end if	


return li_result


end function

public function string uf_get_supplier (string as_owner_id);string ls_owner_cd

ls_owner_cd = ""

select owner_cd  into :ls_owner_cd
from owner
where project_id = :gs_project
and owner_id = :as_owner_id
USING SQLCA;

return ls_owner_cd
end function

public function string uf_get_serial_count (string as_serial);/***************************************************************************************************
* Carton_Serial table may contain for than one record for each serial number.  We will assume that the last entered SN
* record contains the most recent pallet ID.  Therefore, this function will query the carton_serial table for the SN and
* the last one will be returned as the current pallet ID.
**************************************************************************************************/
int li_i_row, li_i_rows, li_sku_flag, li_WO_flag
string ls_return = "", ls_ReceiveSQL, ls_ReceiveSQL1, ls_ReceiveSQL2, ls_ReceiveSQL3
string ls_serial, ls_pallet, lsFirstSKU, lsSKU, lsWOPallet

ls_pallet = ""
lsWOPallet = ""
lsFirstSKU = ""
lsSKU = ""
li_sku_flag = 0
li_WO_flag = 0
ls_ReceiveSQL1 = "select rp.lot_no from receive_master rm, receive_putaway rp " + &
						"where rm.project_id = 'Comcast' and rp.ro_no = rm.ro_no and rp.lot_no in "
ls_ReceiveSQL2 = "and rm.complete_date in (select max(complete_date) from receive_master rm, " + &
						"receive_putaway rp where rm.project_id = 'Comcast' and rp.ro_no = rm.ro_no and rp.lot_no in "
ls_ReceiveSQL3 = " and rp.sku = '"


DECLARE si_serial CURSOR FOR
select pallet_id, SKU FROM carton_serial WHERE project_id = 'Comcast' and Serial_no = :as_serial;

//DECLARE si_receive CURSOR FOR


OPEN si_serial;
	if SQLCA.SQLCODE <>0 then
		MessageBox("Error opening cursor si_serial  in uf_get_serial_countl",SQLCA.SQLErrText)
	else
		Fetch si_serial Into :ls_pallet, :lsSKU;
		if SQLCA.SQLCODE = 100 then
			ls_return = "NONE"
		else
			ls_return = ls_pallet
			lsFirstSKU = lsSKU
			if left(ls_pallet,6) = 'MLO-FG' then
				li_WO_flag = 1
				lsWOPallet = ls_pallet
			end if
			Fetch si_serial Into :ls_pallet, :lsSKU;
			if SQLCA.SQLCODE <> 100 then		// We have multiple serial numbers
				DO WHILE SQLCA.SQLCODE <> 100
					if left(ls_pallet,6) = 'ML0-FG' then
						li_WO_flag = 1
						lsWOPallet = ls_pallet
					end if
					ls_return = ls_return + "','" + ls_pallet
					if lsSKU <> lsFirstSKU then
						li_sku_flag = -1
					end if
					Fetch si_serial Into :ls_pallet, :lsSKU;
				LOOP
				
				if li_WO_flag = 0 then
					ls_return = "('" + ls_return + "')"
					
					// Find latest complete date for multiple serial rows
					if li_sku_flag = -1 then
						ls_ReceiveSQL = ls_ReceiveSQL1 + ls_return + ls_ReceiveSQL2 + ls_return + "); "
					else
						ls_ReceiveSQL = ls_ReceiveSQL1 + ls_return + ls_ReceiveSQL3 + lsFirstSKU + "' " +  ls_ReceiveSQL2 + ls_return + ls_ReceiveSQL3 + lsFirstSKU + "'" + "); "
					end if
					
					// Get the latest pallet
					DECLARE my_cursor DYNAMIC CURSOR FOR SQLSA ;
					PREPARE SQLSA FROM :ls_ReceiveSQL ;
					OPEN DYNAMIC my_cursor ;
					FETCH my_cursor INTO :ls_return;
					CLOSE my_cursor;
				else
					ls_return = lsWOPallet
				end if
			end if
		end if
	end if
CLOSE si_serial;


return ls_return


end function

public function string uf_get_eis_rollup_model (string as_model);/********************************************************************
* SIMS user_field10 in Item Master table is the EIS product model number.
* EIS rolls up certain model numbers and will not accept models not rolled up
* prior to sending transactions.  Add new rollups when identified.
********************************************************************/

string ls_return

CHOOSE CASE as_model
	CASE "DCT2200"
		ls_return = "DCT2000"
	CASE "DCT2224"
		ls_return = "DCT2000"
	CASE "DCT2244"
		ls_return = "DCT2000"
	CASE "DCT2524"
		ls_return = "DCT2500"
	CASE "TDC577X"
		ls_return = "TDC577D"
	CASE "TDC577x"
		ls_return = "TDC577D"
	CASE ELSE
		ls_return = as_model
END CHOOSE

return ls_return
end function

public function string uf_get_model (string as_sku, string as_supp_code);string ls_return = ""

select user_field10  into :ls_return
from item_master
where project_id = :gs_project
and sku = :as_sku and supp_code = :as_supp_code
USING SQLCA;

if isnull(ls_return) then ls_return = ""

return ls_return



end function

protected function integer uf_get_pallet_serials (string as_pallet, string as_order, string as_wh, string as_compl_date, string as_status, string as_model, string as_bolid);int li_row, li_rows, li_return
string ls_serial, ls_model, ls_addr1, ls_addr2, ls_addr3, ls_addr4, ls_addr5, ls_attr1, ls_attr2, ls_attr3, ls_attr4, ls_attr5
string ls_bolid

li_return = 0
ls_bolid = ""

	// Get PalletID for Serial Number using carton_serial.serial_no field
//	DECLARE p_serial CURSOR FOR 
//	select DISTINCT cs.serial_no, im.user_field10, cs.user_field1, cs.user_field2, cs.user_field3, cs.user_field4, cs.user_field5
//	from carton_serial cs, item_master im with (nolock)
//	where cs.project_id = :gs_project and im.project_id = :gs_project
//	and cs.pallet_id = :as_pallet and im.sku = cs.sku 
	//and im.supp_code = cs.supp_code			// Cannot use supplier in query since there are many differences between carton_serial and receive_putaway
//	;

DECLARE p_serial CURSOR FOR 
select serial_no, user_field1, user_field2, user_field3, user_field4, user_field5, user_field6, user_field7, user_field8, user_field9, user_field10
from carton_serial with (nolock)
where project_id = :gs_project and pallet_id = :as_pallet;
	
	OPEN p_serial;
	
	if SQLCA.SQLCODE <>0 then
		MessageBox("Error opening cursor p_serial",SQLCA.SQLErrText)
	else
		Fetch p_serial Into :ls_serial, :ls_addr1, :ls_addr2, :ls_addr3, :ls_addr4, :ls_addr5, :ls_attr1, :ls_attr2, :ls_attr3, :ls_attr4, :ls_attr5;
		if SQLCA.SQLCODE = 100 then			// No serial data for this pallet...  ?
			li_return = -1
		else
			DO WHILE SQLCA.SQLCODE <> 100
				if isnull(ls_addr1) then ls_addr1 = ""
				if isnull(ls_addr2) then ls_addr2 = ""
				if isnull(ls_addr3) then ls_addr3 = ""
				if isnull(ls_addr4) then ls_addr4 = ""
				if isnull(ls_addr5) then ls_addr5 = ""
				if isnull(ls_attr1) then ls_attr1 = ""
				if isnull(ls_attr2) then ls_attr2 = ""
				if isnull(ls_attr3) then ls_attr3 = ""
				if isnull(ls_attr4) then ls_attr4 = ""
				if isnull(ls_attr5) then ls_attr5 = ""
				if isnull(ls_bolid) then ls_bolid = ""

				// Load dw_results
				li_row = dw_results.insertrow(0)
				dw_results.SetItem(li_row,'trantype', is_tran_type)
				dw_results.SetItem(li_row,'fromsite', sle_fromsite.text)
				dw_results.SetItem(li_row,'tosite', sle_tosite.text)
				dw_results.SetItem(li_row,'serialnbr', ls_serial)
				dw_results.SetItem(li_row,'pallet', as_pallet)
				dw_results.SetItem(li_row,'warehouse', as_wh)
				dw_results.Setitem(li_row,'compldate', string(DATE(f_datetime(as_compl_date))))
				dw_results.SetItem(li_row,'bolid', ls_bolid)
				dw_results.SetItem(li_row,'detailtype', ls_detail_type)
				dw_results.SetItem(li_row,'model', as_model)
				dw_results.SetItem(li_row,'tsorder',as_order) 
				dw_results.SetItem(li_row,'bolid', as_bolid)
				dw_results.SetItem(li_row,'addr1', ls_addr1)
				dw_results.SetItem(li_row,'addr2', ls_addr2)
				dw_results.SetItem(li_row,'addr3', ls_addr3)
				dw_results.SetItem(li_row,'addr4', ls_addr4)
				dw_results.SetItem(li_row,'addr5', ls_addr5)
				dw_results.SetItem(li_row,'attr1', ls_attr1)
				dw_results.SetItem(li_row,'attr2', ls_attr2)
				dw_results.SetItem(li_row,'attr3', ls_attr3)
				dw_results.SetItem(li_row,'attr4', ls_attr4)
				dw_results.SetItem(li_row,'attr5', ls_attr5)
				dw_results.SetItem(li_row,'po_no', is_po_no)
					
				Fetch p_serial Into :ls_serial, :ls_addr1, :ls_addr2, :ls_addr3, :ls_addr4, :ls_addr5, :ls_attr1, :ls_attr2, :ls_attr3, :ls_attr4, :ls_attr5;
				li_rows = li_rows + 1
			LOOP
		end if
		li_return = li_rows
	end if
	
	CLOSE p_serial;
	
return li_return

end function

public function integer uf_get_workorder (integer ai_record);integer retVal, liResult
String lsPallet, lsWONbr, lsWONo, lsWHCode, lsModel, lsStatus
Date ldComplDate
retVal = 0
liResult = 0

lsPallet = ids_pallet.GetItemString(ai_record,1)

/* Select for workorder using pallet ID */
DECLARE r_WO CURSOR FOR
select wm.WorkOrder_Number,wm.WO_NO,wm.Wh_Code,im.User_Field10,wm.complete_date
from workorder_master wm, WorkOrder_Putaway wp, Item_Master im with (NOLOCK)
where wm.Project_ID = 'Comcast' and im.Project_ID = 'Comcast'
and wp.WO_No = wm.WO_NO and im.SKU = wp.SKU and im.Supp_Code = wp.Supp_Code
and wp.Lot_No = :lsPallet;

	OPEN r_WO;
	if SQLCA.SQLCODE <> 0 then
		MessageBox("Error opening cursor r_pallet in uf_get_workorder",SQLCA.SQLErrText)
	else
		Fetch r_WO Into :lsWONbr, :lsWONo, :lsWHCode, :lsModel, :ldComplDate;
		if SQLCA.SQLCODE = 100 then			// No pallets for this order.. 
			lsStatus = "N"		
			ids_pallet.SetItem(ai_record,"field6", "X")
		else
			//MessageBox("uf_get_workorder","PalletID: " + lsPallet + ", ComplDate: " + String(DATE(ldComplDate)) + ", PalletCount:" + String(ids_pallet.RowCount()))
			ids_pallet.SetItem(ai_record,"field1", lsWONbr)
			ids_pallet.SetItem(ai_record,"field2", lsWONo)
			ids_pallet.SetItem(ai_record,"field3", String(DATE(ldComplDate)))
			ids_pallet.SetItem(ai_record,"field4", lsWHCode)
			ids_pallet.SetItem(ai_record,"field5", lsModel)
			ids_pallet.SetItem(ai_record,"field8", lsWONbr)
			
			/* Check In Stock */
			liResult = uf_InStock(lsPallet)
			If liResult = 0 then
				ids_pallet.SetItem(ai_record,"field6", "T")
			ElseIf liResult = 1 then
				ids_pallet.SetItem(ai_record,"field6", "T")
			ElseIf liResult = 2 then
				ids_pallet.SetItem(ai_record,"field6", "W")
			End if
				
		end if
	end if
	CLOSE r_WO;


return retVal
end function

public function integer uf_instock (string as_palletid);/* Check inventory for the pallet ID.  Return 0 if not in stock.  Return 1 if pallet in stock but as a partial pallet
		Return 2 if pallet in stock and available quantity is equal to number of assigned serial numbers */
integer retVal, liAvailQty, liNbrSerial
String lsPalletID
lsPalletID = ""
retVal = 0
liAvailQty = 0
liNbrSerial = 0

SELECT con.lot_no, con.avail_qty, count(cs.serial_no)
INTO :lsPalletID, :liAvailQty, :liNbrSerial
FROM content_summary con with (NOLOCK), carton_serial cs with (NOLOCK)
WHERE con.project_id = 'COMCAST' and cs.project_id = 'COMCAST'
and cs.pallet_id = con.lot_no
and con.lot_no = :as_palletid
GROUP BY con.lot_no, con.avail_qty;

If lsPalletID = as_palletid Then
	If liAvailQty = liNbrSerial Then
		retVal = 2
	Else
		retVal = 1
		messagebox("availQty <> nbrSerials","Avail:" + string(liAvailQty) + " - nbrSerials:" + string(liNbrSerial))
	End If
End If

return retVal
end function

public function integer uf_get_transferred ();int retVal
retVal = 0

return retVal

end function

public function integer uf_get_transferred (string as_pallet);int retVal, liRow, liRows
string ls_WHCode, ls_ComplDate, ls_InvoiceNo, ls_CustCode, ls_SerialNo, ls_Msg, ls_Find
datetime ldt_compl_date
date ld_cdate, ld_last_cdate

retVal = 0
ls_Msg = "Serials:"
ls_Find = ""

DECLARE t_pallet CURSOR FOR
select rtrim(dm.wh_code) + '->' + rtrim(dm.cust_code), 
		dm.complete_date, dm.invoice_no, dm.cust_code, dsd.serial_no
from delivery_master dm, delivery_picking_detail dpd, delivery_serial_detail dsd,
	carton_serial cs with (nolock)
where dm.project_id = :gs_project and cs.project_id = :gs_project
and dpd.do_no = dm.do_no and dsd.id_no = dpd.id_no
and cs.serial_no = dsd.serial_no
and cs.pallet_id = :as_pallet
;

/* Checking outbound serial numbers using the delivery picking detail lot no gives inconsistent results */
/*  Use serial no from carton serial against the pallet to check delivery serial detail for the pallet
DECLARE t_pallet CURSOR FOR
select rtrim(dm.wh_code) + '->' + rtrim(dm.cust_code), 
		dm.complete_date, dm.invoice_no, dm.cust_code, dsd.serial_no
from delivery_master dm, delivery_picking_detail dpd, delivery_serial_detail dsd with (nolock)
where dm.project_id = :gs_project
and dpd.do_no = dm.do_no and dsd.id_no = dpd.id_no
and dpd.lot_no = :as_pallet
; */

w_main.setmicrohelp("Pallet shipped: Checking for pallets.  Please wait.")

OPEN t_pallet;
if SQLCA.SQLCODE <> 0 then
	MessageBox("Error opening cursor t_pallet in uf_get_transferred",SQLCA.SQLErrText)
else
	Fetch t_pallet Into :ls_WHCode, :ls_ComplDate, :ls_InvoiceNo, :ls_CustCode, :ls_SerialNo;
	if SQLCA.SQLCODE = 100 then			// No pallets for this order.. 
		//messagebox("Reading pallets for outbound order","No order associated with PalletID " + as_pallet + ". ")
		retVal = 0 		// Pallet does not have any serial numbers shipped
	else
		DO WHILE SQLCA.SQLCODE <> 100
			/*
			ls_Find = "serialnbr = '" + ls_SerialNo + "'"
			liRow = dw_results.Find(ls_Find,1,dw_results.RowCount())

			if liRow = 0 then
				messagebox("Finding the serial number","Could not find SN with "+ls_Find)
			else
				messagebox("Finding the serial number","Found " + ls_SerialNo + " with filter:" + ls_Find)
			end if
			*/
			liRow = ids_serial.InsertRow(0)
			ids_serial.SetItem(liRow, 1, as_pallet)
			ids_serial.SetItem(liRow, 2, ls_SerialNo)
			ids_serial.SetItem(liRow, 3, ls_WHCode)
			ids_serial.SetItem(liRow, 4, ls_ComplDate)
			ids_serial.SetItem(liRow, 5, ls_InvoiceNo)
			ids_serial.SetItem(liRow, 6, ls_CustCode)

			Fetch t_pallet Into :ls_WHCode, :ls_ComplDate, :ls_InvoiceNo, :ls_CustCode, :ls_SerialNo;
		LOOP
	end if
end if
CLOSE t_pallet;

w_main.setmicrohelp("Pallet shipped.  Done.")
/*
liRows = ids_serial.rowcount()
ls_Msg = string(liRows) + " Serials:"
for liRow = 1 to liRows
	ls_Msg += ids_serial.getitemstring(liRow, 5) + ", "
next

MessageBox("Pallet shipped",ls_Msg)
*/
return retVal
end function

on w_resend_transactions.create
this.cbx_1=create cbx_1
this.rb_update=create rb_update
this.cb_savetofile=create cb_savetofile
this.rb_order=create rb_order
this.st_cnt2=create st_cnt2
this.st_cnt1=create st_cnt1
this.sle_refnbr=create sle_refnbr
this.st_refnbr=create st_refnbr
this.st_saveto=create st_saveto
this.sle_path=create sle_path
this.rb_tup=create rb_tup
this.rb_trc=create rb_trc
this.rb_tsu=create rb_tsu
this.dw_results=create dw_results
this.st_note1=create st_note1
this.mle_serial=create mle_serial
this.st_serial=create st_serial
this.sle_tosite=create sle_tosite
this.st_tosite=create st_tosite
this.st_fromsite=create st_fromsite
this.sle_fromsite=create sle_fromsite
this.cb_export=create cb_export
this.cb_help=create cb_help
this.cb_ok=create cb_ok
this.rb_pallet=create rb_pallet
this.rb_serial=create rb_serial
this.cb_retrieve=create cb_retrieve
this.gb_1=create gb_1
this.gb_2=create gb_2
this.shl_help=create shl_help
this.Control[]={this.cbx_1,&
this.rb_update,&
this.cb_savetofile,&
this.rb_order,&
this.st_cnt2,&
this.st_cnt1,&
this.sle_refnbr,&
this.st_refnbr,&
this.st_saveto,&
this.sle_path,&
this.rb_tup,&
this.rb_trc,&
this.rb_tsu,&
this.dw_results,&
this.st_note1,&
this.mle_serial,&
this.st_serial,&
this.sle_tosite,&
this.st_tosite,&
this.st_fromsite,&
this.sle_fromsite,&
this.cb_export,&
this.cb_help,&
this.cb_ok,&
this.rb_pallet,&
this.rb_serial,&
this.cb_retrieve,&
this.gb_1,&
this.gb_2,&
this.shl_help}
end on

on w_resend_transactions.destroy
destroy(this.cbx_1)
destroy(this.rb_update)
destroy(this.cb_savetofile)
destroy(this.rb_order)
destroy(this.st_cnt2)
destroy(this.st_cnt1)
destroy(this.sle_refnbr)
destroy(this.st_refnbr)
destroy(this.st_saveto)
destroy(this.sle_path)
destroy(this.rb_tup)
destroy(this.rb_trc)
destroy(this.rb_tsu)
destroy(this.dw_results)
destroy(this.st_note1)
destroy(this.mle_serial)
destroy(this.st_serial)
destroy(this.sle_tosite)
destroy(this.st_tosite)
destroy(this.st_fromsite)
destroy(this.sle_fromsite)
destroy(this.cb_export)
destroy(this.cb_help)
destroy(this.cb_ok)
destroy(this.rb_pallet)
destroy(this.rb_serial)
destroy(this.cb_retrieve)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.shl_help)
end on

event open;Integer		 li_ScreenH, li_ScreenW
Environment le_Env

// Use dataobject from common pbl (d_find - find_column (250) and find_value (250))
ids_list = Create datastore
ids_list.dataobject = "d_find"
ids_order = Create datastore
ids_order.dataobject = "d_find"
ids_recd = Create datastore
ids_recd.dataobject = "d_find"
ids_content = Create datastore
ids_content.dataobject = "d_find"
ids_dlvd = Create datastore
ids_dlvd.dataobject = "d_find"
ids_outb = Create datastore
ids_outb.dataobject = "d_find"
ids_pallet = Create datastore
ids_pallet.dataobject = "d_comcast_recon"
ids_serial = Create datastore
ids_serial.dataobject = "d_comcast_recon"

// Set export path from INI file
is_path = ProfileString(gs_inifile,"export","path","")
sle_path.text = is_path

// Get help file
shl_help.url = gs_syspath + "ResendComcastEISTransactions.chm"

// Send Address and Attribute fields
cbx_1.checked = true

//Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2

dw_results.Visible = False
//dw_results.y = 338
cb_export.enabled = true

//Initial query choice is by Order:
rb_order.checked = True
st_saveto.visible = False
sle_path.visible = False
st_refnbr.visible = True
sle_refnbr.visible = True

st_serial.Visible = True
mle_serial.Visible = True
st_note1.Visible = True


end event

event resize;
dw_results.Resize(dw_results.width,workspaceHeight() - 470)
end event

type cbx_1 from checkbox within w_resend_transactions
boolean visible = false
integer x = 3639
integer y = 132
integer width = 667
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Include Addr fields"
boolean checked = true
end type

type rb_update from radiobutton within w_resend_transactions
integer x = 82
integer y = 256
integer width = 457
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "TUP - Update"
end type

event clicked;is_tran_type = "UPD"

// Initialize for TUP - Delete
sle_fromsite.text = ''
sle_fromsite.enabled = True
sle_tosite.text = ''
sle_tosite.enabled = True

// Reference number
sle_refnbr.text = ''
sle_refnbr.enabled = True
st_refnbr.visible = True
sle_refnbr.visible = True

mle_serial.text = ''
dw_results.Reset()
dw_results.Visible = False

// Status for TUP is 'deleted'
is_status = 'Received'

end event

type cb_savetofile from commandbutton within w_resend_transactions
integer x = 2866
integer y = 252
integer width = 699
integer height = 84
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save to File"
end type

event clicked;//MessageBox("Under Construction","Under Construction")

dw_results.SaveAs()

return 0





end event

type rb_order from radiobutton within w_resend_transactions
integer x = 869
integer y = 76
integer width = 462
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "&Order Nbr:"
end type

event clicked;// Query by order number
st_serial.visible = True
mle_serial.visible = True
mle_serial.taborder = 60
st_note1.visible = True
st_saveto.visible = False
sle_path.visible = False

// Reset variables
st_serial.text = 'List Order Nbr(s):'
st_note1.text = '(Line break between orders)'
mle_serial.text = ""
dw_results.reset()
dw_results.visible = False

cb_retrieve.default = False	

st_cnt2.text = "0"			// Reset receive count to zero

// Reset reference number
	st_refnbr.visible = True
	sle_refnbr.visible = True
	sle_refnbr.text = ''
	sle_refnbr.enabled = True		


end event

type st_cnt2 from statictext within w_resend_transactions
integer x = 2409
integer y = 276
integer width = 169
integer height = 56
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 255
long backcolor = 67108864
string text = "0"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_cnt1 from statictext within w_resend_transactions
integer x = 1966
integer y = 276
integer width = 443
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Retrieved Count:"
boolean focusrectangle = false
end type

type sle_refnbr from singlelineedit within w_resend_transactions
integer x = 1833
integer y = 184
integer width = 896
integer height = 72
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_refnbr from statictext within w_resend_transactions
integer x = 1527
integer y = 184
integer width = 288
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Ref No:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_saveto from statictext within w_resend_transactions
integer x = 1541
integer y = 360
integer width = 311
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Export To:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_path from singlelineedit within w_resend_transactions
integer x = 1870
integer y = 356
integer width = 1710
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type rb_tup from radiobutton within w_resend_transactions
integer x = 82
integer y = 196
integer width = 457
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "TUP - Delete"
end type

event clicked;is_tran_type = "TUP"

// Initialize for TUP - Delete
sle_fromsite.text = ''
sle_fromsite.enabled = True
sle_tosite.text = ''
sle_tosite.enabled = True

// Reference number
sle_refnbr.text = ''
sle_refnbr.enabled = True
st_refnbr.visible = True
sle_refnbr.visible = True

mle_serial.text = ''
dw_results.Reset()
dw_results.Visible = False

// Status for TUP is 'deleted'
is_status = 'DELETED'

end event

type rb_trc from radiobutton within w_resend_transactions
integer x = 82
integer y = 136
integer width = 457
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "TRC - Receive"
end type

event clicked;is_tran_type = "TRC"

// Initialize for TRC - Receive
sle_fromsite.text = ''
sle_fromsite.enabled = False	// From site is blank
sle_tosite.text = ''
sle_tosite.enabled = True

st_refnbr.visible = True
sle_refnbr.visible = True
sle_refnbr.text = ''
sle_refnbr.enabled = True		// Reference number

mle_serial.text = ''
dw_results.Reset()
dw_results.Visible = False

// Reset status
is_status = ""

end event

type rb_tsu from radiobutton within w_resend_transactions
integer x = 82
integer y = 76
integer width = 457
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "TSU - Transfer"
end type

event clicked;is_tran_type = "TSU"

// Initialize for TSU - Transfer
sle_fromsite.text = ''
sle_fromsite.enabled = True
sle_tosite.text = ''
sle_tosite.enabled = True

st_refnbr.visible = True
sle_refnbr.visible = True
sle_refnbr.text = ''
sle_refnbr.enabled = True		// Reference number

mle_serial.text = ''
dw_results.Reset()
dw_results.Visible = False

// Reset status
is_status = ""


end event

type dw_results from datawindow within w_resend_transactions
integer x = 814
integer y = 440
integer width = 3904
integer height = 1380
string title = "none"
string dataobject = "d_resend_transactions"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_note1 from statictext within w_resend_transactions
integer x = 585
integer y = 368
integer width = 741
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "(Line break between orders)"
boolean focusrectangle = false
end type

type mle_serial from multilineedit within w_resend_transactions
integer x = 41
integer y = 440
integer width = 736
integer height = 1380
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_serial from statictext within w_resend_transactions
integer x = 46
integer y = 364
integer width = 535
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "List Order Nbr(s):"
boolean focusrectangle = false
end type

type sle_tosite from singlelineedit within w_resend_transactions
integer x = 1833
integer y = 104
integer width = 896
integer height = 68
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_tosite from statictext within w_resend_transactions
integer x = 1527
integer y = 104
integer width = 288
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "ToSite:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_fromsite from statictext within w_resend_transactions
integer x = 1527
integer y = 20
integer width = 288
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "FromSite:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_fromsite from singlelineedit within w_resend_transactions
integer x = 1833
integer y = 20
integer width = 896
integer height = 72
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type cb_export from commandbutton within w_resend_transactions
integer x = 2866
integer y = 136
integer width = 704
integer height = 84
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Export"
end type

event clicked;//MessageBox("Under Construction","Under Construction")
int li_cnt, li_rec, li_add, li_send, li_valid, li_files_sent
string ls_trantype, ls_fromsite, ls_tosite, ls_serial, ls_pallet,ls_detailtype, ls_model, ls_out_model, ls_bolid
string ls_addr1, ls_addr2, ls_addr3, ls_addr4, ls_addr5, ls_attr1, ls_attr2, ls_attr3, ls_attr4, ls_attr5
string ls_line, ls_separator, ls_blank
		
boolean send_file

send_file = false
li_files_sent = 0
is_path = sle_path.text
is_refnbr = trim(sle_refnbr.text)		// Reference number for both TSU and TRC

ls_separator = "|"
ls_blank = ''
is_text = ''
is_msg = ''
ls_model = ''
ls_out_model = ''
ls_bolid = ""
is_append1 = '' 
is_append2 = ''
is_append3 = ''
is_append4 = ''
is_append5 = ''
is_append6 = '' 
is_append7 = ''
is_append8 = ''
is_append9 = ''
is_append10 = ''

//Validate From and To sites before creating export file
if uf_validate_from_to_site() = 0 then
	li_cnt = dw_results.RowCount()
	if li_cnt = 0 then
		MessageBox("Empty Result Set","Cannot continue.  No records to send.")
	else
		//MessageBox("Datawindow RowCount",string(li_cnt))
		for li_rec = 1 to li_cnt
			ls_trantype = trim(dw_results.GetItemString(li_rec,"trantype"))
			ls_fromsite = trim(dw_results.GetItemString(li_rec,"fromsite"))
			ls_tosite = trim(dw_results.GetItemString(li_rec,"tosite"))
			ls_serial = trim(dw_results.GetItemString(li_rec, "serialnbr"))
			ls_pallet = trim(dw_results.GetItemString(li_rec, "pallet"))
			ls_bolid = trim(dw_results.GetItemString(li_rec, "bolid"))
			ls_detailtype = trim(dw_results.GetItemString(li_rec, "detailtype"))
			ls_addr1 = trim(dw_results.GetItemString(li_rec, "addr1"))
			ls_addr2 = trim(dw_results.GetItemString(li_rec, "addr2"))
			ls_addr3 = trim(dw_results.GetItemString(li_rec, "addr3"))
			ls_addr4 = trim(dw_results.GetItemString(li_rec, "addr4"))
			ls_addr5 = trim(dw_results.GetItemString(li_rec, "addr5"))	
			ls_attr1 = trim(dw_results.GetItemString(li_rec, "attr1"))
			ls_attr2 = trim(dw_results.GetItemString(li_rec, "attr2"))
			ls_attr3 = trim(dw_results.GetItemString(li_rec, "attr3"))
			ls_attr4 = trim(dw_results.GetItemString(li_rec, "attr4"))
			ls_attr5 = trim(dw_results.GetItemString(li_rec, "attr5"))	
			
			if isnull(ls_addr1) then ls_addr1 = ls_blank
			if isnull(ls_addr2) then ls_addr2 = ls_blank
			if isnull(ls_addr3) then ls_addr3 = ls_blank
			if isnull(ls_addr4) then ls_addr4 = ls_blank
			if isnull(ls_addr5) then ls_addr5 = ls_blank
			if isnull(ls_attr1) then ls_attr1 = ls_blank
			if isnull(ls_attr2) then ls_attr2 = ls_blank
			if isnull(ls_attr3) then ls_attr3 = ls_blank
			if isnull(ls_attr4) then ls_attr4 = ls_blank
			if isnull(ls_attr5) then ls_attr5 = ls_blank
			
			ls_model = trim(dw_results.GetItemString(li_rec, "model"))
			if Pos(ls_model,"^") > 0 then
				ls_out_model = uf_get_model(left(ls_model,Pos(ls_model,"^")-1),right(ls_model,len(ls_model)-pos(ls_model,"^")))
			else
				ls_out_model = ls_model
			end if
			
			// If trantype is TSU use the outbound order number for BOL ID
			if ls_trantype = 'TSU' then
				ls_bolid = trim(dw_results.GetItemString(li_rec,"tsorder"))
			end if
			
			// EIS rolls up certain product model numbers and will not accept the number unless it exists in EIS
			// For future implementation if Comcast wants the model rolled up
			//ls_out_model = uf_get_eis_rollup_model(ls_model)
			if cbx_1.checked = true then
					ls_line = ls_trantype+ls_separator+ls_fromsite+ls_separator+ls_tosite+ls_separator+ &
								is_refnbr+ls_separator+ls_blank+ls_separator+ls_blank+ls_separator+ &
								is_status+ls_separator+ls_pallet+ls_separator+ls_bolid+ls_separator+ &
								ls_serial+ls_separator+ls_detailtype+ls_separator+ls_out_model+ &
								ls_separator+ls_addr1+ls_separator+ls_addr2+ls_separator+ls_addr3+ &
								ls_separator+ls_addr4+ls_separator+ls_addr5+&
								ls_separator+ls_attr1+ls_separator+ls_attr2+ls_separator+ls_attr3+ &
								ls_separator+ls_attr4+ls_separator+ls_attr5
					else
					ls_line = ls_trantype+ls_separator+ls_fromsite+ls_separator+ls_tosite+ls_separator+ &
								is_refnbr+ls_separator+ls_blank+ls_separator+ls_blank+ls_separator+ &
								is_status+ls_separator+ls_pallet+ls_separator+ls_bolid+ls_separator+ &
								ls_serial+ls_separator+ls_detailtype+ls_separator+ls_out_model+ &
								ls_separator+ls_blank+ls_separator+ls_blank+ls_separator+ls_blank+ &
								ls_separator+ls_blank+ls_separator+ls_blank+&
								ls_separator+ls_blank+ls_separator+ls_blank+ls_separator+ls_blank+ &
								ls_separator+ls_blank+ls_separator+ls_blank
					end if
			send_file = false
			if li_rec = li_cnt then		//Send each pallet in a separate file
				send_file = true
			else
				if ls_pallet <> trim(dw_results.GetItemString(li_rec+1, "pallet")) then
					send_file = true
				end if
			end if
	
			li_add = uf_add_transaction(ls_line)
			if li_add <> -1 then
				if send_file then
					li_send = uf_send_file(ls_pallet)
					li_files_sent = li_files_sent + 1
					send_file = false
				end if
			end if
		next
		
	end if
	
	// Set export path in INI file
	SetProfileString(gs_iniFile,"export","path",is_path)
	cb_export.default = False
	is_msg = "Pallet Files Sent: " + string(li_files_sent)
	MessageBox("Resend Transaction Export",is_msg)
else
	dw_results.Reset()
end if

return 0





end event

type cb_help from commandbutton within w_resend_transactions
boolean visible = false
integer x = 2985
integer y = 172
integer width = 315
integer height = 108
integer taborder = 120
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Help"
end type

event clicked;ShowHelp(g.is_helpfile,topic!,543) /*open by topic ID*/
end event

type cb_ok from commandbutton within w_resend_transactions
integer x = 3232
integer y = 20
integer width = 338
integer height = 84
integer taborder = 110
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Done"
end type

event clicked;
Close(parent)
end event

type rb_pallet from radiobutton within w_resend_transactions
integer x = 869
integer y = 136
integer width = 489
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "&PalletID:"
end type

event clicked;
// Query by pallet
st_serial.visible = True
mle_serial.visible = True
mle_serial.taborder = 60
st_note1.visible = true
st_saveto.visible = False
sle_path.visible = False

// Reset variables
st_serial.text = 'List Pallet ID(s):'
st_note1.text = '(Line break between pallets)'
sle_fromsite.text = ""
sle_tosite.text = ""
mle_serial.text = ""
dw_results.reset()
dw_results.visible = False

cb_retrieve.default = False

st_cnt2.text = "0"			// Reset receive count to zero

// Reset reference number
	st_refnbr.visible = True
	sle_refnbr.visible = True
	sle_refnbr.text = ''
	sle_refnbr.enabled = True		

end event

type rb_serial from radiobutton within w_resend_transactions
integer x = 869
integer y = 196
integer width = 489
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "&Serial Nbr:"
end type

event clicked;// Query by serial number
st_serial.visible = True
mle_serial.visible = True
mle_serial.taborder = 60
st_note1.visible = True
st_saveto.visible = False
sle_path.visible = False

// Reset variables
st_serial.text = 'List Serial Nbr(s):'
st_note1.text = '(MAXIMUM: 2,000 Serial No)'
mle_serial.text = ""
dw_results.reset()
dw_results.visible = False

cb_retrieve.default = False	

st_cnt2.text = "0"			// Reset receive count to zero

// Reset reference number
	st_refnbr.visible = True
	sle_refnbr.visible = True
	sle_refnbr.text = ''
	sle_refnbr.enabled = True		

end event

type cb_retrieve from commandbutton within w_resend_transactions
integer x = 2866
integer y = 20
integer width = 338
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;long li_result


// Reset dw_result
ids_order.Reset()
dw_results.Reset()
ids_pallet.Reset()
ids_serial.Reset()

is_msg = ''
if rb_tsu.checked = True then 
	is_tran_type = 'TSU'
elseif rb_trc.checked = True then
	is_tran_type = 'TRC'
elseif rb_tup.checked = True then
	is_tran_type = 'TUP'
elseif rb_update.checked = True then
	is_tran_type = 'TUP'
end if

/* Return if Item List is empty */
if mle_serial.text = "" then
	MessageBox("Resend Transaction Utility","No items to query.  Please enter and resubmit.")
	mle_serial.SetFocus()
	return
end if
li_result = uf_get_list()
//if li_result = 0 then
//	li_result = ids_list.RowCount()
//else
//	messagebox("Get List Error","Error " + string(li_result))
//end if

if 	rb_pallet.checked then
	ii_result = uf_retrieve_pallet()
	if ii_result = 0	then		// No records or invalid pallet_id
		cb_retrieve.default = True
		mle_serial.SetFocus()
	else
		st_cnt2.text = String(ii_result)
		cb_export.default = False
		cb_export.enabled = True
		dw_results.Visible = True
		st_saveto.Visible = True
		sle_path.Visible = True
	end if
elseif rb_serial.checked then
	ii_result = uf_retrieve_serial()
	if ii_result >= 1 then
		st_cnt2.text = String(ii_result)
		cb_export.enabled = True
		dw_results.Visible = True
		st_saveto.Visible = True
		sle_path.Visible = True
	end if
elseif rb_order.checked then
	ii_result = uf_retrieve_order()
	if ii_result >= 1 then
		st_cnt2.text = String(ii_result)
		cb_export.enabled = True
		dw_results.Visible = True
		st_saveto.Visible = True
		sle_path.Visible = True
	end if
end if

dw_results.SetSort("pallet A")
dw_results.sort()

if is_msg <> '' then
	MessageBox("Some records not found", is_msg)
end if
 

end event

type gb_1 from groupbox within w_resend_transactions
integer x = 800
integer y = 20
integer width = 590
integer height = 268
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Query By"
end type

type gb_2 from groupbox within w_resend_transactions
integer x = 50
integer y = 20
integer width = 590
integer height = 316
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Export Type:"
end type

type shl_help from statichyperlink within w_resend_transactions
integer x = 3602
integer y = 356
integer width = 315
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 67108864
string text = "&Help"
alignment alignment = center!
boolean focusrectangle = false
boolean righttoleft = true
string url = "ResendComcastEISTransactions.chm"
end type

event clicked;MessageBox("Help File","FileName:"+this.URL)
end event

