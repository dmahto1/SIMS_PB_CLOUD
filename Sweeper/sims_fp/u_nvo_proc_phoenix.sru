HA$PBExportHeader$u_nvo_proc_phoenix.sru
$PBExportComments$Process Phoenix Brands files
forward
global type u_nvo_proc_phoenix from nonvisualobject
end type
end forward

global type u_nvo_proc_phoenix from nonvisualobject
end type
global u_nvo_proc_phoenix u_nvo_proc_phoenix

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsASNHeader,	&
				idsASNPackage,	&
				idsASNItem
				
// pvh - 03/16/06
datastore idswhXref  // used as cross reference between phxbrands 2 digit wh code and our alpha one.


end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_po (string aspath, string asproject)
public function integer uf_process_rm (string aspath, string asproject)
public function integer uf_process_dboh (string asinifile)
public function integer uf_process_so (string aspath, string asproject)
public function string getsimswhcode (string phxcode)
public function string getphxwhcode (string simscode)
public function integer uf_process_exception_rpt (string asinifile, string asemail)
public function integer uf_process_shipment_detail_rpt (string asinifile, string asemail)
public function integer uf_eom_shipment_mtd (string asinifile)
public function integer uf_process_shipment_mtd (string asinifile, boolean ab_eom)
public function integer uf_process_whtransf_rpt (string asinifile, string asemail)
public function integer uf_process_short_shipped_rpt (string asinifile, string asemail)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);
String	lsLogOut,lsSaveFileName, lsStringData

Integer	liRC, liFileNo

Boolean	bRet


If Left(asFile,1) = 'P' Then /* PO File*/
	
		
		liRC = uf_process_po(asPath, asProject)
	
		//Process any added PO's
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
	
//	Case 'RM' /*Process Return Order File  */
//		
//		liRC = uf_process_rm(asPath, asProject)
//	
//		//Process any added PO's
//		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
//		
		

			
ElseIf Left(asFile,4) =  'N940' Then /* Sales Order Files from LMS to SIMS*/
		
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

public function integer uf_process_po (string aspath, string asproject);Datastore	ldsPOHeader,	&
				ldsPODetail,	&
				lu_ds

String	lsLogout,lsStringData, lsOrder, lsWarehouse, lsTemp, lsREcData, lsRecType, lsDate

Integer	liFileNo,	&
			liRC

Long	llNewRow, llNewDetailRow, llRowCount, llRowPos, llOrderSeq, llLineSeq, llBatchSeq
			
Boolean	lbError

DateTime	ldtToday

ldtToday = DateTime(Today(),Now())

ldsPOheader = Create u_ds_datastore
ldsPOheader.dataobject= 'd_po_header'
ldsPOheader.SetTransObject(SQLCA)

ldsPOdetail = Create u_ds_datastore
ldsPOdetail.dataobject= 'd_po_detail'
ldsPOdetail.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening File for Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Phoenix Processing: " + asPath
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

////Warehouse defaulted from project master default warehouse - only need to retrieve once
// 04/06 - PCONKL - We don't want no stinkin default
//Select wh_code into :lsWarehouse
//From Project
//Where Project_id = :asProject;
//
//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1
	
		
//Process each row of the File
llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	lsrecData = Trim(lu_ds.GetITemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsREcType)
			
		Case 'PM' /*PO Header*/
			
			llNewRow = 	ldsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New REcord DEfaults
			ldsPOheader.SetITem(llNewRow,'project_id',asProject)
		//	ldsPOheader.SetITem(llNewRow,'wh_code',lsWarehouse) /*default warehouse - should be set from file below*/
			ldsPOheader.SetITem(llNewRow,'supp_code','PHX') 
			ldsPOheader.SetITem(llNewRow,'Request_date',String(Today(),'YYMMDD'))
			ldsPOheader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPOheader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsPOheader.SetItem(llNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsPOheader.SetItem(llNewRow,'Status_cd','N')
			ldsPOheader.SetItem(llNewRow,'Last_user','SIMSEDI')
			
			ldsPOheader.SetItem(llNewRow,'Order_type','S') /*Supplier Order*/
			ldsPOheader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
					
			//From File		
			ldsPOheader.SetItem(llNewRow,'action_cd',Trim(Mid(lsRecData,3,1))) /*ACtion Code*/
			ldsPOheader.SetItem(llNewRow,'order_no',Trim(Mid(lsRecData,4,10))) /*Order Number*/
			//ldsPOheader.SetItem(llNewRow,'Supp_code',Trim(Mid(lsRecData,14,10))) /*Supplier*/
			
			//Format Sched Arrival date from yyyymmdd -> mm/dd/yyyy
			lsTemp = Trim(Mid(lsRecData,24,8))
			lsDate = Mid(lsTemp,5,2) + '/' + Right(lsTEmp,2) + '/' + Left(lsTemp,4)
			ldsPOheader.SetItem(llNewRow,'Arrival_Date',lsDate) /*Sched arrival Date*/
			
			//Warehouse - We need to convert their code to ours
			LsTemp = Trim(Mid(lsRecData,32,10))
			lswarehouse = ''
			// pvh - 03.16.06 using warehouse xref
			lsWarehouse = getSIMSWhCode( LsTemp )
			
//			Choose Case Upper(lsTemp)
//				Case '02' /* nashville */
//					lsWarehouse = 'PHX-NASH'
//				Case '03' /* Thorofare NJ */
//					lsWarehouse = 'PHX-THORO'
//				Case '06' /* Cranberry */
//					lsWarehouse = 'PHX-CRANBY'
//				Case '07' /* dts 11/01/05 - added New Fontana wh */
//					lsWarehouse = 'PHX-FONTAN'
//				Case '08' /* 01/06 - PCONKL */
//					lsWarehouse = 'PHX-COLUMB'
//				Case '09' /* 01/06 - PCONKL */
//					lsWarehouse = 'PHX-CHARLO'
//				Case '20'
//					lsWarehouse = 'PHX-MISS'
//				Case '21'
//					lsWarehouse = 'PHX-BRAM'
//				Case '26' // pvh - 03/16/05
//					lsWarehouse = 'PHX-EDMONT'
//			End Choose
			
			If lsWarehouse > '' Then
				ldsPOheader.SetITem(llNewRow,'wh_code',lsWarehouse)
			Else /*  04/06 - PCONKL - Set to invalid Inbound WH from file */
				ldsPOheader.SetITem(llNewRow,'wh_code',lsTemp)
			End If
			
			ldsPOheader.SetItem(llNewRow,'Carrier',Trim(Mid(lsRecData,42,10))) /*Carrier*/
			ldsPOheader.SetItem(llNewRow,'Remark',Trim(Mid(lsRecData,52,250))) /*Carrier*/
			
			
		CASe 'PD' /* detail*/
			
			llNewDetailRow = 	ldsPODetail.InsertRow(0)
			llLineSeq ++
						
			//Add detail level defaults
			ldsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			ldsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N')
			ldsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq)) /*passed from driver as next line seq within order*/
					
			
			//From File
			ldsPODetail.SetItem(llNewDetailRow,'action_cd',trim(Mid(lsRecdata,3,1)))
			ldsPODetail.SetItem(llNewDetailRow,'Order_No',Trim(Mid(lsRecData,4,10)))
			ldsPODetail.SetItem(llNewDetailRow,'line_item_no',Long(Trim(Mid(lsRecData,14,6))))
			ldsPODetail.SetItem(llNewDetailRow,'SKU',trim(Mid(lsRecData,20,26)))
				
			//Qty
			lsTemp = Trim(Mid(lsRecData,46,13))
			If Not isnumber(lsTemp) Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - 'Quantity' is not numeric. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			Else
				ldsPODetail.SetItem(llNewDetailRow,'quantity',lsTemp)
			End If
			
			ldsPODetail.SetItem(llNewDetailRow,'Lot_no',trim(Mid(lsRecData,103,20)))
			ldsPODetail.SetItem(llNewDetailRow,'PO_no',trim(Mid(lsRecData,123,25)))
			ldsPODetail.SetItem(llNewDetailRow,'po_no2',trim(Mid(lsRecData,148,25)))
			ldsPODetail.SetItem(llNewDetailRow,'Serial_no',trim(Mid(lsRecData,173,20)))
	
			
		CAse Else /* Invalid Rec Type*/
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
			lbError = True
			Continue /*Next Record */
			
	End Choose /*record Type*/
		
