HA$PBExportHeader$u_nvo_proc_ws.sru
$PBExportComments$Process Logitech Files
forward
global type u_nvo_proc_ws from nonvisualobject
end type
end forward

global type u_nvo_proc_ws from nonvisualobject
end type
global u_nvo_proc_ws u_nvo_proc_ws

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
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_add_sku (string asproject, string assupplier, string assku)
public function boolean uf_dovalidate (long arow, string asdata)
public function integer uf_dovalidatecritical (long arow, string asdata)
public subroutine setdefaultowner (string asproject, string astype, string asownercode)
public function long getdefaultowner ()
public subroutine setproject (string asproject)
public function string getproject ()
public function string getcoo (string asdesignationcode)
public function integer uf_process_so (string aspath, string asproject, string asfile)
public function integer uf_process_inventory_by_sku_rpt (string asproject, string asinifile, string asemail, string aswhcode)
public function integer uf_process_so_import (string aspath, string asproject)
public function integer uf_process_po_import (string aspath, string asproject)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 2 characters of the file name

String	lsLogOut,	&
			lsSaveFileName
Integer	liRC

Boolean	lbOnce, lbError
lbOnce = false

Choose Case Upper(Left(asFile,2))
		
	Case 'DM' /* Sales Order Files*/
		
		liRC = uf_process_so(asPath, asProject, asfile)
		
		If liRC < 0 Then lbError = True
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
		
		If lbError Then liRC = -1


	Case  'IN'  
		
		liRC = uf_process_po_import(asPath, asProject)


	Case  'OU'  
		
		liRC = uf_process_so_import(asPath, asProject)


Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
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

public function integer uf_process_so (string aspath, string asproject, string asfile);
				
String		lsLogout,lsRecData,lsTemp,lsRecType,lsOrder,lswarehouse,lsordertype, lsDate, ls_check_dtl

String		lsName, lsAdd1, lsAdd2, lsAdd3, lsAdd4, lsDistrict, lsCity, lsState, lsZIP, lsCountry, lsTel, lsContact, &
				lsEmail, lsVatId, lsinventorytype, lsPriority, lsUF5, lsmessage, &
				lsaltaddress_type, lsaltname, lsaltaddress_1, lsaltaddress_2, lsaltaddress_3, &
				lsaltaddress_4, lsaltcity, lsaltdistrict, lsaltstate, lsaltcountry, lsaltalt_cust_code, &
 				lsaltcontact_person, lsalttel, lsaltzip, lsnotetype, lsnotetext
			
			 
String		 ls_IM_uom1, ls_IM_uom2, ls_IM_hs_code,  ls_IM_uf11, ls_IM_alt_sku , ls_sku_desc, lsqty1, lsqty2, lsShipInstr,ls_Req_Date

Long		ll_IM_qty2, ll_qty
Integer		liFileNo,liRC, lirecdatacount

decimal 		ldTemp
				
Long			llRowCount,	llRowPos,llNewRow,llOrderSeq,	llBatchSeq,	llLineSeq,llCount, &
				llOwner,llTemp, llLen, llNewAddressRow, lllineitemno, llnoteseqno, llNewNotesRow, llprevRow, llPOs 
				
DateTime		ldtToday

Boolean		lbError, lbDM, lbDD,lbEOF, lb_2Details

ldtToday = DateTime(today(),Now())
				

iu_ds.Reset()
idsDOHeader.Reset()
idsDODetail.Reset()
idsDOAddress.reset()
//idsDONotes.REset()

//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for WS-MHD Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsRecData)

lirecdatacount  = 0

//Do While liRC > 0
//TAM 05/02/2010
//Get the 1st 26 lines .  They contain the head information
//Do While lirecdatacount < 58
Do While lirecdatacount < 26
	llNewRow = iu_ds.InsertRow(0)
	If isnull(lsrecdata) or lsRecData = '' then 
		iu_ds.SetItem(llNewRow,'rec_data','*') /*placeholder for null or blank lines*/
	Else
		iu_ds.SetItem(llNewRow,'rec_data',lsRecData) /*record data is the rest*/
	End If
	liRC = FileRead(liFileNo,lsRecData)

	lirecdatacount ++

