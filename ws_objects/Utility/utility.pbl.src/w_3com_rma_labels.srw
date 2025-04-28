$PBExportHeader$w_3com_rma_labels.srw
$PBExportComments$3COM RMA Labels
forward
global type w_3com_rma_labels from w_main_ancestor
end type
type cb_print from commandbutton within w_3com_rma_labels
end type
type dw_label from u_dw_ancestor within w_3com_rma_labels
end type
type cb_selectall from commandbutton within w_3com_rma_labels
end type
type cb_clear from commandbutton within w_3com_rma_labels
end type
type rb_inbound from radiobutton within w_3com_rma_labels
end type
type rb_outbound from radiobutton within w_3com_rma_labels
end type
type gb_1 from groupbox within w_3com_rma_labels
end type
end forward

global type w_3com_rma_labels from w_main_ancestor
boolean visible = false
integer width = 3026
integer height = 1844
string title = "Print 3COM RMA Labels"
string menuname = ""
event ue_print ( )
event ue_check_enable ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_clear cb_clear
rb_inbound rb_inbound
rb_outbound rb_outbound
gb_1 gb_1
end type
global w_3com_rma_labels w_3com_rma_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
	
String	isLabels[], isOEMLabel
Long	ilStartingBox


end variables

forward prototypes
public function integer uf_shipping_label (integer airow, string asformat)
public function string uf_set_from_address (string asformat)
public function string uf_set_to_address (string asformat)
public function integer wf_validate ()
public function string uf_new_pto_header (integer airow, string asformat, string ascarton, string asboxof)
end prototypes

event ue_print();Str_Parms	lstrparms
n_labels	lu_labels

Long	llRowCount, llRowPos, 	llPrintJob,  llLabelPos, llFindRow, llPrintPos, llPrintQty, llSoLineCOunt, llLInePos, llLineSize

String  lsPrintText, lsLabel,  lsCarton, lsLine,lsLineSave, lsLinePrint, lsLinePrintTemp, lsNullLabel[], lsFind, lsFormat, lsLineLit
String  lsRMAContractWarranty, lsAddress1, lsAddress2, lsAddress3, lsAddress4, lsAddress5, lsAddress6
String  lsRMA, lsCountry

String lsCOO

lu_labels = Create n_labels

Dw_Label.AcceptText()

isLabels = lsNullLabel /*clear any previous printed labels*/

//Retrieive necessary formats


//Print each detail Row
llRowCount = dw_label.RowCount()

IF rb_inbound.checked THEN

	//lsLabel = lu_labels.uf_read_label_Format("3com_rma_Zebra.txt")
	lsLabel = lu_labels.uf_read_label_Format("3com_rma_Zebra_gls.txt")
	

	
	For llRowPos = 1 to llRowCount /*each detail row */
				
		If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
		
		lsCOO = Trim(Upper(dw_Label.GetITemString(llRowPos,'coo')))
	
		IF IsNull(lsCOO) OR lsCOO = 'XXX' OR lsCOO = '' THEN
			
			
			Messagebox ("Invalid COO", "COO cannot be 'XXX' or emply.")
			
			RETURN  
			
		END IF
	
	NEXT
	
	
	For llRowPos = 1 to llRowCount /*each detail row */
				
		If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
		
		//replace placeholders on label - Loop For each Qty of label
		llPrintQty = dw_Label.GetITemNumber(llRowPos,'c_print_Qty')
		If isnull(llPrintQty) or llPrintQty = 0 Then llPrintQty = 1
		
		For llPrintPos = 1 to llPrintQty
		
			lsFormat = lsLabel /*start with new template for each label */
		
			//Order Nbr
			lsFormat = invo_labels.uf_replace(lsFormat,"~~order_nbr~~",dw_Label.GetITemString(llRowPos,'order_nbr'))
			lsFormat = invo_labels.uf_replace(lsFormat,"~~order_nbr_bc~~",dw_Label.GetITemString(llRowPos,'order_nbr'))
		
			//SKU
			lsFormat = invo_labels.uf_replace(lsFormat,"~~sku~~",dw_Label.GetITemString(llRowPos,'sku'))
			lsFormat = invo_labels.uf_replace(lsFormat,"~~sku_bc~~",dw_Label.GetITemString(llRowPos,'sku'))
			
			//Serial No
			lsFormat = invo_labels.uf_replace(lsFormat,"~~serial_no~~",dw_Label.GetITemString(llRowPos,'serial_no'))
			lsFormat = invo_labels.uf_replace(lsFormat,"~~serial_no_bc~~",dw_Label.GetITemString(llRowPos,'serial_no'))
	
			//COO
			lsFormat = invo_labels.uf_replace(lsFormat,"~~coo~~",dw_Label.GetITemString(llRowPos,'coo'))
			lsFormat = invo_labels.uf_replace(lsFormat,"~~coo_bc~~",dw_Label.GetITemString(llRowPos,'coo'))
			
			
			//Location
			lsFormat = invo_labels.uf_replace(lsFormat,"~~location~~",dw_Label.GetITemString(llRowPos,'l_code'))
			
			//Inv Type
			lsFormat = invo_labels.uf_replace(lsFormat,"~~inv_type~~",dw_Label.GetITemString(llRowPos,'inv_Type'))
			
			isLabels[upperBound(isLabels) + 1] = lsFormat
			
		Next
		
	Next /*detail row to Print*/


