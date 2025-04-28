HA$PBExportHeader$u_nvo_proc_kinderdijk.sru
$PBExportComments$Process files for Physio Control
forward
global type u_nvo_proc_kinderdijk from nonvisualobject
end type
end forward

global type u_nvo_proc_kinderdijk from nonvisualobject
end type
global u_nvo_proc_kinderdijk u_nvo_proc_kinderdijk

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 

end prototypes

type variables

string lsDelimitChar

end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_so_consignment (string aspath, string asproject)
public function integer uf_process_so_outright (string aspath, string asproject)
public function integer uf_process_daily_recon (string asproject, string asinifile)
public function integer uf_process_dboh (string asproject, string asinifile)
public function integer uf_process_dboh_volume ()
public function string nonull (string as_str)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Jxlim 05/06/2013 Kinderdijk
//Process the correct file type based on the first 1 characters of the file name

String	lsLogOut,	&
			lsSaveFileName, &
			lsPOLineCountFileName, lsFile, lsOutboundType
			
Integer	liRC
integer 	liLoadRet, liProcessRet
Boolean	bRet

lsFile =Upper(Left(asFile,1))

Choose Case lsFile
		
//	Case  'IN'  
//		
//		liRC = uf_process_purchase_order(asPath, asProject)
//	
//		//Process any added PO's
//		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject)  	
	
	//Process any added SO's for Consignment Outbound Order
	Case  'C' 
		liRC = uf_process_so_consignment(asPath, asProject)
	
		//Process any added SO's for Consignment Outbound Order
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject )
	
	//Process any added SO's for Outright Outbound Order
	Case  'O' 
		//Process any added SO's for Outright Outbound Order		
		liRC = uf_process_so_outright(asPath, asProject)
	
		//Process any added SO's for Outright Outbound Order
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject )
		
//	Case 'IM'
//		
//		liRC = uf_Process_ItemMaster(asPath, asProject)
		

	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
end function

public function integer uf_process_so_consignment (string aspath, string asproject);//Jxlim 05/03/2013 Kinderdijk
//Process Transaction Type (CDatetime) - Consignment Orders to Pick Outbound Order (SO)  (treated like sims baseline DM file)

STRING lsTemp, lsSupplier, lsWarehouse, lsOrderType, lsTempNote, lsStrykerWarehouse
Datetime ldtWHTime
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llfilerowcount, llfilerowpos
LONG llNewAddressRow, llNoteSequence, llNewNotesRow
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow
STRING lsLogOut, lsChangeID
INTEGER li_Startcol
INTEGER li_UFIdx
DECIMAL ldQuantity
STRING lsCustomerCode
STRING ls_OrderDate, ls_DeliveryDate, ls_ScheduleDate
BOOLEAN lbBillToAddress
STRING lsBillToAddr1, lsBillToAddr2, lsBillToAddr3, lsBillToAddr4, lsBillToCity
STRING	lsBillToState, lsBillToZip, lsBillToCountry, lsBillToTel, lsBillToName
STRING  lsNoteType, lsNoteText, lsTransactionType, lsOutboundType

Boolean lbNewHdrOrderNbr
String lsHdrOrdernbr, lsOrderNbr, lsInvType, lsInvType_Desc, lsCustCode, lsCustName
String lsAddress1, lsAddress2, lsAddress3, lsCity, lsState, lsZipcode, lsSku, lsUom
Long llZipCode, llLineItemNo
Decimal ldQty
Datetime lldtOrdDate

lbNewHdrOrderNbr = False
// Consignment Orders to Pick  -Fields mapping
/////	SIMS	Fields				KD Fields
//1		Order Nbr			HD	[IVDOCNBR] [varchar](25)	
//2		Order Dateime		HD	[DOCDATE] [datetime2](3)
//3		Inventory Type		DT	[TRXLOCTN] [varchar](20)
//4		Customer Code		HD	[TRNSTLOC] [varchar](20)
//5		Customer Name	HD	[LOCNDSCR] [varchar](70)	
//6		Address1				HD	[Address1] [varchar](70)	
//7		Address2				HD	[Address2] [varchar](70)	
//8		Address3				HD	[Address3] [varchar](70)	
//9		City					HD	[City] [varchar](40)	
//10	State					HD	[State] [varchar](35)	
//11	Zip Code				HD	[ZipCode] [varchar](15)	
//12	Line_item_no		DT	[Lnseqnbr] [numeric](18, 0)	
//13	SKU					DT	[ITEMNMBR] [varchar](35)	
//14	UofM					DT[UOFM] [varchar](15)				// Not required in Sims, assumes always 1
//15	Qty					DT	[TRXQTY] [decimal](19, 5)	


//C_  EDI $$HEX2$$13202000$$ENDHEX$$Outbound orders
//1.  Header
//2. . Detail

u_ds_datastore ldsImport, ldsSOheader, ldsSOdetail

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'	//col
//ldsImport.dataobject = 'd_import_generic_csv'			//col

ldsSOheader = Create u_ds_datastore
ldsSOheader.dataobject= 'd_baseline_unicode_shp_header'		//Invoice no is for SO  --Order_no is for PO
//ldsSOheader.dataobject= 'd_shp_header'
ldsSOheader.SetTransObject(SQLCA)

ldsSOdetail = Create u_ds_datastore
ldsSOdetail.dataobject= 'd_baseline_unicode_shp_detail'			//Invoice_no is for SO
//ldsSOdetail.dataobject= 'd_shp_detail'
ldsSOdetail.SetTransObject(SQLCA)

//Open and read the File In
lsLogOut = '      - Opening Sales Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( CSV!, aspath)   //.CSV

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Sales Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

ldsImport.SetSort("Col1 A")
ldsImport.Sort()

llFilerowCount = ldsImport.RowCount()

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

