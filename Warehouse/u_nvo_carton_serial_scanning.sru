HA$PBExportHeader$u_nvo_carton_serial_scanning.sru
$PBExportComments$Carton Level serial scanning functions
forward
global type u_nvo_carton_serial_scanning from nonvisualobject
end type
end forward

global type u_nvo_carton_serial_scanning from nonvisualobject
end type
global u_nvo_carton_serial_scanning u_nvo_carton_serial_scanning

type variables
String		isOrigSql, isPrevSKU, isOrigROSerialSQL
Datastore	idsSerial, idsRoSerial, idw_carton_serial

window		iwParentWindow

// pvh 09/26/05
constant string ThreeComSupplierCode = '3COM'
constant integer childsku = 1
constant integer parentsku = 0

string 		isSupplierCode
string		isChildSku

boolean 	ibParticipant
boolean 	ibUseCarton
boolean 	ibparentsku


datastore idsPack 
datastore idspick
datastore idsparentskbychild

long		ilPackingRows
long		ilCurrentPackRow
long 		ilDesgFind
long 		ilSerialRowNo

decimal 	idSumPackingQty
decimal 	idPackingCartonQty

integer	ipackingskuerror

String		isFootPrintBlankInd = 'NA'







end variables

forward prototypes
public function integer uf_process_ro_carton_scan (ref string asmessage, string asbarcode, ref datawindow adwmain, ref datawindow adwputaway, ref datawindow adwserial, string ascarton, string asorigsql)
public function integer uf_linksys_ro_scan (ref string asmessage, string asbarcode, ref datawindow adwmain, ref datawindow adwputaway, ref datawindow adwserial, string ascarton, string asorigsql)
public subroutine setparentwindow (ref window awin)
public function window getparentwindow ()
public subroutine setparticipant (boolean _participant)
public function boolean getparticipant ()
public subroutine setparticipatingsupplier (string assuppliercode)
public subroutine setsuppliercode (string _suppliercode)
public function string getsuppliercode ()
public function string get3comsuppliercode ()
public function integer uf_3com_ro_scan (ref string asmessage, string asbarcode, ref datawindow adwmain, ref datawindow adwputaway, ref datawindow adwserial, string ascarton, string asorigsql)
public function integer uf_process_do_carton_scan (string ascurrentsku, ref string asmessage, string asbarcode, string aspackcarton, ref datawindow adwmain, ref datawindow adwdetail, ref datawindow adwpick, ref datawindow adwpack, ref datawindow adwserial, long alcurrentrow)
public function integer cartonalreadyused ()
public function integer checkforfullcarton (decimal _qty)
public function integer checkinterfacerows (decimal _qty, ref datawindow adwserial)
public subroutine setpackingrows (long _value)
public function long getpackingrows ()
public subroutine setdesgfind (long _value)
public function long getdesgfind ()
public function integer checkpackingcoo (ref datawindow adw_pack, long _packrow)
public subroutine setsumpackingqty (decimal _value)
public function decimal getsumpackingqty ()
public function integer doprocesspackingrows (ref datawindow adw_serial, string _barcode, decimal _serialcartonqty, ref string asmessage, string _sku, long _packrow)
public subroutine setpackingcartonqty (decimal _value)
public function decimal getpackingcartonqty ()
protected function integer uf_linksys_do_scan (string ascurrentsku, ref string asmessage, string asbarcode, ref datawindow adwmain, ref datawindow adwdetail, ref datawindow adwserial, long alcurrentrow)
public function integer dovalidatecartonid (string ascartonid)
public function integer uf_3com_do_scan (string ascurrentsku, ref string asmessage, string asbarcode, string aspackcarton, ref datawindow adwmain, ref datawindow adwdetail, ref datawindow adwpack, ref datawindow adwserial, ref datawindow adwpick, long alcurrentrow)
public function string getownerid (string _sku, string _supplier, ref datawindow adwpick)
public subroutine setcurrentpackrow (long _row)
public function long getcurrentpackrow ()
public function integer dovalidateprocesstype (string _type, string _sku)
public function string getpackingsku (string assku, ref datawindow idw_pack)
public subroutine setpackingskuerror (integer _state)
public function integer getpackingskuerror ()
public subroutine setparentskuflag (boolean _flag)
public function boolean getparentskuflag ()
public subroutine setchildsku (string _sku)
public function string getchildsku ()
public function integer setpackingrows (ref datawindow adwpack, string aspackcarton, string ascurrentsku, ref datawindow adwpick, ref datawindow adwserial)
public subroutine dodisplaymessage (string _title, string _message)
public function boolean dovalidateenoughrowsforsupplier (string sku, string supplier, ref datawindow adwserial)
public function integer dovalidatecartonserialforsku (string _sku)
public function string getpackingsupplier (long _index, ref datawindow adwpick, ref datawindow adwserial)
public function integer getsuppliercount ()
public function boolean isvalidserialnumber (string asserialno)
public function boolean doserialprefixcheck (string _serialnbr, string _sku)
public function boolean checkserialcartonvendor ()
public function boolean uf_validate_serial_prefix (string assku, string asserialno)
public function integer uf_powerwave_do_scan (string ascurrentsku, ref string asmessage, string asbarcode)
public function integer uf_do_scan_comcast ()
public function integer uf_do_scan_lmc (string asbarcode)
public function integer uf_do_scan_comcast (string assku, string asscan, long alrow)
public function integer uf_do_scan_puma (string asbarcode)
public function integer uf_do_scan_physio (string asbarcode)
public function integer uf_do_scan_pandora (string assku, string asscan, long alrow, string astype)
public function integer uf_do_scan_anki (string asbarcode)
public function integer uf_do_scan_pandora_ip (string asscan)
public function integer uf_do_scan_pandora (string assupplier)
public function integer uf_do_scan_pandora_cntr (string asscan)
public function integer getpalletqty (string asdono, string aspallet)
public function integer getcontainerqty (string asdono, string aspallet, string ascontainer)
public function integer uf_pandora_load_sn_for_picked_containers ()
end prototypes

public function integer uf_process_ro_carton_scan (ref string asmessage, string asbarcode, ref datawindow adwmain, ref datawindow adwputaway, ref datawindow adwserial, string ascarton, string asorigsql);
String	lsProject
Integer	liRC


lsProject = Upper(adwMain.GetITemString(1,'project_id'))

Choose Case lsProject
		
	Case 'LINKSYS'
		
		liRC = uf_linksys_ro_Scan(asMessage, asbarCode, adwMain, adwPutaway, adwSerial, asCarton, asOrigSQL)
		
	Case '3COM_NASH'

		
		//liRC = uf_3com_ro_Scan( asMessage, asbarCode, adwMain, adwPutaway,  adwSerial, asCarton, asOrigSQL)
		
	Case Else
		
		Return 0
		
End Choose

Return liRC
end function

public function integer uf_linksys_ro_scan (ref string asmessage, string asbarcode, ref datawindow adwmain, ref datawindow adwputaway, ref datawindow adwserial, string ascarton, string asorigsql);//Process Linksys Serial/MAC ID scans - DELIVERY ORDER

String	lsNewSql, lsSKU, lsSerial, lsFind, lsProject, lsSupplier, lsMACID, lsScanType, lsModify, lsRC
Long		llPrevCount, lLRowCount, llRowPos, llFindRow,  llNewRow



//If Scan <> 12 digits, then not a valid scan
If Len(asBarCode) <> 12 Then
	asMessage = 'Invalid Barcode scanned (must be 12 digits)!'
	Return -1
End If
	
// There is no way to completely determine whether the user scanned a carton, Serial or Mac. We will need to potentially do
// lookups on all 3 to determine.  For now Mac ID's begin with '00' but serial and cartons have no pattern

//Retreiving scans into datastore and copying to datawindow on w_Ro (reference arg) if present.
// RetreiveStart will clear existing rows if you modify and manually insert rows (for scans not found)

If Not isvalid(idsRoSerial) Then
	idsRoSerial = Create Datastore
	idsRoSerial.Dataobject = 'd_ro_carton_serial'
	idsRoSerial.SettransObject(SQLCA)
	isOrigROSerialSQL = idsRoSerial.getSQLSElect()
End If

//see if we have already scanned this carton, MAC or Serial
If adwSerial.RowCount() > 0 Then
	If adwSerial.Find("Upper(carton_id) = '" + upper(asbarcode) + "'",1,adwSerial.RowCount()) > 0 Then
		Messagebox('', 'This carton has already been scanned!',StopSign!)
		Return -1
	ElseIf adwSerial.Find("Upper(MAC_ID) = '" + upper(asbarcode) + "'",1,adwSerial.RowCount()) > 0 Then
		Messagebox('', 'This MAC ID has already been scanned!',StopSign!)
		Return -1
	ElseIf adwSerial.Find("Upper(Serial_NO) = '" + upper(asbarcode) + "'",1,adwSerial.RowCount()) > 0 Then
		messagebox('', 'This Serial Number has already been scanned!',StopSign!)
		Return -1
	End If
End If
		
If Left(asBarcode,2) = '00' Then /*Probably a Mac ID, try that first*/
	
	//Retrieve the Serial number and populate serial tab based on MAC ID
	lsNewSql = isOrigROSerialSQL + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
	lsNewSQL += " and Mac_ID = '" + asBarCode + "'"
	lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
	lsRC = idsRoSerial.Modify(lsModify)
	llrowCount = idsRoSerial.retrieve()
	
	If llRowCount > 0 then /* It was a MAC ID*/
	
		lsScanType = 'M' 
		
	Else /* Not a MAC, Try Serial Next */
		
		lsNewSql = isOrigROSerialSQL + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
		lsNewSQL += " and Serial_no = '" + asBarCode + "'"
		lsModify = 'DataWindow.Table.Select="' + lsNewSQL+ '"'
		lsRC = idsRoSerial.Modify(lsModify)
		llrowCount = idsRoSerial.retrieve()
		
		If llRowCount > 0 Then /*it was a Serial */
			lsScanType = 'S' 
		Else /*Not a MAC or Serial, try a Carton */
			lsNewSql = isOrigROSerialSQL + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
			lsNewSQL += " and Carton_ID = '" + asBarCode + "'"
			lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
			lsRC = idsRoSerial.Modify(lsModify)
			llrowCount = idsRoSerial.retrieve()
			
			If llRowCount > 0 Then /*It was a carton */
				lsScanType = 'C'
			Else /* Not a carton, Serial or MAC */
				lsScanType = 'X'
			End If
			
		End If
		
	End If
	
Else /* Doesn't appear to be a MAC (doesn't begin with 00), try a carton first, then serial and MAC last */
	
	lsNewSql = isOrigROSerialSQL + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
	lsNewSQL += " and carton_id = '" + asBarCode + "'"
	lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
	lsRC = idsRoSerial.Modify(lsModify)
	llrowCount = idsRoSerial.retrieve()
			
	If llRowCount > 0 Then /*It was a carton */
		lsScanType = 'C'
	Else /* Not a carton,Try Serial */
	
		lsNewSql = isOrigROSerialSQL + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
		lsNewSQL += " and Serial_no = '" + asBarCode + "'"
		lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
		lsRC = idsRoSerial.Modify(lsModify)
		llrowCount = idsRoSerial.retrieve()
		
		If llRowCount > 0 Then /*it was a Serial */
			lsScanType = 'S' 
		Else /*Not a serial, Try a MAC*/
			lsNewSql = isOrigROSerialSQL + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
			lsNewSQL += " and MAC_ID = '" + asBarCode + "'"
			lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
			lsRC = idsRoSerial.Modify(lsModify)
			llrowCount = idsRoSerial.retrieve()
		
			If llRowCount > 0 Then /*it was a MAC */
				lsScanType = 'M' 
			Else /*Not on File*/
				lsScanType = 'X'
			End If
		End If
		
	End If
	
End If

If llRowCount = 0 Then /*scan not found - Manually Insert a row*/

	llNewrow = adwSerial.InsertRow(0)
	adwSerial.SetITem(llNewRow, 'Project_ID', adwMain.GetITemString(1,'Project_ID'))
	adwSerial.SetITem(llNewRow, 'ro_no', adwMain.GetITemString(1,'ro_no'))
	adwSerial.SetITem(llNewRow, 'status_cd','R') /* R = Received */
	adwSerial.SetITem(llNewRow, 'Pallet_id','-')
	adwSerial.SetITem(llNewRow, 'c_Manual_Ind','Y') /* will allow manually created row to be deleted (retrieved rows are only updated to clear ro_no)*/
	
	//If a carton was set on a previous row, default on new and default S
	If asCarton > '' Then
		adwSerial.SetITem(llNewRow, 'carton_id',asCarton)
	Else
		adwSerial.SetITem(llNewRow, 'Carton_id','-')
	End If

	//If only 1 SKU on Putaway, default SKU/Supplier on new row
	If adwPutaway.RowCount() = 1 Then
		adwSerial.SetITem(llNewRow, 'SKU', adwPutaway.getITemstring(1,'SKU'))
		adwSerial.SetITem(llNewRow, 'Supp_Code', adwPutaway.getITemstring(1,'Supp_Code'))
	ElseIf adwPutaway.RowCount() > 0 Then
		lsSKU = adwPutaway.GetITemString(1,'SKU')
		If adwPutaway.Find("SKU <> '" + lsSKU + "'",2,adwPutaway.rowCount()) = 0 Then /* only 1 SKU*/
			adwSerial.SetITem(llNewRow, 'SKU', adwPutaway.getITemstring(1,'SKU'))
			adwSerial.SetITem(llNewRow, 'Supp_Code', adwPutaway.getITemstring(1,'Supp_Code'))
		End If
	End If
	
	//Default to either Serial or Mac
	If Left(asBarCode,2) = '00' Then /* probably a MAC */
		adwSerial.SetITem(llNewRow, 'MAC_ID',asbarcode)
		asMessage = "Barcode Not found. This scan appears to be a MAC ID. Please verify and enter SKU, Serial #"
	Else
		adwSerial.SetITem(llNewRow, 'Serial_No',asbarcode)
		asMessage = "Barcode Not found. This scan appears to be a Serial #. Please verify and enter SKU, MAC ID"
	End If
	
	adwSerial.SetFocus()
	adwSerial.ScrolltoRow(llNewRow)
	
	Return 1 /* will put into semi manual mode*/
	
Else /*Scan found - verify exists on Putaway*/
	
	lsSKU = idsRoSerial.GetITemString(idsRoSerial.RowCount(),'SKU')
	If adwPutaway.Find("Sku = '" + lsSKU + "'",1,adwPutaway.RowCount()) = 0 Then
		Messagebox('', 'SKU not present on Putaway List!',StopSign!)
		Return -1
	End If
	
	//Make sure this scan has actually been previously shipped (N=New, R=Returned, P=Pending Shipment, X=Shipped)
	If idsRoSerial.Find("status_cd = 'N' or Status_cd = 'R'",1,idsRoSerial.RowCount()) > 0 Then /*Either not yet shipped or already returned*/
		Choose Case lsScanType
			Case 'C'
				Messagebox('','One or more of the items in this carton have not been shipped!',StopSign!)
			Case 'M'
				Messagebox('','This MAC ID has not been shipped!',StopSign!)
			Case 'S'
				Messagebox('','This Serial Number has not been shipped!',StopSign!)
		End Choose
		Return -1
	End If
	
	//Copy from Datastore to DW on W_RO, reset status from new modifed (from copy row) to not modifed)
	llrowCount = adwSerial.rowCount()
	
	idsRoSerial.RowsCopy(1,idsRoSerial.RowCount(),Primary!,adwSerial,999999999,Primary!)
	
	For llRowPos = llRowCount to adwSerial.RowCount()
		adwSerial.SetItemStatus(llRowPos,0,Primary!,dataModified!) /*cant go from newmodified directly to not modified*/
		adwSerial.SetItemStatus(llRowPos,0,Primary!,notModified!)
	Next
	
	Choose Case lsScanType
			
		Case 'C'
			asMessage = 'CARTON successfully scanned'
		Case 'M'
			asMessage = 'MAC ID successfully scanned'
		Case 'S'
			asMessage = 'SERIAL NUMBER successfully scanned'
			
	End Choose
	
End If
		

Return 0
end function

public subroutine setparentwindow (ref window awin);iwParentWindow = awin
end subroutine

public function window getparentwindow ();return iwParentWindow

end function

public subroutine setparticipant (boolean _participant);// setParticipant( boolean _participant )

ibparticipant = _participant
end subroutine

public function boolean getparticipant ();// boolean = getparticipant()
return ibparticipant
end function

public subroutine setparticipatingsupplier (string assuppliercode);// setParticipatingSupplier( string asSupplier )

// if it's 3com...they are always a participant
if asSupplierCode = get3comSupplierCode() then 
	setParticipant( true )
	return
end if

setParticipant(  f_isparticipatingsupplier( gs_project, asSupplierCode  ) )

return

end subroutine

public subroutine setsuppliercode (string _suppliercode);// setSuppliercode( string _suppliercode )
isSupplierCode = _SupplierCode
end subroutine

public function string getsuppliercode ();// string = getSuppliercode()
return isSupplierCode

end function

public function string get3comsuppliercode ();// string = get3comsupplierCode()
return ThreeComSupplierCode

end function

public function integer uf_3com_ro_scan (ref string asmessage, string asbarcode, ref datawindow adwmain, ref datawindow adwputaway, ref datawindow adwserial, string ascarton, string asorigsql);////Process 3com return order serial data
//// undo! This isn't necessary anymore
//
//String	lsNewSql, lsSKU, lsSerial, lsFind, lsProject, lsSupplier, lsMACID, lsScanType, lsModify, lsRC
//Long		llPrevCount, lLRowCount, llRowPos, llFindRow,  llNewRow
//	
//datetime ldtToday
//ldtToday = datetime( today(), now() )
//
//// There is no way to completely determine whether the user scanned a carton, Serial or Mac. We will need to potentially do
//// lookups on all 3 to determine.  For now Mac ID's begin with '00' but serial and cartons have no pattern
//
////Retreiving scans into datastore and copying to datawindow on w_Ro (reference arg) if present.
//// RetreiveStart will clear existing rows if you modify and manually insert rows (for scans not found)
//
//If Not isvalid(idsRoSerial) Then
//	idsRoSerial = Create Datastore
//	idsRoSerial.Dataobject = 'd_ro_carton_serial'
//	idsRoSerial.SettransObject(SQLCA)
//	isOrigROSerialSQL = idsRoSerial.getSQLSElect()
//End If
//
////see if we have already scanned this carton, MAC or Serial
//If adwSerial.RowCount() > 0 Then
//	If adwSerial.Find("Upper(carton_id) = '" + upper(asbarcode) + "'",1,adwSerial.RowCount()) > 0 Then
//		Messagebox('', 'This carton has already been scanned!',StopSign!)
//		Return -1
//	ElseIf adwSerial.Find("Upper(Serial_NO) = '" + upper(asbarcode) + "'",1,adwSerial.RowCount()) > 0 Then
//		messagebox('', 'This Serial Number has already been scanned!',StopSign!)
//		Return -1
//	End If
//End If
//	
//lsNewSql = isOrigROSerialSQL + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
//lsNewSQL += " and carton_id = '" + asBarCode + "'"
//lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
//lsRC = idsRoSerial.Modify(lsModify)
//llrowCount = idsRoSerial.retrieve()
//	
//If llRowCount > 0 Then /*It was a carton */
//	lsScanType = 'C'
//Else /* Not a carton,Try Serial */
//	lsNewSql = isOrigROSerialSQL + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
//	lsNewSQL += " and Serial_no = '" + asBarCode + "'"
//	lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
//	lsRC = idsRoSerial.Modify(lsModify)
//	llrowCount = idsRoSerial.retrieve()
//
//	If llRowCount > 0 Then /*it was a Serial */
//		lsScanType = 'S' 
//	Else /*Not on File*/
//		lsScanType = 'X'
//	End If
//End If
//
//If llRowCount = 0 Then /*scan not found - Manually Insert a row*/
//
//	llNewrow = adwSerial.InsertRow(0)
//	adwSerial.SetITem(llNewRow, 'Project_ID', adwMain.GetITemString(1,'Project_ID'))
//	adwSerial.SetITem(llNewRow, 'ro_no', adwMain.GetITemString(1,'ro_no'))
//	adwSerial.SetITem(llNewRow, 'status_cd','R') /* R = Received */
//	adwSerial.SetITem(llNewRow, 'Pallet_id','-')
//	adwSerial.SetITem(llNewRow, 'c_Manual_Ind','Y') /* will allow manually created row to be deleted (retrieved rows are only updated to clear ro_no)*/
//	
//	//If a carton was set on a previous row, default on new and default S
//	If asCarton > '' Then
//		adwSerial.SetITem(llNewRow, 'carton_id',asCarton)
//	Else
//		adwSerial.SetITem(llNewRow, 'Carton_id','-')
//	End If
//
//	//If only 1 SKU on Putaway, default SKU/Supplier on new row
//	If adwPutaway.RowCount() = 1 Then
//		adwSerial.SetITem(llNewRow, 'SKU', adwPutaway.getITemstring(1,'SKU'))
//		adwSerial.SetITem(llNewRow, 'Supp_Code', get3comsupplierCode() )
//	ElseIf adwPutaway.RowCount() > 0 Then
//		lsSKU = adwPutaway.GetITemString(1,'SKU')
//		If adwPutaway.Find("SKU <> '" + lsSKU + "'",2,adwPutaway.rowCount()) = 0 Then /* only 1 SKU*/
//			adwSerial.SetITem(llNewRow, 'SKU', adwPutaway.getITemstring(1,'SKU'))
//			adwSerial.SetITem(llNewRow, 'Supp_Code', get3comsupplierCode() )
//		End If
//	End If
//	
//	//Default to either Serial or Mac
//	If Left(asBarCode,2) = '00' Then /* probably a MAC */
////		adwSerial.SetITem(llNewRow, 'MAC_ID',asbarcode)
////		asMessage = "Barcode Not found. This scan appears to be a MAC ID. Please verify and enter SKU, Serial #"
//	Else
//		adwSerial.SetITem(llNewRow, 'Serial_No',asbarcode)
//		asMessage = "Barcode Not found. This scan appears to be a Serial #. Please verify and enter SKU."
//	End If
//	
//	adwSerial.SetFocus()
//	adwSerial.ScrolltoRow(llNewRow)
//	
//	Return 1 /* will put into semi manual mode*/
//	
//Else /*Scan found - verify exists on Putaway*/
//	
//	lsSKU = idsRoSerial.GetITemString(idsRoSerial.RowCount(),'SKU')
//	If adwPutaway.Find("Sku = '" + lsSKU + "'",1,adwPutaway.RowCount()) = 0 Then
//		Messagebox('', 'SKU not present on Putaway List!',StopSign!)
//		Return -1
//	End If
//	
//	//Make sure this scan has actually been previously shipped (N=New, R=Returned, P=Pending Shipment, X=Shipped)
//	If idsRoSerial.Find("status_cd = 'N' or Status_cd = 'R'",1,idsRoSerial.RowCount()) > 0 Then /*Either not yet shipped or already returned*/
//		Choose Case lsScanType
//			Case 'C'
//				Messagebox('','One or more of the items in this carton have not been shipped!',StopSign!)
//			Case 'S'
//				Messagebox('','This Serial Number has not been shipped!',StopSign!)
//		End Choose
//		Return -1
//	End If
//	
//	//Copy from Datastore to DW on W_RO, reset status from new modifed (from copy row) to not modifed)
//	llrowCount = adwSerial.rowCount()
//	
//	idsRoSerial.RowsCopy(1,idsRoSerial.RowCount(),Primary!,adwSerial,999999999,Primary!)
//	
//	// set the last update date and supp_code
//	int index
//	int max
//	max = adwSerial.rowcount()
//	for index = 1 to max
//		adwSerial.object.supp_code.primary[ index] = get3ComSupplierCode()
//		adwSerial.object.last_update.primary[ index ] = ldtToday
//	next
////	
////	For llRowPos = llRowCount to adwSerial.RowCount()
////		adwSerial.SetItemStatus(llRowPos,0,Primary!,dataModified!) /*cant go from newmodified directly to not modified*/
////		adwSerial.SetItemStatus(llRowPos,0,Primary!,notModified!)
////	Next
////	
//	Choose Case lsScanType
//			
//		Case 'C'
//			asMessage = 'CARTON successfully scanned'
//		Case 'S'
//			asMessage = 'SERIAL NUMBER successfully scanned'
//			
//	End Choose
//	
//End If
//		
//
Return 0
end function

public function integer uf_process_do_carton_scan (string ascurrentsku, ref string asmessage, string asbarcode, string aspackcarton, ref datawindow adwmain, ref datawindow adwdetail, ref datawindow adwpick, ref datawindow adwpack, ref datawindow adwserial, long alcurrentrow);
String	lsProject
Integer	liRC

If Not isValid(idsSerial) Then
	idsSerial = Create DAtastore
	idsSerial.DataObject = 'd_do_serial_smartscan'
	idsSerial.SetTransObject(SQLCA)
	isOrigSql = idsSerial.GetSQLSelect()
End If


lsProject = Upper(adwMain.GetITemString(1,'project_id'))

Choose Case lsProject
		
			
	Case 'POWERWAVE'
		
		liRC = uf_powerwave_do_Scan(asCurrentSKU, asMessage, asbarCode)
				
	Case Else
		
		Return 0
		
End Choose

Return liRC
end function

public function integer cartonalreadyused ();// integer = cartonalreadyused()

string lsFind
long llFindRow
string lsDONO
datetime ldtCompleteDate
string lsDN
string lsOrder
string lsMsg

