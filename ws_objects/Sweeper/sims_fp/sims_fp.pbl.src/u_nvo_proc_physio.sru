$PBExportHeader$u_nvo_proc_physio.sru
$PBExportComments$Process files for Physio Control
forward
global type u_nvo_proc_physio from nonvisualobject
end type
end forward

global type u_nvo_proc_physio from nonvisualobject
end type
global u_nvo_proc_physio u_nvo_proc_physio

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 

end prototypes

type variables

string lsDelimitChar


u_nvo_proc_baseline_unicode 	iu_nvo_proc_baseline_unicode
end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_delivery_order (string aspath, string asproject)
public function integer uf_replace_quote (ref string as_string)
public function integer uf_process_outbound_confirm_rpt (string asinifile, string lsproject, string asemail)
public function integer uf_process_dboh (string asproject, string asinifile)
public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_startuserfield, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow)
public function integer uf_process_userfields (integer al_startimportcolumnnumber, integer al_totaluserfields, ref datastore adw_importdw, integer adw_importdwcurrentrow, ref datastore adw_destdw, integer adw_destdwcurrentrow)
public function integer uf_process_purchase_order (string aspath, string asproject)
public function integer uf_process_itemmaster (string aspath, readonly string asproject)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut,	&
			lsSaveFileName, &
			lsPOLineCountFileName
			
Integer	liRC
integer 	liLoadRet, liProcessRet
Boolean	bRet

u_nvo_proc_baseline_unicode		lu_nvo_proc_baseline_unicode

Choose Case Upper(Left(asFile,2))
		
	Case  'PM'  
		
		// 08/13 - PCONKL - Now calling custom PO load
		//lu_nvo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode	
		
		liRC = uf_process_purchase_order(asPath, asProject)
		If liRC = 0 Then
			//Process any added PO's
			//We need to change to project. This will be changed after testing.
			liRC = gu_nvo_process_files.uf_process_purchase_order(asProject)  //asProject
		End If	
		
	Case  'DM'  
		
		liLoadRet = uf_process_delivery_order(asPath, asProject)
		If liLoadRet = 0 Then
			//Process any added SO's
			//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
			liProcessRet = gu_nvo_process_files.uf_process_Delivery_order( asProject )
		End If
		
		if liLoadRet = -1 OR liProcessRet = -1 then liRC = -1 else liRC = 0
		
	Case 'IM'
		
//		lu_nvo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode	 //21-Oct-2013:Madhu - Commented and calling local method
//		liRC = lu_nvo_proc_baseline_unicode.uf_Process_ItemMaster(asPath, asProject)  //21-Oct-2013:Madhu - Commented and calling local method
		uf_process_itemmaster(asPath,asProject) //21-Oct-2013 :Madhu -created a new function same as baseline to process IM files.
		

//	Case  'RM'  
//		
//		lu_nvo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode	
//		
//		liRC = lu_nvo_proc_baseline_unicode.uf_return_order(asPath, asProject)
//	
//		//Process any added PO's
//		//We need to change to project. This will be changed after testing.
//		liRC = gu_nvo_process_files.uf_process_purchase_order('CHINASIMS')  //asProject
//		
//		

	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
end function

public function integer uf_process_delivery_order (string aspath, string asproject);

integer liIdx
String	lsFreightTerms, lsincoterms, ls_date
string ls_null, lsSKU, lsSupplier, lsAltSKU,lswh_code   //05-Dec-2013 :Madhu- Added -"lswh_code" to set Schedule_date to the current warehouse time 
Datetime ldtwhtime    //05-Dec-2013 :Madhu- Added -to set Schedule_date to the current warehouse time 


//Process Delivery Order


u_ds_datastore 	ldsSOheader,	ldsSOdetail, ldsDOAddress, ldsDONotes
u_ds_datastore 	ldsImport

integer lirc
boolean lberror
string lslogout

//Call the generic load

u_nvo_proc_baseline_unicode lu_nvo_proc_baseline_unicode

lu_nvo_proc_baseline_unicode = create u_nvo_proc_baseline_unicode	


