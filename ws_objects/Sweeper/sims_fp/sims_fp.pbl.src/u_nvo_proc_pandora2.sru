$PBExportHeader$u_nvo_proc_pandora2.sru
$PBExportComments$Process Pandora Files
forward
global type u_nvo_proc_pandora2 from nonvisualobject
end type
type str_finance_record from structure within u_nvo_proc_pandora2
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

global type u_nvo_proc_pandora2 from nonvisualobject
end type
global u_nvo_proc_pandora2 u_nvo_proc_pandora2

type variables
/*datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsTOheader,	&
				idsTODetail,	&
				idsASNHeader,	&
				idsASNPackage,	&
				idsASNItem, &
				idsDONotes, &
				idsRONotes
*/
datastore ids_si

//////////////////////////////////////////////////////////// DiskErase ////////////////////////////////////////////////////////////
Protected nvo_diskerase_gggmim invo_mimggg[]
Protected nvo_diskerase_sims invo_sims[]
Protected nvo_dcmcleared invo_dcmcleared[]
Protected nvo_diskerase_clearingfile invo_cf[]
Protected nvo_diskerase_autosoc invo_autosoc[]
Protected string is_flatfiledirin = "//klrprfp001/pdashare/from_pandora"
Protected string is_ftpdirectoryout = "//klrprfp001/pdashare/to_pandora"
Boolean ib_filter_allocated //SIMSPEVS-420
datastore ids3PLCC, idsCCMaster

end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function datetime getpacifictime (string aswh, datetime adtdatetime)
public function string nonull (string as_str)
public function integer uf_process_data_dump (string asinifile)
public function integer uf_process_delivery_date (string aspath, string asproject)
public function integer uf_create_cc_order (string as_cc_no, string as_order, string as_wh, string as_inclause)
public function boolean f_getnextfield (string as_record, string as_delimeter, ref long al_pos, ref string as_field)
public function boolean f_timeastext (time at_now, ref string as_timeastext)
public function boolean f_importsims ()
public function boolean f_destroysimsobjects ()
public function boolean f_importclearingfile ()
public function boolean f_dateastext (date adt_date, ref string as_dateastext)
public function boolean f_getclearingfilerecord (string as_boxno, string as_driveserialno, ref nvo_diskerase_clearingfile anvo_clearingfile)
public function boolean f_getsimsrecord (string as_boxno, ref nvo_diskerase_sims anvo_sims)
public function boolean f_autosoc (string as_project, string as_path, string as_inifile)
public function boolean f_import_gggmim (string as_project, string as_path, string as_inifile)
public function boolean f_importcleared (string as_filename)
public function boolean f_getmimgggrecord (string as_lotno, ref nvo_diskerase_gggmim anvo_gggmim[])
public function boolean f_exportclearingfile ()
public function boolean f_getsimsforlot (ref nvo_diskerase_sims anvo_sims[])
public function boolean f_generateclearingrecords ()
public function boolean f_destroyclearingobjects ()
public function boolean f_checkforduplicateautosocs (string as_boxno, string as_driveserialno)
public function boolean f_destroymimgggobjects ()
public function boolean f_destroyautosocobjects ()
public function boolean f_destroyclearedobjects ()
public function integer uf_process_chr_ack (string aspath, string asproject)
public function integer uf_process_ups_ftpin (string aspath, string asproject)
public function integer uf_update_content (string as_wh)
public function integer uf_process_cc (string aspath, string asproject, ref string asownercd, ref string asorderno)
protected function boolean f_file_load (string as_project, string as_path, string as_inifile, string as_type)
public function integer uf_create_system_cycle_counts (string asproject, string aswhcode)
public function string uf_get_next_avail_cc_no (string asproject)
public function str_parms uf_build_cc_sku_list (string asproject, string aswhcode, string asformatloc)
public function integer uf_process_cc_eod_report (string as_ini_file, string as_project, datetime ad_next_runtime_date)
public function integer uf_process_cc_inv_snapshot (string as_ini_file, string as_project)
public function datastore uf_build_cc_system_criteria (string as_cc_no, string as_count_type, str_parms as_count_value)
public function datastore uf_build_cc_master (string asccno, string asproject, string aswhcode, string ascccode, datetime adtwhtime, string asremarks)
public function integer uf_process_insert_system_cc_orders (ref datastore adsccmaster, ref datastore adscc3pl)
public function integer uf_update_content_cc_no (string asproject, string aswhcode, ref datastore ads3plcc)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 2 characters of the file name

String	lsLogOut,	 lsSaveFileName
Integer	liRC, li_hour, li_min, li_sec
Boolean	lbOnce
String lsOwner,lsOrder
lbOnce = false

Choose Case Upper(Left(asFile,2))
		
		Case 'CC' /* Cycle Count */  
			//TimA 01/17/13 Because of Pandora issue #501
			//This function needed to be change and and two arguments added.  However, those arguments are not
			//Needed here.  So we need to just pass blank argumnets lsOwner and lsOrder
			liRC = uf_process_cc(asPath, asProject,lsOwner,lsOrder)
			//liRC = uf_process_cc(asPath, asProject)			
		
	/////////////////////////////////////////////// DiskErase ////////////////////////////////////////////////// KZUV.COM
		
		// GGG and MIM files
		Case 'BO'
			
			// Default the return code to 0
			liRC = 0
			
			// Set the inpath for the diskerase files.
			is_flatfiledirin = ProfileString(gsinifile,"PANDORA-DE","flatfiledirin","")
			
			//TimA 05/01/13
			if not f_file_load(asProject, asPath, asinifile,'BOX') then liRC = -1
			
			// If we can import the GGG and MIM files,
			if not f_import_gggmim(asProject, asPath, asinifile) then liRC = -1
		
		// Cleared File
		Case 'DC'
			
			// Default the return code to 0
			liRC = 0
			
			// Set the inpath for the diskerase files.
			is_flatfiledirin = ProfileString(gsinifile,"PANDORA-DE","flatfiledirin","")
			
			if not f_file_load(asProject, asPath, asinifile,'DCM') then liRC = -1
			
			// If we can't create the automated SOC (OC) files, set the return code to -1
			if not f_autosoc(asProject, asPath, asinifile) then liRC = -1
		
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		Case 'OA', '0A' /* Commercial Invoice 3b18 Acknowledgment - We use it to update the BOL */  
			liRC = uf_process_chr_ack(asPath, asProject)
		
		//Jxlim 04/14/2011  /* UPS Load Tender Acknowledgment to SIMS - We use it to update the BOL */  
		Case 'UP'
			liRC = uf_process_ups_ftpin(asPath, asProject)

		Case Else /* Invalid file type */
			lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_writeError(lsLogout)
			Return -1
		
End Choose

Return liRC
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
	  
6/16/2014 - dts - No longer required to create the files but still need to populate the Pandora_Finance_Data table.	  
	  */

//x Datastore	ldsOut, ldsDump_IB, ldsDump_OB, ldsOut_IntrIB, ldsOut_IntrOB, ldsFinanceTable
Datastore	 ldsDump_IB, ldsDump_OB, ldsFinanceTable

Long			llRowPos, llRowCount_IB, llRowCount_OB, llFindRow,	llNewRow, llNewRow_Intr, llFinanceRow

String			lsFind, lsOutString, lslogOut, lsProject, lsNextRunTime, lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail//, lsFileName, lsFileName_NonGIG

//Added for Intrastat...
//String			lsIntrastat, lsFileName_IntrIB, lsFileName_IntrOB, lsTransType, lsCommodity, lsCost, lsExtCost, lsCur, lsMode, ls3rdParty
String			lsIntrastat, lsTransType, lsCommodity, lsCost, lsExtCost, lsCur, lsMode, ls3rdParty
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
//x ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsProject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
//x If ldBatchSeq < 0 Then Return -1
//		//Get the Next Batch Seq Nbr for the Non-GIG file
//		ldBatchSeq_NonGIG = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
//		If ldBatchSeq_NonGIG < 0 Then Return -1

//- Do we need a separate BatchSeq for all 3 files (Finance, Intra-IB and Intra-OB)?
//x lsfileName = "DD" + String(ldBatchSeq, "00000") + ".DAT"
//x lsfileName_IntrIB = "Intr_IB" + String(ldBatchSeq, "00000") + ".DAT"
//x lsfileName_IntrOB = "Intr_OB" + String(ldBatchSeq, "00000") + ".DAT"
//		lsfileName_NonGIG = "DD" + String(ldBatchSeq_NonGIG, "00000") + ".DAT"

//Retrieve the transaction records...
lsLogout = 'Retrieving Pandora Finance Report records, from ' + lsFrom + ' to ' + lsTo +', ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount_IB = ldsDump_IB.Retrieve(lsFrom, lsTo)

lsLogOut = String(llRowCount_IB) + ' Inbound Rows were retrieved for processing. ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

llRowCount_OB = ldsDump_OB.Retrieve(lsFrom, lsTo)

lsLogOut = String(llRowCount_OB) + ' Outbound Rows were retrieved for processing. ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
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

//	lsOutString = "Finance Report for " + lsFrom + " until " + lsTo + " as of " + String(Today(), "m/d/yy hh:mm")
//	llNewRow = ldsOut.insertRow(0)
//	ldsOut.SetItem(llNewRow, 'Project_id', lsproject)
//	ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
//	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
//	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
//	ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
////	lsOutString = "In_Out|Date|Order #|Line #|E|T|R|S|Inventory Location|Ship From Name|Ship From Add 1|Ship From Add 2|Ship From City|Ship From Zip Code|Ship From Country|Ship To Name|Ship To Add 1|Ship To Add 2|Ship To City|Ship To Zip Code|Ship To Country|Sold To Name|Sold To Add 1|Sold To Add 2|Sold To City|Sold To Zip Code|Sold To Country|Part #|Part Description|VendorName?|Mfg Part #|Qty|Unit Value|Extended Value|Currency Code|HTS|ECCN|COO|Supplier Integration|ORG|Project Code|Cost Center|Value ID|CI Invoice #"
////	lsOutString = "In_Out|Date|System#|Order #|Line #|E|T|R|S|ShipFrom Location|Ship From Name|Ship From Add 1|Ship From Add 2|Ship From City|Ship From Zip Code|Ship From Country|ShipTO Location|Ship To Name|Ship To Add 1|Ship To Add 2|Ship To City|Ship To Zip Code|Ship To Country|Sold To Name|Sold To Add 1|Sold To Add 2|Sold To City|Sold To Zip Code|Sold To Country|Part #|Part Description|VendorName?|Mfg Part #|Qty|Unit Value|Extended Value|Currency Code|HTS|ECCN|COO|Supplier Integration|ORG|Project Code|Cost Center|Value ID|CI Invoice #|Requestor|Remarks"
////	lsOutString = "In_Out|Date|System#|Order #|Line #|E|T|R|S|ShipFrom Location|Ship From Name|Ship From Add 1|Ship From Add 2|Ship From City|Ship From Zip Code|Ship From Country|OrdType|TransType|ShipTO Location|Ship To Name|Ship To Add 1|Ship To Add 2|Ship To City|Ship To Zip Code|Ship To Country|Sold To Name|Sold To Add 1|Sold To Add 2|Sold To City|Sold To Zip Code|Sold To Country|Part #|Part Description|VendorName?|Mfg Part #|Qty|Unit Value|Extended Value|Currency Code|HTS|ECCN|COO|Supplier Integration|ORG|Project Code|Cost Center|Value ID|CI Invoice #|Requestor|Remarks"
//	lsOutString = "INTL|In_Out|Date|System#|Order #|Line #|E|T|R|S|ShipFrom Location|Ship From Name|Ship From Add 1|Ship From Add 2|Ship From City|Ship From Zip Code|Ship From Country|OrdType|TransType|ShipTO Location|Ship To Name|Ship To Add 1|Ship To Add 2|Ship To City|Ship To Zip Code|Ship To Country|Sold To Name|Sold To Add 1|Sold To Add 2|Sold To City|Sold To Zip Code|Sold To Country|Part #|Part Description|VendorName?|Mfg Part #|Qty|Unit Value|Extended Value|Currency Code|HTS|ECCN|COO|Supplier Integration|ORG|Project Code|Cost Center|Value ID|CI Invoice #|Requestor|Remarks"
//	llNewRow = ldsOut.insertRow(0)
//	ldsOut.SetItem(llNewRow, 'Project_id', lsproject)
//	ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
//	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
//	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
//	ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)

//	//Inbound Intrastat File...
//	lsOutString = "Inbound Intrastat Report for " + lsFrom + " until " + lsTo + " as of " + String(Today(), "m/d/yy hh:mm")
//	llNewRow = ldsOut_IntrIB.insertRow(0)
//	ldsOut_IntrIB.SetItem(llNewRow, 'Project_id', lsproject)
//	ldsOut_IntrIB.SetItem(llNewRow, 'file_name', lsFileName_IntrIB)
//	ldsOut_IntrIB.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
//	ldsOut_IntrIB.SetItem(llNewRow, 'line_seq_no', llNewRow)
//	ldsOut_IntrIB.SetItem(llNewRow, 'batch_data', lsOutString)
////	lsOutString = "DATE|SIMS System#|ORDER NUMBER|LINE NUMBER|TRANSACTION TYPE|FROM|PART NUMBER|PART DESCRIPTION|QTY|COMMODITIY CODE|EU COUNTRY OF DISPATCH|EU COUNTRY OF DESTINATION|COUNTRY OF ORIGIN|MODE OF TRANSPORT CODE|MODE OF TRANSPORT DESCRIPTION|NATURE OF TRANSACTION|NATURE OF TRANSACTION DESCRIPTION|UNIT VALUE|EXTENDED VALUE|DELIVERY TERMS|UNIT NET MASS (NEAREST KG)|EXTENDED MASS (NEAREST KG)|THIRD PARTY|TAX ID|Currency"
//	lsOutString = "DATE|SIMS System#|ORDER NUMBER|LINE NUMBER|TRANSACTION TYPE|FROM|PART NUMBER|PART DESCRIPTION|QTY|COMMODITIY CODE|EU COUNTRY OF DISPATCH|EU COUNTRY OF DESTINATION|COUNTRY OF ORIGIN|MODE OF TRANSPORT CODE|MODE OF TRANSPORT DESCRIPTION|NATURE OF TRANSACTION|NATURE OF TRANSACTION DESCRIPTION|UNIT VALUE|EXTENDED VALUE|DELIVERY TERMS|UNIT NET MASS (NEAREST KG)|EXTENDED MASS (NEAREST KG)|TAX ID|Currency"
//	llNewRow = ldsOut_IntrIB.insertRow(0)
//	ldsOut_IntrIB.SetItem(llNewRow, 'Project_id', lsproject)
//	ldsOut_IntrIB.SetItem(llNewRow, 'file_name', lsFileName)
//	ldsOut_IntrIB.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
//	ldsOut_IntrIB.SetItem(llNewRow, 'line_seq_no', llNewRow)
//	ldsOut_IntrIB.SetItem(llNewRow, 'batch_data', lsOutString)
//
//	//Outbound Intrastat File...
//	lsOutString = "Outbound Intrastat Report for " + lsFrom + " until " + lsTo + " as of " + String(Today(), "m/d/yy hh:mm")
//	llNewRow = ldsOut_IntrOB.insertRow(0)
//	ldsOut_IntrOB.SetItem(llNewRow, 'Project_id', lsproject)
//	ldsOut_IntrOB.SetItem(llNewRow, 'file_name', lsFileName_IntrOB)
//	ldsOut_IntrOB.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
//	ldsOut_IntrOB.SetItem(llNewRow, 'line_seq_no', llNewRow)
//	ldsOut_IntrOB.SetItem(llNewRow, 'batch_data', lsOutString)
//	lsOutString = "DATE|SIMS System#|ORDER NUMBER|LINE NUMBER|SHIP TO|PART NUMBER|PART DESCRIPTION|QTY|COMMODITIY CODE|COUNTRY OF ORIGIN/SHIPPED|COUNTRY OF CONSIGNEE|COUNTRY OF ORIGIN|MODE OF TRANSPORT CODE|MODE OF TRANSPORT DESCRIPTION|NATURE OF TRANSACTION|NATURE OF TRANSACTION DESCRIPTION|UNIT VALUE|EXTENDED VALUE|DELIVERY TERMS|UNIT NET MASS (NEAREST KG)|EXTENDED MASS (NEAREST KG)|THIRD PARTY|TAX ID|Currency"
//	llNewRow = ldsOut_IntrOB.insertRow(0)
//	ldsOut_IntrOB.SetItem(llNewRow, 'Project_id', lsproject)
//	ldsOut_IntrOB.SetItem(llNewRow, 'file_name', lsFileName)
//	ldsOut_IntrOB.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
//	ldsOut_IntrOB.SetItem(llNewRow, 'line_seq_no', llNewRow)
//	ldsOut_IntrOB.SetItem(llNewRow, 'batch_data', lsOutString)
end if		
		
// *********************************************************************************************
// *******************    INBOUND   ***************************************************************
// *********************************************************************************************
lsLogOut = 'Processing Inbound Finance Report Data..... ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

liThousands = 1
For llRowPos = 1 to llRowCount_IB
	if llRowPos - (liThousands * 1000) = 0 then
		lsLogOut = string(liThousands * 1000) + ' records processed..... '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		FileWrite(gilogFileNo,lsLogOut)
		liThousands += 1
	end if
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
		lstr_FinanceRec.Intl = 'X'
		ldsFinanceTable.SetItem(llFinanceRow, 'Intl', 'X')
	else
		lstr_FinanceRec.Intl = ''
	end if
	lstr_FinanceRec.In_Out = 'IB'
	lsTemp = string(ldsDump_IB.GetItemDateTime(llRowPos, 'complete_date'))
	ldtCompleteDate = datetime(lsTemp)
	ldsFinanceTable.SetItem(llFinanceRow, 'complete_date', ldtCompleteDate)
	//04/28/09 - adding ro_no for uniqueness
	lsRONO = ldsDump_IB.GetItemString(llRowPos, 'ro_no')
	ldsFinanceTable.SetItem(llFinanceRow, 'ro_no', lsRONO)
	ldsFinanceTable.SetItem(llFinanceRow, 'system_number', lsRONO)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'supp_invoice_no')
	ldsFinanceTable.SetItem(llFinanceRow, 'Invoice_No', lsTemp)
	lsLine = string(ldsDump_IB.GetItemNumber(llRowPos, 'line_item_no'))
	ldsFinanceTable.SetItem(llFinanceRow, 'line_item_no', long(lsLine))
	lsTransType = ldsDump_IB.GetItemString(llRowPos, 'TransType') //RM.UF7
	ldsFinanceTable.SetItem(llFinanceRow, 'TransType', lsTransType)
	// - if EITHER country is EU, flag it...
	if lsToCntryEU = 'Y' or lsFromCntryEU = 'Y' then // what about null? or NoNull(lsFromCntryEU) = '') then  //EU Indicator
		lsTemp = '*'
		ldsFinanceTable.SetItem(llFinanceRow, 'EUCntry', '*')
	else
		lsTemp = ''
	end if
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'ThirdParty')  //3rd-Party - if CU.UF8 is 'NO', then T_3rdParty is blank. Otherwise T_3rdParty = 'x'
	if lsTemp = 'x' then //Tempo! - 'Old' is for P2Z transition (rename of Warehouses
		ls3rdParty = 'Y' // for use later for Intrastat Report
		ldsFinanceTable.SetItem(llFinanceRow, 'ThirdParty', lsTemp)
	else
		lsTemp = ''
		ls3rdParty = 'N' // for use later for Intrastat Report
	end if
	lsOrdType = ldsDump_IB.GetItemString(llRowPos, 'ord_type')
	//Per Emily, Return From Customer is flagged here.
	if lsOrdType = 'X' or lsOrdType = 'R' then  //Returns  dts - 2/4/10 - added 'R' condition (not sure why it wasn't already included)
		lsTemp = '*'
		ldsFinanceTable.SetItem(llFinanceRow, 'Returns', '*')
	else
		lsTemp = ''
	end if
	ldsFinanceTable.SetItem(llFinanceRow, 'Ord_Type', lsOrdType)
	lsCommodity = upper(ldsDump_IB.GetItemString(llRowPos, 'Commodity')) //IM.UF5
	if lsCommodity = 'RACK' or lsCommodity = 'TLA' or lsCommodity = 'MACHINED' then
		//TEMP? flag if SHIPMENT contains 'RACK' (or can we do it just at the line level?)? 4/28/09 now Including TLA and Machined
		lsTemp = '*'
		ldsFinanceTable.SetItem(llFinanceRow, 'S_Commodity', '*')
	else
		lsTemp = ''
	end if
	ldsFinanceTable.SetItem(llFinanceRow, 'Commodity', lsCommodity)
	//Moved above (and using lsTransType)...lsTemp = ldsDump_IB.GetItemString(llRowPos, 'TransType') //RM.UF7
	lsToLoc = upper(ldsDump_IB.GetItemString(llRowPos, 'ST_Loc')) //Customer Code for owner_id
	lsToName = ldsDump_IB.GetItemString(llRowPos, 'ST_Name')
	lsToAddr1 = ldsDump_IB.GetItemString(llRowPos, 'ST_Addr1')
	lsToAddr2 = ldsDump_IB.GetItemString(llRowPos, 'ST_Addr2')
	lsToCity = ldsDump_IB.GetItemString(llRowPos, 'ST_City')
	lsToZip = ldsDump_IB.GetItemString(llRowPos, 'ST_Zip')
