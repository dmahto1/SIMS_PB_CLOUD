HA$PBExportHeader$w_nike_cc_data_entry.srw
forward
global type w_nike_cc_data_entry from window
end type
type dw_report from datawindow within w_nike_cc_data_entry
end type
type cb_report from commandbutton within w_nike_cc_data_entry
end type
type dw_print from datawindow within w_nike_cc_data_entry
end type
type cb_print from commandbutton within w_nike_cc_data_entry
end type
type cb_search from commandbutton within w_nike_cc_data_entry
end type
type dw_search from datawindow within w_nike_cc_data_entry
end type
type dw_main from datawindow within w_nike_cc_data_entry
end type
type cb_clear from commandbutton within w_nike_cc_data_entry
end type
type dw_pc_master from datawindow within w_nike_cc_data_entry
end type
type cb_delete from commandbutton within w_nike_cc_data_entry
end type
type cb_insert from commandbutton within w_nike_cc_data_entry
end type
end forward

global type w_nike_cc_data_entry from window
integer x = 9
integer y = 4
integer width = 3813
integer height = 1992
boolean titlebar = true
string title = "DataEntry for CycleCount by SKU"
string menuname = "m_simple_edit"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event type long ue_save ( )
event ue_print ( )
dw_report dw_report
cb_report cb_report
dw_print dw_print
cb_print cb_print
cb_search cb_search
dw_search dw_search
dw_main dw_main
cb_clear cb_clear
dw_pc_master dw_pc_master
cb_delete cb_delete
cb_insert cb_insert
end type
global w_nike_cc_data_entry w_nike_cc_data_entry

type variables
m_simple_record curr_menu
string win_title,i_org_sql,cc_no
boolean record_changed

boolean iIsSku
end variables

forward prototypes
public function integer wf_save_changes ()
end prototypes

event type long ue_save();String curr_order,curr_sku,prev_sku,curr_category,prev_category,curr_coo,prev_coo
String curr_loc,prev_loc, curr_type, prev_type
Long row_cnt, row_no, update_result, ll_owner_id, ll_line_item_no
String ls_sku, ls_supp_code, ls_ro_no
Long ll_cnt
DateTime curr_receipt,prev_receipt


string ls_cc_no, ls_l_code, ls_inventory_type, ls_stock_category, ls_coo
string ls_Serial_No, ls_Po_No, ls_Po_No2, ls_container_id

datetime ldt_receipt_date
integer li_count


SetPointer(HourGlass!)
dw_main.AcceptText()

//check duplicate and invalid detail records

dw_main.Sort()

integer li_idx
integer li_count_level
decimal     ll_quantity

