HA$PBExportHeader$w_comcast_sik_kit_label.srw
$PBExportComments$Modem and Remote Kitting
forward
global type w_comcast_sik_kit_label from w_response_ancestor
end type
type cb_print from commandbutton within w_comcast_sik_kit_label
end type
type cb_newpallet from commandbutton within w_comcast_sik_kit_label
end type
type cbx_unitsperpallet from checkbox within w_comcast_sik_kit_label
end type
type st_unitscanned from statictext within w_comcast_sik_kit_label
end type
type sle_printer from singlelineedit within w_comcast_sik_kit_label
end type
type st_1 from statictext within w_comcast_sik_kit_label
end type
type cb_changeprinter from commandbutton within w_comcast_sik_kit_label
end type
type sle_barcodes from singlelineedit within w_comcast_sik_kit_label
end type
type sle_unitsperpallet from singlelineedit within w_comcast_sik_kit_label
end type
type st_unitsperpallet from statictext within w_comcast_sik_kit_label
end type
type st_2 from statictext within w_comcast_sik_kit_label
end type
type st_scanned from statictext within w_comcast_sik_kit_label
end type
type st_reprint from statictext within w_comcast_sik_kit_label
end type
type rb_conditionnew from radiobutton within w_comcast_sik_kit_label
end type
type rb_conditionused from radiobutton within w_comcast_sik_kit_label
end type
type gb_condition from groupbox within w_comcast_sik_kit_label
end type
type dw_label from u_dw_ancestor within w_comcast_sik_kit_label
end type
type cb_quit from commandbutton within w_comcast_sik_kit_label
end type
end forward

global type w_comcast_sik_kit_label from w_response_ancestor
integer width = 2363
integer height = 848
string title = "Comcast SIK Kitting Label"
event ue_process_barcodes ( )
event ue_print ( )
event ue_reprint_label ( )
event ue_label_reprint ( )
event ue_initialize ( )
cb_print cb_print
cb_newpallet cb_newpallet
cbx_unitsperpallet cbx_unitsperpallet
st_unitscanned st_unitscanned
sle_printer sle_printer
st_1 st_1
cb_changeprinter cb_changeprinter
sle_barcodes sle_barcodes
sle_unitsperpallet sle_unitsperpallet
st_unitsperpallet st_unitsperpallet
st_2 st_2
st_scanned st_scanned
st_reprint st_reprint
rb_conditionnew rb_conditionnew
rb_conditionused rb_conditionused
gb_condition gb_condition
dw_label dw_label
cb_quit cb_quit
end type
global w_comcast_sik_kit_label w_comcast_sik_kit_label

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
Window iw_wo  = w_workorder
Datawindow idw_detail, idw_picking, idw_putaway
Datastore ids_dw, ids_serial, ids_serials, ids_putaway, ids_pickdetail, ids_validSerials

Datetime idtToday
String	isLabels[], isOEMLabel, isPrintText, isShipFormat, isPalletFormat, isUnitsScanned, isOrdStatus, isCondition, isSuppCode
String isPalletUnitsScanned, isModelNo, isOrigPalletID, isPalletID, isPallets, isScannedPallets, isWONo, isOrigRONo
int iiTotalUnits, iiUnitsPerPallet, iiOrigUnitsPerPallet, iiUnitsScanned, iiTotalUnitsScanned, iiOrigContentRow, iiLabelToPrint
int ii_reqqty, ii_allocqty, ii_qty, iiRow, iiPickingRow, iiPickingRows, iiPutawayRow, iiPutawayRows, iiPickingDetailRow
Boolean ibPrinterSelected=FALSE
Boolean ibInitialized=FALSE
Long ilSerialRow, ilOwnerID


end variables

forward prototypes
public function integer uf_shipping_label (integer airow, string asformat)
public function integer wf_validate ()
public function integer uf_getunitsscanned ()
public function string uf_getnewfgpalletid ()
public function integer uf_getitemmasterparameters (string as_sku, string as_suppcode)
public subroutine uf_loadprinter ()
public function integer uf_getputawayrec (string as_palletid)
public function integer uf_getpickingrec (string as_palletid)
public function integer uf_createputawayrow (integer ai_pickingrow)
public function integer uf_createdwlabelrow (string as_palletid)
public function integer uf_loadserialdata ()
public function integer uf_getserialrow (string as_serial)
public function integer uf_update_serialds (long as_row, string as_pallet, string as_sku, string as_remark)
public function integer uf_findnewscan ()
public function integer uf_setpallets ()
public function integer uf_setconfirmputawayind ()
public function integer uf_getpickingdetail (string as_wono)
public function integer uf_pallet_label (integer airow, string asformat)
public function integer uf_enableconfirmputawayind ()
public subroutine uf_reprintlabelonly ()
public function integer uf_setserialdata (string as_serialno, integer ai_type)
public function integer uf_loadpalletserials (string as_palletid)
public function integer uf_getvalidserials ()
public function integer uf_setscannedpallets ()
public function integer uf_update_carton_serial (string as_serialno, string as_palletid, string as_sku, string as_suppcode)
end prototypes

event ue_process_barcodes();String			lsBarcode, lsFind, lsSupplier, lsLine, lsMsg, lsSku, ls_woserial, quote
Integer		liRC, i
Long			llFindRow, llLineItemNo, lLDetailLIne, ll_pickrow
Dec			ldLineQty, ldScanQty, ldExpQty, ldCurrentScanQty

lsBarcode = trim(sle_barcodes.Text)
quote = "'"
lsFind = "#2=" + quote + lsBarCode + quote

