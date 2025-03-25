$PBExportHeader$u_nvo_proc_nyx.sru
forward
global type u_nvo_proc_nyx from nonvisualobject
end type
end forward

global type u_nvo_proc_nyx from nonvisualobject
end type
global u_nvo_proc_nyx u_nvo_proc_nyx

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 

end prototypes

type variables

string lsDelimitChar


u_nvo_proc_baseline_unicode 	iu_nvo_proc_baseline_unicode
end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_replace_quote (ref string as_string)
public function integer uf_process_dboh (string asproject, string asinifile)
public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_startuserfield, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow)
public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow)
public function integer uf_process_purchase_order (string aspath, string asproject)
public function integer uf_process_itemmaster (string aspath, string asproject)
public function integer uf_process_adjustment (string aspath, string asproject)
protected function integer uf_process_delivery_order (string aspath, string asproject)
public function integer uf_process_dboh_kits (string asproject, string asinifile)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut,	&
			lsSaveFileName, &
			lsPOLineCountFileName
			
Integer	liRC
integer 	liLoadRet, liProcessRet
Boolean	bRet

u_nvo_proc_baseline_unicode		lu_nvo_proc_baseline_unicode

Choose Case Upper(Left(asFile,2))
		
	Case  'PM'  
		
		// 08/13 - PCONKL - Now calling custom PO load
		//lu_nvo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode	
		
		liRC = uf_process_purchase_order(asPath, asProject)
		
	
		//Process any added PO's
		//We need to change to project. This will be changed after testing.
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject)  //asProject
		
		

	Case  'DM'  
		
		liLoadRet = uf_process_delivery_order(asPath, asProject)
			
		//Process any added SO's
		liProcessRet = gu_nvo_process_files.uf_process_Delivery_order( asProject )
		
		
		if liLoadRet = -1 OR liProcessRet = -1 then liRC = -1 else liRC = 0
		

//TAM 2016/01 Added an Adjustment Interface		
	Case  'SM'  
		
		liLoadRet = uf_process_adjustment(asPath, asProject)
			
		//Process any added SO's
//		liProcessRet = gu_nvo_process_files.uf_process_Delivery_order()
		
		
		if liLoadRet = -1  then liRC = -1 else liRC = 0
		

		
	Case 'IM'
		
		uf_process_itemmaster(asPath,asProject) //21-Oct-2013 :Madhu -created a new function same as baseline to process IM files.
		


	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
end function

public function integer uf_replace_quote (ref string as_string);string lsquote, lsreplace_with

lsquote = "'"
lsreplace_with = "~~~'"

long ll_start_pos, len_lsquote
ll_start_pos=1
len_lsquote = len(lsquote) 

//find the first occurrence of ls_quote... 
ll_start_pos = Pos(as_string ,lsquote,ll_start_pos) 

//only enter the loop if you find whats in lsquote
DO WHILE ll_start_pos > 0 
	 //replace llsquote with lsreplace_with ... 
	 as_string = Replace(as_string,ll_start_pos,Len_lsquote,lsreplace_with) 
	 //find the next occurrence of lsquote
	ll_start_pos = Pos(as_string,lsquote,ll_start_pos+Len(lsreplace_with)) 
LOOP 

return 0
end function

public function integer uf_process_dboh (string asproject, string asinifile);
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

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

String lsFileNamePath

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run


//Moved to Scheduled Activity Table


ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_nyx_dboh'
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile, asproject,"project","")

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

//GailM - 6/22/2015 - Set filter on BOH to remove warehouse NYX-AU

//TAM - 2016/01 - Ignore Inventory Type 'K'its
//ldsBOH.setfilter( "wh_code = 'NYX-NL' " )
ldsBOH.setfilter( "wh_code = 'NYX-NL' and inventory_type <> 'K' " )

ldsBOH.FILter( )

//Rowcount changes with filter
llRowCount = ldsBOH.RowCount()

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
	
	//Quantity	N(15,5)	Yes	N/A	Balance on hand
	
	long ll_Qty
	
	ll_Qty = ldsboh.GetItemNumber(llRowPos,'avail_qty')
	
	if ll_Qty < 0 then
		ll_Qty = 0
	end if

	lsOutString += string(ll_Qty) + lsDelimitChar

	//Quantity Allocated	N(15,5)	No	N/A	Allocated to Outbound Order

	ll_Qty = ldsboh.GetItemNumber(llRowPos,'alloc_qty')
	
	if ll_Qty < 0 then
		ll_Qty = 0
	end if	
	
	
	lsOutString += string(ll_Qty) + lsDelimitChar
	
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

	If string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'MM/DD/YYYY') <> "12/31/2999" and string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'MM/DD/YYYY') <> "01/01/1900" Then
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
		

	//BH016	Supp_Invoice_No				O	
	
	if IsNull(ldsboh.GetItemString(llRowPos,'Supp_Invoice_No')) OR Trim(ldsboh.GetItemString(llRowPos,'Supp_Invoice_No')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'Supp_Invoice_No')  + lsDelimitChar
	end if	

	//BH017	Lot controlled				O				
	
	if IsNull(ldsboh.GetItemString(llRowPos,'Lot_Controlled_Ind')) OR Trim(ldsboh.GetItemString(llRowPos,'Lot_Controlled_Ind')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'Lot_Controlled_Ind')  + lsDelimitChar
	end if		
	
	//BH018	Serial controlled				O	

	if IsNull(ldsboh.GetItemString(llRowPos,'Serialized_Ind')) OR Trim(ldsboh.GetItemString(llRowPos,'Serialized_Ind')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'Serialized_Ind')  + lsDelimitChar
	end if		

	//BH019	Country_of_origin				O	
	
	if IsNull(ldsboh.GetItemString(llRowPos,'Country_Of_Origin_Default')) OR Trim(ldsboh.GetItemString(llRowPos,'Country_Of_Origin_Default')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'Country_Of_Origin_Default')  + lsDelimitChar
	end if		
	
	//BH020	owner_id				O		
	
	if IsNull(ldsboh.GetItemNumber(llRowPos,'Owner_Id'))  then
//		lsOutString += lsDelimitChar
	else	
	   lsOutString += String(ldsboh.GetItemNumber(llRowPos,'Owner_Id')) // + lsDelimitChar
	end if	
	
	
