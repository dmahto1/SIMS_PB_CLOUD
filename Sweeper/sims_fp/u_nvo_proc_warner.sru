HA$PBExportHeader$u_nvo_proc_warner.sru
$PBExportComments$Process Warner files
forward
global type u_nvo_proc_warner from nonvisualobject
end type
end forward

global type u_nvo_proc_warner from nonvisualobject
end type
global u_nvo_proc_warner u_nvo_proc_warner

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 

Function Long GetACP  () Library "kernel32.dll"

end prototypes

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
public function integer uf_process_dboh ()
public function string getmenloinvtype (string asinvtype)
public function string getwarnerinvtype (string asinvtype)
public function integer uf_process_customer (string aspath, string asproject)
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
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
			
ElseIf Left(asFile,2) =  'DM' Then /* Sales Order Files from LMS to SIMS*/
		
		liRC = uf_process_so(asPath, asProject)
		
		//Process any added SO's
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
		
ElseIf Left(asFile,2) =  'IM' Then /* Item Master File*/
		
		liRC = uf_process_itemMaster(asPath, asProject)
		
ElseIf  Left(asFile,2) =  'CM' Then /* Customer Master File*/ 
	
	liRC = uf_process_Customer(asPath, asProject)
		
Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
	End If

Return liRC
end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for Warner

Datastore	ldsDOHeader, ldsDODetail,	lu_ds
				
String		lsLogout, lsRecData, lsTemp,lsErrText, lsSKU, lsRecType, lswarehouse, lsSupplier,		lsFind,	&
			 lsOrdType, lsOrder, lsCustCode,	lsName, lsAddr1, lsAddr2, lsAddr3, lsAddr4, lsCity, lsState, lsZip, lsCountry, lsTel, lsFax, lsContact, lsEmail


Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos, llNewRow, llCount, llQty,	 llPos,  llOwner, llFindRow, llBatchSeq, llOrderSeq, llLineSeq, lLDetailFindROw
				
Decimal		ldQty
				
DateTime		ldtToday, ldtOrderDate
Date			ldtShipDate
Boolean		lbError
Blob			lblb_wide_chars

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



//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/



liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Warner Processing: " + asPath
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

//Get the default owner for Warner
llOwner = 0
			
Select Owner_id into :llOwner
From Owner
Where project_id = :asProject and owner_type = 'S' and owner_cd = 'WARNER';

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = lu_ds.RowCount()


