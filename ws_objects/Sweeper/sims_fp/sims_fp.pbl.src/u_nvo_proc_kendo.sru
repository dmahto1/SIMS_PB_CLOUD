$PBExportHeader$u_nvo_proc_kendo.sru
forward
global type u_nvo_proc_kendo from nonvisualobject
end type
end forward

global type u_nvo_proc_kendo from nonvisualobject
end type
global u_nvo_proc_kendo u_nvo_proc_kendo

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 

end prototypes

type variables

string lsDelimitChar
u_nvo_proc_baseline_unicode	iuo_proc_baseline_unicode
end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_itemmaster (string aspath, readonly string asproject)
public function integer uf_process_batch_master (string aspath)
public function integer uf_process_delivery_order (string aspath, string asproject)
public function integer uf_process_dboh (string asproject, string asinifile, string aswarehouse)
public function integer uf_process_inv_type_change (string aspath, string asproject)
public function integer uf_update_content_expiration_date (string assku, string assupplier, string aslot, string asexpdate)
public function integer uf_process_inv_type_update (string asproject)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut,	&
			lsSaveFileName, &
			lsPOLineCountFileName
			
Integer	liRC
integer 	liLoadRet, liProcessRet
Boolean	bRet

If not isvalid(u_nvo_proc_baseline_unicode) Then
	iuo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode
End If

Choose Case Upper(Left(asFile,2))
		
	Case  'PM'  
		
		liRC = iuo_proc_baseline_unicode.uf_process_purchase_order(asPath, asProject)
	
		//Process any added PO's
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 

	Case  'DM'  
		
	//	liLoadRet = iuo_proc_baseline_unicode.uf_process_delivery_order(asPath, asProject)
		liLoadRet = uf_process_delivery_order(asPath, asProject)
			
		//Process any added SO's
		If liLoadRet = 0 Then
			liProcessRet = gu_nvo_process_files.uf_process_Delivery_order(asProject)
		End If
		
		
		if liLoadRet = -1 OR liProcessRet = -1 then liRC = -1 else liRC = 0
				
	Case 'IM'
		
		liRC = uf_Process_ItemMaster(asPath, asProject)
		

	Case  'RM'  
		
		liRC = iuo_proc_baseline_unicode.uf_return_order(asPath, asProject)
	
		//Process any added PO's
		//We need to change to project. This will be changed after testing.
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject)  
			
	Case "BM" /* Batch (Lot) Master file */
			
		liRC = uf_process_batch_master(asPath)
		
	Case "IA" /* Inventory Adjustment file */
			
		liRC = uf_process_inv_type_change(asPath,asProject)
			
	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
end function

public function integer uf_process_itemmaster (string aspath, readonly string asproject);long ll_rc
String lsLogOut

u_ds_datastore lds_import
lds_import = Create u_ds_datastore
lds_import.dataobject= 'd_import_item_master'
lds_import.SetTransObject(SQLCA)

lsLogOut = '      - Opening File for Kendo IM Import Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

ll_rc = lds_import.ImportFile(aspath, 1)

// If Headers are present, import again and skip the header row
if ll_rc > 0 or ll_rc = -4 then
	if lds_import.RowCount() > 0 then
		if Upper(Left(lds_import.Object.Project_ID[1], 7)) = 'PROJECT' then
			lds_import.Reset()
			ll_rc = lds_import.ImportFile(aspath, 2)
		end if
	end if
end if

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

public function integer uf_process_batch_master (string aspath);
String	lsLogOut, lsSKU, lsLot, lsExpDT, lsManDt, lsSuppCode
Integer liRtnImp, liCount, liRC
Long	llRowPos, llRowCount, llReturn
Boolean lbError
u_ds_datastore ldsImport

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Batch Master file for Kendo'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liRC = 0

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Batch Control file for Kendo.  Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1
end if


