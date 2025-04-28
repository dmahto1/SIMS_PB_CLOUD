HA$PBExportHeader$w_main.srw
$PBExportComments$MDI Window
forward
global type w_main from window
end type
type mdi_1 from mdiclient within w_main
end type
end forward

global type w_main from window
string tag = "MDI Window"
integer width = 3131
integer height = 1932
boolean titlebar = true
string title = "SIMS"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
windowstate windowstate = maximized!
long backcolor = 273065670
boolean toolbarvisible = false
event ue_set_menu ( )
event ue_load_report ( )
event ue_help ( )
event ue_oldreportloadcode ( )
event type boolean e_postopen ( )
mdi_1 mdi_1
end type
global w_main w_main

type variables
m_main im_menu
Boolean	ibMenuRefresh
String	isHelpIndex

datastore idsReportDetail

end variables

event ue_set_menu();window lwindow
m_main lMenu



If gs_userid = "" Then
	main_menu.m_inbound.Enabled = False
	main_menu.m_outbound.Enabled = False
	main_menu.m_maintenance.Enabled = False
	main_menu.m_inventorymgmt.Enabled = False
	main_menu.m_reports.Enabled = False	
	main_menu.m_file.m_changepassword.Enabled = False
	main_menu.m_utilities.Enabled = False
		
Else
	
	main_menu.m_inbound.Enabled = True
	main_menu.m_outbound.Enabled = True
	main_menu.m_maintenance.Enabled = True
	main_menu.m_reports.Enabled = True
	main_menu.m_inventorymgmt.Enabled = True
	/*if gs_project = "HILLMAN" Then  //GAP1203
		main_menu.m_inventorymgmt.m_boh.Visible = True 
		main_menu.m_inventorymgmt.m_or.Visible = True 
	end if*/
	main_menu.m_file.m_changepassword.Enabled = True
	main_menu.m_utilities.Enabled = True	

	// If this is the Pandora Project,
	if gs_project = "PANDORA" then
		
		// If the user is KXZUVER,
		if gs_userid = "KXZUVER" then
			
			// Enable the 'Disk Erase' Maintenance Window.
			main_menu.m_utilities.m_16diskerase.visible=true
			main_menu.m_utilities.m_16diskerase.enabled=true
		End If

	// Otherwise, if this is the Comcast Project,
	Elseif gs_project = "COMCAST" then
			
			// Enable the 'Disk Erase' Maintenance Window.
			main_menu.m_utilities.m_importcomcast.visible=true
			main_menu.m_utilities.m_importcomcast.enabled=true
	End If

End IF

This.TriggerEvent("ue_set_project_menu")
end event

event ue_load_report();window wReport

string lswindow
string lsAccess
int ReportDetailRow
String	lsReport
Str_parms	lstrparms

lsReport = message.StringParm  

If isvalid(w_select_report) Then
	Close(w_select_report)
End If
w_main.SetMicrohelp("Loading Report...")

SetPointer(Hourglass!)

ReportDetailRow = idsReportDetail.retrieve( lsReport )
lsWindow = idsReportDetail.object.Report_window[ ReportDetailRow ]
lsAccess = idsReportDetail.object.Report_access[ ReportDetailRow ]

lstrparms.String_arg[1] = lsAccess

if lower(lsWindow) = 'w_pandora_commercial_invoice_rpt' then
	
	// ltk 11-08-2010  Added URL logic.  If column project_reports_detail.url is populated,
	// the URL will be HyperLinked, else w_pandora_commercial_invoice_rpt will open per the original logic.
	String lsReportURL
	lsReportURL = idsReportDetail.object.url[ ReportDetailRow ]
	
	if NOT IsNull( lsReportURL ) and Len( Trim( lsReportURL ) ) > 0 then
		//4/1/2011;  Gail M; Reentered David C's changes that did not migrated from Native PB to PVCS....  
		// 2/1/2011; David C; Open new pandora commercial invoice from web service window
		OpenSheetWithParm ( w_pandora_commercial_invoice_rpt_ws, lstrparms, w_main, gi_menu_pos, Original! )
		
		// 2/1/2011; David C; Commented out
