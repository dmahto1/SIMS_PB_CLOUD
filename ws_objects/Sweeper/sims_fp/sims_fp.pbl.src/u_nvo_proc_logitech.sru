$PBExportHeader$u_nvo_proc_logitech.sru
$PBExportComments$Process Logitech Files
forward
global type u_nvo_proc_logitech from nonvisualobject
end type
end forward

global type u_nvo_proc_logitech from nonvisualobject
end type
global u_nvo_proc_logitech u_nvo_proc_logitech

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsASNHeader,	&
				idsASNPackage,	&
				idsASNItem,		&
				iu_ds,			&
				idsDOAddress,	&
				idsDONotes


protected:
long	ilDefaultOwner
string isProject

end variables

forward prototypes
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_itemmaster (string aspath, string asproject)
public function integer uf_process_po (string aspath, string asproject)
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_boh (string asinifile)
public function integer uf_add_sku (string asproject, string assupplier, string assku)
public function integer uf_process_wo (string aspath, string asproject)
public function boolean uf_dovalidate (long arow, string asdata)
public function integer uf_dovalidatecritical (long arow, string asdata)
public function integer uf_processnewitemmaster (string asdata, ref datastore asdsitem)
public subroutine setdefaultowner (string asproject, string astype, string asownercode)
public function long getdefaultowner ()
public subroutine setproject (string asproject)
public function string getproject ()
public function integer uf_processexistingitemmaster (string asdata, ref datastore asdsitem, integer aicount)
public function string getcoo (string asdesignationcode)
end prototypes

public function integer uf_process_so (string aspath, string asproject);//GAP1103 - Process Sales Order files  (DM FILE)

//Datastore	ldsDOHeader,	&
//				iudsDODetail,	&
//				ldsDOAddress,	&
//				ldsDONotes,		&
//				lu_ds
				
String		lsLogout,lsRecData,lsTemp,lsRecType,lsOrder,lswarehouse,lsordertype, lsDate

String		lsName, lsAdd1, lsAdd2, lsAdd3, lsAdd4, lsDistrict, lsCity, lsState, lsZIP, lsCountry, lsTel, lsContact, &
				lsEmail, lsVatId, lsinventorytype, lsPriority, lsUF5, lsmessage, &
				lsaltaddress_type, lsaltname, lsaltaddress_1, lsaltaddress_2, lsaltaddress_3, &
				lsaltaddress_4, lsaltcity, lsaltdistrict, lsaltstate, lsaltcountry, lsaltalt_cust_code, &
 				lsaltcontact_person, lsalttel, lsaltzip, lsnotetype, lsnotetext

Integer		liFileNo,liRC

decimal 		ldTemp
				
Long			llRowCount,	llRowPos,llNewRow,llOrderSeq,	llBatchSeq,	llLineSeq,llCount, &
				llOwner,llTemp, llLen, llNewAddressRow, lllineitemno, llnoteseqno, llNewNotesRow
				
DateTime		ldtToday

Boolean		lbError, lbDM, lbDD

ldtToday = DateTime(today(),Now())
				
//lu_ds = Create datastore
//lu_ds.dataobject = 'd_generic_import'
//
//iudsDOHeader = Create u_ds_datastore
//iudsDOHeader.dataobject = 'd_shp_header'
//iudsDOHeader.SetTransObject(SQLCA)
//
//iudsDODetail = Create u_ds_datastore
//iudsDODetail.dataobject = 'd_shp_detail'
//iudsDODetail.SetTransObject(SQLCA)
//
////TAM Added Datastores for Address and Notes Entry
//iudsDOAddress = Create u_ds_datastore
//iudsDOAddress.dataobject = 'd_mercator_do_address'
//iudsDOAddress.SetTransObject(SQLCA)h
//
//idsDONotes = Create u_ds_datastore
//idsDONotes.dataobject = 'd_mercator_do_notes'
//idsDONotes.SetTransObject(SQLCA)

iu_ds.Reset()
idsDOHeader.Reset()
idsDODetail.Reset()
idsDOAddress.reset()
idsDONotes.REset()

//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Logitech Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	llNewRow = iu_ds.InsertRow(0)
	iu_ds.SetItem(llNewRow,'rec_data',lsRecData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

//Warehouse will have to be defaulted from project master default warehouse
Select wh_code into :lswarehouse
From Project
Where Project_id = :asProject;

//Get Default owner for Logitech (Supplier) in case we are creating any Non Consolidated FG to Inv Receive Detail records
Select owner_id into :llOwner
From OWner
Where project_id = :asProject and Owner_cd = 'LOGITECH' and owner_type = 'S';

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = iu_ds.RowCount()

//Process each Row
For llRowPos = 1 to llRowCount 

	lsRecData = iu_ds.GetITemString(llRowPos,'rec_data')
	lsRecType = Left(lsRecData,2)
	
	//Process header or Detail */
	Choose Case Upper(lsRecType)
			
		//HEADER RECORD
		Case 'DM' /* Header */
			
			w_main.SetMicroHelp("Processing DM Outbound Master Record " + String(llRowPos) + " of " + String(llRowCount))  
	
			llnewRow = idsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//Record Defaults
			idsDOHeader.SetItem(llNewRow,'Action_cd','A') /*Default - will add/update an Order*/
			idsDOHeader.SetITem(llNewRow,'project_id',asProject) /*Project ID*/
			idsDOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
			idsDOHeader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			idsDOHeader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
			idsDOHeader.SetItem(llNewRow,'Status_cd','N')
			idsDOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')

			//Delivery Order Type
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),3,4))
			If lsTemp = "" Then
				lsTemp = "S"
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Blank Delivery Order Type: " + lsTemp + "'.  Sims reset to 'S'.")
				lbError = True
			Else
				Select Code_ID into :lsOrderType
				From Lookup_Table
				Where Code_Descript = :lsTemp and
						Project_id = :asProject and 
    					Code_Type = 'DO' ;     
				If isNull(lsOrderType) Then 	// Error
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Ord Type' field. Record will not be processed.")
					Return -1
				Else
					If lsOrderType <> 'S' and lsOrderType <> 'P' Then
						gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Ord Type' field. Record will not be processed.")
						Return -1
					End If
				End if
			End If
			idsDOHeader.SetItem(llNewRow,'order_Type',lsOrderType)
			
			//Warehouse
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),7,10)) 
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'wh_code',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Delivery Warehouse: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			lswarehouse = lsTemp
			
			//Order Number
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),27,20)) 
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'invoice_no',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Delivery Order Number: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			lsOrder = lsTemp
			
			//Cust Code
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),47,20))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'cust_Code',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Customer Code: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If

			//Cust Order Number
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),67,20))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'order_no',lsTemp)
			End If

			//Supp Invoice No
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),87,30))
			If lsTemp <> "" Then
//				idsDOHeader.SetItem(llNewRow,'order_no',lsTemp)
			End If

			//Order_Date - convert to format to mm/dd/yyyy
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),117,8))
			If lsTemp <> "" Then
				lsDate = Left(lsTemp,4) + '/' + Mid(lsTemp,5,2)  + '/' +  Right(lsTemp,2) 
				idsDOHeader.SetItem(llNewRow,'ord_Date',lsDate)				
			Else /*error*/
				idsDOHeader.SetItem(llNewRow,'ord_Date',ldtToday)
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Order Date: " + lsTemp + ". Sims will replace with:" + string(ldtToday))
//				lbError = True
			End If

			//User Field 4
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),125,20))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'User_Field4',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid User Field 4: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If

			//User Field 2
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),145,10))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'User_Field2',lsTemp)
			End If

			//Priority
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),155,12))
			If lsTemp <> "" Then
				Select Code_ID into :lsPriority
				From Lookup_Table
				Where Code_Descript = :lsTemp and
						Project_id = :asProject and 
    					Code_Type = 'DP' ; 
			 
				If isNumber(lsPriority) Then 	// Error
					idsDOHeader.SetItem(llNewRow,'Priority',long(lsPriority))
				Else
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Priority' field. Record will not be processed.")
					lbError = True
					Continue /*Next Record */
				End if
			Else /*error*/
				idsDOHeader.SetItem(llNewRow,'Priority',10)
			End If

			//Carrier
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),167,50))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Carrier',lsTemp)
			End If

			//Service Level
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),217,10))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Transport_Mode',lsTemp)
			End If

			//User Field 5
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),227,20))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'User_Field5',lstemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Require Carrier Name was missing. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If

			//Freight Terms
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),247,20))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Freight_Terms',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Freight Terms: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If

			//User Field 3
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),267,10))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'User_field3',lsTemp)
			End If

			//User Field 6
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),277,20))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'User_Field6',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid User Field 6: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If

			//Shipping Instructions
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),297,255))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Shipping_Instructions_text',lsTemp)
			End If

			//Remark
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),552,250))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Remark',lsTemp)
			End If

			//Agent Info
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),802,30))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Agent_Info',lsTemp)
			End If