Next /*File Row */

//Save the Changes 
lirc = ldsPOHeader.Update()
	
If liRC = 1 Then
	liRC = ldsPODetail.Update()
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

public function integer uf_process_rm (string aspath, string asproject);//Process Return ORders

Datastore	ldsPOHeader,	&
				ldsPODetail,	&
				lu_ds

String	lsLogout,lsStringData, lsOrder, lsWarehouse, lsTemp, lsREcData, lsRecType

Integer	liFileNo,	&
			liRC

Long	llNewRow, llNewDetailRow, llRowCount, llRowPos, llOrderSeq, llLineSeq, llBatchSeq
			
Boolean	lbError

DateTime	ldtToday

ldtToday = DateTime(Today(),Now())

ldsPOheader = Create u_ds_datastore
ldsPOheader.dataobject= 'd_po_header'
ldsPOheader.SetTransObject(SQLCA)

ldsPOdetail = Create u_ds_datastore
ldsPOdetail.dataobject= 'd_po_detail'
ldsPOdetail.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening File for Return Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for K&N Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',lsStringData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Warehouse defaulted from project master default warehouse - only need to retrieve once
Select wh_code into :lsWarehouse
From Project
Where Project_id = :asProject;

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1
		
		
		
//Process each row of the File
llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	lsrecData = Trim(lu_ds.GetITemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsREcType)
			
		Case 'RM' /* Return Header*/
			
			llNewRow = 	ldsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New REcord DEfaults
			ldsPOheader.SetITem(llNewRow,'project_id',asProject)
			ldsPOheader.SetITem(llNewRow,'wh_code',lsWarehouse)
			ldsPOheader.SetITem(llNewRow,'supp_code','K&N') 
			ldsPOheader.SetITem(llNewRow,'Request_date',String(Today(),'YYMMDD'))
			ldsPOheader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPOheader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsPOheader.SetItem(llNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsPOheader.SetItem(llNewRow,'Status_cd','N')
			ldsPOheader.SetItem(llNewRow,'Last_user','SIMSEDI')
			
			ldsPOheader.SetItem(llNewRow,'Order_type','X') /*Return from Customer*/
			ldsPOheader.SetItem(llNewRow,'Inventory_Type','R') /*default to Return*/
						
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
									
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
							
			ldsPOheader.SetItem(llNewRow,'order_no',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//ACtion Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'ACtion Code' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
							
			ldsPOheader.SetItem(llNewRow,'action_cd',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			
			//Expected Arrival Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			ldsPOheader.SetItem(llNewRow,'Arrival_Date',lsTemp)
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Return From Customer
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
				
			ldsPOheader.SetItem(llNewRow,'User_field1',lsTemp)
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Warehouse - We need to convert their code to ours
			LsTemp = Trim(Mid(lsRecData,32,10))
			lswarehouse = ''
			// pvh - 03.16.06 using warehouse xref
			lsWarehouse = getSIMSWhCode( LsTemp )

//			Choose Case Upper(lsTemp)
//				Case '02' /* nashville */
//					lsWarehouse = 'PHX-NASH'
//				Case '03' /* Thorofare NJ */
//					lsWarehouse = 'PHX-THORO'
//				Case '06' /* Cranberry (added 11/01/05*/
//					lsWarehouse = 'PHX-CRANBY'
//				Case '07' /* dts 11/01/05 - added New Fontana wh */
//					lsWarehouse = 'PHX-FONTAN'
//				Case '08' /* 01/06 - PCONKL */
//					lsWarehouse = 'PHX-COLUMB'
//				Case '09' /* 01/06 - PCONKL */
//					lsWarehouse = 'PHX-CHARLO'
//				Case '20'
//					lsWarehouse = 'PHX-MISS'
//				Case '21'
//					lsWarehouse = 'PHX-BRAM'
//				Case '26' // pvh - 03/16/05
//					lsWarehouse = 'PHX-EDMONT'
//				
//			End Choose
		
			If lsWarehouse > '' Then
				ldsPOheader.SetITem(llNewRow,'wh_code',lsWarehouse)
			Else /* default loaded above */
			End If
			
			
		CASe 'RD' /* Return detail*/
			
			llNewDetailRow = 	ldsPODetail.InsertRow(0)
			llLineSeq ++
						
			//Add detail level defaults
			ldsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			ldsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'R')  /*returns */
			ldsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq)) /*passed from driver as next line seq within order*/

			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
						
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Number' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
							
			ldsPODetail.SetItem(llNewRow,'Order_No',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//ACtion Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'ACtion Code' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
							
			ldsPODetail.SetItem(llNewRow,'action_cd',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Line Item Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Line Item Number' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
							
			ldsPODetail.SetItem(llNewRow,'line_item_no',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
							
			ldsPODetail.SetItem(llNewRow,'SKU',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Qty
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
			
			If Not isnumber(lsTemp) Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - 'Quantity' is not numeric. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			Else
				ldsPODetail.SetItem(llNewRow,'quantity',Dec(lsTemp))
			End If
									
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Arrival Date - UF1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
							
			ldsPODetail.SetItem(llNewRow,'user_field1',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
		CAse Else /* Invalid Rec Type*/
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
			lbError = True
			Continue /*Next Record */
			
	End Choose /*record Type*/
		
Next /*File Row */

//Save the Changes 
lirc = ldsPOHeader.Update()
	
If liRC = 1 Then
	liRC = ldsPODetail.Update()
End If
	
If liRC = 1 then
	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Return Order Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Return Order Records to database!")
	Return -1
End If

If lbError Then
	Return -1
Else
	Return 0
End If
end function

public function integer uf_process_dboh (string asinifile);// uf_process_dboh(
//Process the PHOENIX Daily Balance on Hand Confirmation File

Datastore	ldsOut, ldsboh
				
Long			llRowPos, llRowCount, llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsWarehouse, lsFileName, lsFileNamePath

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

// pvh 03.16.06
constant string lsSpaces = Space(10)

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

lsNextRunDate = ProfileString(asIniFile,'PHXBRANDS','DBOHNEXTDATE','')
lsNextRunTime = ProfileString(asIniFile,'PHXBRANDS','DBOHNEXTTIME','')
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

ldsboh = Create Datastore
//TAM 2007/02/02 Created Separate BOH DW to filter out Where Item_Master.GRP = 'CORR'
ldsboh.Dataobject = 'd_phxbrands_boh_by_sku' /* 02/07 - PCONKL - changed to include Inventory Type*/
//ldsboh.Dataobject = 'd_boh_by_sku' /* rolled up to SKU level */
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Phoenix Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile,'PHXBRANDS',"project","")

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(lsproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for Phoenix BOH confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrive the BOH Data
lsLogout = 'Retrieving Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCOunt = ldsBOH.Retrieve(lsProject)

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by 'Tab'
lsLogOut = 'Processing Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCOunt
	
	// pvh - 03.16.06 using warehouse xref
	lsWarehouse = getPHXWhCode( Upper(ldsboh.GetItemString(llRowPos,'wh_code'))  )
	lsWarehouse = left( lsWarehouse + lsSpaces, 10 )	
		
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'BH' /*rec type = balance on Hand Confirmation*/
	lsOutString+= lsWarehouse
	//lsOutString += ' ' /* no Inventory Type*/ 
	lsOutString += ldsboh.GetItemString(llRowPos,'inventory_type') /*  02/07 - PCONKL - Added inventory Type*/ 
	lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),26) + space(26 - Len(ldsboh.GetItemString(llRowPos,'sku')))
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'total_qty'),'0000000000000') 
		
	ldsOut.SetItem(llNewRow,'Project_id', "PHXBRANDS")
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	//File name is SIBH846P + Axxxxxxxxx being unique member for the AS400
	lsFileName = 'SIBH846P.A' + String(ldBatchSeq,'000000000')
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)
	//ldsOut.SetItem(llNewRow,'file_name', 'SIBH846P')
	
