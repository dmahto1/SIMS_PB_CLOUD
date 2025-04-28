$PBExportHeader$u_nvo_proc_3com.sru
$PBExportComments$Process 3Com Files
forward
global type u_nvo_proc_3com from nonvisualobject
end type
end forward

global type u_nvo_proc_3com from nonvisualobject
end type
global u_nvo_proc_3com u_nvo_proc_3com

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsASNHeader,	&
				idsASNPackage,	&
				idsASNItem, &
				idsSupplier, &
				iu_ds, &
				idsOut, &
				idsboh, &
				iuds_serial, &
				idsDOHeader, &
				idsDODetail, &
				idsDONotes, &
				idsDOAddress, &
				idsItem, &
				idsGenImport, &
 				idsOutputDs, &
				idsSerialPrefix, &
				idsCartonByKeys, &
				idsDupCheck, &
				idsPONotes, &
				iuds_warranty_sku

u_nvo_edi_confirmations_3com	iu_confirm

// pvh - 08/02/05
constant string isDupMessage = "      Error! Data already exists in carton serial table. "
constant int success = 1
constant int failure = -1
long			ilOwnerId

protected:
string		isNextField
string		isRecData
string		isTranslatedSupplierCode
string		isProject
string 		isPalletBreak = "*"
string 		isCartonBreak = "*"
string 		isCarton
string 		isPallet
boolean 	ibPalletFailed
boolean 	ibCartonFailed
long			ilNewRow
// pvh - 03/31/06 - MARL
string marlchanges[]
string qholdchanges[]
datastore idsChanges


end variables

forward prototypes
public function integer uf_process_po (string aspath, string asproject)
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_dboh (string asinifile)
public function integer uf_vendor_po_update (string aspath, string asproject)
public function integer uf_po_reconciliation (string asinifile, string asactivityid, string asparmstring)
public function integer uf_daily_transaction_rpt (string asinifile, string asactivityid, string asparmstring)
public function integer uf_process_asn (string aspath, string asproject)
public function integer uf_process_serial_numbers (string aspath, string asproject)
public function string getnextfield ()
public subroutine setgenimportds (ref datastore asds)
public function datastore getgendsimport ()
public subroutine setoutputds (ref datastore asds)
public function datastore getoutputds ()
protected subroutine setnewrow (long asrow)
protected function long getnewrow ()
public function datastore getgenimportds ()
public subroutine setrecdata (string asdata)
public function string getrecdata ()
public function string gettranslatedsuppliercode ()
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer settranslatedsuppliercode (string assuppliercode)
protected function long getownerid ()
public function integer setnextfield (string aslabel, integer asfieldstart, integer asfieldlength)
public function integer setownerid (string asownercode, string asproject)
public function boolean dovalidateserialprefix (string asserialnumber, string assku, string assuppcode)
public subroutine setproject (string asproject)
public function string getproject ()
public subroutine setpalletbreak (string asbreak)
public subroutine setcartonbreak (string asbreak)
public function string getpalletbreak ()
public function string getcartonbreak ()
public subroutine setpallet (string aspallet)
public subroutine setcarton (string asctn)
public function string getcarton ()
public function string getpallet ()
public function boolean uf_checkforduplicates (string aspalletid, string ascartonid, string asserialnbr)
public subroutine setpalletfailed (boolean abool)
public subroutine setcartonfailed (boolean abool)
public function boolean getpalletfailed ()
public function boolean getcartonfailed ()
public subroutine dopalletbreak ()
public subroutine docartonbreak ()
public function boolean doserialdupcheck (string asserialnbr)
public subroutine dorejectpallet ()
public subroutine dorejectcarton ()
public subroutine docreatedatastores ()
public subroutine dodestroydatastores ()
public function long doindividualrowupdate ()
public subroutine setemailaddress (string avalue)
public function integer uf_process_itemmaster (string aspath, string asproject, string asini)
public subroutine dosendreport (string asini)
public subroutine setchange (string sku, string description, string oldvalue, string newvalue, datetime changedate, string supplier, string changetype)
public function integer uf_process_gls_rma_receipt (string aspath, string asproject)
public function integer uf_process_gls_po_receipt (string aspath, string asproject)
public function integer uf_process_gls_so (string aspath, string asproject)
public function integer uf_process_warranty_sku (string aspath, string asproject, string asini)
end prototypes

public function integer uf_process_po (string aspath, string asproject);//Process Inbound Purchase Order and RMA (Revenue side, not RMA side) order files for 3COM
			
// pvh - 08/29/05
//		rename idsDONotes to idsPONotes to end confusion.
//
String		lsLogout,lsRecData,lsRecType, lsWarehouse, lsOwner, lsSUppCode, lsSKU, lsCOO

Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos,llNewHeaderRow,llNewDetailRow, llNewAddressRow, llNewNotesRow, llOrderSeq, &
				llBatchSeq,	llLineSeq, llRC, llOwner, llCount
				
Decimal		ldQty, ldExistingQTY
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError

// pvh 08/24/05
// Make sure the datasources are set
idsPOHeader.dataobject= 'd_mercator_po_Header'
idsPOHeader.SetTransObject(SQLCA)
idsPOdetail.dataobject= 'd_mercator_po_Detail'
idsPOdetail.SetTransObject(SQLCA)
// eom - we needed to set them back to original.

// pvh - 08/22/05
// reset datastores
idsPOHeader.reset()
idsPODetail.reset()
idsPONotes.reset()
idsItem.reset()
// eom

ldtToday = DateTime(today(),Now())

//Open the File
lsLogOut = '      - Opening File for PO/RMA Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for 3COM Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//Warehouse will have to be defaulted from project master default warehouse
// 04/04 - PCONKL - should be receiving WH on file now to support multiple warehouses
Select wh_code into :lswarehouse
From Project
Where Project_id = :asProject;

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then 
	// pvh - 09/26/06 - empty error file
	lsLogOut = "-       ***Batch Sequence Number Error, EDI Inbound get next sequence. Project: " + asProject + ". Process Aborted."
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	FileClose(liFileNo)
	Return -1
end if

llOrderSeq = 0 /*order seq within file*/
llRowPos = 0

