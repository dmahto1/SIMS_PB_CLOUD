HA$PBExportHeader$u_nvo_proc_hillman.sru
$PBExportComments$Process Nortel Files
forward
global type u_nvo_proc_hillman from nonvisualobject
end type
end forward

global type u_nvo_proc_hillman from nonvisualobject
end type
global u_nvo_proc_hillman u_nvo_proc_hillman

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsASNHeader,	&
				idsASNPackage,	&
				idsASNItem

end variables

forward prototypes
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_itemmaster (string aspath, string asproject)
public function integer uf_process_po (string aspath, string asproject)
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_or (ref string asinifile)
public function integer uf_process_boh (string asinifile)
end prototypes

public function integer uf_process_so (string aspath, string asproject);//GAP1103 - Process Sales Order files  (DM FILE)

Datastore	ldsDOHeader,	&
				ldsDODetail,	&
				lu_ds
				
String		lsLogout,lsRecData,lsTemp,lsRecType,lsOrder,lswarehouse,lsDate

String		lsName, lsAdd1, lsAdd2, lsAdd3, lsAdd4, lsDistrict, lsCity, lsState, lsZIP, lsCountry, lsTel, lsContact

Integer		liFileNo,liRC

decimal 		ldTemp
				
Long			llRowCount,	llRowPos,llNewRow,llOrderSeq,	llBatchSeq,	llLineSeq,llCount,llOwner,llTemp, llLen
				
DateTime		ldtToday, ldt_Current_Sweeper_Datetime

Boolean		lbError, lbDM, lbDD

ldtToday = DateTime(today(),Now())
				
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
	lsLogOut = "-       ***Unable to Open File for HILLMAN Processing: " + asPath
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

//Get Default owner for HILLMAN (Supplier) in case we are creating any Non Consolidated FG to Inv Receive Detail records
Select owner_id into :llOwner
From OWner
Where project_id = :asProject and Owner_cd = 'HILLMAN' and owner_type = 'S';

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = lu_ds.RowCount()

//Process each Row
For llRowPos = 1 to llRowCount 

	If llrowpos = 1090 then
		llLen = Len(lu_ds.GetItemString(llRowPos,'rec_data'))
	End if
	

	//Check for Valid length of PM record (larger of both header and detail)
	llLen = Len(lu_ds.GetItemString(llRowPos,'rec_data'))
	If  llLen < 182  or llLen > 182 Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Record length error. is:" + string(llLen) + ", Should be: 182. Record will not be processed.")
		lbError = True
		Continue /*Next record */
	End If 	
	
	lsRecData = lu_ds.GetITemString(llRowPos,'rec_data')
	lsRecType = Left(lsRecData,2)
	
	//Process header or Detail */
	Choose Case Upper(lsRecType)
			
		//HEADER RECORD
		Case 'DM' /* Header */
			
			w_main.SetMicroHelp("Processing DM Outbound Master Record " + String(llRowPos) + " of " + String(llRowCount))  
	
			llnewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//Record Defaults
			ldsDOHeader.SetItem(llNewRow,'Action_cd','A') /*Default - will add/update an Order*/
			ldsDOHeader.SetITem(llNewRow,'project_id',asProject) /*Project ID*/
			ldsDOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow,'Status_cd','N')
			ldsDOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')
			ldsDOHeader.SetITem(llNewRow,'wh_code',lswarehouse) /*always HILLMAN*/
			ldsDOHeader.SetITem(llNewRow,'User_field8','01') /*10/09 - PCONKL - Default 'Truck Seq'*/
				
			//Order Number
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),3,20)) /*Order Number */
			If lsTemp <> "" Then
				ldsDOHeader.SetItem(llNewRow,'invoice_no',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Delivery Order Number: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			lsOrder = lsTemp
			
			// 07/09 - PCONKL - Supplier Name -> UF6
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),23,9))
			If lsTemp <> "" Then
				ldsDOHeader.SetItem(llNewRow,'User_Field6',lsTemp)
			End If
			
			//Delivery Order Type
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),33,4))
			If lsTemp = "" Then
				lsTemp = "S"
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Delivery Order Type: " + lsTemp + "'.  Sims reset to 'S'.")
				lbError = True
			end if
			ldsDOHeader.SetItem(llNewRow,'order_Type',lsTemp)
			
			//Order_Date - convert to format to mm/dd/yyyy - MEA Changed to GMT 08/2004
			
			SELECT getdate() INTO :ldt_Current_Sweeper_Datetime from project Where project_id = "HILLMAN";
			
			lsDate = String(ldt_Current_Sweeper_Datetime, "yyyy/mm/dd")
			
			ldsDOHeader.SetItem(llNewRow,'ord_Date',lsDate)
			