//	BHYYMDD.dat
	
	lsFilename = ("BH" + string(today(), "YYMMDD") + lsWarehouse + ".dat")
	
	ldsOut.SetItem(llNewRow,'file_name', lsFilename)
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	
	if lsLastWarehouse <> lsWarehouse then

		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
		sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
		commit;
		
		If ldBatchSeq <= 0 Then
			lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' BOH confirmation."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			 Return -1
		End If
		
		lsLastWarehouse = lsWarehouse
		
	end if	
	
	
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
next /*next output record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(ldsOut,lsProject)

// TAM 2011/09  Added ability to email the report

lsFileNamePath = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + lsFileName  + ".txt"
gu_nvo_process_files.uf_send_email(lsProject,"BOHEMAIL", lsProject + " Daily Balance On Hand Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the BALANCE ON HAND REPORT run on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)


//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile, asproject,'DBOHFREQ','')
If isnumber(lsRunFreq) Then
	//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile, asproject,'DBOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile, asproject,'DBOHNEXTDATE','')
End If

Return 0
end function

public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_startuserfield, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow);
integer li_StartCol, li_UFIdx
string lsTemp	
	
 li_StartCol = al_StartImportColumnNumber

//Handle User Fields

For li_UFIdx = al_startuserfield to al_startuserfield + al_TotalUserFields - 1

	lsTemp = Trim(adw_ImportDW.GetItemString(adw_ImportDWCurrentRow, "col" + string(li_StartCol)))

//	Messagebox ("ok", lsTemp)

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		adw_DestDW.SetItem(adw_DestDWCurrentRow,'User_Field' + string(li_UFIdx), lsTemp)
	End If		

	li_StartCol = li_StartCol + 1
	
Next

RETURN 0
end function

public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow);
integer li_StartCol, li_UFIdx
string lsTemp	

	
 li_StartCol = al_StartImportColumnNumber

//Handle User Fields

For li_UFIdx = 1 to al_TotalUserFields

	lsTemp = Trim(adw_ImportDW.GetItemString(adw_ImportDWCurrentRow, "col" + string(li_StartCol)))

//	Messagebox ("ok", lsTemp)

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		adw_DestDW.SetItem(adw_DestDWCurrentRow,'User_Field' + string(li_UFIdx), lsTemp)
	End If		

	li_StartCol = li_StartCol + 1
	
Next

RETURN 0
end function

public function integer uf_process_purchase_order (string aspath, string asproject);
// 08/13 - PCONKL - Cloned from Load Purchase Order (PM) Transaction for Baseline Unicode Client

STRING lsTemp, lsProject, lsSku, lsSupplier, lsWarehouse, lsHeaderOrderNumber, lsDetailOrderNumber, lsConsolOrderNumber, lsOrderType, lsAWB, lsRONO, lsOrderSave
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo, llMaxLineNo
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow, liHeaderFind, liDetailFind
STRING lsLogOut, lsChangeID
INTEGER li_StartCol
INTEGER li_UFIdx
DECIMAL ldQuantity
STRING lsNull
STRING lsDefaultSupp_Code,lsAltSKU //19-Sep-2013 :Madhu Added lsAlt_SKU
INTEGER liSuppCount
BOOLEAN lbAttemptLoadDefaultSupp_Code = False

SetNull(lsNull)

u_ds_datastore	ldsPOHeader,	&
				     ldsPODetail, &
					 ldsImport

ldsPOheader = Create u_ds_datastore
ldsPOheader.dataobject= 'd_baseline_unicode_po_header'
ldsPOheader.SetTransObject(SQLCA)

ldsPOdetail = Create u_ds_datastore
ldsPOdetail.dataobject= 'd_baseline_unicode_po_detail'
ldsPOdetail.SetTransObject(SQLCA)

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Purchase Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Purchase Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

integer llFileRowPos
integer llFilerowCount

llFilerowCount = ldsImport.RowCount()

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Loop through

llFilerowCount = ldsImport.RowCount()

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Purchase Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))


	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“PM”	Purchase order master identifier
	//Record ID	C(2)	Yes	“PD”	Purchase order detail identifier

	//Validate Rec Type is PM OR PD
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
	If NOT (lsTemp = 'PM' OR lsTemp = 'PD') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If

	Choose Case Upper(lsTemp)
	
		//Purchase Order Master
	
		Case 'PM' /*PO Header*/

			//Change ID	C(1)	Yes	N/A	
				//A – Add
				//U – Update
				//D – Delete
				//X – Ignore (Add or update regardless)
				
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Change ID is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsChangeID = lsTemp
			End If		
			
			//Project ID	C(10)	Yes	N/A	Project identifier

			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsProject = lsTemp
			End If					
				
				
			//Warehouse	C(10)	Yes	N/A	Receiving Warehouse

			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col4")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Warehouse is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsWarehouse = lsTemp
			End If					
							
			
			//Order Number	C(30)	Yes	N/A	Purchase order number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsHeaderOrderNumber = lsTemp
			End If					
							
			//Order Type	C(1)	Yes	“S”	Must be valid order typr
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				lsTemp = "S"	
			Else
				lsOrderType = lsTemp
			End If					
				
				
			//Supplier Code	C(20)	Yes	N/A	Valid Supplier code

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				
				//Added so if Supplier Code is not set, then if there is only one supplier, it will use that one.
				
	
	
				IF NOT lbAttemptLoadDefaultSupp_Code THEN
					
					SELECT TOP 1 Count(Supp_Code), Supp_Code  INTO :liSuppCount, :lsDefaultSupp_Code From Supplier With (NoLock) WHERE project_id =  :lsproject GROUP BY Supp_Code;  
						
					IF liSuppCount > 1 then
						
					ELSE
						
						lsTemp = lsDefaultSupp_Code
						
					END IF
		
					lbAttemptLoadDefaultSupp_Code = True
					
				END IF
		
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then	
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsSupplier = lsTemp
				End If			
			Else
				lsSupplier = lsTemp
			End If			

			/* End Required */		
			
			liNewRow = 	ldsPOheader.InsertRow(0)
			llOrderSeq ++
			
			//TODO - This needs to be set from the highest existing line number if consolidating
			//llLineSeq = 0
			
			//New Record Defaults
			asProject = lsProject
			
			
			ldsPOheader.SetItem(liNewRow,'project_id',lsProject)
			ldsPOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
			ldsPOheader.SetItem(liNewRow,'Request_date',String(Today(),'YYMMDD'))
			ldsPOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPOheader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
			ldsPOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsPOheader.SetItem(liNewRow,'Status_cd','N')
			ldsPOheader.SetItem(liNewRow,'Last_user','SIMSEDI')

			ldsPOheader.SetItem(liNewRow,'Order_No',lsHeaderOrderNumber)			//May be the original order or a consolidated one
			ldsPOheader.SetItem(liNewRow,'Order_type',lsOrderType) /*Order Typer*/
			ldsPOheader.SetItem(liNewRow,'Inventory_Type','N') /*default to Normal*/
	
	
			ldsPOheader.SetItem(liNewRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsPOheader.SetItem(liNewRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			

				
			//Order Date	Date	No	N/A	Order Date
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
	
			if len(lsTemp) >= 8 then
				 lsTemp = left(lsTemp,4) + "/" + mid(lsTemp,5,2) + "/" +  mid(lsTemp,7,2)
				 ldsPOheader.SetItem( 1, "Ord_Date",lsTemp)
			end if 

			//Delivery Date	Date	No	N/A	Expected Delivery Date at Warehouse

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
			if len(lsTemp) >= 8 then
				 lsTemp = left(lsTemp,4) + "/" + mid(lsTemp,5,2) + "/" +  mid(lsTemp,7,2)
				 ldsPOheader.SetItem( 1, "arrival_date",lsTemp)
			end if 
			
			//Carrier	C(10)	No	N/A	Carrier
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Carrier',  lsTemp)
			End If				
			
			//Supplier Invoice Number	C(30)	No	N/A	Supplier Invoice Number

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Supp_Order_No', lsTemp)
			End If				
			
			//AWB #	C(20)	No	N?A	Airway Bill/Tracking Number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'AWB_BOL_No', lsTemp)
			End If				
			
			//Transport Mode	C(10)	No	N/A	Transportation mode to warehouse
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Transport_Mode', lsTemp)
			End If				
			
			//Remarks	C(250)	No	N/A	Freeform Remarks

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Remark', lsTemp)
			End If	

			//User Field1	C(10)	No	N/A	User Field
			//User Field2	C(10)	No	N/A	User Field
			//User Field3	C(10)	No	N/A	User Field
			//User Field4	C(20)	No	N/A	User Field
			//User Field5	C(20)	No	N/A	User Field
			//User Field6	C(20)	No	N/A	User Field
			//User Field7	C(30)	No	N/A	User Field
			//User Field8	C(30)	No	N/A	User Field
			//User Field9	C(255)	No	N/A	User Field
			//User Field10	C(255)	No	N/A	User Field
			//User Field11	C(255)	No	N/A	User Field
			//User Field12	C(255)	No	N/A	User Field
			//User Field13	C(255)	No	N/A	User Field
			//User Field14	C(255)	No	N/A	User Field, not viewable on screen
			//User Field15	C(255)	No	N/A	User Field, not viewable on screen
			//

			uf_process_userfields(15, 15, ldsImport, llFileRowPos, ldsPOheader, liNewRow)	

			//MEA - 4/12 - Added the Rcv Slip Nbr
			//GailM - 6/22/2015 - New requirement for NYX/L'Oreal.   supp_invoice_no --> ship_ref.  
			ldsPOHeader.SetItem(liNewRow,'ship_ref', lsHeaderOrderNumber)
			
			//lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col30"))
			//If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
			//	ldsPOheader.SetItem(liNewRow,'ship_ref', lsTemp)
			//End If	

			// 5/13/2015 - GailM - Adding named fields
               
			//Client_Cust_PO_NBR	C(255)	No	N/A	Client Customer PO Number
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col31"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Client_Cust_PO_NBR', lsTemp)
			End If				
			              
			//Client_Invoice_Nbr	C(255)	No	N/A	Client Invoice Number
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col32"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Client_Invoice_Nbr', lsTemp)
			End If				
			
			//Container_Nbr	C(255)	No	N/A	Container Number
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col33"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Container_Nbr', lsTemp)
			End If				
			
			//Client_Order_Type  	C(255)	No	N/A	Client Order Type
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col34"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Client_Order_Type', lsTemp)
			End If				
			
			//Container_Type 	C(255)	No	N/A	Container Type
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col35"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Container_Type', lsTemp)
			End If				
			
			//From_Wh_Loc	C(255)	No	N/A	Fram Warehouse Location
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col36"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'From_Wh_Loc', lsTemp)
			End If				
			
			//Seal_Nbr 	C(255)	No	N/A	Seal Number
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col37"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Seal_Nbr', lsTemp)
			End If				
			
			//Vendor_Invoice_Nbr 	C(255)	No	N/A	Vendor Invoice Number
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col38"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Vendor_Invoice_Nbr', lsTemp)
			End If				
			
			/****End of Named Fields *****/			


			//Note: 
			//
			//1.	A PO can only be deleted if no receipts have been generated against the PO.
			//2.	Deletion of a Purchase Order Master will also delete related purchase order details.
			//3.	Updated PO’s should include all of the information for the PO regardless of whether or not a specific item has been changed.
						


		//Purchase Order Detail				
				
		CASE 'PD' /* detail*/

			//Change ID	C(1)	Yes	N/A	
				//A – Add
				//U – Update
				//D – Delete

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Change ID is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsChangeID = lsTemp
			End If		
			
			//Project ID	C(10)	Yes	N/A	Project identifier
			
			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsProject = lsTemp
			End If									

			//Order Number	C(30)	Yes	N/A	Purchase order number

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
			lsDetailOrderNumber = lsTemp
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				
			
				//Make sure we have a header for this Detail...
				//If ldsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'",1, ldsPoHeader.RowCount()) = 0 Then
				If lsDetailOrderNumber <> lsHeaderOrderNumber Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
					lbError = True
					Continue
				End If
					
				
			End If			

				
			//Supplier Code	C(20)	Yes	N/A	Valid Supplier code

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSupplier = lsTemp
			End If			
				
			
			//Line Item Number	N(6,0)	Yes	N/A	Item number of purchase order document

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				llLineItemNo = Long(lsTemp)
			End If					
			
			//SKU	C(26)	Yes	N/A	Material number
			
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSku = lsTemp
			End If				
			
			//Quantity	N(15,5)	Yes	N/A	Purchase order quantity


			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				ldQuantity = Dec(lsTemp)
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
			
			ldsPODetail.SetItem(llNewDetailRow,'Order_No',lsDetailOrderNumber)		
			ldsPODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsPODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
			ldsPODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
		//	ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
			ldsPODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
			
			
			ldsPODetail.SetItem(llNewDetailRow,'User_Line_Item_No', string(llLineItemNo))
			ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No', llLineSeq)		
			
			
			//Inventory Type	C(1)	No	N/A	Inventory Type
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', lsTemp)
			End If	
			
			//Alternate SKU	C(50)	No	N/A	Supplier’s material number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
			
			//19-Sep-2013 :Madhu -Added code to get alt_sku from Item_Master -START
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku', lsTemp)
//			Else
//				ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku', lsNull)
//			End If	
			
			Select Alternate_SKU
			into :lsAltSKU
			From Item_MAster
			Where project_id = :lsProject and sku = :lsSKU and supp_code = :lsSupplier;
			
			If NOT(IsNull(lsAltSKU) OR trim(lsAltSKU) ='') Then
				ldsPODetail.SetItem( llNewDetailRow,'Alternate_Sku', lsAltSKU)
			Else
				ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku',lsNull)
			End If
			//19-Sep-2013 :Madhu -Added code to get alt_sku from Item_Master -END
			
			//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Lot_No', lsTemp)
			End If				
			
			//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'PO_No', lsTemp)
			End If	
			
			//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'PO_No2', lsTemp)
			End If	
			
			//Serial Number	C(50)	No	N/A	Qty must be 1 if present

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Serial_No', lsTemp)
			End If	
			
			//Expiration Date	Date	No	N/A	Product expiration Date
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
	
			if len(lsTemp) >= 8 then
				 lsTemp = left(lsTemp,4) + "/" + mid(lsTemp,5,2) + "/" +  mid(lsTemp,7,2)
				 ldsPODetail.SetItem( 1, "Expiration_Date", datetime(lsTemp))
			end if 
			
			//Customer  Line Item Number 	C(25)	No	N/A	Customer  Line Item Number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
			
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
// TAM 2012/07 Remove line item number from populating from field 16.  It is populated by field 6 above
//				ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No', long(lsTemp))
				ldsPODetail.SetItem(llNewDetailRow,'User_Line_Item_No', lsTemp)// TAM 7/11/2012 Populate the user_line_item_no from field 16
			End If			
			


			

		
			//User Field1	C(50)	No	N/A	User Field
			//User Field2	C(50)	No	N/A	User Field
			//User Field3	C(50)	No	N/A	User Field
			//User Field4	C(50)	No	N/A	User Field
			//User Field5	C(50)	No	N/A	User Field
			//User Field6	C(50)	No	N/A	User Field
			
			uf_process_userfields(17, 6, ldsImport, llFileRowPos, ldsPODetail, llNewDetailRow)	

			// 08/13 - Pconkl - Need to store the original Physio Order Numebr in UF3 so that we can send it back in GR, may be aready stored above
			If ldsPODetail.GetItemString(llNewDetailRow,'User_Field3') = '' or isNull(ldsPODetail.GetItemString(llNewDetailRow,'User_Field3')) Then
				ldsPODetail.SetItem(llNewDetailRow,'User_Field3', lsDetailOrderNumber)	
			End If
				
			//Country Of Origin
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col23"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Country_of_Origin', lsTemp)
			End If			
							
			//UnitOfMeasure
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col24"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'uom', lsTemp)
			End If		
			
			// 5/13/2015 - GailM - Adding named fields

			//Currency_Code	C(50)	No	N/A	Currency Code
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col25"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Currency_Code', lsTemp)
			End If		
			
			//Supplier_Order_Number r	C(50)	No	N/A	Supplier Order Number
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col26"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Supplier_Order_Number', lsTemp)
			End If		
			
			//Cust_PO_Nbr 	C(50)	No	N/A	Customer PO Number
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col27"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Cust_PO_Nbr', lsTemp)
			End If		
			
			//Line_Container_Nbr	C(50)	No	N/A	Line Container Number
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col28"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Line_Container_Nbr', lsTemp)
			End If		
			
			//Vendor_Line_Nbr 	C(50)	No	N/A	Vendor Line Number
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col29"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Vendor_Line_Nbr', lsTemp)
			End If		
			
			//Client_Line_Nbr 	C(50)	No	N/A	Client Line Number
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col30"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Client_Line_Nbr', lsTemp)
			End If		
			
			//Client_Cust_PO_NBR	C(50)	No	N/A	Client Customer PO Number
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col31"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Client_Cust_PO_NBR', lsTemp)
			End If		
			
			/****End of Named Fields *****/			
				
			//
			//Note: 
			//
			
				
			//1.	PO item can only be deleted if there are no receipts for the line item.
			//2.	PO Qty can not be reduced below that which has already been received.
			//

			
		CASE Else /* Invalid Rec Type*/
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			Continue
		
	End Choose /*record Type*/
	
Next /*File record */
	
////Line Item Numbers may be duplicated if orders combined but not sequential in file
//ldsPoDetail.SetSort("order_no A")
//ldsPoDetail.Sort()
//
//llFileRowCount = ldsPoDetail.RowCount()
//for llFileRowPos = 1 to llFilerowCount
//	
//	lsDetailOrderNumber = ldsPoDetail.GetITemString(llFileRowPos,'order_no')
//	If lsDetailOrderNumber <> lsOrderSave Then
//		llLineSeq = 1
//	Else
//		llLineSeq ++
//	End If
//	
//	lsOrderSave = lsDetailOrderNumber
//		
//	ldsPODetail.SetItem(llFileRowPos,'Line_Item_No', llLineSeq)		
//	ldsPODetail.SetItem(llFileRowPos,"order_line_no",string(llLineSeq))
//	
//next

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

public function integer uf_process_itemmaster (string aspath, string asproject);
//Process Item Master (IM) Transaction for Baseline Unicode Client

STRING lsTemp, lsProject, lsSku, lsSupplier
BOOLEAN lbError, lbNew
LONG llCount, llNew, llNewRow, llOwner, llexist
INTEGER lirc, liRtnImp
STRING lsLogOut
u_ds_datastore	ldsImport

//Item Master

u_ds_datastore	ldsItem 

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_baseline_unicode_item_master'
ldsItem.SetTransObject(SQLCA)

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

//Convert to Chinese - CodePage

integer li_row_idx, li_col_idx 
string lsdata, lsConvData

//for li_row_idx =1 to ldsImport.RowCount()
//
//	for li_col_idx = 1 to 75
//		
//		lsData = ldsImport.GetItemString(li_row_idx, "col" + string(li_col_idx))
//		
//		// Convert utf-8 to utf-16 
//		// Return the numbers of Wide Chars 
//		liRC = MultiByteToWideChar(65001, 0, lsData, -1, lblb_wide_chars, 0) 
//		IF liRC > 0 THEN 
//			
//				// Reserve Unicode Chars 
//				lblb_wide_chars = blob( space( (liRC+1)*2 ) ) 
//		
//				// Convert UTF-8 to UTF-16 
//				liRC = MultiByteToWideChar(65001, 0, lsData, -1, lblb_wide_chars, (liRC+1)*2 ) 
//		
//				// Convert UTF-16 to ANSI 
//				lsConvData = FromUnicode( lblb_wide_chars )         
//				
//		
//		END IF 
//		
////		lsConvData = String(lblb_wide_chars)
//		
//		if li_col_idx = 46 then 
//			Messagebox ("Error", lsData)		
//			Messagebox ("Error", lsConvData)
//			
//		end if
//		
//		if lsDAta <> lsConvData then
//			
//			ldsImport.SetItem(li_row_idx, "col" + string(li_col_idx), lsConvData)
//			
//		end if
//		
//	Next
//Next


if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Item Master File for '+asproject+' Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

integer llFileRowPos
integer llFilerowCount

llFilerowCount = ldsImport.RowCount()

//Loop through

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCount))

	//Field Name	Type	Req.	Default	Description
	//Record ID	C(2)	Yes	“IM”	Item Master Identifier

	//Validate Rec Type is IM
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
	If lsTemp <> 'IM' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If

	//Project ID	C(10)	Yes	N/A	Project identifier
	
	lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col2")))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		lsProject = lsTemp
	End If	
	
	//SKU	C(50)	Yes	N/A	Material number

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		lsSku = lsTemp
	End If	


	//Supplier Code	C(20)	Yes	N/A	Valid Supplier code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		lsSupplier = lsTemp
	End If	

	////Retrieve for SKU - We will be updating across Suppliers

	llCount = ldsItem.Retrieve(lsProject, lsSKU, lsSupplier)
	
	llCount = ldsItem.RowCount()

	If llCount <= 0 Then

		llNew ++ /*add to new count*/
		lbNew = True
		llNewRow = ldsItem.InsertRow(0)

		ldsItem.SetItem(1,'SKU',lsSKU)
		ldsItem.SetItem(1,'project_id', lsProject)		
		
		//Get Default owner for Supplier
		Select owner_id into :llOwner
		From Owner
		Where project_id = :lsProject and Owner_type = 'S' and owner_cd = :lsSupplier;
		
		
		If IsNull(llOwner) OR llOwner <= 0  Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Owner for Supplier ("+lsSupplier+") not found in database.")
			lbError = True
			Continue			
		End If
		
		ldsItem.SetItem(1,'supp_code',lsSupplier)
		ldsItem.SetItem(1,'owner_id',llOwner)
							
	Else /*exists*/		
		llexist += llCount /*add to existing Count*/
		lbNew = False
	End If
	
	//COO	C(3)	No	N/A	Default Country of Origin
	//Validate COO if present, otherwise Default to XXX
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then

		If f_get_Country_name(lsTemp) <= ' ' Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Country of Origin: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue /*Process Next Record */
		Else		
			ldsItem.SetItem(1,'Country_of_Origin_Default', lsTemp)
		End If
		
	Else
		//Set Default to 'XXX'
		ldsItem.SetItem(1,'Country_of_Origin_Default', 'XXX')   
	End If				

	
	//Description	C(70)	Yes	N/A	Item description

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Description is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		ldsItem.SetItem(1,'description', lsTemp)
	End If	

	//Standard Cost	N(17)	No	 N/A   Standard Cost

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		ldsItem.SetItem(1,'strd_cost', 0.0)
	Else
		ldsItem.SetItem(1,'std_cost', Dec(lsTemp))
	End If	
	

	//Standard Cost Old	N(17)	No	 N/A   Standard Cost Old

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		ldsItem.SetItem(1,'std_cost_old', 0.0)
	Else
		ldsItem.SetItem(1,'std_cost_old', Dec(lsTemp))
	End If	

	//Average Cost	N(17)	No	 N/A   Average Cost

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		ldsItem.SetItem(1,'avg_cost', 0.0)
	Else
		ldsItem.SetItem(1,'avg_cost', Dec(lsTemp))
	End If	

	//UOM1	C(4)	No	“EA”	Base unit of measure - NYX base unit is UN 

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		lsTemp = "UN"
	End If	
	
	ldsItem.SetItem(1,'uom_1', lsTemp)
	
	//Length1	N(9,2)	No	N/A	Item Length
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Length_1', Dec(lsTemp))
	End If	
	
	//Width1	N(9,2)	No	N/A	Item Width
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Width_1', Dec(lsTemp))
	End If		
	
	//Height1 	N(9,2)	No	N/A	Item Height
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Height_1', Dec(lsTemp))
	End If		
	
	//Weight1	N(11,5)	No	N/A	Net weight of base unit of measure (kg)

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Weight_1', Dec(lsTemp))
	End If			
	
	//UOM2	C(4)	No	N/A	Level 2 unit of measure
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'UOM_2', lsTemp)
	End If			
	
	//Length2	N(9,2)	No	N/A	Item Length
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Length_2', Dec(lsTemp))
	End If			
	
	//Width2	N(9,2)	No	N/A	Item Width

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Width_2', Dec(lsTemp))
	End If		
	
	//Height2 	N(9,2)	No	N/A	Item Height
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col18"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Height_2', Dec(lsTemp))
	End If			
	
	//Weight2	N(11,5)	No	N/A	Net weight of base unit of measure (kg)
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col19"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Weight_2', Dec(lsTemp))
	End If			
	
	//Qty 2	N(15,5)	No	N/A	Level 2 Qty in relation to base UOM
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col20"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Qty_2', Dec(lsTemp))
	End If			
	
	
	//UOM3	C(4)	No	N/A	Level 3 unit of measure
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col21"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'UOM_3', lsTemp)
	End If			
	
	//Length3	N(9,2)	No	N/A	Item Length
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col22"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Length_3', Dec(lsTemp))
	End If		
	
	//Width3	N(9,2)	No	N/A	Item Width
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col23"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Width_3', Dec(lsTemp))
	End If			
	
	//Height3	N(9,2)	No	N/A	Item Height

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col24"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Height_3', Dec(lsTemp))
	End If			
	
	//Weight3	N(11,5)	No	N/A	Net weight of base unit of measure (kg)
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col25"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Weight_3', Dec(lsTemp))
	End If				
	
	//Qty 3	N(15,5)	No	N/A	Level 3 Qty in relation to Base UOM

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col26"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Qty_3', Dec(lsTemp))
	End If				

	//UOM4	C(4)	No	N/A	Base unit of measure

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col27"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'UOM_4', lsTemp)
	End If			
	
	//Length4	N(9,2)	No	N/A	Item Length
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col28"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Length_4', Dec(lsTemp))
	End If			
	
	//Width4	N(9,2)	No	N/A	Item Width

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col29"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Width_4', Dec(lsTemp))
	End If			
	
	
	//Height4	N(9,2)	No	N/A	Item Height

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col30"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Height_4', Dec(lsTemp))
	End If			

	
	//Weight4	N(11,5)	No	N/A	Net weight of base unit of measure (kg)

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col31"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Weight_4', Dec(lsTemp))
	End If			
	
	//Qty 4	N(15,5)	No	N/A	Level 4 Qty in relation to Base UOM

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col32"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Qty_4', Dec(lsTemp))
	End If			

	//CC Frequency	N(5,0)	No	N/A	Cycle count frequency (in days)

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col33"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'CC_Freq', Dec(lsTemp))
	End If			

	//CC Trigger Qty	N(7,0)	No	N/A	Cycle count Trigger Quantity

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col34"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'CC_Trigger_Qty', Dec(lsTemp))
	End If		
	
	//Shelf Life	N(5)	No	N/A	Shelf life in Days

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col35"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Shelf_Life', Dec(lsTemp))
	End If			
	
	//HS Code	C(15)	No	N/A	HS Code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col36"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'HS_Code', lsTemp)
	End If	
	
	//grp	C(10)	No	N/A	Item Master Group

	SetNull(lsTemp) 	// NYX/L'Oreal has elected to not use the item group when moving to SAP.

	//lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col46"))
	//If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'grp', lsTemp)
	//End If				
	
	//Packaged Weight	N(9)	No	N/A	Packaged Weght

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col47"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'packaged_weight', Dec(lsTemp))
	End If				
	
	//Unpackaged Weight	N(9)	No	N/A	Unpackaged Weght

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col48"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Unpackaged_Weight', Dec(lsTemp))
	End If				
	
	//Alternate SKU	C(50)	No	N/A	Alternate/Customer SKU

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col49"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Alternate_SKU', lsTemp)
	End If				
	
	//Alternate Price	N(9)	No	N/A	Alternate Price

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col50"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Alternate_price', Dec(lsTemp))
	End If				
	
	//Inventory Tracking field 1 (Lot) Controlled	C(1)	No	N/A	Inventory Tracking field 1 (Lot) Controlled Indicator

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col51"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Lot_Controlled_Ind', lsTemp)
	End If		
	
	//Inventory Tracking field 2 (PO) Controlled	C(1)	No	N/A	Inventory Tracking field 2 (PO) Controlled Indicator

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col52"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'PO_Controlled_Ind', lsTemp)
	End If			
	
	//Inventory Tracking field 3 (PO2) Controlled	C(1)	No	N/A	Inventory Tracking field 3 (PO2) Controlled Indicator

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col53"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'PO_NO2_Controlled_Ind', lsTemp)
	End If			
	
	//Serialized Indicator	C(1)	No	N/A	Serialized Indicator
		//N = not serialized
		//B	 = capture serial # at receipt and when shipped but don’t track in inventory
		//O = capture serial # only when shipped
		//Y	 = capture serial # at receipt, track in inventory and when shipped
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col54"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Serialized_Ind', lsTemp)
	End If			

	//Component Indicator	A(1)	No	N/A	Component Indication

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col55"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'component_ind', lsTemp)
	End If			
	
	//Standard of Measure	A(1)	No	N/A	Standard of Measure

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col56"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Standard_of_Measure', lsTemp)
	Else
		ldsItem.SetItem(1,'Standard_of_Measure', "E")	//Default
	End If			
	
	//item_delete_ind	A(1)	No	N/A	Item Delete Indicator
		//If delete flag is set for “Y”, the item will not be available for further transactions.  If delete flag is set for “Y” and no warehouse transaction exist, the record will be physically deleted from database.   (In-Active Flag)

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col57"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'item_delete_ind', lsTemp)
	Else
		ldsItem.SetItem(1,'item_delete_ind', "V")	//Default
	End If			
	
	//Last Cycle Count Date	A(20)	No	N/A	Last Cycle Count Date

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col58"))
	
	if len(lsTemp) >= 8 then
		 lsTemp = left(lsTemp,4) + "/" + mid(lsTemp,5,2) + "/" +  mid(lsTemp,7,2)
		 ldsItem.SetItem( 1, "last_cycle_cnt_date", datetime(lsTemp))
	end if 
	
	//Hazard Text Code	A(8)	No	N/A	Hazard Text Code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col59"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'hazard_text_cd', lsTemp)
	End If			
	
	//Hazard Code	A(6)	No	N/A	Hazard Code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col60"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'hazard_cd', lsTemp)
	End If			
	
	//Hazard Class	A(10)	No	N/A	Hazard Class

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col61"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'hazard_class', lsTemp)
	End If			
	
	//Flash Point	N(3)	No	N/A	Flash Point

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col62"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'flash_point', Dec(lsTemp))
	End If			
	
	//Expiration Date Controlled	C(1)	No	N/A	Expiration Date Controlled indicator
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col63"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'expiration_controlled_ind', lsTemp)
	End If		
	
	//Inventory Class	C(10)	No	N/A	Inventory Class

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col64"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'inventory_class', lsTemp)
	End If			
	
	//Storage Code	C(10)	No	N/A	Storage Code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col65"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'storage_code', lsTemp)
	End If			
	
	//Container Tracking Indicator	C(1)	No	N/A	Container Tracking Indicator

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col66"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'container_tracking_ind', lsTemp)
	End If	
	
	//Freight Class	C(10)	No	N/A	Freight Class

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col67"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Freight_Class', lsTemp)
	End If			

	//UPC Code	C(14)	No	N/A	UPC Code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col68"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		If IsNumber(lsTemp) Then
			ldsItem.SetItem(1,'Part_UPC_Code', Dec(lsTemp))
		End If
	End If			
	
	//Expiration Tracking Type	C(1)	No	“N”	Expiration Tracking Type
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col69"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'expiration_tracking_type', lsTemp)
	End If		

	//Component Type		C(1)	No	“N”	Component Type
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col70"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'component_type', lsTemp)
	End If		

	//Marl Change Date	C(20)	No	“N”	Marl Change Date
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col82"))

	if len(lsTemp) >= 8 then
		 lsTemp = left(lsTemp,4) + "/" + mid(lsTemp,5,2) + "/" +  mid(lsTemp,7,2)
		 ldsItem.SetItem( 1, "marl_change_date", datetime(lsTemp))
	end if 

	//Quality Hold Change Date	C(20)	No	“N”	Quality Hold Change Date
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col83"))

	if len(lsTemp) >= 8 then
		 lsTemp = left(lsTemp,4) + "/" + mid(lsTemp,5,2) + "/" +  mid(lsTemp,7,2)
		 ldsItem.SetItem( 1, "quality_hold_change_date", datetime(lsTemp))
	end if 

	//QA Check indicator	C(1)	No	“N”	QA Check indicator
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col84"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'qa_check_ind', lsTemp)
	End If		

	//CC Group Code	C(1)	No	“N”	CC Group Code
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col85"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'cc_group_code', lsTemp)
	End If		

	//CC Class Code	C(1)	No	“N”	CC Class Code
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col86"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'cc_class_code', lsTemp)
	End If		

	//Last cycle count number	C(16)	No	“N”	Last cycle count number
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col87"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'last_cc_no', lsTemp)
	End If		
	
	//Interface Update Required Indicator 	C(16)	No	“N”	Interface Update Required Indicator
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col88"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'interface_upd_req_ind', lsTemp)
	End If		

	//DWG Upload	C(1)	No	“N”	DWG Upload
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col89"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'dwg_upload', lsTemp)
	End If		

	//DWG Upload Timestamp	C(20)	No	“N”	DWG Upload Timestamp
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col90"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'dwg_upload', lsTemp)
	End If		
	
 	//Native Description	C(75)	No	N/A	Foreign language Description

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col91"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Native_Description', lsTemp)
	End If		

 	//Number of children for parenet	N(3)  No	N/A	Number of children for parenet

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col92"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'no_of_children_for_parent', Dec(lsTemp))
	End If 
	
	// Added Named Fields
 	//Age				N(3)		No	N/A			Age

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col93"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		If IsNumber(lsTemp) Then
			ldsItem.SetItem(1,'age', Dec(lsTemp))
		End If
	End If		

 	//Brand				C(40)		No	N/A			Brand

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col94"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'brand', lsTemp)
	End If		

 	//Color				C(20)		No	N/A			Color

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col95"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'color', lsTemp)
	End If		

 	//Color Description				C(40)		No	N/A			Color Description

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col96"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Color_Desc', lsTemp)
	End If		

 	//Gender			C(10)		No	N/A			Gender

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col97"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'gender', lsTemp)
	End If		

 	//Material Number		C(10)		No	N/A			Material Number	

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col98"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'material_nbr', lsTemp)
	End If		

 	//Pridyct Attribute		C(40)		No	N/A			Product Attribute	

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col99"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'product_attribute', lsTemp)
	End If		

 	//Season Code		C(20)		No	N/A			Season Code	

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col100"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'season_code', lsTemp)
	End If		

 	//Size		C(20)		No	N/A			Size	

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col101"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'size', lsTemp)
	End If		

 	//Style		C(20)		No	N/A			Style	

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col102"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'style', lsTemp)
	End If		

 	//Commodity Rail		C(20)		No	N/A			Commodity Rail		

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col103"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'commodity_rail', lsTemp)
	End If		

 	//Commodity Airl		C(20)		No	N/A			Commodity Air	

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col104"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'commodity_air', lsTemp)
	End If		

 	//Commodity Motor		C(20)		No	N/A			Commodity Motor	

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col105"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'commodity_motor', lsTemp)
	End If		

 	//Distribution channel		C(20)		No	N/A			Distribution channel

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col106"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'dist_channel', lsTemp)
	End If		

  	//ECCB		C(20)		No	N/A			ECCN

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col107"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'eccn', lsTemp)
	End If		

  	//Interpack Quantity		N(20)		No	N/A			Interpack Quantity

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col108"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		If IsNumber(lsTemp) Then
			ldsItem.SetItem(1,'interpack_qty', Dec(lsTemp))
		End If
	End If		

   	//UPC Code2		C(50)		No	N/A			UPC Code2

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col109"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'upc_code2', lsTemp)
	End If		

   	//UPC Code3		C(50)		No	N/A			UPC Code3

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col110"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'upc_code3', lsTemp)
	End If		

   	//UPC Code4		C(50)		No	N/A			UPC Code4

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col111"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'upc_code4', lsTemp)
	End If		

   	//Stackable		C(1)	No	N/A			Stackagle

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col112"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'stackable', lsTemp)
	End If		

   	//Stackable Height		N(10)		No	N/A			Stackable Height

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col113"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		If IsNumber(lsTemp) Then
			ldsItem.SetItem(1,'stackable_height', Dec(lsTemp))
		End If
	End If		
	
	//Handle User Fields

	//User Field1	C(10)	No	N/A	User Field
	//User Field2	C(10)	No	N/A	User Field
	//User Field3	C(10)	No	N/A	User Field
	//User Field4	C(10)	No	N/A	User Field
	//User Field5	C(10)	No	N/A	User Field
	//User Field6	C(20)	No	N/A	User Field
	//User Field7	C(20)	No	N/A	User Field
	//User Field8	C(30)	No	N/A	User Field
	//User Field9	C(30)	No	N/A	User Field
	//User Field10	C(30)	No	N/A	User Field
	//User Field11	C(30)	No	N/A	User Field
	//User Field12	C(30)	No	N/A	User Field
	//User Field13	C(30)	No	N/A	User Field
	//User Field14	C(70)	No	N/A	User Field
	//User Field15	C(70)	No	N/A	User Field
	//User Field16	C(70)	No	N/A	User Field
	//User Field17	C(70)	No	N/A	User Field
	//User Field18	C(70)	No	N/A	User Field
	//User Field19	C(70)	No	N/A	User Field
	//User Field20	C(70)	No	N/A	User Field
	
	//uf_process_userfields(47, 20, ldsImport, llFileRowPos, ldsItem, 1)	
	
	uf_process_userfields(37, 1,  9, ldsImport, llFileRowPos, ldsItem, 1)
	
	uf_process_userfields(71, 10, 11, ldsImport, llFileRowPos, ldsItem, 1)
	
	ldsItem.SetItem(1,'Last_user','SIMSFP')
	ldsItem.SetItem(1,'last_update',today())	
		
