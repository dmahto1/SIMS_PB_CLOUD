HA$PBExportHeader$w_petha_inbound_reconcillation_report.srw
$PBExportComments$+NYCSP Transaction Report by Date
forward
global type w_petha_inbound_reconcillation_report from w_std_report
end type
end forward

global type w_petha_inbound_reconcillation_report from w_std_report
integer width = 3639
integer height = 2076
string title = "Inbound Order Report"
end type
global w_petha_inbound_reconcillation_report w_petha_inbound_reconcillation_report

type variables
string is_origsql
string is_origsql2
long il_long
boolean  ib_first_time
string       is_warehouse_code
string       is_warehouse_name
datastore ids_find_warehouse
datastore ids_find_order_type
boolean ib_arrival_from_first
boolean ib_arrival_to_first
end variables

forward prototypes
public subroutine setdropdowns ()
end prototypes

public subroutine setdropdowns ();DatawindowChild	ldwc_warehouse
DatawindowChild	ldwc_order_type
DatawindowChild	ldwc_status
String	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(Sqlca)
ldwc_warehouse.Retrieve(gs_project)

dw_select.GetChild('order_type', ldwc_order_type)
ldwc_order_type.SetTransObject(Sqlca)
if ldwc_order_type.Retrieve(gs_project) = 0 then ldwc_order_type.Retrieve( 'DEMO')

end subroutine

on w_petha_inbound_reconcillation_report.create
call super::create
end on

on w_petha_inbound_reconcillation_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datawindowchild   ldwc_final
integer  li_return

// 05/09 - PCONKL - custom DW for Philips, 12/12 - added TPV, 6/13 added FUNAI, 01/26/2015 TAM Added Gibson
//3-FEB-2019 :Madhu S28945 Added PHILIPSCLS
If gs_project = 'PHILIPS-SG' or gs_project='PHILIPSCLS' or gs_project = 'TPV'  or gs_project = 'FUNAI'  or  gs_project = 'GIBSON' Then
	dw_report.dataobject = 'd_philips_inbound_order_rpt'
	dw_report.SetTransObject(SQLCA)
End If

// Jxlim 07/22/2010 - custom DW for 'SG-MUSER'
If gs_project = 'SG-MUSER' Then
	dw_report.dataobject = 'd_inbound_order_rpt_sg_muser'
	dw_report.SetTransObject(SQLCA)
End If

is_OrigSql = dw_report.getsqlselect()


end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-400)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_postopen;call super::ue_postopen;setDropdowns()



end event

event ue_retrieve;String ls_sku
String ls_Where
String ls_NewSql
string ls_warehouse
string ls_bol_no
string ls_selection
string ls_order_type
string ls_arrival_from_date
string ls_arrival_to_date
string ls_status
string ls_value
string ls_warehouse_name
string ls_order_type_desc

boolean lb_selection
boolean lb_arrival_from
boolean lb_arrival_to

datawindowchild ldwc_status
datawindowchild ldwc_order_type

date	ld_todate
date	ld_date
date ld_end_period

datetime ldt_end_date
datetime ldt_begin_date
datetime ldt_date_end
datetime ldt_date_begin

time	lt_add_time
time  lt_begin_time

integer li_req_qty
integer li_weight

Long ll_balance
Long i
long ll_cnt
long ll_cnt2
long ll_row
long ll_number
decimal ld_req_qty
long ll_find_row
long ll_weight

datastore ld_final


lt_add_time = 23:59:59
lt_begin_time = 00:00:01
ld_final = create datastore 
ld_final.dataobject = "d_inbound_test_total"
ld_final.Settransobject(SQLCA)

is_origsql2 = ld_final.Getsqlselect()

lb_selection = FALSE
lb_arrival_from = FALSE
lb_arrival_to   = FALSE
If dw_select.AcceptText() = -1 Then Return


SetPointer(HourGlass!)
dw_report.Reset()

dw_select.accepttext()

//Tack on Project ID 
ls_where += " And receive_master.project_id = '" + gs_project + "'"

//Process Warehouse Number
is_warehouse_code = dw_select.GetItemString(1,"warehouse")

IF ib_first_time  = TRUE THEN
  	
	ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_name + "'",&
																1,ids_find_warehouse.RowCount())
	IF ll_find_row > 0 THEN
		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
		dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
		ls_where += " and receive_master.wh_code = '" + is_warehouse_code + "'"
		
	ELSE
		ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())	
		IF ll_find_row > 0 THEN
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
			ls_where += " and receive_master.wh_code = '" + is_warehouse_code + "'"
		
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
		ls_where += " and receive_master.wh_code = '" + is_warehouse_code + "'"
		
	ELSE
		ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
			ls_where += " and receive_master.wh_code = '" + is_warehouse_code + "'"
		
							
		END IF
	END IF