If Trim(lsBarcode) <> "" Then
	liRC = ids_validSerials.Find(lsFind,1,ids_validSerials.RowCount()+1)
	If liRC >= 1 Then									// Valid serial number for scanning
		liRC = uf_setserialdata(lsBarcode, 0)			// Check serial number from picking list 	
		If liRC = 0 Then
			liRC = uf_setserialdata(lsBarcode, 2)		// Check serial number from carton_serial
			if liRC = 0 Then
				MessageBox("Serial Number Error", "Could not find serial no " + lsBarcode + " in palletID " + isOrigPalletID + ".  Check number and try again.")
			else
				If MessageBox("Serial Number Scanned","This serial number has already been scanned.  Do you wish to reprint label?",Question!,YesNo!) = 1 Then
					TriggerEvent("ue_label_reprint")
				End if
			end if
		Else
			If liRC > 1 Then
				MessageBox("Serial Number Error", "More than one record for serial no: " + lsBarcode + ".  Check number and try again.")
			Else
				If liRC < 0 Then
					MessageBox("Serial Number Error","There was a system error when processing SN: " + lsBarcode + ".  Please check with the System Administrator.")
				Else
					isPalletID = dw_label.GetItemString(1,"pallet_id")
					ilSerialRow = uf_getSerialRow(lsBarCode)
				
					iiPickingRow = uf_getpickingRec(ids_serials.GetItemString(ilSerialRow,"pallet_id"))
					
					iiPutawayRow = uf_getputawayrec(isPalletID)
					If iiPutawayRow = 0 Then				// Pallet does not exist in FG Putaway list.  Make new row.
						iiPutawayRow = uf_createputawayrow(iiPickingRow)
						
						iiUnitsScanned = 1
						idw_putaway.SetItem(iiPutawayRow, "quantity", iiUnitsScanned)
						
						iiTotalUnitsScanned += 1
					Else 
						iiUnitsScanned += 1
						idw_putaway.SetItem(iiPutawayRow, "quantity", iiUnitsScanned)	
						iiTotalUnitsScanned +=1
					End If
					
					// Set picking row pallet_id before updating carton/serial
					isOrigPalletID = idw_picking.GetItemString(iiPickingRow,"lot_no")
					
					// Update carton/serial with new pallet_id and SKU
					liRC = uf_update_carton_serial(lsBarcode, isPalletID, isModelNo, isSuppCode)
					
					// If successfully recorded, then print serial number label
					if liRC = 1 then
						//Shipping label for displayed data
						uf_shipping_label(1, isShipFormat) 
						TriggerEvent('ue_Print')
					end if
					
					// Update serial datastore
					liRC = uf_update_serialDS(ilSerialRow, isPalletID, isModelNo, "Scanned")
					
					If (iiUnitsScanned = iiUnitsPerPallet) Then		// Reuse dw_label and create new idw_putaway
					
						// Print pallet label here....
						uf_pallet_label(1, isPalletFormat) 
						TriggerEvent('ue_Print')
						
						isPalletID = uf_getnewfgpalletid()				// Get new pallet ID
						dw_label.SetItem(1, "pallet_id", isPalletID)
						dw_label.SetItem(1, "condition", "New")	
						
						idw_putaway.SetItem(iiPutawayRow,"c_confirm_putaway_ind","Y")		// Turn on putaway indicator
						
						iiUnitsScanned = 0
						
					End If
					
					// Are we done?
					If  (iiTotalUnitsScanned = iiTotalUnits) Then
						st_scanned.text = string(iiTotalUnitsScanned)
						sle_barcodes.enabled = False
						cb_cancel.SetFocus()
						MessageBox("Scanning complete","All units have been scanned.  Press Quit to exit.")
						uf_enableconfirmputawayind()			// Turn on all putaway confirm indicators
						w_workorder.tab_main.tabpage_putaway.cb_confirm_putaway.enabled = true
					Else
						st_scanned.text = string(iiTotalUnitsScanned)
						sle_barcodes.SelectText(1,len(sle_barcodes.Text))
						sle_barcodes.SetFocus()
					End If
				End If
			End If
		End If
	Else
		MessageBox("Process Serial Number","Scanned serial number is not valid for the pallets picked.  Please research to determine correct pallet and serial number.")
	End If
End If
	


end event

event ue_print();
Long llPrintJob

//Open Printer File 
llPrintJob = PrintOpen(isPrintText)

If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return
End If

//Do the print
PrintSend(llPrintJob, isLabels[1])

//Close printer
PrintClose(llPrintJob)



end event

event ue_reprint_label();String			lsBarcode, lsFind, lsSupplier, lsLine, lsMessage, lsSku, ls_woserial
Integer		liRC, i
Long			foundRow
string 		quote = "'"

lsBarcode = sle_barcodes.Text
liRC = uf_setserialdata(lsBarcode, 2)

lsFind = "field1 = " + quote + lsBarcode + quote

If (liRC = 1) then
	isPalletID = ids_serial.GetItemString(liRC, 1)
	liRC = uf_loadPalletSerials(isPalletID)
	if liRC > 0 then
		iiUnitsPerPallet = ids_serials.RowCount()
		for i = 1 to iiUnitsPerPallet
			ls_woserial = ids_serials.GetItemString(i,2)
			if ls_woserial = lsBarCode then
				iiUnitsScanned = i
			end if
		next
		//iiUnitsScanned = ids_serials.find(lsFind, 1, ids_serials.rowcount() )
		ilSerialRow = iiUnitsScanned
		dw_label.Reset()
		dw_label.InsertRow(0)
		dw_label.SetItem(1, 3, isPalletID)
		dw_label.SetItem(1, 1, ids_serial.GetItemString(1, 3))
		if ( rb_conditionNew.Checked ) then
			dw_label.SetItem(1, 2, "New")
		else
			dw_label.SetItem(1, 2, "Used")
		end if
		if ( iiLabelToPrint = 1 ) then
				//Shipping label for displayed data
				uf_shipping_label(1, isShipFormat) 
				TriggerEvent('ue_Print')
		Else
				//Pallet label for displayed data
				uf_pallet_label(1, isPalletFormat) 
				TriggerEvent('ue_Print')
		End if
	else
		MessageBox("ue_reprint_label","Did not find serial number in pallet")
	end if
Else
	MessageBox("ue_reprint_label","Did not find just one serial number.  Please invetigate and retry.")
End if




end event

event ue_label_reprint();/* Reprint a label if serial number has already been scanned and is rescanned */
String ls_pallet, ls_serialNo, ls_condition, ls_model, ls_invType, ls_macID,  ls_find, quote, lsFormat
int li_row, li_qty

lsFormat = isShipFormat

quote = "'"
li_qty = 0
ls_condition = "New"
if ids_serial.RowCount() = 1 then
	ls_pallet = ids_serial.GetItemString(1, 1)
	ls_serialNo = ids_serial.GetItemString(1, 2)
	ls_model = ids_serial.GetItemString(1, 3)
	ls_macID = ids_serial.GetItemString(1,4)
	ls_find = "lot_no = " + quote + ls_pallet + quote
	li_row = idw_putaway.Find(ls_find, 1, idw_putaway.RowCount())
	if li_row > 0 then
		li_qty = idw_putaway.GetItemNumber(li_row, "quantity")
		ls_invType = idw_putaway.GetItemString(li_row,"inventory_type")
		if ls_invType = 'U' then
			ls_condition = "Used"
		end if
	end if
end if

if IsNull(ls_macID) then ls_macID = ""

//Label nn of nn
lsFormat = invo_labels.uf_replace(lsFormat,"~~label_of~~", 'Label ' + string(li_qty) + ' of ' + string(li_qty))

//Model
lsFormat = invo_labels.uf_replace(lsFormat,"~~model~~",String(ls_model))

//Serial No and Bar Code
lsFormat = invo_labels.uf_replace(lsFormat,"~~serial_no~~",String(ls_serialNo))
lsFormat = invo_labels.uf_replace(lsFormat,"~~serial_no_bc~~",String(ls_serialNo))

//Unit ID & Bar Code
lsFormat = invo_labels.uf_replace(lsFormat,"~~unit_id~~",String(ls_macID))
lsFormat = invo_labels.uf_replace(lsFormat,"~~unit_id_bc~~",String(ls_macID))

//Condition
lsFormat = invo_labels.uf_replace(lsFormat,"~~condition~~",String(ls_condition))

//Swedish characters need to be 'cleansed'
lsFormat = f_cleanse_printer(lsFormat)

isLabels[1] = lsFormat

TriggerEvent('ue_Print')

end event

event ue_initialize();// Complete initialization process...  will be after ue_postopen if units per pallets cannot be determined
String lsMsg, lsPalletID, lsTitle
int li_row

