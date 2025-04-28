$PBExportHeader$w_putaway_scan.srw
$PBExportComments$Putaway Scan logic used to generate Putaway List
forward
global type w_putaway_scan from w_response_ancestor
end type
type sle_barcode from singlelineedit within w_putaway_scan
end type
type st_text_1 from statictext within w_putaway_scan
end type
type sle_qty from singlelineedit within w_putaway_scan
end type
type sle_sku from singlelineedit within w_putaway_scan
end type
type st_1 from statictext within w_putaway_scan
end type
type st_2 from statictext within w_putaway_scan
end type
type st_sku from statictext within w_putaway_scan
end type
end forward

global type w_putaway_scan from w_response_ancestor
integer width = 2322
integer height = 924
string title = "Putaway Scan"
sle_barcode sle_barcode
st_text_1 st_text_1
sle_qty sle_qty
sle_sku sle_sku
st_1 st_1
st_2 st_2
st_sku st_sku
end type
global w_putaway_scan w_putaway_scan

type variables
String isOverPick
end variables

forward prototypes
public function integer uf_process_lmc_scan ()
public subroutine dodisplaymessage (string _title, string _message)
public function integer uf_process_physio_scan ()
end prototypes

public function integer uf_process_lmc_scan ();String	lsBarcode, lsPackConfig, lsLMAPrefix, lsProdCode, lsSKU, lsUOM1, lsUOM2, lsUOM3, lsUOM4, lsLot, lsSerial, lsExpDate, lsCOO, lsPackUOM, lsFind
Long		llQty2, llQty3, llQty4, llPAckQty, llNewRow, llDetailFindRow, llPutawayFindRow, llPalletQty
Boolean	lbNewRow
lsBarcode = sle_barcode.Text


//Parse out The Barcode...

// Must be 33 or 35 characters depending on on type (RE-usable of Single Use)
If Len(lsBarcode) = 32 or Len(lsBarcode) = 34 Then
Else
	doDisplayMessage('Putaway Scan',"Invalid Barcode Length (" + string(len(lsBarcode)) + "). Must be 32 for Single Use and 34 for Re-usable parts.")
	Return -1
End If

//First 2 characters must be '01' (AI for GTIN)
If Left(lsBarcode,2) <> '01' Then
	doDisplayMessage('Putaway Scan',"Invalid Barcode (Must begin with '01')")
	Return -1
End If


//PAcking Configuration (will be validated against Item Master below) - Convert to the SIMS UOM so we can maintain meaningfull UOM's in SIMS
lsPAckConfig = Mid(lsBarcode,3,1)

Choose Case lsPAckConfig
		
	Case '0'
		lsPackUOM = 'EA'
	Case '1'
		lsPAckUOM = 'BAG'
	Case '2'
		lsPAckUOM = 'CTN'
	Case '5'
		lsPAckUOM = 'PLT'
	Case Else
		doDisplayMessage('Putaway Scan',"Invalid Pack Configuration (" + lsPAckConfig + ")")
		Return -1
End Choose

//LMA Prefix - Must always be "506011231"
lsLMAPRefix = Mid(lsBarcode,4,9)

If lsLMAPrefix <> "506011231" Then
	doDisplayMessage('Putaway Scan',"Invalid LMA Prefix (Must equal '506011231')")
	Return -1
End If



//3 digit product code registered with GS1 (SIMS Alternate SKU)
lsProdCode = Mid(lsBarcode,13,3)

//Validate SKU - We will also be validating UOM's and Qty below

st_Text_1.Text = "Retrieving Item Master information..."

Select SKU, uom_1, uom_2, uom_3, uom_4,  Qty_2, Qty_3, Qty_4, Country_of_origin_Default
into :lsSKU, :lsUOM1, :lsUOM2, :lsUOM3, :lsUOM4,  :llQty2, :llQty3, :llQty4, :lsCOO
From Item_MAster where project_id = 'LMC' and Alternate_SKU = :lsProdCode and Supp_Code = 'LMC';

st_Text_1.Text = ""

If lsSKU = '' Then
	doDisplayMessage('Putaway Scan',"Invalid Product Identification Code (Alt SKU '" + lsProdCode + "' Not found)")
	Return -1
End If

//Validate Pack Config against UOM's and make sure Qty exists in Item Master

llPackQty = 0

If lsPAckUOM = lsUOM1 Then
	llPackQty = 1
ElseIf lsPAckUOM = lsUOM2 Then
	llPackQty = llQty2
ElseIf lsPAckUOM = lsUOM3 Then
	llPackQty = llQty3
ElseIf lsPAckUOM = lsUOM4 Then
	llPackQty = llQty4
Else /*Invalid PAck Qty */
	doDisplayMessage('Putaway Scan',"Pack Configuration '" + lsPAckUOM + "' Not configured for this Item (" + lsSKU + ")")
	Return -1
End If

If llPAckQty = 0 Then
	doDisplayMessage('Putaway Scan',"No Qty in Item Master (" + lsSKU + ") for this Pack Configuration (" + lsPAckUOM + ")")
	Return -1
End If

//We want to know what the Pallet Qty is for consolidating Putaway Rows
If lsUOM2 = 'PLT' Then
	llPalletQty = llQty2
elseIf lsUOM3 = 'PLT' Then
	llPalletQty = llQty3
Elseif lsUOM4 = 'PLT' Then
	llPalletQty = llQty4
Else
	llPalletQty = 0
End If