///////////
//  Position 802 contains a Cust code that is a duplicate from above
//////////
			
			//Cust Name
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),852,40))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Cust_Name',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Customer Name: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If

			//Address 1
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),892,40))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Address_1',lsTemp)
			End If

			//Address 2
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),932,40))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Address_2',lsTemp)
			End If

			//Address 3
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),972,40))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Address_3',lsTemp)
			End If

			//Address 4
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),1012,40))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Address_4',lsTemp)
			End If

			//City
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),1052,30))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'City',lsTemp)
			End If

			//District
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),1082,40))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'District',lsTemp)
			End If

			//State
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),1222,35))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'State',lsTemp)
			End If

			//Zip
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),1157,15))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Zip',lsTemp)
			End If

			//Country
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),1172,30))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Country',lsTemp)
			End If

			//Contact Person
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),1202,40))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Contact_Person',lsTemp)
			End If

			//Email
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),1242,50))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Email_Address',lsTemp)
			End If

			//Telephone
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),1292,20))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Tel',lsTemp)
			End If

			//VAT ID
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),1312,20))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Vat_Id',lsTemp)
			End If

			//OM Note Code Test
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),1332,255))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'OM_Note_Code_Test',lsTemp)
			End If

			//User Field 10
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),1587,50))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'User_Field10',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid User Field 10: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If

		Case 'DA' /* Address */
									
			lstemp = Trim(Mid(lsRecData,23,2)) /* Address Type */
			If lstemp > '' then
				lsaltaddress_type = lsTemp
			Else 
				lsaltaddress_type = ' '
			End If
			lstemp = Trim(Mid(lsRecData,25,20)) /* Location */
			If lstemp > '' then
				lsaltname = lsTemp
			Else 
				lsaltname = ' '
			End If
			lstemp = Trim(Mid(lsRecData,45,40)) /* Address 1 */
			If lstemp > '' then
				lsaltaddress_1 = lsTemp
			Else 
				lsaltaddress_1 = ' '
			End If
			lstemp = Trim(Mid(lsRecData,85,40)) /* Address 2 */
			If lstemp > '' then
				lsaltaddress_2 = lsTemp
			Else 
				lsaltaddress_2 = ' '
			End If
			lstemp = Trim(Mid(lsRecData,125,40)) /* Address 3 */
			If lstemp > '' then
				lsaltaddress_3 = lsTemp
			Else 
				lsaltaddress_3 = ' '
			End If
			lstemp = Trim(Mid(lsRecData,165,40)) /* Address 4 */
			If lstemp > '' then
				lsaltaddress_4 = lsTemp
			Else 
				lsaltaddress_4 = ' '
			End If
			lstemp = Trim(Mid(lsRecData,205,40)) /* City */
			If lstemp > '' then
				lsaltcity = lsTemp
			Else 
				lsaltcity = ' '
			End If
			lstemp = Trim(Mid(lsRecData,245,40)) /* District */
			If lstemp > '' then
				lsaltdistrict = lsTemp
			Else 
				lsaltdistrict = ' '
			End If
			lstemp = Trim(Mid(lsRecData,285,40)) /* State */
			If lstemp > '' then
				lsaltstate = lsTemp
			Else 
				lsaltstate = ' '
			End If
			lstemp = Trim(Mid(lsRecData,325,15)) /* Postal Code */
			If lstemp > '' then
				lsaltzip = lsTemp
			Else 
				lsaltzip = ' '
			End If
			lstemp = Trim(Mid(lsRecData,340,40)) /* Country */
			If lstemp > '' then
				lsaltcountry = lsTemp
			Else 
				lsaltcountry = ' '
			End If
			lstemp = Trim(Mid(lsRecData,3,20)) /* Alt Cust Code */
			If lstemp > '' then
				lsaltalt_cust_code = lsTemp
			Else 
				lsaltalt_cust_code = ' '
			End If
			lstemp = Trim(Mid(lsRecData,380,20)) /* Contact */
			If lstemp > '' then
				lsaltcontact_person = lsTemp
			Else 
				lsaltcontact_person = ' '
			End If
			lstemp = Trim(Mid(lsRecData,400,20)) /* Telephone */
			If lstemp > '' then
				lsalttel = lsTemp
			Else 
				lsalttel = ' '
			End If

			llNewAddressRow = idsDOAddress.InsertRow(0)
			idsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
			idsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
		
			idsDOAddress.SetItem(llNewAddressRow,'address_type',lsaltaddress_type) /* Address Type*/
			idsDOAddress.SetItem(llNewAddressRow,'Name',lsaltname) /* Name */
			idsDOAddress.SetItem(llNewAddressRow,'address_1',lsaltaddress_1) 
			idsDOAddress.SetItem(llNewAddressRow,'address_2',lsaltaddress_2) 
			idsDOAddress.SetItem(llNewAddressRow,'address_3',lsaltaddress_3) 
			idsDOAddress.SetItem(llNewAddressRow,'address_4',lsaltaddress_4) 
			idsDOAddress.SetItem(llNewAddressRow,'City',lsaltcity)
			idsDOAddress.SetItem(llNewAddressRow,'District',lsaltdistrict) 
			idsDOAddress.SetItem(llNewAddressRow,'State',lsaltstate)
			idsDOAddress.SetItem(llNewAddressRow,'Zip',lsaltzip) 
			idsDOAddress.SetItem(llNewAddressRow,'Country',lsaltcountry) 
			idsDOAddress.SetItem(llNewAddressRow,'Contact_person',lsaltcontact_person) 
			idsDOAddress.SetItem(llNewAddressRow,'tel',lsalttel) 

	
//	Insert Into Delivery_Alt_Address 
//	(project_id, edi_batch_seq_no, order_seq_no, address_type, name, address_1, address_2, address_3, address_4, city, District, state, zip, country, alt_cust_code, 
// 			Contact_person, tel) 
//	values (:asproject, :llbatchseq, :llorderseq, :lsaltaddress_type, :lsaltname, :lsaltaddress_1, :lsaltaddress_2, :lsaltaddress_3, 
//				:lsaltaddress_4, :lsaltcity, :lsaltdistrict, :lsaltstate, :lsaltzip, :lsaltcountry, :lsaltalt_cust_code, &
// 				:lsaltcontact_person, :lsalttel) ;
//			 
	
		// DETAIL RECORD
		Case 'DD' /*Detail */


			llnewRow = idsDODetail.InsertRow(0)
			llLineSeq ++
			
			//Add detail level defaults
			idsDODetail.SetITem(llNewRow,'project_id', asproject) /*project*/
			idsDODetail.SetITem(llNewRow,'status_cd', 'N') 
			idsDODetail.SetITem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDODetail.SetITem(llNewRow,'order_seq_no',llOrderSeq) 
			idsDODetail.SetITem(llNewRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			idsDODetail.SetITem(llNewRow,'Status_cd','N')
			idsDODetail.SetItem(llNewRow,'owner_id',string(llOwner)) //OwnerID if Present	
			idsDODetail.SetITem(llNewRow,'supp_code',"LOGITECH")  // Supplier
			
			
			//Order Number
			idsDODetail.SetItem(llNewRow,'invoice_no',lsorder)

			//Line Item Number - Validate Line Item No for Numerics
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),3,6)) 
			If isNumber(lsTemp) Then
				lllineitemno = Long(lsTemp)
				idsDODetail.SetItem(llNewRow,'line_item_no',Long(lsTemp))
			Else
				llTemp = llLineSeq + 999
				idsDODetail.SetItem(llNewRow,'line_item_no',Long(llTemp))
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - SO Line Number is not numeric. Line number has been set to: " + string(llTemp))
				lbError = True
			End If

			//User Field 1
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),9,20))
			If lsTemp <> "" Then
				idsDODetail.SetITem(llNewRow,'user_field1',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - Invalid User FIeld 1: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If			

			idsDODetail.SetItem(llNewRow,'user_field2',Trim(Mid(lsRecData,29,20))) /* User Field 2 */
			idsDODetail.SetItem(llNewRow,'user_field3',Trim(Mid(lsRecData,49,20))) /* User Field 3 */
				
			//SKU
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),69,50)) 
			If lsTemp <> "" Then
				idsDODetail.SetItem(llNewRow,'SKU',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - Invalid SKU: " + lsTemp + ". Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If

			idsDODetail.SetItem(llNewRow,'alternate_sku',Trim(Mid(lsRecData,119,50))) /* Alternate SKU */
			
			//Validate QTY for Numerics
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),169,15))
			If isnumber(lsTemp) Then
				idsDODetail.SetItem(llNewRow,'quantity',lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - SO QTY is not numeric." +  lsTemp + ". Record will not be processed.")
				lbError = True
			End If

			idsDODetail.SetItem(llNewRow,'UOM',Trim(Mid(lsRecData,184,4))) /* UOM */

			// Price
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),188,12)) 
			If isnumber(lsTEmp) Then /*only map if numeric*/
				idsDODetail.SetItem(llNewRow,'price',lsTemp)		
			else
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + "- Invalid Price: " + lsTemp + ". Record will not be processed.")
				lbError = True
			End If	
			
			//Currency Code
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),200,3))
			If lsTemp <> "" Then
				idsDODetail.SetItem(llNewRow,'User_Field6',lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + "- Invalid Currency Code: " + lsTemp + ". Record will not be processed.")
				lbError = True
			End If			
			
			//Inventory Type
			lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),203,2))
			If lsTemp <> "" Then
				Select Code_ID into :lsInventoryType
				From Lookup_Table
				Where Code_Descript = :lsTemp and
						Project_id = :asProject and 
  		  				Code_Type = 'SI' ;     
				If isNull(lsInventoryType) Then 	// Error
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Inventory Type' field. Record will not be processed.")
					lbError = True
				Else
					idsDODetail.SetItem(llNewRow,'user_field5',lsinventorytype)
					idsDODetail.SetItem(llNewRow,'inventory_type',lsinventorytype)
				End if
			Else
				// TAM   If they send a blank inventory Type default it to 'Z'
				// 09/07 - PCONKL - WE no longer want to default. The presence of an Inv TYpe will forceonly that type to be picked. THe absence will allow all pickable types to be picked
				
				//idsDODetail.SetItem(llNewRow,'inventory_type','Z')

			End If			

			idsDODetail.SetItem(llNewRow,'user_field4',Trim(Mid(lsRecData,205,30))) /* User Field 4 */
			idsDODetail.SetItem(llNewRow,'line_item_notes',Trim(Mid(lsRecData,235,255))) /* Line Item Notes */
	

			
			lsnotetype = Trim(Mid(lsRecData,490,2)) /* Note Type */
			lsnotetext = Trim(Mid(lsRecData,492,255)) /* Note Text */
			llnoteseqno = 1

// TAM added Detail Print Notes to Deliver Notes Table
			If not isNull(lsnotetext) Then
				
				llNewNotesRow = idsDONotes.InsertRow(0)
			
				//Defaults
				idsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
				idsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				idsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			
				idsDONotes.SetItem(llNewNotesRow,'line_item_no',llLineItemNo)
				idsDONotes.SetItem(llNewNotesRow,'note_seq_no',llnoteseqno)
				idsDONotes.SetItem(llNewNotesRow,'note_type',lsnotetype) 
				idsDONotes.SetItem(llNewNotesRow,'note_text',lsnotetext) 
			End If
//			Insert Into Delivery_Notes 
//			(project_id, edi_batch_seq_no, order_seq_no, line_item_no, note_seq_no, note_type, note_text) 
//			values (:asproject, :llbatchseq, :llorderseq, :lllineitemno, :llnoteseqno, :lsnotetype, :lsnotetext) ;
//			 

		Case Else /*Invalid rec type */
			
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue /*Next Record */
			
	End Choose /*Header or Detail */
	
Next /*file record */

//Save Changes
liRC = idsDOHeader.Update()
If liRC = 1 Then
	liRC = idsDODetail.Update()
End If

If liRC = 1 Then
	liRC = idsDOAddress.Update()