//moved above	lsToCntry = ldsDump_IB.GetItemString(llRowPos, 'ST_Cntry')
	ldsFinanceTable.SetItem(llFinanceRow, 'Owner_CD', lsToLoc)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Loc', lsToLoc)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Name', lsToName)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Addr1', lsToAddr1)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Addr2', lsToAddr2)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_City', lsToCity)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Zip', lsToZip)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Cntry', lsToCntry)

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
	ldsFinanceTable.SetItem(llFinanceRow, 'SKU', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'Description')
	ldsFinanceTable.SetItem(llFinanceRow, 'Description', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'VendorName') //RM.UF9
	ldsFinanceTable.SetItem(llFinanceRow, 'VendorName', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'Alternate_Sku')
	ldsFinanceTable.SetItem(llFinanceRow, 'Alternate_SKU', lsTemp)
	lsTemp = string(ldsDump_IB.GetItemNumber(llRowPos, 'Alloc_qty'))
	ldsFinanceTable.SetItem(llFinanceRow, 'Alloc_qty', double(lsTemp))
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'HTS_EU')
//12/12	ldsFinanceTable.SetItem(llFinanceRow, 'HTS_EU', lsTemp)
	lsCost = string(ldsDump_IB.GetItemNumber(llRowPos, 'Cost'))
	ldsFinanceTable.SetItem(llFinanceRow, 'Cost', double(lsCost))
	lsExtCost = string(ldsDump_IB.GetItemNumber(llRowPos, 'ExtendedCost'))
	ldsFinanceTable.SetItem(llFinanceRow, 'ExtendedCost', double(lsExtCost))
	lsCur = ldsDump_IB.GetItemString(llRowPos, 'CurCode') //RD.UF1\
	ldsFinanceTable.SetItem(llFinanceRow, 'CurCode', lsCur) // 02-04-2010
	if lsToCntry = 'US' then
		lsTemp = ldsDump_IB.GetItemString(llRowPos, 'HTS_US') //TEMP!! What about non-US and non-EU?
	else
		lsTemp = ldsDump_IB.GetItemString(llRowPos, 'HTS_EU')
	end if
	ldsFinanceTable.SetItem(llFinanceRow, 'HTS', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'ECCN')
	ldsFinanceTable.SetItem(llFinanceRow, 'ECCN', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'COO') //This should come from Put-away, not detail
	ldsFinanceTable.SetItem(llFinanceRow, 'COO', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'COO_Default') //Should come from Put-away? Getting it from IM
	lsMode = upper(ldsDump_IB.GetItemString(llRowPos, 'Transport_Mode'))
	ldsFinanceTable.SetItem(llFinanceRow, 'Transport_Mode', lsMode)
	//Nature of Transaction: Sale = 1, Return = 2
	// - OrdType = R - Return from Supplier and 'X' - Return from Customer
	ldWgt = ldsDump_IB.GetItemNumber(llRowPos, 'Wgt')
	if isnull(ldWgt) then ldWgt = 0
	ldExtWgt = ldsDump_IB.GetItemNumber(llRowPos, 'ExtendedWgt')
	if isnull(ldExtWgt) then ldExtWgt = 0
	//convert to Kilograms (do we need to make sure the value in Item Master is English?
	ldWgt = round(ldWgt * .4536, 2)
	ldsFinanceTable.SetItem(llFinanceRow, 'WGT', ldWgt)
	ldExtWgt = round(ldExtWgt * .4536, 2)
	ldsFinanceTable.SetItem(llFinanceRow, 'ExtendedWgt', ldExtWgt)
	lsTemp = upper(ldsDump_IB.GetItemString(llRowPos, 'Vat_ID'))

	/*Supplier Integration: 'X' if we have Org (for now)
if In_Out = IB, Group field from Ship-To Customer Master = GIG, BUILDS, DECOM, NPI, HWOPS or Transaction type = PO RECEIPT
if In_Out = OB, Group field from Ship-From Customer Master = GIG, BUILDS, DECOM, NPI, HWOPS
*/
// - look up org based on receiving owner...
//moved above...	lsToLoc = ldsDump_IB.GetItemString(llRowPos, 'ST_Loc') //Customer Code for owner_id
	//lsOrg = ''
	lsOrg = upper(ldsDump_IB.GetItemString(llRowPos, 'ORG')) //Customer.UF3 // 02-04-2010
	lsGroup = upper(ldsDump_IB.GetItemString(llRowPos, 'GroupCode')) //Customer.UF1
	
	if left(lsGroup, 3) = 'GIG' or left(lsGroup, 4) = 'PLAT' or left(lsGroup, 3) = 'ENT' or left(lsGroup, 5) = 'HWOPS' or left(lsGroup, 5) = 'DECOM'  or left(lsGroup, 3) = 'NPI' or left(lsGroup, 5) = 'SCRAP' or left(lsGroup, 3) = 'RMA' or left(lsGroup, 9) = 'NETDEPLOY' or left(lsGroup, 2) = 'CB' or left(lsGroup, 10) = 'SI-CUSTOME' or left(lsGroup, 5) = 'DCOPS' or left(lsGroup, 3) = 'GEO' &
	   or left(lsFromGroup, 3) = 'GIG' or left(lsFromGroup, 4) = 'PLAT' or left(lsFromGroup, 3) = 'ENT' or left(lsFromGroup, 5) = 'HWOPS' or left(lsFromGroup, 5) = 'DECOM' or left(lsFromGroup, 3) = 'NPI' or left(lsFromGroup, 5) = 'SCRAP' or left(lsFromGroup, 3) = 'RMA' or left(lsFromGroup, 9) = 'NETDEPLOY' or left(lsFromGroup, 2) = 'CB' or left(lsFromGroup, 10) = 'SI-CUSTOME' or left(lsFromGroup, 5) = 'DCOPS' or left(lsFromGroup, 3) = 'GEO' then
		ldsFinanceTable.SetItem(llFinanceRow, 'Supl_Integration', 'X')
	end if
		
	ldsFinanceTable.SetItem(llFinanceRow, 'ORG', lsOrg) // 02-04-2010
	//Need to look up Project (rp.PO_NO) 
	lsPandoraProject = ''
	select max(po_no), max(inventory_type) into :lsPandoraProject, :lsInvType
	from receive_putaway
	where ro_no = :lsRONO
	and line_item_no = :lsLine;
	
	ldsFinanceTable.SetItem(llFinanceRow, 'po_no', lsPandoraProject)
	//lsOutString += "|" //CostCenter - Customer.UF7
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'CostCenter') //Customer.UF7
	ldsFinanceTable.SetItem(llFinanceRow, 'CostCenter', lsTemp)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'Requestor')
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'Remark')
	  // - for Inbound, probably need to get InvType from put-away (so far, coming from RM)
	lsTemp = ldsDump_IB.GetItemString(llRowPos, 'awb_bol_no')
	ldsFinanceTable.SetItem(llFinanceRow, 'inventory_type', lsInvType)
	
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
lsLogOut = 'Processing Outbound Finance Report Data..... ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

llNewRow_Intr = 0
liThousands = 1
For llRowPos = 1 to llRowCount_OB
	if llRowPos - (liThousands * 1000) = 0 then
		lsLogOut = string(liThousands * 1000) + ' records processed..... ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		FileWrite(gilogFileNo,lsLogOut)
		liThousands += 1
	end if
	llFinanceRow = ldsFinanceTable.InsertRow(0)
	ldsFinanceTable.SetItem(llFinanceRow, 'In_Out', 'OB')
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
	lsInvoice = ldsDump_OB.GetItemString(llRowPos, 'invoice_no')
	//10/20 - added 'INTL' flag
	if lsFromCntry <> lsToCntry then
		ldsFinanceTable.SetItem(llFinanceRow, 'Intl', 'X')
		ldsFinanceTable.SetItem(llFinanceRow, 'CI_Num', lsInvoice) // added 3/09/10
	end if
	lsTemp = string(ldsDump_OB.GetItemDateTime(llRowPos, 'complete_date'))
	ldtCompleteDate = datetime(lsTemp)
	ldsFinanceTable.SetItem(llFinanceRow, 'complete_date', ldtCompleteDate)
	//04/28/09 - adding do_no for uniqueness
	lsDONO = ldsDump_OB.GetItemString(llRowPos, 'do_no')
	ldsFinanceTable.SetItem(llFinanceRow, 'System_Number', lsDONO)
	ldsFinanceTable.SetItem(llFinanceRow, 'Invoice_No', lsInvoice)
	lsLine = string(ldsDump_OB.GetItemNumber(llRowPos, 'line_item_no'))
	ldsFinanceTable.SetItem(llFinanceRow, 'line_item_no', long(lsLine))
	//  If EITHER country is EU, then flag it.
	if lsFromCntryEU = 'Y' or lsToCntryEU = 'Y' then // what about null? or IsNull(lsToCntryEU)) then
		lsTemp = '*'
		ldsFinanceTable.SetItem(llFinanceRow, 'EUCntry', '*')
	else
		lsTemp = ''
	end if
	
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'ThirdParty')  //3rd-Party - if CU.UF8 is 'NO', then T_3rdParty is blank. Otherwise T_3rdParty = 'x'
	if lsTemp = 'x' then //Tempo! - 'Old' is for P2Z transition (rename of Warehouses
		ls3rdParty = 'Y' // for use later for Intrastat Report
		ldsFinanceTable.SetItem(llFinanceRow, 'ThirdParty', lsTemp)
	else
		lsTemp = ''
		ls3rdParty = 'N' // for use later for Intrastat Report
	end if
	
	lsOrdType = ldsDump_OB.GetItemString(llRowPos, 'ord_type')
	//What order type? Per Emily, flag Return to Supplier
	if lsOrdType = 'X' then 
		lsTemp = '*'
		ldsFinanceTable.SetItem(llFinanceRow, 'Returns', lsTemp)
	else
		lsTemp = ''
	end if
	ldsFinanceTable.SetItem(llFinanceRow, 'ord_type', lsOrdType)
	lsCommodity = upper(ldsDump_OB.GetItemString(llRowPos, 'Commodity')) //IM.UF5
	if lsCommodity = 'RACK' or lsCommodity = 'TLA' or lsCommodity = 'MACHINED' then
		lsTemp = '*'
		ldsFinanceTable.SetItem(llFinanceRow, 's_commodity', lsTemp)
	else
		lsTemp = ''
	end if
	ldsFinanceTable.SetItem(llFinanceRow, 'Commodity', lsCommodity)
	//look up address info in Customer Table. If it's not there, leave blank....
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'TransType') //RM.UF7
	ldsFinanceTable.SetItem(llFinanceRow, 'TransType', lsTemp)
	lsToLoc = upper(ldsDump_OB.GetItemString(llRowPos, 'ST_Loc'))  //Customer Code , 3/19/10 - added 'upper'
	lsToName = ldsDump_OB.GetItemString(llRowPos, 'ST_Name')
	lsIntrastat += NoNull(lsToName) + "|"
	lsToAddr1 = ldsDump_OB.GetItemString(llRowPos, 'ST_Addr1')
	lsToAddr2 = ldsDump_OB.GetItemString(llRowPos, 'ST_Addr2')
	lsToCity = ldsDump_OB.GetItemString(llRowPos, 'ST_City')
	lsToZip = ldsDump_OB.GetItemString(llRowPos, 'ST_Zip')
	//moved above... lsToCntry = ldsDump_OB.GetItemString(llRowPos, 'ST_Cntry')
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Loc', lsToLoc)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Name', lsToName)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Addr1', lsToAddr1)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Addr2', lsToAddr2)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_City', lsToCity)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Zip', lsToZip)
	ldsFinanceTable.SetItem(llFinanceRow, 'ST_Cntry', lsToCntry)

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
	ldsFinanceTable.SetItem(llFinanceRow, 'SKU', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'Description')
	ldsFinanceTable.SetItem(llFinanceRow, 'Description', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'VendorName') 
	ldsFinanceTable.SetItem(llFinanceRow, 'VendorName', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'Alternate_Sku')
	ldsFinanceTable.SetItem(llFinanceRow, 'alternate_sku', lsTemp)
	lsTemp = string(ldsDump_OB.GetItemNumber(llRowPos, 'PickQTY')) //sum of picking qty for group by
	ldsFinanceTable.SetItem(llFinanceRow, 'alloc_qty', double(lsTemp))
	lsMode = upper(ldsDump_OB.GetItemString(llRowPos, 'Transport_Mode'))
	ldsFinanceTable.SetItem(llFinanceRow, 'Transport_Mode', lsMode)
	lsTemp = string(ldsDump_OB.GetItemNumber(llRowPos, 'Price'))
	ldsFinanceTable.SetItem(llFinanceRow, 'Cost', double(lsTemp))
	lsTemp = string(ldsDump_OB.GetItemNumber(llRowPos, 'ExtendedCost'))
	ldsFinanceTable.SetItem(llFinanceRow, 'ExtendedCost', double(lsTemp))

	ldWgt = ldsDump_OB.GetItemNumber(llRowPos, 'Wgt')
	if isnull(ldWgt) then ldWgt = 0
	ldExtWgt = ldsDump_OB.GetItemNumber(llRowPos, 'ExtendedWgt')
	if isnull(ldExtWgt) then ldExtWgt = 0
	//convert to Kilograms (do we need to make sure the value in Item Master is English?
	ldWgt = round(ldWgt * .4536, 2)
	ldsFinanceTable.SetItem(llFinanceRow, 'WGT', ldWgt)
	ldExtWgt = round(ldExtWgt * .4536, 2)
	ldsFinanceTable.SetItem(llFinanceRow, 'ExtendedWGT', ldExtWgt)
	lsCur = ldsDump_OB.GetItemString(llRowPos, 'CurCode')
	ldsFinanceTable.SetItem(llFinanceRow, 'CurCode', lsCur) // 02-04-2010
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'ECCN')
	ldsFinanceTable.SetItem(llFinanceRow, 'ECCN', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'COO') // COO from delivery_picking
	ldsFinanceTable.SetItem(llFinanceRow, 'COO', lsTemp)

	lsOrg = upper(ldsDump_OB.GetItemString(llRowPos, 'ORG')) //Customer.UF3 - 2/4/2010
	lsGroup = upper(ldsDump_OB.GetItemString(llRowPos, 'GroupCode')) //Customer.UF1

	lsToGroup = ''
	select user_field1
	into :lsToGroup
	from customer
	where project_id = 'PANDORA'
	and cust_code = :lsToLoc;
	if left(lsGroup, 3) = 'GIG' or left(lsGroup, 4) = 'PLAT' or left(lsGroup, 3) = 'ENT' or left(lsGroup, 5) = 'HWOPS' or left(lsGroup, 5) = 'DECOM'  or left(lsGroup, 3) = 'NPI' or left(lsGroup, 5) = 'SCRAP' or left(lsGroup, 3) = 'RMA' or left(lsGroup, 9) = 'NETDEPLOY' or left(lsGroup, 2) = 'CB' or left(lsGroup, 11) = 'SI-CUSTOME' or left(lsGroup, 5) = 'DCOPS' or left(lsGroup, 3) = 'GEO' &
	   or left(lsToGroup, 3) = 'GIG' or left(lsToGroup, 4) = 'PLAT' or left(lsToGroup, 3) = 'ENT' or left(lsToGroup, 5) = 'HWOPS' or left(lsToGroup, 5) = 'DECOM' or left(lsToGroup, 3) = 'NPI' or left(lsToGroup, 5) = 'SCRAP' or left(lsToGroup, 3) = 'RMA' or left(lsToGroup, 9) = 'NETDEPLOY' or left(lsToGroup, 2) = 'CB' or left(lsToGroup, 11) = 'SI-CUSTOME' or left(lsToGroup, 5) = 'DCOPS' or left(lsToGroup, 3) = 'GEO' then
		ldsFinanceTable.SetItem(llFinanceRow, 'Supl_Integration', 'X')
	end if

	ldsFinanceTable.SetItem(llFinanceRow, 'Org', lsOrg) // 02/04/10

	//Need to look up Project (dp.PO_NO) 
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'do_no') 
	lsPandoraProject = ''
	select max(po_no) into :lsPandoraProject
	from delivery_picking
	where do_no = :lsTemp
	and line_item_no = :lsLine;

	ldsFinanceTable.SetItem(llFinanceRow, 'po_no', lsPandoraProject)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'CostCenter') //Customer.UF7
	ldsFinanceTable.SetItem(llFinanceRow, 'CostCenter', lsTemp)
	ldsFinanceTable.SetItem(llFinanceRow, 'ValueID', 'NA')
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'Invoice_No')
	
//already set?	ldsFinanceTable.SetItem(llFinanceRow, 'invoice_no', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'Requestor')
	ldsFinanceTable.SetItem(llFinanceRow, 'Requestor', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'Remark')
	ldsFinanceTable.SetItem(llFinanceRow, 'Remark', lsTemp)
	// 01/10 - added AWB and InvType to Finance Table
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'awb_bol_no')
	ldsFinanceTable.SetItem(llFinanceRow, 'awb_bol_no', lsTemp)
	lsTemp = ldsDump_OB.GetItemString(llRowPos, 'inventory_type')
	ldsFinanceTable.SetItem(llFinanceRow, 'inventory_type', lsTemp)

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
//x gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut, "PANDORA")
//Write the Inbound Intrastat Report
//x gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut_IntrIB, "PANDORA")
//Write the Inbound Intrastat Report
//x gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut_IntrOB, "PANDORA")

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

public function integer uf_create_cc_order (string as_cc_no, string as_order, string as_wh, string as_inclause);string lsFindAvail, lsFindAlloc
//stolen from Confirm step in w_cc....
String ls_type, ls_sku, ls_loc, ls_serial, ls_lot, ls_po //, ls_order, sql_syntax, Errors
string ls_supp,ls_po2,ls_container_id, ls_coo //GAP 11-02 added container
datetime ldt_expiration_date  //GAP 11-02
Long i,  ll_cnt,ll_ctr,ll_ret,ll_owner, llRowCount
decimal ld_qty, ld_alloc_qty
string ls_ro_no, ls_alternate_sku, lsLogOut, lsFind
Int		liRC

ll_ctr=0

long lOwner
string lsGroup
string lsClass
string lsWhere, ls_origselect
//string lsGroupWhere 	= " Item_Master.cc_group_code = '"
//string lsClassWhere 	= " item_Master.cc_class_code = '"
//string lsOwnerWhere 	= " content.owner_id  = "
string lsGroupWhere 	= " im.cc_group_code = '"
string lsClassWhere 	= " im.cc_class_code = '"
string lsOwnerWhere 	= " cs.owner_id  = "
string lsAnd = ' and '
string lsQuote = "' "
long sysInvRows
long index

//datastore lds_cc
datastore ldsSysInv
u_sqlutil	SqlUtil
//datastore ids_si
//?datastore ldw_si // needs to be a local ds of d_cc_inventory
SqlUtil = Create u_sqlutil

//lds_cc = f_datastoreFactory( 'd_cc_qty')
// 2010-08-08 ldsSysInv = f_datastoreFactory( 'd_sys_inv_by_item_master')
ldsSysInv = f_datastoreFactory('d_sys_inv_content_summary')
//6/13 - ids_si = f_datastoreFactory( 'd_cc_inventory')

// Get the original sql select. - KZUV.COM
ls_origselect = ldsSysInv.GetSQLSelect()
SqlUtil.setOriginalSql(ls_origselect)
SqlUtil.doParseSql()

//ls_order = idw_main.GetItemstring(1, "cc_no")
//lOwner = idw_main.object.owner_id[1]

//setwarehouse( ls_wh )
//setBlindKnown()
//setBlindKnownprt()
//setCountDiff()
//
//by sku...
	// pvh - 08/03/06 - ccmods
	lsWhere = SqlUtil.getWhere()
	lsWhere += " and  cs.wh_code = '" + as_wh + "' and cs.Project_ID = 'PANDORA'"
//	lsWhere += lsAnd + "content.SKU = '" + ls_s + lsQuote 
//	lsWhere += lsAnd +  "content.owner_id  = "+ string( lOwner )
//??? build list of SKU/Owner combos and use an IN clause??? 	
//	lsWhere += lsAnd +" rtrim(content.sku) + cast(content.owner_id as varchar) in(" + as_InClause + ")"
	lsWhere += "and rtrim(cs.sku) + cast(cs.owner_id as varchar) + rtrim(po_no) in(" + as_InClause + ")"

	SqlUtil.setWhere( lsWhere )
	ldsSysInv.SetSQLSelect ( SqlUtil.getSql() )

	sysInvRows = ldsSysInv.retrieve(  )
	
	//Check to see if any skus are used in another Cyclecount if ib_freeze_cc_inventory = true
	//TimA 06/24/14 Put #853 back in
// LTK 20140605  Pandora #853  Comment out block below and allow Cycle Count to continue even if a SKU is currently in cycle count
//
////	IF ib_freeze_cc_inventory THEN
//		for index = 1 to sysInvRows
//			ls_sku	 = ldsSysInv.object.sku[ index ] 
//			ls_type = ldsSysInv.object.inventory_type[ index ]
//			if ls_type = "*" then
//				//MessageBox ("x", "SKU " + ls_sku + " is currently assigned to another cycle count, cannot continue with this count." )
//				lsLogOut = 'SKU ' + ls_sku + ' is currently assigned to another cycle count!  This Cycle Count will not be loaded.'
//				FileWrite (giLogFileNo, '     ' + lsLogOut)
//				//uf_write_log(lsLogOut)
//				gu_nvo_process_files.uf_writeError(lsLogOut)
//				Return -1
//			end if
//		next
////	END IF
	
	for index = 1 to sysInvRows
		//TimA 06/24/14 Put #853 back in
		// LTK 20140605  Pandora #853  Allow Cycle Count to continue even if a SKU is currently in cycle count
		ls_type					= ldsSysInv.object.inventory_type[ index ]
		if ls_type = "*" then
			lsLogOut = '          - SKU/Location ' +  ldsSysInv.object.sku[ index ] + '/' + ldsSysInv.object.l_code[ index ] + ' is currently assigned to another cycle count and will be set to Allocated here.'
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			ls_loc 					= 'Allocated'
		else
			ls_loc 					= ldsSysInv.object.l_code[ index ]
		end if

		//ls_loc 					= ldsSysInv.object.l_code[ index ]
		ls_sku						= ldsSysInv.object.sku[ index ] 
		ls_supp					= ldsSysInv.object.supp_code[ index ]
		ll_owner					= ldsSysInv.object.owner_id[ index ] 
		ls_type					= ldsSysInv.object.inventory_type[ index ]
		ls_serial					= ldsSysInv.object.serial_no[ index ]
		ls_lot						= ldsSysInv.object.lot_no[ index ] 
		ls_po						= ldsSysInv.object.po_no[ index ]
		ls_po2					= ldsSysInv.object.po_no2[ index ] 
		ls_container_id			= ldsSysInv.object.container_id[ index ] 
		ldt_expiration_date	= ldsSysInv.object.expiration_date[ index ]
		ls_coo					= ldsSysInv.object.country_of_origin[ index ]
		ld_qty 					= ldsSysInv.object.quantity[ index ]
		ld_alloc_qty				= ldsSysInv.object.alloc_qty[ index ]
		ls_alternate_sku		= ldsSysInv.object.alternate_sku[ index ]
		ls_ro_no 					= ldsSysInv.object.ro_no[ index ]

		if IsNull( ld_qty) then ld_qty = 0
		if IsNull( ls_loc) or len( Trim( ls_loc ) ) = 0 then ls_loc = "-"
/*		ll_ret=ids_si.Find("sku = '" + ls_sku + "' and l_code = '" + ls_loc + &
									"' and serial_no = '" + ls_serial + "' and lot_no = '" + ls_lot + &
									"' and supp_code = '" + ls_supp + "' and owner_id = " + string(ll_owner) + &
									" and po_no = '" + ls_po + "' and po_no2 = '" + ls_po2 + &
									"' and inventory_type = '" + ls_type + "' and container_id = '" + ls_Container_id + "' and country_of_origin = '" +ls_coo + "' and ro_no='" +string(ls_ro_no) + "'", 1, ids_si.RowCount())		*/
		
//		lsFind = "sku = '" + ls_sku + "' and serial_no = '" + ls_serial + "' and lot_no = '" + ls_lot + "' and supp_code = '" + ls_supp + "' and owner_id = " + string(ll_owner) + " and po_no = '" + ls_po + "' and po_no2 = '" + ls_po2 + "' and inventory_type = '" + ls_type + "' and container_id = '" + ls_Container_id + "' and country_of_origin = '" +ls_coo + "' and ro_no='" +string(ls_ro_no) + "'"
		lsFind = "sku = '" + ls_sku + "' and serial_no = '" + ls_serial + "' and lot_no = '" + ls_lot + "' and supp_code = '" + ls_supp + "' and owner_id = " + string(ll_owner) + " and po_no = '" + ls_po + "' and po_no2 = '" + ls_po2 + "' and inventory_type = '" + ls_type + "' and container_id = '" + ls_Container_id + "' and country_of_origin = '" +ls_coo + "' "		// LTK 20150325  Remove RO_NO
		lsFindAvail = lsFind + " and l_code = '" + ls_loc + "'"
		lsFindAlloc = lsFind + " and l_code = 'Allocated'"
		//this row may just have allocated qty in which case we don't want to add the row for avail qty
		if ld_qty > 0 then
			//ll_ret=ids_si.Find(lsFind + "' and l_code = '" + ls_loc + "'", 1, ids_si.RowCount())		
			ll_ret=ids_si.Find(lsFindAvail, 1, ids_si.RowCount())		
			if ll_ret <= 0 THEN
				i = ids_si.Insertrow(0)
				ids_si.object.line_item_no[ i ] = i
				ids_si.setitem(i, "cc_no", as_cc_no)
				ids_si.SetItem(i, "sku", ls_sku)
				ids_si.SetItem(i, "supp_code", ls_supp)
				ids_si.SetItem(i, "owner_id", ll_owner)
				ids_si.SetItem(i, "inventory_type", ls_type)
				ids_si.SetItem(i, "serial_no", ls_serial)
				ids_si.SetItem(i, "lot_no", ls_lot)
				ids_si.SetItem(i, "po_no", ls_po)
				ids_si.SetItem(i, "po_no2", ls_po2)					
				ids_si.SetItem(i, "container_id", ls_container_id)				
				ids_si.SetItem(i, "expiration_date", ldt_expiration_date)
				ids_si.SetItem(i, "country_of_origin", ls_coo)
				ids_si.setitem(i, "quantity", ld_qty)	
				ids_si.SetItem(i, "l_code", ls_loc)
				ids_si.SetItem(i, "ro_no", ls_ro_no)
				ids_si.SetItem(i, "alternate_sku", ls_alternate_sku)	
				//set sequence in uf_process_cc ids_si.SetItem(i, "sequence", as_sequence)
			else
				ids_si.object.quantity[ ll_ret ] = ids_si.object.quantity[ ll_ret ] + ld_qty
			end if
		end if // avail_qty > 0
		//if there is allocated qty for the sku/owner/project, the we need a cycle count line for allocated
		if ld_alloc_qty > 0 then
			//ll_ret=ids_si.Find(lsFind + "' and l_code = 'Allocated'", 1, ids_si.RowCount())		
			ll_ret=ids_si.Find(lsFindAlloc, 1, ids_si.RowCount())
			if ll_ret <= 0 THEN
				i = ids_si.Insertrow(0)
				ids_si.object.line_item_no[ i ] = i
				ids_si.setitem(i, "cc_no", as_cc_no)
				ids_si.SetItem(i, "sku", ls_sku)
				ids_si.SetItem(i, "supp_code", ls_supp)
				ids_si.SetItem(i, "owner_id", ll_owner)
				ids_si.SetItem(i, "inventory_type", ls_type)
				ids_si.SetItem(i, "serial_no", ls_serial)
				ids_si.SetItem(i, "lot_no", ls_lot)
				ids_si.SetItem(i, "po_no", ls_po)
				ids_si.SetItem(i, "po_no2", ls_po2)					
				ids_si.SetItem(i, "container_id", ls_container_id)				
				ids_si.SetItem(i, "expiration_date", ldt_expiration_date)
				ids_si.SetItem(i, "country_of_origin", ls_coo)
				ids_si.setitem(i, "quantity", ld_alloc_qty)	
				//note - may need to still specify the location but in that case need to indicate allocated vs available some how
				//ids_si.SetItem(i, "l_code", ls_loc)
				ids_si.SetItem(i, "l_code", 'Allocated')
				//note - may want to sum all allocated, without regard to ro_no
				ids_si.SetItem(i, "ro_no", ls_ro_no)
				ids_si.SetItem(i, "alternate_sku", ls_alternate_sku)	
				//set sequence in uf_process_cc ids_si.SetItem(i, "sequence", as_sequence)
			else
				ids_si.object.quantity[ ll_ret ] = ids_si.object.quantity[ ll_ret ] + ld_alloc_qty
			end if
		end if // alloc qty > 0
	next
	
