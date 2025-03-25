$PBExportHeader$u_dw_comcast_ups_log.sru
$PBExportComments$Export Pulse Transportation Packing List
forward
global type u_dw_comcast_ups_log from u_dw_export
end type
end forward

global type u_dw_comcast_ups_log from u_dw_export
integer width = 3854
integer height = 800
string dataobject = "d_comcast_export_ups_log"
end type
global u_dw_comcast_ups_log u_dw_comcast_ups_log

forward prototypes
public function long wf_retrieve ()
end prototypes

public function long wf_retrieve ();
Long	llRowCount
DateTime	ldFrom, ldTo

//Tackon create Date Search Criteria
w_export.dw_search.AcceptText()

If Date(w_export.dw_search.GetItemDateTime(1,"create_date_from")) > date('01-01-1900') and &
	 Date(w_export.dw_search.GetItemDateTime(1,"create_date_To")) > date('01-01-1900') Then
	 
Else
	Messagebox('Export', 'Create Date range is required')
	REturn -1
End If

ldFrom = w_export.dw_search.GetItemDateTime(1,"create_date_from")
ldTo = w_export.dw_search.GetItemDateTime(1,"create_date_To")

llRowCount = This.Retrieve(gs_project,ldFrom, ldTo)

//we may have some post retrieve functionality
This.TriggerEvent('ue_post_retrieve')

Return	llRowCount
end function

on u_dw_comcast_ups_log.create
call super::create
end on

on u_dw_comcast_ups_log.destroy
call super::destroy
end on

event constructor;call super::constructor;
//This is a custom Export - we will define how the fields are exported 
//This will bypass the ancestor code in wf_export()



ibCustomExport = True

//Default From/To DAtes

w_export.dw_search.SetITem(1,'create_date_From',f_get_Date('BEGIN'))
w_export.dw_search.SetITem(1,'create_date_To',f_get_Date('END'))


end event

event ue_custom_export;Long	llRowPos,	&
		llRowCount

String	lsRowData, lsTemp, lsUOM, lsQTY

llRowCount = This.RowCount()

//Write a header record
lsRowData = "SIMS DO No~t"
lsRowData += "Status Desc~t"
lsRowData += "Address Class Desc~t"
lsRowData += "Customer~t"
lsRowData += "Orig Addr Line~t"
lsRowData += "Orig Cityr~t"
lsRowData += "State~t"
lsRowData += "Zip~t"
lsRowData += "Retn Addr Line~t"
lsRowData += "Retn City~t"
lsRowData += "State~t"
lsRowData += "Zip~t"
lsRowData += "Ext~t"
lsRowData += "Create Date~t"

//Write the row
FileWrite(iiFileNo,lsRowDAta)

For llRowPos = 1 to llRowCount
			
	lsRowDAta = ''
	
	If This.GetItemString(llRowPos,'c_export_ind') <> 'Y' Then Continue
	
	//SIMS DO No
	lsTemp = Trim(This.GetItemString(llRowPos,'do_no'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Status Desc
	lsTemp = Trim(This.GetItemString(llRowPos,'status_desc'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
		
	//Address Class Desc
	lsTemp = Trim(This.GetItemString(llRowPos,'address_class_desc'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Customer
	lsTemp = Trim(This.GetItemString(llRowPos,'cust_name'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Original Address Line
	lsTemp = Trim(This.GetItemString(llRowPos,'orig_addr_line'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If 
		
	//Original City
	lsTemp = Trim(This.GetItemString(llRowPos,'orig_city'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Original State
	lsTemp = Trim(This.GetItemString(llRowPos,'orig_state'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Original Zip
	lsTemp = Trim(This.GetItemString(llRowPos,'orig_zip'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Returned address Line
	lsTemp = Trim(This.GetItemString(llRowPos,'retn_addr_line'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Returned city
	lsTemp = Trim(This.GetItemString(llRowPos,'retn_city'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
		
	//Returned State
	lsTemp = Trim(This.GetItemString(llRowPos,'retn_state'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Returned Zip
	lsTemp = Trim(This.GetItemString(llRowPos,'retn_zip'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Returned zip extension
	lsTemp = Trim(This.GetItemString(llRowPos,'retn_ext'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Create Date
	lsTemp = String(This.GetItemDateTime(llRowPos,'create_time'),'MM/DD/YYYY')
	If NOt isnull(lsTemp) and lsTemp <> '12/31/2999' Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	
	//Write the row
	FileWrite(iiFileNo,lsRowDAta)
	ilExportCOunt ++

Next


end event

