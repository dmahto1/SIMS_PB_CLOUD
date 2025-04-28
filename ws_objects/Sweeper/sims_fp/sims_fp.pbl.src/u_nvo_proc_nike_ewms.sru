$PBExportHeader$u_nvo_proc_nike_ewms.sru
forward
global type u_nvo_proc_nike_ewms from nonvisualobject
end type
end forward

global type u_nvo_proc_nike_ewms from nonvisualobject
end type
global u_nvo_proc_nike_ewms u_nvo_proc_nike_ewms

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 

end prototypes

type variables

string lsDelimitChar

datastore ids_nike_sku_serialized_ind 

u_nvo_proc_baseline_unicode 	iu_nvo_proc_baseline_unicode
end variables

forward prototypes
public function integer uf_process_purchase_order (string aspath, string asproject)
public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow)
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_return_order (string aspath, string asproject)
public function integer uf_process_dboh (string asproject, string asinifile)
public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_startuserfield, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow)
public function integer uf_process_delivery_order (string aspath, string asproject)
public function integer uf_process_itemmaster (string aspath, string asproject)
public function integer uf_replace_quote (ref string as_string)
public function integer uf_reset_sequence_number (string asproject, string asinifile)
end prototypes

public function integer uf_process_purchase_order (string aspath, string asproject);
//Process Purchase Order (PM) Transaction for Baseline Unicode Client
//Process Receive Order


u_ds_datastore 	ldsPOheader,	ldsPOdetail
u_ds_datastore 	ldsImport
boolean lb_error_order_sku = false

integer lirc, liCount
boolean lberror
string lslogout

//Call the generic load

u_nvo_proc_baseline_unicode lu_nvo_proc_baseline_unicode

lu_nvo_proc_baseline_unicode = create u_nvo_proc_baseline_unicode	
	
lirc = lu_nvo_proc_baseline_unicode.uf_load_purchase_order(aspath, asproject, ldsImport, ldsPOheader, ldsPOdetail)
	
IF lirc = -1 then lbError = true else lbError = false	

//Specifc Nike Changes before saving
	
//-	SIMS Order number will be generated as ‘RCTyyyymmxxxxx’ where yyyy = year, mm=month and xxxxx is sequential number for the month.  The Next Sequence generator will return everything except the ‘RCT’. EWMS is currently storing this in the RO_NO but we will maintain our standard and store the RCT number in the Supp_invoice_No field.

//-	On the inbound mapping from ICC, they are sending the Nike PO as the Order Number (5th column in the header, 4th in the detail). We do not want to map this into the SIMS order number (see above). However, this field will be used to link order detail records with the corresponding header. This field will also be mapped into Receive_Master.UF9 by ICC.


integer liIdx, liFind
string lsNewOrderNumber
long llOrderNoSeq, llCustLineItemNo
long llLineItemNo
string lsOrderNumber
string lsSize, lsSku, lsNewSku

For liIdx = 1 to  ldsPOdetail.RowCount() 

	ldsPOdetail.SetItem( liIdx, "inventory_type", "U" )

	lsSku = ldsPOdetail.GetItemString( liIdx, "sku" )	
	lsSize = ldsPOdetail.GetItemString( liIdx, "user_field1" )	

	if Not IsNull(lsSize) then
		lsNewSku = lsSku + '-' + lsSize
		
		 ldsPOdetail.SetItem( liIdx, "sku", lsNewSku )	
		 
	end if	
	
	//Validate SKU
	
	If isNull(lsSku) Then lsSku = ''
	Select Count(*) into :liCount
	From Item_Master
	Where project_id = :asproject and sku = :lsNewSku;
		
		
	If liCount <=0 Then
		
		lsOrderNumber = ldsPODetail.GetItemString( liIdx, "order_no")
		
//		liFind =  ldsPOHeader.Find("Upper(order_no) = '" + Upper(lsOrderNumber) + "'",  1, ldsPOHeader.RowCount())
		
//		if liFind > 0 then
			lb_error_order_sku = true
//		end if
		
	
		
		gu_nvo_process_files.uf_writeError("Order Nbr/Line (detail): " + string(lsOrderNumber) + '/' + string(liIdx) + " Invalid SKU: " + lsNewSku) 

		 ldsPOdetail.SetItem( liIdx, "Status_Cd", "E")
		 ldsPOdetail.SetItem( liIdx, "Status_Message", "Invalid Sku")			 

		lbError = True
	End If
	


	
next

string ls_date

For liIdx = 1 to ldsPOheader.RowCount()

	if lb_error_order_sku = true then
		ldsPOHeader.SetItem(liIdx, "Status_Cd", "E")
		ldsPOHeader.SetItem(liIdx, "Status_Message", "Invalid Sku" )	
	end if
	
	
	//Check for Duplicates
	lsOrderNumber = ldsPOheader.GetItemString( liIdx, "order_no")
	
	// 03/27 - PCONKL - Void any orders in NEW status so we can reload them from scratch - ***NEEDS TO BE ADDED TO SOURCE CONTROL**
	Update Receive_Master 
	Set Ord_status = 'V'
	Where  Receive_Master.project_id = :asProject 
				and Receive_Master.Supp_Order_No = :lsOrderNumber and Ord_status = 'N';	
				
	Commit;
	
	// END of code needed in source control
	
	Select Count(*) into :liCount
		From Receive_Master
		Where Receive_Master.project_id = :asProject 
		and Receive_Master.Supp_Order_No = :lsOrderNumber and Ord_status <> 'V';	
		
	if liCount > 0 then

		lsLogOut = "Order Nbr (Header) " + string(lsOrderNumber) + " - Order Already Exists and action code is 'Add'"
		FileWrite(gilogFileNo,Space(17) + lsLogOut)
		gu_nvo_process_files.uf_writeError("Order Nbr (Header) " + string(lsOrderNumber) + " - Order Already Exists and action code is 'Add'")
 
		lbError = true

		liFind = 0
				
		DO
			
			liFind =  ldsPODetail.Find("Upper(order_no) = '" + Upper(lsOrderNumber) + "'", (liFind+1), ldsPODetail.RowCount())
		
			if liFind > 0 then
				ldsPODetail.SetItem(liFind, "Status_Cd", "E")
				ldsPODetail.SetItem(liFind, "Status_Message", lsLogOut )			 
			end if
		
		
		LOOP UNTIL  liFind = 0 OR liFind >= ldsPOdetail.RowCount()
	
		
		ldsPOheader.SetItem(liIdx, "Status_Cd", "E")
		ldsPOheader.SetItem(liIdx, "Status_Message", lsLogOut )			 


		CONTINUE

	end if
	
	llLineItemNo = 0

	//Set Format for ord_date

	ls_date =  ldsPOheader.GetItemString( liIdx, "ord_date")
	
	if len(ls_date) >= 8 then
		 ls_date = left(ls_date,4) + "/" + mid(ls_date,5,2) + "/" +  mid(ls_date,7,2)
		 ldsPOheader.SetItem( liIdx, "ord_date",ls_date)
	end if 
	
	ldsPOheader.SetItem( liIdx, "request_date",  ldsPOheader.GetItemString( liIdx, "ord_date"))
	
	//Set Format for arrival_date
	
	ls_date =  ldsPOheader.GetItemString( liIdx, "arrival_date")
	
	if len(ls_date) >= 8 then
		 ls_date = left(ls_date,4) + "/" + mid(ls_date,5,2) + "/" +  mid(ls_date,7,2)
		 ldsPOheader.SetItem( liIdx, "arrival_date",ls_date)
	end if 	
	
	
	 ldsPOheader.SetItem( liIdx, "inventory_type", "U" )
	 
	 ldsPOheader.SetItem( liIdx, "ship_ref",  ldsPOheader.GetItemString( liIdx, "supp_order_no" ))
	
	IF ldsPOheader.GetItemString( liIdx, "Status_Cd") = "E" THEN CONTINUE

	lsOrderNumber = ldsPOheader.GetItemString( liIdx, "order_no")

	llOrderNoSeq =  gu_nvo_process_files.uf_get_next_seq_no(asproject,'Receive_Master','SUPP_INVOICE_NO')
	
	If llOrderNoSeq <= 0 Then Return -1

	lsNewOrderNumber = 'RCT' + String(today(),'YYYY')   +  string(llOrderNoSeq,'0000000')
        
	 ldsPOheader.SetItem( liIdx, "order_no", lsNewOrderNumber )
		  
	liFind = 0
				
	DO
		
		liFind =  ldsPODetail.Find("Upper(order_no) = '" + Upper(lsOrderNumber) + "'", (liFind+1), ldsPODetail.RowCount())
		
		
		if liFind > 0 then
		
