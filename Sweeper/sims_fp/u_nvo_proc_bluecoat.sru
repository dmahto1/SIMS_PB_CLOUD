HA$PBExportHeader$u_nvo_proc_bluecoat.sru
$PBExportComments$Process Blue Coat files
forward
global type u_nvo_proc_bluecoat from nonvisualobject
end type
end forward

global type u_nvo_proc_bluecoat from nonvisualobject
end type
global u_nvo_proc_bluecoat u_nvo_proc_bluecoat

type variables
//String	isWarehouse
end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_so_po (string aspath, string asproject)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 2 characters of the file name

String	lsLogOut,	&
			lsSaveFileName, lstemp
			
Integer	liRC

Boolean	lbOnce
lbOnce = false

lstemp = Upper(Left(asFile,6))
Choose Case Upper(Left(asFile,6))
		
	Case 'BC_940' /* Sales Order/Purchase Order Files*/
		
//		liRC = uf_process_so(asPath, asProject)
		liRC = uf_process_so_po(asPath, asProject)
		
		//Process any added SO's
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 

		//Process any added PO's
		liRC = gu_nvo_process_files.uf_process_Purchase_order(asProject) 

Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
end function

public function integer uf_process_so_po (string aspath, string asproject);//Process files for Blue Coat to Create the Receive Order and Delivery Order
Datastore	ldsDOHeader,	&
				ldsDODetail,	&
				ldsDONotes,	&
				ldsDOAddress,	&
				ldsPOHeader, &
				ldsPODetail, & 
				lu_ds
				
String		lsLogout, lsRecData, lsTemp,lsErrText, lsSKU, lsRecType, lswarehouse, &
				lsBillToName, lsBillToAddr1, lsBillToADdr2, lsBillToADdr3,  lsBillToAddr4, lsBillToStreet,	&
				lsBillToZip, lsBillToCity, lsBillToState, lsBillToCountry, lsBillToTel, lsOrdType

Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos, llNewRow, llNewAddressRow, llCount, llQty,	&
				llCONO, llRoNO, llLineItemNo,  llOwner, llNewNotesRow, llFindRow, llIBBatchSeq, llOBBatchSeq, llOrderSeq, llLineSeq
				
Decimal		ldQty
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError, lbBillToAddress, lbDM, lbDD

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

ldsPOheader = Create u_ds_datastore
ldsPOheader.dataobject= 'd_po_header'
ldsPOheader.SetTransObject(SQLCA)

ldsPOdetail = Create u_ds_datastore
ldsPOdetail.dataobject= 'd_po_detail'
ldsPOdetail.SetTransObject(SQLCA)


//Open the File
lsLogOut = '      - Opening File for Sales Order and Purchase order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Blue Coat Processing: " + asPath
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

//Get Default owner for Bluecoat (Supplier) 
Select owner_id into :llOwner
From OWner
Where project_id = :asProject and Owner_cd = 'NETAPP' and owner_type = 'S';