For llFileRowPos = 1 to llFilerowCount
	w_main.SetMicroHelp("Processing Sales Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))		
	
	//HEADER1. ---------------------------------------------------* BEGIN Header Import- Delivery Master */	--------------------------------------------------//	
	
	//Default values:
	//lsWarehouse = "23SHAHALAM"	//Jxlim 05/31/2013 Requirement changed
	lsWarehouse = "KINDERDIJK"
	lsSupplier = "KINDERDIJK"
	lsOrderType="S"
	lsOutboundType ='C'  //C_ = Consignment Outbound Order Type; uses Outbound header user_field22 to store this value; it maybe use for future report requirments
		
	//1[IVDOCNBR] [varchar](25) - Sims Order Nbr
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Nbr is required. Record will not be processed.")
		lbError = True
		Continue		
	Else		
		//Every time the value changes, create a new header and then also get the first detail from that row.
		//For other records with the same order number, just take the detail information.since 		
		If  lsOrderNbr <> lsTemp Then
			lbNewHdrOrderNbr  = True
			lsOrderNbr = lsTemp				
		Else
			lbNewHdrOrderNbr = False
		End If
	End If	
	
	If lbNewHdrOrderNbr  = True  THEN //These are header record - Delivery master
				//2[DOCDATE] [datetime2](3) - Sims Order Dateime
				//Order date is order creation date; use warehouse datetime
				ldtWHTime = f_getLocalWorldTime(lsWarehouse)	
				
				//4[TRNSTLOC] [varchar](20)- Sims Customer Code
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Code is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsCustcode = lsTemp
				End If	
				
				//5[LOCNDSCR] [varchar](70)- Sims Customer Name
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Name is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsCustName = lsTemp
				End If	
				
				//6[Address1] [varchar](70)- Sims Customer Address1
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Address1 is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsAddress1 = lsTemp
				End If	
				
				//7[Address2] [varchar](70)- Sims Customer Address2
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Address2 is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsAddress2 = lsTemp
//				End If	
				
				//8[Address3] [varchar](70)- Sims Customer Address3
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Address3 is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsAddress3 = lsTemp
//				End If	
				
				//9[City] [varchar](40))- Sims Customer City
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - City is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsCity = lsTemp
//				End If	
								
				//10[State] [varchar](35)- Sims Customer State
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - State is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsState = lsTemp
//				End If	
							
				//11[ZipCode] [varchar](15)- Sims Customer Zip code
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Zip Code is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsZipcode = lsTemp
//				End If		
		End If
//HEADER 1. ---------------------------------------------------* END Header Import- Delivery Master */	--------------------------------------------------//
//HEADER 2. -----------------------------------------------* BEGIN HEADER RECORD - Delivery Master */	--------------------------------------------------//
		If lbNewHdrOrderNbr  = True THEN				//If lsOrderNbr is changed, creat new header Delivery Master record
				//Insert to Delivery Master	
				liNewRow = 	ldsSOheader.InsertRow(0)
				llOrderSeq ++
				llLineSeq = 0			
				
				//New Record Defaults
				ldsSOheader.SetItem(liNewRow,'action_cd','A')  /*Always a new record */	
				ldsSOheader.SetItem(liNewRow,'project_id',asProject)			
				ldsSOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
			//	ldsSOheader.SetItem(liNewRow,'Request_date',String(Today(),'YYMMDD'))
				ldsSOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsSOheader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
				ldsSOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
				ldsSOheader.SetItem(liNewRow,'status_cd','N')
				ldsSOheader.SetItem(liNewRow,'Last_user','SIMSEDI')
				ldsSOheader.SetItem(liNewRow,'ord_status','N')		//New
				ldsSOheader.SetItem(liNewRow,'Order_type', lsOrderType)  /* Sale Order Type*/	
				ldsSOheader.SetItem(liNewRow,'User_field22', lsOutboundType)  /* Outbound Order Type*/ //C_ = Consignment Outbound Order Type; uses Outbound header user_field22 to store this value; it maybe use for future report requirments
							
				//Header
				ldsSOheader.SetItem(liNewRow,'invoice_no',Trim(lsOrderNbr))   	 		 /* Order Nbr */	//Invoice_no for SO order_no for PO (Customer Order_no) --(EDI header)
				ldsSOheader.SetItem(liNewRow,'ord_date',string(ldtWHTime, 'mm-dd-yyyy hh:mm')) /* Order Date */	//convert to local warehouse dateime	
				ldsSOheader.SetItem(liNewRow,'Inventory_Type','N')					 /* Inventoryr Type*/	 //Always (N)ormal for kinderdijk at the Header
				ldsSOheader.SetItem(liNewRow,'Cust_Code',lsCustCode) 		 	 /* Customer Code*/	
				ldsSOheader.SetItem(liNewRow,'Cust_Name',lsCustName)	 		 /* Customer Name*/	
				ldsSOheader.SetItem(liNewRow,'Address_1',lsAddress1)			 /* Address1*/	
				ldsSOheader.SetItem(liNewRow,'Address_2',lsAddress2)			 /* Address2*/	
				ldsSOheader.SetItem(liNewRow,'Address_3',lsAddress3)			 /* Address3*/	
				ldsSOheader.SetItem(liNewRow,'City',lsCity)							 /* City*/	
				ldsSOheader.SetItem(liNewRow,'State',lsState)						 /* State*/	
				ldsSOheader.SetItem(liNewRow,'Zip',llZipCode)						 /* Zip Code*/	
		End If
//HEADER2. -----------------------------------------------* End HEADER RECORD - Delivery Master *------------------------------------------------------------------//		

//DETAIL1. ---------------------------------------------------* BEGIN DETAIL RECORD Import- Delivery Detail */	--------------------------------------------------//	
	//1[IVDOCNBR] [varchar](25) - Sims Order Nbr
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))		
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
//		//Make sure we have a header for this Detail...
//		If ldsSOHeader.Find("Upper(invoice_no) = '" + Upper(lstemp) + "'",1, ldsSOHeader.RowCount()) = 0 Then
//			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header Order Number. Record will not be processed.")
//			lbDetailError = True
//		End If		
		lsOrderNbr = lsTemp
	End If			
		
	//3[TRXLOCTN] [varchar](20) - Sims Inventory Type
	//Always (N)normal at the hearder for Kinderdijk
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Inventory Type is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		lsInvType_Desc = lsTemp
		//lsInvType = lsTemp
	End If	
	
	If Not IsNull(lsInvType_Desc ) OR trim(lsInvType_Desc ) > '' Then					
		Select Inv_Type Into :lsInvType From Inventory_Type with( NoLock) 
		Where Project_id =:asproject and  Inv_Type_Desc =:lsInvType_Desc Using SQLCA;
	End IF				

	//12[Lnseqnbr] [numeric](18, 0)- Sims Line Item No
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item No is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		 llLineItemNo = Long(lsTemp)
	End If	
	
	//13[ITEMNMBR] [varchar](35)- Sims SKU
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - SKU is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		lsSku = lsTemp
	End If	
	
	//14[UOFM] [varchar](15)- Sims UofM
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))	
//	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - UOM is required. Record will not be processed.")
//		lbError = True
//		Continue		
//	Else
//		//String lsUom
		 lsUom = lsTemp