next /*next output record */



//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,"PHXBRANDS")

/* TAM - 2007/03/01 -  Email the report*/
lsFileNamePath = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + lsFileName  + ".txt"
gu_nvo_process_files.uf_send_email("PHXBRANDS","BOHEMAIL","PHOENIX BRANDS Daily Balance On Hand Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the BALANCE ON HAND REPORT run on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)


//Added Shiment MTD to be run at same time.

uf_process_shipment_mtd(asinifile, false)



//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile,'PHXBRANDS','DBOHFREQ','')
If isnumber(lsRunFreq) Then
	//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile,'PHXBRANDS','DBOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile,'PHXBRANDS','DBOHNEXTDATE','')
End If



Return 0
end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for Phoenix Brands

Datastore	ldsDOHeader, ldsDODetail, lu_ds, ldsDOAddress, ldsDONotes
				
String		lsLogout,lsRecData,lsTemp,	lswarehouse, lsErrText,	 lsSKU,	lsRecType,	&
				lsSoldToAddr1, lsSoldToADdr2, lsSoldToADdr3,  lsSoldToAddr4, lsSoldToStreet,	&
				lsSoldToZip, lsSoldToCity, lsSoldToState, lsSoldToCountry, lsSoldToTel, lsDate, ls_invoice_no, ls_Note_Type, &
				ls_search,lsNotes,ls_temp, lsCustCode, lsCustText

Integer		liFileNo,liRC, li_line_item_no
				
Long			llRowCount,	llRowPos,llNewRow,llOrderSeq,	llBatchSeq,	llLineSeq,llCount,		&
				llCONO, llRoNO, llLineItemNo,  llOwner, llNewAddressRow, llNewNotesRow, li_find, ll_Note_Seq_No
				
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
	lsLogOut = "-       ***Unable to Open File for Phoenix Processing: " + asPath
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

////Warehouse will have to be defaulted from project master default warehouse
// 04/06 - PCONKL - Don't default
//Select wh_code into :lswarehouse
//From Project
//Where Project_id = :asProject;


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
			//ldsDOHeader.SetITem(llNewRow,'wh_code',lswarehouse) /*Default WH for Project - should be overlaid with real warehouse below */
			ldsDOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow,'Status_cd','N')
			ldsDOHeader.SetItem(llNewRow,'order_Type','S') /*default to SALE */
			ldsDOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')
						
		//From File
			// pvh - 03.16.06 using warehouse xref
			lsWarehouse = getSIMSWhCode( Trim(Mid(lsRecdata,10,6)) )
			
			//Translate warehouse Code to our warehouse
