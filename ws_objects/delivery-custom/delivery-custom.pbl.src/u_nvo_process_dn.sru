$PBExportHeader$u_nvo_process_dn.sru
$PBExportComments$Process Delivery Notes
forward
global type u_nvo_process_dn from nonvisualobject
end type
end forward

global type u_nvo_process_dn from nonvisualobject
end type
global u_nvo_process_dn u_nvo_process_dn

type variables
Integer iicopies
end variables

forward prototypes
public function integer uf_process_dn ()
public function integer uf_print_dn_philips ()
public function integer uf_print_dn_mmd ()
public function integer uf_print_dn_lam ()
public function integer uf_print_dn_warner ()
public function integer uf_process_return_note ()
public function integer uf_print_cn_philips ()
public function integer uf_print_cn_mmd ()
public function integer uf_print_cn_warner ()
public function integer uf_print_dn_philips_th ()
public function integer uf_print_cn_philips_th ()
public function integer uf_print_dn_riverbed ()
public function integer uf_print_dn_nike ()
public function integer uf_print_dn_dana_th ()
public function string getphilipsinvtype (string asinvtype)
public function integer uf_print_dn_starbucks_th ()
public function integer uf_process_dn_philips (datastore idsmain, datastore idsdetail, datastore idspick, datastore idspack, boolean ibshowprintdialog)
public function integer uf_batch_print_philips_dn ()
public function integer uf_process_batch_dn ()
public function integer uf_print_kendo_ci ()
public function integer uf_print_dn_th_muser ()
public function integer uf_process_dn_hager ()
public function integer uf_batch_print_hagersg_dn ()
public function integer uf_print_dn_hager_sg ()
public function integer uf_process_dn_hager_sg (datastore idsmain, datastore idsdetail, datastore idspick, datastore idspack, boolean ibshowprintdialog)
public function str_parms getnotelist (string as_dono, string as_note_type)
public function integer uf_print_leaflet_coty ()
public function string uf_modified_customer_name (readonly string as_cust_name)
public function str_parms uf_get_leaflet_matrix_images (string as_leatlet_id)
public function integer uf_print_dn_philipscls ()
public function string remove_leading_zeros (string as_sku)
public function integer uf_process_dn_philipscls (datastore idsmain, datastore idsdetail, datastore idspick, datastore idspack, boolean ibshowprintdialog)
end prototypes

public function integer uf_process_dn ();//1-FEB-2019 :Madhu S28945 Added PHILIPSCLS

Choose Case Upper(gs_project)

	Case 'PHILIPS-SG', 'TPV', 'FUNAI', 'GIBSON' /* 01/13 - PCONKL - added TPV */  /* 6/13 - Added FUNAI */ /*TAM 2015/03 - Added Gibson */
		
		uf_print_dn_Philips()
		
	Case 'PHILIPS-TH'
		
		uf_print_dn_philips_th()	
		
	//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
	Case 'PHILIPSCLS', 'PHILIPS-DA'
		
		uf_print_dn_philipscls()
				
	Case 'SG-MUSER'
		
		// 07/13 - PCONKL - ADded PANDAN
		
		If w_do.idw_main.GetITemString(1,'wh_Code') = '30BLW' or w_do.idw_main.GetITemString(1,'wh_Code') = 'GOLDIN'  or w_do.idw_main.GetITemString(1,'wh_Code') = 'PANDAN'  Then
			uf_print_dn_mmd()
		End If
		
	Case 'LAM-SG'
		
		uf_print_dn_Lam()
		
	Case 'WARNER'
		
		uf_print_dn_Warner()
	
	//BCR 09-NOV-2011: Riverbed...
	Case 'RIVERBED'
		
		uf_print_dn_riverbed()

		
	Case "DANA-TH" ,"DANA-RAY" /* 4/12 - MEA - 20-May-2016 :Madhu Added 'DANA-RAY'*/
		
	uf_print_dn_dana_th()		
		
	Case "STBTH" /* 04/13 - PCONKL - Starbucks - TH */
		
		uf_print_dn_starbucks_th()
		
	Case "KENDO" /* 04/16 - PCONKL */
		
		uf_print_kendo_ci()
		
	Case "TH-MUSER"	//23-Aug-2016 :Madhu Added for TH-MUSER
		uf_print_dn_th_muser()
		
	Case "HAGER-MY" /* 12/16 - PCONKL */
		
		uf_process_dn_hager()
		
	Case "HAGER-SG"  //GailM 11/27/2017 - Story S13614
		
		uf_print_dn_hager_sg()
		
	Case "COTY"  //20-APR-2018 :Madhu F7945 COTY Printing of personalized Leaflet
		uf_print_leaflet_coty()
		
End Choose

Return 0
end function

public function integer uf_print_dn_philips ();
// 08/13 - PCONKL - Moved the bulk of printing logic to uf_process_dn_Philips to allow for eathe single order printing or batch printing from search results tab

datastore ldsMain, ldsDetail, ldsPick, ldsPack

ldsMain = create datastore
ldsMain.dataobject = 'd_do_master'

ldsdetail = create datastore
ldsDetail.dataobject = 'd_do_detail'

ldsPick = create datastore
ldsPick.dataobject = 'd_do_picking'

ldsPack = create datastore
ldsPack.dataobject = 'd_do_packing_grid'

w_do.idw_Main.ShareData(ldsMain)
w_do.idw_Detail.ShareData(ldsDetail)
w_do.idw_Pick.ShareData(ldsPick)
w_do.idw_Pack.ShareData(ldsPack)

uf_process_dn_philips(ldsMain, ldsdetail, ldsPick, ldspack,true) /*Triue = show printer selection dialog*/
Return 0


//*************************************************************************************************************************************



//
////Print the Philips Delivery Note
//Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llFind, llLIneItem
//String	lsWarehouse,  lsSKU, lsSupplier, lsAltSku, lsDONO, lsDesc, lsInvType, lsPONO, lsPlant, lsSerial
//String	lsFind,lsUF7, lsUF8, lsUF9, lsUOM, lsPhilipsInvType
//String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText
//DataStore	ldsNotes, ldsSoldToAddress, ldsserial, ldsReport
//Int	liRowsPerPAge, liEmptyRows, liMod,  liNotePos
//Decimal {4} ldGrossWeight, ldNetWeight, ldNetVolume, ldGrossVolume
//
//
////Pack list must be generated
//If w_do.idw_pack.RowCount() = 0 Then
//	Messagebox(w_do.is_Title,'You must generate the Pack List before you can print the Delivery Note!')
//	Return -1
//End If
//	
//ldsReport = Create Datastore
//
////Singapore and Malaysia using different versions
//If w_do.idw_Main.GetITEmString(1,'wh_Code') = 'PHILIPS-MY' or w_do.idw_Main.GetITEmString(1,'wh_Code') = 'TPV-MY' or w_do.idw_Main.GetITEmString(1,'wh_Code') = 'FUNAI-MY'  Then /* 01/13 - PCONKL - added TPV*/ /* 6/13 - MEA - added FUNAI */
//	ldsReport.dataobject = 'd_philips_my_delivery_note'
//Else
//	ldsReport.dataobject = 'd_philips_sg_delivery_note'
//End IF
//
//liRowsPerPage =  8
//
//SetPointer(Hourglass!)
//
//
//lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
//lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')
//lsPlant = w_do.idw_Main.GetITemString(1,'User_Field3')
//
//
//ldsSoldToAddress = Create DataStore
//ldsSoldToAddress.dataObject = 'd_do_address_alt'
//ldsSoldToAddress.SetTransObject(sqlca)
//	
//ldsSoldToAddress.Retrieve(lsdono, 'ST') /*Sold To Address*/
//
//
////Notes
//ldsNotes = Create Datastore
//presentation_str = "style(type=grid)"
//lsSQl = "Select Note_seq_No, Note_Text, Line_Item_No from Delivery_Notes Where do_no = '" + lsDoNO + "'"
//dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
//ldsNotes.Create( dwsyntax_str, lsErrText)
//ldsNotes.SetTransObject(SQLCA)
//
//ldsNotes.Retrieve()
//
//ldsNotes.SetSort("Line_Item_No A, Note_Seq_No A")
//ldsNotes.Sort()
//	
////For Malaysia Plant code (MY10) or (MYQ0), we want to print Serial Numbers -
////01-Apr-2013 :Madhu added Plant code is 2180
//If lsPlant = "MY10"  OR   lsPlant = "MYQ0"  or lsPlant ="2180" Then
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
//
//
//llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())
//
//ldsReport.reset()
//
//
//lLRowCount = w_do.idw_Pick.RowCount()
//For llRowPOs = 1 to llRowCount
//
//	lsSKU = w_do.idw_Pick.GetITemString(llRowPos,'sku')
//	lsSupplier = w_do.idw_Pick.GetITemString(llRowPos,'supp_Code')
//	lsInvType = w_do.idw_Pick.GetITemString(llRowPos,'inventory_Type')
//	llLineItem = w_do.idw_Pick.GetITemNumber(llRowPos,'Line_Item_No')
//		
//	If w_do.idw_Pick.GetITemNumber(lLRowPOs,'quantity') = 0 Then Continue
//	
//	//Roll Up To To Line/SKU/Inventory Type
//	LsFind = "po_line = " + String(llLineItem) + " and SKU = '" + lsSKU + "' and Inventory_Type = '" + lsInvType + "'"
//		
//	llFind = ldsReport.Find(lsFind,1,ldsReport.RowCount())
//	If llFind > 0 Then
//		
//		ldsReport.SetItem(llFind,'quantity',ldsReport.GetITemNumber(llFind,'quantity') + w_do.idw_Pick.GetITemNumber(lLRowPOs,'quantity')) /*add to existing Row*/
//		Continue
//		
//	End If
//	
//	
//	//Insert a new report Row
//	
//	llNewRow = ldsReport.InsertRow(0)
//	
//	ldsReport.SetITem(llNewRow,'project_id', gs_project ) /*01/13 - PCONKL - needed to toggle logo for TPV AND FUNAI */
//
//	//Header Notes (up to 4 rows)
//	liNotePos = 0
//	llFind = ldsNotes.Find("Line_Item_No = 0",1,ldsNotes.RowCount()) /* line_item = 0 for header Notes*/
//	Do While llFind > 0
//		
//		liNotePos ++
//		lsNotePos = "header_remarks" + String(liNotePos)
//		ldsReport.setitem(llNewRow,lsNotePos,ldsNotes.GetITemString(llFind,"note_Text"))
//		
//		llFind ++
//		If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
//			llFind = 0
//		Else
//			llFind = ldsNotes.Find("Line_Item_No = 0",llFind,ldsNotes.RowCount())
//		End If
//		
//	Loop
//	
//	//Line Notes (up to 4 rows - into a single line of text) 
//	liNotePos = 0
//	lsNoteText = ""
//	llFind = ldsNotes.Find("Line_Item_No = " + string(llLineItem),1,ldsNotes.RowCount()) 
//	Do While llFind > 0
//		
//		liNotePos ++
//		lsNoteText += ldsNotes.GetITemString(llFind,"note_Text") + " "
//				
//		llFind ++
//		If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
//			llFind = 0
//		Else
//			llFind = ldsNotes.Find("Line_Item_No = " + string(llLineItem),llFind,ldsNotes.RowCount())
//		End If
//		
//	Loop
//	
//	ldsReport.SetItem(llNewRow,"Line_Remarks",lsNoteText)
//	
//	
//	//Ship From Info Box
//	
//	//Take from Supplier
//	
//	string lsSuppName, lsSuppAddress_1, lsSuppAddress_2, lsSuppAddress_3, lsSuppAddress_4
//	string lsSuppCity, lsSuppState, lsSuppCountry, lsSuppZip
//	
//	Select supp_name, address_1, address_2, address_3, address_4, 
//			city, state, country, zip 
//	Into	 :lsSuppName,:lsSuppAddress_1, :lsSuppAddress_2, :lsSuppAddress_3, :lsSuppAddress_4,
//			 :lsSuppCity, :lsSuppState, :lsSuppCountry, :lsSuppZip
//	From Supplier
//	Where Project_id = :gs_project and supp_code = :lsSupplier;
//	
//	
//	
////	If llwarehouseRow > 0 Then /*warehouse row exists*/
//	
//		//Hard code MMD for Plant SGT5, otherwise take from Warehouse
//	If lsPlant = "SGT5" Then
//		lsSuppName = 'MMD SINGAPORE PTE. LTD.'
//		//ldsReport.SetITem(llNewRow,'ship_from_name','MMD SINGAPORE PTE. LTD.')
//	Else
//		//ldsReport.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
//	End If
//	
//	ldsReport.SetITem(llNewRow,'ship_from_name', lsSuppName )
//	ldsReport.setitem(llNewRow,"ship_from_addr1", lsSuppAddress_1) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
//	ldsReport.setitem(llNewRow,"ship_from_addr2", lsSuppAddress_2 ) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
//	ldsReport.setitem(llNewRow,"ship_from_addr3", lsSuppAddress_3) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
//	ldsReport.setitem(llNewRow,"ship_from_addr4", lsSuppAddress_4) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
//	ldsReport.setitem(llNewRow,"ship_from_city", lsSuppCity)  //g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
//	ldsReport.setitem(llNewRow,"ship_from_state", lsSuppState)  //g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
//	ldsReport.setitem(llNewRow,"ship_from_country", lsSuppCountry ) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
//	ldsReport.setitem(llNewRow,"ship_from_zip", lsSuppZip ) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
//
//	
////	End If
//	
//	ldsReport.SetITem(llNewRow,'do_number', w_do.idw_Main.GetITemString(1,'invoice_no'))
//	ldsReport.SetITem(llNewRow,'route', w_do.idw_Main.GetITemString(1,'USer_Field2'))
//	
//	//DO_TYpe
//	If lsPlant = "MY10" OR   lsPlant = "MYQ0" or lsPlant = "2180" Then /*No DO Type for Malaysia */ /* 02/13 - PCONKL - added 2180 for TPV */
//	Else
//		If Upper(w_do.idw_Main.GetITemString(1,'country')) <> 'SG' and w_do.idw_Main.GetITemString(1,'country') <> 'SINGAPORE' Then
//			ldsReport.SetITem(llNewRow,'DO_TYPE','Export')
//		Elseif Upper(w_do.idw_Main.GetITemString(1,'USer_Field2')) = 'SG9999' Then
//			ldsReport.SetITem(llNewRow,'DO_TYPE','Self Collection')
//		Elseif Upper(w_do.idw_Main.GetITemString(1,'USer_Field2')) = 'SGM9' Then /* 09/09 - PCONKL */
//			ldsReport.SetITem(llNewRow,'DO_TYPE','STO')
//		Else
//			ldsReport.SetITem(llNewRow,'DO_TYPE','Normal Delivery')
//		End If
//	End If
//	
//	//DO REceipt and DElivery Date
//	ldsReport.SetITem(llNewRow,'DO_receipt_dateTime',w_do.idw_Main.GetITemDateTime(1,'ord_date'))
//	ldsReport.SetITem(llNewRow,'delivery_date',w_do.idw_Main.GetITemDateTime(1,'request_Date'))
//	
//	//Ship To
//	ldsReport.SetITem(llNewRow,'ship_to_code',w_do.idw_Main.GetITemString(1,'cust_code'))
//	ldsReport.SetITem(llNewRow,'ship_to_name',w_do.idw_Main.GetITemString(1,'cust_Name'))
//	ldsReport.SetITem(llNewRow,'ship_to_addr1',w_do.idw_Main.GetITemString(1,'address_1'))
//	ldsReport.SetITem(llNewRow,'ship_to_addr2',w_do.idw_Main.GetITemString(1,'address_2'))
//	ldsReport.SetITem(llNewRow,'ship_to_addr3',w_do.idw_Main.GetITemString(1,'address_3'))
//	ldsReport.SetITem(llNewRow,'ship_to_addr4',w_do.idw_Main.GetITemString(1,'address_4'))
//	ldsReport.SetITem(llNewRow,'ship_to_city',w_do.idw_Main.GetITemString(1,'city'))
//	ldsReport.SetITem(llNewRow,'ship_to_state',w_do.idw_Main.GetITemString(1,'state'))
//	ldsReport.SetITem(llNewRow,'ship_to_zip',w_do.idw_Main.GetITemString(1,'zip'))
//	ldsReport.SetITem(llNewRow,'ship_to_country',w_do.idw_Main.GetITemString(1,'country'))
//	ldsReport.SetITem(llNewRow,'ship_to_contact',w_do.idw_Main.GetITemString(1,'contact_person'))
//	ldsReport.SetITem(llNewRow,'ship_to_tel',w_do.idw_Main.GetITemString(1,'tel'))
//	
//	//Sold To Address
//	If ldsSoldToAddress.RowCount() > 0 Then
//	
//		ldsReport.SetITem(llNewRow,'sold_to_name',ldsSoldToAddress.GetITemString(1,'name'))
//		ldsReport.setitem(llNewRow,"sold_to_addr1",ldsSoldToAddress.GetITemString(1,'address_1'))
//		ldsReport.setitem(llNewRow,"sold_to_addr2",ldsSoldToAddress.GetITemString(1,'address_2'))
//		ldsReport.setitem(llNewRow,"sold_to_addr3",ldsSoldToAddress.GetITemString(1,'address_3'))
//		ldsReport.setitem(llNewRow,"sold_to_addr4",ldsSoldToAddress.GetITemString(1,'address_4'))
//		ldsReport.setitem(llNewRow,"sold_to_district",ldsSoldToAddress.GetITemString(1,'district'))
//		ldsReport.setitem(llNewRow,"sold_to_city",ldsSoldToAddress.GetITemString(1,'city'))
//		ldsReport.setitem(llNewRow,"sold_to_state",ldsSoldToAddress.GetITemString(1,'state'))
//		ldsReport.setitem(llNewRow,"sold_to_zip",ldsSoldToAddress.GetITemString(1,'zip'))
//		ldsReport.setitem(llNewRow,"sold_to_country",ldsSoldToAddress.GetITemString(1,'country'))
//			
//	End If
//	
//	//Item MAster values
//	ldNetWEight = 0
//	
//	Select alternate_Sku, description, user_field7, user_field8, user_field9, UOM_1, weight_1
//	Into	 :lsAltSku,:lsDesc, :lsUF7, :lsUF8, :lsUF9, :lsUOM, :ldNetWEight
//	From Item_Master
//	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
//		
//	if sqlca.sqlcode <> 0 then
//		MessageBox ("DB Error", SQLCA.SQLErrText )
//	end if
//	
//	ldsReport.SetITem(llNewRow,'sku',lsSKU)
//	
//	//MEA - 1/6/13 - Added for Barcode
//
//	if ldsReport.dataobject = "d_philips_sg_delivery_note" OR  ldsReport.dataobject =  "d_philips_my_delivery_note"  then
//		ldsReport.SetITem(llNewRow,'supp_code',lsSupplier)	
//	end if
//	
//	
//	ldsReport.SetITem(llNewRow,'description',lsDesc)	
//	ldsReport.SetITem(llNewRow,'uom',lsUOM)	
//	ldsReport.SetITem(llNewRow,'alt_Sku',lsAltSku)
//	ldsReport.SetITem(llNewRow,'twelve_nc',lsUF7)
//	ldsReport.SetITem(llNewRow,'conversion_Factor',lsUF9)
//	
//	If isnull(ldNetWeight)Then ldNetWeight = 0
//	ldsReport.SetITem(llNewRow,'net_weight',ldNetWEight)
//	
//	//Volume
//	If isnumber(lsUF8) Then
//		ldsReport.SetITem(llNewRow,'net_volume',Dec(lsUF8))
//	Else
//		ldsReport.SetITem(llNewRow,'net_volume',0)
//	End If
//	
//	ldsReport.SetITem(llNewRow,'po_line',llLineItem)
//	ldsReport.SetITem(llNewRow,'quantity',w_do.idw_Pick.GetITemNUmber(llRowPos,'quantity'))
//	
//
//	//Convert Menlo Inv Type to Philips
//	//MA - 3/12 - Added 'G', 'J', 'F', 'E' to list
//	// 01/13 - PCONKL - Moved to function to support TPV values
//	
////	Choose case upper(w_do.idw_Pick.GetITemString(llRowPos,'inventory_type'))
////		
////		Case 'B'
////			lsPhilipsInvType = 'B'
////		Case 'C'
////			lsPhilipsInvType = 'C'
////		Case 'D'
////			lsPhilipsInvType = 'DAM'
////		Case 'K'
////			lsPhilipsInvType = 'BLCK'
////		Case 'L'
////			lsPhilipsInvType = 'REBL'
////		Case 'N'
////			lsPhilipsInvType = 'WHS'
////		Case 'R'
////			lsPhilipsInvType = 'REW'
////		Case 'S'
////			lsPhilipsInvType = 'SCRP'
////		Case 'G'
////			lsPhilipsInvType = 'BWHS'
////		Case 'J'		
////			lsPhilipsInvType = 'BOPN'			
////		Case 'F'	
////			lsPhilipsInvType = 'BBLK'			
////		Case 'E'	
////			lsPhilipsInvType = 'BDAM'
////		Case Else
////			lsPhilipsInvType = w_do.idw_Pick.GetITemString(llRowPos,'inventory_type')
////		End Choose
//
//	lsPhilipsInvType = getPhilipsInvType(w_do.idw_Pick.GetITemString(llRowPos,'inventory_type'))
//	
//	ldsReport.SetITem(llNewRow,'inventory_desc',lsPhilipsInvType)
//	ldsReport.SetITem(llNewRow,'inventory_type',w_do.idw_Pick.GetITemString(llRowPos,'inventory_type'))
//	ldsReport.SetITem(llNewRow,'plant_Code',lsPlant) /*plant code used to determine which logo to display*/
//		
//	//Plant/Invoice From & Company Registration
//	Choose Case Upper(w_do.idw_Main.GetITemString(1,'User_Field3'))
//			
//		Case "SG10"
//
//			
//			if gs_project = 'FUNAI' then
//				ldsReport.SetITem(llNewRow,'company_registration','201309796D')
//				ldsReport.SetITem(llNewRow,'plant_invoice_From','SG10 / 756058')		
//			else
//				ldsReport.SetITem(llNewRow,'company_registration','199705989C')
//				ldsReport.SetITem(llNewRow,'plant_invoice_From','SG10 / 830144')				
//			end if
//		Case "SG71"
//			
//			if gs_project = 'FUNAI' then
//				ldsReport.SetITem(llNewRow,'company_registration','201309796D')
//				ldsReport.SetITem(llNewRow,'plant_invoice_From','SG71 / 756059')
//			else
//				ldsReport.SetITem(llNewRow,'company_registration','199705989C')
//				ldsReport.SetITem(llNewRow,'plant_invoice_From','SG71 / 830386')
//			end if
//			
//		Case "SG27"
//			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG27 / 832889')
//			ldsReport.SetITem(llNewRow,'company_registration','199705989C')		
//		Case "SG00"
//			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG00 / 830143')
//			ldsReport.SetITem(llNewRow,'company_registration','199705989C')
//		Case "SG03"
//			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG03 / 832445')
//			ldsReport.SetITem(llNewRow,'company_registration','199705989C')
//		Case "SGT5"
//			ldsReport.SetITem(llNewRow,'plant_invoice_From','SGT5 / 834002 ')
//			ldsReport.SetITem(llNewRow,'company_registration','200822460K')
//		Case "MY10"
//			If gs_project = 'FUNAI' then
//				ldsReport.SetITem(llNewRow,'company_registration','1053825-M')
//				ldsReport.SetITem(llNewRow,'plant_invoice_From','MY10 / 756040')	
//			Else
//				ldsReport.SetITem(llNewRow,'plant_invoice_From','MY10')	
//			End If
//		Case "SGQ1"
//			ldsReport.SetITem(llNewRow,'plant_invoice_From','SGQ1 / 900043 ')
//			ldsReport.SetITem(llNewRow,'company_registration','201114879N')
//		Case "MYQ0"
//			ldsReport.SetITem(llNewRow,'plant_invoice_From','MYQ0 / 900023 ')
//			ldsReport.SetITem(llNewRow,'company_registration','952853M')
//	
//		// 01/13 - PCONKL - added plant codes for TPV project
//		Case "2190"
//			ldsReport.SetITem(llNewRow,'plant_invoice_From','2190 / 900043 ')
//			ldsReport.SetITem(llNewRow,'company_registration','201114879N')
//		Case "2180"
//			ldsReport.SetITem(llNewRow,'plant_invoice_From','2180 / 900023 ')
//			ldsReport.SetITem(llNewRow,'company_registration','952853M')
//			
//			
//	End Choose
//	
//	//PO NBR from Delivery Detail (UF3)
//	llFind = w_do.idw_Detail.Find("Line_Item_No = " + String(llLineItem),1,w_do.idw_Detail.RowCount())
//	If llFind > 0 Then
//		ldsReport.SetITem(llNewRow,'po_nbr',w_do.idw_Detail.GetITemString(llFind,'User_Field3')) 
//	End If
//	
//	//Add Serial Number for Malaysia 
//	//01-Apr-2013 :Madhu added Plant code is 2180
//	If lsPlant = "MY10" OR   lsPlant = "MYQ0"  or lsPlant ="2180" Then
//		
//		lsSerial = ''
//		
//		lsFind = "Line_ITem_no = " + String(llLineItem) + " and Upper(SKU) = '" + Upper(lsSKU) + "' and upper(Inventory_Type) = '" + Upper(lsInvType) + "'"
//		llFind = ldsSerial.Find(lsFind,1,ldsSerial.RowCount())
//		
//		Do While llFind > 0
//			
//			lsSerial += ldsSerial.GetITemString(llFind,'serial_no') + ", "
//
//			llFind ++
//			If llFind > ldsSerial.RowCount() Then
//				llFind = 0
//			Else
//				llFind = ldsSerial.Find(lsFind,llFind,ldsSerial.RowCount())
//			End If
//			
//		Loop
//		
//		lsSerial = Left(lsSerial,(len(lsSerial) - 2)) /*Strip off last comma */
//		ldsReport.SetITem(llNewRow,'serial_no',lsSerial)
//		
//	End If /*Malaysia*/
//	
//Next /*Picking Row */
//
////Calculate Gross Volume and Gross Weight
//ldGrossWEight = 0
//ldGrossVolume = 0
//
//lLRowCount = ldsReport.RowCount()
//For llRowPos = 1 to lLRowCount
//	
//	ldGrossWeight += ldsReport.GetItemDecimal(llRowPos,'net_weight') * ldsReport.GetItemDecimal(lLRowPos,'quantity')
//	ldGrossVolume += ldsReport.GetItemDecimal(llRowPos,'net_volume') * ldsReport.GetItemDecimal(lLRowPos,'quantity')
//	
//Next
//
//ldsReport.Modify("gross_Weight_t.text='" + String(ldGrossWeight,"#########.0000") + " KG'")
//ldsReport.Modify("total_volume_t.text='" + String(ldGrossVolume,"#########.0000") + " CDM'")
//
////Show in Override DW (users need to be able to override Weight and Volume
////dw_select.SetITem(1,'total_weight',ldGrossWeight)
////dw_select.SetITem(1,'total_volume',ldGrossVolume)
//
//ldsReport.SetSort("po_line A")
//ldsReport.Sort()
//
//
////Print
//
//String	 lsType
//Int		llCount
//
//// check print count before printing and prompt if already printed
//lsDONO = w_do.idw_Main.GetITemString(1,'do_no')
//
//Select Delivery_Note_Print_Count into :llCount
//From Delivery_MAster
//Where do_no = :lsDONO;
//	
//If isnull(llCount) Then llCount = 0
//	
//If llCount > 0 Then
//	If Messagebox("Print DELIVERY Note","This DELIVERY Note has already been printed. Do you want to continue?",Stopsign!,yesNo!,2) = 2 Then
//		Return 0
//	End If
//End If
//
//OpenWithParm(w_dw_print_options,ldsReport) 
////If printed successfully, update Print count on Delivery_Master
//If message.doubleparm = 1 then
//		
//	llCount ++
//	
//	Execute Immediate "Begin Transaction" using SQLCA;
//	
//	Update Delivery_Master
//	Set Delivery_Note_Print_Count = :llCount
//	Where do_no = :lsDONO;
//		
//	Execute Immediate "COMMIT" using SQLCA;
//	
//End If
//
//SetPointer(arrow!)
//
//
//
//
//
//
//
//Return 0
end function

public function integer uf_print_dn_mmd ();

//Print the MMD Delivery Note
Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llFind, llLIneItem
String	lsWarehouse,  lsSKU, lsSupplier, lsAltSku, lsDONO, lsDesc, lsInvType, lsPONO, lsPlant, lsSerial
String	lsFind,lsUF7, lsUF8, lsUF9, lsUOM, lsPhilipsInvType
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText
DataStore	ldsSoldToAddress, ldsserial, ldsReport
Int	liRowsPerPAge, liEmptyRows, liMod,  liNotePos
Decimal {4} ldGrossWeight, ldNetWeight, ldNetVolume, ldGrossVolume
DateTime	ldtToday

ldtToday = DateTime(today(),Now())

//Pack list must be generated
If w_do.idw_pack.RowCount() = 0 Then
	Messagebox(w_do.is_Title,'You must generate the Pack List before you can print the Delivery Note!')
	Return -1
End If
	
ldsReport = Create Datastore
ldsReport.dataobject = 'd_mmd_delivery_note'

liRowsPerPage =  8

SetPointer(Hourglass!)


lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')
lsPlant = w_do.idw_Main.GetITemString(1,'User_Field3')


ldsSoldToAddress = Create DataStore
ldsSoldToAddress.dataObject = 'd_do_address_alt'
ldsSoldToAddress.SetTransObject(sqlca)
	
ldsSoldToAddress.Retrieve(lsdono, 'ST') /*Sold To Address*/
	
llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

ldsReport.reset()


