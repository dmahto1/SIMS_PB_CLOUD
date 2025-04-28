$PBExportHeader$u_nvo_proc_funai.sru
$PBExportComments$Process FUNAI files
forward
global type u_nvo_proc_funai from nonvisualobject
end type
end forward

global type u_nvo_proc_funai from nonvisualobject
end type
global u_nvo_proc_funai u_nvo_proc_funai

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsDONotes,		&
				idsDoAddress,	&
				iu_DS,			&
				idsRONotes,	&
				idsROAddress
				


				



end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_itemmaster (string aspath, string asproject)
protected function integer uf_process_po (string aspath, string asproject)
public function integer uf_process_return_order (string aspath, string asproject)
public function string getphilipsinvtype (string asinvtype)
public function integer uf_process_dboh ()
public function string getmenloinvtype (string asinvtype)
public function string nonull (string as_str)
public function integer uf_process_dboh_volume ()
public function integer uf_process_dboh_bonded (string asbondedwhsinvtypes)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);
String	lsLogOut,lsSaveFileName, lsStringData

Integer	liRC, liFileNo

Boolean	bRet


If Left(asFile,2) = 'PM' Then /* PO File*/
	
		liRC = uf_process_po(asPath, asProject)
	
		//Process any added PO's
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
		
ElseIf Left(asFile,2) = 'RM' Then /* Return Order File*/
		
		liRC = uf_process_return_order(asPath, asProject)
	
		//Process any added orders
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
			
ElseIf Left(asFile,2) =  'DM' Then /* Sales Order Files from LMS to SIMS*/
		
		liRC = uf_process_so(asPath, asProject)
		
		//Process any added SO's
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
		
ElseIf Left(asFile,2) =  'IM' Then /* Item Master File*/
		
		liRC = uf_process_itemMaster(asPath, asProject)
		
Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
	End If

Return liRC
end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for Philips

Datastore	ldsDOHeader, ldsDODetail,	ldsDOAddress, 	lu_ds, ldsDONotes
				
String		lsLogout, lsRecData, lsTemp,lsErrText, lsSKU, lsRecType, lswarehouse, lsSupplier,		lsFind,	&
				lsSoldToName, lsSoldToAddr1, lsSoldToADdr2, lsSoldToADdr3,  lsSoldToAddr4, lsSoldToStreet, lsDetailID,	&
				lsSoldToDistrict,lsSoldToZip, lsSoldToCity, lsSoldToState, lsSoldToCountry, lsOrdType, lsNoteText,  lsTempNoteText, lsOrder, lsNoteType


Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos, llNewRow, llCount, llQty, llChildQty, llNewNotesRow,	 llPos, llBOMLine, &
				llCONO, llRoNO,  llOwner, llNewAddressRow, llFindRow, llBatchSeq, llOrderSeq, llLineSeq, llNoteSeq,  llNoteLine, lLDetailFindROw
				
Decimal		ldQty
				
DateTime		ldtToday, ldtOrderDate
Date			ldtShipDate
Boolean		lbError, lbSoldToAddress


ldtToday = DateTime(today(),Now())

select Max(dateAdd( hour, 8,:ldtToday )) into :ldtOrderDate
from sysobjects;


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
	lsLogOut = "-       ***Unable to Open File for FUNAI Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',lsRecData) 
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)



//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Warehouse defaulted from project master default warehouse - only need to retrieve once
//Select wh_code into :lsWarehouse
//From Project
//Where Project_id = :asProject;

llOrderSeq = 0 /*order seq within file*/

llRowCount = lu_ds.RowCount()