//			llLineItemNo = llLineItemNo + 1
		
//			llCustLineItemNo =  ldsSODetail.GetItemNumber( liFind, "line_item_no" )
			
//			 ldsSODetail.SetItem( liFind, "line_item_no",  llLineItemNo)
		
//			 ldsSODetail.SetItem( liFind, "user_field1", lsOrderNumber )

			 ldsPODetail.SetItem( liFind, "order_no", lsNewOrderNumber )
		end if
	
	
	LOOP UNTIL  liFind = 0 OR liFind >= ldsPOdetail.RowCount()
	
Next

//-	The Shipment ID is relevant to Nike and is being mapped to the Supplier Order Number (supp_order_No) for search ability in SIMS.
//	
	
//ldsPOheader.SaveAs ("C:\header.xls", Excel!, true)
//ldsPOdetail.SaveAs ("C:\detail.xls", Excel!, true)
	
	
	
//Save the Changes 

SQLCA.DBParm = "disablebind =0"
lirc = ldsPOHeader.Update()
	
If liRC = 1 Then
	liRC = ldsPODetail.Update()
End If
SQLCA.DBParm = "disablebind =1"	

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

public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow);
integer li_StartCol, li_UFIdx
string lsTemp	

	
 li_StartCol = al_StartImportColumnNumber

//Handle User Fields

For li_UFIdx = 1 to al_TotalUserFields

	lsTemp = Trim(adw_ImportDW.GetItemString(adw_ImportDWCurrentRow, "col" + string(li_StartCol)))

//	Messagebox ("ok", lsTemp)

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		adw_DestDW.SetItem(adw_DestDWCurrentRow,'User_Field' + string(li_UFIdx), lsTemp)
	End If		

	li_StartCol = li_StartCol + 1
	
Next

RETURN 0
end function

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut,	&
			lsSaveFileName, &
			lsPOLineCountFileName
			
Integer	liRC, liLoadRet, liProcessRet
	



Choose Case Upper(Left(asFile,4))
		
	Case  'N856'  
		
		liLoadRet = uf_process_purchase_order(asPath, asProject)
	
		//Process any added PO's
		liProcessRet = gu_nvo_process_files.uf_process_purchase_order(asProject)  //asProject

		if liLoadRet = -1 OR liProcessRet = -1 then liRC = -1 else liRC = 0


	Case  'N850'  
		
		liLoadRet = uf_process_delivery_order(asPath, asProject)
		
		//Process any added SO's
		
		liProcessRet = gu_nvo_process_files.uf_process_Delivery_order(asProject)
		
		if liLoadRet = -1 OR liProcessRet < 0 then liRC = -1 else liRC = 0

		
	Case 'N832'
		
			
		liRC = uf_process_itemmaster(asPath, asProject)
		

//	Case  'RM'  
//		
//		liRC = uf_return_order(asPath, asProject)
//	
//		//Process any added PO's
//		//We need to change to project. This will be changed after testing.
//		liRC = gu_nvo_process_files.uf_process_purchase_order('CHINASIMS')  //asProject
//		
		

	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
end function

public function integer uf_return_order (string aspath, string asproject);
//Process Return Order (RM) Transaction for Baseline Unicode Client

STRING lsTemp, lsProject, lsSku, lsSupplier, lsWarehouse, lsOrderNumber, lsOrderType
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow
STRING lsLogOut, lsChangeID
INTEGER li_StartCol
INTEGER li_UFIdx
DECIMAL ldQuantity

u_ds_datastore	ldsPOHeader,	&
				     ldsPODetail, &
					 ldsImport

ldsPOheader = Create u_ds_datastore
ldsPOheader.dataobject= 'd_baseline_unicode_po_header'
ldsPOheader.SetTransObject(SQLCA)

ldsPOdetail = Create u_ds_datastore
ldsPOdetail.dataobject= 'd_baseline_unicode_po_detail'
ldsPOdetail.SetTransObject(SQLCA)

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Purchase Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Purchase Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

integer llFileRowPos
integer llFilerowCount