//read file and load to proper datastore for processing depending on record type
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/
	llRowPos ++
	
	/*Process header, Detail, addresses or Notes */
	Choose Case Upper(lsRecType)
			
		//HEADER RECORD
		Case 'PM', 'RM' /* Header */
						
			//llnewRow = idsPOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0 /*reset detail line seq*/
			
			//Tab seperated fields can be loaded into format
			llRC = idsPOHeader.ImportString(lsRecData,1,1,2,999,9) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 9th column on the DW */
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Header Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				FileClose(liFileNo)
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			
			//Record Defaults
			llNewHeaderRow = idsPOHeader.RowCount()
			idsPOHeader.SetItem(llNewHeaderRow,'ACtion_cd','X') /*bypass validation in next step*/
			idsPOHeader.SetITem(llNewHeaderRow,'project_id',asProject) /*Project ID*/
			idsPOHeader.SetItem(llNewHeaderRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPOHeader.SetItem(llNewHeaderRow,'order_seq_no',llOrderSeq) 
			idsPOHeader.SetItem(llNewHeaderRow,'ftp_file_name',aspath) /*FTP File Name*/
			idsPOHeader.SetItem(llNewHeaderRow,'Status_cd','N')
			idsPOHeader.SetItem(llNewHeaderRow,'Last_user','SIMSEDI')

			//If warehouse not passed on file, set to default WH for project
			If isNull(idsPOHeader.GetITemString(llNewHeaderRow,'wh_code')) Or idsPOHeader.GetITemString(llNewHeaderRow,'wh_code') = '' Then
				idsPOHeader.SetITem(llNewHeaderRow,'wh_code',lswarehouse) /*Default WH for Project */
			End If
			
			//PO or RMA header level defaults
			if lsRecType = 'PM' Then /*PO */
				
				idsPOHeader.SetItem(llNewHeaderRow,'Inventory_Type','N') /*default to Normal (GOOD) for PO*/
				idsPOHeader.SetITem(llNewHeaderRow,'order_Type','S') /*Sale */
				
				lsSuppCode = idsPOHeader.GeTITemString(llNewheaderRow,'supp_code') /*owner retrieved below will default to Supplier*/
				
			Else /*RMA*/
				
				idsPOHeader.SetItem(llNewHeaderRow,'Inventory_Type','R') /*default to ReTurns for RMA*/
				idsPOHeader.SetITem(llNewHeaderRow,'order_Type','X') /*Return from Customer */
				
				//Get the Return from Customer (which is in Supp_code) and store in UF. Then we will defualt SUpplier to 3COM
				// 08/07 - PCONKL - Storing in UF 7 now since we need 30 char instead of 10  support RMA business
				//idsPOHeader.SetITem(llNewHeaderRow,'user_field3',idsPOHeader.getITemString(llNewHeaderRow,'supp_code'))
				idsPOHeader.SetITem(llNewHeaderRow,'user_field7',idsPOHeader.getITemString(llNewHeaderRow,'supp_code'))
				idsPOHeader.SetITem(llNewHeaderRow,'supp_code','3COM')
				
				lsSuppCode = '3COM' /*owner retrieved below will default to Supplier*/
				
			End If
			
			Select owner_id into :llOwner
			From Owner
			Where Owner_Cd = :lsSuppCode and owner_type = 'S' and Project_id = :asProject;
					
			
		// DETAIL RECORD
		Case 'PD', 'RD' /*Detail */
					
			//Tab seperated fields can be loaded into format
			llRC = idsPODetail.ImportString(lsRecData,1,1,2,999,9) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 9th column on the DW */
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Detail Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				FileClose(liFileNo)
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			llLineSeq ++
			
			//Add detail level defaults
			llNewDetailRow = idsPODetail.RowCOunt()
			idsPODetail.SetITem(llNewDetailRow,'project_id', asproject) /*project*/
			idsPODetail.SetITem(llNewDetailRow,'status_cd', 'N') 
			idsPODetail.SetITem(llNewDetailRow,'action_cd', 'U') 
			idsPODetail.SetITem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPODetail.SetITem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			idsPODetail.SetITem(llNewDetailRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			
			// 04/04 - PCONKL - Singapore is using Lot_NO for Import Permit #. If warehouse is NOT Singapore, we want to default the
			//Lot # field so they don't have to enter it at Putaway. iF it is Singapore, we will default DEtail UF3 to 'FTZ' for FTZ/DOM
			If Upper(idsPOHeader.GetITemString(llNewHEaderRow,'wh_Code')) <> '3COM-SIN' Then
				idsPODetail.SetITem(llNewDetailRow,"lot_no",'N/A')
			Else
				idsPODetail.SetITem(llNewDetailRow,"User_Field3",'FTZ')
			End If
			
			//For Returns ONLY, Since we are defaulting the supplier on the header to 3COM, we need to have item master records setup for
			//3COM as well. Otherwise, w_ro won't function properly (all items must have the same supplier)
			
			If lsREcType = 'RD' Then /*return */
			
				lsSKU = idsPODetail.GetItemString(llNewDetailRow,'sku')
			
				Select Count(*) into :llCount
				From ITem_Master 
				Where Project_id = :asProject and sku = :lsSKU and supp_code = '3COM';
			
				If llCount <= 0 Then /*item doesn't exist for 3COM, create a new one*/
			
					llCount = idsItem.Retrieve(asProject, lsSKU)
					If llCount > 0 Then
						
						lirc = idsItem.RowsCopy(1,1,Primary!,idsItem,99999,Primary!) /*copy the existing Item to new */
						idsItem.SetItem(idsItem.RowCount(),'supp_code','3COM') /*update new item */
						idsItem.SetItem(idsItem.RowCount(),'owner_id',llOwner) /*update new item */
					
						liRC = idsItem.Update()
						If liRC = 1 Then
							Commit;
						Else
							Rollback;
							lsLogOut =  "       ***System Error!  Unable to Save new item Master Records (RMA 3COM Item Insert) to database "
							FileWrite(gilogFileNo,lsLogOut)
							gu_nvo_process_files.uf_writeError(lsLogOut)
							FileClose(liFileNo)
							Return -1
						End If
						
					End If /*item exists for any supplier */
					
				End If /*item doesn't exist for 3COM */
				
			End If /*Return */
			
			//If inventory Type not on file, default to Normal for PO and Rwork for RMA
			If isNull(idsPODetail.GetITemString(llNewDetailRow,'Inventory_Type')) or idsPODetail.GetITemString(llNewDetailRow,'Inventory_Type') = '' Then
				If lsRecType = 'PD' Then /* PO */
					idsPODetail.SetITem(llNewDetailRow,"inventory_type",'N') /*Normal (Good) for PO */
				Else /* Return */
					idsPODetail.SetITem(llNewDetailRow,"inventory_type",'R') /*return for RMA*/
				End If
			End If

			// Either supplier if PO, or 3COM if RMA
			If llOwner > 0 Then
				idsPODetail.SetITem(llNewDetailRow,'owner_id',String(llOwner))
			End If
			
			//Get COO default from ITem Master
			Select Country_of_Origin_Default Into :lsCOO
			From ITem_MAster
			Where Project_id = :asProject and Sku = :lsSKU and Supp_code = :lsSuppCode;
			
			idsPODetail.SetITem(llNewDetailRow,"country_of_Origin",lsCOO)
					
		//Notes
		Case 'PN', 'RN'
			
			//Tab seperated fields can be loaded into format
			llRC = idsPONotes.ImportString(lsRecData,1,1,2,999,5) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 5th column on the DW */
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Notes Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				FileClose(liFileNo)
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			
			llNewNotesRow = idsPONotes.RowCount()
			idsPONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
			idsPONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
										
		Case Else /*Invalid rec type */
			
			// 10/07 - PCONKL - we wnat to reject the ntire file. An invalid rec type is probably indicative of a more serious problem with the file
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. *** THIS ENTIRE FILE will not be processed ***.")
			FileClose(liFileNo)
			Return -1
			
//			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
//			lbError = True
//			Continue /*Next Record */
			
	End Choose /*Header, Detail or Notes */
	
	//Read the Next File record
	liRC = FileRead(liFileNo,lsRecData)
	
Loop /*Next File record*/

FileClose(liFileNo)

//Save Changes
liRC = idsPOHeader.Update()
If liRC = 1 Then
	liRC = idsPODetail.Update()
End If

If liRC = 1 Then
	liRC = idsPONotes.Update()
End If

If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new PO/RMA Records to database "
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

If lbError Then Return -1

Return 0
end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for 3COM (Revenue side)
				
String		lsLogout,lsRecData,lsRecType, lsWarehouse, lsOwner, lsNotes

String 		ls_carrier,ls_ship_ref,ls_ship_via,ls_transport_mode
Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos,llNewHeaderRow,llNewDetailRow, llNewAddressRow, llNewNotesRow, llOrderSeq, &
				llBatchSeq,	llLineSeq, llRC, llOwner
				
Decimal		ldQty, ldExistingQTY
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError

ldtToday = DateTime(today(),Now())

// pvh - 08/29/05
idsDONotes.dataobject = 'd_mercator_do_Notes'
idsDONotes.SetTransObject(SQLCA)

//08/07 - PCONK - Make sure correct dataobjects are loaded - RMA side is using different templates
idsDOHeader.dataobject = 'd_mercator_do_Header'
idsDODetail.dataobject = 'd_mercator_do_Detail'

idsDOHeader.SetTransObject(SQLCA)
idsDODetail.SetTransObject(SQLCA)
idsDONotes.SetTransObject(SQLCA)
idsDOAddress.SetTransObject(SQLCA)

// pvh - 08/22/05
idsDOHeader.reset()
idsDODetail.reset()
idsDONotes.reset()
idsDOAddress.reset() 
//

//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for 3COM Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//Warehouse will have to be defaulted from project master default warehouse
// 0 4/04 - PCONKL - using WH passed in interface since we have multiple warehouses now
Select wh_code into :lswarehouse
From Project
Where Project_id = :asProject;

//All records will be loaded with 3COM as the owner 
Select owner_id into :llOwner
From Owner
Where Owner_Cd = '3COM' and owner_type = 'S' and Project_id = :asProject;

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then
	// pvh - 09/26/06 - empty error file
	lsLogOut = "-       ***Batch Sequence Number Error, EDI Inbound get next sequence. Project: " + asProject + ". Process Aborted."
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	FileClose(liFileNo)
	Return -1
end if

llOrderSeq = 0 /*order seq within file*/
llRowPos = 0

//read file and load to proper datastore for processing depending on record type
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/
	llRowPos ++
	
	/*Process header, Detail, addresses or Notes */
	Choose Case Upper(lsRecType)
			
		//HEADER RECORD
		Case 'DM' /* Header */
						
			//llnewRow = idsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0 /*reset detail line seq*/
			
			//Tab seperated fields can be loaded into format
			llRC = idsDOHeader.ImportString(lsRecData,1,1,2,999,9) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 9th column on the DW */
			
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Header Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				FileClose(liFileNo)
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			
			//Record Defaults
			llNewHeaderRow = idsDOHeader.RowCount()		
			//Added by DGM 08/08/2005 For autopopulating carrier columns
			ls_carrier= idsDOHeader.object.carrier[llNewHeaderRow]
			IF ls_carrier > '' THEN
				Select Ship_Ref,
				Ship_Via,
				Transport_Mode
				into :ls_ship_ref,
				:ls_ship_via,
				:ls_transport_mode 
				from carrier_master
				Where project_id = '3COM_NASH'
				and carrier_code= :ls_carrier ;
				idsDOHeader.object.Ship_ref[llNewHeaderRow]=ls_ship_ref
				idsDOHeader.object.Ship_Via[llNewHeaderRow]=ls_ship_via
				idsDOHeader.object.transport_mode[llNewHeaderRow]=ls_transport_mode
			END IF	
			idsDOHeader.SetItem(llNewHeaderRow,'ACtion_cd','A') /*always a new Order*/
			idsDOHeader.SetITem(llNewHeaderRow,'project_id',asProject) /*Project ID*/
			
			idsDOHeader.SetItem(llNewHeaderRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDOHeader.SetItem(llNewHeaderRow,'order_seq_no',llOrderSeq) 
			idsDOHeader.SetItem(llNewHeaderRow,'ftp_file_name',aspath) /*FTP File Name*/
			idsDOHeader.SetItem(llNewHeaderRow,'Status_cd','N')
			idsDOHeader.SetItem(llNewHeaderRow,'Inventory_Type','N') /*default to Normal*/

			//If warehouse not passed on file, set to default WH for project
			If isNull(idsDOHeader.GetITemString(llNewHeaderRow,'wh_code')) Or idsDOHeader.GetITemString(llNewHeaderRow,'wh_code') = '' Then
				idsDOHeader.SetITem(llNewHeaderRow,'wh_code',lswarehouse) /*Default WH for Project */
			End If
			
			//Default Order Type if not present in file
			If isNull(idsDOHeader.GetITemString(llNewHeaderRow,'order_Type')) Or idsDOHeader.GetITemString(llNewHeaderRow,'order_Type') = '' Then
				idsDOHeader.SetITem(llNewHeaderRow,'order_Type','S') /*Sale */
			End If
				
			//Address 1 really contains the customer Name - Remap
			idsDOHeader.SetITem(llNewHeaderRow,'cust_name',idsDOHeader.GetITemString(llNewHeaderRow,'address_1'))
			idsDOHeader.SetITem(llNewHeaderRow,'address_1','')
			
			//Rollup address lines (mainly for TRAX)
			If idsDoHeader.GetITemString(llNewHeaderRow,'address_1') = '' or isnull(idsDoHeader.GetITemString(llNewHeaderRow,'address_1')) Then
				
				If idsDoHeader.GetITemString(llNewHeaderRow,'address_2') > '' Then
					idsDOHeader.SetITem(llNewHeaderRow,'address_1',idsDOHeader.GetITemString(llNewHeaderRow,'address_2'))
					idsDOHeader.SetITem(llNewHeaderRow,'address_2','')
				ElseIf idsDoHeader.GetITemString(llNewHeaderRow,'address_3') > '' Then
					idsDOHeader.SetITem(llNewHeaderRow,'address_1',idsDOHeader.GetITemString(llNewHeaderRow,'address_3'))
					idsDOHeader.SetITem(llNewHeaderRow,'address_3','')
				ElseIf idsDoHeader.GetITemString(llNewHeaderRow,'address_4') > '' Then
					idsDOHeader.SetITem(llNewHeaderRow,'address_1',idsDOHeader.GetITemString(llNewHeaderRow,'address_4'))
					idsDOHeader.SetITem(llNewHeaderRow,'address_4','')
				End If
				
			End If
			
			If idsDoHeader.GetITemString(llNewHeaderRow,'address_2') = '' or isnull(idsDoHeader.GetITemString(llNewHeaderRow,'address_2')) Then
				
				If idsDoHeader.GetITemString(llNewHeaderRow,'address_3') > '' Then
					idsDOHeader.SetITem(llNewHeaderRow,'address_2',idsDOHeader.GetITemString(llNewHeaderRow,'address_3'))
					idsDOHeader.SetITem(llNewHeaderRow,'address_3','')
				ElseIf idsDoHeader.GetITemString(llNewHeaderRow,'address_4') > '' Then
					idsDOHeader.SetITem(llNewHeaderRow,'address_2',idsDOHeader.GetITemString(llNewHeaderRow,'address_4'))
					idsDOHeader.SetITem(llNewHeaderRow,'address_4','')
				End If
				
			End If
			
			If idsDoHeader.GetITemString(llNewHeaderRow,'address_3') = '' or isnull(idsDoHeader.GetITemString(llNewHeaderRow,'address_3')) Then
				
				If idsDoHeader.GetITemString(llNewHeaderRow,'address_4') > '' Then
					idsDOHeader.SetITem(llNewHeaderRow,'address_3',idsDOHeader.GetITemString(llNewHeaderRow,'address_4'))
					idsDOHeader.SetITem(llNewHeaderRow,'address_4','')
				End If
				
			End If
			
			//The header record has some address fields that we're storing in an Alt Address Table
			
			//BillTo Address
			If idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_Code') > '' Then /* Bill to address present*/
			
				llNewAddressRow = idsDOAddress.InsertRow(0)
				idsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				idsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				idsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				idsDOAddress.SetItem(llNewAddressRow,'address_type','BT') /* Bill To Address */
				idsDOAddress.SetItem(llNewAddressRow,'Name',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_Code'))
				idsDOAddress.SetItem(llNewAddressRow,'address_1',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_address_1'))
				idsDOAddress.SetItem(llNewAddressRow,'address_2',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_address_2'))
				idsDOAddress.SetItem(llNewAddressRow,'address_3',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_address_3'))
				idsDOAddress.SetItem(llNewAddressRow,'address_4',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_address_4'))
				idsDOAddress.SetItem(llNewAddressRow,'district',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_district'))
				idsDOAddress.SetItem(llNewAddressRow,'City',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_City'))
				idsDOAddress.SetItem(llNewAddressRow,'State',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_state'))
				idsDOAddress.SetItem(llNewAddressRow,'Zip',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_Zip'))
				idsDOAddress.SetItem(llNewAddressRow,'Country',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_Country'))
				idsDOAddress.SetItem(llNewAddressRow,'tel',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_tel'))
				
			End If /* Bill to Address Present */
			
			//Intermediary Address
			If idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_Code') > '' Then /* Intemerd Consignee address present */
			
				llNewAddressRow = idsDOAddress.InsertRow(0)
				idsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				idsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				idsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				idsDOAddress.SetItem(llNewAddressRow,'address_type','IT') /* Intermediary Address */
				idsDOAddress.SetItem(llNewAddressRow,'Name',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_Code'))
				idsDOAddress.SetItem(llNewAddressRow,'address_1',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_address_1'))
				idsDOAddress.SetItem(llNewAddressRow,'address_2',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_address_2'))
				idsDOAddress.SetItem(llNewAddressRow,'address_3',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_address_3'))
				idsDOAddress.SetItem(llNewAddressRow,'address_4',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_address_4'))
				idsDOAddress.SetItem(llNewAddressRow,'district',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_district'))
				idsDOAddress.SetItem(llNewAddressRow,'City',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_City'))
				idsDOAddress.SetItem(llNewAddressRow,'State',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_state'))
				idsDOAddress.SetItem(llNewAddressRow,'Zip',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_Zip'))
				idsDOAddress.SetItem(llNewAddressRow,'Country',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_Country'))
				idsDOAddress.SetItem(llNewAddressRow,'tel',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_tel'))
				
			End If /* Intermed Consignee Address Present */
			
			//Sold To Address
			If idsDOHeader.GetITemString(llNewHeaderROw,'sold_to_Code') > '' Then /* Sold To address present */
			
				llNewAddressRow = idsDOAddress.InsertRow(0)
				idsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				idsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				idsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				idsDOAddress.SetItem(llNewAddressRow,'address_type','ST') /* Sold TO Address */
				idsDOAddress.SetItem(llNewAddressRow,'Name',idsDOHeader.GetITemString(llNewHeaderROw,'sold_to_Code'))
				idsDOAddress.SetItem(llNewAddressRow,'address_1',idsDOHeader.GetITemString(llNewHeaderROw,'sold_to_address_1'))
								
			End If /* Sold To Address Present */
			
			
		// DETAIL RECORD
		Case 'DD' /*Detail */
					
			//Tab seperated fields can be loaded into format
			llRC = idsDODetail.ImportString(lsRecData,1,1,2,999,7) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 7th column on the DW */
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Detail Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				FileClose(liFileNo)
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			llLineSeq ++
			
			//Add detail level defaults
			llNewDetailRow = idsDODetail.RowCOunt()
			idsDODetail.SetITem(llNewDetailRow,'project_id', asproject) /*project*/
			idsDODetail.SetITem(llNewDetailRow,'status_cd', 'N') 
			idsDODetail.SetITem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDODetail.SetITem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			idsDODetail.SetITem(llNewDetailRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			
			// 04/04 - PCONKL - iF it is Singapore, we will default DEtail UF3 to 'FTZ' for FTZ/DOM
			If Upper(idsDOHeader.GetITemString(llNewHEaderRow,'wh_Code')) = '3COM-SIN' Then
				idsDODetail.SetITem(llNewDetailRow,"User_Field3",'FTZ')
			End If
			
//			//If inventory Type not on file, default to Normal
//	09/07 - PCONKL - We don't want to default Inventory Type anymore. If we do, that is the only type that will be pickable. Blank will allow all pickable types to be picked.
//			If isNull(idsDODetail.GetITemString(llNewDetailRow,'Inventory_Type')) or idsDODetail.GetITemString(llNewDetailRow,'Inventory_Type') = '' Then
//				idsDODetail.SetITem(llNewDetailRow,"inventory_type",'N')
//			End If

			//We always want to set the owner to 3COM - All product should be shipped as 3COM owned
			If llOwner > 0 Then
				idsDODetail.SetITem(llNewDetailRow,'owner_id',String(llOwner))
			End If
					
		//Notes
		Case 'DN'
			
			//Tab seperated fields can be loaded into format
			llRC = idsDONotes.ImportString(lsRecData,1,1,2,999,5) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 5th column on the DW */
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Notes Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			
			llNewNotesRow = idsDONotes.RowCount()
			idsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
			idsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			
			// 03/05 - PCONKL - REmove any double quotes from Notes - will cause setitem on Packlist to bomb
			lsNotes = Trim(idsDONotes.GetITemString(llNewNotesRow,'note_Text'))
			Do While Pos(lsNotes,'"') > 0
				lsNotes = Replace(lsNotes,Pos(lsNotes,'"'),1,"'")
			Loop
			
			idsDONotes.SetITem(llnewNotesRow,'note_text',lsNotes)
			
			// 09/04 - PCONKL - For DI/BL notes, We want to also map to PackList instrucions on Header
			If idsDONotes.GetITemString(llNewNotesRow,'note_Type') = 'BL' or idsDONotes.GetITemString(llNewNotesRow,'note_Type') = 'DI' Then
				If Not isnull(idsDOHeader.GetITemString(llNewHeaderRow,'Packlist_Notes_Text')) Then
					idsDOHeader.SetItem(llNewHeaderRow,'Packlist_Notes_Text',idsDOHeader.GetITemString(llNewHeaderRow,'Packlist_Notes_Text') + Trim(idsDONotes.GetITemString(llNewNotesRow,'note_Text')) + '~r~n')
				Else
					idsDOHeader.SetItem(llNewHeaderRow,'Packlist_Notes_Text',Trim(idsDONotes.GetITemString(llNewNotesRow,'note_Text')) + '~r~n')
				End IF
			End IF
										
		Case Else /*Invalid rec type */
			
			// 10/07 - PCONKL - we wnat to reject the ntire file. An invalid rec type is probably indicative of a more serious problem with the file
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. *** THIS ENTIRE FILE will not be processed ***.")
			FileClose(liFileNo)
			Return -1
			
//			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
//			lbError = True
//			Continue /*Next Record */
			
	End Choose /*Header, Detail or Notes */
	
	//Read the Next File record
	liRC = FileRead(liFileNo,lsRecData)
	
Loop /*Next File record*/

FileClose(liFileNo)


//Save Changes
liRC = idsDOHeader.Update()
If liRC = 1 Then
	liRC = idsDODetail.Update()
End If
If liRC = 1 Then
	liRC = idsDOAddress.Update()
End If
If liRC = 1 Then
	liRC = idsDONotes.Update()
End If

If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new SO Records to database "
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

If lbError Then Return -1

Return 0
end function

public function integer uf_process_dboh (string asinifile);// uf_process_dboh( string asinifile )

//Process the 3COM Nashville Daily Balance on Hand Confirmation File


//Datastore	idsOut,	&
//				idsboh
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsWarehouse, lsFileName, lsFilePrefix

DEcimal		ldBatchSeq
Integer		liRC, J
DateTime		ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run
// 04/04/- PCONKL - Now running once pr warehouse

// pvh - 08/22/05
idsOut.reset()
idsboh.reset()
// eom

lsProject = ProfileString(asInifile,'3com_NASH',"project","")

//Process each warehouse Where it is time to process

// 07/07 - Added 2 RMA Warehouses...

For J = 1 to 5 /* 5 warehouses for now*/

	Choose Case J
			
		Case 1 /*Nashville*/
	
			lsNextRunDate = ProfileString(asIniFile,'3com_NAsh','DBOHNEXTDATE-NASH','')
			lsNextRunTime = ProfileString(asIniFile,'3com_NAsh','DBOHNEXTTIME-NASH','')
			lsWarehouse = 'NASHVILLE'
			lsFilePrefix = 'BH1000'
			
		Case 2 /*Singapore*/
	
			lsNextRunDate = ProfileString(asIniFile,'3com_NAsh','DBOHNEXTDATE-SIN','')
			lsNextRunTime = ProfileString(asIniFile,'3com_NAsh','DBOHNEXTTIME-SIN','')
			lsWarehouse = '3COM-SIN'
			lsFilePrefix = 'BH3251'
			
					
		Case 3 /*Eersel*/
	
			lsNextRunDate = ProfileString(asIniFile,'3com_NAsh','DBOHNEXTDATE-NL','')
			lsNextRunTime = ProfileString(asIniFile,'3com_NAsh','DBOHNEXTTIME-NL','')
			lsWarehouse = '3COM-NL'
			lsFilePrefix = 'BH3011'
			
		Case 4 /*Nashville RMA*/
	
			lsNextRunDate = ProfileString(asIniFile,'3com_NAsh','DBOHNEXTDATE-RMA-NASH','')
			lsNextRunTime = ProfileString(asIniFile,'3com_NAsh','DBOHNEXTTIME-RMA-NASH','')
			lsWarehouse = '3CGLSAMI'
			lsFilePrefix = 'BH7000'
			
		Case 5 /*Eersel RMA*/
	
			lsNextRunDate = ProfileString(asIniFile,'3com_NAsh','DBOHNEXTDATE-RMA-NL','')
			lsNextRunTime = ProfileString(asIniFile,'3com_NAsh','DBOHNEXTTIME-RMA-NL','')
			lsWarehouse = '3CGLSEMEA'
			lsFilePrefix = 'BH7400'
			
	End Choose
	
	If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
		Continue
	Else /*valid date*/
		ldtNextRunTIme = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
		If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
			Continue
		End If
	End If
	
	lsLogOut = ""
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	lsLogOut = "- PROCESSING FUNCTION: 3COM_NASH Balance On Hand Confirmation! Warehouse = " + lsWarehouse
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	lsLogOut = ""
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		
	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
	commit;

	If ldBatchSeq <= 0 Then
		lsLogOut = "   ***Unable to retrive next available sequence number for 3com_NASH BOH confirmation."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		Return -1
	End If
	
	//Retrive the BOH Data
	// 04/04- PCONKL - now processing for multiple warehouses at different times of day, only retrieve current warehouse
	lsLogout = 'Retrieving Balance on Hand Data.....'
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	FileWrite(giLogFileNo,lsLogOut)
	
	llRowCOunt = idsBOH.Retrieve(lsProject, lsWarehouse) /* retrieving for owner 3com, accton and Arcadyan. Need to modify SQL if adding new owners*/
	
	lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	FileWrite(gilogFileNo,lsLogOut)
	
	//Reset the datastore
	idsOut.Reset()
	
	//Write the rows to the generic output table - delimited by '~t'
	For llRowPos = 1 to llRowCOunt
		
		llNewRow = idsOut.insertRow(0)
		lsOutString = 'BH~t' /*rec type = balance on Hand Confirmation*/
		
		lsOutString += lsWarehouse + '~t' /* 04/04 - PCONKL - warehouse Code*/

		// Convert Inv Type Code to 3COM Code
		lsInvTypeCd = Upper(idsboh.GetItemString(llRowPos,'inventory_type'))
		Choose Case lsInvTypeCD
				// pvh - 07/05/06 
			case 'X'
				lsInvTYpeDesc = 'NRC'
			case 'Y'
				lsInvTYpeDesc = 'NRCB'
			case 'Z'
				lsInvTYpeDesc = 'HDNR'
			// eom
			Case 'N'
				
				// 08/07 - PCONKL - RMA warehouses report Normal as SBNA or SEIN based on Warehouse */
				If lsWarehouse = '3CGLSAMI' Then
					lsInvTYpeDesc = 'SBNA'
				ElseIf lsWarehouse = '3CGLSEMEA' Then
					lsInvTYpeDesc = 'SEIN'
				Else /*Revenue Warehouse */
					lsInvTYpeDesc = 'GOOD'
				End If
				
			Case 'G' /* Trey the man! 04/05/06 */
				lsInvTYpeDesc = 'ROHS'
			Case 'R'
				lsInvTypeDesc = 'RETN'
			Case 'W'
				lsInvTypeDesc = 'REWK'
			Case 'B'
				lsInvTypedesc = 'BLKD'
			Case 'H'
				lsInvTypeDesc = 'HOLD'
			Case 'O'
				lsInvTypeDesc = 'OBS' /* 04/04 - PCONKL */
			Case 'K'
				lsInvTypeDesc = 'BSTK' /* 10/04 - PCONKL */
			Case 'S'
				lsInvTypeDesc = 'SPOR' /* 11/04 - PCONKL */
			Case 'L'
				lsInvTypeDesc = 'BNDL' /* 12/04 - PCONKL */
				
			// 08/07 - PCONKL - The following types have to be converted based on the warehouse COde as well
			
			Case 'A' /*RMA Broken */
				
				If lsWarehouse = '3CGLSAMI' Then
					lsInvTYpeDesc = 'BBNA'
				Else
					lsInvTYpeDesc = 'BEIN'
				End If
				
			Case 'D' /* RMA DOA */
				
				If lsWarehouse = '3CGLSAMI' Then
					lsInvTYpeDesc = 'DBNA'
				Else
					lsInvTYpeDesc = 'DEIN'
				End If
				
			Case 'M' /* RMA MRB*/
				
				If lsWarehouse = '3CGLSAMI' Then
					lsInvTYpeDesc = 'MBNA'
				Else
					lsInvTYpeDesc = 'MEIN'
				End If
				
			Case 'V' /* RMA Hold/Quarantine*/
				
				If lsWarehouse = '3CGLSAMI' Then
					lsInvTYpeDesc = 'QBNA'
				Else
					lsInvTYpeDesc = 'QEIN'
				End If
				
			Case 'P' /* RMA SPOR*/
				
				If lsWarehouse = '3CGLSAMI' Then
					lsInvTYpeDesc = 'RBNA'
				Else
					lsInvTYpeDesc = 'REIN'
				End If
				
				
			CAse Else
				lsInvTypeDesc = lsInvTypeCd
		End Choose

		lsOutString += lsInvTypeDesc + '~t'

		lsOutString += left(idsboh.GetItemString(llRowPos,'sku'),50) + '~t'
		lsOutString += string(idsboh.GetItemNumber(llRowPos,'total_qty'),'##########.00000') + '~t'
		lsOutString += Upper(left(idsboh.GetItemString(llRowPos,'owner_cd'),20))

		idsOut.SetItem(llNewRow,'Project_id', lsproject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
		lsFileName = lsFilePrefix + String(ldBatchSeq,'000000') + '.DAT'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)

	next /*next output record */
	
	//Add a trailer Row
	If llRowCount > 0 Then

		//We need the email address from the Warehouse record for the trailer
		Select email_address into :lsEmail
		From Warehouse
		Where wh_code = :lsWarehouse;

		If isnull(lsEmail) Then lsEmail = ''

		lsOutString = "TR~t" + String(llRowCount,'#####0') + '~t' + String(today(),'yyyymmddhhmmss') + '~t' + lsEmail
		llNewRow = idsOut.insertRow(0)
		idsOut.SetItem(llNewRow,'Project_id', lsProject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		
		lsFileName = lsFilePrefix + String(ldBatchSeq,'000000') + '.DAT'
		idsOut.SetItem(llNewRow,'file_name', lsFileName) 

	End If
	
	//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,lsProject)

	//Set the next time to run if freq is set in ini file
	lsRunFreq = ProfileString(asIniFile,'3com_NASH','DBOHFREQ','')
	
	Choose Case J
			
		Case 1 /*Nashville*/
			
			If isnumber(lsRunFreq) Then
				ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
				SetProfileString(asIniFile,'3com_NASH','DBOHNEXTDATE-NASH',String(ldtNextRunDate,'mm-dd-yyyy'))
			Else
				SetProfileString(asIniFile,'3com_NASH','DBOHNEXTDATE-NASH','')
			End If
			
		Case 2 /*Singapore*/
			
			If isnumber(lsRunFreq) Then
				ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
				SetProfileString(asIniFile,'3com_NASH','DBOHNEXTDATE-SIN',String(ldtNextRunDate,'mm-dd-yyyy'))
			Else
				SetProfileString(asIniFile,'3com_NASH','DBOHNEXTDATE-SIN','')
			End If
			
					
		Case 3 /*EErsel*/
			
			If isnumber(lsRunFreq) Then
				ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
				SetProfileString(asIniFile,'3com_NASH','DBOHNEXTDATE-NL',String(ldtNextRunDate,'mm-dd-yyyy'))
			Else
				SetProfileString(asIniFile,'3com_NASH','DBOHNEXTDATE-NL','')
			End If
			
		Case 4 /*RMA Nashville*/
			
			If isnumber(lsRunFreq) Then
				ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
				SetProfileString(asIniFile,'3com_NASH','DBOHNEXTDATE-RMA-NASH',String(ldtNextRunDate,'mm-dd-yyyy'))
			Else
				SetProfileString(asIniFile,'3com_NASH','DBOHNEXTDATE-RMA-NASH','')
			End If
		
		Case 5 /*RMA EErsel*/
			
			If isnumber(lsRunFreq) Then
				ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
				SetProfileString(asIniFile,'3com_NASH','DBOHNEXTDATE-RMA-NL',String(ldtNextRunDate,'mm-dd-yyyy'))
			Else
				SetProfileString(asIniFile,'3com_NASH','DBOHNEXTDATE-RMA-NL','')
			End If
			
	End Choose
	
Next /* Warehouse to Process*/

//We are also producing an Inventory by SKU file to be emailed to 3COM on a daily basis
lsNextRunDate = ProfileString(asIniFile,'3com_NAsh','IBSNEXTDATE','')
lsNextRunTime = ProfileString(asIniFile,'3com_NAsh','IBSNEXTTIME','')

If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
	REturn 0
Else /*valid date*/
	ldtNextRunTIme = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
	If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
		Return 0
	End If
End If

idsboh.Dataobject = 'd_inventory_by_sku'
lirc = idsboh.SetTransobject(sqlca)

lsLogout = 'Retrieving Inventory By SKU report.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)
	
llRowCOunt = idsboh.Retrieve(lsProject) /* retrieving for owner 3com and accton. Need to modify SQL if adding new owners*/
	
If llRowCOunt > 0 Then
	
	lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	FileWrite(gilogFileNo,lsLogOut)
	
	//create a file in the archive directory and email it...
	//lsFileName = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + "Menlo_Inventory_" + String(Today(),"ddmmyy") + ".csv"
	//dts 2/23/05 - added time element to file name so each copy is archived (instead of over-writing the 1st)
	lsFileName = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + "XPO_Inventory_" + String(Today(),"ddmmyy") + string(now(), "hhmm") + ".csv"
	idsboh.SaveAs(lsFileName,CSV!,True)
	
	lsLogout = '     Attached is the Daily Inventory by SKU file for ' + string(today(),'mm-dd-yy')
	gu_nvo_process_files.uf_send_email(lsProject,'IBSEMAIL','XPO Logistics WMS - Daily Inventory by SKU File',lsLogOut,lsFileName) 
	
Else /* No inventory*/
	
		lsLogout = 'There is no Daily Inventory by SKU data for ' + string(today(),'mm-dd-yy')
		gu_nvo_process_files.uf_send_email(lsProject,'IBSEMAIL','XPO Logistics WMS - Daily Inventory by SKU File',lsLogOut,'') 	
	
End If

//Update next run time
// 07/04 - PCONKL - we're running twice a day - 11:30 GMT and 16:00 GMT
lsRunFreq = ProfileString(asIniFile,'3com_NASH','IBSFREQ','')

//If the time is currently 11:30, then set the time to 16:00 and don't update the date
//otherwise set the time to 11;#0 and bump date by 1
// 7/14/04 - dts - Now running at 02:00 and 15:00 GMT
// 10/22/04 - dts - Now running at 02:00 and 14:30 GMT

If lsNextRunTime = "02:00" Then
	lsNextRuntime = "14:30"
	SetProfileString(asIniFile,'3com_NASH','IBSNEXTTIME',lsNextRunTime)
Else
	lsNextRuntime = "02:00"
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile,'3com_NASH','IBSNEXTTIME',lsNextRunTime)
	SetProfileString(asIniFile,'3com_NASH','IBSNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
End If

Return 0
end function

public function integer uf_vendor_po_update (string aspath, string asproject);
//When we send an owner chg (OCH) transaction to 3COM, they are sending us back a corresponding PO Number for each line item that we just sent them
//We need to update the PO Number on the Order Detail (UF4) and send a new MMX record to mercator to forward to the customer affected by the owner chg

				
String		lsLogout,lsRecData,lsRecType, lsOrder, lsTemp, lsDONO, lsSKU, lsCustPO, lsOwner, lsPO
Integer		liFileNo,liRC
Long			llRowCount,	llRowPos, llrc, llLineItemNo
DateTime		ldtToday
Boolean		lbError
Decimal	ldPrice, ldQTY

long	llOwnerId

//u_nvo_edi_confirmations_3com	lu_confirm

ldtToday = DateTime(today(),Now())

//lu_confirm = Create u_nvo_edi_confirmations_3com

//Open the File
lsLogOut = '      - Opening File for Vendor PO Update processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for 3COM Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to proper datastore for processing depending on record type
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	
	llRowPos ++
	lsRecType = Left(lsRecData,2)
	
	Choose Case Upper(lsREcType)
			
		Case 'DH' /*Header*/
			
			lsOrder = Mid(lsRecData,4,99) /*  Rest of record minus rec type and tab - This is from UF 6 on Delivery_Master - we'll derive DO_NO from this*/
			lsDoNo = '3COM_NASH' + Mid(lsOrder,3,10)
			
			Select Count(*) into :llRowCount
			From Delivery_Master
			Where do_no = :lsDoNo;
			
			If llRowCOunt < 1 Then
				
				// 08/10 - PCONKL - If not found by building DO_NO, retrieve the do_no by retireiving based on UF6
				Select max(do_no) into:lsDONO
				from Delivery_Master
				Where project_id = '3COM_NASH' and user_Field6 = :lsOrder;
				
				If lsDONO = '' or isNull(lsDONO) Then
					
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Unable to retrieve Delivery Order from Delivery Number: '" + lsOrder + "'. Record will not be processed.")
					lbError = True
					lsDONO = ''
					
				End If
							
			End If
			
		Case 'DD' /*Detail*/
			
			If lsDONO = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No valid header record found for this detail record. Record will not be processed.")
				lbError = True
				lsDONO = ''
			End If
			
			//parse out the required fields
			lsRecData = Mid(lsRecdata,4,999) /* strip off rec type and tab*/
			
			//Line Item Number
			lsTEmp = Left(lsRecData,(Pos(lsRecData,"~t") - 1))
			
			If isNumber(Trim(lsTemp)) Then
				llLineitemNo = Long(lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Delivery Line Item Number is not numeric: '" + lsTemp + "'. Record will not be processed.")
				lbError = True
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			
			//SKU
			lsTEmp = Left(lsRecData,(Pos(lsRecData,"~t") - 1))
			lsSKU = Trim(lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			
			//QTY 
			lsTEmp = Left(lsRecData,(Pos(lsRecData,"~t") - 1))
			If isNumber(Trim(lsTemp)) Then
				ldQty = Dec(Trim(lsTemp))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Qty is not numeric: '" + lsTemp + "'. Record will not be processed.")
				lbError = True
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			
			//Price
			lsTEmp = Left(lsRecData,(Pos(lsRecData,"~t") - 1))
			
			If isNumber(Trim(lsTemp)) Then
				ldPrice = Dec(Trim(lsTemp))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Price is not numeric: '" + lsTemp + "'. Record will not be processed.")
				lbError = True
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			
			//PO Date - Ignore?
			lsTEmp = Left(lsRecData,(Pos(lsRecData,"~t") - 1))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			
			//Customer PO 
			lsTEmp = Left(lsRecData,(Pos(lsRecData,"~t") - 1))
			lsCustPO = lsTemp
			
			If lsCustPo = '' THen
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Customer PO not present. Record will not be processed.")
				lbError = True
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			
			
			//Owner Code - currently last field
			lsOwner = lsRecData
			// pvh 08/02/05
			if setOwnerId( lsOwner, asproject ) <> 1 then lbError = true
// TAM 11/16/2006 Added error text for this error *** Removed this code.  It is not supposed to generate an error message
//			if setOwnerId( lsOwner, asproject ) <> 1 then 
//				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Owner does not exist for '" + lsOwner + "'. Record will not be processed.")
//				lbError = true
//			end if
			
			If Not lbError Then
				llOwnerID = getOwnerId()
				
			// pvh - 08/02/05 - add owner_id to where clause		
			// 01/05 - PCONKL - Storing at Pick List to support Bundling
				Select Count(*) into :llRowCount
				From Delivery_Picking
				Where do_no = :lsDoNo and Line_item_No = :llLineItemNO and SKU = :lsSKU ;
				//Where do_no = :lsDoNo and Line_item_No = :llLineItemNO and SKU = :lsSKU and OWNER_ID = :llOwnerID;
			
				If llRowCount < 1 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Unable to retrieve Delivery Detail record for this Order/Line/SKU combination: '" + lsOrder + '/' + String(llLineItemNo)  +  "/" + lsSKU + "'. Record will not be processed.")
					lbError = True
				End IF
			
				If Not lbError Then
			
					//get any existing PO so we can concatonate current if necessary
					
					lsPO = ''
			
			// pvh - 08/02/05 - add owner_id to where clause	
			// 01/05 - PCONKL - Storing at Pick List to support Bundling
					Select Min(User_field1) into :lsPo
					From Delivery_Picking
					Where do_no = :lsDoNo and Line_item_No = :llLineItemNO and SKU = :lsSKU;
					//Where do_no = :lsDoNo and Line_item_No = :llLineItemNO and SKU = :lsSKU and OWNER_ID = :llOwnerID;
					
					If lsPo > '' Then
						lsPo +=  ',' + lsCustPo
					Else
						lsPO = lsCustPO
					End If
				
				//update the corresponding Delivery Order Detail record - Cust PO is going in UF 4, concatonate with any existing if line item picked from multiple owners
				// pvh - 08/02/05 - add owner_id to where clause	
				// 01/05 - PCONKL - Storing at Pick List to support Bundling
					Update Delivery_Picking
					Set	User_Field1 = :lsPO
					Where do_no = :lsDoNo and Line_item_No = :llLineItemNO and sku = :lsSKU
					//Where do_no = :lsDoNo and Line_item_No = :llLineItemNO and sku = :lsSKU and OWNER_ID = :llOwnerID
					Using SQLCA;
			
					If Sqlca.SqlCode <> 0 Then
						gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Error updating Delivery Picking Record:" + sqlca.sqlerrtext + ". Record will not be processed.")
						lbError = True
						Rollback;
						lbError = True
					Else
						Commit;
					End If
					
				End IF
			
				If Not lbError Then
					//Send a MMX (PUR) transaction to mercator to forward to customer with new PO number
					llrc = iu_Confirm.uf_vendor_po_update(lsDono, llLineiTemNo, lsSKU, lsCustPO, ldPrice, lsOwner, ldQTY)
					If llRc < 0 Then lbError = True
				End If
				
			End If
			
		Case Else /*invalid rec type */
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
			lbError = True
				
	End Choose
	
	
	//Read the Next File record
	liRC = FileRead(liFileNo,lsRecData)
	
Loop /*Next File record*/

FileClose(liFileNo)

If lbError Then
	Return - 1
Else
	Return 0
End IF

end function

public function integer uf_po_reconciliation (string asinifile, string asactivityid, string asparmstring);
//Process the 3COM PO Reconcilliation File


Datastore	ldsOut,	&
				ldsporec
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsparmstring, lsparm1, lsparm2, &
				lsparm3, lsparm4, lsparm5, lsparm6, lsparm7, &
lsEmail, lsWarehouse, lsFileName, lsFilePrefix

DEcimal		ldBatchSeq
Integer		liRC, J
DateTime		ldtNextRunTime
Date			ldtNextRunDate, ldFromDate

//This function runs on a scheduled basis - the next time to run is stored in the in the file Activity Schedule 
// 04/04/- PCONKL - Now running once pr warehouse

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsporec = Create Datastore
ldsporec.Dataobject = 'd_3com_vendor_po_reconciliation'
lirc = ldsporec.SetTransobject(sqlca)


 SELECT Project_ID,   
        Output_Name,   
        WH_Code  
   INTO :lsProject,   
        :lsFilePrefix,   
        :lsWarehouse  
   FROM Activity_Schedule  
  WHERE Activity_Schedule.Activity_ID = :asactivityid   
           ;


lsparmstring = asparmstring

	
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: 3COM_NASH Vendor PO Reconciliation report = " + asactivityid
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		
//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for 3com_NASH PO Reconciliation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	Return -1
End If
	
//Retrive the PO Data
lsLogout = 'Retrieving Vendor PO Reconciliation.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//Pull out Parm1
If Pos(lsparmstring,',') > 0 Then // If comma found 
	lsparm1 = Left(lsparmstring,(pos(lsparmstring,',') - 1)) // Take everything left of the comma
Else // If no comma found whole thing is parm
	lsparm1 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm1) + 1))) //Strip off parm and comma
	
//Pull out Parm2
If Pos(lsparmstring,',') > 0 Then
	lsparm2 = Left(lsparmstring,(pos(lsparmstring,',') - 1))
Else // If no comma found whole thing is parm
	lsparm2 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm2) + 1))) //Strip off until the next delimeter

//Pull out Parm3
If Pos(lsparmstring,',') > 0 Then
	lsparm3 = Left(lsparmstring,(pos(lsparmstring,',') - 1))
Else // If no comma found whole thing is parm
	lsparm3 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm3) + 1))) //Strip off until the next delimeter
	
//Pull out Parm4
If Pos(lsparmstring,',') > 0 Then
	lsparm4 = Left(lsparmstring,(pos(lsparmstring,',') - 1))
Else
	lsparm4 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm4) + 1))) //Strip off until the next delimeter

//Pull out Parm5
If Pos(lsparmstring,',') > 0 Then // If comma found 
	lsparm5 = Left(lsparmstring,(pos(lsparmstring,',') - 1)) // Take everything left of the comma
Else // If no comma found whole thing is parm
	lsparm5 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm5) + 1))) //Strip off parm and comma
	
//Pull out Parm6
If Pos(lsparmstring,',') > 0 Then // If comma found 
	lsparm6 = Left(lsparmstring,(pos(lsparmstring,',') - 1)) // Take everything left of the comma
Else // If no comma found whole thing is parm
	lsparm6 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm6) + 1))) //Strip off parm and comma
	
//Pull out Parm7
If Pos(lsparmstring,',') > 0 Then // If comma found 
	lsparm7 = Left(lsparmstring,(pos(lsparmstring,',') - 1)) // Take everything left of the comma
Else // If no comma found whole thing is parm
	lsparm7 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm7) + 1))) //Strip off parm and comma
	
//08/07 - PCONKL - currently added Complete Date as the 4th parm -  We only want a rolling year in the file...not retrieved from the file. Adjust accordingly if new parms
ldFromDate = RelativeDate(today(), -365) /*go back a year */

llRowCOunt = ldsPORec.Retrieve(lsparm1,lsparm2,lsparm3, ldFromDate) /* retrieving for owner 3com, accton and Arcadyan. Need to modify SQL if adding new owners*/
	
lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)
	