//			Choose Case Trim(Mid(lsRecdata,10,6))
//				Case '02'
//					lsWarehouse = 'PHX-NASH'
//				Case '03'
//					lsWarehouse = 'PHX-THORO'
//				Case '06'
//					lsWarehouse = 'PHX-CRANBY'
//				Case '07' /* dts 11/01/05 - added New Fontana wh */
//					lsWarehouse = 'PHX-FONTAN'
//				Case '08' /* 01/06 - PCONKL */
//					lsWarehouse = 'PHX-COLUMB'
//				Case '09' /* 01/06 - PCONKL */
//					lsWarehouse = 'PHX-CHARLO'
//				Case '20'
//					lsWarehouse = 'PHX-MISS'
//				Case '21'
//					lsWarehouse = 'PHX-BRAM'
//				Case '26' // pvh - 03/16/05
//					lsWarehouse = 'PHX-EDMONT'
//				Case Else
//					lsWarehouse = ''
//			End Choose
			
			If lsWarehouse > '' Then
				ldsDOHeader.SetITem(llNewRow,'wh_code',lswarehouse) 
			Else
				ldsDOHeader.SetITem(llNewRow,'wh_code',Trim(Mid(lsRecdata,10,6))) /* 04/06 - PCONKL - set to invalid WH from file*/
			End If

			//MA 01/08 - Added Carrier Pro #  and Delivery Appt Ref Code
			ldsDOHeader.SetItem(llNewRow,'User_field6',Trim(Mid(lsRecData,2370,30))) /*Carrier Pro # */
			ldsDOHeader.SetItem(llNewRow,'User_field8',Trim(Mid(lsRecData,2400,30))) /*Delivery Appt Ref Code*/
			
			
			ldsDOHeader.SetItem(llNewRow,'invoice_no',Trim(Mid(lsRecData,30,30))) /*Order Number*/
			
			
			//If the order number beginning in position 30 of the OM record in the 940 file begins with TR set Deleivery_master.Ord_type to Z.
			
			IF Upper(Left(Trim(Mid(lsRecData,30,30)),2)) = "TR" THEN
			
				//Then is the ship to customer name beginning in position 818 is AMCA change the  Deleivery_master.Ord_type to T.
	
				IF Upper(Trim(Mid(lsRecData,818,4))) = "AMCA" THEN
					
					ldsDOHeader.SetItem(llNewRow,'order_Type','T') 	
			
				ELSE
			
					ldsDOHeader.SetItem(llNewRow,'order_Type','Z') 			
			
				END IF
					
			END IF
			
			//--
			
			
			
			ldsDOHeader.SetItem(llNewRow,'User_field2',Trim(Mid(lsRecData,60,4))) /*Order Type - UF 2 - Order # + Plus order Type = Unique order # for LMS*/
			ldsDOHeader.SetItem(llNewRow,'Carrier',Trim(Mid(lsRecData,92,15))) 
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
			
			//MEA Only set the customer data if not an order type of 'Z'
			
			IF ldsDOHeader.GetItemString(llNewRow,'order_Type') <> 'Z' THEN 
			
				ldsDOHeader.SetItem(llNewRow,'Cust_Code',Trim(Mid(lsRecData,803,15))) /*Cust Code*/		
				
				//cust code may not be present...
				If isnull(ldsdoheader.GetITemString(llNewRow,'Cust_Code')) or ldsdoheader.GetITemString(llNewRow,'Cust_Code') = '' Then
					ldsDOHeader.SetItem(llNewRow,'Cust_Code','N/A')
				ELSE //BCR 13-JAN-2012: No CHEP Pallet Project
					//See if there is need to enter Delivery Notes data for this order based upon User_Field4 on Customer table.	
					lsCustCode = Trim(Mid(lsRecData,803,15))	
					
					SELECT user_field4
					INTO :lsCustText
					FROM Customer
					WHERE project_id = :asProject
					AND cust_code = :lsCustCode
					USING SQLCA;
					
					IF NOT IsNull(lsCustText) AND lsCustText <> '' THEN
						
						llNewNotesRow = ldsDONotes.InsertRow(0)
						
						//Defaults
						ldsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
						ldsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
						ldsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
						ldsDONotes.SetItem(llNewNotesRow,'note_type',lsRecType) /*Header Record Type in this case */
						ldsDONotes.SetItem(llNewNotesRow,'line_item_no',0)
						ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',100) /*Arbitrarily hardcoded to 100*/
						//Derived
						ldsDONotes.SetItem(llNewNotesRow,'note_text',lsCustText) /*User_Field4 value from Customer table*/
						
					END IF
					//End No CHEP Pallet Project
				End If
			
			END IF	
				
			ldsDOHeader.SetItem(llNewRow,'Cust_Name',Trim(Mid(lsRecData,818,40))) /*Cust Name*/
			ldsDOHeader.SetItem(llNewRow,'Address_1',Trim(Mid(lsRecData,978,40))) /*Ship to Addr 1*/
			ldsDOHeader.SetItem(llNewRow,'Address_2',Trim(Mid(lsRecData,1018,40))) /*Ship to Addr 2*/
			ldsDOHeader.SetItem(llNewRow,'Address_3',Trim(Mid(lsRecData,1058,40))) /*Ship to Addr 3*/
			ldsDOHeader.SetItem(llNewRow,'City',Trim(Mid(lsRecData,1098,35))) /*Ship to City*/
			ldsDOHeader.SetItem(llNewRow,'State',Trim(Mid(lsRecData,1168,2))) /*Ship to State 1*/
			ldsDOHeader.SetItem(llNewRow,'Zip',Trim(Mid(lsRecData,1170,10))) /*Ship to Zip*/
			ldsDOHeader.SetItem(llNewRow,'Country',Trim(Mid(lsRecData,1180,20))) /*Ship to country*/
			ldsDOHeader.SetItem(llNewRow,'tel',Trim(Mid(lsRecData,1200,20))) /*Ship to Tel*/
		//	ldsDOHeader.SetItem(llNewRow,'Fax',Trim(Mid(lsRecData,1220,20))) /*Ship to Fax*/

		
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
			If Trim(Mid(lsRecData,306,445)) > '' Then
				
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
		//	ldsDODetail.SetITem(llNewRow,'Action_cd', 'A') /*always Add*/
			ldsDODetail.SetITem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDODetail.SetITem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDODetail.SetITem(llNewRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetITem(llNewRow,'Status_cd','N')
			ldsDODetail.SetITem(llNewRow,'supp_code', 'PHX')
		//	ldsDODetail.SetItem(llNewRow,'Inventory_type','N') /*normal inventory*/
				
		//From File
			ls_temp = Trim(Mid(lsRecdata,30,30))
			ldsDODetail.SetItem(llNewRow,'invoice_no',Trim(Mid(lsRecdata,30,30))) 

			//TAM 2007/05/09 Use Cust Line Number from position 251 
			If Trim(Mid(lsRecdata,251,6)) = '' or IsNull(Trim(Mid(lsRecdata,251,6)))  Then
				ldsDODetail.SetItem(llNewRow,'line_item_no',Long(Trim(Mid(lsRecdata,64,6))))
			Else
				ldsDODetail.SetItem(llNewRow,'line_item_no',Long(Trim(Mid(lsRecdata,251,6))))
			End If
			
			ldsDODetail.SetItem(llNewRow,'SKU',Trim(Mid(lsRecdata,70,20))) 
			
			//ldQty = Dec(Trim(Mid(lsRecdata,203,12)))
			ldsDODetail.SetItem(llNewRow,'quantity',Trim(Mid(lsRecdata,203,12)))
			
			ldsDODetail.SetItem(llNewRow,'uom',Trim(Mid(lsRecdata,215,6)))
			ldsDODetail.SetItem(llNewRow,'alternate_sku',Trim(Mid(lsRecdata,221,20)))
			ldsDODetail.SetItem(llNewRow,'User_Field1',Trim(Mid(lsRecdata,241,10))) /* customer Order */
			
			ldQty = Dec(Trim(Mid(lsRecdata,270,8))) / 100
			ldsDODetail.SetItem(llNewRow,'price',Trim(Mid(lsRecdata,270,8)))		
			
			ldsDODetail.SetItem(llNewRow,'User_Field2',Trim(Mid(lsRecdata,328,15))) /* UPC */
							
		Case 'OC', 'DC' /* Header/Line Notes*/
			//This module is added by DGM 07/05/2005
			//Make sure we filtered out unnecessary data from notes
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
						
//			If lsRecType = 'DC' Then /*detail*/
//				ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',Long(Trim(Mid(lsRecdata,70,6))))
//				ldsDONotes.SetItem(llNewNotesRow,'line_item_no',Long(Trim(Mid(lsRecdata,64,6))))
//				ldsDONotes.SetItem(llNewNotesRow,'note_text',Trim(Mid(lsRecdata,82,40)))
//			Else /*header */
//				ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',Long(Trim(Mid(lsRecdata,64,6))))
//				ldsDONotes.SetItem(llNewNotesRow,'line_item_no',0)
//				ldsDONotes.SetItem(llNewNotesRow,'note_text',Trim(Mid(lsRecdata,76,40)))
//			End IF

			If lsRecType = 'DC' Then /*detail*/
			
						
			
				ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',Long(Trim(Mid(lsRecdata,70,6))))
				ldsDONotes.SetItem(llNewNotesRow,'line_item_no',Long(Trim(Mid(lsRecdata,64,6))))
				
				ls_Note_Type = Upper(Trim(Mid(lsRecdata,96,6)))
				
				
				ls_invoice_no = Trim(Mid(lsRecdata,30,30))
				li_line_item_no = integer(Trim(Mid(lsRecdata,64,6)))
				
				li_find = ldsDODetail.Find("line_item_no="+string(li_line_item_no) + " and invoice_no = '" + ls_invoice_no +"'",1, ldsDODetail.RowCount())
	

				CHOOSE CASE ls_Note_Type

				// pvh - 01/23/06 - add SHK
				case "$SHKO$"
					ls_temp = Trim(Mid(lsRecdata,102,4))  //  store
					ldsDODetail.object.User_Field4[li_find] = ls_temp

				// pvh - 01/23/06 - add NWL
				case "$NWLS$"
					ls_temp = Trim(Mid(lsRecdata,102,6))   // Vendor No
					ldsDODetail.object.User_Field3[li_find] = ls_temp 
					ls_temp = Trim(Mid(lsRecdata,108,3))  //  store
					ldsDODetail.object.User_Field4[li_find] = ls_temp
						
				// pvh - 11/18/2005 -  added walgreens
				CASE "$WGNS$"
					ls_temp = Trim(Mid(lsRecdata,102,6))   // Vendor No
					ldsDODetail.object.User_Field3[li_find] = ls_temp 
					ls_temp = Trim(Mid(lsRecdata,108,9))  //  DUNS No
					ldsDODetail.object.User_Field4[li_find] = ls_temp
					ls_temp = Trim(Mid(lsRecdata,117,5))  // WH No
					ldsDODetail.object.User_Field5[li_find] = ls_temp
				
				CASE "$TYPE$"
						ls_temp = Trim(Mid(lsRecdata,102,5))
						ldsDODetail.object.User_Field3[li_find] = Trim(Mid(lsRecdata,102,5))
						ls_temp = Trim(Mid(lsRecdata,107,4))
						ldsDODetail.object.User_Field4[li_find] = Trim(Mid(lsRecdata,107,4))
						ls_temp = Trim(Mid(lsRecdata,111,5))
						ldsDODetail.object.User_Field5[li_find] = Trim(Mid(lsRecdata,111,5))
				CASE "$TYP2$"		
						ls_temp = Trim(Mid(lsRecdata,102,9))
						ldsDODetail.object.User_Field6[li_find] = ls_temp
						
						
				CASE "$SS14$"
						ls_temp = Trim(Mid(lsRecdata,102,14))
			  			ldsDODetail.object.User_Field7[li_find] = Trim(Mid(lsRecdata,102,14))		
						
				CASE "$DESC$"
			
					if li_find > 0 then
				
						ldsDODetail.SetItem(li_find,'User_Field4',Trim(Mid(lsRecdata,102,30))) 

					end if

				CASE "$CAWA$"
									
					if li_find > 0 then
						
						ldsDODetail.SetItem(li_find,'User_Field3',Trim(Mid(lsRecdata,102,6))) 
						ldsDODetail.SetItem(li_find,'User_Field5',Trim(Mid(lsRecdata,108,4))) 
					End If
					
				Case "$DPCI$" /* 12/04 - PCONKL - Target DPCI Code */
					
					if li_find > 0 then
				
						ldsDODetail.SetItem(li_find,'User_Field3',Trim(Mid(lsRecdata,102,9))) 

					end if
				
				
				Case "$BIGL$"

					IF li_find > 0 THEN
						ldsDODetail.SetItem(li_find,'User_Field3',Trim(Mid(lsRecdata,102,12))) 
						ldsDODetail.SetItem(li_find,'User_Field4',Trim(Mid(lsRecdata,114,5))) 

					END IF
					
				CASE ELSE
	
					ldsDONotes.SetItem(llNewNotesRow,'note_text',Trim(Mid(lsRecdata,82,40)))

				END CHOOSE
			
			Else /*header */				
						
					ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',Long(Trim(Mid(lsRecdata,64,6))))
					ldsDONotes.SetItem(llNewNotesRow,'line_item_no',0)
			//MA		ldsDONotes.SetItem(llNewNotesRow,'note_text',Trim(Mid(lsRecdata,76,40)))
			//dts, 3/24/05 - un-commented out writing of header notes to delivery_notes table
					ldsDONotes.SetItem(llNewNotesRow,'note_text',lsNotes)
					
					// 06/06 - pvh - They must be ready now. uncommented exception code
					// 01/05 - PCONKL - Temporary change - Don't load TAR into UF10 for Target label until they are ready to print
					//If Trim(Mid(lsRecdata,90,3)) = 'TAR' Then
					//Else
						ldsDOHeader.SetItem(ldsDOHeader.RowCount(),'user_field10',Trim(Mid(lsRecdata,90,3))) /*userfield 10 - Label Type */
					//End If

		

		
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

public function string getsimswhcode (string phxcode);// string = getSIMSWhCode( string phxCode )

// return the sims wh_code for the passed in phx warehouse code
string findthis
long foundrow
string returnValue

returnValue = ''
findthis = "Code_ID = '" + trim( phxCode ) + "'"
foundRow = idswhXref.find( findthis, 1, idswhXref.rowcount() )
if foundRow > 0 then
	returnValue = idswhXref.object.Code_Descript[ foundrow ]
end if


return returnValue

end function

public function string getphxwhcode (string simscode);// string = getPHXWHCode( string simsCode )

// return the phx warehouse code for the passed in SIMS warehouse code

string findthis
long foundrow
string returnValue

returnValue = ''
findthis = "Code_Descript = '" + trim( UPPER( simsCode ) ) + "'"
foundRow = idswhXref.find( findthis, 1, idswhXref.rowcount() )
if foundRow > 0 then
	returnValue = idswhXref.object.Code_ID[ foundrow ]
end if


return returnValue

end function

public function integer uf_process_exception_rpt (string asinifile, string asemail);
// uf_process_exception_rpt
//Process the PHXBRANDS Exception Report File


//Datastore	ldsOut, ldsboh
Datastore ldsExpRpt
//				
//Long			llRowPos, llRowCount, llNewRow
//				
//String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
//				lsRunFreq, lsWarehouse, lsWarehouseSave, lsSIKAWarehouse, lsFileName, sql_syntax, Errors, lsFileNamePath
//
//Decimal		ldBatchSeq
//Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

STRING lsNextRunTime,	lsNextRunDate, lsRunFreq, lsProject, lsFileName, lsFileNamePath, lslogOut

//// pvh 03.16.06
//constant string lsSpaces = Space(10)
//
//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

//lsNextRunDate = ProfileString(asIniFile, 'PHXBRANDS', 'EXPRPTNEXTDATE','')
//lsNextRunTime = ProfileString(asIniFile, 'PHXBRANDS', 'EXPRPTNEXTTIME','')
//If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
//	Return 0
//Else /*valid date*/
//	ldtNextRunTime = DateTime(Date(lsNextRunDate), Time(lsNextRunTime))
//	If ldtNextRunTime > dateTime(today(), now()) Then /*not yet time to run*/
//		Return 0
//	End If
//End If


//Create the Exception Report datastore
ldsExpRpt = Create Datastore
ldsExpRpt.dataobject = "d_exception_rpt"
ldsExpRpt.SetTransObject(SQLCA)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Exception Report Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile, 'PHXBRANDS', "project", "")

