HA$PBExportHeader$w_ams_cmr_report.srw
$PBExportComments$AMS Multi User CMR Report
forward
global type w_ams_cmr_report from w_std_report
end type
end forward

global type w_ams_cmr_report from w_std_report
integer width = 3653
integer height = 2356
string title = "AMS CMR Report"
end type
global w_ams_cmr_report w_ams_cmr_report

type variables
string is_origsql, isCustomer
string is_origsql2, isOrder
long il_long


String	isremit_name,isRemit_addr1, isRemit_addr2,isRemit_addr3, isRemit_Addr4, isRemit_city, isRemit_state, isRemit_zip, isRemit_country


String isDoNo
end variables

on w_ams_cmr_report.create
call super::create
end on

on w_ams_cmr_report.destroy
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
//We can only print based on DO_NO - User must have valid order open to pass DO_NO in from w_DO
If isVAlid(w_do) Then
	if w_do.idw_main.RowCOunt() > 0 Then
		isDoNo = w_do.idw_main.GetITemString(1,'do_no')
	End If
End If

If isNUll(isDONO) or  isDoNO = '' Then
	Messagebox('Labels','You must have an order retrieved in the Delivery Order Window~rbefore you can print the CMR Report!')
	Return
End If

//Pack list must be generated
If w_do.idw_pick.RowCount() = 0 Then
	Messagebox('Labels','You must generate the Pick List before you can print the CMR Report!')
	Return
End If

This.TriggerEvent('ue_retrieve')

end event

event ue_retrieve;Long	lLRowCount, llRowPos, llNewRow, llWarehouseRow, llBoxCount, llFindRow
String	lsWarehouse, lsDONO, lsCarrier, lsCityZip
String	lsCarrierNAme, lsCarrierAddr1, lsCarrierAddr2, lsCarrierCity, lsCarrierZip, lsCarrierCountry, lsCountryName, lsFind, lsCol

Int	liRowsPerPAge, liEmptyRows, liMod, liColumnPos
Decimal	ldTotalWeight
DataStore	ldsLookup

im_menu.m_file.m_print.Enabled = False

//Number of rows per page - we will want to insert enough rows on the last page so the sumamry is at the bottom
liRowsPerPage = 19


lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')

