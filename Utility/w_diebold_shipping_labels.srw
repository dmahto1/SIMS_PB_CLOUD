HA$PBExportHeader$w_diebold_shipping_labels.srw
$PBExportComments$Diebold Shipping labels
forward
global type w_diebold_shipping_labels from w_main_ancestor
end type
type cb_print from commandbutton within w_diebold_shipping_labels
end type
type dw_label from u_dw_ancestor within w_diebold_shipping_labels
end type
type cb_selectall from commandbutton within w_diebold_shipping_labels
end type
type cb_clear from commandbutton within w_diebold_shipping_labels
end type
end forward

global type w_diebold_shipping_labels from w_main_ancestor
boolean visible = false
integer width = 1330
integer height = 1340
string title = "Diebold Shipping Labels"
string menuname = ""
event ue_print ( )
event ue_check_enable ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_clear cb_clear
end type
global w_diebold_shipping_labels w_diebold_shipping_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
	
String	isLabels[], isOEMLabel, isModel, isItem, isSerialNo
Long	ilStartingBox


end variables

forward prototypes
public function integer uf_shipping_label (integer airow, string asformat)
public function string uf_set_from_address (string asformat)
public function string uf_set_to_address (string asformat)
public function integer wf_validate ()
public function integer uf_pto_label (integer airow, string asformat)
public function string uf_new_pto_header (integer airow, string asformat, string ascarton, string asboxof)
public function String uf_2char_country (string ascoo3)
end prototypes

event ue_print();Str_Parms	lstrparms
n_labels	lu_labels

Long	llRowCount, llRowPos, 	llPrintJob,  llLabelPos

String	lsPrintText, lsFormat, lsCarton, lsLineSave, lsCustomer, lsNullLabel[]

String	lsWarehouse, lsFormatSave, lsShipDate, lsCOO2, lsSKU, lsSalesOrder
Long		lLQty,  j

lu_labels = Create n_labels

Dw_Label.AcceptText()


isLabels = lsNullLabel /*clear any previous printed labels*/

//Retrieive necessary formats
lsFormatSave = lu_labels.uf_read_label_Format("diabold_shipping_Zebra.txt")

//Print each detail Row
llRowCount = dw_label.RowCount()