End If

If liRC = 1 Then
	liRC = idsDONotes.Update()
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

public function integer uf_process_itemmaster (string aspath, string asproject);//Process Item Master (IM) Transaction for Logitech

datastore	ldsItem, ldsitems
datastore	lu_DS
String		lsData
String		lsTemp
String		lsLogOut
String		lsStringData
Integer		liRC
Integer		liFileNo
Long			llCount
Long			llNew
Long			llExist
Long			llNewRow
Long			llFileRowCount
Long			llFileRowPos
Boolean 	lbError

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master_w_supp_cd'
ldsItem.SetTransObject(SQLCA)

// TAM 2006/07/17  Allow update of multiple Item masters for same SKU different Supplier
ldsItems = Create u_ds_datastore
ldsItems.dataobject= 'd_item_master'
ldsItems.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master File for LOGITECH Processing: " + asPath
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

setDefaultOwner( asProject , 'S', 	'LOGITECH'   )
setProject( asProject )

llFileRowCOunt = lu_ds.RowCount()

For llfileRowPos = 1 to llFileRowCOunt
	
	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	//
	// pvh - 07/26/05
	//
	// Validate general non showstopper data
	//
	if not uf_doValidate( llFileRowPos ,lu_ds.object.rec_data[ llFileRowPos ] ) then
		lberror = true
		continue
	end if
	
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))	
	// 
	// Validate showstopper data
	//
	if uf_doValidateCritical(  llFileRowPos ,  lsData  ) < 0 then return -1 // Critical data missing abort
	//
	// is the record new or existing?
	//
	// TAM 2006/07/17 If Supplier code is blank then substitute "LOGITECH" to check if SKU Exists.
	lsTemp = Trim( mid( lsdata ,73,20) ) 
	If lsTemp = "" Then lsTemp = "LOGITECH"

	//	llCount = ldsItem.Retrieve(asProject, Trim( mid( lsdata,13,50) ), Trim( mid( lsdata,73,20) )  )
	llCount = ldsItem.Retrieve(asProject, Trim( mid( lsdata,13,50) ), lstemp  )
	choose case llCount
		case is < 0
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " Retrieve Error: " + &
																string( sqlca.sqlcode ) + " Text: " + sqlca.sqlerrtext + " Process aborted!"  )
			return -1 // abort
			
		case 0 // New
			liRC = uf_processNewItemMaster( lsData, ldsItem )
			if liRC > 0 then llNew++
			
		case is > 0 // Update
// TAM 2006/07/17  Allow update of multiple Item masters for same SKU different Supplier
//			llCount = ldsItem.Retrieve(asProject, Trim( mid( lsdata,13,50) ), lstemp  )
//			liRC = uf_processExistingItemMaster( lsData, ldsItem, llCount  )
			llCount = ldsItems.Retrieve(asProject, Trim( mid( lsdata,13,50) ))
			liRC = uf_processExistingItemMaster( lsData, ldsItems, llCount  )
			if liRc > 0 then llExist++
//			llCount = ldsItem.Retrieve(asProject, Trim( mid( lsdata,13,50) ), 'LOGITECH'  )
//			if llCount > 0 then uf_processExistingItemMaster( lsData, ldsItem, llCount  )
			
	end choose
	
	if liRC < 0 then lbError = true

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

public function integer uf_process_po (string aspath, string asproject);//Datastore	ldsPOHeader,	&
//				ldsPODetail,	&
//				lu_ds

String	lsLogout,			&
			lsStringData,		&
			lsOrder,				&
			lsWarehouse,		&
			lsArrivalDate,		&
			lsTemp,				&
			lsType,				&
			lsDocType,			&
			lsOrderType,		&
			lsData,				&
			lsAction,			&
			lsSuppInvoiceNo,	&
			lsSuppCode,			&
			lsSuppOrderNo,		&
			lsUserField7, lsSuppName, lsAddress1, lsAddress2, lsAddress3, lsAddress4, lsCity, lsState, &
			lsZip, lsCountry, lsRoNo, lsLineNo, lsSKU, lsDescription, lsQty, lsUOM, lsInventoryType, &
			lsDetailAction, lsAWBBOL, lsCustomsDoc, lsUserField8, lsOrdDate, lsRequestDate, lserrtext, &
			lsNewOrder, lsremark, lsUserField1


Integer	liFileNo,			&
			liRC,					&
			liSkuAdd	

Long	llNewRow,			&
		llRowCount,			&
		llRowPos,			&
		llOrderSeq,			&
		llDetailSeq,		&
		llCount,				&
		llOwner,				&
		llFindRow, 			&
		llNewQty, 			&
		llAllocqty,       &
		llLen
		
Decimal	ldEDIBAtchSeq,	&
			ldPOQTY,			&
			ldLineNo
			
Boolean	lbError, lbPM, lbPD

DateTime	ldtToday

ldtToday = DateTime(Today(),Now())

//idsPOHeader = Create u_ds_datastore
//idsPOHeader.dataobject= 'd_po_header'
//idsPOHeader.SetTransObject(SQLCA)
//
//idsPODetail = Create u_ds_datastore
//idsPODetail.dataobject= 'd_po_detail'
//idsPODetail.SetTransObject(SQLCA)
//
//iu_ds = Create datastore
//iu_ds.dataobject = 'd_generic_import'

idsPOHeader.Reset()
idsPODetail.Reset()
iu_ds.Reset()

//Open and read the FIle In
lsLogOut = '      - Opening File for Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for LOGITECH Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//Retrieve default Owner to be used for new items where we are defaulting to SS (not presnt in File)
//Owner defaults to owner ID created for Supplier LOGITECH
Select owner_id into :llOwner
From Owner
Where project_id = :asProject and owner_type = 'S' and Owner_cd = 'LOGITECH';