//Process each Row
For llRowPos = 1 to llRowCount 
	
	lsRecData = lu_ds.GetITemString(llRowpos, 'rec_data')
	
	lsRecType = Left(lsRecData,2)
	
	//Process header or Detail */
	Choose Case Upper(lsRecType)
			
		//HEADER RECORD
		Case 'DM' /* Header */

			llnewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
						
			//Record Defaults
			ldsDOHeader.SetItem(llNewRow,'ACtion_cd','A') /*always a new Order*/
			ldsDOHeader.SetITem(llNewRow,'project_id',asProject) /*Project ID*/
		//	ldsDOHeader.SetITem(llNewRow,'wh_code',lswarehouse) /*Default WH for Project */
			ldsDOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewRow,'Order_Type','S') /*default to Sale*/
			ldsDOHeader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow,'Status_cd','N')
			ldsDOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')
			ldsDOHeader.SetItem(llNewRow,'ord_date',String(ldtOrderDate,'yyyy/mm/dd hh:mm'))
						
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			
			//From File...
			
					
			
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If

			ldsDOHeader.SetItem(llNewRow,'invoice_no',lsTemp)
			lsOrder = lsTemp
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			
						
			//Delivery Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Date' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If
			
			ldsDOHeader.SetItem(llNewRow,'request_Date',Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			
			//Cust Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDOHeader.SetItem(llNewRow,'cust_Code',Trim(lsTemp))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Customer Code' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
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
			
			
			//Customer PO - Customer Order NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Customer PO Number' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If

			ldsDOHeader.SetItem(llNewRow,'Order_No',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
									
			
			//Ship to Name 1 (Address 1)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			ldsDOHeader.SetItem(llNewRow,'address_1',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Name 2 (Address 2)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			ldsDOHeader.SetItem(llNewRow,'address_2',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Ship to Name 3 (Address 3)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			ldsDOHeader.SetItem(llNewRow,'address_3',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Name 4 (Address 4)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			ldsDOHeader.SetItem(llNewRow,'address_4',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Ship to District
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			ldsDOHeader.SetItem(llNewRow,'district',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
					
			//Postal Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'zip',Trim(lsTemp))
			
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
							
			//Country
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'Country',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
		
			 //If we have SoldTo  information, we will need to build an Alt Address record
		 	lbSoldToAddress = False
		 
		 	//Sold  To Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToName = Trim(lsTemp)
			Else
				lsSoldToName = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
		 	//Sold To Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToADdr1 = Trim(lsTemp)
			Else
				lsSoldToADdr1 = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Sold To Name 1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToADdr2 = Trim(lsTemp)
			Else
				lsSoldToADdr2 = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Sold To Name 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToADdr3 = Trim(lsTemp)
			Else
				lsSoldToADdr3 = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Sold To Name 3
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToADdr4 = Trim(lsTemp)
			Else
				lsSoldToADdr4 = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		 				
			//Sold To Name 4 - Nowhere to mapt it to? Hope we don't need it! - We need it - Map to District
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToDistrict = Trim(lsTemp)
			Else
				lsSoldToDistrict = ''
			End If
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Sold To District - Ignore for now
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			
			//Sold To Zip
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToZip = Trim(lsTemp)
			Else
				lsSoldToZip = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Sold To City
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToCity = Trim(lsTemp)
			Else
				lsSoldToCity = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Sold To State
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToState = Trim(lsTemp)
			Else
				lsSoldToState = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Sold To Country
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbSoldToAddress = True
				lsSoldToCountry = Trim(lsTemp)
			Else
				lsSoldToCountry = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
					
			//Plant Code (UF3)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				ldsDOHeader.SetItem(llNewRow,'User_Field3',Trim(lsTemp))
			End If
			
			
			// Warehouse is being set based on the Plant Code - hardcoded for now
			If upper(Trim(lsTemp)) = "2180"  OR upper(Trim(lsTemp)) = "MY10"  Then /*Malaysia*/
				ldsDOHeader.SetItem(llNewRow, 'wh_code',"FUNAI-MY") 
			Else /*Singapoore */
				ldsDOHeader.SetItem(llNewRow, 'wh_code',"FUNAI-SG") 
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Shipping Route ->UF2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				ldsDOHeader.SetItem(llNewRow,'User_Field2',Trim(lsTemp))
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			// cawikholm 06/14/11 Add ship ref 
			//Ship Ref
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				ldsDOHeader.SetItem(llNewRow,'Ship_ref',Trim(lsTemp))
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//If we have Sold To Information, create the Alt Address record
			If lbSoldToAddress Then
				
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				ldsDOAddress.SetItem(llNewAddressRow,'address_type','ST') /* Sold To Address */
				ldsDOAddress.SetItem(llNewAddressRow,'Name',lsSoldToName)
				ldsDOAddress.SetItem(llNewAddressRow,'address_1',lsSoldToAddr1)
				ldsDOAddress.SetItem(llNewAddressRow,'address_2',lsSoldToAddr2)
				ldsDOAddress.SetItem(llNewAddressRow,'address_3',lsSoldToAddr3)
				ldsDOAddress.SetItem(llNewAddressRow,'address_4',lsSoldToAddr4)
				ldsDOAddress.SetItem(llNewAddressRow,'district',lsSoldToDistrict)
				ldsDOAddress.SetItem(llNewAddressRow,'City',lsSoldToCity)
				ldsDOAddress.SetItem(llNewAddressRow,'State',lsSoldToState)
				ldsDOAddress.SetItem(llNewAddressRow,'Zip',lsSoldToZip)
				ldsDOAddress.SetItem(llNewAddressRow,'Country',lsSoldToCountry)
					
			End If /*alt address exists*/
			
	
				
		// DETAIL RECORD
		Case 'DD' /*Detail */

			llnewRow = ldsDODetail.InsertRow(0)
			llLineSeq ++ /*also used for Line_Item_No in Detail record*/
						
			//Add detail level defaults
			ldsDODetail.SetITem(llNewRow,'project_id', asproject) /*project*/
			ldsDODetail.SetITem(llNewRow,'Inventory_Type', 'N')
			ldsDODetail.SetITem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDODetail.SetITem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDODetail.SetITem(llNewRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetITem(llNewRow,'Status_cd','N')
									
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */

			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDODetail.SetItem(llNewRow,'invoice_no',Trim(lsTemp))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Record will not be processed.")
				lbError = True
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				Continue /*Process Next Record */
			End If
			
			
			//Make sure we have a header for this Detail...
			If ldsDOHeader.Find("Upper(invoice_no) = '" + Upper(lstemp) + "'",1,ldsDOHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
				lbError = True
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Line Item Number 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If isNumber(lsTemp) Then
						ldsDODetail.SetItem(llNewRow,'line_item_no',Long(lsTemp))
						ldsDODetail.SetItem(llNewRow,'User_Field2',Trim(lsTemp)) /*Mapping to UF so we can send back on confirmation*/
				Else
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - Line Item Number is not numeric. Row will not be processed")
					lbError = True
					ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
					Continue /*Process Next Record */
				End If
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Line Item Number' field. Record will not be processed.")
				lbError = True
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				Continue /*Process Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//SKU 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDODetail.SetItem(llNewRow,'SKU',Trim(lsTemp))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'SKU' field. Record will not be processed.")
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				lbError = True
				Continue /*Process Next Record */
			End If
									
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Supplier (Plant Code)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDODetail.SetItem(llNewRow,'supp_code',Trim(lsTemp))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Supplier (Plant Code)' field. Record will not be processed.")
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				lbError = True
				Continue /*Process Next Record */
			End If
									
			//Get the default owner for this Supplier
			llOwner = 0
			
			Select Owner_id into :llOwner
			From Owner
			Where project_id = :asProject and owner_type = 'S' and owner_cd = :lsTemp;
			
			If llOwner > 0 Then
				ldsDODetail.SetItem(llNewRow,"owner_id",string(llOwner))
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
					ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
					lbError = True
					Continue /*Process Next Record */
				End If
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after ' Quantity' field. Record will not be processed.")
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				lbError = True
				Continue /*Process Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			
			
			//Inventory _type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If Not isNull(lsTemp) Then
			//		ldsDODetail.SetItem(llNewRow,'Inventory_Type',Trim(lsTemp))
				Else
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - No delimiter found after 'Inventory Type' field. Record will not be processed.")
					ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
					lbError = True
					Continue /*Process Next Record */
				End If
			Else
				lsTEmp = trim(lsRecData)
			End If
			
			If lsTemp > '' Then
				ldsDODetail.SetItem(llNewRow,'Inventory_Type',getMenloInvType(Trim(lsTemp))) /*Convert to Menlo type */
				ldsDODetail.SetItem(llNewRow,'User_Field1',lsTemp) /*Display Philips Inv Type in UF1 */
			End If
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//UOM
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If Not isNull(lsTemp) Then
					ldsDODetail.SetItem(llNewRow,'UOM',Trim(lsTemp))
				End If
			Else
				lsTEmp = trim(lsRecData)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Customer PO - UF3
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			
			ldsDODetail.SetItem(llNewRow,'User_Field3',Trim(lsTemp))
			
				
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			
	Case	"DN" /*Delivery NOtes*/
		
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			
			
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If

			lsOrder = lsTemp
			
			//Make sure we have a header for this Detail...
			If ldsDOHeader.Find("Upper(invoice_no) = '" + Upper(lsOrder) + "'",1,ldsDOHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Order Number does not match header ORder Number. Note Record will not be processed (Delivery Order will still be loaded)..")
				Continue
			End If
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Line Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If

			If isNumber(lsTemp) Then
				llNoteLine = Long(lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Delivery Notes 'Line Item' is not numeric: '" + lsTemp + "'. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If
					
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Note Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Note Type' field. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			
			
			//Note Sequence
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Note Seq Number' field. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If

			If isNumber(lsTemp) Then
				llNoteSeq = Long(lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Delivery Notes Seq Number' is not numeric: '" + lsTemp + "'. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Note Text
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			
			//Each Note row may get broken into multiple rows if we encounter a ~
			lsNoteText = lsTemp
			
			If lsNoteText > "" Then 
			
				llNewNotesRow = ldsDONotes.InsertRow(0)
				ldsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
				ldsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
				ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',llNoteSeq) /*Using our own sequential number so we can start a new row when we hit a ~ */
				ldsDONotes.SetItem(llNewNotesRow,'invoice_no',lsOrder)
				ldsDONotes.SetItem(llNewNotesRow,'note_type',lsNoteType)
				ldsDONotes.SetItem(llNewNotesRow,'line_item_no',llNoteLine)
				ldsDONotes.SetItem(llNewNotesRow,'note_Text',lsNoteText)
				
			End If
			
	Case Else /*Invalid rec type */
			
			If llRowPos < llRowCount Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed (Delivery Order will still be loaded).")
				lbError = True
			End If
			
//			Return -1
			
	End Choose /*Header or Detail */
	
Next


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

public function integer uf_process_itemmaster (string aspath, string asproject);
//Process Item Master (IM) Transaction for FUNAI (12/12 - PCONKL - Cloned from Philips-sg)


String	lsData, lsTemp, lsLogOut, lsStringData, lsSKU, 	lsCOO, lsSupplier
			
Integer	liRC,	liFileNo
			
Long		llCount,	llPos, llOwner, llNew, llExist, llNewRow, llFileRowCount, llFileRowPos 

Decimal ldtemp
DateTime	ldtToday, ldtLastUpdate
Boolean	lbNew, lbError, lbUpdateDIMS

//LAst Update  is GMT + 8 (SIN time)
ldtToday = DateTIme(Today(),Now())
select Max(dateAdd( hour, 8,:ldtToday )) into :ldtLAStUpdate
from sysobjects;

u_ds_datastore	ldsItem 
datastore	lu_DS

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master_w_supp_cd' /* retrieving by SKU and Supplier - Not updating across suppliers*/
ldsItem.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master File for FUNAI Processing: " + asPath
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
	
	lbUpdateDIMS = True
	
	// Any field with a "/" means to not update 
	
	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	
	
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))

	//Ignore EOF
	If lsData = "EOF" Then COntinue
	
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
		
	Else /*error*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
		lbError = True
		Continue
		
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Supplier
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsSupplier = lsTemp
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
		lbError = True
		Continue
	End If

	//Validate Supplier
	If lsSupplier > "" Then
		
		Select Count(*) into :llCount
		From Supplier 
		Where Project_id = :asProject and Supp_code = :lsSupplier;
		
		If llCount < 1 Then
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Supplier (Plant Code): '" + lsSupplier + "'. Record will not be processed.")
			lbError = True
			Continue
		
		End If
		
	Else
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier not present. Record will not be processed.")
		lbError = True
		Continue
		
	End If

	// 08/09 - PCONKL - For SG00 and SG03, we dont want to update the DIMS and Weight on an Update
	If lsSupplier = 'SG00' or lsSupplier = 'SG03' Then lbUpdateDIMS = False
		
	//Retrieve for SKU and Supplier - Not updating across suppliers
	llCount = ldsItem.Retrieve(asProject, lsSKU,lsSupplier)

	llCount = ldsItem.RowCount()
	
	If llCount <= 0 Then /* Insert a new record*/
					
		llNew ++ /*add to new count*/
		lbNew = True
		llNewRow = ldsItem.InsertRow(0)
		ldsItem.SetItem(1,'project_id',asProject)
		ldsItem.SetItem(1,'SKU',lsSKU)
		ldsItem.SetItem(1,'supp_code',lsSupplier)
		
		//Get Default owner for Supplier
		Select owner_id into :llOwner
		From Owner
		Where project_id = :asProject and Owner_type = 'S' and owner_cd = :lsSupplier;
			
		ldsItem.SetItem(1,'owner_id',llOwner)
							
	Else /*exists*/
				
		llexist += llCount /*add to existing Count*/
		lbNew = False
	
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
		
	//Description
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		lsTemp = lsData
	End If
	
	If lsTemp > '' and lsTemp <> "/" Then /* "/" means don't update*/
		
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Description',left(lsTemp,70))
		Next
		
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	// UOM 1 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If  lsTemp <> "/" Then /* "/" means don't update*/
	
		For llPos = 1 to ldsItem.RowCount()
			If lsTEmp > '' Then
				ldsItem.SetItem(llPos,'uom_1',left(lsTemp,4))
			Else 
				ldsItem.SetItem(llPos,'uom_1','EA') //Default EA
			End If
		Next
		
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Weight maps to Weight 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp)) and (lbNew or lbUpdateDims) Then /*only map if numeric*/
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'weight_1',Dec(Trim(lsTemp)))
		Next
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	
	

	//Length maps to Length 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp)) and (lbNew or lbUpdateDims) Then /*only map if numeric*/
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Length_1',Dec(trim(lsTemp)))
		Next
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	

	//Width maps to Width 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp)) and (lbNew or lbUpdateDims)  Then /*only map if numeric*/
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Width_1',Dec(Trim(lsTemp)))
		next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Height maps to Height 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp)) and (lbNew or lbUpdateDims) Then /*only map if numeric*/
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Height_1',Dec(Trim(lsTemp)))
		next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Standard Cost
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp))   Then /*only map if numeric*/
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Std_Cost',dec(trim(lsTemp)))
		next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Cycle Count Frequency in Days
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(trim(lsTEmp))  Then /*only map if numeric*/
		ldTemp = Dec(Trim(lsTemp) )
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'cc_freq',Trim(lsTemp))
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
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Part_UPC_Code',ldTemp)
		Next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	

	//Freight Class 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' and lsTemp <> "/" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Freight_Class',left(lsTemp,10))
		Next
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Storage Code 
	If Pos(lsData,'|') > 0 and lsTemp <> "/" Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Storage_Code',left(lsTemp,10))
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	

	//Inventory Class 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' and lsTemp <> "/" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Inventory_Class',left(lsTemp,10))
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Alternate SKU 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' and lsTemp <> "/" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Alternate_SKU',left(lsTemp,50))
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	

	//Default COO 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTemp <> "/" Then
		
		For llPos = 1 to ldsItem.RowCount()
			If lsTEmp > '' Then
				ldsItem.SetItem(llPos,'Country_Of_Origin_Default',left(lsTemp,3))
			Else
				ldsItem.SetItem(llPos,'Country_Of_Origin_Default','XXX')
			End If
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
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Shelf_Life',ldTemp)
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
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'item_delete_ind',lsTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//CC GROUP
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > ''  and lsTemp <> "/" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'cc_group_code',lsTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Product heirchy ->UF10 (moved from UF1 to UF10 on 5/5/09 - PC)
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > ''  and lsTemp <> "/" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'user_field10',lsTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	
	// 12NC -> UF7
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
		
	If lsTEmp > ''  and lsTemp <> "/" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'user_field7',lsTemp)
		Next
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

		
	//EAN -> UF6
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > ''  and lsTemp <> "/" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'user_field6',lsTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Conversion Factor (UF9)
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > ''  and lsTemp <> "/" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'user_field9',lsTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Volume -> UF8
	If Pos(lsData,'|') > 0   Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' and (lbNew or lbUpdateDims) Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'user_field8',lsTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	
	//Product Division (UF4)
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > ''  and lsTemp <> "/" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'user_field4',lsTemp)
		Next
	End If
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Hazard Class 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
		
	If lsTEmp > ''  and lsTemp <> "/" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'hazard_class',lsTemp)
		Next
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Hazard Cd 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
		
	If lsTEmp > ''  and lsTemp <> "/" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'hazard_cd',lsTemp)
		Next
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Lot Controlled Ind - Add processing of this column cawikholm - 05/24/11
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
		
	If lsTEmp > ''  and lsTemp <> "/" Then
		// Only valid values are 'Y' or 'N' If anything but 'Y' is passed, set to 'N' cawikholm 05/24/11
		IF lsTemp <> 'Y' THEN
			lsTemp = 'N'
		END IF
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'lot_controlled_ind',lsTemp)
		Next
	ELSEIF lbNew THEN
		ldsItem.SetItem(1,'lot_controlled_ind','N')	// Default new record to 'N' if not passed 05/24/11
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter		

	//Update any record defaults
	For llPos = 1 to ldsItem.RowCount()
		ldsItem.SetItem(llPos,'Last_user','SIMSFP')
		ldsItem.SetItem(llPos,'last_update',ldtLAStUpdate)
	Next
		
	//If record is new...
	If lbNew Then
