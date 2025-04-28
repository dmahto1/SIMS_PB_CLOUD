HA$PBExportHeader$w_diebold_container_labels.srw
$PBExportComments$Diebold Container (Putawy) Labels
forward
global type w_diebold_container_labels from w_main_ancestor
end type
type cb_print from commandbutton within w_diebold_container_labels
end type
type dw_label from u_dw_ancestor within w_diebold_container_labels
end type
type cb_selectall from commandbutton within w_diebold_container_labels
end type
type cb_clear from commandbutton within w_diebold_container_labels
end type
end forward

global type w_diebold_container_labels from w_main_ancestor
boolean visible = false
integer width = 1833
integer height = 1868
string title = "Print Diebold Container Labels"
string menuname = ""
event ue_print ( )
event ue_check_enable ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_clear cb_clear
end type
global w_diebold_container_labels w_diebold_container_labels

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

String	lsPrintText, lsLabel,  lsCarton, lsLine,lsLineSave, lsLinePrint, lsLinePrintTemp, lsNullLabel[], lsFind, lsFormat, lsLineLit

lu_labels = Create n_labels

Dw_Label.AcceptText()


isLabels = lsNullLabel /*clear any previous printed labels*/

//Retrieive necessary formats
lsLabel = lu_labels.uf_read_label_Format("Diebold_Container_Zebra.txt")

//Sort Putaway by Container/SO LIne
w_ro.idw_Putaway.SetSort("po_no2 A, po_no A")
w_ro.idw_Putaway.Sort()

//Print each detail Row
llRowCount = dw_label.RowCount()


For llRowPos = 1 to llRowCount /*each detail row */
			
	If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
	
	//For each Container (po_No2), we need a list of SO Lines (po_no) to print on the label 
	lsLineSave = ''
	lsLinePrint = ''
	llSoLineCOunt = 0
	
	llFindRow = w_ro.idw_Putaway.Find("Upper(po_no2) = '" + dw_Label.GetITemString(llRowPos,'container_id') + "'",1,w_ro.idw_Putaway.RowCount())
	Do While llFindRow > 0
		
		If w_ro.Idw_Putaway.GetITemString(llFindROw,'po_no') <> lsLineSave Then /* may have multiple putaway rows for same SO Line (po_no) */
			lsLinePrint += w_ro.Idw_Putaway.GetITemString(llFindROw,'po_no') + ","
			llSoLineCOunt ++
		End If
		
		lsLineSave = w_ro.Idw_Putaway.GetITemString(llFindROw,'po_no')
		
		llFindRow ++
		If llFindRow > w_ro.idw_Putaway.RowCount() Then
			llFindRow = 0
		Else
			llFindRow = w_ro.idw_Putaway.Find("Upper(po_no2) = '" + dw_Label.GetITemString(llRowPos,'container_id') + "'",llFindRow,w_ro.idw_Putaway.RowCount())
		End If
		
	Loop /*Next SO Line for Container */
	
	
	//replace placeholders on label - Loop For each Qty of label for "Box x of y"
	llPrintQty = dw_Label.GetITemNumber(llRowPos,'c_print_Qty')
	If isnull(llPrintQty) or llPrintQty = 0 Then llPrintQty = 1
	
	For llPrintPos = 1 to llPrintQty
	
		lsFormat = lsLabel /*start with new template for each label */
	
		//Container ID
		lsFormat = invo_labels.uf_replace(lsFormat,"~~container_ID_Barcode~~",dw_Label.GetITemString(llRowPos,'container_id'))
	
		//Sales Order
		lsFormat = invo_labels.uf_replace(lsFormat,"~~sales_order~~",dw_Label.GetITemString(llRowPos,'sales_order'))
	
		//SO Lines
	
		//We may need to split into multiple lines to print all on label - currenly 40 char per line
		
		llLineSize = 40
		
		If Len(lsLinePRint) > llLineSize Then
			
			//Print up to 4 lines..
			For llLinePOs = 1 to 4
				
				If Pos(lsLinePrint,',') > 0 and Len(lsLinePrint) >= llLineSize Then
					
					/*don't split a line in the middle*/
					If Pos(lsLinePrint,',',llLineSize) > 0 Then
						lsLinePrintTemp = Left(lsLinePrint,Pos(lsLinePrint,',',llLineSize)) 
					Else
						lsLinePrintTemp = lsLinePrint
					End If
					
				Else
					lsLinePrintTemp = Left(lsLinePrint,llLineSize)
				End If
				
				lsLineLit = "~~so_line_" + String(llLinePOs) + "~~"
				lsFormat = invo_labels.uf_replace(lsFormat,lsLineLit,lsLinePrintTemp)
				
				If Len(lsLinePrintTemp) = Len(lsLinePrint) Then Exit
				
				lsLinePrint = Mid(lsLinePrint,Len(lsLinePrintTemp) + 1)
							
			Next
						
		Else /*Single line only */
			
			If Right(lsLinePrint,1) = ',' Then /*strip off last comma*/
				lsLinePrint = Left(lsLinePrint,Len(lsLinePrint) - 1)
			End If
			
			lsFormat = invo_labels.uf_replace(lsFormat,"~~so_line_1~~",lsLinePrint)
			
		End If
		
		//Single or multiple Lines in SO Line Literal
		If llSoLineCount > 1 Then
			lsFormat = invo_labels.uf_replace(lsFormat,"~~so_line_literal~~","SO LINES: ")
		Else
			lsFormat = invo_labels.uf_replace(lsFormat,"~~so_line_literal~~","SO LINE: ")
		End If
	
		//Box of...
		lsFormat = invo_labels.uf_replace(lsFormat,"~~box_of~~","Box " + String(llPrintPos) + " of " + String(llPrintQty))
		
		llLabelPos = UpperBound(isLabels) + 1
		isLabels[llLabelPos] = lsFormat
		
	Next
	