//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = iu_ds.InsertRow(0)
	iu_ds.SetItem(llNewRow,'rec_data',lsStringData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Process each row of the File
llRowCount = iu_ds.RowCount()
For llRowPos = 1 to llRowCount
	lbPD = false
	lbPM = false 

	//Get Header or Detail type 
	lsData = iu_ds.GetItemString(llRowPos,'rec_data')
	lsType = Left(Trim(iu_ds.GetITemString(llRowPos,'rec_Data')),2)

	// If record is a Header record
	If lsType = 'PM' Then //Header info in the same records
	
		w_main.SetMicroHelp("Processing PM Inbound Master Record " + String(llRowPos) + " of " + String(llRowCount))  

		//Doc Type
		lsTemp = mid(lsdata,23,2)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Ord Type' field. Record will not be processed.")
			Return -1
		Else


//WOs are Removed from PO processing in Middleware
//			If lsTemp = 'W1' or lsTemp = 'W2' or lsTemp = 'W3' Then
//				Return 2 // Process Workorder
//			Else
				Select Code_ID into :lsOrderType
				From Lookup_Table
				Where Code_Descript = :lsTemp and
						Project_id = :asProject and 
    					Code_Type = 'RO' ;     
				If isNull(lsOrderType) Then 	// Error
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Ord Type' field. Record will not be processed.")
					Return -1
				Else
					If lsOrderType <> 'S' and lsOrderType <> 'X' and lsOrderType <>  'E' and lsOrderType <>  'I' Then
						gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Ord Type' field. Record will not be processed.")
						Return -1
					End If
				End if
//			End If
		End If

		//Warehouse
		lsTemp = mid(lsdata,3,10)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Warehouse' field. Record will not be processed.")
			Return -1
		Else
				lsWarehouse = lsTemp
		End If

		//Action
		lsTemp = mid(lsdata,25,1)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Action' field. Record will not be processed.")
			Return -1
		Else
			//Validate Action New, Update, or Delete
			If lsTemp <> 'N' and lsTemp <> 'U' and lsTemp <> 'D'  Then 	// Error
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Action' field. Record will not be processed.")
				Return -1
			Else
				If lstemp = 'N' Then
					lsAction = 'A'
				Else
					lsAction = lsTemp
				End If
			End if
		End If

		//Supplier Invoice No
		lsTemp = mid(lsdata,26,30)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Supplier Invoice No' field. Record will not be processed.")
			Return -1
		Else

			lsNewOrder = lsTemp
//			lsSuppInvoiceNo = lsTemp
		End If

		//Supplier Order No
		lsSuppOrderNo = mid(lsdata,56,16)

		//Vendor Site Code (User Field 7)
		lsTemp = mid(lsdata,92,30)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Vendor Site Code' field. Record will not be processed.")
			Return -1
		Else
			lsUserField7 = lsTemp
		End If
	
		//Supp Name
		lsSuppName = mid(lsdata,122,40)
		If isNull(lsSuppName) or lsSuppName < ' ' Then lssuppname = lsUserField7
		//Address 1
		lsAddress1 = mid(lsdata,162,40)
		//Address 2
		lsAddress2 = mid(lsdata,202,40)
		//Address 3
		lsAddress3 = mid(lsdata,242,40)
		//Address 4
		lsAddress4 = mid(lsdata,282,40)
		//City
		lsCity = mid(lsdata,322,30)
		//State
		lsState = mid(lsdata,352,35)
		//Zip
		lsZip = mid(lsdata,387,15)
		//Country
		lsCountry = mid(lsdata,402,30)
		//RoNo
		lsRoNo = mid(lsdata,432,16)

		//Supplier Code
		lsTemp = mid(lsdata,72,20)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Supplier Code' field. Record will not be processed.")
			Return -1
		Else
			lsSuppCode = lsTemp
			//Create a new Supplier 
			Select Count(*) into :llCount
			From Supplier
			Where Project_ID = :asproject and supp_code = :lsSuppCode;
	
			If llCount <= 0 Then
		
				Insert Into Supplier (project_id, Supp_code, Supp_Name, Address_1, Address_2, Address_3,
								Address_4, City, State, Zip, Country, LAst_USer, last_Update)
				Values 	(:asProject, :lsSuppCode, :lsSuppName, :lsAddress1, :lsAddress2, :lsAddress3, :lsAddress4,
							:lsCity, :lsState, :lszip, 'XXX', 'EDISIMS' , :ldtToday)
				Using SQLCA;
		
				If sqlca.sqlcode <> 0 Then
					lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
					Rollback;
					Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Supplier record to database!~r~r" + lsErrText)
					SetPointer(Arrow!)
					Return -1
				End If
		
			End If /*New Supplier Created */

		End If



	Else // Else Record is a detail

		//User Line Number and Ship Ref
		lsTemp = mid(lsdata,3,25)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'PO Line Number' field. Record will not be processed.")
			Return -1
		Else
			lsLineNo = lsTemp
			lsSuppInvoiceNo = trim(lsNewOrder) + "-" + Trim(lsTemp) // Append -LineNo for Uniqueness

		End If

			//Product Description
		lsDescription = mid(lsdata,78,70)

		//Validate QTY for Numerics
		lsTemp = Trim(Mid(lsData,148,15))
		If Not isnumber(lsTemp) Then
			lsQTY = "0"
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - PO QTY is not numeric. Qty has been set to: 0")
			lbError = True
		Else
			lsQty = lsTemp 
		End If

		//UOM
		lsTemp = Trim(Mid(lsData,163,4))
		If trim(lsTemp) = "" Then //Default EA
			lsUOM = "EA  "
		Else
			lsUOM = lsTemp 
		End If

		//SKU - After Other Fields are unloaded
			lsSku = mid(lsdata,28,50)

		// Expense POs send SKU's in the description field.  We send in the remark field
		If lsOrderType =  'E' Then
			lsremark = lsdescription
		Else	
			lsremark = ''
		End If

		If trim(lsSku) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'SKU' field. Record will not be processed.")
			Return -1
		Else

			
			Select Count(*) into :llCount
			From ITem_MAster
			Where Project_ID = :asproject and SKU = :lsSKU and supp_code = :lsSuppCode;
	
			//Create a new Item Master for this part Number
			If llCount <= 0 Then

				//Check if Logitech already has an Item Master set up form this part Number
				Select Count(*) into :llCount
				From ITem_MAster
				Where Project_ID = :asproject and SKU = :lsSKU and supp_code = 'LOGITECH';

				// If No Sku for logitech Then use the information available on the PO	
				If llCount <= 0 Then
		
					Insert Into Item_MAster (project_id, SKU, Supp_code, Description, Owner_id, Country_of_Origin_Default,
									UOM_1, Freight_Class, LAst_USer, last_Update)
					Values (:asProject, :lsSKU, :lsSuppCode, :lsDescription, :llOwner, 'XXX', :lsUOM, '', 'EDISIMS',:ldtToday)
					Using SQLCA;
		
					If sqlca.sqlcode <> 0 Then
						lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
						Rollback;
						gu_nvo_process_files.uf_writeError("Error saving Row: " + String(llRowPos) + " Unable to save new Item Master record to database!~r~r" + lsErrText)
						lbError = True
					End If

				Else
					If This.UF_add_Sku(asproject,lssuppcode,lssku) < 0 Then
						gu_nvo_process_files.uf_writeError("Error saving Row: " + string(llRowPos) + " Unable to save new Item Master record to database!~r~r")
						lbError = True
					End If 
				End If
			End If /*New ITem Created */
		End If
		
		
		
		//Validate Order Date
		lsTemp = Trim(Mid(lsData,167,8))
		If trim(lsTemp) = "" Then 
			lsOrdDate = "00000000"
		Else
			lsOrdDate = String(lsTemp, "@@@@/@@/@@") 
		End If

		//Validate Arrival Date
		lsTemp = Trim(Mid(lsData,175,8))
		If trim(lsTemp) = "" Then 
			lsArrivalDate = "00000000"
		Else
			lsArrivalDate = String(lsTemp, "@@@@/@@/@@") 
		End If

		//Validate Request Date
		lsTemp = Trim(Mid(lsData,183,8))
		If trim(lsTemp) = "" Then 
			lsRequestDate = String(Today(),'MMDDYYYY')
		Else
			lsRequestDate = String(lsTemp, "@@@@/@@/@@") 
		End If


		//Inventory Type
		lsTemp = mid(lsdata,191,2)
		If trim(lsTemp) = "" Then /*Default*/
// Default blanks to Z
			lsInventoryType = 'Z'
		Else
			Select Code_ID into :lsInventoryType
			From Lookup_Table
			Where Code_Descript = :lsTemp and
					Project_id = :asProject and 
    				Code_Type = 'SI' ;     
			If isNull(lsInventoryType) Then 	// Error
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Inventory Type' field. Record will not be processed.")
				lbError = True
			Else 
				lsUserField1 = lstemp
			End if
		End If

		//Detail Action
		lsTemp = mid(lsdata,193,1)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Detail Action' field. Record will not be processed.")
			Return -1
		Else
			//Header action always matches detail action because single line order
			//Validate Action New, Update, or Delete
			If lstemp = 'N' Then // Detail is New
				lsDetailAction = 'A'
				lsAction = 'A'	

			ElseIf lstemp = 'U' Then // Detail is Update
				// Check	if Order already exist
				Select Count(*) into :llCount
				From Receive_Master
				Where Project_ID = :asproject and supp_Invoice_no = :lsSuppInvoiceNo;
				If llCount > 0 Then
					lsDetailAction = 'U'
					lsAction = 'U'	

//// On Update we need to use the quantity Logitech sends on the PO rather than using the diffence of what they 
//// Requested and what is already allocated.  Therefor we need to add the Alloc qty back into the
//// Requested qty fot proper calculations in the U_NVO_Process_POs.
//				  
//				  SELECT sum(dbo.Receive_Detail.Alloc_Qty)  
//   	 			INTO :llAllocqty  
// 					FROM dbo.Receive_Master  ,   
//     	  					dbo.Receive_Detail
// 				  WHERE ( dbo.Receive_Master.RO_No = dbo.Receive_Detail.RO_No ) and  
//     				    ( ( dbo.Receive_Master.Supp_Invoice_No = :lsSuppInvoiceNo ) AND  
//         				( dbo.Receive_Detail.SKU = :lsSku ))   ;
//
//						If llAllocqty > 0 THen
//							llnewqty = llAllocqty + long(lsqty)
//							lsqty = string(llnewqty)
//						End If
//
				Else	
					lsDetailAction = 'A'
					lsAction = 'A'
				End If

			ElseIf lstemp = 'D' Then//Delete
				lsDetailAction = 'D'
				lsAction = 'B'

			Else  //Bad
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Detail Action' field. Record will not be processed.")
				Return -1
			End If
		End If



		//AWB BOL
		lsAWBBOL = mid(lsdata,194,20)
		//Customs Doc
		lsCustomsDoc = mid(lsdata,214,20)
		//Hot Shipment Flag(User Field 9)
		lsUserField8 = mid(lsdata,234,30) 

	End If // End of Header/Detail Unload

	// If Record Is a Detail the write Header/Detail Combo to Datastore
	If lsType = 'PD' Then
			llNewRow = idsPOHeader.InsertRow(0)
			lbPM = true	
	
			//Get the next available Seq #
			ldEDIBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
			If ldEDIBatchSeq < 0 Then
				Return -1
			End If	
	
			idsPOHeader.SetITem(llNewRow,'wh_code',lsWarehouse) 
			idsPOHeader.SetITem(llNewRow,'project_id',asProject)
			idsPOHeader.SetITem(llNewRow,'action_cd',lsaction) 
			idsPOHeader.SetItem(llNewRow,'Order_No',lsSuppInvoiceNo) 
			idsPOHeader.SetITem(llNewRow,'Request_date',lsRequestDate) //From Detail
			idsPOHeader.SetITem(llNewRow,'Arrival_date',lsArrivalDate) //From Detail
			idsPOHeader.SetItem(llNewRow,'Order_type',lsOrderType) 
			idsPOHeader.SetItem(llNewRow,'Supp_Code',lsSuppCode) 
			idsPOHeader.SetItem(llNewRow,'Inventory_Type',lsInventoryType) 
			idsPOHeader.SetItem(llNewRow,'Ship_Ref',lsLineNo) 
			idsPOHeader.SetItem(llNewRow,'Supp_Order_No',lsSuppOrderNo)
			idsPOHeader.SetItem(llNewRow,'User_Field7',lsUserField7)
			idsPOHeader.SetItem(llNewRow,'User_Field8',lsUserField8)
			idsPOHeader.SetItem(llNewRow,'Customs_Doc',lsCustomsDoc)
			idsPOHeader.SetItem(llNewRow,'AWB_BOL_No',lsAWBBOL)
			idsPOHeader.SetItem(llNewRow,'remark',lsremark)
			
			idsPOHeader.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
			llOrderSeq = llNewRow /*header seq */
			idsPOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			idsPOHeader.SetItem(llNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			idsPOHeader.SetItem(llNewRow,'Status_cd','N')
			idsPOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')

			// Process the Detail Record
	
			w_main.SetMicroHelp("Processing PD Inbound Detail Record " + String(llRowPos) + " of " + String(llRowCount))  

			llNewRow = idsPODetail.InsertRow(0)
			lbPD = true
	
			idsPODetail.SetItem(llNewRow,'Order_No',lsSuppInvoiceNo) 
			idsPODetail.SetItem(llNewRow,'project_id', asproject) /*project*/
			idsPODetail.SetItem(llNewRow,'Inventory_Type', lsInventoryType) 
			idsPODetail.SetItem(llNewRow,'SKU', lsSku) 
			idsPODetail.SetItem(llNewRow,'Line_Item_No',long(lsLineNo)) 
			idsPODetail.SetItem(llNewRow,'Quantity', lsQty) 
			idsPODetail.SetItem(llNewRow,'UOM', lsUOM) 
			idsPODetail.SetItem(llNewRow,'Country_of_Origin', 'XXX') 
			idsPODetail.SetItem(llNewRow,'Action_Cd', lsDetailAction) 
			idsPODetail.SetItem(llNewRow,'User_Field1',lsUserField1)
			idsPODetail.SetItem(llNewRow,'status_cd', 'N') 
			idsPODetail.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
			idsPODetail.SetItem(llNewRow,'order_seq_no',llORderSeq) 
			idsPODetail.SetItem(llNewRow,"order_line_no",'1') //Only 1 detail Per PO
			idsPODetail.SetItem(llNewRow,'owner_id',string(llOwner)) //OwnerID if Present	
	End If
		
	//Save the Changes
	If lbPM  Then // do only if an update is attempted
	 	lirc = idsPOHeader.Update()
	 	If lbPD and liRC = 1 Then lirc = idsPODetail.Update()
		If liRC = 1 Then
				Commit;
		Else
				Rollback;
				lsLogOut = Space(17) + "- ***System Error!  Unable to Save new PO Records to database!"
				FileWrite(gilogFileNo,lsLogOut)
				gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new PO Records to database!")
			Return -1
		End If
	End if

Next //File Row
				

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

Boolean	lbOnce, lbError
lbOnce = false

Choose Case Upper(Left(asFile,2))
		
	Case 'IM' /*Item Master File*/
		
		liRC = uf_Process_ItemMaster(asPath, asProject)	
		
	Case 'PO' /*Processed PO File */
		
		liRC = uf_process_po(asPath, asProject)
		
		If liRC < 0 Then lbError = True
		
		//If liRC >= 0 Then
			liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
		//End If
		
		If lbError Then liRC = -1
		
	Case 'PW' /*Processed PW File */
		
		liRC = uf_process_Wo(asPath, asProject)
		If liRC >= 0 Then
			liRC = gu_nvo_process_files.uf_process_Workorder(asProject) 
		End If
		
	Case 'SO' /* Sales Order Files*/
		
		liRC = uf_process_so(asPath, asProject)
		
		If liRC < 0 Then lbError = True
		
		//Process any added SO's - 05/08 - Pconkl - do regardless of errors
		//If liRC >= 0 Then
			liRC = gu_nvo_process_files.uf_process_Delivery_order(asProject) 
		//End If
		
		If lbError Then liRC = -1

Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
end function

public function integer uf_process_boh (string asinifile);//GAP1203 Process the Hillman BOH File

Datastore	ldsOut,			&
				ldsBOH 		&
				
Long			llRowPos,		&
				llNewRow,		&
				llRowCount,		&
				llqty

String		lsOutString, 	&
				lsPostString, 	&
				lswarehouse,	&
				lsproject, 		&
				lstransdate,	&
				lsSKU,			&
				lsinvcode,		&
				lsMessage,		&
				lsNextRunDate,		&
				lsNextRunTime,		&
				lsRunFreq,			&
				lsDAyName,			&
				lsDaysToRun, 	&
				lsFileName, 	&
				lslogout
				
DEcimal		ldBatchSeq, 	&
				ldEDIBAtchSeq	&
			
Integer		liRC

Boolean 		lbError

DateTime	ldtNextRunTIme
Date		ldtNextRunDate

lsproject = 'LOGITECH'
lstransdate = string(today(),"yyyymmddhhmmss")			
//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

lsNextRunDate = ProfileString(asIniFile,'LOGITECH','BOHNEXTDATE','')
lsNextRunTime = ProfileString(asIniFile,'LOGITECH','BOHNEXTTIME','')
lsDaysToRun = ProfileString(asIniFile,'LOGITECH','BOHDAYSTORUN','') /*days of week to run*/

If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
 	Return 0
Else /*valid date*/
 	ldtNextRunTIme = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
 	If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
 		Return 0
 	End If
End If


lsLogOut =  ''
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut =  '- PROCESSING FUNCTION: LOGITECH BOH File.'
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut =  ''
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsBOH = Create Datastore
ldsBOH.Dataobject = 'd_logitech_BOH'
lirc = ldsBOH.SetTransobject(sqlca)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(lsProject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;
If ldBatchSeq <= 0 Then
	lsMessage = "   ***Unable to retrive next available sequence number for LOGITECH BOH confirmation."
	lsLogOut = Space(5) + '- ' + String(llRowCount) + lsMessage
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1
End If

//Retrive ISKUS from Item master 
llRowCount = ldsBOH.Retrieve(lsProject) 
lsLogOut = Space(5) + '- ' + String(llRowCount) + ' Line Items Retrieved for processing.'
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Write the rows to the generic output table
For llRowPos = 1 to llRowCOunt
	
	llNewRow = ldsOut.insertRow(0)
	
	//rec type = balance on Hand Confirmation
	lsOutString = 'IB' 

	// Warehouse
	lswarehouse= ldsBOH.GetItemString(llRowPos,'Wh_Code')
	lsOutString += lswarehouse + space(10 - len(lswarehouse))
	
	//Project
	lsOutString += lsproject + space(10 - len(lsproject))
		
	//Transaction_Date
	lsOutString += string(today(),'YYYYMMDDHHMMSS')
	
	//SKU
	lsSKU = ldsBOH.GetItemString(llRowPos,'sku')
	lsOutString += lsSKU + space(50 - len(lsSKU))

	//UOM
	lsOutString += 'EA  ' 
	
	//Quantity (On Hand)
	llqty =  ldsBOH.GetItemNumber(llRowPos,'c_avail_qty')
	//llqty = llqty * 100000 // Implied 5 decimals
	lsOutString += string(llqty,'0000000000.00000')

	//Allocated Quantity
	llqty =  ldsBOH.GetItemNumber(llRowPos,'c_alloc_qty')
//	llqty = llqty * 100000 // Implied 5 decimals
	lsOutString += string(llqty,'0000000000.00000')
	
	//Inventory Type (From lookup table)
	lsinvcode = ldsBOH.GetItemString(llRowPos,'Inventory_Code')
	lsOutString += lsinvcode + space(20 - len(lsinvcode))
	

	
	ldsOut.SetItem(llNewRow,'Project_id', lsProject)
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
//File name is IB + Counter 
	lsfilename = 'IB' + string(ldbatchseq,"0000000000") + '.DAT'
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)

	
next /*next output record */
//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,lsProject)

lsMessage = ' line items created for BOH.'
lsLogOut = Space(5) + '- ' + String(llNewRow) + lsMessage
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		
//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile,'LOGITECH','BOHFREQ','')
If isnumber(lsRunFreq) Then
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile,'LOGITECH','BOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile,'LOGITECH','BOHNEXTDATE','')
End If

Return 0


end function

public function integer uf_add_sku (string asproject, string assupplier, string assku);//Add new Item to Item Master for Logitech

datastore	ldsItem

String	lslogout

Integer	liRC	&
			
Long		llNew,		&
			llCount		&
			
Boolean	lberror

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master'
ldsItem.SetTransObject(SQLCA)
	
llCount = ldsItem.Retrieve(asProject, asSKU)
If llCount > 0 Then
						
	lirc = ldsItem.RowsCopy(1,1,Primary!,ldsItem,99999,Primary!) /*copy the existing Item to new */
	ldsItem.SetItem(ldsItem.RowCount(),'supp_code',asSupplier) /*update new item */
	ldsItem.SetItem(2,'Last_user','SIMSFP')
	ldsItem.SetItem(2,'last_update',today())
					
	liRC = ldsitem.Update()
	If liRC = 1 Then
		Commit;
	Else
		Rollback;
		lsLogOut =  "       ***System Error!  Unable to Save new item Master Records (Item Insert) to database "
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogOut)
//		Return -1
	End If
			
End If /*item exists for any supplier */

w_main.SetMicroHelp("")

lsLogOut = Space(10) + String(llNew) + ' Item Records were successfully added.'
FileWrite(gilogFileNo,lsLogOut)

Destroy ldsItem

Return 0

end function

public function integer uf_process_wo (string aspath, string asproject);//Datastore	ldsPOHeader,	&
//				ldsPODetail,	&
//				lu_ds

String	lsLogout,			& 
			lsStringData,		&
			lsOrder,				&
			lsWarehouse,		&
			lsArrivalDate,		&
			lsTemp,				&
			lsType,				&
			lsOrderType,		&
			lsData,				&
			lsAction,			&
			lsWorkOrderNo,	&
			lsSuppCode,			&
			lsSuppOrderNo,		&
			lsUF1, lsUF2, lsUF3, lsSuppName, lsAddress1, lsAddress2, lsAddress3, lsAddress4, lsCity, lsState, &
			lsZip, lsCountry, lsRoNo, lsLineNo, lsSKU, lsDescription, lsQty, lsUOM, lsInventoryType, &
			lsDetailAction, lsAWBBOL, lsCustomsDoc, lsUF8, lsOrdDate, lsRequestDate, lserrtext

Integer	liFileNo,			&
			liRC,					&
			liSkuAdd	

Long	llNewRow,			&
		llRowCount,			&
		llRowPos,			&
		llOrderSeq,			&
		llDetailSeq,		&
		llCount,				&
		llOwner,				&
		llFindRow, 	&
		llLen,				&
		lllineno
		
Decimal	ldEDIBAtchSeq,	&
			ldPOQTY,			&
			ldLineNo
			
Boolean	lbError, lbPM, lbPD

DateTime	ldtToday

ldtToday = DateTime(Today(),Now())

//ldsPOheader = Create u_ds_datastore
//ldsPOheader.dataobject= 'd_po_header'
//ldsPOheader.SetTransObject(SQLCA)
//
//idsPODetail = Create u_ds_datastore
//idsPODetail.dataobject= 'd_po_detail'
//idsPODetail.SetTransObject(SQLCA)
//
//iu_ds = Create datastore
//iu_ds.dataobject = 'd_generic_import'

idsPOheader.reset()
idsPODetail.Reset()
iu_ds.Reset()

//Open and read the FIle In
lsLogOut = '      - Opening File for Workorder Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for LOGITECH Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//Retrieve default Owner to be used for new items where we are defaulting to SS (not presnt in File)
//Owner defaults to owner ID created for Supplier LOGITECH
Select owner_id into :llOwner
From Owner
Where project_id = :asProject and owner_type = 'S' and Owner_cd = 'LOGITECH';


//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = iu_ds.InsertRow(0)
	iu_ds.SetItem(llNewRow,'rec_data',lsStringData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Process each row of the File
llRowCount = iu_ds.RowCount()
For llRowPos = 1 to llRowCount
	lbPD = false
	lbPM = false 

	//Get Header or Detail type 
	lsData = iu_ds.GetItemString(llRowPos,'rec_data')
	lsType = Left(Trim(iu_ds.GetITemString(llRowPos,'rec_Data')),2)

	// If record is a Header record
	If lsType = 'PM' Then //Header info in the same records
	
		w_main.SetMicroHelp("Processing PM Inbound Master Record " + String(llRowPos) + " of " + String(llRowCount))  

		//Doc Type
		lsTemp = mid(lsdata,23,2)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Ord Type' field. Record will not be processed.")
			Return -1
		Else
			lsUF3 = lsTemp  //User Field 3 = Doc Type
			Select Code_Descript  into :lsOrderType
			From Lookup_Table
			Where Code_ID = :lsTemp and
					Project_id = :asProject and 
    				Code_Type = 'WO' ;     
			If isNull(lsOrderType) Then 	// Error
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Ord Type' field. Record will not be processed.")
				Return -1
			Else
				If lsOrderType <> 'S' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Ord Type' field. Record will not be processed.")
					Return -1
				End If
			End if
		End If

		//Warehouse
		lsTemp = mid(lsdata,3,10)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Warehouse' field. Record will not be processed.")
			Return -1
		Else
				lsWarehouse = lsTemp
		End If

		//Action
		lsTemp = mid(lsdata,25,1)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Action' field. Record will not be processed.")
			Return -1
		Else
			//Validate Action New, Update, or Delete
			If lsTemp <> 'N' and lsTemp <> 'U' and lsTemp <> 'D'  Then 	// Error
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Action' field. Record will not be processed.")
				Return -1
			Else
				If lstemp = 'N' Then
					lsAction = 'A'
				Else
					lsAction = lsTemp
				End If
			End if
		End If

		//Workorder No
		lsTemp = mid(lsdata,26,30)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Workorder No' field. Record will not be processed.")
			Return -1
		Else
			lsWorkorderNo = lsTemp
		End If

//		//Supplier Order No
//		lsSuppOrderNo = mid(lsdata,56,16)
		//Supplier Code we use
		lsSuppCode= 'LOGITECH' 
		// Supplier Code they Send
		lsUF1 = mid(lsdata,72,20)
		//Vendor Site Code (User Field 2)
		lsUF2 = mid(lsdata,92,30)
		//Supp Name
		lsSuppName = mid(lsdata,122,40)
		//Address 1
		lsAddress1 = mid(lsdata,162,40)
		//Address 2
		lsAddress2 = mid(lsdata,202,40)
		//Address 3
		lsAddress3 = mid(lsdata,242,40)
		//Address 4
		lsAddress4 = mid(lsdata,282,40)
		//City
		lsCity = mid(lsdata,322,30)
		//State
		lsState = mid(lsdata,352,35)
		//Zip
		lsZip = mid(lsdata,387,15)
		//Country
		lsCountry = mid(lsdata,402,30)
		//RoNo
		lsRoNo = mid(lsdata,432,16)

	Else // Else Record is a detail

		//User Line Number and Ship Ref
		lsTemp = mid(lsdata,3,25)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'WO Line Number' field. Record will not be processed.")
			Return -1
		Else
			lsLineNo = lsTemp
			lsWorkorderNo = trim(lsWorkorderNo) + "-" + Trim(lsTemp) // Append "-" LineNo for Uniqueness
		End If

		//SKU - 
		lsSku = mid(lsdata,28,50)
		If trim(lsSku) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'SKU' field. Record will not be processed.")
			Return -1
		End if

		//Product Description
		lsDescription = mid(lsdata,78,70)

		//Validate QTY for Numerics
		lsTemp = Trim(Mid(lsData,148,15))
		If Not isnumber(lsTemp) Then
			lsQTY = "0"
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - WO QTY is not numeric. Qty has been set to: 0")
			lbError = True
		Else
			lsQty = lsTemp 
		End If

		//UOM
		lsTemp = Trim(Mid(lsData,163,4))
		If trim(lsTemp) = "" Then //Default EA
			lsUOM = "EA  "
		Else
			lsUOM = lsTemp 
		End If

	
		//Validate Order Date
		lsTemp = Trim(Mid(lsData,167,8))
		If trim(lsTemp) = "" Then 
			lsOrdDate = "00000000"
		Else
			lsOrdDate = String(lsTemp, "@@@@/@@/@@") 
		End If

		//Validate Arrival Date
		lsTemp = Trim(Mid(lsData,175,8))
		If trim(lsTemp) = "" Then 
			lsArrivalDate = "00000000"
		Else
			lsArrivalDate = String(lsTemp, "@@@@/@@/@@") 
		End If

		//Validate Request Date
		lsTemp = Trim(Mid(lsData,183,8))
		If trim(lsTemp) = "" Then 
			lsRequestDate = String(Today(),'YYYY/MM/DD')
		Else
			lsRequestDate = String(lsTemp, "@@@@/@@/@@") 
		End If


		//Inventory Type
		lsTemp = mid(lsdata,191,2)
		If trim(lsTemp) = "" Then /*Default*/
//TAM Default to Z
					lsInventoryType = 'Z'
		Else
			Select Code_ID into :lsInventoryType
			From Lookup_Table
			Where Code_Descript = :lsTemp and
					Project_id = :asProject and 
    				Code_Type = 'SI' ;     
			If isNull(lsInventoryType) Then 	// Error
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Inventory Type' field. Record will not be processed.")
				lbError = True
			End if
		End If

//		//Detail Action
//		lsTemp = mid(lsdata,193,1)
//		If trim(lsTemp) = "" Then /*error*/
//			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Detail Action' field. Record will not be processed.")
//			Return -1
//		Else
//			//Validate Action New, Update, or Delete
//			If lsTemp <> 'N' and lsTemp <> 'U' and lsTemp <> 'D'  Then 	// Error
//				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Detail Action' field. Record will not be processed.")
//				Return -1
//			Else
//				If lstemp = 'N' Then
//					lsDetailAction = 'A'
//				Else
//					lsDetailAction = lsTemp
//				End If
//			End if
//		End If
//
///////
		//Detail Action
		lsTemp = mid(lsdata,193,1)
		If trim(lsTemp) = "" Then /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Data expected at 'Detail Action' field. Record will not be processed.")
			Return -1
		Else
			//Header action always matches detail action because single line order
			//Validate Action New, Update, or Delete
			If lstemp = 'N' Then // Detail is New
				lsDetailAction = 'A'
				lsAction = 'A'	

			ElseIf lstemp = 'U' Then // Detail is Update
				// Check	if Order already exist
				Select Count(*) into :llCount
				From Workorder_Master
				Where Project_ID = :asproject and Workorder_Number = :lsWorkorderNo;
				If llCount > 0 Then
					lsDetailAction = 'U'
					lsAction = 'U'	
				Else	
					lsDetailAction = 'A'
					lsAction = 'A'
				End If

			ElseIf lstemp = 'D' Then//Delete
				lsDetailAction = 'D'
				lsAction = 'D'

			Else  //Bad
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid 'Detail Action' field. Record will not be processed.")
				Return -1
			End If
		End If
		
////////		
		//AWB BOL
		lsAWBBOL = mid(lsdata,194,20)
		//Customs Doc
		lsCustomsDoc = mid(lsdata,214,20)
		//Hot Shipment Flag(User Field 8)
		lsUF8 = mid(lsdata,234,30)

	End If // End of Header/Detail Unload

	// If Record Is a Detail the write Header/Detail Combo to Datastore
	If lsType = 'PD' Then
			llNewRow = idsPOHeader.InsertRow(0)
			lbPM = true	
	
			//Get the next available Seq #
			ldEDIBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
			If ldEDIBatchSeq < 0 Then
				Return -1
			End If	
	
			idsPOHeader.SetITem(llNewRow,'wh_code',lsWarehouse) 
			idsPOHeader.SetITem(llNewRow,'project_id',asProject)
			idsPOHeader.SetITem(llNewRow,'action_cd',lsaction) 
			idsPOHeader.SetItem(llNewRow,'Order_No',lsWorkorderNo) 
			idsPOHeader.SetITem(llNewRow,'Request_date',lsRequestDate) //From Detail
			idsPOHeader.SetITem(llNewRow,'Arrival_date',lsArrivalDate) //From Detail
			idsPOHeader.SetItem(llNewRow,'Order_type',lsOrderType) 
			idsPOHeader.SetItem(llNewRow,'Supp_Code',lsSuppCode) 
			idsPOHeader.SetItem(llNewRow,'Inventory_Type',lsInventoryType) 
			idsPOHeader.SetItem(llNewRow,'Ship_Ref',lsLineNo) 
//			idsPOHeader.SetItem(llNewRow,'Supp_Order_No',lsSuppOrderNo)
			idsPOHeader.SetItem(llNewRow,'User_field1',lsUF1) 
			idsPOHeader.SetItem(llNewRow,'USer_Field2',lsUF2)
			idsPOHeader.SetItem(llNewRow,'USer_Field3',lsUF3)
//			idsPOHeader.SetItem(llNewRow,'User_Field8',lsUF8)
//			idsPOHeader.SetItem(llNewRow,'Customs_Doc',lsCustomsDoc)
//			idsPOHeader.SetItem(llNewRow,'AWB_BOL_No',lsAWBBOL)
			
			idsPOHeader.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
			llOrderSeq = llNewRow /*header seq */
			idsPOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			idsPOHeader.SetItem(llNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			idsPOHeader.SetItem(llNewRow,'Status_cd','N')
			idsPOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')

			// Process the Detail Record
	
			w_main.SetMicroHelp("Processing PD Inbound Detail Record " + String(llRowPos) + " of " + String(llRowCount))  

			llNewRow = idsPODetail.InsertRow(0)
			lbPD = true


			idsPODetail.SetItem(llNewRow,'Order_No',lsWorkorderNo) 
			idsPODetail.SetItem(llNewRow,'project_id', asproject) /*project*/
			idsPODetail.SetItem(llNewRow,'Inventory_Type', lsInventoryType) 
			idsPODetail.SetItem(llNewRow,'SKU', lsSku) 
			idsPODetail.SetItem(llNewRow,'Line_Item_No',long(lsLineNo)) 
			idsPODetail.SetItem(llNewRow,'Quantity', lsQty) 
			idsPODetail.SetItem(llNewRow,'UOM', lsUOM) 
			idsPODetail.SetItem(llNewRow,'Country_of_Origin', 'XXX') 
			idsPODetail.SetItem(llNewRow,'Action_Cd', lsDetailAction) 
			idsPODetail.SetItem(llNewRow,'status_cd', 'N') 
			idsPODetail.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
			idsPODetail.SetItem(llNewRow,'order_seq_no',llORderSeq) 
			idsPODetail.SetItem(llNewRow,"order_line_no",'1') //Only 1 detail Per PO
			idsPODetail.SetItem(llNewRow,'owner_id',string(llOwner)) //OwnerID if Present	
			idsPODetail.SetItem(llNewRow,'User_field1', lsInventoryType) 
	End If
		
	//Save the Changes
	If lbPM  Then // do only if an update is attempted
	 	lirc = idsPOHeader.Update()
	 	If lbPD and liRC = 1 Then lirc = idsPODetail.Update()
		If liRC = 1 Then
				Commit;
		Else
				Rollback;
				lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Workorder Records to database!"
				FileWrite(gilogFileNo,lsLogOut)
				gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Workorder Records to database!")
			Return -1
		End If
	End if

Next //File Row
				

If lbError Then
	Return -1
Else
	Return 0		
End If
end function

public function boolean uf_dovalidate (long arow, string asdata);//	boolean = uf_doValidate( long arow , string asData ) then continue

string lsData
string lsTemp

//Check for Valid length of IM record 
If Len( asdata) > 559 Then
	gu_nvo_process_files.uf_writeError("Row: " + string( arow ) + " - Record length error. is:" + string(Len( asdata)) + ", Should be no greater than: 559. Record will not be processed.")
	return false
End If 
	
lsData = Trim( asdata )
	
//Validate Rec Type is IM
lsTemp = Left(lsData,2)
If lsTemp <> 'IM' Then
	gu_nvo_process_files.uf_writeError("Row: " + string( arow ) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
	return false
End If
		
//SKU
lsTemp = mid(lsdata,13,50)
If trim(lsTemp) = "" Then /*error*/
	gu_nvo_process_files.uf_writeError("Row: " + string( arow ) + " Data expected at 'SKU' field. Record will not be prcessed.")
	return false
End If

return true

end function

public function integer uf_dovalidatecritical (long arow, string asdata);//	integer = uf_doValidateCritical( long arow , string asData ) 

// place critical - showstopper validation here


string lsTemp
integer failure = -1
integer success = 0
string lsMessageBegin
string lsMessageEnd

lsMessageBegin = "Row: " + string( arow ) + " Data expected at ~'"
lsMessageEnd = "~' field. Process Aborted."

//Description
lsTemp = mid( asdata ,171,70)
If trim(lsTemp) = "" then  /*error*/
	gu_nvo_process_files.uf_writeError( lsMessageBegin + "Description" + lsMessageEnd )
	return failure
End If

//Standard Cost
lsTemp = mid( asdata ,241,12)
If Trim(lsTemp) = "" then  /*error*/
	gu_nvo_process_files.uf_writeError( lsMessageBegin + "Std_Cost" + lsMessageEnd )
	return failure
End If

//User Field 9
lsTemp = mid( asdata ,484,30)
If Trim(lsTemp) = "" then  
	gu_nvo_process_files.uf_writeError( lsMessageBegin + "User Field 9" + lsMessageEnd )
	Return failure
End If

// GRP
lsTemp = mid( asdata ,524,10)
If Trim(lsTemp) = "" then  
	gu_nvo_process_files.uf_writeError( lsMessageBegin + "GRP" + lsMessageEnd )
	Return failure
End If

// Item Delete Ind
lsTemp = mid( asdata ,534,1)
If Trim(lsTemp) = "" then  
	gu_nvo_process_files.uf_writeError( lsMessageBegin + "Item Delete Ind" + lsMessageEnd )
	Return failure
End If

return success


end function

public function integer uf_processnewitemmaster (string asdata, ref datastore asdsitem);// integer = uf_processNewItemMaster( string asData, asdsItem )

int 			liRc
long 			newrow
long 			newrow2
string 		lsTemp
string 		lsProject
string 		ls_coo_2, ls_coo_3
decimal		ldtemp
boolean 	lbnew
long 			llcount
string 		lsCountryCode
string		lsLogOut
datastore 	ldsLogitechItem

ldsLogitechItem = Create u_ds_datastore
ldsLogitechItem.dataobject= 'd_item_master_w_supp_cd'
ldsLogitechItem.SetTransObject(SQLCA)

newrow = asdsItem.InsertRow(0)

// set defaults

asdsItem.SetItem( newrow , 'project_id' ,  getProject()  )
asdsItem.SetItem( newrow , 'SKU', mid( asdata,13,50) )								
asdsItem.SetItem( newrow , 'lot_controlled_ind','Y') 
asdsItem.SetItem( newrow , 'po_controlled_ind','Y') 
asdsItem.SetItem( newrow , 'serialized_ind','N')
asdsItem.SetItem( newrow , 'po_no2_controlled_ind','N')
asdsItem.SetItem( newrow , 'container_tracking_ind','N')
asdsItem.SetItem( newrow , 'Standard_of_measure','M')
asdsItem.SetItem( newrow , 'expiration_controlled_ind','Y')
asdsItem.SetItem( newrow , 'owner_id', getDefaultOwner() ) 	
asdsItem.SetItem( newrow , 'Last_user','SIMSFP')
asdsItem.SetItem( newrow , 'last_update',today())
asdsItem.SetItem( newrow ,'User_Field9',  mid( asData,484,30 ) ) // User Field 9
asdsItem.SetItem( newrow ,'Item_Delete_Ind', mid(asData,534,1) ) // Item Delete Ind
asdsItem.SetItem( newrow ,'Description', mid(asData,171,70) ) // Description

//Supplier Code
lsTemp = Trim( mid( asdata ,73,20) )
If lsTemp = "" Then
	asdsItem.SetItem( newrow , 'supp_code',"LOGITECH")
else
	asdsItem.SetItem( newrow , 'supp_code', lsTemp )
end if

//Country Of Origin  *** Up to 3 COOs can come in here.  Put the other 2 into User Fields 1 and 2
lsTemp = mid(asData,163,8)
If trim(lsTemp) = "" Then 
	asdsItem.SetItem( newrow ,'country_of_origin_default',"XXX")	//Country of Origin (default XXX)
Else
	// Get 1st char country code	
	lsCountrycode = getCOO(  left( lsTemp, 2 )  )
	asdsItem.SetItem( newrow ,'country_of_origin_default', lsCountrycode )
	asdsItem.SetItem( newrow ,'User_Field1','') // Always reset User Fields 1 and 2 when COO Changes
	asdsItem.SetItem( newrow ,'User_Field2','')

	// Get 2nd 3 char country code		
	If Trim(Mid(lsTemp,4,2)) <> "" then
		lsCountrycode = getCOO(   Trim(Mid(lsTemp,4,2))  )
		asdsItem.SetItem( newrow ,'User_Field1', lsCountrycode )
	End If

	// Get 3rd 3 char country code		
	If Trim(Mid(lsTemp,7,2)) <> "" then
		lsCountrycode = getCOO(   Trim(Mid(lsTemp,7,2))  )
		asdsItem.SetItem( newrow ,'User_Field2', lsCountrycode )
	End If
end if

//Standard Cost
lsTemp = mid(asData,241,12)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'Std_Cost',ldTemp)
end If

//UOM 1 
lsTemp = mid(asData,253,4)
If trim(lsTemp) = "" then
	asdsItem.SetItem( newrow ,'uom_1','EA') //default to EACH
Else
	asdsItem.SetItem( newrow ,'uom_1',lsTemp)
End if

//Length 1
lsTemp = mid(asData,257,9)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'Length_1',ldTemp)
End If

//Width 1
lsTemp = mid(asData,266,9)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'Width_1',ldTemp)
End If

//Height 1
lsTemp = mid(asData,275,9)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'Height_1',ldTemp)
End If