//IF i_nwarehouse.ids.modifiedCount() > 0 THEN	i_nwarehouse.ids.update(FALSE,FALSE)
If ids_si.RowCount() = 0 Then
	//w_cc - MessageBox(is_title, "No System Inventory Generated")
	//Write to log file?
Else
	//w_cc - iw_window.Trigger Event ue_save()
End IF
//tab_main.tabpage_si.enabled = true

//w_main.SetMicroHelp("ready")
//?ids_si.Sort()

//Destroy lds_cc
return 1
end function

public function boolean f_getnextfield (string as_record, string as_delimeter, ref long al_pos, ref string as_field);// Original Design by KZUV.COM

long ll_begpos, ll_recordlength
boolean lb_goodfield

// Get the record length
ll_recordlength = len(as_record)

// IF the beginning position is less than the record length,
If al_pos < ll_recordlength then
	
	// Set lb_goodfield to true
	lb_goodfield = true

	// Record the beginning position.
	ll_begpos = al_pos
	
	// Find the position of the next delimeter.
	al_pos = pos(as_record, as_delimeter, al_pos)
	
	// If there is no more delimeters,
	If al_pos = 0 then
		
		// Set the position to the end of the record.
		al_pos = ll_recordlength + 1
	End if
	
	// Extract the field.
	as_field = mid(as_record, ll_begpos, al_pos - ll_begpos)
	
	// Set the final value for al_pos.
	al_pos++
	
End IF

// Return lb_goodfield.
return lb_goodfield

end function

public function boolean f_timeastext (time at_now, ref string as_timeastext);string ls_element

// Create the text from the date.
ls_element = string(hour(at_now))

// If the month is only one digit,
If len(trim(ls_element)) = 1 then
	
	// Preceed with a 0.
	ls_element = "0" + ls_element
End IF

// Build the date as text.
as_timeastext = ls_element

// Create the text from the date.
ls_element = string(minute(at_now))

// If the month is only one digit,
If len(trim(ls_element)) = 1 then
	
	// Preceed with a 0.
	ls_element = "0" + ls_element
End IF

// Build the date as text.
as_timeastext += ls_element

// Create the text from the date.
ls_element = string(second(at_now))

// If the month is only one digit,
If len(trim(ls_element)) = 1 then
	
	// Preceed with a 0.
	ls_element = "0" + ls_element
End IF

// Build the date as text.
as_timeastext += ls_element

// Return whether the date is valid.
return istime(string(at_now))
end function

public function boolean f_importsims ();// Original Design by KZUV.COM
//Lookup the NON CLEARED HD record in content summary and store them in the nvo, nvo_diskerase instance varable invo_sims

boolean lb_goodimport
string ls_lotno, ls_sku, ls_ownercd, ls_location, ls_whcode, ls_coo, ls_logstring
long ll_numsims, ll_availqty
date ldt_stockdate
long llCount

// Update the Sweeper logfile and console.
ls_logstring = '               - Getting SIMS content data, f_importsims. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,ls_logstring) // Log file
gu_nvo_process_files.uf_write_log(ls_logstring) // Screen

//// Destroy the sims objects.
f_destroysimsobjects()

//TimA 09/28/11 this count is for test should be removed when testing is done
//select COUNT(*)  INTO :llCount
//	FROM dbo.Content_Summary 
//	LEFT OUTER JOIN dbo.Receive_Master ON dbo.Content_Summary.Project_ID = dbo.Receive_Master.Project_ID 
//	AND dbo.Content_Summary.RO_No = dbo.Receive_Master.RO_No,  
//	Owner     with (nolock) 
//	WHERE Content_Summary.Project_ID = 'PANDORA' and 
//	Content_Summary.owner_id = owner.owner_id
//	and po_no = 'NON CLEARED HD' 
//	and (Avail_qty > 0 or alloc_qty > 0 or tfr_in > 0 or tfr_out > 0 or wip_qty > 0 or new_qty > 0);


// Declare the cursor.
DECLARE NONCLEARED CURSOR FOR
	SELECT Content_Summary.Lot_No,  
	Content_Summary.SKU,
	Owner.Owner_Cd,   
	Content_Summary.L_Code , 
	Content_Summary.WH_Code , 
	Content_Summary.avail_qty , 
	Content_Summary.country_of_origin, 
	Receive_Master.Complete_Date  
	FROM dbo.Content_Summary LEFT OUTER JOIN dbo.Receive_Master ON dbo.Content_Summary.Project_ID = dbo.Receive_Master.Project_ID AND dbo.Content_Summary.RO_No = dbo.Receive_Master.RO_No,  
	Owner     with (nolock) 
	WHERE  Content_Summary.Project_ID = 'PANDORA' and 
	Content_Summary.owner_id = owner.owner_id
	and po_no = 'NON CLEARED HD'
	and (Avail_qty > 0 or alloc_qty > 0 or tfr_in > 0 or tfr_out > 0 or wip_qty > 0 or new_qty > 0);
//	and (Avail_qty > 0 or alloc_qty > 0 or sit_qty > 0 or tfr_in > 0 or tfr_out > 0 or wip_qty > 0 or new_qty > 0);

// Open the cursor
OPEN NONCLEARED;

// If we can open the cursor,
If SQLCA.SQLCODE = 0 then
	
	// lb_goodimport is true
	lb_goodimport = true
		
	// Fetch the record.
	Fetch NONCLEARED into :ls_lotno, :ls_sku, :ls_ownercd, :ls_location, :ls_whcode, :ll_availqty, :ls_coo, :ldt_stockdate;
	
	// Loop through the SIMS records.
	Do While SQLCA.SQLCODE<> 100
		
		// Create a new record object.
		ll_numsims++
		invo_sims[ll_numsims] = Create nvo_diskerase_sims

		// Populate the Box Creation Date
		invo_sims[ll_numsims].f_setlotnumber(ls_lotno)
		
		// Populate the Drive Serial Number
		invo_sims[ll_numsims].f_setsku(ls_sku)
		
		// Populate the Drive Serial Number
		invo_sims[ll_numsims].f_setownercode(ls_ownercd)
		
		// Populate the Google Part Number
		invo_sims[ll_numsims].f_setlcode(ls_location)
		
		// Populate the record Box Number
		invo_sims[ll_numsims].f_setwarehousecode(ls_whcode)
		
		// Populate the Available Quantity
		invo_sims[ll_numsims].f_setavailqty(ll_availqty)
		
		// Populate the record Box Number
		invo_sims[ll_numsims].f_setcoo(ls_coo)
		
		// Populate the Drive Stock Date
		invo_sims[ll_numsims].f_setcompletedate(ldt_stockdate)
		
		// Fetch the record.
		Fetch NONCLEARED into :ls_lotno, :ls_sku, :ls_ownercd, :ls_location, :ls_whcode, :ll_availqty, :ls_coo, :ldt_stockdate;
		
		//TimA 09/28/11 for testing the Disk erase process
//		ls_logstring =  '               - ' + string(ll_numsims) +  '  Looping through ' +  String(llCount)  + ' Non Cleared HD records and updating the array. LOT( ' + ls_lotno +  ' ), f_importsims. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
//		FileWrite(giLogFileNo,ls_logstring) // Log file
//		gu_nvo_process_files.uf_write_log(ls_logstring) // Screen
		
	// Next Sims record
	Loop
	
// End if we can open the cursor.
End If

// Close the cursor.
CLOSE NONCLEARED;

//TimA 09/28/11 for testing the Disk erase process remove when done testing
ls_logstring =  '               - '  + ' Completed the looping of records and updating the array, f_importsims. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,ls_logstring) // Log file
gu_nvo_process_files.uf_write_log(ls_logstring) // Screen

// Return lb_goodimport
return lb_goodimport
end function

public function boolean f_destroysimsobjects ();long ll_numrecords, ll_recordnum

// How many sims records?
ll_numrecords = upperbound(invo_sims)

// Loop through the sims records.
for ll_recordnum = 1 to ll_numrecords
	
	// If the sims record is valid,
	If isvalid(invo_sims[ll_recordnum]) then
	
		// Destroy the sims record.
		Destroy invo_sims[ll_recordnum]
		
	// End If the sims record is valid.
	End If
	
// Next sims record.
Next

// Return true
return true
end function

public function boolean f_importclearingfile ();//////////////////////////////////////////////////////////// Not Used KZUV.COM

boolean lb_goodimport = true
string ls_record, ls_field, ls_dateastext, ls_filename
long ll_fileid, ll_numrecords, ll_pos, ll_fieldnum

// Get todays date as text and assemble the clearing file name.
//f_dateastext(today(), ls_dateastext)
////ls_filename = is_de_inpath + "/clh_menlo_" + ls_dateastext + ".csv"
//ls_filename = is_de_inpath + "/lastclearingfile.csv"

// Open the import file
ll_fileid = fileopen(ls_filename, linemode!, read!, lockreadwrite!)

// If we have a valid file,
If ll_fileid > 0 then
	 
	// Set lb_goodimport to true
	lb_goodimport = true

	// Read the first line. (headers)
	fileread(ll_fileid, ls_record)
	
	// Loop through all the records.
	Do While fileread(ll_fileid, ls_record) > 0
			
		// Set the new record in the record set.
		ll_numrecords++
		invo_cf[ll_numrecords] = Create nvo_diskerase_clearingfile
		
		// Reset ll_pos and ll_fieldnum
		ll_pos = 1
		ll_fieldnum = 0
		
		// Loop through and parse the record fields.
		Do while f_getnextfield(ls_record, ",", ll_pos, ls_field)
			
			// Incriment the field number
			ll_fieldnum++
			
			// What field is this?
			Choose Case ll_fieldnum
					
				Case 1
					
					// Populate the record Box Number
					invo_cf[ll_numrecords].f_setboxno(ls_field)
					
				Case 2
					
					// Populate the Google Part Number
					invo_cf[ll_numrecords].f_setgoogleboxno(ls_field)
					
				Case 3
					
					// Populate the Drive Serial Number
					invo_cf[ll_numrecords].f_setdrivepartno(ls_field)
					
				Case 4
					
					// Populate the Box Creation Date
					invo_cf[ll_numrecords].f_setmanpartno(ls_field)
					
				Case 5
					
					// Populate the Drive Serial Number
					invo_cf[ll_numrecords].f_setdrivesserialno(ls_field)
					
				Case 6
					
					// Populate the Drive Serial Number
					invo_cf[ll_numrecords].f_setlocation(ls_field)
					
				Case 7
					
					// Populate the Drive Serial Number
					invo_cf[ll_numrecords].f_setstockdate(date(ls_field))
					
			End Choose
		
		// Next field
		Loop
			
	// Next Record
	Loop
	
// End if we have a valid import file.
End IF

// Close the file.
fileclose(ll_fileid)

// Return lb_goodimport
return lb_goodimport
end function

public function boolean f_dateastext (date adt_date, ref string as_dateastext);// Original Design by KZUV.COM

string ls_element

// Create the text from the date.
ls_element = string(day(adt_date))

// If the month is only one digit,
If len(trim(ls_element)) = 1 then
	
	// Preceed with a 0.
	ls_element = "0" + ls_element
End IF

// Build the date as text.
as_dateastext = ls_element

// Create the text from the date.
ls_element = string(month(adt_date))

// If the month is only one digit,
If len(trim(ls_element)) = 1 then
	
	// Preceed with a 0.
	ls_element = "0" + ls_element
End IF

// Build the date as text.
as_dateastext = as_dateastext + ls_element

// Create the text from the date.
ls_element = string(year(adt_date))

// If the month is only one digit,
If len(trim(ls_element)) = 1 then
	
	// Preceed with a 0.
	ls_element = "0" + ls_element
End IF

// Build the date as text.
as_dateastext = as_dateastext + ls_element

// Return whether the date is valid.
return isdate(string(adt_date))
end function

public function boolean f_getclearingfilerecord (string as_boxno, string as_driveserialno, ref nvo_diskerase_clearingfile anvo_clearingfile);// Original Design by KZUV.COM
//Store each records found in the disk erase file base on the LOT number.  Most of the time this is 20 records found.

long ll_numrec, ll_recnum
string ls_boxno, ls_driveserialno
boolean lb_foundclearingfile

// Get the number of clearing file records.
ll_numrec = upperbound(invo_cf)

// Loop through the clearing file records.  Usually 20 times but could be more or less
For ll_recnum = 1 to ll_numrec
	
	// Get the clearing file box number and drive serial number
	invo_cf[ll_recnum].f_getboxno(ls_boxno)
	invo_cf[ll_recnum].f_getlocation(ls_driveserialno)
	
	// If the passed values match those of this record,
	If as_boxno = ls_boxno and as_driveserialno = ls_driveserialno then
		
		// Set the argument to the instance.
		anvo_clearingfile = invo_cf[ll_recnum]
		lb_foundclearingfile = true
		exit
	End If
	
// Next Clearing File Record.
Next

// Return lb_foundclearingfile
return lb_foundclearingfile
end function

public function boolean f_getsimsrecord (string as_boxno, ref nvo_diskerase_sims anvo_sims);// Original Design by KZUV.COM

long ll_numsims, ll_simsnum
string ls_simslotnumber
boolean lb_foundsims

// Get the number of sims records.
ll_numsims = upperbound(invo_sims)
			
// Loop through the sims records.
For ll_simsnum = 1 to ll_numsims
	
	// Get the sims lot number.
	invo_sims[ll_simsnum].f_getlotnumber(ls_simslotnumber)
	
	// If the MIMGGG and SIMS lot number and ownercode match,
	If as_boxno = ls_simslotnumber then
		
		// Set the argument to the instance.
		anvo_sims = invo_sims[ll_simsnum]
		
		// Set lb_foundsims to true
		lb_foundsims = true
		
	End If
	
// Next Sims Record.
Next

// Return lb_foundsims
return lb_foundsims
end function

public function boolean f_autosoc (string as_project, string as_path, string as_inifile);// Original Design by KZUV

long ll_numcleared, ll_clearednum, ll_filenum, ll_availqty,liSlash
string ls_status, ls_boxno, ls_location, ls_sku, ls_exportline, ls_notused, ls_filename, ls_dateastext,lsFilename,lsUser_Updateable_Ind
string ls_logstring, ls_newlocation, ls_coo, ls_suffix
boolean lb_goodautosoc = true
Boolean lbSQLCAauto
nvo_diskerase_sims lnvo_sims
nvo_diskerase_clearingfile lnvo_cf
	
// Update the Sweeper logfile and console.
ls_logstring = '               - Begin generating DCM AutoSOC Records, f_autosoc. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,ls_logstring)
gu_nvo_process_files.uf_write_log(ls_logstring)

//Check the lookup table to see if this process has been turned on
SELECT 	User_Updateable_Ind 	INTO :lsUser_Updateable_Ind FROM Lookup_Table   
Where 	project_id = :as_project and Code_type = 'DISKERASE' and Code_ID = 'LOAD_HISTORY_TABLE';

	
// Set the filename suffix.
f_timeastext(now(), ls_suffix)