//Lot NUmber - make sure it has a valid Luhn Algorithm check digit
If Mid(lsBarcode,17,2) = '10' Then /* AI for Lot # */

	lsLot = Mid(lsBarcode,19,6)
	
	If not w_ro.iuo_check_digit_validations.uf_validate_luhn(lsLot) Then
		doDisplayMessage('Putaway Scan',"Invalid Lot Number (" + lsLot + ").")
		Return -1
	End IF
	
Else /* No idenetifier for Lot */
	
	doDisplayMessage('Putaway Scan',"No Application Identifier (AI) for Lot Number (required field).")
	Return -1
	
End If

//Next (last) field is either a Serial Number (starting for pack config) for a reusible product or an Expiration Date for a single use
If Mid(lsBarcode,25,2) = '21' Then /* AI for Serial */
	
	lsSerial = Mid(lsBarcode,27,8)
	lsExpDate = ''
	
	//TODO - Validate Check Digit for SN
	
ElseIf Mid(lsBarcode,25,2) = '17' Then /* AI for Exp DT */
	
	lsExpDate = Mid(lsBarcode,27,6) /* YYMMDD */
	lsSerial = ''
	
Else /* Invalid AI */
	
	doDisplayMessage('Putaway Scan',"No Application Identifier (AI) for Serial Number or Expiration Date.")
	Return -1
	
End If


//We will either consolidate Putaway Rows (like SKU/Lot/Exp DT (if Applicable.) for all pack configs other than Pallet (3). 
//We will always add a new Putaway Row for a new Pallet

llDetailFindRow = w_ro.idw_Detail.Find("Upper(SKU) = '" + Upper(lsSKU) + "'",1,w_ro.idw_Detail.RowCount()) //We need the DEtail Row for this SKU

If llDetailFindRow <=0 Then /* No detail row */
	doDisplayMessage('Putaway Scan',"Order Detail Record not found for SKU '" + lsSKU + "'")
	Return -1
End If

If lsPAckUOM = 'PLT' Then /* Pallet scanned */
	lbNewRow = True
Else /* see if we already have a row for this sku/lot*/
	
	lsFind = "Upper(sku) = '" + Upper(lsSKU) + "' and Upper(lot_No) = '" + Upper(lsLot) + "'"
	
	If lsExpDate > '' Then /* Include Exp DT in Find if tracking by Exp Dt */
		lsFind += " and String(expiration_date,'yymmdd') = '" + lsExpDate + "'" 	
	End If

	If llPalletQty > 0 Then
		lsFind += " and quantity <> " + String(llPalletQty) /* don't consolidate to a full pallet*/
	End If
	
	llPutawayFindRow = w_ro.idw_Putaway.Find(lsFind,1,w_ro.idw_putaway.RowCount())
	
	If llPutawayFindRow <= 0 Then
		lbNewRow = True
	End If
	
End If

If lbNewRow Then

	llNewRow = w_ro.idw_Putaway.InsertRow(0)

	w_ro.idw_Putaway.SetITem(llNewRow,'lot_controlled_ind','Y')

	w_ro.idw_Putaway.SetITem(llNewRow,'ro_no',w_ro.idw_Main.GetITemString(1,'ro_no'))
	w_ro.idw_Putaway.SetITem(llNewRow,'line_item_no',w_ro.idw_Detail.GetITemNumber(llDetailFindRow,'line_item_no'))
	w_ro.idw_Putaway.SetITem(llNewRow,'sku',lsSKU)
	w_ro.idw_Putaway.SetITem(llNewRow,'sku_parent',lsSKU)
	w_ro.idw_Putaway.SetITem(llNewRow,'supp_code',w_ro.idw_Detail.GetITemString(llDetailFindRow,'supp_code'))
	w_ro.idw_Putaway.SetITem(llNewRow,'c_owner_name',w_ro.idw_Detail.GetITemString(llDetailFindRow,'c_owner_name'))
	w_ro.idw_Putaway.SetITem(llNewRow,'owner_id',w_ro.idw_Detail.GetITemNumber(llDetailFindRow,'owner_id'))
	w_ro.idw_Putaway.SetITem(llNewRow,'country_of_Origin',lsCoo)
	w_ro.idw_Putaway.SetITem(llNewRow,'l_code',"")
	w_ro.idw_Putaway.SetITem(llNewRow,'inventory_type',w_ro.idw_Main.GetITemString(1,'inventory_type'))
	w_ro.idw_Putaway.SetITem(llNewRow,'lot_no',lslot)
	w_ro.idw_Putaway.SetITem(llNewRow,'component_ind',"N")
	w_ro.idw_Putaway.SetITem(llNewRow,'quantity',llPackQty)

	If lsExpDate > '' Then
		//lsExpDate = "20" + Left(lsExpDate,2) + "/" + Mid(lsExpDate,3,2) + "/" + Right(lsExpDate,2)
		lsExpDate = Mid(lsExpDate,3,2) + "/" + Right(lsExpDate,2) + "/20" + Left(lsExpDate,2)
		w_ro.idw_Putaway.SetITem(llNewRow,'expiration_date',Date(lsExpDate))
		w_ro.idw_Putaway.SetITem(llNewRow,'expiration_controlled_ind','Y')
	End If
	
	st_Text_1.Text = "Scan successful. Putaway Record ADDED. Scan next barcode or 'OK' to finish..."
	
Else /* Add qty to existing Putaway row */
	
	w_ro.idw_Putaway.SetItem(llPutawayFindRow, 'quantity',w_ro.idw_Putaway.getItemNumber(llPutawayFindRow, 'quantity') + llPackQty)
	st_Text_1.Text = "Scan successful. Putaway Record UPDATED. Scan next barcode or 'OK' to finish..."
