HA$PBExportHeader$w_storage_report.srw
$PBExportComments$Powerwave Commercial Invoice Report
forward
global type w_storage_report from w_std_report
end type
end forward

global type w_storage_report from w_std_report
integer width = 3653
integer height = 2936
string title = "Warehouse Storage Receipt"
end type
global w_storage_report w_storage_report

type variables
string is_origsql, isCustomer
string is_origsql2, isOrder
long il_long

Boolean	ibIsustomerHCL
String	isremit_name,isRemit_addr1, isRemit_addr2,isRemit_addr3, isRemit_Addr4, isRemit_city, isRemit_state, isRemit_zip, isRemit_country

DataStore	idsPick, idsBillToAddress, idsNotes, idsImporterAddress, idsDrives
String isDoNo
end variables

forward prototypes
public function str_parms uf_determine_sku (ref str_parms astr_parms)
end prototypes

public function str_parms uf_determine_sku (ref str_parms astr_parms);
String		lsSKU, lsCOO, lsSerial
long			llFind

lsSKU = ""
lsCOO = ""
lsSerial = astr_parms.String_arg[1]

If Left(lsSerial,1) = 'P' Then /*Hitachi*/

	lsSKU = "07002134" /*Hiitachi 1 TB drive*/
	lsCOO = "THA"
	
ElseIF isNumber(Left(lsSerial,1)) Then /*Currently Seagate, may need to narrow nown at some point*/
	
	//First char determines COO
	Choose Case Left(lsSerial,1)
			
		Case '3' /*Singapore*/
			lsCOO = "SG"
		Case '5' /*China*/
			lsCOO = "CN"
		Case '4', '9' /* Thailand */
			lsCOO = "THA"
			
	End Choose
	
	//SKU determined by 2nd and 3rd Characters - Seagate families are currently loaded in Lookup table as "SEAGATE-XX" where XX is 2nd and 3rd characters (drive family)
	llFind = idsDrives.Find("Code_ID = 'SEAGATE-" + Upper(Mid(lsSerial,2,2)) + "'",1,idsDrives.RowCount())
	If llFind > 0 Then
		lsSKU = idsDrives.GetITemString(llFind,'code_descript')
	End If
	
//	Choose Case Mid(lsSerial,2,2)
//			
//		Case "QD" /* 750 GB */
//			lsSKU = "900859"
//		Case "QJ" /* 1 TB*/
//			lsSKU = "07002818"
//			
//	End Choose

ENd If


//Return the generic SKU if not found?
If lsSKU = "" Then lsSKU = "07013415"


astr_parms.String_arg[1] = lsSKU
astr_parms.String_Arg[2] = lsCOO

REturn astr_parms
end function

on w_storage_report.create
call super::create
end on

on w_storage_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-30)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
//
end event

event ue_postopen;call super::ue_postopen;
//We can only print based on DO_NO - User must have valid order open to pass DO_NO in from w_ro
If isVAlid(w_ro) Then
	if w_ro.idw_main.RowCOunt() > 0 Then
		isDoNo = w_ro.idw_main.GetITemString(1,'ro_no')
	End If
End If

If isNUll(isDONO) or  isDoNO = '' Then
	Messagebox('Storage Report','You must have an order retrieved in the Inbound Order Window~rbefore you can print the Report!')
	Return
End If


This.TriggerEvent('ue_retrieve')

end event

event ue_retrieve;
string ls_ro_no	

ls_ro_no = w_ro.idw_main.GetItemString(1, "ro_no")

SetPointer(Arrow!)
If dw_report.Retrieve(ls_ro_no) > 0 Then
	im_menu.m_file.m_print.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If

dw_report.SetRedraw(True)




end event

type dw_select from w_std_report`dw_select within w_storage_report
event ue_populate_dropdowns ( )
event ue_process_enter pbm_dwnprocessenter
boolean visible = false
integer x = 3525
integer y = 20
integer width = 78
integer height = 152
string dataobject = "d_linksys_invoice_srch"
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

type cb_clear from w_std_report`cb_clear within w_storage_report
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_storage_report
integer x = 32
integer y = 12
integer width = 3483
integer height = 2728
integer taborder = 30
string dataobject = "d_storage_report"
boolean hscrollbar = true
end type