Loop /*Next File record*/
lbEOF = False
//TAM Now get the details.  This will continue until we get the line "Goods received in good order and condition," or 1000 lines.  We need to exclude the header part or any unneeded text.
Do While lbEOF = False and lirecdatacount <1000
	If mid(lsRecData,8,43) = 'Goods received in good order and condition,' Then
		lbEOF = True
	Else
		//If length if line = 68 or 69 character then it is a detail.   If the first character start in position 33 then it is the second part of the description.  We need to write these.  Ignore the others.
		//TAM If length of line is 68 to 72 character and position 67 to 72 is numberic(when stripped of blanks) then it is a detail  .   If the first character start in position 33 then it is the second part of the description.  We need to write these.  Ignore the others.

		//Strip Blanks
		ls_check_dtl = Trim(mid(lsRecData,67,6))
			llPOs = Pos(ls_check_dtl,' ',1)
			Do While llPos > 0
				ls_check_dtl = Replace(ls_check_dtl,llPos,1,'')
				llPos ++
				If llPos > Len(ls_check_dtl) Then
					llPos = 0
				Else
					llPOs = Pos(ls_check_dtl,' ',1)
				End If
			Loop
		
		
//		If Len(Trim(mid(lsRecData,8,88))) >= 68 and Len(Trim(mid(lsRecData,8,88))) <= 69 Then //Detail record
		If Len(Trim(mid(lsRecData,8,88))) >= 68 and Len(Trim(mid(lsRecData,8,88))) <= 72 and isnumber(ls_check_dtl)	 Then //Detail record
			llNewRow = iu_ds.InsertRow(0)
			iu_ds.SetItem(llNewRow,'rec_data',lsRecData) /*write record*/
		Else 
			if Trim(Left(lsRecData,32)) = '' and Trim(mid(lsRecData,33,4)) <> '' Then //2nd part of description description record
				llNewRow = iu_ds.InsertRow(0)
				iu_ds.SetItem(llNewRow,'rec_data',lsRecData) /*write record*/
			End If	
		End If
	End If
	lirecdatacount ++
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

//Warehouse will have to be defaulted from project master default warehouse
lswarehouse = 'WS-DP'

//Get Default owner for Logitech (Supplier) in case we are creating any Non Consolidated FG to Inv Receive Detail records
Select owner_id into :llOwner
From OWner
Where project_id = :asProject and Owner_cd = 'MHD' and owner_type = 'S';

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = iu_ds.RowCount()

//HEADER RECORD
			
	w_main.SetMicroHelp("Processing DM Outbound Master Record " + String(llRowPos) + " of " + String(llRowCount))  
	
	llnewRow = idsDOHeader.InsertRow(0)
	llOrderSeq ++
	llLineSeq = 0
			
	//Record Defaults
	idsDOHeader.SetItem(llNewRow,'Action_cd','A') /*Default - will add/update an Order*/
	idsDOHeader.SetItem(llNewRow,'order_Type','S')
	idsDOHeader.SetItem(llNewRow,'wh_code','WS-DP')
	idsDOHeader.SetITem(llNewRow,'project_id',asProject) /*Project ID*/
	idsDOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
	idsDOHeader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
	idsDOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
	idsDOHeader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
	idsDOHeader.SetItem(llNewRow,'Status_cd','N')
	idsDOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')


