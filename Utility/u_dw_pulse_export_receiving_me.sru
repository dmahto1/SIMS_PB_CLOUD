HA$PBExportHeader$u_dw_pulse_export_receiving_me.sru
forward
global type u_dw_pulse_export_receiving_me from u_dw_export
end type
end forward

global type u_dw_pulse_export_receiving_me from u_dw_export
integer width = 1422
integer height = 800
string dataobject = "d_pulse_export_receiving_me"
end type
global u_dw_pulse_export_receiving_me u_dw_pulse_export_receiving_me

forward prototypes
public function long wf_retrieve ()
end prototypes

public function long wf_retrieve ();
Long	llRowCount
DateTime	ldFrom, ldTo
String	lsWH

//Tackon Complete Date Search Criteria
w_export.dw_search.AcceptText()

If Date(w_export.dw_search.GetItemDateTime(1,"complete_date_from")) > date('01-01-1900') and &
	 Date(w_export.dw_search.GetItemDateTime(1,"complete_date_To")) > date('01-01-1900') Then
	 
Else
	Messagebox('Export', 'Complete Date range is required')
	REturn -1
End If

ldFrom = w_export.dw_search.GetItemDateTime(1,"complete_date_from")
ldTo = w_export.dw_search.GetItemDateTime(1,"complete_date_To")
lsWH = w_export.dw_search.GetItemString(1,"wh_Code")

llRowCount = This.Retrieve(ldFrom, ldTo, lsWH)

//we may have some post retrieve functionality
This.TriggerEvent('ue_post_retrieve')

Return	llRowCount
end function

on u_dw_pulse_export_receiving_me.create
call super::create
end on

on u_dw_pulse_export_receiving_me.destroy
call super::destroy
end on

event constructor;call super::constructor;
//This is a custom Export - we will define how the fields are exported 
//This will bypass the ancestor code in wf_export()



ibCustomExport = True

//Default From/To DAtes

w_export.dw_search.SetITem(1,'complete_date_From',f_get_Date('BEGIN'))
w_export.dw_search.SetITem(1,'complete_date_To',f_get_Date('END'))
w_export.dw_search.SetITem(1,'wh_code','PULSE-LIA')
end event

event ue_custom_export;Long	llRowPos,	&
		llRowCount

String	lsRowData,	&
			lsTemp,	&
			lsUOM,	&
			lsQTY

llRowCount = This.RowCount()

//Write a header record
lsRowData = "Receipt Date~t"
lsRowData += "Plant/ Loc~t"
lsRowData += "Line NO~t"
lsRowData += "Pulse Part Number~t"
lsRowData += "Description of Goods~t"
lsRowData += "Vendor Name~t"
lsRowData += "Purchase Order Nbr~t"
lsRowData += "Invoice Date~t"
lsRowData += "PO Unit Price~t"
lsRowData += "PO QTY~t"
lsRowData += "PO UOM~t"
lsRowData += "No of Carton~t"
lsRowData += "Gross Weight (KG)~t"
lsRowData += "Shipment Tracking Nbr~t"
lsRowData += "Country of Origin~t"
lsRowData += "Stock Due Date~t"

//Write the row
FileWrite(iiFileNo,lsRowDAta)

For llRowPos = 1 to llRowCount
			
	lsRowDAta = ''
	
	If This.GetItemString(llRowPos,'c_export_ind') <> 'Y' Then Continue
	
	//Receive Date
	lsTemp = Trim(String(This.GetItemDateTime(llRowPos,'receive_master_complete_date'),'mm/dd/yyyy'))
	lsRowData += lsTemp + '~t'
			
	//Plant/Loc
	lsTemp = Trim(This.GetItemString(llRowPos,'receive_master_user_field1'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Line ITem
	lsTemp = Trim(String(This.GetItemNumber(llRowPos,'receive_putaway_line_item_no')))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//SKU
	lsTemp = Trim(This.GetItemString(llRowPos,'receive_putaway_SKU'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Description
	lsTemp = Trim(This.GetItemString(llRowPos,'receive_Detail_user_field2'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Vendor
	lsTemp = Trim(This.GetItemString(llRowPos,'supplier_supp_name'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//PO Nbr
	lsTemp = Trim(This.GetItemString(llRowPos,'receive_master_supp_invoice_no'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Invoice Date
	lsTemp = Trim(This.GetItemString(llRowPos,'receive_master_User_Field4'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//PO Unit Price
	lsTemp = Trim(String(This.GetItemNumber(llRowPos,'receive_detail_cost'),'#########.####'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	
	//Purchase Qty/UOM - we are concatonating the qty/uom in  the same field (UF1)
	lsTemp = Trim(This.GetItemString(llRowPos,'receive_Detail_user_field1'))
	
	If Pos(lstemp,'/') > 0 Then
		lsQty = Left(lsTemp,(pos(lstemp,'/') - 1))
		lsUOM = Right(lsTemp,(Len(lsTemp) - (Len(lsQty) + 1)))
		lsRowData += lsQty + '~t' + lsUom + '~t'
	Else /*not present, just send delimiters*/
		lsRowData +=  '~t~t'
	End If
	
	//Number of Cartons
	lsTemp = Trim(String(This.GetItemNumber(llRowPos,'c_carton_count')))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
			
	//Gross Weight
	lsTemp = Trim(String(This.GetItemNumber(llRowPos,'c_gross_Weight'),'#######.#####'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Tracking #
	lsTemp = Trim(This.GetItemString(llRowPos,'receive_master_ship_ref'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//COO
	lsTemp = Trim(This.GetItemString(llRowPos,'receive_putaway_country_of_origin'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Stock Due Date
	lsTemp = Trim(This.GetItemString(llRowPos,'stockduedate'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
		
	//Write the row
	FileWrite(iiFileNo,lsRowDAta)
	ilExportCOunt ++
	

Next


end event

