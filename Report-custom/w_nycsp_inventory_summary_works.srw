HA$PBExportHeader$w_nycsp_inventory_summary_works.srw
$PBExportComments$NYCSP Inventory Summary Works Report
forward
global type w_nycsp_inventory_summary_works from w_std_report
end type
end forward

global type w_nycsp_inventory_summary_works from w_std_report
integer width = 3497
integer height = 1780
string title = "NYCSP Inventory Summary works Reportss"
boolean resizable = false
end type
global w_nycsp_inventory_summary_works w_nycsp_inventory_summary_works

type variables
String		  isOrgsql



end variables

on w_nycsp_inventory_summary_works.create
call super::create
end on

on w_nycsp_inventory_summary_works.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;isOrgsql =dw_report.getsqlselect()
end event

event ue_retrieve;call super::ue_retrieve;//18-Dec-2013 -Madhu - NYCSP Inventory Summary Report Works

long ll_cnt

SetPointer(HourGlass!)
dw_report.reset()

ll_cnt = dw_report.retrieve(gs_project)

IF ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled =true
	dw_report.SetFocus()
ELSE
	im_menu.m_file.m_print.Enabled =false
	MessageBox(is_title, "No Records Found!")
END IF
end event

type dw_select from w_std_report`dw_select within w_nycsp_inventory_summary_works
boolean visible = false
integer y = 28
end type

type cb_clear from w_std_report`cb_clear within w_nycsp_inventory_summary_works
end type

type dw_report from w_std_report`dw_report within w_nycsp_inventory_summary_works
integer x = 14
integer y = 0
integer width = 3474
integer height = 1620
string title = "NYCSP Inventory Summary works Report"
string dataobject = "d_nycsp_inventory_summary_works"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