//Weight 1
lsTemp = mid(asData,284,11)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'weight_1',ldTemp)
End If

//UOM 2 
lsTemp = mid(asData,295,4)
If Trim(lsTemp) > "" then  
	asdsItem.SetItem( newrow ,'uom_2',lsTemp)
End If

//Length 2
lsTemp = mid(asData,299,9)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'Length_2',ldTemp)
End If

//Width 2
lsTemp = mid(asData,308,9)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'Width_2',ldTemp)
End If

//Height 2
lsTemp = mid(asData,317,9)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'Height_2',ldTemp)
End If

//Weight 2
lsTemp = mid(asData,326,11)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'weight_2',ldTemp)
End If

//QTY 2
lsTemp = mid(asData,337,15)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'qty_2',ldTemp)
End If

//UOM 3 
lsTemp = mid(asData,352,4)
If trim(lsTemp) > "" Then
	asdsItem.SetItem( newrow ,'uom_3',lsTemp)
End If

//Length 3
lsTemp = mid(asData,356,9)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'Length_3',ldTemp)
End If

//Width 3
lsTemp = mid(asData,365,9)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'Width_3',ldTemp)
End If

//Height 3
lsTemp = mid(asData,374,9)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'Height_3',ldTemp)
End If

//Weight 3
lsTemp = mid(asData,383,11)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'weight_3',ldTemp)
End If