//Note: 
//
//1.	If delete flag is set for “Y”, the item will not be available for further transactions.
//2.	If delete flag is set for “Y” and no warehouse transaction exist, the record will be physically deleted from database.

	//Save New Item to DB
	SQLCA.DBParm = "disablebind =0"
	lirc = ldsItem.Update()
	SQLCA.DBParm = "disablebind =1"
	
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Master Record(s) to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item Master Record to database!")
		Return -1
		Continue
	End If

Next /*File row to Process */

w_main.SetMicroHelp("")

lsLogOut = Space(10) + String(llNew) + ' Item Records were successfully added and ' + String(llExist) + ' Records were updated.'
FileWrite(gilogFileNo,lsLogOut)

Destroy ldsItem

If lbError then
	Return -1
Else
	Return 0
End If

Return 0
end function

public function integer uf_process_adjustment (string aspath, string asproject);
BOOLEAN lbError
STRING lsTemp, lsProject, lsSku, lsSupplier, lsWarehouse, lsOrderNumber, lsToday
STRING lsLogOut
STRING lsCustomerCode
STRING	lsType, lsSerial, lslot, lspo, lspo2
STRING	ls_container_ID, ls_coo, lsloc, lsRONO, lsRemarks, lsOutString, LsFileName
STRING lsUF2,lsUF3,lsUF4,lsUF5,lsUF6,lsUF7,lsUF8,lsUF9,lsUF10,lsUF11,lsUF12,lsUF13,lsUF14,lsUF15,lsUF16,lsUF17,lsUF18,lsUF19,lsUF20,lsUF21,lsUF22, lsLineItemNo
STRING	 lsaddr1, lsAddr2, lsaddr3, lsaddr4, lsCity, lsState, lsZip, lsCountry
INTEGER llContentRowPos, llContentRowCount, lirc, liRtnImp, llFileRowPos, llFilerowCount
DECIMAL ldQuantity, ldBatchSeq, ldContentQuantity
LONG		ll_owner,	ldAvailQty, ldNewQty, llNewRow, llLineItemNo
DATETIME	ldtToday, ldt_expiration_date   
				
