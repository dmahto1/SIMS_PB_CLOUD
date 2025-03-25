$PBExportHeader$w_orphans.srw
forward
global type w_orphans from w_std_master_detail
end type
type cb_orphan_reset from commandbutton within tabpage_main
end type
type dw_si5 from datawindow within tabpage_main
end type
type dw_si4 from datawindow within tabpage_main
end type
type sle_awb from singlelineedit within tabpage_main
end type
type dw_master from u_dw_ancestor within tabpage_main
end type
type dw_search_result from u_dw_ancestor within tabpage_search
end type
type cb_orphan_search from commandbutton within tabpage_search
end type
type dw_search_entry from datawindow within tabpage_search
end type
end forward

global type w_orphans from w_std_master_detail
integer width = 3351
integer height = 1968
string title = "Orphaned Status Records"
event ue_search ( )
event type integer ue_applystatus ( )
end type
global w_orphans w_orphans

type variables

w_orphans iw_window

SingleLineEdit	Isle_AWB

CommandButton icb_reset

DataWindow Idw_Main, Idw_Search, Idw_Result, idw_si4, idw_si5

String isOrigSQL_Result, is_GroupNbr, is_TransNbr //is_rono, is_SKU, is_UF1

long il_lineno

end variables

forward prototypes
public subroutine wf_clear_screen ()
public function integer wf_validation ()
public function integer uf_applystatus ()
public function integer uf_updatestagetable (string astable, string asgroup, string astransaction, integer aivalue)
public function integer uf_validstatuscode (string ascode)
end prototypes

event ue_search();//formerly cb_search's Click event
DateTime ldt_date
String ls_string, ls_where, ls_sql 
Boolean lb_trans_from, lb_trans_to, lb_status_from, lb_status_to
Boolean lb_where
//Boolean lsuseSku,lsuseCONTID,lsusePONO
//Initialize Date Flags
lb_trans_from 		= FALSE  //rcv_date_from/to
lb_trans_to 		= FAlSE
lb_status_from 	= FALSE  //status_date_from/to
lb_status_to 		= FALSE

If idw_search.AcceptText() = -1 Then Return

//idw_search.Reset()
idw_result.Reset()
ls_sql = isOrigSql_Result
lb_where = False


//car_ref_nbr (AWB/BOL No)
ls_string = idw_Search.GetItemString(1, "car_ref_nbr")
if not isNull(ls_string) and trim(ls_string)<>'' then
	ls_where += " and si1_CarrierRefNbr = '" + ls_string + "' "
	lb_where = TRUE
end if

//ShpperRefNbr
ls_string = idw_Search.GetItemString(1, "ship_ref_nbr")
if not isNull(ls_string) and trim(ls_string)<>'' then
	ls_where += " and si1_ShpperRefNbr = '" + ls_string + "' "
	lb_where = TRUE
end if

//Carrier
ls_string = idw_search.GetItemString(1, "carrier")
if not isNull(ls_string) then
	ls_where += " and SI1_Carrier = '" + ls_string + "' "
end if

//Origin Zip
ls_string = idw_search.GetItemString(1, "Origin")
if not isNull(ls_string) then
	ls_where += " and SH.SI2_PostalCode = '" + ls_string + "' "
end if

//Destination Zip
ls_string = idw_search.GetItemString(1, "Dest")
if not isNull(ls_string) then
	ls_where += " and CN.SI2_PostalCode = '" + ls_string + "' "
end if

ldt_date = idw_search.GetItemDateTime(1, "rcv_date_from")
If  Not IsNull(ldt_date) Then
	//?SI1 or SI4?
	ls_where += " and SI1_ReceivedDate >= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_trans_from = TRUE
	lb_where = TRUE
End If

ldt_date = idw_search.GetItemDateTime(1, "rcv_date_to")
If  Not IsNull(ldt_date) Then
	ls_where += " and SI1_ReceivedDate <= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_trans_to = TRUE
	lb_where = TRUE
End If

ldt_date = idw_search.GetItemDateTime(1, "status_date_from")
If  Not IsNull(ldt_date) Then
	ls_where += " and SI4_StatusDate >= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_status_from = TRUE
	lb_where = TRUE
End If

ldt_date = idw_search.GetItemDateTime(1, "status_date_to")
If  Not IsNull(ldt_date) Then
	ls_where += " and SI4_StatusDate <= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_status_to = TRUE
	lb_where = TRUE
End If


/*
//Check Order Date range for any errors prior to retrieving
IF ((lb_trans_to = TRUE and lb_trans_from = FALSE) 	OR &
	 (lb_trans_from = TRUE and lb_trans_to = FALSE)  	OR &
	 (lb_trans_from = FALSE and lb_trans_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Trans Date Range", Stopsign!)
	Return
END IF

IF ((lb_status_to = TRUE and lb_status_from = FALSE) 	OR &
	 (lb_status_from = TRUE and lb_status_to = FALSE)  	OR &
	 (lb_status_from = FALSE and lb_status_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Trans Date Range", Stopsign!)
	Return
END IF
*/

ls_sql += ls_where + "order by SI1_ReceivedDate desc, SI4_Statusdate desc"

idw_result.SetSqlSelect(ls_sql)

If idw_result.Retrieve() = 0 Then
	messagebox(is_title,"No records found!")
End If

end event

public subroutine wf_clear_screen ();idw_main.Reset()
tab_main.SelectTab(1) 
idw_main.Hide()
//idw_stats.Hide()

//isle_code.Text = ""
///isle_code.visible = true
///isle_code.SetFocus()

is_GroupNbr = ''
is_TransNbr = ''
Return

end subroutine

public function integer wf_validation ();
If idw_main.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	Return -1
End If
  
SetPointer(Hourglass!)
w_main.SetMicroHelp('Validating Data...')

// Check if all required fields are filled

If f_check_required(is_title, idw_main) = -1 Then
	tab_main.SelectTab(1) 
	Return -1