// If we can Import the clearing file.
IF f_generateclearingrecords() then

	// Import the Pandora Cleared file.
	f_importcleared(as_path)
	
	//TimA 05/17/13
	lsFilename = as_path
	liSlash = pos(lsFilename, "\")
	do while liSlash > 0
		lsFilename = right(lsFilename, len(lsFilename) - liSlash)
		liSlash = pos(lsFilename, "\")
	loop
	
	// Get the number of cleared drives.
	ll_numcleared = upperbound(invo_dcmcleared)
	
	// Get the date as text.
	f_dateastext(today(), ls_dateastext)
	
	// Loop through the cleared drives.
	For ll_clearednum = 1 to ll_numcleared
		
		// Get the drive box number, location and status.
		invo_dcmcleared[ll_clearednum].f_getboxno(ls_boxno)
		invo_dcmcleared[ll_clearednum].f_getlocation(ls_location)
		invo_dcmcleared[ll_clearednum].f_getstatus(ls_status)
		
		// What is the status?
		Choose Case ls_status
				
			Case "GOOD TO GO"
				
				// New Location is 'main'
				ls_newlocation = "MAIN"
				
			Case "PULL TO DISKERASE PERSONNEL"
				
				// New Location is 'rejected'
				ls_newlocation = "REJECTED HD"
				
			Case Else
				
				// Bad form messagebox from an NVO.
				//TimA 05/10/13 commented this out.  We should not have a messbox display in sweeper.  Change to writting to log file
				//messagebox("Problem creating Automated SOC's", "Unknown lot status " + + " for record #" + string(ll_clearednum))
				ls_logstring = '               - Problem creating Automated SOC Unknown lot status for record # ' + string(ll_clearednum) +  ' ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,ls_logstring)
				gu_nvo_process_files.uf_write_log(ls_logstring)							
				
			// End what is the status?
		End Choose
		
		// Construct a unique file name
		ls_filename = is_flatfiledirin + "\OCR_diskeraseautosoc_" + ls_dateastext + "_" + string(ll_clearednum) + ls_suffix + ".DAT"
		
		// If we can get the corresponding combo record,
		If f_getclearingfilerecord(ls_boxno, ls_location, lnvo_cf) then
					
			// If we can get the corresponding SIMS record.
			if f_getsimsrecord(ls_boxno, lnvo_sims) then
				
				// Get the sims available quantity.
				lnvo_sims.f_getavailqty(ll_availqty)
				lnvo_sims.f_getcoo(ls_coo)
				
				// Get the sku, from po, to po, lineitemnumber and qty.
				lnvo_cf.f_getdrivepartno(ls_sku)
				
				// If this is not a duplicate AutoSOC (this run),
				If not f_checkforduplicateautosocs(ls_boxno, ls_sku) then		
		
					// Open the export file.
					ll_filenum = fileopen(ls_filename, linemode!, write!, lockwrite!, replace!)
					
					// Construct the OC header record
					ls_exportline = "OC" + "|" + ls_notused + "|" + ls_location + "|" + ls_location + "|" + left(right(ls_filename, 20), 16) + "|" + "|" + "|" + "|"
					filewrite(ll_filenum, ls_exportline)
				
					// Construct the SOC auto-export file.
					ls_exportline = "OD" + "|" + ls_sku + "|diskerase|" + ls_boxno + ":" + ls_coo + "|"  + "NON CLEARED HD" + "|" + ls_newlocation + "|" + string(ll_clearednum) + "|" + string(ll_availqty)
					filewrite(ll_filenum, ls_exportline)
				
					// Close the file.
					fileclose(ll_filenum)
					
					//TimA 05/17/13
					If lsUser_Updateable_Ind = 'Y' Then
						//TimA 05/14/14 Turn the AutoCommit to true so that we capture the insert. 
						//Sometimes these are Rollback for unknown reasons.
						 lbSQLCAauto = SQLCA.AutoCommit
						SQLCA.AutoCommit = true  

						Update DiskErase_File_Load_History set OCR_File_Name = :ls_filename where Filename = :lsFilename and Boxno = :ls_boxno
						USING SQLCA;

						SQLCA.AutoCommit = lbSQLCAauto
					End if
					
					// End If this is not a duplicate AutoSOC (this run).
					//TimA 05/10/13 Temp for testing
					ls_logstring = '               - OCR created For NON CLEARED HD ' + ls_boxno + ' ,' + ls_location + ' ,' + ls_status + ' from the cleared dcm file , f_autosoc. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
					FileWrite(giLogFileNo,ls_logstring)
					gu_nvo_process_files.uf_write_log(ls_logstring)							
				
				End If
				
				
			// End  If we can get the corresponding SIMS record.
			Else
				//TimA 09/28/11 Temp for testing
				ls_logstring = '               - OCR not written. Could not find this record in Content_Summary for NON CLEARED HD ' + ls_boxno + ' ,' + ls_location + ' ,' + ls_status + ' from the cleared dcm file , f_autosoc. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,ls_logstring)
				gu_nvo_process_files.uf_write_log(ls_logstring)							
			End IF
		Else
			//TimA 09/28/11 Temp for testing
			ls_logstring = '               - OCR record not written. The cleared DCM record  ' + ls_boxno + ' ,' + ls_location + ' ,' + ls_status + ' combination NOT found in Disk erase or Content Summary., f_autosoc. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,ls_logstring)
			gu_nvo_process_files.uf_write_log(ls_logstring)			
		// End if we can get the corresponding combo record.
		End If
		
	// Next cleared drive record.
	Next
	
// End if we can Import the clearing file.
End If

// Return lb_goodautosoc
return lb_goodautosoc
end function

public function boolean f_import_gggmim (string as_project, string as_path, string as_inifile);// Original Design by KZUV

boolean lb_goodimport, lb_ggg, lb_badrec, lbSQLCAauto
string ls_logstring, ls_filename, ls_fullfilename, ls_record, ls_field, ls_ggg_mim, ls_boxno,lsUser_Updateable_Ind
long ll_fileid, ll_pos, ll_fieldnum, ll_Records
integer liSlash
nvo_diskerase_gggmim lnvo_simsgggrecord
long llNewSerialRecs

DateTime ldFileDate
String lsBoxCompare

Long llCounter, llCounterLoop, llSerialCount
// Update the Sweeper logfile and console.
ls_logstring = '               - Importing MIM and GGG Records from file ' + as_path +', f_import_gggmim. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,ls_logstring) // Log file
gu_nvo_process_files.uf_write_log(ls_logstring) // Screen

//TimA 05/10/13 add to do a sanity check on the data
//Check the lookup table to see if this process has been turned on
SELECT 	User_Updateable_Ind 	INTO :lsUser_Updateable_Ind FROM Lookup_Table   
Where 	project_id = :as_project and Code_type = 'DISKERASE' and Code_ID = 'SANITY_CHECK';
	
// Is this GGG?
lb_ggg = pos(as_path, "GGG") > 0
			
// The file name is the passed path.
ls_filename = as_path

// Construct the full file name and archive file name.
ls_fullfilename = ls_filename

//Strip the path from the file name:
liSlash = pos(ls_FileName, "\")
do while liSlash > 0
	ls_FileName = right(ls_FileName, len(ls_FileName) - liSlash)
	liSlash = pos(ls_FileName, "\")
loop

// Open the import file
ll_fileid = fileopen(ls_fullfilename, linemode!, read!, lockreadwrite!)

// If we have a valid file,
If ll_fileid > 0 then
	
	// Set lb_goodimport to true
	lb_goodimport = true

	// Read the first line. (headers)
	fileread(ll_fileid, ls_record)
	
	llCounter ++
	w_main.SetMicroHelp("Processing Disk Erase Records.  Changes every 500 Records. " + String(llCounter))
	Yield()
	
	// Loop through all the records.
	Do While fileread(ll_fileid, ls_record) > 0
	   //TimA 12/22/11 Reset the count so the MicorHelp is update ever 500 records	
		llCounter ++
		llCounterLoop ++
		If llCounterLoop > 499 then
			w_main.SetMicroHelp("Processing Disk Errase Records.  Changes every 500 Records. " + String(llCounter))
			llCounterLoop = 0 //Reset the loop counter
		end if
		Yield()
		
		// Reset lb_badrec
		lb_badrec = false
		// Create a new GGGMIM object.
		lnvo_simsgggrecord = Create nvo_diskerase_gggmim
		// Reset ll_pos and ll_fieldnum
		ll_pos = 1
		ll_fieldnum = 0
		
		// Loop through and parse the record fields.
		Do while f_getnextfield(ls_record, "|", ll_pos, ls_field)
			// Trim up the data.
			ls_field = trim(ls_field)
			
			// Incriment the field number
			ll_fieldnum++
			
			// If this field is blank or contains only '-',
			If len(ls_field) = 0 or ls_field = '-' then
					// The second field of a GGG record will be blank.
					If not lb_ggg then
						// The entire record is bad.  Continue with the next record.
						lb_badrec = true
						exit
					Elseif ll_fieldnum <> 2 then
						// The entire record is bad.  Continue with the next record.
						lb_badrec = true
						exit
					End If
			End If
			
			// What field is this?
			Choose Case ll_fieldnum
				Case 1
					// Populate the record Box Number
					ls_boxno = ls_field
					lnvo_simsgggrecord.f_setboxnumber(ls_boxno)

//					If lsUser_Updateable_Ind = 'Y' then
//						Update DiskErase_File_Load_History set Processed = 'Y' where Boxno = :ls_boxno;
//					End If

				Case 2
					// Populate the Google Part Number
					lnvo_simsgggrecord.f_setgooglepartnumber(ls_field)
				Case 3
					// Populate the Manual Part Number
					lnvo_simsgggrecord.f_setmanpartnumber(ls_field)
				Case 4
					// Populate the Drive Serial Number
					lnvo_simsgggrecord.f_setdriveserialnumber(ls_field)
				Case 5
					// Populate the Box Creation Date
					lnvo_simsgggrecord.f_setboxcreationdate(date(ls_field))
				Case 6
					// Populate the Drive Serial Number
					lnvo_simsgggrecord.f_setlocked(ls_field = "1")
			End Choose
		// Next field
		Loop
		
		// If the last record was bad,
		if not lb_badrec then
			// Populate/Update the Drive Serial Number
			lnvo_simsgggrecord.f_setimportdate(today())
			
			// Populate/Update the Drive Serial Number
			lnvo_simsgggrecord.f_setfilename(ls_filename)
			
			// Populate/Update the Drive Serial Number
			lnvo_simsgggrecord.f_setsource(ls_ggg_mim)	

			// Insert or Update the record.
			lnvo_simsgggrecord.f_insertupdate()
			
			//TimA 05/17/13 
			If lsBoxCompare <> ls_boxno then
				If llSerialCount <> 0 then
					If lsUser_Updateable_Ind = 'Y' then
						ldFileDate	= DateTime(today(),Now())
						//TimA 05/14/14 Turn the AutoCommit to true so that we capture the insert. 
						//Sometimes these are Rollback for unknown reasons.
						 lbSQLCAauto = SQLCA.AutoCommit
						SQLCA.AutoCommit = true  

						Update DiskErase_File_Load_History set Serial_No_Processed = :llSerialCount , Processed_Date = :ldFileDate where Filename = :ls_filename and Boxno = :lsBoxCompare
						using SQLCA;

						SQLCA.AutoCommit = lbSQLCAauto
					End If
				End if
				lsBoxCompare = ls_boxno
				llSerialCount = 1
			else
				llSerialCount ++
			End if
			
		// Otherwise, if there is a bad record,
		Else
			// Set the file as error.
			//!!! SetProfileString ( "C:\PB11_Devl\Dev\App\diskerase.ini", "GGGMIM", ls_fullfilename + ":" + ls_boxno, "ERROR" )
			// Update the Sweeper logfile and console.
			ls_logstring = '               - Error processing file, f_import_gggmim. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
			FileWrite(giLogFileNo,ls_logstring) // Log file
			gu_nvo_process_files.uf_write_log(ls_logstring) // Screen
			
		// End if the last record was bad.
		End IF
		
		// Destroy the record object.
		Destroy lnvo_simsgggrecord
			
		ll_Records += 1
	// Next Record
	Loop
	
	//TimA 05/17/13 This is to update the last box number in the file
	If lsUser_Updateable_Ind = 'Y' then
		ldFileDate	= DateTime(today(),Now())
		//TimA 05/14/14 Turn the AutoCommit to true so that we capture the insert. 
		//Sometimes these are Rollback for unknown reasons.
		 lbSQLCAauto = SQLCA.AutoCommit
		SQLCA.AutoCommit = true  

		Update DiskErase_File_Load_History set Serial_No_Processed = :llSerialCount , Processed_Date = :ldFileDate where Filename = :ls_filename and Boxno = :lsBoxCompare
		using SQLCA;

		SQLCA.AutoCommit = lbSQLCAauto
	End If	
	
	// Update the Sweeper logfile and console.
	ls_logstring = '               - ' + string(ll_Records) + ' Records processed, f_import_gggmim. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(giLogFileNo,ls_logstring) // Log file
	gu_nvo_process_files.uf_write_log(ls_logstring) // Screen
	
	Select count (driveserialno) into :llNewSerialRecs From diskerase
	where filename = :ls_FileName;
	ls_logstring = '               - ' + string(llNewSerialRecs) + ' Records in DiskErase table for file ' + ls_FileName + ', f_import_gggmim. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(giLogFileNo,ls_logstring) // Log file
	gu_nvo_process_files.uf_write_log(ls_logstring) // Screen

// End if we have a valid import file.
End IF

// Close the file.
fileclose(ll_fileid)

// Return lb_goodimport
return lb_goodimport	
end function

public function boolean f_importcleared (string as_filename);//Open the DCM file that has been found and store each record in the instance invo_dcmcleared

boolean lb_goodimport, lb_ggg, lb_firstrecord
string ls_dateastext, ls_record, ls_field, ls_dirmask, ls_archivepath, ls_logstring
long ll_filenum, ll_fieldnum, ll_pos, ll_numfiles, ll_fileid, ll_numrecords
nvo_dcmcleared lnvo_dcmcleared
listbox lb
window lw

// Update the Sweeper logfile and console.
ls_logstring = '               - Importing DiskErase "cleared" file, f_importcleared. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,ls_logstring) // Log file
gu_nvo_process_files.uf_write_log(ls_logstring) // Screen

//// Open the invisible window and listbox.
//Open(lw)
//lw.visible = false
//lw.openUserObject(lb)
//
//// Get todays date as text.
//f_dateastext(today(), ls_dateastext)
//
//// Construct the import file name.
//ls_dirmask = is_de_inpath + "/dcm_clear_" + ls_dateastext + "*.csv"
//
//// Pull a list of files meeting the description.
//if lb.dirlist(ls_dirmask, 0) then	
//
//	// Get the number of files fitting the profile.
//	ll_numfiles = lb.totalitems()
//	
//	// Loop through the items.
//	For ll_filenum = 1 to ll_numfiles
//		
//		// Reset lb_firstrecord
//		lb_firstrecord = true
		
//		// Get the file name.
//		ls_filename = lb.text(ll_filenum)
//		ls_filepath = is_de_inpath + "/" + ls_filename
//		ls_archivepath = is_archpath + "/" + ls_filename
			
		// Open the import file
		ll_fileid = fileopen(as_filename, linemode!, read!, lockreadwrite!)
		
		// If we have a valid file,
		If ll_fileid > 0 then
			
			// Set lb_goodimport to true
			lb_goodimport = true
			
			// Loop through all the records.
			Do While fileread(ll_fileid, ls_record) > 0
		
				// If this is the first record,
				If lb_firstrecord then
					
					// Set lb_firstrecord to false
					lb_firstrecord = false
					
					// If the first 3 chars are NOT 'dcm',
					If left(ls_record, 3) = 'box' then
					
						// Skip the headers and go to the next line.
						continue
					End If
					
				// End if this is the first record.
				End If
				
				// Incriment the record counter.
				ll_numrecords++
					
				// Create a new GGG object.
				invo_dcmcleared[ll_numrecords] = Create nvo_dcmcleared
				lnvo_dcmcleared = invo_dcmcleared[ll_numrecords]
				
				// Reset ll_pos and ll_fieldnum
				ll_pos = 1
				ll_fieldnum = 0
				
				// Loop through and parse the record fields.
				Do while f_getnextfield(ls_record, ",", ll_pos, ls_field)
					
					// Incriment the field number
					ll_fieldnum++
					
					// What field is this?
					Choose Case ll_fieldnum
							
						Case 1
							
							// Populate the record Box Number
							lnvo_dcmcleared.f_setboxno(ls_field)
							
						Case 2
							
							// Populate the Google Part Number
							lnvo_dcmcleared.f_setlocation(ls_field)
							
						Case 3
							
							// Populate the Manual Part Number
							lnvo_dcmcleared.f_setstatus(ls_field)
							
					End Choose
				
				// Next field
				Loop	
					
			// Next Record
			Loop
			
		// End if we have a valid import file.
		End IF
	
		// Close the file.
		fileclose(ll_fileid)
//		filemove(ls_filepath, ls_archivepath)
		
//	// Next file
//	Next
//	
//// End if we can get a list of files.
//End If

//// Close the window and listbox.
//lw.closeuserobject(lb)
//close(lw)

// Return lb_goodimport
return lb_goodimport
end function

public function boolean f_getmimgggrecord (string as_lotno, ref nvo_diskerase_gggmim anvo_gggmim[]);// Original Design by KZUV.COM

//Find the records in the disk erase table and cycle throu them and store the values in anvo_gggmim.

long ll_nummimggg, ll_mimgggnum
string ls_mimgggboxno, ls_driveserialno, ls_lastdriveserialno
boolean lb_foundmimggg, lb_continue = true
nvo_diskerase_gggmim lnvo_gggmimnull[]

// Set the argument by ref to null.
anvo_gggmim = lnvo_gggmimnull

// Declare the cursor.
DECLARE GETGGGMIM CURSOR FOR
Select driveserialno
From diskerase
Where boxno = :as_lotno;

// Open the cursor
OPEN GETGGGMIM;

// If we can open the cursor,
If SQLCA.SQLCODE = 0 then
	
	// Loop through the SIMS records found in Disk erase
	Do While lb_continue
		
		// Fetch the record.
		Fetch GETGGGMIM into :ls_driveserialno;
		
		// IF this driveserialno is the same as the last one, exit the loop.
		If ls_driveserialno = ls_lastdriveserialno then exit
	
		// Return is true
		lb_foundmimggg = true
		
		// Create the gggmim object.
		ll_nummimggg++
		invo_mimggg[upperbound(invo_mimggg) + 1] =  Create nvo_diskerase_gggmim
		anvo_gggmim[ll_nummimggg] = invo_mimggg[upperbound(invo_mimggg)]
		anvo_gggmim[ll_nummimggg].f_setboxnumber(as_lotno)
		anvo_gggmim[ll_nummimggg].f_setdriveserialnumber(ls_driveserialno)
		anvo_gggmim[ll_nummimggg].f_retrieve()
		
		// Set the last drive serial number to this one.
		ls_lastdriveserialno = ls_driveserialno
		
	// Next Sims record
	Loop
	
// End if we can open the cursor.
End If

// Close the cursor.
CLOSE GETGGGMIM;

// Return lb_foundsims
return lb_foundmimggg
end function

public function boolean f_exportclearingfile ();// Original Design by KZUV.COM

long ll_filenum, ll_numclearing, ll_clearingnum
string ls_dateastext, ls_localfilename, ls_fullfilename, ls_line, ls_boxno, ls_googleboxno
string ls_logstring, ls_drivepartno, ls_driveserialno, ls_manpartno, ls_location
date ldt_stockdate
boolean lb_goodexport
string lsNewFileName
boolean lbRet
				
// Set the FTP output path for 'clearing files'.
is_ftpdirectoryout = ProfileString(gsinifile, "PANDORA-DE", "ftpfiledirout","")

// Update the Sweeper logfile and console.
ls_logstring = '               - Exporting the DiskErase Clearing Files, f_exportclearingfile. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,ls_logstring) // Log file
gu_nvo_process_files.uf_write_log(ls_logstring) // Screen

// IF we can generate the clearing file records.
if f_generateclearingrecords() then

	// Update the Sweeper logfile and console.
	ls_logstring = '               - Generating Clearing Records, f_exportclearingfile. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(giLogFileNo,ls_logstring) // Log file
	gu_nvo_process_files.uf_write_log(ls_logstring) // Screen
	
	//dts setting of ll_numclearing moved from below (so we can use it to determine if we should create a file).
	// Get the number of clearing records.
	ll_numclearing = upperbound(invo_cf)
	
	// Update the Sweeper logfile and console.
	ls_logstring = '               - ' + string(ll_numclearing) + ' Clearing file records retrieved, f_exportclearingfile. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(giLogFileNo,ls_logstring) // Log file
	gu_nvo_process_files.uf_write_log(ls_logstring) // Screen
								
	if ll_numclearing > 0 then
	
		// Get todays date as a string.
		f_dateastext(today(), ls_dateastext)
		
		// Construct the export file name.
		ls_localfilename = "clh_menlo_" + ls_dateastext + ".csv"
		ls_fullfilename = is_ftpdirectoryout + "/" + ls_localfilename
		
		// Open the export file.
		ll_filenum = fileopen(ls_fullfilename, linemode!, write!, lockwrite!, replace!)
		
		// If we have an open file to write to,
		If ll_filenum > 0 then
	
	// Update the Sweeper logfile and console.
	ls_logstring = '               - Valid File Open "' + ls_fullfilename + '", f_exportclearingfile. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(giLogFileNo,ls_logstring) // Log file
	gu_nvo_process_files.uf_write_log(ls_logstring) // Screen
			
			// Set lb_goodexport to true.
			lb_goodexport = true
			
			// Write the file headers.
			ls_line = "Box Number,Google Box No,Drives Part Number,Manufacturer Part Number,Drive Serial Number,Location,Stock Date"
			filewrite(ll_filenum, ls_line)
		
	//		// Get the number of clearing records.
	//		ll_numclearing = upperbound(invo_cf)
	
			// Loop through the clearing records.
			For ll_clearingnum = 1 to ll_numclearing
				
				// Get the clearing record values.
				invo_cf[ll_clearingnum].f_getboxno(ls_boxno)
				invo_cf[ll_clearingnum].f_getgoogleboxno(ls_googleboxno)
				invo_cf[ll_clearingnum].f_getdrivepartno(ls_drivepartno)
				invo_cf[ll_clearingnum].f_getmanpartno(ls_manpartno)
				invo_cf[ll_clearingnum].f_getdrivesserialno(ls_driveserialno)
				invo_cf[ll_clearingnum].f_getlocation(ls_location)
				invo_cf[ll_clearingnum].f_getstockdate(ldt_stockdate)
				
				// Construct the export line.
				ls_line = ls_boxno + "," + ls_googleboxno + "," + ls_drivepartno + "," + ls_manpartno + "," + ls_driveserialno + "," + ls_location + "," +  string(ldt_stockdate)
				filewrite(ll_filenum, ls_line)	
			Next
					
		// End if we have an open file to write to.
		End If
				
		// Close the file
		fileclose(ll_filenum)
		
//Archive the file
		lsNewFileName = ProfileString(gsinifile, "PANDORA-DE", "archivedirectory","") + '\' + ls_localfilename + '.txt'
		
		If FIleExists(lsNewFileName) Then
			lsNewFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')  + '.txt'
		End IF

		lbRet=gu_nvo_process_files.CopyFile(ls_FullFileName, lsNewFileName, True)
		
		// Update the Sweeper logfile and console.
		ls_logstring = '               -      Flat File successfully archived to: ' + lsNewFileName
		FileWrite(giLogFileNo,ls_logstring) // Log file
		gu_nvo_process_files.uf_write_log(ls_logstring) // Screen
		
	end if // if ll_numclearing > 0
	
// End IF we can generate the clearing file records.
End If

// Return lb_goodexport
return lb_goodexport
end function

public function boolean f_getsimsforlot (ref nvo_diskerase_sims anvo_sims[]);//////////////////////////////////////////////////////////// Not Used
boolean lb_goodimport
string ls_lotno, ls_sku, ls_ownercd, ls_location, ls_whcode, ls_dateastext, ls_coo
long ll_numsims, ll_availqty
date ldt_stockdate

//// Destroy the sims objects.
f_destroysimsobjects()

// Declare the cursor.
DECLARE NONCLEARED CURSOR FOR
	SELECT Content_Summary.Lot_No,  
	Content_Summary.SKU,
	Owner.Owner_Cd,   
	Content_Summary.L_Code , 
	Content_Summary.WH_Code , 
	Content_Summary.avail_qty , 
	Content_Summary.country_of_origin, 
	Receive_Master.Complete_Date  
	FROM dbo.Content_Summary LEFT OUTER JOIN dbo.Receive_Master ON dbo.Content_Summary.Project_ID = dbo.Receive_Master.Project_ID AND dbo.Content_Summary.RO_No = dbo.Receive_Master.RO_No,  
	Owner     with (nolock) 
	WHERE Content_Summary.owner_id = owner.owner_id
	and po_no = 'NON CLEARED HD'
	and (Avail_qty > 0 or alloc_qty > 0 or tfr_in > 0 or tfr_out > 0 or wip_qty > 0 or new_qty > 0);
//	and (Avail_qty > 0 or alloc_qty > 0 or sit_qty > 0 or tfr_in > 0 or tfr_out > 0 or wip_qty > 0 or new_qty > 0);

// Open the cursor
OPEN NONCLEARED;

// If we can open the cursor,
If SQLCA.SQLCODE = 0 then
	
	// lb_goodimport is true
	lb_goodimport = true
		
	// Fetch the record.
	Fetch NONCLEARED into :ls_lotno, :ls_sku, :ls_ownercd, :ls_location, :ls_whcode, :ll_availqty, :ls_coo, :ldt_stockdate;
	
	// Loop through the SIMS records.
	Do While SQLCA.SQLCODE<> 100
		
		// Create a new record object.
		ll_numsims++
		invo_sims[ll_numsims] = Create nvo_diskerase_sims

		// Populate the Box Creation Date
		invo_sims[ll_numsims].f_setlotnumber(ls_lotno)
		
		// Populate the Drive Serial Number
		invo_sims[ll_numsims].f_setsku(ls_sku)
		
		// Populate the Drive Serial Number
		invo_sims[ll_numsims].f_setownercode(ls_ownercd)
		
		// Populate the Google Part Number
		invo_sims[ll_numsims].f_setlcode(ls_location)
		
		// Populate the record Box Number
		invo_sims[ll_numsims].f_setwarehousecode(ls_whcode)
		
		// Populate the Available Quantity
		invo_sims[ll_numsims].f_setavailqty(ll_availqty)
		
		// Populate the record Box Number
		invo_sims[ll_numsims].f_setcoo(ls_coo)
		
		// Populate the Drive Stock Date
		invo_sims[ll_numsims].f_setcompletedate(ldt_stockdate)
		
		// Fetch the record.
		Fetch NONCLEARED into :ls_lotno, :ls_sku, :ls_ownercd, :ls_location, :ls_whcode, :ll_availqty, :ls_coo, :ldt_stockdate;
		
	// Next Sims record
	Loop
	
// End if we can open the cursor.
End If

// Close the cursor.
CLOSE NONCLEARED;

// Return lb_goodimport
return lb_goodimport
end function

public function boolean f_generateclearingrecords ();// Original Design by KZUV

long ll_nummimggg, ll_numsims, ll_filenum, ll_gggnum, ll_simsnum, ll_numgggmim, ll_gggmimnum, ll_hr, ll_numrecords
string ls_dateastext, ls_filename, ls_line, ls_gggboxnumber, ls_driveserialno
string ls_manpartlno, ls_sku, ls_location, ls_archivename, ls_simslotnumber, ls_logstring
string ls_lastclearingfilename, ls_localfilename
boolean lb_goodexport = true, lb_process = true
nvo_diskerase_gggmim lnvo_gggmim[]
long llCheckCount, llSIMSQty
	
//// Update the Sweeper logfile and console.
//ls_logstring = '               - Generating DiskErase Clearing Records, f_generateclearingrecords. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
//FileWrite(giLogFileNo,ls_logstring) // Log file
//gu_nvo_process_files.uf_write_log(ls_logstring) // Screen

// First, Destroy the existing clearing objects.
f_destroyclearingobjects()

// If we can import the sims stock owner report,
if f_importsims() then

	// Get the number of sims records.
	ll_numsims = upperbound(invo_sims)
	
	// Update the Sweeper logfile and console.
	ls_logstring = '               - ' + string(ll_numsims) + ' NON CLEARED HD records retrieved (from content_summary), f_generateclearingrecords. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(giLogFileNo,ls_logstring)
	gu_nvo_process_files.uf_write_log(ls_logstring)
	
	// Get the current time.
	ll_hr = hour(now())

	// If we have sims records,
	If ll_numsims > 0 then
		
		// Loop through the Sims records.
		For ll_simsnum = 1 to ll_numsims
	
			// Get the next sims lot number.
			invo_sims[ll_simsnum].f_getlotnumber(ls_simslotnumber)
					
			// If we can get the corresponding mim/ggg record.
			//Pass the lot number and the invo_ggmim by reference and get the diskerase records for the lot number.
			//invo_ggmim is returned with 20 records in it most of the time.
			if f_getmimgggrecord(ls_simslotnumber, lnvo_gggmim) then
	
				// Get the number of gggmim records.
				ll_numgggmim = upperbound(lnvo_gggmim)
				
				// Update the Sweeper logfile and console.
				ls_logstring = '               - Got ' + string(ll_numgggmim) + ' mmmggg records for SIMS record (LOT ' + ls_simslotnumber + '), f_generateclearingrecords. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,ls_logstring)
				gu_nvo_process_files.uf_write_log(ls_logstring)
				
				//Check Content to compare SIMS qty with Serial Count (to prevent sending Clearing file with incorrect serial count)
				select avail_qty into :llSimsQty from content
				where project_id = 'pandora'
				and lot_no = :ls_SimsLotNumber;
				
//				//DTS - TEMPO! validate that there are 20 serial rows and don't include in clearing file until we can find out what is going on.
//				if ll_numgggmim <> 20 and ll_numgggmim <> 12 then
//					select count(*) into :llCheckCount from DiskErase
//					where BoxNo = :ls_SimsLotNumber;
//					
//					ls_logstring = '               - Validating BoxNo ' + ls_simslotnumber + '.  Found ' + string(llCheckCount) + ' records in DiskErase table.  Not creating Clearing records!, f_generateclearingrecords. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
//					FileWrite(giLogFileNo,ls_logstring)
//					gu_nvo_process_files.uf_write_log(ls_logstring)
				if ll_NumGggMim <> llSIMSQty then
					//dts 6/02/11 ls_logstring = '               - Serial Count (' + string(ll_NumGggMim) + ') does not equal SIMS Qty (' + string(llSIMSQty) + ') for box ' + ls_simslotnumber + '. Not creating Clearing records!, f_generateclearingrecords. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
					ls_logstring = '               - Serial Count (' + string(ll_NumGggMim) + ') does not equal SIMS Qty (' + string(llSIMSQty) + ') for box ' + ls_simslotnumber + '. We ARE creating Clearing records!, f_generateclearingrecords. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
					FileWrite(giLogFileNo,ls_logstring)
					gu_nvo_process_files.uf_write_log(ls_logstring)
					
					/* dts 6/02/11
					select count(*) into :llCheckCount from DiskErase
					where BoxNo = :ls_SimsLotNumber;
					
					ls_logstring = '               -     Found ' + string(llCheckCount) + ' records in DiskErase table, f_generateclearingrecords. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
					FileWrite(giLogFileNo,ls_logstring)
					gu_nvo_process_files.uf_write_log(ls_logstring)
					*/
				end if
//					if ll_numgggmim = 12 then
//				 		//if there aren't 20 serial rows, check to see if there are 12 (as that is also common). Log warning but process anyway...
//						select count(*) into :llCheckCount from DiskErase
//						where BoxNo = :ls_SimsLotNumber;
//						
//						ls_logstring = '               - Validating BoxNo ' + ls_simslotnumber + '.  Warning - Found 12 records in DiskErase table but creating Clearing records anyway, f_generateclearingrecords. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
//						FileWrite(giLogFileNo,ls_logstring)
//						gu_nvo_process_files.uf_write_log(ls_logstring)
//					end if
					
					// Loop through the gggmim records.
					For ll_gggmimnum = 1 to ll_numgggmim
						
						// Increment the clearing record number.
						ll_numrecords++
						
						// Get the sims driveserialpart, manpart, sku, and location.
						lnvo_gggmim[ll_gggmimnum].f_getdriveserialnumber(ls_driveserialno)
						lnvo_gggmim[ll_gggmimnum].f_getmanpartnumber(ls_manpartlno)
						invo_sims[ll_simsnum].f_getsku(ls_sku)
						invo_sims[ll_simsnum].f_getownercode(ls_location)
						
						// Create the clearing file record.
						invo_cf[ll_numrecords] = Create nvo_diskerase_clearingfile
					
						// Populate the record Box Number
						invo_cf[ll_numrecords].f_setboxno(ls_simslotnumber)
						
						// Populate the Google Part Number
						invo_cf[ll_numrecords].f_setgoogleboxno(ls_simslotnumber)
						
						// Populate the Drive Serial Number
						invo_cf[ll_numrecords].f_setdrivepartno(ls_sku)
						
						// Populate the Box Creation Date
						invo_cf[ll_numrecords].f_setmanpartno(ls_manpartlno)
						
						// Populate the Drive Serial Number
						invo_cf[ll_numrecords].f_setdrivesserialno(ls_driveserialno)
						
						// Populate the Drive Serial Number
						invo_cf[ll_numrecords].f_setlocation(ls_location)
						
						// Populate the Drive Serial Number
						invo_cf[ll_numrecords].f_setstockdate(today())
						
					// Next gggmim record.
					Next
				//end if  //Not 20 or 12 serial records.
				
			// End If we can get the corresponding SIMS record.
			ELse
				ls_logstring = '               - COULD NOT find ' +  ' this record in the SIMS diskerase table for (LOT ' + ls_simslotnumber + '), f_generateclearingrecords. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,ls_logstring)
				gu_nvo_process_files.uf_write_log(ls_logstring)			
			End If
			
		// Next GGG record
		Next
		
	// End if we have mimggg and sims records
	End If

// End if we can generate the stockowner report.
End If

// Return lb_goodexport
return lb_goodexport
end function

public function boolean f_destroyclearingobjects ();// Original Design by KZUV.COM

nvo_diskerase_clearingfile lnvo_nullcf[]
long ll_numrecords, ll_recordnum

// How many clearing records?
ll_numrecords = upperbound(invo_cf)

// Loop through the clearing records.
for ll_recordnum = 1 to ll_numrecords
	
	// If the clearing record is valid,
	If isvalid(invo_cf[ll_recordnum]) then
	
		// Destroy the clearing record.
		Destroy invo_cf[ll_recordnum]
		
	// End If the clearing record is valid.
	End If
	
// Next clearing record.
Next

// Reset the instance.
invo_cf = lnvo_nullcf

// Return true
return true
end function

public function boolean f_checkforduplicateautosocs (string as_boxno, string as_driveserialno);// Originally designed by KZUV.COM

long ll_numautosoc, ll_autosocnum
string ls_boxno, ls_driveserialno
boolean lb_foundmatch

// Get the total of autosoc objects.
ll_numautosoc = upperbound(invo_autosoc)

// Loop through the autosoc objects.
Do while not lb_foundmatch and ll_autosocnum < ll_numautosoc
	
	// Incriment the autosocnum.
	ll_autosocnum++
	
	// Get the box and serial numbers.
	invo_autosoc[ll_autosocnum].f_getboxno(ls_boxno)
	invo_autosoc[ll_autosocnum].f_getdriveserialno(ls_driveserialno)
	
	// If the box number and drive serial number are the same as those passed,
	lb_foundmatch = as_boxno = ls_boxno and as_driveserialno = ls_driveserialno
	
// Next AutoSOC object.
Loop

// IF we didn't find a match, 
IF not lb_foundmatch then
	
	// Add the AutoSOC object to the array as being processed.
	ll_numautosoc++
	invo_autosoc[ll_numautosoc] = Create nvo_diskerase_autosoc
	invo_autosoc[ll_numautosoc].f_setboxno(as_boxno)
	invo_autosoc[ll_numautosoc].f_setdriveserialno(as_driveserialno)
End IF

// Return lb_foundmatch
return lb_foundmatch
end function

public function boolean f_destroymimgggobjects ();long ll_numrecords, ll_recordnum
boolean lb_destroyed = true, lb_locked
string ls_boxnumber, ls_googlepartnumber, ls_manpartnumber, ls_driveserialnumber, ls_source, ls_filename, ls_locked
date ldt_importdate
nvo_diskerase_gggmim lnvo_nullmimggg[]

// Purge the existing records.
//dts Delete from diskerase using sqlca;

// Get the number of mimggg records.
ll_numrecords = upperbound(invo_mimggg)

// Loop through the mimggg records.
for ll_recordnum = 1 to ll_numrecords
	
	// If the mimggg record is valid,
	if isvalid(invo_mimggg[ll_recordnum]) then
		
		// Destroy the mimggg record.
		Destroy invo_mimggg[ll_recordnum]
		
	// End If the mimggg record is valid
	End If
	
// Next mimggg record.
Next

// Reset the instance.
invo_mimggg = lnvo_nullmimggg

// Return lb_destroyed
return lb_destroyed
end function

public function boolean f_destroyautosocobjects ();// Original Design by KZUV.COM

nvo_diskerase_autosoc lnvo_nullautosoc[]
long ll_numrecords, ll_recordnum

// How many autosoc records?
ll_numrecords = upperbound(invo_autosoc)

// Loop through the autosoc records.
for ll_recordnum = 1 to ll_numrecords
	
	// If the autosoc record is valid,
	If isvalid(invo_autosoc[ll_recordnum]) then
	
		// Destroy the autosoc record.
		Destroy invo_autosoc[ll_recordnum]
		
	// End If the autosoc record is valid.
	End If
	
// Next autosoc record.
Next

// Reset the instance.
invo_autosoc = lnvo_nullautosoc

// Return true
return true
end function

public function boolean f_destroyclearedobjects ();// Original Design by KZUV.COM

nvo_dcmcleared lnvo_nulldcm[]
long ll_numrecords, ll_recordnum

// How many cleared records?
ll_numrecords = upperbound(invo_dcmcleared)

// Loop through the cleared records.
for ll_recordnum = 1 to ll_numrecords
	
	// If the cleared record is valid,
	If isvalid(invo_dcmcleared[ll_recordnum]) then
	
		// Destroy the cleared record.
		Destroy invo_dcmcleared[ll_recordnum]
		
	// End If the cleared record is valid.
	End If
	
// Next cleared record.
Next

// Reset the instance.
invo_dcmcleared = lnvo_nulldcm

// Return true
return true
end function

public function integer uf_process_chr_ack (string aspath, string asproject);//Process CHRobinson 3B18 acknowledgment (with BOL nbr)
/*
HDR01	Transaction_CD	OA2
HDR02	Record Number 	Returned from 3B18 HDR01
HDR03	Creation_DTTM	 
HDR04	Ship_ID	 //dts 3/7 - NOT the BOL (that's in the 6th field)
HDR05	Ack_CD	A=Accept, R=Reject
HDR06	Cost_Center	 - BOL (3/07)
HDR07	Invoice_NO	
HDR08	Total_WT	

*/
String	lsData, lsTemp, lsLogOut, lsStringData, lsSKU, 	lsCOO, lsSupplier
string lsCost, lsOrg, lsCostGroup, lsItem, lsCurCD
			
Integer	liRC,	liFileNo
			
Long		llCount,	llPos, llOwner, llNew, llExist, llNewRow, llFileRowCount, llFileRowPos 

Decimal ldTemp

Boolean	lbNew, lbError

datastore	lu_DS
string lsSysNum, lsBOL, lsAckCode, lsInvoice, lsDONO

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Pandora CI 3B18 ACK for Processing: " + asPath
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
	w_main.SetMicroHelp("Processing Pandora CI 3B18 ACK Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))
	//Ignore EOF
	If lsData = "EOF" Then Continue
	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsData,Len(lsData) - 1)
	End If
	
	//Validate Rec Type is OA2
	lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	If lsTemp <> '0A2' Then //Swapped the Oh for zero
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	//Record Identifier.  Should include integer portion of do_no so that we know we have the correct order
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		//Jxlim 05/23/2011 Modified to fix do_no, extra notes: dono is PANDORA + 7 DIGITS and Trans_id is 6 digits.
		//lsSysNum = lsTemp
		//lsSysNum = 'PAND' + left(lsTemp, 10)		
		lsSysNum = 'PANDO' + left(lsTemp, 9)
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Record Number' field. Record will not be processed.")
		lbError = True
		Continue		
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	//Creation Date/time
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		//lsCost = lsTemp
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Creation Date/Time' field. Record will not be processed.")
		lbError = True
		Continue
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	//Ship_ID  ? Invoice?
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Ship ID (BOL)' field. Record will not be processed.")
		lbError = True
		Continue
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	//Ack Code (A-accept, R-Reject)
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsAckCode = lsTemp
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Ack Code' field. Record will not be processed.")
		lbError = True
		Continue
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	//BOL (spec says 'COST CENTER')
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsBOL = lsTemp
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'BOL' field. Record will not be processed.")
		lbError = True
		Continue
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	//Invoice_NO
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsInvoice = lsTemp
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Invoice No' field. Record will not be processed.")
		lbError = True
		Continue
	End If

	//Total_WT	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	If Pos(lsData,'|') > 0 Then
		//lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTemp = lsData
	End If

/*
//??? Use lsSysNum instead of looking up invoice???
select do_no into :lsDONO from delivery_master
where project_id = 'pandora'
and invoice_no = :lsInvoice;
*/

//if lsDONO = '' or isNull(lsDONO) then
	//log message
//else
//	execute immediate "Begin Transaction" using SQLCA;
	update delivery_master
	set awb_bol_no = :lsBOL
	where do_no = :lsSysNum; //:lsDONO;
//	if SQLCA.SQLCode = 0 then
		//Execute Immediate "COMMIT" using SQLCA;  MikeA - DE15499
		commit using sqlca;
//	else
//		Execute Immediate "rollback" using SQLCA;
//	end if
//end if

Next /*File row to Process */

w_main.SetMicroHelp("")

//??? update last update user/time?
//lsLogOut = Space(10) + String(llNew) + ' Item-Cost Records were successfully added and ' + String(llExist) + ' Records were updated.'
//FileWrite(gilogFileNo,lsLogOut)

If lbError then
	Return -1
Else
	Return 0
End If

Return 0
end function

public function integer uf_process_ups_ftpin (string aspath, string asproject);//Jxlim 04/05/2011 Process file coming back from UPS Worldship Ack
//Sims update awb_bol_no field from BOL nbr that send from UPS Ack
//Process UPS Load Tender acknowledgment (with BOL nbr)

String		lsData, lsTemp, lsLogOut, lsStringData, lsSKU, 	lsCOO, lsSupplier
string 		lsCost, lsOrg, lsCostGroup, lsItem, lsCurCD			
Integer		liRC,	liFileNo			
Long			llCount,	llPos, llOwner, llNew, llExist, llNewRow, llFileRowCount, llFileRowPos , ll_trackID
Decimal 	ldTemp
Boolean	lbNew, lbError
datastore	lu_DS
string 		lsSysNum, lsBOL, lsAckCode, lsInvoice, lsDONO, ls_trackID, lsPro
is_flatfiledirin = ProfileString(gsinifile,"PANDORA-UPS","flatfiledirin","")

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the File In
lsLogOut = '      - Opening UPS BOL 2011 File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Pandora UPS Load Tender Acknowledgement for Processing: " + asPath
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

//Jxlim 04/05/2011 Looping each record
For llfileRowPos = 1 to llFileRowCount
	w_main.SetMicroHelp("Processing Pandora UPS Load tender Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))
	//Ignore EOF
	If lsData = "EOF" Then Continue
	//Make sure first Char is not a comma
	If Left(lsData,1) = ',' Then
		lsData = Right(lsData,Len(lsData) - 1)
	End If
	
	
	//Validate BOL Creation Date, This portion is neccessary to strip off the comma however the Bol date is not currently update in SIMs table.
	If Pos(lsData, ',') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,',') - 1))			
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) +  " - Invalid BOL Creation Date: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If
	
	//Validate Pandora system number
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next comma		
	If Pos(lsData, ',') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,',') - 1))
		lsSysNum = lsTemp		
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Pandora System Number: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If

	//PRO Number
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next comma		
	If 	Pos(lsData, ',') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,',') - 1))
		lsPro = lsTemp		
	//If (lsData) > ''  Then		
	//	lsTemp = Trim(lsData)
	//	lsBol = lsTemp
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - PRO number expected : '" + lsTemp+ "'. Record will not be processed.")
		lbError = True
		Continue
	End If
	
	//BOL number
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next comma		
	If (lsData) > ''  Then		
		lsTemp = Trim(lsData)
		lsBol = lsTemp
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - BOL number expected : '" + lsTemp+ "'. Record will not be processed.")
		lbError = True
		Continue
	End If
	
	// Menlo to receive a BOL number in the UPS ACK and Update the “AWB/BOL Nbr” and “Shipper Tracking ID” in the packing list field and with this number.
    //The BOL may be the same for Multiple Pandora Order Numbers.
    //For each record update the Bol number for the do_no on pandora project.
	//Jxlim 06/03/2011 Only one will be populated because it either goes air or ground, not both.
	If lsPro > '' Then   //If Pro number is available use Pro Number
		Update Delivery_Master
		Set awb_bol_no = :lsPro
		Where do_no = :lsSysNum    	
		Using SQLCA;	
	Else					//If Bol number is available use Bol number
		Update Delivery_Master
		Set awb_bol_no = :lsBOL
		Where do_no = :lsSysNum    	
		Using SQLCA;	
	End If
		
	
	 //For each record update the Shiiper Tracking ID for the do_no on Packing list pandora project based on the above BOL number 
	ll_trackID = Long(ls_trackID)
	//Jxlim 06/03/2011 Only one will be populated because it either goes air or ground, not both.
	If lsPro > '' Then   //If Pro number is available use Pro Number
		Update Delivery_Packing
		Set Shipper_Tracking_ID = :lsPro
		Where do_no = :lsSysNum    	
		//Execute Immediate "COMMIT" using SQLCA;	  MikeA - DE15499
		commit using sqlca;
	Else				//If Bol number is available use Bol number
		Update Delivery_Packing
		Set Shipper_Tracking_ID = :lsBOL
		Where do_no = :lsSysNum    	
		//Execute Immediate "COMMIT" using SQLCA;  MikeA - DE15499
		commit using sqlca;
	End If
	
		