//		ldsItem.SetItem(1,'lot_controlled_ind','N')   No longer default to 'N' - cawikholm 05/24/11
		ldsItem.SetItem(1,'po_controlled_ind','Y') 
		ldsItem.SetItem(1,'po_no2_controlled_ind','Y') 
		ldsItem.SetItem(1,'container_tracking_ind','N') 
		ldsItem.SetItem(1,'standard_of_Measure','M') /*default to metric*/
	End If
			
	//Save NEw Item to DB
	lirc = ldsItem.Update()
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

protected function integer uf_process_po (string aspath, string asproject);//Process PO for Philips Singapore

Datastore	lu_ds

String	lsLogout,lsStringData, lsOrder, lsWarehouse, lsTemp, lsRecData, lsRecType
Integer	liRC,liFileNo
Long		llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llOWner
Boolean	lbError, lbDetailError
DateTime	ldtToday, ldtOrderDate
Decimal	ldWeight, ldLineItemNo
String 	lsOrderNo, lsInvType

ldtToday = DateTime(Today(),Now())


//Order Date is GMT + 8 (SIN time)
select Max(dateAdd( hour, 8,:ldtToday )) into :ldtOrderDate
from sysobjects;


lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'


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
lsLogOut = '      - Opening File for FUNAI Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for FUNAI Processing: " + asPath
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
//Select wh_code into :lsWarehouse
//From Project
//Where Project_id = :asProject;

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
			//idsPOheader.SetItem(llNewRow, 'wh_code',lsWarehouse) 
			idsPOheader.SetItem(llNewRow, 'Request_date',String(Today(),'YYMMDD'))
			idsPOheader.SetItem(llNewRow, 'ord_date',String(ldtOrderDate,'yyyy/mm/dd hh:mm'))
			idsPOheader.SetItem(llNewRow, 'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPOheader.SetItem(llNewRow, 'order_seq_no',llOrderSeq) 
			idsPOheader.SetItem(llNewRow, 'ftp_file_name',asPath) /*FTP File Name*/
			idsPOheader.SetItem(llNewRow, 'Status_cd','N')
			idsPOheader.SetItem(llNewRow, 'Last_user','SIMSEDI')
			idsPOheader.SetItem(llNewRow, 'Order_type', 'S') /*Order Type = Supplier */
			idsPOheader.SetItem(llNewRow, 'Inventory_Type','N') /*default to Normal*/
			idsPOheader.SetItem(llNewRow, 'action_cd','A') /* defaulting to add so we'll reject any updates or reloading of files - per CP, Updates should be handled manually*/
					
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
		
			//Action Code - 			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Action Code' field. Record will not be processed.")
			End If
						
		//	idsPOheader.SetItem(llNewRow, 'action_cd', lsTemp) /* defaulting to add above */
		
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
		

			//Supplier Code (Plant Code)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
			End If
		
			idsPOheader.SetItem(llNewRow,'supp_code',lsTemp)
					
			// Warehouse is being set based on the Plant Code - hardcoded for now
			If  upper(Trim(lsTemp)) = "2180" OR upper(Trim(lsTemp)) = "MY10"   Then  /*Malaysia*/
				idsPOheader.SetItem(llNewRow, 'wh_code',"FUNAI-MY") 
			Else /*Singapoore */
				idsPOheader.SetItem(llNewRow, 'wh_code',"FUNAI-SG") 
			End If
			
			//Get the default owner for this Supplier
			llOwner = 0
			
			Select Owner_id into :llOwner
			From Owner
			Where project_id = :asProject and owner_type = 'S' and owner_cd = :lsTemp;
			
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			//Expected Arrival Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Arrival Date' field. Record will not be processed.")
			End If
					
			idsPOheader.SetItem(llNewRow,'Arrival_Date',Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))
			
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			//Warehouse - Ignored - Defaulted above
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
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
		
					
			//Vendor Number -> UF5
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'User_Field5',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Vendor name -> UF7
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'User_Field7',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				
			//Vendor Invoice Number -> UF9 - also to SHIP_Ref (rcv slip Nbr) 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
										
			idsPOheader.SetItem(llNewRow,'User_Field9',lsTemp)
			idsPOheader.SetItem(llNewRow,'ship_ref',lsTemp)

			// Ship ref will now be passed in DM record.  Does it need to be updated here?