//		inet linet_base
//
//		if GetContextService("Internet", linet_base) = 1 then
//			if linet_base.HyperlinkToURL( lsReportURL ) <> 1 then
//				MessageBox("ERROR", "System error Hyperlinking to URL.", Stopsign!)
//			end if
//		else
//			MessageBox("ERROR", "System error getting context service.", Stopsign!)
//		end if
//
//		if IsValid(linet_base) then Destroy(linet_base)

	else
		OpenSheetWithParm( w_pandora_commercial_invoice_rpt, lstrparms, w_main, gi_menu_pos, Original! )
	end if
Else

//TAM - 8/17 - SIMSPEVS 807 - Change baseline report access to not be case sensitive
//	if lsAccess <> 'All' and NOT isNull( lsAccess ) then
	if Upper(lsAccess) <> 'ALL' and NOT isNull( lsAccess ) then
		If f_check_access ( lsAccess, "" ) = 1 Then	
			OpenSheetWithParm( wReport, lstrparms, lower(lsWindow), w_main, gi_menu_pos, Original! )
		end if
	else
		OpenSheetWithParm( wReport, lstrparms, lower(lsWindow), w_main, gi_menu_pos, Original! )
	end if
End If

SetPointer(Arrow!)
w_main.SetMicrohelp("Ready")

end event

event ue_help;
//Opens the Help File - If index is passed, it will open to specific page in help file

If ishelpindex > ' ' Then
	ShowHelp(g.is_helpfile,Keyword!,ishelpindex)
Else
	ShowHelp(g.is_HelpFile,Index!)
End If
end event

