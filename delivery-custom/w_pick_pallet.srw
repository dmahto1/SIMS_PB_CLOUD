HA$PBExportHeader$w_pick_pallet.srw
$PBExportComments$F8117 I1026 Google Pick Pallet
forward
global type w_pick_pallet from w_response_ancestor
end type
type dw_1 from u_dw_ancestor within w_pick_pallet
end type
type dw_2 from u_dw_ancestor within w_pick_pallet
end type
type st_1 from statictext within w_pick_pallet
end type
type sle_1 from singlelineedit within w_pick_pallet
end type
type cb_1 from commandbutton within w_pick_pallet
end type
type cb_2 from commandbutton within w_pick_pallet
end type
type cb_3 from commandbutton within w_pick_pallet
end type
type cb_4 from commandbutton within w_pick_pallet
end type
type st_msg from statictext within w_pick_pallet
end type
type cb_5 from commandbutton within w_pick_pallet
end type
type st_msg2 from statictext within w_pick_pallet
end type
type lb_carton_list from listbox within w_pick_pallet
end type
type sle_palletid from singlelineedit within w_pick_pallet
end type
type sle_containerid from singlelineedit within w_pick_pallet
end type
type cb_genpallet from commandbutton within w_pick_pallet
end type
type cb_gencon from commandbutton within w_pick_pallet
end type
type dw_3 from u_dw within w_pick_pallet
end type
type sle_2 from u_dw_microhelp within w_pick_pallet
end type
type st_2 from statictext within w_pick_pallet
end type
type st_3 from statictext within w_pick_pallet
end type
end forward

global type w_pick_pallet from w_response_ancestor
integer y = 360
integer height = 1466
string title = "Partial Pallet/Container Selection"
boolean center = true
event ue_container_adjust ( )
event ue_keydown pbm_dwnkey
event type long ue_print_labels ( )
event ue_split_mixed_pallet ( )
event ue_split_mixed_container ( )
event ue_split_mixed_serial ( )
event ue_split_container ( )
event ue_add_serial_numbers ( )
event type long ue_print2_labels ( )
dw_1 dw_1
dw_2 dw_2
st_1 st_1
sle_1 sle_1
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
st_msg st_msg
cb_5 cb_5
st_msg2 st_msg2
lb_carton_list lb_carton_list
sle_palletid sle_palletid
sle_containerid sle_containerid
cb_genpallet cb_genpallet
cb_gencon cb_gencon
dw_3 dw_3
sle_2 sle_2
st_2 st_2
st_3 st_3
end type
global w_pick_pallet w_pick_pallet

type variables
Str_parms	ipStrParms
Str_parms	ipSerParms
datastore ids1, ids2, ids3
datastore idsSerial
u_ds_ancestor idsAdjustment
u_ds_ancestor idsContent
u_ds_ancestor idsContentSummary
u_ds_ancestor idsNewContentSummary
u_ds_ancestor idsPickDetail
u_ds_ancestor idsSerialValidate

w_adjust_pallet iw_parent
boolean ib_Print, ibChecked1, ibChecked2
Boolean ibValidContainer, ibSerialChanged, ibChanged, ibSNChanged, ibGenPalletId, ibGenContainerId

u_nvo_websphere_post	iuoWebsphere
inet	linit

datawindow idw_pick, idw_transfer_detail_content, idw_pick_detail
datetime idtToday
String  isSKU, isPoNo2, isContainerId, isOrigContainer, isDoNo, isStatus, isTitle, isNewPoNo2
String isScanned, isFind, isFind2, isInvoiceNo, isWhCode, isOrderType		//Outbound order = NULL, SOC, Stock Transfer
String isError, isSupplier, isInvType, isLotNo, isPoNo, isZoneId, isCOO, isRoNo, isPreview
Int iiFound, iiClickedRow1, iiClickedRow2, iiSelPos, iiMove, iiNbrSerials
Long ilOwnerId, ilCompNo, llSplitParticipants	//Nbr of participating containers in a split (split containers plus full containers)
Long ilOrigQty, ilNewAllocQty, ilNewContainerQty, ilDetailReqQty, ilPickQty, ilSelectedSerialRows
Long ilSerialInventoryRows, ilContentSummaryRow, ilNewContentRow, ilPickRows, ilSerialRows, ilThisQty
Long ilContentSummaryRows, ilContentSummaryPos, ilContentRows, ilContentRow, ilContentPos, ilPickPos, ilNbrAdjustments
Long ilTfrInQty, ilTfrOutQty, ilAllocQty, ilAvailQty, ilDetailAllocQty, ilFound, ilFound1, ilAdjustNo
TreeViewItem itvi_1, itvi_2

Int iiPrevRow, iiCurrRow, iiCurrPickRow, iiRC2, iiPos, iiRC, iiCnt, iiSplit, iiMultiRono
String isThisContainer, isPrevContainer, isContainerToSplit, isContainersToSplit, isNewContainer, isWhere, isContainers
String isPrevLevel, isCurrLevel, isSerialNo, isContinue, isCompletionMessage, isErrText, isSort, isFilter
Boolean ibKeyCntl, ibKeyShift
String isColorCode, isMixedType, isReallocateInd, isMessage, isPickedSerials, isPickedSerials2, isLocation, isTag, is_sLocation, is_dLocation
String isOldC[], isNewC[]
Boolean ibPharmacyProcessing		//GailM 12/02/2019 Add check for Pharmacy Processing
end variables

forward prototypes
public subroutine dodisplaymessage (string _title, string _message)
public function integer resethighlight ()
public function integer getadjustmentrecord (integer airc, datastore ascontent, integer airec)
public function integer wf_retrieve_pick_detail (integer airow)
public function integer wf_update_content_server ()
public function integer wf_set_pick_filter (string as_action, string as_filter)
public function integer wf_print_2d_barcode_label (str_parms astr_serial_parms, string as_sku, string as_wh, string as_pallet_container_id, string as_label_text, integer ai_print_option)
public function str_parms wf_split_serialno_by_length (str_parms as_str_serial_no, long al_length)
public function string wf_generate_sscc (string as_pallet_container_id)
public function string wf_read_label_format (string asformat_name)
public function string wf_replace (string asstring, string asoldvalue, string asnewvalue)
public function long wf_print_label_data (string as_print_text, string as_print_data, integer ai_print_option)
public function str_parms str_initalize (str_parms astr_parms)
public function integer wf_mixed_containerization ()
public function string getcontainerlist (datawindow adw, datastore ads, string aspono2)
public function string getmultirono ()
public function long myserialfilter (datastore adsserial, string aspicked, string aspicked2)
end prototypes

event ue_container_adjust();Integer i, j

idsNewContentSummary = Create u_ds_ancestor
idsNewContentSummary.dataobject = 'd_content_summary_pallet'
idsNewContentSummary.SetTransObject(SQLCA)

idsAdjustment = Create u_ds_ancestor
idsAdjustment.dataobject =  'd_container_adjustment'
idsAdjustment.SetTransObject(SQLCA)

idsAdjustment.Reset( )

idsSerial = Create datastore
idsSerial.dataobject = 'd_serial_container'
idsSerial.SetTransObject(SQLCA)

ilPickRows 			= ids3.rowcount()			//Un-saved pick row to be container split
ilNewContainerQty 	= ids1.RowCount()			//Number of serial records to save with new po_no2/Carton_Id
ilNewAllocQty 		= ids2.RowCount()			//Number of serial records to leave in original po_no2/Carton_Id

iiCnt = 0
isContinue = 'Y'
isReallocateInd = 'N'
ibChecked1 = FALSE
ibChecked2 = FALSE

//Check for multi-container breaking for refusal
isContainersToSplit = ""
For i = 1 to ilNewContainerQty
	isContainerId = ids1.GetItemString( i, 'carton_id' )
	isFind = "carton_id = '" + isContainerId + "' "
	ilFound1 = ids2.Find( isFind, 1, ilNewAllocQty )
	If ilFound1 > 0 Then
		iiCnt ++
		isContainersToSplit += isContainerId
	End If
	isFind = "container_id = '" + isContainerId + "' "
	ilFound1 = idw_pick.Find(isFind, 1, idw_pick.rowcount() )
	If ilFound1 = 0 Then		//Not in pick list - Add it!



	End If
Next

If isContinue = "Y" Then
	isSort = "po_no2, container_id"
	idtToday = f_getLocalWorldTime( isWhCode ) 
	If isOrderType = 'SOC' or isOrderType = 'StockTransfer' Then
		isDoNo = ids3.GetItemString( ilPickRows, "to_no" )
		isCompletionMessage = "Container " + isContainerId + " has been split.~n~r"
	Else
		isDoNo = ids3.GetItemString( ilPickRows, "do_no" )	//DE12388
		If isPoNo2 = gsFootPrintBlankInd Then
			isCompletionMessage = "Mixed Containerization " + isPoNo2 + "/" + isContainerId + " has been split for shipment.~n~r"
		Else
			isCompletionMessage = "Pallet " + isPoNo2 + " has been split for shipment.~n~r"
		End If
	End If
	
	ilDetailAllocQty = 0
	isPrevContainer = ""
	ids3.Reset()
	iiCnt = 0
	for i = 1 to ids2.rowcount()
		isThisContainer = ids2.GetItemString( i, "carton_id" )
		If isThisContainer <> isPrevContainer Then
			isPrevContainer = isThisContainer
			j = ids3.InsertRow(0)
			iiCnt = 1
			ids3.SetItem( j, "container_id", isThisContainer )
			ids3.SetItem( j, "quantity", iiCnt )
		Else
			iiCnt ++
			ids3.SetItem( j, "quantity", iiCnt )
		End If
		ilDetailAllocQty ++
	Next
	
	ids3.SetSort("container_id asc")
	ids3.Sort()
	
	If ilDetailAllocQty <> ilDetailReqQty Then
		isMessage = "Allocated vs Required Quantity mismatch.~r   Allocated: "  + string(ilDetailAllocQty) + " vs Required: " + string(ilDetailReqQty) + &
							"~n~r~rDo you wish to continue picking serial numbers?"
		iiRC = MessageBox("Checking containers for action", isMessage,  Question!, YesNo!)
		If iiRC <> 1 Then
			isContinue = "N"
		Else
			isContinue = "X"		//Move back to selecting serials without closing window
		End If
	End If
End If

If  isContinue = "Y" Then

	ilPickQty = 0
	If isPoNo2 = gsFootPrintBlankInd Then
		isFilter = "SKU = '" + isSKU + "' and container_id = '" + isThisContainer + "' "
	Else 
		isFilter =  "SKU = '" + isSKU + "' and po_no2 = '" + isPoNo2 + "' "
	End If
	wf_set_pick_filter("Set", isFilter)
	For i = 1 to idw_pick.rowcount()
		If idw_pick.GetItemString( i, "container_id" ) = isThisContainer Then		//Another container on this order can with the same palletId can process
			ilPickQty = ilPickQty + idw_pick.GetItemNumber( i, "quantity" )
		End If
	Next
	//wf_set_pick_filter("Remove","")
	idw_pick.SetSort("container_id asc")
	
	
	If isOrderType = 'SOC' or isOrderType = 'StockTransfer' Then
		for i = 1 to ids3.rowcount()		//Find isContainerToSplit
			for j = 1 to idsContentSummary.rowcount()
				ilThisQty = idsContentSummary.getitemnumber(j,'avail_qty') + idsContentSummary.getitemnumber(j,'tfr_out')
				ilTfrInQty = idsContentSummary.getitemnumber(j,'tfr_in')
				
				if idsContentSummary.getitemstring(j, 'container_id') = ids3.getitemstring(i,'container_id')  and ids3.getitemnumber(i, 'quantity') < ilThisQty and ilTfrInQty = 0 then
					isContainerToSplit += ids3.getitemstring(i,'container_id')
				End if
			next
		next
	Else
		//GailM 4/10/2019 DE9909 - Google - Footrprint container split issue - Allow scan of serial numbers for any container on the pallet
		//GailM 12/2/2019 Turn Pharmacy Processing Off unless asked for through a checkbox
		If ibPharmacyProcessing Then
			For i = 1 to ids3.rowcount()		//Reallocate the content summary records according to ids3 
				isFind = "container_id = '" + ids3.GetItemString(i, 'container_id') + "' "
				ilFound = idw_pick.Find( isFind, 1, idw_pick.rowcount() )
				If ilFound = 0 Then
					iiRC2 = idw_pick.RowsCopy(1, 1, Primary!, idw_pick, idw_pick.rowcount()+1, Primary!)
					iiRC2 = idw_pick.RowCount()	//New row added at end of data
					
					iiRC = idw_pick.SetItem( iiRC2, "container_id", ids3.GetItemString( i, "container_id") )
					iiRC = idw_pick.SetItem( iiRC2, "quantity", ids3.GetItemNumber( i, "quantity") )
					iiRC = idw_pick.SetItemStatus ( iiRC2, "container_id", Primary!, DataModified!)
					iiRC = idw_pick.SetItemStatus ( iiRC2, "quantity", Primary!, DataModified!)
					isReallocateInd = 'Y'
				Else
					If ids3.GetItemNumber( i, "quantity") <> idw_pick.GetItemNumber( ilFound, "quantity")  Then
						//iiRC = idw_pick.SetItem( ilFound, "container_id", ids3.GetItemString( i, "container_id") )  //unneeded
						iiRC = idw_pick.SetItem( ilFound, "quantity", ids3.GetItemNumber( i, "quantity") )
						iiRC = idw_pick.SetItemStatus ( ilFound, "container_id", Primary!, DataModified!)
						iiRC = idw_pick.SetItemStatus ( ilFound, "quantity", Primary!, DataModified!)
					End If
				End If
			Next
			For i = idw_pick.rowcount() to 1 Step -1
				isFind = "container_id = '" + idw_pick.GetItemString(i, 'container_id') + "' "
				ilFound = ids3.Find( isFind, 1, ids3.rowcount() )
				If ilFound = 0 and idw_pick.GetItemString(i, 'po_no2') <> 'NA' Then		//Delete pick row if not a Mixed Containerization pallet
					iiRC = idw_pick.DeleteRow(i)
					isReallocateInd = 'Y'
				End If
			Next
			If isReallocateInd = 'Y' Then
				If wf_update_content_Server() = -1 Then 																																		
					messagebox("Reallocate ContainerID during selection","Error while re-allocating from containerID " + isOrigContainer + " to new containerID " + isContainerToSplit + ".")
					This.TriggerEvent("ue_close")
				Else
					idw_pick.ResetUpdate()
					// Re-retreive content and content summary to show new allocations be proceeding to next level
					ilContentSummaryRows = idsContentSummary.Retrieve( gs_project, isWhCode, isSKU, isPoNo2)		//All content summary rows for the pallet
					ilContentRows = idsContent.Retrieve( gs_project, isWhCode, isSKU, isPoNo2)		//All content rows for the pallet
					idsContentSummary.SetSort(isSort)
					idsContentSummary.Sort()
				End If
			End If
		End If
	End If
	isMessage = ""						
	
	If isPoNo2 = gsFootPrintBlankInd and isThisContainer = gsFootPrintBlankInd Then
		//Do not need this message for loose serials
	Else
		//Determine which containers are shipping and which are staying and which container(s) to split
		//ilDetailAllocQty = 0		//Recheck detail allocated qty		
		If isOrderType <> 'StockTransfer' Then
			//Filter content if mixed containerization
			If isMixedType = 'S' then		//MC for loose serials - use location
				isFilter = "l_code = '" + isLocation + "' "
				idsContentSummary.SetFilter(isFilter)
				idsContentSummary.Filter()
			End If
			For iiRC = 1 to idsContentSummary.RowCount()
				isThisContainer = idsContentSummary.GetItemString( iiRC, "container_id" )
				ilThisQty = idsContentSummary.GetItemNumber( iiRC, "avail_qty" )
				iiCnt = 0
				For i = 1 to ids1.rowcount()
					If ids1.GetItemString( i, "carton_id" ) = isThisContainer Then
						iiCnt ++
					End If
				Next
				
				//20-MAR-2019 :Madhu S30668 Mixed Containerization
				IF isThisContainer ='-' or isThisContainer = gsFootPrintBlankInd THEN 
					ibValidContainer =FALSE
				ELSE
					ibValidContainer =TRUE
				END IF
	
				If iiCnt > 0 Then	//Carton in original
					
					//20-MAR-2019 :Madhu S30668 Mixed Containerization
					IF ibValidContainer THEN
						isMessage += string(iiCnt) + " items for Container " + isThisContainer
					ELSE
						isMessage += string(iiCnt) + " items for Pallet " + isPoNo2
					END IF
					
					isFind = "carton_id = '" + isThisContainer + "' "
					ilFound = ids2.Find(isFind,1,ids2.rowcount())
					If isOrderType = 'SOC' Then
						If ilFound > 0 Then
							isMessage += " will have new pallet  id and container id for this order.~n~r~r"
						Else
							isMessage += " will have new pallet retaining the original container id for this order.~n~r~r"
						End If
					Else
						If ilFound > 0 Then
							isMessage += " will stay in inventory with a new pallet and container id.~n~r~r"
							//If isContainerToSplit = '' Then isContainerToSplit += isThisContainer
							isContainerToSplit += isThisContainer
						Else
							isMessage += " will stay in inventory with a new pallet retaining original container id.~n~r~r"
						End If
					End If
				End If
				iiCnt = 0
				For i = 1 to ids2.rowcount()
					If ids2.GetItemString( i, "carton_id" ) = isThisContainer Then
						iiCnt ++
					End If
				Next
				If iiCnt > 0 Then
					If isOrderType = 'SOC'  Then
						
						//20-MAR-2019 :Madhu S30668 Mixed Containerization - START
						IF ibValidContainer THEN
							isMessage += string(iiCnt) + " items for Container " + isThisContainer + " will retain pallet and container id.~n~r~r"
						ELSE
							isMessage += string(iiCnt) + " items for Pallet " + isPoNo2 + " will retain pallet.~n~r~r"
						END IF
					Else
						IF ibValidContainer THEN
							isMessage += string(iiCnt) + " items for Container " + isThisContainer + " will ship on this order.~n~r~r"
						ELSE
							isMessage += string(iiCnt) + " items for Pallet " + isPoNo2 + " will retain pallet.~n~r~r"
						END IF
						//20-MAR-2019 :Madhu S30668 Mixed Containerization - END
					End If
	
					//ilDetailAllocQty += iiCnt
				End If
			Next
			idsContentSummary.SetFilter("")
			idsContentSummary.Filter()
		Else
			idsContentSummary.SetFilter("tfr_in = 0")			//Do not touch the new tfr in row
			idsContentSummary.Filter()
			For iiRC = 1 to idsContentSummary.rowcount()	//Stock Transfer assumes the status is processing and quantities have been allocated
				isThisContainer = idsContentSummary.GetItemString( iiRC, "container_id" )
				ilAvailQty = idsContentSummary.GetItemNumber( iiRC, "avail_qty" )
				ilTfrOutQty = idsContentSummary.GetItemNumber( iiRC, "tfr_out" )
				ilTfrInQty = idsContentSummary.GetItemNumber( iiRC, "tfr_in" )
				If ilAvailQty > 0 and ilTfrOutQty= 0 Then				//This Pallet/Container is not allocated and will move
					isMessage += string(ilAvailQty) + " items for Container " + isThisContainer + " will move to new pallet retaining original container id.~n~r~r"
				ElseIf ilTfrOutQty > 0 Then
					isMessage += string(ilAvailQty) + " items for Container " + isThisContainer + " will retain original container while " + string(ilTfrOutQty) + " will remain for transfer.~n~r~r"
					//ilDetailAllocQty += ilTfrOutQty
				End If
			Next
		End If
	End If
	wf_set_pick_filter("Remove","")
	idw_pick.SetSort("line_item_no asc")
	idw_pick.Sort()
	
	If ilDetailAllocQty = ilDetailReqQty and ilPickQty = ilDetailReqQty Then
		isMessage += "Allocated correct number of items to satisfy detail req qty: " + string(ilDetailReqQty) + "~n~rDo you wish to continue with split?"
		If MessageBox("Continue to Split Container.", isMessage, Question!, YesNo!) = 1 Then
			//GailM 6/14/2019 - DE11156 Google Mixed Containerization - dynamic breaking
			/******* END OF COLLECTING DATA AND DETERMININE STATUS ********/
			If isColorCode = "8" and isMixedType = 'C' Then
				this.TriggerEvent("ue_split_mixed_container")
			ElseIf isColorCode = "8" and isMixedType = 'P' Then
				this.TriggerEvent("ue_split_mixed_pallet")
			ElseIf isColorCode = "8" and isMixedType = 'S' Then
				this.TriggerEvent("ue_split_mixed_serial")
			Else
				this.TriggerEvent("ue_split_container")
			End If
			
			//GailM 12/6/2019 DE13724 Google Mixed containerization issue
			isContainers = f_parse_array_to_string(isOldC[])
			
			w_main.setMicroHelp("Saving Container Split data...")	
			If	messagebox("Splitting a Container","We are ready to split the container.  Do you wish to continue?", Question!, YesNo! ) = 1 Then
				Execute Immediate "Begin Transaction" using SQLCA; /*PCONKL - Auto Commit Turned on to eliminate DB locks*/
					iiRC = idsSerial.update()
					If iiRC = 1 Then
						If isReallocateInd = 'N' Then   //Only if reallocation was not done above
							iiRC = idsContentSummary.update()
						End if
						If iiRC = 1 Then
							iiRC = idsContent.update()
							If iiRC = 1 Then
								iiRC = idsAdjustment.update()
								If iiRC = 1 Then
									iiRC = idsNewContentSummary.update()
									If iiRC = 1 Then
										//Execute Immediate "Rollback" Using Sqlca;
										Execute Immediate "Commit" Using Sqlca;

											// Get the last two Adjustment No to report.
											select max(adjust_no) into :ilAdjustNo from Adjustment 
											Where project_id = :gs_project and sku = :isSku and last_user = :gs_userid and last_update = :idtToday;
											
										If ilAdjustNo > 0 Then	//Report adjustment numbers created
											For iiCnt = 1 to ilNbrAdjustments
												isCompletionMessage += "AdjustmentNo" + string(iiCnt) + ": " +String(ilAdjustNo - ilNbrAdjustments + iiCnt)  + "~n~r"
											Next
										End If	
											
										iiRC = f_method_trace_special( gs_project, this.ClassName() + " - ue_container_adjust" , isCompletionMessage, isDoNo,'','',isInvoiceNo)
										MessageBox("Split Container " + string(len(isCompletionMessage)), isCompletionMessage)
										
										//GailM 10/26/2018 DE6979 Second pick row that needs splitting does not show after we split the first one
										//idw_pick.SetItem(iiCurrPickRow, "color_code", "0")	//Turn off green hightlight on po_no2 column - Split successful.
										For i = 1 to idw_pick.rowcount()
											If idw_pick.GetItemString(i, 'po_no2') = isPoNo2 and idw_pick.GetItemString(i, 'color_code') <> "0" Then
												idw_pick.SetItem(i, "color_code", "0")
											End If
										Next
										
										isFilter = "po_no2 = '" + isPoNo2 + "' and container_id <> '" + isNewContainer + "' and container_id <> '" + isContainerId + "' "
										idw_pick.SetFilter(isFilter)
										idw_pick.Filter()
										llSplitParticipants = idw_pick.rowcount()

										If llSplitParticipants > 0 Then		//More that one container in pick list
											isFilter = "po_no2 = '" + isPoNo2 + "' and carton_id <> '" + isNewContainer + "' and carton_id <> '" + isContainerId + "' "
											idsSerial.SetFilter("")
											idsSerial.Filter()
											idsSerial.SetFilter(isFilter)
											idsSerial.Filter()
											isPickedSerials2 = f_parse_datastore_to_string(idsSerial, '')
										End If
										
										isPickedSerials = f_parse_datastore_to_string(ids2, '')
										
										idsSerial.setfilter( "" )
										idsSerial.filter()
										//Filter idsSerial to have only the serial numbers contained in isPickedSerials
										ilSerialRows = mySerialFilter(idsSerial, isPickedSerials, isPickedSerials2)

										//15-MAR-2019 :Madhu S30668 - Mixed Containerization - Prompt a message to user about to Pallet Id (Po No2) - START
										If f_retrieve_parm("PANDORA","FLAG","CONTAINERIZATION") = "Y" Then		//GailM 5/6/2019 Mixed containeriazation flag must be on.
												
											IF this.wf_mixed_containerization( ) = 0 THEN
	
												//Re-retrieve records
												IF isOrderType = 'SOC' or isOrderType = 'StockTransfer' THEN
													//iiCnt = idw_pick.retrieve(gs_project, isDoNo)	//why do we need this?  taken out
												ELSE
													idw_pick.retrieve(isDoNo )
												END IF
											END IF
										End If
										
										//GailM 1/12/2020 DE14137 & DE13138 SOC and ST not resetting pick list filter - causing system error
										idw_pick.SetFilter("")
										idw_pick.Filter()
										//wf_set_pick_filter("Remove","")
										
										//15-MAR-2019 :Madhu S30668 - Mixed Containerization - Prompt a message to user about to Pallet Id (Po No2) - END
										//GailM 12/03/2018 DE7547 Google Dynamic Breaking - AutoPrint Pallet/Carton Labels
										If messagebox("Print Carton and Pallet Labels","Would you like to print carton and pallet labels?",Question!, YesNo!) = 1 Then
											This.TriggerEvent("ue_print2_labels")
										End If
										
										This.TriggerEvent("ue_close")
									ElseIf iiRC = -1 Then
										isMessage = "Error occurred while saving New Content Summary record~r~r" 
										Execute Immediate "Rollback" using SQLCA;
										f_method_trace_special( gs_project, this.ClassName() , isMessage,isDoNo,'','',isInvoiceNo)
										Messagebox("Container Split Process", isMessage)
									ElseIf sqlca.sqlcode <> 0 Then
										isErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
										isMessage = "Database error while saving content data for Adjustment records~r~r" + isErrText
										Execute Immediate "Rollback" using SQLCA;
										f_method_trace_special( gs_project, this.ClassName() , isMessage,isDoNo,'','',isInvoiceNo)
										Messagebox("Container Split Process", isMessage)
									End If
								Else
									If iiRC = -1 Then
										Execute Immediate "Rollback" using SQLCA;
										isMessage =  "Could not save Adjustment data for container split~r~r" + idsContentSummary.isDBErrTExt
										f_method_trace_special( gs_project, this.ClassName() , isMessage,isDoNo,'','',isInvoiceNo)
										Messagebox("Container Split Process", isMessage)
									ElseIf sqlca.sqlcode <> 0 Then
										isErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
										isMessage = "Database error while saving Adjustment data for container split~r~r" + isErrText
										Execute Immediate "Rollback" using SQLCA;
										f_method_trace_special( gs_project, this.ClassName() , isMessage,isDoNo,'','',isInvoiceNo)
										Messagebox("Container Split Process", isMessage)
									End If	
								End If
							Else
								isErrText = idsContent.isdberrtext /*text will be lost after rollback*/
								isMessage = "Database error while saving Content data for container split~r~r" + isErrText
								Execute Immediate "Rollback" using SQLCA;
								f_method_trace_special( gs_project, this.ClassName() , isMessage,isDoNo,'','',isInvoiceNo)
								Messagebox("Container Split Process", isMessage)
							End If
						Else
							isMessage = "Error occurred while saving Content Summary records~r~r" 
							Execute Immediate "Rollback" using SQLCA;
							f_method_trace_special( gs_project, this.ClassName() , isMessage,isDoNo,'','',isInvoiceNo)
								Messagebox("Container Split Process", isMessage)
						End If
					Else
						If sqlca.sqlcode <> 0 Then
							isErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
							isMessage = "Unable to save serial data for container split~r~r" + isErrText
							Execute Immediate "Rollback" using SQLCA;
							f_method_trace_special( gs_project, this.ClassName() , isMessage,isDoNo,'','',isInvoiceNo)
							Messagebox("Container Split Process", isMessage)
						End If
					End If
			Else
				wf_set_pick_filter("Remove","")
				idw_pick.SetSort("line_item_no asc")
				This.TriggerEvent("ue_cancel")
			End If
		Else
			messagebox("Cancelled","No changes have been made!")
			This.TriggerEvent("ue_cancel")
		End If
	Else
		isMessage += "Allocated vs Required Quantity mismatch.~r   Allocated: "  + string(ilDetailAllocQty) + " vs Required: " + string(ilDetailReqQty) + &
							"~n~r~rDo you wish to continue picking serial numbers?"
		iiRC = MessageBox("Checking containers for action", isMessage,  Question!, YesNo!)
		If iiRC <> 1 Then
			wf_set_pick_filter("Remove","")
			This.TriggerEvent("ue_close")
		End If
	End If