u_ds_datastore 	ldsContent, ldsOut, ldsImport


ldsOut = Create u_ds_datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsContent = Create u_ds_datastore
ldsContent.dataobject= 'd_nyx_adjust_content'
ldsContent.SetTransObject(SQLCA)

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Sales Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Adjustment Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

llFilerowCount = ldsImport.RowCount()


lsDelimitChar = char(9)

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Adjustment Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))


	//Validate Rec Type is SH OR SD
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
	If NOT (lsTemp = 'SH' OR lsTemp = 'SD' ) Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If

	Choose Case Upper(lsTemp)
	
		//HEADER RECORD
		Case 'SH' /* Header */

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Change ID is required. Record will not be processed.")
				lbError = True
				Continue		
			End If					

			//Project ID	C(10)	Yes	N/A	Project identifier
			
			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsProject = lsTemp
			End If					
				
				
			//Warehouse	C(10)	Yes	N/A	Receiving Warehouse

			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col4")))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Warehouse is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsWarehouse = lsTemp
			End If					
							
			
			//Delivery Number	C(20)	Yes	N/A	Delivery Order Number

			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsOrderNumber = lsTemp
				lsLogOut = "        Creating SI For Order Number: " + lsOrderNumber
				FileWrite(gilogFileNo,lsLogOut)
			End If					
			
		/* End Required */		


			//Get the Next Batch Seq Nbr - Used for all writing to generic tables
			ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Adjustment_Issue_File','Adjustment_Issue')
			If ldBatchSeq <= 0 Then
				lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Adjustment Issue Confirmation.~r~rConfirmation will not be sent to NYX!'"
				FileWrite(gilogFileNo,lsLogOut)
				Return -1
			End If
		
		
		//Ship To Address will be the address from Warehouse Table
			Select Address_1, Address_2, Address_3, Address_4, city, state, zip, country
			Into	 :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
			From warehouse
			Where WH_Code = :lsWarehouse
			Using Sqlca;


			If IsNull(lsaddr1) then lsaddr1 = ''
			If IsNull(lsAddr2) then lsaddr2 = ''
			If IsNull(lsaddr3) then lsaddr3 = ''
			If IsNull(lsaddr4) then lsaddr4 = ''
			If IsNull(lsCity) then lsCity = ''
			If IsNull(lsState) then lsState = ''
			If IsNull(lsZip) then lsZip = ''
			If IsNull(lsCountry) then lsCountry = ''
			
			//Customer Code	C(20)	Yes	N/A	Customer ID
			lsCustomerCode = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
			
			ldtToday = f_getLocalWorldTime( lsWarehouse ) 
			lsToday =  String( ldtToday,'yyyy-mm-dd') 
		// Load Header Data Into Variable 		
			lsUF2 = Trim(ldsImport.GetItemString(llFileRowPos, "col40"))
			lsUF3 = Trim(ldsImport.GetItemString(llFileRowPos, "col41"))
			lsUF4 = Trim(ldsImport.GetItemString(llFileRowPos, "col42"))
			lsUF5 = Trim(ldsImport.GetItemString(llFileRowPos, "col43"))
			lsUF6 = Trim(ldsImport.GetItemString(llFileRowPos, "col44"))
			lsUF7 = Trim(ldsImport.GetItemString(llFileRowPos, "col45"))
			lsUF8 = Trim(ldsImport.GetItemString(llFileRowPos, "col46"))
			lsUF9 = Trim(ldsImport.GetItemString(llFileRowPos, "col47"))
			lsUF10 = Trim(ldsImport.GetItemString(llFileRowPos, "col48"))
			lsUF11 = Trim(ldsImport.GetItemString(llFileRowPos, "col49"))
			lsUF12 = Trim(ldsImport.GetItemString(llFileRowPos, "col50"))
			lsUF13 = Trim(ldsImport.GetItemString(llFileRowPos, "col51"))
			lsUF14 = Trim(ldsImport.GetItemString(llFileRowPos, "col52"))
			lsUF15 = Trim(ldsImport.GetItemString(llFileRowPos, "col53"))
			lsUF16 = Trim(ldsImport.GetItemString(llFileRowPos, "col54"))
			lsUF17 = Trim(ldsImport.GetItemString(llFileRowPos, "col55"))
			lsUF18 = Trim(ldsImport.GetItemString(llFileRowPos, "col56"))
			lsUF19 = Trim(ldsImport.GetItemString(llFileRowPos, "col56"))
			lsUF20 = Trim(ldsImport.GetItemString(llFileRowPos, "col55"))
			lsUF21 = Trim(ldsImport.GetItemString(llFileRowPos, "col56"))
			lsUF22 = Trim(ldsImport.GetItemString(llFileRowPos, "col56"))
			If IsNull(lsUF2) then lsUF2 = ''
			If IsNull(lsUF3) then lsUF3 = ''
			If IsNull(lsUF4) then lsUF4 = ''
			If IsNull(lsUF5) then lsUF5 = ''
			If IsNull(lsUF6) then lsUF6 = ''
			If IsNull(lsUF7) then lsUF7 = ''
			If IsNull(lsUF8) then lsUF8 = ''
			If IsNull(lsUF9) then lsUF9 = ''
			If IsNull(lsUF10) then lsUF10 = ''
			If IsNull(lsUF11) then lsUF11 = ''
			If IsNull(lsUF12) then lsUF12 = ''
			If IsNull(lsUF13) then lsUF13 = ''
			If IsNull(lsUF14) then lsUF14 = ''
			If IsNull(lsUF15) then lsUF15 = ''
			If IsNull(lsUF16) then lsUF16 = ''
			If IsNull(lsUF17) then lsUF17 = ''
			If IsNull(lsUF18) then lsUF18 = ''
			If IsNull(lsUF19) then lsUF19 = ''
			If IsNull(lsUF20) then lsUF20 = ''
			If IsNull(lsUF21) then lsUF21 = ''
			If IsNull(lsUF22) then lsUF22 = ''
		
				

		
		// DETAIL RECORD

		Case 'SD' /*Detail */

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Change ID is required. Record will not be processed.")
				lbError = True
				Continue		
			End If		
			
			//Project ID	C(10)	Yes	N/A	Project identifier
			
			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsProject = lsTemp
			End If									

			//Delivery Number	C(20)	Yes	N/A	Delivery Order Number (must match header)

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				
		
				//Make sure we have a header for this Detail...