//	End If	
	
	//15[TRXQTY] [decimal](19, 5)- Sims Qty
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Qty is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		ldQty = Dec(lsTemp)
	End If	
//DETAIL1. ---------------------------------------------------* ENDDETAIL RECORD Import- Delivery Detail */	--------------------------------------------------//	

//DETAIL2. -----------------------------------------------* BEGIN DETAIL RECORD - Delivery Detail */	--------------------------------------------------//	
//---------Insert to Delivery Detail
		
			lbDetailError = False
			llNewDetailRow = 	ldsSODetail.InsertRow(0)
			llLineSeq ++
					
			//Add Detail level defaults
			ldsSODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsSODetail.SetItem(llNewDetailRow,'project_id', asProject) /*project*/
			ldsSODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsSODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsSODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			
			ldsSODetail.SetItem(llNewDetailRow,'invoice_no',Trim(lsOrderNbr))		//d_ship_detail (invoice_no) 	
			ldsSODetail.SetItem(llNewDetailRow,'Inventory_Type', lsInvType)  //Detail - Inventory_Type
//			ldsSODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	
			ldsSODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
//			ldsSODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	 //11-Jul-2013 :Madhu commented
			ldsSODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineSeq) /*Line_Item_No*/	 //11-Jul-2013 :Madhu Added
			ldsSODetail.SetItem(llNewDetailRow,'User_Line_Item_No',string(llLineItemNo)) /*User_Line_Item_No*/	 //11-Jul-2013 :Madhu Added
			ldsSODetail.SetItem(llNewDetailRow,'Sku',lsSku) /*Sku*/	
			ldsSODetail.SetItem(llNewDetailRow,'UOM',lsUOM) /*UOM*/	
			ldsSODetail.SetItem(llNewDetailRow,'Quantity', String(ldQty)) /*Quantity*/		

			
//End of DETAIL RECORD
//DETAIL2. -----------------------------------------------* END DETAIL RECORD - Delivery Detail */	--------------------------------------------------//	
			
/* EOF Header or Detail */	
	
Next /*File record */

//IF lirc = -1 then lbError = true else lbError = false	

//Save the Changes 
SQLCA.DBParm = "disablebind =0"
lirc = ldsSOheader.Update()
SQLCA.DBParm = "disablebind =1"
	
If liRC = 1 Then
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsSOdetail.Update()
	SQLCA.DBParm = "disablebind =1"
	
ELSE
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Header Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If


If liRC = 1 then
//	Commit;

//BCR 12-30-11 Geistlich UAT Session...
//why comment out this Commit? It is the cause of this UOM issue we have found in Geistlich UAT...
Commit;
//End

Else
	
//	Execute Immediate "ROLLBACK" using SQLCA; 
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Delivery Notes Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If

If lbError Then
	Return -1
Else
	Return 0
End If

end function

public function integer uf_process_so_outright (string aspath, string asproject);//Jxlim 05/03/2013 Kinderdijk
//Process Transaction Type (ODatetime) - Outbound Orders to Pick; Outbound Order (SO) (treated like sims baseline DM file)

STRING lsTemp, lsSupplier, lsWarehouse, lsOrderType, lsOutboundType
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llfilerowcount, llfilerowpos
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow
STRING lsLogOut, lsChangeID
Boolean lbNewHdrOrderNbr
String lsHdrOrdernbr, lsOrderNbr, lsInvType, lsInvType_Desc, lsCustCode, lsCustName
String lsAddress1, lsAddress2, lsAddress3, lsCity, lsState, lsZipcode, lsSku, lsDesc, lsUom, lsFreight_Terms, lsShipToContName, lsShiptoconttlp
Long llZipCode, llLineItemNo
Decimal ldQty, ldPrice
Datetime ldtWHTime, ldtOrdDate
String lsRemark, lscomment, lsComment1, lsComment2, lsComment3, lsComment4

lbNewHdrOrderNbr = False
//	Outright Orders to Pick --MappingStart Date	End Date 							
//1		Inventory Type						DT	[Location Code from Sales Transaction] [varchar](20)
//2		SKU									DT	[Item Number] [varchar](35)
//3		UofM1								DT	[U Of M] [varchar](15)
//4		UofM2								DT	[U Of M Schedule] [varchar](15)
//5		Description							DT	[Item Description] [varchar](110)
//6		Qty									DT	[QTY] [decimal](19, 5)
//7		Not need, assumed always 1	DT[QTY In Base U Of M] [decimal](19, 5) NOT NULL,
//8		OrderDetail-Price					DT	[Unit Price] [decimal](19, 5)
//9		Customer Code						HD	[Customer Number] [varchar](20)
//10	Customer Name					HD	[Customer Name from Customer Master] [varchar](70)
//11	Address1								HD	[Address 1 from Sales Transaction] [varchar](70)
//12	Address2								HD	[Address 2 from Sales Transaction] [varchar](70)
//13	Address3								HD	[Address 3 from Sales Transaction] [varchar](70)
//14	City									HD	[City from Sales Transaction] [varchar](40)
//15	State									HD	[State from Sales Transaction] [varchar](35)
//16	Zip Code								HD	[Zip Code from Sales Transaction] [varchar](15)
//17	Order Nbr							HD	[SOP Number] [varchar](25)
//18	Order Datetime						HD	[Document Date] [datetime2](3)
//19	OrderInfo-Freight Terms			HD	[Payment Terms ID] [varchar](25)
//20	ShipTo-Contact Person			HD	[Salesperson ID from Sales Transaction] [varchar](20)
//21	ShipTo-Telephone					HD	[Phone 1 from Sales Line Item] [varchar](25)
//22	OtherInfo-Remarks				HD	[Batch Number] [varchar](20)
//OtherInfo-Shipping_Instructions nvarchar(255)
		//23			[Comment 1] [varchar](60)
		//24			[Comment 2] [varchar](60)
		//25			[Comment 3] [varchar](60)
		//26			[Comment 4] [varchar](60)
//27	Line_item_no						DT	[Line Item Sequence] [numeric](18, 0)


//O_  EDI $$HEX2$$13202000$$ENDHEX$$Outbound orders
//1.  Header
//2. . Detail

u_ds_datastore ldsImport, ldsSOheader, ldsSOdetail

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'	//col
//ldsImport.dataobject = 'd_import_generic_csv'			//col

ldsSOheader = Create u_ds_datastore
ldsSOheader.dataobject= 'd_baseline_unicode_shp_header'		//Invoice no is for SO  --Order_no is for PO
//ldsSOheader.dataobject= 'd_shp_header'
ldsSOheader.SetTransObject(SQLCA)