//Add or Update (assume Add)
llRowCount = ldsImport.RowCount()
For llRowPos = 1 to lLRowCount
	
	lbError = False
	
	lsSKU =  Trim(ldsImport.GetItemString(llRowPos, "col3"))
	lsSuppCode =  Trim(ldsImport.GetItemString(llRowPos, "col4"))
	lsLot =  Trim(ldsImport.GetItemString(llRowPos, "col5"))
	lsManDT =  Trim(ldsImport.GetItemString(llRowPos, "col6"))
	lsExpDT =  Trim(ldsImport.GetItemString(llRowPos, "col7"))
	
	//Validations
	
	//Record ID must be 'BM'
	If isnull(ldsImport.GetItemString(llRowPos, "col1")) or trim(ldsImport.GetItemString(llRowPos, "col1")) = ''  or trim(ldsImport.GetItemString(llRowPos, "col1")) <> 'BM' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - record ID must be present and = 'BM'. Record will not be processed.")
		lbError = True
	End If
	
	//Project ID must be 'KENDO'
	If isnull(ldsImport.GetItemString(llRowPos, "col2")) or trim(ldsImport.GetItemString(llRowPos, "col2")) = ''  or trim(ldsImport.GetItemString(llRowPos, "col2")) <> 'KENDO' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Project ID must be present and = 'KENDO'. Record will not be processed.")
		lbError = True
	End If
	
	//SKU Required
	If isnull(lsSKU) or trim(lsSKU) = ''  Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - SKU is required. Record will not be processed.")
		lbError = True
	End If
	
	//Supplier Required
	If isnull(lsSuppCode) or trim(lsSuppCode) = ''  Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Supplier is required. Record will not be processed.")
		lbError = True
	End If
		
	// SKU/Supplier combo must be valid
	If not lbError Then
		
		Select Count(*) into :liCount
		From item_Master
		Where Project_id = 'KENDO' and Sku = :lsSKU and Supp_Code = :lsSuppcode;
		
		If liCount < 1 Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid SKU/Supplier. Record will not be processed.")
		lbError = True
		End If
		
	End If
	
	If lbError Then 
		liRC = -1
		Continue
	End If
	
	//Default to Insert...
	//22-Jun-2016 :Madhu- Insert based on Suppcode instead Hardcode to KENDO
	Insert into Lot_Control
	(Project_id, SKU, Supp_Code, Lot_No, Expiration_Date, Manufacture_Date)
	Values ('KENDO', :lsSKU, :lsSuppCode,:lsLot, :lsExpDT, :lsManDT)
	Using SQLCA;
	
	If sqlca.SqlCode < 0 Then /* assume row exists for Project/SKU/Supplier/Lot */
			
		Update Lot_Control
		Set Expiration_Date = :lsExpDT, Manufacture_Date = :lsManDT
		Where Project_id = 'KENDO' and SKU = :lsSKU and Supp_Code = :lsSuppCode and Lot_no = :lsLot
		Using SQLCA;
		
		//09-Mar-2017 :Madhu PEVS-494 -Receiving updates to expiration date -START
		llReturn = uf_update_content_expiration_date(lsSKU, lsSuppCode, lsLot, lsExpDT) 

		If llReturn < 0  Then
			//Execute Immediate "ROLLBACK" using SQLCA;  MikeA - DE15499
			rollback using sqlca;
			lsLogOut = "        *** Failed to Update Content / Insert Adjustment Records against Batch Master Data.~r~r" + Sqlca.Sqlerrtext
			FileWrite(gilogFileNo,lsLogOut)
			Return -1	
		End IF
		//09-Mar-2017 :Madhu PEVS-494 -Receiving updates to expiration date -END
		
	End If
	
	Commit;
	
next

Return liRC
end function

public function integer uf_process_delivery_order (string aspath, string asproject);
//
//Process Sales Order (DM) Transaction for Baseline Unicode Client
//Process Delivery Order


u_ds_datastore 	ldsSOheader,	ldsSOdetail, ldsDOAddress, ldsDONotes
u_ds_datastore 	ldsImport

integer lirc, liSeq
boolean lberror
string lslogout, lsConsolNo, lsConsolNoSave, lsShipment
long	llRowPos, llRowCount

//Call the generic load
lirc = iuo_proc_baseline_unicode.uf_load_delivery_order(aspath, asproject, ldsImport, ldsSOheader, ldsSOdetail, ldsDOAddress, ldsDONotes)	

IF lirc = -1 then 
	lbError = true 
else
	lbError = false	
End If

// Kendo's Sales Order number is being loaded as our Shipment ID (Consolidation_No)
//There might be multiple Pick Releases (invoice_no) per Shipment.
// If the current orders on the shipment have been processed (New Status), we will add a suffix to the Shipment ID to break in W_DO but allow us to keep their sales orer number

//sort by consolidation so we only need to check once per shipment
ldsSOheader.SetSort("Consolidation_no A")
ldsSOheader.Sort()

llRowCount = ldsSOheader.RowCount()
For llRowPos = 1 to llRowCount
	
	lsConSolno = ldsSOheader.GetITemString(llRowPos,'consolidation_no')
	
	If lsConsolNo <> lsCOnsolNoSave Then
		
		//See if we have any shipments in a not new status
		Select Max(consolidation_no) into :lsShipment
		From Delivery_MAster
		where Project_id = 'Kendo' and consolidation_no like :lsConsolNo +"%" and Ord_status <> 'N';
		
		If lsShipment = '' or isnull(lsShipment) Then
			
			lsSHipment = lsConsolNo
			
		Else //There is already a shipment, create a new one with pattern Consol*seq
						
			If pos(lsSHipment,"*") > 0 Then
				
				liSeq = Integer(Mid(Trim(lsShipment), pos(lsSHipment,"*") + 1,99))
				liSeq ++
				lsShipment = lsShipment + String(liSeq)
				
			Else
				lsShipment = lsShipment + "*1"
			End If
			
		End If
		
		lsConsolNoSave = lsConsolNo
		
	End If
	
	ldsSOheader.SetItem(llRowPos,'Consolidation_no',lsSHipment)
	
Next

// 08/16 - PCONKL - Clear out Lot codes that are being sent by Kendo
//llRowCount = ldsSODetail.RowCount()
//For llRowPos = 1 to llRowCount
//	ldsSODetail.SetItem(llRowPos,'Lot_no','')
//Next

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



If liRC = 1 Then
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsDOAddress.Update()
	SQLCA.DBParm = "disablebind =1"
ELSE	
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Detail Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If


If liRC = 1 Then
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsDONotes.Update()
	SQLCA.DBParm = "disablebind =1"	
ELSE
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new DO Address Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If

	
If liRC = 1 then
	Commit;
Else
	
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Delivery Notes Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If

If lbError Then
	Return -1
Else
	Return 0
End If

end function

public function integer uf_process_dboh (string asproject, string asinifile, string aswarehouse);
//Process Daily Balance on Hand Confirmation File


Datastore	ldsOut,	&
				ldsboh
				
Long			llRowPos,	&
				llRowCount,	&
				llFindRow,	&
				llNewRow
				
