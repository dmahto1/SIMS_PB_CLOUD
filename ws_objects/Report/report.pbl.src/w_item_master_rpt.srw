$PBExportHeader$w_item_master_rpt.srw
$PBExportComments$Window used for displaying Item Master replenishment information
forward
global type w_item_master_rpt from w_std_report
end type
end forward

global type w_item_master_rpt from w_std_report
integer width = 3666
integer height = 2196
string title = "Item Master Report"
end type
global w_item_master_rpt w_item_master_rpt

type variables
string is_origsql
string       is_warehouse_code
string      is_warehouse_name
boolean ib_first_time
datastore ids_find_warehouse

boolean ib_update_from_first = true
boolean ib_update_to_first = true
end variables

on w_item_master_rpt.create
call super::create
end on

on w_item_master_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
// 05/09 - PCONKL - Custom DW for Philips, 12/12 - added TPV, 6/13 - added FUNAI. TAM 2015/03 - Added Gibson
//3-FEB-2019 :Madhu S28945 Added PHILIPSCLS
If gs_project = 'PHILIPS-SG' or gs_project = 'PHILIPSCLS' or gs_project = 'TPV'  or gs_project = 'FUNAI'  or gs_project = 'GIBSON' OR gs_project = 'PHILIPS-DA' Then // Dinesh - 19/11/2020-S51443 Philips-da
	dw_report.dataobject = 'd_philips_item_master_rpt'
	dw_report.SetTransObject(SQLCA)
End If

is_OrigSql = dw_report.getsqlselect()




end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-250)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

ib_update_from_first = true
ib_update_to_first = true


end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc
String	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('group', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve()
lsFilter = "project_id = '" + gs_project + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()

end event

event ue_retrieve;String	lsNewSql,	&
			lsWhere,		&
			lsSku,		&
			lsSupplier,	&
			lsCompText,	&
			lsPackText,	&
			lsFilter
			
long 	llRowCount, &
		llCompCount,	&
		llRowPos,		&
		llDetailPos,	&
		llDetailCount

Boolean lb_where,	&
			lbPack,	&
			lbComp

DataStore	ldsComponent

dw_select.accepttext()
lb_where = FALSE

If dw_select.AcceptText() = -1 Then Return


SetPointer(HourGlass!)
dw_report.SetRedraw(False)
dw_report.Reset()

//Always tackon Project
LsWhere = " And Item_Master.project_id = '" + gs_project + "'"

//TAckon Group if present
If Not isnull(dw_select.GetItemString(1,'group')) Then
	lsWhere += " and Grp = '" + dw_select.GetItemString(1,'group') + "'"
	lb_where = TRUE
End If

//TAckon Supplier if present
If Not isnull(dw_select.GetItemString(1,'supp_code')) Then
	lsWhere += " and Item_Master.supp_code = '" + dw_select.GetItemString(1,'supp_code') + "'"
	lb_where = TRUE
End If

//TAckon Description if present
If Not isnull(dw_select.GetItemString(1,'desc')) Then
	lsWhere += " and description like '%" + dw_select.GetItemString(1,'desc') + "%'"
	lb_where = TRUE
End If


// From Last Update Date
If date(dw_select.GetItemDateTime(1,"from_last_update")) > date('01-01-1900') Then
	lsWhere += " and Item_Master.last_update >= '" + string(dw_select.GetItemDateTime(1,"from_last_update"),'mm-dd-yyyy hh:mm') + "' "
	lb_where = TRUE
End If

// To Last Update Date
If date(dw_select.GetItemDateTime(1,"to_last_update")) > date('01-01-1900') Then
	lsWhere += " and Item_Master.last_update <= '" + string(dw_select.GetItemDateTime(1,"to_last_update"),'mm-dd-yyyy hh:mm') + "' "
	lb_where = TRUE
End If

lsNewSql = is_origsql + lsWhere
dw_report.SetSQLSelect(lsNewSQL)

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF	

IF dw_report.Retrieve() > 0 Then
	
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
	
	//Display any component or packaging (09/02 - PCONKL) info if it exists
	ldsComponent = Create Datastore
	ldsComponent.Dataobject = 'd_item_master_rpt_component'
	ldsComponent.Settransobject(SQLCA)
	llCompCount = ldsComponent.Retrieve(gs_project)
	
	If llCompCount > 0 Then /*components orpackaging exist, add to report */
	
		//Process each Report Row
		llDetailCOunt = dw_Report.RowCOunt()
		For llDetailPos = 1 to llDetailCount
			
			lsSku = dw_report.GetITemString(llDetailPos,'Item_master_Sku')
			lsSupplier = dw_report.GetITemString(llDetailPos,'Item_MASter_Supp_code')
		
			//Filter components for current sku
			lsFilter = "Upper(sku_parent) = '" + Upper(lsSKU) + "' and Upper(supp_code_parent) = '" + Upper(lsSupplier) + "'"
			ldsComponent.SetFilter(lsFilter)
			ldsComponent.Filter()
			llRowCount = ldsComponent.RowCount()
		
			If llRowCOunt > 0 Then
			
				lsCompText = '- This item is a component made up of the following Skus: ' 
				lsPackText = ' - This item uses the following SKUs for Packaging: '
				For llRowPos = 1 to llRowCount
					If ldsComponent.GetITemString(llRowPos,'component_type') = 'P' Then /*it's packaging*/
						lsPackText += ldsComponent.GetItemString(llRowPos,'sku_child') + '(' + String(ldsComponent.GetITemNumber(llRowPos,'child_qty')) + '), '
						lbPack = True
					Else /* it's a component */
						lsCompText += ldsComponent.GetItemString(llRowPos,'sku_child') + '(' + String(ldsComponent.GetITemNumber(llRowPos,'child_qty')) + '), '
						lbComp = True
					End If
				Next
			
				If lbComp Then
					lsCompText = left(lsComptext,(len(lscompText) - 2)) /*strip off last comma*/
					dw_report.SetItem(llDetailPos,'Component_text',lsCompText)
				End If
			
				If lbPack Then
					lspackText = left(lsPacktext,(len(lsPackText) - 2)) /*strip off last comma*/
					dw_report.SetItem(llDetailPos,'Package_text',lsPackText)
				End If
			
			End If /*Components or packaging exist for This SKU*/
			
		Next /*Next Report Detail Row */
		
	End If /*Components or packaging exist for This Report*/
	
Else /*no records retrieved */
	
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
	
End If

dw_report.SetRedraw(True)




end event

type dw_select from w_std_report`dw_select within w_item_master_rpt
integer x = 9
integer y = 0
integer width = 3232
integer height = 200
string dataobject = "d_item_master_rpt_srch"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::clicked;call super::clicked;string 	ls_column
//DatawindowChild	ldwc
long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()


CHOOSE CASE ls_column
		
	CASE "from_last_update"
		
		IF ib_update_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("from_last_update")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_update_from_first = FALSE
			
		END IF
		
	CASE "to_last_update"
		
		IF ib_update_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("to_last_update")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_update_to_first = FALSE
			
		END IF
		
			
	
END CHOOSE

end event

type cb_clear from w_std_report`cb_clear within w_item_master_rpt
integer x = 2880
integer y = 4
end type

type dw_report from w_std_report`dw_report within w_item_master_rpt
integer x = 23
integer y = 240
integer width = 3570
integer height = 1712
string dataobject = "d_item_master_rpt"
boolean hscrollbar = true
end type

