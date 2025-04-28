$PBExportHeader$u_nvo_proc_gm.sru
$PBExportComments$Process GM Files
forward
global type u_nvo_proc_gm from nonvisualobject
end type
end forward

global type u_nvo_proc_gm from nonvisualobject
end type
global u_nvo_proc_gm u_nvo_proc_gm

type variables

datastore	idsDOHeader, idsDODetail, idsDOAddress, idsDONotes, iu_ds
end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_set_carrier (ref datastore adsheader, ref datastore adsdetail)
public subroutine dodeleteordersubtypes (long index)
public function integer uf_fedex_interface_out (string asproject)
public function integer uf_fedex_interface_in (string aspath, string asproject, string asfile)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);// int = uf_process_files( string asProject, string asPath, string asFile, string asIniFile )
Integer			liRC
Boolean	lbError

Choose Case Upper(Left(asFile,2))
		
	Case 'FE' /*Fed Ex Interface*/

		liRC = uf_FedEx_Interface_In(asPath, asProject, asFile)	
		If liRC < 0 Then lbError = True

	Case Else /*SO*/
		liRC = uf_process_so(asPath, asProject)
		If liRC < 0 Then lbError = True

		//Process any added SO's
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		//If liRC >= 0 Then 
		liRC = 	gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
		If liRC < 0 Then lbError = True
		//End IF

End Choose

If lbError Then
	Return -1
Else
	Return 0
End If



end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for GM

//Datastore	ldsDOHeader, ldsDODetail, iu_ds, idsDOAddress, idsDONotes
				
String		lsLogout,lsRecData,lsTemp,	lsErrText, lsSKU, lsAddress1, lsAddress2, lsAddress3,	&
				lsAddress4, lsCity, lsState, lsCountry, lsZip, lsCustName, lsTel, lsContact,	&
				lsREcType, lsProject, lsAltSKU,ls_order, lsUF1

Integer		liFileNo,liRC,i
				
Long			llRowCount,	llRowPos,llNewRow, llNewHeaderRow,llNewDetailRow, llOrderSeq,	llBatchSeq,	llLineSeq,llCount,		&
				llLineItemNo, llNewAddressRow, llNewNotesRow,ll_find,ll_tot
	
Boolean		lbError

string		lsMsg

iu_ds.Reset()

idsdoHeader.SetTransObject(SQLCA)
idsdoDetail.SetTransObject(SQLCA)
idsdoAddress.SetTransObject(SQLCA)
idsdoNotes.SetTransObject(SQLCA)

idsdoHeader.Reset()
idsdoDetail.Reset()
idsdoAddress.reset()
idsdoNotes.Reset()

//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for GM Processing: " + asPath
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

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = iu_ds.RowCount()

