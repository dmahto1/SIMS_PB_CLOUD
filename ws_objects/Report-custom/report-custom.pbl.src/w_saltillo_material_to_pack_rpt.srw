$PBExportHeader$w_saltillo_material_to_pack_rpt.srw
$PBExportComments$Saltillo Material to Pack Report
forward
global type w_saltillo_material_to_pack_rpt from w_std_report
end type
end forward

global type w_saltillo_material_to_pack_rpt from w_std_report
integer width = 3538
integer height = 2044
string title = "Materials to Pack Report"
end type
global w_saltillo_material_to_pack_rpt w_saltillo_material_to_pack_rpt

type variables
String	isOrigSQL
end variables

on w_saltillo_material_to_pack_rpt.create
call super::create
end on

on w_saltillo_material_to_pack_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;Long	llRowPos,	&
		llRowCount
Decimal	ldAvailQty
		
String	lsSKU,	&
			lsSKUHold,	&
			lsWarehouse


SetPointer(Hourglass!)
w_main.SetMicrohelp('Retrieving Report data...')

dw_report.Setredraw(False)

If dw_report.Retrieve(gs_Project) > 0 Then
	im_menu.m_file.m_print.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If

//Retrieve the total available in Normal for each SKU
llRowCOunt = dw_report.RowCount()
For llRowPos = 1 to llRowCount
	
	lsSku = dw_report.GetITemString(llRowPos,'SKU')
	lsWarehouse = dw_report.GetITemString(llRowPos,'wh_code')
	
	If lsSKU <> lsSKUHold Then
		
		Select Sum(avail_qty) into :ldAvailQty
		From	Content
		Where project_id = :gs_project and wh_code = :lsWarehouse and sku = :lsSku and Inventory_Type = "N"
		Using SQLCA;
		
		dw_report.SetITem(llRowPos,'c_avail_qty',ldAvailQty)
		
	End If /*Sku changed */
	
	lsSKUHold = lsSKU
	
Next /*Report Row */

//Filter to only show where we need raw
dw_report.SetFilter("c_detail_raw_req > 0")
dw_Report.Filter()

dw_report.Setredraw(True)

SetPointer(Arrow!)
w_main.SetMicrohelp('Ready')
end event

event resize;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-40)
end event

type dw_select from w_std_report`dw_select within w_saltillo_material_to_pack_rpt
boolean visible = false
integer x = 3442
integer y = 8
integer width = 187
integer height = 96
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_saltillo_material_to_pack_rpt
integer x = 3269
integer y = 0
end type

type dw_report from w_std_report`dw_report within w_saltillo_material_to_pack_rpt
integer x = 5
integer y = 20
integer width = 3474
integer height = 1788
string dataobject = "d_saltillo_materials_to_pack_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

