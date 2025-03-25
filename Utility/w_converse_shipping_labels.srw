HA$PBExportHeader$w_converse_shipping_labels.srw
$PBExportComments$Powerwave Shipping labels
forward
global type w_converse_shipping_labels from w_main_ancestor
end type
type cb_print from commandbutton within w_converse_shipping_labels
end type
type dw_label from u_dw_ancestor within w_converse_shipping_labels
end type
type cb_selectall from commandbutton within w_converse_shipping_labels
end type
type cb_clear from commandbutton within w_converse_shipping_labels
end type
type cbx_ship from checkbox within w_converse_shipping_labels
end type
type cbx_carton_content from checkbox within w_converse_shipping_labels
end type
end forward

global type w_converse_shipping_labels from w_main_ancestor
boolean visible = false
integer width = 3086
integer height = 1836
string title = "Converse Shipping Labels"
string menuname = ""
event ue_print ( )
event ue_check_enable ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_clear cb_clear
cbx_ship cbx_ship
cbx_carton_content cbx_carton_content
end type
global w_converse_shipping_labels w_converse_shipping_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
	
String	isLabels[]


datastore  i_dw_ship_label

datastore i_dw_content_label

datastore i_dw_part_label
end variables

forward prototypes
public function integer uf_shipping_label (integer airow, string asformat)
public function integer uf_sku_label (string asformat, long albeginrow, long alendrow)
public function string uf_set_from_address (string asformat)
public function string uf_set_to_address (string asformat)
public function integer wf_validate ()
public function integer uf_sku_label_dw (long albeginrow, long alendrow, long alprintjob)
public function integer uf_shipping_label_dw (integer airow, long alprintjob)
public function string uf_set_to_address_dw (ref datastore a_ds)
public function string uf_set_from_address_dw (ref datastore a_ds)
end prototypes

event ue_print();Str_Parms	lstrparms
n_labels	lu_labels

Long	llRowCount, llRowPos, 	llPrintJob,  llLabelPos, llBeginRow, llEndRow

String	lsPrintText, lsShipFormat, lsSKUFormat, lsCarton, lsCartonSave, lsOEMFormat, lsCustomer, lsNullLabel[]

lu_labels = Create n_labels

Dw_Label.AcceptText()

//Validate any required fields before printing
If wf_validate() < 0 Then Return

string lsWarehouse

lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')

//IF lsWarehouse =  "CONVERSE" THEN
//
//
//	i_dw_ship_label = CREATE datastore;
//	i_dw_content_label = CREATE datastore;
//	i_dw_part_label = CREATE datastore;
//	
//	
//	 i_dw_ship_label.dataobject = "d_converse_shipping_label"
//	 i_dw_content_label.dataobject = "d_converse_carton_content_label"
//	
//	i_dw_ship_label.Modify("DataWindow.Print.quality=1")
//	i_dw_content_label.Modify("DataWindow.Print.quality=1")
//	i_dw_part_label.Modify("DataWindow.Print.quality=1")
//	
//	
//	OpenWithParm(w_label_print_options,lStrParms)
//	Lstrparms = Message.PowerObjectParm		  
//	If lstrParms.Cancelled Then
//		Return
//	End If
//					
//	lsPrintText = 'Converse Shipping Labels '
//	
//	//Open Printer File 
//	llPrintJob = PrintOpen(lsPrintText)
//		
//	If llPrintJob <0 Then 
//		Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
//		Return
//	End If
//	
//
//
////	//Retrieive necessary formats
////	lsShipFormat = lu_labels.uf_read_label_Format("converse_shipping_label.txt")
////	lsSKUFormat = lu_labels.uf_read_label_Format("converse_carton_content.txt")
//	
//
//	
//	//Print each detail Row
//	llRowCount = dw_label.RowCount()
//	llBeginRow = 1 /*starting row of ccurent carton forcarton content labels*/
//	
//	For llRowPos = 1 to llRowCount /*each detail row */
//				
//		If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
//		
//		lsCarton = dw_label.GetITEmString(llRowPos,'carton_no')
//		
//		//If new carton, print shipping label and carton contents label (for all rows in carton)
//		If lsCarton <> lsCartonSave Then
//			
//			llEndRow = llRowPos -1 /*ending Row of last carton*/
//			
//			If llEndRow > 0 Then /*carton content label for previous carton*/
//			
//				uf_sku_label_dw(llBeginRow, llEndRow, llPrintJob )
//				
//			
//			End If
//					
//			uf_shipping_label_dw(llRowPos, llPrintJob) /*shipping label for new carton*/
//			
//			llBeginRow = llRowPos /*starting Row row of current carton*/
//			
//		End If
//		
//		lsCartonSave = lsCarton
//				
//	Next /*detail row to Print*/
//	
//	
//	//Print carton content label for last/only carton
//	If llRowCount > 0 Then
//		
//		uf_sku_label_dw(llBeginRow, llRowCount, llPrintJob ) /*carton contents label*/
//		
//	
//	End If	
//
//	PrintClose(llPrintJob)
//			
//	DESTROY i_dw_ship_label;
//	DESTROY i_dw_content_label;
//	DESTROY i_dw_part_label;
//	
//	
//ELSE
	
	isLabels = lsNullLabel /*clear any previous printed labels*/
	
	//Retrieive necessary formats
	lsShipFormat = lu_labels.uf_read_label_Format("converse_shipping_label.txt")
	lsSKUFormat = lu_labels.uf_read_label_Format("converse_carton_content.txt")
	
	

	//Print each detail Row
	llRowCount = dw_label.RowCount()
	llBeginRow = 1 /*starting row of ccurent carton forcarton content labels*/
	
	For llRowPos = 1 to llRowCount /*each detail row */
				
		If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
		
		lsCarton = dw_label.GetITEmString(llRowPos,'carton_no')
		
		//If new carton, print shipping label and carton contents label (for all rows in carton)
		If lsCarton <> lsCartonSave Then
			
			llEndRow = llRowPos -1 /*ending Row of last carton*/
			
			If llEndRow > 0 Then /*carton content label for previous carton*/
			
				uf_sku_label(lsSKUFormat, llBeginRow, llEndRow)
				
				
			End If
					
			uf_shipping_label(llRowPos, lsShipFormat) /*shipping label for new carton*/
			
			llBeginRow = llRowPos /*starting Row row of current carton*/
			
		End If
		
		lsCartonSave = lsCarton
				
	Next /*detail row to Print*/
	
	
	//Print carton content label for last/only carton
	If llRowCount > 0 Then
		
		uf_sku_label(lsSKUFormat, llBeginRow, llRowCount) /*carton contents label*/
		
				
	End If

	//Send the format to the printer...
	If upperBound(isLabels) > 0  Then
			
		OpenWithParm(w_label_print_options,lStrParms)
		Lstrparms = Message.PowerObjectParm		  
		If lstrParms.Cancelled Then
			Return
		End If
					
		lsPrintText = 'Converse Shipping Labels '
	
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
			
	End If	
	
	
