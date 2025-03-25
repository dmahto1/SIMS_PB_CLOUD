$PBExportHeader$w_carton_serial_search.srw
$PBExportComments$This window is used for reporting the invoice information
forward
global type w_carton_serial_search from w_std_report
end type
end forward

global type w_carton_serial_search from w_std_report
integer width = 4050
integer height = 2200
string title = "Carton Serial Search"
long backcolor = 67108864
end type
global w_carton_serial_search w_carton_serial_search

type variables

string is_origsql
end variables

on w_carton_serial_search.create
call super::create
end on

on w_carton_serial_search.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;
is_OrigSql = dw_report.getsqlselect()
//messagebox("is origsql",is_origsql)

dw_select.InsertRow(0)

dw_report.SetTransObject(SQLCA)

im_menu = This.MenuId
end event

event resize;dw_report.Resize(workspacewidth() - 45,workspaceHeight()-360)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_postopen;call super::ue_postopen;//DatawindowChild	ldwc_warehouse
//string				lsFilter
//
////populate dropdowns - not done automatically since dw not being retrieved
//
////dw_select.GetChild('warehouse', ldwc_warehouse)
////ldwc_warehouse.SetTransObject(Sqlca)
////ldwc_warehouse.Retrieve(gs_project)
////
//dw_select.GetChild('warehouse', ldwc_warehouse)
//ldwc_warehouse.SetTransObject(sqlca)
//If ldwc_warehouse.Retrieve(gs_project) > 0 Then
//	
//	//Filter Warehouse dropdown by Current Project
//	lsFilter = "project_id = '" + gs_project + "'"
//	ldwc_warehouse.SetFilter(lsFilter)
//	ldwc_warehouse.Filter()
//	
//	dw_select.SetItem(1, "warehouse" , ldwc_warehouse.GetItemString(1, "wh_code"))
//	
//End If
//
//
end event

event ue_retrieve;
//SELECT  dbo.Carton_Serial.SKU ,
//           dbo.Carton_Serial.Supp_Code ,
//           dbo.Carton_Serial.Pallet_ID ,
//           dbo.Carton_Serial.Carton_ID ,
//           dbo.Carton_Serial.Serial_No ,
//           dbo.Carton_Serial.Mac_ID ,
//           dbo.Carton_Serial.User_field1     
//        FROM dbo.Carton_Serial      
//        WHERE ( dbo.Carton_Serial.Project_ID = :Project_ID )   

dw_select.AcceptText()

integer ll_cnt, li_where_no_select_len
string lsWhere, lsNewSql,  ls_Pallet, ls_Carton, ls_Serial, ls_Mac, ls_user_field1
String ls_user_field2,ls_user_field3,ls_user_field4,ls_user_field5,ls_user_field6
String ls_user_field7,ls_user_field8,ls_user_field9,ls_user_field10

lsWhere = ''

//always tackon Project
lsWhere = " WHERE dbo.Carton_Serial.Project_ID = '" + gs_project + "'"

li_where_no_select_len = len(lsWhere)

//Pallet

ls_Pallet =  dw_select.GetItemString(1, "pallet")

if not isnull(ls_Pallet) and trim(ls_Pallet) <> "" then

	lsWhere = lsWhere + " and dbo.Carton_Serial.Pallet_ID =  '" + trim(ls_Pallet) + "'"

end if

//Carton

ls_Carton =  dw_select.GetItemString(1, "carton")

if not isnull(ls_Carton) and trim(ls_Carton) <> "" then

	lsWhere = lsWhere + " and dbo.Carton_Serial.Carton_ID =  '" + trim(ls_Carton) + "'"

end if

//Serial

ls_Serial =  dw_select.GetItemString(1, "serial")

if not isnull(ls_Serial) and trim(ls_Serial) <> "" then

	lsWhere = lsWhere + " and dbo.Carton_Serial.Serial_No =  '" + trim(ls_Serial) + "'"

end if

ls_Mac =  dw_select.GetItemString(1, "mac")

if not isnull(ls_Mac) and trim(ls_Mac) <> "" then

	lsWhere = lsWhere + " and dbo.Carton_Serial.Mac_ID =  '" + trim(ls_Mac) + "'"

end if


ls_user_field1 =  dw_select.GetItemString(1, "user_field1")

