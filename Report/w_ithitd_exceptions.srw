HA$PBExportHeader$w_ithitd_exceptions.srw
$PBExportComments$This is the Inbound Order report
forward
global type w_ithitd_exceptions from w_std_report
end type
end forward

global type w_ithitd_exceptions from w_std_report
integer width = 3639
integer height = 2076
string title = "Inbound Order Report"
end type
global w_ithitd_exceptions w_ithitd_exceptions

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

on w_ithitd_exceptions.create
call super::create
end on

on w_ithitd_exceptions.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datawindowchild   ldwc_final
integer  li_return

// 05/09 - PCONKL - custom DW for Philips
//3-FEB-2019 :Madhu S28945 Added PHILIPSCLS
If gs_project = 'PHILIPS-SG' or gs_project = 'PHILIPSCLS' Then
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

event ue_retrieve;String ls_where, ls_warehouse_name, ls_newsql
long ll_find_row, ll_cnt
Datetime ldt_date_begin, ldt_date_end

is_origsql2 = dw_report.Getsqlselect()

SetPointer(HourGlass!)
dw_report.Reset()
ls_where = ""
dw_select.accepttext()

//Process Warehouse Number
is_warehouse_code = dw_select.GetItemString(1,"warehouse")
ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_name + "'", 1, ids_find_warehouse.RowCount())
IF ll_find_row > 0 THEN
		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
		dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
		ls_where += " and Comcast_ITH.wh_code = '" + is_warehouse_code + "'"
		
ELSE
		ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'", 1, ids_find_warehouse.RowCount())	
		IF ll_find_row > 0 THEN
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
			ls_where += " and Comcast_ITH.wh_code = '" + is_warehouse_code + "'"
		END IF
END IF

//Tackon BOL Nbr
IF NOT isnull(dw_select.GetItemString(1,"bol_no")) AND dw_select.GetItemString(1,"bol_no") <> '' then
	ls_where += " and Comcast_ITH.BOL_Nbr = '" + dw_select.GetItemString(1,"bol_no") + "'"
	dw_report.Object.t_bol_number.text = dw_select.GetItemString(1,"bol_no") 
END IF

//Tackon Order Date From
ldt_date_begin = datetime(dw_select.GetItemDateTime(1,"Order_date_from"))

IF ldt_date_begin > datetime('01/01/1900 00:00') THEN
	
	ls_Where += " and Comcast_ITH.Create_Date >= '" + &
					string(ldt_date_begin,'mm/dd/yyyy hh:mm' ) + "'"
	dw_report.Object.t_arrival_date.Text = String(ldt_date_begin) + " - "
END IF

//Tackon Order Date to
ldt_date_end = datetime(dw_select.GetItemDateTime(1,"order_date_to"))

IF ldt_date_end > datetime('01/01/1900 00:00')  THEN
	
	ls_Where = ls_where + " and Comcast_ITH.Create_Date <= '" + &
					string(ldt_date_end,"mm/dd/yyyy hh:mm") + "'"
	dw_report.Object.t_arrival_date.Text = dw_report.Object.t_arrival_date.Text + String(ldt_date_end)					
END IF


//Prepare the main report
ls_NewSql = is_OrigSql + ls_Where + "group by Create_Date, WH_Code, Comcast_ITH.STATUS, Comcast_ITD.Status, Model_no, Serial_no, Pallet_Id, WH_Code, Comcast_ITH.Id_No,Comcast_ITH.Tran_Nbr,RO_No,Ref_Nbr,Ref_Cnt,Container_Temp_Id,BOL_Nbr,Carrier,Waybill_Nbr,From_Site_Id order by Create_Date desc"
dw_report.setsqlselect(ls_Newsql)
ll_cnt = dw_report.Retrieve()
		
IF ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If
		
is_warehouse_code = " "
	




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

type dw_select from w_std_report`dw_select within w_ithitd_exceptions
integer x = 0
integer width = 3575
integer height = 316
string dataobject = "d_ithitdex_rpt_search"
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
		
		
	CASE ELSE
		
END CHOOSE

end event

type cb_clear from w_std_report`cb_clear within w_ithitd_exceptions
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_ithitd_exceptions
integer x = 0
integer y = 332
integer width = 3419
integer height = 1544
integer taborder = 30
string dataobject = "d_ithitd_exceptions"
boolean hscrollbar = true
end type

