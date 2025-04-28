$PBExportHeader$w_nycsp_pallet_count_by_warehouse.srw
$PBExportComments$+NYCSP- Pallet Count By Warehouse
forward
global type w_nycsp_pallet_count_by_warehouse from w_std_report
end type
end forward

global type w_nycsp_pallet_count_by_warehouse from w_std_report
integer width = 3730
integer height = 1672
string title = "Pallet Count Details By Warehouse"
end type
global w_nycsp_pallet_count_by_warehouse w_nycsp_pallet_count_by_warehouse

type variables
String isorigsql
end variables

on w_nycsp_pallet_count_by_warehouse.create
call super::create
end on

on w_nycsp_pallet_count_by_warehouse.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;//26-Dec-2013 :Madhu- NYCSP- Pallet Count Details By Warehouse

long ll_cnt

SetPointer(HourGlass!)
dw_report.reset()

ll_cnt = dw_report.Retrieve()

If ll_cnt >0 Then
	im_menu.m_file.m_print.Enabled =True
	dw_report.setfocus()
	
else
	im_menu.m_file.m_print.Enabled =False
	MessageBox(is_title,"No Recordsfound")
END If
end event

event open;call super::open;isorigsql =dw_report.GetSQLSelect()
end event

type dw_select from w_std_report`dw_select within w_nycsp_pallet_count_by_warehouse
boolean visible = false
end type

type cb_clear from w_std_report`cb_clear within w_nycsp_pallet_count_by_warehouse
end type

type dw_report from w_std_report`dw_report within w_nycsp_pallet_count_by_warehouse
integer y = 20
integer width = 3598
string dataobject = "d_nycsp_pallet_count_by_warehouse"
boolean hscrollbar = true
end type

