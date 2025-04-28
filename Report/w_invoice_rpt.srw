HA$PBExportHeader$w_invoice_rpt.srw
$PBExportComments$This window is used for reporting the invoice information
forward
global type w_invoice_rpt from w_std_report
end type
end forward

global type w_invoice_rpt from w_std_report
int Width=3607
int Height=2116
boolean TitleBar=true
string Title="GE Invoice Report"
end type
global w_invoice_rpt w_invoice_rpt

type variables
Datastore ids_find_warehouse
boolean ib_first_time
string is_warehouse_code
string is_warehouse_name
string is_origsql
end variables

on w_invoice_rpt.create
call super::create
end on

on w_invoice_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
is_OrigSql = dw_report.getsqlselect()
//messagebox("is origsql",is_origsql)


end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc_warehouse
string				lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

//dw_select.GetChild('warehouse', ldwc_warehouse)
//ldwc_warehouse.SetTransObject(Sqlca)
//ldwc_warehouse.Retrieve(gs_project)
//
dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
If ldwc_warehouse.Retrieve(gs_project) > 0 Then
	
	//Filter Warehouse dropdown by Current Project
	lsFilter = "project_id = '" + gs_project + "'"
	ldwc_warehouse.SetFilter(lsFilter)
	ldwc_warehouse.Filter()
	
	dw_select.SetItem(1, "warehouse" , ldwc_warehouse.GetItemString(1, "wh_code"))
	
End If


end event

event ue_retrieve;String ls_invoice_no
string ls_do_no
String ls_Where
String ls_NewSql
string ls_value
string ls_warehouse_code
string ls_warehouse_name


Long ll_balance
Long i
long ll_cnt
long ll_find_row
long ll_number_of_digits
long ll_number

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

//Tack on project id & Invoice no

IF NOT isnull(dw_select.GetItemString(1,"invoice_no")) THEN
	ls_invoice_no = dw_select.GetItemString(1,"invoice_no")

	//Make sure can still find number if leading zeros are missing
	ll_number = long(ls_invoice_no)
	ll_number_of_digits = len(string(ll_number))
	ls_invoice_no = fill('0',7 - ll_number_of_digits) + string(ll_number)
	//ls_invoice_no = fill('0', 8 - ll_number_of_digits) + string(ll_number)
	//messagebox("ls invoice no", ls_invoice_no)
	
//	//SELECT do_no into :ls_do_no_from 
//	//	FROM delivery_master
//	//		WHERE delivery_master.invoice_no = :ls_order_from using SQLCA;
END IF


//select do_no into :ls_do_no 
//	from delivery_master
//		where delivery_master.invoice_no = :ls_invoice_no using SQLCA;
		
//messagebox("invoice no", ls_invoice_no)		
	
//ls_where += " and cs.project_id = '" + gs_project + "'"
//if  (NOT isnull(dw_select.GetItemString(1,"sku")) AND (ls_value > ' ')) THEN
//	ls_where += " and cs.sku = '" + dw_select.GetItemString(1,"sku") + "'"
	
//end if

//Process Warehouse Number
IF ib_first_time  = TRUE THEN
  	is_warehouse_code = dw_select.GetItemString(1,"warehouse")
	  
	ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
	IF ll_find_row > 0 THEN
		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
		//ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
		//dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
	ELSE
		ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN													
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			//dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
			//ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
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
		//dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
		//ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
			
	else
		ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			//dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
			//ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
		END IF
	END IF
END IF



//ls_newsql = is_origsql + ls_where 

//If ls_Where > '  ' Then
//	ls_NewSql = is_select + ls_Where +"   " + is_groupby
//	dw_report.setsqlselect(ls_Newsql)
	
//Else
	
//	dw_report.setsqlselect(is_select + ls_where + "  " + is_groupby)
//End If
	
IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
	MessageBox("ERROR", "Please select a warehouse",stopsign!)
	
ELSE
	IF (ls_invoice_no = "") OR isnull(ls_invoice_no) THEN
		Messagebox("ERROR", "Please specify an Order NO", stopsign!)
	ELSE
		ll_cnt = dw_report.Retrieve(gs_project,is_warehouse_code, ls_invoice_no)
		
		If ll_cnt > 0 Then
			im_menu.m_file.m_print.Enabled = True
			dw_report.Setfocus()
		Else
			im_menu.m_file.m_print.Enabled = False	
			MessageBox(is_title, "No records found!")
			dw_select.Setfocus()
		END IF
		
	END IF
	
END IF

is_warehouse_code = " "



end event

type dw_select from w_std_report`dw_select within w_invoice_rpt
int Y=28
int Width=2688
int Height=80
string DataObject="d_invoice_search"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

event dw_select::constructor;long		ll_row
long		ll_find_row

string 	ls_value
string	ls_warehouse_name


//Create the locating warehouse name datastore
ids_find_warehouse = CREATE Datastore 
ids_find_warehouse.dataobject = 'd_find_warehouse'
ids_find_warehouse.SetTransObject(SQLCA)
ids_find_warehouse.Retrieve()

//ll_row = This.insertrow(0)
ib_first_time = true


//dw_select.SetItem(ll_row,"warehouse",gs_default_wh)
//ls_value = dw_select.GetItemString(1,"warehouse")
//
//ll_find_row = ids_find_warehouse.Find ("wh_code = '" + ls_value + "'",&
//																1,ids_find_warehouse.RowCount())
//IF ll_find_row > 0 THEN
//	is_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
//	is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
//	dw_select.SetItem(1,"warehouse",is_warehouse_name)
//	
//END IF


end event

type dw_report from w_std_report`dw_report within w_invoice_rpt
int Y=132
int Width=3520
int Height=1792
string DataObject="d_invoice"
boolean HScrollBar=true
end type