//			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),37,8))
//			If lsTemp <> "" Then
//				lsDate = Left(lsTemp,4) + '/' + Mid(lsTemp,5,2)  + '/' +  Right(lsTemp,2) 
//				ldsDOHeader.SetItem(llNewRow,'ord_Date',lsDate)				
//			Else /*error*/
//				ldsDOHeader.SetItem(llNewRow,'ord_Date',ldtToday)
//				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Schedule Date: " + lsTemp + ". Sims will replace with:" + string(ldtToday))
//				lbError = True
//			EndIf

			//Goods Issue - schedule_Date - convert to format to mm/dd/yyyy
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),45,8))
			If lsTemp <> "" Then
				lsDate = Left(lsTemp,4) + '/' + Mid(lsTemp,5,2)  + '/' +  Right(lsTemp,2) 
				ldsDOHeader.SetItem(llNewRow,'schedule_Date',lsDate)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Schedule Date: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			//Delivery Date - convert to format to mm/dd/yyyy
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),53,8))
			If lsTemp <> "" Then
				lsDate = Left(lsTemp,4) + '/' + Mid(lsTemp,5,2)  + '/' +  Right(lsTemp,2) 
				ldsDOHeader.SetItem(llNewRow,'delivery_Date',lsDate)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Delivery Date: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If

			//Cust Order Number
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),71,35))
			If lsTemp <> "" Then
				ldsDOHeader.SetItem(llNewRow,'order_no',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Customer Order No.: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If

			//Address Code
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),106,10))
			If lsTemp <> "" Then
				ldsDOHeader.SetItem(llNewRow,'cust_Code',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Customer Code: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If						
						
			//Cust Code
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),116,20))
			If lsTemp <> "" Then
				ldsDOHeader.SetItem(llNewRow,'cust_Code',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Customer Code: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If

			// 07/09 - PCONKL - ASN -> UF7
			If Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),173,10)) > '' Then
				ldsDOHeader.SetItem(llNewRow,'User_Field7',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),173,10)))
			End If
			
			//Get ship to Address information  based on address code above
			Select cust_name, address_1, 	address_2, 	address_3, 	address_4, 	city, 	state, 		zip, 		country,		tel,		contact_person
			into   :lsName, 	:lsAdd1, 	:lsAdd2, 	:lsAdd3, 	:lsAdd4, 	:lsCity, :lsState, 	:lsZIP, 	:lsCountry, :lsTel, :lsContact
			From Customer
			Where project_id = :asProject and cust_code = :lsTemp;
			if lsName > '' then 
				ldsDOHeader.SetItem(llNewRow,'cust_name',lsName)
				ldsDOHeader.SetItem(llNewRow,'address_1',lsAdd1)
				ldsDOHeader.SetItem(llNewRow,'address_2',lsAdd2)
				ldsDOHeader.SetItem(llNewRow,'address_3',lsAdd3)
				ldsDOHeader.SetItem(llNewRow,'address_4',lsAdd4)
				ldsDOHeader.SetItem(llNewRow,'city',lsCity)
				ldsDOHeader.SetItem(llNewRow,'state',lsState)
				ldsDOHeader.SetItem(llNewRow,'zip',lsZIP)
				ldsDOHeader.SetItem(llNewRow,'country',lsCountry)
				ldsDOHeader.SetItem(llNewRow,'tel',lsTel) 
				ldsDOHeader.SetItem(llNewRow,'contact_person',lsContact) 
			else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Customer does not have address information in Sims.")
				lbError = True
			end if
			
		// DETAIL RECORD
		Case 'DD' /*Detail */

			// See if we have an order header for this detail record
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),3,20)) 
			if lsorder <> lsTemp  then 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No DM Master found for this record. Record will not be processed.")
				lbError = True
				Continue /*Next record */			
			end if			

			llnewRow = ldsDODetail.InsertRow(0)
			llLineSeq ++
			
			//Add detail level defaults
			ldsDODetail.SetITem(llNewRow,'project_id', asproject) /*project*/
			ldsDODetail.SetITem(llNewRow,'status_cd', 'N') 
			ldsDODetail.SetITem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDODetail.SetITem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDODetail.SetITem(llNewRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetITem(llNewRow,'Status_cd','N')
			ldsDODetail.SetItem(llNewRow,'owner_id',string(llOwner)) //OwnerID if Present	
			
			//Order Number
			ldsDODetail.SetItem(llNewRow,'invoice_no',lsorder)

			//Line Item Number - Validate Line Item No for Numerics
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),23,6)) 
			If isNumber(lsTemp) Then
				ldsDODetail.SetItem(llNewRow,'line_item_no',Long(lsTemp))
			Else
				llTemp = llLineSeq + 999
				ldsDODetail.SetItem(llNewRow,'line_item_no',Long(llTemp))
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - SO Line Number is not numeric. Line number has been set to: " + string(llTemp))
				lbError = True
			End If
			
			//SKU
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),29,50)) 
			If lsTemp <> "" Then
				ldsDODetail.SetItem(llNewRow,'SKU',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - Invalid SKU: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If

			//Supplier
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),79,20))
			If lsTemp = "" Then
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - Invalid SUPPLIER: " + lsTemp + ". Sims changed to 'HILLMAN'.")
				lbError = True
				lsTemp = "HILLMAN"
			End If			
			
			If Upper(lsTemp) = "SUNSOURCE" then lsTemp = "HILLMAN"
			
			ldsDODetail.SetITem(llNewRow,'supp_code',lsTemp)
			
			//Validate QTY for Numerics
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),107,13))
			If Not isnumber(lsTemp) Then
				lsTemp = "0"
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - SO QTY is not numeric. Qty has been set to: " + lsTemp)
				lbError = True
			End If
			ldsDODetail.SetItem(llNewRow,'quantity',lsTemp)

			//Inventory Type
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),120,1))
//			If lsTemp = "" Then
//				lsTemp = "N"			
//				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + "- Invalid INV TYPE: " + lsTemp + ". Sims set to: " + lsTemp)
//				lbError = True
//			End If			
			ldsDODetail.SetItem(llNewRow,'Inventory_type',lsTemp)
			
			// following fields are not required....
			
			//Alternate SKU
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),121,50))
			If lsTemp <> "" Then
				ldsDODetail.SetItem(llNewRow,'alternate_sku',lsTemp)
			End if
			
			//Unit Price
			lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),171,12)) 
			If isnumber(lsTEmp) Then /*only map if numeric*/
				ldTemp = Dec(lsTemp) * .0001
			else
				ldTemp = 0
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + "- Invalid UNIT PRICE: " + lsTemp + ". Sims set to: " + string(ldTemp))
				lbError = True
			End If	
			lsTemp = string(ldTemp)
			ldsDODetail.SetItem(llNewRow,'price',lsTemp)		
			
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

public function integer uf_process_itemmaster (string aspath, string asproject);//GAP1103

//Process Item Master (IM) Transaction for HILLMAN

u_ds_datastore	ldsItem 
datastore	lu_DS

String	lsData,			&
			lsTemp,			&
			lsLogOut, 		&
			lsStringData
			
Integer	liRC,	&
			liFileNo
			
Long		llCount,				&
			llDefaultOwner,	&
			llOwner,				&
			llNew,				&
			llExist,				&
			llNewRow,			&
			llFileRowCount,	&
			llFileRowPos, 	&
			llLen

decimal ldTemp

Boolean	lbNew,	&
			lbError

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
	lsLogOut = "-       ***Unable to Open Item Master File for HILLMAN Processing: " + asPath
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

//Retrieve default Owner to be used for new items where we are defaulting to SS (not presnt in File)
//Owner defaults to owner ID created for Supplier HILLMAN
Select owner_id into :llDefaultOwner
From Owner
Where project_id = :asProject and owner_type = 'S' and Owner_cd = 'HILLMAN';
			
