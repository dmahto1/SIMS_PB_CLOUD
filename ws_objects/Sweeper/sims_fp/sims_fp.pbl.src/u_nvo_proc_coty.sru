$PBExportHeader$u_nvo_proc_coty.sru
$PBExportComments$Process Maquet files
forward
global type u_nvo_proc_coty from nonvisualobject
end type
end forward

global type u_nvo_proc_coty from nonvisualobject
end type
global u_nvo_proc_coty u_nvo_proc_coty

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsASNHeader,	&
				idsASNPackage,	&
				idsASNItem
				
// pvh - 03/16/06
datastore idswhXref  // used as cross reference between phxbrands 2 digit wh code and our alpha one.

int iiP1, iiP2

datastore	iu_DS
				
u_ds_datastore	idsItem 
u_ds_datastore ids_import
				
end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_itemmaster (string aspath, string asproject)
protected function integer uf_process_po (string aspath, string asproject)
public function integer xuf_process_po (string aspath, string asproject)
public function integer uf_delete_leftovers ()
public function integer uf_process_ds (string aspath, string asproject)
public function integer uf_process_dboh (string asproject, string asinifile)
public function string uf_replace_quote (ref string as_string)
public function string uf_check_unicode (string as_string)
public function string uf_get_next_element (string aselement)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);
String	lsLogOut, lsSaveFileName, lsStringData

Integer	liRC, liFileNo

Boolean	bRet

If Left(asFile, 4) = 'N943' Then /* PO File*/
	liRC = uf_process_po(asPath, asProject)
	//Process any added PO's
	If liRC = 0 Then
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
	End If
ElseIf Left( asFile, 2 ) = 'SO' Then /* DO File*/
	liRC = uf_process_so( asPath, asProject )
	If liRC = 0 Then
		liRC = gu_nvo_process_files.uf_process_delivery_order(asProject) 
	End If
	
/*
ElseIf Left(asFile, 4) =  'N940' Then /* Sales Order Files from LMS to SIMS*/
	liRC = uf_process_so(asPath, asProject)
	//Process any added SO's
	//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
	liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
ElseIf Left(asFile, 4) =  'N832' Then 
	liRC = uf_process_itemMaster(asPath, asProject)
*/
Else /*Invalid file type*/
	lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
	FileWrite(gilogFileNo, lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogout)
	Return -1
End If

Return liRC
end function

public function integer uf_process_so (string aspath, string asproject);Long ll_rc = 0
String lsLogOut, lsStringData, lsData, lsTemp
String lsOrderNo, lsAttribute, lsProductSize, lsStyleNumber, lsGTIN, lsQty
String lsProject, lsWarehouse, lsCustName, lsParentSKU, lsChildSku, lsSupplier, lsNoteHeading, lsNoteText1, lsNoteText2, lsNoteType
Int liRtnImp, liRC, liPos, liODNbr, liNoteLength, liRows, liNoteSeqNo
Long llNewRow, llNewDetailRow, llNewBOMRow, llfileRowPos, llFileRowCount, llOrderSeq, llNewNoteRow
Long llLineSeq, llBatchSeq, llLineItemNo, llOrderLineNo, llChildQty
Boolean lbError, lbParentSKU
DateTime	ldtToday

string quote = String(Blob(Char(34)), EncodingANSI!)
string comma = ','
string tabchar = '~t'
string pipechar = '|'
string delimiter = comma	// set up the system to use comma as the default delimiter

u_ds_datastore	ldsSOheader, ldsSOdetail, ldsDOBOM, ldsDONotes

ldsSOheader = Create u_ds_datastore
ldsSOheader.dataobject= 'd_baseline_unicode_shp_header'
ldsSOheader.SetTransObject(SQLCA)

ldsSOdetail = Create u_ds_datastore
ldsSOdetail.dataobject= 'd_baseline_unicode_shp_detail'
ldsSOdetail.SetTransObject(SQLCA)

ids_import = Create u_ds_datastore
ids_import.dataobject= 'd_import_generic_csv'
ids_import.SetTransObject(SQLCA)

ldsDOBOM = Create u_ds_datastore
ldsDOBOM.dataobject = 'd_delivery_bom'
ldsDOBOM.SetTransObject(SQLCA)

ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes'
ldsDONotes.SetTransObject(SQLCA)

ldtToday = DateTime(today(),Now())
liODNbr = 0		// OD rows are placement specific - OD# 1 = Delivery Detail row for order, OD# 2 - 5 Are Order Notes, OD# 6 - n are Delivery_BOM rows as component children

/**************************************/
lsLogOut = '      - Opening File for Coty SO Import Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)

If liRtnImp < 0 Then
	lsLogOut = "-       ***Unable to Open Customer Master File for Warner Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
ll_rc = FileReadEx( liRtnImp,lsStringData)

Do While ll_rc > 0
	llNewRow = ids_import.InsertRow(0)
	ids_import.SetItem(llNewRow,'column1',Trim(lsStringData))
	ll_rc = FileReadEx(liRtnImp,lsStringData)
Loop /*Next File record*/

lsStringData = ''
FileClose( liRtnImp )

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Outbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1
	
//Process each Row
llFileRowCount = ids_import.RowCount()