li_row = 1		// Only one record for dw_label
lsTitle = "Modem/Remote Kitting Error"

	 iiTotalUnitsScanned = uf_GetUnitsScanned()
	 If iiTotalUnitsScanned = -1 Then
		lsMsg = "All units have been scanned.~r~nWould you like to reprint a serial number or pallet label?"
		If MessageBox("Scan Units",lsMsg,Question!,YesNo!,2) = 1 Then
			lsMsg = "Scan or enter serial number and tab.~r~nDo you want a pallet label? "
			If MessageBox("Scan Units",lsMsg, Question!,YesNo!,2) = 1 Then
				iiLabelToPrint = 2
			Else
				iiLabelToPrint = 1
			End if
			uf_reprintLabelOnly()
		Else
			uf_enableconfirmputawayind()			// Turn on all putaway confirm indicators
			TriggerEvent("ue_close")
		End if
	Else 
		st_scanned.text = string(iiTotalUnitsScanned)
		if iiTotalUnitsScanned = 0 Then				// Just starting -- no scanned units
			lsPalletId = uf_getnewfgpalletid()
			dw_label.SetItem(li_row,"pallet_id",lsPalletId)
			dw_label.SetItem(li_row,"condition","NEW")
			dw_label.SetItem(li_row,"model", isModelNo)
		Else
			iiPutawayRow = uf_findNewScan()			// Have some scanned units -- find starting place  and pallet
			if iiPutawayRow = 0 Then
				lsPalletId = uf_getnewfgpalletid()
				dw_label.SetItem(li_row,"pallet_id",lsPalletId)
				dw_label.SetItem(li_row,"condition","NEW")
				dw_label.SetItem(li_row,"model", isModelNo)
			Else
				iiUnitsScanned = idw_putaway.GetItemNumber(iiPutawayRow,"quantity")
				if (  idw_putaway.GetItemString(iiPutawayRow, "inventory_type") = "N" ) then
					isCondition = "New" 
				else 
					isCondition = "Used" 
				end if
				dw_label.SetItem(iiPutawayRow,"pallet_id", idw_putaway.GetItemString(iiPutawayRow,"lot_no"))
				dw_label.SetItem(iiPutawayRow,"condition", isCondition)
				dw_label.SetItem(iiPutawayRow,"model", idw_putaway.GetItemString(iiPutawayRow, "SKU"))
			End If
		End If
		sle_barcodes.SetFocus()
	End If
	
end event

public function integer uf_shipping_label (integer airow, string asformat);String	lsWarehouse, lsFormat, lsAddr, lsCityState, lsShipDate, lsUCCPRefix, lsUCCCarton, lsCarrier, lsCarrierName
String lsSerialNo, lsModel
Long		lLWarehouseRow, llAddressPos, llLabelPos
Integer	liCheck
lsFormat = asFormat

lsSerialNo = ids_serials.getITemString(ilSerialRow,2)
lsModel = ids_serials.getITemString(ilSerialRow,4)
isCondition = dw_label.getItemString(1,'condition')
if isCondition = 'N' then 
	isCondition = 'New'
elseif isCondition = 'U' then
	isCondition = 'Used'
end if

if IsNull(lsModel) then lsModel = ""

//Label nn of nn
lsFormat = invo_labels.uf_replace(lsFormat,"~~label_of~~", 'Label ' + string(iiUnitsScanned) + ' of ' + string(iiUnitsPerPallet))

//Model
lsFormat = invo_labels.uf_replace(lsFormat,"~~model~~",String(dw_label.getITemString(1,'model')))

//Serial No and Bar Code
lsFormat = invo_labels.uf_replace(lsFormat,"~~serial_no~~",String(lsSerialNo))
lsFormat = invo_labels.uf_replace(lsFormat,"~~serial_no_bc~~",String(lsSerialNo))

//Unit ID & Bar Code
lsFormat = invo_labels.uf_replace(lsFormat,"~~unit_id~~",String(lsModel))
lsFormat = invo_labels.uf_replace(lsFormat,"~~unit_id_bc~~",String(lsModel))

//Condition
lsFormat = invo_labels.uf_replace(lsFormat,"~~condition~~",String(isCondition))

//Swedish characters need to be 'cleansed'
lsFormat = f_cleanse_printer(lsFormat)

isLabels[1] = lsFormat

Return 0
end function

public function integer wf_validate ();String ls_SerialNo, ls_UnitId, ls_UnitId2


//Accept Text to start
dw_label.AcceptText()

//Populate variables
ls_SerialNo  = dw_label.GetItemString(1, "serial_no")
ls_UnitId      = dw_label.GetItemString(1, "unit_id")

IF IsNull(ls_SerialNo) OR ls_SerialNo = "" THEN
	//Remove any previously entered unit id
	ls_UnitId = ""
	// Not ready to print
	Messagebox('Labels','Serial Number must be entered before printing.')
	Return -1
ELSE
	//Populate unit id2 with value from file if serial no is already on file
	SELECT Max(user_field1)
	INTO :ls_UnitId2
	FROM carton_serial
	WHERE project_id = 'Comcast'
	and serial_no = :ls_SerialNo;
	
	IF IsNull(ls_UnitId2) OR ls_UnitId2 ="" THEN
		//Do Nothing
	ELSE
		
		//Replace entered unit id with value from file
		ls_UnitId = ls_UnitId2
		
		//Reset displayed unit id value on dw
		dw_label.SetItem(1,"unit_id", ls_UnitId2)
		
		//Call AcceptText again...in this case  
		dw_label.AcceptText()

	END IF
END IF
		
IF  IsNull(ls_UnitId) OR ls_UnitId = "" THEN
	// Not ready to print
	Messagebox('Labels','Unit ID must be entered before printing.')
	Return -1
END IF

REturn 0
end function

public function integer uf_getunitsscanned ();int li_units_scanned, li_units_remaining, liRow, li_dRows, li_pRows
ii_qty = 0
li_dRows = idw_detail.rowcount()
li_pRows = idw_putaway.rowcount()

// Total Units to Kit from Detail
for liRow = 1 to li_dRows
	ii_reqqty += idw_detail.GetItemNumber(liRow, "req_qty")
	ii_allocqty += idw_detail.GetItemNumber(liRow, "alloc_qty")
next 

iiTotalUnits = ii_reqqty

// Units already scanned from Putaway
for liRow = 1 to li_pRows
	ii_qty += idw_putaway.GetItemNumber(liRow, "quantity")
next

iiTotalUnitsScanned = ii_qty

if ii_qty = ii_reqqty Then
	return -1		// All scanned; nothing to do; return from window.
End If

return ii_qty



end function

public function string uf_getnewfgpalletid ();string ls_pallet_id, ls_sqlca_err_msg
Integer li_seq_no = 0
int li_sqlca_code

li_seq_no = g.of_next_db_seq(gs_project,"Workorder_Putaway","Pallet_ID")

ls_pallet_id = "MLO-FG-" + right("00000000" + string(li_seq_no),8)

return ls_pallet_id

end function

public function integer uf_getitemmasterparameters (string as_sku, string as_suppcode);// Assumption on changing original SKU to new FG SKU is to add -FG to original SKU (Wrong assumption)
// Assumption 2: as_sku is Parent SKU.  Parent will hold UnitsPerPallet
int	 	retVal, qty_2, qty_3, qty_4
String uom_2, uom_3, uom_4