llFilerowCount = ldsImport.RowCount()

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Loop through

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Return Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))

	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“RM”	Return order master identifier
	//Record ID	C(2)	Yes	“RD”	Purchase order detail identifier

	//Validate Rec Type is PM OR PD
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
	If NOT (lsTemp = 'RM' OR lsTemp = 'RD') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If

	Choose Case Upper(lsTemp)
	
		//Return Master
	
		Case 'RM' /*RM Header*/

			//Change ID	C(1)	Yes	N/A	
				//A – Add
				//U – Update
				//D – Delete
				//X – Ignore (Add or update regardless)
				
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Change ID is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsChangeID = lsTemp
			End If		
			
			//Project ID	C(10)	Yes	N/A	Project identifier

			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsProject = lsTemp
			End If					

			//Warehouse	C(10)	Yes	N/A	Receiving Warehouse

			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col4")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Warehouse is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsWarehouse = lsTemp
			End If					

			//Order Number	C(30)	Yes	N/A	Purchase order number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsOrderNumber = lsTemp
			End If					
				
				
			//Order Type	C(1)	Yes	“S”	Must be valid order typr
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				lsOrderType = "X"	
			Else
				lsOrderType = lsTemp
			End If					
	
			
			//Supplier Code	C(20)	Yes	N/A	Valid Supplier code

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSupplier = lsTemp
			End If			

			/* End Required */		
			
			liNewRow = 	ldsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			ldsPOheader.SetItem(liNewRow,'project_id',lsProject)
			ldsPOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
			ldsPOheader.SetItem(liNewRow,'Request_date',String(Today(),'YYMMDD'))
			ldsPOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPOheader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
			ldsPOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsPOheader.SetItem(liNewRow,'Status_cd','N')
			ldsPOheader.SetItem(liNewRow,'Last_user','SIMSEDI')

			ldsPOheader.SetItem(liNewRow,'Order_No',lsOrderNumber)			
			ldsPOheader.SetItem(liNewRow,'Order_type',lsOrderType) /*Order Typer*/
			ldsPOheader.SetItem(liNewRow,'Inventory_Type','N') /*default to Normal*/
	
	
			ldsPOheader.SetItem(liNewRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsPOheader.SetItem(liNewRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			
			//Order Date	Date	No	N/A	Order Date
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Ord_Date', lsTemp)
			End If	
			
			//Delivery Date	Date	No	N/A	Expected Delivery Date at Warehouse

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'arrival_date', lsTemp)
			End If	

			//Carrier	C(10)	No	N/A	Carrier
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Carrier',  lsTemp)
			End If				
			
			//Supplier Invoice Number	C(30)	No	N/A	Supplier Invoice Number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Supp_Order_No', lsTemp)
			End If				
			
			//AWB #	C(20)	No	N/A	Airway Bill/Tracking Number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'AWB_BOL_No', lsTemp)
			End If				
			
			//Transport Mode	C(10)	No	N/A	Transportation mode to warehouse
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Transport_Mode', lsTemp)
			End If				
			
			//Remarks	C(250)	No	N/A	Freeform Remarks

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPOheader.SetItem(liNewRow,'Remark', lsTemp)
			End If	

			//Return Name	C(50)	No	N/A	
			//Return Address 1	C(60)	No	N/A	
			//Return Address 2	C(60)	No	N/A	
			//Return Address 3	C(60)	No	N/A	
			//Return Address 4	C6)	No	N/A	
			//Return City	C(50)	No	N/A	
			//Return State	C(50)	No	N/A	
			//Return Postal Code	C(50)	No	N/A	
			//Return Country	C(50)	No	N/A	
			//Return Tel	C(20)	No	N/A	
			//Return Contact Name	C(40)	No	N/A	
			//User Field1	C(10)	No	N/A	User Field
			//User Field2	C(10)	No	N/A	User Field
			//User Field3	C(10)	No	N/A	User Field
			//User Field4	C(20)	No	N/A	User Field
			//User Field5	C(20)	No	N/A	User Field
			//User Field6	C(20)	No	N/A	User Field
			//User Field7	C(30)	No	N/A	User Field
			//User Field8	C(30)	No	N/A	User Field
			//User Field9	C(255)	No	N/A	User Field
			//User Field10	C(255)	No	N/A	User Field
			//User Field11	C(255)	No	N/A	User Field
			//User Field12	C(255)	No	N/A	User Field
			//User Field13	C(255)	No	N/A	User Field
			//User Field14	C(255)	No	N/A	User Field, not viewable on screen
			//User Field15	C(255)	No	N/A	User Field, not viewable on screen
			//

			uf_process_userfields(26, 15, ldsImport, llFileRowPos, ldsPOheader, liNewRow)	

			//Note: 
			//
			//4.	A return can only be deleted if no receipts have been generated against it.
			//5.	Deletion of a Return Order Master will also delete related purchase order details.
			//6.	Updated RM/RD’s should include all of the information for the RM/RD’s regardless of whether or not a specific item has been changed.
			//
						

		//Return Detail				
				
		CASE 'RD' /* detail*/

		//Return Order Detail

			//Change ID	C(1)	Yes	N/A	
				//A – Add
				//U – Update
				//D – Delete

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Change ID is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsChangeID = lsTemp
			End If		
			
			//Project ID	C(10)	Yes	N/A	Project identifier
			
			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsProject = lsTemp
			End If									

			//Order Number	C(30)	Yes	N/A	Purchase order number

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				
			
				//Make sure we have a header for this Detail...
				If ldsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'",1, ldsPoHeader.RowCount()) = 0 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
					lbDetailError = True
				End If
					
				lsOrderNumber = lsTemp
			End If			

				
			//Supplier Code	C(20)	Yes	N/A	Valid Supplier code

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSupplier = lsTemp
			End If			
				
			
			//Line Item Number	N(6,0)	Yes	N/A	Item number of purchase order document

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				llLineItemNo = Long(lsTemp)
			End If					
			
			//SKU	C(26)	Yes	N/A	Material number
			
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSku = lsTemp
			End If				
			
			//Quantity	N(15,5)	Yes	N/A	Purchase order quantity


			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				ldQuantity = Dec(lsTemp)
			End If			
		
			/* End Required */
		
		
			lbDetailError = False
			llNewDetailRow = 	ldsPODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			ldsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsPODetail.SetItem(llNewDetailRow,'project_id', lsProject) /*project*/
			ldsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			ldsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			
			ldsPODetail.SetItem(llNewDetailRow,'Order_No',lsOrderNumber)			
			ldsPODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsPODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
			ldsPODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
			ldsPODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
			
			
			//Inventory Type	C(1)	No	N/A	Inventory Type
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', lsTemp)
			End If	
			
			//Alternate SKU	C(50)	No	N/A	Supplier’s material number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku', lsTemp)
			End If	
			
			//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Lot_No', lsTemp)
			End If				
			
			//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'PO_No', lsTemp)
			End If	
			
			//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'PO_No2', lsTemp)
			End If	
			
			//Serial Number	C(50)	No	N/A	Qty must be 1 if present

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Serial_No', lsTemp)
			End If	
			
			//Expiration Date	Date	No	N/A	Product expiration Date
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Expiration_Date', datetime(lsTemp))
			End If				
			
			//Customer  Line Item Number 	C(25)	No	N/A	Customer  Line Item Number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No', long(lsTemp))
			End If			
			

		
			//User Field1	C(50)	No	N/A	User Field
			//User Field2	C(50)	No	N/A	User Field
			//User Field3	C(50)	No	N/A	User Field
			//User Field4	C(50)	No	N/A	User Field
			//User Field5	C(50)	No	N/A	User Field
			//User Field6	C(50)	No	N/A	User Field
			
			uf_process_userfields(17, 6, ldsImport, llFileRowPos, ldsPODetail, llNewDetailRow)	
				
				
				//
				//Note: 
				//
			
				
			//1.	PO item can only be deleted if there are no receipts for the line item.
			//2.	PO Qty can not be reduced below that which has already been received.
			//

			
		CASE Else /* Invalid Rec Type*/
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			Continue
		
	End Choose /*record Type*/
	
Next /*File record */
	
	
//Save the Changes 



SQLCA.DBParm = "disablebind =0"
lirc = ldsPOHeader.Update()
	
If liRC = 1 Then
	liRC = ldsPODetail.Update()
End If
SQLCA.DBParm = "disablebind =1"	

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

public function integer uf_process_dboh (string asproject, string asinifile);
//Process Daily Balance on Hand Confirmation File


Datastore	ldsOut,	&
				ldsboh
				
Long			llRowPos,	&
				llRowCount,	&
				llFindRow,	&
				llNewRow
				
String		lsFind,	&
				lsOutString,	&
				lslogOut,	&
				lsProject,	&
				lsNextRunTime,	&
				lsNextRunDate,	&
				lsRunFreq, &
				lsFilename, &
				lsWarehouse, &
				lsLastWarehouse

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

String lsFileNamePath

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run


//Moved to Scheduled Activity Table

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_nike_dboh'
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Balance On Hand Confirmation!"
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
	lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' BOH confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrive the BOH Data
gu_nvo_process_files.uf_write_log('Retrieving Balance on Hand Data.....') /*display msg to screen*/

llRowCOunt = ldsBOH.Retrieve(lsProject)

gu_nvo_process_files.uf_write_log(String(llRowCount) + ' Rows were retrieved for processing.') /*display msg to screen*/

//Write the rows to the generic output table - delimited by lsDelimitChar
gu_nvo_process_files.uf_write_log('Processing Balance on Hand Data.....') /*display msg to screen*/

For llRowPos = 1 to llRowCOunt


	//03/28/12 - PCONKL - Don't send 'Stk REturn'  Inventory type (S)
	If left(ldsboh.GetItemString(llRowPos,'inventory_type'),1) = 'S' THen COntinue
	
	llNewRow = ldsOut.insertRow(0)
	

	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“BH”	Balance on hand identifier
	
	lsOutString = 'BH' + lsDelimitChar
	
	//Project ID	C(10)	Yes	N/A	Project identifier
	lsOutString +=  asproject  + lsDelimitChar

	//Warehouse Code	C(10)	Yes	N/A	Warehouse ID

	lsWarehouse = left(ldsboh.GetItemString(llRowPos,'wh_code'),10)

	lsOutString +=  lsWarehouse + lsDelimitChar
	
	//Inventory Type	C(1)	Yes	N/A	Item condition

	lsOutString += left(ldsboh.GetItemString(llRowPos,'inventory_type'),1) + lsDelimitChar

	//SKU	C(50)	Yes	N/A	Material number

	//It should be the Nike Material Number without the size at the end. For example: 136027-103

	lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),10) + lsDelimitChar
	
	// 03/28 - PCONKL - ICC only passing Avail_Qty to Nike so combining here and passing zero for allocated
	
	//Quantity	N(15,5)	Yes	N/A	Balance on hand
	
	Long	llTotalQty, llTfr_Out, llalloc_qty, llavail_qty
	
	llavail_qty = ldsboh.GetItemNumber(llRowPos,'avail_qty') 
	llalloc_qty = ldsboh.GetItemNumber(llRowPos,'alloc_qty')
	llTfr_Out = ldsboh.GetItemNumber(llRowPos,'Tfr_Out')
	
	If IsNull(llavail_qty) then llavail_qty = 0
	If IsNull(llalloc_qty) then llalloc_qty = 0
	If IsNull(llTfr_Out) then llTfr_Out = 0
	
	llTotalQty = llavail_qty + llalloc_qty + llTfr_Out
	
	
	//lsOutString += string(ldsboh.GetItemNumber(llRowPos,'avail_qty')) + lsDelimitChar
	lsOutString += string(llTotalQty) + lsDelimitChar /*avail + alloc */

	//Quantity Allocated	N(15,5)	No	N/A	Allocated to Outbound Order
	
	//lsOutString += string(ldsboh.GetItemNumber(llRowPos,'alloc_qty')) + lsDelimitChar
	lsOutString += '0' + lsDelimitChar
	
	//Lot Number	C(50)	No	N/A	1st User Defined Inventory field

	if IsNull(ldsboh.GetItemString(llRowPos,'lot_no')) OR trim(ldsboh.GetItemString(llRowPos,'lot_no')) = '-' then
		lsOutString += lsDelimitChar
	else	
	   lsOutString +=  left(ldsboh.GetItemString(llRowPos,'lot_no'),50) + lsDelimitChar
	end if	

	//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
	
	if IsNull(ldsboh.GetItemString(llRowPos,'po_no')) OR trim(ldsboh.GetItemString(llRowPos,'po_no')) = '-' then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'po_no') + lsDelimitChar
	end if	
	
	//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
	
	if IsNull(ldsboh.GetItemString(llRowPos,'po_no2')) OR Trim(ldsboh.GetItemString(llRowPos,'po_no2')) = '-'  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'po_no2') + lsDelimitChar
	end if		
	
	//Serial Number	C(50)	No	N/A	Qty must be 1 if present
	
	if IsNull(ldsboh.GetItemString(llRowPos,'serial_no')) OR Trim(ldsboh.GetItemString(llRowPos,'serial_no')) = '-'  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'serial_no') + lsDelimitChar
	end if			
	
	//Container ID	C(25)	No	N/A	Container ID
	
	if IsNull(ldsboh.GetItemString(llRowPos,'container_ID')) OR trim(ldsboh.GetItemString(llRowPos,'container_ID')) = '-'  then
		lsOutString +=lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'container_ID') + lsDelimitChar
	end if
	