//Process each Row
llFileRowCOunt = lu_ds.RowCount()

For llfileRowPos = 1 to llFileRowCOunt
	
	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	
	//Check for Valid length of IM record 
	llLen = Len(lu_ds.GetItemString(llFileRowPos,'rec_data'))
	If llLen < 299  or llLen > 299 Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Record length error. is:" + string(llLen) + ", Should be: 299. Record will not be processed.")
		lbError = True
		Continue /*Next record */
	End If 
	
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))
	
	//Validate Rec Type is IM
	lsTemp = Left(lsData,2)
	If lsTemp <> 'IM' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If
	
	//Remove any previous filter
	ldsItem.SetFilter('')
	ldsItem.Filter()
		
	//SKU
	lsTemp = mid(lsdata,13,50)
	If lsTemp = "" Then /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'SKU' field. Record will not be prcessed.")
		Return -1
	End If

	llCount = ldsItem.Retrieve(asProject, lsTemp)
	If llCount = 0 Then
		llNew ++ /*add to new count*/
		lbNew = true
		ldsItem.InsertRow(0)
		ldsItem.SetItem(1,'project_id',asProject)	//Project ID (Default:Hillman)				
		ldsItem.SetItem(1,'SKU',lsTemp)
		ldsItem.SetItem(1,'supp_code',"HILLMAN")					//SKU (Default:Hillman)
	Else 
		llExist ++ /*add to existing Count*/		
	End If

	//Update any record defaults
	ldsItem.SetItem(1,'Last_user','SIMSFP')
	ldsItem.SetItem(1,'last_update',today())
	ldsItem.SetItem(1,'owner_id',llDefaultOwner) 			//HILLMAN Code 115229
	ldsItem.SetItem(1,'country_of_origin_default',"XXX")	//Country of Origin (default XXX)

	//Description
	lsTemp = mid(lsdata,94,70)
	If lsTemp = "" then  /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'Description' field. Record will not be prcessed.")
		Return -1
	End If
	ldsItem.SetItem(1,'Description',lsTemp)

	//base UOM maps to UOM 1 
	lsTemp = mid(lsdata,164,4)
	If lsTemp = "" then  ldsItem.SetItem(1,'uom_1','EA') //default to EACH
	ldsItem.SetItem(1,'uom_1',lsTemp)

	//Net Length maps to Length 1
	lsTemp = mid(lsdata,168,9)
	If lsTemp = "" then  /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'Length1' field. Record will not be prcessed.")
		Return -1
	End If
	If isnumber(lsTEmp) Then /*only map if numeric*/
		ldTemp = Dec(lsTemp) * .01
		ldsItem.SetItem(1,'Length_1',ldTemp)
	End If

	//Net Width maps to Width 1
	lsTemp = mid(lsdata,177,9)
	If lsTemp = "" then  /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'Width1' field. Record will not be prcessed.")
		Return -1
	End If
	If isnumber(lsTEmp) Then /*only map if numeric*/
		ldTemp = Dec(lsTemp) * .01
		ldsItem.SetItem(1,'Width_1',ldTemp)
	End If

	//Net Height maps to Height 1
	lsTemp = mid(lsdata,186,9)
	If lsTemp = "" then  /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'Height1' field. Record will not be prcessed.")
		Return -1
	End If
	If isnumber(lsTEmp) Then /*only map if numeric*/
		ldTemp = Dec(lsTemp) * .01
		ldsItem.SetItem(1,'Height_1',ldTemp)
	End If

	//Net Weight maps to Weight 1
	lsTemp = mid(lsdata,195,11)
	If lsTemp = "" then  /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'Weight1' field. Record will not be prcessed.")
		Return -1
	End If
	If isnumber(lsTEmp) Then /*only map if numeric*/
		ldTemp = Dec(lsTemp) * .00001
		ldsItem.SetItem(1,'weight_1',ldTemp)
	End If

	//base UOM maps to UOM 2 
	lsTemp = mid(lsdata,206,4)
	If lsTemp = "" then  ldsItem.SetItem(1,'uom_2','CASE') //default to CASE
	ldsItem.SetItem(1,'uom_2',lsTemp)

	//Net Length maps to Length 2
	lsTemp = mid(lsdata,210,9)
	If lsTemp = "" then  /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'Length2' field. Record will not be prcessed.")
		Return -1
	End If
	If isnumber(lsTEmp) Then /*only map if numeric*/
		ldTemp = Dec(lsTemp) * .01
		ldsItem.SetItem(1,'Length_2',ldTemp)
	End If

	//Net Width maps to Width 2
	lsTemp = mid(lsdata,219,9)
	If lsTemp = "" then  /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'Width2' field. Record will not be prcessed.")
		Return -1
	End If
	If isnumber(lsTEmp) Then /*only map if numeric*/
		ldTemp = Dec(lsTemp) * .01
		ldsItem.SetItem(1,'Width_2',ldTemp)
	End If

	//Net Height maps to Height 2
	lsTemp = mid(lsdata,228,9)
	If lsTemp = "" then  /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'Height2' field. Record will not be prcessed.")
		Return -1
	End If
	If isnumber(lsTEmp) Then /*only map if numeric*/
		ldTemp = Dec(lsTemp) * .01
		ldsItem.SetItem(1,'Height_2',ldTemp)
	End If

	//Net Weight maps to Weight 2
	lsTemp = mid(lsdata,237,11)
	If lsTemp = "" then  /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'Weight2' field. Record will not be prcessed.")
		Return -1
	End If
	If isnumber(lsTEmp) Then /*only map if numeric*/
		ldTemp = Dec(lsTemp) * .00001
		ldsItem.SetItem(1,'weight_2',ldTemp)
	End If
	
	//QTY 2 - Std Case QTY
	lsTemp = mid(lsdata,248,15)
	If lsTemp = "" then  /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'QTY 2' field. Record will not be prcessed.")
		Return -1
	End If
	If isnumber(lsTEmp) Then /*only map if numeric*/
		ldTemp = Dec(lsTemp) * .00001
		ldsItem.SetItem(1,'qty_2',ldTemp)
	End If

	//HS_Code - Harmonized tarrif code
	lsTemp = mid(lsdata,263,15)
	If lsTemp = "" then  /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'HARM/HS_Code' field. Record will not be prcessed.")
		Return -1
	End If
	ldsItem.SetItem(1,'HS_Code',lsTemp)

	//Freight Class 
	lsTemp = mid(lsdata,278,10)
	If lsTemp = "" then  /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'Freight Class' field. Record will not be prcessed.")
		Return -1
	End If
	ldsItem.SetItem(1,'Freight_Class',lsTemp)

	//UPC Code
	lsTemp = mid(lsdata,288,12)
	If lsTemp = "" then  /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + "Data expected at 'UPC Code' field. Record will not be prcessed.")
		Return -1
	End If
	If isnumber(lsTEmp) Then /*only map if numeric*/
		ldTemp = dec(lsTemp)
		ldsItem.SetItem(1,'Part_UPC_Code',ldTemp)
	End If

	//*** If we still have data after the last field, something is wrong with the record