//Make sure this pallet/carton hasn't already been shipped (status = 'X') or pending shipment (P)
lsFind = "status_cd = 'X' or status_cd = 'P'"
llFindRow = idsSerial.Find(lsFind,1,idsSerial.RowCount())
If llFindRow > 0 Then /* one or more units in carton already shipped */
	lsDONO = idsSerial.GetITemString(llfindRow,'do_no')
		Select Complete_Date, User_Field6, invoice_no
		Into	:ldtCompleteDate, :lsDN, :lsOrder
		From Delivery_MAster
		Where do_no = :lsDoNo;

	If isNull(lsDN) then lsDN = ''
	if isNull( ldtCompleteDate) then
		lsMsg = "One or more units of this carton appear in Order: " + lsOrder 
	else
		lsMsg = "One or more units of this carton appear in Order: " + lsOrder + ",and were shipped on~r~n" + String(ldtCompleteDate,'mm/dd/yyyy')
	end if
	If NOT isNull(lsDN) then	lsMsg += "~r~non Delivery Note " + lsDN 
	If MessageBox('Scanning',lsMsg + "~r~rDo you want to continue?",Question!,yesNo!,2) = 2 Then	Return -1
End If /* one or more units in carton already shipped */

return 0

end function

public function integer checkforfullcarton (decimal _qty);// integer = checkForFullCarton( decimal _qty )
long llrowCount
string lsFilter

// If a pallet/carton is being scanned, it must be a full pallet/carton and the full carton qty must be <= the qty being shipped
// Carton qty on the serial records will be set and confirmed when the sweeper imports the file

//Filter out shipped units before comparing current count to carton count (we retrieved X above so we could notify if already shipped)
lsFilter = "status_cd <> 'X'  and supp_code = '" + getSupplierCode() + "'"
idsSerial.SetFilter(lsFilter)
idsSerial.filter()
	
llrowCount = idsSerial.rowCount() /*Count of non shipped serial records for this Carton*/

if _qty = 0 then 
		doDisplayMessage('Full Carton Check','Carton Quantity: ' + 'The Smart Code Carton contains '+ string( integer( llrowCount )) + ' serial numbers, ' + &
		'but no supplier was found to have enough rows available to use the scanned carton. Please scan individual serial numbers for this SKU.' )
	Return -1
end if

//Check for partial qty remaining

If llrowCount > _qty Then
	doDisplayMessage('Full Carton Check','Carton Quantity: ' + 'The Smart Code Carton contains '+ string( integer( llrowCount )) + ' serial numbers, ' + &
		'but the packing container only has ' + string( integer(_qty) ) +  ' units.  Please scan individual serial numbers on remaining rows for this SKU.' )
	Return -1
End If
idsSerial.SetFilter('')
idsSerial.filter()
	
return 0


end function

public function integer checkinterfacerows (decimal _qty, ref datawindow adwserial);// integer = checkinterfacerows( decimal _qty )
long llAvail
string lsSku
string lsFilter
long interfacerows
	
//Make sure carton Qty >= remaining qty to be scanned
llAvail = 0
lsSKU = idsSerial.GetITemString(1,'SKU')

lsFilter = " Upper(sku) = '" + Upper(Trim(lsSKU))  + "' and IsNull(serial_no)"

adwSerial.setredraw( false )
adwSerial.setFilter( lsFilter )
adwSerial.filter()
interfaceRows = adwSerial.rowcount()
adwSerial.setFilter( "" )
adwSerial.filter()
adwSerial.setredraw( true )

If _qty > interfaceRows Then
		doDisplayMessage('Full Carton Check', "Not enough product left for a full carton of SKU: " + lsSKu + &
								"  Carton Quantity: " + string( integer( _qty ) ) +  &
								"  Serial Numbers to Populate: " + string( interfaceRows)+ & 
								"  A Carton Serial Number can only be used when shipping a full carton."+&
								"  Please scan individual serial numbers on remaining rows for this SKU." )
		return -1

	End If

return 0

end function

public subroutine setpackingrows (long _value);// setPackingRows( long _value )
ilPackingRows = _value

end subroutine

public function long getpackingrows ();// long = getPackingRows()
return ilPackingRows

end function

public subroutine setdesgfind (long _value);// setDesgFind( long _value )
ilDesgFind = _value
end subroutine

public function long getdesgfind ();// long = getDesgFind()
return ilDesgFind
end function

public function integer checkpackingcoo (ref datawindow adw_pack, long _packrow);// integer = checkPackingCoo( ref datawindow, long packRow )

string lsTitle = 'Serial Carton Scanning'
integer failure = -1
integer success = 0
string lsCoo
string lsSyntax
long llCooRow
n_warehouse i_nwarehouse

lsCoo= g.ids_coo_translate.object.Designating_Code[ getDesgFind() ]
lsSyntax =  "iso_country_cd = '" + lsCoo + "'"	
llCooRow= i_nwarehouse.of_any_tables_filter(g.ids_Country,lsSyntax)
	
IF llCooRow  <= 0 	THEN
	doDisplayMessage(lsTitle,"Country of Origin not found for updating pack list")
	Return failure
ELSE
	//Get the 2 char from country table & assign it to pack list
	lscoo=g.ids_Country.object.Designating_Code[ llCooRow ]
	adw_pack.object.country_of_origin[ _packrow ]=lsCoo
END IF	
return success

end function

public subroutine setsumpackingqty (decimal _value);// setSumPackingQty( decimal _value )
idSumPackingQty = _value
end subroutine

public function decimal getsumpackingqty ();// decimal = getSumPackingQty()
if isNull( idSumPackingQty ) then idSumPackingQty = 0
return idSumPackingQty

end function

public function integer doprocesspackingrows (ref datawindow adw_serial, string _barcode, decimal _serialcartonqty, ref string asmessage, string _sku, long _packrow);// integer = doProcessPackingRows( ref datawindow adwSerial, string _BarCode, dec _qty, string sku )

boolean foundError
boolean passes
integer success = 1
integer failure = -1
integer index
int cntr

String lsTitle = 'Serial Carton Scanning'
String ls_syntax
String ls_null
String lsFind
String lsPackSupplier
String lsSupplier
String  lsSerialNo
String lsSku

long ll_find
long ll_desg_find
long interfaceRows
long llFindRow
long llSerialRows
int max

SetNull( ls_null )
//
// check the item serial prefixs
//
interfaceRows = idsSerial.rowcount()
for index = 1 to interfaceRows
	lsPackSupplier = getSupplierCode()
	lsSerialNo = idsSerial.object.serial_no[ index ]
	if isNull( lsSerialNo ) then continue
	lsSku = idsSerial.object.sku[ index ]
	passes = doserialprefixcheck(  lsSerialNo, lsSku ) 
	if not passes then exit
next
if not passes then return -1
//
//Copy from carton serial table to serial tab on DO
//
cntr= 0
long storeRow
lsFind = " Upper(sku) = '" + Upper( _sku ) + "' and isnull(serial_no) and supp_code='" + lsPackSupplier + "'"
llFindRow = 1
llSerialRows = idsSerial.rowcount()
For index = 1 to llSerialRows
	llFindRow = adw_serial.Find(lsFind,llFindRow,adw_serial.RowCount())
	If llFindRow > 0 Then
		if doValidateProcessType( adw_serial.object.item_master_user_field4[ llFindRow ] , _sku  ) < 0 then
			founderror = true
			exit
		end if
		if index = 1 then storeRow = llFindRow
		cntr++ 
		adw_serial.object.serial_no[ llFindRow] = idsSerial.object.serial_no[ index]
		adw_serial.object.carton_no[ llFindRow ] = idsPack.object.carton_no[  _packrow ] 
		
	end if
Next 
if founderror then return -1
if cntr >0 then
	if storeRow > 0 then
		adw_serial.scrolltorow( storeRow )
		adw_serial.setrow( storeRow )
		return 1
	end if
else
	asMessage= "Scan Complete. " + string( llSerialRows) + " items processed."
end if

return 1

end function

public subroutine setpackingcartonqty (decimal _value);// setpackingCartonQty( decimal _value )
idPackingCartonQty = _value

end subroutine

public function decimal getpackingcartonqty ();// decimal = getPackingCartonQty()
return idPackingCartonQty

end function

protected function integer uf_linksys_do_scan (string ascurrentsku, ref string asmessage, string asbarcode, ref datawindow adwmain, ref datawindow adwdetail, ref datawindow adwserial, long alcurrentrow);//Process Linksys Serial/MAC ID scans - DELIVERY ORDER

String	lsNewSql, lsSKU, lsSerial, lsFind, lsProject, lsSupplier, lsMACID, lsScanType
Long		lLRowCount, llRowPos, llFindRow, llAvail, llScrollTo, llCount
Boolean	lbSerialSet, lbSerial
Str_parms	lStrParms


//If Scan <> 12 digits, then not a valid scan
If Len(asBarCode) <> 12 Then
	Messagebox('', 'Invalid Barcode scanned (must be 12 digits)!', StopSign!)
	Return -1
End If
	
// There is no way to completely determine whether the user scanned a carton, Serial or Mac. We will need to potentially do
// lookups on all 3 to determine.  For now Mac ID's begin with '00' but serial and cartons have no pattern

If Left(asBarcode,2) = '00' Then /*Probably a Mac ID, try that first*/
	
	//Retrieve the Serial number and populate serial tab based on MAC ID
	lsNewSql = isOrigSql + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
	lsNewSQL += " and Mac_ID = '" + asBarCode + "'"
	idsSerial.SetSqlSelect(lsNewSql)
	llrowCount = idsSerial.retrieve()
	
	If llRowCount > 0 Then /* It was a MAC ID*/
		
		lsScanType = 'M' 
		
	Else /* Not a MAC, Try Serial Next */
		
		lsNewSql = isOrigSql + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
		lsNewSQL += " and Serial_no = '" + asBarCode + "'"
		idsSerial.SetSqlSelect(lsNewSql)
		llrowCount = idsSerial.retrieve()
		
		If lLRowCount > 0 Then /*it was a Serial */
			lsScanType = 'S' 
		Else /*Not a MAC or Serial, try a Carton */
			lsNewSql = isOrigSql + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
			lsNewSQL += " and carton_id = '" + asBarCode + "'"
			idsSerial.SetSqlSelect(lsNewSql)
			llrowCount = idsSerial.retrieve()
			
			If llRowCount > 0 Then /*It was a carton */
				lsScanType = 'C'
			Else /* Not a carton, Serial or MAC */
				lsScanType = 'X'
			End If
			
		End If
		
	End If
	
Else /* Doesn't appear to be a MAC (doesn't begin with 00), try a carton first, then serial and MAC last */
	
	lsNewSql = isOrigSql + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
	lsNewSQL += " and carton_id = '" + asBarCode + "'"
	idsSerial.SetSqlSelect(lsNewSql)
	llrowCount = idsSerial.retrieve()
			
	If llRowCount > 0 Then /*It was a carton */
		lsScanType = 'C'
	Else /* Not a carton,Try Serial */
	
		lsNewSql = isOrigSql + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
		lsNewSQL += " and Serial_no = '" + asBarCode + "'"
		idsSerial.SetSqlSelect(lsNewSql)
		llrowCount = idsSerial.retrieve()
		
		If lLRowCount > 0 Then /*it was a Serial */
			lsScanType = 'S' 
		Else /*Not a serial, Try a MAC*/
			
			lsNewSql = isOrigSql + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
			lsNewSQL += " and MAC_ID = '" + asBarCode + "'"
			idsSerial.SetSqlSelect(lsNewSql)
			llrowCount = idsSerial.retrieve()
		
			If lLRowCount > 0 Then /*it was a MAC */
				lsScanType = 'M' 
			Else /*Not on File*/
				lsScanType = 'X'
			End If
			
		End If
		
	End If
	
End If

//Process the Scan
Choose case lsScanType
		
	Case 'S', 'M' /*Serial or MAC ID*/
		
		For llRowPos = 1 to llRowCount  /*Each Serial/MAC Record found - see if we have an empty row on the Delivery serial tab */
			
			lsSKU = idsSerial.GetITemString(llRowPos,'SKU')
			lsSerial = idsSerial.GetITemString(llRowPos,'serial_no')
			lsMacID = idsSerial.GetITemString(llRowPos,'Mac_ID')
			
			//Make sure this serial hasn't already been entered
			lsFind = " Upper(sku) = '" + Upper(lsSKU) + "' and Upper(serial_No) = '" + Upper(lsSerial) + "'"
			If adwSerial.Find(lsFind,1,adwSerial.RowCount()) > 0 Then
				Messagebox('','This Serial Number/MAC ID has already been scanned on this order!',StopSign!)
				Return -1
			End If
			
			//Make sure this serial/MAC wasn't shipped on a previous order
			If idsSerial.Find("status_cd = 'X'",1,idsSerial.RowCount()) > 0 Then
				Messagebox('','This Serial Number/MAC ID was scanned on another shipped order!',StopSign!)
				Return -1
			ElseIf idsSerial.Find("status_cd = 'P'",1,idsSerial.RowCount()) > 0 Then
				Messagebox('','This Serial Number/MAC ID was scanned on another order (pending shipment)!',StopSign!)
				Return -1
			End If
						
			//If a current row passed in parm, it was from an itemchanged on serial column and we want to update a specific row,
			// otherwise, we'll update the first empty one
			If alCurrentRow > 0 Then
				adwSerial.SetITem(alCurrentRow,'serial_no',lsSerial)
				adwSerial.SetITem(alCurrentRow,'mac_id',lsmacID)
				If lsScanType = 'S' Then
					asMessage = "Serial Number " + asbarcode + " processed from file..."
				Else
					asMessage = "MAC ID " + asbarcode + " processed from file..."
				End IF
				Return 1
				
			Else /*find first empty one*/
				
				lsFind = " Upper(sku) = '" + Upper(lsSKU) + "' and isnull(serial_no)"
				llFindRow = adwSerial.Find(lsFind,1,adwSerial.RowCount())
				If llFindRow > 0 Then
					adwSerial.SetITem(llFindRow,'serial_no',lsSerial)
					adwSerial.SetITem(llFindRow,'Mac_ID',lsMACID)
					lbSerialSet = True
					If lsScanType = 'S' Then
						asMessage = "Serial Number " + asbarcode + " processed from file..."
					Else
						asMessage = "MAC ID " + asbarcode + " processed from file..."
					End IF
					adwSerial.ScrollToRow(llFindRow)
					Return 1
				End If
				
			End If
			
		Next /*serial record found*/
		
	Case 'C' /*Carton*/
		
		//If a carton is being scanned, it must be a full carton and the full carton qty must be <= the qty being shipped
		// Carton qty on the serial records will be set and confirmed when the sweeper imports the file
		
		llrowCount = idsSerial.rowCount() /*Count of serial records for this Carton*/
		
		//See if this carton has already been scanned (check first serial in carton to see if already on DO serial tab)
		lsFind = " Upper(sku) = '" + Upper(lsSKU) + "' and serial_no = '" + idsSerial.GetITemString(1,'serial_no') + "'"
		llFindRow = adwSerial.Find(lsFind,1,adwSerial.RowCount())
		If llFindRow > 0 Then
			Messagebox('', "This carton has already been scanned")
			Return -1
		End If
		
		//Make sure this Carton wasn't shipped on a previous order
		If idsSerial.Find("status_cd = 'X'",1,idsSerial.RowCount()) > 0 Then
			Messagebox('',"One or more items in this carton were scanned on another shipped order!.~rYou will need to scan individual Serial Numbers/MAC ID's",StopSign!)
			Return -1
		ElseIf idsSerial.Find("status_cd = 'P'",1,idsSerial.RowCount()) > 0 Then
			Messagebox('',"One or more items in this carton were scanned on another order (pending Shipment)!.~rYou will need to scan individual Serial Numbers/MAC ID's",StopSign!)
			Return -1
		End If
			
		//Check for partial qty remaining
		If llRowCount < idsSerial.GetITemNumber(1,'carton_qty') Then
			Messagebox('','Only Full cartons can be scanned!~r(Full Carton = ' + String(idsSerial.GetITemNumber(1,'carton_qty')) + &
							", Current Carton Qty = " + String(llRowCount) + ")",StopSign!)
			Return -1
		End If
		
		//Make sure carton Qty >= remaining qty to be scanned
		llAvail = 0
		lsSKU = idsSerial.GetITemString(1,'SKU')
		lsFind = " Upper(sku) = '" + Upper(lsSKU) + "' and isnull(serial_no)"
		llFindRow = adwSerial.Find(lsFind,1,adwSerial.RowCount())
		Do While llFindRow > 0
			llAvail ++
			llFindRow ++
			If llFindRow > adwSerial.RowCount() Then
				llFindRow = 0 
			Else
				llFindRow = adwSerial.Find(lsFind,llFindRow,adwSerial.RowCount())
			End If
		Loop
		
		If idsSerial.GetITemNumber(1,'carton_qty') > llAvail Then
			messagebox('', "You can not scan a carton unless you are shipping the entire carton!~r(Full Carton = " + String(idsSerial.GetITemNumber(1,'carton_qty')) + &
							", Remaining to scan = " + String(llAvail) + ")",StopSign!)
			Return -1
		End If
		
		
		//Copy from carton serial table to serial tab on DO
		llFindRow = 1
		lsFind = " Upper(sku) = '" + Upper(lsSKU) + "' and isnull(serial_no)"
		For llRowPos = 1 to llRowCount
			llFindRow = adwSerial.Find(lsFind,llFindRow,adwSerial.RowCount())
			If llFindRow > 0 Then
				adwSerial.SetItem(llFindRow,'serial_no',idsSerial.GetITemString(llRowPos,'Serial_No'))
				adwSerial.SetItem(llFindRow,'Mac_ID',idsSerial.GetITemString(llRowPos,'Mac_ID'))
				llScrollTo = llFindRow
			End If
		Next
		
		adwSerial.ScrollToRow(llScrollTo)
		asMessage = "Carton ID " + asBarcode + " processed from file. (" + String(llRowCount) + " units processed.)"
		Return 1
				
	Case 'X' /*Not on File*/
		
		lbSerialSet = False /*Will cause prompt for user to enter below*/
		
End Choose

////If UF3 on Delivery Detail not set to 'MAC-ID', then we won't have to send MAC ID's back on GI - no need to validate here
//If adwDetail.Find("Upper(User_Field3) = 'MAC-ID'",1, adwDetail.RowCount()) = 0 Then 
//	Return 0
//End If


//If Serial record not found in table or on serial tab, we need to prompt and enter manually
If Not lbSerialSet Then
	
	//Prompt user for SKU and Serial Number (If only 1 SKU on Serial tab, then they don't need to enter the SKU)
	If adwSerial.RowCount() = 1 Then
		lStrparms.String_arg[1] = adwSerial.GetITemString(1,'SKU') /*Only 1 SKU present */
	ElseIf adwSerial.Find("SKU <> '" + adwSerial.GetITemString(1,'SKU') + "'",1,adwSerial.RowCount()) = 0 Then
		lStrparms.String_arg[1] = adwSerial.GetITemString(1,'SKU') /*Only 1 SKU present */
	Else /*Multiple SKUS on Serial Tab - If we previosly scanned a SKU and there are still empty slots for this SKU, set as default */
		If asCurrentSKU > '' Then /*Sku scanned on serial tab before scanning the serial number*/
			lstrParms.String_arg[1] = asCurrentSKU
		ElseIf isPrevSKU > '' and adwSerial.Find(" Upper(sku) = '" + Upper(isPrevSKU) + "' and isnull(serial_no)",1,adwSerial.RowCount()) > 0 Then
			lstrParms.String_arg[1] = isPrevSKU
		Else
			lStrparms.String_arg[1] = '' /*empty sku will force to be entered on prompt screen*/
		End If
	End If
		
	// If barcode begins with 00, we will assume (for now) that the user scanned the MAC ID
	If left(asBarcode,2) <> '00' Then /*Serial scanned*/
		lstrparms.String_arg[2] = asBarcode /*Serial*/
		lstrparms.String_arg[3] = '' /*MAc ID*/
	Else /*Mac Scanned */
		lstrparms.String_arg[2] = '' /*Serial*/
		lstrparms.String_arg[3] = asBarcode /*MAc ID*/
	End If
	
	OpenWithParm(w_carton_serial_Prompt,lstrparms) /*based on parms passed in, will prompt for serial or Mac and Sku if necessary*/
	lstrparms = Message.PowerObjectParm
	If Not lstrparms.Cancelled Then
		
		isPrevSKU = lstrparms.String_Arg[1]
		lsProject = adwmain.GetITemString(1,'Project_id')
		lsSKU = lstrparms.String_Arg[1]
		lsSerial = Lstrparms.String_Arg[2]
		lsMACID = lstrParms.String_arg[3]
		
		//Make sure this Serial Number has not already been scanned on this order
		lsFind = " Upper(sku) = '" + Upper(lsSKU) + "' and Upper(serial_No) = '" + Upper(lsSerial) + "'"
		If adwSerial.Find(lsFind,1,adwSerial.RowCount()) > 0 Then
			Messagebox('','This Serial Number has already been scanned on this order!',StopSign!)
			Return -1
		End If
		
		//Make sure this MAC ID has not already been scanned on this order
		lsFind = " Upper(sku) = '" + Upper(lsSKU) + "' and Upper(MAC_ID) = '" + Upper(lsMacID) + "'"
		If adwSerial.Find(lsFind,1,adwSerial.RowCount()) > 0 Then
			Messagebox('','This MAC ID has already been scanned on this order!',StopSign!)
			Return -1
		End If
		
		//Find an empty row for this SKU or set specific row if passed in parm
		If alCurrentRow > 0 Then
			
			llFindRow = alCurrentRow
			
		Else
			
			lsFind = " Upper(sku) = '" + Upper(lStrparms.String_arg[1]) + "' and isnull(serial_no)"
			llFindRow = adwSerial.Find(lsFind,1,adwSerial.RowCount())
			
		End If
		
		If llFindRow > 0 Then
			
			adwSerial.SetITem(llFindRow,'serial_no',lstrparms.String_arg[2])
			adwSerial.SetITem(llFindRow,'Mac_ID',lstrparms.String_arg[3])
			
			lsSupplier = adwSerial.GetITemString(llFindRow,'Supp_code')
			
			//01/06 - PCONKL - No longer saving to DB until w_do.ue_save
			
			//Insert a record into the Carton_serial table so we can return serial/Mac combo on GI
//			Execute Immediate "Begin Transaction" using SQLCA;
//			
//			Insert Into Carton_Serial(Project_id, Carton_ID, Serial_No, MAc_ID, Pallet_ID, SKU, Supp_Code, Status_CD)
//					values (:lsProject, '-', :lsSerial, :lsMACID, '-', :lsSKU, :lsSupplier, 'M')
//			Using SQLCA;
//				
//			Execute Immediate "COMMIT" using SQLCA;
			
			asMessage = "Serial Number added to table..."
			Return 1
			
		Else
			Messagebox('','SKU Not found or all Serial Numbers entered for this SKU!',StopSign!)
			Return -1
		End If
		
	End If /*Prompt not Cancelled*/
	
End If /* Prompt for Serial */
		

Return 0
end function

public function integer dovalidatecartonid (string ascartonid);// integer = doValidateCartonId( string asCartonId )

/*
	the carton id they enter must be in the packing list.

*/

string	findthis
long findrow

findthis = "carton_no = '" + asCartonID + "'"
findrow = idsPack.find( findthis,1,idsPack.rowcount() )
if findrow <=0  then
	return -1
end if

return 0

end function

public function integer uf_3com_do_scan (string ascurrentsku, ref string asmessage, string asbarcode, string aspackcarton, ref datawindow adwmain, ref datawindow adwdetail, ref datawindow adwpack, ref datawindow adwserial, ref datawindow adwpick, long alcurrentrow);// integer = uf_3com_do_scan( string ascurrentsku, string asmessage, string asbarcode, string aspackcarton, &
//											 datawindow adwmain, datawindow adwdetail, datawindow adwpack, datawindow adwserial, &
//											datewindow adwpick, long alcurrentrow )
//
//Process 3COM Carton Scan - DELIVERY ORDER

String	lsNewSql
string 	lsFind
Long		lLRowCount
long 		llRowPos
long 		llFindRow
string 	lsSku
int 		index
string 	lsSupplier
string 	lsSerialNo
string 	ls_Syntax
int max
long packrow
string packingsku
int rtnCode
int cntr
int lqty

// if the packing only contains one row..grab the carton id and sku
if adwpack.rowcount() = 1 then
	ascurrentsku = adwserial.object.sku[ 1 ]
	asPackCarton = adwpack.object.carton_no[ 1 ]
	setsumpackingqty( adwpack.object.quantity[ 1 ] )
end if

// check the first character if it's not camp3, then it must be a serial
if NOT MATCH( Upper( left( asBarCode, 1 )), '[CAMP3]' ) then
	return 0 // kick it back to w_do
end if
	
// see if we have data
lsNewSql = isOrigSql + " Where Project_id = '" + adwmain.GetITemString(1,'Project_id') + "'"
lsNewSQL += " and Carton_ID = '" + asBarCode + "'"
idsSerial.SetSqlSelect(lsNewSql)
llrowCount = idsSerial.retrieve()

// if there is no data and the first character is 'M' check the serial prefix
// before processing as a serial  'M' isn't included in the normal check
if llRowCount <= 0 and  Left( asBarCode, 1 ) = 'M' then
		if doserialprefixcheck( asBarCode, asCurrentsku ) then 
			return 0
		else
			return -1
		end if
end if
	
// if there is no data, process as a serial number
if llRowCount <= 0 then return 0 // process in w_do

//setSupplierCode( "" )
//// see if the returned serial carton rows are those from a participating vendor
//if NOT checkSerialCartonVendor() then return 0 // process in w_do

// Try and figure out which packing row they are scanning for...
rtnCode =  SetPackingRows( adwpack, aspackcarton, asCurrentsku, adwpick, adwserial )
/*

SetPackingRows figures out if the supplier is participating, among other things. It now returns the following....
-1...meaning the supplier choosen/determined doesn't have enough quantity for a full case.
 0....meaning the supplier is participating and there is enough quantity for a full case
 1....the supplier isn't a participant.

case 1	if the determined supplier is a non participant...return 0 // normal processing

case 0	

case -1	if the carton serial is found then there isn't enough room for the serials, return quantity error.
	          if the carton serial isn't found and the entered value begins with '3' or 'M' return 1 // normal processing
		     if the carton serial isn't found and the entered value isn't '3' or 'M' display carton not found error.
			  
case -2 User cancelled supplier pick
case -3 User entered combo not found on packing.
case -4 missing/invalid packing number
case -5 missing/invalid sku
	
*/
choose case rtnCode
	case 0 // good 2 go
