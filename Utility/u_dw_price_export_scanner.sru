HA$PBExportHeader$u_dw_price_export_scanner.sru
$PBExportComments$Export Western Digital Scanner - Delivery Order
forward
global type u_dw_price_export_scanner from u_dw_export
end type
end forward

global type u_dw_price_export_scanner from u_dw_export
integer width = 1422
integer height = 800
end type
global u_dw_price_export_scanner u_dw_price_export_scanner

on u_dw_price_export_scanner.create
call super::create
end on

on u_dw_price_export_scanner.destroy
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
		ls_temp = Trim(GetItemString(ll_rownum,'project_id')) + '~t'
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow = ls_temp
		ls_temp = Trim(GetItemString(ll_rownum,'supp_code')) + '~t'
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp
		ls_temp = Trim(GetItemString(ll_rownum,'sku')) + '~t'
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp
		ls_temp = Trim(GetItemString(ll_rownum,'price_class_1')) + '~t'
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp
		ls_temp = string(GetItemDecimal(ll_rownum,'price_1')) + '~t'
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp
		ls_temp = string(GetItemDecimal(ll_rownum,'price_2')) + '~t'
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp
		ls_temp = Trim(GetItemString(ll_rownum,'currency_cd')) + '~t'
		If isnull(ls_temp) then ls_temp = ""
		ls_exportrow += ls_temp
		
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
end event