//Write the rows to the generic output table
For llRowPos = 1 to llRowCOunt
		
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'HD' + '|' 
		
	lsOutString += lswarehouse + '|'  //warehouse

	lsOutString += ldsporec.GetItemString(llRowPos,'picking_sku') + '|'
	lsOutString += string(ldsporec.GetItemNumber(llRowPos,'quantity'),'##########') + '|'
	If Not isNull(ldsporec.GetItemDateTime(llRowPos,'carrier_notified_date')) then
		lsOutString += string(ldsporec.GetItemDateTime(llRowPos,'carrier_notified_date'),'YYYYMMDDHHMMSS') + '|'
	Else
		lsOutString += string(ldsporec.GetItemDateTime(llRowPos,'complete_date'),'YYYYMMDDHHMMSS') + '|'
	End If
	lsOutString += Upper(ldsporec.GetItemString(llRowPos,'Owner_Cd')) + '|'
	lsOutString += Upper(ldsporec.GetItemString(llRowPos,'Invoice_No')) + '|'
	lsOutString += Upper(ldsporec.GetItemString(llRowPos,'user_field6')) + '|'
	lsOutString += String(ldsporec.GetItemNumber(llRowPos,'line_item_no')) 
		
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	lsFileName = lsFilePrefix + String(ldBatchSeq,'000000') + '.DAT'
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next output record */
	