String		lsFind,	&
				lsOutString,	&
				lslogOut,	&
				lsProject,	&
				lsNextRunTime,	&
				lsNextRunDate,	&
				lsRunFreq, &
				lsFilename, &
				lsWarehouse, &
				lsLastWarehouse

DEcimal		ldBatchSeq, ldTotalAvailQty
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

String lsFileNamePath

if isNull(asWarehouse) Then asWarehouse = ""

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_baseline_unicode_dboh'
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = asProject

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' BOH confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrive the BOH Data
gu_nvo_process_files.uf_write_log('Retrieving Balance on Hand Data.....') /*display msg to screen*/

llRowCOunt = ldsBOH.Retrieve(lsProject)

//Filter by Warehouse - We will have a seperate schedule record for each warehouse
if asWarehouse > '' Then
	ldsboh.SetFilter("Upper(wh_Code) = '" + upper(asWarehouse) + "'")
	ldsboh.Filter()
	gu_nvo_process_files.uf_write_log("filtering for warehouse: " + asWarehouse) /*display msg to screen*/
End If 

llRowCOunt = ldsBOH.RowCount()

gu_nvo_process_files.uf_write_log(String(llRowCount) + ' Rows were retrieved for processing.') /*display msg to screen*/

//Write the rows to the generic output table - delimited by lsDelimitChar
gu_nvo_process_files.uf_write_log('Processing Balance on Hand Data.....') /*display msg to screen*/

For llRowPos = 1 to llRowCOunt

	llNewRow = ldsOut.insertRow(0)
	

	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“BH”	Balance on hand identifier
	
	lsOutString = 'BH' + lsDelimitChar
	
	//Project ID	C(10)	Yes	N/A	Project identifier
	lsOutString +=  asproject  + lsDelimitChar

	//Warehouse Code	C(10)	Yes	N/A	Warehouse ID

	lsWarehouse = left(ldsboh.GetItemString(llRowPos,'wh_code'),10)

	lsOutString +=  lsWarehouse + lsDelimitChar
	
	//Inventory Type	C(1)	Yes	N/A	Item condition

	lsOutString += left(ldsboh.GetItemString(llRowPos,'inventory_type'),1) + lsDelimitChar

	//SKU	C(50)	Yes	N/A	Material number

	lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),26) + lsDelimitChar
	
	// 09/16 - PCONKL - Combining Avail & Alloc Qty into Avail Qty field
	//Quantity	N(15,5)	Yes	N/A	Balance on hand
	
	ldTotalAvailQty = ldsboh.GetItemNumber(llRowPos,'avail_qty') + ldsboh.GetItemNumber(llRowPos,'alloc_qty')
	
	//lsOutString += string(ldsboh.GetItemNumber(llRowPos,'avail_qty')) + lsDelimitChar
	lsOutString += string(ldTotalAvailQty) + lsDelimitChar
	
	//Quantity Allocated	N(15,5)	No	N/A	Allocated to Outbound Order
	
//	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'alloc_qty')) + lsDelimitChar
	lsOutString += "0" + lsDelimitChar /* 09/16 - PCONKL - included in Avail Qty */
	
	//Lot Number	C(50)	No	N/A	1st User Defined Inventory field

	if IsNull(ldsboh.GetItemString(llRowPos,'lot_no')) OR trim(ldsboh.GetItemString(llRowPos,'lot_no')) = '-' then
		lsOutString += lsDelimitChar
	else	
	   lsOutString +=  left(ldsboh.GetItemString(llRowPos,'lot_no'),50) + lsDelimitChar
	end if	

	//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
	
	if IsNull(ldsboh.GetItemString(llRowPos,'po_no')) OR trim(ldsboh.GetItemString(llRowPos,'po_no')) = '-' then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'po_no') + lsDelimitChar
	end if	
	
	//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
	
	if IsNull(ldsboh.GetItemString(llRowPos,'po_no2')) OR Trim(ldsboh.GetItemString(llRowPos,'po_no2')) = '-'  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'po_no2') + lsDelimitChar
	end if		
	
	//Serial Number	C(50)	No	N/A	Qty must be 1 if present
	
	if IsNull(ldsboh.GetItemString(llRowPos,'serial_no')) OR Trim(ldsboh.GetItemString(llRowPos,'serial_no')) = '-'  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'serial_no') + lsDelimitChar
	end if			
	
	//Container ID	C(25)	No	N/A	Container ID
	
	if IsNull(ldsboh.GetItemString(llRowPos,'container_ID')) OR trim(ldsboh.GetItemString(llRowPos,'container_ID')) = '-'  then
		lsOutString +=lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'container_ID') + lsDelimitChar
	end if
	
	//Expiration Date	Date	No	N/A	Expiration Date	

	If string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'MM/DD/YYYY') <> "12/31/2999" Then
		lsOutString += string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'YYYY-MM-DD') + lsDelimitChar
	ELSE
		lsOutString +=lsDelimitChar
	End If

	//Item Master UOM
	
	if IsNull(ldsboh.GetItemString(llRowPos,'uom_1')) OR Trim(ldsboh.GetItemString(llRowPos,'uom_1')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'uom_1') + lsDelimitChar
	end if		

	
	//Item Master User_Field1 - Size
	
	if IsNull(ldsboh.GetItemString(llRowPos,'user_field1')) OR Trim(ldsboh.GetItemString(llRowPos,'user_field1')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'user_field1')  + lsDelimitChar
	end if		
		
	// fields not required, not going to map for now
	
	lsOutString += lsDelimitChar /* Supp_invoice_no*/
	lsOutString += lsDelimitChar /* Lot COntrolled Ind*/
	lsOutString += lsDelimitChar /* Serialized Ind*/
	lsOutString += lsDelimitChar /* COO*/