//END IF


		

end event

event ue_check_enable();
//Print button enabled if 1 or more rows and at least one label checked

If dw_label.Find("C_print_Ind = 'Y'",1, dw_label.RowCount()) > 0 and (cbx_Ship.checked or cbx_carton_Content.checked) Then
	cb_print.Enabled = True
Else
	cb_print.Enabled = False
End If


end event

public function integer uf_shipping_label (integer airow, string asformat);String	lsWarehouse, lsFormat, lsAddr, lsCityState, lsShipDate, lsUCCPRefix, lsUCCCarton, lsCarrier, lsCarrierName
Long		lLWarehouseRow, llAddressPos, llLabelPos
Integer	liCheck
lsFormat = asFormat

If Not cbx_ship.checked Then Return 0 /* Don''t print if checkbox for Shipping label not checked*/

llLabelPos = UpperBound(islabels) + 1

lsFormat = uf_set_From_address(lsFormat)
lsFormat = uf_set_to_address(lsFormat)

//Ship to Zip...
If w_do.idw_main.GetITemString(1,'zip') > "" Then
	lsFormat = invo_labels.uf_replace(lsFormat,"~~ship2postzip~~",Left(w_do.idw_main.GetITemString(1,'zip'),30))
	lsFormat = invo_labels.uf_replace(lsFormat,"~~ship2postbarcode~~",Left(w_do.idw_main.GetITemString(1,'zip'),30))
End If

//Carrier
If w_do.idw_main.GetITemString(1,'Carrier') > "" Then
	
	//Carrier Name
	lscarrier = w_do.idw_main.GetITemString(1,'Carrier')
	
	Select Carrier_name into :lsCarrierName
	From Carrier_Master
	Where Project_id = :gs_project and Carrier_code = :lsCarrier;
	
	If lsCarrierName = "" or isnull(lsCarrierName) Then lsCarrierName = lsCarrier;
	
	lsFormat = invo_labels.uf_replace(lsFormat,"~~Carrier~~",lsCarrierName)
End If

//Sales Order Nbr (UF6)
If w_do.idw_main.GetITemString(1,'User_Field6') > "" Then
	lsFormat = invo_labels.uf_replace(lsFormat,"~~sales_order_nbr~~",Left(Upper(w_do.idw_main.GetITemString(1,'User_Field6')),30))
Else
	lsFormat = invo_labels.uf_replace(lsFormat,"~~sales_order_nbr~~","")
End If

//Customer Order Nbr
If w_do.idw_main.GetITemString(1,'Cust_order_No') > "" Then
	lsFormat = invo_labels.uf_replace(lsFormat,"~~Cust_order_nbr~~",Left(Upper(w_do.idw_main.GetITemString(1,'Cust_order_No')),30))