//			//cawikholm - 06/14/11Ship Ref will now be passed
//			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//				
//			If Pos(lsRecData,'|') > 0 Then
//				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//			Else 
//				lsTemp = lsRecData
//			End If
//						
//			idsPOheader.SetItem(llNewRow,'ship_ref',lsTemp)
					
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
			
			//Default Owner if present
			If llOwner > 0 Then
				idsPODetail.SetItem(llNewDetailRow,"owner_id",string(llOwner))
			End If
		
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
			lsOrderNo = trim(lsTemp)

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
				idsPODetail.SetItem(llNewDetailRow,'User_field1',Trim(lsTemp)) /*Also mapping to UF 1 for sending back to SAP */
			End If
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			
			//SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Upper(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'SKU',lsTemp)
		
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Qty
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
		
			idsPODetail.SetItem(llNewDetailRow,'quantity',Trim(lsTemp)) /*checked for numerics in nvo_process_files.uf_process_purcahse_Order*/

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
						
			//UOM
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'uom',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
				
			//Inventory Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			//Convert Their Storage Location to Our Inv Type
			lsInvType = getMenloInvType(lsTemp)
			
			If lsInvType > '' Then /*override default if present*/	
				idsPODetail.SetItem(llNewDetailRow,'Inventory_Type',lsInvType)
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
			
			//lot No 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow, 'Lot_no', trim(lsTemp))
								
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO - FUNAI PO Nummber
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'PO_NO',lsTemp)
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO 2  - FUNAI PO Line
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
			
		
			
					
			//If detail errors, delete the row...
			if lbDetailError Then
				lbError = True
				idsPoDetail.DeleteRow(llNewDetailRow)
				Continue
			End If
				
			
			
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