//				If ldsSOHeader.Find("Upper(invoice_no) = '" + Upper(lstemp) + "'",1, ldsSOHeader.RowCount()) = 0 Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
//					lbDetailError = True
//				End If
					
				lsOrderNumber = lsTemp
			End If			

			
			//Supplier Code	C(20)	Yes	N/A	

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSupplier = lsTemp
			End If			

		
			//Line Number	N(6,0)	Yes	N/A	Delivery line item number

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				llLineItemNo = Long(lsTemp)
			End If					
			
			//SKU	C(50)	Yes	N/A	Material number

	
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSku = lsTemp
			End If				
			
			//Quantity	N(15,5)	Yes	N/A	Requested delivery quantity

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				ldQuantity = Dec(lsTemp)
			End If			

			/* End Required */
			
			lsLineItemNo = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
			If IsNull(lsLineItemNo) then lsLineItemNo = ''
			
		
			// TAM - Retrieve Content records based on Details to be adjusted	
			llContentRowCount = ldsContent.Retrieve(lsProject, lsWarehouse, lsSku, lsSupplier)

			If llContentRowCount <= 0 then
				//No Inventory
			Else
				
				// TAM - Update Content records based on Details to be adjusted
				for llContentRowPos = 1 to llContentRowCount

					//Load Adjustment Data from content
					lsSerial = ldsContent.GetITemString(llContentRowPos,"serial_no")
					If IsNull(lsSerial) then lsSerial= ''
					If  lsSerial = '-' Then lsSerial = ''
					lslot = ldsContent.GetITemString(llContentRowPos,"lot_no")
					If IsNull(lsLot) then lsLot= ''
					If  lsLot = '-' Then lsLot = ''
					lspo = ldsContent.GetITemString(llContentRowPos,"po_no")
					If IsNull(lspo) then lspo= ''
					If  lspo = '-' Then lspo = ''
					lspo2 = ldsContent.GetITemString(llContentRowPos,"po_no2")
					If IsNull(lspo2) then lspo2= ''
					If  lspo2 = '-' Then lspo2 = ''
					ls_container_ID  = ldsContent.GetITemString(llContentRowPos,"container_ID")
					If IsNull(ls_container_ID) then ls_container_ID= ''
					If  ls_container_ID = '-' Then ls_container_ID = ''
 				 	ldt_expiration_date  = ldsContent.GetITemDatetime(llContentRowPos,"expiration_date") 
					ll_owner = ldsContent.GetITemNumber(llContentRowPos,"owner_id")
					ls_coo = ldsContent.GetITemString(llContentRowPos,"country_of_origin")
					lsloc = ldsContent.GetITemString(llContentRowPos,"l_code")
					lsRONO =  ldsContent.GetITemString(llContentRowPos,"ro_no")
	
				
					
					If ldQuantity >= ldsContent.GetItemNumber(llContentRowPos, 'avail_qty' ) Then // All inventory on this row is changing
						ldsContent.SetItem(llContentRowPos,  'inventory_type', 'K')
						lsType = 'K'
						ldQuantity = ldQuantity -  ldsContent.GetItemNumber(llContentRowPos, 'avail_qty' )
						ldAvailQty = 0 /*original value before update!*/
						ldNewQty = ldsContent.GetITemNumber(llContentRowPos,"avail_qty")
