HA$PBExportHeader$w_delivery_by_sku_rpt_chinese.srw
$PBExportComments$Delivery by SKU Report
forward
global type w_delivery_by_sku_rpt_chinese from w_std_report
end type
end forward

global type w_delivery_by_sku_rpt_chinese from w_std_report
integer width = 3648
integer height = 2112
string title = "Delivery by SKU Report"
end type
global w_delivery_by_sku_rpt_chinese w_delivery_by_sku_rpt_chinese

type variables
string is_origsql

end variables

on w_delivery_by_sku_rpt_chinese.create
call super::create
end on

on w_delivery_by_sku_rpt_chinese.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-175)
end event

event open;call super::open;is_OrigSql = dw_report.getsqlselect()


end event

event ue_postopen;call super::ue_postopen;string ls_filter
DatawindowChild	ldwc_warehouse, ldwc


//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(Sqlca)
ldwc_warehouse.Retrieve(gs_project)

dw_select.GetChild('order_Type', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_Project)



end event

event ue_retrieve;String	lsWhere,	&
			lsNewSQL,	&
			lsReportHeader
Long		llRowCount

dw_select.AcceptText()

//always tackon Project
lsWhere += " and Delivery_Master.project_id = '" + gs_project + "'"

//Tackon Warehouse
if  not isnull(dw_select.GetItemString(1,"warehouse")) then
	lswhere += " and Delivery_Master.wh_code = '" + dw_select.GetItemString(1,"warehouse") + "'"
end if

//Tackon From Complete Date
If date(dw_select.GetItemDateTime(1,"from_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and Delivery_Master.complete_Date >= '" + string(dw_select.GetItemDateTime(1,"from_date"),'mm-dd-yyyy hh:mm') + "'"
End If

//Tackon To Complete Date
If date(dw_select.GetItemDateTime(1,"to_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and Delivery_Master.Complete_Date <= '" + string(dw_select.GetItemDateTime(1,"to_date"),'mm-dd-yyyy hh:mm') + "'"
End If

//Tackon Order Type <> Packaging for Satillo/Detroit - GAP 9/02
if  Upper(Left(gs_project,4)) = 'GM_M'  then
	lswhere += " and Delivery_Master.ord_type <> '" + "P" + "'"
end if

//Add Order Type if PResent
If dw_Select.GetItemString(1,'order_Type') > ' ' Then
	lsWhere += " and Delivery_Master.ord_Type = '" + dw_Select.GetItemString(1,'order_Type') + "'"
End If


//Where clause has to be appended before group by or having
LSwhere = lsWhere + ' '

// Set Warehouse in Report Header
if  not isnull(dw_select.GetItemString(1,"warehouse")) then
	dw_report.Modify("st_warehouse.Text='" + dw_select.GetItemString(1,"warehouse") + "'")
Else
	dw_report.Modify("st_warehouse.Text='*All'")
End If

//Set Dates in report header
If date(dw_select.GetItemDateTime(1,"from_date")) > date('01-01-1900') Then
	//Jxlim 08/11/2010 Modified for Chinese report
	//lsReportHeader += "Beginning Date: " + string(dw_select.GetItemDateTime(1,"from_date"),'mm/dd/yyyy')
	lsReportHeader += "$$HEX4$$005fcb59f665f495$$ENDHEX$$: " + string(dw_select.GetItemDateTime(1,"from_date"),'mm/dd/yyyy')

End If

If date(dw_select.GetItemDateTime(1,"To_date")) > date('01-01-1900') Then
	//Jxlim 08/11/2010 Modified for Chinese report
	//lsReportHeader += "  Ending Date: " + string(dw_select.GetItemDateTime(1,"To_date"),'mm/dd/yyyy')
	lsReportHeader += " $$HEX4$$d37e5f67f665f495$$ENDHEX$$: " + string(dw_select.GetItemDateTime(1,"To_date"),'mm/dd/yyyy')
End If

dw_report.Modify("st_dates.Text='" + lsReportHeader + "'")

lsNewSQL = Replace(is_OrigSql, (Pos(is_OrigSQL,'Group By') - 1),1,lsWhere)

//Messagebox("??",lsNewSQL)

dw_report.SetSqlSelect(lsNewSql)

llRowCount = dw_report.Retrieve()

If llRowCount > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If
end event

event ue_clear;
dw_select.Reset()
dw_report.Reset()
dw_select.InsertRow(0)
end event

type dw_select from w_std_report`dw_select within w_delivery_by_sku_rpt_chinese
integer y = 20
integer width = 3424
integer height = 168
string dataobject = "d_delivery_by_sku_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::clicked;DateTime	ldtDate

//CHOOSE CASE dwo.name
//		
//	CASE "from_date"
//		
//		ldtdate = f_get_date("BEGIN")
//		dw_select.SetColumn("order_from_date")
//		dw_select.SetText(string(ldtdate, "mm/dd/yyyy hh:mm"))
//					
//	CASE "to_date"
//			
//		ldtdate = f_get_date("END")
//		dw_select.SetColumn("order_to_date")
//		dw_select.SetText(string(ldtdate, "mm/dd/yyyy hh:mm"))
//							
//End Choose
end event

type cb_clear from w_std_report`cb_clear within w_delivery_by_sku_rpt_chinese
end type

type dw_report from w_std_report`dw_report within w_delivery_by_sku_rpt_chinese
integer x = 14
integer y = 200
integer width = 3566
integer height = 1708
string dataobject = "d_delivery_by_sku_rpt_chinese"
boolean hscrollbar = true
end type