public function integer uf_process_return_order (string aspath, string asproject);//Process Return Order for Philips Singapore

Datastore	lu_ds

String	lsLogout,lsStringData, lsOrder, lsWarehouse, lsTemp, lsRecData, lsRecType, lsCustCode, lsCustName, lsCustAddr1, lsCustAddr2, lsCustAddr3, lsCustAddr4, lsCustCity, lsCustState, lsCustZip, lsCustCountry, lsCustDistrict, lsNoteText, lsNoteType
Integer	liRC,liFileNo
Long		llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llNewAddressRow, llNewNotesRow, llNoteLine, llNoteSeq,llOwner
Boolean	lbError, lbDetailError
DateTime	ldtToday, ldtOrderDate
Decimal	ldWeight, ldLineItemNo
String 	lsOrderNo

ldtToday = DateTime(Today(),Now())

//Order Date is GMT + 8 (SIN time)
select Max(dateAdd( hour, 8,:ldtToday )) into :ldtOrderDate
from sysobjects;

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'


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

If Not isvalid(idsROAddress) Then
	idsROAddress = Create u_ds_datastore
	idsROAddress.dataobject = 'd_mercator_ro_address'
	idsROAddress.SetTransObject(SQLCA)
End If

If Not isvalid(idsRONotes) Then
	idsRONotes = Create u_ds_datastore
	idsRONotes.dataobject = 'd_mercator_ro_notes'
	idsRONotes.SetTransObject(SQLCA)
End If

idsPoheader.Reset()
idsPODetail.Reset()
idsRONotes.Reset()
idsROAddress.Reset()


