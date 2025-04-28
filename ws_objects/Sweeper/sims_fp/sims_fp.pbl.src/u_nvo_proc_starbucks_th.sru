$PBExportHeader$u_nvo_proc_starbucks_th.sru
forward
global type u_nvo_proc_starbucks_th from nonvisualobject
end type
end forward

global type u_nvo_proc_starbucks_th from nonvisualobject
end type
global u_nvo_proc_starbucks_th u_nvo_proc_starbucks_th

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 

end prototypes

type variables

string lsDelimitChar

datastore ids_nike_sku_serialized_ind, ids_import 

u_nvo_proc_baseline_unicode 	iu_nvo_proc_baseline_unicode

long il_X


long il_governor_num
long il_xls_files_processed
end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_daily_inventory_rpt (string asinifile, string asproject, string asemail)
public function integer uf_process_purchase_order_flatfile (string aspath, string asproject, string asfile)
public function integer uf_process_xcel_file (string asproject, string aspath, string asfile)
public function string uf_convert_tab_name_to_code (string as_tab_name)
public function integer uf_reconcile_existing_po (datastore ads_load_file, integer ai_error_code, string as_store_code)
public function long uf_find_max_line_item_no (datastore ads_stbth_receive_detail, string as_ro_no)
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_po (string aspath, string asproject)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut, lsFileDesc
			
Integer	liRC
integer 	liLoadRet, liProcessRet
Boolean	bRet
boolean lb_is_xls_file

u_nvo_proc_baseline_unicode		lu_nvo_proc_baseline_unicode

lu_nvo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode	

Choose Case Upper(Left(asFile,2))
		
	Case  'SM'  
		
		liRC = lu_nvo_proc_baseline_unicode.uf_process_supplier(asPath, asProject)
		lsFileDesc = 'Supplier Master'
		
	Case  'CM'  
		
		liRC = lu_nvo_proc_baseline_unicode.uf_process_customer(asPath, asProject)
		lsFileDesc = 'Customer Master'
	
	Case 'IM'
		
			liRC = lu_nvo_proc_baseline_unicode.uf_Process_ItemMaster(asPath, asProject)
			lsFileDesc = 'Item Master'
	
	Case  'PL' ,'PO'
		
		liRC = uf_process_purchase_order_flatfile(asPath, asProject,asFile)
		lsFileDesc = 'Purchase Order - Flatfile'
		
		liRC = gu_nvo_process_files.uf_process_purchase_order(asproject)
			
			
	Case Else /*Check first 3 Chars of Filename*/
		
		//TAM 01/2016  Added FileTypes 'INB' and 'OUT'
		Choose Case Upper(Left(asFile,3))
		
			Case  'INB'  
		
//			liRC = lu_nvo_proc_baseline_unicode.uf_process_purchase_order(asPath, asProject)
//			lsFileDesc = 'Purchase Order - Baseline Flatfile'
			liRC = uf_process_po(asPath, asProject)
			lsFileDesc = 'Purchase Order - Import'


			Case  'OUT'  
		
			liRC = uf_process_so(asPath, asProject)
			lsFileDesc = 'Sales Order - Import'

			Case Else /*Excel file type*/

		
				//Excel Files
				lb_is_xls_file = true

				if Pos(Upper(aspath), "DAILY_FRESH_FOOD") > 0 OR      &
				   Pos(Upper(aspath), "NONCDC_WEEKLY_FROZEN") > 0  OR   &
				   Pos(Upper(aspath), "DAILY_AMBIENT") > 0 OR  &
				   Pos(Upper(aspath), "WEEKLY_NONCDC_INV_SM_BRU") > 0 OR  &
				   Pos(Upper(aspath), "WEEKLY_INV_SM_BRU") > 0 OR  &
				   Pos(Upper(aspath), "AUTOSHIP_SM") > 0 OR  &
				   Pos(Upper(aspath), "AUTOSHIP_INV") > 0 OR  &
				   Pos(Upper(aspath), "AUTOSHIP_BRU") > 0 OR &
				   Pos(Upper(aspath), "WEEKLY_HVS_DAILY_INV_SM_BRU") > 0 OR &
				   Pos(Upper(aspath), "CDC_PROMOCAMPAIGN") > 0 THEN

					if Upper(f_retrieve_parm('STBTH','FLAG','PROCESS_XLS_FILES_ON')) = 'Y' then
						liRC = uf_process_xcel_file(asproject, aspath, asfile)
						lsFileDesc = 'Excel File'
					else
						lsLogOut = "        XLS file processing is not turned on - File will not be processed."
						FileWrite(gilogFileNo,lsLogOut)
						gu_nvo_process_files.uf_writeError(lsLogout)
						Return -1
					end if
				else

		
					lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
					FileWrite(gilogFileNo,lsLogOut)
					gu_nvo_process_files.uf_writeError(lsLogout)
					Return -1
			
				end if
		
		End Choose
End Choose

if lb_is_xls_file and liRC = -99 then
	// No emails this case
else
	// Email the file to Ops...
	gu_nvo_process_files.uf_send_email("Starbucks-TH","CUSTFILEDIST",lsFileDesc + " file for Starbucks-TH","attached is a " + lsFileDesc + " file for Starbucks-TH ",asPath)
end if


Destroy lu_nvo_proc_baseline_unicode

// Memory cleanup
GarbageCollect()

Return liRC
end function

public function integer uf_process_daily_inventory_rpt (string asinifile, string asproject, string asemail);//28-May-2013 :Madhu - Generate Daily Inventory Report
//Process Daily Inventory Report

string lsFilename ="DailyInventoryReport-"
string lsPath,lsFileNamePath,msg,lsLogOut
int returnCode,liRC
long llRowCount

Datastore	ldsOut,ldsdir


FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started Daily Inventory Report'
FileWrite(gilogFileNo,msg)


// Create our filename and path
lsFilename +=string(datetime(today(),now()),"MMDDYYYYHHMM") + '.csv'
lsPath = ProfileString(asInifile,asproject,"ftpfiledirout","")
lsPath += '\' + lsFilename
// log it
msg = 'Confirmation Report Path & Filename: ' + lsPath
FileWrite(gilogFileNo,msg)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsdir = Create Datastore
ldsdir.Dataobject = 'd_stock_inquiry_starbucks'
lirc = ldsdir.SetTransobject(sqlca)



lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Daily Inventory Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Daily Avail Inventory Data
gu_nvo_process_files.uf_write_log('Retrieving Daily Inventory Data.....') /*display msg to screen*/
llRowCOunt = ldsdir.Retrieve(asProject,asProject)

if llRowCOunt <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(llRowCOunt)
	if llRowCOunt = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	msg = '**********************************'
	FileWrite(gilogFileNo,msg)	
	return 0 // nothing to see here...move along
end if

// Export the data to the file location
returnCode = ldsdir.saveas(lsPath,CSV!,true)
msg = 'Daily Inventory  Report Save As Return Code: ' + string(returnCode)
FileWrite(gilogFileNo,msg)
msg = 'Daily Inventory Report Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)


/* Now e-mailing the Short Shipped Report */
gu_nvo_process_files.uf_send_email("starbucks-TH",asEmail , "Daily Inventory Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Daily Inventory Report ", lsPath)

Destroy ldsdir

RETURN 0
end function

public function integer uf_process_purchase_order_flatfile (string aspath, string asproject, string asfile);
//Load Purchase Order (PM) Transaction for Baseline Unicode Client

//MEA - 8/13 - Default Supplier to CTSUS01.


STRING lsTemp, lsProject, lsSku, lsSupplier, lsWarehouse, lsOrderNumber, lsOrderType
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow
STRING lsLogOut, lsChangeID
INTEGER li_StartCol
INTEGER li_UFIdx
DECIMAL ldQuantity
STRING lsNull
STRING lsDefaultSupp_Code
INTEGER liSuppCount
BOOLEAN lbAttemptLoadDefaultSupp_Code = False
STRING lsOrderTypeDesc
Datetime ldtWHTime

SetNull(lsNull)

u_ds_datastore	ldsPOHeader,	&
				     ldsPODetail

ldsPOheader = Create u_ds_datastore
ldsPOheader.dataobject= 'd_baseline_unicode_po_header'
ldsPOheader.SetTransObject(SQLCA)

ldsPOdetail = Create u_ds_datastore
ldsPOdetail.dataobject= 'd_baseline_unicode_po_detail'
ldsPOdetail.SetTransObject(SQLCA)






Integer liFileNo
String lsStringData
Long llNewRow
Datastore ldsImport


ldsImport = Create datastore
ldsImport.dataobject = 'd_generic_import'


liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Starbucks Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = ldsImport.InsertRow(0)
	ldsImport.SetItem(llNewRow,'rec_data',lsStringData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

integer llFileRowPos
integer llFilerowCount

llFilerowCount = ldsImport.RowCount()

lsLogOut = '         - Starbucks Flat File - Rows: ' + string(llFilerowCount)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Loop through

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Purchase Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))

	//Field Name	Start	Size	Comments	Sales Import Requirements	SIMS Mapping	Menlo comments/ questions	
	//Record Type	1	5		OENTH	NA	Always "OENTH"	Yes

	lsTemp = Trim(Mid(ldsImport.GetItemString(llFileRowPos,'rec_data'),1,5)) /*Pos 1 - 5*/
	
	If NOT (lsTemp = 'OENTH' OR lsTemp = 'OENTI') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If

	Choose Case Upper(lsTemp)
	
		//Purchase Order Master
	
	
		Case 'OENTH' /*PO Header*/
			
			
			lsChangeID = 'A'	
			lsProject = 'STBTH'
			lsWarehouse = 'STBTH'
					
			//Unused	6	3		Operator ID	NA	Is this always "CN1"?	No, this is related to the User ID
			
			//Ignore
			
			
			//Trans Reference Prefix	9	4	
			
			//Ignore
			
					//POSM - Purchase Overseas Smallware
					//PORM - Purchase Overseas Raw Material
					//PLSTK - Purchase Local Stock
					//POSP - Purchase Overseas Sparepart
					//PLCOS - Purchase Local Construction Stock
					//PLFAS - Purchase Fixed Access Stock
					//POCOS - Purchase Overseas Construction Stock
					//PLCDC - Purchase Order Established from IDS"
		
					//Any text or blank	NA	Assume not required	"This is mandatory but SUN system will cutout ""P"" from each PO type.
			
			
			//Trans Reference Suffix	13	6		Any text or blank	Order number	Is this the EXTERNPOKEY to be sent back in RECADV?	Yes
			
			//Order Number
			
			lsTemp = Trim(Mid(ldsImport.GetItemString(llFileRowPos,'rec_data'),13,6)) 
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsOrderNumber = lsTemp
			End If			
			
			
			//Supplier Code	19	10	 	Ignored	Supplier	"Supplier code. Assume 1 supplier code per ""Trans Reference Suffix"".
			//Is this the Otherreference to be sent back in RECADV?"	Yes
			
			//Supplier Code	C(20)	Yes	N/A	Valid Supplier code
			
			//MEA - 8/13 - Default to CTSUS01.
			
			lsSupplier = "CTSUS01"