//Process each Row
For llRowPos = 1 to llRowCount 
	
	lsRecData = lu_ds.GetITemString(llRowpos, 'rec_data')
	
	//Convert To Unicode using COdepage 936 (Chinese)
	liRC = MultiByteToWideChar(936, 0, lsRecData, -1, lblb_wide_chars, 0) 
  	IF liRC > 0 THEN 
		
			// Reserve Unicode Chars 
			lblb_wide_chars = blob( space( (liRC+1)*2 ) ) 
	
			// Convert codepage 936  to UTF-16 
			liRC = MultiByteToWideChar(936, 0, lsRecData, -1, lblb_wide_chars, (liRC+1)*2 ) 

  	END IF 

	lsRecData = String(lblb_wide_chars)
	
	
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
			ldsDOHeader.SetITem(llNewRow,'wh_code','WARNER-SH') /*Default WH for Project */
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
						
			
						
			//Order Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Order Date' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If
			
			ldsDOHeader.SetItem(llNewRow,'ord_Date',Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))
			
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
			
			//Retrieve Customer Record and Validate Cust COde...
			Select Cust_Code, Cust_Name, ADdress_1, Address_2, Address_3, address_4, City, State, Zip, Country, Contact_person, Tel, Fax, Email_Address
			Into	:lsCustCode, :lsName, :lsAddr1, :lsAddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry, :lsContact, :lsTel, :lsFax, :lsEmail
			From Customer
			Where Project_id = :asproject and Cust_Code = :lsTemp;
			
			If lsCustCOde = '' then /*Cust does not exist*/
			
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid Customer Code: '" + lsTemp + "'  Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
				
			Else /* Load Address */
				
				ldsDOHeader.SetItem(llNewRow,'cust_Name',Trim(lsName))
				ldsDOHeader.SetItem(llNewRow,'address_1',Trim(lsAddr1))
				ldsDOHeader.SetItem(llNewRow,'address_2',Trim(lsAddr2))
				ldsDOHeader.SetItem(llNewRow,'address_3',Trim(lsAddr3))
				ldsDOHeader.SetItem(llNewRow,'address_4',Trim(lsAddr4))
				ldsDOHeader.SetItem(llNewRow,'city',Trim(lsCity))
				ldsDOHeader.SetItem(llNewRow,'state',Trim(lsState))
				ldsDOHeader.SetItem(llNewRow,'zip',Trim(lsZip))
				ldsDOHeader.SetItem(llNewRow,'country',Trim(lsCountry))
				ldsDOHeader.SetItem(llNewRow,'tel',Trim(lsTel))
				ldsDOHeader.SetItem(llNewRow,'contact_person',Trim(lsContact))
					
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Customer PO -UF18 (Unicode)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Customer PO Number' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If

		//	ldsDOHeader.SetItem(llNewRow,'Order_No',Trim(lsTemp))
			ldsDOHeader.SetItem(llNewRow,'User_Field18',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//warehouse - Ignore
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
												
			
			//Remarks
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else /*error*/
				lsTEmp = lsRecData
			End If

			ldsDOHeader.SetItem(llNewRow,'remark',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Invoice Number ->UF2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else /*error*/
				lsTEmp = lsRecData
			End If

			ldsDOHeader.SetItem(llNewRow,'User_field2',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Salesman Name ->UF17 (needs to be unicode)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else /*error*/
				lsTEmp = lsRecData
			End If

			ldsDOHeader.SetItem(llNewRow,'User_field17',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			//Buyer Name  ->UF16 (Need unicode field)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else /*error*/
				lsTEmp = lsRecData
			End If

			ldsDOHeader.SetItem(llNewRow,'User_field16',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
	
				
		// DETAIL RECORD
		Case 'DD' /*Detail */

			llnewRow = ldsDODetail.InsertRow(0)
			llLineSeq ++ /*also used for Line_Item_No in Detail record*/
						
			//Add detail level defaults
			ldsDODetail.SetITem(llNewRow,'project_id', asproject) /*project*/
			ldsDODetail.SetITem(llNewRow,'Inventory_Type', 'N')
			ldsDODetail.SetITem(llNewRow,'supp_code', 'WARNER')
			ldsDODetail.SetITem(llNewRow,'owner_id', llOwner)
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
						
			
			
			//Cust SKU -> UF 1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			
			ldsDODetail.SetItem(llNewRow,'User_field1',Trim(lsTemp))
			
				
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Price
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			
			
			If isNumber(lsTemp) Then
				ldsDODetail.SetItem(llNewRow,'price',Trim(lsTemp))
			Else
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - Price is not numeric. Row will not be processed")
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				lbError = True
				Continue /*Process Next Record */
			End If
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
	Case Else /*Invalid rec type */
			
			If llRowPos < llRowCount Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed (Delivery Order will still be loaded).")
				lbError = True
			End If
			
//			Return -1
			
	End Choose /*Header or Detail */
	
Next


//Save Changes
SQLCA.DBParm = "disablebind =0"
liRC = ldsDOHeader.Update()
SQLCA.DBParm = "disablebind =1"

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

public function integer uf_process_itemmaster (string aspath, string asproject);
//Process Item Master (IM) Transaction for Warner


String	lsData, lsTemp, lsLogOut, lsStringData, lsSKU, 	lsSupplier, lsCrap
			
Integer	liRC,	liFileNo, liTempFileNo
			
Long		llCount,	llPos, llOwner, llNew, llExist, llNewRow, llFileRowCount, llFileRowPos 

Decimal ldtemp
DateTime	ldtToday, ldtLastUpdate
Boolean	lbNew, lbError
Blob	lbStringData, lblb_wide_chars

ldtToday = DateTIme(Today(),Now())


u_ds_datastore	ldsItem 
datastore	lu_DS

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master_w_supp_cd' /* retrieving by SKU and Supplier - Not updating across suppliers*/
ldsItem.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening Warner Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)


If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master File for Warner Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

liRC = FileReadEx(liFileNo,lsStringData)

Do While liRC > 0
	
		llNewRow = lu_ds.InsertRow(0)
		lu_ds.SetItem(llNewRow,'rec_data',Trim(lsStringData))
		liRC = FileReadEx(liFileNo,lsStringData)
		
//		liRC = FileReadEx(liFileNo,lbStringData)
//		lsStringData = String(lbStringData, EncodingANSI!)
		
	
Loop /*Next File record*/

FileClose(liFileNo)


//Get Default owner for Warner
Select owner_id into :llOwner
From Owner
Where project_id = :asProject and Owner_type = 'S' and owner_cd = 'WARNER';
		
//Supplier defaulting to Warner
lsSUpplier = 'Warner'

//Process each Row
llFileRowCOunt = lu_ds.RowCount()



For llfileRowPos = 1 to llFileRowCOunt
		
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))
	
	
	If llFileRowPos = 1 and left(lu_ds.GetITemString(llFileRowPos,'rec_data'),2) <> 'IM' Then 
		lsData = Mid(Trim(lu_ds.GetITemString(llFileRowPos,'rec_data')),3,99999)
	Else
		lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_data'))
	End If

	//Convert To Unicode using COdepage 936 (Chinese)
	liRC = MultiByteToWideChar(936, 0, lsData, -1, lblb_wide_chars, 0) 
  	IF liRC > 0 THEN 
		
			// Reserve Unicode Chars 
			lblb_wide_chars = blob( space( (liRC+1)*2 ) ) 
	
			// Convert codepage 936  to UTF-16 
			liRC = MultiByteToWideChar(936, 0, lsData, -1, lblb_wide_chars, (liRC+1)*2 ) 
		
	
  	END IF 

	lsDAta = String(lblb_wide_chars)
	
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

	
	//Retrieve for SKU and Supplier
	llCount = ldsItem.Retrieve(asProject, lsSKU,lsSupplier)

	If llCount <= 0 Then /* Insert a new record*/
					
		llNew ++ /*add to new count*/
		lbNew = True
		llNewRow = ldsItem.InsertRow(0)
		ldsItem.SetItem(1,'project_id',asProject)
		ldsItem.SetItem(1,'SKU',lsSKU)
		ldsItem.SetItem(1,'supp_code',lsSupplier)
		ldsItem.SetItem(1,'component_ind','N')
		ldsItem.SetItem(1,'owner_id',llOwner)
							
	Else /*exists*/
				
		llexist += llCount /*add to existing Count*/
		lbNew = False
	
	End If
		
		
	//Description
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		lsTemp = lsData
	End If
	
	If lsTEmp > '' Then
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
	
	
	For llPos = 1 to ldsItem.RowCount()
		If lsTEmp > '' Then
			ldsItem.SetItem(llPos,'uom_1',left(lsTemp,4))
		Else 
			ldsItem.SetItem(llPos,'uom_1','EA') //Default EA
		End If
	Next
		
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Grp - Needs to be validated...
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTemp > '' Then
		
		Select Count(*) into :llCount
		From Item_Group
		Where Project_id = :asProject and grp = :lsTemp;
		
		If llCount < 1 Then
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Group: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue
			
		Else
			
			If lsTEmp > '' Then
				For llPos = 1 to ldsItem.RowCount()
					ldsItem.SetItem(llPos,'grp',lsTemp)
				Next
			End If
				
		End If
		
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Standard Cost (Price)
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp))  and lsTemp > '' Then /*only map if numeric*/
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Std_Cost',dec(trim(lsTemp)))
		next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//UPC Code
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(lsTEmp)  and lsTemp > '' Then /*only map if numeric*/
		ldTemp = Dec(lsTemp) 
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Part_UPC_Code',ldTemp)
		Next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	
	//Product Release Date  -> UF1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to ldsItem.RowCount()
				ldsItem.SetItem(llPos,'user_field1',lsTemp)
		Next
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

		
	
	//Native Description 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
			
	If lsTEmp > '' Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'native_description',lsTemp)
		Next
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	
	//Update any record defaults
	For llPos = 1 to ldsItem.RowCount()
		ldsItem.SetItem(llPos,'Last_user','SIMSFP')
		ldsItem.SetItem(llPos,'last_update',ldtToday)
	Next
		
	//If record is new...
	If lbNew Then
		ldsItem.SetItem(1,'serialized_ind','N') 
		ldsItem.SetItem(1,'lot_controlled_ind','N') 
		ldsItem.SetItem(1,'po_controlled_ind','N') 
		ldsItem.SetItem(1,'po_no2_controlled_ind','N') 
		ldsItem.SetItem(1,'expiration_controlled_ind','N') 
		ldsItem.SetItem(1,'container_tracking_ind','N') 
		ldsItem.SetItem(1,'standard_of_Measure','M') /*default to metric*/
		ldsItem.SetItem(1,'country_of_Origin_default','XXX')
	End If
			
	//Save NEw Item to DB
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

