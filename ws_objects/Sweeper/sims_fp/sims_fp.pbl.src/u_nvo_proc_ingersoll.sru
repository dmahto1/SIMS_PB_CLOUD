$PBExportHeader$u_nvo_proc_ingersoll.sru
$PBExportComments$Process Ingersoll Rand Files
forward
global type u_nvo_proc_ingersoll from nonvisualobject
end type
end forward

global type u_nvo_proc_ingersoll from nonvisualobject
end type
global u_nvo_proc_ingersoll u_nvo_proc_ingersoll

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
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_so (string aspath, string asproject)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut,	&
			lsSaveFileName
Integer	liRC

Boolean	bRet

Choose Case Upper(Left(asFile,4))
		
	Case 'IRPO' /*Processed PO File from GLS */
		
		liRC = uf_process_so(asPath, asProject)
		
		//Process any added SO's
		lirc = gu_nvo_process_files.uf_process_Delivery_order(asProject) 
		
	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose


Return liRC
end function

public function integer uf_process_so (string aspath, string asproject);Datastore	ldsDOHeader,	&
				ldsDODetail,	&
				lu_ds

String	lsLogout,				&
			lsStringData,			&
			lsOrder,					&
			lsWarehouse

Integer	liFileNo,	&
			liRC

Long	llNewRow,			&
		llRowCount,			&
		llRowPos,			&
		llOrderSeq,			&
		llDetailSeq,		&
		llCount,				&
		llOwner
		
Decimal	ldEDIBAtchSeq,	&
			ldPOQTY
			
Boolean	lbError

DateTime	ldtToday

ldtToday = DateTime(Today(),Now())

ldsDOheader = Create u_ds_datastore
ldsDOheader.dataobject= 'd_shp_header'
ldsDOheader.SetTransObject(SQLCA)

ldsDOdetail = Create u_ds_datastore
ldsDOdetail.dataobject= 'd_shp_detail'
ldsDOdetail.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for IR Processing: " + asPath
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

//All outbound Orders will be fullfilled from SIRC owned inventory - default details
Select Min(Owner_ID) into :llOwner
From Owner
Where Project_id = :asProject and owner_cd = "SIRC";
		