ldsSOdetail = Create u_ds_datastore
ldsSOdetail.dataobject= 'd_baseline_unicode_shp_detail'			//Invoice_no is for SO
//ldsSOdetail.dataobject= 'd_shp_detail'
ldsSOdetail.SetTransObject(SQLCA)

//Open and read the File In
lsLogOut = '      - Opening Sales Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//MA - Reverted code
// Was causing only parital file to load.


////11-Jun-2013 :Madhu code -START
//int liFileNo
//string as_Value,ls_sub1,ls_sub2,ls_sub3,ls_sub4,ls_temp,ls_import,ls_text
//long ll_Pos, ll_OldPos,ll_Pos1,ll_pos2,ll_pos3,ll_length,ll_pos4,ll_OldPos1,ll_readbytes,ll_filehandle
//long ll_count=1
//
//ll_filehandle = FileOpen(aspath, TextMode!) //Open the file -1st time
//ll_readbytes    = FileReadEx(ll_filehandle, ls_import) //Read the data
//
//as_Value =","
//ll_Pos = Pos( ls_import, as_Value )
//IF ll_Pos = 0 THEN RETURN ll_Pos
//
////1st -LOOP -START 
//DO WHILE ll_Pos <> 0  
//	ll_OldPos = ll_Pos  
//	ll_Pos = Pos( ls_import, as_Value, ll_Pos+1 )
//	ls_text =Mid(ls_import,ll_OldPos+1,ll_Pos - ll_OldPos - 1) //getting a string/text which is separated by comma
//	ll_length=len(ls_text) //length of text
//	
//	//Get the positions of double quotes in substring
//	ll_pos1 =Pos(ls_text, "~"")    //Get the 1st position
//	ll_pos2 =Pos(ls_text, "~"",ll_pos1+1) //Get the 2nd position
//	ll_pos3 =LastPos(ls_text,"~"")	 //Get the last position
//
//IF ll_pos2 <ll_length and ll_Pos2 >0 THEN // if substring has double double quotes, that comes in side else go away
//	ls_sub1 =Mid(ls_text,ll_Pos2,ll_Pos3 - ll_Pos2) //get the string b/w 1st & last double quotes
//	ls_temp=ls_sub1 //store the sub1 value in temp
//
////2nd -LOOP -START 
//ll_Pos4 =Pos(ls_sub1,"~"")
//DO WHILE ll_Pos4 <> 0  
//	ll_OldPos1 = ll_Pos4  
//	ll_Pos4 = Pos( ls_sub1, "~"", ll_Pos4+1 )
//	ls_sub2 =Mid(ls_sub1,ll_OldPos1 -1,ll_Pos4) //getting a string/text which is separated by comma
//		
//	IF ll_Pos4 <> 0  and (ll_Pos4 - ll_OldPos1) > 1 THEN //becoz, substring has double double quotes .Ex:- """POPPIES" - which  doesn't allow.
//		ls_sub4 +=ls_sub2
//	END IF
//	
//	IF (ll_Pos4 - ll_OldPos1) =1 THEN //removing double double quotes
//		ls_sub1 = Mid(ls_sub1,ll_Pos4,len(ls_sub1))
//		ll_count = ll_count+1
//	END IF
//LOOP
////2nd -LOOP -END
//
////After the double quotes,if still the text exists
//ls_sub3 =Mid(ls_temp,ll_OldPos1+ ll_count,ll_length - 1) //get the string which is after double quotes
//ls_sub3 =ls_sub4+" "+ls_sub3
//ls_import =Replace(ls_import,ll_OldPos+1,ll_Pos - ll_OldPos - 1,ls_sub3) //Replace the string into local copy
//ls_sub4 =" "
//ll_count=1
//END IF
//LOOP //1st- LOOP END
//
//FileClose(ll_filehandle)  //close the 1st file
//
//liFileNo = FileOpen(aspath,StreamMode!, Write!, LockWrite!, Replace!)  //Open the file -2nd time to replace
//liRC = FileWrite(liFileNo, ls_import) //write the data into file
//FileClose(liRC) //close the file
////11-Jun-2013 :Madhu END

//Bring in File
liRtnImp =  ldsImport.ImportFile( CSV!, aspath)   //.CSV

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Sales Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

ldsImport.SetSort("Col17 A")
ldsImport.Sort()

llFilerowCount = ldsImport.RowCount()

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

