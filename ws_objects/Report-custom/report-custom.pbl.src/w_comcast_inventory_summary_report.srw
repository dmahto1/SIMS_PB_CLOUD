$PBExportHeader$w_comcast_inventory_summary_report.srw
forward
global type w_comcast_inventory_summary_report from w_std_report
end type
end forward

global type w_comcast_inventory_summary_report from w_std_report
integer width = 3438
integer height = 1972
string title = "Comcast Inventory Summary Report"
end type
global w_comcast_inventory_summary_report w_comcast_inventory_summary_report

type variables
Datastore ids_onhand_invt, ids_intransit_invt, ids_alloc_invt, ids_outbound_invt
Datastore ids_intransit_oem, ids_alloc_oem, ids_outbound_oem


end variables

on w_comcast_inventory_summary_report.create
call super::create
end on

on w_comcast_inventory_summary_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;Long ll_row, ll_rowcount, ll_onhandRow, ll_Onhand_Rowcount, ll_IntransitRow, ll_Intransit_Rowcount, ll_AllocRow, ll_Alloc_Rowcount, ll_OutboundRow, ll_Outbound_Rowcount
String ls_oldsql
String ls_sku, ls_user_field10, lsfind, lsSuppCode
long ll_find, ll_NewRow, llrowpos
Long ll_atl, ll_aur, ll_fre, ll_mon, ll_oem
Long ll_onhand_atl, ll_intransit_atl, ll_alloc_atl, ll_outbound_atl, ll_total_atl
Long ll_onhand_aur, ll_intransit_aur, ll_alloc_aur, ll_outbound_aur, ll_total_aur
Long ll_onhand_fre, ll_intransit_fre, ll_alloc_fre, ll_outbound_fre, ll_total_fre
Long ll_onhand_mon, ll_intransit_mon, ll_alloc_mon, ll_outbound_mon, ll_total_mon
Long ll_alloc_oem, ll_outbound_oem, ll_total_oem
Long ll_atl_onhand, ll_aur_onhand, ll_fre_onhand, ll_mon_onhand
Long ll_atl_intrans, ll_aur_intrans, ll_fre_intrans, ll_mon_intrans
Long ll_atl_alloc, ll_aur_alloc, ll_fre_alloc, ll_mon_alloc
Long ll_atl_unpln, ll_aur_unpln, ll_fre_unpln, ll_mon_unpln, ll_oem_unpln
long ll_outboundoemrow, ll_outboundoem_Rowcount, ll_find_outboundoem, ll_find_oem
string lsfind_oem


SetPointer(HourGlass!)
dw_report.Reset()
dw_report.SetRedraw(False)

// 09/10 - PCONKL - Added Supplier to all DW's to show on report