Next /*File row to Process */

w_main.SetMicroHelp("")

If lbError then
	Return -1
Else
	Return 0
End If

Return 0
end function

public function integer uf_update_content (string as_wh);/* assuming we're freezing inventory so not doing the following (from w_cc)...
ib_freeze_cc_inventory = false

SELECT freeze_CC_Inventory INTO :ls_cc_freeze_CC_Inventory FROM project WHERE Project_ID = :gs_project USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN
	MessageBox("DB Error", SQLCA.SQLErrText)
END IF

IF ls_cc_freeze_CC_Inventory = "Y" THEN
	ib_freeze_cc_inventory = true
END IF
*/

string  ls_loc, ls_sku, ls_supp, ls_serial, ls_lot, ls_po, ls_po2, ls_container_id, ls_coo, ls_ro_no, lsLocSave, ls_Type, ls_cc_no
datetime ldt_expiration_date
string ls_coo_key
integer li_key
long ll_owner
integer li_idx
string ls_max_country_origin

//Need to go through and lock the inventory.
for li_idx = 1 to ids_si.RowCount()
	//if ids_si.GetItemStatus(li_idx, 0, Primary!) = NewModified! then 
//use as_wh		ls_wh_code 				= ids_si.object.wh_code[ 1 ]
		ls_loc 					= ids_si.object.l_code[ li_idx ]
		ls_sku						= ids_si.object.sku[ li_idx ] 
		ls_supp					= ids_si.object.supp_code[ li_idx ]
		ll_owner					= ids_si.object.owner_id[ li_idx ] 
		ls_type					= ids_si.object.inventory_type[ li_idx ]
		ls_serial					= ids_si.object.serial_no[ li_idx ]
		ls_lot						= ids_si.object.lot_no[ li_idx ] 
		ls_po						= ids_si.object.po_no[ li_idx ]
		ls_po2					= ids_si.object.po_no2[ li_idx ] 
		ls_container_id			= ids_si.object.container_id[ li_idx ] 
		ldt_expiration_date	= ids_si.object.expiration_date[ li_idx ]
		ls_coo					= ids_si.object.country_of_origin[ li_idx ]
		//ls_ro_no					= ids_si.object.ro_no[ li_idx ]				// LTK 20150317  Remove RO_NO from CC
		ls_cc_no					= ids_si.object.cc_no[ li_idx ]

		//Check to see if duplicate content record will be created.
		SELECT MAX(Country_of_Origin) INTO :ls_max_country_origin
			FROM Content With (Nolock) 
			WHERE project_id = 'PANDORA' AND
						wh_code = :as_wh AND
						L_Code = :ls_loc AND
						sku = :ls_sku AND
						Supp_Code = :ls_supp AND
						Owner_ID = :ll_owner AND
						Inventory_Type = '*' AND
						Serial_No = :ls_serial AND
						Lot_No = :ls_lot AND
						PO_No = :ls_po AND
						PO_No2 = :ls_po2 AND
						Container_ID = :ls_container_id AND
						Expiration_Date = :ldt_expiration_date 
						USING SQLCA;					
						// LTK 20150317  Removed RO_NO from above SQL

		if sqlca.sqlcode < 0 then
			//Execute Immediate "ROLLBACK" using SQLCA;  MikeA - DE15499
			rollback using sqlca;
			//TEMPO Messagebox ("DB Error", SQLCA.SQLErrText)
			Return -1
		end if

		//	Due to setting all inventory types to the same value there is a risk of creating duplicate keys,
		//if this is the case, on the duplicate key record set Content.COO = 'CC1'.  
		//If necessary use CC2, then CC3, etc. to break the tie.  (From spec)

		If IsNull(ls_max_country_origin) Or Trim(ls_max_country_origin) = "" THEN
			ls_coo_key = "CC1"
		ELSE
			li_key = integer(right(ls_max_country_origin, 1))
			li_key = li_key + 1
			ls_coo_key = "CC" + string(li_key)
		END IF	

		/* MEA - 05/12 - Added CC_No */

		UPDATE CONTENT
			SET 	inventory_type = '*',	
					Country_of_Origin = :ls_coo_key,
					old_inventory_type = :ls_type, 
						old_country_of_origin = :ls_coo,
						cc_no = :ls_cc_no
			WHERE project_id = 'PANDORA' AND
						wh_code = :as_wh AND
						L_Code = :ls_loc AND
						sku = :ls_sku AND
						Supp_Code = :ls_supp AND
						Owner_ID = :ll_owner AND
						Inventory_Type = :ls_type AND
						Serial_No = :ls_serial AND
						Lot_No = :ls_lot AND
						PO_No = :ls_po AND
						PO_No2 = :ls_po2 AND
						Container_ID = :ls_container_id AND
						Expiration_Date = :ldt_expiration_date AND
						Country_of_Origin = :ls_coo 
						//dts 9/9/13 - Execute Immediate "Commit" using SQLCA;
						using SQLCA;
						// LTK 20150317  Removed RO_NO from above SQL

		if sqlca.sqlcode < 0 then
			//Execute Immediate "ROLLBACK" using SQLCA;  MikeA - DE15499
			rollback using sqlca;
			//TEMPO Messagebox ("DB Error", SQLCA.SQLErrText)
			Return -1
		end if
	//end if /*New */
next /*SI row */
return 1
end function

public function integer uf_process_cc (string aspath, string asproject, ref string asownercd, ref string asorderno);// new objects: d_sys_inv_by_item_master, sqlutil, d_cc_master, d_cc_inventory, f_datastorefactory(?), u_sqlutil
/* Process Cycle Count Order for Pandora
 - file comes to Menlo as a 4C1 and is translated by ICC to:

IH	Inventory Header
IH001 	Order Type				"CC" MEN?
IH003 	Order Number
IH004 	Inventory Org Code
IH005 	Trransaction Date
	
ID	Inventory Detail
ID001 	Type						"AV1"
ID002 	Sequence
ID003 	Supplier Location		Owner
ID004 	GPN						SKU
ID005 	GPN Description
ID006 	UOM
ID007 	ABC Class
ID008 	Status
ID009 	Count Date
ID0010	Count Qty
ID0011	Reason Code
ID0012	Counter
ID0013	Comments
ID0014	Partner Order Reference 
ID0015	Project Code 
*/ 

Datastore	lu_ds, ldsItem, ldsCCInterface, ldsCCMaster, ldsCCInventory, ldsCCGenericField

datetime ldtWHTime

// 01/18/2010 ujh Add lsDelete_TONO, lsDelete_List  This is Owner Change Fix 1 of 5
// 02/08/2010 ujh add lsRecDataSoc, lsReturnTxt,  llReturnCode, lsListIgnored, lsListProcessed, lbSQLCAauto, 
							// llCntReceived, llCntIgnored, llCntProcessed,   llspParamMax, lsParamSeperator  for  AutoSOCchange
String	lsLogout, lsStringData, lsTemp, lsRecData, lsRecType, lsDesc, lsSKU, lsSupplier, lsNoteText ,lsNoteType, &
		lsCCNO, lsWH, lsUF3, lsDelete_TONO, lsDelete_List, lsRecDataSOC, lsReturnTxt, lsListIgnored, lsListProcessed, lsParamSeperator
Integer	liRC, liFileNo, i, liStart, liEnd
Long		llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llOwnerID, llNewNotesRow, llNoteSeq, llNoteLine &
              ,llReturnCode, llCntReceived, llCntIgnored, llCntProcessed,   llspParamMax

Boolean	lbError, lbDetailError, lbSQLCAauto
DateTime	ldtToday
Decimal	ldWeight, ldLineItemNo_c, ldOwnerID

Decimal ldCCNO

String 	lsOrderNo
string 	lsSKU2, lsGPN, lsTemp2
//string		lsFromProject, lsToProject

string		lsWH_Hold, lsOwnerCd, lsOwnerCd_Hold, lsOwnerID, lsABC, lsABC_Hold, lsInClause, lsSequence, lsProject, lsFind
long		llNewRow_Interface, llRowCountInterface, llNewRow_GenericField
boolean	lbNoInventory

String lsAllocFlg, lsSkuPrevious
Decimal ldAllocQty
long ll_cnt
long llcoocount

lsLogOut = '          - PROCESSING FUNCTION - Create Cycle Count Order. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

SetPointer(Hourglass!)

ldtToday = DateTime(Today(),Now())

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

// 6/13 - this was in uf_create_cc_order...
ids_si = f_datastoreFactory( 'd_cc_inventory')

If Not isvalid(ldsCCInterface) Then
	ldsCCInterface = Create u_ds_datastore
	ldsCCInterface.dataobject= 'd_pandora_cc_interface'
End If
//??ldsCCInterface.SetTransObject(SQLCA)

If Not isvalid(ldsCCMaster) Then
	ldsCCMaster = Create u_ds_datastore
	ldsCCMaster.dataobject= 'd_cc_master'
End If
ldsCCMaster.SetTransObject(SQLCA)

If Not isvalid(ldsCCInventory) Then
	ldsCCInventory = Create u_ds_datastore
	ldsCCInventory.dataobject= 'd_cc_inventory'
End If
ldsCCInventory.SetTransObject(SQLCA)

If Not isvalid(ldsCCGenericField) Then
	ldsCCGenericField = Create u_ds_datastore
	ldsCCGenericField.dataobject= 'd_cc_generic_field'
End If
ldsCCGenericField.SetTransObject(SQLCA)

ldsCCMaster.Reset()
ldsCCInventory.Reset()

//Open and read the File In
lsLogOut = '      - Opening File for PANDORA Cycle Count Processing: ' + asPath
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
	lu_ds.SetItem(llNewRow, 'rec_data', Trim(lsStringData)) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Process Each Record in the file..
llRowCount = lu_ds.RowCount()

lsWH_Hold = ''
//TODO- Assuming a single order per file, header followed by detail.  All detail lines are associated with the same order.  We may break it into multiple orders by ABC Class
//Loading first into d_pandora_cc_interface and then scrolling through that and creating the cycle count order(s)/lines
For llRowPos = 1 to llRowCount
	lsRecData = Trim(lu_ds.GetItemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData, 3) /* rec type should be first 3 char of file*/	
	
	Choose Case Upper(lsRecType)
		//Case 'CC' /* CC Header  */
		Case 'MEN' /* CC Header  */
			//tempo - will the order no be separate from the type (and will the type be 'CC' or 'MEM'?)?
			lsRecData = Right(lsRecData,(len(lsRecData) - 4)) /*strip off to first column after rec type */
			//lsRecData = Right(lsRecData,(len(lsRecData) - 2)) /*strip off to first column after rec type *** actually, looks like order is immediately following the 'CC' */
		
//  Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - ' Data expected after Order Number'. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			If lsTemp > '' Then


				//TAM 2016/08/11  -  We now want to reject duplicate Cycle Counts.  Duplicates are identified by User_Field1(Order Number).
				Select distinct(User_field1) into :lsOrderNo
				From CC_Master
				Where Project_id = :asProject	and User_Field1 = :lstemp;
				if lsOrderNo = lsTemp then 
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Duplicate Cycle Count Order Number(" + lsTemp + ").  Record will not be processed.")
					lbError = True
					Continue /*Process Next Record */
				end if
			
				lsOrderNo = lsTemp
				//GailM 07/12/2017 SIMSPEVS-727 PAN SIMS Blind Count - User_field1 no longer needed
				//ldsCCMaster.SetItem(llNewRow, 'User_Field1', lsOrderNo) //TODO - Using UF1 for now. Some WH's use this already so may need dedicated field
			end if
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
// Inventory Org Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Number' field. Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			End If
			If lsTemp > '' Then
