HA$PBExportHeader$u_nvo_proc_solectron.sru
$PBExportComments$Process Solectron files
forward
global type u_nvo_proc_solectron from nonvisualobject
end type
end forward

global type u_nvo_proc_solectron from nonvisualobject
end type
global u_nvo_proc_solectron u_nvo_proc_solectron

type variables
//String	isWarehouse
end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_dboh (string asinifile)
public function integer uf_process_itemmaster (string aspath, string asproject)
public function integer uf_process_po (string aspath, string asproject)
public function integer uf_process_so (string aspath, string asproject)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 2 characters of the file name

String	lsLogOut,	&
			lsSaveFileName
Integer	liRC

Boolean	lbOnce
lbOnce = false

Choose Case Upper(Left(asFile,2))
		
	Case 'IM' /*Item Master File*/
		
		liRC = uf_Process_ItemMaster(asPath, asProject)	
		
	Case 'PM' /*Processed PM File */
		
		liRC = uf_process_po(asPath, asProject)
		
		//Process any added PO's 
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
			
	Case 'DM' /* Sales Order Files*/
		
		liRC = uf_process_so(asPath, asProject)
		
		//Process any added SO's
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 

Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
end function

public function integer uf_process_dboh (string asinifile);

//Process the SOLECtron Daily Balance on Hand Confirmation File


Datastore	ldsOut,	&
				ldsboh
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

lsNextRunDate = ProfileString(asIniFile,'SOLECTRON','DBOHNEXTDATE','')
lsNextRunTime = ProfileString(asIniFile,'SOLECTRON','DBOHNEXTTIME','')
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
ldsboh.Dataobject = 'd_nortel_boh' /* at the SKU/Inv Type level */
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: SOLECTRON Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile,'SOLECTRON',"project","")

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
	lsOutString = 'BH|' /*rec type = balance on Hand Confirmation*/
// TAM - There warehouse code is EE for Eersel/Selectron warehouse
//	lsOutString += Upper(ldsboh.GetItemString(llRowPos,'wh_Code')) + '|'
	lsOutString += 'EE|'
	lsOutString += Upper(ldsboh.GetItemString(llRowPos,'inventory_type')) + '|'
	lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),50) + '|'
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'total_qty'),'000000000')
		
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'BH' + String(ldBatchSeq,'00000000') + '.DAT'
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)
	
next /*next output record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,"SOLECTRON")

//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile,'SOLECTRON','DBOHFREQ','')
If isnumber(lsRunFreq) Then
	//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile,'SOLECTRON','DBOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile,'SOLECTRON','DBOHNEXTDATE','')
End If



Return 0
end function

public function integer uf_process_itemmaster (string aspath, string asproject);// 02/04 PCONKL

//Process Item Master (IM) Transaction for SOLECTRON


String	lsData, lsTemp, lsLogOut, lsStringData, lsSKU, 	lsCOO
			
Integer	liRC,	liFileNo
			
Long		llCount,	llOwner, llNew, llExist, llNewRow, llFileRowCount, llFileRowPos 

Decimal ldtemp

Boolean	lbNew, lbError

u_ds_datastore	ldsItem 
datastore	lu_DS

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master'
ldsItem.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master File for SOLECTRON Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',Trim(lsStringData))
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Process each Row
llFileRowCOunt = lu_ds.RowCount()

For llfileRowPos = 1 to llFileRowCOunt
	
	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))

	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsDAta,Len(lsData) - 1)
	End If
	
	//Validate Rec Type is IM
	lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	If lsTemp <> 'IM' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Validate SKU and retrieve existing or Create new Row
	If Pos(lsData,'|') > 0 Then
	
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsSKU = lsTemp

	//Retrieve the DS to populate existing SKU if it exists, otherwise insert new
		llCount = ldsItem.Retrieve(asProject, lsSKU)
		If llCount <= 0 Then
			
			llNew ++ /*add to new count*/
			lbNew = True
			llNewRow = ldsItem.InsertRow(0)
			ldsItem.SetItem(1,'project_id',asProject)
			ldsItem.SetItem(1,'SKU',lsSKU)
							
		Else /*Item Master(s) exist */
		
			llexist += llCount /*add to existing Count*/
			lbNew = False
	
		End If
			
	Else /*error*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
		lbError = True
	//		Continue /*Process Next Record */
		
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
		
	//Supplier and Owner
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If lsTEmp > '' Then
			ldsItem.SetItem(1,'supp_code',left(lsTemp,20))
			//Retrieve Owner SOLECTRON 
			Select owner_id into :llOwner
			From Owner
			Where project_id = :asProject and owner_type = 'S' and Owner_cd = :lstemp ;
			ldsItem.SetItem(1,'owner_id',llOwner)
		End If
	Else /*Default*/
		ldsItem.SetItem(1,'supp_code','SLR')
		//Retrieve Owner SOLECTRON 
		Select owner_id into :llOwner
		From Owner
		Where project_id = :asProject and owner_type = 'S' and Owner_cd = 'SLR' ;
		ldsItem.SetItem(1,'owner_id',llOwner)
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
		
	//Description
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If lsTEmp > '' Then
			ldsItem.SetItem(1,'Description',left(lsTemp,70))
		End If