//Process each Row
//The columns are delimited but fixed length as well, we can go by position
For llRowPos = 1 to llRowCount
	
	lsRecData = iu_ds.GetITemString(llRowPos,'rec_data')
	
	//If Record ID not 'ORDER' then Error
	If Upper(Left(lsRecData,5)) <> 'ORDER' Then
   		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record ID: '" + Left(lsRecData,5) + "'. Record will not be processed.")
		lbError = True
		Continue /*Next Record */
	End If
		
	//Process header, Detail or Notes */
	
	lsRecType = Mid(lsRecData,7,1) /*record Type*/
	
	Choose Case Upper(lsRecType)
			
		//HEADER RECORD
		Case 'H' /* Header */			
						
			llNewHeaderRow = idsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//Record Defaults
			idsDOHeader.SetItem(llNewHeaderRow,'ACtion_cd','A') /*always a new Order*/
			idsDOHeader.SetITem(llNewHeaderRow,'project_id',asProject) /*Project ID*/
			idsDOHeader.SetItem(llNewHeaderRow,'Inventory_Type','N') /*default to Normal*/
			idsDOHeader.SetItem(llNewHeaderRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDOHeader.SetItem(llNewHeaderRow,'order_seq_no',llOrderSeq) 
			idsDOHeader.SetItem(llNewHeaderRow,'ftp_file_name',aspath) /*FTP File Name*/
			idsDOHeader.SetItem(llNewHeaderRow,'Status_cd','N')
			idsDOHeader.SetItem(llNewHeaderRow,'Last_user','SIMSEDI')

			//The order type will be set as follows - may be updated to 3 or 4 after processing the detail lines
			// 1 - Single Line SO
			// 2 - Single Line OVN (sched Code)
			// 3 - Multi Line
			// 4 - Multi Line OVN
			
			If Trim(Mid(lsRecData,153,3)) = 'OVN' Then /*Overnight */
				idsDOHeader.SetItem(llNewHeaderRow,'order_Type','2') /* Default to Single Line Overnight */
			Else
				idsDOHeader.SetItem(llNewHeaderRow,'order_Type','1') /* Default to Single Line */
			End If
			
			//Order Number
			lsTemp = Trim(Mid(lsRecData,15,7))
			If lsTemp > '' Then	
				idsDOHeader.SetItem(llNewHeaderRow,'invoice_no',lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Order Number not present. Order will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			//Shipping Warehouse - will use to determine project and Warehouse in case we get feed for other GM Projects
			lsTemp = Trim(Mid(lsRecData,29,3))
			Choose Case lsTemp
				Case "663"
					idsDOHeader.SetITem(llNewHeaderRow,'project_id','GM_MI_DAT')
					lsProject = 'GM_MI_DAT'
					idsDOHeader.SetITem(llNewHeaderRow,'wh_Code','GM DETROIT')
				Case Else /*Invalid*/
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Shipping Facility: '" + lsTemp + "'. Order will not be processed.")
					lbError = True
					Continue /*Next Record */
			End Choose
									
			//Customer
			lsTemp = Trim(Mid(lsRecData,37,8))
			idsDOHeader.SetITem(llNewHeaderRow,'Cust_Code',lsTemp)
					
			// We will load the Customer Address into the Delivery Address and The Delivery Alt Address
			// If we receive an Alt Address or a Customer address in another rec type, we will overlay the DElivery Address.
			
			lsCustName = ''
			lsAddress1 = ''
			lsAddress2 = ''
			lsAddress3 = ''
			lsAddress4 = ''
			lsCity = ''
			lsState = ''
			lsZip = ''
			lsCountry = ''
			lsTel = ''
			lsContact = ''
			lsUF1 = ''
			
			Select Cust_Name, Address_1, address_2, address_3, address_4, city, state, zip, country,  tel, contact_person, user_field1
			Into	:lsCustName, :lsAddress1, :lsAddress2, :lsAddress3, :lsAddress4, :lsCity, :lsState, :lsZip, :lsCountry, :lsTel, :lsContact, :lsUF1
			From Customer
			Where Project_id = :lsProject and Cust_Code = :lsTemp;
			
			// 09/05 - PCONKL - We want to reject orders to customers affected by that bitch Katrina (indicator in User Field 1)
			If lsUF1 = 'Y' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Order Number: " + idsdoheader.GetITemString(llNewHeaderRow,'invoice_no') + &
															", Customer: " + lsTemp + " is not accepting shipments due to hurricane Katrina. Order will not be loaded in SIMS.")
				lbError = True
				Continue /*Next Record */
			End If
			
			//SPECIAL Ship to Address on Packing List
			idsDOHeader.SetItem(llNewHeaderRow,'Cust_Name',lsCustName)
			idsDOHeader.SetItem(llNewHeaderRow,'address_1',lsAddress1)
			idsDOHeader.SetItem(llNewHeaderRow,'address_2',lsAddress2)
			idsDOHeader.SetItem(llNewHeaderRow,'address_3',lsAddress3)
			idsDOHeader.SetItem(llNewHeaderRow,'address_4',lsAddress4)
			idsDOHeader.SetItem(llNewHeaderRow,'City',lsCity)
			idsDOHeader.SetItem(llNewHeaderRow,'State',lsState)
			idsDOHeader.SetItem(llNewHeaderRow,'Zip',lsZip)
			idsDOHeader.SetItem(llNewHeaderRow,'Country',lsCountry)
			idsDOHeader.SetItem(llNewHeaderRow,'Tel',lsTel)
			idsDOHeader.SetItem(llNewHeaderRow,'Contact_Person',lsContact)
			
			//We also want to build the Delivery Alt Address record - "NORMAL SHIP" on Packing Slip
			//If we later overlay the Delivery Address with an alt address, we will want the Delivery Address in the Alt field
			// If not, we will have the Delivery address in both places (confused yet?)
			llNewAddressRow = idsDOAddress.InsertRow(0)
			idsDOAddress.SetITem(llNewAddressRow,'project_id',lsProject) /*Project ID*/
			idsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			idsDOAddress.SetItem(llNewAddressRow,'address_type','NS') /* "Normal Ship To" Address */
			idsDOAddress.SetItem(llNewAddressRow,'Name',lsCustName)
			idsDOAddress.SetItem(llNewAddressRow,'address_1',lsAddress1)
			idsDOAddress.SetItem(llNewAddressRow,'address_2',lsAddress2)
			idsDOAddress.SetItem(llNewAddressRow,'address_3',lsAddress3)
			idsDOAddress.SetItem(llNewAddressRow,'address_4',lsAddress4)
			idsDOAddress.SetItem(llNewAddressRow,'City',lsCity)
			idsDOAddress.SetItem(llNewAddressRow,'State',lsState)
			idsDOAddress.SetItem(llNewAddressRow,'Zip',lsZip)
			idsDOAddress.SetItem(llNewAddressRow,'Country',lsCountry)
			idsDOAddress.SetItem(llNewAddressRow,'tel',lsTel)
						
			// ?? ORder Number - User Field 8
			idsDOHeader.SetItem(llNewHeaderRow,'User_Field8',Trim(Mid(lsRecData,63,9)))
			
			//Transport Mode
			idsDOHeader.SetItem(llNewHeaderRow,'Transport_Mode',Trim(Mid(lsRecData,123,5)))
			
			//Carrier
			idsDOHeader.SetItem(llNewHeaderRow,'Carrier',Trim(Mid(lsRecData,133,5)) + '/' + Trim(Mid(lsRecData,147,1))) //MA - Added UF1 to end of carrier.
			
			//Cust Channel  (Dealer, AC Delco, etc.) - UF 7
			idsDOHeader.SetItem(llNewHeaderRow,'User_Field7',Trim(Mid(lsRecData,143,3)))
			
			//Schedule Code 
			idsDOHeader.SetItem(llNewHeaderRow,'User_Field1',Trim(Mid(lsRecData,147,1)))
			
			//Freight Terms
			idsDOHeader.SetItem(llNewHeaderRow,'Freight_Terms',Trim(Mid(lsRecData,149,1)))
			
			//Ship VIA
			idsDOHeader.SetItem(llNewHeaderRow,'Ship_Via',Trim(Mid(lsRecData,153,3)))
			
			//Alt Ship to Ind - We'll use this to set the Ship address to Alt address if present
			lsTemp = Mid(lsRecData,157,1)
			idsDOHeader.SetITem(llNewHeaderRow,'User_Field4',lsTemp)
			
			If lsTemp = 'Y' then /* load Alt Address. If a particular address component is blank, clear DW column since we already loaded above*/
							
				//Cust Name
				If Trim(Mid(lsREcData,159,30)) > '' Then
					idsDOHeader.SetItem(llNewHeaderRow,'Cust_Name',Trim(Mid(lsREcData,159,30)))
				Else
					idsDOHeader.SetItem(llNewHeaderRow,'Cust_Name','')
				End If
				
				//Cust Address 1
				If Trim(Mid(lsREcData,190,30)) > '' Then
					idsDOHeader.SetItem(llNewHeaderRow,'Address_1',Trim(Mid(lsREcData,190,30)))
				Else
					idsDOHeader.SetItem(llNewHeaderRow,'Address_1','')
				End If
				
				//Cust Address 2
				If Trim(Mid(lsREcData,221,30)) > '' Then
					idsDOHeader.SetItem(llNewHeaderRow,'Address_2',Trim(Mid(lsREcData,221,30)))
				Else
					idsDOHeader.SetItem(llNewHeaderRow,'Address_2','')
				End If
			
				//Cust Address 3
				If Trim(Mid(lsREcData,252,30)) > '' Then
					idsDOHeader.SetItem(llNewHeaderRow,'Address_3',Trim(Mid(lsREcData,252,30)))
				Else
					idsDOHeader.SetItem(llNewHeaderRow,'Address_3','')
				End If
				
				//No Alt address 4
				idsDOHeader.SetItem(llNewHeaderRow,'Address_4','')
				
				//Cust City
				If Trim(Mid(lsREcData,283,28)) > '' Then
					idsDOHeader.SetItem(llNewHeaderRow,'City',Trim(Mid(lsREcData,283,28)))
				Else
					idsDOHeader.SetItem(llNewHeaderRow,'City','')
				End If
				
				//State
				
				// 12/04 - PCONKL - Validate against state table so we can get carrier from state table
				lsState = Trim(Mid(lsREcData,312,2))
				
				Select Count(*) into :llCount
				From State
				Where State_cd = :lsState;
				
				If llCount < 1 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Delivery Address State (header 312-313): '" + lsState + "'. Order will not be processed.")
					lbError = True
					Continue /*Next Record */
				End If
								
				If Trim(Mid(lsREcData,312,2)) > '' Then
					idsDOHeader.SetItem(llNewHeaderRow,'State',Trim(Mid(lsREcData,312,2)))
				Else
					idsDOHeader.SetItem(llNewHeaderRow,'State','')
				End If
				
				//Zip
				If Trim(Mid(lsREcData,315,10)) > '' Then
					idsDOHeader.SetItem(llNewHeaderRow,'Zip',Trim(Mid(lsREcData,315,10)))
				Else
					idsDOHeader.SetItem(llNewHeaderRow,'Zip','')
				End If
				
			End If /*Alt Address Loaded*/
			
			//Haz Materials Rating - UF6
			idsDOHeader.SetItem(llNewHeaderRow,'User_Field6',Mid(lsRecData,388,1))
			
		// DETAIL RECORD
		Case 'D' /*Detail */
			
			// If Sku is '99999999' Then it's a non-shipable dummy and we don't want to create an order detail (we'll still have to print the PAck List Notes later)
			lsTemp = Trim(Mid(lsRecData,30,8)) 
			If lsTemp =  '99999999' Then
				Continue /*Next Record*/
			End If
				
			llnewDetailRow = idsDODetail.InsertRow(0)
			llLineSeq ++
			
			//Add detail level defaults
			idsDODetail.SetITem(llnewDetailRow,'project_id', lsproject) /*project - derived from Ship to Facilty in header*/
			idsDODetail.SetITem(llnewDetailRow,'status_cd', 'N') 
			idsDODetail.SetITem(llnewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDODetail.SetITem(llnewDetailRow,'order_seq_no',llOrderSeq) 
			idsDODetail.SetITem(llnewDetailRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			idsDODetail.SetITem(llnewDetailRow,'Status_cd','N')
			//idsDODetail.SetITem(llnewDetailRow,'Inventory_Type','N') - 09/07 - PCONKL - We don't want to default inventory type any more. To do so restricts the pick to that type and not all pickable types.
			
			//If we have more than 1 detail row, than update the order type on the header to show multi line
			If llLineSeq > 1 Then
//				If Trim(Mid(lsRecData,153,3)) = 'OVN' Then /*Overnight? */
				If Trim(idsDOHeader.GetITemString(llNewHeaderRow,'Ship_Via')) = 'OVN' Then /*Overnight? */
					idsDOHeader.SetItem(llNewHeaderRow,'order_Type','4') /* Default to Multi Line Overnight */
				Else
					idsDOHeader.SetItem(llNewHeaderRow,'order_Type','3') /* Default to Multi Line */
				End If
			End If
						
			//Order Number
			lsTemp = Trim(Mid(lsRecData,15,7))
			If lsTemp > '' Then
				//Make sure we have a header row for this detail
				If idsDOHeader.Find("Invoice_no = '" + lsTemp + "'",1,idsDOHeader.RowCount()) > 0 Then
					idsDODetail.SetItem(llnewDetailRow,'invoice_no',lsTemp)
				Else /*not found*/
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Order Number in Detail Record not present in Header Record. Record will not be processed.")
					lbError = True
					Continue /*Next Record */
				End If
			Else /* order not present*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Order Number not present in DETAIL Row. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			//Line Item Number
			lsTemp = Trim(Mid(lsRecData,23,5))
			If isnumber(lsTemp) Then
				idsDODetail.SetITem(llnewDetailRow,'Line_Item_No',Long(lsTemp))
			Else
				idsDODetail.SetITem(llnewDetailRow,'line_Item_no',llLineSeq)
			End If
			
			//SKU
			//lsTemp = Trim(Mid(lsRecData,29,9))
			lsTemp = Trim(Mid(lsRecData,30,8)) /* 01/04 - PCONKL - We want to strip off the first char of the sku and only take the last 8*/
			If lsTemp > '' Then
				idsDODetail.SetItem(llnewDetailRow,'sku',lstemp)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - SKU not present in DETAIL Row. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
						
			// 07/05 - PCONKL - We want to set the Alternate SKU from Item Master so we can pick by alternate if primary not available
			Select Min(Alternate_Sku) into :lsAltSKU /* Min - may have multiple suppliers for item but we don't have supplier here */
			from Item_Master
			Where Project_id = :asProject and sku = :lstemp;
			
			If lsAltSku > '' Then
				idsDODetail.SetItem(llnewDetailRow,'alternate_sku',lsAltSKU)
			End If
			
			//Qty
			lsTemp = Trim(Mid(lsRecData,47,5))
			If isnumber(lsTemp) Then
				idsDODetail.SetITem(llnewDetailRow,'quantity',lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Quantity not numeric or not present in DETAIL Row. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			//Part Name - UF3
			idsDODetail.SetITem(llnewDetailRow,'USer_Field3',Trim(Mid(lsRecData,118,9)))
			
			//SPO Part WRTN (40) - UF4
			idsDODetail.SetITem(llnewDetailRow,'USer_Field4',Trim(Mid(lsRecData,305,14)))
			
			//ACD Prod Line (41)
			idsDODetail.SetITem(llnewDetailRow,'USer_Field5',Trim(Mid(lsRecData,320,2)))
			
			//Prime Catlg Grp (42)
			idsDODetail.SetITem(llnewDetailRow,'USer_Field6',Trim(Mid(lsRecData,323,6)))
			
			//Cntl Nbr (43)
			idsDODetail.SetITem(llnewDetailRow,'USer_Field1',Trim(Mid(lsRecData,330,20)))
			
			//Cust Bin Loc (50)
			idsDODetail.SetITem(llnewDetailRow,'USer_Field8',Trim(Mid(lsRecData,382,14)))
			
		
		// Notes RECORD
		Case 'A', 'Z' /*header or Detail Notes */
			
			llNewNotesRow = idsDONotes.InsertRow(0)
			idsDONotes.SetITem(llNewNotesRow,'project_id',lsProject) /*Project ID derived from Shipping Facility in Header*/
			idsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			
			//Note Seq
			lsTEmp = Trim(Mid(lsRecData,9,5))
			If isnumber(lsTemp) Then
				idsDONotes.SetItem(llNewNotesRow,'note_seq_no',Long(lsTemp))
			Else
				idsDONotes.SetItem(llNewNotesRow,'note_seq_no',llNewNotesRow)
			End If
			
			//Line ITem No (if Detail note)
			If lsREcType = 'Z' Then
				
				lsTemp = Trim(Mid(lsrecdata,23,5))
				If isnUmber(lsTemp) Then
					idsDONotes.SetITem(llNewNotesRow,'line_Item_No',Long(lsTEmp))
				End If
				
			End If /*Detail Note */
			
			//Note Type
			idsDONotes.SetItem(llNewNotesRow,'Note_Type',Trim(Mid(lsRecData,29,2)))
			
			//Note Text
			idsDONotes.SetItem(llNewNotesRow,'Note_Text',Trim(Mid(lsRecData,32,133)))
			
			
		//Address Record
		Case 'S' 
			
			//we will always update the Delivery Alt Address record (the NORMAL SHIP To on the PAcking List)
			//If we don't have an alternate address (from header field indicator), load into Delivery Master Address (Special Ship To on PAcking List)
			//We already defaulted both sets to the Customer Address (from Customer MAster)
			
			idsDOAddress.SetItem(idsDOAddress.RowCount(),'Name',Trim(Mid(lsRecData,29,30)))
			idsDOAddress.SetItem(idsDOAddress.RowCount(),'Address_1',Trim(Mid(lsRecData,60,30)))
			idsDOAddress.SetItem(idsDOAddress.RowCount(),'Address_2',Trim(Mid(lsRecData,91,30)))
			idsDOAddress.SetItem(idsDOAddress.RowCount(),'Address_3',Trim(Mid(lsRecData,122,30)))
			idsDOAddress.SetItem(idsDOAddress.RowCount(),'Address_4','')
			idsDOAddress.SetItem(idsDOAddress.RowCount(),'City',Trim(Mid(lsRecData,153,28)))
			idsDOAddress.SetItem(idsDOAddress.RowCount(),'State',Trim(Mid(lsRecData,182,2)))
			idsDOAddress.SetItem(idsDOAddress.RowCount(),'Zip',Trim(Mid(lsRecData,185,10)))
			
			//If we didn't load an Alt address into the Delivery MAster Address, Load from Address record here
			If idsDOHeader.GetItemString(llNewHeaderRow,'USer_Field4') <> 'Y' Then
								
				// Validate state Code
				
				lsState = Trim(Mid(lsRecData,182,2))
				
				Select Count(*) into :llCount
				From State
				Where State_cd = :lsState;
				
				If llCount < 1 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Delivery Address State (Address 182-183): '" + lsState + "'. ")
					lbError = True
				End If
				
				idsDOHeader.SetItem(llNewHeaderRow,'Cust_Name',Trim(Mid(lsRecData,29,30)))
				idsDOHeader.SetItem(llNewHeaderRow,'Address_1',Trim(Mid(lsRecData,60,30)))
				idsDOHeader.SetItem(llNewHeaderRow,'Address_2',Trim(Mid(lsRecData,91,30)))
				idsDOHeader.SetItem(llNewHeaderRow,'Address_3',Trim(Mid(lsRecData,122,30)))
				idsDOHeader.SetItem(llNewHeaderRow,'Address_4','')
				idsDOHeader.SetItem(llNewHeaderRow,'City',Trim(Mid(lsRecData,153,28)))
				idsDOHeader.SetItem(llNewHeaderRow,'State',Trim(Mid(lsRecData,182,2)))
				idsDOHeader.SetItem(llNewHeaderRow,'Zip',Trim(Mid(lsRecData,185,10)))
							
			End If /* Alt address not present */
			
			
			
		//Trailer - Ignore for now
		Case 'T'
			
		Case Else /*Invalid rec type */
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
			lbError = True
			Continue /*Next Record */
			
	End Choose /*Header or Detail */
	
Next /*file record */

// pvh - 08/30/05 -  Modified to use correctly formatted ENGLISH!!!!
//Check for header with no details by DGM 08/16/2005
// 09/05 - PCONKL - Don't report as error, just delete the header
ll_tot = idsDOHeader.Rowcount()
for i= ll_tot to 1 step -1
	ls_order = idsDOHeader.object.invoice_no[i]
	If idsDODetail.Find("Invoice_no = '" + ls_order + "'",1,idsDODetail.RowCount()) <= 0 Then		
		//lsMsg = "Order: " + ls_order + " has no line item detail, Not setup in SIMS."
		//gu_nvo_process_files.uf_writeError(lsmsg)
		doDeleteOrderSubTypes( i )  // delete address, notes, etc		
		idsDOHeader.DeleteRow(i)
		//gu_nvo_process_files.uf_send_email( 'GM_MI_DAT', 'CUSTVAL','Order Not Accepted by Sims', lsmsg,'' )
		//lbError = True					
	End If
Next
// eom

// We need to set the Carrier for any orders just added based on product girth, weight, sched code, etc.
liRC = uf_set_Carrier(idsDOHeader, idsDODetail)

//Save Changes
liRC = idsDOHeader.Update()
If liRC = 1 Then
	liRC = idsDODetail.Update()
End If
If liRC = 1 Then
	liRC = idsDONotes.Update()
End If
If liRC = 1 Then
	liRC = idsDOAddress.Update()
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

public function integer uf_set_carrier (ref datastore adsheader, ref datastore adsdetail);
Long	llHeaderRowCount, llheaderRowPos, llDetailRowcount, llDetailRowPos, llMaxGirth, llGirth, llMaxWeight, lLWeight,	&
		llLength, llWidth, llHeight, llCount, llNewRow
		
String	lsOrderNo, lsSKU, lsProject, lsShipVia, lsCarrier, lsnewSched, lsOrigSched, lsShipState, lsTempSched
Boolean	lbDomestic

Datastore	ldsDimensions

ldsDimensions = Create DataStore
ldsDimensions.dataobject = 'd_dimension_sort'

//12/0 4- PCONKL - For each order, determine the carrier based on the Ship Via (OVN), Girth, Weight, Sched Code and Ship to State

//For each Header
llheaderRowCount = adsHeader.RowCount()
For llHeaderRowPos = 1 to llheaderRowCount
	
	lsOrderNo = adsheader.GetITemString(llheaderRowPos,'Invoice_no')
	lsProject = adsheader.GetITemString(llheaderRowPos,'Project_id')
	lsShipState = adsheader.GetITemString(llheaderRowPos,'State')
	lsOrigSched = adsheader.GetITemString(llheaderRowPos,'User_field1') /* Original Schedule Code loaded in User Field 1*/
	
	//If 5 digit zip is numeric, assume a US shipment, otherwise Canada
	If isNumber(Trim(left(adsheader.GetITemString(llheaderRowPos,'Zip'),5))) or & 
		adsheader.GetITemString(llheaderRowPos,'zip') = '' or &
		IsNull(adsheader.GetITemString(llheaderRowPos,'Zip'))				then
		
			lbDomestic = True
			
	Else /*Canadian*/
			
		lbDomestic = False
			
	End IF
		
	//Determine the Max Girth and Weight for the Items in the order. Assume that each item will be shipped seperately
	// (if more than 1 of an item will force it over the weight or girth limit, they will ship seperately instead of overpacking)
	
	//Filter Details for Current Order
	adsDetail.SetFilter("Upper(Invoice_No) = '" + upper(lsOrderNo) + "'")
	adsDetail.Filter()
	
	llMaxGirth = 0
	llmaxWeight = 0
	
	llDetailRowCount = adsDetail.RowCount()
	
	For lLDetailRowPos = 1 to llDetailRowCount
		
		lsSKU = adsDetail.GetITemString(llDetailRowPos,'SKU')
		llLength = 0
		llWidth = 0
		llheight = 0
		lLWeight = 0
		
		Select Max(Length_1), Max(width_1), Max(Height_1), Max(weight_1)
		Into   :llLength, :llWidth, :llheight, :llWeight
		from ITem_Master
		Where Project_id = :lsProject and SKU = :lsSKU;
		
		//Make Sure that Length is largest of the dimensions
		ldsDimensions.Reset()
		llNewRow = ldsDimensions.InsertRow(0)
 		ldsDimensions.SetItem(llNewRow,'dimension',llLength)
		llNewRow = ldsDimensions.InsertRow(0)
 		ldsDimensions.SetItem(llNewRow,'dimension',llWidth)
		llNewRow = ldsDimensions.InsertRow(0)
 		ldsDimensions.SetItem(llNewRow,'dimension',llHeight)
		ldsDimensions.Sort()
		llLength = ldsDimensions.GetITemNumber(1,'dimension')
		llWidth = ldsDimensions.GetITemNumber(2,'dimension')
		llHeight = ldsDimensions.GetITemNumber(3,'dimension')
		llGirth = (2 * llWidth) + (2 * llheight) + llLength
		
		If llGirth > llMaxGirth Then llmaxGirth = llgirth
		If llWeight > llMaxWeight Then llMaxWeight = llWeight
		
	Next /* Detail */

	//DETERMINE PROPER CARRIER AND SCHEDULE CODE
	
	lsShipVia = adsheader.GetITemString(llheaderRowPos,'Ship_Via')

	//If Overnight, Ship Fedex OverNight or Express 1 Day depending on Girth/Weight
	If lsShipVia = 'OVN' Then
		
			
		//If Girth or Weight in excess, ship Express 1 day freight, otherwise ship overnight
		If llMaxGirth >= 165 or llmaxWeight >= 150 Then
			
			If lbDomestic Then
				
				lsCarrier = 'FEDEX'
				lsNewSched = lsOrigSched + '/' + 'OVNFEDLT'
				
			Else /* Canadian LTl go Emery */
				
				lsCarrier = 'EMERY'
				lsNewSched = lsOrigSched + '/' + 'EMERY'
			
			End If
				
		Else /*overnight*/
				
			lsCarrier = 'FEDEX'
			lsNewSched = lsOrigSched + '/' + 'OVNFEDEX'
				
		End If /* Girth/weight */
				
	Else /* Not OverNight*/
		
		//If Canadian, always Ship menlo, otherwise base it on the Original Sched Code
		
		If Not lbDomestic Then

			// Canadia Non Overnight Shipments go Emery
			lsCarrier = 'EMERY'
			lsNewSched = lsOrigSched + '/' + 'EMERY'
			
		Else /* US Shipment, use Sched Code*/
		
			Choose Case upper(lsOrigSched)
				
				Case 'V'
				
					If (llMaxGirth >= 165 or llMaxWeight > 150) Then
					
						lsCarrier = 'FEDEX'
						lsNewSched = lsOrigSched + '/' + 'FEDEX-EX'
					
// 07/07 - PCONKL - No longer applicable...
//					ElseIf llMaxGirth > 130 and llMaxWeight < 150 Then
//					
//						lsCarrier = 'FEDEX'
//						lsNewSched = lsOrigSched + '/' + 'FEDEX'
					
					Else
					
						//Check Carrier State Table to determine Fedex or UPS - 
					
						//02/06 - PCONKL - No longer using UPS, just FEDEX - if a UPS state, set to "FEDEX Ground"
						
						// 07/07 - PCONKL - Now retreive based on state to return the carrier serivce level to use (still using only FEDEX)
						
						lsCarrier = 'FEDEX'
//						lsNewSched = lsOrigSched + '/' + 'FEDEX'

//						//If not found for UPS, then Fedex
//						Select Count(*) into :llCount
//						from Carrier_Shipment
//						Where Project_id = :lsProject and state_cd = :lsShipState and Carrier = "UPS";
//					
//						If llCount > 0 Then
//						
//							//Was UPS, Now Fedex Ground
//							lsCarrier = 'FEDEX'
//							lsNewSched = lsOrigSched + '/' + 'FEDEX-GD'
//						
//						Else /*Fedex*/
//						
//							lsCarrier = 'FEDEX'
//							lsNewSched = lsOrigSched + '/' + 'FEDEX'
//						
//						End If

						lsTempSched = ""
						
						Select carrier into :lsTempSched  /* carrier in DB = Sched Code here */
						from Carrier_Shipment
						Where Project_id = :lsProject and state_cd = :lsShipState and Sched_Code = "V";
						
						If lsTempSChed > "" Then
							
							lsNewSched = lsOrigSched + '/' + lsTempSched
							
						Else /*state not loaded - default to ground*/
							
							lsNewSched = lsOrigSched + '/' + 'FEDEX-GD'
							
						End If

					End If
				
				Case 'B', 'W', 'E', 'F'
				
					If llMaxGirth >= 165  Then
					
						lsCarrier = 'SCHN'
						lsNewSched = lsOrigSched + '/' + 'LTL'
					
					ElseIf llMaxGirth > 130 and llMaxWeight < 150 Then
					
						lsCarrier = 'FEDEX'
						lsNewSched = lsOrigSched + '/' + 'FEDEX'
					
					Else
					
					//02/06 - PCONKL - No longer using UPS...
					
					//	lsCarrier = 'UPS'
					//	lsNewSched = lsOrigSched + '/' + 'UPS'
						
						lsCarrier = 'FEDEX'
						lsNewSched = lsOrigSched + '/' + 'FEDEX'
										
					End If
									
				Case Else /*default to UPS Ground if no SChed Code*/
				
					//02/06 - PCONKL - No longer using UPS...
					
			//		lsCarrier = 'UPS'
			//		lsNewSched = lsOrigSched + '/' + 'UPS GRND'
					
					lsCarrier = 'FEDEX'
					lsNewSched = lsOrigSched + '/' + 'FEDEX'
					
			End Choose /* Orig Sched Code */
			
		End If /*US or Canadian*/
		
	End If /* Overnight or not */
	
	AdsHeader.SetItem(llHeaderRowPos,'Carrier',lsCarrier)
	AdsHeader.SetItem(llHeaderRowPos,'User_field1',lsNewSched)
	
Next /* Order Header Row*/

//Changes will be saved in uf_process_so

Return 0
end function

public subroutine dodeleteordersubtypes (long index);// doDeleteOrderSubTypes( string asOrder )

// Delete the notes, address, etc from the incoming order

// grab the batch and order seq from header
int ediseq
int ordseq
string filterfor
long lRow

ediseq = idsDOHeader.object.edi_batch_seq_no[ index ]
ordseq = idsDOHeader.object.order_seq_no[ index ] 

filterfor = "edi_batch_seq_no = " + string ( ediseq ) + ' and ' + 'order_seq_no = ' + string( ordseq )

idsdoNotes.setfilter( filterfor )
idsdoNotes.filter()
lRow = idsdoNotes.rowcount()
Do while lRow > 0
	idsdoNotes.deleterow( lRow )
	lRow --
Loop
idsdoNotes.setfilter( "" )
idsdoNotes.filter()

idsDoAddress.setfilter( filterfor )
idsDoAddress.filter()
lRow = idsDoAddress.rowcount()
Do while lRow > 0
	idsDoAddress.deleterow( lRow )
	lRow --
Loop
idsDoAddress.setfilter( "" )
idsDoAddress.filter()

return



end subroutine

public function integer uf_fedex_interface_out (string asproject);//Prepare a Goods Issue Transaction for SELECTRON for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llCartonCount
				
String		lsFind, lsOutString,	lsMessage, lsSku,	lsSupplier,	lsInvType,	&
				lsInvoice, lsLogOut, lsFileName, lsCurrentFile

DEcimal		ldBatchSeq
Integer		liRC
DataStore ldsDOMain, ldsout

Boolean	bret

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)


If Not isvalid(ldsDOMain) Then
	ldsDOMain = Create Datastore
	ldsDOMain.Dataobject = 'd_FedEx_Interface_Out'
	ldsDOMain.SetTransObject(SQLCA)
End If
ldsOut.Reset()

//Retreive Delivery Masters for this Project
llRowCount = ldsDOMain.Retrieve(asProject) 

//For each sku/line Item/inventory type in Picking, write an output record - 

lsLogOut = "        Creating FedEx Interface File For Project: " + asProject
FileWrite(gilogFileNo,lsLogOut)

lsLogOut = Space(5) + '- ' + String(llRowCount) + ' Orders Retrieved for processing.'
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Write the rows to the generic output table - delimited by '|'
For llRowPos = 1 to llRowCOunt
	
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'DM|' /*rec type = Delivery Master*/
	lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'Do_No'),20)  + '|'
	lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'Invoice_No'),20) + '|'

	If Not isnull(ldsDOMain.GetItemString(llRowPos,'Cust_Name')) Then
		lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'Cust_Name'),40) + '|'
	Else
		lsOutString +='|'
	End IF
	If Not isnull(ldsDOMain.GetItemString(llRowPos,'Address_1')) Then
		lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'Address_1'),40) + '|'
	Else
		lsOutString +='|'
	End IF
	If Not isnull(ldsDOMain.GetItemString(llRowPos,'Address_2')) Then
		lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'Address_2'),40) + '|'
	Else
		lsOutString +='|'
	End IF
	If Not isnull(ldsDOMain.GetItemString(llRowPos,'Address_3')) Then
		lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'Address_3'),40) + '|'
	Else
		lsOutString +='|'
	End IF
	If Not isnull(ldsDOMain.GetItemString(llRowPos,'Address_4')) Then
		lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'Address_4'),40) + '|'
	Else
		lsOutString +='|'
	End IF
	If Not isnull(ldsDOMain.GetItemString(llRowPos,'City')) Then
		lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'City'),30) + '|'
	Else
		lsOutString +='|'
	End IF
	If Not isnull(ldsDOMain.GetItemString(llRowPos,'State')) Then
		lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'State'),35) + '|'
	Else
		lsOutString +='|'
	End IF
	If Not isnull(ldsDOMain.GetItemString(llRowPos,'Zip')) Then
		lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'Zip'),15) + '|'
	Else
		lsOutString +='|'
	End IF
	If Not isnull(ldsDOMain.GetItemString(llRowPos,'Country')) Then
	lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'Country'),35) + '|'
	Else
		lsOutString +='|'
	End IF
	If Not isnull(ldsDOMain.GetItemString(llRowPos,'Contact_Person')) Then
		lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'Contact_Person'),40) + '|'
	Else
		lsOutString +='|'
	End IF
	If Not isnull(ldsDOMain.GetItemString(llRowPos,'Tel')) Then
		lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'Tel'),20) + '|'
	Else
		lsOutString +='|'
	End IF
	If Not isnull(ldsDOMain.GetItemString(llRowPos,'User_Field1')) Then
		lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'User_Field1'),10) + '|'
	Else
		lsOutString +='|'
	End IF
	If Not isnull(ldsDOMain.GetItemString(llRowPos,'Freight_Terms')) Then
		lsOutString += Left(ldsDOMain.GetItemString(llRowPos,'Freight_Terms'),20)
	End IF

	ldsOut.SetItem(llNewRow,'Project_id', 'GM_MI_DAT')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'dmfedexout' + '.DAT'
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next output record */

			
//We don't want to archive this file since it is just a snapshop of open orders.
// Also delete the file from flatfileout if one exists since it will just keep appending to an existing file
lsCurrentFile = ProfileString(gsinifile,'GM_MI_DAT',"archivedirectory","") + '\' + lsfilename
If FIleExists(lsCurrentFile) Then
	bret = gu_nvo_process_files.DEleteFile(lsCurrentFile)
	If bret Then /*deleted*/
		lsLogOut = Space(10) + "File deleted: " + lsCurrentFile
		FileWrite(gilogFileNo,lsLogOut)
	End If