For llRowPos = 1 to llRowCount /*each detail row */
			
	If dw_label.GetITEmString(llRowPos,'c_select_ind') <> 'Y' Then Continue

	//Create a label for each of qty
	llQty = dw_label.GetITemNumber(llRowPos,'c_print_qty')

	For j = 1 to llQty 
	
		lsFormat = lsFormatSave
	
		llLabelPos = UpperBound(islabels) + 1

		lsFormat = uf_set_From_address(lsFormat)
		lsFormat = uf_set_to_address(lsFormat)


		//Sales Order Nbr - Strip off revision number (following '-') if present (should be)
		If Pos(w_do.idw_main.GetITemString(1,'Invoice_No'),'-') > 0 Then
			lsSalesOrder = Left(w_do.idw_main.GetITemString(1,'Invoice_No'),Pos(w_do.idw_main.GetITemString(1,'Invoice_No'),'-') - 1)
		Else
			lsSalesOrder = w_do.idw_main.GetITemString(1,'Invoice_No')
		End If
	
		lsFormat = invo_labels.uf_replace(lsFormat,"~~sales_order_nbr~~",lsSalesOrder)
		lsFormat = invo_labels.uf_replace(lsFormat,"~~sales_order_nbr_bc~~","1K" + lsSalesOrder) /* include data ID '1K' */
	
		//Customer Code
		If w_do.idw_main.GetITemString(1,'Cust_Code') > "" Then
			lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_code~~",Upper(w_do.idw_main.GetITemString(1,'Cust_Code')))
			lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_Code_bc~~","9V" + Upper(w_do.idw_main.GetITemString(1,'Cust_Code'))) /* include data ID '9V' */
		Else
			lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_code~~","")
			lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_Code_bc~~","")
		End If

		//Customer Order Nbr
		If w_do.idw_main.GetITemString(1,'Cust_order_No') > "" Then
			lsFormat = invo_labels.uf_replace(lsFormat,"~~Cust_order_nbr~~",Upper(w_do.idw_main.GetITemString(1,'Cust_order_No')))
			lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_order_nbr_bc~~","K" + Upper(w_do.idw_main.GetITemString(1,'Cust_order_No'))) /* include data ID 'K' */
		Else
			lsFormat = invo_labels.uf_replace(lsFormat,"~~Cust_order_nbr~~","")
			lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_order_nbr_bc~~","")
		End If

		//Ship Date
		If not isnull(w_do.idw_main.GetITemDateTime(1,'Complete_Date')) Then
			lsShipDate = String(w_do.idw_main.GetITemDateTime(1,'Complete_Date'),'MM/DD/YY')
		Else
			lsShipDate = String(Today(),'MM/DD/YY')
		End If
	
		lsFormat = invo_labels.uf_replace(lsFormat,"~~Ship_Date~~",lsShipDate)
	
		//Item Number
		If isItem > '' Then
			lsFormat = invo_labels.uf_replace(lsFormat,"~~item~~",isItem)
			lsFormat = invo_labels.uf_replace(lsFormat,"~~item_bc~~","P" + isItem) /*include data identifier of "P" */
		End If
		
		//Model
		If isModel > '' Then
			lsFormat = invo_labels.uf_replace(lsFormat,"~~model~~",isModel)
			lsFormat = invo_labels.uf_replace(lsFormat,"~~model_bc~~","1P" + isModel) /*include data identifier of "1P" */
		End If
		
		//Serial Number
		If isSerialNo > '' Then
			lsFormat = invo_labels.uf_replace(lsFormat,"~~serial_no~~",isSerialNo)
			lsFormat = invo_labels.uf_replace(lsFormat,"~~serial_no_bc~~","S" + isSerialNo) /*include data identifier of "S" */
		End If
		
	
		//Carton Number
		lsFormat = invo_labels.uf_replace(lsFormat,"~~carton_nbr~~",dw_label.GetITemString(llRowPos,'carton_no')) 
		lsFormat = invo_labels.uf_replace(lsFormat,"~~carton_nbr_barcode~~","1T" + dw_label.GetITemString(llRowPos,'carton_no')) /*include data identifier of "1T" */
	
		//Dock Code (UF2)
		If w_do.idw_main.GetITemString(1,'USer_field2') > "" Then
			lsFormat = invo_labels.uf_replace(lsFormat,"~~dock_Code~~",Upper(w_do.idw_main.GetITemString(1,'USer_field2')))
		End If
			
		//special characters need to be 'cleansed'
		lsFormat = f_cleanse_printer(lsFormat)

		isLabels[llLabelPos] = lsFormat
	
	
	Next /*qty of label */
	
Next /*detail row to Print*/



//Send the format(s) to the printer...
If upperBound(isLabels) > 0  Then
		
	OpenWithParm(w_label_print_options,lStrParms)
	Lstrparms = Message.PowerObjectParm		  
	If lstrParms.Cancelled Then
		Return
	End If
				
	lsPrintText = 'Diebold Shipping Labels '

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
		

end event

event ue_check_enable();
//Print button enabled if 1 or more rows and at least one label checked

If dw_label.Find("C_select_Ind = 'Y'",1, dw_label.RowCount()) > 0  Then
	cb_print.Enabled = True
Else
	cb_print.Enabled = False
End If


end event

public function integer uf_shipping_label (integer airow, string asformat);String	lsWarehouse, lsFormat, lsShipDate, lsCOO2, lsSKU, lsSalesOrder
Long		llLabelPos, lLQty,  j




//Create a label for each of qty
llQty = dw_label.GetITemNumber(aiRow,'c_print_qty')


