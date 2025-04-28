$PBExportHeader$u_nvo_proc_maquet.sru
$PBExportComments$Process Maquet files
forward
global type u_nvo_proc_maquet from nonvisualobject
end type
end forward

global type u_nvo_proc_maquet from nonvisualobject
end type
global u_nvo_proc_maquet u_nvo_proc_maquet

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				iu_DS
				
u_ds_datastore	idsItem , idsOut

				



end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_dboh (string asinifile)
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_itemmaster (string aspath, string asproject)
protected function integer uf_process_po (string aspath, string asproject)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);
String	lsLogOut,lsSaveFileName, lsStringData

Integer	liRC, liFileNo

Boolean	bRet


If Left(asFile,4) = 'N943' Then /* PO File*/
	
		
		liRC = uf_process_po(asPath, asProject)
	
		//Process any added PO's
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
			
ElseIf Left(asFile,4) =  'N940' Then /* Sales Order Files from LMS to SIMS*/
		
		liRC = uf_process_so(asPath, asProject)
		
		//Process any added SO's
		liRC = gu_nvo_process_files.uf_process_Delivery_order(asProject) 
		
ElseIf Left(asFile,4) =  'N832' Then 
	
	liRC = uf_process_itemMaster(asPath, asProject)
		
Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
	End If

Return liRC
end function

public function integer uf_process_dboh (string asinifile);// uf_process_dboh(
//Process the PHOENIX Daily Balance on Hand Confirmation File

Datastore	ldsOut, ldsboh
				
Long			llRowPos, llRowCount, llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsWarehouse, lsWarehouseSave, lsMaquetWarehouse, lsFileName, sql_syntax, Errors

Decimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

// pvh 03.16.06
constant string lsSpaces = Space(10)

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

lsNextRunDate = ProfileString(asIniFile,'MAQUET','DBOHNEXTDATE','')
lsNextRunTime = ProfileString(asIniFile,'MAQUET','DBOHNEXTTIME','')
If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
	Return 0
Else /*valid date*/
	ldtNextRunTIme = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
	If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
		Return 0
	End If
End If

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

//Create the BOH datastore
ldsboh = Create Datastore
sql_syntax = "SELECT Content_summary.wh_Code,Content_summary.supp_Code, Content_summary.SKU,  Content_summary.inventory_type, Content_summary.Lot_No, Content_summary.po_No, Sum( Content_Summary.Avail_Qty  ) + Sum( Content_Summary.alloc_Qty  ) as total_qty" 
sql_syntax += " From Content_summary "
sql_syntax += " Where Project_ID = 'maquet' "
//dts - 10/98 - excluding inventory in the cross-dock warehouse.
sql_syntax += " and wh_code <> 'MAQ-CROSS' "
sql_syntax += " Group By Content_summary.wh_Code, Content_summary.supp_Code, Sku, Inventory_type, Lot_No, po_no "
sql_syntax += " Having Sum( Content_Summary.Avail_Qty  ) + Sum( Content_Summary.alloc_Qty  ) > 0; "
ldsboh.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Maquet Balance on Hand Extract.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsboh.SetTransObject(SQLCA)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: MAQUET Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile,'MAQUET',"project","")

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no('MAQUET','EDI_Generic_Outbound','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for MAQUET BOH confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrive the BOH Data
lsLogout = 'Retrieving Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCOunt = ldsBOH.Retrieve(lsProject)
ldsBOH.SetSort("wh_code A, sku A")
ldsBOH.Sort()

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by 'Tab'
lsLogOut = 'Processing Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCOunt
	
	// If Warehouse Changes, retreive Maquet code value (for LMS)
	lsWarehouse = ldsboh.GetItemString(llRowPos,'wh_code')
	If lsWarehouse <> lsWarehouseSave Then
		
		Select User_field1 into :lsmaquetWarehouse
		From Warehouse
		where wh_code = :lsWarehouse;
		
		If isNull(lsmaquetWarehouse) or lsMaquetWarehouse = "" Then lsMaquetWarehouse = lsWarehouse
		
		lswarehouseSave = lsWarehouse
		
	End If
			
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'BH|' /*rec type = balance on Hand Confirmation*/
	lsOutString+= lsMaquetWarehouse + "|"
	lsOutString += ldsboh.GetItemString(llRowPos,'inventory_Type') + "|"
	
	//INclude Supplier with SKU field if <> MAQUET
	If Upper(ldsboh.GetItemString(llRowPos,'supp_Code')) <> 'MAQUET' Then
		lsOutString += ldsboh.GetItemString(llRowPos,'supp_Code') + "#" + ldsboh.GetItemString(llRowPos,'sku') + "|"
	Else
		lsOutString += ldsboh.GetItemString(llRowPos,'sku') + "|"
	End If
		
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'total_qty')) + "|"
	lsOutString += left(ldsboh.GetItemString(llRowPos,'po_no'),30) + "|" /* Package Code */
		
	If ldsboh.GetItemString(llRowPos,'lot_no') <> '-' Then
		lsOutString += left(ldsboh.GetItemString(llRowPos,'lot_no'),30)  /* Lot Number */
	Else
		lsOutString += ""
	End If
		
	ldsOut.SetItem(llNewRow,'Project_id', "MAQUET")
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'N846' + String(ldBatchSeq,'00000') + '.DAT'
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)
		
next /*next output record */

If ldsOut.RowCount() > 0 Then /*Don't send an empty file */
	
	//Add a trailer
	llNewRow = ldsOut.insertRow(0)
	ldsOut.SetItem(llNewRow,'Project_id', "MAQUET")
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', "EOF")
	lsFileName = 'N846' + String(ldBatchSeq,'00000') + '.DAT'
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)

	//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,"MAQUET")

End If

//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile,'MAQUET','DBOHFREQ','')
If isnumber(lsRunFreq) Then
	//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile,'MAQUET','DBOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile,'MAQUET','DBOHNEXTDATE','')
End If



Return 0
end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for Maquet

Datastore	ldsDOHeader, ldsDODetail, lu_ds, ldsDOAddress, ldsDONotes
				
String		lsLogout,lsRecData,lsTemp,	lswarehouse, lsErrText,	 lsSKU,	lsRecType,	&
				lsSoldToAddr1, lsSoldToADdr2, lsSoldToADdr3,  lsSoldToAddr4, lsSoldToStreet,	&
				lsSoldToZip, lsSoldToCity, lsSoldToState, lsSoldToCountry, lsSoldToTel, lsDate, ls_invoice_no, ls_Note_Type, &
				ls_search,lsNotes,ls_temp

Integer		liFileNo,liRC, li_line_item_no
				