//Open and read the File In
lsLogOut = '      - Opening File for FUNAI Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for FUNAI Processing: " + asPath
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
//Select wh_code into :lsWarehouse
//From Project
//Where Project_id = :asProject;

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
			
		Case 'RM' /*Return Header*/
			
			llNewRow = 	idsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			idsPOheader.SetItem(llNewRow, 'project_id',asProject)
		//	idsPOheader.SetItem(llNewRow, 'wh_code',lsWarehouse)
			idsPOheader.SetItem(llNewRow, 'Request_date',String(Today(),'YYMMDD'))
			idsPOheader.SetItem(llNewRow, 'ord_date',String(ldtOrderDate,'yyyy/mm/dd hh:mm'))
			idsPOheader.SetItem(llNewRow, 'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPOheader.SetItem(llNewRow, 'order_seq_no',llOrderSeq) 
			idsPOheader.SetItem(llNewRow, 'ftp_file_name',asPath) /*FTP File Name*/
			idsPOheader.SetItem(llNewRow, 'Status_cd','N')
			idsPOheader.SetItem(llNewRow, 'Last_user','SIMSEDI')
			idsPOheader.SetItem(llNewRow, 'Order_type', 'X') /*Order Type = Return from Customer */
			idsPOheader.SetItem(llNewRow, 'Inventory_Type','N') /*default to Normal*/
			idsPOheader.SetItem(llNewRow, 'action_cd', 'A') 
					
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
		
												
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsOrderNo = trim(lsTemp)
			idsPOheader.SetItem(llNewRow,'order_no',Trim(lsTemp))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		

			//Expected Arrival Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Arrival Date' field. Record will not be processed.")
			End If
					
			idsPOheader.SetItem(llNewRow,'Arrival_Date',Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Build the Returning Customer Info into Receive_Alt_Address
			
			//Customer Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsCustCode = trim(lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Customer Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsCustName = trim(lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Cust PO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsOrderNo = trim(lsTemp)
			idsPOheader.SetItem(llNewRow,'supp_order_no',Trim(lsTemp))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Customer Addr1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsCustAddr1 = trim(lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Customer Addr2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsCustAddr2 = trim(lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Customer Addr3
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsCustAddr3 = trim(lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Customer Addr4
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsCustAddr4 = trim(lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Customer District
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsCustDistrict = trim(lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Customer Zip
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsCustZip = trim(lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Customer City
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsCustCity = trim(lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Customer State
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsCustState = trim(lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Customer Country
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsCustCountry = trim(lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
						
			//Supplier Code (Plant Code)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
		
			idsPOheader.SetItem(llNewRow,'supp_code',lsTemp)
			
			// Warehouse is being set based on the Plant Code - hardcoded for now
			If  upper(Trim(lsTemp)) = "2180"  OR upper(Trim(lsTemp)) = "MY10"  Then /*Malaysia*/
				idsPOheader.SetItem(llNewRow, 'wh_code',"FUNAI-MY") 
			Else /*Singapoore */
				idsPOheader.SetItem(llNewRow, 'wh_code',"FUNAI-SG") 
			End If
			
						
			//Get the default owner for this Supplier
			llOwner = 0
			
			Select Owner_id into :llOwner
			From Owner
			Where project_id = :asProject and owner_type = 'S' and owner_cd = :lsTemp;
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Build the Receive_alt_Address record...
			llNewAddressRow = idsROAddress.InsertRow(0)
			idsROAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
			idsROAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsROAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
			idsROAddress.SetItem(llNewAddressRow,'address_type','RC') /* Return Customer*/
			idsROAddress.SetItem(llNewAddressRow,'Name',lsCustCode + "-" + lsCustName)
			idsROAddress.SetItem(llNewAddressRow,'address_1',lsCustAddr1)
			idsROAddress.SetItem(llNewAddressRow,'address_2',lsCustAddr2)
			idsROAddress.SetItem(llNewAddressRow,'address_3',lsCustAddr3)
			idsROAddress.SetItem(llNewAddressRow,'address_4',lsCustAddr4)
			idsROAddress.SetItem(llNewAddressRow,'City',lsCustCity)
			idsROAddress.SetItem(llNewAddressRow,'district',lsCustDistrict)
			idsROAddress.SetItem(llNewAddressRow,'State',lsCustState)
			idsROAddress.SetItem(llNewAddressRow,'Zip',lsCustZip)
			idsROAddress.SetItem(llNewAddressRow,'Country',lsCustCountry)
				
			
			
		CASE 'RD' /* detail*/
			
			lbDetailError = False
			llNewDetailRow = 	idsPODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			idsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'Action_cd', 'U')
			idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
		
			//Default Owner if present
			If llOwner > 0 Then
				idsPODetail.SetItem(llNewDetailRow,"owner_id",string(llOwner))
			End If
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
						
		
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
			lsOrderNo = trim(lsTemp)

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
				idsPODetail.SetItem(llNewDetailRow,'User_field1',Trim(lsTemp)) /*Also mapping to UF 1 for sending back to SAP */
			End If
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			
			//SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Upper(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'SKU',lsTemp)
		
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Supplier Code (Plant Code)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Upper(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Supplier (Plant Code) ' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'supp_code',lsTemp)
		
			
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
				idsPODetail.SetItem(llNewDetailRow,'Inventory_Type',getMenloInvType(lsTemp)) /* convert to Menlo Type*/
			End If
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//UOM
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'uom',lsTemp)
	
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Customer PO (UF3)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			//Mapping Cust PO to Detail and PO_NO and PO_NO2 on Putaway
			idsPODetail.SetItem(llNewDetailRow,'User_Field3',lsTemp)
			idsPODetail.SetItem(llNewDetailRow,'PO_NO',lsTemp)
			idsPODetail.SetItem(llNewDetailRow,'PO_NO2',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
								
			//If detail errors, delete the row...
			if lbDetailError Then
				lbError = True
				idsPoDetail.DeleteRow(llNewDetailRow)
				Continue
			End If
				
			
		Case	"RN" /*Return NOtes*/
		

			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			
			
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If

			lsOrder = lsTemp
			
			//Make sure we have a header for this Detail...
			If idsPOHeader.Find("Upper(order_no) = '" + Upper(lsOrder) + "'",1,idsPOHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Order Number does not match header ORder Number. Note Record will not be processed (Return Order will still be loaded)..")
				Continue
			End If
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Line Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Return Order Number' field. Note Record will not be processed (Return Order will still be loaded)..")
				lbError = True
				Continue
			End If

			If isNumber(lsTemp) Then
				llNoteLine = Long(lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Return Notes 'Line Item' is not numeric: '" + lsTemp + "'. Note Record will not be processed (Return Order will still be loaded)..")
				lbError = True
				Continue
			End If
					
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Note Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Return Note Type' field. Note Record will not be processed (Return Order will still be loaded)..")
				lbError = True
				Continue
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			
			
			//Note Sequence
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Note Seq Number' field. Note Record will not be processed (Return Order will still be loaded)..")
				lbError = True
				Continue
			End If

			If isNumber(lsTemp) Then
				llNoteSeq = Long(lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Return Notes Seq Number' is not numeric: '" + lsTemp + "'. Note Record will not be processed (Return Order will still be loaded)..")
				lbError = True
				Continue
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Note Text
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
		
			lsNoteText = lsTemp
			
			If lsNoteText > "" Then 
			
				llNewNotesRow = idsRONotes.InsertRow(0)
				idsRoNotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
				idsRoNotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				idsRoNotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
				idsRoNotes.SetItem(llNewNotesRow,'note_seq_no',llNoteSeq) /*Using our own sequential number so we can start a new row when we hit a ~ */
				idsRoNotes.SetItem(llNewNotesRow,'invoice_no',lsOrder)
				idsRoNotes.SetItem(llNewNotesRow,'note_type',lsNoteType)
				idsRoNotes.SetItem(llNewNotesRow,'line_item_no',llNoteLine)
				idsRoNotes.SetItem(llNewNotesRow,'note_Text',lsNoteText)
				
			End If
			
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

If liRC = 1 Then
	liRC = idsROAddress.Update()
End If

If liRC = 1 Then
	liRC = idsRONotes.Update()
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

public function string getphilipsinvtype (string asinvtype);
//Convert the Menlo Onventory Type into the Phillips code

String	lsPhilipsInvType
Choose case upper(asInvType)

	Case 'B'
		lsPhilipsInvType = 'B'
	Case 'C'
		lsPhilipsInvType = 'C'
	Case 'D' 
		lsPhilipsInvType = 'DAM'
	Case  'K'
		lsPhilipsInvType = 'BLCK'
	Case  'L' 
		lsPhilipsInvType = 'REBL'
	Case 'N'
		lsPhilipsInvType = 'WHS'
	Case 'R' 
		lsPhilipsInvType = 'REW'
	Case 'S'
		lsPhilipsInvType = 'SCRP'		
		
		
//	Case 'B'
//		lsPhilipsInvType = '3BST'
//	Case 'C'
//		lsPhilipsInvType = '3CST'
//	Case 'D'
//		lsPhilipsInvType = '3DAM'
//	Case 'K'
//		lsPhilipsInvType = '3BLC'
//	Case 'L'
//		lsPhilipsInvType = '3REB'
//	Case 'N'
//		lsPhilipsInvType = '7WHS'
//	Case 'R'
//		lsPhilipsInvType = '3REW'
//	Case 'S'
//		lsPhilipsInvType = '3SCR'
	//Case 'G'
		//lsPhilipsInvType = 'BWHS'
	//Case 'J'
	//	lsPhilipsInvType = 'BOPN'
	//Case 'F'
	//	lsPhilipsInvType = 'BBLK'
	//Case 'E'
	//	lsPhilipsInvType = 'BDAM'
	Case Else
		lsPhilipsInvType = asInvType
End Choose

Return lsPhilipsInvType


end function

public function integer uf_process_dboh ();Integer	liRC, liFileNo
Long	llRowCount, llRowPos, llNewRow,  llQty
String	lsOutString,  lsLogOut,  lsFIleName, lsSupplierSave, lsSupplier
string ERRORS, sql_syntax
string	lsBondedWhsInvTypes
Decimal	ldBatchSeq
Datastore	 ldsInv, ldsOut
DateTime	ldtToday, ldtNow

//Convert GMT to SIN Time
ldtNow = DateTime(today(),Now())
select Max(dateAdd( hour, 8,:ldtNow )) into :ldtToday
from sysobjects;

// cawikholm 06/20/11 - List of bonded warehouses for Philips-SG 
// Formated for sql where clause - Add inventory Type here if new bonded inventory type is added
lsBondedWhsInvTypes = "('BWHS','BOPN','BBLK','BDAM')" 

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: FUNAI Daily Inventory Snapshot File... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Create datastore
ldsInv = Create Datastore

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

// We want each PLant (Supp_code) in a seperate file - Group by Supplier and create a new file when it changes
//Create the Datastore...
//cawikholm - 06/20/11 Added check for Bonded Warehouse Inventory Type
//cawikholm - 07/07/11 Removed code for bonded warehouse - Do not implement this code yet
sql_syntax = "SELECT WH_Code, SKU,Supp_code,  inventory_type,   Sum( Avail_Qty  ) + Sum( alloc_Qty  )  as 'total_qty'   " 
sql_syntax += "from Content_Summary"
sql_syntax += " Where Project_ID = 'FUNAI'"
//sql_syntax += " And inventory_type NOT IN " + lsBondedWhsInvTypes
sql_syntax += " Group by Wh_Code, SKU,Supp_code, Inventory_Type "
sql_syntax += " Having Sum( Avail_Qty  ) + Sum( alloc_Qty  )   > 0 "
sql_syntax += " Order by wh_code, Supp_code, SKU;  "

ldsInv.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for FUNAI Inventory Snapshot ID data.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

lirc = ldsInv.SetTransobject(sqlca)

//Retrieve the Inv Data
lsLogout = 'Retrieving Inventory Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsInv.Retrieve()


lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//cawikholm - 07/07/11 Removed code for bonded warehouse - Do not implement this code yet
//If llRowCount < 1 Then 
//	// cawikholm - 06/20/11 Still might have Bonded Warehouse Records to process, call function and check
//	// send bonded warehouse inventory type list so we only need to hard code in one spot.
//	uf_process_dboh_bonded( lsBondedWhsInvTypes )
//	Return 0
//End If



For llRowPos = 1 to llRowCOunt
	
	lsSUpplier = ldsInv.GetItemString(llRowPos,'supp_code')
	
	If lsSupplier <> lsSupplierSave Then
		
		//Write Previous supplier if any data
		If ldsOut.RowCount() > 0 Then
			gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'FUNAI')
			ldsOut.Reset()
		End If
		
		//Next File Sequence #...
		ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no("FUNAI",'EDI_Generic_Outbound','EDI_Batch_Seq_No')
		If ldBatchSeq <= 0 Then
			lsLogOut = "        *** Unable to retrieve the next available sequence number for FUNAI BOH file. Confirmation will not be sent'"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If
	
	End If /* Supplier Chnaged*/
	
	
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'BH|' /*rec type = balance on Hand Confirmation*/
	lsOutString += String(ldtToday,'YYYYMMDDHHMM') + "|"
	lsOutString += ldsInv.GetItemString(llRowPos,'sku') + '|'
	lsOutString += string(ldsInv.GetItemNumber(llRowPos,'total_qty'),'############0')  + '|'
	lsOutString += ldsInv.GetItemString(llRowPos,'supp_code') + '|'
	lsOutString += getPhilipsInvType(ldsInv.GetItemString(llRowPos,'inventory_type')) /*Convert to Philips Inv Type */
	
	ldsOut.SetItem(llNewRow,'Project_id', 'FUNAI')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', 'BH' + String(ldbatchSeq,'000000') + ".DAT")
	
	lsSupplierSave = lsSupplier
	
Next /*next output record */

//Write last/Only
If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'FUNAI')
End If

//cawikholm - 07/07/11 Removed code for bonded warehouse - Do not implement this code yet
//uf_process_dboh_bonded( lsBondedWhsInvTypes )

end function

public function string getmenloinvtype (string asinvtype);//Convert the Philips Inventory Type into the Menlo code

String	lsMenloInvType
Choose case upper(asInvType)
		
	Case 'B'
		lsMenloInvType = 'B'
	Case 'C'
		lsMenloInvType = 'C'
	Case 'DAM'
		lsMenloInvType = 'D'
	Case 'BLCK'
		lsMenloInvType = 'K'
	Case 'REBL'
		lsMenloInvType = 'L'
	Case 'WHS'
		lsMenloInvType = 'N'
	Case 'REW'
		lsMenloInvType = 'R'
	Case 'SCRP'
		lsMenloInvType = 'S'
	
	Case Else
		lsMenloInvType = asInvType
End Choose

Return lsMenloInvType
end function

public function string nonull (string as_str);as_str = trim(as_str)
if isnull(as_str) or as_str = '-' then
	return ""
else
	return as_str
end if

end function

public function integer uf_process_dboh_volume ();//Process the Daily Balance on Hand Report

String			sql_syntax, ERRORS, lsLogOut, lsOutString, lsFileName, lsWarehouseSave
Long			llRowPos, llRowCount, llNewRow
Int				liRC
Datastore	ldsBOH, ldsOut
Date			ldToday

ldToday = Today()

lsLogOut = "      Creating FUNAI Daily Balance on Hand-Volume File... " 
FileWrite(gilogFileNo,lsLogOut)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

ldsboh = Create Datastore
//Jxlim 12/21/2010 Added Item_Master.Description and Content_Summary.Serial_no
//JXLIM 07/01/2010 Added 3 fields (ItemMaster.UserField8, Volume and ItemMaster.Group)
sql_syntax = "select complete_Date, Arrival_date, Supp_Invoice_No,  Content_Summary.wh_code, Content_Summary.sku, Content_Summary.supp_code, Content_Summary.l_Code, Content_Summary.Lot_No,  Content_Summary.Po_No, "
sql_syntax +=	" Content_Summary.po_no2, Content_Summary.serial_no, Content_Summary.Expiration_Date,  Content_Summary.Inventory_Type,  " 
sql_syntax += " Sum(Content_Summary.Avail_Qty) as avail_qty , Sum(Content_Summary.alloc_Qty) as Alloc_Qty,  "
sql_syntax += "Item_Master.Length_1, Item_Master.Width_1, Item_Master.Height_1, Item_MAster.Weight_1, "
sql_syntax += "Item_Master.User_Field8, "
sql_syntax +=  "CASE WHEN (Sum(Content_Summary.Avail_qty) * Item_Master.User_field8) / 1000  > 0 AND Item_Master.User_field8 NOT LIKE '%[A-Z%]'  THEN  (Sum(Content_Summary.Avail_qty) * Item_Master.User_field8) / 1000 ELSE NULL END As Volume,  "
sql_syntax += "Item_Master.Grp, Item_Master.Description"
sql_syntax += "  From Receive_Master, Content_Summary, Item_Master "
sql_syntax += "  Where Content_Summary.Project_id = 'FUNAI'  and "
sql_syntax += " Content_Summary.Project_id = Receive_MAster.Project_ID and Content_Summary.ro_no = Receive_Master.ro_no "
sql_syntax += " and Content_Summary.project_id = Item_MAster.Project_id and Content_Summary.SKU = Item_Master.SKU and Content_Summary.supp_code = Item_MAster.Supp_code "
sql_syntax += " Group By  complete_Date, Arrival_date, Supp_Invoice_No,  Content_Summary.wh_code, Content_Summary.sku, Content_Summary.supp_code, Content_Summary.l_Code, Content_Summary.Lot_No,  Content_Summary.Po_No, "
sql_syntax +=	" Content_Summary.po_no2, Content_Summary.Serial_no, Content_Summary.Expiration_Date,  Content_Summary.Inventory_Type,  Item_Master.Length_1, Item_Master.Width_1, Item_Master.Height_1, Item_MAster.Weight_1, Item_Master.User_Field8, Grp, Description" 
sql_syntax += " Having Sum( Content_Summary.Avail_Qty  ) > 0 or  Sum( Content_Summary.alloc_Qty  ) > 0 "
sql_syntax += " Order by Content_Summary.wh_Code "

ldsboh.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
 	 lsLogOut = "        *** Unable to create datastore for FUNAI  (BOH-Volume Data).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
 	 RETURN - 1
END IF

lirc = ldsboh.SetTransobject(sqlca)

lLRowCount = ldsBoh.Retrieve()


lsLogOut = "    - " + String(ldsboh) + " inventory records retrieved for  processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

For llRowPos = 1 to lLRowCount /*Each Inv Record*/
	
	//If warehouse changed, write a seperate file for each
	If ldsBoh.GetITemString(llRowPos,'wh_code') <> lsWarehouseSave Then
		
		//Write the previous file (if not the first time through)
		If ldsOut.RowCount() > 0 Then
			gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'FUNAI')
			ldsOut.Reset()
		End If

		lsFileName = "FUNAI-Daily-BOH-Volume-" + ldsBoh.GetITemString(llRowPos,'wh_code')  + "-" + + String(ldToday,"mm-dd-yyyy") + ".csv"
		
		//Add a column Header Row*/
		llNewRow = ldsOut.insertRow(0)
		//Jxlim 12/21/2010 Added Item_Master.Description and Content_Summary.Serial_no
		//JXLIM 07/01/2010 Added 3 labels (ItemMaster.UserField8, Volume and ItemMaster.Group)
		lsOutString = "WH Code,SKU,Description,Supplier Code,Date Received,Arrival Date,Order Nbr,Location,Inventory Type,Avail Qty,Alloc Qty,Length1,Width1,Height1,Weight1, User_Field8,Volume,Item Group"
		ldsOut.SetItem(llNewRow,'Project_id', 'FUNAI')
		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
		ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
		ldsOut.SetItem(llNewRow,'file_name', lsFileName)
		ldsOut.SetItem(llNewRow,'dest_cd', 'BOH') /* routed to different folder for processing */

				
	End If  /*Warehouse changed */
		
	llNewRow = ldsOut.insertRow(0)
	
	lsOutString = ldsBoh.GetITemString(llRowPos,'wh_code') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'sku') + ","
	//Jxlim 12/21/2010 Added Description field and seria_no
	lsOutString += ldsBoh.GetITemString(llRowPos,'Description') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'supp_code') + ","
	lsOutString += String(ldsBoh.GetITemDateTime(llRowPos,'complete_date'),'yyyy-mm-dd') + ","
	lsOutString += String(ldsBoh.GetITemDateTime(llRowPos,'arrival_date'),'yyyy-mm-dd') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'supp_invoice_no') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'l_code') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'Inventory_Type') + ","
	lsOutString += nonull(String(ldsBoh.GetITemNumber(llRowPos,'avail_qty'))) + ","
	lsOutString += nonull(String(ldsBoh.GetITemNumber(llRowPos,'alloc_qty'))) + ","
	lsOutString += nonull(String(ldsBoh.GetITemNumber(llRowPos,'length_1'))) + ","
	lsOutString += nonull(String(ldsBoh.GetITemNumber(llRowPos,'width_1')))  + ","
	lsOutString += nonull(String(ldsBoh.GetITemNumber(llRowPos,'Height_1'))) + ","
	lsOutString += nonull(String(ldsBoh.GetITemNumber(llRowPos,'weight_1'))) + ","
	//JXLIM 07/01/2010 Added 3 fields (ItemMaster.UserField8, Volume and ItemMaster.Group)
	lsOutString += nonull(ldsBoh.GetITemString(llRowPos,'User_Field8')) + ","
	lsOutString +=  nonull(String(ldsBoh.GetITemNumber(llRowPos,'Volume'))) + ","
	lsOutString += nonull(ldsBoh.GetITemString(llRowPos,'Grp'))
	

	
	
	ldsOut.SetItem(llNewRow,'Project_id', 'FUNAI')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)
	ldsOut.SetItem(llNewRow,'dest_cd', 'BOH') /* routed to different folder for processing */

		
	lsWarehouseSave = ldsBoh.GetITemString(llRowPos,'wh_code')
	
Next /*Inventory Record*/

//Last/Only warehouse
If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'FUNAI')
End If
		

REturn 0
end function

public function integer uf_process_dboh_bonded (string asbondedwhsinvtypes);// This function is a copy of uf_process_dboh except for the sql_syntax and the record type of BW

Integer	liRC, liFileNo
Long	llRowCount, llRowPos, llNewRow,  llQty
String	lsOutString,  lsLogOut,  lsFIleName, lsSupplierSave, lsSupplier
string ERRORS, sql_syntax
Decimal	ldBatchSeq
Datastore	 ldsInv, ldsOut
DateTime	ldtToday, ldtNow

//Convert GMT to SIN Time
ldtNow = DateTime(today(),Now())
select Max(dateAdd( hour, 8,:ldtNow )) into :ldtToday
from sysobjects;

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: FUNAI Daily Inventory Snapshot File... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Create datastore
ldsInv = Create Datastore

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

// We want each PLant (Supp_code) in a seperate file - Group by Supplier and create a new file when it changes
//Create the Datastore...
//cawikholm - 06/20/11 Added check for Bonded Warehouse Inventory Type
sql_syntax = "SELECT WH_Code, SKU,Supp_code,  inventory_type,   Sum( Avail_Qty  ) + Sum( alloc_Qty  )  as 'total_qty'   " 
sql_syntax += "from Content_Summary"
sql_syntax += " Where Project_ID = 'FUNAI'"
sql_syntax += " And inventory_type IN " + asBondedWhsInvTypes
sql_syntax += " Group by Wh_Code, SKU,Supp_code, Inventory_Type "
sql_syntax += " Having Sum( Avail_Qty  ) + Sum( alloc_Qty  )   > 0 "
sql_syntax += " Order by wh_code, Supp_code, SKU;  "

ldsInv.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for FUNAI Inventory Snapshot ID data.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

lirc = ldsInv.SetTransobject(sqlca)

//Retrieve the Inv Data
lsLogout = 'Retrieving Inventory Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsInv.Retrieve()


lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

If llRowCount < 1 Then 
	Return 0
End If

For llRowPos = 1 to llRowCOunt
	
	lsSUpplier = ldsInv.GetItemString(llRowPos,'supp_code')
	
	If lsSupplier <> lsSupplierSave Then
		
		//Write Previous supplier if any data
		If ldsOut.RowCount() > 0 Then
			gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'FUNAI')
			ldsOut.Reset()
		End If
		
		//Next File Sequence #...
		ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no("PHIIPS-SG",'EDI_Generic_Outbound','EDI_Batch_Seq_No')
		If ldBatchSeq <= 0 Then
			lsLogOut = "        *** Unable to retrieve the next available sequence number for FUNAI BOH file. Confirmation will not be sent'"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If
	
	End If /* Supplier Chnaged*/
	
	
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'BW|' /*rec type = balance on Hand Confirmation*/
	lsOutString += String(ldtToday,'YYYYMMDDHHMM') + "|"
	lsOutString += ldsInv.GetItemString(llRowPos,'sku') + '|'
	lsOutString += string(ldsInv.GetItemNumber(llRowPos,'total_qty'),'############0')  + '|'
	lsOutString += ldsInv.GetItemString(llRowPos,'supp_code') + '|'
	lsOutString += getPhilipsInvType(ldsInv.GetItemString(llRowPos,'inventory_type')) /*Convert to Philips Inv Type */
	
	ldsOut.SetItem(llNewRow,'Project_id', 'FUNAI')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'dest_cd', 'BOH') 
	ldsOut.SetItem(llNewRow,'file_name', 'BW' + String(ldbatchSeq,'000000') + ".DAT")
	
	lsSupplierSave = lsSupplier
	
Next /*next output record */

//Write last/Only
If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'FUNAI')
End If


end function

on u_nvo_proc_funai.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_funai.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

