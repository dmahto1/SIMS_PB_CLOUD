$PBExportHeader$w_philips-th_delivery_note_rpt.srw
$PBExportComments$Philips Singapore Delivery Note
forward
global type w_philips-th_delivery_note_rpt from w_std_report
end type
end forward

global type w_philips-th_delivery_note_rpt from w_std_report
integer width = 3639
integer height = 3176
string title = "Philips Thailand Delivery Note"
event ue_retrieve_returns ( )
end type
global w_philips-th_delivery_note_rpt w_philips-th_delivery_note_rpt

type variables

end variables

event ue_retrieve_returns();Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llFind, llLIneItem
String	lsWarehouse,  lsSKU, lsSupplier, lsAltSku, lsRONO, lsDesc, lsInvType, lsPONO
String	lsFind,lsUF7, lsUF8, lsUF9, lsUOM, lsPhilipsInvType
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText
String	lsName, lsAddr1, lsAddr2, lsAddr3, lsAddr4, lsCity, lsState, lsZip, lsCountry, lsContact, lsTel
DataStore	ldsNotes, ldsSoldToAddress
Int	liRowsPerPAge, liEmptyRows, liMod,  liNotePos
Decimal	ldGrossWeight, ldNetWeight, ldNetVolume, ldGrossVolume
String lsDistrict



liRowsPerPage =  8

SetPointer(Hourglass!)


lsWarehouse = w_ro.idw_Main.GetITEmString(1,'wh_Code')
lsRoNO = w_ro.idw_Main.GetITEmString(1,'ro_no')


//ldsSoldToAddress = Create DataStore
//ldsSoldToAddress.dataObject = 'd_do_address_alt'
//ldsSoldToAddress.SetTransObject(sqlca)
//	
//ldsSoldToAddress.Retrieve(lsdono, 'ST') /*Sold To Address*/


//Notes
ldsNotes = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select Note_seq_No, Note_Text, Line_Item_No from Receive_Notes Where ro_no = '" + lsroNO + "'"
dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsNotes.Create( dwsyntax_str, lsErrText)
ldsNotes.SetTransObject(SQLCA)

ldsNotes.Retrieve()

ldsNotes.SetSort("Line_Item_No A, Note_Seq_No A")
ldsNotes.Sort()
	
//Ship To - From Alt Address Table
Select Name, Address_1, Address_2, Address_3, Address_4, city, state, zip, Country, Contact_person, Tel, district
Into :lsName, :lsAddr1, :lsAddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry, :lsContact, :lsTel, :lsDistrict
From Receive_alt_address
Where Project_id = :gs_project and ro_no = :lsRONO and Address_type = 'RC';
	
llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

dw_report.reset()
dw_report.SetRedraw(False)