event ue_oldreportloadcode();//// the massive choose case replace 08/10/05
//
//
//
//Choose Case lsReport
//		// PVH 08/09/05  /* LINKSYS Monthly Inbound Carton Count */
//	case 'LINK221'
//		If f_check_access ( "STK_RPT", "") = 1 Then OpenSheetwithparm(w_linksys_mthly_inbnd_ctn_count_rpt, 'INV_RPT',w_main, gi_menu_pos, Original!)
//		
//	// pvh 08/04/05
//	Case "SIMS444" /* SIEMENS INVENTORY QUANTITY ON HAND REPORT*/
//	
//		If f_check_access ( "STK_RPT", "") = 1 Then OpenSheetwithparm(w_siemens_inv_qty_on_hand, 'INV_RPT',w_main, gi_menu_pos, Original!)
//
//	Case "SIMS302" /* Stock Location Report*/
//	
//		If f_check_access ("STK_RPT","") = 1 Then
//			OpenSheetwithparm(w_stock_location_rpt, 'STK_RPT',w_main, gi_menu_pos, Original!)
//		End If
//	
//	Case "SIMS303" /*Stock Movement Report by SKU*/
//	
//		If f_check_access ("STK_RPT","") = 1 Then
//			OpenSheetwithparm(w_stock_movement_rpt, 'STK_RPT',w_main, gi_menu_pos, Original!)
//		End If
//		
//	Case "SIMS303A" /*Stock Movement Report by Date Range*/
//	
//		If f_check_access ("STK_RPT","") = 1 Then
//			OpenSheetwithparm(w_stock_movement_rpt_by_date, 'STK_RPT',w_main, gi_menu_pos, Original!)
//		End If
//	
//	Case "SIMS303B" /*Stock Movement Report by Date Range Exclusively for 3Com */
//	
//		If f_check_access ("STK_RPT","") = 1 Then
//			OpenSheetwithparm(w_3com_stock_movement_rpt_by_date, 'STK_RPT',w_main, gi_menu_pos, Original!)
//		End If
//		
//	Case "SIMS439"	
//		If f_check_access ("STK_RPT","") = 1 Then
//			OpenSheetwithparm(w_3com_order_tat, 'STK_RPT',w_main, gi_menu_pos, Original!)
//		End If
//	
//	Case "SIMS100" /*Receiving Report*/
//
//		IF gs_project = "LINKSYS" then
//			
//			If f_check_access ("W_RCV_RPT","") = 1 Then
//				OpenSheetwithparm(w_linksys_receiving_rpt,"W_RCV_RPT", w_main, gi_menu_pos, Original!)
//			End If
//		
//		ELSE
//
//			If f_check_access ("W_RCV_RPT","") = 1 Then
//				OpenSheetwithparm(w_receiving_rpt,"W_RCV_RPT", w_main, gi_menu_pos, Original!)
//			End If
//		
//		END IF
//		
//	Case "SIMS105" /*Over-Short Receipts Report*/
//	
//		OpenSheet(w_overshort_receipts,w_main, gi_menu_pos, Original!)
//		
//	
//	Case "SIMS200" /* Delivery Report*/
//	
//		If f_check_access ("W_DOR","") = 1 Then
//			OpenSheetwithparm(w_delivery_rpt,"W_DOR", w_main, gi_menu_pos, Original!)
//		End If
//	
//	Case "SIMS210" /* Delivery Report For portmounth*/
//	
//		If f_check_access ("W_DOR","") = 1 Then
//			OpenSheetwithparm(w_delivery_por_rpt,"W_DOR", w_main, gi_menu_pos, Original!)
//		End If
//		
//	Case "SIMS220" /* Delivery Allocation Report*/
//
//		If f_check_access ("W_DOR","") = 1 Then
//			OpenSheetwithparm(w_allocation_rpt,"W_DOR", w_main, gi_menu_pos, Original!)
//		End If
//	
//	Case "SIMS207" /*Delivery by SKU Report*/
//	
//		OpenSheet(w_delivery_by_sku_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "SIMS306" /*Fast Moving Report*/
//	
//		OpenSheet(w_fast_moving_rpt,w_main, gi_menu_pos, Original!)
//	
//	Case "SIMS301" /* Inventory by SKU */
//		IF gs_project = "IAE" then	/* 04/04 - Michael Anderson - Added customer report of IAE */
//	//		OpenSheet(w_iae_inventory_by_sku,w_main, gi_menu_pos, Original!)
//		ELSE
//			OpenSheet(w_inventory_by_sku,w_main, gi_menu_pos, Original!)
//		END IF
//	
//	Case "SIMS300" /* Summary Inventory Report*/
//	
//		OpenSheet(w_summary_inventory_report,w_main, gi_menu_pos, Original!)
//	
//	Case "SIMS307" /*Empty location*/
//		
//		OpenSheet(w_empty_location_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "SIMS101" /*Inbound Order*/
//		
//		OpenSheet(w_inbound_order_rpt,w_main, gi_menu_pos, Original!)
//	
//	Case "SIMS222" /* OutBound Order Report */
//		
//		IF gs_project = "LINKSYS" then
//
//			OpenSheet(w_linksys_outbound_order,w_main, gi_menu_pos, Original!)			
//	
//		ELSE
//
//			OpenSheet(w_outbound_order,w_main, gi_menu_pos, Original!)			
//			
//		END IF
//	
//	Case "SIMS9999" /* Outbound Order */
//		
//		OpenSheet(w_outbound_order_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "SIMS400" /*Item MAster*/
//		
//		OpenSheet(w_item_master_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "SIMS308" /* Inventory Replenishment Report*/
//		
//		OpenSheet(w_inventory_replenish_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "SIMS309" /* Stock Transfer Report*/
//		
//		OpenSheet(w_transfer_report,w_main, gi_menu_pos, Original!)
//		
//	Case "SIMS401" /* Location Master */
//		
//		OpenSheet(w_location_master_rpt,w_main, gi_menu_pos, Original!)
//	Case "SIMS406" /* Location Master */
//
//		OpenSheet(w_inv_priority_loc_rpt,w_main, gi_menu_pos, Original!)
//			
//	Case "SIMS437" /* Ambit hub daily report */
//		
//		OpenSheet(w_ambit_hub_daily_activity_rpt,w_main, gi_menu_pos, Original!)
//				
//	Case "SIMS311" /*Stock Inquiry*/
//		
//		If f_check_access ("W_INQ","") = 1 Then
//			lstrparms.String_arg[1] = "W_INQ"
//			OpenSheetwithparm(w_stockinquiry,lstrparms, w_main, gi_menu_pos, Original!)
//		End If
//		
//	Case "SIMS312" /* FWD Pick Replenishment Report*/
//		
//		OpenSheet(w_fwd_pick_replenish_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "SIMS403" /*customer MAster*/
//		
//		OpenSheet(w_customer_master_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "SIMS402" /* Supplier Master*/
//		
//		OpenSheet(w_supplier_master_rpt,w_main, gi_menu_pos, Original!)
//		
//	CASE 	"SIMS438"  /*po Receipt Total by SKU */
//		OpenSheet(w_po_receipt_total_by_sku_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "GEINVOICE" /*GE Invoice */
//		
//		OpenSheet(w_invoice_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "GENINVOICE" /*GEnrad Invoice */
//		
//		OpenSheet(w_genrad_invoice_rpt,w_main, gi_menu_pos, Original!)
//
//	Case "TDINVOICE" /*Teradyne Invoice */
//		
//		OpenSheet(w_teradyne_invoice_rpt,w_main, gi_menu_pos, Original!)
//	
//	Case "TDDELIV" /* Teradyne Delivery Document*/
//		
//		OpenSheet(w_teradyne_document_rpt,w_main, gi_menu_pos, Original!)
//
//	Case "GENDELIV" /*Genrad Delivery Document*/
//		
//		OpenSheet(w_genrad_document_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "GMMOUT" /*Gmm Outbound Report*/
//		
//		OpenSheet(w_gmm_outbound_report,w_main, gi_menu_pos, Original!)
//		
//	Case "GENSHPDLR" /*Genrad Ship to Dealer Report*/
//		
//		OpenSheet(w_genrad_ship_to_dealer_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "GENSERIAL" /*Genrad Serial Number Report*/
//		
//		OpenSheet(w_genrad_serial_nbr_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "GENINVSTAT" /*Genrad Inventory Status Report*/
//		
//		OpenSheet(w_genrad_inv_status_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "SIMS208" /*GEnrad Invoice location added by DGM */
//		
//		OpenSheet(w_invoice_ship_rpt_new,w_main, gi_menu_pos, Original!)	
//		
//	Case "SIMS902" /*Monthly ThroughPut Report */
//		
//		OpenSheet(w_monthly_thru_rpt,w_main, gi_menu_pos, Original!)	
//
//	Case "SIMS903" /*SIMS/Gemini Report */
//		
//		OpenSheet(w_sims_gemini_manifest_rpt,w_main, gi_menu_pos, Original!)	
//		
//	Case "SIMS904" /*SIMS/GMM Recibo-Empaque-Tranferencia */
//		
//		OpenSheet(w_gmm_receive_order,w_main, gi_menu_pos, Original!)			
//		
//	Case "SIMS404" /*SIMS/Gemini Report */
//		OpenSheet(w_inventory_by_type,w_main, gi_menu_pos, Original!)	
//		
//	Case "SIMS905" /*Work Order Report */
//		OpenSheet(w_workorder_Report,w_main, gi_menu_pos, Original!)
//		
//	Case "SIMS906" /*Consolidation Summary Report */
//		OpenSheet(w_consolidation_summary_rpt,w_main, gi_menu_pos, Original!)
//		
//	Case "SIMSASN" /*SIMS/ASN Report */
//		OpenSheet(w_asn_report,w_main, gi_menu_pos, Original!)	
//		
//		
//	Case "SAL-RMTP" /*08/02 - Pconkl - Saltillo - Raw Materials to PAck */
//		OpenSheet(w_saltillo_material_to_pack_rpt,w_main, gi_menu_pos, Original!)
//			
//	Case "RCVPACK" /*Receive Packaging Report*/
//		OpenSheet(w_receive_packaging_Report,w_main, gi_menu_pos, Original!)
//		
//	Case "SIMS862" /*Shipping Schedule (EDI 862)*/
//		OpenSheet(w_shipping_Schedule,w_main, gi_menu_pos, Original!)
//		
//	Case "HMINVOICE" //*Hillman Invoice */                                        //wason 12/23                                                             //wason 12/22
//      OpenSheet(w_hillman_invoice_rpt,w_main, gi_menu_pos, Original!)            //wason 12/23
//
//   Case "K&NINV" //*K&N Proma Invoice */                                    //wason 3/11/2004                                                             //wason 12/22
//      OpenSheet(w_kn_invoice_rpt,w_main, gi_menu_pos, Original!)            //wason 3/11/2004
//		
//   Case "SEARBOL" //*K&N Proma Invoice */                                    //wason 4/1/2004                                                             //wason 12/22
//      OpenSheet(w_sears_bol_rpt,w_main, gi_menu_pos, Original!)            //wason 4/1/2004
//	
//   Case "SEARSPL" //*K&N Proma Invoice */                                    //wason 4/1/2004                                                             //wason 12/22
//      OpenSheet(w_sears_packinglist_rpt,w_main, gi_menu_pos, Original!)      //wason 4/1/2004
//		
//	Case '3COMMES' /* 3com MES Reconciliation Report */
//		 OpenSheet(w_3com_mes_reconcil_rpt,w_main, gi_menu_pos, Original!) 
//	Case '3COMA0' /* 3com A0 Report */
//		 OpenSheet(w_3com_a0_rpt,w_main, gi_menu_pos, Original!) 
//
//	Case "SIMS405" //*K&N Putaway */                                    //Trey McClanahan 3/20/2004                                                             //wason 12/22
//      OpenSheet(w_putaway_report,w_main, gi_menu_pos, Original!)            
//
//	Case "ITEMBOM" //*Item MAster BOM*/                                                                                           //wason 12/22
//      OpenSheet(w_item_Bom_report,w_main, gi_menu_pos, Original!)            
//
//	Case "LINKINVOIC" //*Linksys Invoice Report*/                                                                                           //wason 12/22
//      OpenSheet(w_linksys_invoice_rpt,w_main, gi_menu_pos, Original!)            
//
//	Case "LOGIIQCR" //Logitech IQC Inspection Report*/                                                                                           //wason 12/22
//      OpenSheet(w_logitech_iqc_inspection_rpt,w_main, gi_menu_pos, Original!)            
//
//	Case "LOGIIQCS" //*Logitech IQC Status Report*/                                                                                           //wason 12/22
//      OpenSheet(w_logitech_iqc_status_rpt,w_main, gi_menu_pos, Original!)            
//
//	Case "LOGICYCR" //Logitech Cycle Count Report*/                                                                                           //wason 12/22
//      OpenSheet(w_logitech_cycle_count_rpt,w_main, gi_menu_pos, Original!)            
//
//	Case "LOGISHRP" //*Logitech Shipping Manifest Report*/                                                                                           //wason 12/22
//      OpenSheet(w_logitech_shipping_manifest_rpt,w_main, gi_menu_pos, Original!)            
//
//	Case "LOGIINV" //*Logitech Shipping Manifest Report*/                                                                                           //wason 12/22
//      OpenSheet(w_logitech_invoice_rpt,w_main, gi_menu_pos, Original!)            
//
//	Case "MARCSHP" //*Marc GT Shipment Reconciliation Report*/                                                                                           //wason 12/22
//      OpenSheet(w_marcgt_shipment_reconcil_rpt,w_main, gi_menu_pos, Original!)            
//
//	Case "LINK220"
//      OpenSheet(w_linksys_allocation_rpt,w_main, gi_menu_pos, Original!)            
//
//   Case "PHX222" //*Logitech Shipping Manifest Report*/                                                                                           //wason 12/22
//      OpenSheet(w_phxbrands_outbound_order,w_main, gi_menu_pos, Original!)     
//		
//		//MA 2004/10/26
//   Case "IBMPO" //*IBM PO*/                                                                                           //wason 12/22
//      OpenSheet(w_ibm_pondicherry_purchase_order,w_main, gi_menu_pos, Original!)   		
//
//      //TAM  2004/10/26
//	Case "MARCBOH" //*Marc GT Inventory Balance on Hand Report*/                                      
//     OpenSheet(w_marcgt_boh_rpt,w_main, gi_menu_pos, Original!)            
//    
//      //Wason 2004/11/17
//   Case "IBMINV" //*IBM pondicherry invoice */                                                                                           //wason 12/22
//     OpenSheetWithParm(w_ibm_pondicherry_invoice_rpt,'',w_main, gi_menu_pos, Original!)  
//	  
//  Case "IBMINVHS" //*IBM pondicherry invoice - High Seas version - Same report, different parm */                                                                                           //wason 12/22
//     OpenSheetWithParm(w_ibm_pondicherry_invoice_rpt, 'H',w_main, gi_menu_pos, Original!)  
//	  
//	Case "BOBCATCI" //*IBobcat Commercial Invoice */                                                                                           //wason 12/22
//     OpenSheet(w_bobcat_commercial_invoice_rpt,w_main, gi_menu_pos, Original!)   
//	
//	Case "3COMOUTP" //*3Com Outbound report */                                                                                           //wason 12/22
//     OpenSheet(w_3com_outbound_order,w_main, gi_menu_pos, Original!) 
//	  
//	// TAM 2004/12/28
//	Case "3CMVTVSBOH" //*3Com Movement vs Balance on Hand */                                                                                           //wason 12/22
//     OpenSheet(w_3com_stock_movement_vs_boh,w_main, gi_menu_pos, Original!) 
//	  
//	Case "BOBCATCM" //*IBobcat Cargo Manifest */                                                                                           //wason 12/22
//     OpenSheet(w_bobcat_cargo_manifest_invoice_rpt,w_main, gi_menu_pos, Original!)   
//
//	//TAM 2005/03/21  
//	Case "BOBCATIC" //*Bobcat Inbound Customs report */                                                                                           //wason 12/22
//     OpenSheet(w_bobcat_inbound_customs_rpt,w_main, gi_menu_pos, Original!)   
//
//	//TAM 2005/03/21  
//	Case "BOBCATOC" //*Bobcat Outbound Customs report */                                                                                           //wason 12/22
//     OpenSheet(w_bobcat_outbound_customs_rpt,w_main, gi_menu_pos, Original!)   
//	  
//	Case "IBMMOV" //*IBM PONDI stock movement report */                                                                                           //wason 01/9
//     OpenSheet(w_stock_movement_rpt_by_boe,w_main, gi_menu_pos, Original!)
//
//End Choose
//
end event

