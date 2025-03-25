HA$PBExportHeader$w_pandora_cmr_report.srw
$PBExportComments$AMS Multi User CMR Report
forward
global type w_pandora_cmr_report from w_std_report
end type
end forward

global type w_pandora_cmr_report from w_std_report
integer width = 3653
integer height = 2356
string title = "PANDORA CMR Report"
end type
global w_pandora_cmr_report w_pandora_cmr_report

type variables
string is_origsql, isCustomer
string is_origsql2, isOrder
long il_long


String	isremit_name,isRemit_addr1, isRemit_addr2,isRemit_addr3, isRemit_Addr4, isRemit_city, isRemit_state, isRemit_zip, isRemit_country


String isDoNo
end variables

on w_pandora_cmr_report.create
call super::create
end on

on w_pandora_cmr_report.destroy
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
//If w_do.idw_pick.RowCount() = 0 Then
If w_do.tab_main.tabpage_pack.dw_pack.RowCount() = 0 Then
	Messagebox('Labels','You must generate the Packing List before you can print the CMR Report!')
	Return
End If

This.TriggerEvent('ue_retrieve')

end event

event ue_retrieve;Long	ll_numrows, ll_rownum, llNewRow, llWarehouseRow, llBoxCount, llFindRow, ll_whsezip
String	lsWarehouse, lsDONO, lsCarrier, lsCityZip, ls_orderno, ls_sku, ls_owner, ls_whsecity, ls_whsecntry, ls_shipvia, ls_addr_1, ls_whsezip, ls_whsephone, ls_whsefax
String	lsCarrierNAme, lsCarrierAddr1, lsCarrierAddr2, lsCarrierCity, lsCarrierZip, lsCarrierCountry, lsCountryName, lsFind, lsCol, ls_shippinginstructions, ls_lastuser
Int	liRowsPerPAge, liEmptyRows, liMod, liColumnPos
Decimal	ldTotalWeight, ld_length, ld_width, ld_height, ld_volm3, ld_weight
DataStore	ldsLookup

datawindow ldw_detail, ldw_packing, ldw_other, ldw_main
long ll_packlineno, ll_detlineno, ll_numpackrows, ll_numpackages
string ls_cartontype, ls_dims
//TimA
String ls_ship_from_name, ls_addr_2, ls_carton_no

// Get the detail, other and packing datawindows.
ldw_detail = w_do.tab_main.tabpage_detail.dw_detail
ldw_other = w_do.tab_main.tabpage_other.dw_other
ldw_packing = w_do.tab_main.tabpage_pack.dw_pack
ldw_main = w_do.tab_main.tabpage_main.dw_main

// Disable the print button.
im_menu.m_file.m_print.Enabled = False

//Number of rows per page - we will want to insert enough rows on the last page so the sumamry is at the bottom
liRowsPerPage = 19
liRowsPerPage = 3

// Get the warehouse and DO_NO.
lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')