for li_idx = 1 to dw_main.RowCount()
	
	if dw_main.GetItemStatus( li_idx, "quantity", Primary!) = Datamodified! then
		
		li_count_level = dw_main.GetItemNumber(li_idx, "count_level")
		ll_quantity = dw_main.GetItemNumber(li_idx, "quantity")
	
		ls_cc_no = dw_main.GetItemString(li_idx, "cc_no")
		ls_l_code = dw_main.GetItemString(li_idx, "l_code")
		ls_sku  = dw_main.GetItemString(li_idx, "sku")
		ls_supp_code  = dw_main.GetItemString(li_idx, "supp_code")
		ls_inventory_type = dw_main.GetItemString(li_idx, "inventory_type")
		ls_stock_category = dw_main.GetItemString(li_idx, "stock_category")
		ls_coo = dw_main.GetItemString(li_idx, "coo")
		ldt_receipt_date = dw_main.GetItemDateTime(li_idx, "receipt_date")
		ll_owner_id = dw_main.GetItemNumber(li_idx, "owner_id")
		ls_Serial_No = dw_main.GetItemString(li_idx, "serial_no")
		ls_Po_No = dw_main.GetItemString(li_idx, "po_no")
		ls_Po_No2 = dw_main.GetItemString(li_idx, "po_no2")
		ls_container_id = dw_main.GetItemString(li_idx, "container_id")
		ll_line_item_no = dw_main.GetItemNumber(li_idx, "line_item_no")
		ls_ro_no = dw_main.GetItemString(li_idx, "ro_no")
		
		CHOOSE CASE li_count_level
				
			CASE 1
					
				SELECT count(quantity) INTO :li_count
					FROM cc_result_1
					WHERE cc_no = :ls_cc_no and
							   l_code = :ls_l_code and
							   sku = :ls_sku and
							   inventory_type = :ls_inventory_type and
							   lot_no = :ls_stock_category and
							   country_of_origin = :ls_coo and
							   line_item_no = :ll_line_item_no and
							   expiration_date = :ldt_receipt_date and
								ro_no = :ls_ro_no USING SQLCA;
				
				if li_count > 0 then

					UPDATE cc_result_1 set quantity = :ll_quantity
						WHERE cc_no = :ls_cc_no and
									l_code = :ls_l_code and
									sku = :ls_sku and
									inventory_type = :ls_inventory_type and
									lot_no = :ls_stock_category and
									country_of_origin = :ls_coo and
									expiration_date = :ldt_receipt_date and
								ro_no = :ls_ro_no USING SQLCA;
								
				else
								
					INSERT  cc_result_1
							(cc_no, sku, supp_code, l_code,  inventory_type, quantity, lot_no, country_of_origin, expiration_date, owner_id, Serial_No, Po_No, Po_No2, container_id, line_item_no, ro_no )
							VALUES ( :ls_cc_no, :ls_sku, :ls_supp_code,:ls_l_code, :ls_inventory_type, :ll_quantity, :ls_stock_category, :ls_coo, :ldt_receipt_date, :ll_owner_id, :ls_Serial_No, :ls_Po_No, :ls_Po_No2, :ls_container_id, :ll_line_item_no, :ls_ro_no ) USING SQLCA;
				
				end if
							
								
			CASE 2
				
				SELECT count(quantity) INTO :li_count
					FROM cc_result_2
					WHERE cc_no = :ls_cc_no and
							   l_code = :ls_l_code and
							   sku = :ls_sku and
							   inventory_type = :ls_inventory_type and
							   lot_no = :ls_stock_category and
							   country_of_origin = :ls_coo and
							   line_item_no = :ll_line_item_no and
							   expiration_date = :ldt_receipt_date and
								ro_no = :ls_ro_no USING SQLCA;				
					
				if li_count > 0 then
				
					UPDATE cc_result_2 set quantity = :ll_quantity
						WHERE cc_no = :ls_cc_no and
									l_code = :ls_l_code and
									sku = :ls_sku and
									inventory_type = :ls_inventory_type and
									lot_no = :ls_stock_category and
									country_of_origin = :ls_coo and
							   		line_item_no = :ll_line_item_no and									
									expiration_date = :ldt_receipt_date and
									ro_no = :ls_ro_no USING SQLCA;			
									
				else
								
					INSERT  cc_result_2
							(cc_no, sku, supp_code, l_code,  inventory_type, quantity, lot_no, country_of_origin, expiration_date, owner_id, Serial_No, Po_No, Po_No2, container_id, line_item_no, ro_no )
							VALUES ( :ls_cc_no, :ls_sku, :ls_supp_code,:ls_l_code, :ls_inventory_type, :ll_quantity, :ls_stock_category, :ls_coo, :ldt_receipt_date, :ll_owner_id, :ls_Serial_No, :ls_Po_No, :ls_Po_No2, :ls_container_id, :ll_line_item_no, :ls_ro_no ) USING SQLCA;
	
		
				end if							
									
				
			CASE 3
				
				SELECT count(quantity) INTO :li_count
					FROM cc_result_3
					WHERE cc_no = :ls_cc_no and
							   l_code = :ls_l_code and
							   sku = :ls_sku and
							   inventory_type = :ls_inventory_type and
							   lot_no = :ls_stock_category and
							   country_of_origin = :ls_coo and
							   line_item_no = :ll_line_item_no and
							   expiration_date = :ldt_receipt_date and
								ro_no = :ls_ro_no USING SQLCA;			
				
				
				if li_count > 0 then
				
					UPDATE cc_result_3 set quantity = :ll_quantity
						WHERE cc_no = :ls_cc_no and
									l_code = :ls_l_code and
									sku = :ls_sku and
									inventory_type = :ls_inventory_type and
									lot_no = :ls_stock_category and
									country_of_origin = :ls_coo and
									line_item_no = :ll_line_item_no and
									expiration_date = :ldt_receipt_date and
								ro_no = :ls_ro_no USING SQLCA;	
									
				else
								
					INSERT  cc_result_3
							(cc_no, sku, supp_code, l_code,  inventory_type, quantity, lot_no, country_of_origin, expiration_date, owner_id, Serial_No, Po_No, Po_No2, container_id, line_item_no, ro_no )
							VALUES ( :ls_cc_no, :ls_sku, :ls_supp_code,:ls_l_code, :ls_inventory_type, :ll_quantity, :ls_stock_category, :ls_coo, :ldt_receipt_date, :ll_owner_id, :ls_Serial_No, :ls_Po_No, :ls_Po_No2, :ls_container_id, :ll_line_item_no, :ls_ro_no ) USING SQLCA;
		
				end if		
									
				
		
		END CHOOSE
		
		
		  if SQLCA.SQLCode <> 0 then
			 	MessageBox ("SQL DB Error", SQLCA.SQLErrText )					
		   end if
		
	end if
	
	
