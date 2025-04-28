$PBExportHeader$w_short_ship_trend_report.srw
$PBExportComments$Short Ship Trend Report
forward
global type w_short_ship_trend_report from w_std_report
end type
end forward

global type w_short_ship_trend_report from w_std_report
integer width = 3831
string title = "Short Ship Trend Report"
end type
global w_short_ship_trend_report w_short_ship_trend_report

type variables

String	is_OrigSql
end variables

on w_short_ship_trend_report.create
call super::create
end on

on w_short_ship_trend_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;String 	lsSelect,lsAddTables,lsWHere, lsNewSQL
Datetime	ldFromSelected, ldToSelected
Boolean lb_order_from, lb_order_to
Boolean lb_where
Int li_result

im_menu.m_file.m_print.Enabled = False

//Initialize Date Flags
lb_order_from 		= FALSE
lb_order_to 			= FAlSE
lb_where 			= FALSE

dw_select.AcceptText()

//Show from and to dates selected - Short Ship Authorized
ldFromSelected = dw_select.GetItemDateTime(1,"s_date")
ldToSelected= dw_select.GetItemDateTime(1,"e_date")

dw_report.object.t_sdate.text =string(ldFromSelected,'mm-dd-yyyy hh:mm')
dw_report.object.t_edate.text =string(ldToSelected,'mm-dd-yyyy hh:mm')
dw_report.object.t_to_label.visible = true
dw_report.object.t_from_label.visible = true

//Build SQL statement
lsSelect = "select dm.Invoice_No OrderNumber, dd.Req_Qty ExpectedQuantity,o.Owner_Cd Requestor,dm.ord_status Status,dm.complete_date CompleteDate,"
lsSelect = lsSelect + "dd.Line_Item_No PandoraLineNumber,dd.sku GPN,dd.Alloc_Qty ShipppedQuantity,bd.Req_Qty BackorderQuantity,"
lsSelect = lsSelect + "ISNULL(DATEDIFF(dd,bo.Ord_Date,GETDATE()),0) OrderAgeInDays,GETDATE() Now,bo.Ord_Date BODate,"
lsSelect = lsSelect + "	dm.Ship_Cnt DOShipCnt, auth.DO_No,auth.UserId SupervisorApproved,Authorize_Date ApprovedDate,"
lsSelect = lsSelect + "bo.do_no as BOOrderNo, bo.Ship_Cnt BOShipCnt,bo.ord_type BOOrdType,bo.Ord_Status as BackorderStatus "

//Build additional tables
lsAddTables = "from Authorized_Signer auth"
lsAddTables = lsAddTables + " LEFT OUTER JOIN delivery_master dm  ON dm.DO_No = auth.DO_No and dm.Project_Id = '" + gs_project + "'"
lsAddTables = lsAddTables + ' LEFT OUTER JOIN delivery_detail dd ON dd.DO_No = auth.DO_No and dd.Req_Qty > dd.Alloc_Qty'
lsAddTables = lsAddTables + ' LEFT OUTER JOIN Owner o	ON o.Owner_Id = dd.Owner_Id'
lsAddTables = lsAddTables + " LEFT OUTER JOIN delivery_master bo ON bo.project_id = '" + gs_project + "'"
lsAddTables = lsAddTables + ' and bo.Invoice_No = dm.Invoice_No and bo.ship_cnt = ISNULL(dm.ship_cnt,1) + 1'
lsAddTables = lsAddTables + ' LEFT OUTER JOIN delivery_detail bd ON bd.DO_No = bo.DO_No and bd.Line_Item_No = dd.Line_Item_No'

lsWHere = " where auth.authorize_type = 'SS'"

//Tackon From Report Date
If date(ldFromSelected) > date('01-01-1900') Then
		lsWhere = lsWhere + " and  auth.authorize_date >= '" + string(ldFromSelected) + "'"
		//lsOrigSQL = lsOrigSQL +  " and  auth.authorize_date >= '" + string(ldFromSelected) + "'"
		lb_order_from = TRUE
		lb_where = TRUE
Else
		MessageBox("Selection Error","This report requires a From and To selection.  Please re-enter.")
		return
End If

//Tackon To Report Date - bump by 1 and check for less than to account for time
If Date(ldToSelected) > date('01-01-1900') Then
		lsWhere = lsWhere + " and  auth.authorize_date <= '" + string(ldToSelected,'mm-dd-yyyy hh:mm') + "'"
		//lsOrigSQL = lsOrigSQL + " and  auth.authorize_date <= '" + string(ldToSelected,'mm-dd-yyyy hh:mm') + "'"
		lb_order_to = TRUE
		lb_where = TRUE
Else
		MessageBox("Selection Error","This report requires a From and To selection.  Please re-enter.")
		return
End If

lsNewSql = lsSelect + lsAddTables + lsWhere 

dw_report.SetRedraw(False)
dw_report.setsqlselect(lsNewsql)
dw_report.retrieve(gs_project)

li_result = dw_report.SetSort("approveddate A")
dw_report.Sort()

If dw_report.RowCount() <=0 Then
	MessageBox('Short Ship Trend Report','No Records Found!')
	im_menu.m_file.m_print.Enabled = False
Else
	im_menu.m_file.m_print.Enabled = True
End If

dw_report.SetRedraw(True)


im_menu.m_file.m_print.Enabled = TRUE

end event

event resize;call super::resize;dw_report.Resize(workspacewidth() - 60,workspaceHeight()-250)
end event

event ue_postopen;call super::ue_postopen;
is_OrigSql = dw_report.getsqlselect()

end event

type dw_select from w_std_report`dw_select within w_short_ship_trend_report
integer height = 196
string dataobject = "d_short_ship_trend_select"
end type

type cb_clear from w_std_report`cb_clear within w_short_ship_trend_report
end type

type dw_report from w_std_report`dw_report within w_short_ship_trend_report
integer y = 244
integer width = 3739
integer height = 1360
string dataobject = "d_short_ship_trend_report"
end type

event ue_retrieve;String ls_sku


end event