Else
	If isContinue = "N" Then
		wf_set_pick_filter("Remove","")
		idw_pick.SetSort("line_item_no asc")
		This.TriggerEvent("ue_close")
	End If
End If
w_main.setMicroHelp("Ready")
end event

event type long ue_print_labels();//Cloned from u_adjust_pallet_merge ue_print_labels
//Use old pallet id (isPoNo2) and new pallet id (isNewPoNo2) to print labels
String 	ls_sql, ls_errors, ls_sscc, ls_string_data
String		lsCarton, lsCartonPrev
long 		ll_row, ll_rowCarton
integer	ll_cnt
integer	li_print_option = 1
str_parms lstr_serialList
str_parms lstr_PalletSerialList
str_parms lstr_initial

Datastore lds_serial

/* START OF LABEL PRINT OF ORIGINAL PALLET */
	lds_serial = create Datastore
	ls_sql = " select * from Serial_Number_Inventory with(nolock) "
	ls_sql += "where Project_Id ='"+gs_project+"' and sku ='"+isSKU+"' "
	ls_sql += "and wh_code ='"+isWhCode+"' "
	If isPoNo2 <> gsFootPrintBlankInd and isPoNo2 <> "" Then
		ls_sql += "and po_no2 ='"+isPoNo2+"' "
	End If
	
	//Mixed Containerization - Get individual serial numbers for 2dBarcode
	If isPoNo2 = gsFootPrintBlankInd or isContainerId = gsFootPrintBlankInd or isNewPoNo2 = gsFootPrintBlankInd or isNewContainer = gsFootPrintBlankInd Then
		ls_string_data = f_parse_datastore_to_string( ids2, "serial_no" )
		If ls_string_data <> "null" Then
			ls_sql += " and serial_no in " + ls_string_data
		End If	
	End If
	
	lds_serial.create( SQLCA.SyntaxFromSql(ls_sql, "", ls_errors))
	lds_serial.settransobject( SQLCA)
	lds_serial.retrieve( )
	
	If isPoNo2 <> gsFootPrintBlankInd or isContainerId <> gsFootPrintBlankInd or isNewPoNo2 <> gsFootPrintBlankInd or isNewContainer <> gsFootPrintBlankInd Then
		IF (len(ls_errors) > 0  or lds_serial.rowcount( ) =0 )Then
			MessageBox("Pallet Label Print", "Unable to retrieve Serial Number Inventory records against Pallet Id "+isPoNo2)
			Return -1
		End IF
	End If
	
	//lb_carton_list lb_carton_list
	lb_carton_list.Reset()
	
	//Get Carton List
	lsCartonPrev = ""
	For ll_row =1 to lds_serial.rowcount( )
		lstr_PalletSerialList.string_arg[ll_row]   =lds_serial.getItemString( ll_row, 'serial_no')
		lsCarton = lds_serial.Object.Carton_Id[ll_row]
		If lsCarton <> lsCartonPrev Then
			lb_carton_list.AddItem(lds_serial.Object.Carton_Id[ll_row])
		End If
		lsCartonPrev = lsCarton
	Next
	
	//Print each carton label
	For ll_rowCarton = 1 to lb_carton_list.TotalItems()
		ll_cnt = 1
		For ll_row = 1 to lds_serial.rowcount()
			If lds_serial.Object.Carton_Id[ll_row] = lb_carton_list.text(ll_rowCarton) Then
				lstr_serialList.string_arg[ll_cnt]  = lds_serial.getItemString( ll_row, 'serial_no')
				ll_cnt++
			End If
		Next
		wf_print_2d_barcode_label( lstr_serialList, isSKU, isWhCode, lb_carton_list.text(ll_rowCarton) , 'CARTON LABEL',li_print_option)
		If ll_rowCarton = 1 Then	 li_print_option = 0
		lstr_serialList = str_initalize(lstr_serialList)
		lstr_serialList =lstr_initial
	Next
	
	//Print Pallet 2D Barcode Label
	wf_print_2d_barcode_label( lstr_PalletSerialList, isSKU, isWhCode, isPoNo2 , 'PALLET LABEL',li_print_option)
	lstr_PalletSerialList = 	str_initalize(lstr_PalletSerialList)
	
/* END OF LABEL PRINT OF ORIGINAL PALLET */

/* START OF LABEL PRINT OF NEW PALLET */
	lds_serial = create Datastore
	ls_sql = " select * from Serial_Number_Inventory with(nolock) "
	ls_sql +="where Project_Id ='"+gs_project+"' and sku ='"+isSKU+"' "
	ls_sql +=" and wh_code ='"+isWhCode+"' and po_no2 ='"+isNewPoNo2+"'"
	
	If isNewPoNo2 = gsFootPrintBlankInd Then	//If pallet id is blank, also query for serial numbers
		ls_string_data = f_parse_datastore_to_string( ids1, "serial_no" )
		If ls_string_data <> "null" Then
			ls_sql += " and serial_no in " + ls_string_data
		End If
	End If

	lds_serial.create( SQLCA.SyntaxFromSql(ls_sql, "", ls_errors))
	lds_serial.settransobject( SQLCA)
	lds_serial.retrieve( )
	
	If isPoNo2 <> gsFootPrintBlankInd and isContainerId <> gsFootPrintBlankInd and isNewPoNo2 <> gsFootPrintBlankInd and isNewContainer <> gsFootPrintBlankInd Then
		IF (len(ls_errors) > 0  or lds_serial.rowcount( ) =0 )Then
			MessageBox("Pallet Label Print", "Unable to retrieve Serial Number Inventory records against Pallet Id "+isNewPoNo2)
			Return -1
		End IF
	ElseIf isPoNo2 <> gsFootPrintBlankInd or isContainerId <> gsFootPrintBlankInd or isNewPoNo2 <> gsFootPrintBlankInd or isNewContainer <> gsFootPrintBlankInd Then
		//Do not print mixed containerization NEW PALLET labels.  They are printed in the OLD PALLET section
		destroy lds_serial
		Return 0
	End If
	
	//lb_carton_list lb_carton_list
	lb_carton_list.Reset()
	
	//Get Carton List     DO NOT PRINT NEW CARTON LABELS.   WILL USE ORIGINAL CONTAINER ID - GalM 12/27/2018
	lsCartonPrev = ""
	For ll_row =1 to lds_serial.rowcount( )
		lstr_PalletSerialList.string_arg[ll_row]   =lds_serial.getItemString( ll_row, 'serial_no')
		lsCarton = lds_serial.Object.Carton_Id[ll_row]
		If lsCarton <> lsCartonPrev Then
			lb_carton_list.AddItem(lds_serial.Object.Carton_Id[ll_row])
		End If
		lsCartonPrev = lsCarton
	Next
	
	//Print each carton label
	For ll_rowCarton = 1 to lb_carton_list.TotalItems()
		ll_cnt = 1
		For ll_row = 1 to lds_serial.rowcount()
			If lds_serial.Object.Carton_Id[ll_row] = lb_carton_list.text(ll_rowCarton) Then
				lstr_serialList.string_arg[ll_cnt]   =lds_serial.getItemString( ll_row, 'serial_no')
				ll_cnt++
			End If
		Next
		//Do Not print carton level labels for stock remaining at this time
		//wf_print_2d_barcode_label( lstr_serialList, isSKU, isWhCode, lb_carton_list.text(ll_rowCarton) , 'CARTON LABEL',li_print_option)
		lstr_serialList = str_initalize(lstr_serialList)
		lstr_serialList =lstr_initial
	Next
	
	//Print Pallet 2D Barcode Label
	wf_print_2d_barcode_label( lstr_PalletSerialList, isSKU, isWhCode, isNewPoNo2 , 'PALLET LABEL',li_print_option)
	lstr_PalletSerialList = 	str_initalize(lstr_PalletSerialList)

/* END OF LABEL PRINT OF NEW PALLET */

ib_Print =TRUE

destroy lds_serial
//destroy lu_pandora_labels
return 0

end event

event ue_split_mixed_pallet();/* This event fires when there is a mixed container - PalletId = NA and a valid containerID - To split this container we need to create a new containerID 
		for the serial numbers staying in stock, change the serial numbers to the new container, and adjust content for the new container */
If ilContentRows > 1 Then
	isFilter = "po_no2 = '" + isPoNo2 + "' "
	idsContent.SetFilter(isFilter)
	idsContent.Filter()
	ilContentRows = idsContent.rowcount()
End If

If ids2.rowcount() > 0 Then		//There is something to change.  First get a new pallet and container number
	w_main.setMicroHelp("Splitting Containers....")
	ilSelectedSerialRows = ids2.rowcount()
	
	ilSerialInventoryRows = idsSerial.Retrieve( gs_project, isWhCode, isSKU, isPoNo2)
	isFilter = "po_no2 = '" + isPoNo2 + "' "
	idsSerial.SetFilter(isFilter)
	idsSerial.Filter()
	
	ilSerialInventoryRows = idsSerial.rowcount()
	If ilSerialInventoryRows > 0 Then
		ids1.SetFilter(isFilter)
		ids1.Filter()
		ilSerialRows = ids1.rowcount()
		If ilSerialRows > 0 Then		//This container will be processed.  Get new container id 
			ilContentSummaryRows = idsContentSummary.rowcount()
			If ilContentSummaryRows = 1 and ilContentRows = 1 Then
				ilContentSummaryRow = ilContentSummaryRows
				ilContentRow = ilContentRows
				ilOrigQty = (idsContentSummary.GetItemNumber( ilContentSummaryRow, 'avail_qty') + idsContentSummary.GetItemNumber( ilContentSummaryRow, 'alloc_qty') + idsContentSummary.GetItemNumber( ilContentSummaryRow, "tfr_out" ))
				sqlca.sp_check_digit_build(gs_project,"SSCC_No", "" , 0 , isNewPoNo2 ) 
				For iiSelPos = 1 to ids1.RowCount()		//Those staying in stock will have a new container/carton
					isSerialNo = ids1.GetItemString( iiSelPos, 'Serial_No')
					isFind = "Serial_No = '" + isSerialNo + "' "
					ilFound = idsSerial.Find(isFind, 1, idsSerial.RowCount())
					If ilFound > 0 Then
						iiPos = Pos( isContainersToSplit, isContainerId )
						If iiPos > 0 Then		//This container Needs to split and have the remaining serials with new container id
							idsSerial.SetItem( ilFound, 'po_no2', isNewPoNo2)
							idsSerial.SetItem( ilFound, 'update_user', gs_userid)
							idsSerial.SetItem( ilFound, 'update_date', idtToday)
							idsSerial.SetItem( ilFound, 'Transaction_Type', 'UPDATE')
							idsSerial.SetItem( ilFound, 'Transaction_Id', isDoNo)
							idsSerial.SetItem( ilFound, 'Adjustment_Type', 'DYNAMIC BREAK')
						End If
					End If	
				Next
				If ilSerialRows < ilOrigQty Then		//The pallet splits.  Two adjustments and two content records
					iiRC = idsContent.RowsCopy(1, idsContent.RowCount(), Primary!, idsContent, idsContent.rowcount()+1, Primary!)
					ilNewContentRow = idsContent.rowcount()

					iiRC = idsAdjustment.InsertRow(0)
					
					If iiRC > 0 Then
						ilNbrAdjustments++
						getAdjustmentRecord( iiRC, idsContent, 1 )   //filtered to one record
						idsAdjustment.SetItem( iiRC, "old_quantity", 0 ) 
						idsAdjustment.SetItem( iiRC, "quantity", idsContent.GetItemNumber(1, 'avail_qty') ) 
						idsAdjustment.SetItem( iiRC, "old_po_no2", idsContent.GetItemString(1, 'po_no2') ) 
						idsAdjustment.SetItem( iiRC, "po_no2", isNewPoNo2 ) 
						idsAdjustment.SetItem( iiRC, "ref_no", isDoNo )  //18-MAR-2019 :Madhu S30668 Added
						
						idsContent.SetItem(ilNewContentRow, 'po_no2', isNewPoNo2 )
						idsContent.SetItem(ilNewContentRow, 'last_user', gs_userid)
						idsContent.SetItem(ilNewContentRow, 'last_update', idtToday)
						
						isOldC[iiRC] = isContainerId
						isNewC[iiRC] = isNewContainer
						isCompletionMessage += "New PalletID " + isNewPoNo2 + " qty: " + string(ilSerialRows) + "~n~r"

						iiRC = idsAdjustment.InsertRow(0)
						If iiRC > 0 Then
							ilNbrAdjustments++
							getAdjustmentRecord( iiRC, idsContentSummary, 1 )
							idsAdjustment.SetItem( iiRC, "old_quantity", idsContentSummary.GetItemNumber(1, 'avail_qty') + idsContentSummary.GetItemNumber(1, 'alloc_qty') ) 
							idsAdjustment.SetItem( iiRC, "quantity", idsContentSummary.GetItemNumber(1, 'alloc_qty') ) 
							idsAdjustment.SetItem( iiRC, "ref_no", isDoNo )  //18-MAR-2019 :Madhu S30668 Added
							
							idsContent.SetItem(1, 'avail_qty', 0 ) 		
							idsContentSummary.SetItem(1, 'avail_qty', 0 ) 		
							idsContent.SetItem(1, 'last_user', gs_userid)
							idsContent.SetItem(1, 'last_update', idtToday)
							
							isOldC[iiRC] = isContainerId
							isNewC[iiRC] = isNewContainer
						Else 
							MessageBox("Adjustment Retrieval Error", "Adjustment Retrieve Failed: iiRC=" + String(iiRC))
							This.TriggerEvent("ue_close")
						End If
					Else 
						MessageBox("Adjustment Retrieval Error", "Adjustment Retrieve Failed: iiRC=" + String(iiRC))
						This.TriggerEvent("ue_close")
					End If
				End If				
			End If
		End If
	End If
End If
//Reset content stores
idsContent.SetFilter("")
idsContent.Filter()
idsContentSummary.SetFilter("")
idsContentSummary.Filter()


w_main.setMicroHelp("Mixed Container by Pallet completed")


end event

event ue_split_mixed_container();/* This event fires when there is a mixed container - PalletId = NA and a valid containerID - To split this container we need to create a new containerID 
		for the serial numbers staying in stock, change the serial numbers to the new container, and adjust content for the new container */
If ilContentRows > 1 Then
	isFilter = "container_id = '" + isContainerId + "' "
	idsContent.SetFilter(isFilter)
	idsContent.Filter()
	idsContentSummary.SetFilter(isFilter)
	idsContentSummary.Filter()
	ilContentRows = idsContent.rowcount()
End If

If ids2.rowcount() > 0 Then		//There is something to change.  First get a new pallet and container number
	w_main.setMicroHelp("Splitting Containers....")
	ilSelectedSerialRows = ids2.rowcount()
	
	ilSerialInventoryRows = idsSerial.Retrieve( gs_project, isWhCode, isSKU, isPoNo2)
	isFilter = "carton_id = '" + isContainerId + "' "
	idsSerial.SetFilter(isFilter)
	idsSerial.Filter()
	
	ilSerialInventoryRows = idsSerial.rowcount()
	If ilSerialInventoryRows > 0 Then
		ids1.SetFilter(isFilter)
		ids1.Filter()
		ilSerialRows = ids1.rowcount()
		If ilSerialRows > 0 Then		//This container will be processed.  Get new container id 
			ilContentSummaryRows = idsContentSummary.rowcount()
			If ilContentSummaryRows = 1 and ilContentRows = 1 Then
				ilContentSummaryRow = ilContentSummaryRows
				ilContentRow = ilContentRows
				ilOrigQty = (idsContentSummary.GetItemNumber( ilContentSummaryRow, 'avail_qty') + idsContentSummary.GetItemNumber( ilContentSummaryRow, 'alloc_qty') + idsContentSummary.GetItemNumber( ilContentSummaryRow, "tfr_out" ))
				sqlca.sp_check_digit_build(gs_project,"SSCC_No", "" , 0 , isNewContainer ) 
				For iiSelPos = 1 to ids1.RowCount()		//Those staying in stock will have a new container/carton
					isSerialNo = ids1.GetItemString( iiSelPos, 'Serial_No')
					isFind = "Serial_No = '" + isSerialNo + "' "
					ilFound = idsSerial.Find(isFind, 1, idsSerial.RowCount())
					If ilFound > 0 Then
						iiPos = Pos( isContainersToSplit, isContainerId )
						If iiPos > 0 Then		//This container Needs to split and have the remaining serials with new container id
							idsSerial.SetItem( ilFound, 'carton_id', isNewContainer)
							idsSerial.SetItem( ilFound, 'update_user', gs_userid)
							idsSerial.SetItem( ilFound, 'update_date', idtToday)
							idsSerial.SetItem( ilFound, 'Transaction_Type', 'UPDATE')
							idsSerial.SetItem( ilFound, 'Transaction_Id', isDoNo)
							idsSerial.SetItem( ilFound, 'Adjustment_Type', 'DYNAMIC BREAK')
						End If
					End If	
				Next
				If ilSerialRows < ilOrigQty Then		//The container splits.  Two adjustments and two content records
					iiRC = idsContent.RowsCopy(1, idsContent.RowCount(), Primary!, idsContent, idsContent.rowcount()+1, Primary!)
					ilNewContentRow = idsContent.rowcount()

					iiRC = idsAdjustment.InsertRow(0)
					
					If iiRC > 0 Then
						ilNbrAdjustments++
						getAdjustmentRecord( iiRC, idsContent, 1 )   //filtered to one record
						idsAdjustment.SetItem( iiRC, "old_quantity", 0 ) 
						idsAdjustment.SetItem( iiRC, "quantity", idsContent.GetItemNumber(1, 'avail_qty') ) 
						idsAdjustment.SetItem( iiRC, "old_po_no2", idsContent.GetItemString(1, 'po_no2') ) 
						idsAdjustment.SetItem( iiRC, "container_id", isNewContainer ) 
						idsAdjustment.SetItem( iiRC, "ref_no", isDoNo )  //18-MAR-2019 :Madhu S30668 Added
						
						idsContent.SetItem(ilNewContentRow, 'container_id', isNewContainer )
						idsContent.SetItem(ilNewContentRow, 'last_user', gs_userid)
						idsContent.SetItem(ilNewContentRow, 'last_update', idtToday)
						
						isOldC[iiRC] = isContainerId
						isNewC[iiRC] = isNewContainer
						isCompletionMessage += "~n~r~tNew ContainerID " + isNewContainer + " qty: " + string(ilSerialRows) + "~n~r"

						iiRC = idsAdjustment.InsertRow(0)
						If iiRC > 0 Then
							ilNbrAdjustments++
							getAdjustmentRecord( iiRC, idsContentSummary, 1 )
							idsAdjustment.SetItem( iiRC, "old_quantity", idsContentSummary.GetItemNumber(1, 'avail_qty') + idsContentSummary.GetItemNumber(1, 'alloc_qty') ) 
							idsAdjustment.SetItem( iiRC, "quantity", idsContentSummary.GetItemNumber(1, 'alloc_qty') ) 
							idsAdjustment.SetItem( iiRC, "ref_no", isDoNo )  //18-MAR-2019 :Madhu S30668 Added
							
							idsContent.SetItem(1, 'avail_qty', 0 ) 		
							idsContentSummary.SetItem(1, 'avail_qty', 0 ) 		
							idsContent.SetItem(1, 'last_user', gs_userid)
							idsContent.SetItem(1, 'last_update', idtToday)
							
							isOldC[iiRC] = isContainerId
							isNewC[iiRC] = isNewContainer
						Else 
							MessageBox("Adjustment Retrieval Error", "Adjustment Retrieve Failed: iiRC=" + String(iiRC))
							This.TriggerEvent("ue_close")
						End If
					Else 
						MessageBox("Adjustment Retrieval Error", "Adjustment Retrieve Failed: iiRC=" + String(iiRC))
						This.TriggerEvent("ue_close")
					End If
				End If				
			End If
		End If
	End If
End If
//Reset content stores
idsContent.SetFilter("")
idsContent.Filter()
idsContentSummary.SetFilter("")
idsContentSummary.Filter()


w_main.setMicroHelp("Mixed Container by Container completed")


end event

event ue_split_mixed_serial();/* This event fires when there is a mixed container - PalletId = NA and containerID = NA - To split loose serials we need to identify the serials 
		then update the serial number inventory record with a SerialFlag = "L" and the do_no */

If ids2.rowcount() > 0 Then		//There is something to change.  
	w_main.setMicroHelp("Splitting Loose Serials....")
	ilSelectedSerialRows = ids2.rowcount()
	
	idsContentSummary.dataobject = 'd_content_summary_mixed'
	idsContentSummary.SetTransObject(SQLCA)

	ilContentSummaryRows = idsContentSummary.Retrieve( gs_project, isWhCode, isSKU, gsFootPrintBlankInd)
	
	ilSerialInventoryRows = idsSerial.Retrieve( gs_project, isWhCode, isSKU, isPoNo2)
	isFilter = "carton_id = '" + gsFootPrintBlankInd + "' "
	idsSerial.SetFilter(isFilter)
	idsSerial.Filter()
	
	ilSerialInventoryRows = idsSerial.rowcount()
	If ilSerialInventoryRows > 0 Then
		ids1.SetFilter(isFilter)
		ids1.Filter()
		ilSerialRows = ids2.rowcount()
		If ilSerialRows > 0 Then		
			ilContentSummaryRows = idsContentSummary.rowcount()
			If ilContentSummaryRows > 0 Then
				ilContentSummaryRow = 1
				ilOrigQty = (idsContentSummary.GetItemNumber( ilContentSummaryRow, 'avail_qty') + idsContentSummary.GetItemNumber( ilContentSummaryRow, 'alloc_qty') + idsContentSummary.GetItemNumber( ilContentSummaryRow, "tfr_out" ))
				//sqlca.sp_check_digit_build(gs_project,"SSCC_No", "" , 0 , isNewContainer ) 
				For iiSelPos = 1 to ids2.RowCount()		//Those staying in stock will have a new container/carton
					isSerialNo = ids2.GetItemString( iiSelPos, 'Serial_No')
					isFind = "Serial_No = '" + isSerialNo + "' "
					ilFound = idsSerial.Find(isFind, 1, idsSerial.RowCount())
					If ilFound > 0 Then
						idsSerial.SetItem( ilFound, 'serial_flag', "L")		//Loose serial flag
						idsSerial.SetItem( ilFound, 'do_no', isDoNo)
						idsSerial.SetItem( ilFound, 'update_user', gs_userid)
						idsSerial.SetItem( ilFound, 'update_date', idtToday)
						idsSerial.SetItem( ilFound, 'Transaction_Type', 'UPDATE')
						idsSerial.SetItem( ilFound, 'Transaction_Id', isDoNo)
					End If
				Next
			End If
		End If
	End If