event type boolean e_postopen();// Have the user logon.
main_menu.m_file.m_logonoff.Event Clicked()



// Return true
return true
end event

on w_main.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

event close;DateTIme	ldtLogout

//10/04 - PCONKL - Update USer Login history with logout time

If gs_userid > '' Then
	
	ldtLogout = DateTime(today(),Now())

	Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

	Update User_login_history
	Set logout_time = :ldtLogout
	Where Project_id = :gs_Project and UserID = :gs_userid and login_time = :g.idt_USer_Login_Time
	Using SQLCA;
	
	Execute Immediate "COMMIT" using SQLCA;
	
End If

Execute Immediate "COMMIT" using SQLCA; /* 11/04 - PCONKL - If we have an unmatched Begin Trans, this should commit any hanging updates*/

Disconnect;

gb_sqlca_connected = FALSE

Close(This)
end event

event open;string	lsDatabase

idsReportDetail = Create datastore
idsReportDetail.DataObject = 'd_report_detail_by_report_id'
idsReportDetail.settransobject( sqlca )

main_menu = This.MenuId

//09/00 PCONKL - Include Database in Title!
lsDatabase = '  Database: '+ sqlca.servername + '/' + sqlca.database 
This.Title = This.Title + lsDatabase
GsTitle = This.Title

// 08/00 PCONKL - Load project specific menu options
This.TriggerEvent("ue_set_menu")

// Trigger the postopen event.
Post Event e_postopen()




 



end event

event resize;if isvalid (w_sims_banner) then w_sims_banner.postEvent ('resize') //Sarun2014Apr09 Banner
end event

type mdi_1 from mdiclient within w_main
long BackColor=276856960
end type