ELSE
	
	
	lsLabel = lu_labels.uf_read_label_Format("3COM_License_Outbound_Zebrea.txt")
	
	For llRowPos = 1 to llRowCount /*each detail row */
		
		lsRMAContractWarranty = Upper(dw_label.GetITEmString(llRowPos,'user_field6'))
		lsRMA = dw_label.GetITEmString(llRowPos,'user_field4')
		lsCountry = Upper(dw_label.GetITEmString(llRowPos,'country'))

		If IsNull(lsRMAContractWarranty) THEN lsRMAContractWarranty = ""
		If IsNull(lsRMA) THEN lsRMA = ""		
		
		If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
		
		//replace placeholders on label - Loop For each Qty of label
		llPrintQty = dw_Label.GetITemNumber(llRowPos,'c_print_Qty')
		If isnull(llPrintQty) or llPrintQty = 0 Then llPrintQty = 1
		
		For llPrintPos = 1 to llPrintQty
		
			lsFormat = lsLabel /*start with new template for each label */
		
			//Address
		
			CHOOSE CASE lsRMAContractWarranty
			CASE 'Z5', 'Z9', 'ZF', 'Z2', 'Z6', 'ZN', 'ZT', 'Z7', 'ZB', 'ZH'
		
				CHOOSE CASE lsCountry
				CASE 'ES' /* Spain */
					lsAddress1 = '3COM C/O'
					lsAddress2 = 'VIVA XPRESS LOGISTICS SPAIN'
					lsAddress3 = 'Senda Galiana, C/A Nave 5'
					lsAddress4 = '28820 Coslada Madrid'
					lsAddress5 = 'SPAIN'
					lsAddress6 = ''			
				CASE 'CZ' /* Czech Republic */
					lsAddress1 = '3COM C/O'
					lsAddress2 = 'GO! Express & Logistics, s.r.o.'
					lsAddress3 = 'U Prioru 1076 / 5'
					lsAddress4 = '160 00 Praha 6'
					lsAddress5 = 'CZECH REPUBLIC'
					lsAddress6 = ''								
				CASE 'ZA' /* South Africa */
					lsAddress1 = '3COM C/O'
					lsAddress2 = 'Globeflight Worldwide Express (SA) PTY LTD'
					lsAddress3 = 'Unit 1,3, Loper Avenue, Spartan Ext2 Aeroport'
					lsAddress4 = 'Industrial Estate'
					lsAddress5 = 'Islando'
					lsAddress6 = 'South Africa'								
				CASE 'PL' /* Poland */
					lsAddress1 = '3COM C/O'
					lsAddress2 = 'GO! Express & logistics Polska Sp. Z.o.o'
					lsAddress3 = 'UI.17 Stycznia 45 b'
					lsAddress4 = '02-146 Warszawa'
					lsAddress5 = 'POLAND'
					lsAddress6 = ''			
				CASE 'GR' /* Greece */
					lsAddress1 = '3COM C/O'
					lsAddress2 = 'W.F.F LTD'
					lsAddress3 = 'World Feight Forwarders Internation LTD'
					lsAddress4 = 'Vakhou 1-3'
					lsAddress5 = 'Vari 16672'
					lsAddress6 = 'Athens - Greece'								

				CASE ELSE /* Use The Netherlands address */

					lsAddress1 = '3COM GLS Returns'
					lsAddress2 = 'c/o Menlo Worldwide Logistics B.V'
					lsAddress3 = 'Meerheide 29-35'
					lsAddress4 = 'Dock Doors 17/18'
					lsAddress5 = '5521 DZ Eersel'
					lsAddress6 = 'The Netherlands'					
						
				END CHOOSE
			
		
			CASE 'Z3', 'Z4'
		
				lsAddress1 = '3COM GLS Returns'
				lsAddress2 = 'c/o Menlo Worldwide Logistics B.V'
				lsAddress3 = 'Meerheide 29-35'
				lsAddress4 = 'Dock Doors 17/18'
				lsAddress5 = '5521 DZ Eersel'
				lsAddress6 = 'The Netherlands'
					
			END CHOOSE
		
			//SKU
			lsFormat = invo_labels.uf_replace(lsFormat,"~~rma~~", lsRMA)
	
			//Address
			lsFormat = invo_labels.uf_replace(lsFormat,"~~address_1~~", lsAddress1)
			lsFormat = invo_labels.uf_replace(lsFormat,"~~address_2~~", lsAddress2)
			lsFormat = invo_labels.uf_replace(lsFormat,"~~address_3~~", lsAddress3)
			lsFormat = invo_labels.uf_replace(lsFormat,"~~address_4~~", lsAddress4)
			lsFormat = invo_labels.uf_replace(lsFormat,"~~address_5~~", lsAddress5)
			lsFormat = invo_labels.uf_replace(lsFormat,"~~address_6~~", lsAddress6)			
		
			isLabels[upperBound(isLabels) + 1] = lsFormat
			
		Next
		
	Next /*detail row to Print*/

	
	
