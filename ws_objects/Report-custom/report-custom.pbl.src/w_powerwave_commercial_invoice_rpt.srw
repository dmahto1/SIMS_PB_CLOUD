$PBExportHeader$w_powerwave_commercial_invoice_rpt.srw
$PBExportComments$Powerwave Commercial Invoice Report
forward
global type w_powerwave_commercial_invoice_rpt from w_std_report
end type
end forward

global type w_powerwave_commercial_invoice_rpt from w_std_report
integer width = 3653
integer height = 2356
string title = "Powerwave Commercial Invoice"
end type
global w_powerwave_commercial_invoice_rpt w_powerwave_commercial_invoice_rpt

type variables
string is_origsql, isCustomer
string is_origsql2, isOrder
long il_long

Boolean	ibIsustomerHCL
String	isremit_name,isRemit_addr1, isRemit_addr2,isRemit_addr3, isRemit_Addr4, isRemit_city, isRemit_state, isRemit_zip, isRemit_country

DataStore	idsPick, idsBillToAddress, idsNotes, idsImporterAddress
String isDoNo
end variables

on w_powerwave_commercial_invoice_rpt.create
call super::create
end on

on w_powerwave_commercial_invoice_rpt.destroy
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
	Messagebox('Labels','You must have an order retrieved in the Delivery Order Window~rbefore you can print the Invoice!')
	Return
End If

//Pack list must be generated
If w_do.idw_pack.RowCount() = 0 Then
	Messagebox('Labels','You must generate the Pack List before you can print the Invoice!')
	Return
End If

//05/07 - PCONKL - custom CI for HCL India

If Pos(Upper(w_do.idw_Main.GetITemString(1,'cust_name')),'HCL') > 0 and  Upper(w_do.idw_Main.GetITemString(1,'country')) = "IN" Then
	ibisustomerhcl = True
	dw_report.dataobject = 'd_powerwave_commercial_invoice_hcl'	
Else
	ibisustomerhcl = False
	
	// 03/08 - PCONKL - Seperate version for Suzhou warehouse
	If w_do.idw_Main.GetITemString(1,'wh_code') = 'PWAVE-SUZ' Then
		dw_report.dataobject = 'd_powerwave_commercial_invoice_suz'	
	End If
	
End If

This.TriggerEvent('ue_retrieve')

end event

event ue_retrieve;Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llPickPos, llPickCount, llPalletCount, llNotesCount, llNotesPos, llFind, llLIneItem, llCount
String	lsWarehouse, lsCityState, lsContact, lsSKU, lsSupplier, lsDONO, lsDesc, lsHTS, lsLicense, lsPlainText, lscarrier, lsSCAC, lsCountry
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsheaderNotes, lsCarton, lsCartonSave, lsNotify, lsRC, lsCOO, lsFind, lsExtIntInd, lsVersion
String	lsSpecialInstructions, lsChinaHTS, lsCanadaHTS, lsEuropeHTS
//DataStore	ldsPick, ldsBillToAddress, ldsNotes, ldsImporterAddress
Int	liRowsPerPAge, liEmptyRows, liMod, liLastExtRow
Decimal	ldGrossWeight

//Number of rows per page - we will want to insert enough rows on the last page so the sumamry is at the bottom
// 05/07 - for Custom HCL CI, we can fit less due to added literals for desc
If ibIsustomerHCL Then
	liRowsPerPage = 9
Else
	liRowsPerPage = 14 /* testing with standard - production on A4 in Europe*/
End If

//Create Pick Datastore...
If not isvalid(idsPick) Then
	idsPick = Create Datastore
	presentation_str = "style(type=grid)"
	lsSQl = "Select Country_Of_Origin, Sum(Quantity) as Quantity from Delivery_Picking Group by Country_of_Origin" /*We'll add do_no, sku and group by below*/
	dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
	idsPick.Create( dwsyntax_str, lsErrText)
	idsPick.SetTransObject(SQLCA)
End IF