For j = 1 to llQty 
	
	lsFormat = asFormat
	
	llLabelPos = UpperBound(islabels) + 1

	lsFormat = uf_set_From_address(lsFormat)
	lsFormat = uf_set_to_address(lsFormat)


	//Sales Order Nbr - Strip off revision number (following '-') if present (should be)
	If Pos(w_do.idw_main.GetITemString(1,'Invoice_No'),'-') > 0 Then
		lsSalesOrder = Left(w_do.idw_main.GetITemString(1,'Invoice_No'),Pos(w_do.idw_main.GetITemString(1,'Invoice_No'),'-') - 1)
	Else
		lsSalesOrder = w_do.idw_main.GetITemString(1,'Invoice_No')
	End If
	
	lsFormat = invo_labels.uf_replace(lsFormat,"~~sales_order_nbr~~",lsSalesOrder)
	lsFormat = invo_labels.uf_replace(lsFormat,"~~sales_order_nbr_bc~~","1K" + lsSalesOrder) /* include data ID '1K' */
	
	//Customer Code
	If w_do.idw_main.GetITemString(1,'Cust_Code') > "" Then
		lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_code~~",Upper(w_do.idw_main.GetITemString(1,'Cust_Code')))
		lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_Code_bc~~","9V" + Upper(w_do.idw_main.GetITemString(1,'Cust_Code'))) /* include data ID '9V' */
	Else
		lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_code~~","")
		lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_Code_bc~~","")
	End If

	//Customer Order Nbr
	If w_do.idw_main.GetITemString(1,'Cust_order_No') > "" Then
		lsFormat = invo_labels.uf_replace(lsFormat,"~~Cust_order_nbr~~",Upper(w_do.idw_main.GetITemString(1,'Cust_order_No')))
		lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_order_nbr_bc~~","K" + Upper(w_do.idw_main.GetITemString(1,'Cust_order_No'))) /* include data ID 'K' */
	Else
		lsFormat = invo_labels.uf_replace(lsFormat,"~~Cust_order_nbr~~","")
		lsFormat = invo_labels.uf_replace(lsFormat,"~~cust_order_nbr_bc~~","")
	End If

	//Ship Date
	If not isnull(w_do.idw_main.GetITemDateTime(1,'Complete_Date')) Then
		lsShipDate = String(w_do.idw_main.GetITemDateTime(1,'Complete_Date'),'MM/DD/YY')
	Else
		lsShipDate = String(Today(),'MM/DD/YY')
	End If
	
	lsFormat = invo_labels.uf_replace(lsFormat,"~~ship_date~~",lsShipDate)
	
	//SKU
	
		
		
	//COO
	If Len(dw_label.GetITemString(aiRow,'c_Coo')) = 3 Then
		lsCOO2 = uf_2char_Country(dw_label.GetITemString(aiRow,'c_Coo'))
	Else
		lsCOO2 = dw_label.GetITemString(aiRow,'c_Coo')
	End If
	
	lsFormat = invo_labels.uf_replace(lsFormat,"~~coo~~",lsCOO2)

	//Carton Number
	lsFormat = invo_labels.uf_replace(lsFormat,"~~carton_nbr~~",dw_label.GetITemString(aiRow,'carton_no')) 
	lsFormat = invo_labels.uf_replace(lsFormat,"~~carton_nbr_barcode~~","1T" + dw_label.GetITemString(aiRow,'carton_no')) /*include data identifier of "1T" */
	
	//special characters need to be 'cleansed'
	lsFormat = f_cleanse_printer(lsFormat)

	isLabels[llLabelPos] = lsFormat
	
	ilStartingBox ++
	
Next /*qty of label */

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

public function integer uf_pto_label (integer airow, string asformat);String	lsWarehouse, lsFormat, lsShipDate, lsSKU, presentation_str, lsSQL, lsErrText, dwsyntax_str
String	lsPackFind, lsTag, lsCarton, lsSkuPrev, lsCOO2
Long		llLabelPos, lLQty,  llPAckFindRow, llLineItemNo, llSerialPos, llSerialCount, llBOMFindRow
int		liPageCOunt, liPagePos,  liLabelSize, liCurrentLabel
Datastore	ldsBOM, ldsSerial


//Currently 22 component rows on a label page
liLabelSize = 22 

//We will have a label for each distinct carton ID (should be a single carton for each unit of qty - only 1 each per carton)

llLineITemNo = dw_label.GetITemNumber(aiRow,'Delivery_Detail_Line_Item_No')
lsSKU = dw_Label.GetITEmString(aiRow,'SKU')

//Retrieve Children components for Line - used for Child Qty
ldsBOM = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select sku_child, child_qty from Delivery_Bom " 
lsSQL += " Where do_no = '" + w_do.idw_main.GetITemString(1,'do_no') + "' and sku_parent = '" + lsSKU + "'"

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsBOM.Create( dwsyntax_str, lsErrText)
ldsBOM.SetTransObject(SQLCA)

ldsBom.Retrieve()