End If
lsCurrentFile = ProfileString(gsinifile,'GM_MI_DAT',"ftpfiledirout","") + '\' + lsfilename
If FIleExists(lsCurrentFile) Then
	bret = gu_nvo_process_files.DEleteFile(lsCurrentFile)
	If bret Then /*deleted*/
		lsLogOut = Space(10) + "File deleted: " + lsCurrentFile
		FileWrite(gilogFileNo,lsLogOut)
	End If
End If


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'GM_MI_DAT')


Return 0
end function

public function integer uf_fedex_interface_in (string aspath, string asproject, string asfile);//Process the File from Fed Ex to add the Tracking Id to the Packing Table

//Datastore	ldsDOHeader, ldsDODetail, iu_ds, idsDOAddress, idsDONotes
				
String		lsLogout, lsRecData, lsErrText,  lsDoNo, lsTrackingId, lsInvoice, lsServiceLevel, & 
				lsRecType, lsOrdStatus, lsCarton, lsCurrentFile, lstemp, lsWhCode

DateTime		ldtToday

Integer		liFileNo,liRC,i
				
Long			llRowCount,	llRowPos,llNewRow, llLineSeq ,llCount, llLineItemNo		

Boolean		lbError, bret

string		lsMsg

long start_pos=1

string old_str, new_str, mystring