//Delivery Notes
If NOt isvalid(idsNotes) Then
	
	idsNotes = Create Datastore
	presentation_str = "style(type=grid)"

	lsSQl = "Select note_type, Note_seq_No, Note_Text, Line_Item_No from Delivery_Notes Where do_no = '" + w_do.idw_Main.GetITEmString(1,'do_no') + "'"
	lsSql += " and note_type = 'H'"

	dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
	idsNotes.Create( dwsyntax_str, lsErrText)
	idsNotes.SetTransObject(SQLCA)
	
End If

llNotesCount = idsNotes.Retrieve()
idsNotes.SetSort("Note_type A, Note_Seq_No A")
idsNotes.Sort()

//Extract header Notes...
For llNotesPos = 1 to llNotesCount
	
	//If more than 5 notes rows, don't add a CR/LF after each one, we will need to use available space
	lsheaderNotes += idsNotes.GetITemString(llNotesPos,'Note_text') 
	
	If llNotesCount > 5 Then
		lsHeaderNotes += "  "
	Else
		lsHeaderNOtes += "~r"
	End If
	
Next

If NOT isvalid(idsImporterAddress) Then
	
	idsImporterAddress = Create DataStore
	idsImporterAddress.dataObject = 'd_do_address_alt'
	idsImporterAddress.SetTransObject(sqlca)
	
End If

If NOT isvalid(idsBillToAddress) Then
	
	idsBillToAddress = Create DataStore
	idsBillToAddress.dataObject = 'd_do_address_alt'
	idsBillToAddress.SetTransObject(sqlca)
	
End IF

lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')

//01/08 - PCONKL - Ship From Address needs to come from Warehouse table
llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

dw_report.reset()
dw_report.SetRedraw(False)


//Get Pallet Count...
Select Count(Distinct carton_no) into :llPalletCount
From Delivery_Packing
Where do_no = :lsDONO and carton_type like 'pallet%';

//Get Gross Weight...
For lLRowPOs = 1 to w_do.idw_Pack.RowCount()
	lsCarton = w_do.idw_pack.GetITemString(llRowPos,'carton_no')
	If lsCarton <> lsCArtonSave Then
		ldGrossWeight += w_do.idw_pack.GetITemNUmber(llRowPos,'weight_gross')
	End If
	lsCartonSave = lsCarton
Next

// Retrieve Bill To and Importer Addresses

// 05/08 - PCONKL - For Suzhou, We really want the On Behalf Of Address record
If  lsWarehouse = 'PWAVE-SUZ' Then
	idsBillToAddress.Retrieve(lsdono, 'OB') /*On Behalf of Address*/
Else
	idsBillToAddress.Retrieve(lsdono, 'BT') /*Bill To Address*/
End If


idsImporterAddress.Retrieve(lsdono, 'IM') /*Importer Address*/

lsNotify = ''

//Set NOtify (Importer address)
If idsImporterAddress.RowCount() > 0 Then
	
	If idsImporterAddress.GetItemString(1,"name") > "" Then
		lsNotify = idsImporterAddress.GetItemString(1,"name") + "~r"
	End If
	
	If idsImporterAddress.GetItemString(1,"address_1") > "" Then
		lsNotify += idsImporterAddress.GetItemString(1,"address_1") + "~r"
	End If
	
	If idsImporterAddress.GetItemString(1,"address_2") > "" Then
		lsNotify += idsImporterAddress.GetItemString(1,"address_2") + "~r"
	End If
	
	If idsImporterAddress.GetItemString(1,"tel") > "" Then
		lsNotify += "tel: " + idsImporterAddress.GetItemString(1,"tel") 
	End If
		
End If