lLRowCount = w_do.idw_Pick.RowCount()
For llRowPOs = 1 to llRowCount

	lsSKU = w_do.idw_Pick.GetITemString(llRowPos,'sku')
	lsSupplier = w_do.idw_Pick.GetITemString(llRowPos,'supp_Code')
	lsInvType = w_do.idw_Pick.GetITemString(llRowPos,'inventory_Type')
	llLineItem = w_do.idw_Pick.GetITemNumber(llRowPos,'Line_Item_No')
		
	If w_do.idw_Pick.GetITemNumber(lLRowPOs,'quantity') = 0 Then Continue
	
	//Roll Up To To Line/SKU/Inventory Type
	LsFind = "po_line = " + String(llLineItem) + " and SKU = '" + lsSKU + "' and Inventory_Type = '" + lsInvType + "'"
		
	llFind = ldsReport.Find(lsFind,1,ldsReport.RowCount())
	If llFind > 0 Then
		
		ldsReport.SetItem(llFind,'quantity',ldsReport.GetITemNumber(llFind,'quantity') + w_do.idw_Pick.GetITemNumber(lLRowPOs,'quantity')) /*add to existing Row*/
		Continue
		
	End If
	
	
	//Insert a new report Row
	
	llNewRow = ldsReport.InsertRow(0)
	
	//Ship From Info Box
	If llwarehouseRow > 0 Then /*warehouse row exists*/
	
		//Hard code MMD for Plant SGT5, otherwise take from Warehouse
		If lsPlant = "SGT5" Then
			ldsReport.SetITem(llNewRow,'ship_from_name','MMD SINGAPORE PTE. LTD.')
		Else
			ldsReport.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
		End If
		
		ldsReport.setitem(llNewRow,"ship_from_addr1",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
		ldsReport.setitem(llNewRow,"ship_from_addr2",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
		ldsReport.setitem(llNewRow,"ship_from_addr3",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
		ldsReport.setitem(llNewRow,"ship_from_addr4",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
		ldsReport.setitem(llNewRow,"ship_from_city",g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
		ldsReport.setitem(llNewRow,"ship_from_state",g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
		ldsReport.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
		ldsReport.setitem(llNewRow,"ship_from_zip",g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
	 	
	End If
	
	ldsReport.SetITem(llNewRow,'do_number', w_do.idw_Main.GetITemString(1,'invoice_no'))
	ldsReport.SetITem(llNewRow,'route', w_do.idw_Main.GetITemString(1,'USer_Field2'))
	ldsReport.SetITem(llNewRow,'header_remarks1', w_do.idw_Main.GetITemString(1,'remark'))
	ldsReport.SetITem(llNewRow,'DO_TYPE',w_do.idw_Main.GetITemString(1,'USer_Field4'))
	
		
	//DO REceipt and DElivery Date
	ldsReport.SetITem(llNewRow,'DO_receipt_dateTime',w_do.idw_Main.GetITemDateTime(1,'ord_date'))
	If Not isnull(w_do.idw_Main.GetITemDateTime(1,'schedule_Date')) Then
		ldsReport.SetITem(llNewRow,'delivery_date',w_do.idw_Main.GetITemDateTime(1,'schedule_Date'))
	Else
		ldsReport.SetITem(llNewRow,'delivery_date',ldtToday)
	End If
	
	//Ship To
	ldsReport.SetITem(llNewRow,'ship_to_code',w_do.idw_Main.GetITemString(1,'cust_code'))
	ldsReport.SetITem(llNewRow,'ship_to_name',w_do.idw_Main.GetITemString(1,'cust_Name'))
	ldsReport.SetITem(llNewRow,'ship_to_addr1',w_do.idw_Main.GetITemString(1,'address_1'))
	ldsReport.SetITem(llNewRow,'ship_to_addr2',w_do.idw_Main.GetITemString(1,'address_2'))
	ldsReport.SetITem(llNewRow,'ship_to_addr3',w_do.idw_Main.GetITemString(1,'address_3'))
	ldsReport.SetITem(llNewRow,'ship_to_addr4',w_do.idw_Main.GetITemString(1,'address_4'))
	ldsReport.SetITem(llNewRow,'ship_to_city',w_do.idw_Main.GetITemString(1,'city'))
	ldsReport.SetITem(llNewRow,'ship_to_state',w_do.idw_Main.GetITemString(1,'state'))
	ldsReport.SetITem(llNewRow,'ship_to_zip',w_do.idw_Main.GetITemString(1,'zip'))
	ldsReport.SetITem(llNewRow,'ship_to_country',w_do.idw_Main.GetITemString(1,'country'))
	ldsReport.SetITem(llNewRow,'ship_to_contact',w_do.idw_Main.GetITemString(1,'contact_person'))
	ldsReport.SetITem(llNewRow,'ship_to_tel',w_do.idw_Main.GetITemString(1,'tel'))
	
	//Sold To Address
	If ldsSoldToAddress.RowCount() > 0 Then
	
		ldsReport.SetITem(llNewRow,'sold_to_name',ldsSoldToAddress.GetITemString(1,'name'))
		ldsReport.setitem(llNewRow,"sold_to_addr1",ldsSoldToAddress.GetITemString(1,'address_1'))
		ldsReport.setitem(llNewRow,"sold_to_addr2",ldsSoldToAddress.GetITemString(1,'address_2'))
		ldsReport.setitem(llNewRow,"sold_to_addr3",ldsSoldToAddress.GetITemString(1,'address_3'))
		ldsReport.setitem(llNewRow,"sold_to_addr4",ldsSoldToAddress.GetITemString(1,'address_4'))
		ldsReport.setitem(llNewRow,"sold_to_district",ldsSoldToAddress.GetITemString(1,'district'))
		ldsReport.setitem(llNewRow,"sold_to_city",ldsSoldToAddress.GetITemString(1,'city'))
		ldsReport.setitem(llNewRow,"sold_to_state",ldsSoldToAddress.GetITemString(1,'state'))
		ldsReport.setitem(llNewRow,"sold_to_zip",ldsSoldToAddress.GetITemString(1,'zip'))
		ldsReport.setitem(llNewRow,"sold_to_country",ldsSoldToAddress.GetITemString(1,'country'))
			
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
	
	ldsReport.SetITem(llNewRow,'sku',lsSKU)
	ldsReport.SetITem(llNewRow,'description',lsDesc)	
	ldsReport.SetITem(llNewRow,'uom',lsUOM)	
	ldsReport.SetITem(llNewRow,'alt_Sku',lsAltSku)
	ldsReport.SetITem(llNewRow,'twelve_nc',lsUF7)
	ldsReport.SetITem(llNewRow,'conversion_Factor',lsUF9)
	
	If isnull(ldNetWeight)Then ldNetWeight = 0
	ldsReport.SetITem(llNewRow,'net_weight',ldNetWEight)
	
	//Volume
	If isnumber(lsUF8) Then
		ldsReport.SetITem(llNewRow,'net_volume',Dec(lsUF8))
	Else
		ldsReport.SetITem(llNewRow,'net_volume',0)
	End If
	
	ldsReport.SetITem(llNewRow,'po_line',llLineItem)
	ldsReport.SetITem(llNewRow,'quantity',w_do.idw_Pick.GetITemNUmber(llRowPos,'quantity'))
	

	//Convert Menlo Inv Type to Philips
	Choose case upper(w_do.idw_Pick.GetITemString(llRowPos,'inventory_type'))
		
		Case 'B'
			lsPhilipsInvType = 'NORMAL-B'
		Case 'C'
			lsPhilipsInvType = 'NORMAL-C'
		Case 'D'
			lsPhilipsInvType = 'DAMAGED'
		Case 'N'
			lsPhilipsInvType = 'NORMAL'
		Case 'W'
			lsPhilipsInvType = 'REWORK'
		Case 'X'
			lsPhilipsInvType = 'SCRAP'
		Case Else
			lsPhilipsInvType = w_do.idw_Pick.GetITemString(llRowPos,'inventory_type')
		End Choose
	
	ldsReport.SetITem(llNewRow,'inventory_desc',lsPhilipsInvType)
	ldsReport.SetITem(llNewRow,'inventory_type',w_do.idw_Pick.GetITemString(llRowPos,'inventory_type'))
	ldsReport.SetITem(llNewRow,'plant_Code',lsPlant) /*plant code used to determine which logo to display*/
		
	//Plant/Invoice From & Company Registration
	ldsReport.SetITem(llNewRow,'company_registration','200822460K')
		
	
	//PO NBR from Delivery Detail (UF3), Line level NOtes from UF4
	llFind = w_do.idw_Detail.Find("Line_Item_No = " + String(llLineItem),1,w_do.idw_Detail.RowCount())
	If llFind > 0 Then
		ldsReport.SetITem(llNewRow,'po_nbr',w_do.idw_Detail.GetITemString(llFind,'User_Field3')) 
		ldsReport.SetItem(llNewRow,"Line_Remarks",w_do.idw_Detail.GetITemString(llFind,'User_Field4'))
	End If
	
Next /*Picking Row */

//Calculate Gross Volume and Gross Weight
ldGrossWEight = 0
ldGrossVolume = 0

lLRowCount = ldsReport.RowCount()
For llRowPos = 1 to lLRowCount
	
	ldGrossWeight += ldsReport.GetItemDecimal(llRowPos,'net_weight') * ldsReport.GetItemDecimal(lLRowPos,'quantity')
	ldGrossVolume += ldsReport.GetItemDecimal(llRowPos,'net_volume') * ldsReport.GetItemDecimal(lLRowPos,'quantity')
	
Next

ldsReport.Modify("gross_Weight_t.text='" + String(ldGrossWeight,"#########.0000") + " KG'")
ldsReport.Modify("total_volume_t.text='" + String(ldGrossVolume,"#########.0000") + " CDM'")


ldsReport.SetSort("po_line A")
ldsReport.Sort()


//Print

String	 lsType
Int		llCount

// check print count before printing and prompt if already printed
lsDONO = w_do.idw_Main.GetITemString(1,'do_no')

Select Delivery_Note_Print_Count into :llCount
From Delivery_MAster
Where do_no = :lsDONO;
	
If isnull(llCount) Then llCount = 0
	
If llCount > 0 Then
	If Messagebox("Print DELIVERY Note","This DELIVERY Note has already been printed. Do you want to continue?",Stopsign!,yesNo!,2) = 2 Then
		Return 0
	End If
End If

OpenWithParm(w_dw_print_options,ldsReport) 
//If printed successfully, update Print count on Delivery_Master
If message.doubleparm = 1 then
		
	llCount ++
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Delivery_Master
	Set Delivery_Note_Print_Count = :llCount
	Where do_no = :lsDONO;
		
	Execute Immediate "COMMIT" using SQLCA;
	
End If

SetPointer(arrow!)







REturn 0
end function

public function integer uf_print_dn_lam ();
//Print the LAM DN

DataStore	ldsREport
String	lsDONO, lsCust, lsSKU, lsSUpplier, lsCustSKU, lsSKUprev
Int		liRowsPerPage, liEmptyRows, liMod, liRowPos

//Pack list must be generated
If w_do.idw_pack.RowCount() = 0 Then
	Messagebox(w_do.is_Title,'You must generate the Pack List before you can print the Delivery Note!')
	Return -1
End If
	
	
SetPointer(Hourglass!)

ldsReport = Create Datastore
ldsReport.dataobject = 'd_lam_delivery_note'
ldsREport.SetTransObject(SQLCA)

lsDONO = w_do.idw_Main.GetITEmSTring(1,'do_no')

ldsREport.Retrieve(lsDONO)

If ldsREport.RowCOunt() > 0 Then
	
	
	//Load any customer SKUS
	lsCust = w_do.idw_main.GetITemString(1,'cust_code')
	
	For liRowPos = 1 to ldsREport.RowCOunt()
		
		lsSKU = ldsReport.GetITEmString(liRowPos,'delivery_picking_sku')
		lsSupplier = ldsReport.GetITEmString(liRowPos,'supp_code')
		
		If lsSKU <> lsSKUPrev Then
			
			lsCustSKU = ''
			
			Select cust_alt_Sku into :lsCustSKU
			From item_cust_sku
			Where Project_id = :gs_project and cust_Code = :lsCust and primary_sku = :lsSKU and primary_Supp_Code = :lsSupplier;
			
			lsSKUPrev = lsSKU
			
		End IF
		
		ldsREport.SetITem(liRowPos,'c_cust_sku',lsCustSKU)
		
	Next
	
	ldsReport.Modify("total_packages_t.text='" + String(w_do.idw_Pack.Object.c_carton_Count[1]) + "'")
	ldsReport.Modify("total_weight_t.text='" + String(w_do.idw_Pack.Object.c_weight[1],'##########.00') + " KG'")
	
//	//add any necessary blank rows so we are always printing the summary at the bottom of the last page
//	liRowsPerPage = 15
//	liEmptyRows = 0
//	
//	If ldsREport.RowCount() < liRowsPerPage Then
//		liEmptyRows = liRowsPerPage - ldsREport.RowCount()
//	ElseIf ldsREport.RowCount() > liRowsPerPage Then
//		liMod = Mod(ldsREport.RowCount(), liRowsPerPage)
//		If liMod > 0 Then
//			liEmptyRows = liRowsPerPage - liMod
//		End IF
//	End If
//
//	If liEmptyRows > 0 Then
//		For liRowPos = 1 to liEmptyRows
//			ldsREport.InsertRow(0)
//		Next
//	End If
	
	OpenWithParm(w_dw_print_options,ldsReport) 
	
Else
	
	MessageBox(w_do.is_title, 'There are no records to print for the Delivery Note')
	
End If

SetPointer(arrow!)

REturn 0
end function

public function integer uf_print_dn_warner ();
//Print the Warner DN

DataStore	ldsREport
String	lsDONO, lsCust, lsSKU, lsSUpplier, lsCustSKU, lsSKUprev
Int		liRowsPerPage, liEmptyRows, liMod, liRowPos

//Pick list must be generated
If w_do.idw_pick.RowCount() = 0 Then
	Messagebox(w_do.is_Title,'You must generate the Pick List before you can print the Delivery Note!')
	Return -1
End If
	
	
SetPointer(Hourglass!)

ldsReport = Create Datastore
ldsReport.dataobject = 'd_warner_delivery_note'
ldsREport.SetTransObject(SQLCA)

lsDONO = w_do.idw_Main.GetITEmSTring(1,'do_no')

ldsREport.Retrieve(lsDONO)

If ldsREport.RowCOunt() > 0 Then
	
	//	//add any necessary blank rows so we are always printing the summary at the bottom of the last page
//	liRowsPerPage = 15
//	liEmptyRows = 0
//	
//	If ldsREport.RowCount() < liRowsPerPage Then
//		liEmptyRows = liRowsPerPage - ldsREport.RowCount()
//	ElseIf ldsREport.RowCount() > liRowsPerPage Then
//		liMod = Mod(ldsREport.RowCount(), liRowsPerPage)
//		If liMod > 0 Then
//			liEmptyRows = liRowsPerPage - liMod
//		End IF
//	End If
//
//	If liEmptyRows > 0 Then
//		For liRowPos = 1 to liEmptyRows
//			ldsREport.InsertRow(0)
//		Next
//	End If
	
	OpenWithParm(w_dw_print_options,ldsReport) 
	
Else
	
	MessageBox(w_do.is_title, 'There are no records to print for the Delivery Note')
	
End If

SetPointer(arrow!)

REturn 0
end function

public function integer uf_process_return_note ();//1-FEB-2019 :Madhu S28945 Added PHILIPSCLS
//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
Choose Case Upper(gs_project)
		
	Case 'PHILIPS-SG', 'PHILIPSCLS' , 'PHILIPS-DA','TPV', 'FUNAI', 'GIBSON' /*TAM 2015/03 - Added Gibson */
		
		uf_print_cn_Philips()
		
	Case 'PHILIPS-TH'
		
		uf_print_cn_philips_th()
		
	Case 'SG-MUSER'
		
		if w_ro.idw_Main.GetITemString(1,'wh_Code') = '30BLW' or w_ro.idw_Main.GetITemString(1,'wh_Code') = 'GOLDIN' Then
			uf_print_cn_MMD()
		End If
		
	Case 'WARNER'
		
		uf_print_cn_Warner()
		
End Choose

Return 0
end function

public function integer uf_print_cn_philips ();
Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llFind, llLIneItem, llCount
String	lsWarehouse,  lsSKU, lsSupplier, lsAltSku, lsRONO, lsDesc, lsInvType, lsPONO
String	lsFind,lsUF7, lsUF8, lsUF9, lsUOM, lsPhilipsInvType, lsFlag, lsPlant
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText
String	lsName, lsAddr1, lsAddr2, lsAddr3, lsAddr4, lsCity, lsState, lsZip, lsCountry, lsContact, lsTel
DataStore	ldsNotes, ldsSoldToAddress, ldsReport
Int	liRowsPerPAge, liEmptyRows, liMod,  liNotePos
Decimal	ldGrossWeight, ldNetWeight, ldNetVolume, ldGrossVolume
string lsSuppName, lsSuppAddress_1, lsSuppAddress_2, lsSuppAddress_3, lsSuppAddress_4
string lsSuppCity, lsSuppState, lsSuppCountry, lsSuppZip, lsSupplierSave


//Putaway list must be generated
If w_Ro.idw_Putaway.RowCount() = 0 Then
	Messagebox(w_Ro.is_Title,'You must generate the Putaway List before you can print the Collection Note!')
	Return -1
End If

ldsReport = Create DataStore
lsPlant = w_ro.idw_main.GetItemString(1, 'supp_code' )

If w_Ro.idw_Main.GetITemString(1,'wh_code') = 'PHILIPS-MY' or w_Ro.idw_Main.GetITemString(1,'wh_code') = 'TPV-MY'   or & 
	w_Ro.idw_Main.GetITemString(1,'wh_code') = 'TPV-SG'   or w_Ro.idw_Main.GetITemString(1,'wh_code') = 'FUNAI-MY'  or w_Ro.idw_Main.GetITemString(1,'wh_code') = 'GIBSON-MY'Then /* 01/13 - PCONKL - added TPV */ /* 6/13 - Added FUNAI *//*TAM 2015/03 - Added Gibson */
	ldsReport.dataobject = 'd_philips_my_return_note'
Else
	ldsReport.dataobject = 'd_philips_sg_return_note'
	//GailM 9/20/2018 S23467/s23404 Implement change to wh_code and use of signify.jpg in delivery/return note
	lsFlag = f_retrieve_parm(gs_Project, 'FLAG', 'USE SIGNIFY LOGO', 'CODE_DESCRIPT')
	If lsFlag = 'Y' and lsPlant = 'SG00' Then
		ldsReport.Modify("p_signify_logo.visible=TRUE")
		ldsReport.Modify("p_signify_logo.Filename='SIGNIFY.JPG'" )
		ldsReport.Modify("p_signify_logo.x=80")
		ldsReport.Modify("t_6.x=100")
		ldsReport.Modify("ship_from_name.x=100")
		ldsReport.Modify("ship_from_addr1.x=100")
		ldsReport.Modify("ship_from_addr2.x=100")
		ldsReport.Modify("compute_1.x=100")
	Else
		ldsReport.Modify("p_signify_logo.visible=FALSE")
		ldsReport.Modify("p_logo_2.visible=TRUE")
		ldsReport.Modify("p_logo_1.visible=TRUE")
	End If
End If

ldsREport.SetTransObject(SQLCA)


liRowsPerPage =  8

SetPointer(Hourglass!)


lsWarehouse = w_Ro.idw_Main.GetITEmString(1,'wh_Code')
lsRoNO = w_Ro.idw_Main.GetITEmString(1,'ro_no')


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
Select Name, Address_1, Address_2, Address_3, Address_4, city, state, zip, Country, Contact_person, Tel
Into :lsName, :lsAddr1, :lsAddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry, :lsContact, :lsTel
From Receive_alt_address
Where Project_id = :gs_project and ro_no = :lsRONO and Address_type = 'RC';
	
llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

ldsReport.reset()

lLRowCount = w_Ro.idw_Putaway.RowCount()
For llRowPOs = 1 to llRowCount

	lsSKU = w_Ro.idw_Putaway.GetITemString(llRowPos,'sku')
	lsSupplier = w_Ro.idw_Putaway.GetITemString(llRowPos,'supp_Code')
	lsInvType = w_Ro.idw_Putaway.GetITemString(llRowPos,'inventory_Type')
	llLineItem = w_Ro.idw_Putaway.GetITemNumber(llRowPos,'Line_Item_No')
		
	If w_Ro.idw_Putaway.GetITemNumber(lLRowPOs,'quantity') = 0 Then Continue
	
	//Roll Up To To Line/SKU/Inventory Type
	LsFind = "po_line = " + String(llLineItem) + " and SKU = '" + lsSKU + "' and Inventory_Type = '" + lsInvType + "'"
		
	llFind = ldsReport.Find(lsFind,1,ldsReport.RowCount())
	If llFind > 0 Then
		
		ldsReport.SetItem(llFind,'quantity',ldsReport.GetITemNumber(llFind,'quantity') + w_Ro.idw_Putaway.GetITemNumber(lLRowPOs,'quantity')) /*add to existing Row*/
		Continue
		
	End If
	
	
	//Insert a new report Row
	
	llNewRow = ldsReport.InsertRow(0)
	
	ldsREport.SetItem(llNewRow,'project_id',gs_project) /* 01/13 - PCONKL*/ 

	if(gs_project ='TPV') then //3/19 -Madhu - corrected Project code value.
		ldsREport.SetItem(llNewRow,'wh_code',lsWarehouse) 
	end if 
	
	//Header Notes (up to 4 rows)
	liNotePos = 0
	llFind = ldsNotes.Find("Line_Item_No = 0",1,ldsNotes.RowCount()) /* line_item = 0 for header Notes*/
	Do While llFind > 0
		
		liNotePos ++
		lsNotePos = "header_remarks" + String(liNotePos)
		ldsReport.setitem(llNewRow,lsNotePos,ldsNotes.GetITemString(llFind,"note_Text"))
		
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
		lsNoteText += ldsNotes.GetITemString(llFind,"note_Text") + " "
				
		llFind ++
		If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
			llFind = 0
		Else
			llFind = ldsNotes.Find("Line_Item_No = " + string(llLineItem),llFind,ldsNotes.RowCount())
		End If
		
	Loop
	
	ldsReport.SetItem(llNewRow,"Line_Remarks",lsNoteText)
		
	
	
	//Ship From Info Box
//	If llwarehouseRow > 0 Then /*warehouse row exists*/
			
	If lsSupplier <> lsSupplierSave Then /* 01/13 - PCONKL */
	
		Select supp_name, address_1, address_2, address_3, address_4, 
				city, state, country, zip 
		Into	 :lsSuppName,:lsSuppAddress_1, :lsSuppAddress_2, :lsSuppAddress_3, :lsSuppAddress_4,
			 	:lsSuppCity, :lsSuppState, :lsSuppCountry, :lsSuppZip
		From Supplier
		Where Project_id = :gs_project and supp_code = :lsSupplier;
	
	End If
	
	lsSupplierSave = lsSupplier
	
	
	//Hard code MMD for Plant SGT5, otherwise take from Warehouse
	If w_Ro.idw_Main.GetITemString(1,'Supp_Code') = "SGT5" Then
		lsSuppName = 'MMD SINGAPORE PTE. LTD.'   // ldsReport.SetITem(llNewRow,'ship_from_name','MMD SINGAPORE PTE. LTD.')
	Else
//			ldsReport.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
	End If
		
		
	ldsReport.SetITem(llNewRow,'ship_from_name', lsSuppName )		
	ldsReport.setitem(llNewRow,"ship_from_addr1", lsSuppAddress_1) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
	ldsReport.setitem(llNewRow,"ship_from_addr2", lsSuppAddress_2 ) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
	ldsReport.setitem(llNewRow,"ship_from_addr3", lsSuppAddress_3) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
	ldsReport.setitem(llNewRow,"ship_from_addr4", lsSuppAddress_4) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
	ldsReport.setitem(llNewRow,"ship_from_city", lsSuppCity)  //g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
	ldsReport.setitem(llNewRow,"ship_from_state", lsSuppState)  //g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
	ldsReport.setitem(llNewRow,"ship_from_country", lsSuppCountry ) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
	ldsReport.setitem(llNewRow,"ship_from_zip", lsSuppZip ) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
	 	
//	End If
	
	ldsReport.SetITem(llNewRow,'do_number', w_Ro.idw_Main.GetITemString(1,'supp_invoice_no'))
	
	//DO_TYpe
	ldsReport.SetITem(llNewRow,'DO_TYPE','Customer Return')
	
	
	//DO REceipt and DElivery Date
	ldsReport.SetITem(llNewRow,'DO_receipt_dateTime',w_Ro.idw_Main.GetITemDateTime(1,'ord_date'))
	ldsReport.SetITem(llNewRow,'delivery_date',w_Ro.idw_Main.GetITemDateTime(1,'arrival_Date'))
	
	
	
	//ldsReport.SetITem(llNewRow,'ship_to_code',idw_Main.GetITemString(1,'cust_code'))
	ldsReport.SetITem(llNewRow,'ship_to_name',lsName)
	ldsReport.SetITem(llNewRow,'ship_to_addr1',lsAddr1)
	ldsReport.SetITem(llNewRow,'ship_to_addr2',lsAddr2)
	ldsReport.SetITem(llNewRow,'ship_to_addr3',lsAddr3)
	ldsReport.SetITem(llNewRow,'ship_to_addr4',lsAddr4)
	ldsReport.SetITem(llNewRow,'ship_to_city',lsCity)
	ldsReport.SetITem(llNewRow,'ship_to_state',lsState)
	ldsReport.SetITem(llNewRow,'ship_to_zip',lsZip)
	ldsReport.SetITem(llNewRow,'ship_to_country',lsCountry)
	ldsReport.SetITem(llNewRow,'ship_to_contact',lsContact)
	ldsReport.SetITem(llNewRow,'ship_to_tel',lsTel)
	
	//Item MAster values
	ldNetWEight = 0
	
	Select alternate_Sku, description, user_field7, user_field8, user_field9, UOM_1, weight_1
	Into	 :lsAltSku,:lsDesc, :lsUF7, :lsUF8, :lsUF9, :lsUOM, :ldNetWEight
	From Item_Master
	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
		
//	if sqlca.sqlcode <> 0 then
//		MessageBox ("DB Error", SQLCA.SQLErrText )
//	end if
	
	ldsReport.SetITem(llNewRow,'sku',lsSKU)
	
	//MEA - 1/6/13 - Added for Barcode

	if ldsReport.dataobject = "d_philips_sg_return_note" or ldsReport.dataobject = "d_philips_my_return_note"  then
		ldsReport.SetITem(llNewRow,'supp_code',lsSupplier)	
	end if	
	
	
	ldsReport.SetITem(llNewRow,'description',lsDesc)	
	ldsReport.SetITem(llNewRow,'uom',lsUOM)	
	ldsReport.SetITem(llNewRow,'alt_Sku',lsAltSku)
	ldsReport.SetITem(llNewRow,'twelve_nc',lsUF7)
	ldsReport.SetITem(llNewRow,'conversion_Factor',lsUF9)
	
	If isnull(ldNetWeight)Then ldNetWeight = 0
	ldsReport.SetITem(llNewRow,'net_weight',ldNetWEight)
	
	//Volume
	If isnumber(lsUF8) Then
		ldsReport.SetITem(llNewRow,'net_volume',Dec(lsUF8))
	Else
		ldsReport.SetITem(llNewRow,'net_volume',0)
	End If
	
	ldsReport.SetITem(llNewRow,'po_line',llLineItem)
	ldsReport.SetITem(llNewRow,'quantity',w_Ro.idw_Putaway.GetITemNUmber(llRowPos,'quantity'))
	

	//Convert Menlo Inv Type to Philips
	// 01/13 - PCONKL - moved to function to accomodate TPV
//	Choose case upper(w_Ro.idw_Putaway.GetITemString(llRowPos,'inventory_type'))
//		
//		Case 'B'
//			lsPhilipsInvType = 'B'
//		Case 'C'
//			lsPhilipsInvType = 'C'
//		Case 'D'
//			lsPhilipsInvType = 'DAM'
//		Case 'K'
//			lsPhilipsInvType = 'BLCK'
//		Case 'L'
//			lsPhilipsInvType = 'REBL'
//		Case 'N'
//			lsPhilipsInvType = 'WHS'
//		Case 'R'
//			lsPhilipsInvType = 'REW'
//		Case 'S'
//			lsPhilipsInvType = 'SCRP'
//		Case Else
//			lsPhilipsInvType = w_Ro.idw_Putaway.GetITemString(llRowPos,'inventory_type')
//		End Choose

	lsPhilipsInvType = getPhilipsInvType(w_Ro.idw_Putaway.GetITemString(llRowPos,'inventory_type'))
	
	ldsReport.SetITem(llNewRow,'inventory_desc',lsPhilipsInvType)
	ldsReport.SetITem(llNewRow,'inventory_type',w_Ro.idw_Putaway.GetITemString(llRowPos,'inventory_type'))
	ldsReport.SetITem(llNewRow,'plant_Code',w_Ro.idw_Main.GetITemString(1,'Supp_Code')) /*plant code used to determine which logo to display*/
		
	//Plant/Invoice From & Company Registration
	Choose Case Upper(w_Ro.idw_Main.GetITemString(1,'Supp_Code'))
			
		Case "SG10"
			
			if gs_project = 'FUNAI' or gs_project = 'GIBSON'  then /*TAM 2015/03 - Added Gibson */
				ldsReport.SetITem(llNewRow,'company_registration','201309796D')
				ldsReport.SetITem(llNewRow,'plant_invoice_From','SG10 / 756058')
			else
				ldsReport.SetITem(llNewRow,'company_registration','199705989C')	
				ldsReport.SetITem(llNewRow,'plant_invoice_From','SG10 / 830144')
			end if
		Case "SG71"
			
			if gs_project = 'FUNAI' or gs_project = 'GIBSON'   then /*TAM 2015/03 - Added Gibson */
				ldsReport.SetITem(llNewRow,'company_registration','201309796D')
				ldsReport.SetITem(llNewRow,'plant_invoice_From','SG71 / 756059')
			else
				ldsReport.SetITem(llNewRow,'company_registration','199705989C')
				ldsReport.SetITem(llNewRow,'plant_invoice_From','SG71 / 830386')
			end if 
			
		Case "SG27"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG27 / 832889')
			ldsReport.SetITem(llNewRow,'company_registration','199705989C')			
		Case "SG00"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG00 / 830143')
			ldsReport.SetITem(llNewRow,'company_registration','196900610Z')
		Case "SG03"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG03 / 832445')
			ldsReport.SetITem(llNewRow,'company_registration','196900610Z')
		Case "SGT5"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SGT5 / 834002 ')
			ldsReport.SetITem(llNewRow,'company_registration','200822460K')
			
		Case "MY10"
			If gs_project = 'FUNAI' or gs_project = 'GIBSON'   then /*TAM 2015/03 - Added Gibson */
				ldsReport.SetITem(llNewRow,'company_registration','1053825-M')
				ldsReport.SetITem(llNewRow,'plant_invoice_From','MY10 / 756040')			
			End IF			
			
			
		Case "SGQ1"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SGQ1 / 900043 ')
			ldsReport.SetITem(llNewRow,'company_registration','201114879N')
		Case "MYQ0"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','MYQ0 / 900023 ')
			ldsReport.SetITem(llNewRow,'company_registration','952853M')
			
		// 01/13 - PCONKL - added TPV	
		Case "2190"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','2190 / 900043 ')
			ldsReport.SetITem(llNewRow,'company_registration','201114879N')
		Case "2180"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','2180 / 900023 ')
			ldsReport.SetITem(llNewRow,'company_registration','952853M')
			
			
	End Choose
	
	//PO NBR from Delivery Detail (UF3)
	llFind = w_Ro.idw_Detail.Find("Line_Item_No = " + String(llLineItem),1,w_Ro.idw_Detail.RowCount())
	If llFind > 0 Then
		ldsReport.SetITem(llNewRow,'po_nbr',w_Ro.idw_Detail.GetITemString(llFind,'User_Field3')) 
	End If
	
Next /*Putaway Row */

//Calculate Gross Volume and Gross Weight
ldGrossWEight = 0
ldGrossVolume = 0

lLRowCount = ldsReport.RowCount()
For llRowPos = 1 to lLRowCount
	
	ldGrossWeight += ldsReport.GetItemDecimal(llRowPos,'net_weight') * ldsReport.GetItemNumber(lLRowPos,'quantity')
	ldGrossVolume += ldsReport.GetItemDecimal(llRowPos,'net_volume') * ldsReport.GetItemNumber(lLRowPos,'quantity')
	
Next

ldsReport.Modify("gross_Weight_t.text='" + String(ldGrossWeight,"#########.0000") + " KG'")
ldsReport.Modify("total_volume_t.text='" + String(ldGrossVolume,"#########.0000") + " CDM'")


ldsReport.SetSort("po_line A")
ldsReport.Sort()


//Print

// check print count before printing and prompt if already printed
lsRONO = w_Ro.idw_Main.GetITemString(1,'ro_no')

Select Delivery_Note_Print_Count into :llCount
From Receive_MAster
Where ro_no = :lsRONO;
		
If isnull(llCount) Then llCount = 0
	
If llCount > 0 Then
	If Messagebox("Print Collection Note","This Collection Note has already been printed. Do you want to continue?",Stopsign!,yesNo!,2) = 2 Then
		Return 0
	End If
End If

OpenWithParm(w_dw_print_options,ldsReport) 
//If printed successfully, update Print count on Delivery_Master
If message.doubleparm = 1 then
		
	llCount ++
	
	Execute Immediate "Begin Transaction" using SQLCA;
	Update Receive_Master
	Set Delivery_Note_Print_Count = :llCount
	Where ro_no = :lsRONO;
	
	Execute Immediate "COMMIT" using SQLCA;
	
End If

SetPointer(arrow!)

If ldsReport.RowCount() > 0 Then
	w_Ro.im_menu.m_file.m_print.Enabled = TRUE
End If


Return 0
end function

public function integer uf_print_cn_mmd ();Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llFind, llLIneItem, llCount
String	lsWarehouse,  lsSKU, lsSupplier, lsAltSku, lsRONO, lsDesc, lsInvType, lsPONO
String	lsFind,lsUF7, lsUF8, lsUF9, lsUOM, lsPhilipsInvType
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText
String	lsName, lsAddr1, lsAddr2, lsAddr3, lsAddr4, lsCity, lsState, lsZip, lsCountry, lsContact, lsTel
DataStore	ldsNotes, ldsSoldToAddress, ldsReport
Int	liRowsPerPAge, liEmptyRows, liMod,  liNotePos
Decimal	ldGrossWeight, ldNetWeight, ldNetVolume, ldGrossVolume


//Putaway list must be generated
If w_ro.idw_Putaway.RowCount() = 0 Then
	Messagebox(w_ro.is_Title,'You must generate the Putaway List before you can print the Collection Note!')
	Return - 1
End If

ldsReport = Create DataStore
ldsReport.dataobject = 'd_mmd_return_note'
ldsREport.SetTransObject(SQLCA)


liRowsPerPage =  8

SetPointer(Hourglass!)


lsWarehouse = w_ro.idw_Main.GetITEmString(1,'wh_Code')
lsRoNO = w_ro.idw_Main.GetITEmString(1,'ro_no')
	
//Ship To - From Alt Address Table
Select Name, Address_1, Address_2, Address_3, Address_4, city, state, zip, Country, Contact_person, Tel
Into :lsName, :lsAddr1, :lsAddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry, :lsContact, :lsTel
From Receive_alt_address
Where Project_id = :gs_project and ro_no = :lsRONO and Address_type = 'RC';
	
llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

ldsReport.reset()

lLRowCount = w_ro.idw_Putaway.RowCount()
For llRowPOs = 1 to llRowCount

	lsSKU = w_ro.idw_Putaway.GetITemString(llRowPos,'sku')
	lsSupplier = w_ro.idw_Putaway.GetITemString(llRowPos,'supp_Code')
	lsInvType = w_ro.idw_Putaway.GetITemString(llRowPos,'inventory_Type')
	llLineItem = w_ro.idw_Putaway.GetITemNumber(llRowPos,'Line_Item_No')
		
	If w_ro.idw_Putaway.GetITemNumber(lLRowPOs,'quantity') = 0 Then Continue
	
	//Roll Up To To Line/SKU/Inventory Type
	LsFind = "po_line = " + String(llLineItem) + " and SKU = '" + lsSKU + "' and Inventory_Type = '" + lsInvType + "'"
		
	llFind = ldsReport.Find(lsFind,1,ldsReport.RowCount())
	If llFind > 0 Then
		
		ldsReport.SetItem(llFind,'quantity',ldsReport.GetITemNumber(llFind,'quantity') + w_ro.idw_Putaway.GetITemNumber(lLRowPOs,'quantity')) /*add to existing Row*/
		Continue
		
	End If
	
	
	//Insert a new report Row
	
	llNewRow = ldsReport.InsertRow(0)
	
	//Ship From Info Box
	If llwarehouseRow > 0 Then /*warehouse row exists*/
	
		//Hard code MMD for Plant SGT5, otherwise take from Warehouse
		If w_ro.idw_Main.GetITemString(1,'Supp_Code') = "SGT5" Then
			ldsReport.SetITem(llNewRow,'ship_from_name','MMD SINGAPORE PTE. LTD.')
		Else
			ldsReport.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
		End If
				
		ldsReport.setitem(llNewRow,"ship_from_addr1",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
		ldsReport.setitem(llNewRow,"ship_from_addr2",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
		ldsReport.setitem(llNewRow,"ship_from_addr3",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
		ldsReport.setitem(llNewRow,"ship_from_addr4",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
		ldsReport.setitem(llNewRow,"ship_from_city",g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
		ldsReport.setitem(llNewRow,"ship_from_state",g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
		ldsReport.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
		ldsReport.setitem(llNewRow,"ship_from_zip",g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
	 	
	End If
	
	ldsReport.SetITem(llNewRow,'do_number', w_ro.idw_Main.GetITemString(1,'supp_invoice_no'))
	ldsReport.SetITem(llNewRow,'header_remarks1', w_ro.idw_Main.GetITemString(1,'remark'))
	
	//DO_TYpe
	ldsReport.SetITem(llNewRow,'DO_TYPE','Customer Return')
	
	
	//DO REceipt and DElivery Date
	ldsReport.SetITem(llNewRow,'DO_receipt_dateTime',w_ro.idw_Main.GetITemDateTime(1,'ord_date'))
	ldsReport.SetITem(llNewRow,'delivery_date',w_ro.idw_Main.GetITemDateTime(1,'arrival_Date'))
	
	
	
	//ldsReport.SetITem(llNewRow,'ship_to_code',idw_Main.GetITemString(1,'cust_code'))
	ldsReport.SetITem(llNewRow,'ship_to_name',lsName)
	ldsReport.SetITem(llNewRow,'ship_to_addr1',lsAddr1)
	ldsReport.SetITem(llNewRow,'ship_to_addr2',lsAddr2)
	ldsReport.SetITem(llNewRow,'ship_to_addr3',lsAddr3)
	ldsReport.SetITem(llNewRow,'ship_to_addr4',lsAddr4)
	ldsReport.SetITem(llNewRow,'ship_to_city',lsCity)
	ldsReport.SetITem(llNewRow,'ship_to_state',lsState)
	ldsReport.SetITem(llNewRow,'ship_to_zip',lsZip)
	ldsReport.SetITem(llNewRow,'ship_to_country',lsCountry)
	ldsReport.SetITem(llNewRow,'ship_to_contact',lsContact)
	ldsReport.SetITem(llNewRow,'ship_to_tel',lsTel)
	
	//Item MAster values
	ldNetWEight = 0
	
	Select alternate_Sku, description, user_field7, user_field8, user_field9, UOM_1, weight_1
	Into	 :lsAltSku,:lsDesc, :lsUF7, :lsUF8, :lsUF9, :lsUOM, :ldNetWEight
	From Item_Master
	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
		
	if sqlca.sqlcode <> 0 then
		MessageBox ("DB Error", SQLCA.SQLErrText )
	end if
	
	ldsReport.SetITem(llNewRow,'sku',lsSKU)
	ldsReport.SetITem(llNewRow,'description',lsDesc)	
	ldsReport.SetITem(llNewRow,'uom',lsUOM)	
	ldsReport.SetITem(llNewRow,'alt_Sku',lsAltSku)
	ldsReport.SetITem(llNewRow,'twelve_nc',lsUF7)
	ldsReport.SetITem(llNewRow,'conversion_Factor',lsUF9)
	
	If isnull(ldNetWeight)Then ldNetWeight = 0
	ldsReport.SetITem(llNewRow,'net_weight',ldNetWEight)
	
	//Volume
	If isnumber(lsUF8) Then
		ldsReport.SetITem(llNewRow,'net_volume',Dec(lsUF8))
	Else
		ldsReport.SetITem(llNewRow,'net_volume',0)
	End If
	
	ldsReport.SetITem(llNewRow,'po_line',llLineItem)
	ldsReport.SetITem(llNewRow,'quantity',w_ro.idw_Putaway.GetITemNUmber(llRowPos,'quantity'))
	

	//Convert Menlo Inv Type to Philips
	Choose case upper(w_ro.idw_Putaway.GetITemString(llRowPos,'inventory_type'))
		
		Case 'B'
			lsPhilipsInvType = 'NORMAL-B'
		Case 'C'
			lsPhilipsInvType = 'NORMAL-C'
		Case 'D'
			lsPhilipsInvType = 'DAMAGED'
		Case 'N'
			lsPhilipsInvType = 'NORMAL'
		Case 'W'
			lsPhilipsInvType = 'REWORK'
		Case 'X'
			lsPhilipsInvType = 'SCRAP'
		Case Else
			lsPhilipsInvType = w_ro.idw_Putaway.GetITemString(llRowPos,'inventory_type')
		End Choose
	
	ldsReport.SetITem(llNewRow,'inventory_desc',lsPhilipsInvType)
	ldsReport.SetITem(llNewRow,'inventory_type',w_ro.idw_Putaway.GetITemString(llRowPos,'inventory_type'))
	ldsReport.SetITem(llNewRow,'plant_Code',w_ro.idw_Main.GetITemString(1,'Supp_Code')) /*plant code used to determine which logo to display*/
	ldsReport.SetITem(llNewRow,'company_registration','200822460K')
	
		
	//PO NBR from Delivery Detail (UF3)
	llFind = w_ro.idw_Detail.Find("Line_Item_No = " + String(llLineItem),1,w_ro.idw_Detail.RowCount())
	If llFind > 0 Then
		ldsReport.SetITem(llNewRow,'po_nbr',w_ro.idw_Detail.GetITemString(llFind,'User_Field3')) 
	End If
	
Next /*Putaway Row */

//Calculate Gross Volume and Gross Weight
ldGrossWEight = 0
ldGrossVolume = 0

lLRowCount = ldsReport.RowCount()
For llRowPos = 1 to lLRowCount
	
	ldGrossWeight += ldsReport.GetItemDecimal(llRowPos,'net_weight') * ldsReport.GetItemNumber(lLRowPos,'quantity')
	ldGrossVolume += ldsReport.GetItemDecimal(llRowPos,'net_volume') * ldsReport.GetItemNumber(lLRowPos,'quantity')
	
Next

ldsReport.Modify("gross_Weight_t.text='" + String(ldGrossWeight,"#########.0000") + " KG'")
ldsReport.Modify("total_volume_t.text='" + String(ldGrossVolume,"#########.0000") + " CDM'")


ldsReport.SetSort("po_line A")
ldsReport.Sort()


//Print

// check print count before printing and prompt if already printed
lsRONO = w_ro.idw_Main.GetITemString(1,'ro_no')

Select Delivery_Note_Print_Count into :llCount
From Receive_MAster
Where ro_no = :lsRONO;
		
If isnull(llCount) Then llCount = 0
	
If llCount > 0 Then
	If Messagebox("Print Collection Note","This Collection Note has already been printed. Do you want to continue?",Stopsign!,yesNo!,2) = 2 Then
		Return 0
	End If
End If

OpenWithParm(w_dw_print_options,ldsReport) 
//If printed successfully, update Print count on Delivery_Master
If message.doubleparm = 1 then
		
	llCount ++
	
	Execute Immediate "Begin Transaction" using SQLCA;
	Update Receive_Master
	Set Delivery_Note_Print_Count = :llCount
	Where ro_no = :lsRONO;
	
	Execute Immediate "COMMIT" using SQLCA;
	
End If

SetPointer(arrow!)

If ldsReport.RowCount() > 0 Then
	w_ro.im_menu.m_file.m_print.Enabled = TRUE
End If

Return 0
end function

public function integer uf_print_cn_warner ();
//Print the Warner DN

DataStore	ldsREport
String	lsRONO, lsCust, lsSKU, lsSUpplier, lsCustSKU, lsSKUprev
Int		liRowsPerPage, liEmptyRows, liMod, liRowPos
	
SetPointer(Hourglass!)

ldsReport = Create Datastore
ldsReport.dataobject = 'd_warner_return_note'
ldsREport.SetTransObject(SQLCA)

lsRONO = w_ro.idw_Main.GetITEmSTring(1,'ro_no')

ldsREport.Retrieve(lsRONO)

If ldsREport.RowCOunt() > 0 Then
	
	OpenWithParm(w_dw_print_options,ldsReport) 
	
Else
	
	MessageBox(w_do.is_title, 'There are no records to print for the Return Note')
	
End If

SetPointer(arrow!)

REturn 0
end function

public function integer uf_print_dn_philips_th ();
//Print the Philips Delivery Note
Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llFind, llLIneItem
String	lsWarehouse,  lsSKU, lsSupplier, lsAltSku, lsDONO, lsDesc, lsInvType, lsPONO, lsPlant, lsSerial
String	lsFind,lsUF7, lsUF8, lsUF9, lsUOM, lsPhilipsInvType, lsFlag
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText
DataStore	ldsNotes, ldsSoldToAddress, ldsserial, ldsReport
Int	liRowsPerPAge, liEmptyRows, liMod,  liNotePos
Decimal {4} ldGrossWeight, ldNetWeight, ldNetVolume, ldGrossVolume

lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')
lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
lsPlant = w_do.idw_Main.GetITemString(1,'User_Field3')

//Pack list must be generated
If w_do.idw_pack.RowCount() = 0 Then
	Messagebox(w_do.is_Title,'You must generate the Pack List before you can print the Delivery Note!')
	Return -1
End If
	
ldsReport = Create Datastore

ldsReport.dataobject = 'd_philips_th_delivery_note'

liRowsPerPage =  8

SetPointer(Hourglass!)

//GailM 9/20/2018 S23467/s23404 Implement change to wh_code and use of signify.jpg in delivery/return note
lsFlag = f_retrieve_parm(gs_Project, 'FLAG', 'USE SIGNIFY LOGO', 'CODE_DESCRIPT')
If lsFlag = 'Y' and lsPlant <> 'THL0' Then	
	ldsReport.Modify("p_logo_1.Filename='SIGNIFY.JPG'" )				// Signify logo
Else
	If lsWarehouse ='PHILIPS-NC' or lsPlant = 'THL0' then
		ldsReport.dataobject = 'd_philips_th_delivery_note_nc'			// Lumileds logo
	Else
		ldsReport.Modify("p_logo_1.Filename='philips_logo_2.JPG'" )
	End If
End If

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

ldsReport.reset()
//ldsReport.SetRedraw(False)

lLRowCount = w_do.idw_Pick.RowCount()
For llRowPOs = 1 to llRowCount

	lsSKU = w_do.idw_Pick.GetITemString(llRowPos,'sku')
	lsSupplier = w_do.idw_Pick.GetITemString(llRowPos,'supp_Code')
	lsInvType = w_do.idw_Pick.GetITemString(llRowPos,'inventory_Type')
	llLineItem = w_do.idw_Pick.GetITemNumber(llRowPos,'Line_Item_No')
		
	
	If w_do.idw_Pick.GetITemNumber(lLRowPOs,'quantity') = 0 Then Continue
	
	//Roll Up To To Line/SKU/Inventory Type
	LsFind = "po_line = " + String(llLineItem) + " and SKU = '" + lsSKU + "' and Inventory_Type = '" + lsInvType + "'"
		
	llFind = ldsReport.Find(lsFind,1,ldsReport.RowCount())
	If llFind > 0 Then
		
		ldsReport.SetItem(llFind,'quantity',ldsReport.GetITemNumber(llFind,'quantity') + w_do.idw_Pick.GetITemNumber(lLRowPOs,'quantity')) /*add to existing Row*/
		Continue
		
	End If
	
	
	//Insert a new report Row
	
	llNewRow = ldsReport.InsertRow(0)

	//Header Notes (up to 4 rows)
	liNotePos = 0
	llFind = ldsNotes.Find("Line_Item_No = 0",1,ldsNotes.RowCount()) /* line_item = 0 for header Notes*/
	Do While llFind > 0
		
		liNotePos ++
		lsNotePos = "header_remarks" + String(liNotePos)
		ldsReport.setitem(llNewRow,lsNotePos,ldsNotes.GetITemString(llFind,"note_Text"))
		
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
	
	ldsReport.SetItem(llNewRow,"Line_Remarks",lsNoteText)
	
	
	//Ship From Info Box
	If llwarehouseRow > 0 Then /*warehouse row exists*/
	

		ldsReport.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
		
		
		ldsReport.setitem(llNewRow,"ship_from_addr1",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
		ldsReport.setitem(llNewRow,"ship_from_addr2",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
		ldsReport.setitem(llNewRow,"ship_from_addr3",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
		ldsReport.setitem(llNewRow,"ship_from_addr4",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
		ldsReport.setitem(llNewRow,"ship_from_city",g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
		ldsReport.setitem(llNewRow,"ship_from_state",g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
		ldsReport.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
		ldsReport.setitem(llNewRow,"ship_from_zip",g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
	 	
	End If
	
	ldsReport.SetITem(llNewRow,'do_number', w_do.idw_Main.GetITemString(1,'invoice_no'))
	ldsReport.SetITem(llNewRow,'route', w_do.idw_Main.GetITemString(1,'USer_Field2'))
	
//	//DO_TYpe
//	If lsPlant = "MY10" Then /*No DO Type for Malaysia */
//	Else
//		If Upper(w_do.idw_Main.GetITemString(1,'country')) <> 'SG' and w_do.idw_Main.GetITemString(1,'country') <> 'SINGAPORE' Then
//			ldsReport.SetITem(llNewRow,'DO_TYPE','Export')
//		Elseif Upper(w_do.idw_Main.GetITemString(1,'USer_Field2')) = 'SG9999' Then
//			ldsReport.SetITem(llNewRow,'DO_TYPE','Self Collection')
//		Elseif Upper(w_do.idw_Main.GetITemString(1,'USer_Field2')) = 'SGM9' Then /* 09/09 - PCONKL */
//			ldsReport.SetITem(llNewRow,'DO_TYPE','STO')
//		Else
//			ldsReport.SetITem(llNewRow,'DO_TYPE','Normal Delivery')
//		End If
//	End If
	
	//DO REceipt and DElivery Date
	ldsReport.SetITem(llNewRow,'DO_receipt_dateTime',w_do.idw_Main.GetITemDateTime(1,'ord_date'))
	ldsReport.SetITem(llNewRow,'delivery_date',w_do.idw_Main.GetITemDateTime(1,'request_Date'))
	
	ldsReport.SetITem(llNewRow,'sales_order_nbr',w_do.idw_Main.GetItemString(1,'cust_order_no'))

		
	//Ship To
	ldsReport.SetITem(llNewRow,'ship_to_code',w_do.idw_Main.GetITemString(1,'cust_code'))
	ldsReport.SetITem(llNewRow,'ship_to_name',w_do.idw_Main.GetITemString(1,'cust_Name'))
	ldsReport.SetITem(llNewRow,'ship_to_addr1',w_do.idw_Main.GetITemString(1,'address_1'))
	ldsReport.SetITem(llNewRow,'ship_to_addr2',w_do.idw_Main.GetITemString(1,'address_2'))
	ldsReport.SetITem(llNewRow,'ship_to_addr3',w_do.idw_Main.GetITemString(1,'address_3'))
	ldsReport.SetITem(llNewRow,'ship_to_addr4',w_do.idw_Main.GetITemString(1,'address_4'))
	ldsReport.SetITem(llNewRow,'ship_to_addr5',w_do.idw_Main.GetITemString(1,'user_field16'))	
	ldsReport.SetITem(llNewRow,'ship_to_city',w_do.idw_Main.GetITemString(1,'city'))
	ldsReport.SetITem(llNewRow,'ship_to_state',w_do.idw_Main.GetITemString(1,'state'))
	ldsReport.SetITem(llNewRow,'ship_to_zip',w_do.idw_Main.GetITemString(1,'zip'))
	ldsReport.SetITem(llNewRow,'ship_to_country',w_do.idw_Main.GetITemString(1,'country'))
	ldsReport.SetITem(llNewRow,'ship_to_contact',w_do.idw_Main.GetITemString(1,'contact_person'))
	ldsReport.SetITem(llNewRow,'ship_to_tel',w_do.idw_Main.GetITemString(1,'tel'))
	ldsReport.SetITem(llNewRow,'ship_to_district',w_do.idw_Main.GetITemString(1,'district'))

	
	//Sold To Address
	If ldsSoldToAddress.RowCount() > 0 Then
	
		ldsReport.SetITem(llNewRow,'sold_to_name',ldsSoldToAddress.GetITemString(1,'name'))
		ldsReport.setitem(llNewRow,"sold_to_addr1",ldsSoldToAddress.GetITemString(1,'address_1'))
		ldsReport.setitem(llNewRow,"sold_to_addr2",ldsSoldToAddress.GetITemString(1,'address_2'))
		ldsReport.setitem(llNewRow,"sold_to_addr3",ldsSoldToAddress.GetITemString(1,'address_3'))
		ldsReport.setitem(llNewRow,"sold_to_addr4",ldsSoldToAddress.GetITemString(1,'address_4'))
		ldsReport.setitem(llNewRow,"sold_to_district",ldsSoldToAddress.GetITemString(1,'district'))
		ldsReport.setitem(llNewRow,"sold_to_city",ldsSoldToAddress.GetITemString(1,'city'))
		ldsReport.setitem(llNewRow,"sold_to_state",ldsSoldToAddress.GetITemString(1,'state'))
		ldsReport.setitem(llNewRow,"sold_to_zip",ldsSoldToAddress.GetITemString(1,'zip'))
		ldsReport.setitem(llNewRow,"sold_to_country",ldsSoldToAddress.GetITemString(1,'country'))
			
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
	
	ldsReport.SetITem(llNewRow,'sku',lsSKU)
	ldsReport.SetITem(llNewRow,'description',lsDesc)	
	ldsReport.SetITem(llNewRow,'uom',lsUOM)	
	ldsReport.SetITem(llNewRow,'alt_Sku',lsAltSku)
	ldsReport.SetITem(llNewRow,'twelve_nc',lsUF7)
	ldsReport.SetITem(llNewRow,'conversion_Factor',lsUF9)
	
	ldsReport.SetITem(llNewRow,'product_no_id',lsUF7)	
	
	If isnull(ldNetWeight)Then ldNetWeight = 0
	ldsReport.SetITem(llNewRow,'net_weight',ldNetWEight)
	
	//Volume
	If isnumber(lsUF8) Then
		ldsReport.SetITem(llNewRow,'net_volume',Dec(lsUF8))
	Else
		ldsReport.SetITem(llNewRow,'net_volume',0)
	End If
	
	ldsReport.SetITem(llNewRow,'po_line',llLineItem)
	ldsReport.SetITem(llNewRow,'quantity',w_do.idw_Pick.GetITemNUmber(llRowPos,'quantity'))
	

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
	
	ldsReport.SetITem(llNewRow,'inventory_desc',lsPhilipsInvType)
	ldsReport.SetITem(llNewRow,'inventory_type',w_do.idw_Pick.GetITemString(llRowPos,'inventory_type'))
	ldsReport.SetITem(llNewRow,'plant_Code',lsPlant) /*plant code used to determine which logo to display*/
		
	//Plant/Invoice From & Company Registration
	Choose Case Upper(w_do.idw_Main.GetITemString(1,'User_Field3'))
			
		Case "SG10"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG10 / 830144')				
			ldsReport.SetITem(llNewRow,'company_registration','199705989C')
	
			
		Case "SG71"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG71 / 830386')
			ldsReport.SetITem(llNewRow,'company_registration','199705989C')
		Case "SG00"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG00 / 830143')
			ldsReport.SetITem(llNewRow,'company_registration','199705989C')
		Case "SG03"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG03 / 832445')
			ldsReport.SetITem(llNewRow,'company_registration','199705989C')
		Case "SGT5"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SGT5 / 834002 ')
			ldsReport.SetITem(llNewRow,'company_registration','200822460K')
		Case "MY10"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','MY10')	
		Case "SGQ1"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SGQ1 / 900043 ')
			ldsReport.SetITem(llNewRow,'company_registration','201114879N')
		Case "MYQ0"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','MYQ0 / 900023 ')
			ldsReport.SetITem(llNewRow,'company_registration','952853M')

			
	End Choose
	
	//PO NBR from Delivery Detail (UF3)
	llFind = w_do.idw_Detail.Find("Line_Item_No = " + String(llLineItem),1,w_do.idw_Detail.RowCount())
	If llFind > 0 Then
		ldsReport.SetITem(llNewRow,'po_nbr',w_do.idw_Detail.GetITemString(llFind,'User_Field3')) 
	End If
	
	
Next /*Picking Row */

//Calculate Gross Volume and Gross Weight
ldGrossWEight = 0
ldGrossVolume = 0

lLRowCount = ldsReport.RowCount()
For llRowPos = 1 to lLRowCount
	
	ldGrossWeight += ldsReport.GetItemDecimal(llRowPos,'net_weight') * ldsReport.GetItemDecimal(lLRowPos,'quantity')
	ldGrossVolume += ldsReport.GetItemDecimal(llRowPos,'net_volume') * ldsReport.GetItemDecimal(lLRowPos,'quantity')
	
Next

ldsReport.Modify("gross_Weight_t.text='" + String(ldGrossWeight,"#########.0000") + " KG'")
ldsReport.Modify("total_volume_t.text='" + String(ldGrossVolume,"#########.0000") + " CDM'")

//Show in Override DW (users need to be able to override Weight and Volume
//dw_select.SetITem(1,'total_weight',ldGrossWeight)
//dw_select.SetITem(1,'total_volume',ldGrossVolume)


//Add any necessary empty rows so sumamry is at bottom of last page
liEmptyRows = 0
If ldsReport.RowCount() < liRowsPerPage Then
	liEmptyRows = liRowsPerPage - ldsReport.RowCount()
ElseIf ldsReport.RowCount() > liRowsPerPage Then
	liMod = Mod(ldsReport.RowCount(), liRowsPerPage)
	If liMod > 0 Then
		liEmptyRows = liRowsPerPage - liMod
	End IF
End If

If liEmptyRows > 0 Then
	For llRowPos = 1 to liEmptyRows
//		ldsReport.InsertRow(0)
	Next
End If

ldsReport.SetSort("po_line A")
ldsReport.Sort()

//Print

String	 lsType
Int		llCount

// check print count before printing and prompt if already printed
lsDONO = w_do.idw_Main.GetITemString(1,'do_no')

Select Delivery_Note_Print_Count into :llCount
From Delivery_MAster
Where do_no = :lsDONO;
	
If isnull(llCount) Then llCount = 0
	
If llCount > 0 Then
	If Messagebox("Print DELIVERY Note","This DELIVERY Note has already been printed. Do you want to continue?",Stopsign!,yesNo!,2) = 2 Then
		Return 0
	End If
End If

OpenWithParm(w_dw_print_options,ldsReport) 
//If printed successfully, update Print count on Delivery_Master
If message.doubleparm = 1 then
		
	llCount ++
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Delivery_Master
	Set Delivery_Note_Print_Count = :llCount
	Where do_no = :lsDONO;
		
	Execute Immediate "COMMIT" using SQLCA;
	
End If

SetPointer(arrow!)







Return 0
end function

public function integer uf_print_cn_philips_th ();
Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llFind, llLIneItem, llCount
String	lsWarehouse,  lsSKU, lsSupplier, lsAltSku, lsRONO, lsDesc, lsInvType, lsPONO
String	lsFind,lsUF7, lsUF8, lsUF9, lsUOM, lsPhilipsInvType, lsFlag
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText
String	lsName, lsAddr1, lsAddr2, lsAddr3, lsAddr4, lsCity, lsState, lsZip, lsCountry, lsContact, lsTel
DataStore	ldsNotes, ldsSoldToAddress, ldsReport
Int	liRowsPerPAge, liEmptyRows, liMod,  liNotePos
Decimal	ldGrossWeight, ldNetWeight, ldNetVolume, ldGrossVolume
String lsDistrict


//Putaway list must be generated
If w_Ro.idw_Putaway.RowCount() = 0 Then
	Messagebox(w_Ro.is_Title,'You must generate the Putaway List before you can print the Collection Note!')
	Return -1
End If

ldsReport = Create DataStore

ldsReport.dataobject = 'd_philips_th_return_note'

ldsREport.SetTransObject(SQLCA)


liRowsPerPage =  8

SetPointer(Hourglass!)


lsWarehouse = w_ro.idw_Main.GetITEmString(1,'wh_Code')
//Nxjain change the logo for NC warehous 
if lsWarehouse ='PHILIPS-NC' then
	ldsReport.dataobject = 'd_philips_th_return_note_nc'
Else
	//GailM 9/20/2018 S23467/s23404 Implement change to wh_code and use of signify.jpg in delivery/return note
	lsFlag = f_retrieve_parm(gs_Project, 'FLAG', 'USE SIGNIFY LOGO', 'CODE_DESCRIPT')
	If lsFlag = 'Y' Then
		ldsReport.Modify("p_logo_1.Filename='SIGNIFY.JPG'" )
	Else
		ldsReport.Modify("p_logo_1.Filename='philips_logo_2.JPG'" )
	End If
end if 
//nxjain 02-25-2015


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

ldsReport.reset()
//ldsReport.SetRedraw(False)

lLRowCount = w_ro.idw_Putaway.RowCount()
For llRowPOs = 1 to llRowCount

	lsSKU = w_ro.idw_Putaway.GetITemString(llRowPos,'sku')
	lsSupplier = w_ro.idw_Putaway.GetITemString(llRowPos,'supp_Code')
	lsInvType = w_ro.idw_Putaway.GetITemString(llRowPos,'inventory_Type')
	llLineItem = w_ro.idw_Putaway.GetITemNumber(llRowPos,'Line_Item_No')
		
	If w_ro.idw_Putaway.GetITemNumber(lLRowPOs,'quantity') = 0 Then Continue
	
	//Roll Up To To Line/SKU/Inventory Type
	LsFind = "po_line = " + String(llLineItem) + " and SKU = '" + lsSKU + "' and Inventory_Type = '" + lsInvType + "'"
		
	llFind = ldsReport.Find(lsFind,1,ldsReport.RowCount())
	If llFind > 0 Then
		
		ldsReport.SetItem(llFind,'quantity',ldsReport.GetITemNumber(llFind,'quantity') + w_ro.idw_Putaway.GetITemNumber(lLRowPOs,'quantity')) /*add to existing Row*/
		Continue
		
	End If
	
	
	//Insert a new report Row
	
	llNewRow = ldsReport.InsertRow(0)

	//Header Notes (up to 4 rows)
	liNotePos = 0
	llFind = ldsNotes.Find("Line_Item_No = 0",1,ldsNotes.RowCount()) /* line_item = 0 for header Notes*/
	Do While llFind > 0 AND llFind <= ldsNotes.RowCount()
		
	
		if ldsNotes.GetITemNumber(llFind,"Note_seq_No") = 1 then
			
			ldsReport.setitem(llNewRow,"return_reason",ldsNotes.GetITemString(llFind,"note_Text"))
			llFind ++
		else
		
			liNotePos ++
			lsNotePos = "header_remarks" + String(liNotePos)
			ldsReport.setitem(llNewRow,lsNotePos,ldsNotes.GetITemString(llFind,"note_Text"))
			
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
	Do While llFind > 0 AND llFind <= ldsNotes.RowCount()
		
		liNotePos ++
		lsNoteText += ldsNotes.GetITemString(llFind,"note_Text")  + char(10)
				
		llFind ++
		If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
			llFind = 0
		Else
			llFind = ldsNotes.Find("Line_Item_No = " + string(llLineItem),llFind,ldsNotes.RowCount())
		End If
		
	Loop
	
	ldsReport.SetItem(llNewRow,"Line_Remarks",lsNoteText)
	
	
	//Ship From Info Box
	If llwarehouseRow > 0 Then /*warehouse row exists*/
	
		//Hard code MMD for Plant SGT5, otherwise take from Warehouse
		ldsReport.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
				
		ldsReport.setitem(llNewRow,"ship_from_addr1",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
		ldsReport.setitem(llNewRow,"ship_from_addr2",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
		ldsReport.setitem(llNewRow,"ship_from_addr3",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
		ldsReport.setitem(llNewRow,"ship_from_addr4",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
		ldsReport.setitem(llNewRow,"ship_from_city",g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
		ldsReport.setitem(llNewRow,"ship_from_state",g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
		ldsReport.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
		ldsReport.setitem(llNewRow,"ship_from_zip",g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
	 	
	End If
	
	ldsReport.SetITem(llNewRow,'do_number', w_ro.idw_Main.GetITemString(1,'supp_invoice_no'))
	
	//DO_TYpe
	ldsReport.SetITem(llNewRow,'DO_TYPE','Customer Return')
	
	
	//DO REceipt and DElivery Date
	ldsReport.SetITem(llNewRow,'DO_receipt_dateTime',w_ro.idw_Main.GetITemDateTime(1,'ord_date'))
	ldsReport.SetITem(llNewRow,'delivery_date',w_ro.idw_Main.GetITemDateTime(1,'arrival_Date'))
	
	ldsReport.SetITem(llNewRow,'sales_order_nbr',w_ro.idw_Main.GetITemString(1,'supp_order_no'))

	
	
	
	ldsReport.SetITem(llNewRow,'ship_to_code',w_ro.idw_Main.GetITemString(1,'User_Field10'))
	ldsReport.SetITem(llNewRow,'ship_to_name',lsName)
	ldsReport.SetITem(llNewRow,'ship_to_addr1',lsAddr1)
	ldsReport.SetITem(llNewRow,'ship_to_addr2',lsAddr2)
	ldsReport.SetITem(llNewRow,'ship_to_addr3',lsAddr3)
	ldsReport.SetITem(llNewRow,'ship_to_addr4',lsAddr4)
	ldsReport.SetITem(llNewRow,'ship_to_city',lsCity)
	ldsReport.SetITem(llNewRow,'ship_to_state',lsState)
	ldsReport.SetITem(llNewRow,'ship_to_zip',lsZip)
	ldsReport.SetITem(llNewRow,'ship_to_country',lsCountry)
	ldsReport.SetITem(llNewRow,'ship_to_contact',lsContact)
	ldsReport.SetITem(llNewRow,'ship_to_tel',lsTel)
	ldsReport.SetITem(llNewRow,'ship_to_district',lsDistrict)

	
	//Item MAster values
	ldNetWEight = 0
	
	Select alternate_Sku, description, user_field7, user_field8, user_field9, UOM_1, weight_1
	Into	 :lsAltSku,:lsDesc, :lsUF7, :lsUF8, :lsUF9, :lsUOM, :ldNetWEight
	From Item_Master
	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
		
	if sqlca.sqlcode <> 0 then
		MessageBox ("DB Error", SQLCA.SQLErrText )
	end if
	
	ldsReport.SetITem(llNewRow,'sku',lsSKU)
	ldsReport.SetITem(llNewRow,'description',lsDesc)	
	ldsReport.SetITem(llNewRow,'uom',lsUOM)	
	ldsReport.SetITem(llNewRow,'alt_Sku',lsAltSku)
//	ldsReport.SetITem(llNewRow,'twelve_nc',lsUF7)
	ldsReport.SetITem(llNewRow,'conversion_Factor',lsUF9)
	
	ldsReport.SetITem(llNewRow,'product_no_id',lsUF7)	
	
	
	If isnull(ldNetWeight)Then ldNetWeight = 0
	ldsReport.SetITem(llNewRow,'net_weight',ldNetWEight)
	
	//Volume
	If isnumber(lsUF8) Then
		ldsReport.SetITem(llNewRow,'net_volume',Dec(lsUF8))
	Else
		ldsReport.SetITem(llNewRow,'net_volume',0)
	End If
	
	ldsReport.SetITem(llNewRow,'po_line',llLineItem)
	ldsReport.SetITem(llNewRow,'quantity',w_ro.idw_Putaway.GetITemNUmber(llRowPos,'quantity'))
	

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
	
	ldsReport.SetITem(llNewRow,'inventory_desc',lsPhilipsInvType)
	ldsReport.SetITem(llNewRow,'inventory_type',w_ro.idw_Putaway.GetITemString(llRowPos,'inventory_type'))
	ldsReport.SetITem(llNewRow,'plant_Code',w_ro.idw_Main.GetITemString(1,'Supp_Code')) /*plant code used to determine which logo to display*/
		
	//Plant/Invoice From & Company Registration
	Choose Case Upper(w_ro.idw_Main.GetITemString(1,'Supp_Code'))
			
		Case "SG10"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG10 / 830144')
			ldsReport.SetITem(llNewRow,'company_registration','199705989C')
		Case "SG71"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG71 / 830386')
			ldsReport.SetITem(llNewRow,'company_registration','199705989C')
		Case "SG00"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG00 / 830143')
			ldsReport.SetITem(llNewRow,'company_registration','199705989C')
		Case "SG03"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG03 / 832445')
			ldsReport.SetITem(llNewRow,'company_registration','199705989C')
		Case "SGT5"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SGT5 / 834002 ')
			ldsReport.SetITem(llNewRow,'company_registration','200822460K')
		Case "SGQ1"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SGQ1 / 900043 ')
			ldsReport.SetITem(llNewRow,'company_registration','201114879N')
		Case "MYQ0"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','MYQ0 / 900023 ')
			ldsReport.SetITem(llNewRow,'company_registration','952853M')
			
	End Choose
	
	//PO NBR from Delivery Detail (UF3)
	llFind = w_ro.idw_Detail.Find("Line_Item_No = " + String(llLineItem),1,w_ro.idw_Detail.RowCount())
	If llFind > 0 Then
		ldsReport.SetITem(llNewRow,'po_nbr',w_ro.idw_Detail.GetITemString(llFind,'User_Field3')) 
	End If
	
Next /*Putaway Row */

//Calculate Gross Volume and Gross Weight
ldGrossWEight = 0
ldGrossVolume = 0

lLRowCount = ldsReport.RowCount()
For llRowPos = 1 to lLRowCount
	
	ldGrossWeight += ldsReport.GetItemDecimal(llRowPos,'net_weight') * ldsReport.GetItemNumber(lLRowPos,'quantity')
	ldGrossVolume += ldsReport.GetItemDecimal(llRowPos,'net_volume') * ldsReport.GetItemNumber(lLRowPos,'quantity')
	
Next

ldsReport.Modify("gross_Weight_t.text='" + String(ldGrossWeight,"#########.0000") + " KG'")
ldsReport.Modify("total_volume_t.text='" + String(ldGrossVolume,"#########.0000") + " CDM'")

//Show in Override DW (users need to be able to override Weight and Volume
//MAdw_select.SetITem(1,'total_weight',ldGrossWeight)
//MA dw_select.SetITem(1,'total_volume',ldGrossVolume)

//Add any necessary empty rows so sumamry is at bottom of last page
//liEmptyRows = 0
//If ldsReport.RowCount() < liRowsPerPage Then
//	liEmptyRows = liRowsPerPage - ldsReport.RowCount()
//ElseIf ldsReport.RowCount() > liRowsPerPage Then
//	liMod = Mod(ldsReport.RowCount(), liRowsPerPage)
//	If liMod > 0 Then
//		liEmptyRows = liRowsPerPage - liMod
//	End IF
//End If
//
//If liEmptyRows > 0 Then
//	For llRowPos = 1 to liEmptyRows
//		ldsReport.InsertRow(0)
//	Next
//End If

ldsReport.SetSort("po_line A")
ldsReport.Sort()

//ldsReport.SetRedraw(True)
SetPointer(arrow!)

//Print

// check print count before printing and prompt if already printed
lsRONO = w_Ro.idw_Main.GetITemString(1,'ro_no')

Select Delivery_Note_Print_Count into :llCount
From Receive_MAster
Where ro_no = :lsRONO;
		
If isnull(llCount) Then llCount = 0
	
If llCount > 0 Then
	If Messagebox("Print Collection Note","This Collection Note has already been printed. Do you want to continue?",Stopsign!,yesNo!,2) = 2 Then
		Return 0
	End If
End If

OpenWithParm(w_dw_print_options,ldsReport) 
//If printed successfully, update Print count on Delivery_Master
If message.doubleparm = 1 then
		
	llCount ++
	
	Execute Immediate "Begin Transaction" using SQLCA;
	Update Receive_Master
	Set Delivery_Note_Print_Count = :llCount
	Where ro_no = :lsRONO;
	
	Execute Immediate "COMMIT" using SQLCA;
	
End If

SetPointer(arrow!)

If ldsReport.RowCount() > 0 Then
	w_Ro.im_menu.m_file.m_print.Enabled = TRUE
End If


Return 0
end function

public function integer uf_print_dn_riverbed ();//BCR 08-NOV-2011

//Print the Riverbed Delivery Note
Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llFind, llLIneItem
String	lsWarehouse,  lsSKU, lsSupplier, lsAltSku, lsDONO, lsDesc, lsInvType, lsPONO, lsPlant, lsSerial
String	lsFind,lsUF7, lsUF8, lsUF9, lsUOM, lsPhilipsInvType, lsType
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText
DataStore	ldsNotes, ldsSoldToAddress, ldsserial, ldsReport
Int	liRowsPerPAge, liEmptyRows, liMod,  liNotePos, llCount
Decimal {4} ldGrossWeight, ldNetWeight, ldNetVolume, ldGrossVolume
String lsUserField4, lsUserField5, lsUserField6, lsUserField7
String	  lsWHCode, lsaddr1, lsaddr2, lsaddr3, lsaddr4, lsCity, lsState, lsZip, lsCountry
String lsPrinter, lsWH_name, lsStandardofMeasure, lsUnitofMeasure


//Pack list must be generated
If w_do.idw_pack.RowCount() = 0 Then
	Messagebox(w_do.is_Title,'You must generate the Pack List before you can print the Delivery Note!')
	Return -1
End If
	
ldsReport = Create Datastore

ldsReport.dataobject = 'd_riverbed_delivery_note_prt'


SetPointer(Hourglass!)


lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')
	
//Ship from address from Warehouse Table
Select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
Into	 :lsWH_name, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
From warehouse
Where WH_Code = :lsWarehouse
Using Sqlca;

//Main Processing Loop	
lLRowCount = w_do.idw_Pick.RowCount()
For llRowPOs = 1 to llRowCount

	lsSKU = w_do.idw_Pick.GetITemString(llRowPos,'sku')
	lsSupplier = w_do.idw_Pick.GetITemString(llRowPos,'supp_Code')
	lsInvType = w_do.idw_Pick.GetITemString(llRowPos,'inventory_Type')
	llLineItem = w_do.idw_Pick.GetITemNumber(llRowPos,'Line_Item_No')
			
	//Insert a new report Row
	llNewRow = ldsReport.InsertRow(0)
	
	//Ship From...
	ldsReport.setitem(llNewRow,"ship_from_name",lsWH_name)
	ldsReport.setitem(llNewRow,"ship_from_address1",lsAddr1)
	ldsReport.setitem(llNewRow,"ship_from_address2",lsAddr2)
	ldsReport.setitem(llNewRow,"ship_from_address3",lsAddr3)
	ldsReport.setitem(llNewRow,"ship_from_address4",lsAddr4)
	ldsReport.setitem(llNewRow,"ship_from_state",lsState)
	ldsReport.setitem(llNewRow,"ship_from_city",lsCity)
	ldsReport.setitem(llNewRow,"ship_from_zip",lsZip)
	ldsReport.setitem(llNewRow,"ship_from_country",lsCountry)
	
	//Ship To
	ldsReport.SetITem(llNewRow,'cust_Name',w_do.idw_Main.GetITemString(1,'cust_Name'))
	ldsReport.SetITem(llNewRow,'delivery_address1',w_do.idw_Main.GetITemString(1,'address_1'))
	ldsReport.SetITem(llNewRow,'delivery_address2',w_do.idw_Main.GetITemString(1,'address_2'))
	ldsReport.SetITem(llNewRow,'delivery_address3',w_do.idw_Main.GetITemString(1,'address_3'))
	ldsReport.SetITem(llNewRow,'delivery_address4',w_do.idw_Main.GetITemString(1,'address_4'))
	ldsReport.SetITem(llNewRow,'city',w_do.idw_Main.GetITemString(1,'city'))
	ldsReport.SetITem(llNewRow,'delivery_state',w_do.idw_Main.GetITemString(1,'state'))
	ldsReport.SetITem(llNewRow,'delivery_zip',w_do.idw_Main.GetITemString(1,'zip'))
	ldsReport.SetITem(llNewRow,'country',w_do.idw_Main.GetITemString(1,'country'))
	
	//Other Header Info...	
	ldsReport.SetITem(llNewRow,'order_number', w_do.idw_Main.GetITemString(1,'invoice_no'))
	ldsReport.SetITem(llNewRow,'do_no', w_do.idw_Main.GetITemString(1,'do_no'))
	ldsReport.SetITem(llNewRow,'cust_code',w_do.idw_Main.GetITemString(1,'cust_code'))
	ldsReport.SetITem(llNewRow,'carrier', w_do.idw_Main.GetITemString(1,'carrier'))
	ldsReport.SetITem(llNewRow,'order_date',w_do.idw_Main.GetITemDateTime(1,'ord_date'))
	ldsReport.SetITem(llNewRow,'cust_order_no',w_do.idw_Main.GetItemString(1,'cust_order_no'))
	ldsReport.SetITem(llNewRow,'end_cust_order_no',w_do.idw_Main.GetItemString(1,'cust_order_no'))

	//Item MAster values
	ldNetWEight = 0
	
	Select alternate_Sku, description, user_field7, user_field8, user_field9, UOM_1, weight_1
	Into	 :lsAltSku,:lsDesc, :lsUF7, :lsUF8, :lsUF9, :lsUOM, :ldNetWEight
	From Item_Master
	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
		
	if sqlca.sqlcode <> 0 then
		MessageBox ("DB Error", SQLCA.SQLErrText )
	end if
	
	ldsReport.SetITem(llNewRow,'sku',lsSKU)
	ldsReport.SetITem(llNewRow,'description',lsDesc)	
	ldsReport.SetITem(llNewRow,'uom',lsUOM)	

	If isnull(ldNetWeight)Then ldNetWeight = 0
	ldsReport.SetITem(llNewRow,'net_weight',ldNetWEight)
	
	ldsReport.SetITem(llNewRow,'line_item_no',llLineItem)
	ldsReport.SetITem(llNewRow,'qty_shipped',w_do.idw_Pick.GetITemNUmber(llRowPos,'quantity'))
	ldsReport.SetITem(llNewRow,'serial_no',w_do.idw_Pick.GetITemString(llRowPos,'serial_no'))
	
	//Shipping Instructions
	ldsReport.SetITem(llNewRow,'Shipping_Instructions',w_do.idw_main.getitemstring(1,"Shipping_Instructions"))
	
	//Freight Terms
	ldsReport.SetITem(llNewRow,'freight_terms',w_do.idw_main.getitemstring(1,"freight_terms"))
	
	//AWB
	ldsReport.SetITem(llNewRow,'awb_bol_no',w_do.idw_other.getitemstring(1,"awb_bol_no"))
	
Next /*Picking Row */

//Total No of Cartons
lLRowCount = w_do.idw_pack.RowCount()

ldsReport.Modify("number_of_cartons_value_t.text='" + w_do.idw_pack.GetItemString(lLRowCount,'carton_No') + "'")

//Calculate Gross Weight
ldGrossWEight = 0

lLRowCount = ldsReport.RowCount()
For llRowPos = 1 to lLRowCount
	
	ldGrossWeight += ldsReport.GetItemDecimal(llRowPos,'net_weight') * ldsReport.GetItemDecimal(lLRowPos,'qty_shipped')
	
Next

lsStandardofMeasure = w_do.idw_Pack.GetITemString(1,"standard_of_measure")
IF lsStandardofMeasure = 'E' THEN
	lsUnitofMeasure = 'LB'
ELSE
	lsUnitofMeasure = 'KG'
END IF

ldsReport.Modify("gross_weight_value_t.text='" + String(ldGrossWeight,"#########.0000 ") + lsUnitofMeasure + "'")

// check print count before printing and prompt if already printed
lsDONO = w_do.idw_Main.GetITemString(1,'do_no')

Select Delivery_Note_Print_Count, User_Field4, User_Field5, User_Field6, User_Field7 
Into :llCount, :lsUserField4, :lsUserField5, :lsUserField6, :lsUserField7
From Delivery_MAster
Where do_no = :lsDONO;

if sqlca.sqlcode <> 0 then
	MessageBox ("DB Error", SQLCA.SQLErrText )
end if
	
If isnull(llCount) Then llCount = 0
	
If llCount > 0 Then
	If Messagebox("Print DELIVERY Note","This DELIVERY Note has already been printed. Do you want to continue?",Stopsign!,yesNo!,2) = 2 Then
		Return 0
	End If
End If

//Set Bill Duty and Bill Freight values...
ldsReport.Modify("user_field4_t.text='" + lsUserField4 + "'")
ldsReport.Modify("user_field5_t.text='" + lsUserField5 + "'")
ldsReport.Modify("user_field6_t.text='" + lsUserField6 + "'")
ldsReport.Modify("user_field7_t.text='" + lsUserField7 + "'")

ldsReport.SetSort("line_item_number A")
ldsReport.Sort()

//Print

OpenWithParm(w_dw_print_options,ldsReport) 

//If printed successfully, update Print count on Delivery_Master
If message.doubleparm = 1 then
		
	llCount ++
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Delivery_Master
	Set Delivery_Note_Print_Count = :llCount
	Where do_no = :lsDONO;
		
	Execute Immediate "COMMIT" using SQLCA;
	
End If

SetPointer(arrow!)

Return 0
end function

public function integer uf_print_dn_nike ();
// 12/11 - PCONKL - Plageurized from Nike EWMS

Long    i, j, ll_row, ll_cnt, ll_size_cnt, ll_item
Long	  ll_pqty, ll_qty, ll_tot_qty, ll_lstpr,ll_cnt2
Integer l_ret, ll_del
String  ls_sku, ls_size, ls_style, ls_prev_style, ls_po
String  ls_cust_code, ls_cust_name, ls_cust_add, ls_contact, ls_tel,ls_deladd, lsSuppCode, lsOrderNbr
String  ls_descript, ls_ppl, ls_prev_ppl
String ls_dono, ls_cust_add1, ls_cust_add2,ls_cust_add3,ls_HoldFlag
Long    ll_find,ll_prow, m, ll_stylecnt, ll_stylecnt1, ll_page
Datastore lds_ppl_detail, ldsDN
Long ll_dn_print
String ls_dnprint,lspreppl,lsuom
Integer li_ctn_cnt  =  0
		


ldsDN = Create DataStore
ldsDN.Dataobject = 'd_nike_delivery_note'

If w_do.idw_pack.RowCount() <= 0 Then
	MessageBox("Delivery Note", "No items in packing list! Nothing to print.")
	Return 0
End If

//picking list Qty vs pack list qty check

//If dw_pack_list.RowCount() > 0 Then
//	If w_do.idw_Detail.GetItemNumber(1, "total_alloc") <> dw_pack_list.GetItemNumber(1, "total_qty") Then
//		MessageBox("Delivery Note","Packing list quantity do not match picked quantity!",StopSign!)
//		Return -1
//	End If	
//End If


//New security - mathi

If w_do.idw_Main.GetItemString(1,"ord_status") <> "C"  Then
 MessageBox("Delivery Note", "Delivery Note can only be printed after the order is CONFIRMED!")
 Return 0
End If

// Access Rights
ll_dn_print = 0
ls_dono = w_do.idw_Main.GetItemString(1,"do_no")
Select Delivery_Note_Print_Count Into :ll_dn_print From delivery_master Where do_no = :ls_dono;
If IsNull(ll_dn_print) Then ll_dn_print = 0
//If ll_dn_print > 0 Then
// MEA - 4/12 - Removed per Yati.	
//	If gs_role = "2" Then
//		MessageBox("Delivery Note", "Only an Admin or Super can re-print the Delivery Note",StopSign!)
//		Return 0
//	End If
//End If

SetPointer(HourGlass!)

If w_do.idw_Detail.AcceptText() = -1 Then Return 0

ldsDN.Reset()

//w_do.Trigger Event ue_refresh()

If ll_dn_print <= 0 Then
	ls_dnprint = ""
Else
	ls_dnprint = "(Re-print #" + trim(string(ll_dn_print)) + ")"
End If

ls_cust_code = w_do.idw_Main.GetItemString(1, "Cust_Code") 
ls_cust_name =	w_do.idw_Main.GetItemString(1, "Cust_name")
//ls_deladd    = Trim(w_do.idw_Main.GetItemString(1, "name_or_address"))
ls_cust_add  = Trim(w_do.idw_Main.GetItemString(1, "address_1"))
ls_cust_add1 = Trim(w_do.idw_Main.GetItemString(1, "address_2"))
ls_cust_add2 = Trim(w_do.idw_Main.GetItemString(1, "address_3"))
ls_cust_add3 = Trim(w_do.idw_Main.GetItemString(1, "city")) + " " +Trim(w_do.idw_Main.GetItemString(1, "zip"))

ls_dono = w_do.idw_Main.GetItemString(1,"do_no")
lsOrderNbr = w_do.idw_Main.GetItemString(1,"Invoice_no")

If IsNull(ls_cust_code) Then ls_cust_code = ""
If IsNull(ls_cust_name) Then ls_cust_name = ""

ll_page = 1
ls_ppl = ""


ll_cnt2 = w_do.idw_Detail.Rowcount()
ldsDN.SetSort("style a")

ls_prev_style = "XXXXXXXXX"
lspreppl = "XXXXXXXXX"
ll_item = 1	

For i = 1 to ll_cnt2		
	
	ls_sku  =w_do.idw_Detail.GetItemString(i,"sku")
	lsSuppCode  =w_do.idw_Detail.GetItemString(i,"Supp_code")
	ls_ppl = w_do.idw_Detail.GetITemString(i,"User_Field1")
	ls_style = Left(ls_sku, 10)
	ls_size  = Trim(Mid(ls_sku, 12, 5))
	ll_qty   = w_do.idw_Detail.GetItemNumber(i,"alloc_qty")
	
	If ll_qty = 0 Then Continue						
			
	If ls_style <> ls_prev_style or ls_ppl <> lspreppl or ll_size_cnt = 10 Then				
				
		If ls_style <> ls_prev_style and ll_tot_qty > 0 Then			
					
			ldsDN.SetItem(ll_row,"total_qty",ll_tot_qty)
			ll_tot_qty = 0
					
		End If
				
		ll_row = ldsDN.InsertRow(0)
				
		Select description,uom_2 
		Into :ls_descript, :lsuom
		From item_master 
		Where Project_id = :gs_project and sku = :ls_sku and supp_Code = :lsSuppCode;
					
		ldsDN.SetItem(ll_row, "dn_print", ls_dnprint)
		ldsDN.SetItem(ll_row,"descript",ls_descript)
		ldsDN.SetItem(ll_row,"style", ls_style)
		ldsDN.SetItem(ll_row,"po_no",lsuom)
		ldsDN.SetItem(ll_row,"cust_name",ls_cust_code + " " + ls_cust_name)
		ldsDN.SetItem(ll_row,"cust_address1", ls_cust_add)
		ldsDN.SetItem(ll_row,"cust_address2", ls_cust_add1)
		ldsDN.SetItem(ll_row,"cust_address3", ls_cust_add2)
		ldsDN.SetItem(ll_row,"cust_address4", ls_cust_add3)
		ldsDN.SetItem(ll_row,"do_no", lsOrderNbr) /*This is really the order nbr, not the do_no*/
		ldsDN.SetItem(ll_row,"ppl_no", ls_ppl)
		
		// MEA - 4/12 - Pull Carton Count from Pack Tab instead of dw_main

		if w_do.idw_Pack.RowCount() > 0 then
			li_ctn_cnt = w_do.idw_Pack.Object.c_carton_Count[1]
		end if
		
		ldsDN.SetItem(ll_row, "ctn_cnt", li_ctn_cnt)
		ldsDN.SetItem(ll_row,"date", Date(w_do.idw_Main.GetItemDateTime(1,"schedule_date")))
		ldsDN.SetItem(ll_row,"complete_date", w_do.idw_Main.GetItemDateTime(1,"complete_date"))
		ldsDN.SetItem(ll_row,"Remark",Trim(w_do.idw_Main.GetItemString(1,"remark")))
		ll_size_cnt = 0		
					
	End If
			
	ll_size_cnt += 1
	ll_tot_qty += ll_qty
	ldsDN.SetItem(ll_row, 13 + ll_size_cnt, ls_size)
	ldsDN.SetItem(ll_row, 23 + ll_size_cnt, ll_qty)		
	lspreppl = ls_ppl
	ls_prev_style = ls_style		
		
	Next	

	ldsDN.SetItem(ll_row,"total_qty",ll_tot_qty)				 

ldsDN.Sort()
ls_prev_style = "XXXXXXXXX"
ls_prev_ppl = "XXXXXX"
ll_item = 0

For j = 1 to ldsDN.RowCount()	
	
	ls_style = ldsDN.GetItemString(j,"style")
	ls_ppl = ldsDN.GetItemString(j,"ppl_no")
	
	If ls_prev_style <> ls_style or ls_prev_ppl <> ls_ppl Then
		ll_item += 1
	End If
	
	ldsDN.SetItem(j, "itemno", ll_item)
	ldsDN.SetItem(j, "grppage", Ceiling(j / 8))
	ls_prev_style = ls_style		
	ls_prev_ppl = ls_ppl		
	
Next

ldsDN.GroupCalc()

//w_do.Trigger Event ue_refresh()

OpenWithParm(w_dw_print_options,ldsDN) 

If message.doubleparm = 1 Then
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Delivery_master
	Set Delivery_Note_Print_Count = ( :ll_dn_print + 1 ) where Do_no = :ls_dono;
	
	Execute Immediate "COMMIT" using SQLCA;
	
//	If w_do.idw_Main.GetItemString(1,"ord_status") <> "N" and &
//		w_do.idw_Main.GetItemString(1,"ord_status") <> "D" and &
//		w_do.idw_Main.GetItemString(1,"ord_status") <> "C" Then
//		w_do.idw_Main.SetItem(1,"ord_status","D")
//		record_changed = True
//		w_do.trigger event ue_save()
//	End If
	
End If

//Print the Packing List if set to print (UF6 = 'Y'
if w_do.idw_Main.GetitemString(1,'User_Field6') = 'Y' then
	w_do.icb_pack_Print.TriggerEvent('clicked')
end if

Return 0
end function

public function integer uf_print_dn_dana_th ();
//Print the Philips Delivery Note
Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llFind, llLIneItem
String	lsWarehouse,  lsSKU, lsSupplier, lsAltSku, lsDONO, lsDesc, lsInvType, lsPONO, lsPlant, lsSerial
String	lsFind,lsUF7, lsUF8, lsUF9, lsUOM, lsPhilipsInvType
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText
DataStore	ldsNotes, ldsSoldToAddress, ldsserial, ldsReport, ldsPickingDetail
Int	liRowsPerPAge, liEmptyRows, liMod,  liNotePos
Decimal {4} ldGrossWeight, ldNetWeight, ldNetVolume, ldGrossVolume
Date ldtReceiveDate


//Pack list must be generated
If w_do.idw_pack.RowCount() = 0 Then
	Messagebox(w_do.is_Title,'You must generate the Pack List before you can print the Delivery Note!')
	Return -1
End If
	
ldsReport = Create Datastore

ldsReport.dataobject = 'd_dana-th_delivery_note'

liRowsPerPage =  8

SetPointer(Hourglass!)


lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')
lsPlant = w_do.idw_Main.GetITemString(1,'User_Field3')


ldsSoldToAddress = Create DataStore
ldsSoldToAddress.dataObject = 'd_do_address_alt'
ldsSoldToAddress.SetTransObject(sqlca)
	
ldsSoldToAddress.Retrieve(lsdono, 'BT') /*Sold To Address*/

ldsPickingDetail = Create DataStore
ldsPickingDetail.dataObject = 'd_data-th-picking_detail_dn'
ldsPickingDetail.SetTransObject(sqlca)
	
ldsPickingDetail.Retrieve(lsdono) /*Sold To Address*/




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
	


llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

ldsReport.reset()
//ldsReport.SetRedraw(False)

lLRowCount = ldsPickingDetail.RowCount()
For llRowPOs = 1 to llRowCount

	lsSKU = ldsPickingDetail.GetITemString(llRowPos,'sku')
	lsSupplier = ldsPickingDetail.GetITemString(llRowPos,'supp_Code')
	lsInvType = ldsPickingDetail.GetITemString(llRowPos,'inventory_Type')
	llLineItem = ldsPickingDetail.GetITemNumber(llRowPos,'Line_Item_No')

	ldtReceiveDate = date(ldsPickingDetail.GetITemDateTime(llRowPos,'receive_date'))
	
	If ldsPickingDetail.GetITemNumber(lLRowPOs,'quantity') = 0 Then Continue
	
	//Roll Up To To Line/SKU/Inventory Type
	LsFind = "po_line = " + String(llLineItem) + " and SKU = '" + lsSKU + "' and Inventory_Type = '" + lsInvType + "' and string(receive_date) = '"+string(ldtReceiveDate) +"'"
			
		
	llFind = ldsReport.Find(lsFind,1,ldsReport.RowCount())
	
	
	If llFind > 0 Then
		
		ldsReport.SetItem(llFind,'quantity',ldsReport.GetITemNumber(llFind,'quantity') + ldsPickingDetail.GetITemNumber(lLRowPOs,'quantity')) /*add to existing Row*/
		Continue
		
	End If
	
	
	//Insert a new report Row
	
	llNewRow = ldsReport.InsertRow(0)

//	//Header Notes (up to 4 rows)
//	liNotePos = 0
//	llFind = ldsNotes.Find("Line_Item_No = 0",1,ldsNotes.RowCount()) /* line_item = 0 for header Notes*/
//	Do While llFind > 0
//		
//		liNotePos ++
		lsNotePos = "header_remarks" + String("1") //String(liNotePos)

		ldsReport.setitem(llNewRow,lsNotePos, w_do.idw_other.GetITemString(1,"remark"))
		
//		llFind ++
//		If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
//			llFind = 0
//		Else
//			llFind = ldsNotes.Find("Line_Item_No = 0",llFind,ldsNotes.RowCount())
//		End If
//		
//	Loop
	
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
	
	ldsReport.SetItem(llNewRow,"Line_Remarks",lsNoteText)
	
	
	//Ship From Info Box
	If llwarehouseRow > 0 Then /*warehouse row exists*/
	

		ldsReport.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
		
		
		ldsReport.setitem(llNewRow,"ship_from_addr1",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
		ldsReport.setitem(llNewRow,"ship_from_addr2",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
		ldsReport.setitem(llNewRow,"ship_from_addr3",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
		ldsReport.setitem(llNewRow,"ship_from_addr4",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
		ldsReport.setitem(llNewRow,"ship_from_city",g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
		ldsReport.setitem(llNewRow,"ship_from_state",g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
		ldsReport.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
		ldsReport.setitem(llNewRow,"ship_from_zip",g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
	 	
	End If
	
	ldsReport.SetITem(llNewRow,'do_number', w_do.idw_Main.GetITemString(1,'invoice_no'))
	ldsReport.SetITem(llNewRow,'route', w_do.idw_Main.GetITemString(1,'USer_Field2'))
	
//	//DO_TYpe
//	If lsPlant = "MY10" Then /*No DO Type for Malaysia */
//	Else
//		If Upper(w_do.idw_Main.GetITemString(1,'country')) <> 'SG' and w_do.idw_Main.GetITemString(1,'country') <> 'SINGAPORE' Then
//			ldsReport.SetITem(llNewRow,'DO_TYPE','Export')
//		Elseif Upper(w_do.idw_Main.GetITemString(1,'USer_Field2')) = 'SG9999' Then
//			ldsReport.SetITem(llNewRow,'DO_TYPE','Self Collection')
//		Elseif Upper(w_do.idw_Main.GetITemString(1,'USer_Field2')) = 'SGM9' Then /* 09/09 - PCONKL */
//			ldsReport.SetITem(llNewRow,'DO_TYPE','STO')
//		Else
//			ldsReport.SetITem(llNewRow,'DO_TYPE','Normal Delivery')
//		End If
//	End If
	
	//DO REceipt and DElivery Date
	ldsReport.SetITem(llNewRow,'DO_receipt_dateTime',w_do.idw_Main.GetITemDateTime(1,'ord_date'))
	ldsReport.SetITem(llNewRow,'delivery_date',w_do.idw_Main.GetITemDateTime(1,'request_Date'))
	
	ldsReport.SetITem(llNewRow,'sales_order_nbr',w_do.idw_Main.GetItemString(1,'cust_order_no'))

		
	//Ship To
	ldsReport.SetITem(llNewRow,'ship_to_code',w_do.idw_Main.GetITemString(1,'cust_code'))
	ldsReport.SetITem(llNewRow,'ship_to_name',w_do.idw_Main.GetITemString(1,'cust_Name'))
	ldsReport.SetITem(llNewRow,'ship_to_addr1',w_do.idw_Main.GetITemString(1,'address_1'))
	ldsReport.SetITem(llNewRow,'ship_to_addr2',w_do.idw_Main.GetITemString(1,'address_2'))
	ldsReport.SetITem(llNewRow,'ship_to_addr3',w_do.idw_Main.GetITemString(1,'address_3'))
	ldsReport.SetITem(llNewRow,'ship_to_addr4',w_do.idw_Main.GetITemString(1,'address_4'))
	ldsReport.SetITem(llNewRow,'ship_to_addr5',w_do.idw_Main.GetITemString(1,'user_field16'))	
	ldsReport.SetITem(llNewRow,'ship_to_city',w_do.idw_Main.GetITemString(1,'city'))
	ldsReport.SetITem(llNewRow,'ship_to_state',w_do.idw_Main.GetITemString(1,'state'))
	ldsReport.SetITem(llNewRow,'ship_to_zip',w_do.idw_Main.GetITemString(1,'zip'))
	ldsReport.SetITem(llNewRow,'ship_to_country',w_do.idw_Main.GetITemString(1,'country'))
	ldsReport.SetITem(llNewRow,'ship_to_contact',w_do.idw_Main.GetITemString(1,'contact_person'))
	ldsReport.SetITem(llNewRow,'ship_to_tel',w_do.idw_Main.GetITemString(1,'tel'))
	ldsReport.SetITem(llNewRow,'ship_to_district',w_do.idw_Main.GetITemString(1,'district'))

	
	//Sold To Address
	If ldsSoldToAddress.RowCount() > 0 Then
	
		ldsReport.SetITem(llNewRow,'sold_to_name',ldsSoldToAddress.GetITemString(1,'name'))
		ldsReport.setitem(llNewRow,"sold_to_addr1",ldsSoldToAddress.GetITemString(1,'address_1'))
		ldsReport.setitem(llNewRow,"sold_to_addr2",ldsSoldToAddress.GetITemString(1,'address_2'))
		ldsReport.setitem(llNewRow,"sold_to_addr3",ldsSoldToAddress.GetITemString(1,'address_3'))
		ldsReport.setitem(llNewRow,"sold_to_addr4",ldsSoldToAddress.GetITemString(1,'address_4'))
		ldsReport.setitem(llNewRow,"sold_to_district",ldsSoldToAddress.GetITemString(1,'district'))
		ldsReport.setitem(llNewRow,"sold_to_city",ldsSoldToAddress.GetITemString(1,'city'))
		ldsReport.setitem(llNewRow,"sold_to_state",ldsSoldToAddress.GetITemString(1,'state'))
		ldsReport.setitem(llNewRow,"sold_to_zip",ldsSoldToAddress.GetITemString(1,'zip'))
		ldsReport.setitem(llNewRow,"sold_to_country",ldsSoldToAddress.GetITemString(1,'country'))
			
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
	
	ldsReport.SetITem(llNewRow,'sku',lsSKU)
	ldsReport.SetITem(llNewRow,'description',lsDesc)	
	ldsReport.SetITem(llNewRow,'uom',lsUOM)	
	ldsReport.SetITem(llNewRow,'alt_Sku',lsAltSku)
	ldsReport.SetITem(llNewRow,'twelve_nc',lsUF7)
	ldsReport.SetITem(llNewRow,'conversion_Factor',lsUF9)
	
	ldsReport.SetITem(llNewRow,'receive_date',ldtReceiveDate)		
	
	
	ldsReport.SetITem(llNewRow,'product_no_id',lsUF7)	
	
	If isnull(ldNetWeight)Then ldNetWeight = 0
	ldsReport.SetITem(llNewRow,'net_weight',ldNetWEight)
	
	//Volume
	If isnumber(lsUF8) Then
		ldsReport.SetITem(llNewRow,'net_volume',Dec(lsUF8))
	Else
		ldsReport.SetITem(llNewRow,'net_volume',0)
	End If
	
	ldsReport.SetITem(llNewRow,'po_line',llLineItem)
	
	/* Aug282012 Arun : Below values come from picklist whereas other value comes from diffrent datawindow which causing diffrent quantity, Getting Values from the dw to sync with other values
	ldsReport.SetITem(llNewRow,'quantity',w_do.idw_Pick.GetITemNUmber(llRowPos,'quantity'))
	ldsReport.SetITem(llNewRow,'po_nbr',w_do.idw_Pick.GetITemString(llRowPos,'po_no'))
	ldsReport.SetITem(llNewRow,'inventory_desc',w_do.idw_Pick.GetITemString(llRowPos,'inventory_type'))
	ldsReport.SetITem(llNewRow,'inventory_type',w_do.idw_Pick.GetITemString(llRowPos,'inventory_type'))
	*/
	
	ldsReport.SetITem(llNewRow,'quantity',ldsPickingDetail.GetITemNUmber(llRowPos,'quantity'))
	ldsReport.SetITem(llNewRow,'po_nbr',ldsPickingDetail.GetITemString(llRowPos,'po_no'))
	ldsReport.SetITem(llNewRow,'inventory_desc',ldsPickingDetail.GetITemString(llRowPos,'inventory_type'))
	ldsReport.SetITem(llNewRow,'inventory_type',ldsPickingDetail.GetITemString(llRowPos,'inventory_type'))

	// Aug282012 Arun : Below values come from picklist whereas other value comes from diffrent datawindow which causing diffrent quantity, Getting Values from the dw to sync with other values
	
	ldsReport.SetITem(llNewRow,'plant_Code',lsPlant) /*plant code used to determine which logo to display*/

	
//	//PO NBR from Delivery Detail (UF3)
//	llFind = w_do.idw_Detail.Find("Line_Item_No = " + String(llLineItem),1,w_do.idw_Detail.RowCount())
//	If llFind > 0 Then
//		ldsReport.SetITem(llNewRow,'po_nbr',w_do.idw_Detail.GetITemString(llFind,'User_Field3')) 
//	End If
	
	
Next /*Picking Row */

//Calculate Gross Volume and Gross Weight
ldGrossWEight = 0
ldGrossVolume = 0

lLRowCount = ldsReport.RowCount()
For llRowPos = 1 to lLRowCount
	
	ldGrossWeight += ldsReport.GetItemDecimal(llRowPos,'net_weight') * ldsReport.GetItemDecimal(lLRowPos,'quantity')
	ldGrossVolume += ldsReport.GetItemDecimal(llRowPos,'net_volume') * ldsReport.GetItemDecimal(lLRowPos,'quantity')
	
Next

ldsReport.Modify("gross_Weight_t.text='" + String(ldGrossWeight,"#########.0000") + " KG'")
ldsReport.Modify("total_volume_t.text='" + String(ldGrossVolume,"#########.0000") + " CDM'")

//Show in Override DW (users need to be able to override Weight and Volume
//dw_select.SetITem(1,'total_weight',ldGrossWeight)
//dw_select.SetITem(1,'total_volume',ldGrossVolume)


//Add any necessary empty rows so sumamry is at bottom of last page
liEmptyRows = 0
If ldsReport.RowCount() < liRowsPerPage Then
	liEmptyRows = liRowsPerPage - ldsReport.RowCount()
ElseIf ldsReport.RowCount() > liRowsPerPage Then
	liMod = Mod(ldsReport.RowCount(), liRowsPerPage)
	If liMod > 0 Then
		liEmptyRows = liRowsPerPage - liMod
	End IF
End If

If liEmptyRows > 0 Then
	For llRowPos = 1 to liEmptyRows
//		ldsReport.InsertRow(0)
	Next
End If

ldsReport.SetSort("po_line A")
ldsReport.Sort()

//Print

String	 lsType
Int		llCount

// check print count before printing and prompt if already printed
lsDONO = w_do.idw_Main.GetITemString(1,'do_no')

Select Delivery_Note_Print_Count into :llCount
From Delivery_MAster
Where do_no = :lsDONO;
	
If isnull(llCount) Then llCount = 0
	
If llCount > 0 Then
	If Messagebox("Print DELIVERY Note","This DELIVERY Note has already been printed. Do you want to continue?",Stopsign!,yesNo!,2) = 2 Then
		Return 0
	End If
End If

OpenWithParm(w_dw_print_options,ldsReport) 
//If printed successfully, update Print count on Delivery_Master
If message.doubleparm = 1 then
		
	llCount ++
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Delivery_Master
	Set Delivery_Note_Print_Count = :llCount
	Where do_no = :lsDONO;
		
	Execute Immediate "COMMIT" using SQLCA;
	
End If

SetPointer(arrow!)







Return 0
end function

public function string getphilipsinvtype (string asinvtype);
//Convert the Menlo Onventory Type into the Phillips code
//25-APR-2019 :Madhu DE10196 Added PHILIPSCLS Inventory Types

String	lsPhilipsInvType

Choose case upper(gs_project)
		
	Case 'TPV'
		
		Choose case upper(asInvType)
		
			Case 'B'
				lsPhilipsInvType = '3BST'
			Case 'C'
				lsPhilipsInvType = '3CST'
			Case 'D'
				lsPhilipsInvType = '3DAM'
			Case 'K'
				lsPhilipsInvType = '3BLC'
			Case 'L'
				lsPhilipsInvType = '3REB'
			Case 'N'
				lsPhilipsInvType = '7WHS'
			Case 'R'
				lsPhilipsInvType = '3REW'
			Case 'S'
				lsPhilipsInvType = '3SCR'
				
			//Case 'G'
				//lsPhilipsInvType = 'BWHS'
			//Case 'J'
			//	lsPhilipsInvType = 'BOPN'
			//Case 'F'
			//	lsPhilipsInvType = 'BBLK'
			//Case 'E'
			//	lsPhilipsInvType = 'BDAM'
			
			Case Else
				lsPhilipsInvType = asInvType
		End Choose

	CASE 'FUNAI', 'GIBSON' /* TAM - 2015/03 - Added Gibson */
		
		Choose case upper(asInvType)
		
		Case 'B'
			lsPhilipsInvType = 'B'
		Case 'C'
			lsPhilipsInvType = 'C'
		Case 'D' 
			lsPhilipsInvType = 'DAM'
		Case  'K'
			lsPhilipsInvType = 'BLCK'
		Case  'L' 
			lsPhilipsInvType = 'REBL'
		Case 'N'
			lsPhilipsInvType = 'WHS'
		Case 'R' 
			lsPhilipsInvType = 'REW'
		Case 'S'
			lsPhilipsInvType = 'SCRP'		
		
		Case Else
				lsPhilipsInvType = asInvType
		End Choose		
		
//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
CASE 'PHILIPSCLS', 'PHILIPS-DA'
	Choose case upper(asInvType)
			
	Case 'B'
		lsPhilipsInvType = 'B'
	Case 'C'
		lsPhilipsInvType = 'C'
	Case 'D'
		lsPhilipsInvType = 'DAM'
	Case 'K'
		lsPhilipsInvType = 'BLCK'
	Case 'L'
		lsPhilipsInvType = 'RETC'
	Case 'N'
		lsPhilipsInvType = 'MAIN'
	Case 'R'
		lsPhilipsInvType = 'VAS'
	Case 'S'
		lsPhilipsInvType = 'SCRP'
	Case 'G'
		lsPhilipsInvType = 'BWHS'
	Case 'J'
		lsPhilipsInvType = 'BOPN'
	Case 'F'
		lsPhilipsInvType = 'BBLK'
	Case 'E'
		lsPhilipsInvType = 'BDAM'
	Case Else
		lsPhilipsInvType = asInvType
	END CHOOSE

Case Else /*Philips-SG */
	
	Choose case upper(asInvType)
			
		Case 'B'
			lsPhilipsInvType = 'B'
		Case 'C'
			lsPhilipsInvType = 'C'
		Case 'D'
			lsPhilipsInvType = 'DAM'
		Case 'K'
			lsPhilipsInvType = 'BLCK'
		Case 'L'
			lsPhilipsInvType = 'REBL'
		Case 'N'
			lsPhilipsInvType = 'WHS'
		Case 'R'
			lsPhilipsInvType = 'REW'
		Case 'S'
			lsPhilipsInvType = 'SCRP'
		Case 'G'
			lsPhilipsInvType = 'BWHS'
		Case 'J'		
			lsPhilipsInvType = 'BOPN'			
		Case 'F'	
			lsPhilipsInvType = 'BBLK'			
		Case 'E'	
			lsPhilipsInvType = 'BDAM'
		Case Else
			lsPhilipsInvType = asInvType
		End Choose
		
End Choose

Return lsPhilipsInvType


end function

public function integer uf_print_dn_starbucks_th ();
//Print the Starbucks-TH DN

DataStore	ldsREport
String	lsDONO, lsDONOSave
long	llDetailCount, llDetailPos
Boolean	lbPrinterSelected

ldsReport = Create Datastore
ldsReport.dataobject = 'd_starbucks_th_delivery_note'
ldsREport.SetTransObject(SQLCA)
	
SetPointer(Hourglass!)

// Can Print either from Delivery ORder or Batch Pick

If isvalid (W_DO) Then /* Delivery ORder*/
	
	//Pick list must be generated
	If w_do.idw_pick.RowCount() = 0 Then
		Messagebox(w_do.is_Title,'You must generate the Pick List before you can print the Delivery Note!')
		Return -1
	End If

	lsDONO = w_do.idw_Main.GetITEmSTring(1,'do_no')

	ldsREport.Retrieve(lsDONO)

	If ldsREport.RowCOunt() > 0 Then
		OpenWithParm(w_dw_print_options,ldsReport) 
	Else
		MessageBox(w_do.is_title, 'There are no records to print for the Delivery Note')
	End If
	
	
Else /* Batch Picking */
	
	//Pick list must be generated
	If w_batch_pick.idw_pick.RowCount() = 0 Then
		Messagebox(w_do.is_Title,'You must generate the Pick List before you can print the Delivery Note!')
		Return -1
	End If
		
	//Make sure we're sorted by DO_NO so we only print one per order
	w_batch_pick.idw_Detail.SetSort("do_no a, line_item_No a")
	w_batch_pick.idw_Detail.Sort()
	
	//Loop Through each unique order and Print
	llDetailCount = w_batch_pick.idw_Detail.RowCount()
	For llDetailPos = 1 to llDetailCount
		
		lsDONO = w_batch_pick.idw_Detail.GetITEmSTring(llDetailPos,'do_no')
		
		If lsDONO <> lsDONOSave Then
						
			ldsREport.Retrieve(lsDONO)
		
			If ldsREport.RowCOunt() > 0 Then
				
				
				
				//For first only, show printer selection box, otherwise just print
				if not lbPrinterSelected Then
					ldsREport.object.datawindow.print.paper.size = 9
					OpenWithParm(w_dw_print_options,ldsReport) 
					lbPrinterSelected = True
				Else
					ldsReport.Print()
				End If
				
			End If /*records exist*/
		
		End If /*Order Number changed */
	
		lsDONOSave = lsDONO
	
	Next /* order detail */
	
End If /* DO or Batch Pick */

SetPointer(arrow!)

REturn 0
end function

public function integer uf_process_dn_philips (datastore idsmain, datastore idsdetail, datastore idspick, datastore idspack, boolean ibshowprintdialog);
//Print the Philips Delivery Note
Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llFind, llLIneItem
String	lsWarehouse,  lsSKU, lsSupplier, lsAltSku, lsDONO, lsDesc, lsInvType, lsPONO, lsPlant, lsSerial
String	lsFind,lsUF7, lsUF8, lsUF9, lsUOM, lsPhilipsInvType ,ls_whcode, lsFlag
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText
DataStore	ldsNotes, ldsSoldToAddress, ldsserial, ldsReport
Int	liRowsPerPAge, liEmptyRows, liMod,  liNotePos
Decimal {4} ldGrossWeight, ldNetWeight, ldNetVolume, ldGrossVolume


//Pack list must be generated
If idsPack.RowCount() = 0 Then
	Messagebox(w_do.is_Title,"Order: " + idsMain.GetITemString(1,'invoice_no') + ', You must generate the Pack List before you can print the Delivery Note!')
	Return -1
End If
	
ldsReport = Create Datastore
lsWarehouse = idsMain.GetITEmString(1,'wh_Code')
lsDoNO = idsMain.GetITEmString(1,'do_no')
lsPlant = idsMain.GetITemString(1,'User_Field3')

//Singapore and Malaysia using different versions
//If idsMain.GetITEmString(1,'wh_Code') = 'PHILIPS-MY' or idsMain.GetITEmString(1,'wh_Code') = 'TPV-MY' or idsMain.GetITEmString(1,'wh_Code') = 'FUNAI-MY'     Then /* 01/13 - PCONKL - added TPV*/ /* 6/13 - MEA - added FUNAI */ old code
If idsMain.GetITEmString(1,'wh_Code') = 'PHILIPS-MY' or idsMain.GetITEmString(1,'wh_Code') = 'FUNAI-MY'  or idsMain.GetITEmString(1,'wh_Code') = 'GIBSON-MY'    Then /* 01/13 - PCONKL - added TPV*/ /* 6/13 - MEA - added FUNAI *//* TAM - 2015/03 - Added Gibson */
	ldsReport.dataobject = 'd_philips_my_delivery_note'
	
	//2-MAR-2019 :Madhu S30230 PhilipsBlueHeart - change display text
	//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
	IF upper(gs_project) = 'PHILIPSCLS' OR upper(gs_project) = 'PHILIPS-DA' THEN ldsReport.modify( "t_14.text='Ultimate Consignee Information' ")
	
elseif idsMain.GetITEmString(1,'wh_Code') = 'TPV-MY' or idsMain.GetITEmString(1,'wh_Code') = 'TPV-SG'    Then /* new datawindow for TPV. -nxjain 2014/08/04*/
	ldsReport.dataobject = 'd_tpv_my_delivery_note'
else
	ldsReport.dataobject = 'd_philips_sg_delivery_note'
	
	//2-MAR-2019 :Madhu S30230 PhilipsBlueHeart - change display text
	//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
	IF upper(gs_project) = 'PHILIPSCLS' OR upper(gs_project) = 'PHILIPS-DA' THEN ldsReport.modify( "t_14.text='Ultimate Consignee Information' ")
	
	//GailM 9/20/2018 S23467/s23404 Implement change to wh_code and use of signify.jpg in delivery/return note
	lsFlag = f_retrieve_parm(gs_Project, 'FLAG', 'USE SIGNIFY LOGO', 'CODE_DESCRIPT')
	If lsFlag = 'Y' and lsPlant = 'SG00' Then
		ldsReport.Modify("p_signify_logo.visible=TRUE")
		ldsReport.Modify("p_signify_logo.Filename='SIGNIFY.JPG'" )
		ldsReport.Modify("p_signify_logo.x=80")
		ldsReport.Modify("t_6.x=100")
		ldsReport.Modify("ship_from_name.x=100")
		ldsReport.Modify("ship_from_addr1.x=100")
		ldsReport.Modify("ship_from_addr2.x=100")
		ldsReport.Modify("compute_1.x=100")
	Else
		ldsReport.Modify("p_signify_logo.visible=FALSE")
		ldsReport.Modify("p_1.visible=TRUE")
		ldsReport.Modify("p_2.visible=TRUE")
	End If
End IF

//2-MAR-2019 :Madhu S30230 PhilipsBlueHeart - Don't display PHILIPS Logo
//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
IF upper(gs_project) = 'PHILIPSCLS' OR upper(gs_project) = 'PHILIPS-DA' THEN
		ldsReport.Modify("p_signify_logo.visible=FALSE")
		ldsReport.Modify("p_1.visible=FALSE")
		ldsReport.Modify("p_2.visible=TRUE")
END IF


liRowsPerPage =  8

SetPointer(Hourglass!)


ldsSoldToAddress = Create DataStore
ldsSoldToAddress.dataObject = 'd_do_address_alt'
ldsSoldToAddress.SetTransObject(sqlca)
	
ldsSoldToAddress.Retrieve(lsdono, 'ST') /*Sold To Address*/


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
	
//For Malaysia Plant code (MY10) or (MYQ0), we want to print Serial Numbers -
//01-Apr-2013 :Madhu added Plant code is 2180
If lsPlant = "MY10"  OR   lsPlant = "MYQ0"  or lsPlant ="2180" Then
	
	ldsSerial = Create Datastore
	presentation_str = "style(type=grid)"

	lsSQl = " Select Delivery_serial_detail.Serial_No, Delivery_serial_detail.Quantity, "
	lsSQL += " Delivery_Picking_Detail.Line_Item_No, Delivery_Picking_Detail.SKU, Delivery_Picking_Detail.Supp_Code, Delivery_Picking_Detail.Inventory_Type "
	lsSQL += " From Delivery_Picking_Detail, Delivery_Serial_Detail "
	lsSQL += " Where Delivery_Picking_Detail.ID_NO = Delivery_Serial_Detail.ID_NO "
	lsSQL += " and Delivery_Picking_Detail.do_no = '" + lsDONO + "'"


	dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
	ldsSerial.Create( dwsyntax_str, lsErrText)
	ldsSerial.SetTransobject(sqlca)
	ldsSerial.Retrieve()
	
End If /* Malaysia */


llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

ldsReport.reset()


lLRowCount = idsPick.RowCount()
For llRowPOs = 1 to llRowCount

	lsSKU = idsPick.GetITemString(llRowPos,'sku')
	lsSupplier =idsPick.GetITemString(llRowPos,'supp_Code')
	lsInvType = idsPick.GetITemString(llRowPos,'inventory_Type')
	llLineItem = idsPick.GetITemNumber(llRowPos,'Line_Item_No')
		
	If idsPick.GetITemNumber(lLRowPOs,'quantity') = 0 Then Continue
	
	//Roll Up To To Line/SKU/Inventory Type
	LsFind = "po_line = " + String(llLineItem) + " and SKU = '" + lsSKU + "' and Inventory_Type = '" + lsInvType + "'"
		
	llFind = ldsReport.Find(lsFind,1,ldsReport.RowCount())
	If llFind > 0 Then
		
		ldsReport.SetItem(llFind,'quantity',ldsReport.GetITemNumber(llFind,'quantity') + idsPick.GetITemNumber(lLRowPOs,'quantity')) /*add to existing Row*/
		Continue
		
	End If
	
	
	//Insert a new report Row
	
	llNewRow = ldsReport.InsertRow(0)
	
	ldsReport.SetITem(llNewRow,'project_id', gs_project ) /*01/13 - PCONKL - needed to toggle logo for TPV AND FUNAI/GIBSON */
	
	if (gs_project ='TPV') then 
		ls_whcode = idsMain.GetITemString(1,'wh_code') 
		ldsReport.SetITem(llNewRow,'wh_code',ls_whcode)	
	End if 

	//Header Notes (up to 4 rows)
	liNotePos = 0
	llFind = ldsNotes.Find("Line_Item_No = 0",1,ldsNotes.RowCount()) /* line_item = 0 for header Notes*/
	Do While llFind > 0
		
		liNotePos ++
		lsNotePos = "header_remarks" + String(liNotePos)
		ldsReport.setitem(llNewRow,lsNotePos,ldsNotes.GetITemString(llFind,"note_Text"))
		
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
		lsNoteText += ldsNotes.GetITemString(llFind,"note_Text") + " "
				
		llFind ++
		If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
			llFind = 0
		Else
			llFind = ldsNotes.Find("Line_Item_No = " + string(llLineItem),llFind,ldsNotes.RowCount())
		End If
		
	Loop
	
	ldsReport.SetItem(llNewRow,"Line_Remarks",lsNoteText)
	
	
	//Ship From Info Box
	
	//Take from Supplier
	
	string lsSuppName, lsSuppAddress_1, lsSuppAddress_2, lsSuppAddress_3, lsSuppAddress_4
	string lsSuppCity, lsSuppState, lsSuppCountry, lsSuppZip
	
	Select supp_name, address_1, address_2, address_3, address_4, 
			city, state, country, zip 
	Into	 :lsSuppName,:lsSuppAddress_1, :lsSuppAddress_2, :lsSuppAddress_3, :lsSuppAddress_4,
			 :lsSuppCity, :lsSuppState, :lsSuppCountry, :lsSuppZip
	From Supplier
	Where Project_id = :gs_project and supp_code = :lsSupplier;
	
	
	
//	If llwarehouseRow > 0 Then /*warehouse row exists*/
	
		//Hard code MMD for Plant SGT5, otherwise take from Warehouse
	If lsPlant = "SGT5" Then
		lsSuppName = 'MMD SINGAPORE PTE. LTD.'
		//ldsReport.SetITem(llNewRow,'ship_from_name','MMD SINGAPORE PTE. LTD.')
	Else
		//ldsReport.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
	End If
	
	ldsReport.SetITem(llNewRow,'ship_from_name', lsSuppName )
	ldsReport.setitem(llNewRow,"ship_from_addr1", lsSuppAddress_1) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
	ldsReport.setitem(llNewRow,"ship_from_addr2", lsSuppAddress_2 ) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
	ldsReport.setitem(llNewRow,"ship_from_addr3", lsSuppAddress_3) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
	ldsReport.setitem(llNewRow,"ship_from_addr4", lsSuppAddress_4) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
	ldsReport.setitem(llNewRow,"ship_from_city", lsSuppCity)  //g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
	ldsReport.setitem(llNewRow,"ship_from_state", lsSuppState)  //g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
	ldsReport.setitem(llNewRow,"ship_from_country", lsSuppCountry ) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
	ldsReport.setitem(llNewRow,"ship_from_zip", lsSuppZip ) //g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))

	
//	End If
	
	ldsReport.SetITem(llNewRow,'do_number', idsMain.GetITemString(1,'invoice_no'))
	ldsReport.SetITem(llNewRow,'route', idsMain.GetITemString(1,'USer_Field2'))
	
	//DO_TYpe
	If lsPlant = "MY10" OR   lsPlant = "MYQ0" or lsPlant = "2180" Then /*No DO Type for Malaysia */ /* 02/13 - PCONKL - added 2180 for TPV */
	Else
		If Upper(idsMain.GetITemString(1,'country')) <> 'SG' and idsMain.GetITemString(1,'country') <> 'SINGAPORE' Then
			ldsReport.SetITem(llNewRow,'DO_TYPE','Export')
		Elseif Upper(idsMain.GetITemString(1,'USer_Field2')) = 'SG9999' Then
			ldsReport.SetITem(llNewRow,'DO_TYPE','Self Collection')
		Elseif Upper(idsMain.GetITemString(1,'USer_Field2')) = 'SGM9' Then /* 09/09 - PCONKL */
			ldsReport.SetITem(llNewRow,'DO_TYPE','STO')
		Else
			ldsReport.SetITem(llNewRow,'DO_TYPE','Normal Delivery')
		End If
	End If
	
	//DO REceipt and DElivery Date
	ldsReport.SetITem(llNewRow,'DO_receipt_dateTime',idsMain.GetITemDateTime(1,'ord_date'))
	ldsReport.SetITem(llNewRow,'delivery_date',idsMain.GetITemDateTime(1,'request_Date'))
	
	//Ship To
	ldsReport.SetITem(llNewRow,'ship_to_code',idsMain.GetITemString(1,'cust_code'))
	ldsReport.SetITem(llNewRow,'ship_to_name',idsMain.GetITemString(1,'cust_Name'))
	ldsReport.SetITem(llNewRow,'ship_to_addr1',idsMain.GetITemString(1,'address_1'))
	ldsReport.SetITem(llNewRow,'ship_to_addr2',idsMain.GetITemString(1,'address_2'))
	ldsReport.SetITem(llNewRow,'ship_to_addr3',idsMain.GetITemString(1,'address_3'))
	ldsReport.SetITem(llNewRow,'ship_to_addr4',idsMain.GetITemString(1,'address_4'))
	ldsReport.SetITem(llNewRow,'ship_to_city',idsMain.GetITemString(1,'city'))
	ldsReport.SetITem(llNewRow,'ship_to_state',idsMain.GetITemString(1,'state'))
	ldsReport.SetITem(llNewRow,'ship_to_zip',idsMain.GetITemString(1,'zip'))
	ldsReport.SetITem(llNewRow,'ship_to_country',idsMain.GetITemString(1,'country'))
	ldsReport.SetITem(llNewRow,'ship_to_contact',idsMain.GetITemString(1,'contact_person'))
	ldsReport.SetITem(llNewRow,'ship_to_tel',idsMain.GetITemString(1,'tel'))
	
	//Sold To Address
	If ldsSoldToAddress.RowCount() > 0 Then
	
		ldsReport.SetITem(llNewRow,'sold_to_name',ldsSoldToAddress.GetITemString(1,'name'))
		ldsReport.setitem(llNewRow,"sold_to_addr1",ldsSoldToAddress.GetITemString(1,'address_1'))
		ldsReport.setitem(llNewRow,"sold_to_addr2",ldsSoldToAddress.GetITemString(1,'address_2'))
		ldsReport.setitem(llNewRow,"sold_to_addr3",ldsSoldToAddress.GetITemString(1,'address_3'))
		ldsReport.setitem(llNewRow,"sold_to_addr4",ldsSoldToAddress.GetITemString(1,'address_4'))
		ldsReport.setitem(llNewRow,"sold_to_district",ldsSoldToAddress.GetITemString(1,'district'))
		ldsReport.setitem(llNewRow,"sold_to_city",ldsSoldToAddress.GetITemString(1,'city'))
		ldsReport.setitem(llNewRow,"sold_to_state",ldsSoldToAddress.GetITemString(1,'state'))
		ldsReport.setitem(llNewRow,"sold_to_zip",ldsSoldToAddress.GetITemString(1,'zip'))
		ldsReport.setitem(llNewRow,"sold_to_country",ldsSoldToAddress.GetITemString(1,'country'))
			
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
	
	ldsReport.SetITem(llNewRow,'sku',lsSKU)
	
	//MEA - 1/6/13 - Added for Barcode

	if ldsReport.dataobject = "d_philips_sg_delivery_note" OR  ldsReport.dataobject =  "d_philips_my_delivery_note"  or  ldsReport.dataobject =    "d_tpv_my_delivery_note" then //nxjain added new datawindow for TPV project  2014/08/04
		ldsReport.SetITem(llNewRow,'supp_code',lsSupplier)	
	end if
	
	
	ldsReport.SetITem(llNewRow,'description',lsDesc)	
	ldsReport.SetITem(llNewRow,'uom',lsUOM)	
	ldsReport.SetITem(llNewRow,'alt_Sku',lsAltSku)
	ldsReport.SetITem(llNewRow,'twelve_nc',lsUF7)
	ldsReport.SetITem(llNewRow,'conversion_Factor',lsUF9)
	
	If isnull(ldNetWeight)Then ldNetWeight = 0
	ldsReport.SetITem(llNewRow,'net_weight',ldNetWEight)
	
	//Volume
	If isnumber(lsUF8) Then
		ldsReport.SetITem(llNewRow,'net_volume',Dec(lsUF8))
	Else
		ldsReport.SetITem(llNewRow,'net_volume',0)
	End If
	
	ldsReport.SetITem(llNewRow,'po_line',llLineItem)
	ldsReport.SetITem(llNewRow,'quantity',idsPick.GetITemNUmber(llRowPos,'quantity'))


	lsPhilipsInvType = getPhilipsInvType(idsPick.GetITemString(llRowPos,'inventory_type'))
	
	ldsReport.SetITem(llNewRow,'inventory_desc',lsPhilipsInvType)
	ldsReport.SetITem(llNewRow,'inventory_type',idsPick.GetITemString(llRowPos,'inventory_type'))
	ldsReport.SetITem(llNewRow,'plant_Code',lsPlant) /*plant code used to determine which logo to display*/
		
	//Plant/Invoice From & Company Registration
	Choose Case Upper(idsMain.GetITemString(1,'User_Field3'))
			
		Case "SG10"

			
			if gs_project = 'FUNAI'  or gs_project = 'GIBSON'  then /*TAM 2015/03 - Added Gibson */
				ldsReport.SetITem(llNewRow,'company_registration','201309796D')
				ldsReport.SetITem(llNewRow,'plant_invoice_From','SG10 / 756058')		
			else
				ldsReport.SetITem(llNewRow,'company_registration','199705989C')
				ldsReport.SetITem(llNewRow,'plant_invoice_From','SG10 / 830144')				
			end if
		Case "SG71"
			
			if gs_project = 'FUNAI' or gs_project = 'GIBSON'  then /*TAM 2015/03 - Added Gibson */
				ldsReport.SetITem(llNewRow,'company_registration','201309796D')
				ldsReport.SetITem(llNewRow,'plant_invoice_From','SG71 / 756059')
			else
				ldsReport.SetITem(llNewRow,'company_registration','199705989C')
				ldsReport.SetITem(llNewRow,'plant_invoice_From','SG71 / 830386')
			end if
			
		Case "SG27"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG27 / 832889')
			ldsReport.SetITem(llNewRow,'company_registration','199705989C')		
		Case "SG00"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG00 / 830143')
			ldsReport.SetITem(llNewRow,'company_registration','196900610Z')
		Case "SG03"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SG03 / 832445')
			ldsReport.SetITem(llNewRow,'company_registration','196900610Z')
		Case "SGT5"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SGT5 / 834002 ')
			ldsReport.SetITem(llNewRow,'company_registration','200822460K')
		Case "MY10"
			If gs_project = 'FUNAI'  or gs_project = 'GIBSON'  then /*TAM 2015/03 - Added Gibson */
				ldsReport.SetITem(llNewRow,'company_registration','1053825-M')
				ldsReport.SetITem(llNewRow,'plant_invoice_From','MY10 / 756040')	
			Else
				ldsReport.SetITem(llNewRow,'plant_invoice_From','MY10')	
			End If
		Case "SGQ1"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','SGQ1 / 900043 ')
			ldsReport.SetITem(llNewRow,'company_registration','201114879N')
		Case "MYQ0"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','MYQ0 / 900023 ')
			ldsReport.SetITem(llNewRow,'company_registration','952853M')
	
		// 01/13 - PCONKL - added plant codes for TPV project
		Case "2190"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','2190 / 900043 ')
			ldsReport.SetITem(llNewRow,'company_registration','201114879N')
		Case "2180"
			ldsReport.SetITem(llNewRow,'plant_invoice_From','2180 / 900023 ')
			ldsReport.SetITem(llNewRow,'company_registration','952853M')
			
			
	End Choose
	
	//PO NBR from Delivery Detail (UF3)
	llFind = idsDetail.Find("Line_Item_No = " + String(llLineItem),1,idsDetail.RowCount())
	If llFind > 0 Then
		ldsReport.SetITem(llNewRow,'po_nbr',idsDetail.GetITemString(llFind,'User_Field3')) 
	End If
	
	//Add Serial Number for Malaysia 
	//01-Apr-2013 :Madhu added Plant code is 2180
	If lsPlant = "MY10" OR   lsPlant = "MYQ0"  or lsPlant ="2180" Then
		
		lsSerial = ''
		
		lsFind = "Line_ITem_no = " + String(llLineItem) + " and Upper(SKU) = '" + Upper(lsSKU) + "' and upper(Inventory_Type) = '" + Upper(lsInvType) + "'"
		llFind = ldsSerial.Find(lsFind,1,ldsSerial.RowCount())
		
		Do While llFind > 0
			
			lsSerial += ldsSerial.GetITemString(llFind,'serial_no') + ", "

			llFind ++
			If llFind > ldsSerial.RowCount() Then
				llFind = 0
			Else
				llFind = ldsSerial.Find(lsFind,llFind,ldsSerial.RowCount())
			End If
			
		Loop
		
		lsSerial = Left(lsSerial,(len(lsSerial) - 2)) /*Strip off last comma */
		ldsReport.SetITem(llNewRow,'serial_no',lsSerial)
		
	End If /*Malaysia*/
	
Next /*Picking Row */

//Calculate Gross Volume and Gross Weight
ldGrossWEight = 0
ldGrossVolume = 0

lLRowCount = ldsReport.RowCount()
For llRowPos = 1 to lLRowCount
	
	ldGrossWeight += ldsReport.GetItemDecimal(llRowPos,'net_weight') * ldsReport.GetItemDecimal(lLRowPos,'quantity')
	ldGrossVolume += ldsReport.GetItemDecimal(llRowPos,'net_volume') * ldsReport.GetItemDecimal(lLRowPos,'quantity')
	
Next

ldsReport.Modify("gross_Weight_t.text='" + String(ldGrossWeight,"#########.0000") + " KG'")
ldsReport.Modify("total_volume_t.text='" + String(ldGrossVolume,"#########.0000") + " CDM'")

//Show in Override DW (users need to be able to override Weight and Volume
//dw_select.SetITem(1,'total_weight',ldGrossWeight)
//dw_select.SetITem(1,'total_volume',ldGrossVolume)

ldsReport.SetSort("po_line A")
ldsReport.Sort()


//Print

String	 lsType
Int		llCount

// check print count before printing and prompt if already printed
lsDONO = idsMain.GetITemString(1,'do_no') 


Select Delivery_Note_Print_Count into :llCount
From Delivery_MAster
Where do_no = :lsDONO;
	
If isnull(llCount) Then llCount = 0
	
If llCount > 0 Then
	If Messagebox("Print DELIVERY Note","Order: " + idsMain.GetITemString(1,'invoice_no') + ", This DELIVERY Note has already been printed. Do you want to continue?",Stopsign!,yesNo!,2) = 2 Then
		Return 0
	End If
End If

//Only show print dialog if first/only one bieng printed, otherwise print to default
if ibShowPrintDialog Then
	OpenWithParm(w_dw_print_options,ldsReport) 
// TAM - 2018/03 - DE3538 - Need to capture the copies for subsequent prints
	iiCopies = integer(ldsReport.describe('datawindow.print.Copies'))
else
// TAM - 2018/03 - DE3538 - Need to capture the copies for subsequent prints
	ldsReport.modify(" datawindow.print.copies = " + String(iiCopies))
	Print(ldsReport)
	message.DoubleParm = 1
End If
//If printed successfully, update Print count on Delivery_Master
If message.doubleparm = 1 then
		
	llCount ++
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Delivery_Master
	Set Delivery_Note_Print_Count = :llCount
	Where do_no = :lsDONO;
		
	Execute Immediate "COMMIT" using SQLCA;
	
End If

SetPointer(arrow!)







Return 0
end function

public function integer uf_batch_print_philips_dn ();
// 08/13 - PCONKL - Loop through selecvted orders on the Delivery Order Search Results tab and print the DN for each Order
// We will retrieve datastores for Main, Detail, Pick and Pack and pass to printing routine (same as for a single order)

Long	llRowCount, llRowPos, llCheckedCount, llCheckedPos
String	lsDONO
Boolean	lbPrintPrompt
datastore ldsMain, ldsDetail, ldsPick, ldsPack

ldsMain = create datastore
ldsMain.dataobject = 'd_do_master'
ldsMain.SetTransObject(SQLCA)

ldsdetail = create datastore
ldsDetail.dataobject = 'd_do_detail'
ldsDetail.SetTransObject(SQLCA)

ldsPick = create datastore
ldsPick.dataobject = 'd_do_picking'
ldsPick.SetTransObject(SQLCA)

ldsPack = create datastore
ldsPack.dataobject = 'd_do_packing_grid'
ldsPack.SetTransObject(SQLCA)

lbPrintPrompt = True /* will only show print dialog box for first one printed*/

//show status bar
//get the max count (numer of checked orders
llCheckedCount = 0
llRowCount = w_do.idw_result.RowCount()
For llRowPos = 1 to llRowCount
	if w_do.idw_result.getITemString(llRowPos,'c_select_ind') = 'Y' Then
		llCheckedCount ++
	End If
NExt

If llCheckedCount = 0 Then return 0

open(w_update_status)
w_update_status.hpb_status.MaxPosition = llCheckedCount

llRowCount = w_do.idw_result.RowCount()
For llRowPos = 1 to llRowCount
	
	if w_do.idw_result.getITemString(llRowPos,'c_select_ind') = 'Y' Then
		
		lsDONO = w_do.idw_result.getITemString(llRowPos,'do_no') 
		
		ldsMain.retrieve(lsDONO)
		ldsDetail.retrieve(lsDONO)
		ldsPick.retrieve(lsDONO)
		ldsPack.retrieve(lsDONO)
		
		If ldsMain.rowcount() > 0 Then
			
			llCheckedPos ++
			w_update_status.hpb_status.Position = llCheckedPos
			w_update_status.st_status.text = 'Printing Delivery Note for Order: ' + ldsMain.getITemString(1,'invoice_no') + "..."
			
		Else
			Continue
		End If
		
		//TAM 2019/07/10 - DE11587 - Print Batch delivery Notes for PhilipsCLS
		//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
		If Upper(gs_project) = 'PHILIPSCLS' OR Upper(gs_project) = 'PHILIPS-DA' Then
			uf_process_dn_philipscls(ldsMain, ldsdetail, ldsPick, ldspack,lbPrintPrompt)
		Else
			uf_process_dn_philips(ldsMain, ldsdetail, ldsPick, ldspack,lbPrintPrompt)
		End if
		
		lbPrintPrompt = False /* will only show print dialog box for first one printed*/
		
	End If
	
Next

Close(w_update_status)

Return 0
end function

public function integer uf_process_batch_dn ();/*TAM - 2013/03 - Added Gibson */
//1-FEB-2019 :Madhu S28945 Added PHILIPSCLS
//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order

Choose Case Upper(gs_project)
		
	Case 'PHILIPS-SG', 'PHILIPSCLS', 'PHILIPS-DA' ,'TPV', 'FUNAI', 'GIBSON' 
		
		uf_batch_print_philips_dn()
		
	Case 'HAGER-SG'
		
		uf_batch_print_hagersg_dn()
		
End Choose

Return 0
end function

public function integer uf_print_kendo_ci ();
// 04/16 - PCONKL - Print the Kendo Commercial Invoice

DataStore	ldsREport, ldsPack
String			lsDONO, lsPrinter, lsConsolNo, lsSQLCI, lsSQLPL, lsWhere
Long			llCartonCount, llPalletCount, llPos
Dec			ldGrossWeight

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Commercial Invoice.')
	Return -1
End If

//Pack list must be generated
If w_do.idw_pack.RowCount() = 0 Then
	Messagebox(w_do.is_Title,'You must generate the Pack List before you can print the Commercial Invoice!')
	Return -1
End If
	
// in W_DO, we are retreiving by Consolidation_No to print all orders on the shipment, make sure all are in at least packing status
if w_do.idw_shipments.RowCount() > 0 Then
	
	If w_do.idw_shipments.Find("Ord_status in ('N', 'P','I','V')", 1, w_do.idw_shipments.rowcount()) > 0 Then
		MessageBox("PrintCommercial Invoice"," All orders on the shipment must be in at least packing status to print the consolidated Commercial Invoice!")
		Return 0
	End If
	
End If


	
SetPointer(Hourglass!)

ldsReport = Create Datastore
ldsReport.dataobject = 'd_kendo_commercial_invoice'
ldsREport.SetTransObject(SQLCA)
lsSQLCI = ldsREport.GetSQLSelect()

lsDONO = w_do.idw_Main.GetITEmSTring(1,'do_no')
lsConSolNo = w_do.idw_Main.GetITEmSTring(1,'Consolidation_no')

//Add Consolidation No to the Where Clause if present, otherwise DO_NO
If lsConsolNo > '' Then
	lsWhere =   " And Consolidation_No = '" + lsConsolNo + "' "
Else
	lsWhere = " And Delivery_Master.DO_NO = '" + lsdono + "' "
End If

llPos = Pos(lsSQLCI,"Group by")

lsSQLCI = Replace(lsSQLCI, (llPos - 2),1, lsWhere)

ldsReport.SetSqlSelect(lsSqlCI)
ldsREport.Retrieve()

If ldsREport.RowCOunt() > 0 Then
		
	//Retrieve the PAckList so we can copy some of the computed values
	ldsPack = Create Datastore
	ldsPack.dataobject = 'd_packing_prt_kendo_Consolidated'
	ldsPack.SetTransObject(SQLCA)
	
	//Either retrieve by Consol_No or DO_NO to match CI
	
	lsSQLPL = ldsPack.getSqlSelect()
	
	If lsConsolNo > '' Then
		lsSQLPL +=   " And Consolidation_No = '" + lsConsolNo + "'"
	Else
		lsSQLPL += " And Delivery_Master.DO_NO = '" + lsdono + "'"
	End If

	ldsPack.SetSqlSelect(lsSqlPL)
	ldsPack.Retrieve()
	
	ldsReport.Modify("total_cartons_t.text='" + String(ldsPack.Object.c_carton_Count[1]) + "'")
//TAM 2018/10/24 - DE6689 - pallet count comes from uf.9
//	ldsReport.Modify("total_pallets_t.text='" + String(ldsPack.Object.c_pallet_Count[1]) + "'")
	//ldsReport.Modify("gross_weight_t.text='" + String(ldsPack.object.c_gross_weight[1],"#######.00") + "'")
	ldsReport.Modify("gross_weight_t.text='" + ldsPack.object.c_gross_weight[1] + "'")
	
	
	//  If we have a default printer for Kendo CI, Load now
	lsPrinter = ProfileString(gs_iniFile,'PRINTERS','KENDOCI','')
	If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

	OpenWithParm(w_dw_print_options,ldsReport) 
	
	// We want to store the last printer used for Printing the Kendo PackList for defaulting later
	lsPrinter = PrintGetPrinter()
	SetProfileString(gs_inifile,'PRINTERS','KENDOCI',lsPrinter)

Else
	
	MessageBox(w_do.is_title, 'There are no records to print for the Commercial Invoice')
	
End If

SetPointer(arrow!)


Return 0
end function

public function integer uf_print_dn_th_muser ();//23-Aug-2016 :Madhu - Added to Print Delivery Note

String lsDoNo
Datastore ldsReport

ldsReport =CREATE Datastore
ldsReport.dataobject='d_th_muser_delivery_note'
ldsReport.settransobject( SQLCA)

SetPointer(Hourglass!)

If isvalid (W_DO) Then /* Delivery Order*/
	
	//Pick list must be generated
	If w_do.idw_pick.RowCount() = 0 Then
		Messagebox(w_do.is_Title,'You must generate the Pick List before you can print the Delivery Note!')
		Return -1
	End If

	lsDoNo = w_do.idw_main.getItemString(1,'do_no')
	ldsReport.retrieve( gs_project, lsDoNo)

	If ldsReport.RowCOunt() > 0 Then
		OpenWithParm(w_dw_print_options,ldsReport) 
	Else
		MessageBox(w_do.is_title, 'There are no records to print for the Delivery Note')
	End If

End If

Return 1
end function

public function integer uf_process_dn_hager ();
//12/16 - PCONKL

String lsDoNo, lsUF1, lsUF2, lsUF3, lsUF4
Datastore ldsReport
Long	llRowPos, llRowCount

ldsReport =CREATE Datastore
ldsReport.dataobject='d_hager_dn'
ldsReport.settransobject( SQLCA)

SetPointer(Hourglass!)

If isvalid (W_DO) Then /* Delivery Order*/
	
	lsDoNo = w_do.idw_main.getItemString(1,'do_no')
	ldsReport.retrieve( lsDoNo)

	If ldsReport.RowCOunt() > 0 Then
		
		//set theUF from the first row to all rows...
		lsUF1 = ldsReport.GetITemString(1,'delivery_detail_User_Field1')
		lsUF2 = ldsReport.GetITemString(1,'delivery_detail_User_Field2')
		lsUF3 = ldsReport.GetITemString(1,'delivery_detail_User_Field3')
		lsUF4 = ldsReport.GetITemString(1,'delivery_detail_User_Field4')
		
		llRowCount =  ldsReport.RowCOunt()
		For llRowPos = 1 to llRowCount
			
			ldsReport.SetItem(llRowPos,'c_first_uf1',lsUF1)
			ldsReport.SetItem(llRowPos,'c_first_uf2',lsUF2)
			ldsReport.SetItem(llRowPos,'c_first_uf3',lsUF3)
			ldsReport.SetItem(llRowPos,'c_first_uf4',lsUF4)
			
		Next
		
		OpenWithParm(w_dw_print_options,ldsReport) 
		
		
	Else
		MessageBox(w_do.is_title, 'There are no records to print for the Delivery Note')
	End If

End If

Return 1
end function

public function integer uf_batch_print_hagersg_dn ();// Cloned from uf_batch_print_philips_dn
// GailM - 12/27/2017 - I540, F6127, S14469 HagerSG - Add PrintDN Button on Search Tab
// We will retrieve datastores for Main, Detail, Pick and Pack and pass to printing routine (same as for a single order)

Long	llRowCount, llRowPos, llCheckedCount, llCheckedPos
String	lsDONO
Boolean	lbPrintPrompt
datastore ldsMain, ldsDetail, ldsPick, ldsPack

ldsMain = create datastore
ldsMain.dataobject = 'd_do_master'
ldsMain.SetTransObject(SQLCA)

ldsdetail = create datastore
ldsDetail.dataobject = 'd_do_detail'
ldsDetail.SetTransObject(SQLCA)

ldsPick = create datastore
ldsPick.dataobject = 'd_do_picking'
ldsPick.SetTransObject(SQLCA)

ldsPack = create datastore
ldsPack.dataobject = 'd_do_packing_grid'
ldsPack.SetTransObject(SQLCA)

lbPrintPrompt = True /* will only show print dialog box for first one printed*/

//show status bar
//get the max count (numer of checked orders
llCheckedCount = 0
llRowCount = w_do.idw_result.RowCount()
For llRowPos = 1 to llRowCount
	if w_do.idw_result.getITemString(llRowPos,'c_select_ind') = 'Y' Then
		llCheckedCount ++
	End If
NExt

If llCheckedCount = 0 Then return 0

open(w_update_status)
w_update_status.hpb_status.MaxPosition = llCheckedCount

llRowCount = w_do.idw_result.RowCount()
For llRowPos = 1 to llRowCount
	
	if w_do.idw_result.getITemString(llRowPos,'c_select_ind') = 'Y' Then
		
		lsDONO = w_do.idw_result.getITemString(llRowPos,'do_no') 
		
		ldsMain.retrieve(lsDONO)
		ldsDetail.retrieve(lsDONO)
		ldsPick.retrieve(lsDONO)
		ldsPack.retrieve(lsDONO)
		
		If ldsMain.rowcount() > 0 Then
			
			llCheckedPos ++
			w_update_status.hpb_status.Position = llCheckedPos
			w_update_status.st_status.text = 'Printing Delivery Note for Order: ' + ldsMain.getITemString(1,'invoice_no') + "..."
			
		Else
			Continue
		End If
		
		uf_process_dn_hager_sg( ldsMain, ldsdetail, ldsPick, ldspack,lbPrintPrompt )

		lbPrintPrompt = False /* will only show print dialog box for first one printed*/
		
	End If
	
Next

Close(w_update_status)

Return 0
end function

public function integer uf_print_dn_hager_sg ();// 08/13 - PCONKL - Moved the bulk of printing logic to uf_process_dn_Philips to allow for eathe single order printing or batch printing from search results tab
// Cloned from uf_print_dn_philips

datastore ldsMain, ldsDetail, ldsPick, ldsPack

ldsMain = create datastore
ldsMain.dataobject = 'd_do_master'

ldsdetail = create datastore
ldsDetail.dataobject = 'd_do_detail'

ldsPick = create datastore
ldsPick.dataobject = 'd_do_picking'

ldsPack = create datastore
ldsPack.dataobject = 'd_do_packing_grid'

w_do.idw_Main.ShareData(ldsMain)
w_do.idw_Detail.ShareData(ldsDetail)
w_do.idw_Pick.ShareData(ldsPick)
w_do.idw_Pack.ShareData(ldsPack)

uf_process_dn_hager_sg(ldsMain, ldsdetail, ldsPick, ldspack,true) /*True = show printer selection dialog*/

Return 0

end function

public function integer uf_process_dn_hager_sg (datastore idsmain, datastore idsdetail, datastore idspick, datastore idspack, boolean ibshowprintdialog);//GailM 11/27/2017 - Story S13614 HagerSG customized delivery note

String lsDoNo, lsUF1, lsUF2, lsUF3, lsUF4
String lsWhCode, lsAd3, lsZip, lsTel, lsFax
String lsCountry, lsCountryCode
Datastore ldsReport
Long	llRowPos, llRowCount

n_cst_string	lnv_string

ldsReport =CREATE Datastore
ldsReport.dataobject='d_hager_sg_dn'
ldsReport.settransobject( SQLCA)

SetPointer(Hourglass!)

If isvalid (W_DO) Then /* Delivery Order*/
	
	lsDoNo = idsMain.getItemString(1,'do_no')
	ldsReport.retrieve( lsDoNo)

	If ldsReport.RowCOunt() > 0 Then
		
		lsWhCode =idsMain.getItemString(1, 'wh_code' )
		lsCountryCode = idsMain.getItemString( 1, 'country' )
		
		// Requirement to use country name using the country code on delivery order 
		SELECT country_name INTO :lsCountry
		FROM country
		WHERE designating_code = :lsCountryCode
		USING sqlca;
		
		//Set theUF 
		SELECT RTRIM( address_1 ), RTRIM( address_2 ), RTRIM( address_3), 
			RTRIM( city ), RTRIM( zip ), RTRIM( tel ), RTRIM( fax ), User_Field2
		INTO :lsUF1, :lsUF3, :lsAd3, :lsUF4, :lsZip, :lsTel, :lsFax, :lsUF2 
		FROM warehouse
		WHERE wh_code = :lsWhCode
		USING sqlca;
		
		//De-bold telephone no
		ldsReport.Modify("delivery_master_tel.Font.Weight='400'")
		
		//set theUF from the first row to all rows...
		lsUF1 = lnv_string.of_WordCap( lsUF1 )
		/* SoonHoon stated that since capitalization did not work properly due to periods between words, we would leave lsUF2 as capitalized if and until client complains */
		//lsUF2 = lnv_string.of_WordCap( lsUF2 ) 
		lsAd3 = lnv_string.of_WordCap( lsAd3 )
		lsUF3 = lnv_string.of_WordCap( lsUF3 )
		lsUF4 = lnv_string.of_WordCap( lsUF4 )
		
		lsUF3 += " " + lsAd3
		lsUF4 += " " + lsZip + " Tel: " + lsTel + " Fax: " + lsFax
		
		llRowCount =  ldsReport.RowCOunt()
		For llRowPos = 1 to llRowCount
			
			ldsReport.SetItem(llRowPos,'c_first_uf1',lsUF1)
			ldsReport.SetItem(llRowPos,'c_first_uf2',lsUF2)
			ldsReport.SetItem(llRowPos,'c_first_uf3',lsUF3)
			ldsReport.SetItem(llRowPos,'c_first_uf4',lsUF4)
			ldsReport.SetItem(llRowPos,'delivery_master_country',lsCountry )
			
		Next
				
		//Only show print dialog if first/only one bieng printed, otherwise print to default
		if ibShowPrintDialog Then
			OpenWithParm(w_dw_print_options,ldsReport) 
// TAM - 2018/03 - DE3538 - Need to capture the copies for subsequent prints
			iiCopies = integer(ldsReport.describe('datawindow.print.Copies'))
		else

// TAM - 2018/03 - DE3538 - Need to capture the copies for subsequent prints
			ldsReport.modify(" datawindow.print.copies = " + String(iiCopies))
			
			Print(ldsReport)
			message.DoubleParm = 1
		End If
		
	Else
		MessageBox(w_do.is_title, 'There are no records to print for the Delivery Note')
	End If

End If

Return 1
end function

public function str_parms getnotelist (string as_dono, string as_note_type);//20-APR-2018 :Madhu F7945 COTY Printing of personalized Leaflet

str_parms lstr_parms
string ls_note_text, ls_notes
long ll_row, ll_rowcount

Datastore  lds_Notes

lds_Notes = Create Datastore
lds_Notes.dataobject = 'd_do_notes'
lds_Notes.SetTransObject(SQLCA)

//Retrieve Notes based on Type
ll_rowcount = lds_Notes.retrieve( gs_project, as_dono, as_note_type)

For ll_row = 1 to ll_rowcount
	ls_note_text = lds_Notes.getItemString( ll_row, 'Note_Text')
	
	if IsNumber(ls_note_text) Then 
		lstr_parms.string_arg[1] = ls_note_text
	else
		ls_notes +=	ls_note_text
	end if
Next

lstr_parms.string_arg[2] = ls_notes

destroy lds_Notes
		
return lstr_parms
end function

public function integer uf_print_leaflet_coty ();//20-APR-2018 :Madhu F7945 COTY Printing of personalized Leaflet

str_parms lstr_Notes_parm, lstr_Images_Parm
string ls_dono, ls_note_type, ls_sql, ls_errors, ls_cust_name, ls_description
string ls_label_1, ls_label_2, ls_label_3, ls_label_4, ls_label_5, ls_label_6
string ls_label_7, ls_label_8, ls_label_9, ls_label_10, ls_label_11, ls_label_12
string ls_label_13, ls_label_14, ls_label_15, ls_label_16, ls_label_17, ls_label_18
string ls_Inside_Img, ls_Illustrate_Img, ls_Bowl_Img, ls_Clock_Img, ls_Desc_Img
string	ls_leaflet_Id, ls_color, ls_personal_id, ls_s_designed_text, ls_lady_Id, ls_personalized_id
string ls_label_5_1, ls_label_6_1, ls_label_7_1
long ll_row, ll_rowcount, ll_note_row
Datastore lds_leaflet, lds_leaflet1, lds_leaflet2, lds_NoteType

lds_leaflet = create Datastore
lds_leaflet.dataobject ='d_coty_leaflet'

lds_leaflet1 = create Datastore
lds_leaflet1.dataobject ='d_coty_leaflet_1'

lds_leaflet2 = create Datastore
lds_leaflet2.dataobject ='d_coty_leaflet_2'


//1st Page
ll_row = lds_leaflet1.insertrow( 0)
ls_dono = w_do.idw_main.getItemString(1, 'do_no') //Do No
// TAM 2018/07/11 DE5047 -  First letter of cust_name is cut off. This is because of the Font. We will append a <blank> in front so the font prints completely
//ls_cust_name = w_do.idw_main.getItemString(1, 'cust_name')
ls_cust_name = string(' ' + w_do.idw_main.getItemString(1, 'cust_name'))
ls_description = w_do.idw_detail.getItemString(1, 'description')
ls_leaflet_Id = w_do.idw_detail.getItemString(1, 'User_Field1') //LeafLet Id
ls_color = w_do.idw_detail.getItemString(1, 'User_Field3') //Custom Color

ls_cust_name = this.uf_modified_customer_name( ls_cust_name)

lds_leaflet1.setItem( ll_row, 'cust_name', ls_cust_name)
lds_leaflet1.setItem( ll_row, 'description', ls_description)
lds_leaflet1.setItem( ll_row, 'label_name1', ls_color)


//get distinct Note Types
lds_NoteType = Create Datastore
ls_sql = " select distinct Note_Type from Delivery_Notes with(nolock) where Do_No ='"+ls_dono+"'"
lds_NoteType.create( SQLCA.syntaxfromsql( ls_sql, "", ls_errors))
lds_NoteType.settransobject( SQLCA)
ll_rowcount = lds_NoteType.retrieve( )

IF ll_rowcount > 0 Then
	For ll_note_row =1 to ll_rowcount
		ls_note_type = lds_NoteType.getItemString( ll_note_row, 'Note_Type')
		
		//Retrieve Notes based on Type
		lstr_Notes_parm = this.getnotelist( ls_dono, ls_note_type)

		//assign Notes Text
		IF UpperBound(lstr_Notes_parm.string_arg[]) > 0 Then
			CHOOSE CASE upper(ls_note_type)
			CASE 'C'
				lds_leaflet1.setItem( ll_row, "c_type_text1", lstr_Notes_parm.string_arg[1])
				lds_leaflet1.setItem( ll_row, "c_type_text2", lstr_Notes_parm.string_arg[2])
			CASE 'D'
				lds_leaflet1.setItem( ll_row, "d_type_text1", lstr_Notes_parm.string_arg[1])
				lds_leaflet1.setItem( ll_row, "d_type_text2", lstr_Notes_parm.string_arg[2])
			
			CASE 'S'
				lds_leaflet1.setItem( ll_row, "s_type_text1", lstr_Notes_parm.string_arg[1])
				lds_leaflet1.setItem( ll_row, "s_type_text2", lstr_Notes_parm.string_arg[2])
			CASE 'M'
				lds_leaflet1.setItem( ll_row, "m_type_text1", lstr_Notes_parm.string_arg[1])
				lds_leaflet1.setItem( ll_row, "m_type_text2", lstr_Notes_parm.string_arg[2])
			END CHOOSE
		End IF
	Next
End IF


//2nd Page
ll_row = lds_leaflet2.insertrow( 0)

//Assign appropriate Images against Leaflet Id
lstr_Images_Parm = this.uf_get_leaflet_matrix_images(ls_leaflet_Id)

If UpperBound(lstr_Images_Parm.string_arg[]) > 0 Then
	ls_Inside_Img = lstr_Images_Parm.string_arg[1] //Inside Image
	ls_Illustrate_Img = lstr_Images_Parm.string_arg[2] //Illustration Image
	ls_Bowl_Img = lstr_Images_Parm.string_arg[3] //Bowl's Image
	ls_Clock_Img = lstr_Images_Parm.string_arg[4] //Clock Image
	
	ls_Desc_Img = lstr_Images_Parm.string_arg[5] //Description Image
End If

//Assign images
lds_leaflet1.setItem( ll_row, 'image_1', ls_Desc_Img)

lds_leaflet2.setItem( ll_row, 'image_1', ls_Inside_Img)
lds_leaflet2.setItem( ll_row, 'image_2', ls_Illustrate_Img)
lds_leaflet2.setItem( ll_row, 'image_3', ls_Bowl_Img)
lds_leaflet2.setItem( ll_row, 'image_4', ls_Clock_Img)

 
ls_personalized_id = Left(ls_leaflet_Id, 2) //Personalized ID

SELECT *   
INTO :ls_personal_id, :ls_s_designed_text, :ls_label_1, :ls_label_2, :ls_label_3, :ls_label_4, :ls_label_5, :ls_label_6, :ls_label_7, :ls_label_8, :ls_label_9, :ls_label_10,   
:ls_label_11, :ls_label_12, :ls_label_13,  :ls_label_14, :ls_label_15, :ls_label_16, :ls_label_17  
FROM Coty_Personalized_Text  with(nolock)
WHERE Coty_Personalized_Text.Personalized_ID = :ls_personalized_id ;

lds_leaflet1.setItem( ll_row, 's_designed_text', ls_s_designed_text)
lds_leaflet2.setItem( ll_row, 'label_1', ls_label_1)
lds_leaflet2.setItem( ll_row, 'label_2', ls_label_2)
lds_leaflet2.setItem( ll_row, 'label_3', ls_label_3)
lds_leaflet2.setItem( ll_row, 'label_4', ls_label_4)
lds_leaflet2.setItem( ll_row, 'label_5', ls_label_5)
lds_leaflet2.setItem( ll_row, 'label_17', ls_label_6)
lds_leaflet2.setItem( ll_row, 'label_6', ls_label_7)
lds_leaflet2.setItem( ll_row, 'label_7', ls_label_8)
lds_leaflet2.setItem( ll_row, 'label_8', ls_label_9)
lds_leaflet2.setItem( ll_row, 'label_9', ls_label_10)
lds_leaflet2.setItem( ll_row, 'label_10', ls_label_11)
lds_leaflet2.setItem( ll_row, 'label_11', ls_label_12)
lds_leaflet2.setItem( ll_row, 'label_12', ls_label_13)
lds_leaflet2.setItem( ll_row, 'label_13', ls_label_14)
lds_leaflet2.setItem( ll_row, 'label_14', ls_label_15)
lds_leaflet2.setItem( ll_row, 'label_15', ls_label_16)
lds_leaflet2.setItem( ll_row, 'label_16', ls_label_17)

//If ls_label_8 = '' or isNull(ls_label_8) then 
//	lds_leaflet2.setItem( ll_row, 'label_17', '')
//	lds_leaflet2.setItem( ll_row, 'label_6', ls_label_6)
//	lds_leaflet2.setItem( ll_row, 'label_7', ls_label_7)
//	lds_leaflet2.setItem( ll_row, 'label_21', '')
//	lds_leaflet2.setItem( ll_row, 'label_22', '6.')
//	lds_leaflet2.setItem( ll_row, 'label_23', '7.')
//Else
//	lds_leaflet2.setItem( ll_row, 'label_17', ls_label_6)
//	lds_leaflet2.setItem( ll_row, 'label_6', ls_label_7)
//	lds_leaflet2.setItem( ll_row, 'label_7', ls_label_8)
//	lds_leaflet2.setItem( ll_row, 'label_21', '6.')
//	lds_leaflet2.setItem( ll_row, 'label_22', '7.')
//	lds_leaflet2.setItem( ll_row, 'label_23', '8.')
//End If

//Set sequential numbering correctly
//Set labels 21-23
int i=5
If len(ls_label_6) >0 Then	
	i++
	lds_leaflet2.setItem( ll_row, 'label_21', string(i) + '.')
End If
If len(ls_label_7) >0 Then	
	i++
	lds_leaflet2.setItem( ll_row, 'label_22', string(i) + '.')
End If
If len(ls_label_8) >0 Then	
	i++
	lds_leaflet2.setItem( ll_row, 'label_23', string(i) + '.')
End If

//Set labels 24-29
i=0
If len(ls_label_9) >0	Then 	
	i++
	lds_leaflet2.setItem( ll_row, 'label_24', string(i)+'.') 
End If
If len(ls_label_10) >0 Then	
	i++
	lds_leaflet2.setItem( ll_row, 'label_25', string(i)+'.')
End If
If len(ls_label_11) >0 Then 
	i++
	lds_leaflet2.setItem( ll_row, 'label_26', string(i)+'.') 
End If
If len(ls_label_12) >0 Then 
	i++
	lds_leaflet2.setItem( ll_row, 'label_27', string(i)+'.')
End If
If len(ls_label_13) >0 Then 	
	i++
	lds_leaflet2.setItem( ll_row, 'label_28', string(i)+'.') 
End If
If len(ls_label_14) >0 Then 	
	i++
	lds_leaflet2.setItem( ll_row, 'label_29', string(i)+'.') 
End If

//Set labels 30-32
i=0
If len(ls_label_15) >0 Then 
	i++
	lds_leaflet2.setItem( ll_row, 'label_30', string(i)+'.')
End If
If len(ls_label_16) >0 Then 	
	i++
	lds_leaflet2.setItem( ll_row, 'label_31', string(i)+'.')
End If
If len(ls_label_17) >0 Then 
	i++
	lds_leaflet2.setItem( ll_row, 'label_32', string(i)+'.') 
End If



Datawindowchild ldwc1, ldwc2
lds_leaflet.getchild( 'dw_1', ldwc1)
lds_leaflet.getchild( 'dw_2', ldwc2)

//copy data into child DW
lds_leaflet1.Rowscopy( lds_leaflet1.getRow(), lds_leaflet1.rowcount(), Primary!, ldwc1, 1, Primary!)
lds_leaflet2.Rowscopy( lds_leaflet2.getRow(), lds_leaflet2.rowcount(), Primary!, ldwc2, 1, Primary!)

//Print
OpenWithParm(w_dw_print_options,lds_leaflet) 


destroy lds_NoteType

return 0
end function

public function string uf_modified_customer_name (readonly string as_cust_name);//20-APR-2018 :Madhu F7945 COTY Printing of personalized Leaflet

string ls_cust_name, ls_name, ls_subA, ls_subB, ls_mod_name
long  ll_Pos

ll_Pos = 0
ls_cust_name = as_cust_name

//Space Seperated
DO WHILE Pos(ls_cust_name, ' ') > 0
	ll_Pos = Pos(ls_cust_name, ' ') //get Position of space
	
	ls_subA = Mid(ls_cust_name, 0, ll_Pos )
	ls_subB = Mid(ls_cust_name, ll_Pos +1, len(ls_cust_name))
	
	ls_name = upper(left(ls_subA, 1)) + lower(Right(ls_subA, len(ls_subA) -1)) //convert 1st char to Uppercase from 1st sub-string
	ls_cust_name = upper(left(ls_subB, 1)) + lower(Right(ls_subB, len(ls_subB) -1)) //convert 1st char to Uppercase from 2nd sub-string
	
	If len(ls_name) > 0 Then ls_mod_name += ls_name
LOOP

//Hyphen Seperated
DO WHILE Pos(ls_cust_name, '-') > 0
	ll_Pos = Pos(ls_cust_name, '-') //get Position of Hyphen
	
	ls_subA = Mid(ls_cust_name, 0, ll_Pos )
	ls_subB = Mid(ls_cust_name, ll_Pos +1, len(ls_cust_name))
	
	ls_name = upper(left(ls_subA, 1)) + lower(Right(ls_subA, len(ls_subA) -1)) //convert 1st char to Uppercase from 1st sub-string
	ls_cust_name = upper(left(ls_subB, 1)) + lower(Right(ls_subB, len(ls_subB) -1)) //convert 1st char to Uppercase from 2nd sub-string
	
	If len(ls_name) > 0 Then ls_mod_name += ls_name
LOOP

//Comma Seperated
DO WHILE Pos(ls_cust_name, ',') > 0
	ll_Pos = Pos(ls_cust_name, ',') //get Position of Comma
	
	ls_subA = Mid(ls_cust_name, 0, ll_Pos )
	ls_subB = Mid(ls_cust_name, ll_Pos +1, len(ls_cust_name))
	
	ls_name = upper(left(ls_subA, 1)) + lower(Right(ls_subA, len(ls_subA) -1)) //convert 1st char to Uppercase from 1st sub-string
	ls_cust_name = upper(left(ls_subB, 1)) + lower(Right(ls_subB, len(ls_subB) -1)) //convert 1st char to Uppercase from 2nd sub-string
	
	If len(ls_name) > 0 Then ls_mod_name += ls_name
LOOP

ls_mod_name +=ls_cust_name

Return ls_mod_name
end function

public function str_parms uf_get_leaflet_matrix_images (string as_leatlet_id);//07-MAY-2018 :Madhu S18798 COTY: Printing of personalized Leaflet
//Based on Matrix, assign appropriate images to LeafLet.

Str_Parms lstr_leaftLet_parms
string ls_person_Id, ls_lady_Id
long ll_LeatLet_Id, ll_person_Id

ll_LeatLet_Id = len(as_leatlet_id) //length of LeafLet Id
ls_person_Id = Left(as_leatlet_id ,2) //Left 2-chars of Personalized Id (01, 02, 03 etc.,)
ls_lady_Id = Right(as_leatlet_id, 4) //Right 4-chars of Lady Id (BLSP,BRSP,RDSP,BKSP etc.,)

//1. Assign Inside Image
CHOOSE CASE ls_person_Id
	CASE '02'
		lstr_leaftLet_parms.string_arg[1] ="Inside_FirstTimeUsers.png"
	CASE ELSE
		lstr_leaftLet_parms.string_arg[1] ="Inside_Standard.png"
END CHOOSE

//2. Assign Illustrations Image
CHOOSE CASE upper(ls_lady_Id)
	CASE 'BKCW'
		lstr_leaftLet_parms.string_arg[2] ="BKCW.png"
	CASE 'BKMB'
		lstr_leaftLet_parms.string_arg[2] ="BKMB.png"
	CASE 'BKSL'
		lstr_leaftLet_parms.string_arg[2] ="BKSL.png"
	CASE 'BKSP'
		lstr_leaftLet_parms.string_arg[2] ="BKSP.png"
	CASE 'BLCW'
		lstr_leaftLet_parms.string_arg[2] ="BLCW.png"
	CASE 'BLMB'
		lstr_leaftLet_parms.string_arg[2] ="BLMB.png"
	CASE 'BLSL'
		lstr_leaftLet_parms.string_arg[2] ="BLSL.png"
	CASE 'BLSP'
		lstr_leaftLet_parms.string_arg[2] ="BLSP.png"
	CASE 'BRCW'
		lstr_leaftLet_parms.string_arg[2] ="BRCW.png"
	CASE 'BRMB'
		lstr_leaftLet_parms.string_arg[2] ="BRMB.png"
	CASE 'BRSL'
		lstr_leaftLet_parms.string_arg[2] ="BRSL.png"
	CASE 'BRSP'
		lstr_leaftLet_parms.string_arg[2] ="BRSP.png"
	CASE 'RDCW'
		lstr_leaftLet_parms.string_arg[2] ="RDCW.png"
	CASE 'RDMB'
		lstr_leaftLet_parms.string_arg[2] ="RDMB.png"
	CASE 'RDSL'
		lstr_leaftLet_parms.string_arg[2] ="RDSL.png"
	CASE 'RDSP'
		lstr_leaftLet_parms.string_arg[2] ="RDSP.png"
END CHOOSE

//3. Assign Bowls Image
IF ls_person_Id ='02' THEN
	CHOOSE CASE Upper(left(ls_lady_Id ,2))
		CASE 'BK'
			lstr_leaftLet_parms.string_arg[3] ="FTUBowl_BK.png"
		CASE 'BL'
			lstr_leaftLet_parms.string_arg[3] ="FTUBowl_BL.png"
		CASE 'BR'
			lstr_leaftLet_parms.string_arg[3] ="FTUBowl_BR.png"
		CASE 'RD','RM'
			lstr_leaftLet_parms.string_arg[3] ="FTUBowl_RD.png"
	END CHOOSE
ELSE
	CHOOSE CASE Upper(left(ls_lady_Id ,2))
		CASE 'BK'
			lstr_leaftLet_parms.string_arg[3] ="StandardBowl_BK.png"
		CASE 'BL'
			lstr_leaftLet_parms.string_arg[3] ="StandardBowl_BL.png"
		CASE 'BR'
			lstr_leaftLet_parms.string_arg[3] ="StandardBowl_BR.png"
		CASE 'RD' ,'RM'
			lstr_leaftLet_parms.string_arg[3] ="StandardBowl_RD.png"
	END CHOOSE
END IF

//4. Assign clocks Image
CHOOSE CASE ls_person_Id
	CASE '02', '03', '04'
		lstr_leaftLet_parms.string_arg[4] ="FTU_Clocks.png"
	CASE '05'
		lstr_leaftLet_parms.string_arg[4] ="Vibrant_Red_Clocks.png"
	CASE '06', '07'
		lstr_leaftLet_parms.string_arg[4] ="GrayExtraTime_Clocks.png"
	CASE ELSE
		lstr_leaftLet_parms.string_arg[4] ="Standard_Clocks.png"
END CHOOSE


//5. Assign Description
CHOOSE CASE ls_person_Id
	CASE '01'
		lstr_leaftLet_parms.string_arg[5] ="Unicorn_Leaflet_01Standard_Intro.png"
	CASE '02'
		lstr_leaftLet_parms.string_arg[5] ="Unicorn_Leaflet_02FirstTime_Intro.png"
	CASE '03'
		lstr_leaftLet_parms.string_arg[5] ="Unicorn_Leaflet_03Recoloring_Intro.png"
	CASE '04'
		lstr_leaftLet_parms.string_arg[5] ="Unicorn_Leaflet_04Semi-Demi_Intro.png"
	CASE '05'
		lstr_leaftLet_parms.string_arg[5] ="Unicorn_Leaflet_05VibrantReds_Intro.png"
	CASE '06'
		lstr_leaftLet_parms.string_arg[5] ="Unicorn_Leaflet_06Gray_Intro.png"
	CASE '07'
		lstr_leaftLet_parms.string_arg[5] ="Unicorn_Leaflet_07LightestBlonde_Intro.png"
	CASE '08'
		lstr_leaftLet_parms.string_arg[5] ="Unicorn_Leaflet_08TraditionalHighlights_Intro.png"
	CASE '09'
		lstr_leaftLet_parms.string_arg[5] ="Unicorn_Leaflet_09Balayage_Intro.png"
	CASE '10'
		lstr_leaftLet_parms.string_arg[5] ="Unicorn_Leaflet_10Ombre_Intro.png"
END CHOOSE


return lstr_leaftLet_parms
end function

public function integer uf_print_dn_philipscls ();// 2019/07/10 - TAM  - DE11587 - Moved the bulk of printing logic to uf_process_dn_Philipscls to allow for eathe single order printing or batch printing from search results tab

datastore ldsMain, ldsDetail, ldsPick, ldsPack

ldsMain = create datastore
ldsMain.dataobject = 'd_do_master'

ldsdetail = create datastore
ldsDetail.dataobject = 'd_do_detail'

ldsPick = create datastore
ldsPick.dataobject = 'd_do_picking'

ldsPack = create datastore
ldsPack.dataobject = 'd_do_packing_grid'

w_do.idw_Main.ShareData(ldsMain)
w_do.idw_Detail.ShareData(ldsDetail)
w_do.idw_Pick.ShareData(ldsPick)
w_do.idw_Pack.ShareData(ldsPack)

uf_process_dn_philipscls(ldsMain, ldsdetail, ldsPick, ldspack,true) /*Triue = show printer selection dialog*/
Return 0


//*************************************************************************************************************************************

/*


//15-APR-2019 :Madhu S32302 PhilipsCLS Delivery Note
//25-APR-2019 :Madhu DE10196 PhilipsCLS Delivery Note
//07-MAY-2019 :Madhu S33197 PhilipsCLS Delivery Note
//17-MAY-2019 :Madhu S33803 PhilipsCLS Delivery Note

String	lsWarehouse,  lsSKU, lsSupplier, lsAltSku, lsDONO, lsDesc, lsInvType, lsPONO, lsPlant, lsSerial
String	lsFind, lsUF8, lsUF9, lsUOM, lsPhilipsInvType ,ls_whcode, lsType, ls_cust_purchase_order
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText, ls_dd_uf1, ls_dd_uf5
String lsSuppName, lsSuppAddress_1, lsSuppAddress_2, lsSuppAddress_3, lsSuppAddress_4
String lsSuppCity, lsSuppState, lsSuppCountry, lsSuppZip, ls_Cust_Ord_No, ls_buyer_code, ls_new_sku
String ls_dm_uf20, ls_uf20, ls_dd_uf6, lsFilter, ls_uf19, ls_uf21, ls_uf22

Long	llRowCount, llRowPos, llNewRow, llFind, llLIneItem, llDetailFind, llBOMFind, llFindRow, llNewDetailRow

Int	 liNotePos, llCount

Decimal {4} ldGrossWeight, ldNetWeight, ldNetVolume, ldGrossVolume

boolean ibShowPrintDialog =true
boolean lbHardBundle =FALSE

DataStore	ldsNotes, ldsSoldToAddress, ldsBillToAddress,  ldsserial, ldsReport, ldsBOM

SetPointer(Hourglass!)

//Pack list must be generated
If w_do.idw_pack.RowCount() = 0 Then
	Messagebox(w_do.is_Title,"Order: " + w_do.idw_main.getItemString(1,'invoice_no') + ', You must generate the Pack List before you can print the Delivery Note!')
	Return -1
End If

ldsReport = Create Datastore
ldsReport.dataobject = 'd_philips_cls_delivery_note'

lsWarehouse = w_do.idw_Main.getItemString(1,'wh_Code')
lsDoNO = w_do.idw_Main.getItemString(1,'do_no')
lsPlant = w_do.idw_Main.getItemString(1,'User_Field3')
ls_Cust_Ord_No = w_do.idw_Main.getItemString(1,'cust_order_no')
ls_buyer_code = w_do.idw_Main.getItemString(1, 'User_Field2')

ls_cust_purchase_order= w_do.idw_detail.getItemString(1, 'User_Field2')
	
ldsSoldToAddress = Create DataStore
ldsSoldToAddress.dataObject = 'd_do_address_alt'
ldsSoldToAddress.SetTransObject(sqlca)
	
ldsSoldToAddress.Retrieve(lsdono, 'ST') /*Sold To Address*/

ldsBillToAddress = Create DataStore
ldsBillToAddress.dataObject = 'd_do_address_alt'
ldsBillToAddress.SetTransObject(sqlca)

ldsBillToAddress.Retrieve(lsdono, 'BT') /*Bill To Address*/

//Delivery Notes
ldsNotes = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select Note_seq_No, Note_Text, Line_Item_No from Delivery_Notes  with(nolock) Where do_no = '" + lsDoNO + "'"
dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsNotes.Create( dwsyntax_str, lsErrText)
ldsNotes.SetTransObject(SQLCA)

ldsNotes.Retrieve()
ldsNotes.SetSort("Line_Item_No A, Note_Seq_No A")
ldsNotes.Sort()

//Delivery BOM
ldsBOM = Create Datastore
lsSql = " Select * From Delivery_BOM with(nolock) where Project_Id ='"+gs_project+"' and Do_No ='"+lsDoNO+"'"
ldsBOM.create( SQLCA.syntaxfromsql( lsSql, "", lsErrText))
ldsBOM.SetTransObject( SQLCA)
ldsBOM.retrieve( )
	
//For Malaysia Plant code (MY10) or (MYQ0), we want to print Serial Numbers -
If Pos(lsPlant, 'MY') > 0 or lsPlant ="2180" Then
	ldsSerial = Create Datastore
	presentation_str = "style(type=grid)"

	lsSQl = " Select Delivery_serial_detail.Serial_No, Delivery_serial_detail.Quantity, "
	lsSQL += " Delivery_Picking_Detail.Line_Item_No, Delivery_Picking_Detail.SKU, Delivery_Picking_Detail.Supp_Code, Delivery_Picking_Detail.Inventory_Type "
	lsSQL += " From Delivery_Picking_Detail with(nolock), Delivery_Serial_Detail with(nolock) "
	lsSQL += " Where Delivery_Picking_Detail.ID_NO = Delivery_Serial_Detail.ID_NO "
	lsSQL += " and Delivery_Picking_Detail.do_no = '" + lsDONO + "'"


	dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
	ldsSerial.Create( dwsyntax_str, lsErrText)
	ldsSerial.SetTransobject(sqlca)
	ldsSerial.Retrieve()
End If

ldsReport.reset()

llRowCount = w_do.idw_pick.RowCount()
For llRowPos = 1 to llRowCount

	lsSKU = w_do.idw_pick.getItemString(llRowPos,'sku')
	lsSupplier =w_do.idw_pick.getItemString(llRowPos,'supp_Code')
	lsInvType = w_do.idw_pick.getItemString(llRowPos,'inventory_Type')
	llLineItem = w_do.idw_pick.GetItemNumber(llRowPos,'Line_Item_No')
		
	If w_do.idw_pick.GetITemNumber(llRowPos,'quantity') = 0 Then Continue
	
	ls_new_sku =this.remove_leading_zeros( lsSKU) //Remove leading zero's
	
	//Roll Up To To Line/SKU/Inventory Type
	lsFind = "po_line = " + String(llLineItem) + " and SKU = '" + ls_new_sku + "' and Inventory_Type = '" + lsInvType + "'"
		
	llFind = ldsReport.Find(lsFind,1,ldsReport.RowCount())
	If llFind > 0 Then
		ldsReport.setItem(llFind,'quantity',ldsReport.GetITemNumber(llFind,'quantity') + w_do.idw_pick.GetITemNumber(lLRowPOs,'quantity')) /*add to existing Row*/
		Continue
	End If
	
	setNull(ls_dd_uf5)
	llDetailFind = w_do.idw_detail.Find("sku ='"+lsSKU+"' and Line_Item_No = " + String(llLineItem),1,w_do.idw_detail.RowCount())
	
	IF llDetailFind > 0 THEN 
		ls_dd_uf5 = w_do.idw_detail.getItemString(llDetailFind, 'User_Field5')
		ls_dd_uf6 = w_do.idw_detail.getItemString(llDetailFind, 'User_Field6')
	END IF
	
	IF Pos(lsPlant, 'MY') = 0 and upper(ls_dd_uf5) ='NONPIC' THEN Continue //1. don't display NONPIC SKU's & Plant <> 'MY' on Delivery Note.
	
	lbHardBundle = FALSE //reset value
	IF Pos(lsPlant, 'MY') > 0 and Upper(ls_dd_uf5) ='PIC' and ls_dd_uf6 <> '000' THEN lbHardBundle =TRUE //2. Determine HardBundle

	//Insert a new report Row
	llNewRow = ldsReport.InsertRow(0)
	ldsReport.setItem(llNewRow,'project_id', gs_project )
	
	//Header Notes (up to 4 rows)
	liNotePos = 0
	llFind = ldsNotes.Find("Line_Item_No = 0",1,ldsNotes.RowCount()) /* line_item = 0 for header Notes*/
	Do While llFind > 0
		liNotePos ++
		lsNotePos = "header_remarks" + String(liNotePos)
		
		//Print Note_Text
		IF Pos(lsPlant ,'MY') > 0 and Pos(ldsNotes.getItemString(llFind,"note_Text"), 'ORD-508' ) > 0 THEN
			ldsReport.setItem(llNewRow,lsNotePos, ldsNotes.getItemString(llFind,"note_Text"))
		ELSEIF Pos(lsPlant ,'MY') = 0 THEN
			ldsReport.setItem(llNewRow,lsNotePos, ldsNotes.getItemString(llFind,"note_Text"))
		END IF
		
		llFind ++
		If llFind > ldsNotes.RowCount() or liNotePos = 10 Then 
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
		lsNoteText += ldsNotes.getItemString(llFind,"note_Text") + " "
				
		llFind ++
		If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
			llFind = 0
		Else
			llFind = ldsNotes.Find("Line_Item_No = " + string(llLineItem),llFind,ldsNotes.RowCount())
		End If
	Loop
	
	select supp_name, address_1, address_2, address_3, address_4, city, state, country, zip 
	into :lsSuppName,:lsSuppAddress_1, :lsSuppAddress_2, :lsSuppAddress_3, :lsSuppAddress_4,
		:lsSuppCity, :lsSuppState, :lsSuppCountry, :lsSuppZip
	from Supplier with(nolock)
	where Project_id = :gs_project and supp_code = :lsSupplier;
	
	//Ship From Address
	ldsReport.setItem(llNewRow,'ship_from_name', lsSuppName )
	ldsReport.setItem(llNewRow,"ship_from_addr1", lsSuppAddress_1)
	ldsReport.setItem(llNewRow,"ship_from_addr2", lsSuppAddress_2 )
	ldsReport.setItem(llNewRow,"ship_from_addr3", lsSuppAddress_3)
	ldsReport.setItem(llNewRow,"ship_from_addr4", lsSuppAddress_4)
	ldsReport.setItem(llNewRow,"ship_from_city", lsSuppCity)
	ldsReport.setItem(llNewRow,"ship_from_state", lsSuppState)
	ldsReport.setItem(llNewRow,"ship_from_country", lsSuppCountry )
	ldsReport.setItem(llNewRow,"ship_from_zip", lsSuppZip )
	
	ldsReport.setItem(llNewRow,'do_number', w_do.idw_main.getItemString(1,'invoice_no'))
	ldsReport.setItem(llNewRow,'route', '')
	
	//DO_Type
	If Pos(lsPlant,'MY') > 0 or lsPlant = "2180" Then /*No DO Type for Malaysia */
	else
		If Upper(w_do.idw_main.getItemString(1,'country')) <> 'SG' and w_do.idw_main.getItemString(1,'country') <> 'SINGAPORE' Then
			ldsReport.setItem(llNewRow,'DO_TYPE','Export')
		Elseif Upper(w_do.idw_main.getItemString(1,'USer_Field2')) = 'SG9999' Then
			ldsReport.setItem(llNewRow,'DO_TYPE','Self Collection')
		Elseif Upper(w_do.idw_main.getItemString(1,'USer_Field2')) = 'SGM9' Then
			ldsReport.setItem(llNewRow,'DO_TYPE','STO')
		Else
			ldsReport.setItem(llNewRow,'DO_TYPE','Normal Delivery')
		End If
	End If
	
	ldsReport.setItem(llNewRow,'DO_receipt_dateTime',w_do.idw_main.getItemDateTime(1,'ord_date'))
	
	ls_uf19 = w_do.idw_main.getItemString(1,'User_Field19') //User Field19
	ls_uf20 = w_do.idw_main.getItemString(1,'User_Field20') //User Field20
	ls_uf21 = w_do.idw_main.getItemString(1,'User_Field21') //User Field21
	ls_uf22 = w_do.idw_main.getItemString(1,'User_Field22') //User Field22
	
	IF len(ls_uf20) = 8 THEN //Ex:-20190427
		ls_dm_uf20 = right(ls_uf20,2)+'.'+mid(ls_uf20,5,2)+'.'+left(ls_uf20,4) //dd.mm.yyyy
		ldsReport.setItem(llNewRow,'dm_uf_20', ls_dm_uf20)
	ELSE
		ldsReport.setItem(llNewRow,'dm_uf_20', ls_uf20)
	END IF
	
	IF Pos(lsPlant,'MY') > 0 THEN
		ldsReport.setItem(llNewRow,'dm_uf_19', ls_uf19)
		ldsReport.setItem(llNewRow,'dm_uf_21', ls_uf21)
		ldsReport.setItem(llNewRow,'dm_uf_22', ls_uf22)
	END IF
	
	//Ship To Address
	ldsReport.setItem(llNewRow,'ship_to_code',w_do.idw_main.getItemString(1,'cust_code'))
	ldsReport.setItem(llNewRow,'ship_to_name',w_do.idw_main.getItemString(1,'cust_Name'))
	ldsReport.setItem(llNewRow,'ship_to_addr1',w_do.idw_main.getItemString(1,'address_1'))
	ldsReport.setItem(llNewRow,'ship_to_addr2',w_do.idw_main.getItemString(1,'address_2'))
	ldsReport.setItem(llNewRow,'ship_to_addr3',w_do.idw_main.getItemString(1,'address_3'))
	ldsReport.setItem(llNewRow,'ship_to_addr4',w_do.idw_main.getItemString(1,'address_4'))
	ldsReport.setItem(llNewRow,'ship_to_city',w_do.idw_main.getItemString(1,'city'))
	ldsReport.setItem(llNewRow,'ship_to_state',w_do.idw_main.getItemString(1,'state'))
	ldsReport.setItem(llNewRow,'ship_to_zip',w_do.idw_main.getItemString(1,'zip'))
	ldsReport.setItem(llNewRow,'ship_to_country',w_do.idw_main.getItemString(1,'country'))
	ldsReport.setItem(llNewRow,'ship_to_contact',w_do.idw_main.getItemString(1,'contact_person'))
	ldsReport.setItem(llNewRow,'ship_to_tel',w_do.idw_main.getItemString(1,'tel'))
	
	//Sold To Address
	If ldsSoldToAddress.RowCount() > 0 Then
		ldsReport.setItem(llNewRow,'sold_to_name', ldsSoldToAddress.getItemString(1,'name'))
		ldsReport.setItem(llNewRow,"sold_to_addr1", ldsSoldToAddress.getItemString(1,'address_1'))
		ldsReport.setItem(llNewRow,"sold_to_addr2", ldsSoldToAddress.getItemString(1,'address_2'))
		ldsReport.setItem(llNewRow,"sold_to_addr3", ldsSoldToAddress.getItemString(1,'address_3'))
		ldsReport.setItem(llNewRow,"sold_to_addr4", ldsSoldToAddress.getItemString(1,'address_4'))
		ldsReport.setItem(llNewRow,"sold_to_district", ldsSoldToAddress.getItemString(1,'district'))
		ldsReport.setItem(llNewRow,"sold_to_city", ldsSoldToAddress.getItemString(1,'city'))
		ldsReport.setItem(llNewRow,"sold_to_state", ldsSoldToAddress.getItemString(1,'state'))
		ldsReport.setItem(llNewRow,"sold_to_zip", ldsSoldToAddress.getItemString(1,'zip'))
		ldsReport.setItem(llNewRow,"sold_to_country", ldsSoldToAddress.getItemString(1,'country'))
	End If
	
	//Bill To Address
	If ldsBillToAddress.RowCount() > 0 Then
		ldsReport.setItem(llNewRow,'bill_to_name', ldsBillToAddress.getItemString(1, 'name'))
		ldsReport.setItem(llNewRow,"bill_to_addr1", ldsBillToAddress.getItemString(1,'address_1'))
		ldsReport.setItem(llNewRow,"bill_to_addr2", ldsBillToAddress.getItemString(1,'address_2'))
		ldsReport.setItem(llNewRow,"bill_to_addr3", ldsBillToAddress.getItemString(1,'address_3'))
		ldsReport.setItem(llNewRow,"bill_to_addr4", ldsBillToAddress.getItemString(1,'address_4'))
		ldsReport.setItem(llNewRow,"bill_to_district", ldsBillToAddress.getItemString(1,'district'))
		ldsReport.setItem(llNewRow,"bill_to_city", ldsBillToAddress.getItemString(1,'city'))
		ldsReport.setItem(llNewRow,"bill_to_state", ldsBillToAddress.getItemString(1,'state'))
		ldsReport.setItem(llNewRow,"bill_to_zip", ldsBillToAddress.getItemString(1,'zip'))
		ldsReport.setItem(llNewRow,"bill_to_country", ldsBillToAddress.getItemString(1,'country'))
	End If
	
	IF llDetailFind > 0 THEN
		ls_dd_uf1 = w_do.idw_detail.getItemString(llDetailFind, 'User_Field1')
	END IF
	
	select description, user_field8, user_field9,  weight_1  into	:lsDesc, :lsUF8, :lsUF9, :ldNetWEight
	from Item_Master with(nolock)
	where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
		
	if sqlca.sqlcode <> 0 then
		MessageBox ("DB Error", SQLCA.SQLErrText )
	end if
	
	//Weight
	If isnull(ldNetWeight)Then ldNetWeight = 0
	ldsReport.setItem(llNewRow,'net_weight',ldNetWEight)
	
	//Volume
	If isnumber(lsUF8) Then
		ldsReport.setItem(llNewRow,'net_volume',Dec(lsUF8))
	Else
		ldsReport.setItem(llNewRow,'net_volume',0)
	End If

	ldsReport.setItem(llNewRow,'sku', ls_new_sku)
	ldsReport.setItem(llNewRow,'supp_code',lsSupplier)
	ldsReport.setItem(llNewRow,'description', lsDesc)	
	ldsReport.setItem(llNewRow,'alt_Sku',ls_dd_uf1)
	ldsReport.setItem(llNewRow,'customer_material_no',ls_dd_uf1)	
	ldsReport.setItem(llNewRow,'po_nbr', ls_cust_purchase_order) 
	ldsReport.setItem(llNewRow,'buyer_code', ls_buyer_code) 	
	
	//Find child SKU on Delivery BOM
	llBOMFind = ldsBOM.find( "SKU_Child='"+lsSKU+"'", 1, ldsBOM.rowcount())
	
	IF llBOMFind > 0 THEN
		
		DO WHILE llBOMFind > 0
			//don't assing duplicate child_line_item_no, if already present
			lsFind ="SKU ='"+ls_new_sku+"' and po_line ="+String(ldsBOM.getItemNumber( llBOMFind, 'Child_Line_Item_No'))
			llFindRow = ldsReport.find( lsFind, 1, ldsReport.rowcount( )+1)
			
			IF llFindRow = 0 THEN
				ldsReport.setItem(llNewRow,'po_line', ldsBOM.getItemNumber( llBOMFind, 'Child_Line_Item_No'))
				llBOMFind =0
			ELSE
				llBOMFind = ldsBOM.find( "SKU_Child='"+lsSKU+"'", llBOMFind+1, ldsBOM.rowcount()+1)
			END IF
		LOOP

	ELSE
		ldsReport.setItem(llNewRow,'po_line',llLineItem)
	END IF

	
	lsPhilipsInvType = getPhilipsInvType(w_do.idw_pick.getItemString(llRowPos,'inventory_type'))

	//3. PlantCode =MY01 & For Hard Bundle where Order Detail.User Field 5 is PIC and UF 6 is not 000, do not print the Storage location, Qty and UOM.
	IF Pos(lsPlant, 'MY') > 0 and lbHardBundle THEN
		ldsReport.setItem(llNewRow,'uom', '')
		ldsReport.setItem(llNewRow,'inventory_desc', '')
		ldsReport.setItem(llNewRow,'quantity', 0)
	ELSE
		ldsReport.setItem(llNewRow,'uom', 'PCE')
		ldsReport.setItem(llNewRow,'inventory_desc',lsPhilipsInvType)
		ldsReport.setItem(llNewRow,'quantity',w_do.idw_pick.getItemNumber(llRowPos,'quantity'))
	END IF

	ldsReport.setItem(llNewRow,'inventory_type',w_do.idw_pick.getItemString(llRowPos,'inventory_type'))
	ldsReport.setItem(llNewRow,'plant_Code',lsPlant) /*plant code used to determine which logo to display*/
		
	//Plant/Invoice From & Company Registration
	Choose Case Upper(w_do.idw_main.getItemString(1,'User_Field3'))

		Case "SG01"
			ldsReport.setItem(llNewRow,'company_registration','199705989C')
			ldsReport.setItem(llNewRow,'plant_invoice_From','SG01 / 830144')				

		Case "SG02"
			ldsReport.setItem(llNewRow,'company_registration','199705989C')
			ldsReport.setItem(llNewRow,'plant_invoice_From','SG02 / 830386')
			
		Case "SG03"
			ldsReport.setItem(llNewRow,'company_registration','199705989C')
			ldsReport.setItem(llNewRow,'plant_invoice_From','SG03 / 832889')
			
		Case "MY01"
			ldsReport.setItem(llNewRow,'company_registration','3690-P')
			ldsReport.setItem(llNewRow,'plant_invoice_From','MY01')	
			
	End Choose
	
	//Add Serial Number for Malaysia 
	//01-Apr-2013 :Madhu added Plant code is 2180
	If Pos(lsPlant ,'MY') > 0 or lsPlant ="2180" Then
		
		lsSerial = ''
		
		lsFind = "Line_Item_no = " + String(llLineItem) + " and Upper(SKU) = '" + Upper(lsSKU) + "' and upper(Inventory_Type) = '" + Upper(lsInvType) + "'"
		llFind = ldsSerial.Find(lsFind,1,ldsSerial.RowCount())
		
		Do While llFind > 0
			
			lsSerial += ldsSerial.getItemString(llFind,'serial_no') + ", "

			llFind ++
			If llFind > ldsSerial.RowCount() Then
				llFind = 0
			Else
				llFind = ldsSerial.Find(lsFind,llFind,ldsSerial.RowCount())
			End If
			
		Loop
		
		lsSerial = Left(lsSerial,(len(lsSerial) - 2)) /*Strip off last comma */
		ldsReport.setItem(llNewRow,'serial_no',lsSerial)
		
	End If /*Malaysia*/
	
	//4. Add NONPIC records for Malaysia
	IF lbHardBundle THEN
		lsFind = "User_Field5='NONPIC' and User_Field6='"+ls_dd_uf6+"'"
		llDetailFind = w_do.idw_detail.find(lsFind, 1, w_do.idw_detail.rowcount())
		
		DO WHILE llDetailFind > 0
			ldsReport.rowscopy( ldsReport.rowcount( ), ldsReport.rowcount( ) , Primary!, ldsReport, ldsReport.rowcount( ) +1, Primary!)
			llNewDetailRow = ldsReport.rowcount( )

			lsSKU = w_do.idw_detail.getItemString(llDetailFind, 'sku')
			lsSupplier = w_do.idw_detail.getItemString(llDetailFind, 'supp_code')
			ls_dd_uf1 = w_do.idw_detail.getItemString(llDetailFind, 'User_Field1')
			
			select description, user_field8, user_field9,  weight_1  into	:lsDesc, :lsUF8, :lsUF9, :ldNetWEight
			from Item_Master with(nolock)
			where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
			
			ls_new_sku = this.remove_leading_zeros( lsSKU)
			ldsReport.setItem(llNewDetailRow,'sku', ls_new_sku)
			ldsReport.setItem(llNewDetailRow,'supp_code',lsSupplier)
			ldsReport.setItem(llNewDetailRow,'description', lsDesc)	
			ldsReport.setItem(llNewDetailRow,'alt_Sku',ls_dd_uf1)
			ldsReport.setItem(llNewDetailRow,'customer_material_no',ls_dd_uf1)
			ldsReport.setItem(llNewDetailRow,'po_line', w_do.idw_detail.getItemNumber(llDetailFind, 'Line_Item_No'))
			ldsReport.setItem(llNewDetailRow,'uom', 'PCE')
			ldsReport.setItem(llNewDetailRow,'inventory_desc', lsPhilipsInvType)
			ldsReport.setItem(llNewDetailRow,'quantity',w_do.idw_detail.getItemNumber(llDetailFind,'req_qty'))
			
			//Weight
			If isnull(ldNetWeight) Then ldNetWeight = 0
			ldsReport.setItem(llNewDetailRow, 'net_weight', ldNetWeight)
			
			//Volume
			If isnumber(lsUF8) Then
				ldsReport.setItem(llNewDetailRow,'net_volume',Dec(lsUF8))
			Else
				ldsReport.setItem(llNewDetailRow,'net_volume', 0)
			End If

			llDetailFind = w_do.idw_detail.find(lsFind, llDetailFind+1, w_do.idw_detail.rowcount()+1)
		LOOP
		
	END IF
	
Next /*Picking Row */

//5. Reset values of SoftBundle -Malaysia
IF Pos(lsPlant, 'MY') > 0 THEN
	
	//apply filter
	lsFilter = "User_Field6 <> '000' "
	w_do.idw_detail.setfilter(lsFilter)
	w_do.idw_detail.filter()
	//IF w_do.idw_detail.rowcount() = 0 THEN Continue
	
	FOR llRowPos =1 to w_do.idw_detail.rowcount()
		
		ls_dd_uf5 = w_do.idw_detail.getItemString(llRowPos, 'User_Field5')
		ls_dd_uf6 = w_do.idw_detail.getItemString(llRowPos, 'User_Field6')
		
		IF ls_dd_uf5 ='NONPIC' THEN
			
			//Look for PIC with same UF6 value
			lsFind = "User_Field5='PIC' and User_Field6='"+ls_dd_uf6+"'"
			llDetailFind = w_do.idw_detail.find(lsFind, 1, w_do.idw_detail.rowcount())
			
			IF llDetailFind = 0 THEN
				//Soft Bundle
		
				lsSKU = w_do.idw_detail.getItemString(llRowPos, 'sku')
				ls_new_sku = this.remove_leading_zeros( lsSKU)
				
				lsFind ="SKU ='"+ls_new_sku+"' and po_line ="+String( w_do.idw_detail.getItemNumber( llRowPos, 'Line_Item_No'))
				llFindRow = ldsReport.find( lsFind, 1, ldsReport.rowcount( )+1)

				IF llFindRow > 0 THEN
					//reset values
					ldsReport.setItem(llFindRow,'uom', '')
					ldsReport.setItem(llFindRow,'inventory_desc', '')
					ldsReport.setItem(llFindRow,'quantity', 0)
					ldsReport.setItem(llFindRow, 'net_weight', 0)
					ldsReport.setItem(llFindRow,'net_volume', 0)
				END IF
			END IF //Detail Find =0
		END IF //UF5 =NONPIC
	NEXT
	
	//clear filter
	w_do.idw_detail.setfilter("")
	w_do.idw_detail.filter()
END IF


//Calculate Gross Volume and Gross Weight
ldGrossWEight = 0
ldGrossVolume = 0

llRowCount = ldsReport.RowCount()
For llRowPos = 1 to llRowCount
	
	ldGrossWeight += ldsReport.getItemDecimal(llRowPos,'net_weight') * ldsReport.getItemDecimal(llRowPos,'quantity')
	ldGrossVolume += ldsReport.getItemDecimal(llRowPos,'net_volume') * ldsReport.getItemDecimal(llRowPos,'quantity')
	
Next

ldsReport.Modify("gross_Weight_t.text='" + String(ldGrossWeight,"#########.0000") + " KG'")
ldsReport.Modify("total_volume_t.text='" + String(ldGrossVolume,"#########.0000") + " CDM'")

ldsReport.SetSort("po_line A")
ldsReport.Sort()

// check print count before printing and prompt if already printed
lsDONO = w_do.idw_main.getItemString(1,'do_no') 

Select Delivery_Note_Print_Count into :llCount
From Delivery_Master with(nolock)
Where do_no = :lsDONO;
	
If isnull(llCount) Then llCount = 0
	
If llCount > 0 Then
	If Messagebox("Print DELIVERY Note","Order: " + w_do.idw_main.getItemString(1,'invoice_no') + ", This DELIVERY Note has already been printed. Do you want to continue?",Stopsign!,yesNo!,2) = 2 Then
		Return 0
	End If
End If

//Only show print dialog if first/only one bieng printed, otherwise print to default
if ibShowPrintDialog Then
	OpenWithParm(w_dw_print_options,ldsReport) 
	iiCopies = integer(ldsReport.describe('datawindow.print.Copies'))
else
	ldsReport.modify(" datawindow.print.copies = " + String(iiCopies))
	Print(ldsReport)
	message.DoubleParm = 1
End If

If message.doubleparm = 1 then
	llCount ++
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Delivery_Master
	Set Delivery_Note_Print_Count = :llCount
	Where do_no = :lsDONO;
		
	Execute Immediate "COMMIT" using SQLCA;
	
End If

SetPointer(arrow!)

destroy ldsNotes
destroy ldsSoldToAddress 
destroy ldsBillToAddress
destroy ldsserial
destroy ldsReport
destroy ldsBOM

Return 0

*/
end function

public function string remove_leading_zeros (string as_sku);//25-APR-2019 :Madhu DE10196 Philps BlueHeart Soft Bundle Hard Bundle Items
//Remove leading 0s.

DO
	IF left(as_sku, 1) = "0" THEN as_sku = mid(as_sku, 2)
LOOP UNTIL left(as_sku, 1) <> "0"

Return as_sku
end function

public function integer uf_process_dn_philipscls (datastore idsmain, datastore idsdetail, datastore idspick, datastore idspack, boolean ibshowprintdialog);//15-APR-2019 :Madhu S32302 PhilipsCLS Delivery Note
//25-APR-2019 :Madhu DE10196 PhilipsCLS Delivery Note
//07-MAY-2019 :Madhu S33197 PhilipsCLS Delivery Note
//17-MAY-2019 :Madhu S33803 PhilipsCLS Delivery Note

//TAM 2019/07/10 DE11587 - Customize batch delivery notes for PjilipsCLS

String	lsWarehouse,  lsSKU, lsSupplier, lsAltSku, lsDONO, lsDesc, lsInvType, lsPONO, lsPlant, lsSerial
String	lsFind, lsUF8, lsUF9, lsUOM, lsPhilipsInvType ,ls_whcode, lsType, ls_cust_purchase_order
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText, ls_dd_uf1, ls_dd_uf5
String lsSuppName, lsSuppAddress_1, lsSuppAddress_2, lsSuppAddress_3, lsSuppAddress_4
String lsSuppCity, lsSuppState, lsSuppCountry, lsSuppZip, ls_Cust_Ord_No, ls_buyer_code, ls_new_sku
String ls_dm_uf20, ls_uf20, ls_dd_uf6, lsFilter, ls_uf19, ls_uf21, ls_uf22

Long	llRowCount, llRowPos, llNewRow, llFind, llLIneItem, llDetailFind, llBOMFind, llFindRow, llNewDetailRow, llChildLineItem //S35817

Int	 liNotePos, llCount

Decimal {4} ldGrossWeight, ldNetWeight, ldNetVolume, ldGrossVolume

//boolean ibShowPrintDialog =true
boolean lbHardBundle =FALSE

DataStore	ldsNotes, ldsSoldToAddress, ldsBillToAddress,  ldsserial, ldsReport, ldsBOM

SetPointer(Hourglass!)

//Pack list must be generated
If idsPack.RowCount() = 0 Then
	Messagebox(w_do.is_Title,"Order: " + idsMain.GetITemString(1,'invoice_no') + ', You must generate the Pack List before you can print the Delivery Note!')
	Return -1
End If


ldsReport = Create Datastore
ldsReport.dataobject = 'd_philips_cls_delivery_note'

lsWarehouse = idsMain.getItemString(1,'wh_Code')
lsDoNO = idsMain.getItemString(1,'do_no')
lsPlant = idsMain.getItemString(1,'User_Field3')
ls_Cust_Ord_No = idsMain.getItemString(1,'cust_order_no')
ls_buyer_code = idsMain.getItemString(1, 'User_Field2')

ls_cust_purchase_order= idsdetail.getItemString(1, 'User_Field2')
	
ldsSoldToAddress = Create DataStore
ldsSoldToAddress.dataObject = 'd_do_address_alt'
ldsSoldToAddress.SetTransObject(sqlca)
	
ldsSoldToAddress.Retrieve(lsdono, 'ST') /*Sold To Address*/

ldsBillToAddress = Create DataStore
ldsBillToAddress.dataObject = 'd_do_address_alt'
ldsBillToAddress.SetTransObject(sqlca)

ldsBillToAddress.Retrieve(lsdono, 'BT') /*Bill To Address*/

//Delivery Notes
ldsNotes = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select Note_seq_No, Note_Text, Line_Item_No from Delivery_Notes  with(nolock) Where do_no = '" + lsDoNO + "'"
dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsNotes.Create( dwsyntax_str, lsErrText)
ldsNotes.SetTransObject(SQLCA)

ldsNotes.Retrieve()
ldsNotes.SetSort("Line_Item_No A, Note_Seq_No A")
ldsNotes.Sort()

//Delivery BOM
ldsBOM = Create Datastore
lsSql = " Select * From Delivery_BOM with(nolock) where Project_Id ='"+gs_project+"' and Do_No ='"+lsDoNO+"'"
ldsBOM.create( SQLCA.syntaxfromsql( lsSql, "", lsErrText))
ldsBOM.SetTransObject( SQLCA)
ldsBOM.retrieve( )
	
//For Malaysia Plant code (MY10) or (MYQ0), we want to print Serial Numbers -
If Pos(lsPlant, 'MY') > 0 or lsPlant ="2180" Then
	ldsSerial = Create Datastore
	presentation_str = "style(type=grid)"

	lsSQl = " Select Delivery_serial_detail.Serial_No, Delivery_serial_detail.Quantity, "
	lsSQL += " Delivery_Picking_Detail.Line_Item_No, Delivery_Picking_Detail.SKU, Delivery_Picking_Detail.Supp_Code, Delivery_Picking_Detail.Inventory_Type "
	lsSQL += " From Delivery_Picking_Detail with(nolock), Delivery_Serial_Detail with(nolock) "
	lsSQL += " Where Delivery_Picking_Detail.ID_NO = Delivery_Serial_Detail.ID_NO "
	lsSQL += " and Delivery_Picking_Detail.do_no = '" + lsDONO + "'"


	dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
	ldsSerial.Create( dwsyntax_str, lsErrText)
	ldsSerial.SetTransobject(sqlca)
	ldsSerial.Retrieve()
End If

ldsReport.reset()

llRowCount = idspick.RowCount()
For llRowPos = 1 to llRowCount

	lsSKU = idspick.getItemString(llRowPos,'sku')
	lsSupplier =idspick.getItemString(llRowPos,'supp_Code')
	lsInvType = idspick.getItemString(llRowPos,'inventory_Type')
	llLineItem = idspick.GetItemNumber(llRowPos,'Line_Item_No')
		
	If idspick.GetITemNumber(llRowPos,'quantity') = 0 Then Continue
	
	ls_new_sku =this.remove_leading_zeros( lsSKU) //Remove leading zero's
	
//TAM -  2019/07/16 - S35817 -  Moved from below because we need to know if pickrow is a hard bundle for QTY update - Start
	setNull(ls_dd_uf5)
	llDetailFind = idsdetail.Find("sku ='"+lsSKU+"' and Line_Item_No = " + String(llLineItem),1,idsdetail.RowCount())
	
	IF llDetailFind > 0 THEN 
		ls_dd_uf5 = idsdetail.getItemString(llDetailFind, 'User_Field5')
		If Isnull(ls_dd_uf5) then ls_dd_uf5 = ""
		ls_dd_uf6 = idsdetail.getItemString(llDetailFind, 'User_Field6')
		If Isnull(ls_dd_uf6) then ls_dd_uf6 = ""
	END IF
	
	IF Pos(lsPlant, 'MY') = 0 and upper(ls_dd_uf5) ='NONPIC' THEN Continue //1. don't display NONPIC SKU's & Plant <> 'MY' on Delivery Note.
	
	lbHardBundle = FALSE //reset value
	//dts, 2019/08/16 - S36861/F17956; Philips changed their 'Bundle' code from '000' to '000000' (when the sku is not part of a bundle).
	//IF Pos(lsPlant, 'MY') > 0 and Upper(ls_dd_uf5) ='PIC' and ls_dd_uf6 <> '000' THEN lbHardBundle =TRUE //2. Determine HardBundle
	IF Pos(lsPlant, 'MY') > 0 and Upper(ls_dd_uf5) ='PIC' and ls_dd_uf6 <> '000' and ls_dd_uf6 <> '000000' THEN lbHardBundle =TRUE //2. Determine HardBundle
//TAM -  2019/07/16 - S35817 - Moved from below because we need to know if pickrow is a hard bundle for QTY update - End

	
	//Roll Up To To Line/SKU/Inventory Type

//TAM 2019/07/15 S35817 - Rollup Child notes as well (*note llLineItem is the Parent Line Number.  llChildLineItem comes from the BOM and is set Below)
//	lsFind = "po_line = " + String(llLineItem) + " and SKU = '" + ls_new_sku + "' and Inventory_Type = '" + lsInvType + "'"
	lsFind = "(po_line = " + String(llLineItem) + "or po_line = " + String(llChildLineItem) + ") and SKU = '" + ls_new_sku + "' and Inventory_Type = '" + lsInvType + "' and dd_uf_5 = '"+ls_dd_uf5+"'"
	
	
		
	llFind = ldsReport.Find(lsFind,1,ldsReport.RowCount())
	
	//GailM 10/10/2019 DE12671 PhilipsBH DN incorrectly consolidate child and normal SKU Qty - add check for ls_dd_uf5 (skip PIC)
	If llFind > 0  Then // and isNull(ls_dd_uf5) Then
		//TAM -  2019/07/16 - S35817 - Dont print QTY on HardBundles
		If lbHardBundle = False Then
			ldsReport.setItem(llFind,'quantity',ldsReport.GetITemNumber(llFind,'quantity') + idspick.GetITemNumber(lLRowPOs,'quantity')) /*add to existing Row*/
		End If
		Continue
	End If
	
	//Insert a new report Row
	llNewRow = ldsReport.InsertRow(0)
	ldsReport.setItem(llNewRow,'project_id', gs_project )
	
	//Header Notes (up to 4 rows)
	liNotePos = 0
	llFind = ldsNotes.Find("Line_Item_No = 0",1,ldsNotes.RowCount()) /* line_item = 0 for header Notes*/
	Do While llFind > 0
		liNotePos ++
		lsNotePos = "header_remarks" + String(liNotePos)
		
		//Print Note_Text
		IF Pos(lsPlant ,'MY') > 0 and Pos(ldsNotes.getItemString(llFind,"note_Text"), 'ORD-508' ) > 0 THEN
			ldsReport.setItem(llNewRow,lsNotePos, ldsNotes.getItemString(llFind,"note_Text"))
		ELSEIF Pos(lsPlant ,'MY') = 0 THEN
			ldsReport.setItem(llNewRow,lsNotePos, ldsNotes.getItemString(llFind,"note_Text"))
		END IF
		
		llFind ++
		If llFind > ldsNotes.RowCount() or liNotePos = 10 Then 
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
		lsNoteText += ldsNotes.getItemString(llFind,"note_Text") + " "
				
		llFind ++
		If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
			llFind = 0
		Else
			llFind = ldsNotes.Find("Line_Item_No = " + string(llLineItem),llFind,ldsNotes.RowCount())
		End If
	Loop
	
	select supp_name, address_1, address_2, address_3, address_4, city, state, country, zip 
	into :lsSuppName,:lsSuppAddress_1, :lsSuppAddress_2, :lsSuppAddress_3, :lsSuppAddress_4,
		:lsSuppCity, :lsSuppState, :lsSuppCountry, :lsSuppZip
	from Supplier with(nolock)
	where Project_id = :gs_project and supp_code = :lsSupplier;
	
	//Ship From Address
	ldsReport.setItem(llNewRow,'ship_from_name', lsSuppName )
	ldsReport.setItem(llNewRow,"ship_from_addr1", lsSuppAddress_1)
	ldsReport.setItem(llNewRow,"ship_from_addr2", lsSuppAddress_2 )
	ldsReport.setItem(llNewRow,"ship_from_addr3", lsSuppAddress_3)
	ldsReport.setItem(llNewRow,"ship_from_addr4", lsSuppAddress_4)
	ldsReport.setItem(llNewRow,"ship_from_city", lsSuppCity)
	ldsReport.setItem(llNewRow,"ship_from_state", lsSuppState)
	ldsReport.setItem(llNewRow,"ship_from_country", lsSuppCountry )
	ldsReport.setItem(llNewRow,"ship_from_zip", lsSuppZip )
	
	ldsReport.setItem(llNewRow,'do_number', idsmain.getItemString(1,'invoice_no'))
	ldsReport.setItem(llNewRow,'route', '')
	
	//DO_Type
	If Pos(lsPlant,'MY') > 0 or lsPlant = "2180" Then /*No DO Type for Malaysia */
	else
		If Upper(idsmain.getItemString(1,'country')) <> 'SG' and idsmain.getItemString(1,'country') <> 'SINGAPORE' Then
			ldsReport.setItem(llNewRow,'DO_TYPE','Export')
		Elseif Upper(idsmain.getItemString(1,'USer_Field2')) = 'SG9999' Then
			ldsReport.setItem(llNewRow,'DO_TYPE','Self Collection')
		Elseif Upper(idsmain.getItemString(1,'USer_Field2')) = 'SGM9' Then
			ldsReport.setItem(llNewRow,'DO_TYPE','STO')
		Else
			ldsReport.setItem(llNewRow,'DO_TYPE','Normal Delivery')
		End If
	End If
	
	ldsReport.setItem(llNewRow,'DO_receipt_dateTime',idsmain.getItemDateTime(1,'ord_date'))
	
	ls_uf19 = idsmain.getItemString(1,'User_Field19') //User Field19
	ls_uf20 = idsmain.getItemString(1,'User_Field20') //User Field20
	ls_uf21 = idsmain.getItemString(1,'User_Field21') //User Field21
	ls_uf22 = idsmain.getItemString(1,'User_Field22') //User Field22
	
	IF len(ls_uf20) = 8 THEN //Ex:-20190427
		ls_dm_uf20 = right(ls_uf20,2)+'.'+mid(ls_uf20,5,2)+'.'+left(ls_uf20,4) //dd.mm.yyyy
		ldsReport.setItem(llNewRow,'dm_uf_20', ls_dm_uf20)
	ELSE
		ldsReport.setItem(llNewRow,'dm_uf_20', ls_uf20)
	END IF
	
	IF Pos(lsPlant,'MY') > 0 THEN
		ldsReport.setItem(llNewRow,'dm_uf_19', ls_uf19)
		ldsReport.setItem(llNewRow,'dm_uf_21', ls_uf21)
		ldsReport.setItem(llNewRow,'dm_uf_22', ls_uf22)
	END IF
	
	//Ship To Address
	ldsReport.setItem(llNewRow,'ship_to_code',idsmain.getItemString(1,'cust_code'))
	ldsReport.setItem(llNewRow,'ship_to_name',idsmain.getItemString(1,'cust_Name'))
	ldsReport.setItem(llNewRow,'ship_to_addr1',idsmain.getItemString(1,'address_1'))
	ldsReport.setItem(llNewRow,'ship_to_addr2',idsmain.getItemString(1,'address_2'))
	ldsReport.setItem(llNewRow,'ship_to_addr3',idsmain.getItemString(1,'address_3'))
	ldsReport.setItem(llNewRow,'ship_to_addr4',idsmain.getItemString(1,'address_4'))
	ldsReport.setItem(llNewRow,'ship_to_city',idsmain.getItemString(1,'city'))
	ldsReport.setItem(llNewRow,'ship_to_state',idsmain.getItemString(1,'state'))
	ldsReport.setItem(llNewRow,'ship_to_zip',idsmain.getItemString(1,'zip'))
	ldsReport.setItem(llNewRow,'ship_to_country',idsmain.getItemString(1,'country'))
	ldsReport.setItem(llNewRow,'ship_to_contact',idsmain.getItemString(1,'contact_person'))
	ldsReport.setItem(llNewRow,'ship_to_tel',idsmain.getItemString(1,'tel'))
	
	//Sold To Address
	If ldsSoldToAddress.RowCount() > 0 Then
		ldsReport.setItem(llNewRow,'sold_to_name', ldsSoldToAddress.getItemString(1,'name'))
		ldsReport.setItem(llNewRow,"sold_to_addr1", ldsSoldToAddress.getItemString(1,'address_1'))
		ldsReport.setItem(llNewRow,"sold_to_addr2", ldsSoldToAddress.getItemString(1,'address_2'))
		ldsReport.setItem(llNewRow,"sold_to_addr3", ldsSoldToAddress.getItemString(1,'address_3'))
		ldsReport.setItem(llNewRow,"sold_to_addr4", ldsSoldToAddress.getItemString(1,'address_4'))
		ldsReport.setItem(llNewRow,"sold_to_district", ldsSoldToAddress.getItemString(1,'district'))
		ldsReport.setItem(llNewRow,"sold_to_city", ldsSoldToAddress.getItemString(1,'city'))
		ldsReport.setItem(llNewRow,"sold_to_state", ldsSoldToAddress.getItemString(1,'state'))
		ldsReport.setItem(llNewRow,"sold_to_zip", ldsSoldToAddress.getItemString(1,'zip'))
		ldsReport.setItem(llNewRow,"sold_to_country", ldsSoldToAddress.getItemString(1,'country'))
	End If
	
	//Bill To Address
	If ldsBillToAddress.RowCount() > 0 Then
		ldsReport.setItem(llNewRow,'bill_to_name', ldsBillToAddress.getItemString(1, 'name'))
		ldsReport.setItem(llNewRow,"bill_to_addr1", ldsBillToAddress.getItemString(1,'address_1'))
		ldsReport.setItem(llNewRow,"bill_to_addr2", ldsBillToAddress.getItemString(1,'address_2'))
		ldsReport.setItem(llNewRow,"bill_to_addr3", ldsBillToAddress.getItemString(1,'address_3'))
		ldsReport.setItem(llNewRow,"bill_to_addr4", ldsBillToAddress.getItemString(1,'address_4'))
		ldsReport.setItem(llNewRow,"bill_to_district", ldsBillToAddress.getItemString(1,'district'))
		ldsReport.setItem(llNewRow,"bill_to_city", ldsBillToAddress.getItemString(1,'city'))
		ldsReport.setItem(llNewRow,"bill_to_state", ldsBillToAddress.getItemString(1,'state'))
		ldsReport.setItem(llNewRow,"bill_to_zip", ldsBillToAddress.getItemString(1,'zip'))
		ldsReport.setItem(llNewRow,"bill_to_country", ldsBillToAddress.getItemString(1,'country'))
	End If
	
	IF llDetailFind > 0 THEN
		ls_dd_uf1 = idsdetail.getItemString(llDetailFind, 'User_Field1')
	END IF
	
	select description, user_field8, user_field9,  weight_1  into	:lsDesc, :lsUF8, :lsUF9, :ldNetWEight
	from Item_Master with(nolock)
	where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
		
	if sqlca.sqlcode <> 0 then
		MessageBox ("DB Error", SQLCA.SQLErrText )
	end if
	
	//Weight
	If isnull(ldNetWeight)Then ldNetWeight = 0
	ldsReport.setItem(llNewRow,'net_weight',ldNetWEight)
	
	//Volume
	If isnumber(lsUF8) Then
		ldsReport.setItem(llNewRow,'net_volume',Dec(lsUF8))
	Else
		ldsReport.setItem(llNewRow,'net_volume',0)
	End If

	ldsReport.setItem(llNewRow,'sku', ls_new_sku)
	ldsReport.setItem(llNewRow,'supp_code',lsSupplier)
	ldsReport.setItem(llNewRow,'description', lsDesc)	
	ldsReport.setItem(llNewRow,'alt_Sku',ls_dd_uf1)
	ldsReport.setItem(llNewRow,'customer_material_no',ls_dd_uf1)	
	ldsReport.setItem(llNewRow,'po_nbr', ls_cust_purchase_order) 
	ldsReport.setItem(llNewRow,'buyer_code', ls_buyer_code) 	
	
	ldsReport.setItem(llNewRow,'dd_uf_5', ls_dd_uf5)
	
//	ldsReport.setItem(llNewRow,'po_line',llLineItem)
	
	//Find child SKU on Delivery BOM
	llBOMFind = ldsBOM.find( "SKU_Child='"+lsSKU+"' and Line_Item_No = " + String(llLineItem), 1, ldsBOM.rowcount())
	
	IF llBOMFind > 0 THEN
		
		DO WHILE llBOMFind > 0
			//don't assing duplicate child_line_item_no, if already present
			lsFind ="SKU ='"+ls_new_sku+"' and po_line ="+String(ldsBOM.getItemNumber( llBOMFind, 'Child_Line_Item_No'))  + " and Inventory_Type = '" + lsInvType + "'"
			llFindRow = ldsReport.find( lsFind, 1, ldsReport.rowcount( )+1)
			
			IF llFindRow = 0 THEN
				ldsReport.setItem(llNewRow,'po_line', ldsBOM.getItemNumber( llBOMFind, 'Child_Line_Item_No'))
			//TAM 2019/07/15 S35817 - Need The Child Line Number to check if it is already writen to the report as well
				llChildLineItem = ldsBOM.getItemNumber( llBOMFind, 'Child_Line_Item_No')
				llBOMFind =0
			ELSE
				//Here
				ldsReport.setItem(llFindRow,'quantity',ldsReport.GetITemNumber(llFindRow,'quantity') + idspick.GetITemNumber(lLRowPOs,'quantity')) /*add to existing Row*/		
				llBOMFind = 0 // ldsBOM.find( "SKU_Child='"+lsSKU+"'", llBOMFind+1, ldsBOM.rowcount()+1)
				ldsReport.DeleteRow(llNewRow)
				Continue 
			END IF
		LOOP

	ELSE
		ldsReport.setItem(llNewRow,'po_line',llLineItem)
	END IF


//	//GailM 10/10/2019 DE12671 PhilipsBH DN incorrectly consolidate child and normal SKU Qty - NonBundle - NonChild set po_line
//	If ls_dd_uf5 = 'PIC' Then
//		ldsReport.setItem(llNewRow,'po_line',llLineItem)
//	End If	
	
	lsPhilipsInvType = getPhilipsInvType(idspick.getItemString(llRowPos,'inventory_type'))

	//3. PlantCode =MY01 & For Hard Bundle where Order Detail.User Field 5 is PIC and UF 6 is not 000, do not print the Storage location, Qty and UOM.
	IF Pos(lsPlant, 'MY') > 0 and lbHardBundle THEN
		ldsReport.setItem(llNewRow,'uom', '')
		ldsReport.setItem(llNewRow,'inventory_desc', '')
		ldsReport.setItem(llNewRow,'quantity', 0)
	ELSE
		ldsReport.setItem(llNewRow,'uom', 'PCE')
		ldsReport.setItem(llNewRow,'inventory_desc',lsPhilipsInvType)
		ldsReport.setItem(llNewRow,'quantity',idspick.getItemNumber(llRowPos,'quantity'))
	END IF

	ldsReport.setItem(llNewRow,'inventory_type',idspick.getItemString(llRowPos,'inventory_type'))
	ldsReport.setItem(llNewRow,'plant_Code',lsPlant) /*plant code used to determine which logo to display*/
		
	//Plant/Invoice From & Company Registration
	//dts - 12/02/2020 - S51441 (cont'd) - Need to vary company_registration based on Project (PHILIPSCLS vs PHILIPS-DA)
	//    - also, moving the setting of company_registration for SG* above the 'Case' statement since it is the same (it will be overwritten for Case MY01)
   //  dts - 28/04/2021 Changes for the Story S56161-Philips-DA by Dhirendra  -Start
	if gs_Project = 'PHILIPSCLS' then
		ldsReport.setItem(llNewRow,'company_registration','199705989C')
		ldsReport.setItem(llNewRow,'plant_invoice_From','SG01 / 830144')				
	else //PHILIPS-DA
		ldsReport.setItem(llNewRow,'company_registration','202018548H')
		ldsReport.setItem(llNewRow,'plant_invoice_From','SG01 / 837812')				
	end if
	//ldsReport.setItem(llNewRow,'plant_invoice_From','SG01 / 830144')				
	Choose Case Upper(idsmain.getItemString(1,'User_Field3'))

		Case "SG01"
			if gs_Project = 'PHILIPS-DA' then
			//dts - 12/02/2020 - S51441 (cont'd) ldsReport.setItem(llNewRow,'company_registration','199705989C')
			ldsReport.setItem(llNewRow,'plant_invoice_From','SG01 / 837812')	
				else 
					ldsReport.setItem(llNewRow,'plant_invoice_From','SG01 / 830144')
				end if 

		Case "SG02"
			if gs_Project = 'PHILIPS-DA' then
			//dts - 12/02/2020 - S51441 (cont'd) ldsReport.setItem(llNewRow,'company_registration','199705989C')
			ldsReport.setItem(llNewRow,'plant_invoice_From','SG02 / 837813')
		else 
			ldsReport.setItem(llNewRow,'plant_invoice_From','SG02 / 830386')
		end if 
			
		Case "SG03"
			if gs_Project = 'PHILIPS-DA' then
			//dts - 12/02/2020 - S51441 (cont'd) ldsReport.setItem(llNewRow,'company_registration','199705989C')
			ldsReport.setItem(llNewRow,'plant_invoice_From','SG03 / 837814')
		else 
			ldsReport.setItem(llNewRow,'plant_invoice_From','SG03 / 832889')
		end if
		 //  dts - 28/04/2021 Changes for the Story S56161-Philips-DA by Dhirendra  -End

		Case "MY01"
			//dts - 12/02/2020 - S51441 (cont'd) - Need to vary company_registration based on Project (PHILIPSCLS vs PHILIPS-DA)
			if gs_Project = 'PHILIPSCLS' then
				ldsReport.setItem(llNewRow,'company_registration','3690-P')
			else //PHILIPS-DA
				ldsReport.setItem(llNewRow,'company_registration','1372363-D')
			end if
			ldsReport.setItem(llNewRow,'plant_invoice_From','MY01')	
			
	End Choose
	
	//Add Serial Number for Malaysia 
	//01-Apr-2013 :Madhu added Plant code is 2180
	If Pos(lsPlant ,'MY') > 0 or lsPlant ="2180" Then
		
		lsSerial = ''
		
		lsFind = "Line_Item_no = " + String(llLineItem) + " and Upper(SKU) = '" + Upper(lsSKU) + "' and upper(Inventory_Type) = '" + Upper(lsInvType) + "'"
		llFind = ldsSerial.Find(lsFind,1,ldsSerial.RowCount())
		
		Do While llFind > 0
			
			lsSerial += ldsSerial.getItemString(llFind,'serial_no') + ", "

			llFind ++
			If llFind > ldsSerial.RowCount() Then
				llFind = 0
			Else
				llFind = ldsSerial.Find(lsFind,llFind,ldsSerial.RowCount())
			End If
			
		Loop
		
		lsSerial = Left(lsSerial,(len(lsSerial) - 2)) /*Strip off last comma */
		ldsReport.setItem(llNewRow,'serial_no',lsSerial)
		
	End If /*Malaysia*/
	
	//4. Add NONPIC records for Malaysia
	IF lbHardBundle THEN
		lsFind = "User_Field5='NONPIC' and User_Field6='"+ls_dd_uf6+"'"
		llDetailFind = idsdetail.find(lsFind, 1, idsdetail.rowcount())
		
		DO WHILE llDetailFind > 0
			ldsReport.rowscopy( ldsReport.rowcount( ), ldsReport.rowcount( ) , Primary!, ldsReport, ldsReport.rowcount( ) +1, Primary!)
			llNewDetailRow = ldsReport.rowcount( )

			lsSKU = idsdetail.getItemString(llDetailFind, 'sku')
			lsSupplier = idsdetail.getItemString(llDetailFind, 'supp_code')
			ls_dd_uf1 = idsdetail.getItemString(llDetailFind, 'User_Field1')
			
			select description, user_field8, user_field9,  weight_1  into	:lsDesc, :lsUF8, :lsUF9, :ldNetWEight
			from Item_Master with(nolock)
			where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
			
			ls_new_sku = this.remove_leading_zeros( lsSKU)
			ldsReport.setItem(llNewDetailRow,'sku', ls_new_sku)
			ldsReport.setItem(llNewDetailRow,'supp_code',lsSupplier)
			ldsReport.setItem(llNewDetailRow,'description', lsDesc)	
			ldsReport.setItem(llNewDetailRow,'alt_Sku',ls_dd_uf1)
			ldsReport.setItem(llNewDetailRow,'customer_material_no',ls_dd_uf1)
			ldsReport.setItem(llNewDetailRow,'po_line', idsdetail.getItemNumber(llDetailFind, 'Line_Item_No'))
			ldsReport.setItem(llNewDetailRow,'uom', 'PCE')
			ldsReport.setItem(llNewDetailRow,'inventory_desc', lsPhilipsInvType)
			ldsReport.setItem(llNewDetailRow,'quantity',idsdetail.getItemNumber(llDetailFind,'req_qty'))
			
			//Weight
			If isnull(ldNetWeight) Then ldNetWeight = 0
			ldsReport.setItem(llNewDetailRow, 'net_weight', ldNetWeight)
			
			//Volume
			If isnumber(lsUF8) Then
				ldsReport.setItem(llNewDetailRow,'net_volume',Dec(lsUF8))
			Else
				ldsReport.setItem(llNewDetailRow,'net_volume', 0)
			End If

			llDetailFind = idsdetail.find(lsFind, llDetailFind+1, idsdetail.rowcount()+1)
		LOOP
		
	END IF
	
Next /*Picking Row */

//5. Reset values of SoftBundle -Malaysia
IF Pos(lsPlant, 'MY') > 0 THEN
	
	//apply filter
	//dts, 2019/08/16 - S36861/F17956; Philips changed their 'Bundle' code from '000' to '000000' (when the sku is not part of a bundle).
	//lsFilter = "User_Field6 <> '000' "
	lsFilter = "User_Field6 <> '000' and User_Field6 <> '000000' "
	idsdetail.setfilter(lsFilter)
	idsdetail.filter()
	//IF idsdetail.rowcount() = 0 THEN Continue
	
	FOR llRowPos =1 to idsdetail.rowcount()
		
		ls_dd_uf5 = idsdetail.getItemString(llRowPos, 'User_Field5')
		ls_dd_uf6 = idsdetail.getItemString(llRowPos, 'User_Field6')
		
		IF ls_dd_uf5 ='NONPIC' THEN
			
			//Look for PIC with same UF6 value
			lsFind = "User_Field5='PIC' and User_Field6='"+ls_dd_uf6+"'"
			llDetailFind = idsdetail.find(lsFind, 1, idsdetail.rowcount())
			
			IF llDetailFind = 0 THEN
				//Soft Bundle
		
				lsSKU = idsdetail.getItemString(llRowPos, 'sku')
				ls_new_sku = this.remove_leading_zeros( lsSKU)
				
				lsFind ="SKU ='"+ls_new_sku+"' and po_line ="+String( idsdetail.getItemNumber( llRowPos, 'Line_Item_No'))
				llFindRow = ldsReport.find( lsFind, 1, ldsReport.rowcount( )+1)

				IF llFindRow > 0 THEN
					//reset values
					ldsReport.setItem(llFindRow,'uom', '')
					ldsReport.setItem(llFindRow,'inventory_desc', '')
					ldsReport.setItem(llFindRow,'quantity', 0)
					ldsReport.setItem(llFindRow, 'net_weight', 0)
					ldsReport.setItem(llFindRow,'net_volume', 0)
				END IF
			END IF //Detail Find =0
		END IF //UF5 =NONPIC
	NEXT
	
	//clear filter
	idsdetail.setfilter("")
	idsdetail.filter()
END IF


//Calculate Gross Volume and Gross Weight
ldGrossWEight = 0
ldGrossVolume = 0

llRowCount = ldsReport.RowCount()
For llRowPos = 1 to llRowCount
	
	ldGrossWeight += ldsReport.getItemDecimal(llRowPos,'net_weight') * ldsReport.getItemDecimal(llRowPos,'quantity')
	ldGrossVolume += ldsReport.getItemDecimal(llRowPos,'net_volume') * ldsReport.getItemDecimal(llRowPos,'quantity')
	
Next

ldsReport.Modify("gross_Weight_t.text='" + String(ldGrossWeight,"#########.0000") + " KG'")
ldsReport.Modify("total_volume_t.text='" + String(ldGrossVolume,"#########.0000") + " CDM'")

ldsReport.SetSort("po_line A")
ldsReport.Sort()

// check print count before printing and prompt if already printed
lsDONO = idsmain.getItemString(1,'do_no') 

Select Delivery_Note_Print_Count into :llCount
From Delivery_Master with(nolock)
Where do_no = :lsDONO;
	
If isnull(llCount) Then llCount = 0
	
If llCount > 0 Then
	If Messagebox("Print DELIVERY Note","Order: " + idsmain.getItemString(1,'invoice_no') + ", This DELIVERY Note has already been printed. Do you want to continue?",Stopsign!,yesNo!,2) = 2 Then
		Return 0
	End If
End If

//Only show print dialog if first/only one bieng printed, otherwise print to default
if ibShowPrintDialog Then
	OpenWithParm(w_dw_print_options,ldsReport) 
	iiCopies = integer(ldsReport.describe('datawindow.print.Copies'))
else
	ldsReport.modify(" datawindow.print.copies = " + String(iiCopies))
	Print(ldsReport)
	message.DoubleParm = 1
End If

If message.doubleparm = 1 then
	llCount ++
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Delivery_Master
	Set Delivery_Note_Print_Count = :llCount
	Where do_no = :lsDONO;
		
	Execute Immediate "COMMIT" using SQLCA;
	
End If

SetPointer(arrow!)

destroy ldsNotes
destroy ldsSoldToAddress 
destroy ldsBillToAddress
destroy ldsserial
destroy ldsReport
destroy ldsBOM

Return 0
end function

on u_nvo_process_dn.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_process_dn.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

