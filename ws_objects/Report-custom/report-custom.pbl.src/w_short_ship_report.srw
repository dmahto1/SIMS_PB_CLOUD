$PBExportHeader$w_short_ship_report.srw
$PBExportComments$Short Ship Report
forward
global type w_short_ship_report from w_std_report
end type
end forward

global type w_short_ship_report from w_std_report
integer width = 4677
integer height = 2356
string title = "Short Ship Report"
end type
global w_short_ship_report w_short_ship_report

type variables
string is_origsql, isCustomer
string is_origsql2, isOrder
long il_long


String	isremit_name,isRemit_addr1, isRemit_addr2,isRemit_addr3, isRemit_Addr4, isRemit_city, isRemit_state, isRemit_zip, isRemit_country


String isDoNo
end variables

on w_short_ship_report.create
call super::create
end on

on w_short_ship_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() - 60,workspaceHeight()-40)
end event

event ue_clear;//dw_select.Reset()
//dw_select.InsertRow(0)
//
end event

event ue_postopen;call super::ue_postopen;


This.TriggerEvent('ue_retrieve')

end event

event ue_retrieve;
im_menu.m_file.m_print.Enabled = False

dw_report.retrieve(gs_project)

dw_report.SetRedraw(True)

im_menu.m_file.m_print.Enabled = TRUE









end event

type dw_select from w_std_report`dw_select within w_short_ship_report
event ue_populate_dropdowns ( )
event ue_process_enter pbm_dwnprocessenter
boolean visible = false
integer x = 3525
integer y = 20
integer width = 78
integer height = 152
string dataobject = "d_linksys_invoice_srch"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::itemerror;Return 1
end event

type cb_clear from w_std_report`cb_clear within w_short_ship_report
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_short_ship_report
integer x = 32
integer y = 12
integer width = 4549
integer height = 2056
integer taborder = 30
string dataobject = "d_short_ship_report"
boolean hscrollbar = true
end type