protected function integer uf_process_po (string aspath, string asproject);//Process PO for Philips Singapore

Datastore	lu_ds

String	lsLogout,lsStringData, lsOrder, lsWarehouse, lsTemp, lsRecData, lsRecType
Integer	liRC,liFileNo
Long		llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llOWner
Boolean	lbError, lbDetailError
DateTime	ldtToday, ldtOrderDate
Decimal	ldWeight, ldLineItemNo
String 	lsOrderNo, lsInvType
Blob		lblb_wide_chars

ldtToday = DateTime(Today(),Now())


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
lsLogOut = '      - Opening File for Warner Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Warner Processing: " + asPath
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

//Get the default owner for Warner
llOwner = 0
			
Select Owner_id into :llOwner
From Owner
Where project_id = :asProject and owner_type = 'S' and owner_cd = 'WARNER';

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1


//Process each row of the File
llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	lsRecData = Trim(lu_ds.GetItemString(llRowPos,'rec_Data'))
	
	//Convert To Unicode using COdepage 936 (Chinese)
	liRC = MultiByteToWideChar(936, 0, lsRecData, -1, lblb_wide_chars, 0) 
  	IF liRC > 0 THEN 
		
			// Reserve Unicode Chars 
			lblb_wide_chars = blob( space( (liRC+1)*2 ) ) 
	
			// Convert codepage 936  to UTF-16 
			liRC = MultiByteToWideChar(936, 0, lsRecData, -1, lblb_wide_chars, (liRC+1)*2 ) 

  	END IF 

	lsRecData = String(lblb_wide_chars)
	
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsRecType)
			
		Case 'PM' /*PO Header*/
			
			llNewRow = 	idsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			idsPOheader.SetItem(llNewRow, 'project_id',asProject)
			idsPOheader.SetItem(llNewRow, 'Request_date',String(Today(),'YYMMDD'))
			//idsPOheader.SetItem(llNewRow, 'ord_date',String(ldtOrderDate,'yyyy/mm/dd hh:mm'))
			idsPOheader.SetItem(llNewRow, 'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPOheader.SetItem(llNewRow, 'order_seq_no',llOrderSeq) 
			idsPOheader.SetItem(llNewRow, 'ftp_file_name',asPath) /*FTP File Name*/
			idsPOheader.SetItem(llNewRow, 'Status_cd','N')
			idsPOheader.SetItem(llNewRow, 'Last_user','SIMSEDI')
			idsPOheader.SetItem(llNewRow, 'Order_type', 'S') /*Order Type = Supplier */
			idsPOheader.SetItem(llNewRow, 'Inventory_Type','N') /*default to Normal*/
			idsPOheader.SetItem(llNewRow, 'wh_code',"WARNER-SH") /*defaulting for now*/
			idsPOheader.SetItem(llNewRow,'supp_code','WARNER')
					
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
		

			//Order Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Date' field. Record will not be processed.")
			End If
					
			idsPOheader.SetItem(llNewRow,'Ord_Date',Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))
			
					
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
			
		
			
			//Remarks
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'remark',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
						
			//Vendor name -> UF7
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'User_Field7',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Delivery Contact -> UF8 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'User_Field8',lsTemp)
			
					
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
			idsPODetail.SetItem(llNewDetailRow,"owner_id",string(llOwner))
			idsPODetail.SetItem(llNewDetailRow,'supp_code','WARNER') /*Supplier defaulted*/
			
		
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
SQLCA.DBParm = "disablebind =0"
lirc = idsPOHeader.Update()
SQLCA.DBParm = "disablebind =1"
	
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