End If /* New Putaway Row */

w_ro.idw_Putaway.TriggerEvent('ue_hide_Unused')
w_ro.ib_changed = True



Return 0
end function

public subroutine dodisplaymessage (string _title, string _message);// doDisplayMessage( string _title, string _message )

str_parms	lstrParms


lstrParms.string_arg[1] = _title
lstrParms.string_arg[2] = _message

openwithparm( w_scan_message, lstrParms )

end subroutine

public function integer uf_process_physio_scan ();String	lsUPN, lsDescript, lsLot, lsSN, lsExpiry, lsScan, lsPackConfig, lsLMAPrefix, lsProdCode, lsSKU, lsUOM1, lsUOM2
String lsUOM3, lsUOM4, lsSerial, lsExpDate, lsCOO, lsPackUOM, lsFind, lsRO_NO, lsSupplier, lsIMOwner_CD
String lsExpCont, lsSerCont, lsLotCont, lsPONOCont, lsPONO2Cont, lsConCont, lsPO_NO, lsPO_NO2, lsContainer,  lsOwner, lsSNNew, lsLotNew, lsIT, lsLoc, lsExpiryNew, lsUF1
Long		llQty2, llQty3, llQty4, llPAckQty, llNewRow, llDetailFindRow, llPutawayFindRow, llPalletQty, lSKUCount, lTotQty, lTemp, llLine_Item,  llOwner_ID, llEDI_Count
datastore dsGetLN
long lQty, ll_row
int iZeroCount = 0

lsUPN =  ""
lsLot = ""
lsSN = ""
lsExpiry = ""
lsScan = sle_barcode.text

if lsScan = "" then //don't whine about whatever when they haven't even entered anything and the field just lost focus
	return 0
end if

if sle_qty.text <> "" then
	lQty = Long(sle_qty.text)	 //hdc 10/12/2012 we may have already prompted for the quantity; if there's something in that field they entered it
else
	lQty = 0  //else init it
end if

if left(lsScan, 2) = "01" then  //hdc 10/12/2012 must start with 01
	lsScan = Mid(lsScan, 3, len(lsScan))
else
	sle_qty.text = ""	
	sle_barcode.SelectText(1,len(sle_barcode.text))	
	doDisplayMessage("Putaway Scan", "Invalid scan: First element is not tagged as UPN")
	return -1
end if

if len(lsScan) < 14 then //hdc 10/12/2012 can't think of any valid combination that could be shorter- so make a quick sanity check
	sle_qty.text = ""
	sle_barcode.SelectText(1,len(sle_barcode.text))
	doDisplayMessage("Putaway Scan", "Invalid scan: Scan too short")	
	return -1	
else
	do	while Mid(lsScan, 1, 1) = "0"  //hdc 10/12/2012 There may be leading zeros and UPN is a numeric field so strip off any leading zeros
		lsScan = Mid(lsScan, 2, len(lsScan))
		iZeroCount = iZeroCount + 1		
	loop
end if

lsUPN = Mid(lsScan, 1, 14-iZeroCount)  //hdc 10/12/2012 UPN is always 12 digits
lsScan = Mid(lsScan, 15-iZeroCount, len(lsScan)) //hdc 10/12/2012 Remove it from the scan

if left(lsScan,2) = "17" then //hdc 10/12/2012 read expiry date
	if Mid(lsScan,3,2) <> "NA" then //hdc 10/12/2012 Scan may include NA for a value which we want to simply skip over
		lsScan = Mid(lsScan, 3, len(lsScan))
		lsExpiry = Mid(lsScan, 1, 6)
		lsScan = Mid(lsScan, 7, len(lsScan))  //hdc 10/12/2012 remove it from the scan
	else
		lsScan = Mid(lsScan, 5, len(lsScan)) //hdc 10/12/2012 remove it from the scan
	end if
end if

if left(lsScan,2) = "10" then  //hdc 10/12/2012 read lot number

	if Mid(lsScan,3,2) <> "NA" then	
		lsScan = Mid(lsScan, 3, len(lsScan))
		lsLot = lsScan
	else  
		lsScan = Mid(lsScan, 5, len(lsScan))
	end if
	
elseif left(lsScan,2) = "21" then //hdc 10/12/2012 read serial number
	
		if Mid(lsScan,3,2) <> "NA" then		
			
				lsSN = Mid(lsScan, 3, len(lsScan))	
				lsScan = Mid(lsScan, 5, len(lsScan))				
				lQty = 1  //hdc 10/12/2012 if it's serialized, by definition, quantity is one
				lsFind = "Upper(serial_no) = '" + Upper(lsSN) + "'"
				
				if w_ro.idw_Putaway.Find(lsFind, 1, w_ro.idw_Putaway.RowCount()) > 0 then
					sle_qty.text = ""					
					sle_barcode.SelectText(1,len(sle_barcode.text))		
					doDisplayMessage('Putaway Scan',"That item has already been scanned (" + lsSN + ")")		
					return -1
					
				end if
		End if 
		
elseif len(lsScan) > 0 then //hdc 11/02/2012  There must be a bogus code left over; complain about it
	
	sle_qty.text = ""	
	sle_barcode.SelectText(1,len(sle_barcode.text))		
	doDisplayMessage("Putaway Scan", "Invalid scan: Unrecognized scan prefix " + Mid(lsScan,1,2)) //kinda sloppy with the case where there's only one remaining char, but PB handles it OK
	return -1		
	
end if

st_Text_1.Text = "Retrieving Item Master information..."