// 03/08 - PCONKL - For Suzhou warehouse, we might be adding a static VAT # to the end of the NOtify info based on particluar customer or ship to Country
// version also being set in the header
//Also including static Special Instructions...
//If Importer (lsNotify) not sent on DM record (lsnotify = '' before adding static vat), add static text here as well
If  w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
	
	lsversion = 'A1' /*default*/
	
	//If  w_do.idw_Main.GetITEmString(1,'cust_code') = '16572' and Upper(w_do.idw_Main.GetITEmString(1,'cust_name')) = 'ASG DHL EXPRESS'  Then
	//If  w_do.idw_Main.GetITEmString(1,'cust_code') = '1880' and Upper(w_do.idw_Main.GetITEmString(1,'cust_name')) = 'RAYCOM'  Then /*A2*/
	If  w_do.idw_Main.GetITEmString(1,'cust_code') = '1880' and Upper(w_do.idw_Main.GetITEmString(1,'country')) = 'SE'  Then /*A2 - 12/08 - PCONKL*/
		
		//If no importer address, set static text
		If lsNotify = '' Then
			lsNotify = "POWERWAVE TECHNOLOGIES SWEDEN AB"
		End If
		
		lsNotify += "~r" +  'VAT # SE556458086701'
		lsversion = 'A2'
		
		//lsSpecialInstructions = "FREIGHT BILL: POSW01 WCC"
		
	ElseIf  w_do.idw_Main.GetITEmString(1,'cust_code') = '1031' and Upper(w_do.idw_Main.GetITEmString(1,'City')) = 'EERSEL'  Then /*A4*/
		
		//If no importer address, set static text
//		If lsNotify = '' Then
//			lsNotify = "POWERWAVE TECHNOLOGIES SWEDEN AB"
//		End If
		
		//lsNotify += "~r" +  'VAT # NL8159.53.744.B.01'
		lsNotify += "~r" +  'POWERWAVE TECHNOLOGIES, INC. ~rVAT # NL8171.80.424.B.01' /* 12/08 - PCONKL */
		lsNotify += "~r" +  '1801 E. ST ANDREW PLACE' /* 03/09 - PCONKL */
		lsNotify += "~r" +  'SANTA ANA, CA 92705 USA' /* 03/09 - PCONKL */
		lsversion = 'A4'
		lsSpecialInstructions = "ROUTE SHIPMENT THRU AMS CEVA FISCAL REP, ON-FORWARD TO ULTIMATE CONSIGNEE."
		
		dw_report.modify("on_behalf_of_t.text='ON BEHALF OF/SELLER'") /* 12/08 - PCONKL - modify header*/
		
	ElseIf  w_do.idw_Main.GetITEmString(1,'cust_code') = '1031' and (Upper(w_do.idw_Main.GetITEmString(1,'City')) = 'CARSON' or Upper(w_do.idw_Main.GetITEmString(1,'City')) = 'SANTA ANA')  Then /*A7*/
		
		//If no importer address, set static text
		If lsNotify = '' Then
			lsNotify = "POWERWAVE TECHNOLOGIES, INC. C/O CEVA"
		End If
		
		lsversion = 'A7'
		lsSpecialInstructions = "BILL TO POTE03 WCC" 
		
	ElseIf  w_do.idw_Main.GetITEmString(1,'cust_code') = '9380' Then /*A8*/
		
		//If no importer address, set static text
		If lsNotify = '' Then
			lsNotify = "SYMBOL TECHNOLOGIES, INC."
		End If
		
		lsversion = 'A8'
		
	ElseIf  w_do.idw_Main.GetITEmString(1,'cust_code') = '6240' Then /*A9 */
		
		//If no importer address, set static text
		If lsNotify = '' Then
			lsNotify = "SYRMA TECHNOLOGY PRIVATE LIMITED"
		End If
		
		lsversion = 'A9'
		lsSpecialInstructions = "WCC" /* 12/08 - PCONKL */
		
	ElseIf  w_do.idw_Main.GetITEmString(1,'cust_code') = '1174' Then /*A10*/
		
		//If no importer address, set static text
		If lsNotify = '' Then
			lsNotify = "BROKER GONDRAND AT DIEPPE"
		End If
		
		lsNotify += "~r" +  'VAT # FR55338966385' 
		lsversion = 'A10'
	//	lsSpecialInstructions = "FREIGHT BILL: POSW01" 
		
	ElseIf  w_do.idw_Main.GetITEmString(1,'cust_code') = '1150' Then /*A11*/
		
		//If no importer address, set static text
		If lsNotify = '' Then
			lsNotify = "FLEXTRONICS-ENTREPOT TELIS"
		End If
		
		lsNotify += "~r" +  'VAT # FR32479733230' 
		lsversion = 'A11'
	//	lsSpecialInstructions = "DOC SWAP REQUIRED - SERVICE TYPE: WOCC - POSW01" 
		
	Else /*Check if in European Union - 12/08 - PCONKL - Exclude GB, DE, FI, SE and EE */
		
		lsCountry = w_do.idw_Main.GetITEmString(1,'country')
		Choose Case Len(lsCountry) /* 2 or 3 char country code */
				
			Case 2
				
				Select Count(*) into : llCount
				From Country
				Where designating_Code = :lsCountry and eu_country_Ind = 'Y' and designating_code Not in ('GB', 'DE', 'FI', 'SE', 'EE');
				
			Case 3
				
				Select Count(*) into : llCount
				From Country
				Where iso_Country_cd = :lsCountry and eu_country_Ind = 'Y' and designating_code Not in ('GBR', 'DEU', 'FIN', 'SWE', 'EST');
				
			Case Else
				
				llCount = 0
				
		End Choose
		
	End If
	
	
	//If llCount > 0 Then /*EU Country - A3 */
	If llCount > 0 and Left(Upper(w_do.idw_Main.GetITEmString(1,'user_field7')),3) = "DDP" Then /*EU Country - A3 */ //12/08 - PCONKL - Only A3 if Incoterms (UF7) begins with "DDP"
	
		//If no importer address, set static text