//	case 1 // not a participant 
//		return 0
	case -1 // not enough rows
		if Left( asBarCode, 1 ) = '3' or Left( asBarCode, 1 ) = 'M' then return 0 // not an error, maybe a serial or sku
		doDisplayMessage('SmartCode', "Not enough remaining rows for supplier.~r~nPlease check" )
		return -1
//	case -2 // user cancelled picking supplier pick window
//		Return -1
	case -3
		doDisplayMessage('SmartCode', "Sku "  + Upper( ascurrentsku ) + " not found in carton " + aspackCarton + " in Packing!" )
		return -1
	case -4
		doDisplayMessage('SmartCode', "Missing or Invalid Packing Carton #, Please Check!" )
		return -1
	case -5
		doDisplayMessage('SmartCode', "Missing or Invalid SKU, Please Check!" )
		return -1
end choose

// position interface to first participating vendor...
// position interface...
lsFind = " Upper(sku) = '" + Upper(ascurrentsku) + "' and isnull(serial_no)"
//lsFind = " Upper(sku) = '" + Upper(ascurrentsku) + "' and isnull(serial_no) and participatingsupplier = 0 "
llFindRow = adwserial.Find(lsFind,1,adwserial.RowCount() + 1) 
If llFindRow > 0 Then
	adwserial.SetRow(llFindRow)
	adwserial.ScrolltoRow(llFindRow)
	adwserial.SetColumn('serial_no')
end if

// See if this carton has already been scanned (check first serial in carton to see if already on DO serial tab)
lsFind = " Upper(sku) = '" + Upper( ascurrentsku ) + "' and serial_no = '" + idsSerial.GetITemString(1,'serial_no') + "'"
llFindRow = adwSerial.Find(lsFind,1,adwSerial.RowCount())
If llFindRow > 0 Then
	doDisplayMessage('SmartCode', "This carton has already been scanned for this order")
	Return -1
End If

if doValidateCartonSerialForSku( asCurrentSKU ) < 0 then
	doDisplayMessage('SmartCode', "The scanned carton is not valid for this sku, Please Check!")
	return -1
end if
if CartonAlreadyUsed() < 0 then return -1
if  doValidateCartonid( aspackcarton ) < 0 then return -1
if CheckForFullCarton( getSumPackingQty() ) < 0 then return -1

return  doProcessPackingRows( adwSerial, asBarCode, idsSerial.object.carton_qty[1] , asMessage, asCurrentSKU, getCurrentPackRow() )

	



end function

public function string getownerid (string _sku, string _supplier, ref datawindow adwpick);// string = getOwnerId( string sku )

string findthis
long	foundrow
string lsOwner

findthis = "sku = '" + _sku + "' and supp_code = '" + _supplier + "'"
foundrow = adwpick.find( findthis, 1, adwpick.rowcount() )
if foundrow > 0 then
	lsOwner = adwpick.object.cf_owner_name[ foundrow ]
end if

return lsOwner

end function

public subroutine setcurrentpackrow (long _row);// setCurrentPackRow( long _row )
ilCurrentPackRow =  _row 
end subroutine

public function long getcurrentpackrow ();// long = getCurrentPackRow()
return ilCurrentPackRow

end function

public function integer dovalidateprocesstype (string _type, string _sku);// integer = doValidateProcessType( string _type, string _sku, string _supplier )

choose case  trim(upper( _type ))
	case 'BCC','BNC'
		return 0
	case else
		doDisplayMessage( "SmartCode", "Invalid Process Type for sku: " + _sku + ",  See ~'Process~' Field in Item Master.~r~nValid Process Types are ~'BCC~'  & ~'BNC~'" )
		return -1
end choose		

return 0

end function

public function string getpackingsku (string assku, ref datawindow idw_pack);// string = getPackingSku( string asSku )

string lsFind
long llFindRow
string returnsku
boolean foundit
int index
int max

returnSku = ''
lsFind = "Upper( sku ) = '" + assku + "'"
llFindRow = idw_pack.find( lsFind, 1, idw_pack.rowcount() )
if llFindRow <=0 then
	// see if the sku is a child
	llFindRow = idsparentskbychild.retrieve( gs_project, assku )
	if llFindRow > 0 then
		max = llFindRow
		foundit = false
		// try again with each parent found
		For index = 1 to max 
			lsFind = "Upper( sku ) = '" + idsparentskbychild.object.sku_parent[ index ] + "'"
			llFindRow = idw_pack.find( lsFind, 1, idw_pack.rowcount() )
			if llFindRow > 0 then
				foundit = true
				returnsku = idw_pack.object.sku[ llFindRow ]
				exit
			end if
		next
		if NOT foundit then
			setParentSkuFlag( false )
			setPackingSkuError( -1 )
			return ""
		else
			setParentSkuFlag( true )
			setChildSku( assku )
			setPackingSkuError( 0 )
			return returnSku
		end if
	else
		setParentSkuFlag( false )
		setChildSku( "" )
		setPackingSkuError( -1 )
		return ''
	end if
else
	setParentSkuFlag( false )
	setChildSku( "" )
	setPackingSkuError( 0 )
	return assku
end if



end function

public subroutine setpackingskuerror (integer _state);// setPackingSkuError()
iPackingSkuError = _state
end subroutine

public function integer getpackingskuerror ();// int = getPackingSkuError()
return iPackingSkuError

end function

public subroutine setparentskuflag (boolean _flag);// setParentSkuFlag()
ibParentSku = _flag

end subroutine

public function boolean getparentskuflag ();// boolean = getParentSkuFlag()
return ibParentSku

end function

public subroutine setchildsku (string _sku);// setChildSku( string _sku )
isChildSku = _sku

end subroutine

public function string getchildsku ();return isChildSku

end function

public function integer setpackingrows (ref datawindow adwpack, string aspackcarton, string ascurrentsku, ref datawindow adwpick, ref datawindow adwserial);// SetPackingRows( ref datawindow adwPack, string asPackCarton, datawindow adwpick )

string sFilter
long packrows
int index
long test
decimal ldsumqty
string packingsku
string	supplier
int	cntr
boolean good2go
boolean foundone
boolean notenoughrows
string lsFind
long llFindrow


// make a copy
idsPack.reset()
adwpack.RowsCopy ( 1, adwpack.rowcount() , primary!, idsPack, 99999999 , primary! )

if doValidateCartonId( aspackcarton )  < 0 then return -4 // missing packing number

// get the sku that's on the packing list...a child sku may have been scanned
packingsku = getPackingSku( asCurrentSku, adwpack )
if getPackingSkuError() = -1 then return -5

// filter out all but the scanned carton and sku
sFilter = "carton_no = '" + asPackCarton + "' and Upper( sku ) = '" + packingsku + "'" 
idsPack.setFilter( sFilter )
idsPack.filter()
// got to have a supplier for later
if  idsPack.rowcount()  = 1 then setSupplierCode( idspack.object.supp_code[ 1 ] )
// 
// sort it by supplier
//
idsPack.setSort( "supp_code A")
idsPack.sort()

//notenoughrows = false
//foundone = false
//packRows = idsPack.rowcount() 
//if packRows = 0 then return -3 // combo not found on packing
//
//// dump non participating supplier packing rows
//for index = 1 to packRows
//	setparticipatingsupplier(  idspack.object.supp_code[ index ] )
//	if  Not getParticipant() then
//		idsPack.rowsdiscard(index, index, primary! )
//		index --
//		packrows --
//	end if
//next
//if packRows = 0 then	return 1 // No Participants

// remove those packing rows that have already done
if packRows > 1 then
	for index = 1 to packRows
		ldsumqty = idspack.object.quantity[ index ]
		lsFind = "carton_no = '" + asPackCarton + "' and Upper( sku ) = '" + packingsku + "'" 
		llFindRow =  adwSerial.Find(lsFind,1, adwSerial.RowCount())
		cntr=0
		do while llFindRow > 0 
			cntr++
			llFindRow ++
			llFindRow = adwSerial.Find(lsFind,( llFindRow ),adwSerial.RowCount())
		loop
		if cntr >= ldsumqty then
			idsPack.rowsdiscard(index, index, primary! )
			index --
			packrows --
		end if
	next
end if
if idsPack.rowcount() = 0 then return 1 // no available rows left, process as a serial 

// We may have to go to picking to determine the correct supplier
//for index = 1 to packRows
//	// figure out which supplier they mean
//	supplier = getPackingSupplier( index, adwpick, adwserial )
//	choose case supplier
//		case "Cancelled"
//			return -2
//		case "not enough rows"
//			notenoughrows = true
//			exit
//		case "NoParticipants"
//			return 1
//		case 'NoCartonSerial'
//			return 1
//	end choose
//	idsPack.object.supp_code[ index ] = supplier // put the selected or found supplier in packing
//	foundone = true
//next
//if notenoughrows then return -1 // like....not enough rows!
//
// participating supplier check
// 
//if NOT foundone then return 1  // no participating supplier
//
// check the number of rows available to fill.
//
/*
	There are goofy rules.
		if there are more than one packing rows then....
			if one of the vendors is 3com
				and one of the vendors is a vmi vendor then
					if we have enough to fill the 3com, then we'll do that
					if there isn't enough 3com, then try a vmi vendor
					if we have enough to fill the vmi, then we'll do that
					else its an error
		
*/
ldsumqty = 0
cntr = 0
good2go = false
for index = 1 to packRows
	supplier = idsPack.object.supp_code[ index ] 
	if doValidateEnoughRowsForSupplier( packingsku , supplier, adwserial )  then
		setSumPackingQty( idsPack.object.quantity[ index ] )
		setCurrentPackRow( index )
		setSupplierCode( supplier )
		good2go = true
		exit
	end if
next
if not good2go then return -1  // not enough rows

return 0 // all is good


end function

public subroutine dodisplaymessage (string _title, string _message);// doDisplayMessage( string _title, string _message )

str_parms	lstrParms


lstrParms.string_arg[1] = _title
lstrParms.string_arg[2] = _message

openwithparm( w_scan_message, lstrParms )

end subroutine

public function boolean dovalidateenoughrowsforsupplier (string sku, string supplier, ref datawindow adwserial);// boolean = doValidateEnoughRowsForSupplier( string sku, string supplier, datawindow adwserial )

int cntr
int lqty
string lsFind
long llFindRow
long	cartonqty

cntr = 0
			
if getParentSkuFlag() then sku = getChildSku( )
lsFind = " Upper(sku) = '" + Upper( sku ) + "' and supp_code = '" + supplier + "' and isNull( serial_no )"
llFindRow =  adwSerial.Find(lsFind,1, adwSerial.RowCount())
do while llFindRow > 0 and ( llFindRow + 1 <= adwSerial.RowCount())
	cntr++
	llFindRow = adwSerial.Find(lsFind,( llFindRow +1 ),adwSerial.RowCount())
loop
if llFindRow > 0 then cntr++
cartonqty = idsSerial.object.carton_qty[1] 
If cntr  < cartonQty Then	Return false

return true

end function

public function integer dovalidatecartonserialforsku (string _sku);// integer = doValidateCartonSerialForSku( string sku )
string  lsFind
long llFindrow

lsFind = " Upper(sku) = '" + Upper( _sku ) + "'" 
llFindRow = idsSerial.Find(lsFind,1,idsSerial.RowCount())
If llFindRow <=0 Then
	Return -1
End If

return 0

end function

public function string getpackingsupplier (long _index, ref datawindow adwpick, ref datawindow adwserial);// string = getPackingSupplier(  long _index, ref datawindow adwpick, ref datawindow adwserial  ) 

/*
	The sku they scanned in may be a child sku.  
	Look at the packing and see what row the parent is in
	then grab the line item number and see if you can determine the
	supplier from picking.
	
	if more than 1 supplier is found for the sku on picking
	and there are available serial rows for more than one supplier,
	display a dialog asking which supplier they'd like to use

*/
int			index
string 	sku
string 	foundSupplier
string 	filterthis
long		pickrows
int 		max
long lineitemnumber
str_parms parms

foundSupplier = ''
if getParentSkuFlag() then
	sku = getChildSku()
	lineitemnumber = idsPack.object.line_item_no[ _index ]
	setSumPackingQty( idsPack.object.quantity[ _index ] )
	setSupplierCode( idsPack.object.supp_code[ _index ] )
else
	setSupplierCode( idsPack.object.supp_code[ _index ] )
	return idsPack.object.supp_code[ _index ]
end if

// a child was scanned...go get the supplier from picking

// make a copy since we don't want to alter the "view" of the picking list
idsPick.reset()
adwpick.RowsCopy ( 1, adwpick.rowcount() , primary!, idsPick, 99999999 , primary! )

max = idsPick.rowcount()
filterthis = "line_item_no = " +String( lineitemnumber ) + " and sku = '" + sku + "'"
idsPick.setFilter( filterthis )
idsPick.Filter( )
pickrows = idsPick.rowcount()
// 
// more and more magic
//
// if the supplier is from picking
// check if they are a participating supplier and
// discard the pickrow if they are not.
max = pickrows
for index = 1 to max
	setparticipatingsupplier(  idspick.object.supp_code[ index ] )
	if  Not getParticipant() then
		idsPick.rowsdiscard( index,index, primary! )
		index --
		max --
	end if
next
if idsPick.rowcount() = 0 then return 'NoParticipants'
//
// more magic
// 
// for each lineitem/supplier/sku, see if we have available serial rows.
// if we do not, decrement pickrows.
//
//
max = idsPick.rowcount()
for index = 1 to max
	if NOT doValidateEnoughRowsForSupplier( sku, idspick.object.supp_code[ index ], adwserial ) then
		idsPick.rowsdiscard( index,index, primary! )
		pickrows --
		index --
		max --
	end if
next

choose case pickrows
	case is > 1
		if getsuppliercount() = 1 then  // more than one pick row, but only one supplier for all of them.
			foundsupplier = idsPick.object.supp_code[ 1 ]
			setSuppliercode( foundsupplier )
		else
			openwithparm( w_smartcode_scan_supplier, idsPick )
			parms = message.powerobjectparm
			if parms.Cancelled then 
				foundSupplier = 'Cancelled'
			else
				if UpperBound( parms.string_arg ) > 0 then
					foundSupplier = parms.string_arg[1]
					if isNull( foundSupplier ) or len( foundSupplier) = 0 then 
						foundSupplier = 'Cancelled' 
					else
						setSuppliercode( foundsupplier )
					end if
				else // they hit the close X in the window
					foundSupplier = "Cancelled"
				end if
			end if
		end if
	case 1
		foundSupplier = idsPick.object.supp_code[ 1 ]
		setSuppliercode( foundsupplier )
	case else
		foundSupplier = "not enough rows"
end choose

return foundSupplier


end function

public function integer getsuppliercount ();// int = getsuppliercount()

long index
long max
string supplier
string supplierbreak = "*"
string supplierlist[]
int cntr

idsPick.setsort( "supp_code A" )
idsPick.sort()

max = idsPick.rowcount()

for index = 1 to max
	supplier = idsPick.object.supp_code[ index ]
	if supplier <> supplierbreak then
		cntr++
		supplierlist[ cntr ] = supplier
		supplierbreak = supplier
	end if
next
return UpperBound( supplierlist )


end function

public function boolean isvalidserialnumber (string asserialno);// boolean = isValidSerialNumber( string asSerialNo )

return true

end function

public function boolean doserialprefixcheck (string _serialnbr, string _sku);// boolean = doserialprefixcheck( string _serialnbr, string _sku ) 

// 01/07 - PCONKL - Leaving alone for 3COM - uf_validate_serial_prefix is available for other projects to validate variable length prefixes

string lsPackSupplier
string ls_syntax

w_do lparent
n_warehouse i_nwarehouse

lparent =  getParentWindow()
i_nwarehouse = lparent.i_nwarehouse
//
// check the item serial prefixs
//
lsPackSupplier = getSupplierCode()
_serialnbr = Upper( trim ( _serialnbr ))
ls_syntax = "prefix = '" + mid(_serialnbr,1,3) + "' and SKU='" + _Sku + "' and supp_code='" + lsPackSupplier + "'"
//
IF i_nwarehouse.of_any_tables_filter(g.ids_item_serial_prefix,ls_syntax) <= 0 	THEN 
	doDisplayMessage("SmartCode", _serialnbr + " is not a valid Serial number for part " +_Sku +", and Supplier "+ lsPackSupplier)
	return false
end if
//
return true

end function

public function boolean checkserialcartonvendor ();// boolean = checkSerialCartonVendor()

long rows
long index
string serialSupplier

string supplierBreak = "*"

rows = idsSerial.rowcount()

idsSerial.setsort( 'supp_code A' )
idsSerial.sort()

// discard rows which belong to non participating vendors
for index = 1 to rows
	serialSupplier = idsSerial.object.supp_code[ index ]
	if supplierBreak <> serialSupplier then
			setParticipatingSupplier( serialSupplier )
			if NOT getParticipant() then
				idsSerial.rowsdiscard(index, index, primary! )
				index --
				rows --
				serialSupplier = "*"
			end if
			supplierBreak = serialSupplier
	end if
next
if idsSerial.rowcount() > 0 then return true
return false


end function

public function boolean uf_validate_serial_prefix (string assku, string asserialno);
//validate the serial number against the serial prefix table

String	lsFind, lsPrefix
Long	llFindRow
Int	liStartPos

If g.ids_item_serial_prefix.RowCount() = 0 Then Return True

lsFind = "Upper(SKU) = '" + upper(asSKU) + "'"
llFindRow = g.ids_item_serial_prefix.Find(lsFind,1,g.ids_item_serial_prefix.RowCount())

//If no records found for sku, not validating
// 05/09 - PCONKL - Powerwave wants a hard stop if no entry in table

If llFindRow = 0 Then 
	
	If gs_project = 'POWERWAVE' Then
		Return False
	Else
		Return True
	End If
	
End If

Do While llFindRow > 0
	
	lsPrefix = g.ids_item_serial_prefix.getITemString(llFindRow,'Prefix')
	liStartPos = g.ids_item_serial_prefix.getITemNumber(llFindRow,'starting_Pos')
	
	//If starting pos not rpesent, default to 1
	If isnull(listartPos) or listartPos < 1 Then listartPos = 1
	
	If Upper(Mid(asSerialNO,listartPos,(len(lsPrefix)))) = Upper(lsPrefix) Then Return True
	
	If llFindRow >= g.ids_item_serial_prefix.RowCount() Then
		llFindRow = 0
	Else
		llFindRow ++
		llFindROw = g.ids_item_serial_prefix.Find(lsFind,llFindRow,g.ids_item_serial_prefix.RowCount())
	End If
		
Loop



Return False
end function

public function integer uf_powerwave_do_scan (string ascurrentsku, ref string asmessage, string asbarcode);

//Validate serial prefix
If NOt uf_validate_serial_prefix(asCurrentSku, asbarcode) Then
	
	doDisplayMessage('Serial Prefix validation', "Invalid Serial Number Prefix." )
	return -1
	
End If


Return 0 /* will drop through for rest of processing*/
end function

public function integer uf_do_scan_comcast ();
//Process DO scans for Comcast

// 05/10 - PCONKL - Allow for individual Serial Numbers to be scanned.

String	lsScan, lsSKU, lsFind, lsPallet, lsCarton
Long		llFindRow, llPalletQty, llCartonQty, llScanQty
//See if we scanned a Pallet
lsScan = w_do.tab_main.tabpage_serial.sle_barcodes.Text
 
//First see if we have scanned this pallet/carton before...
If w_do.tab_main.tabpage_serial.dw_serial.RowCount() > 0 Then
	If w_do.tab_main.tabpage_serial.dw_serial.Find("Serial_No = '" + lsScan + "'",1,w_do.tab_main.tabpage_serial.dw_serial.RowCount()) > 0 Then
		doDisplayMessage('Invalid Scan', "Pallet/CARTON ID has already been scanned." )
		Return -1
	End If
End If

Select Min(SKU), Count(*) into :lsSKU, :llPalletQty
From Carton_Serial
Where Project_id = 'COMCAST' and Pallet_id = :lsScan;

If lsSku > '' Then /*Pallet Exists*/

	//Make sure this pallet is what was actually picked
	llFindRow = w_do.idw_Pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Lot_No) = '" + Upper(lsScan) + "'",1, w_do.idw_Pick.RowCount())
	If llFindRow <= 0 Then
		
		w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
		doDisplayMessage('Pallet Scanned', "Pallet ID not found on Pick List.~r~nPlease correct Pick List and re-scan." )
		Return -1
		
	Else /* make sure a full pallet was picked, otherwise,they need to be scanning Cartons */
		
		If w_do.idw_Pick.GetITemNumber(llFindRow,'quantity') <> llPalletQty Then
			
			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
			doDisplayMessage('Pallet Scanned', "Pallet ID: '" + lsScan + "' was not picked in it's entirety.~r~nCarton ID's or Individual Serial Numbers must be scanned for this Pallet." )
			Return -1
			
		End If
		
	End If /*Pallet not found on Picking List*/

	lsPallet = lsScan
	llScanQty = llPalletQty /*Pallet Qty will be set on Serial record for validating at confirmation that all were entered*/
	w_do.tab_main.tabpage_serial.st_message.Text = "PALLET Scanned."
	
Else /* Not a pallet, see if we scanned a carton*/

	Select Min(SKU), Min(Pallet_id), Count(*)  into :lsSKU, :lsPallet, :llCartonQty
	From Carton_Serial
	Where Project_id = 'COMCAST' and Carton_id = :lsScan;

	If lsPallet > '' Then /*carton Exists */
	
		//Make sure this pallet is what was actually picked
		llFindRow = w_do.idw_Pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Lot_No) = '" + Upper(lsPallet) + "'",1, w_do.idw_Pick.RowCount()) 
		If llFindRow = 0 Then
		
			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
			doDisplayMessage('Carton Scanned', "Pallet ID: '" + lsPallet + "' not found on Pick List for this CARTON.~r~nPlease correct Pick List and re-scan." )
			Return -1
			
		Else /* Make sure we haven't already scanned a pallet that this caarton is contained in */
			
			If w_do.tab_main.tabpage_serial.dw_serial.find("Serial_No = '" + lsPallet + "'",1,w_do.tab_main.tabpage_serial.dw_serial.RowCount()) > 0 Then
				
				w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
				doDisplayMessage('Carton Scanned', "Pallet ID: '" + lsPallet + "' has already been scanned for this CARTON." )
				Return -1
		
			 End IF
				
		End If /*Pallet not found on Picking List*/
		
		llScanQty = llCartonQty /*Carton Qty will be set on Serial record for validating at confirmation that all were entered*/
		w_do.tab_main.tabpage_serial.st_message.Text = "CARTON Scanned."
	
	Else /* Not a Pallet or Carton Scan - Check for an Individual Serial Number scan*/
		
		Select Min(SKU), Min(Pallet_id), Min(carton_id)  into :lsSKU, :lsPallet, :lsCarton
		From Carton_Serial
		Where Project_id = 'COMCAST' and serial_no = :lsScan;
		
		If lsPallet > '' Then /*Serial Number Exists */
		
			//Make sure this pallet is what was actually picked
			llFindRow = w_do.idw_Pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Lot_No) = '" + Upper(lsPallet) + "'",1, w_do.idw_Pick.RowCount()) 
			If llFindRow = 0 Then
		
				w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
				doDisplayMessage('Serial Scanned', "Pallet ID: '" + lsPallet + "' not found on Pick List for this SERIAL NUMBER.~r~nPlease correct Pick List and re-scan." )
				Return -1
			
			Else /* Make sure we haven't already scanned a pallet or Carton that this Serial is contained in */
			
				If w_do.tab_main.tabpage_serial.dw_serial.find("Serial_No = '" + lsPallet + "'",1,w_do.tab_main.tabpage_serial.dw_serial.RowCount()) > 0 Then
				
					w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
					doDisplayMessage('Carton Scanned', "Pallet ID: '" + lsPallet + "' has already been scanned for this SERIAL NUMBER." )
					Return -1
		
				End IF
				
				If w_do.tab_main.tabpage_serial.dw_serial.find("Serial_No = '" + lsCarton + "'",1,w_do.tab_main.tabpage_serial.dw_serial.RowCount()) > 0 Then
				
					w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
					doDisplayMessage('Carton Scanned', "Carton ID: '" + lsCarton + "' has already been scanned for this SERIAL NUMBER." )
					Return -1
		
				End IF
				
			End If /*Pallet not found on Picking List*/
			
			llScanQty = 1
			w_do.tab_main.tabpage_serial.st_message.Text = "SERIAL NUMBER Scanned."
		
		Else /*invalid Serial Number*/
			
			w_do.tab_main.tabpage_serial.st_message.Text = "** Invalid Scan **"
		
			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
			doDisplayMessage('Invalid Scan', "Serial Number information for this Pallet/Carton has not been received from Comcast.~r~nUnable to process Serial Number." )
			Return -1
			
		End If
		
	End If
	
End If

//Find the first empty row for this scan. If no empty row, add a new one.
lsFind = "Upper(sku) = '" + Upper(lsSKU) + "' and (isnull(serial_no) or serial_no = '')"
llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
		
If llFindRow > 0 Then
			
	w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(llFindRow)
	w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'serial_no',lsScan)
	w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'quantity',llScanQty)
		
Else /* no empty rows, add a new row - Copy from another row for SKU*/
			
	lsFind = "Upper(sku) = '" + Upper(lsSKU) + "'"
	llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
		
	If llFindRow > 0 Then /* exists for SKU, Copy Row and set serial*/
			
		w_do.tab_main.tabpage_serial.dw_serial.RowsCopy(llFindRow,llFindRow,Primary!, w_do.tab_main.tabpage_serial.dw_serial,9999999,primary!) /*add at end*/
		w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(w_do.tab_main.tabpage_serial.dw_serial.RowCount())
		w_do.tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'serial_no',lsScan)
		w_do.tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'quantity',llScanQty)
		
	Else /*SKU NOt found on Serial Tab*/
		
		w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
		doDisplayMessage('SKU Not Found', "SKU: '" + lsSKU + "' not found on Pick List for this Pallet/CARTON." )
		Return -1
			
	End If
				