//Retrieve the Exception Report Data
lsLogout = 'Retrieving Exception Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)


Long	llRowCount //, llPos
//Integer	lirc
//String	lsWhere,	lsNewSQL, lsSort

datetime ldt_start, ldt_end
integer li_day_num

choose case DayNumber ( today() )

case 1 //Sunday
	li_day_num = 3
case 2 //Monday
	li_day_num = 3
case 3
	li_day_num = 3
case 4
	li_day_num = 5
case 5
	li_day_num = 5	
case 6
	li_day_num = 5	
case 7
	li_day_num = 4
end choose

ldt_start = DateTime( RelativeDate ( today(), -30 ), Time("00:00:00"))
ldt_end =  DateTime( RelativeDate ( today(), li_day_num ), Time("23:59:59"))


llRowCount  = ldsExpRpt.Retrieve(lsProject,ldt_start, ldt_end)


// Allocate
//--


Long	llRowPos

Long llContentCount, llContentPos, llNewRow

Decimal	ldAvailQty,	ldReqQty
		
String	lsSKU, lsWarehouse, lsFilter
//, lsSupplier,
String lsSQL
			
n_ds_Content	ldsCOntent

ldsContent = Create n_ds_Content
ldsContent.Dataobject = 'd_allocation_rpt_Content'
ldsContent.SetTransObject(SQLCA)

string ls_last_warehouse = ""

//Allocate in current Sort order for Detail Records

For llRowPos = 1 to llRowCount

	lswarehouse = trim(ldsExpRpt.GetITemString(llRowPOs,'origin_whse'))
	
	IF ls_last_warehouse <> lswarehouse THEN
		ls_last_warehouse = lswarehouse
		ldsContent.Reset()
	END IF
	
	//Remove any previous filtering
	ldsContent.SetFilter('')
	ldsContent.Filter()
	
	lsSKU = ldsExpRpt.GetITemString(llRowPOs,'sku_num_at_risk')
