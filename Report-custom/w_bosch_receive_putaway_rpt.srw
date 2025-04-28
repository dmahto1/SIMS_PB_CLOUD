HA$PBExportHeader$w_bosch_receive_putaway_rpt.srw
forward
global type w_bosch_receive_putaway_rpt from w_std_report
end type
end forward

global type w_bosch_receive_putaway_rpt from w_std_report
string title = "BOSCH Receive Putaway Report"
boolean minbox = false
end type
global w_bosch_receive_putaway_rpt w_bosch_receive_putaway_rpt

type variables
string is_orgsql
end variables

on w_bosch_receive_putaway_rpt.create
call super::create
end on

on w_bosch_receive_putaway_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;is_orgsql=dw_report.getsqlselect( )
end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
dw_select.SetFocus()

end event

event ue_retrieve;call super::ue_retrieve;
string as_ship_ref,lsSort
long ll_count,li_rc



If dw_select.Accepttext( ) = -1 Then Return

SetPointer(HourGlass!)

Choose Case Upper(dw_select.GetITemString(1,'sort_type'))
	Case 'O'
		dw_report.dataobject='d_bosch_receive_putaway_rpt_select'
	Case 'S'
		dw_report.dataobject='d_bosch_receive_putaway_rpt_select_by_sku'
End Choose

dw_report.settransobject( SQLCA)
dw_report.setredraw( false)	
dw_report.reset( )

If dw_select.rowcount( ) <= 0 Then
	Return
End If

as_ship_ref= dw_select.getitemstring( 1, 'ship_ref')
ll_count= dw_report.retrieve( gs_project, as_ship_ref)

If ll_count >0 Then
	im_menu.m_file.m_print.Enabled =True
	dw_report.setfocus( )
Else
	im_menu.m_file.m_print.Enabled =False
	MessageBox(is_title,"No records found!")
	dw_Select.setfocus( )
End If

dw_report.setredraw( true)


SetPointer(Arrow!)
end event

event resize;call super::resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_sort;call super::ue_sort;dw_Report.GroupCalc()
Return 0
end event

type dw_select from w_std_report`dw_select within w_bosch_receive_putaway_rpt
integer width = 2377
integer height = 256
string dataobject = "d_bosch_receive_putaway_rpt_search"
end type

event dw_select::itemchanged;call super::itemchanged;string lsSort
long liMsg

Choose Case dwo.name
	CASE "sort_type"
	Choose Case data
		Case 'O'
			dw_report.dataobject='d_bosch_receive_putaway_rpt_select'
		Case 'S' 
			dw_report.dataobject='d_bosch_receive_putaway_rpt_select_by_sku'
	End Choose
End Choose			

dw_report.settransobject( SQLCA)
dw_report.setredraw( false)	
dw_report.reset( )

If dw_select.rowcount( ) <= 0 Then
	Return
End If

SetPointer(Arrow!)
end event

type cb_clear from w_std_report`cb_clear within w_bosch_receive_putaway_rpt
end type

type dw_report from w_std_report`dw_report within w_bosch_receive_putaway_rpt
integer y = 272
string dataobject = "d_bosch_receive_putaway_rpt_select"
boolean hscrollbar = true
end type