End If

w_do.ib_Changed = True

Return 0
end function

public function integer uf_do_scan_lmc (string asbarcode);

//LMC is scanning entire barcode which Consists of SKU, Qty, Lot, SN, Exp DT. Need to parse and validate


String	lsPackConfig, lsLMAPrefix, lsProdCode, lsSKU, lsUOM1, lsUOM2, lsUOM3, lsUOM4, lsLot, lsSerial, lsExpDate, lsCOO, lsPackUOM,lsFind
Long		llQty2, llQty3, llQty4, llPAckQty, llPickedQty, llNewRow, llDetailFindRow,llPackingRow,llFindRow, llCartonQty, llScannedQty, llPickLineItemNo, llPackLineItemNo



//Check for a (Packing) Carton Scan first - will update all rows with Packing carton number until another one is scanned
lsFind = " Upper(carton_no) = '" + Upper(asbarcode) + "'"
llFindRow = w_do.idw_pack.Find(lsFind,1,w_do.idw_pack.RowCount())
If llFindRow > 0 Then
	llPackingRow = llFindRow
	w_do.Tab_main.tabpage_serial.sle_carton_no.text = w_do.idw_pack.GetITemString(llFindRow,'carton_no')
	w_do.Tab_main.tabpage_serial.st_message.text = "PACKING CARTON NUMBER Scanned. Please scan a package barcode."
	w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))
	w_do.isCurrentPackCartonId = trim(Upper(asbarcode))
	Return 0
End If

//If we haven't scanned a carton at this point, we have an error
If w_do.isCurrentPackCartonId = '' or isnull(w_do.isCurrentPackCartonId) then
	doDisplayMessage('Pack Scan',"Packing Carton number must be scanned/entered before scanning a package barcode.")
	Return -1
End If

//Parse out The Barcode...

// Must be 32 or 34 characters depending on on type (RE-usable of Single Use)
If Len(asBarcode) = 32 or Len(asBarcode) = 34 Then
Else
	doDisplayMessage('Pack Scan',"Invalid Barcode Length (" + string(len(asBarcode)) + "). Must be 32 for Single Use and 34 for Re-usable parts.")
	Return -1
End If

//First 2 characters must be '01' (AI for GTIN)
If Left(asBarcode,2) <> '01' Then
	doDisplayMessage('Pack Scan',"Invalid Barcode (Must begin with '01')")
	Return -1
End If


//PAcking Configuration (will be validated against Item Master below) - Convert to the SIMS UOM so we can maintain meaningfull UOM's in SIMS
lsPAckConfig = Mid(asBarcode,3,1)

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
		doDisplayMessage('Pack Scan',"Invalid Pack Configuration (" + lsPAckConfig + ")")
		Return -1
End Choose

//LMA Prefix - Must always be "506011231"
lsLMAPRefix = Mid(asBarcode,4,9)

If lsLMAPrefix <> "506011231" Then
	doDisplayMessage('Pack Scan',"Invalid LMA Prefix (Must equal '506011231')")
	Return -1
End If

//3 digit product code registered with GS1 (SIMS Alternate SKU)
lsProdCode = Mid(asBarcode,13,3)

//Validate SKU - We will also be validating UOM's and Qty below

Select SKU, uom_1, uom_2, uom_3, uom_4,  Qty_2, Qty_3, Qty_4, Country_of_origin_Default
into :lsSKU, :lsUOM1, :lsUOM2, :lsUOM3, :lsUOM4,  :llQty2, :llQty3, :llQty4, :lsCOO
From Item_MAster where project_id = 'LMC' and Alternate_SKU = :lsProdCode and Supp_Code = 'LMC';

If lsSKU = '' Then
	doDisplayMessage('Pack Scan',"Invalid Product Identification Code (Alt SKU '" + lsProdCode + "' Not found)")
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
	doDisplayMessage('Pack Scan',"Pack Configuration '" + lsPAckUOM + "' Not configured for this Item (" + lsSKU + ")")
	Return -1
End If

If llPAckQty = 0 Then
	doDisplayMessage('Pack Scan',"No Qty in Item Master (" + lsSKU + ") for this Pack Configuration (" + lsPAckUOM + ")")
	Return -1
End If

//Lot NUmber - make sure it has a valid Luhn Algorithm check digit
If Mid(asBarcode,17,2) = '10' Then /* AI for Lot # */

	lsLot = Mid(asBarcode,19,6)
	
	If not w_do.iuo_check_digit_validations.uf_validate_luhn(lsLot) Then
		doDisplayMessage('Pack Scan',"Invalid Lot Number (" + lsLot + ").")
		Return -1
	End IF
	
Else /* No idenetifier for Lot */
	
	doDisplayMessage('Pack Scan',"No Application Identifier (AI) for Lot Number (required field).")
	Return -1
	
End If

//Next (last) field is either a Serial Number (starting for pack config) for a reusible product or an Expiration Date for a single use
If Mid(asBarcode,25,2) = '21' Then /* AI for Serial */
	
	lsSerial = Mid(asBarcode,27,8)
	lsExpDate = ''
	
	//Validate Check Digit for SN
	If not w_do.iuo_check_digit_validations.uf_validate_luhn(lsSerial) Then
		doDisplayMessage('Pack Scan',"Invalid Serial Number (" + lsSerial + ").")
		Return -1
	End IF
	
ElseIf Mid(asBarcode,25,2) = '17' Then /* AI for Exp DT */
	
	lsExpDate = Mid(asBarcode,27,6) /* YYMMDD */
	lsSerial = ''
	
Else /* Invalid AI */
	
	doDisplayMessage('Pack Scan',"No Application Identifier (AI) for Serial Number or Expiration Date.")
	Return -1
	
End If


//Make sure this SKU/Lot/Exp DT (if applicable) was picked

lsFind = "Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Lot_no) = '" + Upper(lsLot) + "'"

If lsExpDate > "" Then
	lsExpDate = Mid(lsExpDate,3,2) + "/" + Right(lsExpDate,2) + "/20" + Left(lsExpDate,2)
	lsFind += " and expiration_date = Date('" + String(Date(lsExpDate)) + "')"
End If

llDetailFindRow = w_do.idw_Pick.Find(lsFind,1,w_do.idw_Pick.RowCount())

If llDetailFindRow <=0 Then /* No Pick row */
	doDisplayMessage('Pack Scan',"Picking Record not found for SKU/Lot/Exp Date '" + lsSKU + "/" + lsLot + "/" + lsExpDate + "'")
	Return -1
End If

llPickLineItemNo = w_do.idw_Pick.getITemNumber(llDetailFindRow,'line_item_no')

//Make Sure this SKU is packed in the scanned carton
lsFind = "Upper(carton_No) = '" + Upper(w_do.isCurrentPackCartonId) + "' and Upper(SKU) = '" + upper(lsSKU) + "'"
llFindRow = w_do.idw_Pack.Find(lsFind,1,w_do.idw_Pack.RowCount())

If llFindRow <=0 Then /* No Pack row */
	doDisplayMessage('Pack Scan',"SKU '" + LsSKU + "' Not found in carton '" + w_do.isCurrentPackCartonId + "'")
	Return -1
End If

llPAckLineItemNo = w_do.idw_Pack.GetItemNumber(lLFindRow,'line_item_no')

//Make sure we haven't scanned more than is packed in the Carton
	
//Sum all Qty for Carton/SKU -in Serial Tab
lsFind = " Upper(carton_no) = '" + Upper(w_do.isCurrentPackCartonId) + "' and Upper(sku) = '" + Upper(lsSKU) + "'"
llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
	
llScannedQty = 0
Do While llFindRow > 0
		
	llScannedQty += w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(llFindRow,'Quantity')
		
	If llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.RowCount() Then
		llFindRow = 0
	Else
		llFindRow ++
		llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,llFindRow,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
	End If
Loop
	
//Sum all Qty for Carton/SKU in pACking Tab
llCartonQty = 0

llFindRow = w_do.idw_pack.Find(lsFind,1,w_do.idw_pack.RowCount())

Do While llFindRow > 0
	
	llCartonQty += w_do.idw_pack.GetItemNumber(llFindRow,'Quantity')
	
	If llFindRow = w_do.idw_pack.RowCount() Then
		llFindRow = 0
	Else
		llFindRow ++
		llFindRow = w_do.idw_pack.Find(lsFind,llFindRow,w_do.idw_pack.RowCount())
	End If
Loop


If  llPackQty + llScannedQty > llCartonQty Then
	doDisplayMessage('Serial Numbers',"Existing scanned Qty (" + String(llScannedQty) + ") + current package Qty (" + String(llPAckQty) + ") is greater than Carton Qty from Packing List (" + String(llCartonQty) + "). Please scan the next carton.")
	return -1
End IF

//We also want to make sure that we don't scan more of a Lot than exists on the Pick List

//Sum all Qty for SKU/Lot (MAC_ID) -in Serial Tab
lsFind = " Upper(MAC_ID) = '" + Upper(lsLot) + "' and Upper(sku) = '" + Upper(lsSKU) + "'"
llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
	
llScannedQty = 0
Do While llFindRow > 0
		
	llScannedQty += w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(llFindRow,'Quantity')
		
	If llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.RowCount() Then
		llFindRow = 0
	Else
		llFindRow ++
		llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,llFindRow,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
	End If
	
Loop

//Sum all Qty for SKU/Lot in Picking Tab
llPickedQty = 0 

lsFind = " Upper(LOT_NO) = '" + Upper(lsLot) + "' and Upper(sku) = '" + Upper(lsSKU) + "'"
llFindRow = w_do.idw_pick.Find(lsFind,1,w_do.idw_pick.RowCount())

Do While llFindRow > 0
	
	llPickedQty += w_do.idw_pick.GetItemNumber(llFindRow,'Quantity') /*Picked Qty */
	
	If llFindRow = w_do.idw_pick.RowCount() Then
		llFindRow = 0
	Else
		llFindRow ++
		llFindRow = w_do.idw_pick.Find(lsFind,llFindRow,w_do.idw_pick.RowCount())
	End If
Loop


If  llPackQty + llScannedQty > llPickedQty Then 
	doDisplayMessage('Serial Numbers',"Existing scanned Qty (" + String(llScannedQty) + ") + current package Qty (" + String(llPAckQty) + ") is greater than Picked Qty from Picking List for this LOT NUMBER (" + String(llPickedQty) + "). Please scan the next LOT NUMBER.")
	return -1
End IF


	
//If no serial, add/update a generic row for this sku/lot with Serial = 'N/A' - we still need the total Qty scanned
//Otherwise, set the serial # on an empty row
If lsSerial = '' Then
	
	lsFind = " Upper(Carton_no) = '" + Upper(w_do.isCurrentPackCartonId) + "' and Upper(sku) = '" + Upper(lsSKU) + "' and Left(Serial_no,3) = 'N/A' and Upper(mac_id) = '" + Upper(lsLot) + "'"
	llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount() + 1) 
	
	If llFindRow > 0 Then /* add scanned Qty to existing Qty */

		w_do.Tab_main.tabpage_serial.dw_serial.SetRow(llFindRow)
		w_do.Tab_main.tabpage_serial.dw_serial.ScrolltoRow(llFindRow)
		w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'quantity',w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(llFindRow,'Quantity') + llPackQty)
		w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'mac_id',lsLot) /* storing Lot number in MAC ID so we can xref lot to carton */
		
	Else /* find first empty row for SKU*/
		
		//Find the first empty row for this Carton/SKU and populate Serial and Qty
		//05/09 - PCONKL - Added line item (captured above) so we can allocate it the scan to the correct line item
		lsFind = " Upper(sku) = '" + Upper(lsSKU) + "' and isnull(serial_no) and line_item_no = " + String(llPickLineitemNo) 
		llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount() + 1) 
		If llFindRow > 0 Then
			
			w_do.Tab_main.tabpage_serial.dw_serial.SetRow(llFindRow)
			w_do.Tab_main.tabpage_serial.dw_serial.ScrolltoRow(llFindRow)
			w_do.Tab_main.tabpage_serial.dw_serial.SetColumn('serial_no')
			w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'Serial_no','N/A-' + lsProdCode + '-' + lsLot + '-' + Right(w_do.isCurrentPackCartonId,3))
			w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'carton_no',w_do.isCurrentPackCartonId)
			w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'quantity',llPackQty)
			w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'mac_id',lsLot) /* storing Lot number in MAC ID so we can xref lot to carton */
			w_do.Tab_main.tabpage_serial.st_message.Text = "Package Barcode scanned."
			
		Else /*all rows for this SKU have been entered - 05/09 - PCONKL - Add a new row - we only generated 1 row per pick row, not per qty*/
			
			//	doDisplayMessage('Serial Numbers',"All Serial Numbers for this SKU have been entered.")
			//	w_do.Tab_main.tabpage_serial.st_message.Text = "Please scan a package barcode."
			
			//Find an existing for Line/SKU and Copy to new
			lsFind = " Upper(sku) = '" + Upper(lsSKU) + "' and line_item_no = " + String(llPickLineitemNo) 
			llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount() + 1) 
			If llFindRow > 0 Then
			
				w_do.tab_main.tabpage_serial.dw_serial.RowsCopy(llFindRow,llFindRow,Primary!, w_do.tab_main.tabpage_serial.dw_serial,9999999,primary!) /*add at end*/
				w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(w_do.tab_main.tabpage_serial.dw_serial.RowCount())
				w_do.Tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'Serial_no','N/A-' + lsProdCode + '-' + lsLot + '-' + Right(w_do.isCurrentPackCartonId,3))
				w_do.Tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'carton_no',w_do.isCurrentPackCartonId)
				w_do.Tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'quantity',llPackQty)
				w_do.Tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'mac_id',lsLot) /* storing Lot number in MAC ID so we can xref lot to carton */
				w_do.Tab_main.tabpage_serial.st_message.Text = "Package Barcode scanned."
			
			End If
			
			
		End If
	
	End If
	
Else /*Serialized */
		
	//Find the first empty row for this Carton/SKU and populate Serial and Qty
	//05/09 - PCONKL - Added line item (captured above) so we can allocate it the scan to the correct line item
	lsFind = " Upper(sku) = '" + Upper(lsSKU) + "' and isnull(serial_no) and line_item_no = " + String(llPickLineitemNo)
	llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount() + 1) 

	If llFindRow > 0 Then
		
		w_do.Tab_main.tabpage_serial.dw_serial.SetRow(llFindRow)
		w_do.Tab_main.tabpage_serial.dw_serial.ScrolltoRow(llFindRow)
		w_do.Tab_main.tabpage_serial.dw_serial.SetColumn('serial_no')
		w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'Serial_no',lsSerial)
		w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'carton_no',w_do.isCurrentPackCartonId)
		w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'quantity',llPackQty)
		w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'mac_id',lsLot) /* storing Lot number in MAC ID so we can xref lot to carton */
		w_do.Tab_main.tabpage_serial.st_message.Text = "Package Barcode scanned."
		
	Else /*all rows for this SKU have been entered - 05/09 - PCONKL - Add a new row - we only generated 1 row per pick row, not per qty*/
		
		//doDisplayMessage('Serial Numbers',"All Serial Numbers for this SKU have been entered. ")
		//w_do.Tab_main.tabpage_serial.st_message.Text = "Please scan a package barcode."
		
		//Find an existing for Line/SKU and Copy to new
		lsFind = " Upper(sku) = '" + Upper(lsSKU) + "' and line_item_no = " + String(llPickLineitemNo) 
		llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount() + 1) 
		If llFindRow > 0 Then
			
			w_do.tab_main.tabpage_serial.dw_serial.RowsCopy(llFindRow,llFindRow,Primary!, w_do.tab_main.tabpage_serial.dw_serial,9999999,primary!) /*add at end*/
			w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(w_do.tab_main.tabpage_serial.dw_serial.RowCount())
			w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'Serial_no',lsSerial)
			w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'carton_no',w_do.isCurrentPackCartonId)
			w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'quantity',llPackQty)
			w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'mac_id',lsLot) /* storing Lot number in MAC ID so we can xref lot to carton */
			w_do.Tab_main.tabpage_serial.st_message.Text = "Package Barcode scanned."
			
		End If
				
	End If
	
End If /*serialized? */

w_do.Tab_main.tabpage_serial.st_message.Text = "Please scan a package barcode."
w_do.ib_changed = True

Return 0
end function

public function integer uf_do_scan_comcast (string assku, string asscan, long alrow);
//Process DO scans for Comcast

String	lsScan, lsSKU, lsFind, lsPallet, lsCarton
Long		llFindRow, llPalletQty, llCartonQty, llScanQty

//See if we scanned a Pallet
lsScan = asScan

Select Min(SKU), Count(*) into :lsSKU, :llPalletQty 
From Carton_Serial
Where Project_id = 'COMCAST' and Pallet_id = :lsScan;

If lsSku > '' Then /*Pallet Exists*/

	//Make sure this pallet is what was actually picked
	llFindRow = w_do.idw_Pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Lot_No) = '" + Upper(lsScan) + "'",1, w_do.idw_Pick.RowCount())
	If llFindRow <= 0 Then	
		
		Messagebox('Pallet Scanned', "Pallet ID not found on Pick List.~r~nPlease correct Pick List and re-scan." )
		Return -1
		
	Else /* make sure a full pallet was picked, otherwise,they need to be scanning Cartons */
		
		If w_do.idw_Pick.GetITemNumber(llFindRow,'quantity') <> llPalletQty Then
			
			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
			Messagebox('Pallet Scanned', "Pallet ID: '" + lsScan + "' was not picked in it's entirety.~r~nCarton ID's must be scanned for this Pallet." )
			Return -1
			
		End If 
		
	End If /*Pallet not found on Picking List*/

	lsPallet = lsScan
	llScanQty = llPalletQty /*Pallet Qty will be set on Serial record for validating at confirmation that all were entered*/
		
Else /* Not a pallet, see if we scanned a carton*/

	Select Min(SKU), Min(Pallet_id), Count(*) into :lsSKU, :lsPallet, :llCartonQty
	From Carton_Serial
	Where Project_id = 'COMCAST' and Carton_id = :lsScan;

	If lsPallet > '' Then /*carton Exists */
	
		//Make sure this pallet is what was actually picked
		llFindRow = w_do.idw_Pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Lot_No) = '" + Upper(lsPallet) + "'",1, w_do.idw_Pick.RowCount()) 
		If llFindRow = 0 Then
			
			MessageBox('Carton Scanned', "Pallet ID: '" + lsPallet + "' not found on Pick List for this CARTON.~r~nPlease correct Pick List and re-scan." )
			Return -1
		
		Else /* Make sure we haven't already scanned a pallet that this caarton is contained in */
			
			If w_do.tab_main.tabpage_serial.dw_serial.find("Serial_No = '" + lsPallet + "'",1,w_do.tab_main.tabpage_serial.dw_serial.RowCount()) > 0 Then
				
				w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
				Messagebox('Carton Scanned', "Pallet ID: '" + lsPallet + "' has already been scanned for this CARTON." )
				Return -1
		
			End IF
			
		End If /*Pallet not found on Picking List*/
		
		llScanQty = llCartonQty /*Carton Qty will be set on Serial record for validating at confirmation that all were entered*/
		w_do.tab_main.tabpage_serial.st_message.Text = "CARTON Scanned."
	
	Else /* Not a Pallet or Carton Scan */
						
		w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
		Messagebox('Invalid Scan', "Serial Number information for this Pallet/Carton has not been received from Comcast.~r~nUnable to process Pallet." )
		Return -1
		
	End If
	
End If

If asSKU <> lsSKU Then
	Messagebox('Invalid SCAN', 'Pallet/Carton ID is not associated with this SKU.')
	return -1
End If

//Set the scanned Qty on the updated row
w_do.tab_main.tabpage_serial.dw_serial.SetITem(alRow,'Quantity',llScanQty)

w_do.ib_Changed = True

Return 0
end function

public function integer uf_do_scan_puma (string asbarcode);String	lsFind, lsBarcode, lsSKU,lsQty //23-Apr-2015 Madhu- Added lsQty
Long		llFindROw, llLineItemNo,llFindRecord //16-Jul-2013 :Madhu -added llLineItemNo
Decimal	ldExpQty ,ldQty,ldActualQty,ldSumQty,ldScannedQty  //16-Jul-2013 :Madhu -added ldScannedQty
Int		i,li_row //16-Jul-2013 :Madhu -added li_row
Boolean lbCartonScan =FALSE //23-Apr-2015 Madhu- PUMA- Scan Carton Barcode

//If we haven't scanned a carton at this point, we have an error
If w_do.isCurrentPackCartonId = '' or isnull(w_do.isCurrentPackCartonId) then
	doDisplayMessage('Pack Scan',"Packing Carton number must be scanned/entered before scanning an EAN barcode.")
	Return -1
End If

//23-Apr-2015 Madhu- PUMA- Scan Carton Barcode -START
IF  len(asBarcode) > 30 THEN
	lsbarcode = Mid( asBarcode,16,13) //Get UPC code from 16-28
	lsQty=Mid(asBarcode, 29,3) //Get Qty from 29-31
	lbCartonScan =TRUE
	w_do.tab_main.tabpage_Serial.sle_scan_Qty.text =lsQty
ELSEIF  len(asBarcode) =17 THEN //Barcode is 17 digit char long
	
	//check whether SKU is scanned (sku may be 17 digit)
	lsFind = " Upper(SKU) = '" + asBarcode + "'"
	llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
	
	IF llFindRow > 0 THEN
		lsbarcode = asBarcode
		w_do.tab_main.tabpage_Serial.sle_scan_Qty.text ='1'
		lbCartonScan =FALSE 
	ELSE
		lsbarcode = left( asBarcode,13) //Get UPC code from 1-13
		lsQty=Mid(asBarcode, 14,4) //Get Qty from 29-31
		lbCartonScan =TRUE
		w_do.tab_main.tabpage_Serial.sle_scan_Qty.text =lsQty
	END IF
ELSE //23-Apr-2015 Madhu- PUMA- Scan Carton Barcode -END
	lsbarcode = asBarcode
	w_do.tab_main.tabpage_Serial.sle_scan_Qty.text ='1' //23-Apr-2015 Madhu- PUMA- Scan Carton Barcode -START
	lbCartonScan =FALSE 
END IF //23-Apr-2015 Madhu- PUMA- Scan Carton Barcode -END

// Always check to see if a SKU has been scanned. They are scanning EAN. Do a find based on EAN, not SKU. - Allow lookup on both...

//If he barcode is not numeric, it can't be an EAN code

If isnumber(lsBarcode) then
	lsFind = " part_upc_Code = " + lsbarcode 
	llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
Else
	lsFind = " Upper(SKU) = '" + lsbarcode + "'"
	llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
End If

// Always check to see if a SKU has been scanned (if we were not successfull with a UPC scan)
If llFindRow = 0 Then
	lsFind = " Upper(sku) = '" + Upper(lsbarcode) + "'"
	llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
End If

If llFindRow > 0 Then /* a SKU was scanned*/
		
	lsBarcode = w_do.Tab_main.tabpage_serial.dw_serial.GetITemString(llFindRow,'sku') /*map EAN back to SKU */
	
	//16-Jul-2013 :Madhu -Added code to get LineItemNo &Alloc_Qty of sku from DD -START
	//Always set Expected_Qty as DD.alloc_Qty
	lsFind = " Upper(sku) = '" + Upper(lsBarcode) + "'"
	llLineItemNo =w_do.Tab_main.tabpage_detail.dw_detail.Find(lsFind,1,w_do.Tab_main.tabpage_detail.dw_detail.RowCount())
	ldExpQty = w_do.tab_main.tabpage_detail.dw_detail.GetItemNumber(llLineItemNo,'alloc_qty')
	w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'expected_qty',w_do.tab_main.tabpage_detail.dw_detail.GetItemNumber(llLineItemNo,'alloc_qty')) 
	//16-Jul-2013 :Madhu -Added code to get LineItemNo &Alloc_Qty of sku from DD -END
	
	//12-May-2015 :Madhu- Added code to get current row Qty to validate Over Packing/Scanning -START
	For li_row =1 to w_do.Tab_main.tabpage_serial.dw_serial.RowCount()
		If w_do.Tab_main.tabpage_serial.dw_serial.GetitemString(li_row,'sku') = lsBarcode then
			ldActualQty =ldActualQty + w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(li_row,'quantity')
		end if
	NEXT