For llFileRowPos = 1 to llFilerowCount
	w_main.SetMicroHelp("Processing Sales Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))		
	
	//HEADER1. ---------------------------------------------------* BEGIN Header Import- Delivery Master */	--------------------------------------------------//	
	
	//Default values:
	//lsWarehouse = "23SHAHALAM"	//Jxlim 05/31/2013 Requirement changed
	lsWarehouse = "KINDERDIJK"
	lsSupplier = "KINDERDIJK"
	lsOrderType="S"
	lsOutboundType ='O'  //C_ = Consignment Outbound Order Type; uses Outbound header user_field22 to store this value; it maybe use for future report requirments
	
	//Invoice No is the key to identify for creating header. Every new invoice_no will create new header recoird. (HD)
	//17	Order Nbr							HD	[SOP Number] [varchar](25)		//Sims IInvoice No
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Nbr is required. Record will not be processed.")
		lbError = True
		Continue		
	Else		
		//Every time the value changes, create a new header and then also get the first detail from that row.
		//For other records with the same order number, just take the detail information.since 		
		If  lsOrderNbr <> lsTemp Then
			lbNewHdrOrderNbr  = True
			lsOrderNbr = lsTemp				
		Else
			lbNewHdrOrderNbr = False
		End If
	End If	
	
	If lbNewHdrOrderNbr  = True  THEN //These are header record - Delivery master	
				//1		Inventory Type						DT	[Location Code from Sales Transaction] [varchar](1)
				//For Header treats Inventory type as New

				//18	Order Datetime						HD	[Document Date] [datetime2](3)
				//Order date is order creation date; use warehouse datetime
				ldtWHTime = f_getLocalWorldTime(lsWarehouse)	
						
				//19	OrderInfo-Freight Terms			HD	[Payment Terms ID] [varchar](25)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col19"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Info- Freight Terms is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsfreight_terms = lsTemp
//				End If						
				
//				//20	ShipTo-Contact Person			HD	[Salesperson ID from Sales Transaction] [varchar](20)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col20"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - ShipTo-Contact Person is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsShipToContName = lsTemp
//				End If		
				
				//21	ShipTo-Telephone					HD	[Phone 1 from Sales Line Item] [varchar](25)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col21"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - ShipTo-Contact Telephone is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsShipToContTlp = lsTemp
//				End If		
				
				//22	OtherInfo-Remarks				HD	[Batch Number] [varchar](20)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col22"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Remark is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsRemark = lsTemp
//				End If	
				
				//Combine all comment1 thru comment4 to Shipping instruction on other info tab
				//23 OtherInfo-Shipping_Instructions nvarchar(255)			[Comment 1] [varchar](60)
				lsComment = ''
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col23"))		
				If 	lsTemp > '' Then
					lsComment = lsTemp
				End If
				
				//24	OtherInfo-Shipping_Instructions nvarchar(255)			[Comment 2] [varchar](60)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col24"))				
				If 	lsTemp > '' Then
					lsComment += " " + lsTemp
				End If

				//25	OtherInfo-Shipping_Instructions nvarchar(255)			[Comment 3] [varchar](60)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col25"))				
				If 	lsTemp > '' Then
					lsComment += " " + lsTemp
				End If

				//26	OtherInfo-Shipping_Instructions nvarchar(255)			[Comment 4] [varchar](60)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col26"))				
				If 	lsTemp > '' Then
					lsComment += " " + lsTemp
				End If
				
				//3[TRXLOCTN] [varchar](20) - Sims Inventory Type
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))	
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Inventory Type is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsInvType_Desc = lsTemp
					//lsInvType = lsTemp
				End If	
				
				If Not IsNull(lsInvType_Desc ) OR trim(lsInvType_Desc ) > '' Then					
					Select Inv_Type Into :lsInvType From Inventory_Type with( NoLock) 
					Where Project_id =:asproject and  Inv_Type_Desc =:lsInvType_Desc Using SQLCA;
				End IF		
				
				//9		Customer Code						HD	[Customer Number] [varchar](20)	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Code is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsCustcode = lsTemp
				End If	
				
				//10	Customer Name					HD	[Customer Name from Customer Master] [varchar](70)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Name is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsCustName = lsTemp
				End If		

				//11	Address1								HD	[Address 1 from Sales Transaction] [varchar](70)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Address1 is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsAddress1 = lsTemp
				End If	
				
				//12	Address2								HD	[Address 2 from Sales Transaction] [varchar](70)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Address2 is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsAddress2 = lsTemp
//				End If	
				
				//13	Address3								HD	[Address 3 from Sales Transaction] [varchar](70)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Address3 is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsAddress3 = lsTemp
//				End If	
				
				//14	City									HD	[City from Sales Transaction] [varchar](40)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - City is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsCity = lsTemp
//				End If				

								
				//15	State									HD	[State from Sales Transaction] [varchar](35)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - State is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsState = lsTemp
//				End If	
							
				//16	Zip Code								HD	[Zip Code from Sales Transaction] [varchar](15)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))				
//				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Zip Code is required. Record will not be processed.")
//					lbError = True
//					Continue		
//				Else
					lsZipcode = lsTemp
//				End If		
				
		End If
//HEADER 1. ---------------------------------------------------* END Header Import- Delivery Master */	--------------------------------------------------//
//HEADER 2. -----------------------------------------------* BEGIN HEADER RECORD - Delivery Master */	--------------------------------------------------//
		If lbNewHdrOrderNbr  = True THEN				//If lsOrderNbr is changed, creat new header Delivery Master record
				//Insert to Delivery Master	
				liNewRow = 	ldsSOheader.InsertRow(0)
				llOrderSeq ++
				llLineSeq = 0			
				
				//New Record Defaults
				ldsSOheader.SetItem(liNewRow,'action_cd','A')  /*Always a new record */	
				ldsSOheader.SetItem(liNewRow,'project_id',asProject)			
				ldsSOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
			//	ldsSOheader.SetItem(liNewRow,'Request_date',String(Today(),'YYMMDD'))
				ldsSOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsSOheader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
				ldsSOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
				ldsSOheader.SetItem(liNewRow,'status_cd','N')
				ldsSOheader.SetItem(liNewRow,'Last_user','SIMSEDI')
				ldsSOheader.SetItem(liNewRow,'ord_status','N')		//New
				ldsSOheader.SetItem(liNewRow,'Order_type', lsOrderType)  /* Sale Order Type*/	
				ldsSOheader.SetItem(liNewRow,'User_field22', lsOutboundType)  /* Outbound Order Type*/ //C_ = Consignment Outbound Order Type; uses Outbound header user_field22 to store this value; it maybe use for future report requirments
			
							
				//Header
				ldsSOheader.SetItem(liNewRow,'invoice_no',Trim(lsOrderNbr))   	 /* Order Nbr */	//Invoice_no for SO order_no for PO (Customer Order_no) --(EDI header)						
				ldsSOheader.SetItem(liNewRow,'ord_date',string(ldtWHTime, 'mm-dd-yyyy hh:mm')) 		/* Order Date */	//convert to local warehouse dateime					
				ldsSOheader.SetItem(liNewRow,'Inventory_Type','N')					 								/* Inventory Type*/	 //Always (N)ormal for kinderdijk at the Header
				ldsSOheader.SetItem(liNewRow,'Cust_Code',lsCustCode) 		 									 /* Customer Code*/	
				ldsSOheader.SetItem(liNewRow,'Cust_Name',lsCustName)	 										 /* Customer Name*/	
				ldsSOheader.SetItem(liNewRow,'Address_1',lsAddress1)											 /* Address1*/	
				ldsSOheader.SetItem(liNewRow,'Address_2',lsAddress2)											 /* Address2*/	
				ldsSOheader.SetItem(liNewRow,'Address_3',lsAddress3)											 /* Address3*/	
				ldsSOheader.SetItem(liNewRow,'City',lsCity)									 						/* City*/	
				ldsSOheader.SetItem(liNewRow,'State',lsState)								 						/* State*/	
				ldsSOheader.SetItem(liNewRow,'Zip',llZipCode)														/* Zip Code*/	
				ldsSOheader.SetItem(liNewRow,'freight_terms',lsfreight_terms)									/* Freight Terms */		
				ldsSOheader.SetItem(liNewRow,'contact_person',lsShipToContName) 							/* ShipTo-Contact Person */	
				ldsSOheader.SetItem(liNewRow,'tel',lsShiptoconttlp) 													/* ShipTo-Contact Telephone */	
				ldsSOheader.SetItem(liNewRow,'remark',lsremark) 													/* OtherInfo-Remarks */	
				ldsSOheader.SetItem(liNewRow,'Shipping_Instructions_text',lscomment) 						/* Comment 1, 2, 3, 4*/	
				
		End If