//			lsTemp =Trim(Mid(ldsImport.GetItemString(llFileRowPos,'rec_data'),19,10)) 
//			
//			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//				
//				//Added so if Supplier Code is not set, then if there is only one supplier, it will use that one.
//	
////				IF NOT lbAttemptLoadDefaultSupp_Code THEN
////					
////					SELECT TOP 1 Count(Supp_Code), Supp_Code  INTO :liSuppCount, :lsDefaultSupp_Code From Supplier With (NoLock) WHERE project_id =  :asproject GROUP BY Supp_Code;  
////						
////					IF liSuppCount > 1 then
////						
////					ELSE
////						
////						lsTemp = lsDefaultSupp_Code
////						
////					END IF
////		
////					lbAttemptLoadDefaultSupp_Code = True
////					
////				END IF
//		
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then	
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
//					lsSupplier = lsTemp
//				End If			
//			Else
//				lsSupplier = lsTemp
//			End If				
	
			//Transaction Type	48	5	Valid Purchase Order Definition		"Order Type = Convert to single digit. Refer to comments.
			//User field 1 - remains unchanged."	If this the POType to be sent back in the RECADV?	Yes

			
			lsTemp = Trim(Mid(ldsImport.GetItemString(llFileRowPos,'rec_data'),48,5)) 
			
			lsOrderTypeDesc = lsTemp
			
			CHOOSE CASE trim(lsTemp)
			CASE "POSM"
				lsOrderType = "1"
			CASE "PORM"
				lsOrderType = "2"
			CASE "PLSTK"
				lsOrderType = "3"
			CASE "POSP"
				lsOrderType = "4"			
			CASE "PLCOS"
				lsOrderType = "5"			
			CASE "PLFAS"
				lsOrderType = "6"			
			CASE "POCOS"
				lsOrderType = "7"			
			CASE "PLCDC"
				lsOrderType = "8"	
			CASE ELSE
				lsOrderType = lsTemp
			END CHOOSE
		

			/* End Required */		
			
			liNewRow = 	ldsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			asProject = lsProject
			
			
			ldtWHTime = f_getLocalWorldTime(lsWarehouse)
			
			ldsPOheader.SetItem(liNewRow,'project_id',lsProject)
			ldsPOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
			ldsPOheader.SetItem(liNewRow,'Request_date',String(date(ldtWHTime),'YYMMDD'))
			ldsPOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPOheader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
			ldsPOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsPOheader.SetItem(liNewRow,'Status_cd','N')
			ldsPOheader.SetItem(liNewRow,'Last_user','SIMSEDI')

			ldsPOheader.SetItem(liNewRow,'Order_No',lsOrderNumber)			
			ldsPOheader.SetItem(liNewRow,'Order_type',lsOrderType) /*Order Typer*/
			ldsPOheader.SetItem(liNewRow,'Inventory_Type','N') /*default to Normal*/
	
	
			ldsPOheader.SetItem(liNewRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsPOheader.SetItem(liNewRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			
			
			ldsPOheader.SetItem(liNewRow,'user_field1', lsOrderTypeDesc)

			//Transaction Date	29	8	yyyymmdd or blank for preset		Order date	Is this the date that the PO file is generated/ sent to Menlo?	This is the PO generation date and not the date when the file is generated.  However, usually this is the same.
	
	
			//Order Date	Date	No	N/A	Order Date
			
			lsTemp = Trim(Mid(ldsImport.GetItemString(llFileRowPos,'rec_data'),29,8)) 

			if len(lsTemp) >= 8 then
				 lsTemp = left(lsTemp,4) + "/" + mid(lsTemp,5,2) + "/" +  mid(lsTemp,7,2)
			end if 
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Ord_Date', lsTemp)
			End If	
	
	
			//Second Reference	37	10		Any text or blank for preset	Rcv Slip Nbr	Assume not required	This is required as this is sent back in the CarrierReference in the RECADV

			lsTemp = Trim(Mid(ldsImport.GetItemString(llFileRowPos,'rec_data'),37,10)) 
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'ship_ref', lsTemp)
			End If				
			
			//Order Status 1	47	1		0 : Held, 3 : Released, 6 : Issued	NA	"If 0, does this mean we should hold the inventory, and not receive?
			//If 6, assume we can proceed to receive in the inventory.
			//If 3, what is expected from Menlo?"	Normally, this is fixed to"6"
			
			//IGNORE
			
			//IGRNORE THE REST.
			//Don't seem to need in SIMS.
			
			
			//Delivery Address Code	53	10		Mandatory	NA	Is this field always "0000000000"?	Yes
			//Comments	63	25		Any text or blank for preset	NA	Assume not required	Yes
			//Ack Reference	88	10		Picking and Despatched not allowed	NA	Assume not required	Yes
			//Ack Date	98	8		Ignored	NA	Assume not required	Yes
			//Delivery Date	106	8		Ignored	NA	Assume not required	Yes
			//Delivery Date Advised	114	1		Ignored	NA	Assume not required	Yes
			//Order Period	115	7	yyyyppp or 0000000 or blank		NA	Assume not required	Yes
			//MCode0	122	15	Valid M0 code	Optional	NA	Assume not required	Yes
			//MCode1	137	15	Valid M1 code	Optional	NA	Assume not required	Yes
			//MCode2	152	15	Valid M2 code	Optional	NA	Assume not required	Yes
			//MCode3	167	15	Valid M3 code	Optional	NA	Assume not required	Yes
			//MCode4	182	15	Valid M4 code	Optional	NA	Assume not required	Yes
			//MCode5	197	15	Valid M5 code	Optional	NA	Assume not required	Yes
			//MCode6	212	15	Valid M6 code	Optional	NA	Assume not required	Yes
			//MCode7	227	15	Valid M7 code	Optional	NA	Assume not required	Yes
			//MCode8	242	15	Valid M8 code	Optional	NA	Assume not required	Yes
			//MCode9	257	15	Valid M9 code	Optional	NA	Assume not required	Yes
			//Document Issue Date	272	8		Ignored   Copied from Transaction Date	NA	Assume not required	Yes
			//Delivery Address 	280	210		Any text (spaced appropriately) or blank.	NA	Assume not required	Yes
			//
				
				
				

			
//			//Delivery Date	Date	No	N/A	Expected Delivery Date at Warehouse
//
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPOheader.SetItem(liNewRow,'arrival_date', lsTemp)
//			End If	
//
//			
//			//Carrier	C(10)	No	N/A	Carrier
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPOheader.SetItem(liNewRow,'Carrier',  lsTemp)
//			End If				
//			
//			//Supplier Invoice Number	C(30)	No	N/A	Supplier Invoice Number
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPOheader.SetItem(liNewRow,'Supp_Order_No', lsTemp)
//			End If				
//			
//			//AWB #	C(20)	No	N?A	Airway Bill/Tracking Number
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPOheader.SetItem(liNewRow,'AWB_BOL_No', lsTemp)
//			End If				
//			
//			//Transport Mode	C(10)	No	N/A	Transportation mode to warehouse
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPOheader.SetItem(liNewRow,'Transport_Mode', lsTemp)
//			End If				
//			
//			//Remarks	C(250)	No	N/A	Freeform Remarks
//
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPOheader.SetItem(liNewRow,'Remark', lsTemp)
//			End If	
//


		//Purchase Order Detail				
				
		CASE 'OENTI' /* detail*/
			
			
			lsChangeID = 'A'	
			lsProject = 'STBTH'
			lsWarehouse = 'STBTH'			
			

			//Field Name	Start	Size	Comments	Sales Import Requirements	SIMS Mapping	Menlo comments/ questions	SBUX	
			//Record Type	1	5		OENTI	NA	Always "OENTI"	Yes	
			//Update Base Price	6	1		Ignored	NA		Always "Y"	
			//Operator Id	7	3		Valid Operator ID	NA	Is this always "CN1"?	No, this is related to the User ID	
			//Trans Reference Prefix	10	4		Any existing Header or blank	NA		"This is mandatory but SUN system will cutout ""P"" from each PO type.
			//POSM - Purchase Overseas Smallware
			//PORM - Purchase Overseas Raw Material
			//PLSTK - Purchase Local Stock
			//POSP - Purchase Overseas Sparepart
			//PLCOS - Purchase Local Construction Stock
			//PLFAS - Purchase Fixed Access Stock
			//POCOS - Purchase Overseas Construction Stock
			//PLCDC - Purchase Order Established from IDS"	
			//Trans Reference Suffix	14	6		Any existing Header or blank	NA	Is this the EXTERNPOKEY to be sent back in RECADV?	Yes

			lsTemp = Trim(Mid(ldsImport.GetItemString(llFileRowPos,'rec_data'),14,6)) 

			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				
				lsLogOut = '         - Starbucks Flat File - Detail Row: ' + string(lsTemp)
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				
					
				//Make sure we have a header for this Detail...
				If ldsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'",1, ldsPoHeader.RowCount()) = 0 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
					lbDetailError = True
				End If
					
				lsOrderNumber = lsTemp
			End If			
			
			
			
			//Trans Line number	20	3		3 digits e.g. 001	Line Number	"1. Is this the EXTERNLINENO to be sent back in RECADV?
			//2. Is the SKU where line number = 999 valid, meaning we can ignore this line?"	"1. Yes
			//2. PLEASE CLARIFY YOUR QUESTION FURTHER"	"2. If you refer to the file PL120313.TXT, there are some lines where the SKU = ZVAT, do we need to receive this or ignore? Do we need to send back this in the RECADV?
			//[Ravee 9 April] This is a VAT line generated from the SUN system.  Menlo only need to import the required data per IT’s advice.  This one you can ignore."
			//Trans Line number suffix	23	1		1 digit (description lines) or blank	NA		Please leave blank	


			lsTemp = Trim(Mid(ldsImport.GetItemString(llFileRowPos,'rec_data'),20,3)) 
			
			//Ignore Line Number with 999
			
			If lsTemp = "999" then Continue
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				llLineItemNo = Long(lsTemp)
			End If				
			
			
			//Location Code	24	5		Valid Location Code or blank for preset	NA	"If 0, does this mean we don't receive in the inventory?
			//If 6, assume we can proceed to receive in the inventory.
			//If 3, what is expected from Menlo?"	"No, this is location code.
			//'000' is means existign WH. 
			//We will put ""900"" for new DC location"	
			//Item Code	29	15		Valid Item Code or blank for preset or ‘-‘ plus any text for nonstocked item.	SKU	SIMS.SKU	this is sent back in the SKU in the RECADV	

			lsTemp =Trim(Mid(ldsImport.GetItemString(llFileRowPos,'rec_data'),29,15)) 
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSku = lsTemp
			End If				
			
			
			//Item Description	44	30		Any text or blank for preset	NA	SIMS.SKU Description		
			//Delivery Due Date	74	8	yyyymmdd or 00000000 or copied from Header		NA	SIMS.Scheduled Date	same the transaction date in header	
			//Delivery Date	82	1		Ignored	NA	Assume not required	yes	
			//Order Status 1	83	1		0 : Held, 6 : Issued	NA	"If 0, does this mean we should hold the inventory, and not receive?
			//If 6, assume we can proceed to receive in the inventory."	Normally, this is always fixed to"6"	
			//Order Status 2	84	1		0 : OK, 1 : Cancelled, 2 : Undelivered	NA	What should we do if this is 1 or 2?	Normally, this is always fixed to"0"	
			//Purchase Quantity	85	19		+ or – with 5 decimal places number	Use Purchase Quantity/100, 000 and load into Quantity field 	"1. Is this the qty we are expected to receive?
			//2. If value is +000000000002400000, the actual qty without decimal point is 24?"	"1. Yes
			//2. Yes,  this is sent back in the QtyReceived in the RECADV"


//			There is a change to the EDI mapping for PO/PL as requested by customer last night only.. We need to use Stock Qty from Starbucks, instead of Purchase Qty.
//			
//			Purchase Quantity	85	19		+ or – with 5 decimal places number	NA	1. Is this the qty we are expected to receive?
//			2. If value is +000000000002400000, the actual qty without decimal point is 24?	1. No, Plese use Stock Quantity
//			2. Yes, It means 24.00000
//			Stock Quantity	104	19		+ or – with 5 decimal places number	Use Purchase Quantity/100, 000 and load into Quantity field 	What is this used for?	1. Please use this field for receive from supplier
//			2. This is sent back in the QtyReceived in the RECADV
//

			//Changed to use Stock Quantity.


			lsTemp =Trim(Mid(ldsImport.GetItemString(llFileRowPos,'rec_data'),104,19)) 

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
								
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				
//				lsLogOut =lsTemp
//				FileWrite(giLogFileNo,lsLogOut)
//				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
//				
				
				if left(lsTemp,1) = "+" then lsTemp =  mid(lsTemp,2)
				
//				lsLogOut =lsTemp
//				FileWrite(giLogFileNo,lsLogOut)
//				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
//\
				
				//Divide by 10000

				ldQuantity =dec(lsTemp) / 100000
				
//				lsLogOut = string(ldQuantity)
//				FileWrite(giLogFileNo,lsLogOut)
//				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			
				
				
			End If				
			
			
			
			
			//Stock Quantity	104	19		+ or – with 5 decimal places number	NA	What is this used for?	we will put same purshase quntity	
			//Base Cost Price	123	19		Ignored	NA	Assume not required	yes	
			//Calc Code Value1	142	19	Valid Calc code Value 1	Optional	NA	Assume not required	yes	
			//Calc Code Value2	161	19	Valid Calc code Value 2	Optional	NA	Assume not required	yes	
			//Calc Code Value3	180	19	Valid Calc code Value 3	Optional	NA	Assume not required	yes	
			//Calc Code Value4	199	19	Valid Calc code Value 4	Optional	NA	Assume not required	yes	
			//Calc Code Value5	218	19	Valid Calc code Value 5	Optional	NA	Assume not required	yes	
			//Calc Code Value6	237	19	Valid Calc code Value 6	Optional	NA	Assume not required	yes	
			//Calc Code Value7	256	19	Valid Calc code Value 7	Optional	NA	Assume not required	yes	
			//Calc Code Value8	275	19	Valid Calc code Value 8	Optional	NA	Assume not required	yes	
			//Calc Code Value9	294	19	Valid Calc code Value 9	Optional	NA	Assume not required	yes	
			//Calc Code Value10	313	19	Valid Calc code Value 10	Optional	NA	Assume not required	yes	
			//Calc Code Value11	332	19	Valid Calc code Value 11	Optional	NA	Assume not required	yes	
			//Calc Code Value12	351	19	Valid Calc code Value 12	Optional	NA	Assume not required	yes	
			//Calc Code Value13	370	19	Valid Calc code Value 13	Optional	NA	Assume not required	yes	
			//Calc Code Value14	389	19	Valid Calc code Value 14	Optional	NA	Assume not required	yes	
			//Calc Code Value15	408	19	Valid Calc code Value 15	Optional	NA	Assume not required	yes	
			//Calc Code Value16	427	19	Valid Calc code Value 16	Optional	NA	Assume not required	yes	
			//Calc Code Value17	446	19	Valid Calc code Value 17	Optional	NA	Assume not required	yes	
			//Account Code	465	10		Any Valid Chart of Account Code	NA	Assume not required	yes	
			//Asset Code	475	10		Any Valid Asset Code	NA	Assume not required	yes	
			//Asset Subcode	485	5			NA	Assume not required	yes	
			//MCode0	490	15	Valid M0 code	Optional	NA	Assume not required	yes	
			//MCode1	505	15	Valid M1 code	Optional	NA	Assume not required	yes	
			//MCode2	520	15	Valid M2 code	Optional	NA	Assume not required	yes	
			//MCode3	535	15	Valid M3 code	Optional	NA	Assume not required	yes	
			//MCode4	550	15	Valid M4 code	Optional	NA	Assume not required	yes	
			//MCode5	565	15	Valid M5 code	Optional	NA	Assume not required	yes	
			//MCode6	580	15	Valid M6 code	Optional	NA	Assume not required	yes	
			//MCode7	595	15	Valid M7 code	Optional	NA	Assume not required	yes	
			//MCode8	610	15	Valid M8 code	Optional	NA	Assume not required	yes	
			//MCode9	625	15	Valid M9 code	Optional	NA	Assume not required	yes	
												
												
						
				
			//Supplier Code	C(20)	Yes	N/A	Valid Supplier code
			
			//Set at Header Level

			lsTemp = lsSupplier
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSupplier = lsTemp
			End If			
				
			
			
			
		
		
			/* End Required */
		
		
			lbDetailError = False
			llNewDetailRow = 	ldsPODetail.InsertRow(0)
			llLineSeq ++	
			
					
			//Add detail level defaults
			ldsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsPODetail.SetItem(llNewDetailRow,'project_id', lsProject) /*project*/
			ldsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			ldsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			
			ldsPODetail.SetItem(llNewDetailRow,'Order_No',lsOrderNumber)			
			ldsPODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsPODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
			ldsPODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
			ldsPODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
			
			
			IF Upper(asproject) = 'PHYSIO-MAA' OR Upper(asproject) = 'PHYSIO-XD' THEN
				ldsPODetail.SetItem(llNewDetailRow,'User_Line_Item_No', string(llLineItemNo))
				ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No', llLineSeq)		
			END IF
			
			//Also, the PO Nbr must be populated with the order number if order type is not PLCDC. For PLCDC it will be populated with supplier+receipt date. 
			//Attached is the file that we upload into SIMS. Note that PO Nbr field is the same value as Order Nbr.
			
			IF lsOrderType = "8" THEN   //PLCDC
			//,idw_Putaway.GetITemString(i,'supp_code') + String(ldtToday,'YYYYMMDD')
				ldsPODetail.SetItem(llNewDetailRow,'po_no',lsSupplier + String(date(ldtWHTime),'YYYYMMDD')) /*PO_NO*/	//supplier+receipt date
			ELSE
				ldsPODetail.SetItem(llNewDetailRow,'po_no', lsOrderNumber) /*PO_NO*/	//order number
			END IF
			
			
//			//Inventory Type	C(1)	No	N/A	Inventory Type
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', lsTemp)
//			End If	
//			
//			//Alternate SKU	C(50)	No	N/A	Supplier’s material number
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku', lsTemp)
//			Else
//				ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku', lsNull)
//			End If	
//			
//			//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPODetail.SetItem(llNewDetailRow,'Lot_No', lsTemp)
//			End If				
//			
//			//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPODetail.SetItem(llNewDetailRow,'PO_No', lsTemp)
//			End If	
//			
//			//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPODetail.SetItem(llNewDetailRow,'PO_No2', lsTemp)
//			End If	
//			
//			//Serial Number	C(50)	No	N/A	Qty must be 1 if present
//
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPODetail.SetItem(llNewDetailRow,'Serial_No', lsTemp)
//			End If	
//			
//			//Expiration Date	Date	No	N/A	Product expiration Date
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPODetail.SetItem(llNewDetailRow,'Expiration_Date', datetime(lsTemp))
//			End If				
//			
//			//Customer  Line Item Number 	C(25)	No	N/A	Customer  Line Item Number
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
//			
//			IF Upper(asproject) = 'PHYSIO-MAA' OR Upper(asproject) = 'PHYSIO-XD' THEN
//				lsTemp = ''	
//			END IF	
//			
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//// TAM 2012/07 Remove line item number from populating from field 16.  It is populated by field 6 above
////				ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No', long(lsTemp))
//				ldsPODetail.SetItem(llNewDetailRow,'User_Line_Item_No', lsTemp)// TAM 7/11/2012 Populate the user_line_item_no from field 16
//			End If			
//			
//				
//			//Country Of Origin
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col23"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPODetail.SetItem(llNewDetailRow,'Country_of_Origin', lsTemp)
//			End If			
//							
//			//UnitOfMeasure
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col24"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPODetail.SetItem(llNewDetailRow,'uom', lsTemp)
//			End If		
//			
//				

			
		CASE Else /* Invalid Rec Type*/
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			Continue
		
	End Choose /*record Type*/
	
Next /*File record */
	
//asGenericImport = ldsImport
//adsPOheader = ldsPOheader
//adsPOdetail = ldsPOdetail

IF lbError then
	lirc =  -1	
Else
	lirc =  1
End IF

IF lirc = -1 then lbError = true else lbError = false	
	
//Save the Changes 

SQLCA.DBParm = "disablebind =0"
lirc = ldsPOHeader.Update()
	
If liRC = 1 Then
	liRC = ldsPODetail.Update()
End If
SQLCA.DBParm = "disablebind =1"	

If liRC = 1 then
	Commit;
Else
	
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new PO Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new PO Records to database!")
	Return -1
End If

If lbError Then
	Return -1
Else
	Return 0
End If




end function

public function integer uf_process_xcel_file (string asproject, string aspath, string asfile);
string lsLogOut

//liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
//If liFileNo < 0 Then
//	lsLogOut = "-       ***Unable to Open File for Starbucks Processing: " + asPath
//	FileWrite(giLogFileNo,lsLogOut)
//	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
//	Return -99 /* we wont move to error directory if we can't open the file here*/
//End If

//•	It is assumed that each of the 170 stores will place 8 excel files in an FTP location, and Menlo Operations staff need to copy the 1360 Excel files into a designated Input folder.
//•	As weekly files have 1 order date, on some days the demand or order qty will only come from daily files.
//•	Until all 1360 Excel files are placed in the Input folder, Menlo Operation staff should not use the Excel macro. This can be ensured by checking how many objects are in the status bar. For example, below screenshot shows 10 files.


//First, Load the Excel File into a working datastore 
//Process Outbound Orders
//Process Inbound Orders

string lsOrderType, lsUserField1, ls_store_code, ls_FileType, lsLastOrder, lsCustomerCode, ls_OrderDate, lsSupplier, ls_Cust_Order_Number, lsChangeID, lsFileIndType, ls_tab
long ll_line_no
integer li_count

datetime ldt_OrderDate
string  ls_Y, ls_M, ls_D, ls_H
long ll_day, ll_hour, ll_X
String la_do_xkeys[]		// array used to contain DO order keys which are not being processed
String ls_work
String ls_tab_name_ident 
boolean lb_weekly_sort_tab
String ls_work_store
String ldt_dates_to_be_processed[]
String ls_dates_to_process
boolean lb_use_filename_identifier
boolean lb_is_deleted_once
String ls_order_number_identifier
long ll_rd_qty, ll_reconcile_qty
								
// If a governor parameter exists in the lookup_table, only process that number of XLS files per sweep
if il_governor_num > 0 then
	il_xls_files_processed++
	if il_xls_files_processed > il_governor_num then
		// log once
		if il_xls_files_processed = (il_governor_num + 1) then
			lsLogOut = 'Maximum number of XLS files (' + String(il_governor_num) + ') have been processed this sweep.'
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		end if
		return -99		// return -99 so that the rest of the files remain for next sweep
	end if
end if

//Date ldt_tomorrow = RelativeDate (Today(), 1)
Date ldt_tomorrow 
ldt_tomorrow = RelativeDate (Date(f_getlocalworldtime("STBTH")), 1)

datastore lds_load_file

lds_load_file = CREATE datastore

lds_load_file.dataobject = "d_starbuck_load_excel_flatfile"

int li_rtn
string ls_range, ls_supp_code, lsFileIdent
oleobject lole_excel, lole_workbook, lole_worksheet, lole_range
//lole_excel = create oleobject
//li_rtn = lole_excel.ConnectToNewObject("excel.application")

try
	
	lole_excel = create oleobject
	li_rtn = lole_excel.ConnectToNewObject("excel.application")
	
catch (Exception e)
	
	lsLogOut = 'Exception connecting to Excel file: ' + aspath + asfile + "   Exception: " + e.getMessage()
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

	if IsValid(lole_Excel) then destroy lole_Excel
	return -1

catch (RuntimeError rte)
	
	lsLogOut = 'Runtime error connecting to Excel file: ' + aspath + asfile + "   Exception: " + e.getMessage()
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

	if IsValid(lole_Excel) then destroy lole_Excel
	return -1

finally

end try

lsLogOut = 'Excel Open Return Val:' + string(li_rtn) + "     time=" + String(now())
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

if li_rtn <> 0 then

	lsLogOut = 'Error running MS Excel api.'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/	
		
     destroy lole_Excel
		
	 return -1
else
	
//	lsLogOut = aspath
//	FileWrite(giLogFileNo,lsLogOut)
//gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/		

lsLastOrder = ""

 //string aspath = "C:\080_Daily_Fresh_Food_Week_3-9_Jun_13.xls"
 
//  string aspath = "C:\118_Weekly_nonCDC_Inv_SM_Bru_Week_3-9_Jun_13.xls"
  string lsFileType
  
  Boolean lb_generate_inbound, lb_generate_outbound
 
 
  //N, A, F or U.. depends on input filename.. e.g. if filename has “Daily_Fresh_Food” or “Daily_Ambient” or “Weekly_Inv_SM_Bru” or “HVS_Daily_Inv_SM_Bru_Week” then “N”.. If “AutoShip” or “PromoCampaign” or “Urgent” then “A”.. and so on…
 
//	The 8 file types will be classified as either daily (7 order dates in the worksheets) or weekly (only 1 order date in the file). 
//Daily files include Daily_Fresh_Food, NonCDC_Weekly_Frozen and Daily_Ambient. NonCDC_Weekly_Frozen will be considered a daily file since there are 7 order dates in the worksheets. 
//Weekly files include Weekly_Inv_SM_Bru Weekly_NonCDC_Inv_SM_Bru , AutoShip_SM, AutoShip_Inv and AutoShip_Bru. 

	 if Pos(Upper(aspath), "DAILY_FRESH_FOOD") > 0 THEN //Daily_Fresh_Food – The file name is of the format 999_Daily_Fresh_Food_ XXXXXXXXXX.xls where 999 is the 3-digit numeric store code and XXXXXXXXXX describes which week of the year.  This file will have 7 worksheets, all of which are cross dock, meaning they will be used for both inbound and outbound order generation. 

		lsFileType = "DAILY" 
		
		lb_generate_inbound = true
		lb_generate_outbound = true
		
		ls_FileType = "N"
		lsOrderType = "C"
		
		lsFileIndType = "1"
		
		lb_weekly_sort_tab = true	// treat as weekly and include the tab in branching because DM.UF22 values are not unique within a file across tabs..i.e. 2 sku's on different tabs resolve to same DM.UF22 value causing "Order Exists" issues processing OB orders
 
	elseif Pos(Upper(aspath), "NONCDC_WEEKLY_FROZEN") > 0 THEN   	//The file name is of the format 999_nonCDC_weekly_Frozen_XXXXXXXXXX.xls where 999 is the 3-digit numeric store code and XXXXXXXXXX describes which week of the year. This file is cross dock.

		lsFileType = "DAILY"
		
		lb_generate_inbound = true
		lb_generate_outbound = true
		
		ls_FileType = "N"
		lsOrderType = "F"

		lsFileIndType = "2"

	elseif Pos(Upper(aspath), "DAILY_AMBIENT") > 0 THEN   	//Daily_Ambient – The file name is of the format 999_Daily_Ambient_XXXXXXXXXX.xls where 999 is the 3-digit numeric store code and XXXXXXXXXX describes which week of the year. This file is outbound only.

		lsFileType = "DAILY"
		
		lb_generate_inbound = false
		lb_generate_outbound = true	
		
		ls_FileType = "N"
		lsOrderType = "N"

		lsFileIndType = "3"

	elseif Pos(Upper(aspath), "WEEKLY_NONCDC_INV_SM_BRU") > 0 THEN   	//Weekly_nonCDC_Inv_SM_Bru – The file name is of the format 999_Weekly_nonCDC_Inv_SM_Bru XXXXXXXXXX.xls where 999 is the 3-digit numeric store code and XXXXXXXXXX describes which week of the year. This file is outbound only.

		lsFileType = "WEEKLY"
		
		lb_generate_inbound = false
		lb_generate_outbound = true	
		
		ls_FileType = "N"
		lsOrderType = "U"
		
		lsFileIndType = "4"

		lb_weekly_sort_tab = true
		lb_use_filename_identifier = true

	elseif Pos(Upper(aspath), "WEEKLY_INV_SM_BRU") > 0 THEN   	//Weekly_Inv_SM_Bru – The file name is of the format 999_Weekly_Inv_SM_Bru_XXXXXXXXXX.xls where 999 is the 3-digit numeric store code and XXXXXXXXXX describes which week of the year. This file is outbound only.

		lsFileType = "WEEKLY"
		
		lb_generate_inbound = false
		lb_generate_outbound = true	
		
		ls_FileType = "N"
		lsOrderType = "H"
	
		lsFileIndType = "5"	
	
		lb_weekly_sort_tab = true
		lb_use_filename_identifier = true
	
	elseif Pos(Upper(aspath), "AUTOSHIP_SM") > 0 THEN   	//AutoShip_SM – The file name is of the format 999_ AutoShip_SM_XXXXXXXXXX.xls where 999 is the 3-digit numeric store code and XXXXXXXXXX describes which week of the year. This file is outbound only.

		lsFileType = "WEEKLY"
		
		lb_generate_inbound = false
		lb_generate_outbound = true		
		
		ls_FileType = "A"
		lsOrderType = "A"

		lsFileIndType = "6"

		lb_use_filename_identifier = true
		ls_order_number_identifier = "SM1"

	elseif Pos(Upper(aspath), "AUTOSHIP_INV") > 0 THEN   	//AutoShip_Inv – The file name is of the format 999_ AutoShip_Inv_XXXXXXXXXX.xls where 999 is the 3-digit numeric store code and XXXXXXXXXX describes which week of the year. This file is outbound only.


		lsFileType = "WEEKLY"
		
		lb_generate_inbound = false
		lb_generate_outbound = true
		
		ls_FileType = "A"
		//lsOrderType = "A"
		//lsOrderType = "W"

		// Per Boon Hee...
		// Order types to be changed:
		// a. For files containing “Weekly_HVS_Daily_Inv_SM_Bru” for worksheet = “Weekly_Ambient_Bru”, order type = M. This is good.
		// b. For files containing “NONCDC_AutoShip”, the order type should be W, not A. This is good.
		// But for files containing “_CDC_AUTOSHIP”, the order type should remain as A. It was changed to W.
		//
		if Pos(Upper(aspath), "_CDC_AUTOSHIP") > 0 then
			lsOrderType = "A"
		else
			// “NONCDC_AutoShip”
			lsOrderType = "W"
		end if

		lsFileIndType = "7"
		
		lb_use_filename_identifier = true
		ls_order_number_identifier = "INV"
		
	elseif Pos(Upper(aspath), "AUTOSHIP_BRU") > 0 THEN   	//•	AutoShip_Bru – The file name is of the format 999_ AutoShip_Bru_XXXXXXXXXX.xls where 999 is the 3-digit numeric store code and XXXXXXXXXX describes which week of the year. This file is outbound only.

		lsFileType = "WEEKLY"
		
		lb_generate_inbound = false
		lb_generate_outbound = true				

		ls_FileType = "A"
		lsOrderType = "A"
	
		lsFileIndType = "8"

		lb_use_filename_identifier = true
		ls_order_number_identifier = "BRU"
		
	elseif Pos(Upper(aspath), "WEEKLY_HVS_DAILY_INV_SM_BRU") > 0 THEN   	//Weekly_HVS_Daily_Inv_SM_Bru – The file name is of the format 999_Weekly_HVS_Daily_Inv_SM_Bru_XXXXXXXXXX.xlsx where 999 is the 3-digit numeric store code and XXXXXXXXXX describes which week of the year. This file is outbound only.

		lsFileType = "DAILY"
		
		lb_generate_inbound = false
		lb_generate_outbound = true	
		
		ls_FileType = "N"
		lsOrderType = "N"
		
		lsFileIndType = "9"

		//lb_weekly_sort_tab = false
		lb_weekly_sort_tab = true


//	elseif Pos(Upper(aspath), "CDC_PROMOCAMPAIGN_INV") > 0 THEN   	//999_CDC_PromoCampaign_Inv – The file name is of the format 999_016_CDC_PromoCampaign_Inv_XXXXXXXXXX.xlsx where 999 is the 3-digit numeric store code and XXXXXXXXXX describes which week of the year. This file is outbound only.
	elseif Pos(Upper(aspath), "CDC_PROMOCAMPAIGN") > 0 THEN   	// Treat all 6 Promo file types the same except for the file indicator type

		lsFileType = "WEEKLY"

		lb_generate_inbound = false
		lb_generate_outbound = true	
		
		ls_FileType = "P"
		lsOrderType = "P"

//		lsFileIndType = "10"

		// Note, search the longer strings first
		if Pos(Upper(aspath), "NONCDC_PROMOCAMPAIGN_INV") > 0 then
			lsFileIndType = "13"
			lsOrderType = "R"
			ls_order_number_identifier = "INV"
		elseif Pos(Upper(aspath), "NONCDC_PROMOCAMPAIGN_SM") > 0 then
			lsFileIndType = "14"
			lsOrderType = "R"
			ls_order_number_identifier = "SM1"
		elseif Pos(Upper(aspath), "NONCDC_PROMOCAMPAIGN_BRU") > 0 then
			lsFileIndType = "15"
			lsOrderType = "R"
			ls_order_number_identifier = "BRU"
		elseif Pos(Upper(aspath), "CDC_PROMOCAMPAIGN_INV") > 0 then
			lsFileIndType = "10"
			ls_order_number_identifier = "INV"
		elseif Pos(Upper(aspath), "CDC_PROMOCAMPAIGN_SM") > 0 then
			lsFileIndType = "11"
			ls_order_number_identifier = "SM1"
		elseif Pos(Upper(aspath), "CDC_PROMOCAMPAIGN_BRU") > 0 then
			lsFileIndType = "12"
			ls_order_number_identifier = "BRU"
		end if

		lb_weekly_sort_tab = false
		lb_use_filename_identifier = true

	end if

	// LTK 20140606	Per Boon Hee, if file name contains "NONCDC_AUTOSHIP" then order type is "W"
	if Pos(Upper(aspath), "NONCDC_AUTOSHIP") > 0 then
		lsOrderType = "W"
	end if
			
	
//  lole_excel.WorkBooks.Open(aspath) 
//  lole_workbook = lole_excel.application.workbooks(1)

try

	// Password testing.  Durring testing, some XLS files were sent pw protected.  Boon Hee indicated that no pw protected files would be sent in production.  However, if they are it will stop the sweeper
	// and wait for the Excel password prompt to be entered (unless some OLE isPassWordProtected function is found and implemented in code).  If all stores use one passord, then when we call the open for the XLS file, we
	// can always send the default password.  Even is the files are not pw protected, it will still open the XLS files.  The following code can be used to open pw protected files ("test" is the pw that would
	// be replaced with the real password.  LTK 20140209
	// 
	//	String ls_null
	//	SetNull(ls_null)
	//	lole_excel.WorkBooks.Open(aspath, ls_null, ls_null, ls_null, "test")

	//	Turn off alerts/links before Open...
	lole_excel.Application.DisplayAlerts = false			// shut off any dialog alerts 
	lole_excel.Application.AskToUpdateLinks = false	// shut off request to update links 

	lole_excel.WorkBooks.Open(aspath)

//	lole_excel.Application.DisplayAlerts = false			// shut off any dialog alerts 
//	lole_excel.Application.AskToUpdateLinks = false	// shut off request to update links 

	lole_workbook = lole_excel.application.workbooks(1)
	
catch (Exception ex)
	
	if IsNull(ex.getMessage()) then
		lsLogOut = 'Exception opening Excel file: ' + aspath + asfile + "   Exception: " + String(ex)
	else
		lsLogOut = 'Exception opening Excel file: ' + aspath + asfile + "   Exception: " + ex.getMessage()
	end if
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
	if IsValid(lole_Excel) then 

		lole_excel.application.quit()
		lole_excel.DisconnectObject()
		destroy lole_Excel

	end if

	return -1

catch (RuntimeError rtex)
	
	if IsNull(rtex.getMessage()) then
		lsLogOut = 'Runtime error opening Excel file: ' + aspath + asfile + "   Exception: " + String(rtex)
	else
		lsLogOut = 'Runtime error opening Excel file: ' + aspath + asfile + "   Exception: " + rtex.getMessage()
	end if
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
	if IsValid(lole_Excel) then 

		lole_excel.application.quit()
		lole_excel.DisconnectObject()
		destroy lole_Excel

	end if

	return -1

finally
			 
end try


long ll_SSCount, ll_Idx
string ls_WorkSheet


//Defaults


lsUserField1 = "PLCDC"


//Attached are sample files for starbucks, and a not so updated Solution design but it does give you an idea of what the macro does.
// 
//In a nutshell:
//Files from starbucks are of diff types, each store may send all or some of the file types. Some file types are outbound only, some are both inbound and outbound. 
// 
//End-user chooses order date, then macro processes the excel files. There are 2 output from the macro - Inbound order csv, and Outbound order csv.
// 
//The input excel files does not provide the order numbers; macro has to generate order numbers.
// 
//Inbound order csv groups input excel by supplier code - same supplier, same order number. SKU and qty are grouped.
// 
//Outbound order csv groups input excel file by customer (store), and supplier. Same store still need to split into diff outbound order numbers depending on how many supplier. SKU and qty are grouped.
//

string ls_sku[], ls_current_sku

//•	There are 170 Starbucks Thailand stores in scope, each assigned a fixed 3 digit numeric code such as 005, 123, etc.
//•	Each store will need to provide 8 types of file namely Daily_Fresh_Food, NonCDC_Weekly_Frozen, Daily_Ambient, Weekly_Inv_SM_Bru, Weekly_NonCDC_Inv_SM_Bru , AutoShip_SM, AutoShip_Inv and AutoShip_Bru.
//•	The 8 file types will be classified as either daily (7 order dates in the worksheets) or weekly (only 1 order date in the file). Daily files include Daily_Fresh_Food, NonCDC_Weekly_Frozen and Daily_Ambient. NonCDC_Weekly_Frozen will be considered a daily file since there are 7 order dates in the worksheets. Weekly files include Weekly_Inv_SM_Bru Weekly_NonCDC_Inv_SM_Bru , AutoShip_SM, AutoShip_Inv and AutoShip_Bru.
//•	For all worksheets in all 5 file types, the SKU or item code are in column B, from B10 onwards. The store code will be in cell C5.

integer li_current_line, li_sku_idx

integer li_exec_col

string lsOrder

ll_SSCount = lole_workbook.Worksheets.Count 

lsLogOut = 'Excel File:' + asfile + " - Worksheet Count: " + string(ll_SSCount)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


FOR ll_Idx = 1 TO ll_SSCount 
	
	 lole_worksheet = lole_workbook.worksheets(ll_Idx)

	ls_WorkSheet = lole_WorkBook.Worksheets(ll_Idx).Name 

	// LTK 2013117  Promo spreadsheets have hidden sheets that do not contain inventory such as "Sheet1", etc.  Ensure all promo file sheet names contain "PROMO"
	if ls_FileType = "P" then
		if Pos(Upper(ls_WorkSheet),"PROMO") > 0 then
			// This promo sheet is expected and can be processed
		else
			continue
		end if
	end if

	// LTK 2013117  Autoship spreadsheets have hidden sheets that do not contain inventory such as "Sheet1", etc.  Ensure all autoship file sheet names contain "AUTOSHIP"
	if ls_FileType = "A" then
		if Pos(Upper(ls_WorkSheet),"AUTOSHIP") > 0 then
			// This autoship sheet is expected and can be processed
		else
			continue
		end if
	end if

	ls_store_code = string(lole_worksheet.cells(5,3).value) 
	
	if lsFileType = "DAILY" then
	
		For li_exec_col = 5 to 11
			
			li_current_line = 10
			
//			ll_line_no = 1
			
			//lsOrder = uf_generate_order_number()
	
			long ll_Qty
	
		
			Do 
				
				ls_current_sku =  string(lole_worksheet.cells(li_current_line,2).value)
				ls_current_sku =  Trim(ls_current_sku)
				ll_Qty =  long(lole_worksheet.cells(li_current_line,li_exec_col).value) 


				
				
//				lds_load_file.SetItem(li_sku_idx, "order_date", date(string(lole_worksheet.cells(8,li_exec_col).value)))
//				// The order date from the xls must be greater than tomorrow, otherwise this order will not be processed downstream
//				if DaysAfter(ldt_tomorrow, date(string(lole_worksheet.cells(8,li_exec_col).value))) > 0 then
//					// The xls order date is greater than tomorrow, order will be processed downstream
//					ldt_dates_to_be_processed[UpperBound(ldt_dates_to_be_processed) + 1] = String( date(string(lole_worksheet.cells(8,li_exec_col).value)) ,"yyyymmdd")
//				end if

				//lds_load_file.SetItem(li_sku_idx, "order_date", date(string(lole_worksheet.cells(8,li_exec_col).value)))
				// The order date from the xls must be greater than tomorrow, otherwise this order will not be processed downstream
				if DaysAfter(ldt_tomorrow, date(string(lole_worksheet.cells(8,li_exec_col).value))) > 0 then
					// The xls order date is greater than tomorrow, order will be processed downstream
					
					if Pos(ls_dates_to_process, String( date(string(lole_worksheet.cells(8,li_exec_col).value)) ,"yyyymmdd")) <= 0 then
						ls_dates_to_process += String( date(string(lole_worksheet.cells(8,li_exec_col).value)) ,"yyyymmdd")
						ldt_dates_to_be_processed[UpperBound(ldt_dates_to_be_processed) + 1] = String( date(string(lole_worksheet.cells(8,li_exec_col).value)) ,"yyyymmdd")
					end if
				end if




				
				If IsNull(ls_store_code) then ls_store_code = ""
		
				if IsNull(ll_Qty) then ll_Qty = 0
			
				If IsNull(ls_current_sku) then ls_current_sku = ''
				
				if trim(ls_current_sku) <> '' AND  ll_Qty > 0 then
				
					SELECT supp_code INTO :ls_supp_code
						FROM Item_Master 
						Where Project_ID = :asproject AND sku = :ls_current_sku;
					
					
					If IsNull(ls_supp_code) then ls_supp_code = ""
				    

					if lb_generate_outbound then  /*Generate Outbound*/		
							
						li_sku_idx = lds_load_file.InsertRow(0)
						
						lds_load_file.SetItem(li_sku_idx, "inbound_or_outbound", 'O') 

						lds_load_file.SetItem(li_sku_idx, "warehouse", 'STBTH')
						 // Set order type to Starbucks Marketing 'M' per Boon Hee's email, if... 
						 //
						 //			3.	Order types to be changed:
						//			a.	For files containing “Weekly_HVS_Daily_Inv_SM_Bru” for worksheet = “Weekly_Ambient_Bru”, order type = M.
						if (lsFileIndType = "9" ) and Pos(Upper(ls_WorkSheet), "WEEKLY_AMBIENT_BRU" ) > 0 then
							lsOrderType = 'M'
						end if
						lds_load_file.SetItem(li_sku_idx, "order_type", lsOrderType)
//						lds_load_file.SetItem(li_sku_idx, "order_number",  lsOrder)
						lds_load_file.SetItem(li_sku_idx, "sku", ls_current_sku)
						lds_load_file.SetItem(li_sku_idx, "supplier", ls_supp_code)						

//						lds_load_file.SetItem(li_sku_idx, "filename", asfile)
						lds_load_file.SetItem(li_sku_idx, "cust_order_number", "STB-"+ string(datetime(today(), now()), "yyyymmdd"))
						
						lds_load_file.SetItem(li_sku_idx, "cust_code", "STB" + ls_store_code)
						
						lds_load_file.SetItem(li_sku_idx, "user_field1", lsUserField1)
						
//						lds_load_file.SetItem(li_sku_idx, "line_number", ll_line_no)
						 //Get QTY
						//•	For daily files, order dates are in cells E8, F8, G8, H8, I8, J8, K8. The order qty are in columns E, F, G, H, I, J, K, from E10 onwards.
						lds_load_file.SetItem(li_sku_idx, "order_date", date(string(lole_worksheet.cells(8,li_exec_col).value)))
						lds_load_file.SetItem(li_sku_idx, "schedule_date", date(string(lole_worksheet.cells(8,li_exec_col).value)))
						lds_load_file.SetItem(li_sku_idx, "qty",  long(lole_worksheet.cells(li_current_line,li_exec_col).value))
						
//						// The order date from the xls must be greater than tomorrow, otherwise this order will not be processed downstream
//						if DaysAfter(ldt_tomorrow, lds_load_file.GetItemDate(li_sku_idx, "order_date")) > 0 then
//							// The xls order date is greater than tomorrow, order will be processed downstream
//							ldt_dates_to_be_processed[UpperBound(ldt_dates_to_be_processed) + 1] = String(lds_load_file.GetItemDate(li_sku_idx, "order_date"),"yyyymmdd")
//						end if
//
						lds_load_file.SetItem(li_sku_idx, "tab_name",  ls_WorkSheet)
						
					end if
					
					if lb_generate_inbound then  /*Generate Inbound */		
							
						li_sku_idx = lds_load_file.InsertRow(0)
						
						lds_load_file.SetItem(li_sku_idx, "inbound_or_outbound", 'I') 

						lds_load_file.SetItem(li_sku_idx, "warehouse", 'STBTH')
						//lds_load_file.SetItem(li_sku_idx, "order_type", "S")
						if lsOrderType = "C" then
							lds_load_file.SetItem(li_sku_idx, "order_type", "8")
						elseif lsOrderType = "F" then
							// LTK 20140123  Comment out line below, now Boon Hee wants "F" for IB NonCDC_Weekly_Frozen
							//lds_load_file.SetItem(li_sku_idx, "order_type", "E")	// LTK 20131028  Inbound order type of frozen = 'E'
							lds_load_file.SetItem(li_sku_idx, "order_type", lsOrderType)
						else
							lds_load_file.SetItem(li_sku_idx, "order_type", "S")
						end if

						lds_load_file.SetItem(li_sku_idx, "tab_name",  ls_WorkSheet)
											
//						lds_load_file.SetItem(li_sku_idx, "order_number",  lsOrder)
						lds_load_file.SetItem(li_sku_idx, "sku", ls_current_sku)
						lds_load_file.SetItem(li_sku_idx, "supplier", ls_supp_code)	
						
//						lds_load_file.SetItem(li_sku_idx, "filename", asfile)
						
//						lds_load_file.SetItem(li_sku_idx, "line_number", ll_line_no)
						
						lds_load_file.SetItem(li_sku_idx, "user_field1", lsUserField1)
						
						//STB + 3digit store code + hyphen + system date yyyymmdd
						
						lds_load_file.SetItem(li_sku_idx, "cust_order_number", "STB-"+ string(datetime(today(), now()), "yyyymmdd"))
						lds_load_file.SetItem(li_sku_idx, "cust_code", "STB" + ls_store_code)
						
						 //Get QTY
						//•	For daily files, order dates are in cells E8, F8, G8, H8, I8, J8, K8. The order qty are in columns E, F, G, H, I, J, K, from E10 onwards.
						lds_load_file.SetItem(li_sku_idx, "order_date", date(string(lole_worksheet.cells(8,li_exec_col).value)))
						lds_load_file.SetItem(li_sku_idx, "schedule_date", date(string(lole_worksheet.cells(8,li_exec_col).value)))
						lds_load_file.SetItem(li_sku_idx, "qty",  long(lole_worksheet.cells(li_current_line,li_exec_col).value))
						
					end if
					
					
					
					
					
					ll_line_no = ll_line_no + 1
					
					
				end if
			
				li_current_line = li_current_line + 1
			
			Loop Until trim(ls_current_sku) = '' 
		
		Next
		
	Else
		
			li_current_line = 10
			
//			ll_line_no = 1
			
//			lsOrder = uf_generate_order_number()
	
			Do 
	
				
				
				ls_current_sku =  string(lole_worksheet.cells(li_current_line,2).value)
				ls_current_sku = Trim(ls_current_sku)
				
				SELECT supp_code INTO :ls_supp_code
					FROM Item_Master 
					Where Project_ID = :asproject AND sku = :ls_current_sku;
			
					
				If IsNull(ls_supp_code) then ls_supp_code = ""
				
				
				ll_Qty =  long(lole_worksheet.cells(li_current_line,6).value)
		
				if IsNull(ll_Qty) then ll_Qty = 0
			
				If IsNull(ls_current_sku) then ls_current_sku = ''
				
				if trim(ls_current_sku) <> '' then // AND  ll_Qty > 0 then
							
					li_sku_idx = lds_load_file.InsertRow(0)
					
					
					lds_load_file.SetItem(li_sku_idx, "inbound_or_outbound", 'O')
					 

					  lds_load_file.SetItem(li_sku_idx, "warehouse", 'STBTH')
					 
					 // Set order type to Starbucks Marketing 'M' per Boon Hee's email, if... 
					 //
					//  			Outbound 
					//  			For these files, the order type should be M (Starbucks Marketing) for the “Weekly_Ambient_Bru” xls tab. The SIMS GI file will not contain orders with order type = M 
					//			since Starbucks does not want these orders in the file.
					//  			1.	Weekly_Inv_SM_Bru_Week
					//  			2.	Weekly_nonCDC_Inv_SM_Bru
					if (lsFileIndType = "4" or lsFileIndType = "5" or lsFileIndType = "9" ) and Pos(Upper(ls_WorkSheet), "WEEKLY_AMBIENT_BRU" ) > 0 then
						lsOrderType = 'M'
					end if
					 
					  lds_load_file.SetItem(li_sku_idx, "order_type", lsOrderType)
//					  lds_load_file.SetItem(li_sku_idx, "order_number",  lsOrder)
					  
					 lds_load_file.SetItem(li_sku_idx, "cust_code", "STB" + ls_store_code)
					 lds_load_file.SetItem(li_sku_idx, "cust_order_number", "STB-"+ string(datetime(today(), now()), "yyyymmdd"))
					 
					 lds_load_file.SetItem(li_sku_idx, "sku", ls_current_sku)
					 lds_load_file.SetItem(li_sku_idx, "supplier", ls_supp_code)					 
					 
//					 lds_load_file.SetItem(li_sku_idx, "filename", asfile)
//					 lds_load_file.SetItem(li_sku_idx, "line_number", ll_line_no)			
					 
					 
					 lds_load_file.SetItem(li_sku_idx, "user_field1", lsUserField1)					 
				 
					 //Get QTY
					 
						
						
					//	For weekly files, order dates are in cell F7. The order qty are in column F, from F10 onwards.
			
					lds_load_file.SetItem(li_sku_idx, "order_date", date(string(lole_worksheet.cells(7,6).value)))
					lds_load_file.SetItem(li_sku_idx, "schedule_date", date(string(lole_worksheet.cells(7,6).value)))
					lds_load_file.SetItem(li_sku_idx, "qty",  long(lole_worksheet.cells(li_current_line,6).value))

					// The order date from the xls must be greater than tomorrow, otherwise this order will not be processed downstream
					if DaysAfter(ldt_tomorrow, lds_load_file.GetItemDate(li_sku_idx, "order_date")) > 0 then
						// The xls order date is greater than tomorrow, order will be processed downstream
						ldt_dates_to_be_processed[UpperBound(ldt_dates_to_be_processed) + 1] = String(lds_load_file.GetItemDate(li_sku_idx, "order_date"),"yyyymmdd")
					end if

					lds_load_file.SetItem(li_sku_idx, "tab_name",  ls_WorkSheet)
							
					ll_line_no = ll_line_no + 1
					
					
				end if
			
				li_current_line = li_current_line + 1
			
			Loop Until trim(ls_current_sku) = '' 
	
	End If
	
Next

//End If /*Generate Outbound*/


//  lole_workbook.Close(false)
//
//  // Quit
//  lole_excel.application.quit()
//  lole_excel.DisconnectObject()
//
//  destroy lole_Excel

	try
		int li_disconnect_rc

		// Ensure Excel prompts still disabled before closing
		lole_excel.Application.DisplayAlerts = false			// shut off any dialog alerts 
		lole_excel.Application.AskToUpdateLinks = false	// shut off request to update links 

		lole_workbook.Close(false)

		// Quit
		lole_excel.application.quit()
		li_disconnect_rc = lole_excel.DisconnectObject()

		destroy lole_Excel
	
		lsLogOut = 'Excel Disconnect Return Val:' + string(li_disconnect_rc) + "     time=" + String(now())
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

	
	catch (Exception er)
		
		lsLogOut = 'Exception closing/quiting/disconnectiong from Excel OLE object for Excel file: ' + aspath + asfile + "   Exception: " + er.getMessage()
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

		if IsValid(lole_Excel) then destroy lole_Excel

		return -1

	finally
			 
	end try

  
end if


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//	The following code is necessary because currently, if a DO exists (in new status and other criteria met) for the incoming XLS file, the deletes are happening in the generic u_nvo_process_files.  
//	However, if the XLS file contains no data (meaning all of the previously sent inventory is being deleted) the file is not processed and the deletes do not happen in the generic NVO.
//
//	Select the DO's which are in new status (and other criteria).  Upon selecting, select the RO keys which will be used to select against RM.UF15.
//	Iterate the list above and delete this DO's contribution portion to quantity using Receive_Reconcile and Receive_Detail (i.e. update RD with the decremented qty found in Receive_Reconcile).
//	Delete from DM, the list of DO's found in the first step.


// DM.UF22 = lsFileIndType + lsCustomerCode + lsSupplier + ls_OrderDate + ls_tab_name_ident
//
// File type = lsFileIndType
// Customer code =  "STB" + ls_store_code
// Supplier ... will delete all suppliers
// Order Date ... generate that in the loop below
// Tab Name ... will delete all tabs
 

//	RO
//	lsFileIdent = lsFileIndType + lsSupplier + ls_OrderDate //lsCustomerCode


//	Delete all corresponding Delivery and Receive orders that could have been generated by receiving previous versions of this XLS file.

// Delete these DO's and un-reconcile the RO's
if UpperBound(ldt_dates_to_be_processed) > 0 then

	String ls_dm_uf22_key, ls_rm_uf15_key
	long i, ll_count
	Date ldt_work
	String ls_date
	
	String ls_find_str
	boolean lb_update_receive_detail
	int li_return, li_debug_rc
	long ll_rows, ll_unreconcile_rows, ll_ndx, ll_rr_ndx, ll_found_row
	datastore lds_receive_master, lds_receive_reconcile, lds_receive_detail

	lds_receive_master = f_datastoreFactory('d_starbucks_ro_by_uf15')
	lds_receive_detail = f_datastoreFactory('d_receive_detail_by_rono')
	lds_receive_reconcile = f_datastoreFactory('d_starbucks_receive_reconcile')			

	for i = 1 to UpperBound(ldt_dates_to_be_processed)

		ls_date = ldt_dates_to_be_processed[i]
		ldt_work = Date( Left(ls_date,4) + "/" + Mid(ls_date, 5, 2) + "/" + Right(ls_date, 2) )

		
		if DaysAfter(ldt_tomorrow, ldt_work ) > 0 then
			// Date is greater than tomorrow, this order can be processed (deleted)
			
			ls_dm_uf22_key = lsFileIndType + "STB" + ls_store_code + '%' + ldt_dates_to_be_processed[i] + '%'
			ls_rm_uf15_key = lsFileIndType + '%' + ldt_dates_to_be_processed[i]
	
	//		// If delivery or receive orders exist in a status other than NEW, then return error condition
	//		SELECT COUNT(*)
	//		INTO :ll_count
	//		FROM delivery_master
	//		WHERE project_id = :asproject
	//		AND user_field22 LIKE :ls_dm_uf22_key	
	//		AND ord_status <> 'N';
	//
	//		if sqlca.sqlcode = -1 then
	//			// TODO: log error message
	//			return -1
	//		end if
	//
	//		if ll_count > 0 then
	//			// TODO: log error message, DO found not in NEW status
	//			return -1
	//		end if
	//
	//		SELECT COUNT(*)
	//		INTO :ll_count
	//		FROM receive_master
	//		WHERE project_id = :asproject
	//		AND user_field15 LIKE :ls_rm_uf15_key	
	//		AND ord_status <> 'N';
	//		
	//		if sqlca.sqlcode = -1 then
	//			// TODO: log error message
	//			return -1
	//		end if
	//	
	//		if ll_count > 0 then
	//			// TODO: log error message, DO found not in NEW status
	//			return -1
	//		end if	
	

			if NOT lb_use_filename_identifier then

				DELETE FROM delivery_detail
				WHERE do_no in
					(SELECT do_no
					FROM delivery_master
					WHERE project_id = :asproject
					AND user_field22 LIKE :ls_dm_uf22_key
					AND ord_status = 'N'
					AND last_user IN ('SIMS3FP', 'SIMSFP'));
		
				if sqlca.sqlcode = 0 then
					commit;
				else
					lsLogOut = Space(17) + "- ***System Error!  Error deleting previous orders from Delivery_Detail!"
					FileWrite(gilogFileNo,lsLogOut)
					gu_nvo_process_files.uf_writeError("- ***System Error!  Error deleting previous orders from Delivery_Detail!")
					return -1
				end if
		
				DELETE FROM delivery_master
				WHERE project_id = :asproject
				AND user_field22 LIKE :ls_dm_uf22_key
				AND ord_status = 'N'
				AND last_user IN ('SIMS3FP', 'SIMSFP');
		
				if sqlca.sqlcode = 0 then
					commit;
				else
					lsLogOut = Space(17) + "- ***System Error!  Error deleting previous orders from Delivery_Master!"
					FileWrite(gilogFileNo,lsLogOut)
					gu_nvo_process_files.uf_writeError("- ***System Error!  Error deleting previous orders from Delivery_Master!")
					return -1
				end if
			
			else
				// This group of file types are identified by the DM.remark field being set to the filename.  Delete only once per loop.

				if NOT lb_is_deleted_once then
					lb_is_deleted_once = true
					
					DELETE FROM delivery_detail
					WHERE do_no in
						(SELECT do_no
						FROM delivery_master
						WHERE project_id = :asproject
						AND remark = :asfile
						AND ord_status = 'N'
						AND last_user IN ('SIMS3FP', 'SIMSFP'));
			
					if sqlca.sqlcode = 0 then
						commit;
					else
						lsLogOut = Space(17) + "- ***System Error!  Error deleting previous orders from Delivery_Detail!"
						FileWrite(gilogFileNo,lsLogOut)
						gu_nvo_process_files.uf_writeError("- ***System Error!  Error deleting previous orders from Delivery_Detail!")
						return -1
					end if
			
					DELETE FROM delivery_master
					WHERE project_id = :asproject
					AND remark = :asfile
					AND ord_status = 'N'
					AND last_user IN ('SIMS3FP', 'SIMSFP');
			
					if sqlca.sqlcode = 0 then
						commit;
					else
						lsLogOut = Space(17) + "- ***System Error!  Error deleting previous orders from Delivery_Master!"
						FileWrite(gilogFileNo,lsLogOut)
						gu_nvo_process_files.uf_writeError("- ***System Error!  Error deleting previous orders from Delivery_Master!")
						return -1
					end if
				end if
			end if
			
			
			// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			// Un-reconcile the previously reconciled Receive Orders
			// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			// 1. Retrieve a list of RO_NO's where using the file type code, a wild card for supplier and the order date.
			// 2. Retrieve an un-reconcile result set...a result set from Receive_Reconcile where the RO_NO is contained in the list from step 1 and the store code matches the XLS store code
			// 3. Decrement from RD, all rows from the un-reconcile result set
			// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
//			String ls_find_str
//			boolean lb_update_receive_detail
//			int li_return, li_debug_rc
//			long ll_rows, ll_unreconcile_rows, ll_ndx, ll_rr_ndx, ll_found_row
//			datastore lds_receive_master, lds_receive_reconcile, lds_receive_detail

//			lds_receive_master = f_datastoreFactory('d_starbucks_ro_by_uf15')
//			lds_receive_detail = f_datastoreFactory('d_receive_detail_by_rono')
//			lds_receive_reconcile = f_datastoreFactory('d_starbucks_receive_reconcile')			

			if NOT lb_use_filename_identifier then
				ll_rows = lds_receive_master.retrieve('STBTH', ls_rm_uf15_key)
	
				if ll_rows > 0 then
	
					for ll_ndx = 1 to ll_rows
	
						ll_unreconcile_rows = lds_receive_reconcile.retrieve(asproject, lds_receive_master.Object.ro_no[ll_ndx], ls_store_code)
						if lds_receive_detail.retrieve(lds_receive_master.Object.ro_no[ll_ndx]) > 0 then
	
	
							for ll_rr_ndx = 1 to ll_unreconcile_rows
		
	//							ls_find_str =	"ro_no = '" + lds_receive_reconcile.Object.ro_no[ll_rr_ndx] + "' and "  + &
	//												"line_item_no = " + String(lds_receive_reconcile.Object.line_item_no[ll_rr_ndx]) + " and "  + &
	//												"sku = '" + lds_receive_reconcile.Object.sku[ll_rr_ndx] + "' "
	
								ls_find_str =	"ro_no = '" + lds_receive_reconcile.Object.ro_no[ll_rr_ndx] + "' and "  + &
													"sku = '" + lds_receive_reconcile.Object.sku[ll_rr_ndx] + "' "
	
	
								ll_found_row = lds_receive_detail.find(ls_find_str, 1, lds_receive_detail.RowCount())
	
								if ll_found_row > 0 then
									ll_rd_qty = lds_receive_detail.Object.req_qty[ll_found_row]
									if IsNull(ll_rd_qty) then ll_rd_qty = 0
									ll_reconcile_qty = lds_receive_reconcile.Object.qty[ll_rr_ndx]
									if IsNull(ll_reconcile_qty) then ll_reconcile_qty = 0
									//lds_receive_detail.Object.req_qty[ll_found_row] = lds_receive_detail.Object.req_qty[ll_found_row] - lds_receive_reconcile.Object.qty[ll_rr_ndx]	// decrement reconciled amount from the RD row
									lds_receive_detail.Object.req_qty[ll_found_row] = ll_rd_qty - ll_reconcile_qty
									lds_receive_reconcile.Object.qty[ll_rr_ndx] = 0	// zero out the reconciled amount
									lb_update_receive_detail = true
								else
									lsLogOut = "RD row not found, should not happen!  RO_NO: " + String(lds_receive_reconcile.Object.ro_no[ll_rr_ndx]) + "  SKU: " + String(lds_receive_reconcile.Object.sku[ll_rr_ndx])
									FileWrite(giLogFileNo,lsLogOut)
									gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
								end if
		
							next
	
							if lb_update_receive_detail then
								li_return = lds_receive_detail.update()

								if li_return = 1 then
									commit;
								else
									rollback;
									
									lsLogOut = 'Error updating Receive_Detail during un-reconciliation for file: ' + asfile
									FileWrite(giLogFileNo,lsLogOut)
									gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
								end if
	
								for ll_rr_ndx = ll_unreconcile_rows to 1 step -1
									lds_receive_reconcile.deleteRow(ll_rr_ndx)
								Next
	
								li_return = lds_receive_reconcile.update()
															
								if li_return = 1 then
									commit;
								else
									rollback;
									
									lsLogOut = 'Error updating Receive_Reconcile during un-reconciliation for file: ' + asfile
									FileWrite(giLogFileNo,lsLogOut)
									gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
								end if
		
							end if		// Receive Detail updated
						end if		// RO_NO exists
					next		// Receive Loop
				end if		// Receive Rows exist
			end if		// NOT lb_use_filename_identifier...if this boolean is set, no corresponding receive orders have been created so bypass the logic
		end if		// date > tomorrow check
	next		// date to be processed array
end if

//	End deletion logic
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




//I think the key is going to be determining the rules for consolidating the Inbound and Outbound Orders. Since we won’t be getting order numbers from them, we will need to determine how we determine 
//when to insert a new or update an existing order. 
//For an Outbound order, it will have to be a combination of cust_code (store), Supplier,  Ord_status and one of the 3 dates (Order, Request or Schedule). 
//It looks like on the Outbound, we need one order per Store/Supplier so one customer file may create multiple outbound orders. 
//On the Inbound, multiple Store files may update a single Inbound Order based on the Supplier and Date.

//I think that we’ll end up with one function per file type. We’ll need to the file as an Excel document, parse specific fields for the store, dates, etc. and then loop through the rest of the rows for the line items. Some of the files just look like a shell of all the possible items and a lot of them don’t have quantities so we won’t want to create a line item if there is no qty.



//OutBound

lds_load_file.SetFilter("inbound_or_outbound='O'")
lds_load_file.Filter()

//lds_load_file.SetSort("inbound_or_outbound A,  order_date A, cust_code A, supplier A,  sku A")
lds_load_file.SetSort("inbound_or_outbound A,  tab_name A, order_date A, cust_code A, supplier A,  sku A")

lds_load_file.Sort()


//-	Outbound Orders
//o	What is your algorithm for creating the Outbound Order Number? CP> Rich to provide..
//Rich>> it is 10chars – YMDHmm999X. ICC only process max 10chars. We want to save on chars so…
//Y – right(yyyy) so for 2013 it is 3
//M - Mid("123456789ABC", Month(OrderDate), 1) – month of order date, didn’t want to use 2 char for 10(oct), 11(nov), dec(12)
//D - Mid("123456789ABCDEFGHIJKLMNOPQRSTUV", Day(OrderDate), 1) 
//H - Mid("0123456789ABCDEFGHIJKLMN", Hour(systemtime + 1, 1) – if systertant, just make sure no duplicates per run.
//X – N, A, F or U.. depends on input filename.. e.g. if filename has “Daily_Fresh_Food” or “Daily_Ambient” or “Weekly_Inv_SM_Bru” or “HVS_Daily_Inv_SM_Bru_Week” then “N”.. If “AutoShip” or “PromoCampaign” or “Urgent” then “A”.. and so on…
//o	Can an Outbound Order contain SKUm time is 1205am, then 0; if system time is 2344, then V
//mm – minute of system time. If 12:44, then 44
//999 – running seq per run.. not impos with different suppliers or do we need a order per Store/Supplier combination? CP> Rich..

date ld_Order_Date, ld_Last_Order_Date 
string ls_Cust_Code, ls_Last_Cust_Code, ls_Last_Supplier
String ls_last_tab
ll_line_no = 0 
il_X = 0

//String ls_uf15, ls_work_ro_no, ls_work_line_item_no, ls_work_sku, ls_find_str
//long ll_rr_rows, ll_rd_rows, i, ll_row_found
//dec ld_qty

//We group outbound order by store, by supplier.

string ls_Code_Id, ls_Code_Descript


if lds_load_file.RowCount() > 0 then 


	//Need to store the Order Number Seq Number across orders.

//	SELECT Code_Id,  Code_Descript
//		INTO  :ls_Code_Id, :ls_Code_Descript
//			FROM lookup_table
//			WHERE Project_Id = :asproject AND
//					   Code_Type = 'EXCELSEQNOOUT' USING SQLCA;
//						
//	If IsNull(ls_Code_Id) then ls_Code_Id = "0"
//	If IsNull(ls_Code_Descript) then ls_Code_Id = ""
//
	ls_Code_Id = "0"
	ls_Code_Id = ""

	lsOrder = ls_Code_Descript
	lsLastOrder = ls_Code_Descript
	ll_X = long(ls_Code_Id)	
	
//	lsLogOut = 'Seq No:' + ls_Code_Id  + " Last Order: " + ls_Code_Descript + " X: " + string(ll_X) + " Last Order Memory: " + lsLastOrder
//	FileWrite(giLogFileNo,lsLogOut)
//	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
						

	boolean lb_new_order_header_branch
	string lsExisitingOrder
	boolean lb_deletable
	String ls_dono
	DateTime ldt_order_date

	String ls_create_user, ls_ord_status, ls_ord_type
	DateTime ldt_ord_date

	String ls_ro_ord_status
	
	Date ldt_order_date_no_time
	
	long ll_upper_bound
		
	for ll_Idx = 1 to lds_load_file.RowCount()
		
		ld_Order_Date = lds_load_file.GetItemDate(ll_Idx, "order_date")
		ls_Cust_Code = lds_load_file.GetItemString(ll_Idx, "cust_code")
		lsSupplier = lds_load_file.GetItemString(ll_Idx, "supplier")
		ls_tab = lds_load_file.GetItemString(ll_Idx, "tab_name")
		
		

		// The order date from the xls must be greater than tomorrow, otherwise don't process the order
		if DaysAfter(ldt_tomorrow, ld_Order_Date) > 0 then
			// The xls order date is greater than tomorrow, order can be processed
		else
			// The xls order date <= tomorrow, order can *NOT* be processed
			lds_load_file.SetItem(ll_Idx, "change_id", "X")
			//continue
		end if
		
//		boolean lb_new_order_header_branch
		if lb_weekly_sort_tab then
			lb_new_order_header_branch = ld_Order_Date <> ld_Last_Order_Date OR ls_Cust_Code <> ls_Last_Cust_Code OR ls_Last_Supplier <> lsSupplier OR ls_tab <> ls_last_tab
		else 
			lb_new_order_header_branch = ld_Order_Date <> ld_Last_Order_Date OR ls_Cust_Code <> ls_Last_Cust_Code OR ls_Last_Supplier <> lsSupplier			
		end if

		//if ld_Order_Date <> ld_Last_Order_Date OR ls_Cust_Code <> ls_Last_Cust_Code OR ls_Last_Supplier <> lsSupplier then
		if lb_new_order_header_branch then
			
			//--
			
			 ll_line_no = 1
			
			//Delivery_Master - Check to see if this an update
	
			ls_OrderDate = string(lds_load_file.GetItemDate(ll_idx, "order_date"),"yyyymmdd")
			lsCustomerCode = lds_load_file.GetItemString(ll_idx, "cust_code")
			lsSupplier = lds_load_file.GetItemString(ll_idx, "Supplier")
			

			
			ls_tab_name_ident = ""
//			if lb_weekly_sort_tab then
//				if Upper(ls_tab) = 'WEEKLY_AMBIENT_INV' then
//					ls_tab_name_ident = 'A'
//				elseif Upper(ls_tab) = 'WEEKLY_AMBIENT_SM' then
//					ls_tab_name_ident = 'B'
//				elseif Upper(ls_tab) = 'WEEKLY_AMBIENT_BRU' then
//					ls_tab_name_ident = 'C'
//				end if
//			end if

			if lb_weekly_sort_tab then
				if Upper(ls_tab) = 'WEEKLY_AMBIENT_INV' then
					ls_tab_name_ident = 'A'
				elseif Upper(ls_tab) = 'WEEKLY_AMBIENT_SM' then
					ls_tab_name_ident = 'B'
				elseif Upper(ls_tab) = 'WEEKLY_AMBIENT_BRU' then
					ls_tab_name_ident = 'C'
				
				// Daily File
				elseif Pos(Upper(ls_tab), 'DAILY_FRESH') > 0 then
					ls_tab_name_ident = 'A'
				elseif Pos(Upper(ls_tab), 'DAILY_XD_MARRIOTT') > 0 then
					ls_tab_name_ident = 'B'
				elseif Pos(Upper(ls_tab), 'DAILY_XD_ROY') > 0 then
					ls_tab_name_ident = 'C'					
				elseif Pos(Upper(ls_tab), 'DAILY_XD_COFFEE BEANS') > 0 then
					ls_tab_name_ident = 'D'
				elseif Pos(Upper(ls_tab), 'DAILY_XD_S&P') > 0 then
					ls_tab_name_ident = 'E'
				elseif Pos(Upper(ls_tab), 'DAILY_CHAMP BOOM BELLE') > 0 then
					ls_tab_name_ident = 'F'
				elseif Pos(Upper(ls_tab), 'DAILY_XD_PERFETTO FOODS') > 0 then					
					ls_tab_name_ident = 'G'
				end if
			end if


			//lsFileIdent = lsFileIndType + lsCustomerCode + lsSupplier + ls_OrderDate
			lsFileIdent = lsFileIndType + lsCustomerCode + lsSupplier + ls_OrderDate + ls_tab_name_ident
			
			
	//		cust_code (store), Supplier,  Ord_status and one of the 3 dates (Order, Request or Schedule)
	
//			string lsExisitingOrder
//			boolean lb_deletable
//			//select count(*), max(invoice_no) INTO :li_count, :lsExisitingOrder from delivery_master where project_id =  :asproject and user_field22 = :lsFileIdent group by do_no order by do_no desc ;
//			String ls_dono
//			DateTime ldt_order_date
			li_count = 0
			select count(*), max(invoice_no), max(do_no) INTO :li_count, :lsExisitingOrder, :ls_dono from delivery_master where project_id =  :asproject and user_field22 = :lsFileIdent group by do_no order by do_no desc ;

			if li_count > 0 then
		
				lb_deletable = true
		
				//lds_load_file.SetItem(ll_idx, "change_id", "U")
				
				//lsChangeID = "U" 
				lsChangeID = "R" 		// LTK 20131004  We are now replacing orders
				
				//lsOrder = lsExisitingOrder

//				String ls_create_user, ls_ord_status, ls_ord_type
//				DateTime ldt_ord_date
				
				select create_user, ord_status, ord_date, ord_type
				into :ls_create_user, :ls_ord_status, :ldt_ord_date, :ls_ord_type
				from delivery_master
				where do_no = :ls_dono;

				if Upper(ls_create_user) <> 'SIMS3FP' and Upper(ls_create_user) <> 'SIMSFP' then
					lb_deletable = false
				end if

				if lb_deletable and Upper(ls_ord_status) <> 'N' then
					lb_deletable = false
				end if
				
				if lb_deletable and Upper(ls_ord_status) = 'N' and Upper(ls_ord_type) = 'Z' then					
//					String ls_ro_ord_status

					select ord_status
					into :ls_ro_ord_status
					from receive_master
					where project_id = :asproject
					and do_no = :ls_dono;

					if sqlca.sqlcode = 0 then
						if ls_ro_ord_status <> 'N' then
							lb_deletable = false
						end if
					end if
				end if

				if lb_deletable then
					//  If the order_date is <= today+1day do not delete/add
					//Date ldt_order_date_no_time
					ldt_order_date_no_time = Date(ldt_ord_date)
					if DaysAfter(ldt_tomorrow, ldt_order_date_no_time) > 0 then
						// Date is greater than tomorrow, this order can be processed
					else
						// Date <= tomorrow, this order cannot be processed
						lb_deletable = false
					end if
				end if
				
				if NOT lb_deletable then
					lsChangeID = 'X'			// Don't allow this record to be deleted/re-added
					
					// This DO will not be processed.  Insert it's key into an array so that the subsequent RO will not be processed downstream
					//long ll_upper_bound
					ll_upper_bound = UpperBound(la_do_xkeys)
					la_do_xkeys[ ll_upper_bound + 1 ] =  lsFileIndType + lsSupplier + ls_OrderDate
					
				end if

			else
				
				 //lds_load_file.SetItem(ll_idx, "change_id", "A")
				 
				 lsChangeID = "A"
		
			end if
		
			//Order Number
			
			//-	Outbound Orders
			//o	What is your algorithm for creating the Outbound Order Number? CP> Rich to provide..
			//Rich>> it is 10chars – YMDHmm999X. ICC only process max 10chars. We want to save on chars so…
			//Y – right(yyyy) so for 2013 it is 3
			//M - Mid("123456789ABC", Month(OrderDate), 1) – month of order date, didn’t want to use 2 char for 10(oct), 11(nov), dec(12)
			//D - Mid("123456789ABCDEFGHIJKLMNOPQRSTUV", Day(OrderDate), 1) 
			//H - Mid("0123456789ABCDEFGHIJKLMN", Hour(systemtime + 1, 1) – if systertant, just make sure no duplicates per run.
			//X – N, A, F or U.. depends on input filename.. e.g. if filename has “Daily_Fresh_Food” or “Daily_Ambient” or “Weekly_Inv_SM_Bru” or “HVS_Daily_Inv_SM_Bru_Week” then “N”.. If “AutoShip” or “PromoCampaign” or “Urgent” then “A”.. and so on…
			//o	Can an Outbound Order contain SKUm time is 1205am, then 0; if system time is 2344, then V
			//mm – minute of system time. If 12:44, then 44
			//999 – running seq per run.. not impos with different suppliers or do we need a order per Store/Supplier combination? CP> Rich..
			
			ldt_OrderDate = datetime(today(), now())
			
			//ls_Y = right(string(ldt_OrderDate, "YYYY"), 1)		// LTK 20131023  Change order date to read it from xls
			ls_Y = right(string(ld_Order_Date, "YYYY"), 1)		
			
			//ls_M = Mid("123456789ABC", Month(date(ldt_OrderDate)), 1)	// LTK 20131023  Change order date to read it from xls
			ls_M = Mid("123456789ABC", Month(ld_Order_Date), 1)
			
			//ls_D = Mid("123456789ABCDEFGHIJKLMNOPQRSTUV", Day(Date(ldt_OrderDate)), 1) 	// LTK 20131023  Change order date to read it from xls
			ls_D = Mid("123456789ABCDEFGHIJKLMNOPQRSTUV", Day(ld_Order_Date), 1) 
			
			ls_H = Mid("0123456789ABCDEFGHIJKLMN", Hour(Time(ldt_OrderDate)), 1)
			
			
			//YMDHmm999X	
			
			if  left(lsOrder,6) = left(lsLastOrder,6) then
				
				ll_X = ll_X + 1
										
			else
				
				ll_X = 1
					
			end if

			if ll_X = 1000 then
				ll_X = 1			// sequences must be 3 digits for Outbound
			end if

//			lsOrder = ls_Y + ls_M + ls_D + ls_H + string(ldt_OrderDate, "mm") + string(ll_X, "000") + ls_FileType	 
				
// LTK 20131021	New delivery order number algorithm from Boon Hee...
//
//	Character	Description	Example
//1	Year of order date (last number)	3 for 2013, 4 for 2014… A for 2020, B for 2021…
//2	Month of order date (last number)	1 for Jan, 2 for Feb… A for Oct, B for Nov, C for Dec
//3	Day of order date (last number)	Refer to alphanumeric code on column E and F
//4	3-digit store code	All stores will have 3-digit store code
//5		
//6		
//7	3-digit running number for each file	001, 002, 003 …
//8		
//9		
//10	Delivery Order Type	Refer to screenshot on Delivery Order type list
//
//

			ls_work_store = ls_store_code
			if Len(ls_work_store) > 3 then
				ls_work_store = Left(ls_work_store, 3)
			end if

//			lsOrder = ls_Y + ls_M + ls_D + ls_work_store + string(ll_X, "000") + lsOrderType

//			// LTK 20140729  New file name identifier scheme caused duplicate order numbers for this group.  Add file indicator type and tab name to make unique...
//			if lb_use_filename_identifier then
//				lsOrder =  lsOrder + lsFileIndType + ls_tab_name_ident
//			end if

			// LTK 20140804  New file naming convention only for Autoship and Promo file names
			//lsOrder = ls_Y + ls_M + ls_D + ls_work_store + string(ll_X, "000") + lsOrderType
			lsOrder = ls_Y + ls_M + ls_D + ls_work_store

			if Len(ls_order_number_identifier) > 0 then
				lsOrder += ls_order_number_identifier + lsOrderType
			else
				lsOrder += string(ll_X, "000") + lsOrderType
			end if			
				
				
			//end if
			
			//--
			
			ld_Last_Order_Date = ld_Order_Date
			ls_Last_Cust_Code = ls_Cust_Code
			ls_Last_Supplier = lsSupplier 
			ls_last_tab = ls_tab
			
			lsLastOrder = lsOrder
			
		else
			
			 ll_line_no = ll_line_no + 1
			
			 
			
		end if
	
		ll_Qty =	lds_load_file.GetItemNumber(ll_idx, "qty")
		
		//if lsChangeID = "U" and ll_Qty = 0 then
		if lsChangeID = "R" and (ll_Qty = 0 or IsNull(ll_Qty)) then		// LTK 20131004  Order replacement logic
			//lds_load_file.SetItem(ll_idx, "change_id", "D")
		else
			lds_load_file.SetItem(ll_idx, "change_id", lsChangeID)
		end if	
		
		
		
		lds_load_file.SetItem(ll_idx, "line_number", ll_line_no)		
		lds_load_file.SetItem(ll_idx, "order_number",  lsOrder)
		
		lds_load_file.SetItem(ll_idx, "filename",  lsFileIdent)
		
	next 
	
		//Carry the Seq Cross Orders.
		
		ls_Code_Id = string(ll_X)
		ls_Code_Descript = lsOrder
		
		UPDATE lookup_table 
			SET Code_Id = :ls_Code_Id, Code_Descript = :ls_Code_Descript
			WHERE Project_Id = :asproject AND
					   Code_Type = 'EXCELSEQNOOUT' USING SQLCA;
						
		COMMIT;



	//Remove any 0 columns for Adds. Need to keep for Updates since they might be 0 out rows.
	
//	lds_load_file.SetFilter("inbound_or_outbound='O' AND (IsNull(Qty) OR Qty = 0) AND (change_id = 'A' or change_id = 'R') ")
	lds_load_file.SetFilter("inbound_or_outbound='O' AND (IsNull(Qty) OR Qty = 0) ")
	lds_load_file.Filter()

	for ll_Idx = lds_load_file.RowCount() to 1 step -1 
		lds_load_file.DeleteRow(ll_Idx)
	next
	
	lds_load_file.SetFilter("inbound_or_outbound='O'")
	lds_load_file.Filter()

//	lds_load_file.SetSort("inbound_or_outbound A,  order_date A, cust_code A, supplier A,  sku A")
	if lb_weekly_sort_tab then
		lds_load_file.SetSort("inbound_or_outbound A,  tab_name A, order_date A, cust_code A, supplier A,  sku A")
	else
		lds_load_file.SetSort("inbound_or_outbound A,  order_date A, cust_code A, supplier A,  sku A")
	end if
	lds_load_file.Sort()
	
	
	////Insert
	
	
	integer llFilerowCount
	long llbatchseq
	
	u_ds_datastore 	ldsSOheader,	&
	ldsSOdetail				
	
	
	ldsSOheader = Create u_ds_datastore
	ldsSOheader.dataobject= 'd_baseline_unicode_shp_header'
	ldsSOheader.SetTransObject(SQLCA)
	
	ldsSOdetail = Create u_ds_datastore
	ldsSOdetail.dataobject= 'd_baseline_unicode_shp_detail'
	ldsSOdetail.SetTransObject(SQLCA)
	
	
	llFilerowCount = lds_load_file.RowCount()
	
	//Get the next available file sequence number
	
	llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
	If llBatchSeq <= 0 Then Return -1
	
	
	lsLastOrder = ""
	
	string lsWarehouse, ls_DeliveryDate, ls_GI_Date
	integer liNewRow
	long llOutboundOrderSeq, llOutboundLineSeq, llInboundOrderSeq, llInboundLineSeq

	String ls_Cust_Name, ls_Address_1, ls_Address_2, ls_Address_3, ls_Address_4
	String ls_City, ls_State, ls_Zip, ls_Country, ls_Tel, ls_Contact_Person

	string lsSku, ls_InventoryType
	boolean lbDetailError
	long llNewDetailRow

	for ll_Idx = 1 to llFilerowCount

		if DaysAfter(ldt_tomorrow, lds_load_file.GetItemDate(ll_idx, "order_date")) > 0 then
			// Date is greater than tomorrow, this order can be processed
		else
			// Date <= tomorrow, this order cannot be processed
			continue
		end if

		lsOrder = lds_load_file.GetItemString(ll_idx, "order_number")
		lsCustomerCode = lds_load_file.GetItemString(ll_idx, "cust_code")
	
		if lsLastOrder <> lsOrder then
			
								
//			string lsWarehouse, ls_DeliveryDate, ls_GI_Date
//			integer liNewRow
//			long llOutboundOrderSeq, llOutboundLineSeq, llInboundOrderSeq, llInboundLineSeq
			
			lsChangeID = lds_load_file.GetItemString(ll_idx, "change_id")
			if Upper(lsChangeID) = 'X' then continue								// LTK 20131008  Do not process action codes of X
			
			lsWarehouse = lds_load_file.GetItemString(ll_idx, "warehouse")
			ls_OrderDate = string(lds_load_file.GetItemDate(ll_idx, "order_date"))			
			ls_DeliveryDate = string(lds_load_file.GetItemDate(ll_idx, "order_date"))	
			ls_GI_Date = string(lds_load_file.GetItemDate(ll_idx, "order_date"))			
			lsCustomerCode = lds_load_file.GetItemString(ll_idx, "cust_code")
			ls_Cust_Order_Number = lds_load_file.GetItemString(ll_idx, "cust_order_number")
			lsOrderType = lds_load_file.GetItemString(ll_idx, "order_type")
			lsUserField1 = lds_load_file.GetItemString(ll_idx, "user_field1")	
			ll_Qty =	lds_load_file.GetItemNumber(ll_idx, "qty")
			
			lsFileIdent =  lds_load_file.GetItemString(ll_idx, "filename")
			
			lsLastOrder = lsOrder	
			
			
			liNewRow = 	ldsSOheader.InsertRow(0)
			llOutboundOrderSeq ++
			llOutBoundLineSeq = 0			
			
			//New Record Defaults
			ldsSOheader.SetItem(liNewRow,'project_id',asproject)
			ldsSOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
			//ldsSOheader.SetItem(liNewRow,'Request_date',String(Today(),'YYMMDD'))
			ldsSOheader.SetItem(liNewRow,'request_date',String(Today()))			// LTK 20131004  Default to timestamp
			ldsSOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsSOheader.SetItem(liNewRow,'order_seq_no',llOutboundOrderSeq) 
			ldsSOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsSOheader.SetItem(liNewRow,'status_cd','N')
			ldsSOheader.SetItem(liNewRow,'Last_user','SIMSEDI')
	
			ldsSOheader.SetItem(liNewRow,'invoice_no',lsOrder)		
			
			ldsSOheader.SetItem(liNewRow,'order_no', ls_Cust_Order_Number)	
	
	//		ldsSOheader.SetItem(liNewRow,'Inventory_Type','N') /*default to Normal*/
	
			ldsSOheader.SetItem(liNewRow,'cust_code',lsCustomerCode) /*Order Type*/
	
	
			ldsSOheader.SetItem(liNewRow,'action_cd',lsChangeID) /*Supplier Order*/	
	
			ldsSOheader.SetItem(liNewRow,'Order_type', lsOrderType )
	
			ldsSOheader.SetItem(liNewRow,'user_field22', lsFileIdent)
	
			if lb_use_filename_identifier then
				ldsSOheader.SetItem(liNewRow,'remark', asfile)
			end if
	
	//			1.	Map Delivery Date on DM to “Delivery Date” in SIMS
	//			2.	Map GI Date on DM to “Schedule Date” in SIMS
	//			
			
			ldsSOheader.SetItem(liNewRow,'ord_date',ls_OrderDate)
			ldsSOheader.SetItem(liNewRow,'delivery_date',ls_DeliveryDate)
			ldsSOheader.SetItem(liNewRow,'schedule_date',ls_GI_Date)
			
			ldsSOheader.SetItem(liNewRow,'user_field1', lsUserField1)
	
	//		ldsSOheader.SetItem(liNewRow,'user_field22', lsFileIdent)		 //Tell if this is an update
	
//			String ls_Cust_Name, ls_Address_1, ls_Address_2, ls_Address_3, ls_Address_4
//			String ls_City, ls_State, ls_Zip, ls_Country, ls_Tel, ls_Contact_Person
			
			
			
			select cust_name, address_1, address_2, address_3, address_4, 
					city, state, zip, country, tel, contact_person
			into :ls_Cust_Name, :ls_Address_1, :ls_Address_2, :ls_Address_3, :ls_Address_4,
				 :ls_City, :ls_State, :ls_Zip, :ls_Country, :ls_Tel, :ls_Contact_Person
			from customer
			where project_id = :asproject and cust_code = :lsCustomerCode;
	
			ldsSOheader.SetItem(liNewRow,'cust_name', ls_Cust_Name)
			ldsSOheader.SetItem(liNewRow,'address_1', ls_Address_1)
			ldsSOheader.SetItem(liNewRow,'address_2', ls_Address_2)
			ldsSOheader.SetItem(liNewRow,'address_3', ls_Address_3)
			ldsSOheader.SetItem(liNewRow,'address_4', ls_Address_4)
			ldsSOheader.SetItem(liNewRow,'city', ls_City)
			ldsSOheader.SetItem(liNewRow,'state', ls_State)
			ldsSOheader.SetItem(liNewRow,'zip', ls_Zip)
			ldsSOheader.SetItem(liNewRow,'country', ls_Country)
			ldsSOheader.SetItem(liNewRow,'tel', ls_Tel)
			ldsSOheader.SetItem(liNewRow,'Contact_Person', ls_Contact_Person)
				
	
	
			ll_line_no = 0
	
		end if	
			
		// DETAIL RECORD
									
	
//		string lsSku, ls_InventoryType
//		boolean lbDetailError
//		long llNewDetailRow
	
		lsSupplier = lds_load_file.GetItemString(ll_idx, "Supplier")
		//ll_line_no = lds_load_file.GetItemNumber(ll_idx, "line_number")
		ll_line_no ++
		lsSku = lds_load_file.GetItemString(ll_idx, "sku")
		ll_Qty =	lds_load_file.GetItemNumber(ll_idx, "qty")
		ls_InventoryType = "N"
	
		If IsNull(ll_Qty) OR String(ll_Qty) = '' THEN ll_Qty = 0
	
		//On Adds, don't do anything with the 0 Qty Rows
		if lsChangeID = "A" and ll_Qty = 0 then Continue	
		if IsNull(lsOrder) or llOutboundOrderSeq = 0 then continue
		
		lbDetailError = False
		llNewDetailRow = 	ldsSODetail.InsertRow(0)
		llOutboundLineSeq ++
				
		//Add detail level defaults
		ldsSODetail.SetItem(llNewDetailRow,'order_seq_no',llOutboundOrderSeq) 
		ldsSODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
		ldsSODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
		ldsSODetail.SetItem(llNewDetailRow,'Inventory_Type', ls_InventoryType) 
		ldsSODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
		ldsSODetail.SetItem(llNewDetailRow,"order_line_no",string(llOutboundLineSeq))
		
		ldsSODetail.SetItem(llNewDetailRow,'invoice_no',lsOrder)			
	//	ldsSODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID)
	
		ldsSODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
		ldsSODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
		ldsSODetail.SetItem(llNewDetailRow,'Line_Item_No',ll_line_no) /*Line_Item_No*/	
		ldsSODetail.SetItem(llNewDetailRow,'Quantity', String(ll_Qty)) /*Quantity*/				
	
		ldsSODetail.SetItem(llNewDetailRow,'user_field1', uf_convert_tab_name_to_code(lds_load_file.GetItemString(ll_idx, "tab_name"))) 	// LTK 20131004  Populate with tab name code 
		
	Next
	
	long lirc
	
	//Save the Changes 
	SQLCA.DBParm = "disablebind =0"
	lirc = ldsSOheader.Update()
	SQLCA.DBParm = "disablebind =1"
	
		
	If liRC = 1 Then
		SQLCA.DBParm = "disablebind =0"
		liRC = ldsSOdetail.Update()
		SQLCA.DBParm = "disablebind =1"
		
	ELSE
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Header Records to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
		Return -1
	End If
	
	Commit;
	
	
	//End IF
	//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter	
	int li_rc
	li_rc = gu_nvo_process_files.uf_process_Delivery_order( asProject )

	lsLogOut = Space(17) + "- Return of gu_nvo_process_files.uf_process_Delivery_order() =" + String(li_rc) + "     time=" + String(now())
	FileWrite(gilogFileNo,lsLogOut)
	

end if

//----

//InBound


lds_load_file.SetFilter("inbound_or_outbound='I'")
lds_load_file.Filter()

//lds_load_file.SetSort("inbound_or_outbound A,  order_date A, supplier A, sku A ")
if lb_weekly_sort_tab then
	lds_load_file.SetSort("inbound_or_outbound A,  tab_name A, order_date A, supplier A, sku A ")
else
	lds_load_file.SetSort("inbound_or_outbound A,  order_date A, supplier A, sku A ")
end if
lds_load_file.Sort()


//we group inbound order by supplier. 

///---

//Receive_Master - Check to see if this an update

if lds_load_file.RowCount() > 0 then 

	ll_line_no = 0 
	il_X = 0
	SetNull(ld_Last_Order_Date) 
	ls_Last_Supplier = ""
	lsLastOrder = ""
	
	//Need to store the Order Number Seq Number across orders.

//	SELECT Code_Id,  Code_Descript
//		INTO  :ls_Code_Id, :ls_Code_Descript
//			FROM lookup_table
//			WHERE Project_Id = :asproject AND
//					   Code_Type = 'EXCELSEQNOIN' USING SQLCA;
//						
//	If IsNull(ls_Code_Id) then ls_Code_Id = "0"
//	If IsNull(ls_Code_Descript) then ls_Code_Id = ""
	ls_Code_Id = "0"
	ls_Code_Id = ""

	lsOrder = ls_Code_Descript
	lsLastOrder = ls_Code_Descript
	ll_X = long(ls_Code_Id)	
	
	
	//We group outbound order by store, by supplier.
	
	for ll_Idx = 1 to lds_load_file.RowCount()
		
		ld_Order_Date = lds_load_file.GetItemDate(ll_Idx, "order_date")
	//	ls_Cust_Code = lds_load_file.GetItemString(ll_Idx, "cust_code")
		lsSupplier = lds_load_file.GetItemString(ll_Idx, "supplier")
		
		// OR ls_Cust_Code <> ls_Last_Cust_Code
		
		if ld_Order_Date <> ld_Last_Order_Date OR ls_Last_Supplier <> lsSupplier then
			
			
			//--
			
			 ll_line_no = 1
			
			//Delivery_Master - Check to see if this an update
	
			ls_OrderDate = string(lds_load_file.GetItemDate(ll_idx, "order_date"),"yyyymmdd")
			lsCustomerCode = lds_load_file.GetItemString(ll_idx, "cust_code")
			lsSupplier = lds_load_file.GetItemString(ll_idx, "Supplier")
			
			lsFileIdent = lsFileIndType + lsSupplier + ls_OrderDate //lsCustomerCode
			
	//		cust_code (store), Supplier,  Ord_status and one of the 3 dates (Order, Request or Schedule)
	
	
//			li_count = 0
//			lsExisitingOrder = ""
//			select count(*), max(supp_invoice_no) INTO :li_count, :lsExisitingOrder from receive_master where project_id =  :asproject and User_Field15 = :lsFileIdent group by ro_no order by ro_no desc ;

			ls_ord_status = ""
			li_count = 0
			lsExisitingOrder = ""
			select count(*), max(supp_invoice_no), max(ord_status) 
			INTO :li_count, :lsExisitingOrder, :ls_ord_status
			from receive_master 
			where project_id =  :asproject 
			and User_Field15 = :lsFileIdent 
			group by ro_no 
			order by ro_no desc;
			
//			if li_count > 0 then
//	
//		
//	//			lds_load_file.SetItem(ll_idx, "change_id", "U")
//				
//				//lsChangeID = "U"
//				lsChangeID = "R"		// LTK 20131004  Order replacement logic
//				
//				lsOrder = lsExisitingOrder
//				
//				
//			else
//				
//	//			 lds_load_file.SetItem(ll_idx, "change_id", "A")
//				 
//				 lsChangeID = "A"
//				 
//			
//				//Inbound
//					
//				ldt_OrderDate = datetime(today(), now())
//				
//				ls_Y = right(string(ldt_OrderDate, "YYYY"), 1)
//				
//				ls_M = Mid("123456789ABC", Month(date(ldt_OrderDate)), 1)
//				
//				ls_D = Mid("123456789ABCDEFGHIJKLMNOPQRSTUV", Day(Date(ldt_OrderDate)), 1) 
//				
//				ls_H = Mid("0123456789ABCDEFGHIJKLMN", Hour(Time(ldt_OrderDate)), 1)
//				
//				
//				//YMDHmmssZZ
//				
//				if  left(lsOrder,6) = left(lsLastOrder,6) then
//					ll_X = ll_X + 1
//				else
//					ll_X = 1
//				end if
//				
//				//YMDHmmssZZ
//				
//				lsOrder = ls_Y + ls_M + ls_D + ls_H + string(ldt_OrderDate, "mmss") + string(ll_X, "00") 
//				
//			end if
//
			
//			if li_count > 0 then
//		
//	//			lds_load_file.SetItem(ll_idx, "change_id", "U")
//				
//				//lsChangeID = "U"
//				lsChangeID = "R"		// LTK 20131004  Order replacement logic
//				
//				//lsOrder = lsExisitingOrder
//
//			else
//				
//	//			 lds_load_file.SetItem(ll_idx, "change_id", "A")
//				 
//				 lsChangeID = "A"
//				 
//			end if
//			
			
			if li_count = 1 then
				lsChangeID = "R"
			elseif li_count = 0 then
				 lsChangeID = "A"
			elseif li_count > 1 then
				lsChangeID = "X"
			end if


			//Inbound
				
			ldt_OrderDate = datetime(today(), now())
			
			ls_Y = right(string(ldt_OrderDate, "YYYY"), 1)
			
			ls_M = Mid("123456789ABC", Month(date(ldt_OrderDate)), 1)
			
			ls_D = Mid("123456789ABCDEFGHIJKLMNOPQRSTUV", Day(Date(ldt_OrderDate)), 1) 
			
			ls_H = Mid("0123456789ABCDEFGHIJKLMN", Hour(Time(ldt_OrderDate)), 1)
			
			
			//YMDHmmssZZ
			
			if  left(lsOrder,6) = left(lsLastOrder,6) then
				ll_X = ll_X + 1
			else
				ll_X = 1
			end if
			
			if ll_X = 100 then
				ll_X = 1			// Sequence must be 2 digits for inbound orders
			end if

			//YMDHmmssZZ
			
			lsOrder = ls_Y + ls_M + ls_D + ls_H + string(ldt_OrderDate, "mmss") + string(ll_X, "00") 
			




			
			//--
			
			ld_Last_Order_Date = ld_Order_Date
			ls_Last_Cust_Code = ls_Cust_Code
			ls_Last_Supplier = lsSupplier 
			
			lsLastOrder = lsOrder
			
		else
			
			 ll_line_no = ll_line_no + 1
			
			 
			
		end if
		
		ll_Qty =	lds_load_file.GetItemNumber(ll_idx, "qty")
		
		//if lsChangeID = "U" and ll_Qty = 0 then
		if lsChangeID = "R" and ll_Qty = 0 then		// LTK 20131004  Order replacement logic
			//lds_load_file.SetItem(ll_idx, "change_id", "D"
		else
			lds_load_file.SetItem(ll_idx, "change_id", lsChangeID)
		end if
		
		lds_load_file.SetItem(ll_idx, "line_number", ll_line_no)		
		lds_load_file.SetItem(ll_idx, "order_number",  lsOrder)
		
		lds_load_file.SetItem(ll_idx, "filename",  lsFileIdent)
		
	
	next 
	
	
	//Carry the Seq Cross Orders.
	
	ls_Code_Id = string(ll_X)
	ls_Code_Descript = lsOrder
	
	UPDATE lookup_table 
		SET Code_Id = :ls_Code_Id, Code_Descript = :ls_Code_Descript
		WHERE Project_Id = :asproject AND
					Code_Type = 'EXCELSEQNOIN' USING SQLCA;
					
	COMMIT;
	

	//Remove any 0 columns for Adds. Need to keep for Updates since they might be 0 out rows.
	
	lds_load_file.SetFilter("inbound_or_outbound='I' AND (IsNull(Qty) OR Qty = 0) AND change_id = 'A' ")
	lds_load_file.Filter()

	for ll_Idx = lds_load_file.RowCount() to 1 step -1 
		lds_load_file.DeleteRow(ll_Idx)
	next
	
	//lds_load_file.SetFilter("inbound_or_outbound='I'")
	lds_load_file.SetFilter("inbound_or_outbound='I' AND change_id = 'A'")
	lds_load_file.Filter()

	lds_load_file.SetSort("inbound_or_outbound A,  order_date A, supplier A, sku A, ")
	lds_load_file.Sort()
	
	
	//Insert
	
	
	u_ds_datastore	ldsPOHeader,	&
						  ldsPODetail
					
	
	ldsPOheader = Create u_ds_datastore
	ldsPOheader.dataobject= 'd_baseline_unicode_po_header'
	ldsPOheader.SetTransObject(SQLCA)
	
	ldsPOdetail = Create u_ds_datastore
	ldsPOdetail.dataobject= 'd_baseline_unicode_po_detail'
	ldsPOdetail.SetTransObject(SQLCA)
	
	llFilerowCount = lds_load_file.RowCount()
	
	
	//Get the next available file sequence number
	llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
	If llBatchSeq <= 0 Then Return -1
	
	
	
	
	//---
	
	SetNull(ld_Last_Order_Date) 
	ls_Last_Supplier = ""
	lsLastOrder = ""
	boolean lb_key_found	
	String ls_last_order_date, ls_last_supplier_cd

	long ll_upper, ll_ary_indx
			
	for ll_Idx = 1 to  llFilerowCount
		
		
		if DaysAfter(ldt_tomorrow, lds_load_file.GetItemDate(ll_idx, "order_date")) > 0 then
			// Date is greater than tomorrow, this order can be processed
		else
			// Date <= tomorrow, this order cannot be processed
			continue
		end if
	

//		// Now orders set to "Replace" have been processed upstream and will not get loaded into the EDI tables
//		if lds_load_file.GetItemStrng (ll_Idx, "change_id") = 'R' then
//			continue
//		end if
	
		lsOrder = lds_load_file.GetItemString(ll_idx, "order_number")
		lsCustomerCode = lds_load_file.GetItemString(ll_idx, "cust_code")
		lb_key_found = false

		//if lsLastOrder <> lsOrder then

		lsSupplier = lds_load_file.GetItemString(ll_idx, "Supplier")
		ls_OrderDate = string(lds_load_file.GetItemDate(ll_idx, "order_date"))

		if lsSupplier <> ls_last_supplier_cd or ls_OrderDate <> ls_last_order_date then 					

			ls_last_supplier_cd = lsSupplier
			ls_last_order_date = ls_OrderDate

			lsChangeID = lds_load_file.GetItemString(ll_idx, "change_id")
			lsWarehouse = lds_load_file.GetItemString(ll_idx, "warehouse")
			//ls_OrderDate = string(lds_load_file.GetItemDate(ll_idx, "order_date"))			
			ls_DeliveryDate = string(lds_load_file.GetItemDate(ll_idx, "order_date"))	
			ls_GI_Date = string(lds_load_file.GetItemDate(ll_idx, "order_date"))			
			lsCustomerCode = lds_load_file.GetItemString(ll_idx, "cust_code")
			lsOrderType = lds_load_file.GetItemString(ll_idx, "order_type")
			lsUserField1 = lds_load_file.GetItemString(ll_idx, "user_field1")	
			ll_Qty =	lds_load_file.GetItemNumber(ll_idx, "qty")
			ls_Cust_Order_Number = lds_load_file.GetItemString(ll_idx, "cust_order_number")
			//lsSupplier = lds_load_file.GetItemString(ll_idx, "Supplier")
		
		
			lsFileIdent =  lds_load_file.GetItemString(ll_idx, "filename")

			// if lsFileIdent is in the array of DO's keys not to process, then don't process this RO and continue to the next RO
			//long ll_upper, ll_ary_indx
			ll_upper = UpperBound(la_do_xkeys)
			for ll_ary_indx = 1 to ll_upper
				if la_do_xkeys[ ll_ary_indx ] = lsFileIdent then
					lb_key_found = true
					exit
				end if
			next
			if lb_key_found then continue
			
			lsLastOrder = lsOrder	
			
		
			liNewRow = 	ldsPOheader.InsertRow(0)
			llInboundOrderSeq ++
			llInboundLineSeq = 0
			
			//New Record Defaults
	
			ldsPOheader.SetItem(liNewRow,'project_id',asproject)
			ldsPOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
			ldsPOheader.SetItem(liNewRow,'Request_date',String(Today())) //37IL441776
			ldsPOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPOheader.SetItem(liNewRow,'order_seq_no',llInboundOrderSeq) 
			ldsPOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsPOheader.SetItem(liNewRow,'Status_cd','N')
			ldsPOheader.SetItem(liNewRow,'Last_user','SIMSEDI')
	
			ldsPOheader.SetItem(liNewRow,'Order_No',lsOrder)	
			
			ldsPOheader.SetItem(liNewRow,'Supp_Order_No', ls_Cust_Order_Number)
			
			ldsPOheader.SetItem(liNewRow,'Order_type',lsOrderType) /*Order Typer*/
			ldsPOheader.SetItem(liNewRow,'Inventory_Type','N') /*default to Normal*/
	
	
			ldsPOheader.SetItem(liNewRow,'action_cd',lsChangeID) /*Supplier Order*/	
	
			ldsPOheader.SetItem(liNewRow,'Supp_Code',lsSupplier) /*Supplier Code*/	

			ldsPOheader.SetItem(liNewRow,'User_Field1',lsUserField1)
			ldsPOheader.SetItem(liNewRow,'User_Field15',lsFileIdent)

			ldsPOheader.SetItem(liNewRow,'Ord_Date', ls_OrderDate)
			ldsPOheader.SetItem(liNewRow,'arrival_date', ls_OrderDate)			
	
		end if	
			
		// DETAIL RECORD
	
		lsSupplier = lds_load_file.GetItemString(ll_idx, "Supplier")
		
		ll_line_no = lds_load_file.GetItemNumber(ll_idx, "line_number")
		
		
		
		lsSku = lds_load_file.GetItemString(ll_idx, "sku")
		ll_Qty =	lds_load_file.GetItemNumber(ll_idx, "qty")
		
		If IsNull(ll_Qty) OR String(ll_Qty) = '' THEN ll_Qty = 0
		
		ls_InventoryType = "N"
	
		//On Adds, don't do anything with the 0 Qty Rows
		if lsChangeID = "A" and ll_Qty = 0 then Continue	
		
		
		lbDetailError = False
		llNewDetailRow = 	ldsPODetail.InsertRow(0)
		llInboundLineSeq ++	
		
				
		//Add detail level defaults
		ldsPODetail.SetItem(llNewDetailRow,'order_seq_no',llInboundOrderSeq) 
		
		ldsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
		ldsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
		ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
		ldsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
		ldsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llInboundLineSeq))
		
		ldsPODetail.SetItem(llNewDetailRow,'Order_No',lsOrder)			
		ldsPODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Action_Cd*/	

		ldsPODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
		ldsPODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
		ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No', ll_line_no) /*Line_Item_No*/	
		ldsPODetail.SetItem(llNewDetailRow,'Quantity', String(ll_Qty)) /*Quantity*/				
						
	Next
	
	
	//Save the Changes 
	//SQLCA.DBParm = "disablebind =0"
	lirc = ldsPOheader.Update()
	//SQLCA.DBParm = "disablebind =1"
	
		
	If liRC = 1 Then
	//	SQLCA.DBParm = "disablebind =0"
		liRC = ldsPODetail.Update()
	//	SQLCA.DBParm = "disablebind =1"
		
	ELSE
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new PO Header Records to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new PO Records to database!")
		Return -1
	End If
	
	Commit;
	
	
	//End IF
		
	int li_process_po_rc
	li_process_po_rc = gu_nvo_process_files.uf_process_purchase_order(asProject)

	lsLogOut = Space(17) + "- Return of gu_nvo_process_files.uf_process_purchase_order() =" + String(li_process_po_rc) + "     time=" + String(now())
	FileWrite(gilogFileNo,lsLogOut)


	lds_load_file.SetFilter("inbound_or_outbound='I'")
	lds_load_file.Filter()


	////////////////////////////////////////////////////////////////////////////////
	// Reconcile existing orders.  These are orders received in XLS files 
	// where corresponding RO exists in the database in new status.
	////////////////////////////////////////////////////////////////////////////////
	liRC = uf_reconcile_existing_po(lds_load_file, li_process_po_rc, ls_store_code)

	lsLogOut = Space(17) + "- Return of uf_reconcile_existing_po() =" + String(liRC) + "     time=" + String(now())
	FileWrite(gilogFileNo,lsLogOut)