End If

//Other Required Fields
/*
If isnull(idw_main.GetItemString(1,'wh_code')) or idw_main.GetItemString(1,'wh_code') = '' Then
	messagebox(is_title, 'Warehouse is Required')
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	idw_main.SetColumn('wh_Code')
	Return -1
End If
*/

//ls_whcode = idw_main.getitemstring(1,'wh_code')			

SetPointer(Arrow!)

return 0
end function

public function integer uf_applystatus ();/* dts 8/17/04

Copied from u_nvo_proc_standard_edi.uf_apply_status
 - called for a specific SI1_Seq
 
 Should combine into single source of code...
*/

/*
   - Check for Shipment
	 - Check for duplicate status
	 - Insert into Shipment_Status
	 - Update Shipment
*/
Datastore	ldsSI1, ldsSI2, ldsSI4, ldsSI5, ldsShipStat, ldsShipment

string ls_sql_1, ls_sql_4, ls_sql_5, ls_sql_ship, ls_where, lsShipment, lsGroup, lsTrans, lsShipNo, lsShipNo_Prev
string lsStatus, lsStatusMod, lsTimeZone, lsCarrier, lsProNo, lsCity, lsState, lsCountryCd
//RecordType 5:
string lsSvcLvl, lsPODName, lsWgtUOM, lsWgtQual, lsCtnCnt, lsWgt, lsOSD

any laShipment

long llRowCount_1, llRowPos_1, llRowCount_4, llRowPos_4, llRowCount_5, llCurRow, llRowCount_Ship, llLine

integer liRC, liCount

DateTime ldStatusDate, ldTempDate

Boolean lbDelivered // 06/16/06 - now applying all status to shipment (but not over-writing a delivery status)
String lsPrevStatusCode, lsLastStatusCode
DateTime ldPrevStatusDate, ldLastStatusDate

// pvh 02.15.06 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

				
ldsSI1 = Create u_ds_datastore
ldsSI1.dataobject = 'd_status_import_1'
ldsSI1.SetTransObject(SQLCA)
ls_sql_1 = ldsSI1.GetSQLSelect()

ldsSI4 = Create u_ds_datastore
ldsSI4.dataobject = 'd_status_import_4'
ldsSI4.SetTransObject(SQLCA)
ls_sql_4 = ldsSI4.GetSQLSelect()

ldsSI5 = Create u_ds_datastore
ldsSI5.dataobject = 'd_status_import_5'
ldsSI5.SetTransObject(SQLCA)
ls_sql_5 = ldsSI5.GetSQLSelect()

ldsShipment = Create u_ds_datastore
ldsShipment.dataobject = 'd_Shipment'
ldsShipment.SetTransObject(SQLCA)
ls_sql_Ship = ldsShipment.GetSQLSelect()

ldsShipStat = Create u_ds_datastore
ldsShipStat.dataobject = 'd_shipment_status'
ldsShipStat.SetTransObject(SQLCA)

/*TEMP!! - May want to make this an argument (and pass 1 from EDI, and X from Client)
          ( - OR - pass the actual SI1_Seq from the Client) */
//ls_where = 'where sirs_id=1'
ls_where = 'where si1_seq=' + string(idw_main.GetItemNumber(1,'si1_seq'))
ldsSI1.SetSqlSelect(ls_sql_1 + ls_where)