End If

w_main.setMicroHelp("Split Mixed Container by Loose Serials completed")

end event

event ue_split_container();Integer i
iiMove = 0
iiSplit = 0
If ids2.rowcount() > 0 Then		//There is something to change.  First get a new pallet and container number
	w_main.setMicroHelp("Splitting Containers....")
	ilSelectedSerialRows = ids2.rowcount()

	sqlca.sp_check_digit_build(gs_project,"SSCC_No", "" , 0 , isNewPoNo2 ) 
	ilSerialInventoryRows = idsSerial.Retrieve( gs_project, isWhCode, isSKU, isPoNo2)
	idsContentSummary.SetFilter("tfr_in = 0")		//GailM 2/22/2019
	idsContentSummary.Filter()
	ilContentSummaryRows = idsContentSummary.rowcount()

	If ilSerialInventoryRows > 0 Then		//We do have serial data to split. Get new pallet and container numbers
		For ilContentSummaryRow = 1 to ilContentSummaryRows		//For each content record check for shipment
			iiMove = 0
			iiSplit = 0
			isContainerId = idsContentSummary.GetItemString( ilContentSummaryRow, "container_id" )
			ilTfrInQty = idsContentSummary.GetItemNumber( ilContentSummaryRow, "tfr_in" )
			If ilTfrInQty > 0 Then
				continue
			End if
			ilTfrOutQty = idsContentSummary.GetItemNumber( ilContentSummaryRow, "tfr_out" )
			isFind  = "container_id = '" + isContainerId + "' "
			isFind2 = "carton_id = '" + isContainerId + "' "
			isFilter  = "carton_id = '" + isContainerId + "' "
			iiFound = idw_pick.Find(isFind, 1, idw_pick.rowcount())
			if iiFound > 0 Then
				iiSplit = ids2.Find(isFind2, 1, ids2.rowcount())
				iiMove = 2		//Container not split but allocated with container being split
			Else		
				iiMove = 1		//ContentSummary not in pick list...  change the pallet and containerIDs
			End If
			
			If iiMove > 0 Then
				idsSerial.SetFilter(isFilter)
				idsSerial.Filter()
				ilSerialRows = idsSerial.rowcount()
				If ilSerialRows > 0 and iiMove <> 2 Then		
					ilOrigQty = (idsContentSummary.GetItemNumber( ilContentSummaryRow, 'avail_qty') + idsContentSummary.GetItemNumber( ilContentSummaryRow, 'alloc_qty') + idsContentSummary.GetItemNumber( ilContentSummaryRow, "tfr_out" ))
	
					For iiSelPos = 1 to idsSerial.RowCount()							//Those staying in stock have new pallet but retain original container except for the isContainerToSplit
						idsSerial.SetItem( iiSelPos, 'po_no2', isNewPoNo2)
						idsSerial.SetItem( iiSelPos, 'carton_id', isContainerId)
						idsSerial.SetItem( iiSelPos, 'update_user', gs_userid)
						idsSerial.SetItem( iiSelPos, 'update_date', idtToday)
						idsSerial.SetItem( iiSelPos, 'Transaction_Type', 'UPDATE')
						idsSerial.SetItem( iiSelPos, 'Transaction_Id', isDoNo)
						idsSerial.SetItem( iiSelPos, 'Adjustment_Type', 'DYNAMIC BREAK')
					Next
					
					// For outbound orders, adjustment records are needed while updating content and content summary
					If isOrderType = 'SOC' Then
						//Start SOC Processing
						//Copy order content row to a new content row and set new po_no2, container_id and avail qty
						isFilter = "container_id = '" + isContainerId + "' "
						idsContent.SetFilter(isFilter)
						idsContent.Filter()
						isFilter = "container_id = '" + isContainerId + "' and tfr_in = 0"
						idsContentSummary.SetFilter(isFilter)
						idsContentSummary.Filter()
						
						ilAvailQty = idsContentSummary.GetItemNumber( 1, "avail_qty" )
						ilAllocQty = idsContentSummary.GetItemNumber( 1, "tfr_out" )
	
						If Pos( isContainerToSplit, isContainerId ) > 0 Then			//Need a new content record for the split
							//Update current row with new available quantity and change pallet & container
							isOldC[upperbound(isOldC)+1] = isContainerId
							iiRC = idsContent.RowsCopy(1, idsContent.RowCount(), Primary!, idsContent, idsContent.rowcount()+1, Primary!)
							ilNewContentRow = idsContent.rowcount()
							iiRC2 = idsAdjustment.InsertRow(0)
							If iiRC2 > 0 Then
								ilNbrAdjustments++
								getAdjustmentRecord( iiRC2, idsContent, 1 )
								idsAdjustment.SetItem( iiRC2, "old_quantity", ilAvailQty + ilAllocQty)
								idsAdjustment.SetItem( iiRC2, "quantity", ilAllocQty ) 
								idsAdjustment.SetItem( iiRC2, "ref_no", isDoNo )  //18-MAR-2019 :Madhu S30668 Added
				
								idsContent.SetItem( 1, "avail_qty", 0)
								idsContent.SetItem( 1, "last_user", gs_userid)
								idsContent.SetItem( 1, "last_update", idtToday)
					
								idsContent.SetItemStatus ( idsContent.RowCount(), 0, Primary!, NewModified!)
								
								// Now create a new content row for the 
								iiRC = idsAdjustment.InsertRow(0)
								if iiRC > 0 Then
									ilNbrAdjustments++
									getAdjustmentRecord( iiRC, idsContent, 1 )
									idsAdjustment.SetItem( iiRC, "quantity", ilAvailQty ) 
									idsAdjustment.SetItem( iiRC, "old_quantity", 0 ) 
									idsAdjustment.SetItem( iiRC, "po_no2", isNewPoNo2 ) 
									idsAdjustment.SetItem( iiRC, "container_id", isNewContainer ) 
									idsAdjustment.SetItem( iiRC, "ref_no", isDoNo )  //18-MAR-2019 :Madhu S30668 Added
									
									idsContent.SetItem( ilNewContentRow, "avail_qty", ilAvailQty)
									idsContent.SetItem( ilNewContentRow, "po_no2", isNewPoNo2)
									idsContent.SetItem( ilNewContentRow, "container_id", isNewContainer)
									isNewC[iiRC] = isNewContainer
									
									isCompletionMessage += "Remainder of container "  + isContainerId + " moved to Pallet No " + isNewPoNo2 + " / container " + isNewContainer + " with quantity: " + string(ilSerialRows) + "~n~r"
								End If
							End If
						Else			//This container will not split.  Change pallet and container number only
							iiRC2 = idsAdjustment.InsertRow(0)
							if iiRC2 > 0 Then
								ilNbrAdjustments++
								getAdjustmentRecord( iiRC2, idsContent, idsContent.rowcount() )
								
								idsAdjustment.SetItem( iiRC2, "po_no2", isNewPoNo2 ) 
								idsAdjustment.SetItem( iiRC2, "container_id", isContainerId ) 
								idsAdjustment.SetItem( iiRC2, "quantity", ilOrigQty ) 
								idsAdjustment.SetItem( iiRC2, "ref_no", isDoNo )  //18-MAR-2019 :Madhu S30668 Added
								
								idsContent.SetItem( idsContent.rowcount(), "avail_qty", ilOrigQty )
								idsContent.SetItem( idsContent.rowcount(), "po_no2", isNewPoNo2)
								idsContent.SetItem( idsContent.rowcount(), "container_id", isContainerId)
								idsContent.SetItem( idsContent.rowcount(), "last_user", gs_userid)
								idsContent.SetItem( idsContent.rowcount(), "last_update", idtToday)
								//isOldC[iiRC] = isContainerId
								isNewC[iiRC] = isNewContainer
								isCompletionMessage += "ContainerID " + isContainerId + " moved  to new PalletID " + isNewPoNo2 + ".~n~r"
							End If
						End If
						idsContent.SetFilter("")
						idsContent.Filter()
						idsContentSummary.SetFilter("tfr_in = 0")
						idsContentSummary.Filter()
						idsContentSummary.SetSort(isSort)
						idsContentSummary.Sort()
					ElseIf isOrderType = 'StockTransfer' Then
						// Start Stock Transfer Processing - /*********/
						isFilter = "container_id = '" + isContainerId + "' "
						idsContent.SetFilter(isFilter)
						idsContent.Filter()
						isFilter = "container_id = '" + isContainerId + "' and tfr_in = 0"
						idsContentSummary.SetFilter(isFilter)
						idsContentSummary.Filter()
						
						ilAvailQty = idsContentSummary.GetItemNumber( 1, "avail_qty" )
						ilAllocQty = idsContentSummary.GetItemNumber( 1, "tfr_out" )
	
						If  Pos( isContainerToSplit, isContainerId ) > 0 Then			//Need a new content record for the split
							//Update current row with new available quantity and change pallet & container
							iiRC = idsContent.RowsCopy(1, idsContent.RowCount(), Primary!, idsContent, idsContent.rowcount()+1, Primary!)
							ilNewContentRow = idsContent.rowcount()
	
							iiRC2 = idsAdjustment.InsertRow(0)
							If iiRC2 > 0 Then
								ilNbrAdjustments++
								getAdjustmentRecord( iiRC2, idsContent, 1 )
								idsAdjustment.SetItem( iiRC2, "old_quantity", ilAvailQty + ilAllocQty)
								idsAdjustment.SetItem( iiRC2, "quantity", ilAllocQty ) 
								idsAdjustment.SetItem( iiRC2, "ref_no", isDoNo )  //18-MAR-2019 :Madhu S30668 Added
				
								idsContent.SetItem( 1, "avail_qty", 0)
								idsContent.SetItem( 1, "last_user", gs_userid)
								idsContent.SetItem( 1, "last_update", idtToday)
					
								idsContent.SetItemStatus ( idsContent.RowCount(), 0, Primary!, NewModified!)
								
								// Now create a new content row for the 
								iiRC = idsAdjustment.InsertRow(0)
								if iiRC > 0 Then
									ilNbrAdjustments++
									getAdjustmentRecord( iiRC, idsContent, 1 )
									idsAdjustment.SetItem( iiRC, "quantity", ilAvailQty ) 
									idsAdjustment.SetItem( iiRC, "old_quantity", 0 ) 
									idsAdjustment.SetItem( iiRC, "po_no2", isNewPoNo2 ) 
									idsAdjustment.SetItem( iiRC, "container_id", isNewContainer ) 
									idsAdjustment.SetItem( iiRC, "ref_no", isDoNo )  //18-MAR-2019 :Madhu S30668 Added
									
									//idsContent.SetItem( ilNewContentRow, "avail_qty", ilOrigQty - ilDetailAllocQty)  Should already be correct
									idsContent.SetItem( ilNewContentRow, "po_no2", isNewPoNo2)
									idsContent.SetItem( ilNewContentRow, "container_id", isNewContainer)
									//isOldC[iiRC] = isContainerId
									isNewC[iiRC] = isNewContainer
									
									isCompletionMessage += "Remainder of container "  + isContainerId + " moved to Pallet No " + isNewPoNo2 + " / container " + isNewContainer + " with qty: " + string(ilSerialRows) + "~n~r"
								End If
							End If
						Else			//This container will not split.  Change pallet ID only
							iiRC2 = idsAdjustment.InsertRow(0)
							if iiRC2 > 0 Then
								ilNbrAdjustments++
								getAdjustmentRecord( iiRC2, idsContent, idsContent.rowcount() )
								
								idsAdjustment.SetItem( iiRC2, "po_no2", isNewPoNo2 ) 
								idsAdjustment.SetItem( iiRC2, "container_id", isContainerId ) 
								idsAdjustment.SetItem( iiRC2, "quantity", ilOrigQty ) 
								idsAdjustment.SetItem( iiRC2, "ref_no", isDoNo )  //18-MAR-2019 :Madhu S30668 Added
								
								idsContent.SetItem( idsContent.rowcount(), "avail_qty", ilOrigQty )
								idsContent.SetItem( idsContent.rowcount(), "po_no2", isNewPoNo2)
								idsContent.SetItem( idsContent.rowcount(), "container_id", isContainerId)
								idsContent.SetItem( idsContent.rowcount(), "last_user", gs_userid)
								idsContent.SetItem( idsContent.rowcount(), "last_update", idtToday)
								//isOldC[iiRC] = isContainerId
								isNewC[iiRC] = isNewContainer
								isCompletionMessage += "ContainerID " + isContainerId + " moved  to new PalletID " + isNewPoNo2 + ".~n~r"
							End If
						End If
						idsContent.SetFilter("")
						idsContent.Filter()
						idsContentSummary.SetFilter("tfr_in = 0")
						idsContentSummary.Filter()
						idsContentSummary.SetSort(isSort)
						idsContentSummary.Sort()
					Else
						// Start Outbound processing ****
						isFilter = "container_id = '" + isContainerId + "' "
						idsContent.SetFilter(isFilter)
						idsContent.Filter()
						idsContentSummary.SetFilter(isFilter)
						idsContentSummary.Filter()
						
						If ilSerialRows = ilOrigQty Then		//The container goes intact.  No split.  Put adjustment to 0 quantity
							llSplitParticipants ++				//CONTAINERS STAYING IN STOCK WILL RETAIN THE ORIGIANL CONTAINER ID
							iiRC = idsAdjustment.InsertRow(0)
							If iiRC > 0 Then
								ilNbrAdjustments++
								getAdjustmentRecord( iiRC, idsContentSummary, 1 )
								idsAdjustment.SetItem( iiRC, "po_no2", isNewPoNo2 ) 
								idsAdjustment.SetItem( iiRC, "container_id", isContainerId ) 
								idsAdjustment.SetItem( iiRC, "ref_no", isDoNo )  //18-MAR-2019 :Madhu S30668 Added
																		
								idsContent.SetItem(1, 'po_no2', isNewPoNo2)
								idsContent.SetItem(1, 'container_id', isContainerId)
								idsContent.SetItem(1, 'last_user', gs_userid)
								idsContent.SetItem(1, 'last_update', idtToday)
								//isOldC[iiRC] = isContainerId
								isNewC[iiRC] = isNewContainer
								isCompletionMessage += "New Pallet No " + isNewPoNo2 + "~n~r   Original ContainerID " + isContainerId + " qty: " + string(ilSerialRows) + "~n~r"
							Else 
								MessageBox("Adjustment Retrieval Error", "Adjustment Retrieve Failed: iiRC=" + String(iiRC))
								This.TriggerEvent("ue_close")
							End If
						ElseIf ilSerialRows < ilOrigQty Then		//The container splits.  Two adjustments and two content records
							iiRC = idsContent.RowsCopy(1, idsContent.RowCount(), Primary!, idsContent, idsContent.rowcount()+1, Primary!)
							ilNewContentRow = idsContent.rowcount()
	
							iiRC = idsAdjustment.InsertRow(0)
							If iiRC > 0 Then
								ilNbrAdjustments++
								getAdjustmentRecord( iiRC, idsContentSummary, 1 )   //filtered to one record
								//idsAdjustment.SetItem( iiRC, "old_quantity", idsContentSummary.GetItemNumber(1, 'avail_qty') + idsContentSummary.GetItemNumber(1, 'alloc_qty') ) 
								idsAdjustment.SetItem( iiRC, "old_quantity", 0 ) 
								idsAdjustment.SetItem( iiRC, "quantity", idsContentSummary.GetItemNumber(1, 'avail_qty') ) 
								idsAdjustment.SetItem( iiRC, "old_po_no2", idsContentSummary.GetItemString(1, 'po_no2') ) 
								idsAdjustment.SetItem( iiRC, "po_no2", isNewPoNo2 ) 
								idsAdjustment.SetItem( iiRC, "container_id", isNewContainer ) 
								idsAdjustment.SetItem( iiRC, "ref_no", isDoNo )  //18-MAR-2019 :Madhu S30668 Added
								
								idsContent.SetItem(ilNewContentRow, 'po_no2', isNewPoNo2 )
								idsContent.SetItem(ilNewContentRow, 'container_id', isNewContainer )
								idsContent.SetItem(ilNewContentRow, 'last_user', gs_userid)
								idsContent.SetItem(ilNewContentRow, 'last_update', idtToday)
								
								//isOldC[iiRC] = isContainerId
								isNewC[iiRC] = isNewContainer
								isCompletionMessage += "New Pallet No " + isNewPoNo2 + "~n~r~tNew ContainerID " + isNewContainer + " qty: " + string(ilSerialRows) + "~n~r"
	
								iiRC = idsAdjustment.InsertRow(0)
								If iiRC > 0 Then
									ilNbrAdjustments++
									getAdjustmentRecord( iiRC, idsContentSummary, 1 )
									idsAdjustment.SetItem( iiRC, "old_quantity", idsContentSummary.GetItemNumber(1, 'avail_qty') + idsContentSummary.GetItemNumber(1, 'alloc_qty') ) 
									idsAdjustment.SetItem( iiRC, "quantity", idsContentSummary.GetItemNumber(1, 'alloc_qty') ) 
									idsAdjustment.SetItem( iiRC, "ref_no", isDoNo )  //18-MAR-2019 :Madhu S30668 Added
									
									idsContent.SetItem(1, 'avail_qty', 0 ) 		
									idsContentSummary.SetItem(1, 'avail_qty', 0 ) 		
									idsContent.SetItem(1, 'last_user', gs_userid)
									idsContent.SetItem(1, 'last_update', idtToday)
									
									//isOldC[iiRC] = isContainerId
									isNewC[iiRC] = isNewContainer
								Else 
									MessageBox("Adjustment Retrieval Error", "Adjustment Retrieve Failed: iiRC=" + String(iiRC))
									This.TriggerEvent("ue_close")
								End If
							Else 
								MessageBox("Adjustment Retrieval Error", "Adjustment Retrieve Failed: iiRC=" + String(iiRC))
								This.TriggerEvent("ue_close")
							End If
						End If
						idsContent.SetFilter("")
						idsContentSummary.SetFilter("")
						idsContent.Filter()
						idsContentSummary.Filter()
						idsContentSummary.SetSort(isSort)
						idsContentSummary.Sort()
						// End Outbound processing ****
					End If
				ElseIf iiSplit = 1 Then
					sqlca.sp_check_digit_build(gs_project,"SSCC_No", "" , 0 , isNewContainer ) 
					iiNbrSerials = 0
					llSplitParticipants ++
					For iiSelPos = 1 to idsSerial.RowCount()	
						isSerialNo = idsSerial.GetItemString(iiSelPos, 'serial_no')
						isFind = "Serial_No = '" + isSerialNo + "' "
						iiFound = ids1.Find(isFind,1, ids1.rowcount())
						If iiFound > 0 Then 
							idsSerial.SetItem( iiSelPos, 'po_no2', isNewPoNo2)
							idsSerial.SetItem( iiSelPos, 'carton_id', isNewContainer)
							idsSerial.SetItem( iiSelPos, 'update_user', gs_userid)
							idsSerial.SetItem( iiSelPos, 'update_date', idtToday)
							idsSerial.SetItem( iiSelPos, 'Transaction_Type', 'UPDATE')
							idsSerial.SetItem( iiSelPos, 'Transaction_Id', isDoNo)
							idsSerial.SetItem( iiSelPos, 'Adjustment_Type', 'DYNAMIC BREAK')
							iiNbrSerials ++
						End If
					Next
					//Update content
					isOldC[upperbound(isOldC)+1] = isContainerId
					isFilter = "container_id = '" + isContainerId + "' "
					idsContent.SetFilter(isFilter)
					idsContent.Filter()
					idsContentSummary.SetFilter(isFilter)
					idsContentSummary.Filter()

					iiRC = idsContent.RowsCopy(1, 1, Primary!, idsContent, idsContent.rowcount()+1, Primary!)
					ilNewContentRow = idsContent.rowcount()

					iiRC = idsAdjustment.InsertRow(0)
					If iiRC > 0 Then
						ilNbrAdjustments++
						getAdjustmentRecord( iiRC, idsContentSummary, 1 )   //filtered to one record
						idsAdjustment.SetItem( iiRC, "old_quantity", 0 ) 
						idsAdjustment.SetItem( iiRC, "quantity", idsContentSummary.GetItemNumber(1, 'avail_qty') ) 
						idsAdjustment.SetItem( iiRC, "old_po_no2", idsContentSummary.GetItemString(1, 'po_no2') ) 
						idsAdjustment.SetItem( iiRC, "po_no2", isNewPoNo2 ) 
						idsAdjustment.SetItem( iiRC, "container_id", isNewContainer ) 
						idsAdjustment.SetItem( iiRC, "ref_no", isDoNo )  
						
						idsContent.SetItem(ilNewContentRow, 'po_no2', isNewPoNo2 )
						idsContent.SetItem(ilNewContentRow, 'container_id', isNewContainer )
						idsContent.SetItem(ilNewContentRow, 'last_user', gs_userid)
						idsContent.SetItem(ilNewContentRow, 'last_update', idtToday)
						
						//isOldC[iiRC] = isContainerId
						isNewC[iiRC] = isNewContainer

						iiRC = idsAdjustment.InsertRow(0)
						If iiRC > 0 Then
							ilNbrAdjustments++
							getAdjustmentRecord( iiRC, idsContentSummary, 1 )
							idsAdjustment.SetItem( iiRC, "old_quantity", idsContentSummary.GetItemNumber(1, 'avail_qty') + idsContentSummary.GetItemNumber(1, 'alloc_qty') ) 
							idsAdjustment.SetItem( iiRC, "quantity", idsContentSummary.GetItemNumber(1, 'alloc_qty') ) 
							idsAdjustment.SetItem( iiRC, "ref_no", isDoNo )  
							
							idsContent.SetItem(1, 'avail_qty', 0 ) 		
							idsContentSummary.SetItem(1, 'avail_qty', 0 ) 		
							idsContent.SetItem(1, 'last_user', gs_userid)
							idsContent.SetItem(1, 'last_update', idtToday)
							
							//isOldC[iiRC] = isContainerId
							isNewC[iiRC] = isNewContainer
						Else 
							MessageBox("Adjustment Retrieval Error", "Adjustment Retrieve Failed: iiRC=" + String(iiRC))
							This.TriggerEvent("ue_close")
						End If
					Else 
						MessageBox("Adjustment Retrieval Error", "Adjustment Retrieve Failed: iiRC=" + String(iiRC))
						This.TriggerEvent("ue_close")
					End If
					idsContent.SetFilter("")
					idsContentSummary.SetFilter("")
					idsContent.Filter()
					idsContentSummary.Filter()
					idsContentSummary.SetSort(isSort)
					idsContentSummary.Sort()
					isCompletionMessage += "Quantity " + string(iiNbrSerials) + " in Container " + isContainerId + " moved to new pallet:" + isNewPoNo2 + " and new Container: " + isNewContainer + "~r~n"				
				ElseIf iiMove = 2 Then
					isOldC[upperbound(isOldC)+1] = isContainerId
					isCompletionMessage += "Container " + isContainerId + " is allocated and will move forward with the container to be split.~r~n"
				End If
			End If

		Next
	Else
		messagebox("Error with Serial Number Inventory", "No records in serial number inventory for this container.")
	End If
End If

end event

event ue_add_serial_numbers();//GailM 9/5/2019 S37314 F17337 I1304 Google Footprints GPN Conversion Process
Int liSerialRow, liSerialRows, liSerialValidateRow, liSerialValidateRows, liDeletedRow, liRC, liSNExists, liRtn
String lsOwnerCd, lsComponentInd, lsLocation, lsLotNo, lsPoNo, lsPoNo2, lsSerialNo
String lsInvType, lsFind, lsPreview, lsSNChainOfCustody, lsChainOfCustodyEnforceLocationUpdateInd
Long llOwnerId
Decimal ldComponentNo
datetime ldtExpDate, ldtToday
DWItemStatus istItemStatus
isMessage = "empty"
lsSerialNo =  ids2.GetItemString(liSerialValidateRow, 'serial_no')

//GailM 1/31/2020 Rollup transfer detail content rows if there are multiple rono rows
//		iiMultiRono - isRoNo = idsPickDetail
//GailM 1/30/2020 DE14438 Check for multiple rono to assign correct Ro_No