//	If lsData > ' ' Then
//		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data found after expected last column. Record will not be processed.")
//		lbError = True
//		Continue /*Process Next Record */
//	End If
	
		//If record is new...
		/*If lbNew Then  // all turned off until customer asks for them to be turned on
			ldsItem.SetItem(1,'lot_controlled_ind','N') 
			ldsItem.SetItem(1,'po_controlled_ind','N') 
			ldsItem.SetItem(1,'serialized_ind','N')
			ldsItem.SetItem(1,'po_no2_controlled_ind','N')
			ldsItem.SetItem(1,'container_tracking_ind','N') 
		End If*/
	
	//Save NEw Item to DB
	lirc = ldsItem.Update()
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Master Record to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item Master Record to database!")
		//Return -1
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
end function

public function integer uf_process_po (string aspath, string asproject);Datastore	ldsPOHeader,	&
				ldsPODetail,	&
				lu_ds

String	lsLogout,				&
			lsStringData,			&
			lsOrder,					&
			lsWarehouse,			&
			lsArrivalDate,			&
			lsTemp,					&
			lsType

Integer	liFileNo,	&
			liRC

Long	llNewRow,			&
		llRowCount,			&
		llRowPos,			&
		llOrderSeq,			&
		llDetailSeq,		&
		llCount,				&
		llOwner,				&
		llFindRow, 	&
		llLen
		
Decimal	ldEDIBAtchSeq,	&
			ldPOQTY,			&
			ldLineNo
			
Boolean	lbError, lbPM, lbPD

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

//Retrieve default Owner to be used for new items where we are defaulting to SS (not presnt in File)
//Owner defaults to owner ID created for Supplier HILLMAN
Select owner_id into :llOwner
From Owner
Where project_id = :asProject and owner_type = 'S' and Owner_cd = 'HILLMAN';

//Process each row of the File
llRowCount = lu_ds.RowCount()
For llRowPos = 1 to llRowCount
	lbPD = false
	lbPM = false 
	
	//Check for Valid length of PM record (larger of both header and detail)
	llLen = Len(lu_ds.GetItemString(llRowPos,'rec_data'))
	If  llLen < 336  or llLen > 336 Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Record length error. is:" + string(llLen) + ", Should be: 336. Record will not be processed.")
		lbError = True
		Continue /*Next record */
	End If 
	
	//Validate Rec Type 
	lsType = Left(Trim(lu_ds.GetITemString(llRowPos,'rec_Data')),2)
	
 If lsType = 'PM' Then //Header info in the same records
	
	w_main.SetMicroHelp("Processing PM Inbound Master Record " + String(llRowPos) + " of " + String(llRowCount))  
	
	// See if we already have an order header , if not, create one
	lsOrder = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),14,30)) /*Order Number */

	/* Select count(*) into :llCount
	From Receive_master
	Where Project_id = :asProject and supp_invoice_no = :lsOrder and ord_status = 'N';

	If llcount <= 0 Then */
		
	// See if we already have a header, if not, create one
	If ldsPOHeader.Find("Order_no = '" + lsOrder + "'",1,ldsPoHeader.RowCount()) <= 0 Then	
		
		llNewRow = ldsPoHeader.InsertRow(0)
		lbPM = true	
	
		//Get the next available Seq #
		ldEDIBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
		If ldEDIBatchSeq < 0 Then
			Return -1
		End If	
	
		//Defaults
		ldsPOheader.SetITem(llNewRow,'wh_code',lsWarehouse) /*default WH for Project */
		ldsPOheader.SetITem(llNewRow,'project_id',asProject)
		ldsPOheader.SetITem(llNewRow,'action_cd','X') /*Default - will add/update an Order*/
		ldsPOheader.SetITem(llNewRow,'Request_date',String(Today(),'MMDDYYYY'))
		ldsPOheader.SetItem(llNewRow,'Order_type','S') /*Supplier Order*/
		ldsPOheader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
		ldsPOheader.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
		llOrderSeq = llNewRow /*header seq */
		ldsPOheader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
		ldsPOheader.SetItem(llNewRow,'ftp_file_name',asPath) /*FTP File Name*/
		ldsPOheader.SetItem(llNewRow,'Status_cd','N')
		ldsPOheader.SetItem(llNewRow,'Last_user','SIMSEDI')
		
		llDetailSeq = 0 /*detail seq within order for detail recs */	

		//Action Code
		lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),3,1))
		if lstemp <> "" then ldsPoHeader.SetITem(llNewRow,'action_cd',lsTemp)	
	
		//Order Number
		ldsPoHeader.SetITem(llNewRow,'order_no',lsOrder)
		
		//Supplier
		lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),44,10))
		ldsPoHeader.SetITem(llNewRow,'supp_code',lsTemp)

		//Delivery/Arrival Date - convert to format to mm/dd/yyyy
		lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),54,8))
		lsArrivalDate =  Mid(lsTemp,5,2)  + '/' +  Right(lsTemp,2)  + '/' + Left(lsTemp,4)
		ldsPoHeader.SetITem(llNewRow,'arrival_date',lsArrivalDate)
		
		//Carrier
		lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),72,10))
		ldsPoHeader.SetITem(llNewRow,'carrier',lsTemp)
		
		//Remarks
		lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),82,255))
		ldsPoHeader.SetITem(llNewRow,'remark',lsTemp)
	  
   End If /* No header for this ORder*/
	
 elseIf lsType = 'PD' Then //Insert Detail Row
	
	w_main.SetMicroHelp("Processing PD Inbound Detail Record " + String(llRowPos) + " of " + String(llRowCount))  

	// See if we have an order header for this detail record
	lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),3,30)) 
	if lsorder <> lsTemp  then // See if we have an order header for this detail record
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No PM Master found for this record. Record will not be processed.")
		lbError = True
		Continue /*Next record */			
	end if
	
	llNewRow = ldsPODetail.InsertRow(0)
	lbPD = true
	
	//Defaults
	ldsPODetail.SetItem(llNewRow,'project_id', asproject) /*project*/
	ldsPODetail.SetItem(llNewRow,'status_cd', 'N') 
	ldsPODetail.SetItem(llNewRow,'action_cd', 'A') /* 01/07 - PCONKL */
	ldsPODetail.SetItem(llNewRow,'Inventory_Type', 'N') 
	ldsPODetail.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
	ldsPODetail.SetItem(llNewRow,'order_seq_no',llORderSeq) 
	lLDetailSeq ++
	ldsPODetail.SetItem(llNewRow,"order_line_no",string(lLDetailSeq)) 
	ldsPODetail.SetItem(llNewRow,'owner_id',string(llOwner)) //OwnerID if Present	
	
	/*Order Number */
	ldsPODetail.SetItem(llNewRow,'order_no',lsorder)
	
	//Validate Line Item No for Numerics
	lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),33,6)) 
	If Not isnumber(lsTemp) Then
		ldLineNo = lLDetailSeq + 999
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - PO Line Number is not numeric. Line number has been set to: " + string(ldLineNo))
		lbError = True
		//Continue /*Next record */
	else
		ldLineNo = dec(lsTemp)
	end if
	ldsPODetail.SetItem(llNewRow,'line_Item_No',ldLineNo) 	
	
	/* SKU  */
	lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),39,50))
	ldsPODetail.SetITem(llNewRow,'sku', lsTemp) 

	//Validate QTY for Numerics
	lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),89,13))
	If Not isnumber(lsTemp) Then
		lsTemp = "0"
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - PO QTY is not numeric. Qty has been set to: " + lsTemp)
		lbError = True
	End If
	ldsPODetail.SetITem(llNewRow,'quantity',lsTemp)
	
 else // not a valid record type for this routine
  		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsType + "'. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
 End If

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