end if

return 0
end function

public function string uf_convert_tab_name_to_code (string as_tab_name);String ls_response

as_tab_name = Upper(Trim(as_tab_name))

choose case as_tab_name
	case 'DAILY_FRESH'
		ls_response = 'D-FR'
	case 'DAILY_XD_MARRIOTT'
		ls_response = 'D-XD'
	case 'DAILY_XD_ROY'
		ls_response = 'D-XD'
	case 'DAILY_XD_COFFEE BEANS'
		ls_response = 'D-XD'
	case 'DAILY_XD_S&P'
		ls_response = 'D-XD'
	case 'DAILY_XD_CHAMP BOOM BELLE'
		ls_response = 'D-XD'
	case 'DAILY_XD_PERFETTO FOODS'
		ls_response = 'D-XD'

	case 'DAILY_AMBIENT_INV'
		ls_response = 'D-INV'

	case 'WEEKLY_AMBIENT_INV'
		ls_response = 'W-INV'
	case 'WEEKLY_AMBIENT_SM'
		ls_response = 'W-SM'
	case 'WEEKLY_AMBIENT_BRU'
		ls_response = 'W-BRC'

	case 'DAILY_FRZ_MARRIOTT'
		ls_response = 'D-FRZ'
	case 'DAILY_FRZ_ROY'
		ls_response = 'D-FRZ'
	case 'DAILY_FRZ_S&P'
		ls_response = 'D-FRZ'
	case 'DAILY_FRZ_LURPAK'
		ls_response = 'D-FRZ'
	case 'DAILY_FRZ_COFFEE_BEAN_BY_DAO'
		ls_response = 'D-FRZ'

	case 'CDC_AUTOSHIP_INV'
		ls_response = 'W-AIN'
	case 'CDC_AUTOSHIP_SM'
		ls_response = 'W-ASM'
	case 'CDC_AUTOSHIP_BRU'
		ls_response = 'W-ABR'
	case 'NONCDC_AUTOSHIP_INV'
		ls_response = 'W-AIN'
	case 'NONCDC_AUTOSHIP_SM'
		ls_response = 'W-ASM'
	case 'NONCDC_AUTOSHIP_BRU'
		ls_response = 'W-ABR'

	case 'CDC_PROMOCAMPAIGN_INV'
		ls_response = 'W-AIN'
	case 'CDC_PROMOCAMPAIGN_SM'
		ls_response = 'W-ASM'
	case 'CDC_PROMOCAMPAIGN_BRU'
		ls_response = 'W-ABR'
	case 'NONCDC_PROMOCAMPAIGN_INV'
		ls_response = 'W-AIN'
	case 'NONCDC_PROMOCAMPAIGN_SM'
		ls_response = 'W-ASM'
	case 'NONCDC_PROMOCAMPAIGN_BRU'
		ls_response = 'W-ABR'

	case 'URGENT_INV'
		ls_response = 'W-AIN'
	case 'URGENT_SM'
		ls_response = 'W-ASM'
	case 'URGENT_BRU'
		ls_response = 'W-ABR'
	