//Scroll through unprocessed records in staging tables...
llRowCount_1 = ldsSI1.Retrieve()
If llRowCount_1 > 0 Then
  //messagebox ("ldsSI1", "Row Count: " + string(llRowCount_1))
	For llRowPos_1 = 1 to llRowCount_1
		//check if shipment exists...
		//7/9/04 laShipment = ldsSI1.GetItemString(llRowPos_1, 'SI1_ShpperRefNbr')
		laShipment = ldsSI1.GetItemString(llRowPos_1, 'SI1_CarrierRefNbr')
		lsGroup = ldsSI1.GetItemString(llRowPos_1, 'SI1_GroupControlNbr')  //moved from below
		lsTrans = ldsSI1.GetItemString(llRowPos_1, 'SI1_TransactionControlNbr')  //moved from below
		if isnull(laShipment) then
			messagebox ("ApplyStatus", "Null CarrierRefNbr!")
		else
			lsShipment = laShipment //temp! - necessary? (needed it to resolve nulls which shouldn't happen now that 'ShpperRefNbr' is fixed)
			//liRC = uf_ShipmentExists (asproject, lsShipment)
			ls_where = "where project_id = '" + gs_Project + "' and awb_bol_no = '" + lsShipment + "'"
			ldsShipment.SetSqlSelect(ls_sql_Ship + ls_where)			
			llRowCount_Ship = ldsShipment.Retrieve()
			If llRowCount_Ship <= 0 Then
				//Shipment doesn't exist. Reject and set 'Shipment Doesn't Exist' message
				//TEMP! - set SIRS_ID to ?
				messagebox ("ApplyStatus", "Shipment Doesn't exist: " + lsShipment + ".")
				///messagebox ("TEMP! - ApplyStatus", "Update Staging tables as appropriate (24, Shipment doesn't exist)")
				/* 7/9/04 - added update to staging table. Still haven't applied a status
				   indicative of why the status isn't being applied (shipment doesn't exist, data error....) */
				lirc = uf_UpdateStageTable('1', lsGroup, lsTrans, 24)
				lirc = uf_UpdateStageTable('2', lsGroup, lsTrans, 24)
				lirc = uf_UpdateStageTable('4', lsGroup, lsTrans, 24)
				lirc = uf_UpdateStageTable('5', lsGroup, lsTrans, 24)
			else
				//TEMP! - What if more than 1 shipment meets criteria??
				lsShipNo = ldsShipment.GetItemString(1, 'Ship_No')
				lsCarrier = ldsSI1.GetItemString(llRowPos_1, 'SI1_Carrier')
				//7/9/04 lsProNo = ldsSI1.GetItemString(llRowPos_1, 'SI1_CarrierRefNbr')
				lsProNo = ldsSI1.GetItemString(llRowPos_1, 'SI1_CarrierRefNbr') // dts 3/24/06 - not sure why this was turned off....
				//ls_where = "where SIRS_ID=1 and SI4_GroupControlNbr='" + lsGroup + "' and SI4_TransactionControlNbr = '" + lsTrans + "'"
				// dts 8/17/04 - eliminated SIRS_ID=1 part of criteria (on client version)
				ls_where = "where SI4_GroupControlNbr='" + lsGroup + "' and SI4_TransactionControlNbr = '" + lsTrans + "'"
				//messagebox ("where", ls_where)
				ldsSI4.SetSqlSelect(ls_sql_4 + ls_where)		
				llRowCount_4 = ldsSI4.Retrieve()
				//messagebox ("ldsSI4", "Row Count: " + string(llRowCount_4))
				//scroll through status records....

				/* 061606 - Look up ord_status for shipment and see if it's 'Delivered' (set lbDelivered to True)
						If it is, don't allow a status code/date change
						Make sure that while we're looping, if one is Delivered don't let a later
						one change status(set lbDelivered to True)
				*/
				lsPrevStatusCode = ldsShipment.GetItemString(1, 'ord_status')
				if upper(left(lsLastStatusCode, 1)) = 'D' then lbDelivered = true
				ldPrevStatusDate = ldsShipment.GetItemDateTime(1, 'Ord_Status_Date')
				if isnull(ldLastStatusDate) then 
					ldPrevStatusDate = datetime("1950-01-01")
				end if
				for llRowPos_4 = 1 to llRowCount_4
					lsStatus = ldsSI4.GetItemString(llRowPos_4, 'SI4_StatusCode') 
					//TEMP! lsStatusMod = ldsSI4.GetItemString(llRowPos_4, 'SI4_Status_Modifier') 					
					lsTimeZone = ldsSI4.GetItemString(llRowPos_4, 'SI4_StatusTimeZone')
					ldStatusDate = ldsSI4.GetItemDateTime(llRowPos_4, 'SI4_StatusDate')

					//061606
					//TEMP - Or lsLastStatusCode = 'NS'??? - what if the shipment is created later (and, thus, the status date (on the shipment) is later than the actual status date?
					if ldStatusDate > ldLastStatusDate and not lbDelivered then
						ldLastStatusDate = ldStatusDate
						lsLastStatusCode = lsStatus
					end if
					
					lsCity = ldsSI4.GetItemString(llRowPos_4, 'SI4_StatusCity')
					lsState = ldsSI4.GetItemString(llRowPos_4, 'SI4_StatusState')
					lsCountryCd = ldsSI4.GetItemString(llRowPos_4, 'SI4_StatusCountry')
					//messagebox ("TEMP! - ApplyStatus", "StatusCode: " + lsStatus +", StatusModifier: " +lsStatusMod)
					//check if status code is valid...
					liRC = uf_ValidStatusCode(lsStatus)
					if liRC = -1 then //Invalid Status Code
						//status code not valid. Reject and set 'Invalid Status Code' message
						messagebox ("ApplyStatus", "Invalid StatusCode: " + lsStatus +", StatusModifier: " +lsStatusMod)
					else
						//Save the status record...
						/*Check For duplicate.... (what should we do? Update? Delete/Insert? ...)
						  - don't check for dup. Just insert new status record. Check date for possible update to Shipment/DM tables
							-  What if there's a file problem and the same status records get submitted indefinitely?
							-   - then we may want to check duplicates (StatusCode/StatusDate)
						*/

						/*get the max 'ship_status_line_no' for given ship_no (should do only once per Ship_No)...
						   WHY IS 'ship_status_line_no' a char field?!?! ... 
							 - have to use 'convert' to have 'max' treat values as numbers (otherwise, 2 is greater than 10)
							 - will have trouble if something other than number is ever used!		*/
						if lsShipNo <> lsShipNo_Prev then //are these sorted by ShipNo?
							select max(convert(numeric, ship_status_line_no)) into :llLine from shipment_status where ship_no = :lsShipNo;
							lsShipNo_Prev = lsShipNo
							if isnull(llLine) then 
								llLine = 1
							else
								llLine += 1
							end if
  						//messagebox("TEMP! - ApplyStatus", "Max ship_status_line_no: " + string(llMaxLine))
						else
							llLine += 1
						end if
						
						//messagebox ("TEMP!-ApplyStatus", "Inserting row into ldsShipStat... ShipNo: " +lsShipNo +", lsStatus: " +lsStatus + "LineNo: " + string(llMaxLine + llRowPos_4) + ", Max ship_status_line_no: " + string(llMaxLine) + ", RowPos:" + string(llRowPos_4) )
						llCurRow = ldsShipStat.InsertRow(0)
						//ldsShipStat.SetItem(llCurRow, 'Ship_No', llBatchSeq)
						//messagebox ("TEMP!", "llcurRow: " + string(llCurRow))
						ldsShipStat.SetItem(llCurRow, 'Ship_No', lsShipNo)
						//ldsShipStat.SetItem(llCurRow, 'Ship_Status_line_no', string(llMaxLine + llRowPos_4)) 
						ldsShipStat.SetItem(llCurRow, 'Ship_Status_line_no', string(llLine)) 
						ldsShipStat.SetItem(llCurRow, 'Status_Code', lsStatus)
						//ldsShipStat.SetItem(llCurRow, 'Status_Modifier', lsStatusMod)
						ldsShipStat.SetItem(llCurRow, 'Status_Date', ldStatusDate)
						ldsShipStat.SetItem(llCurRow, 'Status_Source', lsCarrier)
						//7/9/04 ldsShipStat.SetItem(llCurRow, 'Pro_No', lsProNo)
						ldsShipStat.SetItem(llCurRow, 'Pro_No', lsProNo) // dts 3/24/06 - not sure why this was turned off....
						ldsShipStat.SetItem(llCurRow, 'City', lsCity)
						ldsShipStat.SetItem(llCurRow, 'State', lsState)
						ldsShipStat.SetItem(llCurRow, 'ISO_Country_Code', lsCountryCd)
						ldsShipStat.SetItem(llCurRow, 'Last_User', 'SIMSFP')
						// pvh 08/25/05 - GMT
						// ldsShipStat.SetItem(llCurRow, 'Last_Update',  now() )  // how can this work? it's a datetime column!
						
						ldsShipStat.SetItem(llCurRow, 'Last_Update', ldtToday )
						ldsShipStat.SetItem(llCurRow, 'Create_User', 'SIMSFP')
						ldsShipStat.SetItem(llCurRow, 'Create_User_date', ldtToday )
						//TEMP! not in Client's version of d_shipment_status
						//ldsShipStat.SetItem(llCurRow, 'time_zone_id', lsTimeZone)
						liRC = ldsShipStat.Update()
						Execute Immediate "COMMIT" using SQLCA; //temp(?) - for testing
						
						if ldStatusDate > datetime('1950-01-01') then //valid status date?
							//messagebox ("TEMP!", "StatusDate: " + string(ldStatusDate))
							choose case lsStatus 
								case 'D', 'D1'
									// Put this (update of shipment table) in a subroutine?...
									ldTempDate = ldsShipment.GetItemDateTime(1, 'Freight_ATA')
									if isnull(ldTempDate) or ldStatusDate < ldTempDate then
										//messagebox ("TEMP!", "StatusDate ==> Freight_ATA: " + string(ldStatusDate))
										ldsShipment.SetItem(1, 'Freight_ATA', ldStatusDate)
										/* dts - 3/23/06 - now setting Ord_Status field (and date) upon delivery.
													Date should be set for other status codes (that affect ord_status) as well. */
										//061606 ldsShipment.SetItem(1, 'Ord_status', 'D') //Do we want to set Ord_Status on Order(s) also?  
										//061606 ldsShipment.SetItem(1, 'Ord_Status_Date', ldStatusDate)
									else
										//messagebox ("TEMP!", "TempDate: " + string(ldTempDate) + "StatusDate: " + string(ldStatusDate))
									end if
								case 'AD', 'AG', 'AJ'
									//AD - Delivery Appointment Date and Time
									//AG - Estimated Delivery
									//AJ - Tendered for Delivery 										
									ldTempDate = ldsShipment.GetItemDateTime(1, 'Freight_ETA')
									if isnull(ldTempDate) or ldStatusDate < ldTempDate then
										//messagebox ("TEMP!", "StatusDate ==> Freight_ETA: " + string(ldStatusDate))
										ldsShipment.SetItem(1, 'Freight_ETA', ldStatusDate)
									else
										//messagebox ("TEMP!", "TempDate: " + string(ldTempDate) + "StatusDate: " + string(ldStatusDate))
									end if
									/*
									if lsStatus = 'AG' then
										ldTempDate = ldsShipment.GetItemDateTime(1, 'Freight_ATD')
										if isnull(ldTempDate) or ldStatusDate < ldTempDate then
											//messagebox ("TEMP!", "StatusDate ==> Freight_ATD: " + string(ldStatusDate))
											ldsShipment.SetItem(1, 'Freight_ATD', ldStatusDate)
										else
											//messagebox ("TEMP!", "TempDate: " + string(ldTempDate) + "StatusDate: " + string(ldStatusDate))
										end if
									end if
									*/
								case 'AF', 'P1' // dts added 06/16/06
									//AF - Departed Pick-up Location
									//P1 - Departed Origin
									ldTempDate = ldsShipment.GetItemDateTime(1, 'Freight_ATD')
									if isnull(ldTempDate) or ldStatusDate < ldTempDate then
										//messagebox ("TEMP", "StatusDate ==> Freight_ETA: " + string(ldStatusDate))
										ldsShipment.SetItem(1, 'Freight_ATD', ldStatusDate)
									else
										//messagebox ("TEMP", "TempDate: " + string(ldTempDate) + "StatusDate: " + string(ldStatusDate))
									end if
								case else
									//
							end choose
							//liRC = ldsShipment.Update()
							//Execute Immediate "COMMIT" using SQLCA; //temp - where do we want the commit? (once per status rec?, once per Shipment?)
						else
							//messagebox ("TEMP!", "Null/Invalid StatusDate: " + string(ldStatusDate))
							//Should we save without a Status Date?  What good would that be?
						end if
					end if
				next // Next SI4 Record
				//061606 now setting status for shipment to Latest status (not over-writing delivery)
				if lsPrevStatusCode <> lsLastStatusCode and upper(left(lsPrevStatusCode,1)) <> 'D' then //what if it's the same StatusCode but a new date (like a later estimated delivery or delivery appt.?)
					ldsShipment.SetItem(1, 'Ord_status', lsLastStatusCode) //Do we want to set Ord_Status on Order(s) also?  
					ldsShipment.SetItem(1, 'Ord_Status_Date', ldLastStatusDate)
				end if
				
				//process record type 5 (OSD, POD, wgts...)				
				ls_where = "where SIRS_ID=1 and SI5_GroupControlNbr='" + lsGroup + "' and SI5_TransactionControlNbr = '" + lsTrans + "'"
				// dts 10/20/04 - eliminated SIRS_ID=1 part of criteria (on client version)
				ls_where = "where SI5_GroupControlNbr='" + lsGroup + "' and SI5_TransactionControlNbr = '" + lsTrans + "'"
				//messagebox ("where", ls_where)
				ldsSI5.SetSqlSelect(ls_sql_5 + ls_where)		
				llRowCount_5 = ldsSI5.Retrieve()
				//messagebox ("ldsSI5", "Row Count: " + string(llRowCount_5))
				//scroll through status records....
				If llRowCount_5 > 0 Then
					lsSvcLvl = ldsSI5.GetItemString(1, 'SI5_ShipmentServiceLevel')
					lsPODName = ldsSI5.GetItemString(1, 'si5_signature')
					lsCtnCnt = ldsSI5.GetItemString(1, 'si5_ShipmentLadingQuantity')
					lsWgt = ldsSI5.GetItemString(1, 'si5_ShipmentWeight') //TEMP!! Decimal place??
					lsWgtUOM = ldsSI5.GetItemString(1, 'si5_ShipmentWeightUOM')
					lsWgtQual = ldsSI5.GetItemString(1, 'si5_ShipmentWeightQualifier')
					lsOSD = ldsSI5.GetItemString(1, 'si5_OSDFlag')
					//dts - 10/21/04 - added null string test in following....
					if not isnull(lsPODName) and lsPODName <> ''  then ldsShipment.SetItem(1, 'POD_Name', lsPODName)
					if not isnull(lsCtnCnt) then ldsShipment.SetItem(1, 'Ctn_Cnt', long(lsCtnCnt))
					// 8/4/04 dts - if not isnull(lsWgt) then ldsShipment.SetItem(1, 'Weight', double(lsWgt))
					if not isnull(lsWgt) and lsWgt <> ''  then ldsShipment.SetItem(1, 'Weight', double(lsWgt)/1000)
					if not isnull(lsWgtUOM) and lsWgtUOM <> ''  then ldsShipment.SetItem(1, 'Weight_UOM', lsWgtUOM)
					if not isnull(lsWgtQual) and lsWgtQual <> '' then ldsShipment.SetItem(1, 'Weight_Qualifier', lsWgtQual)

					If Not (IsNull(lsOSD) or lsOSD="") Then
						//bOSD = True
						//messagebox("TEMP1", "OSD:" + ldsSI5.GetItemString(1, 'si5_OSDFlag') + ".")
						///messagebox("TEMP!", "OSD:" + lsOSD + ".")
						ldsShipment.SetItem(1, 'OSD_Flag', 'Y')
					End If
			  //Else
			  //  lsSvcLvl = "AI" //TEMP! - what should default Service Level be?
				End If //Record Type 5 present
				if isnull(lsSvcLvl) then lsSvcLvl = 'AI' //TEMP! - what should default Service Level be?
				select count(service_level) into :liCount from Service_Level
				where project_id = :gs_Project and carrier_code = :lsCarrier and service_level = :lsSvcLvl;
				if liCount >0 then ldsShipment.SetItem(1, 'Service_Level', lsSvcLvl) 
				
				ldsShipment.SetItem(1, 'Last_User', 'SIMSFP')
				ldsShipment.SetItem(1, 'Last_Update', ldtToday )

				liRC = ldsShipment.Update()
				Execute Immediate "COMMIT" using SQLCA; //temp! - where do we want the commit? (once per status rec?, once per Shipment?)
				
				//update SIRS_ID for each record type (based on liRC?  Based on some other variable (reflecting import status)?)
				//TEMP! - If success, set to 25, if failure, to 24(???)
				///messagebox ("TEMP! - ApplyStatus", "Update Staging tables as appropriate (25 success, other?)")
				lirc = uf_UpdateStageTable('1', lsGroup, lsTrans, 25)
				lirc = uf_UpdateStageTable('2', lsGroup, lsTrans, 25)
				lirc = uf_UpdateStageTable('4', lsGroup, lsTrans, 25)
				lirc = uf_UpdateStageTable('5', lsGroup, lsTrans, 25)
				//ls_where = "where SI4_GroupControlNbr='" + lsGroup + "' and SI4_TransactionControlNbr = '" + lsTrans + "'"
			end if //liRC = -1 (Shipment Exists)
		end if //Null Shipment
	Next // Next SI1 record
	messagebox ("ApplyStatus", "Done Applying Status Records.")