////////////////////////////////////////////////On-hand Inventory.////////////////////////////////////////////////////////	
ll_Onhand_Rowcount = ids_onhand_invt.Rowcount()	
If ll_Onhand_Rowcount > 0 Then
	// Loop through the onhand inventory rows.
	For ll_onhandRow = 1 to ll_Onhand_Rowcount
		
		//Find SKU, Supplier and User_field10 already exists on the report		
			
		ls_sku = ids_onhand_invt.GetItemString(ll_onhandRow,'content_summary_sku')
		ls_User_field10= ids_onhand_invt.GetItemString(ll_onhandRow,'item_master_user_field10')					
		lsSuppCode = ids_onhand_invt.GetItemString(ll_onhandRow,'supp_code')
		lsFind = "upper(SKU) = '" + upper(ls_sku) + "' and Upper(user_field10) = '" + Upper(ls_user_field10) + "' and Upper(Supp_Code) = '" + upper(lsSuppCode) + "'"
		
		IF Not IsNull( lsFind) THEN
			ll_Find = dw_report.Find(lsFind, 1, dw_report.Rowcount())	
		ELSE
			lsFind = "upper(SKU) = '" + upper(ls_sku) +   "' and Upper(Supp_Code) = '" + upper(lsSuppCode) + "'"
			ll_Find = dw_report.Find(lsFind, 1, dw_report.Rowcount())	
		END IF
		
			If ll_Find > 0 Then								
								//Get qty from existing row for SKU/user_field10 on the report							
								ll_atl =  dw_report.GetItemDecimal(ll_Find, 'avail_qty_atlanta')
								ll_aur = dw_report.GetItemDecimal(ll_Find, 'avail_qty_aurora')
								ll_fre =  dw_report.GetItemDecimal(ll_Find, 'avail_qty_fremont')
								ll_mon = dw_report.GetItemDecimal(ll_Find, 'avail_qty_monroe')	
								
								//Get qty from existing row for SKU/user_field10 on alloc datastore
								ll_atl_onhand =  ids_onhand_invt.GetItemDecimal(ll_onhandRow,'atlanta')
								ll_aur_onhand = ids_onhand_invt.GetItemDecimal(ll_onhandRow,'aurora')
								ll_fre_onhand =  ids_onhand_invt.GetItemDecimal(ll_onhandRow,'fremont')
								ll_mon_onhand= ids_onhand_invt.GetItemDecimal(ll_onhandRow,'monroe')
								
								//if find the qty on existing SKU/user_field10 on the report for Atlanta
								IF IsNull(ll_atl) Then	
									//check if there is a qty
								    IF Not isnull(ll_atl_onhand) Then
									dw_Report.SetItem(ll_Find,"avail_qty_atlanta", ll_atl_onhand)
									END IF
								END IF
								
								//if find the qty on existing SKU/user_field10 on the report for Aurora
								IF IsNull(ll_aur) Then
									//check if there is a qty
								    IF Not isnull(ll_aur_onhand) Then
									dw_Report.SetItem(ll_Find,"avail_qty_aurora", ll_aur_onhand)
									END IF
								END IF
								
								//if find the qty on existing SKU/user_field10 on the report for Fremont
								IF IsNull(ll_fre) Then	
									//check if there is a qty
								    IF Not isnull(ll_fre_onhand) Then
									dw_Report.SetItem(ll_Find,"avail_qty_fremont", ll_fre_onhand)
									END IF
								END IF
								
								//if find the qty on existing SKU/user_field10 on the report for Monroe
								IF IsNull(ll_mon) Then
									//check if there is a qty
								    IF Not isnull(ll_mon_onhand) Then
									dw_Report.SetItem(ll_Find,"avail_qty_monroe", ll_mon_onhand)
									END IF
								END IF	
				Else
					//Insert a new row
					ll_NewRow = dw_report.InsertRow(0)
					// Set the Onhand Inventory fields.
					dw_Report.SetITem(ll_NewRow,'sku',ids_onhand_invt.GetItemString(ll_onhandRow,'content_summary_sku'))
					dw_Report.SetITem(ll_NewRow,'supp_code',ids_onhand_invt.GetItemString(ll_onhandRow,'supp_code'))
					dw_Report.SetItem(ll_NewRow,"user_field10",ids_onhand_invt.GetItemString(ll_onhandRow,'item_master_user_field10'))	
					dw_Report.SetItem(ll_NewRow,"grp",ids_onhand_invt.GetItemString(ll_onhandRow,'item_master_grp'))	
					dw_Report.SetItem(ll_NewRow,"avail_qty_atlanta",ids_onhand_invt.GetItemDecimal(ll_onhandRow,'atlanta'))
					dw_Report.SetItem(ll_NewRow,"avail_qty_aurora",ids_onhand_invt.GetItemDecimal(ll_onhandRow,'aurora'))
					dw_Report.SetItem(ll_NewRow,"avail_qty_fremont",ids_onhand_invt.GetItemDecimal(ll_onhandRow,'fremont'))
					dw_Report.SetItem(ll_NewRow,"avail_qty_monroe",ids_onhand_invt.GetItemDecimal(ll_onhandRow,'monroe'))						
				End If
		Next			
End If