If llRowCount > 0 Then	
//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,lsProject)
End If


Return 0
end function

public function integer uf_daily_transaction_rpt (string asinifile, string asactivityid, string asparmstring);
//Process the 3COM Daily Transaction Report File


Datastore	ldsOut,	&
				ldsporec
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsemail, &
				lsparmstring, lsparm1, lsparm2, lsparm3, lsparm4, lsparm5, lsparm6, lsparm7, &
				lsWarehouse, lsFileName, lsFilePrefix

DEcimal		ldBatchSeq
Integer		liRC, J
DateTime		ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - the next time to run is stored in the in the file Activity Schedule 

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsporec = Create Datastore
ldsporec.Dataobject = 'd_3com_vendor_transaction_rpt'
lirc = ldsporec.SetTransobject(sqlca)

 SELECT Project_ID,   
        Output_Name,   
        WH_Code
   INTO :lsProject,   
        :lsFilePrefix,   
        :lsWarehouse  
   FROM Activity_Schedule  
  WHERE Activity_Schedule.Activity_ID = :asactivityid;

lsparmstring = asparmstring
	
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: 3COM_NASH Vendor Daily Transaction Report = " + asactivityid
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		
//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for 3com_NASH Vendor Transaction Report."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	Return -1
End If
	
//Retrive the PO Data
lsLogout = 'Retrieving Vendor Daily Transactions.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//Pull out Parm1
If Pos(lsparmstring,',') > 0 Then // If comma found 
	lsparm1 = Left(lsparmstring,(pos(lsparmstring,',') - 1)) // Take everything left of the comma
Else // If no comma found whole thing is parm
	lsparm1 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm1) + 1))) //Strip off parm and comma
	
//Pull out Parm2
If Pos(lsparmstring,',') > 0 Then
	lsparm2 = Left(lsparmstring,(pos(lsparmstring,',') - 1))
Else // If no comma found whole thing is parm
	lsparm2 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm2) + 1))) //Strip off until the next delimeter

//Pull out Parm3
If Pos(lsparmstring,',') > 0 Then
	lsparm3 = Left(lsparmstring,(pos(lsparmstring,',') - 1))
Else // If no comma found whole thing is parm
	lsparm3 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm3) + 1))) //Strip off until the next delimeter
	
//Pull out Parm4
If Pos(lsparmstring,',') > 0 Then
	lsparm4 = Left(lsparmstring,(pos(lsparmstring,',') - 1))
Else
	lsparm4 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm4) + 1))) //Strip off until the next delimeter

//Pull out Parm5
If Pos(lsparmstring,',') > 0 Then // If comma found 
	lsparm5 = Left(lsparmstring,(pos(lsparmstring,',') - 1)) // Take everything left of the comma
Else // If no comma found whole thing is parm
	lsparm5 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm5) + 1))) //Strip off parm and comma
	
//Pull out Parm6
If Pos(lsparmstring,',') > 0 Then // If comma found 
	lsparm6 = Left(lsparmstring,(pos(lsparmstring,',') - 1)) // Take everything left of the comma
Else // If no comma found whole thing is parm
	lsparm6 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm6) + 1))) //Strip off parm and comma
	
//Pull out Parm7
If Pos(lsparmstring,',') > 0 Then // If comma found 
	lsparm7 = Left(lsparmstring,(pos(lsparmstring,',') - 1)) // Take everything left of the comma
Else // If no comma found whole thing is parm
	lsparm7 = lsparmstring
End If
lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm7) + 1))) //Strip off parm and comma
	
llRowCOunt = ldsPORec.Retrieve(lsparm1,lsparm2,lsparm3,lsparm4,lsparm5,lsparm6,lsparm7 ) /* retrieving for owner 3com, accton and Arcadyan. Need to modify SQL if adding new owners*/
	
lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)
	
//Write the rows to the generic output table
For llRowPos = 1 to llRowCOunt
		
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'IA' + '|' 
		
	lsOutString += lswarehouse + '|'  //warehouse

	lsOutString += ldsporec.GetItemString(llRowPos,'ord_type') + '|'
	lsOutString += ldsporec.GetItemString(llRowPos,'sku') + '|'
	lsOutString += string(ldsporec.GetItemNumber(llRowPos,'quantity'),'#########0;-#########0') + '|'
	lsOutString += Upper(ldsporec.GetItemString(llRowPos,'Owner_Cd')) 
		
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	lsFileName = lsFilePrefix + String(ldBatchSeq,'000000') + '.DAT'
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next output record */
	
//Write the Trailer Record to the generic output table
If llRowCOunt > 0 Then

	//We need the email address from the Warehouse record for the trailer
	Select email_address into :lsEmail
	From Warehouse
	Where wh_code = :lsWarehouse;

	If isnull(lsEmail) Then lsEmail = ''

		
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'TR' + '|' 
	lsOutString += String(llrowcount,'######') + '|'
	lsOutString += string(datetime(today(),now()),'YYYYMMDDHHMMSS') + '|'
	lsOutString += lsemail 
		
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	lsFileName = lsFilePrefix + String(ldBatchSeq,'000000') + '.DAT'
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)

End If /*next output record */


If llRowCount > 0 Then	
	//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,lsProject)
End If

Return 0
end function

public function integer uf_process_asn (string aspath, string asproject);String	lsLogout,			&
			lsStringData,		&
			lsWarehouse,		&
			lsArrivalDate,		&
			lsData,				&
			lsTemp,				&
			lsType,				&
			lsAction,			&
			lsSuppInvoiceNo,	&
			lsSuppCode,			&
			lsOwner, 			&
			lsCOO, 				&
			lsUF5, 				&
			lsLineNo, lsSKU, lsAltSkU, lsQty,  &
			lscarrier, lsAWBBOL, lsShipRef, lsRequestDate, lserrtext

Integer	liFileNo,			&
			liRC,					&
			liSkuAdd	

Long	llNewRow,			&
		llRowCount,			&
		llRowPos,			&
		llOrderSeq,			&
		lllineSeq,			&
		llowner,			&
		llCount
		
Decimal	ldEDIBAtchSeq
			
Boolean	lbError, lbPM, lbPD

DateTime	ldtToday

setnull(gsemail)

ldtToday = DateTime(Today(),Now())

idsPOHeader.dataobject= 'd_po_header'
idsPOHeader.SetTransObject(SQLCA)

idsPOdetail.dataobject= 'd_po_detail'
idsPOdetail.SetTransObject(SQLCA)

// pvh - 08/22/05
// reset datastores
idsPOHeader.reset()
idsPODetail.reset()
iu_ds.reset()
// eom


//Open and read the FIle In
lsLogOut = '      - Opening File for 3COM ASN Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for 3COM ASN Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If