//	Else /*error*/
//		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Description' field. Record will not be processed.")
//		lbError = True
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	//base UOM maps to UOM 1 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If lsTEmp > '' Then
			ldsItem.SetItem(1,'uom_1',left(lsTemp,4))
		Else 
			ldsItem.SetItem(1,'uom_1','EA') //Default EA
		End If
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Net Weight maps to Weight 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldsItem.SetItem(1,'weight_1',Dec(lsTemp))
		End If
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Net Length maps to Length 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp) * .01
			ldsItem.SetItem(1,'Length',ldTemp)
		End If
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Net Width maps to Width 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp) * .01
			ldsItem.SetItem(1,'Width_1',ldTemp)
		End If
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Net Height maps to Height 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp) * .01
			ldsItem.SetItem(1,'Height_1',ldTemp)
		End If
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Standard Cost
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp) * .0001
			ldsItem.SetItem(1,'Std_Cost',ldTemp)
		End If
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Cycle Count Frequency in Days
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp) 
			ldsItem.SetItem(1,'cc_freq',ldTemp)
		End If
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//UPC Code
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp) 
			ldsItem.SetItem(1,'Part_UPC_Code',ldTemp)
		End If
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Freight Class 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If lsTEmp > '' Then
			ldsItem.SetItem(1,'Freight_Class',left(lsTemp,10))
		End If
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Storage Code 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If lsTEmp > '' Then
			ldsItem.SetItem(1,'Storage_Code',left(lsTemp,10))
		End If
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Inventory Class 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If lsTEmp > '' Then
			ldsItem.SetItem(1,'Inventory_Class',left(lsTemp,10))
		End If
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Alternate SKU 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If lsTEmp > '' Then
			ldsItem.SetItem(1,'Alternate_SKU',left(lsTemp,50))
		End If
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Default COO 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If lsTEmp > '' Then
			ldsItem.SetItem(1,'Country_Of_Origin_Default',left(lsTemp,3))
		Else
			ldsItem.SetItem(1,'Country_Of_Origin_Default','XXX')
		End If
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Shelf Life in Days
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp) 
			ldsItem.SetItem(1,'Shelf_Life',ldTemp)
		End If
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	If lsData > '' Then
		ldsItem.SetItem(1,'item_delete_ind',lsData)
	End If

	//Item Delete Ind
//	If Pos(lsData,'|') > 0 Then
//		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
//		If lsTEmp > '' Then
//			ldsItem.SetItem(1,'item_delete_ind',lsTemp)
//		End If
//	End If
		