public function integer uf_process_return_order (string aspath, string asproject);//Process Return Order for Warner

Datastore	lu_ds

String	lsLogout,lsStringData, lsOrder, lsWarehouse, lsTemp, lsRecData, lsRecType, lsCustCode, lsCustName, lsCustAddr1, lsCustAddr2, lsCustAddr3, lsCustAddr4, lsCustCity, lsCustState, lsCustZip, lsCustCountry, lsCustDistrict, lsCustContact, lsCustTel, lsNoteText, lsNoteType
Integer	liRC,liFileNo
Long		llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llNewAddressRow, llNewNotesRow, llNoteLine, llNoteSeq,llOwner
Boolean	lbError, lbDetailError
DateTime	ldtToday, ldtOrderDate
Decimal	ldWeight, ldLineItemNo
String 	lsOrderNo
Blob		lblb_wide_chars

ldtToday = DateTime(Today(),Now())


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


idsPoheader.Reset()
idsPODetail.Reset()
idsROAddress.Reset()


//Open and read the File In
lsLogOut = '      - Opening File for Warner Return (RMA) Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Warner Processing: " + asPath
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



//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Get the default owner for Warner
llOwner = 0
			
Select Owner_id into :llOwner
From Owner
Where project_id = :asProject and owner_type = 'S' and owner_cd = 'Warner';