//	//Expiration Date	Date	No	N/A	Expiration Date	

	lsOutString +=lsDelimitChar


//	If string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'MM/DD/YYYY') <> "12/31/2999" Then
//		lsOutString += string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'YYYY-MM-DD') + lsDelimitChar
//	ELSE
//		lsOutString += string(ldsboh.GetItemdatetime(llRowPos,'complete_date'),'YYYY-MM-DD') + lsDelimitChar
//	End If



	//Item Master UOM
	
	if IsNull(ldsboh.GetItemString(llRowPos,'uom_1')) OR Trim(ldsboh.GetItemString(llRowPos,'uom_1')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'uom_1') + lsDelimitChar
	end if		

	
	//Item Master User_Field1 - Size
	
	if IsNull(ldsboh.GetItemString(llRowPos,'user_field1')) OR Trim(ldsboh.GetItemString(llRowPos,'user_field1')) = ''  then
//		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'user_field1') // + lsDelimitChar
	end if		
	
	
//	BHYYMDD.dat
	
	lsFilename = ("BH" + string(today(), "YYMMDD") + lsWarehouse + ".DAT")
	
	ldsOut.SetItem(llNewRow,'file_name', lsFilename)
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	
	if lsLastWarehouse <> lsWarehouse then

		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
		sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
		commit;
		
		If ldBatchSeq <= 0 Then
			lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' BOH confirmation."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			 Return -1
		End If
		
		lsLastWarehouse = lsWarehouse
		
	end if	
	
	
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
next /*next output record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(ldsOut,lsProject)


//lsFileNamePath = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + lsFileName  + ".txt"
//gu_nvo_process_files.uf_send_email(lsProject,"BOHEMAIL", lsProject + " Daily Balance On Hand Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the BALANCE ON HAND REPORT run on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)
//

Return 0
end function

public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_startuserfield, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow);
integer li_StartCol, li_UFIdx
string lsTemp	

	
 li_StartCol = al_StartImportColumnNumber

//Handle User Fields

For li_UFIdx = al_startuserfield to al_TotalUserFields

	lsTemp = Trim(adw_ImportDW.GetItemString(adw_ImportDWCurrentRow, "col" + string(li_StartCol)))

//	Messagebox ("ok", lsTemp)

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		adw_DestDW.SetItem(adw_DestDWCurrentRow,'User_Field' + string(li_UFIdx), lsTemp)
	End If		

	li_StartCol = li_StartCol + 1
	
Next

RETURN 0
end function

public function integer uf_process_delivery_order (string aspath, string asproject);
string ls_null
string ls_find
integer licount
boolean lb_error_order_sku = false
datetime ldtToday, ldtOrderDate

SetNull(ls_null)

//Process Delivery Order


u_ds_datastore 	ldsSOheader,	ldsSOdetail, ldsDOAddress, ldsDONotes//BCR 12-DEC-2011: For Geistlich...
u_ds_datastore 	ldsImport

integer lirc
boolean lberror
string lslogout

//Call the generic load

u_nvo_proc_baseline_unicode lu_nvo_proc_baseline_unicode

lu_nvo_proc_baseline_unicode = create u_nvo_proc_baseline_unicode	

//BCR 12-DEC-2011: Added one more argument to accommodate Geistlich...
lirc = lu_nvo_proc_baseline_unicode.uf_load_delivery_order(aspath, asproject, ldsImport, ldsSOheader, ldsSOdetail, ldsDOAddress, ldsDONotes)	
	
IF lirc = -1 then lbError = true else lbError = false	

//Specifc Nike Changes before saving

integer liIdx, liFind
string lsNewOrderNumber
long llOrderNoSeq, llCustLineItemNo
long llLineItemNo
string lsOrderNumber
string lsSize, lsSku, lsNewSku

//Consolidation is based on Cust_Code, Cust_Name, Address1 and Request_Date.  For SG, we also want to include Division (Item_Master.GRP). Do not consolidate if any value in ‘Mark For Name’ (UF8)  or ‘MarkFor Address 1’ (UF16)


For liIdx = 1 to  ldsSOdetail.RowCount() 

	//When loading orders, we will combine multiple Nike Delivery Notes into a single Menlo Order. Nike DN will be stored in Delivery_Detail UF1. ICC is mapping the DN to the Order Number (Invoice_No) but we will move it to DD.UF1 and create the order number as the ‘SHP’ number (see below)
	lsSku = ldsSODetail.GetItemString( liIdx, "sku" )	
	lsSize = ldsSODetail.GetItemString( liIdx, "user_field3" )	

	if Not IsNull(lsSize) then
		lsNewSku = lsSku + '-' + lsSize
		
		 ldsSODetail.SetItem( liIdx, "sku", lsNewSku )	
		 
	end if
	
	//Validate SKU
	
	If isNull(lsSku) Then lsSku = ''
	Select Count(*) into :liCount
	From Item_Master
	Where project_id = :asproject and sku = :lsNewSku;
		
		
	If liCount <=0 Then
		
		lsOrderNumber = ldsSODetail.GetItemString( liIdx, "invoice_no")
		
//		liFind =  ldsSOHeader.Find("Upper(invoice_no) = '" + Upper(lsOrderNumber) + "'",  1, ldsSOHeader.RowCount())
		
//		if liFind > 0 then
			lb_error_order_sku = true
//		end if
				
		gu_nvo_process_files.uf_writeError("Order Nbr/Line (detail): " + string(lsOrderNumber) + '/' + string(liIdx) + " Invalid SKU: " + lsNewSku) 

		 ldsSODetail.SetItem( liIdx, "Status_Cd", "E")
		 ldsSODetail.SetItem( liIdx, "Status_Message", "Invalid Sku")			 

		lbError = True
	End If
	
	lsOrderNumber = ldsSODetail.GetItemString( liIdx, "invoice_no" )	
	ldsSODetail.SetItem( liIdx, "user_field1", lsOrderNumber )

	//Category - Read in on UF5 - Set to Lot_No
	ldsSODetail.SetItem( liIdx, "lot_no", ldsSODetail.GetItemString( liIdx, "user_field5" ))

Next

string lsCust_Code, lsCust_Name, lsAddress1
datetime ldtRequestDate
string lsMarkForName, lsMarkForAddress1
long   llRowCount

llRowCount = ldsSOheader.RowCount()

string ls_date

For liIdx =  ldsSOheader.RowCount() to 1 step -1

	if lb_error_order_sku = true then
		ldsSOHeader.SetItem(liIdx, "Status_Cd", "E")
		ldsSOHeader.SetItem(liIdx, "Status_Message", "Invalid Sku" )			 
	end if

	//Check for Duplicates
	lsOrderNumber = ldsSOheader.GetItemString( liIdx, "invoice_no" )	
	
	Select Count(*) into :liCount
		From Delivery_MAster, Delivery_Detail
		Where Delivery_MAster.project_id = :asProject 
		and Delivery_MAster.Do_NO =  Delivery_Detail.Do_NO
		and Delivery_Detail.User_Field1 = :lsOrderNumber and Ord_status <> 'V';	
		
	if liCount > 0 then

		lsLogOut = "Order Nbr (Header) " + string(lsOrderNumber) + " - Order Already Exists and action code is 'Add'"
		FileWrite(gilogFileNo,Space(17) + lsLogOut)
		gu_nvo_process_files.uf_writeError("Order Nbr (Header) " + string(lsOrderNumber) + " - Order Already Exists and action code is 'Add'")
 
		lbError = true

		liFind = 0
				
		DO
			
			liFind =  ldsSODetail.Find("Upper(invoice_no) = '" + Upper(lsOrderNumber) + "'", (liFind + 1), ldsSODetail.RowCount())
			
			if liFind > 0 then
				ldsSODetail.SetItem(liFind, "Status_Cd", "E")
				ldsSODetail.SetItem(liFind, "Status_Message", lsLogOut )			 
			end if
		
		
		LOOP UNTIL  liFind = 0 OR liFind >= ldsSOdetail.RowCount()
	
		
		ldsSOheader.SetItem(liIdx, "Status_Cd", "E")
		ldsSOheader.SetItem(liIdx, "Status_Message", lsLogOut )			 


		CONTINUE

	end if

	ldtToday = DateTime(today(),Now())

	select Max(dateAdd( hour, 8,:ldtToday )) into :ldtOrderDate
	from sysobjects;

	//Set Format for ord_date

	ldsSOheader.SetItem( liIdx, "ord_date",String(ldtOrderDate,'yyyy/mm/dd hh:mm'))
		 


	//Set Format for delivery_date

	ls_date =  ldsSOheader.GetItemString( liIdx, "delivery_date")
	
	if len(ls_date) >= 8 then
		 ls_date = left(ls_date,4) + "/" + mid(ls_date,5,2) + "/" +  mid(ls_date,7,2)
		 ldsSOheader.SetItem( liIdx, "delivery_date",ls_date)
	end if 

	ldsSOheader.SetItem( liIdx, "request_date",  ldsSOheader.GetItemString( liIdx, "delivery_date"))


	//Set Format for schedule_date

	ls_date =  ldsSOheader.GetItemString( liIdx, "schedule_date")
	
	if len(ls_date) >= 8 then
		 ls_date = left(ls_date,4) + "/" + mid(ls_date,5,2) + "/" +  mid(ls_date,7,2)
		 ldsSOheader.SetItem( liIdx, "schedule_date",ls_date)
	end if 


	ldsSOheader.SetItem( liIdx, "inventory_type", 'U' )

//	ldsSOheader.SetItem( liIdx, "order_no", ldsSOheader.GetItemString( liIdx, "invoice_no"))

	lsMarkForName = ldsSOheader.GetItemString( liIdx, "user_field8")
	
	
	lsMarkForAddress1 = ldsSOheader.GetItemString( liIdx, "user_field16")


	If Not IsNull(lsMarkForName) or Not IsNull(lsMarkForName) then continue

	 lsCust_Code = ldsSOheader.GetItemString( liIdx, "cust_code")
	 lsCust_Name = ldsSOheader.GetItemString( liIdx, "cust_name")
	 lsAddress1	= ldsSOheader.GetItemString( liIdx, "address_1")

	IF liIdx = 1 then continue


	uf_replace_quote(lsCust_Code)
	uf_replace_quote(lsCust_Name)
	uf_replace_quote(lsAddress1)	
	
	ls_find = " cust_code = '"+lsCust_Code+"' and cust_name = '"+lsCust_Name+"' and address_1 = '"+lsAddress1+ "' and  (IsNull(user_field8)  or trim(user_field8) = ''  ) and ( IsNull(user_field16) or trim(user_field16) =  '' ) "

	 liFind = ldsSOheader.Find(ls_find , 1, liIdx -1)

	if liFind > 0 then
		
		long llNewOrder_Seq_No, liOrderSeqNo
		
		//All detail rows changed to new order no.
	
		lsOrderNumber = ldsSOheader.GetItemString( liIdx, "invoice_no" )	
		liOrderSeqNo = ldsSOheader.GetItemNumber( liIdx, "order_seq_no" )
		lsNewOrderNumber = ldsSOheader.GetItemString( liFind, "invoice_no" )	
		llNewOrder_Seq_No = ldsSOheader.GetItemNumber( liFind, "Order_Seq_No" )	
	
		liFind = 0
				
		DO
			
			liFind =  ldsSODetail.Find("Upper(invoice_no) = '" + Upper(lsOrderNumber) + "'",(liFind+1), ldsSODetail.RowCount())
			
			if liFind > 0 then
				 ldsSODetail.SetItem( liFind, "invoice_no", lsNewOrderNumber )
				 ldsSODetail.SetItem( liFind, "Order_Seq_No", llNewOrder_Seq_No )				 
			end if
		
		
		LOOP UNTIL  liFind = 0 OR liFind >= ldsSOdetail.RowCount()
	
	
		//Delete row
		
		ldsSOheader.DeleteRow(liIdx)
		
		//Remove Address Row
		
		liFind =  ldsDOAddress.Find("Order_Seq_No = " + String(liOrderSeqNo), 1, ldsDOAddress.RowCount())

		if liFind > 0 then
				ldsDOAddress.DeleteRow(liFind)
		end if
		
		
	end if

Next


//SIMS Order Number will be created as SHPyyyymmxxxxx where yyyy=year, mm=month and xxxxx = sequential number.  The Next Sequence generator will return everything except the ‘SHP’
//Need to replace invoice number with new invoice number.


For liIdx = 1 to ldsSOheader.RowCount()
	
	IF ldsSOheader.GetItemString( liIdx, "Status_Cd") = "E" THEN CONTINUE
	
	llLineItemNo = 0
	
	lsOrderNumber = ldsSOheader.GetItemString( liIdx, "invoice_no")

	llOrderNoSeq =  gu_nvo_process_files.uf_get_next_seq_no(asproject,'Delivery_Master','INVOICE_NO')
	
	If llOrderNoSeq <= 0 Then Return -1

	lsNewOrderNumber = 'SHP' + String(today(),'YYYY')   +  string(llOrderNoSeq,'0000000')
        
//	MessageBox (lsOrderNumber, lsNewOrderNumber)	  
	
	 ldsSOheader.SetItem( liIdx, "invoice_no", lsNewOrderNumber )
		  
	liFind = 0
				
	DO
		
		liFind =  ldsSODetail.Find("Upper(invoice_no) = '" + Upper(lsOrderNumber) + "'", (liFind+1), ldsSODetail.RowCount())
		
		if liFind > 0 then
		
			//We will sequentially assign our own Line_Item_No since we are combining multiple order numbers. Nike’s Line will be stored in User_line_Item
		
			llLineItemNo = llLineItemNo + 1

			llCustLineItemNo =  ldsSODetail.GetItemNumber( liFind, "line_item_no" )
			
			 ldsSODetail.SetItem( liFind, "line_item_no",  llLineItemNo)
		
			 ldsSODetail.SetItem( liFind, "invoice_no", lsNewOrderNumber )
		end if
	
	
	LOOP UNTIL  liFind = 0 OR liFind >= ldsSOdetail.RowCount()
	
Next


//VAS info is being passed in Line Item Notes:

//If the first Char is ‘T’ and 4 thru 6 = ‘LBL’, then  set DD.UF3 = ‘LBL’
//If the first char = ‘T’ and 4 thru 6 = ‘CAR’, then set DD.UF4 = ‘CAR’

string lsLineItemNotes


ldsSODetail.SetSort("EDI_Batch_Seq_No asc, Order_Seq_No asc, 	user_field1 asc,  order_line_no asc line_item_no asc")
ldsSODetail.Sort()

long llOrderSeqNo
long llLastOrderSeqNo = 0

long llOrderLineNo

For liIdx = 1 to ldsSODetail.RowCount()

	llOrderSeqNo = ldsSODetail.GetItemNumber( liIdx, "Order_Seq_No")

	if llLastOrderSeqNo <> llOrderSeqNo then
		llOrderLineNo = 1
		llLastOrderSeqNo = llOrderSeqNo
	else
		llOrderLineNo = llOrderLineNo + 1
	end if

//	MessageBox (lsOrderNumber, lsOrderNumber + string( llOrderLineNo) )

	ldsSODetail.SetItem( liIdx, "order_line_no", string(llOrderLineNo))	

	lsLineItemNotes = ldsSODetail.GetItemString(liIdx,'line_item_notes')
	
	If Left(lsLineItemNotes,1) = "T" and mid(lsLineItemNotes, 4, 3) = "LBL" then ldsSODetail.SetItem(liIdx,'user_field3', "LBL")
	If Left(lsLineItemNotes,1) = "T" and mid(lsLineItemNotes, 4, 3) = "CAR" then ldsSODetail.SetItem(liIdx,'user_field4', "CAR")
	
Next


	
	
	

//Save the Changes 
SQLCA.DBParm = "disablebind =0"
lirc = ldsSOheader.Update()
SQLCA.DBParm = "disablebind =1"

	
If liRC = 1 Then
//	SQLCA.DBParm = "disablebind =0"
	liRC = ldsSOdetail.Update()
//	SQLCA.DBParm = "disablebind =1"
	
ELSE
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Header Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If



If liRC = 1 Then
	
//	Execute Immediate "COMMIT" using SQLCA; COMMIT USING SQLCA;
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsDOAddress.Update()
	SQLCA.DBParm = "disablebind =1"
ELSE	
//	Execute Immediate "ROLLBACK" using SQLCA;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Detail Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If

//BCR 12-DEC-2011: For Geistlich...
If liRC = 1 Then
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsDONotes.Update()
	SQLCA.DBParm = "disablebind =1"	
ELSE
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new DO Address Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If
//END

	
If liRC = 1 then
//	Commit;
Else
	
//	Execute Immediate "ROLLBACK" using SQLCA; 
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Records to database!"
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

public function integer uf_process_itemmaster (string aspath, string asproject);
//Item master (832) 

//-	When loading a new SKU, check the new serial_prefix table. If the first 2 char of the SKU match a table entry, set the Serial_Tracking_Ind to ‘O’ (outbound)
//
//-	Default Supp_code to ‘NIKE’ for new SKUs
//
//-	Load Division into GRP field. This is used in many functions/reports for Sorting and breaking
//
//-	‘Material Number’ is col3 (sku)
//
//-	Size is UF1
//

//The Size should be loading into UF12 and we also need to be appending it to the end of the SKU coming in from ICC. 
//For example, In the file you loaded on the first, the first record has the SKU as “484890-010”. 
//	We should be appending the size so our SKU is “484890-010-S”, “494890-010-M”, “494890-010-L”,
//	“494890-010-XL” , “494890-010-2XL” and “494890-010-3XL”. 
//


//	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
//	If lsTemp <> 'IM' Then
//		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
//		lbError = True
//		Continue /*Process Next Record */
//	End If