else
	///messagebox("ApplyStatus", "No records found!") //TEMP!!
End If

return 0

end function

public function integer uf_updatestagetable (string astable, string asgroup, string astransaction, integer aivalue);string lsSQL, lsErrText

	lsSQL = "Update Status_Import_" + asTable + " set"
	lsSQL += " SIRS_ID = " + string(aiValue)
	lsSQl += " Where SI" + asTable + "_GroupControlNbr = '" + asGroup + "'"
	lsSQl += " and SI" + asTable + "_TransactionControlNbr = '" + asTransaction + "'"
	
	//messagebox ("TEMPO - SQL", lsSql)
		
	Execute Immediate :lsSQL Using SQLCA;
	Execute Immediate "COMMIT" using SQLCA;

return 0
end function

public function integer uf_validstatuscode (string ascode);string lsStatus

	Select status_code into :lsStatus
	From shipment_status_code
	Where status_code = :asCode;
	//messagebox ("TEMPO", "Valid Status Code: " + lsStatus + ".")
	if isnull(asCode) then
		return -1
	end if
return 0
end function

on w_orphans.create
int iCurrent
call super::create
end on

on w_orphans.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_postopen;call super::ue_postopen;DatawindowChild ldwc //, ldwc2
//messagebox ("TEMP!", "In w_orphans.ue_postopen.")
iw_window = This