//	lsOutString += lsDelimitChar /* Owner - no need for delimiter after*/
	
	
//	BHYYMDD.dat
	
	lsFilename = ("BH" + string(today(), "YYMMDDHHMM") + ".dat") //5-May-2016 :Madhu- Removed warehouse code
	//lsFilename = ("BH" + string(today(), "YYMMDDHHMM-") + asWarehouse + ".dat") //5-May-2016 :Madhu- commented
	//lsFilename = ("BH" + string(today(), "YYMMDD")  + ".dat")
	
	ldsOut.SetItem(llNewRow,'file_name', lsFilename)
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	
//	if lsLastWarehouse <> lsWarehouse then
//
//		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//		sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
//		commit;
//		
//		If ldBatchSeq <= 0 Then
//			lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' BOH confirmation."
//			FileWrite(gilogFileNo,lsLogOut)
//			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
//			 Return -1
//		End If
//		
//		lsLastWarehouse = lsWarehouse
//		
//	end if	
	
	
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
next /*next output record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(ldsOut,lsProject)



Return 0
end function

public function integer uf_process_inv_type_change (string aspath, string asproject);
Datastore	ldsImport, ldsContent
String	lsLogOut, lsTONO, lsWarehouse, lsWarehousePrev, lsSKU, lsSKUPrev, lsLot, lsOldInvType,  lsNewInvType,lsSuppCode, lsFilter,	&
		lsType, lsSerial, lsPO, lsPO2,ls_Container_ID, ls_COO, lsLoc, lsRefType, lsRefLineNumber, lsRefID, lsErrText
Integer	liRC, liRtnImp
Long	llRowPos, llRowCount, llCount, llContentCount, llContentPos, ll_Owner
Decimal ldTOno, ldQtyToAdjust,ldRemainQty, ldContentQty, ldTransferQty
Boolean	lbError
DateTime	ldtToday, ldt_Expiration_Date

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Inventory Type Change request file for Kendo'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liRC = 0

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Inventory Type Change request file for Kendo.  Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1
end if

llRowCount = ldsImport.RowCount()

If llRowCount = 0 Then
	
	lsLogOut = '      - no records loaded for processing'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return 0
	
End If

ldsContent = Create Datastore
ldsContent.dataobject = 'd_content_by_sku'
ldsContent.SetTransObject(SQLCA)

//For Each record

For llRowPos = 1 to lLRowCount
		
	lbError = False
	
	//Record ID must be "IA"
	If upper( ldsImport.GetITemString(llRowPos,'col1')) <> "IA" Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record ID: " + ldsImport.GetITemString(llRowPos,'col1') + ". Record will not be processed.")
		lbError = True
	End If
	
	//Project must be Kendo
	If upper( ldsImport.GetITemString(llRowPos,'col2')) <> "KENDO" Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Project ID: " + ldsImport.GetITemString(llRowPos,'col2') + ". Record will not be processed.")
		lbError = True
	End If
	
	//Validate Warehouse
	lsWarehouse = ldsImport.GetITemString(llRowPos,'col3')
	
	Select Count(*) into :llCount
	From Project_Warehouse
	Where project_id = "KENDO" and wh_code = :lsWarehouse
	Using SQLCA;
		
	If llCount < 1 Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse Code: " + lsWarehouse + ". Record will not be processed.")
		lbError = True
	End If
			
	//SKU Required
	lsSKU = ldsImport.GetITemString(llRowPos,'col7')
	
	If isnull(lsSKU) or trim(lsSKU) = ''  Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - SKU is required. Record will not be processed.")
		lbError = True
	End If
	
	//Supplier Required
	lsSuppCode = ldsImport.GetITemString(llRowPos,'col8')
	
	If isnull(lsSuppCode) or trim(lsSuppCode) = ''  Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Supplier is required. Record will not be processed.")
		lbError = True
	End If
		
	// SKU/Supplier combo must be valid
	If not lbError Then
		
		Select Count(*) into :llCount
		From item_Master
		Where Project_id = 'KENDO' and Sku = :lsSKU and Supp_Code = :lsSuppcode;
		
		If llCount < 1 Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid SKU/Supplier. Record will not be processed.")
			lbError = True
		End If
		
	End If
	
	//Validate Old Inv Type 
	lsOldInvType = ldsImport.GetITemString(llRowPos,'col19')
	
	Select Count(*) into :llCount
	From Inventory_Type
	Where Project_id = 'KENDO' and Inv_Type = :lsOldInvType;
	
	If llCount < 1 Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Original Inventory Type: " + lsOldInvType + ". Record will not be processed.")
		lbError = True
	End If
	
	//Validate New Inv Type 
	lsNewInvType = ldsImport.GetITemString(llRowPos,'col20')
	
	Select Count(*) into :llCount
	From Inventory_Type
	Where Project_id = 'KENDO' and Inv_Type = :lsNewInvType;
	
	If llCount < 1 Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid New Inventory Type: " + lsOldInvType + ". Record will not be processed.")
		lbError = True
	End If
	
	//End of processing for line if validation errors
	If lbError Then 
		liRC = -1
		Continue
	End If
	
	//If Warehouse changed, create a new Transfer MAster record
	If lsWarehouse <> lsWarehousePrev Then
			
		//Get Next TO_NO
		sqlca.sp_next_avail_seq_no(asproject,"Transfer_Master","TO_No" ,ldTOno)

		If ldTOno <= 0 Then
			lsLogOut = "-       ***Unable to retrieve the next available Transfer Order Number (TO_NO) ***"
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			Return -1
		End If
	
		lsTONO = Trim(Left(asproject,9)) + String(ldTOno,"000000")
		ldtToday = f_getLocalWorldTime( lsWarehouse ) 

		//Create the new Transfer Master record
		Insert Into Transfer_Master
		(TO_NO, Project_ID, s_warehouse, d_warehouse, Ord_Type, Ord_status,Ord_Date)
		Values (:lsTONO, 'KENDO',:lsWarehouse, :lsWarehouse,'X','X',:ldtToday)
		Using SQLCA;
		
		If sqlca.SqlCode < 0 Then
			
			lsErrText = sqlca.SqlErrText
			Rollback;
			lsLogOut = "-       ***Unable to create Transfer_MAster record: " + lsErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			Return -1
			
		Else
			Commit;
		End If
		
				
		lsWarehousePrev = lsWarehouse
		
	End If /* warehouse chanegd*/
		
	ldQtyToAdjust = Dec(ldsImport.GetITemString(llRowPos,'col14')) /*Orig Qty*/
	ldRemainQty = ldQtyToADjust
	
	//Retrieve Inventory for Warehouse/SKU - Filter for Lot and Orig Inv Type
	ldscontent.retrieve("KENDO", lsWarehouse, lsSku,lsSuppcode)
	
	//Filter by Lot_No, and Old Inv Types and sort by qty for least number of picks
	lsFilter = "upper(lot_No) = '" + upper(Trim((ldsImport.GetITemString(llRowPos,'col23')))) + "' and upper(inventory_type) = '" + upper(Trim((ldsImport.GetITemString(llRowPos,'col19')))) + "'"
	ldscontent.SetFilter(lsFilter)
	ldscontent.Filter()
	
	ldsContent.SetSort("avail_qty D, l_code A")
	ldscontent.Sort()
	
	llContentCount = ldscontent.RowCount()
	For llContentPos = 1 to llContentCount
		
		If ldRemainQty = 0 Then Continue
				
		ldContentQty = ldsContent.GetItemDecimal(llContentPos,'avail_qty')
				
		if ldRemainQty >= ldContentQty Then
			
			ldRemainQty = ldRemainQty - ldContentQty
			ldTransferQty = ldContentQty
					
		Else 
						
			ldTransferQty =ldRemainQty
			ldRemainQty = 0
			
		End If
		
		//Create Transfer Detail record
		lsType = ldsContent.GetITemString(llContentPos,"inventory_type")
		lsSerial = ldsContent.GetITemString(llContentPos,"serial_no")
		lslot = ldsContent.GetITemString(llContentPos,"lot_no")
		lspo = ldsContent.GetITemString(llContentPos,"po_no")
		lspo2 = ldsContent.GetITemString(llContentPos,"po_no2")
		ls_container_ID  = ldsContent.GetITemString(llContentPos,"container_ID")   
  		ldt_expiration_date  = ldsContent.GetITemDatetime(llContentPos,"expiration_date")  
		ll_owner = ldsContent.GetITemNumber(llContentPos,"owner_id")
		ls_coo = ldsContent.GetITemString(llContentPos,"country_of_origin")
		lsloc = ldsContent.GetITemString(llContentPos,"l_code")
		
		lsRefType = ldsImport.GetITemString(llRowPos,'col29')
		lsRefLineNumber  = ldsImport.GetITemString(llRowPos,'col30')
		lsRefID =  ldsImport.GetITemString(llRowPos,'col31')
		
		Insert into Transfer_Detail
			(TO_NO, Sku, Supp_Code, Owner_ID, Country_of_Origin, Serial_No, Lot_No, Po_NO, Po_No2, S_Location, D_Location, Inventory_Type,
				Quantity, Container_ID, Expiration_Date, Line_Item_No, New_Inventory_Type, User_Field1, User_Field2, User_Field3)
			Values (:lsTONO, :lsSKU, :lsSuppCode, :ll_owner, :ls_coo, :lsSerial, :lsLot, :lsPO, :lsPO2, :lsLoc,"*",:lsType, :ldTransferQty,
						:ls_container_ID, :ldt_expiration_date, :llRowPos, :lsNewInvType, :lsRefType, :lsRefLineNumber, :lsRefID)
		Using SQLCA;
		
		If sqlca.SqlCode < 0 Then
			
			lsErrText = sqlca.SqlErrText
			Rollback;
			lsLogOut = "-       ***Unable to create Transfer_Detail record: " + lsErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			Return -1
			
		End If
		
	Next /* Content Record*/

	//If qty remains, don't save and send error
	If ldRemainQty > 0 Then
		
		Rollback Using SQLCA;
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Unable to  Allocate Inventory for SKU/Batch Code/Inv Type: " + lsSKU + "/" + lsLot + "/" + lsType +  & 
		" ,Required Qty = "+ String(ldQtyToAdjust) + ", Qty available to allocate = " + String(ldQtyToAdjust - ldRemainQty ) + ". Record will not be processed.")
		
		liRC = -1
		
	Else
		Commit Using SQLCA;
	End If
	