end choose

// Allow for any inconsistancies in tab names as in Promo tab names which currently have the store number prepended
if Len(ls_response) = 0 then
	if Pos(as_tab_name, "CDC_PROMOCAMPAIGN_INV") > 0 then
		ls_response = 'W-AIN'
	end if

	if Pos(as_tab_name, "CDC_PROMOCAMPAIGN_SM") > 0 then
		ls_response = 'W-ASM'
	end if

	if Pos(as_tab_name, "CDC_PROMOCAMPAIGN_BRU") > 0 then
		ls_response = 'W-ABR'
	end if

	if Pos(as_tab_name, "NONCDC_PROMOCAMPAIGN_INV") > 0 then
		ls_response = 'W-AIN'
	end if

	if Pos(as_tab_name, "NONCDC_PROMOCAMPAIGN_SM") > 0 then
		ls_response = 'W-ASM'
	end if

	if Pos(as_tab_name, "NONCDC_PROMOCAMPAIGN_BRU") > 0 then
		ls_response = 'W-ABR'
	end if

	// Autoship tabs also have store numbers prepended to the tab name
	if Pos(as_tab_name, "NONCDC_AUTOSHIP_BRU") > 0 then
		ls_response = 'W-ABR'
	end if
	
	if Pos(as_tab_name, "NONCDC_AUTOSHIP_SM") > 0 then
		ls_response = 'W-ASM'
	end if
	
	if Pos(as_tab_name, "NONCDC_AUTOSHIP_INV") > 0 then
		ls_response = 'W-AIN'
	end if
	
	if Pos(as_tab_name, "CDC_AUTOSHIP_BRU") > 0 then
		ls_response = 'W-ABR'
	end if
	
	if Pos(as_tab_name, "CDC_AUTOSHIP_SM") > 0 then
		ls_response = 'W-ASM'
	end if
	
	if Pos(as_tab_name, "CDC_AUTOSHIP_INV") > 0 then
		ls_response = 'W-AIN'
	end if

