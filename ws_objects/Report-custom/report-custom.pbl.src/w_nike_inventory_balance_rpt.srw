$PBExportHeader$w_nike_inventory_balance_rpt.srw
forward
global type w_nike_inventory_balance_rpt from window
end type
type st_1 from statictext within w_nike_inventory_balance_rpt
end type
type cb_print from commandbutton within w_nike_inventory_balance_rpt
end type
type dw_report from datawindow within w_nike_inventory_balance_rpt
end type
type dw_query from datawindow within w_nike_inventory_balance_rpt
end type
end forward

global type w_nike_inventory_balance_rpt from window
integer x = 823
integer y = 360
integer width = 1920
integer height = 852
boolean titlebar = true
string title = "Inventory Balance Report"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_print ( )
event ue_retrieve ( )
event ue_saveas ( )
event ue_file ( )
st_1 st_1
cb_print cb_print
dw_report dw_report
dw_query dw_query
end type
global w_nike_inventory_balance_rpt w_nike_inventory_balance_rpt

type variables
String      is_title, is_org_sql
m_report im_menu
end variables

event ue_print();Long i, ll_cnt, ll_qtytot
String ls_sku, ls_invtype, ls_prev_invtype, ls_descript, ls_whcode
Datetime ld_date
//OLEObject xl, xs
String filename, ls_path, ls_name, ls_date
String lineout[1 to 11]
Long pos, ll_return

If dw_query.AcceptText() = -1 Then Return

ls_whcode = dw_query.GetItemString(1, "wh_code")
If IsNull(ls_whcode) Then
	MessageBox(is_title, "Please choose a warehouse!")
	dw_query.SetFocus()
	dw_query.SetColumn("wh_code")
	Return
End If

//  Retrieve inventory
//SetMicroHelp("Retrieving data... ")
st_1.text = "Retrieving data ..."
SetPointer(HourGlass!)

ls_date = string(today(),"mmm dd, yyyy hhmm")
ll_cnt = dw_report.Retrieve(gs_project, ls_whcode)
If ll_cnt < 1 Then 
	MessageBox(is_title, "No record found!")
	Return
End If


//--------------------------
//SetMicroHelp("Opening Excel ...")
//filename = ProfileString(gs_inifile,"ewms","syspath","") + "inv_balance.xls"
//
//xl = CREATE OLEObject
//xs = CREATE OLEObject
//xl.ConnectToNewObject("Excel.Application")
//xl.Workbooks.Open(filename,0,True)
////xl.Workbooks.Add
//
//ls_prev_invtype = "XXX"
//pos = 2
//For i = 1 to ll_cnt
//	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
//	
//	ls_invtype = dw_report.GetItemstring(i, "inventory_type")
//	SetNull(ls_descript)	
//	Select code_descript into : ls_descript From sys_code where code_id = :ls_invtype and code_type='IT';
//	If Isnull(ls_descript) Then ls_descript = "Empty"
//	
//	If ls_invtype <> ls_prev_invtype Then
//		If ls_prev_invtype <> 'XXX' Then
//			xs.cells(pos + 2,4).value = "TOTAL:"
//			xs.Cells(pos + 2,5).Value = ll_qtytot
//			xs.Range("A3").Select
//		End If
//
//		pos = 2
//		ll_qtytot = 0
//		
//xl.Sheets("Sheet1").Select
//xl.ActiveSheet.Range("A2:E2").Select
//xl.Selection.Copy
//
//		xs = xl.worksheets.add
//		xs.name = ls_descript
//
////		xs.cells(2,1).value = "Style"
////		xs.cells(2,2).value = "Color"
////		xs.cells(2,3).value = "Size"
////		xs.cells(2,4).value = "Inventory_Type"
////		xs.cells(2,5).value = "Qty"
//		xs.cells(1,1).value = "Print Date: " + string(ld_date, "mm/dd/yyyy hh:mm")
//      xs.Range("A2").Select
//    	xs.Paste
//		xs.Columns("A:A").ColumnWidth = 15
//		xs.Columns("B:B").ColumnWidth = 10
//		xs.Columns("C:C").ColumnWidth = 10
//		xs.Columns("D:D").ColumnWidth = 15
//		xs.Columns("E:E").ColumnWidth = 10
//	End If
//
//	pos += 1
////	xs.rows(pos + 1).Insert
//
//	xs.cells(pos,1).value = "'" + left(dw_report.GetItemString(i, "sku"),6)
//	xs.cells(pos,2).value = "'" + Mid(dw_report.GetItemString(i, "sku"),7,3)
//	xs.cells(pos,3).value = "'" + Mid(dw_report.GetItemString(i, "sku"),10)
//	xs.cells(pos,4).value = dw_report.GetItemString(i, "inventory_type")
//	xs.cells(pos,5).value = dw_report.GetItemNumber(i,"qty")
//	ll_qtytot += dw_report.GetItemNumber(i,"qty")
//	
//	ls_prev_invtype = ls_invtype
//Next
//xs.cells(pos + 2,4).value = "TOTAL:"
//xs.Cells(pos + 2,5).Value = ll_qtytot
//xs.Range("A3").Select
//
//SetMicroHelp("Complete!")
//xl.Visible = True
//xl.DisconnectObject()
//----------------------------