// Create Adjustment Record		
						//Create an Adjustment Record
						SQLCA.DBParm = "disablebind =0"
						Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin, &
									wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no,po_no,old_po_no,po_no2,old_po_no2,
									container_ID, expiration_date, ro_no,old_quantity,quantity,ref_no,reason,last_user,last_update, Adjustment_Type,
									old_lot_no,remarks) 
						values	(:lsproject,:lsSku,:lsSupplier,:ll_owner,:ll_owner,:ls_coo,:ls_coo,:lsWarehouse,:lsLoc,'N',:lsType, &
									:lsSerial,:lsLot,:lspo,:lspo,:lspo2,:lspo2, :ls_container_ID, :ldt_expiration_date,:lsRONO,:ldAvailQty, 
									:ldNewQty,'','SSC','SIMSFP',:ldtToday,'I',	:lslot,:lsremarks)  
						Using SQLCA;
						SQLCA.DBParm = "disablebind =1"	
		
						If Sqlca.sqlcode <> 0  Then
							lbError = True
						End IF
//TODO Create GI File Record
						llNewRow = ldsOut.insertRow(0)
						lsOutString = 'KI' + lsDelimitChar	
						//Project ID	C(10)	Yes	N/A	Project identifier
						lsOutString +=  'NYX' + lsDelimitChar
						//Warehouse	C(10)	Yes		Shipping Warehouse
						lsOutString += lsWarehouse + lsDelimitChar
						//Delivery Number	C(10)	Yes	N/A	Order Number
						lsOutString += lsOrderNumber + lsDelimitChar	
						//Delivery Line Item	N(6,0)	Yes	N/A	order item line number
						lsOutString += String(llNewRow) + lsDelimitChar
						//SKU	C(50)	Yes	N/A	Material number
						lsOutString += lsSku  + lsDelimitChar	
						//Quantity	N(15,5)	Yes	N/A	Actual shipped quantity
						lsOutString += String( ldNewQty) + lsDelimitChar
						//Inventory Type	C(1)	Yes	N/A	Item condition
						lsOutString += lsType + lsDelimitChar
						//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
						lsOutString += lsLot+ lsDelimitChar	
						//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
						lsOutString += lsPO+ lsDelimitChar	
						//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
						lsOutString += lsPo2+ lsDelimitChar	
						//Serial Number	C(50)	No	N/A	Qty must be 1 if present
						lsOutString += lsSerial+ lsDelimitChar	
						//Container ID	C(25)	No	N/A	
						lsOutString += ls_container_ID+ lsDelimitChar	
						//Expiration Date	Date	No	N/A	
						lsOutString += String(ldt_expiration_date,'yyyy-mm-dd') + lsDelimitChar		
						//Price	N(12,4)	No	N/A	
						lsOutString += lsDelimitChar	
						//Ship Date	Date	No	N/A	Actual Ship date
						lsOutString += lsToday+ lsDelimitChar
						//Package Count	N(5,0)	No	N/A	Total no. of package in delivery
						lsOutString += '1'+ lsDelimitChar
						//Ship Tracking Number	C(25)	No	N/A	
						lsOutString += lsDelimitChar
						//Carrier	C (20)	No	N/A	Input by user
						lsOutString += 'NONE' + lsDelimitChar
						//Freight Cost	N(10,3)	No	N/A	
						lsOutString += lsDelimitChar
						//Freight Terms	C(20)	No	N/A	
						lsOutString += lsDelimitChar
						//Total Weight	N(12,2)	No	N/A	
						lsOutString += lsDelimitChar		
						//Transportation Mode	C(10)	No	N/A	
						lsOutString += lsDelimitChar
						//Delivery Date	Date	No	N/A	
						lsOutString += lsDelimitChar	
						//Detail User Field1	C(20)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field2	C(20)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field3	C(30)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field4	C(30)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field5	C(30)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field6	C(30)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field7	C(30)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field8	C(30)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Master User Field2 Thru18 	C(10)	No	N/A	User Field
						lsOutString += lsUF2 + lsDelimitChar
						lsOutString += lsUF3 + lsDelimitChar
						lsOutString += lsUF4 + lsDelimitChar
						lsOutString += lsUF5 + lsDelimitChar
						lsOutString += lsUF6 + lsDelimitChar
						lsOutString += lsUF7 + lsDelimitChar
						lsOutString += lsUF8 + lsDelimitChar
						lsOutString += lsUF9 + lsDelimitChar
						lsOutString += lsUF10 + lsDelimitChar
						lsOutString += lsUF11 + lsDelimitChar
						lsOutString += lsUF12 + lsDelimitChar
						lsOutString += lsUF13 + lsDelimitChar
						lsOutString += lsUF14 + lsDelimitChar
						lsOutString += lsUF15 + lsDelimitChar
						lsOutString += lsUF16 + lsDelimitChar
						lsOutString += lsUF17 + lsDelimitChar
						lsOutString += lsUF18 + lsDelimitChar
						//CustomerCode	
						lsOutString += lsCustomerCode + lsDelimitChar
						//Ship To Name
						lsOutString += lsWarehouse + lsDelimitChar
						//Ship Address 1	
						lsOutString += lsAddr1 + lsDelimitChar
						//Ship Address 2	
						lsOutString += lsAddr2 + lsDelimitChar
						//Ship Address 3	
						lsOutString += lsAddr3 + lsDelimitChar
						//Ship Address 4	
						lsOutString += lsAddr4 + lsDelimitChar
						//Ship City	
						lsOutString += lsCity + lsDelimitChar
						//Ship State	
						lsOutString += lsState + lsDelimitChar
						//Ship Postal Code	
						lsOutString += lsZip + lsDelimitChar
						//Ship Country
						lsOutString += lsCountry + lsDelimitChar
						//UnitOfMeasure (weight)
						lsOutString += lsDelimitChar
						//UnitOfMeasure (quantity)	
						lsOutString += lsDelimitChar
						//CountryOfOrigin	
						lsOutString += ls_coo+ lsDelimitChar	
						//Master User Field19 Thru 22	 
						lsOutString += lsUF19 + lsDelimitChar
						lsOutString += lsUF20 + lsDelimitChar
						lsOutString += lsUF21 + lsDelimitChar
						lsOutString += lsUF22 + lsDelimitChar
						//Master Department Code
						lsOutString += lsDelimitChar
						//Master Department_Name
						lsOutString += lsDelimitChar
						//Master Division
						lsOutString += lsDelimitChar
						 //Master Vendor
						lsOutString += lsDelimitChar
						//Detail Buyer_Part 
						lsOutString += lsDelimitChar
						//Detail Vendor_Part
						lsOutString += lsDelimitChar
						//Detail UPC
						lsOutString += lsDelimitChar
						//Detail EAN
						lsOutString += lsDelimitChar
						//Detail GTIN
						lsOutString += lsDelimitChar
						//Detail Department_Name
						lsOutString += lsDelimitChar
						//Detail Division
						lsOutString += lsDelimitChar
						//Detail Packaging_Characteristics
						lsOutString += lsDelimitChar
						//Master Account_Nbr                   
						lsOutString += lsDelimitChar
						//Master ASN_Number                    
						lsOutString += lsDelimitChar
						//Master Client_Cust_PO_Nbr            
						lsOutString += lsDelimitChar
						//Master Client_Cust_SO_Nbr            
						lsOutString += lsDelimitChar
						//Master Container_Nbr                 
						lsOutString += lsDelimitChar
						//Master Dock_Code                     
						lsOutString += lsDelimitChar
						//Master Document_Codes                
						lsOutString += lsDelimitChar
						//Master Equipment_Nbr                 
						lsOutString += lsDelimitChar
						//Master FOB                           
						lsOutString += lsDelimitChar
						//Master FOB_Bill_Duty_Acct            
						lsOutString += lsDelimitChar
						//Master FOB_Bill_Duty_Party           
						lsOutString += lsDelimitChar
						//Master FOB_Bill_Freight_Party        
						lsOutString += lsDelimitChar
						//Master FOB_Bill_Freight_To_Acct      
						lsOutString += lsDelimitChar
						//Master From_Wh_Loc                   
						lsOutString += lsDelimitChar
						//Master Routing_Nbr                   
						lsOutString += lsDelimitChar
						//Master Seal_Nbr                      
						lsOutString += lsDelimitChar
						//Master Shipping_Route                
						lsOutString += lsDelimitChar
						//Master SLI_Nbr                       
						lsOutString += lsDelimitChar
						//Detail client_cust_line_no   
						lsOutString += lsDelimitChar
						//Detail vat_identifier        
						lsOutString += lsDelimitChar
						//Detail CI_Value              
						lsOutString += lsDelimitChar
						//Detail Currency              
						lsOutString += lsDelimitChar
						//Detail Cust_Line_Nbr         
						lsOutString += lsDelimitChar
						//Detail Client_Cust_Invoice   
						lsOutString += lsDelimitChar
						//Detail Cust_PO_Nbr           
						lsOutString += lsDelimitChar
						//Detail Delivery_Nbr          
						lsOutString += lsDelimitChar
						//Detail Internal_Price        
						lsOutString += lsDelimitChar
						//Detail Client_Inv_Type       
						lsOutString += lsDelimitChar
						//Detail Permit_Nbr            
						lsOutString += lsDelimitChar 
						//Detail Supplier Code        
						lsOutString += lsSupplier+ lsDelimitChar		
						//Detail User Line Item No        
						lsOutString += String(lsLineItemNo) 		//+ lsDelimitChar
							//!!! NO DELIMITER ON LAST COLUMN

						ldsOut.SetItem(llNewRow,'Project_id', asProject)
						ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
						ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
						ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
						lsFileName = 'KI' + String(ldBatchSeq,'000000') + '.dat'
						ldsOut.SetItem(llNewRow,'file_name', lsFileName)

						// If No More quantity to adjust then get out
						If ldQuantity = 0 Then 
							llContentRowPos = ldsContent.RowCount ( )  //Get Out 
						End If
						
					Else 	// Not all inventory is used in adjustment.   Create 2 Adjustment Records and 
							//Update quantity of content Row and create a new content row with appropriate quantities
						ldContentQuantity = ldsContent.GetItemNumber(llContentRowPos, 'avail_qty' )
						ldsContent.SetItem(llContentRowPos,  'avail_qty',(ldContentQuantity - ldQuantity) ) //Set  Content Quantity Remainder
						lsType = 'N'
						ldAvailQty =  ldContentQuantity/*original value before update!*/
						ldNewQty = ldContentQuantity - ldQuantity
						ldsContent.RowsCopy(llContentRowPos,llContentRowPos,Primary!,ldsContent,999999999,Primary!) //Create New Content row

					// Create Adjustment Record for Existing Content		
						SQLCA.DBParm = "disablebind =0"
						Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin, &
									wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no,po_no,old_po_no,po_no2,old_po_no2,
									container_ID, expiration_date, ro_no,old_quantity,quantity,ref_no,reason,last_user,last_update, Adjustment_Type,
									old_lot_no,remarks) 
						values	(:lsproject,:lsSku,:lsSupplier,:ll_owner,:ll_owner,:ls_coo,:ls_coo,:lsWarehouse,:lsLoc,'N',:lsType, &
									:lsSerial,:lsLot,:lspo,:lspo,:lspo2,:lspo2, :ls_container_ID, :ldt_expiration_date,:lsRONO,:ldAvailQty, 
									:ldNewQty,'','SSC','SIMSFP',:ldtToday,'I',	:lslot,:lsremarks)  
						Using SQLCA;
						SQLCA.DBParm = "disablebind =1"	
		
						If Sqlca.sqlcode <> 0  Then
							lbError = True
						End IF
						
						//Change Qty and Inventory Type to new value after RowsCopy
						ldsContent.SetItem(ldsContent.RowCount ( ),'avail_qty',ldQuantity)
						ldsContent.SetItem(ldsContent.RowCount ( ),'inventory_type', 'K')
						lsType = 'K'
						ldAvailQty = 0 /*original value before update!*/
						ldNewQty = ldQuantity
	
						//Create an Adjustment Record For New Content
						SQLCA.DBParm = "disablebind =0"
						Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin, &
									wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no,po_no,old_po_no,po_no2,old_po_no2,
									container_ID, expiration_date, ro_no,old_quantity,quantity,ref_no,reason,last_user,last_update, Adjustment_Type,
									old_lot_no,remarks) 
						values	(:lsproject,:lsSku,:lsSupplier,:ll_owner,:ll_owner,:ls_coo,:ls_coo,:lsWarehouse,:lsLoc,'N',:lsType, &
									:lsSerial,:lsLot,:lspo,:lspo,:lspo2,:lspo2, :ls_container_ID, :ldt_expiration_date,:lsRONO,:ldAvailQty, 
									:ldNewQty,'','SSC','SIMSFP',:ldtToday,'I',:lslot,:lsremarks)  
						Using SQLCA;
						SQLCA.DBParm = "disablebind =1"	
						If Sqlca.sqlcode <> 0  Then
							lbError = True
						End IF