lLRowCount = w_ro.idw_Putaway.RowCount()
For llRowPOs = 1 to llRowCount

	lsSKU = w_ro.idw_Putaway.GetITemString(llRowPos,'sku')
	lsSupplier = w_ro.idw_Putaway.GetITemString(llRowPos,'supp_Code')
	lsInvType = w_ro.idw_Putaway.GetITemString(llRowPos,'inventory_Type')
	llLineItem = w_ro.idw_Putaway.GetITemNumber(llRowPos,'Line_Item_No')
		
	If w_ro.idw_Putaway.GetITemNumber(lLRowPOs,'quantity') = 0 Then Continue
	
	//Roll Up To To Line/SKU/Inventory Type
	LsFind = "po_line = " + String(llLineItem) + " and SKU = '" + lsSKU + "' and Inventory_Type = '" + lsInvType + "'"
		
	llFind = dw_report.Find(lsFind,1,dw_report.RowCount())
	If llFind > 0 Then
		
		dw_report.SetItem(llFind,'quantity',dw_report.GetITemNumber(llFind,'quantity') + w_ro.idw_Putaway.GetITemNumber(lLRowPOs,'quantity')) /*add to existing Row*/
		Continue
		
	End If
	
	
	//Insert a new report Row
	
	llNewRow = dw_report.InsertRow(0)

	//Header Notes (up to 4 rows)
	liNotePos = 0
	llFind = ldsNotes.Find("Line_Item_No = 0",1,ldsNotes.RowCount()) /* line_item = 0 for header Notes*/
	Do While llFind > 0 AND llFind <= ldsNotes.RowCount()
		
		if ldsNotes.GetITemNumber(llFind,"Note_seq_No") = 1 then
			
			dw_Report.setitem(llNewRow,"return_reason",ldsNotes.GetITemString(llFind,"note_Text"))
			llFind ++
		else
		
			liNotePos ++
			lsNotePos = "header_remarks" + String(liNotePos)
			dw_Report.setitem(llNewRow,lsNotePos,ldsNotes.GetITemString(llFind,"note_Text"))
			
			llFind ++
			If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
				llFind = 0
			Else
				llFind = ldsNotes.Find("Line_Item_No = 0",llFind,ldsNotes.RowCount())
			End IF
			
		End if
		
	Loop
	
	//Line Notes (up to 4 rows - into a single line of text) 
	liNotePos = 0
	lsNoteText = ""
	llFind = ldsNotes.Find("Line_Item_No = " + string(llLineItem),1,ldsNotes.RowCount()) 
	Do While llFind > 0 AND  llFind <= ldsNotes.RowCount()
		
		liNotePos ++
		lsNoteText += ldsNotes.GetITemString(llFind,"note_Text") + char(10)
				
		llFind ++
		If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
			llFind = 0
		Else
			llFind = ldsNotes.Find("Line_Item_No = " + string(llLineItem),llFind,ldsNotes.RowCount())
		End If
		
	Loop
	
	dw_report.SetItem(llNewRow,"Line_Remarks",lsNoteText)
	
	
	//Ship From Info Box
	If llwarehouseRow > 0 Then /*warehouse row exists*/
	
		//Hard code MMD for Plant SGT5, otherwise take from Warehouse
		dw_Report.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
				
		dw_Report.setitem(llNewRow,"ship_from_addr1",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
		dw_Report.setitem(llNewRow,"ship_from_addr2",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
		dw_Report.setitem(llNewRow,"ship_from_addr3",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
		dw_Report.setitem(llNewRow,"ship_from_addr4",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
		dw_Report.setitem(llNewRow,"ship_from_city",g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
		dw_Report.setitem(llNewRow,"ship_from_state",g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
		dw_Report.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
		dw_Report.setitem(llNewRow,"ship_from_zip",g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))

 
	End If
	
	dw_Report.SetITem(llNewRow,'do_number', w_ro.idw_Main.GetITemString(1,'supp_invoice_no'))
	
	//DO_TYpe
	dw_Report.SetITem(llNewRow,'DO_TYPE','Customer Return')
	
	
	//DO REceipt and DElivery Date
	dw_Report.SetITem(llNewRow,'DO_receipt_dateTime',w_ro.idw_Main.GetITemDateTime(1,'ord_date'))
	dw_Report.SetITem(llNewRow,'delivery_date',w_ro.idw_Main.GetITemDateTime(1,'arrival_Date'))
	
	dw_Report.SetITem(llNewRow,'sales_order_nbr',w_ro.idw_Main.GetITemString(1,'supp_order_no'))

	
	
	
	dw_Report.SetITem(llNewRow,'ship_to_code',w_ro.idw_Main.GetITemString(1,'User_Field10'))
	dw_Report.SetITem(llNewRow,'ship_to_name',lsName)
	dw_Report.SetITem(llNewRow,'ship_to_addr1',lsAddr1)
	dw_Report.SetITem(llNewRow,'ship_to_addr2',lsAddr2)
	dw_Report.SetITem(llNewRow,'ship_to_addr3',lsAddr3)
	dw_Report.SetITem(llNewRow,'ship_to_addr4',lsAddr4)
	dw_Report.SetITem(llNewRow,'ship_to_city',lsCity)
	dw_Report.SetITem(llNewRow,'ship_to_state',lsState)
	dw_Report.SetITem(llNewRow,'ship_to_zip',lsZip)
	dw_Report.SetITem(llNewRow,'ship_to_country',lsCountry)
	dw_Report.SetITem(llNewRow,'ship_to_contact',lsContact)
	dw_Report.SetITem(llNewRow,'ship_to_tel',lsTel)
	dw_Report.SetITem(llNewRow,'ship_to_district',lsDistrict)

	 
	
	//Item MAster values
	ldNetWEight = 0
	
	Select alternate_Sku, description, user_field7, user_field8, user_field9, UOM_1, weight_1
	Into	 :lsAltSku,:lsDesc, :lsUF7, :lsUF8, :lsUF9, :lsUOM, :ldNetWEight
	From Item_Master
	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
		
	if sqlca.sqlcode <> 0 then
		MessageBox ("DB Error", SQLCA.SQLErrText )
	end if
	
	dw_Report.SetITem(llNewRow,'sku',lsSKU)
	dw_Report.SetITem(llNewRow,'description',lsDesc)	
	dw_Report.SetITem(llNewRow,'uom',lsUOM)	
	dw_Report.SetITem(llNewRow,'alt_Sku',lsAltSku)
//	dw_Report.SetITem(llNewRow,'twelve_nc',lsUF7)
	dw_Report.SetITem(llNewRow,'conversion_Factor',lsUF9)
	
	dw_Report.SetITem(llNewRow,'product_no_id',lsUF7)	
	
	
	If isnull(ldNetWeight)Then ldNetWeight = 0
	dw_Report.SetITem(llNewRow,'net_weight',ldNetWEight)
	
	//Volume
	If isnumber(lsUF8) Then
		dw_Report.SetITem(llNewRow,'net_volume',Dec(lsUF8))
	Else
		dw_Report.SetITem(llNewRow,'net_volume',0)
	End If
	
	dw_Report.SetITem(llNewRow,'po_line',llLineItem)
	dw_Report.SetITem(llNewRow,'quantity',w_ro.idw_Putaway.GetITemNUmber(llRowPos,'quantity'))
	

	//Convert Menlo Inv Type to Philips
	Choose case trim(upper(w_ro.idw_Putaway.GetITemString(llRowPos,'inventory_type')))
	Case "1"
		lsPhilipsInvType = "0001"
	Case "2"
		lsPhilipsInvType = "0002"
	Case "4"
		lsPhilipsInvType = "0004"
	Case "5"
		lsPhilipsInvType = "0005"
	Case "6"
		lsPhilipsInvType = "0006"
	Case "9"
		lsPhilipsInvType = "0009"
	Case "A"
		lsPhilipsInvType = "0010"
	Case "B"
		lsPhilipsInvType = "0021"
	Case "C"
		lsPhilipsInvType = "0022"
	Case "D"
		lsPhilipsInvType = "0023"
	Case "E"
		lsPhilipsInvType = "0024"
	Case "F"
		lsPhilipsInvType = "0025"
	Case Else
		lsPhilipsInvType = w_ro.idw_Putaway.GetITemString(llRowPos,'inventory_type')
	End Choose
	
	dw_Report.SetITem(llNewRow,'inventory_desc',lsPhilipsInvType)
	dw_Report.SetITem(llNewRow,'inventory_type',w_ro.idw_Putaway.GetITemString(llRowPos,'inventory_type'))
	dw_Report.SetITem(llNewRow,'plant_Code',w_ro.idw_Main.GetITemString(1,'Supp_Code')) /*plant code used to determine which logo to display*/
		
	//Plant/Invoice From & Company Registration
	Choose Case Upper(w_ro.idw_Main.GetITemString(1,'Supp_Code'))
			
		Case "SG10"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','SG10 / 830144')
			dw_Report.SetITem(llNewRow,'company_registration','199705989C')
		Case "SG71"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','SG71 / 830386')
			dw_Report.SetITem(llNewRow,'company_registration','199705989C')
		Case "SG00"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','SG00 / 830143')
			dw_Report.SetITem(llNewRow,'company_registration','199705989C')
		Case "SG03"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','SG03 / 832445')
			dw_Report.SetITem(llNewRow,'company_registration','199705989C')
		Case "SGT5"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','SGT5 / 834002 ')
			dw_Report.SetITem(llNewRow,'company_registration','200822460K')
		Case "SGQ1"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','SGQ1 / 900043 ')
			dw_Report.SetITem(llNewRow,'company_registration','201114879N')
		Case "MYQ0"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','MYQ0 / 900023 ')
			dw_Report.SetITem(llNewRow,'company_registration','952853M')
			
	End Choose
	
	//PO NBR from Delivery Detail (UF3)
	llFind = w_ro.idw_Detail.Find("Line_Item_No = " + String(llLineItem),1,w_ro.idw_Detail.RowCount())
	If llFind > 0 Then
		dw_Report.SetITem(llNewRow,'po_nbr',w_ro.idw_Detail.GetITemString(llFind,'User_Field3')) 
	End If
	
Next /*Putaway Row */

//Calculate Gross Volume and Gross Weight
ldGrossWEight = 0
ldGrossVolume = 0

lLRowCount = dw_report.RowCount()
For llRowPos = 1 to lLRowCount
	
	ldGrossWeight += dw_report.GetItemDecimal(llRowPos,'net_weight') * dw_report.GetItemNumber(lLRowPos,'quantity')
	ldGrossVolume += dw_report.GetItemDecimal(llRowPos,'net_volume') * dw_report.GetItemNumber(lLRowPos,'quantity')
	
Next

dw_report.Modify("gross_Weight_t.text='" + String(ldGrossWeight,"#########.0000") + " KG'")
dw_report.Modify("total_volume_t.text='" + String(ldGrossVolume,"#########.0000") + " CDM'")

//Show in Override DW (users need to be able to override Weight and Volume
dw_select.SetITem(1,'total_weight',ldGrossWeight)
dw_select.SetITem(1,'total_volume',ldGrossVolume)

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

dw_report.SetSort("po_line A")
dw_report.Sort()

dw_report.SetRedraw(True)
SetPointer(arrow!)

If dw_Report.RowCount() > 0 Then
	im_menu.m_file.m_print.Enabled = TRUE
End If

end event

on w_philips-th_delivery_note_rpt.create
call super::create
end on

on w_philips-th_delivery_note_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() -100,workspaceHeight()-100)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
//
end event

event ue_postopen;call super::ue_postopen;String	lsDONO, lsRONO

im_menu.m_file.m_retrieve.Enabled = False


//Printing from either W_DO or W_RO (but not both at the same time)
If isVAlid(w_do) and isValid(w_ro) Then
	Messagebox('Delivery/Return Note','You can only have either a Delivery order or a Return Order open - but not both!',Stopsign!)
	Return
End If

If isVAlid(w_do) Then
	
	if w_do.idw_main.RowCOunt() > 0 Then
		lsDONO = w_do.idw_main.GetITemString(1,'do_no')
	End If
	
	If isNUll(lsDONO) or  lsDONO = '' Then
		Messagebox('Delivery Note','You must have an order retrieved in the Delivery Order Window~rbefore you can print the Delivery Note!')
		Return
	End If

	//Pack list must be generated
	If w_do.idw_pack.RowCount() = 0 Then
		Messagebox('Delivery Note','You must generate the Pack List before you can print the Delivery Note!')
		Return
	End If

	dw_report.dataobject = 'd_philips-th_delivery_note'
	This.TriggerEvent('ue_retrieve')
	
ElseIf isVAlid(w_ro) Then /*Return Order*/
	
	if w_ro.idw_main.RowCOunt() > 0 Then
		lsrONO = w_ro.idw_main.GetITemString(1,'ro_no')
	End If
	
	If isNUll(lsrONO) or  lsrONO = '' Then
		Messagebox('Goods Return Note','You must have a Return order retrieved in the Receive Order Window~rbefore you can print the Return Note!')
		Return
	End If
	
	if w_ro.idw_main.RowCOunt() > 0 Then
		If w_ro.idw_main.GetITemString(1,'ord_type') <> 'X' Then
			Messagebox('Goods Return Note','You must have a Return order retrieved in the Receive Order Window~rbefore you can print the Return Note!')
			Return
		End If
	End If
	
	dw_report.dataobject = 'd_philips-th_return_note'
	This.TriggerEvent('ue_retrieve_Returns')
	
Else
	
	Messagebox('Delivery/Return Note','You must have either a Delivery order or a Return Order open!',Stopsign!)
	Return
	
End If

end event

event ue_retrieve;Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llFind, llLIneItem
String	lsWarehouse,  lsSKU, lsSupplier, lsAltSku, lsDONO, lsDesc, lsInvType, lsPONO, lsPlant, lsSerial
String	lsFind,lsUF7, lsUF8, lsUF9, lsUOM, lsPhilipsInvType
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText
DataStore	ldsNotes, ldsSoldToAddress, ldsserial
Int	liRowsPerPAge, liEmptyRows, liMod,  liNotePos
Decimal {4} ldGrossWeight, ldNetWeight, ldNetVolume, ldGrossVolume




liRowsPerPage =  8

SetPointer(Hourglass!)


lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')
lsPlant = w_do.idw_Main.GetITemString(1,'User_Field3')


ldsSoldToAddress = Create DataStore
ldsSoldToAddress.dataObject = 'd_do_address_alt'
ldsSoldToAddress.SetTransObject(sqlca)
	
ldsSoldToAddress.Retrieve(lsdono, 'BT') /*Sold To Address*/


//Notes
ldsNotes = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select Note_seq_No, Note_Text, Line_Item_No from Delivery_Notes Where do_no = '" + lsDoNO + "'"
dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsNotes.Create( dwsyntax_str, lsErrText)
ldsNotes.SetTransObject(SQLCA)

ldsNotes.Retrieve()

ldsNotes.SetSort("Line_Item_No A, Note_Seq_No A")
ldsNotes.Sort()
	
////For Malaysia Plant code (MY10), we want to print Serial Numbers
//If lsPlant = "MY10" Then
//	
//	ldsSerial = Create Datastore
//	presentation_str = "style(type=grid)"
//
//	lsSQl = " Select Delivery_serial_detail.Serial_No, Delivery_serial_detail.Quantity, "
//	lsSQL += " Delivery_Picking_Detail.Line_Item_No, Delivery_Picking_Detail.SKU, Delivery_Picking_Detail.Supp_Code, Delivery_Picking_Detail.Inventory_Type "
//	lsSQL += " From Delivery_Picking_Detail, Delivery_Serial_Detail "
//	lsSQL += " Where Delivery_Picking_Detail.ID_NO = Delivery_Serial_Detail.ID_NO "
//	lsSQL += " and Delivery_Picking_Detail.do_no = '" + lsDONO + "'"
//
//
//	dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
//	ldsSerial.Create( dwsyntax_str, lsErrText)
//	ldsSerial.SetTransobject(sqlca)
//	ldsSerial.Retrieve()
//	
//End If /* Malaysia */


llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

dw_report.reset()
dw_report.SetRedraw(False)

lLRowCount = w_do.idw_Pick.RowCount()
For llRowPOs = 1 to llRowCount

	lsSKU = w_do.idw_Pick.GetITemString(llRowPos,'sku')
	lsSupplier = w_do.idw_Pick.GetITemString(llRowPos,'supp_Code')
	lsInvType = w_do.idw_Pick.GetITemString(llRowPos,'inventory_Type')
	llLineItem = w_do.idw_Pick.GetITemNumber(llRowPos,'Line_Item_No')
		
	
	If w_do.idw_Pick.GetITemNumber(lLRowPOs,'quantity') = 0 Then Continue
	
	//Roll Up To To Line/SKU/Inventory Type
	LsFind = "po_line = " + String(llLineItem) + " and SKU = '" + lsSKU + "' and Inventory_Type = '" + lsInvType + "'"
		
	llFind = dw_report.Find(lsFind,1,dw_report.RowCount())
	If llFind > 0 Then
		
		dw_report.SetItem(llFind,'quantity',dw_report.GetITemNumber(llFind,'quantity') + w_do.idw_Pick.GetITemNumber(lLRowPOs,'quantity')) /*add to existing Row*/
		Continue
		
	End If
	
	
	//Insert a new report Row
	
	llNewRow = dw_report.InsertRow(0)

	//Header Notes (up to 4 rows)
	liNotePos = 0
	llFind = ldsNotes.Find("Line_Item_No = 0",1,ldsNotes.RowCount()) /* line_item = 0 for header Notes*/
	Do While llFind > 0
		
		liNotePos ++
		lsNotePos = "header_remarks" + String(liNotePos)
		dw_Report.setitem(llNewRow,lsNotePos,ldsNotes.GetITemString(llFind,"note_Text"))
		
		llFind ++
		If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
			llFind = 0
		Else
			llFind = ldsNotes.Find("Line_Item_No = 0",llFind,ldsNotes.RowCount())
		End If
		
	Loop
	
	//Line Notes (up to 4 rows - into a single line of text) 
	liNotePos = 0
	lsNoteText = ""
	llFind = ldsNotes.Find("Line_Item_No = " + string(llLineItem),1,ldsNotes.RowCount()) 
	Do While llFind > 0
		
		liNotePos ++
		lsNoteText += ldsNotes.GetITemString(llFind,"note_Text") + char(10)
				
		llFind ++
		If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
			llFind = 0
		Else
			llFind = ldsNotes.Find("Line_Item_No = " + string(llLineItem),llFind,ldsNotes.RowCount())
		End If
		
	Loop
	
	dw_report.SetItem(llNewRow,"Line_Remarks",lsNoteText)
	
	
	//Ship From Info Box
	If llwarehouseRow > 0 Then /*warehouse row exists*/
	

		dw_Report.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
		
		
		dw_Report.setitem(llNewRow,"ship_from_addr1",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
		dw_Report.setitem(llNewRow,"ship_from_addr2",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
		dw_Report.setitem(llNewRow,"ship_from_addr3",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
		dw_Report.setitem(llNewRow,"ship_from_addr4",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
		dw_Report.setitem(llNewRow,"ship_from_city",g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
		dw_Report.setitem(llNewRow,"ship_from_state",g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
		dw_Report.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
		dw_Report.setitem(llNewRow,"ship_from_zip",g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
	 	
	End If
	
	dw_Report.SetITem(llNewRow,'do_number', w_do.idw_Main.GetITemString(1,'invoice_no'))
	dw_Report.SetITem(llNewRow,'route', w_do.idw_Main.GetITemString(1,'USer_Field2'))
	
//	//DO_TYpe
//	If lsPlant = "MY10" Then /*No DO Type for Malaysia */
//	Else
//		If Upper(w_do.idw_Main.GetITemString(1,'country')) <> 'SG' and w_do.idw_Main.GetITemString(1,'country') <> 'SINGAPORE' Then
//			dw_Report.SetITem(llNewRow,'DO_TYPE','Export')
//		Elseif Upper(w_do.idw_Main.GetITemString(1,'USer_Field2')) = 'SG9999' Then
//			dw_Report.SetITem(llNewRow,'DO_TYPE','Self Collection')
//		Elseif Upper(w_do.idw_Main.GetITemString(1,'USer_Field2')) = 'SGM9' Then /* 09/09 - PCONKL */
//			dw_Report.SetITem(llNewRow,'DO_TYPE','STO')
//		Else
//			dw_Report.SetITem(llNewRow,'DO_TYPE','Normal Delivery')
//		End If
//	End If
	
	//DO REceipt and DElivery Date
	dw_Report.SetITem(llNewRow,'DO_receipt_dateTime',w_do.idw_Main.GetITemDateTime(1,'ord_date'))
	dw_Report.SetITem(llNewRow,'delivery_date',w_do.idw_Main.GetITemDateTime(1,'request_Date'))
	
	dw_Report.SetITem(llNewRow,'sales_order_nbr',w_do.idw_Main.GetItemString(1,'cust_order_no'))

		
	//Ship To
	dw_Report.SetITem(llNewRow,'ship_to_code',w_do.idw_Main.GetITemString(1,'cust_code'))
	dw_Report.SetITem(llNewRow,'ship_to_name',w_do.idw_Main.GetITemString(1,'cust_Name'))
	dw_Report.SetITem(llNewRow,'ship_to_addr1',w_do.idw_Main.GetITemString(1,'address_1'))
	dw_Report.SetITem(llNewRow,'ship_to_addr2',w_do.idw_Main.GetITemString(1,'address_2'))
	dw_Report.SetITem(llNewRow,'ship_to_addr3',w_do.idw_Main.GetITemString(1,'address_3'))
	dw_Report.SetITem(llNewRow,'ship_to_addr4',w_do.idw_Main.GetITemString(1,'address_4'))
	dw_Report.SetITem(llNewRow,'ship_to_addr5',w_do.idw_Main.GetITemString(1,'user_field16'))
	dw_Report.SetITem(llNewRow,'ship_to_city',w_do.idw_Main.GetITemString(1,'city'))
	dw_Report.SetITem(llNewRow,'ship_to_state',w_do.idw_Main.GetITemString(1,'state'))
	dw_Report.SetITem(llNewRow,'ship_to_zip',w_do.idw_Main.GetITemString(1,'zip'))
	dw_Report.SetITem(llNewRow,'ship_to_country',w_do.idw_Main.GetITemString(1,'country'))
	dw_Report.SetITem(llNewRow,'ship_to_contact',w_do.idw_Main.GetITemString(1,'contact_person'))
	dw_Report.SetITem(llNewRow,'ship_to_tel',w_do.idw_Main.GetITemString(1,'tel'))
	dw_Report.SetITem(llNewRow,'ship_to_district',w_do.idw_Main.GetITemString(1,'district'))
	
	
	//Sold To Address
	If ldsSoldToAddress.RowCount() > 0 Then
	
		dw_Report.SetITem(llNewRow,'sold_to_name',ldsSoldToAddress.GetITemString(1,'name'))
		dw_Report.setitem(llNewRow,"sold_to_addr1",ldsSoldToAddress.GetITemString(1,'address_1'))
		dw_Report.setitem(llNewRow,"sold_to_addr2",ldsSoldToAddress.GetITemString(1,'address_2'))
		dw_Report.setitem(llNewRow,"sold_to_addr3",ldsSoldToAddress.GetITemString(1,'address_3'))
		dw_Report.setitem(llNewRow,"sold_to_addr4",ldsSoldToAddress.GetITemString(1,'address_4'))
		dw_Report.setitem(llNewRow,"sold_to_district",ldsSoldToAddress.GetITemString(1,'district'))
		dw_Report.setitem(llNewRow,"sold_to_city",ldsSoldToAddress.GetITemString(1,'city'))
		dw_Report.setitem(llNewRow,"sold_to_state",ldsSoldToAddress.GetITemString(1,'state'))
		dw_Report.setitem(llNewRow,"sold_to_zip",ldsSoldToAddress.GetITemString(1,'zip'))
		dw_Report.setitem(llNewRow,"sold_to_country",ldsSoldToAddress.GetITemString(1,'country'))
			
	End If
	
	//Item MAster values
	ldNetWEight = 0
	
	Select alternate_Sku, description, user_field7, user_field8, user_field9, UOM_1, weight_1
	Into	 :lsAltSku,:lsDesc, :lsUF7, :lsUF8, :lsUF9, :lsUOM, :ldNetWEight
	From Item_Master
	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
		
	if sqlca.sqlcode <> 0 then
		MessageBox ("DB Error", SQLCA.SQLErrText )
	end if
	
	dw_Report.SetITem(llNewRow,'sku',lsSKU)
	dw_Report.SetITem(llNewRow,'description',lsDesc)	
	dw_Report.SetITem(llNewRow,'uom',lsUOM)	
	dw_Report.SetITem(llNewRow,'alt_Sku',lsAltSku)
	dw_Report.SetITem(llNewRow,'twelve_nc',lsUF7)
	dw_Report.SetITem(llNewRow,'conversion_Factor',lsUF9)
	
	dw_Report.SetITem(llNewRow,'product_no_id',lsUF7)	
	
	If isnull(ldNetWeight)Then ldNetWeight = 0
	dw_Report.SetITem(llNewRow,'net_weight',ldNetWEight)
	
	//Volume
	If isnumber(lsUF8) Then
		dw_Report.SetITem(llNewRow,'net_volume',Dec(lsUF8))
	Else
		dw_Report.SetITem(llNewRow,'net_volume',0)
	End If
	
	dw_Report.SetITem(llNewRow,'po_line',llLineItem)
	dw_Report.SetITem(llNewRow,'quantity',w_do.idw_Pick.GetITemNUmber(llRowPos,'quantity'))
	

	//Convert Menlo Inv Type to Philips
	Choose case upper(w_do.idw_Pick.GetITemString(llRowPos,'inventory_type'))
	Case "1"
		lsPhilipsInvType = "0001"
	Case "2"
		lsPhilipsInvType = "0002"
	Case "4"
		lsPhilipsInvType = "0004"
	Case "5"
		lsPhilipsInvType = "0005"
	Case "6"
		lsPhilipsInvType = "0006"
	Case "9"
		lsPhilipsInvType = "0009"
	Case "A"
		lsPhilipsInvType = "0010"
	Case "B"
		lsPhilipsInvType = "0021"
	Case "C"
		lsPhilipsInvType = "0022"
	Case "D"
		lsPhilipsInvType = "0023"
	Case "E"
		lsPhilipsInvType = "0024"
	Case "F"
		lsPhilipsInvType = "0025"
	Case Else
			lsPhilipsInvType = w_do.idw_Pick.GetITemString(llRowPos,'inventory_type')
		End Choose
	
	dw_Report.SetITem(llNewRow,'inventory_desc',lsPhilipsInvType)
	dw_Report.SetITem(llNewRow,'inventory_type',w_do.idw_Pick.GetITemString(llRowPos,'inventory_type'))
	dw_Report.SetITem(llNewRow,'plant_Code',lsPlant) /*plant code used to determine which logo to display*/
		
	//Plant/Invoice From & Company Registration
	Choose Case Upper(w_do.idw_Main.GetITemString(1,'User_Field3'))
			
		Case "SG10"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','SG10 / 830144')
			dw_Report.SetITem(llNewRow,'company_registration','199705989C')
		Case "SG71"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','SG71 / 830386')
			dw_Report.SetITem(llNewRow,'company_registration','199705989C')
		Case "SG00"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','SG00 / 830143')
			dw_Report.SetITem(llNewRow,'company_registration','199705989C')
		Case "SG03"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','SG03 / 832445')
			dw_Report.SetITem(llNewRow,'company_registration','199705989C')
		Case "SGT5"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','SGT5 / 834002 ')
			dw_Report.SetITem(llNewRow,'company_registration','200822460K')
		Case "MY10"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','MY10')	
		Case "SGQ1"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','SGQ1 / 900043 ')
			dw_Report.SetITem(llNewRow,'company_registration','201114879N')
		Case "MYQ0"
			dw_Report.SetITem(llNewRow,'plant_invoice_From','MYQ0 / 900023 ')
			dw_Report.SetITem(llNewRow,'company_registration','952853M')
				
			
	End Choose
	
	//PO NBR from Delivery Detail (UF3)
	llFind = w_do.idw_Detail.Find("Line_Item_No = " + String(llLineItem),1,w_do.idw_Detail.RowCount())
	If llFind > 0 Then
		dw_Report.SetITem(llNewRow,'po_nbr',w_do.idw_Detail.GetITemString(llFind,'User_Field3')) 
	End If
	
	
Next /*Picking Row */

//Calculate Gross Volume and Gross Weight
ldGrossWEight = 0
ldGrossVolume = 0

lLRowCount = dw_report.RowCount()
For llRowPos = 1 to lLRowCount
	
	ldGrossWeight += dw_report.GetItemDecimal(llRowPos,'net_weight') * dw_report.GetItemDecimal(lLRowPos,'quantity')
	ldGrossVolume += dw_report.GetItemDecimal(llRowPos,'net_volume') * dw_report.GetItemDecimal(lLRowPos,'quantity')
	
Next

dw_report.Modify("gross_Weight_t.text='" + String(ldGrossWeight,"#########.0000") + " KG'")
dw_report.Modify("total_volume_t.text='" + String(ldGrossVolume,"#########.0000") + " CDM'")

//Show in Override DW (users need to be able to override Weight and Volume
dw_select.SetITem(1,'total_weight',ldGrossWeight)
dw_select.SetITem(1,'total_volume',ldGrossVolume)


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
//		dw_report.InsertRow(0)
	Next
End If

dw_report.SetSort("po_line A")
dw_report.Sort()

dw_report.SetRedraw(True)
SetPointer(arrow!)

If dw_Report.RowCount() > 0 Then
	im_menu.m_file.m_print.Enabled = TRUE
End If

end event

event ue_print;//Ancestor overridden 

String	lsDONO, lsType
Int		llCount

// check print count before printing and prompt if already printed

//Either from Delivery master or Receive Master
If isVAlid(w_do) Then /*Delivery Order */

	lsType = "Delivery"
	lsDONO = w_do.idw_Main.GetITemString(1,'do_no')

	Select Delivery_Note_Print_Count into :llCount
	From Delivery_MAster
	Where do_no = :lsDONO;
	
Else /*Return (Inbound) ORder */
	
	lsType = "Return"
	lsDONO = w_ro.idw_Main.GetITemString(1,'ro_no')

	Select Delivery_Note_Print_Count into :llCount
	From Receive_MAster
	Where ro_no = :lsDONO;
	
End If
	
If isnull(llCount) Then llCount = 0
	
If llCount > 0 Then
	If Messagebox("Print " + lsType + " Note","This " + lsType + " Note has already been printed. Do you want to continue?",Stopsign!,yesNo!,2) = 2 Then
		Return
	End If
End If

OpenWithParm(w_dw_print_options,dw_report) 
//If printed successfully, update Print count on Delivery_Master
If message.doubleparm = 1 then
		
	llCount ++
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	If isVAlid(w_do) Then /*Delivery Order */
	
		Update Delivery_Master
		Set Delivery_Note_Print_Count = :llCount
		Where do_no = :lsDONO;
		
	Else /* Return Order */
		
		Update Receive_Master
		Set Delivery_Note_Print_Count = :llCount
		Where ro_no = :lsDONO;
		
	End If
	
	Execute Immediate "COMMIT" using SQLCA;
	
End If
end event

type dw_select from w_std_report`dw_select within w_philips-th_delivery_note_rpt
event ue_populate_dropdowns ( )
event ue_process_enter pbm_dwnprocessenter
boolean visible = false
integer x = 41
integer y = 96
integer width = 2624
integer height = 116
string dataobject = "d_philips-sg_delivery_note_weights"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::itemerror;Return 1
end event

event dw_select::itemchanged;call super::itemchanged;
Choose Case Upper(dwo.name)
		
	Case "TOTAL_WEIGHT"
		dw_report.Modify("gross_Weight_t.text='" + String(Dec(data),"#########.0000") + " KG'")
	Case "TOTAL_VOLUME"
		dw_report.Modify("total_volume_t.text='" + String(Dec(data),"#########.0000") + " CDM'")
		
End Choose
end event

type cb_clear from w_std_report`cb_clear within w_philips-th_delivery_note_rpt
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_philips-th_delivery_note_rpt
integer x = 0
integer y = 12
integer width = 3483
integer height = 1908
integer taborder = 30
boolean hscrollbar = true
end type