//	ldActualQty = w_do.tab_main.tabpage_serial.dw_serial.getItemNumber(llFindRow,'quantity')
	ldSumQty = ldActualQty + long(w_do.tab_main.tabpage_Serial.sle_scan_Qty.text)
	
	//12-May-2015 :Madhu- Added code to get current row Qty to validate Over Packing/Scanning -END	
	
	w_do.ibSkuScanned = True
	w_do.isCurrentSKU = lsBarcode
	
	lsFind = " Upper(sku) = '" + Upper(lsbarcode) + "' and isnull(serial_no) and (serialized_ind = 'O' or serialized_ind = 'B') " 
	llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount() + 1) 
	If llFindRow > 0 Then /*Serialized part*/
		
		w_do.Tab_main.tabpage_serial.dw_serial.SetRow(llFindRow)
		w_do.Tab_main.tabpage_serial.dw_serial.ScrolltoRow(llFindRow)
		w_do.Tab_main.tabpage_serial.dw_serial.SetColumn('serial_no')
		llLineItemNo = w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(llFindRow,'Line_Item_no')
		w_do.Tab_main.tabpage_serial.st_message.Text = "SKU/EAN Scanned. Please scan the Serial Number."
		
	Else /* Non serialized part or all scanned */
		
		// 11/09 - PCONKL - If we are scanning all items (pack validation), we will be adding to an existing record for non serialized parts. We dont need to have an empty serial number record, just an existing SKU record
		If g.ibCartonSerialvalidationRequired Then
			
			
			//If we already have a record for this sku/carton, bump up the Qty
			lsFind = "Upper(sku) = '" + Upper(w_do.isCurrentSku) + "' and Upper(carton_no) = '" + Upper(w_do.Tab_main.tabpage_serial.sle_carton_no.text) + "' and (serialized_ind = 'N' or serialized_ind = 'Y') "
			//lsFind += " and quantity < expected_qty " //12-May-2015 :Madhu- commented - to validate Over Scanning
			lsFind += " and " +  String(ldSumQty) +" <=  expected_qty" //12-May-2015 :Madhu -Added -to validate Over Scanning
			llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
			
			//If Not found, see if we have a record for the sku where we havent assigned a carton number yet.
			If llFindRow = 0 then
				lsFind = "Upper(sku) = '" + Upper(w_do.isCurrentSku) + "' and (Upper(carton_no) = '' or isnull(carton_no)) and (serialized_ind = 'N' or serialized_ind = 'Y')" 
				//lsFind += " and quantity < expected_qty " //12-May-2015 :MAdhu - commented -to validate Over Scanning
				lsFind += " and " +  String(ldSumQty) +" <=  expected_qty" //12-May-2015 :Madhu -Added -to validate Over Scanning
				llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
			End If
			
			//If not found see if we have a row for this SKU that we can copy to a new row for a new carton
			If llFindRow = 0 then
				
				//15-Jun-2015 :Madhu- Added code to get sum(scanned qty) against same SKU with multiple cartons. - START
				For li_row =1 to w_do.Tab_main.tabpage_serial.dw_serial.RowCount()
					If w_do.Tab_main.tabpage_serial.dw_serial.GetitemString(li_row,'sku') = Upper(w_do.isCurrentSku) then
						ldScannedQty =ldScannedQty + w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(li_row,'quantity')
					end if
				NEXT
				
				ldSumQty = ldScannedQty +  long(w_do.tab_main.tabpage_Serial.sle_scan_Qty.text) //override the ldSumQty value
				//15-Jun-2015 :Madhu- Added code to get sum(scanned qty) against same SKU. - END
				
				lsFind = "Upper(sku) = '" + Upper(w_do.isCurrentSku) + "' and (serialized_ind = 'N' or serialized_ind = 'Y')"
				//lsFind += " and quantity < expected_qty " //12-May-2015 :Madhu - commented -to validate Over Scanning
				lsFind += " and " +  String(ldSumQty) +" <=  expected_qty" //12-May-2015 :Madhu -Added -to validate Over Scanning
				llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
				
				If llFindRow > 0 Then
					
					lsSKU = w_do.Tab_main.tabpage_serial.dw_serial.getITemString(llFindRow ,'sku')
					w_do.Tab_main.tabpage_serial.dw_serial.RowsCopy(llFindRow,llFindRow,PRimary!,w_do.Tab_main.tabpage_serial.dw_serial,99999999999, Primary!)
					llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.RowCount()
					w_do.Tab_main.tabpage_serial.dw_serial.SetITem(llFindRow,'quantity',0)
					
					//IF adding a new row, set all the thers to fully processed and the new row to be the remainder
					//ldExpQty = 0  //16-Jul-2013 :Madhu commented
					For i = 1 to (llFindRow - 1)
						If w_do.Tab_main.tabpage_serial.dw_serial.GetitemString(i,'sku') = lsSKU Then
							//ldExpQty += w_do.Tab_main.tabpage_serial.dw_serial.GetitemNumber(i,'expected_qty') - w_do.Tab_main.tabpage_serial.dw_serial.GetitemNumber(i,'quantity') //16-Jul-2013 :Madhu commented
							//w_do.Tab_main.tabpage_serial.dw_serial.SetITem(i,'expected_qty',w_do.Tab_main.tabpage_serial.dw_serial.GetitemNumber(i,'quantity')) //16-Jul-2013 :Madhu commented
							ldQty  = ldQty + w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(i,'quantity') //16-Jul-2013 :Madhu  - Do the sum(qty) of same sku
						End If
					Next

					//16-Jul-2013 :Madhu - Compare the sum(qty) with exp_qty of same sku -START
					//w_do.Tab_main.tabpage_serial.dw_serial.SetITem(llFindRow,'expected_qty',ldExpQty) //16-Jul-2013 :Madhu -commented to don't set as expected qty
					IF  (ldQty =  ldExpQty) THEN
						doDisplayMessage('Serial Numbers',"All Serial Numbers for this SKU/EAN have been entered or all non serialized parts have been scanned for this SKU/EAN.")
						w_do.ibSKUScanned = False
						w_do.Tab_main.tabpage_serial.st_message.Text = "Scan a SKU."
					END IF
					//16-Jul-2013 :Madhu - Compare the sum(qty) with exp_qty of same sku -END
					
				End If
						
			End If
						
			If lLFindRow > 0 Then
				
				//16-Jul-2013 :Madhu - added code to do sum(qty) of same sku -START
				ldQty = 0
				lsSKU = w_do.Tab_main.tabpage_serial.dw_serial.getITemString(llFindRow ,'sku')

				For i = 1 to llFindRow
					If w_do.Tab_main.tabpage_serial.dw_serial.GetitemString(i,'sku') = lsSKU Then
						ldQty  = ldQty + w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(i,'quantity')
					End If
				Next
				
				IF  (ldQty =  ldExpQty) THEN
					doDisplayMessage('Serial Numbers',"All Serial Numbers for this SKU/EAN have been entered or all non serialized parts have been scanned for this SKU/EAN.")
					w_do.ibSKUScanned = False
					w_do.Tab_main.tabpage_serial.st_message.Text = "Scan a SKU."
				ELSE
				//16-Jul-2013 :Madhu -Added code to do sum(qty) of same sku -END
		
				w_do.Tab_main.tabpage_serial.dw_serial.SetRow(llFindRow)
				w_do.Tab_main.tabpage_serial.dw_serial.ScrolltoRow(llFindRow)
				
				//23-Apr-2015 Madhu- PUMA- Scan Carton Barcode -START
				IF lbCartonScan THEN
					w_do.Tab_main.tabpage_serial.dw_serial.SetITem(llFindRow,'quantity',w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(llFindRow,'quantity') + long(lsQty))
				ELSE //23-Apr-2015 Madhu- PUMA- Scan Carton Barcode -END
					w_do.Tab_main.tabpage_serial.dw_serial.SetITem(llFindRow,'quantity',w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(llFindRow,'quantity') + 1)
				END IF //23-Apr-2015 Madhu- PUMA- Scan Carton Barcode -Added
	
				w_do.Tab_main.tabpage_serial.dw_serial.SetITem(llFindRow,'carton_no',w_do.Tab_main.tabpage_serial.sle_carton_no.text)
				w_do.Tab_main.tabpage_serial.dw_serial.SetITem(llFindRow,'serial_no',"N/A-" + w_do.Tab_main.tabpage_serial.sle_carton_no.text)
						
				w_do.ibSKUScanned = False
				w_do.ib_CHanged = True
				w_do.Tab_main.tabpage_serial.sle_barcodes.Text = ""
				w_do.Tab_main.tabpage_serial.st_message.Text = "Non Serialized SKU/EAN scanned. Scan the next SKU/EAN."
				END IF  //16-Jul-2013 :Madhu -added
			Else
				
				doDisplayMessage('Serial Numbers',"All Serial Numbers for this SKU/EAN have been entered or all non serialized parts have been scanned for this SKU/EAN.")
				w_do.ibSKUScanned = False
				w_do.Tab_main.tabpage_serial.st_message.Text = "Scan a SKU."
			
			End If
	
		End If
				
	End If
	
Else /*sku not found, must be a serial scan*/
	
	If w_do.ibskuscanned Then /*sku already scanned, it's a serial # */
				
		//Check for Duplicates
		lsFind = "Upper(sku) = '" + Upper(w_do.isCurrentSku) + "' and Upper(serial_no) = '" + Upper(lsBarcode) + "'"
		If w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount()) > 0 Then
			// pvh 03/02/06 - smartcode 
			doDisplayMessage("Duplicates found","This Serial Number has already been scanned for this SKU/EAN")
			w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))
			Return -1
		End If
		
		//Set the entered barcode to the first empty serial # for the current SKU
		// 11/09 - PCONKL - If scanning all (pack validation) and this is a non serialized product, we just need the first available row for sku and carton
		
		lsFind = "Upper(sku) = '" + Upper(w_do.isCurrentSKU) + "' and isnull(serial_no)"
		llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount() + 1)
		
		If llFindRow > 0 Then
			
			w_do.Tab_main.tabpage_serial.dw_serial.SetRow(llFindRow)
			w_do.Tab_main.tabpage_serial.dw_serial.ScrolltoRow(llFindRow)
			w_do.Tab_main.tabpage_serial.dw_serial.SetITem(llFindRow,'serial_no',w_do.Tab_main.tabpage_serial.sle_barcodes.Text)
			w_do.Tab_main.tabpage_serial.dw_serial.SetITem(llFindRow,'quantity',1)
			w_do.ib_CHanged = True
				
			
			// 10/03 - PCONKL - add carton number if scanned
			If w_do.Tab_main.tabpage_serial.sle_carton_no.text > '' Then
				w_do.Tab_main.tabpage_serial.dw_serial.SetITem(llFindRow,'carton_no',w_do.Tab_main.tabpage_serial.sle_carton_no.text)
			End If
			
			w_do.ib_changed = True
			w_do.ilUndoRow = llFindRow /*so we can undo last scan if desired*/
			w_do.Tab_main.tabpage_serial.cb_undo.Enabled = True
						
		Else
				doDisplayMessage('Serial Numbers',"All Serial Numbers for this SKU (and Supplier/Line Item if carton number entered) have been entered.~rIf you need to update a serial number, switch to manual mode.")
				w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))
				Return -1
	
		End If
		
		
		w_do.Tab_main.tabpage_serial.st_message.Text = "Serial Number Entered, Please scan the next SKU or another Serial # for this SKU."
				
	Else /*sku not already scanned - error*/
		
		doDisplayMessage( "Validation Error","SKU/EAN Not found. Please scan a SKU/EAN.")
		w_do.Tab_main.tabpage_serial.cb_undo.Enabled = False
		
	End If /*Sku already scanned*/
	
End If /*sku found in barcode*/

Return 0
end function

public function integer uf_do_scan_physio (string asbarcode);String  lsSerial, lsExpDate, lsCOO, lsFind, lsDONO, lsSupplier, lsOwner, lsNative, lsExpCont, lsSerCont, lsLotCont, lsPOCont, ls_wh_code
String	  lsUPN, lsDescript, lsLot, lsExpiry, lsSKU, lsPO_NO, lsPO_NO2, lsExpiryNew, lsLotNew, lsSNNew, lsExpDT, ls_std_measure, ls_std_Measure_w
Long		llSKUCount, llFindRow, llScannedQty, llPickLineItemNo, llDetailQty, llPickUpdateQty, llPickFindRow
Boolean	lbNewRow, lbSKU
Decimal	ld_length, ld_width, ld_height, ld_weight

long lQty, ll_row, ll_id_no
int iZeroCount = 0

lsUPN =  ""
lsLot = ""
lsSerial = ""
lsExpiry = ""
lQty = 0

if asbarcode = "" then  //don't whinge to the user about the scan being invalid when s(he) simply changed fields and never entered anything
	return 0
end if

lsFind = "Upper(sku) = Upper('" + asbarcode + "')"  //have to determine if this is a sku or an integrated barcode; try to find it on the order detail
ll_row = w_do.idw_detail.Find(lsFind, 0, w_do.idw_detail.RowCount())
if ll_row > 0 then //it's on the order detail, so it's a sku; read the other information that an integrated barcode would have had

	lbSKU = true
	lsSKU = asbarcode
	
	
	llFindRow = w_do.idw_pick.Find(lsFind, 0, w_do.idw_pick.RowCount())
	//llPickLineitemNo = llFindRow
	llPickLineItemNo = w_do.idw_pick.GetITemNumber(llFindRow,'line_item_No')
	lsExpiry = w_do.idw_pick.GetItemString(llFindRow, 'expiration_date')
	lsLot = w_do.idw_pick.GetItemString(llFindRow, 'lot_no')	
	lsSerial = w_do.idw_pick.GetItemString(llFindRow, 'serial_no')	
	lsSupplier = w_do.idw_pick.GetITemString(llFindRow,'supp_code') /* 01/14*/
	
elseif left(asbarcode, 2) = "01" then //hdc 10/15/2012 It's an integrated barcode
	
	lbSKU = false
	asbarcode = Mid(asbarcode, 3, len(asbarcode))  //trim the ident code
	
	do	while Mid(asbarcode, 1, 1) = "0"	//strip leading zeros; the UPN is 12 characters, but might have one or two leading zeros that don't go toward that count; UPN is a numeric field in the database
		asbarcode = Mid(asbarcode, 2, len(asbarcode))
		iZeroCount = iZeroCount + 1
	loop
	
else //not on the order detail and isn't identified as an integrated barcode; tell the user it's rubbish
	
		w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))			
		doDisplayMessage("Serial Scan", "Invalid scan: Not a SKU or integrated barcode")
		return -1
		
end if

lQty = Long(w_do.tab_main.tabpage_serial.sle_scan_qty.text)  //read the quantity field

if lbSKU = false then  //parse out the integrated barcode

	lsUPN = Mid(asbarcode, 1, 14 - iZeroCount )  //hdc 10/12/2012 UPN is always 12 digits
	asbarcode = Mid(asbarcode, 15 - iZeroCount, len(asbarcode)) //hdc 10/12/2012 Remove it from the scan

	if left(asbarcode,2) = "17" then //hdc 10/12/2012 read expiry date
	
		if Mid(asbarcode,3,2) <> "NA" then //hdc 10/12/2012 Scan may include NA for a value which we want to simply skip over
			asbarcode = Mid(asbarcode, 3, len(asbarcode))
			lsExpiry = Mid(asbarcode, 1, 6)
			asbarcode = Mid(asbarcode, 7, len(asbarcode))  //hdc 10/12/2012 remove it from the scan
		else
			asbarcode = Mid(asbarcode, 5, len(asbarcode)) //hdc 10/12/2012 remove it from the scan
		end if
		
	end if

	if left(asbarcode,2) = "10" then  //hdc 10/12/2012 read lot number
		if Mid(asbarcode,3,2) <> "NA" then	
			asbarcode = Mid(asbarcode, 3, len(asbarcode))
			lsLot = asbarcode
		else  
			asbarcode = Mid(asbarcode, 5, len(asbarcode))
		end if
		
	elseif left(asbarcode,2) = "21" then //hdc 10/12/2012 read serial number
		
			if Mid(asbarcode,3,2) <> "NA" then		
					lsSerial = Mid(asbarcode, 3, len(asbarcode))	
					asbarcode = Mid(asbarcode, 5, len(asbarcode))				
					lQty = 1  //hdc 10/12/2012 if it's serialized, by definition, quantity is one
			end if
			
	elseif len(asbarcode) > 0 then //hdc 11/02/2012  There must be a bogus code left over; complain about it
		
		w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))				
		doDisplayMessage("Packing Scan", "Invalid scan: Unrecognized scan prefix " + Mid(asbarcode,1,2)) //kinda sloppy with the case where there's only one remaining char, but PB handles it OK
		return -1		
		
	end if

	//hdc 10/15/2012 - validate that the sku is on this order and that there's a 1:1 relationship between the sku and UPN 
	lsDoNo = w_do.idw_detail.getItemString(1,"do_no")
	select count(*) into :llSKUCOunt from Item_Master 	where Project_Id = :gs_project and Part_UPC_Code=:lsUPN and SKU in &
		(select SKU from Delivery_Detail where Delivery_Detail.DO_No= :lsDoNo ) ;
	
	select upper(SKU), Upper(expiration_controlled_ind), Upper(serialized_ind), Upper(lot_controlled_ind), Upper(po_controlled_ind) &
		into :lsSKU, :lsExpCont, :lsSerCont, :lsLotCont, :lsPOCont from Item_Master &
		where Project_Id = :gs_project and Part_UPC_Code=:lsUPN and SKU in &
		(select SKU from Delivery_Detail where Delivery_Detail.DO_No= :lsDoNo ) group by sku,expiration_controlled_ind, serialized_ind, lot_controlled_ind, po_controlled_ind;
		
	if llSKUCount = 0 then //hdc 10/15/2012 -it's not on this order
	
		w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))	
		doDisplayMessage("Serial Scan", "Invalid scan: That SKU is not in on this order detail")	
		return -1
		
	elseif llSKUCount > 1 then  //hdc 10/15/2012 -not 1:1; prompt them to scan the sku
		
		w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))				
		w_do.tab_main.tabpage_serial.sle_barcodes.SetFocus()				
		doDisplayMessage("Serial Scan", "There is more than one SKU for UPN "+lsUPN+".  Please scan the SKU")	
		return 0
		
	else  //hdc 10/15/2012 - 1:1 relationship; get the rest of the data we need after validating that all the data needed is there
		
		lsFind = "Upper(sku) = Upper('" + lsSKU + "')"  //have to determine if this is a sku or an integrated barcode; try to find it on the order detail
		llFindRow = w_do.idw_detail.Find(lsFind, 0, w_do.idw_detail.RowCount())
		If llFindRow > 0 Then
//			llPickLineitemNo =  llFindRow
			llPickLineItemNo = w_do.idw_Detail.GetITemNumber(llFindRow,'line_item_No')
		End IF

		if lsExpCont = "Y" and lsExpiry="" then
				w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))							
				doDisplayMessage("Packing Scan", "The item is expiry controlled and no expiry date is present in the barcode.")
				return -1
		end if
		
		if lsSerCont = "O" or lsSerCont = "B" then
			
				//	select distinct SN_Chain_of_Custody into :lsSNCOD from Project where project_id = 'PHYSIO-MAA';
								
				if lsSerial = "" then
					w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))							
					doDisplayMessage("Packing Scan", "The item is serial number controlled and no serial number is present in the barcode.")
					return -1				
				elseif g.ibSNChainOfCustody then
					
					select COUNT(*) into :llSKUCount from Serial_Number_Inventory where Project_Id = :gs_project and sku = :lsSKU and Serial_No = :lsSerial;
					
					if llSKUCount < 1 then
						w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))							
						doDisplayMessage("Packing Scan", "Serial number " + lsSerial + " does not appear in inventory")
						return -1									
					end if
					
				end if
				
		end if
		
		if lsLotCont = "Y" and lsLot="" then
				w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))							
				doDisplayMessage("Packing Scan", "The item is lot controlled and no lot is present in the barcode.")
				return -1				
		end if			
		
		select sku, description, native_description, supp_code into :lsSKU, :lsDescript, :lsNative, :lsSupplier from Item_Master where Project_Id = :gs_project and Part_UPC_Code=:lsUPN &
			and SKU in (select SKU from Delivery_Detail where Delivery_Detail.DO_No= :lsDoNo  );  
			
 		if lsLot = "" then
			lsLot = "-"
		end if
		
		if lsSerial = "" then
			lsSerial = "-"
		end if  
			
		
		lsExpDT = Mid(lsExpiry,3,2) + "/" + Mid(lsExpiry,5,2) + "/" + "20" + Mid(lsExpiry,1,2)
		lsFind = "Upper(sku) = '" + upper(lsSKU) + "'  and  date(expiration_date) = Date('" + lsExpDT + "')"	
		llFindRow =  w_do.idw_Pick.Find(lsFind, 1, w_do.idw_Pick.RowCount())
		
		If llFindRow < 1 and lsExpCont = 'Y' Then 
			
			w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))							
			doDisplayMessage("Packing Scan", "The expiry date does not match the picking list.")
			return -1					
				
		end if
		
		//if lsLotNew <> lsLot and lsLotNew<>"" and not isnull(lsLotNew) then
		lsFind = "Upper(sku) = '" + upper(lsSKU) + "' and upper(Lot_no)  = '" + lsLot + "'"
		llFindRow =  w_do.idw_Pick.Find(lsFind, 1, w_do.idw_Pick.RowCount())
		
		If llFindRow < 1 and lsLot > ''  Then
			
			w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))							
			doDisplayMessage("Packing Scan", "The lot does not match the picking list.")
			return -1							
			
		end if		
			
		
		if llSKUCount = 0 then
			w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))							
			doDisplayMessage("Packing Scan", "The item scanned does not match inventory/the picking list.")
			return -1 
		end if
		
	end if 
	
end if 

if lsSerial <> "-" then	  //hdc 10/15/2012 Validate that this item hasn't already been scanned (serialized)

	lsFind = "Upper(sku) = '" + Upper(lsSKU) + "' and Upper(serial_no) = Upper('" + lsSerial + "')"
	llFindRow = w_do.idw_serial.Find(lsFind, 0, w_do.idw_serial.RowCount())
	
	if llFindRow > 0  then
		w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))			
		doDisplayMessage("Serial Scan", "Serial Number: " + lsSerial + " has already been scanned")	
		return -1	
	end if
	
	lsFind = "Upper(sku) = Upper('" + lsSKU + "') and (IsNull(Serial_no) or Serial_No='-')"
	llFindRow = w_do.idw_serial.Find(lsFind, 0, w_do.idw_serial.RowCount()) 
	
	if llFindRow = 0 then
			w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))							
			doDisplayMessage("Packing Scan", "Scans have been completed for sku " + lsSKU)
			return -1					
	end if
	
	//we may have multiple lines for the same SKU, get the one not fully scanned
	lsFind = "Upper(sku) = Upper('" + lsSKU + "')"
	lsFind += " and (isnull(user_field1) or user_field1 = '' or long(user_field1) < quantity) "
	
	llPickFindRow =  w_do.idw_Pick.Find(lsFind,0,w_do.idw_Pick.RowCount()) /* Scanned Qty will be in the first Pick Row*/
	If llPickFindRow > 0 Then
		llPickLineItemNo = w_do.idw_Pick.GetITemNumber(llPickFindRow,'line_item_No') /* 12/13 - PCONKL - if multiple line items for SKU, we need specific one, originally set from detail row*/
	End If
	
else /* not saerialized*/
	
	//If no serial, add/update a generic row for this sku/lot - we still need the total Qty scanned
	//Otherwise set on an empty row
	if w_do.ib_QtyEntered = false then //user needs to be prompted to enter the quantity	
		w_do.Tab_main.tabpage_serial.st_message.Text = "Please enter a quantity for the item."
		w_do.tab_main.tabpage_serial.sle_scan_qty.text = "0"
		w_do.tab_main.tabpage_serial.sle_scan_qty.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_scan_qty.text))
		w_do.tab_main.tabpage_serial.sle_scan_qty.SetFocus()
		w_do.ibScanQtyNeeded = True /* will allow focus to shift to Qty field*/
		return -1
	else  //quantity already read is correct
		w_do.ib_QtyEntered = false
	end if
	
	
	// 04/01 - PCONKL - We need to capture qty scanned at the Lot/Exp DT Level which we can't do on the serial tab due to field constraint
	//							Instead, we will store the scanned Qty in UF1 on Delivery Picking in the first row for that Lot/Exp DT (in case multiple pick rows with same Lot/Exp DT)
	
	// Scanned Qty - May include Lot and/or Exp DT
	
	llScannedQty = 0
	llFindRow = 0
	
	lsFind = "Upper(sku) = Upper('" + lsSKU + "')"
	
	if lsLotCont = "Y" Then
		lsFind += " and upper(lot_no) = '" + Upper(lsLot) + "'"
	End If
	
	IF lsExpCont = 'Y' Then 
		lsExpDT = Mid(lsExpiry,3,2) + "/" + Mid(lsExpiry,5,2) + "/" + "20" + Mid(lsExpiry,1,2)
		lsFind +=  " and  date(expiration_date) = Date('" + lsExpDT + "')"	
	End If
		
	// 01/14 - PCONKL - a SKU may be in multiple lines, find the one not already fully scanned
	lsFind += " and (isnull(user_field1) or user_field1 = '' or long(user_field1) < quantity) "
	
//	llFindRow =  w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,0,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
	llFindRow =  w_do.idw_Pick.Find(lsFind,0,w_do.idw_Pick.RowCount()) /* Scanned Qty will be in the first Pick Row*/
	If llFindRow > 0 Then
		llScannedQty = Long(trim(w_do.idw_Pick.GetItemString(llFindRow,'user_field1')))
		llPickLineItemNo = w_do.idw_Pick.GetITemNumber(llFindRow,'line_item_No') /* 12/13 - PCONKL - if multiple line items for SKU, we need specific one, originally set from detail row*/
		If isnull(llScannedQty) Then llScannEdQty = 0
	End If
	
//	Do While lLFindRow > 0
		
//		llScannedQty += w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(llFindRow, 'quantity')
		
	//	llFindRow =  w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,llFindRow + 1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount() + 1)
		
//	loop

	
	// Picked Qty - May include Lot and/Or Exp DT
	
	llDetailQty = 0
	//llFindRow =  w_do.idw_Detail.Find(lsFind,0,w_do.idw_Detail.RowCount())
	llFindRow =  w_do.idw_Pick.Find(lsFind,0,w_do.idw_Pick.RowCount())
	Do While lLFindRow > 0
		//llDetailQty += w_do.idw_Detail.getITemNumber(llFindRow,'alloc_qty')
		llDetailQty += w_do.idw_Pick.getITemNumber(llFindRow,'quantity')
		//llFindRow =  w_do.idw_Detail.Find(lsFind,llFindRow + 1,w_do.idw_Detail.RowCount() + 1)
		llFindRow =  w_do.idw_Pick.Find(lsFind,llFindRow + 1,w_do.idw_Pick.RowCount() + 1)
	Loop
	
	
