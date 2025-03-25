HA$PBExportHeader$w_serial_no_capture_outbound_report.srw
$PBExportComments$BCR 09-SEP-11: Outbound Serial No Capture Report Window
forward
global type w_serial_no_capture_outbound_report from w_std_report
end type
end forward

global type w_serial_no_capture_outbound_report from w_std_report
integer width = 4315
integer height = 2260
string title = "Outbound Serial No Capture Report"
end type
global w_serial_no_capture_outbound_report w_serial_no_capture_outbound_report

type variables
string is_origsql


end variables

on w_serial_no_capture_outbound_report.create
call super::create
end on

on w_serial_no_capture_outbound_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;if upper(left(gs_project, 4)) = 'NIKE' then
	
	dw_report.dataobject = "d_nike_serial_no_capture_outbound_report"
	dw_report.SetTransObject(SQLCA)
	
end if

is_OrigSql = dw_report.getsqlselect()





end event

event ue_retrieve;call super::ue_retrieve;//BCR 09-SEP-2011 
Boolean lb_where
String ls_Where, ls_NewSql, ls_string

Long	llRowCount,	&
		llRowPos	
		
DataWindowChild ldwc_InvType


//Initialize		
lb_where = False

dw_select.accepttext()

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)

dw_report.Reset()

dw_report.SetRedraw(False)

//Tackon the following...

//Project Code
ls_Where += " AND Delivery_Master.Project_Id = '" + gs_project + "'"

//Date From
If date(dw_select.GetItemDateTime(1, "Date_From")) > date('01-01-1900') Then
	ls_Where = ls_Where + " and Delivery_Master.Complete_Date >= '" + string(dw_select.GetItemDateTime(1, "Date_From"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = TRUE
End If

//Date To
If date(dw_select.GetItemDateTime(1, "Date_To")) > date('01-01-1900') Then
	ls_Where = ls_Where + " AND Delivery_Master.Complete_Date <= '" + string(dw_select.GetItemDateTime(1, "Date_To"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = TRUE
End If

string ls_Invoice_No

ls_Invoice_No = dw_select.GetItemString(1,"invoice_no")

//Invoice No
If Not IsNull(ls_Invoice_No) AND Trim(ls_Invoice_No) <> '' Then
	ls_Where = ls_Where + " AND Delivery_Master.Invoice_No = '" + ls_Invoice_No + "'"
	lb_where = TRUE
End If



//Modify SQL
If 	lb_where = True Then
	ls_NewSql = is_origsql + ls_Where 
	dw_report.setsqlselect(ls_Newsql)
Else
	//Force user to select date range
	MessageBox('Serial No Capture Report','Please select a date range or Invoice No.',StopSign!)
	dw_report.SetRedraw(True)
	RETURN
End If

//Set Inventory Type child dw
dw_report.GetChild('inventory_type',ldwc_InvType)
ldwc_InvType.SetTransObject(SQLCA)
ldwc_InvType.Retrieve(gs_project)

//Retrieve main dw
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

type dw_select from w_std_report`dw_select within w_serial_no_capture_outbound_report
integer width = 4210
integer height = 212
string dataobject = "d_serial_no_capture_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_serial_no_capture_outbound_report
end type

type dw_report from w_std_report`dw_report within w_serial_no_capture_outbound_report
integer y = 244
integer width = 4219
integer height = 1652
string dataobject = "d_serial_no_capture_outbound_report"
boolean hscrollbar = true
end type