//		If lsNotify = '' Then
//			lsNotify = "POWERWAVE TECHNOLOGIES SWEDEN AB"
//		End If
		
		//lsNotify += "~r" +  'VAT # NL8159.53.744.B.01' 
		lsNotify += "~r" +  'POWERWAVE TECHNOLOGIES, INC. ~rVAT # NL8171.80.424.B.01' /* 12/08 - PCONKL */
		lsversion = 'A3'
		
		//lsSpecialInstructions = "ROUTE SHIPMENT THRU AMS UTI FISCAL REP, ON-FORWARD TO ULTIMATE CONSIGNEE. SERVICE TYPE: WCC-POSW01" 
		lsSpecialInstructions = "ROUTE SHIPMENT THRU AMS CEVA FISCAL REP, ON-FORWARD TO ULTIMATE CONSIGNEE." /* changed 12/08 - PCONKL*/
		
		dw_report.modify("on_behalf_of_t.text='ON BEHALF OF/SELLER'") /* 12/08 - PCONKL - modify header*/
		
	End If
	
	//12/08 - PCONKL - If A1, modify Heading
	If lsversion = 'A1' or lsversion = 'A3' or lsversion = 'A4' Then
		dw_report.modify("ultimate_consignee_t.text='ULTIMATE CONSIGNEE/SHIP TO CUSTOMER:'") 
	End If
	
//	//If A1 and no importer, set static text
//	If lsversion = 'A1' and lsNotify = '' Then
//		lsNotify = "CHECK FOR ‘SHIPPING INSTRUCTIONS"
//	End If
	
End If /* Suzhou Warehouse*/

//12/07 - For Suzhou we will need to print 'External'. We will also trigger event to print internal version (same data and format but with Internal prices and literal) For Eersel we will not.
If lsWarehouse = 'PWAVE-SUZ' Then
	lsExtIntInd = lsVersion + 'E'
Else
	lsExtIntInd = ''
End If

//True Carrier Name is in SCAC Code
lsCarrier = w_do.idw_Main.GetITemString(1,'carrier')

Select SCAC_Code into :lsSCAC
From Carrier_master
Where Project_id = :gs_project and carrier_Code = :lscarrier;

If lsSCAC = "" or isnull(lscarrier) Then lsScac = lsCarrier