//Process each row of the File
llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	lsRecData = Trim(lu_ds.GetItemString(llRowPos,'rec_Data'))
	
	//Convert To Unicode using COdepage 936 (Chinese)
	liRC = MultiByteToWideChar(936, 0, lsRecData, -1, lblb_wide_chars, 0) 
  	IF liRC > 0 THEN 
		
			// Reserve Unicode Chars 
			lblb_wide_chars = blob( space( (liRC+1)*2 ) ) 
	
			// Convert codepage 936  to UTF-16 
			liRC = MultiByteToWideChar(936, 0, lsRecData, -1, lblb_wide_chars, (liRC+1)*2 ) 

  	END IF 

	lsRecData = String(lblb_wide_chars)
	
	
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsRecType)
			
		Case 'RM' /*Return Header*/
			
			llNewRow = 	idsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			idsPOheader.SetItem(llNewRow, 'project_id',asProject)
			idsPOheader.SetItem(llNewRow, 'wh_code','WARNER-SH')
			idsPOheader.SetItem(llNewRow, 'ord_date',String(ldtToday,'yyyy/mm/dd hh:mm'))
			idsPOheader.SetItem(llNewRow, 'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPOheader.SetItem(llNewRow, 'order_seq_no',llOrderSeq) 
			idsPOheader.SetItem(llNewRow, 'ftp_file_name',asPath) /*FTP File Name*/
			idsPOheader.SetItem(llNewRow, 'Status_cd','N')
			idsPOheader.SetItem(llNewRow, 'Last_user','SIMSEDI')
			idsPOheader.SetItem(llNewRow, 'Order_type', 'X') /*Order Type = Return from Customer */
			idsPOheader.SetItem(llNewRow, 'Inventory_Type','E') /*default to Returns*/
			idsPOheader.SetItem(llNewRow, 'action_cd', 'A') 
			idsPOheader.SetItem(llNewRow,'supp_code','WARNER')
					
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
			
			
						
			//Customer Code - UF10
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			idsPOheader.SetItem(llNewRow,'User_Field10',Trim(lsTemp))
			
			//Validate against Customer MAster and create Alt Address record...
			Select Cust_Code, Cust_Name, Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country, Contact_person, tel
			Into	:lsCustCode, :lsCustName, :lsCustaddr1, :lsCustaddr2, :lsCustaddr3, :lsCustaddr4, :lsCustCity, :lsCustState, :lsCustZip, :lsCustCountry, :lsCustContact, :lsCustTel
			From Customer
			Where Project_id = :asProject and cust_code = :lsTemp;
					
			If lsCustCode = "" Then /*cust Not Found*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid RMA Customer Code: '" + lsTemp + "' . Record will not be processed.")
			Else
					//Build the Receive_alt_Address record...
					llNewAddressRow = idsROAddress.InsertRow(0)
					idsROAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
					idsROAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
					idsROAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
					idsROAddress.SetItem(llNewAddressRow,'address_type','RC') /* Return Customer*/
					idsROAddress.SetItem(llNewAddressRow,'Name', lsCustName)
					idsROAddress.SetItem(llNewAddressRow,'address_1',lsCustAddr1)
					idsROAddress.SetItem(llNewAddressRow,'address_2',lsCustAddr2)
					idsROAddress.SetItem(llNewAddressRow,'address_3',lsCustAddr3)
					idsROAddress.SetItem(llNewAddressRow,'address_4',lsCustAddr4)
					idsROAddress.SetItem(llNewAddressRow,'City',lsCustCity)
					idsROAddress.SetItem(llNewAddressRow,'State',lsCustState)
					idsROAddress.SetItem(llNewAddressRow,'Zip',lsCustZip)
					idsROAddress.SetItem(llNewAddressRow,'Country',lsCustCountry)
					idsROAddress.SetItem(llNewAddressRow,'contact_person',lsCustContact)
					idsROAddress.SetItem(llNewAddressRow,'tel',lsCustTel)
			
			End If		
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			//Warehouse - Ignore - defaulted above
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
							
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Remarks
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'remark',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
				
			//Customer Ref - UF12 (needs Unicode field)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			idsPOheader.SetItem(llNewRow,'User_Field12',Trim(lsTemp))
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Salesman Name - UF13 (needs Unicode Field)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			idsPOheader.SetItem(llNewRow,'User_Field13',Trim(lsTemp))
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
		CASE 'RD' /* detail*/
			
			lbDetailError = False
			llNewDetailRow = 	idsPODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			idsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			idsPODetail.SetItem(llNewDetailRow,'status_cd', 'E') /* set inventory Type to Return */
			idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'E') 
			idsPODetail.SetItem(llNewDetailRow,'Action_cd', 'U')
			idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			idsPODetail.SetItem(llNewDetailRow,"owner_id",string(llOwner))
			idsPODetail.SetItem(llNewDetailRow,'supp_code','WARNER')
			
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
			
			
			//Price 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
		
			If isnumber(lsTemp) Then
				idsPODetail.SetItem(llNewDetailRow,'Cost',Trim(lsTemp)) 
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			// Cost - Ignore, we can calculate as price * Qty
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
		
			//idsPODetail.SetItem(llNewDetailRow,'Cost',Trim(lsTemp)) 

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
					
			
			//Alt SKU - UF2
				If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
		
			idsPODetail.SetItem(llNewDetailRow,'User_Field2',Trim(lsTemp)) 

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
SQLCA.DBParm = "disablebind =0"
lirc = idsPOHeader.Update()
SQLCA.DBParm = "disablebind =1"