Next /*file record*/

//If no details created, delete header
If lsTONO > '' Then
	
	Select Count(*) into :llCount
	From Transfer_Detail
	Where to_no = :lsTONO;
	
	If llCount = 0 Then
		
		Delete from Transfer_Master where to_no = :lsTONO
		Commit;
		
	Else
		
		//Send Email
		gu_nvo_process_files.uf_send_email("KENDO","TRANSFERDIST","Kendo Inventory Type Change Transfer created","Transfer: " + lsTONO + " has been created for Kendo","")

	End If
	
End If





Return liRC
end function

public function integer uf_update_content_expiration_date (string assku, string assupplier, string aslot, string asexpdate);//09-Mar-2017 :Madhu -PEVS-494 - Receiving updates to expiration date
//Retrieve all content records against Project/Sku/Supplier/Lot

String sql_syntax, ERRORS, lsLogOut
String lsCoo,lsWhcode,lsLcode,lsSerialNo,lsRoNo,lsPoNo,lsPoNo2,lsContainerId,lsOldCoo,lsInvType,lsOldInvType
long 	llrow,llcount,llOwner,llQty
datetime ldtToday
u_ds_datastore ldsContent


ldsContent =CREATE u_ds_datastore

sql_syntax =	" select Owner_Id, Country_Of_Origin, WH_Code, L_Code, Inventory_Type, Avail_Qty, "
sql_syntax +=	" Old_Inventory_Type, Old_Country_Of_Origin, Serial_No, RO_No, PO_No, PO_No2, Container_Id, Expiration_Date "
sql_syntax += 	" from Content with(nolock) "
sql_syntax += 	" where Project_Id ='KENDO' and Sku = '"+assku+"' and Supp_code='"+assupplier+"' and Lot_No='"+aslot+"'"