//HEADER2. -----------------------------------------------* End HEADER RECORD - Delivery Master *------------------------------------------------------------------//		

//DETAIL1. ---------------------------------------------------* BEGIN DETAIL RECORD Import- Delivery Detail */	--------------------------------------------------//	

	//17	Order Nbr							HD	[SOP Number] [varchar](25)
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))		
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
	//		//Make sure we have a header for this Detail...
	//		If ldsSOHeader.Find("Upper(invoice_no) = '" + Upper(lstemp) + "'",1, ldsSOHeader.RowCount()) = 0 Then
	//			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header Order Number. Record will not be processed.")
	//			lbDetailError = True
	//		End If		
		lsOrderNbr = lsTemp
	End If				

	//1		Inventory Type						DT	[Location Code from Sales Transaction] [varchar](1)
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Inventory Type is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		lsInvType_Desc = lsTemp
		//lsInvType = lsTemp
	End If	
			
			If Not IsNull(lsInvType_Desc ) OR trim(lsInvType_Desc ) > '' Then					
				Select Inv_Type Into :lsInvType From Inventory_Type with( NoLock) 
				Where Project_id =:asproject and  Inv_Type_Desc =:lsInvType_Desc Using SQLCA;
			End IF		
			
	//2		SKU									DT	[Item Number] [varchar](35)
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - SKU is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		lsSku = lsTemp
	End If	
	
	//3		UofM									DT	[U Of M] [varchar](15)
		lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))	
		If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - UOM is required. Record will not be processed.")
			lbError = True
			Continue		
		Else
			 lsUom = lsTemp
		End If	
	
	//4		UofM									DT	[U Of M Schedule] [varchar](15)
		lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))	
		If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - UOM Schedule is required. Record will not be processed.")
			lbError = True
			Continue		
		Else
			 lsUom = lsTemp			
		End If	
		
	//5		Description							DT	[Item Description] [varchar](110)		//This field doesn't exist in Edi Delivery Detail, available on picking list...
//		lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))	
//		If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Item Description is required. Record will not be processed.")
//			lbError = True
//			Continue		
//		Else
//			lsDesc = lsTemp
//		End If	
		
		//6		Qty									DT	[QTY] [decimal](19, 5)
		lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))	
		If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Qty is required. Record will not be processed.")
			lbError = True
			Continue		
		Else
			ldQty = Dec(lsTemp)
		End If	
		
		//7		Not need, assumed always 1	DT[QTY In Base U Of M] [decimal](19, 5) NOT NULL
		lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))	
//		If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - UOM is required. Record will not be processed.")
//			lbError = True
//			Continue		
//		Else
			 lsUom = lsTemp
//		End If	

		//8		OrderDetail-Price					DT	[Unit Price] [decimal](19, 5)
		If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Price is required. Record will not be processed.")
			lbError = True
			Continue		
		Else
			 ldPrice = Dec(lsTemp)
		End If	
		
		//27	Line_item_no						DT	[Line Item Sequence] [numeric](18, 0)
		lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col27"))	
		If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item No is required. Record will not be processed.")
			lbError = True
			Continue		
		Else
			 llLineItemNo = Long(lsTemp)
		End If	

//DETAIL1. ---------------------------------------------------* ENDDETAIL RECORD Import- Delivery Detail */	--------------------------------------------------//	

//DETAIL2. -----------------------------------------------* BEGIN DETAIL RECORD - Delivery Detail */	--------------------------------------------------//	
//---------Insert to Delivery Detail
		
			lbDetailError = False
			llNewDetailRow = 	ldsSODetail.InsertRow(0)
			llLineSeq ++
					
			//Add Detail level defaults
			ldsSODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsSODetail.SetItem(llNewDetailRow,'project_id', asProject) /*project*/
			ldsSODetail.SetItem(llNewDetailRow,'status_cd', 'N') //Edi Order Detail Status 			
			ldsSODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsSODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))			
			ldsSODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			ldsSODetail.SetItem(llNewDetailRow,'invoice_no',Trim(lsOrderNbr))		//d_ship_detail (invoice_no) 	
			ldsSODetail.SetItem(llNewDetailRow,'Inventory_Type', lsInvType)  //Inventory_Type
			ldsSODetail.SetItem(llNewDetailRow,'Sku',lsSku) /*Sku*/
			ldsSODetail.SetItem(llNewDetailRow,'UOM',lsUOM) /*UOM1*/	  	//UOM level from itemmaster
			ldsSODetail.SetItem(llNewDetailRow,'UOM',lsUOM) /*UOM1*/		//UOM level from itemmaster
			ldsSODetail.SetItem(llNewDetailRow,'UOM',lsUOM) /*UOM1*/		//UOM level from itemmaster
			//ldsSODetail.SetItem(llNewDetailRow,'Description',lsDesc) /*Description */   //This field doesn't exist in Edi Delivery Detail, available on picking list...
			ldsSODetail.SetItem(llNewDetailRow,'Quantity', String(ldQty)) /*Quantity*/		
			ldsSODetail.SetItem(llNewDetailRow,'Price', String(ldPrice)) /*Order Detail Price*/			
			//ldsSODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	//11-Jul-2013 :Madhu Commented
			ldsSODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineSeq) /*Line_Item_No*/	 //11-Jul-2013 :Madhu Added
			ldsSODetail.SetItem(llNewDetailRow,'User_Line_Item_No',string(llLineItemNo)) /*User_Line_Item_No*/	 //11-Jul-2013 :Madhu Added
			
//End of DETAIL RECORD
//DETAIL2. -----------------------------------------------* END DETAIL RECORD - Delivery Detail */	--------------------------------------------------//	
			
/* EOF Header or Detail */	
	
Next /*File record */

//IF lirc = -1 then lbError = true else lbError = false	

//Save the Changes 
SQLCA.DBParm = "disablebind =0"
lirc = ldsSOheader.Update()
SQLCA.DBParm = "disablebind =1"
	
If liRC = 1 Then
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsSOdetail.Update()
	SQLCA.DBParm = "disablebind =1"
	
ELSE
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Header Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If


If liRC = 1 then
//	Commit;

//BCR 12-30-11 Geistlich UAT Session...
//why comment out this Commit? It is the cause of this UOM issue we have found in Geistlich UAT...
Commit;
//End

Else
	