iu_ds.Reset()

//Open the File
lsLogOut = '      - Opening File for GM FedEx Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for GM FedEx Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	llNewRow = iu_ds.InsertRow(0)

	Do While Pos(lsRecData,'"')>0
		lsRecData = Replace(LsRecData, Pos(lsRecData,'"'), 1, '')
	Loop

	iu_ds.SetItem(llNewRow,'rec_data',lsRecData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

llRowCount = iu_ds.RowCount()

//Process each Row
//The columns are delimited by '|'
For llRowPos = 1 to llRowCount
	
	lsRecData = Trim(iu_ds.GetITemString(llRowPos,'rec_data'))

	lsRecType = Left(lsRecData,2)

	//Process header or Detail */
	Choose Case Upper(lsRecType)
			
//Detail Record
	Case 'DD' 

		lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
		//DoNo 
		If Pos(lsRecData,'|') > 0 Then
			lsDoNo = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Record will not be processed.")
			lbError = True
		End If
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsDoNo) + 1))) /*strip off to next Column */
	
		//Invoice 
		If Pos(lsRecData,'|') > 0 Then
			lsInvoice = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Invoice Number' field. Record will not be processed.")
			lbError = True
		End If
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsInvoice) + 1))) /*strip off to next Column */

		//Tracking 
		If Pos(lsRecData,'|') > 0 Then
			lsTrackingId = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else
			lsTrackingId = lsRecData
		End If

		// Get the Order Header to check the Status
		// First try with the DONO returned
		Select Ord_Status, Wh_code into :lsOrdStatus, :lsWhCode
		From Delivery_Master
		Where DO_NO = :lsDoNo;

		// Next try the invoice number
		If IsNull(lsDoNo) or lsDoNo = "" Then	
			Select Ord_Status, Do_No, Wh_code into :lsOrdStatus, :lsDoNo, :lsWhCode
			From Delivery_Master
			Where (Project_ID = :asProject) and (Invoice_No = :lsInvoice) and (Ord_Status <> 'V');
		End If 



		// Next Try the invoice number with a leading zero to catch the manual entry typos
		If IsNull(lsDoNo) or lsDoNo = "" Then	
			Select Ord_Status, Do_No, Wh_code into :lsOrdStatus, :lsDoNo, :lsWhCode
			From Delivery_Master
			Where (Project_ID = :asProject) and (Invoice_No = ('0' + :lsInvoice)) and (Ord_Status <> 'V');
		End If 
	
		// Missing DoNo
		If IsNull(lsOrdStatus) or lsOrdStatus = "" or IsNull(lsDoNo) or lsDoNo = "" Then
		//	gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Delivery Order Number: " + lsDoNo + "Order Number: " + lsInvoice + " is invalid or was manually entered.")
		//TAM 2006/1212 - dont	write error
		//lbError = True
		Else
			If lsOrdStatus <> 'A' and  lsOrdStatus <> 'C' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Delivery Order Number: " + lsDoNo + "Order Number: " + lsInvoice + " is in the wrong Status. - " + lsOrdStatus)
				lbError = True
			End If
				
			// Check if the Tracking Number Exists
			Select Count(*) into :llCount
			From Delivery_Packing
			Where Do_No = :lsDoNo and Shipper_Tracking_ID = :lsTrackingId;	

			// If Not Found then Add Packing Row for Tracking ID and Update the Delivery Master
			If llCount < 1 Then
		
				// Get Last Carton Number and Line Number
				SELECT max(Carton_No), max(Line_Item_No) into :lsCarton, :llLineItemNo 
				FROM Delivery_Packing  
				WHERE Delivery_Packing.DO_No = :lsDoNo;   
			  
				llLineItemNo = llLineItemNo + 1
				If IsNumber(lsCarton) Then 
					lsCarton = string(long(lsCarton) + 1) 
				Else
					lsCarton = '1'
				End If

	// TAM 05/24/2006 Disable Updates until ready to turn on in production autocomplete is ready to turn on
				INSERT INTO dbo.Delivery_Packing ( DO_No, Carton_No, SKU, Supp_Code, Country_of_Origin, Quantity, Line_Item_No, Shipper_Tracking_ID)  
  				VALUES ( :lsDoNo, :lsCarton, 'TRACKINGSKU', '0000', 'XXX', 1, :llLineItemNo, :lsTrackingID)
				Using SQLCA; 
		
				If sqlca.sqlcode <> 0 Then
					lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
					Rollback;
					gu_nvo_process_files.uf_writeError("Error saving Row: " + String(llRowPos) + " Unable to save tracking number record to database!~r~r" + lsErrText)
					lbError = True
				Else
					commit;
				End If
				ldtToday = f_getLocalWorldTime( lsWhCode  )

				// Update the Delivery Master - Complete the order if it is in Packing Status			
				//ldtToday = DateTime(today(), Now())
				If lsOrdStatus = 'A' Then
						UPDATE Delivery_Master  
					SET Ord_Status = 'C', Complete_Date = :ldtToday, Last_User = 'FedEx', Last_Update = :ldtToday
					WHERE DO_No = :lsDoNo;   
				Else
					UPDATE Delivery_Master  
					SET Last_User = 'FedEx', Last_Update = :ldtToday
					WHERE DO_No = :lsDoNo;   
				End If	

			End If
		End If
	End Choose