//iu_Shipments = Create u_nvo_shipments

tab_main.MoveTab(2, 99) /* search tab always last*/

// Tabs/DW's assigned to Variables
idw_main = tab_main.tabpage_main.dw_master

idw_Search = tab_main.tabpage_search.dw_search_entry
idw_Result = tab_main.tabpage_search.dw_search_result
idw_result.SetTransObject(Sqlca)

idw_si4 = tab_main.tabpage_main.dw_si4
idw_SI4.SetTransObject(SqlCa)

idw_si5 = tab_main.tabpage_main.dw_si5
idw_SI5.SetTransObject(SqlCa)

isle_awb = Tab_main.tabpage_main.sle_awb

icb_reset = Tab_main.tabpage_main.cb_orphan_reset

/*
//Retrieve DDDWS
//Warehouse
idw_search.GetChild("wh_code",ldwc)
ldwc.SetTransObject(SQLCA)
g.of_set_warehouse_dropdown(ldwc) /* load from User Warehouse DS */

idw_main.GetChild("inspection_level",ldwc)
ldwc.SetTransObject(sqlca)
ldwc.Retrieve(gs_project,'IQCIL')

idw_main.GetChild("failure_category",ldwc)
ldwc.SetTransObject(sqlca)
ldwc.Retrieve(gs_project,'IQCFC')