For llfileRowPos = 1 to llFileRowCount
	
	w_main.SetMicroHelp("Processing Delivery Record " + String(llFileRowPos) + " of " + String(llFilerowCount))
	
	lsData = Trim(ids_import.GetITemString(llFileRowPos,'column1' ) )

	//Make sure first Char is not a delimiter
	If Left(lsData,1) = delimiter Then
		lsData = Right( lsData,Len( lsData ) - 1)
	End If
	
	//Validate Rec Type is OH (Header) or OD (Detail)
	lsTemp = Left( lsData,(pos(lsData,delimiter ) - 1))
	If lsTemp <> 'OH' and lsTemp <> 'OD' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If
	
	
	//Process Header Row
	If lsTemp = 'OH' Then
		lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		lsTemp = Left( lsData,( pos( lsData, delimiter  ) - 1 ))
		
		llNewRow = 	ldsSOheader.InsertRow(0)
		llOrderSeq ++
		llLineSeq = 0	
		
		//Order Number
		ldsSOheader.SetItem(llNewRow,'order_no', lsTemp )
		ldsSOheader.SetItem(llNewRow,'invoice_no', lsTemp )
		
		lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1)))
		lsTemp = Left( lsData,( pos( lsData, delimiter  ) - 1 ))

		//Shipping Method (Grd, Air, etc)
		ldsSOheader.SetItem(llNewRow,'ship_via', lsTemp )
		
		lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) 
		lsTemp = Left( lsData,( pos( lsData, delimiter  ) - 1 ))

		//Warehouse Code
		ldsSOheader.SetItem(llNewRow,'wh_code',lsTemp )

		lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) 
		lsTemp = Left( lsData,( pos( lsData, delimiter  ) - 1 ))

		//Order Date
		ldsSOheader.SetItem(llNewRow,'ord_date',lsTemp )

		//Customer Name
		lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) 
		lsTemp = uf_get_next_Element(lsData)
		lsCustName = lsTemp
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)
		
		lsCustName += ' ' + lsTemp
		ldsSOheader.SetItem(llNewRow,'cust_name', lsCustName )
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//Address1
		ldsSOheader.SetItem(llNewRow,'address_1', uf_replace_quote(lsTemp))
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//Address2
		ldsSOheader.SetItem(llNewRow,'address_2', uf_replace_quote(lsTemp))
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//Address3
		ldsSOheader.SetItem(llNewRow, 'address_3', uf_replace_quote(lsTemp))
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//City
		ldsSOheader.SetItem(llNewRow,'city', uf_replace_quote(lsTemp))
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//Province
		ldsSOheader.SetItem(llNewRow,'state', uf_replace_quote(lsTemp))
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//Postal Code
		ldsSOheader.SetItem(llNewRow,'zip', lsTemp )
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//Country
		ldsSOheader.SetItem(llNewRow,'country', lsTemp )
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//Email
		ldsSOheader.SetItem(llNewRow,'email_address', lsTemp )
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//Phone
		ldsSOheader.SetItem(llNewRow,'tel', lsTemp )
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//CustomAttribute1
		ldsSOheader.SetItem(llNewRow,'user_field1', lsTemp )
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//CustomAttribute2
		ldsSOheader.SetItem(llNewRow,'user_field2', lsTemp )
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//CustomAttribute3
		ldsSOheader.SetItem(llNewRow,'user_field3', lsTemp )
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//CustomAttribute4
		ldsSOheader.SetItem(llNewRow,'user_field4', lsTemp )
		
		lsData = Right(lsData, iiP2) 
		lsTemp = uf_get_next_Element(lsData)

		//CustomAttribute5
		ldsSOheader.SetItem(llNewRow,'user_field5', lsTemp )

		//Start New Record Defaults
		ldsSOheader.SetItem(llNewRow,'project_id',UPPER( asProject ) )
		ldsSOheader.SetItem(llNewRow,'edi_batch_seq_no',llBatchSeq )
		ldsSOheader.SetItem(llNewRow,'order_seq_no',llOrderSeq )
		ldsSOheader.SetItem(llNewRow,'action_cd', 'A' )
		ldsSOheader.SetItem(llNewRow,'ftp_file_name', aspath )
		ldsSOheader.SetItem(llNewRow,'order_type', 'S' )
		ldsSOheader.SetItem(llNewRow,'cust_code', 'CUSTOMER' )
		ldsSOheader.SetItem(llNewRow,'status_cd', 'N' )
		ldsSOheader.SetItem(llNewRow,'last_user', 'SIMSEDI' )
		//End New Record Defaults
		
		//liNoteSeqNo for all notes
		liNoteSeqNo = 1

	ElseIf lsTemp = 'OD' Then	//Process Detail Row
		liODNbr ++
		
		//Pull all into varianles
			lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			lsTemp = Left( lsData,( pos( lsData, delimiter  ) - 1 ))
		lsOrderNo = lsTemp
			lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			lsTemp = Left( lsData,( pos( lsData, delimiter  ) - 1 ))
		If lsParentSKU = '' Then		//First OD record
			lsParentSKU = lsTemp
			lbParentSKU = TRUE
		Else
			lsChildSKU = lsTemp
			lbParentSKU = FALSE
		End If
			lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			lsTemp = Left( lsData,( pos( lsData, delimiter  ) - 1 ))
		lsAttribute = lsTemp
			lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			lsTemp = Left( lsData,( pos( lsData, delimiter  ) - 1 ))
		lsProductSize = lsTemp
			lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			lsTemp = Left( lsData,( pos( lsData, delimiter  ) - 1 ))
		lsStyleNumber = lsTemp		
			lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			lsTemp = Left( lsData,( pos( lsData, delimiter  ) - 1 ))
		lsGTIN = lsTemp		
			lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			If pos( lsData, delimiter ) = 0 Then		//Last element?
				lsTemp = lsData
			Else
				lsTemp = Left( lsData,( pos( lsData, delimiter  ) - 1 ))
				lsQty = lsTemp
				
				lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
				lsTemp = Left( lsData,( pos( lsData, delimiter  ) - 1 ))
				lsNoteHeading = uf_replace_quote( lsTemp )

				lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
				lsTemp = Left( lsData,( pos( lsData, quote, 2  ) - 1 ))		//Look for the second quote (could have comma in quotes)
				lsNoteText1 = uf_replace_quote( lsTemp )
				lsNoteText1 = uf_check_unicode( lsTemp )
				liNoteLength = Len( lsNoteText1 )
				If liNoteLength > 255 Then
					lsNoteText2 = Right( lsNoteText1, liNoteLength - 255 )
					lsNoteText1 = Left( lsNoteText1, 255 )
				Else
					lsNoteText2 = ''
				End If
			End If
		
		CHOOSE CASE liODNbr
			CASE 1
				llNewDetailRow = 	ldsSOdetail.InsertRow(0)
				llLineSeq ++	
				llOrderLineNo ++
				llLineItemNo ++
			
				//Order/Invoice Number
				ldsSOdetail.SetItem(llNewDetailRow,'invoice_no', lsOrderNo )
				//SKU
				ldsSOdetail.SetItem(llNewDetailRow,'sku', lsParentSKU )
				//Attribute
				ldsSOdetail.SetItem(llNewDetailRow,'user_field1', lsAttribute )
				//ProductSize
				ldsSOdetail.SetItem(llNewDetailRow,'user_field2', lsProductSize )
				//StyleNumber
				ldsSOdetail.SetItem(llNewDetailRow,'user_field3', lsStyleNumber )
				//GTIN
				ldsSOdetail.SetItem(llNewDetailRow,'gtin', lsGTIN )
				//Quantity
				ldsSOdetail.SetItem(llNewDetailRow,'quantity', lsQty )
				//Leaflet ID to User_Field1
				ldsSOdetail.SetItem(llNewDetailRow,'user_field1', lsNoteHeading )
				
				//Start New Record Defaults
				ldsSOdetail.SetITem(llNewDetailRow,'project_id',upper( asProject ) ) 
				ldsSOdetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq)
				ldsSOdetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 		
				ldsSOdetail.SetItem(llNewDetailRow,'order_line_no',String( llOrderLineNo ) )
				ldsSOdetail.SetItem(llNewDetailRow,'line_item_no', llLineItemNo  )
				ldsSOdetail.SetItem(llNewDetailRow,'supp_code', 'COTY' )
				ldsSOdetail.SetItem(llNewDetailRow,'inventory_type', 'N' )
				ldsSOdetail.SetItem(llNewDetailRow,'UOM', 'EA' )
				ldsSOdetail.SetItem(llNewDetailRow,'status_cd', 'N' )
				//End New Record Defaults
				
			CASE ELSE		//First Notes Record
				// ProjectId,EDIiBatchSeqNo,OrderSeqNo,invoiceNo,LineItemNo,NoteType,NoteSeqNo,NoteText
				// Two or three note records based on the length of lsNoteText1.  Two if length less than 256 three if more
				lsNoteType = ''
				CHOOSE CASE liODNbr
					CASE 2
						lsNoteType = 'C'
					CASE 3
						lsNoteType = 'D' 
					CASE 4
						lsNoteType = 'S' 
					CASE 5
						lsNoteType = 'M' 
				END CHOOSE

				IF lsNoteType <> '' Then
					llNewNoteRow = ldsDONotes.InsertRow(0)		// Note Heading Row
					ldsDONotes.SetITem(llNewNoteRow,'project_id',asProject) 
					ldsDONotes.SetItem(llNewNoteRow,'edi_batch_seq_no',llbatchseq) 
					ldsDONotes.SetItem(llNewNoteRow,'order_seq_no',llOrderSeq) 
					ldsDONotes.SetItem(llNewNoteRow,'line_item_no',llLineItemNo) 
					ldsDONotes.SetItem(llNewNoteRow,'invoice_no',lsOrderNo) 
					ldsDONotes.SetItem(llNewNoteRow,'note_type',lsNoteType ) 
					ldsDONotes.SetItem(llNewNoteRow,'note_seq_no',liNoteSeqNo ) 
					liNoteSeqNo ++	//For next 
					ldsDONotes.SetItem(llNewNoteRow,'note_text',lsNoteHeading ) 
					
					llNewNoteRow = ldsDONotes.InsertRow(0)		// Note Text 1 Row
					ldsDONotes.SetITem(llNewNoteRow,'project_id',asProject) 
					ldsDONotes.SetItem(llNewNoteRow,'edi_batch_seq_no',llbatchseq) 
					ldsDONotes.SetItem(llNewNoteRow,'order_seq_no',llOrderSeq) 
					ldsDONotes.SetItem(llNewNoteRow,'line_item_no',llLineItemNo) 
					ldsDONotes.SetItem(llNewNoteRow,'invoice_no',lsOrderNo) 
					ldsDONotes.SetItem(llNewNoteRow,'note_type',lsNoteType ) 
					ldsDONotes.SetItem(llNewNoteRow,'note_seq_no',liNoteSeqNo ) 
					liNoteSeqNo ++	//For next 
					ldsDONotes.SetItem(llNewNoteRow,'note_text',lsNoteText1 ) 
			
					If lsNoteText2 <> '' Then
						llNewNoteRow = ldsDONotes.InsertRow(0)		// Note Text 2 Row
						ldsDONotes.SetITem(llNewNoteRow,'project_id',asProject) 
						ldsDONotes.SetItem(llNewNoteRow,'edi_batch_seq_no',llbatchseq) 
						ldsDONotes.SetItem(llNewNoteRow,'order_seq_no',llOrderSeq) 
						ldsDONotes.SetItem(llNewNoteRow,'line_item_no',llLineItemNo) 
						ldsDONotes.SetItem(llNewNoteRow,'invoice_no',lsOrderNo) 
						ldsDONotes.SetItem(llNewNoteRow,'note_type',lsNoteType ) 
						ldsDONotes.SetItem(llNewNoteRow,'note_seq_no',liNoteSeqNo ) 
						liNoteSeqNo ++	//For next 
						ldsDONotes.SetItem(llNewNoteRow,'note_text',lsNoteText2 ) 
					End If
				End If
				
				llNewBOMRow = ldsDOBOM.InsertRow(0)
				ldsDOBOM.SetITem(llNewBOMRow,'project_id',asProject) 
				ldsDOBOM.SetItem(llNewBOMRow,'edi_batch_seq_no',llbatchseq) 
				ldsDOBOM.SetItem(llNewBOMRow,'order_seq_no',llOrderSeq) 
				ldsDOBOM.SetItem(llNewBOMRow,'line_item_no',llLineItemNo) 
				ldsDOBOM.SetItem(llNewBOMRow,'sku_parent',lsParentSKU) 
				ldsDOBOM.SetItem(llNewBOMRow,'sku_child',lsChildSku) 
				ldsDOBOM.SetItem(llNewBOMRow,'supp_code_parent',asProject) 
				ldsDOBOM.SetItem(llNewBOMRow,'supp_code_child',asProject) 
				ldsDOBOM.SetItem(llNewBOMRow,'user_field1',lsAttribute) 
				ldsDOBOM.SetItem(llNewBOMRow,'user_field2',lsProductSize ) 
				ldsDOBOM.SetItem(llNewBOMRow,'user_field3',lsStyleNumber) 
				ldsDOBOM.SetItem(llNewBOMRow,'user_field4',lsGTIN ) 
				ldsDOBOM.SetItem(llNewBOMRow,'inventory_type',"N" ) 
				If isnumber( lsQty ) Then //Validate QTY for Numerics
					llChildQty = dec( lsQty ) 
				Else
					llChildQty = 1
				End If
				ldsDOBOM.SetItem(llNewBOMRow,'child_Qty',llChildQty) 
				
		END CHOOSE
			
	End If		// Next OD
	