//Get the Warehouse Address from global datastore
llWarehouseRow = g.ids_project_warehouse.Find("upper(wh_code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

// Debug
//openwithparm(w_dwspy, g.ids_project_warehouse)

//Get The Carrier Address
lsCarrier = w_do.idw_Main.GetITemString(1,'carrier')
Select Carrier_Name, Address_1, Address_2, Zip, City, iso_Country_cd
into :lsCarrierNAme, :lsCarrierAddr1, :lsCarrierAddr2, :lsCarrierZip, :lsCarrierCity, :lsCarrierCountry
From Carrier_master
Where Project_id = :gs_project and carrier_Code = :lscarrier;

// If carrier is missing,
If NOT lsCarrierNAme > "" Then
	
	// Show error and stop processing.
	Messagebox("CMR Report","Carrier Name  is missing.~r~rReport can not be printed until this information is available on the Carrier Master.",StopSign!)
	Return
End If

// Create the lookup datastore.
ldsLookup = Create Datastore
ldsLookup.dataobject = 'dddw_lookup'
ldsLookup.SetTransObject(SQLCA)
ldsLookup.Retrieve(gs_project,'CMR')

// Reset the report DW and set redraw to false.
dw_report.reset()
dw_report.SetRedraw(False)

// Get the number of detail rows.
ll_numrows = w_do.idw_detail.RowCount()

//Insert 1 blank line to drop the first detail line down
llNewRow = dw_report.InsertRow(0)

	//Ship From Name based on Supplier Code (first row only)
	//17-Nov-2015 :Madhu- Replaced MenloWorldWide by XPO -START
	Choose Case Upper(w_do.idw_Detail.GetITemString(1,'supp_Code'))
			
		Case 'AMD'
			dw_report.SetITem(llNewRow,'ship_from_name','Amdiss C/O XPO Logistics')
		Case 'SPANSION'
			dw_report.SetITem(llNewRow,'ship_from_name','Spansion C/O XPO Logistics')
		Case 'LAM'
			dw_report.SetITem(llNewRow,'ship_from_name','Lam C/O XPO Logistics')
		Case 'BLUECOAT'
			dw_report.SetITem(llNewRow,'ship_from_name','Blue Coat C/O XPO Logistics')
		Case 'PANDORA'
			ls_ship_from_name = g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name')			
			dw_report.SetITem(llNewRow,'ship_from_name',ls_ship_from_name)			
		Case Else
			dw_report.SetITem(llNewRow,'ship_from_name','C/O XPO Logistics')
	End Choose
	//17-Nov-2015 :Madhu- Replaced MenloWorldWide by XPO -END
	If llWarehouseRow > 0 Then
		
		// Get the warehouse city.
		ls_addr_1 = g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1')
		ls_addr_2 = g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2')		
		ls_whsecity = g.ids_project_warehouse.GetITemString(llWarehouseRow,'city')
		ls_whsecntry = g.ids_project_warehouse.GetITemString(llWarehouseRow,'country')
		ls_whsezip = g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip')
//		ls_whsephone = g.ids_project_warehouse.GetITemString(llWarehouseRow,'tel')
		ls_whsefax = g.ids_project_warehouse.GetITemString(llWarehouseRow,'fax')
		
		IF isnull(ls_addr_1) then ls_addr_1 = ""
		IF isnull(ls_addr_2) then ls_addr_2 = ""
		IF isnull(ls_whsecity) then ls_whsecity = ""
		IF isnull(ls_whsecntry) then ls_whsecntry = ""
		IF isnull(ls_whsezip) then ls_whsezip = ""
//		IF isnull(ls_whsephone) then ls_whsephone = ""
		IF isnull(ls_whsefax) then ls_whsefax = ""
		
		dw_report.SetITem(llNewRow,'ship_from_addr1', ls_addr_1)
		dw_report.SetITem(llNewRow,'ship_from_addr2', ls_addr_2)		
		dw_report.SetITem(llNewRow,'ship_from_city',ls_whsecity)
		dw_report.SetITem(llNewRow,'ship_from_country',ls_whsecntry)
		dw_report.SetITem(llNewRow,'ship_from_zip', ls_whsezip)
//		dw_report.SetITem(llNewRow,'ship_from_tel', ls_whsephone)
		dw_report.SetITem(llNewRow,'ship_from_fax', ls_whsefax)
		
		//TimA 08/16/12 Pandora issue 491.
		If Upper(gs_project) = 'PANDORA' then		
			dw_report.Modify("t_shipfromname.text =  '" + ls_ship_from_name + "'")
		Else
			dw_report.Modify("t_shipfromname.text = 'C/O XPO Logistics'")
		End if

		dw_report.Modify("t_shipfromaddress.text = '" + ls_addr_1 + "'")
		dw_report.Modify("t_shipfromaddress_2.text = '" + ls_addr_2 + "'")			
		dw_report.Modify("t_shipfromzipcity.text = '" + ls_whsezip + "   " + ls_whsecity + "'")
		dw_report.Modify("t_shipfromcountry.text = '" + ls_whsecntry + "'")

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
	
	// Get the carrier name.
	lsCarrierName = ldw_other.getitemstring(1, "ship_via")
	
	//Carrier
	dw_report.SetITem(llNewRow,'Carrier_name',lsCarrierName)
//	dw_report.SetITem(llNewRow,'Carrier_addr1',lsCarrierAddr1)
//	dw_report.SetITem(llNewRow,'Carrier_addr2',lsCarrierAddr2)
//	dw_report.SetITem(llNewRow,'Carrier_City',lsCarrierCity)
//	dw_report.SetITem(llNewRow,'Carrier_Zip',lsCarrierZip)
	
	lsCountryName = f_get_country_name(lsCarrierCountry)
	If lsCountryName > "" Then
		dw_report.SetITem(llNewRow,'Carrier_Country',lsCountryName)
	Else
		dw_report.SetITem(llNewRow,'Carrier_Country',lsCarrierCountry)
	End If

//	llFindRow = ldsLookup.Find("Code_ID = 'CMR.Section4.1'",1,ldsLookup.RowCount())
//	If llFindRow > 0 Then
//		dw_report.SetITem(llNewRow,'lookup_41',ldsLookup.GetITEmString(llFindRow,'code_descript'))
//	End If
	
	// 10/07 - PCONKL - Add Customs Doc if UF11 = 'T'
	If w_do.idw_Main.GetITemString(1,'user_Field11') = 'T' Then
		dw_report.SetITem(llNewRow,'customs_doc',"T-1: " + w_do.idw_Other.GetItemString(1,'customs_doc'))
	End If
	
	dw_report.SetITem(llNewRow,'total_weight',ldTotalWeight)

	// Get the shipping instructions
	ls_shippinginstructions = ldw_other.getitemstring(1, "shipping_instructions")
	
	// Set the shipping instructions.
//	dw_report.Object.shipping_instruction[0] = "Hello World" //ls_shippinginstructions
//	messagebox("", dw_report.setitem(1, "shipping_instruction", ls_shippinginstructions))
//	messagebox("", dw_report.setitem(1, "shipping_instruction", "test inst"))
dw_report.Modify("t_1.text = '" + ls_shippinginstructions + "'")
//	messagebox("", dw_report.setitem(1, "t_1", ls_shippinginstructions))
//	dw_report.setitem(1, "ship_inst", ls_shippinginstructions)
//	dw_report.Object.footer.t_1 = ls_shippinginstructions
//	dw_report.object.shipping_instruction[1] = ls_shippinginstructions
//	dw_report.SetITem(0,'t_1', ls_shippinginstructions)
//	dw_report.Object.shipping_instruction.Primary = ls_shippinginstructions

//	// TEST
//	messagebox("", dw_report.getitemstring(1, "shipping_instruction"))
	
// Get the number of packing rows.
ll_numpackrows = ldw_packing.rowcount()

//For each Detail Record
// Get the order number.
ls_orderno = w_do.tab_main.tabpage_main.sle_order.text

// Loop through the detail rows.
For ll_rownum = 1 to ll_numrows
	
	// Get the sku and owner for this line item.
	ll_detlineno = ldw_detail.getitemnumber(ll_rownum, "line_item_no")
	ls_sku = ldw_detail.getitemstring(ll_rownum, "sku")
	ls_owner = ldw_detail.getitemstring(ll_rownum, "cf_owner_name")
	
	// get the corresponding row on the packing tab.
	ll_packlineno = ldw_packing.find("line_item_no=" + string(ll_detlineno), 1, ll_numpackrows)	
	
	// Set the order number.
	dw_report.SetITem(llNewRow,'order_no', ls_orderno)
	
	// Get and set the number of packages for this line item.
	//TimA 08/16/12 Pandora issue 491.
	If Upper(gs_project) = 'PANDORA' then
		ls_carton_no = ldw_packing.getitemstring(ll_packlineno, "carton_no")		
		dw_report.object.numcartons.visible=false
		dw_report.object.carton_no.visible=true
		dw_report.SetITem(llNewRow,'carton_no', ls_carton_no)
		dw_report.object.l_2.visible=false

	Else
		ll_numpackages = ldw_packing.getitemnumber(ll_packlineno, "quantity")
		dw_report.object.numcartons.visible=false
		dw_report.object.carton_no.visible=false
		dw_report.SetITem(llNewRow,'numcartons', ll_numpackages)		
	End if
	
	
	// Get and set the package type for this line item.
	ls_cartontype = ldw_packing.getitemstring(ll_packlineno, "carton_type")
	dw_report.SetITem(llNewRow,'carton_type', ls_cartontype)
	
	// Set the description to 'Electronics'.
	dw_report.SetITem(llNewRow,'description', "computer parts")
	
	// Get and set the dimensions for this line item.
	ld_length = ldw_packing.getitemnumber(ll_packlineno, "length")
	If isnull(ld_length) then ld_length = 0
	ld_width = ldw_packing.getitemnumber(ll_packlineno, "width")
	If isnull(ld_width) then ld_width = 0
	ld_height = ldw_packing.getitemnumber(ll_packlineno, "height")
	If isnull(ld_height) then ld_height = 0
	ls_dims = string(ld_length) + "X" + string(ld_width) + "X" + string(ld_height)
	dw_report.SetITem(llNewRow,'dims', ls_dims)
	
	// Get and set the volume for this line item.
	ld_volm3 = ldw_packing.getitemnumber(ll_packlineno, "cbm")
	ld_volm3 = ld_volm3 * .00001638706
	dw_report.SetITem(llNewRow,'volm3', ld_volm3)
	
	// Get and set the gross weight for this line.
	ld_weight = dec(w_do.idw_pack.GetITemdecimal(ll_packlineno,'weight_gross'))
	dw_report.SetITem(llNewRow,'gross_weight', ld_weight)
	
	// Insert a new row.
	llNewRow = dw_report.InsertRow(0)
	
// Next detail row.
Next

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
	For ll_rownum = 1 to liEmptyRows
		dw_report.InsertRow(0)
	Next
End If

// Set the warehouse city.
//dw_report.SetITem(llNewRow,'warehouse_city', ls_whsecity)
dw_report.Modify("t_whsecity.text = '" + ls_whsecity + "'")

//// Set the Ship VIA info.
//w_do.idw_Other.GetItemString(1,'customs_doc')

////11/07 - PCONKL - We want 3 sets of DO numbers per row, only inserting a new row every 4th
//liColumnPos = 3
//
//// Loop through the detail rows.
//For ll_rownum = 1 to ll_numrows
//	
//	// Accumulate the total weight for all the rows.
//	ldtotalWeight += Dec(w_do.idw_detail.GetITemString(ll_rownum,'User_field3'))
//
//	// Incriment the column counter.
//	liColumnPOs ++
//	
//	//11/07 - PCONKL - We want 3 sets of DO numbers per row, only inserting a new row every 4th
//	If liColumnPos > 3 Then
//		llNewRow = dw_report.InsertRow(0)
//		liColumnPos = 1
//	End If
//	
//	//Ship From Address
//	
//	//Ship From Name based on Supplier Code (first row only)
//	Choose Case Upper(w_do.idw_Detail.GetITemString(1,'supp_Code'))
//			
//		Case 'AMD'
//			dw_report.SetITem(llNewRow,'ship_from_name','Amdiss C/O Menlo Worldwide')
//		Case 'SPANSION'
//			dw_report.SetITem(llNewRow,'ship_from_name','Spansion C/O Menlo Worldwide')
//		Case 'LAM'
//			dw_report.SetITem(llNewRow,'ship_from_name','Lam C/O Menlo Worldwide')
//		Case 'BLUECOAT'
//			dw_report.SetITem(llNewRow,'ship_from_name','Blue Coat C/O Menlo Worldwide')
//		Case Else
//			dw_report.SetITem(llNewRow,'ship_from_name','C/O Menlo Worldwide')
//	End Choose
//	
//	If llWarehouseRow > 0 Then
//		
//		dw_report.SetITem(llNewRow,'ship_from_addr1',g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
//		dw_report.SetITem(llNewRow,'ship_from_city',g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
//		dw_report.SetITem(llNewRow,'ship_from_zip',g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
//		dw_report.SetITem(llNewRow,'ship_from_tel',g.ids_project_warehouse.GetITemString(llWarehouseRow,'tel'))
//		dw_report.SetITem(llNewRow,'ship_from_fax',g.ids_project_warehouse.GetITemString(llWarehouseRow,'fax'))
//				
//	End If
//	
//	//Ship To Address
//	dw_report.SetITem(llNewRow,'ship_to_name',w_do.idw_Main.GetItemString(1,'cust_name'))
//	dw_report.SetITem(llNewRow,'ship_to_addr1',w_do.idw_Main.GetItemString(1,'address_1'))
//	dw_report.SetITem(llNewRow,'ship_to_addr2',w_do.idw_Main.GetItemString(1,'address_2'))
//	dw_report.SetITem(llNewRow,'ship_to_city',w_do.idw_Main.GetItemString(1,'city'))
//	dw_report.SetITem(llNewRow,'ship_to_zip',w_do.idw_Main.GetItemString(1,'zip'))
//	
//	//Convert Country Code to Country Name if present
//	lsCountryName = f_get_country_name(w_do.idw_Main.GetItemString(1,'Country'))
//	If lsCountryName > "" Then
//		dw_report.SetITem(llNewRow,'ship_to_Country',lsCountryName)
//	Else
//		dw_report.SetITem(llNewRow,'ship_to_Country',w_do.idw_Main.GetItemString(1,'Country'))
//	End If
//	
//	//Carrier
//	dw_report.SetITem(llNewRow,'Carrier_name',lsCarrierName)
//	dw_report.SetITem(llNewRow,'Carrier_addr1',lsCarrierAddr1)
//	dw_report.SetITem(llNewRow,'Carrier_addr2',lsCarrierAddr2)
//	dw_report.SetITem(llNewRow,'Carrier_City',lsCarrierCity)
//	dw_report.SetITem(llNewRow,'Carrier_Zip',lsCarrierZip)
//	
//	lsCountryName = f_get_country_name(lsCarrierCountry)
//	If lsCountryName > "" Then
//		dw_report.SetITem(llNewRow,'Carrier_Country',lsCountryName)
//	Else
//		dw_report.SetITem(llNewRow,'Carrier_Country',lsCarrierCountry)
//	End If
//	
//	lsCol = "do_" + String(liColumnPos)
//	dw_report.SetITem(llNewRow,lsCol,w_do.idw_detail.GetITemString(ll_rownum,'User_Field1'))
//	//dw_report.SetITem(llNewRow,'detail_user_Field1',w_do.idw_detail.GetITemString(ll_rownum,'User_Field1'))
//	
//	//Need sum of Picking PO_NO (Carton Count)
//	llBoxCount = 0
//	lsFind = "Line_Item_No = " + String(w_do.idw_detail.GetITemNumber(ll_rownum,'Line_Item_No'))
//	lsFind += " and Upper(SKU) = '" + Upper(w_do.idw_detail.GetITemString(ll_rownum,'Sku')) + "'"
//	llFindRow = w_do.idw_Pick.Find(lsFind,1,  w_do.idw_Pick.RowCount())
//	Do While llFindRow > 0
//		llBoxCount += Long(w_do.idw_Pick.GetItemString(llFindRow,'po_no'))
//		llFindRow ++
//		If llFindRow > w_do.idw_Pick.RowCount() Then
//			llFindRow = 0
//		Else
//			llFindRow = w_do.idw_Pick.Find(lsFind,llFindRow,  w_do.idw_Pick.RowCount())
//		End If
//	Loop
//	
//	lsCol = "carton_" + String(liColumnPos)
//	dw_report.SetITem(llNewRow,lsCol,llBoxCount)
//	//dw_report.SetITem(llNewRow,'pick_po_no',llBoxCount)
//	
//	dw_report.SetITem(llNewRow,'total_weight',ldTotalWeight)
//		
//	llFindRow = ldsLookup.Find("Code_ID = 'CMR.Section4.1'",1,ldsLookup.RowCount())
//	If llFindRow > 0 Then
//		dw_report.SetITem(llNewRow,'lookup_41',ldsLookup.GetITEmString(llFindRow,'code_descript'))
//	End If
//	
//Next /*detail Row */

//Summary Fields

////Only show Special instructions if UF11 = 'T1'
//If isnull(w_do.idw_Main.GetITemString(1,'user_Field11')) or w_do.idw_Main.GetITemString(1,'user_Field11') <> 'T1' Then
//	dw_report.modify("ins_1_t.visible=false ins_2_t.visible=false ins_3_t.visible=false")
//End If
//
//// 10/07 - Different set of sepcial Isntructions to Show if = T
//If isnull(w_do.idw_Main.GetITemString(1,'user_Field11')) or w_do.idw_Main.GetITemString(1,'user_Field11') <> 'T' Then
//	dw_report.modify("ins_4_t.visible=false ins_5_t.visible=false ins_6_t.visible=false ins_7_t.visible=false ins_8_t.visible=false ins_9_t.visible=false ins_10_t.visible=false ")
//End If
//
//If llWarehouseRow > 0 Then
//	
//	dw_report.Modify("warehouse_addr1_t.text = '" + g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1') + "'")
//	
//	//Zip & City
//	lsCityZip = ""
//	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'Zip') > '' Then
//		lsCityZip = g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip') + " "
//	End If
//	
//	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'City') > '' Then
//		lsCityZip += g.ids_project_warehouse.GetITemString(llWarehouseRow,'City') 
//	End If
//	
//	dw_report.Modify("warehouse_zip_city_t.text = '" + lsCityZip + "'")
//	
//End If
//
////Lookup Table
//llFindRow = ldsLookup.Find("Code_ID = 'CMR.Section21.1'",1,ldsLookup.RowCount())
//If llFindRow > 0 Then
//	dw_report.Modify("lookup_211_t.text = '" + ldsLookup.GetITEmString(llFindRow,'code_descript') + "'")
//End If
	
//llFindRow = ldsLookup.Find("Code_ID = 'CMR.Section23.1'",1,ldsLookup.RowCount())
//If llFindRow > 0 Then
//	dw_report.Modify("lookup_231_t.text = '" + ldsLookup.GetITEmString(llFindRow,'code_descript') + "'")
//End If
//	
//llFindRow = ldsLookup.Find("Code_ID = 'CMR.Section23.2'",1,ldsLookup.RowCount())
//If llFindRow > 0 Then
//	dw_report.Modify("lookup_232_t.text = '" + ldsLookup.GetITEmString(llFindRow,'code_descript') + "'")
//End If
//	
//llFindRow = ldsLookup.Find("Code_ID = 'CMR.Section23.3'",1,ldsLookup.RowCount())
//If llFindRow > 0 Then
//	dw_report.Modify("lookup_233_t.text = '" + ldsLookup.GetITEmString(llFindRow,'code_descript') + "'")
//End If

ls_shipvia = ldw_other.getitemstring(1, "ship_via")
dw_report.Modify("lookup_231_t.text = '" + ls_shipvia + "'")

// Set the last user
//TimA 08/16/12 Pandora issue 491..
If Upper(gs_project) = 'PANDORA' then
	ls_lastuser = ldw_main.getitemstring(1, "last_user")
else
	ls_lastuser = ldw_main.getitemstring(1, "create_user")
end if

Select display_name
into :ls_lastuser
from UserTable
Where UserId = :ls_lastuser;

dw_report.Modify("t_lastuser.text = '" + ls_lastuser + "'")

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
	For ll_rownum = 1 to liEmptyRows
		dw_report.InsertRow(0)
	Next
End If

dw_report.SetRedraw(True)

im_menu.m_file.m_print.Enabled = TRUE









end event

event ue_print;
//Ancestor overriden
// ET3 2012/06/20: issue 430 - prefix the P; change to user_field16 from user_field15

Dec	llSeqNo
Boolean	lbNew

//Get the Sequence Number before printing
// 10/07 - PCONKL - If we have already retreived the CMR for this order, re-treive it instead of getting a new one - stored in UF15
If w_do.idw_other.GetITemString(1,'user_field16') > '' Then
	llSeqNo = Long( w_do.idw_other.GetITemString(1,'user_field16'))
Else
	/* 06/07/10 ujh:  This has been cloned from w_ams_cmr_report,   In general PANDORA
		replaces "AMS" whereever found, as seen below
		The following required making an entry in the next_sequence_no table to support
		the following function call. */
	llSeqNo = g.of_next_db_seq(gs_project,'PANDORA_CMR_RPT','SEQ_No')
	lbNew = True /* only need to save when new */
End If

If llSeqNo > 0 Then
	
	// ET3 2012/06/20: issue 430 - prefix the P; change to user_field16 from user_field15
	dw_report.modify("Seq_no_t.text='" + 'P' + String(llSeqNo,'#######') + "' datawindow.print.copies =4 ") /*default to 4 copies*/
	
	//  10/07 - PCONKL - We want to save this number in DO for re-prints
	If lbNew Then
		w_do.idw_other.SetItem(1,'user_field16',String(llSeqNo))
		w_do.ib_changed = True
	End If
	
	OpenWithParm(w_dw_print_options,dw_report) 
		
Else
	Messagebox('CMR Report','Unable to retrieve the Report Sequence Number!',StopSign!)
End If


end event

type dw_select from w_std_report`dw_select within w_pandora_cmr_report
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

type cb_clear from w_std_report`cb_clear within w_pandora_cmr_report
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_pandora_cmr_report
integer x = 32
integer y = 12
integer width = 3483
integer height = 2056
integer taborder = 30
string dataobject = "d_pandora_cmr_report"
boolean hscrollbar = true
end type

