HA$PBExportHeader$w_stryker_inventory_ageing_report.srw
$PBExportComments$Stock Movement Report for All SKU's by Date range
forward
global type w_stryker_inventory_ageing_report from w_std_report
end type
end forward

global type w_stryker_inventory_ageing_report from w_std_report
integer width = 5861
integer height = 3032
string title = "Stryker Inventory Ageing Report"
end type
global w_stryker_inventory_ageing_report w_stryker_inventory_ageing_report

type variables
string is_origsql, isCustomer
string is_origsql2, isOrder
long il_long


String	isremit_name,isRemit_addr1, isRemit_addr2,isRemit_addr3, isRemit_Addr4, isRemit_city, isRemit_state, isRemit_zip, isRemit_country


String isDoNo

string isOrigSql


end variables

on w_stryker_inventory_ageing_report.create
call super::create
end on

on w_stryker_inventory_ageing_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() - 50,workspaceHeight()-190)
end event

event ue_postopen;call super::ue_postopen;
datawindowchild ldwc

dw_select.GetChild("inventory_type", ldwc)
ldwc.SetTransObject(sqlca)
ldwc.Retrieve(gs_project)

//ldwc.InsertRow(0)


//This.TriggerEvent('ue_retrieve')

isorigsql = dw_report.getsqlselect()
end event

event ue_retrieve;
string ls_lot_no, ls_po_no, ls_inventory_type


SetPointer(Hourglass!)

//--
// 05/00 PCONKL - tackon any search criteria and retrieve
String	lsWhere,ls_data,ls_con,	lsNewSQL, ls_String, ls_sku
Integer	liRC
boolean lb_where = false


dw_select.AcceptTExt()


////always tackon Project...
//lsWhere  += " and content_summary.Project_id = '" + gs_project + "'"
//

//SKU
ls_sku = dw_select.GetItemString(1,"sku")
if  not isnull(ls_sku) and trim(ls_sku) <> "" then
	ls_sku = "%" + dw_select.GetItemString(1,"sku") + "%"
	lb_where = TRUE
else
	ls_sku = "%"
end if


// Lot Nbr
if  not isnull(dw_select.GetItemString(1,"lot_no")) then
	ls_lot_no = dw_select.GetItemString(1,"lot_no") 
	lb_where = TRUE
else
	ls_lot_no = '%'
end if



//Po_No

ls_string = dw_select.GetItemString(1,"PO_no")
if not isNull(ls_string) then
	ls_po_no = ls_string
	lb_where = TRUE
else
	ls_po_no = '%'

end if




//Inventory Type
if not isnull(dw_select.GetItemString(1,"inventory_type")) then
	ls_inventory_type = dw_select.GetItemString(1,"inventory_type") 
	lb_where = TRUE
else
	ls_inventory_type = '%'
end if


	

long rc
// liRC = This.Retrieve()
rc =  dw_report.Retrieve(ls_sku, ls_lot_no, ls_po_no, ls_inventory_type)
If rc <= 0 Then
//If liRC <= 0 Then
	MessageBox(is_title, "No report records were found matching your search criteria!")	
Else
	dw_report.Setfocus()
	
	dw_report.SetRedraw(True)

	im_menu.m_file.m_print.Enabled = TRUE
	
End If




















end event

event ue_print;
OpenWithParm(w_dw_print_options,dw_report) 


end event

