$PBExportHeader$u_dw_wd_export_scanner_ro.sru
$PBExportComments$Export Western Digital Scanner - Receive Order
forward
global type u_dw_wd_export_scanner_ro from u_dw_export
end type
end forward

global type u_dw_wd_export_scanner_ro from u_dw_export
integer width = 1422
integer height = 800
string dataobject = "d_wd_export_scanner_ro"
end type
global u_dw_wd_export_scanner_ro u_dw_wd_export_scanner_ro

on u_dw_wd_export_scanner_ro.create
end on

on u_dw_wd_export_scanner_ro.destroy
end on

event constructor;call super::constructor;
//This is a custom Export - we will define how the fields are exported (fixed length)
//This will bypass the ancestor code in wf_export()

ibCustomExport = True
end event

event ue_custom_export;call super::ue_custom_export;Long	llRowPos,	&
		llRowCount

String	lsRowData,	&
			lsTemp

llRowCount = This.RowCount()

For llRowPos = 1 to llRowCount
			
	lsRowDAta = ''
	
	If This.GetItemString(llRowPos,'c_export_ind') = 'Y' Then /* Check to see if row is selected - Added by Guido 3/05/02 */			
	
	lsTemp = Trim(Left(This.GetItemString(llRowPos,'supp_invoice_no'),30))
	lstemp = Lstemp + Space(30 - Len(lsTemp)) /*pad Order Number to 30 char*/
	lsRowData += lsTemp + '~t'
			
	lsTemp = Trim(Left(This.GetItemString(llRowPos,'ro_no'),16))
	lstemp = Lstemp + Space(16 - Len(lsTemp)) /*pad ro no to 16 char*/
	lsRowData += lsTemp + '~t'
			
	lsTemp = Trim(Left(This.GetItemString(llRowPos,'sku'),50))
	lstemp = Lstemp + Space(50 - Len(lsTemp)) /*pad sku to 50 char*/
	lsRowData += lsTemp + '~t'
			
	lsTemp = string(This.GetItemNumber(llRowPos,'req_qty'),'0000000') /*pad qty to 7 char*/
	lsRowData += lsTemp + '~t'
		
	lsTemp = string(This.GetItemDateTime(llRowPos,'ord_date'),'mmddyyyy') /*format date*/
	lsRowData += lsTemp + '~t'
			
	lsTemp = Trim(Left(This.GetItemString(llRowPos,'user_field1'),1))
	If isNull(lsTemp) Then lsTemp = ' ' 
	//lstemp = Lstemp + Space(1 - Len(lsTemp)) /*user field 1 to 1 char*/
	lsRowData += lsTemp
	
	//Write the row
	FileWrite(iiFileNo,lsRowDAta)
	ilExportCOunt ++
	
	End If		

Next


end event