ldsContent.create( SQLCA.syntaxfromsql( sql_syntax, "", ERRORS))

IF Len(Errors) > 0 THEN
	lsLogOut = "        *** Unable to create datastore for retrieving Content records against Batch Master Data.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   Return - 1
END IF

ldsContent.settransobject(SQLCA)
llcount =ldsContent.retrieve( )

//Execute Immediate "Begin Transaction" using SQLCA; 4/2020 - MikeA - DE15499
		
FOR llrow =1 to llcount
	//get all values into local variables	
	llOwner =ldsContent.getItemNumber( llrow, 'Owner_Id') 
	lsCoo =ldsContent.getItemString(llrow,'Country_Of_Origin')
	lsWhcode=ldsContent.getItemString(llrow, 'WH_Code') 
	lsLcode=ldsContent.getItemString(llrow,'L_Code')
	lsSerialNo=ldsContent.getItemString(llrow,'Serial_No') 
	lsRoNo =ldsContent.getItemString(llrow,'RO_No')
	lsPoNo= ldsContent.getItemString(llrow,'PO_No') 
	lsPoNo2 =ldsContent.getItemString(llrow,'PO_No2')
	lsContainerId= ldsContent.getItemString(llrow,'Container_Id')
	llQty =ldsContent.getItemNumber(llrow, 'Avail_Qty')
	lsOldCoo = ldsContent.getItemString(llrow,'Old_Country_Of_Origin')
	lsInvType = ldsContent.getItemString(llrow,'Inventory_Type')
	lsOldInvType = ldsContent.getItemString(llrow,'Old_Inventory_Type')
	
	
	//update content record
	update Content set Expiration_Date =:asexpdate
	where Project_Id= 'KENDO' and Sku= :assku and Supp_code =:assupplier and Lot_No= :aslot
	and Owner_Id = :llOwner and Country_Of_Origin =:lsCoo	and WH_Code =:lsWhcode
	and L_Code =:lsLcode 	and Serial_No =:lsSerialNo 	and  RO_No =:lsRoNo 	and PO_No= :lsPoNo
	and PO_No2 =:lsPoNo2 	and Container_Id= :lsContainerId 	and Avail_Qty = :llQty
	using sqlca;

	If Sqlca.SqlCode <> 0 Then
		//Execute Immediate "ROLLBACK" using SQLCA;  MikeA - DE15499
		rollback using sqlca;
		lsLogOut = "        *** Unable to update Content records against Batch Master Data.~r~r" + Sqlca.Sqlerrtext
		FileWrite(gilogFileNo,lsLogOut)
		return -1
	End If

	ldtToday = f_getLocalWorldTime( ldsContent.getItemString(llrow, 'WH_Code') ) 

	//insert Adjustment record
	//23-May-2017 :Madhu PEVS-639 - Updated New Qty with Qty.
	Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin,&
									wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no,po_no,old_po_no, po_no2,old_po_no2,&
									container_ID, expiration_date, ro_no,old_quantity,quantity,ref_no,reason,last_user,last_update, Adjustment_Type,&
									old_lot_no,remarks) 
		values				('KENDO',:assku,:assupplier, :llOwner ,:llOwner,:lsCoo,:lsOldCoo,:lsWhcode,:lsLcode,:lsOldInvType,&
									:lsInvType, :lsSerialNo,:aslot,:lsPoNo,'-',:lsPoNo2 ,'-',:lsContainerId, :asexpdate,:lsRoNo,&
									:llQty,:llQty,NULL,'IADJ','SIMSFP',:ldtToday,'X','-','Adjustment created through Sweeper against Batch Master File!') 
		Using SQLCA;

		
		If Sqlca.sqlcode <> 0  Then
			//Execute Immediate "ROLLBACK" using SQLCA; 4/2020 - MikeA - DE15499
			rollback using sqlca;
			lsLogOut = "        *** Unable to create Adjustment records against Batch Master Data.~r~r" + Sqlca.Sqlerrtext
			FileWrite(gilogFileNo,lsLogOut)
			Return -1	
		End IF
	