If liRC = 1 Then
	liRC = idsPODetail.Update()
End If

If liRC = 1 Then
	SQLCA.DBParm = "disablebind =0"
	liRC = idsROAddress.Update()
	SQLCA.DBParm = "disablebind =1"
End If

If liRC = 1 then
	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save newReturn Order Records to database!"
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

public function integer uf_process_dboh ();Integer	liRC, liFileNo
Long	llRowCount, llRowPos, llNewRow,  llQty
String	lsOutString,  lsLogOut,  lsFIleName, lsSupplierSave, lsSupplier
string ERRORS, sql_syntax
Datastore	 ldsInv, ldsOut
DateTime	ldtToday, ldtNow


//Convert GMT to SIN Time
ldtNow = DateTime(today(),Now())
select Max(dateAdd( hour, 8,:ldtNow )) into :ldtToday
from sysobjects;

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Warner Daily Inventory Snapshot File... " 
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
sql_syntax = "SELECT WH_Code, SKU,  inventory_type,   Sum( Avail_Qty  ) + Sum( alloc_Qty  )  as 'total_qty'   " 
sql_syntax += "from Content_Summary"
sql_syntax += " Where Project_ID = 'WARNER'"
sql_syntax += " Group by Wh_Code, SKU, Inventory_Type "
sql_syntax += " Having Sum( Avail_Qty  ) + Sum( alloc_Qty  )   > 0 "
sql_syntax += " Order by wh_code, SKU;  "