retVal = 0

select sku, uom_2,qty_2, uom_3,qty_3, uom_4,qty_4
into  :isModelNo, :uom_2, :qty_2, :uom_3, :qty_3, :uom_4, :qty_4
from item_master
where project_id = 'COMCAST'
and sku = :as_sku
and supp_code = :as_suppcode
using sqlca;

if sqlca.sqlcode = 100 or sqlca.sqlcode < 0 then retVal = -1

if ( uom_2 = 'PLT' ) then
	iiUnitsPerPallet = qty_2
else 
	if ( uom_3 = 'PLT' ) then
		iiUnitsPerPallet = qty_3
	else 
		if ( uom_4 = 'PLT' ) then
			iiUnitsPerPallet = qty_4
		else
			iiUnitsPerPallet = 0
		end if
	end if
end if

return retVal
end function

public subroutine uf_loadprinter ();String lsPrinter

//See if we have a saved default printer for WOScanUnits
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','WOScanUnits','')
//lsPrinter = ''
If lsPrinter > '' Then 
	PrintSetPrinter(lsPrinter)
	g.ibNoPromptPrint = True /* called print routine will not display print dialog box */
End If
sle_printer.text = lsPrinter

//Show current Printer
ids_dw = Create Datastore
ids_dw.dataobject = 'd_picking_prt'
sle_printer.text = ids_dw.describe('datawindow.printer')

//Show current Printer 
/*
dw_Type.SetTransObject(sqlca)
dw_Type.Retrieve(gs_project)
li_row = 1
if dw_type.rowcount() > 0 then 
	sle_printer.text = ids_dw.describe('datawindow.printer') + dw_type.getitemstring(li_row,"prt_code")
end if
*/
end subroutine

public function integer uf_getputawayrec (string as_palletid);int retVal, liRows, liRow

liRow = 0 

liRows = idw_putaway.RowCount()
for liRow = 1 to liRows
	if idw_putaway.GetItemString(liRow, "lot_no") = as_palletid Then retVal = liRow
next

return retVal

end function

public function integer uf_getpickingrec (string as_palletid);int retVal, liRows, liRow

liRow = 0 

liRows = idw_picking.RowCount()
for liRow = 1 to liRows
	if idw_picking.GetItemString(liRow, "lot_no") = as_palletid Then retVal = liRow
next

return retVal

end function

public function integer uf_createputawayrow (integer ai_pickingrow);/* Fill in all rows except quantity from pertinent picking list record with new FG pallet ID */
String blank = ""
int liFindRow

	liFindRow = idw_putaway.InsertRow(0)
	idw_putaway.SetItem(liFindRow, "WO_No", idw_picking.GetItemString(iiPickingRow, "wo_no"))
	idw_putaway.SetItem(liFindRow, "lot_no", isPalletID)
	idw_putaway.SetItem(liFindRow, "line_item_no", idw_picking.GetItemNumber(iiPickingRow, "line_item_no"))
	idw_putaway.SetItem(liFindRow, "sku", dw_label.GetItemString(1,"model"))
	// force comcast as supp_code for FG - 2012-03-22  Ermine Todd.  Changed back to supp_code from detail record 2012-04-11 gwmorrison
	idw_putaway.SetItem(liFindRow, "supp_code",isSuppCode)
	//idw_putaway.SetItem(liFindRow, "supp_code", gs_project)
	idw_putaway.SetItem(liFindRow, "owner_id", ilOwnerID)
	idw_putaway.SetItem(liFindRow, "country_of_origin", idw_picking.GetItemString(iiPickingRow, "country_of_origin"))
	idw_putaway.SetItem(liFindRow, "l_code", blank)				// Do not default location
	idw_putaway.SetItem(liFindRow, "inventory_type", left(dw_label.GetItemString(1,"condition"),1))
	idw_putaway.SetItem(liFindRow, "serial_no", idw_picking.GetItemString(iiPickingRow, "serial_no"))
	idw_putaway.SetItem(liFindRow, "po_no", idw_picking.GetItemString(iiPickingRow, "po_no"))
	idw_putaway.SetItem(liFindRow, "po_no2", idw_picking.GetItemString(iiPickingRow, "po_no2"))
	idw_putaway.SetItem(liFindRow, "container_id", idw_picking.GetItemString(iiPickingRow, "container_id"))
	idw_putaway.SetItem(liFindRow, "expiration_date", idw_picking.GetItemDatetime(iiPickingRow, "expiration_date"))
	idw_putaway.SetItem(liFindRow, "sku_parent", idw_picking.GetItemString(iiPickingRow, "sku_parent"))
	idw_putaway.SetItem(liFindRow, "component_ind", idw_picking.GetItemString(iiPickingRow, "component_ind"))
	//idw_putaway.SetItem(liFindRow, "user_field2", string(idtToday))    Blank user_field2 depicts unconfirmed putaway record
	idw_putaway.SetItem(liFindRow, "component_no", idw_picking.GetItemNumber(iiPickingRow, "component_no"))
	idw_putaway.SetItem(liFindRow, "cf_owner_name", idw_picking.GetItemString(iiPickingRow, "cf_owner_name"))
	idw_putaway.SetItem(liFindRow, "lot_controlled_ind", idw_picking.GetItemString(iiPickingRow, "lot_controlled_ind"))
	idw_putaway.SetItem(liFindRow, "po_controlled_ind", idw_picking.GetItemString(iiPickingRow, "po_controlled_ind"))
	idw_putaway.SetItem(liFindRow, "po_no2_controlled_ind", idw_picking.GetItemString(iiPickingRow, "po_no2_controlled_ind"))
	idw_putaway.SetItem(liFindRow, "expiration_controlled_ind", idw_picking.GetItemString(iiPickingRow, "expiration_controlled_ind"))
	idw_putaway.SetItem(liFindRow, "container_tracking_ind", idw_picking.GetItemString(iiPickingRow, "container_tracking_ind"))
	idw_putaway.SetItem(liFindRow, "serialized_ind", idw_picking.GetItemString(iiPickingRow, "serialized_ind"))
	idw_putaway.SetItem(liFindRow, "component_ind", idw_picking.GetItemString(iiPickingRow, "component_ind"))
	idw_putaway.SetItem(liFindRow, "c_confirm_putaway_ind", "Y")

return liFindRow

end function

public function integer uf_createdwlabelrow (string as_palletid);int retVal, liRow

retVal = 0

	liRow = dw_label.InsertRow(0)
	dw_label.SetItem(liRow,"pallet_id",as_PalletId)
	dw_label.SetItem(liRow,"condition","NEW")
	dw_label.SetItem(liRow,"model", isModelNo)

return retVal

end function

public function integer uf_loadserialdata ();int retVal
int liRow, liRows, li_sku_flag, liSRow, liRowCount
string lsPallet, lsSerial,  lsSKU, lsUf1, lsUf2, lsUf3, lsUf4, lsUf5
string lsLotNo, lsSQLSyntax, ERRORS, lsTemp