end if

return ls_response

end function

public function integer uf_reconcile_existing_po (datastore ads_load_file, integer ai_error_code, string as_store_code);// The datastore argument may contain rows with a change code of 'A' (add) and/or 'R' (reconcile).
// The error code argument will contain either a -1 (error condition) or 0 (error free)


// Processing rows with change code of 'A' ...
//
// Filter the load datastore for change id of 'A' then sort by date, supplier
// If the error code = 0 
//   insert all rows into the reconcilliation table
// If the error code = -1 
//   select on the EDI inbound tables for the orders that process successfully
//   insert all of these into the reconcilliation table
//   add the inserted qty to RD.qty
//
//

// Processing rows with change code of 'R' ...
//
// 1. Filter the load datastore for change id of 'R' then sort by date, supplier
// 2. Retrieve all Receive_Detail rows associated to load datastore (the ro_no's were determined in the insert loop above) into a RD datastore
// 3. Scroll through the load DS and find the RO_NO and SKU in the RD datastore
// 4. If found, add the load qty to the RD.req_qty
// 5. If !found, insert a row into the RD datastore and set the RD.req_qty to the load qty
// 6. Update the RD datastore



//String lsDate
//lsDate = String(Today(), "yymmddhhmmss")
//// TODO: temp...
//ads_load_file.SaveAs("c:\temp\ads_load_file_" + lsDate + ".csv", CSV!, true)
//// end TODO temp




