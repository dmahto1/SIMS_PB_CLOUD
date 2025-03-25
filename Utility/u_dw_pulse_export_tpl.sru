HA$PBExportHeader$u_dw_pulse_export_tpl.sru
$PBExportComments$Export Pulse Transportation Packing List
forward
global type u_dw_pulse_export_tpl from u_dw_export
end type
end forward

global type u_dw_pulse_export_tpl from u_dw_export
integer width = 1422
integer height = 800
string dataobject = "d_pulse_export_tpl"
end type
global u_dw_pulse_export_tpl u_dw_pulse_export_tpl

forward prototypes
public function long wf_retrieve ()
end prototypes

public function long wf_retrieve ();
Long	llRowCount
DateTime	ldFrom, ldTo

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

llRowCount = This.Retrieve(ldFrom, ldTo)

//we may have some post retrieve functionality
This.TriggerEvent('ue_post_retrieve')

Return	llRowCount
end function

on u_dw_pulse_export_tpl.create
call super::create
end on

on u_dw_pulse_export_tpl.destroy
call super::destroy
end on

event constructor;call super::constructor;
//This is a custom Export - we will define how the fields are exported 
//This will bypass the ancestor code in wf_export()



ibCustomExport = True

//Default From/To DAtes

w_export.dw_search.Modify("complete_date_From_t.Text='Order Date      From:'") /* 03/03 - PCONkl - change literal to Order date instead of Complete*/
w_export.dw_search.SetITem(1,'complete_date_From',f_get_Date('BEGIN'))
w_export.dw_search.SetITem(1,'complete_date_To',f_get_Date('END'))

w_export.dw_search.Modify('wh_code.visible=false wh_code_t.visible=false')
end event

event ue_custom_export;Long	llRowPos,	&
		llRowCount

String	lsRowData, lsTemp, lsUOM, lsQTY

llRowCount = This.RowCount()

//Write a header record
lsRowData = "SIMS Order Nbr~t"
lsRowData += "Priority~t"
lsRowData += "Recv Date~t"
lsRowData += "Plant/Loc~t"
lsRowData += "Pulse Part Number~t"
lsRowData += "Description of Goods~t"
lsRowData += "Vendor Name~t"
lsRowData += "Purchase Order Nbr~t"
lsRowData += "Invoice Date~t"
lsRowData += "Invoice/DO Number~t"
lsRowData += "IMI ID#~t"
lsRowData += "Quantity~t"
lsRowData += "UOM~t"
lsRowData += "No of Carton~t"
lsRowData += "Pallet #~t"
lsRowData += "Carton # From~t"
lsRowData += "Carton # To~t"
lsRowData += "Gross Weight (KG)~t"
lsRowData += "Shipment Tracking Nbr~t"
lsRowData += "Country of Origin~t"
lsRowData += "Remark~t"
lsRowData += "Expiration Date~t"
lsRowData += "RPO Line~t"
lsRowData += "RPO Number~t"
lsRowData += "CC3~t"

//Write the row
FileWrite(iiFileNo,lsRowDAta)

For llRowPos = 1 to llRowCount
			
	lsRowDAta = ''
	
	If This.GetItemString(llRowPos,'c_export_ind') <> 'Y' Then Continue
	
	//SIMS Order Nbr
	lsTemp = Trim(This.GetItemString(llRowPos,'invoice_no'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Priority - Filler
	lsRowData +=  '~t'
	
	//Recv Date - Filler
	lsRowData +=  '~t'
			
	//Plant/Loc
	lsTemp = Trim(This.GetItemString(llRowPos,'Cust_Code'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
		
	//SKU
	lsTemp = Trim(This.GetItemString(llRowPos,'SKU'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Description - Filler
	lsRowData +=  '~t'
	
	//Vendor - Filler
	lsRowData +=  '~t'
	
	//PO Nbr - Filler
	lsRowData +=  '~t'
	
	//Invoice Date - Filler
	lsRowData +=  '~t'
	
	//Invoice/DO # - Filler
	lsRowData +=  '~t'
	
	//Receiving Ref #
	lsTemp = Trim(This.GetItemString(llRowPos,'lot_no'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Qty
	lsTemp = String(This.GetItemNumber(llRowPos,'c_Total_qty'))
	lsRowData += lsTemp + '~t' 
	
	//UOM
	lsTemp = Trim(This.GetItemString(llRowPos,'uom'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If 
		
	//Number of Cartons
	lsTemp = Trim(String(This.GetItemNumber(llRowPos,'c_carton_count')))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Pallet # (Picking UF 1)
	lsTemp = Trim(This.GetItemString(llRowPos,'delivery_Picking_User_Field1'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//From Carton
	lsTemp = Trim(This.GetItemString(llRowPos,'c_from_carton'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//To Carton
	lsTemp = Trim(This.GetItemString(llRowPos,'c_to_carton'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Gross Weight 
	lsTemp = String(This.GetItemNumber(llRowPos,'c_Weight'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
		
	//Tracking # - Filler
	lsRowData += '~t'
	
	//COO
	lsTemp = Trim(This.GetItemString(llRowPos,'country_of_origin'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Remarks
	lsTemp = Trim(This.GetItemString(llRowPos,'remark'))
	If NOt isnull(lsTemp) Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	//Expiration Date
	lsTemp = String(This.GetItemDateTime(llRowPos,'expiration_date'),'MM/DD/YYYY')
	If NOt isnull(lsTemp) and lsTemp <> '12/31/2999' Then
		lsRowData += lsTemp + '~t'
	Else
		lsRowData += '~t'
	End If
	
	// 08/03 - PCONKL - RPO Line/Number Concatonated together in User FIeld 2
	lsTemp = Trim(This.GetItemString(llRowPos,'delivery_Detail_user_field2'))
	If isnull(lsTemp) or lsTemp = '' Then
		lsRowData += '~t~t' /*2 empty columns on export*/
	Else
		If Pos(lsTemp,'/') = 0 or Pos(lsTemp,'/') = 1 Then 
			lsRowData += '~t' + lsTemp + '~t' /* only one field present, put in RPO Nbr Field*/
		Else
			lsRowData += Right(lsTemp,(len(lsTemp) - Pos(lsTemp,'/'))) + '~t' + left(lsTemp,(Pos(lsTemp,'/') - 1)) + '~t' /*RPO Line + RPO Nbr*/
		End If
	End If
	
	//MEA 08/10 - Added CC3 
	lsTemp = Trim(This.GetItemString(llRowPos,'CC3'))
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