Next /*detail row to Print*/



//Send the format(s) to the printer...
If upperBound(isLabels) > 0  Then
		
	OpenWithParm(w_label_print_options,lStrParms)
	Lstrparms = Message.PowerObjectParm		  
	If lstrParms.Cancelled Then
		Return
	End If
				
	lsPrintText = 'Diebold COntainer Labels '

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
		
//Resort Putaway back
w_ro.idw_Putaway.SetSort("Line_Item_No A, l_code A, sku_Parent A, component_no A, Component_Ind D, SKU, A, Container_ID A")
w_ro.idw_Putaway.Sort()
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

on w_diebold_container_labels.create
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

on w_diebold_container_labels.destroy
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

IF not isvalid(w_ro) Then
	Messagebox("Diebold Container Labels","You must have an open Receiving Order to print Container Labels.")
	Return
End If


This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;call super::ue_retrieve;String lsCArton, lsCartonSave,  lsRONO, lsSKU, lsSOLine,  lsFind
Long	llRowPos, llRowCOunt, llCartonCount, llLineItemNo, llFindRow

If not isvalid(w_ro) Then Return
If w_ro.idw_main.RowCount() < 1 then return


dw_label.SetRedraw(False)
SetPointer(Hourglass!)

//Insert a row for each Container (po_no2)/Sales order (Lot_no) combination on Putaway
llRowCount = w_ro.idw_Putaway.RowCount()
For llRowPos = 1 to llRowCount
	
	If dw_label.Find("Upper(container_id) = '" + Upper(w_ro.idw_Putaway.GetITemString(llRowPos,'po_no2')) + "' and Upper(sales_order) = '" +  Upper(w_ro.idw_Putaway.GetITemString(llRowPos,'lot_no')) + "'",1, dw_label.RowCount()) = 0 Then
		
		dw_label.InsertRow(0)
		dw_Label.SetItem(dw_label.RowCount(),'container_id',w_ro.idw_Putaway.GetITemString(llRowPos,'po_no2'))
		dw_Label.SetItem(dw_label.RowCount(),'sales_order',w_ro.idw_Putaway.GetITemString(llRowPos,'lot_no'))
		
		//User Field 1 may have a box count - if so, use to change print qty. otherwise default to 1
		If isNumber(w_ro.idw_Putaway.GetITemString(llRowPos,'user_field1')) Then
			dw_Label.SetItem(dw_label.RowCount(),'c_print_qty',Long(w_ro.idw_Putaway.GetITemString(llRowPos,'user_field1')))
		Else
			dw_Label.SetItem(dw_label.RowCount(),'c_print_qty',1)
		End If
		
	End If
	
Next /*Putaway Row*/


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

type cb_cancel from w_main_ancestor`cb_cancel within w_diebold_container_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
integer taborder = 30
end type

type cb_ok from w_main_ancestor`cb_ok within w_diebold_container_labels
boolean visible = false
integer x = 1216
integer y = 44
integer height = 80
integer textsize = -9
boolean default = false
end type

type cb_print from commandbutton within w_diebold_container_labels
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

type dw_label from u_dw_ancestor within w_diebold_container_labels
integer x = 9
integer y = 188
integer width = 1728
integer height = 1520
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_diebold_container_label"
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

type cb_selectall from commandbutton within w_diebold_container_labels
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

type cb_clear from commandbutton within w_diebold_container_labels
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