//	llFindRow = w_do.idw_pick.Find(lsFind, 0, w_do.idw_pick.RowCount())	
	
	if llDetailQty < (llScannedQty + lQty) then
		
		w_do.tab_main.tabpage_serial.sle_scan_qty.SetFocus()						
		w_do.tab_main.tabpage_serial.sle_scan_qty.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_scan_qty.text))
		doDisplayMessage("Packing Scan", "The Scanned quantity for this SKU exceeds the Picked Qty for " + lsSKU)
		return -1								

	end if
	
	
	lsFind = "Upper(sku) = Upper('" + lsSKU + "') and line_item_no = " + String(llPickLineitemNo) + " and (carton_no = '' or isnull(carton_no) or carton_no = '" + w_do.tab_main.tabpage_serial.sle_carton_no.text + "')"
	if lsSerial <> "" and lsSerial <> '-' and left(lsSerial,3) <> 'N/A'  then
		lsFind += " and (IsNull(Serial_no) or Serial_No='-')"
	End If
	
	llFindRow = w_do.idw_serial.Find(lsFind, 0, w_do.idw_serial.RowCount()) 
		
	if llFindRow = 0  then
		
		llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.InsertRow(0)
		w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'quantity', 0)
		
		//Need the Line Item and ID_NO from Picking Detail
		w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow, 'line_item_no', llPickLineitemNo )
		
		Select id_no into :ll_id_no FRom Delivery_Picking_Detail Where do_no = :lsDoNo and Line_Item_no = :llPickLineitemNo and Sku = :lsSKU;
		w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow, 'id_no', ll_id_no)
			
		If lsSerCont = 'N' Then
			lsSerial = "N/A-" + w_do.tab_main.tabpage_serial.sle_carton_no.text /* carton not part of key, need to keep it unique in SN field*/
			w_do.Tab_main.tabpage_serial.dw_serial.SetITem(llFindRow,'serial_no',lsSerial)
		End If
		
	end if
	
end if

w_do.Tab_main.tabpage_serial.dw_serial.SetRow(llFindRow)
w_do.Tab_main.tabpage_serial.dw_serial.ScrolltoRow(llFindRow)

if lsSerial <> "" and lsSerial <> '-' and left(lsSerial,3) <> 'N/A'  then
	w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'quantity',1)	
	llPickUpdateQty = 1 /* used to update scanned qty on Pick List*/
else
	w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'quantity',w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(llFindRow,'quantity') + lQty)	
	llPickUpdateQty = lQty /* used to update scanned qty on Pick List*/
	
	If lsSerCont = 'N' Then
		lsSerial = "N/A-" + w_do.tab_main.tabpage_serial.sle_carton_no.text /* carton not part of key, need to keep it unique in SN field*/
	End If
	
end if

w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'Serial_no', lsSerial)
w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'carton_no',w_do.tab_main.tabpage_serial.sle_carton_no.text)
//w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow, 'line_item_no', llPickLineitemNo )
w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow, 'description', lsDescript)		
w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow, 'serialized_ind', lsSerCont)
w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow, 'shippable_flag', 'Y')
w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow, 'part_upc_code', lsUPN)		
w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow, 'sku', lsSKU)		
w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow, 'sku_parent', lsSKU)		
w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow, 'supp_code', lsSupplier)		
w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow, 'component_ind', 'N')		
w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow, 'native_description', lsNative)		


// 04/13 - PCONKL - Update the Scanned Qty on the first matching Pick Row in UF 1
lsFind = "Upper(sku) = Upper('" + lsSKU + "')"
	
if lsLotCont = "Y" Then
	lsFind += " and upper(lot_no) = '" + Upper(lsLot) + "'"
End If
	
IF lsExpCont = 'Y' Then 
	lsExpDT = Mid(lsExpiry,3,2) + "/" + Mid(lsExpiry,5,2) + "/" + "20" + Mid(lsExpiry,1,2)
	lsFind +=  " and  date(expiration_date) = Date('" + lsExpDT + "')"	
End If
		
lsFind += " and (isnull(user_field1) or user_field1 = '' or long(user_field1) < quantity) "

llFindRow =  w_do.idw_Pick.Find(lsFind,0,w_do.idw_Pick.RowCount()) /* Scanned Qty will be in the first Pick Row*/
If llFindRow > 0 Then
		
	If isnumber(Trim(w_do.idw_Pick.getITemString(llFindRow,'User_Field1'))) Then
		w_do.idw_Pick.SetItem(llFindRow,'user_Field1',String( Long(w_do.idw_Pick.getITemString(llFindRow,'User_Field1')) +  llPickUpdateQty) )
	Else
		w_do.idw_Pick.SetItem(llFindRow,'user_Field1',String(llPickUpdateQty))
	End If
	
	llPickFindRow = llFindRow /* 11/13 - PCONKL - Used below for copying attributes to pack*/
		
End If

// 11/13 - PCONKL - We are now going to build the Packing List from the scan since we need the lottbale information and we can't store it anywhere for later generation
//						EDI 945 processing needs the lottables on the PAcking List. These requirements were added after the original scanning logic was created.

lsFInd = "Upper(carton_no) = '" + upper(w_do.tab_main.tabpage_serial.sle_carton_no.text) + "' and LIne_Item_no = " + String(llPickLineitemNo) + " and Upper(sku) = '" + upper(lsSKU) + "'"
lsFind += " and upper(supp_Code) = '" + upper(lsSupplier) + "' and upper(pack_Lot_No) = '" + Upper(lsLot) +  "'"
IF lsExpCont = 'Y' Then 
	lsFind +=  " and  date(Pack_expiration_date) = Date('" + lsExpDT + "')"	
End If

//po_no and po_no2 from Pick List (not scanned)
If llPickFindRow > 0 Then
		lsFind += " and upper(pack_po_no) = '" + upper(w_do.idw_Pick.GetItemString(llPickFindRow,'po_no')) + "' and upper(pack_po_no2) = '" + upper(w_do.idw_Pick.GetItemString(llPickFindRow,'po_no2'))  + "'"
End If
	
//Messagebox("",lsFind)

llFindRow = w_do.idw_Pack.Find(lsFind,1,w_do.idw_Pack.RowCOunt())
If llFindRow > 0 Then /* update existing Pack Row */

	w_do.idw_Pack.SetITem(llFindROw,'quantity',w_do.idw_Pack.GetITEmNumber(llFindRow,'quantity') + llPickUpdateQty)
	w_do.idw_pack.SetItem ( llFindROw, 'weight_gross', (w_do.idw_pack.GetITemNumber(llFindROw,'weight_net') * w_do.idw_pack.GetITemNumber(llFindROw,'Quantity')))
	
Else /* insert a new Pack Row*/
	
	//Get the DIMS and Weight...
	SELECT Length_1, Width_1, Height_1, Weight_1,standard_of_measure
	INTO :ld_length, :ld_width, :ld_height, :ld_weight,:ls_std_measure
	FROM Item_Master 
	WHERE Project_id = :gs_project and	SKU = :lsSKU and	supp_code = :lsSupplier
	Using SQLCA;
	
	ll_row = w_do.idw_pack.InsertRow(0)
	w_do.idw_pack.SetItem(ll_row,'do_no',w_do.idw_Main.GetITemString(1,'do_no'))
	w_do.idw_pack.SetItem(ll_row,'carton_no',w_do.tab_main.tabpage_serial.sle_carton_no.text)
	w_do.idw_pack.SetItem(ll_row,'line_item_no',llPickLineitemNo)
	w_do.idw_pack.SetItem(ll_row,'sku',lsSKU)
	w_do.idw_pack.SetItem(ll_row,'supp_code',lsSUpplier)
	w_do.idw_pack.SetItem(ll_row,'pack_lot_no',lsLot)
	//w_do.idw_pack.SetItem(ll_row,'serial_no',lsSerial)
	//w_do.idw_pack.SetItem(ll_row,'pack_expiration_date',lsExpDT)
	w_do.idw_pack.SetItem(ll_row,'quantity',llPickUpdateQty)
	
	w_do.idw_pack.SetItem ( ll_row, 'length', ld_length)
	w_do.idw_pack.SetItem ( ll_row, 'width', ld_width )
	w_do.idw_pack.SetItem ( ll_row, 'height', ld_height)
	w_do.idw_pack.SetItem ( ll_row, 'weight_net',ld_weight )
	
	ls_wh_code = w_do.idw_main.object.wh_code[1]
	ls_std_measure_w = g.ids_project_warehouse.object.standard_of_measure[g.of_project_warehouse(gs_project,ls_wh_code)]
	IF ls_std_measure = ls_std_measure_w THEN
		w_do.idw_pack.Setitem(ll_row,"standard_of_measure",ls_std_measure)			
	ELSE
		w_do.idw_pack.Setitem(ll_row,"standard_of_measure",ls_std_measure_w)
		w_do.wf_convert(ls_std_measure_w, 1, ll_Row)//convert the Dimentions 
	END IF
				
	//po_no and po_no2 from Pick List (not scanned)
	If llPickFindRow > 0 Then
		
		w_do.idw_pack.SetItem(ll_row,'pack_po_no',w_do.idw_Pick.GetItemString(llPickFindRow,'po_no'))
		w_do.idw_pack.SetItem(ll_row,'pack_po_no2',w_do.idw_Pick.GetItemString(llPickFindRow,'po_no2'))
		w_do.idw_pack.SetItem(ll_row,'pack_expiration_date',w_do.idw_Pick.GetItemDateTime(llPickFindRow,'Expiration_Date'))
		w_do.idw_pack.SetItem(ll_row,'Country_of_Origin',w_do.idw_Pick.GetItemString(llPickFindRow,'Country_of_Origin'))
				
	End If
	
	//If first row for carton...
	If ll_row = 1 Then
		w_do.idw_pack.SetItem(ll_row,"c_first_carton_row","Y")
	Else
		If w_do.idw_pack.Find("carton_no = '" + w_do.tab_main.tabpage_serial.sle_carton_no.text + "'",1, ll_row - 1) = 0 Then
			w_do.idw_pack.SetItem(ll_row,"c_first_carton_row","Y")
		End If
	End If
	
End If

w_do.Tab_main.tabpage_serial.st_message.Text = "Please scan a package barcode."
w_do.ib_changed = True  //mark the page dirty
w_do.tab_main.tabpage_serial.sle_scan_qty.text = "0"  //reset the scanned quantity to one so they don't have to futz with it if  they're doing lots and serialized inventory at the same time
w_do.Tab_main.tabpage_serial.sle_barcodes.text = ""
w_do.Tab_main.tabpage_serial.sle_barcodes.SetFocus()			

Return 0
end function

public function integer uf_do_scan_pandora (string assku, string asscan, long alrow, string astype);//Process DO scans for Pandora

String	lsScan, lsSKU, lsFind, lsContainerId, lsCarton
Long		llFindRow, llContainerQty, llCartonQty, llScanQty

//See if we scanned a Pallet
lsScan = asScan

//TimA 07/30/13 as of this date there are no record in Carton_Serial.  Use Serial Number Inventory
//GailM 11/19/2013 - Added check for status cd D to filter out delivered orders
//TimA 12/05/13 On LPN orders we need to look at pallet_Id
If astype = 'P' then
	Select Min(SKU), Count(*) into :lsSKU, :llContainerQty 
	From Carton_Serial
	Where Project_id = 'PANDORA' and Pallet_Id = :lsScan;
	//And status_cd <> 'D';  //GailM 12/13/2013 Removed check for status code Delivered
Else
	Select Min(SKU), Count(*) into :lsSKU, :llContainerQty 
	From Carton_Serial
	Where Project_id = 'PANDORA' and Carton_Id = :lsScan;
	//And status_cd <> 'D';  //GailM 12/13/2013 Removed check for status code Delivered
End if
//Select Min(SKU), Count(*) into :lsSKU, :llContainerQty 
//From Serial_Number_Inventory
//Where Project_id = 'PANDORA' and Carton_Id = :lsScan;
If isnull(lsSKU) then lsSKU = ''

If lsSku > '' Then /*Container Exists*/

	If w_do.idw_serial.Find("Upper(SERIAL_NO) = '" + upper(lsScan) + "'" + " and Upper(SKU) = '" + upper(lsSku) + "'",1, w_do.idw_serial.rowCount()) > 0 Then
		messagebox('Container Scanned','This Container Number/sku combination has already been scanned!',Stopsign!)
		Return -1
	End If


	//Make sure this pallet is what was actually picked
	If astype = 'P' then
		llFindRow = w_do.idw_Pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(PO_No2) = '" + Upper(lsScan) + "'",1, w_do.idw_Pick.RowCount())
	Else
		llFindRow = w_do.idw_Pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Container_id) = '" + Upper(lsScan) + "'",1, w_do.idw_Pick.RowCount())
	End if
	If llFindRow <= 0 Then	
		
		Messagebox('Container Scanned', "Container ID not found on Pick List.~r~nPlease correct Pick List and re-scan." )
		Return -1
		
	Else /* make sure a full pallet was picked, otherwise,they need to be scanning Cartons */
		
		If w_do.idw_Pick.GetITemNumber(llFindRow,'quantity') <> llContainerQty Then
			
			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
			Messagebox('Container Scanned', "Container ID: '" + lsScan + "' was not picked in it's entirety.~r~nContainer ID's must be scanned for this Pallet." )
			Return -1
			
		End If 
		
	End If /*Container not found on Picking List*/

	lsContainerId = lsScan
	llScanQty = llContainerQty /*Container Qty will be set on Serial record for validating at confirmation that all were entered*/
		
//Else /* Not a pallet, see if we scanned a carton*/
//
//	Select Min(SKU), Min(Pallet_id), Count(*) into :lsSKU, :lsContainerId, :llCartonQty
//	From Carton_Serial
//	Where Project_id = 'COMCAST' and Carton_id = :lsScan;
//
//	If lsContainerId > '' Then /*carton Exists */
//	
//		//Make sure this pallet is what was actually picked
//		llFindRow = w_do.idw_Pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(PO_NO2) = '" + Upper(lsContainerId) + "'",1, w_do.idw_Pick.RowCount()) 
//		If llFindRow = 0 Then
//			
//			MessageBox('Carton Scanned', "Pallet ID: '" + lsContainerId + "' not found on Pick List for this CARTON.~r~nPlease correct Pick List and re-scan." )
//			Return -1
//		
//		Else /* Make sure we haven't already scanned a pallet that this caarton is contained in */
//			
//			If w_do.tab_main.tabpage_serial.dw_serial.find("Serial_No = '" + lsContainerId + "'",1,w_do.tab_main.tabpage_serial.dw_serial.RowCount()) > 0 Then
//				
//				w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
//				Messagebox('Carton Scanned', "Pallet ID: '" + lsContainerId + "' has already been scanned for this CARTON." )
//				Return -1
//		
//			End IF
//			
//		End If /*Pallet not found on Picking List*/
//		
//		llScanQty = llCartonQty /*Carton Qty will be set on Serial record for validating at confirmation that all were entered*/
//		w_do.tab_main.tabpage_serial.st_message.Text = "CARTON Scanned."
//	
//	Else /* Not a Pallet or Carton Scan */
//						
//		w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
//		Messagebox('Invalid Scan', "Serial Number information for this Pallet/Carton has not been received from Comcast.~r~nUnable to process Pallet." )
//		Return -1
//		
//	End If
	
End If

If asSKU <> lsSKU Then
	Messagebox('Invalid SCAN', 'Container ID is not associated with this SKU.')
	return -1
End If

//Set the scanned Qty on the updated row
w_do.tab_main.tabpage_serial.dw_serial.SetITem(alRow,'Quantity',llScanQty)

w_do.ib_Changed = True

Return 0
end function

public function integer uf_do_scan_anki (string asbarcode);

//ANKI is scanning a barcode which that may contain a prefix of "C" for Carton or "P" for Pallet.  If it does then get the Quantity from the Item Master


String	lsPackConfig, lsLMAPrefix, lsProdCode, lsSKU, lsUOM1, lsUOM2, lsUOM3, lsUOM4, lsLot, lsSerial, lsExpDate, lsCOO, lsPackUOM,lsFind,lsSupplier
Long		llQty2, llQty3, llQty4, llPAckQty, llPickedQty, llNewRow, llDetailFindRow,llPackingRow,llFindRow, llCartonQty, llScannedQty, llPickLineItemNo, llPackLineItemNo

//Check for a (Packing) Carton Scan first - will update all rows with Packing carton number until another one is scanned
lsFind = " Upper(carton_no) = '" + Upper(asbarcode) + "'"
llFindRow = w_do.idw_pack.Find(lsFind,1,w_do.idw_pack.RowCount())
If llFindRow > 0 Then
	llPackingRow = llFindRow
	w_do.Tab_main.tabpage_serial.sle_carton_no.text = w_do.idw_pack.GetITemString(llFindRow,'carton_no')
	w_do.Tab_main.tabpage_serial.st_message.text = "PACKING CARTON NUMBER: "+ asbarcode + "Scanned. Please scan a SKU."
	w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))
	w_do.isCurrentPackCartonId = trim(Upper(asbarcode))
	Return 0
End If

//If we haven't scanned a carton at this point, we have an error
If w_do.isCurrentPackCartonId = '' or isnull(w_do.isCurrentPackCartonId) then
	doDisplayMessage('Pack Scan',"Packing Carton number must be scanned/entered before scanning a SKU or package barcode.")
	Return -1
End If

lsFind = " Upper(sku) = '" + Upper(asbarcode) + "'"
llFindRow = w_do.idw_pack.Find(lsFind,1,w_do.idw_pack.RowCount())
If llFindRow > 0 Then
	llPackingRow = llFindRow
	w_do.Tab_main.tabpage_serial.sle_carton_no.text = w_do.idw_pack.GetITemString(llFindRow,'Sku')
	w_do.Tab_main.tabpage_serial.st_message.text = "PACKING CARTON NUMBER: "+ w_do.isCurrentPackCartonId + " ,SKU: " + asbarcode + "  Scanned. Please scan a package barcode."
	w_do.Tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.Tab_main.tabpage_serial.sle_barcodes.Text))
	w_do.isCurrentSKU = trim(Upper(asbarcode))
	Return 0
End If
//If we haven't scanned a carton at this point, we have an error
If w_do.isCurrentSKU = '' or isnull(w_do.isCurrentSKU) then
	doDisplayMessage('Pack Scan',"SKU must be scanned/entered before scanning a package barcode.")
	Return -1
End If

// Check if Serial Number has already been scanned
lsFind = " Upper(serial_no) = '" + Upper(asbarcode) + "'"
llFindRow =  w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1, w_do.Tab_main.tabpage_serial.dw_serial.RowCount()) 
If llFindRow > 0 Then
	doDisplayMessage('Pack Scan',"This package barcode has already been scanned.")
	Return -1
End If

//PAcking Configuration (will be validated against Item Master below) - Convert to the SIMS UOM so we can maintain meaningfull UOM's in SIMS
lsPAckConfig = Left(asBarcode,1)

Choose Case lsPAckConfig
	Case 'C'
		lsPAckUOM = 'C'
	Case 'P'
		lsPAckUOM = 'P'
	Case Else
		lsPackUOM = 'EA'
End Choose

//Validate SKU - We will also be validating UOM's and Qty below

lssku = w_do.isCurrentSKU
//Get Supplier
lsFind = " Upper(sku) = '" + Upper(lsSku) + "' and isnull(serial_no)" 
llFindRow =  w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1, w_do.Tab_main.tabpage_serial.dw_serial.RowCount() + 1) 
If llFindRow > 0 Then
	lsSupplier =  w_do.Tab_main.tabpage_serial.dw_serial.GetItemString(llFindRow,'Supp_Code') 
else
	lsSupplier =  w_do.Tab_main.tabpage_serial.dw_serial.GetItemString(1,'Supp_Code') 
end if

Select uom_1, uom_2, uom_3, uom_4,  Qty_2, Qty_3, Qty_4 
into  :lsUOM1, :lsUOM2, :lsUOM3, :lsUOM4,  :llQty2, :llQty3, :llQty4
From Item_MAster where project_id = 'ANKI' and SKU = :lsSku and Supp_Code = :lsSupplier;


//Validate Pack Config against UOM's and make sure Qty exists in Item Master

llPackQty = 0

If lsPAckUOM = 'EA' Then
	llPackQty = 1
ElseIf lsPAckUOM = left(lsUOM2,1) Then
	llPackQty = llQty2
ElseIf lsPAckUOM = left(lsUOM3,1) Then
	llPackQty = llQty3
ElseIf lsPAckUOM = left(lsUOM4,1) Then
	llPackQty = llQty4
Else /*Invalid PAck Qty */
	doDisplayMessage('Pack Scan',"Pack Configuration '" + lsPAckUOM + "' Not configured for this Item (" + lsSKU + ")")
	Return -1
End If

If llPAckQty = 0 Then
	doDisplayMessage('Pack Scan',"No Qty in Item Master (" + lsSKU + ") for this Pack Configuration (" + lsPAckUOM + ")")
	Return -1
End If




//Make sure this SKU/Lot/Exp DT (if applicable) was picked

lsFind = "Upper(SKU) = '" + Upper(lsSKU) + "'"

llDetailFindRow = w_do.idw_Pick.Find(lsFind,1,w_do.idw_Pick.RowCount())

If llDetailFindRow <=0 Then /* No Pick row */
	doDisplayMessage('Pack Scan',"Picking Record not found for SKU '" + lsSKU +  "'")
	Return -1
End If

llPickLineItemNo = w_do.idw_Pick.getITemNumber(llDetailFindRow,'line_item_no')

//Make Sure this SKU is packed in the scanned carton
lsFind = "Upper(carton_No) = '" + Upper(w_do.isCurrentPackCartonId) + "' and Upper(SKU) = '" + upper(lsSKU) + "'"
llFindRow = w_do.idw_Pack.Find(lsFind,1,w_do.idw_Pack.RowCount())

If llFindRow <=0 Then /* No Pack row */
	doDisplayMessage('Pack Scan',"SKU '" + LsSKU + "' Not found in carton '" + w_do.isCurrentPackCartonId + "'")
	Return -1
End If

llPAckLineItemNo = w_do.idw_Pack.GetItemNumber(lLFindRow,'line_item_no')

//Make sure we haven't scanned more than is packed in the Carton
	
//Sum all Qty for Carton/SKU -in Serial Tab
lsFind = " Upper(carton_no) = '" + Upper(w_do.isCurrentPackCartonId) + "' and Upper(sku) = '" + Upper(lsSKU) + "'"
llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
	
llScannedQty = 0
Do While llFindRow > 0
		
	llScannedQty += w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(llFindRow,'Quantity')
		
	If llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.RowCount() Then
		llFindRow = 0
	Else
		llFindRow ++
		llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,llFindRow,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
	End If
Loop
	
//Sum all Qty for Carton/SKU in pACking Tab
llCartonQty = 0

llFindRow = w_do.idw_pack.Find(lsFind,1,w_do.idw_pack.RowCount())

Do While llFindRow > 0
	
	llCartonQty += w_do.idw_pack.GetItemNumber(llFindRow,'Quantity')
	
	If llFindRow = w_do.idw_pack.RowCount() Then
		llFindRow = 0
	Else
		llFindRow ++
		llFindRow = w_do.idw_pack.Find(lsFind,llFindRow,w_do.idw_pack.RowCount())
	End If
Loop


If  llPackQty + llScannedQty > llCartonQty Then
	doDisplayMessage('Serial Numbers',"Existing scanned Qty (" + String(llScannedQty) + ") + current package Qty (" + String(llPAckQty) + ") is greater than Carton Qty from Packing List (" + String(llCartonQty) + "). Please scan the next carton.")
	return -1
End IF

//We also want to make sure that we don't scan more of a Lot than exists on the Pick List

//Sum all Qty for SKU/Lot (MAC_ID) -in Serial Tab
lsFind = "Upper(sku) = '" + Upper(lsSKU) + "'"
llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
	
llScannedQty = 0
Do While llFindRow > 0
		
	llScannedQty += w_do.Tab_main.tabpage_serial.dw_serial.GetItemNumber(llFindRow,'Quantity')
		
	If llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.RowCount() Then
		llFindRow = 0
	Else
		llFindRow ++
		llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,llFindRow,w_do.Tab_main.tabpage_serial.dw_serial.RowCount())
	End If
	
Loop

//Sum all Qty for SKU in Picking Tab
llPickedQty = 0 

lsFind = "Upper(sku) = '" + Upper(lsSKU) + "'"
llFindRow = w_do.idw_pick.Find(lsFind,1,w_do.idw_pick.RowCount())

Do While llFindRow > 0
	
	llPickedQty += w_do.idw_pick.GetItemNumber(llFindRow,'Quantity') /*Picked Qty */
	
	If llFindRow = w_do.idw_pick.RowCount() Then
		llFindRow = 0
	Else
		llFindRow ++
		llFindRow = w_do.idw_pick.Find(lsFind,llFindRow,w_do.idw_pick.RowCount())
	End If
Loop


If  llPackQty + llScannedQty > llPickedQty Then 
	doDisplayMessage('Serial Numbers',"Existing scanned Qty (" + String(llScannedQty) + ") + current package Qty (" + String(llPAckQty) + ") is greater than Picked Qty from Picking List for this LOT NUMBER (" + String(llPickedQty) + "). Please scan the next LOT NUMBER.")
	return -1
End IF
	