lsSQLSyntax = "select pallet_id, serial_no, SKU, user_field1, user_field2, user_field3, user_field4, user_field5 " &
		+ "FROM carton_serial WHERE project_id = '" + gs_project + "' " 
		
if isScannedPallets <> '' then
	lsTemp = left(isPallets,4) + "(" + right(trim(isPallets),len(isPallets)-4)
	lsSQLSyntax += lsTemp + " or " + right(isScannedPallets,len(isScannedPallets) - 4) + " )"
else
	lsSQLSyntax += isPallets
end if

ids_Serials.Create(SQLCA.SyntaxFromSQL(lsSQLSyntax,"", ERRORS))
ids_Serials.SetTransObject(SQLCA)
retVal = ids_Serials.retrieve()

return retVal

end function

public function integer uf_getserialrow (string as_serial);int retVal, liRows, liRow

retVal = 0

liRows = ids_serials.RowCount()
for liRow = 1 to liRows
	If ids_serials.GetItemString(liRow, 2) = as_serial Then
		retVal = liRow
	End If
Next

return retVal
end function

public function integer uf_update_serialds (long as_row, string as_pallet, string as_sku, string as_remark);int retVal = 0

ids_serials.SetItem(as_row,1,as_pallet)
ids_serials.SetItem(as_row,3,as_sku)
ids_serials.SetItem(as_row,9,as_remark)

return retVal

end function

public function integer uf_findnewscan ();int retVal, liRow, liRows

retVal = 0

liRows = idw_putaway.RowCount()
if liRows > 0 Then
	For liRow = 1 to liRows
		if idw_putaway.GetItemNumber(liRow, "quantity") < iiUnitsPerPallet Then
			retVal = liRow
		End if
	Next
Else
	retVal = -1		// No rows found in putaway list
End If

return retVal

end function

public function integer uf_setpallets ();// Returns the number of picking rows with serial numbers and set isPallets for query

int liRows, liRow
string ls_palletid, ls_where

ls_where = ""

liRows = idw_picking.RowCount()
for liRow = 1 to liRows
	ls_palletid = idw_picking.GetItemString(liRow, "lot_no")
	if ls_palletid <> '-' then
		ls_where += "'" + ls_palletid + "',"
	end if
next

ls_where = left(ls_where,len(ls_where)-1)
isPallets = "and pallet_id in (" + ls_where + ")"

return liRows
end function

public function integer uf_setconfirmputawayind ();int liRow
liRow = 0

iiPutawayRows = idw_putaway.RowCount()
For liRow = 1 to iiPutawayRows
	idw_putaway.SetItem(liRow, "c_confirm_putaway_ind","Y")
Next

return liRow

end function

public function integer uf_getpickingdetail (string as_wono);/* Populate ids_PickDetail and initialize isOrigRoNo */
int retVal = 0
string ls_sku,ls_whcode,ls_lcode,ls_itype,ls_sno,ls_lno, lsWONO, ls_status, ls_ro,ls_pono,ls_supp_code
String ls_coo, ls_po_no2, lsCompInd,lsSkuParent, ls_container_id  
datetime ldt_expiration_date
long ll_owner_id,llComponent,llID,llLineItemNo
int li_ret

	lsWONO = idw_picking.GetItemString(iiPickingRow,'wo_no')
	
	ls_sku = idw_picking.GetItemString(iiPickingRow,'sku')
	ls_supp_code = idw_picking.GetItemString(iiPickingRow,'supp_code')
	ll_owner_id = idw_picking.GetItemNumber(iiPickingRow,'owner_id')
	ls_coo = idw_picking.GetItemString(iiPickingRow,'country_of_origin')
	ls_lcode = idw_picking.GetItemString(iiPickingRow,'l_code')
	ls_itype = idw_picking.GetItemString(iiPickingRow,'inventory_type')
	ls_sno = idw_picking.GetItemString(iiPickingRow,'serial_no')
	ls_lno = idw_picking.GetItemString(iiPickingRow,'lot_no')
	ls_pono = idw_picking.GetItemString(iiPickingRow,'po_no')
	ls_po_no2 = idw_picking.GetItemString(iiPickingRow,'po_no2')
	llLineItemNo = idw_picking.GetItemNumber(iiPickingRow,'line_item_no')
	ls_container_id = idw_picking.GetItemString(iiPickingRow,'container_id')
	ldt_expiration_date = idw_picking.GetItemDatetime(iiPickingRow,'expiration_date')
	
	retVal = ids_pickdetail.Retrieve(lsWONO,ls_sku,ls_supp_code,ll_owner_id,ls_coo,ls_lcode,ls_itype,ls_sno,ls_lno,ls_pono,ls_po_no2,llLineItemNo,ls_container_id,ldt_expiration_date)

	if retVal = 1 then
		isOrigRONo = ids_pickdetail.GetItemString(retVal,"ro_no")
	else
		if retVal <= 0 then
			MessageBox("Picking Detail Error","Could not retrieve picking detail record")
		else
			MessageBox("Picking Detail Error","There are more that one picking detail records")
		end if
	end if
	
return retVal

end function

public function integer uf_pallet_label (integer airow, string asformat);String	lsFormat, lsCount, lsFind
Long		 llLabelPos, llCount
Integer	liCheck
lsFormat = asFormat
String 		quote = "'"

/* Do not need quantity - this code is unneeded 
if iiPutawayRow = 0 then
	lsFind = "lot_no = " + quote + dw_label.getITemString(airow, 'pallet_id') + quote
	iiPutawayRow = idw_putaway.Find(lsFind, 1, iiPutawayRows)
end if
llCount = idw_putaway.GetItemNumber(iiPutawayRow,"quantity")
*/

//Model
lsFormat = invo_labels.uf_replace(lsFormat,"~~model~~",String(dw_label.getITemString(airow,'model')))

//Pallet ID
lsFormat = invo_labels.uf_replace(lsFormat,"~~pallet_id~~",String(dw_label.getITemString(airow,'pallet_id')))

//Swedish characters need to be 'cleansed'
lsFormat = f_cleanse_printer(lsFormat)

isLabels[1] = lsFormat

return 0

end function

public function integer uf_enableconfirmputawayind ();int i, retVal, j
String lsUf2

j = 0
if (isOrdStatus <> 'C') then

	iiPutawayRows = idw_putaway.RowCount()
	for i = 1 to iiPutawayRows
		lsUf2 = idw_putaway.GetItemString(i, "user_field2") 
		if ( isNull(lsUf2) )  then
			idw_putaway.SetItem(i, "c_confirm_putaway_ind", "Y")
			j = 1
		end if
	next
	
	// Enable Putaway Confirm Button if any putaway records need to be confirmed
	If ( j = 1 ) then
		w_workorder.tab_main.tabpage_putaway.cb_confirm_putaway.enabled = true
	end if
	
end if

return retVal
end function

public subroutine uf_reprintlabelonly ();
dw_label.visible = false
cb_newpallet.visible = false
cbx_unitsperpallet.visible = false
sle_unitsperpallet.visible = false
st_unitsperpallet.visible = false
st_unitscanned.visible = false
st_scanned.visible = false