Else
	lsFormat = invo_labels.uf_replace(lsFormat,"~~Cust_order_nbr~~","")
End If

//Delivery NUmber (Invoice No)
If w_do.idw_main.GetITemString(1,'Invoice_no') > "" Then
	lsFormat = invo_labels.uf_replace(lsFormat,"~~Delivery_Number~~",Left(Upper(w_do.idw_main.GetITemString(1,'Invoice_no')),30))
End If

//AWB
If w_do.idw_Main.GetITemString(1,'awb_bol_no') > "" Then
	lsFormat = invo_labels.uf_replace(lsFormat,"~~awb_bol_nbr~~",Left(w_do.idw_Main.GetITemString(1,'awb_bol_no'),30))
Else
	lsFormat = invo_labels.uf_replace(lsFormat,"~~awb_bol_nbr~~","")
End If


//Weight
If dw_label.getITemNumber(aiRow,'weight_gross') > 0 Then
	lsFormat = invo_labels.uf_replace(lsFormat,"~~Weight~~",String(dw_label.getITemNumber(aiRow,'weight_gross')))
End If

//Box of...
lsFormat = invo_labels.uf_replace(lsFormat,"~~Box~~",String(dw_label.getITemString(aiRow,'Box_Of')))

//Ship Date
If not isnull(w_do.idw_main.GetITemDateTime(1,'Complete_Date')) Then
	lsShipDate = String(w_do.idw_main.GetITemDateTime(1,'Complete_Date'),'DD-MMM-YYYY')
Else
	lsShipDate = String(Today(),'DD-MMM-YYYY')
End If
	
lsFormat = invo_labels.uf_replace(lsFormat,"~~Ship_Date~~",lsShipDate)

//Carton Number
lsUCCCarton = dw_label.getITemString(aiRow,'carton_no')
lsFormat = invo_labels.uf_replace(lsFormat,"~~carton_nbr_barcode~~",lsUccCarton)
lsFormat = invo_labels.uf_replace(lsFormat,"~~carton_nbr~~",lsUccCarton)

//Swedish characters need to be 'cleansed'
lsFormat = f_cleanse_printer(lsFormat)

isLabels[llLabelPos] = lsFormat

Return 0
end function

public function integer uf_sku_label (string asformat, long albeginrow, long alendrow);
String	lsFormat, lsLit, lsShipDate, lsSKU
Long	llRowPos, llLabelPos, llFindRow, llpos, llBeginPos, llEndPos
Int	liCurPos

If Not cbx_carton_Content.checked Then Return 0 /* Don't print if checkbox for Carton Content label not checked*/

lsFormat = asFormat

liCurPos = 0

//For each row of current carton
For llRowPos = alBeginRow to alEndRow
	
	If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
	
	liCurPos ++
	
	//Literals - don't want literals for Product or Qty if not data
	lsLit =  "~~product" + String(liCurPos) + "_literal~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsLit,"Product (P)") 
	lsLit =  "~~qty" + String(liCurPos) + "_literal~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsLit,"Qty (Q)")
	
	//SKU - If "Legacy SKU" exist in Detail User field 4, take that, otherwise take the SKU
	llFindRow = w_do.idw_Detail.Find("upper(SKU) = '" + dw_label.GetITemString(llRowPos,'sku') + "'",1,w_do.idw_Detail.RowCount())
	If llFindRow > 0 Then
		If w_do.idw_detail.GetITemString(llFindRow,'User_field4') > "" Then
			lsSKU = w_do.idw_detail.GetITemString(llFindRow,'User_field4')
		Else
			lsSKU = dw_label.GetITemString(llRowPos,'sku')
		End If
	Else
		lsSKU = dw_label.GetITemString(llRowPos,'sku')
	End If
	
	lsLit =  "~~sku" + String(liCurPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsLit,lsSKU)
	lsLit =  "~~sku" + String(liCurPos) + "_barcode~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsLit,"P" + lsSKU)
	
	//Qty
	lsLit =  "~~qty" + String(liCurPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsLit,String(dw_label.GetITemNumber(llRowPos,'quantity')))
	lsLit =  "~~qty" + String(liCurPos) + "_barcode~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsLit,"Q" + String(dw_label.GetITemNumber(llRowPos,'quantity')))
	
	//UOM from Detail record
	llFindRow = w_do.idw_Detail.Find("upper(SKU) = '" + dw_label.GetITemString(llRowPos,'sku') + "'",1,w_do.idw_Detail.RowCount())
	If llFindRow > 0 Then
		lsLit =  "~~uom" + String(liCurPos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsLit,w_do.idw_detail.GetITemString(llFindRow,'uom'))
	End If
	
	//Delivery NUmber (Invoice No)
	If w_do.idw_main.GetITemString(1,'Invoice_no') > "" Then
		lsFormat = invo_labels.uf_replace(lsFormat,"~~delivery_number_barcode~~",Left(w_do.idw_main.GetITemString(1,'Invoice_no'),30))
		lsFormat = invo_labels.uf_replace(lsFormat,"~~delivery_Number~~",Left(w_do.idw_main.GetITemString(1,'Invoice_no'),30))
	End If

	//Ship Date
	If not isnull(w_do.idw_main.GetITemDateTime(1,'Complete_Date')) Then
		lsShipDate = String(w_do.idw_main.GetITemDateTime(1,'Complete_Date'),'DD-MMM-YYYY')
	Else
		lsShipDate = String(Today(),'DD-MMM-YYYY')
	End If
	lsFormat = invo_labels.uf_replace(lsFormat,"~~ship_date~~",lsShipDate)
	
	//We need a new label for each 4 rows...
	If liCurPOs = 4 Then
		
		llLabelPos = UpperBound(islabels) + 1
		isLabels[llLabelPos] = lsFormat
		
		If llRowPos < alEndRow Then
			lsFormat = asFormat
		Else
			lsFormat = ""
		End If
		
		liCurPOs = 0
		
	End If
	