If lbError Then
	Return -1
Else
	Return 0
End If
end function

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

public function integer uf_process_or (ref string asinifile);
//GAP1203 Process the Hillman Order Replenishment Confirmation File

Datastore	ldsPOheader, 	&
				ldsPODetail, 	&
				ldsOut,			&
				ldsItems, 		&
				ldsContentSum, &
				ldsContent, 	&
				ldsReceive, 	&
				ldsDelivery
				
Long			llRowPos,		&
				llNewRow,		&
				llNewRowPM,		&
				llNewRowPD,		&
				llRowCount,		&
				llContentSum,	&
				llContent,		&
				llReceive,		&
				llDelivery,		&
				ll_found,		&
				llMAX,			&
				llMIN,			&
				llReOrderQTY, 	&
				llOpenQTY, 		&
				llOnOrderQTY, 	&	
				llOnHandQTY, 	&	
				llLineItemNO, 	&
				llOwner, 		&
				llDetailSeq, 	&
				llOrderSeq
				
String		lsOutString, 	&
				lsPostString, 	&
				lsSKU,			&
				lsFindSKU,		&
				lsMessage,		&
				lsSuppInvNo,	&
				lsWarehouse, 	&
				lsArrivalDate, &	
				lsproject, 		&
				lsNextRunDate,		&
				lsNextRunTime,		&
				lsRunFreq,			&
				lsDAyName,			&
				lsDaysToRun, 	&
				lslogout
				
DEcimal		ldBatchSeq, 	&
				ldEDIBAtchSeq,	&
				ldNextSeq, 		&
				ldTotal, 		&
				ldQTY1, 			&
				ldQTY2
			
Integer		liRC, 			&
				liYear, 			&
				liDay, 			&
				liMo
				
Boolean 		lbOnce, lbError

DateTime	ldtNextRunTIme
Date		ldtNextRunDate, ldtToday

lbOnce = false
llLineItemNO = 0
lsproject = 'HILLMAN'
			
//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run
//guidotest asinifile = "C:\Pb7devl\sims32dev\SIMS3FP.INI" 
lsNextRunDate = ProfileString(asIniFile,'HILLMAN','ORNEXTDATE','')
lsNextRunTime = ProfileString(asIniFile,'HILLMAN','ORNEXTTIME','')
lsDaysToRun = ProfileString(asIniFile,'HILLMAN','ORDAYSTORUN','') /*days of week to run*/

If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
 	Return 0
Else /*valid date*/
 	ldtNextRunTIme = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
 	If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
 		Return 0
 	End If
End If

//WE may skip certain days (weekends, etc.)
lsDAyName = Upper(DayName(Today()))
If pos(Upper(lsDaysToRun),lsDAyName) <=0 Then
	
	lsLogOut = Space(5) + "- SKIPPING FUNCTION: DAILY HILLMAN OR FILE - Not scheduled to run on this day of the week."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		
	Return 0
	
End If /*run for current day of week */

//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile,'HILLMAN','ORFREQ','')
If isnumber(lsRunFreq) Then
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile,'HILLMAN','ORNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
End If

lsLogOut =  ''
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut =  '- PROCESSING FUNCTION: HILLMAN OR File.'
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut =  ''
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsItems = Create Datastore
ldsItems.Dataobject = 'd_items'
lirc = ldsItems.SetTransobject(sqlca)

ldsContentSum = Create Datastore
ldsContentSum.Dataobject = 'd_hillman_content_summary'
lirc = ldsContentSum.SetTransobject(sqlca)

ldsContent = Create Datastore
ldsContent.Dataobject = 'd_hillman_Content'
lirc = ldsContent.SetTransobject(sqlca)