//////////////////////In-Transit Inventory////////////////////////////////////////////////////
ll_Intransit_Rowcount = ids_intransit_invt.Rowcount()
If ll_Intransit_Rowcount > 0 Then
			// Loop through the In-transit Inventory rows.
			For ll_IntransitRow = 1 to ll_Intransit_Rowcount
				//Find SKU and User_field10 already exists on the report						
				ls_sku = ids_intransit_invt.GetItemString(ll_IntransitRow,'receive_detail_sku')
				lsSuppCode = ids_intransit_invt.GetItemString(ll_IntransitRow,'Supp_Code')
				ls_User_field10= ids_intransit_invt.GetItemString(ll_IntransitRow,'item_master_user_field10')	
				
				lsFind = "upper(SKU) = '" + upper(ls_sku) + "' and Upper(user_field10) = '" + Upper(ls_user_field10) + "' and upper(supp_code) = '" + Upper(lsSuppCode) + "'"
				
				IF Not IsNull( lsFind) THEN
					ll_Find = dw_report.Find(lsFind, 1, dw_report.Rowcount())	
				ELSE
					lsFind = "upper(SKU) = '" + upper(ls_sku) +  "' and upper(supp_code) = '" + Upper(lsSuppCode) + "'"
					ll_Find = dw_report.Find(lsFind, 1, dw_report.Rowcount())	
				END IF
								
				//if sku and user_field10 is found from report then loop throught the datastore and set the field appropirately
					If ll_Find > 0 Then								
								//Get qty from existing row for SKU/user_field10 on the report							
								ll_atl =  dw_report.GetItemDecimal(ll_Find, 'recv_req_qty_atlanta')
								ll_aur = dw_report.GetItemDecimal(ll_Find, 'recv_req_qty_aurora')
								ll_fre =  dw_report.GetItemDecimal(ll_Find, 'recv_req_qty_fremont')
								ll_mon = dw_report.GetItemDecimal(ll_Find, 'recv_req_qty_monroe')	
								
								//Get qty from existing row for SKU/user_field10 on alloc datastore
								ll_atl_intrans =  ids_intransit_invt.GetItemDecimal(ll_IntransitRow,'atlanta')
								ll_aur_intrans =ids_intransit_invt.GetItemDecimal(ll_IntransitRow,'aurora')
								ll_fre_intrans =  ids_intransit_invt.GetItemDecimal(ll_IntransitRow,'fremont')
								ll_mon_intrans = ids_intransit_invt.GetItemDecimal(ll_IntransitRow,'monroe')
								
								//if find the qty on existing SKU/user_field10 on the report for Atlanta
								IF IsNull(ll_atl) Then	
									//check if there is a qty
								    IF Not isnull(ll_atl_intrans) Then
									dw_Report.SetItem(ll_Find,"recv_req_qty_atlanta", ll_atl_intrans)
									END IF
								END IF
								
								//if find the qty on existing SKU/user_field10 on the report for Aurora
								IF IsNull(ll_aur) Then
									//check if there is a qty
								    IF Not isnull(ll_aur_intrans) Then
									dw_Report.SetItem(ll_Find,"recv_req_qty_aurora", ll_aur_intrans)
									END IF
								END IF
								
								//if find the qty on existing SKU/user_field10 on the report for Fremont
								IF IsNull(ll_fre) Then	
									//check if there is a qty
								    IF Not isnull(ll_fre_alloc) Then
									dw_Report.SetItem(ll_Find,"recv_req_qty_fremont", ll_fre_intrans)
									END IF
								END IF
								
								//if find the qty on existing SKU/user_field10 on the report for Monroe
								IF IsNull(ll_mon) Then
									//check if there is a qty
								    IF Not isnull(ll_mon_alloc) Then
									dw_Report.SetItem(ll_Find,"recv_req_qty_monroe", ll_mon_intrans)
									END IF
								END IF		
				Else
						// Insert a new row	
						ll_NewRow = dw_report.InsertRow(0)
						// Set the In-transit Inventory fields.
						dw_Report.SetITem(ll_NewRow,'sku',ids_intransit_invt.GetItemString(ll_IntransitRow,'receive_detail_sku'))
						dw_Report.SetITem(ll_NewRow,'supp_code',ids_intransit_invt.GetItemString(ll_IntransitRow,'supp_code'))
						dw_Report.SetItem(ll_NewRow,"user_field10",ids_intransit_invt.GetItemString(ll_IntransitRow,'item_master_user_field10'))
						dw_Report.SetItem(ll_NewRow,"grp",ids_intransit_invt.GetItemString(ll_IntransitRow,'item_master_grp'))
						dw_Report.SetItem(ll_NewRow,"recv_req_qty_atlanta",ids_intransit_invt.GetItemDecimal(ll_IntransitRow,'atlanta'))						
						dw_Report.SetItem(ll_NewRow,"recv_req_qty_aurora",ids_intransit_invt.GetItemDecimal(ll_IntransitRow,'aurora'))
						dw_Report.SetItem(ll_NewRow,"recv_req_qty_fremont",ids_intransit_invt.GetItemDecimal(ll_IntransitRow,'fremont'))
						dw_Report.SetItem(ll_NewRow,"recv_req_qty_monroe",ids_intransit_invt.GetItemDecimal(ll_IntransitRow,'monroe'))	
				END IF			
			NEXT		
END IF