//For each Detail Record
lLRowCount = w_do.idw_detail.RowCount()
For llRowPOs = 1 to llRowCount
	
	If w_do.idw_Detail.GetITemNumber(lLRowPOs,'alloc_qty') = 0 Then Continue
	
	//Line Item should be in UF5 (Oracle Line vs our assigned line). If not present, copy it over
	If isNull(w_do.idw_Detail.GetITemString(llRowPos,'user_field5')) or w_do.idw_Detail.GetITemString(llRowPos,'user_field5') = "" Then
		w_do.idw_detail.SetItem(llRowPos,'user_Field5',String(w_do.idw_Detail.GetITemNumber(llRowPos,'Line_Item_No')))
	End If
	
	//Set the Currency label on the column heading...
	If w_do.idw_Detail.GetITemString(llRowPos,'user_Field3') > "" Then
		dw_report.Modify("unit_price_t.text = 'UNIT PRICE~~r(" +  w_do.idw_Detail.GetITemString(llRowPos,'user_Field3') + ")'")
		dw_report.Modify("total_price_t.text = 'TOTAL PRICE~~r(" +  w_do.idw_Detail.GetITemString(llRowPos,'user_Field3') + ")'")
		dw_report.Modify("total_value_t.text = 'TOTAL VALUE~~r(" +  w_do.idw_Detail.GetITemString(llRowPos,'user_Field3') + ")'")
	End IF
	
	lsSKU = w_do.Idw_Detail.GetITemString(llRowPos,'sku')
	lsSupplier = w_do.Idw_Detail.GetITemString(llRowPos,'supp_Code')
	llLineItem = w_do.Idw_Detail.GetITemNumber(llRowPos,'Line_Item_No')
	
	//Retrieve Item Master Values
	// 05/08 - PCONKL - Moved HTS from UF1 to UF9
	Select description, User_Field9,  user_field14, User_Field6, User_Field7, User_Field8
	Into	 :lsDesc, :lsHTS,  :lsPlainText, :lsChinaHTS, :lsCanadaHTS, :lsEuropeHTS
	From ITem_MAster
	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
	
	//Descripion is Description + Plain level Description
	If lsPlainText > "" Then
		lsDesc += "~r" + lsPlainText
	End If
	
	//We may have multiple COO's on Picking, Need a row for Sum of each COO,
	//create a datastore dynamically with COO, Sum Qty by DO_NO - only needed if we have multiple COO's
	
	idsPick.SetSqlSelect("Select Country_of_Origin, Sum(Quantity) as Quantity from Delivery_Picking Where do_no = '" + lsDoNO + "' and sku = '" + lsSKU + "' and Line_item_No = " + String(llLineItem) + " Group by Country_of_Origin")
	llPickCOunt = idsPick.Retrieve()
		
	For llPickPos = 1 to llPickCount
	
		//Rollup to Line Item (Oracle in UF5), SKU and COO
		lsFind = "Line_Item = " + w_do.idw_Detail.GetITemString(llRowPos,'user_Field5')
		
		//Sku should be coming from UF 4 (Legacy SKU) - only taking from SKU field if not present
		If w_do.idw_Detail.GetITemString(llRowPos,'user_field4') > "" Then
			lsFind += " and SKU = '" + w_do.idw_Detail.GetITemString(llRowPos,'user_field4') + "'"
		Else
			lsFind += " and SKU = '" + w_do.idw_Detail.GetITemString(llRowPos,'sku') + "'"
		End If
		
		//If 3 char COO, convert to 2 char
		If Pos(Upper(idsPick.GetITemString(llPickPos,'country_of_Origin')),'XX') = 0 Then
			lsCOO = idsPick.GetITemString(llPickPos,'country_of_Origin')
			If len(lsCOO) = 3 Then
				llFind = g.ids_Country.Find("Upper(iso_country_cd) = '" + upper(lsCOO) + "'",1,g.ids_Country.RowCOunt())
				If llFind > 0 Then
					lsCOO = g.ids_Country.getITemString(llFind,'designating_code')
				End If
			End If
		Else
			lsCOO = ""
		End If
		
		//12/08 - PCONKL - For SUZhou, Hardcode COO to 'CN' for all CI
		If  w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
			lsCOO = 'CN'
		End If
		
		lsFind += " and coo = '" + lsCoo + "'"
		llFind = dw_Report.Find(lsFind,1,dw_report.RowCount())
		
		If llFind > 0 Then
			
			dw_report.SetItem(llFind,'qty',dw_Report.GetITemNUmber(llFind,'qty') + idsPick.GetITemNUmber(llPickPos,'quantity'))
			
		Else
			
			llNewRow = dw_report.InsertRow(0)
			
			//12/07 - For new Suzhou warehouse we need to print external and internal. This (the original) will be the External
			// We will print the internal one afterwards and ensure there is a page break.
			
				dw_Report.SetItem(llNewRow,'ext_int_ind',lsExtIntInd)
				
			//Bill To (mapped to Shipper on CI)
			// 05/08 - PCONKL - For Suzhou, this is actually 'On Behalf Of' - Address Type OB instead of BT - retreival changed above*/
		 
			If idsBillToAddress.RowCount() > 0 Then
			
				dw_report.SetITem(llNewRow,'shipper_name',idsBillToAddress.GetItemString(1,"name"))
				dw_report.SetITem(llNewRow,'shipper_addr1',idsBillToAddress.GetItemString(1,"address_1"))
				dw_report.SetITem(llNewRow,'shipper_addr2',idsBillToAddress.GetItemString(1,"address_2"))
				dw_report.SetITem(llNewRow,'shipper_addr3',idsBillToAddress.GetItemString(1,"address_3"))
				dw_report.SetITem(llNewRow,'shipper_addr4',idsBillToAddress.GetItemString(1,"address_4"))
		
		
				//City, Stae Zip in a single field
				If idsBillToAddress.GetItemString(1,"city") > "" Then
					lsCityState = idsBillToAddress.GetItemString(1,"City") + ", "
				End IF
	
				If idsBillToAddress.GetItemString(1,"state") > "" Then
					lsCityState += idsBillToAddress.GetItemString(1,"state")+ " "
				End If
	
				If idsBillToAddress.GetItemString(1,"zip") > "" Then
					lsCityState += idsBillToAddress.GetItemString(1,"zip")
				End If
	
				dw_report.SetITem(llNewRow,'shipper_city_state',lsCityState)

				//Contact + Phone NUmber in same field
				If idsBillToAddress.GetItemString(1,"contact_person") > "" Then
					lsContact = "Contact: " + idsBillToAddress.GetItemString(1,"contact_Person") + "   "
				End IF
	
				//Contact + Phone NUmber in same field
				If idsBillToAddress.GetItemString(1,"tel") > "" Then
					lsContact += "tel: " + idsBillToAddress.GetItemString(1,"tel") 
				End IF
	
				dw_report.SetITem(llNewRow,'shipper_contact',lsContact)
		
			End If /*Bill To Address exists*/
	
			//Header fields
			dw_Report.SetITem(llNewRow,'invoice_no', w_do.idw_Main.GetITemString(1,'invoice_no'))
			dw_Report.SetITem(llNewRow,'sales_order_no', w_do.idw_Main.GetITemString(1,'user_Field6')) /*powerwave Sales ORder NUmber -> User Field6*/
			dw_Report.SetITem(llNewRow,'cust_order_No', w_do.idw_Main.GetITemString(1,'cust_order_no'))
			dw_Report.SetITem(llNewRow,'carrier', lsSCAC)
			dw_Report.SetITem(llNewRow,'hawb', w_do.idw_Main.GetITemString(1,'awb_bol_no'))
			dw_Report.SetITem(llNewRow,'mawb', w_do.idw_Main.GetITemString(1,'user_field2')) /*master AWB -> User Field 2*/
			dw_Report.SetITem(llNewRow,'shipping_method', w_do.idw_Main.GetITemString(1,'ship_via'))
			dw_Report.SetITem(llNewRow,'incoterms', w_do.idw_Main.GetITemString(1,'user_Field7')) /*incoterms ->User Field 7*/
			dw_Report.SetITem(llNewRow,'payment_Terms', w_do.idw_Main.GetITemString(1,'user_Field4')) /*Payment Terms ->User Field 4*/
			dw_Report.SetITem(llNewRow,'notify_party', lsNotify) 
			dw_Report.SetITem(llNewRow,'carton_Count', w_do.idw_Main.GetITemNumber(1,'ctn_cnt')) 
			dw_Report.SetITem(llNewRow,'gross_Weight', ldGrossWeight) 
			dw_Report.SetITem(llNewRow,'pallet_Count', llPalletCount) 
	
			//01/08 - PCONKL - Ship From Address needs to come from Warehouse table
			If llwarehouseRow > 0 Then /*warehouse row exists*/
	
				dw_Report.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
				
				// For Suzhou, users mayu need to override the first line of the SHip from - If UF 11 is present, use that instead of Warehouse Name
				If w_do.idw_Main.GetItemString(1,'User_Field11') > '' and w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
					dw_Report.SetITem(llNewRow,'ship_from_name',w_do.idw_Main.GetItemString(1,'User_Field11'))
				End If
		
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
			
			End If
	
			//Special Instructions are Shipping Instructions from DM record plus any header level notes
			//05/08 - PCONKL - We are creating the Header Notes from the Shipping Instructions when loading the order
			//						If we concatonate them here, we are duplicating them
						
			If w_do.idw_Main.GetITemString(1,'shipping_instructions') > "" Then
				lsHeaderNOtes = w_do.idw_Main.GetITemString(1,'shipping_instructions') + lsheaderNOtes
			End If
			
			//12/08 - PCONKL - For SUZ, WE are only taking from Special Instructions on DO
			If  w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
				lsHeaderNOtes = w_do.idw_Main.GetITemString(1,'shipping_instructions')
				If isnull(lsHeaderNotes) Then lsHeaderNotes = ''
			End If
			
			//For Suzou, we are also adding static Instructions
			If  w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
				lsHeaderNotes += lsSpecialInstructions
			End If
				
			dw_Report.SetITem(llNewRow,'special_instructions', lsHeaderNotes) 
		
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
		
			//Contact + Phone NUmber in same field
			lsContact = ""
			If w_do.idw_Main.GetITemString(1,'contact_person') > "" Then
				lsContact = "Contact: " + w_do.idw_Main.GetITemString(1,'contact_person') + " "
			End If
		
			If w_do.idw_Main.GetITemString(1,'tel') > "" Then
				lsContact += "tel: " + w_do.idw_Main.GetITemString(1,'tel') + " "
			End If
		
			dw_Report.SetITem(llNewRow,'consignee_contact',lsContact)
		
			dw_Report.SetITem(llNewRow,'consignee_country',w_do.idw_Main.GetITemString(1,'country'))
	
			//Detail Fields
			dw_Report.SetITem(llNewRow,'qty',w_do.idw_Detail.GetITemNUmber(llRowPos,'alloc_qty'))
			//dw_Report.SetITem(llNewRow,'line_item',w_do.idw_Detail.GetITemNUmber(llRowPos,'line_item_no'))
			dw_Report.SetITem(llNewRow,'line_item',Long(w_do.idw_Detail.GetITemString(llRowPos,'user_Field5'))) /*Oracle Line ITem in UF5*/
			dw_Report.SetITem(llNewRow,'unit_price',w_do.idw_Detail.GetITemNUmber(llRowPos,'price'))
		
			//Should print "legacy SKU' if present in UF 4, otherwise print SKU
			If w_do.idw_Detail.GetITemString(llRowPos,'user_field4') > "" Then
				dw_Report.SetITem(llNewRow,'sku',w_do.idw_Detail.GetITemString(llRowPos,'user_field4'))
			Else
				dw_Report.SetITem(llNewRow,'sku',w_do.idw_Detail.GetITemString(llRowPos,'sku'))
			End If
	 
			//Qty and COO from Picking
			dw_Report.SetITem(llNewRow,'qty', idsPick.GetITemNUmber(llPickPos,'quantity'))
			dw_Report.SetITem(llNewRow,'coo', lsCOO)
				
			//Item MAster
			
			// 05/08 - PCONKL - For Suzhou, HTS is based  on Country for External, Internal will always use China HTS
			If  w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
				
				Choose Case Upper(w_do.idw_Main.GetITEmString(1,'country'))
					Case 'CA'
						dw_Report.SetITem(llNewRow,'hts',lsCanadaHTS)
					Case 'CN'
						dw_Report.SetITem(llNewRow,'hts',lsChinaHTS)
					Case 'US'
						dw_Report.SetITem(llNewRow,'hts',lsHTS)
					Case Else /*Check for EU*/
						//If lsversion = 'A3' Then /*EU*/
							dw_Report.SetITem(llNewRow,'hts',lsEuropeHTS)
						//Else
						//	dw_Report.SetITem(llNewRow,'hts',lsHTS)
						//End If
				End Choose
				
				dw_Report.SetITem(llNewRow,'internal_hts',lsChinaHTS) /* will be copied over for Internal HTS (Always Chinese) */
			
			Else
				dw_Report.SetITem(llNewRow,'hts',lsHTS)
			End If
			
			If  w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
				dw_Report.SetITem(llNewRow,'lic_nbr','NLR')
			End IF
			
			dw_Report.SetITem(llNewRow,'description',lsDesc)	
			
		End If /*rolled up? */
		
	Next /*Pick Row for Sku/COO*/
	
