HA$PBExportHeader$u_nvo_proc_baseline_unicode.sru
forward
global type u_nvo_proc_baseline_unicode from nonvisualobject
end type
end forward

global type u_nvo_proc_baseline_unicode from nonvisualobject
end type
global u_nvo_proc_baseline_unicode u_nvo_proc_baseline_unicode

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 

end prototypes

type variables

string lsDelimitChar

end variables

forward prototypes
public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow)
public function integer uf_process_delivery_order (string aspath, string asproject)
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_return_order (string aspath, string asproject)
public function integer uf_process_dboh (string asproject, string asinifile)
public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_startuserfield, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow)
public function integer uf_load_delivery_order (string aspath, string asproject, ref datastore asgenericimport, ref datastore asdeliverymaster, ref datastore asdeliverydetail, ref datastore asdeliveryaddress, ref datastore asdeliverynotes)
public function integer uf_process_customer (string aspath, string asproject)
public function integer uf_process_supplier (string aspath, string asproject)
public function integer uf_load_purchase_order (string aspath, ref string asproject, ref datastore asgenericimport, ref datastore adspoheader, ref datastore adspodetail)
public function integer uf_process_purchase_order (string aspath, ref string asproject)
protected function boolean uf_otm_fields_modified (string as_action, datastore ads_current, datastore ads_original, long al_row)
public function integer uf_process_itemmaster (string aspath, readonly string asproject)
end prototypes

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

public function integer uf_process_delivery_order (string aspath, string asproject);//
//Process Sales Order (DM) Transaction for Baseline Unicode Client
//Process Delivery Order


u_ds_datastore 	ldsSOheader,	ldsSOdetail, ldsDOAddress, ldsDONotes//BCR 12-DEC-2011: For Geistlich...
u_ds_datastore 	ldsImport

integer lirc
boolean lberror
string lslogout

//Call the generic load

//BCR 12-DEC-2011: Added one more argument to accommodate Geistlich...
lirc = uf_load_delivery_order(aspath, asproject, ldsImport, ldsSOheader, ldsSOdetail, ldsDOAddress, ldsDONotes)	

IF lirc = -1 then lbError = true else lbError = false	


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



If liRC = 1 Then
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsDOAddress.Update()
	SQLCA.DBParm = "disablebind =1"
ELSE	
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

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut,	&
			lsSaveFileName, &
			lsPOLineCountFileName
			
Integer	liRC
integer 	liLoadRet, liProcessRet
Boolean	bRet

Choose Case Upper(Left(asFile,2))
		
	Case  'PM'  
		
		liRC = uf_process_purchase_order(asPath, asProject)
	
		//Process any added PO's
		//We need to change to project. This will be changed after testing.
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject)  //asProject

	Case  'DM'  
		
		liLoadRet = uf_process_delivery_order(asPath, asProject)
			
		//Process any added SO's
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liProcessRet = gu_nvo_process_files.uf_process_Delivery_order( asProject )
		
		
		if liLoadRet = -1 OR liProcessRet = -1 then liRC = -1 else liRC = 0
		

		
	Case 'IM'
		
		liRC = uf_Process_ItemMaster(asPath, asProject)
		

	Case  'RM'  
		
		liRC = uf_return_order(asPath, asProject)
	
		//Process any added PO's
		//We need to change to project. This will be changed after testing.
		liRC = gu_nvo_process_files.uf_process_purchase_order('CHINASIMS')  //asProject
		
		
	Case 'CM' /* 04/13 - PCONKL - Added Customer Master to baseline */
		
		liRC = uf_Process_Customer(asPath, asProject)
		
	Case 'SM' /* 04/13 - PCONKL - Added Supplier Master to baseline */
		
		liRC = uf_Process_Supplier(asPath, asProject)
		
		
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
	//Record_ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$RM$$HEX2$$1d200900$$ENDHEX$$Return order master identifier
	//Record ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$RD$$HEX2$$1d200900$$ENDHEX$$Purchase order detail identifier

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
				//A $$HEX2$$13202000$$ENDHEX$$Add
				//U $$HEX2$$13202000$$ENDHEX$$Update
				//D $$HEX2$$13202000$$ENDHEX$$Delete
				//X $$HEX2$$13202000$$ENDHEX$$Ignore (Add or update regardless)
				
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
				
				
			//Order Type	C(1)	Yes	$$HEX1$$1c20$$ENDHEX$$S$$HEX2$$1d200900$$ENDHEX$$Must be valid order typr
			
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
			//6.	Updated RM/RD$$HEX1$$1920$$ENDHEX$$s should include all of the information for the RM/RD$$HEX1$$1920$$ENDHEX$$s regardless of whether or not a specific item has been changed.
			//
						

		//Return Detail				
				
		CASE 'RD' /* detail*/

		//Return Order Detail

			//Change ID	C(1)	Yes	N/A	
				//A $$HEX2$$13202000$$ENDHEX$$Add
				//U $$HEX2$$13202000$$ENDHEX$$Update
				//D $$HEX2$$13202000$$ENDHEX$$Delete

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
			
			//Alternate SKU	C(50)	No	N/A	Supplier$$HEX1$$1920$$ENDHEX$$s material number
			
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

//lsNextRunDate = ProfileString(asIniFile,asproject,'DBOHNEXTDATE','')
//lsNextRunTime = ProfileString(asIniFile, asproject,'DBOHNEXTTIME','')
//
//
//If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
//	Return 0
//Else /*valid date*/
//	ldtNextRunTIme = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
//	If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
//		Return 0
//	End If
//End If

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_baseline_unicode_dboh'
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

	llNewRow = ldsOut.insertRow(0)
	

	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$BH$$HEX2$$1d200900$$ENDHEX$$Balance on hand identifier
	
	lsOutString = 'BH' + lsDelimitChar
	
	//Project ID	C(10)	Yes	N/A	Project identifier
	lsOutString +=  asproject  + lsDelimitChar

	//Warehouse Code	C(10)	Yes	N/A	Warehouse ID

	lsWarehouse = left(ldsboh.GetItemString(llRowPos,'wh_code'),10)

	lsOutString +=  lsWarehouse + lsDelimitChar
	
	//Inventory Type	C(1)	Yes	N/A	Item condition

	lsOutString += left(ldsboh.GetItemString(llRowPos,'inventory_type'),1) + lsDelimitChar

	//SKU	C(50)	Yes	N/A	Material number

	lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),26) + lsDelimitChar
	
	//Quantity	N(15,5)	Yes	N/A	Balance on hand
	
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'avail_qty')) + lsDelimitChar

	//Quantity Allocated	N(15,5)	No	N/A	Allocated to Outbound Order
	
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'alloc_qty')) + lsDelimitChar
	
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
	
	//Expiration Date	Date	No	N/A	Expiration Date	

	If string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'MM/DD/YYYY') <> "12/31/2999" Then
		lsOutString += string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'YYYY-MM-DD') + lsDelimitChar
	ELSE
		lsOutString +=lsDelimitChar
	End If

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
	
	lsFilename = ("BH" + string(today(), "YYMMDD") + lsWarehouse + ".dat")
	
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

// TAM 2011/09  Added ability to email the report