//QTY 3
lsTemp = mid(asData,394,15)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = Dec(lsTemp)
	asdsItem.SetItem( newrow ,'qty_3',ldTemp)
End If

//HS_Code - Harmonized tarrif code
lsTemp = mid(asData,409,15)
If Trim(lsTemp) > "" then  
	asdsItem.SetItem( newrow ,'HS_Code',lsTemp)
End If

//User Field 4 
lsTemp = mid(asData,424,10)
If Trim(lsTemp) > "" then  
	asdsItem.SetItem( newrow ,'User_Field4',lsTemp)
End If

//User Field 5 
lsTemp = mid(asData,434,10)
If Trim(lsTemp) > "" then  
	asdsItem.SetItem( newrow ,'User_Field5',lsTemp)
End If

//User Field 6 
lsTemp = mid(asData,444,20)
If Trim(lsTemp) > "" then  
	asdsItem.SetItem( newrow ,'User_Field6',lsTemp)
End If

//User Field 7 
lsTemp = mid(asData,464,20)
If Trim(lsTemp) > "" then  
	asdsItem.SetItem( newrow ,'User_Field7',lsTemp)
End If

//User Field 5 
lsTemp = mid(asData,514,10)
If Trim(lsTemp) > "" then  
	asdsItem.SetItem( newrow ,'User_Field5',lsTemp)