If isOrderType = "StockTransfer" and iiMultiRono > 1 Then
	isRoNo = idsPickDetail.getitemstring(1, "ro_no")
	For liRC = idsPickDetail.rowcount() to 2 step -1
			idsPickDetail.SetItem(1, "quantity", (idsPickDetail.getitemnumber(1, "quantity") + idsPickDetail.getitemnumber( liRC, "quantity")))
			idsPickDetail.DeleteRow(liRC)
	Next
	ibChanged = TRUE
End If

If ibSNChanged or ibSerialChanged Then

	isDoNo = ids3.GetItemString(1, 1)
	ldtToday = f_getLocalWorldTime( isWhCode ) 
	//ownerid on SOC is the new owner id.  We need original here
	//llOwnerId = idsPickDetail.GetItemNumber(1,"owner_id")	could we use ilOwnerId
	llOwnerId = idw_pick.GetItemNumber(1, "owner_id")
	ldtExpDate = idsPickDetail.GetItemDatetime(1,"Expiration_Date")
	lsLotNo = idsPickDetail.GetItemString(1,"Lot_No")
	lsPoNo = idsPickDetail.GetItemString(1,"Po_No")
	isPoNo2 = idsPickDetail.GetItemString(1,"Po_No2")
	isContainerId = idsPickDetail.GetItemString(1, "container_id")
	lsInvType = idsPickDetail.GetItemString(1,"Inventory_Type")
	
	If isOrderType <> "StockTransfer" and IsOrderType <> "SOC" Then
		lsLocation = idsPickDetail.GetItemString(1,"l_code")
		ldComponentNo = idsPickDetail.GetItemNumber(1,"Component_No")
		lsComponentInd = idsPickDetail.GetItemString(1,"Component_Ind")	
	Else
		lsPoNo = idw_transfer_detail_content.GetItemString(1,"Po_No")		//Get original project
		lsLocation = idsPickDetail.GetItemString(1,"s_location")
		lsComponentInd = "N"
		ldComponentNo = 0
	End If
	
	select Owner_Cd into :lsOwnerCd 
	from owner with (nolock)
	where project_id = :gs_project and owner_id = :llOwnerId
	using sqlca;
	
	liRC = 1
	
	liSerialRows = dw_2.RowCount()
	For liSerialRow = 1 to liSerialRows
		lsSerialNo = dw_2.GetItemString(liSerialRow,"serial_no")
		isContainerId = dw_2.GetItemString(liSerialRow,"carton_id")
		isPoNo2 = dw_2.GetItemString(liSerialRow, 'po_no2')
		If ilSerialRows > 0 Then
			lsFind = "serial_no = '" + lsSerialNo + "' "
			iiFound = idsSerialValidate.Find(lsFind, 1, ilSerialRows)
			If iiFound > 0 Then
				istItemStatus = idsSerialValidate.GetItemStatus( iiFound, 0, Primary! )
				continue
			End If
		End If
		
		//Should we check SNI to see if serial no already exists then report the location...?
		
		liSerialValidateRow = idsSerialValidate.InsertRow(0)
		idsSerialValidate.SetItem(liSerialValidateRow,'Project_Id', gs_project)
		idsSerialValidate.SetItem(liSerialValidateRow,'WH_Code', isWhCode)
		idsSerialValidate.SetItem(liSerialValidateRow,'Owner_Id', llOwnerId)
		idsSerialValidate.SetItem(liSerialValidateRow,'Owner_Cd', lsOwnerCd)
		idsSerialValidate.SetItem(liSerialValidateRow,'SKU', isSKU)
		idsSerialValidate.SetItem(liSerialValidateRow,'Serial_No', lsSerialNo)
		idsSerialValidate.SetItem(liSerialValidateRow,'Component_Ind', lsComponentInd)
		idsSerialValidate.SetItem(liSerialValidateRow,'Component_No', ldComponentNo)
		idsSerialValidate.SetItem(liSerialValidateRow,'Update_Date', ldtToday)
		idsSerialValidate.SetItem(liSerialValidateRow,'Update_User', gs_userid)
		idsSerialValidate.SetItem(liSerialValidateRow,'Carton_Id', isContainerId)
		idsSerialValidate.SetItem(liSerialValidateRow,'l_code', lsLocation)
		//idsSerialValidate.SetItem(liSerialValidateRow,'hold_status', '')	//Let this default to NULL
		idsSerialValidate.SetItem(liSerialValidateRow,'Record_Create_Date', ldtToday)
		idsSerialValidate.SetItem(liSerialValidateRow,'Lot_No', lsLotNo)
		idsSerialValidate.SetItem(liSerialValidateRow,'Po_No', lsPoNo)
		idsSerialValidate.SetItem(liSerialValidateRow,'Po_No2', isPoNo2)
		idsSerialValidate.SetItem(liSerialValidateRow,'Exp_DT', ldtExpDate)

		idsSerialValidate.SetItem(liSerialValidateRow,'RO_NO', isRono)
			
		idsSerialValidate.SetItem(liSerialValidateRow,'Inventory_Type', lsInvType)
		idsSerialValidate.SetItem(liSerialValidateRow,'Serial_Flag', 'L')
		idsSerialValidate.SetItem(liSerialValidateRow,'Do_No', isDoNo)
		idsSerialValidate.SetItem(liSerialValidateRow,'Transaction_Type', 'Dynamic Outbound Serial Add')
		idsSerialValidate.SetItem(liSerialValidateRow,'Transaction_Id', isDoNo)
	//	idsSerialValidate.SetItem(liSerialValidateRow,'Adjustment_Type', )  //Let this default to NULL
		ibSerialChanged = TRUE
	Next
	
	// Find and remove dw_2 deleted rows.  Remove from SNL table
	If dw_2.DeletedCount() > 0 Then
		For liDeletedRow = 1 to dw_2.DeletedCount()
			lsSerialNo = dw_2.GetItemString(liDeletedRow,"serial_no",Delete!,false)
			select count(*) into :liSNExists from serial_number_inventory with (nolock) where serial_no = :lsSerialNo using sqlca;
			If liSNExists = 1 Then
				delete from serial_number_inventory where serial_no = :lsSerialNo using sqlca;
			End If
		Next
	End if
End If

//GailM 1/31/2020	14438 For Chain of Custody add serial numbers to Transfer_Serial_Detail
// 12/13 - PCONKL - If chain of Custody and enforcing location update of Serial NUmbers, validate that they have been entered
Select SN_Chain_of_custody, Chain_of_custody_enforce_Location_update_Ind into :lsSNChainOfCustody, :lsChainOfCustodyEnforceLocationUpdateInd
From Project Where Project_id = :gs_Project Using Sqlca;

	//Begin the transaction
	//GailM 10/22/2019 DE13100 - Warning promt without any words - rearranged messaging and clean up OK button for proper functionality
	Execute Immediate "Begin Transaction" using SQLCA; 

	If ibSerialChanged or ibSerialChanged Then	//Added serials
		liRC = idsSerialValidate.update()
		ibSerialChanged = FALSE
			//	Else
			//		isMessage  = "Serial numbers were not saved.  Returned: " + string(liRC)
	End If
	
	If isOrderType = "StockTransfer" and lsSNChainOfCustody = "Y" and lsChainOfCustodyEnforceLocationUpdateInd = "Y" Then
		Delete from Transfer_Serial_Detail where to_no = :isDoNo Using Sqlca;
		For liRtn = 1 to idsSerialValidate.rowcount( )
			
			isSKU = idsSerialValidate.GetItemString( liRtn, "sku" )
			lsSerialNo = idsSerialValidate.GetItemString( liRtn, "serial_no" )
			lsLocation = idw_pick.GetItemString( iiCurrPickRow, "d_location" )
			lsPoNo2 = idsSerialValidate.GetItemString( liRtn, "po_no2" )
			isContainerId = idsSerialValidate.GetItemString( liRtn, "carton_id" )
			
			Insert into Transfer_Serial_Detail (to_no, sku, serial_no, d_Location, Po_No2, Container_Id)
			Values (:isDono, :isSKU, :lsSerialNo, :lsLocation, :lsPoNo2, :isContainerId)
			Using SQLCA;
		Next
	End If
	
	If liRC = 1 or liRC = 0 Then
		If ibChanged Then	//Changed Pallet or Container
			liRC = idw_pick.update()
			If liRC = 1 Then
				liRC = idsPickDetail.update()
				If liRC <> 1 Then
					isMessage  = "Pick Detail list was not saved.  Returned: " + string(liRC)
					ibChanged = FALSE
				End If
			Else
				isMessage  = "Pick list was not saved.  Returned: " + string(liRC)
			End If
		End If
	End If
	
	If liRC = 1 Then
		Execute Immediate "Commit" Using Sqlca;
		isMessage  = "The process saved successfully."
	Else
		Execute Immediate "Rollback" Using Sqlca;
		isMessage = "Process has been rolled back."
	End If
	
	f_method_trace_special( gs_project, this.ClassName() , isMessage,isDoNo,'','',isInvoiceNo)
	If isMessage <> "empty" Then
		Messagebox("Serial Add Process", isMessage)
	End If
	
	if dw_1.RowCount() = 0 Then
		idw_pick.SetItem(iiCurrPickRow, "color_code", "0")
	End If


This.TriggerEvent("ue_close")



end event

event type long ue_print2_labels();//Cloned from u_adjust_pallet_merge ue_print_labels
//Use old pallet id (isPoNo2) and new pallet id (isNewPoNo2) to print labels
String 	ls_sql, ls_errors, ls_sscc, ls_string_data
String		lsCarton, lsCartonPrev
long 		ll_row, ll_rowCarton, llRtn
integer	ll_cnt
integer	li_print_option = 1
str_parms lstr_serialList
str_parms lstr_PalletSerialList
str_parms lstr_initial

llRtn = 0

/* START OF LABEL PRINT OF ORIGINAL PALLET */
	
	//lb_carton_list lb_carton_list
	lb_carton_list.Reset()
	
	//Get Carton List
	lsCartonPrev = ""
	For ll_row =1 to idsSerial.rowcount( )
		lstr_PalletSerialList.string_arg[ll_row]  = idsSerial.getItemString( ll_row, 'serial_no')
		lsCarton = idsSerial.Object.Carton_Id[ll_row]
		If lsCarton <> lsCartonPrev Then
			lb_carton_list.AddItem(idsSerial.Object.Carton_Id[ll_row])
		End If
		lsCartonPrev = lsCarton
	Next
	
	//Print each carton label
	For ll_rowCarton = 1 to lb_carton_list.TotalItems()
		ll_cnt = 1
		For ll_row = 1 to idsSerial.rowcount()
			If idsSerial.Object.Carton_Id[ll_row] = lb_carton_list.text(ll_rowCarton) Then
				lstr_serialList.string_arg[ll_cnt]  = idsSerial.getItemString( ll_row, 'serial_no')
				ll_cnt++
			End If
		Next
		wf_print_2d_barcode_label( lstr_serialList, isSKU, isWhCode, lb_carton_list.text(ll_rowCarton) , 'CARTON LABEL',li_print_option)
		If ll_rowCarton = 1 Then	 li_print_option = 0
		lstr_serialList = str_initalize(lstr_serialList)
		lstr_serialList =lstr_initial
	Next
	
	//Print Pallet 2D Barcode Label
	wf_print_2d_barcode_label( lstr_PalletSerialList, isSKU, isWhCode, isPoNo2 , 'PALLET LABEL',li_print_option)
	lstr_PalletSerialList = 	str_initalize(lstr_PalletSerialList)
	
/* END OF LABEL PRINT OF ORIGINAL PALLET */

Return llRtn

end event

public subroutine dodisplaymessage (string _title, string _message);// doDisplayMessage( string _title, string _message )

str_parms	lstrParms


lstrParms.string_arg[1] = _title
lstrParms.string_arg[2] = _message

openwithparm( w_scan_message, lstrParms )

end subroutine

public function integer resethighlight ();//Gailm 8/2/2018 S22208 F9984 I1026 Google Footprint Partial Containers for SOC and stock transfers
// Reset the background color from Green to default -
// Outbound has also been changed in d_do_picking to use color_code - Take if statement out.
Int i

For i = 1 to idw_pick.rowcount()
		idw_pick.SetItem(i, "color_code", "0")
Next

Return i
end function

public function integer getadjustmentrecord (integer airc, datastore ascontent, integer airec);/* Populate the adjustment with content record */

	idsAdjustment.SetItem( aiRC, "project_id", asContent.GetItemString( aiRec, "project_id" ))
	idsAdjustment.SetItem( aiRC, "sku", asContent.GetItemString( aiRec, "sku" ))
	idsAdjustment.SetItem( aiRC, "supp_code", asContent.GetItemString( aiRec, "supp_code" ))
	idsAdjustment.SetItem( aiRC, "owner_id", asContent.GetItemNumber( aiRec, "owner_id" ))
	idsAdjustment.SetItem( aiRC, "old_owner", asContent.GetItemNumber( aiRec, "owner_id" ))
	idsAdjustment.SetItem( aiRC, "country_of_origin", asContent.GetItemString( aiRec, "country_of_origin" ))
	idsAdjustment.SetItem( aiRC, "old_country_of_origin", asContent.GetItemString( aiRec, "country_of_origin" ))
	idsAdjustment.SetItem( aiRC, "wh_code", asContent.GetItemString( aiRec, "wh_code" ))
	idsAdjustment.SetItem( aiRC, "l_code", asContent.GetItemString( aiRec, "l_code" ))
	idsAdjustment.SetItem( aiRC, "inventory_type", asContent.GetItemString( aiRec, "inventory_type" ))
	idsAdjustment.SetItem( aiRC, "old_inventory_type", asContent.GetItemString( aiRec, "inventory_type" ))
	idsAdjustment.SetItem( aiRC, "serial_no", asContent.GetItemString( aiRec, "serial_no" ))
	idsAdjustment.SetItem( aiRC, "lot_no", asContent.GetItemString( aiRec, "lot_no" ))
	idsAdjustment.SetItem( aiRC, "old_lot_no", asContent.GetItemString( aiRec, "lot_no" ))
	idsAdjustment.SetItem( aiRC, "ro_no", asContent.GetItemString( aiRec, "ro_no" ))
	idsAdjustment.SetItem( aiRC, "po_no", asContent.GetItemString( aiRec, "po_no" ))
	idsAdjustment.SetItem( aiRC, "old_po_no", asContent.GetItemString( aiRec, "po_no" ))
	idsAdjustment.SetItem( aiRC, "po_no2", asContent.GetItemString( aiRec, "po_no2" ))
	idsAdjustment.SetItem( aiRC, "old_po_no2", asContent.GetItemString( aiRec, "po_no2" ))
	idsAdjustment.SetItem( aiRC, "old_quantity",  asContent.GetItemNumber( aiRec, "avail_qty" ))
	idsAdjustment.SetItem( aiRC, "quantity", asContent.GetItemNumber( aiRec, "avail_qty" ))
	idsAdjustment.SetItem( aiRC, "reason", "Container Split")
	If isOrderType = 'SOC' or isOrderType = 'Stock Transfer' Then
		idsAdjustment.SetItem( aiRC, "ref_no", isDoNo)   //to_no assigned earlier
		idsAdjustment.SetItem( aiRC, "adjustment_type", "O")
	Else
		idsAdjustment.SetItem( aiRC, "ref_no", isDoNo)
		idsAdjustment.SetItem( aiRC, "adjustment_type", "900")
	End If
	idsAdjustment.SetItem( aiRC, "last_user", gs_userid)
	idsAdjustment.SetItem( aiRC, "last_update", idtToday)
	idsAdjustment.SetItem( aiRC, "container_id", asContent.GetItemString( aiRec, "container_id" ))
	idsAdjustment.SetItem( aiRC, "expiration_date", asContent.GetItemString( aiRec, "expiration_date" ))
	idsAdjustment.SetItem( aiRC, "old_expiration_date", asContent.GetItemString( aiRec, "expiration_date" ))

Return aiRC
end function

public function integer wf_retrieve_pick_detail (integer airow);/* User has select a container different from the original container.  We must reallocate the content and in doing so, change pick list and the pick detail record */
/* In this context, the pick detail is not populated (only in the w_do wf_update_content function.  We will populate idw_pick _detail to change the containerID.  */
Int liRtn, liPickDet
String lsDoNo, lsSKU, lsSupplier, lsLocation, lsInventoryType, lsSerialNo
String lsLotNo, lsPoNo, lsCOO, lsPoNo2, lsContainerID, lsZoneID
Datetime ldtExpDate
Long llLineItemNo, llCompNo, llOwnerCD

lsDoNo = idw_pick.GetItemString(aiRow, "do_no")
lsSKU = idw_pick.GetItemString(aiRow, "sku")
lsSupplier = idw_pick.GetItemString(aiRow, "supp_code") 
llOwnerCD = idw_pick.GetItemNumber(aiRow, "owner_id")
lsCOO = idw_pick.GetItemString(aiRow, "country_of_origin")
lsLocation = idw_pick.GetItemString(aiRow, "l_code")
lsInventoryType = idw_pick.GetItemString(aiRow, "inventory_type")
lsSerialNo = idw_pick.GetItemString(aiRow, "serial_no")
lsLotNo = idw_pick.GetItemString(aiRow, "lot_no")
lsPoNo = idw_pick.GetItemString(aiRow, "po_no")
lsPoNo2 = idw_pick.GetItemString(aiRow, "po_no2")
lsContainerID = idw_pick.GetItemString(aiRow, "container_id")
llLineItemNo = idw_pick.GetItemNumber(aiRow, "line_item_no")
llCompNo = idw_pick.GetItemNumber(aiRow, "component_no")
ldtExpDate = idw_pick.GetItemDatetime(aiRow, "expiration_date")
lsZoneID = idw_pick.GetItemString(aiRow, "zone_id")

liRtn = idsPickDetail.retrieve(lsDoNo, lsSKU, lsSupplier, llOwnerCD, lsLocation, lsInventoryType, lsSerialNo, lsLotNo, lsPoNo, lsCOO, lsPoNo2, llLineItemNo, lsContainerID, ldtExpDate, llCompNo, lsZoneID)

If liRtn = 0 Then			//Populate the DW with an insert statement
	liPickDet = idsPickDetail.insertrow(0)
	idsPickDetail.SetItem(liPickDet, "do_no", lsDoNO)
	idsPickDetail.SetItem(liPickDet, "sku", lsSKU)
	idsPickDetail.SetItem(liPickDet, "supp_code", lsSupplier)
	idsPickDetail.SetItem(liPickDet, "owner_id", llOwnerCD)
	idsPickDetail.SetItem(liPickDet, "country_of_origin", lsCOO)
	idsPickDetail.SetItem(liPickDet, "l_code", lsLocation)
	idsPickDetail.SetItem(liPickDet, "inventory_type", lsInventoryType)
	idsPickDetail.SetItem(liPickDet, "serial_no", lsSerialNo)

	idsPickDetail.SetItem(liPickDet, "lot_no", lsLotNo)
	idsPickDetail.SetItem(liPickDet, "po_no", lsPoNo)
	idsPickDetail.SetItem(liPickDet, "po_no2", lsPoNo2)
	idsPickDetail.SetItem(liPickDet, "container_id", lsContainerID)
	idsPickDetail.SetItem(liPickDet, "line_item_no", llLineItemNo)
	idsPickDetail.SetItem(liPickDet, "component_no", llCompNo)
	idsPickDetail.SetItem(liPickDet, "expiration_date", ldtExpDate)
	idsPickDetail.SetItem(liPickDet, "zone_id", lsZoneID)
	
	liRtn = idsPickDetail.rowcount()
End If


Return liRtn
end function

public function integer wf_update_content_server ();
long	i, llSerialArrayPos, llNull[], llFindRow, llCount, llFileLength, llCartonCount
String	 lsNull[], lsPost, lsXMLResponse, lsReturnCode, lsReturnDesc, lsFind, lsCrap, lsSaveFile
Boolean	lbRefreshSerial, lbCheckSerial
dwitemstatus ldis_status
String  lsXML, lsTempxml
Integer	liFileNo, liLoop

//Build XML of Pick list to pass to Websphere - We will pass Deletes and Adds - An update will be both

//Writing XML to a file - appending large amounts of data to varaibale is slow.

//TimA 12/12/13 Added
f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'Start function:  ',isDoNo, ' ',' ',isInvoiceNo) 

//OPen a temp file to hold the XML - 
lsSaveFile = "PickSaveXML-" + String(today(),"yyyymmddss") + ".txt"
liFileNo = FileOpen(lsSaveFile,LineMOde!,Write!,LockReadWrite!,Replace!)

idw_pick.AcceptText()

wf_Set_pick_Filter('Remove', '')

////If f_check_required(isTitle, idw_Pick) = -1 Then Return -1

isWhCode = w_do.idw_main.getitemstring(1,'wh_code')
isDoNo = w_do.idw_main.getitemstring(1,'do_no')
isStatus = w_do.idw_main.getitemstring(1,'ord_status')


//Build the Deletes first
llCount = idw_pick.deletedcount()
for i = 1 to llCount
		
	// 09/01 PCONKL - No Picking Detail Row if SKU is non-pickable (it was never picked to begin with)
	If idw_pick.getitemstring(i,'sku_pickable_ind',Delete!,True) = 'N' Then Continue
	
	ldis_status = idw_pick.getitemstatus(i,0,Delete!)
	if ldis_status = New! or ldis_status = NewModified! then Continue
	

	//w_main.setMicroHelp("Building DELETE for row " + String(i) + " of " + String (llCount))
	
	//Pass key values in for Delete
	lsXML = "<DOPickRecord>"
	lsXML += "<UpdateType>D</UpdateType>" /*Update Type is Delete */
	lsXML += "<DONO>" + nz(w_do.idw_main.getitemstring(1,'do_no'),'') + "</DONO>"
	lsXML += "<LineItemNo>" + nz(String(idw_pick.getitemnumber(i,'line_Item_No',Delete!,True) ),'') + "</LineItemNo>"
	lsXML += "<SKU>" + nz(idw_pick.getitemstring(i,'sku',Delete!,True),'') + "</SKU>"
	lsXML += "<SupplierCode>" + idw_pick.getitemstring(i,'supp_code',Delete!,True) + "</SupplierCode>"
	lsXML += "<OwnerID>" + nz(String(idw_pick.getitemnumber(i,'owner_id',Delete!,True)),'') + "</OwnerID>"
	lsXML += "<Quantity>" + nz(String(idw_pick.getitemnumber(i,'Quantity',Delete!,True)),'') + "</Quantity>"
	
	//Only pass if NOt Default Value to keep size of XML down
	
	If idw_pick.getitemstring(i,'inventory_type',Delete!,True) <> 'N' Then
		lsXML += "<InvType>" + nz(idw_pick.getitemstring(i,'inventory_type',Delete!,True),'') + "</InvType>"
	End If
	
	If idw_pick.getitemstring(i,'country_of_origin',Delete!,True) <> 'XXX' Then
		lsXML += "<COO>" + nz(idw_pick.getitemstring(i,'country_of_origin',Delete!,True),'') + "</COO>"
	End If

		
	If idw_pick.getitemstring(i,'serial_no',Delete!,True) <> '-' Then
		lsXML += "<SerialNo>" + nz(idw_pick.getitemstring(i,'serial_no',Delete!,True),'') + "</SerialNo>"
	End If
	
	If idw_pick.getitemstring(i,'lot_no',Delete!,True) <> '-' Then
		lsXML += "<LotNo>" + nz(idw_pick.getitemstring(i,'lot_no',Delete!,True),'') + "</LotNo>"
	End If
	
	If idw_pick.getitemstring(i,'po_no',Delete!,True) <> '-' Then
		lsXML += "<PONO>" + idw_pick.getitemstring(i,'po_no',Delete!,True) + "</PONO>"
	End If
	
	If idw_pick.getitemstring(i,'po_no2',Delete!,True) <> '-' Then
		lsXML += "<PONO2>" + nz(idw_pick.getitemstring(i,'po_no2',Delete!,True),'') + "</PONO2>"
	End If
	
	If idw_pick.getitemstring(i,'Container_ID',Delete!,True) <> '-' Then
		lsXML += "<ContainerID>" + nz(idw_pick.getitemstring(i,'Container_ID',Delete!,True),'') + "</ContainerID>"
	End If
	
	If String(idw_pick.getitemDateTime(i,'Expiration_Date',Delete!,True),"yyyy-mm-dd hh:mm:ss") <> '2999-12-31 00:00:00' Then
		lsXML += "<ExpirationDate>" + String(idw_pick.getitemDateTime(i,'Expiration_Date',Delete!,True),"yyyy-mm-dd hh:mm:ss") + ":000</ExpirationDate>"
	End If
		
		
	lsXML += "<Location>" + nz(idw_pick.getitemstring(i,'l_code',Delete!,True),'') + "</Location>"
	
	If idw_pick.getitemstring(i,'Zone_ID',Delete!,True) <> '-' Then
		lsXML += "<ZoneID>" + nz(idw_pick.getitemstring(i,'Zone_ID',Delete!,True),'') + "</ZoneID>"
	End If
	
	If NOt isnull(idw_pick.getitemnumber(i,'component_no',Delete!,True)) and idw_pick.getitemnumber(i,'component_no',Delete!,True) <> 0 Then
		lsXML += "<ComponentNo>" + String(idw_pick.getitemnumber(i,'component_no',Delete!,True)) + "</ComponentNo>"
	End If
	
	//Add Serial # Indicator
	If llFindRow > 0 Then
		lsXML += "<SerialNumbersExist>Y</SerialNumbersExist>"
	End If

	//Component Indicator -
	If not isnull(idw_pick.getitemstring(i,'component_ind',Delete!,True)) and idw_pick.getitemstring(i,'component_ind',Delete!,True) <> 'N' Then
		lsXML	+=  "<ComponentInd>" + idw_pick.getitemstring(i,'component_ind',Delete!,True) + "</ComponentInd>"
	End If
		
	//GailM 06/20/2017 Add Container ID Scanned Ind for 605
	If idw_pick.getitemstring(i,'container_id_scanned_ind',Delete!,True) <> '' Then
		lsXML += "<ContainerIDScannedInd>" + nz(idw_pick.getitemstring(i,'container_id_scanned_ind',Delete!,True),'') + "</ContainerIDScannedInd>"
	End If

	lsXML += "</DOPickRecord>"
	
	//Either write to file if available or Temp Variable if not
	If liFileNo > 0 Then
		FileWrite(liFileNo,lsXML)
	Else
		lsTempXml += lsXML
	End If