//x				ldsCCMaster.SetItem(llNewRow, 'User_Field2', lsTemp) //TODO - Using UF2 for now. Some WH's use this already so need dedicated field
			end if
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
// Transaction Date *Not used(?)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				//gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Org Code' field. Record will not be processed.")
				//lbError = True
				//Continue /*Process Next Record */
				lsTemp = lsRecData
			End If
			//If lsTemp > '' Then
			//	ldsCCMaster.SetItem(llNewRow, 'ord_date', lsTemp) 
			//end if
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
		CASE 'AVI' /* detail - TODO - is it really going to be 'AVI'???*/
			// grab the sequence (2nd field in record)
			i = 1
			liStart = 1
			do while i < 2 // and liStart > 0
				liStart = pos(lsRecData, '|', liStart) + 1
				i += 1
			loop
			liEnd = pos(lsRecData, '|', liStart)
			lsSequence = Mid(lsRecData, liStart, liEnd - liStart)
			if lsSequence = '' or isnull(lsSequence) then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Sequence is Required! Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			end if
			// grab the SKU/Owner/Project from pandora file and find all inventory records that match...
			//Owner: 3rd field in Detail record
			//SKU: 4th field in Detail record
			//ABC Class: 7th field in Detail record
			//Project: 15th field in Detail record
			i = 1
			liStart = 1
			do while i < 3
				liStart = pos(lsRecData, '|', liStart) + 1
				i += 1
			loop
			liEnd = pos(lsRecData, '|', liStart)
			lsOwnerCd = Mid(lsRecData, liStart, liEnd - liStart)
			if lsOwnerCd = '' or isnull(lsOwnerCd) then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Owner Cd is Required! Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			end if
			// Get SKU from data...
			i += 1 //increment field counter
			liStart = liEnd + 1 //?? will this be + 2 (for the '|')?
			liEnd = pos(lsRecData, '|', liStart)
			lsSKU = Mid(lsRecData, liStart, liEnd - liStart)
			if lsSKU = '' or isnull(lsSKU) then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - SKU is Required! Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			end if
			// Get ABC Class from data...
			do while i < 7
				liStart = pos(lsRecData, '|', liStart) + 1
				i += 1
			loop
			liEnd = pos(lsRecData, '|', liStart)
			lsABC = Mid(lsRecData, liStart, liEnd - liStart)
			if lsABC = '' or isnull(lsABC) then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - ABC Class is Required! Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			end if
			// Get Project from data...
			do while i < 15
				liStart = pos(lsRecData, '|', liStart) + 1
				i += 1
			loop
			liEnd = pos(lsRecData, '|', liStart)
			if liEnd > 0 then
				lsProject = Mid(lsRecData, liStart, liEnd - liStart)
			else
				lsProject = Mid(lsRecData, liStart)
			end if
			if lsProject = '' or isnull(lsProject) then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Project is Required! Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			end if

			//Look up warehouse and make sure it's not different than any previous detail lines...
			select user_field2 into :lsWH
			from customer
			where project_id = :asProject and cust_code = :lsOwnerCD;
			if lsWH = '' or isnull(lsWH) then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No Warehouse identified for owner: " + lsOwnerCd + "! Record will not be processed.")
				lbError = True
				Continue /*Process Next Record */
			end if
			if lsWH_Hold = '' then
				lsWH_Hold = lsWH
				// setting ord_date to local wh time
				ldtWHTime = f_getLocalWorldTime(lsWH)
				//Multiple Header Records (ABC Class)?
				//ldsCCMaster.SetItem(llNewRow, 'ord_date', ldtWHTime) // this is setting in CC_Master so ord_date is actually a date/time (and not char)
			elseif lsWH <> lsWH_Hold then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Only one Warehouse allowed per file! Record will not be processed.")
				lbError = True
				Continue /*Process Next Record  ? should we abort the whole file here?*/
			end if
//x			// - Need to Create/Set multiple header records (if more than one ABC Class)
//x			ldsCCMaster.SetItem(llNewRow, 'wh_code', lsWH)  /*  */	
			
			//look up OwnerID (if changed)...
			if lsOwnerCd <> lsOwnerCd_Hold then
				select owner_id into :ldOwnerID
				from owner
				where project_id = :asProject and owner_cd = :lsOwnerCd;
				lsOwnerId = string(ldOwnerID)
				lsOwnerCd_Hold = lsOwnerCD
			end if

			llNewRow_Interface = ldsCCInterface.InsertRow(0)
			llLineSeq ++
			ldsCCInterface.SetItem(llNewRow_Interface, 'sequence', lsSequence)
			ldsCCInterface.SetItem(llNewRow_Interface, 'order_no', lsOrderNo)
			ldsCCInterface.SetItem(llNewRow_Interface, 'wh_code', lsWH)
			ldsCCInterface.SetItem(llNewRow_Interface, 'owner_cd', lsOwnerCD)
			ldsCCInterface.SetItem(llNewRow_Interface, 'owner_id', ldOwnerID)
			ldsCCInterface.SetItem(llNewRow_Interface, 'GPN', lsSKU)
			ldsCCInterface.SetItem(llNewRow_Interface, 'ABC_Class', lsABC)
			ldsCCInterface.SetItem(llNewRow_Interface, 'project_cd', lsProject)
			
			ldsCCInterface.SetItem(llNewRow_Interface, 'alloc_flg', 'N')		//Initialize alloc_flg to No
			

//TAM 2017/05 - SIMSPEVS-420 We now need see if the row being requested has "allocated" inventory for that GPN.  If there is allocated inventory then we will create a separate CC for this GPN below. 
// We will not be creating System Inventory for these rows.

//GailM 07/12/2017 PAN SIMS Blind Count - Code is not needed now.  See loop below	
//			If  ib_filter_allocated = True Then 
//			  	SELECT sum(dbo.content_summary.alloc_qty) 
//			  	INTO :ldAllocQty  
//			   	FROM dbo.content_summary  
//			   	WHERE ( dbo.content_summary.project_id = 'PANDORA' ) AND  
//		     	    	( dbo.content_summary.wh_code = :lswh ) AND  
//		     	    	( dbo.content_summary.sku = :lssku ) AND  
//		     	    	( dbo.content_summary.Owner_Id = :ldOwnerId ) AND  
//		      	   	( dbo.content_summary.po_no = :lsProject ) AND  
// 		      	 	( dbo.content_summary.alloc_qty > 0 )   ;
//				If ldAllocQty > 0 Then 
//					ldsCCInterface.SetItem(llNewRow_Interface, 'alloc_flg', 'Y' )
//				Else	
////TAM 207/07/03 - PEVS-420 - We need to filter out inventory locked by another cycle count as well
//				  	long llcoocount
//					SELECT count(dbo.content_summary.country_of_origin)
//		  			INTO :llcoocount  
//		   			FROM dbo.content_summary  
//		   			WHERE ( dbo.content_summary.project_id = 'PANDORA' ) AND  
//		       	  	( dbo.content_summary.wh_code = :lswh ) AND  
//		      	   	( dbo.content_summary.sku = :lssku ) AND  
//		      	   	( dbo.content_summary.Owner_Id = :ldOwnerId ) AND  
//		      	   	( dbo.content_summary.po_no = :lsProject ) AND  
// 		      	 	( dbo.content_summary.country_of_origin like ('CC%' ))   ;
//					If llcoocount > 0 Then 
//						ldsCCInterface.SetItem(llNewRow_Interface, 'alloc_flg', 'Y' )
//					Else	
//						ldsCCInterface.SetItem(llNewRow_Interface, 'alloc_flg', 'N' )
//					End If	
//				End if
//			Else 
//				ldsCCInterface.SetItem(llNewRow_Interface, 'alloc_flg', 'N' )
//			End If

		Case Else /* Invalid Rec Type*/
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
			Continue
	End Choose /*record Type*/
Next /*File record */
//above here, load d_pandora_cc_interface datastore
//below here, scroll through datastore and use generate logic from w_cc to generate all of the cycle count records 

		//TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off	
			select count(Code_Type) into :ll_cnt from Lookup_Table
			where project_id = :asProject and code_type = 'FILTER_ALLOCATED' and code_id = :lswh;
			if ll_cnt > 0 then
				ib_Filter_Allocated = TRUE
			Else
				ib_Filter_Allocated = FALSE
			end if	

// ****** IF filter allocated flag turned on
//GailM 07/12/2017 PAN SIMS Blind Count - Mark all alloc SKU records as alloc
If  ib_filter_allocated = True Then 
	ldsCCInterface.SetSort("GPN A")
	ldsCCInterface.sort()
	llRowCountInterface = ldsCCInterface.RowCount()
	lsSkuPrevious = "" 	/* Initialize Previous SKU */
	
	For llRowPos = 1 to llRowCountInterface
		lsSKU = ldsCCInterface.GetItemString(llRowPos, 'GPN')
		If lsSKU <> lsSkuPrevious Then
			SELECT sum(dbo.content_summary.alloc_qty)
			INTO :ll_cnt  
			FROM dbo.content_summary  
			WHERE ( dbo.content_summary.project_id = 'PANDORA' ) AND  
						( dbo.content_summary.wh_code = :lswh ) AND  
						( dbo.content_summary.sku = :lssku ) ;
			If ll_cnt > 0 Then
				lsAllocFlg = 'Y'
			Else			//Test for cycle count for this sku
				SELECT count(dbo.content_summary.country_of_origin)
				INTO :llcoocount  
				FROM dbo.content_summary  
				WHERE ( dbo.content_summary.project_id = 'PANDORA' ) AND  
						( dbo.content_summary.wh_code = :lswh ) AND  
						( dbo.content_summary.sku = :lssku ) AND  
						( dbo.content_summary.country_of_origin like ('CC%' ))   ;
				If llcoocount > 0 Then 
					lsAllocFlg = 'Y'
				Else	
					lsAllocFlg = 'N'
				End If	
			End If
		End If
		ldsCCInterface.SetItem(llRowPos, 'alloc_flg', lsAllocFlg)
		lsSkuPrevious = lsSKU
	next  /* End of Blind Count loop */
End If	
// ****** End of filter allocated flag turned on

//TAM 2017/05 - SIMSPEVS-420 Filter out allocated
ldsCCInterface.SetFilter("alloc_flg = 'N'")
ldsCCInterface.Filter()

//Process Each Record in d_pandora_cc_interface...
// - create the CC_Master record and then string together the 'IN' clause for the SKU + Owner condition
//   at each change in ABC Class, call the function to create the cycle count order.
llRowCountInterface = ldsCCInterface.RowCount()

ldsCCInterface.SetSort("ABC_Class A, Order_No A")
ldsCCInterface.sort()

For llRowPos = 1 to llRowCountInterface
	lsABC = ldsCCInterface.GetItemString(llRowPos, 'ABC_Class')
	lsSequence = ldsCCInterface.GetItemString(llRowPos, 'sequence')
	if lsABC <> lsABC_Hold then //TODO - if there is more than one order, will need to accommodate that here (use concatenation of Order and ABC class)
		if lsABC_Hold > '' then
			//this isn't the first order so call uf_create_cc_order with the previous order
			//i = uf_create_cc_order(lsCCNO, lsOrderNo, lswh, lsInClause, lsSequence)
			i = uf_create_cc_order(lsCCNO, lsOrderNo, lswh, lsInClause)
			if i = -1 then lbError = true
		end if

		//insert header record
		lsABC_Hold = lsABC
		llNewRow=ldsCCMaster.InsertRow(0)
		llOrderSeq ++
		llLineSeq = 0
		
		sqlca.sp_next_avail_seq_no(asproject, "CC_Master", "CC_No" , ldCCNO) //get the next available CC_NO
		If ldCCNO <= 0 Then Return -1
	
		lsCCNO = asProject + String(Long(ldCCNo),"000000") 
// 6/7 - set these later, after call to create_cc_order?
		ldsCCMaster.SetItem(llNewRow, 'cc_no', lsCCNo)
		ldsCCMaster.SetItem(llNewRow, 'project_id', asProject)
		ldsCCMaster.SetItem(llNewRow, 'last_update', Today())
		ldsCCMaster.SetItem(llNewRow, 'last_user', 'SIMSFP')
		ldsCCMaster.SetItem(llNewRow, 'Ord_type', 'P')  /* TODO - 'P' for Pandora-directed. What should it be? */
		ldsCCMaster.SetItem(llNewRow, 'Ord_Status', 'P') // we're generating the cycle count, so set it to 'Process'
		//ldsCCMaster.SetItem(llNewRow, 'Ord_Date', ldtToday)  //-  now setting to local wh time
		// should still be set... lsWH = ldsCCInterface.GetItemString(llRowPos, 'wh_code')
		ldsCCMaster.SetItem(llNewRow, 'wh_code', lsWH)  /*  */	
		//set above... ldtWHTime = f_getLocalWorldTime(lsWH)
		ldsCCMaster.SetItem(llNewRow, 'ord_date', ldtWHTime) // this is setting in CC_Master so ord_date is actually a date/time (and not char)
		ldsCCMaster.SetItem(llNewRow, 'User_Field1', lsOrderNo) //TODO - Using UF1 for now. Some WH's use this already so may need dedicated field
		ldsCCMaster.SetItem(llNewRow, 'Class', lsABC) //TODO - Using UF1 for now. Some WH's use this already so may need dedicated field
	end if // new CC Order (new ABC Class)
	ldsCCInterface.SetItem(llRowPos, 'cc_no', lsCCNO) //used later to add missing cycle count request rows (where we have no inventory)

	lbDetailError = False
	llNewDetailRow = 	ldsCCInventory.InsertRow(0)
	llLineSeq ++

	//Add detail level defaults
// 6/7 - set these later, after call to create_cc_order?
//	ldsCCInventory.SetItem(llNewDetailRow, 'CC_NO', lsCCNO) 
//	ldsCCInventory.SetItem(llNewDetailRow, 'Inventory_Type', 'N') 
//	ldsCCInventory.SetItem(llNewDetailRow,'Supp_Code', 'PANDORA') 
//	ldsCCInventory.SetItem(llNewDetailRow,'Country_of_origin', 'XXX') 
//	ldsCCInventory.SetItem(llNewDetailRow,'Serial_No', '-') 
//	ldsCCInventory.SetItem(llNewDetailRow,'Lot_No', '-') 
//	ldsCCInventory.SetItem(llNewDetailRow,'Po_No2', '-') 
//	ldsCCInventory.SetItem(llNewDetailRow,'Container_Id', '-') 
//	ldsCCInventory.SetItem(llNewDetailRow,'Expiration_Date', '2999/12/31') 
//	ldsCCInventory.SetItem(llNewDetailRow, 's_location', '*')  /*  */	
//	ldsCCInventory.SetItem(llNewDetailRow, 'd_location', '*')  /*  */	
		
//SKU
	lsSKU = ldsCCInterface.GetItemString(llRowPos, 'GPN')
	/* may use to build itemmaster record 
	Need to check SKU in Item_Master and, if it's not there, check MFG SKU Look-up */
	Select distinct(SKU) into :lsSKU2
	From Item_Master
	Where Project_id = :asProject
	and SKU = :lsSKU;
	if lsSKU2 = '' then 
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Missing Pandora SKU...") 
	end if
//6/7	ldsCCInventory.SetItem(llNewDetailRow, 'SKU', lsSKU)
//Owner
	lsOwnerID = string(ldsCCInterface.GetItemNumber(llRowPos, 'Owner_ID'))
	lsProject = ldsCCInterface.GetItemString(llRowPos, 'project_cd')
	//Build 'In' clause to pass to uf_create_cc_order where it will find content records for the SKU/Owner combo
	//adding po_no (project) to InClause
	if llLineSeq = 1 then
		lsInClause = "'" + lsSKU + lsOwnerID + lsProject + "'"
	else
		lsInClause += ", '" + lsSKU + lsOwnerID + lsProject + "'"
	end if
/*
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//Line Number
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
			End If
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

//Qty
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
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
*/
next //next Record in d_pandora_cc_interface...

/* TEMP - 6/10 - need to get sequence #s in the cc_inventory table
 - Maybe set them after the call to uf_create_cc_order 
 ?Scroll thru ldsCCInventory, grabbing distinct SKU/Owner/Project combos...
 ?update cc_inventory set sequence = <lsSequence> where cc_no = xx and sku = yy and owner_cd = aa and po_no = zz */
if lsABC_Hold > '' then
	//call uf_create_cc_order with the last (or maybe only) order
	//i = uf_create_cc_order(lsCCNO, lsOrderNo, lswh, lsInClause, lsSequence)
	i = uf_create_cc_order(lsCCNO, lsOrderNo, lswh, lsInClause)
	if i = -1 then lbError = true
end if
//Scroll thru ?[ldsCCInterface = 'd_pandora_cc_interface'] or [ldsCCInventory.dataobject= 'd_cc_inventory']... and set sequence for all records in ids_si that match

For llRowPos = 1 to llRowCountInterface
	//Need to set Sequence, plus add Cycle Count Request rows for which SIMS doesn't have inventory...
//8/5/10!!  Need to add rows for Allocated inventory with a location of 'Allocated'!!!  If there is no inventory in locations or allocated, then add the 'No_Count' row.

	lsSequence = ldsCCInterface.GetItemString(llRowPos, 'sequence')
	lsSku = ldsCCInterface.GetItemString(llRowPos, 'gpn')
	ldOwnerID = ldsCCInterface.GetItemNumber(llRowPos, 'Owner_ID')
	lsOwnerID = string(ldOwnerID)
	lsProject = ldsCCInterface.GetItemString(llRowPos, 'Project_cd')
	//set find based on sku/owner/project
	lsFind = "sku = '" + lsSku +"' and owner_id = " + lsOwnerID + " and po_no = '" + lsProject + "'"
	//find row(s) in ids_si (System Inventory)
	llFindRow = 1
	lbNoInventory = True
	do while llFindRow > 0
		llFindRow = ids_si.Find(lsFind, llFindRow, ids_si.RowCount() + 1)
		//set in ids_si
		If llFindRow > 0 Then
			ids_si.SetItem(llFindRow, 'sequence', lsSequence) 
			llFindRow ++
			lbNoInventory = False
		End If
	loop
	if lbNoInventory then
		//add a row in cycle count for this row in the file from Pandora
			i = ids_si.Insertrow(0)
			lsCCNO = ldsCCInterface.GetItemString(llRowPos, 'cc_no')
			ids_si.object.line_item_no[ i ] = i
			ids_si.setitem(i, "cc_no", lsCCNO)
			ids_si.SetItem(i, "sku", lsSKU)
			ids_si.SetItem(i, "sequence", lsSequence)
			ids_si.SetItem(i, "supp_code", 'PANDORA')
			ids_si.SetItem(i, "owner_id", ldOwnerID)
//TAM 2016/11/25 -  Inventory type "-" is not valid.  Changing to "*" which is valid
//			ids_si.SetItem(i, "inventory_type", '-')
			ids_si.SetItem(i, "inventory_type", '*')
			ids_si.SetItem(i, "serial_no", '-')
			ids_si.SetItem(i, "lot_no", '-')
			ids_si.SetItem(i, "po_no", lsProject)
			ids_si.SetItem(i, "po_no2", '-')
			//ids_si.SetItem(i, "container_id", '-')
			//ids_si.SetItem(i, "expiration_date", ldt_expiration_date)
			ids_si.SetItem(i, "country_of_origin", '-')
			ids_si.setitem(i, "quantity", 0)
			ids_si.SetItem(i, "l_code", 'No_Count')
			//ids_si.SetItem(i, "ro_no", ls_ro_no)
			//ids_si.SetItem(i, "alternate_sku", ls_alternate_sku)	
	end if
next //next row in data from file


//TAM 2017/05 - SIMSPEVS-420 We now need see if the row being requested has "allocated" inventory for that GPN.  
//If there is allocated inventory then we will create a separate CC for this GPN below.
// We will not be creating System Inventory for these rows.

//TAM 2017/05 - SIMSPEVS-420 Filter allocated
ldsCCInterface.SetFilter("alloc_flg = 'Y'")
ldsCCInterface.Filter()
llRowCountInterface = ldsCCInterface.RowCount()

ldsCCInterface.SetSort("GPN A")
ldsCCInterface.sort()
lsSkuPrevious = "" 	/* Initialize Previous SKU */

For llRowPos = 1 to llRowCountInterface
	lsABC = ldsCCInterface.GetItemString(llRowPos, 'ABC_Class')
	lsSku = ldsCCInterface.GetItemString(llRowPos, 'gpn')
	lsSequence = ldsCCInterface.GetItemString(llRowPos, 'Sequence')
	ldOwnerID = ldsCCInterface.GetItemNumber(llRowPos, 'Owner_ID')
	lsOwnerID = string(ldOwnerID)
	lsProject = ldsCCInterface.GetItemString(llRowPos, 'Project_cd')
	
	If 	lsSkuPrevious <> lsSku Then //Only create one Allocated CC per SKU
	
//		i = uf_create_cc_order(lsCCNO, lsOrderNo, lswh, lsInClause)
//		if i = -1 then lbError = true

		//insert header record
		llNewRow=ldsCCMaster.InsertRow(0)
		sqlca.sp_next_avail_seq_no(asproject, "CC_Master", "CC_No" , ldCCNO) //get the next available CC_NO
		If ldCCNO <= 0 Then Return -1
	
		lsCCNO = asProject + String(Long(ldCCNo),"000000") 
		ldsCCMaster.SetItem(llNewRow, 'cc_no', lsCCNo)
		ldsCCMaster.SetItem(llNewRow, 'project_id', asProject)
		ldsCCMaster.SetItem(llNewRow, 'last_update', Today())
		ldsCCMaster.SetItem(llNewRow, 'last_user', 'SIMSFP')
		ldsCCMaster.SetItem(llNewRow, 'Ord_type', 'P')  /* TODO - 'P' for Pandora-directed. What should it be? */
		ldsCCMaster.SetItem(llNewRow, 'Ord_Status', 'A') //  so set these status to allocated on hold
		ldsCCMaster.SetItem(llNewRow, 'wh_code', lsWH)  /*  */	
		ldsCCMaster.SetItem(llNewRow, 'ord_date', ldtWHTime) // this is setting in CC_Master so ord_date is actually a date/time (and not char)
		ldsCCMaster.SetItem(llNewRow, 'User_Field1', lsOrderNo) //TODO - Using UF1 for now. Some WH's use this already so may need dedicated field
		ldsCCMaster.SetItem(llNewRow, 'Class', lsABC) 
		ldsCCMaster.SetItem(llNewRow, 'Range_Start', lsSku) 
		ldsCCMaster.SetItem(llNewRow, 'Range_End', lsSku) 
		//ldsCCMaster.SetItem(llNewRow, 'User_Field4', lsSequence) //Sequence no longer needed on header - GailM 07/12/2017 SIMSPEVS-727 PAN SIMS Blind Count
		//ldsCCMaster.SetItem(llNewRow, 'Owner_Id', ldOwnerID) //Owner_Id  no longer needed on header - GailM 07/12/2017 SIMSPEVS-727 PAN SIMS Blind Count
		//ldsCCMaster.SetItem(llNewRow, 'User_Field5', lsproject) //Project  no longer needed on header - GailM 07/12/2017 SIMSPEVS-727 PAN SIMS Blind Count
		lsSkuPrevious = lsSku //Only create one CC per SKU
	End If

	//GailM 07/12/2017 PAN SIMS Blind Count - Add allocated rows to cc_generic_field
	// Record will be put into cc_generic_field table for further processing
	llNewRow_GenericField = ldsCCGenericField.InsertRow(0)
	ldsCCGenericField.SetItem(llNewRow_GenericField, 'cc_no',lsCCNo)
	ldsCCGenericField.SetItem(llNewRow_GenericField, 'Sequence',lsSequence)
	ldsCCGenericField.SetItem(llNewRow_GenericField, 'project',lsProject)
	ldsCCGenericField.SetItem(llNewRow_GenericField, 'owner_id',lsOwnerID)

next //next row in data from file

 //TimA 01/17/13 Pandora issue #501
//Varables are called in function uf_sendemailnotification
asownercd = lsOwnerCd
asorderno = lsOrderNo

//Save the Changes
//todo - setting lbError on return from uf_create_cc_order if any SKU already in cycle count.  
// - May need to allow some orders (order/ABC_Class) to be created while rejecting the order with the previous Cycle Count.
If lbError Then 
	rollback; //dts 5/5/11 - added roll back.
	Return -1
Else
	f_method_trace_special( asproject, this.ClassName() + ' - u_nvo_proc_pandora2 - uf_process_cc', 'Start Save ldsCCMaster, ids_si, uf_update_content and ldsCCGenericField ' ,lsCCNo, '','','')																
	lirc = ldsCCMaster.Update()
	If liRC = 1 Then