//Retrieve COO and Serial Numbers for LIne - Will Filter for child SKU and carton below
ldsSerial = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "SELECT dbo.Delivery_Picking_Detail.SKU as 'SKU', dbo.Delivery_Picking_Detail.Country_of_Origin as 'Country_of_Origin', dbo.Item_Master.Description as 'Description', dbo.Delivery_Serial_Detail.Serial_No as 'Serial_No',   "
lsSql +="  dbo.Delivery_Serial_Detail.carton_no as 'carton_no', 	Sum(Delivery_Picking_Detail.Quantity) as 'Quantity' " 
lsSQL += " FROM dbo.Delivery_Picking_Detail LEFT OUTER JOIN dbo.Delivery_Serial_Detail ON dbo.Delivery_Picking_Detail.ID_No = dbo.Delivery_Serial_Detail.ID_No, dbo.Item_Master "
lsSql += " WHERE ( dbo.Delivery_Picking_Detail.Supp_Code = dbo.Item_Master.Supp_Code ) and ( dbo.Delivery_Picking_Detail.SKU = dbo.Item_Master.SKU )    and "
lsSql += "	Item_Master.Project_id = 'Netapp' and "
lsSql += "	do_no = '" + w_do.idw_main.GetITemString(1,'do_no') + "' and Line_Item_No = " + String(llLineITemNo)
lsSQL += " and Delivery_picking_Detail.sku <> delivery_Picking_Detail.sku_parent " /*only want children*/
lsSql += " Group By dbo.Delivery_Picking_Detail.SKU, dbo.Delivery_Picking_Detail.Country_of_Origin, dbo.Item_Master.Description, dbo.Delivery_Serial_Detail.Serial_No,   dbo.Delivery_Serial_Detail.carton_no "

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsSerial.Create( dwsyntax_str, lsErrText)
ldsSerial.SetTransObject(SQLCA)

llSerialCOunt = ldsSerial.Retrieve()
ldsSerial.SetSort("Sku A, Serial_No A")
ldsSerial.Sort()

//TODO - calculate the number of labels required to print all rows for "Box of" label
liPageCount = llSerialCount / liLabelSize
If lLSerialCount > 0 Then
	If Mod(liLabelSize,llSerialCount) > 0 Then liPageCount ++
End If

//Loop for each carton for this line
lsPackFind = "Line_Item_No = " + String(llLineItemNo) + " and sku = '" + lsSKU + "'"
llPackFindRow = w_do.idw_Pack.Find(lsPAckFind, 1, w_do.idw_Pack.RowCount())

// We should now have a carton for each label already, no need to loop for carton
//Do While llPAckFindRow > 0 /* For each Carton */
	
	liCurrentLabel = 1

//	lsCarton = w_do.idw_PAck.GetITemString(llPAckFindRow,'carton_no')
	lsCarton = dw_label.GetITemString(aiRow,'carton_no')
	
	//New Label (with header information) for new carton...
	If lsFormat <> asFormat Then
		
		lsFormat = f_cleanse_printer(lsFormat) /* cleanse any special characters*/
		isLabels[ UpperBound(islabels) + 1] = lsFormat
		
		lsFormat = uf_new_pto_header(aiRow, asFormat,lsCarton, String(liCurrentLabel) + " of " + String(liPageCount))
		
	End If
	
	liPagePos = 0 /* current label print line */
	
	//Write component level details - Filter serial numbers for Carton
	ldsSerial.SetFilter("Upper(Carton_no) = '" + Upper(lsCarton) + "' or carton_no = '' or isnull(carton_no)")
	ldsSerial.Filter()
				
	//For Each Coo/Serial Number
	llSerialCount = ldsSerial.RowCount()
	For llSerialPos = 1 to llSerialCount
			
		liPagePos ++
		
		If liPagePos > liLabelSize Then
			
			liCurrentLabel ++
			
			lsFormat = f_cleanse_printer(lsFormat) /* cleanse any special characters*/
			isLabels[ UpperBound(islabels) + 1] = lsFormat
		
			lsFormat = uf_new_pto_header(aiRow, asFormat,lsCarton, String(liCurrentLabel) + " of " + String(liPageCount)) /*TODO - calc label of */
			
			liPagePos = 1
			
		End If
			
		//load component data - supress repeating values (child SKU and Desc) sum qty in firt row for all serial numbers if present
		If (lsSKUPrev <> ldsSerial.GetITEmString(llSerialPos,'sku')) or liPagePos = 1 Then
			
			//Child SKU
			lsTag = "~~comp_item_" + String(liPagePos) + "~~"
			lsFormat = invo_labels.uf_replace(lsFormat,lsTag,ldsSerial.GetITEmString(llSerialPos,'sku'))
		
			//Child qty
			lsTag = "~~qty_" + String(liPagePos) + "~~"
						
			//Find Child Qty in BOM DS
			llBOMFindRow = ldsBom.Find("Upper(sku_Child) = '" + Upper(ldsSerial.GetITEmString(llSerialPos,'sku')) + "'",1,ldsBom.RowCount())
			If llBomFindRow > 0 Then
				lsFormat = invo_labels.uf_replace(lsFormat,lsTag,String(ldsBom.GetITEmNumber(llBomFindRow,'child_qty')))
			Else /*not found, should never happen (which means it will!)*/
				lsFormat = invo_labels.uf_replace(lsFormat,lsTag,"1")
			End If
					
			//Description
			lsTag = "~~desc_" + String(liPagePos) + "~~"
			lsFormat = invo_labels.uf_replace(lsFormat,lsTag,ldsSerial.GetITEmString(llSerialPos,'description'))
		
		End If /*suppressing repeating values for SKU */
		
		lsSKUPrev = ldsSerial.GetITEmString(llSerialPos,'sku') 
		
		//Serial Number
		lsTag = "~~sn_" + String(liPagePos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsTag,ldsSerial.GetITEmString(llSerialPos,'serial_no'))
		
		//COO - If 3 char, we need to convert to 2 char
		If Len(ldsSerial.GetITEmString(llSerialPos,'country_of_Origin')) = 3 Then
			lsCOO2 = uf_2char_country(ldsSerial.GetITEmString(llSerialPos,'country_of_Origin'))
		Else
			lsCOO2 = ldsSerial.GetITEmString(llSerialPos,'country_of_Origin')
		End If
		
		lsTag = "~~coo_" + String(liPagePos) + "~~"
		lsFormat = invo_labels.uf_replace(lsFormat,lsTag,lsCOO2)
		
		
	Next //Next Serial Number
		
	