next

dw_main.ResetUpdate()

record_changed = false

return 0 
//row_cnt = dw_main.RowCount()
//For row_no = row_cnt To 1 Step -1
//	curr_sku = trim(dw_main.GetItemString(row_no, "sku"))
//	curr_loc = trim(dw_main.GetItemString(row_no, "l_code"))
//	curr_type = dw_main.GetItemString(row_no, "inventory_type")
//	curr_category = dw_main.GetItemString(row_no,"stock_category")
//	curr_coo = dw_main.GetItemString(row_no,"coo")
//	curr_receipt = dw_main.GetITemDateTime(row_no,"receipt_date")
//	If IsNull(curr_sku) or IsNull(curr_loc) or IsNull(curr_type) Then
//		MessageBox(win_title,"Found invalid item, please check!")
//		dw_main.SetFocus()
//		dw_main.ScrollToRow(row_no)
//		dw_main.SetRow(row_no)
//		dw_main.SetColumn("l_code")
//		Return 0
//	End If
//	
//	If (curr_sku = prev_sku and curr_type = prev_type and curr_loc = prev_loc &
// 	   and curr_category = prev_category and curr_coo = prev_coo and curr_receipt = prev_receipt )Then 
//		MessageBox(win_title,"Found duplicate item, please check!")
//		dw_main.SetFocus()
//		dw_main.ScrollToRow(row_no)
//		dw_main.SetRow(row_no)
//		dw_main.SetColumn("l_code")
//		Return 0
//	Else
//		dw_main.SetItem(row_no,"cc_no", cc_no)
//	End If
//	prev_sku = curr_sku
//	prev_loc = curr_loc
//	prev_type = curr_type
//	prev_category = curr_category
//	prev_coo = curr_coo
//	prev_receipt = curr_receipt
//Next
//
//For row_no = 1 to dw_main.rowcount()
//	If dw_main.GetItemStatus(row_no,0,Primary!) <> NotModified! Then
//		ls_sku = ''
//		ll_cnt = 0
//		curr_sku = dw_main.getitemstring(row_no,"sku")
//		
//		
//	   Select sku 
//			Into :ls_sku 
//			From item_master 
//			Where sku = :curr_sku AND project_id = :gs_project;
//			
//		If sqlca.sqlcode <> 0 Then
//			MessageBox (string(row_no), curr_sku)
//			Messagebox(win_title,"Item not found in item master, please re-enter!")
//			dw_main.SetFocus()
//			dw_main.ScrollToRow(row_no)
//			dw_main.SetRow(row_no)
//			dw_main.SetColumn("sku")
//			Return 0
//		End If
//		
//		ll_cnt = 0
//		curr_loc = dw_main.GetItemString(row_no,"l_code")
//	   Select count(*) Into :ll_cnt From location, project_warehouse 
//			Where location.wh_code =  project_warehouse.wh_code and project_warehouse.project_id = :gs_project and l_code = :curr_loc;
//		If IsNull(ll_cnt) or ll_cnt = 0 Then
//			Messagebox(win_title,"Invalid location, please re-enter!")
//			dw_main.SetFocus()
//			dw_main.ScrollToRow(row_no)
//			dw_main.SetRow(row_no)
//			dw_main.SetColumn("l_code")
//			Return 0
//		End If		
//	End If
//Next


//---

//---