String ls_find_str, ls_error, ls_report, ls_ro_no_in_list
long ll_detail_found_row, ll_item_rows, ll_next_line_item_no, ll_rows_a, ll_rows_b, ll_detail_rows, ll_new_row
String lsa_ro_no_list[]
DateTime ldt_warehouse_time
Date ldt_tomorrow

ldt_warehouse_time = f_getlocalworldtime("STBTH")
ldt_tomorrow = RelativeDate (Date(ldt_warehouse_time), 1)

datastore lds_reconcile
datastore lds_receive_detail
datastore lds_item_master
datastore  lds_stbth_receive_detail

lds_reconcile = f_datastoreFactory('d_receive_reconcile')
lds_receive_detail = f_datastoreFactory( 'd_receive_detail_reconcile')
lds_item_master = f_datastoreFactory('d_item_master')
lds_stbth_receive_detail = f_datastoreFactory('d_starbucks_receive_detail')

// Processing rows with change code of 'A' ...

// Filter the load datastore for change id of 'A' then sort by date, supplier
//ads_load_file.SetFilter("inbound_or_outbound='I' AND change_id='A'")
ads_load_file.SetFilter("inbound_or_outbound='I' AND (change_id='A' or change_id='R')")
ads_load_file.Filter()
ads_load_file.SetSort("inbound_or_outbound A,  order_date A, supplier A, sku A, ")
ads_load_file.Sort()