//When loading a new SKU, check the new serial_prefix table. If the first 2 char of the SKU match a table entry, set the Serial_Tracking_Ind to ‘O’ (outbound)




//Process Item Master (IM) Transaction for Baseline Unicode Client

STRING lsTemp, lsProject, lsSku, lsSupplier, lsSize, lsPreFix
BOOLEAN lbError, lbNew
LONG llCount, llNew, llNewRow, llOwner, llexist
INTEGER lirc, liRtnImp
STRING lsLogOut
u_ds_datastore	ldsImport

//Item Master

u_ds_datastore	ldsItem 

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_baseline_unicode_item_master'
ldsItem.SetTransObject(SQLCA)

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

//Convert to Chinese - CodePage

integer li_row_idx, li_col_idx 
string lsdata, lsConvData


if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Item Master File for '+asproject+' Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

integer llFileRowPos
integer llFilerowCount
string lsMaterialNo

llFilerowCount = ldsImport.RowCount()

//Loop through

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCount))

	//Field Name	Type	Req.	Default	Description
	//Record ID	C(2)	Yes	“IM”	Item Master Identifier

	//Validate Rec Type is IM
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
	If lsTemp <> "IM" Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If

	//Project ID	C(10)	Yes	N/A	Project identifier
	
	lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col2")))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		lsProject = lsTemp
	End If	
	
	//SKU	C(50)	Yes	N/A	Material number

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		lsSku = lsTemp
	End If	

	lsMaterialNo = lsSku

	//Supplier Code	C(20)	Yes	N/A	Valid Supplier code

	lsSupplier = "NIKE"
	
	lsSize = Trim(ldsImport.GetItemString(llFileRowPos, "col47"))
	
	if Not IsNull(lsSize) then
		
		lsSku = lsSku + "-" + lsSize
		
	end if
		