f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'Deleted Pick XML:  ' + lsXML,isDoNo, ' ',' ',isInvoiceNo) //08-May-2014 :Madhu- Added
next /* DEleted Pick Row */


//Updates will build a Delete with the original key values (might have changed) and an Insert for the entire new PIck Record
Long llModified, llDataMod
llCount = idw_pick.rowcount()
llModified = idw_Pick.modifiedcount( )
For i = 1 to llCount /*For each Pick Row*/
	
	ldis_status = idw_pick.getitemstatus(i,0,Primary!)
	
	f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'Modified Pick count:  ' + string(llModified)+ ' Status: '+ string(ldis_status),isDoNo, ' ',' ',isInvoiceNo) //08-May-2014 :Madhu- Added
	
	//Delete for DataModified OR Void
	If ldis_status = DataModified! Then
		
		//09/13 - PCONKL - If we did a serial swap to another order (for Ariens), it has already been saved and we don't want to send to Websphere)
		if idw_pick.GetITemString(i,'c_no_websphere_ind') = 'Y' Then 
			Continue
		End If
		
	//	w_main.setMicroHelp("Building Datamodified DELETE for row " + String(i) + " of " + String (llCount))
		
		//Pass key values in for Delete
		lsXML = "<DOPickRecord>"
		lsXML += "<UpdateType>D</UpdateType>" /*Update Type is Delete */
		lsXML += "<DONO>" + nz(w_do.idw_main.getitemstring(1,'do_no'),'') + "</DONO>"
		lsXML += "<LineItemNo>" + nz(String(idw_pick.getitemnumber(i,'line_Item_No',Primary!,True) ),'') + "</LineItemNo>"
		lsXML += "<SKU>" + nz(idw_pick.getitemstring(i,'sku',Primary!,True),'') + "</SKU>"
		lsXML += "<SupplierCode>" + nz(idw_pick.getitemstring(i,'supp_code',Primary!,True),'') + "</SupplierCode>"
		lsXML += "<OwnerID>" + nz(String(idw_pick.getitemnumber(i,'owner_id',Primary!,True)),'') + "</OwnerID>"
		lsXML += "<Quantity>" + nz(String(idw_pick.getitemnumber(i,'Quantity',Primary!,True)),'') + "</Quantity>"
		
		f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'DataModified! Pick record XML:  ' + lsXML,isDoNo, ' ',' ',isInvoiceNo) //08-May-2014 :Madhu- Added
		//Only pass in if not default value
		
		If idw_pick.getitemstring(i,'inventory_type',Primary!,True) <> 'N' Then
			lsXML += "<InvType>" + nz(idw_pick.getitemstring(i,'inventory_type',Primary!,True),'') + "</InvType>"
		End If
			
		If idw_pick.getitemstring(i,'country_of_origin',Primary!,True) <> 'XXX' Then
			lsXML += "<COO>" + nz(idw_pick.getitemstring(i,'country_of_origin',Primary!,True),'') + "</COO>"
		End If
			
		If idw_pick.getitemstring(i,'serial_no',Primary!,True) <> '-' Then
			lsXML += "<SerialNo>" + nz(idw_pick.getitemstring(i,'serial_no',Primary!,True),'') + "</SerialNo>"
		End If
		
		If idw_pick.getitemstring(i,'lot_no',Primary!,True) <> '-' Then
			lsXML += "<LotNo>" + nz(idw_pick.getitemstring(i,'lot_no',Primary!,True),'') + "</LotNo>"
		End If
		
		If idw_pick.getitemstring(i,'po_no',Primary!,True) <> '-' Then
			lsXML += "<PONO>" + idw_pick.getitemstring(i,'po_no',Primary!,True) + "</PONO>"
		End If
		
		If idw_pick.getitemstring(i,'po_no2',Primary!,True) <> '-' Then
			lsXML += "<PONO2>" + nz(idw_pick.getitemstring(i,'po_no2',Primary!,True),'') + "</PONO2>"
		End If
				
		If idw_pick.getitemstring(i,'Container_ID',Primary!,True) <> '-' Then		
			lsXML += "<ContainerID>" + nz(idw_pick.getitemstring(i,'Container_ID',Primary!,True),'') + "</ContainerID>"
		End If
				
		If String(idw_pick.getitemDateTime(i,'Expiration_Date',Primary!,True),"yyyy-mm-dd hh:mm:ss") <> '2999-12-31 00:00:00' Then
			lsXML += "<ExpirationDate>" + String(idw_pick.getitemDateTime(i,'Expiration_Date',Primary!,True),"yyyy-mm-dd hh:mm:ss") + ":000</ExpirationDate>"
		End If
		
		lsXML += "<Location>" + nz(idw_pick.getitemstring(i,'l_code',Primary!,True),'') + "</Location>"
		
		If idw_pick.getitemstring(i,'Zone_ID',Primary!,True) <> '-' Then
			lsXML += "<ZoneID>" + nz(idw_pick.getitemstring(i,'Zone_ID',Primary!,True),'') + "</ZoneID>"
		End If
		
		If NOt isnull(idw_pick.getitemnumber(i,'component_no',Primary!,True)) and idw_pick.getitemnumber(i,'component_no',Primary!,True) <> 0 Then
			lsXML += "<ComponentNo>" + String(idw_pick.getitemnumber(i,'component_no',Primary!,True)) + "</ComponentNo>"
		Else
			lsXML += "<ComponentNo>0</ComponentNo>"
		End If
		
		//Add Serial # Indicator
		If llFindRow > 0 Then	
			lsXML += "<SerialNumbersExist>Y</SerialNumbersExist>"
		End If

		//Component Indicator -
		If not isnull(idw_pick.getitemstring(i,'component_ind',Primary!,True)) and idw_pick.getitemstring(i,'component_ind',Primary!,True) <> 'N' Then
			lsXML	+=  "<ComponentInd>" + idw_pick.getitemstring(i,'component_ind',Primary!,True) + "</ComponentInd>"
		End If
		
		//GailM 06/20/2017 Add Container ID Scanned Ind for 605
		lsXML += "<ContainerIDScannedInd>" + nz(idw_pick.getitemstring(i,'container_id_scanned_ind',Primary!,True),'') + "</ContainerIDScannedInd>"
	
		lsXML += "</DOPickRecord>"
		
		f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'DataModified! Pick record XML:  ' + lsXML,isDoNo, ' ',' ',isInvoiceNo) //08-May-2014 :Madhu- Added
		//Either write to file if available or Temp Variable if not
		If liFileNo > 0 Then
			FileWrite(liFileNo,lsXML)
		Else
			lsTempXml += lsXML
		End If
		
	End If /*Modified */
	
	
	//Create a new pick Record with the new (updated) values For New!, NewModified!, MOdified! and Not Void
	If (ldis_status = New! or ldis_status = NewModified! or ldis_status = DataModified!) Then
		
	//	w_main.setMicroHelp("Building Datamodified INSERT for row " + String(i) + " of " + String (llCount))
		f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'DW Status:  NewModified! or DataModified!' ,isDoNo, ' ',' ',isInvoiceNo) //08-May-2014 :Madhu- Added
		lsXML = "<DOPickRecord>"
		lsXML += "<UpdateType>N</UpdateType>" /*Update Type is New */
		lsXML += "<DONO>" + w_do.idw_main.getitemstring(1,'do_no') + "</DONO>"
		lsXML += "<LineItemNo>" + String(idw_pick.getitemnumber(i,'line_Item_No') ) + "</LineItemNo>"
		lsXML += "<SKU>" + idw_pick.getitemstring(i,'sku') + "</SKU>"
		lsXML += "<SupplierCode>" + idw_pick.getitemstring(i,'supp_code') + "</SupplierCode>"
		lsXML += "<OwnerID>" + nz(String(idw_pick.getitemnumber(i,'owner_id')),'') + "</OwnerID>"   //Use nz function to ensure not null
		lsXML += "<Quantity>" + nz(String(idw_pick.getitemnumber(i,'Quantity')),'') + "</Quantity>"
		
//		f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'New Pick record XML:  ' + lsXML,isDoNo, ' ',' ',isInvoiceNo) //08-May-2014 :Madhu- Added
		//Only pass in if not default value
		
		If idw_pick.getitemstring(i,'inventory_type') <> 'N' Then
			lsXML += "<InvType>" + nz(idw_pick.getitemstring(i,'inventory_type'),'') + "</InvType>"
		End If
		
		If idw_pick.getitemstring(i,'country_of_origin') <> 'XXX' Then
			lsXML += "<COO>" + nz(idw_pick.getitemstring(i,'country_of_origin'),'') + "</COO>"
		End If
		
		If idw_pick.getitemstring(i,'serial_no') <> '-' Then
			lsXML += "<SerialNo>" + nz(idw_pick.getitemstring(i,'serial_no'),'') + "</SerialNo>"
		End If
		
		If idw_pick.getitemstring(i,'lot_no') <> '-' Then
			lsXML += "<LotNo>" + nz(idw_pick.getitemstring(i,'lot_no'),'') + "</LotNo>"
		End If
		
		If idw_pick.getitemstring(i,'po_no') <> '-' Then
			lsXML += "<PONO>" + idw_pick.getitemstring(i,'po_no') + "</PONO>"
		End If
		
		If idw_pick.getitemstring(i,'po_no2') <> '-' Then
			lsXML += "<PONO2>" + nz(idw_pick.getitemstring(i,'po_no2'),'') + "</PONO2>"
		End If

//		f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'New Pick record XML:  ' + lsXML,isDoNo, ' ',' ',isInvoiceNo) //08-May-2014 :Madhu- Added
		
		If idw_pick.getitemstring(i,'Container_ID')  <> '-' Then
			lsXML += "<ContainerID>" + nz(idw_pick.getitemstring(i,'Container_ID'),'') + "</ContainerID>"
		End If
		
		If String(idw_pick.getitemDateTime(i,'Expiration_Date'),"yyyy-mm-dd hh:mm:ss") <> '2999-12-31 00:00:00' Then
			lsXML += "<ExpirationDate>" + String(idw_pick.getitemDateTime(i,'Expiration_Date'),"yyyy-mm-dd hh:mm:ss") + ":000</ExpirationDate>"
		End If
		
		lsXML += "<Location>" + nz(idw_pick.getitemstring(i,'l_code'),'') + "</Location>"
		
		If Not isnull(idw_pick.getitemstring(i,'Zone_ID')) and  idw_pick.getitemstring(i,'Zone_ID') <> '-' Then
			lsXML += "<ZoneID>" + nz(idw_pick.getitemstring(i,'Zone_ID'),'') + "</ZoneID>"
		End If
		
		
		If NOt isnull(idw_pick.getitemnumber(i,'component_no')) and idw_pick.getitemnumber(i,'component_no') <> 0 Then
			lsXML += "<ComponentNo>" + String(idw_pick.getitemnumber(i,'component_no')) + "</ComponentNo>"
		End If
				
		//Non key fields...
		If not isnull(idw_pick.getitemstring(i,'component_ind')) and idw_pick.getitemstring(i,'component_ind') <> 'N' Then
			lsXML	+=  "<ComponentInd>" + idw_pick.getitemstring(i,'component_ind') + "</ComponentInd>"
		End If
		
		If not isnull(idw_pick.getitemstring(i,'sku_parent')) and idw_pick.getitemstring(i,'sku_parent') <> idw_pick.getitemstring(i,'sku')Then
			lsXML	+=  "<SkuParent>" + idw_pick.getitemstring(i,'sku_parent') + "</SkuParent>"
		End If
		
		If not isnull(idw_pick.getitemstring(i,'user_Field1')) Then
			lsXML += "<UserField1>" + idw_pick.getitemstring(i,'user_Field1') + "</UserField1>"
		End If
		
		If not isnull(idw_pick.getitemstring(i,'user_Field2')) Then
			lsXML += "<UserField2>" + idw_pick.getitemstring(i,'user_Field2') + "</UserField2>"
		End If
		
		If Not isnull(idw_pick.getitemstring(i,'sku_pickable_ind')) and idw_pick.getitemstring(i,'sku_pickable_ind') <> 'Y' Then
			lsXML += "<SkuPickableInd>" + idw_pick.getitemstring(i,'sku_pickable_ind') + "</SkuPickableInd>"
		End If
		
		If NOt isnull(idw_pick.getitemNumber(i,'cntnr_length')) and idw_pick.getitemNumber(i,'cntnr_length') <> 0 Then		//GailM - 03/25/2014 - Changed cntnr_width to cntnr_length.  typo
			lsXML += "<CntnrLength>" + String(idw_pick.getitemNumber(i,'cntnr_length')) + "</CntnrLength>"
		End If
		
		If Not isnull(idw_pick.getitemNumber(i,'cntnr_width')) and idw_pick.getitemNumber(i,'cntnr_width') <> 0 Then
			lsXML += "<CntnrWidth>" + String(idw_pick.getitemNumber(i,'cntnr_width')) + "</CntnrWidth>"
		End If
		
		If not isnull(idw_pick.getitemNumber(i,'cntnr_height')) and idw_pick.getitemNumber(i,'cntnr_height') <> 0  Then
			lsXML += "<CntnrHeight>" + String(idw_pick.getitemNumber(i,'cntnr_height')) + "</CntnrHeight>"
		End If
		
		If not isnull(idw_pick.getitemNumber(i,'cntnr_weight')) and idw_pick.getitemNumber(i,'cntnr_weight') <> 0 Then
			lsXML += "<CntnrWeight>" + String(idw_pick.getitemNumber(i,'cntnr_weight')) + "</CntnrWeight>"
		End If
		
		//05/08 - PCONKL
		If not isnull(idw_pick.getitemstring(i,'staging_location')) Then
			lsXML += "<StagingLocation>" + idw_pick.getitemstring(i,'staging_location') + "</StagingLocation>"
		End If
		
		If not isnull(idw_pick.getitemstring(i,'Mobile_status_Ind')) Then
			lsXML += "<MobileStatusInd>" + idw_pick.getitemstring(i,'Mobile_status_Ind') + "</MobileStatusInd>"
		End If
		
		If not isnull(idw_pick.getitemNumber(i,'Mobile_Picked_Qty')) Then
			lsXML += "<MobilePickedQty>" +String( idw_pick.getitemNumber(i,'Mobile_Picked_Qty')) + "</MobilePickedQty>"
		End If
		
		If String(idw_pick.getitemDateTime(i,'Mobile_Pick_start_Time'),"yyyy-mm-dd hh:mm:ss") > '' Then
			lsXML += "<MobilePickStartTime>" + String(idw_pick.getitemDateTime(i,'Mobile_Pick_start_Time'),"yyyy-mm-dd hh:mm:ss") + ":000</MobilePickStartTime>"
		End If
		
		//19-Mar-2018 :Madhu DE3510 - Populate Mobile_Pick_Complete_Time
		If String(idw_pick.getitemDateTime(i,'Mobile_Pick_Complete_Time'),"yyyy-mm-dd hh:mm:ss") > '' Then
			lsXML += "<MobilePickCompleteTime>" + String(idw_pick.getitemDateTime(i,'Mobile_Pick_Complete_Time'),"yyyy-mm-dd hh:mm:ss") + ":000</MobilePickCompleteTime>"
		End If
		
		If not isnull(idw_pick.getitemstring(i,'Mobile_Picked_By')) Then
			lsXML += "<MobilePickedBy>" + idw_pick.getitemstring(i,'Mobile_Picked_By') + "</MobilePickedBy>"
		End If
		
		If not isnull(idw_pick.getitemstring(i,'Mobile_Current_Location')) Then
			lsXML += "<MobileCurrentLocation>" + idw_pick.getitemstring(i,'Mobile_Current_Location') + "</MobileCurrentLocation>"
		End If
		
		//GailM 06/20/2017 - Add Container ID Scanned Ind for 605
		If not isnull(idw_pick.getitemstring(i,'Container_ID_Scanned_Ind')) Then
			lsXML += "<ContainerIDScannedInd>" + idw_pick.getitemstring(i,'Container_ID_Scanned_Ind') + "</ContainerIDScannedInd>"
		End If

		//GailM 06/15/2018 Add User_Field5 for S19742 Edge Packaging
		If not isnull(idw_pick.getitemstring(i,'user_field5')) Then
			lsXML += "<UserField5>" + nz(idw_pick.getitemstring(i,'user_field5',Primary!,True),'') + "</UserField5>"
		End If
	
		//GailM 06/15/2018 Add ContainerIDFound for S19742 Edge Packaging
		If not isnull(idw_pick.getitemstring(i,'containerid_found')) Then
			lsXML += "<ContainerIDFound>" + nz(idw_pick.getitemstring(i,'containerid_found',Primary!,True),'') + "</ContainerIDFound>"
		End If
	
		lsXML += "</DOPickRecord>"
		f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'New Pick record XML:  ' + lsXML,isDoNo, ' ',' ',isInvoiceNo) //08-May-2014 :Madhu- Added
		
		//Either write to file if available or Temp Variable if not
		If liFileNo > 0 Then
			FileWrite(liFileNo,lsXML)
		Else
			lsTempXml += lsXML
		End If
		
	End If /* Modified or new and not void*/
	
Next

If liFileNo > 0 Then FileClose(liFileNo)

//w_main.setMicroHelp("Creating XML from File...")

llFileLength = FileLength(lsSaveFile)
liFileNo = FileOPen(lsSaveFile,StreamMode!,Read!)

If liFileNo > 0 Then
	// Determine how many times to call FileRead
	IF llFileLength > 32765 THEN
		IF Mod(llFileLength, 32765) = 0 THEN
    	   liLoop = llFileLength/32765
   	ELSE
       	liLoop = (llFileLength/32765) + 1
   	END IF
	ELSE
  	 liLoop = 1
	END IF

	lsXML = ""

	For i = 1 to liLoop
		FileRead(liFileNo,lsCrap)
		lsXML += lsCrap
	Next

	FileClose(liFileNo)
	FileDelete(lsSaveFile)
	
Else
	
	lsXML = lsTempXml
	f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'Temp XML:  ' + lsTempXml,isDoNo, ' ',' ',isInvoiceNo) //08-May-2014 :Madhu- Added
End If


If isNull(lsXML) or lsXML = "" Then
	f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'Unable to Save Pick list - required Pick fields missing',isDoNo, ' ',lsPost,isInvoiceNo) 
	Messagebox(isTitle, 'Unable to Save Pick list - required Pick fields missing' )
	Return -1
End If

If lsXML = "" Then 
	
	//09/13 - PCONKL - If we suppressed any updates to Websphere, reset the flag
	llCount = idw_pick.RowCount()
	For i = 1 to llCount
		idw_pick.SetItem(i,'c_no_websphere_ind','')
	Next
	f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'XML is Blank or Null  ',isDoNo, ' ',lsPost,isInvoiceNo) 
	Return 0

End If

//Add the header and footer
iuoWebsphere = CREATE u_nvo_websphere_post
linit = Create Inet
lsPost = iuoWebsphere.uf_request_header("DOPickAllocRequest", "ProjectID='" + gs_Project + "'")
lsPost += lsXML
lsPost = iuoWebsphere.uf_request_footer(lsPost)

//Messagebox("",lsPost)

w_main.setMicroHelp("Saving Pick List on Application Server...")

//TimA 12/12/13 Added
f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'Call to Webshpere:  ',isDoNo, ' ',lsPost,isInvoiceNo) 

lsXMLResponse = iuoWebsphere.uf_post_url(lsPost)

w_main.setMicroHelp("Pick List Allocation complete")

//TimA 12/12/13 Added
f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'Response from Webshpere:  ',isDoNo, ' ',lsXMLResponse,isInvoiceNo) 

//Check for Valid Return...
//If we didn't receive an XML back, there is a fatal exception error
If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
	//TimA 12/12/13 Added
	f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'Websphere Fatal Exception Error:  ',isDoNo, ' ',lsXMLResponse,isInvoiceNo) 
	Messagebox("Websphere Fatal Exception Error","Unable to save Pick List: ~r~r" + lsXMLResponse,StopSign!)
	Return -1
End If

//Check the return code and return description for any trapped errors
lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		//TimA 12/12/13 Added
		f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'Websphere Error Unable to Save Pick List:  ',isDoNo, ' ',lsXMLResponse,isInvoiceNo) 		
		Messagebox("Websphere Operational Exception Error","Unable to Save Pick List: ~r~r" + lsReturnDesc,StopSign!)
		Return -1
	
	Case Else
		
		If lsReturnDesc > '' Then
			Messagebox(isTitle,lsReturnDesc)
		End If
		
		if lsReturnCode = "-1" Then Return -1
			
End Choose


//09/13 - PCONKL - If we suppressed any updates to Websphere, reset the flag
llCount = idw_pick.RowCount()
For i = 1 to llCount
	idw_pick.SetItem(i,'c_no_websphere_ind','')
Next

//TimA 12/12/13 Added
f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content_server', 'End function:  ',isDoNo, ' ',' ',isInvoiceNo) 

Return 0

end function

public function integer wf_set_pick_filter (string as_action, string as_filter);
//Pick list may be filtering component info. Most logic needs to process these rows anyway.
// so we may have to unfilter the pick list before processing and refilter afterwords.

Choose Case as_action
		
	Case 'Remove' /*remove existing filter*/
		
		idw_pick.SetFilter('')
		
	Case 'Set' /* Re-set*/
		
			idw_pick.SetFilter(as_filter)

End Choose

idw_pick.Filter()
idw_pick.GroupCalc()

Return 0

end function

public function integer wf_print_2d_barcode_label (str_parms astr_serial_parms, string as_sku, string as_wh, string as_pallet_container_id, string as_label_text, integer ai_print_option);//Cloned from wf_print_2d_barcode_label
//-Print 2D Barcode

string ls_sscc, ls_coo, lsFormat, lsLabel, lsCurrentLabel, lsLabelPrint
long ll_row, ll_Rowcount, ll_Return
str_parms lstr_serial_data, lstr_parms

//split serial no's by length into multiple labels.
lstr_serial_data = this.wf_split_serialno_by_length( astr_serial_parms, 500)
ll_Rowcount =UpperBound(lstr_serial_data.string_arg[])

//generate SSCC
ls_sscc = this.wf_generate_sscc( as_pallet_container_Id)

select Top 1 Country_Of_Origin into :ls_coo 
from Content with(nolock) where Project_Id=:gs_project  and wh_code= :as_wh
and sku=:as_sku and container_Id = :as_pallet_container_Id
using sqlca;

//read Label Format
lsFormat = "Pandora_QR_Barcode_Label.txt"
lsLabel = this.wf_read_label_Format(lsFormat)

If lsLabel = "" Then Return -1
	
//Preparing Print Label Data
For ll_row = 1 to ll_Rowcount
	lsCurrentLabel = lsLabel
	lsCurrentLabel = this.wf_replace(lsCurrentLabel,"~~label_text~~", as_label_text)
	lsCurrentLabel = this.wf_replace(lsCurrentLabel,"_7eserial_5fno_5fbc_7e", lstr_serial_data.string_arg[ll_row])
	lsCurrentLabel = this.wf_replace(lsCurrentLabel,"~~cont~~", ls_sscc)
	lsCurrentLabel = this.wf_replace(lsCurrentLabel,">=cont>=", ls_sscc)
	
	lsCurrentLabel = this.wf_replace(lsCurrentLabel,"~~carton_id~~", as_pallet_container_Id)
	lsCurrentLabel = this.wf_replace(lsCurrentLabel,"~~sku~~", as_sku)
	lsCurrentLabel = this.wf_replace(lsCurrentLabel,">=sku>=", as_sku)
		
	lsCurrentLabel = this.wf_replace(lsCurrentLabel,"~~qty~~", string(ll_Rowcount))
	lsCurrentLabel = this.wf_replace(lsCurrentLabel,">=qty>=", string(ll_Rowcount))
		
	lsCurrentLabel = this.wf_replace(lsCurrentLabel,"~~uc3~~", left(ls_coo, 2))
	lsCurrentLabel = this.wf_replace(lsCurrentLabel,">=uc3>=", left(ls_coo, 2))
	
	lsCurrentLabel = this.wf_replace(lsCurrentLabel,"~~count~~", string(ll_row))
	lsCurrentLabel = this.wf_replace(lsCurrentLabel,"~~count_total~~", string(ll_Rowcount))
	
	lsLabelPrint += lsCurrentLabel
