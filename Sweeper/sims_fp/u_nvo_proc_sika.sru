HA$PBExportHeader$u_nvo_proc_sika.sru
$PBExportComments$Process Sika files
forward
global type u_nvo_proc_sika from nonvisualobject
end type
end forward

global type u_nvo_proc_sika from nonvisualobject
end type
global u_nvo_proc_sika u_nvo_proc_sika

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				iu_DS
				
u_ds_datastore	idsItem 

				



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
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
		
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

public function integer uf_process_dboh (string asinifile);// uf_process_dboh
//Process the SIKA Daily Balance on Hand Confirmation File
//(modeled after Maquet, Oct '07)

Datastore	ldsOut, ldsboh
				
Long			llRowPos, llRowCount, llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsWarehouse, lsWarehouseSave, lsSIKAWarehouse, lsFileName, sql_syntax, Errors, lsFileNamePath

Decimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

// pvh 03.16.06
constant string lsSpaces = Space(10)

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

lsNextRunDate = ProfileString(asIniFile, 'SIKA', 'DBOHNEXTDATE','')
lsNextRunTime = ProfileString(asIniFile, 'SIKA', 'DBOHNEXTTIME','')
If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
	Return 0
Else /*valid date*/
	ldtNextRunTime = DateTime(Date(lsNextRunDate), Time(lsNextRunTime))
	If ldtNextRunTime > dateTime(today(), now()) Then /*not yet time to run*/
		Return 0
	End If
End If

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

//Create the BOH datastore
ldsboh = Create Datastore
//sql_syntax = "SELECT Content_summary.wh_Code,Content_summary.supp_Code, Content_summary.SKU,  Content_summary.inventory_type, Content_summary.Lot_No, Content_summary.po_No, Sum( Content_Summary.Avail_Qty  ) + Sum( Content_Summary.alloc_Qty  ) as total_qty" 
sql_syntax = "SELECT wh_Code, SKU, inventory_type, Lot_No, Sum(Avail_Qty) + Sum(alloc_Qty) as total_qty" 
sql_syntax += " From Content_summary "
sql_syntax += " Where Project_ID = 'SIKA' "
sql_syntax += " Group By wh_Code, Sku, Inventory_type, Lot_No"
sql_syntax += " Having Sum(Avail_Qty) + Sum(alloc_Qty) > 0; "
ldsBOH.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for SIKA Balance on Hand Extract.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsboh.SetTransObject(SQLCA)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: SIKA Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile, 'SIKA', "project", "")

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no('SIKA', 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No', ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrieve next available sequence number for SIKA BOH confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrieve the BOH Data
lsLogout = 'Retrieving Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsBOH.Retrieve(lsProject)
ldsBOH.SetSort("wh_code A, sku A")
ldsBOH.Sort()

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '|'
lsLogOut = 'Processing Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCount
	
	// If Warehouse Changes, retrieve SIKA code value (for LMS)
	lsWarehouse = ldsboh.GetItemString(llRowPos, 'wh_code')
	If lsWarehouse <> lsWarehouseSave Then
		Select User_field1 into :lsSIKAWarehouse
		From Warehouse
		where wh_code = :lsWarehouse;
		
		If isNull(lsSIKAWarehouse) or lsSIKAWarehouse = "" Then lsSIKAWarehouse = lsWarehouse
		lsWarehouseSave = lsWarehouse		
	End If
			
	llNewRow = ldsOut.InsertRow(0)
	lsOutString = 'BH|' /*rec type = balance on Hand Confirmation*/
	lsOutString+= lsSikaWarehouse + "|"
	lsOutString += ldsboh.GetItemString(llRowPos, 'inventory_Type') + "|"
	lsOutString += ldsBOH.GetItemString(llRowPos, 'sku') + "|"
	lsOutString += string(ldsboh.GetItemNumber(llRowPos, 'total_qty')) + "|"
//	lsOutString += left(ldsboh.GetItemString(llRowPos,'po_no'),30) + "|" /* Package Code */
	lsOutString += "NA" + "|" /* Package Code? The 846 map for ICC requires a value, so using NA (though 'CRAP' would be a better choice)*/
		
	If ldsboh.GetItemString(llRowPos, 'lot_no') <> '-' Then
		lsOutString += left(ldsboh.GetItemString(llRowPos, 'lot_no'), 30)  /* Lot Number */
	Else
		lsOutString += ""
	End If
		
	ldsOut.SetItem(llNewRow, 'Project_id', "SIKA")
	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	lsFileName = 'N846' + String(ldBatchSeq, '00000') + '.DAT'
	ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
		
next /*next output record */

If ldsOut.RowCount() > 0 Then /*Don't send an empty file */
	
	//Add a trailer
	llNewRow = ldsOut.insertRow(0)
	ldsOut.SetItem(llNewRow, 'Project_id', "SIKA")
	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow, 'batch_data', "EOF")
	lsFileName = 'N846' + String(ldBatchSeq,'00000') + '.DAT'
	ldsOut.SetItem(llNewRow, 'file_name', lsFileName)

	//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut, "SIKA")

End If