lirc = lu_nvo_proc_baseline_unicode.uf_load_delivery_order(aspath, asproject, ldsImport, ldsSOheader, ldsSOdetail, ldsDOAddress, ldsDONotes)	
	
IF lirc = -1 then lbError = true else lbError = false	

If Not lbError Then
	//Set TRAX DElivery Terms based on Freight Terms and UF 16 (incoterms)
	For liIdx =  1 to ldsSOheader.RowCount() 
		
		lsFreightTerms = ldsSOheader.GetITemString(liIdx,'Freight_Terms')
		lsincoterms = ldsSOheader.GetITemString(liIdx,'User_Field16')
		
		Choose Case upper(lsFreightTerms)
				
			Case 'PREPAID'
				
				if lsIncoterms = 'DDP' Then
					ldsSOheader.SetItem(liIdx,'Trax_Duty_Terms','SHIPPERDUTYVAT')
				Elseif  lsIncoterms = 'CPT' Then
					ldsSOheader.SetItem(liIdx,'Trax_Duty_Terms','CONSIGNEEDUTYVAT')
				End If
				
			Case 'COLLECT'
				
				if  lsIncoterms = 'FCA' Then
					ldsSOheader.SetItem(liIdx,'Trax_Duty_Terms','CONSIGNEEDUTYVAT')
				End If
				
		End Choose
		
		
		//Set Format for delivery_date
	
		ls_date =  ldsSOheader.GetItemString( liIdx, "delivery_date")
		
		if len(ls_date) >= 8 then
			 ls_date = left(ls_date,4) + "/" + mid(ls_date,5,2) + "/" +  mid(ls_date,7,2)
			 ldsSOheader.SetItem( liIdx, "delivery_date",ls_date)
		end if 
		
		
		//Set Format for ord_date
	
		ls_date =  ldsSOheader.GetItemString( liIdx, "ord_date")
		
		if len(ls_date) >= 8 then
			 ls_date = left(ls_date,4) + "/" + mid(ls_date,5,2) + "/" +  mid(ls_date,7,2)
			 ldsSOheader.SetItem( liIdx, "ord_date",ls_date)
		end if 
		
		
		//Set Format for schedule_date
		
		//05-Dec-2013 :Madhu- Added -set Schedule_date to the current warehouse time -START
		//ls_date =  ldsSOheader.GetItemString( liIdx, "schedule_date")
		
		//if len(ls_date) >= 8 then
		//	 ls_date = left(ls_date,4) + "/" + mid(ls_date,5,2) + "/" +  mid(ls_date,7,2)
		//	 ldsSOheader.SetItem( liIdx, "schedule_date",ls_date)
		//end if 	
		
		lswh_code=	ldsSOheader.GetItemString(liIdx,"wh_code")
		ldtwhtime = f_getLocalWorldTime(lswh_code)
		ldsSOheader.SetItem(liIdx,"schedule_date",ldtwhtime)
		//05-Dec-2013 :Madhu- Added -set Schedule_date to the current warehouse time -END
	
	Next
	
	
	IF Upper(asproject) = 'PHYSIO-MAA' THEN
		
		For liIdx =  1 to ldsSOdetail.RowCount() 
			
			SetNull(ls_null)
		
			 ldsSOdetail.SetItem( liIdx, "po_no", ls_null)
			 
			 //MEA - 8/13 - Fix issue where lot_no is being set to null. 
			 //It is being set as '' in content. 
			 
			 if IsNull(ldsSOdetail.GetItemString( liIdx, "lot_no")) OR trim(ldsSOdetail.GetItemString( liIdx, "lot_no")) = '' then
				
				ldsSOdetail.SetItem( liIdx, "lot_no", "-")
				
			end if
			
		Next
		
	END IF
	
	// 08/13 - PCONKL - We need to populate the Alternate_SKU from Item Master
	For liIdx =  1 to ldsSOdetail.RowCount() 
			
			lsSKU = ldsSODetail.GetItemString(liIdx,'sku')
			lsSupplier = ldsSODetail.GetItemString(liIdx,'supp_code')
			
			Select Alternate_SKU
			into :lsAltSKU
			From Item_MAster
			Where project_id = :asProject and sku = :lsSKU and supp_code = :lsSupplier;
		
			ldsSOdetail.SetItem( liIdx, "Alternate_SKU", lsAltSKU)
			
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
End If