END IF


//Send the format(s) to the printer...
If upperBound(isLabels) > 0  Then
		
	OpenWithParm(w_label_print_options,lStrParms)
	Lstrparms = Message.PowerObjectParm		  
	If lstrParms.Cancelled Then
		Return
	End If
				
	lsPrintText = '3COM RMA Labels '

		//Open Printer File 
		llPrintJob = PrintOpen(lsPrintText)
	
		If llPrintJob <0 Then 
			Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
			Return
		End If

		For llLabelPos = 1 to upperBound(isLabels)
			
			PrintSend(llPrintJob, isLabels[llLabelPos])	
						
		Next
		
		PrintClose(llPrintJob)
		
		IF rb_outbound.checked THEN
		
			Post Function Close(this)
		
		END IF
		
End If
		

end event

event ue_check_enable();
//Print button enabled if 1 or more rows and at least one label checked

If dw_label.Find("c_print_ind = 'Y'",1, dw_label.RowCount()) > 0  Then
	cb_print.Enabled = True
Else
	cb_print.Enabled = False
End If


end event

public function integer uf_shipping_label (integer airow, string asformat);//String	lsWarehouse, lsFormat, lsShipDate, lsCOO2, lsSKU
//Long		llLabelPos, lLQty,  j
//
//
//
//
////Create a label for each of qty
//llQty = dw_label.GetITemNumber(aiRow,'c_print_qty')
////llStartingBox = dw_label.GetITemNumber(aiRow,'c_starting_box')
//
//For j = 1 to llQty 
//	
//	lsFormat = asFormat
//	
//	llLabelPos = UpperBound(islabels) + 1
//
//	lsFormat = uf_set_From_address(lsFormat)
//	lsFormat = uf_set_to_address(lsFormat)
//
//
//	//Sales Order Nbr (UF6)
//	If w_do.idw_main.GetITemString(1,'User_Field6') > "" Then
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~so_nbr~~",Left(Upper(w_do.idw_main.GetITemString(1,'User_Field6')),30))
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~so_nbr_barcode~~",Left(Upper(w_do.idw_main.GetITemString(1,'User_Field6')),30))
//	Else
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~so_nbr~~","")
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~so_nbr_barcode~~","")
//	End If
//
//	//Customer Order Nbr
//	If w_do.idw_main.GetITemString(1,'Cust_order_No') > "" Then
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_po_nbr~~",Left(Upper(w_do.idw_main.GetITemString(1,'Cust_order_No')),30))
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_po_nbr_barcode~~",Left(Upper(w_do.idw_main.GetITemString(1,'Cust_order_No')),30))
//	Else
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_po_nbr~~","")
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_po_nbr_barcode~~","")
//	End If
//
//	//Delivery NUmber (from DONO)
//	lsFormat = invo_labels.uf_replace(lsFormat,"~~delivery_nbr~~",Right(w_do.idw_main.GetITemString(1,'do_no'),6))
//	lsFormat = invo_labels.uf_replace(lsFormat,"~~delivery_nbr_barcode~~",Right(w_do.idw_main.GetITemString(1,'do_no'),6))
//
//	//Box of...
//	//lsFormat = invo_labels.uf_replace(lsFormat,"~~box_count~~",String(ilStartingBox) + " of " + String(dw_label.GetITemNumber(aiRow,'c_boxcount')))
//	lsFormat = invo_labels.uf_replace(lsFormat,"~~box_count~~",String(ilStartingBox) + " of " + String(dw_label.object.c_box_count[aiRow]))
//	
//	//Ship Date
//	If not isnull(w_do.idw_main.GetITemDateTime(1,'Complete_Date')) Then
//		lsShipDate = String(w_do.idw_main.GetITemDateTime(1,'Complete_Date'),'DD MMM, YYYY')
//	Else
//		lsShipDate = String(Today(),'DD MMM, YYYY')
//	End If
//	
//	lsFormat = invo_labels.uf_replace(lsFormat,"~~ship_date~~",lsShipDate)
//	
//	//SKU
//	
//	//If Sku contains "^" (Hat ITem), need to replace with ?? since this is a Zebra control Caharacter
//	lsSKU = dw_label.GetITemString(aiRow,'sku')
//	If Pos(lsSKU,'^') > 0 Then
//		lsSKU = Replace(lsSKU,Pos(lsSKU,'^'),1,"_5E")
//		lsFormat = invo_labels.uf_replace(lsFormat,"FD~~sku~~","FH^FD" + lsSKU)
//		lsFormat = invo_labels.uf_replace(lsFormat,"FD~~sku_barcode~~","FH^FD" +lsSKU)
//	Else
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~sku~~",lsSKU)
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~sku_barcode~~",lsSKU)
//	End If
//	
//	lsFormat = invo_labels.uf_replace(lsFormat,"~~sku~~",lsSKU)
//	lsFormat = invo_labels.uf_replace(lsFormat,"~~sku_barcode~~",lsSKU)
//	
//	//Revision
//	If dw_label.GetITemString(aiRow,'c_rev') > "" Then
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~sku_rev~~",dw_label.GetITemString(aiRow,'c_rev'))
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~sku_rev_barcode~~",dw_label.GetITemString(aiRow,'c_rev'))
//	Else
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~sku_rev~~","")
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~sku_rev_barcode~~","")
//	End If
//	
//	//SO Line - "LN" + Line number
//	If dw_label.GetITemString(aiRow,'delivery_detail_user_field2') > "" Then
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~so_nbr_line~~","LN" + dw_label.GetITemString(aiRow,'delivery_detail_user_field2'))
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~so_nbr_line_barcode~~","LN" + dw_label.GetITemString(aiRow,'delivery_detail_user_field2'))
//	Else
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~so_nbr_line~~","")
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~so_nbr_line_barcode~~","")
//	End If
//	
//	//Description (2  rows of 25 if necessary)
//	lsFormat = invo_labels.uf_replace(lsFormat,"~~desc_1~~",Left(dw_label.GetITemString(aiRow,'description'),25))
//	
//	If Len(dw_label.GetITemString(aiRow,'description')) > 25 Then
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~desc_2~~",Mid(dw_label.GetITemString(aiRow,'description'),26, 50))
//	Else
//		lsFormat = invo_labels.uf_replace(lsFormat,"~~desc_2~~","")
//	End If
//	
//	//COO
//	If Len(dw_label.GetITemString(aiRow,'c_Coo')) = 3 Then
//		lsCOO2 = uf_2char_Country(dw_label.GetITemString(aiRow,'c_Coo'))
//	Else
//		lsCOO2 = dw_label.GetITemString(aiRow,'c_Coo')
//	End If
//	
//	lsFormat = invo_labels.uf_replace(lsFormat,"~~coo~~",lsCOO2)
//	lsFormat = invo_labels.uf_replace(lsFormat,"~~coo_barcode~~",lsCOO2)
//	
//	//Qty
//	// 08/07 - PEr Netapp's Keith Owens after weeks of debate determined that the qty should be the carton Qty and Not the Line Qty.
//	//				Guaranteed this will change at some point in the future!!
//	//lsFormat = invo_labels.uf_replace(lsFormat,"~~qty~~",String(dw_label.GetITemNumber(aiRow,'alloc_Qty'),"###00"))
//	//lsFormat = invo_labels.uf_replace(lsFormat,"~~qty_barcode~~",String(dw_label.GetITemNumber(aiRow,'alloc_Qty'),"###00"))
//	lsFormat = invo_labels.uf_replace(lsFormat,"~~qty~~",String(dw_label.GetITemNumber(aiRow,'quantity'),"###00"))
//	lsFormat = invo_labels.uf_replace(lsFormat,"~~qty_barcode~~",String(dw_label.GetITemNumber(aiRow,'quantity'),"###00"))
//	
//	//special characters need to be 'cleansed'
//	lsFormat = f_cleanse_printer(lsFormat)
//
//	isLabels[llLabelPos] = lsFormat
//	
//	ilStartingBox ++
//	
//Next /*qty of label */
//
Return 0
end function