ldsReceive = Create Datastore
ldsReceive.Dataobject = 'd_hillman_Receive'
lirc = ldsReceive.SetTransobject(sqlca)

ldsDelivery = Create Datastore
ldsDelivery.Dataobject = 'd_hillman_Delivery'
lirc = ldsDelivery.SetTransobject(sqlca)

ldsPOheader = Create u_ds_datastore
ldsPOheader.dataobject= 'd_po_header'
ldsPOheader.SetTransObject(SQLCA)

ldsPOdetail = Create u_ds_datastore
ldsPOdetail.dataobject= 'd_po_detail'
ldsPOdetail.SetTransObject(SQLCA)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsMessage = "   ***Unable to retrive next available sequence number for HILLMAN OR confirmation."
	lsLogOut = Space(5) + '- ' + String(llRowCount) + lsMessage
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1
End If

//Retrive ISKUS from Item master 
llRowCount = ldsItems.Retrieve(lsProject) 
lsLogOut = Space(5) + '- ' + String(llRowCount) + ' Line Items Retrieved for processing.'
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

If llRowCount < 0 Then
	lsLogOut = Space(5) + "*** Unable to Retrieve Item Master records"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1
End If

//Load Data Stores with  OR Data
llContent = ldsContent.Retrieve(lsproject) 
llContentSum = ldsContentSum.Retrieve(lsproject) 
llDelivery = ldsDelivery.Retrieve(lsproject) 
llReceive = ldsReceive.Retrieve(lsproject) 

