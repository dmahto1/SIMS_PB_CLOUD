$PBExportHeader$w_pandora_mim_demand_analysis.srw
$PBExportComments$Window used for processing Inventory by SKU information
forward
global type w_pandora_mim_demand_analysis from w_std_report
end type
end forward

global type w_pandora_mim_demand_analysis from w_std_report
integer width = 4649
integer height = 2120
string title = "MIM Demand Analysis Report"
end type
global w_pandora_mim_demand_analysis w_pandora_mim_demand_analysis

type variables
String	is_OrigSql
string       is_select
string       is_groupby
string       is_warehouse_code
string       is_warehouse_name
datastore ids_find_warehouse
boolean ib_first_time

Datawindowchild idwc_warehouse
end variables

on w_pandora_mim_demand_analysis.create
call super::create
end on

on w_pandora_mim_demand_analysis.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;//Integer  li_pos,ll_len
//
//
//is_OrigSql = trim(dw_report.getsqlselect())
////messagebox("is origsql",is_origsql)
//li_pos = pos(is_origsql,"Group by",1)
////is_groupby = mid(is_origsql,794)
//is_groupby = mid(is_origsql,li_pos)
//ll_len= pos(is_groupby,';',1) 
//is_groupby = mid(is_groupby,1,(ll_len - 1))
////Messagebox("",is_groupby)
//IF li_pos > 0 THEN li_pos=li_pos - 1
////is_select = mid(is_origsql,1,793)
//is_select = mid(is_origsql,1,li_pos)
//is_OrigSql = dw_report.getsqlselect()
//

end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-175)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_retrieve;String ls_sku
String ls_Where
String ls_NewSql
string ls_value
string ls_warehouse_code
string ls_warehouse_name


Long ll_balance
Long i
long ll_cnt
long ll_find_row

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

ls_warehouse_code = dw_select.GetItemString(1,"warehouse")

Sqlca.sp_pandora_mim_demand( ls_warehouse_code )


ll_cnt = dw_report.Retrieve()
		
If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If

is_warehouse_code = " "



end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc_warehouse, ldwc
string	lsValues

Select User_Field1 INTO :lsValues FROM Project_Reports_Parm with (NoLock) 
Where Project_ID = :gs_project AND Report_Id = 'PANMIM' and User_Field0 = 'DropDown'  USING SQLCA;

dw_select.object.warehouse.ddlb.limit="0"
dw_select.object.warehouse.ddlb.allowedit="no" 
dw_select.object.warehouse.ddlb.case="any" 
dw_select.object.warehouse.ddlb.nilisnull="yes" 
dw_select.object.warehouse.ddlb.useasborder="yes"
dw_select.object.warehouse.ddlb.imemode="0"

dw_select.Object.warehouse.Values = lsValues
//dw_select.Object.warehouse.Values = "Atlanta~tAT/Singapore~tSG/"		
dw_select.GetChild ( "warehouse", idwc_warehouse )
idwc_warehouse.SetTransObject(Sqlca)

dw_select.object.inv_type.visible=false
dw_select.object.inv_type_t.visible=false


end event

event ue_print;dw_report.Object.DataWindow.Print.Orientation=1
OpenWithParm(w_dw_print_options,dw_report) 
 
end event

type dw_select from w_std_report`dw_select within w_pandora_mim_demand_analysis
integer x = 0
integer width = 3227
integer height = 116
string dataobject = "d_inventory_type_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::itemchanged;call super::itemchanged;String ls_warehouse_code, lsName
//TimA 04/18/14

String lsLoc1, lsLoc2, lsLoc3, lsLoc4, lsLoc5, lsLoc6, lsLoc7
String lsTitle

dw_report.reset( )

ls_warehouse_code = data
lsName = dwo.name

//New Table for getting paramators for the reports.
Select User_Field1, User_Field2, User_Field3, User_Field4, User_Field5, User_Field6, User_Field7, User_Field9 INTO :lsLoc1, :lsLoc2, :lsLoc3, :lsLoc4, :lsLoc5, :lsLoc6, :lsLoc7, :lsTitle FROM Project_Reports_Parm with (NoLock) 
Where Project_ID = :gs_project AND Report_Id = 'PANMIM' and User_Field0 = :ls_warehouse_code  USING SQLCA;

If lsLoc1 <> '' then
	dw_report.Modify("loc1_qty_t.Visible='1'")
	dw_report.Modify("loc1_qty_t.Text='" + lsLoc1 + "'" )
Else
	dw_report.Modify("loc1_qty_t.Visible='0'")	
End if
If lsLoc2 <> '' then
	dw_report.Modify("loc2_qty_t.Visible='1'")
	dw_report.Modify("loc2_qty_t.Text='" + lsLoc2 + "'" )
Else
	dw_report.Modify("loc2_qty_t.Visible='0'")	
End if
If lsLoc3 <> '' then
	dw_report.Modify("loc3_qty_t.Visible='1'")
	dw_report.Modify("loc3_qty_t.Text='" + lsLoc3 + "'" )
Else
	dw_report.Modify("loc3_qty_t.Visible='0'")	
End if
If lsLoc4 <> '' then
	dw_report.Modify("loc4_qty_t.Visible='1'")
	dw_report.Modify("loc4_qty_t.Text='" + lsLoc4 + "'" )
Else
	dw_report.Modify("loc4_qty_t.Visible='0'")	
End if
If lsLoc5 <> '' then
	dw_report.Modify("loc5_qty_t.Visible='1'")
	dw_report.Modify("loc5_qty_t.Text='" + lsLoc5 + "'" )
Else
	dw_report.Modify("loc5_qty_t.Visible='0'")	
End if
If lsLoc6 <> '' then
	dw_report.Modify("loc6_qty_t.Visible='1'")
	dw_report.Modify("loc6_qty_t.Text='" + lsLoc6 + "'" )
Else
	dw_report.Modify("loc6_qty_t.Visible='0'")	
End if
If lsLoc7 <> '' then
	dw_report.Modify("loc7_qty_t.Visible='1'")
	dw_report.Modify("loc7_qty_t.Text='" + lsLoc7 + "'" )
Else
	dw_report.Modify("loc7_qty_t.Visible='0'")	
End if


dw_report.Modify("t_2.Text='" + lsTitle + "'" )


end event

type cb_clear from w_std_report`cb_clear within w_pandora_mim_demand_analysis
integer x = 3365
integer y = 8
integer width = 96
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_pandora_mim_demand_analysis
integer x = 23
integer y = 124
integer width = 4544
integer height = 1796
integer taborder = 30
string dataobject = "d_pandora_mim_demand_rpt"
boolean hscrollbar = true
end type