idw_main.GetChild("cause",ldwc)
ldwc.SetTransObject(sqlca)
ldwc.Retrieve(gs_project, 'IQCCC')

/*
//Share Warehouse with Info Tab
idw_main.GetChild("wh_code",ldwc2)
ldwc.ShareData(ldwc2)
*/

*/

isOrigSql_Result = idw_result.GetSqlSelect() /* orig SQL for Search Criteria */
//? isOrigSql_Stats = idw_Stats.GetSqlSelect() /* orig SQL for Search Criteria */
//? why isn't idw_Stats.GetSqlSelect() working?
///isOrigSql_Stats = idw_Result.GetSqlSelect() /* orig SQL for Search Criteria */

idw_search.InsertRow(0)
///idw_stats.InsertRow(0)

This.TriggerEvent("ue_edit")

// We may be coming from Shipment with a selected shipment
If UpperBound(Istrparms.String_arg) > 0 Then // search for shipment
/*TEMPO - Pass/Set Group/Trans Nbrs (or Shipment Nbr) here?
	If Istrparms.String_arg[2] > '' Then
		//is_rono = Istrparms.String_arg[1]
		is_rono = Istrparms.String_arg[2]
		il_LineNo = Istrparms.Long_arg[3]
		is_sku = Istrparms.String_arg[4]
		//what about nulls?
		is_UF1 = Istrparms.String_arg[5]
		This.TriggerEvent('ue_retrieve')
	End If
*/
	//isle_awb.text = Istrparms.String_arg[1]
	//This.TriggerEvent('ue_retrieve')
	//is_awb = Istrparms.String_arg[1]
	if Istrparms.String_arg[1] <> '' then
		idw_Search.SetItem(1, 'car_ref_nbr', Istrparms.String_arg[1])
		iw_window.TriggerEvent('ue_search')
	end if
	tab_main.SelectTab(2)
//	tab_main.tabpage_search.cb_search.click()
End If

end event

event ue_edit;call super::ue_edit;// Acess Rights

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False

// Changing menu properties
//im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()

//? wf_clear_screen()

//TEMP isle_code.Visible=True
//TEMP is_roNo = ''
//TEMP isle_code.DisplayOnly = False
//TEMP isle_code.TabOrder = 10
//TEMP isle_code.SetFocus()


end event

event ue_new;call super::ue_new;//From w_ro.ue_new....
string ls_Prefix,ls_order
long ll_no

// Acess Rights
If f_check_access(is_process,"N") = 0 Then Return

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

// Clear existing data
This.Title = is_title + " - New"
ib_edit = False
ib_changed = False
//ibConfirmrequested = False

///isle_code.text = ""
//isle_order2.text = ""

wf_clear_screen()

idw_main.InsertRow(0)
//wf_checkstatus()

idw_main.Show()
idw_main.SetFocus()
//idw_main.SetColumn("supp_invoice_no")

end event

event ue_save;call super::ue_save;//from w_ro.ue_save...
Integer li_ret //,li_ret_l,li_ret_ll,li_return

//long i,ll_totalrows, ll_no

String	ls_Order, lsRONO, lsOrdStat

//IF f_check_access(is_process,"S") = 0 THEN Return -1

// Validations

SetPointer(HourGlass!)

If idw_main.RowCount() > 0 Then
	//idw_main.SetItem(1,'last_update',Today()) 
	//idw_main.SetItem(1,'last_user',gs_userid)
	If wf_validation() = -1 Then
		SetMicroHelp("Save failed!")
		Return -1
	End If
End If

// Assign Order No.

/*
ib_edit = ib_edit

If ib_edit = False Then
	
	
Else /*updating existing record*/
	
	
End If
*/

Execute Immediate "Begin Transaction" using SQLCA; //dts 6/16/06 - added 'Begin Transaction'

// Updating the Datawindow

If idw_main.RowCount() > 0 Then
	li_ret = idw_main.Update()
	if li_ret = 1 then li_ret = idw_si4.Update()
//Else 
//	li_ret = 1
End If


/*
if li_ret = 1 then li_ret = idw_putaway.Update()
if li_ret = 1 then li_ret = idw_content.Update()
If idw_main.RowCount() = 0 and li_ret = 1 Then li_ret = idw_main.Update()
*/

IF li_ret = 1 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		If idw_main.RowCount() > 0 Then 
			ib_changed = False
			ib_edit = True
			This.Title = is_title  + " - Edit"
//			wf_checkstatus()
			SetMicroHelp("Record Saved!")
		End If
		uf_applyStatus()
		Return 0
   ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
      MessageBox(is_title, SQLCA.SQLErrText)
		Return -1
   END IF
ELSE
   Execute Immediate "ROLLBACK" using SQLCA;
	SetMicroHelp("Save failed!")
	MessageBox(is_title, "System error, record save failed!")
	Return -1
END IF


end event

event open;call super::open;Istrparms = Message.PowerObjectParm

end event

event ue_retrieve;call super::ue_retrieve;
// lsSKU,
String lsLastLvl, lsCurLvl, lsPassFail
Long	llCount, llRowPos, llInspections, llAccepted, llMonths
datastore ldsStats
DateTime ldLastDT, ldCurDt
boolean lbNoFailures