lsFileNamePath = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + lsFileName  + ".txt"
gu_nvo_process_files.uf_send_email(lsProject,"BOHEMAIL", lsProject + " Daily Balance On Hand Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the BALANCE ON HAND REPORT run on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)


//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile, asproject,'DBOHFREQ','')
If isnumber(lsRunFreq) Then
	//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile, asproject,'DBOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile, asproject,'DBOHNEXTDATE','')
End If

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

public function integer uf_load_delivery_order (string aspath, string asproject, ref datastore asgenericimport, ref datastore asdeliverymaster, ref datastore asdeliverydetail, ref datastore asdeliveryaddress, ref datastore asdeliverynotes);
//Load Sales Order (DM) Transaction for Baseline Unicode Client

STRING lsTemp, lsProject, lsSku, lsSupplier, lsWarehouse, lsOrderNumber, lsOrderType, lsHeaderProject
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo,llPos
LONG llNewAddressRow, llNoteSequence, llNewNotesRow
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow
STRING lsLogOut, lsChangeID
INTEGER li_StartCol
INTEGER li_UFIdx
DECIMAL ldQuantity
STRING lsCustomerCode
STRING ls_OrderDate, ls_DeliveryDate, ls_GI_Date
BOOLEAN lbBillToAddress
STRING lsBillToAddr1, lsBillToAddr2, lsBillToAddr3, lsBillToAddr4, lsBillToCity
STRING	lsBillToState, lsBillToZip, lsBillToCountry, lsBillToTel, lsBillToName
STRING ls_InventoryType, lsNoteType, lsNoteText


u_ds_datastore 	ldsSOheader,	&
				ldsSOdetail, &
				ldsDOAddress, ldsDONotes//BCR 13-DEC-2011: Geistlich needs DeliveryNotes processing...
				
u_ds_datastore ldsImport

ldsSOheader = Create u_ds_datastore
ldsSOheader.dataobject= 'd_baseline_unicode_shp_header'
ldsSOheader.SetTransObject(SQLCA)

ldsSOdetail = Create u_ds_datastore
ldsSOdetail.dataobject= 'd_baseline_unicode_shp_detail'
ldsSOdetail.SetTransObject(SQLCA)

ldsDOAddress = Create u_ds_datastore
ldsDOAddress.dataobject = 'd_baseline_unicode_do_address'
ldsDOAddress.SetTransObject(SQLCA)

//BCR 13-DEC-2011: Geistlich needs DeliveryNotes processing...
ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes'
ldsDONotes.SetTransObject(SQLCA)


ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Sales Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

//GailM 2/7/2018 - Defect DE3036 - SIMS Sweeper - files in error not being processed correctly - Wrap in if/then/else
if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Sales Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	lbError = True
else

	integer llFileRowPos
	integer llFilerowCount
	
	llFilerowCount = ldsImport.RowCount()
	
	//Get the next available file sequence number
	
	llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
	If llBatchSeq <= 0 Then Return -1
	
	//llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
	//If llBatchSeq <= 0 Then Return -1
	
	//Loop through
	
	//
	//Delivery Order Master
	//
	
	//
	//* - Either the Delivery Date or the Goods issue Date is required. If neither is present, the order drop date will be the default ship date.
	//
	//
	
	
	for llFileRowPos = 1 to llFilerowCount
	
		w_main.SetMicroHelp("Processing Sales Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))
	
	
		//Field Name	Type	Req.	Default	Description
		//Record ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$DM$$HEX2$$1d200900$$ENDHEX$$Delivery order master identifier
		//Record ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$DD$$HEX2$$1d200900$$ENDHEX$$Delivery order detail identifier
		
		//BCR 12-DEC-2011: Need to introduce Delivery Note for Geistlich...
		//Record ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$DN$$HEX2$$1d200900$$ENDHEX$$Delivery Note identifier
	
		//Validate Rec Type is DM OR DD
		lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
		If NOT (lsTemp = 'DM' OR lsTemp = 'DD' OR lsTemp = 'DN') Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			//Continue /*Process Next Record */
		End If
	
		Choose Case Upper(lsTemp)
		
			//Delivery Order Master
		
			//HEADER RECORD
			Case 'DM' /* Header */
	
	
				//Change ID	C(1)	Yes	N/A	
					//A $$HEX2$$13202000$$ENDHEX$$Add
					//U $$HEX2$$13202000$$ENDHEX$$Update
					//D $$HEX2$$13202000$$ENDHEX$$Delete
					//X $$HEX2$$13202000$$ENDHEX$$Ignore (Add or update regardless)
					
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
					lsheaderProject = lsTemp /* 02/13 - PCONKL*/
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
								
				
				//Delivery Number	C(20)	Yes	N/A	Delivery Order Number
	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsOrderNumber = lsTemp
				End If					
					
								
				//Order Date	Date	No	N/A	Order Date
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				Else
					ls_OrderDate = lsTemp
				End If				
				
				
				//Delivery Date	Date	No*	*	Date for delivery to Customer
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				Else
					ls_DeliveryDate = lsTemp
				End If				
				
				//GI Date	Date	No*	*	Planned goods ship date from warehouse
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				Else
					ls_GI_Date = lsTemp
				End If				
				
				
				//Customer Code	C(20)	Yes	N/A	Customer ID
			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
				
	//			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
	//				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Code is required. Record will not be processed.")
	//				lbError = True
	//				Continue		
	//			Else
					lsCustomerCode = lsTemp
	//			End If		
	
	
				/* End Required */		
	
				
				
				liNewRow = 	ldsSOheader.InsertRow(0)
				llOrderSeq ++
				llLineSeq = 0			
				
				//New Record Defaults
				ldsSOheader.SetItem(liNewRow,'project_id',lsProject)
				ldsSOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
	//			ldsSOheader.SetItem(liNewRow,'Request_date',String(Today(),'YYMMDD'))
				ldsSOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsSOheader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
				ldsSOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
				ldsSOheader.SetItem(liNewRow,'status_cd','N')
				ldsSOheader.SetItem(liNewRow,'Last_user','SIMSEDI')
	
				ldsSOheader.SetItem(liNewRow,'invoice_no',lsOrderNumber)			
	
	//			ldsSOheader.SetItem(liNewRow,'Inventory_Type','N') /*default to Normal*/
	
				ldsSOheader.SetItem(liNewRow,'cust_code',lsCustomerCode) /*Order Type*/
		
		
				ldsSOheader.SetItem(liNewRow,'action_cd',lsChangeID) /*Supplier Order*/	
	
	//			1.	Map Delivery Date on DM to $$HEX1$$1c20$$ENDHEX$$Delivery Date$$HEX2$$1d202000$$ENDHEX$$in SIMS
	//			2.	Map GI Date on DM to $$HEX1$$1c20$$ENDHEX$$Schedule Date$$HEX2$$1d202000$$ENDHEX$$in SIMS
	//			
				
				ldsSOheader.SetItem(liNewRow,'ord_date',ls_OrderDate)
				ldsSOheader.SetItem(liNewRow,'delivery_date',ls_DeliveryDate)
				ldsSOheader.SetItem(liNewRow,'schedule_date',ls_GI_Date)
			
				//Order Type	C(1)	No	N/A	Order Type
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					lsTemp = "S"	
				Else
					lsOrderType = lsTemp
					
					ldsSOheader.SetItem(liNewRow,'Order_type',lsOrderType) /*Order Type*/	
									
				End If					
					
					
				//Customer Order #	C(20)	No	N/A	Customer Order Number
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'order_no', lsTemp)
				End If		
							
				
				//Carrier	C(20)	No	N/A			
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'carrier', lsTemp)
				End If		
				
			
				
				//Transport Mode	C10)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'transport_mode', lsTemp)
				End If		
				
				//Ship Via	C(15)	No	N/A	
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'ship_via', lsTemp)
				End If				
				
				//Freight Terms	C(20)	No	N/A	
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'freight_terms', lsTemp)
				End If			
				
				//Agent Info	C(30)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'agent_info', lsTemp)
				End If				
				
				
				//Ship To Name	C(50)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'cust_name', lsTemp)
				End If				
	
					
				
				//Ship Address 1	C(60)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col18"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'address_1', lsTemp)
				End If			
				
				//Ship Address 2	C(60)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col19"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'address_2', lsTemp)
				End If				
				
				//Ship Address 3	C(60)	No	N/A	
		
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col20"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'address_3', lsTemp)
				End If	
				
				//Ship Address 4	C6)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col21"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'address_4', lsTemp)
				End If				
				
				//Ship City	C(50)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col22"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'city', lsTemp)
				End If			
				
				//Ship State	C(50)	No	N/A
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col23"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'state', lsTemp)
				End If				
				
				//Ship Postal Code	C(50)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col24"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'zip', lsTemp)
				End If				
				
				//Ship Country	C(50)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col25"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'country', lsTemp)
				End If				
				
				//Ship Tel	C(20)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col26"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'tel', lsTemp)
				End If				
	
	
				//If we have Bill to information, we will need to build an Alt Address record
				lbBillToAddress = False		
					
				//Bill To Name	C(50)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col27"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					lbBillToAddress = True
					lsBillToName = Trim(lsTemp)
				ELSE
					lsBillToName = ''
				End If				
				
				//Bill Address 1	C(60)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col28"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					lbBillToAddress = True
					lsBillToADdr1 = Trim(lsTemp)
				ELSE
					lsBillToADdr1 = ''
				End If				
				
				//Bill Address 2	C(60)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col29"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					lbBillToAddress = True
					lsBillToADdr2 = Trim(lsTemp)
				ELSE
					lsBillToADdr2 = ''
				End If					
				
				//Bill Address 3	C(60)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col30"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					lbBillToAddress = True
					lsBillToADdr3 = Trim(lsTemp)
				ELSE
					lsBillToADdr3 = ''
				End If					
				
				//Bill Address 4	C(60)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col31"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					lbBillToAddress = True
					lsBillToADdr4 = Trim(lsTemp)
				ELSE
					lsBillToADdr4 = ''
				End If				
				
				
				//Bill City	C(50)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col32"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					lbBillToAddress = True
					lsBillToCity = Trim(lsTemp)
				ELSE
					lsBillToCity = ''
				End If	
				
				//Bill State	C(50)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col33"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					lbBillToAddress = True
					lsBillToState = Trim(lsTemp)
				ELSE
					lsBillToState = ''
				End If			
				
				//Bill Postal Code	C(50)	No	N/A
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col34"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					lbBillToAddress = True
					lsBillToZip = Trim(lsTemp)
				ELSE
					lsBillToZip = ''
				End If				
				
				//Bill Country	C(50)	No	N/A
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col35"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					lbBillToAddress = True
					lsBillToCountry = Trim(lsTemp)
				ELSE
					lsBillToCountry = ''
				End If			
				
				//Bill Tel	C(20)	No	N/A	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col36"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					lbBillToAddress = True
					lsBillToTel = Trim(lsTemp)
				ELSE
					lsBillToTel = ''
				End If				
				
				//Remarks	C(255)	No	N/A	
			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col37"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'remark', lsTemp)
				End If		
				
				//Shipping Instructions	C(255)	No	N/A	
			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col38"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'shipping_instructions_Text', lsTemp)
				End If			
				
				//Packlist Notes	C(255)	No	N/A
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col39"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					If lsProject = 'NYX' Then				//NYX will use the packlist notes with an address that needs to display as an address
						lsTemp = f_replace_pipe(lsTemp)
					End If
					
					ldsSOheader.SetItem(liNewRow,'packlist_notes_Text', lsTemp)
				End If			
				
							
				//User Field2	C(10)	No	N/A	User Field
				//User Field3	C(10)	No	N/A	User Field
				//User Field4	C(20)	No	N/A	User Field
				//User Field5	C(20)	No	N/A	User Field
				//User Field6	C(20)	No	N/A	User Field
				//User Field7	C(30)	No	N/A	User Field
				//User Field8	C(60)	No	N/A	User Field
				//User Field9	C(30)	No	N/A	User Field
				//User Field10	C(30)	No	N/A	User Field
				//User Field11	C(30)	No	N/A	User Field
				//User Field12	C(50)	No	N/A	User Field
				//User Field13	C(50)	No	N/A	User Field
				//User Field14	C(50)	No	N/A	User Field
				//User Field15	C(50)	No	N/A	User Field
				//User Field16	C(100)	No	N/A	User Field
				//User Field17	C(100)	No	N/A	User Field
				//User Field18	C(100)	No	N/A	User Field
				
				uf_process_userfields(40, 2, 18, ldsImport, llFileRowPos, ldsSOheader, liNewRow)	
	
				//Ship To Contact	C(30)	No	N/A
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col57"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'contact_person', lsTemp)
				End If			
				
				//Ship To Email		C(50)	No	N/A
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col58"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'email_address', lsTemp)
				End If			
				
	
				//User_Field	19
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col59"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'user_field19', lsTemp)
				End If			
				
				
				//User_Field	20
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col60"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'user_field20', lsTemp)
				End If						
				
				//User_Field	21
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col61"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'user_field21', lsTemp)
				End If	
				
				//25-Sep-2014 :Madhu- KLN B2B Conversion to SPS -START
				//IF File comes from 'SPS' folder, set DM.UF21 =SPS else DM.UF21 =B2B
				llPos =Pos(aspath,"\SPS\")
				If Upper(asproject) ='KLONELAB' Then
					IF llPos > 0  Then
						ldsSOheader.SetItem(liNewRow,'user_field21','SPS')
					ELSE
						ldsSOheader.SetItem(liNewRow,'user_field21','B2B')
					END IF
				END IF
				//25-Sep-2014 :Madhu- KLN B2B Conversion to SPS -END
	
				//User_Field	22
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col62"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'user_field22', lsTemp)
				End If			
				
				
				// 02/13 - PCONKL - Added SHip Ref
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col63"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'ship_ref', lsTemp)
				End If			
				
				//2015/05/01 - TAM - Added Department Code
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col64"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'department_Code', lsTemp)
				End If			
				
	
				//2015/05/01 - TAM - Added Division
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col65"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'division', lsTemp)
				End If			
				
				//2015/05/01 - TAM - Added Vendor
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col66"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'vendor', lsTemp)
				End If			
	
				//2015/05/01 - TAM - Added Request Date
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col67"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'request_date', lsTemp)
				End If			
	
				//2015/05/01 - TAM - Added Department Name
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col68"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'department_Name', lsTemp)
				End If			
				//2015/05/20 - GWM - Added 18 Master named fields
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col69"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Account_Nbr', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col70"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'ASN_Number', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col71"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Client_Cust_PO_Nbr', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col72"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Client_Cust_SO_Nbr', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col73"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Container_Nbr', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col74"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Dock_Code', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col75"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Document_Codes', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col76"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Equipment_Nbr', Long(lsTemp))
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col77"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'FOB', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col78"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'FOB_Bill_Duty_Acct', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col79"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'FOB_Bill_Duty_Party', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col80"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'FOB_Bill_Freight_Party', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col81"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'FOB_Bill_Freight_To_Acct', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col82"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'From_Wh_Loc', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col83"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Routing_Nbr', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col84"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Seal_Nbr', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col85"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Shipping_Route', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col86"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'SLI_Nbr', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col87"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Trax_Acct_No', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col88"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Trax_Duty_Terms', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col89"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Trax_Duty_Acct_No', lsTemp)
				End If			
	
	//TAM 2015/09/16			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col90"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Currency_Code', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col91"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Order_Tax_Amt', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col92"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Order_Discount_Amt', lsTemp)
				End If			
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col93"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Shipping_Handling_Amt', lsTemp)
				End If			
	
				//03/16 - PCONKL - Adding Shipment ID (Consolidation_No)
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col94"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSOheader.SetItem(liNewRow,'Consolidation_No', lsTemp)
				End If			
				
				//If we have Bill To Information, create the Alt Address record
				If lbBillToAddress Then
					
					llNewAddressRow = ldsDOAddress.InsertRow(0)
					ldsDOAddress.SetITem(llNewAddressRow,'project_id', lsProject) /*Project ID*/
					ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
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
				
				//28-March-2017 :Madhu - SIMSPEVS-535 - Add Return Address for GEI -START
				//20-AUG-2018 :Madhu S22535 - Don't add RT address for GEI
				/*If upper(asproject) ='GEISTLICH' Then
					llNewAddressRow = ldsDOAddress.InsertRow(0)
					ldsDOAddress.setItem( llNewAddressRow, 'project_id', lsProject) 
					ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq)
					ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
					ldsDOAddress.SetItem(llNewAddressRow,'address_type','RT') /* Return To Address */
					ldsDOAddress.SetItem(llNewAddressRow,'Name','GEISTLICH C/O XPO LOGISTICS')
					ldsDOAddress.SetItem(llNewAddressRow,'address_1','1 INDUSTRIAL RD SUITE 20')
					ldsDOAddress.SetItem(llNewAddressRow,'City','DAYTON')
					ldsDOAddress.SetItem(llNewAddressRow,'State','NJ')
					ldsDOAddress.SetItem(llNewAddressRow,'Zip','08810')
					ldsDOAddress.SetItem(llNewAddressRow,'Country','US')
					ldsDOAddress.SetItem(llNewAddressRow,'tel','732-438-2142')
					ldsDOAddress.SetItem(llNewAddressRow,'email_address','geistlich.xpo.return@gmail.com')				
				End If*/
				//28-March-2017 :Madhu - SIMSPEVS-535 - Add Return Address for GEI -END
									
			// DETAIL RECORD
	
			Case 'DD' /*Detail */
	
			//Delivery Order Detail
	
	
				//Change ID	C(1)	Yes	N/A	
					//A $$HEX2$$13202000$$ENDHEX$$Add
					//U $$HEX2$$13202000$$ENDHEX$$Update
					//D $$HEX2$$13202000$$ENDHEX$$Delete
	
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
				ElseIf lsTemp <> lsheaderProject Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Delivery Detail (DD) Project ID does not match header (DM) Project ID. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsProject = lsTemp
				End If									
	
				//Delivery Number	C(20)	Yes	N/A	Delivery Order Number (must match header)
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					
			
					//Make sure we have a header for this Detail...
					If ldsSOHeader.Find("Upper(invoice_no) = '" + Upper(lstemp) + "'",1, ldsSOHeader.RowCount()) = 0 Then
						gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
						lbDetailError = True
					End If
						
					lsOrderNumber = lsTemp
				End If			
	
				
				//Supplier Code	C(20)	Yes	N/A	
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsSupplier = lsTemp
				End If			
	
			
				//Line Number	N(6,0)	Yes	N/A	Delivery line item number
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					llLineItemNo = Long(lsTemp)
				End If					
				
				//SKU	C(50)	Yes	N/A	Material number
	
		
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsSku = lsTemp
				End If				
				
				//Quantity	N(15,5)	Yes	N/A	Requested delivery quantity
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					ldQuantity = Dec(lsTemp)
				End If			
	
				//Inventory Type	C(1)	Yes	N/A	Inventory Type		
		
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Inventory Type is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					ls_InventoryType = lsTemp
				End If		
		
				/* End Required */
			
			
				lbDetailError = False
				llNewDetailRow = 	ldsSODetail.InsertRow(0)
				llLineSeq ++
						
				//Add detail level defaults
				ldsSODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
				ldsSODetail.SetItem(llNewDetailRow,'project_id', lsProject) /*project*/
				ldsSODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
				ldsSODetail.SetItem(llNewDetailRow,'Inventory_Type', ls_InventoryType) 
				ldsSODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsSODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
				
				ldsSODetail.SetItem(llNewDetailRow,'invoice_no',lsOrderNumber)			
	//			ldsSODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	
	
				ldsSODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
				ldsSODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
				ldsSODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
				ldsSODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
	
				IF Upper(asproject) = 'PHYSIO-MAA' OR Upper(asproject) = 'PHYSIO-XD' THEN
					ldsSODetail.SetItem(llNewDetailRow,'User_Line_Item_No', string(llLineItemNo))
					ldsSODetail.SetItem(llNewDetailRow,'Line_Item_No', llLineSeq)		
				END IF			
				
				
	
				//Customer  Line Item Number	C(20)	No	N/A	Customer Line Item Number
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
				
				IF Upper(asproject) = 'PHYSIO-MAA' OR Upper(asproject) = 'PHYSIO-XD' THEN
					lsTemp = ''	
				END IF			
				
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow, 'User_Line_Item_No', lsTemp)  
				End If		
	
				//Alternate SKU	C(50)	No	N/A	Alternate SKU
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'alternate_sku', lsTemp)
				End If				
				
				
				//Customer SKU	C(35)	No	N/A	Customer/Alternate SKU
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'customer_sku', lsTemp)
				End If				
				
				//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'lot_no', lsTemp)
				End If				
				
				
				//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'po_no', lsTemp)
				End If			
				
				
				//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'po_no2', lsTemp)
				End If				
				
				//Serial Number	C(50)	No	N/A	Qty must be 1 if present
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'serial_no', lsTemp)
				End If				
				
				//Line Item Text	C(255)	No	N/A	Notes / remarks
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'line_item_notes', lsTemp)
				End If				
				
				
				//User Field1	C(20)	No	N/A	User Field
				//User Field2	C(20)	No	N/A	User Field
				//User Field3	C(30)	No	N/A	User Field
				//User Field4	C(30)	No	N/A	User Field
				//User Field5	C(30)	No	N/A	User Field
				//User Field6	C(30)	No	N/A	User Field
				//User Field7	C(30)	No	N/A	User Field
				//User Field8	C(30)	No	N/A	User Field, not viewable on screen
		
				uf_process_userfields(18, 8, ldsImport, llFileRowPos, ldsSODetail, llNewDetailRow)	
				
	//TAM - Temp for Karcher 2012/07/28  Need to map the customer line number to the user_field8 until the new field "User_Line_Item_No" is added to the process.  When the new field is added the column 10 above needs to be changed
				If asProject = 'KARCHER' then
					lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
					If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
							ldsSODetail.SetItem(llNewDetailRow,'user_field8',lsTemp) /*Temp Cust_Line_Item_No*/
					End If
				End If		
	
				
				//UnitOfMeasure	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col26"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'uom', lsTemp)
				End If		
				
				//Unit Price
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col27"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'price', lsTemp)
				End If					
	
					//Client Customer Line Number
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col28"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'client_cust_line_no', lsTemp)
				End If					
			  
					//VAT Identifier
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col29"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'vat_identifier', lsTemp)
				End If					
	
				//TAM 2015/05/ BuyerPart
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col30"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Buyer_Part', lsTemp)
				End If					
	
				//TAM 2015/05/ Vendor Part
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col31"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Vendor_Part', lsTemp)
				End If					
	
	//			//TAM 2015/05/ Col 32 Unused - GWM Moved UPC from 36 to 32 to sync with structure
				//TAM 2015/05/UPC
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col32"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'UPC', lsTemp)
				End If			
					
				//TAM 2015/05/ EIN
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col33"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'EAN', lsTemp)
				End If					
	
				//TAM 2015/05/GTIN
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col34"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'GTIN', lsTemp)
				End If					
	
				//TAM 2015/05/ Department Name
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col35"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Department_Name', lsTemp)
				End If					
	
	//			//TAM 2015/05/ Col 34 Unused
	
				//TAM 2015/05/ Division
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col36"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Division', lsTemp)
				End If	
				
				//GWM - 2015/05/20 - Add named fields
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col37"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'CI_Value', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col38"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Currency', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col39"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Cust_Line_Nbr', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col40"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Client_Cust_Invoice', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col41"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Cust_PO_Nbr', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col42"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Delivery_Nbr', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col43"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Internal_Price', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col44"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Client_Inv_Type', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col45"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Permit_Nbr', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col46"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Packaging_Characteristics', lsTemp)
				End If	
				
	//TAM 2015/09/16
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col47"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Line_Total_Amt', lsTemp)
				End If	
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col48"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Line_Tax_Amt', lsTemp)
				End If	
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col49"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Line_Discount_Amt', lsTemp)
				End If	
				
				// 01/17 - Pconkl - Added 'Mark for' fields
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col50"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Mark_For_Name', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col51"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Mark_For_Address_1', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col52"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Mark_For_Address_2', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col53"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Mark_For_Address_3', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col54"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Mark_For_Address_4', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col55"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Mark_For_City', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col56"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Mark_For_State', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col57"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Mark_For_Zip', lsTemp)
				End If	
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col58"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsSODetail.SetItem(llNewDetailRow,'Mark_For_Country', lsTemp)
				End If	
				
				
				//End of add named fields
				
			//BCR 12-DEC-2011: Need to introduce Delivery Note for Geistlich...
	
			//Delivery Note
		
			//NOTE RECORD
			Case 'DN' /* Note */ 
				
				//Change ID	C(1)	Yes	N/A	
					//A $$HEX2$$13202000$$ENDHEX$$Add........always an 'A'
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))
	
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					lsChangeID = 'A'	
				Else
					lsChangeID = lsTemp
				End If				
				
				//Project ID	C(10)	Yes	N/A	Project identifier
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))
	
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Project ID is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					//IF asProject = lsTemp THEN
					IF lsHeaderProject = lsTemp THEN
						lsProject = lsTemp
					ELSE
						gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Delivery Note Project ID does not match header Project ID. Record will not be processed.")
						lbError = True
						Continue		
					END IF
				End If		
				
				//Delivery Number	C(20)	Yes	N/A	Delivery Order Number (must match header)
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					
			
					//Make sure we have a header for this Detail...
					If ldsSOHeader.Find("Upper(invoice_no) = '" + Upper(lstemp) + "'",1, ldsSOHeader.RowCount()) = 0 Then
						gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
						lbDetailError = True
					End If
						
					lsOrderNumber = lsTemp
				End If		
				
				//Line Number	N(6,0)	Yes	N/A	Delivery line item number
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					llLineItemNo = Long(lsTemp)
				End If				
				
				//Note Type	C(2)	Yes	N/A	Delivery note type...$$HEX1$$1820$$ENDHEX$$WH$$HEX1$$1920$$ENDHEX$$, $$HEX1$$1820$$ENDHEX$$BL$$HEX1$$1920$$ENDHEX$$, $$HEX1$$1820$$ENDHEX$$PK$$HEX1$$1920$$ENDHEX$$, or $$HEX1$$1820$$ENDHEX$$LB$$HEX1$$1920$$ENDHEX$$
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Note Type is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					//GailM - 06/22/2015 - Add check for CD - CrossDock for NYX
					IF lsTemp = 'WH' OR lsTemp = 'BL' OR lsTemp = 'PK' OR lsTemp = 'LB'  OR lsTemp = 'MR'  OR lsTemp = 'CD' THEN
						lsNoteType = lsTemp
					ELSE 
						gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Note Type. Record will not be processed.")
						lbError = True
						Continue
					END IF
				End If		
				
				//Note Sequence	N(5,0)	Yes	N/A	Delivery note sequence
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Note Sequence is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					llNoteSequence = Long(lsTemp)
				End If			
				
				//Note Text	C(255)	Yes	N/A	Delivery note text.
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Note Text is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					lsNoteText = lsTemp
				End If					
				
				//InsertRow...
				llNewNotesRow = ldsDONotes.InsertRow(0)
				
				//SetItem...
				ldsDONotes.SetITem(llNewNotesRow,'project_id',lsProject) 
				ldsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq)
				ldsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 		
				ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',llNoteSequence) 
				ldsDONotes.SetItem(llNewNotesRow,'invoice_no',lsOrderNumber)
				ldsDONotes.SetItem(llNewNotesRow,'note_type',lsNoteType)
				ldsDONotes.SetItem(llNewNotesRow,'line_item_no',llLineItemNo)
				ldsDONotes.SetItem(llNewNotesRow,'note_Text',lsNoteText)
	
		End Choose /*Header, Detail or Notes */
			
	Next /*File record */