//Get the Warehouse Address from global datastore
llWarehouseRow = g.ids_project_warehouse.Find("upper(wh_code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())


//Get The Carrier Address
lsCarrier = w_do.idw_Main.GetITemString(1,'carrier')

Select Carrier_Name, Address_1, Address_2, Zip, City, iso_Country_cd
into :lsCarrierNAme, :lsCarrierAddr1, :lsCarrierAddr2, :lsCarrierZip, :lsCarrierCity, :lsCarrierCountry
From Carrier_master
Where Project_id = :gs_project and carrier_Code = :lscarrier;

//Get out if Carrier Address missing
If lsCarrierNAme > "" and  lsCarrierAddr1 > "" and lscarrierCity > "" and lsCarrierZip > "" and lsCarrierCountry > "" Then
Else
	Messagebox("CMR Report","Carrier Address information is missing.~r~rReport can not be printed until this information is available on the Carrier Master.",StopSign!)
	Return
End If


//Get the Lookup table values...
ldsLookup = Create Datastore
ldsLookup.dataobject = 'dddw_lookup'
ldsLookup.SetTransObject(SQLCA)
ldsLookup.Retrieve(gs_project,'CMR')

dw_report.reset()
dw_report.SetRedraw(False)

lLRowCount = w_do.idw_detail.RowCount()

//Get the total Weight as Sum of Detail UF3
ldTotalWeight = 0
For llRowPOs = 1 to llRowCount
	ldtotalWeight += Dec(w_do.idw_detail.GetITemString(llRowPos,'User_field3'))
Next


//Insert 1 blank line to drop the first detail line down
llNewRow = dw_report.InsertRow(0)

	//Ship From Name based on Supplier Code (first row only)
	//17-Nov-2015 :Madhu- Replaced "Menlo WorldWide" by "XPO Logistics"
	Choose Case Upper(w_do.idw_Detail.GetITemString(1,'supp_Code'))
			
		Case 'AMD'
			dw_report.SetITem(llNewRow,'ship_from_name','Amdiss C/O XPO Logistics')
		Case 'SPANSION'
			dw_report.SetITem(llNewRow,'ship_from_name','Spansion C/O XPO Logistics')
		Case 'LAM'
			dw_report.SetITem(llNewRow,'ship_from_name','Lam C/O XPO Logistics')
		Case 'BLUECOAT'
			dw_report.SetITem(llNewRow,'ship_from_name','Blue Coat C/O XPO Logistics')
		Case Else
			dw_report.SetITem(llNewRow,'ship_from_name','C/O XPO Logistics')
	End Choose
	
	If llWarehouseRow > 0 Then
		
		dw_report.SetITem(llNewRow,'ship_from_addr1',g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
		dw_report.SetITem(llNewRow,'ship_from_city',g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
		dw_report.SetITem(llNewRow,'ship_from_zip',g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
		dw_report.SetITem(llNewRow,'ship_from_tel',g.ids_project_warehouse.GetITemString(llWarehouseRow,'tel'))
		dw_report.SetITem(llNewRow,'ship_from_fax',g.ids_project_warehouse.GetITemString(llWarehouseRow,'fax'))
				
	End If
	
	//Ship To Address
	dw_report.SetITem(llNewRow,'ship_to_name',w_do.idw_Main.GetItemString(1,'cust_name'))
	dw_report.SetITem(llNewRow,'ship_to_addr1',w_do.idw_Main.GetItemString(1,'address_1'))
	dw_report.SetITem(llNewRow,'ship_to_addr2',w_do.idw_Main.GetItemString(1,'address_2'))
	dw_report.SetITem(llNewRow,'ship_to_city',w_do.idw_Main.GetItemString(1,'city'))
	dw_report.SetITem(llNewRow,'ship_to_zip',w_do.idw_Main.GetItemString(1,'zip'))
	
	//Convert Country Code to Country Name if present
	lsCountryName = f_get_country_name(w_do.idw_Main.GetItemString(1,'Country'))
	If lsCountryName > "" Then
		dw_report.SetITem(llNewRow,'ship_to_Country',lsCountryName)
	Else
		dw_report.SetITem(llNewRow,'ship_to_Country',w_do.idw_Main.GetItemString(1,'Country'))
	End If
	
	//Carrier
	dw_report.SetITem(llNewRow,'Carrier_name',lsCarrierName)
	dw_report.SetITem(llNewRow,'Carrier_addr1',lsCarrierAddr1)
	dw_report.SetITem(llNewRow,'Carrier_addr2',lsCarrierAddr2)
	dw_report.SetITem(llNewRow,'Carrier_City',lsCarrierCity)
	dw_report.SetITem(llNewRow,'Carrier_Zip',lsCarrierZip)
	
	lsCountryName = f_get_country_name(lsCarrierCountry)
	If lsCountryName > "" Then
		dw_report.SetITem(llNewRow,'Carrier_Country',lsCountryName)
	Else
		dw_report.SetITem(llNewRow,'Carrier_Country',lsCarrierCountry)
	End If

	llFindRow = ldsLookup.Find("Code_ID = 'CMR.Section4.1'",1,ldsLookup.RowCount())
	If llFindRow > 0 Then
		dw_report.SetITem(llNewRow,'lookup_41',ldsLookup.GetITEmString(llFindRow,'code_descript'))
	End If
	
	// 10/07 - PCONKL - Add Customs Doc if UF11 = 'T'
	If w_do.idw_Main.GetITemString(1,'user_Field11') = 'T' Then
		dw_report.SetITem(llNewRow,'customs_doc',"T-1: " + w_do.idw_Other.GetItemString(1,'customs_doc'))
	End If
	
	dw_report.SetITem(llNewRow,'total_weight',ldTotalWeight)
	
//For each Detail Record

//11/07 - PCONKL - We want 3 sets of DO numbers per row, only inserting a new row every 4th
liColumnPos = 3

For llRowPOs = 1 to llRowCount
	
	liColumnPOs ++
	
	//11/07 - PCONKL - We want 3 sets of DO numbers per row, only inserting a new row every 4th
	If liColumnPos > 3 Then
		llNewRow = dw_report.InsertRow(0)
		liColumnPos = 1
	End If
	
	//Ship From Address
	
	//Ship From Name based on Supplier Code (first row only)
	Choose Case Upper(w_do.idw_Detail.GetITemString(1,'supp_Code'))
			
		Case 'AMD'
			dw_report.SetITem(llNewRow,'ship_from_name','Amdiss C/O XPO Logistics')
		Case 'SPANSION'
			dw_report.SetITem(llNewRow,'ship_from_name','Spansion C/O XPO Logistics')
		Case 'LAM'
			dw_report.SetITem(llNewRow,'ship_from_name','Lam C/O XPO Logistics')
		Case 'BLUECOAT'
			dw_report.SetITem(llNewRow,'ship_from_name','Blue Coat C/O XPO Logistics')
		Case Else
			dw_report.SetITem(llNewRow,'ship_from_name','C/O XPO Logistics')
	End Choose
	
	If llWarehouseRow > 0 Then
		
		dw_report.SetITem(llNewRow,'ship_from_addr1',g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
		dw_report.SetITem(llNewRow,'ship_from_city',g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
		dw_report.SetITem(llNewRow,'ship_from_zip',g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
		dw_report.SetITem(llNewRow,'ship_from_tel',g.ids_project_warehouse.GetITemString(llWarehouseRow,'tel'))
		dw_report.SetITem(llNewRow,'ship_from_fax',g.ids_project_warehouse.GetITemString(llWarehouseRow,'fax'))
				
	End If
	
	//Ship To Address
	dw_report.SetITem(llNewRow,'ship_to_name',w_do.idw_Main.GetItemString(1,'cust_name'))
	dw_report.SetITem(llNewRow,'ship_to_addr1',w_do.idw_Main.GetItemString(1,'address_1'))
	dw_report.SetITem(llNewRow,'ship_to_addr2',w_do.idw_Main.GetItemString(1,'address_2'))
	dw_report.SetITem(llNewRow,'ship_to_city',w_do.idw_Main.GetItemString(1,'city'))
	dw_report.SetITem(llNewRow,'ship_to_zip',w_do.idw_Main.GetItemString(1,'zip'))
	
	//Convert Country Code to Country Name if present
	lsCountryName = f_get_country_name(w_do.idw_Main.GetItemString(1,'Country'))
	If lsCountryName > "" Then
		dw_report.SetITem(llNewRow,'ship_to_Country',lsCountryName)
	Else
		dw_report.SetITem(llNewRow,'ship_to_Country',w_do.idw_Main.GetItemString(1,'Country'))
	End If
	
	//Carrier
	dw_report.SetITem(llNewRow,'Carrier_name',lsCarrierName)
	dw_report.SetITem(llNewRow,'Carrier_addr1',lsCarrierAddr1)
	dw_report.SetITem(llNewRow,'Carrier_addr2',lsCarrierAddr2)
	dw_report.SetITem(llNewRow,'Carrier_City',lsCarrierCity)
	dw_report.SetITem(llNewRow,'Carrier_Zip',lsCarrierZip)
	
	lsCountryName = f_get_country_name(lsCarrierCountry)
	If lsCountryName > "" Then
		dw_report.SetITem(llNewRow,'Carrier_Country',lsCountryName)
	Else
		dw_report.SetITem(llNewRow,'Carrier_Country',lsCarrierCountry)
	End If
	
	lsCol = "do_" + String(liColumnPos)
	dw_report.SetITem(llNewRow,lsCol,w_do.idw_detail.GetITemString(lLRowPos,'User_Field1'))
	//dw_report.SetITem(llNewRow,'detail_user_Field1',w_do.idw_detail.GetITemString(lLRowPos,'User_Field1'))
	
	//Need sum of Picking PO_NO (Carton Count)
	llBoxCount = 0
	lsFind = "Line_Item_No = " + String(w_do.idw_detail.GetITemNumber(lLRowPos,'Line_Item_No'))
	lsFind += " and Upper(SKU) = '" + Upper(w_do.idw_detail.GetITemString(lLRowPos,'Sku')) + "'"
	llFindRow = w_do.idw_Pick.Find(lsFind,1,  w_do.idw_Pick.RowCount())
	Do While llFindRow > 0
		llBoxCount += Long(w_do.idw_Pick.GetItemString(llFindRow,'po_no'))
		llFindRow ++
		If llFindRow > w_do.idw_Pick.RowCount() Then
			llFindRow = 0
		Else
			llFindRow = w_do.idw_Pick.Find(lsFind,llFindRow,  w_do.idw_Pick.RowCount())
		End If
	Loop
	
	lsCol = "carton_" + String(liColumnPos)
	dw_report.SetITem(llNewRow,lsCol,llBoxCount)
	//dw_report.SetITem(llNewRow,'pick_po_no',llBoxCount)
	
	dw_report.SetITem(llNewRow,'total_weight',ldTotalWeight)
		
	llFindRow = ldsLookup.Find("Code_ID = 'CMR.Section4.1'",1,ldsLookup.RowCount())
	If llFindRow > 0 Then
		dw_report.SetITem(llNewRow,'lookup_41',ldsLookup.GetITEmString(llFindRow,'code_descript'))
	End If
	
Next /*detail Row */

//Summary Fields

//Only show Special instructions if UF11 = 'T1'
If isnull(w_do.idw_Main.GetITemString(1,'user_Field11')) or w_do.idw_Main.GetITemString(1,'user_Field11') <> 'T1' Then
	dw_report.modify("ins_1_t.visible=false ins_2_t.visible=false ins_3_t.visible=false")
End If

// 10/07 - Different set of sepcial Isntructions to Show if = T
If isnull(w_do.idw_Main.GetITemString(1,'user_Field11')) or w_do.idw_Main.GetITemString(1,'user_Field11') <> 'T' Then
	dw_report.modify("ins_4_t.visible=false ins_5_t.visible=false ins_6_t.visible=false ins_7_t.visible=false ins_8_t.visible=false ins_9_t.visible=false ins_10_t.visible=false ")
End If

If llWarehouseRow > 0 Then
	
	dw_report.Modify("warehouse_addr1_t.text = '" + g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1') + "'")
	
	//Zip & City
	lsCityZip = ""
	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'Zip') > '' Then
		lsCityZip = g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip') + " "
	End If
	
	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'City') > '' Then
		lsCityZip += g.ids_project_warehouse.GetITemString(llWarehouseRow,'City') 
	End If
	
	dw_report.Modify("warehouse_zip_city_t.text = '" + lsCityZip + "'")
	
End If

//Lookup Table
llFindRow = ldsLookup.Find("Code_ID = 'CMR.Section21.1'",1,ldsLookup.RowCount())
If llFindRow > 0 Then
	dw_report.Modify("lookup_211_t.text = '" + ldsLookup.GetITEmString(llFindRow,'code_descript') + "'")
End If
	
llFindRow = ldsLookup.Find("Code_ID = 'CMR.Section23.1'",1,ldsLookup.RowCount())
If llFindRow > 0 Then
	dw_report.Modify("lookup_231_t.text = '" + ldsLookup.GetITEmString(llFindRow,'code_descript') + "'")
End If
	
llFindRow = ldsLookup.Find("Code_ID = 'CMR.Section23.2'",1,ldsLookup.RowCount())
If llFindRow > 0 Then
	dw_report.Modify("lookup_232_t.text = '" + ldsLookup.GetITEmString(llFindRow,'code_descript') + "'")
End If
	
llFindRow = ldsLookup.Find("Code_ID = 'CMR.Section23.3'",1,ldsLookup.RowCount())
If llFindRow > 0 Then
	dw_report.Modify("lookup_233_t.text = '" + ldsLookup.GetITEmString(llFindRow,'code_descript') + "'")
End If

//Add any necessary empty rows so sumamry is at bottom of last page
liEmptyRows = 0
If dw_report.RowCount() < liRowsPerPage Then
	liEmptyRows = liRowsPerPage - dw_report.RowCount()
ElseIf dw_report.RowCount() > liRowsPerPage Then
	liMod = Mod(dw_report.RowCount(), liRowsPerPage)
	If liMod > 0 Then
		liEmptyRows = liRowsPerPage - liMod
	End IF
End If

If liEmptyRows > 0 Then
	For llRowPos = 1 to liEmptyRows
		dw_report.InsertRow(0)
	Next
End If

dw_report.SetRedraw(True)

im_menu.m_file.m_print.Enabled = TRUE









end event

event ue_print;
//Ancestor overriden

Dec	llSeqNo
Boolean	lbNew

//Get the Sequence Number before printing
// 10/07 - PCONKL - If we have already retreived the CMR for this order, re-treive it instead of getting a new one - stored in UF15
If w_do.idw_other.GetITemString(1,'user_field15') > '' Then
	llSeqNo = Long( w_do.idw_other.GetITemString(1,'user_field15'))
Else
	llSeqNo = g.of_next_db_seq(gs_project,'AMS_CMR_RPT','SEQ_No')
	lbNew = True /* only need to save when new */
End If

If llSeqNo > 0 Then
	
	dw_report.modify("Seq_no_t.text='" + String(llSeqNo,'#######') + "' datawindow.print.copies =4 ") /*default to 4 copies*/
	
	//  10/07 - PCONKL - We want to save this number in DO for re-prints
	If lbNew Then
		w_do.idw_other.SetItem(1,'user_field15',String(llSeqNo))
		w_do.ib_changed = True
	End If
	
	OpenWithParm(w_dw_print_options,dw_report) 
		
Else
	Messagebox('CMR Report','Unable to retrieve the Report Sequence Number!',StopSign!)
End If


end event

type dw_select from w_std_report`dw_select within w_ams_cmr_report
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

type cb_clear from w_std_report`cb_clear within w_ams_cmr_report
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_ams_cmr_report
integer x = 32
integer y = 12
integer width = 3483
integer height = 2056
integer taborder = 30
string dataobject = "d_ams_cmr_report"
boolean hscrollbar = true
end type