OpenWithParm(w_dw_print_options,dw_report)

/*SARUN20070531
ls_name = "inventory of " + ls_date
ls_path = ProfileString(gs_inifile,"ewms","UploadPath","") + ls_name
ll_return = GetFileSaveName("Save As File", ls_path, ls_name, "XLS", &
	" Excel Files (*.XLS), *.XLS")
If ll_return = 1 Then
	st_1.text = "Saving excel file ..."
	ll_return = dw_report.SaveAs(ls_path, Excel5!, True)
	if ll_return <> 1 Then
		Messagebox(is_title, "Error when saveing excel file!")
	Else
		st_1.text = "Saved excel file completely"
	End If
Else
	If ll_return = 0 Then
		st_1.text = "Saving cancelled"
	Else
		st_1.text = "Please check saveas file name!"
	End If
End If
SARUN20070531*/
return



//Long i, ll_cnt, ll_qtytot
//String ls_sku, ls_invtype, ls_prev_invtype, ls_descript, ls_whcode
//Datetime ld_date
//OLEObject xl, xs
//String filename, ls_path, ls_name, ls_date
//String lineout[1 to 11]
//Long pos, ll_return
//
//If dw_query.AcceptText() = -1 Then Return
//
//ls_whcode = dw_query.GetItemString(1, "wh_code")
//If IsNull(ls_whcode) Then
//	MessageBox(is_title, "Please choose a warehouse!")
//	dw_query.SetFocus()
//	dw_query.SetColumn("wh_code")
//	Return
//End If
//
////  Retrieve inventory
////SetMicroHelp("Retrieving data... ")
//st_1.text = "Retrieving data ..."
//SetPointer(HourGlass!)
//
//ls_date = string(today(),"mmm dd, yyyy hhmm")
//ll_cnt = dw_report.Retrieve(gs_project, ls_whcode)
//If ll_cnt < 1 Then 
//	MessageBox(is_title, "No record found!")
//	Return
//End If
//
//SetMicroHelp("Opening Excel ...")
//filename =   gs_syspath + "Reports\inv_balance.xls"
//
//xl = CREATE OLEObject
//xs = CREATE OLEObject
//xl.ConnectToNewObject("Excel.Application")
//xl.Workbooks.Open(filename,0,True)
//xs = xl.application.workbooks(1).worksheets(1)
////xl.Workbooks.Add
//
//ls_prev_invtype = "XXX"
//pos = 2
//For i = 1 to ll_cnt
//	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
//	
////	ls_invtype = dw_report.GetItemstring(i, "inv_type")
//////	SetNull(ls_descript)	
//////	Select code_descript into : ls_descript From sys_code where code_id = :ls_invtype and code_type='IT';
//////	If Isnull(ls_descript) Then ls_descript = "Empty"
//////	
//////	If ls_invtype <> ls_prev_invtype Then
//////		If ls_prev_invtype <> 'XXX' Then
//////			xs.cells(pos + 2,4).value = "TOTAL:"
//////			xs.Cells(pos + 2,5).Value = ll_qtytot
//////			xs.Range("A3").Select
//////		End If
//////
////		pos = 2
////		ll_qtytot = 0
////		
////xl.Sheets("Sheet1").Select
////xl.ActiveSheet.Range("A2:E2").Select
////xl.Selection.Copy
////
////		xs = xl.worksheets.add
////		xs.name = ls_descript
////
//////		xs.cells(2,1).value = "Style"
//////		xs.cells(2,2).value = "Color"
//////		xs.cells(2,3).value = "Size"
//////		xs.cells(2,4).value = "Inventory_Type"
//////		xs.cells(2,5).value = "Qty"
////		xs.cells(1,1).value = "Print Date: " + string(ld_date, "mm/dd/yyyy hh:mm")
////      xs.Range("A2").Select
////    	xs.Paste
////		xs.Columns("A:A").ColumnWidth = 15
////		xs.Columns("B:B").ColumnWidth = 10
////		xs.Columns("C:C").ColumnWidth = 10
////		xs.Columns("D:D").ColumnWidth = 15
////		xs.Columns("E:E").ColumnWidth = 10
////	End If
////
////	pos += 1
//////	xs.rows(pos + 1).Insert
////
//	pos += 1
//	xs.rows(pos ).Insert
//	xs.cells(pos,1).value = "'" + dw_report.GetItemString(i, "division")
//	xs.cells(pos,2).value = "'" + dw_report.GetItemString(i, "sku")
//	xs.cells(pos,3).value = "'" + dw_report.GetItemString(i, "size")
//	xs.cells(pos,4).value = dw_report.GetItemString(i, "inv_type")
//	xs.cells(pos,5).value = dw_report.GetItemNumber(i,"qty")
//	ll_qtytot += dw_report.GetItemNumber(i,"qty")
//	
//	ls_prev_invtype = ls_invtype
//Next
////xs.cells(pos + 2,4).value = "TOTAL:"
////xs.Cells(pos + 2,5).Value = ll_qtytot
////xs.Range("A3").Select
////
//SetMicroHelp("Complete!")
//xl.Visible = True
//xl.DisconnectObject()
//
//
////OpenWithParm(w_dw_print_options,dw_report)
//
///*SARUN20070531
//ls_name = "inventory of " + ls_date
//ls_path = ProfileString(gs_inifile,"ewms","UploadPath","") + ls_name
//ll_return = GetFileSaveName("Save As File", ls_path, ls_name, "XLS", &
//	" Excel Files (*.XLS), *.XLS")
//If ll_return = 1 Then
//	st_1.text = "Saving excel file ..."
//	ll_return = dw_report.SaveAs(ls_path, Excel5!, True)
//	if ll_return <> 1 Then
//		Messagebox(is_title, "Error when saveing excel file!")
//	Else
//		st_1.text = "Saved excel file completely"
//	End If
//Else
//	If ll_return = 0 Then
//		st_1.text = "Saving cancelled"
//	Else
//		st_1.text = "Please check saveas file name!"
//	End If
//End If
//SARUN20070531*/
//return
//
//
end event