//Set the serial # on an empty row
		
	//Find the first empty row for this Carton/SKU and populate Serial and Qty
	//05/09 - PCONKL - Added line item (captured above) so we can allocate it the scan to the correct line item
	lsFind = " Upper(sku) = '" + Upper(lsSKU) + "' and isnull(serial_no) and line_item_no = " + String(llPickLineitemNo)
	llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount() + 1) 

	If llFindRow > 0 Then
		
		w_do.Tab_main.tabpage_serial.dw_serial.SetRow(llFindRow)
		w_do.Tab_main.tabpage_serial.dw_serial.ScrolltoRow(llFindRow)
		w_do.Tab_main.tabpage_serial.dw_serial.SetColumn('serial_no')
		w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'Serial_no',asBarCode)
		w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'carton_no',w_do.isCurrentPackCartonId)
		w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'quantity',llPackQty)
		w_do.Tab_main.tabpage_serial.st_message.Text = "Package Barcode scanned."
		
	Else /*all rows for this SKU have been entered - 05/09 - PCONKL - Add a new row - we only generated 1 row per pick row, not per qty*/
		
		//doDisplayMessage('Serial Numbers',"All Serial Numbers for this SKU have been entered. ")
		
		//Find an existing for Line/SKU and Copy to new
		lsFind = " Upper(sku) = '" + Upper(lsSKU) + "' and line_item_no = " + String(llPickLineitemNo) 
		llFindRow = w_do.Tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.Tab_main.tabpage_serial.dw_serial.RowCount() + 1) 
		If llFindRow > 0 Then
			
			w_do.tab_main.tabpage_serial.dw_serial.RowsCopy(llFindRow,llFindRow,Primary!, w_do.tab_main.tabpage_serial.dw_serial,9999999,primary!) /*add at end*/
			w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(w_do.tab_main.tabpage_serial.dw_serial.RowCount())
			w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'Serial_no',asBarCode)
			w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'carton_no',w_do.isCurrentPackCartonId)
			w_do.Tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,'quantity',llPackQty)
			w_do.Tab_main.tabpage_serial.st_message.Text = "Package Barcode scanned."
			
		End If
				
	End If

w_do.Tab_main.tabpage_serial.st_message.Text = "Please scan a package barcode."
w_do.ib_changed = True








////Process DO scans for Pandora
//
//String	lsScan, lsSKU, lsFind, lsContainer, lsCarton,lsLineItemNo,ls_ctype,lsCartonId, ls_sku,lsSUpplier
//String ls_SerializedInd,ls_PONO2ControlledInd,ls_ContainerTrackingInd
//String ls_serialprefix
//Long ld_Qty2, ld_Qty3, ld_Qty4, ld_IMQty //TAM 2015/06
//String ls_UOM2, ls_UOM3, ls_UOM4 //TAM 2015/06
//
//Long		llFindRow, llContainerQty, llCartonQty, llScanQty,ll_cs_rows, row, i_ndx
//
////TimA 08/16/13 Pandora LPN project
//If Not isValid(idw_carton_serial) Then
//	idw_carton_serial = Create DAtastore
//	idw_carton_serial.DataObject = 'd_carton_serial_validate'
//	idw_carton_serial.SetTransObject(SQLCA)
//	//isOrigSql = idsSerial.GetSQLSelect()
//End If
//
//ld_IMQty = 1
////See if we scanned a Pallet
//lsScan = w_do.tab_main.tabpage_serial.sle_barcodes.Text
//row = w_do.tab_main.tabpage_serial.dw_serial.getrow()
//ls_sku = w_do.tab_main.tabpage_serial.dw_serial.getitemstring(row, "sku")
//ls_serialPrefix = left(lsScan,1)
//lsSupplier = w_do.tab_main.tabpage_pick.dw_pick.GetITemString(row,"supp_code")
//
//Select UOM_2, Qty_2, UOM_3, Qty_3, UOM_4, Qty_4 Into :ls_UOM2, :ld_Qty2, :ls_UOM3, :ld_Qty3, :ls_UOM4, :ld_Qty4
//From Item_Master
//Where project_id = :gs_project and sku = :ls_sku and supp_code = :lsSUpplier;			
//			
//	If ls_SerialPrefix = 'P'  then
//		If Upper(ls_UOM2) = 'PLT' then
//			ld_IMQty = ld_qty2 
//		Else 
//			If Upper(ls_UOM3) = 'PLT' then
//				ld_IMQty = ld_qty3 
//			Else
//				If Upper(ls_UOM4) = 'PLT' then
//					ld_IMQty = ld_qty4 
//				Else
//					//ERROR QTY not defined in Item Master
////					messagebox("Pallet Quantity is not set up in Item Master for SKU " + string(ls_Sku))
//					w_do.tab_main.tabpage_serial.dw_serial.SetItem(row, 'Serial_no', '-')  // blank out the scanned data
//					w_do.tab_main.tabpage_serial.dw_serial.SelectText(1,1)
//					return 1
//				End If
//			End If
//		End If
//	Else
//		If Upper(ls_UOM2) = 'CTN' then
//			ld_IMQty = ld_qty2 
//		Else 
//			If Upper(ls_UOM3) = 'CTN' then
//				ld_IMQty = ld_qty3 
//			Else
//				If Upper(ls_UOM4) = 'CTN' then
//					ld_IMQty = ld_qty4 
//				Else
//					//ERROR QTY not defined in Item Master
////					messagebox("Carton Quantity is not set up in Item Master for SKU " + string(ls_Sku))
//					w_do.tab_main.tabpage_serial.dw_serial.SetItem(row, 'Serial_no', '-')  // blank out the scanned data
//					w_do.tab_main.tabpage_serial.dw_serial.SelectText(1,1)
//					return 1
//				End If
//			End If
//		End If
//	End If
//
//lsLineItemNo = string(w_do.tab_main.tabpage_serial.dw_serial.GetItemNumber(row,"line_item_no")) 
//lsFind = "(serial_no = '-' or IsNull(serial_no)) and SKU = '" + ls_sku + "' and line_item_no = " + lsLineItemNo
//llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
//if llFindRow > 0 then
//		w_do.tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,"serial_no", lsScan)
//		w_do.tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,"quantity",ld_IMQty)
//end if							
//
//
//		
//lsFind = "IsNull(serial_no)"
////lsFind = "serial_no = '-'"
//llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())	// Find next blank SN
//if llFindRow > 0 then
//	w_do.tab_main.tabpage_serial.dw_serial.scrolltorow(llFindRow)
//end if
//
//w_do.SetMicroHelp("Ready")				

Return 0
end function

public function integer uf_do_scan_pandora_ip (string asscan);//Process DO scans for Pandora IP(Intellectual Property) 

String	lsScan, lsSKU, lsFind, lsContainer, lsLineItemNo,ls_ctype,lsCartonId, ls_sku,lsSUpplier, lsDoNo
String lsSNPalletId, lsSNCartonNo, lsSNSku
String ls_Filter, lsPalletId,  lsSerialNo,lsCartonNo, lsMsg, lsMixedContainerization
String lsSqlSyntax, lsWhere, lsSql
Long	i, j, llRC, llFindRow, llContainerQty, llCartonQty, ldPickQty, ldPickCount, ldSNRowCount, ldContentQty
DataStore ldw_serial
datetime ldtToday
String	lsSerialFlag 
String	lsSerialDoNo 

lsMixedContainerization = "N"

If Not isValid(ldw_serial) Then
	ldw_serial = Create Datastore
	ldw_serial.DataObject = 'd_serial_inventory_validate'
	ldw_serial.SetTransObject(SQLCA)
End If
 
//1. Resolve the scan to its associated Pallet ID.  All IP(Intellectual Property) SKUs must be on a pallet.  Reguardless of the value(Serial, Container ID or Pallet) entered we can determine which Pallet it  belongs to.

// Check if the value scanned is a Pallet	
lsDoNo = w_do.idw_Pick.GetItemString(1,'do_no')
lsFind = "Upper(po_no2) = '" + Upper(asScan) + "'"
llFindRow = w_do.idw_Pick.Find(lsFind,1, w_do.idw_Pick.RowCount())
If llFindRow > 0 Then 
     lsPalletId = asScan
	lsCartonNo = w_do.idw_Pick.GetITemString(llFindRow,'container_id' )
	ldPickQty = GetPalletQty(lsDoNo, lsPalletId)
	lsSKU = w_do.idw_pick.getitemstring(llFindRow,'sku')
	ls_ctype = "Pallet"
Else
	// Check if the value scanned is a Container
	lsFind = "Upper(container_id) = '" + Upper(asScan) + "'"
	llFindRow = w_do.idw_Pick.Find(lsFind,1, w_do.idw_Pick.RowCount())

	If llFindRow > 0 Then 
		ls_ctype = "Carton"
		lsCartonNo = w_do.idw_Pick.GetITemString(llFindRow,'container_id' )
		lsPalletId = w_do.idw_Pick.GetITemString(llFindRow,'po_no2' )
		ldPickQty = GetContainerQty(lsDoNo, lsPalletId, lsCartonNo)
	Else
		ls_ctype = "Serial"
		lsSerialNo = asScan
		ldw_serial.DataObject = 'd_serial_inventory_serial'
		ldw_serial.SetTransObject(SQLCA)
		ldSNRowCount = ldw_serial.retrieve('PANDORA', lsSerialNo)
		If ldSNRowCount <= 0 Then 
			doDisplayMessage('Invalid Scan', "Serial No Cannot be found in the Serial Inventory Table." )
			Return -1
		End If
		If ldSNRowCount = 1 Then
			lsSNPalletId = ldw_serial.GetItemString(1, 'po_no2')
			lsSNCartonNo = ldw_serial.GetItemString(1, 'carton_id')
			lsSNSku = ldw_serial.GetItemString(1, 'sku')
			lsSKU = w_do.idw_serial.GetItemString(ilSerialRowNo, 'sku')
			If lsSNSku <> lsSKU Then
				doDisplayMessage('Invalid Scan', "Serial No " + lsSerialNo + " cannot be linked to GPN " + lsSKU + " in the Serial Inventory Table." )
				Return -1
			End If
			lsPalletId = lsSNPalletId
			lsCartonNo = lsSNCartonNo
			lsSerialFlag = ldw_serial.getItemString(1, 'serial_flag')
			lsSerialDoNo = ldw_serial.getItemString(1, 'do_no')
			If lsSerialFlag = "L" Then
				//Get the rest of the pallet/carton
				ldw_serial.DataObject = 'd_serial_inventory_validate'
				ldw_serial.SetTransObject(SQLCA)
				
				lsSqlSyntax = ldw_serial.GetSqlSelect()
				lsWhere   = " WHERE Serial_Number_Inventory.Serial_Flag = '" + lsSerialFlag + "' and Serial_Number_Inventory.do_no = '" + lsSerialDoNo + "' "  
				lsSql = lsSqlSyntax + lsWhere
				
				i = ldw_serial.SetSqlSelect(lsSql)
				If i <> 1 Then
					MessageBox("Error Retrieving Serial Numbers","An error has been encountered when setting SerialFlag and DoNo. ~r~n~r~n" + lsSql)
					This.TriggerEvent("ue_close")
				End If
				ldSNRowCount = ldw_serial.retrieve()
			End If
		End If
	End If

End If

//GailM 10/28/2019 DE13105 Google - Outbound - If user assigns only a container ID for GPNs, the serial tab won$$HEX1$$1920$$ENDHEX$$t scan the Container ID
//     A footprint GPN cannot have a dash "-" in the pallet or container ID to be considered a footprint
If f_is_sku_foot_print(lsSKU,'PANDORA') Then
	If lsPalletId = '-' Or lsCartonNo = '-' Then
		lsMsg   = "Pallet/Carton invalid for Footprint GPN~r~n" 
		lsMsg += "A dash (-) in pallet or carton cannot be processed.~r~n"
		lsMsg += "Mixed containerization requires " + isFootPrintBlankInd + " be assigned to a ~r~n"
		lsMsg += "pallet and or carton to be considered a footprint GPN.~r~n" 
		lsMsg += "Please change prior to adding to Serial# Tab."
		w_do.tab_main.tabpage_serial.sle_barcodes.Text = ""
		doDisplayMessage('Invalid Pallet or Carton Scan', lsMsg)
		Return -1
	End If
End If

if lsCartonNo = isFootPrintBlankInd or lsPalletId = isFootPrintBlankInd Then lsMixedContainerization = "Y"
	
if ls_ctype = 'Pallet' Then
	SELECT SUM(content_summary.alloc_qty) INTO :ldContentQty FROM content_summary WHERE ( content_summary.project_id = 'PANDORA' ) AND ( content_summary.po_no2 = :lsPalletId )   ;

	If ldContentQty<>ldPickQty then 
		//this should be a redundant check since we should not have allocated it in during pick generate)
		w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
		doDisplayMessage('Invalid Scan', "Pallet ID '" + lsPalletId + "'cannot be saved.  The pallet quantity in inventory does not match the Picked Quantity and Partial Pallets cant be shipped.~r~n Please delete this Pick List and adjust the inventory")
		Return -1
	End If
	
	 //GailM 9/5/2019 S37769 F17337 I1304 Google Footprints GPN Conversion Process
	lsSqlSyntax = ldw_serial.GetSqlSelect()
	lsWhere   = " WHERE Serial_Number_Inventory.Project_id = '" + gs_project + "' and Serial_Number_Inventory.po_no2 = '" + lsPalletId + "' "  
	lsSql = lsSqlSyntax + lsWhere
	
	i = ldw_serial.SetSqlSelect(lsSql)
	If i <> 1 Then
		MessageBox("Error Retrieving Serial Numbers","An error has been encountered when setting the serial number validate query. ~r~n~r~n" + lsSql)
		This.TriggerEvent("ue_close")
	End If

	ldSNRowCount = ldw_serial.retrieve('PANDORA', lsPalletId)
	If ldSNRowCount <= 0 Then 
		doDisplayMessage('Invalid Scan', "PALLET ID Cannot be found in the Serial Inventory Table." )
		Return -1
	End If
	
	If ldSNRowCount <> ldPickQty Then
		doDisplayMessage('Invalid Scan', "PALLET ID Not all serial number can be found in the Serial Inventory Table." )
		Return -1	
	End If
End If

If lsPalletId <> isFootPrintBlankInd Then			//NonMixed containerization
	if ls_ctype = 'Carton' Then
		SELECT SUM(content_summary.alloc_qty) INTO :ldContentQty FROM content_summary WHERE ( content_summary.project_id = 'PANDORA' ) AND ( content_summary.po_no2 = :lsPalletId )   ;
	
		If ldContentQty<>ldPickQty then 
			//this should be a redundant check since we should not have allocated it in during pick generate)
			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
			doDisplayMessage('Invalid Scan', "Carton ID '" + lsPalletId + "'cannot be saved.  The pallet quantity in inventory does not match the Picked Quantity and Partial Pallets cannot be shipped.~r~n Please delete this Pick List and adjust the inventory")
			Return -1
		End If
		
		 //GailM 9/5/2019 S37769 F17337 I1304 Google Footprints GPN Conversion Process
		lsSqlSyntax = ldw_serial.GetSqlSelect()
		lsWhere   = " WHERE Serial_Number_Inventory.Project_id = '" + gs_project + "' and Serial_Number_Inventory.carton_id = '" + lsCartonNo + "' "  
		lsSql = lsSqlSyntax + lsWhere
		
		i = ldw_serial.SetSqlSelect(lsSql)
		If i <> 1 Then
			MessageBox("Error Retrieving Serial Numbers","An error has been encountered when setting the serial number validate query. ~r~n~r~n" + lsSql)
			This.TriggerEvent("ue_close")
		End If

		ldSNRowCount = ldw_serial.retrieve('PANDORA', lsCartonNo)
		If ldSNRowCount <= 0 Then 
			doDisplayMessage('Invalid Scan', "CONTAINER ID Cannot be found in the Serial Inventory Table." )
			Return -1
		End If
		
		If ldSNRowCount <> ldPickQty Then
			doDisplayMessage('Invalid Scan', "CONTAINER ID Not all serial number can be found in the Serial Inventory Table." )
			Return -1	
		End If
	End If
Else
	If lsCartonNo <> isFootPrintBlankInd Then
		SELECT SUM(content_summary.alloc_qty) INTO :ldContentQty FROM content_summary WHERE ( content_summary.project_id = 'PANDORA' ) AND ( content_summary.container_id = :lsCartonNo )   ;
	
		If ldContentQty<>ldPickQty and ldPickQty > 0 then 
			//this should be a redundant check since we should not have allocated it in during pick generate)
			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
			doDisplayMessage('Invalid Scan', "Pallet ID '" + lsPalletId + "'cannot be saved.  The pallet quantity in inventory does not match the Picked Quantity and Partial Pallets cant be shipped.~r~n Please delete this Pick List and adjust the inventory")
			Return -1
		End If
		
		//Mixed Containerization - PalletId is a footprint blank indicator
		ldw_serial.DataObject = 'd_serial_inventory_container'
		ldw_serial.SetTransObject(SQLCA)
		ldSNRowCount = ldw_serial.retrieve('PANDORA', lsCartonNo)
		If ldSNRowCount <= 0 Then 
			doDisplayMessage('Invalid Scan', "CARTON ID Cannot be found in the Serial Inventory Table." )
			Return -1
		End If
	End If
	
End If

ldtToday = f_getLocalWorldTime(ldw_serial.GetItemString(1, 'wh_code') ) 

For i = 1 to ldSNRowCount
	lsSerialFlag = ldw_serial.getItemString(i, 'serial_flag')
	lsSerialDoNo = ldw_serial.getItemString(i, 'do_no')
	lsSKU = ldw_serial.getItemString(i, 'Sku')
	lsContainer = ldw_serial.getItemString(i, 'carton_id')		//GailM 4/27/2018 - SIMS release 18.3.2
	lsFind =  "Upper(sku) = '" + Upper(lsSKU) + "' and (isnull(serial_no) or serial_no = '') and container_id = '" + lsContainer + "' "
	llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
		
	If llFindRow > 0 Then
			
		w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(llFindRow)
//		w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'carton_no',lsCartonNo)
		If lsPalletId = isFootPrintBlankInd Then	//Mixed Containerization
			If lsCartonNo = isFootPrintBlankInd Then
				//Get a unique carton no for free serial no
				lsCartonId = w_do.tab_main.tabpage_serial.sle_carton_no.text
				If lsCartonId <> '' and lsCartonId <> 'NA' Then
					w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'carton_no',lsCartonId)
				Else
					doDisplayMessage('Invalid Scan', "Could not assign a Carton No for this serial number.  Footprint mixed containerization has pallet and container blank." )
				End If
			Else
				w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'carton_no',lsCartonNo)
			End If
		Else
			w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'carton_no',lsPalletId)
		End If
		w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'serial_no',ldw_serial.getItemString(i, 'serial_no'))
		w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'quantity',1)
		
	Else /* no empty rows, add a new row - Copy from another row for SKU*/
				
		lsFind =  "Upper(sku) = '" + Upper(lsSKU) + "'"
		llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
		
		If llFindRow > 0 Then /* exists for SKU, Copy Row and set serial*/
			
			w_do.tab_main.tabpage_serial.dw_serial.RowsCopy(llFindRow,llFindRow,Primary!, w_do.tab_main.tabpage_serial.dw_serial,9999999,primary!) /*add at end*/
			w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(w_do.tab_main.tabpage_serial.dw_serial.RowCount())
			If lsPalletId <> isFootPrintBlankInd Then
				w_do.tab_main.tabpage_serial.dw_serial.setItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'carton_no',lsPalletId)
			ElseIf lsCartonNo <> isFootPrintBlankInd Then 
				w_do.tab_main.tabpage_serial.dw_serial.setItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'carton_no',lsCartonNo)
			Else
				w_do.tab_main.tabpage_serial.dw_serial.setItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'carton_no','')
			End If
			w_do.tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'serial_no',ldw_serial.getItemString(i, 'serial_no'))
			w_do.tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'quantity',1)
		
		Else /*SKU NOt found on Serial Tab*/
		
			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
			doDisplayMessage('SKU Not Found', "SKU: '" + lsSKU + "' not found on Pick List for this Container." )
			Return -1
			
		End If
				
	End If
	
	//GailM DE6145 Populate SerialFlag and DoNo for this record.
	ldw_serial.SetItem(i, 'Serial_Flag','P' )
	ldw_serial.SetItem(i, 'Do_No', gs_system_no )		//Would this always true?
	ldw_serial.SetItem(i, 'Update_Date', ldtToday )
	ldw_serial.SetItem(i, 'Update_User',gs_userid ) 
	ldw_serial.SetItem(i, 'Transaction_Type','Set serial no flag to Y on serial tab insert' )
	ldw_serial.SetItem(i, 'Transaction_Id', gs_system_no )
	
	w_do.ib_Changed = True
Next

If w_do.ib_Changed Then
	Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
	llRC = ldw_serial.Update()
	If llRC = 1 Then
		Execute Immediate "COMMIT" using SQLCA;
	Else
		Execute Immediate "ROLLBACK" using SQLCA;
		lsMsg = "Unable to Update Serial Number Inventory Record with serial flag and do_no!~r~r"
			If Not isnull(SQLCA.SQLErrText) Then /*if errtext is null, we get no msg - datastores dont return error codes like DW's*/
				lsMsg += SQLCA.SQLErrText
			End If
			MessageBox("Scan Pandora IP process in Carton Serial Scanning module", lsMsg)
	End If	
End If

//if lsCartonNo <> isFootPrintBlankInd and lsPalletId <> isFootPrintBlankInd Then		//Footprint SerialNo Only
//	w_do.tab_main.tabpage_serial.sle_carton_no.text = lsPalletId
//	w_do.tab_main.tabpage_serial.st_carton_no_t.text = 'PALLET ID:'
//End If

w_do.SetMicroHelp("Ready")


Return 0
end function

public function integer uf_do_scan_pandora (string assupplier);//Process DO scans for Pandora

String	lsScan, lsFind, lsContainer, lsCarton,lsLineItemNo,ls_ctype,lsCartonId, lsSKU,lsSUpplier
String ls_SerializedInd,ls_PONO2ControlledInd,ls_ContainerTrackingInd
Long		llFindRow, llContainerQty, llCartonQty, llScanQty,ll_cs_rows, row, i_ndx, llRtn, llSerialRow
Boolean lbLpn, lbFootprint, lbCntrSerial
lbLpn = False
lbFootprint = False
lbCntrSerial = False

//See if we scanned a Pallet
lsScan = w_do.tab_main.tabpage_serial.sle_barcodes.Text
row = w_do.idw_serial.getrow()
lsSKU = w_do.idw_serial.getitemstring(row, "sku")
ilSerialRowNo = row

//Ensure row has not been filled already
//lsFind = "IsNull(serial_no)"
//llFindRow = w_do.idw_serial.Find(lsFind, 1, w_do.idw_serial.rowcount())
//If llFindRow <> row Then		//Row should be changed
//	row = llFindRow
//	lsSKU = w_do.idw_serial.getitemstring(row, "sku")
//End If

//TimA 12/05/13 Determine is LPN Order
//TAM 2018/02 - S14383 - get supplier passed in.
//lsSupplier = w_do.tab_main.tabpage_pick.dw_pick.GetITemString(row,"supp_code")
lsSupplier = asSupplier
Select Serialized_Ind, PO_NO2_Controlled_Ind, Container_Tracking_Ind 
	Into :ls_SerializedInd, :ls_PONO2ControlledInd, :ls_ContainerTrackingInd
From Item_Master
Where project_id = :gs_project and sku = :lsSKU and supp_code = :lsSUpplier;	

//10SEPT-2018 :MEA S23046 F9270 - I1304 - Google - SIMS Footprints Containerization - Outbound
//Use Foot_Prints_Ind Flag

If f_is_sku_foot_print(lsSKU,lsSUpplier) Then
	lbLpn = True
	lbFootprint = True
ElseIf  ls_SerializedInd = 'B' and ls_PONO2ControlledInd = 'N' and ls_ContainerTrackingInd = 'Y' then	//GailM 2/20/2018 DE3189
	lbCntrSerial = True
End if

If row > 0 Then
	lsLineItemNo = string(w_do.idw_serial.GetItemNumber(row,"line_item_no")) 
End If

w_do.SetMicroHelp("Checking serial numbers.  Please wait..")

//TAM = 2018/01 - Footprint - Override existing LPN validation and call new validation
If lbFootprint = True Then llRtn = This.uf_do_scan_Pandora_Ip( lsScan )
If lbCntrSerial = True Then llRtn = This.uf_do_scan_Pandora_Cntr( lsScan )  //GailM 2/20/2018 DE3189

	If  llRtn < 0 Then
		return 1
	Else
		return 0
	End If
	
	

//TimA 08/16/13 Pandora LPN project
If Not isValid(idw_carton_serial) Then
	idw_carton_serial = Create DAtastore
	idw_carton_serial.DataObject = 'd_carton_serial_validate'
	idw_carton_serial.SetTransObject(SQLCA)
	//isOrigSql = idsSerial.GetSQLSelect()
End If

idw_carton_serial.Reset()
ll_cs_rows = idw_carton_serial.Retrieve(gs_project, lsScan)
if ll_cs_rows = 0 then
	messagebox("Find LPN serial numbers","No serial numbers found for " + string(lsScan))
	w_do.tab_main.tabpage_serial.dw_serial.SetItem(row, 'Serial_no', '-')  // blank out the scanned data
	w_do.tab_main.tabpage_serial.dw_serial.SelectText(1,1)
	return 1