Next

w_main.SetMicroHelp( "Ready" )

IF lirc = -1 then 
	lbError = true 
else 
	lbError = false	

	//Save the Changes 
	SQLCA.DBParm = "disablebind =0"
	lirc = ldsSOheader.Update()
	SQLCA.DBParm = "disablebind =1"
	
	If liRC = 1 Then
		SQLCA.DBParm = "disablebind =0"
		liRC = ldsSOdetail.Update()
		SQLCA.DBParm = "disablebind =1"
	
		If liRC = 1 Then
			SQLCA.DBParm = "disablebind =0"
			liRC = ldsDOBOM.Update()
			SQLCA.DBParm = "disablebind =1"
			
			If liRC <> 1 Then
				lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO BOM Records to database!"
				FileWrite(gilogFileNo,lsLogOut)
				gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO BOM Records to database!")
				Return -1
			Else
				SQLCA.DBParm = "disablebind =0"
				liRC = ldsDONotes.Update()
				SQLCA.DBParm = "disablebind =1"
				
				If liRC <> 1 Then
					lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Notes Records to database!"
					FileWrite(gilogFileNo,lsLogOut)
					gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Notes Records to database!")
					Return -1
				End If
			End If
		ELSE
			lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Detail Records to database!"
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Detail Records to database!")
			Return -1
		End If
	Else
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Header Records to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
		Return -1
	End If
	
	
	If liRC = 1 then

		Commit;
	
	Else
		
	//	Execute Immediate "ROLLBACK" using SQLCA; 
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Delivery Detail Records to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
		Return -1
	End If
End If


return 0

end function

public function integer uf_process_itemmaster (string aspath, string asproject);//Process Item Master (IM) Transaction for Coty
	Return 0


end function

protected function integer uf_process_po (string aspath, string asproject);/* Import of Purchase Order for COTY
- Coty will have multiple shipments against an Order (with a different Delivery Date)
- SIMS will create a distinct Receive_Master record for each PO/Date combo (actually, Orig/Dest/PO/Date)

**** 07/11/07 ****
Now disregarding Ship Date and treating orders similar to blanket POs
 - We will delete all orders in 'New' status nightly
 - We will treat every detail line as an Add
   - if we have a matching PO in New status, we will add the SKU/Qty to it.
*/

Datastore	lu_dsImport, ldsRMaster, ldsRDetail

String	lsLogout, lsStringData, lsOrder, lsWarehouse, lsTemp, lsRecData, lsRecType, lsDesc
//not used for COTY , lsSKU, lsSupplier
Integer	liRC,liFileNo
Long		llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llOwnerID
Boolean	lbError, lbDetailError
DateTime	ldtToday, ldtDelivery
Decimal	ldWeight, ldLineItemNo
String 	lsOrderNo, lsActionCd, lsShipRef, lsCarrier, lsAWB, lsMode, lsRemark, lsOrdType
long llRMasterCount, llExistingBatch, llNewBatch, llPOHeaderCount
string lsSKU, lsQTY, lsInvType, lsAltSKU, lsLot, lsPONO, lsPONO2, lsSerial, lsOldQty, lsLineNo
decimal ldQty
long llLineRow, llRDExists
boolean lbHeaderUpdated, lbDetailUpdated

ldtToday = DateTime(Today(),Now())

lu_dsImport = Create datastore
lu_dsImport.dataobject = 'd_generic_import'

//ldsItem = Create u_ds_datastore
//ldsItem.dataobject= 'd_item_master'
//ldsItem.SetTransObject(SQLCA)

ldsRMaster = Create u_ds_datastore
ldsRMaster.dataobject= 'd_receive_master'
ldsRMaster.SetTransObject(SQLCA)

ldsRDetail = Create u_ds_datastore
ldsRDetail.dataobject= 'd_receive_detail'
ldsRDetail.SetTransObject(SQLCA)

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

//07/07 - PCONKL - reset datastores
idsPOHeader.Reset()
idsPODetail.REset()

//Open and read the File In
lsLogOut = '      - Opening File for Coty Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath, LineMode!, Read!, LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Coty Processing: " + asPath
	FileWrite(giLogFileNo, lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo, lsStringData)

