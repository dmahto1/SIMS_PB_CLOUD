HA$PBExportHeader$w_3com_customs_declaration_report.srw
forward
global type w_3com_customs_declaration_report from w_std_report
end type
end forward

global type w_3com_customs_declaration_report from w_std_report
integer width = 4462
integer height = 2044
string title = "3COM Customs Declaration Report"
end type
global w_3com_customs_declaration_report w_3com_customs_declaration_report

type variables
String	isOrigSql


end variables

on w_3com_customs_declaration_report.create
call super::create
end on

on w_3com_customs_declaration_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
isOrigSql = dw_report.getsqlselect()



end event

event ue_retrieve;
string ls_order_nbr
string ls_do_no

long ll_cnt
long ll_number

boolean lb_selection

lb_selection = FALSE
If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

ls_do_no = w_do.idw_main.getitemstring(1,"DO_NO")

ll_cnt = dw_report.Retrieve(ls_do_no)

If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If

end event

event resize;dw_report.Resize(workspacewidth() - 5,workspaceHeight()-5)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)


end event

event ue_postopen;call super::ue_postopen;//If Delivery Order is Open, default the Order to the current Delivery Order Number
If isVAlid(w_do) Then
	if w_do.idw_main.RowCOunt() > 0 Then
		This.TriggerEvent('ue_retrieve')
	End If
Else
	messagebox("3COM Customs Declaration","You must open a Delivery Order before you can print Customs Declaration Report.!")
	close(this)
End If
end event

type dw_select from w_std_report`dw_select within w_3com_customs_declaration_report
boolean visible = false
integer x = 9
integer y = 0
integer width = 41
integer height = 36
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::clicked;string 	ls_column

long		ll_row

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "order_nbr"
		
			dw_select.SetColumn("order_nbr")
		
END CHOOSE

end event

type cb_clear from w_std_report`cb_clear within w_3com_customs_declaration_report
end type

type dw_report from w_std_report`dw_report within w_3com_customs_declaration_report
integer x = 5
integer y = 4
integer width = 4416
integer height = 1844
integer taborder = 30
string dataobject = "d_3com_customs_declaration"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