Next

//If we don't have a full label, we need to clear out the rest of the fields...
If liCurPos > 0 Then
	
	For llRowPos = (liCurPos + 1) to 4	
	
		//Clear out literals
		lsLit =  "~~product" + String(llRowPos) + "_literal~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsLit,"") 
		lsLit =  "~~qty" + String(llRowPos) + "_literal~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsLit,"")
		
		//Delete barcode ZPL from format so we don't print an empty barcode
		
		//Find the string for the barcodes
		llPos = pos(lsFormat,("sku" + String(lLRowPos) + "_barcode"),1)
		If llPos > 0 Then
			lsFormat = Replace(lsFormat, (llPos - 37),53,"") //row begins 37 before with a length of 53 (got to be a better way!)
		End If
		
		llPos = pos(lsFormat,("qty" + String(lLRowPos) + "_barcode"),1)
		If llPos > 0 Then
			if llRowPos = 4 Then /*an extra char on the last one - this is really fuc*ed*/
				lsFormat = Replace(lsFormat, (llPos - 38),54,"") //row begins 38 before with a length of 54 
			else
				lsFormat = Replace(lsFormat, (llPos - 37),53,"") //row begins 37 before with a length of 53 
			End If
		End If
	
	Next
		
End If



//Write last format if present
If lsFormat > "" Then
	llLabelPos = UpperBound(islabels) + 1
	isLabels[llLabelPos] = lsFormat
End If

//Ship to Zip...
If w_do.idw_main.GetITemString(1,'zip') > "" Then
	lsFormat = invo_labels.uf_replace(lsFormat,"~~ship2postzip~~",Left(w_do.idw_main.GetITemString(1,'zip'),30))
	lsFormat = invo_labels.uf_replace(lsFormat,"~~ship2postbarcode~~",Left(w_do.idw_main.GetITemString(1,'zip'),30))