/* dts - 05/22/08 -  Now also e-mailing the 846 */
lsFileNamePath = ProfileString(asInifile, lsProject, "archivedirectory","") + '\' + lsFileName
gu_nvo_process_files.uf_send_email("SIKA", "BOHEMAIL", "SIKA Daily Balance On Hand - Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the SIKA Balance On Hand Report, run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile, 'SIKA', 'DBOHFREQ', '')
If isnumber(lsRunFreq) Then
	//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
	ldtNextRunDate = relativeDate(today(), Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile, 'SIKA', 'DBOHNEXTDATE', String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile, 'SIKA', 'DBOHNEXTDATE', '')
End If

Return 0
end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files (940) for Sika (modeled after Maquet)

Datastore	ldsDOHeader, ldsDODetail, lu_ds, ldsDOAddress, ldsDONotes
				
String		lsLogout,lsRecData,lsTemp,	lswarehouse, lsErrText,	 lsSKU,	lsRecType,	&
				lsSoldToAddr1, lsSoldToAddr2, lsSoldToAddr3, lsSoldToAddr4, lsSoldToStreet,	&
				lsSoldToZip, lsSoldToCity, lsSoldToState, lsSoldToCountry, lsSoldToTel, lsDate, ls_invoice_no, ls_Note_Type, &
				ls_search,lsNotes,ls_temp, lsCommentDest

Integer		liFileNo,liRC, li_line_item_no, liSeparator
				
Long			llRowCount,	llRowPos,llNewRow, llNewDetailRow ,llOrderSeq,	llBatchSeq,	llLineSeq,llCount,		&
				llCONO, llRoNO, llLineItemNo, llOwner, llNewAddressRow, llNewNotesRow, li_find
				
Decimal		ldQty, ldPrice
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError, lbSoldToAddress 
string		lsBT_Address[ ] //last three BT Notes are City,State,Zip. Up to 4 other lines.
string		lsBOLNotes[], lsBOLNote //capture BOL Notes to write to Remark field (& possibly Shipping_Instructions)
string 		lsInvoice, lsPrevInvoice, lsCustNum, lsPrevInvoice_Detail
integer 		i, liBTAddr, liBOLNote

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
ldsDOAddress.dataobject = 'd_mercator_do_address' //Delivery_Alt_Address
ldsDOAddress.SetTransObject(SQLCA)

ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes'
ldsDONotes.SetTransObject(SQLCA)
 //SELECT Delivery_Notes_ID, Delivery_Notes.Project_ID, EDI_Batch_Seq_No, Order_Seq_No, 
 //space(30) as Invoice_no, Line_Item_No, Note_Type, Note_seq_no, Note_Text
 //FROM Delivery_Notes   

//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for SIKA Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo, lsRecData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',lsRecData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = lu_ds.RowCount()

//Process each Row
For llRowPos = 1 to llRowCount
	lsRecData = lu_ds.GetItemString(llRowPos, 'rec_data')
		
	//Process header, Detail, or header/line notes */
	lsRecType = Upper(Mid(lsRecData,7,2))
	Choose Case lsRecType
		//HEADER RECORD
		Case 'OM' /* Header */
			llnewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
		//Record Defaults
			ldsDOHeader.SetItem(llNewRow,'Action_cd','A') /*always a new Order*/
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
			Select W.wh_Code into :lsWarehouse
			From Warehouse W, Project_warehouse PW
			Where W.wh_Code = PW.wh_Code and project_id = :asProject and User_Field1 = :ls_temp;
			If lsWarehouse > '' Then
				ldsDOHeader.SetItem(llNewRow,'wh_code',lswarehouse) 
			Else
				ldsDOHeader.SetItem(llNewRow,'wh_code',Trim(Mid(lsRecdata,10,6))) /* 04/06 - PCONKL - set to invalid WH from file*/
			End If
			//ldsDOHeader.SetItem(llNewRow, 'invoice_no', Trim(Mid(lsRecData, 30, 30))) /*Order Number*/
			/*Order Number carries SIKA Order plus (LMS?) Picker Number, separated by a '~' */
			lsTemp = Trim(Mid(lsRecData, 30, 30))
			liSeparator = pos(lstemp, '~~') // the 2nd '~' is required as ~ is the escape character for special chars
			If liSeparator > 0 Then 
				ldsDOHeader.SetItem(llNewRow, 'Invoice_no', Left(lsTemp, liSeparator - 1))
				lsInvoice = Left(lsTemp, liSeparator - 1)
				ldsDOHeader.SetItem(llNewRow, 'User_Field8', Mid(lsTemp, liSeparator + 1, 99999)) //Picker Number
			Else
				ldsDOHeader.SetItem(llNewRow, 'invoice_no', lsTemp)
				lsInvoice = lsTemp
			End If
			
			if lsInvoice <> lsPrevInvoice and llNewRow > 1 then
				lsPrevInvoice = lsInvoice
				/* load Bill-To Address info and BOL Notes for previous Order...
				   - BT Address is coming in as a series of Notes
					  - we'll capture them in lsBT_Address array and then
					    write them to ldsDOAddress when done with the order.
				     - last three BT Notes are City,State,Zip. Up to 4 other lines.
					- BOL Notes are being written to Notes table and Header-level notes 
					  are writen to Remark field as well (so they are visible in w_do)
				*/
				//liLast = Upperbound(lsBT_Address)
				if liBTAddr > 0 then
					llNewAddressRow = ldsDOAddress.InsertRow(0)
					ldsDOAddress.SetItem(llNewAddressRow, 'project_id', asProject) /*Project ID*/
					ldsDOAddress.SetItem(llNewAddressRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
					ldsDOAddress.SetItem(llNewAddressRow, 'order_seq_no', llOrderSeq - 1) //we're on next order now (but setting BT Address for previous order)...
					ldsDOAddress.SetItem(llNewAddressRow, 'address_type', 'BT') /* Bill To Address */
					ldsDOAddress.SetItem(llNewAddressRow, 'address_1', lsBT_Address[1]) /*Bill To Name - using Address_1 because it's 40 chars instead of 20*/
					if liBTAddr > 4 then ldsDOAddress.SetItem(llNewAddressRow, 'address_2', lsBT_Address[2]) /* BT Addr 1*/
					if liBTAddr > 5 then ldsDOAddress.SetItem(llNewAddressRow, 'address_3', lsBT_Address[3]) /* BT Addr 1*/
					if liBTAddr > 6 then ldsDOAddress.SetItem(llNewAddressRow, 'address_4', lsBT_Address[4]) /* BT Addr 2*/
					//if liBTAddr > 7 then ldsDOAddress.SetItem(llNewAddressRow, 'address_4', lsBT_Address[5]) /* BT Addr 3*/
					if liBTAddr > 2 then ldsDOAddress.SetItem(llNewAddressRow, 'City', lsBT_Address[liBTAddr - 2]) /* BT City */
					if liBTAddr > 1 then ldsDOAddress.SetItem(llNewAddressRow, 'State', lsBT_Address[liBTAddr - 1]) /*BT State */
					ldsDOAddress.SetItem(llNewAddressRow, 'Zip', lsBT_Address[liBTAddr]) /*Bill To Zip */
					//ldsDOAddress.SetItem(llNewAddressRow, 'Country', Trim(Mid(lsRecdata, 713, 20))) /* BT Country */
					//ldsDOAddress.SetItem(llNewAddressRow, 'tel', Trim(Mid(lsRecdata, 733, 20))) /*BT Phone*/
					for i = 1 to liBTAddr
						lsBT_Address[i] = ''
					next
					liBTAddr = 0
				end if
				//load BOL Header Notes into DM.Remark (and DM.Shipping_Instructions if > 250 chars)
				if liBolNote > 0 then
					lsBOLNote = lsBOLNotes[1]
					for i = 2 to liBOLNote
						//build sting of bol notes from array lsBOLNotes[]
						lsBOLNote += ' ' + lsBOLNotes[i]
						//	messagebox("TEMPO-1, Len: " + string(len(lsBOLNote)), lsBOLNOte)
					next
					//We're setting Remark for the previous order (so llNewRow - 1)
					ldsDOHeader.SetItem(llNewRow - 1, 'remark', left(lsBOLNote, 250))
					if len(lsBOLNote) > 250 then
						ldsDOHeader.SetItem(llNewRow, 'shipping_instructions_text', mid(lsBOLNote, 251, 250)) 
					end if
					liBOLNote = 0
				end if
					
			end if			
			
			ldsDOHeader.SetItem(llNewRow, 'User_field2', Trim(Mid(lsRecData, 60, 4))) /*Order Type - UF 2 - Order # + Plus order Type = Unique order # for LMS*/
			ldsDOHeader.SetItem(llNewRow, 'Carrier', Trim(Mid(lsRecData, 92, 15))) 
			ldsDOHeader.SetItem(llNewRow, 'User_Field1', Trim(Mid(lsRecData, 92, 15))) /*dts - PackList prints UF1 in 'Carrier/Service lvl' ?Used for Sika*/
			ldsDOHeader.SetItem(llNewRow, 'User_field3', Trim(Mid(lsRecData,129, 12))) /*End Leg Carrier for Master Load (Group Code 2) ?Used for Sika*/
			ldsDOHeader.SetItem(llNewRow, 'User_field9', Trim(Mid(lsRecData, 201, 10))) /*Stop Sequence*/
			ldsDOHeader.SetItem(llNewRow, 'Priority', Trim(Mid(lsRecData, 211, 3))) /*Priority*/
			ldsDOHeader.SetItem(llNewRow, 'User_field4', Trim(Mid(lsRecData, 224, 15))) /*LMS Shipment*/
			ldsDOHeader.SetItem(llNewRow, 'awb_bol_no', Trim(Mid(lsRecData, 224, 15))) /*LMS Shipment*/
			ldsDOHeader.SetItem(llNewRow, 'User_field5', Trim(Mid(lsRecData, 239, 15))) /*LMS Master Shipment*/
			
			//Huh? lsTemp = Trim(Mid(lsRecData, 24, 8))
			//Huh? lsDate = Mid(lsTemp, 5, 2) + '/' + Right(lsTemp, 2) + '/' + Left(lsTemp, 4)
			
			/* Schedule Date - reformat to mm/dd/yyyy */
			lsTemp = Trim(Mid(lsRecData, 288, 8))
			lsDate = Mid(lsTemp, 5, 2) + '/' + Right(lsTemp, 2) + '/' + Left(lsTemp, 4)
			ldsDOHeader.SetItem(llNewRow, 'Schedule_Date', lsDate) 
			
			/*Request Date*/
			lsTemp = Trim(Mid(lsRecData, 296, 8))
			lsDate = Mid(lsTemp, 5, 2) + '/' + Right(lsTemp, 2) + '/' + Left(lsTemp, 4)
			ldsDOHeader.SetItem(llNewRow, 'Request_Date', lsDate) 
			
			//12/26/07 ldsDOHeader.SetItem(llNewRow, 'User_field5', Trim(Mid(lsRecData, 304, 2)))
			/* Freight Terms - Prepaid or Collect - LMS is sending a 2-char code */
			lsTemp = Trim(Mid(lsRecData, 304, 2))
			choose case lsTemp
				case 'PP', 'PA'
					lsTemp = 'PREPAID'
				case 'CC', 'CA'
					lsTemp = 'COLLECT'
			end choose
			ldsDOHeader.SetItem(llNewRow, 'Freight_Terms', lsTemp) /*Freight Terms - Prepaid or Collect ?Need to translate?*/

			ldsDOHeader.SetItem(llNewRow, 'Order_no', Trim(Mid(lsRecData, 773, 30))) /*Cust Order No*/
			
			/* 01/07/08 - Day 1, Cust_Code is not coming in at the header (in Ship-to Customer Number)
			              but instead coming in User Code 2 at the line level (see below)
			ldsDOHeader.SetItem(llNewRow, 'Cust_Code', Trim(Mid(lsRecData, 803, 15))) /*Cust Code*/		
			
			//cust code may not be present...
			If isnull(ldsdoheader.GetItemString(llNewRow, 'Cust_Code')) or ldsdoheader.GetItemString(llNewRow, 'Cust_Code') = '' Then
				ldsDOHeader.SetItem(llNewRow, 'Cust_Code', 'N/A')
			End If
			*/
			
			ldsDOHeader.SetItem(llNewRow, 'Cust_Name', Trim(Mid(lsRecData, 818, 40))) /*Cust Name*/
			ldsDOHeader.SetItem(llNewRow, 'Address_1', Trim(Mid(lsRecData, 978, 40))) /*Ship to Addr 1*/
			ldsDOHeader.SetItem(llNewRow, 'Address_2', Trim(Mid(lsRecData, 1018, 40))) /*Ship to Addr 2*/
			ldsDOHeader.SetItem(llNewRow, 'Address_3', Trim(Mid(lsRecData, 1058, 40))) /*Ship to Addr 3*/
			ldsDOHeader.SetItem(llNewRow, 'City', Trim(Mid(lsRecData, 1098, 35))) /*Ship to City*/
			ldsDOHeader.SetItem(llNewRow, 'State', Trim(Mid(lsRecData, 1168, 2))) /*Ship to State 1*/
			ldsDOHeader.SetItem(llNewRow, 'Zip', Trim(Mid(lsRecData, 1170, 10))) /*Ship to Zip*/
			ldsDOHeader.SetItem(llNewRow, 'Country', Trim(Mid(lsRecData, 1180, 20))) /*Ship to country*/
			ldsDOHeader.SetItem(llNewRow, 'tel', Trim(Mid(lsRecData, 1200, 20))) /*Ship to Tel*/
		
			//If we have Bill to, or Interim Dest Addresses, we will build alt address records
		 				
			//Bill To
			/* SIKA is sending Bill-To Address in as Notes (with note type 'ADR...')
			 - See Notes Processing....
					If Trim(Mid(lsRecData, 306, 445)) > '' Then
						llNewAddressRow = ldsDOAddress.InsertRow(0)
						ldsDOAddress.SetItem(llNewAddressRow, 'project_id', asProject) /*Project ID*/
						ldsDOAddress.SetItem(llNewAddressRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
						ldsDOAddress.SetItem(llNewAddressRow, 'order_seq_no', llOrderSeq) 
					
						ldsDOAddress.SetItem(llNewAddressRow, 'address_type', 'BT') /* Bill To Address */
						ldsDOAddress.SetItem(llNewAddressRow, 'Name', Trim(Mid(lsRecdata, 336, 15))) /*Bill To Number*/
						ldsDOAddress.SetItem(llNewAddressRow, 'address_1', Trim(Mid(lsRecdata, 351, 40))) /* Bill To Cust Name*/
						ldsDOAddress.SetItem(llNewAddressRow, 'address_2', Trim(Mid(lsRecdata, 511, 40))) /* BT Addr 1*/
						ldsDOAddress.SetItem(llNewAddressRow, 'address_3', Trim(Mid(lsRecdata, 551, 40))) /*BT addr 2*/
						ldsDOAddress.SetItem(llNewAddressRow, 'address_4', Trim(Mid(lsRecdata, 591, 40))) /*BT addr 3*/
						ldsDOAddress.SetItem(llNewAddressRow, 'City', Trim(Mid(lsRecdata, 631, 35))) /* BT City */
						ldsDOAddress.SetItem(llNewAddressRow, 'State', Trim(Mid(lsRecdata, 701, 2))) /*BT State */
						ldsDOAddress.SetItem(llNewAddressRow, 'Zip', Trim(Mid(lsRecdata, 703, 10))) /*Bill To Zip */
						ldsDOAddress.SetItem(llNewAddressRow, 'Country', Trim(Mid(lsRecdata, 713, 20))) /* BT Country */
						ldsDOAddress.SetItem(llNewAddressRow, 'tel', Trim(Mid(lsRecdata, 733, 20))) /*BT Phone*/
					End If /*Bill To address exists*/
					*/
			
			/* TEMPO - Notes? (still part of OM record)
			Routing Comment 1	O	1838
			Routing Comment 2	O	1868
			Routing Comment 3	O	1898
			Routing Comment 4	O	1928
			Routing Comment 5	O	1958
			*/
			
			//Intermediate Dest
			//If Trim(Mid(lsRecData, 306, 445)) > '' Then
			If Trim(Mid(lsRecData, 1988, 370)) > '' Then
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetITem(llNewAddressRow, 'project_id', asProject) /*Project ID*/
				ldsDOAddress.SetItem(llNewAddressRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
				ldsDOAddress.SetItem(llNewAddressRow, 'order_seq_no', llOrderSeq) 
			
				ldsDOAddress.SetItem(llNewAddressRow, 'address_type', 'ID') /*Intermediate Dest*/
				ldsDOAddress.SetItem(llNewAddressRow, 'Name', Trim(Mid(lsRecdata, 1988, 40))) 
				ldsDOAddress.SetItem(llNewAddressRow, 'address_1', Trim(Mid(lsRecdata, 2148, 40))) 
				ldsDOAddress.SetItem(llNewAddressRow, 'address_2', Trim(Mid(lsRecdata, 2188, 40))) 
				ldsDOAddress.SetItem(llNewAddressRow, 'address_3', Trim(Mid(lsRecdata, 2228, 40)))
				ldsDOAddress.SetItem(llNewAddressRow, 'City', Trim(Mid(lsRecdata, 2268, 35))) 
				ldsDOAddress.SetItem(llNewAddressRow, 'State', Trim(Mid(lsRecdata, 2338, 2))) 
				ldsDOAddress.SetItem(llNewAddressRow, 'Zip', Trim(Mid(lsRecdata, 2340, 10))) 
				ldsDOAddress.SetItem(llNewAddressRow, 'Country', Trim(Mid(lsRecdata, 2350, 20))) 
			End If /*Intemediate Dest address exists*/
			
			
		// DETAIL RECORD
		Case 'OD' /*Detail */
			llNewDetailRow = ldsDODetail.InsertRow(0)
			llLineSeq ++
		//Add detail level defaults
			ldsDODetail.SetItem(llNewDetailRow, 'project_id', asproject) /*project*/
			ldsDODetail.SetItem(llNewDetailRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			ldsDODetail.SetItem(llNewDetailRow, 'order_seq_no', llOrderSeq) 
			ldsDODetail.SetItem(llNewDetailRow, "order_line_no", string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'N')
			//ldsDODetail.SetItem(llNewDetailRow, 'Inventory_type', 'N') /*normal inventory*/
				
		//From File
			ls_temp = Trim(Mid(lsRecdata, 30, 30))
			//ldsDODetail.SetItem(llNewDetailRow, 'invoice_no', Trim(Mid(lsRecdata, 30, 30))) 
			/*Order Number carries SIKA Order plus (LMS?) Picker Number, separated by a '~' */
			lsTemp = Trim(Mid(lsRecData, 30, 30))
			liSeparator = pos(lstemp, '~~') // the 2nd '~' is required as ~ is the escape character for special chars
			If liSeparator > 0 Then 
				ldsDODetail.SetItem(llNewDetailRow, 'Invoice_no', Left(lsTemp, liSeparator - 1))
				lsInvoice = Left(lsTemp, liSeparator - 1)
				//?do we need to match on Order+Picker? ldsDODetail.SetItem(llNewDetailRow, 'User_Field8', Mid(lsTemp, liSeparator + 1, 99999))
			Else
				ldsDODetail.SetItem(llNewDetailRow, 'invoice_no', lsTemp)
				lsInvoice = lsTemp
			End If

			ldsDODetail.SetItem(llNewDetailRow, 'line_item_no', Long(Trim(Mid(lsRecdata, 64, 6)))) //LMS Line ==> Line_Item_No
			ldsDODetail.SetItem(llNewDetailRow, 'SKU', Trim(Mid(lsRecdata, 70, 20)))
			ldsDODetail.SetItem(llNewDetailRow, 'po_no', Trim(Mid(lsRecdata, 90, 6)))	/* Package Code -> PO_NO (for Maquet, not SIKA?)*/
			ldsDODetail.SetItem(llNewDetailRow, 'lot_no', Trim(Mid(lsRecdata, 100, 15))) //12/13/07
//messagebox("TEMPO! - LOT", Trim(Mid(lsRecdata, 100, 15)))
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field3', Trim(Mid(lsRecdata, 115, 15))) /* Customer Part # is coming over in 'User Code 1' in DMA */
			lsCustNum = Trim(Mid(lsRecdata, 130, 15)) /* Customer # is coming over in 'User Code 1' (at the Detail level!) */
			if lsInvoice <> lsPrevInvoice_Detail then
				//set Customer Code on Header...
				//messagebox("TEMPO! Invoice:" + lsInvoice, "Setting Cust_Code: " + lsCustNum)
				if lsCustNum <> '' then
					ldsDOHeader.SetItem(llNewRow, 'Cust_Code', lsCustNum)
				else
					ldsDOHeader.SetItem(llNewRow, 'Cust_Code', 'N/A')
				end if
				lsPrevInvoice_Detail = lsInvoice
			end if
			ldsDODetail.SetItem(llNewDetailRow, 'quantity', Trim(Mid(lsRecdata, 203, 12)))
			ldsDODetail.SetItem(llNewDetailRow, 'uom', Trim(Mid(lsRecdata, 215, 6)))
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field1', Trim(Mid(lsRecdata, 241, 10))) /* customer Order */
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field2', Trim(Mid(lsRecdata, 251, 10))) /* dts - Customer Line Number -> */
			ldsDODetail.SetItem(llNewDetailRow, 'price', Trim(Mid(lsRecdata, 270, 8)))		
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field4', Trim(Mid(lsRecdata, 328, 15))) /* UPC Code */
							
		Case 'OC', 'DC' /* Header/Line Notes*/
			IF lsRecType = 'OC' THEN
				lsCommentDest = Trim(Mid(lsRecdata, 70, 6)) 
				/* 6-char Y/N flags
					Per Tom Leap:
					Flag 1 = Picking Note (set for LMS directed text of "PIK")
					Flag 2 = Packing Note (set for LMS directed text of "PAK" or "TXT")
					Flag 3 = Address Note (set for LMS directed text of "ADR")
					Flag 4 = BOL Note (set for LMS directed text of "BOL" or "TXT")
					Flag 5 = ? Note (set for LMS directed text of "MNF")  I'll try to get clarification from provia as to exactly what this was/is for since we don't have this text type defined.
					Flag 6 = ? Note (set for LMS directed text of "CHK") I'll try to get clarification from provia as to exactly what this was/is for since we don't have this text type defined.
					* 01/03/08
					- Flag 3 = 'Y' means it's a Bill-To address line...
					- If both Flag 2 and Flag 4 are 'Y', then note is just text and not to be printed anywhere
				*/
				lsNotes=Trim(Mid(lsRecdata, 76, 40))
				// Ignore notes that say 'Notes for Order Number' or 'Function Code' or empty notes...
				IF pos(Trim(lsNotes), 'Notes for Order Number') = 0 and pos(Trim(lsNotes), 'Function Code') = 0 and lsNotes <> '' THEN	
					ls_search = 'TXT         :'
					IF pos(Trim(lsNotes), ls_search) > 0 THEN
						lsNotes=mid(Trim(lsNotes), (len(ls_search)+1))
					END IF
					if mid(lsCommentDest, 3, 1) = 'Y' then //Bill-to address
						//lsNotes = 'BT:' + lsNotes
						lsRecType = 'BT'
						liBTAddr ++
						lsBT_Address[liBTAddr] = lsNotes
					end if
					/* Set lsRecType = 'PL' if this is a P/L note (lsCommentDest.2 = 'Y')
						- Set lsRecType = 'BL' if this is a BOL note (lsCommentDest.4 = 'Y')
						- Set lsRecType = 'PB' if this is BOTH a P/L and a BOL note 
						!!Assuming it can't be both a BT note and a PL / BOL Note
					*/
/*								if mid(lsCommentDest, 2, 1) = 'Y' then //Packing List note
									if mid(lsCommentDest, 4, 1) = 'Y' then //also a Bill of Lading note
										lsRecType = 'PB'
									else
										lsRecType = 'PL'
									end if
								else
									// Not a P/L note but it is a BOL note... (lsCommentDest.4 = 'Y')
									if mid(lsCommentDest, 4, 1) = 'Y' then //Bill of Lading note
										lsRecType = 'BL'
									end if
								end if
*/
					if mid(lsCommentDest, 4, 1) = 'Y' then //BOL note
						if mid(lsCommentDest, 2, 1) = 'Y' then //also a Pack List note
							lsRecType = 'PB'
						else
							lsRecType = 'BL'
						end if
						//add BOL note to Array to write to DM.Remark (& possibly DM.Shipping_Intructions) at the end (of the order)
						liBOLNote ++
						lsBOLNotes[liBOLNote] = lsNotes
					else
						// Not a BOL note but it is a P/L note... (lsCommentDest.2 = 'Y')
						if mid(lsCommentDest, 2, 1) = 'Y' then //PackList note
							lsRecType = 'PL'
						end if
					end if

				Else 
					Continue
				End If
			else // DC...
				lsCommentDest = Trim(Mid(lsRecdata, 76, 6)) 
				lsNotes=Trim(Mid(lsRecdata, 82, 40))
				
				/* Set lsRecType = 'PL' if this is a P/L note (lsCommentDest.2 = 'Y')
				   - Set lsRecType = 'BL' if this is a BOL note (lsCommentDest.4 = 'Y')
					- Set lsRecType = 'PB' if this is BOTH a P/L and a BOL note 
				*/
				if mid(lsCommentDest, 2, 1) = 'Y' then //Packing List note
					if mid(lsCommentDest, 4, 1) = 'Y' then //also a Bill of Lading note
						lsRecType = 'PB'
					else
						lsRecType = 'PL'
					end if
				else
					// Not a P/L note but it is a BOL note... (lsCommentDest.4 = 'Y')
					if mid(lsCommentDest, 4, 1) = 'Y' then //Bill of Lading note
						lsRecType = 'BL'
					end if
				end if
			End IF
			
			llNewNotesRow = ldsDONotes.InsertRow(0)
			
			//Defaults
			ldsDONotes.SetItem(llNewNotesRow, 'project_id', asProject) /*Project ID*/
			ldsDONotes.SetItem(llNewNotesRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			ldsDONotes.SetItem(llNewNotesRow, 'order_seq_no', llOrderSeq) 
			
			//From File
			ldsDONotes.SetItem(llNewNotesRow, 'note_type', lsRecType) /* Note Type */
			ldsDONotes.SetItem(llNewNotesRow, 'invoice_no', Trim(Mid(lsRecdata, 30, 30)))
						
			//dts - should set lsNoteSeq and lsLineItem depending on Header/detail and then wouldn't need condition here...
			If lsRecType = 'DC' or lsRecType = 'BL' Then /*detail*/
				ldsDONotes.SetItem(llNewNotesRow, 'note_seq_no', Long(Trim(Mid(lsRecdata, 70, 6))))
				ldsDONotes.SetItem(llNewNotesRow, 'line_item_no', Long(Trim(Mid(lsRecdata, 64, 6))))
				//ldsDONotes.SetItem(llNewNotesRow, 'note_text', Trim(Mid(lsRecdata, 82, 40)))
				ldsDONotes.SetItem(llNewNotesRow, 'note_text', lsNotes)
			Else /*header */
				ldsDONotes.SetItem(llNewNotesRow, 'note_seq_no', Long(Trim(Mid(lsRecdata, 64, 6))))
				ldsDONotes.SetItem(llNewNotesRow, 'line_item_no', 0)
				//ldsDONotes.SetItem(llNewNotesRow, 'note_text', Trim(Mid(lsRecdata, 76, 40)))
				ldsDONotes.SetItem(llNewNotesRow, 'note_text', lsNotes)
			End IF
		
		Case Else /*Invalid rec type */
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue /*Next Record */
			
	End Choose /*Header, Detail or Notes */
	
Next /*file record */

//load Bill-To Address info for Last Order...
// - last three BT Notes are City,State,Zip. Up to 4 other lines.
if liBTAddr > 0 then
	llNewAddressRow = ldsDOAddress.InsertRow(0)
	ldsDOAddress.SetItem(llNewAddressRow, 'project_id', asProject) /*Project ID*/
	ldsDOAddress.SetItem(llNewAddressRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
	ldsDOAddress.SetItem(llNewAddressRow, 'order_seq_no', llOrderSeq) //Here we're still on the current order (as opposed to above)...
	ldsDOAddress.SetItem(llNewAddressRow, 'address_type', 'BT') /* Bill To Address */
	ldsDOAddress.SetItem(llNewAddressRow, 'address_1', lsBT_Address[1]) /*Bill To Name - using Address_1 because it's 40 chars instead of 20*/
	if liBTAddr > 4 then ldsDOAddress.SetItem(llNewAddressRow, 'address_2', lsBT_Address[2]) /* BT Addr 1*/
	if liBTAddr > 5 then ldsDOAddress.SetItem(llNewAddressRow, 'address_3', lsBT_Address[3]) /* BT Addr 1*/
	if liBTAddr > 6 then ldsDOAddress.SetItem(llNewAddressRow, 'address_4', lsBT_Address[4]) /* BT Addr 2*/
	//if liBTAddr > 7 then ldsDOAddress.SetItem(llNewAddressRow, 'address_4', lsBT_Address[5]) /* BT Addr 3*/
	if liBTAddr > 2 then ldsDOAddress.SetItem(llNewAddressRow, 'City', lsBT_Address[liBTAddr - 2]) /* BT City */
	if liBTAddr > 1 then ldsDOAddress.SetItem(llNewAddressRow, 'State', lsBT_Address[liBTAddr - 1]) /*BT State */
	ldsDOAddress.SetItem(llNewAddressRow, 'Zip', lsBT_Address[liBTAddr]) /*Bill To Zip */
	//ldsDOAddress.SetItem(llNewAddressRow, 'Country', Trim(Mid(lsRecdata, 713, 20))) /* BT Country */
	//ldsDOAddress.SetItem(llNewAddressRow, 'tel', Trim(Mid(lsRecdata, 733, 20))) /*BT Phone*/
end if

//load BOL Header Notes into DM.Remark (& possibly Shipping_Instructions)
if liBolNote > 0 then
	lsBOLNote = lsBOLNotes[1]
	for i = 2 to liBOLNote
		//build sting of bol notes from array lsBOLNotes[]
		lsBOLNote += ' ' + lsBOLNotes[i]
	// messagebox("TEMPO, Len: " + string(len(lsBOLNote)), lsBOLNOte)
	next
	ldsDOHeader.SetItem(llNewRow, 'remark', left(lsBOLNote, 250)) 
	if len(lsBOLNote) > 250 then
		ldsDOHeader.SetItem(llNewRow, 'shipping_instructions_text', mid(lsBOLNote, 251, 250)) 
	end if
end if

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
	FileWrite(gilogFileNo, lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

If lbError Then Return -1

Return 0
end function

public function integer uf_process_itemmaster (string aspath, string asproject);
//Process Item Master (IM) Transaction for Maquet


String	lsData, lsTemp, lsLogOut, lsStringData, lsSKU, 	lsCOO, lsSupplier, lsSupplierSave
			
Integer	liRC,	liFileNo
			
Long		llCount,	llPos, llOwner, llNew, llExist, llNewRow, llFileRowCount, llFileRowPos 

Decimal ldtemp

Boolean	lbNew, lbError

//u_ds_datastore	ldsItem 
//datastore	iu_ds

If NOt isvalid(idsItem) Then
	idsItem = Create u_ds_datastore
	//ldsItem.dataobject= 'd_item_master'
	idsItem.dataobject= 'd_item_master_w_supp_cd'
	idsItem.SetTransObject(SQLCA)
End If

idsItem.Reset()

If not isvalid(iu_ds) Then
	iu_ds = Create datastore
	iu_ds.dataobject = 'd_generic_import'
End If

iu_ds.Reset()

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

For llFileRowPos = 1 to llFileRowCOunt
	
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
		
	Else /*error*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
		lbError = True
		Continue
		
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


	//Package Code - Mapped to UF 4 ?????
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
	
	
	
	//Update any record defaults
	For llPos = 1 to idsItem.RowCount()
		idsItem.SetItem(llPos,'Last_user','SIMSFP')
		idsItem.SetItem(llPos,'last_update',today())
		idsItem.SetItem(llPos,'interface_upd_req_Ind','Y') /*Will trigger a refresh to LMS*/
	Next
		
	//If record is new...
	If lbNew Then
			
		idsItem.SetItem(1,'po_controlled_ind','Y') /*tracking by Pkg Code*/
		idsItem.SetItem(1,'po_no2_controlled_ind','N')
		idsItem.SetItem(1,'container_tracking_ind','N') 
			
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

Next /*File row to Process */

w_main.SetMicroHelp("")

lsLogOut = Space(10) + String(llNew) + ' Item Records were successfully added and ' + String(llExist) + ' Records were updated.'
FileWrite(gilogFileNo,lsLogOut)

Destroy idsItem

//Send updates to LMS
u_nvo_edi_confirmations_maquet	luMaquet
luMaquet = Create u_nvo_edi_confirmations_maquet
luMaquet.uf_lms_itemmaster()

If lbError then
	Return -1
Else
	Return 0
End If


end function

protected function integer uf_process_po (string aspath, string asproject);//Process 943 for SIKA (modeled after Maquet)

Datastore	lu_ds, ldsItem

String	lsLogout,lsStringData, lsOrder, lsWarehouse, lsTemp, lsRecData, lsRecType, lsDesc, lsSKU, lsSupplier
Integer	liRC,liFileNo
Long		llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llOwnerID
Boolean	lbError, lbDetailError
DateTime	ldtToday
Decimal	ldWeight, ldLineItemNo
String 	lsOrderNo

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
lsLogOut = '      - Opening File for SIKA Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for SIKA Processing: " + asPath
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
//TEMPO - Why? What is the WH code we're getting in the file?
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
	
	lsRecData = Trim(lu_ds.GetItemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsRecType)
			
		Case 'PM' /*PO Header*/
			
			llNewRow = 	idsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			idsPOheader.SetItem(llNewRow, 'project_id',asProject)
			idsPOheader.SetItem(llNewRow, 'wh_code',lsWarehouse)
			idsPOheader.SetItem(llNewRow, 'Request_date',String(Today(),'YYMMDD'))
			idsPOheader.SetItem(llNewRow, 'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPOheader.SetItem(llNewRow, 'order_seq_no',llOrderSeq) 
			idsPOheader.SetItem(llNewRow, 'ftp_file_name',asPath) /*FTP File Name*/
			idsPOheader.SetItem(llNewRow, 'Status_cd','N')
			idsPOheader.SetItem(llNewRow, 'Last_user','SIMSEDI')
		
			//Getting Order_Type from SIKA(at end of PM Record). Defaulting it here...
			idsPOheader.SetItem(llNewRow, 'Order_type', 'S') /*Order Type TEMPO - 'I' or '?')  */
			idsPOheader.SetItem(llNewRow, 'Inventory_Type','N') /*default to Normal*/
					
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
		
			//Action Code - 			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Action Code' field. Record will not be processed.")
			End If
						
			idsPOheader.SetItem(llNewRow, 'action_cd', lsTemp) 
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
									
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsOrderNo = trim(lsTemp)
			idsPOheader.SetItem(llNewRow,'order_no',Trim(lsTemp))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
//TEMPO?			//No more required fields after Supplier
			
//TEMPO? That's for Maquet. Getting supplier on PM record for SIKA(?)			//Supplier  - Supplier is not present on the header. Will load from first detail
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
		
			If lsTemp > '' Then
				lsSupplier = lsTemp /*used to build item master below if necessary*/
				idsPOheader.SetItem(llNewRow,'supp_code',lsTemp)
			Else
				idsPOheader.SetItem(llNewRow,'supp_code','SIKA') /*default to SIKA - not currently being sent on file? */
			End If
			
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
//			idsPOheader.SetItem(llNewRow,'wh_Code',lsWarehouse)
						
					
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
		
			//Order Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'Order_type',lsTemp) /*Order Type*/	
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
				
			//Action Code
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
		
			//SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Upper(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			lsSKU = trim(lsTemp) /*used to build itemmaster below*/				
			idsPODetail.SetItem(llNewDetailRow,'SKU',lsSKU)
		
//TEMPO? Ah, Maquet was setting supplier as part of SKU			//If first row for the order, set the supplier on the header - not set from PM
//			If llLineSeq = 1 Then
//				idsPOheader.SetITem(llNewRow,'supp_code',lsSupplier)
//			End If
			
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
						
			idsPODetail.SetItem(llNewDetailRow, 'Lot_no', trim(lsTemp))
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO - We will be mapping PKG Code below to PO_NO (for maquet)
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
				
			//We may receive a detail row for a new sku//supplier combination. If we have the sku for another supplier and this supplier is also valid, copy existing item to new supplier
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

on u_nvo_proc_sika.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_sika.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

