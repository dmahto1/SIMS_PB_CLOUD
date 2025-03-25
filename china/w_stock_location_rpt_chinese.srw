HA$PBExportHeader$w_stock_location_rpt_chinese.srw
forward
global type w_stock_location_rpt_chinese from w_std_report
end type
type cbx_rollup from checkbox within w_stock_location_rpt_chinese
end type
end forward

global type w_stock_location_rpt_chinese from w_std_report
integer width = 3602
integer height = 2044
string title = "Stock Transfer Report"
cbx_rollup cbx_rollup
end type
global w_stock_location_rpt_chinese w_stock_location_rpt_chinese

type variables
DataWindowChild idwc_warehouse
datawindow idw_report
end variables

on w_stock_location_rpt_chinese.create
int iCurrent
call super::create
this.cbx_rollup=create cbx_rollup
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_rollup
end on

on w_stock_location_rpt_chinese.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_rollup)
end on

event open;call super::open;string	lsFilter

dw_select.GetChild('wh_code', idwc_warehouse)
idwc_warehouse.SetTransObject(sqlca)
If idwc_warehouse.Retrieve() > 0 Then
	
	//Filter Warehouse dropdown by Current Project
	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
	idwc_warehouse.SetFilter(lsFilter)
	idwc_warehouse.Filter()
	
	If idwc_warehouse.RowCount() > 0 Then
		dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
	End If
	
End If


end event

event ue_retrieve;String ls_whcode, ls_sloc, ls_eloc

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()
ls_whcode = dw_select.GetItemString(1, "wh_code")
ls_sloc = dw_select.GetItemString(1, "s_loc")
ls_eloc = dw_select.GetItemString(1, "e_loc")
If isnull(ls_sloc) Then ls_sloc = "          "
If isnull(ls_eloc) Then ls_eloc = "ZZZZZZZZZZ"

If dw_report.Retrieve(gs_project, ls_whcode, ls_sloc, ls_eloc) > 0 Then
	im_menu.m_file.m_print.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If



end event

event resize;dw_report.Resize(workspacewidth() - 75,workspaceHeight()-150)
end event

event ue_clear;//If idwc_warehouse.RowCount() > 0 Then
//	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
//End If
dw_select.Reset()
dw_select.InsertRow(0)



end event

event activate;call super::activate;//DGM Make owner name invisible based in indicator
IF Upper(g.is_owner_ind) <> 'Y' THEN
	dw_report.object.cf_owner_name.visible = 0
	dw_report.object.cf_name_t.visible = 0
End IF
IF Upper(g.is_coo_ind) <> 'Y' THEN	dw_report.object.country_of_origin.visible = 0	



end event

type dw_select from w_std_report`dw_select within w_stock_location_rpt_chinese
integer x = 5
integer y = 8
integer width = 3008
integer height = 96
string dataobject = "d_stock_location_rpt_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_stock_location_rpt_chinese
integer x = 2967
integer y = 12
end type

event cb_clear::clicked;call super::clicked;If idwc_warehouse.RowCount() > 0 Then
	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
End If

end event

type dw_report from w_std_report`dw_report within w_stock_location_rpt_chinese
integer y = 116
integer width = 3497
integer height = 1692
string dataobject = "d_stock_location_rpt_chinese"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type cbx_rollup from checkbox within w_stock_location_rpt_chinese
integer x = 2725
integer y = 12
integer width = 741
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
string text = "Roll Up to Location/SKU"
end type

event clicked;//Jxlim 08/03/2010 Modified for Chinese report
If this.checked Then
	//dw_report.dataobject = 'd_stock_location_rpt_rollup'
	dw_report.dataobject = 'd_stock_location_rpt_rollup_chinese'
	dw_report.SetTransObject(SQLCA)
Else
	//dw_report.dataobject = 'd_stock_location_rpt'
	dw_report.dataobject = 'd_stock_location_rpt_chinese'
	dw_report.SetTransObject(SQLCA)
End If
end event

event constructor;
g.of_check_label_button(this)
end event