end if			/* DE3036 END OF IF/THEN/ESLE */

w_main.SetMicroHelp("Ready")

asGenericImport = ldsImport
asDeliveryMaster = ldsSOheader
asDeliveryDetail = ldsSOdetail
asDeliveryAddress = ldsDOAddress
asDeliveryNotes = ldsDONotes//BCR 12-DEC-2011: Need to introduce Delivery Note for Geistlich...

IF lbError then
	Return -1	
Else
	RETURN 1
End IF
end function

public function integer uf_process_customer (string aspath, string asproject);

//Process baseline Customer Master Transaction 

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
lsLogOut = '      - Opening  Customer Master File: ' + asPath + " for " + asProject
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Customer Master File for  Processing: " + asPath
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
	
//	//Convert To Unicode using COdepage 936 (Chinese)
//	liRC = MultiByteToWideChar(936, 0, lsData, -1, lblb_wide_chars, 0) 
//  	IF liRC > 0 THEN 
//		
//			// Reserve Unicode Chars 
//			lblb_wide_chars = blob( space( (liRC+1)*2 ) ) 
//	
//			// Convert codepage 936  to UTF-16 
//			liRC = MultiByteToWideChar(936, 0, lsData, -1, lblb_wide_chars, (liRC+1)*2 ) 
//		
//	
//  	END IF 
//
//	lsDAta = String(lblb_wide_chars)
		
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
	
	//UF1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'User_Field1',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//UF2
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

