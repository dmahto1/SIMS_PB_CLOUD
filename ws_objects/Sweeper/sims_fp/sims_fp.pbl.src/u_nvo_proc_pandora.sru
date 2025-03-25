$PBExportHeader$u_nvo_proc_pandora.sru
$PBExportComments$Process Pandora Files
forward
global type u_nvo_proc_pandora from nonvisualobject
end type
type str_finance_record from structure within u_nvo_proc_pandora
end type
end forward

type str_Finance_Record from structure
	string		wh_code
	string		Intl
	string		In_Out
	datetime		Complete_Date
	string		supp_invoice_no
	long		line_item_no
	string		FromCntry_EU
end type

global type u_nvo_proc_pandora from nonvisualobject
end type
global u_nvo_proc_pandora u_nvo_proc_pandora

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsTOheader,	&
				idsTODetail,	&
				idsASNHeader,	&
				idsASNPackage,	&
				idsASNItem, &
				idsDONotes, &
				idsRONotes, &
				idsROMain, &
				idsRODetail

//06-JUN-2017 :Madhu Added OM Respective Datastores for PINT
datastore idsOMPO, &
			idsOMPODetail, &
			idsOMCReceipt, &
			idsOMCReceiptDetail, &
			idsOMAReceiptQueue, &
			idsOMReceiptDetailSerial, &
			idsOMQROMain, &
			idsOMQRODetail
			
//2017-07 - TAM Added OM Respective Datastores for PINT
datastore idsOMCDelivery, &
			idsOMCDeliveryDetail, &
			idsOMADeliveryQueue, &
			idsOMASOCQueue, &
			idsOMQDelivery, &
			idsOMQDeliveryDetail, &
			idsOMQDeliveryAttr, &
			idsOMEXP, &
			idsOMCSOCDelivery, &
			idsOMCSOCDeliveryAttr, &
			idsOMCSOCDeliveryDetail, &
			idsOMCDeliveryAttr
			
//TimA 05/30/12 Pandora issue #425
//Need to store the warehouse and invoice number for later use.
//If the order passes so_rose and delivery order updates then send an email notification.
String is_WhCode
String is_Invoice

String isFileName

long il_X,il_returnvalue //08-Oct-2015 :Madhu Added il_returnvalue
String is_om_client_id

//TAM 2018/11 S26846			
datastore idsOMQInvTran, idsOMAInvQtyOnHand
end variables

forward prototypes
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_itemmaster (string aspath, string asproject)
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_boh ()
public function integer uf_process_item_cost (string aspath, string asproject)
public function datetime getpacifictime (string aswh, datetime adtdatetime)
public function string nonull (string as_str)
public function integer uf_process_data_dump (string asinifile)
public function integer uf_process_new_replace_so (string aspath, string asproject)
public function integer uf_process_po_rose (string aspath, string asproject)
public function integer uf_process_so_rose (string aspath, string asproject)
public function integer uf_process_to_rose (string aspath, string asproject)
public function integer uf_process_cityblock_so (string aspath, string asproject)
public function integer uf_process_pandora_decom_mrb_aging_rpt (string asinifile, string asemail)
public function integer uf_process_pandora_open_rma_po_rpt (string asinifile, string asemail)
public function integer uf_process_so_rose_archive (string aspath, string asproject)
public function integer uf_process_boh_rose ()
public function integer uf_process_delivery_date (string aspath, string asproject)
protected function boolean uf_otm_fields_modified (string as_action, datastore ads_current, datastore ads_original, long al_row)
public function integer uf_process_po (string aspath, string asproject)
public function integer uf_process_boh_hourly ()
public function integer uf_process_holds (string asproject, string as_otm_status)
public subroutine uf_sendemailnotification (string aswh, string asinvoice, string astypeoforder)
public function integer uf_process_mim_receipt_ack (string aspath, string asproject)
public function boolean getcartonserialdata (string asproject, string aspallet, string ascarton, string asserial)
public function integer uf_process_mim_demand (string aspath)
public function integer uf_process_xcel_file (string asproject, string aspath, string asfile)
public function integer uf_process_mim_demand_txt (string asproject, string aspath, string asfile)
public function integer uf_process_hourly_receiving ()
public function integer uf_process_mim_outbound_report ()
public function integer uf_process_confirmation_check ()
public function integer uf_process_om_inbound (string asproject)
public function integer uf_process_om_receipt (readonly string asproject)
public function integer uf_process_om_delivery (readonly string asproject)
public function integer uf_process_om_warehouse_order (readonly datastore adsorderlist)
public function integer uf_process_om_soc (string asproject)
public function integer uf_process_om_warehouse_order_oc (readonly datastore adsorderlist)
public function integer uf_process_om_inbound_acknowledge (string asproject, string asrono, string asaction)
public function datetime getesd (string aswhcode, datetime adtwhtime, datetime adtrdd, string asmimorder, string ascarrier, string ascust)
public function integer uf_process_load_plan (string aspath, string asproject)
public function str_parms uf_process_load_plan_rejection (string as_project, string as_wh_code, string as_trans_type, string as_load_id, string as_customer_order, datetime adt_trans_time_stamp)
public function datetime convert_string_to_datetime (string as_data)
public function integer uf_sync_om_inventory (string asproject, string aswarehouse)
public function integer uf_process_boh_sap ()
end prototypes

public function integer uf_process_so (string aspath, string asproject);//Process Material Transfer (Sales Order) for PANDORA (used SIKA as a template)

Datastore	ldsDOHeader, ldsDODetail, lu_ds //, ldsDOAddress, ldsDONotes
				
String		lsLogout,lsRecData,lsTemp,	lswarehouse, lsErrText, lsSKU, lsRecType, &
				lsDate, ls_invoice_no, ls_Note_Type, ls_search, lsNotes, ls_temp, lsCommentDest
//				lsSoldToAddr1, lsSoldToAddr2, lsSoldToAddr3, lsSoldToAddr4, lsSoldToStreet,	&
//				lsSoldToZip, lsSoldToCity, lsSoldToState, lsSoldToCountry, lsSoldToTel, 

Integer		liFileNo,liRC, li_line_item_no, liSeparator
				
Long			llRowCount,	llRowPos,llNewRow, llNewDetailRow ,llOrderSeq,	llBatchSeq,	llLineSeq,llCount,		&
				llCONO, llRoNO, llLineItemNo, llOwner, llNewAddressRow, llNewNotesRow, li_find
				
//Decimal		ldQty, ldPrice
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError, lbSoldToAddress 
// string		lsBT_Address[ ] //last three BT Notes are City,State,Zip. Up to 4 other lines.
// string		lsBOLNotes[], lsBOLNote //capture BOL Notes to write to Remark field (& possibly Shipping_Instructions)
string 		lsInvoice, lsPrevInvoice, lsCustNum, lsPrevInvoice_Detail
//integer 		i, liBTAddr, liBOLNote
string			lsOwnerCD, lsOwnerCD_Prev, lsOwnerID, lsWH
string	         lsCustName, lsAddr1, lsAddr2, lsCity, lsState, lsZip, lsCountry, lsTel, lsCustType
String		   lsToProject //TimA 10/15/14 Pandora issue #904

ldtToday = DateTime(today(),Now())
				
lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

ldsDOHeader = Create u_ds_datastore
ldsDOHeader.dataobject = 'd_shp_header'
ldsDOHeader.SetTransObject(SQLCA)

ldsDODetail = Create u_ds_datastore
ldsDODetail.dataobject = 'd_shp_detail'
ldsDODetail.SetTransObject(SQLCA)

//ldsDOAddress = Create u_ds_datastore
//ldsDOAddress.dataobject = 'd_mercator_do_address' //Delivery_Alt_Address
//ldsDOAddress.SetTransObject(SQLCA)

//ldsDONotes = Create u_ds_datastore
//ldsDONotes.dataobject = 'd_mercator_do_notes'
//ldsDONotes.SetTransObject(SQLCA)
 //SELECT Delivery_Notes_ID, Delivery_Notes.Project_ID, EDI_Batch_Seq_No, Order_Seq_No, 
 //space(30) as Invoice_no, Line_Item_No, Note_Type, Note_seq_no, Note_Text
 //FROM Delivery_Notes   

//Open the File
lsLogOut = '      - Opening File for Pandora Material Transfer (Sales Order) Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath, LineMode!, Read!, LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for PANDORA Material Transfer Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo, lsRecData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow, 'rec_data', lsRecData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

//Get the next available file sequence number
// 03/09 llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Outbound_Header', 'EDI_Batch_Seq_No')
// 03/09 -  using edi_INbound_header because web does and it will crash when trying to re-use a sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = lu_ds.RowCount()

//Process each Row
For llRowPos = 1 to llRowCount
	//lsRecData = lu_ds.GetItemString(llRowPos, 'rec_data')
	lsRecData = Trim(lu_ds.GetItemString(llRowPos, 'rec_Data'))
		
	//Process header, Detail (sika..., or header/line notes) */
	//lsRecType = Upper(Mid(lsRecData,7,2))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	

	Choose Case lsRecType
		//HEADER RECORD
		Case 'DM' /* Header */
			llNewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0

		//Record Defaults
			ldsDOHeader.SetItem(llNewRow, 'Action_cd', 'A') /*always a new Order*/
			ldsDOHeader.SetITem(llNewRow, 'project_id', asProject) /*Project ID*/
			ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow, 'ftp_file_name', aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow, 'Status_cd', 'N')
			ldsDOHeader.SetItem(llNewRow, 'order_Type', 'S') /*default to SALE. we'll set it to 'Z' later if appropriate */
			ldsDOHeader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
						
		//From File			
//			ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
					
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
		
			//User_Field7 - Transaction Type (passed back to Pandora in Inventory Transaction Confirmation)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Transaction Type' field. Record will not be processed.")
			End If						
			ldsDOheader.SetItem(llNewRow, 'User_Field7', lsTemp) 
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//'From' Location (blank here - being mapped to Owner_CD (Owner_ID) on Detail)
			//  but need to look up WH_Code (stored in Customer.UF2...
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'From' Location. Record will not be processed.")
			End If
			// ldsDOheader.SetItem(llNewRow, 'User_Field2', Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			//'To' Location - mapped to Cust_Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'To' Location. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'Cust_Code', Trim(lsTemp))
			//reset customer variables...
			lsCustName = ""; lsAddr1=""; lsAddr2=""; lsCity=""; lsState=""; lsZip=""; lsCountry=""; lsTel=""; lsCustType=""
			//grab customer information, if available....
			select Cust_name, Address_1, Address_2, City, State, Zip, Country, Tel, customer_type
			into :lsCustName, :lsAddr1, :lsAddr2, :lsCity, :lsState, :lsZip, :lsCountry, :lsTel, :lsCustType
			from customer
			where project_id = 'pandora'
			and cust_code = :lsTemp;
			
			ldsDOHeader.SetItem(llNewRow,'Cust_Name', lsCustName)
			ldsDOHeader.SetItem(llNewRow,'Address_1', lsAddr1)
			ldsDOHeader.SetItem(llNewRow,'Address_2', lsAddr2)
			//ldsDOHeader.SetItem(llNewRow,'Address_3',Trim(Mid(lsRecData,1058,40)))
			ldsDOHeader.SetItem(llNewRow,'City', lsCity) 
			ldsDOHeader.SetItem(llNewRow,'State', lsState) 
			ldsDOHeader.SetItem(llNewRow,'Zip', lsZip) 
			ldsDOHeader.SetItem(llNewRow,'Country', lsCountry) 
			ldsDOHeader.SetItem(llNewRow,'tel', lsTel) 
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			//'To' Project - mapped to User_Field8
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'To' Project. Record will not be processed.")
			End If
			//TimA 10/15/14 Pandora issue #904.  Store the To Project into a varable lsToProject to be use in the Detail Record below.
			lsToProject = Trim ( lsTemp )
			ldsDOHeader.SetItem(llNewRow, 'User_Field8', Trim(lsTemp))
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			//Material Transfer Number - mapped to Invoice
			If Pos(lsRecData,'|') > 0 Then
				lsInvoice = trim(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Material Transfer Number. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'Invoice_no', lsInvoice)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsInvoice) + 1))) /*strip off to next Column */
						
			//Shipping Method - mapped to Transport Mode
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Shipping Method. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'Transport_Mode', Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			//Shipping Terms - mapped to freight terms
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Material Transfer Terms. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'freight_terms', Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			//Comments - mapped to remark
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Material Transfer Number. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'remark', Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Requestor Name - mapped to UF9 -- 4/14/09 - now mapping to uf11
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow, 'user_field11', Trim(lsTemp))
									
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Jxlim 03/22/2012 BRD #385 Hard code SCH CD (user_field1) to 'DOS' for MIM Outbounds
			ldsDOHeader.SetItem(llNewRow, 'user_field1', 'DOS')
			
			//Request Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = Trim(lsRecData)
			End If
						
			//ldsDOHeader.SetItem(llNewRow,'Request_date',Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2))
			//dts 2015/12/01 - Pandora now (possibly) including the time portion (in format YYYYMMDDHHMM)
			string lsTime, lsDateTime
			lsTime = mid(lsTemp,9,4)
			lsDateTime = Left(lsTemp,4) + "/" + Mid(lsTemp,5,2) + "/" + Mid(lsTemp,7,2) + " " + Mid(lsTemp,9,2) + ":" + Mid(lsTemp,11,2)
			ldsDOHeader.SetItem(llNewRow,'Request_date',lsDateTime)

			
//pandora			if lsInvoice <> lsPrevInvoice and llNewRow > 1 then
//				lsPrevInvoice = lsInvoice
				/* load Bill-To Address info and BOL Notes for previous Order...
				   - BT Address is coming in as a series of Notes
					  - we'll capture them in lsBT_Address array and then
					    write them to ldsDOAddress when done with the order.
				     - last three BT Notes are City,State,Zip. Up to 4 other lines.
					- BOL Notes are being written to Notes table and Header-level notes 
					  are writen to Remark field as well (so they are visible in w_do)
				*/
				//liLast = Upperbound(lsBT_Address)
//pandora				if liBTAddr > 0 then
//					llNewAddressRow = ldsDOAddress.InsertRow(0)
//					ldsDOAddress.SetItem(llNewAddressRow, 'project_id', asProject) /*Project ID*/
//					ldsDOAddress.SetItem(llNewAddressRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
//					ldsDOAddress.SetItem(llNewAddressRow, 'order_seq_no', llOrderSeq - 1) //we're on next order now (but setting BT Address for previous order)...
//					ldsDOAddress.SetItem(llNewAddressRow, 'address_type', 'BT') /* Bill To Address */
//					ldsDOAddress.SetItem(llNewAddressRow, 'address_1', lsBT_Address[1]) /*Bill To Name - using Address_1 because it's 40 chars instead of 20*/
//					if liBTAddr > 4 then ldsDOAddress.SetItem(llNewAddressRow, 'address_2', lsBT_Address[2]) /* BT Addr 1*/
//					if liBTAddr > 5 then ldsDOAddress.SetItem(llNewAddressRow, 'address_3', lsBT_Address[3]) /* BT Addr 1*/
//					if liBTAddr > 6 then ldsDOAddress.SetItem(llNewAddressRow, 'address_4', lsBT_Address[4]) /* BT Addr 2*/
//					//if liBTAddr > 7 then ldsDOAddress.SetItem(llNewAddressRow, 'address_4', lsBT_Address[5]) /* BT Addr 3*/
//					if liBTAddr > 2 then ldsDOAddress.SetItem(llNewAddressRow, 'City', lsBT_Address[liBTAddr - 2]) /* BT City */
//					if liBTAddr > 1 then ldsDOAddress.SetItem(llNewAddressRow, 'State', lsBT_Address[liBTAddr - 1]) /*BT State */
//					ldsDOAddress.SetItem(llNewAddressRow, 'Zip', lsBT_Address[liBTAddr]) /*Bill To Zip */
//					//ldsDOAddress.SetItem(llNewAddressRow, 'Country', Trim(Mid(lsRecdata, 713, 20))) /* BT Country */
//					//ldsDOAddress.SetItem(llNewAddressRow, 'tel', Trim(Mid(lsRecdata, 733, 20))) /*BT Phone*/
//					for i = 1 to liBTAddr
//						lsBT_Address[i] = ''
//					next
//					liBTAddr = 0
//				end if
//				//load BOL Header Notes into DM.Remark (and DM.Shipping_Instructions if > 250 chars)
//				if liBolNote > 0 then
//					lsBOLNote = lsBOLNotes[1]
//					for i = 2 to liBOLNote
//						//build sting of bol notes from array lsBOLNotes[]
//						lsBOLNote += ' ' + lsBOLNotes[i]
//						//	messagebox("TEMPO-1, Len: " + string(len(lsBOLNote)), lsBOLNOte)
//					next
//					//We're setting Remark for the previous order (so llNewRow - 1)
//					ldsDOHeader.SetItem(llNewRow - 1, 'remark', left(lsBOLNote, 250))
//					if len(lsBOLNote) > 250 then
//						ldsDOHeader.SetItem(llNewRow, 'shipping_instructions_text', mid(lsBOLNote, 251, 250)) 
//					end if
//					liBOLNote = 0
//				end if
					
//			end if			
			
		
			//If we have Bill to, or Interim Dest Addresses, we will build alt address records
		 				
			//Bill To
			/* SIKA is sending Bill-To Address in as Notes (with note type 'ADR...')
			 - See Notes Processing....
					If Trim(Mid(lsRecData, 306, 445)) > '' Then
						llNewAddressRow = ldsDOAddress.InsertRow(0)
						ldsDOAddress.SetItem(llNewAddressRow, 'project_id', asProject) /*Project ID*/
						ldsDOAddress.SetItem(llNewAddressRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
						ldsDOAddress.SetItem(llNewAddressRow, 'order_seq_no', llOrderSeq) 
					
						ldsDOAddress.SetItem(llNewAddressRow, 'address_type', 'BT') /* Bill To Address */
						ldsDOAddress.SetItem(llNewAddressRow, 'Name', Trim(Mid(lsRecdata, 336, 15))) /*Bill To Number*/
						ldsDOAddress.SetItem(llNewAddressRow, 'address_1', Trim(Mid(lsRecdata, 351, 40))) /* Bill To Cust Name*/
						ldsDOAddress.SetItem(llNewAddressRow, 'address_2', Trim(Mid(lsRecdata, 511, 40))) /* BT Addr 1*/
						ldsDOAddress.SetItem(llNewAddressRow, 'address_3', Trim(Mid(lsRecdata, 551, 40))) /*BT addr 2*/
						ldsDOAddress.SetItem(llNewAddressRow, 'address_4', Trim(Mid(lsRecdata, 591, 40))) /*BT addr 3*/
						ldsDOAddress.SetItem(llNewAddressRow, 'City', Trim(Mid(lsRecdata, 631, 35))) /* BT City */
						ldsDOAddress.SetItem(llNewAddressRow, 'State', Trim(Mid(lsRecdata, 701, 2))) /*BT State */
						ldsDOAddress.SetItem(llNewAddressRow, 'Zip', Trim(Mid(lsRecdata, 703, 10))) /*Bill To Zip */
						ldsDOAddress.SetItem(llNewAddressRow, 'Country', Trim(Mid(lsRecdata, 713, 20))) /* BT Country */
						ldsDOAddress.SetItem(llNewAddressRow, 'tel', Trim(Mid(lsRecdata, 733, 20))) /*BT Phone*/
					End If /*Bill To address exists*/
					*/
			
			/* TEMPO - Notes? (still part of OM record)
			Routing Comment 1	O	1838
			Routing Comment 2	O	1868
			Routing Comment 3	O	1898
			Routing Comment 4	O	1928
			Routing Comment 5	O	1958
			*/
			
			//Intermediate Dest
			//If Trim(Mid(lsRecData, 306, 445)) > '' Then
//			If Trim(Mid(lsRecData, 1988, 370)) > '' Then
//				llNewAddressRow = ldsDOAddress.InsertRow(0)
//				ldsDOAddress.SetITem(llNewAddressRow, 'project_id', asProject) /*Project ID*/
//				ldsDOAddress.SetItem(llNewAddressRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
//				ldsDOAddress.SetItem(llNewAddressRow, 'order_seq_no', llOrderSeq) 
//			
//				ldsDOAddress.SetItem(llNewAddressRow, 'address_type', 'ID') /*Intermediate Dest*/
//				ldsDOAddress.SetItem(llNewAddressRow, 'Name', Trim(Mid(lsRecdata, 1988, 40))) 
//				ldsDOAddress.SetItem(llNewAddressRow, 'address_1', Trim(Mid(lsRecdata, 2148, 40))) 
//				ldsDOAddress.SetItem(llNewAddressRow, 'address_2', Trim(Mid(lsRecdata, 2188, 40))) 
//				ldsDOAddress.SetItem(llNewAddressRow, 'address_3', Trim(Mid(lsRecdata, 2228, 40)))
//				ldsDOAddress.SetItem(llNewAddressRow, 'City', Trim(Mid(lsRecdata, 2268, 35))) 
//				ldsDOAddress.SetItem(llNewAddressRow, 'State', Trim(Mid(lsRecdata, 2338, 2))) 
//				ldsDOAddress.SetItem(llNewAddressRow, 'Zip', Trim(Mid(lsRecdata, 2340, 10))) 
//				ldsDOAddress.SetItem(llNewAddressRow, 'Country', Trim(Mid(lsRecdata, 2350, 20))) 
//			End If /*Intemediate Dest address exists*/
//			
			
		// DETAIL RECORD
		Case 'DD' /*Detail */
//TEMPO?			lbDetailError = False
			llNewDetailRow = 	ldsDODetail.InsertRow(0)
			llLineSeq ++

		//Add detail level defaults
			ldsDODetail.SetITem(llNewDetailRow, 'supp_code', 'PANDORA') /* 2/14/09 */
			ldsDODetail.SetItem(llNewDetailRow, 'project_id', asproject) /*project*/
			ldsDODetail.SetItem(llNewDetailRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			ldsDODetail.SetItem(llNewDetailRow, 'order_seq_no', llOrderSeq) 
			ldsDODetail.SetItem(llNewDetailRow, "order_line_no", string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'N')
			//ldsDODetail.SetItem(llNewDetailRow, 'Inventory_type', 'N') /*normal inventory*/
				
		//From File
		lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
		
		//Invoice No
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Invoice No' field. Record will not be processed.")
		End If						
		ldsDODetail.SetItem(llNewDetailRow, 'Invoice_no', lsTemp) 
		
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		//'From' Project - mapped to PO_NO
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'From' Project. Record will not be processed.")
		End If	
		ldsDODetail.SetItem(llNewDetailRow, 'po_no', lsTemp) 
		//TimA 10/15/14 Pandora Issue #904.  Add the To Project to User_Field5
		ldsDODetail.SetItem(llNewDetailRow, 'User_Field5', lsToProject) 
		
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		//SKU
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Part Number. Record will not be processed.")
		End If	
		ldsDODetail.SetItem(llNewDetailRow, 'sku', lsTemp) 
		
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		//Quantity
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Quantity. Record will not be processed.")
		End If
		ldsDODetail.SetItem(llNewDetailRow, 'quantity', lsTemp) 
		
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		//Material Transfer Line Number
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Material Transfer Line Number. Record will not be processed.")
		End If	
		ldsDODetail.SetItem(llNewDetailRow, 'line_item_no', dec(lsTemp)) 
		
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		//'From' Location - mapped to Owner_ID (after look-up via Owner_CD)
		// - 4/12/09 - Also setting DM.UF2 to 'FROM' Location from file
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			//lbError = True
			//gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'From' Location. Record will not be processed.")
			lsTemp = lsRecData
		End If	
		//ldsDODetail.SetItem(llNewDetailRow, 'line_item_no', lsTemp) 
		lsOwnerCD = lsTemp
		if lsOwnerCD <> lsOwnerCD_Prev then
			//Need to look up Owner_CD and WH_Code (but shouldn't look it up for each row if it doesn't change)
			//  - do we need to validate that the WH_Code doesn't change within an Order?
			lsOwnerID = ''
			select owner_id into :lsOwnerID
			from owner
			where project_id = :asProject and owner_cd = :lsOwnerCD;
			lsOwnerCD_Prev = lsOwnerCD
		
			select user_field2 into :lsWH
			from customer
			where project_id = 'PANDORA'
			and cust_code = :lsOwnerCD;
		end if
		if lsInvoice <> lsPrevInvoice then
		  //set wh_code when the invoice changes
			ldsDOheader.SetItem(llNewRow, 'wh_code', lsWH)
			lsPrevInvoice = lsInvoice
			//need to set order type to 'Z' (for warehouse transfer) if customer is of type WH
			if lsCustType = 'WH' then
				ldsDOHeader.SetItem(llNewRow, 'order_Type', 'Z') /* warehouse Transfer*/
			//	ldsDOHeader.SetItem(llNewRow, 'user_field2', lsOwnerCD) /* warehouse Transfer*/
			end if		
		end if
		ldsDODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
		ldsDOHeader.SetItem(llNewRow, 'user_field2', lsOwnerCD) /* 04/09 - PCONKL - Moved outside of if statement to unconditionally set the From Location */

		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		//LOT_No - added for MIM (Breadboard)
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lsTemp = lsRecData
		End If	
		ldsDODetail.SetItem(llNewDetailRow, 'lot_no', lsTemp) 

		//TimA 10/15/14 Pandora Issue #904.  Add the To Project to User_Field5
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		//To Project - 
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lsTemp = lsRecData
		End If	
		ldsDODetail.SetItem(llNewDetailRow, 'User_Field5', lsTemp) 

//		//TimA 10/15/14 Pandora Issue #904.  Add the To Project to User_Field5
//		ldsDODetail.SetItem(llNewDetailRow, 'User_Field5', lsToProject) 	
/*pandora		Case 'OC', 'DC' /* Header/Line Notes*/
			IF lsRecType = 'OC' THEN
				lsCommentDest = Trim(Mid(lsRecdata, 70, 6)) 
				/* 6-char Y/N flags
					Per Tom Leap:
					Flag 1 = Picking Note (set for LMS directed text of "PIK")
					Flag 2 = Packing Note (set for LMS directed text of "PAK" or "TXT")
					Flag 3 = Address Note (set for LMS directed text of "ADR")
					Flag 4 = BOL Note (set for LMS directed text of "BOL" or "TXT")
					Flag 5 = ? Note (set for LMS directed text of "MNF")  I'll try to get clarification from provia as to exactly what this was/is for since we don't have this text type defined.
					Flag 6 = ? Note (set for LMS directed text of "CHK") I'll try to get clarification from provia as to exactly what this was/is for since we don't have this text type defined.
					* 01/03/08
					- Flag 3 = 'Y' means it's a Bill-To address line...
					- If both Flag 2 and Flag 4 are 'Y', then note is just text and not to be printed anywhere
				*/
//				lsNotes=Trim(Mid(lsRecdata, 76, 40))
//				// Ignore notes that say 'Notes for Order Number' or 'Function Code' or empty notes...
//				IF pos(Trim(lsNotes), 'Notes for Order Number') = 0 and pos(Trim(lsNotes), 'Function Code') = 0 and lsNotes <> '' THEN	
//					ls_search = 'TXT         :'
//					IF pos(Trim(lsNotes), ls_search) > 0 THEN
//						lsNotes=mid(Trim(lsNotes), (len(ls_search)+1))
//					END IF
//					if mid(lsCommentDest, 3, 1) = 'Y' then //Bill-to address
//						//lsNotes = 'BT:' + lsNotes
//						lsRecType = 'BT'
//						liBTAddr ++
//						lsBT_Address[liBTAddr] = lsNotes
//					end if
					/* Set lsRecType = 'PL' if this is a P/L note (lsCommentDest.2 = 'Y')
						- Set lsRecType = 'BL' if this is a BOL note (lsCommentDest.4 = 'Y')
						- Set lsRecType = 'PB' if this is BOTH a P/L and a BOL note 
						!!Assuming it can't be both a BT note and a PL / BOL Note
					*/
/*								if mid(lsCommentDest, 2, 1) = 'Y' then //Packing List note
									if mid(lsCommentDest, 4, 1) = 'Y' then //also a Bill of Lading note
										lsRecType = 'PB'
									else
										lsRecType = 'PL'
									end if
								else
									// Not a P/L note but it is a BOL note... (lsCommentDest.4 = 'Y')
									if mid(lsCommentDest, 4, 1) = 'Y' then //Bill of Lading note
										lsRecType = 'BL'
									end if
								end if
*/
					if mid(lsCommentDest, 4, 1) = 'Y' then //BOL note
						if mid(lsCommentDest, 2, 1) = 'Y' then //also a Pack List note
							lsRecType = 'PB'
						else
							lsRecType = 'BL'
						end if
						//add BOL note to Array to write to DM.Remark (& possibly DM.Shipping_Intructions) at the end (of the order)
//						liBOLNote ++
//						lsBOLNotes[liBOLNote] = lsNotes
					else
						// Not a BOL note but it is a P/L note... (lsCommentDest.2 = 'Y')
						if mid(lsCommentDest, 2, 1) = 'Y' then //PackList note
							lsRecType = 'PL'
						end if
					end if

				Else 
					Continue
				End If
			else // DC...
				lsCommentDest = Trim(Mid(lsRecdata, 76, 6)) 
				lsNotes=Trim(Mid(lsRecdata, 82, 40))
				
				/* Set lsRecType = 'PL' if this is a P/L note (lsCommentDest.2 = 'Y')
				   - Set lsRecType = 'BL' if this is a BOL note (lsCommentDest.4 = 'Y')
					- Set lsRecType = 'PB' if this is BOTH a P/L and a BOL note 
				*/
				if mid(lsCommentDest, 2, 1) = 'Y' then //Packing List note
					if mid(lsCommentDest, 4, 1) = 'Y' then //also a Bill of Lading note
						lsRecType = 'PB'
					else
						lsRecType = 'PL'
					end if
				else
					// Not a P/L note but it is a BOL note... (lsCommentDest.4 = 'Y')
					if mid(lsCommentDest, 4, 1) = 'Y' then //Bill of Lading note
						lsRecType = 'BL'
					end if
				end if
			End IF
			
			llNewNotesRow = ldsDONotes.InsertRow(0)
			
			//Defaults
			ldsDONotes.SetItem(llNewNotesRow, 'project_id', asProject) /*Project ID*/
			ldsDONotes.SetItem(llNewNotesRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			ldsDONotes.SetItem(llNewNotesRow, 'order_seq_no', llOrderSeq) 
			
			//From File
			ldsDONotes.SetItem(llNewNotesRow, 'note_type', lsRecType) /* Note Type */
			ldsDONotes.SetItem(llNewNotesRow, 'invoice_no', Trim(Mid(lsRecdata, 30, 30)))
						
			//dts - should set lsNoteSeq and lsLineItem depending on Header/detail and then wouldn't need condition here...
			If lsRecType = 'DC' or lsRecType = 'BL' Then /*detail*/
				ldsDONotes.SetItem(llNewNotesRow, 'note_seq_no', Long(Trim(Mid(lsRecdata, 70, 6))))
				ldsDONotes.SetItem(llNewNotesRow, 'line_item_no', Long(Trim(Mid(lsRecdata, 64, 6))))
				//ldsDONotes.SetItem(llNewNotesRow, 'note_text', Trim(Mid(lsRecdata, 82, 40)))
				ldsDONotes.SetItem(llNewNotesRow, 'note_text', lsNotes)
			Else /*header */
				ldsDONotes.SetItem(llNewNotesRow, 'note_seq_no', Long(Trim(Mid(lsRecdata, 64, 6))))
				ldsDONotes.SetItem(llNewNotesRow, 'line_item_no', 0)
				//ldsDONotes.SetItem(llNewNotesRow, 'note_text', Trim(Mid(lsRecdata, 76, 40)))
				ldsDONotes.SetItem(llNewNotesRow, 'note_text', lsNotes)
			End IF
pandora */		
		Case Else /*Invalid rec type */
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue /*Next Record */
			
	End Choose /*Header, Detail or Notes */
	
Next /*file record */
/* pandora
//load Bill-To Address info for Last Order...
// - last three BT Notes are City,State,Zip. Up to 4 other lines.
if liBTAddr > 0 then
	llNewAddressRow = ldsDOAddress.InsertRow(0)
	ldsDOAddress.SetItem(llNewAddressRow, 'project_id', asProject) /*Project ID*/
	ldsDOAddress.SetItem(llNewAddressRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
	ldsDOAddress.SetItem(llNewAddressRow, 'order_seq_no', llOrderSeq) //Here we're still on the current order (as opposed to above)...
	ldsDOAddress.SetItem(llNewAddressRow, 'address_type', 'BT') /* Bill To Address */
	ldsDOAddress.SetItem(llNewAddressRow, 'address_1', lsBT_Address[1]) /*Bill To Name - using Address_1 because it's 40 chars instead of 20*/
	if liBTAddr > 4 then ldsDOAddress.SetItem(llNewAddressRow, 'address_2', lsBT_Address[2]) /* BT Addr 1*/
	if liBTAddr > 5 then ldsDOAddress.SetItem(llNewAddressRow, 'address_3', lsBT_Address[3]) /* BT Addr 1*/
	if liBTAddr > 6 then ldsDOAddress.SetItem(llNewAddressRow, 'address_4', lsBT_Address[4]) /* BT Addr 2*/
	//if liBTAddr > 7 then ldsDOAddress.SetItem(llNewAddressRow, 'address_4', lsBT_Address[5]) /* BT Addr 3*/
	if liBTAddr > 2 then ldsDOAddress.SetItem(llNewAddressRow, 'City', lsBT_Address[liBTAddr - 2]) /* BT City */
	if liBTAddr > 1 then ldsDOAddress.SetItem(llNewAddressRow, 'State', lsBT_Address[liBTAddr - 1]) /*BT State */
	ldsDOAddress.SetItem(llNewAddressRow, 'Zip', lsBT_Address[liBTAddr]) /*Bill To Zip */
	//ldsDOAddress.SetItem(llNewAddressRow, 'Country', Trim(Mid(lsRecdata, 713, 20))) /* BT Country */
	//ldsDOAddress.SetItem(llNewAddressRow, 'tel', Trim(Mid(lsRecdata, 733, 20))) /*BT Phone*/
end if

//load BOL Header Notes into DM.Remark (& possibly Shipping_Instructions)
if liBolNote > 0 then
	lsBOLNote = lsBOLNotes[1]
	for i = 2 to liBOLNote
		//build sting of bol notes from array lsBOLNotes[]
		lsBOLNote += ' ' + lsBOLNotes[i]
	// messagebox("TEMPO, Len: " + string(len(lsBOLNote)), lsBOLNOte)
	next
	ldsDOHeader.SetItem(llNewRow, 'remark', left(lsBOLNote, 250)) 
	if len(lsBOLNote) > 250 then
		ldsDOHeader.SetItem(llNewRow, 'shipping_instructions_text', mid(lsBOLNote, 251, 250)) 
	end if
end if
pandora */

//Save Changes
liRC = ldsDOHeader.Update()
If liRC = 1 Then
	liRC = ldsDODetail.Update()
End If
//If liRC = 1 Then
//	liRC = ldsDOAddress.Update()
//End If
//If liRC = 1 Then
//	liRC = ldsDONotes.Update()
//End If
If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new SO Records to database "
	FileWrite(gilogFileNo, lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

If lbError Then Return -1

Return 0
end function

public function integer uf_process_itemmaster (string aspath, string asproject);//Process Item Master (IM) Transaction for Pandora

String		lsData, lsTemp, lsLogOut, lsStringData, lsSKU, 	lsCOO, lsSupplier, lsSetSerializedInd, lsGetSerializedInd, lsMsg
String 	ls_action, ls_ind, sql_syntax, ls_Errors, lsFind, ls_supp[]
String 	ls_description, ls_uom1, ls_weight1, ls_length1, ls_width1, ls_height1, ls_std_cost, ls_cc_freq
String 	ls_part_upc, ls_freight_class, ls_storage_code, ls_inv_class, ls_alt_sku, ls_coo, ls_shelf_life
String 	ls_item_delete_ind, ls_uf1, ls_uf4, ls_uf5, ls_uf15, ls_sn_track, ls_cc_class_code, ls_foot_print_ind

Integer	liRC,	liFileNo

Long		llCount,	llPos, llOwner, llNew, llExist, llNewRow, llFileRowCount, llFileRowPos, ll_ContentSKU, llFindRow
Long		ll_supp_row, ll_supp_found, ll_Owner_Row, ll_owner_found

Boolean	lbNew, lbError, lbSave, lb_otm_item_turned_on


u_ds_datastore	 ldsItemOrig, ldsItem
datastore	lu_ds, ldsItemGroupCode, ldsSuppOwner

n_otm ln_otm
ln_otm = CREATE n_otm

ldsItemOrig = Create u_ds_datastore
ldsItemOrig.dataobject= 'd_item_master'

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master'
ldsItem.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

ldsSuppOwner = Create u_ds_datastore
ldsSuppOwner.dataobject ='d_supplier_owner'

//TimA 01/25/12 OTM Project Added OTM Flag
If gs_OTM_Flag = 'Y' then 
	select OTM_Item_Master_Send_Ind
		into	:ls_ind
	from project with(nolock)
	where project_id = 'PANDORA';
End if

lb_otm_item_turned_on = Upper(trim(ls_ind)) = 'Y'
lb_otm_item_turned_on = FALSE //19-Dec-2018 :Madhu S27372 - Don't send to OTM

//15-Nov-2017 :Madhu PEVS-806 - 3PL Cycle Count Order - START
ldsItemGroupCode = Create datastore
sql_syntax =" select * from cc_group_class_code with(nolock) "
sql_syntax +=" where project_Id ='"+asproject+"'"
ldsItemGroupCode.create( SQLCA.SyntaxFromSql(sql_syntax,"", ls_Errors))
ldsItemGroupCode.settransobject( SQLCA)
ldsItemGroupCode.retrieve( )
//15-Nov-2017 :Madhu PEVS-806 - 3PL Cycle Count Order - END

//Open and read the File In
lsLogOut = '      - Opening Item Master File: ' + asPath + String(Today(), "mm/dd/yyyy hh:mm:ss.fff")
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master File for Pandora Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',trim(lsStringData))
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Process each Row
llFileRowCount = lu_ds.RowCount()
w_main.SetMicroHelp("Total Item Master Records "+ string(llFileRowCount)+" have to Process and continues...")

For llfileRowPos = 1 to llFileRowCount
	lbSave = True	
	lsData = trim(lu_ds.GetItemString(llFileRowPos,'rec_Data'))
	
	//Ignore EOF
	If lsData = "EOF" Then Continue
	
	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsData,Len(lsData) - 1)
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

	//Supplier ... Should always be 'PANDORA'
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsSupplier = lsTemp
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
		lbError = True
		Continue
	End If
	
	ll_supp_found =0 //19-Dec-2018 :Madhu S27372 - Re-set value
	
	//19-Dec-2018 :Madhu S27372 - Loop through supplier List
	FOR ll_supp_row = 1 to UpperBound(ls_supp)
		IF ls_supp[ll_supp_row] = lsSupplier THEN ll_supp_found ++
	NEXT
	
	//Validate Supplier
	If ll_supp_found = 0 Then
		Select Count(*) into :llCount
		From Supplier with(nolock)
		Where Project_id = :asProject and Supp_code = :lsSupplier
		using sqlca;

		If llCount < 1 Then			
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Supplier: '" + lsSupplier + "'. Record will not be processed.")
			lbError = True
			Continue
		else
			ls_supp[UpperBound(ls_supp) +1 ] = lsSupplier //19-Dec-2018 :Madhu S27372 - Add supplier to Array
		End If		
	End If
	
	//Retrieve for SKU - We will be updating across Suppliers
	llCount = ldsItem.Retrieve(asProject, lsSKU)
	ldsItem.RowsCopy(1, ldsItem.RowCount(), Primary!, ldsItemOrig, 1, Primary!)		// LTK 20120111	OTM addition
	llCount = ldsItem.RowCount()
		
	If llCount <= 0 Then
	
		//If No Supplier, default to Pandora
		If lsSupplier = "" Then lsSupplier = 'PANDORA'
		
		llNew ++ /*add to new count*/
		lbNew = True
		llNewRow = ldsItem.InsertRow(0)
		ldsItem.SetItem(llNewRow, 'project_id', asProject)
		ldsItem.SetItem(llNewRow, 'SKU', lsSKU)
		
		//19-Dec-2018 :Madhu S27372 Add Owner Id & Owner Cd into external DW
		If ldsSuppOwner.rowcount() > 0 Then ll_owner_found = ldsSuppOwner.find( "owner_cd ='"+lsSupplier+"'", 0, ldsSuppOwner.rowcount())
		
		If ldsSuppOwner.rowcount( ) = 0 or  ll_owner_found = 0 Then
		
			//Get Default owner for Supplier
			Select owner_id into :llOwner
			From Owner with(nolock)
			Where project_id = :asProject and Owner_type = 'S' 
			and owner_cd = :lsSupplier
			using sqlca;
			
			ll_Owner_Row = ldsSuppOwner.insertrow( 0)
			ldsSuppOwner.setItem( ll_Owner_Row, 'owner_cd', lsSupplier)
			ldsSuppOwner.setItem( ll_Owner_Row, 'owner_id', llOwner)
		
		elseIf ll_owner_found > 0 Then
			llOwner = ldsSuppOwner.getItemNumber(ll_owner_found, 'owner_id')
		End If
		
		ldsItem.SetItem(llNewRow, 'supp_code',lsSupplier)
		ldsItem.SetItem(llNewRow, 'owner_id',llOwner)
		ldsItem.setItem(llNewRow, 'Initial_File_Name', asPath) //25-May-2018 :Madhu S19730 - Store Initial File Name
		
	else /*exists*/
		lsGetSerializedInd = ldsItem.GetItemString(llCount, 'serialized_ind')
		ldsItem.setItem( llCount, 'Update_File_Name', asPath) //25-May-2018 :Madhu S19730 - Store Update File Name
		ldsItem.setItem( llCount, 'Last_Sweeper_Update', today()) //25-May-2018 :Madhu S19730 - Store Updated Sweeper Date
		
		llexist += llCount /*add to existing Count*/
		lbNew = False
	End IF //Record exists

	//Description	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_description = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		ls_description = lsData
	End If
	
	// UOM 1 
	lsData = Right(lsData,(len(lsData) - (Len(ls_description) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_uom1 = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_uom1 = lsData
	End If

	//Weight maps to Weight 1
	lsData = Right(lsData,(len(lsData) - (Len(ls_uom1) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_weight1 = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_weight1 = lsData
	End If

	//Length maps to Length 1
	lsData = Right(lsData,(len(lsData) - (Len(ls_weight1) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_length1 = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_length1 = lsData
	End If

	//Width maps to Width 1
	lsData = Right(lsData,(len(lsData) - (Len(ls_length1) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_width1 = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_width1 = lsData
	End If

	//Height maps to Height 1
	lsData = Right(lsData,(len(lsData) - (Len(ls_width1) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_height1 = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_height1 = lsData
	End If

	//Standard Cost
	lsData = Right(lsData,(len(lsData) - (Len(ls_height1) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_std_cost = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_std_cost = lsData
	End If

	//Cycle Count Frequency in Days
	lsData = Right(lsData,(len(lsData) - (Len(ls_std_cost) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_cc_freq = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_cc_freq = lsData
	End If

	//UPC Code
	lsData = Right(lsData,(len(lsData) - (Len(ls_cc_freq) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_part_upc = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_part_upc = lsData
	End If	

	//Freight Class 
	lsData = Right(lsData,(len(lsData) - (Len(ls_part_upc) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_freight_class = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_freight_class = lsData
	End If

	//Storage Code 
	lsData = Right(lsData,(len(lsData) - (Len(ls_freight_class) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_storage_code = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_storage_code = lsData
	End If

	//Inventory Class 
	lsData = Right(lsData,(len(lsData) - (Len(ls_storage_code) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_inv_class = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_inv_class = lsData
	End If

	//Alternate SKU 
	lsData = Right(lsData,(len(lsData) - (Len(ls_inv_class) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_alt_sku = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_alt_sku = lsData
	End If

	//Default COO 
	lsData = Right(lsData,(len(lsData) - (Len(ls_alt_sku) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_coo = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_coo = lsData
	End If

	//Shelf Life in Days
	lsData = Right(lsData,(len(lsData) - (Len(ls_coo) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_shelf_life = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_shelf_life = lsData
	End If
	
	//Item Delete Ind
	lsData = Right(lsData,(len(lsData) - (Len(ls_shelf_life) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_item_delete_ind = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_item_delete_ind = lsData
	End If

	// (UF1 - Item Revision)
	lsData = Right(lsData,(len(lsData) - (Len(ls_item_delete_ind) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_uf1 = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_uf1 = lsData
	End If

	// (UF4 - Item Status Code (like Production, Obsolete, Prototype (lifecycle))
	lsData = Right(lsData,(len(lsData) - (Len(ls_uf1) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_uf4 = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_uf4 = lsData
	End If

	//UF5
	lsData = Right(lsData,(len(lsData) - (Len(ls_uf4) + 1))) //Strip off until the next delimeter	
	If Pos(lsData,'|') > 0 Then
		ls_uf5 = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_uf5 = lsData
	End If	

	//UF15
	lsData = Right(lsData,(len(lsData) - (Len(ls_uf5) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_uf15 = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_uf15 = lsData
	End If	

	//SN Tracking
	lsData = Right(lsData,(len(lsData) - (Len(ls_uf15) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_sn_track = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_sn_track = lsData
	End If	

	//CC Class Code
	lsData = Right(lsData,(len(lsData) - (Len(ls_sn_track) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_cc_class_code = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_cc_class_code = lsData
	End If

	lsFind ="Group_Code ='1' and Class_Code ='"+ls_cc_class_code+"'"
	llFindRow = ldsItemGroupCode.find( lsFind, 1, ldsItemGroupCode.rowcount())
	
	//Foot Prints Ind
	lsData = Right(lsData,(len(lsData) - (Len(ls_cc_class_code) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		ls_foot_print_ind = Left(lsData,(pos(lsData,'|') - 1))
	Else
		ls_foot_print_ind = lsData
	End If	

	//20-Dec-2018 :Madhu S27372 - Update all Item Master Record attribute values
	llCount = ldsItem.RowCount() //get Item's count
	FOR llPos = 1 to llCount
		
		//Capture the 1st 70 chars in Description, then the next 70 in UF14.
		ldsItem.SetItem(llPos, 'Description', left(ls_description,70))							//Description
		IF len(ls_description) > 70 THEN
			ldsItem.SetItem(llPos, 'user_field14', mid(ls_description, 71, 70))				//User Field14
		END IF
		
		IF ls_uom1 > '' THEN									//UOM1
			ldsItem.SetItem(llPos,'uom_1',left(ls_uom1,4))
		ELSE
			ldsItem.SetItem(llPos,'uom_1','EA') //Default EA
		END IF
		
		IF isnumber(trim(ls_weight1))	THEN 	ldsItem.SetItem(llPos,'weight_1', Dec(trim(ls_weight1)))				//Weight 1
		IF isnumber(trim(ls_length1))	THEN	ldsItem.SetItem(llPos,'Length_1', Dec(trim(ls_length1)))				//Length 1
		IF isnumber(trim(ls_width1))	THEN	ldsItem.SetItem(llPos,'Width_1', Dec(trim(ls_width1)))				//Width 1
		IF isnumber(trim(ls_height1))	THEN	ldsItem.SetItem(llPos,'Height_1', Dec(trim(ls_height1)))				//Height 1
		IF isnumber(trim(ls_std_cost))	THEN	ldsItem.SetItem(llPos,'Std_Cost', Dec(trim(ls_std_cost)))				//Std Cost
		IF isnumber(trim(ls_cc_freq))	THEN 	ldsItem.SetItem(llPos,'cc_freq', Dec(trim(ls_cc_freq)))				//CC Freq
		IF isnumber(trim(ls_part_upc))	THEN	ldsItem.SetItem(llPos,'Part_UPC_Code', Dec(trim(ls_part_upc)))	//Part UPC Code	
		IF ls_freight_class > '' 			THEN 	ldsItem.SetItem(llPos,'Freight_Class', left(ls_freight_class,10))		//Freight Class
		IF ls_storage_code > '' 			THEN	ldsItem.SetItem(llPos,'Storage_Code', left(ls_storage_code,10))	//Storage Code	
		IF ls_inv_class > '' 				THEN	ldsItem.SetItem(llPos,'Inventory_Class', left(ls_inv_class,10))		//Inventory Class
		IF ls_alt_sku > '' 					THEN	ldsItem.SetItem(llPos,'Alternate_SKU', left(ls_alt_sku,50))        	//Alternate SKU

		IF ls_coo > '' THEN						//COO
			ldsItem.SetItem(llPos,'Country_Of_Origin_Default', left(ls_coo,3))
		ELSEIF lbNew THEN
			ldsItem.SetItem(llPos,'Country_Of_Origin_Default', 'XXX')
		END IF

		IF isnumber(trim(ls_shelf_life)) THEN	ldsItem.SetItem(llPos,'Shelf_Life', Dec(trim(ls_shelf_life)))			//Shelf Life
		IF ls_item_delete_ind > '' 		THEN ldsItem.SetItem(llPos,'item_delete_ind', ls_item_delete_ind)		//Item Delete Ind
		IF ls_uf1 > '' 						THEN 	ldsItem.SetItem(llPos,'user_field1', ls_uf1)					//User Field1
		IF ls_uf4 > '' 						THEN	ldsItem.SetItem(llPos, 'user_field4', ls_uf4)					//User Field4
		IF ls_uf5 > '' 						THEN	ldsItem.SetItem(llPos, 'user_field5', ls_uf5)					//User Field5
		IF ls_uf15 > '' 						THEN	ldsItem.SetItem(llPos, 'user_field15', ls_uf15)				//User Field15
		
		ll_ContentSKU = 0 //Need to reset count on each record.  If not, a previous sku that might have inventory will carry through to the next SKU.

		IF ls_sn_track > '' THEN
			ldsItem.SetItem(llPos, 'SN_Tracking', ls_sn_track)            //SN Tracking
			
			Choose case ls_sn_track
			Case 'Y'
				If lbNew Then 
					lsSetSerializedInd = 'B' //New Record just set the serialized ind to Both
				Else
					//Check for Inventory
					select count(Content_Summary.SKU)
						into :ll_ContentSKU
					from Content_Summary with(nolock)
					where project_id = 'PANDORA'
					and Content_Summary.SKU = :lsSku
					using SQLCA;
				
					If ll_ContentSKU = 0 then
						lsSetSerializedInd = 'B' //Allow the indicator to be changed
					Else
						//Throw and error there is inventory fail the line
						lsLogOut  = "-       *** Error: Inventory found for SKU: " + lsSku + " Flag was set to " + lsTemp 
						gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + lsLogOut)
						gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
						FileWrite(gilogFileNo,lsLogOut)
						gu_nvo_process_files.uf_send_email('PANDORA', 'CUSTVAL', 'Serial number flag error. Inventory already in SIMS', lsLogOut, '')
						lbSave = False
					End if
				End if
				
			Case 'N'
				
				If lbNew Then
					
					// 09/19 - PCONKL - If 'N', we should actually be setting serial tracked to No
					
				//	lsSetSerializedInd = 'B' //New Record just set the serialized ind to Both
					lsSetSerializedInd = 'N' 
					
				Else					
					//Check for Inventory
					select count(Content_Summary.SKU)
						into :ll_ContentSKU
					from Content_Summary with(nolock)
					where project_id = 'PANDORA'
					and Content_Summary.SKU = :lsSku
					using SQLCA;
				
					If ll_ContentSKU = 0 then
						lsSetSerializedInd = 'N'
					else
						//Throw and error there is inventory fail the line
						//TimA 07/15/14 change the message to was "NOT" set
						lsLogOut  = "-       *** Error: Inventory found for SKU: " + lsSku + " Flag was NOT set to " + lsTemp 
						gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + lsLogOut)
						gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
						FileWrite(gilogFileNo,lsLogOut)
						gu_nvo_process_files.uf_send_email('PANDORA', 'CUSTVAL', 'Serial number flag error. Inventory already in SIMS', lsLogOut, '')							
						lbSave = False												
					End if
				End If
			End Choose
			
			IF lsSetSerializedInd <>'' then	ldsItem.SetItem(llPos, 'serialized_ind', lsSetSerializedInd) //We don't want to set the ind to a blank
		END IF
		
		ldsItem.SetItem(llPos,'CC_Group_Code', '1') //CC Group Code

		IF ls_cc_class_code > '' THEN						//CC Class Code
			ldsItem.SetItem(llPos,'CC_Class_Code',ls_cc_class_code)
			IF llFindRow > 0 THEN ldsItem.SetItem(llPos,'CC_Freq',  ldsItemGroupCode.getItemNumber( llFindRow, 'Count_Frequency')) //CC Freq
		END IF
		
		
		IF ls_foot_print_ind > '' THEN						//Foot Prints Ind
			ldsItem.SetItem(llPos, 'Foot_Prints_Ind', ls_foot_print_ind)

			If upper(ls_foot_print_ind) = 'Y' Then
				ldsItem.SetItem(llPos, 'PO_No2_Controlled_Ind', 'Y')
				ldsItem.SetItem(llPos, 'Container_Tracking_Ind', 'Y')
				ldsItem.SetItem(llPos, 'Serialized_Ind', 'B')
			else
				ldsItem.SetItem(llPos, 'PO_No2_Controlled_Ind', 'N')
				ldsItem.SetItem(llPos, 'Container_Tracking_Ind', 'N')
			End If
		END IF

		
		//Update any record defaults
		ldsItem.SetItem(llPos, 'Last_user', 'SIMSFP')
		ldsItem.SetItem(llPos, 'last_update', today())
		ldsItem.SetItem(llPos, 'standard_of_Measure', 'M')
	
		IF lbNew THEN
			ldsItem.SetItem(llPos, 'po_controlled_ind', 'Y')
			ldsItem.SetItem(llPos,'Create_user', 'SIMSFP')
		END IF
	NEXT

	//Save New Item to DB
	If lbSave = True then
		lirc = ldsItem.Update()
	else
		Rollback;
	End if
	
	IF liRC = 1 THEN
		Commit;
		
		lsLogOut ="Row: " + string(llfileRowPos) + " SKU: "+lsSku + " processed successfully!  - " + String(Today(), "mm/dd/yyyy hh:mm:ss.fff")
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		FileWrite(gilogFileNo,lsLogOut)

		//TimA 01/25/12 OTM Project Added OTM Flag
		If gs_OTM_Flag = 'Y' and lb_otm_item_turned_on then // LTK 20120111	OTM Additions
			// Send each item to OTM if any of the OTM fields have been modified
			For llPos = 1 to ldsItem.RowCount()
				if Upper(trim(ldsItem.Object.item_delete_ind[llPos])) = 'Y' then
					ls_action = 'D' 		// Delete
				elseif lbNew then
					ls_action = 'I' 	// Insert
				else
					ls_action = 'U' 		// Update
				end if
				
				// OTM Changes - determine if any data has been modified in the set of OTM fields
				if uf_otm_fields_modified(ls_action,ldsItem,ldsItemOrig,llPos) then
					String ls_return_cd, ls_error_message
					ln_otm.uf_push_otm_item_master(ls_action, ldsItem.Object.project_id[llPos], ldsItem.Object.sku[llPos], ldsItem.Object.Supp_Code[llPos], ls_return_cd, ls_error_message)
				end if
			Next
		End If 			// OTM end changes
	ELSE
		If lbSave = True then
			Rollback;
			lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Master Record(s) to database!"
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item Master Record to database!")
			Return -1
			Continue
		End if
	END IF
	
Next /*File row to Process */

lsLogOut = Space(10) + String(llNew) + ' Item Records were successfully added and ' + String(llExist) + ' Records were updated.' + String(Today(), "mm/dd/yyyy hh:mm:ss.fff")
FileWrite(gilogFileNo,lsLogOut)

Destroy ldsItem 
Destroy ldsItemOrig
Destroy ldsItemGroupCode 
Destroy lu_ds
Destroy ldsSuppOwner

If lbError then
	Return -1
Else
	Return 0
End If
end function

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 2 characters of the file name

String	lsLogOut,	 lsSaveFileName, lsFileExt
Integer	liRC, liSo, liDo, liPo

Boolean	lbOnce, lbRC
u_nvo_proc_pandora2 	lu_Pandora2
//xx	nvo_diskerase 	lu_diskerase

lbOnce = false

//TimA 06/19/12 Added for the Method Trace log
isFileName = asFile

Choose Case Upper(Left(asFile,2))
		
	Case 'IM' /* Item Master File */
		liRC = uf_Process_ItemMaster(asPath, asProject)	
	Case 'IU' /* Price Update File (may process in ItemMaster function... */
		liRC = uf_Process_Item_Cost(asPath, asProject)	
	Case 'PO' /* Processed PO File */ // TAM 2009/06/16 - Added Rosettanet Mapping
		Choose Case Upper(Left(asFile,3))
			Case 'POR' /* Receive Order Files */
				liRC = uf_process_po_rose(asPath, asProject)
				liPo = liRC

				//Process any added PO's 
				//GailM - 02/12/2014 - Process order function will not be run if po_rose fails
				if liRC = 0 then
					liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
					liDo = liRC
				end if 
				//TimA 01/17/13 Pandora issue #501
				//Send email notifications to cirtain warehouses
				If liPo = 0 and liDo = 0 then
					uf_sendemailnotification(is_WhCode, is_Invoice,'Purchase Order')
				End if					
				//TimA 06/15/12 This now evaluates the two functions being called.
				liRC = liPo + liDo
			Case Else /* Invalid file type */
				lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
				FileWrite(gilogFileNo,lsLogOut)
				gu_nvo_process_files.uf_writeError(lsLogout)
				Return -1
		End Choose
	Case 'SO' /* Processed SO File */  // TAM 2009/06/16 - Added Rosettanet Mapping
		Choose Case Upper(Left(asFile,3))
			Case 'SOR' /* Sales Order Files */
				//TimA 05/30/12 Added instant varables for Pandora issue #425
				liRC = uf_process_so_rose(asPath, asProject)

				liSo = liRC
				//Process any added SO's
				liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject )
				liDo = liRC
				//TimA 05/30/12
				//New Function for sending email notifications to cirtain warehouses
				If liSo = 0 and liDo = 0 then
					uf_sendemailnotification(is_WhCode, is_Invoice,'Sales Order')
				End if	
				//TimA 06/15/12 Put this in because if uf_process_so_rose fails and uf_process_delivery_order returns a 0 then the error is wrond for code below this.
				liRC = liSo + liDo
			Case Else /* Invalid file type */
				lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
				FileWrite(gilogFileNo,lsLogOut)
				gu_nvo_process_files.uf_writeError(lsLogout)
				Return -1
		End Choose
	Case 'PM', 'AM' /* Processed PM File */
		liRC = uf_process_po(asPath, asProject)
		//Process any added PO's 
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
	Case 'DM' /* Sales Order Files */
		liRC = uf_process_so(asPath, asProject)
		//Process any added SO's
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
		//ENTERPRISE ON HOLD...
//	Case 'DO' /* Enterprise Sales Order Files */
//		liRC = uf_process_new_replace_so(asPath, asProject)
//		//Process any added SO's
//		liRC = gu_nvo_process_files.uf_process_Delivery_order() 
	Case 'OC' /* Owner Change */  // TAM 2009/06/16 - Added Rosettanet Mapping
		liRC = uf_process_to_rose(asPath, asProject)
	Case 'CB' /* Cityblock Outbound ORders*/
		liRC = uf_process_cityblock_so(asPath, asProject)
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
	Case 'DU' /* Cityblock Outbound ORders*/
		liRC = uf_process_delivery_date(asPath, asProject)
	Case 'CY' /* Cycle Count, mask of "CYC*" */ 
		lu_Pandora2 = Create u_nvo_proc_Pandora2
		liRC = lu_Pandora2.uf_process_cc(asPath, asProject,is_WhCode,is_Invoice)
		//TimA 01/17/13 Pandora issue #501
		//Send email notifications to cirtain warehouses
		If liRC = 0 then
			uf_sendemailnotification(is_WhCode, is_Invoice,'Cycle Count')
		End if							
		// Destroy the pandora2 object.  KZUV.COM
		Destroy lu_Pandora2
		
	/////////////////////////////////////////////// DiskErase /////////////////////////////////////////////// KZUV.COM
	Case 'BO', 'DC'  // DiskErase files to be processed.  KZUV.COM
		
		// Create the local pandora2 object.
		lu_Pandora2 = Create u_nvo_proc_Pandora2
		
		// Diskerase is handled by the pandora2 object.
		liRC = lu_Pandora2.uf_process_files(asProject, asPath, asFile, asInifile)
		
		// Destroy the local pandora2 object.
		Destroy lu_Pandora2
		
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	Case 'OA', '0A' /* CHR Confirmation with AWB/BOL Nbr *" */ 
		lu_Pandora2 = Create u_nvo_proc_Pandora2
		liRC = lu_Pandora2.uf_process_chr_ack(asPath, asProject)
		
		// Destroy the pandora2 object.  KZUV.COM
		//Destroy lu_Pandora2
	
	//Jxlim 04/20/2011 commented out per BRD change
	//Jxlim 04/14/2011 UPS Load Tender Acknowledgement with AWB/BOL Nbr *" */ 
	Case 'UP'
		lu_Pandora2 = Create u_nvo_proc_Pandora2
		liRC = lu_Pandora2.uf_process_ups_ftpin(asPath, asProject)

	Case 'DR'  // ET3 2013-01-20 Pandora 517 - MIM Receipt Ack
		liRC = uf_process_mim_receipt_ack(asPath, asProject)
		if liRC < 0 then		// LTK 20150320  Do not propagate errors on the acknowledgement as the orders could be from WMS and the emails are not desired
			f_method_trace_special( asproject, this.ClassName() + ' - uf_process_files', 'Process MIM Receipt Ack Failed' ,"", asFile,'',"")																														
			liRC = 0
		end if
		
		
/* not ready yet...
	Case 'MI'  // dts - 1/14/14 - MIM Demand Analysis spreadsheet ('MIM Demand Analysis.xls')
		liRC = uf_process_mim_demand(asPath)
*/

	Case 'TM'
		liRC = this.uf_process_load_plan( aspath, asproject )
		If liRC = 0 Then gu_nvo_process_files.uf_process_load_plan_outbound_update(asproject)
		
	Case Else 
		//Change the name of the file because ICC is dropping the file this way.
		//TimA 07/23/14
		if Pos(Upper(aspath ), "MIM_DA" ) > 0 THEN 
		//if Pos(Upper(aspath), "MIM DEMAND ANALYSIS") > 0 THEN
			lsFileExt = Right ( aspath,4 )
			if Upper(f_retrieve_parm('PANDORA','FLAG','PROCESS_XLS_FILES_ON' ) ) = 'Y' then
				If upper(lsFileExt) = ".DAT" or upper(lsFileExt) = ".TXT" Then
					liRC = uf_process_mim_demand_txt ( asproject, aspath, asfile )
				Else
					liRC = uf_process_xcel_file(asproject, aspath, asfile )
					//lsFileDesc = 'Excel File'
				End if
			else
				lsLogOut = "        XLS file processing is not turned on - File will not be processed."
				FileWrite(gilogFileNo,lsLogOut)
				gu_nvo_process_files.uf_writeError(lsLogout)
				Return -1
			end if
		else

		/* Invalid file type */
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		End if
End Choose

Return liRC
end function

public function integer uf_process_boh ();//Process the PANDORA Daily Balance on Hand Confirmation File
Datastore	ldsOut_GIG, ldsboh, ldsOut_NonGIG
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String			lsFind, lsOutString, lslogOut, lsProject, lsNextRunTime, lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName, lsFileName_NonGIG

String			lsGIG_YN, ls_PacificTime
String 		ERRORS, sql_syntax, lsTemp	

Decimal		ldBatchSeq, ldBatchSeq_NonGIG
Integer		liRC
DateTime	ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file

ldsOut_GIG = Create Datastore
ldsOut_GIG.Dataobject = 'd_edi_generic_out'
lirc = ldsOut_GIG.SetTransobject(sqlca)

ldsOut_NonGIG = Create Datastore
ldsOut_NonGIG.Dataobject = 'd_edi_generic_out'
lirc = ldsOut_NonGIG.SetTransobject(sqlca)

//ldsboh = Create Datastore
//ldsboh.Dataobject = 'd_nortel_boh' /* at the SKU/Inv Type level */
//lirc = ldsboh.SetTransobject(sqlca)

//Create the BOH datastore
// dts - 12/01/2014 - It's suddenly an emergency to include pending Stock Transfers in this snapshot, so adding tfr_in...
//07-Nov-2017  :Madhu BOH shouldn't be generated for OM Enabled Ind warehouses
ldsboh = Create Datastore
//sql_syntax = "SELECT owner_cd, SKU, Sum(Avail_Qty) + Sum(alloc_Qty) as total_qty, user_field1"
sql_syntax = "SELECT owner_cd, SKU, Sum(Avail_Qty) + Sum(alloc_Qty) + Sum(Tfr_In) as total_qty, user_field1"
sql_syntax += " from Content_Summary cs, owner o, customer c"
sql_syntax += " Where cs.owner_id = o.owner_id"
sql_syntax += " and o.project_id = c.project_id and o.owner_cd = c.cust_code"
sql_syntax += "  and cs.wh_code IN ( select wh_code from Warehouse with(nolock) where  OM_Enabled_Ind <> 'Y') "
sql_syntax += " and cs.Project_ID = 'PANDORA'"
sql_syntax += " Group by user_field1, owner_cd, SKU"
//sql_syntax += " Having Sum(Avail_Qty) + Sum(alloc_Qty) > 0"
sql_syntax += " Having Sum(Avail_Qty) + Sum(alloc_Qty) +Sum(Tfr_In) > 0"
ldsBOH.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for PANDORA Balance on Hand Extract.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF
ldsboh.SetTransObject(SQLCA)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: PANDORA Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "PANDORA"

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq < 0 Then Return -1
//Get the Next Batch Seq Nbr for the Non-GIG file
ldBatchSeq_NonGIG = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq_NonGIG < 0 Then Return -1


//isInvFileName = ProfileString(asInifile, "PANDORA", "archivedirectory", "") + '\' + "BH" + String(ldBatchSeq, "00000") + ".DAT"
lsfileName = "BH" + String(ldBatchSeq, "00000") + ".DAT"
lsfileName_NonGIG = "BH" + String(ldBatchSeq_NonGIG, "00000") + ".DAT"
//lsFileName = "SIMSonhandinv.csv"

//Retrieve the BOH Data
lsLogout = 'Retrieving Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsBOH.Retrieve()

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '~t'
lsLogOut = 'Processing Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//ls_Now = string(now(), 'yyyy-mm-dd hh:mm:ss')
ls_PacificTime = string(GetPacificTime('GMT', datetime(today(), now())), 'yyyy-mm-dd hh:mm:ss')
For llRowPos = 1 to llRowCount
	lsTemp = upper(ldsBOH.GetItemstring(llRowPos, 'User_Field1')) /* Group - used to determine GIG or Non-GiG */
	//if lsTemp = 'GIG' then //  02/26/09
	if left(lsTemp, 3) = 'GIG' then 
		lsGIG_YN = 'Y'
	else
		lsGIG_YN = 'N'
	end if
	llNewRow = ldsOut_GIG.insertRow(0)
	lsOutstring = "BH" + String(ldBatchSeq, "000000") + "|"

	lsTemp = ldsBOH.GetItemstring(llRowPos, 'Owner_CD')  /* Oracle Sub-Inventory Location */
	lsOutString += lsTemp + "|"
	lsOutstring += ls_PacificTime + "|"
	lsTemp = ldsBOH.GetItemstring(llRowPos, 'sku')  /* SKU */
	lsOutString += lsTemp + "|"
	//TEMPO!! - Format for qty?....
	lsTemp = String(ldsBOH.GetItemNumber(llRowPos, 'total_qty'), "#############")
	lsOutString += lsTemp + "|"
	lsOutString += lsGIG_YN
	
	//GailM - 03/21/2013 - Files no longer being sent to MIM.  Both GIG types will go into one file
	//if lsGIG_YN = 'Y' then
		ldsOut_GIG.SetItem(llNewRow, 'Project_id', lsproject)
		ldsOut_GIG.SetItem(llNewRow, 'file_name', lsFileName)
		ldsOut_GIG.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut_GIG.SetItem(llNewRow, 'line_seq_no', llNewRow)
		ldsOut_GIG.SetItem(llNewRow, 'batch_data', lsOutString)
	//else //non-gig
	//	ldsOut_NonGIG.SetItem(llNewRow, 'Project_id', lsproject)
	//	ldsOut_NonGIG.SetItem(llNewRow, 'file_name', lsFileName_NonGig)
	//	ldsOut_NonGIG.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq_NonGIG))
	//	ldsOut_NonGIG.SetItem(llNewRow, 'line_seq_no', llNewRow)
	//	ldsOut_NonGIG.SetItem(llNewRow, 'batch_data', lsOutString)
	//end if	
Next /*next output record */

//gailm - 03/20/2013 - Remove file from FlatFileOut to Archive Only...  No longer sent to MIM
//Write the Outbound File for GIG - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_archive_outbound(ldsOut_GIG, "PANDORA")
//Write the Outbound File for Non-GIG - no need to save and re-retrieve - just use the currently loaded DW
//GailM - 03/21/2013 - Files no longer being sent to MIM.  Both GIG types will go into one file
//gu_nvo_process_files.uf_process_archive_outbound(ldsOut_NonGIG, "PANDORA")

Return 0
end function

public function integer uf_process_item_cost (string aspath, string asproject);//Process Item-Cost Transaction for Pandora
String	lsData, lsTemp, lsLogOut, lsStringData, lsSKU, 	lsCOO, lsSupplier
string lsCost, lsOrg, lsCostGroup, lsItem, lsCurCD
			
Integer	liRC,	liFileNo
			
Long		llCount,	llPos, llOwner, llNew, llExist, llNewRow, llFileRowCount, llFileRowPos 

Decimal ldTemp

Boolean	lbNew, lbError

u_ds_datastore	ldsItemCost 
datastore	lu_DS

ldsItemCost = Create u_ds_datastore
ldsItemCost.dataobject= 'd_price_master'
ldsItemCost.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master Cost File for Pandora Processing: " + asPath
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
llFileRowCount = lu_ds.RowCount()

For llfileRowPos = 1 to llFileRowCount
	w_main.SetMicroHelp("Processing Item Master Cost Update Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))
	//Ignore EOF
	If lsData = "EOF" Then Continue
	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsData,Len(lsData) - 1)
	End If
	
	//Validate Rec Type is IU
	lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	If lsTemp <> 'IU' Then
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
	//Cost.....
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsCost = lsTemp
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Item Cost' field. Record will not be processed.")
		lbError = True
		Continue
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	//Org.....
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsOrg = lsTemp
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Org' field. Record will not be processed.")
		lbError = True
		Continue
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	//CostGroup.....
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsCostGroup = lsTemp
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Cost Group' field. Record will not be processed.")
		lbError = True
		Continue
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	//Currency Code.....
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsCurCD = lsTemp
	Else
//		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Cost Group' field. Record will not be processed.")
//		lbError = True
//		Continue
		lsCurCD = lsData
	End If

	//Retrieve for SKU / Org / CostGroup
	//llPos = ldsItemCost.Retrieve(asProject, lsSKU, lsCostGroup, lsOrg)
	/*not using CostGroup now - storing price for 'USED' in Price_2, others in Price 1
	   - using 'PANDORA' as supplier also alows Price_Master Maintenance screen to work. */
	llPos = ldsItemCost.Retrieve(asProject, lsSKU, 'PANDORA', lsOrg)
	llCount = ldsItemCost.RowCount()
	
	If llCount <= 0 Then
		llNew ++ /*add to new count*/
		lbNew = True
		llNewRow = ldsItemCost.InsertRow(0)
		ldsItemCost.SetItem(1, 'project_id', asProject)
		ldsItemCost.SetItem(1, 'SKU', lsSKU)
		//ldsItemCost.SetItem(1, 'Supp_Code', lsCostGroup)
		//not using CostGroup now - storing price for 'USED' in Price_2, others in Price 1
		// - using 'PANDORA' as supplier also alows Price_Master Maintenance screen to work.
		ldsItemCost.SetItem(1, 'Supp_Code', 'PANDORA')
		ldsItemCost.SetItem(1, 'Price_Class', lsOrg)
		llPos = 1
	Else /*exists*/		
		llexist += llCount /*add to existing Count*/
		lbNew = False
	End If
	if lsCostGroup = 'USED' then
		ldsItemCost.SetItem(llPos, 'Price_2',  dec(trim(lsCost)))
		if lbNew then
			ldsItemCost.SetItem(llPos, 'user_field1', 'USED - ' + string(datetime(today(), now()), 'yyyy-mm-dd hh:mm'))
		end if
	else
		ldsItemCost.SetItem(llPos, 'Price_1',  dec(trim(lsCost)))
		ldsItemCost.SetItem(llPos, 'user_field1', lsCostGroup + ' - ' + string(datetime(today(), now()), 'yyyy-mm-dd hh:mm'))
	end if
	ldsItemCost.SetItem(llPos, 'currency_cd',  trim(lsCurCD))
		
	//If record is new...
	If lbNew Then
	//	ldsItem.SetItem(1,'lot_controlled_ind','Y') /*Sales Order Number on all items*/
	End If
			
	//Save New Item to DB
	lirc = ldsItemCost.Update()
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item-Cost Record(s) to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item-Cost Record to database!")
		Return -1
		Continue
	End If

Next /*File row to Process */

w_main.SetMicroHelp("")

lsLogOut = Space(10) + String(llNew) + ' Item-Cost Records were successfully added and ' + String(llExist) + ' Records were updated.'
FileWrite(gilogFileNo,lsLogOut)

Destroy ldsItemCost

If lbError then
	Return -1
Else
	Return 0
End If

Return 0
end function

public function datetime getpacifictime (string aswh, datetime adtdatetime);string lsOffset, lsOffsetFremont
long   llNetOffset, llTimeSecs
date ldDate
time ltTime, ltTimeNew

select gmt_offset into :lsOffsetFremont
from warehouse
where wh_code = 'PND_FREMNT';

if asWH = 'GMT' then
	lsOffset = '0'
else
	select gmt_offset into :lsOffset
	from warehouse
	where wh_code = :asWH;
end if

// see if subtracting the offset would make it the previous day. If so, subtract a day and the remainder of the Offset.
// - if the offset is negative (West of Fremont), see if adding the offset would make it the next day. If so, add a day and the remainder of Offset
llNetOffset = long(lsOffset) - long(lsOffsetFremont)
llNetOffset = llNetOffset * 60 * 60  //convert the offset to seconds
ldDate = date(adtDateTime)
ltTime = time(adtDateTime)
ltTimeNew = ltTime
if llNetOffset > 0 then
	llTimeSecs = SecondsAfter(time('00:00'), ltTime)
	if llTimeSecs < llNetOffset then
		ldDate = RelativeDate(ldDate, -1)
		ltTimeNew = RelativeTime(time('23:59:59'), - (llNetOffset - llTimeSecs))
	else
		ltTimeNew = RelativeTime(ltTime, - llNetOffset)
	end if
elseif llNetOffset < 0 then  //Net Offset is negative - selected WH is West of Fremont. Going to add time to convert to Pacific
	llTimeSecs = SecondsAfter(ltTime, time('23:59:59')) //seconds remaining in the day
	if llTimeSecs < llNetOffset then // time remaining in the day is less than the net offset....
		//so add a day and add the remaing time
		ldDate = RelativeDate(ldDate, +1)
		ltTimeNew = RelativeTime(time('00:00'),  (llNetOffset - llTimeSecs))
	else
		// adding the net offset won't require adding another day
		ltTimeNew = RelativeTime(ltTime, llNetOffset)
	end if
end if

//ltTimeNew = RelativeTime(ltTime, - llNetOffset*60*60)
//if ltTimeNew > ltTime then  // are there any locations West of Pacific (Hawaii or other?)
//	ldDate = RelativeDate(ldDate, -1)
//end if
adtDateTime = DateTime(ldDate, ltTimeNew)
//adtDate = RelativeDate(adtDate, llNetOffset)
return adtDateTime
end function

public function string nonull (string as_str);as_str = trim(as_str)
if isnull(as_str) or as_str = '-' then
	return ""
else
	return as_str
end if

end function

public function integer uf_process_data_dump (string asinifile);/*aaa  Process the PANDORA Daily Data Dump
 TODO - ? Use a structure for the Outbound Order data. Use two structure variables - 1 for WH and 1 for DC?
     - maybe use a structure for customer too...
	  //str_Customer	lstr_Cust_DC, lstr_Cust_WH
	  */

Datastore	ldsOut, ldsDump_IB, ldsDump_OB, ldsOut_IntrIB, ldsOut_IntrOB, ldsFinanceTable

Long			llRowPos, llRowCount_IB, llRowCount_OB, llFindRow,	llNewRow, llNewRow_Intr, llFinanceRow

String			lsFind, lsOutString, lslogOut, lsProject, lsNextRunTime, lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName, lsFileName_NonGIG

//Added for Intrastat...
String			lsIntrastat, lsFileName_IntrIB, lsFileName_IntrOB, lsTransType, lsCommodity, lsCost, lsExtCost, lsCur, lsMode, ls3rdParty
decimal		ldWgt, ldExtWgt
Long			liThousands

String			lsGIG_YN, ls_PacificTime
String 		ERRORS, sql_syntax, lsTemp

Decimal		ldBatchSeq, ldBatchSeq_NonGIG
Integer		liRC
DateTime	ldtNextRunTime, ldtCompleteDate
Date			ldtNextRunDate

string		lsFromLoc, lsFromName, lsFromAddr1, lsFromAddr2, lsFromCity, lsFromZip, lsFromCntry
string		lsToLoc, lsToName, lsToAddr1, lsToAddr2, lsToCity, lsToZip, lsToCntry, lsFromCntryEU, lsToCntryEU
string		lsSoldName, lsSoldAddr1, lsSoldAddr2, lsSoldCity, lsSoldZip, lsSoldCntry
string 	lsLine, lsPandoraProject
string		lsFrom, lsTo, lsFromGroup, lsToGroup
integer	liMonth, liYear, liNextMonth, liNextYear, liWeekDay
string		lsOrg, lsRONO, lsDONO, lsOrdType
string		lsGroup
str_Finance_Record lstr_FinanceRec
string		lsInvType
string		lsInvoice
string		lsCntryOfDispatch
//This function runs on a scheduled basis - Run from the activity_schedule, not the .ini file

//get the from / to dates from the ini file...
lsFrom = ProfileString(asInifile, "Pandora", "DDFrom", "")
lsTo = ProfileString(asInifile, "Pandora", "DDTo", "")

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsOut_IntrIB = Create Datastore
ldsOut_IntrIB.Dataobject = 'd_edi_generic_out'
lirc = ldsOut_IntrIB.SetTransobject(sqlca)

ldsOut_IntrOB = Create Datastore
ldsOut_IntrOB.Dataobject = 'd_edi_generic_out'
lirc = ldsOut_IntrOB.SetTransobject(sqlca)

ldsDump_IB = Create Datastore
ldsDump_IB.Dataobject = 'd_pandora_finance_dump_ib'
lirc = ldsDump_IB.SetTransobject(sqlca)

ldsDump_OB = Create Datastore
ldsDump_OB.Dataobject = 'd_pandora_finance_dump_ob'
lirc = ldsDump_OB.SetTransobject(sqlca)

ldsFinanceTable = Create Datastore
ldsFinanceTable.Dataobject = 'd_pandora_finance_data'
lirc = ldsFinanceTable.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo, lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: PANDORA Finance Data Dump!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "PANDORA"

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsProject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq < 0 Then Return -1
//		//Get the Next Batch Seq Nbr for the Non-GIG file
//		ldBatchSeq_NonGIG = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
//		If ldBatchSeq_NonGIG < 0 Then Return -1

//- Do we need a separate BatchSeq for all 3 files (Finance, Intra-IB and Intra-OB)?
lsfileName = "DD" + String(ldBatchSeq, "00000") + ".DAT"
lsfileName_IntrIB = "Intr_IB" + String(ldBatchSeq, "00000") + ".DAT"
lsfileName_IntrOB = "Intr_OB" + String(ldBatchSeq, "00000") + ".DAT"
//		lsfileName_NonGIG = "DD" + String(ldBatchSeq_NonGIG, "00000") + ".DAT"

//Retrieve the transaction records...
lsLogout = 'Retrieving Pandora Finance Report records, from ' + lsFrom + ' to ' + lsTo
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount_IB = ldsDump_IB.Retrieve(lsFrom, lsTo)

llRowCount_OB = ldsDump_OB.Retrieve(lsFrom, lsTo)

lsLogOut = String(llRowCount_IB) + ' Inbound Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)
lsLogOut = String(llRowCount_OB) + ' Outbound Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '|'

//		ls_PacificTime = string(GetPacificTime('GMT', datetime(today(), now())), 'yyyy-mm-dd hh:mm:ss')

if llRowCount_IB + llRowCount_OB > 0 then
	//Finance Report...
	//Delete from the Finance Data table for date range selected....
	delete from pandora_finance_data
	where complete_date > :lsFrom and complete_date < :lsTo
	and import_date is null;

	lsOutString = "Finance Report for " + lsFrom + " until " + lsTo + " as of " + String(Today(), "m/d/yy hh:mm")
	llNewRow = ldsOut.insertRow(0)
	ldsOut.SetItem(llNewRow, 'Project_id', lsproject)
	ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
//	lsOutString = "In_Out|Date|Order #|Line #|E|T|R|S|Inventory Location|Ship From Name|Ship From Add 1|Ship From Add 2|Ship From City|Ship From Zip Code|Ship From Country|Ship To Name|Ship To Add 1|Ship To Add 2|Ship To City|Ship To Zip Code|Ship To Country|Sold To Name|Sold To Add 1|Sold To Add 2|Sold To City|Sold To Zip Code|Sold To Country|Part #|Part Description|VendorName?|Mfg Part #|Qty|Unit Value|Extended Value|Currency Code|HTS|ECCN|COO|Supplier Integration|ORG|Project Code|Cost Center|Value ID|CI Invoice #"
//	lsOutString = "In_Out|Date|System#|Order #|Line #|E|T|R|S|ShipFrom Location|Ship From Name|Ship From Add 1|Ship From Add 2|Ship From City|Ship From Zip Code|Ship From Country|ShipTO Location|Ship To Name|Ship To Add 1|Ship To Add 2|Ship To City|Ship To Zip Code|Ship To Country|Sold To Name|Sold To Add 1|Sold To Add 2|Sold To City|Sold To Zip Code|Sold To Country|Part #|Part Description|VendorName?|Mfg Part #|Qty|Unit Value|Extended Value|Currency Code|HTS|ECCN|COO|Supplier Integration|ORG|Project Code|Cost Center|Value ID|CI Invoice #|Requestor|Remarks"
//	lsOutString = "In_Out|Date|System#|Order #|Line #|E|T|R|S|ShipFrom Location|Ship From Name|Ship From Add 1|Ship From Add 2|Ship From City|Ship From Zip Code|Ship From Country|OrdType|TransType|ShipTO Location|Ship To Name|Ship To Add 1|Ship To Add 2|Ship To City|Ship To Zip Code|Ship To Country|Sold To Name|Sold To Add 1|Sold To Add 2|Sold To City|Sold To Zip Code|Sold To Country|Part #|Part Description|VendorName?|Mfg Part #|Qty|Unit Value|Extended Value|Currency Code|HTS|ECCN|COO|Supplier Integration|ORG|Project Code|Cost Center|Value ID|CI Invoice #|Requestor|Remarks"
	lsOutString = "INTL|In_Out|Date|System#|Order #|Line #|E|T|R|S|ShipFrom Location|Ship From Name|Ship From Add 1|Ship From Add 2|Ship From City|Ship From Zip Code|Ship From Country|OrdType|TransType|ShipTO Location|Ship To Name|Ship To Add 1|Ship To Add 2|Ship To City|Ship To Zip Code|Ship To Country|Sold To Name|Sold To Add 1|Sold To Add 2|Sold To City|Sold To Zip Code|Sold To Country|Part #|Part Description|VendorName?|Mfg Part #|Qty|Unit Value|Extended Value|Currency Code|HTS|ECCN|COO|Supplier Integration|ORG|Project Code|Cost Center|Value ID|CI Invoice #|Requestor|Remarks"
	llNewRow = ldsOut.insertRow(0)
	ldsOut.SetItem(llNewRow, 'Project_id', lsproject)
	ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)

	//Inbound Intrastat File...
	lsOutString = "Inbound Intrastat Report for " + lsFrom + " until " + lsTo + " as of " + String(Today(), "m/d/yy hh:mm")
	llNewRow = ldsOut_IntrIB.insertRow(0)
	ldsOut_IntrIB.SetItem(llNewRow, 'Project_id', lsproject)
	ldsOut_IntrIB.SetItem(llNewRow, 'file_name', lsFileName_IntrIB)
	ldsOut_IntrIB.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut_IntrIB.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut_IntrIB.SetItem(llNewRow, 'batch_data', lsOutString)
//	lsOutString = "DATE|SIMS System#|ORDER NUMBER|LINE NUMBER|TRANSACTION TYPE|FROM|PART NUMBER|PART DESCRIPTION|QTY|COMMODITIY CODE|EU COUNTRY OF DISPATCH|EU COUNTRY OF DESTINATION|COUNTRY OF ORIGIN|MODE OF TRANSPORT CODE|MODE OF TRANSPORT DESCRIPTION|NATURE OF TRANSACTION|NATURE OF TRANSACTION DESCRIPTION|UNIT VALUE|EXTENDED VALUE|DELIVERY TERMS|UNIT NET MASS (NEAREST KG)|EXTENDED MASS (NEAREST KG)|THIRD PARTY|TAX ID|Currency"
	lsOutString = "DATE|SIMS System#|ORDER NUMBER|LINE NUMBER|TRANSACTION TYPE|FROM|PART NUMBER|PART DESCRIPTION|QTY|COMMODITIY CODE|EU COUNTRY OF DISPATCH|EU COUNTRY OF DESTINATION|COUNTRY OF ORIGIN|MODE OF TRANSPORT CODE|MODE OF TRANSPORT DESCRIPTION|NATURE OF TRANSACTION|NATURE OF TRANSACTION DESCRIPTION|UNIT VALUE|EXTENDED VALUE|DELIVERY TERMS|UNIT NET MASS (NEAREST KG)|EXTENDED MASS (NEAREST KG)|TAX ID|Currency"
	llNewRow = ldsOut_IntrIB.insertRow(0)
	ldsOut_IntrIB.SetItem(llNewRow, 'Project_id', lsproject)
	ldsOut_IntrIB.SetItem(llNewRow, 'file_name', lsFileName)
	ldsOut_IntrIB.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut_IntrIB.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut_IntrIB.SetItem(llNewRow, 'batch_data', lsOutString)

	//Outbound Intrastat File...
	lsOutString = "Outbound Intrastat Report for " + lsFrom + " until " + lsTo + " as of " + String(Today(), "m/d/yy hh:mm")
	llNewRow = ldsOut_IntrOB.insertRow(0)
	ldsOut_IntrOB.SetItem(llNewRow, 'Project_id', lsproject)
	ldsOut_IntrOB.SetItem(llNewRow, 'file_name', lsFileName_IntrOB)
	ldsOut_IntrOB.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut_IntrOB.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut_IntrOB.SetItem(llNewRow, 'batch_data', lsOutString)
	lsOutString = "DATE|SIMS System#|ORDER NUMBER|LINE NUMBER|SHIP TO|PART NUMBER|PART DESCRIPTION|QTY|COMMODITIY CODE|COUNTRY OF ORIGIN/SHIPPED|COUNTRY OF CONSIGNEE|COUNTRY OF ORIGIN|MODE OF TRANSPORT CODE|MODE OF TRANSPORT DESCRIPTION|NATURE OF TRANSACTION|NATURE OF TRANSACTION DESCRIPTION|UNIT VALUE|EXTENDED VALUE|DELIVERY TERMS|UNIT NET MASS (NEAREST KG)|EXTENDED MASS (NEAREST KG)|THIRD PARTY|TAX ID|Currency"
	llNewRow = ldsOut_IntrOB.insertRow(0)
	ldsOut_IntrOB.SetItem(llNewRow, 'Project_id', lsproject)
	ldsOut_IntrOB.SetItem(llNewRow, 'file_name', lsFileName)
	ldsOut_IntrOB.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut_IntrOB.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut_IntrOB.SetItem(llNewRow, 'batch_data', lsOutString)
end if		
		
// *********************************************************************************************
// *******************    INBOUND   ***************************************************************
// *********************************************************************************************
lsLogOut = 'Processing Inbound Finance Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

liThousands = 1
For llRowPos = 1 to llRowCount_IB
	if llRowPos - (liThousands * 1000) = 0 then
		lsLogOut = string(liThousands * 1000) + ' records processed.....'
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		FileWrite(gilogFileNo,lsLogOut)
		liThousands += 1
	end if
	llNewRow = ldsOut.insertRow(0)
	llFinanceRow = ldsFinanceTable.InsertRow(0)
	ldsFinanceTable.SetItem(llFinanceRow, 'In_Out', 'IB')
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'wh_code')
	ldsFinanceTable.SetItem(llFinanceRow, 'wh_code', lsTemp)

/***********  may need to look for ST and SF locations in customer_master as 'Old_*'...
*/

	//TEMP! need to look up EU Cntry Indicator for From / To (is this Outbound only?)
	//           - if both are EU Countries, then '*'...
	lsToCntryEU = ldsDump_IB.GetItemString(llRowPos, 'ToCntry_EU')
	lsFromCntryEU = ldsDump_IB.GetItemString(llRowPos, 'FromCntry_EU')
//12/12	ldsFinanceTable.SetItem(llFinanceRow, 'FromCntry_EU', lsFromCntryEU)
//12/12	ldsFinanceTable.SetItem(llFinanceRow, 'ToCntry_EU', lsToCntryEU)

	/* 04/28/09... added FromCntry join on Inbound...
		Inbound: TO EU and From either EU or Blank
	    Outbound: Both EU	*/
	
	//moved this from below so that From/To countries are available for Intrastat determination...
	lsToCntry = ldsDump_IB.GetItemString(llRowPos, 'ST_Cntry')
	ldsFinanceTable.SetItem(llFinanceRow, 'ToCntry', lsToCntry)
	lsFromLoc = upper(ldsDump_IB.GetItemString(llRowPos, 'FromLoc')) // rm.uf6... 3/19/10 - added 'upper' 
	//look up address info in Customer Table. If it's not there, leave blank....
	//  - now looking in supplier table as well....
//xxxTEMPOxxx - can't we get these from the join to SF_Cust? (what if it's from a supplier?)
	// 3/14/10 - added FromGroup to check Supplier Integration against both From/To
	lsFromName=''; lsFromAddr1=''; lsFromAddr2=''; lsFromCity=''; lsFromZip=''; lsFromCntry=''; lsFromGroup = ''
	// 3/11/2010 - if FromLoc is MENLOCL there won't be SF Address info but set the SF Cntry to the ST Cntry
	if lsFromLoc = 'MENLOCL' then
		ldsFinanceTable.SetItem(llFinanceRow, 'FromLoc', lsFromLoc)
		lsFromCntry = lsToCntry
		ldsFinanceTable.SetItem(llFinanceRow, 'SF_Cntry', lsToCntry)
	elseif lsFromLoc > '' then
		select cust_name, address_1, address_2, city, zip, country, user_field1
		into :lsFromName, :lsFromAddr1, :lsFromAddr2, :lsFromCity, :lsFromZip, :lsFromCntry, :lsFromGroup
		from customer
		where project_id = 'PANDORA'
		and cust_code = :lsFromLoc;
		
		// 3/26/10 !!!### Now have to look for a customer record with an 'Old_' prefix (if it's not found and it's a DC or WH)...
		if NoNull(lsFromName) = "" and (left(lsFromLoc, 2) = 'DC' or left(lsFromLoc, 2) = 'WH') then
			select cust_name, address_1, address_2, city, zip, country, user_field1
			into :lsFromName, :lsFromAddr1, :lsFromAddr2, :lsFromCity, :lsFromZip, :lsFromCntry, :lsFromGroup
			from customer
			where project_id = 'PANDORA'
			and cust_code = 'Old_' + :lsFromLoc;
		end if
		
		// if we didn't find the From Location in the Customer table, look in the Supplier table...
		if NoNull(lsFromName) = "" then
			select Supp_name, address_1, address_2, city, zip, country
			into :lsFromName, :lsFromAddr1, :lsFromAddr2, :lsFromCity, :lsFromZip, :lsFromCntry
			from supplier
			where project_id = 'PANDORA'
			and supp_code = :lsFromLoc;
		end if
		lsOutString += NoNull(lsFromName) + "|" + NoNull(lsFromAddr1) + "|" + NoNull(lsFromAddr2) + "|" + NoNull(lsFromCity) + "|" + NoNull(lsFromZip) + "|" + NoNull(lsFromCntry)  + "|" 
		//ldsFinanceTable.SetItem(llFinanceRow, 'FromLoc', lsFromLoc) //TEMPO - Should This be lsFromName or lsFromLoc?
		//2/23/10 - ldsFinanceTable.SetItem(llFinanceRow, 'FromLoc', lsFromName)
		ldsFinanceTable.SetItem(llFinanceRow, 'FromLoc', lsFromLoc)
		ldsFinanceTable.SetItem(llFinanceRow, 'sf_name', lsFromName) //2/23/10
		ldsFinanceTable.SetItem(llFinanceRow, 'SF_Addr1', lsFromAddr1)
		ldsFinanceTable.SetItem(llFinanceRow, 'SF_Addr2', lsFromAddr2)
		ldsFinanceTable.SetItem(llFinanceRow, 'SF_City', lsFromCity)
		ldsFinanceTable.SetItem(llFinanceRow, 'SF_Zip', lsFromZip)
		ldsFinanceTable.SetItem(llFinanceRow, 'SF_Cntry', lsFromCntry)
		ldsFinanceTable.SetItem(llFinanceRow, 'FromCntry', lsFromCntry) //do we need both sf_cntry and FromCntry?
	end if
	
	lsCntryOfDispatch = ldsDump_IB.GetItemString(llRowPos, 'CntryOfDispatch')
	if lsCntryOfDispatch > '' then
		// 3/26/2010 - if there is a CntryOfDispatch, need to look up EU Country...
		select eu_country_ind into :lsFromCntryEU
		from country
		where designating_code = :lsCntryOfDispatch;
	end if
	
	lsIntrastat = ''
	
	//if lsToCntryEU = 'Y' and lsFromCntryEU = 'Y' then
	//if lsToCntryEU = 'Y' and lsFromCntryEU = 'Y' and lsFromCntry <> lsToCntry then //xxx
	if lsToCntryEU = 'Y' and (lsFromCntryEU = 'Y' or IsNull(lsFromCntryEU)) and lsFromCntry <> lsToCntry then
		llNewRow_Intr = ldsOut_IntrIB.insertRow(0)
	end if
	
	//lsOutstring = 'IB' + "|"
	//10/20 - added 'INTL' flag
	// 3/18/10 - now using cntry of dispatch here (if present)....
	if lsCntryOfDispatch > '' then 
		lsTemp = lsCntryOfDispatch
		ldsFinanceTable.SetItem(llFinanceRow, 'SF_Cntry', lsCntryOfDispatch)  // do we need both lsFromCntry and lsCntryOfDisapatch? (or can cntry of dispatch take precendence?)
	else
		lsTemp = lsFromCntry
	end if
	// 3/18/10 - if lsFromCntry <> lsToCntry then
	if lsTemp <> lsToCntry then
		lsOutstring = 'X' + "|"
		lstr_FinanceRec.Intl = 'X'
		ldsFinanceTable.SetItem(llFinanceRow, 'Intl', 'X')
	else
		lsOutstring = "|"
		lstr_FinanceRec.Intl = ''
	end if
	lsOutstring += 'IB' + "|"
	lstr_FinanceRec.In_Out = 'IB'
	lsTemp = string(ldsDump_IB.GetItemDateTime(llRowPos, 'complete_date'))
	lsOutString += lsTemp + "|"
	lsIntrastat += lsTemp + "|"
	ldtCompleteDate = datetime(lsTemp)
	ldsFinanceTable.SetItem(llFinanceRow, 'complete_date', ldtCompleteDate)
	//04/28/09 - adding ro_no for uniqueness
	lsRONO = ldsDump_IB.GetItemString(llRowPos, 'ro_no')
	lsOutString += lsRONO + "|"
	lsIntrastat += lsRONO + "|"
//TEMPO!	 - need this to be called System_Number in pandora_finance_data table
//?? We do have 'sysetem_number in finance table...
	//ldsFinanceTable.SetItem(llFinanceRow, 'Trans_Order_ID', lsRONO)
	ldsFinanceTable.SetItem(llFinanceRow, 'ro_no', lsRONO)
	ldsFinanceTable.SetItem(llFinanceRow, 'system_number', lsRONO)
// 05/08	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'ship_ref')
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'supp_invoice_no')
	lsOutString += lsTemp + "|"
	lsIntrastat += lsTemp + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'Invoice_No', lsTemp)
	lsLine = string(ldsDump_IB.GetItemNumber(llRowPos, 'line_item_no'))
	lsOutString += lsLine + "|"
	lsIntrastat += lsLine + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'line_item_no', long(lsLine))
	lsTransType = ldsDump_IB.GetItemString(llRowPos, 'TransType') //RM.UF7
	lsIntrastat += NoNull(lsTransType) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'TransType', lsTransType)
	// 02-04-2010 - if lsToCntryEU = 'Y' and (lsFromCntryEU = 'Y' or NoNull(lsFromCntryEU) = '') then  //EU Indicator
	// - if EITHER country is EU, flag it...
	if lsToCntryEU = 'Y' or lsFromCntryEU = 'Y' then // what about null? or NoNull(lsFromCntryEU) = '') then  //EU Indicator
		lsTemp = '*'
		ldsFinanceTable.SetItem(llFinanceRow, 'EUCntry', '*')
	else
		lsTemp = ''
	end if
	lsOutString += lsTemp + "|"
	// 3rd-party logic here? (--> Any receipt received from a location that is not a DC or WHSE.)
	//now using 3rd-party flag in Customer Master (user_field8)
	//lsTemp = ldsDump_IB.GetItemString(llRowPos, 'Customer_type')  //3rd-Party
	//if not (lsTemp = 'DC' or lsTemp = 'WH' or lsTemp = 'Old') then //Tempo! - 'Old' is for P2Z transition (rename of Warehouses
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'ThirdParty')  //3rd-Party - if CU.UF8 is 'NO', then T_3rdParty is blank. Otherwise T_3rdParty = 'x'
	if lsTemp = 'x' then //Tempo! - 'Old' is for P2Z transition (rename of Warehouses
		ls3rdParty = 'Y' // for use later for Intrastat Report
		ldsFinanceTable.SetItem(llFinanceRow, 'ThirdParty', lsTemp)
	else
		lsTemp = ''
		ls3rdParty = 'N' // for use later for Intrastat Report
	end if
	lsOutString += lsTemp + "|"
//?	lsOutString += "|"  			//??? Dummy Customer flag - should only apply to outbound transactions.
	lsOrdType = ldsDump_IB.GetItemString(llRowPos, 'ord_type')
	//Per Emily, Return From Customer is flagged here.
	if lsOrdType = 'X' or lsOrdType = 'R' then  //Returns  dts - 2/4/10 - added 'R' condition (not sure why it wasn't already included)
		lsTemp = '*'
		ldsFinanceTable.SetItem(llFinanceRow, 'Returns', '*')
	else
		lsTemp = ''
	end if
	lsOutString += lsTemp + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'Ord_Type', lsOrdType)
	lsCommodity = upper(ldsDump_IB.GetItemString(llRowPos, 'Commodity')) //IM.UF5
	//11/29 - if lsTemp = 'RACK' or lsTemp = 'TLA' or lsTemp = 'MACHINED' then
	if lsCommodity = 'RACK' or lsCommodity = 'TLA' or lsCommodity = 'MACHINED' then
		//TEMP? flag if SHIPMENT contains 'RACK' (or can we do it just at the line level?)? 4/28/09 now Including TLA and Machined
		lsTemp = '*'
		ldsFinanceTable.SetItem(llFinanceRow, 'S_Commodity', '*')
	else
		lsTemp = ''
	end if
	ldsFinanceTable.SetItem(llFinanceRow, 'Commodity', lsCommodity)
	lsOutString += lsTemp + "|"
	//moved above...lsFromLoc = ldsDump_IB.GetItemString(llRowPos, 'FromLoc')
	lsOutString += NoNull(lsFromLoc) + "|"
//xxx	lsIntrastat += NoNull(lsFromLoc) + "|"
	if lsFromLoc > '' then
		//either Customer addr info or Supplier addr info...
		lsOutString += NoNull(lsFromName) + "|" + NoNull(lsFromAddr1) + "|" + NoNull(lsFromAddr2) + "|" + NoNull(lsFromCity) + "|" + NoNull(lsFromZip) + "|" + NoNull(lsFromCntry)  + "|"
	else
		lsOutString += "|" + "|" + "|" + "|" + "|"   + "|"
	end if
	if lsFromName > '' then
		lsIntrastat += NoNull(lsFromName) + "|"
	else
		lsIntrastat += NoNull(lsFromLoc) + "|"
	end if
	lsOutString += lsOrdType + "|"
	//Moved above (and using lsTransType)...lsTemp = ldsDump_IB.GetItemString(llRowPos, 'TransType') //RM.UF7
	lsOutString += NoNull(lsTransType) + "|"
	lsToLoc = upper(ldsDump_IB.GetItemString(llRowPos, 'ST_Loc')) //Customer Code for owner_id
	lsOutString += lsToLoc + "|" //ShipTo Location
	lsToName = ldsDump_IB.GetItemString(llRowPos, 'ST_Name')
	lsToAddr1 = ldsDump_IB.GetItemString(llRowPos, 'ST_Addr1')
	lsToAddr2 = ldsDump_IB.GetItemString(llRowPos, 'ST_Addr2')
	lsToCity = ldsDump_IB.GetItemString(llRowPos, 'ST_City')
	lsToZip = ldsDump_IB.GetItemString(llRowPos, 'ST_Zip')
//moved above	lsToCntry = ldsDump_IB.GetItemString(llRowPos, 'ST_Cntry')
	lsOutString += NoNull(lsToName) + "|" + NoNull(lsToAddr1) + "|" + NoNull(lsToAddr2) + "|" + NoNull(lsToCity) + "|" + NoNull(lsToZip) + "|" + NoNull(lsToCntry)  + "|" 
	ldsFinanceTable.SetItem(llFinanceRow, 'Owner_CD', lsToLoc)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Loc', lsToLoc)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Name', lsToName)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Addr1', lsToAddr1)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Addr2', lsToAddr2)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_City', lsToCity)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Zip', lsToZip)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Cntry', lsToCntry)
	
//?		lsOutString += lsTemp + "|"

 /*    Sold To - assuming same as receiving location for inbound
//TODO! - 10/09 - per emily, "Sold-to should be Either receiving location's sold-to address or leave blank!!!"
Soldto_Cust.Cust_Name
Soldto_Cust.Address_1
Soldto_Cust.Address_2
Soldto_Cust.City
Soldto_Cust.Zip
Soldto_Cust.Country
*/
//	lsOutString += "|" + "|" + "|" + "|" + "|" + "|"  // Sold To - assuming same as receiving location for inbound
	lsOutString += NoNull(lsToName) + "|" + NoNull(lsToAddr1) + "|" + NoNull(lsToAddr2) + "|" + NoNull(lsToCity) + "|" + NoNull(lsToZip) + "|" + NoNull(lsToCntry)  + "|" 

	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Cntry', lsToCntry)

//Sold-To added 02/04/2010
//Look up Sold To in Customer_Address table (have to blank out the variables because they aren't nulled if no Address record found)
//International only???
	lsSoldName = ""; lsSoldAddr1 = ""; lsSoldAddr2 = ""; lsSoldCity = ""; lsSoldZip = ""; lsSoldCntry = ""
	select address_name, address_1, address_2, city, zip, country
	into :lsSoldName, :lsSoldAddr1, :lsSoldAddr2, :lsSoldCity, :lsSoldZip, :lsSoldCntry
	from Customer_Address
	where project_id = 'PANDORA'
	and cust_code = :lsToLoc
	and address_code = 'ST';
//x	lsOutString += NoNull(lsSoldName) + "|" + NoNull(lsSoldAddr1) + "|" + NoNull(lsSoldAddr2) + "|" + NoNull(lsSoldCity) + "|" + NoNull(lsSoldZip) + "|" + NoNull(lsSoldCntry)  + "|" 
// Populating Sold-To address info in Finance Table
	if lsSoldName > '' then
		ldsFinanceTable.SetItem(llFinanceRow, 'SoldTo_Name', lsSoldName)
		ldsFinanceTable.SetItem(llFinanceRow, 'SoldTo_Addr1', lsSoldAddr1)
		ldsFinanceTable.SetItem(llFinanceRow, 'SoldTo_Addr2', lsSoldAddr2)
		ldsFinanceTable.SetItem(llFinanceRow, 'SoldTo_City', lsSoldCity)
		ldsFinanceTable.SetItem(llFinanceRow, 'SoldTo_Zip', lsSoldZip)
		ldsFinanceTable.SetItem(llFinanceRow, 'SoldTo_Cntry', lsSoldCntry)
	end if

/////////////////////////
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'SKU')
	lsOutString += lsTemp + "|"
	lsIntrastat += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'SKU', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'Description')
	lsOutString += lsTemp + "|"
	lsIntrastat += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'Description', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'VendorName') //RM.UF9
	lsOutString += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'VendorName', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'Alternate_Sku')
	lsOutString += NoNull(lsTemp) + "|" // 'Mfg Part'
	ldsFinanceTable.SetItem(llFinanceRow, 'Alternate_SKU', lsTemp)
	lsTemp = string(ldsDump_IB.GetItemNumber(llRowPos, 'Alloc_qty'))
	lsOutString += lsTemp + "|"
	lsIntrastat += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'Alloc_qty', double(lsTemp))
//12/12	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'HTS_US') //added 11/30/09 for Finance_Data table
//12/12	ldsFinanceTable.SetItem(llFinanceRow, 'HTS_US', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'HTS_EU')
	lsIntrastat += NoNull(lsTemp) + "|" //Use HTS code for Commodity on Intrastat Rpt
//12/12	ldsFinanceTable.SetItem(llFinanceRow, 'HTS_EU', lsTemp)
/* TODO?
?pass record-specific lsOut to function, then parse it into new datastore?
?Create Finance Structure, set structure variables and then build lsOutString and datastore record from that?
 - could call a function that puts the '|' between each field and then return the string variable
*/
	//Country of Dispatch. Use RM.UF5, if Present. Otherwise, use lsFromCntry (which may have real data if ShipFrom is a CustomerCode)
	// 3/18/2010 - moved above to set SF_Cntry and Intl as appropriate lsTemp = ldsDump_IB.GetItemString(llRowPos, 'CntryOfDispatch')
	//if lsTemp > '' then
	if lsCntryOfDispatch > '' then // 3/18/2010 - moved above to set SF_Cntry and Intl as appropriate
		lsIntrastat += NoNull(lsCntryOfDispatch) + "|"
		// 3/11/10 ldsFinanceTable.SetItem(llFinanceRow, 'CntryOfDispatch', lsTemp)
		//ldsFinanceTable.SetItem(llFinanceRow, 'SF_Cntry', lsTemp)
	else
		lsIntrastat += NoNull(lsFromCntry) + "|"
		// 3/11/10 ldsFinanceTable.SetItem(llFinanceRow, 'CntryOfDispatch', lsFromCntry)
	end if
	//Country of Destination...
	lsIntrastat += NoNull(lsToCntry) + "|"
//xxx
	lsCost = string(ldsDump_IB.GetItemNumber(llRowPos, 'Cost'))
	lsOutString += NoNull(lsCost) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'Cost', double(lsCost))
	lsExtCost = string(ldsDump_IB.GetItemNumber(llRowPos, 'ExtendedCost'))
	lsOutString += NoNull(lsExtCost) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'ExtendedCost', double(lsExtCost))
	lsCur = ldsDump_IB.GetItemString(llRowPos, 'CurCode') //RD.UF1\
	lsOutString += NoNull(lsCur) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'CurCode', lsCur) // 02-04-2010
	if lsToCntry = 'US' then
		lsTemp = ldsDump_IB.GetItemString(llRowPos, 'HTS_US') //TEMP!! What about non-US and non-EU?
	else
		lsTemp = ldsDump_IB.GetItemString(llRowPos, 'HTS_EU')
	end if
	lsOutString += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'HTS', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'ECCN')
	lsOutString += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'ECCN', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'COO') //This should come from Put-away, not detail
	lsOutString += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'COO', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'COO_Default') //Should come from Put-away? Getting it from IM
	lsIntrastat += NoNull(lsTemp) + "|"
//12/12	ldsFinanceTable.SetItem(llFinanceRow, 'COO_Default', lsTemp)
	//Transport Mode Code: Air = 4, Road = 3
	// - For now, assuming everything not 'AIR' or 'OCEAN' is ROAD
	lsMode = upper(ldsDump_IB.GetItemString(llRowPos, 'Transport_Mode'))
	if lsMode = 'OCEAN' then
		lsIntrastat += "1|"
		lsIntrastat += "OCEAN|"
	ElseIf lsMode = 'AIR' then
		lsIntrastat += "4|"
		lsIntrastat += "AIR|"
	else
		lsIntrastat += "3|"
		lsIntrastat += "ROAD|"
	end if
	ldsFinanceTable.SetItem(llFinanceRow, 'Transport_Mode', lsMode)
	//Nature of Transaction: Sale = 1, Return = 2
	// - OrdType = R - Return from Supplier and 'X' - Return from Customer
	if lsOrdType = 'R' or lsOrdType = 'X' then
		lsIntrastat += "2|"
		lsIntrastat += "RETURN OF GOODS OR REPLACEMENT GOODS|"
	else
		lsIntrastat += "1|"
		lsIntrastat += "SALE PURCHASE|"
	end if
	lsIntrastat += NoNull(lsCost) + "|"
	lsIntrastat += NoNull(lsExtCost) + "|"
	//Delivery Terms are 'CPT' (unless 3rd-Party?) if ls3rdParty = 'Y' then
	lsIntrastat += "CPT|"
	ldWgt = ldsDump_IB.GetItemNumber(llRowPos, 'Wgt')
	if isnull(ldWgt) then ldWgt = 0
	ldExtWgt = ldsDump_IB.GetItemNumber(llRowPos, 'ExtendedWgt')
	if isnull(ldExtWgt) then ldExtWgt = 0
	//convert to Kilograms (do we need to make sure the value in Item Master is English?
	ldWgt = round(ldWgt * .4536, 2)
	lsIntrastat += string(ldWgt) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'WGT', ldWgt)
	ldExtWgt = round(ldExtWgt * .4536, 2)
	lsIntrastat += string(ldExtWgt) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'ExtendedWgt', ldExtWgt)
	lsTemp = upper(ldsDump_IB.GetItemString(llRowPos, 'Vat_ID'))
	lsIntrastat += NoNull(lsTemp) + "|"
	lsIntrastat += NoNull(lsCur) + "|"

	/*Supplier Integration: 'X' if we have Org (for now)
if In_Out = IB, Group field from Ship-To Customer Master = GIG, BUILDS, DECOM, NPI, HWOPS or Transaction type = PO RECEIPT
if In_Out = OB, Group field from Ship-From Customer Master = GIG, BUILDS, DECOM, NPI, HWOPS
*/
// - look up org based on receiving owner...
//moved above...	lsToLoc = ldsDump_IB.GetItemString(llRowPos, 'ST_Loc') //Customer Code for owner_id
	//lsOrg = ''
	lsOrg = upper(ldsDump_IB.GetItemString(llRowPos, 'ORG')) //Customer.UF3 // 02-04-2010
	lsGroup = upper(ldsDump_IB.GetItemString(llRowPos, 'GroupCode')) //Customer.UF1
	
	//select user_field3 into :lsOrg 	from customer 	where project_id = 'PANDORA' and cust_code = :lsToLoc;
	// if lsOrg > "" then
	// 4-30-09 : now using ShipFrom Loc code ends in $$HEX1$$1820$$ENDHEX$$G$$HEX2$$19202000$$ENDHEX$$or $$HEX1$$1820$$ENDHEX$$P$$HEX2$$19202000$$ENDHEX$$(GIG or Plat-Builds)
	//	if right(lsToLoc, 1) = 'G'  or right(lsToLoc, 1) = 'P' then
	//		lsOutString += "X" + "|"
	//	else
	//		lsOutString += "|"
	//	end if
	// - 02/04/10 - Replaced 'BUILDS' with 'PLAT'... if left(lsGroup, 3) = 'GIG' or left(lsGroup, 6) = 'BUILDS' or left(lsGroup, 5) = 'DECOM' or left(lsGroup, 3) = 'NPI' or left(lsGroup, 5) = 'HWOPS' then
	// - 02/27/10 - Added RMA and SCRAP if left(lsGroup, 3) = 'GIG' or left(lsGroup, 4) = 'PLAT' or left(lsGroup, 5) = 'DECOM' or left(lsGroup, 3) = 'NPI' or left(lsGroup, 5) = 'HWOPS' then
	//   03/14/10 - now setting SI to 'x' if either Ship-From or ship-to loc qualifies....
	//   05/12/2010 - added 'SI-CUSTOMER' (actually, SI-CUSTOME due to 10-char limit)
	// 9/23/2010 - added 'GEO'
	// TimA 07/15/2011 Added NETOPS
	if left(lsGroup, 3) = 'GIG' or left(lsGroup, 4) = 'PLAT' or left(lsGroup, 3) = 'ENT' or left(lsGroup, 5) = 'HWOPS' or left(lsGroup, 5) = 'DECOM'  or left(lsGroup, 3) = 'NPI' or left(lsGroup, 5) = 'SCRAP' or left(lsGroup, 3) = 'RMA' or left(lsGroup, 9) = 'NETDEPLOY' or left(lsGroup, 2) = 'CB' or left(lsGroup, 10) = 'SI-CUSTOME' or left(lsGroup, 5) = 'DCOPS' or left(lsGroup, 3) = 'GEO' or left(lsGroup, 6) = 'NETOPS' &
	   or left(lsFromGroup, 3) = 'GIG' or left(lsFromGroup, 4) = 'PLAT' or left(lsFromGroup, 3) = 'ENT' or left(lsFromGroup, 5) = 'HWOPS' or left(lsFromGroup, 5) = 'DECOM' or left(lsFromGroup, 3) = 'NPI' or left(lsFromGroup, 5) = 'SCRAP' or left(lsFromGroup, 3) = 'RMA' or left(lsFromGroup, 9) = 'NETDEPLOY' or left(lsFromGroup, 2) = 'CB' or left(lsFromGroup, 10) = 'SI-CUSTOME' or left(lsFromGroup, 5) = 'DCOPS' or left(lsFromGroup, 3) = 'GEO' or left(lsFromGroup, 6) = 'NETOPS'  then
		lsOutString += "x" + "|"
		ldsFinanceTable.SetItem(llFinanceRow, 'Supl_Integration', 'X')
	else
		lsOutString += "|"
	end if
		
//	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'Org') //RM.UF1
	lsOutString += NoNull(lsOrg) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'ORG', lsOrg) // 02-04-2010
	//Need to look up Project (rp.PO_NO) 
	lsPandoraProject = ''
	select max(po_no), max(inventory_type) into :lsPandoraProject, :lsInvType
	from receive_putaway
	where ro_no = :lsRONO
	and line_item_no = :lsLine;
	
	lsOutString += NoNull(lsPandoraProject) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'po_no', lsPandoraProject)
	//lsOutString += "|" //CostCenter - Customer.UF7
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'CostCenter') //Customer.UF7
	lsOutString += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'CostCenter', lsTemp)
	lsOutString += "|" //ValueID
	lsOutString += "|" //CI No.
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'Requestor')
	lsOutString += NoNull(lsTemp) + "|"
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'Remark')
	lsOutString += NoNull(lsTemp) + "|"
	// 01/10 - added AWB and InvType to Finance Table
	  // - for Inbound, probably need to get InvType from put-away (so far, coming from RM)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'awb_bol_no')
// 3/12/10: per Revathy, ignore for Inbound...	ldsFinanceTable.SetItem(llFinanceRow, 'awb_bol_no', lsTemp)
//TEMPO - Need to change datastore to get this from put-away!	lsInvType = ldsDump_IB.GetItemString(llRowPos, 'inventory_type')
	ldsFinanceTable.SetItem(llFinanceRow, 'inventory_type', lsInvType)

	//TEMPO!! - Format for qty?....
//	lsTemp = String(ldsBOH.GetItemNumber(llRowPos, 'total_qty'), "#############")

	ldsOut.SetItem(llNewRow, 'Project_id', lsproject)
	ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)

	//if lsToCntryEU = 'Y' and lsFromCntryEU = 'Y' then
	//if lsToCntryEU = 'Y' and lsFromCntryEU = 'Y' and lsFromCntry <> lsToCntry then
	if lsToCntryEU = 'Y' and (lsFromCntryEU = 'Y' or IsNull(lsFromCntryEU)) and lsFromCntry <> lsToCntry then
		ldsOut_IntrIB.SetItem(llNewRow_Intr, 'Project_id', lsproject)
		ldsOut_IntrIB.SetItem(llNewRow_Intr, 'file_name', lsFileName_IntrIB)
		ldsOut_IntrIB.SetItem(llNewRow_Intr, 'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut_IntrIB.SetItem(llNewRow_Intr, 'line_seq_no', llNewRow_Intr)
		ldsOut_IntrIB.SetItem(llNewRow_Intr, 'batch_data', lsIntrastat)
	end if
	
	//we don't want the Inbound half of Warehouse transfers included in the Finance report (double dipping)....
	if lsOrdType = 'Z' then
		ldsFinanceTable.DeleteRow(llFinanceRow)
	end if
	// 3/19/10 - per Revathy, if 'From LOC' or 'To Loc' = 'Cyclecount', 'GPN_Change', 'MIM_GPN' then don't include in Finance Report
	if lsFromLoc = 'CYCLECOUNT' or lsFromLoc = 'GPN_CHANGE' or lsFromLoc = 'MIM_GPN' then
		ldsFinanceTable.DeleteRow(llFinanceRow)
	end if
	
next /*next output record for Inbound Transactions */

//TEMPO!!! - TESTING!
//Save New records to DB
lirc = ldsFinanceTable.Update()
If liRC = 1 then
	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Finance Table record(s) to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Finance Table Record to database!")
	Return -1
//	Continue
End If

// *********************************************************************************************
// *******************    OUTBOUND   ***************************************************************
// *********************************************************************************************
lsLogOut = 'Processing Outbound Finance Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

llNewRow_Intr = 0
liThousands = 1
For llRowPos = 1 to llRowCount_OB
	if llRowPos - (liThousands * 1000) = 0 then
		lsLogOut = string(liThousands * 1000) + ' records processed.....'
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		FileWrite(gilogFileNo,lsLogOut)
		liThousands += 1
	end if
	llNewRow = ldsOut.insertRow(0)
	llFinanceRow = ldsFinanceTable.InsertRow(0)
	ldsFinanceTable.SetItem(llFinanceRow, 'In_Out', 'OB')
	//TEMP! need to look up EU Cntry Indicator for From / To
	//           - if both are EU Countries, then '*'...
	//lsTemp = ldsDump_IB.GetItemString(llRowPos, 'wh_code')
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'wh_code')
	ldsFinanceTable.SetItem(llFinanceRow, 'wh_code', lsTemp)

	lsFromCntryEU = ldsDump_OB.GetItemString(llRowPos, 'FromCntry_EU')
	lsToCntryEU = ldsDump_OB.GetItemString(llRowPos, 'ToCntry_EU')

	//moved this from below so that From/To countries are available for Intrastat determination...
	lsFromLoc = upper(ldsDump_OB.GetItemString(llRowPos, 'FromLoc')) //Cust_code associated with dd.owner_id
	if lsFromLoc > '' then
		select cust_name, address_1, address_2, city, zip, country
		into :lsFromName, :lsFromAddr1, :lsFromAddr2, :lsFromCity, :lsFromZip, :lsFromCntry
		from customer
		where project_id = 'PANDORA'
		and cust_code = :lsFromLoc;
		lsOutString += NoNull(lsFromName) + "|" + NoNull(lsFromAddr1) + "|" + NoNull(lsFromAddr2) + "|" + NoNull(lsFromCity) + "|" + NoNull(lsFromZip) + "|" + NoNull(lsFromCntry)  + "|" 
		// 2/19/2010 - now using lsFromLoc instead of lsFromName (not sure why it was lsFromName???)
		ldsFinanceTable.SetItem(llFinanceRow, 'owner_cd', lsFromLoc)
		ldsFinanceTable.SetItem(llFinanceRow, 'FromLoc', lsFromLoc)
		ldsFinanceTable.SetItem(llFinanceRow, 'SF_Name', lsFromName) //added 2/19/2010
		ldsFinanceTable.SetItem(llFinanceRow, 'SF_Addr1', lsFromAddr1)
		ldsFinanceTable.SetItem(llFinanceRow, 'SF_Addr2', lsFromAddr2)
		ldsFinanceTable.SetItem(llFinanceRow, 'SF_City', lsFromCity)
		ldsFinanceTable.SetItem(llFinanceRow, 'SF_Zip', lsFromZip)
		ldsFinanceTable.SetItem(llFinanceRow, 'SF_Cntry', lsFromCntry)
	end if
	lsToCntry = ldsDump_OB.GetItemString(llRowPos, 'ST_Cntry')
	lsIntrastat = ''
	//if lsToCntryEU = 'Y' and lsFromCntryEU = 'Y' then
	//if lsToCntryEU = 'Y' and lsFromCntryEU = 'Y' and lsFromCntry <> lsToCntry then //xxx
	if lsFromCntryEU = 'Y' and (lsToCntryEU = 'Y' or IsNull(lsToCntryEU)) and lsFromCntry <> lsToCntry then
		llNewRow_Intr = ldsOut_IntrOB.insertRow(0)
	end if
	lsInvoice = ldsDump_OB.GetItemString(llRowPos, 'invoice_no')
	//lsOutstring = 'OB' + "|"
	//10/20 - added 'INTL' flag
	if lsFromCntry <> lsToCntry then
		lsOutstring = 'X' + "|"
		ldsFinanceTable.SetItem(llFinanceRow, 'Intl', 'X')
		ldsFinanceTable.SetItem(llFinanceRow, 'CI_Num', lsInvoice) // added 3/09/10
	else
		lsOutstring = "|"
	end if
	lsOutstring += 'OB' + "|"
	lsTemp = string(ldsDump_OB.GetItemDateTime(llRowPos, 'complete_date'))
	lsOutString += lsTemp + "|"
	lsIntrastat += lsTemp + "|"
	ldtCompleteDate = datetime(lsTemp)
	ldsFinanceTable.SetItem(llFinanceRow, 'complete_date', ldtCompleteDate)
	//04/28/09 - adding do_no for uniqueness
	lsDONO = ldsDump_OB.GetItemString(llRowPos, 'do_no')
	lsOutString += lsDONO + "|"		
	lsIntrastat += lsDONO + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'System_Number', lsDONO)
	// 3/11/2010 moved above...lsTemp = ldsDump_OB.GetItemString(llRowPos, 'invoice_no')
	lsOutString += lsInvoice + "|"
	lsIntrastat += lsInvoice + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'Invoice_No', lsInvoice)
	lsLine = string(ldsDump_OB.GetItemNumber(llRowPos, 'line_item_no'))
	lsOutString += lsLine + "|"
	lsIntrastat += lsLine + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'line_item_no', long(lsLine))
	// 02/04/2010 - if lsFromCntryEU = 'Y' and lsToCntryEU = 'Y' then  //EU Indicator
	//  If EITHER country is EU, then flag it.
	//if lsFromCntryEU = 'Y' and (lsToCntryEU = 'Y' or IsNull(lsToCntryEU)) and lsFromCntry <> lsToCntry then
	if lsFromCntryEU = 'Y' or lsToCntryEU = 'Y' then // what about null? or IsNull(lsToCntryEU)) then
		lsTemp = '*'
		ldsFinanceTable.SetItem(llFinanceRow, 'EUCntry', '*')
	else
		lsTemp = ''
	end if
	lsOutString += lsTemp + "|"
//	 //Dummy Customer flag - are we to use the 'GENSHIPTO' customer? Any others???
//	lsToLoc = ldsDump_OB.GetItemString(llRowPos, 'ST_Loc') //3rd-Party
//	if lsToLoc = 'GENSHIPTO' then
//		lsTemp = '*'
//	else
//		lsTemp = ''
//	end if
	// 3rd-party: 4/28/04 - now Any ShipTo location that is not a DC or WH.)
	//12/20/09 - now using 3rd-party flag in Customer Master (user_field8)
	/*			lsTemp = ldsDump_OB.GetItemString(llRowPos, 'Customer_type')  //3rd-Party
				if not (lsTemp = 'DC' or lsTemp = 'WH' or lsTemp = 'Old') then //Tempo! - 'Old' is for P2Z transition (rename of Warehouses
					lsTemp = '*'
					ls3rdParty = 'Y' // for use later for Intrastat Report
				else
					lsTemp = ''
					ls3rdParty = 'N' // for use later for Intrastat Report
				end if
	*/
	
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'ThirdParty')  //3rd-Party - if CU.UF8 is 'NO', then T_3rdParty is blank. Otherwise T_3rdParty = 'x'
	if lsTemp = 'x' then //Tempo! - 'Old' is for P2Z transition (rename of Warehouses
		ls3rdParty = 'Y' // for use later for Intrastat Report
		ldsFinanceTable.SetItem(llFinanceRow, 'ThirdParty', lsTemp)
	else
		lsTemp = ''
		ls3rdParty = 'N' // for use later for Intrastat Report
	end if
	
	lsOutString += lsTemp + "|"
	lsOrdType = ldsDump_OB.GetItemString(llRowPos, 'ord_type')
	//What order type? Per Emily, flag Return to Supplier
	if lsOrdType = 'X' then 
		lsTemp = '*'
		ldsFinanceTable.SetItem(llFinanceRow, 'Returns', lsTemp)
	else
		lsTemp = ''
	end if
	lsOutString += lsTemp + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'ord_type', lsOrdType)
	lsCommodity = upper(ldsDump_OB.GetItemString(llRowPos, 'Commodity')) //IM.UF5
	if lsCommodity = 'RACK' or lsCommodity = 'TLA' or lsCommodity = 'MACHINED' then
		//TEMP? flag if SHIPMENT contains 'RACK' (or can we do it just at the line level?)? Yes, at the line level. 4/28/09 now Including TLA and Machined
		lsTemp = '*'
		ldsFinanceTable.SetItem(llFinanceRow, 's_commodity', lsTemp)
	else
		lsTemp = ''
	end if
	lsOutString += lsTemp + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'Commodity', lsCommodity)
	//moved above lsFromLoc = upper(ldsDump_OB.GetItemString(llRowPos, 'FromLoc')) //Cust_code associated with dd.owner_id
	lsOutString += NoNull(lsFromLoc) + "|"
	//look up address info in Customer Table. If it's not there, leave blank....
	if lsFromLoc > '' then
		lsOutString += NoNull(lsFromName) + "|" + NoNull(lsFromAddr1) + "|" + NoNull(lsFromAddr2) + "|" + NoNull(lsFromCity) + "|" + NoNull(lsFromZip) + "|" + NoNull(lsFromCntry)  + "|" 
	else
		lsOutString += "|" + "|" + "|" + "|" + "|"   + "|" 
	end if
	lsOutString += lsOrdType + "|"
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'TransType') //RM.UF7
	lsOutString += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'TransType', lsTemp)
	lsToLoc = upper(ldsDump_OB.GetItemString(llRowPos, 'ST_Loc'))  //Customer Code , 3/19/10 - added 'upper'
	lsOutString += NoNull(lsToLoc) + "|"
//xxx	lsIntrastat += NoNull(lsToLoc) + "|"
	lsToName = ldsDump_OB.GetItemString(llRowPos, 'ST_Name')
	lsIntrastat += NoNull(lsToName) + "|"
	lsToAddr1 = ldsDump_OB.GetItemString(llRowPos, 'ST_Addr1')
	lsToAddr2 = ldsDump_OB.GetItemString(llRowPos, 'ST_Addr2')
	lsToCity = ldsDump_OB.GetItemString(llRowPos, 'ST_City')
	lsToZip = ldsDump_OB.GetItemString(llRowPos, 'ST_Zip')
	//moved above... lsToCntry = ldsDump_OB.GetItemString(llRowPos, 'ST_Cntry')
	lsOutString += NoNull(lsToName) + "|" + NoNull(lsToAddr1) + "|" + NoNull(lsToAddr2) + "|" + NoNull(lsToCity) + "|" + NoNull(lsToZip) + "|" + NoNull(lsToCntry)  + "|" 
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Loc', lsToLoc)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Name', lsToName)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Addr1', lsToAddr1)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Addr2', lsToAddr2)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_City', lsToCity)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Zip', lsToZip)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Cntry', lsToCntry)

//?		lsOutString += lsTemp + "|"

//Look up Sold To in Customer_Address table (have to blank out the variables because they aren't nulled if no Address record found)
// 03/18/09 - now grabbing Sold-to from Order (delivery_alt_address)
	lsSoldName = ""; lsSoldAddr1 = ""; lsSoldAddr2 = ""; lsSoldCity = ""; lsSoldZip = ""; lsSoldCntry = ""
	select Name, address_1, address_2, city, zip, country
	into :lsSoldName, :lsSoldAddr1, :lsSoldAddr2, :lsSoldCity, :lsSoldZip, :lsSoldCntry
	from delivery_alt_address 			//Customer_Address
	where project_id = 'PANDORA'
	and do_no = :lsDONO
	and address_type = 'ST';
//	and cust_code = :lsToLoc;
//  - 3/18/2010 - now grabbing from customer if not present on order
	if lsSoldName = '' then
		select address_1, address_2, city, zip, country
		into :lsSoldAddr1, :lsSoldAddr2, :lsSoldCity, :lsSoldZip, :lsSoldCntry
		from Customer_Address
		where project_id = 'PANDORA'
		and address_code = 'ST'
		and cust_code = :lsToLoc;
		if lsSoldAddr1 > '' then
			lsSoldName = lsToName
		end if
	end if
	lsOutString += NoNull(lsSoldName) + "|" + NoNull(lsSoldAddr1) + "|" + NoNull(lsSoldAddr2) + "|" + NoNull(lsSoldCity) + "|" + NoNull(lsSoldZip) + "|" + NoNull(lsSoldCntry)  + "|" 
// 01/10 ... Populating Sold-To address info in Finance Table
	if lsSoldName > '' then
		ldsFinanceTable.SetItem(llFinanceRow, 'SoldTo_Name', lsSoldName)
		ldsFinanceTable.SetItem(llFinanceRow, 'SoldTo_Addr1', lsSoldAddr1)
		ldsFinanceTable.SetItem(llFinanceRow, 'SoldTo_Addr2', lsSoldAddr2)
		ldsFinanceTable.SetItem(llFinanceRow, 'SoldTo_City', lsSoldCity)
		ldsFinanceTable.SetItem(llFinanceRow, 'SoldTo_Zip', lsSoldZip)
		ldsFinanceTable.SetItem(llFinanceRow, 'SoldTo_Cntry', lsSoldCntry)
	end if

	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'SKU')
	lsOutString += lsTemp + "|"
	lsIntrastat += lsTemp + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'SKU', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'Description')
	lsOutString += lsTemp + "|"
	lsIntrastat += lsTemp + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'Description', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'VendorName') 
	lsOutString += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'VendorName', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'Alternate_Sku')
	lsOutString += NoNull(lsTemp) + "|" // 'Mfg Part'
	ldsFinanceTable.SetItem(llFinanceRow, 'alternate_sku', lsTemp)
//	lsTemp = string(ldsDump_OB.GetItemNumber(llRowPos, 'Alloc_qty'))
	lsTemp = string(ldsDump_OB.GetItemNumber(llRowPos, 'PickQTY')) //sum of picking qty for group by
	lsOutString += lsTemp + "|"
	lsIntrastat += lsTemp + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'alloc_qty', double(lsTemp))
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'HTS_EU')
	lsIntrastat += NoNull(lsTemp) + "|" //Use HTS code for Commodity on Intrastat Rpt
//12/12	ldsFinanceTable.SetItem(llFinanceRow, 'HTS_EU', lsTemp)
	lsIntrastat += NoNull(lsFromCntry) + "|"
	//Ship-To Country
	lsIntrastat += NoNull(lsToCntry) + "|"
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'COO_Default') //Should this come from Picking? Getting it from IM
	lsIntrastat += NoNull(lsTemp) + "|"
	//Transport Mode Code: Air = 4, Road = 3
	// - For now, assuming everything not 'AIR' or 'OCEAN' is ROAD
	lsMode = upper(ldsDump_OB.GetItemString(llRowPos, 'Transport_Mode'))
	if lsMode = 'OCEAN' then
		lsIntrastat += "1|"
		lsIntrastat += "OCEAN|"
	ElseIf lsMode = 'AIR' then
		lsIntrastat += "4|"
		lsIntrastat += "AIR|"
	else
		lsIntrastat += "3|"
		lsIntrastat += "ROAD|"
	end if
	ldsFinanceTable.SetItem(llFinanceRow, 'Transport_Mode', lsMode)
	//Nature of Transaction: Sale = 1, Return = 2
	// - OrdType = X - Return to Supplier and 'A' - Advance Replacement
	if lsOrdType = 'R' or lsOrdType = 'X' then
		lsIntrastat += "2|"
		lsIntrastat += "RETURN OF GOODS OR REPLACEMENT GOODS|"
	else
		lsIntrastat += "1|"
		lsIntrastat += "SALE PURCHASE|"
	end if

	lsTemp = string(ldsDump_OB.GetItemNumber(llRowPos, 'Price'))
	lsOutString += NoNull(lsTemp) + "|"
	lsIntrastat += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'Cost', double(lsTemp))
	lsTemp = string(ldsDump_OB.GetItemNumber(llRowPos, 'ExtendedCost'))
	lsOutString += NoNull(lsTemp) + "|"
	lsIntrastat += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'ExtendedCost', double(lsTemp))

	//Delivery Terms are 'CPT' (unless 3rd-Party)
	if ls3rdParty = 'Y' then
		lsTemp = ldsDump_OB.GetItemString(llRowPos, 'Freight_Terms')
		lsIntrastat += NoNull(lsTemp) + "|"
	else
		lsIntrastat += "CPT|"
	end if
	ldWgt = ldsDump_OB.GetItemNumber(llRowPos, 'Wgt')
	if isnull(ldWgt) then ldWgt = 0
	ldExtWgt = ldsDump_OB.GetItemNumber(llRowPos, 'ExtendedWgt')
	if isnull(ldExtWgt) then ldExtWgt = 0
	//convert to Kilograms (do we need to make sure the value in Item Master is English?
	ldWgt = round(ldWgt * .4536, 2)
	lsIntrastat += string(ldWgt) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'WGT', ldWgt)
	ldExtWgt = round(ldExtWgt * .4536, 2)
	lsIntrastat += string(ldExtWgt) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'ExtendedWGT', ldExtWgt)
	if ls3rdParty = 'Y' then
		lsIntrastat += "Y|"
	else
		lsIntrastat += "|"
	end if
	lsTemp = upper(ldsDump_OB.GetItemString(llRowPos, 'Vat_ID'))
	lsIntrastat += NoNull(lsTemp) + "|"

	lsCur = ldsDump_OB.GetItemString(llRowPos, 'CurCode')
	lsOutString += NoNull(lsCur) + "|"
	lsIntrastat += NoNull(lsCur) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'CurCode', lsCur) // 02-04-2010
	if lsToCntry = 'US' then
		lsTemp = ldsDump_OB.GetItemString(llRowPos, 'HTS_US') //TEMP!! What about non-US and non-EU?
	else
		lsTemp = ldsDump_OB.GetItemString(llRowPos, 'HTS_EU')
	end if
	lsOutString += NoNull(lsTemp) + "|"
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'ECCN')
	lsOutString += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'ECCN', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'COO') // COO from delivery_picking
	lsOutString += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'COO', lsTemp)

	//Supplier Integration: 'X' if we have Org (for now)
	// - look up org based on owner...
	/*		//Moved above...	lsToLoc = ldsDump_OB.GetItemString(llRowPos, 'ST_Loc') //Customer Code for owner_id
				lsOrg = '' 
				select user_field3 into :lsOrg 
				from customer	where project_id = 'PANDORA'
				and cust_code = :lsFromLoc;
				//if lsOrg > "" then
			//TODO! what is the logic for this now?
				// 4-30-09 : now using ShipFrom Loc code ends in $$HEX1$$1820$$ENDHEX$$G$$HEX2$$19202000$$ENDHEX$$or $$HEX1$$1820$$ENDHEX$$P$$HEX2$$19202000$$ENDHEX$$(GIG or Plat-Builds)
				if right(lsFromLoc, 1) = 'G'  or right(lsFromLoc, 1) = 'P' then
					lsOutString += "X" + "|"
				else
					lsOutString += "|"
				end if
	*/
	lsOrg = upper(ldsDump_OB.GetItemString(llRowPos, 'ORG')) //Customer.UF3 - 2/4/2010
	lsGroup = upper(ldsDump_OB.GetItemString(llRowPos, 'GroupCode')) //Customer.UF1
	// - 02/04/10 - Replaced 'BUILDS' with 'PLAT'... if left(lsGroup, 3) = 'GIG' or left(lsGroup, 6) = 'BUILDS' or left(lsGroup, 5) = 'DECOM' or left(lsGroup, 3) = 'NPI' or left(lsGroup, 5) = 'HWOPS' then
	// - 02/27/10 - Added RMA and SCRAP if left(lsGroup, 3) = 'GIG' or left(lsGroup, 4) = 'PLAT' or left(lsGroup, 5) = 'DECOM' or left(lsGroup, 3) = 'NPI' or left(lsGroup, 5) = 'HWOPS' then
	//   3/14/10 - now setting SI to 'x' if either Ship-From or ship-to loc qualifies....
	//   05/12/2010 - added 'SI-CUSTOMER' (actually, SI-CUSTOME due to 10-char limit)
	// TimA 07/15/2011 Added NETOPS
	lsToGroup = ''
	select user_field1
	into :lsToGroup
	from customer
	where project_id = 'PANDORA'
	and cust_code = :lsToLoc;
	if left(lsGroup, 3) = 'GIG' or left(lsGroup, 4) = 'PLAT' or left(lsGroup, 3) = 'ENT' or left(lsGroup, 5) = 'HWOPS' or left(lsGroup, 5) = 'DECOM'  or left(lsGroup, 3) = 'NPI' or left(lsGroup, 5) = 'SCRAP' or left(lsGroup, 3) = 'RMA' or left(lsGroup, 9) = 'NETDEPLOY' or left(lsGroup, 2) = 'CB' or left(lsGroup, 11) = 'SI-CUSTOME' or left(lsGroup, 5) = 'DCOPS' or left(lsGroup, 3) = 'GEO' or left(lsGroup, 6) = 'NETOPS' &
	   or left(lsToGroup, 3) = 'GIG' or left(lsToGroup, 4) = 'PLAT' or left(lsToGroup, 3) = 'ENT' or left(lsToGroup, 5) = 'HWOPS' or left(lsToGroup, 5) = 'DECOM' or left(lsToGroup, 3) = 'NPI' or left(lsToGroup, 5) = 'SCRAP' or left(lsToGroup, 3) = 'RMA' or left(lsToGroup, 9) = 'NETDEPLOY' or left(lsToGroup, 2) = 'CB' or left(lsToGroup, 11) = 'SI-CUSTOME' or left(lsToGroup, 5) = 'DCOPS' or left(lsToGroup, 3) = 'GEO' or left(lsToGroup, 6) = 'NETOPS'  then
		lsOutString += "x" + "|"
		ldsFinanceTable.SetItem(llFinanceRow, 'Supl_Integration', 'X')
	else
		lsOutString += "|"
	end if


//	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'Org') //RM.UF1
	lsOutString += NoNull(lsOrg) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'Org', lsOrg) // 02/04/10

//	lsOutString += NoNull(lsTemp) + "|"
//	lsOutString += "DummyOrg" + "|"
//	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'Org') //RM.UF1
//	lsOutString += NoNull(lsTemp) + "|"
	//Need to look up Project (dp.PO_NO) 
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'do_no') 
	lsPandoraProject = ''
	select max(po_no) into :lsPandoraProject
	from delivery_picking
	where do_no = :lsTemp
	and line_item_no = :lsLine;

	lsOutString += NoNull(lsPandoraProject) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'po_no', lsPandoraProject)
	//lsOutString += "|" //CostCenter - Customer.UF7
	//lsTemp = ldsDump_IB.GetItemString(llRowPos, 'CostCenter') //Customer.UF7
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'CostCenter') //Customer.UF7
	lsOutString += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'CostCenter', lsTemp)
	lsOutString += "|" //ValueID
	ldsFinanceTable.SetItem(llFinanceRow, 'ValueID', 'NA')
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'Invoice_No')
	lsOutString += NoNull(lsTemp) + "|" // CI #
	
//already set?	ldsFinanceTable.SetItem(llFinanceRow, 'invoice_no', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'Requestor')
	lsOutString += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'Requestor', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'Remark')
	lsOutString += NoNull(lsTemp) + "|"
	ldsFinanceTable.SetItem(llFinanceRow, 'Remark', lsTemp)
	// 01/10 - added AWB and InvType to Finance Table
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'awb_bol_no')
	ldsFinanceTable.SetItem(llFinanceRow, 'awb_bol_no', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'inventory_type')
	ldsFinanceTable.SetItem(llFinanceRow, 'inventory_type', lsTemp)

	//TEMPO!! - Format for qty?....
//	lsTemp = String(ldsBOH.GetItemNumber(llRowPos, 'total_qty'), "#############")

	ldsOut.SetItem(llNewRow, 'Project_id', lsproject)
	ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)

	//if lsToCntryEU = 'Y' and lsFromCntryEU = 'Y' then
	//if lsToCntryEU = 'Y' and lsFromCntryEU = 'Y' and lsFromCntry <> lsToCntry then
	if lsFromCntryEU = 'Y' and (lsToCntryEU = 'Y' or IsNull(lsToCntryEU)) and lsFromCntry <> lsToCntry then
		ldsOut_IntrOB.SetItem(llNewRow_Intr, 'Project_id', lsproject)
		ldsOut_IntrOB.SetItem(llNewRow_Intr, 'file_name', lsFileName_IntrOB)
		ldsOut_IntrOB.SetItem(llNewRow_Intr, 'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut_IntrOB.SetItem(llNewRow_Intr, 'line_seq_no', llNewRow_Intr)
		ldsOut_IntrOB.SetItem(llNewRow_Intr, 'batch_data', lsIntrastat)
	end if
	// 3/19/10 - per Revathy, if 'From LOC' or 'To Loc' = 'Cyclecount', 'GPN_Change', 'MIM_GPN' then don't include in Finance Report
	if lsToLoc = 'CYCLECOUNT' or lsToLoc = 'GPN_CHANGE' or lsToLoc = 'MIM_GPN' then
		ldsFinanceTable.DeleteRow(llFinanceRow)
	end if

//TEMPO!!! - TESTING!
//Save New records to DB
lirc = ldsFinanceTable.Update()
If liRC = 1 then
	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Finance Table record(s) to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Finance Table Record to database!")
	Return -1
	Continue
End If
next /*next output record for Outbound Transactions */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut, "PANDORA")
//Write the Inbound Intrastat Report
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut_IntrIB, "PANDORA")
//Write the Inbound Intrastat Report
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut_IntrOB, "PANDORA")

//ldNextDate = ldNextDate
/*set FROM and TO dates....
    - current plan is to run once in the middle of the month (the 15th) and once on the 1st.
	  That means that the next report range will always be for the month containing today()
	  If it's the month-end run (on the 1st) then the next run will be for the
    - assuming that we will run next month for the current month.
	 
*/
liMonth = month(today())
liYear = year(today())
if liMonth = 12 then
	liNextMonth = 1
	liNextYear = liYear + 1
else
	liNextMonth = liMonth + 1
	liNextYear = liYear
end if
lsFrom = string(liMonth) + '-01-' + string(liYear)
lsTO = string(liNextMonth) + '-01-' + string(liNextYear)

/*
*** 9/09 Actually, been running this weekly on Sundays for a Sunday-Saturday week then zipping the files together and placing in \\mwtkl001\Sims-Updates\PND
	... so, now setting FROM to previous Sunday (or today, if today's sunday) and then the TO date to 7 days after FROM (basically, setting to run for the next week).
	     - TODO - need to accommodate month-end and when a week spans the month end
*/
liWeekday = DayNumber(today())
//set FROM to previous Sunday (or today, if today's sunday)
lsFrom = string(RelativeDate(today(), 1 - liWeekDay))
lsTO = string(RelativeDate(today(), 7 - liWeekday +1))

SetProfileString(gsIniFile, 'PANDORA', 'DDFrom', lsFrom)
SetProfileString(gsIniFile, 'PANDORA', 'DDTo', lsTo)

/* TODO - see about zipping the files together and dropping in the Updates\PND folder....
			string lsZipList, lsZipFile, lsCommand

			lsZipFile = 'C:\SIMS31FP\Archive\Pandora\Finance_Intrastat_' + 'SepXX' +'_' + ' SepYY' + '.zip'

			//Create the command line prompt
			//lsCommand = "winzip32 -a " + asZipFile + " " + asFileList
			//lsCommand = "wzzip -a " + asZipFile + " " + asFileList
			lsZipList = 'C:\SIMS31FP\Archive\Pandora\Intr_IB23592.DAT.txt C:\SIMS31FP\Archive\Pandora\Intr_OB23592.DAT.txt'
			lsCommand = '"c:\program files\winzip\wzzip" -a ' + lsZipFile + ' ' + lsZipList

			Run(lsCommand, minimized!)
*/

Return 0

end function

public function integer uf_process_new_replace_so (string aspath, string asproject);//Process Material Transfer (Sales Order) for PANDORA (used SIKA as a template)

Datastore	ldsDOHeader, ldsDODetail, lu_ds, ldsDOAddress, ldsDONotes
				
String		lsLogout,lsRecData,lsTemp,	lswarehouse, lsErrText, lsSKU, lsRecType, &
				lsDate, ls_invoice_no, ls_Note_Type, ls_search, lsNotes, ls_temp, lsCommentDest

Integer		liFileNo,liRC, li_line_item_no, liSeparator
				
Long			llRowCount,	llRowPos,llNewRow, llNewDetailRow ,llOrderSeq,	llBatchSeq,	llLineSeq,llCount,		&
				llCONO, llRoNO, llLineItemNo, llOwner, llNewAddressRow, llNewNotesRow, li_find
				
Decimal		ldQty, ldPrice
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError, lbSoldToAddress 
//pandora string		lsBT_Address[ ] //last three BT Notes are City,State,Zip. Up to 4 other lines.
//pandora string		lsBOLNotes[], lsBOLNote //capture BOL Notes to write to Remark field (& possibly Shipping_Instructions)
string 		lsInvoice, lsPrevInvoice, lsCustNum, lsPrevInvoice_Detail
integer 		i, liBTAddr, liBOLNote
string			lsOwnerCD, lsOwnerCD_Prev, lsOwnerID, lsWH

ldtToday = DateTime(today(),Now())
				
lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

ldsDOHeader = Create u_ds_datastore
ldsDOHeader.dataobject = 'd_shp_header'
ldsDOHeader.SetTransObject(SQLCA)

ldsDODetail = Create u_ds_datastore
ldsDODetail.dataobject = 'd_shp_detail'
ldsDODetail.SetTransObject(SQLCA)

//ldsDOAddress = Create u_ds_datastore
//ldsDOAddress.dataobject = 'd_mercator_do_address' //Delivery_Alt_Address
//ldsDOAddress.SetTransObject(SQLCA)

ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes' //tempo
ldsDONotes.SetTransObject(SQLCA)
 //SELECT Delivery_Notes_ID, Delivery_Notes.Project_ID, EDI_Batch_Seq_No, Order_Seq_No, 
 //space(30) as Invoice_no, Line_Item_No, Note_Type, Note_seq_no, Note_Text
 //FROM Delivery_Notes   

//Open the File
lsLogOut = '      - Opening File for Pandora-Enterprise Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath, LineMode!, Read!, LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for PANDORA-Enterprise Sales Order Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo, lsRecData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow, 'rec_data', lsRecData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

//Get the next available file sequence number
// 03/09 -  using edi_INbound_header because web does and it will crash when trying to re-use a sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = lu_ds.RowCount()

//Process each Row
For llRowPos = 1 to llRowCount
	lsRecData = Trim(lu_ds.GetItemString(llRowPos, 'rec_Data'))
		
	//Process header, Detail (sika..., or header/line notes) */
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	

	Choose Case lsRecType
		//HEADER RECORD
		Case 'DM' /* Header */
			llNewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0

		//Record Defaults
			ldsDOHeader.SetItem(llNewRow, 'Action_cd', 'A') /*always a new Order*/
			ldsDOHeader.SetITem(llNewRow, 'project_id', asProject) /*Project ID*/
			ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow, 'ftp_file_name', aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow, 'Status_cd', 'N')
			ldsDOHeader.SetItem(llNewRow, 'order_Type', 'S') /*default to SALE. we'll set it to 'Z' later if appropriate */
			ldsDOHeader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
						
		//From File			
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
		
			//Delivery Number - mapped to Invoice
			If Pos(lsRecData,'|') > 0 Then
				lsInvoice = trim(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Delivery Number. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'Invoice_no', lsInvoice)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsInvoice) + 1))) /*strip off to next Column */

			/* Delivery Date - CCYYMMDDHHMM (mapped to schedule_date) */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				//lsDate = Mid(lsTemp, 5, 2) + '/' + Right(lsTemp, 2) + '/' + Left(lsTemp, 4)
				lsDate = Left(lsTemp, 4) + '-' + Mid(lsTemp, 5, 2) + '-' + Mid(lsTemp, 7, 2)
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Delivery Date. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'Schedule_Date', lsDate) 
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Cust_Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Customer Name'. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'Cust_Name', Trim(lsTemp))
//			ldsDOHeader.SetItem(llNewRow,'Cust_Name', lsCustName)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Customer PO - mapped to cust_order_no
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Customer PO'. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'Cust_Order_No', Trim(lsTemp))
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Address1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Address1'. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'Address_1', Trim(lsTemp))
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Address2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Address2'. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'Address_2', Trim(lsTemp))
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Address3
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Address3'. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'Address_3', Trim(lsTemp))
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Zip
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Postal Code'. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'Zip', Trim(lsTemp))
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//City
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'City'. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'City', Trim(lsTemp))
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//State
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'State'. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'State', Trim(lsTemp))
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Country
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Country'. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'Country', Trim(lsTemp))
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//User_Field7 - Transaction Type (passed back to Pandora in Inventory Transaction Confirmation)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Transaction Type' field. Record will not be processed.")
			End If						
			ldsDOheader.SetItem(llNewRow, 'User_Field7', lsTemp) 
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Contact Person
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Contact Person'. Record will not be processed.")
			End If						
			ldsDOheader.SetItem(llNewRow, 'Contact_Person', lsTemp) 
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Telephone 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If						
			ldsDOheader.SetItem(llNewRow, 'tel', lsTemp) 
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			
		// DETAIL RECORD
		Case 'DD' /*Detail */
//TEMPO?			lbDetailError = False
			llNewDetailRow = 	ldsDODetail.InsertRow(0)
			llLineSeq ++

		//Add detail level defaults
			ldsDODetail.SetITem(llNewDetailRow, 'supp_code', 'PANDORA') /* 2/14/09 */
			ldsDODetail.SetItem(llNewDetailRow, 'project_id', asproject) /*project*/
			ldsDODetail.SetItem(llNewDetailRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			ldsDODetail.SetItem(llNewDetailRow, 'order_seq_no', llOrderSeq) 
			ldsDODetail.SetItem(llNewDetailRow, "order_line_no", string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'N')
			//ldsDODetail.SetItem(llNewDetailRow, 'Inventory_type', 'N') /*normal inventory*/
				
		//From File
		lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
		
		//Invoice No
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Invoice No' field. Record will not be processed.")
		End If						
		ldsDODetail.SetItem(llNewDetailRow, 'Invoice_no', lsTemp) 
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

		//Line Number
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Line Number. Record will not be processed.")
		End If	
		ldsDODetail.SetItem(llNewDetailRow, 'line_item_no', dec(lsTemp)) 
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

		//SKU
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Part Number. Record will not be processed.")
		End If	
		ldsDODetail.SetItem(llNewDetailRow, 'sku', lsTemp) 
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
		//Quantity
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Quantity. Record will not be processed.")
		End If
		ldsDODetail.SetItem(llNewDetailRow, 'quantity', lsTemp) 
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

		//UOM
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after UOM. Record will not be processed.")
		End If
		ldsDODetail.SetItem(llNewDetailRow, 'UOM', lsTemp) 
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

		//User Field 4 (What is this for???)
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after UF4. Record will not be processed.")
		End If
		ldsDODetail.SetItem(llNewDetailRow, 'User_Field4', lsTemp) 
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

		//Price
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Price. Record will not be processed.")
		End If
		ldsDODetail.SetItem(llNewDetailRow, 'Price', lsTemp) 
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

		//Currency_Code
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Currency_Code. Record will not be processed.")
		End If
		ldsDODetail.SetItem(llNewDetailRow, 'Currency_Code', lsTemp) 
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

		//Owner_ID (after look-up via Owner_CD)
		//  - Also setting DM.UF2 to 'FROM' Location from file
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else /*error*/
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Owner. Record will not be processed.")
		End If
		lsOwnerCD = lsTemp
		if lsOwnerCD <> lsOwnerCD_Prev then
			//Need to look up Owner_ID and WH_Code (but shouldn't look it up for each row if it doesn't change)
			//  - do we need to validate that the WH_Code doesn't change within an Order?
			lsOwnerID = ''
			select owner_id into :lsOwnerID
			from owner
			where project_id = :asProject and owner_cd = :lsOwnerCD;
			lsOwnerCD_Prev = lsOwnerCD
		
			select user_field2 into :lsWH
			from customer
			where project_id = 'PANDORA'
			and cust_code = :lsOwnerCD;
		end if
		if lsInvoice <> lsPrevInvoice then
		  //set wh_code when the invoice changes
			ldsDOheader.SetItem(llNewRow, 'wh_code', lsWH)
			lsPrevInvoice = lsInvoice
//Enterprise...			//need to set order type to 'Z' (for warehouse transfer) if customer is of type WH
//			if lsCustType = 'WH' then
//				ldsDOHeader.SetItem(llNewRow, 'order_Type', 'Z') /* warehouse Transfer*/
//			end if		
		end if
		ldsDODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
//		ldsDOHeader.SetItem(llNewRow, 'user_field2', lsOwnerCD) /* 04/09 - PCONKL - Moved outside of if statement to unconditionally set the From Location */
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

		//Defective Appliance ID (UF1)
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else
			lsTemp = lsRecData
		End If
		ldsDODetail.SetItem(llNewDetailRow, 'User_Field1', lsTemp) 

	
/*pandora		Case 'OC', 'DC' /* Header/Line Notes*/
			IF lsRecType = 'OC' THEN
				lsCommentDest = Trim(Mid(lsRecdata, 70, 6)) 
				/* 6-char Y/N flags
					Per Tom Leap:
					Flag 1 = Picking Note (set for LMS directed text of "PIK")
					Flag 2 = Packing Note (set for LMS directed text of "PAK" or "TXT")
					Flag 3 = Address Note (set for LMS directed text of "ADR")
					Flag 4 = BOL Note (set for LMS directed text of "BOL" or "TXT")
					Flag 5 = ? Note (set for LMS directed text of "MNF")  I'll try to get clarification from provia as to exactly what this was/is for since we don't have this text type defined.
					Flag 6 = ? Note (set for LMS directed text of "CHK") I'll try to get clarification from provia as to exactly what this was/is for since we don't have this text type defined.
					* 01/03/08
					- Flag 3 = 'Y' means it's a Bill-To address line...
					- If both Flag 2 and Flag 4 are 'Y', then note is just text and not to be printed anywhere
				*/
//				lsNotes=Trim(Mid(lsRecdata, 76, 40))
//				// Ignore notes that say 'Notes for Order Number' or 'Function Code' or empty notes...
//				IF pos(Trim(lsNotes), 'Notes for Order Number') = 0 and pos(Trim(lsNotes), 'Function Code') = 0 and lsNotes <> '' THEN	
//					ls_search = 'TXT         :'
//					IF pos(Trim(lsNotes), ls_search) > 0 THEN
//						lsNotes=mid(Trim(lsNotes), (len(ls_search)+1))
//					END IF
//					if mid(lsCommentDest, 3, 1) = 'Y' then //Bill-to address
//						//lsNotes = 'BT:' + lsNotes
//						lsRecType = 'BT'
//						liBTAddr ++
//						lsBT_Address[liBTAddr] = lsNotes
//					end if
					/* Set lsRecType = 'PL' if this is a P/L note (lsCommentDest.2 = 'Y')
						- Set lsRecType = 'BL' if this is a BOL note (lsCommentDest.4 = 'Y')
						- Set lsRecType = 'PB' if this is BOTH a P/L and a BOL note 
						!!Assuming it can't be both a BT note and a PL / BOL Note
					*/
/*								if mid(lsCommentDest, 2, 1) = 'Y' then //Packing List note
									if mid(lsCommentDest, 4, 1) = 'Y' then //also a Bill of Lading note
										lsRecType = 'PB'
									else
										lsRecType = 'PL'
									end if
								else
									// Not a P/L note but it is a BOL note... (lsCommentDest.4 = 'Y')
									if mid(lsCommentDest, 4, 1) = 'Y' then //Bill of Lading note
										lsRecType = 'BL'
									end if
								end if
*/
					if mid(lsCommentDest, 4, 1) = 'Y' then //BOL note
						if mid(lsCommentDest, 2, 1) = 'Y' then //also a Pack List note
							lsRecType = 'PB'
						else
							lsRecType = 'BL'
						end if
						//add BOL note to Array to write to DM.Remark (& possibly DM.Shipping_Intructions) at the end (of the order)
//						liBOLNote ++
//						lsBOLNotes[liBOLNote] = lsNotes
					else
						// Not a BOL note but it is a P/L note... (lsCommentDest.2 = 'Y')
						if mid(lsCommentDest, 2, 1) = 'Y' then //PackList note
							lsRecType = 'PL'
						end if
					end if

				Else 
					Continue
				End If
			else // DC...
				lsCommentDest = Trim(Mid(lsRecdata, 76, 6)) 
				lsNotes=Trim(Mid(lsRecdata, 82, 40))
				
				/* Set lsRecType = 'PL' if this is a P/L note (lsCommentDest.2 = 'Y')
				   - Set lsRecType = 'BL' if this is a BOL note (lsCommentDest.4 = 'Y')
					- Set lsRecType = 'PB' if this is BOTH a P/L and a BOL note 
				*/
				if mid(lsCommentDest, 2, 1) = 'Y' then //Packing List note
					if mid(lsCommentDest, 4, 1) = 'Y' then //also a Bill of Lading note
						lsRecType = 'PB'
					else
						lsRecType = 'PL'
					end if
				else
					// Not a P/L note but it is a BOL note... (lsCommentDest.4 = 'Y')
					if mid(lsCommentDest, 4, 1) = 'Y' then //Bill of Lading note
						lsRecType = 'BL'
					end if
				end if
			End IF
			
			llNewNotesRow = ldsDONotes.InsertRow(0)
			
			//Defaults
			ldsDONotes.SetItem(llNewNotesRow, 'project_id', asProject) /*Project ID*/
			ldsDONotes.SetItem(llNewNotesRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			ldsDONotes.SetItem(llNewNotesRow, 'order_seq_no', llOrderSeq) 
			
			//From File
			ldsDONotes.SetItem(llNewNotesRow, 'note_type', lsRecType) /* Note Type */
			ldsDONotes.SetItem(llNewNotesRow, 'invoice_no', Trim(Mid(lsRecdata, 30, 30)))
						
			//dts - should set lsNoteSeq and lsLineItem depending on Header/detail and then wouldn't need condition here...
			If lsRecType = 'DC' or lsRecType = 'BL' Then /*detail*/
				ldsDONotes.SetItem(llNewNotesRow, 'note_seq_no', Long(Trim(Mid(lsRecdata, 70, 6))))
				ldsDONotes.SetItem(llNewNotesRow, 'line_item_no', Long(Trim(Mid(lsRecdata, 64, 6))))
				//ldsDONotes.SetItem(llNewNotesRow, 'note_text', Trim(Mid(lsRecdata, 82, 40)))
				ldsDONotes.SetItem(llNewNotesRow, 'note_text', lsNotes)
			Else /*header */
				ldsDONotes.SetItem(llNewNotesRow, 'note_seq_no', Long(Trim(Mid(lsRecdata, 64, 6))))
				ldsDONotes.SetItem(llNewNotesRow, 'line_item_no', 0)
				//ldsDONotes.SetItem(llNewNotesRow, 'note_text', Trim(Mid(lsRecdata, 76, 40)))
				ldsDONotes.SetItem(llNewNotesRow, 'note_text', lsNotes)
			End IF
pandora */		
		Case Else /*Invalid rec type */
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue /*Next Record */
			
	End Choose /*Header, Detail or Notes */
	
Next /*file record */
/* pandora
//load Bill-To Address info for Last Order...
// - last three BT Notes are City,State,Zip. Up to 4 other lines.
if liBTAddr > 0 then
	llNewAddressRow = ldsDOAddress.InsertRow(0)
	ldsDOAddress.SetItem(llNewAddressRow, 'project_id', asProject) /*Project ID*/
	ldsDOAddress.SetItem(llNewAddressRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
	ldsDOAddress.SetItem(llNewAddressRow, 'order_seq_no', llOrderSeq) //Here we're still on the current order (as opposed to above)...
	ldsDOAddress.SetItem(llNewAddressRow, 'address_type', 'BT') /* Bill To Address */
	ldsDOAddress.SetItem(llNewAddressRow, 'address_1', lsBT_Address[1]) /*Bill To Name - using Address_1 because it's 40 chars instead of 20*/
	if liBTAddr > 4 then ldsDOAddress.SetItem(llNewAddressRow, 'address_2', lsBT_Address[2]) /* BT Addr 1*/
	if liBTAddr > 5 then ldsDOAddress.SetItem(llNewAddressRow, 'address_3', lsBT_Address[3]) /* BT Addr 1*/
	if liBTAddr > 6 then ldsDOAddress.SetItem(llNewAddressRow, 'address_4', lsBT_Address[4]) /* BT Addr 2*/
	//if liBTAddr > 7 then ldsDOAddress.SetItem(llNewAddressRow, 'address_4', lsBT_Address[5]) /* BT Addr 3*/
	if liBTAddr > 2 then ldsDOAddress.SetItem(llNewAddressRow, 'City', lsBT_Address[liBTAddr - 2]) /* BT City */
	if liBTAddr > 1 then ldsDOAddress.SetItem(llNewAddressRow, 'State', lsBT_Address[liBTAddr - 1]) /*BT State */
	ldsDOAddress.SetItem(llNewAddressRow, 'Zip', lsBT_Address[liBTAddr]) /*Bill To Zip */
	//ldsDOAddress.SetItem(llNewAddressRow, 'Country', Trim(Mid(lsRecdata, 713, 20))) /* BT Country */
	//ldsDOAddress.SetItem(llNewAddressRow, 'tel', Trim(Mid(lsRecdata, 733, 20))) /*BT Phone*/
end if

//load BOL Header Notes into DM.Remark (& possibly Shipping_Instructions)
if liBolNote > 0 then
	lsBOLNote = lsBOLNotes[1]
	for i = 2 to liBOLNote
		//build sting of bol notes from array lsBOLNotes[]
		lsBOLNote += ' ' + lsBOLNotes[i]
	// messagebox("TEMPO, Len: " + string(len(lsBOLNote)), lsBOLNOte)
	next
	ldsDOHeader.SetItem(llNewRow, 'remark', left(lsBOLNote, 250)) 
	if len(lsBOLNote) > 250 then
		ldsDOHeader.SetItem(llNewRow, 'shipping_instructions_text', mid(lsBOLNote, 251, 250)) 
	end if
end if
pandora */

//Save Changes
liRC = ldsDOHeader.Update()
If liRC = 1 Then
	liRC = ldsDODetail.Update()
End If
//If liRC = 1 Then
//	liRC = ldsDOAddress.Update()
//End If
//If liRC = 1 Then
//	liRC = ldsDONotes.Update()
//End If
If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new SO Records to database "
	FileWrite(gilogFileNo, lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

If lbError Then Return -1

Return 0
end function

public function integer uf_process_po_rose (string aspath, string asproject);//Process PO for Pandora 3B2
Datastore lu_ds, ldsItem, ldsOrders
String lsLogout,lsStringData, lsOrder, lsWarehouse, lsTemp, lsRecData, lsRecType, lsDesc, lsSKU, lsSupplier, lsNoteText ,lsNoteType, lsAction, lsDate
Integer liRC,liFileNo,liItems
Long  llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llOwnerID, llNewNotesRow, llNoteSeq, llNoteLine
Boolean lbError, lbDetailError, lbExtraSNs, lbLPN
DateTime ldtToday
Decimal ldWeight, ldLineItemNo_c
int li_cnt

String  lsOrderNo, lsThisContainer,lsLPNSuffix
string  lsSKU2, lsGPN, lsOwnerCD, lsOwnerCD_Prev, lsOwnerID, lsTemp2, lsSKUPrev
string  lsGroup, lsProject, lsUF6
String  lsRoNo, sql_syntax, Errors, lsFInd,  lsUserLineItemNo   //TAM 2009/10/28
Long  llNewRoNoCount, llNewRowPos, llDeleteRowPos,llDeleteRowCount //TAM 2009/10/28
datetime ldtWHTime
boolean lbCrossDock // dts - 8/12/2010
string  lsCrossDock_Loc
datastore ldsRoNo   //TAM 2009/10/28
string lsActionCD, lsOrderNum, lsInvType, lsAltSKU, lsLotNO, lsPONO2, lsSerial, ls_country, lsContainer, lsPoLineDate, lsLPNOrder
string lsMaxOrd, lsLPNActionCd, lsPONO2Prev
long llQuantity, llRemainingQty, llSerialCount, llDetailQty, llLineNum, ll_rm_lpnbr, llTempQty
ldtToday = DateTime(Today(),Now())
String lsShipmentDistributionNo
DateTime ldNeedByDate

boolean lb_treat_adds_as_updates, lb_mr_add_equals_add, lbFirst, lbSKUChanged
long ll_rm_count, ll_sn_count, llLPNSuffix, llLPNNo,ll_rm_pos, ll_pd_qty	//gwm #668 - 0 no suffix - >0 has suffix in order no
String ls_mr_add_is_add_flag, lsTempQty

boolean lb_update_void_treat_as_add, lb_sn_in_carton_serial 	//gailm - 10/24/2013 - #608 Does serial number already exist in carton/serial
boolean lbSerializedSKU // TAM 2016/07/29
long ll_line_item_no, ll_line_item_no_from_project	// LTK 20150821
boolean lb_set_from_project_from_detail				// LTK 20150821

long ll_po_max_lines //dts 2/12/13
long ll_luds_rowcount  //gwm 9/2/14
String lsSerialized, lsPono2Controlled, lsContainerTracked 		//gwm 9/2/14
string lsFromProject
//TimA 01/17/13
is_WhCode = ''
is_Invoice = ''

//GailM 08/08/2017 SIMSPEVS-537 - Identify MIM order - If not a MIM order, default to *all
String lsMIMOrder = '*all*'		

//GailM 10/25/2013 #668
llLPNNo = 1		//Initialize LPN No
lbLPN = false	//Default is false. Put it here anyway
lsPONO2Prev = ''	//initialize LPN previous pallet/ Roll LPN to pallet level
lsSKUPrev = ''
lbSKUChanged = false

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'
ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master'
ldsItem.SetTransObject(SQLCA)

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

If Not isvalid(idsRONotes) Then
	 idsRONotes = Create u_ds_datastore
	 idsRONotes.dataobject = 'd_mercator_ro_notes'
	 idsRONotes.SetTransObject(SQLCA)
End If

If Not isvalid(ldsOrders) Then
	 ldsOrders = Create u_ds_datastore
	 ldsOrders.dataobject = 'd_receive_master'
	 ldsOrders.SetTransObject(SQLCA)
End If

idsPoheader.Reset()
idsPODetail.Reset()
idsRONotes.Reset()
ldsOrders.Reset()
//Open and read the File In
lsLogOut = '      - Opening File for PANDORA Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)

If liFileNo < 0 Then
	 lsLogOut = "-       ***Unable to Open File for PANDORA Processing: " + asPath
	 FileWrite(giLogFileNo,lsLogOut)
	 gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	 Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
//TimA 03/16/15 Change to read Unicode because of the Non Ascii characters in the file.
liRC = FileReadEX(liFileNo,lsStringData)
//liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	 llNewRow = lu_ds.InsertRow(0)
	 lu_ds.SetItem(llNewRow,'rec_data',Trim(lsStringData)) /*record data is the rest*/
	 //TimA 03/16/15 Change to read Unicode because of the Non Ascii characters in the file.
	 liRC = FileReadEX(liFileNo,lsStringData)
	 //liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//GailM - 9/2/2014 - #899 - Ensure that LPN formated files are coded as LPN in Item Master - nonLPN files will not process and sweeper is hung
// First thing is the size of the file.  How many rows are in the file
ll_luds_rowcount = lu_ds.Rowcount( )
if ll_luds_rowcount > 3 Then										//File must have at least 3 rows (PM, PD and possibly an SN) 
	lsRecData = lu_ds.GetItemString(2, 'rec_data') + '|'		//In case the row does not end with a separator
	lsRecType = left(lsRecData,2)
	If lsRecType = 'PD' Then										// Continue to check Item Master to determine if this is an LPN GPN
		for li_cnt = 1 to 15											// SKU is 5th element in the PD row, palletID/pono2 at 11th and containerID at 15th element
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			lsRecData = Right(lsRecData,(len(lsRecData) - len(lsTemp) - 1))
			if li_cnt = 5 then lsSKU = lsTemp
			if li_cnt = 11 then lsPono2 = lsTemp
			if li_cnt = 15 then lsContainer = lsTemp
			//if li_cnt = 16 then lsFromProject = lsTemp			// LTK 20150814  From project now being sent at the detail level
		next
		lsRecData = lu_ds.GetItemString(3, 'rec_data')		//If row 3 is SN then this SKU must be serialized
		lsRecType = left(lsRecData,2)

//TAM 2016/08/01 - Bypass this edit.  It is no longer used since we are not loading the serial numbers in if the Item Master flag is not Serialized 
//		If lsRecType = 'SN' Then									// Continue to check Item Master to determine if this is an LPN GPN
//			select serialized_ind, po_no2_controlled_ind, container_tracking_ind into :lsSerialized, :lsPono2Controlled, :lsContainerTracked
//			from item_master where project_id = 'PANDORA' and sku = :lsSKU;
//			if lsSerialized = 'N' Then
//				lsLogOut = "-       ***Serial numbers found in file where GPN is non-serialized. "
//				if lsPono2 <> '' and lsPono2Controlled = 'N' Then
//					lsLogOut += "~r~n        ***PalletID found in file where GPN is not po_no2 controlled."
//				End If
//				if lsContainer <> '' and lsContainerTracked = 'N' Then
//					lsLogOut += "~r~n        ***ContainerID found in file where GPN is not container tracked."
//				End If
//				lsLogOut += "~r~n        ***Please analyze file and correct."
//				FileWrite(giLogFileNo,lsLogOut)
//				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
//				gu_nvo_process_files.uf_writeError(lsLogOut)
//				 lbError = True
//									 
//				uf_sendemailnotification(lsWarehouse, lsOrderNo,lsLogOut)
//				
//				Return -1 /* File cannot continue to process */
//			End If
//		End If
	End If
End If

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Process Each Record in the file..
//Process each row of the File
llRowCount = lu_ds.RowCount()

//dts 2/12/13 - Adding a check for Maximum number of lines allowed in PO files (to prevent sweeper hanging on 25,000 serial records)
select code_descript
into :ll_po_max_lines
from lookup_table
where project_id = 'PANDORA'
and code_type = 'FLAG'
and code_id = 'po_max_lines';

if llRowCount > ll_po_max_lines then
	lsLogOut = '      !!!! Not loading file! Too many records (' + string(llRowCount) + '). The maximum allowed lines is ' + string(ll_po_max_lines) + ' (as governed in lookup_table).'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	gu_nvo_process_files.uf_writeError(lsLogOut)
	return -1
end if

// Reset main window microhelp message
w_main.SetMicroHelp("Processing Purchase Order (ROSE)")
	
For llRowPos = 1 to llRowCount
	lsRecData = Trim(lu_ds.GetItemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/ 
 
	Choose Case Upper(lsRecType)
	   	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		Case 'PM' /* PO Header (AM - ASN) */
   
			llNewRow = idsPOheader.InsertRow(0)
   			llOrderSeq ++
			llLineSeq = 0
   
			//New Record Defaults
			idsPOheader.SetItem(llNewRow, 'project_id', asProject)
			idsPOheader.SetItem(llNewRow, 'Request_date',String(Today(), 'YYMMDD'))
			idsPOheader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq)  /* batch seq No */
			idsPOheader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
			idsPOheader.SetItem(llNewRow, 'ftp_file_name',asPath)  /* FTP File Name */
			idsPOheader.SetItem(llNewRow, 'Status_cd', 'N')
			idsPOheader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
  
			//Getting Order_Type from SIKA(at end of PM Record). Defaulting it here...
			idsPOheader.SetItem(llNewRow, 'Order_type', 'S')  /* Order Type )  */
			idsPOheader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
			
			/* TAM - 2016/08/26 - Temporary FIX for Universal MOR Shipment ID project.  ICC may not send and invoice Number(Should only be for Cycle count 3b2s).  
								If no invoice number is sent then grab the value from the Client_Cust_Po_Nbr(field 22)
			*/
			//Client_Cust_Po_Nbr (Order Nbr): 22h field in PM record
			integer i, liStart, liEnd
			string lsClientCustPoNbr
			i = 1
			liStart = 1
			do while i < 22
				liStart = pos(lsRecData, '|', liStart) + 1
				i += 1
			loop
			liEnd = pos(lsRecData, '|', liStart)
			
			If liEnd = 0 Then 	
				lsClientCustPoNbr = Mid(lsRecData, liStart)
			Else
				lsClientCustPoNbr = Mid(lsRecData, liStart, liEnd - liStart)
			End If
			// End of Temp Fix
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			
			//Action Code  /Change ID   
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				 lbError = True
				 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Action Code' field. Record will not be processed.")
			End If
			lsAction = lsTemp
						
			// 4-14-09: setting to X so it always adds/updates.
			//2007/07/13  Remove change ing the action to X.  Need to keep it as 'A' or 'u'
			//if lsAction = 'A' or lsTemp = 'U' then
			//	idsPOheader.SetItem(llNewRow, 'action_cd', 'X')
			//else
				 idsPOheader.SetItem(llNewRow, 'action_cd', lsAction) 
			//end if
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
  
			//Delivery Number AKA Order Number AKA Invoice Number
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
			 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
			 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order No' field. Record will not be processed.")
			 lbError = True
			 Continue /*Process Next Record */
			End If
			
			/* TAM - 2016/08/26 - Temporary FIX for Universal MOR Shipment ID project.  ICC may not send and invoice Number(Should only be for Cycle count 3b2s).  
								If no invoice number is sent then grab the value from the Client_Cust_Po_Nbr(field 22 loaded above)
			*/
			If lsTemp = '' Then
				lsTemp = lsClientCustPoNbr
			End If

			lsOrderNo = trim(lsTemp)
			
			idsPOheader.SetItem(llNewRow, 'order_no', Trim(lsTemp))
			// dts 2010/08/12 - need to direct putaway to cross-dock location if order is a crossdock order
			//??lsOrder?? if left(lsOrder, 4) = 'CMOR' then // 8/31... or left(lsOrder, 4) = 'FMOR' then
			//if left(lsOrderNo, 4) = 'CMOR' then // 8/31... or left(lsOrderNo, 4) = 'FMOR' then
			if left(lsOrderNo, 4) = 'CMOR' or left(lsOrderNo, 4) = 'CMTR' then  // LTK 20110218 Enhancement #166:  Added 'CMTR' but NOT 'FMTR' 
				lbCrossDock = True
			 	idsPOheader.SetItem(llNewRow, 'Crossdock_ind', 'Y')
			end if
			
// TAM 2016/08/29
//			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */  TAM 2016/08/29
			lsRecData = Right(lsRecData,(len(lsRecData) - (Pos(lsRecData,'|')))) /*strip off to next Column */

			
			//TAM 2009/07/06 Added Add/Delete Logic unstead of update 
			//TAM 2009/09/03 Remove this logic.  Corrected some update errors by moving the Pandora line number to User_Line_Item_No 
			//  TAM 2009/10/28 Do an Inline Delete of new orders only rather than writing to the EDI files and and deleting in Process Files 
			ldsRoNo = Create datastore


			// LTK 20160301	Roy no longer wants updates to void orders treated as adds, comment out block below...
			//
			//
//			// LTK 20111117	Pandora #304 if the 3B2 is an update and the most recent SIMS order is a Void, then set a flag so that
//			//						the order is treated as an add.
//			long ll_void_count
//			lb_update_void_treat_as_add = FALSE	// reset flag
//
//			if lsAction = 'U' then
//
//				select count(*)
//				into :ll_void_count
//				from receive_master
//				where project_id = 'PANDORA'
//				and Ord_Status = 'V'
//				and ro_no = 
//					(select max(ro_no)
//					from receive_master
//					where Project_ID = 'PANDORA'
//					and Supp_Invoice_No = :lsOrderNo);
//
//				if ll_void_count > 0 then
//					lb_update_void_treat_as_add = TRUE
//				end if
//			end if

			// LTK 20151105	Reject 2nd PO adds, except for MATERIAL RECEIPT orders
			if lsAction = 'A' and Upper(f_retrieve_parm('PANDORA','FLAG','PO_REJECT_2ND_ADDS' ) ) = 'Y' then
				
				if Pos(lsRecData,'|MATERIAL RECEIPT|') > 0 then
					// Don't reject these orders
				else
					long ll_count
		
					select count(*)
					into :ll_count
					from receive_master
					where project_id = 'PANDORA'
					and Supp_Invoice_No = :lsOrderNo;
	
					if ll_count > 0 then
						lsLogOut = "        *** Rejecting 2nd add for order number:  " + lsOrderNo
						gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
						gu_nvo_process_files.uf_writeError(lsLogOut)
						RETURN -1
					end if
				end if				
			end if

			// LTK 20111111	#304 and #254 update:  Treat adds as updates, if order status is NEW, *except* for MATERIAL RECEIPT orders
			select COUNT(*)
			into :ll_rm_count
			from receive_master
			where Project_ID = 'PANDORA'
			and (Supp_Invoice_No = :lsOrderNo or Supp_Invoice_No like (:lsOrderNo + '-LPN%'))
			and Ord_Status = 'N';
			
			// GailM - 10/28/2013 - #668 Multiple LPN orders *******************
			ll_rm_pos = Pos(lsOrderNo,"-LPN") 
			if ll_rm_pos > 0 then
				//lsLPNOrder = Left(lsOrderNo,ll_rm_pos - 1) + "%"
				lsLPNOrder = lsOrderNo
			else
				lsLPNOrder = lsOrderNo + '-LPN%'
			end if
			
			
			select max(supp_invoice_no) into :lsMaxOrd
			from receive_master
			where Project_ID = 'PANDORA'
			and supp_invoice_no like (:lsLPNOrder);

			
			if isnull(lsMaxOrd) or lsMaxOrd = "" then
				if ll_rm_pos = 0 then
					lsLPNOrder = lsOrderNo + "-LPN01"
				end if
			else
				lsTemp = Right(lsMaxOrd,2)
				li_cnt = Integer( lsTemp )
				li_cnt ++
				lsMaxOrd = Left(lsMaxOrd,Len(lsMaxOrd) - 2) + Right("00" + string(li_cnt),2)
				lsLPNOrder = lsMaxOrd
			end if
			// End of LPN order 	
			
			lsOrderNum = lsOrderNo
			idsPOheader.SetItem(llNewRow, 'Order_No', lsOrderNo)  /* Order No )  */

			
			// Retrieve the implementation flag
			select code_descript
			into :ls_mr_add_is_add_flag
			from lookup_table
			where project_id = 'PANDORA'
			and code_type = 'FLAG'
			and code_id = 'MR_ADD_IS_ADD';

			lb_mr_add_equals_add = Pos(lsRecData,'|MATERIAL RECEIPT|') > 0 and Upper(Trim(ls_mr_add_is_add_flag)) = 'Y'

			if ll_rm_count = 1 and lsAction = 'A' and NOT lb_mr_add_equals_add then
				lb_treat_adds_as_updates = TRUE
			end if

			// Gailm - 10/25/2013 - Issue #668 - Multiple LPN order will have -LPNnn as a suffix to the order.  Check here if this order has suffix.
			llLPNSuffix = Pos(lsOrderNo,'-LPN')
			if llLPNSuffix > 0 then			//We have an LPN order
				lsLPNSuffix = Right(lsOrderNo,Len(lsOrderNo) - llLPNSuffix + 1)
				if isnumber(Right(lsLPNSuffix,2)) then 
					llLPNNo = Long(Right(lsLPNSuffix,2)) 
				end if
			else
				llLPNNo = 0
			end if

			// LTK 20110921	Pandora #254 Treat Adds like Updates if records exist.  The test for existing records is the ldsRoNo retrieve below.
			// 
			//If lsAction = 'U' Then  //IF the Action is "U"pdate We need to issue a delete and then an Add for the entire order
			// LTK 20111108	Treat adds as updates *except* from MATERIAL RECEIPT orders
			//If lsAction = 'U' or lsAction = 'A' Then  //IF the Action is "U"pdate We need to issue a delete and then an Add for the entire order
			If lsAction = 'U' or lb_treat_adds_as_updates Then  //IF the Action is "U"pdate We need to issue a delete and then an Add for the entire order

				//TAM 2009/10/29 Get existing details for order (for status "N"ew and "P"rocess ) to compare what is being sent. Pandora is not sending deletes for lines. 
				//Later on as we unload the 3b2 details we remove the line from this datastore if a match is found based on SKU/User_Line_Item_No
				//Any lines remaining means it did not come in on the transaction and need to be deleted from Recieve Detail.  We will create a 
				//Delete line transaction in the EDI files
				 

				sql_syntax = "SELECT RO_No, SKU, line_item_no, user_line_Item_No FROM Receive_Detail"    
				// LTK 20110526  Added project_id to the line below
				sql_syntax += " Where RO_no in (select ro_no from receive_master where project_id = 'PANDORA' and supp_invoice_no = '" + lsorderno + "'  and (Ord_Status = 'N' or Ord_Status = 'P'  ));"  
					
			  
			//    sql_syntax = "SELECT RO_NO"
			//    sql_syntax += " From Receive_Master "
			//    sql_syntax += " Where Project_ID = 'PANDORA' "
			//    sql_syntax += " and Supp_Invoice_No = '" + lsOrderNo + "'"
			//    sql_syntax += " and Ord_Status = 'N';"
			
			 ldsRoNo.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
			 IF Len(ERRORS) > 0 THEN
				 lsLogOut = "        *** Unable to create datastore for Pandora Sales Order Process.~r~r" + Errors
			  FileWrite(gilogFileNo,lsLogOut)
				RETURN - 1
			 END IF
			 ldsRoNO.SetTransObject(SQLCA)
			 llNewRoNoCount =ldsRoNo.Retrieve()
				//    If llNewRoNoCount > 0 Then
				//     For llNewRowPos = 1 to llNewRoNoCount
				//      lsRono = ldsRoNo.GetItemString(llNewRowPos,'RO_NO')
				//      Delete from Receive_Putaway where ro_no = :lsRono;
				//      Delete from Receive_detail where ro_no = :lsRoNo;
				//      Delete From Receive_master where ro_no = :lsRono;
				//     Next
				//    End If
				//
				//    Select wh_Code into :lsWarehouse
				//    From Receive_master
				//    Where project_ID = :asproject and supp_invoice_no = :lsOrderNo;
				//
				//    If lsWarehouse = "" Then
				//     lbError = True
				//     gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse: '" + lsTemp + "'. Order will not be processed.") 
				//    End If
				//   
				//    idsPOheader.SetItem(llNewRow,'wh_Code',lsWarehouse)
				//
				//    idsPOHeader.SetItem(llNewRow, 'Action_cd', 'D') /*Delete */
				//
				//    lsAction = 'A'
				//    //Get the next available file sequence number
				//    llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
				//    If llBatchSeq <= 0 Then Return -1
				//
				//    llOrderSeq = 0 /*order seq within file*/
				//
				//    llNewRow = idsPOheader.InsertRow(0)
				//    llOrderSeq ++
				//    llLineSeq = 0
				//   //New Record Defaults
				//    idsPOheader.SetItem(llNewRow, 'project_id', asProject)
				//    idsPOheader.SetItem(llNewRow, 'Request_date',String(Today(), 'YYMMDD'))
				//    idsPOheader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq)  /* batch seq No */
				//    idsPOheader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
				//    idsPOheader.SetItem(llNewRow, 'ftp_file_name',asPath)  /* FTP File Name */
				//    idsPOheader.SetItem(llNewRow, 'Status_cd', 'N')
				//    idsPOheader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
				//    idsPOheader.SetItem(llNewRow, 'Order_type', 'S')  /* Order Type )  */
				//    idsPOheader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
				//   //New Order Number
				//    idsPOheader.SetItem(llNewRow, 'order_no', Trim(lsOrderNo))
				//    idsPOheader.SetItem(llNewRow, 'action_cd', 'A')
			End If
  
				// Supplier ID
				//Supplier - always 'PANDORA' for now (capturing Vendor later in UF)
				If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else
				 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
				 lbError = True
				 Continue /*Process Next Record */
				End If
				If lsTemp > '' Then
				 //not building IM record for Pandora at this time... lsSupplier = lsTemp  /* used to build item master below if necessary */
				 idsPOheader.SetItem(llNewRow, 'supp_code', lsTemp)
				Else
				 idsPOheader.SetItem(llNewRow, 'supp_code', 'PANDORA')  /* default to PANDORA */
				End If
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				
				//Expected Arrival Date
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Arrival Date' field. Record will not be processed.")
					 lbError = True
					 Continue /*Process Next Record */
				End If     
				idsPOheader.SetItem(llNewRow, 'Arrival_Date', lsTemp)
					  
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
				//Not Getting Sub-Inventory Location here. Need to look up warehouse based on Customer.UF2
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Sub-Inventory' field. Record will not be processed.")
					 lbError = True
					 Continue /*Process Next Record */
				End If
					  
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1)))  /* strip off to next Column */
				//Carrier
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Carrier' field. Record will not be processed.")
					 lbError = True
					 Continue /*Process Next Record */
				End If     
				idsPOheader.SetItem(llNewRow,'Carrier',lsTemp)
				
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				//AWB *Not Used
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'AWB' field. Record will not be processed.")
					 lbError = True
					 Continue /*Process Next Record */
				End If  
				idsPOheader.SetItem(llNewRow,'Awb_bol_no',lsTemp)
				  
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				//Transport Mode *Not Used
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Tansport Mode' field. Record will not be processed.")
					 lbError = True
					 Continue /*Process Next Record */
				End If
				idsPOheader.SetItem(llNewRow,'transport_mode',lsTemp)
				  
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				//Remarks
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else
					 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Remark' field. Record will not be processed.")
					 lbError = True
					 Continue /*Process Next Record */
				End If 
				
				idsPOheader.SetItem(llNewRow, 'remark', lsTemp)
				/* 2/24/09 - setting Ship_Ref to Transaction Ref from MIM 
					 - Grabbing first N characters until first ':' (for Atlanta) */
				If Pos(lsTemp, ':') > 1 Then
					 lsTemp2 = Left(lsTemp, (Pos(lsTemp, ':') - 1))
				End If
				
				if len(lsTemp2) > 4 and len(lsTemp2) < 10 then
					 idsPOheader.SetItem(llNewRow, 'ship_ref', lsTemp2)
				end if
     
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				
				// UF1 - Org Code *Not Used
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'UF1' (Org) field. Record will not be processed.")
					 lbError = True
					 Continue /*Process Next Record */
				End If     
				idsPOheader.SetItem(llNewRow, 'User_Field1', lsTemp)  /* UF1 - Org Code */ 
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				
				// UF2 - Sub-Inventory Loc *Not Used here
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Sub-Inventory Loc' field. Record will not be processed.")
					 lbError = True
					 Continue /*Process Next Record */
				End If     
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				// UF3 - 'From' Location
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'From Location' (UF3) field. Record will not be processed.")
					 lbError = True
					 Continue /*Process Next Record */
				End If     
				//TAM 12/14/2009 = UF3 moved to UF6
				//   idsPOheader.SetItem(llNewRow, 'User_Field3', lsTemp)  /* UF3 - 'From' Location */ 
				//   lsUF3 = lsTemp
				idsPOheader.SetItem(llNewRow, 'User_Field6', lsTemp)  /* UF6 - 'From' Location */ 
				lsUF6 = lsTemp
			 
				
				 //Jxlim 05/24/2011 #198 look up from customer _master table if user_field6 =cust_code then
				//set user_filed5 (country of dispatch) with country from customer_master
			//TAM - 3/18 - S13945 -  Don't allow "INACTIVE" customers
				String lsSFCustType
//				Select   Country Into :ls_country
				Select   Country, customer_type Into :ls_country, :lsSFCustType
					  From    Customer
					  Where  Project_id = :asproject					 
					  And       Cust_code = :lsUF6					  
					  Using    SQLCA;
					  
				 //Jxlim 04/12/2012 Added  -- Update to edi (idsPOheader)
				If sqlca.sqlcode = 0 Then

					//TAM - 3/18 - S13945 -  Don't allow "INACTIVE" customers
					If  lsSFCustType = 'IN' Then		
						gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " -Invalid Customer Code specified (" + lsUF6 +")! Record will not be processed.")
						lbError = True
						Continue /*Process Next Record */
					End If 
					
					idsPOheader.SetItem(llNewRow, 'User_Field5', ls_country)  /* UF6 - 'From' Location */ 
//						Update Receive_Master
//						Set 		Receive_Master.User_field5 = :ls_country
//						Where   Project_id = :asproject						
//						And   	User_Field6 = :lsUF6
//						And        Supp_Invoice_No = :lsOrderNo
//						Using    SQLCA;	
//						If sqlca.sqlcode < 0 then
//							Execute Immediate "ROLLBACK" using SQLCA;
//							//TEMPO Messagebox ("DB Error", SQLCA.SQLErrText)
//							//Return -1
//						Else
//							Commit;
//						End If
					//Jxlim 05/27/2011 Commented out the Else statement, because having Return 1 causing the insert failed (not inserts are perfromed)
					//Else /*not Found*/               
					//Return 1
				 End If
				//Jxlim 05/24/2011 End of Country of dispatch #198	
   
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				// UF7 - Pandora PO Line Type
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 lsTemp = lsRecData
				End If     
				idsPOheader.SetItem(llNewRow, 'User_Field7', lsTemp)  /* UF7 - PO Line Type */   
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				
				// UF8 - 'From' Project
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 lsTemp = lsRecData
				End If     
				//idsPOheader.SetItem(llNewRow, 'User_Field8', lsTemp)  /* UF8 - From Project */ 
				// dts - 2015-07-08 - Suddenly 'From Project' is required as 3B2s are failing in Pandora on WMS-to-SIMS wh xfers due to FromProject mismatch (the In-transit inventory has a different project than 'MAIN' which is going out from SIMS as the default)
				// - *** assumption is the header-level FromProject may be propagated to the detail
				lsFromProject = lsTemp //for use later on the Detail lines as FromProject is RD.UF2

				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				// UF9 - Vendor Name
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 lsTemp = lsRecData
				End If     
				idsPOheader.SetItem(llNewRow, 'User_Field9', lsTemp)  /* UF9 Vendor Name */ 
				  
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				//UF10 - Buyer Name
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 lsTemp = lsRecData
				End If     
				idsPOheader.SetItem(llNewRow, 'User_Field10', lsTemp)  /* UF10 Buyer Name */ 
				  
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				// UF11 - Requestor Name
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 lsTemp = lsRecData
				End If     
				idsPOheader.SetItem(llNewRow, 'User_Field11', lsTemp)  /* UF11 Requestor Name */ 
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				
				  // UF12 - Cost Center *TODO Add to tables and PO header process *Not used until then
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 lsTemp = lsRecData
				End If     
				idsPOheader.SetItem(llNewRow, 'User_Field12', lsTemp)  /* UF12 Cost Center */ 
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				// Customer_sent_date -  TAM 2010/01/17 
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 lsTemp = lsRecData
				End If     
				
				lsDate = Mid(lsTemp, 5, 2) + '/' + Mid(lsTemp,7, 2) + '/' + Left(lsTemp, 4)
				idsPOHeader.SetItem(llNewRow, 'customer_sent_date', lsDate) 
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

				// TimA 02/17/2012 Pandora issue #348 add new field Supp_Order_No -
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 lsTemp = lsRecData
				End If     
				idsPOheader.SetItem(llNewRow, 'Supp_Order_No', lsTemp)  /* Supp_Order_No */ 
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

				//PO Number - TAM 05/2016  
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 lsTemp = lsRecData
				End If     
				idsPOheader.SetItem(llNewRow, 'Client_Cust_PO_NBR', lsTemp)  
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				
				//GailM 08/08/2017 SIMSPEVS-537 - Identify MIM order - If not a MIM order, default to *all
				If Left( lsTemp, 1 ) = "X" Then
					lsMIMOrder = 'Yes'		
				End If

				//Vendor Order Number - TAM 05/2016  
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 lsTemp = lsRecData
				End If     
				idsPOheader.SetItem(llNewRow, 'Vendor_Invoice_Nbr', lsTemp)  
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

				//Probill - TAM 05/2016  
				If Pos(lsRecData,'|') > 0 Then
					 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				Else 
					 lsTemp = lsRecData
				End If     
				idsPOheader.SetItem(llNewRow, 'Client_Invoice_Nbr', lsTemp)  
				lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		CASE 'PD', 'AD' /* detail */
			lbDetailError = False
   
			// Rollup of LPN detail to pallet/pono2 level.  CartonID/ContainerID will be in carton/serial but not in EDI Inbound
			//if lsPONO2Prev = lsPONO2 and lsPONO2Prev <> "" then
				// Do not insert a new detail record
			//else
				llNewDetailRow =  idsPODetail.InsertRow(0)
			//end if
			
			
			llLineSeq ++
			llLineNum ++
			ll_sn_count = 0
     
			//Add detail level defaults
			idsPODetail.SetItem(llNewDetailRow,'order_seq_no', llOrderSeq) 
			idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			idsPODetail.SetItem(llNewDetailRow,"order_line_no", string(llLineSeq))
			//TAM 2009/08/25 change line item number to increment.  We are now saving Pandoras Line no into User Line No
			//dts 4/6/11 - may be splitting line item by serial number so have to use a different increment for line_item than we use for edi's order_line_no 
			//idsPODetail.SetItem(llNewDetailRow,'line_item_no', llLineSeq)
			idsPODetail.SetItem(llNewDetailRow,'line_item_no', llLineNum)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			
			//Action Code
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			 	lsActionCD = lsTemp
			Else /*error*/
			 	gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Action Code' field. Record will not be processed.")
			 	lbDetailError = True
			End If 

			// LTK 20160301	Roy no longer wants updates to void orders treated as adds, comment out block below...
			//
			//
//			// LTK 20111117	Pandora #304 If the last SIMS order is set to Void status and this 3B2 is an "Update", treat this PO as an add.
//			if lb_update_void_treat_as_add then
//				lsActionCD = 'A'
//			end if
//			// #304 end of block

			// LTK 20110823	Pandora #254 - For Pandora orders, treat 'A' as 'U' if order exists.  Since 'U' is treated as 'A' if no order
			// 						exists, no need to check for existing order.
			// LTK 20111108	Treat adds as updates *except* from MATERIAL RECEIPT orders			
			//if lsTemp = 'A' then
			if lb_treat_adds_as_updates then			
				idsPODetail.SetItem(llNewDetailRow,'action_cd','U') 
				lsActionCD = 'U'
			else
				//idsPODetail.SetItem(llNewDetailRow,'action_cd',lsTemp) 
				idsPODetail.SetItem(llNewDetailRow,'action_cd',lsActionCD) 	// #304 use the variable which is set upon parsing the file record above
			end if
			//idsPODetail.SetItem(llNewDetailRow,'action_cd',lsTemp) 
			// end #254

			//2009/08/17  TAM Remove Action Change because of the Delete/Add logic from the header above   
			//   if lsTemp = 'U' then
			//    idsPODetail.SetItem(llNewDetailRow, 'action_cd', 'A') 
			//   end if
			//   if lsTemp = 'U' then
			//    idsPOheader.SetItem(llNewRow, 'action_cd', 'X')  // 4-14-09: setting to X so it always adds/updates.
			//   elseif lsTemp = 'D' then
			//    idsPOheader.SetItem(llNewRow, 'action_cd', 'U')  // Setting to 'U' so order will be updated with Delete
			//   end if
				// 4-14-09: setting to X so it always adds/updates.
			//2009/07/13  TAM Remove Action Change   
			//2009/09/09  TAM Adding it back in for update 
			if lsTemp = 'A' or lsTemp = 'U' then
				 idsPOheader.SetItem(llNewRow, 'action_cd', 'X') 
			end if
		  
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				 if lbLPN and Pos(lsTemp,"-LPN") = 0 then
					lsTemp += "-LPN" + right("00" + string(llLPNNo, '##'),2)
				end if

			/* TAM - 2016/08/26 - Temporary FIX for Universal MOR Shipment ID project.  ICC may not send and invoice Number(Should only be for Cycle count 3b2s).  
								If no invoice number is sent then grab the value from the Client_Cust_Po_Nbr(field 22 loaded above)
			*/
			If lsTemp = '' Then
				lsTemp = lsClientCustPoNbr
			End If

				 lsOrderNum = trim(lsTemp)
			Else /*error*/
				 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Number' field. Record will not be processed.")
				 lbDetailError = True   
			End If      
			
			//Make sure we have a header for this Detail...
			//GailM - 10/29/2013 - Issue 668 Multiple LPN orders will be appended with -LPNxx in order no.
			If idsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'", 1, idsPoHeader.RowCount()) = 0 Then
				lsLPNOrder = idsPoHeader.GetItemString(idsPoHeader.RowCount(),"order_no")
				ll_rm_lpnbr = Pos(lsLPNOrder,"-LPN")
				IF ll_rm_lpnbr > 0 then
					lsTemp = lsLPNOrder		//LPN order 
				else
					 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Detail Order Number does not match header Order Number. Record will not be processed.")
					 lbDetailError = True
				end if
			End If
			
			idsPODetail.SetItem(llNewDetailRow, 'Order_No', Trim(lsTemp))
			//lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			lsRecData = Right(lsRecData,(len(lsRecData) - (Pos(lsRecData,'|')))) /*strip off to next Column */
			
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
				// TAM 2009/08/25 change line number to increment.  We are now saving Pandoras Line no into User Line Item No
				 lsUserLineItemNo = Trim(lsTemp)
				 idsPODetail.SetItem(llNewDetailRow,'user_line_item_no',Trim(lsTemp))
				//    idsPODetail.SetItem(llNewDetailRow,'line_item_no',Dec(Trim(lsTemp)))
			End If
		  
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//SKU
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Upper(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else /*error*/
				 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				 lbDetailError = True
			End If
				
			lsSKU = trim(lsTemp)  
			/* may use to build itemmaster record 
			Need to check SKU in Item_Master and, if it's not there, check MFG SKU Look-up */
			Select distinct(SKU) into :lsSKU2
			From Item_Master
			Where Project_id = :asProject
			and SKU = :lsSKU;
			
			if lsSKU2 = '' then 
				 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Missing Pandora SKU...") 
			end if
			
			/* Populate ldsItem datastore to determine whether this SKU is LPN or non-LPN */
			liItems = ldsItem.Retrieve( asProject, lsSKU )
			if liItems = 1 then
				if (ldsItem.GetItemString(1, "serialized_ind") = "B" and  ldsItem.GetItemString(1, "po_no2_controlled_ind") = "Y" and ldsItem.GetItemString(1, "container_tracking_ind") = "Y") then
					lbLPN = true
					// Update order to LPN order number
					lsOrderNo = lsLPNOrder
					lsOrderNum = lsOrderNo
					idsPOHeader.SetItem(llNewRow,'Order_No',Trim(lsLPNOrder))
					idsPODetail.SetItem(llNewDetailRow, 'Order_No', Trim(lsLPNOrder))
				else 
					lbLPN = false
				end if
			else
				lbLPN = false
			end if
			
			If lsSKU <> lsSKUPrev Then
				lbSKUChanged = true
				lsSKUPrev = lsSKU
			End IF
    
// TAM 2016/07/29 - Used to check the 'SN' record type below. If Item is not serialized but serial numbers are passed in then skip the SN record.  This is because PANDORA made a change to their system and started passing serial numbers for non serialized items.			
// TAM 2016/09/07 - Must check if Item master exists so we don't get a Datawindow error.			
			if liItems >= 1 then
				if (ldsItem.GetItemString(1, "serialized_ind") = "B" or ldsItem.GetItemString(1, "serialized_ind") = "I")  then
					lbSerializedSKU = TRUE
				else
					lbSerializedSKU = FALSE
				end if
			else
				lbSerializedSKU = FALSE
			end if
			
			idsPODetail.SetItem(llNewDetailRow, 'SKU', lsSKU)
		  
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Qty
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				 lsTemp = lsRecData
			End If 
			
			llQuantity = long(trim(lsTemp))
	//		idsPODetail.SetItem(llNewDetailRow,'quantity',Trim(lsTemp)) /*checked for numerics in nvo_process_files.uf_process_purcahse_Order*/
			  // *** No more required fields...
		  
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Inventory Type
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				 lsTemp = lsRecData
			End If 
			
			lsInvType = lsTemp
			If lsTemp > '' Then /*override default if present*/ 
				 idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', lsTemp)
			End If
		  
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Alternate SKU
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				 lsTemp = lsRecData
			End If 
			
			lsAltSku = lsTemp
			idsPODetail.SetItem(llNewDetailRow,'Alternate_SKU',lsTemp)
			  
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//lot No
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				 lsTemp = lsRecData
			End If 
			
			lsLotNo = trim(lsTemp)
			idsPODetail.SetItem(llNewDetailRow, 'Lot_no', trim(lsTemp))
   
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO - Pandora Project...
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				 lsTemp = lsRecData
			End If 
			
			if lsTemp = '' then
				 lsProject = 'MAIN' //PO_NO tracking is on for all SKUs. Defaulting to 'MAIN'
			else
				 lsProject = lsTemp
			end if
			
			idsPODetail.SetItem(llNewDetailRow, 'PO_NO', lsProject)
			
			// dts - 2015-07-08 - 'From Project' is being set from Header record and populated here now (4B2s from WMS-to-SIMS x-fers suddenly started failing due to FromProject mismatch)
			idsPODetail.SetItem(llNewDetailRow, 'User_Field2', lsFromProject)
							
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO 2
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				 lsTemp = lsRecData
			End If 
			
			lsPONO2 = trim(lsTemp)
			idsPODetail.SetItem(llNewDetailRow,'po_no2',lsTemp)
			If lsPONO2Prev = "" Then
				lsPONO2Prev = lsPONO2
				lbFirst = TRUE
			Else
				lbFirst = FALSE
			End If
			If lsPONO2 = lsPONO2Prev Then
				if lbLPN Then
					if not lbFirst Then
						idsPODetail.DeleteRow(llNewDetailRow)
						llNewDetailRow = idsPODetail.RowCount()
						llLineSeq --		//Decrement OrderLineNo 
						llLineNum --
					Else
						idsPODetail.SetItem(llNewDetailRow,'Quantity','0')
					End If
				Else
					if isnull(idsPODetail.GetItemString(llNewRow,'Quantity')) or lbSKUChanged then
						idsPODetail.SetItem(llNewDetailRow,'Quantity','0')
					end if
				
					llTempQty = Dec(idsPODetail.GetItemString(llNewDetailRow,'Quantity'))  + llQuantity
					lsTempQty = string(llTempQty)
					idsPODetail.SetItem(llNewDetailRow,'Quantity',lsTempQty)
				End If
			Else
				idsPODetail.SetItem(llNewDetailRow,'Quantity','0')
				llTempQty = Dec(idsPODetail.GetItemString(llNewDetailRow,'Quantity'))  + llQuantity
				lsTempQty = string(llTempQty)
				//idsPODetail.SetItem(llNewDetailRow,'Quantity',lsTempQty)  1/9/2014 deleted
				lsPONO2Prev = lsPONO2
			End If
			  
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Serial No
			If Pos(lsRecData,'|') > 0 Then
			 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
			 lsTemp = lsRecData
			End If
			//dts 4/5/11 - now set in separate serial loop...
			//idsPODetail.SetItem(llNewDetailRow,'Serial_No',lsTemp)
			  
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Expiration date
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				 lsTemp = lsRecData
			End If 
			
			//idsPODetail.SetItem(llNewDetailRow,'expiration_date',dateTime(lsTemp))
			  
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//For Pandora, assigning Owner based on Sub-Inventory Location (Group- and location- specific)
			If Pos(lsRecData,'|') > 0 Then
			 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
			 lsTemp = lsRecData
			End If      
			
			//Need to look-up Owner_CD (but shouldn't look it up for each row if it doesn't change)
			lsOwnerCD = lsTemp
			if lsOwnerCD <> lsOwnerCD_Prev then
				 lsOwnerID = ''
				 select owner_id into :lsOwnerID
				 from owner
				 where project_id = :asProject and owner_cd = :lsOwnerCD;
				 lsOwnerCD_Prev = lsOwnerCD

				// TAM 2017/09 - SIMSPEVS - 816 - If Customer Type = "INACTIVE" then it is invalid -Begin
				string lsSTCustType
				
				select customer_type into :lsSTCustType
				from customer
				where project_id = 'PANDORA' and customer_type <> 'IN'
				and cust_code = :lsOwnerCD;
			
				// - Throw error message if Customer is not in Customer_Master
				if isnull(lsSTCustType) or lsSTCustType = '' then
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " -Invalid Customer Code specified (" + lsOwnerCD +")! Record will not be processed.")
					lbDetailError = True
				End iF
				// TAM 2017/09 - SIMSPEVS - 816 - If Customer Type = "INACTIVE" then it is invalid -End

			end if
			
			idsPODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
			//TimA 11/10/11 Pandora issue #329  Add Sub Inventory
			idsPOHeader.SetItem(llNewDetailRow,'User_Field2',lsOwnerCD)			

			//TAM 2009/07/13 If UF7 is 'MATERIAL RECEIPT' and TO owner code is 'WHIEDUBEN'  the set UF7 to 'RETURN RECEIPT' 
			//Hokey but Pandora is anable to determine this is an Enterprise ASN and needs to change UF7.  This is a workaround
			//dts - 07/14 - Pandora is now going to handle this on their end.
			// If idsPOHeader.GetItemString(1, 'user_field7') = 'MATERIAL RECEIPT' and lsOwnerCd = 'WHIEDUBEN' Then
				//  idsPOheader.SetItem(1, 'User_Field7', 'RETURN RECEIPT' )  /* UF7 - PO Line Type */ 
			//End If
			  
			//Should we set RM.UF2 to Owner (like the manually-entered orders)?
			// - now getting it from ICC in header record
			//If first row for the order, set UF2 to Sub-Inv Loc
			If llLineSeq = 1 Then
				 //not setting this now idsPOheader.SetItem(llNewRow, 'User_Field2', lsTemp)
				 // but need to set WH since not set at header any more (should validate that it doesn't change between lines)
				 select user_field1, user_field2 into :lsGroup, :lsWarehouse
				 from customer
				 where project_id = :asProject and cust_code = :lsOwnerCD;
				 idsPOheader.SetItem(llNewRow, 'wh_code', lsWarehouse)  /*  */ 
				 // 3/30/2010 - they want the Order Date to be represented in the time zone of the warehouse...
					/*
					integer liOffset
					datetime ldtWHTime
					string lsWHTime
						 select gmt_offset into :liOffset
						 from warehouse
						 where wh_code = :lsWarehouse;
						 lsWHTime = String(Today(), "m/d/yy hh:mm")
						 ldtWHTime = datetime(lsWHTime)) + liOffset/24
						 idsPOheader.SetItem(llNewRow, 'ord_date', ldtWHTime)  */ 
						 
				 // 4/2010  - now setting ord_date to local wh time
				 ldtWHTime = f_getLocalWorldTime(lsWarehouse)
				 idsPOheader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm')) 
			 
				 if lbCrossDock = True then
					  // dts 2010/08/12 - now seeding l_code with a cross-dock location if it's a cross-dock order
					  //TODO!  need to look up a (empty?) cross-dock location? (where l_type = '9')
					  select min(l_code) into :lsCrossDock_Loc from location
					  where wh_code = :lsWarehouse and l_type = '9';
				 end if
				 
				 lsCrossDock_Loc = NoNull(lsCrossDock_loc)
			End If
			
			// 10/15/09 -  RMA has different Inventory_Type rules based on Project (po_no)...
			if lsGroup = 'RMA' then //now testing for RMA instead of not DECOM.
					if llLineSeq = 1  then // don't look up supplier for each detail row; only the first row for the order
						  //if Order is RMA and From Location is a supplier, set order_type to 'R' (return from supplier) here
						  select supp_code into :lsSupplier
						  from supplier
						  where project_id = :asProject and supp_code = :lsUF6;  //UF6 is 'FROM' Location
						  if lsUF6 > '' then
							idsPOHeader.SetItem(llNewRow, 'Order_Type', 'R') 
						  end if
					end if
					//11/11      if lsProject = 'RTV-IN' or lsProject = 'RTV-OUT' then
					//       idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N') 
					//      elseif lsProject = 'OSV' then
					//       idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N')
					//      elseif lsProject = 'SCRAP' then
					//       idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'S') 
					//      elseif lsProject = 'DECOM' then
					//       idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N')
					
					//      elseif lsProject = 'MRB' then
					// ET3 2012-12-06 Pandora 545 - no longer track by MRB inventory type
					//       idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N')
					//       //idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'M')
					//      end if
					
					//Q....Is it detail or header level ??????
					 if lsProject = 'RTV-RMA' or lsProject = 'RTV-PO' then
						  idsPOHeader.SetItem(llNewDetailRow, 'Inventory_Type', 'N') /* RTV */ 
						  idsPOHeader.SetItem(llNewDetailRow, 'Order_Type', 'Y') 
					 elseif lsProject = 'OSV' then
						  idsPOHeader.SetItem(llNewDetailRow, 'Inventory_Type', 'N') 
						  idsPOHeader.SetItem(llNewDetailRow, 'Order_Type', 'Y') 
					 elseif lsProject = 'REMARKET' then
						
						  idsPOHeader.SetItem(llNewDetailRow, 'Inventory_Type', 'N') 
						  idsPOHeader.SetItem(llNewDetailRow, 'Order_Type', 'Y') 
						 //11/11 elseif lsProject = 'SCRAP' then
						 //11/11  idsPOHeader.SetItem(llNewDetailRow, 'Inventory_Type', 'S') 
						 //11/11  //idsPOHeader.SetItem(llNewDetailRow, 'Order_Type', 'Y') 
						 //11/11 elseif lsProject = 'DECOM' then
						 //11/11  idsPOHeader.SetItem(llNewDetailRow, 'Inventory_Type', 'N') 
						 //11/11  //idsPOHeader.SetItem(llNewDetailRow, 'Order_Type', 'Y') 
					 
					 // ET3 2012-12-06 Pandora 545 - no longer track by MRB inventory type
//					 elseif lsProject = 'MRB' then
//						  idsPOHeader.SetItem(llNewDetailRow, 'Inventory_Type', 'M') 
//						  idsPOHeader.SetItem(llNewDetailRow, 'Order_Type', 'Y') 
					 else
						  idsPOHeader.SetItem(llNewDetailRow, 'Inventory_Type', 'N') /*default to Normal*/
					 end if
			end if
			
			//dts 2013-06-23, container ID coming in for LPN project (608)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Container ID
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				 lsTemp = lsRecData
			End If 
			
			lsContainer = trim(lsTemp)
			If lbLPN Then
				idsPODetail.SetItem(llNewDetailRow, 'container_id', '-')		//Pallet Rollup.  Container No tracked forLPN (Set to dash)
			Else
				idsPODetail.SetItem(llNewDetailRow, 'container_id', lsContainer)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */


			// From Warehouse  -  The From Project is now being sent at the detail level PD016.  LTK 20150820
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				 lsTemp = lsRecData
			End If
			
			// If the From Project is passed in the detail record PD016, then use it.  Otherwise, it is set from the header above.  LTK 20150821
			if Trim( lsTemp ) <> '' then

				// One exception.  The WMS-to-SIMS transfers incorrectly have the 16th field already populated with the line item number with preceding zeros.  Ex...
				//
				// 		PD|A|MORSC105597160|4|07106622|100||||WHBEGHH||||WHBEGHP||0000000004|
				//
				// Skip these and don't use them as From Project
				lb_set_from_project_from_detail = TRUE
				if IsNumber( lsTemp ) and IsNumber( lsUserLineItemNo ) then
					ll_line_item_no = Long( lsTemp )
					ll_line_item_no_from_project = Long( lsUserLineItemNo )
					if ll_line_item_no = ll_line_item_no_from_project then
						lb_set_from_project_from_detail = FALSE
					end if
				end if

				if lb_set_from_project_from_detail then
					lsFromProject = lsTemp
					idsPODetail.SetItem(llNewDetailRow, 'user_field2', lsFromProject)
				end if
			end if

			
			//If detail errors, delete the row...
			if lbDetailError Then
				 lbError = True
				 idsPoDetail.DeleteRow(llNewDetailRow)
				 Continue
			End If
			
			//GailM - 9/9/2013 - Pandora Issue 594 - Add PO Line Date
			//PO Line Date

			//TimA 09/03/14 No longer needed.  Never implemented.

//			If Pos(lsRecData,'|') > 0 Then
//				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//			Else 
//				 lsTemp = lsRecData
//			End If 
//			
//			lsPoLineDate = trim(lsTemp)
//			idsPODetail.SetItem(llNewDetailRow, 'po_line_date', lsPoLineDate)
//			
//			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//			
//			//If detail errors, delete the row...
//			if lbDetailError Then
//				 lbError = True
//				 idsPoDetail.DeleteRow(llNewDetailRow)
//				 Continue
//			End If


			//TimA 10/07/14 - Pandora Issue 889 - Add Shipment_Distribution_No
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				 lsTemp = lsRecData
			End If 

			lsShipmentDistributionNo = Nz(trim(lsTemp ) ,'')
			//dts - 11/04/2015 - slamming po_no into Shipment_distribution_no to split single PND line by Project (we need the Project on the detail line in order to find it when creating the back order)
			//idsPODetail.SetItem(llNewDetailRow, 'Shipment_Distribution_No', lsShipmentDistributionNo)
			//dts 2016-03-02 - They SAY they won't split a line by Project but they will potentially CHANGE the project so not setting SDN to po_no.
			//dts idsPODetail.SetItem(llNewDetailRow, 'Shipment_Distribution_No', lsProject)

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//If detail errors, delete the row...
			if lbDetailError Then
				 lbError = True
				 idsPoDetail.DeleteRow(llNewDetailRow)
				 Continue
			End If

			//TimA 10/07/14 - Pandora Issue 889 - Add Need_By_Date
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				 lsTemp = lsRecData
			End If 

			ldNeedByDate = DateTime(trim(lsTemp ) )
			idsPODetail.SetItem(llNewDetailRow, 'Need_By_Date', ldNeedByDate)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//If detail errors, delete the row...
			if lbDetailError Then
				 lbError = True
				 idsPoDetail.DeleteRow(llNewDetailRow)
				 Continue
			End If

			
			// TAM 2009/10/29 Find the Row in the Delivery Detail Datastore and if Found Then Delete It from the DataStore.
			//  This will leave those records that need to be deleted from Delivery Detail
			If  idsPODetail.GetItemString(llNewDetailRow,'action_cd') = 'U' Then
				 lsFind = "upper(sku) = '" + upper(lsSku) +"'"
				 lsFind += " and user_line_item_no = '" + lsUserLineItemNo + "'"
				 llFindRow = ldsRoNo.Find(lsFind, 1, ldsRoNo.RowCount())
				 If llFindRow > 0 Then 
					  // TAM 2009/10/29 change line item number for updated row to original line number found. 
					  idsPODetail.SetItem(llNewDetailRow,'line_item_no',ldsRoNo.GetItemNumber(llfindRow,'Line_Item_No'))
					  ldsRoNo.DeleteRow(llFindRow)
				 End If
			End If
			
			if lbCrossDock = True and lsCrossDock_Loc > '' then
				idsPODetail.SetItem(llNewDetailRow, 'l_code', lsCrossDock_Loc)
			end if
			
		Case 'SN'
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//Start SN section for both LPN and non-LPN GPNs
			// dts 4/5/11 - now capturing all of the detail line's data first and then setting edi_detail record fields from variables (one detail row per serial#)..
			/*DTS - 4/5/11 - now getting separate serial loop on 4b2
				- we'll check the 'next' record and if it's a SN record, then we'll loop thru the serials until done
			  We'll create an edi detail record for each serial no (using the variables captured above)
			  We'll then aggregate them in process_files to be a single detail line
			  Note - we won't always get enough serial numbers in which case we'll create a line for the remaining qty (with no serial_no) */
			//TODO! - check how this will work with updates/deletes!!!

			//TAM 2016/07/29 - If Item is not serialized but serial numbers are passed in then skip the SN record.  This is because PANDORA made a change to their system and started passing serial numbers for non serialized items.
			If lbSerializedSKU = False Then Continue
			
			// START SN SECTION
				if lbLPN then
						// START LPN SN SECTION
						lsLPNActionCD = lsActionCd
						ll_sn_count ++
						lsThisContainer = lsContainer 		//Must reuse the lsContainer from PD line for each SN.  ContainerId will be SN for each SN line
						//first set the serial_no for the current detail line...
						lsRecData = Right(lsRecData, (len(lsRecData) - 3)) /*strip off to first column after rec type */
						//Serial Number
						If Pos(lsRecData, '|') > 0 Then
							lsSerial = Left(lsRecData, (pos(lsRecData, '|') - 1))
						Else
							lsSerial = lsRecData
						End If
						//idsPODetail.SetItem(llNewDetailRow, 'quantity', '1')
						llRemainingQty = llQuantity - 1
						llSerialCount = 1
						
							// For LPN GPNs the carton_id Detail cannot be blank.  Set carton_id = serial_no 
							// Also create a EDI_Inbound_Detail for each serialno/cartonid
							// Not needed for Pallet Rollup.  CartonID and SerialNo to carton/serial only
							if lsThisContainer = '' then
								lsThisContainer = lsSerial
								if ll_sn_count = 1 then
									idsPODetail.SetItem( idsPODetail.RowCount(), 'serial_no','')
									//idsPODetail.SetItem( idsPODetail.RowCount(), 'container_id', lsSerial)
									idsPODetail.SetItem( idsPODetail.RowCount(), 'container_id', "-")		//Pallet Rollup - Set containerID to dash  lottable field.
									//idsPODetail.SetItem(idsPODetail.RowCount(), 'quantity',string(Dec(idsPODetail.GetItemString(llNewDetailRow,'Quantity'))  + 1))
								//else
									//liRC = idsPODetail.RowCount()
									//liRC =  idsPODetail.rowscopy(idsPODetail.RowCount(), idsPODetail.RowCount(), Primary!, idsPODetail, idsPODetail.RowCount()+1, Primary!)
									//liRC = idsPODetail.RowCount()		//Why is this set twice?
									//if liRC >= 1 then
									//	llLineSeq ++
										//idsPODetail.SetItem(liRC,'line_item_no',llLineSeq)
										//idsPODetail.SetItem(liRC,"Order_Line_No", string(llLineSeq))
										//idsPODetail.SetItem(liRC,'serial_no','')
										//idsPODetail.SetItem(liRC,'container_id',"")
										//idsPODetail.SetItem(liRC, 'quantity',string(Dec(idsPODetail.GetItemString(llNewDetailRow,'Quantity'))  + 1))
									//end if
								end if
							else
								idsPODetail.SetItem(llNewDetailRow, 'Serial_No', '')   //Blank out serial number for LPN 
							end if
							if lsPONO2 = '' then
								//lsPONO2 = '-'
								//GailM - 3/13/2014 - If LPN order is received without a PalletID/PO_No2, the load is rejected.  Get out and send error email
					 			lsLogOut = "        *** Missing required pallet ID/PO No2.  LPN GPNs must contain a valid PO No2 to complete processing.~r~r" + Errors
								gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
								gu_nvo_process_files.uf_writeError(lsLogOut)
								RETURN -1
							end if
							if lsSerial = '' then
								lsSerial = '-'
							end if
							
							// Before we start inserting serial numbers into carton_serial, check whether PalletID/CartonID/SerialNo already in 
							//   carton_serial.  If first one is in the table assume this is an update to an RO.
							If ll_sn_count = 1 and llRowPos <= 4 Then 		//First SN row will be 3 unless there is an RN note
								lb_sn_in_carton_serial = getCartonSerialData(asproject, lsPONO2, lsThisContainer,lsSerial)
								If lb_sn_in_carton_serial Then
									if ll_rm_count > 0 then		//This order exists and serial numbers are in carton_serial and ordStatus = New.  Update
										lsLPNOrder = is_Invoice
										lsOrderNo = is_Invoice
										lsOrderNum = is_Invoice
										lb_treat_adds_as_updates = true
										lsLPNActionCd = 'U'
										lsActionCd = 'U'										
										idsPODetail.SetItem(llNewDetailRow,'action_cd',lsLPNActionCD) 
										if llLPNNo > 0 then			//Order has an LPN No already
											//What to do if this is an update?  
											for ll_rm_pos = 1 to ll_rm_count
												lsLPNOrder = ""
												ll_rm_lpnbr ++
											next
										else
											//Append suffix on order
										//	if Pos(lsordernum,"-") = 0 then
										//		lsordernum += "-LPN01"
										//	end if
											idsPOheader.SetItem(idsPOheader.RowCount(), 'order_no', lsordernum)
											idsPODetail.SetItem(llNewDetailRow, 'Serial_No', lsorderno)   //Set this detail line with new order number
											//And update order
											Update receive_master Set supp_invoice_no = :lsorderno
											Where project_id = 'PANDORA' and ro_no in
												(Select ro_no from receive_master where project_id = 'PANDORA' 
													and supp_invoice_no = :lsordernum and ord_status = 'N') using SQLCA;
											lsorderno = lsordernum
										end if
									end if
								else
									// Serial data is not in carton_serial.  Do insert. Check suffix and update if not there.  No need for update receive_master
									if llLPNNo = 0 and llNewRoNoCount = 0 then
										//lsordernum += "-LPN01"
										lsOrderNo = lsLPNOrder
										lsOrderNum = lsordernum
										llLPNNo ++
									else
										for ll_rm_pos = 1 to llNewRoNoCount
											lsLPNOrder = ldsOrders.GetItemString(ll_rm_pos,"supp_invoice_no")
											
										next	
									end if
								End If
							End If
							
							idsPODetail.SetItem(llNewDetailRow,'action_cd',lsLPNActionCD) 
							idsPOheader.SetItem(idsPOheader.RowCount(), 'order_no', lsOrderNo)
							idsPODetail.SetItem(llNewDetailRow, 'order_no', lsordernum)   //Set this detail line with new order number
							// Add SN to qty
							idsPODetail.SetItem(llNewDetailRow,'Quantity',string(Dec(idsPODetail.GetItemString(llNewDetailRow,'Quantity'))  + 1))
							
							//ElseIf ll_sn_count = 0 Then
								// Check order number to append -LPNxx to end 
							//	If ll_rm_count = 0 Then
							//	End If
							//End If
							
							// Main window microhelp message for each serial number processed
							w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Inserting serial numbers")
					

							If lb_sn_in_carton_serial Then
								sql_syntax  = "sp_carton_serial_update '" + asproject + "','" + lsThisContainer + "', '" + lsSerial + "', '" + lsPONO2 + "', '"
								sql_syntax += string(ldtToday) + "','B','" + string(llBatchSeq) + "' "
							Else
								sql_syntax  = "sp_carton_serial '" + asproject + "','" + lsThisContainer + "', '" + lsSerial + "', '','" + lsPONO2 + "', '"
								sql_syntax += lsSKU + "','" + lsOwnerID + "','',NULL,NULL,NULL,'" + string(ldtToday) + "','N',"
								sql_syntax += string(llLineNum) + "," + string(llLineSeq) + ",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,"
								sql_syntax += string(llBatchSeq) + ",'LPN' "						
							end if
							
							//Execute Immediate "Begin Transaction" using SQLCA; 4/2020 - MikeA - DE15499
									
							Execute Immediate :sql_syntax using SQLCA;
							if SQLCA.SqlCode = -1 then
								//GailM 9/11/2013 - Duplicate SNs will fail the process immediately
								//lsLogOut = '      !!!! Duplicate serial number(s) found in carton/serial table.  Ensure this order has not been previously loaded.'
								lsLogOut = '      !!!!Error in serial number save: ' + SQLCA.SqlErrText
								FileWrite(giLogFileNo,lsLogOut)
								gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
								gu_nvo_process_files.uf_writeError(lsLogOut)
								 lbError = True
								 
								uf_sendemailnotification(lsWarehouse, lsOrderNo,lsLogOut)

								//Execute Immediate "Rollback Transaction" using SQLCA; 4/2020 - MikeA - DE15499
								   rollback using sqlca;
								return -1
							else
							//Execute Immediate "Commit Transaction" using SQLCA; 4/2020 - MikeA - DE15499
							commit using sqlca;
						End If
				else  //***END LPN SN SECTION***
					string lsRecData_Next, lsRecType_Next
					lbExtraSNs = FALSE
					
					// Since there are SN rows, save PD quantity and plug SN quantity to PODetail
					ll_pd_qty = Long(idsPODetail.GetItemString(llNewDetailRow,'quantity'))
					lsSerial = Right(lsRecData, (len(lsRecData) - 3))
					// Put SN in first PD line in detail
					idsPODetail.SetItem(llNewDetailRow, 'quantity', '1')
		//			idsPODetail.SetItem(llNewDetailRow, 'quantity', string(Dec(idsPODetail.GetItemString(llNewDetailRow,'Quantity'))  + 1))
					idsPODetail.SetItem(llNewDetailRow, 'Serial_No', lsSerial)
			
					llRemainingQty = llQuantity - 1				

					if llRowPos < llRowCount then // not the last row so check the next row
						lsRecData_Next = Trim(lu_ds.GetItemString(llRowPos + 1, 'rec_Data'))
						lsRecType_Next = Left(lsRecData_Next, 2) /* rec type should be first 2 char of file*/ 
						if lsRecType_Next = 'SN' then
							//first set the serial_no for the current detail line...
							lsRecData_Next = Right(lsRecData_Next, (len(lsRecData_Next) - 3)) /*strip off to first column after rec type */
							//Serial Number
							If Pos(lsRecData_Next, '|') > 0 Then
								lsSerial = Left(lsRecData_Next, (pos(lsRecData_Next, '|') - 1))
							Else
								lsSerial = lsRecData_Next
							End If

							If llRemainingQty = 0 and llRowPos < llRowCount Then	// Do not add record of last record
								lbExtraSNs = TRUE
								llRemainingQty = 1 		/* Lets loop, enter the extra SN and set Qty to zero */
								llDetailQty = 0
							Else
								lbExtraSNs = FALSE
								llDetailQty = 1
							End If
							llSerialCount = 2
							//llLineNum ++;
							//llOrderSeq ++
				  			llLineSeq ++
							  
							//now scroll through the serial records and create a detail line for each SN, with a quantity of 1
							// - count the serial #s and if the total count is less than the detail QTY, create a line for the difference
							/* GXMOR 598 Must add SNs even if there are more than PD shows as ReqQty.  Set Quantity of Zero. */
							Do While llRemainingQty > 0
								llNewDetailRow =  idsPODetail.InsertRow(0)
								//Add detail level defaults
								idsPODetail.SetItem(llNewDetailRow,'order_seq_no', llOrderSeq) 
								idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
								idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
								idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
								idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no', llbatchseq) /*batch seq No*/
								idsPODetail.SetItem(llNewDetailRow,"order_line_no", string(llLineSeq))
									//TAM 2009/08/25 change line item number to increment.  We are now saving Pandoras Line no into User Line No
								idsPODetail.SetItem(llNewDetailRow,'line_item_no', llLineNum)
								idsPODetail.SetItem(llNewDetailRow,'action_cd',lsActionCD) 
								idsPODetail.SetItem(llNewDetailRow, 'Order_No', lsOrderNum)
								idsPODetail.SetItem(llNewDetailRow,'user_line_item_no',lsUserLineItemNo)
								idsPODetail.SetItem(llNewDetailRow, 'SKU', lsSKU)
								idsPODetail.SetItem(llNewDetailRow,'quantity', string(llDetailQty))
								idsPODetail.SetItem(llNewDetailRow,'Alternate_SKU', lsAltSku)
								idsPODetail.SetItem(llNewDetailRow, 'Lot_no', lsLotNo)
								idsPODetail.SetItem(llNewDetailRow, 'PO_NO', lsProject)
								// dts - 2015-07-08 - 'From Project' is being set from Header record and populated here now (4B2s from WMS-to-SIMS x-fers suddenly started failing due to FromProject mismatch)
								idsPODetail.SetItem(llNewDetailRow, 'User_Field2', lsFromProject)
								idsPODetail.SetItem(llNewDetailRow,'po_no2', lsPONO2)
								idsPODetail.SetItem(llNewDetailRow,'Serial_No', lsSerial)
								idsPODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
								idsPODetail.SetItem(llNewDetailRow, 'Shipment_Distribution_No', lsShipmentDistributionNo)								

								If lsInvType > '' Then /*override default if present*/ 
									 idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', lsInvType)
								End If

								if lbCrossDock = True and lsCrossDock_Loc > '' then
									idsPODetail.SetItem(llNewDetailRow, 'l_code', lsCrossDock_Loc)
								end if
								
								llLineSeq ++  // still have to increment the EDI order_line_no
								llRemainingQty --
								llRowPos ++
								if llRowPos < llRowCount then // not the last row so check the next row
									lsRecData_Next = Trim(lu_ds.GetItemString(llRowPos + 1, 'rec_Data'))
									lsRecType_Next = Left(lsRecData_Next, 2) /* rec type should be first 2 char of file*/ 
									if lsRecType_Next = 'SN' then
										//There's another serial number so keep going...
										lsRecData_Next = Right(lsRecData_Next, (len(lsRecData_Next) - 3)) /*strip off to first column after rec type */
										//Serial Number
										If Pos(lsRecData_Next, '|') > 0 Then
											lsSerial = Left(lsRecData_Next, (pos(lsRecData_Next, '|') - 1))
										Else
											lsSerial = lsRecData_Next
										End If
										//llRemainingQty = llRemainingQty - 1
										llSerialCount += 1

										If llRemainingQty = 0 and llRowPos < llRowCount Then	// Do not add record of last record
											lbExtraSNs = TRUE
											llRemainingQty = 1 		/* Lets loop, enter the extra SN and set Qty to zero */
											llDetailQty = 0
										Else
											lbExtraSNs = FALSE
											llDetailQty = 1
										End If
									else
										if llRemainingQty > 0 Then 
											//create a detail record for the remaining qty, with no serial_no
											llDetailQty = llRemainingQty
											llRemainingQty =0
											lsSerial = ''
											llNewDetailRow =  idsPODetail.InsertRow(0)
											//Add detail level defaults
											idsPODetail.SetItem(llNewDetailRow,'order_seq_no', llOrderSeq) 
											idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
											idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
											idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
											idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no', llbatchseq) /*batch seq No*/
											idsPODetail.SetItem(llNewDetailRow,"order_line_no", string(llLineSeq))
												//TAM 2009/08/25 change line item number to increment.  We are now saving Pandoras Line no into User Line No
											idsPODetail.SetItem(llNewDetailRow,'line_item_no', llLineNum)
											idsPODetail.SetItem(llNewDetailRow,'action_cd',lsActionCD) 
											idsPODetail.SetItem(llNewDetailRow, 'Order_No', lsOrderNum)
											idsPODetail.SetItem(llNewDetailRow,'user_line_item_no',lsUserLineItemNo)
											idsPODetail.SetItem(llNewDetailRow, 'SKU', lsSKU)
											idsPODetail.SetItem(llNewDetailRow,'quantity', string(llDetailQty))
											idsPODetail.SetItem(llNewDetailRow,'Alternate_SKU', lsAltSku)
											idsPODetail.SetItem(llNewDetailRow, 'Lot_no', lsLotNo)
											idsPODetail.SetItem(llNewDetailRow, 'PO_NO', lsProject)
											// dts - 2015-07-08 - 'From Project' is being set from Header record and populated here now (4B2s from WMS-to-SIMS x-fers suddenly started failing due to FromProject mismatch)
											idsPODetail.SetItem(llNewDetailRow, 'User_Field2', lsFromProject)
											idsPODetail.SetItem(llNewDetailRow,'po_no2', lsPONO2)
											idsPODetail.SetItem(llNewDetailRow,'Serial_No', lsSerial)
											idsPODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
											idsPODetail.SetItem(llNewDetailRow, 'Shipment_Distribution_No', lsShipmentDistributionNo)																			
											If lsInvType > '' Then /*override default if present*/ 
												 idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', lsInvType)
											End If
			
											if lbCrossDock = True and lsCrossDock_Loc > '' then
												idsPODetail.SetItem(llNewDetailRow, 'l_code', lsCrossDock_Loc)
											end if
										end if
									end if //next record is of type 'SN'
								else
									//create a detail record for the remaining qty, with no serial_no
									if llRemainingQty <> 0 then
										llDetailQty = llRemainingQty
										llRemainingQty = 0
										lsSerial = ''
										llNewDetailRow =  idsPODetail.InsertRow(0)
										//Add detail level defaults
										idsPODetail.SetItem(llNewDetailRow,'order_seq_no', llOrderSeq) 
										idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
										idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
										idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
										idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no', llbatchseq) /*batch seq No*/
										idsPODetail.SetItem(llNewDetailRow,"order_line_no", string(llLineSeq))
											//TAM 2009/08/25 change line item number to increment.  We are now saving Pandoras Line no into User Line No
										idsPODetail.SetItem(llNewDetailRow,'line_item_no', llLineNum)
										idsPODetail.SetItem(llNewDetailRow,'action_cd',lsActionCD) 
										idsPODetail.SetItem(llNewDetailRow, 'Order_No', lsOrderNum)
										idsPODetail.SetItem(llNewDetailRow,'user_line_item_no',lsUserLineItemNo)
										idsPODetail.SetItem(llNewDetailRow, 'SKU', lsSKU)
										idsPODetail.SetItem(llNewDetailRow,'quantity', string(llDetailQty))
										idsPODetail.SetItem(llNewDetailRow,'Alternate_SKU', lsAltSku)
										idsPODetail.SetItem(llNewDetailRow, 'Lot_no', lsLotNo)
										idsPODetail.SetItem(llNewDetailRow, 'PO_NO', lsProject)
										// dts - 2015-07-08 - 'From Project' is being set from Header record and populated here now (4B2s from WMS-to-SIMS x-fers suddenly started failing due to FromProject mismatch)
										idsPODetail.SetItem(llNewDetailRow, 'User_Field2', lsFromProject)
										idsPODetail.SetItem(llNewDetailRow,'po_no2', lsPONO2)
										idsPODetail.SetItem(llNewDetailRow,'Serial_No', lsSerial)
										idsPODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
										idsPODetail.SetItem(llNewDetailRow, 'Shipment_Distribution_No', lsShipmentDistributionNo)																		
										If lsInvType > '' Then /*override default if present*/ 
											 idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', lsInvType)
										End If
		
										if lbCrossDock = True and lsCrossDock_Loc > '' then
											idsPODetail.SetItem(llNewDetailRow, 'l_code', lsCrossDock_Loc)
										end if
									end if
								end if //There is another record
							loop //while remaining Qty > 0
						end if //is Next record of type 'SN'
					elseif llRemainingQty > 0 then
						llDetailQty = llRemainingQty
						lsSerial = ''
				  		llLineSeq ++
						llNewDetailRow =  idsPODetail.InsertRow(0)
						//Add detail level defaults
						idsPODetail.SetItem(llNewDetailRow,'order_seq_no', llOrderSeq) 
						idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
						idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
						idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
						idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no', llbatchseq) /*batch seq No*/
						idsPODetail.SetItem(llNewDetailRow,"order_line_no", string(llLineSeq))
							//TAM 2009/08/25 change line item number to increment.  We are now saving Pandoras Line no into User Line No
						idsPODetail.SetItem(llNewDetailRow,'line_item_no', llLineNum)
						idsPODetail.SetItem(llNewDetailRow,'action_cd',lsActionCD) 
						idsPODetail.SetItem(llNewDetailRow, 'Order_No', lsOrderNum)
						idsPODetail.SetItem(llNewDetailRow,'user_line_item_no',lsUserLineItemNo)
						idsPODetail.SetItem(llNewDetailRow, 'SKU', lsSKU)
						idsPODetail.SetItem(llNewDetailRow,'quantity', string(llDetailQty))
						idsPODetail.SetItem(llNewDetailRow,'Alternate_SKU', lsAltSku)
						idsPODetail.SetItem(llNewDetailRow, 'Lot_no', lsLotNo)
						idsPODetail.SetItem(llNewDetailRow, 'PO_NO', lsProject)
						// dts - 2015-07-08 - 'From Project' is being set from Header record and populated here now (4B2s from WMS-to-SIMS x-fers suddenly started failing due to FromProject mismatch)
						idsPODetail.SetItem(llNewDetailRow, 'User_Field2', lsFromProject)
						idsPODetail.SetItem(llNewDetailRow,'po_no2', lsPONO2)
						idsPODetail.SetItem(llNewDetailRow,'Serial_No', lsSerial)
						idsPODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
						idsPODetail.SetItem(llNewDetailRow, 'Shipment_Distribution_No', lsShipmentDistributionNo)														
						If lsInvType > '' Then /*override default if present*/ 
							 idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', lsInvType)
						End If

						if lbCrossDock = True and lsCrossDock_Loc > '' then
							idsPODetail.SetItem(llNewDetailRow, 'l_code', lsCrossDock_Loc)
						end if						
					end if // not the last row...
				end if
						
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		Case "RN" /*Return NOtes*/
  
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
   
   
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				 lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Note Record will not be processed (Delivery Order will still be loaded)..")
				 lbError = True
				 Continue
			End If
			
			/* TAM - 2016/08/26 - Temporary FIX for Universal MOR Shipment ID project.  ICC may not send and invoice Number(Should only be for Cycle count 3b2s).  
								If no invoice number is sent then grab the value from the Client_Cust_Po_Nbr(field 22 loaded above)
			*/
			If lsTemp = '' Then
				lsTemp = lsClientCustPoNbr
			End If

			lsOrder = lsTemp
			
			//Make sure we have a header for this Detail...
			If idsPOHeader.Find("Upper(order_no) = '" + Upper(lsOrder) + "'",1,idsPOHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Order Number does not match header ORder Number. Note Record will not be processed (Return Order will still be loaded)..")
			 	Continue
			End If
			  
// TAM 2016/08/29
			lsRecData = Right(lsRecData,(len(lsRecData) - (Pos(lsRecData,'|')))) /*strip off to next Column */
//			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
   
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
			
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////			
	  	Case Else /* Invalid Rec Type*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
   			Continue
				
 		End Choose /*record Type*/
Next /*File record */

// Reset main window microhelp message
w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Completed File Rows")
	


// LTK 20120608  Pandora #353 Don't delete RD records when treating Adds as Updates
if NOT lb_treat_adds_as_updates then

	// TAM 2009/10/29 Any Rows left in the Detail Datastore need to be deleted so create a delete detail Row for each on.
	llDeleteRowCount = ldsRoNo.RowCount()
	If  llDeleteRowCount > 0 Then
		For llDeleteRowPos = 1  to llDeleteRowCount 
			llNewDetailRow =  idsPODetail.InsertRow(0)
			llLineSeq ++
			//Add detail level defaults
			idsPODetail.SetItem(llNewDetailRow,'order_seq_no', llOrderSeq) 
			idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			idsPODetail.SetItem(llNewDetailRow,"order_line_no", string(llLineSeq))
			idsPODetail.SetItem(llNewDetailRow,'action_cd','D') 
			idsPODetail.SetItem(llNewDetailRow,'line_item_no', ldsRoNo.GetItemNumber(llDeleteRowPos,'line_item_no'))
			idsPODetail.SetItem(llNewDetailRow,'SKU', ldsRoNo.GetItemString(llDeleteRowPos,'SKU'))
			idsPODetail.SetItem(llNewDetailRow,'Order_No', lsOrderNo)
		Next
	End If
end if
 //TimA 01/17/13 Pandora issue #501
//Varables are called in function uf_sendemailnotification
is_WhCode = lsWarehouse
is_Invoice = lsOrderNo

// Reset main window microhelp message
w_main.SetMicroHelp("Completed processing PO (Rose) SN - Saving datastores.")

//Save the Changes 
lirc = idsPOHeader.Update()
 
If liRC = 1 Then
	liRC = idsPODetail.Update()
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

// Reset main window microhelp message
w_main.SetMicroHelp("Ready")

If lbError Then
	Return -1
Else
	Return 0
End If
 

end function

public function integer uf_process_so_rose (string aspath, string asproject);//Process Material Transfer (Sales Order) for PANDORA 

/*
for DECOM, the 3B18 is for movement from a DC to a WH
 - we don't control inventory at the DC so we're creating an inbound order from DC to Local WH, and an outbound order to final destination (if necessary) 
   For RMA, the final destination may be a customer or even a DC.
    - In the case of a DC, we must ship to the associated WH 1st, then to the DC
	 (so, from DC to Local WH, Local WH to remote WH, from remote WH to remote DC 
	  - total of 4 orders - 2 inbound and 2 outbound
	  - Now some DC's operate as a WH...
	  ) 
   For Multi-stage (actually for HWOPS), the Project for the intermediate stop needs to be governed by the customer's UF10 field....
	- if it's going from Project 'X' to Project 'Y', receive into the intermediate stop based on Customer.UF10 (if present)
	 

 TODO - ? Use a structure for the Outbound Order data. Use two structure variables - 1 for WH and 1 for DC
     - maybe use a structure for customer too...
	  //str_Customer	lstr_Cust_DC, lstr_Cust_WH

	  
 * What about Notes / Remarks, etc (WH or DC outbound order?)?
 
 Put 2nd order in a 'Hold' status?
 
 Oct '09
  - Some DC's now operating as WH's.  
    * If the Ship-To is a DC-WH, Ship to its Local WH and Outbound from WH to DC-WH needs to be WH X-Fer (order type 'Z' instead of 'Y')
    * If the Ship-From is a DC-WH, 1st Order should be WH X-fer from DC-WH to Local WH
	  Sweeper should not create the receipt into local wh (WH X-fer will do that)
	  Sweeper should create the outbound from Local WH to Destination WH.
	   ?and put on 'Hold'?
	  and Outbound from Destination WH to final destination (if necessary)
	  
 - If Final Destination is in the same warehouse as the 'Local WH Location', then receive directly into the Final Location 
   - dts Jan '14, now also substituting if it's in the same WH Group (warehouse.UF3)
   (by using the Final Destination as either the Receiving Owner Id (if it's a receipt) or the Customer if it's a WH xfer (DC is operating as a WH)

 Mar '10
  - Need to put 2nd leg of Multi Stage on 'Hold' until 1st leg is confirmed.
    - (What about 4th leg?)

*/
Datastore	ldsDOHeader, ldsDODetail, lu_ds, ldsDOAddress, ldsDONotes, ldsDOBOM
				
String		lsLogout,lsRecData,lsTemp,	lswarehouse, lsErrText, lsSKU, lsRecType, &
				lsDate, ls_invoice_no, ls_Note_Type, ls_search, lsNotes, ls_temp, lsCommentDest,  &
				lsSoldToName, lsSoldToAddr1, lsSoldToAddr2, lsSoldToAddr3, lsSoldToAddr4, lsSoldToDistrict,	&
				lsSoldToZip, lsSoldToCity, lsSoldToState, lsSoldToCountry, lsNoteText, lsNoteType, lsAction ,lsAltSku, lsParentSKU,  lsSaveParentSku, lsParentQTY,lsChildSku, lsChildQTY, &
				lsfind, lssupplier, lsPrice, lsChildLine 
				

Integer		liFileNo,liRC, li_line_item_no, liSeparator, &
				liParentSkuStart, liParentSkuEnd, liParentQTYEnd, liChildSkuStart, liChildSkuEnd, liChildQTYStart, liChildQTYEnd, &
				liChildPriceStart, liChildPriceEnd, liChildLineStart, liChildLineEnd 
				
Long			llRowCount,	llRowPos,llNewRow, llNewDetailRow ,llOrderSeq,	llBatchSeq,	llLineSeq,llCount,		&
				llCONO, llRoNO, llLineItemNo, llOwner, llNewAddressRow, llNewNotesRow, llNoteSeq, llNoteLine, li_find, llchildQTY, llNewBOMRow, llOwnerId
				
Decimal		ldQty, ldPrice, ldChildPrice
				
DateTime	ldtToday, ldtScheduleDate
Date			ldtShipDate
Boolean		lbError, lbSoldToAddress,lbDoDeliveryBOM  
string 		lsInvoice, lsPrevInvoice, lsCustNum, lsPrevInvoice_Detail,  lsOrder
integer 		i, liBTAddr, liBOLNote
string			lsOwnerCD, lsOwnerCD_Prev, lsOwnerID, lsWH
string	         lsCustName, lsAddr1, lsAddr2, lsCity, lsState, lsZip, lsCountry, lsTel, lsCustType
string			lsBB, lsSFCustType, lsFromProject, lsToProject, lsSF_LocalWHLoc, lsRequestor, lsRemark, lsLine, lsQty, lsContainer,lsFromDetailLineProject 
//lsLocalWHDECOM, lsLocalWHRTV, lsLocalWHOSV, lsIntermediateOwner
long			llBatchSeqPO, llNewRowPO, llNewRowPODetail, llBatchSeqSO_2, llNewRowSO_2, llNewRowSODetail_2, llTempRow
long 			llBatchSeqSO_DCWH, llNewRowSO_DCWH, llNewRowSODetail_DCWH
string 		lsOwnerCd_DCWH, lsOwnerCd_DCWH_Prev, lsOwnerID_DCWH, lsWH_DCWH
boolean		lbNoOutbound
string			lsSTCust, lsSTCustType, lsST_LocalWHLoc, lsST_LocalWHLoc_Prev, lsOwnerID_2, lsWH_2, lsFinalOrigin, lsST_Group, lsProject_Hardcode 
integer		liStart, liEnd
string			lsSTCust_WH, lsSF_LocalWHLoc_WH, lsOwnerID_Final
datetime		ldtWHTime 
boolean		lbCrossDock
string			lsCrossDock_Loc

//TimA 08/04/11 Pandora #192
boolean		lbMorkOrder
//TimA 09/26/11 Pandora #287
Date  ldtRequestDatePlus3,ldtRequestDatePlus6
Date ldtRequestDatePlus7 //7 Days Warehouse Transfer Domestic Outbound
Date ldtRequestDatePlus9 //9 Warehouse Transfer International Outbound
Date ldtRequestDatePlus1 //1 Day Local Warouse
String lsCountyLocal, lsCountryShipTo
String lsHeader, lsDetail, lsOTM_Y_N, lsHeaderFromProject
//dts 1/19/14 - #692 - Associated Warehouse
string ls_SFWH_Assoc, ls_LocalWH_Assoc, ls_STWH_Assoc

//TimA 05/25/12 Pandora issue #425
is_WhCode = ''
is_Invoice = ''

//TimA 08/06/12 Pandora issue #440
String lsCurrentOTMStatus, lsCurrentOrdStatus

//TimA 11/16/12 Pandora #476 
Long n, llNLine,ll_found
String lsType,sVar

//TimA 01/30/13 Pandora issue #569 If action code is a 'U' then treat it as an add if the invoice does not exist
Long lsCountInv
//TimA 03/16/15
String lsInsertData,ls_Identifier, ls_IdList

datetime ldtCutoffDate //TAM 2017/04 
datetime ldtRDD //GWM 201709
String  lsdefaultTime//TAM 2017/04 
Date  ldt_Temp		//TAM 2017/04 

//GailM 08/08/2017 SIMSPEVS-537 - Identify MIM order - If not a MIM order, default to *all
String lsMIMOrder      = '*all'	
String lsCarrierAddr1 =  '*all'		//From CarrierMaster Address_1 (Expeditor, UPS, etc.
String lsCust              =  '*all'		
String lsMessage

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
ldsDOAddress.dataobject = 'd_mercator_do_address' //Delivery_Alt_Address
ldsDOAddress.SetTransObject(SQLCA)

ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes'
ldsDONotes.SetTransObject(SQLCA)

ldsDOBOM = Create u_ds_datastore
ldsDOBOM.dataobject = 'd_delivery_bom'
ldsDOBOM.SetTransObject(SQLCA)

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

If Not isvalid(idsRONotes) Then
	idsRONotes = Create u_ds_datastore
	idsRONotes.dataobject = 'd_mercator_ro_notes'
	idsRONotes.SetTransObject(SQLCA)
End If

idsPoheader.Reset()
idsPODetail.Reset()
idsRONotes.Reset()

//Open the File
lsLogOut = '      - Opening File for Pandora Material Transfer (Sales Order) Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath, LineMode!, Read!, LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for PANDORA Material Transfer Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
//TimA 03/17/15 Changed to read Unicode because of the special characters that maybe in the file.
ls_idList = "DM, DN,DD, SN"
liRC = FileReadEx(liFileNo, lsRecData)
//liRC = FileRead(liFileNo, lsRecData)
ls_Identifier = Left(lsRecData,(pos(lsRecData,'|') - 1))
If pos(ls_idList,ls_Identifier,1)= 0 Then
	Return -1
End if
lsInsertData = lsRecData

Do While liRC > 0 //-100 is EOF

	llNewRow = lu_ds.InsertRow(0)
	liRC = FileReadEx(liFileNo,lsRecData) //Read the next record.  If liRC = 0 then it hit a CR or LF
	ls_Identifier = Left(lsRecData,(pos(lsRecData,'|') - 1)) //Grab the first 2 characters
	Do while pos(ls_idList,ls_Identifier,1)= 0 and liRC >= 0 //Continue onto the next records until it hit a good record.
		lsInsertData = lsInsertData + space(1) + lsRecData
		liRC = FileReadEx(liFileNo,lsRecData)
		ls_Identifier = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Loop
	lu_ds.SetItem(llNewRow, 'rec_data', lsInsertData) //Now insert all the concatinated record.
	lsInsertData = lsRecData

	//lu_ds.SetItem(llNewRow, 'rec_data', lsRecData) /*record data is the rest*/
	//TimA 03/17/15 Changed to read Unicode because of the special characters that maybe in the file.
//	liRC = FileReadEx(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

//Get the next available file sequence number
// 03/09 llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Outbound_Header', 'EDI_Batch_Seq_No')
// 03/09 -  using edi_INbound_header because web does and it will crash when trying to re-use a sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = lu_ds.RowCount()

/* DECOM/RMA - See if this is a multi-stop order requiring a receipt into a warehouse first.
     - we need to scroll through the records until we find a detail, then check the owner (ship-from) to see if it's a DC
	  * Oct '09 - Now Ship-From DC may be acting as WH so need to create preliminary WH xfer instead of a receipt (so need to find out if it has a Local WH)
	 - Supposed to be just a single Order in the file. 
	3/09/10 - Setting 2nd Order in Leg to 'Hold' (what about potential 4th Order - destination WH to Destination DC/Cust?) 
	 */
	 
//TimA 05/24/13 Pandora issue #606
If gs_OTM_Flag = 'Y' then 
	lsOTM_Y_N = 'Y'  //Default to Yes (Y) sent to OTM
	//Lookup to see if the RTV-RMA is to be using in the Header or Detail sections.
	select User_Updateable_Ind
	into :lsHeader
	from lookup_table
	where project_id = 'PANDORA'
	and code_type = 'OTM'
	and code_id = 'HEADER'
	and Code_Descript = 'RTV-RMA';
	
	select User_Updateable_Ind
	into :lsDetail
	from lookup_table
	where project_id = 'PANDORA'
	and code_type = 'OTM'
	and code_id = 'DETAIL'
	and Code_Descript = 'RTV-RMA';
End if

For llRowPos = 1 to llRowCount
	lsRecData = Trim(lu_ds.GetItemString(llRowPos, 'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	Choose Case lsRecType
		Case 'DM' /* Header */
			//Customer: 5th field in DM record
			i = 1
			liStart = 1
			do while i < 5
				liStart = pos(lsRecData, '|', liStart) +1
				i += 1
			loop
			liEnd = pos(lsRecData, '|', liStart)
			lsSTCust = Mid(lsRecData, liStart, liEnd - liStart)
			
			//TimA Pandora issue #606 grab the From project in the header record
			i = 1
			liStart = 1
			do while i < 32
				liStart = pos(lsRecData, '|', liStart) +1
				i += 1
			loop
			liEnd = pos(lsRecData, '|', liStart)
			lsHeaderFromProject = Mid(lsRecData, liStart, liEnd - liStart) //Get the To Project
			If lsHeaderFromProject = 'RTV-RMA' and lsHeader = 'Y' then
				lsOTM_Y_N = 'N'
			End if
			
			/* 07/22/09 - Now Need to look up Ship-To Customer type to see if it is a DC...
			    ( then use UF4 to find local WH sub-inventory location owner) 
				
			 **08/10/09 - now we want to ship to some customers via a different WH
				- using UF4 to turn on this functionality, instead of Customer Type. If there's data in UF4....
			 * 08/20/09 - now grabbing UF1 to test group (DECOM and RMA have different rules) 
			 * 10/09/09 - now grabbing UF2 - need ST Customer's WH (if final destination is a WH Sub-Inventory Loc) */
			//select customer_type, user_field4, user_field1 into :lsSTCustType, :lsST_LocalWHLoc, :lsST_Group
//			where project_id = 'PANDORA' 
			select customer_type, user_field4, user_field1, user_field2 into :lsSTCustType, :lsST_LocalWHLoc, :lsST_Group, :lsSTCust_WH
			from customer
// TAM 2017/09 - SIMSPEVS - 816 - If Customer Type = "INACTIVE" then it is invalid
//			where project_id = 'PANDORA' 
			where project_id = 'PANDORA' and customer_type <> 'IN'
			and cust_code = :lsSTCust;
			
			// - Throw error message if Customer is not in Customer_Master
			if isnull(lsSTCustType) or lsSTCustType = '' then
				lbError = True
				gu_nvo_process_files.uf_writeError("Invalid Customer Code specified (" + lsSTCust +")! Record will not be processed.")
			end if

			//if lsSTCustType = 'DC' then
			if lsST_LocalWHLoc > '' then
//Only need to create 2nd order if Ship-To's Local WH is not the Ship-From WH-Loc...
// - what if it's in the same building??? Per Ian, only a single order (Pandora doesn't want the owner change)
//    - now receiving into the Final Destination, not the 'Local WH Location' (if it's in the same building)
// - What if it's changing PROJECT???

				//Get the next available file sequence number for the 2nd Outbound Order (from Destination WH to Destination DC)
	//			llBatchSeqSO_2 = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
	//			If llBatchSeqSO_2 <= 0 Then Return -1

				// - Throw error message if lsST_LocalWHLoc is not populated (and a valid owner?)
				//obsolete if isnull(lsST_LocalWHLoc) or lsST_LocalWHLoc = '' then
				//				lbError = True
				//				gu_nvo_process_files.uf_writeError("Ship-to DC Location '" + lsSTCust + "' does not have the associated WH Location set up in Customer Maintenance. Record will not be processed.")
				//			  end if
				
				//below, we'll compare Ship-To and IntermediateOwner. If the same, we won't create OUTBOUND order
				
			end if
		Case 'DD' /*Detail */
			//TimA 05/31/13 Pandora issue #606 look at the From Project on the detail line also
			i = 1
			liStart = 1
			do while i < 10
				liStart = pos(lsRecData, '|', liStart) + 1
				i += 1
			loop
			liEnd = pos(lsRecData, '|', liStart)
			lsFromDetailLineProject = Mid(lsRecData, liStart, liEnd - liStart)
			If lsFromDetailLineProject = 'RTV-RMA' and lsDetail = 'Y' then
				lsOTM_Y_N = 'N'
			End if		
			
			//Sub-Inv (Owner): 11th field in DD record
			//TO Project: 16th field in DD record
			i = 1
			liStart = 1
			do while i < 11
				liStart = pos(lsRecData, '|', liStart) + 1
				i += 1
			loop
			liEnd = pos(lsRecData, '|', liStart)
			lsOwnerCd = Mid(lsRecData, liStart, liEnd - liStart)
			/*Need to look up Owner's customer type to see if it is a DC...
			    (UF4 is the local WH's owner) */

			/* 07/14/09 - now assuming only a SINGLE Local WH Loc for any single DC Loc! */
//			select customer_type, user_field4, user_field5, user_field6 into :lsSFCustType, :lsLocalWHDECOM, :lsLocalWHRTV, :lsLocalWHOSV
			//TimA 11/08/11 Pandora issue #287 grab the country of the local WH
			select customer_type, user_field4, Country into :lsSFCustType, :lsSF_LocalWHLoc, :lsCountyLocal
			from customer
			where project_id = 'PANDORA'
			and cust_code = :lsOwnerCD;

//TAM - 3/18 - S13945 -  For Pandora, Don't allow "INACTIVE" from_location(UF6) -Start
			// - Throw error message if Customer is Inactive
			if  lsSFCustType = 'IN' then
				lbError = True
				gu_nvo_process_files.uf_writeError("Invalid Customer Code specified (" + lsOwnerCD +")! Record will not be processed.")
			end if
//TAM - 3/18 - S13945 -  For Pandora, Don't allow "INACTIVE" from_location(UF6) -End

			if lsSF_LocalWHLoc > '' then
				//10/09 - need the actual WH for lsSF_LocalWHLoc
				//TimA 11/08/11 Pandora issue #287 grab the country of the local WH				
				select user_field2, Country into :lsSF_LocalWHLoc_wh, :lsCountyLocal
				from customer
				where project_id = 'PANDORA'
				and cust_code = :lsSF_LocalWHLoc;
			end if

			//dts 1/19/14 - 692 - now checking if warehouses are in the same 'Association' (Warehouse.UF3)
			//if they are in the same 'Association', then don't need to receive into the Local WH and then ship to Final destination. Instead, receive straight to the final WH.
			//get Association of the Ship-to WH...
			select user_field3 into :ls_STWH_Assoc from Warehouse
			where WH_Code = :lsSTCust_WH;
			
			//get the Association of the 'Local' WH...
			select user_field3 into :ls_LocalWH_Assoc from Warehouse
			where WH_Code = :lsSF_LocalWHLoc_WH;
			
			//if ls_STWH_Assoc = ls_LocalWH_Assoc then
			//dts 3/31/14 - need to make sure they aren't both '', thus triggering this logic. (Not sure why this is a problem all of the sudden)
			if ls_STWH_Assoc = ls_LocalWH_Assoc and ls_STWH_Assoc <> '' then
				//don't need the 1st movement (to the 'Local' WH), and need to set the 'Local' location to the Associated Location (in the warehouse of the same Association)
				lsSF_LocalWHLoc_WH = lsSTCust_WH
				lsSF_LocalWHLoc = lsSTCust
			end if

			//if this is shipping to a DC, compare the Ship-To DC's Local WH Loc to the Ship-From Owner...
			//If the origin is a DC, we need to check against the Ship-From DC's Local WH Loc, not the ship-from loc
			//if lsSTCustType = 'DC' then  //now shipping to some customers via a 'local wh'
			if lsST_LocalWHLoc > '' then
				// - What if it's changing PROJECT???
				// 10/09 if lsSFCustType = 'DC' then 
				/*now DC's Cust Type may be WH (DC operating as a WH)
				    - need to check lsSF_LocalWHLoc instead  */
				if lsSF_LocalWHLoc > '' then 
					lsFinalOrigin = lsSF_LocalWHLoc
				else
					lsFinalOrigin = lsOwnerCD
				end if
				if lsFinalOrigin <> lsST_LocalWHLoc then
					// - If it's in the same building... Per Ian, only a single order (Pandora doesn't want the owner change 1st)
					//Check the warehouse for both the Ship-From(lsOwnerCd) and the Intermediate (lsST_LocalWHLoc)....
					
					select user_field2 into :lsWH from customer where project_id = 'PANDORA'
					and cust_code = :lsFinalOrigin;
					if isnull(lsWH) or lsWH = '' then
						lbError = True
						gu_nvo_process_files.uf_writeError("Sub-Inventory Location '" + NoNull(lsFinalOrigin) + "' does not have an associated WH specified in Customer Maintenance. Record will not be processed.")
						//ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
					end if
			
				// need to grab uf10 to check to see if Project hard-code is in effect (for HWOPS, but open to anyone with data in uf10)
				//TEMPO!! Customer-Project fix (need to un-do the customer project rule. look for lsProject_Hardcode...)
				// - 3/10/10 - setting lsProject_Hardcode to '' in order to ignore customer-project setting (as test) for electronic orders
					select user_field2, user_field10 into :lsWH_2, :lsProject_Hardcode from customer 	where project_id = 'PANDORA'
					and cust_code = :lsST_LocalWHLoc;
					
					lsProject_Hardcode = '' //TODO - ignoring customer-project but 
					if isnull(lsWH_2) or lsWH_2 = '' then
						lbError = True
						gu_nvo_process_files.uf_writeError("Local WH Location '" + NoNull(lsST_LocalWHLoc) + "' does not have an associated WH specified in Customer Maintenance. Record will not be processed.")
					end if
				end if // lsFinalOrigin <> lsST_LocalWHLoc 
				
				if lsWH <> lsWH_2 then
					//dts 1/19/14 - 692 - now checking if warehouses are in the same 'Group' (Warehouse.UF3, for now, though that may be used in baseline putaway so need to investigate)
					//if they are in the same 'Group', then don't need to ship to the Local WH and instead can go straight to the DC.
					//get group of the Ship-from WH...
					select user_field3 into :ls_SFWH_Assoc from Warehouse
					where WH_Code = :lsWH;

					//get the group of the 'Local' WH...
					select user_field3 into :ls_LocalWH_Assoc from Warehouse
					where WH_Code = :lsWH_2;
					
					if ls_SFWH_Assoc = ls_LocalWH_Assoc then
						//don't need the 2nd movement, and need to set the 'Local' location to the Associated Location (in the warehouse of the same Group)
						lsWH_2 = lsWH
						lsST_LocalWHLoc = lsOwnerCD
					else
						//Get the next available file sequence number for the 2nd Outbound Order (from Destination WH to Destination DC)
						llBatchSeqSO_2 = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
						If llBatchSeqSO_2 <= 0 Then Return -1
					end if
				end if
			end if  //lsST_LocalWHLoc > ''

			// now get project....
			liStart = liEnd + 1
			i += 1
			do while i < 16
				liStart = pos(lsRecData, '|', liStart) + 1
				i += 1
			loop
			liEnd = pos(lsRecData, '|', liStart)
//TEMPO! - why are we setting this here
			lsToProject = Mid(lsRecData, liStart, liEnd - liStart)
			
			//TimA 05/24/13 Pandora issue #606
			If lsToProject = 'RTV-RMA' and lsDetail = 'Y' then
				lsOTM_Y_N = 'N'
			End if			
			if lsST_LocalWHLoc > '' then
//TEMPO!				if lsProject_Hardcode > '' then
//					lsToProject_Intermediate = lsProject_Hardcode 
//				end if
			end if			

			// 10/09 if lsSFCustType = 'DC' then 
			/*now DC's Cust Type may be WH (DC operating as a WH)
				 - need to check lsSF_LocalWHLoc instead  */
			if lsSF_LocalWHLoc > '' then 
				/* - Make sure we can count on 'DECOM' for Project on DECOM orders
					 - ...nope. now, per Pandora, a DC Loc is only mapped to a single WH Loc! */
					/*
					if lsToProject = 'RTV' then
						lsIntermediateOwner = lsLocalWHRTV
					elseif lsToProject = 'OSV' then
						lsIntermediateOwner = lsLocalWHOSV
					else
						lsIntermediateOwner = lsLocalWHDECOM
					end if
					*/	
				//lsIntermediateOwner = lsSF_LocalWHLoc

				if lsSFCustType = 'DC' Then
					// need to create receipt into local WH
					//Get the next available file sequence number for the Inbound
					llBatchSeqPO = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
					If llBatchSeqPO <= 0 Then Return -1
				else //lsSFCustType = 'WH' 
					// need to create wh xfer from DCWH to WH
					//Get the next available file sequence number for the WH xfer from the DCWH to local WH
					llBatchSeqSO_DCWH = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
					If llBatchSeqSO_DCWH <= 0 Then Return -1
				end if

				// - Throw error message if lsIntermediateOwner is not populated (and a valid owner?)
				//Obsolete if isnull(lsSF_LocalWHLoc) or lsSF_LocalWHLoc = '' then
				//				lbError = True
				//				gu_nvo_process_files.uf_writeError("Ship-From DC Location '" + lsOwnerCD + "' does not have the associated WH Location set up in Customer Maintenance. Record will not be processed.")
				//				//ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				//			   end if
				
				//below, we'll compare Ship-To and IntermediateOwner. If the same, we won't create OUTBOUND order
			end if
			//llRowPos = llRowCount // no need to keep scrolling through records...			
	End Choose /*Header, Detail or Notes */	
Next /*file record */
/*for DECOM / RMA, we need to compare the Customer to the Intermediate WH
	- if it's the same, don't create the outbound order 
	- if it's a DC, we need to find the local WH and create a WH transfer and an outbound order to DC */


//Process each Row
For llRowPos = 1 to llRowCount
	//lsRecData = lu_ds.GetItemString(llRowPos, 'rec_data')
	lsRecData = Trim(lu_ds.GetItemString(llRowPos, 'rec_Data'))
		
	//Process header, Detail (sika..., or header/line notes) */
	//lsRecType = Upper(Mid(lsRecData,7,2))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	

	Choose Case lsRecType
		//HEADER RECORD
		Case 'DM' /* Header */
			llNewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			lbSoldToAddress = False

		//Record Defaults
			ldsDOHeader.SetItem(llNewRow, 'Action_cd', 'A') /*always a new Order*/
			ldsDOHeader.SetItem(llNewRow, 'project_id', asProject) /*Project ID*/
			ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow, 'ftp_file_name', aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow, 'Status_cd', 'N')
			
			ldsDOHeader.SetItem(llNewRowSO_2, 'ord_status', 'H') //Order is on 'Hold' until WH x-fer is received.
				
			ldsDOHeader.SetItem(llNewRow, 'order_Type', 'S') /*default to SALE. we'll set it to 'Z' later if appropriate */
			ldsDOHeader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
			//TimA Pandora issue #606
			ldsDOHeader.SetItem(llNewRow, 'OTM_Y_N', lsOTM_Y_N) 
			
			/*notes		OSV (on site verification) --> RMA inv type (on outbound)
							if MRB, should be no Outbound( Ship-to should be the Local WH)
							
							receive all of these as MRB inventory type (non-pickable)
							ops will do an adjustment to a pickable inv type based on pandora disposition
			
			Need to set Order Type and Inventory Type based on Project
			All Inbounds among RTV, RTC, OSV, MRB, DECOM, SCRAP are Order 'Y - Intermediate Receipt' and 'M - MRB'
			Project	OrderType					InvType
			--------	----------------------		----------
			RTV 		X - ReturnToSupplier		R - RTV
			DECOM 	S - Sale						?Rework, S - Scrap
			MRB 		No outbound Order
			OSV 		Z - WHxFer					A - RMA
			
			10/05/09
			RTV - RMA
			MRB - MRB
			OSV - Cross Dock
			SCRAP
			DECOM
			
			--CROSS DOCK! Can we dedicate a cross-dock location to cross dock inventory type?
			
			can we pick non-pickable inventory if specified

			10/14/09 - new RMA Rules:
			Project Code: RTV-IN	SIMS - Inv Type	SIMS - Order type
			Inbound: DC - Local WH	RTV	Receipt from DC
			Outbound: Local WH - Vendor	RTV	Return to supplier
			Inbound: Return Replacements from Vendor	RMA	Return from Supplier
					
			Project Code: RTV-OUT	SIMS - Inv Type	SIMS - Order type
			Inbound: DC - Local WH	RTV	Receipt from DC
			Outbound: Local WH - Vendor	RTV	Return to supplier
			Inbound: Return Replacements from Vendor	RMA	Return from Supplier
					
			Project Code : OSV	SIMS - Inv Type	SIMS - Order type
			Inbound: DC - Local WH	Normal	Receipt from DC
			Outbound: Local WH - Atlanta DC (HUB)	Normal	Sale
					
			Project Code : SCRAP	SIMS - Inv Type	SIMS - Order type
			Inbound: DC - Local WH	Scrap	Receipt from DC
			(Atlanta being the HUB, scrap material stops in the local WH) 		
					
			Project Code:  Decom	SIMS - Inv Type	SIMS - Order type
			Inbound: DC - Local WH	Normal	Receipt from DC
			(Atlanta being the HUB, Decom material stops in the local WH) 		
					
			Project Code:  MRB	SIMS - Inv Type	SIMS - Order type
			Inbound: DC - Local WH	MRB	Receipt from DC
			SOC	Normal	
			Outbound:  RTV disposition	RTV	Return to supplier
			Outbound: OSV disposition	Normal	Sale
					
			Scrap and Decom will be a 4C1 transaction as the material will move from local WH MRB location to Local WH Scrap or Decom location (Inv Type=Normal)		

			*/
			if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
			//RTV, OSV, MRB are exclusive to RMA project, DECOM and SCRAP are not!
				//11/03/09 if lsToProject = 'RTV-IN' or lsToProject = 'RTV-OUT' then  //RTV, RTC, OSV, MRB, DECOM, SCRAP, 
				if lsToProject = 'RTV-RMA' or lsToProject = 'RTV-PO' then  //RTV, RTC, OSV, MRB, DECOM, SCRAP, 
					//ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'R') /*Return - RTV*/
					ldsDOHeader.SetItem(llNewRow, 'Order_Type', 'X') 
				elseif lsToProject = 'OSV' then
					ldsDOHeader.SetItem(llNewRow, 'Order_Type', 'S') 
// ET3 2012-12-06 Pandora 545 - no longer track by MRB inventory type
//				elseif lsToProject = 'MRB' then
//					/*										InvType	Order Type
//					  Outbound: RTV disposition	RTV - R	Return to supplier - X
//					  Outbound: OSV disposition	Normal	Sale							*/
//					//11/11 ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'S') /*DECOM*/
//					//11/11 ldsDOHeader.SetItem(llNewRow, 'Order_Type', 'S') 
				else
					//11/11 ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
				end if
			end if
						
			//if lsSTCustType = 'DC' then
			if llBatchSeqSO_2 > 0 then				 
				/* DECOM / RMA, Multi-Stage shipment.
				  - if Ship-To is a DC, we need to ship first to the Associated WH, then to the DC
					 (so we're creating two outbound orders) */
				llNewRowSO_2 = ldsDOHeader.InsertRow(0)
				//llOrderSeq ++
				//llLineSeq = 0
	
				//Record Defaults
				ldsDOHeader.SetItem(llNewRowSO_2, 'Action_cd', 'A') /*always a new Order*/
				ldsDOHeader.SetItem(llNewRowSO_2, 'project_id', asProject) /*Project ID*/
				// 10/01/09 - Some DC's now operating as WH's so need to create WH X-fer...
				if lsSTCustType = 'WH' then
					ldsDOHeader.SetItem(llNewRowSO_2, 'order_Type', 'Z') /* WH X-fer */
				else
					ldsDOHeader.SetItem(llNewRowSO_2, 'order_Type', 'Y') /* new order type for Multi-stage shipments */
				end if

//				if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
//					if lsToProject = 'RTV' then //RTV, RTC, OSV, MRB, DECOM, SCRAP, 
//						ldsDOHeader.SetItem(llNewRowSO_2, 'Inventory_Type', 'R') /*Return - RTV*/
//						ldsDOHeader.SetItem(llNewRowSO_2, 'Order_Type', 'X') 
//					//elseif lsToProject = 'RTC' then
//					//	ldsDOHeader.SetItem(llNewRowSO_2, 'Inventory_Type', 'C') /*Return - RTC*/
//					//	ldsDOHeader.SetItem(llNewRowSO_2, 'Order_Type', 'X') 
//					elseif lsToProject = 'OSV' then
//						ldsDOHeader.SetItem(llNewRowSO_2, 'Inventory_Type', 'A') /*DECOM*/
//						ldsDOHeader.SetItem(llNewRowSO_2, 'Order_Type', 'Z') 
//					elseif lsToProject = 'DECOM' then
//						ldsDOHeader.SetItem(llNewRowSO_2, 'Inventory_Type', 'S') /*DECOM*/
//						ldsDOHeader.SetItem(llNewRowSO_2, 'Order_Type', 'S') 
//					else
//						ldsDOHeader.SetItem(llNewRowSO_2, 'Inventory_Type', 'N') /*default to Normal*/
//					end if
//				else
//					ldsDOHeader.SetItem(llNewRowSO_2, 'Inventory_Type', 'N') /*default to Normal*/
//				end if

/*TODO - will we have a 2nd Outbound order for RMA????
				if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
				//RTV, OSV, MRB are exclusive to RMA project, DECOM and SCRAP are not!
					if lsToProject = 'RTV-IN' or lsToProject = 'RTV-OUT' then  //RTV, RTC, OSV, MRB, DECOM, SCRAP, 
						ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'R') /*Return - RTV*/
						ldsDOHeader.SetItem(llNewRow, 'Order_Type', 'X') 
					//elseif lsToProject = 'RTC' then
					//	ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'C') /*Return - RTC*/
					//	ldsDOHeader.SetItem(llNewRow, 'Order_Type', 'X') 
					elseif lsToProject = 'OSV' then
						ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') 
						ldsDOHeader.SetItem(llNewRow, 'Order_Type', 'S') 
					//elseif lsToProject = 'SCRAP' then
					//	ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'S') /*DECOM*/
					//	ldsDOHeader.SetItem(llNewRow, 'Order_Type', 'S') 
					//elseif lsToProject = 'DECOM' then
					//	ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'S') /*DECOM*/
					//	ldsDOHeader.SetItem(llNewRow, 'Order_Type', 'S') 
// ET3 2012-12-06 Pandora 545 - no longer track by MRB inventory type
//					elseif lsToProject = 'MRB' then
//						//										InvType	Order Type
//						//Outbound: RTV disposition	RTV - R	Return to supplier - X
//						//Outbound: OSV disposition	Normal	Sale
//						ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'S') /*DECOM*/
//						ldsDOHeader.SetItem(llNewRow, 'Order_Type', 'S') 
					else
						ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
					end if
				end if			*/
				
				ldsDOHeader.SetItem(llNewRowSO_2, 'edi_batch_seq_no', llBatchSeqSO_2) /*batch seq No*/ //????? why was this llNewRowSO_2 for the value????
				ldsDOHeader.SetItem(llNewRowSO_2, 'order_seq_no', 1)  // always one order in file...
				ldsDOHeader.SetItem(llNewRowSO_2, 'ftp_file_name', aspath) /*FTP File Name*/
				ldsDOHeader.SetItem(llNewRowSO_2, 'Status_cd', 'N') //Order is on 'Hold' until WH x-fer is received.

				If gs_OTM_Flag = 'Y' then 
					//TimA 05/01/12 Pandora This is just a temporary place holder for multi stage orders.
					//This is changed in u_nvo_process_files/uf_process_delivery_order
					ldsDOHeader.SetItem(llNewRowSO_2, 'ord_status', 'M') //
				Else
					ldsDOHeader.SetItem(llNewRowSO_2, 'ord_status', 'H') //Order is on 'Hold' until WH x-fer is received.
				End if
				
				ldsDOHeader.SetItem(llNewRowSO_2, 'Last_user', 'SIMSEDI')
			end if
			
			// 10/01/09 - DC's may be operating as WH. For DCWH, need to start movement with a WH x-fer from DCWH to WH
			if llBatchSeqSO_DCWH > 0 then
				llNewRowSO_DCWH = ldsDOHeader.InsertRow(0)
	
				//Record Defaults
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Action_cd', 'A') /*always a new Order*/
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'project_id', asProject) /*Project ID*/
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'order_Type', 'Z') /* WH X-fer */
//				if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
//					if lsToProject = 'RTV' then //RTV, RTC, OSV, MRB, DECOM, SCRAP, 
//						ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Inventory_Type', 'R') /*Return - RTV*/
//						ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Order_Type', 'X') 
//					elseif lsToProject = 'OSV' then
//						ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Inventory_Type', 'A') /*DECOM*/
//						ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Order_Type', 'Z') 
//					elseif lsToProject = 'DECOM' then
//						ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Inventory_Type', 'S') /*DECOM*/
//						ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Order_Type', 'S') 
//					else
//						ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Inventory_Type', 'N') /*default to Normal*/
//					end if
//				else
//					ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Inventory_Type', 'N') /*default to Normal*/
//				end if

				if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
				//RTV, OSV, MRB are exclusive to RMA project, DECOM and SCRAP are not!
					//11/03/09 if lsToProject = 'RTV-IN' or lsToProject = 'RTV-OUT' then  //RTV, RTC, OSV, MRB, DECOM, SCRAP, 
					if lsToProject = 'RTV-RMA' or lsToProject = 'RTV-PO' then  //RTV, RTC, OSV, MRB, DECOM, SCRAP, 
						//ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Inventory_Type', 'R') /*Return - RTV*/
						ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Order_Type', 'X') 
					elseif lsToProject = 'OSV' then
						ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Order_Type', 'S') 
// ET3 2012-12-06 Pandora 545 - no longer track by MRB inventory type
//					elseif lsToProject = 'MRB' then
//						/*										InvType	Order Type
//						  Outbound: RTV disposition	RTV - R	Return to supplier - X
//						  Outbound: OSV disposition	Normal	Sale							*/
//						//11/11 ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Inventory_Type', 'S') /*DECOM*/
//						//11/11 ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Order_Type', 'S') 
					else
						//11/11 ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Inventory_Type', 'N') /*default to Normal*/
					end if
				end if
				
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'edi_batch_seq_no', llBatchSeqSO_DCWH) /*batch seq No*/ //????? why was this llNewRowSO_2 for the value????
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'order_seq_no', 1)  // always one order in file...
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'ftp_file_name', aspath) /*FTP File Name*/
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Status_cd', 'N') //Order is on 'Hold' until WH x-fer is received.
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Last_user', 'SIMSEDI')
				
				//TimA 03/28/12 OTM Project				
				If gs_OTM_Flag = 'Y' then 
					//This is just a temporary place holder for multi stage orders.
					//In u_nvo_process_file/uf_process_delivery_order we will look for the "M" on shuttle type orders then set the order status there.
					ldsDOHeader.SetItem(llNewRow, 'ord_status', 'M') 									
				Else				
					// 3/09/10 - need to put 2nd leg on Hold...
					ldsDOHeader.SetItem(llNewRow, 'ord_status', 'H') //Order is on 'Hold' until WH x-fer is received.
				end if
			end if // llBatchSeqSO_DCWH > 0 (shipment starts from a DCWH)
		
		
		//From File			
//			ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
					
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
//  Change ID 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Action Code' field. Record will not be processed.")
			End If

			lsAction = lsTemp
			ldsDOHeader.SetItem(llNewRow, 'Action_cd', lsTemp)
			ldsDOHeader.SetItem(llNewRowSO_2, 'Action_cd', lsTemp)
			ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Action_cd', lsTemp)

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Delivery_Number
			//Material Transfer Number - mapped to Invoice
			If Pos(lsRecData,'|') > 0 Then
				lsInvoice = trim(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Material Transfer Number. Record will not be processed.")
			End If
			//**********************************
			//TimA 01/30/13 Pandora issue #569
			//If the files has an action type of 'U' for update check to see if the order aready exist.  If no, then treat the order as an add 'A'
			If lsAction = 'U' then
				Select  Count(1) into :lsCountInv
				From Delivery_master
				Where project_ID = :asproject and Invoice_No = :lsInvoice and Ord_Status <> 'V';
				If lsCountInv = 0 Then //No order found.  Change to 'A'
					lsAction = 'A'
					ldsDOHeader.SetItem(llNewRow, 'Action_cd', lsAction)
					ldsDOHeader.SetItem(llNewRowSO_2, 'Action_cd', lsAction)
					ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Action_cd', lsAction)					
				End if
			End if
			
			ldsDOHeader.SetItem(llNewRow, 'Invoice_no', lsInvoice)
			// appending a '_2' for now (so not rejected when trying to 'Add')
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'Invoice_no', lsInvoice + '_2') 
			// If movement starts from a DCWH, appending a '_DCWH' to invoice_no
			if llNewRowSO_DCWH > 0 then ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Invoice_no', lsInvoice + '_DCWH') 
			
			// dts 2010/08/12 - need to direct putaway to cross-dock location if order is a crossdock order
			//if left(lsInvoice, 4) = 'CMOR' or left(lsInvoice, 4) = 'FMOR' then
			// LTK 20110218 Enhancement #166:  Added 'CMTR' and 'FMTR' 				
			if left(lsInvoice, 4) = 'CMOR' or left(lsInvoice, 4) = 'FMOR' or left(lsInvoice, 4) = 'CMTR' or left(lsInvoice, 4) = 'FMTR' then
				lbCrossDock = True
				ldsDOheader.SetItem(llNewRow, 'Crossdock_ind', 'Y')
			end if
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsInvoice) + 1))) /*strip off to next Column */

			If lsAction = 'U' Then  //IF the Action is "U"pdate We need to issue a delete and then an Add for the entire order
			//TODO!!! - what about Updates to the multi-stage orders???
				Select wh_Code, Client_Cust_PO_Nbr into :lsWarehouse, :lsMIMOrder
				From Delivery_master
				Where project_ID = :asproject and Invoice_No = :lsInvoice;
	
				If lsWarehouse = "" Then
					lbError = True
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse: '" + lsTemp + "'. Order will not be processed.") 
				End If
				
				Select  ord_status,OTM_Status into :lsCurrentOrdStatus, :lsCurrentOTMStatus
				From Delivery_master
				Where project_ID = :asproject and Invoice_No = :lsInvoice and Ord_Status <> 'V';

				//TimA 08/10/12 Pandora issue #440
				//This order was in "New" status and "Ready" OTM Status we don't want to send an OTM delete which is handled in uf_process_delivery_order
				//Set the OTM status to 'Q'.  This is just a flag so that we can capture the results in uf_process_delivery_order
				If lsCurrentOrdStatus = 'N' and lsCurrentOTMStatus = 'R' then
					ldsDOHeader.SetItem(llNewRow, 'OTM_Status', 'Q')
				End if

				ldsDOheader.SetItem(llNewRow,'wh_Code',lsWarehouse)
				// 4/2010 - now setting ord_date to local wh time
				ldtWHTime = f_getLocalWorldTime(lsWarehouse)
				ldsDOheader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))

				//GailM 0712/2017 SIMSPEVS-728 Defect: Current ESD logic does not include Weekend cutoff date
				If Left(lsMIMOrder,1) = 'X' Then lsMIMOrder = 'Yes'
				ldtScheduleDate = f_delivery_advance_esd_configuration(lsWH,ldtWHTime, ldtRDD, lsMIMOrder, lsCarrierAddr1, lsSTCust )				
				ldsDOheader.setitem(llNewRow,'schedule_date',string(ldtScheduleDate, 'mm-dd-yyyy hh:mm'))

				ldsDOHeader.SetItem(llNewRow, 'Action_cd', 'D') /*Delete */
				
				lsAction = 'A'
				//Get the next available file sequence number
				llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
				If llBatchSeq <= 0 Then Return -1

				llOrderSeq = 0 /*order seq within file*/

				llNewRow = ldsDOHeader.InsertRow(0)
				llOrderSeq ++
				llLineSeq = 0
				lbSoldToAddress = False

				//Record Defaults
				ldsDOHeader.SetItem(llNewRow, 'Action_cd', 'A') /*always a new Order*/
				ldsDOHeader.SetITem(llNewRow, 'project_id', asProject) /*Project ID*/
				ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
				ldsDOHeader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
				ldsDOHeader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
				ldsDOHeader.SetItem(llNewRow, 'ftp_file_name', aspath) /*FTP File Name*/
				ldsDOHeader.SetItem(llNewRow, 'Status_cd', 'N')
				ldsDOHeader.SetItem(llNewRow, 'order_Type', 'S') /*default to SALE. we'll set it to 'Z' later if appropriate */
				ldsDOHeader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
				
				//TimA 08/06/12 Pandora issue #440 the order is in "New" status on OTM "Ready" status
				If lsCurrentOrdStatus = 'N' and lsCurrentOTMStatus = 'R' then
					ldsDOHeader.SetItem(llNewRow, 'OTM_Status', 'Q')				
				End if				
				ldsDOHeader.SetItem(llNewRow, 'Invoice_no', lsInvoice)
				ldsDOheader.SetItem(llNewRow,'wh_Code',lsWarehouse) //?
				// 4/2010 - now setting ord_date to local wh time
				ldtWHTime = f_getLocalWorldTime(lsWarehouse)
				ldsDOheader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))

				//GailM 0712/2017 SIMSPEVS-728 Defect: Current ESD logic does not include Weekend cutoff date
				ldtScheduleDate = f_delivery_advance_esd_configuration(lsWH,ldtWHTime, ldtRDD, lsMIMOrder, lsCarrierAddr1, lsSTCust  )				
				ldsDOheader.setitem(llNewRow,'schedule_date',string(ldtScheduleDate, 'mm-dd-yyyy hh:mm'))

			End If //lsAction = 'U' 

//  Request Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'To' Location. Record will not be processed.")
			End If
			lsDate = Mid(lsTemp, 5, 2 ) + '/' + Mid(lsTemp,7, 2 ) + '/' + Left(lsTemp, 4 )
			ldsDOHeader.SetItem(llNewRow, 'Request_Date', lsDate) 
			
			//GailM 08/08/2017 SIMSPEVS-537 - SIMS to provide advance ESD cutoff configuration use ldtRDD for Reqd Request Date RDD
			Date ldRDD
			Time ltRDD
			
			ltRDD =Time( Mid( lsTemp, 9, 2) + ':' + Mid( lsTemp, 11, 2 ))
			ldRDD = Date( lsDate )
			ldtRDD = Datetime( ldRDD, ltRDD )
			
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'Request_Date', lsDate)  
		
			if llNewRowSO_DCWH > 0 then ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Request_Date', lsDate)  

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Customer Code
			//'To' Location - mapped to Cust_Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'To' Location. Record will not be processed.")
			End If

			If IsNull(lsTemp) or Trim(lsTemp) = '' Then
				ldsDOHeader.SetItem(llNewRow, 'Cust_Code', 'GENERIC')
			Else	
				//ldsDOHeader.SetItem(llNewRow, 'Cust_Code', Trim(lsTemp))
				if llBatchSeqSO_2 > 0 then //need two outbound orders, 1st to WH, 2nd to DC
//TEMPO! if lsSTCust is in the same wh as lsSF_LocalWHLoc, then set cust_code to lsSTCust
					ldsDOHeader.SetItem(llNewRow, 'Cust_Code', Trim(lsST_LocalWHLoc))
					ldsDOHeader.SetItem(llNewRowSO_2, 'Cust_Code', Trim(lsSTCust))
				else
					ldsDOHeader.SetItem(llNewRow, 'Cust_Code', Trim(lsTemp)) //??same as lsSTCust?
				end if
				if llNewRowSO_DCWH > 0 then //need a WH X-fer from DCWH to Local WH
					if lsSF_LocalWHLoc_WH = lsSTCust_WH then
						//if the Final Destination is in the same wh as the Local WH Loc, then do WH X-fer to Final Destination
						ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Cust_Code', lsSTCust)
					else
						ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Cust_Code', Trim(lsSF_LocalWHLoc))
					end if
				end if
			End If

			/*for DECOM / RMA, we need to compare the Customer to the Intermediate WH
			   - if it's the same, don't create the outbound order */
			if lsTemp = lsSF_LocalWHLoc then
				lbNoOutbound = true
			else
				/* 5/14/2010 - need to check the Customer's WH with the LocalWHLoc's WH.
				  - if they're the same, we'll be receiving directly into the customer code (instead of the Local WH) and no outbound order is required
				  - 5/18/2010 - added the test for empty string...*/
				if lsSTCust_WH = lssf_LocalWHLoc_WH and trim(lsSTCust_WH) <>'' then
					lbNoOutbound = true
				else
				 	// dts 1/19/14 - now need to check if the customer's WH is in the same 'WH Group' (warehouse.UF3) as the local WH
					

				end if
			end if
			// strip lsTemp from lsRecData before lsTemp is manipulated...
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			if llNewRowSO_2 > 0 then //need two outbound orders, 1st to WH, 2nd to DC
			    //set address info for 2nd outbound order (where final DC is customer)...
				//reset customer variables...
				lsCustName = ""; lsAddr1=""; lsAddr2=""; lsCity=""; lsState=""; lsZip=""; lsCountry=""; lsTel=""; lsCustType=""
				//grab customer information, if available....
				select Cust_name, Address_1, Address_2, City, State, Zip, Country, Tel, customer_type
				into :lsCustName, :lsAddr1, :lsAddr2, :lsCity, :lsState, :lsZip, :lsCountry, :lsTel, :lsCustType
				from customer
				where project_id = 'pandora'
				and cust_code = :lsSTCust;
				
				//change llNewRowSO_2 to llNewRow?
				ldsDOHeader.SetItem(llNewRowSO_2, 'Cust_Name', lsCustName)
				ldsDOHeader.SetItem(llNewRowSO_2, 'Address_1', lsAddr1)
				ldsDOHeader.SetItem(llNewRowSO_2, 'Address_2', lsAddr2)
				//ldsDOHeader.SetItem(llNewRowSO_2, 'Address_3',Trim(Mid(lsRecData,1058,40)))
				ldsDOHeader.SetItem(llNewRowSO_2, 'City', lsCity) 
				ldsDOHeader.SetItem(llNewRowSO_2, 'State', lsState) 
				ldsDOHeader.SetItem(llNewRowSO_2, 'Zip', lsZip) 
				ldsDOHeader.SetItem(llNewRowSO_2, 'Country', lsCountry) 
				ldsDOHeader.SetItem(llNewRowSO_2, 'tel', lsTel) 
				lsTemp = lsST_LocalWHLoc	// for looking up WH Address info	
			end if

			if llNewRowSO_DCWH > 0 then //need a WH x-fer from DCWH to Local WH
			    //set address info for initiating DCWH WH xfer (where movement starts from a DCWH)...
				//reset customer variables...
				lsCustName = ""; lsAddr1=""; lsAddr2=""; lsCity=""; lsState=""; lsZip=""; lsCountry=""; lsTel=""; lsCustType=""
				//grab customer information, if available....
				select Cust_name, Address_1, Address_2, City, State, Zip, Country, Tel, customer_type
				into :lsCustName, :lsAddr1, :lsAddr2, :lsCity, :lsState, :lsZip, :lsCountry, :lsTel, :lsCustType
				from customer
				where project_id = 'pandora'
				and cust_code = :lsSF_LocalWHLoc;
				
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Cust_Name', lsCustName)
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Address_1', lsAddr1)
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Address_2', lsAddr2)
				//ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Address_3',Trim(Mid(lsRecData,1058,40)))
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'City', lsCity) 
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'State', lsState) 
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Zip', lsZip) 
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'Country', lsCountry) 
				ldsDOHeader.SetItem(llNewRowSO_DCWH, 'tel', lsTel) 
			end if

			//set address for main (or only) outbound order
			//reset customer variables...
			lsCustName = ""; lsAddr1=""; lsAddr2=""; lsCity=""; lsState=""; lsZip=""; lsCountry=""; lsTel=""; lsCustType=""
			//grab customer information, if available....
			select Cust_name, Address_1, Address_2, City, State, Zip, Country, Tel, customer_type
			into :lsCustName, :lsAddr1, :lsAddr2, :lsCity, :lsState, :lsZip, :lsCountry, :lsTel, :lsCustType
			from customer
			where project_id = 'pandora'
			and cust_code = :lsTemp;
			
			ldsDOHeader.SetItem(llNewRow,'Cust_Name', lsCustName)
			ldsDOHeader.SetItem(llNewRow,'Address_1', lsAddr1)
			ldsDOHeader.SetItem(llNewRow,'Address_2', lsAddr2)
			//ldsDOHeader.SetItem(llNewRow,'Address_3',Trim(Mid(lsRecData,1058,40)))
			ldsDOHeader.SetItem(llNewRow,'City', lsCity) 
			ldsDOHeader.SetItem(llNewRow,'State', lsState) 
			ldsDOHeader.SetItem(llNewRow,'Zip', lsZip) 
			ldsDOHeader.SetItem(llNewRow,'Country', lsCountry) 
			ldsDOHeader.SetItem(llNewRow,'tel', lsTel) 
			
//moved above			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
//  Customer Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				If Len(trim(lsTemp)) > 0 Then
					ldsDOHeader.SetItem(llNewRow, 'Cust_Name', Trim(lsTemp))
				//else
				//	ldsDOHeader.SetItem(llNewRow, 'Cust_Name', ' ')
				End If
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Customer_PO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.SetItem(llNewRow, 'order_no', Trim(lsTemp))
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'order_no', Trim(lsTemp))
			if llNewRowSO_DCWH > 0 then ldsDOHeader.SetItem(llNewRowSO_DCWH, 'order_no', Trim(lsTemp))
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
/* Need to set correct record for these, depending on whether it is the DC or WH Address on order
      - use a new variable for the row and set it to either llNewRow or llNewRowSO_2 as appropriate.... */
//  ShipTo_ADDR1
			if llNewRowSO_2 > 0 then 
				llTempRow = llNewRowSO_2
			else
				llTempRow = llNewRow
			end if
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'Address_1', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_ADDR2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'Address_2', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_ADDR3
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'Address_3', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_ADDR4
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'Address_4', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_District *not used
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_Postal_Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'Zip', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

///  ShipTo_City
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'City', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_State
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'State', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_Country
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'Country', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  SoldTo_Number *Not Used
			// LTK 20120329 Now using Sold To Number to populate Delivery_Alt_Address.Tel
			String lsSoldToNumber
			If Pos(lsRecData,'|') > 0 Then
				//lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				lsSoldToNumber = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				//lsTemp = lsRecData
				lsSoldToNumber = lsRecData
			End If
			
			//lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToNumber) + 1))) /*strip off to next Column */
			
//  SoldTo Name 
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToName = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToName = lsRecData
			End If
			if Len(lsSoldToName) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToName) + 1))) /*strip off to next Column */


//  SoldTo_ADDR1 
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToAddr1 = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToAddr1 = lsRecData
			End If

			if Len(lsSoldToAddr1) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToAddr1) + 1))) /*strip off to next Column */

//  SoldTo_ADDR2
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToAddr2 = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToAddr2 = lsRecData
			End If
			
			if Len(lsSoldToAddr2) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToAddr2) + 1))) /*strip off to next Column */

//  SoldTo_ADDR3
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToAddr3 = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToAddr3 = lsRecData
			End If
			
			if Len(lsSoldToAddr3) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToAddr3) + 1))) /*strip off to next Column */

//  SoldTo_ADDR4
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToAddr4 = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToAddr4 = lsRecData
			End If
			
			if Len(lsSoldToAddr4) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToAddr4) + 1))) /*strip off to next Column */

//  SoldTo_District
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToDistrict = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToDistrict = lsRecData
			End If
			
			if Len(lsSoldToDistrict) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToDistrict) + 1))) /*strip off to next Column */

//  SoldTo_Postal_Code 
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToZip = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToZip = lsRecData
			End If
			
			if Len(lsSoldToZip) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToZip) + 1))) /*strip off to next Column */

//  SoldTo_City
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToCity = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToCity = lsRecData
			End If
			
			if Len(lsSoldToCity) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToCity) + 1))) /*strip off to next Column */

//  SoldTo_State 
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToState = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToState = lsRecData
			End If
			
		if Len(lsSoldToState) > 0 Then lbSoldToAddress = True
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToState) + 1))) /*strip off to next Column */

//  SoldTo_Country
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToCountry = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToCountry = lsRecData
			End If
			
			if Len(lsSoldToCountry) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToCountry) + 1))) /*strip off to next Column */

			If lbSoldToAddress Then
				//TODO - For DC to DC, do we need address records for the SO to the DC? (different BatchSeqNo)
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetItem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
		
				ldsDOAddress.SetItem(llNewAddressRow,'address_type','ST') /* Address Type*/
				ldsDOAddress.SetItem(llNewAddressRow,'Name',lsSoldToname) /* Name */
				ldsDOAddress.SetItem(llNewAddressRow,'address_1',lsSoldToaddr1) 
				ldsDOAddress.SetItem(llNewAddressRow,'address_2',lsSoldToaddr2) 
				ldsDOAddress.SetItem(llNewAddressRow,'address_3',lsSoldToaddr3) 
				ldsDOAddress.SetItem(llNewAddressRow,'address_4',lsSoldToaddr4) 
				ldsDOAddress.SetItem(llNewAddressRow,'City',lsSoldTocity)
				ldsDOAddress.SetItem(llNewAddressRow,'District',lsSoldTodistrict) 
				ldsDOAddress.SetItem(llNewAddressRow,'State',lsSoldTostate)
				ldsDOAddress.SetItem(llNewAddressRow,'Zip',lsSoldTozip) 
				ldsDOAddress.SetItem(llNewAddressRow,'Country',lsSoldTocountry)
				
				ldsDOAddress.SetItem(llNewAddressRow,'Tel',lsSoldToNumber)	// LTK 20120329 added
				ldsDOAddress.SetItem(llNewAddressRow,'contact_person',lsSoldToname)	// LTK 20120329 added
				
				lbSoldToAddress = False
			End if

//  Supplier *not used * Defaulted Above
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Shipping Route *Not Used
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

///  Freight Terms
			//Shipping Terms - mapped to freight terms
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Material Transfer Terms. Record will not be processed.")
			End If
			//ldsDOHeader.SetItem(llNewRow, 'freight_terms', Trim(lsTemp))
			// LTK 20120329 comment out line above.  Freight_terms now being populated with the new field incoterms in position DM043 			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
//  User Field 7
			//User_Field7 - Transaction Type (passed back to Pandora in Inventory Transaction Confirmation)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Transaction Type' field. Record will not be processed.")
			End If						
			ldsDOheader.SetItem(llNewRow, 'User_Field7', lsTemp) 
			if llNewRowSO_2 > 0 then ldsDOheader.SetItem(llNewRowSO_2, 'User_Field7', lsTemp) 
			if llNewRowSO_DCWH > 0 then ldsDOheader.SetItem(llNewRowSO_DCWH, 'User_Field7', lsTemp) 
			
			//TAM 07/01/2009 Added return replacement as order type 
			// TAM 2009/07/09 Remove the logic to create an inbound order for defective parts 
			//IF lsTemp =  'RETURN REPLACEMENT' Then
			//	ldsDOHeader.SetItem(llNewRow, 'order_Type', 'Y') /*Set Return Defective */
			//End If
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
//  User Field 8
//??? should we quit mapping this at the header level? I believe we're getting this at the detail level so not sure what the value is here...
// 10/08/09 - no longer setting UF8 to To Project (finally) (still grabbing the data, just not setting the field).
			//'To' Project - mapped to User_Field8
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'To' Project. Record will not be processed.")
			End If
			//dsDOHeader.SetItem(llNewRow, 'User_Field8', Trim(lsTemp))
			//not setting UF8 on WH-DC order if llNewRowSO_2 > 0 then 
				
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//  User Field 11
			//Requestor Name - 
			If Pos(lsRecData,'|') > 0 Then
				lsRequestor = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsRequestor = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow, 'user_field11', Trim(lsRequestor))
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'user_field11', Trim(lsRequestor))
			if llNewRowSO_DCWH > 0 then ldsDOHeader.SetItem(llNewRowSO_DCWH, 'user_field11', Trim(lsRequestor))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsRequestor) + 1))) /*strip off to next Column */

//  User Field 10
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow, 'user_field10', Trim(lsTemp))
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'user_field10', Trim(lsTemp))
			if llNewRowSO_DCWH > 0 then ldsDOHeader.SetItem(llNewRowSO_DCWH, 'user_field10', Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Shipping Instructions
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.SetItem(llNewRow, 'shipping_instructions_text', Trim(lsTemp))
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'shipping_instructions_text', Trim(lsTemp))
			if llNewRowSO_DCWH > 0 then ldsDOHeader.SetItem(llNewRowSO_DCWH, 'shipping_instructions_text', Trim(lsTemp))
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Remarks
//TAM 2009/08/25  - Moved Remarks to userfield 1 (They contain Service Levels)
			//Comments - mapped to remark
			If Pos(lsRecData,'|') > 0 Then
				lsRemark = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsRemark = lsRecData
			End If
			
			//GailM 08/08/2017 SIMSPEVS-537 - SIMS to provide advance ESD cutoff configuration via GUI
			Select Top 1 address_1 Into :lsCarrierAddr1
			From carrier_master
			Where project_id = 'PANDORA'
			and address_1 in ( 'VENDOR PAID SHIPMENT', 'FEDEX','UPS','EXPEDITORS','SHUTTLE','DHL' )		//Added Shuttle and DHL for future
			and ( inactive is null or inactive = 0 )
			And user_field1 = :lsRemark;
			
			If lsCarrierAddr1 = '' Then lsCarrierAddr1 = '*all'

			// LTK 20120613  Pandora #442  If the order number prefix is in list (currently:  CMOR, CMTR, FMOR, FMTR) then set DM.UF1 = PIU (stored in the lookup table in case of changes).
			String ls_order_prefix, ls_service_from_lookup, ls_original_remark
			ls_original_remark = lsRemark
			
			ls_order_prefix = ldsDOHeader.GetItemString(llNewRow, 'Invoice_no')
			if Len(ls_order_prefix) >= 4 then
				ls_order_prefix = Upper(Trim(Left(ls_order_prefix,4)))
				
				select code_descript
				into :ls_service_from_lookup
				from lookup_table
				where project_id = 'PANDORA'
				and code_type = '3B18'
				and code_id = :ls_order_prefix;
				
				if Len(ls_service_from_lookup) > 0 then
					lsRemark = ls_service_from_lookup
				end if
			end if
			// End Pandora #442

			ldsDOHeader.SetItem(llNewRow, 'user_field1', Trim(lsRemark))
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'user_field1', Trim(lsRemark))
			if llNewRowSO_DCWH > 0 then ldsDOHeader.SetItem(llNewRowSO_DCWH, 'user_field1', Trim(lsRemark))
			
//			ldsDOHeader.SetItem(llNewRow, 'remark', Trim(lsRemark))
//			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'remark', Trim(lsRemark))

			// LTK 20120525  Pandora #423 Set carrier if the service level is in the list (currently: NOS, DOS and PIU).
			String ls_carrier,  ls_service_level			
			ls_service_level = Upper(Trim(lsRemark))
			
			select code_descript
			into :ls_carrier
			from lookup_table
			where project_id = 'PANDORA'
			and code_type = 'CCODE'
			and code_id = :ls_service_level;
			
			if Len(ls_carrier) > 0 then
				ldsDOHeader.SetItem(llNewRow,'Carrier', ls_carrier)	

				// Also set transport_mode
				String ls_transport_mode

				select transport_mode
				into :ls_transport_mode
				from carrier_master
				where project_id = 'PANDORA'
				and carrier_code = :ls_carrier;
				
				if Len(ls_transport_mode) > 0 then
					ldsDOHeader.SetItem(llNewRow,'transport_mode', ls_transport_mode)
				end if
			end if
			// End of Pandora #423

			// LTK 20110722  	Pandora #266  Store carrier service level code description, as opposed to the code.
			//						The carrier service level code comes in the remarks field.  Look up the description 
			//						and store it in delivery_master.agent_info.
			if Len(lsRemark) > 0 then
				
				String ls_code_desc
				
				select code_descript
				into :ls_code_desc
				from lookup_table
				where project_id = 'PANDORA'
				and code_type = 'SL'
				and code_ID = :lsRemark;
				
				ls_code_desc = Left(Trim(ls_code_desc),30)	// DM.agent_info is length 30, lookup_table.code_descript is length 40
				if Len(ls_code_desc) > 0 then
					ldsDOHeader.SetItem(llNewRow, 'agent_info', ls_code_desc)

					if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'agent_info', ls_code_desc)
					if llNewRowSO_DCWH > 0 then ldsDOHeader.SetItem(llNewRowSO_DCWH, 'agent_info', ls_code_desc)

				end if
			end if
			// Pandora #266 end.


			//lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsRemark) + 1))) /*strip off to next Column */
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(ls_original_remark) + 1))) /*strip off to next Column */	// LTK 20120613  Pandora #442
			
//  Customer_sent_date - TAM 2010/01/17

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsDate = Mid(lsTemp, 5, 2) + '/' + Mid(lsTemp,7, 2) + '/' + Left(lsTemp, 4)
			ldsDOHeader.SetItem(llNewRow, 'customer_sent_date', lsDate) 
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'customer_sent_date', lsDate) 
			if llNewRowSO_DCWH > 0 then ldsDOHeader.SetItem(llNewRowSO_DCWH, 'customer_sent_date', lsDate) 

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Ship To Contact Person - TAM 2010/01/27

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow, 'contact_person', lstemp) 
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'contact_person', lstemp) 
			if llNewRowSO_DCWH > 0 then ldsDOHeader.SetItem(llNewRowSO_DCWH, 'contact_person', lstemp) 

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Ship To Telephone - TAM 2010/01/27

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow, 'tel', lstemp) 
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'tel', lstemp) 
			if llNewRowSO_DCWH > 0 then ldsDOHeader.SetItem(llNewRowSO_DCWH, 'tel', lstemp) 

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//TimA 12/15/11 OTM project
			//********************************************************************
			
			//Pandora issu #348 GUTS-NUM
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow, 'user_field5', Trim(lsTemp)) 
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			// LTK 20120329 Commented out code below and rearranged so that the fields are always stipped off.  
			// This way fields added to the end of the record can be processed, regardless of the OTM flag.

			//TimA 01/03/12 OTM Project Fixed RDD Flag
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			If gs_OTM_Flag = 'Y' then 
				//TimA 09/12/12 Pandora issue 473.  On all MTR and CMTR order default User_Field14 to FIRM for Firm/Flex OTM
				//dts 2012-09-14 - 473 cont'd: Word is now that only 'MTR' triggers this.
				//TimA 10/26/12 Pandora issue #529.  Change the current process to looking up the vaules in a table
				String  ls_CodeDesc, lsCodeID
				lsCodeID = left(lsInvoice,4 )
				
				select code_descript
				into :ls_CodeDesc
				from lookup_table
				where project_id = 'PANDORA'
				and code_type = 'FIRM'
				and code_ID = :lsCodeID;
				
				ls_CodeDesc = Trim(ls_CodeDesc)
				if ls_CodeDesc = 'Y'  then

				//If left(lsInvoice,3 ) = 'MTR' or left(lsInvoice,4 ) = 'CMTR' then
				//If left(lsInvoice,3 ) = 'MTR' then
					ldsDOHeader.SetItem(llNewRow, 'user_field14', 'FIRM' ) 					
				else
					ldsDOHeader.SetItem(llNewRow, 'user_field14', Trim(lsTemp)) 
				end if
			End if

			//TimA 01/03/12 OTM Project Rate Trans ID
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			If gs_OTM_Flag = 'Y' Then 
				ldsDOHeader.SetItem(llNewRow, 'user_field15', Trim(lsTemp)) 
			End if

			// LTK 20120329  incoterms now coming as DM043 and populating DM.freight_terms
			String lsIncoTerms
			If Pos(lsRecData,'|') > 0 Then
				lsIncoTerms = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsIncoTerms = lsRecData
			End If
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsIncoTerms) + 1))) /*strip off to next Column */
			ldsDOHeader.SetItem(llNewRow, 'freight_terms', Left(Trim(lsIncoTerms),20))

			// TAM 201606  Client Cust PO Nbr (AKA - Vendor Order Nbr)
			String lsClientCustPONbr
			If Pos(lsRecData,'|') > 0 Then
				lsClientCustPONbr = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsClientCustPONbr = lsRecData
			End If
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsClientCustPONbr) + 1))) /*strip off to next Column */
			ldsDOHeader.SetItem(llNewRow, 'client_cust_po_nbr', Trim(lsClientCustPONbr))
			
			//GailM 08/08/2017 SIMSPEVS-537 - This element determines if this order is MIM.  Starts with the letter X
			If Left(lsClientCustPONbr,1) = 'X' Then
				lsMIMOrder = 'Yes'
			End If
			
			//********************************************************************			
			
//DECOM / RMA, Multi-Stage shipment. Create Inbound receipt from DC to 'local' WH...
			if lsSFCustType = 'DC' then
				If llBatchSeqPO = 0 then // might not have been set above...(if there is no lsSF_LocalWHLoc)
					llBatchSeqPO = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
					If llBatchSeqPO <= 0 Then Return -1
				end if
				llNewRowPO = idsPOHeader.InsertRow(0)
				//llOrderSeq ++
				//llLineSeq = 0
	
				//Record Defaults
				idsPOHeader.SetItem(llNewRowPO, 'Action_cd', 'A') /*always a new Order*/
				// 4/2010 - if this is a delete, need to delete the inbound too...
				if lsAction = 'D' then
					idsPOHeader.SetItem(llNewRowPO, 'Action_cd', 'D')
				end if
				idsPOHeader.SetItem(llNewRowPO, 'project_id', asProject) /*Project ID*/
				idsPOHeader.SetItem(llNewRowPO, 'order_Type', 'Y') /* new order type for Multi-stage shipments */
				//setting inventory type to 'MRB' for RMA (project in RTV, OSV, MRB, DECOM, SCRAP?)
				if lsST_Group = 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
				//RTV, OSV, MRB are exclusive to RMA project, DECOM and SCRAP are not!
				    idsPOHeader.SetItem(llNewRowPO, 'Inventory_Type', 'N') /*default to Normal*/
				end if
				if lsST_Group = 'RMA' then //now testing for RMA instead of not DECOM.
					if lsToProject = 'RTV-RMA' or lsToProject = 'RTV-PO' then
						idsPOHeader.SetItem(llNewRowPO, 'Inventory_Type', 'N') /* RTV */	
						idsPOHeader.SetItem(llNewRowPO, 'Order_Type', 'Y') 
					elseif lsToProject = 'OSV' then
						idsPOHeader.SetItem(llNewRowPO, 'Inventory_Type', 'N') 
						idsPOHeader.SetItem(llNewRowPO, 'Order_Type', 'Y') 
					elseif lsToProject = 'REMARKET' then
						idsPOHeader.SetItem(llNewRowPO, 'Inventory_Type', 'N') 
						idsPOHeader.SetItem(llNewRowPO, 'Order_Type', 'Y') 
					//11/11 elseif lsToProject = 'SCRAP' then
					//11/11 	idsPOHeader.SetItem(llNewRowPO, 'Inventory_Type', 'S') 
					//11/11 	//idsPOHeader.SetItem(llNewRowPO, 'Order_Type', 'Y') 
					//11/11 elseif lsToProject = 'DECOM' then
					//11/11 	idsPOHeader.SetItem(llNewRowPO, 'Inventory_Type', 'N') 
					//11/11 	//idsPOHeader.SetItem(llNewRowPO, 'Order_Type', 'Y') 

// ET3 2012-12-06 Pandora 545 - no longer track by MRB inventory type
//					elseif lsToProject = 'MRB' then
//						idsPOHeader.SetItem(llNewRowPO, 'Inventory_Type', 'M') 
//						idsPOHeader.SetItem(llNewRowPO, 'Order_Type', 'Y') 
					else
						idsPOHeader.SetItem(llNewRowPO, 'Inventory_Type', 'N') /*default to Normal*/
					end if
				end if
				idsPOHeader.SetItem(llNewRowPO, 'edi_batch_seq_no', llBatchSeqPO) /*batch seq No*/
				idsPOHeader.SetItem(llNewRowPO, 'order_seq_no', 1)  // always one order in file...
				idsPOHeader.SetItem(llNewRowPO, 'ftp_file_name', aspath) /*FTP File Name*/
				idsPOHeader.SetItem(llNewRowPO, 'Status_cd', 'N')
				idsPOHeader.SetItem(llNewRowPO, 'Last_user', 'SIMSEDI')
				
				idsPOheader.SetItem(llNewRow, 'order_no', lsInvoice) //Invoice from 3b18
				//dts - 2/24/11 - adding cross-dock functionality to DC-to-WH receipt
				if left(lsInvoice, 4) = 'CMOR' or left(lsInvoice, 4) = 'CMTR' then 
					lbCrossDock = True
					idsPOheader.SetItem(llNewRowPO, 'Crossdock_ind', 'Y')
				end if
				
				idsPOheader.SetItem(llNewRow, 'supp_code', 'PANDORA')  
				idsPOheader.SetItem(llNewRow, 'Arrival_Date', lsDate) //? is this date valid?
				//idsPOheader.SetItem(llNewRow,'Carrier', lsTemp)
				//idsPOheader.SetItem(llNewRow, 'remark', lsRemark)
				//TAM 2009/08/25  - Moved Remarks to userfield 1 (They contain Service Levels)
				idsPOheader.SetItem(llNewRow, 'User_Field1', lsRemark)
				//TAM 01/25/2010 UF3 moved to UF6
				//idsPOheader.SetItem(llNewRow, 'User_Field3', lsOwnerCd)  /* UF3 - 'From' Location */	
				idsPOheader.SetItem(llNewRow, 'User_Field6', lsOwnerCd)  /* UF6 - 'From' Location */	

				//TimA 04/26/12 Pandora issue #329
				idsPOheader.SetItem(llNewRow, 'User_Field2', lsSF_LocalWHLoc)  
				
				idsPOheader.SetItem(llNewRow, 'User_Field7', 'MATERIAL RECEIPT')  /* UF7 - PO Line Type */	
				//idsPOheader.SetItem(llNewRow, 'User_Field8', lsTemp)  /* UF8 - From Project */	
				//idsPOheader.SetItem(llNewRow, 'User_Field9', lsTemp)  /* UF9 Vendor Name */	
				//idsPOheader.SetItem(llNewRow, 'User_Field10', lsTemp)  /* UF10 Buyer Name */	
				idsPOheader.SetItem(llNewRow, 'User_Field11', lsRequestor)  /* UF11 Requestor Name */	

				//TimA 12/14/11 Pandora issue #337 OTM Project
				//NOTE:  Should we change this on the second leg?
				//TimA 03/28/12 OTM Project				
				If gs_OTM_Flag = 'Y' then 
					//This is just a temporary place holder for multi stage orders.
					//In u_nvo_process_file we will look for the "M" on shuttle type orders then set the order status there.
					ldsDOHeader.SetItem(llNewRow, 'ord_status', 'M') 									
				Else
					// 3/09/10 - need to put 2nd leg on Hold...
					ldsDOHeader.SetItem(llNewRow, 'ord_status', 'H') //Order is on 'Hold' until Receipt from DC is received.				
				End if
				// 5/14/2010 - if Local WH Loc is in the same building as the receiving owner, we're receiving directly 
				//   into the owner (instead of the local WH) and not creating the outbound.
			end if //Ship-from is a DC
			
			if lbError then
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				ldsDOHeader.SetItem(llNewRow,'status_message','Custom Pandora Validation') /*Don't want to process this record in the next step*/
				if llNewRowSO_2  > 0 then 
					ldsDOHeader.SetItem(llNewRowSO_2,'status_cd','E') /*Don't want to process this header in the next step*/
					ldsDOHeader.SetItem(llNewRowSO_2,'status_message','Custom Pandora Validation') /*Don't want to process this record in the next step*/
				end if
			end if

		// DETAIL RECORD
		Case 'DD' /*Detail */
		
/*	TAM 2010/03/04 - Pandora is going to start sending Delivery BOMs but instead of sending the Header/Detail/Child they ill be sending the children in the detail loop and 2 aditional fields at the end that has the parent sku 
and parent quantity.  This presents a little logic difficulty.  If these 2 new fields are blank then the detail line is a normal order line -no problem.  If the 2 new fields have parent values then we need to use the parent sku 
and quantity to create the detail line.  We will take the existing Sku and quantity an create a DELIVERY_BOM record -Also no problem.  
	The problem is we will be receiving multiple detail rows that have the same parent with different children.  We only need to create 1 detail row
per Parent Sku an use the rest to create the DELIVERY_BOM records.  So the solution is look for the Parent SKU in the detail row.  If it exists use it as the sku and save it to see when it changes.  If on the next detail record 
the parent SKU is the same as the save Parent Sku then we skip creating a new detail and just create the BOM.  If the Parent Sku Changes then we create a new detail record and create the next delivery BOM.
Another quirk.  Pandora is send the total child quantity.  We will calculate the BOM quantity by dividing the Total child quantity by the parent quantity
			//Child Sku: 4th field in DD record
			//Child QTY: 6th field in DD record
			//Parent Sku: 18th field in DD record
			//Parent QTY: 19th field in DD record
			//Child Price: 13th field in DD record
			//Child Line: 3th field in DD record
*/
			i = 1
			liChildSkuStart = 1
			do while i < 4
				liChildSkuStart = pos(lsRecData, '|', liChildSkuStart) + 1
				i += 1
			loop
			liChildSkuEnd = pos(lsRecData, '|', liChildSkuStart)
			lsChildSKU = Mid(lsRecData, liChildSkuStart, liChildSkuEnd - liChildSkuStart)
				
			i = 1
			liChildQTYStart = 1
			do while i < 6
			liChildQTYStart = pos(lsRecData, '|', liChildQTYStart) + 1
			i += 1
			loop
			liChildQTYEnd = pos(lsRecData, '|', liChildQTYStart)
			lsChildQTY = Mid(lsRecData, liChildQTYStart, liChildQTYEnd - liChildQTYStart)

//TAM 2010/03/29  Get the Child Price to roll up into Parent
			i = 1
			liChildPriceStart = 1
			do while i < 13
			liChildPriceStart = pos(lsRecData, '|', liChildPriceStart) + 1
			i += 1
			loop
			liChildPriceEnd = pos(lsRecData, '|', liChildPriceStart)
			ldChildPrice = Dec(Mid(lsRecData, liChildPriceStart, liChildPriceEnd - liChildPriceStart))
		
//TAM 2010/04/19  Get the Child Line to roll up into Parent
			i = 1
			liChildLineStart = 1
			do while i < 3
			liChildLineStart = pos(lsRecData, '|', liChildLineStart) + 1
			i += 1
			loop
			liChildLineEnd = pos(lsRecData, '|', liChildLineStart)
			lsChildLine = Mid(lsRecData, liChildLineStart, liChildLineEnd - liChildLineStart)
		
			i = 1
			liParentSkuStart = 1
			do while i < 18
				liParentSkuStart = pos(lsRecData, '|', liParentSkuStart) + 1
				i += 1
			loop
// TAM 2010/04/08  If liParentSkuStart = 1 then the file did not have the 2 new pipes "|" at the end.  This would happen if we processed a file prior to ICC changes.
			If liParentSkuStart > 1 Then
				liParentSkuEnd = pos(lsRecData, '|', liParentSkuStart)
                  lsParentSKU = Mid(lsRecData, liParentSkuStart, liParentSkuEnd - liParentSkuStart)
                  lsParentQTY = Right(lsRecData,(len(lsRecData) - (liParentSkuEnd)))
						
				//TimA Pandora issue #192
				If lsParentSKU <> "" and lsParentQTY <> "" then
					//Data found un Field18 and 19 This is MORK order
					ldsDOheader.SetItem(llNewRow, 'User_Field21', 'Y')
				end if
             Else 
              	lsParentSku = ''
				lsParentQTY = ''

              End IF
			
			If Not isNull(lsParentSku) and lsParentSKU > '' Then 
				lbDoDeliveryBOM = True
//				lsSKU = lsParentSKU
//				lsParentQty = Mid(lsRecData, liParentSkuEnd, liParentqtyEnd - liParentSkuEnd)
			End If
				
	// Added a big If Statement to be able to create Delivery BOMs from the detail records.  We only want to create 1 Order Detail per Delivery BOM grouping
			If lsSaveParentSKU <> lsParentSKU or not lbDoDeliveryBOM Then
			llNewDetailRow = 	ldsDODetail.InsertRow(0)
			llLineSeq ++

		//Add detail level defaults
			ldsDODetail.SetITem(llNewDetailRow, 'supp_code', 'PANDORA') /* 2/14/09 */
			ldsDODetail.SetItem(llNewDetailRow, 'project_id', asproject) /*project*/
			ldsDODetail.SetItem(llNewDetailRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			ldsDODetail.SetItem(llNewDetailRow, 'order_seq_no', llOrderSeq) 
			ldsDODetail.SetItem(llNewDetailRow, "order_line_no", string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'N')
// 09/09 - per Ian, don't want to default Inv Type....
			//ldsDODetail.SetItem(llNewDetailRow, 'Inventory_type', 'N') /*normal inventory*/
/*TODO!!! 10/09 - RMA no longer necessarily multi-stage (OSV still is), so SFCust won't be DC
 (Plus, some DC's are operating as Warehouses so this was no longer valid anyway) */
			if lsSFCustType = 'DC' then
				if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
					if lsToProject = 'RTV' then
						ldsDODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'R') /*Return - RTV*/
					elseif lsToProject = 'OSV' then
						/* 07/28/2010 ujhall: 01 of 02: Temporary Fix.  Later remove the whole else if as 
						Inventory_type is likely already 'N' */
//						ldsDODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'A') 
						ldsDODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N') 
					elseif lsToProject = 'DECOM' then
						ldsDODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'S') 
					else
						ldsDODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N') /*default to Normal*/
					end if
				end if
			end if
				
			//if lsSTCustType = 'DC' then
			if llBatchSeqSO_2 > 0 then
				/* DECOM / RMA, Multi-Stage shipment.
				  - if Ship-To is a DC, we need to ship first to the Associated WH, then to the DC
					 (so we're creating two outbound orders) */
				llNewRowSODetail_2 = ldsDODetail.InsertRow(0)
				//llLineSeq ++

			//Add detail level defaults
				ldsDODetail.SetItem(llNewRowSODetail_2, 'supp_code', 'PANDORA') /* 2/14/09 */
				ldsDODetail.SetItem(llNewRowSODetail_2, 'project_id', asproject) /*project*/
				ldsDODetail.SetItem(llNewRowSODetail_2, 'edi_batch_seq_no', llBatchSeqSO_2) /*batch seq No*/
				ldsDODetail.SetItem(llNewRowSODetail_2, 'order_seq_no', llOrderSeq) 
				ldsDODetail.SetItem(llNewRowSODetail_2, "order_line_no", string(llLineSeq)) /*next line seq within order*/
				ldsDODetail.SetItem(llNewRowSODetail_2, 'Status_cd', 'N')
// 09/09 - per Ian, don't want to default Inv Type....
				//ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_type', 'N') /*normal inventory*/
	
				if lsSFCustType = 'DC' then //TODO - 10/09 - what about ShipFrom a DCWH (cust type won't be 'DC')
					if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
						if lsToProject = 'RTV' then
							ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_Type', 'R') /*Return - RTV*/
						elseif lsToProject = 'OSV' then
							/* 07/28/2010 ujhall: 02 of 02: Temporary Fix.  Later remove the whole else if as 
							Inventory_type is likely already 'N' */
//							ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_Type', 'A') 
							ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_Type', 'N') 
						elseif lsToProject = 'DECOM' then
							ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_Type', 'S') 
						else
							// 10/09 - per Ian, don't want to default Inv Type....
							//ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_Type', 'N') /*default to Normal*/
						end if
					end if
				end if
			end if //llBatchSeqSO_2 > 0

			if llBatchSeqSO_DCWH > 0 then
				/* DECOM / RMA, Multi-Stage shipment.
				  - if Ship-To is a DC, we need to ship first to the Associated WH, then to the DC
					 (so we're creating two outbound orders) */
				llNewRowSODetail_DCWH = ldsDODetail.InsertRow(0)
				//llLineSeq ++

			//Add detail level defaults
				ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'supp_code', 'PANDORA') /* 2/14/09 */
				ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'project_id', asproject) /*project*/
				ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'edi_batch_seq_no', llBatchSeqSO_DCWH) /*batch seq No*/
				ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'order_seq_no', llOrderSeq) 
				ldsDODetail.SetItem(llNewRowSODetail_DCWH, "order_line_no", string(llLineSeq)) /*next line seq within order*/
				ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'Status_cd', 'N')
// 09/09 - per Ian, don't want to default Inv Type....
				//ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_type', 'N') /*normal inventory*/
	
				//if lsSFCustType = 'DC' then
				//	if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
				//		if lsToProject = 'RTV' then
				//			ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_Type', 'R') /*Return - RTV*/
				//		elseif lsToProject = 'OSV' then
				//			ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_Type', 'A') 
				//		elseif lsToProject = 'DECOM' then
				//			ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_Type', 'S') 
				//		else
				//			ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_Type', 'N') /*default to Normal*/
				//		end if
				//	end if
				//end if
			end if //llBatchSeqSO_DCWH > 0 (shipment starts from DCWH)
			
			//From File
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */

//  Delivery_Number
			//Invoice No
			If Pos(lsRecData,'|') > 0 Then
				lsInvoice = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Invoice No' field. Record will not be processed.")
			End If						
			ldsDODetail.SetItem(llNewDetailRow, 'Invoice_no', lsInvoice) 
			//TODO - Do we need to have a distinct Invoice_No (for DC-DC 2nd order)????
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'Invoice_no', lsInvoice + '_2')
			if llNewRowSODetail_DCWH > 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'Invoice_no', lsInvoice + '_DCWH')
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsInvoice) + 1))) /*strip off to next Column */

//  Line_Number
			//Material Transfer Line Number
			If Pos(lsRecData,'|') > 0 Then
				lsLine = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Material Transfer Line Number. Record will not be processed.")
			End If	
			ldsDODetail.SetItem(llNewDetailRow, 'line_item_no', dec(lsLine)) 
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'line_item_no', dec(lsLine)) 
			if llNewRowSODetail_DCWH	> 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'line_item_no', dec(lsLine)) 
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsLine) + 1))) /*strip off to next Column */
//  SKU
//  TAM 03/2010 -  Use Parent SKU from above if we are creating a delivery BOM
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If lbDoDeliveryBOM = TRUE then 
					lsSKU = lsParentSku
				Else
					lsSKU = Left(lsRecData,(pos(lsRecData,'|') - 1))
				End If
//TAM 11/20/2009  - Get ALT_SKU from the Item_master and save if it exists.
				select alternate_sku into :lsAltSku
				from item_master
				where project_id = 'PANDORA'
				and sku = :lsSku;
				// - If Alt Sku is found then populate
				if not isnull(lsAltSku) and lsAltSku <> '' then
						ldsDODetail.SetItem(llNewDetailRow, 'Alternate_Sku', lsAltSku) 
				end if

			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Part Number. Record will not be processed.")
			End If	
			ldsDODetail.SetItem(llNewDetailRow, 'sku', lsSKU) 
			// TAM 2009/11/20 - If Alt Sku is found then populate
			if not isnull(lsAltSku) and lsAltSku <> '' then
				ldsDODetail.SetItem(llNewDetailRow, 'Alternate_Sku', lsAltSku) 
			end if
			if llNewRowSODetail_2 > 0 then 
				ldsDODetail.SetItem(llNewRowSODetail_2, 'sku', lsSKU) 
				ldsDODetail.SetItem(llNewRowSODetail_2, 'Alternate_Sku', lsAltSku) //TAM 2009/11/20
			End If
			if llNewRowSODetail_DCWH > 0 then 
				ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'sku', lsSKU)
				ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'Alternate_Sku', lsAltSku) //TAM 2009/11/20
			End If
//			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSKU) + 1))) /*strip off to next Column */
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//  Supplier *Not Used
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Quantity
//  TAM 03/2010 -  Use Parent QTY from above if we are creating a delivery BOM
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If lbDoDeliveryBOM = TRUE then 
					lsQTY = lsParentQTY
				Else
					lsQTY = Left(lsRecData,(pos(lsRecData,'|') - 1))
				End If
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Quantity. Record will not be processed.")
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'quantity', lsQTY) 
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'quantity', lsQTY) 
			if llNewRowSODetail_DCWH > 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'quantity', lsQTY)		
//			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsQTY) + 1))) /*strip off to next Column */
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Storage Location *Not Used
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Unit_of_Measure
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'UOM', Trim(lsTemp))
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'UOM', Trim(lsTemp))
			if llNewRowSODetail_DCWH > 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'UOM', Trim(lsTemp))
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Customer PO Number *not Used
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  PO Number 1
			//'From' Project - mapped to PO_NO
			// - for DECOM/RMA (multi-stage) FROM project of outbound order will be TO project of 1st leg
			//   - we'll set that later (when we get to the 'To Project' in the data)
			//   (need to retain original FROM project for FROM project on 1st leg, receipt from DC)
			If Pos(lsRecData,'|') > 0 Then
				lsFromProject = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'From' Project. Record will not be processed.")
			End If	
			ldsDODetail.SetItem(llNewDetailRow, 'po_no', lsFromProject) 
			//for final leg of DC-DC move, From/To project will always be the same (To Project in the file (below))
			if llNewRowSODetail_DCWH > 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'po_no', lsFromProject)  //TODO - is PO_NO right here???
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsFromProject) + 1))) /*strip off to next Column */

//  Owner Code
			//'From' Location - mapped to Owner_ID (after look-up via Owner_CD)
			// - 4/12/09 - Also setting DM.UF2 to 'FROM' Location from file
			// For DC-DC move, owner of 2nd Outbound Order will be Owner in Local SHIP-TO WH (lsST_LocalWHLoc)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If	
			//ldsDODetail.SetItem(llNewDetailRow, 'line_item_no', lsTemp) 
			lsOwnerCD = lsTemp
			if lsSF_LocalWHLoc > '' then
				//for DECOM/RMA - Owner is not on the Ship-From in the file - it is the intemediate WH's owner
				if llBatchSeqSO_DCWH > 0 then lsOwnerCD_DCWH = lsOwnerCD
				lsOwnerCd = lsSF_LocalWHLoc 
			end if
			if lsOwnerCD <> lsOwnerCD_Prev then
				//Need to look up Owner_ID and WH_Code (but shouldn't look it up for each row if it doesn't change)
				//  - do we need to validate that the WH_Code doesn't change within an Order?
				lsOwnerID = ''
				select owner_id into :lsOwnerID
				from owner
				where project_id = :asProject and owner_cd = :lsOwnerCD;
				lsOwnerCD_Prev = lsOwnerCD
		
				select user_field2 into :lsWH
				from customer
				where project_id = 'PANDORA'
				and cust_code = :lsOwnerCD;
			end if
			if lsST_LocalWHLoc > '' then
				//for DC-DC order, Owner on 2nd SO is the 2nd (Ship-To) intemediate WH's owner
				//lsOwnerCd = lsST_LocalWHLoc 
				if lsST_LocalWHLoc <> lsST_LocalWHLoc_Prev then
					//Need to look up Owner_ID and WH_Code (but shouldn't look it up for each row if it doesn't change)
					//  - do we need to validate that the WH_Code doesn't change within an Order?
					lsOwnerID_2 = ''
					select owner_id into :lsOwnerID_2
					from owner
					where project_id = :asProject and owner_cd = :lsST_LocalWHLoc;
					lsST_LocalWHLoc_Prev = lsST_LocalWHLoc
			//TEMPO! 692 - check lsWH_2...
					select user_field2 into :lsWH_2
					from customer
					where project_id = 'PANDORA'
					and cust_code = :lsST_LocalWHLoc;
				end if
			end if
			if llBatchSeqSO_DCWH > 0 then //if lsSF_LocalWHLoc > '' then
				//movement starts with a WH X-Fer from DCWH to local WH
				//Need to look up Owner_ID and WH_Code (but shouldn't look it up for each row if it doesn't change)
				//  - do we need to validate that the WH_Code doesn't change within an Order?
				lsOwnerID_DCWH = ''
				select owner_id into :lsOwnerID_DCWH
				from owner
				where project_id = :asProject and owner_cd = :lsOwnerCD_DCWH;
				lsOwnerCD_DCWH_Prev = lsOwnerCD_DCWH
		
				select user_field2 into :lsWH_DCWH
				from customer
				where project_id = 'PANDORA'
				and cust_code = :lsOwnerCD_DCWH;
			end if

			if lsInvoice <> lsPrevInvoice then
			  //set wh_code when the invoice changes
//				ldsDOheader.SetItem(llNewDetailRow, 'wh_code', lsWH)
				ldsDOheader.SetItem(llNewRow, 'wh_code', lsWH)
				// 4/2010 - now setting ord_date to local wh time
				ldtWHTime = f_getLocalWorldTime(lsWH)
				ldsDOheader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))

				//GailM 0712/2017 SIMSPEVS-728 Defect: Current ESD logic does not include Weekend cutoff date
				ldtScheduleDate = f_delivery_advance_esd_configuration(lsWH,ldtWHTime, ldtRDD, lsMIMOrder, lsCarrierAddr1, lsSTCust )				
				ldsDOheader.setitem(llNewRow,'schedule_date',string(ldtScheduleDate, 'mm-dd-yyyy hh:mm'))
				
				lsMessage = 'Set ESD to ' + string( ldtScheduleDate ) + ' with Carrier: ' + lsCarrierAddr1 + ', MIM Order: ' + lsMIMOrder + ', CustCode: ' + lsSTCust + ', WH Time: ' + string( ldtWHTime ) + ', RDD: ' + string( ldtRDD ) 
				f_method_trace_special( asproject, this.ClassName() + ' - uf_process_so_rose',lsMessage, lsWH, ' ',' ',lsInvoice)

				lsPrevInvoice = lsInvoice
				//need to set order type to 'Z' (for warehouse transfer) if customer is of type WH
				if lsCustType = 'WH' then 
					ldsDOHeader.SetItem(llNewRow, 'order_Type', 'Z') /* warehouse Transfer*/
//					ldsDOHeader.SetItem(llNewDetailRow, 'order_Type', 'Z') /* warehouse Transfer*/
				//	ldsDOHeader.SetItem(llNewRow, 'user_field2', lsOwnerCD) /* warehouse Transfer*/
				end if
				
				//DECOM/RMA
				if lsSFCustType = 'DC' then
					idsPOheader.SetItem(1, 'wh_code', lsWH)
					// 4/2010 - now setting ord_date to local wh time
					ldtWHTime = f_getLocalWorldTime(lsWH)
					idsPOheader.SetItem(1, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))
				end if
				if llNewRowSO_2 > 0 then 
					ldsDOheader.SetItem(llNewRowSO_2 , 'wh_code', lsWH_2) //TEMPO! 692 - check lsWH_2...
					// 4/2010 - now setting ord_date to local wh time
					ldtWHTime = f_getLocalWorldTime(lsWH_2)
					ldsDOheader.SetItem(llNewRowSO_2, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))
					
					//GailM 0712/2017 SIMSPEVS-728 Defect: Current ESD logic does not include Weekend cutoff date
					ldtScheduleDate = f_delivery_advance_esd_configuration(lsWH,ldtWHTime, ldtRDD, lsMIMOrder, lsCarrierAddr1, lsSTCust )				
					ldsDOheader.setitem(llNewRow,'schedule_date',string(ldtScheduleDate, 'mm-dd-yyyy hh:mm'))
					
				end if
				if llNewRowSO_DCWH > 0 then 
					ldsDOheader.SetItem(llNewRowSO_DCWH , 'wh_code', lsWH_DCWH)
					// 4/2010 - now setting ord_date to local wh time
					ldtWHTime = f_getLocalWorldTime(lsWH_DCWH)
					ldsDOheader.SetItem(llNewRowSO_DCWH, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))
					
					//GailM 0712/2017 SIMSPEVS-728 Defect: Current ESD logic does not include Weekend cutoff date
					ldtScheduleDate = f_delivery_advance_esd_configuration(lsWH,ldtWHTime, ldtRDD, lsMIMOrder, lsCarrierAddr1, lsSTCust ) 				
					ldsDOheader.setitem(llNewRow,'schedule_date',string(ldtScheduleDate, 'mm-dd-yyyy hh:mm'))

				end if
				
				if lbCrossDock = True then
					// dts 2010/08/12 - now seeding l_code with a cross-dock location if it's a cross-dock order
					//TODO!  need to look up a cross-dock location (where l_type = '9') that has inventory in question?
					// !! May just want to always use 'CROSSDOCK' as the location (per Ian, every warehouse will have a 'CROSSDOCK' location
					select min(l_code) into :lsCrossDock_Loc from location
					where wh_code = :lsWH and l_type = '9';
				end if
				lsCrossDock_Loc = NoNull(lsCrossDock_loc)

			end if // lsInvoice <> lsPrevInvoice
			if lbCrossDock = True and lsCrossDock_Loc > '' then
//TEMP-dts. waiting for server code				ldsDODetail.SetItem(llNewDetailRow, 'l_code', lsCrossDock_Loc)
			end if
			
			ldsDODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
			//for DC-DC, Owner on 2nd outbound order should be owner on 2nd Inbound order (lsST_LocalWHLoc)...
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'owner_id', lsOwnerID_2)
			if llNewRowSODetail_DCWH > 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'owner_id', lsOwnerID_DCWH)
			
			ldsDOHeader.SetItem(llNewRow, 'user_field2', lsOwnerCD) /* 04/09 - PCONKL - Moved outside of if statement to unconditionally set the From Location */
			if llNewRowSO_2  > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'user_field2', lsST_LocalWHLoc) /* For 2nd Oubound order (DC-DC movement), need 'From Location' */
			if llNewRowSO_DCWH > 0 then ldsDOHeader.SetItem(llNewRowSO_DCWH, 'user_field2', lsOwnerCD_DCWH) /* For DCWH - WH movement */

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
//  User Field 1
	//Mfg Part NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field1', Trim(lsTemp))
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'User_Field1', Trim(lsTemp))
			if llNewRowSODetail_DCWH > 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'User_Field1', Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Price
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldPrice = 0 //Reset price for parent line when summing children prices
			ldsDODetail.SetItem(llNewDetailRow, 'Price', Trim(lsTemp))
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'Price', Trim(lsTemp))
			if llNewRowSODetail_DCWH > 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'Price', Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Currency Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'Currency_Code', Trim(lsTemp))
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'Currency_Code', Trim(lsTemp))
			if llNewRowSODetail_DCWH > 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'Currency_Code', Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Serial Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field3', Trim(lsTemp))
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'User_Field3', Trim(lsTemp))
			if llNewRowSODetail_DCWH > 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'User_Field3', Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  To Project 
//!!TEMPO!!
			If Pos(lsRecData,'|') > 0 Then
				lsToProject = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsToProject = lsRecData
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field5', Trim(lsToProject))
			if llNewRowSODetail_2 > 0 then 
				ldsDODetail.SetItem(llNewRowSODetail_2, 'User_Field5', Trim(lsToProject))
				/* if this is multi-stage and the intermediate WH has a Hard-coded Project rule (Customer.uf10)
				    - then the To Project of the 1st Order should be the hard-coded Project value of the intermediate WH */
//TODO - HardCode - should this be the hard-coded value or file driven?  I've heard it both ways.
// - 3/10/10 - lsProject_Hardcode is set to '' to (temporarily?) disable customer-project setting on electronic orders.
				if lsProject_Hardcode > '' then
					ldsDODetail.SetItem(llNewDetailRow, 'User_Field5', Trim(lsProject_Hardcode))
				end if
			end if
			if llNewRowSODetail_DCWH > 0 then 
//TODO - HardCode - should this be the hard-coded value or file driven?  I've heard it both ways.
				ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'User_Field5', Trim(lsToProject))
				//if lsProject_Hardcode > '' then
				//	ldsDODetail.SetItem(llNewDetailRow, 'User_Field5', Trim(lsProject_Hardcode))
				//end if
			end if
			//FOR DECOM/RMA, 'FROM' Project of outbound order should be the 'TO' project of 1st leg.
			if lsSFCustType = 'DC' then
				ldsDODetail.SetItem(llNewDetailRow, 'po_no', Trim(lsToProject))
			end if
			if llNewRowSODetail_2 > 0 then 
				/* if this is multi-stage and the intermediate WH has a Hard-coded Project rule (Customer.uf10)
				    - then the From Project of the 2nd Order should be the hard-coded Project value of the intermediate WH */
// - 3/10/10 - lsProject_Hardcode is set to '' to (temporarily?) disable customer-project setting on electronic orders.
				if lsProject_Hardcode > '' then
					ldsDODetail.SetItem(llNewRowSODetail_2, 'po_no', Trim(lsProject_Hardcode))
				else
					ldsDODetail.SetItem(llNewRowSODetail_2, 'po_no', Trim(lsToProject))
				end if
			end if
			if llNewRowSODetail_DCWH > 0 then 
				/* if this is multi-stage and the intermediate WH has a Hard-coded Project rule (Customer.uf10)
				    - then the From Project of the 2nd Order should be the hard-coded Project value of the intermediate WH */
// - 3/10/10 - lsProject_Hardcode is set to '' to (temporarily?) disable customer-project setting on electronic orders.
				if lsProject_Hardcode > '' then
					ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'po_no', Trim(lsProject_Hardcode))
				else
					ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'po_no', Trim(lsToProject))
				end if
			end if

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsToproject) + 1))) /*strip off to next Column */
		
//  Container ID
			If Pos(lsRecData,'|') > 0 Then
				lsContainer = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsContainer = lsRecData
			End If
			// 10/08/09 - RMA Container ID is stored at detail (not Picking as we're not necessarily picking the Container that was stored).
			// 08/03/10 ujhall:  Now it is stored at picking
			ldsDODetail.SetItem(llNewDetailRow, 'user_field7', Trim(lsContainer)) 
			// dts - 2010-08-19, adding container to the detail level UF7 ('RMA Container #') for '_DCWH' and '_2' orders.
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'user_field7', Trim(lsContainer))
			if llNewRowSODetail_DCWH > 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'user_field7', Trim(lsContainer))
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// 08/03/2010 ujhall: Per dave to Fix Container Number Picking Issue
			/* dts 8/10/10 - now only setting container ID if container comes from KARMA (with a format 0000-000000000000, )
			 			Karma has reserved cont id  starting with 0000 through 0999 */
			 lsContainer = Trim(lsContainer)
			 // dts 6/18/14 - PND 876 - set Container_ID in staging table so that pick generation is by container. (Waiting for clarification so no changes at this time).
			// gwm 8/15/14 - 883 - removed condition on lsContainer for Deja Vu
	//		 if len(lsContainer) = 17 and left(lsContainer, 4) >= '0000' and left(lsContainer, 4) <= '0999'  then
				ldsDODetail.SetItem(llNewDetailRow, 'Container_Id', Trim(lsContainer)) 
				if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'Container_Id', Trim(lsContainer))
				/* dts 2010-08-17, 	the setting of container_id for the 'DCWH' order was always enabled.
				    							I think it should be subject to the same rules as the others so bringing 
											it into the Karma container condition */
				if llNewRowSODetail_DCWH > 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'Container_Id', Trim(lsContainer))
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsContainer) + 1))) /*strip off to next Column */
			
/* Breadboard # (DECOM)
  	- Not part of Detail Record - comes in as a Note of type 'BB' 
	  (still assumes only a single detail line per DECOM order */
			if lsBB > '' then
				ldsDODetail.SetItem(llNewDetailRow, 'Lot_No', lsBB)
				if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'Lot_No', lsBB)
				if llNewRowSODetail_DCWH > 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'Lot_No', lsBB)
			end if

//Multi-Stage shipment. Create Inbound receipt from DC to 'local' WH...
			if lsSFCustType = 'DC' then
				llNewRowPODetail = idsPODetail.InsertRow(0)
				//lbDetailError = False
				//llLineSeq ++
						
				//Add detail level defaults
				idsPODetail.SetItem(llNewRowPODetail,'order_seq_no', 1) //always only 1 order for DECOM/RMA
				idsPODetail.SetItem(llNewRowPODetail,'project_id', asproject) /*project*/
				idsPODetail.SetItem(llNewRowPODetail,'status_cd', 'N') 
				idsPODetail.SetItem(llNewRowPODetail,'Inventory_Type', 'N') 
				if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
					//if lsToProject = 'RTV'  or lsToProject = 'OSV' or lsToProject = 'MRB' or lsToProject = 'DECOM' then 
					//11-Sep-2015 :Madhu - As requested Roy, make default Inventory Type as N.
					//if lsToProject = 'MRB' then 
					//	idsPODetail.SetItem(llNewRowPODetail, 'Inventory_Type', 'M') /*MRB */
					//else
						idsPODetail.SetItem(llNewRowPODetail, 'Inventory_Type', 'N') /*default to Normal*/
					//end if
				end if
				idsPODetail.SetItem(llNewRowPODetail,'edi_batch_seq_no', llbatchseqPO) /*batch seq No*/
				idsPODetail.SetItem(llNewRowPODetail,"order_line_no", string(llLineSeq))
		
	//Action Code
	//Do we need to check to see if this PO already exists???
				idsPODetail.SetItem(llNewRowPODetail,'action_cd', 'A') 
	//Order Number
				idsPODetail.SetItem(llNewRowPODetail, 'Order_No', lsInvoice)
	//Line Item Number
				idsPODetail.SetItem(llNewRowPODetail,'line_item_no', dec(lsLine))
// TAM 2009/08/25 We are now saving Pandoras Line no into User Line No
				idsPODetail.SetItem(llNewRowPODetail,'user_line_item_no', lsLine)
	//SKU
				idsPODetail.SetItem(llNewRowPODetail, 'SKU', lsSKU)
				idsPODetail.SetItem(llNewRowPODetail, 'Alternate_Sku', lsAltSku) //TAM 2009/11/20
	//Qty
				idsPODetail.SetItem(llNewRowPODetail, 'quantity', lsQty) 
	//Price
				//TimA 07/18/2011 Pandora issue #255
				idsPODetail.SetItem(llNewRowPODetail, 'cost', string(ldChildPrice) )
	//lot No
				idsPODetail.SetItem(llNewRowPODetail, 'Lot_no', lsBB)
	//PO NO - Pandora Project...
				if lsToProject = '' then
					idsPODetail.SetItem(llNewRowPODetail, 'PO_NO', 'MAIN') //PO_NO tracking is on for all SKUs. Defaulting to 'MAIN'
				else
					idsPODetail.SetItem(llNewRowPODetail, 'PO_NO', lsToProject)
				end if
	//From Project (rd.uf2)
				idsPODetail.SetItem(llNewRowPODetail, 'user_field2', lsFromProject)
	//Owner ID
				// 10/09/09 - receiving into the Final Destination (if it's in the same WH as 'Local WH Loc')
				if lsSTCust_WH > '' and lsSTCust_WH = lsSF_LocalWHLoc_WH then
					lsOwnerID_Final = ''
					select owner_id into :lsOwnerID_Final
					from Owner
					where project_id = :asProject and owner_cd = :lsSTCust;
					idsPODetail.SetItem(llNewRowPODetail, 'owner_id', lsOwnerID_Final)
					
					//TimA 06/12/12 Pandora issue #426
					idsPOheader.SetItem(llNewRow, 'User_Field2',  lsSTCust) 
					
				else
					idsPODetail.SetItem(llNewRowPODetail, 'owner_id', lsOwnerID)
				end if
	//Container ID
				if lsContainer > '' then
					idsPODetail.SetItem(llNewRowPODetail, 'container_id', lsContainer)
				end if
				
				//dts - 2/24/11 - adding cross-dock functionality to DC-to-WH move....
				if lbCrossDock = True and lsCrossDock_Loc > '' then
					idsPODetail.SetItem(llNewRowPODetail, 'l_code', lsCrossDock_Loc)
				end if
			end if //ship-from is a DC (so DECOM/RMA multi-stage order)

			if lbError then
				//TODO - set status_cd on header as well?
				ldsDODetail.SetItem(llNewDetailRow,'status_cd','E') /*Don't want to process this record in the next step*/
				ldsDODetail.SetItem(llNewDetailRow,'status_message','Custom Pandora Validation') /*Don't want to process this record in the next step*/
				if llNewRowSODetail_2 > 0 then 
					ldsDODetail.SetItem(llNewRowSODetail_2,'status_cd','E') /*Don't want to process this record in the next step*/
					ldsDODetail.SetItem(llNewRowSODetail_2,'status_message','Custom Pandora Validation') /*Don't want to process this record in the next step*/
				end if
			end if
		end if // End of Delivery BOM check

		//TODO Create Child Delivery BOM Record
		If lbDoDeliveryBOM then
			//TODO create Child BOM 
				
				// We want to use the Line ITem Nmber that we assigned and not the Oracle line - Use Oracle line in UF 5 to find our line
				//We want to reject this order if Oracle has split a kitted line (same Order/Line/parent & Child SKU)
				
					//See if BOM record is a Dup
					lsFind = "order_seq_no = " + String(llOrderSeq) + " and sku_parent = '" + lsSKU + "' and sku_child = '" + lsChildSku + "' and Line_item_No = " + lsLine
					
					If ldsDOBom.Find(lsFind,1,ldsDOBom.RowCount()) > 0 Then /*Dup*/
						gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) +  " Split BOM row detected. Order will not be processed.")
						ldsDOHeader.SetItem(ldsDOHeader.RowCount(),'status_cd','E') /*Don't want to process this header in the next step*/
						ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
						lbError = True
						Continue /*Process Next Record */
					Else
						If dec(lsParentQty) > 0 then
							llChildQty = dec(lsChildQty)/dec(lsParentQty)
						Else
							gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) +  " Parent Quantity is less than Zero. Order will not be processed.")
							ldsDOHeader.SetItem(ldsDOHeader.RowCount(),'status_cd','E') /*Don't want to process this header in the next step*/
							ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
							lbError = True
							Continue /*Process Next Record */
						End If					

// TAM 2010/03/29  - Need to roll up the BOM Prices to the Parent Detail row
						ldPrice = ldPrice+ldChildPrice
						lsPrice = Trim(string(ldPrice))
						ldsDODetail.SetItem(llNewDetailRow, 'Price', Trim(lsPrice))
						if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'Price', Trim(lsPrice))
						if llNewRowSODetail_DCWH > 0 then ldsDODetail.SetItem(llNewRowSODetail_DCWH, 'Price', Trim(lsPrice))
					
						//Insert a new BOM LIne
						llNewBOMRow = ldsDOBOM.InsertRow(0)
						ldsDOBOM.SetITem(llNewBOMRow,'project_id',asProject) 
						ldsDOBOM.SetItem(llNewBOMRow,'edi_batch_seq_no',llbatchseq) 
						ldsDOBOM.SetItem(llNewBOMRow,'order_seq_no',llOrderSeq) 
						ldsDOBOM.SetItem(llNewBOMRow, 'line_item_no', dec(lsLine)) 
						ldsDOBOM.SetItem(llNewBOMRow,'sku_parent',lsSKU) 
						ldsDOBOM.SetItem(llNewBOMRow,'sku_child',lsChildSku) 
						ldsDOBOM.SetItem(llNewBOMRow,'child_Qty',llChildQty) 
						ldsDOBOM.SetItem(llNewBOMRow,'supp_code_parent','PANDORA') 
						ldsDOBOM.SetItem(llNewBOMRow,'supp_code_child','PANDORA') 
						ldsDOBOM.SetItem(llNewBOMRow,'user_field1',lsChildLine) 
						// LTK 20110902  Pandora #293 Set delivery_BOM.user_field2 to the project
						ldsDOBOM.SetItem(llNewBOMRow,'user_field2',lsFromProject) 
// TAM 2010/04/22  - Add Owner ID to the BOM 
						ldsDOBOM.SetItem(llNewBOMRow, 'Owner_Id', dec(lsOwnerId)) //Better be the same as the Parent.
				
						Select Min(supp_Code) into :lsSupplier
						From Item_MAster
						Where PRoject_ID = :asProject and sku = :lsChildSku;
				
						If lsSupplier > "" Then
						Else /*Child ITem does not exist*/
							gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - Child SKU: '" + lsChildSku + "' Does not exist. Record will not be processed.")
							ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
							ldsDOBOM.DeleteRow(llNewBomRow)
							lbError = True
							Continue /*Process Next Record */
						End If
						
					End If /*BOM exists*/
							
			lsSaveParentSku = lsParentSKU
			lbDoDeliveryBOM = False
		End IF


Case 'DN'/* Header/Line Notes*/  

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

			lsNoteType = lsTemp
			
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
			//TimA 04/08/14 pandora wants to include pipes '|' in the note field so we are just getting everthing in the note field.
			//NOTE:  This will only work if the notes field is the last field in the txt file.
//			If Pos(lsRecData,'|') > 0 Then
//				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//			Else 
				lsTemp = lsRecData
//			End If

			//Each Note row may get broken into multiple rows if we encounter a ~
			lsNoteText = lsTemp
			If lsNoteText > "" Then 

			//DECOM - BreadBoard is coming in as a note - Supposedly only a single BreadBoard (and single line) for an Order.
				if lsNoteType = 'BB' then
					lsBB = lsNoteText //need to set variable for later use if BB Note comes before Detail line in the file.
					ldsDODetail.SetItem(1, 'Lot_No', lsBB)
				end if
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
			
			//dts 10/23/13 - Returning out of here instead of Continuing (as we're getting imbedded carriage returns and, thus, invalid record types and the file remains stuck in the inbound directory)
			//dts 10/23/13 gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Entire FILE (ORDER) will not be processed.")
			lbError = True
			//dts 10/23/13 Continue /*Next Record */
			Return -1 //dts 10/23/13 

			
	End Choose /*Header, Detail or Notes */
	
Next /*file record */

//TimA 11/16/12 Pandora issue #476
//RMA Note date is after the detail lines on the DAT file.  See if the Note table has any RMA information and set the same line item no user_field8 to 'RM'
sVar = "RM"
ldsDONotes.SetFilter("note_type = '"+ sVar +" '")  //Filter notes for note type 'RM'
ldsDONotes.filter( )
For n = 1 to ldsDONotes.rowcount( )
	llNLine = ldsDONotes.getitemnumber(n,'line_item_no')
	If llNLine > 0 then
		ll_found = ldsDODetail.Find("line_item_no = " + String(llNLine), 1, ldsDODetail.RowCount())
		If ll_found > 0 then
			ldsDODetail.SetItem(ll_found, 'user_field8', 'RM') 
		End if
	End if
Next

//*************************************************************************************
//TimA 05/25/12 Pandora issue #425
//Varables are called in new function uf_sendemailnotification
is_WhCode = lswh
is_Invoice = lsInvoice

if lbNoOutbound then //for DECOM / RMA, we may be creating only an Inbound order (from DC to WH)
// 10/09 - DC to WH may now be an outbound order from the DC....
	// 11/02/09 -  not setting this to 'E'....
	ldsDOHeader.SetItem(llNewRow,'status_cd','X') /*Don't want to process this record in the next step*/
	ldsDOHeader.SetItem(llNewRow,'status_message', 'No Outbound Order Needed (Local WH Loc same as ship-to WH Loc)') /*Don't want to process this record in the next step*/
	//shouldn't ever have to prevent the creation of the '2nd' Outbound order (from ship-to WH to ship-to DC)
	// - on DC-DC move, ship-from WH might be same as ship-to WH so no '1st' outbound order but still need outbound to ship-to DC
	//if llNewRowSODetail_2 > 0 then 
	//	ldsDOHeader.SetItem(llNewRowSODetail_2,'status_cd','E') /*Don't want to process this record in the next step*/
	//	ldsDOHeader.SetItem(llNewRowSODetail_2,'status_message','No Outbound Order Needed (Local WH Loc same as ship-to)') /*Don't want to process this record in the next step*/
	//end if
	For llRowPos = 1 to llNewDetailRow //count of detail rows.
		// 11/02/09 -  not setting this to 'E'....
		ldsDODetail.SetItem(llRowPos,'status_cd','X') /*Don't want to process this record in the next step*/
		ldsDODetail.SetItem(llRowPos,'status_message', 'No Outbound Order Needed (Local WH Loc same as ship-to)') /*Don't want to process this record in the next step*/
		//if llNewRowSODetail_2 > 0 then ....
	next
end if

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
	liRC = ldsDOBOM.Update()
End If
If liRC = 1 Then
	if lsSFCustType = 'DC' then
		liRC = idsPOHeader.Update()
		If liRC = 1 Then
			liRC = idsPODetail.Update()
		End If
	end if
end if
If liRC = 1 Then
	Commit;
	if lsSFCustType = 'DC' then
		If liRC = 1 Then
			if not lbError then // don't create inbound order if there are errors (need to get more specific about this)
				liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
			end if
		End If
	end if
//	if llBatchSeqSO_2 > 0 then //need two outbound orders, 1st to WH, 2nd to DC
//		liRC = gu_nvo_process_files.uf_process_delivery_order()
//	end if
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new SO Records to database "
	FileWrite(gilogFileNo, lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

If lbError Then Return -1

//if lbNoOutbound then //for DECOM / RMA, we may be creating only an Inbound order (from DC to WH)

//TimA 06/28/12 This error return code is no longer needed
//if lbNoOutbound and llBatchSeqSO_DCWH = 0 then //for DECOM / RMA, we may be creating only an Inbound order (from DC to WH)
//	return -1 
//end if

Return 0
end function

public function integer uf_process_to_rose (string aspath, string asproject);//Process Tranfer Order for Pandora
/* 05/24/2010 ujh:  Even though the DiskErase/HWOPS Key words are specified on the OD, the use of lsSOC_variant assumes that the
	whole order is as specified and will call the appropriate stored procedure for all ODs.  Note that lsSOC_variant is set only once.  */
boolean lb_diskerase
string lsSOC_variant, lsNewInvType

Datastore	lu_ds, ldsItem, lsLookupTable

datetime ldtWHTime

// 01/18/2010 ujh Add lsDelete_TONO, lsDelete_List  This is Owner Change Fix 1 of 5
// 02/08/2010 ujh add lsRecDataSoc, lsReturnTxt,  llReturnCode, lsListIgnored, lsListProcessed, lbSQLCAauto, 
							// llCntReceived, llCntIgnored, llCntProcessed,   llspParamMax, lsParamSeperator  for  AutoSOCchange
String	lsLogout,lsStringData, lsOrder, lsTemp, lsRecData, lsRecType, lsDesc, lsSKU, lsSupplier, lsNoteText ,lsNoteType,lsFromOwnerCd, &
		lsToOwnerCd, lsFromPoNo, lsToPoNo, lsTONO,lsFromOwnerId , lsToOwnerId,  lsFromWarehouse, lsToWarehouse,lsUF3, & 
		lsDelete_TONO, lsDelete_List, lsRecDataSOC, lsReturnTxt, lsListIgnored, lsListProcessed, lsParamSeperator
Integer	liRC,liFileNo
Long		llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llOwnerID, llNewNotesRow, llNoteSeq, llNoteLine &
              ,llReturnCode, llCntReceived, llCntIgnored, llCntProcessed,   llspParamMax,ll_ccline, ll_ccinvt

Boolean	lbError, lbDetailError, lbSQLCAauto
DateTime	ldtToday
Decimal	ldWeight, ldLineItemNo_c, ldFromOwnerID, ldToOwnerID
String ls_ccno, ls_ccline, ls_ccsku, ls_ccsupp_code, ls_cccoo, ls_cclotno, ls_ccpono, ls_ccpono2, ls_ccqty, ls_ccownerid, ls_cclcode, ls_ccinvtype, ls_ccserialno, ls_cccontid, ls_ccrono

Decimal ldTONO

String 	lsOrderNo
string 	lsSKU2, lsGPN, lsTemp2
string		lsFromProject, lsToProject
String 	lsLot_No, lsCOO, lsDiskEraseDelim   // 05/21/2010 ujh added to create a delimiter for Lot_Number and COO in Diskerase
boolean lbSkipAutoSOC
String    ls_SkipSOCProj
Long llSkipSOCCountRowCount, ll_SelectCount
//TimA 12/13/11 Set a counter for displaying the record process
Long llCounter, llCounterLoop
// LTK 20151210 Added for Pandora #1002 SOC with Serial GPNs
String ls_serialized_ind, ls_container_tracking_ind //TAM 2017/01 for container tracking SOC exceptions
long ll_rows

lsDiskEraseDelim = ":"

// 02/08/2010 ujh:  Initialize max length of parmaeter to be sent to stored proc sqlca.Sp_Auto_SOC and define the param segment seperator
 llspParamMax = 4000
lsParamSeperator = '$*&'

lsLogOut = '          - PROCESSING FUNCTION - Create Inbound Transfer Orders. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

SetPointer(Hourglass!)

ldtToday = DateTime(Today(),Now())

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

If Not isvalid(idsTOHeader) Then
	idsTOheader = Create u_ds_datastore
	idsTOheader.dataobject= 'd_transfer_master'
	idsTOheader.SetTransObject(SQLCA)
End If
idsTOheader.SetTransObject(SQLCA)

If Not isvalid(idsTOdetail) Then
	idsTOdetail = Create u_ds_datastore
	idsTOdetail.dataobject= 'd_transfer_detail'
	idsTOdetail.SetTransObject(SQLCA)
End If

If Not isvalid(lsLookupTable) Then
	 lsLookupTable = Create u_ds_datastore
	 lsLookupTable.dataobject = 'd_lookup_table_search'
	 lsLookupTable.SetTransObject(SQLCA)
End If
idsTODetail.SetTransObject(SQLCA)

idsTOheader.Reset()
idsTODetail.Reset()

//Open and read the File In
lsLogOut = '      - Opening File for PANDORA Transfer Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for PANDORA Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//TimA 05/19/14 Pandora issue #582 Add logic to lookup the Projects that skip Auto SOC from the lookup table
//TimA 02/13/15 Parms for the Functionality_Manager function
String ls_Parm1, ls_Parm2, ls_Parm3
SetNull(ls_Parm1)
SetNull(ls_Parm2)
SetNull(ls_Parm3)
//If f_functionality_manager(asProject,'SOC',gs_Tier_Desc,ls_Parm1 ,ls_Parm2, ls_Parm3)= 'N' then

llSkipSOCCountRowCount = lsLookupTable.retrieve(asProject,'SOC' )
llRowPos = 0
For llRowPos = 1 to llSkipSOCCountRowCount
		//Build a string of projects that are skipped.
		ll_SelectCount ++
		If ll_SelectCount > 1 then
			ls_SkipSOCProj = ls_SkipSOCProj + ',' + lsLookupTable.GetItemString(llRowPos,'Code_Id')
		Else
			ls_SkipSOCProj = ls_SkipSOCProj  + lsLookupTable.GetItemString(llRowPos,'Code_Id')
		End if
Next

llRowPos = 0

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)
Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',Trim(lsStringData)) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Process Each Record in the file..

//Process each row of the File
llRowCount = lu_ds.RowCount()

////  Owner Change Fix 2 of 5
// 01/18/2010 ujh:  Reset the delete list that will hold "new" Transfer_Master records that will be replaced by input file.
lsDelete_List = ""

//TimA 12/13/11 Display a count of records
llCounter ++
w_main.SetMicroHelp("Processing Owner Change Records.  Changes every 500 Records. " + String(llCounter))
Yield()

For llRowPos = 1 to llRowCount
	
    //TimA 12/13/11 Reset the count so the MicorHelp is update ever 500 records	
	llCounter ++
	llCounterLoop ++
	If llCounterLoop > 499 then
		w_main.SetMicroHelp("Processing Owner Change Records.  Changes every 500 Records. " + String(llCounter))
		llCounterLoop = 0 //Reset the loop counter
	end if
	Yield()
	
	lsRecData = Trim(lu_ds.GetItemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsRecType)
			
		Case 'OC' /* TO Header  */
				//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
				lsLogOut =  '      - Load Header: '  + String(Today(), "mm/dd/yyyy hh:mm:ss") 
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			lsSOC_variant = '*EMPTY*'  // 06/11/2010 ujh:  Set on each order so variants can be set at most once to apply to whole order
			llNewRow=idsToHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0

			sqlca.sp_next_avail_seq_no(asproject,"Transfer_Master","TO_No" ,ldTONO)//get the next available RO_NO
			If ldTONO <= 0 Then Return -1

			lsToNO = asProject + String(Long(ldToNo),"000000") 
			idsTOHeader.SetItem(llNewRow,'to_no',lsToNo)
			idsTOHeader.SetItem(llNewRow,'project_id',asProject)
			idsTOHeader.SetItem(llNewRow,'last_user','SIMSFP')
			idsTOHeader.SetItem(llNewRow, 'Ord_type', 'O')  /* Internal Order Type )  */
			idsTOHeader.SetItem(llNewRow, 'Ord_Status', 'N')
			idsTOHeader.SetItem(llNewRow, 'Ord_Date', ldtToday)  //-  now set later, after warehouse
					
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */

//  Warehouse ID *Not Used
				//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
				lsLogOut =  '      - Process Warehouse: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Warehouse' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
// From Owner
				//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
				lsLogOut =  '      - Get Owner: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Sub-Inventory Loc' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			If lsTemp > '' Then
				lsFromOwnerCd  = lsTemp
				idsTOHeader.SetItem(llNewRow, 'User_Field2', lsTemp)

				//From Owner Code
				select owner_id into :ldFromOwnerID
				from owner
				where project_id = :asProject and owner_cd = :lsFromOwnerCd;
				lsFromOwnerId = string(ldFromOwnerID)

				//Warehouse
				select user_field2 into :lsFromWarehouse
				from customer
				where project_id = :asProject and cust_code = :lsFromOwnerCD;
				idsTOHeader.SetItem(llNewRow, 's_warehouse', lsFromWarehouse)  /*  */	
				// 4/2010 - now setting ord_date to local wh time
				ldtWHTime = f_getLocalWorldTime(lsFromWarehouse)
				//idsTOheader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))
				idsTOheader.SetItem(llNewRow, 'ord_date', ldtWHTime) // this is setting in Transfer_Master so ord_date is actually a date/time (and not char)

				// KZUV.COM - Set the last update DATETIME to warehouse time.
				idsTOHeader.SetItem(llNewRow,'last_update', ldtWHTime)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " 'Sub-Inventory Loc' field is required but missing. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			
// To Owner
				//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
				lsLogOut =  '      - Get TO owner: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'To Owner' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			If lsTemp > '' Then
				lsToOwnerCd  = lsTemp

				//To Owner Code
				select owner_id into :ldToOwnerID
				from owner
				where project_id = :asProject and owner_cd = :lsToOwnerCd;
				lsToOwnerId = string(ldToOwnerID)

				//Warehouse
				select user_field2 into :lsToWarehouse
				from customer
				where project_id = :asProject and cust_code = :lsToOwnerCD;
				idsTOHeader.SetItem(llNewRow, 'd_warehouse', lsToWarehouse)  /*  */	

			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " 'To Owner' field is required but is missing. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			If lsFromWarehouse <> lsToWarehouse Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " 'From Owner' and 'To Owner' are in different Warehouses. This is not allowed on an Owner Change. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			
			// If the TO owner code follows the pattern WH*PM,
			If left(lsToOwnerCd, 2) = "WH" and right(lsToOwnerCd, 2) = "PM" then
			 
				 // Write the error to the log file.
				 gu_nvo_process_files.uf_write_log("Row: " + string(llRowPos) + " 'Operations needs control where FROM and TO warehouses both equal 'WH*PM'.  Record will not be processed.")
				 
				 // Set the error flag.
				 //lbError = True
				 lbSkipAutoSOC = True
				 
				 // Continue with next record.
				 //Continue
			 
			// End If the from and to warehouses both follow the pattern WH*PM.
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//MTR Number 
				//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
				lsLogOut =  '      - Get MTR Number: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'MTR Number' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If		
			
// Check if MTR Number already exists.  If It does, Bail.
// 2007/08/03 TAM filter status = "V"oid from duplicate check
			Select Distinct(User_Field3) into :lsUF3
			From Transfer_Master
			Where Project_id = :asProject
			and User_Field3 = :lsTemp and Ord_status <> 'V';

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  01/17/2010 ujh  This is replaced by Owner Change Fix 3 of 5
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//			if lsUF3 =  lsTemp then 
//				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " MTR Nbr " + string(lsTemp) + " - Owner Change Already Exists ") 
//				lbError = True
//				Continue /*Process Next Record */
//			end if
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 01/17/2010  ujh Owner Change Fix:  Fix so "New" transfer_Master, Transfer_detail, and Transfer_detail_content records are replaced			
			lsDelete_TONO = ''
			// If record already exists, check to see if it is new.  If so get TO_No so those new records can be deleted.
			if lsUF3 =  lsTemp then 
				Select TO_No into :lsDelete_TONO
				From Transfer_Master
				Where Project_ID = :asProject
				and User_Field3 = :lsUF3 and Ord_Status = 'N';
								
				//if lsDelete_TONO is populated, need to create/AddTo delete list, otherwise bail
				if len(lsDelete_TONO) > 0 then
					//01/18/2010 ujh:  Here build a string of lsDelete_TO_NO just in case the are multiple OC/OD groups of records.
					//  This is considered only because it seems possible to have multiple OC/OD groups of records at one time.  
					//  The architecture now says that multiples can be updated (which will really be inserts) AND if any fail
					//  the whole group will be rolled back.  With that, it will be possible to delete multiple OC/OD records that need to be replaced.
					lsDelete_List = lsDelete_List + ',' +  lsDelete_TONO
				else
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " MTR Nbr " + string(lsTemp) + " - Owner Change Already Exists and is NOT 'New'") 
					lbError = True
					Continue /*Process Next Record */
				end if
			
			end if
// 01/17/2010 ujh End Owner Change Fix 3 of 5
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////BEGIN/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 02/08/2010 UJH:  Capture Ordernumbers as Parameters for Store Proc named in PB as Sp_Auto_SOC
			if (len(lsRecDataSOC) + len(lsTemp))  > llspParamMax  then 
					lsRecDataSoc = lsRecDataSoc + lsParamSeperator
			end if
			lsRecDataSOC =  lsRecDataSOC + lsTemp + '|'
///////END//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			idsTOHeader.SetItem(llNewRow, 'User_Field3', lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Arrival Date  *Not Used
/* 11/17/2010 UJH: R&R:  adding code for possiblity of Requestor and Remarks.  the File format from here is Arrival Date|Remarks|Requestor
    This is to make it possible to run dependent on whether those fields are there or not.*/
		//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
		lsLogOut =  '      - Get Retrival Date: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				/* It is not yet an error for this NOT to be mapped. Therefore no error will be shown.  If arrival date is here, it will be ignored
					until further instruction.
					Once Remarks and Requestor are mapped, Code here will have to be uncommented, as it will be an error for this to be missing.
					It may be and will likely be empty, but it can't be missing the ending pipe.*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Arrival Date' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

// Remark
				//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
				lsLogOut =  '      - Remark: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Remark' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			// update Transfer master remark = = 
			idsTOHeader.SetItem(llNewRow, 'Remark', lsTemp)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

// Requestor Email
				//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
				lsLogOut =  '      - Requester Email: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Requestor Email' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			// update Transfer master user_field5 = Requestor Email
			idsTOHeader.SetItem(llNewRow, 'user_field5', lsTemp)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
// 12/01/2010 ujh:  Change for 11/17/2010 ujh: to allow for ending pipe or not			
// Requestor 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			end if
			// dts - 12/12/10 - I don't believe Requestor is required (and is not populated on the Auto-SOC's) so eliminating len validation...
			//If len(trim(lsTemp)) = 0 then
			//	gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Requestor' field. Record will not be processed.")
			//	lbError = True
			//	Continue /*Process Next Record */
			//End If
			// update Transfer master user_field4 = Requestor Email
			idsTOHeader.SetItem(llNewRow, 'user_field4', lsTemp)
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
// End 11/17/2010 ujh: R&R ////////////////////////////////////////////////////////////////////////////////////////////////////////////


	CASE 'OD' /* detail */
				//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
				lsLogOut =  '      - Load Detail: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			
			lbDetailError = False
			llNewDetailRow = 	idsTODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			idsTODetail.SetItem(llNewDetailRow,'TO_NO', lsTONO) /*project*/
			idsTODetail.SetItem(llNewDetailRow, 'Owner_id', ldFromOwnerID)  /*  */	
			idsTODetail.SetItem(llNewDetailRow, 'New_Owner_id',ldToOwnerID)  /*  */	
			idsTODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			idsTODetail.SetItem(llNewDetailRow, 'New_Inventory_Type', 'N')
			idsTODetail.SetItem(llNewDetailRow,'Supp_Code', 'PANDORA') 
			idsTODetail.SetItem(llNewDetailRow,'Country_of_origin', 'XXX') 
			idsTODetail.SetItem(llNewDetailRow,'Serial_No', '-') 
			idsTODetail.SetItem(llNewDetailRow,'Lot_No', '-') 
			idsTODetail.SetItem(llNewDetailRow,'Po_No2', '-') 
			idsTODetail.SetItem(llNewDetailRow,'Container_Id', '-') 
			idsTODetail.SetItem(llNewDetailRow,'Expiration_Date', '2999/12/31') 
			idsTODetail.SetItem(llNewDetailRow, 's_location', '*')  /*  */	
			idsTODetail.SetItem(llNewDetailRow, 'd_location', '*')  /*  */	
		
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */

			
//SKU
			//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
			lsLogOut =  '      - Process SKU: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Upper(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			lsSKU = trim(lsTemp)  
			/* may use to build itemmaster record 
			Need to check SKU in Item_Master and, if it's not there, check MFG SKU Look-up */
			//Select distinct(SKU) into :lsSKU2
			// LTK 20151210  Pandora #1002 - added more columns
			// TAM 20170113  Pandora  - added more columns
			Select MAX(SKU), COUNT(SKU), MAX(serialized_ind), MAX(Container_Tracking_Ind)
			Into :lsSKU2, :ll_rows, :ls_serialized_ind, :ls_container_tracking_ind
			From Item_Master
			Where Project_id = :asProject
			and SKU = :lsSKU;
			if lsSKU2 = '' then 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Missing Pandora SKU...") 
			end if
				
			idsTODetail.SetItem(llNewDetailRow, 'SKU', lsSKU)

			// LTK 20151210  Pandora #1002 - If GPN is serialized, then skip the Auto SOC
			if NOT lbSkipAutoSOC and Len(lsSKU2) > 0 then				
				 If f_retrieve_parm("PANDORA", "FLAG", "SOC_SERIAL_GPN_TRACK_ON") = 'Y' then
					if ll_rows = 1 then
						if Len( ls_serialized_ind ) > 0 and ls_serialized_ind <> 'N'  then
							lbSkipAutoSOC = TRUE
							lsLogOut = '      - Skipping Auto SOC because SKU (' + lsSKU + ') is serialized'
							FileWrite(giLogFileNo,lsLogOut)
						end if
					else
						ls_serialized_ind = ""
	
						Select MAX(serialized_ind)
						Into :ls_serialized_ind
						From Item_Master
						Where Project_id = :asProject
						and SKU = :lsSKU
						and Supp_Code = 'PANDORA';
	
						if Len( ls_serialized_ind ) > 0 and ls_serialized_ind <> 'N'  then
							lbSkipAutoSOC = TRUE
							lsLogOut = '      - Skipping Auto SOC because SKU (' + lsSKU + ') is serialized'
							FileWrite(giLogFileNo,lsLogOut)
						end if
					end if
				end if
			end if

			// TAM 20170113  Pandora  - If GPN is container tracked, then skip the Auto SOC
			if NOT lbSkipAutoSOC and Len(lsSKU2) > 0 then				
				 If f_retrieve_parm("PANDORA", "FLAG", "SOC_CONTAINER_TRACK_ON") = 'Y' then
					if ll_rows = 1 then
						if Len( ls_container_tracking_ind ) > 0 and ls_container_tracking_ind <> 'N'  then
							lbSkipAutoSOC = TRUE
							lsLogOut = '      - Skipping Auto SOC because SKU (' + lsSKU + ') is container tracked'
							FileWrite(giLogFileNo,lsLogOut)
						end if
					else
						ls_container_tracking_ind = ""
	
						Select MAX(Container_Tracking_Ind)
						Into :ls_container_tracking_ind
						From Item_Master
						Where Project_id = :asProject
						and SKU = :lsSKU
						and Supp_Code = 'PANDORA';
	
						if Len( ls_container_tracking_ind ) > 0 and ls_container_tracking_ind <> 'N'  then
							lbSkipAutoSOC = TRUE
							lsLogOut = '      - Skipping Auto SOC because SKU (' + lsSKU + ') is container tracked'
							FileWrite(giLogFileNo,lsLogOut)
						end if
					end if
				end if
			end if

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//From Inventory Type *Not Used
/*  - 10/09 - For RMA, need to use From/To Inventory Type.
				 We'll default it to 'N' but set as required based on Project (below)*/
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			
				// If the last field value was 'diskerase', set lb_diskerase to true
				lb_diskerase = lsTemp = 'diskerase'
				if lsSOC_variant = '*EMPTY*'  then
					lsSOC_variant = lsTemp   // 06/11/2010 ujh:  Set the last field to define the action for the next field (Diskerase * HWOPS)
				end if
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'From Inventory Type' field. Record will not be processed.")
				lbDetailError = True
			End If	
			
			//idsTODetail.SetItem(llNewDetailRow, 'Inventory_Type', Trim(lsTemp))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//To Inventory Type *NOT USED
/*  - 10/09 - For setting below (after From/To Project) for RMA. */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'To Inventory Type' field. Record will not be processed.")
				lbDetailError = True
			End If		
			
		lsTemp = Trim(lsTemp)	
		Choose Case upper(lsSOC_variant)   // 06/11/2010 ujh:  changed to use "Choose" due to another case.
				case  'DISKERASE'

				//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
				lsLogOut =  '      - Content Count: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			// If the last field was 'diskerase',
//			if lb_diskerase then

				// 05/21/2010 ujh:  Set the COO and lot_number.  The order of occurence is [COO:Lot_no]			
				if Pos(lsTemp, lsDiskEraseDelim) > 0 then
					lsLot_No = Left(lsTemp, (Pos(lsTemp, lsDiskEraseDelim) - 1))
					lsCOO = Right(lsTemp, len(lsTemp) - len(lsLot_No) - 1)
					idsTODetail.SetItem(llNewDetailRow, 'Lot_No', lsLot_No)
					idsTODetail.SetItem(llNewDetailRow,'Country_of_origin', lsCOO) 		
				else
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - DiskErase Format Error: Delimiter = '" + lsDiskEraseDelim + "'not found" )
				end if
	//			End If				
	
						//Jxlim 08/03/2011 BRD #39 Pandora diskErase	Do not set up SOC when inventory type is cycle count (*)
						//This is DiskErase so Lot_no is unique to the Disk, it will not be a duplicate lot_no.  However if Lot_no happen to be duplicate the operator have to corrected.
						Select count(*)  into :ll_ccinvt
						From   Content					
						Where Project_id 		= :asProject 
						And 	   WH_Code		= :lsFromWarehouse
						And	   Owner_id	 	= :ldFromOwnerID
						And	   SKU				= :lsSku
						And 	   Lot_no			= :lsLot_No
						And      Inventory_type	=  '*'
						//Below criterias are not neccesary, it gives incorrect count for cycle count inventory type.
						//			And 	   PO_No 				= :lstrparms.String_arg[8]	
						//			And 	   Lot_No 				= :lslot_no
						//			And      L_Code				= :ls_loc
						//			And 	  Country_of_Origin  = :ls_coo		
						//			And 	  Serial_No =
						//			And     RO_No =					
						//			And 	  Supp_Code=	/
						//			And 	  PO_No2 =	
						//			And 	  Component_No =	
						//			And 	  Container_ID		= 
						USING SQLCA;
								
						If ll_ccinvt > 0 Then
								gu_nvo_process_files.uf_writeError("Material is in Cycle count.  DiskErase Auto SOC will not be created.")
								lbError  = True
								Continue
						End If		
			
				// 06/11/2010 ujh:  Set the Lot_no and Inventory Type.  The order of occurence in the record is [Inv_type:Lot_no]
				case 'HWOPS'
				if Pos(lsTemp, lsDiskEraseDelim) > 0 then
					lsLot_No = Left(lsTemp, (Pos(lsTemp, lsDiskEraseDelim) - 1))
					lsNewInvType = Right(lsTemp, len(lsTemp) - len(lsLot_No) - 1)
					idsTODetail.SetItem(llNewDetailRow, 'Lot_No', lsLot_No)
					idsTODetail.SetItem(llNewDetailRow,'New_Inventory_Type',lsNewInvType) 
				else
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - HWOPS Format Error: Delimiter = '" + lsDiskEraseDelim + "'not found" )
				end if			
					
			End Choose
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//From Project

			//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
			lsLogOut =  '      - From Project: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				//TimA 12/27/12 Pandora issue #553 If the From or To Po_No has "Quarantine" or "GPNREVIEW" then don't process the Auto SOC
				//TimA Add RECHARGE 07/09/13
				//TimA Added RESEARCH 09/27/13 Pandora #648
				//dts 11/14/13 added 'EXPIRED' 
				//TimA 03/07/14 added WHITEBOX
				//TimA 04/28/14 added HPBUYBACK

				//TimA 05/19/14 Pandora issue #852 Removed the hard coded search of projects that are skipped from Auto SOC and have this come from the lookup table.
				//Look in the string (created above) for the project.
				//TimA 10/16/14 Bug found.  Should have been > 0 not > 1
				If pos ( ls_SkipSOCProj, Upper(lsTemp ), 1 ) > 0 then
				//Remove the If Condition
				//If Upper(lsTemp) = 'QUARANTINE' or Upper(lsTemp) = 'GPNREVIEW' or Upper(lsTemp) = 'RECHARGE' or Upper(lsTemp) = 'RESEARCH' or Upper(lsTemp) = 'EXPIRED' or Upper(lsTemp) = 'WHITEBOX' or Upper(lsTemp) = 'HPBUYBACK'   then 
					lbSkipAutoSOC = True
				End if
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'From Project' field. Record will not be processed.")
				lbDetailError = True
			End If						

			idsTODetail.SetItem(llNewDetailRow, 'PO_NO', Trim(lsTemp))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			lsFromProject = lsTemp

//To Project
			//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
			lsLogOut =  '      - To Project: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				//TimA 12/27/12 Pandora issue #553 If the From or To Po_No has "Quarantine" or "GPNREVIEW" then don't process the Auto SOC
				//TimA 07/09/13 Added RECHARGE
				//TimA Added RESEARCH 09/27/13 Pandora #648	
				//dts 11/14/2013 added EXPIRED (re-added 01/15/14. Not sure why wasn't in current version)
				//TimA 03/07/14 added WHITEBOX
				//TimA 04/28/14 added HPBUYBACK

				//TimA 05/19/14 Pandora issue #852 Removed the hard coded search of projects that are skipped from Auto SOC and have this come from the lookup table.
				//Look in the string (created above) for the project.
				//TimA 10/16/14 Bug found.  Should have been > 0 not > 1
				If pos ( ls_SkipSOCProj, Upper( lsTemp ), 1 ) > 0  then
				//Remove the If Condition
				//If Upper(lsTemp) = 'QUARANTINE' or Upper(lsTemp) = 'GPNREVIEW' or Upper(lsTemp) = 'RECHARGE' or Upper(lsTemp) = 'RESEARCH' or Upper(lsTemp) = 'EXPIRED' or Upper(lsTemp) = 'WHITEBOX'  or Upper(lsTemp) = 'HPBUYBACK'   then 
					lbSkipAutoSOC = True
				End if				
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'To Project' field. Record will not be processed.")
				lbDetailError = True
			End If						

			idsTODetail.SetItem(llNewDetailRow, 'New_PO_NO', Trim(lsTemp))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			lsToProject = lsTemp
			
			//Jxlim 11/15/2011 BRD #302 Do not process SOC when the project is Research to Research
			If 	lsFromProject = 'RESEARCH'  and lsToProject = 'RESEARCH' Then     
				//dts 5/2/2014 - only skipping 'RESEARCH' SOC if From/To owner are the same...
				if lsFromOwnerCD = lsToOwnerCD then
					//Jxlim 11/17/2011 Remove error message BRD #302
					//gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - From Research To Research are in the same project changed. SOC will not be  processed.")
					//dts - 5/2/2014 added log message to aid in investigating an SOC that doesn't process.
					lsLogOut =  '  - !!! FROM and TO Project are RESEARCH - Not processing SOC'
					FileWrite(giLogFileNo,lsLogOut)
					Return -1
				end if
			End If

//From/To Inventory Types...
/*  - 10/09 - For RMA, need to set From/To Inventory Type based on From/To Project.
				 Defaulted it to 'N' (above) and set here according to RMA Rules 
				 Basically, Project MRB uses InvType 'M' (MRB) and Projects RTV-IN/RTV-Out use 'R' (RTV)

				 May also have to set Owner on receipt if return from vendor specifes RTV Owner Code
				 That implies it wasn't dispositioned at the time of file creation and Needes to either be Hwops (if Project=RTV-In) or Decom (RTV-Out)*/
				 
			// RMA has different Inventory_Type rules based on Project (po_no)...
			// - assuming RTV-IN/Out and MRB are exclusive to RMA movements...
			//if lsGroup = 'RMA' then
			Choose Case upper(lsSOC_variant) 
				case 'DISKERASE', 'HWOPS'  // 06/11/2010 ujh:  not relavant for these variants
					
				case else
					if lsFromProject = 'RTV-IN' or lsFromProject = 'RTV-OUT' then
						idsTODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'R') /* RTV */
					//elseif lsProject = 'SCRAP' then
					//	idsTODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'S') 
// ET3 2012-12-06 Pandora 545 - no longer track by MRB inventory type
//					elseif lsFromProject = 'MRB' then
//						idsTODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'M')
					end if
	
					if lsToProject = 'RTV-IN' or lsToProject = 'RTV-OUT' then
						idsTODetail.SetItem(llNewDetailRow, 'New_Inventory_Type', 'R') /* RTV */
					//elseif lsProject = 'SCRAP' then
					//	idsTODetail.SetItem(llNewDetailRow, 'New_Inventory_Type', 'S') 
// ET3 2012-12-06 Pandora 545 - no longer track by MRB inventory type
//					elseif lsToProject = 'MRB' then
//						idsTODetail.SetItem(llNewDetailRow, 'New_Inventory_Type', 'M')
					end if
			end choose
			//end if

//Line Number
			//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
			lsLogOut =  '      - Processing Line Number: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If		

			If Not isnumber(lsTemp) Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - 'Line Item' is not numeric. Record will not be processed.")
				lbDetailError = True
			Else
				idsTODetail.SetItem(llNewDetailRow, 'Line_Item_No', dec(Trim(lsTemp)))
				// LTK 20110429 Pandora #205 - SOC Multiline Fix
				idsTODetail.SetItem(llNewDetailRow, 'User_Line_Item_No', dec(Trim(lsTemp)))
			End If
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//Qty
			//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
			lsLogOut =  '      - Processing Qty: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If		
			If Not isnumber(lsTemp) Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - 'Qty' is not numeric. Record will not be processed.")
				lbDetailError = True
			Else
				idsTODetail.SetItem(llNewDetailRow, 'Quantity', dec(trim(lsTemp)))
			End If
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
			 //Jxlim 06/10/2011 get cycle count order no cc_no from file, we need to pass 3 pipies to get the cc_no
			//cc_no (system no) 	
			//''|'
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then					
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//			Else /*error*/
//			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Place holder. Record will not be processed.")
//			lbDetailError = True
			End If		
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//''|'			
			If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
//			Else /*error*/
//			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Place holder. Record will not be processed.")
//			lbDetailError = True
			End If		
				
			//Cycle Count system number cc_no
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
			lsTemp = Upper(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			ls_ccno = trim(lsTemp)  				
			Else /*error*/
//			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order No' field. Record will not be processed.")
//			lbDetailError = True
			End If								
												
			//cc_no cycle count line_item_no (This line item was found from cc_inventory where there is a difference.
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
			lsTemp = Upper(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			ls_ccline = trim(lsTemp)  				
			Else /*error*/
//			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Cycle Count Line Item No' field. Record will not be processed.")
//			lbDetailError = True
			End If		
				
			//Jxlim 07/28/2011 Passing the ls_ccno and ls_ccline to sp to process the cc auto soc
			ll_ccline =	Long(ls_ccline)					
						
		Case Else /* Invalid Rec Type*/
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
			
			//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
			lsLogOut = "      - Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed."
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			Continue
		
	End Choose /*record Type*/
	
Next /*File record */
	
//Save the Changes 
If lbError Then 
	Return -1
Else
	//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem  - Note this should be only temporary
	lsLogOut = '      - Saving Header Record: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
	lirc = idsTOHeader.Update()
	
	If liRC = 1 Then
		//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
		lsLogOut = '      - Saving Detail Record: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		
		liRC = idsTODetail.Update()
	End If
End If
	
If liRC = 1 then
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// 01/17/2010  ujh Owner Change Fix 4 of 5
	// 01/17/2010 ujh:  If lsDelete_List contains data, then  we need to delete from Transfer_Detail and Transfer_Detail_Content
	//                              followed by delete from Transfer_Master records where TO_No is in  lsDelete_List,
	//						  as at least one "new" record was found and has been replaced
	if len(lsDelete_List) > 0 then
		// Stirp of leading comma
		lsDelete_List =  right(lsDelete_List, len(lsDelete_List) - 1)
		DELETE FROM Transfer_Detail_Content  WHERE TO_No in  (:lsDelete_List)   USING sqlca;
		if sqlca.sqlcode<> 0 then
			GOTO RollbackAll
		end if
		DELETE FROM Transfer_Detail  WHERE TO_No in  (:lsDelete_List)   USING sqlca;
		if sqlca.sqlcode<> 0 then
			GOTO RollbackAll
		end if
		DELETE FROM Transfer_Master  WHERE TO_No in  (:lsDelete_List)   USING sqlca;
		// At least one row should be deleted.  Did not do this for detail, as there can be cases where there is no detail record.
		if sqlca.sqlcode<> 0  or sqlca.sqlnrows < 1 then
			GOTO RollbackAll
		end if
	end if
	// 01/17/2010  ujh END Owner Change Fix 4 of 5
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	 Commit;
	if not lbSkipAutoSOC then
		//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
		lsLogOut = '      - Begin the Auto SOC Process: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// 0208/2010 ujh:  call to stored procedure for Auto Stock Owner Change  and DiskErase
		// After all processing is done, now go and see if any records can be auto completed.
		 lbSQLCAauto = SQLCA.AutoCommit
		SQLCA.AutoCommit = true  // Control of Transaction processing in Stored Procedure
	
		// Get the segments to send to the stored procedure if more than one was created when lsRecDataSOC was populated
		lsTemp2 = lsRecDataSOC
		String ls_test, ls_test2  //TimA for Testing results
		String ls_method_trace
		
		Do While len(lsTemp2) > 0
			lsTemp = Left(lsTemp2,(pos(lsTemp2,lsParamSeperator) -1))
			if len(lsTemp) = 0 then
				lsTemp = lsTemp2
			End if
			//TimA 06/13/12 Take off the | pipe
			ls_method_trace = Upper(Left(lsTemp,(pos(lsTemp,'|') - 1)))			
			lsTemp2 = Right(lsTemp2,(len(lsTemp2) - (Len(lsTemp) + Len(lsParamSeperator)))) /*strip off to next Segment */
			choose case upper(lsSOC_variant)
				case 'DISKERASE'
					//TimA 12/01/11 Write out to the log file that you are about to do the Auto SOC.
					//This is for testing to find out why some file don't auto SOC
					lsLogOut = '      - Processing PANDORA Diskerase Auto SOC: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
					
				//ls_test = 'O' + "," +  lsTemp + "," +  lsReturnTxt + "," +  String(llReturnCode) + "," +  String(llCntReceived) + "," +  String(llCntIgnored) + "," +  lsListIgnored + "," +  String(llCntProcessed) + "," +  lsListProcessed
				
				//f_method_trace( asproject, this.ClassName() + ' - uf_process_to_rose', 'Start Sp_Auto_SOC_DiskErase Stored Procedure' ,ls_method_trace, isFileName)
				//TimA 03/04/13 Added new/modified method trace logic
				f_method_trace_special( asproject, this.ClassName() + ' - uf_process_to_rose', 'Start Sp_Auto_SOC_DiskErase Stored Procedure',lsToNo, isFileName,'',ls_method_trace)
				
				sqlca.Sp_Auto_SOC_DiskErase('O', lsTemp, lsReturnTxt, llReturnCode, llCntReceived, llCntIgnored, lsListIgnored, llCntProcessed, lsListProcessed)
				
				//f_method_trace( asproject, this.ClassName() + ' - uf_process_to_rose', 'End Sp_Auto_SOC_DiskErase Stored Procedure' ,ls_method_trace, isFileName)
				//TimA 03/04/13 Added new/modified method trace logic
				f_method_trace_special( asproject, this.ClassName() + ' - uf_process_to_rose', 'End Sp_Auto_SOC_DiskErase Stored Procedure' ,lsToNo, isFileName,'',ls_method_trace)				
				
				//TimA Just for testing results remove later
				//ls_test2 = 'O' + "," +  lsTemp + "," +  lsReturnTxt + "," +  String(llReturnCode) + "," +  String(llCntReceived) + "," +  String(llCntIgnored) + "," +  lsListIgnored + "," +  String(llCntProcessed) + "," +  lsListProcessed
				//case 'HWOPS'
				//sqlca.sp_Auto_HWOPS_InvTypeProj('O', lsTemp, lsReturnTxt, llReturnCode, llCntReceived, llCntIgnored, lsListIgnored, llCntProcessed, lsListProcessed)				
				case else
					//Jxlim 07/07/2011 BRD #233 If a cycle count call cc auto soc sp  (This OCR created by SIMS with cycle count information)
					If  Trim(ls_ccno) > "" Then
						//Jxlim 07/28/2011 Commented out setting value before trigger sp, passing the ls_ccno and ls_ccline to sp to process the cc auto soc
						//sqlca.Sp_Auto_SOC_CC('O', lsTemp, lsReturnTxt, llReturnCode, llCntReceived, llCntIgnored, lsListIgnored, llCntProcessed, lsListProcessed)

						//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
						lsLogOut = '      - Start Auto SOC_CC Process: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
						FileWrite(giLogFileNo,lsLogOut)
						gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
						
						sqlca.Sp_Auto_SOC_CC('O', lsTemp, ls_ccno, ll_ccline, lsReturnTxt, llReturnCode, llCntReceived, llCntIgnored, lsListIgnored, llCntProcessed, lsListProcessed)
						
						//TimA Just for testing results remove later						
						ls_Test = 'O' + "," +  lsTemp + "," + ls_ccno + "," +  String(ll_ccline) + "," + String(llReturnCode) + "," +  String(llCntReceived) + "," +  String(llCntIgnored) + "," +  lsListIgnored + "," +  String(llCntProcessed) + "," +  lsListProcessed
					Else
						//goto skipAUTOSOC  //06/17/2010 ujh:   Quick fix to prevent use prior to going live in production
						
						//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
						
						lsLogOut = '      - Start Auto SOC Process: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
						FileWrite(giLogFileNo,lsLogOut)
						gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
						
						//f_method_trace( asproject, this.ClassName() + ' - uf_process_to_rose', 'Start Auto SOC Stored Procedure' ,ls_method_trace, isFileName)
						//TimA 03/04/13 Added new/modified method trace logic
						f_method_trace_special( asproject, this.ClassName() + ' - uf_process_to_rose', 'Start Auto SOC Stored Procedure' ,lsToNo, isFileName,'',ls_method_trace)										
						//Aliased - the SP name is dbo.sp_auto_stockowner_change
						ls_Test = 'O' + "," +  lsTemp + "," + ls_ccno + "," +  String(ll_ccline) + "," + String(llReturnCode) + "," +  String(llCntReceived) + "," +  String(llCntIgnored) + "," +  lsListIgnored + "," +  String(llCntProcessed) + "," +  lsListProcessed						
						sqlca.Sp_Auto_SOC('O', lsTemp, lsReturnTxt, llReturnCode, llCntReceived, llCntIgnored, lsListIgnored, llCntProcessed, lsListProcessed)
						
						//f_method_trace( asproject, this.ClassName() + ' - uf_process_to_rose', 'End Auto SOC Stored Procedure ' + lsReturnTxt + 'Return code ' + String(llReturnCode),ls_method_trace, isFileName)
						//TimA 03/04/13 Added new/modified method trace logic
						f_method_trace_special( asproject, this.ClassName() + ' - uf_process_to_rose', 'End Auto SOC Stored Procedure ' + lsReturnTxt + 'Return code ' + String(llReturnCode),lsToNo, isFileName,'',ls_method_trace)																
						
						//TimA Just for testing results remove later												
						//ls_test = 'O' + "," + lsTemp + "," + String(llReturnCode) + "," + String(llCntReceived) + "," + String(llCntIgnored) + "," + lsListIgnored + "," + String(llCntProcessed) + "," + lsListProcessed
						//FileWrite(giLogFileNo,ls_test)
						//gu_nvo_process_files.uf_write_log(ls_test) /*write to Screen*/
						
					End If
					//skipAUTOSOC:
			//end if
			End Choose
			
			If SQLCA.SQLCode = -1 Then
				//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
				//f_method_trace( asproject, this.ClassName() + ' - uf_process_to_rose', 'SQL System Error Occured' ,ls_method_trace, isFileName)
				//TimA 03/04/13 Added new/modified method trace logic
				f_method_trace_special( asproject, this.ClassName() + ' - uf_process_to_rose', 'SQL System Error Occured' ,lsToNo, isFileName,'',ls_method_trace)																
						
				lsLogOut = '      - SQL System Error Occured: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,lsLogOut + "  " + SQLCA.SqlerrText)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/			
				gu_nvo_process_files.uf_writeError("- ***System  Error!:   "+SQLCA.SqlerrText)  // ujhTODO  Get further requirements def.   "Some Database problem--likely only the type that will happen during development."
				Return -1
			ELSE
				/* 06/24/2010:  Per discussion with Trey, remove error for AutoSoc so OPS does not see that order did not process.  The order will still be in new
					status, so for Auto SOC that is desired.  */
				choose case upper(lsSOC_variant)
					case 'DISKERASE'
						// Get Return Codes.  
						if llReturnCode < 0 Then
							//f_method_trace( asproject, this.ClassName() + ' - uf_process_to_rose', 'Diskerase Auto SOC Failed' ,ls_method_trace, isFileName)
							//TimA 03/04/13 Added new/modified method trace logic
							f_method_trace_special( asproject, this.ClassName() + ' - uf_process_to_rose', 'Diskerase Auto SOC Failed' ,lsToNo, isFileName,'',ls_method_trace)																							
							//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
							lsLogOut = '      - Diskerase Auto SOC Failed: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
							FileWrite(giLogFileNo,lsLogOut)
							gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/										
							
							gu_nvo_process_files.uf_writeError("- ***Disk Erase Proccessing Error!:   "+ lsReturnTxt)  // ujhTODO  Not sure yet whether this will be exactly this way untill further requirements."
							Return -1
						end if
					Case Else
						//TimA 10/12/11  Added this because there was no errors being recorded if a SOC failed
						//TimA 10/18/11 added and (ldFromOwnerID = ldToOwnerID)
						if llReturnCode < 0 and (ldFromOwnerID = ldToOwnerID) Then
							//f_method_trace( asproject, this.ClassName() + ' - uf_process_to_rose', 'Auto SOC Failed' ,ls_method_trace, isFileName)
							//TimA 03/04/13 Added new/modified method trace logic
							f_method_trace_special( asproject, this.ClassName() + ' - uf_process_to_rose', 'Auto SOC Failed' ,lsToNo, isFileName,'',ls_method_trace)																														
							
							//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
							lsLogOut = '      - Auto SOC Failed: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
							FileWrite(giLogFileNo,lsLogOut)
							gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/										
							
							//TimA Remove ls_Test when done testing
							gu_nvo_process_files.uf_writeError("- ***Auto Complete SOC Failed!:   "+ lsReturnTxt + " -> " + ls_test)  
							Return -1
							
						ElseIf llReturnCode < 0 then
							lsLogOut = '      - Auto SOC Failed: '  + String(Today(), "mm/dd/yyyy hh:mm:ss") + ' No Error File Written.  Check the Method Trace Log'
							FileWrite(giLogFileNo,lsLogOut)
							gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/	
							
							//f_method_trace( asproject, this.ClassName() + ' - uf_process_to_rose', 'Auto SOC Failed for From Owner ID: ' + String(ldFromOwnerID) + ' and To Owner ID: ' + String(ldToOwnerID) ,ls_method_trace, isFileName)
							//TimA 03/04/13 Added new/modified method trace logic
							f_method_trace_special( asproject, this.ClassName() + ' - uf_process_to_rose', 'Auto SOC Failed for From Owner ID: ' + String(ldFromOwnerID) + ' and To Owner ID: ' + String(ldToOwnerID) ,lsToNo, isFileName,'',ls_method_trace)
						end if						
				End Choose
			End if
		Loop	
		SQLCA.AutoCommit = lbSQLCAauto  //Reset SQLCA's Transaction Processing
		//f_method_trace( asproject, this.ClassName() + ' - uf_process_to_rose', 'Auto SOC Completed' ,ls_method_trace, isFileName)
		//TimA 03/04/13 Added new/modified method trace logic
		f_method_trace_special( asproject, this.ClassName() + ' - uf_process_to_rose', 'Auto SOC Completed' ,lsToNo, isFileName,'',ls_method_trace)		
		 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end if	 
Else
	// 01/17/2010  ujh Owner Change Fix  5 of 5:  need this label
	RollbackAll:
	Rollback;
	//f_method_trace( asproject, this.ClassName() + ' - uf_process_to_rose', 'System Error!  Unable to Save new TO Records to database!' ,ls_method_trace, isFileName)
	//TimA 03/04/13 Added new/modified method trace logic
	f_method_trace_special( asproject, this.ClassName() + ' - uf_process_to_rose', 'System Error!  Unable to Save new TO Records to database!' ,lsToNo, isFileName,'',ls_method_trace)			
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new TO Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new TO Records to database!")
	Return -1
End If

Return 0


end function

public function integer uf_process_cityblock_so (string aspath, string asproject);//Process Sales Order files for Cityblock

Datastore	ldsDOHeader, ldsDODetail, 	lu_ds
				
String		lsLogout, lsRecData, lsTemp,lsErrText, lsSKU, lsSKUSave,  lsSupplier,	lsFind,	&
			 lsOrderNo, lsOrderSave, lsWarehouse, lsCustCode, lsRectype, lsOwnerCode



Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos, llNewRow, llCount, llQty,   	 llBatchSeq, llOrderSeq, llLineSeq,  llRC, llNewDetailRow, llOwnerID
				
Decimal		ldQty
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError


ldtToday = DateTime(today(),Now())


lu_ds = Create datastore
lu_ds.dataobject = 'd_import_generic_csv'

ldsDOHeader = Create u_ds_datastore
ldsDOHeader.dataobject = 'd_shp_header'
ldsDOHeader.SetTransObject(SQLCA)

ldsDODetail = Create u_ds_datastore
ldsDODetail.dataobject = 'd_shp_detail'
ldsDODetail.SetTransObject(SQLCA)

//Open and read the File In - Importing CSV file
lsLogOut = '      - Opening File for PAndora Cityblock Delivery Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

llRC = lu_ds.ImportFile(csv!,asPath) 




//Process each row of the File
llRowCount = lu_ds.RowCount()

lsLogOut = '      - ' + String(llRowCount) + '  Records retrieved for processing...'
FileWrite(giLogFileNo,lsLogOut)

For llRowPos = 1 to llRowCount
	
	
	
	
	Choose Case Trim(lu_ds.getITemString(llRowPos, 'column1')) /*rec Type */
			
		Case 'DM' /*Header*/
				
			//Get the next available file sequence number
			llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
			If llBatchSeq <= 0 Then Return -1
			
			lsOrderNo = "SYS-" + String(llBatchSeq,'0000000') /* SYS- will assign the order number based on the DO_NO when the order is built. If we use the Seq Number here we will get duplicate order numbers at some point*/

			llNewRow = 	ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			ldsDOHeader.SetItem(llNewRow, 'project_id',asProject)
			ldsDOHeader.SetItem(llNewRow, 'action_cd','A')
			ldsDOHeader.SetItem(llNewRow, 'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow, 'order_seq_no',llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow, 'ftp_file_name',asPath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow, 'Status_cd','N')
			ldsDOHeader.SetItem(llNewRow, 'Last_user','SIMSEDI')
			ldsDOHeader.SetItem(llNewRow, 'Order_type', 'C') /*Order Type = Cityblock - Shp to Driversr */
			ldsDOHeader.SetItem(llNewRow, 'Inventory_Type','Z') /*default to CB Erased*/
			ldsDOHeader.SetItem(llNewRow,'invoice_no',lsOrderNo)
			ldsDOHeader.SetItem(llNewRow,'cust_Code',"CB-DRIVER") /*generic Cust Code for drivers*/
			ldsDOHeader.SetItem(llNewRow,'User_Field7',"MATERIAL TRANSFER") /* Transaction Type */
			
			//OWner Hardcoded based on Warehouse
			Choose Case Upper(Trim(lu_ds.getITemString(llRowPos, 'column2')))
					
				Case "PND_LENOIR"
					lsOwnerCode = "WHNCLNCTY"
				Case "PND_DALLES"
					lsOwnerCode = "WHORDALCTY"
				Case "PND_BRUSSH"
					lsOwnerCode = "WHBEGHCTY"
				Case Else
					lsOwnerCode = ""
			End Choose
			
			If lsOwnerCode > '' Then
				
				Select Owner_id into :llOwnerID
				From Owner
				Where Project_id = 'Pandora' and owner_type = 'C' and Owner_cd = :lsOwnerCode;
				
			Else
				llOwnerID = 0
			End If
			
			
			//From File
			
			ldsDOHeader.SetItem(llNewRow,'wh_Code',Trim(lu_ds.getITemString(llRowPos, 'column2')))
			ldsDOHeader.SetItem(llNewRow,'cust_name',Trim(lu_ds.getITemString(llRowPos, 'column3')))
			ldsDOHeader.SetItem(llNewRow,'address_1',Trim(lu_ds.getITemString(llRowPos, 'column4')))
			ldsDOHeader.SetItem(llNewRow,'address_2',Trim(lu_ds.getITemString(llRowPos, 'column5')))
			ldsDOHeader.SetItem(llNewRow,'address_3',Trim(lu_ds.getITemString(llRowPos, 'column6')))
			ldsDOHeader.SetItem(llNewRow,'address_4',Trim(lu_ds.getITemString(llRowPos, 'column7')))
			ldsDOHeader.SetItem(llNewRow,'city',Trim(lu_ds.getITemString(llRowPos, 'column10')))
			ldsDOHeader.SetItem(llNewRow,'state',Trim(lu_ds.getITemString(llRowPos, 'column11')))
			ldsDOHeader.SetItem(llNewRow,'zip',Trim(lu_ds.getITemString(llRowPos, 'column9')))
			ldsDOHeader.SetItem(llNewRow,'Country',Trim(lu_ds.getITemString(llRowPos, 'column12')))
			ldsDOHeader.SetItem(llNewRow,'tel',Trim(lu_ds.getITemString(llRowPos, 'column13')))
			ldsDOHeader.SetItem(llNewRow,'email_address',Trim(lu_ds.getITemString(llRowPos, 'column14')))
			ldsDOHeader.SetItem(llNewRow,'ship_via',Trim(lu_ds.getITemString(llRowPos, 'column15')))
			ldsDOHeader.SetItem(llNewRow,'Carrier',Trim(lu_ds.getITemString(llRowPos, 'column16')))
			ldsDOHeader.SetItem(llNewRow,'Remark',Trim(lu_ds.getITemString(llRowPos, 'column17')))
			ldsDOHeader.SetItem(llNewRow,'User_Field11',Trim(lu_ds.getITemString(llRowPos, 'column18'))) /*UF11 = Requester Name*/
			ldsDOHeader.SetItem(llNewRow,'User_Field12',Trim(lu_ds.getITemString(llRowPos, 'column19'))) /*UF11 = Vehicle ID*/
						
		Case 'DD' /*Detail*/
			
			llNewDetailRow = 	ldsDODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			ldsDODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsDODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			ldsDODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsDODetail.SetItem(llNewDetailRow,'Inventory_Type', 'Z') /* Z = CB Erased */
			ldsDODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			ldsDODetail.SetItem(llNewDetailRow,"line_item_no",llLineSeq)
		
			//From File
			ldsDODetail.SetItem(llNewDetailRow,'Invoice_No',lsOrderNo)
			ldsDODetail.SetItem(llNewDetailRow,'SKU',Trim(lu_ds.getITemString(llRowPos, 'column2')))
			ldsDODetail.SetItem(llNewDetailRow,'quantity',String(Trim(lu_ds.getITemString(llRowPos, 'column3')))) 
			
			If llOwnerID > 0 Then
				ldsDODetail.SetItem(llNewDetailRow,'owner_id',String(llOwnerID))
			End If
		
	End Choose

Next /*File record */


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

public function integer uf_process_pandora_decom_mrb_aging_rpt (string asinifile, string asemail);
//Process the PANDORA DECOM MRB Aging Report
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
lds_Rpt.Dataobject = 'd_pandora_decom_mrb_aging_report'
lirc = lds_Rpt.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION:  PANDORA DECOM MRB Aging Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "PANDORA"

//Retrieve the Data
lsLogout = 'Retrieving PANDORA DECOM MRB Aging Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = lds_Rpt.Retrieve()

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '~t'
lsLogOut = 'Processing PANDORA DECOM MRB Aging Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//ls_Now = string(now(), 'yyyy-mm-dd hh:mm:ss')
//ls_PacificTime = string(GetPacificTime('GMT', datetime(today(), now())), 'yyyy-mm-dd hh:mm:ss')


lsFileName = 'PANODRA_DECOM_MRB_Aging_Report' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'

lsFileNamePath = ProfileString(asInifile, lsProject, "archivedirectory","") + '\' + lsFileName

lds_Rpt.SaveAs ( lsFileNamePath, Excel!	, true )

//Using entry in file instead of database email field. 
//Google DL did not work and too many names to fit in column.
	
gu_nvo_process_files.uf_send_email("PANDORA", "RMA_DECOM_REPORTS_EMAIL", "PANDORA DECOM MRB Aging Report - Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the PANDORA DECOM MRB Aging Report, run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)





Return 0
end function

public function integer uf_process_pandora_open_rma_po_rpt (string asinifile, string asemail);
//Process the PANDORA Open RMA PO Receipt Report


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
lds_Rpt.Dataobject = 'd_pandora_open_rma_po_receipt_report'
lirc = lds_Rpt.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION:  PANDORA Open RMA PO Receipt Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "PANDORA"

//Retrieve the Data
lsLogout = 'Retrieving  PANDORA Open RMA PO Receipt Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = lds_Rpt.Retrieve()

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '~t'
lsLogOut = 'Processing  PANDORA Open RMA PO Receipt Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//ls_Now = string(now(), 'yyyy-mm-dd hh:mm:ss')
//ls_PacificTime = string(GetPacificTime('GMT', datetime(today(), now())), 'yyyy-mm-dd hh:mm:ss')


lsFileName =  'PANDORA_Open_RMA_PO_Report' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'

lsFileNamePath = ProfileString(asInifile, lsProject, "archivedirectory","") + '\' + lsFileName

lds_Rpt.SaveAs ( lsFileNamePath, Excel!	, true )


//Using entry in file instead of database email field. 
//Google DL did not work and too many names to fit in column.
	
gu_nvo_process_files.uf_send_email("PANDORA", "RMA_DECOM_REPORTS_EMAIL", " PANDORA Open RMA PO Receipt Report - Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the  PANDORA Open RMA PO Receipt Report, run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)





Return 0
end function

public function integer uf_process_so_rose_archive (string aspath, string asproject);// This is an Archive (from production) on 11/04/09 (before major changes were promoted at different stages of sdlc)

//Process Material Transfer (Sales Order) for PANDORA 

/* TODO - ? Use a structure for the Outbound Order data. Use two structure variables - 1 for WH and 1 for DC
     - maybe use a structure for customer too...
	  //str_Customer	lstr_Cust_DC, lstr_Cust_WH

	  
 * What about Notes / Remarks, etc (WH or DC outbound order?)?
 
 Put 2nd order in a 'Hold' status

*/
Datastore	ldsDOHeader, ldsDODetail, lu_ds, ldsDOAddress, ldsDONotes
				
String		lsLogout,lsRecData,lsTemp,	lswarehouse, lsErrText, lsSKU, lsRecType, &
				lsDate, ls_invoice_no, ls_Note_Type, ls_search, lsNotes, ls_temp, lsCommentDest,  &
				lsSoldToName, lsSoldToAddr1, lsSoldToAddr2, lsSoldToAddr3, lsSoldToAddr4, lsSoldToDistrict,	&
				lsSoldToZip, lsSoldToCity, lsSoldToState, lsSoldToCountry, lsNoteText, lsNoteType, lsAction

Integer		liFileNo,liRC, li_line_item_no, liSeparator
				
Long			llRowCount,	llRowPos,llNewRow, llNewDetailRow ,llOrderSeq,	llBatchSeq,	llLineSeq,llCount,		&
				llCONO, llRoNO, llLineItemNo, llOwner, llNewAddressRow, llNewNotesRow, llNoteSeq, llNoteLine, li_find
				
Decimal		ldQty, ldPrice
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError, lbSoldToAddress 
string 		lsInvoice, lsPrevInvoice, lsCustNum, lsPrevInvoice_Detail,  lsOrder
integer 		i, liBTAddr, liBOLNote
string			lsOwnerCD, lsOwnerCD_Prev, lsOwnerID, lsWH
string	         lsCustName, lsAddr1, lsAddr2, lsCity, lsState, lsZip, lsCountry, lsTel, lsCustType
string			lsBB, lsSFCustType, lsFromProject, lsToProject, lsSF_LocalWHLoc, lsRequestor, lsRemark, lsLine, lsQty, lsContainer 
//lsLocalWHDECOM, lsLocalWHRTV, lsLocalWHOSV, lsIntermediateOwner
long			llBatchSeqPO, llNewRowPO, llNewRowPODetail, llBatchSeqSO_2, llNewRowSO_2, llNewRowSODetail_2, llTempRow
boolean		lbNoOutbound
string			lsSTCust, lsSTCustType, lsST_LocalWHLoc, lsST_LocalWHLoc_Prev, lsOwnerID_2, lsWH_2, lsFinalOrigin, lsST_Group, lsProject_Hardcode 
integer		liStart, liEnd

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
ldsDOAddress.dataobject = 'd_mercator_do_address' //Delivery_Alt_Address
ldsDOAddress.SetTransObject(SQLCA)

ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes'
ldsDONotes.SetTransObject(SQLCA)

/*for DECOM, the 3B18 is for movement from a DC to a WH
 - we don't control inventory at the DC so we're creating an inbound order from DC to Local WH, and an outbound order to final destination (if necessary) 
   For RMA, the final destination may be a customer or even a DC.
    - In the case of a DC, we must ship to the associated WH 1st, then to the DC
	 (so, from DC to Local WH, Local WH to remote WH, from remote WH to remote DC (total of 4 orders - 2 inbound and 2 outbound)) 
   For Multi-stage (actually for HWOPS), the Project for the intermediate stop needs to be governed by the customer's UF10 field....
	- if it's going from Project 'X' to Project 'Y', receive into the intermediate stop based on Customer.UF10 (if present)
	 
	 */
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

If Not isvalid(idsRONotes) Then
	idsRONotes = Create u_ds_datastore
	idsRONotes.dataobject = 'd_mercator_ro_notes'
	idsRONotes.SetTransObject(SQLCA)
End If

idsPoheader.Reset()
idsPODetail.Reset()
idsRONotes.Reset()

//Open the File
lsLogOut = '      - Opening File for Pandora Material Transfer (Sales Order) Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath, LineMode!, Read!, LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for PANDORA Material Transfer Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo, lsRecData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow, 'rec_data', lsRecData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

//Get the next available file sequence number
// 03/09 llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Outbound_Header', 'EDI_Batch_Seq_No')
// 03/09 -  using edi_INbound_header because web does and it will crash when trying to re-use a sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = lu_ds.RowCount()

/* DECOM/RMA - See if this is a multi-stop order requiring a receipt into a warehouse first.
     - we need to scroll through the records until we find a detail, then check the owner (ship-from) to see if it's a DC
	 - Supposed to be just a single Order in the file. */
For llRowPos = 1 to llRowCount
	lsRecData = Trim(lu_ds.GetItemString(llRowPos, 'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	Choose Case lsRecType
		Case 'DM' /* Header */
			//Customer: 5th field in DM record
			i = 1
			liStart = 1
			do while i < 5
				liStart = pos(lsRecData, '|', liStart) +1
				i += 1
			loop
			liEnd = pos(lsRecData, '|', liStart)
			lsSTCust = Mid(lsRecData, liStart, liEnd - liStart)
			
			/* 07/22/09 - Now Need to look up Ship-To Customer type to see if it is a DC...
			    ( then use UF4 to find local WH sub-inventory location owner) 
				
			 **08/10 - now we want to ship to some customers via a different WH
				- using UF4 to turn on this functionality, instead of Customer Type. If there's data in UF4....
			 * 08/20/09 - now grabbing UF1 to test group (DECOM and RMA have different rules) */
			select customer_type, user_field4, user_field1 into :lsSTCustType, :lsST_LocalWHLoc, :lsST_Group
			from customer
			where project_id = 'PANDORA'
			and cust_code = :lsSTCust;
			
			// - Throw error message if Customer is not in Customer_Master
			if isnull(lsSTCustType) or lsSTCustType = '' then
				lbError = True
				gu_nvo_process_files.uf_writeError("Invalid Customer Code specified (" + lsSTCust +")! Record will not be processed.")
			end if

			//if lsSTCustType = 'DC' then
			if lsST_LocalWHLoc > '' then
//Only need to create 2nd order if Ship-To's Local WH is not the Ship-From WH-Loc...
// - what about if it's in the same building??? Per Ian, only a single order (Pandora doesn't want the owner change 1st)
// - What if it's changing PROJECT???
				//Get the next available file sequence number for the 2nd Outbound Order (from Destination WH to Destination DC
	//			llBatchSeqSO_2 = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
	//			If llBatchSeqSO_2 <= 0 Then Return -1

				// - Throw error message if lsST_LocalWHLoc is not populated (and a valid owner?)
				if isnull(lsST_LocalWHLoc) or lsST_LocalWHLoc = '' then
					lbError = True
					gu_nvo_process_files.uf_writeError("Ship-to DC Location '" + lsSTCust + "' does not have the associated WH Location set up in Customer Maintenance. Record will not be processed.")
				end if
				
				//below, we'll compare Ship-To and IntermediateOwner. If the same, we won't create OUTBOUND order
				
			end if
		Case 'DD' /*Detail */
			//Sub-Inv (Owner): 11th field in DD record
			//TO Project: 16th field in DD record
			i = 1
			liStart = 1
			do while i < 11
				liStart = pos(lsRecData, '|', liStart) + 1
				i += 1
			loop
			liEnd = pos(lsRecData, '|', liStart)
			lsOwnerCd = Mid(lsRecData, liStart, liEnd - liStart)
			/*Need to look up Owner's customer type to see if it is a DC...
			    (UF4 is the local WH's owner) */

			/* 07/14/09 - now assuming only a SINGLE Local WH Loc for any single DC Loc! */
//			select customer_type, user_field4, user_field5, user_field6 into :lsSFCustType, :lsLocalWHDECOM, :lsLocalWHRTV, :lsLocalWHOSV
			select customer_type, user_field4 into :lsSFCustType, :lsSF_LocalWHLoc
			from customer
			where project_id = 'PANDORA'
			and cust_code = :lsOwnerCD;
			
			//if this is shipping to a DC, compare the Ship-To DC's Local WH Loc to the Ship-From Owner...
			//If the origin is a DC, we need to check against the Ship-From DC's Local WH Loc, not the ship-from loc
			//if lsSTCustType = 'DC' then  //now shipping to some customers via a 'local wh'
			if lsST_LocalWHLoc > '' then
				// - What if it's changing PROJECT???
				if lsSFCustType = 'DC' then 
					lsFinalOrigin = lsSF_LocalWHLoc
				else
					lsFinalOrigin = lsOwnerCD
				end if
				if lsFinalOrigin <> lsST_LocalWHLoc then
					// - If it's in the same building... Per Ian, only a single order (Pandora doesn't want the owner change 1st)
					//Check the warehouse for both the Ship-From(lsOwnerCd) and the Intermediate (lsST_LocalWHLoc)....
					
					select user_field2 into :lsWH from customer 	where project_id = 'PANDORA'
					and cust_code = :lsFinalOrigin;
					if isnull(lsWH) or lsWH = '' then
						lbError = True
						gu_nvo_process_files.uf_writeError("Sub-Inventory Location '" + NoNull(lsFinalOrigin) + "' does not have an associated WH specified in Customer Maintenance. Record will not be processed.")
						//ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
					end if
			
				// need to grab uf10 to check to see if Project hard-code is in effect (for HWOPS, but open to anyone with data in uf10)
					select user_field2, user_field10 into :lsWH_2, :lsProject_Hardcode from customer 	where project_id = 'PANDORA'
					and cust_code = :lsST_LocalWHLoc;
					if isnull(lsWH_2) or lsWH_2 = '' then
						lbError = True
						gu_nvo_process_files.uf_writeError("Local WH Location '" + NoNull(lsST_LocalWHLoc) + "' does not have an associated WH specified in Customer Maintenance. Record will not be processed.")
					end if
				end if // lsFinalOrigin <> lsST_LocalWHLoc 
				
				if lsWH <> lsWH_2 then
					//Get the next available file sequence number for the 2nd Outbound Order (from Destination WH to Destination DC
					llBatchSeqSO_2 = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
					If llBatchSeqSO_2 <= 0 Then Return -1
				end if
			end if  //lsST_LocalWHLoc > ''

			// now get project....
			liStart = liEnd + 1
			i += 1
			do while i < 16
				liStart = pos(lsRecData, '|', liStart) + 1
				i += 1
			loop
			liEnd = pos(lsRecData, '|', liStart)
			lsToProject = Mid(lsRecData, liStart, liEnd - liStart)
			if lsST_LocalWHLoc > '' then
//TEMPO!				if lsProject_Hardcode > '' then
//					lsToProject_Intermediate = lsProject_Hardcode 
//				end if
			end if			

			if lsSFCustType = 'DC' then
				/* - Make sure we can count on 'DECOM' for Project on DECOM orders
					 - ...nope. now, per Pandora, a DC Loc is only mapped to a single WH Loc! */
					/*
					if lsToProject = 'RTV' then
						lsIntermediateOwner = lsLocalWHRTV
					elseif lsToProject = 'OSV' then
						lsIntermediateOwner = lsLocalWHOSV
					else
						lsIntermediateOwner = lsLocalWHDECOM
					end if
					*/	
				//lsIntermediateOwner = lsSF_LocalWHLoc
				
				//Get the next available file sequence number for the Inbound
				llBatchSeqPO = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
				If llBatchSeqPO <= 0 Then Return -1

				// - Throw error message if lsIntermediateOwner is not populated (and a valid owner?)
				if isnull(lsSF_LocalWHLoc) or lsSF_LocalWHLoc = '' then
					lbError = True
					gu_nvo_process_files.uf_writeError("Ship-From DC Location '" + lsOwnerCD + "' does not have the associated WH Location set up in Customer Maintenance. Record will not be processed.")
					//ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				end if
				
				//below, we'll compare Ship-To and IntermediateOwner. If the same, we won't create OUTBOUND order
			end if
			//llRowPos = llRowCount // no need to keep scrolling through records...			
	End Choose /*Header, Detail or Notes */	
Next /*file record */
/*for DECOM / RMA, we need to compare the Customer to the Intermediate WH
	- if it's the same, don't create the outbound order 
	- if it's a DC, we need to find the local WH and create a WH transfer and an outbound order to DC */


//Process each Row
For llRowPos = 1 to llRowCount
	//lsRecData = lu_ds.GetItemString(llRowPos, 'rec_data')
	lsRecData = Trim(lu_ds.GetItemString(llRowPos, 'rec_Data'))
		
	//Process header, Detail (sika..., or header/line notes) */
	//lsRecType = Upper(Mid(lsRecData,7,2))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	

	Choose Case lsRecType
		//HEADER RECORD
		Case 'DM' /* Header */
			llNewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			lbSoldToAddress = False

		//Record Defaults
			ldsDOHeader.SetItem(llNewRow, 'Action_cd', 'A') /*always a new Order*/
			ldsDOHeader.SetItem(llNewRow, 'project_id', asProject) /*Project ID*/
			ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow, 'ftp_file_name', aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow, 'Status_cd', 'N')
			ldsDOHeader.SetItem(llNewRow, 'order_Type', 'S') /*default to SALE. we'll set it to 'Z' later if appropriate */
			ldsDOHeader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
			/*notes		OSV (on site verification) --> RMA inv type (on outbound)
							if MRB, should be no Outbound( Ship-to should be the Local WH)
							
							receive all of these as MRB inventory type (non-pickable)
							ops will do an adjustment to a pickable inv type based on pandora disposition
			
			Need to set Order Type and Inventory Type based on Project
			All Inbounds among RTV, RTC, OSV, MRB, DECOM, SCRAP are Order 'Y - Intermediate Receipt' and 'M - MRB'
			Project	OrderType					InvType
			--------	----------------------		----------
			RTV 		X - ReturnToSupplier		R - RTV
			DECOM 	S - Sale						?Rework, S - Scrap
			MRB 		No outbound Order
			OSV 		Z - WHxFer					A - RMA
			*/
			if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
				if lsToProject = 'RTV' then //RTV, RTC, OSV, MRB, DECOM, SCRAP, 
					ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'R') /*Return - RTV*/
					ldsDOHeader.SetItem(llNewRow, 'Order_Type', 'X') 
				//elseif lsToProject = 'RTC' then
				//	ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'C') /*Return - RTC*/
				//	ldsDOHeader.SetItem(llNewRow, 'Order_Type', 'X') 
				elseif lsToProject = 'OSV' then
					ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'A') /*DECOM*/
					ldsDOHeader.SetItem(llNewRow, 'Order_Type', 'Z') 
				elseif lsToProject = 'DECOM' then
					ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'S') /*DECOM*/
					ldsDOHeader.SetItem(llNewRow, 'Order_Type', 'S') 
				else
						ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
				end if
			end if
						
			//if lsSTCustType = 'DC' then
			if llBatchSeqSO_2 > 0 then				 
				/* DECOM / RMA, Multi-Stage shipment.
				  - if Ship-To is a DC, we need to ship first to the Associated WH, then to the DC
					 (so we're creating two outbound orders) */
				llNewRowSO_2 = ldsDOHeader.InsertRow(0)
				//llOrderSeq ++
				//llLineSeq = 0
	
				//Record Defaults
				ldsDOHeader.SetItem(llNewRowSO_2, 'Action_cd', 'A') /*always a new Order*/
				ldsDOHeader.SetItem(llNewRowSO_2, 'project_id', asProject) /*Project ID*/
				ldsDOHeader.SetItem(llNewRowSO_2, 'order_Type', 'Y') /* new order type for Multi-stage shipments */
				if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
					if lsToProject = 'RTV' then //RTV, RTC, OSV, MRB, DECOM, SCRAP, 
						ldsDOHeader.SetItem(llNewRowSO_2, 'Inventory_Type', 'R') /*Return - RTV*/
						ldsDOHeader.SetItem(llNewRowSO_2, 'Order_Type', 'X') 
					//elseif lsToProject = 'RTC' then
					//	ldsDOHeader.SetItem(llNewRowSO_2, 'Inventory_Type', 'C') /*Return - RTC*/
					//	ldsDOHeader.SetItem(llNewRowSO_2, 'Order_Type', 'X') 
					elseif lsToProject = 'OSV' then
						ldsDOHeader.SetItem(llNewRowSO_2, 'Inventory_Type', 'A') /*DECOM*/
						ldsDOHeader.SetItem(llNewRowSO_2, 'Order_Type', 'Z') 
					elseif lsToProject = 'DECOM' then
						ldsDOHeader.SetItem(llNewRowSO_2, 'Inventory_Type', 'S') /*DECOM*/
						ldsDOHeader.SetItem(llNewRowSO_2, 'Order_Type', 'S') 
					else
							ldsDOHeader.SetItem(llNewRowSO_2, 'Inventory_Type', 'N') /*default to Normal*/
					end if
				else
					ldsDOHeader.SetItem(llNewRowSO_2, 'Inventory_Type', 'N') /*default to Normal*/
				end if
				ldsDOHeader.SetItem(llNewRowSO_2, 'edi_batch_seq_no', llBatchSeqSO_2) /*batch seq No*/ //????? why was this llNewRowSO_2 for the value????
				ldsDOHeader.SetItem(llNewRowSO_2, 'order_seq_no', 1)  // always one order in file...
				ldsDOHeader.SetItem(llNewRowSO_2, 'ftp_file_name', aspath) /*FTP File Name*/
				ldsDOHeader.SetItem(llNewRowSO_2, 'Status_cd', 'N') //Order is on 'Hold' until WH x-fer is received.
				ldsDOHeader.SetItem(llNewRowSO_2, 'Last_user', 'SIMSEDI')
			end if
		//From File			
//			ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
					
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
//  Change ID 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Action Code' field. Record will not be processed.")
			End If

			lsAction = lsTemp
			ldsDOHeader.SetItem(llNewRow, 'Action_cd', lsTemp)
			ldsDOHeader.SetItem(llNewRowSO_2, 'Action_cd', lsTemp)

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Delivery_Number
			//Material Transfer Number - mapped to Invoice
			If Pos(lsRecData,'|') > 0 Then
				lsInvoice = trim(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Material Transfer Number. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'Invoice_no', lsInvoice)
			// appending a '_2' for now (so not rejected when trying to 'Add')
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'Invoice_no', lsInvoice + '_2') 
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsInvoice) + 1))) /*strip off to next Column */

			If lsAction = 'U' Then  //IF the Action is "U"pdate We need to issue a delete and then an Add for the entire order
			//TODO!!! - what about Updates to the multi-stage orders???
				Select wh_Code into :lsWarehouse
				From Delivery_master
				Where project_ID = :asproject and Invoice_No = :lsInvoice;
	
				If lsWarehouse = "" Then
					lbError = True
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse: '" + lsTemp + "'. Order will not be processed.") 
				End If
			
				ldsDOheader.SetItem(llNewRow,'wh_Code',lsWarehouse)

				ldsDOHeader.SetItem(llNewRow, 'Action_cd', 'D') /*Delete */

				lsAction = 'A'
				//Get the next available file sequence number
				llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
				If llBatchSeq <= 0 Then Return -1

				llOrderSeq = 0 /*order seq within file*/

				llNewRow = ldsDOHeader.InsertRow(0)
				llOrderSeq ++
				llLineSeq = 0
				lbSoldToAddress = False

				//Record Defaults
				ldsDOHeader.SetItem(llNewRow, 'Action_cd', 'A') /*always a new Order*/
				ldsDOHeader.SetITem(llNewRow, 'project_id', asProject) /*Project ID*/
				ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
				ldsDOHeader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
				ldsDOHeader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
				ldsDOHeader.SetItem(llNewRow, 'ftp_file_name', aspath) /*FTP File Name*/
				ldsDOHeader.SetItem(llNewRow, 'Status_cd', 'N')
				ldsDOHeader.SetItem(llNewRow, 'order_Type', 'S') /*default to SALE. we'll set it to 'Z' later if appropriate */
				ldsDOHeader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
				ldsDOHeader.SetItem(llNewRow, 'Invoice_no', lsInvoice)
				ldsDOheader.SetItem(llNewRow,'wh_Code',lsWarehouse) //?
										
			End If //lsAction = 'U' 

//  Request Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'To' Location. Record will not be processed.")
			End If
			lsDate = Mid(lsTemp, 5, 2) + '/' + Mid(lsTemp,7, 2) + '/' + Left(lsTemp, 4)
			ldsDOHeader.SetItem(llNewRow, 'Request_Date', lsDate) 
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'Request_Date', lsDate) 

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Customer Code
			//'To' Location - mapped to Cust_Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'To' Location. Record will not be processed.")
			End If

			If IsNull(lsTemp) or Trim(lsTemp) = '' Then
				ldsDOHeader.SetItem(llNewRow, 'Cust_Code', 'GENERIC')
			Else	
				//ldsDOHeader.SetItem(llNewRow, 'Cust_Code', Trim(lsTemp))
				if llBatchSeqSO_2 > 0 then //need two outbound orders, 1st to WH, 2nd to DC
					ldsDOHeader.SetItem(llNewRow, 'Cust_Code', Trim(lsST_LocalWHLoc))
					ldsDOHeader.SetItem(llNewRowSO_2, 'Cust_Code', Trim(lsSTCust))
				else
					ldsDOHeader.SetItem(llNewRow, 'Cust_Code', Trim(lsTemp))
				end if
			End If
			/*for DECOM / RMA, we need to compare the Customer to the Intermediate WH
			   - if it's the same, don't create the outbound order */
			if lsTemp = lsSF_LocalWHLoc then
				lbNoOutbound = true
			end if
			// strip lsTemp from lsRecData before lsTemp is manipulated...
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			if llNewRowSO_2 > 0 then //need two outbound orders, 1st to WH, 2nd to DC
			    //set address info for 2nd outbound order (where final DC is customer)...
				//reset customer variables...
				lsCustName = ""; lsAddr1=""; lsAddr2=""; lsCity=""; lsState=""; lsZip=""; lsCountry=""; lsTel=""; lsCustType=""
				//grab customer information, if available....
				select Cust_name, Address_1, Address_2, City, State, Zip, Country, Tel, customer_type
				into :lsCustName, :lsAddr1, :lsAddr2, :lsCity, :lsState, :lsZip, :lsCountry, :lsTel, :lsCustType
				from customer
				where project_id = 'pandora'
				and cust_code = :lsSTCust;
				
				//change llNewRowSO_2 to llNewRow?
				ldsDOHeader.SetItem(llNewRowSO_2, 'Cust_Name', lsCustName)
				ldsDOHeader.SetItem(llNewRowSO_2, 'Address_1', lsAddr1)
				ldsDOHeader.SetItem(llNewRowSO_2, 'Address_2', lsAddr2)
				//ldsDOHeader.SetItem(llNewRowSO_2, 'Address_3',Trim(Mid(lsRecData,1058,40)))
				ldsDOHeader.SetItem(llNewRowSO_2, 'City', lsCity) 
				ldsDOHeader.SetItem(llNewRowSO_2, 'State', lsState) 
				ldsDOHeader.SetItem(llNewRowSO_2, 'Zip', lsZip) 
				ldsDOHeader.SetItem(llNewRowSO_2, 'Country', lsCountry) 
				ldsDOHeader.SetItem(llNewRowSO_2, 'tel', lsTel) 
				lsTemp = lsST_LocalWHLoc	// for looking up WH Address info	
			end if
			//set address for 1st (or only) outbound order
			//reset customer variables...
			lsCustName = ""; lsAddr1=""; lsAddr2=""; lsCity=""; lsState=""; lsZip=""; lsCountry=""; lsTel=""; lsCustType=""
			//grab customer information, if available....
			select Cust_name, Address_1, Address_2, City, State, Zip, Country, Tel, customer_type
			into :lsCustName, :lsAddr1, :lsAddr2, :lsCity, :lsState, :lsZip, :lsCountry, :lsTel, :lsCustType
			from customer
			where project_id = 'pandora'
			and cust_code = :lsTemp;
			
			ldsDOHeader.SetItem(llNewRow,'Cust_Name', lsCustName)
			ldsDOHeader.SetItem(llNewRow,'Address_1', lsAddr1)
			ldsDOHeader.SetItem(llNewRow,'Address_2', lsAddr2)
			//ldsDOHeader.SetItem(llNewRow,'Address_3',Trim(Mid(lsRecData,1058,40)))
			ldsDOHeader.SetItem(llNewRow,'City', lsCity) 
			ldsDOHeader.SetItem(llNewRow,'State', lsState) 
			ldsDOHeader.SetItem(llNewRow,'Zip', lsZip) 
			ldsDOHeader.SetItem(llNewRow,'Country', lsCountry) 
			ldsDOHeader.SetItem(llNewRow,'tel', lsTel) 
			
//moved above			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
//  Customer Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				If Len(trim(lsTemp)) > 0 Then
					ldsDOHeader.SetItem(llNewRow, 'Cust_Name', Trim(lsTemp))
				//else
				//	ldsDOHeader.SetItem(llNewRow, 'Cust_Name', ' ')
				End If
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Customer_PO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			ldsDOHeader.SetItem(llNewRow, 'order_no', Trim(lsTemp))
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'order_no', Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
/* Need to set correct record for these, depending on whether it is the DC or WH Address on order
      - use a new variable for the row and set it to either llNewRow or llNewRowSO_2 as appropriate.... */
//  ShipTo_ADDR1
			if llNewRowSO_2 > 0 then 
				llTempRow = llNewRowSO_2
			else
				llTempRow = llNewRow
			end if
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'Address_1', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_ADDR2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'Address_2', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_ADDR3
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'Address_3', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_ADDR4
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'Address_4', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_District *not used
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_Postal_Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'Zip', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

///  ShipTo_City
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'City', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_State
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'State', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  ShipTo_Country
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			// Only populate if data came from Interface
			If Len(lsRecData) > 0 Then
				ldsDOHeader.SetItem(llTempRow, 'Country', Trim(lsTemp))
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  SoldTo_Number *Not Used
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  SoldTo Name 
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToName = Left(lsRecData,(pos(lsRecData,'|') - 1))

			Else 
				lsSoldToName = lsRecData
			End If
			if Len(lsSoldToName) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToName) + 1))) /*strip off to next Column */


//  SoldTo_ADDR1 
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToAddr1 = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToAddr1 = lsRecData
			End If

			if Len(lsSoldToAddr1) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToAddr1) + 1))) /*strip off to next Column */

//  SoldTo_ADDR2
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToAddr2 = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToAddr2 = lsRecData
			End If
			
			if Len(lsSoldToAddr2) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToAddr2) + 1))) /*strip off to next Column */

//  SoldTo_ADDR3
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToAddr3 = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToAddr3 = lsRecData
			End If
			
			if Len(lsSoldToAddr3) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToAddr3) + 1))) /*strip off to next Column */

//  SoldTo_ADDR4
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToAddr4 = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToAddr4 = lsRecData
			End If
			
			if Len(lsSoldToAddr4) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToAddr4) + 1))) /*strip off to next Column */

//  SoldTo_District
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToDistrict = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToDistrict = lsRecData
			End If
			
			if Len(lsSoldToDistrict) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToDistrict) + 1))) /*strip off to next Column */

//  SoldTo_Postal_Code 
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToZip = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToZip = lsRecData
			End If
			
			if Len(lsSoldToZip) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToZip) + 1))) /*strip off to next Column */

//  SoldTo_City
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToCity = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToCity = lsRecData
			End If
			
			if Len(lsSoldToCity) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToCity) + 1))) /*strip off to next Column */

//  SoldTo_State 
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToState = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToState = lsRecData
			End If
			
		if Len(lsSoldToState) > 0 Then lbSoldToAddress = True
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToState) + 1))) /*strip off to next Column */

//  SoldTo_Country
			If Pos(lsRecData,'|') > 0 Then
				lsSoldToCountry = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsSoldToCountry = lsRecData
			End If
			
			if Len(lsSoldToCountry) > 0 Then lbSoldToAddress = True
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSoldToCountry) + 1))) /*strip off to next Column */

			If lbSoldToAddress Then
				//TODO - For DC to DC, do we need address records for the SO to the DC? (different BatchSeqNo)
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetItem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
		
				ldsDOAddress.SetItem(llNewAddressRow,'address_type','ST') /* Address Type*/
				ldsDOAddress.SetItem(llNewAddressRow,'Name',lsSoldToname) /* Name */
				ldsDOAddress.SetItem(llNewAddressRow,'address_1',lsSoldToaddr1) 
				ldsDOAddress.SetItem(llNewAddressRow,'address_2',lsSoldToaddr2) 
				ldsDOAddress.SetItem(llNewAddressRow,'address_3',lsSoldToaddr3) 
				ldsDOAddress.SetItem(llNewAddressRow,'address_4',lsSoldToaddr4) 
				ldsDOAddress.SetItem(llNewAddressRow,'City',lsSoldTocity)
				ldsDOAddress.SetItem(llNewAddressRow,'District',lsSoldTodistrict) 
				ldsDOAddress.SetItem(llNewAddressRow,'State',lsSoldTostate)
				ldsDOAddress.SetItem(llNewAddressRow,'Zip',lsSoldTozip) 
				ldsDOAddress.SetItem(llNewAddressRow,'Country',lsSoldTocountry)
				lbSoldToAddress = False
			End if

//  Supplier *not used * Defaulted Above
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Shipping Route *Not Used
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

///  Freight Terms
			//Shipping Terms - mapped to freight terms
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Material Transfer Terms. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'freight_terms', Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
//  User Field 7
			//User_Field7 - Transaction Type (passed back to Pandora in Inventory Transaction Confirmation)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Transaction Type' field. Record will not be processed.")
			End If						
			ldsDOheader.SetItem(llNewRow, 'User_Field7', lsTemp) 
			if llNewRowSO_2 > 0 then ldsDOheader.SetItem(llNewRowSO_2, 'User_Field7', lsTemp) 

			//TAM 07/01/2009 Added return replacement as order type 
			// TAM 2009/07/09 Remove the logic to create an inbound order for defective parts 
			//IF lsTemp =  'RETURN REPLACEMENT' Then
			//	ldsDOHeader.SetItem(llNewRow, 'order_Type', 'Y') /*Set Return Defective */
			//End If
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
//  User Field 8
//??? should we quit mapping this at the header level? I believe we're getting this at the detail level so not sure what the value is here...
			//'To' Project - mapped to User_Field8
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'To' Project. Record will not be processed.")
			End If
			ldsDOHeader.SetItem(llNewRow, 'User_Field8', Trim(lsTemp))
			//not setting UF8 on WH-DC order if llNewRowSO_2 > 0 then 
				
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
//  User Field 11
			//Requestor Name - 
			If Pos(lsRecData,'|') > 0 Then
				lsRequestor = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsRequestor = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow, 'user_field11', Trim(lsRequestor))
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'user_field11', Trim(lsRequestor))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsRequestor) + 1))) /*strip off to next Column */

//  User Field 10
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow, 'user_field10', Trim(lsTemp))
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'user_field10', Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Shipping Instructions
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow, 'shipping_instructions_text', Trim(lsTemp))
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'shipping_instructions_text', Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Remarks
//TAM 2009/08/25  - Moved Remarks to userfield 1 (They contain Service Levels)
			//Comments - mapped to remark
			If Pos(lsRecData,'|') > 0 Then
				lsRemark = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsRemark = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow, 'user_field1', Trim(lsRemark))
			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'user_field1', Trim(lsRemark))
//			ldsDOHeader.SetItem(llNewRow, 'remark', Trim(lsRemark))
//			if llNewRowSO_2 > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'remark', Trim(lsRemark))
			


//DECOM / RMA, Multi-Stage shipment. Create Inbound receipt from DC to 'local' WH...
			if lsSFCustType = 'DC' then
				llNewRowPO = idsPOHeader.InsertRow(0)
				//llOrderSeq ++
				//llLineSeq = 0
	
				//Record Defaults
				idsPOHeader.SetItem(llNewRowPO, 'Action_cd', 'A') /*always a new Order*/
				idsPOHeader.SetITem(llNewRowPO, 'project_id', asProject) /*Project ID*/
				idsPOHeader.SetItem(llNewRowPO, 'order_Type', 'Y') /* new order type for Multi-stage shipments */
				//setting inventory type to 'MRB' for RMA (project in RTV, OSV, MRB, DECOM, SCRAP?)
				if lsST_Group = 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
				    idsPOHeader.SetItem(llNewRowPO, 'Inventory_Type', 'N') /*default to Normal*/
				else
					// ET3 2012-12-06 Pandora 545 - no longer track by MRB inventory type
					//if lsToProject = 'RTV'  or lsToProject = 'OSV' or lsToProject = 'MRB' or lsToProject = 'DECOM' then 
					if lsToProject = 'RTV'  or lsToProject = 'OSV' or lsToProject = 'DECOM' then 
						idsPOHeader.SetItem(llNewRowPO, 'Inventory_Type', 'M') /* MRB */
					else
						idsPOHeader.SetItem(llNewRowPO, 'Inventory_Type', 'N') /*default to Normal*/
					end if
				end if
				idsPOHeader.SetItem(llNewRowPO, 'edi_batch_seq_no', llBatchSeqPO) /*batch seq No*/
				idsPOHeader.SetItem(llNewRowPO, 'order_seq_no', 1)  // always one order in file...
				idsPOHeader.SetItem(llNewRowPO, 'ftp_file_name', aspath) /*FTP File Name*/
				idsPOHeader.SetItem(llNewRowPO, 'Status_cd', 'N')
				idsPOHeader.SetItem(llNewRowPO, 'Last_user', 'SIMSEDI')
				
				idsPOheader.SetItem(llNewRow, 'order_no', lsInvoice) //Invoice from 3b18
				idsPOheader.SetItem(llNewRow, 'supp_code', 'PANDORA')  
				idsPOheader.SetItem(llNewRow, 'Arrival_Date', lsDate) //? is this date valid?
				//idsPOheader.SetItem(llNewRow,'Carrier', lsTemp)
				//idsPOheader.SetItem(llNewRow, 'remark', lsRemark)
				//TAM 2009/08/25  - Moved Remarks to userfield 1 (They contain Service Levels)
				idsPOheader.SetItem(llNewRow, 'User_Field1', lsRemark)
				idsPOheader.SetItem(llNewRow, 'User_Field3', lsOwnerCd)  /* UF3 - 'From' Location */	
				idsPOheader.SetItem(llNewRow, 'User_Field7', 'MATERIAL RECEIPT')  /* UF7 - PO Line Type */	
				//idsPOheader.SetItem(llNewRow, 'User_Field8', lsTemp)  /* UF8 - From Project */	
				//idsPOheader.SetItem(llNewRow, 'User_Field9', lsTemp)  /* UF9 Vendor Name */	
				//idsPOheader.SetItem(llNewRow, 'User_Field10', lsTemp)  /* UF10 Buyer Name */	
				idsPOheader.SetItem(llNewRow, 'User_Field11', lsRequestor)  /* UF11 Requestor Name */	
			end if //Ship-from is a DC
			
			if lbError then
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				ldsDOHeader.SetItem(llNewRow,'status_message','Custom Pandora Validation') /*Don't want to process this record in the next step*/
				if llNewRowSO_2  > 0 then 
					ldsDOHeader.SetItem(llNewRowSO_2,'status_cd','E') /*Don't want to process this header in the next step*/
					ldsDOHeader.SetItem(llNewRowSO_2,'status_message','Custom Pandora Validation') /*Don't want to process this record in the next step*/
				end if
			end if
		
		// DETAIL RECORD
		Case 'DD' /*Detail */
			llNewDetailRow = 	ldsDODetail.InsertRow(0)
			llLineSeq ++

		//Add detail level defaults
			ldsDODetail.SetITem(llNewDetailRow, 'supp_code', 'PANDORA') /* 2/14/09 */
			ldsDODetail.SetItem(llNewDetailRow, 'project_id', asproject) /*project*/
			ldsDODetail.SetItem(llNewDetailRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			ldsDODetail.SetItem(llNewDetailRow, 'order_seq_no', llOrderSeq) 
			ldsDODetail.SetItem(llNewDetailRow, "order_line_no", string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'N')
// 10/09 - per Ian, don't want to default Inv Type....
			//ldsDODetail.SetItem(llNewDetailRow, 'Inventory_type', 'N') /*normal inventory*/

			if lsSFCustType = 'DC' then
				if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
					if lsToProject = 'RTV' then
						ldsDODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'R') /*Return - RTV*/
					elseif lsToProject = 'OSV' then
						ldsDODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'A') 
					elseif lsToProject = 'DECOM' then
						ldsDODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'S') 
					else
						ldsDODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N') /*default to Normal*/
					end if
				end if
			end if
				
			//if lsSTCustType = 'DC' then
			if llBatchSeqSO_2 > 0 then
				/* DECOM / RMA, Multi-Stage shipment.
				  - if Ship-To is a DC, we need to ship first to the Associated WH, then to the DC
					 (so we're creating two outbound orders) */
				llNewRowSODetail_2 = ldsDODetail.InsertRow(0)
				//llLineSeq ++

			//Add detail level defaults
				ldsDODetail.SetItem(llNewRowSODetail_2, 'supp_code', 'PANDORA') /* 2/14/09 */
				ldsDODetail.SetItem(llNewRowSODetail_2, 'project_id', asproject) /*project*/
				ldsDODetail.SetItem(llNewRowSODetail_2, 'edi_batch_seq_no', llBatchSeqSO_2) /*batch seq No*/
				ldsDODetail.SetItem(llNewRowSODetail_2, 'order_seq_no', llOrderSeq) 
				ldsDODetail.SetItem(llNewRowSODetail_2, "order_line_no", string(llLineSeq)) /*next line seq within order*/
				ldsDODetail.SetItem(llNewRowSODetail_2, 'Status_cd', 'N')
// 10/09 - per Ian, don't want to default Inv Type....
				//ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_type', 'N') /*normal inventory*/
	
				if lsSFCustType = 'DC' then
					if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
						if lsToProject = 'RTV' then
							ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_Type', 'R') /*Return - RTV*/
						elseif lsToProject = 'OSV' then
							ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_Type', 'A') 
						elseif lsToProject = 'DECOM' then
							ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_Type', 'S') 
						else
							// 10/09 - per Ian, don't want to default Inv Type....
							//ldsDODetail.SetItem(llNewRowSODetail_2, 'Inventory_Type', 'N') /*default to Normal*/
						end if
					end if
				end if
			end if
			
			//From File
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
		

//  Delivery_Number
			//Invoice No
			If Pos(lsRecData,'|') > 0 Then
				lsInvoice = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Invoice No' field. Record will not be processed.")
			End If						
			ldsDODetail.SetItem(llNewDetailRow, 'Invoice_no', lsInvoice) 
			//TODO - Do we need to have a distinct Invoice_No (for DC-DC 2nd order)????
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'Invoice_no', lsInvoice + '_2')
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsInvoice) + 1))) /*strip off to next Column */

//  Line_Number
			//Material Transfer Line Number
			If Pos(lsRecData,'|') > 0 Then
				lsLine = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Material Transfer Line Number. Record will not be processed.")
			End If	
			ldsDODetail.SetItem(llNewDetailRow, 'line_item_no', dec(lsLine)) 
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'line_item_no', dec(lsLine)) 
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsLine) + 1))) /*strip off to next Column */
//  SKU
			If Pos(lsRecData,'|') > 0 Then
				lsSKU = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Part Number. Record will not be processed.")
			End If	
			ldsDODetail.SetItem(llNewDetailRow, 'sku', lsSKU) 
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'sku', lsSKU) 
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsSKU) + 1))) /*strip off to next Column */
//  Supplier *Not Used
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Quantity
			//Quantity
			If Pos(lsRecData,'|') > 0 Then
				lsQTY = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after Quantity. Record will not be processed.")
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'quantity', lsQTY) 
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'quantity', lsQTY) 
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsQTY) + 1))) /*strip off to next Column */

//  Storage Location *Not Used
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Unit_of_Measure
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'UOM', Trim(lsTemp))
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'UOM', Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Customer PO Number *not Used
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  PO Number 1
			//'From' Project - mapped to PO_NO
			// - for DECOM/RMA (multi-stage) FROM project of outbound order will be TO project of 1st leg
			//   - we'll set that later (when we get to the 'To Project' in the data)
			//   (need to retain original FROM project for FROM project on 1st leg, receipt from DC)
			If Pos(lsRecData,'|') > 0 Then
				lsFromProject = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'From' Project. Record will not be processed.")
			End If	
			ldsDODetail.SetItem(llNewDetailRow, 'po_no', lsFromProject) 
			//for final leg of DC-DC move, From/To project will always be the same (To Project in the file (below))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsFromProject) + 1))) /*strip off to next Column */

//  Owner Code
			//'From' Location - mapped to Owner_ID (after look-up via Owner_CD)
			// - 4/12/09 - Also setting DM.UF2 to 'FROM' Location from file
			// For DC-DC move, owner of 2nd Outbound Order will be Owner in Local SHIP-TO WH (lsST_LocalWHLoc)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If	
			//ldsDODetail.SetItem(llNewDetailRow, 'line_item_no', lsTemp) 
			lsOwnerCD = lsTemp
			if lsSF_LocalWHLoc > '' then
				//for DECOM/RMA - Owner is not on the Ship-From in the file - it is the intemediate WH's owner
				lsOwnerCd = lsSF_LocalWHLoc 
			end if
			if lsOwnerCD <> lsOwnerCD_Prev then
				//Need to look up Owner_ID and WH_Code (but shouldn't look it up for each row if it doesn't change)
				//  - do we need to validate that the WH_Code doesn't change within an Order?
				lsOwnerID = ''
				select owner_id into :lsOwnerID
				from owner
				where project_id = :asProject and owner_cd = :lsOwnerCD;
				lsOwnerCD_Prev = lsOwnerCD
		
				select user_field2 into :lsWH
				from customer
				where project_id = 'PANDORA'
				and cust_code = :lsOwnerCD;
			end if
			if lsST_LocalWHLoc > '' then
				//for DC-DC order, Owner on 2nd SO is the 2nd (Ship-To) intemediate WH's owner
				//lsOwnerCd = lsST_LocalWHLoc 
				if lsST_LocalWHLoc <> lsST_LocalWHLoc_Prev then
					//Need to look up Owner_ID and WH_Code (but shouldn't look it up for each row if it doesn't change)
					//  - do we need to validate that the WH_Code doesn't change within an Order?
					lsOwnerID_2 = ''
					select owner_id into :lsOwnerID_2
					from owner
					where project_id = :asProject and owner_cd = :lsST_LocalWHLoc;
					lsST_LocalWHLoc_Prev = lsST_LocalWHLoc
			
					select user_field2 into :lsWH_2
					from customer
					where project_id = 'PANDORA'
					and cust_code = :lsST_LocalWHLoc;
				end if
			end if

			
			if lsInvoice <> lsPrevInvoice then
			  //set wh_code when the invoice changes
//				ldsDOheader.SetItem(llNewDetailRow, 'wh_code', lsWH)
				ldsDOheader.SetItem(llNewRow, 'wh_code', lsWH)

				lsPrevInvoice = lsInvoice
				//need to set order type to 'Z' (for warehouse transfer) if customer is of type WH
				if lsCustType = 'WH' then 
					ldsDOHeader.SetItem(llNewRow, 'order_Type', 'Z') /* warehouse Transfer*/
//					ldsDOHeader.SetItem(llNewDetailRow, 'order_Type', 'Z') /* warehouse Transfer*/
				//	ldsDOHeader.SetItem(llNewRow, 'user_field2', lsOwnerCD) /* warehouse Transfer*/
				end if
				
				//DECOM/RMA
				if lsSFCustType = 'DC' then
					idsPOheader.SetItem(1, 'wh_code', lsWH)
				end if
				if llNewRowSO_2  > 0 then ldsDOheader.SetItem(llNewRowSO_2 , 'wh_code', lsWH_2)
				
			end if
			ldsDODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
			//for DC-DC, Owner on 2nd outbound order should be owner on 2nd Inbound order (lsST_LocalWHLoc)...
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'owner_id', lsOwnerID_2)
			
			ldsDOHeader.SetItem(llNewRow, 'user_field2', lsOwnerCD) /* 04/09 - PCONKL - Moved outside of if statement to unconditionally set the From Location */
			if llNewRowSO_2  > 0 then ldsDOHeader.SetItem(llNewRowSO_2, 'user_field2', lsST_LocalWHLoc) /* For 2nd Oubound order (DC-DC movement), need 'From Location' */

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
//  User Field 1
	//Mfg Part NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field1', Trim(lsTemp))
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'User_Field1', Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Price
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'Price', Trim(lsTemp))
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'Price', Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Currency Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'Currency_Code', Trim(lsTemp))
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'Currency_Code', Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  Serial Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field3', Trim(lsTemp))
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'User_Field3', Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//  To Project 
//!!TEMPO!!
			If Pos(lsRecData,'|') > 0 Then
				lsToProject = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsToProject = lsRecData
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field5', Trim(lsToProject))
			if llNewRowSODetail_2 > 0 then 
				ldsDODetail.SetItem(llNewRowSODetail_2, 'User_Field5', Trim(lsToProject))
				/* if this is multi-stage and the intermediate WH has a Hard-coded Project rule (Customer.uf10)
				    - then the To Project of the 1st Order should be the hard-coded Project value of the intermediate WH */
				if lsProject_Hardcode > '' then
					ldsDODetail.SetItem(llNewDetailRow, 'User_Field5', Trim(lsProject_Hardcode))
				end if
			end if
			//FOR DECOM/RMA, 'FROM' Project of outbound order should be the 'TO' project of 1st leg.
			if lsSFCustType = 'DC' then
				ldsDODetail.SetItem(llNewDetailRow, 'po_no', Trim(lsToProject))
			end if
			if llNewRowSODetail_2 > 0 then 
				/* if this is multi-stage and the intermediate WH has a Hard-coded Project rule (Customer.uf10)
				    - then the From Project of the 2nd Order should be the hard-coded Project value of the intermediate WH */
				if lsProject_Hardcode > '' then
					ldsDODetail.SetItem(llNewRowSODetail_2, 'po_no', Trim(lsProject_Hardcode))
				else
					ldsDODetail.SetItem(llNewRowSODetail_2, 'po_no', Trim(lsToProject))
				end if
			end if

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsToproject) + 1))) /*strip off to next Column */
		
//  Container ID
			If Pos(lsRecData,'|') > 0 Then
				lsContainer = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsContainer = lsRecData
			End If
			ldsDODetail.SetItem(llNewDetailRow, 'Container_Id', Trim(lsContainer))
			if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'Container_Id', Trim(lsContainer))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsContainer) + 1))) /*strip off to next Column */

/* Breadboard # (DECOM)
  	- Not part of Detail Record - comes in as a Note of type 'BB' 
	  (still assumes only a single detail line per DECOM order */
			if lsBB > '' then
				ldsDODetail.SetItem(llNewDetailRow, 'Lot_No', lsBB)
				if llNewRowSODetail_2 > 0 then ldsDODetail.SetItem(llNewRowSODetail_2, 'Lot_No', lsBB)
			end if

//DECOM / RMA, Multi-Stage shipment. Create Inbound receipt from DC to 'local' WH...
			if lsSFCustType = 'DC' then
				llNewRowPODetail = idsPODetail.InsertRow(0)
				//lbDetailError = False
				//llLineSeq ++
						
				//Add detail level defaults
				idsPODetail.SetItem(llNewRowPODetail,'order_seq_no', 1) //always only 1 order for DECOM/RMA
				idsPODetail.SetItem(llNewRowPODetail,'project_id', asproject) /*project*/
				idsPODetail.SetItem(llNewRowPODetail,'status_cd', 'N') 
				idsPODetail.SetItem(llNewRowPODetail,'Inventory_Type', 'N') 
				if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
					// ET3 2012-12-06 Pandora 545 - no longer track by MRB inventory type
					//if lsToProject = 'RTV'  or lsToProject = 'OSV' or lsToProject = 'MRB' or lsToProject = 'DECOM' then 
					if lsToProject = 'RTV'  or lsToProject = 'OSV' or lsToProject = 'DECOM' then 
						idsPODetail.SetItem(llNewRowPODetail, 'Inventory_Type', 'M') /*MRB */
					else
// 10/09 - per Ian, don't want to default Inv Type....
						//idsPODetail.SetItem(llNewRowPODetail, 'Inventory_Type', 'N') /*default to Normal*/
					end if
				end if
				idsPODetail.SetItem(llNewRowPODetail,'edi_batch_seq_no', llbatchseqPO) /*batch seq No*/
				idsPODetail.SetItem(llNewRowPODetail,"order_line_no", string(llLineSeq))
		
	//Action Code
	//Do we need to check to see if this PO already exists???
				idsPODetail.SetItem(llNewRowPODetail,'action_cd', 'A') 
	//Order Number
				idsPODetail.SetItem(llNewRowPODetail, 'Order_No', lsInvoice)
	//Line Item Number
				idsPODetail.SetItem(llNewRowPODetail,'line_item_no', dec(lsLine))
// TAM 2009/09/29 We are now saving Pandoras Line no into User Line No
				idsPODetail.SetItem(llNewRowPODetail,'user_line_item_no', lsLine)
	//SKU
				idsPODetail.SetItem(llNewRowPODetail, 'SKU', lsSKU)
	//Qty
				idsPODetail.SetItem(llNewRowPODetail, 'quantity', lsQty) 
	//lot No
				idsPODetail.SetItem(llNewRowPODetail, 'Lot_no', lsBB)
	//PO NO - Pandora Project...
				if lsToProject = '' then
					idsPODetail.SetItem(llNewRowPODetail, 'PO_NO', 'MAIN') //PO_NO tracking is on for all SKUs. Defaulting to 'MAIN'
				else
					idsPODetail.SetItem(llNewRowPODetail, 'PO_NO', lsToProject)
				end if
	//From Project (rd.uf2)
				idsPODetail.SetItem(llNewRowPODetail, 'user_field2', lsFromProject)
	//Owner ID
				idsPODetail.SetItem(llNewRowPODetail, 'owner_id', lsOwnerID)
	//Container ID
				if lsContainer > '' then
					idsPODetail.SetItem(llNewRowPODetail, 'container_id', lsContainer)
				end if
			end if //ship-from is a DC (so DECOM/RMA multi-stage order)

			if lbError then
				//TODO - set status_cd on header as well?
				ldsDODetail.SetItem(llNewDetailRow,'status_cd','E') /*Don't want to process this record in the next step*/
				ldsDODetail.SetItem(llNewDetailRow,'status_message','Custom Pandora Validation') /*Don't want to process this record in the next step*/
				if llNewRowSODetail_2 > 0 then 
					ldsDODetail.SetItem(llNewRowSODetail_2,'status_cd','E') /*Don't want to process this record in the next step*/
					ldsDODetail.SetItem(llNewRowSODetail_2,'status_message','Custom Pandora Validation') /*Don't want to process this record in the next step*/
				end if
			end if

Case 'DN'/* Header/Line Notes*/  

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

			lsNoteType = lsTemp
			
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

			//DECOM - BreadBoard is coming in as a note - Supposedly only a single BreadBoard (and single line) for an Order.
				if lsNoteType = 'BB' then
					lsBB = lsNoteText //need to set variable for later use if BB Note comes before Detail line in the file.
					ldsDODetail.SetItem(1, 'Lot_No', lsBB)
				end if
			
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
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue /*Next Record */
			
	End Choose /*Header, Detail or Notes */
	
Next /*file record */

if lbNoOutbound then //for DECOM / RMA, we may be creating only an Inbound order (from DC to WH)
	ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this record in the next step*/
	ldsDOHeader.SetItem(llNewRow,'status_message', 'No Outbound Order Needed (Local WH Loc same as ship-to WH Loc)') /*Don't want to process this record in the next step*/
	//shouldn't ever have to prevent the creation of the '2nd' Outbound order (from ship-to WH to ship-to DC)
	// - on DC-DC move, ship-from WH might be same as ship-to WH so no '1st' outbound order but still need outbound to ship-to DC
	//if llNewRowSODetail_2 > 0 then 
	//	ldsDOHeader.SetItem(llNewRowSODetail_2,'status_cd','E') /*Don't want to process this record in the next step*/
	//	ldsDOHeader.SetItem(llNewRowSODetail_2,'status_message','No Outbound Order Needed (Local WH Loc same as ship-to)') /*Don't want to process this record in the next step*/
	//end if
	For llRowPos = 1 to llNewDetailRow //count of detail rows.
		ldsDODetail.SetItem(llRowPos,'status_cd','E') /*Don't want to process this record in the next step*/
		ldsDODetail.SetItem(llRowPos,'status_message', 'No Outbound Order Needed (Local WH Loc same as ship-to)') /*Don't want to process this record in the next step*/
		//if llNewRowSODetail_2 > 0 then ....
	next
end if

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
	if lsSFCustType = 'DC' then
		liRC = idsPOHeader.Update()
		If liRC = 1 Then
			liRC = idsPODetail.Update()
		End If
	end if
end if
If liRC = 1 Then
	Commit;
	if lsSFCustType = 'DC' then
		If liRC = 1 Then
			if not lbError then // don't create inbound order if there are errors (need to get more specific about this)
				liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
			end if
		End If
	end if
//	if llBatchSeqSO_2 > 0 then //need two outbound orders, 1st to WH, 2nd to DC
//		liRC = gu_nvo_process_files.uf_process_delivery_order()
//	end if
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new SO Records to database "
	FileWrite(gilogFileNo, lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

If lbError Then Return -1

if lbNoOutbound then //for DECOM / RMA, we may be creating only an Inbound order (from DC to WH)
	return -1 
end if

Return 0
end function

public function integer uf_process_boh_rose ();//Inventory Snapshot for PANDORA
/* TEMPO! 15.2. For purposes of this file, inventory that has been picked 
for an order but not yet ship completed is considered available inventory. */
Integer	liRC, liFileNo
Long	llRowCount, llRowPos, llNewRow, llBatchSeq, llRecSeq
String	lsOutString,  lsLogOut
string ERRORS, sql_syntax, lsTemp,  lsOwner, lsWhCode, lsToday, lsProject, lsNextRunDate, lsNextRunTime, lsRunFreq
Decimal	ldBatchSeq
datetime ldtToday,	ldtNextRunTIme
Date		ldtNextRunDate


Datastore	 ldsInv, ldsOut

If Not isvalid(ldsOut) Then
	ldsOut = Create Datastore
	ldsOut.Dataobject = 'd_edi_generic_out'
	lirc = ldsOut.SetTransobject(sqlca)
End If

ldtToday = DateTime(Today(), Now())
ldtToday = GetPacificTime('GMT', ldtToday)
lsToday= String(ldtToday, 'yyyymmddhhmmss')   									//current_time

lsProject = "PANDORA"

// TAM 2009/11/18  Change to run from Scheduled Activities
//lsNextRunDate = ProfileString(asIniFile,'PANDORA','DBOHNEXTDATE','')
//lsNextRunTime = ProfileString(asIniFile,'PANDORA','DBOHNEXTTIME','')
//
//
////If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
// 	Return 0
//Else /*valid date*/
// 	ldtNextRunTIme = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
// 	If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
// 		Return 0
// 	End If
//End If


lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: PANDORA Daily Inventory Snapshot File... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Create datastore
ldsInv = Create Datastore

//Create the Datastore...
//sql_syntax = "SELECT wh_code, owner_cd, SKU,  po_no, Sum(Avail_Qty) + Sum(alloc_Qty) as total_qty"
//sql_syntax += " from Content_Summary, Owner"
//sql_syntax += " Where Content_Summary.Project_ID = 'PANDORA' and "
//sql_syntax += " Content_Summary.Project_id = owner.Project_id and Content_Summary.owner_id = owner.Owner_id "
//sql_syntax += " Group by WH_Code, Owner_cd, SKU, po_No"
//sql_syntax += " Having Sum(Avail_Qty) + Sum(alloc_Qty) > 0;"


// 2009/07/31 TAM - Remove Project from the group by
// 2009/09/08 TAM - Adding it back in Project from the group by and default Project
//TimA 03/12/14 added CHROME and GFIBER
//07-Nov-2017 :Madhu BOH shouldn't be generated for OM Enabled Ind warehouses.
sql_syntax = " SELECT wh_code, owner_cd, SKU, po_no, Sum(Avail_Qty) + Sum(alloc_Qty) as total_qty, user_field1"
sql_syntax += "  from Content_Summary cs, owner o, customer c"
sql_syntax += "  Where cs.owner_id = o.owner_id"
sql_syntax += "  and o.project_id = c.project_id and o.owner_cd = c.cust_code"
sql_syntax += "  and cs.wh_code IN ( select wh_code from Warehouse with(nolock) where  OM_Enabled_Ind <> 'Y') "
//sql_syntax += "  and cs.Project_ID = 'PANDORA' and (c.user_field1 like 'GIG%' or c.user_field1 like 'PLAT%' or c.user_field1 like 'ENT%' or c.user_field1 like 'HWOPS%' or c.user_field1 like 'DECOM%' or c.user_field1 like 'SCRAP%' or c.user_field1 like 'NPI%' or c.user_field1 like 'RMA%'  or c.user_field1 like 'CHROME'  or c.user_field1 like 'GFIBER%')"
sql_syntax += "  and cs.Project_ID = 'PANDORA'"
sql_syntax += "  Group by wh_code, owner_cd, SKU, po_no, user_field1"
sql_syntax += "  Having Sum(Avail_Qty) + Sum(alloc_Qty) > 0 "
sql_syntax += "  Order By wh_code, owner_cd, SKU;"

//sql_syntax = " SELECT wh_code, owner_cd, SKU, Sum(Avail_Qty) + Sum(alloc_Qty) as total_qty, user_field1"
//sql_syntax += "  from Content_Summary cs, owner o, customer c"
//sql_syntax += "  Where cs.owner_id = o.owner_id"
//sql_syntax += "  and o.project_id = c.project_id and o.owner_cd = c.cust_code"
//sql_syntax += "  and cs.Project_ID = 'PANDORA' and (c.user_field1 like 'GIG%' or c.user_field1 like 'PLAT%' or c.user_field1 like 'ENT%' )"
//sql_syntax += "  Group by wh_code, owner_cd, SKU, user_field1"
//sql_syntax += "  Having Sum(Avail_Qty) + Sum(alloc_Qty) > 0 "
//sql_syntax += "  Order By wh_code, owner_cd, SKU;"
//

ldsInv.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for PANDORA Inventory Snapshot ID data (CO).~r~r" + Errors
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

If llRowCount < 0 Then 
	il_returnvalue =2 //05-Oct-2015 Madhu- Store return value in Instance variable
	Return 1 //05-Oct-2015 Madhu- As discussed with Tim, changed Return Value
	//Return 0   //05-Oct-2015 Madhu- As discussed with Tim, commented Return Value
else
	il_returnvalue =0 //05-Oct-2015 Madhu- Store return value in Instance variable
End If

//Next File Sequence #...
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no("PANDORA", 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number for PANDORA Inventory Snapshot file. File will not be Created/Sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

For llRowPos = 1 to llrowCount
	
// Build a header record at owner code or Warehouse change
	If lsOwner <> ldsInv.GetItemstring(llRowPos, 'owner_cd') or lsWhCode <> ldsInv.GetItemstring(llRowPos, 'wh_code') then
	// Save New Owner and Warehouse
		lsOwner = ldsInv.GetItemstring(llRowPos, 'owner_cd')
		lsWhCode = ldsInv.GetItemstring(llRowPos, 'wh_code')

		llNewRow = ldsOut.insertRow(0)

		lsOutstring = 'BH|'
		lsOutString += ldsInv.GetItemstring(llRowPos, 'wh_code') + '|' /*warehouse*/
		lsOutString += ldsInv.GetItemstring(llRowPos, 'owner_cd') + '|' /*Owner Code - From and To are the same*/ 
		lsOutString += ldsInv.GetItemstring(llRowPos, 'owner_cd') + '|' /*Owner Code - From and To are the same*/ 
		lsOutstring += '|' /*MTR Not Used */
		lsOutString += lsToday /*Current Date*/ 

		ldsOut.SetItem(llNewRow, 'Project_id', lsProject)
		ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
		ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
		ldsOut.SetItem(llNewRow, 'file_name', 'BIR' + String(ldBatchSeq, '000000') + '.DAT') 

	End If

// //Build detail records

	llNewRow = ldsOut.insertRow(0)

	lsOutstring = 'BD|'
	lsOutString += ldsInv.GetItemstring(llRowPos, 'sku')  + '|'/*SKU*/
	lsOutstring += '|' /*Inventory Type Not Used */
	lsOutstring += '|' /*Inventory Type Not Used */
// 2009/07/31 TAM - Remove Project from the group by and default Project
// 2009/09/08 TAM - Adding it back in Project from the group by and default Project
	lsOutString += ldsInv.GetItemstring(llRowPos, 'po_no') + '|' /*Project Code -  From and To are the same*/
	lsOutString += ldsInv.GetItemstring(llRowPos, 'po_no') + '|' /*Project Code -  From and To are the same*/
//	lsOutString +=  'MAIN|' /*Project Code -  From and To are the same*/
//	lsOutString +=  'MAIN|' /*Project Code -  From and To are the same*/
	lsOutstring += '|' /*Line Not Used */
	lsOutstring += String(ldsInv.GetItemNumber(llRowPos, 'total_qty'), "#############")

	ldsOut.SetItem(llNewRow, 'Project_id', lsProject)
	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow, 'file_name', 'BIR' + String(ldBatchSeq, '000000') + '.DAT') 

Next /*Inv record*/

//Write the Outbound File
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,lsProject)

// TAM 2009/11/18  Change to run from Scheduled Activities
//Set the next time to run if freq is set in ini file
//lsRunFreq = ProfileString(asIniFile,'PANDORA','DBOHFREQ','')
//If isnumber(lsRunFreq) Then
//	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
//	SetProfileString(asIniFile,'PANDORA','DBOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
//Else
//	SetProfileString(asIniFile,'PANDORA','DBOHNEXTDATE','')
//End If


//Return llrowCount
Return 0
end function

public function integer uf_process_delivery_date (string aspath, string asproject);//Apply Delivery Dates to orders in Complete status

String	lsData, lsTemp, lsLogOut, lsStringData, lsOrdNum, lsTrackNum, lsCOO, lsStatus
String lsReturnData, lsDM_DO_No, lsDM_Ord_Status
string ls_SkippedData[ ]  //Hold Headings of cols skipped

Integer	liRC,	liFileNo
			
Long		llCount,	llPos, llOwner, llNew, llRecCnt, llNewRow, llFileRowCount, llFileRowPos 

Decimal ldTemp

Boolean	lbNew, lbError, lSQLCAauto

DateTime ldtDeliveryDate, ldtDM_Delivery_Date, ldtDM_Complete_Date

	
DECLARE sp_DeliveryDate PROCEDURE FOR
	@liRC = dbo.Sp_Update_Delivery_Master
	@aInvoice_No = :lsOrdNum,
	@aAWB_BOL_No = :lsTrackNum,
	@aDelivery_Date = :ldtDeliveryDate,
	@aReturnData = :lsReturnData out,
	@aUpdateRecordCnt = :llCount out,
	@aDM_DO_No = :lsDM_DO_No out,
	@aDM_Ord_Status = :lsDM_Ord_Status out,
	@aDM_Complete_Date = :ldtDM_Complete_Date out,
	@aDM_Delivery_Date = :ldtDM_Delivery_Date out
USING SQLCA;
	
	

u_ds_datastore	ldsItem 
datastore	lu_DS


lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master File for Pandora Processing: " + asPath
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
llFileRowCount = lu_ds.RowCount()

For llfileRowPos = 1 to llFileRowCount
	w_main.SetMicroHelp("Processing Delivery Master Record " + String(llFileRowPos) + " of " + String(llFilerowCount))
	 lsData = Trim(lu_ds.GetItemString(llFileRowPos,'rec_Data'))

	//Ignore EOF
	If lsData = "EOF" Then Continue
	
	//Skip past Header if it exists
	If llfileRowPos = 1 Then
		lsTemp = Left(lsData,(pos(lsData, ',') - 1))
	     If Trim(upper(lsTemp)) = 'ORDER NUMBER' Then
		     Continue /*Process Next Record */
	     End If 
	End if
	
	//Make sure first Char is not a delimiter
	If Left(lsData,1) = ',' Then
		lsData = Right(lsData,Len(lsData) - 1)
	End If
	
	//Validate Rec Type is DU
	lsTemp = Left(lsData,(pos(lsData, ',') - 1))
	If Trim(lsTemp) <> 'DU' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + Trim(lsTemp) + "'. Record will not be processed.")
		lbError = True
		Continue		// Can't process without valid Record Type
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	//Validate Order Number and retrieve existing or Create new Row
	If Pos(lsData, ',') > 0 Then
		lsTemp = Left(lsData,(pos(lsData, ',') - 1))
		lsOrdNum = Trim(lsTemp)		
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'ORDER NUMBER' field. Record will not be processed.")
		lbError = True
		Continue		// Can't process without valid Order Number
	End If
	
	// Validate, but skip past Order Type & Order Status to get to Tracking Number
	ls_SkippedData[1] = 'ORDER TYPE'
	ls_SkippedData[2] = 'ORDER STATUS'
	For llPos = 1 to 2
			lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
				If Pos(lsData, ',') > 0 Then
			lsTemp = Left(lsData,(pos(lsData, ',') - 1))
			
		Else /*error*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after "+ls_SkippedData[llPos]+" field. Record will not be processed.")
			lbError = True
			Continue		
	End If
	Next

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	//Validate Tracking Number and retrieve existing or Create new Row
	If Pos(lsData, ',') > 0 Then
		lsTemp = Left(lsData,(pos(lsData, ',') - 1))
		 lsTrackNum = Trim(lsTemp)		
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'TRACKING NUMBER' field. Record will not be processed.")
		lbError = True
		Continue		
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	//Validate Delivery Date and retrieve existing or Create new Row
	If Pos(lsData, ',') > 0 Then
		lsTemp = Left(lsData,(pos(lsData, ',') - 1))
		ldtDeliveryDate = Datetime(Trim(lsTemp))		
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'DELIVERY DATE' field. Record will not be processed.")
		lbError = True
		Continue		
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	//Validate Status and retrieve existing or Create new Row
	If (Pos(lsData, ',') > 0 or Len(lsData) > 0)  Then
		lsTemp = lsData //Left(lsData,(pos(lsData, ',') - 1))
		 lsStatus = Trim(lsTemp)		
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'STATUS' field. Record will not be processed.")
		lbError = True
		Continue		
	End If

lSQLCAauto = SQLCA.AutoCommit
SQLCA.AutoCommit = true  // Control of Transaction processing in Stored Procedure
EXECUTE sp_DeliveryDate; 
SQLCA.AutoCommit = lSQLCAauto  //Reset SQLCA's Transaction Processing
If SQLCA.SQLCode = -1 Then
	gu_nvo_process_files.uf_writeError("- ***System  Error!:   "+SQLCA.SqlerrText)  // ujhTODO  Remove this and write to log "Some Database problem.  Dave to tell me what to log here."
ELSE
	// Get Return Code.  Though not yet used, each record returns from Delivery_Master the Ord_Status, Delivery_Date, and Complete_Date plus.....    to
	//      be used perchance "ReturnData" is not sufficient, as the valuesarebe embedded in the string.
	FETCH sp_DeliveryDate INTO :liRC, :lsReturnData, :llCount, :lsDM_DO_No,  :lsDM_Ord_Status,  :ldtDM_Complete_Date, :ldtDM_Delivery_Date;
	Close sp_DeliveryDate;
	llRecCnt =  llRecCnt + llCount
	//01/08/2010 ujh  lsReturnData will contain the one of the following.  
	//    Additionally, take note of the other output from the stored procedure (See Fetch above for 
	//    column names = DM prefix with names of cols from Delivery_Master)  These could be used to create different log messages) 
	//    As it stands only errors are logged (llCount < 1)).  Success is not logged.
	//        'UDUF| The record exists but update failed due to unknown cause--the kind of thiing that happens in development such as data conversion error'
	//        'SUCCESS| The record has been updated'
	//        'REMC| Multiple matching Records exists where status = complete.'
	//        'UDCF| The record exists, but update count was zero--not likely and was never be forced during testing.'
	//		'REGE| Record exists; (Ord_Status = C, but Complete_Date >= Delivery_Date)
	//		'RENC| Record exists; (Ord_Status NOT "C")
	//		'REMR| Multiple matching Records exists, but none where status = complete AND Complete_Date < Delivery_Date'
	//		'UDBE| Update was not attempted due to some unkown problem--not likely and was never be forced during testing.' 
	//		NERF| No record exists that fits criteria.'
	//        'UDBP| Unkown database problem--not likely and was never be forced during testing.' 
	// For now onlyplace errors in log; success not logged.
	If llCount < 1 Then   
		gu_nvo_process_files.uf_writeError("- ***Processing  Error!:   "+ lsReturnData)
	End if
	
END if

Next /*File row to Process */

w_main.SetMicroHelp("")

lsLogOut =  String(llRecCnt) + ' Record(s) updated.'
FileWrite(gilogFileNo,lsLogOut)





If lbError then
	Return -1
Else
	Return 0
End If

Return 0
end function

protected function boolean uf_otm_fields_modified (string as_action, datastore ads_current, datastore ads_original, long al_row);// Checks to determine if required OTM fields have been modified and thus the item needs to be sent to TIBCO/OTM.  
// A return of TRUE indicates the item must be sent.

boolean lb_return, lb_otm_fields_populated

as_action = Upper(Trim(as_action))

// Determine if all of the OTM required fields are populated
lb_otm_fields_populated =	(NOT IsNull(ads_current.Object.uom_1[al_row])) and Trim(ads_current.Object.uom_1[al_row]) <> "" and &
									(NOT IsNull(ads_current.Object.length_1[al_row])) and ads_current.Object.length_1[al_row] <> 0 and &
									(NOT IsNull(ads_current.Object.width_1[al_row])) and ads_current.Object.width_1[al_row] <> 0 and &
									(NOT IsNull(ads_current.Object.height_1[al_row])) and ads_current.Object.height_1[al_row] <> 0 and &
									(NOT IsNull(ads_current.Object.weight_1[al_row])) and ads_current.Object.weight_1[al_row] <> 0 

if as_action = 'D' then
	lb_return = TRUE		// Send all deletes to OTM
elseif as_action = 'I' and lb_otm_fields_populated then
	lb_return = TRUE
elseif as_action = 'U' and lb_otm_fields_populated then
	// For updates, if any values have changed from the original DB values return true
	if al_row <= ads_current.RowCount() and al_row <= ads_original.RowCount() then
		lb_return = 	NOT (	f_is_equal(ads_current.Object.length_1[al_row], ads_original.Object.length_1[al_row]) and &
								f_is_equal(ads_current.Object.width_1[al_row], ads_original.Object.width_1[al_row]) and &
								f_is_equal(ads_current.Object.height_1[al_row], ads_original.Object.height_1[al_row]) and &
								f_is_equal(ads_current.Object.weight_1[al_row], ads_original.Object.weight_1[al_row]) and &
								f_is_equal(ads_current.Object.uom_1[al_row], ads_current.Object.uom_1[al_row])  )
	end if
end if

return lb_return

end function

public function integer uf_process_po (string aspath, string asproject);//Process PO for Pandora

Datastore	lu_ds, ldsItem

String	lsLogout,lsStringData, lsOrder, lsWarehouse, lsTemp, lsRecData, lsRecType, lsDesc, lsSKU, lsSupplier
Integer	liRC,liFileNo
Long		llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llOwnerID
Boolean	lbError, lbDetailError
DateTime	ldtToday
Decimal	ldWeight, ldLineItemNo_c

String 	lsOrderNo
string 	lsSKU2, lsGPN, lsOwnerCD, lsOwnerCD_Prev, lsOwnerID, lsTemp2

ldtToday = DateTime(Today(),Now())

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master'
ldsItem.SetTransObject(SQLCA)

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
lsLogOut = '      - Opening File for PANDORA Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for PANDORA Processing: " + asPath
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

/* holdover from sika...
//Warehouse defaulted from project master default warehouse - only need to retrieve once
//TEMPO - Why? What is the WH code we're getting in the file?
Select wh_code into :lsWarehouse
From Project
Where Project_id = :asProject;
*/

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Process Each Record in the file..

//Process each row of the File
llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	lsRecData = Trim(lu_ds.GetItemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsRecType)
			
		Case 'PM', 'AM' /* PO Header (AM - ASN) */
			
			llNewRow = idsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			idsPOheader.SetItem(llNewRow, 'project_id', asProject)
//sika..			idsPOheader.SetItem(llNewRow, 'wh_code', lsWarehouse)
			idsPOheader.SetItem(llNewRow, 'Request_date',String(Today(), 'YYMMDD'))
			idsPOheader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq)  /* batch seq No */
			idsPOheader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
			idsPOheader.SetItem(llNewRow, 'ftp_file_name',asPath)  /* FTP File Name */
			idsPOheader.SetItem(llNewRow, 'Status_cd', 'N')
			idsPOheader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
		
//			//Getting Order_Type from SIKA(at end of PM Record). Defaulting it here...
			idsPOheader.SetItem(llNewRow, 'Order_type', 'S')  /* Order Type )  */
			idsPOheader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
					
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			//Action Code - 			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Action Code' field. Record will not be processed.")
			End If

			// 4-14-09: setting to X so it always adds/updates.
			if lsTemp = 'A' or lsTemp = 'U' then
				 idsPOheader.SetItem(llNewRow, 'action_cd', 'X')
			end if

			idsPOheader.SetItem(llNewRow, 'action_cd', lsTemp) 

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order No' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			lsOrderNo = trim(lsTemp)
			//pandora - supp_invoice_no or order_no??? (it's 'Order_No' in Edi_Inbound and in d_po_header)
			idsPOheader.SetItem(llNewRow, 'order_no', Trim(lsTemp))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Supplier - always 'PANDORA' for now (capturing Vendor later in UF)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			If lsTemp > '' Then
				//not building IM record for Pandora at this time... lsSupplier = lsTemp  /* used to build item master below if necessary */
				idsPOheader.SetItem(llNewRow, 'supp_code', lsTemp)
			Else
				idsPOheader.SetItem(llNewRow, 'supp_code', 'PANDORA')  /* default to PANDORA */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Expected Arrival Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Arrival Date' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If					
			idsPOheader.SetItem(llNewRow, 'Arrival_Date', lsTemp)
								
			// Unique order for Powerwave is Order/Receipt Date. Check for existence here. If doesn't exist, set action to 'Z'. This will force PO process
			// to create a new order regardless. Otherwise, we will append to same order when they should be 2.
			If idsPOHeader.GetItemString(llNewRow, 'Action_cd') = 'A' and lsTemp > '' Then
				Select Count(*) into :lLCount
				From Receive_Master 
				Where Project_id = 'PANDORA' and Supp_Invoice_No = :lsOrderNo and arrival_date = :lsTemp;
				If lLCount = 0 Then
					idsPoheader.SetItem(llNewRow, 'action_cd', 'Z') /*add regardless*/
				End If
			End If

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Getting Sub-Inventory Location here. Need to look up warehouse based on Customer.UF2
			/// - not coming here - look about 6 fields below....
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Sub-Inventory' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
								
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1)))  /* strip off to next Column */
			//Carrier
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Carrier' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If					
			idsPOheader.SetItem(llNewRow,'Carrier',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//AWB
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'AWB' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If		
			idsPOheader.SetItem(llNewRow,'Awb_bol_no',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Transport Mode
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Tansport Mode' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			idsPOheader.SetItem(llNewRow,'transport_mode',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Remarks
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Remark' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If	
			idsPOheader.SetItem(llNewRow, 'remark', lsTemp)
			/* 2/24/09 - setting Ship_Ref to Transaction Ref from MIM 
			    - Grabbing first N characters until first ':' (for Atlanta) */
			If Pos(lsTemp, ':') > 1 Then
				lsTemp2 = Left(lsTemp, (Pos(lsTemp, ':') - 1))
			End If
			if len(lsTemp2) > 4 and len(lsTemp2) < 10 then
				idsPOheader.SetItem(llNewRow, 'ship_ref', lsTemp2)
			end if
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			// UF1 - Org Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'UF1' (Org) field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If					
			idsPOheader.SetItem(llNewRow, 'User_Field1', lsTemp)  /* UF1 - Org Code */	

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			// UF2 - Sub-Inventory Loc?
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Sub-Inventory Loc' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If					
			/* not getting this here now - only on detail
					idsPOheader.SetItem(llNewRow, 'User_Field2', lsTemp)  /* UF2 - Sub-Inventory Loc*/	
					//look up warehouse based on sub-inventory loc...
					Select User_Field2 into :lsWarehouse
					From Customer
					Where project_id = 'PANDORA' and cust_code = :lsTemp;			
					If lsWarehouse = "" or isnull(lsWarehouse) Then
						lbError = True
						gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No Warehouse Set for Sub-Inventory Location '" + lsTemp + "' (check Customer Maintenance). Order will not be processed.") 
					End If
					idsPOheader.SetItem(llNewRow, 'wh_Code', lsWarehouse)
			*/
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			// UF3 - 'From' Location
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'From Location' (UF3) field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If					
			idsPOheader.SetItem(llNewRow, 'User_Field3', lsTemp)  /* UF3 - 'From' Location */	

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			// UF7 - Pandora PO Line Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If					
			idsPOheader.SetItem(llNewRow, 'User_Field7', lsTemp)  /* UF7 - PO Line Type */	

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			// UF8 - 'From' Project
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If					
			idsPOheader.SetItem(llNewRow, 'User_Field8', lsTemp)  /* UF8 - From Project */	

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			// UF9 - Vendor Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If					
			idsPOheader.SetItem(llNewRow, 'User_Field9', lsTemp)  /* UF9 Vendor Name */	

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			// UF10 - Buyer Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If					
			idsPOheader.SetItem(llNewRow, 'User_Field10', lsTemp)  /* UF10 Buyer Name */	

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			// UF11 - Requestor Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If					
			idsPOheader.SetItem(llNewRow, 'User_Field11', lsTemp)  /* UF11 Requestor Name */	

	CASE 'PD', 'AD' /* detail */
			
			lbDetailError = False
			llNewDetailRow = 	idsPODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			idsPODetail.SetItem(llNewDetailRow,'order_seq_no', llOrderSeq) 
			idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			idsPODetail.SetItem(llNewDetailRow,"order_line_no", string(llLineSeq))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			//Action Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Action Code' field. Record will not be processed.")
				lbDetailError = True
			End If	
			idsPODetail.SetItem(llNewDetailRow,'action_cd',lsTemp) 
			if lsTemp = 'U' then
				idsPOheader.SetItem(llNewRow, 'action_cd', 'X')  // 4-14-09: setting to X so it always adds/updates.
			elseif lsTemp = 'D' then
				idsPOheader.SetItem(llNewRow, 'action_cd', 'U')  // Setting to 'U' so order will be updated with Delete
			end if
			// 4-14-09: setting to X so it always adds/updates.
			if lsTemp = 'A' or lsTemp = 'U' then
				idsPOheader.SetItem(llNewRow, 'action_cd', 'X') 
			end if
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Number' field. Record will not be processed.")
				lbDetailError = True
			End If						
			//Make sure we have a header for this Detail...
			If idsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'", 1, idsPoHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Detail Order Number does not match header Order Number. Record will not be processed.")
				lbDetailError = True
			End If
			idsPODetail.SetItem(llNewDetailRow, 'Order_No', Trim(lsTemp))

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
						
			lsSKU = trim(lsTemp)  
			/* may use to build itemmaster record 
			Need to check SKU in Item_Master and, if it's not there, check MFG SKU Look-up */
			Select distinct(SKU) into :lsSKU2
			From Item_Master
			Where Project_id = :asProject
			and SKU = :lsSKU;
			if lsSKU2 = '' then 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Missing Pandora SKU...") 

				//TEMPO!! - are we going to map MFG Parts to GPNs?
				// SKU doesn't exist in Item Master. See if it's a MFG SKU...
				/* ... if we're storing the MFG_SKU - GPN map in Lookup_Table...
				 (what about 2 MFGs with same Part#, Different GPN???) */
				 
				//look-up not implemented.  Store in look-up table?  Store in Price_Master?  Other???
/*				
				select code_descript into :lsGPN
				from lookup_table
				where project_id = :asProject
				and code_type = 'M_SKU'
				and code_id = :lsSKU;
				
				// if we store MFG_SKU / GPN map in PriceMaster...
				Select distinct(SKU) into :lsSKU2
				From Item_Master
				Where Project_id = :asProject
				and SKU = :lsSKU;
*/				
			end if
				
			idsPODetail.SetItem(llNewDetailRow, 'SKU', lsSKU)
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				//Qty
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If		
			idsPODetail.SetItem(llNewDetailRow,'quantity',Trim(lsTemp)) /*checked for numerics in nvo_process_files.uf_process_purcahse_Order*/

		// *** No more required fields...
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Inventory Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If						
			If lsTemp > '' Then /*override default if present*/	
				idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', lsTemp)
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
			//PO NO - Pandora Project...
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If	
			if lsTemp = '' then
				idsPODetail.SetItem(llNewDetailRow, 'PO_NO', 'MAIN') //PO_NO tracking is on for all SKUs. Defaulting to 'MAIN'
			else
				idsPODetail.SetItem(llNewDetailRow, 'PO_NO', lsTemp)
			end if
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//PO NO 2
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
			//idsPODetail.SetItem(llNewDetailRow,'expiration_date',dateTime(lsTemp))
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//For Pandora, assigning Owner based on Sub-Inventory Location (Group- and location- specific)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If						
			//Need to look-up Owner_CD (but shouldn't look it up for each row if it doesn't change)
			lsOwnerCD = lsTemp
			if lsOwnerCD <> lsOwnerCD_Prev then
				lsOwnerID = ''
				select owner_id into :lsOwnerID
				from owner
				where project_id = :asProject and owner_cd = :lsOwnerCD;
				lsOwnerCD_Prev = lsOwnerCD
			end if
			idsPODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
					
			//Should we set RM.UF2 to Owner (like the manually-entered orders)?
			// - now getting it from ICC in header record
			//If first row for the order, set UF2 to Sub-Inv Loc
			If llLineSeq = 1 Then
				//not setting this now idsPOheader.SetItem(llNewRow, 'User_Field2', lsTemp)
				// but need to set WH since not set at header any more (should validate that it doesn't change between lines)
				select user_field2 into :lsWarehouse
				from customer
				where project_id = :asProject and cust_code = :lsOwnerCD;
				idsPOheader.SetItem(llNewRow, 'wh_code', lsWarehouse)  /*  */	
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//If detail errors, delete the row...
			if lbDetailError Then
				lbError = True
				idsPoDetail.DeleteRow(llNewDetailRow)
				Continue
			End If
				
/* For dynamically-created SKUs.....
			//We may receive a detail row for a new sku//supplier combination. If we have the sku for another supplier and this supplier is also valid, copy existing item to new supplier
			llCount = ldsItem.Retrieve(asProject, lsSKU)
			If llCount > 0 Then				
				llFindRow = ldsItem.Find("Upper(Supp_code) = '" + upper(lsSupplier) + "'",1,ldsItem.RowCount())
				If llFindRow = 0 Then /*doesnt exist for this supplier*/
					//validate Supplier and if valid, create an item for the new supplier
					Select Count(*) into :llCount
					From Supplier
					Where Project_id = :asProject and supp_code = :lsSupplier;					
					If llCount > 0 Then						
						//Get Owner for this supplier
						Select Owner_id into :llOwnerID
						From Owner
						Where Project_id = :asProject and Owner_type = 'S' and owner_cd = :lsSUpplier;
						If ldsItem.RowsCopy(ldsItem.RowCount(),ldsItem.RowCount(),Primary!,ldsItem,99999,Primary!) = 1 Then
							ldsItem.SetItem(ldsitem.RowCount(),'supp_code',lsSupplier)
							ldsItem.SetItem(ldsitem.RowCount(),'owner_id',llOwnerID)
							ldsItem.SetItem(ldsitem.RowCount(),'last_update',ldtToday)
							ldsItem.SetItem(ldsitem.RowCount(),'last_user','SIMSFP')
							lirc = ldsItem.Update()
							If liRC = 1 then
								Commit;
							Else
								Rollback;
							End If
						End If
					End If /*valid supplier*/
				End If  /*doesnt exist for this supplier*/
			End If /*Item exists for some supplier*/
*/

		Case Else /* Invalid Rec Type*/
		
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

public function integer uf_process_boh_hourly ();//Jxlim 02/07/2012 BRD #366 Hourly Inventory Snapshot
//GXMOR 05/15/2013 #366 Version 4 - Added Alloc Qty and Open Orders Qty to snapshot
//Process the PANDORA Hourly Inventory Snapshot
Datastore	ldsOut, ldsboh				
Long			llRowPos, llRowCount, llNewRow, llBOH				
String		lsFind, lsOutString, lslogOut, lsProject, lsNextRunTime, lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName
String		ls_pacifictime, lstoday
String 		ERRORS, sql_syntax, lsTemp	
Decimal	ldBatchSeq
Integer		liRC
DateTime	ldtNextRunTime, ldttoday
Date			ldtNextRunDate

ldtToday = DateTime(Today(), Now())
ldtToday = GetPacificTime('GMT', ldtToday)
lsToday= String(ldtToday, 'yyyymmdd')   									//current_time

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file
ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

//Jxlim 03/22/2012 BRD #366 Limited to Atlanta and Amsterdam warehouse, added and c.User_Field2 = cs.wh_code that is in ATL or Amster
//dts 8/14/20 - MIM doesn't want Allocated invetnory on the snapshot. MIM is triggering orders based on this snapshot, and the Allocated inventory is not Available (duh)
//Create the BOH datastore  //Report query

//Load the Hourly BOH Extract
ldsboh = Create Datastore
ldsboh.Dataobject = 'd_pandora_hourly_boh'
llBOH = ldsboh.SetTransobject(sqlca)

IF llBOH < 0 THEN
   lsLogOut = "        *** Unable to create datastore for PANDORA Balance on Hand Extract.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: PANDORA Hourly Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "PANDORA"

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq < 0 Then Return -1

//ls_PacificTime = string(GetPacificTime('GMT', datetime(today(), now())), 'yyyy-mm-dd hh:mm:ss')

//Jxlim 03/09/2012 BRD #366 Construct file name BOHYYYYMMDD.csv
//Jxlim 02/09/2012 BRD #366 Construct file name BHYYYYMMDD
//lsFileName = "BH" + String(Date(today()), "yyyymmdd") + '.DAT'
lsFileName = "BOH" + lstoday + '.csv'

//Retrieve the BOH Data
lsLogout = 'Retrieving Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsBOH.Retrieve()

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '~t'
lsLogOut = 'Processing Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCount
	llNewRow = ldsOut.insertRow(0)
	
	//Sku
	lsTemp = ldsBOH.GetItemstring(llRowPos, 'sku')  /* SKU */
	lsOutString += lsTemp + "|"
	
	//qty
	//TEMPO!! - Format for qty?....
	//Avail Qty - GXMOR Issue 366 Version 4 5/15/2013
	lsTemp = String(ldsBOH.GetItemNumber(llRowPos, 'availqty'), "#############")
	If lsTemp = '' Then
		lsTemp = '0'
	End If
	lsOutString += lsTemp + "|"
	
	//Alloc Qty - GXMOR Issue 366 Version 4 5/15/2013
	lsTemp = String(ldsBOH.GetItemNumber(llRowPos, 'allocqty'), "#############")
	If lsTemp = '' Then
		lsTemp = '0'
	End If
	lsOutString += lsTemp + "|"
	
	//Open Orders Qty - GXMOR Issue 366 Version 4 5/15/2013
	lsTemp = String(ldsBOH.GetItemNumber(llRowPos, 'openorders'), "#############")
	If lsTemp = '' Then
		lsTemp = '0'
	End If
	lsOutString += lsTemp + "|"
	
	//Owner_cd - GXMOR Issue 366 Version 4 5/15/2013
	lsTemp = ldsBOH.GetItemstring(llRowPos, 'ownercd')  /* Oracle Sub-Inventory Location */
	lsOutString += lsTemp + "|"
	
	//Lot_no - GXMOR Issue 366 Version 4 5/15/2013
	lsTemp = ldsBOH.GetItemstring(llRowPos, 'lotno')  /* cs.Lot_no*/
	lsOutString += lsTemp + "|"
	
	//Project_Code - GXMOR Issue 366 Version 4 5/15/2013
	lsTemp = ldsBOH.GetItemstring(llRowPos, 'programcode')  /* cs.po_no as Project_Code */
	lsOutString += lsTemp + "|"
	
	//Jxlim 02/09/2012 BRD #366 built the record into file
	ldsOut.SetItem(llNewRow, 'Project_id', lsproject)
	ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	
	//Reset varible to clear out memory
	lsOutString =''
	lsTemp = ''

Next /*next output record */

//Write the Outbound File  - no need to save and re-retrieve - just use the currently loaded DW
If ldsOut.RowCount() > 0 Then
   gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'PANDORA')
End If

Destroy ldsBOH

Return 0
end function

public function integer uf_process_holds (string asproject, string as_otm_status);
Datastore	idsDMheader  

Long			llRowCount,llRowPos
String lsLogout, ls_Do_No
String ls_action, ls_return_cd, ls_error_message, lsWhCode, lsFromOwnerCD,lsFromWarehouse
String ls_Code_Descript, ls_Country, lsProcessOTM
Integer li_OTM_Return,liRC
String lsDeleteSkus[] 
Datetime ldtWHTime
n_otm ln_otm

If gs_OTM_Flag = 'Y' Then
	If Not isvalid(ln_otm) Then
		ln_otm = CREATE n_otm
	End if
	
	If Not isvalid(idsDMheader) Then
		idsDMheader = Create u_ds_datastore
		idsDMheader.dataobject= 'd_delivery_holds'
		idsDMheader.SetTransObject(SQLCA)
	End If
	
	//TimA 01/25/12 OTM Project.  Need the country of the warehouse.
	//Look for the new global_warhouse flag in the lookup table
	
	SELECT 	Code_Descript 	INTO :ls_Code_Descript FROM Lookup_Table   
	Where 	project_id = :asproject and Code_type = 'OTM' and Code_ID = 'global_warhouse';
		
	idsDMheader.Reset()
	
	//Open the File
	lsLogOut = '      - Opening File for Pandora Looking for Sweeper OTM Holds Processing for Status type: ' + as_OTM_Status
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
	//llRowCount = lu_ds.RowCount()
	llRowCount = idsDMheader.retrieve(asproject,as_OTM_Status)
	If llRowCount > 0 Then
		lsLogOut =  '        ' + String(llRowCount) + ' OTM Sweeper holds retrieved for processing.'
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		FileWrite(gilogFileNo,lsLogOut)
	End if
	
	ls_action = 'I'
	
	For llRowPos = 1 to llRowCount
		ls_Do_No = idsDMheader.Getitemstring(llRowPos,'Do_No')
		lsWhCode = idsDMheader.Getitemstring(llRowPos,'WH_Code')
	
		SELECT dbo.Warehouse.country
		INTO :ls_Country
		FROM dbo.Warehouse
		WHERE wh_code = :lsWhCode;
	
		If ls_Code_Descript = 'Y' Then
			lsProcessOTM = 'Y'
		Else
			//We still want to do US warehouses
			If ls_Country = 'US' then 
				lsProcessOTM = 'Y'
			else		
				lsProcessOTM = 'N'
			end if
		End if
		
		If lsProcessOTM = 'Y' Then	
			li_OTM_Return = ln_otm.uf_otm_send_order(ls_action, asproject, ls_Do_No, lsDeleteSkus, ls_return_cd, ls_error_message)		
			If li_OTM_Return = -1 then
				lsLogOut = '       ***OTM System Error! Unable to request OTM call for Do_No: ' + ls_Do_No 
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			else
		
				//Warehouse
				select user_field2 into :lsFromWarehouse
				from customer
				where project_id = :asProject and cust_code = :lsWhCode;
				
				ldtWHTime = f_getLocalWorldTime(lsWhCode)
				
				idsDMheader.SetItem(llRowPos, 'OTM_Call_Date', ldtWHTime) 
				//Set the ord_status to New per Roy and Dave 03/01/12
				idsDMheader.SetItem(llRowPos,'Ord_Status','N')
				idsDMheader.SetItem(llRowPos,'OTM_Status','H')
				
				lsLogOut = '       Do_No ' + ls_Do_No +  '  was sent to OTM successfully and placed on OTM Hold.'
				FileWrite(gilogFileNo,lsLogOut)		
				gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
				
			End if
		else
				//TimA 03/27/12 set order_status to new
				idsDMheader.SetItem(llRowPos,'Ord_Status','N')
				idsDMheader.SetItem(llRowPos,'OTM_Status','N')
				lsLogOut = '       ***OTM call for Do_No: ' + ls_Do_No + " was not sent because the flag to process US countries only is turned on."
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/		
		End if					
	
	Next /*file record */
		
	liRC = idsDMheader.Update()
	
	If liRC = 1 Then
		Commit;
	Else
		Rollback;
		lsLogOut =  "       ***System Error!  Unable to Save OTM on hold Records to database "
		FileWrite(gilogFileNo, lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogOut)
		Return -1
	End If
End if	
Return 0
end function

public subroutine uf_sendemailnotification (string aswh, string asinvoice, string astypeoforder);//TimA 05/30/12 Pandora issue #425
//Send email notifications to people that have email addresses in the remarks column of warehouse
//All 3b18 files that and email address in the remarks column of warhouse needs to send and email to the list.
//Look in the remarks column for email names

String ls_PandoraRemark,ls_EmailString[], ls_Email
Integer li_NumberFound, li_Cnt

select remark into :ls_PandoraRemark
from warehouse
where wh_code = :aswh;

//TimA 01/17/13 Pandora issue #501
//Because of Cycle count records we need to find a warehouse because the CYC files on have owner
If ls_PandoraRemark = '' or IsNull(ls_PandoraRemark) then
	select Remark into :ls_PandoraRemark
	from Warehouse where WH_Code = 
	(select User_Field2 from Customer where Project_ID = 'PANDORA' and Cust_Code = :aswh);

End if

//Look for an @ sign to see if there is an email address.
If Pos(ls_PandoraRemark,"@")  > 0  Then
	
	string lstest
	u_sqlutil	SqlUtil
	If not Isvalid(SqlUtil) then
		SqlUtil = Create u_sqlutil
	End if
	
	//Call the function that Parses out the string	
	li_NumberFound = SqlUtil.uf_ParseStringToArray(ls_PandoraRemark,";",ls_EmailString)
	
	For li_Cnt = 1 to li_NumberFound
		ls_Email += 	ls_EmailString[li_Cnt] + ";"
		//lstest = "PANDORA" +"," +  ls_Email + "," +  asinvoice + "," +  " - " + asinvoice +  " has been dropped on " + aswh + "~r~r - Please take action as necessary"
	Next
	
	If ls_Email > "" Then
		gu_nvo_process_files.uf_send_email("PANDORA",ls_Email, asinvoice,  astypeoforder + " - " + asinvoice + " has been dropped on " + aswh + "~r~r - Please take action as necessary",'' )		
	End if
	
End if
end subroutine

public function integer uf_process_mim_receipt_ack (string aspath, string asproject);// uf_process_mim_receipt_ack(asPath, asProject)

/* ***********************************************************
 * process DR#####.DAT file - extract order no, datetime, transaction type and user
 *
 *	locate existing order, confirm type is 'MATERIAL RECEIPT', update receipt date/time and user
 *
 ************************************************************ */

string 		lsPath
string 		lsProject
string 		lsOrderNo
string 		lsTransType
string 		lsUserId
string      ls_dt
datetime 	ldtReceive 

string 		lsError = 'Existing order not found for order no: '
string 		lsTargetTransType = 'MATERIAL RECEIPT'
string 		lsRecData
integer 		lRtn = 0, liFileNo
Datastore	lds_Rpt
				
Long			llRowPos, llPrevPos, llRowCount, llFindRow,	llNewRow, llCurrentRow
String		lsFind, lsOutString, lslogOut, lsNextRunTime, lsNextRunDate
string		lsFileName, lsFileNamePath, lsErrorFileName
String 		ERRORS, sql_syntax, lsTemp	
LONG			llRC, llVarCnt, llRtn

boolean lbError //dts - 2/7/2013

lds_Rpt = Create Datastore
lds_Rpt.Dataobject = 'd_pandora_mim_receipt_ack'
llRC = lds_Rpt.SetTransobject(sqlca)

llRowCount = lds_Rpt.Reset()

lsLogOut = "- PROCESSING FUNCTION:  PANDORA MIM Receipt Ack!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "PANDORA"

//Open the File
lsLogOut = '      - Opening File for MIM Receipt Ack Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath, LineMode!, Read!, LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for PANDORA MIM Receipt Ack Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we won't move to error directory if we can't open the file here*/
End If

//create an error file to handle any file specific eerors - will have file name + .err
//gsErrorFileName = aspath + '.err.txt' 

//lsErrorFileName = ProfileString(gsinifile,lsDir[llDirPos],"errordirectory","") + '\' + gsErrorFileName

//read file and load to datastore for processing
llRC = FileReadEx(liFileNo, lsRecData)

Do While llRC > 0
	llNewRow = lds_Rpt.InsertRow(0)
	// save the record
	llRtn = lds_Rpt.SetItem(llNewRow, 'rec_data', lsRecData)
	llRC = FileReadEx(liFileNo,lsRecData)
LOOP

FileClose(liFileNo)
	
// parse out the data
llRowCount = lds_Rpt.Rowcount( )
FOR llCurrentRow = 1 to llRowCount
	
	lsRecData = lds_Rpt.GetItemString(llCurrentRow, 'rec_data')
	llVarCnt = 1
	//dts - 2/7/2013 - llRowPos = POS(lsRecData, '|', llRowPos)
	llRowPos = POS(lsRecData, '|', 1)
	DO WHILE llRowPos > 0
		
		CHOOSE CASE llVarCnt
			CASE 1 // order no
				lsOrderNo = Left( lsRecData, llRowPos - 1 )
				lds_Rpt.SetItem(llCurrentRow, 'do_order_no', lsOrderNo )
				
			case 2 // receipt dt
				//dts - 2/7/2013 - ls_dt	 = MID( lsRecData, llPrevPos + 1, (llRowPos - llPrevPos) ) 
				ls_dt	 = TRIM(MID( lsRecData, llPrevPos + 1, llRowPos - llPrevPos -1 ))
				//IF IsDate(ls_dt) THEN 
					ldtReceive = DateTime(ls_dt)
				//ELSE
				//	ldtReceive = DateTime(today(), now() )
				//END IF
				lds_Rpt.SetItem(llCurrentRow, 'do_receiptdt', ldtReceive )
				
			case 3 // transaction type
				//dts - 2/7/2013 - lsTransType = MID( lsRecData, llPrevPos + 1, (llRowPos - llPrevPos) )
				lsTransType = MID( lsRecData, llPrevPos + 1, llRowPos - llPrevPos -1)
				lds_Rpt.SetItem(llCurrentRow, 'transaction_type', lsTransType )
				
			case 4 // user
				//dts - 2/7/2013 - lsUserId = MID( lsRecData, llPrevPos + 1, (llRowPos - llPrevPos) )
				lsUserId = MID( lsRecData, llPrevPos + 1, llRowPos - llPrevPos -1)
				lds_Rpt.SetItem(llCurrentRow, 'do_userid', lsUserId )
				
		END CHOOSE
				
		llPrevPos = llRowPos
		llVarCnt++
		
		if llVarCnt < 4 then
			//dts - 2/7/2013 - llRowPos = POS(lsRecData, '|', llRowPos)
			llRowPos = POS(lsRecData, '|', llRowPos +1)
		elseif llVarCnt = 4 then //dts  - 2/7/2013 - added condition for 4th field
			llRowPos = LEN(lsRecData) + 1
		else //dts - 2/7/2013 - setting to 0 to get out of the loop.
			llRowPos = 0
		end if
		
	LOOP			
	
NEXT /*parse the records*/

lsLogOut = '      - MIM Receipt Ack File Parsing complete: ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

lRtn = 0
llRowCount = lds_Rpt.rowcount()
FOR llCurrentRow = 1 to llRowCount
	// process the rows
	lsOrderNo	= lds_Rpt.GetItemString( llCurrentRow, 'do_order_no' )
	lsTransType = lds_Rpt.GetItemString( llCurrentRow, 'transaction_type' )
	lsUserId		= lds_Rpt.GetItemString( llCurrentRow, 'do_userid' )
	ldtReceive	= lds_Rpt.GetItemDateTime( llCurrentRow, 'do_receiptdt' )
	
	IF lsTransType <> lsTargetTransType THEN
		// not the correct transaction type
		lsLogOut = "MIM Receipt Ack - Row: " + string(llCurrentRow) + " invalid transaction type."
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		gu_nvo_process_files.uf_writeError(lsLogOut )
		lbError = True //dts

		CONTINUE
		
	ELSE
		// correct type - process it; make the changes to the db; Receive_date = dtstamp; User_Field17 = user
		SELECT count(*) INTO :llRtn
		FROM Delivery_Master 
		WHERE Project_Id = 'PANDORA' 
		AND Invoice_No = :lsOrderNo 
		USING SQLCA;
		
		IF SQLCA.sqlcode = 0 AND llRtn = 1 THEN
			UPDATE Delivery_Master
			SET Receive_Date = :ldtReceive, 
				 User_Field17 = :lsUserId
			WHERE Project_Id = 'PANDORA' 
			AND Invoice_No = :lsOrderNo 
			USING SQLCA; 
			
			IF SQLCA.sqlcode <> 0 THEN
				// error - 
				lsLogOut = "MIM Receipt Ack - Row: " + string(llCurrentRow) + " order no (" + lsOrderNo + ") not updated."
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut )
				lbError = True //dts
			ELSE
				lRtn++
			END IF
			
		ELSE
			// *ding* - error 
			lsLogOut = "MIM Receipt Ack - Row: " + string(llCurrentRow) + " order no (" + lsOrderNo + ") not found."
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			//gu_nvo_process_files.uf_writeError(lsLogOut )		// LTK 20150320  Don't write error file for these receipt acknowledgements
			lbError = True //dts
		END IF 
		
		
	END IF

NEXT

lsLogOut = '      - MIM Receipt Ack File Processing complete: ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//dts - 2/7/2013 - RETURN lRtn 
If lbError then
	Return -1
Else
	Return 0
End If

end function

public function boolean getcartonserialdata (string asproject, string aspallet, string ascarton, string asserial);// Function used in uf_proacess_po_rose to determine whether an LPN serialNo exists in carton_serial table with pallet and carton IDs passed
// Return true if found false if not
boolean lb_return
long ll_count, ll_batch
string ls_batch

lb_return = false			//Initialize return value

Select rm.supp_invoice_no into :is_Invoice
From Carton_Serial cs with (NOLOCK), Receive_Master rm with (NOLOCK)
Where cs.Project_id = :asproject and cs..Project_id = :asproject
And cs.Pallet_Id = :aspallet  And cs.carton_Id = :ascarton And cs.Serial_No = :asserial 
And rm.EDI_Batch_Seq_No = convert(int, cs.user_field10)
//And cs.Status_Cd <> 'D'			// GailM - 11/14/2013 - If a delivery record exists, this will update it to New (the delivery record will be removed.
Using    SQLCA;

If is_Invoice <> '' Then
	lb_return = true
End If

return lb_return




end function

public function integer uf_process_mim_demand (string aspath);/*dts 1/14/14 - 701: MIM Demand Management
Testing proof-of-concept: loading MIM demand and Alternate SKU Look-up from spreadsheet (two tabs in a single file)
This data can be used to report inventory availability against the demand 
Need to bullet proof...
May choose to have MIM deliver data in two text files instead of spreadsheet with two tabs
*/
string lsLogOut

string ls_tab
long ll_line_no
integer li_count

String ls_tab_name_ident 
long ll_SSCount, ll_Idx
string ls_WorkSheet
string ls_sku, ls_alt_sku
integer li_current_line, li_sku_idx
integer li_exec_col
string lsOrder
boolean lbQuitter

datastore lds_load_file

int li_rtn
string ls_range, ls_supp_code, lsFileIdent
oleobject lole_excel, lole_workbook, lole_worksheet, lole_range
lole_excel = create oleobject
li_rtn = lole_excel.ConnectToNewObject("excel.application")

lsLogOut = 'Excel Open Return Val:' + string(li_rtn)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

if li_rtn <> 0 then
	lsLogOut = 'Error running MS Excel api.'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	destroy lole_Excel
	return -1
else
	lole_excel.WorkBooks.Open(aspath) 
	lole_workbook = lole_excel.application.workbooks(1)
	
	ll_SSCount = lole_workbook.Worksheets.Count 
	
	lsLogOut = 'Excel File:' + aspath + " - Worksheet Count: " + string(ll_SSCount)
	FileWrite(giLogFileNo, lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
	long ll_Qty_week0, ll_Qty_week1, ll_Qty_week2, ll_Qty_week3, ll_Qty_week4
	string ls_site, ls_generic
	
	lole_worksheet = lole_workbook.worksheets(1)
	ls_WorkSheet = lole_WorkBook.Worksheets(1).Name 
	lsLogOut = 'Worksheet name: ' + ls_WorkSheet
	FileWrite(giLogFileNo, lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	//validate worksheet name and format here....
	if upper(ls_WorkSheet) <> 'MIM DEMAND ANALYSIS' then
		lsLogOut = 'Unexpected worksheet name: ' + ls_WorkSheet
		FileWrite(giLogFileNo, lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		lbQuitter = True
	else
		ls_site =  nonull(string(lole_worksheet.cells(1, 1).value))
			if upper(ls_site) <> 'SITE' then
			lsLogOut = 'Unexpected worksheet format.  Expecting "SITE" in cell A1, instead of ' + ls_Site
			FileWrite(giLogFileNo, lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			lbQuitter = True
		end if
	end if
	if lbQuitter = true then
		lole_workbook.Close(false)
		lole_excel.application.quit()
		lole_excel.DisconnectObject()
		destroy lole_Excel
	end if

	lsLogOut = 'About to load new MIM Demand data...'
	FileWrite(giLogFileNo, lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
	delete from Pandora_Mim_Demand
	commit using SQLCA;
	li_current_line = 2
	
	Do 
		ls_site =  string(lole_worksheet.cells(li_current_line, 1).value)
		ls_sku =  string(lole_worksheet.cells(li_current_line, 2).value)
		if len(trim(ls_sku)) > 0 then
			ll_Qty_Week0 =  long(lole_worksheet.cells(li_current_line, 4).value) 
			ll_Qty_Week1 =  long(lole_worksheet.cells(li_current_line, 5).value) 
			ll_Qty_Week2 =  long(lole_worksheet.cells(li_current_line, 6).value) 
			ll_Qty_Week3 =  long(lole_worksheet.cells(li_current_line, 7).value) 
			ll_Qty_Week4 =  long(lole_worksheet.cells(li_current_line, 8).value) 
			ls_generic =  string(lole_worksheet.cells(li_current_line, 10).value)
			if upper(ls_generic) = 'GENERIC' then
				ls_generic = 'Y'
			else
				ls_generic = 'N'
			end if
			
			insert into Pandora_Mim_Demand(Location, SKU, Week_0, Week_1, Week_2, Week_3, Week_4, Generic_YN)
			values (:ls_site, :ls_sku, :ll_qty_Week0, :ll_qty_Week1, :ll_qty_Week2, :ll_qty_Week3, :ll_qty_Week4, :ls_Generic)
			commit Using SQLCA;
				
			if mod(li_current_line, 100) = 0 then
				lsLogOut = string(li_current_line - 1) + ' records processed...'
				FileWrite(giLogFileNo, lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) 
			end if
			li_current_line = li_current_line + 1
				
		end if
	
	Loop Until nonull(ls_sku) = ''
	
	lsLogOut = 'Done loading new MIM Demand data. ' + string(li_current_line - 2) + ' records loaded.'
	FileWrite(giLogFileNo, lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) 
	
	//now load the alternate part look-up....
	lole_worksheet = lole_workbook.worksheets(2)
	ls_WorkSheet = lole_WorkBook.Worksheets(2).Name 
	lsLogOut = 'Worksheet name: ' + ls_WorkSheet
	FileWrite(giLogFileNo, lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	//validate worksheet name and format here....
	if upper(ls_WorkSheet) <> 'ALTERNATIVE PART MATRIX' then
		lsLogOut = 'Unexpected worksheet name: ' + ls_WorkSheet
		FileWrite(giLogFileNo, lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		lbQuitter = True
	else
		ls_SKU =  nonull(string(lole_worksheet.cells(1, 1).value))
			if upper(ls_sku) <> 'GENERIC PN' then
			lsLogOut = 'Unexpected worksheet format.  Expecting "GENERIC PN" in cell A1, instead of ' + ls_SKU
			FileWrite(giLogFileNo, lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			lbQuitter = True
		end if
	end if
	if lbQuitter = true then
		lole_workbook.Close(false)
		lole_excel.application.quit()
		lole_excel.DisconnectObject()
		destroy lole_Excel
	end if
	
	lsLogOut = 'About to load new Alternate Part look-up'
	FileWrite(giLogFileNo, lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
	delete from Alternate_SKU_Lookup
	commit using SQLCA;
	li_current_line = 2
	
	Do 
		ls_sku =  string(lole_worksheet.cells(li_current_line, 1).value)
		if len(trim(ls_sku)) > 0 then
			ls_alt_sku =  string(lole_worksheet.cells(li_current_line, 2).value)
			
			insert into Alternate_SKU_Lookup(Project_id, SKU, Alternate_SKU)
			values ('PANDORA', :ls_sku, :ls_Alt_Sku)
			commit Using SQLCA;
				
			if mod(li_current_line, 100) = 0 then
				lsLogOut = string(li_current_line - 1) + ' records processed...'
				FileWrite(giLogFileNo, lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) 
			end if
			li_current_line = li_current_line + 1
		end if
	
	Loop Until nonull(ls_sku) = ''
	
	lsLogOut = 'Done loading new Alternate SKU Look-up data. ' + string(li_current_line - 2) + ' records loaded.'
	FileWrite(giLogFileNo, lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) 
	
	lole_workbook.Close(false)
	
	// Quit
	lole_excel.application.quit()
	lole_excel.DisconnectObject()
	
	destroy lole_Excel
end if //loaded Excel application
return 0

end function

public function integer uf_process_xcel_file (string asproject, string aspath, string asfile);
String ls_location, ls_Sku,ls_OrderType, ls_Part_Status, ls_Description, ls_GenericSku, ls_AlternateSku, ls_TabName, lsLogOut
Long ll_CurWeek, ll_Week1, ll_Week2, ll_Week3, ll_Week4, ll_Total, ll_row, lirc
long ll_SSCount, ll_Idx
string ls_WorkSheet
integer li_current_line
int li_rtn


//Clear out the table
Delete From Pandora_MIM_Demand_Analysis using SQLCA;

datastore lds_load_file
lds_load_file = CREATE datastore
lds_load_file.dataobject = "d_pandora_load_excel_mim_flatfile"
lds_load_file.SetTransObject(SQLCA)


oleobject lole_excel, lole_workbook, lole_worksheet, lole_range

try
	lole_excel = create oleobject
	li_rtn = lole_excel.ConnectToNewObject("excel.application")

	catch (Exception e )
		
		lsLogOut = 'Exception connecting to Excel file: ' + aspath + asfile + "   Exception: " + e.getMessage()
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
		if IsValid(lole_Excel) then destroy lole_Excel
		return -1
	
	catch (RuntimeError rte)
		
		lsLogOut = 'Runtime error connecting to Excel file: ' + aspath + asfile + "   Exception: " + e.getMessage()
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
		if IsValid(lole_Excel) then destroy lole_Excel
		return -1
	
	finally

end try

lsLogOut = 'Excel Open Return Val:' + string(li_rtn)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

If li_rtn <> 0 then
	lsLogOut = 'Error running MS Excel api.'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/	
		
     destroy lole_Excel
	 return -1
Else
	try
		lole_excel.WorkBooks.Open(aspath)
		lole_workbook = lole_excel.application.workbooks(1)
		
		catch (Exception ex )
			
			if IsNull(ex.getMessage()) then
				lsLogOut = 'Exception opening Excel file: ' + aspath + asfile + "   Exception: " + String(ex)
			else
				lsLogOut = 'Exception opening Excel file: ' + aspath + asfile + "   Exception: " + ex.getMessage()
			end if
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			
			if IsValid(lole_Excel) then 
		
				lole_excel.application.quit()
				lole_excel.DisconnectObject()
				destroy lole_Excel
		
			end if
		
			return -1
		
		catch (RuntimeError rtex)
			
			if IsNull(rtex.getMessage()) then
				lsLogOut = 'Runtime error opening Excel file: ' + aspath + asfile + "   Exception: " + String(rtex)
			else
				lsLogOut = 'Runtime error opening Excel file: ' + aspath + asfile + "   Exception: " + rtex.getMessage()
			end if
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			
			if IsValid(lole_Excel) then 
		
				lole_excel.application.quit()
				lole_excel.DisconnectObject()
				destroy lole_Excel
		
			end if
		
			return -1
		
		finally
				 
	end try
	
	
	ll_SSCount = lole_workbook.Worksheets.Count 
	
	lsLogOut = 'Excel File:' + asfile + " - Worksheet Count: " + string(ll_SSCount)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
	FOR ll_Idx = 1 TO ll_SSCount 
		
		lole_worksheet = lole_workbook.worksheets(ll_Idx )
		ls_WorkSheet = lole_WorkBook.Worksheets(ll_Idx ).Name 
	
			if Pos(Upper(ls_WorkSheet),"MIM DEMAND ANALYSIS") > 0 then
				ls_TabName = 'MIM DEMAND ANALYSIS'
				li_current_line = 2
				Do
					ls_location = nz(string(lole_worksheet.cells(li_current_line,1 ).value ) ,'' )
					ls_Sku = nz(string(lole_worksheet.cells(li_current_line,2 ).value ) ,'' )
					ls_OrderType = nz(string(lole_worksheet.cells(li_current_line,3 ).value ) ,'' )
					ll_CurWeek = nz(long(lole_worksheet.cells(li_current_line,4 ).value ) ,0 )
					ll_Week1 = nz(long(lole_worksheet.cells(li_current_line,5 ).value ) ,0 )
					ll_Week2 = nz(long(lole_worksheet.cells(li_current_line,6 ).value ) ,0 )
					ll_Week3 = nz(long(lole_worksheet.cells(li_current_line,7 ).value ) ,0 )
					ll_Week4 = nz(long(lole_worksheet.cells(li_current_line,8 ).value ) ,0 )
					ll_Total = nz(long(lole_worksheet.cells(li_current_line,9 ).value ) ,0 )
					ls_Part_Status = nz(string(lole_worksheet.cells(li_current_line,10 ).value ) ,'' )
					ls_Description = nz(string(lole_worksheet.cells(li_current_line,11 ).value ) ,'' )
	
					ll_row = lds_load_file.InsertRow(0 )
					lds_load_file.SetItem(ll_row, "project_id", 'PANDORA' ) 
					lds_load_file.SetItem(ll_row, "location", ls_location ) 
					lds_load_file.SetItem(ll_row, "sku", ls_Sku ) 
					lds_load_file.SetItem(ll_row, "order_type", ls_Sku ) 
					lds_load_file.SetItem(ll_row, "curr_week", ll_CurWeek ) 
					lds_load_file.SetItem(ll_row, "week_1", ll_Week1 ) 
					lds_load_file.SetItem(ll_row, "week_2", ll_Week2 ) 
					lds_load_file.SetItem(ll_row, "week_3", ll_Week3 ) 
					lds_load_file.SetItem(ll_row, "week_4", ll_Week4 ) 
					lds_load_file.SetItem(ll_row, "total", ll_Total ) 
					lds_load_file.SetItem(ll_row, "part_status", ls_Part_Status ) 
					lds_load_file.SetItem(ll_row, "description", ls_Description ) 
					//lds_load_file.SetItem(ll_row, "tab_name", ls_TabName ) 
	
					li_current_line = li_current_line + 1
					w_main.SetMicroHelp("Processing MIM Records. " + String(li_current_line))
					Yield()
	
				Loop Until trim(ls_location ) = '' 
				
			end if
	
	
			//TimA This second tab is not being used at this time.  The Atlanta warehouse is working on a solution on how they want to handle this
			//But let's keep it open
			if Pos(Upper(ls_WorkSheet),"ALTERNATIVE PART MATRIX") > 0 then
				ls_TabName = 'ALTERNATIVE PART MATRIX'
				li_current_line = 2
				Do
					ls_GenericSku = nz(string(lole_worksheet.cells(li_current_line,1 ).value ) , '' )
					ls_AlternateSku = nz(string(lole_worksheet.cells(li_current_line,2 ).value ) , '' )
					ls_Description = nz(string(lole_worksheet.cells(li_current_line,3 ).value ) , '' )
	
					//ll_row = lds_load_file.InsertRow(0 )
					//lds_load_file.SetItem(ll_row, "project", 'PANDORA' ) 
					//lds_load_file.SetItem(ll_row, "generic_sku", ls_GenericSku ) 
					//lds_load_file.SetItem(ll_row, "alternate_sku", ls_AlternateSku ) 
					//lds_load_file.SetItem(ll_row, "description", ls_Description ) 
	
					li_current_line = li_current_line + 1			
				Loop Until trim(ls_GenericSku ) = '' 
			end if
	Next
	lsLogOut = String(li_current_line) +  ' Files read from spreadsheet'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/	
	
	try
		
			lole_workbook.Close(false)
	
			// Quit
			lole_excel.application.quit()
			lole_excel.DisconnectObject()
	
			destroy lole_Excel
		
		catch (Exception er)
			
			lsLogOut = 'Exception closing/quiting/disconnectiong from Excel OLE object for Excel file: ' + aspath + asfile + "   Exception: " + er.getMessage()
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
			if IsValid(lole_Excel) then destroy lole_Excel
	
			return -1
	
		finally
				 
	end try
End if
	
//Save the Changes 
//SQLCA.DBParm = "disablebind =0"
w_main.SetMicroHelp("Saving MIM Records. " )
Yield()

lsLogOut =  "Saving MIM Records. " 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/	

lirc = lds_load_file.Update()
//SQLCA.DBParm = "disablebind =1"
		
If liRC <> 1 Then
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new MIM Demand Analysis data!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save MIM Demand Analysis data!")
	Return -1
Else
	lsLogOut =  "Saved. " 
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/	
End If
	
Commit;

w_main.SetMicroHelp("")
return 0
end function

public function integer uf_process_mim_demand_txt (string asproject, string aspath, string asfile);
Datastore	lu_ds
String fileread,lsStringData, lsrecdata, lsRecType, lsTemp
Long lifileno, llnewrow, llRowCount, llrowpos

String ls_location, ls_Sku,ls_OrderType, ls_Part_Status, ls_Description, ls_GenericSku, ls_AlternateSku, ls_TabName, lsLogOut
Long ll_CurWeek, ll_Week1, ll_Week2, ll_Week3, ll_Week4, ll_Total, ll_row, lirc
long ll_SSCount, ll_Idx
string ls_WorkSheet
integer li_current_line
int li_rtn


//Clear out the table
Delete From Pandora_MIM_Demand_Analysis using SQLCA;

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

datastore lds_load_file
lds_load_file = CREATE datastore
lds_load_file.dataobject = "d_pandora_load_excel_mim_flatfile"
lds_load_file.SetTransObject(SQLCA)

//Open and read the File In
lsLogOut = '      - Opening File MIM Demand Analysis Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for MIM Demand Analysis: " + asPath
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


llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	lsRecData = Trim(lu_ds.GetItemString(llRowPos,'rec_Data') )

	//Skip the header record.
	If UPPER ( Left(lsRecData,4 ) ) <>  'SITE'  then

		//Location
		If Pos(lsRecData,'|') > 0 Then
			lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
		Else 
			lsTemp = lsRecData
		End If
			ls_location = nz( trim( lsTemp ) ,'' )
			lsRecData = Right ( lsRecData, ( len ( lsRecData ) - ( Len(lsTemp) + 1 ) ) ) /*strip off to next Column */

		//Sku
		If Pos(lsRecData,'|' ) > 0 Then
			lsTemp = Left(lsRecData, ( pos ( lsRecData,'|' ) - 1 ) )
		Else 
			lsTemp = lsRecData
		End If
			ls_Sku = nz( trim( lsTemp ) ,'' )
			lsRecData = Right(lsRecData, ( len ( lsRecData ) - ( Len ( lsTemp ) + 1 ) ) ) /*strip off to next Column */

		//OrderType
		If Pos(lsRecData,'|' ) > 0 Then
			lsTemp = Left(lsRecData, ( pos ( lsRecData,'|' ) - 1 ) )
		Else 
			lsTemp = lsRecData
		End If
			ls_OrderType = nz( trim( lsTemp ) ,'' )
			lsRecData = Right(lsRecData, ( len ( lsRecData ) - ( Len ( lsTemp ) + 1 ) ) ) /*strip off to next Column */

		//CurWeek
		If Pos(lsRecData,'|' ) > 0 Then
			lsTemp = Left(lsRecData, ( pos ( lsRecData,'|' ) - 1 ) )
		Else 
			lsTemp = lsRecData
		End If
			ll_CurWeek = Long ( nz( trim( lsTemp ) ,0 ) )
			lsRecData = Right(lsRecData, ( len ( lsRecData ) - ( Len ( lsTemp ) + 1 ) ) ) /*strip off to next Column */

		//Week1
		If Pos(lsRecData,'|' ) > 0 Then
			lsTemp = Left(lsRecData, ( pos ( lsRecData,'|' ) - 1 ) )
		Else 
			lsTemp = lsRecData
		End If
			ll_Week1 = Long ( nz( trim( lsTemp ) ,0 ) )
			lsRecData = Right(lsRecData, ( len ( lsRecData ) - ( Len ( lsTemp ) + 1 ) ) ) /*strip off to next Column */

		//Week2
		If Pos(lsRecData,'|' ) > 0 Then
			lsTemp = Left(lsRecData, ( pos ( lsRecData,'|' ) - 1 ) )
		Else 
			lsTemp = lsRecData
		End If
			ll_Week2 = Long ( nz( trim( lsTemp ) ,0 ) )
			lsRecData = Right(lsRecData, ( len ( lsRecData ) - ( Len ( lsTemp ) + 1 ) ) ) /*strip off to next Column */

		//Week3
		If Pos(lsRecData,'|' ) > 0 Then
			lsTemp = Left(lsRecData, ( pos ( lsRecData,'|' ) - 1 ) )
		Else 
			lsTemp = lsRecData
		End If
			ll_Week3 = Long ( nz( trim( lsTemp ) ,0 ) )
			lsRecData = Right(lsRecData, ( len ( lsRecData ) - ( Len ( lsTemp ) + 1 ) ) ) /*strip off to next Column */

		//Week4
		If Pos(lsRecData,'|' ) > 0 Then
			lsTemp = Left(lsRecData, ( pos ( lsRecData,'|' ) - 1 ) )
		Else 
			lsTemp = lsRecData
		End If
			ll_Week4 = Long ( nz( trim( lsTemp ) ,0 ) )
			lsRecData = Right(lsRecData, ( len ( lsRecData ) - ( Len ( lsTemp ) + 1 ) ) ) /*strip off to next Column */

		//Total
		ll_Total = ll_CurWeek + ll_Week1 + ll_Week2 + ll_Week3 + ll_Week4


		//Part_Status
		If Pos(lsRecData,'|' ) > 0 Then
			lsTemp = Left(lsRecData, ( pos ( lsRecData,'|' ) - 1 ) )
		Else 
			lsTemp = lsRecData
		End If
			ls_Part_Status = nz( trim( lsTemp ) ,'' ) 
			lsRecData = Right(lsRecData, ( len ( lsRecData ) - ( Len ( lsTemp ) + 1 ) ) ) /*strip off to next Column */

		//Description
		If Pos(lsRecData,'|' ) > 0 Then
			lsTemp = Left(lsRecData, ( pos ( lsRecData,'|' ) - 1 ) )
		Else 
			lsTemp = lsRecData
		End If
			ls_Description = nz( trim( lsTemp ) ,'' ) 
			lsRecData = Right(lsRecData, ( len ( lsRecData ) - ( Len ( lsTemp ) + 1 ) ) ) /*strip off to next Column */

		ll_row = lds_load_file.InsertRow(0 )
		lds_load_file.SetItem(ll_row, "project_id", 'PANDORA' ) 
		lds_load_file.SetItem(ll_row, "location", ls_location ) 
		lds_load_file.SetItem(ll_row, "sku", ls_Sku ) 
		lds_load_file.SetItem(ll_row, "order_type", ls_OrderType ) 
		lds_load_file.SetItem(ll_row, "curr_week", ll_CurWeek ) 
		lds_load_file.SetItem(ll_row, "week_1", ll_Week1 ) 
		lds_load_file.SetItem(ll_row, "week_2", ll_Week2 ) 
		lds_load_file.SetItem(ll_row, "week_3", ll_Week3 ) 
		lds_load_file.SetItem(ll_row, "week_4", ll_Week4 ) 
		lds_load_file.SetItem(ll_row, "total", ll_Total ) 
		lds_load_file.SetItem(ll_row, "part_status", ls_Part_Status ) 
		lds_load_file.SetItem(ll_row, "description", ls_Description ) 

	End if	
	
	li_current_line = li_current_line + 1
	w_main.SetMicroHelp("Processing MIM Records. " + String(li_current_line))
	Yield()

Next

lsLogOut = String(li_current_line) +  ' Files read from Txt File'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/	

//Save the Changes 
//SQLCA.DBParm = "disablebind =0"
w_main.SetMicroHelp("Saving MIM Records. " )
Yield()

lsLogOut =  "Saving MIM Records. " 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/	

lirc = lds_load_file.Update()
//SQLCA.DBParm = "disablebind =1"
		
If liRC <> 1 Then
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new MIM Demand Analysis data!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save MIM Demand Analysis data!")
	Return -1
Else
	lsLogOut =  "Saved. " 
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/	
End If
	
Commit;

w_main.SetMicroHelp("")
return 0
end function

public function integer uf_process_hourly_receiving ();//Process PANDORA Hourly Receiving Report

CONSTANT String FILENAME = 'HRR'
CONSTANT String DELIMITER = '|'
CONSTANT String QUOTE_CHARACTER = ''
Datastore	ldsOut, ldsboh, lds_hourly_receiving
Long			llRowPos, llRowCount, llNewRow				
String		lsOutString, lslogOut, lsProject, lsFileName, lsFileNamePath, ls_null_warehouse, ls_out_attach_report
String		lstoday, lsTemp	
Decimal	ldBatchSeq
DateTime ldttoday, ldt_report_start_date

SetNull(ls_null_warehouse)

ldtToday = f_getlocalworldtime(ls_null_warehouse)
lsToday= String(ldtToday, 'yyyymmddhhmm')
ldt_report_start_date = DateTime(RelativeDate(Date(ldtToday), -7), Time(ldtToday))

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file
ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
ldsOut.SetTransobject(sqlca)

//Load the Hourly Receiving Extract
lds_hourly_receiving = Create Datastore
lds_hourly_receiving.Dataobject = 'd_pandora_hourly_receiving_report'

IF lds_hourly_receiving.SetTransobject(sqlca) < 0 THEN
	lsLogOut = "        *** Unable to create datastore for PANDORA Hourly Receiving Report (Extract)."
	FileWrite(gilogFileNo,lsLogOut)
	RETURN - 1
END IF

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: PANDORA Hourly Receiving Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "PANDORA"

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq < 0 Then Return -1

lsFileName = FILENAME + lstoday + '.csv'
//lsFileName = FILENAME + lstoday

//Retrieve the Received Data
lsLogout = 'Retrieving Hourly Receiving Report.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = lds_hourly_receiving.Retrieve(lsProject, ldt_report_start_date)

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsLogOut = 'Processing Hourly Receive Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCount + 1
	llNewRow = ldsOut.insertRow(0)
	
	if llRowPos = 1 then
		//lsOutString = "Warehouse,Order Number,To Location,Order Status,Complete Date"
		lsOutString = "Warehouse" + DELIMITER + "Order Number" + DELIMITER + "To Location" + DELIMITER + "Order Status" + DELIMITER + "Complete Date" + DELIMITER 
		
	else
		lsTemp = lds_hourly_receiving.GetItemstring(llRowPos -1, 'wh_code')  // Warehouse code
		lsOutString += lsTemp + DELIMITER
	
		lsTemp = lds_hourly_receiving.GetItemstring(llRowPos -1, 'supp_invoice_no')  // Invoice number
		lsOutString += lsTemp + DELIMITER
	
		lsTemp = lds_hourly_receiving.GetItemstring(llRowPos -1, 'user_field2')  // "To Location" user_field2
		lsOutString += lsTemp + DELIMITER
	
		// Order status, should be 'C' based on the SQL
		if lds_hourly_receiving.GetItemstring(llRowPos -1, 'ord_status') = "C" then
			lsTemp = "Complete"
		else
			lsTemp = lds_hourly_receiving.GetItemstring(llRowPos -1, 'ord_status')
		end if
		lsOutString += lsTemp + DELIMITER
	
		lsTemp = String(lds_hourly_receiving.GetItemDateTime(llRowPos -1, 'complete_date'), 'mm/dd/yyyy hh:mm:ss')  // Complete date
		lsOutString += lsTemp + DELIMITER
	end if

	ldsOut.SetItem(llNewRow, 'Project_id', lsproject)
	ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow, 'dest_cd', FILENAME)	
	
	ls_out_attach_report += lsOutString + '~r~n'
	
	lsOutString =''
	lsTemp = ''

Next /*next output record */


// Direct report destination
String ls_destination
ls_destination = f_retrieve_parm('PANDORA', 'PARM', 'HRLY_REC_RPT_DESTINATION')

if ls_destination = 'FTP' or ls_destination = 'BOTH' then

	// Write the Outbound File  - no need to save and re-retrieve - just use the currently loaded DW
	If ldsOut.RowCount() > 0 Then
		gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'PANDORA')
	End If

end if

if ls_destination = 'EMAIL' or ls_destination = 'BOTH' then

	// Email report
	lsFileName = FILENAME + lstoday + '_ATT.csv'
	lsFileNamePath = ProfileString(gsIniFile, lsProject, "archivedirectory","") + '\' + lsFileName
	//lds_hourly_receiving.SaveAs ( lsFileNamePath, CSV!, true )
	lds_hourly_receiving.SaveAsFormattedText( lsFileNamePath, EncodingANSI!, DELIMITER, QUOTE_CHARACTER )

	gu_nvo_process_files.uf_send_email("PANDORA", "HOURLY_RECEIVE_REPORT_EMAIL", " PANDORA Hourly Receive Report - Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the  PANDORA Hourly Receive Report, run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

end if


Destroy lds_hourly_receiving

Return 0
end function

public function integer uf_process_mim_outbound_report ();//Process PANDORA MIM Outbound Report

// LTK 20141106  Pandora #906  Added inbound orders to the report
//dts - 01/05/15 - they now want all non-completed orders from the last 60 days in addition to orders completed in the last 10 days (no longer passing a date parameter)

CONSTANT String FILENAME = 'MDR'
CONSTANT String DELIMITER = '|'
CONSTANT String QUOTE_CHARACTER = ''
//CONSTANT Int		DAYS_TO_RETRIEVE = 10

Datastore	ldsOut, lds_mim_outbound
Long			llRowPos, llRowCount, llNewRow				
String		lsOutString, lslogOut, lsProject, lsFileName, lsFileNamePath, ls_null_warehouse, ls_out_attach_report
String		lstoday, lsTemp	
Decimal	ldBatchSeq
DateTime ldttoday //, ldt_report_start_date

SetNull(ls_null_warehouse)

ldtToday = f_getlocalworldtime(ls_null_warehouse)
lsToday= String(ldtToday, 'yyyymmddhhmm')
// ldt_report_start_date = DateTime(RelativeDate(Date(ldtToday), - DAYS_TO_RETRIEVE), Time(ldtToday))

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file
ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
ldsOut.SetTransobject(sqlca)

//Load the Hourly Receiving Extract
lds_mim_outbound = Create Datastore
lds_mim_outbound.Dataobject = 'd_pandora_mim_outbound_report'

IF lds_mim_outbound.SetTransobject(sqlca) < 0 THEN
	lsLogOut = "        *** Unable to create datastore for PANDORA MIM Outbound Report (Extract)."
	FileWrite(gilogFileNo,lsLogOut)
	RETURN - 1
END IF

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: PANDORA MIM Outbound Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "PANDORA"

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq < 0 Then Return -1

lsFileName = FILENAME + lstoday + '.csv'
//lsFileName = FILENAME + lstoday

//Retrieve the Received Data
lsLogout = 'Retrieving MIM Outbound Report.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//llRowCount = lds_mim_outbound.Retrieve(lsProject, ldt_report_start_date)
llRowCount = lds_mim_outbound.Retrieve(lsProject)

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsLogOut = 'Processing MIM Outbound Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCount + 1
	llNewRow = ldsOut.insertRow(0)
	
	if llRowPos = 1 then
		//lsOutString = "Warehouse,Order Number,To Location,Order Status,Complete Date"
		lsOutString = "Warehouse" + DELIMITER + "Order" + DELIMITER + "Order Type" + DELIMITER + "Order Date" + DELIMITER + "Order Status" + DELIMITER + "Delivery Date" + DELIMITER + "Receive Date" + DELIMITER
		
	else
		
		// Convert both report timestamps from local warehouse time to Pacific Time.  This will also be useful below if the datawindow is exported upon emailing the report.
		lds_mim_outbound.SetItem(llRowPos -1, 'ord_date', getpacifictime(	lds_mim_outbound.GetItemString(llRowPos -1, 'wh_code'), 	lds_mim_outbound.GetItemDateTime(llRowPos -1, 'ord_date') ) )
		lds_mim_outbound.SetItem(llRowPos -1, 'delivery_date', getpacifictime(	lds_mim_outbound.GetItemString(llRowPos -1, 'wh_code'), 	lds_mim_outbound.GetItemDateTime(llRowPos -1, 'delivery_date') ) )
		lds_mim_outbound.SetItem(llRowPos -1, 'receive_date', getpacifictime(	lds_mim_outbound.GetItemString(llRowPos -1, 'wh_code'), 	lds_mim_outbound.GetItemDateTime(llRowPos -1, 'receive_date') ) )

		lsTemp = lds_mim_outbound.GetItemstring(llRowPos -1, 'wh_code')  // Warehouse code
		lsOutString += lsTemp + DELIMITER
	
		lsTemp = lds_mim_outbound.GetItemstring(llRowPos -1, 'invoice_no')  // Invoice number
		lsOutString += lsTemp + DELIMITER
		
		lsTemp = lds_mim_outbound.GetItemstring(llRowPos -1, 'ord_type')  // Order Type
		lsOutString += lsTemp + DELIMITER

		lsTemp = String(lds_mim_outbound.GetItemDateTime(llRowPos -1, 'ord_date'), 'mm/dd/yyyy hh:mm')	// Order date
		lsOutString += lsTemp + DELIMITER

		lsTemp = lds_mim_outbound.Describe("Evaluate('LookUpDisplay(ord_status)',"+string(llRowPos -1) + ")")	// Order status
		lsOutString += lsTemp + DELIMITER

		lsTemp = String(lds_mim_outbound.GetItemDateTime(llRowPos -1, 'delivery_date'), 'mm/dd/yyyy hh:mm')	// Delivery date
		lsOutString += lsTemp + DELIMITER

		lsTemp = String(lds_mim_outbound.GetItemDateTime(llRowPos -1, 'receive_date'), 'mm/dd/yyyy hh:mm')	// Receive date
		lsOutString += lsTemp + DELIMITER
	end if

	ldsOut.SetItem(llNewRow, 'Project_id', lsproject)
	ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	
	ls_out_attach_report += lsOutString + '~r~n'
	
	lsOutString =''
	lsTemp = ''

Next /*next output record */


// Direct report destination
String ls_destination
ls_destination = f_retrieve_parm('PANDORA', 'PARM', 'MIM_DO_RPT_DESTINATION')

if ls_destination = 'FTP' or ls_destination = 'BOTH' then

	// Write the Outbound File  - no need to save and re-retrieve - just use the currently loaded DW
	If ldsOut.RowCount() > 0 Then
		gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'PANDORA')
	End If

end if

if ls_destination = 'EMAIL' or ls_destination = 'BOTH' then

	// Email report
	lsFileName = FILENAME + lstoday + '_ATT.csv'
	lsFileNamePath = ProfileString(gsIniFile, lsProject, "archivedirectory","") + '\' + lsFileName
	//lds_mim_outbound.SaveAs ( lsFileNamePath, CSV!, true )
	lds_mim_outbound.SaveAsFormattedText( lsFileNamePath, EncodingANSI!, DELIMITER, QUOTE_CHARACTER )

	gu_nvo_process_files.uf_send_email("PANDORA", "MIM_OUTBOUND_REPORT_EMAIL", " PANDORA MIM Order Report - Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the  PANDORA MIM Order Report, run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

end if


Destroy lds_mim_outbound
Destroy ldsOut

Return 0

end function

public function integer uf_process_confirmation_check ();//Check for Orders that have been confirmed (have a complete_date) but no associated batch_transaction confirmation record (GR for Inbound, GI for Outbound)
// - may want to (also/instead?) check for orders stuck in 'Confirming' status.
Datastore	ldsMissingIn, ldsMissingOut, ldsOut
				
Long			llRowPos, llRowCountIn, llRowCountOut, llFindRow,	llNewRow
				
String			lsFind, lsOutString, lslogOut, lsProject, lsNextRunTime, lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName, lsFileNamePath

String			ls_PacificTime
String 		ERRORS, sql_syntax, lsTemp	

Decimal		ldBatchSeq, ldBatchSeq_NonGIG
Integer		liRC
DateTime	ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

//Create the Missing Transaction datastore for Inbound orders...
ldsMissingIn = Create Datastore
sql_syntax = "select ro_No, rtrim(rm.Supp_Invoice_No) Supp_Invoice_No, Complete_Date, Ord_Type, Ord_Status"
sql_syntax += " from receive_master rm with(nolock)"
sql_syntax += " where project_id = 'pandora'"
sql_syntax += " and complete_date> getdate()-11"
sql_syntax += " and cast(ro_no as CHAR(20)) not in(select trans_order_id from Batch_Transaction bt with(nolock)"
sql_syntax += " where bt.Project_Id='pandora' and bt.Trans_Type='GR' and Trans_Create_Date >GETDATE()-11)"
sql_syntax += " order by rm.supp_Invoice_No"

ldsMissingIn.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for PANDORA Missing Inbound Order Confirmations.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF
ldsMissingIn.SetTransObject(SQLCA)

//Create the Missing Transaction datastore for Outbound orders...
ldsMissingOut = Create Datastore
sql_syntax = "select DO_No, rtrim(dm.Invoice_No) Invoice_No, Complete_Date, Ord_Type, Ord_Status"
sql_syntax += " from Delivery_master dm with(nolock)"
sql_syntax += " where project_id = 'pandora'"
sql_syntax += " and complete_date> getdate()-11"
sql_syntax += " and cast(do_no as CHAR(20)) not in(select trans_order_id from Batch_Transaction bt with(nolock)"
sql_syntax += " where bt.Project_Id='pandora' and bt.Trans_Type='GI' and Trans_Create_Date >GETDATE()-11)"
sql_syntax += " order by dm.Invoice_No -- dm.Complete_Date"

ldsMissingOut.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for PANDORA Missing Outbound Order Confirmations.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF
ldsMissingOut.SetTransObject(SQLCA)
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: PANDORA Confirmation Check!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "PANDORA"

lsLogout = 'Retrieving Inbound orders that are missing Confirmations.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCountIn = ldsMissingIn.Retrieve()

lsLogout = 'Retrieving Outbound orders that are missing Confirmations.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCountOut = ldsMissingOut.Retrieve()

lsLogOut = 'Orders missing Confirmations--  Inbound: ' + String(llRowCountIn) + ', Outbound: ' + string(llRowCountOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

if llRowCountIn + llRowCountOut > 0 then
	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq < 0 Then Return -1
	lsfileName = "ConfirmCheck" + String(ldBatchSeq, "00000") + ".DAT"

	//Write the rows to the generic output table - delimited by '|'
	
	//ls_Now = string(now(), 'yyyy-mm-dd hh:mm:ss')
	//ls_PacificTime = string(GetPacificTime('GMT', datetime(today(), now())), 'yyyy-mm-dd hh:mm:ss')
	//   I/O, Ord#, CompleteDate, OrdType, OrdStatus, System#
	llNewRow = ldsOut.insertRow(0)
	lsOutstring = "I/O|Ord#|CompleteDate|OrdType|OrdStatus|System#"
	ldsOut.SetItem(llNewRow, 'Project_id', lsproject)
	ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	
	For llRowPos = 1 to llRowCountIn
		llNewRow = ldsOut.insertRow(0)
		lsOutstring = "I|"
	
		lsTemp = ldsMissingIn.GetItemString(llRowPos, 'Supp_Invoice_No') 
		lsOutString += lsTemp + "|"
		lsTemp = string(ldsMissingIn.GetItemDateTime(llRowPos, 'Complete_Date') )
		lsOutString += lsTemp + "|"
		lsTemp = ldsMissingIn.GetItemString(llRowPos, 'Ord_Type') 
		lsOutString += lsTemp + "|"
		lsTemp = ldsMissingIn.GetItemString(llRowPos, 'Ord_Status') 
		lsOutString += lsTemp + "|"
		lsTemp = ldsMissingIn.GetItemString(llRowPos, 'ro_no') 
		lsOutString += lsTemp
		
		ldsOut.SetItem(llNewRow, 'Project_id', lsproject)
		ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
		ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
		ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	Next /*next output record */
	
	//Outbound...
	For llRowPos = 1 to llRowCountOut
		llNewRow = ldsOut.insertRow(0)
		lsOutstring = "O|"
	
	//	lsOutstring += ls_PacificTime + "|"
		lsTemp = ldsMissingOut.GetItemString(llRowPos, 'Invoice_No') 
		lsOutString += lsTemp + "|"
		lsTemp = string(ldsMissingOut.GetItemDateTime(llRowPos, 'Complete_Date') )
		lsOutString += lsTemp + "|"
		lsTemp = ldsMissingOut.GetItemString(llRowPos, 'Ord_Type') 
		lsOutString += lsTemp + "|"
		lsTemp = ldsMissingOut.GetItemString(llRowPos, 'Ord_Status') 
		lsOutString += lsTemp + "|"
		lsTemp = ldsMissingOut.GetItemString(llRowPos, 'do_no') 
		lsOutString += lsTemp
		
		ldsOut.SetItem(llNewRow, 'Project_id', lsproject)
		ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
		ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
		ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	Next /*next output record */
	
	//gailm - 03/20/2013 - Remove file from FlatFileOut to Archive Only...  No longer sent to MIM
	//Write the Outbound File for GIG - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_archive_outbound(ldsOut, "PANDORA")
	//Write the Outbound File for Non-GIG - no need to save and re-retrieve - just use the currently loaded DW
	//GailM - 03/21/2013 - Files no longer being sent to MIM.  Both GIG types will go into one file
	//gu_nvo_process_files.uf_process_archive_outbound(ldsOut_NonGIG, "PANDORA")
	
	// Direct report destination
	//String ls_destination
	//ls_destination = f_retrieve_parm('PANDORA', 'PARM', 'HRLY_REC_RPT_DESTINATION')
	//
	//if ls_destination = 'FTP' or ls_destination = 'BOTH' then
	//
	//	// Write the Outbound File  - no need to save and re-retrieve - just use the currently loaded DW
	//	If ldsOut.RowCount() > 0 Then
	//		gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'PANDORA')
	//	End If
	//
	//end if
	//
	//if ls_destination = 'EMAIL' or ls_destination = 'BOTH' then
	
		// Email report
		//lsFileName = FILENAME + lstoday + '_ATT.csv'
		lsFileNamePath = ProfileString(gsIniFile, lsProject, "archivedirectory","") + '\' + lsFileName
		//lds_hourly_receiving.SaveAs ( lsFileNamePath, CSV!, true )
		//lds_hourly_receiving.SaveAsFormattedText( lsFileNamePath, EncodingANSI!, DELIMITER, QUOTE_CHARACTER )
	
		gu_nvo_process_files.uf_send_email("PANDORA", "Confirmation_Check", " PANDORA Confirmation Check - Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the  PANDORA Confirmation Check Report, run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)
	
end if  //found Orders missing Confirmations


Return 0
end function

public function integer uf_process_om_inbound (string asproject);//30-MAY-2017 :Madhu - Pull/Process Orders from OM
long llRC

//connect to OM Database
gu_nvo_process_files.uf_connect_to_om(asproject)

//Get OM_Client_Id value
SELECT OM_Client_Id into :is_om_client_id 
FROM Project with(nolock) 
WHERE Project_Id =:asproject 
USING SQLCA;

//Pull Orders from OM to load into SIMS
llRC = uf_process_om_receipt(asproject) //Inbound Orders (ASN)

If llRC = 0 Then llRC = gu_nvo_process_files.uf_process_purchase_order(asProject)  //Write into SIMS

//Pull Delivery Orders from OM to load into SIMS
llRC = uf_process_om_delivery(asproject) //Inbound Orders (940)

If llRC = 0 Then llRC = gu_nvo_process_files.uf_process_delivery_order(asProject)  //Write into SIMS

//Pull SOC Orders from OM to load into SIMS
llRC = uf_process_om_soc(asproject) //Inbound Orders (940SOC)

//disconnect from OM Database
gu_nvo_process_files.uf_disconnect_from_om( )

return llRC
end function

public function integer uf_process_om_receipt (readonly string asproject);//14-JUNE-2017 :Madhu -PINT - Pull Inbound Orders from OM.
Datastore  ldsItem, ldsOrders, ldsRoNo

boolean lbLPN, lbSKUChanged, lbError, lbCrossDock, lb_mr_add_equals_add
boolean lb_treat_adds_as_updates, lbDetailError, lbSerializedSKU, lbFirst, lb_sn_in_carton_serial

String ls_org_sql, ls_change_request_nbrs, lsPoNo, lsPONO2Prev, lsSKUPrev, lsLogOut, lsAction, ls_Notes
String ls_OrderNo, lsLPNOrder, lsMaxOrd, lsTemp, ls_mr_add_is_add_flag, lsLPNSuffix, ls_receipt_lineNo, ls_UF7
String sql_syntax, ERRORS, lsRecData, lsSerial, lsContainer, lsActionCd, ls_om_enabled, ls_om_threshold, ls_om_client_id, lsErrText
String  lsWarehouse, ls_UF6, ls_country, lsSKU, lsSKU2, lsPONO2, lsTempQty, lsOwnerCD, ls_error_msg
String  lsOwnerCD_Prev, lsOwnerID, lsGroup, lsCrossDock_Loc, lsSupplier, lsProject, lsLPNActionCD, lsThisContainer
String ls_om_type, ls_omc_sql, ls_om_client_cust_po_no, ls_user_Line_Item_No, lsFind, ls_PrevOrderNo, ls_container_tracking_ind, lsAltSKU
String lsPoNo2Controlled
string lsNextLeg, ls_SAP_Enabled // dts - 01/16/2021, S53004

integer liItems, lirc

long 	ll_receipt_count, ll_receipt_detail_count, ll_receipt_queue_count, ll_change_request_nbr, ll_receipt_detail_sn
long 	ll_Row_Pos_RD, ll_Row_Pos_SN, ll_Row_Pos, ll_New_Row, llOrderSeq, llLineSeq, llNewNotesRow, ll_Old_LineNum
long  	ll_Batch_Seq, llLPNNo, ll_rm_count, ll_rm_pos, li_cnt, llLPNSuffix, llNewRoNoCount, llNewDetailRow, llLineNum
long 	llQuantity, llTempQty, ll_sn_count, llRemainingQty, llSerialCount, ll_rm_lpnbr, ll_detail_error_count, llNoteSeq
long	llDeleteRowPos, llDeleteRowCount, llFindRow

boolean lbUpdateExistRec =TRUE
boolean lbExcludeOrder = FALSE
datetime ldtWHTime, ldtToday

//GailM 10/25/2013 #668
llLPNNo = 1		//Initialize LPN No
lbLPN = false	//Default is false. Put it here anyway
lsPONO2Prev = ''	//initialize LPN previous pallet/ Roll LPN to pallet level
lsSKUPrev = ''
lbSKUChanged = false

ls_om_threshold =ProfileString (gsinifile ,"SIMS3FP", "OMTHRESHOLD","")

IF NOT isvalid(idsPOHeader) THEN						//EDI_Inbound_Header
	idsPOheader = Create u_ds_datastore
	idsPOheader.dataobject= 'd_po_header'
	idsPOheader.SetTransObject(SQLCA)
END IF

IF NOT isvalid(idsPOdetail) THEN							//EDI_Inbound_Detail
	idsPOdetail = Create u_ds_datastore
	idsPOdetail.dataobject= 'd_po_detail'
	idsPOdetail.SetTransObject(SQLCA)
END IF

IF NOT isvalid(ldsItem) THEN
	ldsItem = Create u_ds_datastore
	ldsItem.dataobject= 'd_item_master'
	ldsItem.SetTransObject(SQLCA)
END IF

IF NOT isvalid(idsRONotes) THEN							//Receive_Notes
	idsRONotes = Create u_ds_datastore
	idsRONotes.dataobject = 'd_mercator_ro_notes'
	idsRONotes.SetTransObject(SQLCA)
END IF

IF NOT isvalid(ldsOrders) THEN							//Receive_Master
	ldsOrders = Create u_ds_datastore
	ldsOrders.dataobject = 'd_receive_master'
	ldsOrders.SetTransObject(SQLCA)
END IF

IF NOT isvalid(idsOMCReceipt) THEN					//OMC_Receipt
	idsOMCReceipt = Create u_ds_datastore
	idsOMCReceipt.dataobject ='d_omc_receipt'
	idsOMCReceipt.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMCReceiptDetail) THEN		 		//OMC_ReceiptDetail
	idsOMCReceiptDetail = Create u_ds_datastore
	idsOMCReceiptDetail.dataobject ='d_omc_receipt_detail'
	idsOMCReceiptDetail.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMAReceiptQueue) THEN		 		//OMA_Receipt_Queue
	idsOMAReceiptQueue = Create u_ds_datastore
	idsOMAReceiptQueue.dataobject ='d_oma_receipt_queue'
	idsOMAReceiptQueue.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMReceiptDetailSerial) THEN   		//OMC_RECEIPTDETAIL_SERNUM
	idsOMReceiptDetailSerial =Create u_ds_datastore
	idsOMReceiptDetailSerial.dataobject ='d_omc_receiptdetail_sernum'
	idsOMReceiptDetailSerial.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(ldsRoNo) THEN
	ldsRoNo = Create Datastore
End If
			
//reset all datastores
idsPoheader.Reset()
idsPODetail.Reset()
idsRONotes.Reset()
ldsOrders.Reset()
idsOMCReceipt.reset()
idsOMCReceiptDetail.reset()
idsOMAReceiptQueue.reset()
idsOMReceiptDetailSerial.reset()

lsLogOut ="   OM Inbound Start Processing of uf_process_om_receipt() "
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Retrieve eligible records from Queue

ls_org_sql =idsOMAReceiptQueue.getsqlselect( )
ls_org_sql +=" AND DIST_SEQ_ID IN (SELECT SEQ_ID FROM OPS$OMAUTH.OMA_DISTRIBUTION WHERE SYSTEM_TYPE='SIMS' AND CLIE_CLIENT_ID ='"+is_om_client_id+"') "
ls_org_sql +=" AND ROWNUM < " + ls_om_threshold //Threshold
ls_org_sql +=" ORDER BY CHANGE_REQUEST_NBR  "
idsOMAReceiptQueue.setsqlselect( ls_org_sql)
ll_receipt_queue_count = idsOMAReceiptQueue.retrieve( )

lsLogOut =" RQ SQL query is -> "+ls_org_sql
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = " RQ count from OM -> "+string(ll_receipt_queue_count)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


//dts, 01/26/2021, S53004 (cont'd) - For SAP, using existence of Next Leg to drive CrossDock indicator
//  - Making crossdock Stamping configurable...
SELECT code_descript INTO :ls_SAP_Enabled
FROM lookup_table with(nolock)
WHERE project_id = :asProject
AND code_type = 'FLAG'
AND code_id = 'SAP_ENABLED'
USING SQLCA;

FOR ll_Row_Pos =1 to ll_receipt_queue_count
	
	ll_change_request_nbr = idsOMAReceiptQueue.getitemnumber(ll_Row_Pos, 'CHANGE_REQUEST_NBR') 
	ls_change_request_nbrs += string(ll_change_request_nbr) +","
	
NEXT

IF ll_receipt_queue_count > 0 Then
	ls_change_request_nbrs =left(ls_change_request_nbrs, len(ls_change_request_nbrs) -1)
	
	//Retrieving Orders from OM database	
	ls_omc_sql =idsOMCReceipt.getsqlselect( )
	ls_omc_sql +=" WHERE CHANGE_REQUEST_NBR IN ( " + ls_change_request_nbrs + " )" //Threshold
	idsOMCReceipt.setsqlselect( ls_omc_sql)
	ll_receipt_count = idsOMCReceipt.retrieve( )
	
	//Write to File and Screen
	lsLogOut = '      - OM Inbound - Query for OMC_Receipt : ' +ls_omc_sql
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	//Write to File and Screen
	lsLogOut = '      - OM Inbound - Getting count(Records) from OM Receipt Table for Processing: ' + string(ll_receipt_count)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
	// Reset main window microhelp message
	w_main.SetMicroHelp("Processing Receipt Order (ROSE) from OM")
	
	//1.Receipt Header
	For ll_Row_Pos = 1 to ll_receipt_count
		
		ll_New_Row = idsPOheader.InsertRow(0)
		llOrderSeq ++
		llLineSeq = 0
		
		CHOOSE CASE upper(idsOMCReceipt.getitemstring(ll_Row_Pos, 'CHANGE_REQUEST_INDICATOR'))
			CASE 'INSERT'
				lsAction ='A'
			CASE 'CANCEL'
				lsAction ='D'
			CASE 'UPDATE'
				lsAction ='U'
			CASE 'DELINS'
				lsAction ='U'
		END CHOOSE

		//Get the next available file sequence number
		ll_Batch_Seq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
		IF ll_Batch_Seq <= 0 THEN RETURN -1
	
		//New Record Defaults
		idsPOheader.SetItem(ll_New_Row, 'project_id', asProject)
		idsPOheader.SetItem(ll_New_Row, 'Request_date',String(Today(), 'YYMMDD'))
		idsPOheader.SetItem(ll_New_Row, 'edi_batch_seq_no', ll_Batch_Seq)
		idsPOheader.SetItem(ll_New_Row, 'order_seq_no', llOrderSeq) 
		idsPOheader.SetItem(ll_New_Row, 'Status_cd', 'N')
		idsPOheader.SetItem(ll_New_Row, 'Last_user', 'SIMSEDI')
		idsPOheader.SetItem(ll_New_Row, 'Order_type', 'S')
		idsPOheader.SetItem(ll_New_Row, 'Inventory_Type', 'N')
		idsPOheader.SetItem(ll_New_Row, 'OM_Order_Type', 'A') //A -> ASN
		idsPOheader.SetItem(ll_New_Row, 'OM_Confirmation_type', 'E') //E -> EDI
	
		//Action Code  /Change ID   
		idsPOheader.setitem( ll_New_Row, 'action_cd', lsAction) //Always A for ASN
		
		ll_change_request_nbr = idsOMCReceipt.getitemnumber(ll_Row_Pos, 'CHANGE_REQUEST_NBR')
		idsPOheader.SetItem(ll_New_Row, 'OM_CHANGE_REQUEST_NBR', ll_change_request_nbr)  //CHANGE_REQUEST_NBR
		
		//Write to Log File and Screen
		lsLogOut = '      - OM Inbound - Processing Header Record for Change Request Nbr: ' + string(ll_change_request_nbr)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		
		//Delivery Number AKA Order Number AKA Invoice Number
		ls_OrderNo = Left(idsOMCReceipt.getitemstring( ll_Row_Pos,'EXTERNALRECEIPTKEY2'),30)
	
		IF len(ls_OrderNo) > 0 Then
			idsPOheader.setitem( ll_New_Row, 'order_no', ls_OrderNo)
		ELSE
			ls_error_msg = "OM Inbound -Change_Request_Nbr ="+string(ll_change_request_nbr)+" , Order No# "+nz(ls_OrderNo,'-')+" -EXTERNALRECEIPTKEY2 shouldn't be NULL. Record will not be processed."
			idsPOheader.SetItem(ll_New_Row, 'Status_cd', 'E')
			idsPOheader.SetItem(ll_New_Row, 'Status_Message', 'EXTERNALRECEIPTKEY2 should not be NULL')
			gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'IB', ls_error_msg)
			lbError = True
			Continue //Process Next Record
		END IF
		
		//09/19 - PCONKL - Added CIMOR and check against client_cust_po_nbr
		ls_om_client_cust_po_no = idsOMCReceipt.getitemstring(ll_Row_Pos, 'EXTERNRECEIPTKEY')
		
		//  dts, 01/16/2021, S53004 - grab Previous Leg and Next Leg if present (for multi-leg orders)... 
		//      (note that we're not grabbing Multi-leg Indicator at this time, found in OMC_RECEIPT.SERVICE_TYPE (Y, N, or Null))
		idsPOheader.SetItem(ll_New_Row, 'User_Field13', idsOMCReceipt.getitemstring(ll_Row_Pos, 'SUSR5'))  //Previous Leg
		lsNextLeg = trim(idsOMCReceipt.getitemstring(ll_Row_Pos, 'SUSR4'))
		idsPOheader.SetItem(ll_New_Row, 'User_Field15', lsNextLeg)  //Next Leg

		//dts, 01/16/2021, S53004 - Now using existence of Next Leg to drive CrossDock indicator
		//dts, 01/26/2021, S53004 (cont'd) - Making crossdock Stamping configurable (while waiting for SAP go-live)
		if ls_SAP_Enabled <>'Y' then
			IF left(ls_OrderNo, 4) = 'CMOR' or left(ls_OrderNo, 4) = 'CMTR'  or left(ls_OrderNo, 5) = 'CIMOR'  or & 
				left(ls_om_client_cust_po_no, 4) = 'CMOR' or left(ls_om_client_cust_po_no, 4) = 'CMTR'  or left(ls_om_client_cust_po_no, 5) = 'CIMOR'               THEN  // LTK 20110218 Enhancement #166:  Added 'CMTR' but NOT 'FMTR' 
					lbCrossDock = True
					idsPOheader.SetItem(ll_New_Row, 'Crossdock_ind', 'Y')		
			ELSE
					lbCrossDock = False //14-MAR-2019 :Madhu DE9424 Reset flag
					idsPOheader.SetItem(ll_New_Row, 'Crossdock_ind', 'N')
			END IF
		else
			if len(lsNextLeg) > 0 then
				lbCrossDock = True
				idsPOheader.SetItem(ll_New_Row, 'Crossdock_ind', 'Y')		
			ELSE
				lbCrossDock = False //14-MAR-2019 :Madhu DE9424 Reset flag
				idsPOheader.SetItem(ll_New_Row, 'Crossdock_ind', 'N')
			END IF
		End If
		
		SELECT COUNT(*)
			INTO :ll_rm_count
		FROM receive_master with(nolock)
		WHERE Project_ID = :asProject
		AND (Supp_Invoice_No = :ls_OrderNo or Supp_Invoice_No like (:ls_OrderNo + '-LPN%'))
		AND Ord_Status = 'N' 
		USING SQLCA;
		
		
		idsPOheader.SetItem(ll_New_Row, 'Order_No', ls_OrderNo)  /* Order No  */
		
		// Retrieve the implementation flag
		SELECT code_descript
			INTO :ls_mr_add_is_add_flag
		FROM lookup_table with(nolock)
		WHERE project_id = :asProject
		AND code_type = 'FLAG'
		AND code_id = 'MR_ADD_IS_ADD'
		USING SQLCA;
		
				
		//follow below matrix to set UF7
		ls_om_type = idsOMCReceipt.getitemstring(ll_Row_Pos, 'TYPE')
		
		If upper(ls_om_type) ='ASN'  THEN
			ls_UF7 = 'PO RECEIPT'
		ELSE
			ls_UF7= 'MATERIAL RECEIPT'
		END IF

		//Write to Log File and Screen
		lsLogOut = "      - OM Inbound - Processing uf_process_om_receipt - OM Type: "+nz(ls_om_type, '-') +" - SQLCA Code: "+string(sqlca.sqlcode) +" - Batch Seq No: "+string(ll_Batch_Seq)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)

		//Insert Record into OM_Expansion_Table
		INSERT INTO OM_Expansion_Table (Project_Id, Table_Name, Key_Value, Line_Item_No, Column_Name, Column_Value)
			values ( :asproject, 'Receive_Master', :ll_Batch_Seq, 0, 'TYPE', :ls_om_type )
		USING SQLCA;
		
		If sqlca.sqlcode = 0 Then
			COMMIT;
		else
			lsErrText = sqlca.sqlerrtext
			ROLLBACK using SQLCA;
			//Write to Log File and Screen
			lsLogOut = "      - OM Inbound - Unable to Insert Record into OM_Expansion_Table .!~r~r Error SQLCA Code: " +string(sqlca.sqlcode) +" - Error Text: "+nz(lsErrText,'-')
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		End If
		
		lb_mr_add_equals_add = Pos(ls_UF7,'MATERIAL') > 0 and Upper(Trim(ls_mr_add_is_add_flag)) = 'Y'
		
		IF ll_rm_count = 1 and lsAction = 'A' and NOT lb_mr_add_equals_add THEN
			lb_treat_adds_as_updates = TRUE
		END IF
		
		// Gailm - 10/25/2013 - Issue #668 - Multiple LPN order will have -LPNnn as a suffix to the order.  Check here if this order has suffix.
		llLPNSuffix = Pos(ls_OrderNo,'-LPN')
		if llLPNSuffix > 0 then			//We have an LPN order
			lsLPNSuffix = Right(ls_OrderNo,Len(ls_OrderNo) - llLPNSuffix + 1)
			if isnumber(Right(lsLPNSuffix,2)) then 
				llLPNNo = Long(Right(lsLPNSuffix,2)) 
			end if
		else
			llLPNNo = 0
		end if
		
		If lsAction = 'U' or lb_treat_adds_as_updates Then  //IF the Action is "U"pdate We need to issue a delete and then an Add for the entire order
		
			sql_syntax = "SELECT RO_No, SKU, line_item_no, user_line_Item_No FROM Receive_Detail"    
			sql_syntax += " Where RO_no in (select ro_no from receive_master with(nolock) where project_id = 'PANDORA' and supp_invoice_no = '" + nz(ls_OrderNo,'-') + "'  and (Ord_Status = 'N' or Ord_Status = 'P'  ));"  
			
						
			ldsRoNo.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
			IF Len(ERRORS) > 0 THEN
				lsLogOut = "        *** Unable to create datastore for Pandora Sales Order Process.~r~r" + Errors
				FileWrite(gilogFileNo,lsLogOut)
				RETURN - 1
			END IF
			ldsRoNO.SetTransObject(SQLCA)
			llNewRoNoCount =ldsRoNo.Retrieve()
		End If
		
		idsPOheader.SetItem(ll_New_Row, 'supp_code', 'PANDORA')   	// Supplier ID -default to PANDORA
		idsPOheader.SetItem(ll_New_Row, 'Arrival_Date', string(idsOMCReceipt.getitemdatetime( ll_Row_Pos, 'EXPECTED_RECEIPT_DATE'), 'mm/dd/yyyy hh:mm')) //Expected Arrival Date
		lsWarehouse = idsOMCReceipt.getitemstring(ll_Row_Pos, 'DEST_WHS_ID')
		idsPOheader.SetItem(ll_New_Row,'wh_code', lsWarehouse)  	//WH Code
		
		If not isnull(idsOMCReceipt.getitemstring(ll_Row_Pos, 'CARRIERKEY')) Then
			idsPOheader.SetItem(ll_New_Row,'Carrier', Left(idsOMCReceipt.getitemstring(ll_Row_Pos, 'CARRIERKEY'), 10))  	//Carrier
		else
			idsPOheader.SetItem(ll_New_Row,'Carrier', 'MLOGUNKUNK')  	//Carrier
		End If
		
		idsPOheader.SetItem(ll_New_Row, 'remark', Left(idsOMCReceipt.getitemstring(ll_Row_Pos, 'NOTES'), 250)) //Remarks
		ls_UF6 = idsOMCReceipt.getitemstring(ll_Row_Pos, 'PLACE_OF_DISCHARGE')
		
		IF len(ls_UF6) > 0 THEN
			idsPOheader.SetItem(ll_New_Row, 'User_Field6', ls_UF6)  /* UF6 - 'From' Location */ 		
		ELSE
			ls_error_msg = "OM Inbound -Change_Request_Nbr ="+string(ll_change_request_nbr)+", Order No# "+nz(ls_OrderNo,'-')+" - PLACE_OF_DISCHARGE shouldn't be NULL. Record will not be processed."
			idsPOheader.SetItem(ll_New_Row, 'Status_cd', 'E')
			idsPOheader.SetItem(ll_New_Row, 'Status_Message', 'PLACE_OF_DISCHARGE should not be NULL')
			gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'IB', ls_error_msg)
			lbError = True
			Continue
		END IF

//TAM - 3/18 - S13945 -  Added customer type to the SQL
		string lsSFCustType
		
		//Jxlim 05/24/2011 #198 look up from customer _master table if user_field6 =cust_code then
		//set user_filed5 (country of dispatch) with country from customer_master
		SELECT   Country, Customer_Type Into :ls_country,  :lsSFCustType	 FROM   Customer with(nolock)
		WHERE  Project_id = :asproject					 
		AND       Cust_code = :ls_UF6				  
		USING    SQLCA;
	
		If sqlca.sqlcode = 0 Then

			//TAM - 3/18 - S13945 -  Don't allow "INACTIVE" customers(UF2) or from_location(UF6)
			If  lsSFCustType = 'IN' Then		
				ls_error_msg = "OM Inbound -Change_Request_Nbr ="+string(ll_change_request_nbr)+", Order No# "+nz(ls_OrderNo,'-')+" - PLACE_OF_DISCHARGE shouldn't be NULL. Record will not be processed."
				idsPOheader.SetItem(ll_New_Row, 'Status_cd', 'E')
				idsPOheader.SetItem(ll_New_Row, 'Status_Message', 'The From Location cannot be INACTIVE.')
				gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'IB', ls_error_msg)
				lbError = True
				Continue
			End If 
			
			idsPOheader.SetItem(ll_New_Row, 'User_Field5', ls_country)  /* UF6 - 'From' Location */ 
		End If
	
		idsPOheader.SetItem(ll_New_Row, 'User_Field7', ls_UF7)	/* UF7 - PO Line Type */ 
		idsPOheader.SetItem(ll_New_Row, 'User_Field9',  idsOMCReceipt.getitemstring(ll_Row_Pos, 'VENDOR_SHIPFROM_COMPANY'))  /* UF9 Vendor Name */  
		
		If Pos(ls_UF7, 'MATERIAL') > 0 Then 
			idsPOheader.SetItem(ll_New_Row, 'User_Field11', idsOMCReceipt.getitemstring(ll_Row_Pos, 'REFCHAR2'))  /* UF11 Requestor Name */ 
		End IF
		
		idsPOheader.SetItem(ll_New_Row, 'User_Field12', idsOMCReceipt.getitemstring(ll_Row_Pos, 'REFCHAR1'))  /* UF12 Cost Center */ 
		
		idsPOHeader.SetItem(ll_New_Row, 'customer_sent_date', String(idsOMCReceipt.getitemdatetime( ll_Row_Pos, 'SOURCEFILEDATE'),'YYYYMMDDHHMM')) // Customer_sent_date
		idsPOheader.SetItem(ll_New_Row, 'Supp_Order_No', idsOMCReceipt.getitemstring(ll_Row_Pos, 'RMA'))  /* Supp_Order_No */ 
		
		ls_om_client_cust_po_no = idsOMCReceipt.getitemstring(ll_Row_Pos, 'EXTERNRECEIPTKEY')
		idsPOheader.SetItem(ll_New_Row, 'Client_Cust_PO_NBR', Left(ls_om_client_cust_po_no, 30))  //Client Cust PO Nbr
		idsPOheader.SetItem(ll_New_Row, 'Vendor_Invoice_Nbr', idsOMCReceipt.getitemstring(ll_Row_Pos, 'SUSR2'))  //Vendor Order Number
		idsPOheader.SetItem(ll_New_Row, 'Client_Invoice_Nbr', idsOMCReceipt.getitemstring(ll_Row_Pos, 'SUSR1'))  //Client Invoice Nbr
		//idsPOheader.SetItem(ll_New_Row, 'Client_Invoice_Nbr', idsOMCReceipt.getitemstring(ll_Row_Pos, 'SUSR1'))  //Client Invoice Nbr

		ll_detail_error_count =0 //re-set detail error count value
		ls_error_msg ='' //re-set error msg value
		
	//2.RECEIPT_DETAIL STARTS
		ll_receipt_detail_count = idsOMCReceiptDetail.retrieve(ll_change_request_nbr )

		//Write to Log File and Screen
		lsLogOut = '      - OM Inbound - Processing Detail Record for Change Request Nbr: ' + string(ll_change_request_nbr) + " and count is: "+ string(ll_receipt_detail_count)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)

		For ll_Row_Pos_RD =1 to ll_receipt_detail_count
			
			lbDetailError = False
			llNewDetailRow =  idsPODetail.InsertRow(0)
			
			llLineSeq ++
			
			IF ls_OrderNo <> ls_PrevOrderNo THEN llLineNum =0 //Reset Line Num, if Order is different
			llLineNum ++
			ls_PrevOrderNo = ls_OrderNo //store Order No
			
			//Add detail level defaults
			idsPODetail.SetItem(llNewDetailRow,'order_seq_no', llOrderSeq) 
			idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no', ll_Batch_Seq) /*batch seq No*/
			idsPODetail.SetItem(llNewDetailRow,"order_line_no", string(llLineSeq))
			//idsPODetail.SetItem(llNewDetailRow,'line_item_no', llLineNum)
			idsPODetail.SetItem(llNewDetailRow,'supp_code', 'PANDORA')
			
			IF lb_treat_adds_as_updates Then
				idsPODetail.SetItem(llNewDetailRow,'action_cd','U') 
			else
				idsPODetail.SetItem(llNewDetailRow,'action_cd',lsAction) //set Header Action Cd
			END IF

			idsPODetail.SetItem(llNewDetailRow, 'Order_No',ls_OrderNo) //Order No -Map with Header Order No
			
			IF not isnull(idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO')) Then //Line Item Number
				idsPODetail.SetItem(llNewDetailRow,'user_line_item_no',idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO'))
			else
				ls_error_msg +="OM Inbound - Row: " + string(llNewDetailRow) + " - Line Item Number should not be NULL. Record will not be processed. ~n~r"
				idsPOheader.SetItem(ll_New_Row, 'Status_cd', 'E')
				idsPOheader.SetItem(ll_New_Row, 'Status_Message', 'Errors exist on Header/Detail')
				idsPODetail.SetItem(llNewDetailRow, 'Status_cd', 'E')
				idsPODetail.SetItem(llNewDetailRow, 'Status_Message', 'Line Item Number should not be NULL. Record will not be processed.')
				lbDetailError = True
			End If
			
			//29-MAY-2019 :Madhu S34063 Exclude Container Tracking Ind Condition for Orders 'MTR', CMTR', 'FMTR'
			// 07/20 - PCONKL - Needs to apply to Client Cust PO Nbr as well
			IF left(ls_OrderNo, 3)='MTR' OR left(ls_OrderNo, 4)='CMTR' OR left(ls_OrderNo, 4)='FMTR' or left(ls_om_client_cust_po_no, 3)='MTR' OR left(ls_om_client_cust_po_no, 4)='CMTR' OR left(ls_om_client_cust_po_no, 4)='FMTR' THEN
				lbExcludeOrder =TRUE
			ELSE
				lbExcludeOrder =FALSE
			END IF
			
			IF not isnull(idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'ITEM')) Then //SKU
				lsSKU = idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'ITEM') //SKU
				liItems = ldsItem.Retrieve( asProject, lsSKU )
			else
				ls_error_msg +="Row: " + string(llNewDetailRow) + " -SKU should not be NULL. Record will not be processed. ~n~r"
				idsPOheader.SetItem(ll_New_Row, 'Status_cd', 'E')
				idsPOheader.SetItem(ll_New_Row, 'Status_Message', 'Errors exist on Header/Detail')
				idsPODetail.SetItem(llNewDetailRow, 'Status_cd', 'E')
				idsPODetail.SetItem(llNewDetailRow, 'Status_Message', 'SKU should not be NULL. Record will not be processed.')
				lbDetailError = True
			End If
			
			//Write to Log File and Screen
			lsLogOut = '      - OM Inbound - Processing Detail Record for Change Request Nbr: ' + string(ll_change_request_nbr) +"  and Order No: "+ nz(ls_OrderNo,'-') +"  and Line Item No: " + idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO')
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			
			//16-Jan-2018 :Madhu S14839 -Foot Prints - START
			//Assign same Line Item No, if user_line_item_no already exists else bump up llLineNum++
			//14-FEB-2019 :Madhu DE8237 Added Order_No condition.
			If idsPODetail.rowcount( ) > 0  Then
				lsFind = "Order_No ='"+ls_OrderNo+"' and upper(sku) = '" + upper(lsSKU) +"' and user_line_item_no = '" + idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO') + "'"
				llFindRow = idsPODetail.find( lsFind, 1, idsPODetail.rowcount())
				If llFindRow > 0 Then
					ll_Old_LineNum = idsPODetail.getItemNumber( llFindRow, 'line_item_no')
					If ll_Old_LineNum > 0 Then
						idsPODetail.SetItem(llNewDetailRow,'line_item_no', ll_Old_LineNum)
						llLineNum -- //maintain sequence
					else
						idsPODetail.SetItem(llNewDetailRow,'line_item_no', llLineNum)					
					End If
				else
					idsPODetail.SetItem(llNewDetailRow,'line_item_no', llLineNum)					
				End If
			else
				idsPODetail.SetItem(llNewDetailRow,'line_item_no', llLineNum)	
			End If
//			//TAM 2019/04/03 - DE9673 - set the old line number to the llLineNum after PO Detail has been updated
//			ll_Old_LineNum = llLineNum

			//16-Jan-2018 :Madhu S14839 -Foot Prints - END
			
			/* may use to build itemmaster record 
			Need to check SKU in Item_Master and, if it's not there, check MFG SKU Look-up */
			Select distinct(SKU) into :lsSKU2
			From Item_Master with(nolock)
			Where Project_id = :asProject
			and SKU = :lsSKU
			USING SQLCA;
			
			IF lsSKU2 = '' THEN
				gu_nvo_process_files.uf_writeError("Change_Request_Nbr ="+string(ll_change_request_nbr)+" - Missing Pandora SKU....")
			END IF
			
			/* Populate ldsItem datastore to determine whether this SKU is LPN or non-LPN */
			//17-Jan-2018 :Madhu S14839 -Foot Prints - Disabled LPN logic
			//11/05/2017 DE6997 :GailM Re-enable lbLPN for testing.  Covered back up
			If liItems >= 1 then
				IF ldsItem.GetItemString(1, 'Foot_Prints_Ind') = "Y" THEN
					//lbLPN = true		//Will Not use the LPN for footprints
					lbLPN = false
				ELSE 
					lbLPN = false
				END IF
			else
				lbLPN  = false
			end if	
			
			If lsSKU <> lsSKUPrev Then
				lbSKUChanged = true
				lsSKUPrev = lsSKU
			End IF
			
			if liItems >= 1 then
				if (ldsItem.GetItemString(1, "serialized_ind") = "B" or ldsItem.GetItemString(1, "serialized_ind") = "I")  then
					lbSerializedSKU = TRUE
				else
					lbSerializedSKU = FALSE
				end if
			else
				lbSerializedSKU = FALSE
			end if
			
			IF liItems >=1 THEN
				ls_container_tracking_ind = ldsItem.getItemString( 1, 'Container_Tracking_Ind') //20-MAY-2019 :Madhu S33850 Container Tracked Items.
				lsPoNo2Controlled = ldsItem.getItemString( 1, 'Po_No2_Controlled_Ind')			//GailM 2/25/2020 S42902 Suppress PalletID on IB orders
			ELSE
				ls_container_tracking_ind ='N'
				lsPoNo2Controlled = 'N'
			END IF
		
			idsPODetail.SetItem(llNewDetailRow, 'SKU', lsSKU) //SKU
			idsPODetail.setitem(llNewDetailRow,'Quantity', string(idsOMCReceiptDetail.getitemnumber(ll_Row_Pos_RD, 'QTYEXPECTED'))) //Qty
			idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N') //Inventory Type
			
			// 10/19 - PCONKL - F19346/S39540 - If Alternate SKU not passed on order, load from Item Master
			//idsPODetail.setitem(llNewDetailRow,'alternate_sku', idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'ALTSKU')) //Alternate SKU
			
			lsAltSKU = idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'ALTSKU')
			If lsAltSKU = '' or isnull(lsAltSKU) Then
				
				Select Alternate_Sku into :lsAltSKU
				From Item_Master
				Where project_id = 'PANDORA' and sku = :lsSKU and supp_code = 'PANDORA'
				Using SQLCA;
				
				if isnull(lsAltSKU) Then lsAltSKU = ''
				
			End If
			
			idsPODetail.setitem(llNewDetailRow,'alternate_sku',lsAltSKU)
			
			
			idsPODetail.SetItem(llNewDetailRow, 'Lot_no', '-') //lot No
			
			if not isnull(idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'LOTTABLE03')) Then
				idsPODetail.setitem(llNewDetailRow,'PO_NO', idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'LOTTABLE03')) //Po No	
			else
				idsPODetail.setitem(llNewDetailRow,'PO_NO', 'MAIN') //Po No
			end If
			
			lsPoNo = idsPODetail.getitemstring(llNewDetailRow,'PO_NO') //Po No
			idsPODetail.SetItem(llNewDetailRow, 'user_field2', idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'SUSR1')) //UF2
			lsPONO2 = idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'SUSR5') //PO NO 2
			idsPODetail.SetItem(llNewDetailRow,'po_no2',lsPONO2)
			
			If lsPONO2Prev = "" Then
				lsPONO2Prev = lsPONO2
				lbFirst = TRUE
			Else
				lbFirst = FALSE
			End If
			
			llQuantity =  idsOMCReceiptDetail.getitemnumber(ll_Row_Pos_RD, 'QTYEXPECTED') //Qty
			
			IF lsPONO2 = lsPONO2Prev THEN
				if lbLPN Then
					if not lbFirst Then
						idsPODetail.DeleteRow(llNewDetailRow)
						llNewDetailRow = idsPODetail.RowCount()
						llLineSeq --		//Decrement OrderLineNo 
						llLineNum --
					else
						idsPODetail.SetItem(llNewDetailRow,'Quantity','0')
					end If
				else
					if isnull(idsPODetail.GetItemString(llNewDetailRow,'Quantity')) or lbSKUChanged then
						idsPODetail.SetItem(llNewDetailRow,'Quantity','0')
					end if
				
					llTempQty = Dec(idsPODetail.GetItemString(llNewDetailRow,'Quantity'))  + llQuantity
					lsTempQty = string(llTempQty)
					idsPODetail.SetItem(llNewDetailRow,'Quantity',lsTempQty)
				end If
			ELSE
				idsPODetail.SetItem(llNewDetailRow,'Quantity', '0')
				llTempQty = Dec(idsPODetail.GetItemString(llNewDetailRow,'Quantity'))  + llQuantity
				lsTempQty = string(llTempQty)
				idsPODetail.SetItem(llNewDetailRow,'Quantity', lsTempQty)
				lsPONO2Prev = lsPONO2
			END IF
			
			//Need to look-up Owner_CD (but shouldn't look it up for each row if it doesn't change)
			lsOwnerCD = idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'LOTTABLE01')
	
			if lsOwnerCD <> lsOwnerCD_Prev then 	
				lsOwnerID = ''
				select owner_id into :lsOwnerID
				from owner with(nolock)
				where project_id = :asProject and owner_cd = :lsOwnerCD
				using SQLCA;

				// TAM 2017/09 - SIMSPEVS - 816 - If Customer Type = "INACTIVE" then it is invalid -Begin
				string lsSTCustType
				
				select customer_type into :lsSTCustType
				from customer
				where project_id = 'PANDORA' and customer_type <> 'IN'
				and cust_code = :lsOwnerCD;
			
				// - Throw error message if Customer is not in Customer_Master
				if isnull(lsSTCustType) or lsSTCustType = '' then
					ls_error_msg +="Row: " + string(llNewDetailRow) + " -Invalid Customer Code specified. Record will not be processed. ~n~r"
					idsPOheader.SetItem(ll_New_Row, 'Status_cd', 'E')
					idsPOheader.SetItem(ll_New_Row, 'Status_Message', 'Errors exist on Header/Detail')
					idsPODetail.SetItem(llNewDetailRow, 'Status_cd', 'E')
					idsPODetail.SetItem(llNewDetailRow, 'Status_Message', 'Invalid Customer Code specified. Record will not be processed.')
					lbDetailError = True
				End iF
				// TAM 2017/09 - SIMSPEVS - 816 - If Customer Type = "INACTIVE" then it is invalid -End
	
				lsOwnerCD_Prev = lsOwnerCD
			end if
			
			idsPODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
			idsPOHeader.SetItem(ll_New_Row,'User_Field2',lsOwnerCD)			
			
			// dts, 01/16/2021, S53004 - For RMA, we need to stamp DM.UF14...
			//	 - From the BRD: If Receive To Ownercode is WH*PD then flag the order as DECOM, if WH*PM then flag the order as RMA, if WH*RK then flag the order as REMARKET
			if left(lsOwnerCD,2)='WH' then
				if right(lsOwnerCD,2)='PD' then idsPOHeader.SetItem(ll_New_Row, 'user_field14', 'DECOM')
				if right(lsOwnerCD,2)='PM' then idsPOHeader.SetItem(ll_New_Row, 'user_field14', 'RMA')
				if right(lsOwnerCD,2)='RK' then idsPOHeader.SetItem(ll_New_Row, 'user_field14', 'REMARKET')
			end if

			//If first row for the order, set UF2 to Sub-Inv Loc
			IF llLineSeq = 1 Then
				select user_field1, user_field2 into :lsGroup, :lsWarehouse
				from customer with(nolock)
				where project_id = :asProject and cust_code = :lsOwnerCD using sqlca;
				
				idsPOheader.SetItem(ll_New_Row, 'wh_code', lsWarehouse)
				
				// 4/2010  - now setting ord_date to local wh time
				ldtWHTime = f_getLocalWorldTime(lsWarehouse)
				idsPOheader.SetItem(ll_New_Row, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm')) 
				
				if lbCrossDock = True then
					select min(l_code) into :lsCrossDock_Loc from location with(nolock)
					where wh_code = :lsWarehouse and l_type = '9' using sqlca;
				end if
				
				lsCrossDock_Loc = NoNull(lsCrossDock_loc)
			END IF
			
			// 10/15/09 -  RMA has different Inventory_Type rules based on Project (po_no)...
			if lsGroup = 'RMA' then //now testing for RMA instead of not DECOM.
				if llLineSeq = 1  then // don't look up supplier for each detail row; only the first row for the order
					select supp_code into :lsSupplier
					from supplier with(nolock)
					where project_id = :asProject and supp_code = :ls_UF6 using sqlca;  //UF6 is 'FROM' Location
			
					if ls_UF6 > '' then
						idsPOHeader.SetItem(ll_New_Row, 'Order_Type', 'R') 
					end if
				end if
			
				if lsProject = 'RTV-RMA' or lsProject = 'RTV-PO' then
					idsPOHeader.SetItem(ll_New_Row, 'Inventory_Type', 'N') /* RTV */ 
					idsPOHeader.SetItem(ll_New_Row, 'Order_Type', 'Y') 
				elseif lsProject = 'OSV' then
					idsPOHeader.SetItem(ll_New_Row, 'Inventory_Type', 'N') 
					idsPOHeader.SetItem(ll_New_Row, 'Order_Type', 'Y') 
				elseif lsProject = 'REMARKET' then
					idsPOHeader.SetItem(ll_New_Row, 'Inventory_Type', 'N') 
					idsPOHeader.SetItem(ll_New_Row, 'Order_Type', 'Y') 
				else
					idsPOHeader.SetItem(ll_New_Row, 'Inventory_Type', 'N') /*default to Normal*/
				end if
			end if
			
			//If lbLPN Then
			//	idsPODetail.SetItem(llNewDetailRow, 'container_id', '-')		//Pallet Rollup.  Container No tracked forLPN (Set to dash)
			//Else
				If left(idsOMCReceipt.getitemstring(ll_Row_Pos, 'SUSR2'), 1) <> 'X' or isnull(idsOMCReceipt.getitemstring(ll_Row_Pos, 'SUSR2'))  Then /* 08/30/17 - PCONKL - added null check*/
					
					//20-MAY-2019 :Madhu S33850 Container Tracked Items. - START
					//29-MAY-2019 :Madhu S34063 Exclude Container Tracking Ind Condition
					IF ls_container_tracking_ind ='Y'  OR lbExcludeOrder THEN
						idsPODetail.SetItem(llNewDetailRow, 'container_id', idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'SUSR4')) //container Id
					ELSE
						//OCT 2019 - MikeA - DE12998
						idsPODetail.SetItem(llNewDetailRow, 'container_id', '') //container Id
					END IF
					//20-MAY-2019 :Madhu S33850 Container Tracked Items. - END
					
					//GailM 2/21/2020 S42902 F21477 Google - Suppress Pallet ID's on IB orders 
					IF lsPoNo2Controlled ='Y' OR lbExcludeOrder THEN
						idsPODetail.SetItem(llNewDetailRow, 'po_no2', idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'SUSR5')) //container Id
					ELSE
						idsPODetail.SetItem(llNewDetailRow, 'po_no2', '') //Pallet Id
					END IF
					
				End If
			//End If
			
			if lbCrossDock = True and lsCrossDock_Loc > '' then
				idsPODetail.SetItem(llNewDetailRow, 'l_code', lsCrossDock_Loc)
			end if
			
			idsPODetail.SetItem(llNewDetailRow, 'Client_Cust_PO_NBR', ls_om_client_cust_po_no) //Client_cust_Po_No
			idsPODetail.SetItem(llNewDetailRow, 'OM_CHANGE_REQUEST_NBR', idsOMCReceiptDetail.getitemnumber(ll_Row_Pos_RD, 'CHANGE_REQUEST_NBR'))  //CHANGE_REQUEST_NBR	
			ls_receipt_lineNo =idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD,'RECEIPTLINENUMBER')
			
			// TAM 2009/10/29 Find the Row in the Receive Detail Datastore and if Found Then Delete It from the DataStore.
			//  This will leave those records that need to be deleted from Receive Detail
			ls_user_Line_Item_No = idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO')
			
			If  idsPODetail.GetItemString(llNewDetailRow,'action_cd') = 'U' Then
				 lsFind = "upper(sku) = '" + upper(lsSKU) +"'"
				 lsFind += " and user_line_item_no = '" + ls_user_Line_Item_No + "'"
				 llFindRow = ldsRoNo.Find(lsFind, 1, ldsRoNo.RowCount())
			
				If llFindRow > 0 Then 
					  // TAM 2009/10/29 change line item number for updated row to original line number found. 
					  idsPODetail.SetItem(llNewDetailRow, 'line_item_no', ldsRoNo.GetItemNumber(llFindRow,'Line_Item_No'))
					  ldsRoNo.DeleteRow(llFindRow)
				 End If
			End If
			
			IF lbDetailError Then ll_detail_error_count++
		
	//3. RECEIPT SERIAL NUMBERS -OMC_RECEIPTDETAIL_SERNUM
		ll_receipt_detail_sn = idsOMReceiptDetailSerial.retrieve(ll_change_request_nbr, ls_receipt_lineNo )
		
		If ll_receipt_detail_sn > 0 Then
			//Write to Log File and Screen
			lsLogOut = '      - OM Inbound - Processing Serial Record for Change Request Nbr: ' + string(ll_change_request_nbr) +" and Line Item No: " + ls_receipt_lineNo + " and count is: "+ string(ll_receipt_detail_sn)
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
	
			lbUpdateExistRec =TRUE //set to TRUE for each detail record
			
			//GailM 7/10/2019 DE11612 Google - Not populating Container on inbound 856
			lsContainer = idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'SUSR4')
			
			FOR ll_Row_Pos_SN =1 to ll_receipt_detail_sn
				If lbSerializedSKU = False Then Continue
					
				// START SN SECTION
				// Since there are SN rows, save PD quantity and plug SN quantity to PODetail
				lsSerial = idsOMReceiptDetailSerial.getitemstring(ll_Row_Pos_SN, 'SERIAL_NUMBER')  	//Serial Number
	
				//update 1st record with Qty =1 and set SN.
				 IF lbUpdateExistRec THEN
					idsPODetail.SetItem(llNewDetailRow, 'quantity', '1')
					idsPODetail.SetItem(llNewDetailRow, 'Serial_No', lsSerial)
					
					//GailM 07/17/2019 DE11716 Google containerID error
					IF ls_container_tracking_ind ='Y' OR lbExcludeOrder THEN
						idsPODetail.SetItem(llNewDetailRow, 'container_id', lsContainer) //container Id
					ELSE
						//OCT 2019 - MikeA - DE12998
						idsPODetail.SetItem(llNewDetailRow, 'container_id', '') //container Id
					END IF
					
					//GailM 2/21/2020 S42902 F21477 Google - Suppress Pallet ID's on IB orders 
					IF lsPoNo2Controlled ='Y' OR lbExcludeOrder THEN
						idsPODetail.SetItem(llNewDetailRow, 'po_no2', lsPONO2) //container Id
					ELSE
						idsPODetail.SetItem(llNewDetailRow, 'po_no2', '') //Pallet Id
					END IF
					
					idsPODetail.SetItem(llNewDetailRow, 'OM_CHANGE_REQUEST_NBR', ll_change_request_nbr)  	//CHANGE_REQUEST_NBR
					lbUpdateExistRec =FALSE
					llQuantity = llQuantity - 1 //decrement qty					

						//Write to Log File and Screen
						lsLogOut = "      - OM Inbound - Processing Serial Record for Change Request Nbr: " + string(ll_change_request_nbr) +" and Line Item No: " + idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO') + "  and Serial No: " + lsSerial + " update existing row."
						FileWrite(giLogFileNo,lsLogOut)
						gu_nvo_process_files.uf_write_log(lsLogOut)
						
				ELSE
					llQuantity = llQuantity - 1 //decrement qty					
					llLineSeq ++
				
					IF llQuantity >= 0 THEN
					//now scroll through the serial records and create a detail line for each SN, with a quantity of 1
						llNewDetailRow =  idsPODetail.InsertRow(0)
						
						//Add detail level defaults
						idsPODetail.SetItem(llNewDetailRow,'order_seq_no', llOrderSeq) 
						idsPODetail.SetItem(llNewDetailRow,'project_id', asproject)
						idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N')
						idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
						idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no', ll_Batch_Seq)
						idsPODetail.SetItem(llNewDetailRow,"order_line_no", string(llLineSeq))
						
						//20-MAR-2019 :Madhu Assign existing Line_Item_No - START
						//TAM 2019/04/03 - DE9673 - Use llLineNum - it was set correctly above
						lsFind = "Order_No ='"+ls_OrderNo+"' and upper(sku) = '" + upper(lsSKU) +"' and user_line_item_no = '" + idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO') + "'"
						llFindRow = idsPODetail.find( lsFind, 1, idsPODetail.rowcount())
						If llFindRow > 0 Then
							ll_Old_LineNum = idsPODetail.getItemNumber( llFindRow, 'line_item_no')
							idsPODetail.SetItem(llNewDetailRow,'line_item_no', ll_Old_LineNum)
						else
							idsPODetail.SetItem(llNewDetailRow,'line_item_no', llLineNum)					
						End If
						//20-MAR-2019 :Madhu Assign existing Line_Item_No - END
						
						idsPODetail.SetItem(llNewDetailRow,'action_cd',lsAction) 
						idsPODetail.SetItem(llNewDetailRow,'supp_code', 'PANDORA')
						idsPODetail.SetItem(llNewDetailRow, 'Order_No', ls_OrderNo)
						idsPODetail.SetItem(llNewDetailRow,'user_line_item_no',idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO'))
						idsPODetail.SetItem(llNewDetailRow, 'SKU', lsSKU)
						idsPODetail.SetItem(llNewDetailRow,'quantity', '1')
						idsPODetail.SetItem(llNewDetailRow,'Alternate_SKU', idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'ALTSKU'))
						idsPODetail.SetItem(llNewDetailRow, 'Lot_no', '-')
						idsPODetail.SetItem(llNewDetailRow, 'PO_NO', lsPoNo)
						idsPODetail.SetItem(llNewDetailRow, 'user_field2', idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'SUSR1')) //UF2
						idsPODetail.SetItem(llNewDetailRow,'Serial_No', lsSerial)
						idsPODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
						idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N')
	
						//20-MAY-2019 :Madhu S33850 Container Tracked Items. - START
						//29-MAY-2019 :Madhu S34063 Exclude Container Tracking Ind Condition
						IF ls_container_tracking_ind ='Y' OR lbExcludeOrder THEN
							idsPODetail.SetItem(llNewDetailRow, 'container_id', lsContainer) //container Id
						ELSE
							//OCT 2019 - MikeA - DE12998
							idsPODetail.SetItem(llNewDetailRow, 'container_id', '') //container Id
						END IF
						//20-MAY-2019 :Madhu S33850 Container Tracked Items. - END
						
						//GailM 2/21/2020 S42902 F21477 Google - Suppress Pallet ID's on IB orders 
						IF lsPoNo2Controlled ='Y' OR lbExcludeOrder THEN
							idsPODetail.SetItem(llNewDetailRow,'po_no2', lsPONO2)
						Else
							idsPODetail.SetItem(llNewDetailRow,'po_no2', '')
						End If
						
						idsPODetail.SetItem(llNewDetailRow, 'Client_Cust_PO_NBR', ls_om_client_cust_po_no) //Client_cust_Po_No
						idsPODetail.SetItem(llNewDetailRow, 'OM_CHANGE_REQUEST_NBR', ll_change_request_nbr)  //CHANGE_REQUEST_NBR	
						
						//Write to Log File and Screen
						lsLogOut = "      - OM Inbound - Processing Serial Record for Change Request Nbr: " + string(ll_change_request_nbr) +" and Line Item No: " + idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO') + "  and Serial No: " + lsSerial
						FileWrite(giLogFileNo,lsLogOut)
						gu_nvo_process_files.uf_write_log(lsLogOut)
						
						if lbCrossDock = True and lsCrossDock_Loc > '' then
							idsPODetail.SetItem(llNewDetailRow, 'l_code', lsCrossDock_Loc)
						end if
					END IF
				END IF
					
			Next //Receipt Detail Serial Num
				
			//GailM 11/05/2018 DE6997 If there is remaining quantity then add an extra detail line without SN
			//20-Feb-2019 :Madhu DE8893 - Don't add extra line, if it is Non-Serialized even serial records are coming from OM.
			If llQuantity > 0 and lbSerializedSKU Then
				llNewDetailRow =  idsPODetail.InsertRow(0)
				llLineSeq ++
				
				//Add detail level defaults
				idsPODetail.SetItem(llNewDetailRow,'order_seq_no', llOrderSeq) 
				idsPODetail.SetItem(llNewDetailRow,'project_id', asproject)
				idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N')
				idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
				idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no', ll_Batch_Seq)
				idsPODetail.SetItem(llNewDetailRow,"order_line_no", string(llLineSeq))


				//20-MAR-2019 :Madhu Assign existing Line_Item_No - START
				//TAM 2019/04/03 - DE9673 - 
				lsFind = "Order_No ='"+ls_OrderNo+"' and upper(sku) = '" + upper(lsSKU) +"' and user_line_item_no = '" + idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO') + "'"
				llFindRow = idsPODetail.find( lsFind, 1, idsPODetail.rowcount())
				If llFindRow > 0 Then
					ll_Old_LineNum = idsPODetail.getItemNumber( llFindRow, 'line_item_no')
					idsPODetail.SetItem(llNewDetailRow,'line_item_no', ll_Old_LineNum)
				else
					idsPODetail.SetItem(llNewDetailRow,'line_item_no', llLineNum)					
				End If
				//20-MAR-2019 :Madhu Assign existing Line_Item_No - END
							
				idsPODetail.SetItem(llNewDetailRow,'action_cd',lsAction) 
				idsPODetail.SetItem(llNewDetailRow,'supp_code', 'PANDORA')
				idsPODetail.SetItem(llNewDetailRow, 'Order_No', ls_OrderNo)
				idsPODetail.SetItem(llNewDetailRow,'user_line_item_no',idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO'))
				idsPODetail.SetItem(llNewDetailRow, 'SKU', lsSKU)
				idsPODetail.SetItem(llNewDetailRow,'quantity', String(llQuantity))
				idsPODetail.SetItem(llNewDetailRow,'Alternate_SKU', idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'ALTSKU'))
				idsPODetail.SetItem(llNewDetailRow, 'Lot_no', '-')
				idsPODetail.SetItem(llNewDetailRow, 'PO_NO', lsPoNo)
				idsPODetail.SetItem(llNewDetailRow, 'user_field2', idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'SUSR1')) //UF2
				idsPODetail.SetItem(llNewDetailRow,'po_no2', lsPONO2)
				idsPODetail.SetItem(llNewDetailRow,'Serial_No', '-')
				idsPODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
				idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N')
				
				//20-MAY-2019 :Madhu S33850 Container Tracked Items. - START
				//29-MAY-2019 :Madhu S34063 Exclude Container Tracking Ind Condition
				IF ls_container_tracking_ind ='Y' OR lbExcludeOrder THEN
					idsPODetail.SetItem(llNewDetailRow, 'container_id', lsContainer) //container Id
				ELSE
					//OCT 2019 - MikeA - DE12998
					idsPODetail.SetItem(llNewDetailRow, 'container_id', '') //container Id
				END IF
				//20-MAY-2019 :Madhu S33850 Container Tracked Items. - END
				
				idsPODetail.SetItem(llNewDetailRow, 'Client_Cust_PO_NBR', ls_om_client_cust_po_no) //Client_cust_Po_No
				idsPODetail.SetItem(llNewDetailRow, 'OM_CHANGE_REQUEST_NBR', ll_change_request_nbr)  //CHANGE_REQUEST_NBR	
				
				//Write to Log File and Screen
				lsLogOut = "      - OM Inbound - Processing Serial Record for Change Request Nbr: " + string(ll_change_request_nbr) +" and Line Item No: " + idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO') + " with a blank SN and the remaining quantity."
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut)
				
				if lbCrossDock = True and lsCrossDock_Loc > '' then
					idsPODetail.SetItem(llNewDetailRow, 'l_code', lsCrossDock_Loc)
				end if			
			End If
		End If
			
	//4. RECEIPT NOTES - each detail line, make an entry for Notes.
		ls_Notes = idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD,'NOTES')
		IF not isnull(ls_Notes) or ls_Notes <>'' or ls_Notes <>' ' or len(ls_Notes) > 0 Then
			llNoteSeq++
			llNewNotesRow = idsRONotes.InsertRow(0)
			idsRoNotes.SetItem(llNewNotesRow,'project_id',asproject) /*Project ID*/
			idsRoNotes.SetItem(llNewNotesRow,'edi_batch_seq_no',ll_Batch_Seq) /*batch seq No*/
			idsRoNotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			idsRoNotes.SetItem(llNewNotesRow,'note_seq_no',llNoteSeq) /*Using our own sequential number so we can start a new row when we hit a ~ */
			idsRoNotes.SetItem(llNewNotesRow,'invoice_no', ls_OrderNo)
			idsRoNotes.SetItem(llNewNotesRow,'note_type','DS')
			idsRoNotes.SetItem(llNewNotesRow,'line_item_no',idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO'))
			idsRoNotes.SetItem(llNewNotesRow,'note_Text',ls_Notes)
			
			//Write to Log File and Screen
			lsLogOut = "      - OM Inbound - Processing Receive Notes Record for Change Request Nbr: " + string(ll_change_request_nbr) +" and Line Item No: " + idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO')
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
						
		END IF
		
		Next //Receipt Detail
		
		IF ll_detail_error_count > 0 Then 	gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'IB', ls_error_msg)
		
	Next //Receipt Master
ELSE
	Return 0
END IF

// LTK 20120608  Pandora #353 Don't delete RD records when treating Adds as Updates
IF NOT lb_treat_adds_as_updates then
	// TAM 2009/10/29 Any Rows left in the Detail Datastore need to be deleted so create a delete detail Row for each on.
	llDeleteRowCount = ldsRoNo.RowCount()
	If  llDeleteRowCount > 0 Then
		For llDeleteRowPos = 1  to llDeleteRowCount 
			llNewDetailRow =  idsPODetail.InsertRow(0)
			llLineSeq ++
			//Add detail level defaults
			idsPODetail.SetItem(llNewDetailRow,'order_seq_no', llOrderSeq) 
			idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no', ll_Batch_Seq) /*batch seq No*/
			idsPODetail.SetItem(llNewDetailRow,"order_line_no", string(llLineSeq))
			idsPODetail.SetItem(llNewDetailRow,'action_cd','D') 
			idsPODetail.SetItem(llNewDetailRow,'line_item_no', ldsRoNo.GetItemNumber(llDeleteRowPos,'line_item_no'))
			idsPODetail.SetItem(llNewDetailRow,'SKU', ldsRoNo.GetItemString(llDeleteRowPos,'SKU'))
			idsPODetail.SetItem(llNewDetailRow,'Order_No', ls_OrderNo)
		Next
	End If
End IF

// Reset main window microhelp message
w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Completed File Rows")

//Save the Changes 
lirc = idsPOHeader.Update()
 
If liRC = 1 Then
	liRC = idsPODetail.Update()
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

//Write to Log File and Screen
lsLogOut ="*** OM Inbound - End - Processing of uf_process_om_receipt() "
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//destroy all instances
destroy idsPoheader
destroy idsPODetail
destroy idsRONotes
destroy ldsOrders
destroy idsOMCReceipt
destroy idsOMCReceiptDetail
destroy idsOMAReceiptQueue
destroy idsOMReceiptDetailSerial
destroy ldsRoNo

// Reset main window microhelp message
w_main.SetMicroHelp("Ready")

Return 0 //21-MAR-2018 :Madhu DE3461 - Removed "Return -1"
end function

public function integer uf_process_om_delivery (readonly string asproject);//07-2017 :TAM -PINT - Pull Outbound Orders from OM.

Datastore	ldsDOHeader, ldsDODetail, ldsDOAddress, ldsDONotes
				
String			lsLogout, lsTemp,	lswarehouse,  lsSKU, ls_om_threshold, &
				lsDate, ls_temp,  &
				lsSoldToName, lsSoldToAddr1, lsSoldToAddr2, lsSoldToAddr3, lsSoldToAddr4, lsSoldToPhone, &
				lsSoldToZip, lsSoldToCity, lsSoldToState, lsSoldToCountry, &
				lsCustName, lsAddr1, lsAddr2, lsCity, lsState, lsZip, lsCountry, lsTel, lsCustType, &
				lsSTCust, lsSTCustType,  lsST_Group, lsSTCust_WH,  &
				lsOwnerCD, lsOwnerCD_Prev, lsOwnerID, lsWH, &
				lsInvoice, lsPrevInvoice, lsPrevInvoice_Detail, &
				lsToProject,  lsRequestor, lsRemark,  lsContainer, lsPoNo, lsCrossDock_Loc, &
				lsAction ,lsAltSku, ls_change_request_nbrs, ls_org_sql, &
				lsOTM_Y_N, lsCurrentOTMStatus, lsCurrentOrdStatus, lsdefaultTime, ls_error_msg, &
				ls_om_type, lsErrText, ls_susr4, &
				lsTmsFlag = 'N' , lsTmsWHFlag = '' //TAM 2019/03/31 - S25773 -DE9566
String			lsFind, lsExternOrderKey, lsOrderKey	//DE14765
				
Integer		liRC, i
				
Long			llRowPos,llNewRow, llNewDetailRow ,llOrderSeq,	llBatchSeq,	llLineSeq, llTempRow,	&
				llLineItemNo, llOwner, llNewAddressRow, llOwnerId,  &
				ll_delivery_queue_count, ll_delivery_count, ll_delivery_detail_count, ll_change_request_nbr, ll_Row_Pos_Detail, llCountInv, &
				ll_detail_error_count, ll_rc, ll_delivery_attr_count, ll_found, llNewNotesRow, llFound 
				
Decimal		ldQty, ldPrice
				
Boolean		lbError, lbDetailError, lbSoldToAddress,  lbCrossDock 

datetime		ldtToday, ldtWHTime, ldtCutoffDate, ldtRDD, ldtScheduleDate

Date  ldt_Temp		 

//GailM 08/08/2017 SIMSPEVS-537 - Identify MIM order - If not a MIM order, default to *all
String lsMIMOrder      = '*all'	
String lsCarrierAddr1 =  '*all'		//From CarrierMaster Address_1 (Expeditor, UPS, etc.
String lsCust              =  '*all'		
String lsMessage

string ls_SAP_Enabled // dts - 01/26/2021, S53004 (cont'd)

is_WhCode = ''
is_Invoice = ''
ls_om_threshold =ProfileString (gsinifile ,"SIMS3FP", "OMTHRESHOLD","")
ldtToday = DateTime(today(),Now())
				
idsDOHeader = Create u_ds_datastore
idsDOHeader.dataobject = 'd_shp_header'
idsDOHeader.SetTransObject(SQLCA)

idsDODetail = Create u_ds_datastore
idsDODetail.dataobject = 'd_shp_detail'
idsDODetail.SetTransObject(SQLCA)

ldsDOAddress = Create u_ds_datastore
ldsDOAddress.dataobject = 'd_mercator_do_address' //Delivery_Alt_Address
ldsDOAddress.SetTransObject(SQLCA)

ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes'
ldsDONotes.SetTransObject(SQLCA)


IF NOT isvalid(idsOMCDelivery) THEN					//OMC_Warehouse_Order
	idsOMCDelivery = Create u_ds_datastore
	idsOMCDelivery.dataobject ='d_omc_warehouse_order'
	idsOMCDelivery.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMCDeliveryDetail) THEN		 		//OMC_Warehouse_Order_Detail
	idsOMCDeliveryDetail = Create u_ds_datastore
	idsOMCDeliveryDetail.dataobject ='d_omc_warehouse_orderdetail'
	idsOMCDeliveryDetail.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMCDeliveryAttr) THEN		 		//OMC_Warehouse_OrderAttr
	idsOMCDeliveryAttr = Create u_ds_datastore
	idsOMCDeliveryAttr.dataobject ='d_omc_warehouse_orderattr'
	idsOMCDeliveryAttr.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMADeliveryQueue) THEN		 		//OMA_Warehouse_Order_Queue
	idsOMADeliveryQueue = Create u_ds_datastore
	idsOMADeliveryQueue.dataobject ='d_oma_warehouse_order_queue'
	idsOMADeliveryQueue.SetTransObject(om_sqlca)
END IF

idsOMCDelivery.reset()
idsOMCDeliveryDetail.reset()
idsOMADeliveryQueue.reset()
idsOMCDeliveryAttr.reset()
//Open the File
lsLogOut = '      - OM Inbound Start Processing of uf_process_om_delivery() ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//dts, 01/26/2021, S53004 (cont'd) - For SAP, using existence of Previous Leg to drive CrossDock indicator
//  - Making crossdock Stamping configurable...
SELECT code_descript INTO :ls_SAP_Enabled
FROM lookup_table with(nolock)
WHERE project_id = :asProject
AND code_type = 'FLAG'
AND code_id = 'SAP_ENABLED'
USING SQLCA;

lsLogOut =" SAP Enabled Y/N: " +nz(ls_SAP_Enabled,' ')
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Retrieve eligible records from Queue
ls_org_sql =idsOMADeliveryQueue.getsqlselect( )
ls_org_sql +=" AND DIST_SEQ_ID IN (SELECT SEQ_ID FROM OPS$OMAUTH.OMA_DISTRIBUTION WHERE SYSTEM_TYPE='SIMS' AND CLIE_CLIENT_ID ='"+is_om_client_id+"') "
ls_org_sql +=" AND ORDERGROUP<> 'SOC' " 
ls_org_sql +=" AND ROWNUM < " + ls_om_threshold //Threshold
ls_org_sql +=" ORDER BY CHANGE_REQUEST_NBR  "
idsOMADeliveryQueue.setsqlselect( ls_org_sql)
ll_delivery_queue_count = idsOMADeliveryQueue.retrieve( )

lsLogOut =" Warehouse Order Queue SQL query is -> "+ls_org_sql
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = " Warehouse Order Queue count from OM -> "+string(ll_delivery_queue_count)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


// load Queue datastore for processing
FOR llRowPos =1 to ll_delivery_queue_count
	ll_change_request_nbr = idsOMADeliveryQueue.getitemnumber(llRowPos, 'CHANGE_REQUEST_NBR') 
	ls_change_request_nbrs += string(ll_change_request_nbr) +","
NEXT

IF ll_delivery_queue_count > 0 Then
	ls_change_request_nbrs =left(ls_change_request_nbrs, len(ls_change_request_nbrs) -1)
	
	ls_org_sql =idsOMCDelivery.getsqlselect( )
	ls_org_sql +=" WHERE CHANGE_REQUEST_NBR IN ( " + ls_change_request_nbrs + " )" //Threshold
	idsOMCDelivery.setsqlselect( ls_org_sql)
	ll_delivery_count = idsOMCDelivery.retrieve( )

	//Retrieving Orders from OM database
	lsLogOut = '      - OM Outbound - Getting Count(Records) from OM Warehouse_Order Table for Processing: ' + string(ll_delivery_count)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
	// Reset main window microhelp message
	w_main.SetMicroHelp("Processing Delivery Order from OM")

	llOrderSeq = 0 /*order seq within file*/

// ***** LOAD HEADER RECORDS *****
	For llRowPos = 1 to ll_delivery_count
		
		ll_change_request_nbr = idsOMCDelivery.getitemnumber(llRowPos, 'CHANGE_REQUEST_NBR')

		//Write to Log File and Screen
		lsLogOut = '      -OM Outbound - Processing Header Record for Change Request Nbr: ' + string(ll_change_request_nbr)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)

		choose case  Upper(idsOMCDelivery.GetItemString(llRowPos, 'CHANGE_REQUEST_INDICATOR'))
			case 'INSERT'
				lsAction ='A'
			case 'UPDATE'
				lsAction ='U'
			case 'CANCEL'
				lsAction ='D'
//TAM TODO *should the default action be "ADD" or should we send an error
			case else
				lsAction ='A'
		end choose


		//Get the next available file sequence number
		llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
		If llBatchSeq <= 0 Then Return -1
		
	// Start Creating the Header	
		llNewRow = idsDOHeader.InsertRow(0)
		llOrderSeq ++
		llLineSeq = 0
		lbSoldToAddress = False

	//Record Defaults
		idsDOHeader.SetItem(llNewRow, 'project_id', asProject) /*Project ID*/
		idsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
		idsDOHeader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
		idsDOHeader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
//		idsDOHeader.SetItem(llNewRow, 'ftp_file_name', aspath) /*FTP File Name*/
		idsDOHeader.SetItem(llNewRow, 'Status_cd', 'N')
		idsDOHeader.SetItem(llNewRow, 'order_Type', 'S') /*default to SALE. we'll set it to 'Z' later if appropriate */
		idsDOHeader.SetItem(llNewRow, 'Last_user', 'SIMSOM')
		idsDOHeader.SetItem(llNewRow, 'OTM_Y_N', lsOTM_Y_N) 
		idsDOHeader.SetItem(llNewRow, 'OM_Order_Type', 'A') //A -> ASN
		idsDOHeader.SetItem(llNewRow, 'OM_Confirmation_type', 'E') //E -> EDI
			
		//Action Code  /Change ID   
		idsDOheader.setitem( llNewRow, 'action_cd', lsAction) //
		idsDOheader.SetItem(llNewRow, 'OM_CHANGE_REQUEST_NBR', ll_change_request_nbr)  //CHANGE_REQUEST_NBR
		
		// Get the orderattr records for this header. 		
		ll_delivery_attr_count = idsOMCDeliveryAttr.retrieve(ll_change_request_nbr )

		// Get the first detail record for this header. It contains Owner and PONO(project) needed on the header		
		ll_delivery_detail_count = idsOMCDeliveryDetail.retrieve(ll_change_request_nbr )

		// Get Project from first detail
		if ll_delivery_detail_count > 0 Then
			lsPoNo = Trim(idsOMCDeliveryDetail.GetItemString(1, 'LOTTABLE03'))
		End If

		If gs_OTM_Flag = 'Y' then lsOTM_Y_N = 'Y'  //Default to Yes (Y) sent to OTM

		If lsPoNo = 'RTV-RMA'  then
			lsOTM_Y_N = 'N'
		End if		

		//Delivery Number AKA Order Number AKA Invoice Number
		lsInvoice = trim(idsOMCDelivery.GetItemString(llRowPos, 'ExternOrderKey'))
		
		//TAM TODO
		// Getting Customer Master First.  DOn't Know if this is still needed since we are not doing multi stops
		//TAM 10/27/2017 Changed per Dave
//		lsSTCust = Trim(idsOMCDelivery.GetItemString(llRowPos, 'ConsigneeKey'))
		lsSTCust = Trim(idsOMCDelivery.GetItemString(llRowPos, 'CLIENT_SHIPTO_ID'))
		lsSTCustType='' // Dinesh - DE17352 - 10/01/2020- Sims - OM - Google - OB order rejecting 
		select customer_type, user_field1, user_field2 into :lsSTCustType, :lsST_Group, :lsSTCust_WH
		from customer
// TAM 2017/09 - SIMSPEVS - 816 - If Customer Type = "INACTIVE" then it is invalid
//		where project_id = 'PANDORA' 
		where project_id = 'PANDORA' and customer_type <> 'IN'
		and cust_code = :lsSTCust;
		
		lsLogOut = '      - OM Outbound Processing of uf_process_om_delivery() - Cust Code:  '+nz( lsSTCustType, '-')
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

		// - Throw error message if Customer is not in Customer_Master
		if isnull(lsSTCustType) or lsSTCustType = '' then
//			ls_error_msg = "Invalid Customer Code specified for Change Request NBR ="+string(ll_change_request_nbr)+ ", Customer Code (CONSIGNEEKEY) = "+ lsSTCust +". Record will not be processed."
			ls_error_msg = "OM Outbound - Invalid Customer Code specified for Change Request NBR ="+string(ll_change_request_nbr)+ ", Customer Code (CLIENT_SHIPTO_ID) = "+ lsSTCust +", Order No# "+nz(lsInvoice,'-')+". Record will not be processed."
			idsDOHeader.SetItem(llNewRow, 'Status_cd', 'E')
			idsDOHeader.SetItem(llNewRow, 'Status_Message', 'Invalid Customer Code specified' )
			gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
			lbError = True
			Continue //Process Next Record
		end if

		if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
			if lsToProject = 'RTV-RMA' or lsToProject = 'RTV-PO' then  //RTV, RTC, OSV, MRB, DECOM, SCRAP, 
				idsDOHeader.SetItem(llNewRow, 'Order_Type', 'X') 
			else
			end if
		end if

		//  Warehouse
		lsWh = idsOMCDelivery.GetItemString(llRowPos, 'Site_Id')
		IF len(lsWh) > 0 Then
			idsDOHeader.SetItem(llNewRow, 'wh_code', lsWh)
		ELSE
			ls_error_msg = "OM Outbound - Change_Request_Nbr ="+string(ll_change_request_nbr)+", Order No# "+nz(lsInvoice,'-')+" -SITEID(Warehouse) shouldn't be NULL. Record will not be processed."
			idsDOHeader.SetItem(llNewRow, 'Status_cd', 'E')
			idsDOHeader.SetItem(llNewRow, 'Status_Message', 'SITEID(Warehouse) should not be NULL')
			gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
			lbError = True
			Continue //Process Next Record
		END IF

		// Customer Order Type *From First Detail Record
		//need to set order type to 'Z' (for warehouse transfer) if customer is of type WH
		if lsSTCustType = 'WH' then 
			idsDOHeader.SetItem(llNewRow, 'order_Type', 'Z') /* warehouse Transfer*/
		end if
		
		// Order Date = Local Warehouse time
		ldtWHTime = f_getLocalWorldTime(lsWH)
		idsDOheader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))

		//Delivery Number AKA Order Number AKA Invoice Number
		IF len(lsInvoice) > 0 Then
			idsDOHeader.SetItem(llNewRow, 'Invoice_no', lsInvoice)
			idsDOHeader.SetItem(llNewRow, 'Order_no', lsInvoice)
		ELSE
			ls_error_msg = "OM Outbound - Change_Request_Nbr ="+string(ll_change_request_nbr)+" -EXTERNORDERKEY shouldn't be NULL. Record will not be processed."
			idsDOheader.SetItem(llNewRow, 'Status_cd', 'E')
			idsDOheader.SetItem(llNewRow, 'Status_Message', 'EXTERNORDERKEY should not be NULL')
			gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
			lbError = True
			Continue //Process Next Record
		END IF

		// Owner Code, Owner_Id  * Get from the first detail
		if ll_delivery_detail_count > 0 Then
			lsOwnerCd = Trim(idsOMCDeliveryDetail.GetItemString(1, 'LOTTABLE01'))
		else
			lsOwnerCd =''
		end if
		
		lsOwnerID = ''
		select owner_id into :lsOwnerID
		from owner
		where project_id = :asProject and owner_cd = :lsOwnerCD;
		
		IF len(lsOwnerID) > 0 Then
			lsOwnerCD_Prev = lsOwnerCD  // Used in detail Processing to see if the Owner Ccde has Changed

//TAM - 3/18 - S13945 -  For Pandora, Don't allow "INACTIVE" from_location(UF6) -Start
			String lsSFCustType

			select customer_type into :lsSFCustType
			from customer
			where project_id = 'PANDORA' 
			and cust_code = :lsOwnerCD;
			
			// - Throw error message if Customer is Inactive
			if  lsSFCustType = 'IN' then
				ls_error_msg = "OM Outbound - Invalid Customer Code specified for Change Request NBR ="+string(ll_change_request_nbr)+ ", Customer Code (CLIENT_SHIPTO_ID) = "+ lsSTCust +", Order No# "+nz(lsInvoice,'-')+". Record will not be processed."
				idsDOHeader.SetItem(llNewRow, 'Status_cd', 'E')
				idsDOHeader.SetItem(llNewRow, 'Status_Message', 'The Ship FROM Location cannot be INACTIVE.' )
				gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
				lbError = True
				Continue //Process Next Record
			end if
//TAM - 3/18 - S13945 -  For Pandora, Don't allow "INACTIVE" from_location(UF6) -End

		ELSE
			IF  lsAction <> 'D' Then // Owner not needed for deletes so skip error
				ls_error_msg = "OM Outbound - Change_Request_Nbr ="+string(ll_change_request_nbr)+" , Order No# "+nz(lsInvoice,'-')+" -LOTTABLE01(OWNER CODE) is not valid. Record will not be processed."
				idsDOheader.SetItem(llNewRow, 'Status_cd', 'E')
				idsDOheader.SetItem(llNewRow, 'Status_Message', 'LOTTABLE01(OWNER CODE) is not valid')
				gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
				lbError = True
				Continue //Process Next Record
			End If
		END IF

		//USER FIELD 2
		idsDOHeader.SetItem(llNewRow, 'user_field2', lsOwnerCD) /* 04/09 - PCONKL - Moved outside of if statement to unconditionally set the From Location */

//  dts, 01/16/2020, S53004 - For RMA, we need to stamp DM.UF19...
//	 - From the BRD: If Ship From Ownercode is WH*PD then flag the order as DECOM, if WH*PM then flag the order as RMA, if WH*RK then flag the order as REMARKET
		if left(lsOwnerCD,2)='WH' then
			if right(lsOwnerCD,2)='PD' then idsDOHeader.SetItem(llNewRow, 'user_field19', 'DECOM')
			if right(lsOwnerCD,2)='PM' then idsDOHeader.SetItem(llNewRow, 'user_field19', 'RMA')
			if right(lsOwnerCD,2)='RK' then idsDOHeader.SetItem(llNewRow, 'user_field19', 'REMARKET')
		end if

		//Schedule Date (ESD)
		//GailM 11/15/2017 SIMSPEVS-537  Change to use Advance ESD Configuration
		//TAM TODO USE GAILS CODE
		ldtToday = ldtWHTime // Get local system date
		
		
//		Select  Code_Descript INTO  :lsdefaultTime FROM lookup_table with (NoLock) 
//		Where Project_ID = 'PANDORA' AND Code_Type = 'ESDDEFAULT' and Code_Id = :lswarehouse  USING SQLCA;
//
//		If IsNull(lsdefaultTime) or lsdefaultTime = '' or Not isTime(lsdefaultTime) then lsdefaultTime ='14:00:00' //  - If not setup default to 2pm
//
//		ldtCutoffDate = datetime(relativeDate(date(ldtToday),0),time(lsdefaultTime)) // Get default date
//		ldt_Temp = RelativeDate(Date(ldtCutoffDate),0)
//		
//		If ldtToday < ldtCutoffDate and DayNumber(ldt_Temp) <> 7 and DayNumber(ldt_Temp) = 1 Then
//			idsDOheader.setitem(llNewRow,'schedule_date',string(ldtCutoffDate, 'mm-dd-yyyy hh:mm'))
//		Else
//			If DayNumber(ldt_Temp) = 6 then //If Cutoff is missed on Friday then set to Monday
//				idsDOheader.setitem(llNewRow,'schedule_date',string(datetime(relativeDate(date(ldtCutoffDate),3),time(lsdefaultTime)), 'mm-dd-yyyy hh:mm')) /*relative based on Monday*/
//			ElseIf DayNumber(ldt_Temp) = 7 then //If Date is Saturday then set to Monday
//				idsDOheader.setitem(llNewRow,'schedule_date',string(datetime(relativeDate(date(ldtCutoffDate),2),time(lsdefaultTime)), 'mm-dd-yyyy hh:mm')) /*relative based on Monday*/
//			ElseIf DayNumber(ldt_Temp) = 1 then //If Date is Sunday then set to Monday
//				idsDOheader.setitem(llNewRow,'schedule_date',string(datetime(relativeDate(date(ldtCutoffDate),1),time(lsdefaultTime)), 'mm-dd-yyyy hh:mm')) /*relative based on Monday*/
//			Else	
//				idsDOheader.setitem(llNewRow,'schedule_date',string(datetime(relativeDate(date(ldtCutoffDate),1),time(lsdefaultTime)), 'mm-dd-yyyy hh:mm')) /*relative based on tomorrow*/
//			End If
//		End If


//TAM TOD this was part of multi stop functionality.  I think it can be removed
//		// CrossDoc Need to direct putaway to cross-dock location if order is a crossdock order
//					// dts 2010/08/12 - now seeding l_code with a cross-dock location if it's a cross-dock order
//					//TODO!  need to look up a cross-dock location (where l_type = '9') that has inventory in question?
//					// !! May just want to always use 'CROSSDOCK' as the location (per Ian, every warehouse will have a 'CROSSDOCK' location
//		if left(lsInvoice, 4) = 'CMOR' or left(lsInvoice, 4) = 'FMOR' or left(lsInvoice, 4) = 'CMTR' or left(lsInvoice, 4) = 'FMTR' then
//			lbCrossDock = True
//			idsDOheader.SetItem(llNewRow, 'Crossdock_ind', 'Y')
//			select min(l_code) into :lsCrossDock_Loc from location
//			where wh_code = :lsWH and l_type = '9';
//		end if
//		lsCrossDock_Loc = NoNull(lsCrossDock_loc )

		//TAM 2018/07/02 - Defect_S14838_Not able to pick from crossdock locations  - Yhis was missed in original Pint developement
		//21-NOV-2018 :Madhu DE7265 assign crossdock  location
		//8-MAY-2019 :Madhu S33258 - CrossDock Order Validation - START
		// 09/19 - PCONKL - Added CIMOR and FIMOR
		//  dts, 01/16/2021, S53004 - CrossDock now driven off of existence of Previous Leg Order (set below)
		// dts, 01/26/2021, S53004 (cont'd) - Making crossdock Stamping configurable (while waiting for SAP go-live)
		if ls_SAP_Enabled <>'Y' then
			IF left(lsInvoice, 4) = 'CMOR' and right(lsInvoice,2) = '.1'  THEN
				lbCrossDock = FALSE
			ElseIF left(lsInvoice, 5) = 'CIMOR' and right(lsInvoice,2) = '.1'  THEN 
				lbCrossDock = FALSE
			ElseIF left(lsInvoice, 5) = 'FIMOR' and right(lsInvoice,2) = '.1'  THEN 
				lbCrossDock = FALSE
			ELSEIF left(lsInvoice, 4) = 'CMOR' and right(lsInvoice,2) <> '.1' THEN
				lbCrossDock = TRUE
			ELSEIF left(lsInvoice, 5) = 'CIMOR' and right(lsInvoice,2) <> '.1' THEN
				lbCrossDock = TRUE
			ELSEIF left(lsInvoice, 5) = 'FIMOR' and right(lsInvoice,2) <> '.1' THEN
				lbCrossDock = TRUE
			ELSEIF left(lsInvoice, 4) = 'FMOR' or left(lsInvoice, 4) = 'CMTR' or left(lsInvoice, 4) = 'FMTR' THEN
				lbCrossDock = TRUE
			ELSE
				lbCrossDock = FALSE //14-MAR-2019 :Madhu DE9424 Reset flag
			END IF
			
			IF lbCrossDock THEN
				idsDOheader.SetItem(llNewRow, 'Crossdock_ind', 'Y')
	
				select min(l_code) into :lsCrossDock_Loc 
				from location with(nolock)
				where wh_code = :lsWH and l_type = '9';
			ELSE
				idsDOheader.SetItem(llNewRow, 'Crossdock_ind', 'N')
			END IF
			//8-MAY-2019 :Madhu S33258 - CrossDock Order Validation - END
							
			lsCrossDock_Loc = NoNull(lsCrossDock_loc )
			
			//20-MAR-2019 :Madhu write crossdock info to log
			lsLogOut =" OM Outbound - Change_Request_Nbr ="+string(ll_change_request_nbr)+", Order No# "+nz(lsInvoice,'-') +" CrossDock Ind: "+string(lbCrossDock) +" CrossDockLoc: "+nz(lsCrossDock_loc, '-')
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		End if //SAP not enabled.
		
		/* 940C - BEGIN
			If the files has an action type of 'D' for Cancel,  check to see if the order aready exist and is in New status.  
			If the order does not exist or is not in New staus, then Reject the Cancel in the OMC_Header
			We will still write the EDI records so the messaging is processed in u_nvo_process_files
			If during the processing below any error occurs then we will reject it there as well.
		*/
		If lsAction = 'D' then
			Select  Count(1) into :llCountInv
			From Delivery_master
			Where project_ID = :asproject and Invoice_No = :lsInvoice and Ord_Status = 'N' ;
			
			//GailM 2/19/2020 - DE14765 Before rejecting, check whether the INSERT is in this batch.  If it is, 
			lsFind = "EXTERNORDERKEY = '" + lsInvoice + "' and CHANGE_REQUEST_INDICATOR = 'INSERT'"
			llFound = idsOMCDelivery.Find(lsFind, 1, idsOMCDelivery.RowCount())
			
			If llCountInv = 0 And llFound = 0 Then //Order is not found.  Set the OMC record to 'REJECTED' otherwise set to 'Accepted'
				idsOMCDelivery.setitem( llRowPos, 'CHANGE_REQUEST_STATUS', 'REJECTED')
				idsOMCDelivery.setitem( llRowPos, 'editwho', 'SIMSUSER')
			else
				idsOMCDelivery.setitem( llRowPos, 'CHANGE_REQUEST_STATUS', 'ACCEPTED')
				idsOMCDelivery.setitem( llRowPos, 'editwho', 'SIMSUSER')
			END IF
			Continue
		End if //940C = END

		If lsAction = 'U' then
			Select  Count(1) into :llCountInv
			From Delivery_master
			Where project_ID = :asproject and Invoice_No = :lsInvoice and Ord_Status <> 'V';
			If llCountInv = 0 Then //No order found.  Change to 'A'
				lsAction = 'A'
				idsDOHeader.SetItem(llNewRow, 'Action_cd', lsAction)
			End if
		End if
			
		If lsAction = 'U' Then  //IF the Action is "U"pdate We need to issue a delete and then an Add for the entire order
			Select wh_Code into :lsWarehouse
			From Delivery_master
			Where project_ID = :asproject and Invoice_No = :lsInvoice;

			IF len(lsWarehouse) > 0 Then
			ELSE
				ls_error_msg = "OM Outbound - Change_Request_Nbr ="+string(ll_change_request_nbr)+", Order No# "+nz(lsInvoice,'-')+" - Invalid Warehouse: '" + lsWarehouse + "'. Order will not be processed."
				idsDOHeader.SetItem(llNewRow, 'Status_cd', 'E')
				idsDOHeader.SetItem(llNewRow, 'Status_Message', 'SITEID(Warehouse) should not be NULL')
				gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
				lbError = True
				Continue //Process Next Record
			END IF
			
			Select  ord_status,OTM_Status into :lsCurrentOrdStatus, :lsCurrentOTMStatus
			From Delivery_master
			Where project_ID = :asproject and Invoice_No = :lsInvoice and Ord_Status <> 'V';

			//TimA 08/10/12 Pandora issue #440
			//This order was in "New" status and "Ready" OTM Status we don't want to send an OTM delete which is handled in uf_process_delivery_order
			//Set the OTM status to 'Q'.  This is just a flag so that we can capture the results in uf_process_delivery_order
			If lsCurrentOrdStatus = 'N' and lsCurrentOTMStatus = 'R' then
				idsDOHeader.SetItem(llNewRow, 'OTM_Status', 'Q')
			End if

			idsDOheader.SetItem(llNewRow,'wh_Code',lsWarehouse)

			// 4/2010 - now setting ord_date to local wh time
			ldtWHTime = f_getLocalWorldTime(lsWarehouse)
			idsDOheader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))

			idsDOHeader.SetItem(llNewRow, 'Action_cd', 'D') /*Delete */
				
			lsAction = 'A'
				//Get the next available file sequence number
			llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
			If llBatchSeq <= 0 Then Return -1

			llOrderSeq = 0 /*order seq within file*/

			llNewRow = idsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			lbSoldToAddress = False

			//Record Defaults
			idsDOHeader.SetITem(llNewRow, 'project_id', asProject) /*Project ID*/
			idsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
			idsDOHeader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			idsDOHeader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
//			idsDOHeader.SetItem(llNewRow, 'ftp_file_name', aspath) /*FTP File Name*/
			idsDOHeader.SetItem(llNewRow, 'Status_cd', 'N')
			idsDOHeader.SetItem(llNewRow, 'order_Type', 'S') /*default to SALE. we'll set it to 'Z' later if appropriate */
			idsDOHeader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
			idsDOHeader.SetItem(llNewRow, 'Action_cd', 'A') /*Delete */
				
			//TimA 08/06/12 Pandora issue #440 the order is in "New" status on OTM "Ready" status
			If lsCurrentOrdStatus = 'N' and lsCurrentOTMStatus = 'R' then
				idsDOHeader.SetItem(llNewRow, 'OTM_Status', 'Q')				
			End if				
			idsDOHeader.SetItem(llNewRow, 'Invoice_no', lsInvoice)
			idsDOHeader.SetItem(llNewRow, 'Order_no', lsInvoice)
			idsDOheader.SetItem(llNewRow,'wh_Code',lsWarehouse) 
			// setting ord_date to local wh time
			idsDOheader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))

//--
			idsDOHeader.SetItem(llNewRow, 'wh_code', lsWh)
			// Customer Order Type *From First Detail Record
			//need to set order type to 'Z' (for warehouse transfer) if customer is of type WH
			
			idsDOheader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))
	
			idsDOHeader.SetItem(llNewRow, 'Invoice_no', lsInvoice)
			idsDOHeader.SetItem(llNewRow, 'Order_no', lsInvoice)
			idsDOHeader.SetItem(llNewRow, 'user_field2', lsOwnerCD) /* 04/09 - PCONKL - Moved outside of if statement to unconditionally set the From Location */
			if lsST_Group <> 'DECOM' then //should test postively for RMA, but not sure RMA is always the group
				if lsToProject = 'RTV-RMA' or lsToProject = 'RTV-PO' then  //RTV, RTC, OSV, MRB, DECOM, SCRAP, 
					idsDOHeader.SetItem(llNewRow, 'Order_Type', 'X') 
				end if
			end if
//--

//TAM TODO - ADD GAILS CODE
			//TAM 04/2017 - Pandora now wants to set the default schedule date from the lookup table.  This may change if they come up with a more detailed requirements	
				// Get default date
			ldtToday = ldtWHTime // Get local system date

//GailM 08/08/2017 SIMSPEVS-537 - Moved ldtScheduleDate code to end of header record code after all parameters have been identified

//			Select  Code_Descript INTO  :lsdefaultTime FROM lookup_table with (NoLock) 
//			Where Project_ID = 'PANDORA' AND Code_Type = 'ESDDEFAULT' and Code_Id = :lswarehouse  USING SQLCA;
//
//			If IsNull(lsdefaultTime) or lsdefaultTime = '' or Not isTime(lsdefaultTime) then lsdefaultTime ='14:00:00' //  - If not setup default to 2pm
//
//			ldtCutoffDate = datetime(relativeDate(date(ldtToday),0),time(lsdefaultTime)) // Get default date
//			ldt_Temp = RelativeDate(Date(ldtCutoffDate),0)
//	
//			If ldtToday < ldtCutoffDate and DayNumber(ldt_Temp) <> 7 and DayNumber(ldt_Temp) = 1 Then
//				idsDOheader.setitem(llNewRow,'schedule_date',string(ldtCutoffDate, 'mm-dd-yyyy hh:mm'))
//			Else
//				If DayNumber(ldt_Temp) = 6 then //If Cutoff is missed on Friday then set to Monday
//					idsDOheader.setitem(llNewRow,'schedule_date',string(datetime(relativeDate(date(ldtCutoffDate),3),time(lsdefaultTime)), 'mm-dd-yyyy hh:mm')) /*relative based on Monday*/
//				ElseIf DayNumber(ldt_Temp) = 7 then //If Cutoff is missed on Saturday then set to Monday
//					idsDOheader.setitem(llNewRow,'schedule_date',string(datetime(relativeDate(date(ldtCutoffDate),2),time(lsdefaultTime)), 'mm-dd-yyyy hh:mm')) /*relative based on Monday*/
//				ElseIf DayNumber(ldt_Temp) = 1 then //If Cutoff is missed on Sunday then set to Monday
//					idsDOheader.setitem(llNewRow,'schedule_date',string(datetime(relativeDate(date(ldtCutoffDate),1),time(lsdefaultTime)), 'mm-dd-yyyy hh:mm')) /*relative based on Monday*/
//				Else	
//					idsDOheader.setitem(llNewRow,'schedule_date',string(datetime(relativeDate(date(ldtCutoffDate),1),time(lsdefaultTime)), 'mm-dd-yyyy hh:mm')) /*relative based on tomorrow*/
//				End If
//			End If
										
		End If //lsAction = 'U' 		
		
		ls_om_type = idsOMCDelivery.getitemstring(llRowPos, 'TYPE')
		ls_susr4 = idsOMCDelivery.getitemstring(llRowPos, 'SUSR4')
		
		lsLogOut = "      - OM Outbound - processing uf_process_om_delivery - Change Request No: "+ string(ll_change_request_nbr) +" , Order No# "+nz(lsInvoice,'-')+" - TYPE: "+ nz(ls_om_type,'-') +" - SUSR4: "+nz(ls_susr4,'-')
		lsLogOut += " - SQLCA Code: " +string(sqlca.sqlcode) +" Batch Seq No: "+string(llBatchSeq)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)

		//Insert Record into OM_Expansion_Table
		INSERT INTO OM_Expansion_Table (Project_Id, Table_Name, Key_Value, Line_Item_No, Column_Name, Column_Value)
			values ( :asproject, 'Delivery_Master', :llBatchSeq, 0, 'TYPE', :ls_om_type )
		using SQLCA;

		If sqlca.sqlcode = 0 Then
			COMMIT;
		else
			lsErrText = sqlca.sqlerrtext
			ROLLBACK using SQLCA;
			//Write to Log File and Screen
			lsLogOut = "      - OM Outbound - Unable to Insert Record into OM_Expansion_Table .!~r~r SQL Error Code: " +string(sqlca.sqlcode) + ' Error: '+nz(lsErrText,'-')
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		End If

		INSERT INTO OM_Expansion_Table (Project_Id, Table_Name, Key_Value, Line_Item_No, Column_Name, Column_Value)
			values ( :asproject, 'Delivery_Master', :llBatchSeq, 0, 'RDD_Time_Zone', :ls_susr4 )
		using SQLCA;

		If sqlca.sqlcode = 0 Then
			COMMIT;
		else
			lsErrText = sqlca.sqlerrtext
			ROLLBACK using SQLCA;
			//Write to Log File and Screen
			lsLogOut = "      - OM Outbound - Unable to Insert Record into OM_Expansion_Table .!~r~r SQL Error Code: " +string(sqlca.sqlcode) + ' Error: '+nz(lsErrText,'-')
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		End If

//  Request Date
// TAM TODO - This is not Present in the Oracle Files - Is this Required? Will set to local warehouse time
		lsDate = string(idsOMCDelivery.getitemDateTime(llRowPos, 'DELIVERYDATE'), 'mm/dd/yyyy hh:mm') //changed from RequestedShipDate to DeliveryDate
		IF len(lsDate) > 0 Then
		Else
			lsDate = string(ldtWHTime, 'mm/dd/yyyy hh:mm')
		End If
		idsDOHeader.SetItem(llNewRow, 'Request_Date',lsDate)
			
		//GailM 11/15/2017 SIMSPEVS-537 - SIMS to provide advance ESD cutoff configuration use ldtRDD for Reqd Request Date RDD
		Date ldRDD
		Time ltRDD
		
		ltRDD =Time( Mid( lsDate, 9, 2) + ':' + Mid( lsDate, 11, 2 ))
		ldRDD = Date( lsDate )
		ldtRDD = Datetime( ldRDD, ltRDD )

//  Customer Code
		//TAM 10/27/2017 Changed per Dave
//		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'ConsigneeKey'))
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'CLIENT_SHIPTO_ID'))


		If IsNull(lsTemp) or Trim(lsTemp) = '' Then
//			idsDOHeader.SetItem(llNewRow, 'Cust_Code', 'GENERIC')
//			ls_error_msg = "Change_Request_Nbr ="+string(ll_change_request_nbr)+" -CONSIGNEEKEY(CustomerCode) shouldn't be NULL. Record will not be processed."
			ls_error_msg = "OM Outbound -Change_Request_Nbr ="+string(ll_change_request_nbr)+" , Order No# "+nz(lsInvoice,'-')+" -CLIENT_SHIPTO_ID(CustomerCode) shouldn't be NULL. Record will not be processed."
			idsDOheader.SetItem(llNewRow, 'Status_cd', 'E')
//			idsDOheader.SetItem(llNewRow, 'Status_Message', 'CONSIGNEEKEY(CustomerCode) should not be NULL')
			idsDOheader.SetItem(llNewRow, 'Status_Message', 'CLIENT_SHIPTO_ID(CustomerCode) should not be NULL')
			gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
			lbError = True
			Continue //Process Next Record
		Else	
			idsDOHeader.SetItem(llNewRow, 'Cust_Code', lsTemp)
		End If


		//set address for main (or only) outbound order
		//reset customer variables...
		lsCustName = ""; lsAddr1=""; lsAddr2=""; lsCity=""; lsState=""; lsZip=""; lsCountry=""; lsTel=""; lsCustType=""
		//grab customer information, if available....
		select Cust_name, Address_1, Address_2, City, State, Zip, Country, Tel, customer_type
		into :lsCustName, :lsAddr1, :lsAddr2, :lsCity, :lsState, :lsZip, :lsCountry, :lsTel, :lsCustType
		from customer
		where project_id = 'PANDORA'
		and cust_code = :lsTemp;
			
		idsDOHeader.SetItem(llNewRow,'Cust_Name', lsCustName)
		idsDOHeader.SetItem(llNewRow,'Address_1', lsAddr1)
		idsDOHeader.SetItem(llNewRow,'Address_2', lsAddr2)
		idsDOHeader.SetItem(llNewRow,'City', lsCity) 
		idsDOHeader.SetItem(llNewRow,'State', lsState) 
		idsDOHeader.SetItem(llNewRow,'Zip', lsZip) 
		idsDOHeader.SetItem(llNewRow,'Country', lsCountry) 
		idsDOHeader.SetItem(llNewRow,'tel', lsTel) 
			
//  Customer Name
		// Only populate if data came from Interface

//  Ship To Contact Person 
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'C_CONTACT1'))
//		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'C_Company'))
		If Len(trim(lsTemp)) > 0 Then
			idsDOHeader.SetItem(llNewRow, 'Cust_Name', Trim(lsTemp))
		End If

//  Customer_PO
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'Buyer_PO'))
		idsDOHeader.SetItem(llNewRow, 'client_cust_po_nbr', Trim(lsTemp))
		
		if lsCustType = 'WH' then 
			idsDOHeader.SetItem(llNewRow, 'order_Type', 'Z') /* warehouse Transfer*/
		end if

//  ShipTo_ADDR1
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'C_ADDRESS1'))
		// Only populate if data came from Interface
		If Len(lsTemp) > 0 Then
			idsDOHeader.SetItem(llNewRow, 'Address_1', Trim(lsTemp))
		End If

//  ShipTo_ADDR2
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'C_ADDRESS2'))
		// Only populate if data came from Interface
		If Len(lsTemp) > 0 Then
			idsDOHeader.SetItem(llNewRow, 'Address_2', Trim(lsTemp))
		End If

//  ShipTo_ADDR3
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'C_ADDRESS3'))
		// Only populate if data came from Interface
		If Len(lsTemp) > 0 Then
			idsDOHeader.SetItem(llNewRow, 'Address_3', Trim(lsTemp))
		End If

//  ShipTo_ADDR4
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'C_ADDRESS4'))
		// Only populate if data came from Interface
		If Len(lsTemp) > 0 Then
			idsDOHeader.SetItem(llNewRow, 'Address_4', Trim(lsTemp))
		End If

//  ShipTo_Postal_Code
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'C_ZIP'))
		// Only populate if data came from Interface
		If Len(lsTemp) > 0 Then
			idsDOHeader.SetItem(llNewRow, 'Zip', Trim(lsTemp))
		End If

///  ShipTo_City
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'C_CITY'))
		// Only populate if data came from Interface
		If Len(lsTemp) > 0 Then
			idsDOHeader.SetItem(llNewRow, 'City', Trim(lsTemp))
		End If

//  ShipTo_State
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'DELIVERYPLACE'))
		// Only populate if data came from Interface
		If Len(lsTemp) > 0 Then
			idsDOHeader.SetItem(llNewRow, 'State', Trim(lsTemp))
		End If

//  ShipTo_Country
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'C_COUNTRY'))
		// Only populate if data came from Interface
		If Len(lsTemp) > 0 Then
			idsDOHeader.SetItem(llNewRow, 'Country', Trim(lsTemp))
		End If

//  SoldTo_Number *Not Used
		// LTK 20120329 Now using Sold To Number to populate Delivery_Alt_Address.Tel
		lsSoldToPhone = Trim(idsOMCDelivery.GetItemString(llRowPos, 'B_PHONE1'))
			
//  SoldTo Name 
		lsSoldToName = Trim(idsOMCDelivery.GetItemString(llRowPos, 'B_Company'))
		if Len(lsSoldToName) > 0 Then lbSoldToAddress = True

//  SoldTo_ADDR1 
		lsSoldToAddr1 = Trim(idsOMCDelivery.GetItemString(llRowPos, 'B_ADDRESS1'))
		if Len(lsSoldToAddr1) > 0 Then lbSoldToAddress = True

//  SoldTo_ADDR2
		lsSoldToAddr2 = Trim(idsOMCDelivery.GetItemString(llRowPos, 'B_ADDRESS2'))
		if Len(lsSoldToAddr2) > 0 Then lbSoldToAddress = True

//  SoldTo_ADDR3
		lsSoldToAddr3 = Trim(idsOMCDelivery.GetItemString(llRowPos, 'B_ADDRESS3'))
		if Len(lsSoldToAddr3) > 0 Then lbSoldToAddress = True

//  SoldTo_ADDR4
		lsSoldToAddr4 = Trim(idsOMCDelivery.GetItemString(llRowPos, 'B_ADDRESS4'))
		if Len(lsSoldToAddr4) > 0 Then lbSoldToAddress = True

//  SoldTo_Postal_Code 
		lsSoldToZip = Trim(idsOMCDelivery.GetItemString(llRowPos, 'B_ZIP'))
		if Len(lsSoldToZip) > 0 Then lbSoldToAddress = True

//  SoldTo_City
		lsSoldToCity = Trim(idsOMCDelivery.GetItemString(llRowPos, 'B_CITY'))
		if Len(lsSoldToCity) > 0 Then lbSoldToAddress = True

//  SoldTo_State 
		lsSoldToState = Trim(idsOMCDelivery.GetItemString(llRowPos, 'B_STATE'))
		if Len(lsSoldToState) > 0 Then lbSoldToAddress = True

//  SoldTo_Country
		lsSoldToCountry = Trim(idsOMCDelivery.GetItemString(llRowPos, 'B_COUNTRY'))
		if Len(lsSoldToCountry) > 0 Then lbSoldToAddress = True

		If lbSoldToAddress Then
			llNewAddressRow = ldsDOAddress.InsertRow(0)
			ldsDOAddress.SetItem(llNewAddressRow,'project_id',asProject) /*Project ID*/
			ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
		
			ldsDOAddress.SetItem(llNewAddressRow,'address_type','ST') /* Address Type*/
			ldsDOAddress.SetItem(llNewAddressRow,'Name',lsSoldToname) /* Name */
			ldsDOAddress.SetItem(llNewAddressRow,'address_1',lsSoldToaddr1) 
			ldsDOAddress.SetItem(llNewAddressRow,'address_2',lsSoldToaddr2) 
			ldsDOAddress.SetItem(llNewAddressRow,'address_3',lsSoldToaddr3) 
			ldsDOAddress.SetItem(llNewAddressRow,'address_4',lsSoldToaddr4) 
			ldsDOAddress.SetItem(llNewAddressRow,'City',lsSoldTocity)
			ldsDOAddress.SetItem(llNewAddressRow,'State',lsSoldTostate)
			ldsDOAddress.SetItem(llNewAddressRow,'Zip',lsSoldTozip) 
			ldsDOAddress.SetItem(llNewAddressRow,'Country',lsSoldTocountry)
				
			ldsDOAddress.SetItem(llNewAddressRow,'Tel',lsSoldToPhone)	// LTK 20120329 added
			ldsDOAddress.SetItem(llNewAddressRow,'contact_person',lsSoldToname)	// LTK 20120329 added
				
			lbSoldToAddress = False
		End if

//  Freight Terms
		//TAM TODO - Do we need to get this from inco tems.  this was commented out	// LTK 20120329 Freight_terms now being populated with the new field incoterms in position DM043 			
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'INCOTERM'))
		idsDOHeader.SetItem(llNewRow, 'freight_terms', Trim(lsTemp))
						
//User_Field7 - Transaction Type (passed back to Pandora in Inventory Transaction Confirmation)
	//TAM - map a new set of codes to the existing literals
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'TYPE'))
		If lsTemp = 'TRANSFER' Then idsDOheader.SetItem(llNewRow, 'User_Field7', 'MATERIAL TRANSFER') 
		If lsTemp = 'DLVORDER' Then idsDOheader.SetItem(llNewRow, 'User_Field7', 'CUSTOMER SHIPMENT') 
			
//  User Field 8 From the Detail "PO_NO"
		// Owner Code, Owner_Id  * Get from the first detail
		if ll_delivery_detail_count > 0 Then
			lsTemp = Trim(idsOMCDeliveryDetail.GetItemString(1, 'SUSR1'))
		else
			lsTemp =''
		end if
		idsDOheader.SetItem(llNewRow, 'User_Field8', Trim(lsTemp))

//  User Field 11
		//ll_found = idsOMCDeliveryAttr.Find("CHANGE_REQUEST_NBR = " + string(ll_change_request_nbr) + ', Order No# '+nz(lsInvoice,'-')+' and UPPER(ATTR_TYPE) = "SHIPFROMCONTACT" ' , 1, ll_delivery_attr_count)
		ll_found = idsOMCDeliveryAttr.Find("CHANGE_REQUEST_NBR = " + string(ll_change_request_nbr) + " and UPPER(ATTR_TYPE) = 'SHIPFROMCONTACT' " , 1, ll_delivery_attr_count)
		
		if ll_found > 0 then
			lsTemp = Trim(idsOMCDeliveryAttr.GetItemString(ll_found, 'REFCHAR1'))
			idsDOheader.SetItem(llNewRow, 'User_Field11', Trim(lsTemp)) 
		end if

//  User Field 10 - CostCenter
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'DEPARTMENT'))
		idsDOHeader.SetItem(llNewRow, 'user_field10', Trim(lsTemp))

//  dts, 01/26/2021, S53004 (cont'd) - Making Prev/Next leg and crossdock Stamping configurable (while waiting for SAP go-live)
		if ls_SAP_Enabled = 'Y' then
	//  dts, 01/15/2021, S53004 - grab Previous Leg if present (for multi-leg orders)
	//  User Field 16
			ll_found = idsOMCDeliveryAttr.Find("CHANGE_REQUEST_NBR = " + string(ll_change_request_nbr) + " and UPPER(ATTR_TYPE) = 'MULTILEG_PREVORDER' " , 1, ll_delivery_attr_count)
			
			if ll_found > 0 then
				lsTemp = Trim(idsOMCDeliveryAttr.GetItemString(ll_found, 'REFCHAR1'))
				idsDOheader.SetItem(llNewRow, 'User_Field16', Trim(lsTemp)) 
	
				lbCrossdock = true
				idsDOheader.SetItem(llNewRow, 'Crossdock_ind', 'Y')
	
				select min(l_code) into :lsCrossDock_Loc 
				from location with(nolock)
				where wh_code = :lsWH and l_type = '9';
			else
				lbCrossdock = false
				idsDOheader.SetItem(llNewRow, 'Crossdock_ind', 'N')
			END IF
	
			lsCrossDock_Loc = NoNull(lsCrossDock_loc )
			
			//20-MAR-2019 :Madhu write crossdock info to log
			lsLogOut =" OM Outbound - Change_Request_Nbr ="+string(ll_change_request_nbr)+", Order No# "+nz(lsInvoice,'-') +" CrossDock Ind: "+string(lbCrossDock) +" CrossDockLoc: "+nz(lsCrossDock_loc, '-')
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

		//  dts, 01/15/2021, S53004 - grab Next Leg if present (for multi-leg orders)
		//  User Field 18 
			ll_found = idsOMCDeliveryAttr.Find("CHANGE_REQUEST_NBR = " + string(ll_change_request_nbr) + " and UPPER(ATTR_TYPE) = 'MULTILEG_NEXTORDER' " , 1, ll_delivery_attr_count)
			
			if ll_found > 0 then
				lsTemp = Trim(idsOMCDeliveryAttr.GetItemString(ll_found, 'REFCHAR1'))
				idsDOheader.SetItem(llNewRow, 'User_Field18', Trim(lsTemp)) 
			end if
		end if //SAP Enabled

//  Shipping Instructions
// TAM TODO - may change - ask Pandor where they're coming from
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'NOTES'))
		idsDOHeader.SetItem(llNewRow, 'shipping_instructions_text', Trim(lsTemp))

//  Remarks
// TAM TODO - Is something changed???//TAM 2009/08/25  - Moved Remarks to userfield 1 (They contain Service Levels)
// GailM - Defect to SIMSPEVS-537 - Advance ESD Configuration - lsRemark should come from transportationservice field 
		lsRemark = Trim(idsOMCDelivery.GetItemString(llRowPos, 'transportationservice'))
		idsDOHeader.SetItem(llNewRow, 'remark', Trim(lsRemark))

		//GailM 11/15/2017 SIMSPEVS-537 - SIMS to provide advance ESD cutoff configuration via GUI
		Select Top 1 address_1 Into :lsCarrierAddr1
		From carrier_master
		Where project_id = 'PANDORA'
		and address_1 in ( 'VENDOR PAID SHIPMENT', 'FEDEX','UPS','EXPEDITORS','SHUTTLE','DHL' )		//Added Shuttle and DHL for future
		and ( inactive is null or inactive = 0 )
		And user_field1 = :lsRemark;
		
		If lsCarrierAddr1 = '' Then lsCarrierAddr1 = '*all'

		// TAM TODO - Is something changed???//TAM 2009/08/25  - Moved Remarks to userfield 1 (They contain Service Levels)
		// LTK 20120613  Pandora #442  If the order number prefix is in list (currently:  CMOR, CMTR, FMOR, FMTR) then set DM.UF1 = PIU (stored in the lookup table in case of changes).
		String ls_order_prefix, ls_service_from_lookup, ls_original_remark
		ls_original_remark = lsRemark
			
		ls_order_prefix = idsDOHeader.GetItemString(llNewRow, 'Invoice_no')
		if Len(ls_order_prefix) >= 4 then
			ls_order_prefix = Upper(Trim(Left(ls_order_prefix,4)))
				
			select code_descript
			into :ls_service_from_lookup
			from lookup_table
			where project_id = 'PANDORA'
			and code_type = '3B18'
			and code_id = :ls_order_prefix;
				
			if Len(ls_service_from_lookup) > 0 then
				lsRemark = ls_service_from_lookup
			end if
		end if
		// End Pandora #442

		idsDOHeader.SetItem(llNewRow, 'user_field1', Trim(lsRemark))
			
		// LTK 20120525  Pandora #423 Set carrier if the service level is in the list (currently: NOS, DOS and PIU).
		String ls_carrier, ls_service_level
		ls_service_level = Upper(Trim(lsRemark))
			
		ls_carrier = '' /* 11/20 - PCONKL - DE13353*/
		
		select code_descript
		into :ls_carrier
		from lookup_table
		where project_id = 'PANDORA'
		and code_type = 'CCODE'
		and code_id = :ls_service_level;
			
		if Len(ls_carrier) > 0 then
			idsDOHeader.SetItem(llNewRow,'Carrier', ls_carrier)	

			// Also set transport_mode
			String ls_transport_mode

			select transport_mode
			into :ls_transport_mode
			from carrier_master
			where project_id = 'PANDORA'
			and carrier_code = :ls_carrier;
				
			if Len(ls_transport_mode) > 0 then
				idsDOHeader.SetItem(llNewRow,'transport_mode', ls_transport_mode)
			end if
		end if
		// End of Pandora #423

		// LTK 20110722  	Pandora #266  Store carrier service level code description, as opposed to the code.
		//						The carrier service level code comes in the remarks field.  Look up the description 
		//						and store it in delivery_master.agent_info.
		if Len(lsRemark) > 0 then
				
			String ls_code_desc
			
			ls_code_desc = ''  /* 11/20 - PCONKL - DE13353*/
				
			select code_descript
			into :ls_code_desc
			from lookup_table
			where project_id = 'PANDORA'
			and code_type = 'SL'
			and code_ID = :lsRemark;
				
			ls_code_desc = Left(Trim(ls_code_desc),30)	// DM.agent_info is length 30, lookup_table.code_descript is length 40
			if Len(ls_code_desc) > 0 then
				idsDOHeader.SetItem(llNewRow, 'agent_info', ls_code_desc)
			end if
		end if
		// Pandora #266 end.
// End TODO - Is something changed???//TAM 2009/08/25  - Moved Remarks to userfield 1 (They contain Service Levels)


//  Customer_sent_date - 
		lsDate = string(idsOMCDelivery.getitemDateTime(llRowPos, 'SOURCEFILEDATE'), 'mm/dd/yyyy hh:mm')
		IF len(lsDate) > 0 Then
		Else
			lsDate = string(ldtWHTime, 'mm/dd/yyyy hh:mm')
		End If
		idsDOHeader.SetItem(llNewRow, 'customer_sent_date', lsDate) 

//  Ship To Contact Person 
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'C_CONTACT1'))
		idsDOHeader.SetItem(llNewRow, 'contact_person', lstemp) 

//  Ship To Telephone
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'C_PHONE1'))
		idsDOHeader.SetItem(llNewRow, 'tel', lstemp) 

//Pandora issu #348 GUTS-NUM
		if ll_delivery_detail_count > 0 Then
			lsTemp = Trim(idsOMCDeliveryDetail.GetItemString(1, 'REFCHAR6'))
		else
			lsTemp =''
		end if
		idsDOHeader.SetItem(llNewRow, 'user_field5', Trim(lsTemp)) 

			// LTK 20120329 Commented out code below and rearranged so that the fields are always stipped off.  
			// This way fields added to the end of the record can be processed, regardless of the OTM flag.

// OTM Project Fixed RDD Flag  
//Not Used at this time
// 12/19 - PCONKL -F19814/S40650 -  We will pull the flag from OTM if present

		If gs_OTM_Flag = 'Y' then 
			
			//TimA 09/12/12 Pandora issue 473.  On all MTR and CMTR order default User_Field14 to FIRM for Firm/Flex OTM
			//dts 2012-09-14 - 473 cont'd: Word is now that only 'MTR' triggers this.
			//TimA 10/26/12 Pandora issue #529.  Change the current process to looking up the vaules in a table
			
			//Check the Order attribute record for Flex/Firm flag
			lsTemp = ''
			//ll_found = idsOMCDeliveryAttr.Find("CHANGE_REQUEST_NBR = " + string(ll_change_request_nbr) + ', Order No# '+nz(lsInvoice,'-')+' and UPPER(ATTR_TYPE) = "OTM_FIXED_DLVRY_FLAG" ' , 1, ll_delivery_attr_count)
			ll_found = idsOMCDeliveryAttr.Find("CHANGE_REQUEST_NBR = " + string(ll_change_request_nbr)  + " and UPPER(ATTR_TYPE) = 'OTM_FIXED_DLVRY_FLAG' " , 1, ll_delivery_attr_count)
			if ll_found > 0 then
				lsTemp = Trim(idsOMCDeliveryAttr.GetItemString(ll_found, 'REFCHAR1'))
				idsDOheader.SetItem(llNewRow, 'User_Field14', Trim(lsTemp)) 
			end if
			
			String  ls_CodeDesc, lsCodeID
			lsCodeID = left(lsInvoice,4 )
				
			ls_CodeDesc = '' /* 11/20 - PCONKL */
			
			//If flag not found in OM, check for an order prefix based default
			If lsTemp = '' Then
				
				select code_descript
				into :ls_CodeDesc
				from lookup_table
				where project_id = 'PANDORA'
				and code_type = 'FIRM'
				and code_ID = :lsCodeID;
				
				ls_CodeDesc = Trim(ls_CodeDesc)
				if ls_CodeDesc = 'Y'  then
					idsDOHeader.SetItem(llNewRow, 'user_field14', 'FIRM' ) 					
//				else
//					idsDOHeader.SetItem(llNewRow, 'user_field14', Trim(lsTemp)) 
				end if
				
			End If /* no flag found in OM */
			
		End if /*OTM*/
		
// End TODO - OTM Project Fixed RDD Flag not Mapped at this time

// OTM Project Rate Trans ID
// OTM Project Rate Trans ID not Mapped at this time

		lsTemp = ''
		If gs_OTM_Flag = 'Y' Then 
			idsDOHeader.SetItem(llNewRow, 'user_field15', Trim(lsTemp)) 
		End if
		
		//TAM 2019/03/31 - S25773 -DE9566 - For TMS enabled warehouses we Need to set OMS status to either Pending TMS('L') or Non TMS('Z'')		
		lsTmsFlag = 'N'
		lsTmsWHFlag = ''

		select code_descript	into :lsTmsFlag from lookup_table	where project_id = 'PANDORA' and code_type = 'FLAG' and code_id = 'TMS';
		select code_descript	into :lsTmsWHFlag from lookup_table	where project_id = 'PANDORA' and code_type = 'SKIP_TMS' and code_id = :lsWh; //Return blank means this warehouse is participating in TMS

//		lsLogOut = "TEST MESSAGE Before Loop      - OM Outbound - lsTmsFlag " + lsTmsflag + " lsTmsWHFlag " + lsTmsWHFlag + " lsRemark " + lsRemark + " lswh " + lswh
//		FileWrite(giLogFileNo,lsLogOut)
//		gu_nvo_process_files.uf_write_log(lsLogOut)

		// 10/19 - PCONKL - F19222/S39332 - Include 'GND' for non-TMS
		
		if lsTmsFlag = "Y" and lsTmsWHFlag = '' Then
			if lsRemark <> 'DOS' and lsRemark <> 'NOS' and lsRemark <> 'PIU' and lsRemark <> 'GND' Then
				idsDOHeader.SetItem(llNewRow, 'OTM_STATUS', 'L') 

//				lsLogOut = "TEST MESSAGE in Loop      - OM Outbound - lsTmsFlag " + lsTmsflag + " lsTmsWHFlag " + lsTmsWHFlag + " lsRemark " + lsRemark + " lswh " + lswh
//				FileWrite(giLogFileNo,lsLogOut)
//				gu_nvo_process_files.uf_write_log(lsLogOut)

			Else

//				lsLogOut = "TEST MESSAGE in Loop      - OM Outbound - lsTmsFlag " + lsTmsflag + " lsTmsWHFlag " + lsTmsWHFlag + " lsRemark " + lsRemark + " lswh " + lswh
//				FileWrite(giLogFileNo,lsLogOut)
//				gu_nvo_process_files.uf_write_log(lsLogOut)
//
				idsDOHeader.SetItem(llNewRow, 'OTM_STATUS', 'Z') 
			End If
		End If

		string tempsts
		tempsts 	= idsDOHeader.GetItemString(llNewRow, 'OTM_STATUS') 
			
//		lsLogOut = "TEST MESSAGE after Loop      - OM Outbound - lsTmsFlag " + lsTmsflag + " lsTmsWHFlag " + lsTmsWHFlag + " lsRemark " + lsRemark + " lswh " + lswh + " OTM STATUS " + tempsts
//		FileWrite(giLogFileNo,lsLogOut)
//		gu_nvo_process_files.uf_write_log(lsLogOut)

// TAM TODO - INCO TERMS - Ask Pandora
		//lsTemp = ''
		//idsDOHeader.SetItem(llNewRow, 'freight_terms', Left(Trim(lsTemp),20))

// Client Cust PO Nbr (AKA - Vendor Order Nbr) - Ask Pandora
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'SUSR3'))
		idsDOHeader.SetItem(llNewRow, 'client_cust_po_nbr', Trim(lsTemp))

		//GailM 08/08/2017 SIMSPEVS-537 - SIMS to provide advance ESD cutoff configuration via GUI  Cut_Off_Time				If Left(lsMIMOrder,1) = 'X' Then lsMIMOrder = 'Yes'
		If Left( lsTemp, 1 ) = 'X' Then lsMIMOrder = 'Yes'
		
		ldtScheduleDate = f_delivery_advance_esd_configuration(lsWH,ldtWHTime, ldtRDD, lsMIMOrder, lsCarrierAddr1, lsSTCust )				
		
		lsMessage = 'Set OM ESD to ' + string( ldtScheduleDate ) + ' with Carrier: ' + lsCarrierAddr1 + ', MIM Order: ' + lsMIMOrder + ', CustCode: ' + lsSTCust + ', WH Time: ' + string( ldtWHTime ) + ', RDD: ' + string( ldtRDD ) 
		f_method_trace_special( asproject, this.ClassName() + ' - uf_process_om_delivery',lsMessage, lsWH, ' ',' ',lsInvoice)

		idsDOHeader.SetItem(llNewRow,'schedule_date',string(ldtScheduleDate, 'mm-dd-yyyy hh:mm'))

		//GailM 2/19/2020 - DE14765 On insert, check for CANCEL in this batch.  If found code INSERT as "E" with message
		If lsAction = 'A' Then
			lsFind = "EXTERNORDERKEY = '" + lsInvoice + "' and CHANGE_REQUEST_INDICATOR = 'CANCEL' "
			llFound = idsOMCDelivery.Find(lsFind, 1, idsOMCDelivery.RowCount())
			If llFound > 0 Then
				ls_error_msg = 'CANCEL request found in this batch for INSERT order'
				idsDOheader.SetItem(llNewRow, 'Status_cd', 'E')
				idsDOheader.SetItem(llNewRow, 'Status_Message', ls_error_msg)
				gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
				continue /*Next Record*/
			End If
		End If
	
//TODO - Process notes - Needs testing
// Notes Table - Load up in Batches of 255 Chars,
		lsTemp = Trim(idsOMCDelivery.GetItemString(llRowPos, 'NOTES2'))
			// L - Remove any carriage returns/Line feeds from Notes 
		if isNull(lsTemp) then lsTemp = ''
			
		Do While pos(lsTemp,"~t") > 0 /*tab*/
			lsTemp = Replace(lsTemp, pos(lsTemp,"~t"),1," ")
		Loop
			
		Do While pos(lsTemp,"~n") > 0 /*New line*/
			lsTemp = Replace(lsTemp, pos(lsTemp,"~n"),1," ")
		Loop
			
		Do While pos(lsTemp,"~r") > 0 /*CR*/
			lsTemp = Replace(lsTemp, pos(lsTemp,"~r"),1," ")
		Loop

		//  dts, 01/16/2021, S53004 - For DA KITTING ORDERs (formerly MORSCKIT* Order#), now identifying by 'ORDER TYPE: KIT' in the Notes.
		//  - May want to stamp a field here (currently using logic in w_main.retrieveend based on 'MORSCKIT' order prefix
		//if pos(lsTemp,"ORDER TYPE: KIT") > 0 then
			//DA KITTING ORDER
		//end if

		Do While lsTemp > ''
			llNewNotesRow = ldsDONotes.InsertRow(0)
			ldsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
			ldsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',llNewNotesRow) 
			ldsDONotes.SetItem(llNewNotesRow,'invoice_no',lsInvoice)
			ldsDONotes.SetItem(llNewNotesRow,'note_type','DR')
			ldsDONotes.SetItem(llNewNotesRow,'line_item_no',0)
			ldsDONotes.SetItem(llNewNotesRow,'note_Text',Left(lsTemp,255))
			lsTemp = Right(lsTemp,len(lsTemp)-254)
		LOOP
	
	// ***** LOAD DETAIL RECORDS *****
		ll_detail_error_count =0 //re-set detail error count value
		ls_error_msg ='' //re-set error msg value

		FOR ll_Row_Pos_Detail =1 to ll_delivery_detail_count	
		
			lbDetailError = False
			llNewDetailRow = 	idsDODetail.InsertRow(0)
			llLineSeq ++

			//Add detail level defaults
			idsDODetail.SetITem(llNewDetailRow, 'supp_code', 'PANDORA') /* 2/14/09 */
			idsDODetail.SetItem(llNewDetailRow, 'project_id', asproject) /*project*/
			idsDODetail.SetItem(llNewDetailRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			idsDODetail.SetItem(llNewDetailRow, 'order_seq_no', llOrderSeq) 
			idsDODetail.SetItem(llNewDetailRow, "order_line_no", string(llLineSeq)) /*next line seq within order*/
			idsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'N')
			// 09/09 - per Ian, don't want to default Inv Type....
			//idsDODetail.SetItem(llNewDetailRow, 'Inventory_type', 'N') /*normal inventory*/

		//Invoice No
			idsDODetail.SetItem(llNewDetailRow, 'Invoice_no', lsInvoice) 
// TAM TODO Invoice Error Handling

		//  Line_Number
			//Material Transfer Line Number
			lsTemp = Trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'EXTERNLINENO'))
			If IsNull(lsTemp) or lsTemp = '' Then //Error
				ls_error_msg +="OM Outbound - Row: " + string(llNewDetailRow) + " - EXTERNLINENO(Line Item Number) should not be NULL. Record will not be processed. ~n~r"
				idsDOheader.SetItem(llNewRow, 'Status_cd', 'E')
				idsDOheader.SetItem(llNewRow, 'Status_Message', 'Errors exist on Header/Detail')
				idsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'E')
				idsDODetail.SetItem(llNewDetailRow, 'Status_Message', 'EXTERNLINENO(Line Item Number) should not be NULL. Record will not be processed.')
				lbDetailError = True
			Else	
				idsDODetail.SetItem(llNewDetailRow, 'line_item_no', dec(lsTemp)) 
			End If	

		//  SKU, ALT SKU
			lsTemp = Trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'ITEM'))
			If IsNull(lsTemp) or lsTemp = '' Then //Error
				ls_error_msg +="OM Outbound - Row: " + string(llNewDetailRow) + " -ITEM(SKU) should not be NULL. Record will not be processed. ~n~r"
				idsDOheader.SetItem(llNewRow, 'Status_cd', 'E')
				idsDOheader.SetItem(llNewRow, 'Status_Message', 'Errors exist on Header/Detail')
				idsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'E')
				idsDODetail.SetItem(llNewDetailRow, 'Status_Message', 'ITEM(SKU) should not be NULL. Record will not be processed.')
				lbDetailError = True
			Else
				idsDODetail.SetItem(llNewDetailRow, 'sku', lsTemp) 
				//TAM 11/20/2009  - Get ALT_SKU from the Item_master and save if it exists.
				select alternate_sku into :lsAltSku
				from item_master
				where project_id = 'PANDORA'
				and sku = :lsTemp;
				// - If Alt Sku is found then populate
				if not isnull(lsAltSku) and lsAltSku <> '' then
						idsDODetail.SetItem(llNewDetailRow, 'Alternate_Sku', lsAltSku) 
				end if
			End If	

		//  Quantity
			lsTemp = String(idsOMCDeliveryDetail.GetItemNumber(ll_Row_Pos_Detail, 'ORDEREDSKUQTY'))
			If IsNull(lsTemp) or lsTemp = '' Then //Error
				ls_error_msg +="OM Outbound - Row: " + string(llNewDetailRow) + " -ORDEREDSKUQTY(QTY) should not be NULL. Record will not be processed. ~n~r"
				idsDOheader.SetItem(llNewRow, 'Status_cd', 'E')
				idsDOheader.SetItem(llNewRow, 'Status_Message', 'Errors exist on Header/Detail')
				idsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'E')
				idsDODetail.SetItem(llNewDetailRow, 'Status_Message', 'ORDEREDSKUQTY(QTY) should not be NULL. Record will not be processed.')
				lbDetailError = True
			ELSE
				idsDODetail.SetItem(llNewDetailRow, 'quantity', lsTemp) 
			End If

		//  Unit_of_Measure
			lsTemp = Trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'UOM'))
			idsDODetail.SetItem(llNewDetailRow, 'UOM', Trim(lsTemp))

		//  PO Number 1 (Project)
			lsTemp = Trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'LOTTABLE03'))
			If IsNull(lsTemp) or lsTemp = '' Then //Error
				ls_error_msg +="OM Outbound - Row: " + string(llNewDetailRow) + " -LOTTABLE03(Project) should not be NULL. Record will not be processed. ~n~r"
				idsDOheader.SetItem(llNewRow, 'Status_cd', 'E')
				idsDOheader.SetItem(llNewRow, 'Status_Message', 'Errors exist on Header/Detail')
				idsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'E')
				idsDODetail.SetItem(llNewDetailRow, 'Status_Message', 'LOTTABLE03(Project) should not be NULL. Record will not be processed.')
				lbDetailError = True
			ELSE
// TAM TODO DMA has Lottable 3 as "PO Number" and SUSR 1 as "User_Field5" In SO ROSE "UF5" is the PONO on the detail record(setting it here
				idsDODetail.SetItem(llNewDetailRow, 'po_no', lsTemp) 
				idsDODetail.SetItem(llNewDetailRow, 'user_field5', lsTemp) 
			End If	

		//  Owner ID
			if lsOwnerCD <> lsOwnerCD_Prev then
// TAM TODO Error Handling
				lsOwnerID = ''
				select owner_id into :lsOwnerID
				from owner
				where project_id = :asProject and owner_cd = :lsOwnerCD;
				lsOwnerCD_Prev = lsOwnerCD
			end if
			idsDODetail.SetItem(llNewDetailRow, 'owner_id', lsOwnerID)
			
			//21-NOV-2018 :Madhu DE7265 assign crossdock location
			IF lbCrossDock = True and lsCrossDock_Loc > '' then
				idsDODetail.SetItem(llNewDetailRow, 'l_code', lsCrossDock_Loc)
			END IF
	
//  User Field 1
	//Mfg Part NO
			lsTemp = Trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'RETAILSKU'))
			idsDODetail.SetItem(llNewDetailRow, 'User_Field1', Trim(lsTemp))

//  Price
			lsTemp = String(idsOMCDeliveryDetail.GetItemNumber(ll_Row_Pos_Detail, 'UNITPRICE'))
			idsDODetail.SetItem(llNewDetailRow, 'Price', Trim(lsTemp))

//  Currency Code
			lsTemp = Trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'SUSR2'))
			idsDODetail.SetItem(llNewDetailRow, 'Currency_Code', Trim(lsTemp))

//  Serial Number
			lsTemp = Trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'SUSR3'))
			idsDODetail.SetItem(llNewDetailRow, 'User_Field3', Trim(lsTemp))

//  To Project 
			lsTemp = Trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'SUSR1'))
			idsDODetail.SetItem(llNewDetailRow, 'User_Field5', Trim(lsTemp))

//  Container ID
			lsTemp = Trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'LOTTABLE06'))
			idsDODetail.SetItem(llNewDetailRow, 'user_field7', Trim(lsTemp)) 
			idsDODetail.SetItem(llNewDetailRow, 'Container_Id', Trim(lsTemp)) 
			
			IF lbDetailError Then ll_detail_error_count++

		Next /*Detail record */

		IF ll_detail_error_count > 0 Then 	
			gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
		END IF

	Next //Header Record

ELSE
	Return 0
END IF


//TimA 05/25/12 Pandora issue #425
//Varables are called in new function uf_sendemailnotification
is_WhCode = lswh
is_Invoice = lsInvoice

//Save Changes

// 940C - BEGIN
//Execute Immediate "Begin Transaction" using OM_SQLCA; 4/2020 - MikeA - DE15499

liRC =idsOMCDelivery.update( false, false);
	
If liRC <> 1 Then
	//Execute Immediate "ROLLBACK" using om_sqlca; 4/2020 - MikeA - DE15499
	rollback using om_sqlca;
	idsOMCDelivery.reset( )
	//Write to Log File and Screen
	lsLogOut = "      - OM Outbound - Unable to Save new SO Records to database .!~r~r" + om_sqlca.SQLErrText
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End if 
//940C = END

liRC = idsDOHeader.Update()
If liRC = 1 Then
	liRC = idsDODetail.Update()
End If
If liRC = 1 Then
	liRC = ldsDOAddress.Update()
End If
If liRC = 1 Then
	liRC = ldsDONotes.Update()
End If
If liRC = 1 Then
	Commit;
//	Execute Immediate "COMMIT" using om_sqlca; 4/2020 - MikeA - DE15499
	commit using om_sqlca;
Else
	Rollback;
	//Execute Immediate "ROLLBACK" using om_sqlca; 4/2020 - MikeA - DE15499
	rollback using om_sqlca;
	lsLogOut =  "       ***System Error!  Unable to Save new SO Records to database "
	FileWrite(gilogFileNo, lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If


destroy idsOMCDelivery
destroy idsOMCDeliveryDetail
destroy idsOMADeliveryQueue

//Write to Log File and Screen
lsLogOut ="*** OM Inbound - End - Processing of uf_process_om_delivery() "
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

// Reset main window microhelp message
w_main.SetMicroHelp("Ready")

Return 0 //21-MAR-2018 :Madhu DE3461 - Removed "Return -1"
end function

public function integer uf_process_om_warehouse_order (readonly datastore adsorderlist);//JULY-2017 :TAM - Added for PINT-861 - 940c  Confirmation.
//Write records back into OMQ Warehouse OrderTables.

String		lsFind,  lsLogOut, lsOwnerCD, lsGroup,  lsWH, lsTransYN,lsDoNo
String   	lsToProject, lsTransType, lsRemarks, lsFromProject, lsDetailFind, ls_line_no
string		lsInvoice, lsRONO, lsPndSer, lsSku, lsPrevSku, ls_client_id, lsSkipProcess
String 	ls_oracle_integrated, lsClientCustPONbr, lsToLoc, ls_awb_bol, lsSkipProcess2
String		ls_OM_Type, ls_OM_RecType, ls_status_cd

Decimal	 ldTransID, ldOMQ_Inv_Tran
DateTime ldtTemp, ldtToday
Long		llRowPos, llRowCount, llFindRow,	llNewRow, llNewDetailRow, ll_row,  ll_detail_row
Long 		ll_change_req_no, ll_serial_row, ll_rc, ll_batch_seq_no, ll_Inv_Row, llOwnerID, llOwnerID_Prev
Boolean 	lbParmFound, lbAddHeader

DataStore ldsDOAddress

ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - OM 940 Confirmation- Start Processing of uf_process_om_warehouse_order: ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
select OM_Client_Id into :ls_client_id
from Project with(nolock)
where Project_Id= 'PANDORA'
using sqlca;

If Not isvalid(idsDOheader) Then
	idsDOheader = Create Datastore
	idsDOheader.Dataobject = 'd_do_master'
	idsDOheader.SetTransObject(SQLCA)
End If

If Not isvalid(idsDOdetail) Then
	idsDOdetail = Create Datastore
	idsDOdetail.Dataobject = 'd_do_Detail'
	idsDOdetail.SetTransObject(SQLCA)
End If

If Not isvalid(ldsDOAddress) Then
	ldsDOAddress = Create u_ds_datastore
	ldsDOAddress.dataobject = 'd_do_address' //Delivery_Alt_Address
	ldsDOAddress.SetTransObject(SQLCA)
End If

If Not isvalid(idsOMQDelivery) Then
	idsOMQDelivery =Create u_ds_datastore
	idsOMQDelivery.Dataobject ='d_omq_warehouse_order'
	idsOMQDelivery.settransobject(om_sqlca)
End If

If Not isvalid(idsOMQDeliveryDetail) Then
	idsOMQDeliveryDetail =Create u_ds_datastore
	idsOMQDeliveryDetail.Dataobject ='d_omq_warehouse_order_detail'
	idsOMQDeliveryDetail.settransobject(om_sqlca)
End If


If Not isvalid(idsOMExp) Then
	idsOMExp =Create u_ds_datastore
	idsOMExp.Dataobject ='d_om_expansion'
	idsOMExp.settransobject(SQLCA)
End If	

idsOMQDelivery.reset()
idsOMQDeliveryDetail.reset()
idsOMExp.reset()

// ***** LOAD HEADER RECORDS *****
//Loop through Ref datastore to update OM tables.
For ll_row = 1 to adsorderlist.rowcount()
	ll_change_req_no = adsorderlist.getitemnumber(ll_row, 'change_req_no')
	ls_status_cd =adsorderlist.getitemstring(ll_row, 'status_cd')

	
	//Get DONO
	SELECT DO_No	INTO :lsDoNo
	FROM Delivery_Master with(nolock)
	WHERE Project_Id = 'PANDORA'  and OM_CHANGE_REQUEST_NBR = :ll_change_req_no  ;
//	lsDoNo =adsorderlist.getitemstring(ll_row, 'system_order_no')

	//Retrieve the Receive Header, Detail and Putaway records for this order
	If idsDOheader.Retrieve(lsDoNo) <> 1 Then
		lsLogOut = "                  *** Unable to retrieve Delivery Order Header For DONO: " + lsDoNo
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	lsWH = idsDOheader.GetItemString(1, 'wh_code')
	ll_batch_seq_no =idsDOheader.getitemnumber(1,'EDI_Batch_Seq_No')
	lsInvoice = idsDOheader.GetItemString(1, 'Invoice_no')

	 //Retrieve OM_Expansion_Table records
 	idsOMExp.retrieve(ll_batch_seq_no)

	//Get values of TYPE   
	lsFind ="Column_Name ='TYPE'"
	llFindRow =idsOMExp.find(lsFind,1,idsOMExp.rowcount())
	ls_OM_Type =idsOMExp.getitemstring(llFindRow,'Column_value')


	//1. ADD OMQ_DELIVERY Tables
	llNewRow =	idsOMQDelivery.insertrow( 0)
		
	idsOMQDelivery.setitem(llNewRow,'CHANGE_REQUEST_NBR',ll_change_req_no)
	idsOMQDelivery.setitem(llNewRow,'CLIENT_ID',ls_client_id)
	idsOMQDelivery.setitem(llNewRow, 'QACTION', 'I') //Action
	idsOMQDelivery.setitem(llNewRow, 'QSTATUS', 'NEW') //QStatus
	idsOMQDelivery.setitem(llNewRow, 'STATUS', '02') //Status
	idsOMQDelivery.setitem(llNewRow, 'QWMQID', ll_batch_seq_no) //Set with Batch_Transaction.Trans_Id
	idsOMQDelivery.setitem(llNewRow, 'ORDERKEY', Right(lsDoNo,10)) //Receipt Key
	idsOMQDelivery.setitem(llNewRow, 'SITE_ID',  lsWh) //site id
	idsOMQDelivery.setitem(llNewRow, 'ADDDATE', ldtToday) //add_date
	idsOMQDelivery.setitem(llNewRow, 'ADDWHO', 'SIMSUSER') //add_who
	idsOMQDelivery.setitem( llNewRow, 'EDITDATE', ldtToday) //Edit Date
	idsOMQDelivery.setitem( llNewRow, 'EDITWHO', 'SIMSUSER') //Edit Who
	idsOMQDelivery.setitem( llNewRow, 'TYPE', ls_OM_Type) //Type

	//Load Records from Delivery Master	
//TAM 10/27/2017 Change per Dave
//	idsOMQDelivery.SetItem(llNewRow, 'CONSIGNEEKEY' ,idsDOheader.GetItemString(1,'Cust_Code'))
	idsOMQDelivery.SetItem(llNewRow, 'CONSIGNEEKEY' ,left(idsDOheader.GetItemString(1,'Cust_Code'),10))
	idsOMQDelivery.SetItem(llNewRow, 'CLIENT_SHIPTO_ID' ,idsDOheader.GetItemString(1,'Cust_Code'))
	idsOMQDelivery.SetItem(llNewRow, 'C_COMPANY', left(idsDOheader.GetItemString(1,'Cust_Name') ,45)) //19-APR-2019 :Madhu DE10140
	idsOMQDelivery.SetItem(llNewRow, 'C_ADDRESS1', idsDOheader.GetItemString(1,'Address_1'))
	idsOMQDelivery.SetItem(llNewRow, 'C_ADDRESS2', idsDOheader.GetItemString(1,'Address_2'))
	idsOMQDelivery.SetItem(llNewRow, 'C_ADDRESS3', idsDOheader.GetItemString(1,'Address_3'))
	idsOMQDelivery.SetItem(llNewRow, 'C_ADDRESS4', idsDOheader.GetItemString(1,'Address_4'))
	idsOMQDelivery.SetItem(llNewRow, 'C_ZIP', idsDOheader.GetItemString(1,'zip'))
	idsOMQDelivery.SetItem(llNewRow, 'C_CITY', idsDOheader.GetItemString(1,'City'))
	idsOMQDelivery.SetItem(llNewRow, 'DELIVERYPLACE', idsDOheader.GetItemString(1,'State'))
	idsOMQDelivery.SetItem(llNewRow, 'C_COUNTRY', idsDOheader.GetItemString(1,'Country'))
	idsOMQDelivery.SetItem(llNewRow, 'C_CONTACT1', idsDOheader.GetItemString(1, 'contact_person')) 
	idsOMQDelivery.SetItem(llNewRow, 'C_PHONE1', idsDOheader.GetItemString(1, 'tel')) 
	idsOMQDelivery.SetItem(llNewRow, 'BUYER_PO', idsDOheader.GetItemString(1,'client_cust_po_nbr'))
	idsOMQDelivery.SetItem(llNewRow, 'DEPARTMENT', idsDOheader.GetItemString(1, 'user_field10'))
	idsOMQDelivery.SetItem(llNewRow, 'NOTES', idsDOheader.GetItemString(1, 'shipping_instructions'))
	idsOMQDelivery.SetItem(llNewRow, 'SUSR1', idsDOheader.GetItemString(1, 'remark'))
	idsOMQDelivery.SetItem(llNewRow, 'freightPaymentTerms',  idsDOheader.GetItemString(1,'freight_terms'))
	idsOMQDelivery.SetItem(llNewRow, 'ORDERGROUP', idsDOheader.GetItemString(1, 'User_Field7')) 
	idsOMQDelivery.setitem( llNewRow, 'EXTERNORDERKEY', idsDOheader.GetItemString(1, 'Invoice_no')) //supp_invoice_no
	idsOMQDelivery.setitem( llNewRow, 'SUSR3', idsDOheader.GetItemString(1, 'Client_Cust_Po_Nbr')) 
	//idsOMQDelivery.setitem( llNewRow, 'SOURCEFILEDATE', idsDOheader.GetItemDateTime(1, 'Customer_Sent_Date')) 

	//Get SHIP_FROM from Delivery Alt address
	ldsDOAddress.Retrieve(lsDoNo)
	lsFind ="address_type ='ST'"
	llFindRow =ldsDOAddress.find(lsFind,1,ldsDOAddress.rowcount())
	
	If llfindRow > 0 Then
		idsOMQDelivery.SetItem(llNewRow,'B_COMPANY',Trim(ldsDOAddress.GetItemString(llfindRow, 'Name'))) 
		idsOMQDelivery.SetItem(llNewRow,'B_ADDRESS1',Trim(ldsDOAddress.GetItemString(llfindRow, 'Address_1'))) 
		idsOMQDelivery.SetItem(llNewRow,'B_ADDRESS2',Trim(ldsDOAddress.GetItemString(llfindRow, 'Address_2'))) 
		idsOMQDelivery.SetItem(llNewRow,'B_ADDRESS3',Trim(ldsDOAddress.GetItemString(llfindRow, 'Address_4'))) 
		idsOMQDelivery.SetItem(llNewRow,'B_ADDRESS4',Trim(ldsDOAddress.GetItemString(llfindRow, 'Address_4'))) 
		idsOMQDelivery.SetItem(llNewRow,'B_CITY',Trim(ldsDOAddress.GetItemString(llfindRow, 'City')))
		idsOMQDelivery.SetItem(llNewRow,'B_STATE',Trim(ldsDOAddress.GetItemString(llfindRow, 'State')))
		idsOMQDelivery.SetItem(llNewRow,'B_ZIP',Trim(ldsDOAddress.GetItemString(llfindRow, 'Zip'))) 
		idsOMQDelivery.SetItem(llNewRow,'B_COUNTRY',Trim(ldsDOAddress.GetItemString(llfindRow, 'Country')))
		idsOMQDelivery.SetItem(llNewRow,'B_PHONE1',Trim(ldsDOAddress.GetItemString(llfindRow, 'Tel')))	
	End if
		
	//Write to File and Screen
	lsLogOut = '      - OM Outbound 940C- Processed Header Record for Do_No: ' + lsDoNo +" and Change_Request_No: "+string(ll_change_req_no)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
	//2. ADD OMQ_RECEIPTDETAIL Tables
	idsDOdetail.Retrieve(lsDoNo)

//Loop through Ref datastore to update OM tables.
	For ll_detail_row = 1 to idsDOdetail.rowcount()
		llNewDetailRow = idsOMQDeliveryDetail.insertrow( 0)

		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'CHANGE_REQUEST_NBR', ll_change_req_no) //change_request_no
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'CLIENT_ID', ls_client_id) //client_Id
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'QACTION', 'I') //Action
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'QSTATUS', 'NEW') //QStatus
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'STATUS', '02') //Status
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'QWMQID', ll_batch_seq_no) //Set with Batch_Transaction.Trans_Id
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'ORDERKEY', Right(lsDoNo,10)) //Receipt Key
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'SITE_ID',  lsWh) //site id
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'ADDDATE', ldtToday) //add_date
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'ADDWHO', 'SIMSUSER') //add_who
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'EDITDATE', ldtToday) //Edit Date
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'EDITWHO', 'SIMSUSER') //Edit Who

		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'ITEM', Trim(idsDOdetail.GetItemString(ll_detail_row, 'sku'))) 
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'EXTERNLINENO', String (idsDOdetail.GetItemNumber(ll_detail_row,'line_item_no'))) 
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'ORDERLINENUMBER', String (idsDOdetail.GetItemNumber(ll_detail_row,'line_item_no'),'00000')) 
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'EXTERNORDERKEY',  idsDOheader.GetItemString(1, 'Invoice_no')) //supp_invoice_no
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'ORIGINALQTY',idsDOdetail.GetItemNumber(ll_detail_row, 'Req_Qty')) 
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'UOM', Trim(idsDOdetail.GetItemString(ll_detail_row, 'UOM')))


		ls_line_no =String (idsDOdetail.GetItemNumber(ll_detail_row,'line_item_no'))
		lsSku =Trim(idsDOdetail.GetItemString(ll_detail_row, 'sku'))
		
		select Po_No into :lsFromProject from EDI_Outbound_Detail with(nolock) 
		where EDI_Batch_Seq_No=:ll_batch_seq_no and Invoice_No=:lsInvoice 
		and sku=:lsSku and line_Item_No=:ls_line_no
		using sqlca;

		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'LOTTABLE03',  trim(lsFromProject))

		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'RETAILSKU', Trim(idsDOdetail.GetItemString(ll_detail_row,'User_Field1')))
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'UNITPRICE', idsDOdetail.GetItemNumber(ll_detail_row,'Price'))
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'SUSR1', Trim(idsDOdetail.GetItemString(ll_detail_row,'User_Field5')))
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'SUSR2',Trim(idsDOdetail.GetItemString(ll_detail_row, 'Currency_Code')))
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'SUSR3',Trim(idsDOdetail.GetItemString(ll_detail_row, 'User_Field3')))
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'REFCHAR6', idsDOheader.GetItemString(1, 'User_Field5')) 

//TAM TODO Get Container from the EDI Record
//		idsOMQDeliveryDetail.SetItem(llNewDetailRow,'LOTTABLE06', Trim(idsDOdetail.GetItemString(ll_detail_row,'Container_Id' )))

		llOwnerID= idsDOdetail.GetItemNumber(ll_detail_row,'Owner_Id')
		//  Owner ID
		if llOwnerID <> llOwnerID_Prev then
			select owner_CD into :lsOwnerCD
			from owner
			where project_id = 'PANDORA' and owner_id = :llOwnerId;
			llOwnerId_Prev = llOwnerId
		end if
		idsOMQDeliveryDetail.SetItem(llNewDetailRow,'LOTTABLE01', Trim(lsOwnerCd))
	
//TAM 11/8/2017 Added INVACCOUNT  Per Dave's instructions
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'INVACCOUNT', lsOwnerCd +'~~'+lsFromProject) //Owner_CD, '~', PO_NO (ex: WHIACBP~MAIN)
		
		//Write to File and Screen
		lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + lsDoNo +" and Change_Request_No: "+string(ll_change_req_no) +" and Line_Item_No: "+ String(idsDOdetail.GetItemNumber(ll_detail_row,'line_item_no'))
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
	next /*next detail record */
	
next /*next header record */

//storing into DB
//Execute Immediate "Begin Transaction" using om_sqlca; 4/2020 - MikeA - DE15499
If idsOMQDeliveryDetail.rowcount( ) > 0 Then 	ll_rc =idsOMQDeliveryDetail.update( false, false);
If idsOMQDelivery.rowcount( ) > 0 and ll_rc =1 Then ll_rc =idsOMQDelivery.update( false, false);

If ll_rc =1 Then
	//Execute Immediate "COMMIT" using om_sqlca; 4/2020 - MikeA - DE15499
	commit using om_sqlca;
	if om_sqlca.sqlcode = 0 then
		idsOMQDelivery.resetupdate( )
		idsOMQDeliveryDetail.resetupdate( )
	else
		//Execute Immediate "ROLLBACK" using om_sqlca; 4/2020 - MikeA - DE15499
		rollback using om_sqlca;
		idsOMQDelivery.reset( )
		idsOMQDeliveryDetail.reset( )
		//Write to Log File and Screen
		lsLogOut = "      - OM Outbound 940C- Unable to Save new SO Records to database .!~r~r" + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)

		Return -1
	end if

else
	//Execute Immediate "ROLLBACK" using om_sqlca; 4/2020 - MikeA - DE15499
	rollback using om_sqlca;
	
	//Write to Log File and Screen
	lsLogOut = "      - OM Outbound 940C- System error, record save failed! .!~r~r" + om_sqlca.SQLErrText
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

destroy idsOMQDelivery
destroy idsOMQDeliveryDetail

//Write to File and Screen
lsLogOut = '      - OM 940 Confirmation- End Processing of uf_process_om_warehouse_order: ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function integer uf_process_om_soc (string asproject);//Process Tranfer Order for Pandora
/* 05/24/2010 ujh:  Even though the DiskErase/HWOPS Key words are specified on the OD, the use of lsSOC_variant assumes that the
	whole order is as specified and will call the appropriate stored procedure for all ODs.  Note that lsSOC_variant is set only once.  */
boolean lb_diskerase
string lsSOC_variant, lsNewInvType

Datastore	lu_ds, ldsItem, lsLookupTable

datetime ldtWHTime

// 01/18/2010 ujh Add lsDelete_TONO, lsDelete_List  This is Owner Change Fix 1 of 5
// 02/08/2010 ujh add lsRecDataSoc, lsReturnTxt,  llReturnCode, lsListIgnored, lsListProcessed, lbSQLCAauto, 
							// llCntReceived, llCntIgnored, llCntProcessed,   llspParamMax, lsParamSeperator  for  AutoSOCchange
String	lsLogout,lsStringData, lsOrder, lsTemp, lsRecData, lsRecType, lsDesc, lsSKU, lsSupplier, lsNoteText ,lsNoteType,lsFromOwnerCd, &
		lsToOwnerCd, lsFromPoNo, lsToPoNo, lsTONO,lsFromOwnerId , lsToOwnerId,  lsFromWarehouse, lsToWarehouse,lsUF3, & 
		lsDelete_TONO, lsDelete_List, lsRecDataSOC, lsReturnTxt, lsListIgnored, lsListProcessed, lsParamSeperator
Integer	liRC,liFileNo
Long		llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llOwnerID, llNewNotesRow, llNoteSeq, llNoteLine &
              ,llReturnCode, llCntReceived, llCntIgnored, llCntProcessed,   llspParamMax,ll_ccline, ll_ccinvt

Boolean	lbError, lbDetailError, lbSQLCAauto
DateTime	ldtToday
Decimal	ldWeight, ldLineItemNo_c, ldFromOwnerID, ldToOwnerID
String ls_ccno, ls_ccline, ls_ccsku, ls_ccsupp_code, ls_cccoo, ls_cclotno, ls_ccpono, ls_ccpono2, ls_ccqty, ls_ccownerid, ls_cclcode, ls_ccinvtype, ls_ccserialno, ls_cccontid, ls_ccrono

Decimal ldTONO, ldTemp

String 	lsOrderNo
string 	lsSKU2, lsGPN, lsTemp2
string		lsFromProject, lsToProject
String 	lsLot_No, lsCOO, lsDiskEraseDelim   // 05/21/2010 ujh added to create a delimiter for Lot_Number and COO in Diskerase
boolean lbSkipAutoSOC
String    ls_SkipSOCProj
Long llSkipSOCCountRowCount, ll_SelectCount
//TimA 12/13/11 Set a counter for displaying the record process
Long llCounter, llCounterLoop
// LTK 20151210 Added for Pandora #1002 SOC with Serial GPNs
String ls_serialized_ind, ls_container_tracking_ind //TAM 2017/01 for container tracking SOC exceptions
long ll_rows, ll_row
String ls_org_sql, ls_om_threshold, ls_change_request_nbrs, ls_error_msg, lsFromOwnerCD_Prev, lsToOwnerCD_Prev
Long ll_delivery_queue_count, ll_change_request_nbr, ll_delivery_count, ll_detail_error_count, ll_row_pos_detail, ll_delivery_detail_count, ll_delivery_attr_count, ll_found

lsDiskEraseDelim = ":"

// 02/08/2010 ujh:  Initialize max length of parmaeter to be sent to stored proc sqlca.Sp_Auto_SOC and define the param segment seperator
 llspParamMax = 4000
lsParamSeperator = '$*&'

lsLogOut = '          - PROCESSING FUNCTION - Create Inbound Transfer Orders. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

SetPointer(Hourglass!)

ls_om_threshold =ProfileString (gsinifile ,"SIMS3FP", "OMTHRESHOLD","")
ldtToday = DateTime(Today(),Now())

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

If Not isvalid(idsTOHeader) Then
	idsTOheader = Create u_ds_datastore
	idsTOheader.dataobject= 'd_transfer_master'
	idsTOheader.SetTransObject(SQLCA)
End If
idsTOheader.SetTransObject(SQLCA)

If Not isvalid(idsTOdetail) Then
	idsTOdetail = Create u_ds_datastore
	idsTOdetail.dataobject= 'd_transfer_detail'
	idsTOdetail.SetTransObject(SQLCA)
End If

If Not isvalid(lsLookupTable) Then
	 lsLookupTable = Create u_ds_datastore
	 lsLookupTable.dataobject = 'd_lookup_table_search'
	 lsLookupTable.SetTransObject(SQLCA)
End If
idsTODetail.SetTransObject(SQLCA)

IF NOT isvalid(idsOMCSOCDelivery) THEN					//OMC_Warehouse_Order
	idsOMCSOCDelivery = Create u_ds_datastore
	idsOMCSOCDelivery.dataobject ='d_omc_warehouse_order'
	idsOMCSOCDelivery.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMCSOCDeliveryDetail) THEN		 		//OMC_Warehouse_OrderDetail
	idsOMCSOCDeliveryDetail = Create u_ds_datastore
	idsOMCSOCDeliveryDetail.dataobject ='d_omc_warehouse_orderdetail'
	idsOMCSOCDeliveryDetail.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMCSOCDeliveryAttr) THEN		 		//OMC_Warehouse_OrderAttr
	idsOMCSOCDeliveryAttr = Create u_ds_datastore
	idsOMCSOCDeliveryAttr.dataobject ='d_omc_warehouse_orderattr'
	idsOMCSOCDeliveryAttr.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMASOCQueue) THEN		 		//OMA_Warehouse_Order_Queue
	idsOMASOCQueue = Create u_ds_datastore
	idsOMASOCQueue.dataobject ='d_oma_warehouse_order_queue'
	idsOMASOCQueue.SetTransObject(om_sqlca)
END IF

Datastore lds_om_receipt_list //2017/07 :TAM Added for PINT- 856
//2017/07 :TAM Added for PINT- 856
//Store all Delivery Orders + Status Cd value
If not isValid(lds_om_receipt_list) Then
	lds_om_receipt_list =create Datastore
	lds_om_receipt_list.dataobject ='d_om_update_receipt_order_list'
End If
//2017/07 :TAM Added for PINT -856 -END

idsOMCSOCDelivery.reset()
idsOMCSOCDeliveryAttr.reset()
idsOMCSOCDeliveryDetail.reset()
idsOMASOCQueue.reset()

idsTOheader.Reset()
idsTODetail.Reset()

//Open and read the File In
lsLogOut = '      - Opening File for PANDORA OM Transfer Order Processing: ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Retrieve eligible records from Queue
ls_org_sql =idsOMASOCQueue.getsqlselect( )
ls_org_sql +=" AND DIST_SEQ_ID IN (SELECT SEQ_ID FROM OPS$OMAUTH.OMA_DISTRIBUTION WHERE SYSTEM_TYPE='SIMS' AND CLIE_CLIENT_ID ='"+is_om_client_id+"') "
ls_org_sql +=" AND ORDERGROUP= 'SOC' " 

ls_org_sql +=" AND ROWNUM < " + ls_om_threshold //Threshold
ls_org_sql +=" ORDER BY CHANGE_REQUEST_NBR  "
idsOMASOCQueue.setsqlselect( ls_org_sql)
ll_delivery_queue_count = idsOMASOCQueue.retrieve( )

lsLogOut =" Warehouse Order Queue SQL query is -> "+ls_org_sql
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

lsLogOut = " Warehouse Order Queue count from OM -> "+string(ll_delivery_queue_count)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


// load Queue datastore for processing
FOR llRowPos =1 to ll_delivery_queue_count
	ll_change_request_nbr = idsOMASOCQueue.getitemnumber(llRowPos, 'CHANGE_REQUEST_NBR') 
	ls_change_request_nbrs += string(ll_change_request_nbr) +","
NEXT

IF ll_delivery_queue_count > 0 Then
	ls_change_request_nbrs =left(ls_change_request_nbrs, len(ls_change_request_nbrs) -1)
	
	ls_org_sql =idsOMCSOCDelivery.getsqlselect( )
	ls_org_sql +=" WHERE CHANGE_REQUEST_NBR IN ( " + ls_change_request_nbrs + " )" //Threshold
	idsOMCSOCDelivery.setsqlselect( ls_org_sql)
	ll_delivery_count = idsOMCSOCDelivery.retrieve( )

	//Retrieving Orders from OM database
	lsLogOut = '      - OM Outbound - Getting Count(Records) from OM Warehouse_Order Table for Processing: ' + string(ll_delivery_count)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
	// Reset main window microhelp message
	w_main.SetMicroHelp("Processing Delivery Order from OM")

	llOrderSeq = 0 /*order seq within file*/

	//TimA 05/19/14 Pandora issue #582 Add logic to lookup the Projects that skip Auto SOC from the lookup table
	//TimA 02/13/15 Parms for the Functionality_Manager function
	String ls_Parm1, ls_Parm2, ls_Parm3
	SetNull(ls_Parm1)
	SetNull(ls_Parm2)
	SetNull(ls_Parm3)

	llSkipSOCCountRowCount = lsLookupTable.retrieve(asProject,'SOC' )
	llRowPos = 0
	For llRowPos = 1 to llSkipSOCCountRowCount
			//Build a string of projects that are skipped.
			ll_SelectCount ++
			If ll_SelectCount > 1 then
				ls_SkipSOCProj = ls_SkipSOCProj + ',' + lsLookupTable.GetItemString(llRowPos,'Code_Id')
			Else
				ls_SkipSOCProj = ls_SkipSOCProj  + lsLookupTable.GetItemString(llRowPos,'Code_Id')
			End if
	Next

		////  Owner Change Fix 2 of 5
		// 01/18/2010 ujh:  Reset the delete list that will hold "new" Transfer_Master records that will be replaced by input file.
	lsDelete_List = "" ///TAM TODO ????What is this


// ***** LOAD HEADER RECORDS *****
	For llRowPos = 1 to ll_delivery_count
		
		ll_change_request_nbr = idsOMCSOCDelivery.getitemnumber(llRowPos, 'CHANGE_REQUEST_NBR')

		//Write to Log File and Screen
		lsLogOut = '      -OM SOC - Processing Header Record for Change Request Nbr: ' + string(ll_change_request_nbr)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)


		choose case  Upper(idsOMCSOCDelivery.GetItemString(llRowPos, 'CHANGE_REQUEST_INDICATOR'))
			case 'CANCEL'
				ls_error_msg = "Change_Request_Nbr ="+string(ll_change_request_nbr)+" CANCEL is not valid for SOC. Record will not be processed."
				gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
				lbError = True
				Continue //Process Next Record
		end Choose
		
		
		lsSOC_variant = '*EMPTY*'  // 06/11/2010 ujh:  Set on each order so variants can be set at most once to apply to whole order
		llNewRow=idsToHeader.InsertRow(0)
		llOrderSeq ++
		llLineSeq = 0

		sqlca.sp_next_avail_seq_no(asproject,"Transfer_Master","TO_No" ,ldTONO)//get the next available RO_NO
		If ldTONO <= 0 Then Return -1

		lsToNO = asProject + String(Long(ldToNo),"000000") 
		idsTOHeader.SetItem(llNewRow,'to_no',lsToNo)
		idsTOHeader.SetItem(llNewRow,'project_id',asProject)
		idsTOHeader.SetItem(llNewRow,'last_user','SIMSFP')
		idsTOHeader.SetItem(llNewRow, 'Ord_type', 'O')  /* Internal Order Type )  */
		idsTOHeader.SetItem(llNewRow, 'Ord_Status', 'N')
		idsTOHeader.SetItem(llNewRow, 'OM_Change_Request_Nbr', ll_change_request_nbr)  
		idsTOHeader.SetItem(llNewRow, 'OM_Confirmation_Type', 'E')  

		
// From Owner
		// Get the first detail record for this header. It contains Owner and PONO(project) needed on the header		
		ll_delivery_detail_count = idsOMCSOCDeliveryDetail.retrieve(ll_change_request_nbr )

		// Owner Code, Owner_Id  * Get from the first detail
		lsFromOwnerCd = Trim(idsOMCSOCDeliveryDetail.GetItemString(1, 'LOTTABLE01'))

		lsLogOut =  '      - Get From Owner: '  + lsFromOwnerCd
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

		select owner_id into :ldFromOwnerID
		from owner
		where project_id = :asProject and owner_cd = :lsFromOwnerCD;
	
		lsFromOwnerID = String(ldFromOwnerID)
		
		IF len(lsFromOwnerID) > 0 Then
			lsFromOwnerCD_Prev = lsFromOwnerCD  // Used in detail Processing to see if the Owner Ccde has Changed
			idsTOHeader.SetItem(llNewRow, 'User_Field2', lsFromOwnerCd)
		ELSE
			ls_error_msg = "Change_Request_Nbr ="+string(ll_change_request_nbr)+" -LOTTABLE01(FROM OWNER CODE) is not valid. Record will not be processed."
			gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
			lbError = True
			Continue //Process Next Record
		END IF

		//Warehouse
		select user_field2 into :lsFromWarehouse
		from customer
		where project_id = :asProject and cust_code = :lsFromOwnerCD;
		idsTOHeader.SetItem(llNewRow, 's_warehouse', lsFromWarehouse)  /*  */	
		// 4/2010 - now setting ord_date to local wh time
		ldtWHTime = f_getLocalWorldTime(lsFromWarehouse)
		//idsTOheader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))
		idsTOheader.SetItem(llNewRow, 'ord_date', ldtWHTime) // this is setting in Transfer_Master so ord_date is actually a date/time (and not char)

		// KZUV.COM - Set the last update DATETIME to warehouse time.
		idsTOHeader.SetItem(llNewRow,'last_update', ldtWHTime)

			
// To Owner
		// Owner Code, Owner_Id  * Get from the first detail

		//TAM 10/27/2017 Changed per Dave
//		lsToOwnerCd = Trim(idsOMCSOCDelivery.GetItemString(llRowPos, 'CONSIGNEEKEY'))
		lsToOwnerCd = Trim(idsOMCSOCDelivery.GetItemString(llRowPos, 'CLIENT_SHIPTO_ID'))
		lsLogOut =  '      - Get TO owner: '  + lsToOwnerCd
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

		lsToOwnerID = ""		//GailM 6/19/2020 DE16350 Google - error creating SOC when new owner doesn't exist - Reinitialize variable
				
		select owner_id into :ldToOwnerID
		from owner
		where project_id = :asProject and owner_cd = :lsToOwnerCD;

		lsToOwnerID = String(ldToOwnerID)

		IF len(lstoOwnerID) > 0 Then
			lsToOwnerCD_Prev = lsToOwnerCD  // Used in detail Processing to see if the Owner Ccde has Changed
		ELSE
//			ls_error_msg = "Change_Request_Nbr ="+string(ll_change_request_nbr)+" -CONSIGNEEKEY(TO OWNER CODE) is not valid. Record will not be processed."
			ls_error_msg = "Change_Request_Nbr ="+string(ll_change_request_nbr)+" -CLIENT_SHIPTO_ID(TO OWNER CODE) is not valid. Record will not be processed."
			gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
			lbError = True
			Continue //Process Next Record
		END IF

		//To Warehouse
		select user_field2 into :lsToWarehouse
		from customer
		where project_id = :asProject and cust_code = :lsToOwnerCD;
		idsTOHeader.SetItem(llNewRow, 'd_warehouse', lsToWarehouse)  /*  */	

		If lsFromWarehouse <> lsToWarehouse Then

			ls_error_msg = "Change_Request_Nbr ="+string(ll_change_request_nbr)+" -'From Owner' and 'To Owner' are in different Warehouses. This is not allowed on an Owner Change. Record will not be processed."
			gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
			lbError = True
			Continue /*Process Next Record */
		End If
			
		// If the TO owner code follows the pattern WH*PM,
		If left(lsToOwnerCd, 2) = "WH" and right(lsToOwnerCd, 2) = "PM" then
			 // Write the error to the log file.
			 gu_nvo_process_files.uf_write_log("Row: " + string(llRowPos) + " 'Operations needs control where FROM and TO warehouses both equal 'WH*PM'.  Record will not be processed.")
			 lbSkipAutoSOC = True
		End If
			
//MTR Number 
		//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
		lsLogOut =  '      - Get MTR Number: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

		lsTemp = Trim(idsOMCSOCDelivery.GetItemString(llRowPos, 'EXTERNORDERKEY'))

		IF len(lsTemp) = 0 Then
			ls_error_msg = "Change_Request_Nbr ="+string(ll_change_request_nbr)+" -EXTERNORDERKEY(MTR Numbrt) is not valid. Record will not be processed."
			gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
			lbError = True
			Continue //Process Next Record
		END IF

// Check if MTR Number already exists.  If It does, Bail.
// 2007/08/03 TAM filter status = "V"oid from duplicate check
		Select Distinct(User_Field3) into :lsUF3
		From Transfer_Master
		Where Project_id = :asProject
		and User_Field3 = :lsTemp and Ord_status <> 'V';

// 01/17/2010  ujh Owner Change Fix:  Fix so "New" transfer_Master, Transfer_detail, and Transfer_detail_content records are replaced			
		lsDelete_TONO = ''
		// If record already exists, check to see if it is new.  If so get TO_No so those new records can be deleted.
		if lsUF3 =  lsTemp then 
			Select TO_No into :lsDelete_TONO
			From Transfer_Master
			Where Project_ID = :asProject
			and User_Field3 = :lsUF3 and Ord_Status = 'N';
								
			//if lsDelete_TONO is populated, need to create/AddTo delete list, otherwise bail
			if len(lsDelete_TONO) > 0 then
					lsDelete_List = lsDelete_List + ',' +  lsDelete_TONO
				else

					ls_error_msg = "Change_Request_Nbr ="+string(ll_change_request_nbr)+" -Owner Change Already Exists and is NOT 'New'"
					gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
					
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " MTR Nbr " + string(lsTemp) + " - Owner Change Already Exists and is NOT 'New'") 
					lbError = True
					Continue /*Process Next Record */
				end if
			
		end if
		
		if (len(lsRecDataSOC) + len(lsTemp))  > llspParamMax  then 
				lsRecDataSoc = lsRecDataSoc + lsParamSeperator
		end if
		lsRecDataSOC =  lsRecDataSOC + lsTemp + '|'
		idsTOHeader.SetItem(llNewRow, 'User_Field3', lsTemp)
		
// Remark
		//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
		lsLogOut =  '      - Remark: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//TAM 2017/12/5 - Pull NOTES2 into remarks
//		lsTemp = Trim(idsOMCSOCDelivery.GetItemString(llRowPos, 'TRANSPORTATIONSERVICE'))
		lsTemp = Trim(idsOMCSOCDelivery.GetItemString(llRowPos, 'NOTES2'))
		idsTOHeader.SetItem(llNewRow, 'Remark', lsTemp)
		lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */


		// Get the orderattr records for this header. 		
		ll_delivery_attr_count = idsOMCSOCDeliveryAttr.retrieve(ll_change_request_nbr )
// Requestor and Email
		ll_found = idsOMCSOCDeliveryAttr.Find("CHANGE_REQUEST_NBR = " + string(ll_change_request_nbr) + ' and UPPER(ATTR_TYPE) = "SHIPFROMCONTACT" ' , 1, ll_delivery_attr_count)
		if ll_found > 0 then
			//  User Field 4 
			lsTemp = Trim(idsOMCSOCDeliveryAttr.GetItemString(ll_found, 'REFCHAR1'))
			idsTOheader.SetItem(llNewRow, 'User_Field4', Trim(lsTemp)) 
			//  User Field 5
			lsTemp = Trim(idsOMCSOCDeliveryAttr.GetItemString(ll_found, 'REFCHAR2'))
			idsTOheader.SetItem(llNewRow, 'User_Field5', Trim(lsTemp)) 
		end if


//*****  Begin detail loop
	// ***** LOAD DETAIL RECORDS *****
		ll_detail_error_count =0 //re-set detail error count value
		ls_error_msg ='' //re-set error msg value

		FOR ll_Row_Pos_Detail =1 to ll_delivery_detail_count	


//CASE 'OD' /* detail */
			//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
			lsLogOut =  '      - Load Detail: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			
			lbDetailError = False
			llNewDetailRow = 	idsTODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			idsTODetail.SetItem(llNewDetailRow,'TO_NO', lsTONO) /*project*/
			idsTODetail.SetItem(llNewDetailRow, 'Owner_id', ldFromOwnerID)  /*  */	
			idsTODetail.SetItem(llNewDetailRow, 'New_Owner_id',ldToOwnerID)  /*  */	
			idsTODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			idsTODetail.SetItem(llNewDetailRow, 'New_Inventory_Type', 'N')
			idsTODetail.SetItem(llNewDetailRow,'Supp_Code', 'PANDORA') 
			idsTODetail.SetItem(llNewDetailRow,'Country_of_origin', 'XXX') 
			idsTODetail.SetItem(llNewDetailRow,'Serial_No', '-') 
			idsTODetail.SetItem(llNewDetailRow,'Lot_No', '-') 
			idsTODetail.SetItem(llNewDetailRow,'Po_No2', '-') 
			idsTODetail.SetItem(llNewDetailRow,'Container_Id', '-') 
			idsTODetail.SetItem(llNewDetailRow,'Expiration_Date', '2999/12/31') 
			idsTODetail.SetItem(llNewDetailRow, 's_location', '*')  /*  */	
			idsTODetail.SetItem(llNewDetailRow, 'd_location', '*')  /*  */	
			idsTODetail.SetItem(llNewDetailRow, 'OM_Change_Request_Nbr', ll_change_request_nbr)  

//SKU
			//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
			lsLogOut =  '      - Process SKU: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			lsTemp = Trim(idsOMCSOCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'ITEM'))
						
			lsSKU = trim(lsTemp)  
			// TAM 20170113  Pandora  - added more columns
			Select MAX(SKU), COUNT(SKU), MAX(serialized_ind), MAX(Container_Tracking_Ind)
			Into :lsSKU2, :ll_rows, :ls_serialized_ind, :ls_container_tracking_ind
			From Item_Master
			Where Project_id = :asProject
			and SKU = :lsSKU;
			if lsSKU2 = '' then 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Missing Pandora SKU...") 
			end if
				
			idsTODetail.SetItem(llNewDetailRow, 'SKU', lsSKU)

			// LTK 20151210  Pandora #1002 - If GPN is serialized, then skip the Auto SOC
			if NOT lbSkipAutoSOC and Len(lsSKU2) > 0 then				
				 If f_retrieve_parm("PANDORA", "FLAG", "SOC_SERIAL_GPN_TRACK_ON") = 'Y' then
					if ll_rows = 1 then
						if Len( ls_serialized_ind ) > 0 and ls_serialized_ind <> 'N'  then
							lbSkipAutoSOC = TRUE
							lsLogOut = '      - Skipping Auto SOC because SKU (' + lsSKU + ') is serialized'
							FileWrite(giLogFileNo,lsLogOut)
						end if
					else
						ls_serialized_ind = ""
	
						Select MAX(serialized_ind)
						Into :ls_serialized_ind
						From Item_Master
						Where Project_id = :asProject
						and SKU = :lsSKU
						and Supp_Code = 'PANDORA';
	
						if Len( ls_serialized_ind ) > 0 and ls_serialized_ind <> 'N'  then
							lbSkipAutoSOC = TRUE
							lsLogOut = '      - Skipping Auto SOC because SKU (' + lsSKU + ') is serialized'
							FileWrite(giLogFileNo,lsLogOut)
						end if
					end if
				end if
			end if

			// TAM 20170113  Pandora  - If GPN is container tracked, then skip the Auto SOC
			if NOT lbSkipAutoSOC and Len(lsSKU2) > 0 then				
				 If f_retrieve_parm("PANDORA", "FLAG", "SOC_CONTAINER_TRACK_ON") = 'Y' then
					if ll_rows = 1 then
						if Len( ls_container_tracking_ind ) > 0 and ls_container_tracking_ind <> 'N'  then
							lbSkipAutoSOC = TRUE
							lsLogOut = '      - Skipping Auto SOC because SKU (' + lsSKU + ') is container tracked'
							FileWrite(giLogFileNo,lsLogOut)
						end if
					else
						ls_container_tracking_ind = ""
	
						Select MAX(Container_Tracking_Ind)
						Into :ls_container_tracking_ind
						From Item_Master
						Where Project_id = :asProject
						and SKU = :lsSKU
						and Supp_Code = 'PANDORA';
	
						if Len( ls_container_tracking_ind ) > 0 and ls_container_tracking_ind <> 'N'  then
							lbSkipAutoSOC = TRUE
							lsLogOut = '      - Skipping Auto SOC because SKU (' + lsSKU + ') is container tracked'
							FileWrite(giLogFileNo,lsLogOut)
						end if
					end if
				end if
			end if

//From Project

			//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
			lsLogOut =  '      - From Project: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			lsTemp = Trim(idsOMCSOCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'LOTTABLE03'))
			//TimA 05/19/14 Pandora issue #852 Removed the hard coded search of projects that are skipped from Auto SOC and have this come from the lookup table.
			If pos ( ls_SkipSOCProj, Upper(lsTemp ), 1 ) > 0 then
				lbSkipAutoSOC = True
			End if

			idsTODetail.SetItem(llNewDetailRow, 'PO_NO', Trim(lsTemp))
			lsFromProject = lsTemp


//To Project
			//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
			lsLogOut =  '      - To Project: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			lsTemp = Trim(idsOMCSOCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'SUSR1'))

			//TimA 05/19/14 Pandora issue #852 Removed the hard coded search of projects that are skipped from Auto SOC and have this come from the lookup table.
			//Look in the string (created above) for the project.
			If pos ( ls_SkipSOCProj, Upper( lsTemp ), 1 ) > 0  then
				lbSkipAutoSOC = True
			End if				

			idsTODetail.SetItem(llNewDetailRow, 'New_PO_NO', Trim(lsTemp))
		
			lsToProject = lsTemp
			
			//Jxlim 11/15/2011 BRD #302 Do not process SOC when the project is Research to Research
			If 	lsFromProject = 'RESEARCH'  and lsToProject = 'RESEARCH' Then     
				//dts 5/2/2014 - only skipping 'RESEARCH' SOC if From/To owner are the same...
				if lsFromOwnerCD = lsToOwnerCD then
	// TAM TODO  - Process Detail Error
					lsLogOut =  '  - !!! FROM and TO Project are RESEARCH - Not processing SOC'
					FileWrite(giLogFileNo,lsLogOut)
					Return -1
				end if
			End If

//From/To Inventory Types...
			Choose Case upper(lsSOC_variant) 
				case 'DISKERASE', 'HWOPS'  // 06/11/2010 ujh:  not relavant for these variants
					
				case else
					if lsFromProject = 'RTV-IN' or lsFromProject = 'RTV-OUT' then
						idsTODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'R') /* RTV */
					end if
	
					if lsToProject = 'RTV-IN' or lsToProject = 'RTV-OUT' then
						idsTODetail.SetItem(llNewDetailRow, 'New_Inventory_Type', 'R') /* RTV */
					end if
			end choose
			//end if

//Line Number
			//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
			lsLogOut =  '      - Processing Line Number: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			lsTemp = Trim(idsOMCSOCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'EXTERNLINENO'))
			If Not isnumber(lsTemp) Then
// TAM TODO  - Process Detail Error
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - 'Line Item' is not numeric. Record will not be processed.")
				lbDetailError = True
			Else
				idsTODetail.SetItem(llNewDetailRow, 'Line_Item_No', dec(Trim(lsTemp)))
				// LTK 20110429 Pandora #205 - SOC Multiline Fix
				idsTODetail.SetItem(llNewDetailRow, 'User_Line_Item_No', dec(Trim(lsTemp)))
			End If
		
//Qty
			//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
			lsLogOut =  '      - Processing Qty: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			ldTemp = idsOMCSOCDeliveryDetail.GetItemNumber(ll_Row_Pos_Detail, 'ORIGINALQTY')
			idsTODetail.SetItem(llNewDetailRow, 'Quantity', ldTemp)
		Next /*Detail Recod*/

		//2017/07 TAM PINT-856 -Add successfully loaded orders into an Array -START
		If lbError = False Then
			ll_row =lds_om_receipt_list.insertrow( 0)	
			lds_om_receipt_list.setitem( ll_row, 'project_Id', asProject)
			lds_om_receipt_list.setitem( ll_row, 'change_req_no', ll_change_request_nbr)
			lds_om_receipt_list.setitem( ll_row, 'status_cd', 'C')
		End If
		//2017/07 TAM PINT-856 -Add successfully loaded orders into an Array - END
	
	Next /*Header Recod*/
	
	//Save the Changes 
	If lbError Then 
		Return -1
	Else
		//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem  - Note this should be only temporary
		lsLogOut = '      - Saving Header Record: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		
		lirc = idsTOHeader.Update()
		
		If liRC = 1 Then
			//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
			lsLogOut = '      - Saving Detail Record: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		
			liRC = idsTODetail.Update()
		End If
	End If
	
	If liRC = 1 then
		if len(lsDelete_List) > 0 then
			// Stirp of leading comma
			lsDelete_List =  right(lsDelete_List, len(lsDelete_List) - 1)
			DELETE FROM Transfer_Detail_Content  WHERE TO_No in  (:lsDelete_List)   USING sqlca;
			if sqlca.sqlcode<> 0 then
				ls_error_msg = "Change_Request_Nbr ="+string(ll_change_request_nbr)+" -Delete from Transfer_Detail_Content Failed. Record will not be processed."
				gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
				GOTO RollbackAll
			end if
			DELETE FROM Transfer_Detail  WHERE TO_No in  (:lsDelete_List)   USING sqlca;
			if sqlca.sqlcode<> 0 then
				ls_error_msg = "Change_Request_Nbr ="+string(ll_change_request_nbr)+" -Delete from Transfer_Detail Failed. Record will not be processed."
				gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
				GOTO RollbackAll
			end if
			DELETE FROM Transfer_Master  WHERE TO_No in  (:lsDelete_List)   USING sqlca;
			if sqlca.sqlcode<> 0  then
				ls_error_msg = "Change_Request_Nbr ="+string(ll_change_request_nbr)+" -Delete from Transfer_Master Failed. Record will not be processed."
				gu_nvo_process_files.uf_process_om_writeerror( asproject, 'E', ll_change_request_nbr,'OB', ls_error_msg)
				GOTO RollbackAll
			end if
		end if
		// 01/17/2010  ujh END Owner Change Fix 4 of 5
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
		Commit;

		//2017/07 TAM PINT-856 -Add successfully loaded orders into an Array -START
		If lds_om_receipt_list.rowcount( ) > 0  Then gu_nvo_process_files.uf_process_om_outbound_update( lds_om_receipt_list) 
		If lds_om_receipt_list.rowcount( ) > 0  Then uf_process_om_warehouse_order_oc( lds_om_receipt_list) 
		destroy lds_om_receipt_list
		//2017/07 TAM PINT-856 -Add successfully loaded orders into an Array - END
			
		if not lbSkipAutoSOC then
		//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
		lsLogOut = '      - Begin the Auto SOC Process: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// 0208/2010 ujh:  call to stored procedure for Auto Stock Owner Change  and DiskErase
		// After all processing is done, now go and see if any records can be auto completed.
		 lbSQLCAauto = SQLCA.AutoCommit
		SQLCA.AutoCommit = true  // Control of Transaction processing in Stored Procedure
	
		// Get the segments to send to the stored procedure if more than one was created when lsRecDataSOC was populated
		lsTemp2 = lsRecDataSOC
		String ls_test, ls_test2  //TimA for Testing results
		String ls_method_trace
		
		Do While len(lsTemp2) > 0
			lsTemp = Left(lsTemp2,(pos(lsTemp2,lsParamSeperator) -1))
			if len(lsTemp) = 0 then
				lsTemp = lsTemp2
			End if
			//TimA 06/13/12 Take off the | pipe
			ls_method_trace = Upper(Left(lsTemp,(pos(lsTemp,'|') - 1)))			
			lsTemp2 = Right(lsTemp2,(len(lsTemp2) - (Len(lsTemp) + Len(lsParamSeperator)))) /*strip off to next Segment */
			choose case upper(lsSOC_variant)
				case 'DISKERASE'
					lsLogOut = '      - Processing PANDORA Diskerase Auto SOC: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
					
				f_method_trace_special( asproject, this.ClassName() + ' - uf_process_om_soc', 'Start Sp_Auto_SOC_DiskErase Stored Procedure',lsToNo, isFileName,'',ls_method_trace)
				
				sqlca.Sp_Auto_SOC_DiskErase('O', lsTemp, lsReturnTxt, llReturnCode, llCntReceived, llCntIgnored, lsListIgnored, llCntProcessed, lsListProcessed)
				f_method_trace_special( asproject, this.ClassName() + ' - uf_process_om_soc', 'End Sp_Auto_SOC_DiskErase Stored Procedure' ,lsToNo, isFileName,'',ls_method_trace)				
				
				case else
					//Jxlim 07/07/2011 BRD #233 If a cycle count call cc auto soc sp  (This OCR created by SIMS with cycle count information)
					If  Trim(ls_ccno) > "" Then
						lsLogOut = '      - Start Auto SOC_CC Process: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
						FileWrite(giLogFileNo,lsLogOut)
						gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
						
						sqlca.Sp_Auto_SOC_CC('O', lsTemp, ls_ccno, ll_ccline, lsReturnTxt, llReturnCode, llCntReceived, llCntIgnored, lsListIgnored, llCntProcessed, lsListProcessed)
						
						//TimA Just for testing results remove later						
						ls_Test = 'O' + "," +  lsTemp + "," + ls_ccno + "," +  String(ll_ccline) + "," + String(llReturnCode) + "," +  String(llCntReceived) + "," +  String(llCntIgnored) + "," +  lsListIgnored + "," +  String(llCntProcessed) + "," +  lsListProcessed
					Else
					
						lsLogOut = '      - Start Auto SOC Process: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
						FileWrite(giLogFileNo,lsLogOut)
						gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
						f_method_trace_special( asproject, this.ClassName() + ' - uf_process_om_soc', 'Start Auto SOC Stored Procedure' ,lsToNo, isFileName,'',ls_method_trace)										
						//Aliased - the SP name is dbo.sp_auto_stockowner_change
						ls_Test = 'O' + "," +  lsTemp + "," + ls_ccno + "," +  String(ll_ccline) + "," + String(llReturnCode) + "," +  String(llCntReceived) + "," +  String(llCntIgnored) + "," +  lsListIgnored + "," +  String(llCntProcessed) + "," +  lsListProcessed						
						sqlca.Sp_Auto_SOC('O', lsTemp, lsReturnTxt, llReturnCode, llCntReceived, llCntIgnored, lsListIgnored, llCntProcessed, lsListProcessed)
						
						f_method_trace_special( asproject, this.ClassName() + ' - uf_process_om_soc', 'End Auto SOC Stored Procedure ' + lsReturnTxt + 'Return code ' + String(llReturnCode),lsToNo, isFileName,'',ls_method_trace)																
						
					End If
					//skipAUTOSOC:
			//end if
			End Choose
			
			If SQLCA.SQLCode = -1 Then
				f_method_trace_special( asproject, this.ClassName() + ' - uf_process_om_soc', 'SQL System Error Occured' ,lsToNo, isFileName,'',ls_method_trace)																
						
				lsLogOut = '      - SQL System Error Occured: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,lsLogOut + "  " + SQLCA.SqlerrText)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/			
				gu_nvo_process_files.uf_writeError("- ***System  Error!:   "+SQLCA.SqlerrText)  // ujhTODO  Get further requirements def.   "Some Database problem--likely only the type that will happen during development."
				Return -1
			ELSE
				choose case upper(lsSOC_variant)
					case 'DISKERASE'
						// Get Return Codes.  
						if llReturnCode < 0 Then
							f_method_trace_special( asproject, this.ClassName() + ' - uf_process_om_soc', 'Diskerase Auto SOC Failed' ,lsToNo, isFileName,'',ls_method_trace)																							
							//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
							lsLogOut = '      - Diskerase Auto SOC Failed: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
							FileWrite(giLogFileNo,lsLogOut)
							gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/										
							
							gu_nvo_process_files.uf_writeError("- ***Disk Erase Proccessing Error!:   "+ lsReturnTxt)  // ujhTODO  Not sure yet whether this will be exactly this way untill further requirements."
							Return -1
						end if
					Case Else
						if llReturnCode < 0 and (ldFromOwnerID = ldToOwnerID) Then
							f_method_trace_special( asproject, this.ClassName() + ' - uf_process_om_soc', 'Auto SOC Failed' ,lsToNo, isFileName,'',ls_method_trace)																														
							
							//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
							lsLogOut = '      - Auto SOC Failed: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
							FileWrite(giLogFileNo,lsLogOut)
							gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/										
							
							//TimA Remove ls_Test when done testing
							gu_nvo_process_files.uf_writeError("- ***Auto Complete SOC Failed!:   "+ lsReturnTxt + " -> " + ls_test)  
							Return -1
							
						ElseIf llReturnCode < 0 then
							lsLogOut = '      - Auto SOC Failed: '  + String(Today(), "mm/dd/yyyy hh:mm:ss") + ' No Error File Written.  Check the Method Trace Log'
							FileWrite(giLogFileNo,lsLogOut)
							gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/	
							
							//f_method_trace( asproject, this.ClassName() + ' - uf_process_om_soc', 'Auto SOC Failed for From Owner ID: ' + String(ldFromOwnerID) + ' and To Owner ID: ' + String(ldToOwnerID) ,ls_method_trace, isFileName)
							//TimA 03/04/13 Added new/modified method trace logic
							f_method_trace_special( asproject, this.ClassName() + ' - uf_process_om_soc', 'Auto SOC Failed for From Owner ID: ' + String(ldFromOwnerID) + ' and To Owner ID: ' + String(ldToOwnerID) ,lsToNo, isFileName,'',ls_method_trace)
						end if						
				End Choose
			End if
			Loop	
			SQLCA.AutoCommit = lbSQLCAauto  //Reset SQLCA's Transaction Processing
	
			f_method_trace_special( asproject, this.ClassName() + ' - uf_process_om_soc', 'Auto SOC Completed' ,lsToNo, isFileName,'',ls_method_trace)		
		end if	 
	Else
		// 01/17/2010  ujh Owner Change Fix  5 of 5:  need this label
		RollbackAll:
		Rollback;
		//f_method_trace( asproject, this.ClassName() + ' - uf_process_om_soc', 'System Error!  Unable to Save new TO Records to database!' ,ls_method_trace, isFileName)
		//TimA 03/04/13 Added new/modified method trace logic
		f_method_trace_special( asproject, this.ClassName() + ' - uf_process_om_soc', 'System Error!  Unable to Save new TO Records to database!' ,lsToNo, isFileName,'',ls_method_trace)			
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new TO Records to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new TO Records to database!")
		Return -1
	End If

End If //No Records to load

destroy idsOMQDelivery
destroy idsOMQDeliveryDetail
destroy idsOMCSOCDelivery
destroy idsOMCSOCDeliveryDetail


Return 0


end function

public function integer uf_process_om_warehouse_order_oc (readonly datastore adsorderlist);//JULY-2017 :TAM - Added for PINT - 940SOC  Confirmation.
//Write records back into OMQ Warehouse OrderTables.

String		lsFind,  lsLogOut, lsFromOwnerCD,  lsToOwnerCD,lsGroup,  lsWH, lsTransYN,lsToNo
String   	lsToProject, lsTransType, lsRemarks, lsFromProject, lsDetailFind, ls_line_no
string		lsInvoice,  lsSku, lsPrevSku, ls_client_id, lsSkipProcess
String 	ls_oracle_integrated, lsToLoc, lsSkipProcess2
String		ls_OM_Type, ls_OM_RecType, ls_status_cd

Decimal	 ldTransID
DateTime ldtTemp, ldtToday 
Long		llRowPos, llRowCount, llFindRow,	llNewRow, llNewDetailRow, ll_row,  ll_detail_row, ll_attr_row
Long 		ll_change_req_no, ll_serial_row, ll_rc, ll_batch_seq_no, ll_Inv_Row, llFromOwnerID, llFromOwnerID_Prev,  llToOwnerID, llToOwnerID_Prev
Boolean 	lbParmFound, lbAddHeader

DataStore ldsDOAddress

ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - OM 940 SOC Confirmation- Start Processing of uf_process_om_warehouse_order_oc: ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
select OM_Client_Id into :ls_client_id
from Project with(nolock)
where Project_Id= 'PANDORA'
using sqlca;

If Not isvalid(idsTOheader) Then
	idsTOheader = Create Datastore
	idsTOheader.Dataobject = 'd_transfer_master'
	idsTOheader.SetTransObject(SQLCA)
End If

If Not isvalid(idsTOdetail) Then
	idsTOdetail = Create Datastore
	idsTOdetail.Dataobject = 'd_transfer_Detail'
	idsTOdetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsOMQDelivery) Then
	idsOMQDelivery =Create u_ds_datastore
	idsOMQDelivery.Dataobject ='d_omq_warehouse_order'
	idsOMQDelivery.settransobject(om_sqlca)
End If

If Not isvalid(idsOMQDeliveryDetail) Then
	idsOMQDeliveryDetail =Create u_ds_datastore
	idsOMQDeliveryDetail.Dataobject ='d_omq_warehouse_order_detail'
	idsOMQDeliveryDetail.settransobject(om_sqlca)
End If

If Not isvalid(idsOMQDeliveryAttr) Then
	idsOMQDeliveryAttr =Create u_ds_datastore
	idsOMQDeliveryAttr.Dataobject ='d_omq_warehouse_order_attr'
	idsOMQDeliveryAttr.settransobject(om_sqlca)
End If


idsOMQDelivery.reset()
idsOMQDeliveryDetail.reset()
idsOMQDeliveryAttr.reset()

// ***** LOAD HEADER RECORDS *****
//Loop through Ref datastore to update OM tables.
For ll_row = 1 to adsorderlist.rowcount()
	ll_change_req_no = adsorderlist.getitemnumber(ll_row, 'change_req_no')
	ls_status_cd =adsorderlist.getitemstring(ll_row, 'status_cd')

	
	//Get DONO
	SELECT TO_No	INTO :lsToNo
	FROM Transfer_Master with(nolock)
	WHERE Project_Id = 'PANDORA'  and OM_CHANGE_REQUEST_NBR = :ll_change_req_no  ;

	//Retrieve the Receive Header, Detail and Putaway records for this order
	If idsTOheader.Retrieve(lstoNo) <> 1 Then
		lsLogOut = "                  *** Unable to retrieve Transfer Order Header For TONO: " + lstoNo
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

//	 TAM 2017/12/01 - Moved retrieve from below above - This was causing and error when multiple SOC orders were processed in the same sweeper run
	idsTOdetail.Retrieve(lsToNo)

	lsWH = idsTOheader.GetItemString(1, 'd_warehouse')

	//1. ADD OMQ_DELIVERY Tables
	llNewRow =	idsOMQDelivery.insertrow( 0)
		
	// 03-09 - Get the next available Trans_ID sequence number 
	ldTransID = gu_nvo_process_files.uf_get_next_seq_no('PANDORA', 'Transactions', 'Trans_ID')
	If ldTransID <= 0 Then Return -1

	
	idsOMQDelivery.setitem(llNewRow,'CHANGE_REQUEST_NBR',ll_change_req_no)
	idsOMQDelivery.setitem(llNewRow,'CLIENT_ID',ls_client_id)
	idsOMQDelivery.setitem(llNewRow, 'QACTION', 'I') //Action
	idsOMQDelivery.setitem(llNewRow, 'QSTATUS', 'NEW') //QStatus
	idsOMQDelivery.setitem(llNewRow, 'STATUS', '02') //Status
	idsOMQDelivery.setitem(llNewRow, 'QWMQID', ldTransID) //Set with TONO number
	idsOMQDelivery.setitem(llNewRow, 'ORDERKEY', Right(lsToNo,10)) //Receipt Key
	idsOMQDelivery.setitem(llNewRow, 'SITE_ID',  lsWh) //site id
	idsOMQDelivery.setitem(llNewRow, 'ADDDATE', ldtToday) //add_date
	idsOMQDelivery.setitem(llNewRow, 'ADDWHO', 'SIMSUSER') //add_who
	idsOMQDelivery.setitem( llNewRow, 'EDITDATE', ldtToday) //Edit Date
	idsOMQDelivery.setitem( llNewRow, 'EDITWHO', 'SIMSUSER') //Edit Who
	idsOMQDelivery.setitem( llNewRow, 'TYPE', 'SOC' ) //Type

	//Load Records from Transfer Master	
//	idsOMQDelivery.SetItem(llNewRow, 'ORDERGROUP', idsTOheader.GetItemString(1, 'User_Field7')) 
	idsOMQDelivery.setitem( llNewRow, 'EXTERNORDERKEY', idsTOheader.GetItemString(1, 'User_Field3')) 
//TAM 2017/12/07 - Changed mapping for Remark
//	idsOMQDelivery.setitem(1, 'TRANSPORTATIONSERVICE', trim(idsTOheader.GetItemString(1, 'Remark'))) //Consignee Key
	idsOMQDelivery.setitem(1, 'NOTES2', trim(idsTOheader.GetItemString(1, 'Remark'))) //Consignee Key
//	idsOMQDelivery.setitem(1, 'REFCHAR1', trim(idsTOheader.GetItemString(1, 'user_field4'))) //Requestor
//	idsOMQDelivery.setitem(1, 'REFCHAR2', trim(idsTOheader.GetItemString(1, 'user_field5'))) //Requestor Email

long temptono 
temptono =	idsOMQDelivery.getitemnumber(llNewrow, 'QWMQID')

	llToOwnerID= idsTOdetail.GetItemNumber(1,'New_Owner_Id')
	//  Owner ID
	if llTOOwnerID <> llToOwnerID_Prev then
		select owner_CD into :lsToOwnerCD
		from owner
		where project_id = 'PANDORA' and owner_id = :llToOwnerId;
		llToOwnerId_Prev = llToOwnerId
	end if

	idsOMQDelivery.SetItem(llNewRow, 'CONSIGNEEKEY' ,Left(Trim(lsToOwnerCd),10))
	idsOMQDelivery.SetItem(llNewRow, 'CLIENT_SHIPTO_ID' ,Trim(lsToOwnerCd))
	
	//Write to File and Screen
	lsLogOut = '      - OM Outbound 940SOC- Processed Header Record for To_No: ' + lsToNo +" and Change_Request_No: "+string(ll_change_req_no)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
	//Add OMQ Attribute for Ship From Contact Construct
	ll_attr_row =idsOMQDeliveryAttr.insertrow(0)
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'QACTION','I')
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'QWMQID',ldTransID)
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'ATTR_ID', 'SFC3')
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'ATTR_TYPE','ShipFromContact') 
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'CLIENT_ID', long(ls_client_id))
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'SITE_ID', lsWH)
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'ORDERKEY', Right(lstono, 10))
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'REFCHAR1', trim(idsTOheader.GetItemString(1, 'user_field4')))
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'REFCHAR2', trim(idsTOheader.GetItemString(1, 'user_field5')))
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
	idsOMQDeliveryAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')

	
	
	//2. ADD OMQ_RECEIPTDETAIL Tables
//	 TAM 2017/12/01 - Moved retrieve up above - This was causing and error when multiple SOC orders were processed in the same sweeper run
//	idsTOdetail.Retrieve(lsToNo)

//Loop through Ref datastore to update OM tables.
	For ll_detail_row = 1 to idsTOdetail.rowcount()
		llNewDetailRow = idsOMQDeliveryDetail.insertrow( 0)

		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'CHANGE_REQUEST_NBR', ll_change_req_no) //change_request_no
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'CLIENT_ID', ls_client_id) //client_Id
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'QACTION', 'I') //Action
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'QSTATUS', 'NEW') //QStatus
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'STATUS', '02') //Status
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'QWMQID', ldTransID) //Set with ToNo
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'ORDERKEY', Right(lsToNo,10)) //Receipt Key
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'SITE_ID',  lsWh) //site id
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'ADDDATE', ldtToday) //add_date
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'ADDWHO', 'SIMSUSER') //add_who
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'EDITDATE', ldtToday) //Edit Date
		idsOMQDeliveryDetail.setitem( llNewDetailRow, 'EDITWHO', 'SIMSUSER') //Edit Who

		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'ITEM', Trim(idsTOdetail.GetItemString(ll_detail_row, 'sku'))) 
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'EXTERNLINENO', String (idsTOdetail.GetItemNumber(ll_detail_row,'line_item_no'))) 
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'ORDERLINENUMBER', String (idsTOdetail.GetItemNumber(ll_detail_row,'line_item_no'),'00000')) 
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'EXTERNORDERKEY',  idsTOheader.GetItemString(1, 'User_Field3')) 
		idsOMQDeliveryDetail.SetItem(llNewDetailRow, 'ORIGINALQTY',idsTOdetail.GetItemNumber(ll_detail_row, 'Quantity')) 
		idsOMQDeliveryDetail.SetItem(llNewDetailRow,'LOTTABLE03', Trim(idsTOdetail.GetItemString(ll_detail_row, 'Po_No')))
		idsOMQDeliveryDetail.SetItem(llNewDetailRow,'SUSR1', Trim(idsTOdetail.GetItemString(ll_detail_row, 'New_Po_No')))

		llFromOwnerID= idsTOdetail.GetItemNumber(ll_detail_row,'Owner_Id')
		//  Owner ID
		if llFromOwnerID <> llFromOwnerID_Prev then
			select owner_CD into :lsFromOwnerCD
			from owner
			where project_id = 'PANDORA' and owner_id = :llFromOwnerId;
			llFromOwnerId_Prev = llFromOwnerId
		end if
		idsOMQDeliveryDetail.SetItem(llNewDetailRow,'LOTTABLE01', Trim(lsFromOwnerCd))
	
		//Write to File and Screen
		lsLogOut = '      - OM Outbound 940SOC Confirmation- Processing Detail Record for To_No: ' + lsToNo +" and Change_Request_No: "+string(ll_change_req_no) +" and Line_Item_No: "+ String(idsTOdetail.GetItemNumber(ll_detail_row,'line_item_no'))
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
	next /*next detail record */
	
next /*next header record */

//storing into DB
//Execute Immediate "Begin Transaction" using om_sqlca;  4/2020 - MikeA - DE15499
If idsOMQDeliveryDetail.rowcount( ) > 0 Then 	ll_rc =idsOMQDeliveryDetail.update( false, false);
If idsOMQDeliveryAttr.rowcount( ) > 0 Then 	ll_rc =idsOMQDeliveryAttr.update( false, false);
If idsOMQDelivery.rowcount( ) > 0 and ll_rc =1 Then ll_rc =idsOMQDelivery.update( false, false);

If ll_rc =1 Then
	//Execute Immediate "COMMIT" using om_sqlca; 4/2020 - MikeA - DE15499
     commit using sqlca;
	  
	if om_sqlca.sqlcode = 0 then
		idsOMQDelivery.resetupdate( )
		idsOMQDeliveryDetail.resetupdate( )
		idsOMQDeliveryAttr.resetupdate( )
	else
		//Execute Immediate "ROLLBACK" using om_sqlca;  4/2020 - MikeA - DE15499
		rollback using sqlca;
		
		idsOMQDelivery.reset( )
		idsOMQDeliveryDetail.reset( )
		idsOMQDeliveryAttr.reset( )
		//Write to Log File and Screen
		lsLogOut = "      - OM Outbound 940 SOC- Unable to Insert records for SOC .!~r~r" + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)

		Return -1
	end if

else
	//Execute Immediate "ROLLBACK" using om_sqlca;  4/2020 - MikeA - DE15499
	rollback using sqlca;
	
	//Write to Log File and Screen
	lsLogOut = "      - OM Outbound 940 SOC- System error, record save failed! .!~r~r" + om_sqlca.SQLErrText
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	Return -1
End If

destroy idsOMQDelivery
destroy idsOMQDeliveryDetail
destroy idsOMQDeliveryAttr
// TAM 2017/12/01 = Need to destro these object to prevent memory problems
destroy idsTOheader 
destroy idsTOdetail 

//Write to File and Screen
lsLogOut = '      - OM 940 SOC Confirmation- End Processing of uf_process_om_warehouse_order_oc: ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function integer uf_process_om_inbound_acknowledge (string asproject, string asrono, string asaction);//05-SEP-2017 :Madhu - Added for PINT-856 - Goods Receipt Acknowledgement.
//Write records back into OMQ Tables.

String		lsFind,  lsLogOut, lsOwnerCD, lsGroup, lsWH
string		ls_client_id, lsSkipProcess
String 	lsToLoc, lsSkipProcess2
String		ls_OM_Type, lsOrderNo

Decimal	 ldOwnerID, ldOwnerID_Prev, ldTransID
DateTime ldtTemp, ldtToday
Long		llRowPos, llRowCount, llFindRow,	ll_detail_row
Long 		ll_change_req_no, ll_rc, ll_batch_seq_no, ll_orig_batch_seq_no

ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - OM Inbound Acknowledge- Start Processing of uf_process_om_inbound_acknowledge() for Ro_No: ' + asrono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

lsSkipProcess2 = f_functionality_manager(asProject,'FLAG','SWEEPER','UNIQUETRXID','','')

select User_Updateable_Ind
	into :lsSkipProcess
from lookup_table with(nolock)
where project_id = 'PANDORA'
and code_type = 'SKIP_PROCESS'
and code_ID = 'Shipment_Distribution_No'
using sqlca;

select OM_Client_Id into :ls_client_id
from Project with(nolock)
where Project_Id= :asproject
using sqlca;


If Not isvalid(idsROMain) Then
	idsROMain = Create Datastore
	idsROMain.Dataobject = 'd_ro_master'
	idsROMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsRODetail) Then
	idsRODetail = Create Datastore
	idsRODetail.Dataobject = 'd_ro_Detail'
	idsRODetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsOMQROMain) Then
	idsOMQROMain =Create u_ds_datastore
	idsOMQROMain.Dataobject ='d_omq_receipt'
	idsOMQROMain.settransobject(om_sqlca)
End If

If Not isvalid(idsOMQRODetail) Then
	idsOMQRODetail =Create u_ds_datastore
	idsOMQRODetail.Dataobject ='d_omq_receipt_detail'
	idsOMQRODetail.settransobject(om_sqlca)
End If

If Not isvalid(idsOMExp) Then
	idsOMExp =Create u_ds_datastore
	idsOMExp.Dataobject ='d_om_expansion'
	idsOMExp.settransobject(SQLCA)
End If	

idsOMQROMain.reset()
idsOMQRODetail.reset()
idsOMExp.reset()

//Write to File and Screen
lsLogOut = "    OM Inbound Acknowledge - Creating Inventory Transaction (GR) For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Retrieve the Receive Header, Detail and Putaway records for this order
If idsROMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retrieve Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsToLoc = idsROMain.GetItemString(1,'User_field2')
If Not isnull(lsToLoc) Then
	select user_field1 into :lsGroup
	from customer with(nolock)
	where project_id = :asProject and cust_code = :lsToLoc;
	
	If Upper(lsGroup) = 'S-OWND-MIM' Then
		lsLogOut = "     GR Suppressed for MIM Owned-Inventory transaction For RO_NO: " + asRONO + ". No GR is being created for this order."
		FileWrite(gilogFileNo, lsLogOut)
		Return 0
	End IF
End IF

lsWH = idsROMain.GetItemString(1, 'wh_code')
ll_change_req_no = idsROMain.getitemnumber(1,'OM_Change_request_nbr')
ll_batch_seq_no =idsROMain.getitemnumber(1,'EDI_Batch_Seq_No')

llRowCount = idsRODetail.Retrieve(asRONO) //Get Detail count

idsOMExp.retrieve(ll_batch_seq_no) //Retrieve OM_Expansion_Table records

//Get values of TYPE and RECEIPT_TYPE
lsFind ="Column_Name ='TYPE'"
llFindRow =idsOMExp.find(lsFind,1,idsOMExp.rowcount())

// 08/29/17 - PCONKL - Deal with missing expansion records...
//								If expansion records missing, retrieve for the original order, mif still missing, default to blank

If llFindRow > 0 Then
	ls_OM_Type =idsOMExp.getitemstring(llFindRow,'Column_value')
Else /* get from original order*/

	lsorderNo = trim(idsROMain.GetItemString(1, 'supp_invoice_no'))
	
	Select min(edi_batch_seq_no) into :ll_orig_batch_seq_no
	From Receive_master with(nolock)
	Where Project_id = 'PANDORA' and supp_invoice_no = :lsOrderNo;
	
	If ll_orig_batch_seq_no > 0 Then
		idsOMExp.retrieve(ll_orig_batch_seq_no) //Retrieve OM_Expansion_Table records from original order
		llFindRow =idsOMExp.find(lsFind,1,idsOMExp.rowcount())
		If llFindRow > 0 Then
			ls_OM_Type =idsOMExp.getitemstring(llFindRow,'Column_value')
		Else
			ls_OM_Type = ""
		End If
	Else
		ls_OM_Type = ""
	End If
End If


// 03-09 - Get the next available Trans_ID sequence number 
ldTransID = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'Transactions', 'Trans_ID')
If ldTransID <= 0 Then Return -1

//Write the rows to respective OMQ Tables
//1. ADD OMQ_RECEIPT Tables
idsOMQROMain.insertrow( 0)
//ldtTemp = idsROMain.GetItemDateTime(1, 'complete_date')
ldtTemp = GetPacificTime(lsWH, ldtToday)

idsOMQROMain.setitem(1,'CHANGE_REQUEST_NBR',ll_change_req_no)
idsOMQROMain.setitem(1,'CLIENT_ID',ls_client_id)
idsOMQROMain.setitem(1, 'QACTION', asaction) //Action
idsOMQROMain.setitem(1, 'QSTATUS', 'NEW') //QStatus
idsOMQROMain.setitem(1, 'QWMQID', ldTransID) //Next Transaction Id
idsOMQROMain.setitem(1, 'RECEIPTKEY', 'XXX' +Right(asrono,7)) //Receipt Key
idsOMQROMain.setitem(1, 'SITE_ID', lsWH) //site id
idsOMQROMain.setitem(1, 'STATUS', 'NOTRECVD') //Status

idsOMQROMain.setitem( 1, 'EXTERNRECEIPTKEY', idsROMain.GetItemString(1, 'Client_Cust_PO_NBR' )) //client_cust_po_nbr
idsOMQROMain.setitem( 1, 'EXTERNALRECEIPTKEY2', idsROMain.GetItemString(1, 'supp_invoice_no')) //supp_invoice_no
idsOMQROMain.setitem( 1, 'RECEIPTDATE', ldtTemp) //trans_date
idsOMQROMain.setitem( 1, 'REFCHAR1', idsROMain.GetItemString(1, 'user_field12')) //UF12

//TAM 10/27/2017 - Change per Dave		
//idsOMQROMain.setitem( 1, 'VENDORID', idsROMain.GetItemString(1, 'user_field6')) //UF6
idsOMQROMain.setitem( 1, 'VENDORID', Left(idsROMain.GetItemString(1, 'user_field6'),10)) //UF6
idsOMQROMain.setitem( 1, 'PLACE_OF_DISCHARGE', idsROMain.GetItemString(1, 'user_field6')) //UF6
idsOMQROMain.setitem( 1, 'TYPE', ls_OM_Type) //Type

idsOMQROMain.setitem( 1, 'SUSR2', idsROMain.GetItemString(1, 'Vendor_Invoice_Nbr' )) //Vendor Invoice Nbr
idsOMQROMain.setitem( 1, 'SUSR1',  idsROMain.GetItemString(1, 'awb_bol_no')) 	//Awb Bol No

idsOMQROMain.setitem( 1, 'ADDDATE', today()) //add_date
idsOMQROMain.setitem( 1, 'ADDWHO', 'SIMSUSER') //add_who
idsOMQROMain.setitem( 1, 'EDITDATE',today())
idsOMQROMain.setitem( 1, 'EDITWHO', 'SIMSUSER')


//Write to File and Screen
lsLogOut = '      - OM Inbound Acknowledge- Processing Header Record for Ro_No: ' + asrono +" and Change_Request_No: "+string(ll_change_req_no)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//2. ADD OMQ_RECEIPTDETAIL Tables
//Roll Up Detail records for same attribute values.
For llRowPos = 1 to llRowCount

	ll_detail_row = idsOMQRODetail.insertrow( 0)
	idsOMQRODetail.setitem( ll_detail_row, 'CHANGE_REQUEST_NBR', ll_change_req_no) //change_request_no
	idsOMQRODetail.setitem( ll_detail_row, 'CLIENT_ID', ls_client_id) //client_Id
	idsOMQRODetail.setitem( ll_detail_row, 'QACTION', asaction) //Action
	idsOMQRODetail.setitem( ll_detail_row, 'QSTATUS', 'NEW') //QStatus
	idsOMQRODetail.setitem( ll_detail_row, 'QWMQID', ldTransID) //Set with Batch_Transaction.Trans_Id
	idsOMQRODetail.setitem( ll_detail_row, 'RECEIPTKEY', 'XXX'+Right(asrono,7)) //Receipt Key
	idsOMQRODetail.setitem( ll_detail_row, 'SITE_ID', lsWH) //site id
	idsOMQRODetail.setitem( ll_detail_row, 'STATUS', 'NOTRECVD') //Status
	
	ldOwnerID = idsRODetail.GetItemNumber(llRowPos, 'owner_id')
	
	if ldOwnerID <> ldOwnerID_Prev then
		select owner_cd into :lsOwnerCD
		from owner with(nolock)
		where project_id = :asproject and owner_id = :ldOwnerID
		using sqlca;
		
		ldOwnerID_Prev = ldOwnerID
	end if
	
	idsOMQRODetail.setitem( ll_detail_row, 'EXTERNRECEIPTKEY', idsROMain.GetItemString(1, 'Client_Cust_PO_NBR' )) //client_cust_po_nbr
	idsOMQRODetail.setitem( ll_detail_row, 'EXTERNLINENO', string(idsRODetail.GetItemNumber(llRowPos, 'line_item_no'))) //user_line_item_no
	idsOMQRODetail.setitem( ll_detail_row, 'ITEM', upper(idsRODetail.GetItemString(llRowPos, 'sku'))) //sku
	idsOMQRODetail.setitem( ll_detail_row, 'LOTTABLE01', upper(trim(lsOwnerCD))) //to_location
	idsOMQRODetail.setitem( ll_detail_row, 'LOTTABLE07', upper(idsRODetail.GetItemString(llRowPos, 'country_of_origin'))) //COO
	idsOMQRODetail.setitem( ll_detail_row, 'QTYEXPECTED', idsRODetail.GetItemNumber(llRowPos,'req_qty')) //QTY
	idsOMQRODetail.setitem( ll_detail_row, 'SUSR1', trim(idsRODetail.GetItemString(llRowPos, 'user_field2'))) //From Project -UF2
	idsOMQRODetail.setitem( ll_detail_row, 'RECEIPTLINENUMBER', Right(string(idsRODetail.GetItemNumber(llRowPos, 'line_item_no')),5)) //Receipt Line Nbr
	idsOMQRODetail.setitem( ll_detail_row, 'UOM', 'EA') //UOM
	idsOMQRODetail.setitem( ll_detail_row, 'ADDDATE', Date(today())) //add_date
	idsOMQRODetail.setitem( ll_detail_row, 'ADDWHO', 'SIMSUSER') //add_who
	idsOMQRODetail.setitem( ll_detail_row, 'EDITDATE',today())
	idsOMQRODetail.setitem( ll_detail_row, 'EDITWHO', 'SIMSUSER')
	
	//Write to File and Screen
	lsLogOut = '      - OM Inbound Acknowledge- Processing Detail Record for Ro_No: ' + asrono +" and Change_Request_No: "+string(ll_change_req_no) +" and Line_Item_No: "+string(idsRODetail.GetItemNumber(llRowPos, 'line_item_no'))
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

next /*next output record */

idsOMQROMain.setitem( 1, 'LINECOUNT',   idsOMQRODetail.rowcount()) 	//Line Count - Set Detail Record count

//storing into DB
//Execute Immediate "Begin Transaction" using om_sqlca; 4/2020 - MikeA - DE15499
If idsOMQROMain.rowcount( ) > 0 Then	ll_rc =idsOMQROMain.update( false, false);
If idsOMQRODetail.rowcount( ) > 0 and ll_rc =1 Then 	ll_rc =idsOMQRODetail.update( false, false);

If ll_rc =1 Then
	//Execute Immediate "COMMIT" using om_sqlca; 4/2020 - MikeA - DE15499
	commit using om_sqlca;
	
	if om_sqlca.sqlcode = 0 then
		idsOMQROMain.resetupdate( )
		idsOMQRODetail.resetupdate( )
	else
		//Execute Immediate "ROLLBACK" using om_sqlca; 4/2020 - MikeA - DE15499
		rollback using om_sqlca;
		idsOMQROMain.reset( )
		idsOMQRODetail.reset( )
		
		//Write to File and Screen
		lsLogOut = '      - OM Inbound Acknowledge- Error Processing of uf_process_om_inbound_acknowledge() for Ro_No: ' + asrono+" Error: "+om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		
		//MessageBox("ERROR", om_sqlca.SQLErrText)
		Return -1
	end if

else
	//Execute Immediate "ROLLBACK" using om_sqlca;
	rollback using om_sqlca;
	//Write to File and Screen
	lsLogOut = '      - OM Inbound Acknowledge- Error Processing of uf_process_om_inbound_acknowledge() for Ro_No: ' + asrono+" Error: "+om_sqlca.SQLErrText +" Record sav failed"
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	//MessageBox("ERROR", "System error, record save failed!")
	Return -1
End If

destroy idsOMQROMain
destroy idsOMQRODetail

//Write to File and Screen
lsLogOut = '      - OM Inbound Acknowledge- End Processing of uf_process_om_inbound_acknowledge() for Ro_No: ' + asrono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function datetime getesd (string aswhcode, datetime adtwhtime, datetime adtrdd, string asmimorder, string ascarrier, string ascust);//GailM 0712/2017 SIMSPEVS-728 Defect: Current ESD logic does not include Weekend cutoff date
//GailM 08/08/2017 SIMSPEVS-537 - SIMS to provide advance ESD cutoff configuration via GUI  Cut_Off_Time
// This function and logic will also be in SIMS function f_delivery_advance_esd_configurarion
// Checking for Wh Code is not necessary since query for idsESDConfig contains only the WH sent
// Begin testing 10/5/2017 for 17-11 release
// Replaced this function with external function f_delivery_advance_esd_configurationfor
datetime ldtESD

return ldtESD

//GailM 08/08/2017 SIMSPEVS-537 - Enhance the ESD schedule date with below table business rules:
/*  These are the rules as of 8/8/2017.  Coding above will reflect these rules
______________________________________________________________________________________________________
Warehouse		Carrier		MIM order	To Customer Code		Cutoff Time									Notes
______________________________________________________________________________________________________
*all				*all			*all			*all						2:00pm										Default for All
PND_AMSTER	*all			*all			*all						10:00am										Default for AMSTER
PND_ATLSKY	*all			*all			*all						1:00pm										Default for ATLSKY
PND_BRUSSH	*all			*all			*all						3:00pm										Default for BRUSSH
PND_AMSTER	Vendor Paid	*all			*all						12:00pm										Rule 3 From Rule ESD Rules
PND_AMSTER	*all			Yes			*all						if RDD Same Day use Cutoff time,		Rule 4 From Rule ESD Rules
																					 otherwise use RDD
PND_AMSTER	FedEx		*all			*all						11:00am										Rule 1 From Rule ESD Rules
PND_AMSTER	UPS			*all			*all						1:00pm										Rule 1 From Rule ESD Rules
PND_AMSTER	Expeditors	*all			*all						use default cutoff							?
PND_AMSTER	Expeditors	*all			some value				11:59am										Rule 2 From Rule ESD Rules
PND_AMSTER	Expeditors	*all			some other value		1:59am										Rule 2 From Rule ESD Rules
PND_AMSTER	FedEx		Yes			*all						if RDD Same Day use Cutoff time, 	?
																					otherwise use RDD
PND_AMSTER	Vendor Paid	Yes			*all						if RDD Same Day use Cutoff time,		?
																					otherwise use RDD
_____________________________________________________________________________________________________*/


end function

public function integer uf_process_load_plan (string aspath, string asproject);//06-AUG-2018 :Madhu S21850 - Process Load Plan Detail.

string	lsLogOut, lsTemp, ls_line_count, ls_trans_type, ls_load_Id, ls_customer_order
string ls_wh_code, ls_prev_wh_code, ls_carrier, ls_prev_carrier
string lsStringData, ls_Type, ls_transaction_time_stamp

long	ll_FileRowPos, ll_FileRowCount, ll_EDI_Load_Plan_Id, ll_New_Row
long 	ll_wh_count, ll_carrier_count, ll_row, ll_FindRow, ll_RC, ll_FileNo, ll_length

boolean	lbError
DateTime ldt_transaction_time

Str_Parms lstr_Parms

u_ds_datastore	 ldsImport, ldsLoadPlan

//create datastores
ldsImport = create u_ds_datastore
ldsImport.dataobject = 'd_generic_import'

ldsLoadPlan = create u_ds_datastore
ldsLoadPlan.dataobject ='d_import_load_plan'
ldsLoadPlan.settransobject( SQLCA)

//Open and read the File In
lsLogOut = '      - Opening File for Load Plan Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

ll_FileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If ll_FileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Load Plan Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
ll_RC = FileRead(ll_FileNo, lsStringData)

Do While ll_RC > 0
	ll_New_Row = ldsImport.InsertRow(0)
	ldsImport.SetItem(ll_New_Row,'rec_data',lsStringData) /*record data is the rest*/
	ll_RC = FileRead(ll_FileNo,lsStringData)
Loop /*Next File record*/

//close file
FileClose(ll_FileNo)

//read the data from Datastore
ll_FileRowCount = ldsImport.RowCount()

For ll_FileRowPos = 1 to ll_FileRowCount
	
	w_main.SetMicroHelp("Processing Load Plan Record " + String(ll_FileRowPos) + " of " + String(ll_FileRowCount))
	
	ls_line_count = Left(trim(ldsImport.GetItemString(ll_FileRowPos,'rec_Data')),10) //1. Line Count
	ls_Type = trim(Mid(ldsImport.GetItemString(ll_FileRowPos,'rec_data'),11, 2)) //2. Record Type
	
	ll_length = Len(ldsImport.GetItemString(ll_FileRowPos, 'rec_data'))
	IF  (ll_length < 541  or ll_length > 541) and upper(ls_Type) ='LP' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(ll_FileRowPos) + " - Record length error. is:" + string(ll_length) + ", Should be: 531. LP Record will not be processed.")
		lbError = True
		Continue /*Next record */
	End IF
	
	IF NOT (ls_Type = 'LP' OR ls_Type = 'TR' ) Then
		gu_nvo_process_files.uf_writeError("Row: " + string(ll_FileRowPos) + " - Invalid Record Type: '" + ls_Type + "'. Record will not be processed.")
		lbError = True
	End IF
		
	IF NOT (ls_Type = 'LP' OR ls_Type = 'TR' ) Then
		gu_nvo_process_files.uf_writeError("Row: " + string(ll_FileRowPos) + " - Invalid Record Type: '" + ls_Type + "'. Record will not be processed.")
		lbError = True
	End IF
		
	CHOOSE Case Upper(ls_Type)
	
		Case 'LP' 
		
			ll_EDI_Load_Plan_Id = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Load_Plan', 'EDI_Load_Plan_Id')
			If ll_EDI_Load_Plan_Id <= 0 Then Return -1
		
			//Insert record into EDI_Load_Plan table
			ll_New_Row = ldsLoadPlan.insertrow( 0)
			ldsLoadPlan.setItem( ll_New_Row, 'Project_Id', asproject)
			ldsLoadPlan.setItem( ll_New_Row, 'EDI_Load_Plan_Id',  ll_EDI_Load_Plan_Id)
			ldsLoadPlan.setItem( ll_New_Row, 'FTP_File_Name', aspath)
			ldsLoadPlan.setItem( ll_New_Row, 'Rec_Id', upper(ls_Type))
			ldsLoadPlan.setItem( ll_New_Row, 'Status_Cd', 'N')
			
			//Line count validation
			If IsNull(ls_line_count) OR trim(ls_line_count) = '' Then
				lsLogOut="Row: " + string(ll_FileRowPos) + " - Line Count is required. Record will not be processed."
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				
				lbError = True
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Cd', 'E')
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Message', 'Line Count is required')
				Continue
			Else
				ldsLoadPlan.setItem( ll_New_Row, 'Line_Count', ls_line_count)
			End If	

			//3. Transaction Type
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),13,1))
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		
				lsLogOut="Row: " + string(ll_FileRowPos) + " - Transaction Type is required. Record will not be processed."
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				
				lbError = True
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Cd', 'E')
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Message', 'Transaction Type is required')
				Continue		
			Else
				ls_trans_type = lsTemp
			End If

			ldsLoadPlan.setItem( ll_New_Row, 'Transaction_Type', ls_trans_type)
			
			//4. Warehouse
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),14,10))
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		
				lsLogOut="Row: " + string(ll_FileRowPos) + " - Warehouse is required. Record will not be processed."
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				
				lbError = True
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Cd', 'E')
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Message', 'Warehouse is required')
				Continue		
			Else
				ls_wh_code = lsTemp
			End If
			
			//validate warehouse code
			If ls_prev_wh_code <> ls_wh_code Then
				select count(*) into :ll_wh_count from Warehouse with(nolock)
				where wh_code =:ls_wh_code
				using SQLCA;
			End If
			
			If ll_wh_count = 0 Then
				lsLogOut="Row: " + string(ll_FileRowPos) + " - Invalid Warehouse Code . Record will not be processed."
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				
				lbError = True
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Cd', 'E')
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Message', 'Warehouse does not exist in SIMS')
				
				Continue
			End If
			
			ldsLoadPlan.setItem( ll_New_Row, 'wh_code', ls_wh_code)
			ls_prev_wh_code = ls_wh_code

			//5. Load Id
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),24,12))
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				lsLogOut="Row: " + string(ll_FileRowPos) + " - Load Id is required. Record will not be processed."
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				
				lbError = True
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Cd', 'E')
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Message', 'Load Id is required')
				Continue		
			else
				ls_load_Id = lsTemp
			End If
			
			ldsLoadPlan.setItem( ll_New_Row, 'Load_Id', ls_load_Id)
				
			//6. Update Date Time
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),36,14))
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				ldsLoadPlan.setItem( ll_New_Row, 'Update_Date_Time', lsTemp)					
			else
				ldsLoadPlan.setItem( ll_New_Row, 'Update_Date_Time', this.convert_string_to_datetime(lsTemp))
			End If

			//7. Customer Order
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),50,30))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				lsLogOut="Row: " + string(ll_FileRowPos) + " - Customer Order is required. Record will not be processed."
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Cd', 'E')
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Message', 'Customer Order is required')
				lbError = True
				Continue		
			Else
				ls_customer_order =lsTemp
			End If

			ldsLoadPlan.setItem( ll_New_Row, 'Customer_Order', ls_customer_order)
		
			//8. Shipment Id
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),80,20))
			ldsLoadPlan.setItem( ll_New_Row, 'Shipment_Id', lsTemp)
			
			//9. Master BOL
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),100,20))
			ldsLoadPlan.setItem( ll_New_Row, 'Master_BOL', lsTemp)
			
			//10.Child BOL
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),120,20))
			ldsLoadPlan.setItem( ll_New_Row, 'Child_BOL', lsTemp)
			
			//11. Carrier
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),140,15))
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				lsLogOut="Row: " + string(ll_FileRowPos) + " - Carrier Id is required. Record will not be processed."
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				
				lbError = True
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Cd', 'E')
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Message', 'Carrier Id is required')
				Continue		
			Else
				ls_carrier = lsTemp
			End If
		
			//validate carrier code
			If ls_prev_carrier <> ls_carrier Then
				select count(*) into :ll_carrier_count from Carrier_Master with(nolock)
				where Project_Id =:asproject and Carrier_Code =:ls_carrier
				using SQLCA;
			End If
		
			If ll_carrier_count =0 Then
				lsLogOut="Row: " + string(ll_FileRowPos) + " - Invalid Carrier Id!. Record will not be processed."
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				
				lbError = True
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Cd', 'E')
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Message', 'Carrier Id does not exist in SIMS')
				Continue
			End If
		
			ldsLoadPlan.setItem( ll_New_Row, 'Carrier_Id', ls_carrier)
			ls_prev_carrier = ls_carrier
		
			//12. Tracking Number
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),155,20))
			ldsLoadPlan.setItem( ll_New_Row, 'Tracking_Number', lsTemp)
			
			//13. Tracking Number Type
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),175,3))
			ldsLoadPlan.setItem( ll_New_Row, 'Tracking_Number_Type', lsTemp)

			//14. Pick Up Stop
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),178,10))
			If Not isnumber(lsTemp) OR IsNull(lsTemp) OR trim(lsTemp) = '' Then
				lsTemp = "0"
				lsLogOut="Row: " + string(ll_FileRowPos) + " - Pick Up Stop is not numeric. It has been set to: " + nz(lsTemp, '-')
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			End If
			
			ldsLoadPlan.setItem( ll_New_Row, 'Pick_Up_Stop', dec(lsTemp))
				
			//15. Delivery Stop
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),188,10))
			If Not isnumber(lsTemp) Then
				lsTemp = "0"				
				lsLogOut="Row: " + string(ll_FileRowPos) + " - Delivery Stop is not numeric. It has been set to: " + lsTemp
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			End If
			
			ldsLoadPlan.setItem( ll_New_Row, 'Delivery_Stop', dec(lsTemp))
			
			//16. Loading Sequence
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),198,10))
			If Not isnumber(lsTemp) Then
				lsTemp = "0"				
				lsLogOut="Row: " + string(ll_FileRowPos) + " - Loading Sequence is not numeric. It has been set to: " + lsTemp
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			End If

			ldsLoadPlan.setItem( ll_New_Row, 'Load_Sequence', dec(lsTemp))
			
			//17. Load Start Date Time
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),208,14))
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				ldsLoadPlan.setItem( ll_New_Row, 'Load_Start_Date_Time', lsTemp)
			else
				ldsLoadPlan.setItem( ll_New_Row, 'Load_Start_Date_Time', this.convert_string_to_datetime(lsTemp))
			End If

			//18. Load End Time
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),222,14))
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				ldsLoadPlan.setItem( ll_New_Row, 'Load_End_Date_Time', lsTemp)
			else
				ldsLoadPlan.setItem( ll_New_Row, 'Load_End_Date_Time', this.convert_string_to_datetime(lsTemp))
			End If

			//19. Ready By Date Time
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),236,14))
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				ldsLoadPlan.setItem( ll_New_Row, 'Ready_By_Date_Time',  lsTemp)
			else
				ldsLoadPlan.setItem( ll_New_Row, 'Ready_By_Date_Time',  this.convert_string_to_datetime(lsTemp))
			End If

			//20. Terminal Arrival Date Time
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),250,14))
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				ldsLoadPlan.setItem( ll_New_Row, 'Terminal_Arrival_Date_Time', lsTemp)
			else
				ldsLoadPlan.setItem( ll_New_Row, 'Terminal_Arrival_Date_Time', this.convert_string_to_datetime(lsTemp))
			End If				

			//21. Terminal Depart Date Time
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),264,14))
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				ldsLoadPlan.setItem( ll_New_Row, 'Terminal_Depart_Date_Time', lsTemp)
			else
				ldsLoadPlan.setItem( ll_New_Row, 'Terminal_Depart_Date_Time', this.convert_string_to_datetime(lsTemp))
			End If

			//22. Equipment Code
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),278,80))
			ldsLoadPlan.setItem( ll_New_Row, 'Equipment_Code', lsTemp)

			//23. Trailer Number
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),358,80))
			ldsLoadPlan.setItem( ll_New_Row, 'Trailer_Number', lsTemp)

			//24. Pandora Trans Id
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),438,80))
			ldsLoadPlan.setItem( ll_New_Row, 'Pandora_Trans_Id', lsTemp)

			//25. Transaction Time Stamp
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),518,14))
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				ldsLoadPlan.setItem( ll_New_Row, 'Transaction_Time_Stamp', lsTemp)
			else
				ldt_transaction_time = this.convert_string_to_datetime(lsTemp)
				ldsLoadPlan.setItem( ll_New_Row, 'Transaction_Time_Stamp', ldt_transaction_time)
			End If

			//26. Logistic Service Requirement Code
			lsTemp = trim(Mid(ldsImport.getItemString( ll_FileRowPos, 'rec_data'),532,10))
			ldsLoadPlan.setItem( ll_New_Row, 'Logistic_Service_Requirement_Code', lsTemp)

			IF lbError = False Then
				//Load Plan Rejection Process
				lstr_Parms = this.uf_process_load_plan_rejection( asproject, ls_wh_code, ls_trans_type, ls_load_Id, ls_customer_order, ldt_transaction_time)
				
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Cd', lstr_Parms.string_arg[1])
				ldsLoadPlan.setItem( ll_New_Row, 'Status_Message', lstr_Parms.string_arg[2])
				
				IF lstr_Parms.string_arg[1] ='E' Then 
					lsLogOut="Row: " + string(ll_FileRowPos) + " - " +lstr_Parms.string_arg[2]
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
					gu_nvo_process_files.uf_writeError(lsLogOut)
					
					lbError =True
					//2019/05/31  - S33973  - Added a global email subjuct line to allow customization within a process
					gsEmailSubject = 'XPO Logistics WMS - Load id: ' + ls_load_Id + ', Action: LP' +  ls_trans_type + ', Whs: ' + ls_wh_code + ' - File Validation Error '

				END IF					
			END IF
	END CHOOSE
  NEXT

//Find any load plan record is failed to process.
ll_FindRow = ldsLoadPlan.find( "Status_Cd ='E'", 1, ldsLoadPlan.rowcount())

//Reject complete file
IF ll_FindRow > 0 THEN
	//assign Status_Cd ='E' for all records
	For ll_row = 1 to ldsLoadPlan.rowcount( )
		
		IF ldsLoadPlan.getItemString( ll_row, 'Status_Cd') <> 'E' Then
			ldsLoadPlan.setItem( ll_row, 'Status_Cd', 'E')
			ldsLoadPlan.setItem( ll_row, 'Status_Message', 'Error exists and File is rejected!')					
		End IF
	Next
END IF

w_main.SetMicroHelp("Completed processing Load plan - Saving datastores.")


//store records into Database
ll_RC = ldsLoadPlan.Update()
 
 If ll_RC = 1 then
 	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save Load Plan Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save Load Plan Records to database!")
	Return -1
End If

// Reset main window microhelp message
w_main.SetMicroHelp("Ready")

//Destroy datastore
destroy ldsLoadPlan
destroy ldsImport

IF lbError THEN
	Return -1
ELSE
	Return 0
END IF
end function

public function str_parms uf_process_load_plan_rejection (string as_project, string as_wh_code, string as_trans_type, string as_load_id, string as_customer_order, datetime adt_trans_time_stamp);//07-AUG-2018 :Madhu S21850 - Load Plan Rejection Logic

long ll_load_Id_Row,  ll_Load_Lock_Row, ll_rows, ll_findRow, ll_ts_count
string ls_sql, ls_error, ls_find, ls_existing_load_id, ls_current_ts, ls_load_lock
Str_Parms lstr_parms

Datastore lds_Delivery

lds_Delivery =create Datastore
ls_sql =" select * from Delivery_Master with(nolock) "
ls_sql +=" where Project_Id ='"+as_project+"' and wh_code ='"+as_wh_code+"'"
ls_sql += " and Invoice_No ='"+as_customer_order+"' and Ord_Status NOT IN ('V') "

lds_Delivery.create( SQLCA.syntaxfromsql( ls_sql, "", ls_error))
lds_Delivery.settransobject( SQLCA)
ll_rows = lds_Delivery.retrieve( )

//TAM - 2018/12/12 - S25773 -$$HEX1$$1c20$$ENDHEX$$Non TMS$$HEX2$$1d202000$$ENDHEX$$orders should not accept load plan any further from Google TMS. Get out immediately skipping all other validation - START
If ll_rows > 0 Then
	integer i
	FOR i = 1 to ll_rows
		If lds_Delivery.getItemString( i, 'otm_status') = 'Z' then
			lstr_parms.string_arg[1] ='E'
			lstr_parms.string_arg[2] = 'The Order No '+as_customer_order+ ' has been excluded from TMS processing and can not be updated.!'
			destroy lds_Delivery
			Return lstr_parms
		End If
	NEXT
End If
//TAM - 2018/12/12 - S25773 -$$HEX1$$1c20$$ENDHEX$$Non TMS$$HEX2$$1d202000$$ENDHEX$$orders should not accept load plan any further from Google TMS. Get out immediately skipping all other validation - END

//Transaction Type
If upper(as_trans_type) ='A' Then
	
	//a. Reject file, if load Id is already associated with Order
	ls_find ="Load_Id ='"+as_load_Id+"'"
	ll_findRow = lds_Delivery.find( ls_find, 1, lds_Delivery.rowcount())
	
	If ll_findRow > 0 Then
		lstr_parms.string_arg[1] ='E'
		lstr_parms.string_arg[2] ='Load Id is already exist in SIMS.'
		
	//b. Reject file, if  Order doesn't exist in System.	
	elseIf ll_rows = 0 Then
		lstr_parms.string_arg[1] ='E'
		lstr_parms.string_arg[2] ='Order No does not exist in SIMS.'

	else
		lstr_parms.string_arg[1] ='N'
		lstr_parms.string_arg[2] =''
	End If

	
	
elseIf upper(as_trans_type) ='U' Then
	
	//find a record for another Load Id
	ll_load_Id_Row = lds_Delivery.find( " Load_Id <> '"+as_load_Id+"'", 1, lds_Delivery.rowcount())
	
	//find a record for Load Lock
	ll_Load_Lock_Row = lds_Delivery.find(  " Load_Lock ='Y'", 1, lds_Delivery.rowcount())

	//a. Reject file, if  Order doesn't exist in System.
	If ll_rows = 0 Then
		lstr_parms.string_arg[1] ='E'
		lstr_parms.string_arg[2] ='Order No does not exist in SIMS.'
		
	//b. Reject file, if Order is associated with different Load Id
	elseIf ll_rows > 0 and ll_load_Id_Row > 0 Then
		ls_existing_load_Id = lds_Delivery.getItemString( ll_load_Id_Row, 'Load_Id')
		
		lstr_parms.string_arg[1] ='E'
		lstr_parms.string_arg[2] ='The Order No '+as_customer_order+ ' is already on another Load '+ls_existing_load_Id+' and can not be updated.!'

	//c. Reject file, if Load Id exist in SIMS and is locked (DM.Load_Lock =Y)			
	elseIf ll_rows > 0 and ll_Load_Lock_Row > 0 Then
			lstr_parms.string_arg[1] ='E'
			lstr_parms.string_arg[2] = 'The Load Id '+as_load_Id+ ' is locked in SIMS.'

	//d. Reject file, if processing load Id is lesser than previous Trans_Date
	else
	
		//get count of records lessthan current Transaction Time Stamp (DE7906)
		select count(*) into :ll_ts_count from EDI_Load_Plan with(nolock)
		where Project_Id =:as_project and Load_Id =:as_load_Id 
		and Transaction_Time_Stamp > :adt_trans_time_stamp and Status_Cd ='C'
		using SQLCA;
		
		If ll_ts_count > 0 Then
			lstr_parms.string_arg[1] ='E'
			lstr_parms.string_arg[2] = 'The current Load Message is not latest.!'
		else
			lstr_parms.string_arg[1] ='N'
			lstr_parms.string_arg[2] = ''
		End If
	End If	

elseIf upper(as_trans_type) ='D' Then
	
	//find a record whether Load Id exists or Not
	ll_findRow = lds_Delivery.find( " Load_Id = '"+as_load_Id+"'", 1, lds_Delivery.rowcount())
	
	//find a record for Load Lock
	ll_Load_Lock_Row = lds_Delivery.find(  " Load_Lock ='Y'", 1, lds_Delivery.rowcount())
	
	//a. Reject file, if  Order doesn't exist in System.
	If ll_rows = 0 Then
		lstr_parms.string_arg[1] ='E'
		lstr_parms.string_arg[2] ='Order No does not exist in SIMS.'

	//b. Reject file, if Load Id doesn't exist on Delivery Master
	elseIf ll_findRow = 0 Then
		lstr_parms.string_arg[1] ='E'
		lstr_parms.string_arg[2] ='The Load Id '+as_load_Id+' doesnot exist in SIMS.'

	//c. Reject file, if Load Id exist in SIMS and is locked (DM.Load_Lock =Yes)
	elseIf ll_Load_Lock_Row > 0 Then
		lstr_parms.string_arg[1] ='E'
		lstr_parms.string_arg[2] = 'The Load Id '+as_load_Id+ ' is locked in SIMS.'

	else
		lstr_parms.string_arg[1] ='N'
		lstr_parms.string_arg[2] = ''
	End If
	
End If
				
destroy lds_Delivery

Return lstr_parms
end function

public function datetime convert_string_to_datetime (string as_data);//08-AUG-2018 :Madhu S21850 - Process Load Plan

//Convert String to Date Time in format YYYY-MM-DD hh:mm:ss

DateTime ldt_Final_DateTime
date ld_Date
time lt_Time

string ls_year, ls_month, ls_day, ls_hour, ls_min, ls_sec, ls_nano
String ls_remain, ls_date, ls_time

//Incoming String contains 2018060820000053
If len(as_data) > 0 and Pos(as_data, "-") = 0 Then
	
	ls_remain = as_data //store current format into local variable
	
	ls_year =Left(ls_remain, 4) //get first 4 chars
	ls_remain = Mid(ls_remain, 5) 	//exculde 4 chars and start from 5th
		
	ls_month = Left(ls_remain, 2) //get first 2 chars
	ls_remain = Mid(ls_remain, 3) //exclude 2 chars
	
	ls_day = Left(ls_remain, 2) //get first 2 chars
	ls_remain = Mid(ls_remain, 3) //exclude 2 chars
	
	ls_hour = Left(ls_remain, 2) //get first 2 chars
	ls_remain = Mid(ls_remain, 3) //exclude 2 chars
	
	ls_min = Left(ls_remain, 2) //get first 2 chars
	ls_remain = Mid(ls_remain, 3) //exclude 2 chars

	If len(ls_remain) > 0 Then
		ls_sec = Left(ls_remain, 2) //get first 2 chars
		ls_remain = Mid(ls_remain, 3) //exclude 2 chars
	End If	

	If len(ls_remain) > 0 Then
		ls_nano = ls_remain 
	End If	
	
	If len(ls_year) > 0 Then ls_date =ls_year
	If len(ls_month) > 0 Then ls_date +="-"+ls_month
	If len(ls_day) > 0 Then ls_date +="-"+ls_day
	If len(ls_hour) > 0 Then ls_time +=ls_hour
	If len(ls_min) > 0 Then ls_time +=":"+ls_min
	If len(ls_sec) > 0 Then ls_time +=":"+ls_sec
	If len(ls_nano) > 0 Then ls_time +="."+ls_nano
	
	ld_Date = Date(ls_date)
	lt_Time = Time(ls_time)
	ldt_Final_DateTime = DateTime( ld_Date, lt_Time )
	
else	
	ldt_Final_DateTime = DateTime(as_data)
	
End If

Return ldt_Final_DateTime
end function

public function integer uf_sync_om_inventory (string asproject, string aswarehouse);//TAM 2018/11 - S26846 - Pandora-OM to SIMS inventory sync

datetime		ldtToday
String			lsErrors, lsSku, ls_client_id, lsLogout, sql_syntax, lsAccount
Long			ll_inv_count, llAvail, ll_OM_Qty_On_Hand, ll_req_count, ll_Row, ll_Inv_Row, llRC
Decimal		ldOMQ_Inv_Tran
datastore	ldsInv, ldsOpenOrders 


//write to screen and Log File
lsLogOut = '      -  Start Processing Function - Pandora OM to SIMS Inventory Reconcilliation - uf_sync_om_inventory. '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//write to screen and Log File
lsLogOut = '     	 	-  Start Processing Function - Reconcile Available Inventory between SIMS and OM - uf_sync_om_inventory. '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


ldtToday = DateTime(today(),Now())

gu_nvo_process_files.uf_connect_to_om( 'PANDORA') //connect to OM DB.

If Not isvalid(idsOMQInvTran) Then
	idsOMQInvTran = Create u_ds_datastore
	idsOMQInvTran.Dataobject = 'd_omq_inventory_transaction'
	idsOMQInvTran.SetTransObject(om_sqlca)
End If

If Not isvalid(idsOMAInvQtyOnHand) Then
	idsOMAInvQtyOnHand = Create u_ds_datastore
	idsOMAInvQtyOnHand.Dataobject = 'd_oma_inventory_qtyonhand'
	idsOMAInvQtyOnHand.SetTransObject(om_sqlca)
End If


//1.	Reconcile Available inventory between SIMS and OM

//build SQL Qeury to pull all Inventory from SIMS.
ldsInv = create Datastore

select OM_Client_Id into :ls_client_id from Project with(nolock) where Project_Id='PANDORA' using sqlca;

sql_syntax = "Select rtrim(CS.SKU ) as SKU, O.Owner_Cd, CS.PO_NO, SUM(CS.avail_qty + CS.alloc_qty + CS.tfr_In) as c_avail from content_summary CS, Owner O"
sql_syntax += " where CS.project_id = 'PANDORA' and CS.wh_code = '" + asWarehouse + "' and cs.owner_id = O.Owner_ID"
sql_syntax += " Group by CS.SKU, O.owner, CS.PO_NO"
sql_syntax += " order by CS.SKU, O.owner, CS.PO_NO"

ldsInv.create( SQLCA.SyntaxFromSql(sql_syntax, "", lsErrors))

IF len(lsErrors) > 0 THEN
 	lsLogOut = "        *** Unable to create datastore to Pull Inventory Items of PANDORA .~r~r" + lsErrors
	FileWrite(gilogFileNo,lsLogOut)
END IF

ldsInv.SetTransObject(SQLCA)
ll_inv_count =ldsInv.retrieve( )

//	Loop through each datastore record and update the allocated qty in OM
FOR ll_row =1 to ll_inv_count

//	Retrieve the corresponding OM Inventory for the current SIMS SKU
		lsSku = ldsInv.getitemString(ll_row, 'SKU')
		lsAccount = ldsInv.getitemString(ll_row, 'Owner_cd') + '~~' + ldsInv.getitemString(ll_row, 'PO_NO')
		llAvail = ldsInv.getitemNumber(ll_row, 'c_avail')

		If llAvail > 0 Then
//			SELECT sum(qtyonhand)  INTO :ll_OM_Qty_On_Hand FROM oma_inv_account_balance with(nolock)   WHERE Client_id = '1206' and account = 'MAIN' and Item = :lssku using om_sqlca  ;
			idsOMAInvQtyOnHand.reset()
			idsOMAInvQtyOnHand.retrieve(lsSku,aswarehouse,lsAccount)
			ll_OM_Qty_On_Hand = idsOMAInvQtyOnHand.getitemNumber(1, 'QtyOnHand')
			
			If llAvail <> ll_OM_Qty_On_Hand Then

				//	insert OMQ Record
				ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
				idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
				idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
				idsOMQInvTran.setitem( ll_Inv_Row, 'QADDWHO', 'SIMSUSER') //Add Who
				idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
				idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
				idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', asWarehouse) //site id
				idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
				idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
	
				ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no('PANDORA', 'OMQ_Inv_Tran', 'ITRNKey')
				idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', ldOMQ_Inv_Tran) //Set Trans_Id
				idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
				idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'DP') //Tran Type as AJ (Adjustment)
				idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', lsSku) 
				idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01', ldsInv.getitemString(ll_row, 'Owner_cd')) 
				idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE02', '')
				idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', ldsInv.getitemString(ll_row, 'PO_NO'))
				idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', llAvail - ll_OM_Qty_On_Hand) 
				idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', 'Recn' + string(ldtToday,'YYMMDD'))
				idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
				idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', 'Recon-' + string(ldtToday,'YYMMDD'))
				idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ADJUSTMENT') //Adjustment
				idsOMQInvTran.setitem( ll_Inv_Row, 'REASONCODE', 'RECON') //Reason code
			End If
		End If	

NEXT

//Save Inventory Transaction
If idsOMQInvTran.rowcount( ) > 0 Then
	//Execute Immediate "Begin Transaction" using om_sqlca; 4/2020 - MikeA - DE15499
	llRC =idsOMQInvTran.update( false, false);

	If llRC =1 Then
		//Execute Immediate "COMMIT" using om_sqlca; 4/2020 - MikeA - DE15499
		commit using om_sqlca; 
		
		if om_sqlca.sqlcode = 0 then
			idsOMQInvTran.resetupdate( )
		else
			//Execute Immediate "ROLLBACK" using om_sqlca; 4/2020 - MikeA - DE15499
			rollback using om_sqlca;
			idsOMQInvTran.reset( )
		
			//Write to File and Screen
			lsLogOut = '      - PANDORA OM to SIMS Inventory Reconcilliation - Processing of- uf_sync_om_inventory failed to write/update OM Tables: ' + om_sqlca.SQLErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		end if
	else
		//Execute Immediate "ROLLBACK" using om_sqlca; 4/2020 - MikeA - DE15499
		rollback using om_sqlca;
		//Write to File and Screen
			lsLogOut = '      - PANDORA OM to SIMS Inventory Reconcilliation - Processing of- uf_sync_om_inventory failed to write/update OM Tables: ' + om_sqlca.SQLErrText+  "System error, record save failed!"
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	End If
End IF
idsOMQInvTran.reset( )
idsOMAInvQtyOnHand.reset()

//write to screen and Log File
lsLogOut = '     	 	-  End Processing Function - Reconcile Available Inventory between SIMS and OM - uf_sync_om_inventory. '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsInv

//2.	Reconcile Allocated inventory between SIMS and OM

//write to screen and Log File
lsLogOut = '     		 -  Start Processing Function - Reconcile Allocated inventory between SIMS and OM - uf_sync_om_inventory. '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//	Clear the existing allocated qty in the OM Inventory table (we will rebuild it below)
Update oma_inv_account_balance  set qtyallocated = 0 WHERE Client_id = '1206' and account = 'MAIN' using om_sqlca  ;

//Execute Immediate "Begin Transaction" using om_sqlca; 4/2020 - MikeA - DE15499
//Execute Immediate "COMMIT" using om_sqlca; 4/2020 - MikeA - DE15499
commit using om_sqlca;
if om_sqlca.sqlcode = 0 then
else
	//Execute Immediate "ROLLBACK" using om_sqlca; 4/2020 - MikeA - DE15499
	rollback using om_sqlca;
	
	//Write to File and Screen
	lsLogOut = '      - PANDORA OM to SIMS Allocated Reconcilliation (Set to Zero) - Processing of- uf_sync_om_inventory failed to write/update OM Tables: ' + om_sqlca.SQLErrText
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
end if


//	Retrieve the SIMS $$HEX1$$1c20$$ENDHEX$$open$$HEX2$$1d202000$$ENDHEX$$inventory into a datastore
//build SQL Qeury to pull all Inventory from SIMS.
ldsOpenOrders = create Datastore

sql_syntax =	"Select rtrim(SKU) as SKU, SUM(req_qty) as req_qty from delivery_detail where do_no in (select do_no from Delivery_Master where project_id = 'PANDORA' and ord_status not in ('C','D','V')) Group By SKU order by SKU "

ldsOpenOrders.create( SQLCA.SyntaxFromSql(sql_syntax, "", lsErrors))

IF len(lsErrors) > 0 THEN
 	lsLogOut = "        *** Unable to create datastore to Pull Inventory Items of PANDORA .~r~r" + lsErrors
	FileWrite(gilogFileNo,lsLogOut)
END IF

ldsOpenOrders.SetTransObject(SQLCA)
ll_req_count =ldsOpenOrders.retrieve( )

//	Loop through each datastore record and update the allocated qty in OM
//	SQL = Update oma_inv_account_balance set qtyallocated = <qty> where client_id = $$HEX1$$1820$$ENDHEX$$1206$$HEX2$$19202000$$ENDHEX$$and item = <sku> and account = $$HEX1$$1820$$ENDHEX$$MAIN$$HEX4$$1920200020002000$$ENDHEX$$
FOR ll_row =1 to ll_req_count
	//	Update the corresponding OM Inventory for the current SIMS SKU
		lsSku = ldsOpenOrders.getitemString(ll_row, 'SKU')
		llAvail = ldsOpenOrders.getitemNumber(ll_row, 'req_qty')
		Update oma_inv_account_balance  set qtyallocated = :llAvail WHERE Client_id = '1206' and account = 'MAIN' and Item = :lssku using om_sqlca  ;
NEXT

//Execute Immediate "Begin Transaction" using om_sqlca; 4/2020 - MikeA - DE15499
//Execute Immediate "COMMIT" using om_sqlca; 4/2020 - MikeA - DE15499
commit using om_sqlca;
if om_sqlca.sqlcode = 0 then
else
	//Execute Immediate "ROLLBACK" using om_sqlca; 4/2020 - MikeA - DE15499
	rollback using om_sqlca;
	//Write to File and Screen
	lsLogOut = '      - PANDORA OM to SIMS Allocated Reconcilliation (Set OM to SIMS Value) - Processing of- uf_sync_om_inventory failed to write/update OM Tables: ' + om_sqlca.SQLErrText
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
end if


//write to screen and Log File
lsLogOut = '     	 	-  End Processing Function - Reconcile Allocated inventory between SIMS and OM - uf_sync_om_inventory. '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsOpenOrders

//write to screen and Log File
lsLogOut = '      -  End Processing Function - PANDORA OM to SIMS Inventory Reconcilliation - uf_sync_om_inventory. '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

gu_nvo_process_files.uf_disconnect_from_om() //Disconnect from OM.

Return 0


end function

public function integer uf_process_boh_sap ();					
					////////////////////////////////////////////////////////////////////////////////////////////////////////
					///// S59147- Google - SIMS - Need to create new inventory snapshot                        /////
					/////Process and  send one file to CM for all of the Inventory in Google Pandora SIMS  /////
					///// Author: Dinesh  Mahto																			  /////
					///// Date: 07/19/2021																				  /////
					////////////////////////////////////////////////////////////////////////////////////////////////////////

String			sql_syntax, ERRORS, lsLogOut, lsOutString, lsFileName, lsWarehouseSave,ls_sequence,ls_delete_list
Long			llRowPos, llRowCount, llNewRow
Int				liRC
Datastore	ldsBOH, ldsOut
Date			ldToday,ldtTransDate
datetime ldtToday
ldToday= today()
ldtToday = DateTime(today(),Now())

lsLogOut = "      Creating PANDORA for generating and sending an inventory snapshot to CM File... " 
FileWrite(gilogFileNo,lsLogOut)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

ldsboh = Create Datastore
sql_syntax="SELECT cs.wh_code, owner_cd, po_no, SKU, Sum(Avail_Qty) + Sum(alloc_Qty) + Sum(Tfr_In) as total_qty"
sql_syntax +=" from Content_Summary cs with(nolock)"
sql_syntax +=" inner join owner o with(nolock) on cs.project_id=o.project_id and cs.owner_id=o.owner_id"
sql_syntax +=" inner join project_warehouse pw with(nolock) on cs.project_id=pw.project_id and cs.wh_code=pw.wh_code"
sql_syntax +=" Where cs.Project_ID = 'PANDORA'"
sql_syntax +=" Group by cs.wh_code, owner_cd, po_no, SKU"
sql_syntax +=" Having Sum(Avail_Qty) + Sum(alloc_Qty) +Sum(Tfr_In) > 0"
sql_syntax += " Order by cs.wh_Code "

ldsboh.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
 	 lsLogOut = "        *** Unable to create datastore for PANDORA  (SAP).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
 	 RETURN - 1
END IF

lirc = ldsboh.SetTransobject(sqlca)

lLRowCount = ldsBoh.Retrieve()


lsLogOut = "    - " + String(ldsboh) + " inventory records retrieved for  processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

For llRowPos = 1 to lLRowCount /*Each Inv Record*/
	
	 ldsBoh.GetITemString(llRowPos,'wh_code')
	
	//If warehouse changed, write a seperate file for each
	If ldsBoh.GetITemString(llRowPos,'wh_code') <> lsWarehouseSave Then
		
		//Write the previous file (if not the first time through)
		If ldsOut.RowCount() > 0 Then
			gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'PANDORA')
			ldsOut.Reset()
		End If

		lsFileName = "SNPF_" + ldsBoh.GetITemString(llRowPos,'wh_code')  + "_" + + String(ldToday,"yyyymmddhhmmss") + ".dat"
		
		//Add a column Header Row*/
//		llNewRow = ldsOut.insertRow(0)
//		//Jxlim 12/21/2010 Added Item_Master.Description and Content_Summary.Serial_no
//		//JXLIM 07/01/2010 Added 3 labels (ItemMaster.UserField8, Volume and ItemMaster.Group)
//		lsOutString = "wh_code, owner_cd, po_no, SKU, total_qty"
//		ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
//		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
//		ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
//		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
//		ldsOut.SetItem(llNewRow,'file_name', lsFileName)
//		ldsOut.SetItem(llNewRow,'dest_cd', 'SAP') /* routed to different folder for processing */
//
				
	End If  /*Warehouse changed */
	string ls_sku,ls_pono,ls_owner,ls_wh
	//long ll_sku_len
	ls_sku= ldsBoh.GetITemString(llRowPos,'sku')
	ls_pono= ldsBoh.GetITemString(llRowPos,'po_no')
	ls_owner=ldsBoh.GetITemString(llRowPos,'owner_cd')
	ls_wh= ldsBoh.GetITemString(llRowPos,'wh_code')
	llNewRow = ldsOut.insertRow(0)
	
	lsOutString = "UI" /* Record ID */
	lsOutString += String(ldtToday,'yyyymmdd') /* transaction Date (GMT + 8) */
	lsOutString += String(ldtToday,'hhmmss')+ Space(10) /* transaction Time (GMT + 8) */
	lsOutString += String(ldsBoh.GetItemNumber(llRowPos, 'total_qty'), "0000000000.00")
	lsOutString += ls_sku + Space(45- len(ls_sku))
	lsOutString +=Space(6) // Package code
	lsOutString +=Space(60) // lot
	lsOutString += ls_pono + Space(60- len(ls_pono))
	lsOutString += ls_owner + Space(60- len(ls_owner))
	lsOutString +=Space(60) // User code 3
	lsOutString +=Space(4) // hold code
	lsOutString +=Space(30) // Order ID
	lsOutString +=Space(4) // Order Type
	lsOutString +=Space(10) // Order Line Number
	lsOutString +=Space(6) // UOM
	lsOutString +=Space(15) // Kit Code
	lsOutString +=ls_wh + Space(10- len(ls_wh))

	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)
	ldsOut.SetItem(llNewRow,'dest_cd', 'SAP') /* routed to different folder for processing */

		
	lsWarehouseSave = ldsBoh.GetITemString(llRowPos,'wh_code')
	
Next /*Inventory Record*/

//Last/Only warehouse
If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'PANDORA')
End If
		

REturn 0
end function

on u_nvo_proc_pandora.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_pandora.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