ldsInv.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Warner Inventory Snapshot ID data.~r~r" + Errors
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

decimal ldCurrentBHBatchSeqNum

//Get the Next CurrentBHBatchSeqNum
sqlca.sp_next_avail_seq_no('WARNER','CurrentBHBatchSeqNum','CurrentBHBatchSeqNum',ldCurrentBHBatchSeqNum)

If ldCurrentBHBatchSeqNum <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor DBOH.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

For llRowPos = 1 to llRowCOunt
	
	
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'BH|' /*rec type = balance on Hand Confirmation*/
	lsOutString += String(ldtToday,'YYYYMMDD') + "|"
	lsOutString += "01|" /* hardcoded warehouse value*/
	lsOutString += getWarnerInvType(ldsInv.GetItemString(llRowPos,'inventory_type')) + "|"  /*Convert to Warner Inv Type */
	lsOutString += ldsInv.GetItemString(llRowPos,'sku') + '|'
	lsOutString += string(ldsInv.GetItemNumber(llRowPos,'total_qty'),'############0')  
		
	ldsOut.SetItem(llNewRow,'Project_id', 'WARNER')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldCurrentBHBatchSeqNum))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', 'BH' + String(ldCurrentBHBatchSeqNum,'000000') + ".DAT")
	
	lsSupplierSave = lsSupplier
	
Next /*next output record */

//Write to file
If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'WARNER')
End If


end function

public function string getmenloinvtype (string asinvtype);//Convert the Philips Inventory Type into the Menlo code

String	lsMenloInvType
Choose case upper(asInvType)
		
	Case 'A'
		lsMenloInvType = 'N' /*Saleable */
	Case 'D'
		lsMenloInvType = 'R' /*Rework*/
	Case Else
		lsMenloInvType = asInvType
End Choose

Return lsMenloInvType
end function

public function string getwarnerinvtype (string asinvtype);//Convert the Philips Inventory Type into the Menlo code

String	lsWarnerInvType
Choose case upper(asInvType)
		
	Case 'N'
		lsWarnerInvType = 'A' /*NOrmal->Saleable*/
	Case 'R'
		lsWarnerInvType = 'D' /*Rework*/
	Case Else
		lsWarnerInvType = asInvType