END IF


//Tackon BOL Nbr
IF NOT isnull(dw_select.GetItemString(1,"bol_no")) AND dw_select.GetItemString(1,"bol_no") <> '' then
	ls_where += " and receive_master.supp_invoice_No = '" + dw_select.GetItemString(1,"bol_no") + "'"
	dw_report.Object.t_bol_number.text = dw_select.GetItemString(1,"bol_no") 
	
END IF

//Tackon Order Type
ls_value = dw_select.GetItemString(1,"order_type")

If not isnull(ls_Value) AND ls_value <> '' Then
	ll_find_row = ids_find_order_type.Find ("ord_type = '" + ls_value + "'",&
																1,ids_find_order_type.RowCount())

	IF ll_find_row > 0 THEN
		ls_order_type_desc = ids_find_order_type.GetItemString(ll_find_row,"ord_type_desc")
		ls_where += " and receive_master.ord_type = '" + ls_value + "'"
		dw_report.Object.t_order_type.text = ls_order_type_desc 
	END IF
	
End If

//Tackon status
ls_value = dw_select.object.status[ 1 ]
IF NOT isnull( ls_value ) AND ls_value <> '' then
	ls_where += " and receive_master.ord_status = '" + dw_select.GetItemString(1,"status") + "'"
	dw_report.Object.t_status.text = ls_value 
END IF

//Tackon Arrival Date From
ldt_date_begin = datetime(dw_select.GetItemDateTime(1,"arrival_date_from"))

IF ldt_date_begin > datetime('01/01/1900 00:00') THEN
	lb_arrival_from = TRUE
	ls_Where += " and receive_Master.arrival_Date >= '" + &
					string(dw_select.GetItemDateTime(1,"arrival_date_from"),'mm/dd/yyyy hh:mm' ) + "'"
	ls_arrival_from_date = string(dw_select.GetItemDateTime(1,"arrival_date_from"),'mm/dd/yyyy hh:mm ') 
		
END IF

//Tackon Arrival Date to
ldt_date_end = datetime(dw_select.GetItemDateTime(1,"arrival_date_to"))

IF ldt_date_end > datetime('01/01/1900 00:00')  THEN
	
	lb_arrival_to = TRUE
	ls_Where = ls_where + " and receive_Master.arrival_Date <= '" + &
					string(ldt_date_end,"mm/dd/yyyy hh:mm") + "'"
	
	dw_report.Object.t_arrival_date.text = ls_arrival_from_date + " - " + &
		string(ldt_date_end,"mm/dd/yyyy hh:mm ")
				
END IF

//Tackon Order Date From
ldt_date_begin = datetime(dw_select.GetItemDateTime(1,"Order_date_from"))

IF ldt_date_begin > datetime('01/01/1900 00:00') THEN
	
	ls_Where += " and receive_Master.Ord_Date >= '" + &
					string(ldt_date_begin,'mm/dd/yyyy hh:mm' ) + "'"
			
END IF

//Tackon Order Date to
ldt_date_end = datetime(dw_select.GetItemDateTime(1,"order_date_to"))

IF ldt_date_end > datetime('01/01/1900 00:00')  THEN
	
	ls_Where = ls_where + " and receive_Master.Ord_Date <= '" + &
					string(ldt_date_end,"mm/dd/yyyy hh:mm") + "'"
					
END IF

//Tackon Complete Date From
ldt_date_begin = datetime(dw_select.GetItemDateTime(1,"Complete_date_from"))

IF ldt_date_begin > datetime('01/01/1900 00:00') THEN
	
	ls_Where += " and receive_Master.Complete_Date >= '" + &
					string(ldt_date_begin,'mm/dd/yyyy hh:mm' ) + "'"
			
END IF

//Tackon Complete Date to
ldt_date_end = datetime(dw_select.GetItemDateTime(1,"Complete_date_to"))

IF ldt_date_end > datetime('01/01/1900 00:00')  THEN
	
	ls_Where = ls_where + " and receive_Master.Complete_Date <= '" + &
					string(ldt_date_end,"mm/dd/yyyy hh:mm") + "'"
					
END IF

//Tackon Supplier Code
ls_value = dw_select.object.supp_code[ 1 ]
IF NOT isnull( ls_value ) AND ls_value <> '' then
	ls_where += " and receive_master.supp_Code = '" + ls_value + "'"
END IF

//Prepare the main report
ls_NewSql = is_OrigSql + ls_Where 
dw_report.setsqlselect(ls_Newsql)
	
//Prepare the final total datastore
//ls_newsql = is_origsql2 + ls_where
//ld_final.setsqlselect(ls_newsql)
//
	
IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
	
	MessageBox("ERROR", "Please select a warehouse",stopsign!)
	