Next	

//We also don't want to keep error files for to long because they prefix an "X" to each error file
// This is a hokey loop to delete files with X's
//If lbError Then
//	
//	lsCurrentFile = ProfileString(gsinifile,'GM_MI_DAT',"errordirectory","") + '\' + asfile + '.txt'
//	If FIleExists(lsCurrentFile) Then
//		bret = gu_nvo_process_files.DEleteFile(lsCurrentFile)
//		If bret Then /*deleted*/
//			lsLogOut = Space(10) + "File deleted: " + lsCurrentFile
//			FileWrite(gilogFileNo,lsLogOut)
//		End If
//	End If
//	lsCurrentFile = ProfileString(gsinifile,'GM_MI_DAT',"errordirectory","") + '\' + asfile + '.err.txt'
//	If FIleExists(lsCurrentFile) Then
//		bret = gu_nvo_process_files.DEleteFile(lsCurrentFile)
//		If bret Then /*deleted*/
//			lsLogOut = Space(10) + "File deleted: " + lsCurrentFile
//			FileWrite(gilogFileNo,lsLogOut)
//		End If
//	
//		lsTemp = 'X' + asfile
//		lsCurrentFile = ProfileString(gsinifile,'GM_MI_DAT',"errordirectory","") + '\' + lsTemp + '.err.txt'
//			
//				Do While FileExists(lsCurrentFile)
//					bret = gu_nvo_process_files.DEleteFile(lsCurrentFile)
//					If bret Then /*deleted*/
//						lsLogOut = Space(10) + "File deleted: " + lsCurrentFile
//						FileWrite(gilogFileNo,lsLogOut)
//					End If
//					lsTemp = 'X' + lsTemp
//					lsCurrentFile = ProfileString(gsinifile,'GM_MI_DAT',"errordirectory","") + '\' + lsTemp + '.err.txt'
//				Loop
//
//	End If
//
//
//Else
	