//Process each Row - WS is unique.  They have a fixed format with data coming on specific lines and positions.
	
	 //  Customer Order Number
	lsTemp = Trim(Mid(iu_ds.GetItemString(2,'rec_data'),28,8)) 
	If lsTemp <> "" Then
		idsDOHeader.SetItem(llNewRow,'order_no',lsTemp)
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Customer Order Number: " + lsTemp + ". Record will not be processed.")
		lbError = True
	End If

	 //  Request Date
	lsTemp = Trim(Mid(iu_ds.GetItemString(3,'rec_data'),24,10))
	If lsTemp <> "" Then
		ls_Req_Date = mid(lsTemp,4,3) + left(lsTemp,3) + mid(lsTemp,7,4)
		idsDOHeader.SetItem(llNewRow,'Request_date',ls_Req_Date)
	Else /*No Date*/
		idsDOHeader.SetItem(llNewRow,'Request_Date',ldtToday)
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Order Date: " + lsTemp + ". Sims will replace with:" + string(ldtToday))
	End If

	 //  Customer Order Number
	lsTemp = Trim(Mid(iu_ds.GetItemString(4,'rec_data'),27,50)) 
	If lsTemp <> "" Then
		idsDOHeader.SetItem(llNewRow,'User_Field12',lsTemp)
	End If

	//  Sales Order Number
	lsTemp = Trim(Mid(iu_ds.GetItemString(5,'rec_data'),26,8)) 
	If lsTemp <> "" Then
		idsDOHeader.SetItem(llNewRow,'User_Field10',lsTemp)
	End If

	//  Account Executive
	lsTemp = Trim(Mid(iu_ds.GetItemString(6,'rec_data'),28,50)) 
	If lsTemp <> "" Then
		idsDOHeader.SetItem(llNewRow,'User_Field11',lsTemp)
	End If

	 //  Customer Number = Ship to Customer Name and Cust Code
	lsTemp = Trim(Mid(iu_ds.GetItemString(10,'rec_data'),57,8)) 
	If lsTemp <> "" Then
		idsDOHeader.SetItem(llNewRow,'Cust_Name',lsTemp)
		idsDOHeader.SetItem(llNewRow,'Cust_Code',lsTemp)
	End If
	
	//  Shipping Instructions
	lsShipInstr = Trim(Mid(iu_ds.GetItemString(18,'rec_data'),9,255)) 

	lsTemp = Trim(Mid(iu_ds.GetItemString(19,'rec_data'),9,255)) 
	If lsTemp <> "" Then
		lsShipInstr = lsShipInstr + char(13) + lsTemp
	End If
	lsTemp = Trim(Mid(iu_ds.GetItemString(20,'rec_data'),9,255)) 
	If lsTemp <> "" Then
		lsShipInstr = lsShipInstr + char(13) + lsTemp
	End If
	lsTemp = Trim(Mid(iu_ds.GetItemString(21,'rec_data'),9,255)) 
	If lsTemp <> "" Then
		lsShipInstr = lsShipInstr + char(13) + lsTemp
	End If

	If lsShipInstr <> "" Then
		idsDOHeader.SetItem(llNewRow,'Shipping_Instructions_Text',lsShipInstr)
	End If


	//  Customer Warehouse Code
	lsTemp = Trim(Mid(iu_ds.GetItemString(22,'rec_data'),20,20)) 
	If lsTemp <> "" Then
		idsDOHeader.SetItem(llNewRow,'User_Field4',lsTemp)
	End If
	
	//  File Name
	idsDOHeader.SetItem(llNewRow,'User_Field18',asFile)

    //TAM - W&S 2011/01  -   Order Number is Formatted.  We will not allow entry into this field.  We do not have the DONO yet.  That comes in the process SO
    //Format is (WH_CODE(4th and 5TH Char)) + "S" + (Year(2 digit)) + (Month(2 Digit)) + (4 Digit Running number from Lookup table) 
   //Left 2 characters = WS for Wine and Spirt.
	idsDOHeader.SetItem(llNewRow,'invoice_no','MH-S' + String(ldtToday,'YYMM'))
	idsDOHeader.SetItem(llNewRow,'ord_Date',ldtToday)



			//Ship To Address 1
			integer liPosAdd
			liPosAdd = Pos(iu_ds.GetItemString(11,'rec_data'),':',22) + 2  //Ship to add 1 starts 3 spaces after the ':'