//
//update_result = dw_main.Update()
//If update_result = 1 Then
//	Commit;
//   If SQLCA.SQLCode = 0 Then
////   	dw_main.ResetUpdate()
//     	record_changed = False
//		SetMicroHelp("Record Saved!")
//		Return 1 
//   Else
//		Rollback;
//     	MessageBox(win_title, SQLCA.SQLErrText)
//		SetMicroHelp("Save failed!")
//		Return 0
//	End If
//Else
//   RollBack;
//	SetMicroHelp("Save failed!")
//	Messagebox(win_title,"System error, record save failed!")
//	Return 0
//End If
end event

public function integer wf_save_changes ();long ll_status

if record_changed then
	choose case MessageBox(win_title,"Save Changes?",Question!,YesNoCancel!,3)
		case 1
			ll_status = w_nike_cc_data_entry.Trigger Event ue_save()
			Return ll_status
		case 2
			record_changed = false
			return 1
		case 3
			return 0
	end choose
else
	return 1
end if

end function

on w_nike_cc_data_entry.create
if this.MenuName = "m_simple_edit" then this.MenuID = create m_simple_edit
this.dw_report=create dw_report
this.cb_report=create cb_report
this.dw_print=create dw_print
this.cb_print=create cb_print
this.cb_search=create cb_search
this.dw_search=create dw_search
this.dw_main=create dw_main
this.cb_clear=create cb_clear
this.dw_pc_master=create dw_pc_master
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
this.Control[]={this.dw_report,&
this.cb_report,&
this.dw_print,&
this.cb_print,&
this.cb_search,&
this.dw_search,&
this.dw_main,&
this.cb_clear,&
this.dw_pc_master,&
this.cb_delete,&
this.cb_insert}
end on

on w_nike_cc_data_entry.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
destroy(this.cb_report)
destroy(this.dw_print)
destroy(this.cb_print)
destroy(this.cb_search)
destroy(this.dw_search)
destroy(this.dw_main)
destroy(this.cb_clear)
destroy(this.dw_pc_master)
destroy(this.cb_delete)
destroy(this.cb_insert)
end on

event open;This.move(0,0)

Str_parms	lstrparms

lstrparms = message.PowerObjectParm

if lstrparms.string_arg[1] = "SKU" then
	iIsSku = true
else
	iIsSku = false
	
	dw_main.dataobject = "d_nike_pc_dataentry"
	
	dw_report.dataobject = "d_nike_stock_verification_loc_rpt"
	
	dw_print.dataobject = "d_nike_pc_dataentry_print"
	
	
end if


IF NOT iIsSku Then
	this.title = "DataEntry for CycleCount by Location"
End IF 

curr_menu = This.MenuId
win_title = This.Title

curr_menu.m_file.m_print.Enabled = True
// Changing menu properties
curr_menu.m_file.m_save.Enable()
curr_menu.m_file.m_retrieve.Disable()

dw_main.SetTransObject(sqlca)
dw_search.settransobject(sqlca)
dw_pc_master.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_report.settransobject(sqlca)

dw_search.insertrow(0)
i_org_sql = dw_main.getsqlselect()

datawindowchild ldw_child