End If

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
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'),30))
	End If
	
	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1') > ' ' Then
		llAddressPos ++
		lsAddr = "~~from_addr" + String(llAddressPos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'),30))
	End If

	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2') > ' ' Then
		llAddressPos ++
		lsAddr = "~~from_addr" + String(llAddressPos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'),30))
	End If

	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3') > ' ' Then
		llAddressPos ++
		lsAddr = "~~from_addr" + String(llAddressPos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'),30))
	End If

	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4') > ' ' Then
		llAddressPos ++
		lsAddr = "~~from_addr" + String(llAddressPos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'),30))
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
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(lsCityState,30))
		
	End If
	
	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'country') > ' ' Then
		llAddressPos ++
		lsAddr = "~~from_addr" + String(llAddressPos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'),30))
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
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(w_do.idw_main.GetITemString(1,'cust_name'),30))
End If

If w_do.idw_main.GetITemString(1,'address_1') > ' ' Then
	llAddressPos ++
	lsAddr = "~~to_addr" + String(llAddressPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(w_do.idw_main.GetITemString(1,'address_1'),30))
End If

If w_do.idw_main.GetITemString(1,'address_2') > ' ' Then
	llAddressPos ++
	lsAddr = "~~to_addr" + String(llAddressPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(w_do.idw_main.GetITemString(1,'address_2'),30))
End If

If w_do.idw_main.GetITemString(1,'address_3') > ' ' Then
	llAddressPos ++
	lsAddr = "~~to_addr" + String(llAddressPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(w_do.idw_main.GetITemString(1,'address_3'),30))
End If

If w_do.idw_main.GetITemString(1,'address_4') > ' ' Then
	llAddressPos ++
	lsAddr = "~~to_addr" + String(llAddressPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(w_do.idw_main.GetITemString(1,'address_4'),30))
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
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(lsCityState,30))
	
End If

If w_do.idw_main.GetITemString(1,'country') > ' ' Then
	llAddressPos ++
	lsAddr = "~~to_addr" + String(llAddressPos) + "~~"
	lsFormat = invo_labels.uf_replace(lsFormat,lsAddr,Left(w_do.idw_main.GetITemString(1,'country'),30))
End If

Return lsFormat
end function

public function integer wf_validate ();Long	llRowPos, llRowCount

llRowCount= dw_label.rowCount()
For lLRowPos = 1 to lLRowCount
	
	If dw_label.GetITemString(llRowPOs,'c_print_ind') <> 'Y' Then Continue
	

Next

REturn 0
end function

public function integer uf_sku_label_dw (long albeginrow, long alendrow, long alprintjob);
String	 lsLit, lsShipDate, lsSKU
Long	llRowPos, llLabelPos, llFindRow, llpos, llBeginPos, llEndPos
Int	liCurPos

If Not cbx_carton_Content.checked Then Return 0 /* Don't print if checkbox for Carton Content label not checked*/

i_dw_content_label.Reset()
i_dw_content_label.InsertRow(1)

liCurPos = 0

//For each row of current carton
For llRowPos = alBeginRow to alEndRow
	
	If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
	
	liCurPos ++
	
//	//Literals - don't want literals for Product or Qty if not data
//	lsLit =  "product" + String(liCurPos) + "_literal"
//	lsFormat = invo_labels.uf_replace(lsFormat,lsLit,"Product (P)") 
//	lsLit =  "~~qty" + String(liCurPos) + "_literal~~"
//	lsFormat = invo_labels.uf_replace(lsFormat,lsLit,"Qty (Q)")
	
	//SKU - If "Legacy SKU" exist in Detail User field 4, take that, otherwise take the SKU
	llFindRow = w_do.idw_Detail.Find("upper(SKU) = '" + dw_label.GetITemString(llRowPos,'sku') + "'",1,w_do.idw_Detail.RowCount())
	If llFindRow > 0 Then
		If w_do.idw_detail.GetITemString(llFindRow,'User_field4') > "" Then
			lsSKU = w_do.idw_detail.GetITemString(llFindRow,'User_field4')
		Else
			lsSKU = dw_label.GetITemString(llRowPos,'sku')
		End If
	Else
		lsSKU = dw_label.GetITemString(llRowPos,'sku')
	End If
	
	lsLit =  "sku" + String(liCurPos)
	i_dw_content_label.SetItem(1,lsLit,lsSKU)
	lsLit =  "sku" + String(liCurPos) + "_barcode"
	i_dw_content_label.SetItem(1,lsLit,"P" + lsSKU)
	
	//Qty
	lsLit =  "qty" + String(liCurPos)
	i_dw_content_label.SetItem(1,lsLit,String(dw_label.GetITemNumber(llRowPos,'quantity')))
	lsLit =  "qty" + String(liCurPos) + "_barcode"
	i_dw_content_label.SetItem(1,lsLit,"Q" + String(dw_label.GetITemNumber(llRowPos,'quantity')))
	
	//UOM from Detail record
	llFindRow = w_do.idw_Detail.Find("upper(SKU) = '" + dw_label.GetITemString(llRowPos,'sku') + "'",1,w_do.idw_Detail.RowCount())
	If llFindRow > 0 Then
		lsLit =  "uom" + String(liCurPos) 
		i_dw_content_label.SetItem(1,lsLit,w_do.idw_detail.GetITemString(llFindRow,'uom'))
	End If
	
	//Delivery NUmber (Invoice No)
	If w_do.idw_main.GetITemString(1,'Invoice_no') > "" Then
		i_dw_content_label.SetItem(1,"delivery_number_barcode",Left(w_do.idw_main.GetITemString(1,'Invoice_no'),30))
		i_dw_content_label.SetItem(1,"delivery_Number",Left(w_do.idw_main.GetITemString(1,'Invoice_no'),30))
	End If

	//Ship Date
	If not isnull(w_do.idw_main.GetITemDateTime(1,'Complete_Date')) Then
		lsShipDate = String(w_do.idw_main.GetITemDateTime(1,'Complete_Date'),'DD-MMM-YYYY')
	Else
		lsShipDate = String(Today(),'DD-MMM-YYYY')
	End If
	i_dw_content_label.SetItem(1,"ship_date",lsShipDate)
	
	//We need a new label for each 4 rows...
	If liCurPOs = 4 Then

		
//     Add label		
//		llLabelPos = UpperBound(islabels) + 1
//		isLabels[llLabelPos] = lsFormat
//		
//		If llRowPos < alEndRow Then
//			lsFormat = asFormat
//		Else
//			lsFormat = ""
//		End If
//		
//		liCurPOs = 0
		
	End If
	
Next

//If we don't have a full label, we need to clear out the rest of the fields...
If liCurPos > 0 Then
	
	For llRowPos = (liCurPos + 1) to 4	
	
		//Clear out literals
		
		i_dw_content_label.SetItem(1,"not_visible"+string(llRowPos),1)
		
		
//		lsLit =  "~~product" + String(llRowPos) + "_literal~~"
//		lsFormat = invo_labels.uf_replace(lsFormat,lsLit,"") 
//		lsLit =  "~~qty" + String(llRowPos) + "_literal~~"
//		lsFormat = invo_labels.uf_replace(lsFormat,lsLit,"")
		
//		//Delete barcode ZPL from format so we don't print an empty barcode
//		
//		//Find the string for the barcodes
//		llPos = pos(lsFormat,("sku" + String(lLRowPos) + "_barcode"),1)
//		If llPos > 0 Then
//			lsFormat = Replace(lsFormat, (llPos - 37),53,"") //row begins 37 before with a length of 53 (got to be a better way!)
//		End If
//		
//		llPos = pos(lsFormat,("qty" + String(lLRowPos) + "_barcode"),1)
//		If llPos > 0 Then
//			if llRowPos = 4 Then /*an extra char on the last one - this is really fuc*ed*/
//				lsFormat = Replace(lsFormat, (llPos - 38),54,"") //row begins 38 before with a length of 54 
//			else
//				lsFormat = Replace(lsFormat, (llPos - 37),53,"") //row begins 37 before with a length of 53 
//			End If
//		End If
	
	Next
		
End If


PrintDataWindow ( alPrintJob, i_dw_content_label )

//Write last format if present
//If lsFormat > "" Then
//	llLabelPos = UpperBound(islabels) + 1
//	isLabels[llLabelPos] = lsFormat
//End If
//
////Ship to Zip...
//If w_do.idw_main.GetITemString(1,'zip') > "" Then
//	lsFormat = invo_labels.uf_replace(lsFormat,"~~ship2postzip~~",Left(w_do.idw_main.GetITemString(1,'zip'),30))
//	lsFormat = invo_labels.uf_replace(lsFormat,"~~ship2postbarcode~~",Left(w_do.idw_main.GetITemString(1,'zip'),30))
//End If
//
Return 0
end function

public function integer uf_shipping_label_dw (integer airow, long alprintjob);String	lsWarehouse, lsAddr, lsCityState, lsShipDate, lsUCCPRefix, lsUCCCarton, lsCarrier, lsCarrierName
Long		lLWarehouseRow, llAddressPos
Integer	liCheck
long 		llPrintJob

If Not cbx_ship.checked Then Return 0 /* Don''t print if checkbox for Shipping label not checked*/


i_dw_ship_label.Reset()
i_dw_ship_label.InsertRow(1)

//llPrintJob = PrintOpen('Powerwave Shipping Labels ')

uf_set_From_address_dw(i_dw_ship_label)
uf_set_to_address_dw(i_dw_ship_label)

//Ship to Zip...
If w_do.idw_main.GetITemString(1,'zip') > "" Then
	i_dw_ship_label.SetItem(1,"ship2postzip",Left(w_do.idw_main.GetITemString(1,'zip'),30))
	i_dw_ship_label.SetItem(1,"ship2postbarcode",Left(w_do.idw_main.GetITemString(1,'zip'),30))
End If

//Carrier
If w_do.idw_main.GetITemString(1,'Carrier') > "" Then
	
	//Carrier Name
	lscarrier = w_do.idw_main.GetITemString(1,'Carrier')
	
	Select Carrier_name into :lsCarrierName
	From Carrier_Master
	Where Project_id = :gs_project and Carrier_code = :lsCarrier;
	
	If lsCarrierName = "" or isnull(lsCarrierName) Then lsCarrierName = lsCarrier;
	
	i_dw_ship_label.SetItem(1,"Carrier",lsCarrierName)
End If

//Sales Order Nbr (UF6)
If w_do.idw_main.GetITemString(1,'User_Field6') > "" Then
	i_dw_ship_label.SetItem(1,"sales_order_nbr",Left(Upper(w_do.idw_main.GetITemString(1,'User_Field6')),30))
Else
//	i_dw_ship_label.SetItem(1,"sales_order_nbr","")
End If

//Customer Order Nbr
If w_do.idw_main.GetITemString(1,'Cust_order_No') > "" Then
	i_dw_ship_label.SetItem(1,"Cust_order_nbr",Left(Upper(w_do.idw_main.GetITemString(1,'Cust_order_No')),30))
Else
//	i_dw_ship_label.SetItem(1,"Cust_order_nbr","")
End If

//Delivery NUmber (Invoice No)
If w_do.idw_main.GetITemString(1,'Invoice_no') > "" Then
	i_dw_ship_label.SetItem(1,"Delivery_Number",Left(Upper(w_do.idw_main.GetITemString(1,'Invoice_no')),30))
End If

//AWB
If w_do.idw_Main.GetITemString(1,'awb_bol_no') > "" Then
	i_dw_ship_label.SetItem(1,"awb_bol_nbr",Left(w_do.idw_Main.GetITemString(1,'awb_bol_no'),30))
Else
//	i_dw_ship_label.SetItem(1,"awb_bol_nbr","")
End If


//Weight
If dw_label.getITemNumber(aiRow,'weight_gross') > 0 Then
	i_dw_ship_label.SetItem(1,"Weight",String(dw_label.getITemNumber(aiRow,'weight_gross')))
End If

//Box of...
i_dw_ship_label.SetItem(1,"Box",String(dw_label.getITemString(aiRow,'Box_Of')))

//Ship Date
If not isnull(w_do.idw_main.GetITemDateTime(1,'Complete_Date')) Then
	lsShipDate = String(w_do.idw_main.GetITemDateTime(1,'Complete_Date'),'DD-MMM-YYYY')
Else
	lsShipDate = String(Today(),'DD-MMM-YYYY')
End If
	
i_dw_ship_label.SetItem(1,"Ship_Date",lsShipDate)

//Carton Number
lsUCCCarton = dw_label.getITemString(aiRow,'carton_no')
i_dw_ship_label.SetItem(1,"carton_nbr_barcode",lsUccCarton)
i_dw_ship_label.SetItem(1,"carton_nbr",lsUccCarton)

//Swedish characters need to be 'cleansed'
//lsFormat = f_cleanse_printer(lsFormat)

//isLabels[llLabelPos] = lsFormat

PrintDataWindow ( alPrintJob, i_dw_ship_label )

//PrintClose(llPrintJob)

Return 0
end function

public function string uf_set_to_address_dw (ref datastore a_ds);Long	llAddressPos
String	lsAddr, lsCityState


//Ship To - Roll up if not all present
llAddressPos = 0

If w_do.idw_main.GetITemString(1,'cust_name') > ' ' Then
	llAddressPos ++
	lsAddr = "to_addr" + String(llAddressPos) 
	a_ds.SetItem(1, lsAddr,Left(w_do.idw_main.GetITemString(1,'cust_name'),30))
End If

If w_do.idw_main.GetITemString(1,'address_1') > ' ' Then
	llAddressPos ++
	lsAddr = "to_addr" + String(llAddressPos) 
	a_ds.SetItem(1,lsAddr,Left(w_do.idw_main.GetITemString(1,'address_1'),30))
End If

If w_do.idw_main.GetITemString(1,'address_2') > ' ' Then
	llAddressPos ++
	lsAddr = "to_addr" + String(llAddressPos) 
	a_ds.SetItem(1,lsAddr,Left(w_do.idw_main.GetITemString(1,'address_2'),30))
End If

If w_do.idw_main.GetITemString(1,'address_3') > ' ' Then
	llAddressPos ++
	lsAddr = "to_addr" + String(llAddressPos) 
	a_ds.SetItem(1,lsAddr,Left(w_do.idw_main.GetITemString(1,'address_3'),30))
End If

If w_do.idw_main.GetITemString(1,'address_4') > ' ' Then
	llAddressPos ++
	lsAddr = "to_addr" + String(llAddressPos) 
	a_ds.SetItem(1,lsAddr,Left(w_do.idw_main.GetITemString(1,'address_4'),30))
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
	lsAddr = "to_addr" + String(llAddressPos) 
	a_ds.SetItem(1,lsAddr,Left(lsCityState,30))
	
End If

If w_do.idw_main.GetITemString(1,'country') > ' ' Then
	llAddressPos ++
	lsAddr = "to_addr" + String(llAddressPos) 
	a_ds.SetItem(1,lsAddr,Left(w_do.idw_main.GetITemString(1,'country'),30))
End If

Return "" // lsFormat
end function

public function string uf_set_from_address_dw (ref datastore a_ds);
String	lsWarehouse, lsAddr, lsCityState
Long	llWarehouseRow, llAddressPos

//Ship From -> Warehouse address (Warehouse info retreived in Warehouse DS)
lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

//Roll up if not all present
If llWarehouseRow > 0 Then
	
	llAddressPos = 0

	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name') > ' ' Then
		llAddressPos ++
		lsAddr = "from_addr" + String(llAddressPos) 
		a_ds.SetItem(1,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'),30))
	End If
	
	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1') > ' ' Then
		llAddressPos ++
		lsAddr = "from_addr" + String(llAddressPos) 
		a_ds.SetItem(1,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'),30))
	End If

	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2') > ' ' Then
		llAddressPos ++
		lsAddr = "from_addr" + String(llAddressPos) 
		a_ds.SetItem(1,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'),30))
	End If

	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3') > ' ' Then
		llAddressPos ++
		lsAddr = "from_addr" + String(llAddressPos) 
		a_ds.SetItem(1,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'),30))
	End If

	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4') > ' ' Then
		llAddressPos ++
		lsAddr = "from_addr" + String(llAddressPos) 
		a_ds.SetItem(1,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'),30))
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
		lsAddr = "from_addr" + String(llAddressPos) 
		a_ds.SetItem(1,lsAddr,Left(lsCityState,30))
		
	End If
	
	If g.ids_project_warehouse.GetITemString(llWarehouseRow,'country') > ' ' Then
		llAddressPos ++
		lsAddr = "from_addr" + String(llAddressPos) 
		a_ds.SetItem(1,lsAddr,Left(g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'),30))
	End If
	
End If /*warehouse Found*/

Return ""
end function

on w_converse_shipping_labels.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_label=create dw_label
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
this.cbx_ship=create cbx_ship
this.cbx_carton_content=create cbx_carton_content
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_clear
this.Control[iCurrent+5]=this.cbx_ship
this.Control[iCurrent+6]=this.cbx_carton_content
end on

on w_converse_shipping_labels.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_selectall)
destroy(this.cb_clear)
destroy(this.cbx_ship)
destroy(this.cbx_carton_content)
end on

event ue_postopen;call super::ue_postopen;String	lsWarehouse

invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

cb_print.Enabled = False

IF not isvalid(w_do) Then
	Messagebox("Labels","You must have an open Delivery Order to print Shipping Labels.")
	Return
End If


cbx_Ship.Checked = True
cbx_carton_Content.Checked = True

This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;call super::ue_retrieve;String lsCArton, lsCartonSave,  lsCustomer
Long	llRowPos, llRowCOunt, llCartonCount, llCartonNo

If not isvalid(w_do) Then Return
If w_do.idw_main.RowCount() < 1 then return

dw_label.Retrieve(w_do.idw_main.GetITemString(1,'do_no'))

//See if we have an OEM label - from Custumer Master UF2...
lsCustomer = w_do.idw_main.GetITemString(1,'cust_code')


//Calculate Box of... First pass, get number of unique cartons
lLRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount

	lsCarton = dw_label.GEtITEmString(llRowPOs, 'carton_no')
	If lsCarton <> lscartonSave Then llCartonCount ++
	lsCartonSave = lscarton


NExt

//Second pass - assign...
lscartonSave = ""
For llRowPos = 1 to llRowCount

	lsCarton = dw_label.GEtITEmString(llRowPOs, 'carton_no')
	If lsCarton <> lscartonSave Then llCartonNo ++
	lsCartonSave = lscarton
		
//	dw_label.SetItem(lLRowPos,'box_of',String(llCartonNo) + " of " + String(llCartonCount))
	
Next

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

type cb_cancel from w_main_ancestor`cb_cancel within w_converse_shipping_labels
boolean visible = false
integer x = 1938
integer y = 1596
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_converse_shipping_labels
boolean visible = false
integer x = 2693
integer y = 52
integer height = 80
integer textsize = -9
boolean default = false
end type

type cb_print from commandbutton within w_converse_shipping_labels
integer x = 576
integer y = 52
integer width = 329
integer height = 80
integer taborder = 30
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

type dw_label from u_dw_ancestor within w_converse_shipping_labels
integer y = 208
integer width = 2990
integer height = 1340
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;
Choose Case Upper(dwo.name)
		
	Case "COUNTRY_OF_ORIGIN_DEFAULT"
		
		If data > "" Then
			
			If f_get_country_name(data) = "" Then
				Messagebox("Labels", "Invalid Country of Origin")
				Return 1
			End If
			
		End If
		
	case 'C_PRINT_IND'
		
		Parent.PostEvent('ue_check_Enable')
		
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event constructor;call super::constructor;
DatawindowChild	ldwc

This.GetChild('user_field11',ldwc)

ldwc.SetTransObject(SQLCA)

ldwc.Retrieve(gs_project,'PTLBL')
end event

event process_enter;call super::process_enter;
Send(Handle(This),256,9,Long(0,0))
end event

type cb_selectall from commandbutton within w_converse_shipping_labels
integer x = 37
integer y = 12
integer width = 338
integer height = 68
integer taborder = 20
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

type cb_clear from commandbutton within w_converse_shipping_labels
integer x = 37
integer y = 92
integer width = 338
integer height = 72
integer taborder = 30
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

type cbx_ship from checkbox within w_converse_shipping_labels
integer x = 1166
integer y = 24
integer width = 402
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Shipping"
end type

event clicked;Parent.TriggerEvent('ue_check_Enable')
end event

type cbx_carton_content from checkbox within w_converse_shipping_labels
integer x = 1166
integer y = 88
integer width = 503
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Carton Content"
end type

event clicked;Parent.TriggerEvent('ue_check_Enable')
end event