type dw_select from w_std_report`dw_select within w_stryker_inventory_ageing_report
event ue_populate_dropdowns ( )
event ue_process_enter pbm_dwnprocessenter
integer x = 37
integer y = 24
integer width = 3680
integer height = 116
string dataobject = "d_stryker_ageing_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::ue_populate_dropdowns;String	lsCustomer,	&
			lsName, lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry, lsCityStateZip, &
			lsModify, lsrc
Long	llNumber,	&
		llNumDigits,	&
		llAddressRow,	&
		llFindRow
		
datawindowChild	ldwc


// 01/01 PCONKL - Populate the address dropdowns based on the current customer

isOrder = This.GetITemString(1,'order_no')

//Make sure can still find number if leading zeros are missing
llnumber = long(isOrder)
llNumdigits = len(string(llnumber))
if llNumdigits < 6 THEN
	isOrder = fill('0',7 - llNumdigits) + string(llnumber)
END IF

isCustomer = ''
	
Select Cust_Code,Cust_name, address_1, address_2, address_3, address_4, city, state, zip, country
into :isCustomer,:lsName, :lsaddr1, :lsaddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
From Delivery_master
Where invoice_no = :isOrder and
		project_id = :gs_project
Using SQLCA;

If isCustomer > '' Then
	
	lsModify = ''
	llAddressRow = 0
	If NOt isnull(lsName) Then lsModify += "ship_name_t.Text='" + lsName + "' "
	If Not isnull(lsAddr1) Then 
		llAddressRow ++
		lsModify += "ship_address" + string(llAddressRow) + "_t.Text='" + lsaddr1 + "' "
	End If
	If Not isnull(lsAddr2) Then 
		llAddressRow ++
		lsModify += "ship_address" + string(llAddressRow) + "_t.Text='" + lsaddr2 + "' "
	End If
	If Not isnull(lsAddr3) Then 
		llAddressRow ++
		lsModify += "ship_address" + string(llAddressRow) + "_t.Text='" + lsaddr3 + "' "
	End If
	If Not isnull(lsAddr4) Then 
		llAddressRow ++
		lsModify += "ship_address" + string(llAddressRow) + "_t.Text='" + lsaddr4 + "' "
	End If
	If Not isnUll(lsCity) Then lsCityStateZip = lsCity + ', '
	If Not isnUll(lsState) Then lsCityStateZip += lsState + ' '
	If Not isnUll(lsZip) Then lsCityStateZip += lszip
	If Not isnull(lsCityStateZip) Then 
		llAddressRow ++
		lsModify += "ship_address" + string(llAddressRow) + "_t.Text='" + lsCityStateZip + "' "
	End If
	If Not isnull(lsCountry) Then 
		llAddressRow ++
		lsModify += "ship_address" + string(llAddressRow) + "_t.Text='" + lsCountry + "' "
	End If

	lsRC = dw_report.Modify(lsModify)

	This.GetChild('bill_to_name',ldwc)
	ldwc.Retrieve(gs_project,isCustomer)
	
	//If there is a bill to Address, Populate Bill TO Dropdown, otherwise populate with Ship To
	If ldwc.RowCount() > 0 Then
		
		llFindRow = ldwc.Find("upper(address_code) = 'BILL'",1,ldwc.RowCount())
		
		If llFindRow > 0 Then
		
			dw_select.SetItem(1,'bill_to_name','BILL')
		
			Select Address_name, address_1, address_2, address_3, address_4, city, state, zip, country
			Into	:lsName, :lsaddr1, :lsaddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
			From Customer_address
			Where Cust_code = :isCustomer and project_id = 'Genrad' and address_code = 'BILL';
						
		End If
		
		lsModify = ''
		llAddressRow = 0
		If NOt isnull(lsName) Then lsModify += "bill_name_t.Text='" + lsName + "' "
		If Not isnull(lsAddr1) Then 
			llAddressRow ++
			lsModify += "bill_address" + string(llAddressRow) + "_t.Text='" + lsaddr1 + "' "
		End If
		If Not isnull(lsAddr2) Then 
			llAddressRow ++
			lsModify += "bill_address" + string(llAddressRow) + "_t.Text='" + lsaddr2 + "' "
		End If
		If Not isnull(lsAddr3) Then 
			llAddressRow ++
			lsModify += "bill_address" + string(llAddressRow) + "_t.Text='" + lsaddr3 + "' "
		End If
		If Not isnull(lsAddr4) Then 
			llAddressRow ++
			lsModify += "bill_address" + string(llAddressRow) + "_t.Text='" + lsaddr4 + "' "
		End If
		If Not isnUll(lsCity) Then lsCityStateZip = lsCity + ', '
		If Not isnUll(lsState) Then lsCityStateZip += lsState + ' '
		If Not isnUll(lsZip) Then lsCityStateZip += lszip
		If Not isnull(lsCityStateZip) Then 
			llAddressRow ++
			lsModify += "bill_address" + string(llAddressRow) + "_t.Text='" + lsCityStateZip + "' "
		End If
		If Not isnull(lsCountry) Then 
			llAddressRow ++
			lsModify += "bill_address" + string(llAddressRow) + "_t.Text='" + lsCountry + "' "
		End If

		lsRC = dw_report.Modify(lsModify)
	
	End If /*seperate Billing address Found*/
	
Else /*no customer record found for Delivery MAster*/

	This.GetChild('bill_to_name',ldwc)
	ldwc.Reset()
	dw_select.SetItem(1,'bill_to_name','')
	dw_select.SetFocus()
	dw_select.SetColumn('order_no')
	
End If /*Customer exists for Delivery Order Rec*/
end event

event dw_select::ue_process_enter;If This.GetColumnName() <> "remark" Then
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If
end event

event dw_select::itemchanged;String	lsName, lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry, lsCityStateZip, &
			lsModify, lsrc,	lsCode

Long		llAddressRow

Choose Case dwo.name
		
	Case 'order_no' //If order no changes, populate the address dropdowns for the customer that owns this order
		
		//Clear out existing Address
		lsmodify = "ship_name_t.Text = '' "
		lsmodify += " bill_name_t.Text = '' "
		For llAddressRow = 1 to 6
			lsModify += " ship_address" + String(llAddressRow) + "_t.Text = ''"
			lsModify += " bill_address" + String(llAddressRow) + "_t.Text = ''"
		Next
		
		lsRC = dw_report.Modify(lsModify)
		
		This.PostEvent("ue_populate_dropdowns")
		
//	Case 'vat_percentage' /*validate for numerics*/
//		
//		If not isnumber(data) Then
//			Messagebox(is_title,'Vat Percentage must be numeric')
//			Return 1
//		End If
//		
//	Case 'genrad_name'
//		
//		//Retrieve either primary or alternate address
//		If data = 'Primary' Then /*primary address from customer table*/
//		
//			Select Cust_name, address_1, address_2, address_3, address_4, city, state, zip, country
//			Into	:lsName, :lsaddr1, :lsaddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
//			From Customer
//			Where Cust_code = 'Genrad' and project_id = 'Genrad';
//			
//		Else /*get address from customer_address Table */
//			
//			Select Address_name, address_1, address_2, address_3, address_4, city, state, zip, country
//			Into	:lsName, :lsaddr1, :lsaddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
//			From Customer_address
//			Where Cust_code = 'Genrad' and project_id = 'Genrad' and address_code = :data;
//			
//		End If
//
//		//Clear out existing Address
//		lsmodify = "genrad_name_t.Text = '' "
//		For llAddressRow = 1 to 6
//			lsModify += " genrad_address" + String(llAddressRow) + "_t.Text = ''"
//		Next
//		
//		lsRC = dw_report.Modify(lsModify)
//				
//		lsModify = ''
//		llAddressRow = 0
//		If NOt isnull(lsName) Then lsModify += "genrad_name_t.Text='" + lsName + "' "
//		If Not isnull(lsAddr1) Then 
//			llAddressRow ++
//			lsModify += "genrad_address" + string(llAddressRow) + "_t.Text='" + lsaddr1 + "' "
//		End If
//		If Not isnull(lsAddr2) Then 
//			llAddressRow ++
//			lsModify += "genrad_address" + string(llAddressRow) + "_t.Text='" + lsaddr2 + "' "
//		End If
//		If Not isnull(lsAddr3) Then 
//			llAddressRow ++
//			lsModify += "genrad_address" + string(llAddressRow) + "_t.Text='" + lsaddr3 + "' "
//		End If
//		If Not isnull(lsAddr4) Then 
//			llAddressRow ++
//			lsModify += "genrad_address" + string(llAddressRow) + "_t.Text='" + lsaddr4 + "' "
//		End If
//		If Not isnUll(lsCity) Then lsCityStateZip = lsCity + ', '
//		If Not isnUll(lsState) Then lsCityStateZip += lsState + ' '
//		If Not isnUll(lsZip) Then lsCityStateZip += lszip
//		If Not isnull(lsCityStateZip) Then 
//			llAddressRow ++
//			lsModify += "genrad_address" + string(llAddressRow) + "_t.Text='" + lsCityStateZip + "' "
//		End If
//		If Not isnull(lsCountry) Then 
//			llAddressRow ++
//			lsModify += "genrad_address" + string(llAddressRow) + "_t.Text='" + lsCountry + "' "
//		End If
//		
//		lsRC = dw_report.Modify(lsModify)
//		
//	Case 'remit_to_name'
//		
//		If data <> 'Primary' Then /*take from customer_address_table*/
//		
//			Select Address_name, address_1, address_2, address_3, address_4, city, state, zip, country
//			Into	:isRemit_Name, :isRemit_addr1, :isRemit_addr2, :isRemit_addr3, :isRemit_addr4, :isRemit_City, :isRemit_State, :isRemit_Zip, :isRemit_Country
//			From Customer_address
//			Where Cust_code = 'Genrad' and project_id = 'Genrad' and address_code = :data;
//		
//	Else /*Take from Customer Table*/
//		
//		Select Cust_name, address_1, address_2, address_3, address_4, city, state, zip, country
//		Into	:isRemit_Name, :isRemit_addr1, :isRemit_addr2, :isRemit_addr3, :isRemit_addr4, :isRemit_City, :isRemit_State, :isRemit_Zip, :isRemit_Country
//		From Customer
//		Where Cust_code = 'Genrad' and project_id = 'Genrad';
//		
//	End If
//	
//	Case 'bill_to_name'
//		
//		//Retrieve either primary or alternate address
//		If data = 'Primary' Then /*primary address from customer table*/
//		
//			Select Cust_name, address_1, address_2, address_3, address_4, city, state, zip, country
//			Into	:lsName, :lsaddr1, :lsaddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
//			From Customer
//			Where Cust_code = :isCustomer and project_id = 'Genrad';
//			
//		Else /*get address from customer_address Table */
//			
//			Select Address_name, address_1, address_2, address_3, address_4, city, state, zip, country
//			Into	:lsName, :lsaddr1, :lsaddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
//			From Customer_address
//			Where Cust_code = :isCustomer and project_id = 'Genrad' and address_code = :data;
//			
//		End If
//
//		//Clear out existing Address
//		lsmodify = "bill_name_t.Text = '' "
//		For llAddressRow = 1 to 6
//			lsModify += " bill_address" + String(llAddressRow) + "_t.Text = ''"
//		Next
//		
//		lsRC = dw_report.Modify(lsModify)
//		
//		lsModify = ''
//		llAddressRow = 0
//		If NOt isnull(lsName) Then lsModify += "bill_name_t.Text='" + lsName + "' "
//		If Not isnull(lsAddr1) Then 
//			llAddressRow ++
//			lsModify += "bill_address" + string(llAddressRow) + "_t.Text='" + lsaddr1 + "' "
//		End If
//		If Not isnull(lsAddr2) Then 
//			llAddressRow ++
//			lsModify += "bill_address" + string(llAddressRow) + "_t.Text='" + lsaddr2 + "' "
//		End If
//		If Not isnull(lsAddr3) Then 
//			llAddressRow ++
//			lsModify += "bill_address" + string(llAddressRow) + "_t.Text='" + lsaddr3 + "' "
//		End If
//		If Not isnull(lsAddr4) Then 
//			llAddressRow ++
//			lsModify += "bill_address" + string(llAddressRow) + "_t.Text='" + lsaddr4 + "' "
//		End If
//		If Not isnUll(lsCity) Then lsCityStateZip = lsCity + ', '
//		If Not isnUll(lsState) Then lsCityStateZip += lsState + ' '
//		If Not isnUll(lsZip) Then lsCityStateZip += lszip
//		If Not isnull(lsCityStateZip) Then 
//			llAddressRow ++
//			lsModify += "bill_address" + string(llAddressRow) + "_t.Text='" + lsCityStateZip + "' "
//		End If
//		If Not isnull(lsCountry) Then 
//			llAddressRow ++
//			lsModify += "bill_address" + string(llAddressRow) + "_t.Text='" + lsCountry + "' "
//		End If
//		
//		lsRC = dw_report.Modify(lsModify)
//		
//		
//	
		
End Choose
end event

event dw_select::itemerror;Return 1
end event

type cb_clear from w_std_report`cb_clear within w_stryker_inventory_ageing_report
boolean visible = true
integer x = 3799
integer y = 24
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_stryker_inventory_ageing_report
integer x = 18
integer y = 160
integer width = 5755
integer height = 2612
integer taborder = 30
string dataobject = "d_stryker_ageing_report"
boolean hscrollbar = true
end type