//	lsSupplier = dw_Report.GetITemString(llRowPOs,'delivery_Detail_supp_code')

//	llOwner = dw_report.GetITemNumber(llRowPos,'delivery_Detail_Owner_id')
	ldReqQty = ldsExpRpt.GetITemNumber(llRowPos,'qty_required')
		
	//Retrieve Content records if we dont already have (Retrievestart=2)
	If ldsContent.Find("Upper(Content_SKU) = '" + Upper(lsSKU) + "'", 1, ldsContent.RowCOunt()) <= 0 Then
		ldsContent.Retrieve(lsProject, lsWarehouse, lsSku)
	End If
	
	//Filter for the current Detail Row.
	lsFilter = "Upper(Content_SKU) = '" + Upper(lsSKU) + "' and c_avail_qty > 0" /*always filter by SKU  and available qty > 0*/
	
//	//If not allowing picking by Alt Supplier, include in Filter
//	If g.is_allow_alt_supplier_pick = 'N' Then
//		lsFilter += " and Upper(Content_supp_code) = '" + Upper(lsSUpplier) + "'"
//	End If
	
//	//If not allowing to pick from all owners, filte for current Owner
//	If dw_Select.GetITemString(1,'allow_alt_owner_Ind') <> 'Y' Then
//		lsFilter += " and Content_owner_id = " + String(llOwner)
//	End If	
	
	ldsContent.SetFilter(lsFilter)
	 ldsContent.Filter()
	
	//allocate from Content records
	llContentCount = ldsContent.RowCount()
	FOr llContentPos = 1 to llContentCount
		
		ldAvailQty = ldsContent.GetITemNumber(llContentPos,'c_avail_Qty')
		If ldAvailQTy <= 0 Then Continue
		
		//If this is the first time for this detail record, update the fields on the current record, otherwise add a new row. We'll sort when we're done
		If llContentPos = 1 then
			llNewRow = llRowPos
		Else
			llNewRow = ldsExpRpt.InsertRow(0)
			
			
			//---

			ldsExpRpt.SetITem(llNewRow,'Origin_Whse',ldsExpRpt.GetITemString(llRowPos,'Origin_Whse'))
			ldsExpRpt.SetITem(llNewRow,'Carrier_SCAC',ldsExpRpt.GetITemString(llRowPos,'Carrier_SCAC'))
			ldsExpRpt.SetITem(llNewRow,'Customer_Order_Num',ldsExpRpt.GetITemString(llRowPos,'Customer_Order_Num'))
			ldsExpRpt.SetITem(llNewRow,'PO_Num',ldsExpRpt.GetITemString(llRowPos,'PO_Num'))
			ldsExpRpt.SetITem(llNewRow,'Customer_Name',ldsExpRpt.GetITemString(llRowPos,'Customer_Name'))
			ldsExpRpt.SetITem(llNewRow,'Customer_City',ldsExpRpt.GetITemString(llRowPos,'Customer_City'))
			ldsExpRpt.SetITem(llNewRow,'Customer_State',ldsExpRpt.GetITemString(llRowPos,'Customer_State'))
			ldsExpRpt.SetITem(llNewRow,'LMS_Sch_Ship_Date',ldsExpRpt.GetItemDateTime(llRowPos,'LMS_Sch_Ship_Date'))
			ldsExpRpt.SetITem(llNewRow,'RAD_Date',ldsExpRpt.GetItemDateTime(llRowPos,'RAD_Date'))
			ldsExpRpt.SetITem(llNewRow,'SKU_Num_At_Risk',ldsExpRpt.GetITemString(llRowPos,'SKU_Num_At_Risk'))
			ldsExpRpt.SetITem(llNewRow,'QTY_Required',0)
	
		End If
		
//		dw_report.SetITem(llNewRow,'c_avail_owner', ldsContent.GetITEmString(llContentPos,'owner_Owner_Cd') + '(' + ldsContent.GetITEmString(llContentPos,'owner_Owner_Type') + ')')
		
		If ldAvailQty >= ldreqqty Then
			ldsExpRpt.SetITem(llNewRow,'qty_available', ldReqQty)
			ldsContent.SetItem(llContentPos,'c_avail_qty', (ldAvailQty - ldReqQty))
			Exit
		Else /*not all available*/
			ldsExpRpt.SetITem(llNewRow,'qty_available', ldAvailQty)
			ldsContent.SetItem(llContentPos,'c_avail_qty', 0)			
			ldReqQty = ldReqQty - ldAvailQty
		End If
				
	Next /*Content record */
		
Next /*Detail Row */




//-----

ldsExpRpt.SetFilter ( "qty_available <> qty_required")
ldsExpRpt.Filter()	

llRowCount = ldsExpRpt.RowCount()


//ds_Content_Inbound.Retrieve(gs_project)

//decimal ldReqAvailQty, ld_Needed

for llRowPos = 1 to llRowCount	

	ldsExpRpt.SetItem(llRowPos,'qty_short', (ldsExpRpt.GetItemDecimal(llRowPos,'qty_required')-ldsExpRpt.GetItemDecimal(llRowPos,'qty_available')))


next



//--

ldsExpRpt.SetFilter("IsNull(qty_available) OR qty_available <> qty_required")
ldsExpRpt.Filter()


lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)


lsLogOut = 'Processing Exception Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)


//US (Cranbury, Charlotte, Fontana, and Columbus)
//PHX-CRANBY, PHX-CHARLO, PHX-FONTAN, PHX-COLUMB

lsFileName = 'ExceptionReport-US-' + String(DateTime( today(), now()), "yyyymmddhhmmss") + ".XLS"


ldsExpRpt.SetFilter("(IsNull(qty_available) OR qty_available <> qty_required) AND (origin_whse  = 'PHX-CRANBY' OR origin_whse  = 'PHX-CHARLO' OR origin_whse  = 'PHX-FONTAN' OR origin_whse  = 'PHX-COLUMB'  OR origin_whse  = 'PHX-ATLNTA')")
ldsExpRpt.Filter()

string lsCurrentWarehouse

lsCurrentWarehouse = ""	
	
for llRowPos = 1 to ldsExpRpt.RowCount()

	lswarehouse = ldsExpRpt.GetITemString(llRowPOs,'origin_whse')

	if llRowPos = 1 then lsCurrentWarehouse = lswarehouse


	if lsCurrentWarehouse <> lswarehouse then
		
		ldsExpRpt.InsertRow(llRowPos)
	
		lsCurrentWarehouse = lswarehouse
	
	end if

next



/*E-maili the Exception Report */
lsFileNamePath = ProfileString(asInifile, lsProject, "archivedirectory","") + '\' + lsFileName

ldsExpRpt.SaveAs ( lsFileNamePath, Excel!	, true )