NEXT

//Execute Immediate "COMMIT" using SQLCA; 4/2020 - MikeA - DE15499
commit using sqlca;

Return 1
end function

public function integer uf_process_inv_type_update (string asproject);
//    Dhirendra-  S57452  KDO - Kendo:  SIMS New Inventory Type, update process and messages -Start
Datastore	ldsImport, ldsContent
String	lsLogOut, lsTONO, lsWarehouse, lsWarehousePrev, lsSKU, lsSKUPrev, lsLot, lsOldInvType,  lsNewInvType,lsSuppCode, lsFilter,	&
		lsType, lsSerial, lsPO, lsPO2,ls_Container_ID, lsLoc, lsRefType, lsRefLineNumber, lsRefID, lsErrText,ls_sku_check
Integer	liRC, liRtnImp
Long	llRowPos, llRowCount, llCount, llContentCount, llContentPos, ll_Owner,ll_currentrow,ll_adjust_no
Decimal ldQtyToAdjust,ld_avail_qty,ld_qty =0.0000
Boolean	lbError
DateTime	ldtToday, ldt_Expiration_Date
String ls_project,ls_sku,ls_suppcode,ls_coo,ls_whcode,ls_lcode,ls_serial,ls_lot,ls_rono, & 
ls_container,ls_oldinvt_type,ls_invtype,ls_pono,ls_pono2,ls_adjsment_type
long  ll_ownerid,rtn
ldsContent = Create Datastore
ldsContent.dataobject = 'd_content_specific_inv_type'
ldsContent.SetTransObject(SQLCA)

	lsLogOut = '     -  Processing for kendo inventory type update' 
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

       IF Upper(asproject) = 'KENDO' Then
          llRowCount = ldsContent.retrieve()
			 If llRowCount = 0 Then
				lsLogOut = '      - No records loaded for processing for kendo inventory type update' 
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				Return 0
			End If


   For ll_currentrow = 1 to llRowCount
    
	    ls_invtype = ldsContent.getitemstring(ll_currentrow,'Content_inventory_type')
	    ldtToday =ldsContent.getitemdatetime(ll_currentrow,'date_1')
	    ldt_Expiration_Date= ldsContent.getitemdatetime(ll_currentrow,'Content_Expiration_Date')
	    ls_project =ldsContent.getitemstring(ll_currentrow,'Content_Project_Id')	 
		ls_sku=ldsContent.getitemstring(ll_currentrow,'Content_SKU')	
		ls_suppcode=ldsContent.getitemstring(ll_currentrow,'Content_Supp_Code')	
		ll_ownerid=ldsContent.getitemnumber(ll_currentrow,'Content_Owner_Id')	
		ls_coo=ldsContent.getitemstring(ll_currentrow,'Content_Country_of_origin')	
		ls_whcode=ldsContent.getitemstring(ll_currentrow,'Content_WH_Code')	
		ls_lcode=ldsContent.getitemstring(ll_currentrow,'Content_L_code')	
		ls_serial=ldsContent.getitemstring(ll_currentrow,'Content_Serial_No')	
		ls_lot=ldsContent.getitemstring(ll_currentrow,'Content_Lot_No')	
		ls_rono=ldsContent.getitemstring(ll_currentrow,'Content_Ro_No')	
		ls_pono=ldsContent.getitemstring(ll_currentrow,'Content_Po_No')	
		ls_pono2=ldsContent.getitemstring(ll_currentrow,'Content_Po_No2')	
		ldQtyToAdjust=ldsContent.getitemdecimal(ll_currentrow,'Content_Avail_Qty')	
		ls_container=ldsContent.getitemstring(ll_currentrow,'Content_Container_id')
		
		
		// Modified existing code by Dhirendra to prevent inserting duplicate row in content table -Start 
		
		IF ldt_Expiration_Date <  ldtToday    Then 
				
				ls_oldinvt_type = ls_invtype
				ls_invtype ='E'
				
				 Select Avail_Qty, sku into :ld_Avail_qty , :ls_sku_check
			      from content with(nolock)
			      where project_id = :ls_project and sku =:ls_sku and supp_code = :ls_suppcode 
	     		 and owner_id= :ll_ownerid and Country_of_origin =:ls_coo and wh_code=:ls_whcode 
			      and L_code= :ls_lcode and inventory_type =:ls_invtype and serial_no = :ls_serial and lot_no = :ls_lot and ro_no= :ls_rono 
			      and po_no= :ls_pono and po_no2= :ls_pono2 and Container_id = :ls_container and Expiration_Date= :ldt_Expiration_Date 
	               using sqlca;
				
				 IF isnull(ls_sku_check) or ls_sku_check = '' then
				     ldsContent.setitem(ll_currentrow,'Content_inventory_type' ,ls_invtype)
				else  
					ldsContent.setitem(ll_currentrow,'Content_Avail_qty' ,0.0000)
					
					update content
					Set   Avail_Qty = :ldQtyToAdjust + :ld_Avail_qty 
				     Where project_id = :ls_project and sku =:ls_sku and supp_code = :ls_suppcode 
			          and owner_id= :ll_ownerid and Country_of_origin =:ls_coo and wh_code=:ls_whcode 
			          and L_code= :ls_lcode and inventory_type =:ls_invtype and serial_no = :ls_serial and lot_no = :ls_lot and ro_no= :ls_rono 
			          and po_no= :ls_pono and po_no2= :ls_pono2 and Container_id = :ls_container and Expiration_Date= :ldt_Expiration_Date 
	                   using sqlca;
					
				end if 
			else
				
				ls_oldinvt_type = ls_invtype
				ls_invtype ='6'
				Select Avail_Qty, sku into :ld_Avail_qty , :ls_sku_check
			      from content with(nolock)
			      where project_id = :ls_project and sku =:ls_sku and supp_code = :ls_suppcode 
	     		 and owner_id= :ll_ownerid and Country_of_origin =:ls_coo and wh_code=:ls_whcode 
			      and L_code= :ls_lcode and inventory_type =:ls_invtype and serial_no = :ls_serial and lot_no = :ls_lot and ro_no= :ls_rono 
			      and po_no= :ls_pono and po_no2= :ls_pono2 and Container_id = :ls_container and Expiration_Date= :ldt_Expiration_Date 
	               using sqlca;
				
				IF  isnull(ls_sku_check) or ls_sku_check = '' then
						ldsContent.setitem(ll_currentrow,'Content_inventory_type' ,ls_invtype)
					else  
							ldsContent.setitem(ll_currentrow,'Content_Avail_qty' ,0.0000)
							update content
							Set   Avail_Qty = :ldQtyToAdjust + :ld_Avail_qty
				             Where project_id = :ls_project and sku =:ls_sku and supp_code = :ls_suppcode 
			                  and owner_id= :ll_ownerid and Country_of_origin =:ls_coo and wh_code=:ls_whcode 
			                 and L_code= :ls_lcode and inventory_type =:ls_invtype and serial_no = :ls_serial and lot_no = :ls_lot and ro_no= :ls_rono 
			                 and po_no= :ls_pono and po_no2= :ls_pono2 and Container_id = :ls_container and Expiration_Date= :ldt_Expiration_Date 
	                       using sqlca;
						end if 
					end if 
								// Dhirendra - END 
						 
	 INSERT INTO Adjustment  
         (  Project_Id,   
           SKU,   
           Supp_Code,   
           Owner_Id,
		  old_Owner,
           Country_Of_Origin,
		old_Country_Of_Origin,
           WH_Code,   
           L_Code,   
           Inventory_Type,   
		 Old_Inventory_Type, 
           Serial_No,   
           Lot_No, 
		 old_lot_no,
           RO_No,   
           PO_No,
		 old_PO_No ,
           PO_No2, 
		 old_po_No2,
           Old_Quantity,   
           Quantity,   
          Container_Id,    
           Adjustment_Type,
		 Last_Update,
		 Last_User,
		Expiration_Date
		
		    )  
		VALUES ( 
          :asproject,   
          :ls_sku,   
          :ls_suppcode,
		 : ll_ownerid,
		 :ll_ownerid,
		  :ls_coo   ,
		 : ls_coo,
          :ls_whcode,   
          :ls_lcode,  
	     :ls_invtype,
		 :ls_oldinvt_type,
          :ls_serial,  
		 :ls_lot,
	     :ls_lot,
          :ls_rono,
		 :ls_pono,
		: ls_pono,
		 :ls_pono2,
		  :ls_pono2,
		  :ldQtyToAdjust,
		 :ldQtyToAdjust,   
		 :ls_container, 
		'I',
		 :ldtToday,
	//	 :ldtToday,
		 'Sweeper',
		 :ldt_Expiration_Date
      ) using sqlca ; 
				
	IF sqlca.SqlCode < 0 Then
			lsErrText = sqlca.SqlErrText
			Rollback;
			lsLogOut = "-       ***Unable to create Adjustment record for kendo inventory type update : " + lsErrText
		//	FileWrite(giLogFileNo,lsLogOut)
