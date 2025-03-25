$PBExportHeader$u_dw_item_export_scanner.sru
$PBExportComments$Export Western Digital Scanner - Delivery Order
forward
global type u_dw_item_export_scanner from u_dw_export
end type
end forward

global type u_dw_item_export_scanner from u_dw_export
integer width = 1422
integer height = 800
end type
global u_dw_item_export_scanner u_dw_item_export_scanner

on u_dw_item_export_scanner.create
call super::create
end on

on u_dw_item_export_scanner.destroy
call super::destroy
end on

event constructor;call super::constructor;
//This is a custom Export - we will define how the fields are exported (fixed length)
//This will bypass the ancestor code in wf_export()

ibCustomExport = True
end event

event ue_custom_export;call super::ue_custom_export;Long	ll_rownum, ll_numrows
string ls_exportrow, ls_temp

// Get the number of rows.
ll_numrows = rowcount()

// Loop through the rows.
For ll_rownum = 1 to ll_numrows
	
	If Trim(GetItemString(ll_rownum,'c_export_ind')) = "Y" then
	
		// Reset the row data
		ls_exportrow = ""
		
		// Build the export record.
	//	ls_temp = Trim(GetItemString(ll_rownum,'project_id'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow = ls_temp
		ls_temp = Trim(GetItemString(ll_rownum,'sku'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'supp_code'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'Alternate_SKU'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
	//	ls_temp = string(GetItemNumber(ll_rownum,'owner_id'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemString(ll_rownum,'Description'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemString(ll_rownum,'Country_of_Origin_Default'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemDecimal(ll_rownum,'Std_Cost'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'HS_Code'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'GRP'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
	//	ls_temp = string(GetItemDecimal(ll_rownum,'Std_Cost_Old'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = string(GetItemDecimal(ll_rownum,'Avg_Cost'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'UOM_1'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Length_1'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Width_1'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Height_1'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Weight_1'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'UOM_2'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Length_2'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Width_2'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Height_2'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Weight_2'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Qty_2'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'UOM_3'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Length_3'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Width_3'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Height_3'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Weight_3'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Qty_3'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'UOM_4'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Length_4'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Width_4'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Height_4'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Weight_4'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Qty_4'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'Serialized_Ind'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'Lot_Controlled_Ind'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'PO_Controlled_Ind'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'PO_NO2_Controlled_Ind'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'expiration_controlled_ind'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'container_tracking_ind'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Part_UPC_Code'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'QA_Check_Ind'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field1'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field2'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field3'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field4'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field5'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field6'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field7'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field8'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field9'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field10'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field11'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field12'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field13'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field14'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field15'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field16'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field17'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field18'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field19'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'User_Field20'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
	//	ls_temp = Trim(GetItemString(ll_rownum,'L_Type'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = Trim(GetItemString(ll_rownum,'L_Code'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'Tax_Code'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = String(GetItemNumber(ll_rownum,'Shelf_Life'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = String(GetItemNumber(ll_rownum,'CC_Freq'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'CC_Trigger_Qty'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'cc_group_code'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'cc_class_code'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
	//	ls_temp = Trim(GetItemString(ll_rownum,'Last_User'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = string(GetItemDateTime(ll_rownum,'Last_Update'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = string(GetItemNumber(ll_rownum,'Packaged_Weight'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = string(GetItemNumber(ll_rownum,'Unpackaged_Weight'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = string(GetItemDecimal(ll_rownum,'Alternate_Price'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = Trim(GetItemString(ll_rownum,'Component_Ind'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = Trim(GetItemString(ll_rownum,'Standard_of_Measure'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = Trim(GetItemString(ll_rownum,'Item_Delete_Ind'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = string(GetItemDateTime(ll_rownum,'Last_Cycle_Cnt_Date'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'Hazard_Text_Cd'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'Hazard_Cd'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'Hazard_Class'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = string(GetItemNumber(ll_rownum,'Flash_Point'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'Freight_Class'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'inventory_class'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
		ls_temp = Trim(GetItemString(ll_rownum,'storage_code'))
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp + '~t'
	//	ls_temp = Trim(GetItemString(ll_rownum,'Expiration_Tracking_Type'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = Trim(GetItemString(ll_rownum,'component_type'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = string(GetItemDateTime(ll_rownum,'marl_change_date'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = string(GetItemDateTime(ll_rownum,'quality_hold_change_date'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = trim(GetItemString(ll_rownum,'last_cc_no'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = Trim(GetItemString(ll_rownum,'Interface_Upd_Req_Ind'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = Trim(GetItemString(ll_rownum,'DWG_UPLOAD'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
	//	ls_temp = string(GetItemDateTime(ll_rownum,'DWG_UPLOAD_TIMESTAMP'))
	//	If isnull(ls_temp) then ls_temp = ""
	//	ls_exportrow += ls_temp + '~t'
		
		// Add the export record to the export string.
		FileWrite(iiFileNo,ls_exportrow)
		
		// Incriment the export count.
		ilExportCOunt ++
		
		// Update microhelp.
		w_main.setmicrohelp("Exporting " + string(ll_rownum) + " of " + string(ll_numrows) + " total records.")
	End If

// Process next selected row.
Next
		
// Update microhelp.
w_main.setmicrohelp("ready...")


end event

event clicked;call super::clicked;if keydown(KeyControl!) then
	selectrow(row, true)
Else
	selectrow(0, false)
	selectrow(row, true)
End If

//messagebox("", dataobject)
end event