if not isnull(ls_user_field1) and trim(ls_user_field1) <> "" then

	lsWhere = lsWhere + " and dbo.Carton_Serial.User_field1 =  '" + trim(ls_user_field1) + "'"

end if

//Jxlim 07/06/2010 added user_field2-6 to serach criteria
// GXMOR 07/01/2011 added user_fields 7 thru 10 to search criteria
ls_user_field2 =  dw_select.GetItemString(1, "user_field2")
if not isnull(ls_user_field2) and trim(ls_user_field2) <> "" then
	lsWhere = lsWhere + " and dbo.Carton_Serial.User_field2 =  '" + trim(ls_user_field2) + "'"
end if
ls_user_field3 =  dw_select.GetItemString(1, "user_field3")
if not isnull(ls_user_field3) and trim(ls_user_field3) <> "" then
	lsWhere = lsWhere + " and dbo.Carton_Serial.User_field3 =  '" + trim(ls_user_field3) + "'"
end if
ls_user_field4 =  dw_select.GetItemString(1, "user_field4")
if not isnull(ls_user_field4) and trim(ls_user_field4) <> "" then
	lsWhere = lsWhere + " and dbo.Carton_Serial.User_field4 =  '" + trim(ls_user_field4) + "'"
end if
ls_user_field5 =  dw_select.GetItemString(1, "user_field5")
if not isnull(ls_user_field5) and trim(ls_user_field5) <> "" then
	lsWhere = lsWhere + " and dbo.Carton_Serial.User_field5 =  '" + trim(ls_user_field5) + "'"
end if
ls_user_field6 =  dw_select.GetItemString(1, "user_field6")
if not isnull(ls_user_field6) and trim(ls_user_field6) <> "" then
	lsWhere = lsWhere + " and dbo.Carton_Serial.User_field6 =  '" + trim(ls_user_field6) + "'"
end if
//Jxlim 07/06/2010 end of user_field criteria
ls_user_field7 =  dw_select.GetItemString(1, "user_field7")
if not isnull(ls_user_field7) and trim(ls_user_field7) <> "" then
	lsWhere = lsWhere + " and dbo.Carton_Serial.User_field7 =  '" + trim(ls_user_field7) + "'"
end if
ls_user_field8 =  dw_select.GetItemString(1, "user_field8")
if not isnull(ls_user_field8) and trim(ls_user_field8) <> "" then
	lsWhere = lsWhere + " and dbo.Carton_Serial.User_field8 =  '" + trim(ls_user_field8) + "'"
end if
ls_user_field9 =  dw_select.GetItemString(1, "user_field9")
if not isnull(ls_user_field9) and trim(ls_user_field9) <> "" then
	lsWhere = lsWhere + " and dbo.Carton_Serial.User_field9 =  '" + trim(ls_user_field9) + "'"
end if
ls_user_field10 =  dw_select.GetItemString(1, "user_field10")
if not isnull(ls_user_field10) and trim(ls_user_field10) <> "" then
	lsWhere = lsWhere + " and dbo.Carton_Serial.User_field10 =  '" + trim(ls_user_field10) + "'"
end if
// GXMOR 07/01/2011 end of user_field criteria for attributes

IF len(lsWhere) = li_where_no_select_len THEN
	
	MessageBox ("Error", "You must select at least one of the selection criteria.")
	
	RETURN 
	
END IF

If lsWhere > '  ' Then
	
	lsNewSql = is_origsql + lsWhere /*second Where */
	
	dw_report.setsqlselect(lsNewsql) 
	
End If


ll_cnt = dw_report.Retrieve()
If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If

w_carton_serial_search.SetMicroHelp(String(dw_report.RowCount()) + " Records retrieved...")
end event

event closequery;call super::closequery;
w_carton_serial_search.SetMicroHelp("Ready")
end event

type dw_select from w_std_report`dw_select within w_carton_serial_search
integer y = 28
integer width = 3520
integer height = 364
string dataobject = "d_carton_serial_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_carton_serial_search
integer x = 3547
integer y = 116
end type

type dw_report from w_std_report`dw_report within w_carton_serial_search
integer y = 388
integer width = 3931
integer height = 1568
string dataobject = "d_carton_serial_list"
boolean hscrollbar = true
end type