//			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		    Return -1
		End If
		
		

    Select Max(Adjust_no) into :ll_adjust_no
	 From Adjustment
     Where project_id = :asproject and ro_no = :ls_rono and sku = :ls_Sku and supp_code = :ls_suppcode using sqlca;//and last_user = :gs_userid;
          
If sqlca.SqlCode < 0 Then
	lsErrText = sqlca.SqlErrText
		Rollback;
		lsLogOut = "-       ***Unable to create Adjustment record for kendo inventory type update: " + lsErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		Return -1
	End If
			  
	 INSERT INTO Batch_Transaction  
         (  
           Project_Id,   
           Trans_Type,   
           Trans_Order_Id,   
           Trans_Status,   
           Trans_Create_Date  
           )  
  VALUES
         (  
          :asproject,   
           'MM',   
           :ll_adjust_no,   
           'N',   
            :ldtToday     
            )  using sqlca ;
    

	 setnull(ld_Avail_qty)
	 setnull(ls_invtype)
	 setnull(ldQtyToAdjust)
	
If sqlca.SqlCode < 0 Then
			
			lsErrText = sqlca.SqlErrText
			Rollback;
			lsLogOut = "-       ***Unable to create Btach Transaction record for kendo inventory type update: " + lsErrText
			FileWrite(giLogFileNo,lsLogOut)
	     	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			Return -1
			
		End If
		
		rtn = ldsContent.update() 
		IF rtn <> 1 Then
			ROLLBACK ;
			lsLogOut = "-       ***Unable to update Content record for kendo inventory type update: " + lsErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			Return -1
		END IF
	next
end if 
return  0

//    Dhirendra-  S57452  KDO - Kendo:  SIMS New Inventory Type, update process and messages -End 

end function

on u_nvo_proc_kendo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_kendo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