//	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	
	//Update any record defaults
	ldsItem.SetItem(1,'Last_user','SIMSFP')
	ldsItem.SetItem(1,'last_update',today())
		
	//If record is new...
	If lbNew Then
		ldsItem.SetItem(1,'lot_controlled_ind','N') 
		ldsItem.SetItem(1,'po_controlled_ind','N') 
		ldsItem.SetItem(1,'serialized_ind','N')
		ldsItem.SetItem(1,'po_no2_controlled_ind','N')
		ldsItem.SetItem(1,'container_tracking_ind','N') 
	End If
			
	//Save NEw Item to DB
	lirc = ldsItem.Update()
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Master Record to database!"
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

public function integer uf_process_po (string aspath, string asproject);String	lsLogout, lsStringData, lsOrder, lsWarehouse, lsTemp, lsREcData, lsRecType

Integer	liFileNo, liRC

Long	llNewRow, llNewDetailRow, llFindRow, llRowCount, llRowPos, llOrderSeq, llDetailSeq, llCount, llOwner

Decimal	ldEDIBAtchSeq,	ldPOQTY,	ldLineNo

Boolean	lbError, lbPM, lbPD

DateTime	ldtToday

Datastore	ldsPOHeader, ldsPODetail, lu_ds

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
	lsLogOut = "-       ***Unable to Open File for Pulse Processing: " + asPath
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

//Owner defaults to owner ID created for Supplier SOLECTRON
Select owner_id into :llOwner
From Owner
Where project_id = :asProject and owner_type = 'S' and Owner_cd = 'SLR';

//Process each row of the File
llRowCount = lu_ds.RowCount()
For llRowPos = 1 to llRowCount
	lbPD = false
	lbPM = false 

	lsrecData = Trim(lu_ds.GetITemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsREcType)
			
	Case 'PM' /*PO Header*/
			
		w_main.SetMicroHelp("Processing PM Inbound Master Record " + String(llRowPos) + " of " + String(llRowCount))  
		llNewRow = 	ldsPOHeader.InsertRow(0)

		//Get the next available Seq #
		ldEDIBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
		If ldEDIBatchSeq < 0 Then
			Return -1
		End If	

		lbPM = true 
		llDetailSeq = 0 /*detail seq within order for detail recs */	
			
			
		//New REcord DEfaults
		ldsPOHeader.SetITem(llNewRow,'project_id',asProject)
		ldsPOHeader.SetITem(llNewRow,'wh_code',lsWarehouse)
		ldsPOHeader.SetITem(llNewRow,'supp_code','SLR') 
		ldsPOHeader.SetITem(llNewRow,'Request_date',String(Today(),'YYMMDD'))
		ldsPOheader.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
		llOrderSeq = llNewRow /*header seq */
		ldsPOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
		ldsPOHeader.SetItem(llNewRow,'ftp_file_name',asPath) /*FTP File Name*/
		ldsPOHeader.SetItem(llNewRow,'Status_cd','N')
		ldsPOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')
		
		ldsPOHeader.SetItem(llNewRow,'Order_type','S') /*Supplier Order*/
		ldsPOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
					
		lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
		
		//ACtion Code
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
		End If
						
		ldsPOHeader.SetItem(llNewRow,'action_cd',lsTemp)
		
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//No more required fields after Order Number
		
		//Order Number
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else 
			lsTemp = lsRecData
		End If
						
		ldsPOHeader.SetItem(llNewRow,'order_no',Trim(lsTemp))
		
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
		//Supplier 
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else 
			lsTemp = lsRecData
		End If
		
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
		//Expected Arrival Date
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else 
			lsTemp = lsRecData
		End If
					
		ldsPOHeader.SetItem(llNewRow,'Arrival_Date',lsTemp)
					
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
		//Warehouse - Ignore for now - get from project default
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else 
			lsTemp = lsRecData
		End If
					
		//ldsPOHeader.SetItem(llNewRow,'wh_Code',lsTemp)
					
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
		//Carrier
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else 
			lsTemp = lsRecData
		End If
					
		ldsPOHeader.SetItem(llNewRow,'Carrier',lsTemp)
					
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
		//Remarks
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else 
			lsTemp = lsRecData
		End If
					
		ldsPOHeader.SetItem(llNewRow,'remark',lsTemp)
					
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
	Case 'PD' /* detail*/
		
		llNewDetailRow = 	ldsPODetail.InsertRow(0)
		lbPD = true
					
		//Add detail level defaults
		ldsPODetail.SetItem(llNewDetailRow,'order_seq_no',llORderSeq) 
		ldsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
		ldsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
		ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
		ldsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
		llDetailSeq ++
		ldsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llDetailSeq))
		ldsPODetail.SetItem(llNewDetailRow,'owner_id',string(llOwner)) //OwnerID if Present	

		lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
				
		//ACtion Code
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llDetailSeq) + " - Data expected after 'ACtion Code' field. Record will not be processed.")
			lbError = True
		End If
						
		ldsPODetail.SetItem(llNewDetailRow,'action_cd',lsTemp)
		
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
		
		//Order Number
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llDetailSeq) + " - Data expected after 'Order Number' field. Record will not be processed.")
			lbError = True
		End If
						
		ldsPODetail.SetItem(llNewDetailRow,'Order_No',Trim(lsTemp))
		
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
		//Line Item Number
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llDetailSeq) + " - Data expected after 'Line Item Number' field. Record will not be processed.")
			lbError = True
		End If
						
		ldsPODetail.SetItem(llNewDetailRow,'line_item_no',Long(Trim(lsTemp)))
		
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
		
		//SKU
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llDetailSeq) + " - Data expected after 'SKU' field. Record will not be processed.")
			lbError = True
		End If
						
		ldsPODetail.SetItem(llNewDetailRow,'SKU',lsTemp)
		
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
		//Qty
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else
			lsTemp = lsRecData
		End If
		
		If Not isnumber(lsTemp) Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llDetailSeq) + " - 'Quantity' is not numeric. Record will not be processed.")
			lbError = True
		Else
			ldsPODetail.SetItem(llNewDetailRow,'quantity',Trim(lsTemp))
		End If
								
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
		