//			lsTemp = Trim(Mid(iu_ds.GetItemString(11,'rec_data'),57,35))
			lsTemp = Trim(Mid(iu_ds.GetItemString(11,'rec_data'),liPosAdd,35))
				 
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Address_1',lsTemp)
			End If

			//Address 2
			lsTemp = Trim(Mid(iu_ds.GetItemString(12,'rec_data'),57,35))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Address_2',lsTemp)
			End If

			//Address 3
			lsTemp = Trim(Mid(iu_ds.GetItemString(13,'rec_data'),57,35))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Address_3',lsTemp)
			End If

			//Address 4
			lsTemp = Trim(Mid(iu_ds.GetItemString(14,'rec_data'),57,35))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'Address_4',lsTemp)
			End If

			//District
			lsTemp = Trim(Mid(iu_ds.GetItemString(15,'rec_data'),57,35))
			If lsTemp <> "" Then
				idsDOHeader.SetItem(llNewRow,'District',lsTemp)
			End If



		 /* Address Stuff */
		 If Trim(Mid(iu_ds.GetItemString(11,'rec_data'),22,35)) > '' Then /*Check first line */
									
			lsaltaddress_type = 'BT'

			 //  Customer Number = Bill to Customer Name 
			lsTemp = Trim(Mid(iu_ds.GetItemString(10,'rec_data'),23,8)) 
			If lsTemp <> "" Then
				lsaltname = lsTemp
			End If

			
			lsTemp = Trim(Mid(iu_ds.GetItemString(11,'rec_data'),22,35)) /*Bill To Address 1 */
			lsTemp = Trim(replace(lsTemp,Pos(lsTemp,'Add'),35,''))  
			If lstemp > '' then
				lsaltaddress_1 = lsTemp
			Else 
				lsaltaddress_1 = ' '
			End If

			lsTemp = Trim(Mid(iu_ds.GetItemString(12,'rec_data'),22,35)) /*Bill To Address 2 */
			If lstemp > '' then
				lsaltaddress_2 = lsTemp
			Else 
				lsaltaddress_2 = ' '
			End If

			lsTemp = Trim(Mid(iu_ds.GetItemString(13,'rec_data'),22,35)) /*Bill To Address 3 */
			If lstemp > '' then
				lsaltaddress_3 = lsTemp
			Else 
				lsaltaddress_3 = ' '
			End If

			lsTemp = Trim(Mid(iu_ds.GetItemString(14,'rec_data'),22,35)) /*Bill To Address 4 */
			If lstemp > '' then
				lsaltaddress_4 = lsTemp
			Else 
				lsaltaddress_4 = ' '
			End If

			lsTemp = Trim(Mid(iu_ds.GetItemString(15,'rec_data'),22,35)) /*Bill To District */
			If lstemp > '' then
				lsaltdistrict = lsTemp
			Else 
				lsaltdistrict = ' '
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
			idsDOAddress.SetItem(llNewAddressRow,'District',lsaltdistrict) 
		End If
		
		// DETAIL RECORD
			llrowcount = iu_ds.RowCount()
		If 	llrowcount > 0  Then
			
//		If 	len(Trim(Mid(iu_ds.GetItemString(27,'rec_data'),2))) > 0  Then
			
//Process each Row
			llRowPos = 27
//			For llRowPos = 27 to 58 		
			For llRowPos = 27 to llrowcount 		

//			// Position 1 = * or Position 8 = G means there are no mor detail rows
//				If left(iu_ds.GetItemString(llRowPos,'rec_data'),1) = '*' or  mid(iu_ds.GetItemString(llRowPos,'rec_data'),8,1) = 'G' Then
//					llRowPos =59
//					Continue
//				End  If

				If   Trim(mid(iu_ds.GetItemString(llRowPos,'rec_data'),12,20)) = '' Then  //Sku = blank then this is the second part of the sku description
					lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),33,34)) 
					ls_sku_desc = ls_sku_desc + lsTemp
					idsDODetail.SetItem(llNewRow,'line_item_notes', ls_sku_desc)
					If	lb_2Details = true Then //set the description for the line above since another line would have been created for this order
						idsDODetail.SetItem(llNewRow - 1,'line_item_notes', ls_sku_desc) 
						lb_2Details = false
					End If
				Else
					

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
					idsDODetail.SetITem(llNewRow,'supp_code',"MHD")  // Supplier
					idsDODetail.SetITem(llNewRow,'user_field3',"DP")  // Permit Number
					idsDODetail.SetItem(llNewRow,'invoice_no','MH-S' + String(ldtToday,'YYMM'))  //Order Number
			
					//Line Item Number * Now setting user line item number since we could be splitting a single customer line into 2 lines for bottles and cases
					lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),9,3)) 
//					If isNumber(lsTemp) Then
//						lllineitemno = Long(lsTemp)
//						idsDODetail.SetItem(llNewRow,'line_item_no',Long(lsTemp))
//					Else
//						llTemp = llLineSeq + 999
//						idsDODetail.SetItem(llNewRow,'line_item_no',Long(llTemp))
//						gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - SO Line Number is not numeric. Line number has been set to: " + string(llTemp))
//					End If
						idsDODetail.SetItem(llNewRow,'line_item_no',llLineSeq)