If lbError Then
	Return -1
Else
	Return 0
End If

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

public function integer uf_process_outbound_confirm_rpt (string asinifile, string lsproject, string asemail);//07-Feb-2013 :Madhu  Outbound confirmation Weekly Report
// Create the SAT Weekly Report

string lsFilename ="wklyoutboundconfirmationreport"
string lsPath,ls_sql_Select,ls_where,lsFileNamePath
string msg
int returnCode
long rows
datetime pickFrom,pickTo,start_date,end_date
date aweekago 
time zero1
date yesterday
time lastsec

FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started PHC Outbound Confirmation Weekly  Report'
FileWrite(gilogFileNo,msg)


// Create our filename and path
lsFilename +=string(datetime(today(),now()),"MMDDYYYYHHMM") + '.csv'
lsPath = ProfileString(gsinifile,lsproject,"ftpfiledirout","")
lsPath += '\' + lsFilename
// log it
msg = 'Confirmation Report Path & Filename: ' + lsPath
FileWrite(gilogFileNo,msg)

// Create our datastore

Datastore 	idsPHCWeeklyReport
idsPHCWeeklyReport = f_datastoreFactory( 'd_outbound_confirmation' )


aweekago = RelativeDate ( today(), -7 )
zero1 = time("00:00:01")
start_date = datetime( aweekago,zero1 )
yesterday = RelativeDate ( today(), -1 )
lastsec = time("23:59:59")
end_date = datetime( yesterday,lastsec)

// Testing - 
/*start_date = datetime('10/01/12 00:00:01')
end_date = datetime(today(),now())*/
// End Testing -

idsPHCWeeklyReport.SetTransObject(SQLCA)
ls_sql_Select = idsPHCWeeklyReport.GetSQLSelect()
ls_where = "where Delivery_Master.Project_id = '" + lsproject + "' and Delivery_Master.Ord_Date >= '" + String(start_date) + "' and Delivery_Master.Ord_Date <= '" + String(end_date) + "'"

idsPHCWeeklyReport.SetSqlSelect(ls_sql_Select +ls_where )			

msg = 'Outbound Confirmation Report  From: ' + string( start_date) + ' To: ' + string(end_date)
FileWrite(gilogFileNo,msg)
rows= idsPHCWeeklyReport.retrieve(lsproject,start_date,end_date)

if rows <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(rows)
	if rows = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	msg = '**********************************'
	FileWrite(gilogFileNo,msg)	
	return 0 // nothing to see here...move along
end if

// Export the data to the file location
returnCode = idsPHCWeeklyReport.saveas(lsPath,CSV!,true)
msg = 'PHC Weekly Outbound Confirmation Report Save As Return Code: ' + string(returnCode)
FileWrite(gilogFileNo,msg)
msg = 'PHC Weekly Outbound Confirmation Report Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)

lsFileName = "wklyoutboundconfirmationreport" + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'

/* Now SAVE  it so we can attached the file to email. */
IF lsproject ='PHYSIO-MAA' THEN
lsFileNamePath = ProfileString(asInifile, 'PHYSIO-MAA', "archivedirectory","") + '\' + lsFileName
ELSE
lsFileNamePath = ProfileString(asInifile, 'PHYSIO-XD', "archivedirectory","") + '\' + lsFileName	
END IF
idsPHCWeeklyReport.SaveAs ( lsFileNamePath, Excel!	, true )