lsRO_NO = w_ro.idw_Main.GetITemString(1,'ro_no') //hdc 10/12/2012 Grab the RO_NO for lookups

if sle_sku.visible = true then //hdc 10/12/2012 if this is visible then we had multiple skus per UPN and prompted the user to enter the correct sku

	lsSKU = sle_sku.text
	lSKUCount = 1  //hdc 10/12/2012 pretend that we looked it up and it came back as a one to one relationship since the user just told us this is the valid sku
	
end if

if lsSKU = "" then  //hdc 10/12/2012  This is actually the first processing stop, as sle_sku will only be visible on the second pass, after this is processed

	// the check for empty sku is so we ONLY run this logic on the first pass; we need to check if there is a many to one relationnship between the sku and UPN
	select count(*)	into :lSKUCount from Item_Master with (nolock) &
		where Project_Id = :gs_project and Part_UPC_Code=:lsUPN and SKU in &
		(select SKU from Receive_Detail with (nolock) where Receive_Detail.RO_No= :lsRO_NO) ;
	
	select Upper(expiration_controlled_ind), Upper(serialized_ind), Upper(lot_controlled_ind), Upper(PO_Controlled_Ind), Upper(PO_No2_Controlled_Ind), Upper(Container_Tracking_Ind) &
		into :lsExpCont, :lsSerCont, :lsLotCont, :lsPONOCont, :lsPONO2Cont, :lsConCont from Item_Master with (nolock) &
		where Project_Id = :gs_project and Part_UPC_Code=:lsUPN and SKU in &
		(select SKU from Receive_Detail with (nolock) where Receive_Detail.RO_No= :lsRO_NO) group by expiration_controlled_ind, serialized_ind, lot_controlled_ind, PO_Controlled_Ind, PO_NO2_Controlled_Ind, Container_Tracking_Ind ;
		
else // regardless of which pass it is we still need the tracking information
	
//	select count(*)	into :lSKUCount from Item_Master with (nolock) where Project_Id = :gs_project and SKU = :lsSku;
	
	select count(*), Upper(expiration_controlled_ind), Upper(serialized_ind), Upper(lot_controlled_ind), Upper(PO_Controlled_Ind), Upper(PO_No2_Controlled_Ind), Upper(Container_Tracking_Ind) &
		into :lSKUCount, :lsExpCont, :lsSerCont, :lsLotCont, :lsPONOCont, :lsPONO2Cont, :lsConCont from Item_Master with (nolock) &
		where Project_Id = :gs_project and SKU = :lsSku &
		group by expiration_controlled_ind, serialized_ind, lot_controlled_ind, PO_Controlled_Ind, PO_NO2_Controlled_Ind, Container_Tracking_Ind; 		
		
end if
		
// 07/13 - PCONKL - moved to ue_postopen so we don't do it for every scan
//select  validate_putaway_ind into :lsOverPick from Project  with (nolock) where Project_Id = :gs_project;  //note if over receiving is allowed

if lSKUCount = 0 then //hdc 10/12/2012 Scanned something that isn't on the order

	sle_qty.text = ""
	sle_barcode.SelectText(1,len(sle_barcode.text))	
	doDisplayMessage('Putaway Scan',"UPC does not match any SKU on the order detail (UPC '" + lsUPN + "' Not found)")
	Return -1
	
