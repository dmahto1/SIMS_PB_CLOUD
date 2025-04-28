$PBExportHeader$w_kn_invoice_rpt.srw
forward
global type w_kn_invoice_rpt from w_std_report
end type
end forward

global type w_kn_invoice_rpt from w_std_report
integer width = 3790
integer height = 2384
string title = "K&N Proma Invoice"
end type
global w_kn_invoice_rpt w_kn_invoice_rpt

on w_kn_invoice_rpt.create
call super::create
end on

on w_kn_invoice_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;//K&N invoice report wason 03/09/04
string ls_order
string ls_do_no
string ls_invoice_no

long ll_cnt
long ll_number
long ll_number_of_digits

boolean lb_selection

lb_selection = FALSE
If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

ls_do_no = w_do.idw_main.getitemstring(1,"DO_NO")

select invoice_no into :ls_invoice_no from delivery_master where do_no = :ls_do_no and project_id = :gs_project;

dw_select.SetItem(1,"order_no", ls_invoice_no)

////Tack on order number 
//IF NOT isnull(dw_select.GetItemString(1,"order_no")) THEN
//	ls_do_no = dw_select.GetItemString(1,"order_no")
//
//	
//Else /*null*/
//	
//	MessageBox(is_title, "Please select a delivery order first",stopsign!)
//	return
//		
//END IF



//Remit info is passed to the nested report from paramaters passed from here to main report!

ll_cnt = dw_report.Retrieve(gs_project,ls_do_no)

IF ll_cnt > 0  THEN
	im_menu.m_file.m_print.Enabled = TRUE
	dw_report.modify('DataWindow.Print.Preview ="yes"')
	dw_report.Setfocus()
ELSE
	im_menu.m_file.m_print.Enabled = FALSE	
	MessageBox(is_title, "Orders found in New or Picking status!")
	close(this)
//	dw_select.Setfocus()
//	dw_select.SetColumn('order_no')
END IF
		


end event

event ue_clear;call super::ue_clear;
dw_select.Reset()
dw_select.InsertRow(0)
end event

event ue_postopen;call super::ue_postopen;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-200)
//If Delivery Order is Open, default the Order to the current Delivery Order Number
If isVAlid(w_do) Then
	if w_do.idw_main.RowCOunt() > 0 Then
//		dw_select.SetItem(1,"order_no", w_do.idw_main.getitemstring(1,"DO_NO"))
		This.TriggerEvent('ue_retrieve')
	End If
Else
	messagebox("K&N Invoice","You must open a Delivery Order before you can print the Invoice.!")
	close(this)
End If
end event

event resize;call super::resize;dw_report.Resize(workspacewidth() - 5,workspaceHeight() - 10)
end event

type dw_select from w_std_report`dw_select within w_kn_invoice_rpt
boolean visible = false
integer x = 5
integer width = 2994
integer height = 64
boolean enabled = false
string dataobject = "d_kn_invoice_srch"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_kn_invoice_rpt
integer x = 3035
integer y = 36
end type

type dw_report from w_std_report`dw_report within w_kn_invoice_rpt
integer x = 0
integer y = 0
integer width = 3703
integer height = 2164
string dataobject = "d_kn_invoice"
boolean hscrollbar = true
boolean livescroll = false
borderstyle borderstyle = StyleLowered!
end type