else
	ls_ctype = idw_carton_serial.GetItemString(1,'c_type')
	if ls_ctype = 'S' and idw_carton_serial.rowcount( ) = 1 then
		//Until Pandora desides on what to do with serial numbers on pallets that might be spit we are not allowing
		//of scanning serial numbers
		messagebox("Serial numbers Error","Serial Numbers are not allowed to be scanned on LPN tpe SKU's ")
		Return 1
		//This.SetItem(row,'Serial_no',idw_carton_serial.GetItemString(1,'serial_no'))
		//This.SetItem(llFindRow,"quantity",idw_carton_serial.GetItemnumber(1,"carton_qty"))
	elseif ls_ctype = 'C' then
			lsCartonId = idw_carton_serial.GetItemString(1,"carton_id")
			llCartonQty = Dec(idw_carton_serial.GetItemNumber(1,"carton_qty"))
		If This.uf_do_scan_Pandora(w_do.tab_main.tabpage_serial.dw_serial.GetITemString(row,'sku'),lsCartonId, row,ls_ctype) < 0 Then
			Return 1
		else
			lsFind = "(serial_no = '-' or IsNull(serial_no)) and SKU = '" + lsSKU + "' and line_item_no = " + lsLineItemNo
			llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
			if llFindRow > 0 then
				w_do.tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,"serial_no", lsCartonId)
				w_do.tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,"quantity",llCartonQty)
			end if							

		End if
		//lsFind = "(serial_no = '-' or serial_no = '" + data + "') and container_id = '" + data + "' and line_item_no = " + lsLineItemNo
		//for i_ndx = 1 to ll_cs_rows
		//	llFindRow = This.Find(lsFind,1,This.RowCount())
		//	if llFindRow > 0 then
		//		This.SetItem(llFindRow,"serial_no",idw_carton_serial.GetItemString(i_ndx,"carton_id"))
		//		This.SetItem(llFindRow,"quantity",idw_carton_serial.GetItemnumber(i_ndx,"carton_qty"))
		//	end if
		//next	
	elseif ls_ctype = 'P' then
		for i_ndx = 1 to ll_cs_rows
			//TimA 12/05/13 On LPN order use the pallet_id field
			If lbLpn = True then
				lsCartonId = idw_carton_serial.GetItemString(i_ndx,"pallet_id")
			Else				
				lsCartonId = idw_carton_serial.GetItemString(i_ndx,"carton_id")
			End if
			llCartonQty = Dec(idw_carton_serial.GetItemNumber(i_ndx,"carton_qty"))
						
			If This.uf_do_scan_Pandora(lsSKU,lsCartonId, row,ls_ctype) < 0 Then
				Return 1
			else
				lsFind = "(serial_no = '-' or IsNull(serial_no)) and SKU = '" + lsSKU + "' and line_item_no = " + lsLineItemNo
				llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
				if llFindRow > 0 then
					w_do.tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,"serial_no", lsCartonId)
					w_do.tab_main.tabpage_serial.dw_serial.SetItem(llFindRow,"quantity",llCartonQty)
				end if
			End if
		next
	else
		messagebox("Find LPN serial numbers","Error in detail for:  " + string(lsScan))
		w_do.tab_main.tabpage_serial.dw_serial.SetItem(row, 'Serial_no', '-')  // blank out the scanned data
		w_do.tab_main.tabpage_serial.dw_serial.SelectText(1,1)
		return 1
	end if
		
	lsFind = "IsNull(serial_no)"
	//lsFind = "serial_no = '-'"
	llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())	// Find next blank SN
	if llFindRow > 0 then
		w_do.tab_main.tabpage_serial.dw_serial.scrolltorow(llFindRow)
	end if
	w_do.SetMicroHelp("Ready")
	return 1
End if		
	w_do.SetMicroHelp("Ready")				


//**********************************************************************

 //The Above code replaces all this below.
 
 
 
 
////First see if we have scanned this pallet/carton before...
//If w_do.tab_main.tabpage_serial.dw_serial.RowCount() > 0 Then
//	If w_do.tab_main.tabpage_serial.dw_serial.Find("Serial_No = '" + lsScan + "'",1,w_do.tab_main.tabpage_serial.dw_serial.RowCount()) > 0 Then
//		doDisplayMessage('Invalid Scan', "CONTAINER ID has already been scanned." )
//		Return -1
//	End If
//End If
//
////TimA 07/30/13 as of this date there are no record in Carton_Serial.  Use Serial Number Inventory
//Select Min(SKU), Count(*) into :lsSKU, :llContainerQty 
//From Carton_Serial
//Where Project_id = 'PANDORA' and Carton_Id = :lsScan;
//
////Select Min(SKU), Count(*) into :lsSKU, :llContainerQty 
////From Serial_Number_Inventory
////Where Project_id = 'PANDORA' and Carton_Id = :lsScan;
//
//If lsSku > '' Then /*Container Exists*/
//
//	//Make sure this pallet is what was actually picked
//	llFindRow = w_do.idw_Pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Container_Id) = '" + Upper(lsScan) + "'",1, w_do.idw_Pick.RowCount())
//	If llFindRow <= 0 Then
//		
//		w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
//		doDisplayMessage('Container Scanned', "Container ID not found on Pick List.~r~nPlease correct Pick List and re-scan." )
//		Return -1
//		
//	Else /* make sure a full Container was picked, otherwise,they need to be scanning Cartons */
//		
//		If w_do.idw_Pick.GetITemNumber(llFindRow,'quantity') <> llContainerQty Then
//			
//			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
//			doDisplayMessage('Container Scanned', "Container ID: '" + lsScan + "' was not picked in it's entirety.~r~nContainer ID's or Individual Serial Numbers must be scanned for this Pallet." )
//			Return -1
//			
//		End If
//		
//	End If /*Container not found on Picking List*/
//
//	lsContainer = lsScan
//	llScanQty = llContainerQty /*Container Qty will be set on Serial record for validating at confirmation that all were entered*/
//	w_do.tab_main.tabpage_serial.st_message.Text = "CONTAINER Scanned."
//	
////Else /* Not a pallet, see if we scanned a carton*/
////
////	Select Min(SKU), Min(Pallet_id), Count(*)  into :lsSKU, :lsContainer, :llCartonQty
////	From Carton_Serial
////	Where Project_id = 'COMCAST' and Carton_id = :lsScan;
////
////	If lsContainer > '' Then /*carton Exists */
////	
////		//Make sure this pallet is what was actually picked
////		llFindRow = w_do.idw_Pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Lot_No) = '" + Upper(lsContainer) + "'",1, w_do.idw_Pick.RowCount()) 
////		If llFindRow = 0 Then
////		
////			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
////			doDisplayMessage('Carton Scanned', "Pallet ID: '" + lsContainer + "' not found on Pick List for this CARTON.~r~nPlease correct Pick List and re-scan." )
////			Return -1
////			
////		Else /* Make sure we haven't already scanned a pallet that this caarton is contained in */
////			
////			If w_do.tab_main.tabpage_serial.dw_serial.find("Serial_No = '" + lsContainer + "'",1,w_do.tab_main.tabpage_serial.dw_serial.RowCount()) > 0 Then
////				
////				w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
////				doDisplayMessage('Carton Scanned', "Pallet ID: '" + lsContainer + "' has already been scanned for this CARTON." )
////				Return -1
////		
////			 End IF
////				
////		End If /*Pallet not found on Picking List*/
////		
////		llScanQty = llCartonQty /*Carton Qty will be set on Serial record for validating at confirmation that all were entered*/
////		w_do.tab_main.tabpage_serial.st_message.Text = "CARTON Scanned."
////	
////	Else /* Not a Pallet or Carton Scan - Check for an Individual Serial Number scan*/
////		
////		Select Min(SKU), Min(Pallet_id), Min(carton_id)  into :lsSKU, :lsContainer, :lsCarton
////		From Carton_Serial
////		Where Project_id = 'COMCAST' and serial_no = :lsScan;
////		
////		If lsContainer > '' Then /*Serial Number Exists */
////		
////			//Make sure this pallet is what was actually picked
////			llFindRow = w_do.idw_Pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Lot_No) = '" + Upper(lsContainer) + "'",1, w_do.idw_Pick.RowCount()) 
////			If llFindRow = 0 Then
////		
////				w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
////				doDisplayMessage('Serial Scanned', "Pallet ID: '" + lsContainer + "' not found on Pick List for this SERIAL NUMBER.~r~nPlease correct Pick List and re-scan." )
////				Return -1
////			
////			Else /* Make sure we haven't already scanned a pallet or Carton that this Serial is contained in */
////			
////				If w_do.tab_main.tabpage_serial.dw_serial.find("Serial_No = '" + lsContainer + "'",1,w_do.tab_main.tabpage_serial.dw_serial.RowCount()) > 0 Then
////				
////					w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
////					doDisplayMessage('Carton Scanned', "Pallet ID: '" + lsContainer + "' has already been scanned for this SERIAL NUMBER." )
////					Return -1
////		
////				End IF
////				
////				If w_do.tab_main.tabpage_serial.dw_serial.find("Serial_No = '" + lsCarton + "'",1,w_do.tab_main.tabpage_serial.dw_serial.RowCount()) > 0 Then
////				
////					w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
////					doDisplayMessage('Carton Scanned', "Carton ID: '" + lsCarton + "' has already been scanned for this SERIAL NUMBER." )
////					Return -1
////		
////				End IF
////				
////			End If /*Pallet not found on Picking List*/
////			
////			llScanQty = 1
////			w_do.tab_main.tabpage_serial.st_message.Text = "SERIAL NUMBER Scanned."
////		
////		Else /*invalid Serial Number*/
////			
////			w_do.tab_main.tabpage_serial.st_message.Text = "** Invalid Scan **"
////		
////			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
////			doDisplayMessage('Invalid Scan', "Serial Number information for this Pallet/Carton has not been received from Comcast.~r~nUnable to process Serial Number." )
////			Return -1
////			
////		End If
////		
////	End If
////	
//End If
//
////Find the first empty row for this scan. If no empty row, add a new one.
//lsFind = "Upper(sku) = '" + Upper(lsSKU) + "' and (isnull(serial_no) or serial_no = '')"
//llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
//		
//If llFindRow > 0 Then
//			
//	w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(llFindRow)
//	w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'serial_no',lsScan)
//	w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'quantity',llScanQty)
//		
//Else /* no empty rows, add a new row - Copy from another row for SKU*/
//			
//	lsFind = "Upper(sku) = '" + Upper(lsSKU) + "'"
//	llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
//		
//	If llFindRow > 0 Then /* exists for SKU, Copy Row and set serial*/
//			
//		w_do.tab_main.tabpage_serial.dw_serial.RowsCopy(llFindRow,llFindRow,Primary!, w_do.tab_main.tabpage_serial.dw_serial,9999999,primary!) /*add at end*/
//		w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(w_do.tab_main.tabpage_serial.dw_serial.RowCount())
//		w_do.tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'serial_no',lsScan)
//		w_do.tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'quantity',llScanQty)
//		
//	Else /*SKU NOt found on Serial Tab*/
//		
//		w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
//		doDisplayMessage('SKU Not Found', "SKU: '" + lsSKU + "' not found on Pick List for this Container." )
//		Return -1
//			
//	End If
//				
//End If
//
//w_do.ib_Changed = True

Return 0
end function

public function integer uf_do_scan_pandora_cntr (string asscan);//Process DO scans for Pandora container tracked, serialized both 

String	lsScan, lsSKU, lsFind, lsContainer, lsLineItemNo,ls_ctype,lsCartonId, ls_sku,lsSUpplier
String ls_Filter, lsPalletId,  lsSerialNo,lsCartonNo
Long	i, j, llFindRow, llContainerQty, llCartonQty, ldPickQty, ldPickCount, ldSNRowCount, ldContentQty
Int liRtn = 1
String ls_sql_syntax, ERRORS, ls_where_clause, new_sql_syntax, lsMessage
datetime ldtToday

DataStore ldw_serial

If Not isValid(ldw_serial) Then
	ldw_serial = Create DAtastore
	ldw_serial.DataObject = 'd_serial_inventory_container'
	ldw_serial.SetTransObject(SQLCA)
End If

ldtToday = f_getLocalWorldTime(ldw_serial.GetItemString(1, 'wh_code') ) 

// Check if the value scanned is a Container
lsFind = "Upper(container_id) = '" + Upper(asScan) + "'"
llFindRow = w_do.idw_Pick.Find(lsFind,1, w_do.idw_Pick.RowCount())

If llFindRow > 0 Then 
	lsContainer = w_do.idw_Pick.GetITemString(llFindRow,'container_id' )
Else
	
	// Check if the value scanned is a serial Number 
	Select  carton_id, Serial_No, sku 
	into :lsContainer, :lsSerialNo, :lsSku
	From Serial_Number_Inventory WITH (NOLOCK)
	Where Project_id = 'PANDORA' and Serial_No = :asScan;
	
	If lsContainer ='' or isNull(lsContainer) or lsContainer = '-' then //Error - Scanned value not found or is invalid
		w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
		doDisplayMessage('Invalid Scan', 'Scanned Value "' + asScan + '" was not associated with a Container on the Picking list.~r~nPlease correct Pick List and re-scan or scan a different code'  )
		Return -1

	Else//Container found, now, make sure it was actually picked

		lsFind = "Upper(container_id) = '" + Upper(lsContainer) + "'"
		llFindRow = w_do.idw_Pick.Find(lsFind,1, w_do.idw_Pick.RowCount())
		If llFindRow <= 0 Then //Error - Wrong value scanned
			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
			doDisplayMessage('Invalid Scan', "Scanned Value '" + asScan + "' was not associated with a Container on the Picking list.~r~nPlease correct Pick List and re-scan or scan a different code" )
			Return -1
		Else
			If lsSerialNo = asScan Then		//This is a serial number.  
			//	lsSKU = ldw_serial.getItemString(i, 'Sku')
				lsFind =  "Upper(sku) = '" + Upper(lsSKU) + "' and (isnull(serial_no) or serial_no = '')"
				llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
					
				If llFindRow > 0 Then
						
					w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(llFindRow)
					w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'carton_no',lsContainer)
					w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'serial_no', lsSerialNo )
					w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'quantity',1)
					//liRtn = 0		//Completed
					Return -1
				Else
					// Do you need to generate rows?
					doDisplayMessage('Serial Number Scanning', "No more rows for this SKU." )
					Return -1
				End If
			End If
			
		End If // Serial number scanned
	End If // Container Found
End If //Container


ldSNRowCount = ldw_serial.Retrieve( gs_Project, lsContainer )
IF SQLCA.sqlcode <> 0 THEN
	doDisplayMessage('Serial Number Retrieval Error', "Unable to retrive serial numbeer list :~n " + SQLCA.SQLErrText)
	return -1
End If

If liRtn = 1 Then		/* Move on to process container */
	If ldSNRowCount > 0 Then
		If w_do.tab_main.tabpage_serial.dw_serial.RowCount() > 0 Then 
			lsFind = "Upper(Carton_No) = '" + Upper(lsContainer) + "'"
			If w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount()) > 0 Then //
		
					doDisplayMessage('Invalid Scan', "Container has already been scanned." )
					Return -1
			End If
		End If
		ls_Filter = "container_id = '" + lsContainer + "'"
		w_do.idw_Pick.SetFilter(ls_filter)
		w_do.idw_Pick.Filter()
		
		ldPickQty = 0
		ldPickCount =w_do.idw_Pick.RowCount()
		
		for j = 1 to ldPickCount
			ldPickQty = ldPickQty + w_do.idw_Pick.Getitemnumber( j, 'quantity')
		Next
	
		//Remove Filters
		w_do.idw_Pick.SetFilter('' )
		w_do.idw_Pick.Filter()
		
		SELECT SUM(content_summary.alloc_qty) INTO :ldContentQty FROM content_summary WHERE ( content_summary.project_id = 'PANDORA' ) AND ( content_summary.container_id = :lsContainer )   ;
		
		If ldContentQty<>ldPickQty then 
			//this should be a redundant check since we should not have allocated it in during pick generate)
			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
			doDisplayMessage('Invalid Scan', "Container ID '" + lsContainer + "'cannot be saved.  The container quantity in inventory does not match picked quantity.  Cannot scan by container in Serial# tab for partial containers.~r~n Please scan serial numbers individually through manual entry.")
			Return -1
		End If
		
		If ldPickQty < ldSNRowCount then
			// If the number picked is less that the container SN count then report that only full containers can be shipped.  Break the container.
			w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
			lsMessage = "Container ID '" + lsContainer + " 'cannot be saved.  The Container has more serial records ( " + String( ldSNRowCount )  + " ) than the number picked.~r~n.~r~n" +&
				"Please scan the serial numbers individually.~r~n"
			doDisplayMessage('Scan Container Mismatch', lsMessage )
			Return -1
		End If
		
		w_do.SetMicroHelp("Ready")
	
		For i = 1 to ldSNRowCount
			//
			lsSKU = ldw_serial.getItemString(i, 'Sku')
			lsFind =  "Upper(sku) = '" + Upper(lsSKU) + "' and (isnull(serial_no) or serial_no = '') and container_id = '" + lsContainer + "' "
			llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
				
			If llFindRow > 0 Then
					
				w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(llFindRow)
				w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'carton_no',lsContainer)
				w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'serial_no',ldw_serial.getItemString(i, 'serial_no'))
				w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'quantity',1)
				
			Else /* no empty rows, add a new row - Copy from another row for SKU*/
						
				lsFind =  "Upper(sku) = '" + Upper(lsSKU) + "'"
				llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
				
				If llFindRow > 0 Then /* exists for SKU, Copy Row and set serial*/
					
					w_do.tab_main.tabpage_serial.dw_serial.RowsCopy(llFindRow,llFindRow,Primary!, w_do.tab_main.tabpage_serial.dw_serial,9999999,primary!) /*add at end*/
					w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(w_do.tab_main.tabpage_serial.dw_serial.RowCount())
					w_do.tab_main.tabpage_serial.dw_serial.setItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'carton_no',lsContainer)
					w_do.tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'serial_no',ldw_serial.getItemString(i, 'serial_no'))
					w_do.tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'quantity',1)
				
				Else /*SKU NOt found on Serial Tab*/
				
					w_do.tab_main.tabpage_serial.sle_barcodes.SelectText(1,len(w_do.tab_main.tabpage_serial.sle_barcodes.Text))
					doDisplayMessage('SKU Not Found', "SKU: '" + lsSKU + "' not found on Pick List for this Container." )
					Return -1
					
				End If
						
			End If
			
			//GailM s33409 Populate SerialFlag and DoNo for this record.
			ldw_serial.SetItem(i, 'Serial_Flag','P' )
			ldw_serial.SetItem(i, 'Do_No', gs_system_no )		//Would this always true?
			ldw_serial.SetItem(i, 'Update_Date', ldtToday )
			ldw_serial.SetItem(i, 'Update_User',gs_userid ) 
			ldw_serial.SetItem(i, 'Transaction_Type','Set serial no flag to Y on serial tab insert' )
			ldw_serial.SetItem(i, 'Transaction_Id', gs_system_no )
					
			w_do.ib_Changed = True
		Next
		liRtn = -1		//Erases scanned container
	Else
		doDisplayMessage( 'Serial Data' , 'No records found in serial number inventory for this container~n~n'  + ls_sql_syntax  )
		liRtn = -1
	End If
End If

If w_do.ib_Changed Then
	Execute Immediate "Begin Transaction" using SQLCA; 
	liRtn = ldw_serial.Update()
	If liRtn = 1 Then
		Execute Immediate "COMMIT" using SQLCA;
	Else
		Execute Immediate "ROLLBACK" using SQLCA;
		lsMessage = "Unable to Update Serial Number Inventory Record with serial flag and do_no!~r~r"
			If Not isnull(SQLCA.SQLErrText) Then /*if errtext is null, we get no msg - datastores dont return error codes like DW's*/
				lsMessage += SQLCA.SQLErrText
			End If
			MessageBox("Scan Pandora Container process in Carton Serial Scanning module", lsMessage)
	End If	
End If

Return liRtn
end function

public function integer getpalletqty (string asdono, string aspallet);/* Return pick list pallet quantity for multiple container rows */
int liQty = 0

Select sum(quantity) into :liQty from delivery_picking with (nolock)
where do_no = :asDoNo and po_no2 = :asPallet
using sqlca;


return liQty

end function

public function integer getcontainerqty (string asdono, string aspallet, string ascontainer);/* Return pick list pallet/container quantity for multiple container rows */
int liQty = 0

Select sum(quantity) into :liQty from delivery_picking with (nolock)
where do_no = :asDoNo and po_no2 = :asPallet and container_id = :ascontainer
using sqlca;


return liQty

end function

public function integer uf_pandora_load_sn_for_picked_containers ();//01/20 - PCONKL - For Pandora, we want to loop through the Pick List and load the SNs for Footprint COntainers that have already been validated. There's no need to scan them twice.
//						 If there are any validation issues, we jsut won't load them

String	 lsSKU, lsFind, lsSerialContainer,  ls_sku, lsDoNo,lsSKUPrev,lsFootPrintInd, lsPickContainer,lsSerialFlag,lsSerialDoNo  
String  lsSerialNo
Long	i, j, llRC, llFindRow, ldSNRowCount,llPickPos, llPickRowCount
DataStore ldw_serial
datetime ldtToday
Boolean	lbSerialsUpdated, lbSerialLoadError,lbFootprintsExist

ldw_serial = Create Datastore
ldw_serial.DataObject = 'd_serial_inventory_container'
ldw_serial.SetTransObject(SQLCA)

lbSerialLoadError = False
lbFootprintsExist = False
ldtToday = f_getLocalWorldTime(ldw_serial.GetItemString(1, 'wh_code') )

//Loop through each Picking record and if Footprints and a Container ID is present and has been validated, load the SN's so the container ID's don't have to be scanned
llPickRowCount =  w_do.idw_Pick.RowCount()
For llPickPos = 1 to llPickRowCount
	
	lbSerialsUpdated = False 
	lsPickContainer = w_do.idw_Pick.getItemString(llPickPos,'Container_ID')
	lsDONO = w_do.idw_Pick.getItemString(llPickPos,'do_no')
	
	If lsPickContainer = '-' or lsPickContainer = 'NA' Then Continue /* not a valid container ID or not container tracked*/
	
	If w_do.idw_Pick.getItemString(llPickPos,'Container_ID_scanned_ind') <> 'Y' Then Continue /*Container not validated on Pick tab*/
	
	ls_sku = w_do.idw_Pick.getItemString(llPickPos,'sku')
	
	If ls_Sku <> lsSKUPrev Then
		
		If f_is_sku_foot_print(ls_Sku,'PANDORA') Then
			lsFootPrintInd = 'Y'
			lbFootprintsExist = True
		Else
			lsFootPrintInd = 'N'
		End If
			
	End IF /*SKU changed*/
	
	lsSKUPrev = ls_Sku
	
	If lsFootPrintInd <> 'Y' Then Continue /* only supporting for Footrints for now */
	
	//Retrieve the SNs for this Container
	ldSNRowCount = ldw_serial.retrieve('PANDORA', lsPickContainer)
	
	//	If Serial Count doesn't equal Picked qty (assume only 1 pick row per container), don't load
	If ldSNRowCount <> w_do.idw_Pick.getItemNumber(llPickPos,'Quantity') Then 
		lbSerialLoadError = True
		Continue
	End If
	
	//Load the Serial Tab
	For i = 1 to ldSNRowCount
		
		lsSerialFlag = ldw_serial.getItemString(i, 'serial_flag')
		lsSerialDoNo = ldw_serial.getItemString(i, 'do_no')
		lsSKU = ldw_serial.getItemString(i, 'Sku')
		lsSerialContainer = ldw_serial.getItemString(i, 'carton_id')		
		
		lsFind =  "Upper(sku) = '" + Upper(lsSKU) + "' and (isnull(serial_no) or serial_no = '') and container_id = '" + lsSerialContainer + "' "
		llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
		
		If llFindRow > 0 Then
			
			w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(llFindRow)
			
			w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'serial_no',ldw_serial.getItemString(i, 'serial_no'))
			w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'carton_no',ldw_serial.getItemString(i, 'po_no2'))
			w_do.tab_main.tabpage_serial.dw_serial.setItem(llFindRow,'quantity',1)
				
		Else /* no empty rows, add a new row - Copy from another row for SKU*/
				
			lsFind =  "Upper(sku) = '" + Upper(lsSKU) + "'"
			llFindRow = w_do.tab_main.tabpage_serial.dw_serial.Find(lsFind,1,w_do.tab_main.tabpage_serial.dw_serial.RowCount())
		
			If llFindRow > 0 Then /* exists for SKU, Copy Row and set serial*/
			
				w_do.tab_main.tabpage_serial.dw_serial.RowsCopy(llFindRow,llFindRow,Primary!, w_do.tab_main.tabpage_serial.dw_serial,9999999,primary!) /*add at end*/
				w_do.tab_main.tabpage_serial.dw_serial.ScrollToRow(w_do.tab_main.tabpage_serial.dw_serial.RowCount())
				w_do.tab_main.tabpage_serial.dw_serial.setItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'container_id',lsSerialContainer)
				w_do.tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'serial_no',ldw_serial.getItemString(i, 'serial_no'))
				w_do.tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'carton_no',ldw_serial.getItemString(i, 'po_no2'))
				w_do.tab_main.tabpage_serial.dw_serial.SetItem(w_do.tab_main.tabpage_serial.dw_serial.RowCount(),'quantity',1)
				
			Else /*SKU NOt found on Serial Tab*/
		
				lbSerialLoadError = True
				continue
			
			End If
				
		End If
			
		ldw_serial.SetItem(i, 'Serial_Flag','P' )
		ldw_serial.SetItem(i, 'Do_No', lsDONO )	
		ldw_serial.SetItem(i, 'Update_Date', ldtToday )
		ldw_serial.SetItem(i, 'Update_User',gs_userid ) 
		ldw_serial.SetItem(i, 'Transaction_Type','Set serial no flag to Y on serial tab insert' )
		ldw_serial.SetItem(i, 'Transaction_Id', gs_system_no )
		lbSerialsUpdated = True
		w_do.ib_Changed = True
	
	Next /*Serial row */

	If lbSerialsUpdated Then
		
		//This may create a potential mismatch if we save here but the Serial Tab is not saved in w_do but technically they are already committed to these SNs unless they delete the pick list
		
		Execute Immediate "Begin Transaction" using SQLCA; 
		llRC = ldw_serial.Update()
		If llRC = 1 Then
			Execute Immediate "COMMIT" using SQLCA;
		Else
			Execute Immediate "ROLLBACK" using SQLCA;
			lbSerialLoadError = True
		End If	
	
	End If /* serial table updated*/
		
next /* Pick Row*/

w_do.SetMicroHelp("Ready")

If lbSerialLoadError Then
	Return -1
ElseiF lbFootprintsExist Then
	REturn 1
Else
	Return 0
End IF
end function

on u_nvo_carton_serial_scanning.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_carton_serial_scanning.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;idsPack 					=  f_datastorefactory("d_do_packing_grid")
idsPick						= f_datastoreFactory('d_do_picking')
idsparentskbychild		= f_datastoreFactory('d_getparentskubychild')





end event

event destructor;if isValid( idsPack ) then destroy( idsPack )
if isValid( idsPick ) then destroy( idsPick )
if isValid( idsparentskbychild ) then destroy( idsparentskbychild )


end event