elseif lSKUCount = 1 then  //hdc 10/12/2012 The cannonical case: There's a 1:1 relationship between the UPN and sku; validate that all the data is present
	
	if lsExpCont = "Y" and lsExpiry="" then  //tracked by expiry but it wasn't in the barcode
			sle_qty.text = ""	
		    sle_sku.visible = false
			st_sku.visible = false
			sle_barcode.SetFocus()				
			sle_barcode.SelectText(1,len(sle_barcode.text))							
			doDisplayMessage("Putaway Scan", "The item is expiry controlled and no expiry date is present in the barcode.")
			return -1			
	end if
	
	if (lsSerCont = "Y" or lsSerCont = "B") and lsSN="" then  //tracked by serial number but it wasn't in the barcode
			sle_qty.text = ""	
		    sle_sku.visible = false
			st_sku.visible = false
			sle_barcode.SetFocus()		
			sle_barcode.SelectText(1,len(sle_barcode.text))										
			doDisplayMessage("Putaway Scan", "The item is serial number controlled and no serial number is present in the barcode.")
			return -1			
	end if	
	
	if lsLotCont = "Y" and lsLot="" then	//tracked by lot but it wasn't in the barcode
			sle_qty.text = ""	
		    sle_sku.visible = false
			st_sku.visible = false
			sle_barcode.SetFocus()				
			sle_barcode.SelectText(1,len(sle_barcode.text))										
			doDisplayMessage("Putaway Scan", "The item is lot controlled and no lot is present in the barcode.")
			return -1			
	end if		
	
	if lQty < 1  then //hdc 10/12/2012 We've no serial number and no quantity; must be first pass; prompt user to enter quantity (serialized is always quantity of one)
		sle_qty.SetFocus()	
		st_Text_1.Text = "Enter a quantity for the scanned unit"
		return 0  //don't return -1 or the caller will change the text to "invalid scan"
	end if
	
	if lsSKU = '' then  //update description, translate to sku if necessary
		select sku, description, owner_id into :lsSKU, :lsDescript, :llOwner_Id from Item_Master  with (nolock) where Project_Id = :gs_project and Part_UPC_Code=:lsUPN &
			and SKU in (select SKU from Receive_Detail  with (nolock) where Receive_Detail.RO_No= :lsRO_NO );  
	else
		select description, owner_id into :lsDescript, :llOwner_Id from Item_Master  with (nolock) where Project_Id = :gs_project and Part_UPC_Code=:lsUPN and sku=:lsSKU &
			and SKU in (select SKU from Receive_Detail  with (nolock) where Receive_Detail.RO_No= :lsRO_NO );  		
	end if 
	
	select Owner_cd into :lsIMOwner_CD from Owner where Owner_Id = :llOwner_Id;

	dsGetLN = create datastore  //retrieve the EDI input data to see if what was scanned matches what was in the upload file
	dsGetLN.dataobject = 'd_edi_line_no'
	dsGetLN.SetTransObject(SQLCA)
	
	if lsSerCont <> 'Y' and lsSerCont <> 'B' then
		SetNull(lsSNNew)
	else
		lsSNNew = lsSN
	end if
	
	if lsLotCont <> 'Y'  then
		SetNull(lsLotNew)
	else
		lsLotNew = lsLot
	end if
	
	if lsExpCont <> 'Y'  then
		SetNull(lsExpiryNew)
	else
		lsExpiryNew = Mid(lsExpiry, 3, 2) + "/" + Mid(lsExpiry, 5, 2) + "/20" + Mid(lsExpiry, 1, 2)
	end if
	
	dsGetLN.Retrieve(lsSku, gs_project, lsExpiryNew, lsRO_NO, lsLotNew, lsSNNew)
	
	if dsGetLN.RowCount() > 0 then  //save line item number of item on the EDI record
	
		llLine_Item = dsGetLN.GetItemNumber(1,'line_item_no')
		
		// got the right item; read all its data
		select EDI_Inbound_Detail.owner_id, EDI_Inbound_Detail.Serial_No, EDI_Inbound_Detail.lot_no, EDI_Inbound_Detail.inventory_type, &
			EDI_Inbound_Detail.Country_Of_Origin, EDI_Inbound_Detail.Supp_Code, EDI_Inbound_Detail.PO_No, &
			EDI_Inbound_Detail.PO_No2, EDI_Inbound_Detail.Line_Item_No, EDI_Inbound_Detail.Container_Id, &
			EDI_Inbound_Detail.l_code, EDI_Inbound_Detail.expiration_date, EDI_Inbound_Detail.user_field1	 &
		into :lsOwner, :lsSNNew, :lsLotNew, :lsIT, :lsCOO, :lsSupplier, :lsPO_NO, :lsPO_NO2, :llLine_Item, :lsContainer, &			
		:lsLoc, :lsExpiryNew, :lsUF1 from EDI_Inbound_Detail with (nolock) &
		where EDI_Inbound_Detail.Line_Item_No = :llLine_Item and EDI_Inbound_Detail.SKU = :lsSku and EDI_Inbound_Detail.Project_Id = :gs_project and EDI_Inbound_Detail.Line_Item_No =  :llLine_Item and EDI_Inbound_Detail.EDI_Batch_Seq_No in &
			(select EDI_Batch_Seq_No from Receive_master with (nolock) where RO_No = :lsRO_NO and project_id = :gs_project); 		
			
			If lsContainer = '' or isnull(lsContainer) Then lsContainer = '-'// 02/13 - PCONKL - hopefully to avoid a blank Container_ID
			
	else  //failed validation
		
		select COUNT(*) into :llEDI_Count from EDI_Inbound_Header where Project_Id = 'PHYSIO-MAA' and EDI_Batch_Seq_No in 
			(select EDI_Batch_Seq_No from Receive_master with (nolock) where RO_No = :lsRO_NO);
			//(select EDI_Batch_Seq_No from Receive_master with (nolock) where RO_No like :lsRO_NO and project_id = 'PHYSIO-MAA');
			
		if llEDI_Count > 0 then // it was entered via EDI but none of the data matches (as opposed to being entered manually so there's no EDI record)
		
			st_Text_1.Text = 'Scan an item...'
			sle_qty.text = ""
			sle_barcode.SetFocus()				
			sle_barcode.SelectText(1,len(sle_barcode.text))									
			doDisplayMessage("Putaway Scan", "The tracked fields of the scanned item do not match anything on the order detail.")		
			return -1			
			
		end if
		
	end if

else //hdc 10/12/2012 The unlikely case that there are multiple skus associated with one UPN- only resolution is to prompt the user for which one they scanned
	
	if sle_sku.visible = false then
		sle_sku.visible = true
		st_sku.visible = true
		st_Text_1.Text = "More than one SKU on this order matches UPC " + lsUPN + ".  Enter the SKU for this item"
		sle_barcode.SelectText(1,len(sle_barcode.text))	
		sle_sku.SetFocus()
		return 0 //hdc 10/12/2012 Don't return -1 or the caller will change the above text message to "Invalid scan"
	end if
	
end if

if lQty < 1  then //hdc 10/12/2012 We've a serial number and no quantity; must be first pass; prompt user to enter quantity
	sle_qty.SetFocus()	
	st_Text_1.Text = "Enter a quantity for the scanned unit"
	return 0  //don't return -1 or the caller will change the text to "invalid scan"
else
	st_Text_1.Text = ""  //hdc 10/12/2012 If we're here we're ready to create the packing row; clear all message text that was used to get here
end if

/* find the item on the receive detail */
if llLine_Item > 0 then
	lsFind = "Upper(sku) = '" + Upper(lsSKU) +"' and Line_Item_no = " + String(llLine_Item)
else
	lsFind = "Upper(sku) = '" + Upper(lsSKU) +"'"
end if