//Get the next available file sequence number
llIBBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
llOBBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Outbound_Header','EDI_Batch_Seq_No')
If llIBBatchSeq <= 0 Then Return -1
If llOBBatchSeq <= 0 Then Return -1

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
			
			llNewRow = ldsDOHeader.InsertRow(0)
			llNewRow = ldsPOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0

						
			//Record Defaults
			ldsDOHeader.SetItem(llNewRow,'ACtion_cd','A') /*always a new Order*/
			ldsDOHeader.SetITem(llNewRow,'project_id',asProject) /*Project ID*/
			ldsDOHeader.SetITem(llNewRow,'wh_code',lswarehouse) /*Default WH for Project */
			ldsDOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewRow,'edi_batch_seq_no',llOBbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow,'Status_cd','N')
			ldsDOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')

			ldsPOHeader.SetItem(llNewRow,'ACtion_cd','A') /*always a new Order*/
			ldsPOHeader.SetITem(llNewRow,'project_id',asProject) /*Project ID*/
			ldsPOHeader.SetITem(llNewRow,'wh_code',lswarehouse) /*Default WH for Project */
			ldsPOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
			ldsPOHeader.SetItem(llNewRow,'edi_batch_seq_no',llIBbatchseq) /*batch seq No*/
			ldsPOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsPOHeader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
			ldsPOHeader.SetItem(llNewRow,'Status_cd','N')
			ldsPOHeader.SetItem(llNewRow,'Ship_Ref','N/A')
			ldsPOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')
			ldsPOHeader.SetITem(llNewRow,'supp_code','NETAPP') 
			ldsPOHeader.SetITem(llNewRow,'Request_date',String(Today(),'YYMMDD'))
					
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
			ldsPOHeader.SetItem(llNewRow,'supp_order_no',lsTemp)
			ldsPOHeader.SetItem(llNewRow,'order_no',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
						
			//Delivery Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			End If
			
			ldsPOHeader.SetItem(llNewRow,'request_Date',Trim(lsTemp))
			ldsPOHeader.SetItem(llNewRow,'Arrival_Date',Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Goods Issue Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			End If
			
			ldsDOHeader.SetItem(llNewRow,'schedule_Date',Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Cust Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				IF lstemp = '' Then
					ldsDOHeader.SetItem(llNewRow,'cust_Code','END CUSTOMER')
				Else			
					ldsDOHeader.SetItem(llNewRow,'cust_Code',Trim(lsTemp))
				End If
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
				ldsPOHeader.SetItem(llNewRow,'Order_type','S') /*Supplier Order*/
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
			ldsPOHeader.SetItem(llNewRow,'Carrier',Trim(lsTemp))
			
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
				ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llOBbatchseq) /*batch seq No*/
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

			//Freight Terms
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'Freight_Terms',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Customer Account #
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'User_Field2',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
		// DETAIL RECORD
		Case 'DD' /*Detail */
			
//			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			llnewRow = ldsDODetail.InsertRow(0)
			llnewRow = ldsPODetail.InsertRow(0)
			llLineSeq ++
						
			//Add detail level defaults
			ldsDODetail.SetITem(llNewRow,'project_id', asproject) /*project*/
//			ldsDODetail.SetITem(llNewRow,'action_cd', 'A')  /*always Add */
//			ldsDODetail.SetITem(llNewRow,'Inventory_Type', 'N')
			ldsDODetail.SetITem(llNewRow,'edi_batch_seq_no',llOBbatchseq) /*batch seq No*/
			ldsDODetail.SetITem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDODetail.SetITem(llNewRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetITem(llNewRow,'Status_cd','N')
			ldsDODetail.SetITem(llNewRow,'supp_code', 'NETAPP')

			ldsPODetail.SetItem(llNewRow,'order_seq_no',llORderSeq) 
			ldsPODetail.SetItem(llNewRow,'project_id', asproject) /*project*/
			ldsPODetail.SetItem(llNewRow,'status_cd', 'N') 
			ldsPODetail.SetItem(llNewRow,'Inventory_Type', 'N') 
			ldsPODetail.SetItem(llNewRow,'edi_batch_seq_no',llIBBAtchSeq) /*batch seq No*/
			ldsPODetail.SetItem(llNewRow,"order_line_no",string(llLineSeq))
			ldsPODetail.SetItem(llNewRow,'owner_id',string(llOwner)) //OwnerID if Present	
			ldsPODetail.SetItem(llNewRow,'action_cd','A')
					
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */

		//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDODetail.SetItem(llNewRow,'invoice_no',Trim(lsTemp))
				ldsPODetail.SetItem(llNewRow,'order_no',Trim(lsTemp))
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
					ldsPODetail.SetItem(llNewRow,'line_item_no',Long(Trim(lsTemp)))
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
				ldsPODetail.SetItem(llNewRow,'SKU',Trim(lsTemp))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'SKU' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
							
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Check if Bluecoat already has an Item Master set up form this part Number
			Select Count(*) into :llCount
			From ITem_MAster
			Where Project_ID = :asproject and SKU = :lsTemp and supp_code = 'NETAPP';
	
			//Create a new Item Master for this part Number
			If llCount <= 0 Then
		
					Insert Into Item_MAster (project_id, SKU, Supp_code, Description, Owner_id, Country_of_Origin_Default,
									UOM_1, Freight_Class, LAst_USer, last_Update)
					Values (:asProject, :lsTemp, 'NETAPP', :lsTemp, :llOwner, 'XXX', 'EA', '', 'EDISIMS',:ldtToday)
					Using SQLCA;
		
					If sqlca.sqlcode <> 0 Then
						lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
						Rollback;
						gu_nvo_process_files.uf_writeError("Error saving Row: " + String(llRowPos) + " Unable to save new Item Master record to database!~r~r" + lsErrText)
						lbError = True
					End If
			End If /*New ITem Created */
			
			//Quantity
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If isNumber(lsTemp) Then
					ldsDODetail.SetItem(llNewRow,'quantity',Trim(lsTemp))
					ldsPODetail.SetItem(llNewRow,'quantity',Trim(lsTemp))
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
//				If Not isNull(lsTemp) Then
//					ldsDODetail.SetItem(llNewRow,'Inventory_Type',Trim(lsTemp))
//				Else
//					ldsDODetail.SetItem(llNewRow,'Inventory_Type','N')
//				End If
			Else
				lsTEmp = trim(lsRecData)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			// No more required fields after this point
			
			//Customer PO Line - Mapped to User_field1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'User_Field1',Trim(lsTemp))
			
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
			ldsPODetail.SetItem(llNewRow,'lot_no',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'po_no',Trim(lsTemp))
			ldsPODetail.SetItem(llNewRow,'po_no',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'po_no2',Trim(lsTemp))
			ldsPODetail.SetItem(llNewRow,'po_no2',Trim(lsTemp))
						
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

// pvh - 09/29/06 - better error codes
string whoFailed
//Save Changes
liRC = ldsDOHeader.Update()
If liRC = 1 Then
	liRC = ldsDODetail.Update()
	If liRC = 1 Then
		liRC = ldsPOHeader.Update()
		If liRC = 1 Then
			liRC = ldsPODetail.Update()
		else
			whoFailed = "Purchase Order Header"
		End If
	else
		whoFailed = "Delivery Order Detail"
	End If
else
	whoFailed = "Delivery Order Header"
End If
	
If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new SO Records to database - " + whoFailed
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

If lbError Then Return -1

Return 0
end function

on u_nvo_proc_bluecoat.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_bluecoat.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

