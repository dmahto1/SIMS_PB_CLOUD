HA$PBExportHeader$w_inventory_replenish_rpt.srw
$PBExportComments$Window used for displaying inventory replenishment information
forward
global type w_inventory_replenish_rpt from w_std_report
end type
type rb_all from radiobutton within w_inventory_replenish_rpt
end type
type rb_below from radiobutton within w_inventory_replenish_rpt
end type
type cbx_pickable_inv_types from checkbox within w_inventory_replenish_rpt
end type
end forward

global type w_inventory_replenish_rpt from w_std_report
integer width = 3579
integer height = 2124
string title = "Inventory Replenish Report"
rb_all rb_all
rb_below rb_below
cbx_pickable_inv_types cbx_pickable_inv_types
end type
global w_inventory_replenish_rpt w_inventory_replenish_rpt

type variables

string is_OrigSql
end variables

on w_inventory_replenish_rpt.create
int iCurrent
call super::create
this.rb_all=create rb_all
this.rb_below=create rb_below
this.cbx_pickable_inv_types=create cbx_pickable_inv_types
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_all
this.Control[iCurrent+2]=this.rb_below
this.Control[iCurrent+3]=this.cbx_pickable_inv_types
end on

on w_inventory_replenish_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_all)
destroy(this.rb_below)
destroy(this.cbx_pickable_inv_types)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-220)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
dw_Select.SetItem(1,'warehouse',gs_default_wh)
end event

event ue_retrieve;
string ls_NewSql, ls_Where, ls_sql, ls_From = '', ls_having = ''
integer li_pos
string ls_Warehouse

dw_report.SetRedraw(False)


ls_Where =  " and reorder_point.Project_id = '" + gs_project + "' "

ls_Warehouse = dw_select.GetITemString(1,'warehouse')

IF Not IsNull(ls_Warehouse) AND Trim(ls_Warehouse) <> '' THEN

	ls_Where = ls_Where + " and Reorder_Point.WH_Code = '" + ls_Warehouse + "' "

END IF

ls_sql = is_OrigSQL

if cbx_pickable_inv_types.checked then
	
	ls_Where = ls_Where + " and Content_Summary.Inventory_Type IN (SELECT Inventory_type.Inv_Type FROM Inventory_type WHERE Inventory_type.Inventory_Shippable_Ind = 'Y' and Inventory_type.Project_id = '" + gs_project + "')  "
	ls_having = " and Content_Summary.Inventory_Type IS NOT NULL   "
	
end if


li_pos =Pos(Upper(ls_sql), "GROUP BY", 1)

if li_pos > 0 then
	
	ls_sql = left( ls_sql, li_pos - 1) + ls_where + mid(ls_sql, li_pos)
	
end if


li_pos = Pos(Upper(ls_sql), "UNION", li_pos)

IF ls_having <> '' then
	if li_pos > 0 then
	
		ls_sql = left( ls_sql, li_pos - 1) + ls_having + mid(ls_sql, li_pos)
		
	end if

END IF


li_pos =Pos(Upper(ls_sql), "GROUP BY", li_pos)


if li_pos > 0 then
	
	ls_sql = left( ls_sql, li_pos - 1) + ls_where + mid(ls_sql, li_pos)
	
end if

IF ls_having <> '' THEN
	
	ls_sql = ls_sql + ls_having 
	
END IF

// 12/09 - PCONKL - If we have added Inventory Type (pickable), we need to add inventory_type to the end of the Group by (right before the 'Having' Clause
if cbx_pickable_inv_types.checked then
	
	li_pos =Pos(Upper(ls_sql), "HAVING", 1)
	Do While li_Pos > 0
		
		ls_sql = Replace(ls_Sql, (li_pos - 1),1," , Inventory_Type ")
		li_pos += 20
		li_pos =Pos(Upper(ls_sql), "HAVING", li_pos)
		
	Loop
	
End If

ls_NewSql = ls_sql

dw_report.setsqlselect(ls_Newsql)

dw_report.SetFilter('')
dw_report.Filter()




dw_report.Retrieve()

//If RB checked, only show where we are below
if rb_below.Checked Then
	dw_report.SetFilter("c_qty_short >= 0")
	dw_Report.Filter()
End If
If dw_report.RowCount() > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If

dw_report.SetRedraw(True)
end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc_warehouse
String	lsFilter

// ET3 2012/05/24 - customization for Pandora
if gs_project = 'PANDORA' then
	dw_report.dataobject = 'd_pandora_inv_replenish_rpt'
	dw_report.settransobject( SQLCA )
	is_OrigSql = dw_report.getsqlselect()
end if

//populate dropdowns - not done automatically since dw not being retrieved

//dw_select.GetChild('warehouse', ldwc_warehouse)
//ldwc_warehouse.SetTransObject(Sqlca)
//ldwc_warehouse.Retrieve(gs_project)
//dw_Select.SetItem(1,'warehouse',gs_default_wh)

// LTK 20150922  Commented out block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
dw_select.GetChild("warehouse", ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_warehouse)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "warehouse", gs_default_wh)
end if

rb_all.Checked = True
end event

event open;call super::open;
is_OrigSql = dw_report.getsqlselect()
end event

type dw_select from w_std_report`dw_select within w_inventory_replenish_rpt
integer y = 28
integer width = 1577
integer height = 96
string dataobject = "d_warehouse_display_wh_code"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_inventory_replenish_rpt
integer x = 3191
integer y = 8
integer width = 320
end type

type dw_report from w_std_report`dw_report within w_inventory_replenish_rpt
integer x = 23
integer y = 208
integer width = 3483
integer height = 1716
string dataobject = "d_inv_replenish_rpt"
boolean hscrollbar = true
end type

event dw_report::sqlpreview;call super::sqlpreview;
//MessageBox ("ok", sqlsyntax)
end event

type rb_all from radiobutton within w_inventory_replenish_rpt
integer x = 1650
integer width = 695
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show All Items"
end type

event clicked;
dw_report.SetFilter("")
	dw_Report.Filter()
end event

type rb_below from radiobutton within w_inventory_replenish_rpt
integer x = 1650
integer y = 60
integer width = 1253
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show only Items at or Below Reorder Point"
end type

event clicked;
dw_report.SetFilter("c_qty_short >= 0")
dw_Report.Filter()
end event

type cbx_pickable_inv_types from checkbox within w_inventory_replenish_rpt
integer x = 1650
integer y = 136
integer width = 1029
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Include only Pickable Inventory Types"
end type