Next

//Print Label
ll_Return = this.wf_print_label_data(  'Pandora QR Barcode Labels ', lsLabelPrint, ai_print_option)

Return ll_Return
end function

public function str_parms wf_split_serialno_by_length (str_parms as_str_serial_no, long al_length);//Split Serial No's against 2D Barcode length and print multiple labels.

str_parms ls_str_parms
string ls_serial_concat, ls_prev_serial_concat, ls_serial_no, ls_new_serialNo
long 	llRowPos, ll_serial_length, ll_total_carton_count, ll_Serial_Count
boolean lbNextCarton

ll_Serial_Count = upperBound(as_str_serial_no.string_arg[])

FOR llRowPos =1 to ll_Serial_Count

	ls_prev_serial_concat = ls_serial_concat	
	ls_serial_no = as_str_serial_no.string_arg[llRowPos] //get Serial No
	
	ls_serial_concat += ls_serial_no //concat serial No
	
	ll_serial_length =len(ls_serial_concat)
	IF ll_serial_length <= al_length Then
		ls_serial_concat +=","
		lbNextCarton = False
	else
		lbNextCarton = True
	End IF
	
	//if New Carton Required, stored concatenated SN into Str_Parms
	If lbNextCarton Then
		ls_new_serialNo = Left(ls_prev_serial_concat, len(ls_prev_serial_concat) -1) //remove comma at the end
		llRowPos = llRowPos -1 //starts from previous row
		
		//Re-set the variables.
		ls_prev_serial_concat =''
		ls_serial_concat =''
		
		ls_str_parms.string_arg[UpperBound(ls_str_parms.string_arg[]) + 1] =ls_new_serialNo
	End If
	
	//assign LeftOver Serial No's into Str_Parms
	IF (llRowPos = ll_Serial_Count) and lbNextCarton =False Then
		ls_new_serialNo = Left(ls_serial_concat, len(ls_serial_concat) -1) //remove comma at the end
		ls_str_parms.string_arg[UpperBound(ls_str_parms.string_arg[])+ 1] =ls_new_serialNo
	End IF

NEXT

Return ls_str_parms
end function

public function string wf_generate_sscc (string as_pallet_container_id);//generate SSCC (18 digit) No.

String lsContainer_Id ,lsUCCS, lsOutString, lsDelimitChar, lsUCCSCompanyPrefix
Long liCartonNo,liCheck

lsContainer_Id = as_pallet_container_Id
lsDelimitChar = char(9)

select UCC_Company_Prefix into :lsUCCSCompanyPrefix 
from Project with(nolock)
where Project_ID = :gs_project 
using SQLCA;

IF IsNull(lsUCCSCompanyPrefix) Then lsUCCSCompanyPrefix = '00000000'
IF IsNull(lsContainer_Id) Then lsContainer_Id = '00000000'
IF lsContainer_Id <> '' Then
	If Len(lsContainer_Id)	 = 20 Then		 
		liCartonNo = Long(MID(lsContainer_Id,12,8))
	Else
		liCartonNo = Long(RIGHT(lsContainer_Id,8))
	End If
	
	lsContainer_Id =string(liCartonNo, '00000000') 
	lsUCCS =  "0" + trim((lsUCCSCompanyPrefix +  lsContainer_Id))
	liCheck = f_calc_uccs_check_Digit(lsUCCS) 
	
	If liCheck >=0 Then
			lsUCCS = lsUCCS + String(liCheck)
	Else
		lsUCCS = String(lsUCCS, '00000000000000000') + "0"
	End IF
	
	lsOutString += lsUCCS  + lsDelimitChar
	
end if

Return lsOutString
end function

public function string wf_read_label_format (string asformat_name);
String	lsFormatData,	&
			lsFile
			
Integer	liFileNo

//Look in the labels sub-directory of the SIMS directory
//TimA 06/08/15 Added new global varable for path location of labels.
If gs_labelpath > '' Then
	lsFile = gs_labelpath  + asformat_name
else
	If gs_SysPath > '' Then
		lsFile = gs_syspath + 'labels\' + asformat_name
		//guido's local directory	gs_SysPath = "c:\pb7devl\sims32dev\" 
	Else
		lsFile = 'labels\' + asformat_name
	End If
End if

If Not FileExists(lsFile) Then
	Messagebox('Labels', 'Unable to load necessary label Format! - ' + lsfile)
	Return ''
End If

//Open the File - streammode will read entire file into 1 variable
liFileNo = FileOpen(lsFile,StreamMode!,Read!,Shared!)

If liFileNo < 0 Then
	Messagebox('Labels', 'Unable to load necessary label Format: "' + asFormat_Name + '"')
	Return ''
End If

FileRead(lifileNo, lsFormatData)
FileClose(liFileNo)

//Messagebox('before',lsFormatData)

Return lsFormatData
end function

public function string wf_replace (string asstring, string asoldvalue, string asnewvalue);String	lsString
Long	llPos


if isNull(asnewValue) Then Return asString

lsString = asString
llPos = Pos(lsString,asOldValue)

Do While llPos > 0 
	lsString = Replace(lsString,llPos,len(asOldValue), asNewValue) 
	llPos = Pos(lsString,asOldValue,llPos+1)
Loop

REturn lsString
end function

public function long wf_print_label_data (string as_print_text, string as_print_data, integer ai_print_option);//Print Label
long llPrintJob
str_parms lstr_parms

IF as_print_data > "" Then
	If ai_print_option = 1 Then
		OpenWithParm(w_label_print_options,lstr_parms)
		lstr_parms = Message.PowerObjectParm		  
		
		IF lstr_parms.Cancelled Then
			Return -1
		End IF
	End If
	
	//Open Printer File 
	llPrintJob = PrintOpen( as_print_text)
	IF llPrintJob <0 Then 
		Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
		Return -1
	End IF
	
	PrintSend(llPrintJob, as_print_data)	
	PrintClose(llPrintJob)
End IF

Return 0
end function

public function str_parms str_initalize (str_parms astr_parms);str_parms lstr_parms
int liNbrArgs, liRow
String lsNull

liNbrArgs = UpperBound(astr_parms.String_arg)
For liRow = liNbrArgs to 1 step -1
	astr_parms.string_arg[liRow] = lsNull
Next

return astr_parms
end function

public function integer wf_mixed_containerization ();//15-MAR-2019 :Madhu S30668 - F14058 - Add Validation on Picking for Splitting Footprints
//10-APR-2019 :Madhu DE9805 Added Container Id to prompt  message.

string		ls_container_id, ls_prev_container_id, ls_supp, ls_coo, ls_inv_type, ls_serial, ls_pono2
string		ls_loc, ls_lotno, ls_rono, ls_pono, ls_reason, ls_adj_type, ls_sql, ls_errors, lsFind
string		ls_new_pono2, ls_new_container_Id, lsInitialCode, lsMsg
long		ll_row, ll_rowcount, ll_owner_id, llFindRow, llCRows, llCSRows, llNewCSRows, llSerialRows
int			liRtn = 0
boolean	lbContinue, lbMixedContainerization
decimal 	ld_qty
datetime ldt_exp_date, ldtToday
str_parms lstr_parms

datastore lds_adjust

ls_pono2 = isPoNo2 //store Original PoNo2
ls_errors = ""
ldtToday = f_getLocalWorldTime( isWhCode ) 

//Filter pick list to the palletID for the splitting containerID...  All containers will be changed
isFilter = "po_no2 = '" + isPoNo2 + "' "
idw_pick.SetFilter(isFilter)
idw_pick.Filter()

lbMixedContainerization = FALSE
lbContinue = TRUE

/********************************************START OF MIXED CONTAINERIZATION**************************************************************/
//get list of shipping container Id.s
FOR ll_row=1 to idsSerial.rowcount( )
	ls_container_id = idsSerial.getItemString( ll_row, 'carton_id')
	
	IF ls_prev_container_id <> ls_container_id  THEN
		
		ls_prev_container_id = ls_container_id
			
		//If Loose serial no's are picked without pallet Id / container Id, prompt a  message to user
		IF (ls_container_id ='-' or ls_container_id = gsFootPrintBlankInd) OR &
				(ls_pono2 ='-' or ls_pono2 = gsFootPrintBlankInd) THEN
			lbMixedContainerization = TRUE

			If ls_pono2 <> '-' and ls_pono2 <> gsFootPrintBlankInd Then
				lstr_parms.String_arg[1] = 'P'
				lstr_parms.String_arg[2] = ls_pono2
			ElseIf ls_container_id <> '-' and ls_container_id <> gsFootPrintBlankInd Then
				lstr_parms.String_arg[1] = 'C'
				lstr_parms.String_arg[2] = ls_container_id
			Else
				lstr_parms.String_arg[1] = 'N'
				lstr_parms.String_arg[2] = 'NA'
			End If
			
			lsInitialCode = lstr_parms.String_arg[1]

			//Prompt for Loose serial no selection
			OpenWithParm(w_pick_mixed_container,lstr_parms)
			lstr_parms = Message.PowerObjectParm
				
			IF lstr_parms.Cancelled THEN
				Return 1
			ELSE
				
				If lstr_parms.String_Arg[1] <> lsInitialCode Then
					//choose shipping option
					CHOOSE CASE lstr_parms.String_Arg[1]
						CASE 'P'
							
							IF isPoNo2 ='-' or isPoNo2 = gsFootPrintBlankInd THEN
								sqlca.sp_check_digit_build(gs_project,"SSCC_No", "" , 0 ,ls_new_pono2 )
								isNewPoNo2 = ls_new_pono2
							ELSE
								ls_new_pono2 = isPoNo2 //Retain Original Pallet Id
							END IF
							
							ls_new_container_Id = gsFootPrintBlankInd
							
						CASE 'C'
							
							IF ls_container_id ='-' or ls_container_id =gsFootPrintBlankInd THEN
								sqlca.sp_check_digit_build(gs_project,"SSCC_No", "" , 0 ,ls_new_container_Id ) 
								isNewContainer = ls_new_container_Id
							ELSE
								ls_new_container_Id = ls_container_id //Retain Original Container Id
							END IF
							
							ls_new_pono2 = gsFootPrintBlankInd
							
						CASE 'N'
							ls_new_pono2 = gsFootPrintBlankInd
							ls_new_container_Id = gsFootPrintBlankInd
					END CHOOSE
				Else
					lbContinue = FALSE
				End If
			END IF
		End If
	End If
NEXT

If lbContinue and lbMixedContainerization Then
	
	Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

	//process based on Order Type
	IF isOrderType = 'SOC' or isOrderType = 'StockTransfer' THEN
		
		//A. get ro_no from transfer detail content
		select Ro_No into :ls_rono from transfer_detail_content with(nolock) 
		where To_No =:isDoNo	and sku=:isSKU and Po_No2=:ls_pono2 and Container_Id =:ls_container_id
		using sqlca;
	
		//B. update transfer_detail/ transfer_detail_content table
		update transfer_detail_content set Po_No2=:ls_new_pono2, container_id =:ls_new_container_Id
		where To_No =:isDoNo and sku=:isSKU and Po_No2=:ls_pono2
		//and container_id =:ls_container_id
		using sqlca;
	
		update transfer_detail set Po_No2=:ls_new_pono2 , container_id =:ls_new_container_Id
		where To_No =:isDoNo and sku=:isSKU and Po_No2=:ls_pono2
		//and container_id =:ls_container_id
		using sqlca;
		
		//C. get appropriate record details from transfer (full container)
		lsFind ="sku ='"+isSKU+"' and po_no2='"+ls_pono2+"' and container_id='"+ls_container_id+"'"
		llFindRow = idw_pick.find( lsFind, 1, idw_pick.rowcount())
		
		IF llFindRow > 0 THEN
			ls_supp = idw_pick.getItemString(llFindRow, 'supp_code')
			ll_owner_id = idw_pick.getItemNumber( llFindRow, 'Owner_Id')
			ls_coo = idw_pick.getItemString( llFindRow, 'Country_Of_Origin')
			ls_loc = idw_pick.getItemString( llFindRow, 'S_Location')
			ls_inv_type = idw_pick.getItemString( llFindRow, 'Inventory_Type')
			ls_serial = idw_pick.getItemString( llFindRow, 'Serial_No')
			ls_lotno = idw_pick.getItemString( llFindRow, 'Lot_No')
			ls_pono = idw_pick.getItemString( llFindRow, 'Po_No')
			ld_qty = idw_pick.getItemNumber( llFindRow, 'Quantity')
			ldt_exp_date = idw_pick.getItemDateTime( llFindRow, 'Expiration_Date')
			
			ls_reason ='Container Split'
			ls_adj_type ='9'
		END IF
			
	ELSE //Outbound Order
		
		//D. get ro_no from picking detail 
		select Ro_No into :ls_rono from delivery_picking_detail with(nolock) 
		where Do_No =:isDoNo	and sku=:isSKU and Po_No2=:ls_pono2 and Container_Id =:ls_container_id
		using sqlca;
	
		//E. update delivery_picking/ delivery_picking_detail table
		update delivery_picking_detail set Po_No2=:ls_new_pono2 , container_id =:ls_new_container_Id
		where Do_No=:isDoNo and sku=:isSKU and Po_No2=:ls_pono2
		//and container_id =:ls_container_id
		using sqlca;
		
		update delivery_picking set Po_No2=:ls_new_pono2 , container_id =:ls_new_container_Id 
		where Do_No=:isDoNo and sku=:isSKU and Po_No2=:ls_pono2
		//and container_id = :ls_container_id
		using sqlca;
		
		//F. get appropriate record details from picking (full container)
		lsFind ="sku ='"+isSKU+"' and po_no2='"+ls_pono2+"' and container_id='"+ls_container_id+"'"
		llFindRow = idw_pick.find( lsFind, 1, idw_pick.rowcount())
		
		IF llFindRow > 0 THEN
			ls_supp = idw_pick.getItemString(llFindRow, 'supp_code')
			ll_owner_id = idw_pick.getItemNumber( llFindRow, 'Owner_Id')
			ls_coo = idw_pick.getItemString( llFindRow, 'Country_Of_Origin')
			ls_loc = idw_pick.getItemString( llFindRow, 'L_Code')
			ls_inv_type = idw_pick.getItemString( llFindRow, 'Inventory_Type')
			ls_serial = idw_pick.getItemString( llFindRow, 'Serial_No')
			ls_lotno = idw_pick.getItemString( llFindRow, 'Lot_No')
			ls_pono = idw_pick.getItemString( llFindRow, 'Po_No')
			ld_qty = idw_pick.getItemNumber( llFindRow, 'Quantity')
			ldt_exp_date = idw_pick.getItemDateTime( llFindRow, 'Expiration_Date')
			
			ls_reason ='Container Split'
			ls_adj_type ='9'
			
			idw_pick.SetItem(llFindRow,  "po_no2",  ls_new_pono2)
		END IF
	END IF //Order Type

	//H. update serial_number_inventory table
	llSerialRows = idsSerial.RowCount()
	 
	If llSerialRows > 0 Then
		For iiRC = 1 to llSerialRows
			idsSerial.SetItem(iiRC, "po_no2", ls_new_pono2)
			idsSerial.SetItem(iiRC, "carton_id", ls_new_container_Id)
			idsSerial.SetItem(iiRC, "serial_flag", "P")
			idsSerial.SetItem(iiRC, "do_no", isDoNo)
			idsSerial.SetItem(iiRC, "transaction_type",  "MixedContainerizationUpdate")
			idsSerial.SetItem(iiRC, "transaction_id", isDoNo)
		Next
	End If   //End Serial Number Update
	
	//I. create stock adjustment to replace po_no2 with gsFootPrintBlankInd
	lds_adjust = Create Datastore
	ls_sql = " select * from Adjustment with(nolock) "
	ls_sql += " where Project_Id ='"+gs_project+"' and SKU ='"+isSKU+"' and wh_code= '"+isWhCode+"'"
	ls_sql += " and Po_No2 ='"+ls_pono2+"' and Container_Id ='"+ls_container_id+"' and Ref_No ='"+isDoNo+"'"
	
	lds_adjust.create( SQLCA.Syntaxfromsql( ls_sql, "", ls_errors))
	If ls_errors <> "" Then
		isMessage = "Error occurred while querying New Adjustment record in wf_mixed_containerization function.~r~r"
		Execute Immediate "ROLLBACK" using SQLCA;
		Return 1
	End If
	lds_adjust.settransobject( SQLCA)
	ll_rowcount = lds_adjust.retrieve( )
		
	IF ll_rowcount > 0 THEN
		ls_supp = lds_adjust.getItemString( 1, 'Supp_Code')
		ll_owner_id = lds_adjust.getItemNumber( 1, 'Owner_Id')
		ls_coo = lds_adjust.getItemString( 1, 'Country_Of_Origin')
		ls_loc = lds_adjust.getItemString( 1, 'L_Code')
		ls_inv_type = lds_adjust.getItemString( 1, 'Inventory_Type')
		ls_serial = lds_adjust.getItemString( 1, 'Serial_No')
		ls_lotno = lds_adjust.getItemString( 1, 'Lot_No')
		ls_rono = lds_adjust.getItemString( 1, 'Ro_No')
		ls_pono = lds_adjust.getItemString( 1, 'Po_No')
		ld_qty = lds_adjust.getItemNumber( 1, 'Quantity')
		ls_reason = lds_adjust.getItemString( 1, 'Reason')
		ldt_exp_date = lds_adjust.getItemDateTime( 1, 'Expiration_Date')
		ls_adj_type = lds_adjust.getItemString( 1, 'Adjustment_Type')

		idw_pick.SetItem(llFindRow,  "po_no2",  ls_new_pono2)
	END IF				
	
	//J. insert into Adjustment.
	Insert into Adjustment (Project_Id, SKU, Supp_Code, Owner_Id, Country_Of_Origin, WH_Code, L_Code, Inventory_Type, Serial_No, Lot_No, RO_No,
			PO_No, PO_No2, Old_Quantity, Quantity, Ref_No, Reason, Last_User,Last_Update, Old_Inventory_Type, Container_Id, Expiration_Date,	Old_Owner, 
			Old_Country_Of_Origin, Old_Po_No, Old_Po_No2, Old_Lot_No, Adjustment_Type, DWG_Upload, DWG_Upload_Timestamp, Remarks, Old_Expiration_Date)
	
	values (:gs_project, :isSKU, :ls_supp, :ll_owner_id, :ls_coo, :isWhCode, :ls_loc, :ls_inv_type, :ls_serial, :ls_lotno, :ls_rono, 
			:ls_pono, :ls_new_pono2, :ld_qty, :ld_qty, :isDoNo, :ls_reason, :gs_userId, :ldtToday, :ls_inv_type, :ls_new_container_Id, :ldt_exp_date, :ll_owner_id,
			:ls_coo, :ls_pono, :ls_pono2, :ls_lotno, :ls_adj_type, NULL, NULL, NULL, NULL)
	using sqlca;
	
	iiRC = idsSerial.Update( )
	If iiRC < 0 Then
			Execute Immediate "ROLLBACK" using SQLCA;
			MessageBox("Container Split - Mixed Containerization", "System error, record save failed!")
			f_method_trace_special( gs_project, this.ClassName() + ' - wf_mixed_containerization', 'End wf_mixed_containerization   FAILED System Error:' ,isDoNo, ' ',' ',isDoNo) 
			Return -1
	Else
		Execute Immediate "COMMIT" using SQLCA;

	End If
End If			


/********************************************END OF MIXED CONTAINERIZATION****************************************************************/
/********************************************START OF ALLOW PALLET ID TO BE CHANGED TO NA**************************************************/
If lbContinue and Not lbMixedContainerization Then
	lsMsg =  "Do you want to remove the existing Pallet ID "+isPoNo2+" against Container ID "+ls_container_id+&
				" and "+string(llSplitParticipants) + " other participant container(s), for this shipment? ~r~n~r~nClick $$HEX1$$1820$$ENDHEX$$Yes$$HEX2$$19202000$$ENDHEX$$to remove or $$HEX1$$1820$$ENDHEX$$No$$HEX2$$19202000$$ENDHEX$$to retain it."
	IF MessageBox("Mixed Containerization",lsMsg, Question!, YesNo!) = 1 Then
		ls_new_pono2 = gsFootPrintBlankInd
		ls_new_container_Id = ls_container_id
	ELSE
		liRtn = 1
		lbContinue = FALSE
	END IF
	
	If lbContinue Then
		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

		IF isOrderType = 'SOC' or isOrderType = 'StockTransfer' THEN
		
			//A. get ro_no from transfer detail content
			select Ro_No into :ls_rono from transfer_detail_content with(nolock) 
			where To_No =:isDoNo	and sku=:isSKU and Po_No2=:ls_pono2 
			using sqlca;
		
			//B. update transfer_detail/ transfer_detail_content table
			update transfer_detail_content set Po_No2=:ls_new_pono2
			where To_No =:isDoNo and sku=:isSKU and Po_No2=:ls_pono2
			//and container_id =:ls_container_id
			using sqlca;
		
			update transfer_detail set Po_No2=:ls_new_pono2
			where To_No =:isDoNo and sku=:isSKU and Po_No2=:ls_pono2
			//and container_id =:ls_container_id
			using sqlca;
			
			//C. get appropriate record details from transfer (full container)
			lsFind ="sku ='"+isSKU+"' and po_no2='"+ls_pono2+"' "
			llFindRow = idw_pick.find( lsFind, 1, idw_pick.rowcount())
			
			IF llFindRow > 0 THEN
				ls_supp = idw_pick.getItemString(llFindRow, 'supp_code')
				ll_owner_id = idw_pick.getItemNumber( llFindRow, 'Owner_Id')
				ls_coo = idw_pick.getItemString( llFindRow, 'Country_Of_Origin')
				ls_loc = idw_pick.getItemString( llFindRow, 'S_Location')
				ls_inv_type = idw_pick.getItemString( llFindRow, 'Inventory_Type')
				ls_serial = idw_pick.getItemString( llFindRow, 'Serial_No')
				ls_lotno = idw_pick.getItemString( llFindRow, 'Lot_No')
				ls_pono = idw_pick.getItemString( llFindRow, 'Po_No')
				ld_qty = idw_pick.getItemNumber( llFindRow, 'Quantity')
				ldt_exp_date = idw_pick.getItemDateTime( llFindRow, 'Expiration_Date')
				
				ls_reason ='Container Split'
				ls_adj_type ='9'
				
				idw_pick.SetItem(llFindRow,  "po_no2",  ls_new_pono2)
			END IF
			
		ELSE //Outbound Order
		
			//D. get ro_no from picking detail 
			select Ro_No into :ls_rono from delivery_picking_detail with(nolock) 
			where Do_No =:isDoNo	and sku=:isSKU and Po_No2=:ls_pono2
			using sqlca;
		
			//E. update delivery_picking/ delivery_picking_detail table
			update delivery_picking_detail set Po_No2=:ls_new_pono2
			where Do_No=:isDoNo and sku=:isSKU and Po_No2=:ls_pono2 		//and container_id = :ls_container_id
			//and container_id =:ls_container_id
			using sqlca;
			
			update delivery_picking set Po_No2=:ls_new_pono2 
			where Do_No=:isDoNo and sku=:isSKU and Po_No2=:ls_pono2 		//and container_id = :ls_container_id
			//and container_id = :ls_container_id
			using sqlca;
			
			//F. get appropriate record details from picking (full container)
			lsFind ="sku ='"+isSKU+"' and po_no2='"+ls_pono2+"' and container_id = '" + ls_container_id + "' "
			llFindRow = idw_pick.find( lsFind, 1, idw_pick.rowcount())
			
			IF llFindRow > 0 THEN
				ls_supp = idw_pick.getItemString(llFindRow, 'supp_code')
				ll_owner_id = idw_pick.getItemNumber( llFindRow, 'Owner_Id')
				ls_coo = idw_pick.getItemString( llFindRow, 'Country_Of_Origin')
				ls_loc = idw_pick.getItemString( llFindRow, 'L_Code')
				ls_inv_type = idw_pick.getItemString( llFindRow, 'Inventory_Type')
				ls_serial = idw_pick.getItemString( llFindRow, 'Serial_No')
				ls_lotno = idw_pick.getItemString( llFindRow, 'Lot_No')
				ls_pono = idw_pick.getItemString( llFindRow, 'Po_No')
				ld_qty = idw_pick.getItemNumber( llFindRow, 'Quantity')
				ldt_exp_date = idw_pick.getItemDateTime( llFindRow, 'Expiration_Date')
				
				ls_reason ='Container Split'
				ls_adj_type ='9'
			END IF
		END IF //Order Type

		//H. update serial_number_inventory table
		llSerialRows = idsSerial.RowCount()
		 
		If llSerialRows > 0 Then
			For iiRC = 1 to llSerialRows
				idsSerial.SetItem(iiRC, "po_no2", ls_new_pono2)
				//idsSerial.SetItem(iiRC, "carton_id", ls_new_container_Id)
				idsSerial.SetItem(iiRC, "serial_flag", "P")
				idsSerial.SetItem(iiRC, "do_no", isDoNo)
				idsSerial.SetItem(iiRC, "transaction_type",  "MixedContainerizationUpdate")
				idsSerial.SetItem(iiRC, "transaction_id", isDoNo)
			Next
		End If   //End Serial Number Update
			
	//I. create stock adjustment to replace po_no2 with gsFootPrintBlankInd
	lds_adjust = Create Datastore
	ls_sql = " select * from Adjustment with(nolock) "
	ls_sql += " where Project_Id ='"+gs_project+"' and SKU ='"+isSKU+"' and wh_code= '"+isWhCode+"'"
	ls_sql += " and Po_No2 ='"+ls_pono2+"' and Container_Id ='"+ls_container_id+"' and Ref_No ='"+isDoNo+"'"
	
	lds_adjust.create( SQLCA.Syntaxfromsql( ls_sql, "", ls_errors))
	If ls_errors <> "" Then
		isMessage = "Error occurred while querying New Adjustment record in wf_mixed_containerization function.~r~r"
		Execute Immediate "ROLLBACK" using SQLCA;
		Return 1
	End If
	lds_adjust.settransobject( SQLCA)
	ll_rowcount = lds_adjust.retrieve( )
	
	IF ll_rowcount > 0 THEN
			ls_supp = lds_adjust.getItemString( 1, 'Supp_Code')
			ll_owner_id = lds_adjust.getItemNumber( 1, 'Owner_Id')
			ls_coo = lds_adjust.getItemString( 1, 'Country_Of_Origin')
			ls_loc = lds_adjust.getItemString( 1, 'L_Code')
			ls_inv_type = lds_adjust.getItemString( 1, 'Inventory_Type')
			ls_serial = lds_adjust.getItemString( 1, 'Serial_No')
			ls_lotno = lds_adjust.getItemString( 1, 'Lot_No')
			ls_rono = lds_adjust.getItemString( 1, 'Ro_No')
			ls_pono = lds_adjust.getItemString( 1, 'Po_No')
			ld_qty = lds_adjust.getItemNumber( 1, 'Quantity')
			ls_reason = lds_adjust.getItemString( 1, 'Reason')
			ldt_exp_date = lds_adjust.getItemDateTime( 1, 'Expiration_Date')
			ls_adj_type = lds_adjust.getItemString( 1, 'Adjustment_Type')
		END IF				
		
		//J. insert into Adjustment.
		Insert into Adjustment (Project_Id, SKU, Supp_Code, Owner_Id, Country_Of_Origin, WH_Code, L_Code, Inventory_Type, Serial_No, Lot_No, RO_No,
				PO_No, PO_No2, Old_Quantity, Quantity, Ref_No, Reason, Last_User,Last_Update, Old_Inventory_Type, Container_Id, Expiration_Date,	Old_Owner, 
				Old_Country_Of_Origin, Old_Po_No, Old_Po_No2, Old_Lot_No, Adjustment_Type, DWG_Upload, DWG_Upload_Timestamp, Remarks, Old_Expiration_Date)
		
		values (:gs_project, :isSKU, :ls_supp, :ll_owner_id, :ls_coo, :isWhCode, :ls_loc, :ls_inv_type, :ls_serial, :ls_lotno, :ls_rono, 
				:ls_pono, :ls_new_pono2, :ld_qty, :ld_qty, :isDoNo, :ls_reason, :gs_userId, :ldtToday, :ls_inv_type, :ls_new_container_Id, :ldt_exp_date, :ll_owner_id,
				:ls_coo, :ls_pono, :ls_pono2, :ls_lotno, :ls_adj_type, NULL, NULL, NULL, NULL)
		using sqlca;
	End If	
	
	iiRC = idsSerial.Update()
	If iiRC < 0 Then
			Execute Immediate "ROLLBACK" using SQLCA;
			MessageBox("Container Split - Mixed Containerization", "System error, record save failed!")
			f_method_trace_special( gs_project, this.ClassName() + ' - wf_mixed_containerization', 'End wf_mixed_containerization   FAILED System Error:' ,isDoNo, ' ',' ',isDoNo) 
			Return -1
	Else  
		Execute Immediate "COMMIT" using SQLCA;

	End If