event ue_retrieve;This.Trigger Event ue_print()
end event

event ue_saveas();
IF dw_report.RowCount() > 0 THEN
	dw_report.SaveAs()
END IF
end event

event ue_file();
IF dw_report.RowCount() > 0 THEN
	dw_report.SaveAs()
END IF
end event

on w_nike_inventory_balance_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.st_1=create st_1
this.cb_print=create cb_print
this.dw_report=create dw_report
this.dw_query=create dw_query
this.Control[]={this.st_1,&
this.cb_print,&
this.dw_report,&
this.dw_query}
end on

on w_nike_inventory_balance_rpt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_print)
destroy(this.dw_report)
destroy(this.dw_query)
end on

event open;This.Move(0,0)

dw_query.SetTransObject(Sqlca)
dw_report.SetTransObject(Sqlca)

is_title = This.Title
im_menu = This.Menuid

dw_query.InsertRow(0)
dw_query.setitem(1, "wh_code", gs_default_wh)

im_menu.m_file.m_print.Enabled = True

// Loading from USer Warehouse Datastore 
DataWindowChild ldwc_warehouse,ldwc_warehouse2

dw_query.GetChild("wh_code", ldwc_warehouse)

ldwc_warehouse.SetTransObject(sqlca)

g.of_set_warehouse_dropdown(ldwc_warehouse)

dw_query.SetITem(1,'wh_code',gs_default_WH)

end event

type st_1 from statictext within w_nike_inventory_balance_rpt
integer x = 384
integer y = 76
integer width = 1047
integer height = 104
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_print from commandbutton within w_nike_inventory_balance_rpt
integer x = 823
integer y = 480
integer width = 343
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;parent.Trigger Event ue_print()
end event

type dw_report from datawindow within w_nike_inventory_balance_rpt
boolean visible = false
integer x = 795
integer y = 64
integer width = 1024
integer height = 464
integer taborder = 10
string dataobject = "d_nike_inven_balance_report"
borderstyle borderstyle = stylelowered!
end type

type dw_query from datawindow within w_nike_inventory_balance_rpt
integer x = 297
integer y = 308
integer width = 1221
integer height = 96
integer taborder = 20
string dataobject = "d_nike_packinglist_search"
boolean border = false
boolean livescroll = true
end type