//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = iu_ds.InsertRow(0)
	iu_ds.SetItem(llNewRow,'rec_data',lsStringData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Process each row of the File
llRowCount = iu_ds.RowCount()

lbPD = false
lbPM = false 

For llRowPos = 1 to llRowCount

	//Get Header or Detail type 
	lsData = iu_ds.GetItemString(llRowPos,'rec_data')
	lsType = Left(Trim(iu_ds.GetITemString(llRowPos,'rec_Data')),2)

	// If record is a Header record
	If lsType = 'PM' Then //Header info in the same records

// TAM 2005/04/18 added email address from email table to notify for errors
		Select Email_address into :gsemail
		From Email_address
		Where Project_ID = :asproject and wh_code = 'ALL' and supp_code = 'ALL' and email_type = 'ASNERROR';
	
		w_main.SetMicroHelp("Processing PM Inbound Master Record " + String(llRowPos) + " of " + String(llRowCount))  

		llLineSeq = 0 /*reset detail line seq*/

		//Action
		lsTemp = mid(lsdata,3,1)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Action' field. Record will not be processed.")
			Return -1
		Else
			//Validate Action Add, Update, or Delete
			If lsTemp <> 'A' and lsTemp <> 'U' and lsTemp <> 'D'  Then 	// Error
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Action' field. Record will not be processed.")
				Return -1
			Else
				lsAction = lsTemp
			End If
		End If

		//Supplier Code
		lsTemp = mid(lsdata,4,20)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Supplier Code' field. Record will not be processed.")
			Return -1
		Else
			lsSuppCode = lsTemp
			Select Count(*) into :llCount
			From Supplier
			Where Project_ID = :asproject and supp_code = :lsSuppCode;
	
			If llCount <= 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid Supplier Code: " + lsSuppCode + " Record will not be processed.")
					SetPointer(Arrow!)
					Return -1
			Else
// TAM added email address from supplier to notify for errors
					Select Email_address into :lstemp
					From Supplier
					Where Project_ID = :asproject and supp_code = :lsSuppCode;

					If not isnull(lstemp) then
						gsemail += ';' + lstemp
					End If

			End If 

		End If

		//Owner ID
		Select owner_id into :llowner
		From Owner
		Where Project_ID = :asproject and owner_cd = :lsSuppCode;
	
		If isnull(llowner) or llowner = 0 Then
			lsowner=""
		Else
			lsowner = String(llowner)
		End If 
		

		//Warehouse
		lsTemp = mid(lsdata,24,10)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Warehouse' field. Record will not be processed.")
			Return -1
		Else
				lsWarehouse = lsTemp
		End If

		//Ship Ref and Supplier Invoice Number
		lsTemp = mid(lsdata,34,40)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Ship Ref' field. Record will not be processed.")
			Return -1
		Else
			lsShipRef = lsTemp
			//2005/14/05 Supplier Invoice Number
			Select Supp_invoice_no into :lsSuppInvoiceNo
			From receive_master
			Where Project_ID = :asproject and supp_code = :lsSuppCode and ship_ref = :lsshipref;
		End If

		//AWB BOL
		lsTemp = mid(lsdata,74,20)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'AWB/BOL' field. Record will not be processed.")
			Return -1
		Else
			lsAWBBOL = lsTemp
		End If
		
		//Carrier
		lsTemp = mid(lsdata,94,10)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Carrier' field. Record will not be processed.")
			Return -1
		Else
			lsCarrier = lsTemp
		End If

		//Validate Request Date
		lsTemp = Trim(Mid(lsData,104,14))
		If trim(lsTemp) = "" Then 
			lsRequestDate = String(Today(),'MM/DD/YY')
		Else
			lsRequestDate = (mid(lsTemp,5,2) + '/' + mid(lsTemp,7,2) + '/' + mid(lsTemp,3,2)) 
		End If
		
		//Validate Arrival Date
		lsTemp = Trim(Mid(lsData,118,14))
		If trim(lsTemp) = "" Then 
			lsArrivalDate = "00000000000000"
		Else
			lsArrivalDate = (mid(lsTemp,5,2) + '/' + mid(lsTemp,7,2) + '/' + mid(lsTemp,3,2)) 
		End If

		llNewRow = idsPOHeader.InsertRow(0)
		lbPM = true	
	
		//Get the next available Seq #
		ldEDIBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
		If ldEDIBatchSeq < 0 Then
			// pvh - 09/26/06 - empty error file
			lsLogOut = "-       ***Batch Sequence Number Error, EDI Inbound get next sequence. Project: " + asProject + ". Process Aborted."
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			FileClose(liFileNo)
			Return -1
		End If	

		//TAM 2005/02/14
		if  isnull(lssuppinvoiceno) or lssuppinvoiceno = ''  then
			lssuppInvoiceNo = string(1000000000 + ldEDIBatchSeq)
		end if
		
		idsPOHeader.SetITem(llNewRow,'wh_code',lsWarehouse) 
		idsPOHeader.SetITem(llNewRow,'project_id',asProject)
		idsPOHeader.SetITem(llNewRow,'action_cd',lsaction) 
		idsPOHeader.SetItem(llNewRow,'Order_No',lsSuppInvoiceNo) 
		idsPOHeader.SetITem(llNewRow,'Request_date',lsRequestDate) 
		idsPOHeader.SetITem(llNewRow,'Arrival_date',lsArrivalDate) 
		idsPOHeader.SetItem(llNewRow,'Order_type','S') 
		idsPOHeader.SetItem(llNewRow,'Supp_Code',lsSuppCode) 
		idsPOHeader.SetItem(llNewRow,'Inventory_Type','N') 
		idsPOHeader.SetItem(llNewRow,'Ship_Ref',lsSHipRef) 
		idsPOHeader.SetItem(llNewRow,'Supp_Order_No','')
		idsPOHeader.SetItem(llNewRow,'AWB_BOL_No',lsAWBBOL)
		idsPOHeader.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
		llOrderSeq = llNewRow /*header seq */
		idsPOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
		idsPOHeader.SetItem(llNewRow,'ftp_file_name',asPath) /*FTP File Name*/
		idsPOHeader.SetItem(llNewRow,'Status_cd','N')
		idsPOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')


	Else // Else Record is a detail

		llLineSeq ++


		//User Line Number 
		lsTemp = mid(lsdata,3,6)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'PO Line Number' field. Record will not be processed.")
			Return -1
		Else
			lsLineNo = lsTemp
		End If

		//COO 
		lsSku = mid(lsdata,9,50)
 		SELECT Country_of_Origin_Default  
    	INTO :lsCOO  
   	FROM Item_Master  
   	WHERE Project_id = :asProject and 
				SKU = :lsSku AND  
         	Supp_Code = :lsSuppCode   ;
			
		If isnull(lsCOO) or lscoo = '' then 
			lscoo = 'XXX'
		End if

		//Validate QTY for Numerics
		lsTemp = Trim(Mid(lsData,59,15))
		If Not isnumber(lsTemp) Then
			lsQTY = "0"
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - PO QTY is not numeric. Qty has been set to: 0")
			lbError = True
		Else
			lsQty = lsTemp 
		End If

		//User Field 5 (Blanket PO)
		lsUF5 = Trim(Mid(lsData,74,20))

		//Alt SKU  
		lsAltSku = mid(lsdata,94,50)

		w_main.SetMicroHelp("Processing PD Inbound Detail Record " + String(llRowPos) + " of " + String(llRowCount))  

		llNewRow = idsPOdetail.InsertRow(0)
		lbPD = true
	
		idsPOdetail.SetItem(llNewRow,'Order_No',lsSuppInvoiceNo) 
		idsPOdetail.SetItem(llNewRow,'project_id', asproject) /*project*/
		idsPOdetail.SetItem(llNewRow,'Inventory_Type', 'N') 
		idsPOdetail.SetItem(llNewRow,'SKU', lsSku) 
		idsPOdetail.SetItem(llNewRow,'ALternate_SKU', lsAltSku) 
		idsPOdetail.SetItem(llNewRow,'Line_Item_No',long(lsLineNo)) 
		idsPOdetail.SetItem(llNewRow,'Quantity', lsQty) 
		idsPOdetail.SetItem(llNewRow,'UOM', 'EA') 
		idsPOdetail.SetItem(llNewRow,'Country_of_Origin', LsCOO) 
		idsPOdetail.SetItem(llNewRow,'Action_Cd', lsAction) 
		idsPOdetail.SetItem(llNewRow,'status_cd', 'N') 
		idsPOdetail.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
		idsPOdetail.SetItem(llNewRow,'order_seq_no',llORderSeq) 
		idsPOdetail.SetItem(llNewRow,'order_line_no', string(lllineSeq)) 
		idsPOdetail.SetItem(llNewRow,'user_line_item_no', lsLineNo) 
		idsPOdetail.SetItem(llNewRow,'owner_id', lsowner) 
	End If

Next //File Row
		
	//Save the Changes
	If lbPM  Then // do only if an update is attempted
	 	lirc = idsPOHeader.Update()
	 	If lbPD and liRC = 1 Then lirc = idsPOdetail.Update()
		If liRC = 1 Then
				Commit;
		Else
				Rollback;
				lsLogOut = Space(17) + "- ***System Error!  Unable to Save new PO Records to database!"
				FileWrite(gilogFileNo,lsLogOut)
				gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new PO Records to database!")
			Return -1
		End If
	End if

If lbError Then
	Return -1
Else
	Return 0
End If
end function

public function integer uf_process_serial_numbers (string aspath, string asproject);// int = uf_process_serial_numbers( string aspath, string asproject )
//
// pvh - 07/20/05 - Created
//
string		lsLogout
string		lsRecData
string 		lsTemp
string 		lsMdate
string 		lsMTime
Integer		liFileNo
Integer		liRC
Long			llNewROw
Long			llRowPos
Long			llRowCount
DateTime	ldtToday
Boolean	lbSKUError

int iiPacManCodeFieldLength = 14

// Field Lengths
int liCartonFieldStart = 1
int liCartonFieldLength = 20
int liMfdateFieldStart = 22
int liMfdateFieldLength = 8
int liMfTimeFieldStart = 31
int liMfTimeFieldLength = 6
int liSerialNbrFieldStart = 38
int liSerialNbrFieldLength = 20
int liMtrlNbrFieldStart = 59
int liMtrlNbrFieldLength = 50
int liSupplierfieldStart=110
int liSupplierfieldLength=20
int liRevCodeFieldStart = 131
int liRevCodeFieldLength = 25
int liPalletIDFieldStart = 157
int liPalletIDFieldLength = 20
int liMacAddressFieldStart = 178
int liMacAddressFieldLength = 50
int liCountryofOriginFieldStart =229
int liCountryofOriginFieldLength = 3

// pvh - 08/22/05
idsSupplier.retrieve(  asProject  )
idsSerialPrefix.retrieve( asproject )
iu_ds.reset()
idsDupCheck.reset()
iuds_serial.reset()
// eom

ldtToday = DateTime(today(),Now())

//Open the File
lsLogOut = '      - Opening File for 3Com Serial Number Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for 3Com Serial Number Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	llNewRow = iu_ds.InsertRow(0)
	iu_ds.SetItem(llNewRow,'rec_data',lsRecData) 
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

setGenImportDS( iu_ds )
setOutputDs( iuds_serial )
setProject ( asProject )


//Load the serial table - fields are comma seperated - Must have delimiters to the end (last field is Required)
llRowCount = iu_ds.RowCount()
if llRowCount <=0 then return -1

For llRowPOs = 1 to llRowCount 
	
	iu_ds.setrow( llRowPos )
	
	lsRecData = iu_ds.GetITemString(llRowPos, 'rec_data')
	if isNull( lsRecData ) or len( lsRecData ) = 0 then continue
	
	llNewRow = iuds_serial.InsertRow(0)
	
	iuds_serial.setrow( llNewRow )
	setNewRow( llNewRow )
	setRecData( lsRecData )
	
	//Record Defaults
	iuds_serial.SetItem(llNewRow, 'Project_ID', asProject)
	iuds_serial.SetItem(llNewRow, 'pallet_ID', '-')
	iuds_serial.SetItem(llNewRow, 'last_Update', ldtToday)
	iuds_serial.SetItem(llNewRow, 'status_cd', 'N')
	
	// Carton
	if setNextField( 'Carton Number', liCartonFieldstart, liCartonFieldLength ) < 0 then continue
	setCarton( getNextField() )
	iuds_serial.object.carton_id[ llNewRow ] = getNextField()
	
	// Manufactured Date
	if setNextField( 'Manufactured Date', liMfdateFieldStart, liMfdateFieldLength ) < 0  Then Continue
	lsTemp = getNextField()
	lsMdate = left( lsTemp,4 ) + "/" + mid( lsTemp,5,2) + "/" + right( lsTemp, 2)
	if NOT isDate( lsMdate ) then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Manufactured Date is Invalid. Record will not be processed.")
		iuds_serial.DeleteRow(llNewRow)
		Continue
	End If
	
	// Manufactured Time
	if setNextField( 'Manufactured Time', liMfTimeFieldStart, liMfTimeFieldLength ) < 0 then continue
	lsTemp = getNextField()
	lsMTime = left( lsTemp,2 ) + ":" + mid( lsTemp,3,2 ) + ":" + right( lsTemp,2)
	if NOT isTime( lsMTime ) then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Manufactured Time is Invalid. Record will not be processed.")
		iuds_serial.DeleteRow(llNewRow)
		Continue
	End If
	iuds_serial.object.manufacture_date[ llNewRow ] = DateTime( date( lsMdate) , Time( lsMTime ) )
	
	// Serial Number
	if setNextField( 'Serial Number',liSerialNbrFieldStart, liSerialNbrFieldLength ) < 0  then continue
	iuds_serial.Object.Serial_No[ llNewRow ] = getNextField()

	// Material Number
	if setNextField( 'Material Number',liMtrlNbrFieldStart, liMtrlNbrFieldLength ) < 0 then continue
	iuds_serial.object.sku[ llNewRow ] = getNextField()
	
	if setNextField("Supplier",liSupplierfieldStart,liSupplierfieldLength) < 0 then continue
	if setTranslatedSuppliercode(  getNextField()  ) < 0 then 	continue
	iuds_serial.object.supp_code[ llNewRow ] = getTranslatedSupplierCode()

	// Revision Code
	if setNextField( 'Revision code',liRevCodeFieldStart, liRevCodeFieldLength ) < 0 then continue
	iuds_serial.Object.user_field1[ llNewRow ] = getNextField()

	// Pallet ID
	if setNextField( 'Pallet ID',liPalletIDFieldStart, liPalletIDFieldLength ) < 0 then continue
	setPallet( getNextField() )
	iuds_serial.Object.pallet_id[ llNewRow ] = getNextField()

	// Mac Address  
	if setNextField( 'Mac Address',liMacAddressFieldStart, liMacAddressFieldLength ) < 0 then continue
	iuds_serial.Object.mac_id[ llNewRow ] = getNextField() 

	// Country of Origin
 	if setNextField( 'Country of Origin',liCountryofOriginFieldStart, liCountryofOriginFieldLength ) < 0 then continue
	iuds_serial.Object.country_of_origin[ llNewRow ] = getNextField()
	
	if getPalletBreak() <> getPallet() then doPalletBreak() 
	if getPalletFailed() then
		iuds_serial.deleterow( llNewRow )
		continue
	end if
	
	if getCartonBreak() <> getCarton() then doCartonBreak() 
	if getCartonFailed() then
		iuds_serial.deleterow( llNewRow )
		continue
	end if
	
	if doSerialDupCheck( iuds_serial.Object.Serial_No[ llNewRow ]  ) then
		iuds_serial.deleterow( llNewRow )
		continue
	end if
	
Next /*Serial Row*/

if NOT getPalletFailed() and NOT getCartonFailed() then
	setCartonBreak( getCarton() )
	doCartonBreak()
end if

//Save records
liRC = iuds_serial.Update()
If liRC = 1 Then
	Commit;
Else
	// If an error occurs on the entire update, try to update individually
	long errorCount
	errorCount = doIndividualRowUpdate()
	if errorCount > 0 then
		lsLogOut =  "       "+String( errorcount )+ " rows of " + string( iuds_serial.rowCount() )+ " records submitted failed update. Check For Duplicates."
		gu_nvo_process_files.uf_writeError(lsLogOut)
		FileWrite(gilogFileNo,lsLogOut)
		return -1
	end if
End If

//If serial record count is less than raw data count, then we dropped row(s) - Return error
If iuds_serial.rowCount() < ( iu_ds.RowCount() -1 ) Then
	gu_nvo_process_files.uf_writeError("       Rows were Rejected.")
	Return -1
Else
	Return 0
End If
end function

public function string getnextfield ();return isNextField
end function

public subroutine setgenimportds (ref datastore asds);// setGenImport( ref datastore asds )
idsGenImport = asDs

end subroutine

public function datastore getgendsimport ();//datastore = getGenImport()
return idsGenImport
end function

public subroutine setoutputds (ref datastore asds);// setOutputDs( ref datastore asds )
idsOutputDs = asDs

end subroutine

public function datastore getoutputds ();//datastore = getOutputDs()
return idsOutputDs
end function

protected subroutine setnewrow (long asrow);// setNewRow( long asRow )
ilNewRow = asRow

end subroutine

protected function long getnewrow ();// long = getNewRow()
return ilNewRow


end function

public function datastore getgenimportds ();//datastore = getGenImport()
return idsGenImport
end function

public subroutine setrecdata (string asdata);// setRecData( string asData )
isRecData = asData

end subroutine

public function string getrecdata ();// string = getRecData()
return isRecData
end function

public function string gettranslatedsuppliercode ();// string = getTranslatedSupplierCode()
return isTranslatedSupplierCode

end function

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);// int = uf_process_files( string asProject, string asPath, string asFile, string asIniFile )

//Process the correct file type based on the first 5 characters of the file name

String	lsLogOut, lsSaveFileName, lsFileType
Integer	liRC

Boolean	bRet

u_nvo_proc_standard_edi lu_nvo_proc_standard_edi

lsFileType = Upper(Left(asFile,5))

Choose Case lsFileType
			
	Case 'KCMOW' /* Sales Order Files*/
		
		liRC = uf_process_so(asPath, asProject)
		
		//Process any added SO's		
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		If liRC >= 0 Then
			liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
		End If
		
	Case 'KCMAR' /* Purhcase Order and Return Order Files*/
		
		liRC = uf_process_po(asPath, asProject)
		
		//Process any added PO's
		If liRC >= 0 Then
			liRC = gu_nvo_process_files.uf_process_Purchase_order(asProject) 
		End If
		
	Case 'KCMPU' /* Update to Vendor PO Number (3COM to Customer ie. Accton)*/
		
		liRC = uf_vendor_po_Update(asPath, asProject)
		

// TAM 11/08/04
	Case 'ASN3C' /* ASN Files*/
		
		liRC = uf_process_asn(asPath, asProject)
		
		// pvh 08/24/05
		// the previous process changes the datasource for the following...
		idsPOHeader.dataobject= 'd_mercator_po_Header'
		idsPOHeader.SetTransObject(SQLCA)
		idsPOdetail.dataobject= 'd_mercator_po_Detail'
		idsPOdetail.SetTransObject(SQLCA)	
		// eom - we needed to set them back to original.
		
		//Process any added PO's via ASN
		If liRC >= 0 Then
			liRC = gu_nvo_process_files.uf_process_Purchase_order(asProject) 
		End If
		
	// pvh - 07/29/05 - requirement change
	// filename will now begin with 3CMSN for 3COM SERIAL NUMBER
	Case	'3CMSN'
		liRC = uf_process_serial_numbers(asPath, asProject)
	
	// pvh - 03.08.06 - Marl level load
	Case '3CMRL'
		
			liRC = uf_process_itemmaster(asPath, asProject, asIniFile )

			//Process any added PO's
			If liRC >= 0 Then
				liRC = gu_nvo_process_files.uf_process_Purchase_order(asProject) 
			End If
		
	Case "RMAAR" /* 08/07 - PCONKL - RMA Expected Receipt */
		
		liRC = uf_process_gls_rma_receipt(asPath, asProject)
		If liRC >= 0 Then
			liRC = gu_nvo_process_files.uf_process_Purchase_order(asProject) 
		End If
		
	Case "RMAPO" /* 08/07 - PCONKL - RMA PO (Allocation and Repairs*/
		
		liRC = uf_process_gls_po_receipt(asPath, asProject)
		If liRC >= 0 Then
			liRC = gu_nvo_process_files.uf_process_Purchase_order(asProject) 
		End If
		
	Case "RMAOW" /* 08/07 - PCONKL - RMA Shipment Request*/
		
		liRC = uf_process_gls_so(asPath, asProject)
		
		//Process any added SO's
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		If liRC >= 0 Then
			liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
		End If
		
	Case "KCMFR" /* 11/08 - MEA - FRU Warranty*/		
		
		liRC = uf_process_warranty_sku(asPath, asProject, asIniFile )
	
		
	Case Else /* check 3 o4 4 char prefixes*/
		
		if left(lsFileType, 4) = '3040' or left(lsFileType, 4) = '4010' then
			
			lu_nvo_proc_standard_edi= create u_nvo_proc_standard_edi
			
			liRC = lu_nvo_proc_standard_edi.uf_process_214(asProject, asPath)
							
		else /*Invalid type*/
			
			lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_writeError(lsLogout)
			Return -1
		end if
// eom		
End Choose



Return liRC
end function

public function integer settranslatedsuppliercode (string assuppliercode);// integer = setTranslatedSuppliercode( String asSupplierCode )
integer returnCode
long lFoundRow
string lsSearchFor

lsSearchfor = "Upper(Trim(user_field3)) = ~'" + Upper(Trim( asSupplierCode )) + "~'"

lFoundRow = idsSupplier.find( lsSearchfor, 0 , idsSupplier.rowcount() )
if lFoundRow <= 0 then 
	gu_nvo_process_files.uf_writeError("Row: " + string(getgenimportds().getrow()) + " - "+ "Supplier Code: " + Upper(Trim( asSupplierCode ) ) + " Did not translate. Record will not be processed.")
	getoutputds().deleterow( getNewRow() )
	return failure
end if

isTranslatedSupplierCode = idsSupplier.object.supp_code[ lFoundRow ]

setEmailAddress( idsSupplier.object.email_address[ lFoundRow ] )

return success

end function

protected function long getownerid ();// long = getOwnerId()
return ilOwnerId

end function

public function integer setnextfield (string aslabel, integer asfieldstart, integer asfieldlength);// integer = setNextField( string asLabel, int asFieldStart, integer asFieldLength, ref string asData )

// asLabel = the column label for error referencing
// asFieldLength = the field length


string lsTemp
string lsData

lsData = getRecData()
lsTemp = mid( lsData,asFieldStart, asFieldLength )
if isNull( lsTemp ) or len( lsTemp ) = 0 then
	gu_nvo_process_files.uf_writeError("Row: " + string(getgenimportds().getrow()) + " - "+ asLabel + " is not present. Record will not be processed.")
	getoutputds().deleterow( getNewRow() )
	return -1
End If

isNextField = Trim( lsTemp )

return 0


end function

public function integer setownerid (string asownercode, string asproject);// integer = setOwnerId( string asOwnerCode, string asProject )
string _ownercd

_ownercd = Upper( trim( asOwnerCode )) 
select owner_id
into :ilOwnerId
from owner
where Upper( rtrim( ltrim( owner_cd ))) = :_ownercd
and Owner_type = 'S'
and project_id = :asProject ;

if sqlca.sqlcode <> 0 then return -1
return 1


end function

public function boolean dovalidateserialprefix (string asserialnumber, string assku, string assuppcode);// boolean = doValidateSerialPrefix( string asSerialNumber, string asSKU, string asSuppCode )
// Validate Serial Number Prefix...
//	If NOT doValidateSerialPrefix( luds_serial.Object.Serial_No[ llNewRow ] , luds_serial.object.sku[ llNewRow ], getTranslatedSupplierCode() ) then
//		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos ) + " - Invalid Serial Number Prefix for SKU: " + &
//															luds_serial.object.sku[ llNewRow ] + ", Serial: " + luds_serial.Object.Serial_No[ llNewRow ] + &
//															". Record will not be processed.")
//		luds_Serial.DeleteRow(llNewRow)
//		Continue
//	End If 
string 	_testPrefix
string 	_sku
string 	_supplier
string 	_filter
string 	_prefix
string 	_searchfor
long 		_foundrow

idsSerialPrefix.setfilter( '' )
idsSerialPrefix.filter()

_testPrefix = Upper( left ( asSerialNumber, 3 ))

_sku = 'sku = ~'' + asSKU + '~''
_supplier = 'supp_code = ~'' + asSuppCode + '~''

_filter = _sku + ' and ' + _supplier

idsSerialPrefix.setfilter( _filter )
idsSerialPrefix.filter()

if idsSerialPrefix.rowcount() <= 0 then return false

// There may be more than one row returned....use find to see if our test prefix is there.....