Long			llRowCount,	llRowPos,llNewRow,llOrderSeq,	llBatchSeq,	llLineSeq,llCount,		&
				llCONO, llRoNO, llLineItemNo,  llOwner, llNewAddressRow, llNewNotesRow, li_find
				
Decimal		ldQty, ldPrice
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError, lbSoldToAddress 
			

ldtToday = DateTime(today(),Now())
				
lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

ldsDOHeader = Create u_ds_datastore
ldsDOHeader.dataobject = 'd_shp_header'
ldsDOHeader.SetTransObject(SQLCA)

ldsDODetail = Create u_ds_datastore
ldsDODetail.dataobject = 'd_shp_detail'
ldsDODetail.SetTransObject(SQLCA)

ldsDOAddress = Create u_ds_datastore
ldsDOAddress.dataobject = 'd_mercator_do_address'
ldsDOAddress.SetTransObject(SQLCA)

ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes'
ldsDONotes.SetTransObject(SQLCA)

//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Maquet Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',lsRecData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

//Get the next available file sequence number
//llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
//If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = lu_ds.RowCount()

//Process each Row
For llRowPos = 1 to llRowCount
	
	lsRecData = lu_ds.GetITemString(llRowPos,'rec_data')
		
	//Process header, Detail, or header/line notes */
	lsRecType = Upper(Mid(lsRecData,7,2))
	
	Choose Case lsRecType
			
		//HEADER RECORD
		Case 'OM' /* Header */
				
			// 01/20 - PCONKL - Moved assignment of Batch Seq No so each order is it's own Seq No. This fixes a bug below where notes are being assigned only on Batch Seq and Not Order seq which is causing notes to be applied to the wrong order.
			llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
			If llBatchSeq <= 0 Then Return -1

			llnewRow = ldsDOHeader.InsertRow(0)
			//llOrderSeq ++
			llOrderSeq = 1
			llLineSeq = 0
			
		//Record Defaults
			ldsDOHeader.SetItem(llNewRow,'ACtion_cd','A') /*always a new Order*/
			ldsDOHeader.SetITem(llNewRow,'project_id',asProject) /*Project ID*/
			ldsDOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow,'Status_cd','N')
			ldsDOHeader.SetItem(llNewRow,'order_Type','S') /*default to SALE */
			ldsDOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')
						
		//From File
			
			ls_temp = Trim(Mid(lsRecdata,10,6))

			Select warehouse.wh_Code into :lsWarehouse
			From Warehouse, Project_warehouse
			Where warehouse.wh_Code = project_warehouse.wh_Code and project_id = :asProject
			and User_Field1 = :ls_temp;
					
			
			If lsWarehouse > '' Then
				ldsDOHeader.SetITem(llNewRow,'wh_code',lswarehouse) 
			Else
				ldsDOHeader.SetITem(llNewRow,'wh_code',Trim(Mid(lsRecdata,10,6))) /* 04/06 - PCONKL - set to invalid WH from file*/
			End If
					
			ldsDOHeader.SetItem(llNewRow,'invoice_no',Trim(Mid(lsRecData,30,30))) /*Order Number*/
			ldsDOHeader.SetItem(llNewRow,'User_field2',Trim(Mid(lsRecData,60,4))) /*Order Type - UF 2 - Order # + Plus order Type = Unique order # for LMS*/
			ldsDOHeader.SetItem(llNewRow,'Carrier',Trim(Mid(lsRecData,92,15))) 
			ldsDOHeader.SetItem(llNewRow,'User_Field1',Trim(Mid(lsRecData,92,15))) /*dts - PackList prints UF1 in 'Carrier/Service lvl' */
			ldsDOHeader.SetItem(llNewRow,'User_field3',Trim(Mid(lsRecData,129,12))) /*End Leg Carrier for MAster Load (Group Code 2)*/
			ldsDOHeader.SetItem(llNewRow,'Priority',Trim(Mid(lsRecData,211,3))) /*Priority*/
			ldsDOHeader.SetItem(llNewRow,'User_field4',Trim(Mid(lsRecData,224,15))) /*LMS SHipment*/
			ldsDOHeader.SetItem(llNewRow,'User_field5',Trim(Mid(lsRecData,239,15))) /*LMS Master SHipment*/
			
			lsTemp = Trim(Mid(lsRecData,24,8))
			lsDate = Mid(lsTemp,5,2) + '/' + Right(lsTEmp,2) + '/' + Left(lsTemp,4)
			
			/*Schedule Date - reformat to mm/dd/yyyy*/
			lsTemp = Trim(Mid(lsRecData,288,8))
			lsDate = Mid(lsTemp,5,2) + '/' + Right(lsTEmp,2) + '/' + Left(lsTemp,4)
			ldsDOHeader.SetItem(llNewRow,'Schedule_Date',lsDate) 
			
			/*Request Date*/
			lsTemp = Trim(Mid(lsRecData,296,8))
			lsDate = Mid(lsTemp,5,2) + '/' + Right(lsTEmp,2) + '/' + Left(lsTemp,4)
			ldsDOHeader.SetItem(llNewRow,'Request_Date',lsDate) 
			
			ldsDOHeader.SetItem(llNewRow,'Order_no',Trim(Mid(lsRecData,773,30))) /*Cust Order No*/
			
			ldsDOHeader.SetItem(llNewRow,'Cust_Code',Trim(Mid(lsRecData,803,15))) /*Cust Code*/		
			
			//cust code may not be present...
			If isnull(ldsdoheader.GetITemString(llNewRow,'Cust_Code')) or ldsdoheader.GetITemString(llNewRow,'Cust_Code') = '' Then
				ldsDOHeader.SetItem(llNewRow,'Cust_Code','N/A')
			End If
			
			ldsDOHeader.SetItem(llNewRow,'Cust_Name',Trim(Mid(lsRecData,818,40))) /*Cust Name*/
			//24-Jul-2013 :Madhu -Added Address_3,Address_4 columns -START
			ldsDOHeader.SetItem(llNewRow,'Address_2',Trim(Mid(lsRecData,858,40))) /*Ship to Addr 2*/
			ldsDOHeader.SetItem(llNewRow,'Address_3',Trim(Mid(lsRecData,898,40))) /*Ship to Addr 3*/
			ldsDOHeader.SetItem(llNewRow,'Address_4',Trim(Mid(lsRecData,938,40))) /*Ship to Addr 4*/
			//24-Jul-2013 :Madhu -Added Address_3,Address_4 columns -END
			ldsDOHeader.SetItem(llNewRow,'Address_1',Trim(Mid(lsRecData,978,40))) /*Ship to Addr 1*/

			//ldsDOHeader.SetItem(llNewRow,'Address_3',Trim(Mid(lsRecData,1058,40))) /*Ship to Addr 3*/ //24-Jul-2013 :Madhu -Commented
			ldsDOHeader.SetItem(llNewRow,'City',Trim(Mid(lsRecData,1098,35))) /*Ship to City*/
			ldsDOHeader.SetItem(llNewRow,'State',Trim(Mid(lsRecData,1168,2))) /*Ship to State 1*/
			ldsDOHeader.SetItem(llNewRow,'Zip',Trim(Mid(lsRecData,1170,10))) /*Ship to Zip*/
			ldsDOHeader.SetItem(llNewRow,'Country',Trim(Mid(lsRecData,1180,20))) /*Ship to country*/
			ldsDOHeader.SetItem(llNewRow,'tel',Trim(Mid(lsRecData,1200,20))) /*Ship to Tel*/
			
			//Jxlim 04/07/2014 L14P164 - QUN-  Add UPS as TraX carrier for Maquet Inc			
			ldsDOHeader.SetItem(llNewRow,'trax_acct_no',Trim(Mid(lsRecData,2488,30))) /*Consignee Carrier Account=dm.trax_acct_number*/
			
			//18-Sep-2014 : Madhu- Store Freght Terms value -START
			/* Freight Terms - Prepaid or Collect - LMS is sending a 2-char code */
			lsTemp = Trim(Mid(lsRecData, 304, 2))
			choose case lsTemp
				case 'PP', 'PA'
					lsTemp = 'PREPAID'
				case 'CC', 'CA'
					lsTemp = 'COLLECT'
			end choose
			ldsDOHeader.SetItem(llNewRow, 'Freight_Terms', lsTemp) /*Freight Terms - Prepaid or Collect ?Need to translate?*/
			//18-Sep-2014 : Madhu- Store Freght Terms value -END
		
			//If we have Bill to, or Interim Dest Addresses, we will build alt address records
		 				
			//Bill To
			If Trim(Mid(lsRecData,306,445)) > '' Then
				
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				ldsDOAddress.SetItem(llNewAddressRow,'address_type','BT') /* Bill To Address */
				ldsDOAddress.SetItem(llNewAddressRow,'Name',Trim(Mid(lsRecdata,336,15))) /*Bill To Number*/
				ldsDOAddress.SetItem(llNewAddressRow,'address_1',Trim(Mid(lsRecdata,351,40))) /* Bill To Cust Name*/
				ldsDOAddress.SetItem(llNewAddressRow,'address_2',Trim(Mid(lsRecdata,511,40))) /* BT Addr 1*/
				ldsDOAddress.SetItem(llNewAddressRow,'address_3',Trim(Mid(lsRecdata,551,40))) /*BT addr 2*/
				ldsDOAddress.SetItem(llNewAddressRow,'address_4',Trim(Mid(lsRecdata,591,40))) /*BT addr 3*/
				ldsDOAddress.SetItem(llNewAddressRow,'City',Trim(Mid(lsRecdata,631,35))) /* BT City */
				ldsDOAddress.SetItem(llNewAddressRow,'State',Trim(Mid(lsRecdata,701,2))) /*BT State */
				ldsDOAddress.SetItem(llNewAddressRow,'Zip',Trim(Mid(lsRecdata,703,10))) /*Bill To Zip */
				ldsDOAddress.SetItem(llNewAddressRow,'Country',Trim(Mid(lsRecdata,713,20))) /* BT Country */
				ldsDOAddress.SetItem(llNewAddressRow,'tel',Trim(Mid(lsRecdata,733,20))) /*BT Phone*/
				
			End If /*Bill To address exists*/
			
			//Intermediate Dest
			// 12/06/07 If Trim(Mid(lsRecData,306,445)) > '' Then
			If Trim(Mid(lsRecData,1988,370)) > '' Then
				
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				ldsDOAddress.SetItem(llNewAddressRow,'address_type','ID') /*Intermediate Dest*/
				ldsDOAddress.SetItem(llNewAddressRow,'Name',Trim(Mid(lsRecdata,1988,40))) 
				ldsDOAddress.SetItem(llNewAddressRow,'address_1',Trim(Mid(lsRecdata,2148,40))) 
				ldsDOAddress.SetItem(llNewAddressRow,'address_2',Trim(Mid(lsRecdata,2188,40))) 
				ldsDOAddress.SetItem(llNewAddressRow,'address_3',Trim(Mid(lsRecdata,2228,40)))
				ldsDOAddress.SetItem(llNewAddressRow,'City',Trim(Mid(lsRecdata,2268,35))) 
				ldsDOAddress.SetItem(llNewAddressRow,'State',Trim(Mid(lsRecdata,2338,2))) 
				ldsDOAddress.SetItem(llNewAddressRow,'Zip',Trim(Mid(lsRecdata,2340,10))) 
				ldsDOAddress.SetItem(llNewAddressRow,'Country',Trim(Mid(lsRecdata,2350,20))) 
				
			End If /*Intemediate Dest address exists*/

		// DETAIL RECORD
		Case 'OD' /*Detail */
									
			llnewRow = ldsDODetail.InsertRow(0)
			llLineSeq ++
		
		//Add detail level defaults
			ldsDODetail.SetITem(llNewRow,'project_id', asproject) /*project*/
			ldsDODetail.SetITem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDODetail.SetITem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDODetail.SetITem(llNewRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetITem(llNewRow,'Status_cd','N')
			//ldsDODetail.SetItem(llNewRow,'Inventory_type','N') /*normal inventory*/
				
		//From File
			ls_temp = Trim(Mid(lsRecdata,30,30))
			ldsDODetail.SetItem(llNewRow,'invoice_no',Trim(Mid(lsRecdata,30,30))) 
			ldsDODetail.SetItem(llNewRow,'line_item_no',Long(Trim(Mid(lsRecdata,64,6))))
			
			// SKU may have a 3 char supplier code prefix seperated by #
			lsTemp = Trim(Mid(lsRecdata,70,20))
			If pos(lstemp,"#") > 0 Then
				
				ldsDODetail.SetItem(llNewRow,'Supp_code',Left(lsTemp,(pos(lstemp,"#") - 1)))
				ldsDODetail.SetItem(llNewRow,'SKU',Mid(lsTemp,(pos(lstemp,"#") + 1),99999))
				
			Else
				
				ldsDODetail.SetItem(llNewRow,'SKU',lsTemp)
				
			End If
						
			ldsDODetail.SetItem(llNewRow,'quantity',Trim(Mid(lsRecdata,203,12)))
			ldsDODetail.SetItem(llNewRow,'uom',Trim(Mid(lsRecdata,215,6)))
			ldsDODetail.SetItem(llNewRow,'alternate_sku',Trim(Mid(lsRecdata,221,20)))
			ldsDODetail.SetItem(llNewRow,'User_Field1',Trim(Mid(lsRecdata,241,10))) /* customer Order */
			ldsDODetail.SetItem(llNewRow,'User_Field2',Trim(Mid(lsRecdata,251,10))) /* dts - Customer Line Number -> */
			ldsDODetail.SetItem(llNewRow,'price',Trim(Mid(lsRecdata,270,8)))		
			ldsDODetail.SetItem(llNewRow,'po_no',Trim(Mid(lsRecdata,90,6)))	/* Package Code -> PO_NO */
							
		Case 'OC', 'DC' /* Header/Line Notes*/
						
			IF lsRecType = 'OC' THEN
				lsNotes=Trim(Mid(lsRecdata,76,40)) 
					IF pos(Trim(lsNotes),'Notes for Order Number') = 0  and &
						pos(Trim(lsNotes),'Function Code') = 0 	THEN	
						ls_search = 'TXT         :'
						IF pos(Trim(lsNotes),ls_search) > 0 THEN
							lsNotes=mid(Trim(lsNotes),(len(ls_search)+1))
						END IF
					Else 
					Continue
				ENd IF		
			ENd IF		  				
			
			llNewNotesRow = ldsDONotes.InsertRow(0)
			
			//Defaults
			ldsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
			ldsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			
			//From File
			ldsDONotes.SetItem(llNewNotesRow,'note_type',lsRecType) /* Note Type */
			ldsDONotes.SetItem(llNewNotesRow,'invoice_no',Trim(Mid(lsRecdata,30,30)))
						
			If lsRecType = 'DC' Then /*detail*/
				ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',Long(Trim(Mid(lsRecdata,70,6))))
				ldsDONotes.SetItem(llNewNotesRow,'line_item_no',Long(Trim(Mid(lsRecdata,64,6))))
				ldsDONotes.SetItem(llNewNotesRow,'note_text',Trim(Mid(lsRecdata,82,40)))
			Else /*header */
				ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',Long(Trim(Mid(lsRecdata,64,6))))
				ldsDONotes.SetItem(llNewNotesRow,'line_item_no',0)
				ldsDONotes.SetItem(llNewNotesRow,'note_text',Trim(Mid(lsRecdata,76,40)))
			End IF

			
		Case Else /*Invalid rec type */
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue /*Next Record */
			
	End Choose /*Header or Detail */
	
Next /*file record */

//Copy the notes to the remarks

// 01/10 - PCONKL - There is a bug in the process of copying the NOtes to the remarks. It is only doing a find on the batch-seq_no and not the ord-seq_no. This is causing notes to be applied to the wrong order.
//							I am taking the quick fix and making each order a different batch seq no above.

long ll_edi_batch_seq_no_note[]
string ls_note_text_note[]
integer li_idx, li_array_idx
boolean lb_find_seq_num

IF ldsDONotes.RowCount() > 0 THEN
	
	ldsDONotes.SetSort("edi_batch_seq_no A order_seq_no A")
	ldsDONotes.Sort()
	
	for li_idx = 1 to  ldsDONotes.RowCount()
	
		lb_find_seq_num = false
	
		if UpperBound(ll_edi_batch_seq_no_note) > 0 then
			
			for li_array_idx = 1 to UpperBound(ll_edi_batch_seq_no_note)
			
				if ll_edi_batch_seq_no_note[li_array_idx] =  ldsDONotes.GetItemNumber(li_idx,'edi_batch_seq_no') then
					
					ls_note_text_note[li_array_idx] = ls_note_text_note[li_array_idx] + char(13) + ldsDONotes.GetItemString(li_idx,'note_text')
					
					lb_find_seq_num = true
					
					continue
					
				end if
			
			next
			
		end if
		
		if not lb_find_seq_num  then
			
			ll_edi_batch_seq_no_note[UpperBound(ll_edi_batch_seq_no_note)+1] = ldsDONotes.GetItemNumber(li_idx,'edi_batch_seq_no')
			ls_note_text_note[UpperBound(ll_edi_batch_seq_no_note)] = ldsDONotes.GetItemString(li_idx,'note_text')

		end if
		
	next

	for li_idx = 1 to UpperBound(ll_edi_batch_seq_no_note)
	
		li_find = ldsDOHeader.Find("edi_batch_seq_no=" + string(ll_edi_batch_seq_no_note[li_idx]), 1, ldsDOHeader.RowCount())
		
		if li_find > 0 then
			
			ldsDOHeader.SetItem(li_find, "remark", ls_note_text_note[li_idx])
			
		end if

	next	
	
END IF



//Save Changes
liRC = ldsDOHeader.Update()

If liRC = 1 Then
	liRC = ldsDODetail.Update()
End If

If liRC = 1 Then
	liRC = ldsDOAddress.Update()
End If

If liRC = 1 Then
	liRC = ldsDONotes.Update()
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

public function integer uf_process_itemmaster (string aspath, string asproject);//Process Item Master (IM) Transaction for Maquet


String	lsData, lsTemp, lsLogOut, lsStringData, lsSKU, 	lsCOO, lsSupplier, lsSupplierSave, lsOutString_LMS, lsLMSSKU
			
Integer	liRC,	liFileNo
			
Long		llCount,	llPos, llOwner, llNew, llExist, llNewRow, llFileRowCount, llFileRowPos ,llRecSeq, llNewOutRow

Decimal ldtemp, ldBatchSeq, ldqty, ldWgt

Boolean	lbNew, lbError
DateTime	ldtToday

ldtToday = DateTime(today(),Now())

//u_ds_datastore	idsItem 
//datastore	iu_ds

If Not isvalid(idsItem) Then
	idsItem = Create u_ds_datastore
	//idsItem.dataobject= 'd_item_master'
	idsItem.dataobject= 'd_item_master_w_supp_cd'
	idsItem.SetTransObject(SQLCA)
End If

idsItem.Reset()

If not isvalid(iu_ds) Then
	iu_ds = Create datastore
	iu_ds.dataobject = 'd_generic_import'
End If

iu_ds.Reset()

// 04/08 - PCONKL - For creating LMS records
If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

idsOut.Reset()

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('MAQUET','EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Phoenix!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Open and read the FIle In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master File for Maquet Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = iu_ds.InsertRow(0)
	iu_ds.SetItem(llNewRow,'rec_data',Trim(lsStringData))
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Process each Row
llFileRowCount = iu_ds.RowCount()

llRecSeq = 0

For llFileRowPos = 1 to llFileRowCOunt
	
	// 04/08 - PCONKL - We will build an output update record to LMS and send from here instead of triggering at the end and buiilding
	//							from the database. This will solve the problem of receiving same Item/different Pkg Code in the same sweeper cycle
	//							and only sending one to LMS (since it is the same Item master record in SIMS - we don't care about pkg code)
	
	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	
	
	lsData = Trim(iu_ds.GetITemString(llFileRowPos,'rec_Data'))
	
	If lsData = 'EOF' Then Continue

	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsDAta,Len(lsData) - 1)
	End If
	
	//Validate Rec Type is IM (Ignore if Trailer Record TR)
	lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	If lsTemp = 'IM'  Then
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Validate SKU and retrieve existing or Create new Row
	
	// The SKU may have a 3 char supplier code prefix seperated by #
	
	If Pos(lsData,'|') > 0 Then
	
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		
		//Parse out SKU/Supplier
		If pos(lsTemp,"#") > 1 Then
			lsSupplier = Left(lsTemp,(pos(lsTemp,"#") - 1))
			lsSKU = Mid(lsTemp,(pos(lsTemp,"#") + 1),99999)
		Else
			lsSupplier = 'MAQUET'
			If pos(lsTemp,"#") = 1 Then
				lsSKU = Mid(lsTemp, 2, 99999)
			else
				lsSKU = lsTemp
			end if
		End If
		if lsSKU = '' then 
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Null SKU: Record will not be processed.")
			lbError = True
			continue //dts - 11/08 - Maquet sending a null SKU. Not importing.
		end if
	Else /*error*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
		lbError = True
		Continue
		
	End If
		
	//For LMS Update - If we received it with a supplier, send it back with a supplier (assuming that if we defaulted it, the supplier will be 'Maquet' or existing supplier is numeric
	// always send # as seperator even if not present
	
	If lsSupplier = 'MAQUET' Then
		lsLMSSKU = "#" + lsSKU
	Else
		lsLMSSKU = lsSupplier + "#" + lsSKU
	End If
	
	//Retrieve for SKU - We will be updating across Suppliers
	//llCount = idsItem.Retrieve(asProject, lsSKU)
	llCount = idsItem.Retrieve(asProject, lsSKU, lsSupplier)
		
	If llCount <= 0 Then
			
		//If No Supplier, default to Maquet
		If lsSupplier = "" Then
			
			lsSUpplier = 'MAQUET'
		
		End If
		
		//Validate Supplier
		If lsSupplier <> lsSupplierSave Then
			
			Select Count(*) into :llCount
			From Supplier
			Where Project_id = :asProject and Supp_Code = :lsSupplier;
			
			If llCount < 1 Then
				
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Supplier: '" + lsSupplier + "'. Unable to insert new Item Master without a valid supplier. Record will not be processed.")
				lbError = True
				Continue
				
			End If
			
		End If
		
		llNew ++ /*add to new count*/
		lbNew = True
		llNewRow = idsItem.InsertRow(0)
		idsItem.SetItem(1,'project_id',asProject)
		idsItem.SetItem(1,'SKU',lsSKU)
		
		//Get Default owner for Supplier if Changed
		If lsSupplier <> lsSupplierSave Then
			
			Select owner_id into :llOwner
			From Owner
			Where project_id = :asProject and Owner_type = 'S' and owner_cd = :lsSupplier;
			
		End If
		
		lsSupplierSave = lsSupplier
			
		idsItem.SetItem(1,'supp_code',lsSupplier)
		idsItem.SetItem(1,'owner_id',llOwner)
							
	Else /*exists*/
				
		llexist += llCount /*add to existing Count*/
		lbNew = False
	
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	//Part Type - UF1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		lsTemp = lsData
	End If
	
	For llPos = 1 to idsItem.RowCount()
		idsItem.SetItem(llPos,'User_Field1',left(lsTemp,70))
	Next
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
		
	//Description
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		lsTemp = lsData
	End If
	
	For llPos = 1 to idsItem.RowCount()
		idsItem.SetItem(llPos,'Description',left(lsTemp,70))
	Next
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	//base UOM maps to UOM 1 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	For llPos = 1 to idsItem.RowCount()
		
		If lsTEmp > '' Then
			idsItem.SetItem(llPos,'uom_1',left(lsTemp,4))
		Else 
			idsItem.SetItem(llPos,'uom_1','EA') //Default EA
		End If
						
	Next
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	
	//Standard Cost
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp)) Then /*only map if numeric*/
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'Std_Cost',dec(trim(lsTemp)))
		next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Cycle Count Frequency in Days
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(trim(lsTEmp)) Then /*only map if numeric*/
		ldTemp = Dec(Trim(lsTemp) )
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'cc_freq',Trim(lsTemp))
		Next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//UPC Code
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(lsTEmp) Then /*only map if numeric*/
		ldTemp = Dec(lsTemp) 
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'Part_UPC_Code',ldTemp)
		Next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	

	//Freight Class 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'Freight_Class',left(lsTemp,10))
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Storage Code 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'Storage_Code',left(lsTemp,10))
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	

	//Inventory Class 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'Inventory_Class',left(lsTemp,10))
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Shelf Life in Days
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp)) Then /*only map if numeric*/
		ldTemp = Dec(trim(lsTemp) )
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'Shelf_Life',ldTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		

	//Item Delete Ind
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'item_delete_ind',lsTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Package Code - Mapped to UF 4
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'User_field4',lsTemp)
		Next
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//COO
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'Country_of_Origin_Default',lsTemp)
		Next
	Else /*for new records, if not present, default to 'XXX' */
		If lbNew Then
			For llPos = 1 to idsItem.RowCount()
				idsItem.SetItem(llPos,'Country_of_Origin_Default','XXX')
			Next
		End If
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Serial Tracking Ind
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' and lstemp <> 'N' Then
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'serialized_ind','Y')
		Next
	Else /*for new records, if not present, default to 'N' */
		If lbNew Then
			For llPos = 1 to idsItem.RowCount()
				idsItem.SetItem(llPos,'serialized_ind','N')
			Next
		End If
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Lot Tracking Ind
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' and lstemp <> 'N' Then
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'Lot_Controlled_Ind','Y')
		Next
	Else /*for new records, if not present, default to 'N' */
		If lbNew Then
			For llPos = 1 to idsItem.RowCount()
				idsItem.SetItem(llPos,'Lot_Controlled_Ind','N')
			Next
		End If
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Expiration Tracking Ind
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' and lstemp <> 'N' Then
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'expiration_controlled_ind','Y')
		Next
	Else /*for new records, if not present, default to 'N' */
		If lbNew Then
			For llPos = 1 to idsItem.RowCount()
				idsItem.SetItem(llPos,'expiration_controlled_ind','N')
			Next
		End If
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Weight - Only set if a new record 
	
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp)) and lbNew Then /*only map if numeric*/
		ldTemp = Dec(trim(lsTemp) )
		For llPos = 1 to idsItem.RowCount()
			idsItem.SetItem(llPos,'weight_1',ldTemp)
		Next
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	

	
	//Update any record defaults
	For llPos = 1 to idsItem.RowCount()
		idsItem.SetItem(llPos,'Last_user','SIMSFP')
		idsItem.SetItem(llPos,'last_update',today())
	//	idsItem.SetItem(llPos,'interface_upd_req_Ind','Y') /*Will trigger a refresh to LMS - 04/08 - PCONKL - no need to trigger update - writing here*/
	Next
		
	//If record is new...
	If lbNew Then
			
		idsItem.SetItem(1,'po_controlled_ind','Y') /*tracking by Pkg Code*/
		idsItem.SetItem(1,'po_no2_controlled_ind','N')
		idsItem.SetItem(1,'container_tracking_ind','N') 
		idsItem.SetItem(1,'qa_check_ind','O') 
			
	End If
			
	//Save New Item to DB
	lirc = idsItem.Update()
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Master Record(s) to database! File Row Pos: " + string(llFileRowPos) + ", SKU: " + lsSku
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item Master Record to database! File Row Pos: " + string(llFileRowPos) + ", SKU: " + lsSku)
		Return -1
		Continue
	End If

	//build LMS Update Record - Use existing Item Master datastore that has either been loaded and updated from an existing Item master record or created new from LMS data
		
	llRecSeq ++
	lsOutString_LMS = String(llRecSeq,'000000') /* Record Number*/
	lsOutString_LMS += "PM" /*Record Type */
	lsOutString_LMS += "A" /*Transaction Type*/
	lsOutString_LMS += "MAQ_NJ" /*Warehouse - hardcoded for now as is not relevent to Item Master*/
	lsOutString_LMS += String(ldtToday,'YYYYMMDD') /* Transaction date*/
	lsOutString_LMS += String(ldtToday,'HHMMSS') /* Transaction Time*/
		
	lsOutString_LMS += Left(lsLMSSKU,20) + Space(20 - len(lsLMSSKU))
	
	//Package Code (UF4) 
	If idsItem.GetItemString(1,'User_field4') > "" Then
		lsOutString_LMS +=  Left(idsItem.GetItemString(1,'user_Field4'),6) + Space(6 - len(idsItem.GetItemString(1,'User_field4')))
	Else
		lsOutString_LMS += Space(6)
	End If
	
	//Description
	If idsItem.GetItemString(1,'Description') > "" Then
		lsOutString_LMS +=  Left(idsItem.GetItemString(1,'Description'),30) + Space(30 - len(idsItem.GetItemString(1,'Description')))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Product Class (UF5)
	If idsItem.GetItemString(1,'User_field5') > "" Then
		lsOutString_LMS +=  Left(idsItem.GetItemString(1,'user_Field5'),6) + Space(6 - len(idsItem.GetItemString(1,'User_field5')))
	Else
		lsOutString_LMS += Space(6)
	End If
	
	//Freight Class - must be numeric for LMS
	If idsItem.GetItemString(1,'freight_class') > "" and isnumber(idsItem.GetItemString(1,'freight_class')) Then
		lsOutString_LMS +=  String(Dec(idsItem.GetItemString(1,'freight_class')),'00000000.0')
	Else
		lsOutString_LMS += "00000000.0"
	End If
	
	lsOutString_LMS += "00000000.0000" /*Maximum Qty*/
	lsOutString_LMS += "00000000.0000" /*Minimum Qty*/
	
	//Shelf Life
	If idsItem.GetITemNumber(1, 'shelf_life') > 0 Then
		lsOutString_LMS += String(idsItem.GetITemNumber(1, 'shelf_life'),'00000000')
	Else
		lsOutString_LMS += "00000000"
	end If
		
	//UOM1
	If idsItem.GetItemString(1,'uom_1') > "" Then
		lsOutString_LMS +=  Left(idsItem.GetItemString(1,'uom_1'),3) + Space(3 - len(idsItem.GetItemString(1,'uom_1')))
	Else
		lsOutString_LMS += "EA "
	End If
	
	//UOM2
	If idsItem.GetItemString(1,'uom_2') > "" Then
		lsOutString_LMS +=  Left(idsItem.GetItemString(1,'uom_2'),3) + Space(3 - len(idsItem.GetItemString(1,'uom_2')))
	Else
		lsOutString_LMS += "   "
	End If
	
	//UOM3
	If idsItem.GetItemString(1,'uom_3') > "" Then
		lsOutString_LMS +=  Left(idsItem.GetItemString(1,'uom_3'),3) + Space(3 - len(idsItem.GetItemString(1,'uom_3')))
	Else
		lsOutString_LMS += "   "
	End If
	
	//UOM4
	If idsItem.GetItemString(1,'uom_4') > "" Then
		lsOutString_LMS +=  Left(idsItem.GetItemString(1,'uom_4'),3) + Space(3 - len(idsItem.GetItemString(1,'uom_4')))
	Else
		lsOutString_LMS += "   "
	End If
	
	
	
	//UOM Qty1 - Conversion facfor from UOM2 -> UOM1 (QTY1 is always 1)
	If idsItem.GetITemNumber(1, 'qty_2') > 0  Then
		lsOutString_LMS += String(idsItem.GetITemNumber(1, 'qty_2'),"0000000.00000000")
	Else
		lsOutString_LMS += "0000000.00000000"
	End If
	
	//UOm Qty 2 - Conversion facfor from UOM3 -> UOM2
	If idsItem.GetITemNumber(1, 'qty_3') > 0 and idsItem.GetITemNumber(1, 'qty_2') > 0 Then
		
		ldQty = idsItem.GetITemNumber(1, 'qty_3') / idsItem.GetITemNumber(1, 'qty_2')
		lsOutString_LMS += String(ldQty,"0000000.00000000")
		
	Else
		lsOutString_LMS += "0000000.00000000"
	End If
	
	//UOm Qty 3 Conversion factor from UOM4 -> 3
	If idsItem.GetITemNumber(1, 'qty_4') > 0 and idsItem.GetITemNumber(1, 'qty_3') > 0 Then
		
		ldQty = idsItem.GetITemNumber(1, 'qty_4') / idsItem.GetITemNumber(1, 'qty_3')
		lsOutString_LMS += String(ldQty,"0000000.00000000")
		
	Else
		lsOutString_LMS += "0000000.00000000"
	End If
	
	//Weight 1
	//dts - 10/08 - now converting Wgt to Kilos, if necessary
	
	ldWgt = idsItem.GetItemNumber(1, 'weight_1')
	If ldWgt > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldWgt = ldWgt * 0.45359237
		end if
		lsOutString_LMS += String(ldWgt,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Weight 2
	//dts - 10/08 - now converting Wgt to Kilos, if necessary
	ldWgt = idsItem.GetItemNumber(1, 'weight_2')
	If ldWgt > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldWgt = ldWgt * 0.45359237
		end if
		lsOutString_LMS += String(ldWgt,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Weight 3
	//dts - 10/08 - now converting Wgt to Kilos, if necessary
	ldWgt = idsItem.GetItemNumber(1, 'weight_3')
	If ldWgt > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldWgt = ldWgt * 0.45359237
		end if
		lsOutString_LMS += String(ldWgt,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Weight 4
	//dts - 10/08 - now converting Wgt to Kilos, if necessary
	ldWgt = idsItem.GetItemNumber(1, 'weight_4')
	If ldWgt > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldWgt = ldWgt * 0.45359237
		end if
		lsOutString_LMS += String(ldWgt,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Height 1
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = idsItem.GetItemNumber(1, 'height_1')
	If ldTemp > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Height 2
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = idsItem.GetItemNumber(1, 'height_2')
	If ldTemp > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Height 3
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = idsItem.GetItemNumber(1, 'height_3')
	If ldTemp > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Height 4
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = idsItem.GetItemNumber(1, 'height_4')
	If ldTemp > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Width 1
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = idsItem.GetItemNumber(1, 'Width_1')
	If ldTemp > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Width 2
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = idsItem.GetItemNumber(1, 'Width_2')
	If ldTemp > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Width 3
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = idsItem.GetItemNumber(1, 'Width_3')
	If ldTemp > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Width 4
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = idsItem.GetItemNumber(1, 'Width_4')
	If ldTemp > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
		
	//Length 1
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = idsItem.GetItemNumber(1, 'Length_1')
	If ldTemp > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Length 2
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = idsItem.GetItemNumber(1, 'Length_2')
	If ldTemp > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Length 3
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = idsItem.GetItemNumber(1, 'Length_3')
	If ldTemp > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Length 4
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = idsItem.GetItemNumber(1, 'Length_4')
	If ldTemp > 0 Then
		if idsItem.GetItemString(1, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If	
	
	
	// Write the record for LMS
	llNewOutRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewOutRow,'Project_id', 'MAQUET')
	idsOut.SetItem(llNewOutRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewOutRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewOutRow,'batch_data', lsOutString_LMS)
	idsOut.SetItem(llNewOutRow,'file_name', 'N832' + String(ldBatchSeq,'00000') + '.DAT') 
	
Next /*File row to Process */

w_main.SetMicroHelp("")

lsLogOut = Space(10) + String(llNew) + ' Item Records were successfully added and ' + String(llExist) + ' Records were updated.'
FileWrite(gilogFileNo,lsLogOut)

Destroy idsItem

//Send updates to LMS
// 04/08 - PCONKL - sending update from data processed instead of reloading from DB
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'MAQUET')

//u_nvo_edi_confirmations_maquet	luMaquet
//luMaquet = Create u_nvo_edi_confirmations_maquet
//luMaquet.uf_lms_itemmaster()



If lbError then
	Return -1
Else
	Return 0
End If


end function

protected function integer uf_process_po (string aspath, string asproject);
Datastore	lu_ds, ldsItem

String	lsLogout,lsStringData, lsOrder, lsWarehouse, lsTemp, lsREcData, lsRecType, lsDesc, lsSKU, lsSupplier
Integer	liRC,liFileNo
Long	llNewRow, llNewDetailRow, llFindRow, llBAtchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llOwnerID
Boolean	lbError, lbDetailError
DateTime	ldtToday
Decimal	ldWeight, ldLineItemNo
String 	lsOrderNo
string lsFileWH //WH Now coming in file (but still defaulting WH if absent in file)

ldtToday = DateTime(Today(),Now())

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master'
ldsItem.SetTransObject(SQLCA)

If Not isvalid(idsPOHeader) Then
	idsPOheader = Create u_ds_datastore
	idsPOheader.dataobject= 'd_po_header'
	idsPOheader.SetTransObject(SQLCA)
End If

If Not isvalid(idsPOdetail) Then
	idsPOdetail = Create u_ds_datastore
	idsPOdetail.dataobject= 'd_po_detail'
	idsPOdetail.SetTransObject(SQLCA)
End If

//Open and read the File In
lsLogOut = '      - Opening File for Maquet Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Maquet Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',Trim(lsStringData)) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Warehouse defaulted from project master default warehouse - only need to retrieve once
// dts 08/25/08 - WH now coming in field 6 in PM record (still using default if absent from file)
Select wh_code into :lsWarehouse
From Project
Where Project_id = :asProject;

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Process Each Record in the file..

//Process each row of the File
llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	lsrecData = Trim(lu_ds.GetITemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsREcType)
			
		Case 'PM' /*PO Header*/
			
			llNewRow = 	idsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			idsPOheader.SetItem(llNewRow,'project_id',upper(asProject))
			idsPOheader.SetItem(llNewRow,'wh_code',lsWarehouse)
			idsPOheader.SetItem(llNewRow,'Request_date',String(Today(),'YYMMDD'))
			idsPOheader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPOheader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			idsPOheader.SetItem(llNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			idsPOheader.SetItem(llNewRow,'Status_cd','N')
			idsPOheader.SetItem(llNewRow,'Last_user','SIMSEDI')
		
			idsPOheader.SetItem(llNewRow,'Order_type','S') /*Supplier Order*/
			idsPOheader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
					
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
		
			//Action Code - 			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'ACtion Code' field. Record will not be processed.")
			End If
						
			idsPOheader.SetItem(llNewRow,'action_cd',lstemp) 
		
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
								
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsOrderNo = lsTemp
			idsPOheader.SetItem(llNewRow,'order_no',Trim(lsTemp))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//No more required fields after Supplier
			
			//Supplier  - Supplier is not present on the header. Will load from first detail
			// dts 09/15/08 Now getting Supplier from Detail record - Single PO may have multiple 'suppliers' (Prefix to SKU)
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
		
//			If lsTemp > '' Then
//				lsSupplier = lsTemp /*used to build item master below if necessary*/
//				idsPOheader.SetITem(llNewRow,'supp_code',lsTemp)
//			Else
//				idsPOheader.SetITem(llNewRow,'supp_code','MAQUET') /*default to Maquet - not currently being sent on file */
//			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Expected Arrival Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'Arrival_Date',lsTemp)
			
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Warehouse - Needs to be translated into the SIMS WH Code
			//Currently defaulting warehouse
			// dts 08/25/08 - WH now coming in field 6 in PM record (still using default if absent from file)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
				
//			Select warehouse.wh_Code into :lsWarehouse
//			From Warehouse, Project_warehouse
//			Where warehouse.wh_Code = project_warehouse.wh_Code and project_id = :asProject and User_Field1 = :lsTemp;
//			
//
//			If lsWarehouse = "" Then
//				lbError = True
//				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse: '" + lsTemp + "'. Order will not be processed.") 
//			End If
//			
			If lsTemp = "" Then
				lsFileWH = lsWarehouse
			else
				Select warehouse.wh_Code into :lsFileWH
				From Warehouse, Project_warehouse
				Where warehouse.wh_Code = project_warehouse.wh_Code and project_id = :asProject
				and User_Field1 = :lsTemp;

				If lsFileWH = "" Then
					lbError = True
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse (see Wh.UF1): '" + lsTemp + "'. Order will not be processed.") 
				else
					idsPOheader.SetItem(llNewRow, 'wh_Code', lsFileWH)
				End If
			End If
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Carrier
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'Carrier',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//AWB
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'Awb_bol_no',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Transport Mode
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'transport_mode',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Remarks
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'remark',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
				
		CASE 'PD' /* detail*/
			
			lbDetailError = False
			llNewDetailRow = 	idsPODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			idsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
				
			//ACtion Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'ACtion Code' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'action_cd',lsTemp) 
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
		
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Number' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			//Make sure we have a header for this Detail...
			If idsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'",1,idsPoHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
				lbDetailError = True
			End If
			
			idsPODetail.SetItem(llNewDetailRow,'Order_No',Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Line Item Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Line Item Number' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			If Not isnumber(lsTemp) Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - 'Line Item' is not numeric. Record will not be processed.")
				lbDetailError = True
			Else
				idsPODetail.SetItem(llNewDetailRow,'line_item_no',Dec(Trim(lsTemp)))
			End If
		
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

		
			//SKU - Supplier concatonated at beginning with # (supplier#SKU)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Upper(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			If Pos(lsTemp,'#') > 1 Then
				lsSupplier = Left(lstemp, (Pos(lsTemp,'#') - 1))
				lsSKU = Mid(lsTemp,(Pos(lsTemp,'#') + 1),99999)
			Else				
				lsSupplier = 'MAQUET'
				If Pos(lsTemp, '#') = 1 Then
					lsSKU = Mid(lsTemp, 2, 99999)
				else					
					lsSKU = lsTemp /*used to build itemmaster below*/
				end if
			End If
			
			idsPODetail.SetItem(llNewDetailRow,'SKU',lsSKU)
			idsPODetail.SetItem(llNewDetailRow, 'supp_code', lsSupplier) // dts - 09/15/08
		
			//If first row for the order, set the supplier on the header - not set from PM
			If llLineSeq = 1 Then
				idsPOheader.SetITem(llNewRow,'supp_code',lsSupplier)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Qty
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
		
			idsPODetail.SetItem(llNewDetailRow,'quantity',Trim(lsTemp)) /*checked for numerics in nvo_process_files.uf_process_purcahse_Order*/
							
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
		// *** No more required fields...
		
			//Inventory Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			If lsTemp > '' Then /*override default if present*/	
				idsPODetail.SetItem(llNewDetailRow,'Inventory_Type',lsTemp)
			End If
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Alternate SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'Alternate_SKU',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//lot No (LPN)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'Lot_no',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//PO NO - We will be mapping PKG Code below to PO_NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
		//	idsPODetail.SetItem(llNewDetailRow,'PO_NO',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'po_no2',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Serial No
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'Serial_No',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Expiration date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
		//	idsPODetail.SetItem(llNewDetailRow,'expiration_date',dateTime(lsTemp))
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			//Maquet Division ("package Code") -> to PO_NO (above)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'po_no',lsTemp)
			
			
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//If detail errors, delete the row...
			if lbDetailError Then
				lbError = True
				idsPoDetail.DeleteRow(llNewDetailRow)
				Continue
			End If
				
			//We may receive a detail row for a new sku/supplier combination. If we have the sku for another supplier and this supplier is also valid, copy existing item to new supplier
			llCount = ldsItem.Retrieve(asProject, lsSKU)
			If llCount > 0 Then
				
				llFindRow = ldsItem.Find("Upper(Supp_code) = '" + upper(lsSupplier) + "'",1,ldsItem.RowCount())
				If llFindRow = 0 Then /*doesnt exist for this supplier*/
					
					//validate Supplier and if valid, create an item for the new supplier
					Select Count(*) into :llCount
					From Supplier
					Where Project_id = :asProject and supp_code = :lsSupplier;
					
					If llCount > 0 Then
						
						//Get Owner for this supplier
						Select Owner_id into :llOwnerID
						From Owner
						Where Project_id = :asProject and Owner_type = 'S' and owner_cd = :lsSUpplier;
						
						If ldsItem.RowsCopy(ldsItem.RowCount(),ldsItem.RowCount(),Primary!,ldsItem,99999,Primary!) = 1 Then
							
							ldsItem.SetItem(ldsitem.RowCount(),'supp_code',lsSupplier)
							ldsItem.SetItem(ldsitem.RowCount(),'owner_id',llOwnerID)
							ldsItem.SetItem(ldsitem.RowCount(),'last_update',ldtToday)
							ldsItem.SetItem(ldsitem.RowCount(),'last_user','SIMSFP')
							lirc = ldsItem.Update()
							If liRC = 1 then
								Commit;
							Else
								Rollback;
							End If
							
						End If
						
					End If /*valid supplier*/
					
				End If  /*doesnt exist for this supplier*/
				
			End If /*Item exists for some supplier*/
			
		CAse Else /* Invalid Rec Type*/
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
			Continue
		
	End Choose /*record Type*/
	
Next /*File record */
	
//Save the Changes 
lirc = idsPOHeader.Update()
	
If liRC = 1 Then
	liRC = idsPODetail.Update()
End If
	
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

on u_nvo_proc_maquet.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_maquet.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