st_reprint.visible = true
if iiLabelToPrint = 1 then 
	st_reprint.text = "Reprint Serial Number Label"
	gb_condition.visible = true
	rb_conditionNew.visible = true
	rb_conditionUsed.visible = true
	rb_conditionNew.checked = true
Else
	st_reprint.text = "Reprint Pallet Label"
End if

return
end subroutine

public function integer uf_setserialdata (string as_serialno, integer ai_type);/* Query ai_type:   */


int retVal
long llRowCount
string ls_sqlsyntax, ERRORS

ls_sqlsyntax =    "select rtrim(pallet_id),rtrim(serial_no),sku,user_field1,"
ls_sqlsyntax += "user_field2,user_field3,user_field4,user_field5 "
ls_sqlsyntax += "from carton_serial where project_id = '" + gs_project + "' "

Choose Case ai_type
	case 0
		ls_sqlsyntax += isPallets + " and serial_no = '" + as_serialno + "' "
	case 1
		ls_sqlsyntax += isOrigPalletID + " and serial_no = '" + as_serialno + "' "
	case 2
		ls_sqlsyntax += " and serial_no = '" + as_serialno + "' "
end choose

ids_serial.Create(SQLCA.SyntaxFromSQL(ls_sqlsyntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
   Messagebox('Generate Details', 'Unable to retrieve serial data: ' + Errors)
   RETURN - 1
END IF

ids_serial.SetTransObject(SQLCA)
llRowCount = ids_serial.retrieve()

return llRowCount

end function

public function integer uf_loadpalletserials (string as_palletid);int retVal, liSRow
string lsPallet, lsSerial,  lsSKU, lsUf1, lsUf2, lsUf3, lsUf4, lsUf5

lsPallet = ""
lsSerial = ""
lsSKU = ""
lsUf1 = ""
lsUf2 = ""
lsUf3 = ""
lsUf4 = ""
lsUf5 = ""

retVal = 0

ids_serials.Reset()

	DECLARE si_picking CURSOR FOR
	select pallet_id, serial_no, SKU, user_field1, user_field2, user_field3, user_field4, user_field5 
	FROM carton_serial WHERE project_id = :gs_project and pallet_id = :as_palletid;

	OPEN si_picking;
		if SQLCA.SQLCODE <>0 then
			MessageBox("Error opening cursor si_picking  in uf_load_carton_serial",SQLCA.SQLErrText)
		else
			Fetch si_picking Into :lsPallet, :lsSerial, :lsSKU, :lsUf1, :lsUf2, :lsUf3, :lsUf4, :lsUf5;
				DO WHILE SQLCA.SQLCODE <> 100
					liSRow = ids_serials.InsertRow(0)
					ids_serials.SetItem(liSRow, 1, lsPallet)
					ids_serials.SetItem(liSRow, 2, lsSerial)
					ids_serials.SetItem(liSRow, 3, lsSKU)
					ids_serials.SetItem(liSRow, 4, lsUf1)
					ids_serials.SetItem(liSRow, 5, lsUf2)
					ids_serials.SetItem(liSRow, 6, lsUf3)
					ids_serials.SetItem(liSRow, 7, lsUf4)
					ids_serials.SetItem(liSRow, 8, lsUf5)
					ids_serials.SetItem(liSRow, 9, string(liSRow))
					Fetch si_picking Into :lsPallet, :lsSerial, :lsSKU, :lsUf1, :lsUf2, :lsUf3, :lsUf4, :lsUf5;
				LOOP
		end if
	CLOSE si_picking;

	retVal = ids_serials.RowCount()
	
return retVal

end function

public function integer uf_getvalidserials ();int llRowCount
string ls_sqlsyntax, ERRORS

ls_sqlsyntax =    "select 'unscanned', rtrim(serial_no) "
ls_sqlsyntax += "from carton_serial where project_id = '" + gs_project + "' " + isPallets + " "

If idw_putaway.RowCount() > 0 Then
	uf_setScannedPallets()
	ls_sqlsyntax += "UNION Select 'scanned', rtrim(serial_no) "
	ls_sqlsyntax += "from carton_serial where project_id = '" + gs_project + "' " + isScannedPallets
End if

ids_validSerials.Create(SQLCA.SyntaxFromSQL(ls_sqlsyntax,"", ERRORS))
ids_validSerials.SetTransObject(SQLCA)
llRowCount = ids_validSerials.retrieve()

if llRowCount < 0 then
	MessageBox("Get Valid Serial Numbers", "An error occurred will retrieving valid serial numbers.  See your System Administrator.")
end if

return llRowCount

end function

public function integer uf_setscannedpallets ();// Returns the number of putaway rows

int liRows, liRow
string ls_palletid, ls_where

ls_where = ""

liRows = idw_putaway.RowCount()
for liRow = 1 to liRows
	ls_palletid = idw_putaway.GetItemString(liRow, "lot_no")
	ls_where += "'" + ls_palletid + "',"
next

ls_where = left(ls_where,len(ls_where)-1)
isScannedPallets = "and pallet_id in (" + ls_where + ")"

return liRows
end function

public function integer uf_update_carton_serial (string as_serialno, string as_palletid, string as_sku, string as_suppcode);/* Update 4/24/2012 - GXMOR - added isOrigPalletID to change only the SN for the original pallet id */

int retVal = 0
int li_alloc_qty, li_c
string ls_sqlsyntax, lsErrText

		Execute Immediate "Begin Transaction" using SQLCA;

		update carton_serial
		set pallet_id =:as_palletid, sku = :as_sku, supp_code = :as_suppcode
		where project_id = :gs_project
		and serial_no = :as_serialno and pallet_id = :isOrigPalletID
		Using SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "Rollback" using SQLCA;
			Messagebox("Update Carton/Serial", " Unable to update pallet ID: " + as_palletid + " in carton/serial to database!~r~r" + lsErrText)
			Return -1
		Else			
			// Update putaway list for this serial number scan
			retVal = idw_putaway.Update()
			if retVal = 1 then
				Execute Immediate "Commit" using SQLCA;
				idw_putaway.Retrieve(isWONo)
			else
				Execute Immediate "Rollback" using SQLCA;
				Messagebox("Update Carton/Serial", " Unable to update pallet ID: " + as_palletid + " in the putaway list!~r~rReturnValue: " + string(retVal))
				Return -1
			end if
		End If	

return retVal

end function

on w_comcast_sik_kit_label.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_newpallet=create cb_newpallet
this.cbx_unitsperpallet=create cbx_unitsperpallet
this.st_unitscanned=create st_unitscanned
this.sle_printer=create sle_printer
this.st_1=create st_1
this.cb_changeprinter=create cb_changeprinter
this.sle_barcodes=create sle_barcodes
this.sle_unitsperpallet=create sle_unitsperpallet
this.st_unitsperpallet=create st_unitsperpallet
this.st_2=create st_2
this.st_scanned=create st_scanned
this.st_reprint=create st_reprint
this.rb_conditionnew=create rb_conditionnew
this.rb_conditionused=create rb_conditionused
this.gb_condition=create gb_condition
this.dw_label=create dw_label
this.cb_quit=create cb_quit
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_newpallet
this.Control[iCurrent+3]=this.cbx_unitsperpallet
this.Control[iCurrent+4]=this.st_unitscanned
this.Control[iCurrent+5]=this.sle_printer
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cb_changeprinter
this.Control[iCurrent+8]=this.sle_barcodes
this.Control[iCurrent+9]=this.sle_unitsperpallet
this.Control[iCurrent+10]=this.st_unitsperpallet
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_scanned
this.Control[iCurrent+13]=this.st_reprint
this.Control[iCurrent+14]=this.rb_conditionnew
this.Control[iCurrent+15]=this.rb_conditionused
this.Control[iCurrent+16]=this.gb_condition
this.Control[iCurrent+17]=this.dw_label
this.Control[iCurrent+18]=this.cb_quit
end on

on w_comcast_sik_kit_label.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_newpallet)
destroy(this.cbx_unitsperpallet)
destroy(this.st_unitscanned)
destroy(this.sle_printer)
destroy(this.st_1)
destroy(this.cb_changeprinter)
destroy(this.sle_barcodes)
destroy(this.sle_unitsperpallet)
destroy(this.st_unitsperpallet)
destroy(this.st_2)
destroy(this.st_scanned)
destroy(this.st_reprint)
destroy(this.rb_conditionnew)
destroy(this.rb_conditionused)
destroy(this.gb_condition)
destroy(this.dw_label)
destroy(this.cb_quit)
end on

event open;call super::open;invo_labels = Create n_labels
string lsNew, lsOld, lsText
int liRec

lsNew = 'MAC Address'
lsOld = 'Unit Identifier'

//Set print text
isPrintText = 'Comcast Rekit Labels '

//Retrieive necessary formats
isShipFormat = invo_labels.uf_read_label_Format("Comcast_Rekit_Label.txt")
isPalletFormat = invo_labels.uf_read_label_Format("Comcast_rekit_pallet_label.txt")

isShipFormat = replace(isShipFormat,pos(isShipFormat, lsOld),len(lsOld),lsNew)
isLabels[1] = isShipFormat		// Initialize labels

uf_loadprinter()

istrparms = Message.PowerObjectParm
idw_detail = istrparms.Datawindow_arg[1]
idw_picking = istrparms.Datawindow_arg[2]
idw_putaway = istrparms.Datawindow_arg[3]
isOrdStatus = istrparms.String_arg[1]				// Order status

idw_putaway.SetTransObject(SQLCA)

ids_pickdetail = Create datastore					// WO does not keep pick detail except when saving
ids_pickdetail.DataObject = 'd_work_order_pick_detail'
ids_pickdetail.SetTransObject(SQLCA)
ids_serial = Create datastore						// Hold one serial record
ids_serial.DataObject = 'd_comcast_recon' 
ids_serials = Create datastore						// Hold alll possible serial records
ids_serials.DataObject = 'd_comcast_recon'
ids_validSerials = Create datastore				// Hold valid serial numbers to scan
ids_validSerials.DataObject = 'd_find'
ids_validSerials.SetTransObject(SQLCA)

//Initialize
 iiLabelToPrint = 0										// Reprint a label (0 = No reprint, 1 = SN, 2 = Pallet)
 iiUnitsPerPallet = 0
 iiUnitsScanned = 0
 iiTotalUnitsScanned = 0
 iiPickingRows = uf_setPallets()						// Use to query carton/serial
 iiPickingRow = 1										// Begin with picking row one for pallet
 uf_getValidSerials()
 iiPutawayRows = idw_putaway.RowCount()	// Putaway rows, if any
 isCondition = "New"									// Initialize condition to New
 idtToday = f_getLocalWorldTime( g.getCurrentWarehouse() ) 

liRec = uf_loadserialdata()							// Load picking and putaway serial data

If idw_picking.RowCount() = 0 Then
	MessageBox("Comcast SIK Modem Kitting Error","Scan Units cannot continue without Component Picking Data")
	 TriggerEvent("ue_close")
Else
	 isWONo = idw_picking.GetItemString(1, "WO_No")
	 iiPickingDetailRow = uf_getpickingdetail(isWONo)						// Update isOrigRoNo & populate picking detail DS
End If
 

end event

event ue_postopen;call super::ue_postopen;string lsPalletID, lsMsg, lsTitle
int li_error, li_row

li_row = 1		// Only one record for dw_label
lsTitle = "Modem/Remote Kitting Error"
isSuppCode = idw_detail.GetItemString(1, "supp_code")		// Use detail supplier code
ilOwnerID = idw_detail.GetItemNumber(1, "owner_id") 		// Use detail owner id
//Get kit SKU
li_error = uf_getitemmasterparameters(idw_detail.GetItemString(1,"sku"),isSuppCode)
if li_error = -1 Then
	lsMsg = "Could not find Kit SKU for SKU: " + idw_detail.GetItemString(1,"sku") + " with supplier code: " + isSuppCode + ".  Cannot continue."
	MessageBox(lsTitle, lsMsg)
	TriggerEvent("ue_close")
Else
	if iiUnitsPerPallet = 0 then
		lsMsg =    "SKU " + idw_detail.GetItemString(1,"sku") + " does not contain a pallet quantity to determine units per pallet. ~n~n"
		lsMsg += "Please enter Units per Pallet."
		MessageBox(lsTitle,lsMsg)
		cbx_unitsperpallet.checked = true
		sle_unitsperpallet.SetFocus()
	else
		iiOrigUnitsPerPallet = iiUnitsPerPallet			// Units per pallet can be changed from ItemMaster setting
		sle_unitsperpallet.text = string(iiUnitsPerPallet) 
		cbx_unitsperpallet.checked = true
		ibInitialized = TRUE
		TriggerEvent("ue_initialize")
	End if
End If


end event

type cb_cancel from w_response_ancestor`cb_cancel within w_comcast_sik_kit_label
boolean visible = false
integer x = 2021
integer y = 424
integer height = 92
integer taborder = 50
boolean enabled = false
string text = "Cancel"
end type

event cb_cancel::clicked;call super::clicked;// Save putaway list before quitting window



//idw_putaway.Update()




end event

type cb_ok from w_response_ancestor`cb_ok within w_comcast_sik_kit_label
integer x = 41
integer y = 1028
integer taborder = 0
boolean enabled = false
boolean default = false
end type

type cb_print from commandbutton within w_comcast_sik_kit_label
boolean visible = false
integer x = 37
integer y = 72
integer width = 329
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Print"
end type

event clicked;Parent.TriggerEvent('ue_Print')



end event

type cb_newpallet from commandbutton within w_comcast_sik_kit_label
integer x = 32
integer y = 32
integer width = 402
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Pallet"
end type

event clicked;string ls_pallet_id

if cbx_unitsperpallet.checked then
	MessageBox("Request for New PalletID","Units per pallet must be changed to request a new pallet ID.  Uncheck New Pallet and change units.")
else
	ls_pallet_id = uf_getnewfgpalletid()
	dw_label.SetItem(1, 'pallet_id', ls_pallet_id)
	cbx_unitsperpallet.checked = true
	
	MessageBox("New Pallet","Pallet_ID: " + ls_pallet_id)
end if
end event

type cbx_unitsperpallet from checkbox within w_comcast_sik_kit_label
integer x = 594
integer y = 60
integer width = 599
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "New pallet every "
end type

event clicked;
If this.checked Then
	sle_unitsperpallet.SetFocus()
Else
	sle_unitsperpallet.text = string(iiOrigUnitsPerPallet)
	iiUnitsPerPallet = iiOrigUnitsPerPallet
	sle_barcodes.SetFocus()
End If


end event

type st_unitscanned from statictext within w_comcast_sik_kit_label
integer x = 1682
integer y = 64
integer width = 443
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Units Scanned:            "
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_printer from singlelineedit within w_comcast_sik_kit_label
integer x = 274
integer y = 176
integer width = 1710
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12639424
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_comcast_sik_kit_label
integer x = 32
integer y = 176
integer width = 233
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Printer:"
boolean focusrectangle = false
end type

type cb_changeprinter from commandbutton within w_comcast_sik_kit_label
integer x = 2016
integer y = 176
integer width = 274
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change"
end type

event clicked;String lsPrinter

printsetup()

lsPrinter = ids_dw.describe('datawindow.printer')

// We want to store the last printer used for Printing the Welcome lettert for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile, 'PRINTERS','WOScanUnits', lsPrinter)

g.ibNoPromptPrint = False

sle_printer.text = lsPrinter
end event

type sle_barcodes from singlelineedit within w_comcast_sik_kit_label
integer x = 581
integer y = 292
integer width = 1403
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;
		
		if ( iiLabelToPrint = 0 ) then
			Parent.TriggerEvent("ue_process_barcodes")
		Else
			Parent.TriggerEvent("ue_reprint_label")
		End if



end event

event getfocus;// Disable Quit button until focus is lost
cb_quit.enabled = false

end event

event losefocus;// Re-enable Quit button
cb_quit.enabled = true

end event

type sle_unitsperpallet from singlelineedit within w_comcast_sik_kit_label
integer x = 1189
integer y = 60
integer width = 169
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;
iiUnitsPerPallet = integer(sle_unitsperpallet.text)

If iiUnitsPerPallet > 0 Then
	If NOT  ibInitialized Then
		iiOrigUnitsPerPallet = iiUnitsPerPallet			
		ibInitialized = TRUE
		Parent.TriggerEvent("ue_initialize")
	End If
	cbx_unitsperpallet.checked = True
	sle_barcodes.SetFocus()
Else
	MessageBox("Units Per Pallet Error","Must enter a number to set units per pallet")
	sle_unitsperpallet.SetFocus()
End If
end event

event getfocus;
sle_unitsperpallet.SelectText(1,len(sle_unitsperpallet.Text))

end event

type st_unitsperpallet from statictext within w_comcast_sik_kit_label
integer x = 1367
integer y = 60
integer width = 215
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
string text = " units."
boolean focusrectangle = false
end type

type st_2 from statictext within w_comcast_sik_kit_label
integer x = 32
integer y = 304
integer width = 544
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Scan Serial No:"
boolean focusrectangle = false
end type

type st_scanned from statictext within w_comcast_sik_kit_label
integer x = 2185
integer y = 56
integer width = 105
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type st_reprint from statictext within w_comcast_sik_kit_label
boolean visible = false
integer x = 512
integer y = 32
integer width = 1371
integer height = 104
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reprint"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_conditionnew from radiobutton within w_comcast_sik_kit_label
boolean visible = false
integer x = 59
integer y = 492
integer width = 544
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
string text = "Condition   New"
boolean checked = true
boolean lefttext = true
end type

type rb_conditionused from radiobutton within w_comcast_sik_kit_label
boolean visible = false
integer x = 640
integer y = 492
integer width = 279
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
string text = "Used"
end type

type gb_condition from groupbox within w_comcast_sik_kit_label
boolean visible = false
integer x = 37
integer y = 436
integer width = 887
integer height = 156
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_label from u_dw_ancestor within w_comcast_sik_kit_label
integer x = 32
integer y = 444
integer width = 2263
integer height = 276
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_comcast_sik_rekit_label_grid"
boolean vscrollbar = true
boolean resizable = true
end type

event constructor;call super::constructor;DataWindowChild ldwc_condition
String ls_new, ls_used, ls_ColName,ls_DisplayCol,ls_DataCol 


//Insert Row into dw
dw_label.InsertRow(0)

//Create wh nvo
i_nwarehouse = Create n_warehouse

i_nwarehouse.of_init_inv_ddw(dw_label,TRUE) 
dw_label.GetChild('condition',ldwc_condition)
ldwc_condition.SetTransObject(SQLCA)

//Retrieve dddw
ldwc_condition.Retrieve(gs_project)

//SetFilter
ldwc_condition.SetFilter("inv_type_desc= 'Normal' OR inv_type_desc= 'USED'")

//Filter
ldwc_condition.Filter() 

//After filter, change Normal to NEW as per spec...
ldwc_condition.SetItem(1,"inv_type_desc","NEW")



end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event clicked;call super::clicked;String ls_Model, ls_Condition, ls_SerialNo, ls_UnitId

/*
THIS.AcceptText()

//Get values of model and condition
ls_Model = THIS.GetItemString(1, "model")
ls_Condition = THIS.GetItemString(1, "condition")
ls_SerialNo = THIS.GetItemString(1, "serial_no")

//Protect Serial Number and unit ID if BOTH Model and Condition are not yet entered 
IF (IsNull(ls_Model) OR ls_Model = '') OR (IsNull(ls_Condition) OR ls_Condition = '') THEN
	THIS.Object.serial_no.Protect = 1
	THIS.Object.unit_id.Protect = 1
ELSE
	THIS.Object.serial_no.Protect = 0
	THIS.Object.unit_id.Protect = 0
END IF
		
//Unit Id cannot be valid until Serial number has been entered
IF IsNull(ls_SerialNo) OR ls_SerialNo ="" THEN
	//Remove any previously entered unit id
	THIS.SetItem(1,"unit_id", "")
ELSE
	
	//Populate unit id if serial no is already on file
	SELECT Max(user_field1)
	INTO :ls_UnitId
	FROM carton_serial
	WHERE project_id = 'Comcast'
	and serial_no = :ls_SerialNo;
	
	IF IsNull(ls_UnitId) OR ls_UnitId ="" THEN
		//No Unit ID associated with this Serial Number in table. Get Unit ID from datawindow...if already populated
		ls_UnitId = THIS.GetItemString(1, "unit_id")
	ELSE
		//Set Unit ID to value in table
		THIS.SetItem(1,"unit_id", ls_UnitId)

	END IF
	
	//Invoke Print Routine at this point...only if unit id is populated
	IF IsNull(ls_UnitId) OR ls_UnitId = "" THEN
		//Do nothing
	ELSE
		Parent.TriggerEvent('ue_Print')
	END IF
	
END IF
				
*/


end event

type cb_quit from commandbutton within w_comcast_sik_kit_label
integer x = 2016
integer y = 292
integer width = 274
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Quit"
end type

event clicked;// Ask before actually quitting....

If messagebox("Scan Units Complete","Do you wish to quit this window?",Question!,YesNo!) = 1 Then
	cb_cancel.TriggerEvent("clicked")
End if

end event