End If

//GRP 
lsProject = getProject()
lsTemp = mid(asData,524,10)

Select Count(*)  into :llCount
From Item_Group
Where Project_id = :lsProject and grp = :lsTemp;

If llCount > 0 Then
	asdsItem.SetItem( newrow ,'grp',lsTemp)
End If

// Finished goods flag assignment to ldTemp is missing
If trim(lstemp) = 'Y' Then // Finished Goods
	asdsItem.SetItem( newrow ,'Component_Ind', 'Y')
End If

//UPC Code
lsTemp = mid(asData,535,14)
If isnumber(lsTEmp) Then /*only map if numeric*/
	ldTemp = dec(lsTemp)
	asdsItem.SetItem( newrow ,'Part_UPC_Code',ldTemp)
End If

//Commodity Code 
lsTemp = mid(asData,549,10)
If lsTemp > "" then  
	asdsItem.SetItem( newrow ,'User_Field8',lsTemp)
End If
//
//  When we dynamically setup an item master record for a new 
//  SKU/supplier, we need to setup another item master record 
//  for the same SKU with Logitech  as the supplier.
//

if Upper( asdsItem.object.supp_code[  newrow ]  )  <> "LOGITECH" then
	if ldsLogitechItem.Retrieve(  getProject() , Trim( mid( asdata,13,50) ) , "LOGITECH"  ) > 0 then
		uf_ProcessExistingItemMaster( asData, ldsLogitechItem, ldsLogitechItem.rowcount()  )
	else
		newrow2 = asdsItem.insertrow( 0 )
		asdsItem.Object.data.primary[ NewRow2 ] = asdsItem.Object.data.primary[ newrow ]
		asdsItem.object.supp_code[ NewRow2 ] = "LOGITECH"
	end if