_searchfor = 'prefix = ~'' + _testPrefix + '~''
_foundRow = idsSerialPrefix.find( _searchfor, 1, idsSerialPrefix.rowcount() )
if _foundRow <= 0 then return false

return true

end function

public subroutine setproject (string asproject);isProject = asProject

end subroutine

public function string getproject ();return isProject

end function

public subroutine setpalletbreak (string asbreak);isPalletBreak = Upper( Trim( asBreak ) )
end subroutine

public subroutine setcartonbreak (string asbreak);isCartonBreak = Upper( Trim( asBreak ) )
end subroutine

public function string getpalletbreak ();return isPalletBreak

end function

public function string getcartonbreak ();return isCartonBreak

end function

public subroutine setpallet (string aspallet);isPallet = Upper( Trim( aspallet ) )
end subroutine

public subroutine setcarton (string asctn);isCarton = Upper( Trim( asctn ) )
end subroutine

public function string getcarton ();return isCarton

end function

public function string getpallet ();return isPallet

end function

public function boolean uf_checkforduplicates (string aspalletid, string ascartonid, string asserialnbr);// Boolean = uf_CheckForDuplicates( string asPalletId, string asCartonId, string asSerialNbr  )

if idsDupCheck.retrieve( getProject() , &
								    Upper(Trim( asPalletId)), &
								    Upper(Trim( asCartonId)), &
								    Upper(Trim(asSerialNbr)) )  > 0 then return true

Return false

end function

public subroutine setpalletfailed (boolean abool);ibPalletFailed = abool

end subroutine

public subroutine setcartonfailed (boolean abool);ibCartonFailed = abool
end subroutine

public function boolean getpalletfailed ();return ibPalletFailed

end function

public function boolean getcartonfailed ();return ibCartonFailed

end function

public subroutine dopalletbreak ();// doPalletBreak()

if  uf_CheckForDuplicates( getPallet(), ' ' , ' ' )  then
	gu_nvo_process_files.uf_writeError( isDupMessage +"Pallet Id: " + getPallet() + " Pallet Rejected." )
	FileWrite(gilogFileNo,isDupMessage + "Pallet Id: " + getPallet() + " Pallet Rejected." )
	setPalletFailed( true )
else	
	setPalletFailed( false )
end if

setPalletBreak( getPallet() )
doCartonBreak() 

return 


end subroutine

public subroutine docartonbreak ();// doCartonBreak()
datastore lds

string _sbegin = 'Upper( carton_id ) = ~''
string _send = '~''
string _sfilter
int _rows
int _index

if getCartonBreak() <> "*" then
	lds = getOutPutDs()
	_sfilter = _sbegin + Upper(Trim(getCartonBreak() )) + _send
	lds.setfilter( _sfilter )
	lds.filter()
	_rows = lds.rowcount()
	if _rows > 0 then 
		for _index = 1 to _rows
			lds.object.Carton_qty.primary[ _index ] = lds.rowcount()
		next
	end if
	lds.setfilter( "" )
	lds.filter()
end if

if  uf_CheckForDuplicates( ' ', getCarton() , ' ' )  then
	FileWrite(gilogFileNo, ( isDupMessage + "Carton Id: " + getCarton() + " Carton Rejected." ))
	gu_nvo_process_files.uf_writeError( isDupMessage + "Carton Id: " + getCarton() + " Carton Rejected."  )
	setCartonFailed( true )
else	
	setCartonFailed( false )
end if

setCartonBreak( getCarton() )

return 


end subroutine

public function boolean doserialdupcheck (string asserialnbr);// boolean = doSerialDupCheck( string asSerialnbr )

if  uf_CheckForDuplicates( '' , ' ' , asSerialNbr  )  then
	gu_nvo_process_files.uf_writeError( isDupMessage + "Serial #: " + asSerialnbr + " Serial Number Rejected."  )
	FileWrite(gilogFileNo, isDupMessage + "Serial #: " + asSerialnbr + " Serial Number Rejected."  )
	doRejectPallet()
	doRejectCarton()
	setPalletFailed( true )
	setCartonFailed( true )
	return true
end if

return false



end function

public subroutine dorejectpallet ();// doRejectPallet()

// Remove all rows already processed for the current pallet
datastore lds

string _sbegin = 'Upper( pallet_id ) = ~''
string _send = '~''
string _sfilter
int _rows

lds = getOutPutDs()
_sfilter = _sbegin + Upper(Trim(getPallet() )) + _send
lds.setfilter( _sfilter )
lds.filter()
_rows = lds.rowcount()
if _rows > 0 then
	do while _rows > 0
		lds.deleterow( _rows )
		_rows --
	loop
end if
lds.setfilter( "" )
lds.filter()

return 
end subroutine

public subroutine dorejectcarton ();// doRejectCarton()

// Remove all rows already processed for the current doRejectCarton
datastore lds

string _sbegin = 'Upper( carton_id ) = ~''
string _send = '~''
string _sfilter
int _rows

lds = getOutPutDs()
_sfilter = _sbegin + Upper(Trim(getCarton() )) + _send
lds.setfilter( _sfilter )
lds.filter()
_rows = lds.rowcount()
if _rows > 0 then
	do while _rows > 0
		lds.deleterow( _rows )
		_rows --
	loop
end if
lds.setfilter( "" )
lds.filter()

return 



end subroutine

public subroutine docreatedatastores ();// doCreateDatastores()

// pvh 03/31/06 - marl
idsChanges = f_datastoreFactory( 'd_3com_marl_change_rpt' )

idsPOHeader = Create u_ds_datastore
idsPOHeader.dataobject = 'd_mercator_po_Header'
idsPOHeader.SetTransObject(SQLCA)

idsPODetail = Create u_ds_datastore
idsPODetail.dataobject = 'd_mercator_po_Detail'
idsPODetail.SetTransObject(SQLCA)

idsPONotes = Create u_ds_datastore
idsPONotes.dataobject = 'd_mercator_ro_Notes'
idsPONotes.SetTransObject(SQLCA)

idsItem = Create u_ds_datastore
idsItem.dataobject= 'd_item_master'
idsItem.SetTransObject(SQLCA)

iu_ds = Create datastore
iu_ds.dataobject = 'd_generic_import'		

idsOut = Create Datastore
idsOut.Dataobject = 'd_edi_generic_out'
idsOut.SetTransobject(sqlca)

idsboh = Create Datastore
idsboh.Dataobject = 'd_3com_boh'
idsboh.SetTransobject(sqlca)

idsSupplier = create datastore
idsSupplier.dataobject = 'd_supplier_by_projectid'
idsSupplier.settransobject( sqlca )

idsDupCheck = create datastore
idsDupCheck.dataobject = 'd_carton_serial_dup_check'

idsSerialPrefix = create datastore
idsSerialPrefix.dataobject = 'd_3com_serial_prefix_by_project_id'
idsSerialPrefix.settransobject( sqlca )

iuds_serial = Create datastore
iuds_serial.dataobject = 'd_carton_serial'
iuds_serial.SetTransObject(SQLCA)

iuds_warranty_sku = Create datastore
iuds_warranty_sku.dataobject = 'd_warranty_sku'
iuds_warranty_sku.SetTransObject(SQLCA)

idsDOHeader = Create u_ds_datastore
idsDOHeader.dataobject = 'd_mercator_do_Header'
idsDOHeader.SetTransObject(SQLCA)

idsDODetail = Create u_ds_datastore
idsDODetail.dataobject = 'd_mercator_do_Detail'
idsDODetail.SetTransObject(SQLCA)

idsDONotes = Create u_ds_datastore
idsDONotes.dataobject = 'd_mercator_do_Notes'
idsDONotes.SetTransObject(SQLCA)

idsDOAddress = Create u_ds_datastore
idsDOAddress.dataobject = 'd_mercator_do_address'
idsDOAddress.SetTransObject(SQLCA)


iu_confirm = Create u_nvo_edi_confirmations_3com





end subroutine

public subroutine dodestroydatastores ();// doDestroyDatastores()

if IsValid( idsPOHeader ) then destroy idsPOHeader
if IsValid( idsPODetail ) then destroy idsPODetail
if IsValid( idsDONotes ) then destroy idsDONotes
if IsValid( idsItem ) then destroy idsItem
if IsValid( iu_ds ) then destroy idsItem
if IsValid( idsOut ) then destroy idsOut
if IsValid( idsboh ) then destroy idsboh
if IsValid( idsSupplier ) then destroy idsSupplier
if IsValid( idsDupCheck ) then destroy idsDupCheck
if IsValid( idsSerialPrefix ) then destroy idsSerialPrefix
if IsValid( idsDOHeader ) then destroy idsDOHeader
if IsValid( idsDODetail ) then destroy idsDODetail
if IsValid( idsDONotes ) then destroy idsDONotes
if IsValid( idsDOAddress ) then destroy idsDOAddress
// pvh - 03/31/2006 marl
if IsValid( idsChanges ) then destroy  idsChanges
if IsValid( iuds_warranty_sku ) then destroy  iuds_warranty_sku


end subroutine

public function long doindividualrowupdate ();// integer = doIndividualRowUpdate()

// if the update of the entire datawindow fails
// try to update individual rows.

long 			index
long 			max
long 			errorCount
datastore 	lds

lds = f_datastoreFactory( iuds_serial.dataobject ) // create a copy
errorCount = 0
max = iuds_serial.rowcount()
for index = 1 to max
	lds.reset()
	iuds_serial.RowsCopy( index, index, Primary!, lds, 1, Primary! )
	lds.setItemStatus( 1, 0, Primary!, NewModified! )
	if lds.Update() = 1 then continue
	errorCount++
next

return errorCount

end function

public subroutine setemailaddress (string avalue);// setEmailAddress( string avalue )

string lsDistribList

string workerAnt

lsDistribList = ProfileString(gsinifile,Upper(Trim(getProject())),"CUSTEMAIL","")

workerAnt = gsemail
if pos( workerAnt, avalue ) > 0 then return
if IsNull( workerAnt ) or len( workerAnt ) = 0 then
	workerAnt = avalue
else
	workerAnt += "," + avalue
end if
if Pos( workerAnt, lsDistribList ) > 0 then
	gsemail = workerAnt
	return
end if
gsemail = workerAnt + "," + lsDistribList

workerAnt = gseMail

end subroutine

public function integer uf_process_itemmaster (string aspath, string asproject, string asini);// integer = uf_process_itemmaster( string aspath, string asProject, string asIni )

string		lsLogout
string		lsRecData
string 		lsTemp
Integer		liFileNo
Integer		liRC
Long			llNewROw
Long			llRowPos
Long			llRowCount
DateTime	ldtToday
string 		_sku
string 		_marl
string 		_qhold
long	 		_itemRows
int				_cntr
string		_invMarl
string		_invQhold
int				index
string 		_supplier

constant string _user = 'SIMSFP'
constant string _marldesc = 'MARL Changed'
constant string _qdesc = 'Quality Hold Changed'

boolean updateMarl
boolean updateQhold

// Field Lengths
int liSkuStart = 1
int liSkuLength = 50
int liMarlStart = 51
int liMarlLength = 2
int liQhold = 53
int liQholdLength = 1
///....

ldtToday = DateTime(today(),Now())


//Open the File
lsLogOut = '      - Opening File for 3Com Item Master Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for 3Com Item Master Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	llNewRow = iu_ds.InsertRow(0)
	iu_ds.SetItem(llNewRow,'rec_data',lsRecData) 
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

setGenImportDS( iu_ds )
setOutputDs( idsItem )
setProject ( asProject )

//Load the serial table - fields are comma seperated - Must have delimiters to the end (last field is Required)
llRowCount = iu_ds.RowCount()
if llRowCount <=0 then return -1

For llRowPOs = 1 to llRowCount 
	
	iu_ds.setrow( llRowPos )
	
	lsRecData = iu_ds.GetITemString(llRowPos, 'rec_data')
	if isNull( lsRecData ) or len( lsRecData ) = 0 then continue

	//sku
	lsTemp = mid( lsRecData,liSkuStart, liSkuLength )
	if isNull( lsTemp ) or len( lsTemp ) = 0 then
		gu_nvo_process_files.uf_writeError("Row: " + string( llRowPOs ) + " - Sku is not present. Record will not be processed.")
		continue
	End If
	_sku = Upper( Trim( lsTemp ) )
	
	// marl
	updateMarl = true
	lsTemp = mid( lsRecData,liMarlStart, liMarlLength )
	if isNull( lsTemp ) or len( lsTemp ) = 0 then updateMarl = false
	_MARL = Upper( Trim( lsTemp ) )
	
	// quality hold
	updateQhold = true
	lsTemp = mid( lsRecData,liQhold, liQholdLength )
	if isNull( lsTemp ) or len( lsTemp ) = 0 then	 updateQhold = false
	_Qhold = Upper( Trim( lsTemp ) )

	_itemRows = idsItem.retrieve( asProject, _sku )
	if _itemRows <= 0 then
		gu_nvo_process_files.uf_writeError("Row: " + string( llRowPOs ) + " - Unable to retrieve sku, " + _sku + " from item master. Record will not be processed.")
		continue
	end if
	
	for index = 1 to _itemRows
		
		// test for a change in MARL or Quality Hold....set the change date if there is a difference
		_supplier = Upper( trim( idsItem.object.supp_code[ index] ))
		_invMarl = Upper( trim(idsItem.object.user_field6[ index ]  ))
		_invQhold = Upper( trim( idsItem.object.user_field12[ index ] ))
		if isNull( _invMarl ) then _invMarl = ''
		if isNull( _invQHold ) then _invQHold = ''
		if updateMarl then
			if _invMarl <> _MARL then
				setChange( _sku, _marldesc, _invMarl, _MARL,  ldtToday, _supplier,"MARL" )
				idsItem.object.marl_change_date[ index ] = ldtToday
			end if
			idsItem.object.user_field6[ index ] = _MARL
		end if
		
		if updateQhold	then
			if _invQhold <> _Qhold then 
				setChange( _sku, _qdesc, _invQhold, _Qhold,  ldtToday, _supplier, "Hold"  )
				idsItem.object.quality_hold_change_date[ index ] = ldtToday
			end if
			idsItem.object.user_field12[ index ] = _Qhold
		end if
		
		// set the data and update
		if updateMarl or updateQhold then 
			idsItem.object.last_user[ index ] = 'Sweeper'
			idsItem.object.last_update[ index ] = ldtToday
		end if
	
	next
	
//	Execute Immediate "Begin Transaction" using SQLCA; 
	liRC = idsItem.Update()
	If liRC <> 1 Then
		rollback;
		gu_nvo_process_files.uf_writeError("Row: " + string( llRowPOs ) + " - Unable to Update item master. Record will not be processed.")
		continue
	else
		commit;
	end if
	_cntr++

Next // item master row

// If the record count is less than raw data count, then we dropped row(s) - Return error
If _cntr < ( iu_ds.RowCount() -1 ) Then
	_cntr = ( iu_ds.RowCount() ) - _cntr
	gu_nvo_process_files.uf_writeError( string( _cntr ) + " Rows were Rejected.")
End If

if idsChanges.rowcount() > 0 then doSendReport( asIni )

return 0

end function

public subroutine dosendreport (string asini);// doSendReport( string asIni )

string lsFileName
string lsDescription
string lslogout
string lsemailstring
string lsOutputName
long emailRow

datastore ldsEmailAddress

ldsEmailAddress = f_datastoreFactory( 'd_email_address' )
emailRow = ldsEmailAddress.retrieve( getProject(), 'MARLCHANGE' )
lsemailstring = ldsEmailAddress.object.email_address[ emailrow ]

idsChanges.setsort( 'description a' )
idsChanges.sort()

lsDescription = '3COM MARL/Quality Hold Changes'
lsOutputName = '3CMARLCHANGES' + string( datetime( today(), now() ) , 'mmddyyyyhhmm' ) + '.xls'
//create a file in the archive directory and email it...
lsFileName = ProfileString(asIni, getProject() ,"archivedirectory","") + '\' + lsOutputName 
idsChanges.SaveAs(lsFileName,excel5!,True)
lsLogout = '     Attached is the ' + lsDescription + ' for ' + string(today(),'mm-dd-yyyy hh:mm')
gu_nvo_process_files.uf_send_email( getproject() ,lsemailstring,'XPO Logistics WMS - ' + lsdescription,lsLogOut,lsFileName) 

end subroutine

public subroutine setchange (string sku, string description, string oldvalue, string newvalue, datetime changedate, string supplier, string changetype);// setChange( string sku, string desc, string oldvalue, string newvalue, datetime changedate, string supplier, string changetype )

long 			insertRow

insertRow = idsChanges.insertrow( 0 )
if insertRow <=0 then return

idsChanges.object.sku[ insertRow ] = sku
idsChanges.object.supplier[ insertRow ] = supplier
idsChanges.object.description[ insertRow ] = description
idsChanges.object.date_of_change[ insertRow ] = changedate

if changetype = "MARL" then
	idsChanges.object.marl_old_value[ insertRow ] = oldvalue
	idsChanges.object.marl_new_value[ insertRow ] = newvalue
else
	idsChanges.object.hold_old_value[ insertRow ] = oldvalue
	idsChanges.object.hold_new_value[ insertRow ] = newvalue
end if


return
end subroutine

public function integer uf_process_gls_rma_receipt (string aspath, string asproject);//Process RMA Receipt (GLS side, not Revenue)
			