///////////////////////////////Allocated Inventory////////////////////////////////////
ll_alloc_Rowcount = ids_alloc_invt.Rowcount()
If ll_alloc_Rowcount > 0 Then
			// Loop through the Allocated Unplanned Inventory rows.
			For ll_allocRow = 1 to ll_alloc_Rowcount	
				//Find if SKU and User_field10 already exists on the report						
				ls_sku = ids_alloc_invt.GetItemString(ll_allocRow,'delivery_detail_sku')
				lsSuppCode = ids_alloc_invt.GetItemString(ll_allocRow,'supp_code')
				ls_User_field10= ids_alloc_invt.GetItemString(ll_allocRow,'item_master_user_field10')	
				
					lsFind = "upper(SKU) = '" + upper(ls_sku) + "' and Upper(user_field10) = '" + Upper(ls_user_field10) + "' and upper(supp_code) = '" + Upper(lsSuppCode) + "'"
					IF Not IsNull( lsFind) THEN
						ll_Find = dw_report.Find(lsFind, 1, dw_report.Rowcount())	
					ELSE
						lsFind = "upper(SKU) = '" + upper(ls_sku) + "' and upper(supp_code) = '" + Upper(lsSuppCode) + "'"
						ll_Find = dw_report.Find(lsFind, 1, dw_report.Rowcount())	
					END IF
														
					//if sku and user_field10 is found from report then loop throught the datastore and set the field appropirately
					If ll_Find > 0 Then		
						
								//Get qty from existing row for SKU/user_field10 on the report
								ll_atl =  dw_report.GetItemDecimal(ll_Find, 'alloc_qty_atlanta')		
								ll_aur = dw_report.GetItemDecimal(ll_Find, 'alloc_qty_aurora')	
								ll_fre =  dw_report.GetItemDecimal(ll_Find, 'recv_req_qty_fremont')
								ll_mon = dw_report.GetItemDecimal(ll_Find, 'recv_req_qty_monroe')		
								
								//Get qty from existing row for SKU/user_field10 on alloc datastore
								ll_atl_alloc =  ids_alloc_invt.GetItemDecimal(ll_allocRow,'atlanta')
								ll_aur_alloc =ids_alloc_invt.GetItemDecimal(ll_allocRow,'aurora')
								ll_fre_alloc =  ids_alloc_invt.GetItemDecimal(ll_allocRow,'fremont')
								ll_mon_alloc = ids_alloc_invt.GetItemDecimal(ll_allocRow,'monroe')
								
								//if find the qty on existing SKU/user_field10 on the report for Atlanta
								IF IsNull(ll_atl) Then	
									//check if there is a qty
								    IF Not isnull(ll_atl_alloc) Then
									dw_Report.SetItem(ll_Find,"alloc_qty_atlanta", ll_atl_alloc)
									END IF
								END IF
								
								//if find the qty on existing SKU/user_field10 on the report for Aurora
								IF IsNull(ll_aur) Then
									//check if there is a qty
								    IF Not isnull(ll_aur_alloc) Then
									dw_Report.SetItem(ll_Find,"alloc_qty_aurora", ll_aur_alloc)
									END IF
								END IF
								
								//if find the qty on existing SKU/user_field10 on the report for Fremont
								IF IsNull(ll_fre) Then	
									//check if there is a qty
								    IF Not isnull(ll_fre_alloc) Then
									dw_Report.SetItem(ll_Find,"alloc_qty_fremont", ll_fre_alloc)
									END IF
								END IF
								
								//if find the qty on existing SKU/user_field10 on the report for Monroe
								IF IsNull(ll_mon) Then
									//check if there is a qty
								    IF Not isnull(ll_mon_alloc) Then
									dw_Report.SetItem(ll_Find,"alloc_qty_monroe", ll_mon_alloc)
									END IF
								END IF		
								
								//Set Allocated qty for In-OEM to existing row for SKU/user_field10	
								IF ids_alloc_oem.rowcount() > 0 Then
									ll_oem = dw_report.GetItemDecimal(ll_Find, 'alloc_qty_in_oem')							
									IF isNull(ll_oem) Then
										IF IsNull(ids_alloc_oem.GetItemDecimal(ll_allocRow,'in_oem'))	Then
											ll_oem = 0
											dw_Report.SetItem(ll_Find, "alloc_qty_in_oem", ll_oem)	
										ELSE
											dw_Report.SetItem(ll_Find, "alloc_qty_in_oem", ids_alloc_oem.GetItemDecimal(ll_allocRow,'in_oem'))
										END IF
									END IF						
								END IF
					Else
						// Insert a new row										
						ll_NewRow = dw_report.InsertRow(0)
						// Set the Allocated Unplanned Inventory fields.
						dw_Report.SetITem(ll_NewRow,'sku',ids_alloc_invt.GetItemString(ll_allocRow,'delivery_detail_sku'))
						dw_Report.SetITem(ll_NewRow,'supp_Code',ids_alloc_invt.GetItemString(ll_allocRow,'supp_code'))
						dw_Report.SetItem(ll_NewRow,"user_field10",ids_alloc_invt.GetItemString(ll_allocRow,'item_master_user_field10'))		
						dw_Report.SetItem(ll_NewRow,"grp",ids_alloc_invt.GetItemString(ll_allocRow,'item_master_grp'))		
						dw_Report.SetItem(ll_NewRow,"alloc_qty_atlanta",ids_alloc_invt.GetItemDecimal(ll_allocRow,'atlanta'))
						dw_Report.SetItem(ll_NewRow,"alloc_qty_aurora",ids_alloc_invt.GetItemDecimal(ll_allocRow,'aurora'))
						dw_Report.SetItem(ll_NewRow,"alloc_qty_fremont",ids_alloc_invt.GetItemDecimal(ll_allocRow,'fremont'))
						dw_Report.SetItem(ll_NewRow,"alloc_qty_monroe",ids_alloc_invt.GetItemDecimal(ll_allocRow,'monroe'))