/* Now e-mailing the Short Shipped Report */
IF lsproject ='PHYSIO-MAA' THEN
gu_nvo_process_files.uf_send_email("PHYSIO-MAA", asEmail, "PHC Weekly Outbound Confirmation Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Outbound confirmation Report From: " +   string(start_date) +  " To: " +  string(end_date) +  " -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)
ELSE
gu_nvo_process_files.uf_send_email("PHYSIO-XD", asEmail, "PHC Weekly Outbound Confirmation Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Outbound confirmation Report From: " +   string(start_date) +  " To: " +  string(end_date) +  " -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)
END IF
Destroy idsPHCWeeklyReport


RETURN 0
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
ldsboh.Dataobject = 'd_physio_dboh'
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

	lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),26) + lsDelimitChar
	
	//Quantity	N(15,5)	Yes	N/A	Balance on hand
	
	long ll_Qty
	
	ll_Qty = ldsboh.GetItemNumber(llRowPos,'avail_qty')
	
	if ll_Qty < 0 then
		ll_Qty = 0
	end if

	lsOutString += string(ll_Qty) + lsDelimitChar

	//Quantity Allocated	N(15,5)	No	N/A	Allocated to Outbound Order

	ll_Qty = ldsboh.GetItemNumber(llRowPos,'alloc_qty')
	
	if ll_Qty < 0 then
		ll_Qty = 0
	end if	
	
	
	lsOutString += string(ll_Qty) + lsDelimitChar
	
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

	If string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'MM/DD/YYYY') <> "12/31/2999" and string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'MM/DD/YYYY') <> "01/01/1900" Then
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
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'user_field1')  + lsDelimitChar
	end if		
		

	//BH016	Supp_Invoice_No				O	
	
	if IsNull(ldsboh.GetItemString(llRowPos,'Supp_Invoice_No')) OR Trim(ldsboh.GetItemString(llRowPos,'Supp_Invoice_No')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'Supp_Invoice_No')  + lsDelimitChar
	end if	

	//BH017	Lot controlled				O				
	
	if IsNull(ldsboh.GetItemString(llRowPos,'Lot_Controlled_Ind')) OR Trim(ldsboh.GetItemString(llRowPos,'Lot_Controlled_Ind')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'Lot_Controlled_Ind')  + lsDelimitChar
	end if		
	
	//BH018	Serial controlled				O	

	if IsNull(ldsboh.GetItemString(llRowPos,'Serialized_Ind')) OR Trim(ldsboh.GetItemString(llRowPos,'Serialized_Ind')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'Serialized_Ind')  + lsDelimitChar
	end if		

	//BH019	Country_of_origin				O	
	
	if IsNull(ldsboh.GetItemString(llRowPos,'Country_Of_Origin_Default')) OR Trim(ldsboh.GetItemString(llRowPos,'Country_Of_Origin_Default')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'Country_Of_Origin_Default')  + lsDelimitChar
	end if		
	
	//BH020	owner_id				O		
	
	if IsNull(ldsboh.GetItemNumber(llRowPos,'Owner_Id'))  then
//		lsOutString += lsDelimitChar
	else	
	   lsOutString += String(ldsboh.GetItemNumber(llRowPos,'Owner_Id')) // + lsDelimitChar
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

public function integer uf_process_purchase_order (string aspath, string asproject);
// 08/13 - PCONKL - Cloned from Load Purchase Order (PM) Transaction for Baseline Unicode Client
//		Physio now has consolidation logic that requires special processing