string ls_sql, ls_where

//Set bol = current text
//lsSKU = This.Text

//If the Group/Trans Nbrs have been set...
	IF is_GroupNbr > '' and is_TransNbr > '' THEN

		/*?
		IF SQLCA.sqlcode <> 0 THEN
			MessageBox(is_title, "IQC Record not found, please enter again!", Exclamation!)
			isle_code.SetFocus()
			isle_code.SelectText(1,Len(is_SKU))
			RETURN
		End If
		*/
	END IF

IF is_GroupNbr = "" THEN RETURN

idw_main.Retrieve(is_GroupNbr, is_TransNbr)
//should we be retrieving based on si1_seq?

IF idw_main.RowCount() > 0 Then
/*
	wf_checkstatus()
	
	If idw_main.GetItemString(1, "ord_status") <> "C" and &
		idw_main.GetItemString(1, "ord_status") <> "V" Then
		iw_window.TriggerEvent("ue_refresh")
	End If
	*/
	ib_changed = False
/*
	idw_main.Show()
	idw_stats.show() //show this dw on top of dw_Main
	idw_main.SetFocus()
	isle_code.Visible = FALSE	
*/
ELSE
/*///
	idw_main.InsertRow(0)
	idw_main.SetItem(1, "ro_no", is_rono)
	idw_main.SetItem(1, "line_item_no", il_LineNo)
	idw_main.SetItem(1, "Original_Inv_Type", is_UF1)
	idw_main.SetFocus()
	ib_changed = True
	*/
END IF
tab_main.SelectTab(1)
idw_main.Show()
//idw_stats.show() //show this dw on top of dw_Main
icb_reset.show()
idw_main.SetFocus()
//idw_SI4.SetTransObject(SqlCa)
idw_si4.retrieve(is_GroupNbr, is_TransNbr)
idw_si5.retrieve(is_GroupNbr, is_TransNbr)
///isle_code.Visible = FALSE	

end event

event ue_clear;call super::ue_clear;wf_clear_screen()
end event

event resize;call super::resize;tab_main.Resize(workspacewidth() - 20,workspaceHeight())
//tab_main.tabpage_main.dw_iqc.Resize(workspacewidth() - 80,workspaceHeight()-300)
tab_main.tabpage_search.dw_search_result.Resize(workspacewidth() - 120, workspaceHeight()-700)

end event