// TODO  Create GI File Record
						llNewRow = ldsOut.insertRow(0)
						lsOutString = 'KI' + lsDelimitChar	
						//Project ID	C(10)	Yes	N/A	Project identifier
						lsOutString +=  'NYX' + lsDelimitChar
						//Warehouse	C(10)	Yes		Shipping Warehouse
						lsOutString += lsWarehouse + lsDelimitChar
						//Delivery Number	C(10)	Yes	N/A	Order Number
						lsOutString += lsOrderNumber + lsDelimitChar	
						//Delivery Line Item	N(6,0)	Yes	N/A	order item line number
						lsOutString += String(llNewRow) + lsDelimitChar
						//SKU	C(50)	Yes	N/A	Material number
						lsOutString += lsSku  + lsDelimitChar	
						//Quantity	N(15,5)	Yes	N/A	Actual shipped quantity
						lsOutString += String( ldNewQty) + lsDelimitChar
						//Inventory Type	C(1)	Yes	N/A	Item condition
						lsOutString += lsType + lsDelimitChar
						//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
						lsOutString += lsLot+ lsDelimitChar	
						//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
						lsOutString += lsPO+ lsDelimitChar	
						//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
						lsOutString += lsPo2+ lsDelimitChar	
						//Serial Number	C(50)	No	N/A	Qty must be 1 if present
						lsOutString += lsSerial+ lsDelimitChar	
						//Container ID	C(25)	No	N/A	
						lsOutString += ls_container_ID+ lsDelimitChar	
						//Expiration Date	Date	No	N/A	
						lsOutString += String(ldt_expiration_date,'yyyy-mm-dd') + lsDelimitChar		
						//Price	N(12,4)	No	N/A	
						lsOutString += lsDelimitChar	
						//Ship Date	Date	No	N/A	Actual Ship date
						lsOutString += lsToday+ lsDelimitChar
						//Package Count	N(5,0)	No	N/A	Total no. of package in delivery
						lsOutString += '1'+ lsDelimitChar
						//Ship Tracking Number	C(25)	No	N/A	
						lsOutString += lsDelimitChar
						//Carrier	C (20)	No	N/A	Input by user
						lsOutString += 'NONE' + lsDelimitChar
						//Freight Cost	N(10,3)	No	N/A	
						lsOutString += lsDelimitChar
						//Freight Terms	C(20)	No	N/A	
						lsOutString += lsDelimitChar
						//Total Weight	N(12,2)	No	N/A	
						lsOutString += lsDelimitChar		
						//Transportation Mode	C(10)	No	N/A	
						lsOutString += lsDelimitChar
						//Delivery Date	Date	No	N/A	
						lsOutString += lsDelimitChar	
						//Detail User Field1	C(20)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field2	C(20)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field3	C(30)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field4	C(30)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field5	C(30)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field6	C(30)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field7	C(30)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Detail User Field8	C(30)	No	N/A	User Field
						lsOutString += lsDelimitChar
						//Master User Field2 Thru18 	C(10)	No	N/A	User Field
						lsOutString += lsUF2 + lsDelimitChar
						lsOutString += lsUF3 + lsDelimitChar
						lsOutString += lsUF4 + lsDelimitChar
						lsOutString += lsUF5 + lsDelimitChar
						lsOutString += lsUF6 + lsDelimitChar
						lsOutString += lsUF7 + lsDelimitChar
						lsOutString += lsUF8 + lsDelimitChar
						lsOutString += lsUF9 + lsDelimitChar
						lsOutString += lsUF10 + lsDelimitChar
						lsOutString += lsUF11 + lsDelimitChar
						lsOutString += lsUF12 + lsDelimitChar
						lsOutString += lsUF13 + lsDelimitChar
						lsOutString += lsUF14 + lsDelimitChar
						lsOutString += lsUF15 + lsDelimitChar
						lsOutString += lsUF16 + lsDelimitChar
						lsOutString += lsUF17 + lsDelimitChar
						lsOutString += lsUF18 + lsDelimitChar
						//CustomerCode	
						lsOutString += lsCustomerCode + lsDelimitChar
						//Ship To Name
						lsOutString += lsWarehouse + lsDelimitChar
						//Ship Address 1	
						lsOutString += lsAddr1 + lsDelimitChar
						//Ship Address 2	
						lsOutString += lsAddr2 + lsDelimitChar
						//Ship Address 3	
						lsOutString += lsAddr3 + lsDelimitChar
						//Ship Address 4	
						lsOutString += lsAddr4 + lsDelimitChar
						//Ship City	
						lsOutString += lsCity + lsDelimitChar
						//Ship State	
						lsOutString += lsState + lsDelimitChar
						//Ship Postal Code	  58
						lsOutString += lsZip + lsDelimitChar
						//Ship Country
						lsOutString += lsCountry + lsDelimitChar
						//UnitOfMeasure (weight)
						lsOutString += lsDelimitChar
						//UnitOfMeasure (quantity)	
						lsOutString += lsDelimitChar
						//CountryOfOrigin	 62
						lsOutString += ls_coo+ lsDelimitChar	
						//Master User Field19 Thru 22	 
						lsOutString += lsUF19 + lsDelimitChar
						lsOutString += lsUF20 + lsDelimitChar
						lsOutString += lsUF21 + lsDelimitChar
						lsOutString += lsUF22 + lsDelimitChar
						//Master Department Code
						lsOutString += lsDelimitChar
						//Master Department_Name
						lsOutString += lsDelimitChar
						//Master Division
						lsOutString += lsDelimitChar
						 //Master Vendor
						lsOutString += lsDelimitChar
						//Detail Buyer_Part 
						lsOutString += lsDelimitChar
						//Detail Vendor_Part
						lsOutString += lsDelimitChar
						//Detail UPC
						lsOutString += lsDelimitChar
						//Detail EAN
						lsOutString += lsDelimitChar
						//Detail GTIN
						lsOutString += lsDelimitChar
						//Detail Department_Name
						lsOutString += lsDelimitChar
						//Detail Division
						lsOutString += lsDelimitChar
						//Detail Packaging_Characteristics
						lsOutString += lsDelimitChar
						//Master Account_Nbr                   
						lsOutString += lsDelimitChar
						//Master ASN_Number                    
						lsOutString += lsDelimitChar
						//Master Client_Cust_PO_Nbr            
						lsOutString += lsDelimitChar
						//Master Client_Cust_SO_Nbr            
						lsOutString += lsDelimitChar
						//Master Container_Nbr                 
						lsOutString += lsDelimitChar
						//Master Dock_Code                     
						lsOutString += lsDelimitChar
						//Master Document_Codes                
						lsOutString += lsDelimitChar
						//Master Equipment_Nbr                 
						lsOutString += lsDelimitChar
						//Master FOB                           
						lsOutString += lsDelimitChar
						//Master FOB_Bill_Duty_Acct            
						lsOutString += lsDelimitChar
						//Master FOB_Bill_Duty_Party           
						lsOutString += lsDelimitChar
						//Master FOB_Bill_Freight_Party        
						lsOutString += lsDelimitChar
						//Master FOB_Bill_Freight_To_Acct      
						lsOutString += lsDelimitChar
						//Master From_Wh_Loc                   
						lsOutString += lsDelimitChar
						//Master Routing_Nbr                   
						lsOutString += lsDelimitChar
						//Master Seal_Nbr                      
						lsOutString += lsDelimitChar
						//Master Shipping_Route                
						lsOutString += lsDelimitChar
						//Master SLI_Nbr                       
						lsOutString += lsDelimitChar
						//Detail client_cust_line_no   
						lsOutString += lsDelimitChar
						//Detail vat_identifier        
						lsOutString += lsDelimitChar
						//Detail CI_Value              
						lsOutString += lsDelimitChar
						//Detail Currency              
						lsOutString += lsDelimitChar
						//Detail Cust_Line_Nbr         
						lsOutString += lsDelimitChar
						//Detail Client_Cust_Invoice   
						lsOutString += lsDelimitChar
						//Detail Cust_PO_Nbr           
						lsOutString += lsDelimitChar
						//Detail Delivery_Nbr          
						lsOutString += lsDelimitChar
						//Detail Internal_Price        
						lsOutString += lsDelimitChar
						//Detail Client_Inv_Type       
						lsOutString += lsDelimitChar
						//Detail Permit_Nbr            
						lsOutString += lsDelimitChar 
						//Detail Supplier Code        
						lsOutString += lsSupplier+ lsDelimitChar		
						//Detail User Line Item No        
						lsOutString += String(lsLineItemNo) 		//+ lsDelimitChar
							//!!! NO DELIMITER ON LAST COLUMN

						ldsOut.SetItem(llNewRow,'Project_id', asProject)
						ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
						ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
						ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
						lsFileName = 'KI' + String(ldBatchSeq,'000000') + '.dat'
						ldsOut.SetItem(llNewRow,'file_name', lsFileName)

						// No More quantity to adjust after spliting the row so get out of the loop 
						llContentRowPos = ldsContent.RowCount ( ) //Get Out
					End If
				Next /*Content record */

					//Once Content and Adjustment Records are updated for this line then commit the changes
					IF Not lbError then
						lirc = ldsContent.Update() 
						If liRC = 1 then
							Commit;
						Else
							lsLogOut = "- ***System Error!  Unable to Save Receive Master Record to database!"
							FileWrite(giLogFileNo,lsLogOut)
							Rollback;
							lberror = True
						End If
					Else
						lsLogOut = "- ***System Error!  Unable to Save Receive Master Record to database!"
						FileWrite(giLogFileNo,lsLogOut)
						Rollback;
						lberror = True
					End IF

			End If /*Content Found*/

	End Choose /*Header, Detail */
		
