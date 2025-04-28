HA$PBExportHeader$w_phx_brnds_can_can_label.srw
$PBExportComments$BCR 12-JAN-12: PhxBrands Can Can Label window
forward
global type w_phx_brnds_can_can_label from w_main_ancestor
end type
type cb_print from commandbutton within w_phx_brnds_can_can_label
end type
type st_1 from statictext within w_phx_brnds_can_can_label
end type
type sle_1 from singlelineedit within w_phx_brnds_can_can_label
end type
end forward

global type w_phx_brnds_can_can_label from w_main_ancestor
boolean visible = false
integer width = 3067
integer height = 1684
string title = "Can-Can Shipping Label"
string menuname = ""
event ue_print ( )
cb_print cb_print
st_1 st_1
sle_1 sle_1
end type
global w_phx_brnds_can_can_label w_phx_brnds_can_can_label

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
	
String	isLabels[], isOEMLabel, isPrintText, isShipFormat, isDoNo

Boolean ibPrinterSelected=FALSE

end variables

forward prototypes
public function integer uf_shipping_label (integer airow, string asformat)
public function string uf_set_from_address (string asformat)
public function string uf_set_to_address (string asformat)
end prototypes

event ue_print();Str_Parms	lstrparms
n_labels	lu_labels
Long	 llRowPos, 	llPrintJob,  llLabelPos, llBeginRow, llEndRow
String 	lsPrintText, lsShipFormat, lsSKUFormat, lsCarton, lsCartonSave, lsOEMFormat, lsCustomer, lsNullLabel[]
Integer  liNoLabels, liCount




//Has Printer been selected?
IF NOT ibPrinterSelected THEN

	//Open printer options window
	OpenWithParm(w_label_print_options,iStrParms)
	istrparms = Message.PowerObjectParm		  
	If istrParms.Cancelled Then
		Return
	End If
	
	//Set printer selection boolean
	ibPrinterSelected = TRUE

END IF

//Open Printer File 
llPrintJob = PrintOpen(isPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Can-Can Labels', 'Unable to open Printer file. Labels will not be printed')
	Return
End If

//No of labels to print
liNoLabels = integer(sle_1.text)

//Shipping label for displayed data
uf_shipping_label(liNoLabels, isShipFormat) 

FOR liCount = 1 to UpperBound(isLabels)
	//Do the print
	PrintSend(llPrintJob, isLabels[liCount])
NEXT

//Close printer
PrintClose(llPrintJob)



end event

public function integer uf_shipping_label (integer airow, string asformat);String 	lsAddLetter, lsFormat, lsAddr, lsCityState, lsTemp, lsUCCPRefix, lsUCCCarton, lsCarrier, lsCarrierName
Long		lLWarehouseRow, llAddressPos, llLabelPos
Integer	liCheck, liCount



lsFormat = asFormat

FOR liCount = 1 TO airow
	
	//BCR 16-MAR-2012: Modified by deleting the 'A', 'B', 'C', etc. post-scripts
	
	//Call From/To Address functions
	lsFormat = uf_set_From_address(lsFormat)
	lsFormat = uf_set_to_address(lsFormat)
	
	//Carrier Name
	lsTemp = w_do.idw_other.GetITemString(1,'Carrier')
	lsFormat = invo_labels.uf_Replace(lsFormat,"~~carrier_name~~",lsTemp)
	
	//Order NO
	lsTemp = w_do.idw_main.GetITemString(1,'Invoice_No')	
	lsFormat = invo_labels.uf_Replace(lsFormat,"~~invoice_no~~",lsTemp)	
	
	//LMS Shipment ID
	lsTemp = w_do.idw_other.GetITemString(1,'User_Field4')	
	lsFormat = invo_labels.uf_Replace(lsFormat,"~~lms_id~~",lsTemp)	
	
	//Label No
	lsTemp = w_do.idw_other.GetITemString(1,'User_Field22')	
	lsFormat = invo_labels.uf_Replace(lsFormat,"~~label_no~~",lsTemp)	

	//Swedish characters need to be 'cleansed'
	lsFormat = f_cleanse_printer(lsFormat)
	
	isLabels[liCount] = lsFormat
	
	//Reset Format
	lsFormat = asFormat
NEXT

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

on w_phx_brnds_can_can_label.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.st_1=create st_1
this.sle_1=create sle_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_1
end on

on w_phx_brnds_can_can_label.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.st_1)
destroy(this.sle_1)
end on

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
IF ISVALID(n_labels) THEN Destroy(n_labels)
end event

event open;call super::open;invo_labels = Create n_labels


//Set print text
isPrintText = 'Can-Can Shipping Labels'

//Retrieive necessary formats
isShipFormat = invo_labels.uf_read_label_Format("Phx_Brands_Can-Can_Shipping_Label_UCC.txt")
end event

event ue_postopen;call super::ue_postopen;//We can only print based on DO_NO - User must have valid order open to pass DO_NO in from w_DO
If isVAlid(w_do) Then
	if w_do.idw_main.RowCOunt() > 0 Then
		isDoNo = w_do.idw_main.GetITemString(1,'do_no')
	End If
End If

If isNUll(isDONO) or  isDoNO = '' Then
	
	Messagebox('Can-Can Labels','You must have an order retrieved in the Delivery Order Window~rbefore you can print labels!')
	
	//Close window
	Close(THIS)
End If


end event

type cb_cancel from w_main_ancestor`cb_cancel within w_phx_brnds_can_can_label
integer x = 2606
integer y = 56
integer width = 274
integer height = 80
integer taborder = 0
string text = "&Close"
end type

type cb_ok from w_main_ancestor`cb_ok within w_phx_brnds_can_can_label
boolean visible = false
integer x = 1330
integer y = 1600
integer height = 80
integer taborder = 0
integer textsize = -9
boolean enabled = false
boolean default = false
end type

type cb_print from commandbutton within w_phx_brnds_can_can_label
integer x = 78
integer y = 52
integer width = 329
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;IF integer(sle_1.Text) <= 0 THEN 
	
	Messagebox('Can-Can Labels','You must enter number of labels to print~rbefore you can print labels!')
	
ELSE
	
	Parent.TriggerEvent('ue_Print')
	
End If





end event

type st_1 from statictext within w_phx_brnds_can_can_label
integer x = 78
integer y = 316
integer width = 471
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nbr of Labels :"
boolean border = true
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_phx_brnds_can_can_label
integer x = 567
integer y = 316
integer width = 402
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 1
borderstyle borderstyle = stylelowered!
end type