//	//Check for next carton for LIne
//	If llPAckFindRow = w_do.idw_pack.RowCount() Then
//		llPAckFindRow = 0
//	Else
//		llPackFindRow++
//		llPackFindRow = w_do.idw_Pack.Find(lsPAckFind, llPAckFindRow, w_do.idw_Pack.RowCount())
//	End If
	
//Loop /* Next Carton */


//Write last/only format
lsFormat = f_cleanse_printer(lsFormat) /* cleanse any special characters*/
isLabels[ UpperBound(islabels) + 1] = lsFormat
	

Return 0
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

public function String uf_2char_country (string ascoo3);
String	lsCOO2

Select designating_code into :lsCOO2
From Country
Where iso_country_cd = :asCOO3;



Return lsCOO2
end function

on w_diebold_shipping_labels.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_label=create dw_label
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_clear
end on

on w_diebold_shipping_labels.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_selectall)
destroy(this.cb_clear)
end on

event ue_postopen;call super::ue_postopen;String	lsWarehouse

invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

cb_print.Enabled = False

IF not isvalid(w_do) Then
	Messagebox("Labels","You must have an open Delivery Order to print Shipping Labels.")
	Return
End If


This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;call super::ue_retrieve;String lsCArton, lsCartonSave,  lsCustomer, lsDONO, lsRONO, lsSKU, lsSOLine, lsCOO, lsDefaultCOO, lsRev, lsFind, lsItemType
Long	llRowPos, llRowCOunt, llCartonCount, llStartingBox, llLineItemNo, llFindRow

If not isvalid(w_do) Then Return
If w_do.idw_main.RowCount() < 1 then return

lsDONO = w_do.idw_main.GetITemString(1,'do_no')

dw_label.SetRedraw(False)
SetPointer(Hourglass!)

dw_label.Retrieve(lsDONO)

//We need to determine the Item and Model to use on the Label
//Item - Look for base unit in IM - Fac App CD (UF 1) = 3 or U. If doesn't exist, take Item for lowest Line ITem Number
//If we have a base Unit, The Model is postitions 6 - 8 of the SKU
Select Min(SKU) into :isItem
From Item_MAster where Project_id = 'Diebold' and user_Field1 in ('3', 'U') and SKU in (Select Sku from Delivery_Detail where do_no = :lsDONO);

If isItem > '' Then
	
	isModel = Mid(isItem,6,3)
	
Else
	
	isModel = 'N/A'
	
	Select Sku into :isItem
	From Delivery_Detail where do_no = :lsDONO and Line_Item_NO = (Select Min(Line_Item_No) from delivery_Detail where do_no = :lsDONO);
	
End If