gu_nvo_process_files.uf_send_email("PHXBRANDS", asEmail, "PHXBRANDS Daily Exception Report (" +  string(ldt_start,"mm-dd-yy") + " to " + string(ldt_end, "mm-dd-yy") +  ") - Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the PHXBRANDS Daily Exception Report (" +  string(ldt_start,"mm-dd-yy") + " to " + string(ldt_end, "mm-dd-yy") +  "), run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)






//Canada (Miss and Edmonton)


lsFileName = 'ExceptionReport-Canada-' + String(DateTime( today(), now()), "yyyymmddhhmmss") + ".XLS"



ldsExpRpt.SetFilter("(IsNull(qty_available) OR qty_available <> qty_required) AND (origin_whse = 'PHX-MISS' OR origin_whse = 'PHX-EDMONT')")
ldsExpRpt.Filter()

ldsExpRpt.SetSort("origin_whse A, sku_num_at_risk A, lms_sch_ship_date A, customer_order_num A")
ldsExpRpt.Sort()

lsCurrentWarehouse = ""	
	
for llRowPos = 1 to ldsExpRpt.RowCount()

	lswarehouse = ldsExpRpt.GetITemString(llRowPOs,'origin_whse')

	if llRowPos = 1 then lsCurrentWarehouse = lswarehouse


	if lsCurrentWarehouse <> lswarehouse then
		
		ldsExpRpt.InsertRow(llRowPos)
	
		lsCurrentWarehouse = lswarehouse
	
	end if

next


/*E-mail the Exception Report */
lsFileNamePath = ProfileString(asInifile, lsProject, "archivedirectory","") + '\' + lsFileName

ldsExpRpt.SaveAs ( lsFileNamePath, Excel!	, true )


gu_nvo_process_files.uf_send_email("PHXBRANDS", asEmail, "PHXBRANDS Daily Exception Report (" +  string(ldt_start,"mm-dd-yy") + " to " + string(ldt_end, "mm-dd-yy") +  ") - Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the PHXBRANDS Daily Exception Report (" +  string(ldt_start,"mm-dd-yy") + " to " + string(ldt_end, "mm-dd-yy") +  "), run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)




destroy ldsContent

Return 0


end function

public function integer uf_process_shipment_detail_rpt (string asinifile, string asemail);
// uf_process_shipment_detail_rpt
//Process the PHXBRANDS Shipment Daily Report File


//Datastore	ldsOut, ldsboh
Datastore ldsShipmentDetailRpt
//				
//Long			llRowPos, llRowCount, llNewRow
//				
//String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
//				lsRunFreq, lsWarehouse, lsWarehouseSave, lsSIKAWarehouse, lsFileName, sql_syntax, Errors, lsFileNamePath
//
//Decimal		ldBatchSeq
//Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

STRING lsNextRunTime,	lsNextRunDate, lsRunFreq, lsProject, lsFileName, lsFileNamePath, lslogOut

//// pvh 03.16.06
//constant string lsSpaces = Space(10)
//
//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

//lsNextRunDate = ProfileString(asIniFile, 'PHXBRANDS', 'EXPRPTNEXTDATE','')
//lsNextRunTime = ProfileString(asIniFile, 'PHXBRANDS', 'EXPRPTNEXTTIME','')
//If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
//	Return 0
//Else /*valid date*/
//	ldtNextRunTime = DateTime(Date(lsNextRunDate), Time(lsNextRunTime))
//	If ldtNextRunTime > dateTime(today(), now()) Then /*not yet time to run*/
//		Return 0
//	End If
//End If


//Create the Shipment Detail Report datastore
ldsShipmentDetailRpt = Create Datastore
ldsShipmentDetailRpt.dataobject = "d_shipment_detail_rpt"
ldsShipmentDetailRpt.SetTransObject(SQLCA)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Shipment Detail Report Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile, 'PHXBRANDS', "project", "")

//Retrieve the Shipment Detail Report Data
lsLogout = 'Retrieving Shipment Detail Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)


Long	llRowCount //, llPos
//Integer	lirc
//String	lsWhere,	lsNewSQL, lsSort

//datetime ldt_start, ldt_end
//integer li_day_num
//
//choose case DayNumber ( today() )
//
//case 1 //Sunday
//	li_day_num = 3
//case 2 //Monday
//	li_day_num = 3
//case 3
//	li_day_num = 3
//case 4
//	li_day_num = 5
//case 5
//	li_day_num = 5	
//case 6
//	li_day_num = 5	
//case 7
//	li_day_num = 4
//end choose
//
//ldt_start = DateTime( RelativeDate ( today(), -30 ), Time("00:00:00"))
//ldt_end =  DateTime( RelativeDate ( today(), li_day_num ), Time("23:59:59"))
//

llRowCount  = ldsShipmentDetailRpt.Retrieve(lsProject) // ,ldt_start, ldt_end)



string lsCurrentWarehouse

lsCurrentWarehouse = ""	

long	llRowPos
string 	lswarehouse
	
for llRowPos = 1 to ldsShipmentDetailRpt.RowCount()

	lswarehouse = ldsShipmentDetailRpt.GetITemString(llRowPOs,'wh_code')

	if llRowPos = 1 then lsCurrentWarehouse = lswarehouse


	if lsCurrentWarehouse <> lswarehouse then
		
		ldsShipmentDetailRpt.InsertRow(llRowPos)
	
		lsCurrentWarehouse = lswarehouse
	
	end if

next



lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)


lsLogOut = 'Processing Shipment Detail Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)


lsFileName = 'ShipmentDetailReport' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'




/* dts - 05/22/08 -  Now also e-mailing the Shipment Detail Report */
lsFileNamePath = ProfileString(asInifile, lsProject, "archivedirectory","") + '\' + lsFileName

ldsShipmentDetailRpt.SaveAs ( lsFileNamePath, Excel!	, true )


// (" +  string(ldt_start,"mm-dd-yy") + " to " + string(ldt_end, "mm-dd-yy") +  ")

gu_nvo_process_files.uf_send_email("PHXBRANDS", asEmail, "PHXBRANDS Daily Shipment Detail Report - Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the PHXBRANDS Daily Shipment Detail Report, run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

//(" +  string(ldt_start,"mm-dd-yy") + " to " + string(ldt_end, "mm-dd-yy") +  ")


////Set the next time to run if freq is set in ini file
//lsRunFreq = ProfileString(asIniFile, 'PHXBRANDS', 'EXPRPTFREQ', '')
//If isnumber(lsRunFreq) Then
//	//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
//	ldtNextRunDate = relativeDate(today(), Long(lsRunFreq)) /*relative based on today*/
//	SetProfileString(asIniFile, 'PHXBRANDS', 'EXPRPTNEXTDATE', String(ldtNextRunDate,'mm-dd-yyyy'))
//Else
//	SetProfileString(asIniFile, 'PHXBRANDS', 'EXPRPTNEXTDATE', '')
//End If


Return 0


end function

public function integer uf_eom_shipment_mtd (string asinifile);
// uf_process_dboh(
//Process the PHOENIX Daily Balance on Hand Confirmation File

Datastore	ldsOut, ldsboh
				
Long			llRowPos, llRowCount, llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunDate,	&
				lsRunFreq, lsWarehouse, lsFileName, lsFileNamePath

DEcimal		ldBatchSeq
Integer		liRC

Date			ldtNextRunDate

// pvh 03.16.06
constant string lsSpaces = Space(10)

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

//EOMSHIPMTDNEXTDATE=
//EOMSHIPMTDEMAIL=anderson.michael@con-way.com
//
lsNextRunDate = ProfileString(asIniFile,'PHXBRANDS','EOMSHIPMTDNEXTDATE','')

If trim(lsNextRunDate) = ''  or (not isdate(string(Date(lsNextRunDate)))) Then /*not scheduled to run*/
	Return 0
Else /*valid date*/

	If date(lsNextRunDate) > date(today()) Then /*not yet time to run*/
		Return 0
	End If
End If


//Added Shiment MTD to be run at same time.
uf_process_shipment_mtd(asinifile, true)


ldtNextRunDate = relativeDate(today(),Long(32)) /*relative based on today*/

ldtNextRunDate = date(string(Month(ldtNextRunDate)) + "-01-" + string(year(ldtNextRunDate)))

SetProfileString(asIniFile,'PHXBRANDS','EOMSHIPMTDNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))


Return 0
end function

public function integer uf_process_shipment_mtd (string asinifile, boolean ab_eom);
// uf_process_shipments_mtd
//Process the PHXBRANDS Shipment MTD Report File

Datastore ldsShipmentMTDRpt

DateTime		ldtNextRunTime
Date			ldtNextRunDate

STRING lsNextRunTime,	lsNextRunDate, lsRunFreq, lsProject, lsFileName, lsFileNamePath, lslogOut


//Create the Shipment Detail Report datastore
ldsShipmentMTDRpt = Create Datastore
ldsShipmentMTDRpt.dataobject = "d_phxbrands_mtd_shipments"
ldsShipmentMTDRpt.SetTransObject(SQLCA)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Shipment MTD Report Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile, 'PHXBRANDS', "project", "")

//Retrieve the Shipment MTD Report Data
lsLogout = 'Retrieving Shipment MTD Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)


Long	llRowCount

Date ld_Ret_Date

IF ab_eom THEN
	ld_Ret_Date = RelativeDate( Today(), -10)
ELSE
	
	ld_Ret_Date = Today()
	
END IF

llRowCount  = ldsShipmentMTDRpt.Retrieve(Month(ld_Ret_Date), Year(ld_Ret_Date))


lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)