//						//Set Allocated qty for In-OEM
//						IF ids_alloc_oem.rowcount() > 0 Then
//							dw_Report.SetItem(ll_NewRow,"alloc_qty_in_oem",ids_alloc_oem.GetItemDecimal(ll_allocRow,'in_oem'))
//						END IF
					END IF					
			NEXT	
	END IF
	
////////////////////////Unplanned Outbound Inventory///////////////////////////////////
ll_outbound_Rowcount = ids_outbound_invt.Rowcount()
If ll_outbound_Rowcount > 0 Then
			// Loop through the Unplanned Outbound Inventory rows.
			For ll_outboundRow = 1 to ll_outbound_Rowcount			
			//Find SKU and User_field10 already exists on the report						
				ls_sku = ids_outbound_invt.GetItemString(ll_outboundRow,'delivery_detail_sku')
				lsSuppCode = ids_outbound_invt.GetItemString(ll_outboundRow,'Supp_code')
				ls_User_field10= ids_outbound_invt.GetItemString(ll_outboundRow,'item_master_user_field10')				
				
			    lsFind = "upper(SKU) = '" + upper(ls_sku) + "' and Upper(user_field10) = '" + Upper(ls_user_field10) + "' and upper(supp_code) = '" + Upper(lsSuppCode) + "'"
				
				IF Not IsNull( lsFind) THEN
					ll_Find = dw_report.Find(lsFind, 1, dw_report.Rowcount())	
				ELSE
					lsFind = "upper(SKU) = '" + upper(ls_sku) +  "' and upper(supp_code) = '" + Upper(lsSuppCode) + "'"
					ll_Find = dw_report.Find(lsFind, 1, dw_report.Rowcount())	
				END IF
				
				If ll_find > 0 Then
									//Get qty from existing row for SKU/user_field10 on the report
									ll_atl =  dw_report.GetItemDecimal(ll_Find, 'delvr_req_qty_atlanta')
									ll_aur = dw_report.GetItemDecimal(ll_Find, 'delvr_req_qty_aurora')
									ll_fre =  dw_report.GetItemDecimal(ll_Find, 'delvr_req_qty_fremont')
									ll_mon = dw_report.GetItemDecimal(ll_Find, 'delvr_req_qty_monroe')
									
									//Get qty from existing row for SKU/user_field10 on alloc datastore
									ll_atl_unpln =  ids_outbound_invt.GetItemDecimal(ll_outboundRow, 'atlanta')
									ll_aur_unpln = ids_outbound_invt.GetItemDecimal(ll_outboundRow, 'aurora')
									ll_fre_unpln =  ids_outbound_invt.GetItemDecimal(ll_outboundRow, 'fremont')
									ll_mon_unpln = ids_outbound_invt.GetItemDecimal(ll_outboundRow, 'monroe')
								
									//if find the qty on existing SKU/user_field10 on the report for Atlanta
									IF IsNull(ll_atl) Then	
										//check if there is a qty
										 IF Not isnull(ll_atl_unpln) Then
										dw_Report.SetItem(ll_Find,"delvr_req_qty_atlanta", ll_atl_unpln)
										END IF
									END IF
									
									//if find the qty on existing SKU/user_field10 on the report for Aurora
									IF IsNull(ll_aur) Then
										//check if there is a qty
										 IF Not isnull(ll_aur_unpln) Then
										dw_Report.SetItem(ll_Find,"delvr_req_qty_aurora", ll_aur_unpln)
										END IF
									END IF
									
									//if find the qty on existing SKU/user_field10 on the report for Fremont
									IF IsNull(ll_fre) Then	
										//check if there is a qty
										 IF Not isnull(ll_fre_unpln) Then
										dw_Report.SetItem(ll_Find,"delvr_req_qty_fremont", ll_fre_unpln)
										END IF
									END IF
									
									//if find the qty on existing SKU/user_field10 on the report for Monroe
									IF IsNull(ll_mon) Then
										//check if there is a qty
										 IF Not isnull(ll_mon_unpln) Then
										dw_Report.SetItem(ll_Find,"delvr_req_qty_monroe", ll_mon_unpln)
										END IF
									END IF		
									
									//Set Outbound qty to existing row for SKU/user_field10 for In-OEM 
										IF ids_outbound_oem.rowcount() > 0 Then
											ll_oem = dw_report.GetItemDecimal(ll_Find, 'delvr_req_qty_in_oem')
											ll_outbound_oem = ids_outbound_oem.GetItemDecimal(ll_outboundRow,'in_oem')
											IF isNull(ll_oem) Then
												IF Not IsNull (ll_oem_unpln) Then												
													dw_Report.SetItem(ll_Find, "delvr_req_qty_in_oem", ll_outbound_oem)
												END IF
											END IF
										END IF
				Else
					// Insert a new row										
					ll_NewRow = dw_report.InsertRow(0)				
					// Set the Unplanned Outbound Inventory fields.
					dw_Report.SetITem(ll_NewRow,'sku',ids_outbound_invt.GetItemString(ll_outboundRow,'delivery_detail_sku'))
					dw_Report.SetITem(ll_NewRow,'supp_code',ids_outbound_invt.GetItemString(ll_outboundRow,'supp_code'))
					dw_Report.SetItem(ll_NewRow,"user_field10",ids_outbound_invt.GetItemString(ll_outboundRow,'item_master_user_field10'))
					dw_Report.SetItem(ll_NewRow,"grp",ids_outbound_invt.GetItemString(ll_outboundRow,'item_master_grp'))
					dw_Report.SetItem(ll_NewRow,"delvr_req_qty_atlanta",ids_outbound_invt.GetItemDecimal(ll_outboundRow,'atlanta'))
					dw_Report.SetItem(ll_NewRow,"delvr_req_qty_aurora",ids_outbound_invt.GetItemDecimal(ll_outboundRow,'aurora'))
					dw_Report.SetItem(ll_NewRow,"delvr_req_qty_fremont",ids_outbound_invt.GetItemDecimal(ll_outboundRow,'fremont'))
					dw_Report.SetItem(ll_NewRow,"delvr_req_qty_monroe",ids_outbound_invt.GetItemDecimal(ll_outboundRow,'monroe'))	