Next /*detail Row */

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
		dw_Report.SetItem(dw_Report.RowCount(),'ext_int_ind',lsExtIntInd) /*External for SUZ*/
	Next
End If


//12/07 - PCONKL - For Suzhuo warehoue, we also want to generate internal version
//						We will just copy all of the rows and set the literal to Internal, and set the internal Price

If lsWarehouse = 'PWAVE-SUZ' Then
	
	//Set the Currency label on the column heading...(UF7 for Internal)
	If w_do.idw_Detail.GetITemString(1,'user_Field7') > "" Then
		dw_report.Modify("Int_unit_price_t.text = 'UNIT PRICE~~r(" +  w_do.idw_Detail.GetITemString(1,'user_Field7') + ")'")
		dw_report.Modify("Int_total_price_t.text = 'TOTAL PRICE~~r(" +  w_do.idw_Detail.GetITemString(1,'user_Field7') + ")'")
		dw_report.Modify("Int_total_value_t.text = 'TOTAL VALUE~~r(" +  w_do.idw_Detail.GetITemString(1,'user_Field7') + ")'")
	End IF
	
	liLastExtRow = dw_report.RowCount()
	
	dw_report.RowsCopy(1,liLastExtrow,Primary!,dw_report,9999999,Primary!)
	
	//Set new rows to Internal and set Internal Price 
	For llRowPos = (liLastExtRow + 1) to dw_report.RowCount()
		
		dw_Report.SetItem(llRowPos,'ext_int_ind', lsVersion + 'I')
		
		//Find first detail row for Oracle LIne (UF5)/Sku
		llFind = dw_report.Find("Line_item = " + String(dw_report.GetITemNumber(llRowPos,'line_item')) + " and sku = '" +  dw_report.GetITemString(llRowPos,'Sku') + "'",1,liLastExtRow)
		If llFind > 0 Then
			dw_Report.SetITem(llRowPos,'unit_price',Dec(w_do.idw_Detail.GetITemString(llFind,'User_Field6'))) /*(Internal Unit Price in UF6) */
		End If
		
		//Also Default Incoterms for Internal Only...
		dw_Report.SetITem(llRowPos,'incoterms','FCA SUZHOU')
				
		//Always use China HTS for Internal -  12/08 - PCONKL - Always leaving blank for Internal
		If dw_report.GetITemString(llRowPos,'SKU') > '' Then
			//dw_Report.SetITem(llRowPos,'hts',dw_Report.GetItemString(llRowPos,'internal_hts'))
			dw_Report.SetITem(llRowPos,'hts',"")
		End If
		
		//Set Lic from DM User Field if PResent, Otherwise to NLR
		If w_do.Idw_main.GetITemString(1,'user_field3') > '' Then
			dw_Report.SetITem(llRowPos,'lic_nbr',w_do.Idw_main.GetITemString(1,'user_field3'))
		Else
			dw_Report.SetITem(llRowPos,'lic_nbr','NLR')
		End If
		
	NExt

	
End If /* SUZ */

im_menu.m_file.m_print.Enabled = TRUE

dw_report.SetRedraw(True)
dw_report.GroupCalc()

end event

type dw_select from w_std_report`dw_select within w_powerwave_commercial_invoice_rpt
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

type cb_clear from w_std_report`cb_clear within w_powerwave_commercial_invoice_rpt
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_powerwave_commercial_invoice_rpt
integer x = 32
integer y = 12
integer width = 3483
integer height = 2056
integer taborder = 30
string dataobject = "d_powerwave_commercial_invoice"
boolean hscrollbar = true
end type

