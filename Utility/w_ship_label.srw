HA$PBExportHeader$w_ship_label.srw
forward
global type w_ship_label from w_std_report
end type
end forward

global type w_ship_label from w_std_report
integer x = 567
integer y = 564
integer width = 2729
integer height = 1872
string title = "Shipping Label"
long backcolor = 128
end type
global w_ship_label w_ship_label

type variables
DataWindowChild idwc_warehouse
String	isOrigSql

end variables

on w_ship_label.create
call super::create
end on

on w_ship_label.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;String	lsWhere,	&
			lsNewSql
Date		ldToDAte
			
Long ll_cnt

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)

//tackon where

//Always tackon Project
lsWhere += " and delivery_master.project_id = '" + gs_project + "'"

//Tackon from BOL Nbr
if  not isnull(dw_select.GetItemString(1,"from_bol_nbr")) then
	lswhere += " and Invoice_No >= '" + dw_select.GetItemString(1,"from_bol_nbr") + "'"
end if

//Tackon to BOL Nbr
if  not isnull(dw_select.GetItemString(1,"to_bol_nbr")) then
	lswhere += " and Invoice_No <= '" + dw_select.GetItemString(1,"to_bol_nbr") + "'"
end if

//Tackon From Date
If dw_select.GetItemDate(1,"from_date") > date('01-01-1900') Then
		lsWhere = lsWhere + " and Complete_Date >= '" + string(dw_select.GetItemDate(1,"from_date"),'mm-dd-yyyy') + "'"
End If

//Tackon To Date
If dw_select.GetItemDate(1,"to_date") > date('01-01-1900') Then
		ldToDate = relativeDate(dw_select.GetItemDate(1,"to_date"),1) /*account for time in date*/
		lsWhere = lsWhere + " and Complete_Date < '" + string(ldToDate,'mm-dd-yyyy') + "'"
End If

//5/00 PCONKL, changed report parm to retrieve by search critera
//If lsWhere > '  ' Then
//	lsWhere = replace(lsWhere,1,4,' Where') /*replace first and with where*/
	lsNewSql = isOrigSql + lsWhere 
	dw_report.setsqlselect(lsNewsql)
//Else
//	dw_report.setsqlselect(isOrigSql)
// End If

ll_cnt = dw_report.Retrieve()
If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found matching your search criteria!")
	dw_select.Setfocus()
End If


end event

event open;call super::open;isOrigSql = dw_report.getsqlselect()

ilHelpTopicID = 542
end event

event ue_clear;dw_select.Reset()
dw_select.Insertrow(0)
end event

type dw_select from w_std_report`dw_select within w_ship_label
integer x = 0
integer y = 16
integer width = 1929
integer height = 160
string dataobject = "d_ship_label-select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_ship_label
integer x = 2350
integer y = 12
integer width = 270
integer height = 100
integer taborder = 20
end type

event cb_clear::clicked;call super::clicked;
dw_select.reset()
dw_select.insertrow(0)

end event

type dw_report from w_std_report`dw_report within w_ship_label
integer x = 50
integer y = 200
integer width = 2629
integer height = 1476
integer taborder = 30
string dataobject = "d_ship_label"
boolean hscrollbar = true
end type