//		liRC = ldsCCInventory.Update()
		lirc = ids_si.update()
		If liRC = 1 Then
			lirc = uf_update_content(lsWH)
		end if
		If liRC = 1 Then
			liRC = ldsCCGenericField.Update()
				String lsRC = String(liRC)
							f_method_trace_special( asproject, this.ClassName() + ' - u_nvo_proc_pandora2 - uf_process_cc', 'Update ldsCCGenericField, liRC returns: ' + lsRC ,lsCCNo, '','','')																

			If SQLCA.SQLCode = -1 Then
				//TimA 12/05/11 Putting a lot of log entries trying to capture auto SOC problem - Note this should be only temporary
				//f_method_trace( asproject, this.ClassName() + ' - uf_process_to_rose', 'SQL System Error Occured' ,ls_method_trace, isFileName)
				//TimA 03/04/13 Added new/modified method trace logic
				f_method_trace_special( asproject, this.ClassName() + ' - u_nvo_proc_pandora2 - uf_process_cc', 'SQL System Error Occured' ,lsCCNo, '','','')																
						
				lsLogOut = '      - SQL System Error Occured: '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
				FileWrite(giLogFileNo,lsLogOut + "  " + SQLCA.SqlerrText)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/			
				gu_nvo_process_files.uf_writeError("- ***System  Error!:   "+SQLCA.SqlerrText)  // ujhTODO  Get further requirements def.   "Some Database problem--likely only the type that will happen during development."
				Return -1
			End If
		End If
	End If
End If
	
If liRC = 1 then
	 Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Cycle Count Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new cycle count Records to database!")
	Return -1
End If

Return 0

end function

protected function boolean f_file_load (string as_project, string as_path, string as_inifile, string as_type);
boolean lb_goodimport, lbSQLCAauto
string ls_logstring, ls_filename, ls_fullfilename, ls_record, ls_field, ls_ggg_mim, ls_boxno
long ll_fileid, ll_pos, ll_fieldnum, ll_Records
integer liSlash
nvo_diskerase_gggmim lnvo_simsgggrecord
long llNewSerialRecs, llBoxCount

String lsBoxNumberCompare, lsType, lsDisposition, lsBoxNo,lsUser_Updateable_Ind,lsSerialNo,lsOwner
Datetime ldFileDate

//Check the lookup table to see if this process has been turned on
SELECT 	User_Updateable_Ind 	INTO :lsUser_Updateable_Ind FROM Lookup_Table   
Where 	project_id = :as_project and Code_type = 'DISKERASE' and Code_ID = 'LOAD_HISTORY_TABLE';

If lsUser_Updateable_Ind = 'N' or IsNull(lsUser_Updateable_Ind) then
	Return True
End If

Long llCounter, llCounterLoop
// Update the Sweeper logfile and console.
ls_logstring = '               - Saving files to DiskErase_File_Load_History for type ' + as_type + "  "  + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,ls_logstring) // Log file
gu_nvo_process_files.uf_write_log(ls_logstring) // Screen
			
// The file name is the passed path.
ls_filename = as_path

// Construct the full file name and archive file name.
ls_fullfilename = ls_filename