//		//Inventory Type
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//			If Not isNull(lsTemp) Then ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type',lsTemp)
//		Else
//			lsTemp = lsRecData
//		End If
//						
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//Alternate SKU
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//			If Not isNull(lsTemp) Then ldsPODetail.SetItem(llNewDetailRow,'alternate_SKU',lsTemp)
//		Else
//			lsTemp = lsRecData
//		End If
//
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		//Lot
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//			If Not isNull(lsTemp) Then ldsPODetail.SetItem(llNewDetailRow,'Lot_No',lsTemp)
//		Else
//			lsTemp = lsRecData
//		End If
//						
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//PONO
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//			If Not isNull(lsTemp) Then ldsPODetail.SetItem(llNewDetailRow,'PO_NO',lsTemp)
//		Else
//			lsTemp = lsRecData
//		End If
//
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		//PONO2
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//			If Not isNull(lsTemp) Then ldsPODetail.SetItem(llNewDetailRow,'PO_NO2',lsTemp)
//		Else
//			lsTemp = lsRecData
//		End If
//						
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		
//		//Serial Number
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//			If Not isNull(lsTemp) Then ldsPODetail.SetItem(llNewDetailRow,'Serial_No',lsTemp)
//		Else
//			lsTemp = lsRecData
//		End If
//
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//		
//		If Pos(lsRecData,'|') > 0 Then
//			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//		Else
//			lsTemp = lsRecData
//		End If
//						
//		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

	Case Else /* Invalid Rec Type*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llDetailSeq) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
		Return -1
		
	End Choose /*record Type*/

	//Save the Changes
	if lbPM or lbPD then // do only if an update is attempted
		lirc = ldsPOHeader.Update()
		if lbPD and liRC = 1 then lirc = ldsPODetail.Update()
		If liRC = 1 then
			Commit;
		Else
			Rollback;
			lsLogOut = Space(17) + "- ***System Error!  Unable to Save new PO Records to database!"
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new PO Records to database!")
			Return -1
		End If
	end if
  
Next /*File Row */
	

Return 0

end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for Solectron
Datastore	ldsDOHeader,	&
				ldsDODetail,	&
				ldsDOAddress,	&
				lu_ds
				
