$PBExportHeader$w_pandora_commercial_invoice_rpt.srw
$PBExportComments$Powerwave Commercial Invoice Report
forward
global type w_pandora_commercial_invoice_rpt from w_std_report
end type
type sle_totalpieces from singlelineedit within w_pandora_commercial_invoice_rpt
end type
end forward

global type w_pandora_commercial_invoice_rpt from w_std_report
integer width = 3653
integer height = 2364
string title = "Pandora Commercial Invoice"
event ue_retrieve_cityblock ( )
sle_totalpieces sle_totalpieces
end type
global w_pandora_commercial_invoice_rpt w_pandora_commercial_invoice_rpt

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
public function boolean f_getcostcenter (long al_pickrow, ref decimal ad_cost)
public function boolean f_getprice (long al_pickrownumber, string as_sku, ref decimal ad_price)
end prototypes

event ue_retrieve_cityblock();Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llPickPos, llPickCount,   llFind, llLIneItem, llLineItemSave, llCount, llOwnerID, llOwnerPrev
long ll_quantity
String	lsWarehouse, lsCityState, lsContact, lsSKU, lsSKUPrev, lsSupplier, lsDONO, lsDesc, lsSerial, ls_currency_code, lsOwnerCd, ls_Location_Org
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsCarton, lsCartonSave, lsCOO, lsCOOSave, lsFind, ls_tel
STRING ls_ord_type, ls_ord_type_desc, lsCurrency
Int	liRowsPerPAge, liEmptyRows, liMod, liLastExtRow
Decimal	ldGrossWeight, ldPrice_1, ldPrice_2
decimal ld_price, ld_costcenter
boolean ib_null_price = false
string ls_hts, ls_user_field7, ls_user_field8, ls_warehouse_county, ls_user_field9
string lsNewCarton, lsPrevCarton, ls_cartontype
integer liPallets
decimal ld_weight
str_parms	lstrparms

liRowsPerPage =  5


IF w_do.idw_Pack.RowCount() <= 0 THEN
	MessageBox ("Error", "There are no detail rows. Can't print.")
	RETURN 
END IF

SetPointer(Hourglass!)

//Seagate drive families are stored in Lookup table to allow us to add families a little easier
idsDrives = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select * from lookup_table where project_id = 'Pandora' and Code_Type = 'CB-SN' "
dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
idsDrives.Create( dwsyntax_str, lsErrText)
idsDrives.SetTransObject(SQLCA)
idsDrives.Retrieve()

//Get Gross Weight...
For lLRowPOs = 1 to w_do.idw_Pack.RowCount()

	// Get the carton type.
	ls_cartontype = w_do.idw_pack.GetItemString(llRowPos,'carton_type')
	
	// If the cartontype is null, default it to 'ea.'.
	if isnull(ls_cartontype) then ls_cartontype = "ea."
	
	// Aggregate the quantity.
	ll_quantity += w_do.idw_pack.GetItemnumber(llRowPos,'quantity')

	// Get the carton number.
	lsNewCarton = w_do.idw_pack.GetItemString(llRowPos,'Carton_no')
		
	if lsNewCarton <> lsPrevCarton then
		
		liPallets += 1
		ld_weight = w_do.idw_pack.GetITemNUmber(llRowPos,'weight_gross')
				 
		if IsNull(ld_weight) then ld_weight = 0
				 
		ldGrossWeight += ld_weight
	end if

	lsPrevCarton = lsNewCarton

Next

If NOT isvalid(idsImporterAddress) Then
	
	idsImporterAddress = Create DataStore
	idsImporterAddress.dataObject = 'd_do_address_alt'
	idsImporterAddress.SetTransObject(sqlca)
	
End If

lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')


llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

//dw_report.reset()
dw_report.SetRedraw(False)

ls_ord_type = w_do.idw_Main.GetITEmString(1,'ord_type')
	
SELECT Ord_Type_Desc INTO :ls_ord_type_desc
FROM Delivery_Order_Type
WHERE Project_ID = :gs_project AND
Ord_Type = :ls_ord_type USING SQLCA;
		
//For CityBlock, we only have a single detail row for a Generic SKU
//We need to loop through Picking and determine the real SKU based on the Serial Number. COO will also be determined from the SN
//We may be either adding or updating existing rows on the Invoice based on the serial numbers (SKU's) that are scanned

lLRowCount = w_do.idw_Pick.RowCount()
For llRowPOs = 1 to llRowCount
		
		// Get the line item and serial numbers.
		llLineItem = w_do.idw_Pick.GetITemNumber(llRowPos,'Line_Item_No')
		lsSerial = w_do.idw_Pick.GetITemString(llRowPos,'Serial_No')
		
		//Determine the SKU from the Serial Number
		lstrparms.String_arg[1] = lsSerial
		lstrparms = uf_Determine_SKU(lstrparms)
		lsSKU = lstrparms.String_arg[1]
		lsCOO = lstrparms.String_arg[2]
	
	//Don't include NON CityBlock SKU, they will be reported seperately
	If w_do.idw_Pick.GetITemString(llRowPos,'SKU') <> '07013415' Then Continue
	//If lsSKU <> '07013415' Then Continue
		
//	lsSKU = w_do.idw_Pick.GetITemString(llRowPos,'sku')
//	lsSupplier = w_do.idw_Pick.GetITemString(llRowPos,'supp_Code')
//	llLineItem = w_do.idw_Pick.GetITemNumber(llRowPos,'Line_Item_No')
//	lsSerial = w_do.idw_Pick.GetITemString(llRowPos,'Serial_No')
	