type tab_main from w_std_master_detail`tab_main within w_orphans
integer width = 3237
integer height = 1740
end type

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
event create ( )
event destroy ( )
integer width = 3200
integer height = 1612
string text = "Orphaned Status"
cb_orphan_reset cb_orphan_reset
dw_si5 dw_si5
dw_si4 dw_si4
sle_awb sle_awb
dw_master dw_master
end type

on tabpage_main.create
this.cb_orphan_reset=create cb_orphan_reset
this.dw_si5=create dw_si5
this.dw_si4=create dw_si4
this.sle_awb=create sle_awb
this.dw_master=create dw_master
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_orphan_reset
this.Control[iCurrent+2]=this.dw_si5
this.Control[iCurrent+3]=this.dw_si4
this.Control[iCurrent+4]=this.sle_awb
this.Control[iCurrent+5]=this.dw_master
end on

on tabpage_main.destroy
call super::destroy
destroy(this.cb_orphan_reset)
destroy(this.dw_si5)
destroy(this.dw_si4)
destroy(this.sle_awb)
destroy(this.dw_master)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer width = 3200
integer height = 1612
dw_search_result dw_search_result
cb_orphan_search cb_orphan_search
dw_search_entry dw_search_entry
end type

on tabpage_search.create
this.dw_search_result=create dw_search_result
this.cb_orphan_search=create cb_orphan_search
this.dw_search_entry=create dw_search_entry
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_search_result
this.Control[iCurrent+2]=this.cb_orphan_search
this.Control[iCurrent+3]=this.dw_search_entry
end on

on tabpage_search.destroy
call super::destroy
destroy(this.dw_search_result)
destroy(this.cb_orphan_search)
destroy(this.dw_search_entry)
end on

type cb_orphan_reset from commandbutton within tabpage_main
string tag = "Resets Transaction for re-application"
integer x = 2624
integer y = 176
integer width = 402
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reset"
end type

event clicked;idw_main.SetItem(1, 'SIRS_ID', 2)
ib_changed = true

end event

event constructor;
g.of_check_label_button(this)
end event

type dw_si5 from datawindow within tabpage_main
integer x = 27
integer y = 1184
integer width = 3136
integer height = 376
integer taborder = 50
boolean titlebar = true
string title = "SI5 - OSD"
string dataobject = "d_orphan_si5"
boolean livescroll = true
end type

event constructor;
g.of_check_label(this) 
end event

type dw_si4 from datawindow within tabpage_main
integer x = 27
integer y = 792
integer width = 3136
integer height = 376
integer taborder = 40
boolean titlebar = true
string title = "SI4 - Status Codes"
string dataobject = "d_orphan_si4"
boolean livescroll = true
end type

event itemchanged;idw_main.SetItem(1, 'SIRS_ID', 2)
ib_changed = true
//make sure dw_si4 is being saved....
end event

event constructor;
g.of_check_label(this) 
end event

type sle_awb from singlelineedit within tabpage_main
integer x = 571
integer y = 296
integer width = 809
integer height = 88
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;/*iqc
long llCount
is_sku = This.Text
	/*If entering a SKU to start, check to see if existing IQC records exist
	  - If One, retrieve it, If more than one show Search grid
	  If coming from w_ro with Detail Line selected (or coming from search grid), Retrieve
	  */
	  
//if 'modified' was called from search screen, retrieve iqc record...
if is_rono = '' or isnull(is_rono) then
	Select Count(*) into :llCount
	FROM Receive_IQC IQC, Receive_Master RM, Receive_Detail RD
	WHERE iqc.RO_No = RM.RO_No
	and iqc.RO_No = RD.RO_No and iqc.Line_Item_No = RD.Line_Item_No
	and SKU = :is_SKU and project_id = :gs_project;
	
	If llCount = 0 or SQLCA.sqlcode <> 0 THEN
		MessageBox(is_title, "IQC Record not found!", Exclamation!)
		isle_code.SetFocus()
		isle_code.SelectText(1,Len(is_SKU))
		RETURN
	ElseIf llCount > 1 Then 
		Messagebox(is_title,"Multiple records found for this SKU, please select from search tab!")
		//SetItem for SKU on dw_search_entry (idw_Search)?
		isle_code.SetFocus()
		isle_code.SelectText(1,Len(is_SKU))
		Return
	end if 
end if
	//Else /* one record found or called from grid */
		Select IQC.ro_no, IQC.line_item_no into :is_rono, :il_LineNo
		FROM Receive_IQC IQC, Receive_Master RM, Receive_Detail RD
		WHERE iqc.RO_No = RM.RO_No
		and iqc.RO_No = RD.RO_No and iqc.Line_Item_No = RD.Line_Item_No
		and SKU = :is_SKU and project_id = :gs_project;
		iw_window.TriggerEvent('ue_Retrieve')
	//end if
*/
return

end event

type dw_master from u_dw_ancestor within tabpage_main
event ue_post_check_status ( )
integer x = 27
integer y = 32
integer width = 3136
integer height = 712
integer taborder = 30
string dataobject = "d_orphan_master"
borderstyle borderstyle = stylebox!
end type

event itemerror;//Choose Case dwo.name
//	Case "supp_code"
//		Return 1
//	Case Else
//		Return 2
//End Choose

Return 2
end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event ue_postitemchanged;call super::ue_postitemchanged;idw_main.SetItem(1, 'SIRS_ID', 2)
ib_changed = true
//messagebox ("TEMPO", "CHANGED")
end event

type dw_search_result from u_dw_ancestor within tabpage_search
integer x = 46
integer y = 560
integer width = 2971
integer height = 952
integer taborder = 30
string dataobject = "d_orphan_search_result"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

event doubleclicked;// Pasting the record to the main entry datawindow
//string ls_code

IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	If ib_changed = False and ib_edit = True Then
		//ls_code = this.getitemstring(row,'supp_invoice_no')
		//ls_code = this.getitemstring(row,'sku')
		///is_sku = this.getitemstring(row,'sku')
		///is_rono = this.getitemstring(row,'ro_no')
		///il_lineno = this.getitemNumber(row,'line_item_no')

		is_GroupNbr = this.getitemstring(row,'si1_GroupControlNbr')
		is_TransNbr = this.getitemstring(row,'si1_TransactionControlNbr')
		iw_window.TriggerEvent('ue_retrieve')
		//isle_code.text = ls_code
		//isle_code.TriggerEvent(Modified!)
	End If
END IF
end event

type cb_orphan_search from commandbutton within tabpage_search
integer x = 2661
integer y = 376
integer width = 274
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;iw_window.TriggerEvent('ue_search')
/*
DateTime ldt_date
String ls_string, ls_where, ls_sql 
Boolean lb_order_from, lb_order_to, lb_sched_from, lb_sched_to, lb_complete_from, lb_complete_to
Boolean lb_where
Boolean lsuseSku,lsuseCONTID,lsusePONO
//Initialize Date Flags
lb_order_from 		= FALSE
lb_order_to 		= FAlSE
lb_sched_from 		= FALSE
lb_sched_to 		= FALSE
lb_complete_from 	= FALSE
lb_complete_to 	= FALSE

If idw_search.AcceptText() = -1 Then Return

//idw_search.Reset()
idw_result.Reset()
ls_sql = isOrigSql_Result
lb_where = False

//ls_where = " and receive_master.project_id = '" + gs_project + "' "
//ls_where = " and receive_iqc.ro_no like '" + gs_project + "%' "

/*
ldt_date = idw_search.GetItemDateTime(1,"ord_date_s")
If  Not IsNull(ldt_date) Then
	ls_where += " and receive_master.ord_date >= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_order_from = TRUE
	lb_where = TRUE
End If

ldt_date = idw_Search.GetItemDateTime(1,"ord_date_e")
If  Not IsNull(ldt_date) Then
	ls_where += " and receive_master.ord_date <= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_order_to = TRUE
	lb_where = TRUE
End If

*/
ls_string = idw_Search.GetItemString(1,"car_ref_nbr")
if not isNull(ls_string) and trim(ls_string)<>'' then
	ls_where += " and si1_CarrierRefNbr = '" + ls_string + "' "
	lb_where = TRUE
end if

ls_string = idw_Search.GetItemString(1,"ship_ref_nbr")
if not isNull(ls_string) and trim(ls_string)<>'' then
	ls_where += " and si1_ShpperRefNbr = '" + ls_string + "' "
	lb_where = TRUE
end if


//Check Order Date range for any errors prior to retrieving
IF ((lb_order_to = TRUE and lb_order_from = FALSE) 	OR &
	 (lb_order_from = TRUE and lb_order_to = FALSE)  	OR &
	 (lb_order_from = FALSE and lb_order_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Order Date Range", Stopsign!)
	Return
END IF

ls_sql += ls_where + "order by SI1_ReceivedDate desc, SI4_Statusdate desc"

idw_result.SetSqlSelect(ls_sql)

If idw_result.Retrieve() = 0 Then
	messagebox(is_title,"No records found!")
End If
*/
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_search_entry from datawindow within tabpage_search
integer x = 37
integer y = 36
integer width = 2953
integer height = 496
integer taborder = 20
string title = "none"
string dataobject = "d_orphan_search_entry"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;g.of_check_label(this) 
end event

