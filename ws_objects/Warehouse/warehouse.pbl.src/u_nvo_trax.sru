$PBExportHeader$u_nvo_trax.sru
$PBExportComments$Trax Functions
forward
global type u_nvo_trax from nonvisualobject
end type
end forward

global type u_nvo_trax from nonvisualobject
end type
global u_nvo_trax u_nvo_trax

type prototypes
FUNCTION boolean CopyFile(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll" ALIAS for "CopyFileA;Ansi"
Function boolean MoveFile (ref string lpExistingFileName, ref string lpNewFileName ) LIBRARY "kernel32.dll" ALIAS FOR "MoveFileA;Ansi"
end prototypes

type variables
inet	linit
u_nvo_websphere_post	iuoWebsphere
boolean ibOpenPrintDialog 

n_cryptoapi in_crypto  // ET3 2012-11-27 implementing base64 encoding-decoding
end variables

forward prototypes
public function integer uf_ship_shipment (ref datawindow adw_packing)
public function integer uf_validate_do (ref datawindow adw_main, ref datawindow adw_packing)
public function integer uf_validate_bp (ref datawindow adw_trax, ref datawindow adw_detail, ref datawindow adw_packing)
public function integer uf_process_eod (ref datawindow adw_eod)
public function string uf_retrieve_label (string aslabelid, string aslabeltype)
public function integer uf_print_label (string aslabel)
public function integer uf_void_shipment (ref datawindow adw_main, ref datawindow adw_packing)
public function integer uf_print_eod_manifest (string aslabelid, string aslabeltype)
public function string uf_retrieve_label_dp (string aslabelid, string asdono)
end prototypes

public function integer uf_ship_shipment (ref datawindow adw_packing);
Long 		llRowPos, llRowCount, llOrderCount
String	lsXML, lsDONO, lsDONOHold, lsCarton,  lsReturnCode, lsReturnDesc, lsXMLResponse, lsCrap, lsFinalREpsonse, lsPrinter
Boolean	lbValid, lbShipmentError
u_nvo_websphere_post	lu_websphere

lu_websphere = Create u_nvo_websphere_post

lsDONOHold = ""

	// 01/11 - PCONKL - If a printer override selected, pass in header
	If isValid(w_batch_pick) Then
		lsPrinter = w_batch_Pick.tab_main.tabpage_trax.ddlb_Trax_Printer.Text
	End If
	
	//add the Header segment
	If lsPrinter > '' Then
		//lsXML = lu_websphere.uf_request_header("TraxShipShipmentRequest", "Printer='" + lsPrinter + "'") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
		lsXML = lu_websphere.uf_request_header("CSShipShipmentRequest", "Printer='" + lsPrinter + "'") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
		
	Else
		//lsXML = lu_websphere.uf_request_header("TraxShipShipmentRequest") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
		lsXML = lu_websphere.uf_request_header("CSShipShipmentRequest") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
	End IF

	//For each selected Packing row, create an XML segment to pass to Websphere
	llRowCount = adw_PAcking.RowCount()
	For llRowPos = 1 to llRowCount
	
		lsDONO = adw_Packing.GetItemString(llRowPos,'do_no')
		lsCarton = adw_Packing.GetItemString(llRowPos,'carton_no')
	
		If adw_packing.GetITemString(llRowPos,'c_select_ind') <>  'Y' or &
			adw_packing.GetITemString(llRowPos,'c_select_ind') =  '' or &
			isNull(adw_packing.GetITemString(llRowPos,'c_select_ind')) Then Continue /*Skip if not checked*/
		
		//TAM 2007/11/01 Check Tracking_ID_Type.  We will allow a Trax call if the tracking number was not assigned by trax.
		If not isnull(adw_packing.GetITemString(llRowPos,'Tracking_ID_Type')) and adw_packing.GetITemString(llRowPos,'Tracking_ID_Type') > '' Then Continue /*Can't void if Tracking ID assigned*/
	//	If not isnull(adw_packing.GetITemString(llRowPos,'Shipper_tracking_ID')) and adw_packing.GetITemString(llRowPos,'Shipper_tracking_ID') > '' Then Continue /*Can't void if Tracking ID assigned*/

		//If DO_NO changes, build the header/footer segments for this DO_NO
		//We will only have more than 1 DO_NO if coming from batch Picking
	
		If lsDONO <> lsDONOHold Then
			
			llOrderCount ++
		
			//If not the first one, add a footer for the Delivery Order Segment
			If lsDONOHold > "" Then
				lsXML += "</Carton></RequestDeliveryOrder>"
			End If
		
			//iF we have sent more than 20 orders (and still more to print), send what we have - We don't want to time out
			If llOrdercount > 10 and llRowPos < llRowCount Then
				
				//add a footer to the existinbg File
				lsXML = lu_websphere.uf_request_footer(lsXML)
				
				//Post the Current File
				//w_main.setMicroHelp("Connecting to TRAX server...")  // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
				w_main.setMicroHelp("Connecting to ConnectShip server...") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 

				//post the transaction to Websphere
				lsXMLResponse = lu_websphere.uf_post_url(lsXML)
				
				//PRocess the Repsonse
				w_main.setMicroHelp("Ready")
				
				//If we didn't receive an XML back, there is a fatal exception error
				If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
					Messagebox("Websphere Fatal Exception Error",lsXMLResponse,StopSign!)
					Return -1
				End If
				
				//Check the return code and return description for any trapped errors
				lsReturnCode = lu_websphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
				lsReturnDesc = lu_websphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")
				
				If lsReturnCode = "-99" THen/* Websphere non fatal exception error*/
				
					Messagebox("Websphere Operational Exception Error",lsReturnDesc,StopSign!)
					Return -1
					
				ElseIf lsReturnCode = "-1" Then /* unable to assign tracking ID to one or more cartons*/
					
					lbShipmentError = True
					
					If lsReturnDesc  > '' Then
						lsFinalREpsonse += "~r" +lsReturnDesc
					End IF
					
				End IF
				
				//Create a new Header
				//lsXML = lu_websphere.uf_request_header("TraxShipShipmentRequest")
				
				If lsPrinter > '' Then
					//lsXML = lu_websphere.uf_request_header("TraxShipShipmentRequest", "Printer='" + lsPrinter + "'") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
					lsXML = lu_websphere.uf_request_header("CSShipShipmentRequest", "Printer='" + lsPrinter + "'") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
					
				Else
					//lsXML = lu_websphere.uf_request_header("TraxShipShipmentRequest") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
					lsXML = lu_websphere.uf_request_header("CSShipShipmentRequest") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
				End IF
				
				llOrderCOunt = 0
				
			End IF /* Multiple orders/calls to TRAX*/
			
			//Add the new header segment
			lsXML += "<RequestDeliveryOrder><DONO>" + lsDONO + "</DONO><Carton>"
		
		End If /*DONO changed */
	
		//Add the Carton header/Detail - including project ID as prefix to be unique across all of TRAX
		lsXML += "<CartonNumber>" + gs_project + lsCarton + "</CartonNumber>"
	
		lsDOnoHold = lsDONO
		lbvalid = True
	
	Next /*Packing row */

	If not lbvalid Then
		//Messagebox("TRAX", "There are no cartons to Ship in TRAX!")
		Messagebox("TRAX", "There are no cartons to Ship in ConnectShip!") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
		Return 0
	End IF

	//Add the carton and Order Footer Segments
	lsXML += "</Carton></RequestDeliveryOrder>"

	//Add the footer
	lsXML = lu_websphere.uf_request_footer(lsXML)

	//w_main.setMicroHelp("Connecting to TRAX server...")
	w_main.setMicroHelp("Connecting to ConnectShip server...") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 

	//post the transaction to Websphere
	lsXMLResponse = lu_websphere.uf_post_url(lsXML)

	

	w_main.setMicroHelp("Ready")

	//Process the response...

	//If we didn't receive an XML back, there is a fatal exception error
	If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
		Messagebox("Websphere Fatal Exception Error",lsXMLResponse,StopSign!)
		Return -1
	End If

	//Check the return code and return description for any trapped errors
	lsReturnCode = lu_websphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
	lsReturnDesc = lu_websphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

	Choose Case lsReturnCode
		
		Case "-99" /* Websphere non fatal exception error*/
		
			Messagebox("Websphere Operational Exception Error",lsReturnDesc,StopSign!)
			Return -1

		Case "-1" /* unable to assign tracking ID to one or more cartons*/
		
			If lsReturnDesc > '' Then
				//Messagebox("TRAX Shipment error", lsFinalREpsonse + "~r" + lsReturnDesc)
				Messagebox("ConnectShip Shipment error", lsFinalREpsonse + "~r" + lsReturnDesc) // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
			Else
				//Messagebox("TRAX Shipment error", "One or more Shipments generated an error in TRAX.")
				Messagebox("ConnectShip Shipment error", "One or more Shipments generated an error in ConnectShip.") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
			End If
		
		Case Else
		
			If lsReturnDesc > '' Then
				Messagebox("",lsReturnDesc)
			Else
			//	Messagebox("", "TRAX SHIPMENT call Successful")
			End If
			
	End Choose

	//If error from previos call but not current, show msgbox
	if lbShipmentError and lsReturnDesc <> "-1" Then
		
		If lsFinalREpsonse > '' Then
			//Messagebox("TRAX Shipment error", lsFinalREpsonse)
			Messagebox("ConnectShip Shipment error", lsFinalREpsonse) // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
		Else
			//Messagebox("TRAX Shipment error", "One or more Shipments generated an error in TRAX.")
			Messagebox("ConnectShip Shipment error", "One or more Shipments generated an error in ConnectShip.")// Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
		End If
		
	End If

Return 0
end function

public function integer uf_validate_do (ref datawindow adw_main, ref datawindow adw_packing);
String	lsError, lsCarton, lsCartonHold
Long	llRowCount, llRowPos

//validate required fields on Delivery Order before sending ship request to TRAX

adw_main.AcceptText()
adw_Packing.AcceptText()

lsError = ""

//Carrier required
If isnull(adw_main.GetITemString(1,'Carrier')) or adw_main.GetITemString(1,'Carrier') = '' Then
	lsError += "~r-Carrier is required."
End If

//At least one address row is required
If (isnull(adw_main.GetITemString(1,'address_1')) or adw_main.GetITemString(1,'address_1') = '') and &
	(isnull(adw_main.GetITemString(1,'address_2')) or adw_main.GetITemString(1,'address_2') = '') and &
	(isnull(adw_main.GetITemString(1,'address_3')) or adw_main.GetITemString(1,'address_3') = '') and &
	(isnull(adw_main.GetITemString(1,'address_4')) or adw_main.GetITemString(1,'address_4') = '') Then
	
		lsError += '~r-At least one address row is required!'
			
End If

//City required
If isnull(adw_main.GetITemString(1,'City')) or adw_main.GetITemString(1,'City') = '' Then
	lsError += '~r-City is required!'
End If

//State required
//TAM 10/24/2007 remove state as a requirement.  Europe doesn't use this
//If isnull(adw_main.GetITemString(1,'State')) or adw_main.GetITemString(1,'State') = '' Then
//	lsError += '~r-State is required!'
//End If

//Zip required
//TAM 1/17/2011 remove state as a requirement.  Hong Kong doesn't use this
//If isnull(adw_main.GetITemString(1,'Zip')) or adw_main.GetITemString(1,'Zip') = '' Then
//	lsError += '~r-Zip is required!'
//End If

If lsError > '' Then lsError += "~r" 

//validate PAcking level fields
lLRowCount = adw_Packing.RowCount()
For llRowPos = 1 to llRowCount
	
	If adw_Packing.GetItemString(llRowPos,'c_select_Ind') <> 'Y' Then Continue /* don't validate rows not being shipped*/
	
	//DIMS and weight are required - we only need to validate the first row of a carton
	
	lsCarton = adw_Packing.GetItemString(llRowPos,'carton_no')
	
	If lsCarton = lsCartonHold Then Continue /*no need to validate more than the first row of a carton*/
	
	If adw_Packing.GetItemNumber(llRowPos,'length') = 0 or isNull(adw_Packing.GetItemNumber(llRowPos,'length')) Then
		lsError += '~r- Carton ' + lscarton +  ' Packing List Length is required!'
	End If
	
	If adw_Packing.GetItemNumber(llRowPos,'width') = 0 or isNull(adw_Packing.GetItemNumber(llRowPos,'width')) Then
		lsError += '~r- Carton ' + lscarton +  ' Packing List Width is required!'
	End If
	
	If adw_Packing.GetItemNumber(llRowPos,'height') = 0 or isNull(adw_Packing.GetItemNumber(llRowPos,'height')) Then
		lsError += '~r- Carton ' + lscarton +  ' Packing List Height is required!'
	End If
	
	If adw_Packing.GetItemNumber(llRowPos,'weight_Gross') = 0 or isNull(adw_Packing.GetItemNumber(llRowPos,'weight_Gross')) Then
		lsError += '~r- Carton ' + lscarton +  ' Packing List Gross Weight is required!'
	End If
	
	lscartonHold = lsCarton
	
Next /*packing Row */

If lsError > "" Then
	Messagebox("ConnectShip Validation errors",lsError,StopSign!) // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
	//Messagebox("TRAX Validation errors",lsError,StopSign!)
	Return -1
End If


Return 0
end function

public function integer uf_validate_bp (ref datawindow adw_trax, ref datawindow adw_detail, ref datawindow adw_packing);
String	lsError, lsInvoice, lsInvoiceHold, lscarton, lscartonHold
Long		llFindRow, llRowCount, llRowPos

//validate required fields on Batch Picking before sending ship request to TRAX

adw_detail.AcceptText()

lsError = ""

//For each TRAX/Carton Row, if order changes, validate header information
llRowCount = adw_trax.RowCount()
for llRowPos = 1 to llRowCount
	
	If adw_Trax.GetItemString(llRowPos,'c_select_Ind') <> 'Y' Then Continue
	
	//If we have already assigned a tracking Number, uncheck
	If (not isnull(adw_trax.GetITemString(llRowpos,'shipper_tracking_id'))) and &
		adw_trax.GetITemString(llRowpos,'shipper_tracking_id') > "" Then
		
			adw_trax.SetITem(lLRowPos,'c_select_ind','N')
		
	End If
	
	lsInvoice = adw_trax.GetITemString(llRowpos,'invoice_no')
	
	//Only need to validate header once per order
	If lsInvoice = lsInvoiceHold Then Continue
	
	lsInvoiceHold = lsInvoice
	
	//Find the correct detail row
	llFindrow = adw_detail.Find("Upper(Invoice_no) = '" + Upper(lsInvoice) + "'",1,adw_detail.RowCount())
	If llFindRow <=0 Then 
		lsError = "Line " + String(lLRowPos) + ", Order " + lsInvoice + ", No Order Header/Detail information found."
		Exit
	End If

	//Status must be PAcking
	If  adw_detail.GetITemString(llFindROw,'Ord_status') <> 'A' Then
		lsError += "~r- Order " + lsInvoice + ", Status must be 'Packing'."
	End If
	
	//Carrier required
	If isnull(adw_detail.GetITemString(llFindRow,'Carrier')) or adw_detail.GetITemString(llFindRow,'Carrier') = '' Then
		lsError += "~r- Order " + lsInvoice + ", Carrier is required."
	End If

	//At least one address row is required
	If (isnull(adw_detail.GetITemString(llFindRow,'address_1')) or adw_detail.GetITemString(llFindRow,'address_1') = '') and &
		(isnull(adw_detail.GetITemString(llFindRow,'address_2')) or adw_detail.GetITemString(llFindRow,'address_2') = '') and &
		(isnull(adw_detail.GetITemString(llFindRow,'address_3')) or adw_detail.GetITemString(llFindRow,'address_3') = '') and &
		(isnull(adw_detail.GetITemString(llFindRow,'address_4')) or adw_detail.GetITemString(llFindRow,'address_4') = '') Then
	
			lsError += '~r- Order " + lsInvoice + ", At least one address row is required!'
			
	End If

	//City required
	If isnull(adw_detail.GetITemString(llFindRow,'City')) or adw_detail.GetITemString(llFindRow,'City') = '' Then
		lsError += '~r- Order " + lsInvoice + ", City is required!'
	End If

	//State required
//TAM 10/24/2007 remove state as a requirement.  Europe doesn't use this
//	If isnull(adw_detail.GetITemString(llFindRow,'State')) or adw_detail.GetITemString(llFindRow,'State') = '' Then
//		lsError += '~r- Order " + lsInvoice + ", State is required!'
//	End If

	//Zip required
	If isnull(adw_detail.GetITemString(llFindRow,'Zip')) or adw_detail.GetITemString(llFindRow,'Zip') = '' Then
		lsError += '~r- Order " + lsInvoice + ", Zip is required!'
	End If
	
Next /*selected Trax Row*/

If lsError > '' Then lsError += "~r" 

//validate PAcking level fields
lLRowCount = adw_Packing.RowCount()
For llRowPos = 1 to llRowCount
	
	//DIMS and weight are required - we only need to validate the first row of a carton
	
	lsCarton = adw_Packing.GetItemString(llRowPos,'carton_no')
	lsInvoice = adw_Packing.GetItemString(llRowPos,'invoice_no')
	
	If lsCarton = lsCartonHold Then Continue /*no need to validate more than the first row of a carton*/
	
	If adw_Packing.GetItemNumber(llRowPos,'length') = 0 or isNull(adw_Packing.GetItemNumber(llRowPos,'length')) Then
		lsError += '~r- Order ' + lsInvoice + ',  Carton ' + lscarton +  ' Packing List Length is required!'
	End If
	
	If adw_Packing.GetItemNumber(llRowPos,'width') = 0 or isNull(adw_Packing.GetItemNumber(llRowPos,'width')) Then
		lsError += '~r- Order ' + lsInvoice + ',  Carton ' + lscarton +   ' Packing List Width is required!'
	End If
	
	If adw_Packing.GetItemNumber(llRowPos,'height') = 0 or isNull(adw_Packing.GetItemNumber(llRowPos,'height')) Then
		lsError += '~r- Order ' + lsInvoice + ',  Carton ' + lscarton +  ' Packing List Height is required!'
	End If
	
	If adw_Packing.GetItemNumber(llRowPos,'weight_Gross') = 0 or isNull(adw_Packing.GetItemNumber(llRowPos,'weight_Gross')) Then
		lsError += '~r- Order ' + lsInvoice + ',  Carton ' + lscarton +   ' Packing List Gross Weight is required!'
	End If
	
	lscartonHold = lsCarton
	
Next /*packing Row */

If lsError > "" Then
	Messagebox("ConnectShip Validation errors",lsError,StopSign!) // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
	//Messagebox("TRAX Validation errors",lsError,StopSign!)
	Return -1
End If

Return 0
end function

public function integer uf_process_eod (ref datawindow adw_eod);//Create an End of Day transaction to Websphere for one or more carriers

Long		llRowCount, llRowPos, llBeginPos, llEndPos
String	lsXML, lsXMLResponse, lsReturnCode, lsReturnDesc, lsBeginTag, lsEndTag, lsBatchID, lsLabels, lsWarehouse, lsLocale
Boolean	lbvalid
integer  lirc

u_nvo_websphere_post	lu_websphere

lu_websphere = Create u_nvo_websphere_post

//add the Header segment
lsXML = lu_websphere.uf_request_header("TraxEODShipmentRequest")

//For each selected Carrier row, create an XML segment to pass to Websphere
llRowCount = adw_eod.RowCount()
For llRowPos = 1 to llRowCount

	If adw_eod.GetITemString(llRowPos,'c_select_ind') <>  'Y' or &
		adw_eod.GetITemString(llRowPos,'c_select_ind') =  '' or &
		isNull(adw_eod.GetITemString(llRowPos,'c_select_ind')) Then Continue /*Skip if not checked*/
		
	lsXML += "<EOD>"
	lsXML += "<Project>" + adw_eod.GetITemString(llRowPos,'project_id') + "</Project>"
	lsXML += "<Warehouse>" + adw_eod.GetITemString(llRowPos,'wh_code') + "</Warehouse>"
	lsXML += "<Carrier>" + adw_eod.GetITemString(llRowPos,'carrier_master_trax_carrier_Code') + "</Carrier>"
	lsXML += "<FromDate>" + String(adw_eod.GetITemDateTime(llRowPos,'begin_eod_Date'),"MM/dd/yyyy HH:mm") + "</FromDate>"
	lsXML += "<ToDate>" + String(adw_eod.GetITemDateTime(llRowPos,'next_eod_Date'),"MM/dd/yyyy HH:mm") + "</ToDate>"
	lsXML += "</EOD>"
	
	lbvalid = True
	
Next /*Selected Carrier */

If not lbvalid Then
	Messagebox("ConnectShip", "There are no Carriers selected to process EOD in ConnectShip!") // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
	//Messagebox("TRAX", "There are no Carriers selected to process EOD in TRAX!")
	Return 0
End IF

//Add the footer
lsXML = lu_websphere.uf_request_footer(lsXML)

//w_main.setMicroHelp("Connecting to TRAX server...")
w_main.setMicroHelp("Connecting to ConnectShip server...") // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip

//post the transaction to Websphere
lsXMLResponse = lu_websphere.uf_post_url(lsXML)

//Messagebox("",lsXMLRESPONSE)

w_main.setMicroHelp("Ready")

//Process the response...

//If we didn't receive an XML back, there is a fatal exception error
If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
	Messagebox("Websphere Fatal Exception Error",lsXMLResponse,StopSign!)
	Return -1
End If

//Check the return code and return description for any trapped errors
lsReturnCode = lu_websphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = lu_websphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		
		Messagebox("Websphere Operational Exception Error",lsReturnDesc,StopSign!)
		Return -1

	Case "-1" /* unable to process EOD on one or more carriers*/
		
		Messagebox("ConnectShip EOD processing error", lsReturnDesc) // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
		//Messagebox("TRAX EOD processing error", lsReturnDesc)
		
	Case Else
		
		If lsReturnDesc > '' Then
			Messagebox("",lsReturnDesc)
		Else
			Messagebox("", "ConnectShip carrier EOD call Successful") // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
			//Messagebox("", "TRAX carrier EOD call Successful")
		End If
		
		
End Choose

//Print any EOD labels returned...

// 01/11 - PCONKL - If TRAX printer Locale is other than 'QPSL', then the labels are being sent to a physical printer. No need to print, just display a confirmation msg that we already did.
//							May be printing for more than 1 warehouse, make the assumption that if first sending to printer, they all are.

lsWarehouse = adw_eod.GetITemString(1,'wh_code')

	Select trax_printer_locale into :lsLocale
	From Trax_warehouse
	Where project_id = :gs_Project and wh_code = :lsWarehouse;
	
//	If lsLocale <> 'QPSL' Then
//
//		Messagebox("TRAX call Successful",'TRAX Labels(s) sent to printer')
//		
//	Else
//
//		If Messagebox("TRAX call Successful" ,"Would you like to print the TRAX Shipping Labels?",Question!,YesNo!,1) = 1 then
//			This.TriggerEvent('ue_Print_labels')
//		End If
//		
//	End If

//For each batch ID in the reponse XML, retrieve and print the label
lsBeginTag = "<BATCHID>"
lsEndTag = "</BATCHID>"
llBeginPos = pos(Upper(lsXMLResponse),lsBeginTag)
Do While llBeginPos > 0
	
	llBeginPos += len(lsBeginTag) /*first char after tag */
	llEndPos = pos(Upper(lsXMLResponse),lsEndTag,llBeginPos)
	
	If llBeginPos < llEndPos Then 	
		
		lsBatchID = Mid(lsXMLResponse, llBeginPos, (llEndPos - llBeginPos))
	
//		If lsBatchID > '' Then
//			lsLabels += uf_retrieve_label(lsBatchID, 'ED')
//		End If
//		
		If lsBatchID > '' Then
			
			If lsLocale <> 'QPSL' Then /*Sent directly to Printer*/
				Messagebox("ConnectShip EOD call Successful",'ConnectShip Labels(s) sent to printer') // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
				//Messagebox("TRAX EOD call Successful",'TRAX Labels(s) sent to printer')
			Else /*not sent directly to printer*/
				
				lirc = uf_print_eod_manifest(lsBatchID, 'ED')
				If lirc < 0 Then
					Messagebox('ConnectShip EOD', 'No EOD Manifest was printed.') // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
					//Messagebox('TRAX EOD', 'No EOD Manifest was printed.')
				End If
				
			End If
			
		End If

	End If
	
	llBeginPos = pos(Upper(lsXMLResponse),lsBeginTag,(llEndPos + Len(lsEndTag))) /*next occurance of Batch ID*/
	
Loop /* Next Batch ID */

//If lsLabels = "" Then
//	uf_print_label(lsLabels)
//Else
//	Messagebox('TRAX EOD', 'No EOD labels were produced.')
//End If

Return 0
end function

public function string uf_retrieve_label (string aslabelid, string aslabeltype);// ET3 2012-11-20 ... Implementing Trax secure label printing
String   lsParsePrinter, lsParseServer
Integer liPos
String	lsLabel
STRING 	lsLabels
STRING	lsCurrentLabel
STRING	lsXML
STRING	lsXMLResponse
STRING	lsReturnCode
STRING	lsReturnDesc
STRING	lsPaths
STRING	lsPath
STRING	lsEncodedLabel   				//ET3 - holds the bin64 encoded label
STRING   lsProvider, lsProviders[]	//ET3 - cryptographic providers
BLOB		lbTmp
int 		lirc, lifileno
String lsLablepath //08-Apr-2014 :Madhu- Print Connote document
//Select Trax_label_Text into :lsLabel
SELECT Trax_label_Text, Trax_Label_Encoded 
INTO :lsPaths, :lsEncodedLabel
FROM Trax_label
WHERE project_id = :gs_Project 
and trax_label_id = :asLabelID 
and trax_label_type = :asLabelType
USING SQLCA;

IF SQLCA.sqlcode <> 0 THEN
	messagebox('ERROR', 'Unable to retrieve label information for label id: ' + aslabelid)
	return ''
END IF

lsLabels = ''
lsLablepath =lsPaths //08-Apr-2014 :Madhu- Print Connote document

IF (NOT IsNull(lsEncodedLabel) AND TRIM(lsEncodedLabel) <> '' ) THEN
	// base64 encoded labels
	// we have an encoded label - need to decode
	// example fragment = XkNDXix+Q0NeXk1DTl5YQV5TWjJeTUNZflRBMH5KU05eTUZOLE5eSlpZXlBNTl5KTUFeTEgwLDBe   
	
	// get default provider
	lsProvider = in_crypto.of_GetDefaultProvider()
	
	// update settings
	in_crypto.iCryptoProvider		= lsProvider
	in_crypto.iProviderType			= in_crypto.PROV_RSA_FULL
	in_crypto.iEncryptAlgorithm	= in_crypto.CALG_RC4
	in_crypto.iHashAlgorithm		= in_crypto.CALG_MD5
	
	// ET3 2013-01-14 Implementing alternate logic - do the decoding in the database and just get
	// an already decoded string back; note: do NOT trim lsEncodedLabel since spaces can be significant
	
	If LEFT(TRIM(lsEncodedLabel),1) = '^' Then
		// appears to be a valid Zebra label String
		lsLabels = lsEncodedLabel
		
	ELSE
		// call the decode function
		lbTmp = in_crypto.of_decode64(lsEncodedLabel)
		lsLabels = STRING( lbTmp, EncodingANSI! )
		
	END IF
		
	If lsLabels = '' or TRIM(lsLabels) = 'Error decoding Base64 string.' Then
		Messagebox('Error', 'There was a problem decoding the label id: ' + aslabelid )
		return ''
	End If

ELSEIF (NOT IsNull(lsPaths) AND TRIM(lsPaths) <> '') THEN

	//TAM 11/06/07 Loop through Paths and parse out individual file names
	Do While lsPaths > ''
		//Label - 			
		If Pos(lsPaths,';') > 0 Then
			lsPath = Left(lsPaths,(pos(lsPaths,';') - 1))
		End If
		lsPaths = Right(lsPaths,(len(lsPaths) - (Len(lsPath) + 1))) /*strip off to next SemiColon */
				
		
		//TAM 10/22/07 open the Saved File using the path stored in the DB and stream it to the print
	//	liFileNo = FileOpen(lsPath,LineMode!,Read!,LockReadWrite!)
		//liFileNo = FileOpen(lsPath,StreamMode!,Read!)
		liFileNo = FileOpen(lsPath,StreamMode!,Read!,Shared!) /* 12/09 - PCONKL- changed to Shared */
		If liFileNo < 0 Then
			Messagebox('', "-       ***Unable to Open File for label Processing: " + lspath)
			Return ''
		End If
			
		liRC = FileRead(liFileNo,lsLabel)
		Do While liRC > 0
			lsLabels += lsLabel
			liRC = FileRead(liFileNo,lsLabel)
		Loop
		
		FileClose(liFileNo)
	
	Loop

ELSE
	// unknown format - exit
	lsLabels = ''
	Messagebox('Error', 'There was a problem getting the label data for label: ' + aslabelid )
	
END IF

//TAM 11/07/2007 Call printing of labels here instead of W_DO.  
//   We are having a problem when multiple labels are concatinated. 

If lsLabels = "" Then
	Messagebox('',"There are no TRAX shipping labels to print!")
	Return lsLabels
End If

//Print the labels...
this.uf_Print_Label(lsLabels)

//08-Apr-2014 :Madhu- Print Connote document -START
String lsPrinter,lsTempPrinter
long llength
Str_parms	lstrparms

//See if we have a saved default printer for TRAX EOD
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','TRAXEOD','')
If lsPrinter > '' Then 
	PrintSetPrinter(lsPrinter)
End If

llength =lastPos(lsPath,'CONN')  //look for connote document
If llength > 0 then	
	//If Messagebox("TRAX call Successful" ,"Would you like to print Connote document?",Question!,YesNo!,1) = 1 then
	If Messagebox("ConnectShip call Successful" ,"Would you like to print Connote document?",Question!,YesNo!,1) = 1 then // Dinesh - 02/05/2025 - SIMS-641- Development for Delivery Order screen change for ConnectShip 
		//this.uf_print_eod_manifest(asLabelID,asLabelType)
		//Prompt for printer
		OpenWithParm(w_label_print_options,lStrParms)
		Lstrparms = Message.PowerObjectParm		  
		If lstrParms.Cancelled Then
			//	Return -1
		End If	
	
		lsPrinter = PrintGetPrinter()
		If Pos(lsPRinter,"~t") > 0 Then
			lsTempPrinter = Left(lsPrinter,(Pos(lsPrinter,"~t") - 1))
		Else
			lsTempPrinter = lsPrinter
		End If
		
		//MEA - 11/2017
		//RDS Migration - Add code for Physio on RDS
		
		//From their desktop version or citrix, the printer format looks like this :”\\copfp0472\2A3B368P006” and works fine in the copyfile() command used to print the connote.
 		//From RDS, it looks like this: “2A3B368P006 on copfp0472 (redirected 30)” and does not work in the copyfile() function.
 		//We need to put in logic to conditionally reformat the printer name if we are coming from RDS. I would just check for pos(“redirect”) > 0 or something like that. 
		//If RDS, we need to parse out the server and  printer names from “lstempprinter” and format it as “\\” + <server> + “\” + <printer> to match what it looks like from the desktop/citrix. I have tested by hardcoding the printer name and running it from RDS. It works fine.

			
		If Pos(lower(lsTempPrinter),"redirect") > 0 Then
			
			
			liPos =  Pos(lsTempPrinter, " ") 
			
			lsParsePrinter = left(lsTempPrinter, liPos -1 )
			
			lsTempPrinter = mid(lsTempPrinter, liPos + 4)
			
			liPos =  Pos(lsTempPrinter, " ") 
			
			lsParseServer =  left(lsTempPrinter, liPos -1 )	
			
			lsTempPrinter = "\\" + lsParseServer + "\" + lsParsePrinter
		
		
		End If	
	
		CopyFile(lsPath, lsTempPrinter, False)
	End If
end if
//Store the last label printer used in the .ini file
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','TRAXEOD',lsPrinter)
//08-Apr-2014 :Madhu- Print Connote document - END

REturn lsLabels
end function

public function integer uf_print_label (string aslabel);String	lsPrinter, lsLabels, lsLabel
Str_parms	lstrparms
Long	llPrintJob

//See if we have a saved default printer for TRAX labels
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','TRAXLABEL','')
If lsPrinter > '' Then 
	PrintSetPrinter(lsPrinter)
End If


//Prompt for printer
//TAM 11/07/2007 This UF is now being called multiple times.  We only want the dialog opened once.

If Not ibOpenPrintDialog Then
	OpenWithParm(w_label_print_options,lStrParms)
	Lstrparms = Message.PowerObjectParm		  
	If lstrParms.Cancelled Then
		Return -1
	Else
		ibOpenPrintDialog = True
	End If	
End If

//Stream to a file for printing
llPrintJob = PrintOpen("TRAX Shipping Labels")
If llPrintJob <0 Then 
	Messagebox('', 'Unable to open Printer file. ConnectShip Labels will not be printed') // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
	//Messagebox('', 'Unable to open Printer file. TRAX Labels will not be printed')
	Return -1
End If

// 01/08 - PCONKL - PrintSend can only send up to 32K, need to break into peices if file larger
lsLabels = asLabel

If Len(lsLabels) < 32000 Then
	
	PrintSend(llPrintJob,lsLabels, 255)
	
Else
	
	lsLabel = Left(lsLabels,32000)
	
	Do While Len(lsLabel) > 0
		
		PrintSend(llPrintJob,lsLabel, 255)
		
		lsLabels = Right(lsLabels,(Len(lsLabels) - Len(lsLabel)))
		lsLabel = Left(lsLabels,32000)
		
	Loop
	
End If

PrintClose(llPrintJob)


//Store the last label printer used in the .ini file
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','TRAXLABEL',lsPrinter)

Return 0
end function

public function integer uf_void_shipment (ref datawindow adw_main, ref datawindow adw_packing);
Long 		llRowPos, llRowCount
String	lsXML, lsResponse, lsReturnCode, lsReturnDesc, lsDONO, lsDONOHold, lsShipRef, lsShipRefHold
Boolean 	lbvalid

u_nvo_websphere_post	lu_websphere

lu_websphere = Create u_nvo_websphere_post


//add the Header segment
//lsXML = lu_websphere.uf_request_header("TraxVoidShipmentRequest") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
lsXML = lu_websphere.uf_request_header("CSVoidShipmentRequest")   // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 

//Project and Carton header
//lsXML += "<Project>" + adw_main.GetITemString(1,'project_id') + "</Project><Carton>"

lsDONOHold = ""

//For each selected Packing row, create an XML segment to pass to Websphere
llRowCount = adw_PAcking.RowCount()
For llRowPos = 1 to llRowCount
	
	If adw_packing.GetITemString(llRowPos,'c_select_ind') <> 'Y' Then Continue /*Skip if not checked*/
	
	If isnull(adw_packing.GetITemString(llRowPos,'tracking_id_type')) or adw_packing.GetITemString(llRowPos,'tracking_id_type') <> 'T' Then Continue /*Skip if not orignally shipped via TRAX*/

	If isnull(adw_packing.GetITemString(llRowPos,'Shipper_tracking_ID')) or adw_packing.GetITemString(llRowPos,'Shipper_tracking_ID') = '' Then Continue /*Can't void if Tracking ID assigned*/
			
	
	lsDONo = adw_packing.GetITemString(llRowPos,'do_no')
	
	//If DONO has changed (would only happen in Batch Picking or for first row of a DO), create a new order header
	If lsDONO <> lsDONOHold Then
		
		If lsDoNoHold > '' Then
			lsXML += "</Order>"
		End If
		
		lsXML += '<Order Project="' + adw_main.GetITemString(1,'project_id') + '" DONO="' + lsDoNo + '" Warehouse="' + adw_main.GetITemString(1,'wh_code') + '">'
		
	End If /*dono changed*/
		
	lsDONoHold = adw_packing.GetITemString(llRowPos,'do_no')
		
	//Add the Carton segment - include project ID as carton Prefix to keep unique within TRAX
	// 01/08 - If Trax_Ship_Ref_Nbr field is present, use that as the Carton Number here - still include project so Websphere doesn't have to determine whther to strip it or not
	//				We may have multiple cartons with the same Ship Ref. If so, we only need to send once
	
//	If adw_packing.GetItemString(llRowPos,'trax_ship_ref_nbr')  > '' Then
//		lsXML += "<CartonNumber>"  + gs_project + adw_packing.GetItemString(llRowPos,'trax_ship_ref_nbr') + "</CartonNumber>"
//	Else
//		lsXML += "<CartonNumber>" + gs_project + adw_packing.GetItemString(llRowPos,'Carton_no') + "</CartonNumber>"
//	End If
	
	If adw_packing.GetItemString(llRowPos,'trax_ship_ref_nbr')  > '' Then
		lsShipRef = gs_project + adw_packing.GetItemString(llRowPos,'trax_ship_ref_nbr')
	Else
		lsShipRef = gs_project + adw_packing.GetItemString(llRowPos,'Carton_no')
	End If
		
	If lsShipRef = lsShipRefHold Then Continue
	
	lsShipRefHold = lsShipRef
	
	lsXML += "<CartonNumber>"  + lsShipRef + "</CartonNumber>"
	
	lbValid = True
	
Next /*Packing row */

If not lbvalid Then
	//Messagebox("TRAX", "There are no cartons to Void in TRAX!")
	Messagebox("ConnectShip", "There are no cartons to Void in ConnectShip!")// Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
	Return 0
End IF

//Last/Only order Footer
lsXML += "</Order>"

//Add the footer
lsXML = lu_websphere.uf_request_footer(lsXML)

//post the transaction to Websphere
//w_main.setMicroHelp("Connecting to TRAX server...")
w_main.setMicroHelp("Connecting to ConnectShip server...") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
lsResponse = lu_websphere.uf_post_url(lsXML)

w_main.setMicroHelp("Ready")

//Process the response...

//If we didn't receive an XML back, there is a fatal exception error or we were unable to connect to websphere
If pos(Upper(lsResponse),"SIMSRESPONSE") = 0 Then
	Messagebox("Websphere fatal Exception Error",lsResponse,StopSign!)
	Return -1
End If

//Check the return code and return description for any trapped errors
lsReturnCode = lu_websphere.uf_get_xml_single_Element(lsResponse,"returncode")
lsReturnDesc = lu_websphere.uf_get_xml_single_Element(lsResponse,"errormessage")

Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		
		Messagebox("Websphere Operational Exception Error",lsReturnDesc,StopSign!)
		Return -1
		
	Case Else
		
		If lsReturnDesc > '' Then
			Messagebox("",lsReturnDesc)
		Else
			//Messagebox("", "TRAX VOID call Successful") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
			Messagebox("", "ConnectShip VOID call Successful") // Dinesh - 02/05/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
		End If
				
End Choose

Return 0
end function

public function integer uf_print_eod_manifest (string aslabelid, string aslabeltype);
String	lsLabel, lsLabels, lsCurrentLabel, lsXML, lsXMLResponse, lsReturnCode, lsReturnDesc, lsTemp, &
			lsPaths, lsPath, lscommand, lsprinter, lsTempPrinter, lsReport, lsReports
int lirc, lifileno
Str_parms	lstrparms
Long	llPrintJob
String   lsParsePrinter, lsParseServer
Integer liPos

//See if we have a saved default printer for TRAX EOD
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','TRAXEOD','')
If lsPrinter > '' Then 
	PrintSetPrinter(lsPrinter)
End If

//Prompt for printer
OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then
	Return -1
End If	

lsPrinter = PrintGetPrinter()
If Pos(lsPRinter,"~t") > 0 Then
	lsTempPrinter = Left(lsPrinter,(Pos(lsPrinter,"~t") - 1))
Else
	lsTempPrinter = lsPrinter
End If

//MEA - 11/2017
//RDS Migration - Add code for Physio on RDS

//From their desktop version or citrix, the printer format looks like this :”\\copfp0472\2A3B368P006” and works fine in the copyfile() command used to print the connote.
//From RDS, it looks like this: “2A3B368P006 on copfp0472 (redirected 30)” and does not work in the copyfile() function.
//We need to put in logic to conditionally reformat the printer name if we are coming from RDS. I would just check for pos(“redirect”) > 0 or something like that. 
//If RDS, we need to parse out the server and  printer names from “lstempprinter” and format it as “\\” + <server> + “\” + <printer> to match what it looks like from the desktop/citrix. I have tested by hardcoding the printer name and running it from RDS. It works fine.

	
If Pos(lower(lsTempPrinter),"redirect") > 0 Then
	
	
	liPos =  Pos(lsTempPrinter, " ") 
	
	lsParsePrinter = left(lsTempPrinter, liPos -1 )
	
	lsTempPrinter = mid(lsTempPrinter, liPos + 4)
	
	liPos =  Pos(lsTempPrinter, " ") 
	
	lsParseServer =  left(lsTempPrinter, liPos -1 )	
	
	lsTempPrinter = "\\" + lsParseServer + "\" + lsParsePrinter


End If	



//Select Trax_label_Text into :lsLabel
Select Trax_label_Text into :lsPaths
from Trax_label
where project_id = :gs_Project and trax_label_id = :asLabelID and trax_label_type = :asLabelType;


//lsLabels = ''
//TAM 11/06/07 Loop through Paths and parse out individual file names
Do While lsPaths > ''
	
	//Report - 			
	If Pos(lsPaths,';') > 0 Then
		lsPath = Left(lsPaths,(pos(lsPaths,';') - 1))
	End If
	
	lsPaths = Right(lsPaths,(len(lsPaths) - (Len(lsPath) + 1))) /*strip off to next SemiColon */
		
	CopyFile(lsPath, lsTempPrinter, False)
	
Loop


//Store the last label printer used in the .ini file
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','TRAXEOD',lsPrinter)


REturn 0
end function

public function string uf_retrieve_label_dp (string aslabelid, string asdono);//Dinesh -01/30/2025- SIMS-640 -Development for ConnectShip Label Re-print in SIMS 
// ET3 2012-11-20 ... Implementing Trax secure label printing
String   lsParsePrinter, lsParseServer
Integer liPos
String	lsLabel
STRING 	lsLabels
STRING	lsCurrentLabel
STRING	lsXML
STRING	lsXMLResponse
STRING	lsReturnCode
STRING	lsReturnDesc
STRING	lsPaths
STRING	lsPath
STRING	lsEncodedLabel   				//ET3 - holds the bin64 encoded label
STRING   lsProvider, lsProviders[]	//ET3 - cryptographic providers
BLOB		lbTmp
int 		lirc, lifileno
String lsLablepath //08-Apr-2014 :Madhu- Print Connote document
//Begin - Akash -01/30/2025- SIMS-640 -Development for ConnectShip Label Re-print in SIMS 
//Select CS_LABEL_DATA
Select MAX(CS_LABEL_DATA) //dts - 02/24/25 - SIMS-672-Label Print and Re-print not working for container with multiple Packing records (added 'MAX' - need to make sure more than 1 row is not returned. They should all be the same.)
INTO :lsEncodedLabel
FROM Delivery_Packing
WHERE Trax_Ship_Ref_Nbr = :asLabelID 
and do_no = :asdono
USING SQLCA;
//End - Akash -01/30/2025- SIMS-640 -Development for ConnectShip Label Re-print in SIMS 
IF SQLCA.sqlcode <> 0 THEN
	messagebox('ERROR', 'Unable to retrieve label information for label id: ' + aslabelid)
	return ''
END IF

lsLabels = ''
lsLablepath =lsPaths //08-Apr-2014 :Madhu- Print Connote document

IF (NOT IsNull(lsEncodedLabel) AND TRIM(lsEncodedLabel) <> '' ) THEN
	// base64 encoded labels
	// we have an encoded label - need to decode
	// example fragment = XkNDXix+Q0NeXk1DTl5YQV5TWjJeTUNZflRBMH5KU05eTUZOLE5eSlpZXlBNTl5KTUFeTEgwLDBe   
	
	// get default provider
	lsProvider = in_crypto.of_GetDefaultProvider()
	
	// update settings
	in_crypto.iCryptoProvider		= lsProvider
	in_crypto.iProviderType			= in_crypto.PROV_RSA_FULL
	in_crypto.iEncryptAlgorithm	= in_crypto.CALG_RC4
	in_crypto.iHashAlgorithm		= in_crypto.CALG_MD5
	
	// ET3 2013-01-14 Implementing alternate logic - do the decoding in the database and just get
	// an already decoded string back; note: do NOT trim lsEncodedLabel since spaces can be significant
	
	//If LEFT(TRIM(lsEncodedLabel),1) = '^' Then //dts - SIMS-673-CS Migration - Labels are not printing on the printer (payload from CS response not as expected (doesn't start with '^'))
	If LEFT(TRIM(lsEncodedLabel),1) = '^' or LEFT(TRIM(lsEncodedLabel),1) = '~~' Then //note that the '~' is an escape character so need to use '~~' to represent '~'
		// appears to be a valid Zebra label String
		lsLabels = lsEncodedLabel
		
	ELSE
		// call the decode function
		lbTmp = in_crypto.of_decode64(lsEncodedLabel)
		lsLabels = STRING( lbTmp, EncodingANSI! )
		
	END IF
		
	If lsLabels = '' or TRIM(lsLabels) = 'Error decoding Base64 string.' Then
		Messagebox('Error', 'There was a problem decoding the label id: ' + aslabelid )
		return ''
	End If
//Begin - Dinesh -01/30/2025- SIMS-640 -Development for ConnectShip Label Re-print in SIMS 
//ELSEIF (NOT IsNull(lsPaths) AND TRIM(lsPaths) <> '') THEN
//
//	//TAM 11/06/07 Loop through Paths and parse out individual file names
//	Do While lsPaths > ''
//		//Label - 			
//		If Pos(lsPaths,';') > 0 Then
//			lsPath = Left(lsPaths,(pos(lsPaths,';') - 1))
//		End If
//		lsPaths = Right(lsPaths,(len(lsPaths) - (Len(lsPath) + 1))) /*strip off to next SemiColon */
//				
//		
//		//TAM 10/22/07 open the Saved File using the path stored in the DB and stream it to the print
//	//	liFileNo = FileOpen(lsPath,LineMode!,Read!,LockReadWrite!)
//		//liFileNo = FileOpen(lsPath,StreamMode!,Read!)
//		liFileNo = FileOpen(lsPath,StreamMode!,Read!,Shared!) /* 12/09 - PCONKL- changed to Shared */
//		If liFileNo < 0 Then
//			Messagebox('', "-       ***Unable to Open File for label Processing: " + lspath)
//			Return ''
//		End If
//			
//		liRC = FileRead(liFileNo,lsLabel)
//		Do While liRC > 0
//			lsLabels += lsLabel
//			liRC = FileRead(liFileNo,lsLabel)
//		Loop
//		
//		FileClose(liFileNo)
//	
//	Loop
//
//End - Dinesh -01/30/2025- SIMS-640 -Development for ConnectShip Label Re-print in SIMS 
ELSE
	// unknown format - exit
	lsLabels = ''
	Messagebox('Error', 'There was a problem getting the label data for label: ' + aslabelid )
	
END IF

//TAM 11/07/2007 Call printing of labels here instead of W_DO.  
//   We are having a problem when multiple labels are concatinated. 

If lsLabels = "" Then
	Messagebox('',"There are no ConnectShip shipping labels to print!") // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
	//Messagebox('',"There are no TRAX shipping labels to print!")
	
	Return lsLabels
End If

//Print the labels...
this.uf_Print_Label(lsLabels)

//08-Apr-2014 :Madhu- Print Connote document -START
String lsPrinter,lsTempPrinter
long llength
Str_parms	lstrparms

//See if we have a saved default printer for TRAX EOD
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','TRAXEOD','')
If lsPrinter > '' Then 
	PrintSetPrinter(lsPrinter)
End If

llength =lastPos(lsPath,'CONN')  //look for connote document
If llength > 0 then	
	//If Messagebox("TRAX call Successful" ,"Would you like to print Connote document?",Question!,YesNo!,1) = 1 then
	If Messagebox("ConnectShip call Successful" ,"Would you like to print Connote document?",Question!,YesNo!,1) = 1 then // Dinesh - 02/05/2025 - SIMS-641- Development for Delivery Order screen change for ConnectShip 
		//this.uf_print_eod_manifest(asLabelID,asLabelType)
		//Prompt for printer
		OpenWithParm(w_label_print_options,lStrParms)
		Lstrparms = Message.PowerObjectParm		  
		If lstrParms.Cancelled Then
			//	Return -1
		End If	
	
		lsPrinter = PrintGetPrinter()
		If Pos(lsPRinter,"~t") > 0 Then
			lsTempPrinter = Left(lsPrinter,(Pos(lsPrinter,"~t") - 1))
		Else
			lsTempPrinter = lsPrinter
		End If
		
		//MEA - 11/2017
		//RDS Migration - Add code for Physio on RDS
		
		//From their desktop version or citrix, the printer format looks like this :”\\copfp0472\2A3B368P006” and works fine in the copyfile() command used to print the connote.
 		//From RDS, it looks like this: “2A3B368P006 on copfp0472 (redirected 30)” and does not work in the copyfile() function.
 		//We need to put in logic to conditionally reformat the printer name if we are coming from RDS. I would just check for pos(“redirect”) > 0 or something like that. 
		//If RDS, we need to parse out the server and  printer names from “lstempprinter” and format it as “\\” + <server> + “\” + <printer> to match what it looks like from the desktop/citrix. I have tested by hardcoding the printer name and running it from RDS. It works fine.

			
		If Pos(lower(lsTempPrinter),"redirect") > 0 Then
			
			
			liPos =  Pos(lsTempPrinter, " ") 
			
			lsParsePrinter = left(lsTempPrinter, liPos -1 )
			
			lsTempPrinter = mid(lsTempPrinter, liPos + 4)
			
			liPos =  Pos(lsTempPrinter, " ") 
			
			lsParseServer =  left(lsTempPrinter, liPos -1 )	
			
			lsTempPrinter = "\\" + lsParseServer + "\" + lsParsePrinter
		
		
		End If	
	
		CopyFile(lsPath, lsTempPrinter, False)
	End If
end if
//Store the last label printer used in the .ini file
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','TRAXEOD',lsPrinter)
//08-Apr-2014 :Madhu- Print Connote document - END

REturn lsLabels
end function

on u_nvo_trax.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_trax.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