//	//Determine the SKU from the Serial Number
//	lstrparms.String_arg[1] = lsSerial
//	lstrparms = uf_Determine_SKU(lstrparms)
//	
//	lsSKU = lstrparms.String_arg[1]
//	lsCOO = lstrparms.String_arg[2]
	
	
	//SKU/COO already exists
	lsFind = "Line_Item = " + String(llLineItem) + " and upper(SKU) = '" + upper(lsSKU) + "' and Upper(Coo) = '" + Upper(lsCOO) + "'"
	llFind = dw_report.Find(lsFind,1,dw_report.RowCount())
	If llFind > 0 Then
	
		dw_Report.SetITem(llFind,'qty',dw_report.GetITemNumber(llFind,'qty') + w_do.idw_Pick.GetITemNUmber(llRowPos,'quantity')) /*add qty to existing row for SKU/COO*/
		
	Else /* Insert a new row */
		
		llNewRow = dw_report.InsertRow(0)
		
		dw_Report.SetITem(llNewRow,'sku',lsSKU)
		dw_Report.SetITem(llNewRow,'coo',lsCOO)

		//Exporter/Shipper Info Box
		If llwarehouseRow > 0 Then /*warehouse row exists*/
	
			dw_Report.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
			
			dw_Report.setitem(llNewRow,"ship_from_addr1",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
			dw_Report.setitem(llNewRow,"ship_from_addr2",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
			dw_Report.setitem(llNewRow,"ship_from_addr3",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
			dw_Report.setitem(llNewRow,"ship_from_addr4",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
	
			//Format City/State/Zip
			lsCityState = ""
	
			If g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') > "" Then
				lsCityState = g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') + ", "
			End If
	
			If g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') > "" Then
				lsCityState += g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') + " "
			End If
	
			If g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip') > "" Then
				lsCityState += g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip')
			End If
	
			dw_Report.setitem(llNewRow,"ship_from_addr5",lsCityState)
	
			dw_Report.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
	 
			ls_warehouse_county = g.ids_project_warehouse.GetITemString(llWarehouseRow,'country')
	
			dw_Report.setitem(llNewRow,"ship_from_contact",g.ids_project_warehouse.GetITemString(llWarehouseRow,'contact_person'))
			dw_Report.setitem(llNewRow,"ship_from_telephone",g.ids_project_warehouse.GetITemString(llWarehouseRow,'tel'))
		
		End If
	
		dw_Report.SetITem(llNewRow,'invoice_no', w_do.idw_Main.GetITemString(1,'invoice_no'))
		dw_Report.setitem(llNewRow,"freight_atd", w_do.idw_other.GetItemDateTime(1,'freight_atd'))
		dw_Report.setitem(llNewRow,"ship_via", w_do.idw_other.GetITEmString(1,'ship_via'))
		dw_Report.setitem(llNewRow,"transport_mode", w_do.idw_other.GetITEmString(1,'transport_mode'))
			
		dw_Report.setitem(llNewRow,"ord_type", ls_ord_type_desc)
		dw_report.Modify("order_type_t.text = '" + ls_ord_type_desc + "'")
		dw_Report.setitem(llNewRow,"freight_terms", w_do.idw_other.GetITEmString(1,'freight_terms'))

		//Customer Address -> Consignee
		dw_Report.SetITem(llNewRow,'consignee_name',w_do.idw_Main.GetITemString(1,'cust_Name'))
		dw_Report.SetITem(llNewRow,'consignee_addr1',w_do.idw_Main.GetITemString(1,'address_1'))
		dw_Report.SetITem(llNewRow,'consignee_addr2',w_do.idw_Main.GetITemString(1,'address_2'))
		dw_Report.SetITem(llNewRow,'consignee_addr3',w_do.idw_Main.GetITemString(1,'address_3'))
		dw_Report.SetITem(llNewRow,'consignee_addr4',w_do.idw_Main.GetITemString(1,'address_4'))

		//City State Zip combined
		lsCityState = ""
		If w_do.idw_Main.GetITemString(1,'city') > "" Then
			lsCityState = w_do.idw_Main.GetITemString(1,'city') + ", "
		End If

		If w_do.idw_Main.GetITemString(1,'state') > "" Then
			lsCityState += w_do.idw_Main.GetITemString(1,'state') + " "
		End If

		If w_do.idw_Main.GetITemString(1,'zip') > "" Then
			lsCityState += w_do.idw_Main.GetITemString(1,'zip') 
		End If

		dw_Report.SetITem(llNewRow,'consignee_city_state',lsCityState)


		If w_do.idw_Main.GetITemString(1,'contact_person') > "" Then
			lsContact = w_do.idw_Main.GetITemString(1,'contact_person') 
		End If

		If w_do.idw_Main.GetITemString(1,'tel') > "" Then
			ls_tel =  w_do.idw_Main.GetITemString(1,'tel') 
		End If
	

		dw_Report.SetITem(llNewRow,'consignee_contact',lsContact)
		dw_Report.SetITem(llNewRow,'consignee_telephone',ls_tel)
	
		if IsNull(lsContact) then lsContact = ""
	
		dw_Report.Modify("consignee_contact_t.text='" + lsContact + "'")

		dw_Report.SetITem(llNewRow,'consignee_country',w_do.idw_Main.GetITemString(1,'country'))

		idsImporterAddress.Retrieve(lsdono, 'ST') /*Importer Address*/


		If idsImporterAddress.RowCount() > 0 Then
	
			//dw_Report.SetITem(llNewRow,'sold_to_name',idsImporterAddress.GetITemString(1,'name'))	// LTK 20110412 No longer populate sold_to_name
			dw_Report.setitem(llNewRow,"sold_to_addr1",idsImporterAddress.GetITemString(1,'address_1'))
			dw_Report.setitem(llNewRow,"sold_to_addr2",idsImporterAddress.GetITemString(1,'address_2'))
			dw_Report.setitem(llNewRow,"sold_to_addr3",idsImporterAddress.GetITemString(1,'address_3'))
			dw_Report.setitem(llNewRow,"sold_to_addr4",idsImporterAddress.GetITemString(1,'address_4'))
	
			//Format City/State/Zip
			lsCityState = ""
	
			If idsImporterAddress.GetITemString(1,'city') > "" Then
				lsCityState = idsImporterAddress.GetITemString(1,'city') + ", "
			End If
	
			If idsImporterAddress.GetITemString(1,'state') > "" Then
				lsCityState += idsImporterAddress.GetITemString(1,'state') + " "
			End If
	
			If idsImporterAddress.GetITemString(1,'zip') > "" Then
				lsCityState += idsImporterAddress.GetITemString(1,'zip')
			End If
	
			dw_Report.setitem(llNewRow,"sold_to_addr5",lsCityState)
			dw_Report.setitem(llNewRow,"sold_to_country",idsImporterAddress.GetITemString(1,'country'))
			dw_Report.setitem(llNewRow,"sold_to_contact",idsImporterAddress.GetITemString(1,'contact_person'))
			dw_Report.setitem(llNewRow,"sold_to_telephone",idsImporterAddress.GetITemString(1,'tel'))
			
		End If
	
		string ls_ship_instr
	
		ls_ship_instr  = w_do.idw_other.GetITemString(1,'shipping_instructions')
		if IsNull(ls_ship_instr) then ls_ship_instr = ""
		
		dw_Report.Modify("ship_instr_t.text='" + ls_ship_instr + "'")
			
		string ls_uom, ls_user_field10
		If (lsSKU > '' and lsSKU <> lsSKUPrev) or (llLineItem <> llLineItemSave) or (lsCOO <> lsCOOSave)  Then
			
			Select description, user_field7, user_field8, user_field9, UOM_1, user_field10
			Into	 :lsDesc, :ls_user_field7, :ls_user_field8, :ls_user_field9, :ls_uom, :ls_user_field10
			From Item_Master
			Where Project_id = :gs_project and sku = :lsSKU and supp_code = "PANDORA";
		
//			if sqlca.sqlcode <> 0 then
//				MessageBox ("", SQLCA.SQLErrText )
//			end if

			dw_Report.SetITem(llNewRow,'description',lsDesc)	
			dw_Report.SetITem(llNewRow,'uom',ls_uom)	
			dw_Report.SetITem(llNewRow,'hts',ls_user_field7)
			dw_Report.SetITem(llNewRow,'euhts',ls_user_field8)		
			dw_Report.SetITem(llNewRow,'eccn',ls_user_field9)
			dw_Report.SetITem(llNewRow,'lic',ls_user_field10)
			
			lsSKUPrev = lsSKU
			llLineItemSave = llLineItem
			lsCOOSave = lsCOO
			
		End If
		
		dw_Report.SetITem(llNewRow,'line_item',w_do.idw_Pick.GetITemNumber(llRowPos,'Line_Item_No'))
		dw_Report.SetITem(llNewRow,'qty',w_do.idw_Pick.GetITemNUmber(llRowPos,'quantity'))
	
		
///////////////////////////////////////////////////////////  PROBLEM WITH PRICE  ///////////////////////////////////////////////////////////////////////////////	
		//Get the price from owner->Customer->Price Master (See W_DO)
		llOwnerID =  w_do.idw_Pick.GetITemNUmber(llRowPos,'owner_id')
		
		if llOwnerID <> llOwnerPrev then
			
			SELECT owner_cd INTO :lsOwnerCd 
			FROM Owner
			Where Project_id = :gs_project and owner_id = :llOwnerID;
			
			Select user_field3
			Into	 :ls_location_org
			From Customer
			Where Project_id = :gs_project and Cust_Code = :lsOwnerCd;
			
			llOwnerPrev = llOwnerID
			
		end if
		
		// Reset price1 and price 2
		ldprice_1 = 0; ldprice_2 = 0
		
		Select price_1, price_2, currency_cd
		Into	 :ldprice_1, :ldprice_2, :lsCurrency
		From Price_Master
		Where Project_id = :gs_project and sku = :lsSKU and supp_code = 'PANDORA' AND price_class = :ls_location_org;
		
		// If the price is null, set the null price flag.
		if IsNull(ldprice_1) then
			
			// Show message.
			MessageBox ("Can't print Commercial Invoice", "Pricing information is not complete. You will not be able to print the invoice.")
			
		// Otherwise, if the price is NOT null,
		Else	

			// enable the print button.
			im_menu.m_file.m_print.Enabled = TRUE
			
		// End if the price is NOT null.
		End If

		//Always taking the Used Price for CB drives
		dw_Report.SetITem(llNewRow,'unit_value', ldprice_2)
		dw_Report.setitem(llNewRow,"currency", lsCurrency)
		
		//	sum of Delivery_Packing.weight_gross of first row of each distinct Delivery_packing.carton_no
		dw_Report.SetITem(llNewRow,'total_weight', ldGrossWeight) 
		dw_Report.SetITem(llNewRow,'total_pieces',  liPallets) 
		//dw_Report.SetITem(llNewRow,'total_pieces',  string(ll_quantity) + " " + ls_cartontype + " on " + string(liPallets) + " pallets") 
		// All boxes are 'ea' as per paul
		dw_Report.SetITem(llNewRow,'total_pieces',  string(ll_quantity) + " ea. on " + string(liPallets) + " pallets") 
	
		IF w_do.idw_Pack.RowCount() > 0 THEN
			dw_Report.SetITem(llNewRow,'Standard_of_measure',  w_do.idw_Pack.GetItemString(1, "Standard_of_measure"))
		END IF
	
	End If	 /*report row found for SKU/COO*/
	
	// Add carrier tracking number.
	dw_Report.SetITem(llNewRow,'carrier_tracking_no', w_do.idw_Main.GetITemString(1,'awb_bol_no')) // KRZ Added carrier_tracking_no 12/15/09
	
	// Get the cost center.
	f_getcostcenter(llRowPos, ld_costcenter)
			
	dw_Report.SetITem(llNewRow,'cost_center', ld_costcenter) // KRZ Added Cost Center 12/15/09
	
Next /*Pick Row */


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


dw_report.SetRow(1)
dw_report.SetRedraw(True)
SetPointer(Arrow!)





end event

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

public function boolean f_getcostcenter (long al_pickrow, ref decimal ad_cost);nvo_order lnvo_o

// Create the order object.
lnvo_o = Create nvo_order

// Get the cost center.
lnvo_o.f_getcostcenter(al_pickrow, ad_cost)

// Destroy lnvo_o
Destroy lnvo_o

// Return true
return true
end function

public function boolean f_getprice (long al_pickrownumber, string as_sku, ref decimal ad_price);long ll_lineitemno, ll_findrow
boolean lb_return

// Get the item number.
ll_lineitemno = w_do.tab_main.tabpage_pick.dw_pick.getitemnumber(al_pickrownumber, "line_item_no")

// Find the detail row that shares the same sku and line item number.
ll_findrow = w_do.tab_main.tabpage_detail.dw_detail.find("sku='" + string(as_sku) + "' and line_item_no=" + string(ll_lineitemno), 1, w_do.tab_main.tabpage_detail.dw_detail.rowcount())

// If we found the row,
If ll_findrow > 0 then
	
	// Get the price
	lb_return = true
	ad_price = w_do.tab_main.tabpage_detail.dw_detail.getitemnumber(ll_findrow, "price")
	
// Otherwise, if we did not find the row,
Else
	
	// Show an error.
	messagebox("Could not find price", "Please contact SIMS support.")
End If

// Return lb_return
return lb_return
end function

on w_pandora_commercial_invoice_rpt.create
int iCurrent
call super::create
this.sle_totalpieces=create sle_totalpieces
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_totalpieces
end on

on w_pandora_commercial_invoice_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_totalpieces)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-30)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
//
end event

event ue_postopen;call super::ue_postopen;string presentation_str, lsSQl, dwsyntax_str, lsErrText

//We can only print based on DO_NO - User must have valid order open to pass DO_NO in from w_DO
If isVAlid(w_do) Then
	if w_do.idw_main.RowCOunt() > 0 Then
		isDoNo = w_do.idw_main.GetITemString(1,'do_no')
	End If
End If

If isNUll(isDONO) or  isDoNO = '' Then
	Messagebox('Commercial Invoice','You must have an order retrieved in the Delivery Order Window~rbefore you can print the Invoice!')
	Return
End If

//Pack list must be generated
If w_do.idw_pack.RowCount() = 0 Then
	Messagebox('Commercial Invoice','You must generate the Pack List before you can print the Invoice!')
	Return
End If

im_menu.m_file.m_retrieve.Enabled = False

//04/09 - PCONKL - CityBlock needs to be calculated differently - call both in case an order has both types.
This.TriggerEvent('ue_retrieve')
This.TriggerEvent('ue_retrieve_Cityblock')

// Default the total pieces.
sle_totalpieces.text = dw_report.getitemstring(1, "total_pieces")
end event

event ue_retrieve;Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow,  llPalletCount, llFind, llLIneItem, llCount
long ll_quantity, lllineitemsave, llownerid, llownerprev, ll_findrow
String	lsWarehouse, lsCityState, lsContact, lsSKU, lsSupplier, lsDONO, lsDesc, lsskuprev, lscoosave, presentation_str, lsSQl, dwsyntax_str, lsErrText
String	 lsCarton, lsCartonSave, lsCOO,  lsFind, ls_cartontype, lsownercd, ls_location_org, lscurrency
string ls_hts, ls_user_field7, ls_user_field8, ls_user_field9, ls_tel, ls_ship_instr, ls_uom, ls_user_field10
string ls_do, ls_currency_code, ls_ord_type, ls_ord_type_desc, lsNewCarton, lsPrevCarton, lsSerial, ls_skuold
string ls_userfield14, ls_cost, lsmodify,lscustcode,lsvatid
integer liPallets, liRowsPerPAge, liEmptyRows, liMod, liLastExtRow, li_rc
Decimal	ldGrossWeight, ldprice_1, ldprice_2, ld_price, ld_weight, ld_costcenter, ld_fc
str_parms lstrparms

// Set the rows per page.
liRowsPerPage =  5

// If there are no detail rows,
IF w_do.idw_Pack.RowCount() <= 0 THEN
	
	// Show error.
	MessageBox ("Error", "There are no detail rows. Can't print.")
	
// Otherwise, if there are detail rows,
Else

//	//Seagate drive families are stored in Lookup table to allow us to add families a little easier
//	If not isvalid(idsDrives) then
//		idsDrives = Create Datastore
//		presentation_str = "style(type=grid)"
//		lsSQl = "Select * from lookup_table where project_id = 'Pandora' and Code_Type = 'CB-SN' "
//		dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
//		idsDrives.Create( dwsyntax_str, lsErrText)
//		idsDrives.SetTransObject(SQLCA)
//		idsDrives.Retrieve()
//	End If

	// Loop through the packing rows.
	For lLRowPOs = 1 to w_do.idw_Pack.RowCount()
	
		// Get the carton type.
		ls_cartontype = w_do.idw_pack.GetItemString(llRowPos,'carton_type')
		
		// If the cartontype is null, default it to 'ea.'.
		if isnull(ls_cartontype) then ls_cartontype = "ea."
	
		// Get the carton number.
		lsNewCarton = w_do.idw_pack.GetItemString(llRowPos,'Carton_no')
		
		// Aggregate the quantity.
		ll_quantity += w_do.idw_pack.GetItemnumber(llRowPos,'quantity')
		
		// If the carton type has changed,
		if lsNewCarton <> lsPrevCarton then
			
			// Incriment the pallet counter.
			liPallets += 1
			
			// Get the carton weight.
			ld_weight = w_do.idw_pack.GetITemNUmber(llRowPos,'weight_gross')
			
			// If the weight is null, default it to 0.
			if IsNull(ld_weight) then ld_weight = 0
			
			// Aggregate the weight.
			ldGrossWeight += ld_weight
			
		// End if the carton type has changed.
		End If
		
		// Set the previous carton to the current carton.
		lsPrevCarton = lsNewCarton
	
	// Next carton.
	Next
	
	// If the importer address datastore has not been created,
	If NOT isvalid(idsImporterAddress) Then
		
		// Create the importer address datastore.
		idsImporterAddress = Create DataStore
		idsImporterAddress.dataObject = 'd_do_address_alt'
		idsImporterAddress.SetTransObject(sqlca)
	End If
	
	// Get the warehouse and do number.
	lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
	lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')
	lscustcode = w_do.idw_main.GetItemString(1,'cust_code') //15-Oct-2014 :Madhu- To get customer code
	
	select vat_id into :lsvatid from Customer where Project_Id=:gs_project and cust_code=:lscustcode;
	
	// Get the warehouse row from the global project_warehouse datastore.
	llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())
	
	// Clear the report datawindow and set redraw to false.
	dw_report.reset()
	dw_report.SetRedraw(False)
	
	// Get the order type.
	ls_ord_type = w_do.idw_Main.GetITEmString(1,'ord_type')
		
	// Get the order type description.
	SELECT Ord_Type_Desc INTO :ls_ord_type_desc
	FROM Delivery_Order_Type
	WHERE Project_ID = :gs_project AND
	Ord_Type = :ls_ord_type USING SQLCA;
			
	// Get the number of rows on the picking datawindow.	
	lLRowCount = w_do.idw_pick.RowCount()
	
	// Loop through the 'picking' rows.
	For llRowPOs = 1 to llRowCount
		
		// Get the line item and serial numbers.
		llLineItem = w_do.idw_Pick.GetITemNumber(llRowPos,'Line_Item_No')
		lsSerial = w_do.idw_Pick.GetITemString(llRowPos,'Serial_No')
		lsSKU = w_do.idw_Pick.GetITemString(llRowPos,'sku')
		lsCOO = w_do.idw_Pick.GetITemString(llRowPos,'country_of_origin')
		
//		//Determine the SKU from the Serial Number
//		lstrparms.String_arg[1] = lsSerial
//		lstrparms = uf_Determine_SKU(lstrparms)
//		lsSKU = lstrparms.String_arg[1]
//		lsCOO = lstrparms.String_arg[2]
	
		//Don't include CityBlock Generic SKU, they will be reported seperately
		//If w_do.idw_pick.GetITemString(llRowPos,'SKU') = '07013415' Then Continue
		If lsSKU = '07013415' Then Continue

// TAM 2010/03/29 We need to skip pick rows that are part of a Delivery BOM (Component Ind = 'W')
		If w_do.idw_Pick.GetITemString(llRowPos,'component_ind') = 'W' Then Continue
		
		// Find where we have a previous line item in the report dw with the same sku and line item and coo.
		lsFind = "Line_Item = " + String(llLineItem) + " and upper(SKU) = '" + upper(lsSKU) + "' and Upper(Coo) = '" + Upper(lsCOO) + "'"
		llFind = dw_report.Find(lsFind,1,dw_report.RowCount())
		
		// If there is a previous existing line,
		If llFind > 0 Then
		
			// Update the quantity.
			dw_Report.SetITem(llFind,'qty',dw_report.GetITemNumber(llFind,'qty') + w_do.idw_Pick.GetITemNUmber(llRowPos,'quantity')) /*add qty to existing row for SKU/COO*/
			
		// Otherwise, if there is not an existing line,
		Else
			
			// Insert a new row.
			llNewRow = dw_report.InsertRow(0)
			
			// Se the sku and coo for the new row.
			dw_Report.SetITem(llNewRow,'sku',lsSKU)
			dw_Report.SetITem(llNewRow,'coo',lsCOO)
	
			//Exporter/Shipper Info Box
			// If we have a valid warehouse record,
			If llwarehouseRow > 0 Then
			
				// Set the warehouse name and address.
				dw_Report.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
				dw_Report.setitem(llNewRow,"ship_from_addr1",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
				dw_Report.setitem(llNewRow,"ship_from_addr2",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
				dw_Report.setitem(llNewRow,"ship_from_addr3",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
				dw_Report.setitem(llNewRow,"ship_from_addr4",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
			
				// Reset the citystate placeholder.
				lsCityState = ""
			
				// If there is a city,
				If g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') > "" Then
					
					// Add the city to the formatted string.
					lsCityState = g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') + ", "
				End If
			
				// If there is a state,
				If g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') > "" Then
					
					// Add the state to the formatted string.
					lsCityState += g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') + " "
				End If
			
				// If there is a zip,
				If g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip') > "" Then
					
					// Add the zip to the formatted string.
					lsCityState += g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip')
				End If
			
				// Set addr5 to the formatted string.
				dw_Report.setitem(llNewRow,"ship_from_addr5",lsCityState)
			
				// Set the report country, ship from contact and telephone field to the warehouse values.
				dw_Report.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
				dw_Report.setitem(llNewRow,"ship_from_contact",g.ids_project_warehouse.GetITemString(llWarehouseRow,'contact_person'))
				dw_Report.setitem(llNewRow,"ship_from_telephone",g.ids_project_warehouse.GetITemString(llWarehouseRow,'tel'))
			
			// End if we have a valid warehouse record.
			End If
			
			// Set various field values from idw_main and idw_other.
			dw_Report.SetITem(llNewRow,'invoice_no', w_do.idw_Main.GetITemString(1,'invoice_no'))
			dw_Report.setitem(llNewRow,"freight_atd", w_do.idw_other.GetItemDateTime(1,'freight_atd'))
			dw_Report.setitem(llNewRow,"ship_via", w_do.idw_other.GetITEmString(1,'ship_via'))
			dw_Report.setitem(llNewRow,"transport_mode", w_do.idw_other.GetITEmString(1,'transport_mode'))
			
			// Get the cost center.
			//21-Oct-2014 :Madhu- pass DD rowpos value for ANKI -START
			If Upper(gs_project) ='ANKI' THEN
				f_getcostcenter(llNewRow, ld_costcenter) //send the DD.RowPos
			ELSE
				f_getcostcenter(llRowPos, ld_costcenter)
			END IF
			
			li_Rc = dw_Report.SetITem(llNewRow,'cost_center', string(ld_costcenter)) // KRZ Added Cost Center 12/15/09
			dw_Report.SetITem(llNewRow,'carrier_tracking_no', w_do.idw_Main.GetITemString(1,'awb_bol_no')) // KRZ Added carrier_tracking_no 12/15/09
			//messagebox("", w_do.idw_Main.GetITemString(1,'awb_bol_no'))
			dw_Report.SetITem(llNewRow,'tax_id', w_do.idw_Main.GetITemString(1,'vat_id')) // KRZ Added warehouse tax_id 12/16/09
			dw_Report.SetITem(llNewRow,'vat_id', w_do.idw_Main.GetITemString(1,'vat_id')) // KRZ Added customer vat_id 12/16/09
			dw_Report.SetITem(llNewRow,'tax_id', lsvatid) // 15-Oct-2014 :Madhu- Set customer VAT value.

			// Get the do number.
			ls_do = w_do.idw_Main.GetITemString(1,'do_no')
			
			// Set the currency code.			
			dw_Report.setitem(llNewRow,"currency", w_do.idw_detail.GetITemstring(1,'currency_code'))
			
			// Set the order type.
			dw_Report.setitem(llNewRow,"ord_type", ls_ord_type_desc)
			dw_report.Modify("order_type_t.text = '" + ls_ord_type_desc + "'")
			
			// Set the freight terms.
			dw_Report.setitem(llNewRow,"freight_terms", w_do.idw_other.GetITEmString(1,'freight_terms'))
			
			//Customer Address -> Consignee
			dw_Report.SetITem(llNewRow,'consignee_name',w_do.idw_Main.GetITemString(1,'cust_Name'))
			dw_Report.SetITem(llNewRow,'consignee_addr1',w_do.idw_Main.GetITemString(1,'address_1'))
			dw_Report.SetITem(llNewRow,'consignee_addr2',w_do.idw_Main.GetITemString(1,'address_2'))
			dw_Report.SetITem(llNewRow,'consignee_addr3',w_do.idw_Main.GetITemString(1,'address_3'))
			dw_Report.SetITem(llNewRow,'consignee_addr4',w_do.idw_Main.GetITemString(1,'address_4'))
		
			// Reset the citystate string.
			lsCityState = ""
			
			// If there is a valid city, add it to the formatted string.
			If w_do.idw_Main.GetITemString(1,'city') > "" Then lsCityState = w_do.idw_Main.GetITemString(1,'city') + ", "
		
			// If there is a valid state, add it to the formatted string.
			If w_do.idw_Main.GetITemString(1,'state') > "" Then lsCityState += w_do.idw_Main.GetITemString(1,'state') + " "
		
			// If there is a valid zip, add it to the formatted string.
			If w_do.idw_Main.GetITemString(1,'zip') > "" Then lsCityState += w_do.idw_Main.GetITemString(1,'zip') 
		
			// Set the formatted city state zip string on the report.
			dw_Report.SetITem(llNewRow,'consignee_city_state',lsCityState)
		
			// Get the valid contact person if there is one.
			If w_do.idw_Main.GetITemString(1,'contact_person') > "" Then lsContact = w_do.idw_Main.GetITemString(1,'contact_person') 
			if IsNull(lsContact) then lsContact = ""
			// dw_Report.Modify("consignee_contact_t.text='" + lsContact + "'") // don't default consignee name as per Paul T.
		
			// Get the valid phone number if there is one.
			If w_do.idw_Main.GetITemString(1,'tel') > "" Then ls_tel =  w_do.idw_Main.GetITemString(1,'tel') 
			
			// Set he consignee name and telephone number.
			dw_Report.SetITem(llNewRow,'consignee_contact',lsContact)
			dw_Report.SetITem(llNewRow,'consignee_telephone',ls_tel)
			
			// Set the consignee country.
			dw_Report.SetITem(llNewRow,'consignee_country',w_do.idw_Main.GetITemString(1,'country'))
		
			// Retrieve the 'sold to' address for the do number.
			idsImporterAddress.Retrieve(lsdono, 'ST') /*Importer Address*/
		
			// If we got a valid 'sold to' address,
			If idsImporterAddress.RowCount() > 0 Then
			
				// Get the sold to address information.
				//dw_Report.SetITem(llNewRow,'sold_to_name',idsImporterAddress.GetITemString(1,'name'))	// LTK 20110412 No longer populate sold_to_name
				dw_Report.setitem(llNewRow,"sold_to_addr1",idsImporterAddress.GetITemString(1,'address_1'))
				dw_Report.setitem(llNewRow,"sold_to_addr2",idsImporterAddress.GetITemString(1,'address_2'))
				dw_Report.setitem(llNewRow,"sold_to_addr3",idsImporterAddress.GetITemString(1,'address_3'))
				dw_Report.setitem(llNewRow,"sold_to_addr4",idsImporterAddress.GetITemString(1,'address_4'))
			
				// reset the city state formatstring.
				lsCityState = ""
			
				// If we have a valid city, add it to the format string.
				If idsImporterAddress.GetITemString(1,'city') > "" Then lsCityState = idsImporterAddress.GetITemString(1,'city') + ", "
			
				// If we have a valid state, add it to the format string.
				If idsImporterAddress.GetITemString(1,'state') > "" Then lsCityState += idsImporterAddress.GetITemString(1,'state') + " "
			
				// If we have a valid zip, add it to the format string.
				If idsImporterAddress.GetITemString(1,'zip') > "" Then lsCityState += idsImporterAddress.GetITemString(1,'zip')
			
				// Set the 'sold to' city and state formatstring.
				dw_Report.setitem(llNewRow,"sold_to_addr5",lsCityState)
			
				// Set the sold to country.
				dw_Report.setitem(llNewRow,"sold_to_country",idsImporterAddress.GetITemString(1,'country'))
			
				// Set the sold to contact name and telephone number.
				dw_Report.setitem(llNewRow,"sold_to_contact",idsImporterAddress.GetITemString(1,'contact_person'))
				dw_Report.setitem(llNewRow,"sold_to_telephone",idsImporterAddress.GetITemString(1,'tel'))
		
			// End if we got a valid 'sold to' address,
			End If
			
			// Get and Set the shipping instructions.
			ls_ship_instr  = w_do.idw_other.GetITemString(1,'shipping_instructions')
			if IsNull(ls_ship_instr) then ls_ship_instr = ""
			dw_Report.Modify("ship_instr_t.text='" + ls_ship_instr + "'")
				
			// If the quantity is 0, continue to next record.
			If w_do.idw_pick.GetITemNumber(lLRowPOs,'quantity') = 0 Then Continue
				
				// Get the sku, supplier code and line item number.
				lsSKU = w_do.idw_pick.GetITemString(llRowPos,'sku')
				lsSupplier = w_do.idw_pick.GetITemString(llRowPos,'supp_Code')
				llLineItem = w_do.idw_pick.GetITemNumber(llRowPos,'Line_Item_No')
				
				// If this is a different sku,
				If lsSKU <> ls_skuold then
		
					// Select the detail data for this sku.
					Select description, user_field7, user_field8, user_field9, user_field14, UOM_1, user_field10
					Into	 :lsDesc, :ls_user_field7, :ls_user_field8, :ls_user_field9, :ls_userfield14, :ls_uom, :ls_user_field10
					From Item_Master
					Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier
					Using SQLCA;
					
					// If there is an error, show error message.
					if sqlca.sqlcode <> 0 then MessageBox ("DB Error", SQLCA.SQLErrText )
					
				// End if this is a different sku.
				End If
				
				// Set this as the old sku.
				ls_skuold = lsSKU
				
				// IF user field 14 is not null,
				If not isnull(ls_userfield14) then
					
					// Concatentate user field 14 to the description.
					lsDesc = lsDesc + "  " + ls_userfield14
				End If
		
				// Set the SKU, description, unit of measure, line item number, quantity, hts, euhts, eccn and lic.
				dw_Report.SetITem(llNewRow,'sku',w_do.idw_pick.GetITemString(llRowPos,'sku'))
				dw_Report.SetITem(llNewRow,'description',lsDesc)	
				//dw_Report.SetITem(llNewRow,'description2',ls_userfield14)	
				dw_Report.SetITem(llNewRow,'uom',ls_uom)	
				dw_Report.SetITem(llNewRow,'line_item',w_do.idw_pick.GetITemNumber(llRowPos,'Line_Item_No'))
				dw_Report.SetITem(llNewRow,'qty',w_do.idw_pick.GetITemNUmber(llRowPos,'quantity'))
				dw_Report.SetITem(llNewRow,'hts',ls_user_field7)
				dw_Report.SetITem(llNewRow,'euhts',ls_user_field8)		
				dw_Report.SetITem(llNewRow,'eccn',ls_user_field9)
				dw_Report.SetITem(llNewRow,'lic',ls_user_field10)
				
				// If we can get the price,
				If f_getprice(llRowPOs, lsSKU, ld_price) then
	
					// Set the price.
					dw_Report.SetITem(llNewRow,'unit_value', ld_price)
			
					// enable the print button.
					im_menu.m_file.m_print.Enabled = TRUE
				End If
		
				// Set the total weight.		
				dw_Report.SetITem(llNewRow,'total_weight', ldGrossWeight) 
				
				// Were defaulting to 'ea' on pallets but the user can override on the CI itself.
				dw_Report.SetITem(llNewRow,'total_pieces',  string(ll_quantity) + " ea. on " + string(liPallets) + " pallets") 
			
				// If there are pack rows, set the standard of measure.
				IF w_do.idw_Pack.RowCount() > 0 THEN dw_Report.SetITem(llNewRow,'Standard_of_measure',  w_do.idw_Pack.GetItemString(1, "Standard_of_measure"))
					
				// Get and set the country of origin.		
				lsCOO = w_do.idw_pick.GetItemString(llRowPos, "country_of_origin")
				dw_Report.SetITem(llNewRow,'coo',lsCOO)

		//nxjain	31-08-2105
		if gs_project ='ANKI' then
			dw_Report.Modify("t_56.visible=0")
			dw_Report.Modify("t_57.visible=0")
	    end if 
		
		//nxjain end 
			
			// End if there is not an existing line.
			End If
		
	// Next detail row.
	Next
	
	//Jxlim 12/27/2011 BRD #349- Pandora - Add Freight cost for CI 
	ld_fc =  round(w_do.idw_other.GetITemDecimal(1,'freight_cost'), 2)
	If 	Not IsNull (ld_fc) Then		
		dw_Report.setitem(llNewRow,"freight_cost", ld_fc)	
		lsModify += "freight_cost_t.text= '" + String(ld_fc) + "'"		
		dw_report.Modify(lsModify)	
	End If
	
	
	////////////////////////////////////////////// Old Code to be deleted /////////////////////////////////////////////
	//lLRowCount = w_do.idw_detail.RowCount()
	//For llRowPOs = 1 to llRowCount
	//		
	//	//Don't include CityBlock Generic SKU, they will be reported seperately
	//	If w_do.idw_detail.GetITemString(llRowPos,'SKU') = '07013415' Then Continue
	//	
	//	llNewRow = dw_report.InsertRow(0)
	//
	//	//Exporter/Shipper Info Box
	//	
	//	If llwarehouseRow > 0 Then /*warehouse row exists*/
	//	
	//		dw_Report.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
	//		
	//		dw_Report.setitem(llNewRow,"ship_from_addr1",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
	//		dw_Report.setitem(llNewRow,"ship_from_addr2",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
	//		dw_Report.setitem(llNewRow,"ship_from_addr3",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
	//		dw_Report.setitem(llNewRow,"ship_from_addr4",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
	//	
	//		//Format City/State/Zip
	//		lsCityState = ""
	//	
	//		If g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') > "" Then
	//			lsCityState = g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') + ", "
	//		End If
	//	
	//		If g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') > "" Then
	//		lsCityState += g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') + " "
	//		End If
	//	
	//		If g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip') > "" Then
	//			lsCityState += g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip')
	//		End If
	//	
	//		dw_Report.setitem(llNewRow,"ship_from_addr5",lsCityState)
	//	
	//		dw_Report.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
	//	 
	//		ls_warehouse_county = g.ids_project_warehouse.GetITemString(llWarehouseRow,'country')
	//	
	//		dw_Report.setitem(llNewRow,"ship_from_contact",g.ids_project_warehouse.GetITemString(llWarehouseRow,'contact_person'))
	//		dw_Report.setitem(llNewRow,"ship_from_telephone",g.ids_project_warehouse.GetITemString(llWarehouseRow,'tel'))
	//	
	//	
	//	End If
	//	
	//	dw_Report.SetITem(llNewRow,'invoice_no', w_do.idw_Main.GetITemString(1,'invoice_no'))
	//	dw_Report.setitem(llNewRow,"freight_atd", w_do.idw_other.GetItemDateTime(1,'freight_atd'))
	//	dw_Report.setitem(llNewRow,"ship_via", w_do.idw_other.GetITEmString(1,'ship_via'))
	//	dw_Report.setitem(llNewRow,"transport_mode", w_do.idw_other.GetITEmString(1,'transport_mode'))
	//	dw_Report.SetITem(llNewRow,'cost_center', w_do.idw_Main.GetITemString(1,'user_field10')) // KRZ Added Cost Center 12/15/09
	//	dw_Report.SetITem(llNewRow,'carrier_tracking_no', w_do.idw_Main.GetITemString(1,'carrier_tracking_no')) // KRZ Added carrier_tracking_no 12/15/09
	//	dw_Report.SetITem(llNewRow,'tax_id', w_do.idw_Main.GetITemString(1,'vat_id')) // KRZ Added warehouse tax_id 12/16/09 carrier_tracking_no 12/15/09
	//	dw_Report.SetITem(llNewRow,'vat_id', w_do.idw_Main.GetITemString(1,'vat_id')) // KRZ Added customer vat_id 12/16/09
	//	
	//	
	//	string ls_do, ls_currency_code
	//	
	//	ls_do = w_do.idw_Main.GetITemString(1,'do_no')
	//	
	//	SELECT currency_code INTO :ls_currency_code
	//		FROM Delivery_Detail
	//		WHERE do_no = :ls_do AND line_item_no = 1 USING SQLCA;
	//	
	//	
	//	
	//	dw_Report.setitem(llNewRow,"currency", ls_currency_code)
	//	
	//	
	//	
	//	
	//	
	////	ls_ord_type = w_do.idw_Main.GetITEmString(1,'ord_type')
	////	
	////	SELECT Ord_Type_Desc INTO :ls_ord_type_desc
	////		FROM Delivery_Order_Type
	////		WHERE Project_ID = :gs_project AND
	////				Ord_Type = :ls_ord_type USING SQLCA;
	//	
	//	
	//	dw_Report.setitem(llNewRow,"ord_type", ls_ord_type_desc)
	//	
	//	dw_report.Modify("order_type_t.text = '" + ls_ord_type_desc + "'")
	//	
	//	dw_Report.setitem(llNewRow,"freight_terms", w_do.idw_other.GetITEmString(1,'freight_terms'))
	//
	//
	//	//Customer Address -> Consignee
	//	dw_Report.SetITem(llNewRow,'consignee_name',w_do.idw_Main.GetITemString(1,'cust_Name'))
	//	dw_Report.SetITem(llNewRow,'consignee_addr1',w_do.idw_Main.GetITemString(1,'address_1'))
	//	dw_Report.SetITem(llNewRow,'consignee_addr2',w_do.idw_Main.GetITemString(1,'address_2'))
	//	dw_Report.SetITem(llNewRow,'consignee_addr3',w_do.idw_Main.GetITemString(1,'address_3'))
	//	dw_Report.SetITem(llNewRow,'consignee_addr4',w_do.idw_Main.GetITemString(1,'address_4'))
	//
	//	//City State Zip combined
	//	lsCityState = ""
	//	If w_do.idw_Main.GetITemString(1,'city') > "" Then
	//		lsCityState = w_do.idw_Main.GetITemString(1,'city') + ", "
	//	End If
	//
	//	If w_do.idw_Main.GetITemString(1,'state') > "" Then
	//		lsCityState += w_do.idw_Main.GetITemString(1,'state') + " "
	//	End If
	//
	//	If w_do.idw_Main.GetITemString(1,'zip') > "" Then
	//		lsCityState += w_do.idw_Main.GetITemString(1,'zip') 
	//	End If
	//
	//	dw_Report.SetITem(llNewRow,'consignee_city_state',lsCityState)
	//
	//
	//	If w_do.idw_Main.GetITemString(1,'contact_person') > "" Then
	//		lsContact = w_do.idw_Main.GetITemString(1,'contact_person') 
	//	End If
	//
	//	String ls_tel
	//
	//	If w_do.idw_Main.GetITemString(1,'tel') > "" Then
	//		ls_tel =  w_do.idw_Main.GetITemString(1,'tel') 
	//	End If
	//	
	//
	//	dw_Report.SetITem(llNewRow,'consignee_contact',lsContact)
	//	dw_Report.SetITem(llNewRow,'consignee_telephone',ls_tel)
	//	
	//	if IsNull(lsContact) then lsContact = ""
	//	
	//	dw_Report.Modify("consignee_contact_t.text='" + lsContact + "'")
	//
	//	dw_Report.SetITem(llNewRow,'consignee_country',w_do.idw_Main.GetITemString(1,'country'))
	//
	//	idsImporterAddress.Retrieve(lsdono, 'ST') /*Importer Address*/
	//
	//
	//	If idsImporterAddress.RowCount() > 0 Then
	//	
	//		dw_Report.SetITem(llNewRow,'sold_to_name',idsImporterAddress.GetITemString(1,'name'))
	//		dw_Report.setitem(llNewRow,"sold_to_addr1",idsImporterAddress.GetITemString(1,'address_1'))
	//		dw_Report.setitem(llNewRow,"sold_to_addr2",idsImporterAddress.GetITemString(1,'address_2'))
	//		dw_Report.setitem(llNewRow,"sold_to_addr3",idsImporterAddress.GetITemString(1,'address_3'))
	//		dw_Report.setitem(llNewRow,"sold_to_addr4",idsImporterAddress.GetITemString(1,'address_4'))
	//	
	//		//Format City/State/Zip
	//		lsCityState = ""
	//	
	//		If idsImporterAddress.GetITemString(1,'city') > "" Then
	//			lsCityState = idsImporterAddress.GetITemString(1,'city') + ", "
	//		End If
	//	
	//		If idsImporterAddress.GetITemString(1,'state') > "" Then
	//		lsCityState += idsImporterAddress.GetITemString(1,'state') + " "
	//		End If
	//	
	//		If idsImporterAddress.GetITemString(1,'zip') > "" Then
	//			lsCityState += idsImporterAddress.GetITemString(1,'zip')
	//		End If
	//	
	//		dw_Report.setitem(llNewRow,"sold_to_addr5",lsCityState)
	//	
	//		dw_Report.setitem(llNewRow,"sold_to_country",idsImporterAddress.GetITemString(1,'country'))
	//	
	//	
	//		dw_Report.setitem(llNewRow,"sold_to_contact",idsImporterAddress.GetITemString(1,'contact_person'))
	//		dw_Report.setitem(llNewRow,"sold_to_telephone",idsImporterAddress.GetITemString(1,'tel'))
	//
	//			
	//	End If
	//	
	//		string ls_ship_instr
	//	
	//		ls_ship_instr  = 	GetITemString(1,'shipping_instructions')
	//	
	//
	//
	//		if IsNull(ls_ship_instr) then ls_ship_instr = ""
	//		
	//		dw_Report.Modify("ship_instr_t.text='" + ls_ship_instr + "'")
	//		
	//		
	//
	//		
	//		If w_do.idw_Detail.GetITemNumber(lLRowPOs,'alloc_qty') = 0 Then Continue
	//		
	//		lsSKU = w_do.Idw_Detail.GetITemString(llRowPos,'sku')
	//		lsSupplier = w_do.Idw_Detail.GetITemString(llRowPos,'supp_Code')
	//		llLineItem = w_do.Idw_Detail.GetITemNumber(llRowPos,'Line_Item_No')
	//
	//		string ls_uom, ls_user_field10
	//
	//		Select description, user_field7, user_field8, user_field9, UOM_1, user_field10
	//		Into	 :lsDesc, :ls_user_field7, :ls_user_field8, :ls_user_field9, :ls_uom, :ls_user_field10
	//		From Item_Master
	//		Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
	//		
	//		if sqlca.sqlcode <> 0 then
	//			MessageBox ("DB Error", SQLCA.SQLErrText )
	//		end if
	//
	//		dw_Report.SetITem(llNewRow,'sku',w_do.idw_detail.GetITemString(llRowPos,'sku'))
	//		dw_Report.SetITem(llNewRow,'description',lsDesc)	
	//		dw_Report.SetITem(llNewRow,'uom',ls_uom)	
	//		
	//		dw_Report.SetITem(llNewRow,'line_item',w_do.idw_detail.GetITemNumber(llRowPos,'Line_Item_No'))
	//		dw_Report.SetITem(llNewRow,'qty',w_do.idw_detail.GetITemNUmber(llRowPos,'alloc_qty'))
	//
	//		//HTS field.  If the 'From Warehouse' is in the US, grab Item_Master.UF7 and if not, grab Item_master.UF8
	//
	//		//HTS:	Item_master.User_field7
	//		//EUHTS:	Item_master.User_field8
	//		//ECCN:	Item_master.User_field9
	//		//LIC:	Item_master.User_field10
	//		//
	//		
	//
	////		IF Trim(Upper(ls_warehouse_county)) = 'US' THEN 
	////			ls_hts = ls_user_field7
	////		ELSE
	////			ls_hts = ls_user_field8
	////		END IF
	//
	//		dw_Report.SetITem(llNewRow,'hts',ls_user_field7)
	//		dw_Report.SetITem(llNewRow,'euhts',ls_user_field8)		
	//		dw_Report.SetITem(llNewRow,'eccn',ls_user_field9)
	//		dw_Report.SetITem(llNewRow,'lic',ls_user_field10)
	//		
	//		
	//		
	//		ld_price = w_do.idw_detail.GetITemNUmber(llRowPos,'price')
	//
	//		if IsNull(ld_price) then
	//			
	//			ib_null_price = true
	//			
	//		end if
	//	
	//
	//		dw_Report.SetITem(llNewRow,'unit_value', ld_price)
	//
	////	sum of Delivery_Packing.weight_gross of first row of each distinct Delivery_packing.carton_no
	//
	//	//dw_Report.SetITem(llNewRow,'carton_Count', w_do.idw_Main.GetITemNumber(1,'ctn_cnt')) 
	//	dw_Report.SetITem(llNewRow,'total_weight', ldGrossWeight) 
	//	dw_Report.SetITem(llNewRow,'total_pieces',  string(ll_quantity) + " " + ls_cartontype + " on " + string(liPallets) + " Pallets") 
	//	
	//	IF w_do.idw_Pack.RowCount() > 0 THEN
	//		dw_Report.SetITem(llNewRow,'Standard_of_measure',  w_do.idw_Pack.GetItemString(1, "Standard_of_measure"))
	//	
	//	END IF
	//
	//
	//
	//	lsCOO = w_do.idw_pack.GetItemString(llRowPos, "country_of_origin")
	//
	//	dw_Report.SetITem(llNewRow,'coo',lsCOO)
	//	
	//Next /*detail Row */
	
	
	//--
	
	
	
	
	
	// 04/09 - PCONKL - Empty lines will be added in ue_retieve_cityblock
	
	
	//Add any necessary empty rows so sumamry is at bottom of last page
	//liEmptyRows = 0
	//If dw_report.RowCount() < liRowsPerPage Then
	//	liEmptyRows = liRowsPerPage - dw_report.RowCount()
	//ElseIf dw_report.RowCount() > liRowsPerPage Then
	//	liMod = Mod(dw_report.RowCount(), liRowsPerPage)
	//	If liMod > 0 Then
	//		liEmptyRows = liRowsPerPage - liMod
	//	End IF
	//End If
	//
	//If liEmptyRows > 0 Then
	//	For llRowPos = 1 to liEmptyRows
	//		dw_report.InsertRow(0)
	//	Next
	//End If
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Set the first row as active.
	dw_report.SetRow(1)
	
	// Set redraw to true.
	dw_report.SetRedraw(True)
	
// End if there are detail rows,
End If




end event

type dw_select from w_std_report`dw_select within w_pandora_commercial_invoice_rpt
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

type cb_clear from w_std_report`cb_clear within w_pandora_commercial_invoice_rpt
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_pandora_commercial_invoice_rpt
integer x = 32
integer y = 12
integer width = 3483
integer height = 2056
integer taborder = 30
string dataobject = "d_pandora_commercial_invoice"
boolean hscrollbar = true
end type

event dw_report::itemchanged;// Ancestor Override!!

end event

type sle_totalpieces from singlelineedit within w_pandora_commercial_invoice_rpt
integer x = 2158
integer y = 1632
integer width = 1262
integer height = 64
integer taborder = 40
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean border = false
end type

event modified;long ll_numrows, ll_rownum

// Get the number of rows.
ll_numrows = dw_report.rowcount()

// Loop through the rows.
For ll_rownum = 1 to ll_numrows
	
	// Set the total pieces text on the datawindow.
	dw_report.setitem(ll_rownum, "total_pieces", text)
	
// Next Row
Next
end event

event getfocus;setfocus()
selecttext(1, len(text))
end event