ELSE
	
	IF ((lb_arrival_to = TRUE and lb_arrival_from = FALSE) 	OR &
		 (lb_arrival_from = TRUE and lb_arrival_to = FALSE)  	OR &
		 (lb_arrival_from = FALSE and lb_arrival_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Arrival Date Range", Stopsign!)
	ELSE
		IF lb_arrival_to = FALSE and lb_arrival_from = FALSE THEN
			dw_report.Object.t_arrival_date.text = "NONE"
		END IF
		ll_cnt = dw_report.Retrieve()
		dw_report.GroupCalc()
		
		//12/07 - pconkl - rEMOVED NESTED REPORT - NO NEED TO RETREIVE HERE.
	//	ll_cnt2 = ld_final.retrieve(gs_project,is_warehouse_code)


//		IF ll_cnt2 > 0 THEN
//			ld_req_qty = ld_final.getitemdecimal(ll_cnt2,"cf_qty")
//			ll_weight = ld_final.getitemdecimal(ll_cnt2,"cf_weight")
//			dw_report.Object.final_qty.text = string(ld_req_qty,"#######.#####")
//			dw_report.Object.final_weight.text = string(ll_weight,"#,###,###")
//	
//		END IF

		IF ll_cnt > 0 Then
			im_menu.m_file.m_print.Enabled = True
			dw_report.Setfocus()
		Else
			im_menu.m_file.m_print.Enabled = False	
			MessageBox(is_title, "No records found!")
			dw_select.Setfocus()
		End If
		
	END IF
	
	is_warehouse_code = " "
	
END IF



end event

event ue_file;String	lsOption
Str_parms	lstrparms

//Triggered from menu

lsoption = Message.StringParm
Choose Case lsoption
		
	Case "PRINTPREVIEW" /*print preview window*/
		
		lstrparms.Datawindow_arg[1] = dw_report
		OpenwithParm(w_preview,lstrparms)
		
	Case "SAVEAS" /*Export*/
		
		dw_report.Saveas()
		
End Choose
end event

type dw_select from w_std_report`dw_select within w_petha_inbound_reconcillation_report
integer x = 0
integer width = 3575
integer height = 316
string dataobject = "d_inbound_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::itemchanged;string 				ls_column_name
string				ls_warehouse
string				ls_value

long					ll_row

This.Accepttext()

ls_column_name = DWO.name
ls_value = data


//CHOOSE CASE This.GetColumnName()
//	CASE 'warehouse'
//		ls_warehouse = data
//		//dw_report.setitem(1,"selection",data)
//		dw_report.Object.selection.text = data
//END CHOOSE
//
end event

event dw_select::constructor;//DataWindowChild  ldwc_warehouse
datawindowchild   ldwc_order_type
datastore 			lds_order_type

//DateTime ldt_date_end
//DateTime ldt_end_date

string   ls_string
string	ls_warehouse_name
string   ls_value

//date		ld_end_period
//
//time		lt_add_time

long	ll_row
long  ll_cur_row
long  ll_find_row


ll_row = dw_select.insertrow(0)
ib_arrival_from_first 	= TRUE
ib_arrival_to_first 		= TRUE

//dw_select.SetItem(ll_row,"arrival_date_from", today())
//dw_select.SetItem(ll_row,"arrival_date_to", today())


//Create the locating order type datastore
ids_find_order_type = CREATE Datastore 
ids_find_order_type.dataobject = 'd_find_order_type'
ids_find_order_type.SetTransObject(SQLCA)
ids_find_order_type.Retrieve()

//Create the locating warehouse name datastore
ids_find_warehouse = CREATE Datastore 
ids_find_warehouse.dataobject = 'd_find_warehouse'
ids_find_warehouse.SetTransObject(SQLCA)
ids_find_warehouse.Retrieve()

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


dw_select.setItem(ll_row,"order_type","S")
dw_select.setitem(ll_row,"status","N")

end event

event dw_select::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
	case 'cbx_reset'
		this.reset()
		this.insertrow(0)
		setDropDowns()
		
	CASE "arrival_date_from"
		
		IF ib_arrival_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("arrival_date_from")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_arrival_from_first = FALSE
			
		END IF
		
	CASE "arrival_date_to"
		
		IF ib_arrival_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("arrival_date_to")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_arrival_to_first = FALSE
			
		END IF
		
	CASE ELSE
		
END CHOOSE

end event

type cb_clear from w_std_report`cb_clear within w_petha_inbound_reconcillation_report
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_petha_inbound_reconcillation_report
integer x = 0
integer y = 332
integer width = 3419
integer height = 1544
integer taborder = 30
string dataobject = "d_petha_inbound_recon_order_rpt"
boolean hscrollbar = true
end type