ll_rows_a = ads_load_file.RowCount()

ls_report = "Reconciliation results: error_code: " + String(ai_error_code) + "; store_code: " + as_store_code + "; change_id: A or R rows: " + String(ads_load_file.RowCount()) + "; "
FileWrite(giLogFileNo,ls_report)
gu_nvo_process_files.uf_write_log(ls_report) /*write to Screen*/



// If the error code = 0 (no errors)
//   insert all rows into the reconcilliation table
if ai_error_code = 0 and ads_load_file.RowCount() > 0 then

	// PO details datastore
	long ll_row, i, j, ll_found_row, ll_receive_detail_rows
	String ls_file_ident
	int li_rc
	boolean lb_deleted_qty_check
	long ll_debug_row

	for i = 1 to ads_load_file.RowCount()

		if DaysAfter(ldt_tomorrow, date(ads_load_file.Object.order_date[i])) > 0 then
			// Order can be processed
		else
			// This date will not be processed as it is not greater than tomorrow
			continue
		end if

		if ls_file_ident <> ads_load_file.Object.filename[i] then
			ll_receive_detail_rows = lds_receive_detail.Retrieve('STBTH', ads_load_file.Object.filename[i])	// Retrieve PO details using UF15

			
			if ll_receive_detail_rows <= 0 then
				ls_error = "Reconciliation error; unable to retrieve detail rows for file code: " + ads_load_file.Object.filename[i] + "  corresponding to receive_master.user_field15 "
				gu_nvo_process_files.uf_writeError(ls_error)
				FileWrite(gilogFileNo,ls_error)
				return -1
			elseif lds_receive_detail.Object.receive_master_ord_status[1] <> 'N' then
				ls_error = "Reconciliation error; order not in new status, ro_no: " + lds_receive_detail.Object.receive_master_ro_no[1]
				gu_nvo_process_files.uf_writeError(ls_error)
				FileWrite(gilogFileNo,ls_error)
				return -1
			end if
		end if

		ll_row = lds_reconcile.InsertRow(0)

		lds_reconcile.Object.project_id[ll_row] = "STBTH"
		lds_reconcile.Object.ro_no[ll_row] = lds_receive_detail.Object.receive_master_ro_no[1]
		lds_reconcile.Object.line_item_no[ll_row] = ads_load_file.Object.line_number[i]
		lds_reconcile.Object.sku[ll_row] = ads_load_file.Object.sku[i]
		lds_reconcile.Object.store_code[ll_row] = as_store_code
		lds_reconcile.Object.qty[ll_row] = ads_load_file.Object.qty[i]
		lds_reconcile.Object.record_create_date[ll_row] = ldt_warehouse_time
		
		ads_load_file.Object.user_field2[i] = lds_receive_detail.Object.receive_master_ro_no[1]	// for later use 
		
		if Pos(ls_ro_no_in_list, lds_receive_detail.Object.receive_master_ro_no[1]) = 0 then
			ls_ro_no_in_list = ls_ro_no_in_list + lds_receive_detail.Object.receive_master_ro_no[1]
			lsa_ro_no_list[ UpperBound(lsa_ro_no_list) + 1 ] = lds_receive_detail.Object.receive_master_ro_no[1]
		end if
	next

	SQLCA.DBParm = "disablebind =0"
	ll_debug_row = lds_reconcile.RowCount()
	li_rc = lds_reconcile.Update()
	SQLCA.DBParm = "disablebind =1"

	if li_rc = 1 then
		Commit;
	else
		Rollback;
		ls_error = "Reconciliation error; change_id=A; ro_no: " + lds_receive_detail.Object.receive_master_ro_no[1] + &
						"; error updating receive_reconcile;" + " sqlcode=" + String(sqlca.sqlcode) + "; error Text=" + sqlca.SQLErrText					
		gu_nvo_process_files.uf_writeError(ls_error)
		FileWrite(gilogFileNo,ls_error)
		return -1
	end if