//	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
//	
//	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
//		lbError = True
//		Continue		
//	Else
//		lsSupplier = lsTemp
//	End If	

	
	////Retrieve for SKU - We will be updating across Suppliers

	llCount = ldsItem.Retrieve(lsProject, lsSKU, lsSupplier)

	If llCount <= 0 Then

		llNew ++ /*add to new count*/
		lbNew = True
		llNewRow = ldsItem.InsertRow(0)

		ldsItem.SetItem(1,'SKU',lsSKU)
		ldsItem.SetItem(1,'project_id', lsProject)		
		
		//Get Default owner for Supplier
		Select owner_id into :llOwner
		From Owner
		Where project_id = :lsProject and Owner_type = 'S' and owner_cd = :lsSupplier;
		
		
		If IsNull(llOwner) OR llOwner <= 0  Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Owner for Supplier ("+lsSupplier+") not found in database.")
			lbError = True
			Continue			
		End If
		
		ldsItem.SetItem(1,'supp_code',lsSupplier)
		ldsItem.SetItem(1,'owner_id',llOwner)
							
	Else /*exists*/		
		llexist += llCount /*add to existing Count*/
		lbNew = False
	End If
	
	//Description	C(70)	Yes	N/A	Item description

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Description is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		ldsItem.SetItem(1,'description', lsTemp)
	End If	

	//UOM1	C(4)	No	“EA”	Base unit of measure

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		lsTemp = "EA"
	End If	
	
	ldsItem.SetItem(1,'uom_1', lsTemp)
	
	//Length1	N(9,2)	No	N/A	Item Length
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Length_1', Dec(lsTemp))
	End If	
	
	//Width1	N(9,2)	No	N/A	Item Width
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Width_1', Dec(lsTemp))
	End If		
	
	//Height1 	N(9,2)	No	N/A	Item Height
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Height_1', Dec(lsTemp))
	End If		
	
	//Weight1	N(11,5)	No	N/A	Net weight of base unit of measure (kg)

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Weight_1', Dec(lsTemp))
	End If			
	
	//UOM2	C(4)	No	N/A	Level 2 unit of measure
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'UOM_2', lsTemp)
	End If			
	
	//Length2	N(9,2)	No	N/A	Item Length
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Length_2', Dec(lsTemp))
	End If			
	
	//Width2	N(9,2)	No	N/A	Item Width

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Width_2', Dec(lsTemp))
	End If		
	
	//Height2 	N(9,2)	No	N/A	Item Height
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Height_2', Dec(lsTemp))
	End If			
	
	//Weight2	N(11,5)	No	N/A	Net weight of base unit of measure (kg)
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Weight_2', Dec(lsTemp))
	End If			
	
	//Qty 2	N(15,5)	No	N/A	Level 2 Qty in relation to base UOM
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Qty_2', Dec(lsTemp))
	End If			
	
	
	//UOM3	C(4)	No	N/A	Level 3 unit of measure
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'UOM_3', lsTemp)
	End If			
	
	//Length3	N(9,2)	No	N/A	Item Length
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col18"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Length_3', Dec(lsTemp))
	End If		
	
	//Width3	N(9,2)	No	N/A	Item Width
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col19"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Width_3', Dec(lsTemp))
	End If			
	
	//Height3	N(9,2)	No	N/A	Item Height

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col20"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Height_3', Dec(lsTemp))
	End If			
	
	//Weight3	N(11,5)	No	N/A	Net weight of base unit of measure (kg)
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col21"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Weight_3', Dec(lsTemp))
	End If				
	
	//Qty 3	N(15,5)	No	N/A	Level 3 Qty in relation to Base UOM

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col22"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Qty_3', Dec(lsTemp))
	End If				

	//UOM4	C(4)	No	N/A	Base unit of measure

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col23"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'UOM_4', lsTemp)
	End If			
	
	//Length4	N(9,2)	No	N/A	Item Length
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col24"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Length_4', Dec(lsTemp))
	End If			
	
	//Width4	N(9,2)	No	N/A	Item Width

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col25"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Width_4', Dec(lsTemp))
	End If			
	
	
	//Height4	N(9,2)	No	N/A	Item Height

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col26"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Height_4', Dec(lsTemp))
	End If			

	
	//Weight4	N(11,5)	No	N/A	Net weight of base unit of measure (kg)

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col27"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Weight_4', Dec(lsTemp))
	End If			
	
	//Qty 4	N(15,5)	No	N/A	Level 4 Qty in relation to Base UOM

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col28"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Qty_4', Dec(lsTemp))
	End If			

	//Cost	N(12,4)	No	N/A	Item Cost (std_cost)

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col29"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'std_cost', Dec(lsTemp))
	End If				
	
	//CC Frequency	N(5,0)	No	N/A	Cycle count frequency (in days)

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col30"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'CC_Freq', Dec(lsTemp))
	End If			
	
	//HS Code	C(15)	No	N/A	HS Code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col31"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'HS_Code', lsTemp)
	End If			
	
	//UPC Code	C(14)	No	N/A	UPC Code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col32"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Part_UPC_Code', dec(lsTemp))
	End If			
	
	//Freight Class	C(10)	No	N/A	Freight Class

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col33"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Freight_Class', lsTemp)
	End If			

	//Storage Code	C(10)	No	N/A	Storage Code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col34"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'storage_code', lsTemp)
	End If			
	
	//Inventory Class	C(10)	No	N/A	Inventory Class

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col35"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'inventory_class', lsTemp)
	End If			
	
	//Alternate SKU	C(50)	No	N/A	Alternate/Customer SKU

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col36"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Alternate_SKU', lsTemp)
	End If				
	
	//COO	C(3)	No	N/A	Default Country of Origin
	//Validate COO if present, otherwise Default to XXX

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col37"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then

		If f_get_Country_name(lsTemp) <= ' ' Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Country of Origin: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue /*Process Next Record */
		Else		
			ldsItem.SetItem(1,'Country_of_Origin_Default', lsTemp)
		End If
		
	Else
		//Set Default to 'XXX'
		ldsItem.SetItem(1,'Country_of_Origin_Default', 'XXX')   
	End If				

	
	//Shelf Life	N(5)	No	N/A	Shelf life in Days

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col38"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Shelf_Life', Dec(lsTemp))
	End If			
	
	//Inventory Tracking field 1 (Lot) Controlled	C(1)	No	N/A	Inventory Tracking field 1 (Lot) Controlled Indicator

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col39"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Lot_Controlled_Ind', lsTemp)
	End If		
	
	//Inventory Tracking field 2 (PO) Controlled	C(1)	No	N/A	Inventory Tracking field 2 (PO) Controlled Indicator

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col40"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'PO_Controlled_Ind', lsTemp)
	End If			
	
	//Inventory Tracking field 3 (PO2) Controlled	C(1)	No	N/A	Inventory Tracking field 3 (PO2) Controlled Indicator

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col41"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'PO_NO2_Controlled_Ind', lsTemp)
	End If			
	
	//Serialized Indicator	C(1)	No	N/A	Serialized Indicator
		//N = not serialized
		//B	 = capture serial # at receipt and when shipped but don’t track in inventory
		//O = capture serial # only when shipped
		//Y	 = capture serial # at receipt, track in inventory and when shipped
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col42"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Serialized_Ind', lsTemp)
	End If			

	//Expiration Date Controlled	C(1)	No	N/A	Expiration Date Controlled indicator
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col43"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'expiration_controlled_ind', lsTemp)
	End If		
	
	//Container Tracking Indicator	C(1)	No	N/A	Container Tracking Indicator

	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col44"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'container_tracking_ind', lsTemp)
	End If	
	
	//Delete Flag	C(1)	No	“N”	Flag for record deletion
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col45"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Item_Delete_Ind', lsTemp)
	End If		

	
	//Native Description	C(75)	No	N/A	Foreign language Description

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col46"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Native_Description', lsTemp)
	End If		

	//Handle User Fields

	//User Field1	C(10)	No	N/A	User Field
	//User Field2	C(10)	No	N/A	User Field
	//User Field3	C(10)	No	N/A	User Field
	//User Field4	C(10)	No	N/A	User Field
	//User Field5	C(10)	No	N/A	User Field
	//User Field6	C(20)	No	N/A	User Field
	//User Field7	C(20)	No	N/A	User Field
	//User Field8	C(30)	No	N/A	User Field
	//User Field9	C(30)	No	N/A	User Field
	//User Field10	C(30)	No	N/A	User Field
	//User Field11	C(30)	No	N/A	User Field
	//User Field12	C(30)	No	N/A	User Field
	//User Field13	C(30)	No	N/A	User Field
	//User Field14	C(70)	No	N/A	User Field
	//User Field15	C(70)	No	N/A	User Field
	//User Field16	C(70)	No	N/A	User Field
	//User Field17	C(70)	No	N/A	User Field
	//User Field18	C(70)	No	N/A	User Field
	//User Field19	C(70)	No	N/A	User Field
	//User Field20	C(70)	No	N/A	User Field
	
	//Use a function to load the userfields.
	
	uf_process_userfields(47, 20, ldsImport, llFileRowPos, ldsItem, 1)	
	
	//-	Load Division into GRP field. This is used in many functions/reports for Sorting and breaking

	//Division

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col67"))


	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'grp', lsTemp)
	End If			

	
	if NOT isValid( ids_nike_sku_serialized_ind ) then 
		
		ids_nike_sku_serialized_ind = CREATE datastore
		ids_nike_sku_serialized_ind.dataobject = "d_nike_sku_serialized_ind"
		ids_nike_sku_serialized_ind.SetTransObject(SQLCA)
		ids_nike_sku_serialized_ind.Retrieve(	lsProject)
	end if
	
	lsPreFix = upper(left(lsSku, 2))

	IF ids_nike_sku_serialized_ind.Find("code_id='"+lsPreFix+"'", 1, ids_nike_sku_serialized_ind.RowCount()) > 0 then 
		
		ldsitem.SetItem(1,'Serialized_Ind', 'O')
			
	Else 

		ldsitem.SetItem(1,'Serialized_Ind', 'N')
		
	End IF
	
	//- ‘Material Number’ i
	ldsitem.SetItem(1,'user_field11', lsMaterialNo)
	
	ldsItem.SetItem(1,'Last_user','SIMSFP')
	ldsItem.SetItem(1,'last_update',today())	
		