public function integer uf_process_supplier (string aspath, string asproject);
// 04/13 - PCONKL - Added to baseline

//Process Supplier Master Transaction

u_ds_datastore	ldsSupplier
DAtastore	lu_DS

String	lsData,			&
			lsTemp,			&
			lsLogOut, 		&
			lsStringData,	&
			lsSupplier
			
Integer	liRC,	&
			liFileNo
			
Long		llCount,				&
			llNew,				&
			llExist,				&
			llNewRow,			&
			llFileRowCount,	&
			llFileRowPos

Boolean	lbError

ldsSupplier = Create u_ds_datastore
ldsSupplier.dataobject= 'd_supplier_master'
ldsSupplier.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening Supplier Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Supplier Master File for Processing: " + asPath + ' for Project: ' + asProject
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
	
	w_main.SetMicroHelp("Processing Supplier Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))
		
	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsDAta,Len(lsData) - 1)
	End If
	
	//Validate Rec Type is SM
	lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	If lsTemp <> 'SM' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Validate Supplier and retrieve existing or Create new Row
	If Pos(lsData,'|') > 0 Then
	
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsSupplier = lsTemp
	
		//Retrieve the DS to pupulate existing SKU if it exists, other wise insert new
		llCount = ldsSupplier.Retrieve(asProject, lsSupplier)
		If llCount <= 0 Then
			
			llNew ++ /*add to new count*/
			ldsSupplier.InsertRow(0)
			ldsSupplier.SetItem(1,'project_id',asProject)
			ldsSupplier.SetItem(1,'supp_code',lsSupplier)
				
		Else /*Supplier Master exists */
		
			llExist += llCount /*add to existing Count*/
					
		End If
			
	Else /*error*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
		
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			
	/*** Fields after this point will not validate for another delimiter, since the rest of the fields are optional***/
	/*** If any more required fields are added later, we should check for a delimeter up to that point*/
		
	//Supplier Name 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsDAta
	End If

	ldsSupplier.SetItem(1,'supp_name',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'address_1',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 2
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'address_2',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 3
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'address_3',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 4
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'address_4',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	//City
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'City',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//State
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'State',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Zip
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'Zip',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Country
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'Country',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Contact
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'Contact_Person',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//telephone
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'tel',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Fax
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'fax',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
//	//Email
//	If Pos(lsData,'|') > 0 Then
//		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
//	Else /*error*/
//		lsTemp = lsData
//	End If
//	
//	ldsSupplier.SetItem(1,'email_Address',lsTemp)
//			
//	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
//	//Harmonized Code
//	If Pos(lsData,'|') > 0 Then
//		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
//	Else /*error*/
//		lsTemp = lsData
//	End If
//	
//	ldsSupplier.SetItem(1,'harmonized_code',lsTemp)
//			
//	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
//	
//	//VAT ID
//	If Pos(lsData,'|') > 0 Then
//		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
//	Else /*error*/
//		lsTemp = lsData
//	End If
//	
//	ldsSupplier.SetItem(1,'vat_id',lsTemp)
//			
//	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//User Field1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'User_Field1',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//User Field 2
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'User_Field2',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	
//	//*** If we still have data after the last field, something is wrong with the record
//	If lsData > ' ' Then
//		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data found after expected last column. Record will not be processed.")
//		lbError = True
//		Continue /*Process Next Record */
//	End If
	
	
	//Update any record defaults
	ldsSupplier.SetItem(1,'Last_user','SIMSFP')
	ldsSupplier.SetItem(1,'last_update',today())

	//Save Supplier to DB
	lirc = ldsSupplier.Update()
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save Supplier Master Record to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save Supplier Master Record to database!")
		//Return -1
		Continue
	End If

Next /*File row to Process */

w_main.SetMicroHelp("")

lsLogOut = Space(10) + String(llNew) + ' Supplier Records were successfully added and ' + String(llExist) + ' Records were updated.'
FileWrite(gilogFileNo,lsLogOut)

Destroy ldsSupplier

If lbError then
	Return -1
Else
	Return 0
End If
end function

public function integer uf_load_purchase_order (string aspath, ref string asproject, ref datastore asgenericimport, ref datastore adspoheader, ref datastore adspodetail);
//Load Purchase Order (PM) Transaction for Baseline Unicode Client

STRING lsTemp, lsProject, lsSku, lsSupplier, lsWarehouse, lsOrderNumber, lsOrderType
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo,llPos
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow
STRING lsLogOut, lsChangeID
INTEGER li_StartCol
INTEGER li_UFIdx
DECIMAL ldQuantity
STRING lsNull
STRING lsDefaultSupp_Code
INTEGER liSuppCount
BOOLEAN lbAttemptLoadDefaultSupp_Code = False

SetNull(lsNull)

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

//GailM 2/7/2018 - Defect DE3036 - SIMS Sweeper - files in error not being processed correctly - Wrap in if/then/else
if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Purchase Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	lbError = True
else

	integer llFileRowPos
	integer llFilerowCount
	
	llFilerowCount = ldsImport.RowCount()
	
	//Get the next available file sequence number
	llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
	If llBatchSeq <= 0 Then Return -1
	
	//Loop through
	
	for llFileRowPos = 1 to llFilerowCount
	
		w_main.SetMicroHelp("Processing Purchase Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))
	
	
		//Field Name	Type	Req.	Default	Description
		//Record_ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$PM$$HEX2$$1d200900$$ENDHEX$$Purchase order master identifier
		//Record ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$PD$$HEX2$$1d200900$$ENDHEX$$Purchase order detail identifier
	
		//Validate Rec Type is PM OR PD
		lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
		If NOT (lsTemp = 'PM' OR lsTemp = 'PD') Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			//Continue /*Process Next Record */
		End If
	
		Choose Case Upper(lsTemp)
		
			//Purchase Order Master
		
			Case 'PM' /*PO Header*/
	
				//Change ID	C(1)	Yes	N/A	
					//A $$HEX2$$13202000$$ENDHEX$$Add
					//U $$HEX2$$13202000$$ENDHEX$$Update
					//D $$HEX2$$13202000$$ENDHEX$$Delete
					//X $$HEX2$$13202000$$ENDHEX$$Ignore (Add or update regardless)
					
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
					
					
				//Order Type	C(1)	Yes	$$HEX1$$1c20$$ENDHEX$$S$$HEX2$$1d200900$$ENDHEX$$Must be valid order typr
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					lsTemp = "S"	
				Else
					lsOrderType = lsTemp
				End If					
					
					
				//Supplier Code	C(20)	Yes	N/A	Valid Supplier code
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					
					//Added so if Supplier Code is not set, then if there is only one supplier, it will use that one.
					
		
		
					IF NOT lbAttemptLoadDefaultSupp_Code THEN
						
						SELECT TOP 1 Count(Supp_Code), Supp_Code  INTO :liSuppCount, :lsDefaultSupp_Code From Supplier With (NoLock) WHERE project_id =  :asproject GROUP BY Supp_Code;  
							
						IF liSuppCount > 1 then
							
						ELSE
							
							lsTemp = lsDefaultSupp_Code
							
						END IF
			
						lbAttemptLoadDefaultSupp_Code = True
						
					END IF
			
					If IsNull(lsTemp) OR trim(lsTemp) = '' Then	
						gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
						lbError = True
						Continue		
					Else
						lsSupplier = lsTemp
					End If			
				Else
					lsSupplier = lsTemp
				End If			
	
				/* End Required */		
				
				liNewRow = 	ldsPOheader.InsertRow(0)
				llOrderSeq ++
				llLineSeq = 0
				
				//New Record Defaults
				asProject = lsProject
				
				
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
				
				//AWB #	C(20)	No	N?A	Airway Bill/Tracking Number
				
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
	
				uf_process_userfields(15, 15, ldsImport, llFileRowPos, ldsPOheader, liNewRow)	
	
				//26-Sep-2014 : Madhu- KLN B2B Conversion to SPS- Set RM.UF13=B2B or SPS -START
				llPos =Pos(aspath,"\SPS\")
				IF Upper(asproject) ='KLONELAB'  Then
					IF llPos > 0 Then
						ldsPOheader.SetITem(liNewRow,'user_field13','SPS')
					ELSE
						ldsPOheader.SetItem(liNewRow,'user_field13','B2B')
					END IF
				END IF
				//26-Sep-2014 : Madhu- KLN B2B Conversion to SPS- Set RM.UF10=B2B or SPS -END
	
				//MEA - 4/12 - Added the Rcv Slip Nbr
	
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col30"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPOheader.SetItem(liNewRow,'ship_ref', lsTemp)
				End If	
	
				// 03/16 - PCONKL - Added new named fields 31 - 38
				
				//Client Cust PO Nbr
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col31"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPOheader.SetItem(liNewRow,'Client_Cust_PO_Nbr', lsTemp)
				End If	
				
				//Client Invoice Nbr
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col32"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPOheader.SetItem(liNewRow,'Client_Invoice_Nbr', lsTemp)
				End If	
				
				//Container Nbr
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col33"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPOheader.SetItem(liNewRow,'Container_Nbr', lsTemp)
				End If	
				
				//Client Order Type
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col34"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPOheader.SetItem(liNewRow,'Client_Order_Type', lsTemp)
				End If	
				
				//Container Type
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col35"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPOheader.SetItem(liNewRow,'Container_Type', lsTemp)
				End If	
				
				//From WH Loc
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col36"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPOheader.SetItem(liNewRow,'From_WH_Loc', lsTemp)
				End If	
				
				//Seal Nbr
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col37"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPOheader.SetItem(liNewRow,'Seal_Nbr', lsTemp)
				End If	
				
				//Vendor Invoice Nbr
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col38"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPOheader.SetItem(liNewRow,'Vendor_Invoice_Nbr', lsTemp)
				End If	
				
	
				//Note: 
				//
				//1.	A PO can only be deleted if no receipts have been generated against the PO.
				//2.	Deletion of a Purchase Order Master will also delete related purchase order details.
				//3.	Updated PO$$HEX1$$1920$$ENDHEX$$s should include all of the information for the PO regardless of whether or not a specific item has been changed.
							
	
	
			//Purchase Order Detail				
					
			CASE 'PD' /* detail*/
	
				//Change ID	C(1)	Yes	N/A	
					//A $$HEX2$$13202000$$ENDHEX$$Add
					//U $$HEX2$$13202000$$ENDHEX$$Update
					//D $$HEX2$$13202000$$ENDHEX$$Delete
	
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
				
				
				IF Upper(asproject) = 'PHYSIO-MAA' OR Upper(asproject) = 'PHYSIO-XD' THEN
					ldsPODetail.SetItem(llNewDetailRow,'User_Line_Item_No', string(llLineItemNo))
					ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No', llLineSeq)		
				END IF
				
				
				//Inventory Type	C(1)	No	N/A	Inventory Type
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', lsTemp)
				End If	
				
				//Alternate SKU	C(50)	No	N/A	Supplier$$HEX1$$1920$$ENDHEX$$s material number
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku', lsTemp)
				Else
					ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku', lsNull)
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
				
				IF Upper(asproject) = 'PHYSIO-MAA' OR Upper(asproject) = 'PHYSIO-XD' THEN
					lsTemp = ''	
				END IF	
				
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
	// TAM 2012/07 Remove line item number from populating from field 16.  It is populated by field 6 above
	//				ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No', long(lsTemp))
					ldsPODetail.SetItem(llNewDetailRow,'User_Line_Item_No', lsTemp)// TAM 7/11/2012 Populate the user_line_item_no from field 16
				End If			
				
	
	
				
	
			
				//User Field1	C(50)	No	N/A	User Field
				//User Field2	C(50)	No	N/A	User Field
				//User Field3	C(50)	No	N/A	User Field
				//User Field4	C(50)	No	N/A	User Field
				//User Field5	C(50)	No	N/A	User Field
				//User Field6	C(50)	No	N/A	User Field
				
				uf_process_userfields(17, 6, ldsImport, llFileRowPos, ldsPODetail, llNewDetailRow)	
	
					
				//Country Of Origin
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col23"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPODetail.SetItem(llNewDetailRow,'Country_of_Origin', lsTemp)
				End If			
								
				//UnitOfMeasure
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col24"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPODetail.SetItem(llNewDetailRow,'uom', lsTemp)
				End If		
				
				//03/16 - PCONKL - Added new named fields 25 - 34
				
				//Currency Code
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col25"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPODetail.SetItem(llNewDetailRow,'Currency_Code', lsTemp)
				End If		
				
				//Supplier Order Nbr
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col26"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPODetail.SetItem(llNewDetailRow,'Supplier_Order_Number', lsTemp)
				End If		
				
				//Cust PO Nbr
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col27"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPODetail.SetItem(llNewDetailRow,'Cust_PO_Nbr', lsTemp)
				End If		
					
				//Line Container Nbr
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col28"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPODetail.SetItem(llNewDetailRow,'Line_Container_Nbr', lsTemp)
				End If		
				
				//Vendor Line Nbr
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col29"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPODetail.SetItem(llNewDetailRow,'Vendor_Line_Nbr', lsTemp)
				End If		
				
				//Client Line Nbr
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col30"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPODetail.SetItem(llNewDetailRow,'Client_Line_Nbr', lsTemp)
				End If		
				
				//Client Cust PO Nbr
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col31"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPODetail.SetItem(llNewDetailRow,'Client_Cust_PO_Nbr', lsTemp)
				End If		
				
				//Owner Code - Not mapping for now (32)
				
				//SSCC Number
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col33"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPODetail.SetItem(llNewDetailRow,'SSCC_Nbr', lsTemp)
				End If		
				
				//Vintage (34) - Not mapping now - Not in Receive_DEtail Table
				
				
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

end if			/* DE3036 END OF IF/THEN/ESLE */
	
asGenericImport = ldsImport
adsPOheader = ldsPOheader
adsPOdetail = ldsPOdetail

IF lbError then
	Return -1	
Else
	RETURN 1
End IF
end function

public function integer uf_process_purchase_order (string aspath, ref string asproject);
//Process Purchase Order (PM) Transaction for Baseline Unicode Client
//Process Receive Order


u_ds_datastore 	ldsPOheader,	ldsPOdetail
u_ds_datastore 	ldsImport

integer lirc
boolean lberror
string lslogout

//Call the generic load

lirc = uf_load_purchase_order(aspath, asproject, ldsImport, ldsPOheader, ldsPOdetail)	
	
IF lirc = -1 then lbError = true else lbError = false	
	
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

public function integer uf_process_itemmaster (string aspath, readonly string asproject);
//Process Item Master (IM) Transaction for Baseline Unicode Client

STRING lsTemp, lsProject, lsSku, lsSupplier
BOOLEAN lbError, lbNew
LONG llCount, llNew, llNewRow, llOwner, llexist, llPos
INTEGER lirc, liRtnImp
STRING lsLogOut
u_ds_datastore	ldsImport

//Item Master

// TAM 2013/11/26 - Added OTM Call to baseline if Flags Turned ON
String ls_action, ls_ind
Boolean lb_otm_item_turned_on
n_otm ln_otm
ln_otm = CREATE n_otm
u_ds_datastore	ldsItemOrig	// used to compare original DB OTM values for item updates

ldsItemOrig = Create u_ds_datastore
ldsItemOrig.dataobject= 'd_baseline_unicode_item_master'

//TimA 01/25/12 OTM Project Added OTM Flag
If gs_OTM_Flag = 'Y' then 
	select OTM_Item_Master_Send_Ind
	into	:ls_ind
	from project
	where project_id = :asproject;
End if

lb_otm_item_turned_on = Upper(Trim(ls_ind)) = 'Y'
// end OTM additions


u_ds_datastore	ldsItem, ldsItem2

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_baseline_unicode_item_master'
ldsItem.SetTransObject(SQLCA)

ldsItem2 = Create u_ds_datastore
ldsItem2.dataobject= 'd_baseline_unicode_item_master'
ldsItem2.SetTransObject(SQLCA)

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
integer llFilerowCount, llFileCountTemp
string lsSize

llFilerowCount = ldsImport.RowCount()

//02/13 - PCONKL - FOr Physio, we want to update multiple projects, we will just duplicate the original rows and change the project for the second project
If llFilerowCount > 0 Then
	
	If  Upper(Trim(ldsImport.GetItemString(1, "col2"))) = 'PHYSIO-MAA' Then
		
		llFileCountTemp = llFileRowCount + 1
		ldsImport.RowsCopy(1,llFileRowCount,Primary!,ldsImport,llFileCountTemp,Primary!)
		llFilerowCount = ldsImport.RowCount()
		
		For llFileRowPos = llFileCountTemp to llFilerowCount
			ldsImport.SetItem(llFileRowPos,'col2','PHYSIO-XD')
		Next
		
	End If
	
End If

//Loop through

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCount))

	//Field Name	Type	Req.	Default	Description
	//Record ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$IM$$HEX2$$1d200900$$ENDHEX$$Item Master Identifier

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


	//Supplier Code	C(20)	Yes	N/A	Valid Supplier code

	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
	
	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier Code is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		lsSupplier = lsTemp
	End If	

	
	////Retrieve for SKU - We will be updating across Suppliers

	llCount = ldsItem.Retrieve(lsProject, lsSKU, lsSupplier)

	ldsItem.RowsCopy(1, ldsItem.RowCount(), Primary!, ldsItemOrig, 1, Primary!)		// TAM 20131126	OTM addition

	If llCount <= 0 Then

		llNew ++ /*add to new count*/
		lbNew = True
		llNewRow = ldsItem.InsertRow(0)

		ldsItem.SetItem(1,'SKU',lsSKU)
		ldsItem.SetItem(1,'project_id', lsProject)		

//TAM 2013/11/01  Added default for Component Indicator

			ldsItem.SetItem(1,'Component_Ind', 'N')            
		
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

	//UOM1	C(4)	No	$$HEX1$$1c20$$ENDHEX$$EA$$HEX2$$1d200900$$ENDHEX$$Base unit of measure

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

//		//Open and read the File In
//		lsLogOut = 'UPC Code: ' + lsTemp
//		FileWrite(giLogFileNo,lsLogOut)
//		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
//		
		
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
		//B	 = capture serial # at receipt and when shipped but don$$HEX1$$1920$$ENDHEX$$t track in inventory
		//O = capture serial # only when shipped
		//Y	 = capture serial # at receipt, track in inventory and when shipped
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col42"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Serialized_Ind', lsTemp)
	End If			

	//Expiration Date Controlled	C(1)	No	N/A	Expiration Date Controlled indicator
	
	//Can you please add logic to the baseline Item Master process that if a $$HEX1$$1820$$ENDHEX$$D$$HEX2$$19202000$$ENDHEX$$is passed for the expiration_controlled_ind that we set it to a $$HEX1$$1820$$ENDHEX$$Y$$HEX1$$1920$$ENDHEX$$
	//and also set the expiration_Tracking_Type field to $$HEX1$$1820$$ENDHEX$$D$$HEX1$$1920$$ENDHEX$$.


	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col43"))
//31-Jul-2013 :Madhu - Re-write the condition to set Exp_Control_Ind value -START		
//	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//		
//		if trim(lsTemp) = "D" then 
//			lsTemp = "Y"
//			ldsItem.SetItem(1,'Expiration_Tracking_Type', "D")
//		end if
//		ldsItem.SetItem(1,'expiration_controlled_ind', lsTemp)
//	End If

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') and trim(lsTemp) ="D" THEN
		ldsItem.SetItem(1,'Expiration_Tracking_Type', "D")
		ldsItem.SetItem(1,'expiration_controlled_ind', "Y")
	ELSE
		ldsItem.SetItem(1,'expiration_controlled_ind', "N")
	END IF
//31-Jul-2013 :Madhu - Re-write the condition to set Exp_Control_Ind value -END		
	//Container Tracking Indicator	C(1)	No	N/A	Container Tracking Indicator

	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col44"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'container_tracking_ind', lsTemp)
	End If	
	
	//Delete Flag	C(1)	No	$$HEX1$$1c20$$ENDHEX$$N$$HEX2$$1d200900$$ENDHEX$$Flag for record deletion
	
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
	
	// 02/13 - PCONKL - added new fields 
	
	// QA Check Ind
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col68"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'QA_Check_Ind', lsTemp)
	End If			
	
	//Hazard TExt
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col69"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'hazard_text_cd', lsTemp)
	End If			
	
	
	//Hazard Code
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col70"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'hazard_cd', lsTemp)
	End If			
	
	
	//Hazard Class
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col71"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'hazard_class', lsTemp)
	End If			
	
	
	//CC Group
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col72"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'cc_group_Code', lsTemp)
	End If			
	
	//CC Class
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col73"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'cc_class_Code', lsTemp)
	End If			
	
	//Standard of Measure
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col74"))

	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') or lstemp = 'M' or lstemp = 'E'Then
		ldsItem.SetItem(1,'standard_of_measure', lsTemp)
	End If			
	
	
	
	ldsItem.SetItem(1,'Last_user','SIMSFP')
	ldsItem.SetItem(1,'last_update',today())	
	
	
	//Default Values for Physio-XD
	
	if lsProject = 'PHYSIO-XD' then
		
//		MEA - 3/13 - Default values

//		Field	Value source	Value destination
//		Serial tracked	Any value	N
//		Lot tracked	Any value	N
//		Expiry date tracked	Any value	N
//		QA check	Any value	N
//
		
		ldsItem.SetItem(1,'Serialized_Ind', 'N')
		ldsItem.SetItem(1,'Lot_Controlled_Ind', 'N')	
		ldsItem.SetItem(1,'expiration_controlled_ind', 'N')	
		ldsItem.SetItem(1,'QA_Check_Ind', 'N')	
	
	end if

//nxjain Starbucks 2013-03-06 put the defalut value code 

	if lsProject = 'STBTH' then
		
			ldsItem.SetItem(1,'Serialized_Ind', 'N')
			ldsItem.SetItem(1,'Lot_Controlled_Ind', 'N')       
			//ldsItem.SetItem(1,'expiration_controlled_ind', 'N')     //31-Jul-2013 :Madhu commented        
			ldsItem.SetItem(1,'QA_Check_Ind', 'N')                
			ldsItem.SetItem(1,'PO_Controlled_Ind', 'N')      
			ldsItem.SetItem(1,'PO_No2_Controlled_Ind', 'N')           
			ldsItem.SetItem(1,'Component_Ind', 'N')            
			ldsItem.SetItem(1,'Item_Delete_Ind', 'N')          
			ldsItem.SetItem(1,'Container_Tracking_Ind', 'N')             
			ldsItem.SetItem(1,'Interface_Upd_Req_Ind', 'N')           
	end if 

//end nxjain 
		
//Note: 
//
//1.	If delete flag is set for $$HEX1$$1c20$$ENDHEX$$Y$$HEX1$$1d20$$ENDHEX$$, the item will not be available for further transactions.
//2.	If delete flag is set for $$HEX1$$1c20$$ENDHEX$$Y$$HEX2$$1d202000$$ENDHEX$$and no warehouse transaction exist, the record will be physically deleted from database.


	
	//Save New Item to DB
	SQLCA.DBParm = "disablebind =0"
	lirc = ldsItem.Update()
	SQLCA.DBParm = "disablebind =1"
	
	If liRC = 1 then
		Commit;

// TAM 2013/11/26 - Added OTM Call to baseline if Flags Turned ON
		If gs_OTM_Flag = 'Y' then 
			// LTK 20120111	OTM Additions			
			if lb_otm_item_turned_on then
			
				// Send each item to OTM if any of the OTM fields have been modified
				For llPos = 1 to ldsItem.RowCount()

					if Upper(Trim(ldsItem.Object.item_delete_ind[llPos])) = 'Y' then
						// Delete
						ls_action = 'D'
					elseif lbNew then
						// Insert
						ls_action = 'I'
					else
						// Update
						ls_action = 'U'
					end if

					// OTM Changes - determine if any data has been modified in the set of OTM fields
					if uf_otm_fields_modified(ls_action,ldsItem,ldsItemOrig,llPos) then
						//	Send to OTM
						String ls_return_cd, ls_error_message
						ln_otm.uf_push_otm_item_master(ls_action, ldsItem.Object.project_id[llPos], ldsItem.Object.sku[llPos], ldsItem.Object.Supp_Code[llPos], ls_return_cd, ls_error_message)
	
//						if ls_return_cd <> "0" then
//							lsLogOut = "-       Error sending item [project_id=" + ldsItem.Object.project_id[llPos] + "   sku=" + ldsItem.Object.sku[llPos] + "   supp_code=" + ldsItem.Object.Supp_Code[llPos] + "] to OTM.  Error message:  " + ls_error_message
//							FileWrite(giLogFileNo,lsLogOut)
//							gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
//						end if
					end if
				Next
			end if
			// OTM end changes
		End If

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

on u_nvo_proc_baseline_unicode.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_baseline_unicode.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

