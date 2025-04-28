$PBExportHeader$w_comcast_serial_pallet.srw
forward
global type w_comcast_serial_pallet from w_std_report
end type
end forward

global type w_comcast_serial_pallet from w_std_report
integer width = 4069
integer height = 2192
string title = "Inventory Report - Serial and Pallet Data"
end type
global w_comcast_serial_pallet w_comcast_serial_pallet

type variables
string is_origsql


end variables

on w_comcast_serial_pallet.create
call super::create
end on

on w_comcast_serial_pallet.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;is_OrigSql = dw_report.getsqlselect()
end event

event ue_postopen;call super::ue_postopen;dw_select.InsertRow(0)
end event

event ue_retrieve;call super::ue_retrieve;//Jxlim 12/02/2010 Comcast EIS Error visibility
Boolean lb_where
String ls_Where, ls_NewSql, ls_string, ls_order

Long	llRowCount,	&
		llRowPos	
		
//Initialize		
lb_where = False
ls_order = "ORDER BY dbo.content_summary.sku,dbo.carton_serial.pallet_id, dbo.carton_serial.serial_no"

dw_select.accepttext()

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

dw_report.SetRedraw(False)

//////////////////
// Add project id to where clause
If not isNull(ls_string) then
	ls_where += " and dbo.content_summary.project_id = '" + gs_project + "' and dbo.carton_serial.project_id = '" + gs_project + "' "
	lb_where = TRUE
End If

////////////////////////

//SKU
ls_string = dw_select.GetItemString(1,"SKU")
If  len(trim( ls_string )) > 0  and not isNull(ls_string) then
	ls_where += " and dbo.content_summary.SKU like ( '" + ls_string + "' )  "
	lb_where = TRUE
End If


//Modify SQL
If 	lb_where = True Then
	//If some criteria were entered replace the first "and" with "Where"
	//ls_where = Replace(ls_where,pos(ls_where,"and"),3,"Where")	
	ls_NewSql = is_origsql + ls_Where + ls_order
	dw_report.setsqlselect(ls_Newsql)
Else
	ls_NewSql = is_origsql + ls_order
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

event resize;call super::resize;//dw_report.Resize(workspacewidth() - 50,workspaceHeight()-300)

/*BCR - 03162011 - Introduce Tran_Type and Site_Id fields. Resize to accomodate.*/
dw_report.Resize(workspacewidth() - 75,workspaceHeight()-400)
end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

dw_report.Reset()

end event

type dw_select from w_std_report`dw_select within w_comcast_serial_pallet
integer width = 4023
integer height = 296
string dataobject = "d_comcast_serial_pallet_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_comcast_serial_pallet
end type

type dw_report from w_std_report`dw_report within w_comcast_serial_pallet
integer y = 328
integer width = 3945
integer height = 1596
string dataobject = "d_comcast_serial_pallet"
boolean hscrollbar = true
end type