STRING lsTemp, lsProject, lsSku, lsSupplier, lsWarehouse, lsHeaderOrderNumber, lsDetailOrderNumber, lsConsolOrderNumber, lsOrderType, lsAWB, lsRONO, lsOrderSave
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo, llMaxLineNo
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow, liHeaderFind, liDetailFind
STRING lsLogOut, lsChangeID
INTEGER li_StartCol
INTEGER li_UFIdx
DECIMAL ldQuantity
STRING lsNull
STRING lsDefaultSupp_Code,lsAltSKU //19-Sep-2013 :Madhu Added lsAlt_SKU
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

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Purchase Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	lbError = TRUE
else

	integer llFileRowPos
	integer llFilerowCount
	
	llFilerowCount = ldsImport.RowCount()
	
	//Get the next available file sequence number
	llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
	If llBatchSeq <= 0 Then Return -1
	
	
	// 08/13 - PCONKL - Pre-Consolidate orders from the file before processing...
	for llFileRowPos = 1 to llFilerowCount
		
		//If Header, get the AWB and search for other headers with that AWB
		If Trim(ldsImport.GetItemString(llFileRowPos, "col1")) = 'PM' Then
			
			ldsImport.SetItem(llFileRowPos,'col50',Trim(ldsImport.GetItemString(llFileRowPos, "col5"))) /* we are going to want to sort by order number at the end but is in different column if PM/PD*/
			
			lsHeaderOrderNumber = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			lsAWB = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
			liHeaderFind = ldsImport.Find("col1 = 'PM' and col12 = '" + lsAwb + "'",llFileRowPos +1,llFileRowCount)
			
			//If AWB Found in another header, find the detail rows associated and set to current order and save existing Order Nbr in UF3
			If liHeaderFind > 0 Then
				
				//Set current Header Row to lsHeaderOrderNumber
				lsDetailOrderNumber = Trim(ldsImport.GetItemString(liheaderFind, "col5"))
				ldsImport.SetItem(liheaderFind,'col5',lsHeaderOrderNumber)
				ldsImport.SetItem(liheaderFind,'col2','Z') /* We can delete this header - flag */
				
				//Find the detail rows col2 = 'PD' and order nbr (col4) = the order number from this header
				liDetailFind = ldsImport.Find("Col1 = 'PD' and col4 = '" + lsDetailOrderNumber + "'",liHeaderFind + 1,llFileRowCount)
				
				//update all the detail rows (do while) with order number and set UF3 to the original order nbr from the PD record
				Do While liDetailFind > 0
					
					ldsImport.SetItem(liDetailFind,'col19',ldsImport.GetItemString(liDetailFind,'col4')) /* Set Uf3 to current Order Number*/
					ldsImport.SetItem(liDetailFind,'col4',lsHeaderOrderNumber) /*Update current Detail row to the header order number */
					
					liDetailFind ++
					If liDetailFind > llFileRowCount Then
						liDetailFind = 0
					Else
						liDetailFind = ldsImport.Find("Col1 = 'PD' and col4 = '" + lsDetailOrderNumber + "'",liDetailFind,llFileRowCount)
					End If
					
				Loop
							
			End If /* Header found with same AWB*/
		
		else /*Detail*/
			
			ldsImport.SetItem(llFileRowPos,'col50',Trim(ldsImport.GetItemString(llFileRowPos, "col4"))) /* we are going to want to sort by order number at the end but is in different column if PM/PD*/
			
		End If /* Header*/
		
		
	Next /* File Row*/
	
	//Delete any headers flagged as such
	for llFileRowPos = llFilerowCount to 1 step -1
		If Trim(ldsImport.GetItemString(llFileRowPos,'col1')) = 'PM' and Trim(ldsImport.GetItemString(llFileRowPos,'col2')) = 'Z' Then
			ldsImport.DEleteRow(llFileRowPos)
		End If
	Next
	
	//Sort PM/PD back by order, we ight have deleted a header in the middle somewhere Order number copied to col50 for both header and detail
	ldsImport.SetSort("col50 A, col1 D")
	ldsImport.Sort()
	
	//Loop through
	
	llFilerowCount = ldsImport.RowCount()
	
	for llFileRowPos = 1 to llFilerowCount
	
		w_main.SetMicroHelp("Processing Purchase Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))
	
	
		//Field Name	Type	Req.	Default	Description
		//Record_ID	C(2)	Yes	“PM”	Purchase order master identifier
		//Record ID	C(2)	Yes	“PD”	Purchase order detail identifier
	
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
					lsHeaderOrderNumber = lsTemp
				End If					
					
				// 08/13 - PCONKL - Check for existing open order for this AWB. If exists, we will consolidate into that order instead. WE will change this order number to the existing and also store this order number at the detail levelm(UF2) for GR purposes
				//we also need to check for orders already processed for consolidation
				
				lsAWB = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
				lsRONO = ''
				lsConsolOrderNumber = ''
				
				select ro_no, Supp_invoice_no
				Into :lsRONO, :lsConsolOrderNumber
				FRom Receive_Master
				Where project_id = :lsProject and awb_bol_no = :lsAwb and ord_status = 'N';
				
				//Set the starting line item number > already exists (for consol)
				If lsConsolOrderNumber > '' Then
					
					Select Max(line_item_no)
					into :llMaxLineNo
					from receive_detail
					Where ro_no = :lsRONO;
					
					If llMaxLineNo > 0 Then
						llLineSeq = llMaxLineNo 
					Else
						llLineSeq = 0
					End If
					
					lsChangeID = 'U' /* we will now be updating an existing order instead of creating a new one */
					
					//Note in Log...
					FileWrite(giLogFileNo,"Consolidating PO. Order Number " + lsHeaderOrdernumber + " is being consolidated onto Order " + lsConsolOrderNumber)
					
				Else /* not consolidating*/
					lsConSolOrderNumber = lsHeaderOrderNumber
					llLineSeq = 0
				End If
				
				//Order Type	C(1)	Yes	“S”	Must be valid order typr
				
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
						
						SELECT TOP 1 Count(Supp_Code), Supp_Code  INTO :liSuppCount, :lsDefaultSupp_Code From Supplier With (NoLock) WHERE project_id =  :lsproject GROUP BY Supp_Code;  
							
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
				
				//TODO - This needs to be set from the highest existing line number if consolidating
				//llLineSeq = 0
				
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
	
				ldsPOheader.SetItem(liNewRow,'Order_No',lsConsolOrderNumber)			//May be the original order or a consolidated one
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
				
				// 10/13 - PCONKL - Supp Order Number being set from AWB now.
				
	//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	//	
	//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
	//				ldsPOheader.SetItem(liNewRow,'Supp_Order_No', lsTemp)
	//			End If				
				
				//AWB #	C(20)	No	N?A	Airway Bill/Tracking Number
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPOheader.SetItem(liNewRow,'AWB_BOL_No', lsTemp)
					ldsPOheader.SetItem(liNewRow,'Supp_Order_No', lsTemp) /* 10/13 - PCONKL - set Supplier ORder NUmber same as AWB */
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
	
				//MEA - 4/12 - Added the Rcv Slip Nbr
	
				//lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col30"))
				
				//MEA - 8/13 - Changed to col12 as per Pete and Mickael.
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPOheader.SetItem(liNewRow,'ship_ref', lsTemp)
				End If	
	
	
				//Note: 
				//
				//1.	A PO can only be deleted if no receipts have been generated against the PO.
				//2.	Deletion of a Purchase Order Master will also delete related purchase order details.
				//3.	Updated PO’s should include all of the information for the PO regardless of whether or not a specific item has been changed.
							
	
	
			//Purchase Order Detail				
					
			CASE 'PD' /* detail*/
	
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
				lsDetailOrderNumber = lsTemp
				
				If IsNull(lsTemp) OR trim(lsTemp) = '' Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
					lbError = True
					Continue		
				Else
					
				
					//Make sure we have a header for this Detail...
					//If ldsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'",1, ldsPoHeader.RowCount()) = 0 Then
					If lsDetailOrderNumber <> lsHeaderOrderNumber Then
						gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
						lbError = True
						Continue
					End If
						
					
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
				
				ldsPODetail.SetItem(llNewDetailRow,'Order_No',lsConsolOrderNumber)			//may be the original or consolidated order
				ldsPODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	
	
				ldsPODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
				ldsPODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			//	ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
				ldsPODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
				
				
				ldsPODetail.SetItem(llNewDetailRow,'User_Line_Item_No', string(llLineItemNo))
				ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No', llLineSeq)		
				
				
				//Inventory Type	C(1)	No	N/A	Inventory Type
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
		
				If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
					ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', lsTemp)
				End If	
				
				//Alternate SKU	C(50)	No	N/A	Supplier’s material number
				
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
				
				//19-Sep-2013 :Madhu -Added code to get alt_sku from Item_Master -START
	//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
	//				ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku', lsTemp)
	//			Else
	//				ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku', lsNull)
	//			End If	
				
				Select Alternate_SKU
				into :lsAltSKU
				From Item_MAster
				Where project_id = :lsProject and sku = :lsSKU and supp_code = :lsSupplier;
				
				If NOT(IsNull(lsAltSKU) OR trim(lsAltSKU) ='') Then
					ldsPODetail.SetItem( llNewDetailRow,'Alternate_Sku', lsAltSKU)
				Else
					ldsPODetail.SetItem(llNewDetailRow,'Alternate_Sku',lsNull)
				End If
				//19-Sep-2013 :Madhu -Added code to get alt_sku from Item_Master -END
				
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
	
				// 08/13 - Pconkl - Need to store the original Physio Order Numebr in UF3 so that we can send it back in GR, may be aready stored above
				If ldsPODetail.GetItemString(llNewDetailRow,'User_Field3') = '' or isNull(ldsPODetail.GetItemString(llNewDetailRow,'User_Field3')) Then
					ldsPODetail.SetItem(llNewDetailRow,'User_Field3', lsDetailOrderNumber)	
				End If
					
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
		
	////Line Item Numbers may be duplicated if orders combined but not sequential in file
	//ldsPoDetail.SetSort("order_no A")
	//ldsPoDetail.Sort()
	//
	//llFileRowCount = ldsPoDetail.RowCount()
	//for llFileRowPos = 1 to llFilerowCount
	//	
	//	lsDetailOrderNumber = ldsPoDetail.GetITemString(llFileRowPos,'order_no')
	//	If lsDetailOrderNumber <> lsOrderSave Then
	//		llLineSeq = 1
	//	Else
	//		llLineSeq ++
	//	End If
	//	
	//	lsOrderSave = lsDetailOrderNumber
	//		
	//	ldsPODetail.SetItem(llFileRowPos,'Line_Item_No', llLineSeq)		
	//	ldsPODetail.SetItem(llFileRowPos,"order_line_no",string(llLineSeq))
	//	
	//next
	
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
End If

If lbError Then
	Return -1
Else
	Return 0
End If
end function

public function integer uf_process_itemmaster (string aspath, readonly string asproject);
//21-Oct-2013 :Madhu - Copied uf_process_itemmaster from baseline to PHC

//Process Item Master (IM) Transaction for Baseline Unicode Client

STRING lsTemp, lsProject, lsSku, lsSupplier
BOOLEAN lbError, lbNew
LONG llCount, llNew, llNewRow, llOwner, llexist
INTEGER lirc, liRtnImp
STRING lsLogOut
u_ds_datastore	ldsImport

//Item Master

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
		//B	 = capture serial # at receipt and when shipped but don’t track in inventory
		//O = capture serial # only when shipped
		//Y	 = capture serial # at receipt, track in inventory and when shipped
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col42"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		ldsItem.SetItem(1,'Serialized_Ind', lsTemp)
	End If			

	//Expiration Date Controlled	C(1)	No	N/A	Expiration Date Controlled indicator
	
	//Can you please add logic to the baseline Item Master process that if a ‘D’ is passed for the expiration_controlled_ind that we set it to a ‘Y’
	//and also set the expiration_Tracking_Type field to ‘D’.


	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col43"))
	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		
		if trim(lsTemp) = "D" then 
			
			lsTemp = "Y"
			
			ldsItem.SetItem(1,'Expiration_Tracking_Type', "D")
			
		end if
		
		ldsItem.SetItem(1,'expiration_controlled_ind', lsTemp)
	End If		
	
	//Container Tracking Indicator	C(1)	No	N/A	Container Tracking Indicator

	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col44"))
	ldsItem.SetItem(1,'container_tracking_ind','N') //21-Oct-2013 :Madhu -Set Container_Tracking_Ind to N
	
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
	
	
	ldsItem.SetItem(1,'Component_Ind', 'N') //05-Nov-2013 :Madhu -Added to set Component_Ind to 'N'
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
			ldsItem.SetItem(1,'expiration_controlled_ind', 'N')         
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
//1.	If delete flag is set for “Y”, the item will not be available for further transactions.
//2.	If delete flag is set for “Y” and no warehouse transaction exist, the record will be physically deleted from database.


	
	//Save New Item to DB
	SQLCA.DBParm = "disablebind =0"
	lirc = ldsItem.Update()
	SQLCA.DBParm = "disablebind =1"
	
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

on u_nvo_proc_physio.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_physio.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

