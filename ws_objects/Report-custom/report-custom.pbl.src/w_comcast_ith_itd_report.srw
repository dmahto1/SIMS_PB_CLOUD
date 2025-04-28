$PBExportHeader$w_comcast_ith_itd_report.srw
$PBExportComments$BCR: Window for viewing ITH/ITD results
forward
global type w_comcast_ith_itd_report from w_std_report
end type
end forward

global type w_comcast_ith_itd_report from w_std_report
integer width = 4315
integer height = 2260
string title = "Comcast ITH/ITD Report"
end type
global w_comcast_ith_itd_report w_comcast_ith_itd_report

type variables
string is_origsql


end variables

on w_comcast_ith_itd_report.create
call super::create
end on

on w_comcast_ith_itd_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;is_OrigSql = dw_report.getsqlselect()
end event

event ue_postopen;call super::ue_postopen;DataWindowChild ldwc_warehouse,ldwc_warehouse2

dw_select.InsertRow(0)


dw_select.GetChild("wh_code", ldwc_warehouse)

ldwc_warehouse.SetTransObject(sqlca)

//Loading from USer Warehouse Datastore
g.of_set_warehouse_dropdown(ldwc_warehouse)


end event

event ue_retrieve;call super::ue_retrieve;//BCR 01-APR-2011 Comcast ITH/ITD Report
Boolean lb_where
String ls_Where, ls_NewSql, ls_string

Long	llRowCount,	&
		llRowPos	
		
//Initialize		
lb_where = False

dw_select.accepttext()

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

dw_report.SetRedraw(False)

//If present, tackon the following...

//Tran nbr
ls_string = dw_select.GetItemString(1,"Tran_nbr")
If not isNull(ls_string) then
	ls_where += " and UPPER(ITH.Tran_nbr) = '" + ls_string + "' "
	lb_where = TRUE
End If

//Ref nbr
ls_string = dw_select.GetItemString(1,"Ref_nbr")
If not isNull(ls_string) then
	ls_where += " and UPPER(ITH.Ref_nbr) = '" + ls_string + "' "
	lb_where = TRUE
End If

//Warehouse Cd
ls_string = dw_select.GetItemString(1,"Wh_code")
If not isNull(ls_string) then
	ls_where += " and ITH.Wh_Code = '" + ls_string + "' "
	lb_where = TRUE
End If

//Bol Nbr
ls_string = dw_select.GetItemString(1,"Bol_Nbr")
If not isNull(ls_string) then
	ls_where += " and ITH.Bol_Nbr = '" + ls_string + "' "
	lb_where = TRUE
End If

//Pallet ID
ls_string = dw_select.GetItemString(1,"Pallet_Id")
If not isNull(ls_string) then
	ls_where += " and ITH.Pallet_Id = '" + ls_string + "' "
	lb_where = TRUE
End If

//From Site ID
ls_string = dw_select.GetItemString(1,"From_Site_Id")
If not isNull(ls_string) then
	ls_where += " and ITH.From_Site_Id = '" + ls_string + "' "
	lb_where = TRUE
End If

//Create Date From
If date(dw_select.GetItemDateTime(1, "Date_From")) > date('01-01-1900') Then
	ls_Where = ls_Where + " and ITH.Create_Date >= '" + string(dw_select.GetItemDateTime(1, "Date_From"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = TRUE
End If

//Create Date To
If date(dw_select.GetItemDateTime(1, "Date_To")) > date('01-01-1900') Then
	ls_Where = ls_Where + " and ITH.Create_Date <= '" + string(dw_select.GetItemDateTime(1, "Date_To"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = TRUE
End If

//Serial nbr
ls_string = dw_select.GetItemString(1,"Serial_nbr")
If not isNull(ls_string) then
	ls_where += " and ITD.Serial_no = '" + ls_string + "' "
	lb_where = TRUE
End If

//Modify SQL
If 	lb_where = True Then
	ls_NewSql = is_origsql + ls_Where 
	dw_report.setsqlselect(ls_Newsql)
Else
	ls_NewSql = is_origsql
	dw_report.setsqlselect(ls_Newsql)
End If

llRowCount = dw_report.Retrieve()
If llRowCount > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If

dw_report.SetRedraw(True)
SetPointer(Arrow!)
end event

event resize;call super::resize;dw_report.Resize(workspacewidth() - 75,workspaceHeight()-400)
end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

dw_report.Reset()

end event

type dw_select from w_std_report`dw_select within w_comcast_ith_itd_report
integer width = 4210
integer height = 292
string dataobject = "d_comcast_ith_itd_results_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_comcast_ith_itd_report
end type

type dw_report from w_std_report`dw_report within w_comcast_ith_itd_report
integer y = 352
integer width = 4219
integer height = 1652
string dataobject = "d_comcast_ith_itd_report"
boolean hscrollbar = true
end type

