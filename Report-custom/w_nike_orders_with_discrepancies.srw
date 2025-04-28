HA$PBExportHeader$w_nike_orders_with_discrepancies.srw
$PBExportComments$Stock Transfer Report
forward
global type w_nike_orders_with_discrepancies from w_std_report
end type
end forward

global type w_nike_orders_with_discrepancies from w_std_report
integer width = 3767
integer height = 1984
string title = "Nike Orders with Discrepancies"
end type
global w_nike_orders_with_discrepancies w_nike_orders_with_discrepancies

type variables
String	isOrigSQL
end variables

on w_nike_orders_with_discrepancies.create
call super::create
end on

on w_nike_orders_with_discrepancies.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;date ld_shipstrdt, ld_shipenddt
datetime ldtm_shipstrdt,ldtm_shipenddt

dw_select.AcceptText()

//Copied from EWMS

ld_shipstrdt 	= Date(dw_select.GetItemDateTime(1, "ship_frdt"))
ld_shipenddt 	= Date(dw_select.GetItemDateTime(1, "ship_todt"))

//SARUN VER101201
long ll,ll_11,ll_12,ll_21,ll_22,ll_1,ll_2

if isnull(ld_shipstrdt) or ld_shipstrdt < Date(2001,01,01) then 
	ll_21 = 0
else
	ll_21 = 1
end if
if isnull(ld_shipenddt) or ld_shipenddt < Date(2001,01,01) then 
	ll_22 = 0
else
	ll_22 = 1
end if

ll_1 = ll_11 + ll_12
ll_2 = ll_21 + ll_22
ll	  = ll_1  + ll_2	

if ll_1 = 0 and ll_2 = 0 then
	MessageBox(is_title, "Please enter Date")
	return
end if

if ll_1 = 1 or ll_2 = 1  then
	MessageBox(is_title, "Please enter Date")
	return
end if

if (ll = 3) then
	MessageBox(is_title, "Please enter Date")
	return
end if


if ll_2 = 2 and ld_shipstrdt > ld_shipenddt then
	MessageBox(is_title, "End Date should be greater than the start Date")
	//dw_query.setfocus(1)
	
	return
end if


if ll_21 = 0 or ll_22 = 0  then 
	select min(schedule_date),max(schedule_date) into :ldtm_shipstrdt,:ldtm_shipenddt from delivery_master;
	ld_shipstrdt = date(ldtm_shipstrdt)
	ld_shipenddt = date(ldtm_shipenddt)
end if


SetPointer(Arrow!)
If dw_report.Retrieve(gs_project, ld_shipstrdt,ld_shipenddt) > 0 Then
	im_menu.m_file.m_print.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If



end event

event resize;dw_report.Resize(workspacewidth() - 65,workspaceHeight()-425)
end event

event ue_clear;
dw_select.Reset()
dw_select.InsertRow(0)



end event

event ue_postopen;call super::ue_postopen;string	lsFilter
DatawindowChild	ldwc

If gs_project = 'WARNER' then 
	dw_report.dataobject = "d_warner_transfer_report"
	dw_report.SetTransObject(SQLCA)
End If

dw_select.GetChild('wh_code', ldwc)
ldwc.SetTransObject(sqlca)

If ldwc.Retrieve() > 0 Then
	//Filter Warehouse dropdown by Current Project
	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
	ldwc.SetFilter(lsFilter)
	ldwc.Filter()
End If

isOrigSQL = dw_report.GetSQlSelect() /*capture original SQL*/
end event

type dw_select from w_std_report`dw_select within w_nike_orders_with_discrepancies
integer x = 82
integer y = 24
integer width = 1577
integer height = 260
string dataobject = "d_nike_orders_with_discrepancies_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_nike_orders_with_discrepancies
integer x = 3269
integer y = 0
end type

type dw_report from w_std_report`dw_report within w_nike_orders_with_discrepancies
integer x = 5
integer y = 316
integer width = 3703
integer height = 1448
string dataobject = "d_nike_orders_with_discrepancies"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