End If	
//
// Save New Item to DB
//
lirc = asdsItem.Update()
If liRC = 1 then
	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Master Record to database! " + "id= " + asdsItem.getItemstring( newrow , 'project_id'   ) + "SKU: " + asdsItem.getItemstring( newrow , 'SKU' )								
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item Master Record to database!")
	liRC = -1
End If
	
return liRc

end function

public subroutine setdefaultowner (string asproject, string astype, string asownercode);// setDefaultOwner( string asProject, string asType, string asOwnerCode )

//Retrieve default Owner to be used for new items where we are defaulting to SS (not presnt in File)
//Owner defaults to owner ID created for Supplier Logitech

Select owner_id into :ilDefaultOwner
From Owner
Where project_id = :asProject and owner_type = :asType and Owner_cd = :asOwnerCode;


end subroutine

public function long getdefaultowner ();return ilDefaultOwner
end function

public subroutine setproject (string asproject);// setProject( string asProject )
isProject = asProject

end subroutine

public function string getproject ();return isProject
end function

public function integer uf_processexistingitemmaster (string asdata, ref datastore asdsitem, integer aicount);// integer = uf_processexistingItemMaster( string asData, asdsItem, integer aiCount )
//
// There may be more than one row returned on the retrieve since we may add a 'Logitech' supplier code row
// when creating a new record
//
int 			liRc
long 			newrow
string 		lsTemp
string 		lsProject
string 		lsLogOut
decimal		ldtemp
boolean 	lbnew
long 			llcount
integer 		index
string 		lsCountryCode
string 		lsUom

for index = 1 to aiCount

	asdsItem.SetItem( index,'Last_user', 'SIMSFP' )
	asdsItem.SetItem( index,'last_update', today() )
	asdsItem.SetItem( index , 'Description', mid(asdata ,171,70) ) // Description
	asdsItem.SetItem( index ,'User_Field9', mid(asData,484,30) ) // User Field 9
	asdsItem.SetItem( index ,'Item_Delete_Ind', mid(asData,534,1) )// Item Delete Ind

	//Country Of Origin  *** Up to 3 COOs can come in here.  Put the other 2 into User Fields 1 and 2
	lsTemp = mid(asData,163,8)
	If trim(lsTemp) = "" Then 
		asdsItem.SetItem( index ,'country_of_origin_default',"XXX")	//Country of Origin (default XXX)
	Else
		// Get 1st char country code	
		lsCountrycode = getCOO(  left( lsTemp, 2 )  )
		asdsItem.SetItem( index ,'country_of_origin_default', lsCountrycode )
		asdsItem.SetItem( index ,'User_Field1','') // Always reset User Fields 1 and 2 when COO Changes
		asdsItem.SetItem( index ,'User_Field2','')
		// Get 2nd 3 char country code		
		If Trim(Mid(lsTemp,4,2)) <> "" then
			lsCountrycode = getCOO(   Trim(Mid(lsTemp,4,2))  )
			asdsItem.SetItem( index ,'User_Field1', lsCountrycode )
		End If
		// Get 3rd 3 char country code		
		If Trim(Mid(lsTemp,7,2)) <> "" then
			lsCountrycode = getCOO(   Trim(Mid(lsTemp,7,2))  )
			asdsItem.SetItem( index ,'User_Field2', lsCountrycode )
		End If
	end if
	
	// Standard Cost
		lsTemp = mid(asData,241,12)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'Std_Cost', ldTemp)
		End If
	
		// UOM 1 
		lsTemp = mid(asData,253,4)
		lsUom = Trim( asdsItem.object.uom_1[ index ] )
		if asdsItem.object.uom_1[ index ] <> lsTemp and len(  lsUom  )  = 0 then
			if len( trim( lsTemp )) = 0 then
				asdsItem.SetItem( index ,'uom_1','EA') //default to EACH
			else
				asdsItem.SetItem( index ,'uom_1',lsTemp)
			end if
		else
			asdsItem.object.uom_1[ index ] = lsTemp
		end if
		
	//Length 1
		lsTemp = mid(asData,257,9)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'Length_1',ldTemp)
		End If
	
	//Width 1
		lsTemp = mid(asData,266,9)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'Width_1',ldTemp)
		End If
	
	//Height 1
		lsTemp = mid(asData,275,9)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'Height_1',ldTemp)
		End If
	
	//Weight 1
		lsTemp = mid(asData,284,11)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'weight_1',ldTemp)
		End If
	
	//UOM 2 
		lsTemp = mid(asData,295,4)
		If Trim(lsTemp) > "" then  
			asdsItem.SetItem( index ,'uom_2',lsTemp)
		End If
	
	//Length 2
		lsTemp = mid(asData,299,9)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'Length_2',ldTemp)
		End If
	
	//Width 2
		lsTemp = mid(asData,308,9)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'Width_2',ldTemp)
		End If
	
	//Height 2
		lsTemp = mid(asData,317,9)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'Height_2',ldTemp)
		End If
	
	//Weight 2
		lsTemp = mid(asData,326,11)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'weight_2',ldTemp)
		End If
		
	//QTY 2
		lsTemp = mid(asData,337,15)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'qty_2',ldTemp)
		End If
	
	//UOM 3 
		lsTemp = mid(asData,352,4)
		If trim(lsTemp) > "" Then
			asdsItem.SetItem( index ,'uom_3',lsTemp)
		End If
	
	//Length 3
		lsTemp = mid(asData,356,9)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'Length_3',ldTemp)
		End If
	
	//Width 3
		lsTemp = mid(asData,365,9)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'Width_3',ldTemp)
		End If
	
	//Height 3
		lsTemp = mid(asData,374,9)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'Height_3',ldTemp)
		End If
	
	//Weight 3
		lsTemp = mid(asData,383,11)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'weight_3',ldTemp)
		End If
		
	//QTY 3
		lsTemp = mid(asData,394,15)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = Dec(lsTemp)
			asdsItem.SetItem( index ,'qty_3',ldTemp)
		End If
		
	//HS_Code - Harmonized tarrif code
		lsTemp = mid(asData,409,15)
		If Trim(lsTemp) > "" then  
			asdsItem.SetItem( index ,'HS_Code',lsTemp)
		End If
	
	//User Field 4 
		lsTemp = mid(asData,424,10)
		If Trim(lsTemp) > "" then  
			asdsItem.SetItem( index ,'User_Field4',lsTemp)
		End If
	
	//User Field 5 
		lsTemp = mid(asData,434,10)
		If Trim(lsTemp) > "" then  
			asdsItem.SetItem( index ,'User_Field5',lsTemp)
		End If
	
	//User Field 6 
		lsTemp = mid(asData,444,20)
		If Trim(lsTemp) > "" then  
			asdsItem.SetItem( index ,'User_Field6',lsTemp)
		End If
	
	//User Field 7 
		lsTemp = mid(asData,464,20)
		If Trim(lsTemp) > "" then  
			asdsItem.SetItem( index ,'User_Field7',lsTemp)
		End If

	//User Field 5 
		lsTemp = mid(asData,514,10)
		If Trim(lsTemp) > "" then  
			asdsItem.SetItem( index ,'User_Field5',lsTemp)
		End If
	
	//GRP 
		
		lsProject  = getProject()
		
		lsTemp = mid(asData,524,10)
		Select Count(*)  into :llCount
		From Item_Group
		Where Project_id = :lsProject and grp = :lsTemp;
			
		If llCount > 0 Then
			asdsItem.SetItem( index ,'grp',lsTemp)
		End If
	
	//UPC Code
		lsTemp = mid(asData,535,14)
		If isnumber(lsTEmp) Then /*only map if numeric*/
			ldTemp = dec(lsTemp)
			asdsItem.SetItem( index ,'Part_UPC_Code',ldTemp)
		End If
	
	//Commodity Code 
		lsTemp = mid(asData,549,10)
		If lsTemp > "" then  
			asdsItem.SetItem( index ,'User_Field8',lsTemp)
		End If
next
//
// Save 
//
lirc = asdsItem.Update()
If liRC = 1 then
	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Master Record to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item Master Record to database!")
	liRC = -1
End If
return liRc

end function

public function string getcoo (string asdesignationcode);// string = getCOO( string asDesignation )

string returnValue

Select ISO_Country_Cd into :returnValue
From country
Where Designating_Code = :asDesignationCode;

If isnull( returnValue ) then
	returnValue = asDesignationCode
End If

return returnValue

end function

on u_nvo_proc_logitech.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_logitech.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
idsPOheader = Create u_ds_datastore
idsPOheader.dataobject= 'd_po_header'
idsPOheader.SetTransObject(SQLCA)

idsPOdetail = Create u_ds_datastore
idsPOdetail.dataobject= 'd_po_detail'
idsPOdetail.SetTransObject(SQLCA)

idsDOHeader = Create u_ds_datastore
idsDOHeader.dataobject = 'd_shp_header'
idsDOHeader.SetTransObject(SQLCA)

idsDODetail = Create u_ds_datastore
idsDODetail.dataobject = 'd_shp_detail'
idsDODetail.SetTransObject(SQLCA)

//TAM Added Datastores for Address and Notes Entry
idsDOAddress = Create u_ds_datastore
idsDOAddress.dataobject = 'd_mercator_do_address'
idsDOAddress.SetTransObject(SQLCA)

idsDONotes = Create u_ds_datastore
idsDONotes.dataobject = 'd_mercator_do_notes'
idsDONotes.SetTransObject(SQLCA)

iu_ds = Create datastore
iu_ds.dataobject = 'd_generic_import'
end event