Do While liRC > 0
	llNewRow = lu_dsImport.InsertRow(0)
	lu_dsImport.SetItem(llNewRow, 'rec_data', Trim(lsStringData)) /*record data is the rest*/
	liRC = FileRead(liFileNo, lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Warehouse defaulted from project master default warehouse - only need to retrieve once
Select wh_code into :lsWarehouse
From Project
Where Project_id = :asProject;

/* Moved below to get new batch no for each header
    (to avoid adding up all quantity's from edi_inbound_detail for associated order)
*/
//Get the next available file sequence number
//llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
//If llBatchSeq <= 0 Then Return -1
/*
!!!!!!
Need to create a single edi_inbound_header/detail combo for an open PO (line)
 - check for open PO
 - if Open, grab edi_batch_seq_no
 -  update(?) edi_inbound_header
 -  Add qty to edi_inbound_detail
 .....


!!!!!!
*/

//Process Each Record in the file..

//Process each row of the File
llRowCount = lu_dsImport.RowCount()

For llRowPos = 1 to llRowCount
	
	lsrecData = Trim(lu_dsImport.GetItemString(llRowPos, 'rec_Data'))
	lsRecType = Left(lsRecData, 2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsRecType)
			
		Case 'PM' /*PO Header*/
			/*
			Retrieve any Open Receive Master records for this Order (and get edi_batch_seq_no)
			We'll create a single EDI_Detail record for each distinct Order Line 
			no matter how many rows are in the file (multiple ShipDates for single Order)
			
			We had to move the setting of idsPOHeader fields to after we determine if we
			have an existing EDI Record.
			*/
			
			//grab data from file...
			lsRecData = Right(lsRecData, (len(lsRecData) - 3)) /*strip off to first column after rec type */
			//Action Code - 			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'AcCtion Code' field. Record will not be processed.")
			End If
			//idsPOheader.SetItem(llNewRow, 'action_cd', lstemp)
			lsActionCd = lsTemp
		
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Order Number
			If Pos(lsRecData, '|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData, '|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsOrderNo = trim(lsTemp)
			//idsPOheader.SetItem(llNewRow, 'order_no', Trim(lsTemp))
		
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//No more required fields after Supplier
			//Supplier 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			//? Always use 'COTY' for supplier?
			//If lsTemp > '' Then
			//	//not used for COTY: lsSupplier = lsTemp /*used to build item master below if necessary*/
			//	idsPOheader.SetItem(llNewRow, 'supp_code', lsTemp)
			//Else
				//idsPOheader.SetItem(llNewRow, 'supp_code', 'COTY') /* default to Coty */
			//End If
			
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Expected Arrival Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsShipRef = lsTemp
			//idsPOHeader.SetItem(llNewRow, 'Arrival_Date', lsTemp)
//TEMPO!!! - need to set SHIP_REF! - and check to see if it already exists.
			//idsPOHeader.SetItem(llNewRow, 'Ship_Ref', lsTemp)  //should make sure it's a date and force the format ('yyyy-mm-dd'?)
			/* Unique order for Coty is Orig/Dest/PO/ShipmentDate. Check for existence here. 
			If one doesn't exist, set action to 'Z'. This will force PO process to create a new order 
			regardless (if PO already exists).
			*/
					
/* 200070712 - commented out as we're ignoring Ship date now...

			//7/10/07 If idsPOHeader.GetItemString(llNewRow, 'Action_cd') = 'A' and lsTemp > '' Then
			If idsPOHeader.GetItemString(llNewRow, 'Action_cd') = 'X' and lsTemp > '' Then
				Select Count(*) into :llCount
				From Receive_Master 
				Where Project_id = 'COTY' and Supp_Invoice_No = :lsOrderNo and arrival_date = :lsTemp;
				If llCount = 0 Then
					idsPOHeader.SetItem(llNewRow, 'action_cd', 'Z') /*add regardless*/
				End If				
			End If
*/

			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Warehouse
			//Only single warehouse at this time (COTY-WARSA)...
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
				
			//Should we validate that it's COTY-WARSA?
			//If lsTemp <> 'COTY-WARSA' Then
			//	lbError = True
			//	gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse: '" + lsTemp + "'. Order will not be processed.") 
			//End If
			
//			Select warehouse.wh_Code into :lsWarehouse
//			From Warehouse, Project_warehouse
//			Where warehouse.wh_Code = project_warehouse.wh_Code and project_id = :asProject and User_Field1 = :lsTemp;
//			
//			If lsWarehouse = "" Then
//				lbError = True
//				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse: '" + lsTemp + "'. Order will not be processed.") 
//			End If
//			
//			idsPOheader.SetItem(llNewRow,'wh_Code',lsWarehouse)
			//idsPOheader.SetItem(llNewRow, 'wh_Code', 'COTY-WARSA')
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Carrier
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			//idsPOheader.SetItem(llNewRow, 'Carrier',lsTemp)
			lsCarrier = lsTemp
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//AWB
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			//idsPOheader.SetItem(llNewRow, 'Awb_bol_no', lsTemp)
			lsAWB = lsTemp
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Transport Mode
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			//idsPOheader.SetItem(llNewRow, 'transport_mode',lsTemp)
			lsMode = lsTemp
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Remarks
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			//idsPOheader.SetItem(llNewRow, 'remark', lsTemp)
			lsRemark = lsTemp
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Order Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			// Coty will send 'PO' or 'IT' 
			if lsTemp = 'PO' then
				// Supplier Purchase Order
				lsOrdType = 'S'
			elseif lsTemp = 'IT' then
				// Inventory Transfer order
				lsOrdType = 'I'
			end if
			//idsPOheader.SetItem(llNewRow, 'Order_Type', lsTemp)
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//see if there is an open order for lsOrderNo...
			//lsSupplier = idsPOHeader.GetItemString(llheaderPos,'supp_code')
			//llBatchSeq = idsPOHeader.GetItemNumber(llHeaderPos,'edi_batch_seq_no')
			//llOrderSeq = idsPOHeader.GetItemNumber(llHeaderPos,'order_seq_no')

/*
string lsOrigSQL, lsWhere, lsModify
integer liWherePos
lsOrigSql = ldsRMaster.GetSqlSelect()
liWherePos = Pos (lsOrigSql, 'Where')
lsOrigSQL = left(lsOrigSql, liWherePos - 1)
lsWhere = " Where Project_id = 'COTY' and Supp_Invoice_No = '" + lsOrderNo + "' and ord_status = 'N'"
//lsModify = 'DataWindow.Table.Select="' + lsOrigSql + " where ro_no  = '" + lsRoNo + "' and Project_id = '" + lsProject + "'" + '"'
lsModify = 'DataWindow.Table.Select="' + lsOrigSql + lsWhere + '"'
ldsRMaster.Modify(lsModify)
*/
			llExistingBatch = 0
			llRMasterCount = 0 /* 07/07 - PCONKL*/
			llPOHeaderCount = idsPOHeader.Find("Project_id = 'COTY' and Order_No = '" + lsOrderNo + "'", 1, idsPOHeader.RowCount())
			if llPOHeaderCount > 0 then
				//Order exists previously in this file (even if not already in database)
				llExistingBatch = idsPOHeader.GetItemNumber(llPOHeaderCount, 'edi_batch_seq_no')
				if llExistingBatch < 0 then llExistingBatch = 0  // - 08/02/07
				llBatchSeq = llExistingBatch
				llOrderSeq = idsPOHeader.GetItemNumber(llPOHeaderCount, 'order_seq_no') /* 07/07 - PCONKL- Batch Seq and Order SEQ need to match when adding a detail to an existing header*/
				
//			else /* 07/07 - PCONKL - commented out - I don;t think we care that a Receive Master record already exists*/
//				llRMasterCount = ldsRMaster.Retrieve(asProject, lsOrderNo)
//				llRMasterCount = ldsRMaster.SetFilter("ord_status = 'N'")
//				llRMasterCount = ldsRMaster.Filter()
//				llRMasterCount = ldsRMaster.RowCount()
//				if llRMasterCount > 0 then
//					/*Not already in this file, but there's an open order in ReceiveMaster.
//					  If we're already processing an order, commit the changes... */
//					if lbHeaderUpdated then
//						liRC = idsPOHeader.Update()
//						lbHeaderUpdated = False
//					end if
//					if lbDetailUpdated then
//						liRC = idsPODetail.Update()
//						lbDetailUpdated = False
//					end if
//					if ldsRDetail.RowCount() > 0 then
//						liRC = ldsRDetail.Update()
//					end if
//					commit;
//					llExistingBatch = ldsRMaster.GetItemNumber(1, 'edi_batch_seq_no')
//					llBatchSeq = llExistingBatch
//					//?Need to get Ord_Seq too???
//					//Grab all exising EDI_Inbound_Detail records for BatchSeq...
//					liRC = idsPODetail.Retrieve(asProject, llExistingBatch, lsOrderNo)
//				elseif llRMasterCount = -1 then
//					//messagebox ("ERROR", SQLCA.SQLErrText)
//				end if
			end if
			
			if llPOHeaderCount + llRMasterCount = 0 then //Not already loaded from this file and no Open Inbound Order for lsOrderNo
			
				lbHeaderUpdated = True
				//Get the next available file sequence number
				llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
				If llBatchSeq <= 0 Then Return -1
				llNewRow = 	idsPOheader.InsertRow(0)
				llOrderSeq ++
				//llOrderSeq = 1 //always 1?  Only increment if it's a different order?
				// 08/02/07 not resetting LineSeq (Causes Duplicate Key Violation) llLineSeq = 0
				//   - May have issue still if PO 'ABC' drops in more than one file (in a single day)
				//New Record Defaults
				idsPOheader.SetItem(llNewRow, 'project_id', asProject)
				idsPOheader.SetItem(llNewRow, 'wh_code', lsWarehouse)
				idsPOheader.SetItem(llNewRow, 'Request_date', String(Today(), 'YYMMDD'))
				idsPOheader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
				idsPOheader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
				idsPOheader.SetItem(llNewRow, 'ftp_file_name', asPath) /*FTP File Name*/
				idsPOheader.SetItem(llNewRow, 'Status_cd', 'N')
				idsPOheader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
				//idsPOheader.SetItem(llNewRow, 'Order_type', 'S') /*Supplier Order*/
				idsPOheader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
				//... From the file...
				idsPOheader.SetItem(llNewRow, 'action_cd', lsActionCd) 
				idsPOheader.SetItem(llNewRow, 'order_no', lsOrderNo)
				idsPOheader.SetItem(llNewRow, 'supp_code', 'COTY') /* default to Coty */
				idsPOHeader.SetItem(llNewRow, 'Arrival_Date', lsShipRef)
				idsPOHeader.SetItem(llNewRow, 'Ship_Ref', lsShipRef)  //should make sure it's a date and force the format ('yyyy-mm-dd'?)
				idsPOheader.SetItem(llNewRow, 'wh_Code', 'COTY-WARSA')
				idsPOheader.SetItem(llNewRow, 'Carrier', lsCarrier)
				idsPOheader.SetItem(llNewRow, 'Awb_bol_no', lsAWB)
				idsPOheader.SetItem(llNewRow, 'transport_mode',lsMode)
				idsPOheader.SetItem(llNewRow, 'remark', lsRemark)
				idsPOheader.SetItem(llNewRow, 'Order_Type', lsOrdType)
				
			elseif llExistingBatch = 0 then
				llLineSeq = 0
				
				// do we want to update any of the EDI Header fields?  What about Arrival Date
				//? how will this trigger? It's not a new edi Header Record (dw passed to uf?)
				//llExistingBatch = ldsRMaster.GetItemNumber(1, 'edi_batch_seq_no')
				//llBatchSeq = llExistingBatch
				//?Need to get Ord_Seq too???]
				
			end if


		CASE 'PD' /* detail*/
			lbDetailError = False

			//grab data from file...
			lsRecData = Right(lsRecData, (len(lsRecData) - 3)) /*strip off to first column after rec type */
			//Action Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'ACtion Code' field. Record will not be processed.")
				lbDetailError = True
			End If
			lsActionCd = lsTemp

			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Number' field. Record will not be processed.")
				lbDetailError = True
			End If
			lsOrderNo = lsTemp
			//Make sure we have a header for this Detail...
			//If idsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'", 1, idsPoHeader.RowCount()) = 0 Then
//TEMPO!!! Will there be more than one Order/Shipment(Date) combination in a single file?
//Yes, need to do the find based on order/shipment (but shipment is no longer in the record, need date!)
//actually, we've already set Order_Seq_no for this detail line, so...	

//  07/18/07 -  Only doing the Find if we aren't using a pre-existing BatchSeq...
			if llExistingBatch = 0 then
				If idsPoHeader.Find("Upper(order_no) = '" + Upper(lsOrderNo) + "'", 1, idsPoHeader.RowCount()) = 0 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Detail Order Number does not match header Order Number. Record will not be processed.")
					lbDetailError = True
				End If
			end if
			
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Line Item Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Line Item Number' field. Record will not be processed.")
				lbDetailError = True
			End If
			lsLineNo = lsTemp
			If Not isnumber(lsLineNo) Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - 'Line Item' is not numeric. Record will not be processed.")
				lbDetailError = True
			Else
				//idsPODetail.SetItem(llNewDetailRow, 'line_item_no',Dec(Trim(lsTemp)))
			End If
		
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Upper(Left(lsRecData, (pos(lsRecData,'|') - 1)))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				lbDetailError = True
			End If						
			lsSKU = lsTemp
		
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Qty
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
			lsQty = lsTemp
		
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		// *** No more required fields...
			//Inventory Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsInvType = lsTemp
						
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Alternate SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
			lsAltSku = lsTemp
						
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//lot No
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsLot = lsTemp
						
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//PO NO - We will be mapping PKG Code below to PO_NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsPONO = lsTemp
			
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//PO NO 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsPONO2 = lsTemp
						
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Serial No
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsSerial = lsTemp
						
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			//Expiration date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			//lsExpDate = lsTemp
						
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsPONO = lsTemp
						
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//lbExistingLine = false
			llLineRow = 0
			llRDExists = 0
			
			if llExistingBatch > 0 then
				
				//There's an open Inbound Order for this PO. Check for Line (in EDI_Inbound_Detail)
				//? Can we assume all the associated detail immediately follows the header?
				llLineRow = idsPODetail.Find("Project_id = 'COTY' and Order_No = '" + lsOrderNo + "' and line_item_no = " + lsLineNo, 1, idsPODetail.RowCount())
				/* Need to update Receive Detail line, if it exists. */
				//llRDLine = ldsRDetail.Find("Project_id = 'COTY' and Order_No = '" + lsOrderNo + "' and line_item_no = " + lsLineNo, 1, idsPODetail.RowCount())
		// 07/07 - PCONKL - commented out		
		//		llRDExists = ldsRDetail.Retrieve(lsOrderNo, lsSKU, 'Coty', dec(lsLineNo))
				//order, sku, suppl, line
			/*	if llRDLine > 0 then
					//Line exists at least previously in this file (even if not already in database)
					//lbExistingLine = True
				else
					// Use new datastore ldsExistingLine???
					llLineRow = ldsExistingEDILine.Retrieve(asProject, llExistingBatch, lsOrderNo)
					liRC = ldsExistingEDILine.SetFilter("line_item_no = " + lsLineNo)
					liRC = ldsExistingEDILine.Filter()
					llLineRow = ldsExistingEDILine.RowCount() //should always be 1 or 0
					if llLineRow = -1 then
						//messagebox ("ERROR", SQLCA.SQLErrText)
					end if
				end if
				
				*/
			end if
			
			if llLineRow = 0 then
				
				lbDetailUpdated = True
				//Insert new row in Edi_Inbound_Detail
				llNewDetailRow = idsPODetail.InsertRow(0)
				//need to make sure the llLineSeq is greater than the 
				llLineSeq ++
						
				//Add detail level defaults
				idsPODetail.SetItem(llNewDetailRow, 'order_seq_no', llOrderSeq) 
				idsPODetail.SetItem(llNewDetailRow, 'project_id', asproject) /*project*/
				idsPODetail.SetItem(llNewDetailRow, 'status_cd', 'N') 
				idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N') 
				idsPODetail.SetItem(llNewDetailRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
				idsPODetail.SetItem(llNewDetailRow, "order_line_no", string(llLineSeq))
				
				//set fields from file...
				//07/12/07 - idsPODetail.SetItem(llNewDetailRow, 'action_cd', lsTemp) 
				//now deleting all open orders nightly and treating everything as an add... 
				idsPODetail.SetItem(llNewDetailRow, 'action_cd', 'A')
				idsPODetail.SetItem(llNewDetailRow, 'Order_No', Trim(lsOrderNo))
				idsPODetail.SetItem(llNewDetailRow, 'line_item_no',Dec(Trim(lsLineNo)))
				idsPODetail.SetItem(llNewDetailRow, 'SKU', lsSku)
				idsPODetail.SetItem(llNewDetailRow, 'quantity', Trim(lsQty)) /*checked for numerics in nvo_process_files.uf_process_purchase_Order*/
				If lsInvType > '' Then /*override default if present*/	
					idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', lsInvType)
				End If
				idsPODetail.SetItem(llNewDetailRow, 'Alternate_SKU', lsAltSku)
				idsPODetail.SetItem(llNewDetailRow, 'Lot_no', lsLot)
				//idsPODetail.SetItem(llNewDetailRow, 'PO_NO', lsPONO)
				idsPODetail.SetItem(llNewDetailRow, 'po_no2', lsPONO2)
				idsPODetail.SetItem(llNewDetailRow, 'Serial_No', lsSerial)
				//idsPODetail.SetItem(llNewDetailRow, 'expiration_date', dateTime(lsExpDate))
				idsPODetail.SetItem(llNewDetailRow, 'po_no', lsPONO)
				
			else
				
				// line already exists in edi_inbound_detail. Update Qty...
				lbDetailUpdated = True
				lsOldQty = idsPODetail.GetItemString(llLineRow, 'quantity')
				ldQty = dec(lsOldQty) + dec(lsQty)
				idsPODetail.SetItem(llLineRow, 'quantity', string(ldQty))
				
//				//need to update ReceiveDetail record (if it exists and we've added to qty)
	// 07/07 - PCONKL - commented out
//				if llRDExists > 0 then
//					ldsRDetail.SetItem(llRDExists, 'req_qty', ldQty)
//					//liRC = ldsRDetail.Update()
//					//commit; //TEMPO - do we need to commit the changes before
//				end if

				
			end if

			//If detail errors, delete the row...
			if lbDetailError Then
				lbError = True
				idsPoDetail.DeleteRow(llNewDetailRow)
				Continue
			End If
				
			//We may receive a detail row for a new sku//supplier combination. If we have the sku for another supplier and this supplier is also valid, copy existing item to new supplier
			/*COTY - Not adding Item Master records for COTY			*/
		CASE 'EO' /* EOF */
			// do nothing...
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

	// 07/07 - PCONKL - commented out
//if liRC = 1 and ldsRDetail.RowCount() > 0 then
//	liRC = ldsRDetail.Update()
//end if

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

public function integer xuf_process_po (string aspath, string asproject);/* Import of Purchase Order for COTY
- Coty will have multiple shipments against an Order (with a different Delivery Date)
- SIMS will create a distinct Receive_Master record for each PO/Date combo (actually, Orig/Dest/PO/Date)

**** 07/11/07 ****
This has been superceded...

*/

Datastore	lu_dsImport, ldsItem

String	lsLogout, lsStringData, lsOrder, lsWarehouse, lsTemp, lsRecData, lsRecType, lsDesc
//not used for COTY , lsSKU, lsSupplier
Integer	liRC,liFileNo
Long		llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llOwnerID
Boolean	lbError, lbDetailError
DateTime	ldtToday, ldtDelivery
Decimal	ldWeight, ldLineItemNo
String 	lsOrderNo

ldtToday = DateTime(Today(),Now())

lu_dsImport = Create datastore
lu_dsImport.dataobject = 'd_generic_import'

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
lsLogOut = '      - Opening File for Coty Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath, LineMode!, Read!, LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Coty Processing: " + asPath
	FileWrite(giLogFileNo, lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo, lsStringData)

Do While liRC > 0
	llNewRow = lu_dsImport.InsertRow(0)
	lu_dsImport.SetItem(llNewRow, 'rec_data', Trim(lsStringData)) /*record data is the rest*/
	liRC = FileRead(liFileNo, lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Warehouse defaulted from project master default warehouse - only need to retrieve once
Select wh_code into :lsWarehouse
From Project
Where Project_id = :asProject;

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Process Each Record in the file..

//Process each row of the File
llRowCount = lu_dsImport.RowCount()

For llRowPos = 1 to llRowCount
	
	lsrecData = Trim(lu_dsImport.GetItemString(llRowPos, 'rec_Data'))
	lsRecType = Left(lsRecData, 2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsRecType)
			
		Case 'PM' /*PO Header*/
			
			llNewRow = 	idsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			//New Record Defaults
			idsPOheader.SetItem(llNewRow, 'project_id', asProject)
			idsPOheader.SetItem(llNewRow, 'wh_code', lsWarehouse)
			idsPOheader.SetItem(llNewRow, 'Request_date', String(Today(), 'YYMMDD'))
			idsPOheader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			idsPOheader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
			idsPOheader.SetItem(llNewRow, 'ftp_file_name', asPath) /*FTP File Name*/
			idsPOheader.SetItem(llNewRow, 'Status_cd', 'N')
			idsPOheader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
		
			idsPOheader.SetItem(llNewRow, 'Order_type', 'S') /*Supplier Order*/
			idsPOheader.SetItem(llNewRow, 'Inventory_Type', 'N') /*default to Normal*/
					
			lsRecData = Right(lsRecData, (len(lsRecData) - 3)) /*strip off to first column after rec type */
		
			//Action Code - 			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'AcCtion Code' field. Record will not be processed.")
			End If
						
			idsPOheader.SetItem(llNewRow, 'action_cd', lstemp) 
		
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
								
			//Order Number
			If Pos(lsRecData, '|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData, '|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsOrderNo = lsTemp
			idsPOheader.SetItem(llNewRow, 'order_no', Trim(lsTemp))
		
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//No more required fields after Supplier
			
			//Supplier 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
		
			//? Always use 'COTY' for supplier?
			//If lsTemp > '' Then
			//	//not used for COTY: lsSupplier = lsTemp /*used to build item master below if necessary*/
			//	idsPOheader.SetItem(llNewRow, 'supp_code', lsTemp)
			//Else
				idsPOheader.SetItem(llNewRow, 'supp_code', 'COTY') /* default to Coty */
			//End If
			
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Expected Arrival Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOHeader.SetItem(llNewRow, 'Arrival_Date', lsTemp)
//TEMPO!!! - need to set SHIP_REF! - and check to see if it already exists.
			idsPOHeader.SetItem(llNewRow, 'Ship_Ref', lsTemp)  //should make sure it's a date and force the format ('yyyy-mm-dd'?)
			/* Unique order for Coty is Orig/Dest/PO/ShipmentDate. Check for existence here. 
			If one doesn't exist, set action to 'Z'. This will force PO process to create a new order 
			regardless (if PO already exists).
			*/
					
			//7/10/07 If idsPOHeader.GetItemString(llNewRow, 'Action_cd') = 'A' and lsTemp > '' Then
			If idsPOHeader.GetItemString(llNewRow, 'Action_cd') = 'X' and lsTemp > '' Then
				Select Count(*) into :llCount
				From Receive_Master 
				Where Project_id = 'COTY' and Supp_Invoice_No = :lsOrderNo and arrival_date = :lsTemp;
				If llCount = 0 Then
					idsPOHeader.SetItem(llNewRow, 'action_cd', 'Z') /*add regardless*/
				End If				
			End If

			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Warehouse
			//Only single warehouse at this time (COTY-WARSA)...
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
				
			//Should we validate that it's COTY-WARSA?
			//If lsTemp <> 'COTY-WARSA' Then
			//	lbError = True
			//	gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse: '" + lsTemp + "'. Order will not be processed.") 
			//End If
			
//			Select warehouse.wh_Code into :lsWarehouse
//			From Warehouse, Project_warehouse
//			Where warehouse.wh_Code = project_warehouse.wh_Code and project_id = :asProject and User_Field1 = :lsTemp;
//			
//			If lsWarehouse = "" Then
//				lbError = True
//				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse: '" + lsTemp + "'. Order will not be processed.") 
//			End If
//			
//			idsPOheader.SetItem(llNewRow,'wh_Code',lsWarehouse)
			idsPOheader.SetItem(llNewRow, 'wh_Code', 'COTY-WARSA')
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Carrier
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow, 'Carrier',lsTemp)
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//AWB
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow, 'Awb_bol_no', lsTemp)
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Transport Mode
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			idsPOheader.SetItem(llNewRow, 'transport_mode',lsTemp)
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Remarks
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow, 'remark', lsTemp)
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Order Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			// Coty will send 'PO' or 'IT' 
			if lsTemp = 'PO' then
				// Supplier Purchase Order
				lsTemp = 'S'
			elseif lsTemp = 'IT' then
				// Inventory Transfer order
				lsTemp = 'I'
			end if
			idsPOheader.SetItem(llNewRow, 'Order_Type', lsTemp)
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

		CASE 'PD' /* detail*/
			lbDetailError = False
			llNewDetailRow = 	idsPODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			idsPODetail.SetItem(llNewDetailRow, 'order_seq_no', llOrderSeq) 
			idsPODetail.SetItem(llNewDetailRow, 'project_id', asproject) /*project*/
			idsPODetail.SetItem(llNewDetailRow, 'status_cd', 'N') 
			idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N') 
			idsPODetail.SetItem(llNewDetailRow, 'edi_batch_seq_no', llbatchseq) /*batch seq No*/
			idsPODetail.SetItem(llNewDetailRow, "order_line_no", string(llLineSeq))
		
			lsRecData = Right(lsRecData, (len(lsRecData) - 3)) /*strip off to first column after rec type */
				
			//Action Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'ACtion Code' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			idsPODetail.SetItem(llNewDetailRow, 'action_cd', lsTemp) 
		
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Number' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			//Make sure we have a header for this Detail...
			//If idsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'", 1, idsPoHeader.RowCount()) = 0 Then
//TEMPO!!! Will there be more than one Order/Shipment(Date) combination in a single file?
//Yes, need to do the find based on order/shipment (but shipment is no longer in the record, need date!)
//actually, we've already set Order_Seq_no for this detail line, so...	
			If idsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'", 1, idsPoHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Detail Order Number does not match header Order Number. Record will not be processed.")
				lbDetailError = True
			End If
			
			idsPODetail.SetItem(llNewDetailRow, 'Order_No', Trim(lsTemp))

			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Line Item Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Line Item Number' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			If Not isnumber(lsTemp) Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - 'Line Item' is not numeric. Record will not be processed.")
				lbDetailError = True
			Else
				idsPODetail.SetItem(llNewDetailRow, 'line_item_no',Dec(Trim(lsTemp)))
			End If
		
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Upper(Left(lsRecData, (pos(lsRecData,'|') - 1)))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			//not used for COTY lsSKU = lsTemp /*used to build itemmaster below*/
			idsPODetail.SetItem(llNewDetailRow, 'SKU', lsTemp)
		
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Qty
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
		
			idsPODetail.SetItem(llNewDetailRow, 'quantity', Trim(lsTemp)) /*checked for numerics in nvo_process_files.uf_process_purcahse_Order*/

			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
		// *** No more required fields...
		
			//Inventory Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			If lsTemp > '' Then /*override default if present*/	
				idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', lsTemp)
			End If
		
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Alternate SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow, 'Alternate_SKU', lsTemp)
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//lot No
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'Lot_no',lsTemp)
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO - We will be mapping PKG Code below to PO_NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
		//
			idsPODetail.SetItem(llNewDetailRow, 'PO_NO', lsTemp)
			
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow, 'po_no2', lsTemp)
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Serial No
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow, 'Serial_No', lsTemp)
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Expiration date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
		//idsPODetail.SetItem(llNewDetailRow, 'expiration_date', dateTime(lsTemp))
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			//Maquet Division ("package Code") -> to PO_NO (above)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData, (pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow, 'po_no', lsTemp)
					
			lsRecData = Right(lsRecData, (len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//If detail errors, delete the row...
			if lbDetailError Then
				lbError = True
				idsPoDetail.DeleteRow(llNewDetailRow)
				Continue
			End If
				
			/*COTY - Not adding Item Master records for COTY
			//We may receive a detail row for a new sku//supplier combination. If we have the sku for another supplier and this supplier is also valid, copy existing item to new supplier
			//llCount = ldsItem.Retrieve(asProject, lsSKU)
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
							
							ldsItem.SetItem(ldsitem.RowCount(), 'supp_code', lsSupplier)
							ldsItem.SetItem(ldsitem.RowCount(), 'owner_id', llOwnerID)
							ldsItem.SetItem(ldsitem.RowCount(), 'last_update', ldtToday)
							ldsItem.SetItem(ldsitem.RowCount(), 'last_user', 'SIMSFP')
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
		CASE 'EO' /* EOF */
			// do nothing...
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

public function integer uf_delete_leftovers ();/*
Delete all PO-type orders in 'New' status daily, before orders are dropped for
the current day.
  - (1/31/08 - Now purging Back-Orders as well)
Coty plans to drop orders beginning midnight ET.
 - 9:00pm Pacific
 - Run this around 8:00pm Pacific (
Need to safeguard against deleting orders that are newly imported:
 - (in case new orders started dropping before 'delete_leftovers' is called)
 - don't delete orders that came in less than X hours ago
 - where Clause:
 -		Ord_status = 'N'
 -		and Ord_Type = 'S'
 -		x - now no matter what Last_User (and last_user = 'SIMSFTP')
 -		and last_update < getdate() - .1
 ! May need to have Coty send us a file that triggers the purge.
 ? Is there something in the file that indicates the day of the file? (can we trust the name?)
  - If so, we could populate a user field with the date of file, and delete if it's 'old'
  
*/
string lsSql, lsLogOut
long llCount

lsLogOut = '   Deleting Left-over Coty POs'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//ldtOldDate = RelativeDate(Today(), -1)
//ldtPurgeTime = DateTime(Today(), Time(lsNextRunTime))

select count(ro_no) into :llCount
from receive_master
where project_id = 'COTY' and Ord_status = 'N'
// 8/02/07 and Ord_Type = 'S' and Last_User = 'SIMSFP' 
// 01/31/08 Now purging Back Orders as well...
and Ord_Type in('S', 'B')
and Last_Update < GetDate() - .2;

lsLogOut = '   ' + string (llCount) + ' order(s) will be deleted.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

if llCount > 0 then
	lsSql = "delete from receive_detail where ro_no in"
	lsSql += " (select ro_no from receive_master"
	lsSql += " where project_id = 'COTY' and Ord_status = 'N'"
	// 8/02/07 	lsSql += " and Ord_Type = 'S' and Last_User = 'SIMSFP' and Last_Update < GetDate() - .1)"
	lsSql += " and Ord_Type in('S', 'B') and Last_Update < GetDate() - .2)"
	EXECUTE IMMEDIATE :lsSQL;
	
	lsSql = "delete from receive_master"
	lsSql += " where project_id = 'COTY' and Ord_status = 'N'"
	// 08/02/07 lsSql += " and Ord_Type = 'S' and Last_User = 'SIMSFP' and Last_Update < GetDate() - .2"
	lsSql += " and Ord_Type in('S', 'B') and Last_Update < GetDate() - .2"
	EXECUTE IMMEDIATE :lsSQL;
	commit;
end if

return 0

/* If we go the datastore route...

datastore ldsRMaster, ldsRDetail

ldsRMaster = Create u_ds_datastore
ldsRMaster.dataobject= 'd_receive_master'
ldsRMaster.SetTransObject(SQLCA)

ldsRDetail = Create u_ds_datastore
ldsRDetail.dataobject= 'd_receive_detail'
ldsRDetail.SetTransObject(SQLCA)


//Create the Receive Master/Detail datastores dynamically (no physical datastore object)
ldsRMaster = Create Datastore
ldsRDetail = Create Datastore
sql_syntax = "select ro_no from receive_master"
lsWhereProjects = " where project_id in (" + lsProjects + ")"
sql_syntax += lsWhereProjects
sql_syntax += " and complete_date > getdate() - " + lsDays
sql_syntax += " and complete_date < getdate() - .1" //(to prevent catching one for which the transaction is being created right now. one was caught in testing)
sql_syntax += " and ro_no not in(select trans_order_id from batch_transaction"
//test..sql_syntax += " and ro_no in(select trans_order_id from batch_transaction"
sql_syntax += lsWhereProjects
sql_syntax += " and trans_type = 'GR')"
sql_syntax += " group by project_id"

//messagebox("TEMPO", sql_syntax)
ldsTransactions.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", Errors))
IF Len(Errors) > 0 THEN
//	messagebox("TEMPO", "*** Unable to create datastore for Transactions.~r~r" + Errors)
   lsLogOut = "        *** Unable to create datastore for missing Batch Transactions.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   Return - 1
END IF
*/


end function

public function integer uf_process_ds (string aspath, string asproject);//Cloned from Metro to Coty to accept multipile file times.  CSV will use command delimiter
Long llRtn = 0
long ll_rc, rtn, fId, llen
String lsLogOut, sLine
string thisColumn
datetime ldtToday, ldtTempDate
int lposComma, lposPipe, lposTab

string sCustCds[]
string quote = String(Blob(Char(34)), EncodingANSI!)
string comma = ','
string tabchar = '~t'
string pipechar = '|'
string delimiter = comma	// set up the system to use comma as the default delimiter

long lpos = 0			// used for pos search
long lpos2 = 0 			// find quotes

long lImportRow = 0
long cnt = 0         		// counter
long i = 0				// iterator
long ldr = 0
string ss = ''

/*********Get DW display columns*************/
  Long li_Loop, ll_columns
  String ls_ColName, lsa_ColNames[]
  
  Any la_colno
  la_colno = ids_import.object.datawindow.column.count
  ll_columns = long(la_colno)
  FOR li_Loop = 1 TO ll_columns
  	ls_ColName = ids_import.Describe("#" + String( li_Loop ) + ".Name")
	IF Long( ids_import.Describe( ls_ColName + ".Visible") ) > 0 THEN
    		lsa_ColNames[ UpperBound(lsa_ColNames[]) + 1] = ls_ColName
    END IF
 next
/*****************************************/
fId = fileopen ( asPath, LineMode!, Read!)

rtn = FileReadEx( fId, sLine )  
if IsNull(rtn) OR (rtn <= 0 ) then
		lsLogOut = "        Could not read: " + asPath + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
else
	llen = len(sLine)
end if

//ldtToday = f_getLocalWorldTime( gs_default_wh )

// determine the delimiter to use
lposComma = 0
lposPipe = 0
lposTab = 0

lposComma = pos(sLine, comma, 1)
lposPipe  = pos(sLine, PipeChar, 1)
lposTab   = pos(sLine, TabChar, 1)

IF lposComma > 0 THEN
	delimiter = comma
ELSEIF lposPipe > 0 THEN
	delimiter = PipeChar
ELSEIF lposTab > 0 THEN
	delimiter = TabChar
ELSE
		lsLogOut = "        Unable to determine delimiter. ~r~nPlease confirm that the file uses either the comma, tab or pipe characters as column markers."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
END IF

DO WHILE ( rtn > 0)
	
	lImportRow ++
	// write to the status line
	w_main.SetMicroHelp( 'Processing row: ' + string(lImportRow) + ': ' + sLine)
	
	llen = len(sLine)
	i = 1
	cnt = 0
	
	DO UNTIL (i >= llen)
		// get the columns
		cnt++ // increment column counter
		
		lpos = pos(sLine, delimiter, i)
		if lpos > 0 then
			ss = mid(sLine, i, lpos - i)
			// how to deal with embedded quotes and delimiters:
			// Test for quote and if found then find match and set i and lpos appropriately
			If left(ss,1) = quote Then
				lpos2 = pos(sLine, quote, lpos + 1)
				if lpos > 0 then
					ss = mid(sline, i + 1, lpos2 - i - 1) 
					i = lpos2 + 2
					//lpos = lpos2
				end if
			else
				i = lpos + 1
			End if
		elseif lpos = 0 and i = 0 then
			ss = ''
			i++
			cnt --
		else
			ss = mid(sLine, i)
			i = llen 
		end if
		
		thisColumn = upper(lsa_ColNames[cnt])
		
		//Change format of dates for web server (order_date & scheduled_date for purchase order; schedule_date and request_date for sales order)
		if thisColumn = 'ORDER_DATE' or thisColumn = 'SCHEDULED_DATE' &
				or thisColumn = 'SCHEDULE_DATE' or thisColumn = 'REQUEST_DATE' then
			if len(ss) = 8 then
				ss = left(ss,4) + '-' + mid(ss,5,2) + '-' + right(ss,2)
			end if
		end if
		
		
		// Add column data to DS
		If cnt = 1 Then 
			If left(upper(ss),4) = left(upper(thisColumn),4) Then
				// Header row - do not process
				EXIT
			Else
				ldr =ids_import.insertrow(0)
				ids_import.setitem( ldr, thisColumn, ss)
			End If
		Else
			ids_import.setitem( ldr, thisColumn, ss)
		End If
		
	LOOP // Parse through the colunns
	
	rtn = FileReadEx( fId, sLine )  // row 5+ data

LOOP  // Rows 4+

rtn = FileClose(fId)

return llRtn
end function

public function integer uf_process_dboh (string asproject, string asinifile);//18-APR-2018 :Madhu S18357 - COTY - Inventory Snapshot

Datastore	lds_Inv_dboh
Long			llRowCount
String			lsLogOut, lsFileName, lsFileNamePath
Integer		liRC


//create Datastore
lds_Inv_dboh = Create Datastore
lds_Inv_dboh.Dataobject = 'd_coty_dboh'
liRC = lds_Inv_dboh.settransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsLogOut = "- PROCESSING FUNCTION: COTY Inventory Snapshot!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the COTY Inventory Snapshot
lsLogout = 'Retrieving COTY Inventory Snapshot.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//Retrieve records
llRowCount = lds_Inv_dboh.Retrieve(asproject) 

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsFileName = 'BH' + String(DateTime( today(), now()), "yyyymmddhhmmss") +".csv"

//Save to ftpfiledirout
lsFileNamePath = ProfileString(asInifile,  asproject, "ftpfiledirout","") + '\' +lsFileName
lds_Inv_dboh.SaveAs ( lsFileNamePath, CSV!,  false )


destroy lds_Inv_dboh

Return 0
end function

public function string uf_replace_quote (ref string as_string);string lsquote, lsreplace_with

lsquote = '"'

lsreplace_with = ''
//lsreplace_with = "~~~'"

long ll_start_pos, len_lsquote
ll_start_pos=1
len_lsquote = len(lsquote) 

//find the first occurrence of ls_quote... 
ll_start_pos = Pos(as_string ,lsquote,ll_start_pos) 

//only enter the loop if you find whats in lsquote
DO WHILE ll_start_pos > 0 
	 //replace llsquote with lsreplace_with ... 
	 as_string = Replace(as_string,ll_start_pos,Len_lsquote,lsreplace_with) 
	 //find the next occurrence of lsquote
	ll_start_pos = Pos(as_string,lsquote,ll_start_pos+Len(lsreplace_with)) 
LOOP 


return as_string
end function

public function string uf_check_unicode (string as_string);
int li_c3_pos, li_a9_pos, li_e9_pos
int li_C3 = 195
int li_A9 = 169
int li_E9 = 233
String ls_C3, ls_A9, ls_E9 

ls_C3 =  String( Blob( Char( li_C3 ) ) )
ls_A9 =  String( Blob( Char( li_A9 ) ) )
ls_E9 =  String( Blob( Char( li_E9 ) ) )

//Can we find and replace C3A9 characters with a E9? -- e with acute is not displaying properly
/*
li_c3_pos = Pos(as_string ,String(Blob(Char(li_C3 )), EncodingANSI!) ,1) 
li_a9_pos = Pos(as_string ,String(Blob(Char(li_A9 )), EncodingANSI!) ,1) 
li_e9_pos = Pos(as_string ,String(Blob(Char(li_E9 )), EncodingANSI!) ,1)
*/
li_c3_pos = Pos(as_string ,ls_C3,1)
li_a9_pos = Pos(as_string ,ls_A9,1)
li_e9_pos = Pos(as_string ,ls_E9,1)


If li_c3_pos > 0 Then
	as_string = Left( as_string, li_c3_pos - 1) + ls_E9 + Right( as_string, Len(as_string) - li_c3_pos - 1)
	
		f_method_trace_special( 'COTY', this.ClassName() + ' - u_nvo_proc_coty - uf_check_unicode', 'Found unicode character: ' + as_string ,'C3:' + ls_C3, '','','')																

End If

If li_e9_pos > 0 Then
	as_string = Left( as_string,  li_e9_pos - 1) + ls_E9 + Right( as_string, Len(as_string) - li_e9_pos )
End If

return as_string
end function

public function string uf_get_next_element (string aselement);string lsQuote, test, delimiter
string lsRetElement

lsQuote = CHAR(34)
delimiter = ","

If left(asElement,1) = lsQuote Then
	iiP1 = 2
	iiP2 = pos(asElement, lsQuote, 2)
	lsRetElement = mid(asElement, iiP1, iiP2 - 2)
	iiP2 = Len(asElement) - iiP2 - 1
Else	
	iiP1 = 1
	iiP2 = pos(asElement, delimiter, iiP1)
	lsRetElement = left(asElement, iiP2 -1)
	iiP2 = Len(asElement) - iiP2 
	
	test = Right(asElement, iiP2)
	
End If

return lsRetElement
end function

on u_nvo_proc_coty.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_coty.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
idswhXref = f_datastorefactory('d_phxbrands_whxref')
idswhXref.retrieve()

end event

event destructor;if isValid( idswhXref ) then destroy idswhXref

end event