dw_main.GetChild( "inventory_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(gs_project)
end event

event closequery;dw_main.AcceptText()
if wf_save_changes() = 0 then
	return 1
else
	return 0
end if
end event

type dw_report from datawindow within w_nike_cc_data_entry
boolean visible = false
integer x = 379
integer y = 208
integer width = 494
integer height = 360
integer taborder = 30
string dataobject = "d_nike_stock_verification_rpt"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_report from commandbutton within w_nike_cc_data_entry
integer x = 137
integer y = 144
integer width = 311
integer height = 108
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Report"
end type

event clicked;Long row_cnt, row_no
Long line_gain, line_loss
Long tot_system, tot_count
string ls_cc_no          //   l_lob not used in Nike Shanghai 
string ls_s_loc, ls_e_loc, ls_where, ls_ord_status, ls_sql
Long i, ll_row

dw_report.AcceptText()
if wf_save_changes() = 0 then
	return
end if

if dw_main.rowcount() <= 0 Then
	Messagebox(win_title, "No record!")
	Return
End If

dw_search.accepttext()
dw_report.reset()

ls_cc_no = dw_search.getitemstring(1,"cc_no")
ls_s_loc = dw_search.getitemstring(1,"s_loc")
ls_e_loc = dw_search.getitemstring(1,"e_loc")

If isnull(ls_cc_no) Then
	messagebox(win_title, "please enter CC No.!")
	Return
End If

if isnull(ls_s_loc) and isnull(ls_e_loc) then
	messagebox(win_title, "Please enter location!")
	Return
End If

// check pc_master
If dw_pc_master.Retrieve(ls_cc_no) <= 0 Then
	messagebox(win_title, "Not found this order!")
	Return
Else
	If dw_pc_master.GetItemString(1, "ord_status") = "C" Then
		messagebox(win_title, "This order is confirmed!")
		Return
	End if
end if

row_cnt = dw_report.Retrieve(ls_cc_no, ls_s_loc, ls_e_loc)
If row_cnt <= 0 Then
	messagebox(win_title, "No record found!")
	Return
end if


SetPointer(Hourglass!)
line_gain = 0
line_loss = 0
tot_system = 0
tot_count = 0
For row_no = 1 to row_cnt
	tot_system += dw_report.GetItemNumber(row_no, "systemqty")
	tot_count += dw_report.GetItemNumber(row_no, "ccountqty")	
	If dw_report.GetItemNumber(row_no, "stock_diff") > 0 Then
		line_gain = line_gain + 1
	Else
		If dw_report.GetItemNumber(row_no, "stock_diff") < 0 Then
			line_loss = line_loss + 1
		End If
	End If
Next

dw_report.Modify("line_gain.expression = '" + String(line_gain) + "'")
dw_report.Modify("line_loss.expression = '" + String(line_loss) + "'")
dw_report.Modify("total_line.expression = '" + String(row_cnt) + "'")
dw_report.Modify("total_system.expression = '" + String(tot_system) + "'")
dw_report.Modify("total_count.expression = '" + String(tot_count) + "'")
dw_report.Modify("skucnt.expression = '" + String(row_cnt) + "'")
//dw_report.SetFilter("stock_diff <> 0")
//dw_report.Filter()
openwithparm(w_dw_print_options,dw_report)
dw_report.SetFilter("")
end event

type dw_print from datawindow within w_nike_cc_data_entry
boolean visible = false
integer x = 46
integer y = 1164
integer width = 654
integer height = 360
integer taborder = 100
string dataobject = "d_nike_cc_dataentry_print"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_print from commandbutton within w_nike_cc_data_entry
boolean visible = false
integer x = 27
integer y = 1092
integer width = 215
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;string ls_cc_no          //   l_lob not used in Nike Shanghai 
string ls_s_loc, ls_e_loc, ls_where, ls_ord_status, ls_sql
Long ll_cnt, i, ll_row

dw_print.AcceptText()
if wf_save_changes() = 0 then
	return
end if

if dw_main.rowcount() <= 0 Then
	Messagebox(win_title, "No record!")
	Return
End If

dw_search.accepttext()
dw_print.reset()

ls_cc_no = dw_search.getitemstring(1,"cc_no")
ls_s_loc = dw_search.getitemstring(1,"s_loc")
ls_e_loc = dw_search.getitemstring(1,"e_loc")

If isnull(ls_cc_no) Then
	messagebox(win_title, "please enter CC No.!")
	Return
End If

if isnull(ls_s_loc) and isnull(ls_e_loc) then
	messagebox(win_title, "Please enter location!")
	Return
End If

//If ls_e_loc <= ls_s_loc Then
//	messagebox(win_title, "End location should be larger than start location!")
//	Return
//End If

// check pc_master
If dw_pc_master.Retrieve(ls_cc_no) <= 0 Then
	messagebox(win_title, "Not found this order!")
	Return
Else
	If dw_pc_master.GetItemString(1, "ord_status") = "C" Then
		messagebox(win_title, "This order is confirmed!")
		Return
	End if
end if

ll_cnt = dw_print.Retrieve(ls_cc_no, ls_s_loc, ls_e_loc)
If ll_cnt <= 0 Then
	messagebox(win_title, "No record found!")
	Return
end if

OpenWithParm(w_dw_print_options,dw_print)
end event

type cb_search from commandbutton within w_nike_cc_data_entry
integer x = 2171
integer y = 144
integer width = 320
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Search"
end type

event clicked;string ls_cc_no          //   l_lob not used in Nike Shanghai 
string ls_s_loc, ls_e_loc, ls_where, ls_ord_status, ls_sql
Long ll_cnt, i, ll_row

dw_main.AcceptText()
if wf_save_changes() = 0 then
	return
end if

dw_search.accepttext()
dw_main.reset()
SetNull(cc_no)

ls_cc_no = dw_search.getitemstring(1,"cc_no")
ls_s_loc = dw_search.getitemstring(1,"s_loc")
ls_e_loc = dw_search.getitemstring(1,"e_loc")

If isnull(ls_cc_no) Then
	messagebox(win_title, "please enter CC No.!")
	Return
End If

if isnull(ls_s_loc) and isnull(ls_e_loc) then
	messagebox(win_title, "Please enter location!")
	Return
End If

//If ls_e_loc <= ls_s_loc Then
//	messagebox(win_title, "End location should be larger than start location!")
//	Return
//End If

// check pc_master

If dw_pc_master.Retrieve(ls_cc_no) <= 0 Then
	messagebox(win_title, "Not found this order!")
	Return
Else
	If dw_pc_master.GetItemString(1, "ord_status") = "C" Then
		messagebox(win_title, "This order is confirmed!")
		Return
	End if
end if

ll_cnt = dw_main.Retrieve(ls_cc_no, ls_s_loc, ls_e_loc)
If ll_cnt <= 0 Then
	messagebox(win_title, "No record found!")
	Return
end if

cc_no = ls_cc_no

end event

type dw_search from datawindow within w_nike_cc_data_entry
integer x = 704
integer y = 44
integer width = 1339
integer height = 296
integer taborder = 10
string dataobject = "d_nike_pc_loc_search"
boolean border = false
boolean livescroll = true
end type

type dw_main from datawindow within w_nike_cc_data_entry
event ue_pressenter pbm_dwnprocessenter
integer y = 376
integer width = 3529
integer height = 1380
integer taborder = 40
string dataobject = "d_nike_cc_dataentry"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;IF This.GetColumnName() = "quantity" THEN
	IF This.GetRow() = This.RowCount() THEN
		cb_insert.TriggerEvent(Clicked!)
	END IF
ELSE
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If
end event

event itemchanged;integer li_idx

record_changed = true

if row = 1 and dwo.Name = "count_level" then

	if this.RowCount() > 1 then
		for li_idx = 2 to this.RowCount()

			this.SetItem( li_idx, "count_level",  integer(data))
	
		next
	end if
end if
end event

type cb_clear from commandbutton within w_nike_cc_data_entry
integer x = 2560
integer y = 144
integer width = 320
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;dw_main.AcceptText()
if wf_save_changes() = 0 then
	return
end if

dw_search.reset()
dw_search.insertrow(0)
dw_main.reset()
end event

type dw_pc_master from datawindow within w_nike_cc_data_entry
boolean visible = false
integer x = 110
integer y = 748
integer width = 494
integer height = 360
integer taborder = 70
string dataobject = "d_nike_cc_main"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_delete from commandbutton within w_nike_cc_data_entry
integer x = 9
integer y = 676
integer width = 215
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Delete"
end type

event clicked;dw_main.deleterow(0)

end event

type cb_insert from commandbutton within w_nike_cc_data_entry
integer x = 9
integer y = 492
integer width = 215
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Insert"
end type

event clicked;long ll_row
string ls_sku, ls_serial, ls_ref, ls_grp, ls_loc,lsCategory,lsCoo
DateTime ldreceipt

If IsNull(cc_no) or len(trim(cc_no)) = 0 Then
	Messagebox(win_title, "No CC No.!")
	Return
End If

ll_row = dw_main.getrow()

if ll_row > 0 then
	ls_loc = dw_main.getitemstring(ll_row,"l_code")
	ls_sku = dw_main.GetItemString(ll_row,"sku")
	lsCategory = dw_main.GetITemString(ll_row,"stock_category")
	lsCoo = dw_main.GetItemString(ll_row,"coo")
	ldreceipt = dw_main.GetItemDateTime(ll_row,"receipt_date")
end if

if ll_row = dw_main.rowcount() or ll_row < 1 then
	ll_row = 0
else
	ll_row ++
end if

ll_row = dw_main.insertrow(ll_row)
dw_main.scrolltorow(ll_row)
dw_main.setitem(ll_row,"cc_no",cc_no)
dw_main.setitem(ll_row,"l_code",ls_loc)
dw_main.setitem(ll_row,"sku",ls_sku)
dw_main.setitem(ll_row,"stock_category",lscategory)
dw_main.setitem(ll_row,"coo",lscoo)
dw_main.setitem(ll_row,"receipt_date",ldreceipt)
dw_main.setfocus()
dw_main.setcolumn("l_code")


end event