llDetailFindRow = w_ro.idw_Detail.Find(lsFind,1,w_ro.idw_Detail.RowCount())

if llDetailFindRow = 0 then
		sle_qty.text = ""	
		sle_barcode.SetFocus()				
		sle_barcode.SelectText(1,len(sle_barcode.text))									
		doDisplayMessage("Putaway Scan", "The tracked fields of the scanned item do not match anything on the order detail.")		
		return -1			
end if

lTotQty = w_ro.idw_Detail.GetItemNumber(llDetailFindRow, 'req_qty')

/* populate date missing on the EDI record with data from the detail tab */
if lsOwner = '' or isnull(lsOwner) then
	lsOwner = w_ro.idw_Detail.GetItemString(llDetailFindRow, 'c_owner_name')	
end if

if lsCOO = '' or isnull(lsCOO) then
	lsCOO = w_ro.idw_Detail.GetItemString(llDetailFindRow, 'country_of_origin')		
end if

if lsSupplier = '' or isnull(lsSupplier) then
	lsSupplier = w_ro.idw_Detail.GetItemString(llDetailFindRow, 'supp_code')		
end if

if llLine_Item = 0 or isnull(llLine_Item) or llLine_Item = -1 then
	llLine_Item = w_ro.idw_Detail.GetItemNumber(llDetailFindRow, 'line_item_no')		
end if

if lsUF1 = '' or isnull(lsUF1) then
	lsUF1 = w_ro.idw_Detail.GetItemString(llDetailFindRow, 'user_field1')		
end if

if isOverPick<>'Y' and isOverPick<>'B' then  //check totals by sku if that is being enforced

		w_ro.idw_Putaway.SetFilter(lsFind)  // filter putaway list to show only this item or its aggregate
		w_ro.idw_Putaway.SetRedraw(false)
		w_ro.idw_Putaway.Filter()	
		lTemp = w_ro.idw_Putaway.RowCount()	
		
		if (w_ro.idw_Putaway.getItemNumber(lTemp, 'compute_2') + lQty) > lTotQty then  //if what's on the putaway for this sku + what was just scanned exceeds order detail
		
			doDisplayMessage("Putaway Scan", "Quantity for " + lsSKU + " (" + String(w_ro.idw_Putaway.getItemNumber(lTemp, 'compute_2') + lQty) + ") exceeds the amount on the order detail (" + String(lTotQty) + ").")				
			sle_qty.text = ""		
			w_ro.idw_Putaway.SetFilter("")				
			w_ro.idw_Putaway.Filter()				
			w_ro.idw_Putaway.SetRedraw(true)			
			sle_barcode.SelectText(1,len(sle_barcode.text))									
			return -1
			
		end if
		
		w_ro.idw_Putaway.SetFilter("")				
		w_ro.idw_Putaway.Filter()						
		w_ro.idw_Putaway.SetRedraw(true)			
		
end if

/* see if there's already a row to aggregate */
if lsSerCont = 'Y' or lsSerCont = 'B' then
	lsFind += " and Upper(serial_no) = '" + Upper(lsSN) + "'"			
end if
if lsLotCont = 'Y' then 
	lsFind += " and Upper(lot_no) = '" + Upper(lsLot)  + "'"			
end if
if lsExpCont = 'Y' then
	lsExpiryNew = Mid(lsExpiry, 3, 2) + "/" + Mid(lsExpiry, 5, 2) + "/20" + Mid(lsExpiry, 1, 2)	
	lsFind += " and  date(expiration_date) = Date('" + lsExpiryNew + "')"			
end if
if lsPONOCont = 'Y' then
	lsFind += " and Upper(PO_NO) = '" + Upper(lsPO_NO) + "'"
end if
if lsPONO2Cont = 'Y' then
	lsFind += " and Upper(PO_NO2) = '" + Upper(lsPO_NO2) + "'"
end if
if lsConCont = 'Y' then
	lsFind += " and Upper(Container_ID) = '" + Upper(lsContainer) + "'"
end if	
llNewRow = w_ro.idw_Putaway.Find(lsFind, 1, w_ro.idw_Putaway.RowCount())

sle_sku.text = ""  //hdc 10/12/2012 It's finally safe to hide this if it was enabled for the multiple sku->UPN case
sle_sku.visible = false
st_sku.visible = false

//26-Jun-2013: Madhu - Added code for Back order to set original order vlaues -START
string ls_ord_type,ls_supp_invoice_no1,ls_origrono,lsLot1
Date ldt_expiration_date1
ls_ord_type = w_ro.idw_Main.GetITemString(1,'ord_type') 

//IF  ls_ord_type ='B' THEN  // If ordertype is Backorder
//	select Supp_Invoice_No into :ls_supp_invoice_no1 from Receive_Master where Ro_No =:lsRo_No using sqlca;
//	select Ro_No into :ls_origrono from Receive_Master where Supp_Invoice_No=:ls_supp_invoice_no1 and Ord_type='S' and Ord_status='C' and Project_Id =:gs_project using sqlca;
//	select  lot_no,po_no,po_no2,inventory_type,expiration_date,container_id 	into :lsLot1,:lsPO_NO,:lsPO_NO2,:lsIT,:ldt_expiration_date1,:lsContainer 
//	from Receive_Putaway where Ro_No=:ls_origrono and sku=:lssku using sqlca;
//END IF

//26-Jun-2013 :Madhu - Added code for Back order to set original order values -END