End Choose

Return lsWarnerInvType
end function

public function integer uf_process_customer (string aspath, string asproject);

//Process Customer Master Transaction for Warner

u_ds_datastore	ldsCustomer
DAtastore	lu_DS

String	lsData,			&
			lsTemp,			&
			lsLogOut, 		&
			lsStringData,	&
			lsCustomer
			
Integer	liRC,	&
			liFileNo
			
Long		llCount,				&
			llNew,				&
			llExist,				&
			llNewRow,			&
			llFileRowCount,	&
			llFileRowPos

Boolean	lbError
Blob		lblb_wide_chars

ldsCustomer = Create u_ds_datastore
ldsCustomer.dataobject= 'd_Customer_master'
ldsCustomer.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening Warner Customer Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Customer Master File for Warner Processing: " + asPath
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
	
	w_main.SetMicroHelp("Processing Customer Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))
	
	//Convert To Unicode using COdepage 936 (Chinese)
	liRC = MultiByteToWideChar(936, 0, lsData, -1, lblb_wide_chars, 0) 
  	IF liRC > 0 THEN 
		
			// Reserve Unicode Chars 
			lblb_wide_chars = blob( space( (liRC+1)*2 ) ) 
	
			// Convert codepage 936  to UTF-16 
			liRC = MultiByteToWideChar(936, 0, lsData, -1, lblb_wide_chars, (liRC+1)*2 ) 
		
	
  	END IF 

	lsDAta = String(lblb_wide_chars)
		
	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsDAta,Len(lsData) - 1)
	End If
	
	//Validate Rec Type is CM
	lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	If lsTemp <> 'CM' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Validate Customer and retrieve existing or Create new Row
	If Pos(lsData,'|') > 0 Then
	
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsCustomer = lsTemp
	
		//Retrieve the DS to pupulate existing SKU if it exists, other wise insert new
		llCount = ldsCustomer.Retrieve(asProject, lsCustomer)
		If llCount <= 0 Then
			
			llNew ++ /*add to new count*/
			ldsCustomer.InsertRow(0)
			ldsCustomer.SetItem(1,'project_id',asProject)
			ldsCustomer.SetItem(1,'cust_code',lsCustomer)
			ldsCustomer.SetItem(1,'customer_Type','CU') /*Default Customer Type*/
				
		Else /*Customer Master exists */
		
			llExist += llCount /*add to existing Count*/
					
		End If
			
	Else /*error*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Customer' field. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
		
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	//Customer Name 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsDAta
	End If

	ldsCustomer.SetItem(1,'cust_name',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'address_1',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 2
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'address_2',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 3
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'address_3',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 4
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'address_4',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	//City
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'City',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//State
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'State',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Zip
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'Zip',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Country
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'Country',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Contact
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'Contact_Person',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//telephone
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'tel',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Fax
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'fax',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Short Shipment Flag -> UF1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'User_Field1',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Customer Short Name - UF2
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'User_Field2',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	
	//Update any record defaults
	ldsCustomer.SetItem(1,'Last_user','SIMSFP')
	ldsCustomer.SetItem(1,'last_update',today())

	//Save Customer to DB
	SQLCA.DBParm = "disablebind =0"
	lirc = ldsCustomer.Update()
	SQLCA.DBParm = "disablebind =1"
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save Customer Master Record to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save Customer Master Record to database!")
		//Return -1
		Continue
	End If

Next /*File row to Process */

w_main.SetMicroHelp("")

lsLogOut = Space(10) + String(llNew) + ' Customer Records were successfully added and ' + String(llExist) + ' Records were updated.'
FileWrite(gilogFileNo,lsLogOut)

Destroy ldsCustomer

If lbError then
	Return -1
Else
	Return 0
End If
end function

on u_nvo_proc_warner.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_warner.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

