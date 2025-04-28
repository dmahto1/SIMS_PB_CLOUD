HA$PBExportHeader$u_nvo_proc_bosch.sru
$PBExportComments$Process Bosch files
forward
global type u_nvo_proc_bosch from nonvisualobject
end type
end forward

global type u_nvo_proc_bosch from nonvisualobject
end type
global u_nvo_proc_bosch u_nvo_proc_bosch

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsASNHeader,	&
				idsASNPackage,	&
				idsASNItem
				
string lsDelimitChar // TAM 2015/03/23
				
// pvh - 03/16/06
datastore idswhXref  // used as cross reference between phxbrands 2 digit wh code and our alpha one.


end variables

forward prototypes
public function integer uf_process_dboh_old (string asinifile, string asemail)
public function integer uf_process_dboh (string asproject, string asinifile)
end prototypes

public function integer uf_process_dboh_old (string asinifile, string asemail);// uf_process_dboh(
//Process the BOSCH  Daily Balance on Hand Confirmation File

Datastore	ldsOut, ldsboh
				
Long			llRowPos, llRowCount, llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsWarehouse, lsFileName, lsFileNamePath

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

// pvh 03.16.06
constant string lsSpaces = Space(10)


ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_phxbrands_boh_by_sku' /* 02/07 - PCONKL - changed to include Inventory Type*/
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: BOSCH Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile,'BOSCH',"project","")

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')


If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for BOSCH BOH confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrive the BOH Data
lsLogout = 'Retrieving Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCOunt = ldsBOH.Retrieve(lsProject)

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by 'Tab'
lsLogOut = 'Processing Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCOunt
	
lsWarehouse = left( lsWarehouse + lsSpaces, 10 )	
		
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'BH' /*rec type = balance on Hand Confirmation*/
	lsOutString += ldsboh.GetItemString(llRowPos,'wh_code') + space(10 - Len(ldsboh.GetItemString(llRowPos,'wh_code')))
	lsOutString += ldsboh.GetItemString(llRowPos,'inventory_type')
	lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),26) + space(26 - Len(ldsboh.GetItemString(llRowPos,'sku')))
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'total_qty'),'0000000000000') 
		
	ldsOut.SetItem(llNewRow,'Project_id', "BOSCH")
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	lsFileName = 'BH' + String(ldBatchSeq,'000000000') + ".DAT"
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)
		
next /*next output record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,"BOSCH")

/*   Email the report*/
lsFileNamePath = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + lsFileName  
gu_nvo_process_files.uf_send_email("BOSCH",asEmail,"BOSCH Daily Balance On Hand Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the BALANCE ON HAND REPORT run on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)


Return 0
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
	
// TAM 2015/04/02  Combined available quantity and Allocated quantity
//Quantity	N(15,5)	Yes	N/A	Balance on hand
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'avail_qty')+ ldsboh.GetItemNumber(llRowPos,'alloc_qty')) + lsDelimitChar
	lsOutString += '0' + lsDelimitChar
//	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'avail_qty')) + lsDelimitChar

	//Quantity Allocated	N(15,5)	No	N/A	Allocated to Outbound Order
	
//	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'alloc_qty')) + lsDelimitChar
	
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

on u_nvo_proc_bosch.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_bosch.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
idswhXref = f_datastorefactory('d_phxbrands_whxref')
idswhXref.retrieve()

lsDelimitChar = char(9)
end event

event destructor;if isValid( idswhXref ) then destroy idswhXref

end event