If llNewRow = 0 or isnull(llNewRow) Then //hdc 10/12/2012 Create a new putaway row

	llNewRow = w_ro.idw_Putaway.InsertRow(0)
	if len(lsSN) < 1 then
		lsSN = "-"
	end if

	w_ro.idw_Putaway.SetITem(llNewRow,'lot_controlled_ind',lsLotCont)	
	w_ro.idw_Putaway.SetITem(llNewRow,'ro_no',w_ro.idw_Main.GetITemString(1,'ro_no'))
	//w_ro.idw_Putaway.SetITem(llNewRow,'line_item_no',llDetailFindRow)
	w_ro.idw_Putaway.SetITem(llNewRow,'line_item_no',llLine_Item)
	w_ro.idw_Putaway.SetITem(llNewRow,'po_no', lsPO_NO)
	w_ro.idw_Putaway.SetITem(llNewRow,'po_no2', lsPO_NO2)	
	w_ro.idw_Putaway.SetITem(llNewRow,'container_id', lsContainer)	
	w_ro.idw_Putaway.SetITem(llNewRow,'sku',lsSKU)
	w_ro.idw_Putaway.SetITem(llNewRow,'country_of_Origin',lsCoo)
	w_ro.idw_Putaway.SetITem(llNewRow,'inventory_type', lsIT)
	
	if isnull(lsLoc) then
		w_ro.idw_Putaway.SetITem(llNewRow,'l_code',' ')		
	else
		w_ro.idw_Putaway.SetITem(llNewRow,'l_code',lsLoc)
	end if
	
	w_ro.idw_Putaway.SetITem(llNewRow,'supp_code',lsSupplier)	
	w_ro.idw_Putaway.SetITem(llNewRow,'user_field1',lsUF1)		
	
	if lsLot = "" or isnull(lsLot) then
		if lsLotNew <> "" and isnull(lsLotNew)=false then
			w_ro.idw_Putaway.SetITem(llNewRow,'lot_no',lsLotNew)					
		else
			w_ro.idw_Putaway.SetITem(llNewRow,'lot_no',"-")		
		end if
	else 
			w_ro.idw_Putaway.SetITem(llNewRow,'lot_no',lsLot)
	end if
	
	w_ro.idw_Putaway.SetITem(llNewRow,'quantity',lQty)
	
	if len(lsSN) > 1 then
		w_ro.idw_Putaway.SetITem(llNewRow,'serial_no', lsSN)
	elseif len(lsSNNew) > 1 then
		w_ro.idw_Putaway.SetITem(llNewRow,'serial_no', lsSNNew)
	else
		w_ro.idw_Putaway.SetITem(llNewRow,'serial_no', lsSN)
	end if
	
	if lsSN <> "-" and lsSerCont <>"B" and lsSerCont<>"Y" then
		w_ro.idw_Putaway.Modify("serial_no.width=0")
	end if
	
	w_ro.idw_Putaway.SetITem(llNewRow,'description', lsDescript)
	w_ro.idw_Putaway.SetITem(llNewRow,'serialized_ind', lsSerCont)
	w_ro.idw_Putaway.SetITem(llNewRow,'expiration_controlled_ind', lsExpCont)
	w_ro.idw_Putaway.SetITem(llNewRow,'lot_controlled_ind',lsLotCont)
	w_ro.idw_Putaway.SetITem(llNewRow,'po_controlled_Ind', lsPONOCont)
    w_ro.idw_Putaway.SetITem(llNewRow,'po_no2_controlled_Ind', lsPONO2Cont)
	 w_ro.idw_Putaway.SetITem(llNewRow,'container_tracking_Ind', lsConCont)
	 
	if lsOwner = "" or isnull(lsOwner) then
		w_ro.idw_Putaway.SetITem(llNewRow,'owner_cd',lsIMOwner_CD)	
		w_ro.idw_Putaway.SetITem(llNewRow,'c_owner_name',lsIMOwner_CD)		
	else 
		w_ro.idw_Putaway.SetITem(llNewRow,'owner_cd',lsOwner)	
		w_ro.idw_Putaway.SetITem(llNewRow,'c_owner_name',lsOwner)				
	end if
	
	w_ro.idw_Putaway.SetITem(llNewRow,'owner_id',llOwner_Id)				
	
	//assumes integrated barcode scan items are all parent components
	w_ro.idw_Putaway.SetITem(llNewRow,'sku_parent',lsSKU)	
	w_ro.idw_Putaway.SetITem(llNewRow,'component_ind',"N")		

//	IF ls_ord_type <> 'B' THEN //26-Jun-2013 :Madhu - added code to set the Expiration date to back order
	
		If lsExpiry > '' Then   //hdc 10/12/2012 Set the expiry controlled flag appropriately based on whether or not an expiry date was entered
			lsExpiry =  Mid(lsExpiry, 3, 2) + "/" + Mid(lsExpiry, 5, 2) + "/20" + Mid(lsExpiry, 1, 2)
			w_ro.idw_Putaway.SetITem(llNewRow,'expiration_date',Date(lsExpiry))
		Elseif len(lsExpiryNew) > 0 then
			w_ro.idw_Putaway.SetITem(llNewRow,'expiration_date',lsExpiryNew)
		end if
		
//	else  //26-Jun-2013 :Madhu - added code to set the Expiration date to back order -START
		
	//	w_ro.idw_Putaway.SetITem(llNewRow,'expiration_date',Date(ldt_expiration_date1))
		
	//	w_ro.idw_Putaway.SetITem(llNewRow,'lot_no',lsLot1)
	