//						idsDODetail.SetItem(llNewRow,'user_line_item_no',lsTemp)

					//SKU
					lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),12,20)) 
					If lsTemp <> "" Then
						idsDODetail.SetItem(llNewRow,'SKU',lsTemp)

						SELECT UOM_1, UOM_2, Qty_2, HS_Code, User_Field11, Alternate_SKU  
			  			INTO :ls_IM_uom1, :ls_IM_uom2, :ll_IM_qty2,  :ls_IM_hs_code,  :ls_IM_uf11,	:ls_IM_alt_sku  
 			  	 		FROM Item_Master  
			 	  		WHERE Project_ID = :asproject  AND SKU = :lstemp  AND  Supp_Code = 'MHD'   ;

						idsDODetail.SetItem(llNewRow,'alternate_sku', ls_IM_alt_sku) /* Alternate SKU */
					Else /*error*/
						gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos)  + "  - Invalid SKU: " + lsTemp + ". Record will not be processed.")
						lbError = True
					End If

					// SKU Description put into line item notes
					lsTemp = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),33,34)) 
					If lsTemp <> "" Then
						ls_sku_desc = lsTemp
						idsDODetail.SetItem(llNewRow,'line_item_notes', ls_sku_desc)
					End  If


//  QTy1 begins in position 72 but can be up to 5 digits.  The problem it qty1 is followed by 1 space and then character so you can not just get Mid 5 character.  You must look for the 1st blank



					//User Field 1 - OrdQTY - Also Used to calculate Quantity and UOM 1 or 2
//					lsqty1 = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),72,2)) // UOM1
					lsqty1 = Trim(mid(iu_ds.GetItemString(llRowPos,'rec_data'),72,5))
					llPOs = Pos(lsqty1,' ',1)
					If llPOS > 0 THEN 
						llPos = llPos -1
						lsqty1 = Left(lsqty1,llpos)
					End If

					If lsqty1 <> "" and lsqty1 <> "0" Then
						If isnumber(lsqty1) Then //Validate QTY for Numerics
							idsDODetail.SetItem(llNewRow,'quantity',lsqty1)
							idsDODetail.SetITem(llNewRow,'UOM',ls_IM_uom1)
							idsDODetail.SetITem(llNewRow,'user_field1',lsqty1)
							idsDODetail.SetITem(llNewRow,'user_field2',ls_IM_uom1)
						Else
							gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos)  + "  - SO QTY is not numeric." +  lsTemp + " . Record will not be processed.")
							lbError = True
						End If	
					End If
				
					//Else 
					lsQty2 = Trim(Mid(iu_ds.GetItemString(llRowPos,'rec_data'),66,5)) // UOM 2

					If lsqty2 = "" or lsqty2 = "0" Then
						lb_2Details = False //only one detail is needed
					Else
						If isnumber(lsQty2) Then //Validate QTY for Numerics
							ll_qty = dec(lsQty2) * ll_IM_qty2
							If lsqty1 = "" or lsqty1 = "0" Then
								lb_2Details = false //only one detail
								idsDODetail.SetItem(llNewRow,'quantity',string(ll_qty))
								idsDODetail.SetITem(llNewRow,'UOM',ls_IM_uom1)
								idsDODetail.SetITem(llNewRow,'user_field1',lsQty2)
								idsDODetail.SetITem(llNewRow,'user_field2',ls_IM_uom2)
							Else
								lb_2Details = True //More than one detail is needed
							End if
						Else
							gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos)  + "  - SO QTY is not numeric." +  lsTemp + ". Record will not be processed.")
							lbError = True
						End If	
					End If

					idsDODetail.SetItem(llNewRow,'user_field5', ls_IM_hs_Code) /* User Field5 = HS_Code from IM */
					idsDODetail.SetItem(llNewRow,'user_field7',ls_IM_uf11) /* User Field7 = Pack Size from IM*/
					
					// If Case and bottle quantities came on on the same line then we are going to create another order	for the cases	
					IF lb_2Details = true then
						//create second line

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
						idsDODetail.SetITem(llNewRow,'supp_code',"MHD")  // Supplier
						idsDODetail.SetITem(llNewRow,'user_field3',"DP")  // Permit Number
						idsDODetail.SetItem(llNewRow,'invoice_no','MH-S' + String(ldtToday,'YYMM'))  //Order Number
			
						//Line Item Number and user line item number
						idsDODetail.SetItem(llNewRow,'line_item_no',llLineSeq)