public function string uf_set_from_address (string asformat);
String	lsWarehouse, lsAddr, lsFormat, lsCityState
Long	llWarehouseRow, llAddressPos

lsFormat = asFormat

//Ship From -> Warehouse address (Warehouse info retreived in Warehouse DS)
lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

//Roll up if not all present
If llWarehouseRow > 0 Then
	
	llAddressPos = 0

	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name') > ' ' Then
		llAddressPos ++
		lsAddr = "~~from_addr" + String(llAddressPos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'),40))
	End If
	
	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1') > ' ' Then
		llAddressPos ++
		lsAddr = "~~from_addr" + String(llAddressPos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'),40))
	End If

	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2') > ' ' Then
		llAddressPos ++
		lsAddr = "~~from_addr" + String(llAddressPos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'),40))
	End If

	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3') > ' ' Then
		llAddressPos ++
		lsAddr = "~~from_addr" + String(llAddressPos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'),40))
	End If

	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4') > ' ' Then
		llAddressPos ++
		lsAddr = "~~from_addr" + String(llAddressPos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'),40))
	End If
	
	//Combine City, State and Zip
	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') > "" Then
		lsCityState = g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') + ", "
	End IF
		
	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') > "" Then
		lsCityState += g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') + " "
	End If
		
	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip') > "" Then
		lsCityState += g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip') 
	End If
	
	If lsCityState > "" Then
		
		llAddressPos ++
		lsAddr = "~~from_addr" + String(llAddressPos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(lsCityState,40))
		
	End If
	
	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'country') > ' ' Then
		llAddressPos ++
		lsAddr = "~~from_addr" + String(llAddressPos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'),40))
	End If
	
End If /*warehouse Found*/

Return lsFormat
end function

public function string uf_set_to_address (string asformat);Long	llAddressPos
String	lsAddr, lsFormat, lsCityState

lsFormat = asFormat

//Ship To - Roll up if not all present
llAddressPos = 0

If w_do.idw_main.GetITemString(1,'cust_name') > ' ' Then
	llAddressPos ++
	lsAddr = "~~to_addr" + String(llAddressPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(w_do.idw_main.GetITemString(1,'cust_name'),40))
End If

If w_do.idw_main.GetITemString(1,'address_1') > ' ' Then
	llAddressPos ++
	lsAddr = "~~to_addr" + String(llAddressPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(w_do.idw_main.GetITemString(1,'address_1'),40))
End If

If w_do.idw_main.GetITemString(1,'address_2') > ' ' Then
	llAddressPos ++
	lsAddr = "~~to_addr" + String(llAddressPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(w_do.idw_main.GetITemString(1,'address_2'),40))
End If

If w_do.idw_main.GetITemString(1,'address_3') > ' ' Then
	llAddressPos ++
	lsAddr = "~~to_addr" + String(llAddressPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(w_do.idw_main.GetITemString(1,'address_3'),40))
End If

If w_do.idw_main.GetITemString(1,'address_4') > ' ' Then
	llAddressPos ++
	lsAddr = "~~to_addr" + String(llAddressPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(w_do.idw_main.GetITemString(1,'address_4'),40))
End If

//Combine City, State and Zip
lsCityState = ""

If w_do.idw_main.GetITemString(1,'city') > "" Then
	lsCityState = w_do.idw_main.GetITemString(1,'city') + ", "
End IF
		
If w_do.idw_main.GetITemString(1,'state') > "" Then
	lsCityState += w_do.idw_main.GetITemString(1,'state') + " "
End If
		
If w_do.idw_main.GetITemString(1,'zip') > "" Then
	lsCityState += w_do.idw_main.GetITemString(1,'zip') 
End If
	
If lsCityState > "" Then
		
	llAddressPos ++
	lsAddr = "~~to_addr" + String(llAddressPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(lsCityState,40))
	
End If

If w_do.idw_main.GetITemString(1,'country') > ' ' Then
	llAddressPos ++
	lsAddr = "~~to_addr" + String(llAddressPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(w_do.idw_main.GetITemString(1,'country'),40))
End If

Return lsFormat
end function

public function integer wf_validate ();Long	llRowPos, llRowCount

llRowCount= dw_label.rowCount()
For lLRowPos = 1 to lLRowCount
	
	
		
Next

REturn 0
end function

public function string uf_new_pto_header (integer airow, string asformat, string ascarton, string asboxof);
String	lsFormat, lsSKU

lsFormat = asFormat

		lsFormat = uf_set_From_address(lsFormat)
		lsFormat = uf_set_to_address(lsFormat)

		//Sales Order Nbr (UF6)
		If w_do.idw_main.GetITemString(1,'User_Field6') > "" Then
			lsFormat = invo_labels.uf_replace(lsFormat,"~~so_nbr~~",Left(Upper(w_do.idw_main.GetITemString(1,'User_Field6')),30))
			lsFormat = invo_labels.uf_replace(lsFormat,"~~so_nbr_barcode~~",Left(Upper(w_do.idw_main.GetITemString(1,'User_Field6')),30))
		Else
			lsFormat = invo_labels.uf_replace(lsFormat,"~~so_nbr~~","")
			lsFormat = invo_labels.uf_replace(lsFormat,"~~so_nbr_barcode~~","")
		End If
		
		//SO Line - 
		If dw_label.GetITemString(aiRow,'delivery_detail_user_field2') > "" Then
			lsFormat = invo_labels.uf_replace(lsFormat,"~~so_line~~", dw_label.GetITemString(aiRow,'delivery_detail_user_field2'))
		Else
			lsFormat = invo_labels.uf_replace(lsFormat,"~~so_nbr_line~~","")
		End If
	
		//Parent SKU + Revision
		lsSKU = dw_label.GetITemString(aiRow,'sku')
	
		If dw_label.GetITemString(aiRow,'c_rev') > "" Then
			lsSKU += "+" + dw_label.GetITemString(aiRow,'c_rev')
		End If
	
		lsFormat = invo_labels.uf_replace(lsFormat,"~~sku~~",lsSKU)
	
		//PArent Description 
		lsFormat = invo_labels.uf_replace(lsFormat,"~~desc~~",dw_label.GetITemString(aiRow,'description'))
			
		//Print Date
		lsFormat = invo_labels.uf_replace(lsFormat,"~~print_date~~",String(Today(),'MMMM DD, YYYY'))
	
		//Carton Number 
		lsFormat = invo_labels.uf_replace(lsFormat,"~~carton_nbr~~",asCarton)
		lsFormat = invo_labels.uf_replace(lsFormat,"~~carton_nbr_barcode~~",asCarton)
	
		//Box of...
		lsFormat = invo_labels.uf_replace(lsFormat,"~~page~~",asBoxOf)



Return lsFormat
end function

on w_3com_rma_labels.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_label=create dw_label
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
this.rb_inbound=create rb_inbound
this.rb_outbound=create rb_outbound
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_clear
this.Control[iCurrent+5]=this.rb_inbound
this.Control[iCurrent+6]=this.rb_outbound
this.Control[iCurrent+7]=this.gb_1
end on

on w_3com_rma_labels.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_selectall)
destroy(this.cb_clear)
destroy(this.rb_inbound)
destroy(this.rb_outbound)
destroy(this.gb_1)
end on

event ue_postopen;call super::ue_postopen;String	lsWarehouse

invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

boolean lb_valid_window_open = false

cb_print.Enabled = False

IF isvalid(w_ro) Then
	rb_inbound.checked = true
	rb_outbound.checked = false	
	lb_valid_window_open = true

ELSE
	
	
	IF isvalid(w_do) Then
		rb_inbound.checked = false
		rb_outbound.checked = true
		lb_valid_window_open = true
	
	END IF

End If


IF NOT lb_valid_window_open THEN

	Messagebox("3COM RMA Labels","You must have an open Receiving or Outbound Order to print RMA Labels.")
	
	Return

END IF

This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;call super::ue_retrieve;String lsCArton, lsCartonSave,  lsRONO, lsSKU, lsSOLine,  lsFind, lsInvType, lsInvTypeSave, lsInvDesc
Long	llRowPos, llRowCOunt, llCartonCount, llLineItemNo, llFindRow

IF rb_inbound.checked THEN

	IF dw_Label.dataobject <> "d_3com_rma_label" THEN  dw_Label.dataobject = "d_3com_rma_label"

	If not isvalid(w_ro) Then Return
	If w_ro.idw_main.RowCount() < 1 then return
	
	
	dw_label.SetRedraw(False)
	SetPointer(Hourglass!)
	
	//Insert a row for each Putaway Row
	llRowCount = w_ro.idw_Putaway.RowCount()
	For llRowPos = 1 to llRowCount
		
			
		dw_label.InsertRow(0)
		dw_Label.SetItem(dw_label.RowCount(),'order_nbr',w_ro.idw_Main.GetITemString(1,'supp_invoice_no'))
		dw_Label.SetItem(dw_label.RowCount(),'sku',w_ro.idw_Putaway.GetITemString(llRowPos,'sku'))
		dw_Label.SetItem(dw_label.RowCount(),'serial_No',w_ro.idw_Putaway.GetITemString(llRowPos,'serial_no'))
		dw_Label.SetItem(dw_label.RowCount(),'l_code',w_ro.idw_Putaway.GetITemString(llRowPos,'l_code'))
		dw_Label.SetItem(dw_label.RowCount(),'coo',w_ro.idw_Putaway.GetITemString(llRowPos,'country_of_origin'))
	
		
		
		dw_Label.SetItem(dw_label.RowCount(),'c_print_qty',1)
		
		//Get Inv Type Description
		lsInvType = w_ro.idw_Putaway.GetITemString(llRowPos,'inventory_type')
		
		If lsInvType <> lsInvTypeSave Then
			
			Select inv_type_Desc into :lsInvDesc
			From Inventory_Type
			Where project_id = :gs_Project and inv_type = :lsInvType;
			
			//Strip off anything in parenthesis
			If Pos(lsInvDesc,'(') > 0 Then
				lsInvDesc = Left(lsInvDesc,Pos(lsInvDesc,'(') -1)
			End If
			
		End If
		
		lsInvTypeSave = lsInvType
		
		dw_Label.SetItem(dw_label.RowCount(),'inv_type',lsInvDesc)
			
	Next /*Putaway Row*/


ELSE

string lsDoNo

	If isVAlid(w_do) Then
		if w_do.idw_main.RowCOunt() > 0 Then
			lsDoNo = w_do.idw_main.GetITemString(1,'do_no')
		End If
	End If
	
	
	IF dw_Label.dataobject <> "d_3com_rma_outbound_label" THEN  
		
		dw_Label.dataobject = "d_3com_rma_outbound_label"
		dw_Label.SetTransObject(SQLCA)
		
		
			
	END IF
	
	dw_Label.Retrieve(gs_Project, lsDoNo)
	
	
END IF


dw_label.SetRedraw(True)
SetPointer(Arrow!)

This.TriggerEvent('ue_check_enable')


end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','Y')
Next

dw_label.SetRedraw(True)

This.TriggerEvent('ue_check_Enable')

end event

event ue_unselectall;call super::ue_unselectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','N')
Next

dw_label.SetRedraw(True)

This.TriggerEvent('ue_check_Enable')

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-250)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_3com_rma_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
integer taborder = 30
end type

type cb_ok from w_main_ancestor`cb_ok within w_3com_rma_labels
boolean visible = false
integer x = 1216
integer y = 44
integer height = 80
integer textsize = -9
boolean default = false
end type

type cb_print from commandbutton within w_3com_rma_labels
integer x = 576
integer y = 44
integer width = 329
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;Parent.TriggerEvent('ue_Print')
end event

type dw_label from u_dw_ancestor within w_3com_rma_labels
integer x = 27
integer y = 348
integer width = 2944
integer height = 1280
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_3com_rma_label"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;
Choose Case Upper(dwo.name)
		
			
	case 'C_PRINT_IND'
		
		Parent.PostEvent('ue_check_Enable')
				
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event process_enter;call super::process_enter;
//Send(Handle(This),256,9,Long(0,0))
end event

type cb_selectall from commandbutton within w_3com_rma_labels
integer x = 37
integer y = 12
integer width = 338
integer height = 68
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All"
end type

event clicked;Parent.Event ue_selectall()

end event

type cb_clear from commandbutton within w_3com_rma_labels
integer x = 37
integer y = 92
integer width = 338
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear All"
end type

event clicked;Parent.Event ue_unselectall()
end event

type rb_inbound from radiobutton within w_3com_rma_labels
integer x = 2400
integer y = 116
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inbound"
boolean checked = true
end type

event clicked;
dw_label.dataobject = 'd_3com_rma_label'

IF isvalid(w_ro) Then

	
	w_3com_rma_labels.TriggerEvent('ue_retrieve')


	

ELSE
	

	Messagebox("3COM RMA Labels","You must have an open Receiving Order to print Inbound RMA Labels.")
	
	Return

END IF

end event

type rb_outbound from radiobutton within w_3com_rma_labels
integer x = 2400
integer y = 192
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Outbound"
end type

event clicked;

dw_label.dataobject = 'd_3com_rma_outbound_label'
dw_label.SetTransObject(SQLCA)


IF isvalid(w_do) Then



	w_3com_rma_labels.TriggerEvent('ue_retrieve')
	
	
	

ELSE
	

	Messagebox("3COM RMA Labels","You must have an open Delivery Order to print Outbound RMA Labels.")
	
	Return

END IF

end event

type gb_1 from groupbox within w_3com_rma_labels
integer x = 2309
integer y = 44
integer width = 567
integer height = 248
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Label Type"
end type