//See if we have a Serial Number for the item...
If isItem > '' Then
	
	Select Serial_no into :isSerialNo
	From Delivery_Serial_Detail
	Where id_NO in (select Min(id_NO) from delivery_Picking_detail where do_no = :lsDONO and sku = :isItem);
	
End If

dw_label.SetRedraw(True)
SetPointer(Arrow!)

This.TriggerEvent('ue_check_enable')


end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_select_ind','Y')
Next

dw_label.SetRedraw(True)

This.TriggerEvent('ue_check_Enable')
dw_label.PostEvent("ue_set_boxcount") 

end event

event ue_unselectall;call super::ue_unselectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_select_ind','N')
Next

dw_label.SetRedraw(True)

This.TriggerEvent('ue_check_Enable')
dw_label.PostEvent("ue_set_boxcount") 
end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-250)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_diebold_shipping_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
integer taborder = 30
end type

type cb_ok from w_main_ancestor`cb_ok within w_diebold_shipping_labels
boolean visible = false
integer x = 878
integer y = 40
integer height = 80
integer textsize = -9
boolean default = false
end type

type cb_print from commandbutton within w_diebold_shipping_labels
integer x = 439
integer y = 40
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

type dw_label from u_dw_ancestor within w_diebold_shipping_labels
event ue_set_boxcount ( )
integer x = 9
integer y = 188
integer width = 1161
integer height = 968
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_diebold_label_grid"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_set_boxcount();

Long	lLStartingBox, llRowPos, llRowCount, llCartonCount, llLastBoxCount

lLRowCount = This.RowCount()

This.AcceptText()

// 08/07 - PCONKL - Per Netapp's Keith Owen - Box Count Should reset for each Line


////Total Number of Boxes
//llCartonCount = 0
//For llRowPOs = 1 to llRowCount
//	
//	//Only bump up if not previously listed 
//	If llRowPos = 1 Then
//		//If This.GetITemString(1,'c_select_ind') = 'Y' Then
//			llCartonCount += This.GetITemNumber(llRowPos,'c_print_qty')
//		//End If
//	ElseIf  dw_Label.Find("Upper(carton_no) = '" + Upper(dw_label.GetITemString(llRowPos,'Carton_no')) + "'",1,(lLRowPos - 1)) = 0 Then
//		llCartonCount += This.GetITemNumber(llRowPos,'c_print_qty')
//	End If
//	
//NExt
//
////Set Starting Box and total carton count on each row - used for printing "box of "
//llStartingBox = 0
//llLAstBoxCount = 1
//
//For llRowPOs = 1 to llRowCount
//	
//	If This.GetITemString(llRowPOs,'c_select_ind') = 'Y' Then
//		
//		If llRowPos = 1 Then
//			If This.GetITemString(1,'c_select_ind') = 'Y' Then
//				llStartingBox += 1
//			End If
//		ElseIf  dw_Label.Find("Upper(carton_no) = '" + Upper(dw_label.GetITemString(llRowPos,'Carton_no')) + "' and c_select_ind = 'Y'",1,(lLRowPos - 1)) = 0 Then	
//		//	llStartingBox += This.GetITemNumber(llRowPos - 1,'c_print_qty')
//			llStartingBox += llLAstBoxCount
//		End If
//		
//		This.SetITem(llRowPOs,'c_starting_Box',llStartingBox)
//		This.SetITem(llRowPOs,'c_boxCount',lLCartonCount)
//		This.SetITem(llRowPOs,'c_box_of', String(lLStartingBox) + " of " + String(llCartonCount))
//			
//		llLAstBoxCount = This.GetITemNumber(llRowPos,'c_print_qty') /* used to calc starting of next checked carton above*/
//		
//	Else
//		
//		This.SetITem(llRowPOs,'c_box_of','')
//		
//	End If
//	
//NExt


end event

event itemchanged;call super::itemchanged;
Choose Case Upper(dwo.name)
		
			
	case 'C_SELECT_IND'
		
		Parent.PostEvent('ue_check_Enable')
		This.PostEvent("ue_set_boxcount") /*recalc box count*/
		
	case 'C_PRINT_QTY'
		
		This.PostEvent("ue_set_boxcount") /*recalc box count*/
		
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event process_enter;call super::process_enter;
//Send(Handle(This),256,9,Long(0,0))
end event

type cb_selectall from commandbutton within w_diebold_shipping_labels
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

type cb_clear from commandbutton within w_diebold_shipping_labels
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

