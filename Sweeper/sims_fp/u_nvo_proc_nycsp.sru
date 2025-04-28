HA$PBExportHeader$u_nvo_proc_nycsp.sru
$PBExportComments$Process NYCSP files
forward
global type u_nvo_proc_nycsp from nonvisualobject
end type
end forward

global type u_nvo_proc_nycsp from nonvisualobject
end type
global u_nvo_proc_nycsp u_nvo_proc_nycsp

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				iu_DS
				
u_ds_datastore	idsItem , idsOut


String lsDelimitChar
				



end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_inventory_snapshot (string asproject, string asinifile)
public function integer uf_process_dboh (string asproject, string asinifile)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);
String	lsLogOut,lsSaveFileName, lsStringData

Integer	liRC, liFileNo

Boolean	bRet


If  Left(asFile,4) =  'N940' Then /* Sales Order Files from LMS to SIMS*/
		
		liRC = uf_process_so(asPath, asProject)
		
		//Process any added SO's
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
		
Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
	End If

Return liRC
end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for NYCSP

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
	lsLogOut = "-       ***Unable to Open File for NYCSP Processing: " + asPath
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
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

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
									
			llnewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
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
			ldsDOHeader.SetItem(llNewRow,'Address_1',Trim(Mid(lsRecData,978,40))) /*Ship to Addr 1*/
			ldsDOHeader.SetItem(llNewRow,'Address_2',Trim(Mid(lsRecData,1018,40))) /*Ship to Addr 2*/
			ldsDOHeader.SetItem(llNewRow,'Address_3',Trim(Mid(lsRecData,1058,40))) /*Ship to Addr 3*/
			ldsDOHeader.SetItem(llNewRow,'City',Trim(Mid(lsRecData,1098,35))) /*Ship to City*/
			ldsDOHeader.SetItem(llNewRow,'State',Trim(Mid(lsRecData,1168,2))) /*Ship to State 1*/
			ldsDOHeader.SetItem(llNewRow,'Zip',Trim(Mid(lsRecData,1170,10))) /*Ship to Zip*/
			ldsDOHeader.SetItem(llNewRow,'Country',Trim(Mid(lsRecData,1180,20))) /*Ship to country*/
			ldsDOHeader.SetItem(llNewRow,'tel',Trim(Mid(lsRecData,1200,20))) /*Ship to Tel*/
		
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
//			ldsDODetail.SetItem(llNewRow,'User_Field1',Trim(Mid(lsRecdata,241,10))) /* customer Order */
			ldsDODetail.SetItem(llNewRow,'User_Field2',Trim(Mid(lsRecdata,251,10))) /* dts - Customer Line Number -> */
			ldsDODetail.SetItem(llNewRow,'price',Trim(Mid(lsRecdata,270,8)))		
			ldsDODetail.SetItem(llNewRow,'po_no',Trim(Mid(lsRecdata,115,15))) /*Picking Location from spreadsheet via LMS*/
//			ldsDODetail.SetItem(llNewRow,'po_no',Trim(Mid(lsRecdata,90,6)))	/* Package Code -> PO_NO */
							
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

public function integer uf_process_inventory_snapshot (string asproject, string asinifile);


//Process the Daily Balance on Hand Confirmation File


Datastore	ldsOut,	&
				ldsboh
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName, lsFileNamepath

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file

ldsboh = Create Datastore
//Tam 2016/05/16 - Changed the DW of the report
ldsboh.Dataobject = 'd_nycsp_inventory' /* at the SKU/Inv Type level */
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: NYCSP Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "NYCSP"


//Retrieve the Data

llRowCount = ldsboh.Retrieve()

//Write the rows to the generic output table - delimited by '~t'


lsFileName =  'Report_924_' + String(DateTime( today(), now()), "yyyy.mm.dd.hh.mm.ss") + '.csv'


//Flatfile Out

lsFileNamepath = ProfileString(asInifile, "NYCSP", "ftpfiledirout","") + '\' + lsFileName

ldsboh.SaveAs ( lsFileNamePath, CSV!	, true )

Return 0



end function

public function integer uf_process_dboh (string asproject, string asinifile);


//Process the Daily Balance on Hand Confirmation File


Datastore	ldsOut,	&
				ldsboh
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_nycsp_boh' /* at the SKU/Inv Type level */
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: NYCSP Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "NYCSP"

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq < 0 Then Return -1

//Retrive the BOH Data
lsLogout = 'Retrieving Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCOunt = ldsBOH.Retrieve(lsProject)

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '~t'
lsLogOut = 'Processing Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCOunt
	
	llNewRow = ldsOut.insertRow(0)
	lsOutString = ""
	lsOutString += ldsboh.GetItemString(llRowPos,'wh_code') + lsDelimitChar //08-Jan-2014 :Madhu -NYCSP- CR- DBOH- Added
	lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),50) + lsDelimitChar
	lsOutString += ldsboh.GetItemString(llRowPos,'description') + lsDelimitChar
	//lsOutString += ldsboh.GetItemString(llRowPos,'uom_1') + lsDelimitChar  //08-Jan-2014 :Madhu -NYCSP- CR- DBOH- commented
	//lsOutString += string(ldsboh.GetItemNumber(llRowPos,'total_qty'),'############0') + lsDelimitChar //08-Jan-2014 :Madhu -NYCSP- CR- DBOH- commented
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'avail_qty'),'############0') + lsDelimitChar
	//lsOutString += string(ldsboh.GetItemNumber(llRowPos,'comp_qty'),'############0') //08-Jan-2014 :Madhu NYCSP- CR- DBOH- commented
		
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	lsFileName = 'IB' + String(ldBatchSeq,'000000') + '.RNM'
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
next /*next output record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,"NYCSP")

Return 0
end function

on u_nvo_proc_nycsp.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_nycsp.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor; lsDelimitChar = char(9)
end event