end if


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// TODO:
//
// if error code = -1 then
//	 Errors detected in generic process PO method, only process the RO's that were successfully processed in the generic process PO method.  Insert those rows into the reconcilliation table.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 1. Filter the load datastore for change id of 'R' then sort by date, supplier
ads_load_file.SetFilter("inbound_or_outbound='I' AND change_id='R'")
ads_load_file.Filter()
ads_load_file.SetSort("inbound_or_outbound A,  order_date A, supplier A, sku A, ")
ads_load_file.Sort()

// Retrieve detail rows for *all* receive orders processed in the load datastore
ll_detail_rows = lds_stbth_receive_detail.Retrieve(lsa_ro_no_list)


ls_report = "Reconciliation: change_id R; load file rows: " + String(ads_load_file.RowCount()) + "; Receive_Detail rows: " + String(ll_detail_rows)
FileWrite(giLogFileNo,ls_report)
gu_nvo_process_files.uf_write_log(ls_report) /*write to Screen*/


long ll_max_line_item_no

if ads_load_file.RowCount() > 0 then
	// 2. Scroll through the load DS processing the UF15 values in groups
	for i = 1 to ads_load_file.RowCount()

		if DaysAfter(ldt_tomorrow, date(ads_load_file.Object.order_date[i])) > 0 then
			// Order can be processed
		else
			// This date will not be processed as it is not greater than tomorrow
			continue
		end if

		ls_find_str = "ro_no = '" + ads_load_file.Object.user_field2[i] + "' and sku = '" + ads_load_file.Object.sku[i] + "'"
		ll_row = lds_stbth_receive_detail.find(ls_find_str, 1, lds_stbth_receive_detail.RowCount())
		
		if ll_row > 0 then

			// add qty
			lds_stbth_receive_detail.Object.req_qty[ll_row] = lds_stbth_receive_detail.Object.req_qty[ll_row] + ads_load_file.Object.qty[i]

		else
			
			// Insert RD row and set qty.  This is the case when we have an updated XLS with new SKU's
			ll_new_row = lds_stbth_receive_detail.InsertRow(0)
			lds_stbth_receive_detail.Object.ro_no[ll_new_row] = ads_load_file.Object.user_field2[i]
			lds_stbth_receive_detail.Object.sku[ll_new_row] = ads_load_file.Object.sku[i]
			lds_stbth_receive_detail.Object.req_qty[ll_new_row] = ads_load_file.Object.qty[i]
			lds_stbth_receive_detail.Object.alloc_qty[ll_new_row] = 0
			lds_stbth_receive_detail.Object.damage_qty[ll_new_row] = 0
			lds_stbth_receive_detail.Object.record_create_date[ll_new_row] = ldt_warehouse_time
			ll_max_line_item_no = uf_find_max_line_item_no(lds_stbth_receive_detail, ads_load_file.Object.user_field2[i])	// find max line item no
			lds_stbth_receive_detail.Object.line_item_no[ll_new_row] = ( ll_max_line_item_no + 1 )
			lds_stbth_receive_detail.Object.user_line_item_no[ll_new_row] = String(ll_max_line_item_no + 1)

			ll_item_rows = lds_item_master.retrieve('STBTH', ads_load_file.Object.sku[i])
			if ll_item_rows > 0 then
				lds_stbth_receive_detail.Object.supp_code[ll_new_row] = lds_item_master.Object.supp_code[1]
				lds_stbth_receive_detail.Object.owner_id[ll_new_row] = lds_item_master.Object.owner_id[1]
				lds_stbth_receive_detail.Object.country_of_origin[ll_new_row] = lds_item_master.Object.country_of_origin_default[1]
				if IsNull(lds_item_master.Object.alternate_sku[1]) then
					lds_stbth_receive_detail.Object.alternate_sku[ll_new_row] = lds_stbth_receive_detail.Object.sku[ll_new_row]
				else
					lds_stbth_receive_detail.Object.alternate_sku[ll_new_row] = lds_item_master.Object.alternate_sku[1]
				end if
				lds_stbth_receive_detail.Object.uom[ll_new_row] = lds_item_master.Object.uom_1[1]
			else
				ls_error = "Reconciliation error, item_master record could not be retrieved for file code / sku: " + ads_load_file.Object.filename[i] + "/" + ads_load_file.Object.sku[i]
				gu_nvo_process_files.uf_writeError(ls_error)
				FileWrite(gilogFileNo,ls_error)
				return -1
			end if				

		end if

	next


//	// TODO: temp, remove this...
	String lsDate
	lsDate = String(Today(), "yymmddhhmmss")
//	lds_stbth_receive_detail.SaveAs("c:\temp\lds_stbth_receive_detail_" + lsDate + ".csv", CSV!, true)
//	// end TODO temp
//	//
//	// Delete all detail rows where quantity = 0
//	long x
//	for x = lds_stbth_receive_detail.RowCount() to 1 step -1
//		if Long(lds_stbth_receive_detail.Object.req_qty[x]) = 0 or IsNull(lds_stbth_receive_detail.Object.req_qty[x]) then
//			lds_stbth_receive_detail.DeleteRow(x)
//		end if
//	next
//	lds_stbth_receive_detail.SaveAs("c:\temp\lds_stbth_receive_detail_AFTER_DELETE" + lsDate + ".csv", CSV!, true)
//	
//	// TODO: 2. Now scroll through the RM:RD and if no RD's exist for an RM (deleted above) then delete the RM.
//	long ll_count
//	for x = 1 to UpperBound(lsa_ro_no_list)
//		
//		SELECT count(*)
//		INTO :ll_count
//		FROM receive_master
//		WHERE project_id = 'STBTH'
//		AND ro_no = :lsa_ro_no_list[x];
//
//		if ll_count = 0 then
//			DELETE FROM receive_master
//			WHERE ro_no = :lsa_ro_no_list[x];
//			
//			ls_report = "Reconciliation: deleting Receive_Master record because no detail rows exist;  RO_NO= " + lsa_ro_no_list[x]
//			FileWrite(giLogFileNo,ls_report)
//
//		end if
//	next
//

	// Delete all detail rows where quantity = 0
	long x
	for x = lds_stbth_receive_detail.RowCount() to 1 step -1
		real lr_temp
		lr_temp = Real(lds_stbth_receive_detail.Object.req_qty[x])
		long ll_temp 
		ll_temp = Long(lds_stbth_receive_detail.Object.req_qty[x])
		if Long(lds_stbth_receive_detail.Object.req_qty[x]) = 0 or IsNull(lds_stbth_receive_detail.Object.req_qty[x]) then
			lds_stbth_receive_detail.DeleteRow(x)
		end if
	next
//	lds_stbth_receive_detail.SaveAs("c:\temp\lds_stbth_receive_detail_AFTER_DELETE" + lsDate + ".csv", CSV!, true)

	SQLCA.DBParm = "disablebind =0"
	
	li_rc = lds_stbth_receive_detail.Update()

	SQLCA.DBParm = "disablebind =1"
	
	if li_rc = 1 then

		Commit;

	else

		ls_error = "Reconciliation error -- Error updating Receive_Detail quantities: " + " sqlcode=" + String(sqlca.sqlcode) + "; error Text=" + sqlca.SQLErrText

		Rollback;

		gu_nvo_process_files.uf_writeError(ls_error)
		FileWrite(gilogFileNo,ls_error)
		return -1

	end if
end if


// Delete all orders where no quantity exists (decremented via reconciliation)
ads_load_file.SetFilter("inbound_or_outbound='I'")
ads_load_file.Filter()
ads_load_file.SetSort("filename A")
ads_load_file.Sort()

String ls_last_filename, ls_ro_no
long ll_qty, ll_count

for i = 1 to ads_load_file.RowCount()
	if ls_last_filename <> Upper(Trim(	ads_load_file.Object.filename[i])) then
		ls_last_filename = Upper(Trim(	ads_load_file.Object.filename[i]))

		if Len(Trim(ls_last_filename)) > 0 then
			SELECT Sum(RD.Req_Qty), Count(RM.RO_No), Max(RM.RO_No)
			INTO :ll_qty, :ll_count, :ls_ro_no
			FROM Receive_Master RM
			INNER JOIN Receive_Detail RD 
			ON RD.ro_no = RM.RO_No
			WHERE RM.Project_id = 'STBTH'
			AND RM.Create_User = 'SIMSFP'
			AND RM.Ord_Status = 'N'
			AND RM.User_Field15 = :ls_last_filename;
	
			if ll_count >= 1 and ll_qty = 0 then
	
				DELETE FROM Receive_Detail
				WHERE Ro_No = :ls_ro_no;
	
				DELETE FROM Receive_Detail
				WHERE Ro_No = :ls_ro_no;	
			end if
		end if
	end if
next


if IsValid(lds_reconcile) then Destroy lds_reconcile
if IsValid(lds_receive_detail) then Destroy lds_receive_detail
if IsValid(lds_item_master) then Destroy lds_item_master
if IsValid(lds_item_master) then Destroy lds_item_master
if IsValid(lds_stbth_receive_detail) then Destroy lds_stbth_receive_detail

//FileWrite(gilogFileNo,"Reconciliation Successful; " + ls_report)
ls_report = "Reconciliation Successful"
FileWrite(giLogFileNo,ls_report)
gu_nvo_process_files.uf_write_log(ls_report) /*write to Screen*/

return 0

end function

public function long uf_find_max_line_item_no (datastore ads_stbth_receive_detail, string as_ro_no);long ll_return = 0

datastore  lds_copy
lds_copy = f_datastoreFactory('d_starbucks_receive_detail')

ads_stbth_receive_detail.RowsCopy(1, ads_stbth_receive_detail.RowCount(), Primary!, lds_copy, 1, Primary!)

lds_copy.SetFilter("ro_no = '" + as_ro_no + "'")
lds_copy.Filter()
lds_copy.SetSort("line_item_no desc")
lds_copy.Sort()

if lds_copy.RowCount() > 0 then
	long i
	for i = 1 to lds_copy.RowCount()
		ll_return = Long(lds_copy.Object.line_item_no[i])
		if NOT IsNull(ll_return) then
			exit
		end if
	next
end if

return ll_return

end function

public function integer uf_process_so (string aspath, string asproject);long ll_rc
String lsLogOut

u_ds_datastore lds_import
lds_import = Create u_ds_datastore
lds_import.dataobject= 'd_import_so'
lds_import.SetTransObject(SQLCA)

lsLogOut = '      - Opening File for Starbucks SO Import Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

ll_rc = lds_import.ImportFile(aspath, 1)

// If Headers are present, import again and skip the header row
if ll_rc > 0 or ll_rc = -4 then
	if lds_import.RowCount() > 0 then
		if Upper(Left(lds_import.Object.Project_Id[1], 7)) = 'PROJECT' then
			lds_import.Reset()
			ll_rc = lds_import.ImportFile(aspath, 2)
		end if
	end if
end if

// Process import return
if ll_rc <= 0 then
	lsLogOut = '      - Error importing file, error code: ' + String(ll_rc)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	gu_nvo_process_files.uf_writeError(lsLogOut)
	return -1
else
	lsLogOut = '      - Rows imported from file: ' + String(ll_rc)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

ll_rc =  gu_nvo_process_files.uf_process_import_server( asproject, Trim( lds_import.Object.DataWindow.Data.XML ) )

return ll_rc

end function

public function integer uf_process_po (string aspath, string asproject);long ll_rc
String lsLogOut

u_ds_datastore lds_import
lds_import = Create u_ds_datastore
lds_import.dataobject= 'd_import_po'
lds_import.SetTransObject(SQLCA)

lsLogOut = '      - Opening File for Starbucks PO Import Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

ll_rc = lds_import.ImportFile(aspath, 1)

// If Headers are present, import again and skip the header row
if ll_rc > 0 or ll_rc = -4 then
	if lds_import.RowCount() > 0 then
		if Upper(Left(lds_import.Object.Project[1], 7)) = 'PROJECT' then
			lds_import.Reset()
			ll_rc = lds_import.ImportFile(aspath, 2)
		end if
	end if
end if

// Process import return
if ll_rc <= 0 then
	lsLogOut = '      - Error importing file, error code: ' + String(ll_rc)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	gu_nvo_process_files.uf_writeError(lsLogOut)
	return -1
else
	lsLogOut = '      - Rows imported from file: ' + String(ll_rc)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

ll_rc =  gu_nvo_process_files.uf_process_import_server( asproject, Trim( lds_import.Object.DataWindow.Data.XML ) )

return ll_rc

end function

on u_nvo_proc_starbucks_th.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_starbucks_th.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)


String ls_num_xls_to_process
ls_num_xls_to_process = f_retrieve_parm('STBTH', 'PARM', 'NUM_XLS_2_PROCESS')
il_governor_num = Long( ls_num_xls_to_process)

if isNull(il_governor_num) then
	il_governor_num = 0
end if

end event