//					//Set Allocated qty for In-OEM
//						IF ids_outbound_oem.rowcount() > 0 Then
//							dw_Report.SetItem(ll_NewRow,"delvr_req_qty_in_oem",ids_outbound_oem.GetItemDecimal(ll_outboundRow,'in_oem'))
//						END IF
					END IF				
			NEXT	
	END IF
	
///////////////////IN_OEM new row///////////////////////////////
ll_outboundoem_Rowcount = ids_outbound_oem.Rowcount()
If ll_outboundoem_Rowcount > 0 Then	
	For ll_outboundoemRow = 1 to ll_outboundoem_Rowcount			
								//Find SKU and User_field10 already exists on the report						
								ls_sku = ids_outbound_oem.GetItemString(ll_outboundoemRow,'delivery_detail_sku')
								lsSuppCode = ids_outbound_oem.GetItemString(ll_outboundoemRow,'Supp_code')
								ls_User_field10= ids_outbound_oem.GetItemString(ll_outboundoemRow,'item_master_user_field10')				
								
								 lsFind_oem = "upper(SKU) = '" + upper(ls_sku) + "' and Upper(user_field10) = '" + Upper(ls_user_field10) + "' and upper(supp_code) = '" + Upper(lsSuppCode) + "'"
								
								IF Not IsNull(lsFind_oem) THEN
									ll_find_oem = dw_report.Find(lsFind_oem, 1, dw_report.Rowcount())	
								ELSE
									lsFind_oem = "upper(SKU) = '" + upper(ls_sku) +   "' and upper(supp_code) = '" + Upper(lsSuppCode) + "'"
									ll_find_oem = dw_report.Find(lsFind_oem, 1, dw_report.Rowcount())	
								END IF
								//If not found insert row to report.
								If ll_find_oem = 0 Then
										// Insert a new row										
										ll_NewRow = dw_report.InsertRow(0)				
										// Set the Unplanned Outbound Inventory fields.
										dw_Report.SetITem(ll_NewRow,'sku',ids_outbound_oem.GetItemString(ll_outboundoemRow,'delivery_detail_sku'))
										dw_Report.SetITem(ll_NewRow,'supp_code',ids_outbound_oem.GetItemString(ll_outboundoemRow,'supp_code'))
										dw_Report.SetItem(ll_NewRow,"user_field10",ids_outbound_oem.GetItemString(ll_outboundoemRow,'item_master_user_field10'))
										dw_Report.SetItem(ll_NewRow,"grp",ids_outbound_oem.GetItemString(ll_outboundoemRow,'item_master_grp'))
										dw_Report.SetItem(ll_NewRow,"delvr_req_qty_in_oem",ids_outbound_oem.GetItemDecimal(ll_outboundoemRow,'in_oem'))										
								END IF
	NEXT	