//	Execute Immediate "ROLLBACK" using SQLCA; 
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Delivery Notes Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If

If lbError Then
	Return -1
Else
	Return 0
End If

end function

public function integer uf_process_daily_recon (string asproject, string asinifile);//xlim 04/30/2013 Kinderdijk Daily Inventory snapshot BOH
//(E) Daily Reconciliation Stock Balance	
		//[Item Number] [varchar](35)
		//[LOCTNID] [varchar](15)
		//[QUANTITY] [numeric](19, 5)
		//[Recon Date Time] [DateTime]

//The File name can be ItemQtyYYYYMMDDHHSS.csv (prefix with $$HEX1$$1820$$ENDHEX$$ItemQty$$HEX1$$1920$$ENDHEX$$)
//Note: the $$HEX1$$1820$$ENDHEX$$LOCTNID$$HEX2$$19202000$$ENDHEX$$field should be handled by SIMS as an $$HEX1$$1820$$ENDHEX$$Inventory Type$$HEX2$$19202000$$ENDHEX$$handling. 


Integer	liRC, liFileNo
Long	llRowCount, llRowPos, llNewRow,  llQty
String	lsOutString,  lsLogOut,  lsFIleName, lsproject, lstoday, lsInvType, lsInvType_Desc
string ERRORS, sql_syntax
Decimal	ldBatchSeq
Datastore	 ldsBoh, ldsOut
DateTime	ldtToday, ldtNow, ldtWHTime

//ldtToday = DateTime(Today(), Now())
////ldtToday = GetPacificTime('GMT', ldtToday)
//lsToday= String(ldtToday, 'YYYYMMDDHHMMSS')   	//current_time  

//Convert GMT to SIN Time
ldtNow = DateTime(today(),Now())
select Max(dateAdd( hour, 8,:ldtNow )) into :ldtToday
from sysobjects;
lsToday= String(ldtToday, 'YYYYMMDDHHMMSS')     //SGT time

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Kinderdijk Daily Inventory Snapshot ... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_kinderdijk_dboh'
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: Kinderdijk Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile, asproject,"project","")

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for Pulse BOH confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrive the BOH Data
lsLogout = 'Retrieving Inventory Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//Retrieving ....
llRowCOunt = ldsBOH.Retrieve(lsProject)

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by ','
gu_nvo_process_files.uf_write_log('Processing Balance on Hand Data.....') /*display msg to screen*/

For llRowPos = 1 to llRowCOunt
	
	llNewRow = ldsOut.insertRow(0)
	//lsOutString = 'BH,' /*rec type = balance on Hand Confirmation*/
	lsOutString = ldsBoh.GetItemString(llRowPos,'Sku') + ','					 //+ commaDelimiter					//[Item Number] [varchar](35)
	//lsOutString += ldsBoh.GetItemString(llRowPos,'Inventory_Type') + ','												//[LOCTNID] [varchar](15)  Sims Inventory Type
	lsInvType = Trim(ldsBoh.GetItemString(llRowPos,'Inventory_Type')) 
		If  Not IsNull(lsInvType) OR Trim(lsInvType) > '' Then
			Select Inv_Type_Desc Into :lsInvType_Desc From Inventory_Type with( NoLock) 
			Where Project_id =:asproject and Inv_Type =:lsInvType Using SQLCA;
		End If		
	lsOutString += lsInvType_Desc + ','		
	lsOutString += String(ldsBoh.GetItemNumber(llRowPos,'quantity'),'############0')  + ','				//[QUANTITY] [numeric](19, 5)
	lsOutString += String(ldtToday,'YYYY-MM-DD HH:mm:ss') 															//[Recon Date Time] [DateTime] 	//SGT date/time of BOH file creation

	ldsOut.SetItem(llNewRow,'Project_id', 'KINDERDIJK')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//The File name can be ItemQtyYYYYMMDDHHSS.csv (prefix with $$HEX1$$1820$$ENDHEX$$ItemQty$$HEX1$$1920$$ENDHEX$$)
	//ldsOut.SetItem(llNewRow,'file_name', 'BH' + String(ldbatchSeq,'000000') + ".CSV")  //Jxlim .csv
	lsFileName = "ItemQty" + lstoday + '.csv'
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)  //Jxlim .csv
	
Next /*next output record */

//Write last/Only
If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'KINDERDIJK')
End If



end function

public function integer uf_process_dboh (string asproject, string asinifile);//xlim 04/30/2013 Kinderdijk Daily Inventory snapshot BOH
//(E) Daily Reconciliation Stock Balance	
		//[Item Number] [varchar](35)
		//[LOCTNID] [varchar](15)
		//[QUANTITY] [numeric](19, 5)
		//[Recon Date Time] [DateTime]

//The File name can be ItemQtyYYYYMMDDHHSS.csv (prefix with $$HEX1$$1820$$ENDHEX$$ItemQty$$HEX1$$1920$$ENDHEX$$)
//Note: the $$HEX1$$1820$$ENDHEX$$LOCTNID$$HEX2$$19202000$$ENDHEX$$field should be handled by SIMS as an $$HEX1$$1820$$ENDHEX$$Inventory Type$$HEX2$$19202000$$ENDHEX$$handling. 


Integer	liRC, liFileNo
Long	llRowCount, llRowPos, llNewRow,  llQty
String	lsOutString,  lsLogOut,  lsFIleName, lsproject, lstoday, lsInvType, lsInvType_desc
string ERRORS, sql_syntax
Decimal	ldBatchSeq
Datastore	 ldsBoh, ldsOut
DateTime	ldtToday, ldtNow, ldtWHTime

//ldtToday = DateTime(Today(), Now())
////ldtToday = GetPacificTime('GMT', ldtToday)
//lsToday= String(ldtToday, 'YYYYMMDDHHMMSS')   	//current_time  

//Convert GMT to SIN Time
ldtNow = DateTime(today(),Now())
select Max(dateAdd( hour, 8,:ldtNow )) into :ldtToday
from sysobjects;
lsToday= String(ldtToday, 'YYYYMMDDHHMMSS')  	//SGT time

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Kinderdijk Daily Inventory Snapshot ... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_kinderdijk_dboh'
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: Kinderdijk Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile, asproject,"project","")

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for Pulse BOH confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrive the BOH Data
lsLogout = 'Retrieving Inventory Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//Retrieving ....
llRowCOunt = ldsBOH.Retrieve(lsProject)

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by ','
gu_nvo_process_files.uf_write_log('Processing Balance on Hand Data.....') /*display msg to screen*/