//We don't want to archive this file over and over again because each file is an accumulation of a days activity.
// We only need the most recent archive
	lsCurrentFile = ProfileString(gsinifile,'GM_MI_DAT',"archivedirectory","") + '\' + asfile
	If FIleExists(lsCurrentFile) and not(lbError) Then
		bret = gu_nvo_process_files.DEleteFile(lsCurrentFile)
		If bret Then /*deleted*/
			lsLogOut = Space(10) + "File deleted: " + lsCurrentFile
			FileWrite(gilogFileNo,lsLogOut)
		End If
	End If
//End If

If lbError Then Return -1

Return 0
end function

on u_nvo_proc_gm.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_gm.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;
DESTROY idsDOHeader
destroy idsDODEtail
destroy idsDONotes
destroy idsDOADdress

end event

event constructor;iu_ds = Create datastore
iu_ds.dataobject = 'd_generic_import'

idsDOHeader = Create u_ds_datastore
idsDOHeader.dataobject = 'd_shp_header'
idsDOHeader.SetTransObject(SQLCA)

idsDODetail = Create u_ds_datastore
idsDODetail.dataobject = 'd_shp_detail'
idsDODetail.SetTransObject(SQLCA)

IdsDOAddress = Create u_ds_datastore
idsDOAddress.dataobject = 'd_mercator_do_address'
idsDOAddress.SetTransObject(SQLCA)

idsDONotes = Create u_ds_datastore
idsDONotes.dataobject = 'd_mercator_do_Notes'
idsDONotes.SetTransObject(SQLCA)

end event