End If
			
/********************************************END OF ALLOW PALLET ID TO BE CHANGED TO NA**************************************************/

If ls_new_pono2 <> ls_pono2 Then
	isPoNo2 = ls_new_pono2
Else
	isPoNo2 = ls_pono2 //re-set original PoNo2 value	DE13724 11/22/2019 GailM - Reset isPoNo2 to original from beginning of function.
End If

destroy lds_adjust

Return liRtn
end function

public function string getcontainerlist (datawindow adw, datastore ads, string aspono2);// Return a comma-delimited list of containers for the pick list...  These participate in the move
String lsRtn
Int liIdx

If adw.rowcount() > 0 Then
	For liIdx = 1 to adw.rowcount()
		If adw.GetItemString(liIdx, 'po_no2') = asPoNo2 Then
			lsRtn += "'" + adw.GetItemString(liIdx, 'container_id') + "',"
		End If
	Next
End If

If Len(lsRtn) > 0 Then lsRtn = Left(lsRtn, Len(lsRtn)-1)
lsRtn = "(" + lsRtn + ")"


Return lsRtn
end function

public function string getmultirono ();//GailM 1/30/2020 DE14438 Assign a rono if there are more than one
String lsRtn		//Return a rono
String lsRoNo, lsDone
Int liPickRows, liDetailRows, i, j, k
Long llPickQty, llDetailQty
llPickQty = idw_pick.GetItemNumber(1,"quantity")
liDetailRows = idsPickDetail.rowcount()
lsRoNo = ""
lsDone = ""

For i = 1 to liDetailRows
	k = 1
	llDetailQty = idsPickDetail.getitemnumber(i, 'quantity')
	lsRoNo = idsPickDetail.getitemstring(i, 'ro_no')
	For j = 1 to idsSerialValidate.rowcount()
		If idsSerialValidate.getitemstring(j,'ro_no') = lsRoNo Then k++
	Next
	If k <= llDetailQty Then 
		lsRtn = lsRoNo
		exit
	End If
Next

Return lsRtn

end function

public function long myserialfilter (datastore adsserial, string aspicked, string aspicked2);Long llRtn
Int i, liPos1, liPos2, li
String lsSerialNo

If idsSerial.RowCount() = 0 Then Return 0

For i = idsSerial.RowCount() to 1 Step -1
	lsSerialNo = idsSerial.GetItemString(i, "serial_no")
	liPos1 = Pos(asPicked, lsSerialNo, 1)
	liPos2 = Pos(asPicked2, lsSerialNo, 1)
	If liPos1 = 0 and liPos2 = 0 Then
		idsSerial.RowsMove(i, i, Primary!, idsSerial, i + 1, Filter!)
	End If
Next

llRtn = idsSerial.RowCount()

Return llRtn

end function

on w_pick_pallet.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.st_msg=create st_msg
this.cb_5=create cb_5
this.st_msg2=create st_msg2
this.lb_carton_list=create lb_carton_list
this.sle_palletid=create sle_palletid
this.sle_containerid=create sle_containerid
this.cb_genpallet=create cb_genpallet
this.cb_gencon=create cb_gencon
this.dw_3=create dw_3
this.sle_2=create sle_2
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_3
this.Control[iCurrent+8]=this.cb_4
this.Control[iCurrent+9]=this.st_msg
this.Control[iCurrent+10]=this.cb_5
this.Control[iCurrent+11]=this.st_msg2
this.Control[iCurrent+12]=this.lb_carton_list
this.Control[iCurrent+13]=this.sle_palletid
this.Control[iCurrent+14]=this.sle_containerid
this.Control[iCurrent+15]=this.cb_genpallet
this.Control[iCurrent+16]=this.cb_gencon
this.Control[iCurrent+17]=this.dw_3
this.Control[iCurrent+18]=this.sle_2
this.Control[iCurrent+19]=this.st_2
this.Control[iCurrent+20]=this.st_3
end on

on w_pick_pallet.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.st_msg)
destroy(this.cb_5)
destroy(this.st_msg2)
destroy(this.lb_carton_list)
destroy(this.sle_palletid)
destroy(this.sle_containerid)
destroy(this.cb_genpallet)
destroy(this.cb_gencon)
destroy(this.dw_3)
destroy(this.sle_2)
destroy(this.st_2)
destroy(this.st_3)
end on

event open;call super::open;
String lsFilter, lsSort, lsFind, lsSql, lsSqlSyntax, lsGPNConversionFlag
Long llTotalReqQty, llThisPalletReqQty, llSerialRow, lldw2Row, llPickDetailRows, llPos, llLineItemNo
String lsCarton, lsPrevCarton, lsError, lsWhere, lsMsg, lsContainerList
Int i, liPos
Datetime ldtExpDt
datastore ldsSerial

ipStrParms = message.PowerObjectParm
lsPrevCarton = ""
ibSNChanged = FALSE

isOrigContainer = ipStrParms.string_arg[2] 
isScanned = ipStrParms.string_arg[2]
isInvoiceNo = ipStrParms.String_Arg[3]
isWhCode = ipStrParms.String_Arg[4]
isOrderType = ipStrParms.String_Arg[5]
ilDetailReqQty = ipStrParms.long_arg[1]
ilPickQty = ipStrParms.long_arg[2]
iiCurrPickRow = ipStrParms.integer_arg[1]
isColorCode = ipStrParms.String_Arg[6]
isMixedType = ipStrParms.String_Arg[7]
isLocation = ipStrParms.String_Arg[8] 

ibPharmacyProcessing = ipStrParms.Boolean_Arg[1]
llSplitParticipants = 0
iiMultiRono = 1

ids1 = ipStrParms.datastore_arg[1]	//Original
ids2 = ipStrParms.datastore_arg[2]	//Selected serials
ids3 = ipStrParms.datastore_arg[3]	//d_do_picking of the container to be split
idw_pick = ipStrParms.datawindow_arg[1]	//The pick list
idw_pick_detail  = ipStrParms.datawindow_arg[1]	
idw_transfer_detail_content  = ipStrParms.datawindow_arg[2]	

idsPickDetail = Create u_ds_ancestor
If isOrderType = 'SOC' Then
	idsPickDetail.dataobject = 'd_owner_change_detail_content'
ElseIf isOrderType = 'StockTransfer' Then
	idsPickDetail.dataobject = 'd_tran_detail_content'
Else
	idsPickDetail.dataobject = 'd_do_pick_detail' 
End If
idsPickDetail.SetTransObject(SQLCA)

idsContent = Create u_ds_ancestor
idsContent.dataobject = 'd_content_pallet'
idsContent.SetTransObject(SQLCA)

idsContentSummary = Create u_ds_ancestor
idsContentSummary.dataobject = 'd_content_summary_pallet'
idsContentSummary.SetTransObject(SQLCA)

idsSerialValidate = Create u_ds_ancestor
idsSerialValidate.DataObject = 'd_serial_inventory_validate'
idsSerialValidate.SetTransObject(SQLCA)

isSKU = ids3.GetItemString(1,"SKU")
isPoNo2 = ids3.GetItemString(1,"po_no2")
isNewPoNo2 = isPoNo2		//Initialize new pono2 to original pono2
isContainerId = ids3.GetItemString(1,"container_id")
isNewContainer = isContainerId 	//Initialize new container to original containerId

ilContentSummaryRows = idsContentSummary.Retrieve( gs_project, isWhCode, isSKU, isPoNo2, isContainerId, gsFootprintBlankInd )		//All content summary rows for the pallet
ilContentRows = idsContent.Retrieve( gs_project, isWhCode, isSKU, isPoNo2)		//All content rows for the pallet

If isOrderType = "StockTransfer" OR isOrderType = "SOC" Then
	isDoNo = idw_pick.GetItemString(iiCurrPickRow, "to_no")
Else
	isDoNo = idw_pick.GetItemString(iiCurrPickRow, "do_no")
	ilCompNo = idw_pick.GetItemNumber(iiCurrPickRow, "component_no")
	isZoneId = idw_pick.GetItemString(iiCurrPickRow, "zone_id")
End If

isSupplier = idw_pick.GetItemString(iiCurrPickRow, "supp_code")
ilOwnerId = idw_pick.GetItemNumber(iiCurrPickRow, "owner_id")
isInvType = idw_pick.GetItemString(iiCurrPickRow, "inventory_type")
isSerialNo = idw_pick.GetItemString(iiCurrPickRow, "serial_no")
isLotNo = idw_pick.GetItemString(iiCurrPickRow, "lot_no")
isPoNo = idw_pick.GetItemString(iiCurrPickRow, "po_no")
isCOO = idw_pick.GetItemString(iiCurrPickRow, "country_of_origin")
ldtExpDt = idw_pick.GetItemDatetime(iiCurrPickRow, "expiration_date")
llLineItemNo = idw_pick.GetItemNumber(iiCurrPickRow, "line_item_no")

If isOrderType = 'SOC' Then
	llPickDetailRows = idsPickDetail.Retrieve( isDoNo )
ElseIf isOrderType = 'StockTransfer' Then
	liPos = pos(isLocation,"/") 	
	If liPos > 0 Then
		is_sLocation = left(isLocation, liPos - 1)
		is_dLocation = right(isLocation,len(isLocation) - liPos)
		isLocation = is_sLocation
	Else
		is_sLocation = isLocation
		is_dLocation = isLocation
	End If

	llPickDetailRows = idsPickDetail.Retrieve(isDoNo,isSKU,isSupplier,ilOwnerId,is_sLocation,is_dLocation,isInvType,isSerialNo,isLotNo,isPoNo,isPoNo2,isContainerId,ldtExpDt,isCOO)
	iiMultiRono = llPickDetailRows
Else
	llPickDetailRows = idsPickDetail.Retrieve( isDoNo, isSKU,isSupplier, ilOwnerId, isCOO, isLocation, isInvType, isSerialNo, isLotNo, isPoNo, isPoNo2, llLineItemNo, isContainerId, ldtExpDt, ilCompNo, isZoneId)
End If

If llPickDetailRows = -1 then
	MessageBox("Pick Detail Retrieve Error","Retieve error on Pick Detail: " + SQLCA.SQLErrText)
Else
	If llPickDetailRows = 0 then			//If there is a mismatch between picking and picking detail
		lsMsg = "Could not retrieve Pick Detail.~n~r"
		lsMsg += " One of the below variables is incorrect: ~n~r"
		lsMsg += "isDoNo:" + isDoNo + "~n~r"
		lsMsg += "isSKU:" + isSKU + "~n~r" 	
		lsMsg += "isSupplier:" + isSupplier + "~n~r" 	
		lsMsg += "ilOwnerId:" + string(ilOwnerId) + "~n~r"	
		lsMsg += "isCOO:" + isCOO + "~n~r" 	
		lsMsg += "isLocation:" + isLocation + "~n~r"	
		lsMsg += "isInvType:" + isInvType + "~n~r" 	
		lsMsg += "isSerialNo:" + isSerialNo + "~n~r" 	
		lsMsg += "isLotNo:" + isLotNo + "~n~r" 	
		lsMsg += "isPoNo:" + isPoNo + "~n~r" 	
		lsMsg += "isPoNo2:" + isPoNo2 + "~n~r" 	
		lsMsg += "iiCurrPickRow:" + string(iiCurrPickRow) + "~n~r" 	
		lsMsg += "isContainerId:" + isContainerId + "~n~r" 	
		lsMsg += "ldtExpDt:" + string(ldtExpDt) + "~n~r" 	
		lsMsg += "ilCompNo:" + string(ilCompNo) + "~n~r" 	
		lsMsg += "isZoneId:" + isZoneId
		
		//Do not show this error message at this time....  Check method trace to research reason detail cannot be retrieved.
		//MessageBox("Pick Detail Retrieve Warning","System Error 10002.  ~r~nThis does not affect current processing.  Please continue.")
		
		f_method_trace_special( gs_project, this.ClassName() , lsMsg,isDoNo,'','',isInvoiceNo)

	Else
		isRoNo = idsPickDetail.GetItemString(1, "ro_no")
	End If
End If

 //GailM 9/5/2019 S37314 F17337 I1304 Google Footprints GPN Conversion Process - Turn this off until needed
lsGPNConversionFlag = f_retrieve_parm("PANDORA","FOOTPRINT","GPN_CONVERSION")
If lsGPNConversionFlag = 'Y' Then
	If isColorCode <> '9' and isColorCode <> '' and isColorCode <> '0' Then
		sle_palletid.visible = FALSE
		sle_containerid.visible = FALSE
		cb_genpallet.visible = FALSE
		cb_gencon.visible = FALSE
		sle_2.text = ''
		st_2.text = ''
		st_3.text = ''
	Else
		cb_1.visible = FALSE
		cb_2.visible = FALSE
		cb_4.visible = FALSE
		cb_1.enabled = FALSE
		cb_2.enabled = FALSE
		cb_4.enabled = FALSE
		If isColorCode = '' or isColorCode = '0' Then
			cb_3.visible = FALSE
			cb_3.enabled = FALSE
			sle_1.enabled = FALSE
		End If
	End If
End If

If lsError = 'Y' Then 
	This.TriggerEvent("ue_close")
Else
	lsContainerList = getContainerList(idw_pick, ids1, isPoNo2)	//List of containers allocated from pick list

	If isPoNo2 = gsFootPrintBlankInd or isColorCode = "5" Then
		lsFilter = "carton_id = '" + isContainerId + "' "
	ElseIf ibPharmacyProcessing Then
		lsFilter = "" 
	Else
		lsFilter = "carton_id IN " + lsContainerList
	End If
	ids1.SetFilter(lsFilter)
	ids1.Filter()

	If isOrderType = 'SOC' or isOrderType = 'StockTransfer' Then
		lsFilter = "container_id = '" + isContainerId + "' and l_code = '" + isLocation + "' "
		idsContent.SetFilter(lsFilter)
		idsContent.Filter()
		lsFilter += " and tfr_in = 0 "
		idsContentSummary.SetFilter(lsFilter)
		idsContentSummary.Filter()
		//lsFilter = "container_id = '" + isContainerId + "' and s_location = '" + isLocation + "' "

		llTotalReqQty = idw_pick.getitemnumber( iiCurrPickRow, 'quantity' )
	Else
		//GailM DE7392 - Are there multiple pallets in picking?  If so, reduce ilDetailReqQty for only present pallet.
		lsFilter = "sku = '" + isSKU + "' " 
		idw_pick.SetFilter(lsFilter)
		idw_pick.Filter()
		For i = 1 to idw_pick.rowcount()
			llTotalReqQty += idw_pick.getitemnumber( i, 'quantity' )
			If idw_pick.getitemstring( i, 'po_no2' ) = isPoNo2 	Then
				llThisPalletReqQty += idw_pick.getitemnumber( i, 'quantity' )
			End If
		Next
		ilDetailReqQty = llTotalReqQty
		If llThisPalletReqQty < ilDetailReqQty Then
			ilDetailReqQty = llThisPalletReqQty			//Multiple pallets, use total for this pallet only
		End If
		If ilDetailReqQty > ilPickQty	Then					//Cannot have a target qty larger than this pick row qty
			ilDetailReqQty = ilPickQty
		End If
	End If
	
	//GailM 6/14/2019 DE11156 Dynamic breaking of mixed containerization - detail req qty from pick record only
	//If there are more than one pick record at this point means that there are multiple containers.  Need to use the select pick record required qty
	If isColorCode = "8" and idw_pick.rowcount() > 1 Then
		ilDetailReqQty = ilPickQty
	End if
	
	lsSort = "po_no2, carton_id, serial_no"

	//GailM 9/20/2019 S37769 Footprint GPN Conversion Process
	If (isColorCode = "9" or isColorCode = "" or isColorCode = "0") and idw_pick.rowcount() > 0 Then
		ilDetailReqQty = idw_pick.GetItemNumber(1,"quantity")
		This.Title = "Add serial numbers: - Tier: 1: Pallet - 2: Container - 3: SN"
		lsSqlSyntax = idsSerialValidate.GetSqlSelect()
		//llPos = Pos(lsSqlSyntax, "WHERE", 1)
		lsWhere   = " WHERE Serial_Number_Inventory.Project_id = '" + gs_project + "' and Serial_Number_Inventory.po_no2 = '" + isPoNo2 + "' "  
		lsWhere += " and Serial_Number_Inventory.wh_code = '" + isWhCode + "' and Serial_Number_Inventory.l_code = '" + isLocation + "' "
		lsWhere += " and Serial_Number_Inventory.sku = '"+ isSKU + "' and Serial_Number_Inventory.carton_id = '" + isContainerId + "' "
		If (isPoNo2 = "-" and isContainerId = "-")  or (isPoNo2 = "-" and isContainerId = "-") Then	// Loose Serials must be linked to the order
			lsWhere += " and Serial_Number_Inventory.Serial_Flag = 'L' and Serial_Number_Inventory.Do_No = '" + isDoNo + "' "
		End If
		//DE14186 Filter out any serial numbers with a question mark in front of a Serial No
		lsWhere += " and Left(Serial_Number_Inventory.Serial_No,1) <> '?' "
		
		lsSql = lsSqlSyntax + lsWhere
		
		i = idsSerialValidate.SetSqlSelect(lsSql)
		If i <> 1 Then
			MessageBox("Error Retrieving Serial Numbers","An error has been encountered when setting the serial number validate query. ~r~n~r~n" + lsSql)
			This.TriggerEvent("ue_close")
		End If
		
		ilSerialRows = idsSerialValidate.Retrieve(gs_project, isPoNo2)
		
		If ilSerialRows > 0 Then
			For llSerialRow = 1 to ilSerialRows
				lldw2Row = dw_2.InsertRow(0)
				dw_2.SetItem(lldw2Row, "po_no2", idsSerialValidate.GetItemString(llSerialRow, "po_no2"))
				dw_2.SetItem(lldw2Row, "carton_id", idsSerialValidate.GetItemString(llSerialRow, "carton_id"))
				dw_2.SetItem(lldw2Row, "serial_no", idsSerialValidate.GetItemString(llSerialRow, "serial_no"))
			Next
			dw_2.SetSort(lsSort)
			dw_2.Sort()
			dw_2.ExpandAll()
		End If
	End If
	
	If llTotalReqQty < ids1.RowCount()  and isColorCode = "9" Then
		ids1.RowsCopy(ids1.GetRow(), llTotalReqQty, Primary!, dw_1, 1, Primary!)
	Else
		ids1.RowsCopy(ids1.GetRow(), ids1.RowCount(), Primary!, dw_1, 1, Primary!)
	End If
	
	sle_1.SetFocus( )
	dw_1.SetSort(lsSort)
	dw_1.Sort()
	idw_pick.SetFilter("")
	idw_pick.Filter()
	idw_pick.SetSort("")
	idw_pick.Sort()
	
	dw_1.ExpandAll()
	
dw_3.of_register(sle_2)
dw_3.setTransObject(sqlca)
dw_3.retrieve()
	
End If
end event

event mousemove;call super::mousemove;/* Show button tag below command buttons */

IF xpos >= cb_1.X AND (xpos <= cb_1.x + cb_1.Width) AND &
     ypos >= cb_1.y AND (ypos <= cb_1.y + cb_1.Height) THEN
   st_msg.text = cb_1.tag
ELSEIF xpos >= cb_2.X AND (xpos <= cb_2.x + cb_2.Width) AND &
     ypos >= cb_2.y AND (ypos <= cb_2.y + cb_2.Height) THEN
   		st_msg.text = cb_2.tag
ELSEIF xpos >= cb_3.X AND (xpos <= cb_3.x + cb_3.Width) AND &
     ypos >= cb_3.y AND (ypos <= cb_3.y + cb_3.Height) THEN
   		st_msg.text = cb_3.tag
ELSEIF xpos >= cb_4.X AND (xpos <= cb_4.x + cb_4.Width) AND &
     ypos >= cb_4.y AND (ypos <= cb_4.y + cb_4.Height) THEN
   		st_msg.text = cb_4.tag
ELSE
  	 st_msg.text = ""
END IF

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_pick_pallet
integer x = 1690
integer y = 1152
end type

event cb_cancel::clicked;call super::clicked;//istrparms.string_arg[4] = 'Close'
end event