For llRowPos = 1 to llRowCOunt
	
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'BH,' /*rec type = balance on Hand Confirmation*/													
	lsOutString += String(ldtToday,'YYYY-MM-DD HH:mm:ss') + ','												//[Recon Date Time] [DateTime] //SGT time, BOH Creation Date
	lsOutString +=  ldsBoh.GetItemString(llRowPos,'sku') + ','													//[Item Number] [varchar](35)
	lsOutString += String(ldsBoh.GetItemNumber(llRowPos,'Avail_qty'),'############0')  + ','	//[QUANTITY] [numeric](19, 5)
	lsOutString += String(ldsBoh.GetItemNumber(llRowPos,'Alloc_qty'),'############0')  + ','	//[QUANTITY] [numeric](19, 5)
	lsOutString += String(ldsBoh.GetItemNumber(llRowPos,'sit_qty'),'############0')  + ','		//[QUANTITY] [numeric](19, 5)
	lsOutString += String(ldsBoh.GetItemNumber(llRowPos,'quantity'),'############0')  + ','		//[QUANTITY] [numeric](19, 5)	
	//lsOutString += ldsBoh.GetItemString(llRowPos,'inventory_type')	 + ','									//[LOCTNID] [varchar](15)  Sims Inventory Type
	lsInvType = Trim(ldsBoh.GetItemString(llRowPos,'Inventory_Type')) 
		If  Not IsNull(lsInvType) OR Trim(lsInvType) > '' Then
			Select Inv_Type_Desc Into :lsInvType_Desc From Inventory_Type with( NoLock) 
			Where Project_id =:asproject and Inv_Type =:lsInvType Using SQLCA;
		End If		
	lsOutString += lsInvType_Desc + ','		
	
	lsOutString += ldsBoh.GetItemString(llRowPos,'supp_code') + ','											//Supplier code
	lsOutString += ldsBoh.GetItemString(llRowPos,'po_no')														//Po no
	
	ldsOut.SetItem(llNewRow,'Project_id', 'KINDERDIJK')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//ldsOut.SetItem(llNewRow,'file_name', 'BH' + String(ldbatchSeq,'000000') + ".CSV")  //Jxlim .csv baseline
	ldsOut.SetItem(llNewRow,'file_name', 'BH' +  String(ldtToday,'YYYYMMDDHHMMSS') + ".CSV")  //Jxlim .csv baseline	
	ldsOut.SetItem(llNewRow,'dest_cd', 'BOH') /* routed to different folder for processing */ //Jxlim File Print server	
	
Next /*next output record */

//Write last/Only
If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'KINDERDIJK')
End If



end function

public function integer uf_process_dboh_volume ();//Process the Daily Balance on Hand Report

String			sql_syntax, ERRORS, lsLogOut, lsOutString, lsFileName, lsWarehouseSave
Long			llRowPos, llRowCount, llNewRow
Int				liRC
Datastore	ldsBOH, ldsOut
Date			ldToday

ldToday = Today()

lsLogOut = "      Creating KINDERDIJK Daily Balance on Hand-Volume File... " 
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
sql_syntax += "Item_Master.Grp, Item_Master.Description , Item_Master.Alternate_Sku"
sql_syntax += "  From Receive_Master, Content_Summary, Item_Master "
sql_syntax += "  Where Content_Summary.Project_id = 'KINDERDIJK'  and "
sql_syntax += " Content_Summary.Project_id = Receive_MAster.Project_ID and Content_Summary.ro_no = Receive_Master.ro_no "
sql_syntax += " and Content_Summary.project_id = Item_MAster.Project_id and Content_Summary.SKU = Item_Master.SKU and Content_Summary.supp_code = Item_MAster.Supp_code "
sql_syntax += " Group By  complete_Date, Arrival_date, Supp_Invoice_No,  Content_Summary.wh_code, Content_Summary.sku, Content_Summary.supp_code, Content_Summary.l_Code, Content_Summary.Lot_No,  Content_Summary.Po_No, "
sql_syntax +=	" Content_Summary.po_no2, Content_Summary.Serial_no, Content_Summary.Expiration_Date,  Content_Summary.Inventory_Type,  Item_Master.Length_1, Item_Master.Width_1, Item_Master.Height_1, Item_MAster.Weight_1, Item_Master.User_Field8, Grp, Description, Item_Master.Alternate_Sku" 
sql_syntax += " Having Sum( Content_Summary.Avail_Qty  ) > 0 or  Sum( Content_Summary.alloc_Qty  ) > 0 "
sql_syntax += " Order by Content_Summary.wh_Code "

ldsboh.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
 	 lsLogOut = "        *** Unable to create datastore for KINDERDIJK (BOH-Volume Data).~r~r" + Errors
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
			gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'KINDERDIJK')
			ldsOut.Reset()
		End If

		lsFileName = "KINDERDIJK-Daily-BOH-Volume-" + ldsBoh.GetITemString(llRowPos,'wh_code')  + "-" + + String(ldToday,"mm-dd-yyyy") + ".csv"
		
		//Add a column Header Row*/
		llNewRow = ldsOut.insertRow(0)
		//Jxlim 12/21/2010 Added Item_Master.Description and Content_Summary.Serial_no
		//JXLIM 07/01/2010 Added 3 labels (ItemMaster.UserField8, Volume and ItemMaster.Group)
		lsOutString = "WH Code,SKU,Description,Supplier Code,Date Received,Arrival Date,Order Nbr,Location,Inventory Type,Avail Qty,Alloc Qty,Length1,Width1,Height1,Weight1, User_Field8,Volume,Item Group,Alternate SKU "
		ldsOut.SetItem(llNewRow,'Project_id', 'KINDERDIJK')
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
	lsOutString += nonull(ldsBoh.GetITemString(llRowPos,'Grp'))+ ","
	lsOutString += nonull(ldsBoh.GetITemString(llRowPos,'Alternate_Sku'))	

	
	
	ldsOut.SetItem(llNewRow,'Project_id', 'KINDERDIJK')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)
	ldsOut.SetItem(llNewRow,'dest_cd', 'BOH') /* routed to different folder for processing */

		
	lsWarehouseSave = ldsBoh.GetITemString(llRowPos,'wh_code')
	
Next /*Inventory Record*/

//Last/Only warehouse
If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'KINDERDIJK')
End If
		

REturn 0
end function

public function string nonull (string as_str);as_str = trim(as_str)
if isnull(as_str) or as_str = '-' then
	return ""
else
	return as_str
end if
end function

on u_nvo_proc_kinderdijk.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_kinderdijk.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