//Strip the path from the file name:
liSlash = pos(ls_FileName, "\")
do while liSlash > 0
	ls_FileName = right(ls_FileName, len(ls_FileName) - liSlash)
	liSlash = pos(ls_FileName, "\")
loop

// Open the import file
ll_fileid = fileopen(ls_fullfilename, linemode!, read!, lockreadwrite!)

// If we have a valid file,
If ll_fileid > 0 then
	
	// Set lb_goodimport to true
	lb_goodimport = true

	// Read the first line. (headers)
	fileread(ll_fileid, ls_record)
		
	ldFileDate	= DateTime(today(),Now())
	// Loop through all the records.
	Do While fileread(ll_fileid, ls_record) > 0
		ll_Records++
		ll_pos = 1
		ll_fieldnum = 0
		
		// Loop through and parse the record fields.
		Choose Case as_Type
			Case 'BOX'
				llBoxCount++
				Do while f_getnextfield(ls_record, "|", ll_pos, ls_field)
					// Trim up the data.
					ls_field = trim(ls_field)
						// Incriment the field number
					ll_fieldnum++
					Choose Case ll_fieldnum
						Case 1
							lsBoxNo = ls_Field
						Case 4
							lsSerialNo = ls_field
					End Choose
				Loop
					// Populate the record Box Number
					If lsBoxNumberCompare <> lsBoxNo then
						lsBoxNumberCompare = lsBoxNo						
						ls_boxno = ls_field

						//TimA 05/14/14 Turn the AutoCommit to true so that we capture the insert. 
						//Sometimes these are Rollback for unknown reasons.
						 lbSQLCAauto = SQLCA.AutoCommit
						SQLCA.AutoCommit = true  

						Insert into DiskErase_File_Load_History (Filename, Boxno, File_Type,File_Date)
						Values (:ls_filename, :lsBoxNo,:as_type, :ldFileDate)
						Using SQLCA;

						SQLCA.AutoCommit = lbSQLCAauto
  
						If SQLCA.SQLCode <> 0 Then
							ls_logstring = '      - SQL System Error Occured: Unable to insert BOX Data into DiskErase_File_Load_History for File ' + ls_filename + ' Box Number ' + lsBoxNo + '  ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
							FileWrite(giLogFileNo,ls_logstring + "  " + SQLCA.SqlerrText)
							gu_nvo_process_files.uf_write_log(ls_logstring) /*write to Screen*/			
							gu_nvo_process_files.uf_writeError("- ***System  Error!:   " + SQLCA.SqlerrText)  
							lb_goodimport = False
						Else
							//Can't do a count of boxes here because we insert the first box and our count would be 1.
							//It skips over the other boxes until it fines the next one.
							ls_logstring = '               - '  + 'Inserting records for box ' + lsBoxNo +  ' - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
							FileWrite(giLogFileNo,ls_logstring) // Log file
							gu_nvo_process_files.uf_write_log(ls_logstring) // Screen

						End if
						//Inset into new table
					End if
			Case 'DCM'

				Do while f_getnextfield(ls_record, ",", ll_pos, ls_field)
					// Trim up the data.
					ls_field = trim(ls_field)
					// Incriment the field number
					ll_fieldnum++
					//disposition
					Choose Case ll_fieldnum
						Case 1
							lsBoxNo = ls_Field
						Case 2
							lsOwner = ls_field
						Case 3
							lsDisposition = ls_field
					End Choose
				Loop
					// Populate the record Box Number
					If lsBoxNumberCompare <> lsBoxNo then
						lsBoxNumberCompare = lsBoxNo						
						ls_boxno = ls_field
						//Inset into new table
						//TimA 05/13/14 adding logic to see it we can trap the reason why the Load history table is not being updated.
						If Len(ls_filename ) = 0 then
							ls_logstring = '      - Possible Error.  The ls_Filename is null or blank and can not be updated in the DiskErase_File_Load_History table '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
							FileWrite(giLogFileNo,ls_logstring )
							gu_nvo_process_files.uf_write_log(ls_logstring) /*write to Screen*/			
							gu_nvo_process_files.uf_writeError("- ***Process  Error!:   " + ls_logstring )  
						End if

						//TimA 05/13/14 adding logic to see it we can trap the reason why the Load history table is not being updated.
						If Len(lsBoxNo ) = 0 then
							ls_logstring = '      - Possible Error.  The lsBoxNo is null or blank and can not be updated in the DiskErase_File_Load_History table '  + String(Today(), "mm/dd/yyyy hh:mm:ss")
							FileWrite(giLogFileNo,ls_logstring )
							gu_nvo_process_files.uf_write_log(ls_logstring) /*write to Screen*/			
							gu_nvo_process_files.uf_writeError("- ***Process  Error!:   " + ls_logstring )  
						End if

						//TimA 05/14/14 Turn the AutoCommit to true so that we capture the insert. 
						//Sometimes these are Rollback for unknown reasons.
						 lbSQLCAauto = SQLCA.AutoCommit
						SQLCA.AutoCommit = true  
						//The Filename  Boxno don't allow nulls
						Insert into DiskErase_File_Load_History (Filename, Boxno, Owner_Cd,File_Type,Disposition, File_Date)
						Values (:ls_filename, :lsBoxNo, :lsOwner, :as_type, :lsDisposition, :ldFileDate)
						Using SQLCA;

						SQLCA.AutoCommit = lbSQLCAauto

						If SQLCA.SQLCode <> 0 Then
							ls_logstring = '      - SQL System Error Occured: Unable to insert DCM Data into DiskErase_File_Load_History for File ' + ls_filename + ' Box Number ' + lsBoxNo + String(Today(), "mm/dd/yyyy hh:mm:ss")
							FileWrite(giLogFileNo,ls_logstring + "  " + SQLCA.SqlerrText)
							gu_nvo_process_files.uf_write_log(ls_logstring) /*write to Screen*/			
							gu_nvo_process_files.uf_writeError("- ***System  Error!:   " + SQLCA.SqlerrText)  
							lb_goodimport = False
						End if								
					End if
		End Choose
	llBoxCount = 0
	// Next Record
	Loop
else
	ls_logstring = '               - Unable to open file ' + ls_fullfilename + " No records save to DiskErase_File_Load_History "  + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(giLogFileNo,ls_logstring ) // Log file
	gu_nvo_process_files.uf_write_log(ls_logstring) // Screen
	
End IF
If ll_Records > 0 then
	ls_logstring = '               - ' + string ( ll_Records ) + ' Records processed for file ' + ls_FileName +  ' - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(giLogFileNo,ls_logstring) // Log file
	gu_nvo_process_files.uf_write_log ( ls_logstring ) // Screen

End if
// Close the file.
fileclose ( ll_fileid )

// Return lb_goodimport
return lb_goodimport	
end function

public function integer uf_create_system_cycle_counts (string asproject, string aswhcode);//10-NOV-2017 :Madhu PEVS-806 - 3PL Cycle Count Orders

//a. If SKU is Serialized and Count All Locations Flag is Enabled -> create new CC for each serialized SKU from Location (Count By Sku)
//b. If SKU is Serialized and Count All Locations Flag is Disabled -> create new CC for against Location Limit (Count By Location).
//c. If SKU is Non-Serialized and Locations Per Count > 0 -> create new CC for against Location Limit (Count By Location).
//d. If SKU is Foot Print -> creare new CC for each Foot Print SKU from Location (Count By Sku)

string lsLogOut, sql_syntax, lsErrors, 	ls_count_All_Locations, ls_cc_No, ls_class_code
string	ls_location_list[], ls_empty_list[], ls_formatted_locations, ls_sku, ls_daily_limit, ls_om_enabled
long 	ll_row, ll_locations_Limit, ll_serialized_count, ll_Non_serialized_count, ll_count, ll_sku_row, ll_rc, ll_eligible_count
long	ll_cc_count, ll_criteria_count, ll_daily_count, ll_remain_count, ll_sku_loc_count, ll_Foot_Print_count
Decimal ldCCNO
DateTime ldtwhTime
Boolean lbCreateNewCC, lbCreateSystemCriteria, lbCountBySku
str_parms ls_sku_list, ls_loc_list, ls_empty_str, ls_sku_parm

Datastore ldsBuildList
n_string_util  ln_string_util
ln_string_util = CREATE n_string_util

SetPointer(Hourglass!)

//write to screen and Log File
lsLogOut = '      - Start Processing Function - 3PL Cycle Count Order - uf_create_system_cycle_counts()  against  wh_code: '+aswhcode+ ' - ' +String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Initialize variables
lbCreateNewCC =FALSE
lbCreateSystemCriteria =FALSE
lbCountBySku = FALSE
ll_count =0

If Not isvalid(ids3PLCC) Then
	ids3PLCC = Create u_ds_datastore
	ids3PLCC.dataobject= 'd_cc_system_criteria'
End If
ids3PLCC.SetTransObject(SQLCA)

If Not isvalid(idsCCMaster) Then
	idsCCMaster = Create u_ds_datastore
	idsCCMaster.dataobject= 'd_cc_master'
End If
idsCCMaster.SetTransObject(SQLCA)

//Is Warehouse -OM Enabled
select OM_Enabled_Ind into :ls_om_enabled 
from Warehouse with(nolock) 
where Wh_code =:aswhcode 
using sqlca;
	
IF upper(ls_om_enabled) <> 'Y' Then
 	lsLogOut = '        3PL Cycle Count Order - processing uf_create_system_cycle_counts()  against  wh_code: '+aswhcode+ ' is not OM Enabled.! No System Cycle Counts will be generated.'
	FileWrite(gilogFileNo,lsLogOut)
   	RETURN -1
End If
	
ldtwhTime = f_getLocalWorldTime(aswhcode) //Warehouse Local Time

//get Daily System generated CC Order Limit
// TAM - 2018/05 - S18503 - Now limiting number of Cycles Counts from the Warehouse 
//get required values from Project Warehouse table.
SELECT CC_count_All_Locs_For_Serialized_Sku,CC_Num_Locs_Per_Count, max_cycle_count
	INTO :ls_count_All_Locations, :ll_locations_Limit, :ll_daily_count
FROM Project_Warehouse with(nolock)  WHERE wh_code= :aswhcode
using SQLCA;

If ll_daily_count = 0 or isNull(ll_daily_count)   then
	ls_daily_limit =f_retrieve_parm(asproject, 'CycleCount','System')
	If IsNumber(ls_daily_limit) Then ll_daily_count =long(ls_daily_limit)
End If


//set default values
If IsNULL(ls_count_All_Locations) Then ls_count_All_Locations ='N'
If IsNull(ll_locations_Limit) Then ll_locations_Limit =0;

//build SQL Query to pull all eligible records for CC.
//TAM 2018/04 -S17607 - Exclude Inventory with Locations = "Research" or "Reconp" or or PoNo = "Research" 
//07-JUNE-2018 :Madhu DE4625 - Create CC Order per Foot Print Item
//TAM 2019/06 -S34780 - Don't include Packaging owners(Owner Codes ending in 'PK') in System generated CC's
ldsBuildList = create Datastore
sql_syntax =	"	SELECT Distinct A.L_Code as L_code, B.CC_Class_Code as CC_Class_Code, count(*) as Serialized_count, 0 as Non_Serialized_count, 0 as Foot_Print_count	"
sql_syntax +=	"	FROM Content A with(nolock)	"
sql_syntax +=	"	INNER JOIN Item_Master B with(nolock) ON A.Project_Id= B.Project_Id	"
sql_syntax +=	"	AND A.SKU = B.SKU and A.Supp_Code = B.Supp_code	"
sql_syntax +=	"	INNER JOIN Owner O with (nolock) on A.Project_Id= O.Project_Id	"
sql_syntax +=	"	AND A.Owner_Id = O.Owner_id "	
sql_syntax +=	"	Where A.Project_Id='"+asproject+"' and A.WH_Code ='"+aswhcode+"'	"
sql_syntax +=	"	AND DATEDIFF(DAY, A.Last_Cycle_Count, GETDATE()) > B.CC_Freq	"
sql_syntax +=	"	AND (A.CC_No ='-' OR  A.CC_No IS NULL)	"
sql_syntax +=	"	AND B.Serialized_Ind <> 'N'	 AND (B.PO_No2_Controlled_Ind <> 'Y' OR B.Container_Tracking_Ind <> 'Y') "
sql_syntax +=	"	AND B.CC_Class_Code in ('A','B','C')	"
sql_syntax +=	"	AND (A.L_code Not Like 'RESEARCH%' and A.L_code Not Like 'RECONP%'  )	"
sql_syntax +=	"	AND A.PO_NO Not Like 'RESEARCH%' 	"
sql_syntax +=	"	AND O.Owner_CD Not Like '%PK' 	"
sql_syntax +=	"	Group By A.L_Code, B.CC_Class_Code	"
sql_syntax +=	"	UNION	"
sql_syntax +=	"	SELECT Distinct A.L_Code as L_code, B.CC_Class_Code as CC_Class_Code, 0 as Serialized_count, count(*) as Non_Serialized_count, 0 as Foot_Print_count	"
sql_syntax +=	"	FROM Content A with(nolock)	"
sql_syntax +=	"	INNER JOIN Item_Master B with(nolock) ON A.Project_Id= B.Project_Id	"
sql_syntax +=	"	AND A.SKU = B.SKU and A.Supp_Code = B.Supp_code	"
sql_syntax +=	"	INNER JOIN Owner O with (nolock) on A.Project_Id= O.Project_Id	"
sql_syntax +=	"	AND A.Owner_Id = O.Owner_id "	
sql_syntax +=	"	Where A.Project_Id='"+asproject+"' and A.WH_Code ='"+aswhcode+"'	"
sql_syntax +=	"	AND DATEDIFF(DAY, A.Last_Cycle_Count, GETDATE()) > B.CC_Freq	"
sql_syntax +=	"	AND (A.CC_No ='-' OR  A.CC_No IS NULL)	"
sql_syntax +=	"	AND B.Serialized_Ind = 'N'	"
sql_syntax +=	"	AND B.CC_Class_Code in ('A','B','C')	"
sql_syntax +=	"	AND (A.L_code Not Like 'RESEARCH%' and A.L_code Not Like 'RECONP%'  )	"
sql_syntax +=	"	AND A.PO_NO Not Like 'RESEARCH%' 	"
sql_syntax +=	"	AND O.Owner_CD Not Like '%PK' 	"
sql_syntax +=	"	Group By A.L_Code, B.CC_Class_Code	"
sql_syntax +=	"	UNION	"
sql_syntax +=	"	SELECT Distinct A.L_Code as L_code, B.CC_Class_Code as CC_Class_Code, 0 as Serialized_count, 0 as Non_Serialized_count, count(*) as Foot_Print_count	"
sql_syntax +=	"	FROM Content A with(nolock)	"
sql_syntax +=	"	INNER JOIN Owner O with (nolock) on A.Project_Id= O.Project_Id	"
sql_syntax +=	"	AND A.Owner_Id = O.Owner_id "	
sql_syntax +=	"	INNER JOIN Item_Master B with(nolock) ON A.Project_Id= B.Project_Id	"
sql_syntax +=	"	AND A.SKU = B.SKU and A.Supp_Code = B.Supp_code	"
sql_syntax +=	"	Where A.Project_Id='"+asproject+"' and A.WH_Code ='"+aswhcode+"'	"
sql_syntax +=	"	AND DATEDIFF(DAY, A.Last_Cycle_Count, GETDATE()) > B.CC_Freq	"
sql_syntax +=	"	AND (A.CC_No ='-' OR  A.CC_No IS NULL)	"
sql_syntax +=	"	AND B.Serialized_Ind = 'B' AND B.PO_No2_Controlled_Ind='Y' AND B.Container_Tracking_Ind='Y'		"
sql_syntax +=	"	AND B.CC_Class_Code in ('A','B','C')	"
sql_syntax +=	"	AND (A.L_code Not Like 'RESEARCH%' and A.L_code Not Like 'RECONP%'  )	"
sql_syntax +=	"	AND A.PO_NO Not Like 'RESEARCH%' 	"
sql_syntax +=	"	AND O.Owner_CD Not Like '%PK' 	"
sql_syntax +=	"	Group By A.L_Code, B.CC_Class_Code	"
sql_syntax +=	"	Order By Foot_Print_count desc, Serialized_count desc, B.CC_Class_Code, A.L_Code	"

ldsBuildList.create( SQLCA.SyntaxFromSql(sql_syntax, "", lsErrors))

IF len(lsErrors) > 0 THEN
 	lsLogOut = "        *** Unable to create datastore for PANDORA 3PL System Cycle Count Orders .~r~r" + lsErrors
	FileWrite(gilogFileNo,lsLogOut)
   	RETURN -1
END IF

ldsBuildList.SetTransObject(SQLCA)
ll_eligible_count = ldsBuildList.retrieve( )

//write to screen and Log File
lsLogOut = '      - Processing Function - 3PL Cycle Count Order - uf_create_system_cycle_counts(). - ' + ' Total Eligible Records: '+string(ll_eligible_count) + ' Per Count Location Limit: '+ string(ll_locations_Limit) + ' Count All Locations for Serialized Sku is Enabled: ' + ls_count_All_Locations
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Process of Foot Print Items - Apply Filter
ldsBuildList.setfilter( " Foot_Print_count > 0")
ldsBuildList.filter( )
ll_Foot_Print_count = ldsBuildList.rowcount( )

ll_remain_count = ll_daily_count //store daily limit into remaining Limit

// (A) build Foot Print Items - Irrespective of Count All Loc Flag
IF ll_Foot_Print_count > 0  Then
	lbCountBySku = TRUE //all serialized Items count By Sku
	
	//write to screen and Log File
	lsLogOut = '      -  Processing Function - 3PL Cycle Count Order - uf_create_system_cycle_counts(). - ' + ' Foot Print Item Count:' +string(ll_serialized_count) + ' - Count All Locations for Foot Print SKU'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	//setting counts against Daily Limit
	If ll_Foot_Print_count >= ll_daily_count Then
		ll_Foot_Print_count = ll_daily_count
		ll_remain_count = 0
	else
		ll_remain_count = ll_daily_count - ll_Foot_Print_count
	End If

	//write to screen and Log File
	lsLogOut = '      -  Processing Function - 3PL Cycle Count Order - uf_create_system_cycle_counts(). - ' + ' Processing Serialized Item Limit Count:' +string(ll_serialized_count) + ' - Count All Locations for Foot Print SKU'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	For ll_row =1 to ll_Foot_Print_count
		ls_location_list[ UpperBound(ls_location_list) + 1 ] = ldsBuildList.getItemString( ll_row, 'L_Code')
		ls_class_code =ldsBuildList.getItemString( ll_row, 'CC_Class_Code')
	Next	
	
	If UpperBound(ls_location_list) > 0 Then 
		ls_formatted_locations = ln_string_util.of_format_string( ls_location_list, n_string_util.FORMAT1 ) //formatted Locations
		ls_sku_list =this.uf_build_cc_sku_list( asproject, aswhcode, ls_formatted_locations) //get all distinct SKU List
		IF ls_sku_list.boolean_arg[1] =TRUE THEN 	Return -1
	End If
	
	//Limit to create CC Order against SKU
	ll_sku_loc_count = UpperBound(ls_sku_list.string_arg)
	
	FOR ll_sku_row =1 to ll_sku_loc_count
		ls_sku_parm.string_arg[1] = ls_sku_list.string_arg[ll_sku_row] //store SKU value into Parm
		ls_sku = ls_sku_list.string_arg[ll_sku_row]
		
		SELECT CC_Class_Code into :ls_class_code FROM Item_Master with(nolock) WHERE Project_Id = :asproject and Sku =:ls_sku USING sqlca;
		
		ls_cc_No = this.uf_get_next_avail_cc_no( asproject) //get Next CC No
		idsCCMaster = this.uf_build_cc_master( ls_cc_No, asproject, aswhcode, ls_class_code ,ldtwhTime, 'Count All Locations for Foot Print SKU ' + ls_sku) //build CC Master Records
		
		If idsCCMaster.rowcount( ) > 0 Then 
			ids3PLCC = this.uf_build_cc_system_criteria( ls_cc_No, 'S', ls_sku_parm) //build System Criteria Records
		else
			Return -1
		End If
	NEXT
	
	//clear list
	ls_location_list[] = ls_empty_list[]
	ls_loc_list.string_arg  = ls_empty_str.string_arg //clear Location List
	ls_sku_list.string_arg = ls_empty_str.string_arg //clear sku List
End IF


//clear filter
ldsBuildList.setfilter( "")
ldsBuildList.filter( )
ldsBuildList.rowcount( )

//Process of Serialized Items - Apply Filter
ldsBuildList.setfilter( " Serialized_count > 0")
ldsBuildList.filter( )
ll_serialized_count = ldsBuildList.rowcount( )

// (B) build Serialized Items - If count All Serilized Ind Locations Flag is Enabled
IF ll_serialized_count > 0 and upper(ls_count_All_Locations) ='Y' Then
	lbCountBySku = TRUE //all serialized Items count By Sku
	
	//write to screen and Log File
	lsLogOut = '      -  Processing Function - 3PL Cycle Count Order - uf_create_system_cycle_counts(). - ' + ' Serialized Item Count:' +string(ll_serialized_count) + ' - Count All Locations for Serialized SKU'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)


 //MEA SEPT-2018 : MEA DE5705 - System generated CC are not dropping for serialized GPN.
 //changed as per Madhu
 
// //setting counts against Daily Limit
//
//If ((ll_remain_count > 0) and (ll_serialized_count > ll_remain_count)) Then
//
//                ll_serialized_count = ll_remain_count
//	              ll_remain_count = 0
 
//setting counts against Daily Limit

If (ll_remain_count > 0) Then
       If (ll_serialized_count > ll_remain_count) Then
                ll_serialized_count = ll_remain_count
                ll_remain_count = 0
	  End If

		//write to screen and Log File
		lsLogOut = '      -  Processing Function - 3PL Cycle Count Order - uf_create_system_cycle_counts(). - ' + ' Processing Serialized Item Limit Count:' +string(ll_serialized_count) + ' - Count All Locations for Serialized SKU'
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
	
		For ll_row =1 to ll_serialized_count
			ls_location_list[ UpperBound(ls_location_list) + 1 ] = ldsBuildList.getItemString( ll_row, 'L_Code')
			ls_class_code =ldsBuildList.getItemString( ll_row, 'CC_Class_Code')
		Next	
		
		If UpperBound(ls_location_list) > 0 Then 
			ls_formatted_locations = ln_string_util.of_format_string( ls_location_list, n_string_util.FORMAT1 ) //formatted Locations
			ls_sku_list =this.uf_build_cc_sku_list( asproject, aswhcode, ls_formatted_locations) //get all distinct SKU List
			IF ls_sku_list.boolean_arg[1] =TRUE THEN 	Return -1
		End If
	
		//Limit to create CC Order against SKU
		ll_sku_loc_count = UpperBound(ls_sku_list.string_arg)
		
		FOR ll_sku_row =1 to ll_sku_loc_count
			ls_sku_parm.string_arg[1] = ls_sku_list.string_arg[ll_sku_row] //store SKU value into Parm
			ls_sku = ls_sku_list.string_arg[ll_sku_row]
			
			SELECT CC_Class_Code into :ls_class_code FROM Item_Master with(nolock) WHERE Project_Id = :asproject and Sku =:ls_sku USING sqlca;
			
			ls_cc_No = this.uf_get_next_avail_cc_no( asproject) //get Next CC No
			idsCCMaster = this.uf_build_cc_master( ls_cc_No, asproject, aswhcode, ls_class_code ,ldtwhTime, 'Count All Locations for Serialized SKU ' + ls_sku) //build CC Master Records
			
			If idsCCMaster.rowcount( ) > 0 Then 
				ids3PLCC = this.uf_build_cc_system_criteria( ls_cc_No, 'S', ls_sku_parm) //build System Criteria Records
			else
				Return -1
			End If
		NEXT
	End If
End IF

// (C) build Serialized /Non-Serialized Items - If count All Serilized Ind Locations Flag is Disabled - then count by Location Limit
IF ll_locations_Limit > 0 Then
	//clear filter
	ldsBuildList.setfilter( "")
	ldsBuildList.filter( )
	ldsBuildList.rowcount( )
	
	//If serialized SKU's already counted, count only Non-Serialized Items.
	If lbCountBySku = TRUE Then
		//Process of Non-Serialized Items - Apply Filter
		ldsBuildList.setfilter( " Non_Serialized_count > 0")
		ldsBuildList.filter( )
		ll_Non_serialized_count = ldsBuildList.rowcount( )
	else
		//If serialized SKU's are NOT counted, count only all Items.
		ll_Non_serialized_count = ldsBuildList.rowcount( )
	End IF
	
	//write to screen and Log File
	lsLogOut = '      -  Processing Function - 3PL Cycle Count Order - uf_create_system_cycle_counts(). - ' + ' Non-Serialized Item(s) Count:' +string(ll_Non_Serialized_count) 
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
	//setting counts against Daily Limit
	If ll_remain_count > 0  Then
		
		If ll_Non_serialized_count > ll_remain_count Then
			ll_Non_serialized_count = ll_remain_count
			ll_remain_count = 0
		End If
		
		//write to screen and Log File
		lsLogOut = '      -  Processing Function - 3PL Cycle Count Order - uf_create_system_cycle_counts(). - ' + ' Processing Non-Serialized Item(s) Limit Count:' +string(ll_Non_Serialized_count) 
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		
		
		For ll_row =1 to ll_Non_serialized_count
			ll_count++
			ls_loc_list.string_arg[ll_count] =ldsBuildList.getItemString( ll_row, 'L_Code')
			ls_class_code =ldsBuildList.getItemString( ll_row, 'CC_Class_Code')
			
			IF lbCreateNewCC =FALSE Then
				ls_cc_No = this.uf_get_next_avail_cc_no( asproject) //get Next CC No
				idsCCMaster = this.uf_build_cc_master( ls_cc_No, asproject, aswhcode, ls_class_code, ldtwhTime, 'Count By Locations for Serialized/Non-Serialized SKU') //build CC_Master records
			End IF
			
			//create new CC record aginst Limit
			IF (ll_locations_Limit - ll_count) > 0 Then
				lbCreateNewCC =TRUE
				lbCreateSystemCriteria =FALSE
			else
				lbCreateNewCC =FALSE
				lbCreateSystemCriteria =TRUE
			End IF
			
			IF lbCreateSystemCriteria =TRUE THEN
				ids3PLCC = this.uf_build_cc_system_criteria( ls_cc_No, 'L', ls_loc_list) //build CC_System_Criteria records
				lbCreateSystemCriteria =FALSE //re-initialize value
				ll_count =0 //re-initialize value
				ls_loc_list.string_arg  = ls_empty_str.string_arg //clear Location List
			End IF
		Next
		
		If upperbound(ls_loc_list.string_arg) > 0 Then 
			ids3PLCC = this.uf_build_cc_system_criteria( ls_cc_No, 'L', ls_loc_list) //build CC_System_Criteria records - Any Open System Criteria Records
		End If
	End IF
End IF

//(C) Write Records into DB
ll_cc_count = idsCCMaster.rowcount( )
ll_criteria_count = ids3PLCC.rowcount( )

//write to screen and Log File
lsLogOut = '      -  Processing Function - 3PL Cycle Count Order - uf_create_system_cycle_counts() - CC Master Count: '+nz(string(ll_cc_count),'-')+' - CC Criteria Count: '+nz(string(ll_criteria_count),'-')
lsLogOut += ' - have to be inserted into DB.' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
 
If ll_cc_count > 0 and  ll_criteria_count > 0 Then ll_rc = this.uf_process_insert_system_cc_orders( idsCCMaster, ids3PLCC) //Insert CC Records
If ll_rc = 0 Then	this.uf_update_content_cc_no( asproject, aswhcode, ids3PLCC) //Update Content Records

//Destroy Datastores
destroy ids3PLCC
destroy idsCCMaster

//write to screen and Log File
lsLogOut = '      - End Processing Function - 3PL Cycle Count Order - uf_create_system_cycle_counts() against wh_code: '+aswhcode+ ' - ' +String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function string uf_get_next_avail_cc_no (string asproject);//13-Nov-2017 :Madhu PEVS-806 - 3PL Cycle Count Orders

string ls_cc_No
decimal ldCCNO

//get Next CC No
sqlca.sp_next_avail_seq_no(asproject, "CC_Master", "CC_No" , ldCCNO)
ls_cc_No = asproject + String(Long(ldCCNo),"000000")

Return ls_cc_No
end function

public function str_parms uf_build_cc_sku_list (string asproject, string aswhcode, string asformatloc);//13-NOV-2017 :Madhu PEVS-806 - 3PL Cycle Count Orders

string		sql_syntax, lsErrors, lsLogOut, ls_skuList[]
long		ll_serialized_list, ll_row
str_parms ls_str_parms

Datastore ldsSKUList

ls_str_parms.boolean_arg[1] =FALSE //set default value

//write to screen and Log File
lsLogOut = '      -  Start Processing Function - 3PL Cycle Count Order - uf_build_cc_sku_list(). - for wh_code: '+ aswhcode
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


//build SQL Qeury to pull all distinct Serialized Items.
ldsSKUList = create Datastore
sql_syntax =	"	SELECT Distinct A.SKU as SKU, B.Serialized_Ind	"
sql_syntax +=	"	FROM Content A with(nolock)	"
sql_syntax +=	"	INNER JOIN Item_Master B with(nolock) ON A.Project_Id= B.Project_Id	"
sql_syntax +=	"	AND A.SKU = B.SKU and A.Supp_Code = B.Supp_code	"
sql_syntax +=	"	AND B.Serialized_Ind <> 'N'	"
sql_syntax +=	"	Where A.Project_Id='"+asproject+"'	"
sql_syntax +=	"	AND A.WH_Code ='"+aswhcode+"'	"
sql_syntax +=	"	AND A.L_Code IN ("+asformatloc+")"
sql_syntax +=	"	Order By A.SKU 	"

ldsSKUList.create( SQLCA.SyntaxFromSql(sql_syntax, "", lsErrors))

IF len(lsErrors) > 0 THEN
 	lsLogOut = "        *** Unable to create datastore to Pull Serialized Items of PANDORA 3PL System Cycle Count Orders .~r~r" + lsErrors
	FileWrite(gilogFileNo,lsLogOut)
	ls_str_parms.boolean_arg[1] =TRUE
END IF

ldsSKUList.SetTransObject(SQLCA)
ll_serialized_list =ldsSKUList.retrieve( )

FOR ll_row =1 to ll_serialized_list
	ls_str_parms.string_arg[ll_row] = ldsSKUList.getItemString(ll_row, 'SKU')
NEXT

//write to screen and Log File
lsLogOut = '      -  End Processing Function - 3PL Cycle Count Order - uf_build_cc_sku_list(). - for wh_code: '+ aswhcode + ' Serialized SKU count: '+string(ll_serialized_list)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsSKUList
Return  ls_str_parms
end function

public function integer uf_process_cc_eod_report (string as_ini_file, string as_project, datetime ad_next_runtime_date);//16-Nov-2017 :Madhu PEVS-806 3PL Cycle Count Order
//Daily End Of Day Cycle Count Reports

string lsFilename ="CycleCount_XPO-SIMS_"
string lsPath,lsFileNamePath,msg,lsLogOut
int returnCode,liRC
long llRowCount, ll_row,	ll_New_Row, ll_first_count_qty, ll_first_count_partner_qty, ll_second_count_qty, ll_second_count_partner_qty

Datastore ldsccInv, ldsCCInvResult

date ld_StartDate, ld_EndDate
ld_StartDate = Date(ad_next_runtime_date) //current Date (2017-11-05 00:00:00)
ld_StartDate = RelativeDate(ld_StartDate, -1)  //Current Date (2017-11-04 00:00:00)
ld_EndDate = Date(ad_next_runtime_date) //current Date (2017-11-05 00:00:00)


// Create our filename and path
lsFilename +=string(datetime(today(),now()),"YYYYMMDDHHMMSS") + '.csv'
lsPath = ProfileString(as_ini_file, "PANDORA-CC-REPORTS", "ftpfiledirout", "")
lsPath += '\' + lsFilename

ldsccInv = Create Datastore
ldsccInv.Dataobject = 'd_cc_daily_eod_report'
ldsccInv.SetTransobject(sqlca)

ldsCCInvResult = Create Datastore
ldsCCInvResult.Dataobject ='d_cc_daily_eod_rolledup_report'
ldsCCInvResult.SetTransobject(sqlca)


lsLogOut = "- PROCESSING FUNCTION: "+as_project+" Daily CC EOD Report! and Path: "+lsPath
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Daily Avail Inventory Data
gu_nvo_process_files.uf_write_log('Retrieving Daily CC  EOD Report.....') /*display msg to screen*/
llRowCount = ldsccInv.Retrieve(as_project, ld_StartDate,ld_EndDate)

if llRowCount <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(llRowCount)
	if llRowCOunt = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	return 0 // nothing to see here...move along
end if


//08-JUNE-2018 :Madh S20175 RolledUp CC Results
//If First_Count_Qty = First_Count_Partner_Qty then following Count Quantities becomes zero.

For ll_row =1 to llRowCount
	ll_first_count_qty = ldsccInv.getItemNumber( ll_row, 'First_Count_Qty')
	ll_first_count_partner_qty = ldsccInv.getItemNumber( ll_row, 'First_Count_Partner_Qty')
	
	ll_second_count_qty = ldsccInv.getItemNumber( ll_row, 'Second_Count_Qty')
	ll_second_count_partner_qty = ldsccInv.getItemNumber( ll_row, 'Second_Count_Partner_Qty')
	
	ll_New_Row = ldsCCInvResult.insertrow( 0)
	ldsCCInvResult.setItem( ll_New_Row, 'Count_Date_Time', ldsccInv.getItemdatetime( ll_row, 'Count_Date_Time'))
	ldsCCInvResult.setItem( ll_New_Row, 'Receipt_Date_Time', ldsccInv.getItemString( ll_row, 'Receipt_Date_Time'))
	ldsCCInvResult.setItem( ll_New_Row, 'Time_Zone', ldsccInv.getItemString(ll_row, 'Time_Zone'))
	ldsCCInvResult.setItem( ll_New_Row, 'Count_Number', ldsccInv.getItemString(ll_row, 'Count_Number'))
	ldsCCInvResult.setItem( ll_New_Row, 'Count_source', ldsccInv.getItemString(ll_row, 'Count_source'))
	ldsCCInvResult.setItem( ll_New_Row, 'Bin_Number', ldsccInv.getItemString(ll_row, 'Bin_Number'))
	ldsCCInvResult.setItem( ll_New_Row, 'Tag_Number', ldsccInv.getItemString(ll_row, 'Tag_Number'))
	ldsCCInvResult.setItem( ll_New_Row, 'GPN', ldsccInv.getItemString(ll_row, 'GPN'))
	ldsCCInvResult.setItem( ll_New_Row, 'Vendor_ABC_Classification', ldsccInv.getItemString(ll_row, 'Vendor_ABC_Classification'))
	ldsCCInvResult.setItem( ll_New_Row, 'Location_Code', ldsccInv.getItemString(ll_row, 'Location_Code'))
	ldsCCInvResult.setItem( ll_New_Row, 'Project_Code', ldsccInv.getItemString(ll_row, 'Project_Code'))
	ldsCCInvResult.setItem( ll_New_Row, 'First_Count_Qty', ll_first_count_qty)
	ldsCCInvResult.setItem( ll_New_Row, 'First_Count_Partner_Qty', ll_first_count_partner_qty)

	IF ll_first_count_qty = ll_first_count_partner_qty THEN
		ldsCCInvResult.setItem( ll_New_Row, 'Second_Count_Qty', 0)
		ldsCCInvResult.setItem( ll_New_Row, 'Second_Count_Partner_Qty', 0)
		ldsCCInvResult.setItem( ll_New_Row, 'Third_Count_Qty', 0)
		ldsCCInvResult.setItem( ll_New_Row, 'Third_Count_Partner_Qty', 0)
	
	ELSEIF ll_second_count_qty = ll_second_count_partner_qty THEN
		ldsCCInvResult.setItem( ll_New_Row, 'Second_Count_Qty', ll_second_count_qty)
		ldsCCInvResult.setItem( ll_New_Row, 'Second_Count_Partner_Qty', ll_second_count_partner_qty)
		ldsCCInvResult.setItem( ll_New_Row, 'Third_Count_Qty', 0)
		ldsCCInvResult.setItem( ll_New_Row, 'Third_Count_Partner_Qty', 0)
		
	ELSE
		ldsCCInvResult.setItem( ll_New_Row, 'Second_Count_Qty', ldsccInv.getItemNumber( ll_row, 'Second_Count_Qty'))
		ldsCCInvResult.setItem( ll_New_Row, 'Second_Count_Partner_Qty', ldsccInv.getItemNumber( ll_row, 'Second_Count_Partner_Qty'))
		ldsCCInvResult.setItem( ll_New_Row, 'Third_Count_Qty', ldsccInv.getItemNumber( ll_row, 'Third_Count_Qty'))
		ldsCCInvResult.setItem( ll_New_Row, 'Third_Count_Partner_Qty', ldsccInv.getItemNumber( ll_row, 'Third_Count_Partner_Qty'))
	END IF
	
Next

// Export the data to the file location
returnCode = ldsCCInvResult.saveas(lsPath,CSV!,true)
msg = 'Daily CC EOD Report  Save As Return Code: ' + string(returnCode) + " and Successfully completed and Path: "+lsPath
FileWrite(gilogFileNo,msg)

Destroy ldsccInv
Destroy ldsCCInvResult

RETURN 0
end function

public function integer uf_process_cc_inv_snapshot (string as_ini_file, string as_project);//16-Nov-2017 :Madhu PEVS-806 3PL Cycle Count Order
//Daily Inventory Snapshot

string lsFilename ="InventorySnapShot_XPO-SIMS_"
string lsPath,lsFileNamePath,msg,lsLogOut
int returnCode,liRC
long llRowCount

Datastore ldsccInv


// Create our filename and path
lsFilename +=string(datetime(today(),now()),"YYYYMMDDHHMMSS") + '.csv'
lsPath = ProfileString(as_ini_file, "PANDORA-CC-REPORTS", "ftpfiledirout", "")
lsPath += '\' + lsFilename

ldsccInv = Create Datastore
ldsccInv.Dataobject = 'd_cc_daily_inv_snapshot'
ldsccInv.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: "+as_project+" Daily CC Inventory SnapShot! and Path: "+lsPath
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Daily Avail Inventory Data
gu_nvo_process_files.uf_write_log('Retrieving Daily CC Inventory Data.....') /*display msg to screen*/
llRowCOunt = ldsccInv.Retrieve(as_project)

if llRowCOunt <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(llRowCOunt)
	if llRowCOunt = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	return 0 // nothing to see here...move along
end if

// Export the data to the file location
returnCode = ldsccInv.saveas(lsPath,CSV!,true)
msg = 'Daily CC Inventory SnapShot  Save As Return Code: ' + string(returnCode) + " and Successfully completed and Path: "+lsPath
FileWrite(gilogFileNo,msg)

Destroy ldsccInv

RETURN 0
end function

public function datastore uf_build_cc_system_criteria (string as_cc_no, string as_count_type, str_parms as_count_value);//13-NOV-2017 :Madhu PEVS-806 - 3PL Cycle Count Orders
//Build System Criteria Records

string lsLogOut, lsFind
long llCCRow, ll_row, llFindRow

If Not isvalid(ids3PLCC) Then
	ids3PLCC = Create u_ds_datastore
	ids3PLCC.dataobject= 'd_cc_system_criteria'
	ids3PLCC.SetTransObject(SQLCA)
End If

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count Order -Start Processing of uf_build_cc_system_criteria()- Building CC System Criteria Records '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

llFindRow = 0

//build CC_System_Criteria records
FOR ll_row =1 to UpperBound(as_count_value.string_arg)
	
	//Write to File and Screen
	lsFind = "CC_No ='"+as_cc_no+"' and Count_Type ='"+as_count_type+"' and Count_Value ='"+trim(as_count_value.string_arg[ll_row])+"'"
	If ids3PLCC.rowcount() > 0 Then llFindRow = ids3PLCC.find( lsFind, 1,ids3PLCC.rowcount())

	lsLogOut = '      - 3PL Cycle Count Order - Processing of uf_build_cc_system_criteria()- Find Record: '+lsFind+ ' Find Row Count: '+nz(string(llFindRow), '-')
	lsLogOut +=' Build CC System Criteria Record Count: '+ nz(string( ids3PLCC.rowcount()), '-')
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	IF llFindRow =0 Then
		llCCRow = ids3PLCC.insertrow( 0)
		ids3PLCC.setItem( llCCRow, 'CC_No', as_cc_no)
		ids3PLCC.setItem( llCCRow, 'Count_Type', as_count_type)
		ids3PLCC.setItem( llCCRow, 'Count_Value', trim(as_count_value.string_arg[ll_row]))
	End IF
Next

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count Order -End Processing of uf_build_cc_system_criteria()- Building CC System Criteria Records '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return ids3PLCC
end function

public function datastore uf_build_cc_master (string asccno, string asproject, string aswhcode, string ascccode, datetime adtwhtime, string asremarks);//13-NOV-2017 :Madhu PEVS-806 - 3PL Cycle Count Orders
long llNewRow

If Not isvalid(idsCCMaster) Then
	idsCCMaster = Create u_ds_datastore
	idsCCMaster.dataobject= 'd_cc_master'
	idsCCMaster.SetTransObject(SQLCA)
End If

//build CC_Master records
llNewRow = idsCCMaster.insertrow( 0)
idsCCMaster.SetItem(llNewRow, 'cc_no', asccno)
idsCCMaster.SetItem(llNewRow, 'project_id', asproject)
idsCCMaster.SetItem(llNewRow, 'wh_code', aswhcode)
idsCCMaster.SetItem(llNewRow, 'last_update', Today())
idsCCMaster.SetItem(llNewRow, 'last_user', 'SIMSFP')
idsCCMaster.SetItem(llNewRow, 'ord_date', adtwhtime)
idsCCMaster.SetItem(llNewRow, 'Ord_type', 'X') //System generated
idsCCMaster.SetItem(llNewRow, 'Ord_Status', 'N')
idsCCMaster.SetItem(llNewRow, 'class', ascccode)
idsCCMaster.SetItem(llNewRow, 'class_end', ascccode)
idsCCMaster.SetItem(llNewRow, 'Remark', asremarks)


Return idsCCMaster
end function

public function integer uf_process_insert_system_cc_orders (ref datastore adsccmaster, ref datastore adscc3pl);//05-Dec-2017 :Madhu PEVS-806 3PL Cycle Count Orders.
string	lsLogOut
long 	ll_cc_count, ll_criteria_count, ll_rc

SetPointer(Hourglass!)
ll_cc_count = adsCCMaster.rowcount()
ll_criteria_count = adsCC3PL.rowcount()

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count Order -Start Processing of uf_process_insert_system_cc_orders()- Inserting records into DB '
lsLogOut += ' - CC Master count: ' + string(ll_cc_count)+' - System Criteria Count: '+string(ll_criteria_count) + ' - SQL Return Code: '+ string(SQLCA.sqlcode)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
		
If adsCCMaster.rowcount( ) > 0 Then	ll_rc =adsCCMaster.update( True, False);
If adsCC3PL.rowcount( ) > 0 and ll_rc > 0 Then ll_rc =adsCC3PL.update( True, False);

If ll_rc =1 Then
	COMMIT USING SQLCA;
	if SQLCA.sqlcode = 0 then
		adsCCMaster.resetupdate( )
		adsCC3PL.resetupdate()
	else
		ROLLBACK USING SQLCA;
		adsCCMaster.reset( )
		adsCC3PL.reset()
		
		//Write to File and Screen
		lsLogOut = '      - 3PL Cycle Count Order - Error Processing of uf_process_insert_system_cc_orders()  Error: '+nz(SQLCA.SQLErrText,'-') + ' Error code: '+string(SQLCA.sqlcode)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if

else
	ROLLBACK USING SQLCA;
	//Write to File and Screen
	lsLogOut = '      - 3PL Cycle Count Order - Error Processing of uf_process_insert_system_cc_orders()  Error: '+nz(SQLCA.SQLErrText,'-') + ' Error code: '+string(SQLCA.sqlcode) +' Record save failed'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count Order -End Processing of uf_process_insert_system_cc_orders() - Insertion Successfully Completed.!'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function integer uf_update_content_cc_no (string asproject, string aswhcode, ref datastore ads3plcc);//15-NOV-2017 :Madhu PEVS-806 - 3PL Cycle Count Orders
//Update Content Records with appropriate CC No.

string ls_loc, lsLogOut, ls_cc_no, ls_count_type, ls_count_value
long ll_row, ll_system_count

//Write to File and Screen
lsLogOut = '       - 3PL Cycle Count Order - Start Processing - uf_update_content_cc_no()  - wh_code: '+aswhcode
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

ll_system_count = ads3PLCC.rowcount()

If ll_system_count > 0 Then

	FOR ll_row =1 to ll_system_count
		
		ls_cc_no = ads3PLCC.getItemString(ll_row, 'CC_No')
		ls_count_type = ads3PLCC.getItemString(ll_row, 'Count_Type')
		ls_count_value = ads3PLCC.getItemString(ll_row, 'Count_Value')
	
		If upper(ls_count_type) ='S' Then	 //update content against SKU
			UPDATE Content SET CC_No =:ls_cc_no, Old_Inventory_Type =Inventory_Type, Old_Country_Of_Origin = Country_Of_Origin
			WHERE Project_Id =:asproject and wh_code =:aswhcode
			and sku =:ls_count_value and (CC_No ='-' or CC_No IS NULL)
			USING SQLCA;
			COMMIT;
		else		//update content against Location
			UPDATE Content SET CC_No =:ls_cc_no, Old_Inventory_Type =Inventory_Type, Old_Country_Of_Origin = Country_Of_Origin
			WHERE Project_Id =:asproject and wh_code =:aswhcode
			and l_code =:ls_count_value and (CC_No ='-' or CC_No IS NULL)
			USING SQLCA;
			COMMIT;
		End If
		
		If Sqlca.sqlcode <> 0  Then
			ROLLBACK USING SQLCA;
			lsLogOut = '       - 3PL Cycle Count Order - Processing- uf_update_content_cc_no()  - Failed to Update Content Records.! Error Code: '+string(sqlca.sqlcode) +'  Error Msg: '+sqlca.sqlerrtext
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		End IF
				
	NEXT
End IF

//Write to File and Screen
lsLogOut = '       - 3PL Cycle Count Order - End Processing - uf_update_content_cc_no()  - wh_code: '+aswhcode
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

on u_nvo_proc_pandora2.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_pandora2.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;// Destroy the mimggg objects.
f_destroymimgggobjects()

// Destroy the sims objects.
f_destroysimsobjects()

// Destroy the clearing objects.
f_destroyclearingobjects()

// Destroy the cleared objects.
f_destroyclearedobjects()

// Destroy the AutoSOC objects.
f_destroyautosocobjects()
end event