//						idsDODetail.SetItem(llNewRow,'user_line_item_no',idsDODetail.GetItemString(llNewRow - 1,'user_line_item_no'))
						idsDODetail.SetItem(llNewRow,'SKU',idsDODetail.GetItemString(llNewRow - 1,'SKU'))
						idsDODetail.SetItem(llNewRow,'alternate_sku', ls_IM_alt_sku) /* Alternate SKU */
						idsDODetail.SetItem(llNewRow,'line_item_notes', ls_sku_desc)
						idsDODetail.SetItem(llNewRow,'quantity',string(ll_qty)) //calculated from above
						idsDODetail.SetITem(llNewRow,'UOM',ls_IM_uom1)
						idsDODetail.SetITem(llNewRow,'user_field1',lsqty2)
						idsDODetail.SetITem(llNewRow,'user_field2',ls_IM_uom2)
						idsDODetail.SetItem(llNewRow,'user_field5', ls_IM_hs_Code) /* User Field5 = HS_Code from IM */
						idsDODetail.SetItem(llNewRow,'user_field7',ls_IM_uf11) /* User Field7 = Pack Size from IM*/
						
					End If
						
					
					
				End If
			Next
		End If 


////Notes stuff
//
//			lsnotetype = Trim(Mid(lsRecData,490,2)) /* Note Type */
//			lsnotetext = Trim(Mid(lsRecData,492,255)) /* Note Text */
//			llnoteseqno = 1
//
//// TAM added Detail Print Notes to Deliver Notes Table
//			If not isNull(lsnotetext) Then
//				
//				llNewNotesRow = idsDONotes.InsertRow(0)
//			
//				//Defaults
//				idsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
//				idsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
//				idsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
//			
//				idsDONotes.SetItem(llNewNotesRow,'line_item_no',llLineItemNo)
//				idsDONotes.SetItem(llNewNotesRow,'note_seq_no',llnoteseqno)
//				idsDONotes.SetItem(llNewNotesRow,'note_type',lsnotetype) 
//				idsDONotes.SetItem(llNewNotesRow,'note_text',lsnotetext) 
//			End If
//			Insert Into Delivery_Notes 
//			(project_id, edi_batch_seq_no, order_seq_no, line_item_no, note_seq_no, note_type, note_text) 
//			values (:asproject, :llbatchseq, :llorderseq, :lllineitemno, :llnoteseqno, :lsnotetype, :lsnotetext) ;
//			 


//Save Changes
liRC = idsDOHeader.Update()
If liRC = 1 Then
	liRC = idsDODetail.Update()
End If

If liRC = 1 Then
	liRC = idsDOAddress.Update()
End If

//If liRC = 1 Then
//	liRC = idsDONotes.Update()
//End If

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

public function integer uf_process_inventory_by_sku_rpt (string asproject, string asinifile, string asemail, string aswhcode);
//Process the WS- Inventory By Sku


Datastore	lds_Rpt
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String			lsFind, lsOutString, lslogOut, lsProject, lsNextRunTime, lsNextRunDate,	&
				lsRunFreq, lsFileName, lsFileNamePath

String			ls_PacificTime
String 		ERRORS, sql_syntax, lsTemp	

Decimal		ldBatchSeq, ldBatchSeq_NonGIG
Integer		liRC
DateTime	ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file

lds_Rpt = Create Datastore
lds_Rpt.Dataobject = 'd_inventory_by_sku_ws'
lirc = lds_Rpt.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION:  " + asproject + ":" + aswhcode +  " Inventory by Sku Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "W&S"

//Retrieve the Data
lsLogout = 'Retrieving ' + asproject + ":" + aswhcode +  ' Inventory by Sku Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = lds_Rpt.Retrieve(asproject, aswhcode)

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '~t'
lsLogOut = 'Processing  ' + asproject + ":" + aswhcode +  ' Inventory by Sku Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//ls_Now = string(now(), 'yyyy-mm-dd hh:mm:ss')
//ls_PacificTime = string(GetPacificTime('GMT', datetime(today(), now())), 'yyyy-mm-dd hh:mm:ss')


lsFileName =  asproject + "_" + aswhcode +  '_Inventory_By_Sku_Report' + String(DateTime( today(), now()), "yyyymmddhhmmss") + "_" + aswhcode + '.XLS'

//Flatfile Out

lsFileNamePath = ProfileString(asInifile, "WS-BOH", "ftpfiledirout","") + '\' + lsFileName