String		lsLogout, lsRecData, lsTemp,lsErrText, lsSKU, lsRecType, lswarehouse, &
				lsBillToName, lsBillToAddr1, lsBillToADdr2, lsBillToADdr3,  lsBillToAddr4, lsBillToStreet,	&
				lsBillToZip, lsBillToCity, lsBillToState, lsBillToCountry, lsBillToTel, lsOrdType

Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos, llNewRow, llCount, llQty,	&
				llCONO, llRoNO, llLineItemNo,  llOwner, llNewAddressRow, llFindRow, llBatchSeq, llOrderSeq, llLineSeq
				
Decimal		ldQty
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError, lbBillToAddress, lbDM, lbDD

ldtToday = DateTime(today(),Now())

	
///////	
	

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

//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for SOLECTRON Processing: " + asPath
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

//Warehouse will have to be defaulted from project master default warehouse
Select wh_code into :lswarehouse
From Project
Where Project_id = :asProject;

//Get Default owner for SOLECTRON (Supplier) 
Select owner_id into :llOwner
From OWner
Where project_id = :asProject and Owner_cd = 'SLR' and owner_type = 'S';

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = lu_ds.RowCount()


//Process each Row
For llRowPos = 1 to llRowCount 

	lsRecData = Trim(lu_ds.GetITemString(llRowPos,'rec_data'))
	lsRecType = Left(lsRecData,2)

	//Process header or Detail */
	Choose Case Upper(lsRecType)
			
		//HEADER RECORD
		Case 'DM' /* Header */
			