//Process each row of the File
llRowCount = lu_ds.RowCount()
For llRowPos = 1 to llRowCount
	
	//Check for Valid length of file, we should at least have everything up to change flag (669)
	If Len(lu_ds.GetItemString(llRowPos,'rec_data')) < 669 Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Record length too short. Record will not be processed.")
		lbError = True
		Continue /*Next record */
	End If
	
	//Header and detail info in the same records
	
	lsOrder = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),71,35)) /*Pos 71 - 105*/
	
	// See if we already have a header, if not, create one
	If ldsDOHeader.Find("Upper(Invoice_no) = '" + Upper(lsOrder) + "'",1,ldsDOHeader.RowCount()) <= 0 Then
		
		llNewRow = ldsDOHeader.InsertRow(0)
		
		llOrderSeq ++
		llDetailSeq = 0 /*detail seq within order for detail recs */
					
		//Get the next available Seq #
		ldEDIBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
		If ldEDIBatchSeq < 0 Then
			Return -1
		End If
			
		//Record Defaults
		ldsDOHeader.SetITem(llNewRow,'project_id',asProject) /*Project ID*/
		ldsDOHeader.SetITem(llNewRow,'wh_code',lswarehouse) /*Default WH for Project */
		ldsDOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
		ldsDOHeader.SetItem(llNewRow,'order_Type','S') /*default to Sale*/
		ldsDOHeader.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
		ldsDOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
		ldsDOHeader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
		ldsDOHeader.SetItem(llNewRow,'Status_cd','N')
		ldsDOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')
		
		// Add or update - If we already have a DElivery Order, set to Update (Consolidated PO # is sent as an update)
		Select Count(*) into :llCount
		From DElivery_MAster
		Where Project_id = :asProject and Invoice_No = :lsOrder and ord_Status Not in('C','D','V');
		
		If llCount > 0 Then
			ldsDOHeader.SetItem(llNewRow,'ACtion_cd','U') /*Update*/
		Else
			ldsDOHeader.SetItem(llNewRow,'ACtion_cd','A')
		End If
			
	 // From File...
		
		//Order Number
		ldsDOHeader.SetITem(llNewRow,'invoice_no',lsOrder)
		
		//GLS TR ID - 
		ldsDOHeader.SetITem(llNewRow,'gls_tr_id',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),1,35)))
					
		//Transportation Mode
		ldsDOHeader.SetITem(llNewRow,'ship_via',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),351,35)))
		
		//Cust Code
		ldsDOHeader.SetITem(llNewRow,'cust_Code',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),715,35)))
		
		//Address 1 (Cust Name)
		ldsDOHeader.SetITem(llNewRow,'customer_name',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),750,35)))
		
		//Address 2
		ldsDOHeader.SetITem(llNewRow,'address_1',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),785,35)))
		
		//Address 3
		ldsDOHeader.SetITem(llNewRow,'address_2',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),820,35)))
		
		//Address 4
		ldsDOHeader.SetITem(llNewRow,'address_3',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),855,35)))
		
		//Address 5
		ldsDOHeader.SetITem(llNewRow,'address_4',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),890,35)))
		
	End If /* No header for this ORder*/

	
	//Insert Detail Row
	llNewRow = ldsDODetail.InsertRow(0)
	
	llDetailSeq ++
	
	//Add detail level defaults
	ldsDODetail.SetITem(llNewRow,'project_id', asproject) /*project*/
	ldsDODetail.SetITem(llNewRow,'status_cd', 'N') 
	ldsDODetail.SetITem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
	ldsDODetail.SetITem(llNewRow,'order_seq_no',llOrderSeq) 
	ldsDODetail.SetITem(llNewRow,"order_line_no",string(lldetailSeq)) /*next line seq within order*/
	ldsDODetail.SetITem(llNewRow,'Status_cd','N')
	ldsDODetail.SetItem(llNewRow,'owner_id',string(llOwner)) /*owner always set to SIRC */
	ldsDODetail.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
	
	//From File
	ldsDODetail.SetItem(llNewRow,'gls_so_id',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),36,35))) /*GLS SO ID  */
	ldsDODetail.SetItem(llNewRow,'gls_so_line',Long(Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),528,10)))) /*GLS SO Line */
	ldsDODetail.SetItem(llNewRow,'invoice_no',lsOrder) /*Order Number */
	ldsDODetail.SetITem(llNewRow,'sku',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),538,35)))
	ldsDODetail.SetITem(llNewRow,'line_item_no',Long(Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),386,10))))
	ldsDODetail.SetITem(llNewRow,'uom',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),465,3)))
	ldsDODetail.SetITem(llNewRow,'user_field1',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),680,35))) /*Consolidated PO # to User field 1*/
		
	//Validate QTY for Numerics
	If Not isnumber(Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),449,16))) Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - PO QTY is not numeric. Qty has been set to 0.")
		lbError = True
		ldPOQTY = 0
		//Continue /*Next record */
	Else
		ldPOQTY = Dec(Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),449,16)))
	End If
		
	ldsDODetail.SetITem(llNewRow,'quantity',String(ldPOQTY,'##########.#####'))
		
//	//Action Code - Unless it is Delete, set to update
//	If Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),679,1)) <> 'D' Then
//		ldsDODetail.SetItem(llNewRow,'action_cd','U')
//	Else
//		ldsDODetail.SetItem(llNewRow,'action_cd','D') 
//	End If
					
Next /*File Row */

//Save the Changes 
lirc = ldsDOHeader.Update()
	
If liRC = 1 Then
	liRC = ldsDODetail.Update()
End If
	
If liRC = 1 then
	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new DO Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new DO Records to database!")
	Return -1
End If

If lbError Then
	Return -1
Else
	Return 0
End If
end function

on u_nvo_proc_ingersoll.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_ingersoll.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