String		lsLogout,lsRecData,lsRecType, lsWarehouse, lsOwner, lsSUppCode, lsSKU, lsCOO

Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos,llNewHeaderRow,llNewDetailRow,  llOrderSeq, &
				llBatchSeq,	llLineSeq, llRC, llOwner, llCount
				
Decimal		ldQty, ldExistingQTY
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError


// Make sure the datasources are set
idsPOHeader.dataobject= 'd_mercator_3com_gls_rma_header'
idsPOHeader.SetTransObject(SQLCA)
idsPOdetail.dataobject= 'd_mercator_3com_gls_rma_detail'
idsPOdetail.SetTransObject(SQLCA)

// reset datastores
idsPOHeader.reset()
idsPODetail.reset()
idsPONotes.reset()
idsItem.reset()


ldtToday = DateTime(today(),Now())

//Open the File
lsLogOut = '      - Opening File for 3COM RMA Expected Receipt (GLS) Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for 3COM Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then 
	// pvh - 09/26/06 - empty error file
	lsLogOut = "-       ***Batch Sequence Number Error, EDI Inbound get next sequence. Project: " + asProject + ". Process Aborted."
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	FileClose(liFileNo)
	Return -1
end if


//DEfault Owner to 3COM for all records
lsSuppCode = '3COM' /*owner retrieved below will default to Supplier*/
					
Select owner_id into :llOwner
From Owner
Where Owner_Cd = :lsSuppCode and owner_type = 'S' and Project_id = :asProject;


llOrderSeq = 0 /*order seq within file*/
llRowPos = 0