Next /*File record */


IF lbError then
	Return -1	
Else
	//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(ldsOut,asProject)
	
	RETURN 1
End IF
end function

protected function integer uf_process_delivery_order (string aspath, string asproject);

integer liIdx
String	lsFreightTerms, lsincoterms, ls_date
string ls_null, lsSKU, lsSupplier, lsAltSKU,lswh_code   //05-Dec-2013 :Madhu- Added -"lswh_code" to set Schedule_date to the current warehouse time 
Datetime ldtwhtime    //05-Dec-2013 :Madhu- Added -to set Schedule_date to the current warehouse time 


//Process Delivery Order


u_ds_datastore 	ldsSOheader,	ldsSOdetail, ldsDOAddress, ldsDONotes
u_ds_datastore 	ldsImport

integer lirc
boolean lberror
string lslogout

//Call the generic load

u_nvo_proc_baseline_unicode lu_nvo_proc_baseline_unicode

lu_nvo_proc_baseline_unicode = create u_nvo_proc_baseline_unicode	


lirc = lu_nvo_proc_baseline_unicode.uf_load_delivery_order(aspath, asproject, ldsImport, ldsSOheader, ldsSOdetail, ldsDOAddress, ldsDONotes)	
	
IF lirc = -1 then lbError = true else lbError = false	

//Set TRAX DElivery Terms based on Freight Terms and UF 16 (incoterms)
For liIdx =  1 to ldsSOheader.RowCount() 
	
	lsFreightTerms = ldsSOheader.GetITemString(liIdx,'Freight_Terms')
	lsincoterms = ldsSOheader.GetITemString(liIdx,'User_Field16')
	
	Choose Case upper(lsFreightTerms)
			
		Case 'PREPAID'
			
			if lsIncoterms = 'DDP' Then
				ldsSOheader.SetItem(liIdx,'Trax_Duty_Terms','SHIPPERDUTYVAT')
			Elseif  lsIncoterms = 'CPT' Then
				ldsSOheader.SetItem(liIdx,'Trax_Duty_Terms','CONSIGNEEDUTYVAT')
			End If
			
		Case 'COLLECT'
			
			if  lsIncoterms = 'FCA' Then
				ldsSOheader.SetItem(liIdx,'Trax_Duty_Terms','CONSIGNEEDUTYVAT')
			End If
			
	End Choose
	
	
	//Set Format for delivery_date

	ls_date =  ldsSOheader.GetItemString( liIdx, "delivery_date")
	
	if len(ls_date) >= 8 then
		 ls_date = left(ls_date,4) + "/" + mid(ls_date,5,2) + "/" +  mid(ls_date,7,2)
		 ldsSOheader.SetItem( liIdx, "delivery_date",ls_date)
	end if 
	
	
	//Set Format for ord_date

	ls_date =  ldsSOheader.GetItemString( liIdx, "ord_date")
	
	if len(ls_date) >= 8 then
		 ls_date = left(ls_date,4) + "/" + mid(ls_date,5,2) + "/" +  mid(ls_date,7,2)
		 ldsSOheader.SetItem( liIdx, "ord_date",ls_date)
	end if 
	
	
	//Set Format for schedule_date
	
	ls_date =  ldsSOheader.GetItemString( liIdx, "schedule_date")
	
	if len(ls_date) >= 8 then
		 ls_date = left(ls_date,4) + "/" + mid(ls_date,5,2) + "/" +  mid(ls_date,7,2)
		 ldsSOheader.SetItem( liIdx, "schedule_date",ls_date)
	end if 	
	//Gailm 7/21/2015 below code taken out.  Use supllied schedule date.
	//lswh_code=	ldsSOheader.GetItemString(liIdx,"wh_code")
	//ldtwhtime = f_getLocalWorldTime(lswh_code)
	//ldsSOheader.SetItem(liIdx,"schedule_date",ldtwhtime)
	//05-Dec-2013 :Madhu- Added -set Schedule_date to the current warehouse time -END

	//Set Format for request_date

// TAM - 2015/12/09 - set request date to local warehouse time
	lswh_code=	ldsSOheader.GetItemString(liIdx,"wh_code")
	ldtwhtime = f_getLocalWorldTime(lswh_code)
	ls_date = string(ldtwhtime,'YYYY/MM/DD hh:mm:ss')
	ldsSOheader.SetItem(liIdx,"request_date",ls_date)
string ldttestdt	
ldttestdt = ldsSOheader.GetItemString(liIdx,"request_date")
//	ls_date =  ldsSOheader.GetItemString( liIdx, "request_date")
//	
//	if len(ls_date) >= 8 then
//		 ls_date = left(ls_date,4) + "/" + mid(ls_date,5,2) + "/" +  mid(ls_date,7,2)
//		 ldsSOheader.SetItem( liIdx, "request_date",ls_date)
//	end if 	
	
Next


// 08/13 - PCONKL - We need to populate the Alternate_SKU from Item Master
For liIdx =  1 to ldsSOdetail.RowCount() 
		
		lsSKU = ldsSODetail.GetItemString(liIdx,'sku')
		lsSupplier = ldsSODetail.GetItemString(liIdx,'supp_code')
		
		Select Alternate_SKU
		into :lsAltSKU
		From Item_MAster
		Where project_id = :asProject and sku = :lsSKU and supp_code = :lsSupplier;
	
		ldsSOdetail.SetItem( liIdx, "Alternate_SKU", lsAltSKU)
		
Next

//Save the Changes 
SQLCA.DBParm = "disablebind =0"
lirc = ldsSOheader.Update()
SQLCA.DBParm = "disablebind =1"

	
If liRC = 1 Then
//	SQLCA.DBParm = "disablebind =0"
	liRC = ldsSOdetail.Update()
//	SQLCA.DBParm = "disablebind =1"
	
ELSE
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Header Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If



If liRC = 1 Then
	
//	Execute Immediate "COMMIT" using SQLCA; COMMIT USING SQLCA;
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsDOAddress.Update()
	SQLCA.DBParm = "disablebind =1"
ELSE	
//	Execute Immediate "ROLLBACK" using SQLCA;
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
//END

	
If liRC = 1 then
//	Commit;
Else
	
//	Execute Immediate "ROLLBACK" using SQLCA; 
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Records to database!"
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

public function integer uf_process_dboh_kits (string asproject, string asinifile);
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

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

String lsFileNamePath

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run


//Moved to Scheduled Activity Table


ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_nyx_dboh'
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile, asproject,"project","")

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

//GailM - 6/22/2015 - Set filter on BOH to remove warehouse NYX-AU
ldsBOH.setfilter( "wh_code = 'NYX-NL' and inventory_type = 'K' " )
ldsBOH.FILter( )

//Rowcount changes with filter
llRowCount = ldsBOH.RowCount()

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
	
	//Quantity	N(15,5)	Yes	N/A	Balance on hand
	
	long ll_Qty
	
	ll_Qty = ldsboh.GetItemNumber(llRowPos,'avail_qty')
	
	if ll_Qty < 0 then
		ll_Qty = 0
	end if

	lsOutString += string(ll_Qty) + lsDelimitChar

	//Quantity Allocated	N(15,5)	No	N/A	Allocated to Outbound Order

	ll_Qty = ldsboh.GetItemNumber(llRowPos,'alloc_qty')
	
	if ll_Qty < 0 then
		ll_Qty = 0
	end if	
	
	
	lsOutString += string(ll_Qty) + lsDelimitChar
	
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

	If string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'MM/DD/YYYY') <> "12/31/2999" and string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'MM/DD/YYYY') <> "01/01/1900" Then
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
		

	//BH016	Supp_Invoice_No				O	
	
	if IsNull(ldsboh.GetItemString(llRowPos,'Supp_Invoice_No')) OR Trim(ldsboh.GetItemString(llRowPos,'Supp_Invoice_No')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'Supp_Invoice_No')  + lsDelimitChar
	end if	

	//BH017	Lot controlled				O				
	
	if IsNull(ldsboh.GetItemString(llRowPos,'Lot_Controlled_Ind')) OR Trim(ldsboh.GetItemString(llRowPos,'Lot_Controlled_Ind')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'Lot_Controlled_Ind')  + lsDelimitChar
	end if		
	
	//BH018	Serial controlled				O	

	if IsNull(ldsboh.GetItemString(llRowPos,'Serialized_Ind')) OR Trim(ldsboh.GetItemString(llRowPos,'Serialized_Ind')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'Serialized_Ind')  + lsDelimitChar
	end if		

	//BH019	Country_of_origin				O	
	
	if IsNull(ldsboh.GetItemString(llRowPos,'Country_Of_Origin_Default')) OR Trim(ldsboh.GetItemString(llRowPos,'Country_Of_Origin_Default')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'Country_Of_Origin_Default')  + lsDelimitChar
	end if		
	
	//BH020	owner_id				O		
	
	if IsNull(ldsboh.GetItemNumber(llRowPos,'Owner_Id'))  then
//		lsOutString += lsDelimitChar
	else	
	   lsOutString += String(ldsboh.GetItemNumber(llRowPos,'Owner_Id')) // + lsDelimitChar
	end if	
	
	
//	BHYYMDD.dat
	
	lsFilename = ("KBH" + string(today(), "YYMMDD") + lsWarehouse + ".dat")
	
	ldsOut.SetItem(llNewRow,'file_name', lsFilename)
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	
	if lsLastWarehouse <> lsWarehouse then

		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
		sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
		commit;
		
		If ldBatchSeq <= 0 Then
			lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' BOH confirmation."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			 Return -1
		End If
		
		lsLastWarehouse = lsWarehouse
		
	end if	
	
	
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
next /*next output record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(ldsOut,lsProject)

// TAM 2011/09  Added ability to email the report

lsFileNamePath = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + lsFileName  + ".txt"
gu_nvo_process_files.uf_send_email(lsProject,"BOHEMAIL", lsProject + " Daily Balance On Hand  for Kits Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the BALANCE ON HAND FOR KITS REPORT run on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)


//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile, asproject,'DBOHFREQ','')
If isnumber(lsRunFreq) Then
	//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile, asproject,'DBOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile, asproject,'DBOHNEXTDATE','')
End If

Return 0
end function

on u_nvo_proc_nyx.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_nyx.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