type cb_ok from w_response_ancestor`cb_ok within w_pick_pallet
boolean visible = false
integer x = 1339
integer y = 1139
integer height = 48
boolean enabled = false
boolean default = false
end type

event cb_ok::clicked;call super::clicked;
//ids1.reset( )
//ids2.reset( )

dw_1.RowsCopy(1, dw_1.RowCount(), Primary!, ids1, 1, Primary!)
dw_2.RowsCopy(1, dw_2.RowCount(), Primary!, ids2, 1, Primary!)

ipStrParms.datastore_arg[1] = ids1
ipStrParms.datastore_arg[2] = ids2

end event

type dw_1 from u_dw_ancestor within w_pick_pallet
event selectionchanged pbm_tvnselchanged
event ue_keydown pbm_dwnkey
string tag = "Holds pre-selected serial numbers"
integer x = 22
integer y = 19
integer width = 827
integer height = 883
boolean bringtotop = true
string dataobject = "d_pick_pallet"
end type

event selectionchanged;
TreeViewItem l_tvinew, l_tviold
 
// get the treeview item that was the old selection
//This.GetItem(oldhandle, l_tviold)
 
// get the treeview item that is currently selected
//This.GetItem(newhandle, l_tvinew)
 
// Display the labels for the two items in sle_get
st_msg2.Text = "Selection changed from " &
   + String(l_tviold.Label) + " to " &
   + String(l_tvinew.Label)



end event

event ue_keydown;Long llRtn

If KeyDown( KeyControl! ) Then
	ibKeyCntl = TRUE
	ibKeyShift = FALSE
ElseIf KeyDown( KeyShift! ) Then
	ibKeyShift = TRUE
	ibKeyCntl = FALSE
Else
	ibKeyCntl = FALSE
	ibKeyShift = FALSE
End If

return llRtn

end event

event clicked;call super::clicked;//Should we use pbm_keydown or pbm_dwnkey?  Try both.   pbm_keydown is for the window event and pbm_dwnkey is for the datawindows key event.

iiClickedRow1 = this.getclickedrow()
String lsThisLevel
int liRowPos
string ls_obj

If iiClickedRow1 > 0 THEN
     // detail band
     lsThisLevel = dwo.name

	If (lsThisLevel = isPrevLevel) Then		//Same level
		If ibKeyShift = TRUE Then
			If iiClickedRow1 <> iiPrevRow Then		//Different row.  Attempt to select all rows between
				If iiPrevRow > iiClickedRow1 Then
					For liRowPos = iiClickedRow1 to iiPrevRow
						SelectRow( liRowPos, TRUE )
					Next
				Else
					For liRowPos = iiPrevRow to iiClickedRow1
						SelectRow( liRowPos, TRUE )
					Next
				End If
			End If
		ElseIf ibKeyCntl Then
			SelectRow( iiPrevRow, TRUE )
			SelectRow( iiClickedRow1, TRUE )
		Else
			For liRowPos = 1 to dw_1.rowcount()
				If liRowPos = iiClickedRow1 Then
					SelectRow( liRowPos, TRUE )
				Else
					SelectRow( liRowPos, FALSE )
				End If
			Next
		End if
	Else
		For liRowPos = 1 to dw_1.rowcount()
			If liRowPos = iiClickedRow1 Then
				SelectRow( liRowPos, TRUE )
			Else
				SelectRow( liRowPos, FALSE )
			End If
		Next
	End If  
Else	
	For liRowPos = 1 to dw_1.rowcount()
		If liRowPos = iiClickedRow1 Then
			SelectRow( liRowPos, TRUE )
		Else
			SelectRow( liRowPos, FALSE )
		End If
	Next

END IF
 
ibKeyShift = FALSE
ibKeyCntl = FALSE
isPrevLevel = lsThisLevel
iiPrevRow = iiClickedRow1
 
		  



end event

event constructor;call super::constructor;
//itvi_1 = 

Long ll_handle,ll_required_handle
String ls_label = 'Label_H'

//ll_handle = itvi_1.FindItem(RootTreeItem!,0)
end event

event getfocus;call super::getfocus;sle_2.Text = This.Tag
end event

event losefocus;call super::losefocus;sle_2.Text = ""
end event

type dw_2 from u_dw_ancestor within w_pick_pallet
event ue_keydown2 pbm_dwnkey
string tag = "Holds selected serial numbers"
integer x = 1145
integer y = 19
integer width = 827
integer height = 883
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pick_pallet"
end type

event ue_keydown2;Long llRtn

If KeyDown( KeyControl! ) Then
	ibKeyCntl = TRUE
Else
	ibKeyCntl = FALSE
End If

return llRtn

end event

event clicked;call super::clicked;
String lsThisLevel
int liRowPos
string ls_obj

iiClickedRow2 = this.getclickedrow()

If iiClickedRow2 > 0 THEN
     // detail band
     lsThisLevel = dwo.name

	If lsThisLevel = isPrevLevel and ibKeyCntl = TRUE Then		//Same level
		If iiClickedRow2 <> iiPrevRow Then		//Different row.  Attempt to select all rows between
			If iiPrevRow > iiClickedRow2 Then
				For liRowPos = iiClickedRow2 to iiPrevRow
					SelectRow( liRowPos, TRUE )
				Next
			Else
				For liRowPos = iiPrevRow to iiClickedRow2
					SelectRow( liRowPos, TRUE )
				Next
			End If
		End If
	Else
		For liRowPos = 1 to dw_2.rowcount()
			If liRowPos = iiClickedRow2 Then
				SelectRow( liRowPos, TRUE )
			Else
				SelectRow( liRowPos, FALSE )
			End If
		Next
	End If  
	ibKeyCntl = FALSE
	isPrevLevel = lsThisLevel
	iiPrevRow = iiClickedRow2
ELSE
        // outside detail band
        ls_obj = This.GetObjectAtPointer()
        lsThisLevel = Left( ls_obj, Pos( ls_obj, "~t") - 1 )
        iiClickedRow2 = Integer( Right( ls_obj, Len( ls_obj ) - Pos(ls_obj, "~t") ) )
		If lsThisLevel = isPrevLevel  Then
			If iiClickedRow2 <> iiPrevRow Then
				If ibKeyCntl Then
					parent.st_msg2.text = "Attempt to multiselect with: " + lsThisLevel + ";" + string(iiClickedRow2)
				Else
					parent.st_msg2.text = "Not getting the control key: " + lsThisLevel + ";" + string(iiClickedRow2)
				End If
			End If
		Else
			parent.st_msg2.text = ""
			
		End If
		iiPrevRow = iiClickedRow2
		isPrevLevel = lsThisLevel
		  
END IF
//st_msg.text = string(iiClickedRow1)
//st_msg2.text = string(iiClickedRow2)
end event

event getfocus;call super::getfocus;sle_2.Text = This.Tag
end event

event losefocus;call super::losefocus;sle_2.Text = ""
end event

type st_1 from statictext within w_pick_pallet
integer x = 40
integer y = 1200
integer width = 194
integer height = 61
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Scan:"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_pick_pallet
event add_serial_number ( )
string tag = "Scan Serial Numbers"
integer x = 260
integer y = 1168
integer width = 900
integer height = 93
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event add_serial_number();//GailM 9/5/2019 S37314 F17337 I1304 Google Footprints GPN Conversion Process
Long llRow, llDel, llRowCount, llFound
Integer liRtn
String lsFind, lsMsg
isScanned = sle_1.text

If dw_1.rowcount() > 0 Then
	If dw_2.rowcount() > 0 and isScanned <> '' Then //Check for duplicate	
		lsFind = "serial_no = '" + isScanned + "' "
		llFound = dw_2.Find(lsFind, 1, dw_2.rowcount())
		If llFound > 0 Then
			messagebox("Serial Error","Serial Number has already been scanned.")
		Else
			llRow = 1
			//Does the serial number already exists in serial number inventory table?
			ipSerParms.String_Arg[1] = isScanned
			ipSerParms = f_serial_number_exists(ipSerParms)
			
			If ipSerParms.Long_Arg[1] = 0 Then
				dw_1.SetItem(1, "serial_no", isScanned)
				dw_1.RowsMove(llRow, llRow, Primary!,  dw_2, dw_2.rowcount() + 1, Primary!)
				st_msg2.text = "Target: " + String(ilDetailReqQty) + "  Assigned: " + String(dw_2.rowcount())
				ibSNChanged = TRUE
			Else
				lsMsg = "The requested serial number already exists in serial number inventory table.~r~n"
				lsMsg += "SerialNo: " + ipSerParms.String_Arg[1] + ", GPN: " + ipSerParms.String_Arg[4] + "~r~n"
				lsMsg +=	 "WhCode: " + ipSerParms.String_Arg[2] + ", Location: " + ipSerParms.String_Arg[3] + "~r~n" 
				lsMsg += "PalletID: " + ipSerParms.String_Arg[5] + ", CartonID: " + ipSerParms.String_Arg[6]
				lsMsg += "~r~n~r~n          Do you wish to keep this serial number?"
				If MessageBox("Add Serial Number", lsMsg, Question!, YesNo!) = 1 Then
					dw_1.SetItem(1, "serial_no", isScanned)
					dw_1.RowsMove(llRow, llRow, Primary!,  dw_2, dw_2.rowcount() + 1, Primary!)
					st_msg2.text = "Target: " + String(ilDetailReqQty) + "  Assigned: " + String(dw_2.rowcount())
				End If
			End If
		End If
	Else
		llRow = 1
		dw_1.SetItem(1, "serial_no", isScanned)
		dw_1.RowsMove(llRow, llRow, Primary!,  dw_2, dw_2.rowcount() + 1, Primary!)
		st_msg2.text = "Target: " + String(ilDetailReqQty) + "  Assigned: " + String(dw_2.rowcount())
		ibSNChanged = TRUE
	End If
Else
	messagebox("Add a serial number","All serial numbers have been entered.")
End If

dw_2.ExpandAll()

sle_1.SetFocus()
if isColorCode = "9" Then st_msg.text = "Scan serial numbers"
//messagebox("Add a serial number","We must add a serial number " + isScanned + ". With required qty: " + string(ilDetailReqQty))

end event

event modified;Long llRow, llDel, llRowCount
Integer liRtn
isScanned = sle_1.text

If isColorCode = "9" Then			//Entering serial numbers
	This.TriggerEvent("add_serial_number")
Else

	llRowCount = dw_1.RowCount()
	isFind = "po_no2 = '" + isScanned + "' "
	iiFound = dw_1.Find(isFind, 1, dw_1.rowcount())
	If iiFound > 0 Then
		For llRow = llRowCount to 1 Step -1
			If dw_1.GetItemString(llRow, "po_no2" ) = isScanned Then
				liRtn = dw_1.RowsMove( llRow, llRow, Primary!, dw_1, llRowCount+1, Delete! )
			End If
		Next
		dw_1.RowsMove(1, dw_1.DeletedCount(), Delete!,  dw_2, 1, Primary!)
		dw_2.SetSort("po_no2, carton_id, serial_no")
		dw_2.Sort()
	Else
		isFind = "carton_id = '" + isScanned + "' "
		iiFound = dw_1.Find(isFind, 1, llRowCount)
		If iiFound > 0 Then
			For llRow = llRowCount to 1 Step -1
				If dw_1.GetItemString(llRow, "carton_id" ) = isScanned Then
					liRtn = dw_1.RowsMove( llRow, llRow, Primary!, dw_1, llRowCount+1, Delete! )
				End If
			Next
			dw_1.RowsMove(1, dw_1.DeletedCount(), Delete!,  dw_2, 1, Primary!)
			dw_2.SetSort("po_no2, carton_id, serial_no")
			dw_2.Sort()
		Else
			isFind = "serial_no = '" + isScanned + "' "
			iiFound = dw_1.Find(isFind, 1, dw_1.rowcount())
			If iiFound > 0 Then
				For llRow = llRowCount to 1 Step -1
					If dw_1.GetItemString(llRow, "serial_no" ) = isScanned Then
						liRtn = dw_1.RowsMove( llRow, llRow, Primary!, dw_1, llRowCount+1, Delete! )
					End If
				Next
				dw_1.RowsMove(1, dw_1.DeletedCount(), Delete!,  dw_2, 1, Primary!)
				dw_2.SetSort("po_no2, carton_id, serial_no")
				dw_2.Sort()
			Else
				messagebox("Results","Scanned entry not found")
			End If
		End If
	End If
End If

sle_1.text = ''

end event

event getfocus;sle_2.Text = This.Tag
end event

event losefocus;sle_2.Text = ""
end event

type cb_1 from commandbutton within w_pick_pallet
string tag = "Move selectted serial numbers to the right"
integer x = 889
integer y = 301
integer width = 201
integer height = 144
integer taborder = 20
boolean bringtotop = true
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;//Move all selected rows to dw_2
long llRowPos = 1
Int liRowPos
String lsMsg

//GailM 2/4/2019 S28940 Operators cannot manually move serial numbers unless in function rights table
If gs_role = '-1' or gs_role = '0' or gs_role = '1' or g.getfunctionrights('W_SPLIT1',"C") = true THEN 
	Do While llRowPos > 0
		llRowPos = dw_1.GetSelectedRow( 0 )
		If llRowPos > 0 Then
			dw_1.RowsMove(llRowPos, llRowPos, Primary!,  dw_2, dw_2.rowcount() + 1, Primary!)
		End If
	Loop
	
	dw_2.SetSort("po_no2, carton_id, serial_no")
	dw_2.Sort()
	
	st_msg2.text = "Target: " + String(ilDetailReqQty) + "  Assigned: " + String(dw_2.rowcount())
	iiClickedRow1 = 0
	dw_2.ExpandAll()
Else
	lsMsg = "Manual Move Not Allowed.  Please Scan Serial Nbrs.~n~r~n~r " +&
			   "     Note:  Utilities/Container Split/Confirm."
	messagebox("Manual Move Restricted", lsMsg)
End If

end event

type cb_2 from commandbutton within w_pick_pallet
string tag = "Move all serial numbers for this container"
integer x = 889
integer y = 96
integer width = 201
integer height = 144
integer taborder = 30
boolean bringtotop = true
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">>"
end type

event clicked;String lsMsg

sle_1.text = dw_1.GetItemString( iiClickedRow1, "carton_id" )

//GailM 2/4/2019 S28940 Operators cannot manually move serial numbers unless in function rights table
If gs_role = '-1' or gs_role = '0' or gs_role = '1' or g.getfunctionrights('W_SPLIT1',"C") = true THEN 

	If iiClickedRow1 > 0 and iiClickedRow1 <= dw_1.RowCount() Then
		
		
	//	long ll_cnt, ll_max, ll_group
	//	string ls_first, ls_last
	//	ll_max = dw_1.rowcount()
	//	for ll_cnt = 1 to ll_max
	//		ls_first = dw_1.Describe("evaluate('first( getrow() for group 1 )',"+string(ll_cnt)+")")
	//		ls_last = dw_1.Describe("evaluate('last( getrow() for group	1 )',"+string(ll_cnt)+")")
	//					  //clear out old values
	//		dw_1.setitem(ll_cnt, 'po_no2', "higlevel")	
	//		if ll_cnt = long(ls_first) then
	//			ll_group = ll_group + 1
	//			dw_1.setitem(ll_cnt, 'carton_id', 'h:'+string( ll_group))
	//		end if
	//		if ll_cnt = long(ls_last) then
	//			dw_1.setitem(ll_cnt, 'serial_no', 't:'+string( ll_group))
	//		end if
	//	next
	
		
		sle_1.triggerevent("modified")
		st_msg2.text = "Target: " + String(ilDetailReqQty) + "  Assigned: " + String(dw_2.rowcount())
	
	End If
Else
	lsMsg = "Manual Move Not Allowed.  Please Scan Serial Nbrs.~n~r~n~r " +&
			   "     Note:  Utilities/Container Split/Confirm."
	messagebox("Manual Move Restricted", lsMsg)
End If

dw_2.ExpandAll()




end event

type cb_3 from commandbutton within w_pick_pallet
string tag = "Move selected serial numbers to the left"
integer x = 889
integer y = 464
integer width = 201
integer height = 144
integer taborder = 30
boolean bringtotop = true
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
end type

event clicked;//Move all selected rows to dw_1
long llRowPos = 1
Int liRowPos, liRet, liDeletedRow

llRowPos = dw_2.GetSelectedRow( 0 )

If isColorCode = "9" Then
	If llRowPos > 0 Then
		dw_2.RowsMove(llRowPos, llRowPos, Primary!, dw_2, dw_1.rowcount() + 1, Delete!)
		liDeletedRow = dw_2.DeletedCount()
		dw_2.RowsCopy(liDeletedRow, liDeletedRow, Delete!, dw_1, dw_1.rowcount() + 1, Primary!)
		dw_1.SetItem(dw_1.rowcount(), "serial_no", "")
		ibSerialChanged = TRUE
	End If
Else
	Do While llRowPos > 0
		If llRowPos > 0 Then
			dw_2.RowsMove(llRowPos, llRowPos, Primary!,  dw_1, dw_1.rowcount() + 1, Primary!)
			llRowPos = dw_2.GetSelectedRow( 0 )
		End If
	Loop
	
	dw_1.SetSort("po_no2, carton_id, serial_no")
	dw_1.Sort()
End If

st_msg2.text = "Target: " + String(ilDetailReqQty) + "  Assigned: " + String(dw_2.rowcount())
iiClickedRow1 = 0

dw_1.ExpandAll()
dw_2.ExpandAll()
end event

type cb_4 from commandbutton within w_pick_pallet
string tag = "Remove container from selected"
integer x = 889
integer y = 675
integer width = 201
integer height = 144
integer taborder = 40
boolean bringtotop = true
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<<"
end type

event clicked;/* Move container from Selected to UnSelected datawindow */
Long llRow, llRowCount
Integer liRtn

If iiClickedRow2 > 0 and iiClickedRow2 <= dw_2.RowCount() Then
	isScanned = dw_2.GetItemString( iiClickedRow2, "carton_id" )
	llRowCount = dw_2.RowCount()
	
	For llRow = llRowCount to 1 Step -1
		If dw_2.GetItemString(llRow, "carton_id" ) = isScanned Then
			liRtn = dw_2.RowsMove( llRow, llRow, Primary!, dw_2, llRowCount+1, Delete! )
		End If
	Next
	dw_2.RowsMove(1, dw_2.DeletedCount(), Delete!,  dw_1, 1, Primary!)
	dw_1.SetSort("po_no2, carton_id, serial_no")
	dw_1.Sort()
	st_msg2.text = "Target: " + String(ilDetailReqQty) + "  Assigned: " + String(dw_2.rowcount())


End If
end event

type st_msg from statictext within w_pick_pallet
integer y = 1056
integer width = 1295
integer height = 83
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_5 from commandbutton within w_pick_pallet
integer x = 1342
integer y = 1152
integer width = 271
integer height = 109
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;string lsContainer, lsContainerPrev, lsMixedType
int liNbrPicked, i

lsContainerPrev = ""
liNbrPicked = dw_2.rowcount()

ids1.reset( )
ids2.reset( )

dw_1.RowsCopy(1, dw_1.RowCount(), Primary!, ids1, 1, Primary!)
dw_2.RowsCopy(1, dw_2.RowCount(), Primary!, ids2, 1, Primary!)

ipStrParms.datastore_arg[1] = ids1
ipStrParms.datastore_arg[2] = ids2

If isColorCode = "9" Or isColorCode = "" Or isColorCode = "0" Then		//Allow isColorCode empty to change just Pallet or Container
	parent.TriggerEvent("ue_add_serial_numbers")
Else
	parent.TriggerEvent("ue_container_adjust")
End If


end event

type st_msg2 from statictext within w_pick_pallet
integer x = 1287
integer y = 1056
integer width = 691
integer height = 83
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type lb_carton_list from listbox within w_pick_pallet
boolean visible = false
integer x = 1185
integer y = 1146
integer width = 121
integer height = 115
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
boolean border = false
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type sle_palletid from singlelineedit within w_pick_pallet
string tag = "Scan Pallet ID or Generate"
integer x = 22
integer y = 982
integer width = 644
integer height = 74
integer taborder = 50
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event getfocus;isTag = This.tag
sle_2.text = isTag


end event

event losefocus;isTag = ""
sle_2.text = isTag

end event

event modified;//GailM 9/5/2019 S37314 F17337 I1304 Google Footprints GPN Conversion Process
Long llDw1Rows, llDw2Rows, llDw1Row, llDw2Row
Int liRtn, liRow
String lsPalletId

//If (isColorCode = "0" or isColorCode = "") and (isPoNo2 <> '-' and NOT ibChecked1) Then
//	MessageBox("Change PalletId","Cannot change pallet Id through this process.  Restricted to Dash.")
//Else
	ibChecked1 = FALSE
	If ibGenPalletId Then
		lsPalletId = isPoNo2
	Else
		lsPalletId = This.Text
	End If
	
	llDw1Rows = parent.dw_1.rowcount()
	llDw2Rows = parent.dw_2.rowcount()
	
	If llDw1Rows > 0 Then
		For llDw1Row = 1 to llDw1Rows
			parent.dw_1.setItem(llDw1Row,'po_no2',lsPalletId)
		Next
	End If
	If llDw2Rows > 0 Then
		For llDw2Row = 1 to llDw2Rows
			parent.dw_2.setItem(llDw2Row,'po_no2',lsPalletId)
			idsSerialValidate.SetItem(llDw2Row,'po_no2',lsPalletId)
			idsSerialValidate.SetItem(llDw2Row,'Serial_Flag', 'L')
			idsSerialValidate.SetItem(llDw2Row,'Do_No', isDoNo)
			idsSerialValidate.SetItem(llDw2Row,'Transaction_Type', 'Dynamic Outbound PalletId change')
			idsSerialValidate.SetItem(llDw2Row,'Transaction_Id', isDoNo)
			ibSerialChanged = TRUE
		Next
	End If
	
	idw_pick.SetItem(iiCurrPickRow, 'po_no2', lsPalletId)
	//GailM 1/13/2020 DE14136 At this point there will be only one pick detail row.  
	For liRow = 1 to idsPickDetail.rowcount()
		idsPickDetail.SetItem(liRow, 'po_no2', lsPalletId) 
	Next
	
	ibChanged = TRUE
	MessageBox("Change PalletID","PalletID has been changed to: " + lsPalletId)
	
	//w_pick_pallet.TriggerEvent("ue_add_serial_numbers")
//End If
end event

type sle_containerid from singlelineedit within w_pick_pallet
string tag = "Scan Container ID or Generate"
integer x = 1145
integer y = 982
integer width = 644
integer height = 74
integer taborder = 60
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event getfocus;sle_2.Text = This.Tag
end event

event losefocus;sle_2.Text = ""
end event

event modified;//GailM 9/5/2019 S37314 F17337 I1304 Google Footprints GPN Conversion Process
Long llDw1Rows, llDw2Rows, llDw1Row, llDw2Row
Int liRtn, liRow
String lsContainerId

//If (isColorCode = "0" or isColorCode = "") and (isContainerId <> '-' and NOT ibChecked2) Then
//	MessageBox("Change ContainerId","Cannot change Container Id through this process.  Restricted to changing from Dash.")
//Else
	ibChecked2 = FALSE
	If ibGenContainerId Then
		lsContainerId = isContainerId
	Else
		lsContainerId = This.Text
	End If
	
	llDw1Rows = parent.dw_1.rowcount()
	llDw2Rows = parent.dw_2.rowcount()
	
	If llDw1Rows > 0 Then
		For llDw1Row = 1 to llDw1Rows
			parent.dw_1.setItem(llDw1Row,'carton_id',lsContainerId)
		Next
	End If
	If llDw2Rows > 0 Then
		For llDw2Row = 1 to llDw2Rows
			parent.dw_2.setItem(llDw2Row,'carton_id',lsContainerId)
			idsSerialValidate.SetItem(llDw2Row,'carton_id',lsContainerId)
			idsSerialValidate.SetItem(llDw2Row,'Serial_Flag', 'L')
			idsSerialValidate.SetItem(llDw2Row,'Do_No', isDoNo)
			idsSerialValidate.SetItem(llDw2Row,'Transaction_Type', 'Dynamic Outbound Carton change')
			idsSerialValidate.SetItem(llDw2Row,'Transaction_Id', isDoNo)
			ibSerialChanged = TRUE
		Next
	End If
	
	idw_pick.SetItem(iiCurrPickRow, 'container_id', lsContainerId)
	//GailM 1/13/2020 DE14136 At this point there will be only one pick detail row.  
	For liRow = 1 to idsPickDetail.rowcount()
		idsPickDetail.SetItem(liRow, 'container_id', lsContainerId) 
	Next
	
	ibChanged = TRUE
	MessageBox("Change ContainerID","ContainerID has been changed to: " + lsContainerId)
	
	//w_pick_pallet.TriggerEvent("ue_add_serial_numbers")
//End If
end event

type cb_genpallet from commandbutton within w_pick_pallet
integer x = 673
integer y = 982
integer width = 172
integer height = 74
integer taborder = 60
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "GEN"
end type

event clicked;//Generaate a new pallet id	

	sqlca.sp_check_digit_build(gs_project,"SSCC_No", "" , 0 , isPoNo2 ) 
	ibGenPalletId = TRUE
	ibChecked1 = TRUE
	sle_palletid.TriggerEvent("modified")


end event

type cb_gencon from commandbutton within w_pick_pallet
integer x = 1803
integer y = 982
integer width = 172
integer height = 74
integer taborder = 60
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "GEN"
end type

event clicked;//Generate a new container id	

	sqlca.sp_check_digit_build(gs_project,"SSCC_No", "" , 0 , isContainerId ) 
	ibGenContainerId = TRUE
	ibChecked2 = TRUE
	sle_containerid.TriggerEvent("modified")

end event

type dw_3 from u_dw within w_pick_pallet
string tag = "This is the tag for dw3"
boolean visible = false
integer x = 40
integer y = 1491
integer height = 362
integer taborder = 20
boolean bringtotop = true
end type

type sle_2 from u_dw_microhelp within w_pick_pallet
integer x = 44
integer y = 1283
integer width = 1938
integer height = 102
integer taborder = 30
boolean bringtotop = true
long backcolor = 553648127
string text = ""
end type

type st_2 from statictext within w_pick_pallet
integer x = 22
integer y = 918
integer width = 947
integer height = 67
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Scan Pallet ID or Generate "
boolean focusrectangle = false
end type

type st_3 from statictext within w_pick_pallet
integer x = 1145
integer y = 918
integer width = 827
integer height = 67
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Scan Container ID or Generate"
boolean focusrectangle = false
end type