//Note: 
//
//1.	If delete flag is set for “Y”, the item will not be available for further transactions.
//2.	If delete flag is set for “Y” and no warehouse transaction exist, the record will be physically deleted from database.

	ldsItem.SetItem(1,'Lot_Controlled_Ind', 'Y')	
	ldsItem.SetItem(1,'standard_of_measure', 'M')	
	
		
	//Save New Item to DB
//	SQLCA.DBParm = "disablebind =0"
	lirc = ldsItem.Update()
//	SQLCA.DBParm = "disablebind =1"
	
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

public function integer uf_replace_quote (ref string as_string);string lsquote, lsreplace_with

lsquote = "'"
lsreplace_with = "~~~'"

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

return 0
end function

public function integer uf_reset_sequence_number (string asproject, string asinifile);
string lsLogOut

//MEA - 12/11

//Per Pete
//I think we can just add a scheduled function in the Sweeper that will run just after midnight SG/MY time. 
//It should run everyday but unless it is the first day of the month, it can quit (since we don't have a way to 
//make it only run on the first). On the first, we just want to reset the 2 sequence numbers (Inbound and Outbound) as 
//MM00000 where MM = Month.

//We need a function to run at midnight (warehouse time) to reset the Inbound and Outbound Order Sequences 
//used to create the Inbound/Outbound Order Numbers.  It can be scheduled to run daily and if not the first day 
//of the month, return. We can add new entries to the Next Sequence generator table. We should store the 
//entire format (‘yyyymmxxxxx’) so the client doesn’t need to determine the year and month.  
//At the beginning of the month we will bump up the month and if necessary the year (resetting the month to 01). 
//The client will just add the ‘RCT’  or ‘SHP’ prefix after retrieving the next sequence number.

IF day(today()) = 1 THEN

	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	lsLogOut = "- PROCESSING FUNCTION: Reset the Inbound and Outbound Order Sequences - " + string(asproject)
	FileWrite(gilogFileNo,lsLogOut)
	
	long ll_num
	
	//Format - MM00000
	
	ll_num = long(string(month(today())) + '00000')
	
	UPDATE next_sequence_no 
		SET  next_avail_seq_no = :ll_num
		WHERE Table_Name = 'Delivery_Master' and Column_Name = 'INVOICE_NO' and Project_ID = :asproject USING SQLCA;
	
	UPDATE next_sequence_no 
		SET  next_avail_seq_no = :ll_num 
		  WHERE Table_Name = 'Receive_Master' and Column_Name = 'SUPP_INVOICE_NO' and Project_ID = :asproject USING SQLCA;

End IF

RETURN 0
end function

on u_nvo_proc_nike_ewms.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_nike_ewms.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