//	END IF //26-Jun-2013 :Madhu - added code to set the Expiration date to back order -END	

	 //hdc 10/12/2012 All finished OK; clean up and get ready for the next scan
	st_Text_1.Text = "Scan successful. Putaway Record ADDED. Scan next barcode or 'OK' to finish..."
	sle_barcode.text = ""
	sle_qty.text = ""
	sle_barcode.SetFocus()	
	
Else  //hdc 10/12/2012 This is not a new row so simply update the quantity in the existing row	
	
	w_ro.idw_Putaway.SetItem(llNewRow, 'quantity',w_ro.idw_Putaway.getItemNumber(llNewRow, 'quantity') + lQty)
	 //hdc 10/12/2012 All finished OK; clean up and get ready for the next scan	
	st_Text_1.Text = "Scan successful. Putaway Record UPDATED. Scan next barcode or 'OK' to finish..."
	sle_barcode.text = ""
	sle_qty.text = ""	
	sle_barcode.SetFocus()
	
End If

w_ro.idw_Putaway.TriggerEvent('ue_hide_Unused')  //hdc 10/12/2012  Clean up the display
w_ro.ib_changed = True   //hdc 10/12/2012  Mark the window dirty

Return 0 
end function

on w_putaway_scan.create
int iCurrent
call super::create
this.sle_barcode=create sle_barcode
this.st_text_1=create st_text_1
this.sle_qty=create sle_qty
this.sle_sku=create sle_sku
this.st_1=create st_1
this.st_2=create st_2
this.st_sku=create st_sku
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_barcode
this.Control[iCurrent+2]=this.st_text_1
this.Control[iCurrent+3]=this.sle_qty
this.Control[iCurrent+4]=this.sle_sku
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_sku
end on

on w_putaway_scan.destroy
call super::destroy
destroy(this.sle_barcode)
destroy(this.st_text_1)
destroy(this.sle_qty)
destroy(this.sle_sku)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_sku)
end on

event ue_postopen;call super::ue_postopen;
select  validate_putaway_ind into :isOverPick from Project  with (nolock) where Project_Id = :gs_project;  //note if over receiving is allowed

Sle_barcode.SetFocus()

st_text_1.Text = "Scan a barcode..."

end event

event open;call super::open;if Upper (gs_project) = 'PHYSIO-MAA' or Upper(gs_project)='PHYSIO-XD' then /* hdc 10-05-2012 show the quantity field for physio */
	sle_qty.visible = true
	st_2.visible = true
else
	st_2.visible = false
	sle_qty.visible = false
end if
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_putaway_scan
boolean visible = false
integer x = 1614
integer y = 660
integer width = 165
end type

type cb_ok from w_response_ancestor`cb_ok within w_putaway_scan
integer x = 1019
integer y = 708
integer width = 311
string text = "OK/Done"
boolean default = false
end type

type sle_barcode from singlelineedit within w_putaway_scan
integer x = 27
integer y = 128
integer width = 1696
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;
Integer	liRC
String sProject_ID

This.SetFocus()
sProject_ID = Upper(w_ro.idw_Main.GetITemString(1,'Project_id'))

st_text_1.text = 'Processing Barcode...'

Choose Case sProject_ID
		
	Case 'LMC'
		liRC = uf_process_LMC_Scan()

	Case 'PHYSIO-MAA' , 'PHYSIO-XD' //hdc 10/05/2012
		liRC = uf_process_physio_Scan()

End Choose


If liRC < 0 Then  //error return
	st_text_1.text = 'Invalid Barcode, Please scan again...'
	if len(this.text) > 0 then
		This.SelectText(1,len(This.Text))
	end if
Else //normal return
	if sProject_ID='PHYSIO-MAA' or sProject_ID='PHYSIO-XD' then //hdc 10/05/2012 Physio can return while a scan is in progress and we don't want to kill the message text
	else
	     st_text_1.text = ""
		 this.text = ""
	end if 
End If
end event

type st_text_1 from statictext within w_putaway_scan
integer x = 50
integer y = 400
integer width = 2167
integer height = 272
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type sle_qty from singlelineedit within w_putaway_scan
integer x = 1755
integer y = 124
integer width = 521
integer height = 116
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

event modified;//hdc 10/12/2012  If this is visible and this event was triggered it means we're physio, the user has entered a quantity and we need to return to the scan processing
uf_process_physio_scan()  
end event

type sle_sku from singlelineedit within w_putaway_scan
boolean visible = false
integer x = 256
integer y = 256
integer width = 1463
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;
Integer	liRC
String sProject_ID

This.SetFocus()
sProject_ID = Upper(w_ro.idw_Main.GetITemString(1,'Project_id'))

st_text_1.text = 'Processing Barcode...'

Choose Case sProject_ID
		
	Case 'LMC'
		liRC = uf_process_LMC_Scan()

	Case 'PHYSIO-MAA' , 'PHYSIO-XD'
		liRC = uf_process_physio_Scan()

End Choose


If liRC < 0 Then
	st_text_1.text = 'Invalid Barcode, Please scan again...'
	if len(this.text) > 0 then
		This.SelectText(1,len(This.Text))
	end if
Else
	if sProject_ID='PHYSIO-MAA' or sProject_ID='PHYSIO-XD' then 
	else
	     st_text_1.text = ""
	end if 
End If
end event

type st_1 from statictext within w_putaway_scan
integer x = 32
integer y = 48
integer width = 517
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Barcode:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_putaway_scan
integer x = 1765
integer y = 40
integer width = 517
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Quantity:"
boolean focusrectangle = false
end type

type st_sku from statictext within w_putaway_scan
boolean visible = false
integer x = 32
integer y = 280
integer width = 215
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "SKU:"
boolean focusrectangle = false
end type