//			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			llnewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
						
			//Record Defaults
			ldsDOHeader.SetItem(llNewRow,'ACtion_cd','A') /*always a new Order*/
			ldsDOHeader.SetITem(llNewRow,'project_id',asProject) /*Project ID*/
			ldsDOHeader.SetITem(llNewRow,'wh_code',lswarehouse) /*Default WH for Project */
			ldsDOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow,'Status_cd','N')
			ldsDOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')
						
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			//From File...
			
			
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Record will not be processed.")
				lbError = True
			End If

			ldsDOHeader.SetItem(llNewRow,'invoice_no',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
						
			//Delivery Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			End If
			
			ldsDOHeader.SetItem(llNewRow,'request_Date',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Goods Issue Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			End If
			
			ldsDOHeader.SetItem(llNewRow,'schedule_Date',Trim(lsTemp))

			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
		//Order Drop Date
		// To be coded
			
			//Cust Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDOHeader.SetItem(llNewRow,'cust_Code',Trim(lsTemp))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Customer Code' field. Record will not be processed.")
				lbError = True
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Delivery ORder Type - Validate from Table, If not valid, default to 'S'
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			End If
			
			lsOrdType = Trim(lsTemp)
			
			Select Count(*) into :llCount
			FRom Delivery_Order_Type
			Where Project_id = :asProject and ord_type = :lsOrdType;
			
			If llCount > 0 Then
				ldsDOHeader.SetItem(llNewRow,'order_Type',lsOrdType)
			Else
				ldsDOHeader.SetItem(llNewRow,'order_Type','S') /*default to SALE */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Customer PO - Customer Order NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If

			ldsDOHeader.SetItem(llNewRow,'Order_No',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//carrier 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'Carrier',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			//carrier name (Not Used)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			//Ship to Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'Cust_Name',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Address 1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'address_1',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Address 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'address_2',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Address 3
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'address_3',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Address 4
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'address_4',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//City
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'City',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//State
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'state',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Postal Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'zip',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Country
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'Country',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Telephone
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'tel',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			 //If we have Bill to information, we will need to build an Alt Address record
		 	lbBillToAddress = False
		 
		 	//Bill To Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToName = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
		 	//Bill To Addr1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToADdr1 = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To Addr2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToADdr2 = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To Addr3
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToADdr3 = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To Addr4
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToADdr4 = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		 				
			//Bill To City
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToCity = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To State
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToState = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To Zip
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToZip = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To Country
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToCountry = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To Tel
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillTotel = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//If we have Bill To Information, create the Alt Address record
			If lbBillToAddress Then
				
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				ldsDOAddress.SetItem(llNewAddressRow,'address_type','BT') /* Bill To Address */
				ldsDOAddress.SetItem(llNewAddressRow,'Name',lsBillToName)
				ldsDOAddress.SetItem(llNewAddressRow,'address_1',lsBillToAddr1)
				ldsDOAddress.SetItem(llNewAddressRow,'address_2',lsBillToAddr2)
				ldsDOAddress.SetItem(llNewAddressRow,'address_3',lsBillToAddr3)
				ldsDOAddress.SetItem(llNewAddressRow,'address_4',lsBillToAddr4)
				ldsDOAddress.SetItem(llNewAddressRow,'City',lsBillToCity)
				ldsDOAddress.SetItem(llNewAddressRow,'State',lsBillToState)
				ldsDOAddress.SetItem(llNewAddressRow,'Zip',lsBillToZip)
				ldsDOAddress.SetItem(llNewAddressRow,'Country',lsBillToCountry)
				ldsDOAddress.SetItem(llNewAddressRow,'tel',lsBillToTel)
				
			End If /*alt address exists*/
			
		// DETAIL RECORD
		Case 'DD' /*Detail */
			
//			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			llnewRow = ldsDODetail.InsertRow(0)
			llLineSeq ++
						
			//Add detail level defaults
			ldsDODetail.SetITem(llNewRow,'project_id', asproject) /*project*/
			//ldsDODetail.SetITem(llNewRow,'action_cd', 'A')  /*always Add */
			ldsDODetail.SetITem(llNewRow,'Inventory_Type', 'N')
			ldsDODetail.SetITem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDODetail.SetITem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDODetail.SetITem(llNewRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetITem(llNewRow,'Status_cd','N')
			ldsDODetail.SetITem(llNewRow,'supp_code', 'SLR')
						
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */

		//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDODetail.SetItem(llNewRow,'invoice_no',Trim(lsTemp))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Line Item Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If isNumber(lsTemp) Then
					ldsDODetail.SetItem(llNewRow,'line_item_no',Long(Trim(lsTemp)))
				Else
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - Line Item Number is not numeric. Row will not be processed")
					lbError = True
					Continue /*Process Next Record */
				End If
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Line Item Number' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDODetail.SetItem(llNewRow,'SKU',Trim(lsTemp))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'SKU' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
							
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Quantity
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If isNumber(lsTemp) Then
					ldsDODetail.SetItem(llNewRow,'quantity',Trim(lsTemp))
					llqty = long(lstemp)
				Else
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - Quantity is not numeric. Row will not be processed")
					lbError = True
					Continue /*Process Next Record */
				End If
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Quantity' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Inventory _type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If Not isNull(lsTemp) Then
					ldsDODetail.SetItem(llNewRow,'Inventory_Type',Trim(lsTemp))
				Else
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - Quantity is not numeric. Row will not be processed")
					lbError = True
					Continue /*Process Next Record */
				End If
			Else
				lsTEmp = trim(lsRecData)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			// No more required fields after this point
			
			//Customer PO Line - Mapped to USer Field 1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'user_field1',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Alternate SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'alternate_sku',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Lot No
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'lot_no',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'po_no',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'po_no2',Trim(lsTemp))
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Serial Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
				If llqty = 1 Then // Ony Add Serial Number if Qty = 1 
					ldsDODetail.SetItem(llNewRow,'Serial_No',Trim(lsTemp))
				End If
			Else
				lsTEmp = trim(lsRecData)
			End If
			llqty = 0			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Note Text
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDODetail.SetItem(llNewRow,'line_item_notes',Trim(lsTemp))
			Else 
				lsTEmp = trim(lsRecData)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

	Case Else /*Invalid rec type */
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Return -1
			
	End Choose /*Header or Detail */
Next

//Save Changes
liRC = ldsDOHeader.Update()
If liRC = 1 Then
	liRC = ldsDODetail.Update()
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

on u_nvo_proc_solectron.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_solectron.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