lsLogOut = 'Processing Shipment MTD Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

IF ab_eom THEN
	lsFileName = 'ShipmentMTDReportEOM' + String( ld_Ret_Date, "yyyymm")  + '.htm'
	
ELSE
	lsFileName = 'ShipmentMTDReport' + String(DateTime( today(), now()), "yyyymmddhhmmss") +'.htm'  //'.XLS'
END IF


lsFileNamePath = ProfileString(asInifile, lsProject, "archivedirectory","") + '\' + lsFileName

ldsShipmentMTDRpt.SaveAs ( lsFileNamePath, HTMLTable!, true )


IF ab_EOM THEN

	gu_nvo_process_files.uf_send_email("PHXBRANDS", "EOMSHIPMTDEMAIL", "PHXBRANDS Shipment MTD Report - End of Month ("+String( ld_Ret_Date, "mm-yyyy")+") - Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the PHXBRANDS Shipment MTD EOM Report  - End of Month ("+String( ld_Ret_Date, "mm-yyyy")+"), run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)
	
ELSE
	//Same as BOHEMAIL
	
	gu_nvo_process_files.uf_send_email("PHXBRANDS", "BOHEMAIL", "PHXBRANDS Shipment MTD Report - Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the PHXBRANDS Shipment MTD Report, run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

END IF

Return 0


end function

public function integer uf_process_whtransf_rpt (string asinifile, string asemail);//Jxlim 11/09/2010
//uf_process_whtransf_rpt(asinifile, asemail)
//Process the PHXBRANDS Warehouse Transfer Report

Datastore	lds_wh_transfer
Long			llRowCount
String		lsOutString,	lslogOut, lsProject, lsEmail, lsFileName,  &			
				lsFileNamePath, lsLocalFromDate, lsLocalToDate	

Integer		liRC
DateTime	 ldt_start, ldt_end

//jxlim Report contains info from previous date time to today run time, didn't use the asparmstring (&from&,&to&) because we do not want to get the default calculaton that is minus 2 days

//The date range is current date back to same date of the previous month
//From same date of the previous month
ldt_start = DateTime( RelativeDate ( today(), -30 ), Time("00:00:00"))
//To Current date
ldt_end = DateTime(today(),Now())

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file
lds_wh_transfer = Create Datastore
lds_wh_transfer.Dataobject = "d_phx_warehouse_tfr_rpt"
lirc = lds_wh_transfer.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Warehouse Transfer Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Warehouse Transfer Report
lsLogout = 'Retrieving Warehouse Transfer Report.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//Retrieve report
lsProject = 'PHXBRANDS'
lsLocalFromDate 	= String(ldt_start)
lsLocalToDate		= String(ldt_end)

llRowCount  = lds_wh_transfer.Retrieve(lsProject ,lsLocalFromDate, lsLocalToDate)

lsLogOut = 'Processing Warehouse Transfer Report...'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsLogOut = String(llRowcount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsFileName = "Wh_Transfer" + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'

/* Now SAVE  it so we can attached the file to email. */
lsFileNamePath = ProfileString(asInifile, 'PHXBRANDS', "archivedirectory","") + '\' + lsFileName

lds_wh_transfer.SaveAs ( lsFileNamePath, Excel!	, true )

/* Now e-mailing the Warehouse Transfer Report */
gu_nvo_process_files.uf_send_email("PHXBRANDS", asEmail, "Warehouse Transfer Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Warehouse Transfer Report From: " +  lsLocalFromDate  +  " To: " +  lsLocalToDate +  " -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

Return 0
end function

public function integer uf_process_short_shipped_rpt (string asinifile, string asemail);
//MAS - 042611
//Process the PHXBRANDS Short Shipped Report

Datastore	lds_short_shipped
Long			llRowCount
String		lsOutString,	lslogOut, lsProject, lsEmail, lsFileName,  &			
				lsFileNamePath
				//, lsLocalFromDate, lsLocalToDate	

Integer		liRC
DateTime	 ldt_start, ldt_end



//The date range is current date back to the previous day
ldt_start = DateTime( RelativeDate ( today(), -1 ), Time("00:00:00"))
//To Current date
ldt_end =  DateTime( RelativeDate ( today(), -1 ), Time("23:59:59"))  //MEA - 8/12 - Fixed as per Fred.
//ldt_end = DateTime(today(),Now())



//This function runs on a scheduled basis - Run from the scheduler, not the .ini file
lds_short_shipped = Create Datastore
lds_short_shipped.Dataobject = "d_phxbrands_short_shipped_rpt"
lirc = lds_short_shipped.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Short Shipped Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Short Shipped Report
lsLogout = 'Retrieving Short Shipped Report.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//Retrieve report
lsProject = 'PHXBRANDS'
//Don't need report uses DT arg's
//lsLocalFromDate 	= String(ldt_start)
//lsLocalToDate		= String(ldt_end)

//***********************************
//MAS comment after testing
//ldt_start = datetime('01/01/08')
//***********************************

llRowCount  = lds_short_shipped.Retrieve(lsProject ,ldt_start, ldt_end)

lsLogOut = 'Processing Short Shipped Report...'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsLogOut = String(llRowcount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsFileName = "short_shipped_rpt" + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'

/* Now SAVE  it so we can attached the file to email. */
lsFileNamePath = ProfileString(asInifile, 'PHXBRANDS', "archivedirectory","") + '\' + lsFileName

lds_short_shipped.SaveAs ( lsFileNamePath, Excel!	, true )

/* Now e-mailing the Short Shipped Report */
gu_nvo_process_files.uf_send_email("PHXBRANDS", asEmail, "Short Shipped Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Short Shipped Report From: " +   string(ldt_start) +  " To: " +  string(ldt_end) +  " -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

Destroy lds_short_shipped

Return 0

end function

on u_nvo_proc_phoenix.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_phoenix.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
idswhXref = f_datastorefactory('d_phxbrands_whxref')
idswhXref.retrieve()

end event

event destructor;if isValid( idswhXref ) then destroy idswhXref

end event