//Write the rows to the generic output table
For llRowPos = 1 to llRowCOunt
	
	llNewRow = ldsOut.insertRow(0)
	
	//SKU
	lsSKU = ldsItems.GetItemString(llRowPos,'sku')
	lsOutString = lsSKU + space(50 - len(lsSKU))
	lsFindSKU = "sku = '" + lsSKU + "'"
	
	// Calculate ON HAND QTY
	ldQTY1 = 0
	ldQTY2 = 0
	ldTotal = 0
	ll_found = ldsContent.Find(lsFindSKU,1, llContent)
	if ll_found > 0 then ldQTY1 = ldsContent.GetItemNumber(ll_found,'c_avail_qty')
	ll_found = ldsContentSum.Find(lsFindSKU,1, llContentSum)
	if ll_found > 0 then ldQTY2 = ldsContentSum.GetItemNumber(ll_found,'c_alloc_qty')	
	llOnHandQTY = ldQTY1 + ldQTY2
	ldTotal = llOnHandQTY * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')
	
	// Calculate Open Orders QTY
	ldQTY1 = 0
	ldTotal = 0
	ll_found = ldsDelivery.Find(lsFindSKU,1, llDelivery)
	if ll_found > 0 then ldQTY1 = ldsDelivery.GetItemNumber(ll_found,'c_req_qty')
	llOpenQTY = ldQTY1 + ldQTY2
	ldTotal = llOpenQTY * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')	
	
	// Calculate ON Order QTY
	ldQTY1 = 0
	ldQTY2 = 0
	ldTotal = 0
	ll_found = ldsReceive.Find(lsFindSKU,1, llReceive)	
	if ll_found > 0 then ldQTY1 = ldsReceive.GetItemNumber(ll_found,'c_req_qty')
	ll_found = ldsContentSum.Find(lsFindSKU,1, llContentSum)	
	if ll_found > 0 then ldQTY2 = ldsContentSum.GetItemNumber(ll_found,'c_sit_qty')	
	llOnOrderQTY = ldQTY1 + ldQTY2
	ldTotal = llOnOrderQTY * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')	

	// get min and Max from Reorder_point Table
	llMAX = 0
	llMIN = 0
	Select MAX_Supply_OnHand, MIN_ROP, ReOrder_QTY
	into :llMAX, :llMIN, :llReOrderQTY
	From Reorder_Point
	where sku = :lsSKU and supp_code = "HILLMAN";
	ldTotal = llMIN * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')
	ldTotal = llMAX * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')
	
	/* create a record when available QTY - requested qty drops below  the min_rop */
	If llMin > 0 and llReOrderQTY > 0 then
		
		ldTotal =  (llOnHandQTY + llOnOrderQTY) - llOpenQTY //Net QTY
		
		if ldTotal <= llMIN then //check to see if net quantity is less than Min ROP qty
		
			if lbOnce = false then // create PM header record Once!
				lbOnce = true
				
				//Warehouse defaulted from project master default warehouse - only need to retrieve once
				Select wh_code into :lsWarehouse
				From Project
				Where Project_id = :lsproject;

				//Retrieve default Owner to be used for new items where we are defaulting to SS (not presnt in File)
				//Owner defaults to owner ID created for Supplier HILLMAN
				Select owner_id into :llOwner
				From Owner
				Where project_id = :lsproject and owner_type = 'S' and Owner_cd = 'HILLMAN';

				llNewRowPM = ldsPOheader.InsertRow(0)
	
				//Get the next available Seq #
				sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldEDIBAtchSeq)
				If ldEDIBatchSeq < 0 Then
					lsMessage = "   ***Unable to retrive next available sequence number for HILLMAN OR confirmation."
					lsLogOut = Space(5) + '- ' + String(llRowPos) + lsMessage
					FileWrite(gilogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
					Return -1
				End If	
	
				//Header Defaults
				ldsPOheader.SetITem(llNewRowPM,'wh_code',lsWarehouse) /*default WH for Project */
				ldsPOheader.SetITem(llNewRowPM,'project_id',lsproject)
				ldsPOheader.SetITem(llNewRowPM,'action_cd','X') /*Default - will add/update an Order*/
				ldsPOheader.SetITem(llNewRowPM,'Request_date',String(Today(),'MMDDYYYY'))
				ldsPOheader.SetItem(llNewRowPM,'Order_type','S') /*Supplier Order*/
				ldsPOheader.SetItem(llNewRowPM,'Inventory_Type','N') /*default to Normal*/
				ldsPOheader.SetItem(llNewRowPM,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
				llOrderSeq = llNewRowPM /*header seq */
				ldsPOheader.SetItem(llNewRowPM,'order_seq_no',llOrderSeq) 
				ldsPOheader.SetItem(llNewRowPM,'ftp_file_name','OR') /*FTP File Name*/
				ldsPOheader.SetItem(llNewRowPM,'Status_cd','N')
				ldsPOheader.SetItem(llNewRowPM,'Last_user','SIMSEDI')
		
				llDetailSeq = 0 /*detail seq within order for detail recs */	

				/*Add header items to PM *********************/
				
				//Supplier Invoice no - Using Stored procedure to get next available RO_NO
				sqlca.sp_next_avail_seq_no(lsproject,'Receive_Master','RO_No',ldNextSeq)
				lsSuppInvNo = string(ldNextSeq,'000000')
				// lsSuppInvNo = string(this.uf_get_next_seq_no(lsproject,'Receive_Master','RO_No')
				If lsSuppInvNo = "" Then
					lsMessage = "   ***Unable to retrive next available sequence Supplier Invoice number for HILLMAN OR confirmation."
					lsLogOut = Space(5) + '- ' + String(llRowPos) + lsMessage
					FileWrite(gilogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/	
					Return -1
				End If			
				ldsPOheader.SetITem(llNewRowPM,'order_no',lsSuppInvNo)
				
				//Supplier
				ldsPOheader.SetITem(llNewRowPM,'supp_code','HILLMAN')
				
				//Delivery/Arrival Date - convert to format to mm/dd/yyyy and add one week
				liYear = Year(Today())
				liDay = Day(Today()) + 7
				liMo = Month(Today())
				ldtToday = Date ( liYear, liMo, liDay ) 
				lsArrivalDate =  string(ldtToday,'mm/dd/yyyy') 
				ldsPOheader.SetITem(llNewRowPM,'arrival_date',lsArrivalDate)

			end if
	//Create PD detail record ************************/
			llNewRowPD = ldsPODetail.InsertRow(0)
			
			//Defaults
			ldsPODetail.SetItem(llNewRowPD,'project_id', lsproject) /*project*/
			ldsPODetail.SetItem(llNewRowPD,'status_cd', 'N') 
			ldsPODetail.SetItem(llNewRowPD,'Inventory_Type', 'N') 
			ldsPODetail.SetItem(llNewRowPD,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
			ldsPODetail.SetItem(llNewRowPD,'order_seq_no',llORderSeq) 
			lLDetailSeq ++
			ldsPODetail.SetItem(llNewRowPD,"order_line_no",string(lLDetailSeq)) 
			ldsPODetail.SetItem(llNewRowPD,'owner_id',string(llOwner)) //OwnerID if Present	
			
			/*Order Number */
			ldsPODetail.SetItem(llNewRowPD,'order_no',lsSuppInvNo)
			
			/*Line Item Number */
			llLineItemNO ++
			ldsPODetail.SetItem(llNewRowPD,'line_Item_No',llLineItemNO) 	
	
			/* SKU  */
			ldsPODetail.SetITem(llNewRowPD,'sku', lsSKU) 
			
			// QTY 
			ldsPODetail.SetITem(llNewRowPD,'quantity',string(llReOrderQTY))
		/* end of detail items to PD ********************/
			
		/* create OR record *******************************************/
			//rec type OR = Order Replenishment Confirmation
			lsPostString = 'OR' 
			
			//Supplier Invoice no     
			lsPostString += lsSuppInvNo + space(30 - len(lsSuppInvNo))
			
			//Line Item No
			lsPostString += string(llLineItemNO,'000000')

			//concatenate poststring with outstring 
			lsOutString = lsPostString + lsOutString		
			
			//ReOrder QTY
			llReOrderQTY = llReOrderQTY * 100000 // 5 implied decimals
			lsOutString += string(llReOrderQTY,'000000000000000')

			// create EDI OUT record
			ldsOut.SetItem(llNewRow,'Project_id', lsproject)
			ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
			ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
			ldsOut.SetItem(llNewRow,'batch_data', lsOutString)			
		/* End of OR record ********************************************/			

		end if
		
	 end if 
	
next /*next output record */

//Save the changes to the generic output table - FP will write to flat file
If lbOnce = true Then
	liRC = ldsPOheader.Update()
	If liRC = 1 Then liRC = ldsPODetail.Update()
	If liRC = 1 Then liRC = ldsOut.Update()
	If liRC = 1 Then
		Commit;
		lsMessage = ' line items created for OR.'
		lsLogOut = Space(5) + '- ' + String(llLineItemNO) + lsMessage
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		
		//Set the next time to run if freq is set in ini file
		lsRunFreq = ProfileString(asIniFile,'HILLMAN','ORFREQ','')
		If isnumber(lsRunFreq) Then
			ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
			SetProfileString(asIniFile,'HILLMAN','ORNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
		Else
			SetProfileString(asIniFile,'HILLMAN','ORNEXTDATE','')
		End If

		Return 0
		
	Else
		lsMessage= SQLCA.SQLErrText
		if lsMessage = "" then lsMessage = ' Unable to save the changes to the generic output table.'
		Rollback;
		lsLogOut = Space(5) + '- ' + String(llRowCount) + lsMessage
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		Return -1	
	End If
else
		lsMessage = 'No Order Repleneshments needed at this time.'
		lsLogOut = Space(5) + '- ' + String(llRowCount) + lsMessage
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		Return -1	
End If


end function

public function integer uf_process_boh (string asinifile);
//GAP1203 Process the Hillman BOH File

Datastore	ldsOut,			&
				ldsItems, 		&
				ldsContentSum, &
				ldsContent, 	&
				ldsReceive, 	&
				ldsDelivery
				
Long			llRowPos,		&
				llNewRow,		&
				llRowCount,		&
				llContentSum,	&
				llContent,		&
				llReceive,		&
				llDelivery,		&
				ll_found,		&
				llMAX,			&
				llMIN,			&
				llReOrderQTY

String		lsOutString, 	&
				lsPostString, 	&
				lsSKU,			&
				lsFindSKU,		&
				lsMessage,		&
				lsproject, 		&
				lsNextRunDate,		&
				lsNextRunTime,		&
				lsRunFreq,			&
				lsDAyName,			&
				lsDaysToRun, 	&
				lslogout
				
DEcimal		ldBatchSeq, 	&
				ldEDIBAtchSeq,	&
				ldTotal, 		&
				ldQTY1, 			&
				ldQTY2
			
Integer		liRC

Boolean 		lbError

DateTime	ldtNextRunTIme
Date		ldtNextRunDate

lsproject = 'HILLMAN'
			
//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

lsNextRunDate = ProfileString(asIniFile,'HILLMAN','BOHNEXTDATE','')
lsNextRunTime = ProfileString(asIniFile,'HILLMAN','BOHNEXTTIME','')
lsDaysToRun = ProfileString(asIniFile,'HILLMAN','BOHDAYSTORUN','') /*days of week to run*/

If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
 	Return 0
Else /*valid date*/
 	ldtNextRunTIme = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
 	If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
 		Return 0
 	End If
End If

//WE may skip certain days (weekends, etc.)
lsDAyName = Upper(DayName(Today()))
If pos(Upper(lsDaysToRun),lsDAyName) <=0 Then
	
	lsLogOut = Space(5) + "- SKIPPING FUNCTION: DAILY HILLMAN BOH FILE - Not scheduled to run on this day of the week."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
	//Set the next time to run if freq is set in ini file
	lsRunFreq = ProfileString(asIniFile,'HILLMAN','BOHFREQ','')
	If isnumber(lsRunFreq) Then
		ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
		SetProfileString(asIniFile,'HILLMAN','BOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
	End If
	
	Return 0
	
End If /*run for current day of week */

lsLogOut =  ''
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut =  '- PROCESSING FUNCTION: HILLMAN BOH File.'
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut =  ''
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsItems = Create Datastore
ldsItems.Dataobject = 'd_items'
lirc = ldsItems.SetTransobject(sqlca)

ldsContentSum = Create Datastore
ldsContentSum.Dataobject = 'd_hillman_content_summary'
lirc = ldsContentSum.SetTransobject(sqlca)

ldsContent = Create Datastore
ldsContent.Dataobject = 'd_hillman_Content'
lirc = ldsContent.SetTransobject(sqlca)

ldsReceive = Create Datastore
ldsReceive.Dataobject = 'd_hillman_Receive'
lirc = ldsReceive.SetTransobject(sqlca)

ldsDelivery = Create Datastore
ldsDelivery.Dataobject = 'd_hillman_Delivery'
lirc = ldsDelivery.SetTransobject(sqlca)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(lsProject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;
If ldBatchSeq <= 0 Then
	lsMessage = "   ***Unable to retrive next available sequence number for HILLMAN BOH confirmation."
	lsLogOut = Space(5) + '- ' + String(llRowCount) + lsMessage
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1
End If

//Retrive ISKUS from Item master 
llRowCOunt = ldsItems.Retrieve(lsProject) 
lsLogOut = Space(5) + '- ' + String(llRowCount) + ' Line Items Retrieved for processing.'
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Load Data Stores with  BOH Data
llContent = ldsContent.Retrieve(lsProject) 
llContentSum = ldsContentSum.Retrieve(lsProject) 
llDelivery = ldsDelivery.Retrieve(lsProject) 
llReceive = ldsReceive.Retrieve(lsProject) 

//Write the rows to the generic output table
For llRowPos = 1 to llRowCOunt
	
	llNewRow = ldsOut.insertRow(0)
	
	//rec type = balance on Hand Confirmation
	lsOutString = 'BH' 
	
	//SKU
	lsSKU = ldsItems.GetItemString(llRowPos,'sku')
	lsOutString += lsSKU + space(50 - len(lsSKU))
	lsFindSKU = "Upper(sku) = '" + Upper(lsSKU) + "'"
	
	// Calculate ON HAND QTY
	ldQTY1 = 0
	ldQTY2 = 0
	ldTotal = 0
	ll_found = ldsContent.Find(lsFindSKU,1, llContent)
	if ll_found > 0 then ldQTY1 = ldsContent.GetItemNumber(ll_found,'c_avail_qty')
	ll_found = ldsContentSum.Find(lsFindSKU,1, llContentSum)
	if ll_found > 0 then ldQTY2 = ldsContentSum.GetItemNumber(ll_found,'c_alloc_qty')	
	ldTotal = ldQTY1 + ldQTY2
	ldTotal = ldTotal * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')
	
	// Calculate Open Orders QTY
	ldQTY1 = 0
	ldTotal = 0
	ll_found = ldsDelivery.Find(lsFindSKU,1, llDelivery)
	if ll_found > 0 then ldQTY1 = ldsDelivery.GetItemNumber(ll_found,'c_req_qty')
	ldTotal = ldQTY1 + ldQTY2
	ldTotal = ldTotal * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')	
	
	// Calculate ON Order QTY
	ldQTY1 = 0
	ldQTY2 = 0
	ldTotal = 0
	ll_found = ldsReceive.Find(lsFindSKU,1, llReceive)	
	if ll_found > 0 then ldQTY1 = ldsReceive.GetItemNumber(ll_found,'c_req_qty')
	ll_found = ldsContentSum.Find(lsFindSKU,1, llContentSum)	
	if ll_found > 0 then ldQTY2 = ldsContentSum.GetItemNumber(ll_found,'c_sit_qty')	
	ldTotal = ldQTY1 + ldQTY2
	ldTotal = ldTotal * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')	

	// get min and Max from Reorder_point Table
	llMAX = 0
	llMIN = 0
	Select MAX_Supply_OnHand, MIN_ROP 
	into :llMAX, :llMIN
	From Reorder_Point
	where sku = :lsSKU and supp_code = "HILLMAN";
	llMIN = llMIN * 100000 // 5 implied decimals
	lsOutString += string(llMIN,'000000000000000')
	llMAX = llMAX * 100000 // 5 implied decimals
	lsOutString += string(llMAX,'000000000000000')

	ldsOut.SetItem(llNewRow,'Project_id', lsProject)
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
next /*next output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,lsProject)

lsMessage = ' line items created for BOH.'
lsLogOut = Space(5) + '- ' + String(llNewRow) + lsMessage
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		
//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile,'HILLMAN','BOHFREQ','')
If isnumber(lsRunFreq) Then
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile,'HILLMAN','BOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile,'HILLMAN','BOHNEXTDATE','')
End If

Return 0


end function

on u_nvo_proc_hillman.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_hillman.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