END IF

/////////////////Calculation qty////////////////////////////////////////////
For ll_row = 1 to dw_report.Rowcount()
	
	//Get Total qty for Atlanta
	 ll_onhand_atl   = dw_report.GetItemDecimal (ll_row, "avail_qty_atlanta")
	 ll_intransit_atl  = dw_report.GetItemDecimal (ll_row, "recv_req_qty_atlanta")
	 ll_alloc_atl      = dw_report.GetItemDecimal (ll_row, "alloc_qty_atlanta")
	 ll_outbound_atl = dw_report.GetItemDecimal (ll_row, "delvr_req_qty_atlanta")
	 
				 If isNull(ll_onhand_atl) Then ll_onhand_atl = 0
				 If isNull(ll_intransit_atl) Then ll_intransit_atl = 0
				 If isNull(ll_alloc_atl) Then ll_alloc_atl = 0
				 If isNull(ll_outbound_atl) Then ll_outbound_atl = 0
				 
				 ll_total_atl = (ll_onhand_atl +  ll_intransit_atl) - (ll_alloc_atl + ll_outbound_atl)
				 //Set Total for Aurora
				 dw_Report.SetItem(ll_row,"total_atlanta", ll_total_atl)	
	
	 //Get Total qty for Aurora
	 ll_onhand_aur   = dw_report.GetItemDecimal (ll_row, "avail_qty_aurora")
	 ll_intransit_aur  = dw_report.GetItemDecimal (ll_row, "recv_req_qty_aurora")
	 ll_alloc_aur       = dw_report.GetItemDecimal (ll_row, "alloc_qty_aurora")
	 ll_outbound_aur = dw_report.GetItemDecimal (ll_row, "delvr_req_qty_aurora")	
	 
				 If isNull(ll_onhand_aur) Then ll_onhand_aur = 0
				 If isNull(ll_intransit_aur) Then ll_intransit_aur = 0
				 If isNull(ll_alloc_aur) Then ll_alloc_aur = 0
				 If isNull(ll_outbound_aur) Then ll_outbound_aur = 0
				 
				 ll_total_aur =  (ll_onhand_aur + ll_intransit_aur) - (ll_alloc_aur + ll_outbound_aur)
				 //Set Total for Aurora
				 dw_Report.SetItem(ll_row,"total_aurora", ll_total_aur)	
	 
	 //Get Total qty for Fremont
	 ll_onhand_fre   = dw_report.GetItemDecimal (ll_row, "avail_qty_fremont")
	 ll_intransit_fre  = dw_report.GetItemDecimal (ll_row, "recv_req_qty_fremont")
	 ll_alloc_fre       = dw_report.GetItemDecimal (ll_row, "alloc_qty_fremont")
	 ll_outbound_fre = dw_report.GetItemDecimal (ll_row, "delvr_req_qty_fremont")
	 
					 If isNull(ll_onhand_fre) Then ll_onhand_fre = 0
					 If isNull(ll_intransit_fre) Then ll_intransit_fre = 0
					 If isNull(ll_alloc_fre) Then ll_alloc_fre = 0
					 If isNull(ll_outbound_fre) Then ll_outbound_fre = 0
					 
					 ll_total_fre =  (ll_onhand_fre + ll_intransit_fre) - (ll_alloc_fre + ll_outbound_fre)
					 
					 //Set Total for Fremont
					 dw_Report.SetItem(ll_row,"total_fremont", ll_total_fre)	
	 
	 //Get Total qty for Monroe
	 ll_onhand_mon   = dw_report.GetItemDecimal (ll_row, "avail_qty_monroe")
	 ll_intransit_mon  = dw_report.GetItemDecimal (ll_row, "recv_req_qty_monroe")
	 ll_alloc_mon       = dw_report.GetItemDecimal (ll_row, "alloc_qty_monroe")
	 ll_outbound_mon = dw_report.GetItemDecimal (ll_row, "delvr_req_qty_monroe")
	 
					 If isNull(ll_onhand_mon) Then ll_onhand_mon = 0
					 If isNull(ll_intransit_mon) Then ll_intransit_mon = 0
					 If isNull(ll_alloc_mon) Then ll_alloc_mon = 0
					 If isNull(ll_outbound_mon) Then ll_outbound_mon = 0
					 
					 ll_total_mon =  (ll_onhand_mon + ll_intransit_mon) - (ll_alloc_mon + ll_outbound_mon)
					 
					 //Set Total for Monroe
					 dw_Report.SetItem(ll_row,"total_monroe", ll_total_mon)	
		
	 //Get Total for IN-OEM
	 ll_alloc_oem 	      = dw_report.GetItemDecimal (ll_row, "alloc_qty_in_oem")
	 ll_outbound_oem   = dw_report.GetItemDecimal (ll_row, "delvr_req_qty_in_oem")	 
					 
					 IF isNull(ll_alloc_oem) then  ll_alloc_oem = 0
					 IF isNull(ll_outbound_oem) then  ll_outbound_oem = 0
						 
					 ll_total_oem =  (ll_alloc_oem + ll_outbound_oem)
					 
					//Set Total for IN-OEM
					dw_Report.SetItem(ll_row,"total_oem", ll_total_oem)	
