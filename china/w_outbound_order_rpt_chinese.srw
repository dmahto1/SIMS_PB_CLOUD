HA$PBExportHeader$w_outbound_order_rpt_chinese.srw
$PBExportComments$This is the Outbound Order report
forward
global type w_outbound_order_rpt_chinese from w_std_report
end type
end forward

global type w_outbound_order_rpt_chinese from w_std_report
integer width = 3648
integer height = 2112
string title = "Outbound Order Report"
end type
global w_outbound_order_rpt_chinese w_outbound_order_rpt_chinese

type variables
string is_origsql
string       is_warehouse_code
string  is_warehouse_name
datastore ids_find_warehouse
boolean ib_first_time
end variables

on w_outbound_order_rpt_chinese.create
call super::create
end on

on w_outbound_order_rpt_chinese.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-175)
end event

event ue_retrieve;
String ls_Where
String ls_warehouse
string ls_warehouse_name
String ls_NewSql
string ls_selection
string ls_value

long ll_row
long ll_cnt
long ll_find_row


If dw_select.AcceptText() = -1 Then Return


SetPointer(HourGlass!)
dw_report.Reset()



//Process Warehouse Number
IF ib_first_time  = TRUE THEN
  	is_warehouse_code = dw_select.GetItemString(1,"warehouse")
	  
	ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
	IF ll_find_row > 0 THEN
		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
		
		dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
	ELSE
		ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN													
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
			
		END IF
	END IF
	ib_first_time = false
  
ELSE
	is_warehouse_code = dw_select.GetItemString(1,"warehouse")
	ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
															
	IF ll_find_row > 0 THEN
		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
		dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
		
			
	else
		ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
			
		END IF
	END IF
END IF

IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
	MessageBox("ERROR", "Please select a warehouse",stopsign!)
ELSE


	ll_cnt = dw_report.Retrieve(gs_project,is_warehouse_code)
	IF ll_cnt > 0 Then
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
	Else
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
	End If
	is_warehouse_code = " "
END IF




end event

event open;call super::open;is_OrigSql = dw_report.getsqlselect()


end event

event ue_postopen;call super::ue_postopen;string ls_filter
DatawindowChild	ldwc_warehouse


//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(Sqlca)
ldwc_warehouse.Retrieve(gs_project)

//Filter Warehouse dropdown by Current Project
//ls_Filter = "project_id = '" + gs_project + "'"
//ldwc_warehouse.SetFilter(ls_Filter)
//ldwc_warehouse.Filter()

end event

type dw_select from w_std_report`dw_select within w_outbound_order_rpt_chinese
integer y = 16
integer width = 1728
integer height = 80
string dataobject = "d_outbound_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;long		ll_row
long		ll_find_row

string 	ls_value
string	ls_warehouse_name

g.of_check_label(this) 

//Create the locating warehouse name datastore
ids_find_warehouse = CREATE Datastore 
ids_find_warehouse.dataobject = 'd_find_warehouse'
ids_find_warehouse.SetTransObject(SQLCA)
ids_find_warehouse.Retrieve()

ll_row = dw_select.insertrow(0)

ib_first_time = true


dw_select.SetItem(ll_row,"warehouse",gs_default_wh)
ls_value = dw_select.GetItemString(ll_row,"warehouse")

ll_find_row = ids_find_warehouse.Find ("wh_code = '" + ls_value + "'",&
																1,ids_find_warehouse.RowCount())
IF ll_find_row > 0 THEN
	is_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
	is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
	dw_select.SetItem(ll_row,"warehouse",is_warehouse_name)
	
END IF
end event

type cb_clear from w_std_report`cb_clear within w_outbound_order_rpt_chinese
end type

type dw_report from w_std_report`dw_report within w_outbound_order_rpt_chinese
integer x = 14
integer y = 108
integer width = 3566
integer height = 1800
string dataobject = "d_outbound_order_rpt_chinese"
boolean hscrollbar = true
end type

event dw_report::constructor;

//This.SetTransObject(SQLCA)
//This.Retrieve(gs_project)

idw_current = This
end event

event dw_report::retrieveend;long ll_count
decimal ld_req_qty


//select count(*), sum(req_qty) into :ll_count, :ll_req_qty 
//from delivery_detail USING SQLCA;

  
//messagebox("count", ll_count)
//messagebox("req qty", ll_req_qty)


end event