//read file and load to proper datastore for processing depending on record type
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/
	llRowPos ++
	
	/*Process header, Detail, addresses or Notes */
	Choose Case Upper(lsRecType)
			
		//HEADER RECORD
		Case  'RM' /* Header */
						
			//llnewRow = idsPOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0 /*reset detail line seq*/
			
			//Tab seperated fields can be loaded into format
			llRC = idsPOHeader.ImportString(lsRecData,1,1,2,999,9) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 9th column on the DW */
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Header Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				FileClose(liFileNo)
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			
			//Record Defaults
			llNewHeaderRow = idsPOHeader.RowCount()
			//idsPOHeader.SetItem(llNewHeaderRow,'ACtion_cd','X') /*bypass validation in next step*/
			idsPOHeader.SetITem(llNewHeaderRow,'project_id',asProject) /*Project ID*/
			idsPOHeader.SetItem(llNewHeaderRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPOHeader.SetItem(llNewHeaderRow,'order_seq_no',llOrderSeq) 
			idsPOHeader.SetItem(llNewHeaderRow,'ftp_file_name',aspath) /*FTP File Name*/
			idsPOHeader.SetItem(llNewHeaderRow,'Status_cd','N')
			idsPOHeader.SetItem(llNewHeaderRow,'Last_user','SIMSEDI')
			
			idsPOHeader.SetItem(llNewHeaderRow,'Inventory_Type','N') /* Default to NOrmal if not rpesent in file*/
			idsPOHeader.SetITem(llNewHeaderRow,'order_Type','M') /*GLS RMA */
			idsPOHeader.SetITem(llNewHeaderRow,'supp_code','3COM') /*always 3COM for supplier for RMA*/
						
			
		// DETAIL RECORD
		Case 'RD' /*Detail */
					
			//Tab seperated fields can be loaded into format
			llRC = idsPODetail.ImportString(lsRecData,1,1,2,999,9) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 9th column on the DW */
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Detail Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				FileClose(liFileNo)
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			llLineSeq ++
			
			//Add detail level defaults
			llNewDetailRow = idsPODetail.RowCOunt()
			idsPODetail.SetITem(llNewDetailRow,'project_id', asproject) /*project*/
			idsPODetail.SetITem(llNewDetailRow,'status_cd', 'N') 
		//	idsPODetail.SetITem(llNewDetailRow,'action_cd', 'U') /*should come on file */
			idsPODetail.SetITem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPODetail.SetITem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			idsPODetail.SetITem(llNewDetailRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			
			//Since we are defaulting the supplier on the header to 3COM, we need to have item master records setup for
			//3COM as well. Otherwise, w_ro won't function properly (all items must have the same supplier)
			
			lsSKU = idsPODetail.GetItemString(llNewDetailRow,'sku')
			
			Select Count(*) into :llCount
			From ITem_Master 
			Where Project_id = :asProject and sku = :lsSKU and supp_code = '3COM';
			
			If llCount <= 0 Then /*item doesn't exist for 3COM, create a new one*/
			
				llCount = idsItem.Retrieve(asProject, lsSKU)
				If llCount > 0 Then
						
					lirc = idsItem.RowsCopy(1,1,Primary!,idsItem,99999,Primary!) /*copy the existing Item to new */
					idsItem.SetItem(idsItem.RowCount(),'supp_code','3COM') /*update new item */
					idsItem.SetItem(idsItem.RowCount(),'owner_id',llOwner) /*update new item */
					
					liRC = idsItem.Update()
					If liRC = 1 Then
						Commit;
					Else
						Rollback;
						lsLogOut =  "       ***System Error!  Unable to Save new item Master Records (RMA 3COM Item Insert) to database "
						FileWrite(gilogFileNo,lsLogOut)
						gu_nvo_process_files.uf_writeError(lsLogOut)
						FileClose(liFileNo)
						Return -1
					End If
					
				End If /*item exists for any supplier */
					
			End If /*item doesn't exist for 3COM */
							
			//If inventory Type not on file, we want to reject it in the generic PO processor
			If isNull(idsPODetail.GetITemString(llNewDetailRow,'Inventory_Type')) or idsPODetail.GetITemString(llNewDetailRow,'Inventory_Type') = '' Then
				idsPODetail.SetITem(llNewDetailRow,"inventory_type",'<NULL>') 
			End If
			
			If llOwner > 0 Then
				idsPODetail.SetITem(llNewDetailRow,'owner_id',String(llOwner))
			End If
			
			//Get COO default from ITem Master
			Select Country_of_Origin_Default Into :lsCOO
			From ITem_MAster
			Where Project_id = :asProject and Sku = :lsSKU and Supp_code = :lsSuppCode;
			
			idsPODetail.SetITem(llNewDetailRow,"country_of_Origin",lsCOO)
					
		
		Case Else /*Invalid rec type */
			
			// 10/07 - PCONKL - we wnat to reject the ntire file. An invalid rec type is probably indicative of a more serious problem with the file
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. *** THIS ENTIRE FILE will not be processed ***.")
			FileClose(liFileNo)
			Return -1
			
//			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
//			lbError = True
//			Continue /*Next Record */
			
	End Choose /*Header, Detail or Notes */
	
	//Read the Next File record
	liRC = FileRead(liFileNo,lsRecData)
	
Loop /*Next File record*/

FileClose(liFileNo)

//Save Changes
liRC = idsPOHeader.Update()
If liRC = 1 Then
	liRC = idsPODetail.Update()
End If

If liRC = 1 Then
	liRC = idsPONotes.Update()
End If

If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new RMA Records to database "
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

If lbError Then Return -1

Return 0
end function

public function integer uf_process_gls_po_receipt (string aspath, string asproject);//Process PO Receipt (GLS side, not Revenue)
			

String		lsLogout,lsRecData,lsRecType, lsWarehouse, lsOwner, lsSUppCode, lsSKU, lsCOO

Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos,llNewHeaderRow,llNewDetailRow,  llOrderSeq, &
				llBatchSeq,	llLineSeq, llRC, llOwner, llCount
				
Decimal		ldQty, ldExistingQTY
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError


// Make sure the datasources are set
idsPOHeader.dataobject= 'd_mercator_3com_gls_po_header'
idsPOHeader.SetTransObject(SQLCA)
idsPOdetail.dataobject= 'd_mercator_3com_gls_po_detail'
idsPOdetail.SetTransObject(SQLCA)

// reset datastores
idsPOHeader.reset()
idsPODetail.reset()
idsItem.reset()


ldtToday = DateTime(today(),Now())

//Open the File
lsLogOut = '      - Opening File for 3COM PO Receipt (GLS) Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for 3COM Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then 
	// pvh - 09/26/06 - empty error file
	lsLogOut = "-       ***Batch Sequence Number Error, EDI Inbound get next sequence. Project: " + asProject + ". Process Aborted."
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	FileClose(liFileNo)
	Return -1
end if


//DEfault Owner to 3COM for all records
lsSuppCode = '3COM' /*owner retrieved below will default to Supplier*/
					
Select owner_id into :llOwner
From Owner
Where Owner_Cd = :lsSuppCode and owner_type = 'S' and Project_id = :asProject;


llOrderSeq = 0 /*order seq within file*/
llRowPos = 0

//read file and load to proper datastore for processing depending on record type
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/
	llRowPos ++
	
	/*Process header, Detail, addresses or Notes */
	Choose Case Upper(lsRecType)
			
		//HEADER RECORD
		Case  'PM' /* Header */
						
			//llnewRow = idsPOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0 /*reset detail line seq*/
			
			//Tab seperated fields can be loaded into format
			llRC = idsPOHeader.ImportString(lsRecData,1,1,2,999,8) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 8th column on the DW */
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Header Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				FileClose(liFileNo)
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			
			//Record Defaults
			llNewHeaderRow = idsPOHeader.RowCount()
			idsPOHeader.SetItem(llNewHeaderRow,'ACtion_cd','X') /*bypass validation in next step*/
			idsPOHeader.SetITem(llNewHeaderRow,'project_id',asProject) /*Project ID*/
			idsPOHeader.SetItem(llNewHeaderRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPOHeader.SetItem(llNewHeaderRow,'order_seq_no',llOrderSeq) 
			idsPOHeader.SetItem(llNewHeaderRow,'ftp_file_name',aspath) /*FTP File Name*/
			idsPOHeader.SetItem(llNewHeaderRow,'Status_cd','N')
			idsPOHeader.SetItem(llNewHeaderRow,'Last_user','SIMSEDI')
			
			idsPOHeader.SetItem(llNewHeaderRow,'Inventory_Type','N') /*Default header Inv TYpe to Normal*/
			
			//TODO - Translate 4 char order type to SIMS order type
			Choose Case Trim(Upper(idsPoHeader.GetITEmString(llNewHeaderRow,'order_type')))
					
				case 'ZUB' /* Stock Transport' */
					idsPOHeader.SetItem(llNewHeaderRow,'order_type','U')
				Case 'ZRP' /*Repair*/
					idsPOHeader.SetItem(llNewHeaderRow,'order_type','R')
				Case 'ZNB' /* New Buy/Allocation*/
					idsPOHeader.SetItem(llNewHeaderRow,'order_type','N')
				Case 'WA' /*FSL Pre Alert */
					idsPOHeader.SetItem(llNewHeaderRow,'order_type','A')
					
			End Choose
			
			//idsPOHeader.SetITem(llNewHeaderRow,'order_Type','M') /*GLS RMA */
			idsPOHeader.SetITem(llNewHeaderRow,'supp_code','3COM') /*always 3COM for supplier for RMA*/
						
			
		// DETAIL RECORD
		Case 'PD' /*Detail */
					
			//Tab seperated fields can be loaded into format
			llRC = idsPODetail.ImportString(lsRecData,1,1,2,999,9) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 9th column on the DW */
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Detail Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				FileClose(liFileNo)
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			
			llLineSeq ++
			
			//Add detail level defaults
			llNewDetailRow = idsPODetail.RowCOunt()
			idsPODetail.SetITem(llNewDetailRow,'project_id', asproject) /*project*/
			idsPODetail.SetITem(llNewDetailRow,'status_cd', 'N') 
		//	idsPODetail.SetITem(llNewDetailRow,'action_cd', 'U') /*should come on file */
			idsPODetail.SetITem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPODetail.SetITem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			idsPODetail.SetITem(llNewDetailRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			
			//Since we are defaulting the supplier on the header to 3COM, we need to have item master records setup for
			//3COM as well. Otherwise, w_ro won't function properly (all items must have the same supplier)
			
			lsSKU = idsPODetail.GetItemString(llNewDetailRow,'sku')
			
			Select Count(*) into :llCount
			From ITem_Master 
			Where Project_id = :asProject and sku = :lsSKU and supp_code = '3COM';
			
			If llCount <= 0 Then /*item doesn't exist for 3COM, create a new one*/
			
				llCount = idsItem.Retrieve(asProject, lsSKU)
				If llCount > 0 Then
						
					lirc = idsItem.RowsCopy(1,1,Primary!,idsItem,99999,Primary!) /*copy the existing Item to new */
					idsItem.SetItem(idsItem.RowCount(),'supp_code','3COM') /*update new item */
					idsItem.SetItem(idsItem.RowCount(),'owner_id',llOwner) /*update new item */
					
					liRC = idsItem.Update()
					If liRC = 1 Then
						Commit;
					Else
						Rollback;
						lsLogOut =  "       ***System Error!  Unable to Save new item Master Records (RMA 3COM Item Insert) to database "
						FileWrite(gilogFileNo,lsLogOut)
						gu_nvo_process_files.uf_writeError(lsLogOut)
						FileClose(liFileNo)
						Return -1
					End If
					
				End If /*item exists for any supplier */
					
			End If /*item doesn't exist for 3COM */
							
			//If inventory Type not on file, we want to reject it in the generic PO processor
			If isNull(idsPODetail.GetITemString(llNewDetailRow,'Inventory_Type')) or idsPODetail.GetITemString(llNewDetailRow,'Inventory_Type') = '' Then
				idsPODetail.SetITem(llNewDetailRow,"inventory_type",'<NULL>') 
			End If

			If llOwner > 0 Then
				idsPODetail.SetITem(llNewDetailRow,'owner_id',String(llOwner))
			End If
			
			//Get COO default from ITem Master
			Select Country_of_Origin_Default Into :lsCOO
			From ITem_MAster
			Where Project_id = :asProject and Sku = :lsSKU and Supp_code = :lsSuppCode;
			
			idsPODetail.SetITem(llNewDetailRow,"country_of_Origin",lsCOO)
					
		
		Case Else /*Invalid rec type */
			
			// 10/07 - PCONKL - we wnat to reject the ntire file. An invalid rec type is probably indicative of a more serious problem with the file
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. *** THIS ENTIRE FILE will not be processed ***.")
			FileClose(liFileNo)
			Return -1
			
//			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
//			lbError = True
//			Continue /*Next Record */
			
	End Choose /*Header, Detail or Notes */
	
	//Read the Next File record
	liRC = FileRead(liFileNo,lsRecData)
	
Loop /*Next File record*/

FileClose(liFileNo)

//Save Changes
liRC = idsPOHeader.Update()
If liRC = 1 Then
	liRC = idsPODetail.Update()
End If

If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new PO (GLS) Records to database "
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

If lbError Then Return -1

Return 0
end function

public function integer uf_process_gls_so (string aspath, string asproject);//Process Sales Order files for 3COM (RMA side)
				
String		lsLogout,lsRecData,lsRecType, lsWarehouse, lsOwner, lsNotes

String 		ls_carrier,ls_ship_ref,ls_ship_via,ls_transport_mode
Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos,llNewHeaderRow,llNewDetailRow, llNewAddressRow, llNewNotesRow, llOrderSeq, &
				llBatchSeq,	llLineSeq, llRC, llOwner
				
Decimal		ldQty, ldExistingQTY
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError

ldtToday = DateTime(today(),Now())

// pvh - 08/29/05
idsDONotes.dataobject = 'd_mercator_do_Notes'
idsDONotes.SetTransObject(SQLCA)

//08/07 - PCONKL - Make sure correct dataobjects are loaded - Revenue side is using different templates
idsDOHeader.dataobject = 'd_mercator_3com_gls_do_Header'
idsDODetail.dataobject = 'd_mercator_3com_gls_do_Detail'

idsDOHeader.SetTransObject(SQLCA)
idsDODetail.SetTransObject(SQLCA)
idsDONotes.SetTransObject(SQLCA)
idsDOAddress.SetTransObject(SQLCA)

// pvh - 08/22/05
idsDOHeader.reset()
idsDODetail.reset()
idsDONotes.reset()
idsDOAddress.reset() 
//

//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for 3COM Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//All records will be loaded with 3COM as the owner 
Select owner_id into :llOwner
From Owner
Where Owner_Cd = '3COM' and owner_type = 'S' and Project_id = :asProject;

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then
	// pvh - 09/26/06 - empty error file
	lsLogOut = "-       ***Batch Sequence Number Error, EDI Inbound get next sequence. Project: " + asProject + ". Process Aborted."
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	FileClose(liFileNo)
	Return -1
end if

llOrderSeq = 0 /*order seq within file*/
llRowPos = 0

//read file and load to proper datastore for processing depending on record type
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/
	llRowPos ++
	
	/*Process header, Detail, addresses or Notes */
	Choose Case Upper(lsRecType)
			
		//HEADER RECORD
		Case 'DM' /* Header */
						
			//llnewRow = idsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0 /*reset detail line seq*/
			
			//Tab seperated fields can be loaded into format
			llRC = idsDOHeader.ImportString(lsRecData,1,1,2,999,8) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 8th column on the DW */
			
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Header Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				FileClose(liFileNo)
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			
			//Record Defaults
			llNewHeaderRow = idsDOHeader.RowCount()		
			
			//Added by DGM 08/08/2005 For autopopulating carrier columns
			ls_carrier= Trim(idsDOHeader.object.carrier[llNewHeaderRow])
			
			// 10/07 - PCONKL - Carrier "SHIP012514" maps to DHL Express for both US and Europe. Based on the Warehouse code, we need to 
			//							set it to either "SHIP012514US" or "SHIP012514ECX" so we can have seperate TRAX Service level codes
			//							The Goods Issue transaction will strip off the last 2 characters
			
			Choose Case Upper(ls_carrier)
					
				Case 'SHIP012514'
				
					Choose Case Upper(trim(idsDOHeader.GetITemString(llNewHeaderRow,'wh_code')))
						
//						Case '3CGLSAMI' /*Nashville*/
//							ls_carrier = 'SHIP012514US'
						Case '3CGLSEMEA' /*Eersel*/
							ls_carrier = 'SHIP012514ECX'
						
					End Choose
					
//				Case 'SHIP010961'
//					
//					If Upper(trim(idsDOHeader.GetITemString(llNewHeaderRow,'wh_code'))) = '3CGLSAMI' Then
//						ls_carrier = 'SHIP010961GRD'
//					End If
					
			End Choose
						
			idsDoheader.SetItem(llNewHeaderRow,'Carrier',ls_carrier)
				
			
			
			IF ls_carrier > '' THEN
				
				Select Ship_Ref,
				Ship_Via,
				Transport_Mode
				into :ls_ship_ref,
				:ls_ship_via,
				:ls_transport_mode 
				from carrier_master
				Where project_id = '3COM_NASH'
				and carrier_code= :ls_carrier ;
				
				idsDOHeader.object.Ship_ref[llNewHeaderRow]=ls_ship_ref
				idsDOHeader.object.Ship_Via[llNewHeaderRow]=ls_ship_via
				idsDOHeader.object.transport_mode[llNewHeaderRow]=ls_transport_mode
				
			END IF	
			
			idsDOHeader.SetItem(llNewHeaderRow,'ACtion_cd','A') /*always a new Order*/
			idsDOHeader.SetITem(llNewHeaderRow,'project_id',asProject) /*Project ID*/
			
			idsDOHeader.SetItem(llNewHeaderRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDOHeader.SetItem(llNewHeaderRow,'order_seq_no',llOrderSeq) 
			idsDOHeader.SetItem(llNewHeaderRow,'ftp_file_name',aspath) /*FTP File Name*/
			idsDOHeader.SetItem(llNewHeaderRow,'Status_cd','N')
			idsDOHeader.SetItem(llNewHeaderRow,'Inventory_Type','N') /*default to Normal*/
			
			idsDOHeader.SetItem(llNewHeaderRow,'Ord_date','') /*This willd default to the current date/time in the main driver*/

			//If warehouse not passed on file, set to default WH for project
//			If isNull(idsDOHeader.GetITemString(llNewHeaderRow,'wh_code')) Or idsDOHeader.GetITemString(llNewHeaderRow,'wh_code') = '' Then
//				idsDOHeader.SetITem(llNewHeaderRow,'wh_code',lswarehouse) /*Default WH for Project */
//			End If
			
			//Default Order Type Based on value sent in 'Transaction Type'
			Choose Case Upper(Trim((idsDOHeader.GetITemString(llNewHeaderRow,'Transaction_type'))))
				Case 'LF' /*RMA Shipment*/
					idsDOHeader.SetITem(llNewHeaderRow,'order_Type','R')
				Case 'LB' /*Repair Vendor Shipment*/
					idsDOHeader.SetITem(llNewHeaderRow,'order_Type','V')
				Case 'NL', 'NLC'
					idsDOHeader.SetITem(llNewHeaderRow,'order_Type','T')
				Case Else /* what do we want to default to here*/
					idsDOHeader.SetITem(llNewHeaderRow,'order_Type','S')
			End Choose
				
			//Address 1 really contains the customer Name - Remap
			idsDOHeader.SetITem(llNewHeaderRow,'cust_name',idsDOHeader.GetITemString(llNewHeaderRow,'address_1'))
			idsDOHeader.SetITem(llNewHeaderRow,'address_1','')
			
			//Rollup address lines (mainly for TRAX)
			If idsDoHeader.GetITemString(llNewHeaderRow,'address_1') = '' or isnull(idsDoHeader.GetITemString(llNewHeaderRow,'address_1')) Then
				
				If idsDoHeader.GetITemString(llNewHeaderRow,'address_2') > '' Then
					idsDOHeader.SetITem(llNewHeaderRow,'address_1',idsDOHeader.GetITemString(llNewHeaderRow,'address_2'))
					idsDOHeader.SetITem(llNewHeaderRow,'address_2','')
				ElseIf idsDoHeader.GetITemString(llNewHeaderRow,'address_3') > '' Then
					idsDOHeader.SetITem(llNewHeaderRow,'address_1',idsDOHeader.GetITemString(llNewHeaderRow,'address_3'))
					idsDOHeader.SetITem(llNewHeaderRow,'address_3','')
				ElseIf idsDoHeader.GetITemString(llNewHeaderRow,'address_4') > '' Then
					idsDOHeader.SetITem(llNewHeaderRow,'address_1',idsDOHeader.GetITemString(llNewHeaderRow,'address_4'))
					idsDOHeader.SetITem(llNewHeaderRow,'address_4','')
				End If
				
			End If
			
			If idsDoHeader.GetITemString(llNewHeaderRow,'address_2') = '' or isnull(idsDoHeader.GetITemString(llNewHeaderRow,'address_2')) Then
				
				If idsDoHeader.GetITemString(llNewHeaderRow,'address_3') > '' Then
					idsDOHeader.SetITem(llNewHeaderRow,'address_2',idsDOHeader.GetITemString(llNewHeaderRow,'address_3'))
					idsDOHeader.SetITem(llNewHeaderRow,'address_3','')
				ElseIf idsDoHeader.GetITemString(llNewHeaderRow,'address_4') > '' Then
					idsDOHeader.SetITem(llNewHeaderRow,'address_2',idsDOHeader.GetITemString(llNewHeaderRow,'address_4'))
					idsDOHeader.SetITem(llNewHeaderRow,'address_4','')
				End If
				
			End If
			
			If idsDoHeader.GetITemString(llNewHeaderRow,'address_3') = '' or isnull(idsDoHeader.GetITemString(llNewHeaderRow,'address_3')) Then
				
				If idsDoHeader.GetITemString(llNewHeaderRow,'address_4') > '' Then
					idsDOHeader.SetITem(llNewHeaderRow,'address_3',idsDOHeader.GetITemString(llNewHeaderRow,'address_4'))
					idsDOHeader.SetITem(llNewHeaderRow,'address_4','')
				End If
				
			End If
			
			//The header record has some address fields that we're storing in an Alt Address Table
			
			//BillTo Address
			If idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_Code') > '' Then /* Bill to address present*/
			
				llNewAddressRow = idsDOAddress.InsertRow(0)
				idsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				idsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				idsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				idsDOAddress.SetItem(llNewAddressRow,'address_type','BT') /* Bill To Address */
				idsDOAddress.SetItem(llNewAddressRow,'Name',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_Code'))
				idsDOAddress.SetItem(llNewAddressRow,'address_1',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_address_1'))
				idsDOAddress.SetItem(llNewAddressRow,'address_2',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_address_2'))
				idsDOAddress.SetItem(llNewAddressRow,'address_3',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_address_3'))
				idsDOAddress.SetItem(llNewAddressRow,'address_4',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_address_4'))
				idsDOAddress.SetItem(llNewAddressRow,'district',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_district'))
				idsDOAddress.SetItem(llNewAddressRow,'City',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_City'))
				idsDOAddress.SetItem(llNewAddressRow,'State',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_state'))
				idsDOAddress.SetItem(llNewAddressRow,'Zip',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_Zip'))
				idsDOAddress.SetItem(llNewAddressRow,'Country',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_Country'))
				idsDOAddress.SetItem(llNewAddressRow,'tel',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_tel'))
				
			End If /* Bill to Address Present */
			
			//Intermediary Address
			If idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_Code') > '' Then /* Intemerd Consignee address present */
			
				llNewAddressRow = idsDOAddress.InsertRow(0)
				idsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				idsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				idsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				idsDOAddress.SetItem(llNewAddressRow,'address_type','IT') /* Intermediary Address */
				idsDOAddress.SetItem(llNewAddressRow,'Name',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_Code'))
				idsDOAddress.SetItem(llNewAddressRow,'address_1',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_address_1'))
				idsDOAddress.SetItem(llNewAddressRow,'address_2',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_address_2'))
				idsDOAddress.SetItem(llNewAddressRow,'address_3',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_address_3'))
				idsDOAddress.SetItem(llNewAddressRow,'address_4',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_address_4'))
				idsDOAddress.SetItem(llNewAddressRow,'district',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_district'))
				idsDOAddress.SetItem(llNewAddressRow,'City',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_City'))
				idsDOAddress.SetItem(llNewAddressRow,'State',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_state'))
				idsDOAddress.SetItem(llNewAddressRow,'Zip',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_Zip'))
				idsDOAddress.SetItem(llNewAddressRow,'Country',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_Country'))
				idsDOAddress.SetItem(llNewAddressRow,'tel',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_tel'))
				
			End If /* Intermed Consignee Address Present */
			
			//Sold To Address
			If idsDOHeader.GetITemString(llNewHeaderROw,'sold_to_Code') > '' Then /* Sold To address present */
			
				llNewAddressRow = idsDOAddress.InsertRow(0)
				idsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				idsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				idsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				idsDOAddress.SetItem(llNewAddressRow,'address_type','ST') /* Sold TO Address */
				idsDOAddress.SetItem(llNewAddressRow,'Name',idsDOHeader.GetITemString(llNewHeaderROw,'sold_to_Code'))
				idsDOAddress.SetItem(llNewAddressRow,'address_1',idsDOHeader.GetITemString(llNewHeaderROw,'sold_to_address_1'))
								
			End If /* Sold To Address Present */
			
			
		// DETAIL RECORD
		Case 'DD' /*Detail */
					
			//Tab seperated fields can be loaded into format
			llRC = idsDODetail.ImportString(lsRecData,1,1,2,999,7) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 7th column on the DW */
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Detail Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				FileClose(liFileNo)
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			llLineSeq ++
			
			//Add detail level defaults
			llNewDetailRow = idsDODetail.RowCOunt()
			idsDODetail.SetITem(llNewDetailRow,'project_id', asproject) /*project*/
			idsDODetail.SetITem(llNewDetailRow,'status_cd', 'N') 
			idsDODetail.SetITem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDODetail.SetITem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			idsDODetail.SetITem(llNewDetailRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			
//			//If inventory Type not on file, default to Normal
//			If isNull(idsDODetail.GetITemString(llNewDetailRow,'Inventory_Type')) or idsDODetail.GetITemString(llNewDetailRow,'Inventory_Type') = '' Then
//				idsDODetail.SetITem(llNewDetailRow,"inventory_type",'N')
//			End If

			//We always want to set the owner to 3COM - All product should be shipped as 3COM owned
			If llOwner > 0 Then
				idsDODetail.SetITem(llNewDetailRow,'owner_id',String(llOwner))
			End If
					
		//Notes
		Case 'DN'
			
			//Tab seperated fields can be loaded into format
			llRC = idsDONotes.ImportString(lsRecData,1,1,2,999,5) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 5th column on the DW */
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Notes Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			
			llNewNotesRow = idsDONotes.RowCount()
			idsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
			idsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			
			// 03/05 - PCONKL - REmove any double quotes from Notes - will cause setitem on Packlist to bomb
			lsNotes = Trim(idsDONotes.GetITemString(llNewNotesRow,'note_Text'))
			Do While Pos(lsNotes,'"') > 0
				lsNotes = Replace(lsNotes,Pos(lsNotes,'"'),1,"'")
			Loop
			
			idsDONotes.SetITem(llnewNotesRow,'note_text',lsNotes)
			
			// 09/04 - PCONKL - For DI/BL notes, We want to also map to PackList instrucions on Header
			If idsDONotes.GetITemString(llNewNotesRow,'note_Type') = 'BL' or idsDONotes.GetITemString(llNewNotesRow,'note_Type') = 'DI' Then
				If Not isnull(idsDOHeader.GetITemString(llNewHeaderRow,'Packlist_Notes_Text')) Then
					idsDOHeader.SetItem(llNewHeaderRow,'Packlist_Notes_Text',idsDOHeader.GetITemString(llNewHeaderRow,'Packlist_Notes_Text') + Trim(idsDONotes.GetITemString(llNewNotesRow,'note_Text')) + '~r~n')
				Else
					idsDOHeader.SetItem(llNewHeaderRow,'Packlist_Notes_Text',Trim(idsDONotes.GetITemString(llNewNotesRow,'note_Text')) + '~r~n')
				End IF
			End IF
										
		Case Else /*Invalid rec type */
			
			// 10/07 - PCONKL - we wnat to reject the ntire file. An invalid rec type is probably indicative of a more serious problem with the file
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. *** THIS ENTIRE FILE will not be processed ***.")
			FileClose(liFileNo)
			Return -1
			
	End Choose /*Header, Detail or Notes */
	
	//Read the Next File record
	liRC = FileRead(liFileNo,lsRecData)
	
Loop /*Next File record*/

FileClose(liFileNo)


//Save Changes
liRC = idsDOHeader.Update()
If liRC = 1 Then
	liRC = idsDODetail.Update()
End If
If liRC = 1 Then
	liRC = idsDOAddress.Update()
End If
If liRC = 1 Then
	liRC = idsDONotes.Update()
End If

If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new SO Records to database "
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

If lbError Then Return -1

Return 0
end function

public function integer uf_process_warranty_sku (string aspath, string asproject, string asini);// integer = uf_process_warranty_sku( string aspath, string asProject, string asIni )

string		lsLogout
string		lsRecData
Integer		liFileNo
Integer		liRC
Long			llNewROw
Long			llRowPos
Long			llRowCount

string	ls_sku
integer li_warranty_length
string  ls_fru_sku

//Open the File
lsLogOut = '      - Opening File for 3Com FRU Warranty SKU Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for 3Com FRU Warranty SKU Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	llNewRow = iu_ds.InsertRow(0)
	iu_ds.SetItem(llNewRow,'rec_data',lsRecData) 
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

setGenImportDS( iu_ds )
setOutputDs( iuds_warranty_sku )
setProject ( asProject )


//Load the serial table - fields are comma seperated - Must have delimiters to the end (last field is Required)
llRowCount = iu_ds.RowCount()
if llRowCount <=0 then return -1

For llRowPOs = 1 to llRowCount 
	
	iu_ds.setrow( llRowPos )
	
	lsRecData = trim(iu_ds.GetITemString(llRowPos, 'rec_data'))

	if Left(lsRecData, 1) = "~"" then
		
		lsRecData = Mid(lsRecData, 2)
		
	end if
	
	if Right(lsRecData, 1) = "~"" then
		
		lsRecData = Mid(lsRecData, 1, len(lsRecData) - 1)
		
	end if	
	
	if isNull( lsRecData ) or len( lsRecData ) = 0 then continue
	
	
	
	llNewRow = iuds_warranty_sku.InsertRow(0)
	
	iuds_warranty_sku.setrow( llNewRow )
	setNewRow( llNewRow )
	setRecData( lsRecData )

	//project_id
	
	//Record Defaults
	iuds_warranty_sku.SetItem(llNewRow, 'Project_ID', asProject)


	integer li_Pos


	//SKU

	li_Pos = Pos(lsRecData,',')

	If li_Pos > 0 Then // If comma found 
		ls_sku = Left(lsRecData,(li_Pos - 1)) // Take everything left of the comma
		
		lsRecData = Mid( lsRecData, li_Pos + 1)
		
	Else // If no comma found whole thing is parm
		ls_sku = lsRecData
		
		lsRecData = ""
		
	End If
	
	iuds_warranty_sku.SetItem(llNewRow, 'sku', ls_sku)

	//Warranty_length

	li_Pos = Pos(lsRecData,',')

	If li_Pos > 0 Then // If comma found 
		li_warranty_length = Long(Left(lsRecData,(li_Pos - 1))) // Take everything left of the comma
		
		lsRecData = Mid( lsRecData, li_Pos + 1)
		
	Else // If no comma found whole thing is parm

		li_warranty_length = Long(lsRecData)
		
		lsRecData = ""
		
	End If
	
	iuds_warranty_sku.SetItem(llNewRow, 'warranty_length', li_warranty_length)


//fru_sku

	ls_fru_sku = lsRecData

	iuds_warranty_sku.SetItem(llNewRow, 'fru_sku', ls_fru_sku)

Next /*Warranty*/

//Save records
liRC = iuds_warranty_sku.Update()
If liRC = 1 Then
	Commit;
Else
	// If an error occurs on the entire update, try to update individually
	long errorCount
	errorCount = doIndividualRowUpdate()
	if errorCount > 0 then
		lsLogOut =  "       "+String( errorcount )+ " rows of " + string( iuds_warranty_sku.rowCount() )+ " records submitted failed update. Check For Duplicates."
		gu_nvo_process_files.uf_writeError(lsLogOut)
		FileWrite(gilogFileNo,lsLogOut)
		return -1
	end if
End If

//If serial record count is less than raw data count, then we dropped row(s) - Return error
If iuds_warranty_sku.rowCount() < ( iu_ds.RowCount() -1 ) Then
	gu_nvo_process_files.uf_writeError("       Rows were Rejected.")
	Return -1
Else
	Return 0
End If
end function

on u_nvo_proc_3com.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_3com.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
doCreateDatastores()

end event

event destructor;doDestroyDatastores()
end event