lds_Rpt.SaveAs ( lsFileNamePath, Excel!	, true )

//Archive

//Gets archived when ftp'd

//lsFileNamePath = ProfileString(asInifile, "WS-BOH", "archivedirectory","") + '\' + lsFileName
//
//lds_Rpt.SaveAs ( lsFileNamePath, Excel!	, true )
//
//


Return 0
end function

public function integer uf_process_so_import (string aspath, string asproject);//Process Sales Order files for WS_PR

Integer		liFileNo
				
Long			ll_Rc, llRowPos, llRowCount, llNewRow, llpos
				
String  lsPipe,lsTab, lsRecData, lsTemp, lsLogOut
int i, li_Nbr, li_Nbr2



u_ds_datastore lds_import
datastore lu_ds


lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

lds_import = Create u_ds_datastore
lds_import.dataobject= 'd_import_so_ws_pr'
lds_import.SetTransObject(SQLCA)


//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for WS_PR Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
ll_rc = FileRead(liFileNo,lsRecData)

Do While ll_rc >= 0
	If  ll_rc > 0 Then  // Skip Extra {CR}
		llNewRow = lu_ds.InsertRow(0)
		lu_ds.SetItem(llNewRow,'rec_data',Trim(lsRecData)) 
	End If
	ll_rc = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

llRowCount = lu_ds.RowCount()

//Process each Row
For llRowPos = 1 to llRowCount 
	
	// If Headers are present, import again and skip the header row
	If  Upper(left(lu_ds.GetITemString(llRowPos,'rec_data'),7)) = 'PROJECT' Then 
		continue
	End If

	lsRecData = lu_ds.GetITemString(llRowPos,'rec_data')	
	
	// Replace '|' with tab

	lsPipe = '|'										//Pipe delimiter
	lsTab = char(9)				// Tab Delimiter

	IF len(lsRecData) > 1 THEN
		lstemp = TRIM(lsRecData)
		Do While pos(lstemp,'|') >1
			llpos = pos(lstemp,'|') 
			lsTemp = replace(lsTemp,llpos,1,lsTab)
		loop
	END IF

	lds_import.ImportString(lstemp)

	Next

ll_rc =  gu_nvo_process_files.uf_process_import_server( asproject, Trim( lds_import.Object.DataWindow.Data.XML ) )

return ll_rc

end function

public function integer uf_process_po_import (string aspath, string asproject);//Process Purchase Order files for WS_PR

Integer		liFileNo
				
Long			ll_Rc, llRowPos, llRowCount, llNewRow, llpos
				
String  lsPipe,lsTab, lsRecData, lsTemp, lsLogOut
int i, li_Nbr, li_Nbr2



u_ds_datastore lds_import
datastore lu_ds


lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

lds_import = Create u_ds_datastore
lds_import.dataobject= 'd_import_po_ws_pr'
lds_import.SetTransObject(SQLCA)


//Open the File
lsLogOut = '      - Opening File for Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for WS_PR Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
ll_rc = FileRead(liFileNo,lsRecData)

Do While ll_rc >= 0
	If  ll_rc > 0 Then  // Skip Extra {CR}
		llNewRow = lu_ds.InsertRow(0)
		lu_ds.SetItem(llNewRow,'rec_data',Trim(lsRecData)) 
	End If
	ll_rc = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

llRowCount = lu_ds.RowCount()

//Process each Row
For llRowPos = 1 to llRowCount 
	
	// If Headers are present, import again and skip the header row
	If  Upper(left(lu_ds.GetITemString(llRowPos,'rec_data'),7)) = 'PROJECT' Then 
		continue
	End If

	lsRecData = lu_ds.GetITemString(llRowPos,'rec_data')	
	
	// Replace '|' with tab



	lsPipe = '|'										//Pipe delimiter
	lsTab = char(9)				// Tab Delimiter


	IF len(lsRecData) > 1 THEN
		lstemp = TRIM(lsRecData)
		Do While pos(lstemp,'|') >1
			llpos = pos(lstemp,'|') 
			lsTemp = replace(lsTemp,llpos,1,lsTab)
		loop
	END IF

	lds_import.ImportString(lstemp)

	Next

ll_rc =  gu_nvo_process_files.uf_process_import_server( asproject, Trim( lds_import.Object.DataWindow.Data.XML ) )

return ll_rc

end function

on u_nvo_proc_ws.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_ws.destroy
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