NEXT


dw_report.SetRedraw(True)

im_menu.m_file.m_print.Enabled = True
end event

event resize;call super::resize;dw_report.Resize(workspacewidth() -30,workspaceHeight()-200)
end event

event ue_postopen;call super::ue_postopen;//Jxlim 05/19/2010 SIMS Comcast Inventory summary Report
//On-hand Inventory
	If not isvalid(ids_onhand_invt) then
		ids_onhand_invt = Create Datastore
		ids_onhand_invt.DataObject = 'd_comcast_onhand_invt_rpt'
		ids_onhand_invt.SetTransObject(SQLCA)
		ids_onhand_invt.Retrieve()
	End If
	
	//In-transit Inventory
	If not isvalid(ids_intransit_invt) then
		ids_intransit_invt = Create Datastore
		ids_intransit_invt.DataObject = 'd_comcast_inbound_intransit_invt_rpt'
		ids_intransit_invt.SetTransObject(SQLCA)
		ids_intransit_invt.Retrieve()
	END IF
	
	//Allocated Unplanned Inventory
	If not isvalid(ids_alloc_invt) then
		ids_alloc_invt = Create Datastore
		ids_alloc_invt.DataObject = 'd_comcast_allocated_invt_planned_rpt'
		ids_alloc_invt.SetTransObject(SQLCA)
		ids_alloc_invt.Retrieve()
	End If

	//Unplanned Outbound Inventory
	If not isvalid(ids_outbound_invt) then
		ids_outbound_invt = Create Datastore
		ids_outbound_invt.DataObject = 'd_comcast_outbound_invt_unplanned_rpt'
		ids_outbound_invt.SetTransObject(SQLCA)
		ids_outbound_invt.Retrieve()
	End If
	
	//IN-OEM qty	
	//Allocated IN-OEM
	If not isvalid(ids_alloc_oem) then
		ids_alloc_oem = Create Datastore
		ids_alloc_oem.DataObject =  'd_comcast_allocated_oem_rpt'
		ids_alloc_oem.SetTransObject(SQLCA)
		ids_alloc_oem.Retrieve()
	End If
	
	//Outbound Unplanned IN-OEM
	If not isvalid(ids_outbound_oem) then
		ids_outbound_oem = Create Datastore
		ids_outbound_oem.DataObject =  'd_comcast_outbound_oem_rpt'
		ids_outbound_oem.SetTransObject(SQLCA)
		ids_outbound_oem.Retrieve()
	End If
	
end event

type dw_select from w_std_report`dw_select within w_comcast_inventory_summary_report
boolean visible = false
integer x = 64
integer y = 1692
integer width = 2565
integer height = 48
end type

type cb_clear from w_std_report`cb_clear within w_comcast_inventory_summary_report
integer x = 2661
integer y = 1656
end type

type dw_report from w_std_report`dw_report within w_comcast_inventory_summary_report
integer x = 0
integer y = 0
integer height = 1636
string dataobject = "d_comcast_inventory_summary_report"
boolean hscrollbar = true
end type

