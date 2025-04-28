HA$PBExportHeader$u_nvo_edi_confirmations.sru
$PBExportComments$Process any outbound edi confirmation transactions
forward
global type u_nvo_edi_confirmations from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations from nonvisualobject
end type
global u_nvo_edi_confirmations u_nvo_edi_confirmations

type variables
Integer	iiFileNo, &
			iiTotalQty, &
			iiCountQty
DataStore	idsDefaults

u_nvo_edi_confirmations_Phoenix		iu_nvo_Phoenix
u_nvo_edi_confirmations_Hillman		iu_nvo_hillman
u_nvo_edi_confirmations_Logitech		iu_nvo_Logitech
u_nvo_marc_transactions         		iu_nvo_Marc_Gt
u_nvo_edi_confirmations_ams_muser	iu_nvo_ams_muser
u_nvo_edi_confirmations_solectron	iu_nvo_Solectron
u_nvo_edi_confirmations_bluecoat		iu_nvo_bluecoat
u_nvo_edi_confirmations_Maquet		iu_nvo_Maquet
u_nvo_edi_confirmations_sika			iu_nvo_sika
u_nvo_edi_confirmations_Comcast	iu_nvo_Comcast
u_nvo_edi_confirmations_Pandora		iu_nvo_Pandora
u_nvo_edi_confirmations_LMC			iu_nvo_LMC
u_nvo_edi_confirmations_philips		iu_nvo_philips
u_nvo_edi_confirmations_philips_th	iu_nvo_philips_th
u_nvo_edi_confirmations_philipscls	iu_nvo_philipscls //TAM 2019/01/30 S28686
u_nvo_edi_confirmations_nycsp			iu_nvo_nycsp
u_nvo_edi_confirmations_baseline_unicode	iu_edi_confirmations_baseline_unicode
u_nvo_edi_confirmations_epson	iu_nvo_epson
u_nvo_edi_confirmations_babycare	iu_nvo_babycare
u_nvo_edi_confirmations_riverbed       iu_edi_confirmations_riverbed
u_nvo_edi_confirmations_nike       iu_edi_confirmations_nike
//Jxlim 08/07/2012 CR12 Added 3 interfaces for PHYSIO-XD and PHYSIO-MAA mimic AMS-MUSER
u_nvo_edi_confirmations_physio_maa 	iu_nvo_physio_maa 	
u_nvo_edi_confirmations_nyx 				iu_nvo_nyx	//2014/03 	
u_nvo_edi_confirmations_klonelab	 	iu_nvo_klonelab
u_nvo_edi_confirmations_tpv		 		iu_nvo_tpv
u_nvo_edi_confirmations_starbucks_th	iu_nvo_stbth
u_nvo_edi_confirmations_kinderdijk		iu_nvo_kinderdijk  //Jxlim 04/28/2013 Kinderdijk
u_nvo_edi_confirmations_funai			iu_nvo_funai
u_nvo_edi_confirmations_gibson			iu_nvo_gibson  // TAM 1/26/2015 
u_nvo_edi_confirmations_ariens			iu_nvo_ariens 		//Jxlim 07/30/2013 Ariens
u_nvo_edi_confirmations_friedrich	     iu_nvo_friedrich //TAM 2013/10 Friedrich
u_nvo_edi_confirmations_puma	          iu_nvo_puma //TAM 2013/10 Friedrich
u_nvo_edi_confirmations_garmin		     iu_nvo_garmin  //Jxlim 04/30/2014 Garmin
u_nvo_edi_confirmations_anki		    		iu_nvo_anki  //Jxlim 09/05/2014 Anki
u_nvo_edi_confirmations_honda_new		     iu_nvo_honda //TAM 2014/08 Honda
u_nvo_edi_confirmations_metro			iu_nvo_metro  //GWM 2013/11 Metro
u_nvo_edi_confirmations_aspen			iu_nvo_aspen // TAM 2015/09 Aspen
u_nvo_edi_confirmations_h2o		iu_nvo_h2o // 01/16 - PCONKL
u_nvo_edi_confirmations_fabercast		iu_nvo_fabercast	// 06/18 GailM
u_nvo_edi_confirmations_kendo		iu_nvo_kendo /* 04/16 - PCONKL*/
u_nvo_edi_confirmations_ws			iu_nvo_ws // TAM 2016/02
u_nvo_edi_confirmations_rema			iu_nvo_rema // TAM 2018/01
//u_nvo_edi_confirmations_loreal			iu_nvo_loreal  //GWM 2015/05 Loreal NYX  //TimA 05/26/15 Removed per Gail to get the build done.
u_nvo_edi_confirmations_coty			iu_nvo_coty  //GWM 2018/04 Coty
u_nvo_edi_confirmations_bosch		iu_nvo_bosch


end variables

forward prototypes
public function integer uf_stock_adjustment (string asproject, long aladjustid, long aitransid)
public function integer uf_workorder_confirmation (string asproject, string aswono, long aitransid)
public function integer uf_wo_components_issue (string asproject, string aswono, long aitransid)
public function integer uf_wo_putaway_confirmation (string asproject, string aswono, long aitransid)
public function integer uf_marc_gt_goods_issue_confirmation (string asproject, string asorderid, long aitransid)
public function integer uf_marc_gt_receipt_confirmation (string asproject, string asorderid, long aitransid)
public function integer uf_marc_gt_stock_adjustment (string asproject, long aladjustid, long aitransid)
public function integer uf_ready_to_ship_confirmation (string asproject, string asdono, long aitransid)
public function integer uf_itemmaster_confirmation (string asproject, long altransid)
public function integer uf_owner_change_confirmation (string asproject, string asorderid, long aitransid, string astransparm)
public function integer uf_proof_of_delivery_confirmation (string asproject, string asdono, integer aitransid)
public function integer uf_cycle_count_confirmation (string asproject, string asorderid, long altransid)
public function integer uf_serial_change_confirmation (string asproject, string asorderid, long aitransid)
public function integer uf_ups_load_tender_confirmation (string asproject, string asdono)
public function integer uf_delivery_dst_confirmation (string asproject, string asdono, string asstatus)
public function integer uf_th_multimacid_confirmation (string asproject, string asorderid, long altransid)
public function integer uf_goods_receipt_confirmation (string asproject, string asorderid, long aitransid, string astransparm)
public function integer uf_goods_issue_confirmation (string asproject, string asdono, long aitransid, string astransparm, datetime dtrecordcreatedate)
public function integer uf_shipment_confirmation (string asproject, string asdono, long aitransid, string astransparm, datetime dtrecordcreatedate)
public function integer uf_commercial_invoice_confirmation (string asproject, string asdono, long aitransid, string astransparm, datetime dtrecordcreatedate)
public function integer uf_delivery_void_confirmation (string asproject, string asdono, long altransid)
public function integer uf_lwon (string asproject, string asloadid, long aitransid, string astransparm, datetime dtrecordcreatedate)
public function integer uf_event_status (string asproject, string astranstype, string asdono, string astransparm)
public function integer uf_rd_sd_change_confirmation (string asproject, string astranstype, string asdono)
public function integer uf_receipt_void_confirmation (string asproject, string asorderid, long aitransid, string astransparm)
end prototypes

public function integer uf_stock_adjustment (string asproject, long aladjustid, long aitransid);//Process a Good Issue confirmation Transaction for the proper project
Integer	liRC
String	lsWarehouseType, lsWH
string  lsadjustment_type

u_nvo_edi_Confirmations_Phoenix	lu_nvo_Phoenix
u_nvo_edi_Confirmations_Maquet	lu_nvo_Maquet
u_nvo_edi_Confirmations_Logitech	lu_nvo_Logitech
u_nvo_edi_confirmations_ams_muser	lu_nvo_ams_muser
u_nvo_edi_Confirmations_philips	lu_nvo_philips
u_nvo_edi_Confirmations_philips_th	lu_nvo_philips_th
u_nvo_edi_Confirmations_Comcast	lu_nvo_Comcast
u_nvo_edi_confirmations_baseline_unicode	lu_nvo_edi_confirmations_baseline_unicode
//Jxlim 08/07/2012 CR12 Added 3 interfaces for PHYSIO-XD and PHYSIO-MAA mimic AMS-MUSER
u_nvo_edi_confirmations_physio_xd	lu_nvo_physio_xd
u_nvo_edi_confirmations_physio_maa	lu_nvo_physio_maa
u_nvo_edi_confirmations_honda_new	lu_nvo_honda
//Jxlim 08/14/2012 CR12 Added 3 interfaces for PHYSIO-XD and PHYSIO-MAA mimic AMS-MUSER to be removed after UAT

u_nvo_edi_confirmations_tpv		lu_nvo_tpv
u_nvo_edi_confirmations_funai		lu_nvo_funai
u_nvo_edi_confirmations_gibson	lu_nvo_gibson
u_nvo_edi_confirmations_nyx		lu_nvo_nyx
u_nvo_edi_confirmations_kendo		lu_nvo_kendo
u_nvo_edi_confirmations_pandora lu_nvo_pandora //08-Aug-2017 :Madhu PINT-947 Stock Adjustment
u_nvo_edi_confirmations_rema 	lu_nvo_rema	//05-APR-2018 :Madhu S17944 Stock Adjustment
u_nvo_edi_confirmations_philipscls       lu_nvo_philipscls /* 02/19 - PCONKL */

Choose Case Upper(asproject)
	
	Case 'AMS-MUSER'
		lu_nvo_ams_muser = Create u_nvo_edi_confirmations_ams_muser
		liRC = lu_nvo_ams_muser.uf_adjustment(asProject, alAdjustID, aiTransID)

//Jxlim 08/14/2012 This is done on Marc_GT calls Strock adjustment(GU) for Physio
	//Jxlim 08/07/2012 CR12 Added 3 interfaces for PHYSIO-XD and PHYSIO-MAA mimic AMS-MUSER
	Case 'PHYSIO-XD'
		lu_nvo_physio_xd = Create u_nvo_edi_confirmations_physio_xd
		liRC = lu_nvo_physio_xd.uf_adjustment(asProject, alAdjustID, aiTransID)
		
	Case 'PHYSIO-MAA'
		lu_nvo_physio_maa = Create u_nvo_edi_confirmations_physio_maa
		liRC = lu_nvo_physio_maa.uf_adjustment(asProject, alAdjustID, aiTransID)		
			
	Case 'PHXBRANDS'
		
		lu_nvo_Phoenix = Create u_nvo_edi_Confirmations_Phoenix
		liRC = lu_nvo_Phoenix.uf_adjustment(asProject, alAdjustID)
	
	Case 'LOGITECH'
		
		lu_nvo_Logitech = Create u_nvo_edi_Confirmations_Logitech
		liRC = lu_nvo_Logitech.uf_adjustment(asProject, alAdjustID)

	
//	Case 'MAQUET'
//		
//		// dts 10/08 - not sending transactions for cross-dock wh (need to add field to wh table to enable/disable transactions)
//		select wh_Code into :lsWH from Adjustment where adjust_no = :alAdjustID; 
//		
//		if lsWH = 'MAQ-CROSS' then
//			//don't create transaction
//			//return 0
//		else
//			lu_nvo_Maquet = Create u_nvo_edi_Confirmations_Maquet
//			liRC = lu_nvo_Maquet.uf_adjustment(asProject, alAdjustID)
//		end if
		
	Case 'PHILIPS-SG'
		
		lu_nvo_philips = Create u_nvo_edi_Confirmations_Philips
		liRC = lu_nvo_philips.uf_adjustment(asProject, alAdjustID)
			
	Case 'PHILIPS-TH'
		
		lu_nvo_philips_th = Create u_nvo_edi_Confirmations_philips_th
		liRC = lu_nvo_philips_th.uf_adjustment(asProject, alAdjustID)		

	Case 'PHILIPSCLS' /* 02/19 - PCONKL */
                             
		lu_nvo_philipscls = Create u_nvo_edi_Confirmations_Philipscls
         liRC = lu_nvo_philipscls.uf_adjustment(asProject, alAdjustID, aiTransID)

	Case 'GEISTLICH' //BCR 22-DEC-2011 for Geistlich
		
		lu_nvo_edi_confirmations_baseline_unicode = Create u_nvo_edi_confirmations_baseline_unicode
		liRC = lu_nvo_edi_confirmations_baseline_unicode.uf_adjustment(asProject, alAdjustID)
	
	Case 'TPV' /* 01/13 - PCONKL */
		
		lu_nvo_tpv = Create u_nvo_edi_Confirmations_tpv
		liRC = lu_nvo_tpv.uf_adjustment(asProject, alAdjustID)
		
	Case 'FUNAI' /* 6/13 - MEA */
		
		lu_nvo_funai = Create u_nvo_edi_Confirmations_funai
		liRC = lu_nvo_funai.uf_adjustment(asProject, alAdjustID)		
		
		
	Case 'GIBSON' /* 1/2015 - TAM */
		
		lu_nvo_gibson = Create u_nvo_edi_Confirmations_gibson
		liRC = lu_nvo_gibson.uf_adjustment(asProject, alAdjustID)		
		
		
	Case 'FRIEDRICH' //TAM 2013/10 - Added Friedrich
		
		lu_nvo_edi_confirmations_baseline_unicode = Create u_nvo_edi_confirmations_baseline_unicode
		liRC = lu_nvo_edi_confirmations_baseline_unicode.uf_adjustment(asProject, alAdjustID)

	Case 'HONDA-TH'
	
		lu_nvo_honda = Create u_nvo_edi_confirmations_honda_new
		liRC = lu_nvo_honda.uf_adjustment(asProject, alAdjustID)
		
	Case 'NYX' //gwm 2015/06 - Added NYX
		
		lu_nvo_nyx = Create u_nvo_edi_Confirmations_nyx
		liRC = lu_nvo_nyx.uf_adjustment(asProject, alAdjustID)		
		//lu_nvo_edi_confirmations_baseline_unicode = Create u_nvo_edi_confirmations_baseline_unicode
		//liRC = lu_nvo_edi_confirmations_baseline_unicode.uf_adjustment(asProject, alAdjustID)

	Case 'KENDO'
	
		lu_nvo_kendo = Create u_nvo_edi_confirmations_kendo
		liRC = lu_nvo_kendo.uf_adjustment(asProject, alAdjustID)

	//08-Aug-2017 :Madhu PINT -947 Stock Adjustment
	Case 'PANDORA'
		lu_nvo_pandora = Create u_nvo_edi_confirmations_pandora
		liRC = lu_nvo_pandora.uf_om_adjustment(asProject, alAdjustID, aiTransID)
		
	Case 'REMA'
		lu_nvo_rema = Create u_nvo_edi_confirmations_rema
		liRC = lu_nvo_rema.uf_process_om_adjustment( asProject, alAdjustID, aiTransID)
		
	Case Else /* not being processed, delete record */
		
		liRC = 99
	
		
End Choose


Return liRC

end function

public function integer uf_workorder_confirmation (string asproject, string aswono, long aitransid);// we may need to send a transaction when the workorder is confirmed
Integer	liRC

Choose Case Upper(asproject)
		
// TAM 07/04
	Case 'LOGITECH'
		
		If Not isvalid(iu_nvo_logitech) Then	
			iu_nvo_logitech = Create u_nvo_edi_confirmations_logitech
		End If
		// Send a returns transaction at Final Confirmation		
		liRC = iu_nvo_logitech.uf_wo_Components_Return(asProject, asWONO, aiTransID)	
		
	// TAM 07/04
	Case 'RIVERBED'
		
		If Not isvalid(iu_edi_confirmations_riverbed) Then	
			iu_edi_confirmations_riverbed = Create u_nvo_edi_confirmations_riverbed
		End If
		// Send a returns transaction at Final Confirmation		
		liRC = iu_edi_confirmations_riverbed.uf_gw(asProject, asWONO)	

	// TAM 2016/01
	Case 'NYX'
		
		If Not isvalid(iu_nvo_nyx) Then	
			iu_nvo_nyx = Create u_nvo_edi_confirmations_nyx
		End If
		// Send a returns transaction at Final Confirmation		
		liRC = iu_nvo_nyx.uf_gw(asProject, asWONO)	
	
	Case Else /* not being processed, delete record */
		
		liRC = 99
	
End Choose
 

Return liRC

end function

public function integer uf_wo_components_issue (string asproject, string aswono, long aitransid);//TAM 07/04
// we may need to send a transaction when the workorder has components picked 
// Currently assigned when the first Putaway is confirmed
Integer	liRC

Choose Case Upper(asproject)
									
	Case 'LOGITECH'
		
	If Not isvalid(iu_nvo_Logitech) Then	
		iu_nvo_logitech = Create u_nvo_edi_confirmations_Logitech
	End If
		
	liRC = iu_nvo_logitech.uf_wo_components_issue(asProject, asWONO, aiTransID)	
	
End Choose
 

Return liRC

end function

public function integer uf_wo_putaway_confirmation (string asproject, string aswono, long aitransid);//TAM 07/04
// we may need to send a  transaction when the workorder is has components returned to stock
Integer	liRC

Choose Case Upper(asproject)
									
	Case 'LOGITECH'
		
		If Not isvalid(iu_nvo_Logitech) Then	
			iu_nvo_logitech = Create u_nvo_edi_confirmations_Logitech
		End If
		//	Send a receipt transaction	at putaway confirmation
		liRC = iu_nvo_logitech.uf_workorder_receipt(asProject, asWONO, aiTransID)	
		
	Case Else /* not being processed, delete record */
		
		liRC = 99

End Choose
 

Return liRC

end function

public function integer uf_marc_gt_goods_issue_confirmation (string asproject, string asorderid, long aitransid);//Process a Mark GT Transaction for the proper project
Integer	liRC
String	lswarehouse


//We need the order type to determine Warehouse
Select Wh_Code into :lswarehouse
From Delivery_master
Where do_no = :asOrderID;
		
Choose Case Upper(asproject)
		
//TAM added AMS-MUSER
	Case 'AMS-MUSER' 
		If Not isvalid(iu_nvo_Marc_Gt) Then	
			iu_nvo_Marc_Gt = Create u_nvo_marc_transactions
		End If
		
//24-Jun-2013 :Madhu added code to stop send transaction files to MarcGT, if WH is Non-bonded -START
 string ls_whtype
 select wh_type  into :ls_whtype from Warehouse_Type where WH_Type in (
 		                                 select WH_Type from Warehouse where WH_Code in (
                                         select WH_Code from Delivery_Master where DO_No=:asOrderId))
 using sqlca;
      
IF (ls_whtype <> 'N'  ) THEN  //24-Jun-2013 :Madhu added code to stop send transaction files to MarcGT, if WH is Non-bonded -END
		iu_nvo_Marc_Gt.uf_shipments(asProject,asOrderId)
END IF		//24-Jun-2013 :Madhu added code to stop send transaction files to MarcGT, if WH is Non-bonded -Added

//TAM added EER-MUSER
	Case 'EER-MUSER' 
		If Not isvalid(iu_nvo_Marc_Gt) Then	
			iu_nvo_Marc_Gt = Create u_nvo_marc_transactions
		End If
		
//24-Jun-2013 :Madhu added code to stop send transaction files to MarcGT, if WH is Non-bonded -START
 select wh_type  into :ls_whtype from Warehouse_Type where WH_Type in (
 		                                 select WH_Type from Warehouse where WH_Code in (
                                         select WH_Code from Delivery_Master where DO_No=:asOrderId))
 using sqlca;
      
IF (ls_whtype <> 'N'  ) THEN  //24-Jun-2013 :Madhu added code to stop send transaction files to MarcGT, if WH is Non-bonded -END
		iu_nvo_Marc_Gt.uf_shipments(asProject,asOrderId)
END IF		//24-Jun-2013 :Madhu added code to stop send transaction files to MarcGT, if WH is Non-bonded -Added

//Jxlim 08/07/2012 CR12 Added interfaces for PHYSIO-XD, PHYSIO-MAA mimic AMS-MUSER
	Case 'PHYSIO-XD'
		If Not isvalid(iu_nvo_Marc_Gt) Then	
			iu_nvo_Marc_Gt = Create u_nvo_marc_transactions
		End If
		iu_nvo_Marc_Gt.uf_shipments(asProject,asOrderId)		
		
	Case 'PHYSIO-MAA'
		If Not isvalid(iu_nvo_Marc_Gt) Then	
			iu_nvo_Marc_Gt = Create u_nvo_marc_transactions
		End If
		iu_nvo_Marc_Gt.uf_shipments(asProject,asOrderId)		
		
		
	Case Else /* not being processed, delete record */
		
		liRC = 99
		
End Choose


Return liRC

end function

public function integer uf_marc_gt_receipt_confirmation (string asproject, string asorderid, long aitransid);//Process a Mark GT Transaction for the proper project
Integer	liRC
String	lswarehouse


//We need the Warehouse
Select Wh_Code into :lswarehouse
From Receive_master
Where ro_no = :asOrderID;
		
Choose Case Upper(asproject)
	
//TAM added AMS-MUSER
	Case 'AMS-MUSER'
		If Not isvalid(iu_nvo_Marc_Gt) Then	
			iu_nvo_Marc_Gt = Create u_nvo_marc_transactions
		End If
		iu_nvo_Marc_Gt.uf_receipts(asProject,asOrderId)
		
//Jxlim 08/07/2012 CR12 Added interfaces for PHYSIO-XD, PHYSIO-MAA mimic AMS-MUSER
	Case 'PHYSIO-XD'
		If Not isvalid(iu_nvo_Marc_Gt) Then	
			iu_nvo_Marc_Gt = Create u_nvo_marc_transactions
		End If
		iu_nvo_Marc_Gt.uf_receipts(asProject,asOrderId)
		
	Case 'PHYSIO-MAA'
		If Not isvalid(iu_nvo_Marc_Gt) Then	
			iu_nvo_Marc_Gt = Create u_nvo_marc_transactions
		End If
		iu_nvo_Marc_Gt.uf_receipts(asProject,asOrderId)			


			
	Case Else /* not being processed, delete record */
		
		liRC = 99
		
End Choose


Return liRC

end function

public function integer uf_marc_gt_stock_adjustment (string asproject, long aladjustid, long aitransid);//Process a Mark GT Transaction for the proper project
Integer	liRC
String	lswarehouse
		
Choose Case Upper(asproject)
		

//TAM added AMS-MUSER
	Case 'AMS-MUSER'
		If Not isvalid(iu_nvo_Marc_Gt) Then	
			iu_nvo_Marc_Gt = Create u_nvo_marc_transactions
		End If
		iu_nvo_Marc_Gt.uf_corrections(asProject,alAdjustId)
		
//Jxlim 08/01/2012 CR12 Added interfaces for PHYSIO-XD, PHYSIO-MAA mimic AMS-MUSER
	Case 'PHYSIO-XD'
		If Not isvalid(iu_nvo_Marc_Gt) Then	
			iu_nvo_Marc_Gt = Create u_nvo_marc_transactions
		End If
		iu_nvo_Marc_Gt.uf_corrections(asProject,alAdjustId)
		
	Case 'PHYSIO-MAA'
		If Not isvalid(iu_nvo_Marc_Gt) Then	
			iu_nvo_Marc_Gt = Create u_nvo_marc_transactions
		End If
		iu_nvo_Marc_Gt.uf_corrections(asProject,alAdjustId)

	Case Else /* not being processed, delete record */
		
		liRC = 99
		
End Choose


Return liRC



end function

public function integer uf_ready_to_ship_confirmation (string asproject, string asdono, long aitransid); 
//Process a Ready To Ship confirmation Transaction for the proper project
Integer	liRC
String	lsOrdType, lsWH, lsShipToCountry, lsLogOut, lsReadyToShipInd, lsOrdStat

//We need the order type to determine Sale vs Transfer, etc. - Added Order Status for Faber-Cast
Select Ord_type, Country, Ord_Status into :lsOrdtype, :lsShipToCountry, :lsOrdStat
From Delivery_master with(nolock)
Where do_no = :asDoNo;


Choose Case Upper(asproject)
		
		
	Case 'MAQUET'
		// dts 10/08 - not sending transactions for cross-dock wh (need to add field to wh table to enable/disable transactions)
		Select wh_code into :lsWH
		From  Delivery_Master where do_no = :asDONO;
		
		/*  dts 10/14/08 - Not sending for orders of type 'N - NO SAP' or 'Z - Warehouse Transfer'
		    ...eventually will add field to delivery_order_type that indicates whether or not interfaces are sent... */
		if lsWH = 'MAQ-CROSS' or lsOrdType = 'N' or lsOrdType = 'Z' then
			//don't create transaction
			//return 0
		else
			If Not isvalid(iu_nvo_maquet) Then
				iu_nvo_maquet = Create u_nvo_edi_confirmations_maquet
			End If
			
			liRC = iu_nvo_maquet.uf_gi_lms(asProject, asDONO, 'RS')	/*LMS RS */
		end if
		
	Case "FABER-CAST"
		
		Select enable_ready_ind into :lsReadyToShipInd
		From Project with(nolock)
		Where project_id = :asDoNo;

		If lsReadyToShipInd = "Y" and lsOrdStat = "R" Then 
			If Not isvalid(iu_nvo_fabercast) Then
				iu_nvo_fabercast = Create u_nvo_edi_confirmations_fabercast
			End If		
	
			liRC = iu_nvo_fabercast.uf_gi(asProject, asDONO, 'RS')
		End If

	Case "KLONELAB"
		
		If Not isvalid(iu_nvo_klonelab) Then
			iu_nvo_klonelab = Create u_nvo_edi_confirmations_klonelab
		End If		

		liRC = iu_nvo_klonelab.uf_gi(asProject, asDONO, 'RS')

	//15-Sep-2016 Madhu -KDO-1003407	- Generate GI file for International Orders (other than US) -START
	Case "KENDO"
		
		If Not isvalid(iu_nvo_kendo) Then
			iu_nvo_kendo =Create u_nvo_edi_confirmations_kendo
		End If

		lsLogOut = "        Creating GI from ReadyToShip For DONO: " + asDONO + " ShipToCountry: " +lsShipToCountry
		FileWrite(gilogFileNo,lsLogOut)
		
		//20-Feb-2017 :Madhu -SIMSPEVS-492 - Don't resend RS file, if Order is Re-confirmed -START
		int ll_count
		select count(*) into :ll_count from Batch_Transaction with(nolock)
		//dts 2019-08-21 (why wasn't Trans_type='RS' part of the 'where' clause?)... 
		//where Project_Id=:asproject and Trans_Order_Id=:asDONO and Trans_Status='C';
		where Project_Id=:asproject and Trans_Order_Id=:asDONO and Trans_Status='C' and Trans_type='RS';

		//check for ship to country, If it is an International Order, generate GI
		//Since, using ReadyToShip for US orders too, generate GI file one time.

		//TAM - 2019/07/05 - DE11405 - Exclude PhilipsCLS from resending RS records
		//dts 2019-08-21 - DE12306 - why is DE11405 for Philips implemented in this Case KENDO section?
		//  - for DE12306, I am re-commenting out the line below and re-uncommenting out the line below that. (Also note that I've added Trans_type='RS' as part of the where clause above)
		//If isnull(lsShipToCountry) OR lsShipToCountry ='' OR lsShipToCountry ="US" OR lsShipToCountry ="USA" OR ll_count > 0 Then
		If ll_count > 0 Then
			liRC =99 // To delete RS record from Batch Transaction
			
			lsLogOut=" RS record is deleted due to either RS file has already generated or ShipToCountry is USA"
			FileWrite(giLogFileNo, lsLogOut)
		//20-Feb-2017 :Madhu -SIMSPEVS-492 - Don't resend RS file, if Order is Re-confirmed -END
		Else
			liRC =iu_nvo_kendo.uf_gi( asproject, asdono) //call GI function
		End If
	
	//15-Sep-2016 Madhu -KDO-1003407	- Generate GI file for International Orders (other than US) -END
	
	//22-FEB-2019 :Madhu S29714 PhilipsBlueHeart Product Picked
	Case 'PHILIPSCLS'
	
	IF Not IsValid(iu_nvo_philipscls) Then
		iu_nvo_philipscls = create u_nvo_edi_confirmations_philipscls
	End IF
	
	liRC = iu_nvo_philipscls.uf_product_picked( asproject, asdono)
	
	Case Else /* not being processed, delete record */
		
		liRC = 99
		
End Choose


Return liRC


//Return 0
end function

public function integer uf_itemmaster_confirmation (string asproject, long altransid);
//We may need to send a transaction when an ITem Master is updated
//We generally won't pass a SKU in the transaction - we will retrieve all rows where "Interface_Upd_Req_Ind" is set to "Y"

 

Integer	liRC



Choose Case Upper(asproject)
			
	Case 'MAQUET'
	
		If Not isvalid(iu_nvo_maquet) Then
			iu_nvo_maquet = Create u_nvo_edi_confirmations_maquet
		End If
		
		liRC = iu_nvo_maquet.uf_lms_itemmaster()	/*Item Master update to LMS */
	
		
	Case 'PHXBRANDS'
	
		If Not isvalid(iu_nvo_Phoenix) Then
			iu_nvo_Phoenix = Create u_nvo_edi_confirmations_Phoenix
		End If
		
		liRC = iu_nvo_Phoenix.uf_lms_itemmaster()	/*Item Master update to LMS */
		
	Case 'NYCSP'
	
// TAM 2013/02/27  Removed NYCSP
//		If Not isvalid(iu_nvo_NYCSP) Then
//			iu_nvo_NYCSP = Create u_nvo_edi_confirmations_NYCSP
//		End If
//		
//		liRC = iu_nvo_NYCSP.uf_lms_itemmaster()	/*Item Master update to LMS */
//			
	Case Else /* not being processed, delete record */
		
		liRC = 99
		
End Choose


Return liRC


end function

public function integer uf_owner_change_confirmation (string asproject, string asorderid, long aitransid, string astransparm); 
//Process a Owner Change confirmation Transaction for the proper project
Integer	liRC

String ls_OM_Conf_Type
// TAM 08/2017 - PINT Added confirmation type to split between EDI and OM transaction
Select OM_Confirmation_type Into :ls_OM_Conf_Type
From Transfer_master with(nolock)
Where to_no = :asorderid;

// TAM 11/2017 - PINT Added a check to the warehouse_master to see if OM is turned on.  This is needed to process cycle count SOCs which don't originate from Pandora so the   
// OM_Confirmation_type will not be set for these but we still need to process it through OM
String ls_OM_Enabled_Ind
SELECT OM_Enabled_Ind  
INTO :ls_OM_Enabled_Ind  
FROM Transfer_Master with(nolock), Warehouse  with(nolock)
WHERE D_Warehouse = WH_Code and  To_No = :asorderid   ;

Choose Case Upper(asproject)
		
		
	Case 'PANDORA'
	
		If Not isvalid(iu_nvo_Pandora) Then
			iu_nvo_pandora = Create u_nvo_edi_confirmations_pandora
		End If
		
		If upper(ls_OM_Conf_Type) ='E' or ls_OM_Enabled_Ind = 'Y' Then //08/-2017 :TAM PINT-945 SOC Confirmation
			liRC = iu_nvo_pandora.uf_process_oc_om(asProject, asorderid, astransparm, aitransid )
		Else
//		TAM 2009/06/16 RosettaNet
		//TimA 05/05/14 Pandora issue #36 added astransparm
			liRC = iu_nvo_pandora.uf_oc_rose(asProject, asorderid, astransparm)
		End If		
		
	Case Else /* not being processed, delete record */
		
		liRC = 99
		
End Choose


Return liRC

end function

public function integer uf_proof_of_delivery_confirmation (string asproject, string asdono, integer aitransid);
Integer	liRC

//Choose Case Upper(asproject)
//		
//	Case "WARNER" 
//		
//		If Not isvalid(iu_nvo_WARNER) Then
//			iu_nvo_Warner = Create u_nvo_edi_confirmations_Warner
//		End If		
//		
//		liRC = iu_nvo_warner.uf_pod(asProject, asDONO)
//		
//	Case "BABYCARE" 
//		
//		If Not isvalid(iu_nvo_babycare) Then
//			iu_nvo_babycare = Create u_nvo_edi_confirmations_babycare
//		End If		
//		
//		liRC = iu_nvo_babycare.uf_pod(asProject, asDONO)
//	
//		
//	Case Else /* not being processed, delete record */
//		
//		liRC = 99
//		
//End Choose

Return liRC
end function

public function integer uf_cycle_count_confirmation (string asproject, string asorderid, long altransid);//Process a cycle count Transaction for the proper project
Integer	liRC
String	lsOrdType, lsWarehouseType, lsWH, ls_om_enabled, lsStatus 

If Not isvalid(iu_nvo_pandora) Then
	iu_nvo_pandora = Create u_nvo_edi_confirmations_pandora
End If

//We need the order type to determine supplier order vs Return or Transfer (MM)
Select Ord_type, wh_code, Ord_status into :lsOrdtype, :lsWh, :lsStatus
From CC_Master with(nolock)
Where cc_no = :asOrderID
using sqlca;

Choose Case Upper(asproject)
	Case 'PANDORA'
		//Only processing Order type 'P' - Pandora-directed Cycle Count
		//If lsOrdtype = 'P' Then 
		//	liRC = iu_nvo_pandora.uf_cc_confirm(asProject, asOrderID)
	
		//ElseIf lsOrdtype = 'X' Then  		//20-Nov-2017 :Madhu - PEVS-806 3PL Cycle Count Order
		If lsStatus <> 'V' Then //TAM 2018/07/12 - Skip Voids
			liRC = iu_nvo_pandora.uf_confirm_system_generated_cc( asProject, asOrderID)
		Else
			liRC = 99
		End If
	Case Else /* not being processed, delete record */
		liRC = 99
End Choose

//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
IF upper(asproject) ='PANDORA' and liRC <> 99 and liRC <> -1 THEN
	
	//find up count zero cc orders
	liRC = iu_nvo_pandora.uf_create_up_count_zero_cc_records( asOrderID)
	
	//if up count zero records exists, create inbound order
	If iu_nvo_pandora.ids_cc_upcountzero_result.rowcount( ) > 0 Then 
		liRC = iu_nvo_pandora.uf_create_up_count_zero_inbound_order( asProject, asOrderID)
	End If
	
	destroy iu_nvo_pandora.ids_cc_upcountzero_result //TAM 2018/11/12  - DE7202, DE9598 -  Need to destroy the ids after complete.  2 cc's in the same sweeper run will cause extra enventory to be written when it shouldn't
	
END IF

Return liRC

end function

public function integer uf_serial_change_confirmation (string asproject, string asorderid, long aitransid); 
//Process a Serial Number Change confirmation Transaction for the proper project
Integer	liRC




Choose Case Upper(asproject)
		
		
	Case 'PANDORA'
	
		If Not isvalid(iu_nvo_Pandora) Then
			iu_nvo_pandora = Create u_nvo_edi_confirmations_pandora
		End If
		
//		TAM 2009/06/16 RosettaNet
		liRC = iu_nvo_pandora.uf_serial_change_rose(asProject)
		
		liRC = iu_nvo_pandora.uf_process_serial_change_om( asproject) //PINT-947 -Stock Adjustment for SN
		
	Case Else /* not being processed, delete record */
		
		liRC = 99
		
End Choose


Return liRC

end function

public function integer uf_ups_load_tender_confirmation (string asproject, string asdono);//Jxlim 04/20/2011 Pandora UPS laod tender  (out going file)
//Send a file for communicating Commercial Invoice data
Integer	liRC

Choose Case Upper(asproject)
			
	Case 'PANDORA'
		If Not isvalid(iu_nvo_pandora) Then
			iu_nvo_pandora = Create u_nvo_edi_confirmations_pandora
		End If
		liRC = iu_nvo_pandora.uf_process_ups(asProject, asDONO)	
		
	Case Else /* not being processed, delete record */
		liRC = 99
End Choose

Return liRC

end function

public function integer uf_delivery_dst_confirmation (string asproject, string asdono, string asstatus); 
//Process a DST (Picking) confirmation Transaction for the proper project
Integer	liRC
String	lsOrdType, lsWarehouseType, lsWH

//We need the order type to determine Sale vs Transfer, etc.
//Select Ord_type into :lsOrdtype
//From Delivery_master
//Where do_no = :asDoNo;

Choose Case Upper(asproject)
		
	Case 'NIKE-SG', 'NIKE-MY'
	
		If Not isvalid(iu_edi_confirmations_nike) Then
			iu_edi_confirmations_nike = Create u_nvo_edi_confirmations_nike
		End If
		
		liRC = iu_edi_confirmations_nike.uf_dst(asProject, asDONO, asstatus)		

//22-Feb-2017 :Madhu- As Trey suggested to comment until go-live
//	Case 'WS-PR'
//	
//		If Not isvalid(iu_nvo_ws) Then
//			iu_nvo_ws = Create u_nvo_edi_confirmations_ws
//		End If
//		
//		liRC = iu_nvo_ws.uf_dst(asProject, asDONO, asstatus)		
			
	Case Else /* not being processed, delete record */
		
		liRC = 99
		
End Choose


Return liRC


end function

public function integer uf_th_multimacid_confirmation (string asproject, string asorderid, long altransid);/* Added new transaction type TH for sending multiple Mac ID alerts */
/* Gail - 4/4/2013 - Add check for TransParm to send email for MacID, Invalid Site, or Dupe Record and Insert Error. */
integer liRC
string   lsTransParm

Choose Case Upper(asproject)
									
	Case 'COMCAST'
		If Not isvalid(iu_nvo_comcast) Then	
			iu_nvo_comcast = Create u_nvo_edi_confirmations_comcast
		End If
		/* Get TransParm for type of email */
		Select trans_parm into :lsTransParm
		from Batch_Transaction
		Where trans_id = :alTransId;
		
		Choose Case Upper(lsTransParm)
			Case 'MAC'
				liRC = iu_nvo_comcast.uf_multiple_mac_id(asProject, asOrderID, alTransID)	
			Case 'SITE'
				liRC = iu_nvo_comcast.uf_missing_from_site(asProject, asOrderID, alTransID)
			Case 'DUPE'
				liRC = iu_nvo_comcast.uf_dupe_record(asProject, asOrderID, alTransID)
			Case 'INSERT'
				liRC = iu_nvo_comcast.uf_insert_error(asProject, asOrderID, alTransID)
			Case 'SKU'
				liRC = iu_nvo_comcast.uf_missing_sku_in_im(asProject, asOrderID, alTransID)
			Case Else
				liRC = 99	  /* not being processed, delete record */
		End Choose
	Case Else /* not being processed, delete record */
		
		liRC = 99
	
End Choose
	

return liRC
end function

public function integer uf_goods_receipt_confirmation (string asproject, string asorderid, long aitransid, string astransparm);//Process a Good Receipts Transaction for the proper project
Integer	liRC
String	lsOrdType, lsWarehouseType, lsWH, ls_om_conf_type, ls_wh_code, ls_om_enabled
Long ll_edi_batch_seq_no

//We need the order type to determine supplier order vs Return or Transfer (MM)
//TAM Get EDI_Batch_seq_id to determine if electronic order
Select Ord_type, EDI_Batch_Seq_No, OM_Confirmation_Type, wh_code  
into :lsOrdtype, :ll_edi_batch_seq_no, :ls_om_conf_type, :ls_wh_code
From Receive_master with(nolock)
Where ro_no = :asOrderID
using sqlca;

//07-Sep-2017 :Madhu Added PINT-861 - Get WH Level OM Ind
select OM_Enabled_Ind into :ls_om_enabled 
from Warehouse with(nolock)  Where wh_code= :ls_wh_code
using sqlca;

If IsNull(ls_om_conf_type) then ls_om_conf_type ='N' //If OM_Conf_Type= null, set to N.

Choose Case Upper(asproject)		
	
	//TAM added AMS-MUSER
	Case 'AMS-MUSER'
		If Not isvalid(iu_nvo_ams_muser) Then
			iu_nvo_ams_muser = Create u_nvo_edi_confirmations_ams_muser
		End If
		
		//Either process as a normal order or a return order (return from Customer)
		If lsOrdtype = 'X' Then /* a return*/
			//liRC = iu_nvo_ams_muser.uf_rt(asProject, asOrderID) //17-Apr-2014 :Madhu- commented to avoid generate duplicate MarcGT
		Else
			liRC = iu_nvo_ams_muser.uf_gr(asProject, asOrderID)
		End If
	//Jxlim 08/14/2012 Good receipt confirmation is GT not GR and it is done on Marc_GT call		
	//Jxlim 07/24/2012 CR12 Added 3 interfaces for PHYSIO-XD and PHYSIO-MAA mimic AMS-MUSER
	Case 'PHYSIO-XD'
		If Not isvalid(iu_nvo_physio_maa) Then
			iu_nvo_physio_maa = Create u_nvo_edi_confirmations_physio_maa
		End If
		
		//Either process as a normal order or a return order (return from Customer)
		If lsOrdtype = 'X' Then /* a return*/
			//liRC = iu_nvo_physio_maa.uf_rt(asProject, asOrderID) //17-Apr-2014 :Madhu- commented to avoid generate duplicate MarcGT
		Else
			liRC = iu_nvo_physio_maa.uf_gr(asProject, asOrderID)
		End If
		
	Case  'PHYSIO-MAA'
		If Not isvalid(iu_nvo_physio_maa) Then
			iu_nvo_physio_maa = Create u_nvo_edi_confirmations_physio_maa
		End If
		
		//Either process as a normal order or a return order (return from Customer)
		If lsOrdtype = 'X' Then /* a return*/
			//liRC = iu_nvo_physio_maa.uf_rt(asProject, asOrderID) //17-Apr-2014 :Madhu- commented to avoid generate duplicate MarcGT
		Else
			liRC = iu_nvo_physio_maa.uf_gr(asProject, asOrderID)
		End If	
	
		
	Case 'PHXBRANDS' /* Phoenix Brands*/
		
		If Not isvalid(iu_nvo_Phoenix) Then
			iu_nvo_Phoenix = Create u_nvo_edi_confirmations_Phoenix
		End If
		
		//Either process as a normal order or a return order (return from Customer)
		If lsOrdtype = 'X' Then /* a return*/
			liRC = iu_nvo_phoenix.uf_rt(asProject, asOrderID)
		ElseIf lsOrdtype = 'T' Then /* Transfer (IN)*/
			liRC = iu_nvo_phoenix.uf_transfer_IN(asProject, asOrderID)
		Else
			liRC = iu_nvo_phoenix.uf_gr(asProject, asOrderID)
		End If	
				
			
	// TAM 07/04
	Case 'LOGITECH'
	
		If Not isvalid(iu_nvo_logitech) Then
			iu_nvo_Logitech = Create u_nvo_edi_confirmations_logitech
		End If
		
		liRC = iu_nvo_Logitech.uf_gr(asProject, asOrderID)	
			
	Case 'PANDORA'
		
		If Not isvalid(iu_nvo_pandora) Then
			iu_nvo_pandora = Create u_nvo_edi_confirmations_pandora
		End If		

		//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
		IF upper(lsOrdtype) ='C' Then
			liRC = iu_nvo_pandora.uf_process_om_cc_inbound_order( asProject, asOrderID, aitransid ) //write 947 Adjustment Record
	
		//07-JULY-2017 :Madhu -Added for PINT -861 - START
		elseIF  ((upper(ls_om_conf_type) = 'E' )  OR (upper(ls_om_conf_type) <> 'R' and upper(ls_om_enabled) ='Y')) Then
			liRC = iu_nvo_pandora.uf_process_gr_om(asProject, asOrderID, aitransid,astransparm, 'I') //Insert
			If liRC =0 Then liRC = iu_nvo_pandora.uf_process_gr_om(asProject, asOrderID, aitransid,astransparm, 'U') //Update
		else
			liRC = iu_nvo_pandora.uf_gr_rose(asProject, asOrderID, astransparm)
		End If
		//07-JULY-2017 :Madhu -Added for PINT -861 - END
		
	Case 'LMC'
		
		If Not isvalid(iu_nvo_LMC) Then
			iu_nvo_LMC = Create u_nvo_edi_confirmations_LMC
		End If		
		liRC = iu_nvo_LMC.uf_gr(asProject, asOrderID)
		
	Case 'PHILIPS-SG'
		
		If Not isvalid(iu_nvo_philips) Then
			iu_nvo_philips = Create u_nvo_edi_confirmations_philips
		End If		
		
		//Either process as a normal order or a return order (return from Customer)
		If lsOrdtype = 'X' Then /* a return*/
			liRC = iu_nvo_philips.uf_rt(asProject, asOrderID)
		Else
			liRC = iu_nvo_philips.uf_gr(asProject, asOrderID)
		End If

//TAM - 2019/01/30 - S28686 - Added PHILIPSCLS	
	Case 'PHILIPSCLS'
		
		If Not isvalid(iu_nvo_philipscls) Then
			iu_nvo_philipscls = Create u_nvo_edi_confirmations_philipscls
		End If		
		
		liRC = iu_nvo_philipscls.uf_gr(asProject, asOrderID)

		
    Case  'RIVERBED'  //TAM 2011/09/21 Added riverbed      
                                
		  If Not isvalid(iu_edi_confirmations_riverbed) Then
			iu_edi_confirmations_riverbed = Create u_nvo_edi_confirmations_riverbed
		  End If                    
								
		  liRC = iu_edi_confirmations_riverbed.uf_gr(asProject, asOrderID)
		
	Case 'BOSCH' // TAM2015/01 Bosch changed to not send 'M'anual orders types
		

		IF lsOrdtype = 'M' THEN	return 0	
		If Not isvalid(iu_edi_confirmations_baseline_unicode) Then
				iu_edi_confirmations_baseline_unicode = Create u_nvo_edi_confirmations_baseline_unicode
		End If		
			
		liRC = iu_edi_confirmations_baseline_unicode.uf_gr(asProject, asOrderID)		

		
	Case  'KARCHER'//TAM 2012/07 Added Karcher// TAM2014/09 Added Bosch
		
			If Not isvalid(iu_edi_confirmations_baseline_unicode) Then
				iu_edi_confirmations_baseline_unicode = Create u_nvo_edi_confirmations_baseline_unicode
			End If		
			
			liRC = iu_edi_confirmations_baseline_unicode.uf_gr(asProject, asOrderID)		

		
	Case  'KLONELAB' //MEA 8/12 Added KloneLab
		
			If Not isvalid(iu_nvo_klonelab) Then
				iu_nvo_klonelab = Create u_nvo_edi_confirmations_klonelab
			End If		
			
			liRC = iu_nvo_klonelab.uf_gr(asProject, asOrderID)			
		
		
		
	Case 'PHILIPS-TH'
		
		If Not isvalid(iu_nvo_philips_th) Then
			iu_nvo_philips_th = Create u_nvo_edi_confirmations_philips_th
		End If		
		
		//Either process as a normal order or a return order (return from Customer)
		If lsOrdtype = 'X' Then /* a return*/
			liRC = iu_nvo_philips_th.uf_rt(asProject, asOrderID)
		Else
			IF lsOrdtype <> 'I' THEN		//10/11 - MEA Added to not send GR for Ord Type I
				liRC = iu_nvo_philips_th.uf_gr(asProject, asOrderID)
			END IF
		End If	

//TAM - 2019/01/30 - S28686 - Added PHILIPSCLS	
	Case 'PHILIPSCLS	'
		
		If Not isvalid(iu_nvo_philipscls) Then
			iu_nvo_philipscls = Create u_nvo_edi_confirmations_philipscls
		End If		
		
		liRC = iu_nvo_philipscls.uf_gr(asProject, asOrderID)


	Case 'TPV'
		
		If Not isvalid(iu_nvo_tpv) Then
			iu_nvo_tpv = Create u_nvo_edi_confirmations_tpv
		End If		
		
		//Either process as a normal order or a return order (return from Customer)
		If lsOrdtype = 'X' Then /* a return*/
			liRC = iu_nvo_tpv.uf_rt(asProject, asOrderID)
		Else
			liRC = iu_nvo_tpv.uf_gr(asProject, asOrderID)
		End If
					
	Case 'FUNAI'
		
		If Not isvalid(iu_nvo_funai) Then
			iu_nvo_funai = Create u_nvo_edi_confirmations_funai
		End If		
		
		//Either process as a normal order or a return order (return from Customer)
		If lsOrdtype = 'X' Then /* a return*/
			liRC = iu_nvo_funai.uf_rt(asProject, asOrderID)
		Else
			liRC = iu_nvo_funai.uf_gr(asProject, asOrderID)
		End If
	
	Case 'GIBSON'
		
		If Not isvalid(iu_nvo_gibson) Then
			iu_nvo_gibson = Create u_nvo_edi_confirmations_gibson
		End If		
		
		//Either process as a normal order or a return order (return from Customer)
		If lsOrdtype = 'X' Then /* a return*/
			liRC = iu_nvo_gibson.uf_rt(asProject, asOrderID)
		Else
			liRC = iu_nvo_gibson.uf_gr(asProject, asOrderID)
		End If
	
	Case  'FRIEDRICH' //TAM 2013/10 Added Friedrich
		
			If Not isvalid(iu_edi_confirmations_baseline_unicode) Then
				iu_edi_confirmations_baseline_unicode = Create u_nvo_edi_confirmations_baseline_unicode
			End If		
			
			liRC = iu_edi_confirmations_baseline_unicode.uf_gr(asProject, asOrderID)		

		
	Case  'PUMA' //TAM 2013/10 Added PUMA
		
			If Not isvalid(iu_nvo_puma) Then
				iu_nvo_puma = Create u_nvo_edi_confirmations_puma
			End If		
			
			liRC = iu_nvo_puma.uf_gr(asProject, asOrderID)		

	Case 'GARMIN'  //Jxlim 04/30/2014
		
		If Not isvalid(iu_nvo_Garmin) Then
			iu_nvo_Garmin = Create u_nvo_edi_confirmations_Garmin
		End If
		
		//Garmin treated Return as regular receipt (send GR instead of RT)
		//Either process as a normal order or a return order (return from Customer)
		liRC = iu_nvo_garmin.uf_gr(asProject, asOrderID)
		
	Case 'HONDA-TH'
	
		If Not isvalid(iu_nvo_honda) Then
			iu_nvo_honda = Create u_nvo_edi_confirmations_honda_new
		End If
		
		
		// Do not send if order type is a transfer
		
		If lsOrdType <> 'T' and lsOrdType <> 'Z'  and  lsOrdType <> 'H'  Then /*Skip Transfers*/
			liRC = iu_nvo_Honda.uf_gr(asProject, asOrderID)
		End IF
		
	Case  'METRO' //GailM 11/12/2014 Added Metro
		
			If Not isvalid(iu_nvo_metro) Then
				iu_nvo_metro = Create u_nvo_edi_confirmations_metro
			End If		
			
			liRC = iu_nvo_metro.uf_gr(asProject, asOrderID)		

	Case  'NYX' //GailM 05/32/2015 Added NYX
		
			If Not isvalid(iu_nvo_nyx) Then
				iu_nvo_nyx = Create u_nvo_edi_confirmations_nyx
			End If		
			
			liRC = iu_nvo_nyx.uf_gr(asProject, asOrderID)		

	Case  'ASPEN'//TAM 2015/08 Added ASPEN
		
			If Not isvalid(iu_nvo_aspen) Then
				iu_nvo_aspen = Create u_nvo_edi_confirmations_aspen
			End If		
			
			liRC = iu_nvo_aspen.uf_gr(asProject, asOrderID)		

	Case  'H2O' /* 01/16 - PCONKL*/
		
			If Not isvalid(iu_nvo_h2o) Then
				iu_nvo_h2o = Create u_nvo_edi_confirmations_h2o
			End If		
			
			liRC = iu_nvo_h2o.uf_gr(asProject, asOrderID)		
			
	Case  'FABER-CAST' /* 06/18 - GailM*/
		
			If Not isvalid(iu_nvo_fabercast) Then
				iu_nvo_fabercast = Create u_nvo_edi_confirmations_fabercast
			End If		
			
			liRC = iu_nvo_fabercast.uf_gr(asProject, asOrderID)		
			
	Case  'KENDO' /* 04/16 - PCONKL*/
		
			If Not isvalid(iu_nvo_kendo) Then
				iu_nvo_kendo = Create u_nvo_edi_confirmations_kendo
			End If		
			
			liRC = iu_nvo_kendo.uf_gr(asProject, asOrderID)		
	
	Case  'WS-PR' /* 02/2016 -TAM*/ //17-Mar-2017 :Madhu -SIMSPEVS-516 - Enable the functionality
		
			If Not isvalid(iu_nvo_ws) Then
				iu_nvo_WS = Create u_nvo_edi_confirmations_ws
			End If		
			
			liRC = iu_nvo_ws.uf_gr(asProject, asOrderID)		
	
	//2018/01 :TAM -Added for REMA - START
	Case 'REMA' 
		
		If Not isvalid(iu_nvo_rema) Then
			iu_nvo_rema = Create u_nvo_edi_confirmations_rema
		End If		
			liRC = iu_nvo_rema.uf_process_gr_om(asProject, asOrderID, aitransid,astransparm, 'I') //Insert
			If liRC =0 Then liRC = iu_nvo_rema.uf_process_gr_om(asProject, asOrderID, aitransid,astransparm, 'U') //Update
		//2018/01 :TAM -Added for REMA - END
		
	Case Else /* not being processed, delete record */
		
		liRC = 99
		
End Choose


Return liRC

end function

public function integer uf_goods_issue_confirmation (string asproject, string asdono, long aitransid, string astransparm, datetime dtrecordcreatedate); 
//Process a Good Issue confirmation Transaction for the proper project
Integer	liRC
String	lsOrdType, lsWarehouseType, lsWH, lsdono, ls_OM_Conf_Type, ls_wh_code, ls_om_enabled
DateTime ldtCompDate

//Select do_no Into :lsdono
//From Delivery_master
//Where project_id =:asproject and  Consolidation_no = :asDoNo;  //Jxlim 08/01/2013 asDono this ship_id for Ariens from Batch_transaction

Select Trans_parm, Trans_Complete_Date Into :lsdono, :ldtCompDate
From Batch_transaction
Where Trans_id = :aitransid and  project_id =:asproject; //Jxlim 08/01/2013 asDono this ship_id for Ariens from Batch_transaction

//We need the order type to determine Sale vs Transfer, etc.
//01-Sep-2017 :Madhu - Added to set DoNo
If (isnull(lsDoNo) or lsDoNo ='') then lsDoNo = asdono

Select Ord_type, OM_Confirmation_type, wh_code Into :lsOrdtype, :ls_OM_Conf_Type, :ls_wh_code
From Delivery_master with(nolock)
Where do_no = :lsDoNo;


//13-Sep-2017 :Madhu Added PINT-861 - Get WH Level OM Ind
select OM_Enabled_Ind into :ls_om_enabled 
from Warehouse with(nolock)  Where wh_code= :ls_wh_code;

If IsNull(ls_OM_Conf_Type) then ls_OM_Conf_Type ='N' //If OM_Conf_Type= null, set to N.

////Jxlim 07/30/2013 Get shipId (consolidation_no)
//String lsShipID
//Select Consolidation_no Into :lsshipID
//From Delivery_master
//Where do_no = :asDoNo;

Choose Case Upper(asproject)
	
	Case 'PHXBRANDS'
	
		If Not isvalid(iu_nvo_Phoenix) Then
			iu_nvo_Phoenix = Create u_nvo_edi_confirmations_Phoenix
		End If
		
		//If a transfer, we're sending a MM
		// 03/07 - PCONKL - also for type 'Z'
//		If lsOrdType = 'T' or lsOrdType = 'Z' Then
//			liRC = iu_nvo_Phoenix.uf_transfer_Out(asProject, asDONO)
//		Else
//			liRC = iu_nvo_PhoenixasProject, asDONO)
//		End IF
		
		//05/08 - PCONKL - Always sending GI to LMS and 947 to JVH if Transfer
		
		If lsOrdType = 'T' or lsOrdType = 'Z' Then /*Transfer to JVH*/
			liRC = iu_nvo_Phoenix.uf_transfer_Out(asProject, asDONO)
		End IF
		
		//GI to LMS for All
		liRC = iu_nvo_Phoenix.uf_gi(asProject, asDONO)
	
	Case 'HILLMAN'
	
		If Not isvalid(iu_nvo_hillman) Then
			iu_nvo_hillman = Create u_nvo_edi_confirmations_hillman
		End If
		
		liRC = iu_nvo_hillman.uf_gi(asProject, asDONO)		

		
	//TAM 07/04
	Case 'LOGITECH'
	
		If Not isvalid(iu_nvo_Logitech) Then
			iu_nvo_Logitech = Create u_nvo_edi_confirmations_Logitech
		End If
		
		liRC = iu_nvo_logitech.uf_gi(asProject, asDONO)	


// TAM 09/14/2006
	Case 'BLUECOAT'
	
		If Not isvalid(iu_nvo_bluecoat) Then
			iu_nvo_bluecoat = Create u_nvo_edi_confirmations_bluecoat
		End If
		
		liRC = iu_nvo_bluecoat.uf_gi(asProject, asDONO)	
			
//	Case 'MAQUET'
//		// dts 10/08 - not sending transactions for cross-dock wh (need to add field to wh table to enable/disable transactions)
//		Select wh_code into :lsWH
//		From  Delivery_Master where do_no = :asDONO;
//		
//		/*  dts 10/14/08 - Not sending for orders of type 'N - NO SAP' or 'Z - Warehouse Transfer'
//		    ...eventually will add field to delivery_order_type that indicates whether or not interfaces are sent... */
//		if lsWH = 'MAQ-CROSS' or lsOrdType = 'N' or lsOrdType = 'Z' then
//			//don't create transaction
//			//return 0
//		else
//			If Not isvalid(iu_nvo_maquet) Then
//				iu_nvo_maquet = Create u_nvo_edi_confirmations_maquet
//			End If
//			
//			liRC = iu_nvo_maquet.uf_gi_lms(asProject, asDONO, 'GI')	/*LMS GI */
//		end if
			
	Case 'PANDORA'
	
		If Not isvalid(iu_nvo_Pandora) Then
			iu_nvo_pandora = Create u_nvo_edi_confirmations_pandora
		End If
		
		// 07/09 - PCONKL - Seperate function (email) for Cityblock
		If (lsOrdType = 'C'  and upper(ls_OM_Conf_Type) <> 'E') Then
			liRC = iu_nvo_pandora.uf_gi_cityblock(asProject, asDONO)
			
		elseIf ((upper(ls_om_conf_type) = 'E' )  OR (upper(ls_om_conf_type) <> 'R' and upper(ls_om_enabled) ='Y')) Then //24-JUNE-2017 :Madhu PINT-945 OB Order Confirmation
			//06-Dec-2017 :Madhu - Don't Re-trigger to OM, if GI file already have Trans Complete Date
			If IsNull(IsDate(string(Date(ldtCompDate)))) Then 	liRC = iu_nvo_pandora.uf_process_gi_om(asProject, asDONO, aitransid, astransparm, dtrecordcreatedate )
		Else
	//		TAM 2009/06/16 RosettaNet
	//		liRC = iu_nvo_pandora.uf_gi(asProject, asDONO)
			//TimA 04/24/14 Pandora issue #36 Re-Confirm by line numbers.  Adding astransparm.
			//TimA 10/15/14 Pandora issue #903 Passing the Record_Create_Date for delaying the GIR processing
			liRC = iu_nvo_pandora.uf_gi_rose(asProject, asDONO, astransparm, dtrecordcreatedate )
			
		End If
			
	Case 'PHILIPS-SG'
	
		If Not isvalid(iu_nvo_philips) Then
			iu_nvo_philips = Create u_nvo_edi_confirmations_Philips
		End If
		
		liRC = iu_nvo_philips.uf_gi(asProject, asDONO)
		
	Case 'PHILIPSCLS'
	
		If Not isvalid(iu_nvo_philipscls) Then
			iu_nvo_philipscls = Create u_nvo_edi_confirmations_PhilipsCLS
		End If
		
		liRC = iu_nvo_philipscls.uf_gi(asProject, asDONO)
		
// TAM 11/11/2009
	Case 'NYCSP'
	
		//TAM = 2013/02/27  - Skip Warehouse Transfers
		If lsOrdType  <>  'Z' Then
			If Not isvalid(iu_nvo_nycsp) Then
				iu_nvo_nycsp = Create u_nvo_edi_confirmations_nycsp
			End If
		
			liRC = iu_nvo_nycsp.uf_gi(asProject, asDONO, 'GI')	/*LMS GI */
		End If

			
	Case 'CHINASIMS' , 'BABYCARE', 'GEISTLICH', 'KARCHER' //MSTUART 080811 added babycare //BCR 23-NOV-2011...added Geistlich // TAM 2012/07 added Karcher  

		If Not isvalid(iu_edi_confirmations_baseline_unicode) Then
			iu_edi_confirmations_baseline_unicode = Create u_nvo_edi_confirmations_baseline_unicode
		End If		

		liRC = iu_edi_confirmations_baseline_unicode.uf_gi(asProject, asDONO, 'GI')
		
	
		if asproject = 'BABYCARE' and  lsOrdtype = 'E'  then

			If Not isvalid(iu_nvo_babycare) Then
				iu_nvo_babycare = Create u_nvo_edi_confirmations_babycare
			End If		
			
			iu_nvo_babycare.uf_delivery_eo(asProject, asDONO)
			
			//liRC =
			
		end if
		
	Case 'KLONELAB'   //MEA 8/12 - Added KloneLab

		If Not isvalid(iu_nvo_klonelab) Then
			iu_nvo_klonelab = Create u_nvo_edi_confirmations_klonelab
		End If		

		liRC = iu_nvo_klonelab.uf_gi(asProject, asDONO, 'GI')
	


	Case 'PHILIPS-TH'
	
		If Not isvalid(iu_nvo_philips_th) Then
			iu_nvo_philips_th = Create u_nvo_edi_confirmations_philips_th
		End If
		
		If lsOrdtype <> 'I' Then		//10/11 - MEA Added to not send GI for Ord Type I

			liRC = iu_nvo_philips_th.uf_gi(asProject, asDONO)		
			
		End If

		
// 05/13 - PCONKL - Starbucks does not send a file at confirmation - on a timed basis only
//	Case 'STBTH'   //GXMOR 4/19/2013 - Added Starbucks-TH
//
//		If Not isvalid(iu_nvo_stbth) Then
//			iu_nvo_stbth = Create u_nvo_edi_confirmations_starbucks-th
//		End If		
//
//		liRC = iu_nvo_stbth.uf_gi()
	
    Case 'RIVERBED' //TAM 20111031 added Riverbed

		  If Not isvalid(iu_edi_confirmations_riverbed) Then
				iu_edi_confirmations_riverbed = Create u_nvo_edi_confirmations_riverbed
		  End If                    

		  liRC = iu_edi_confirmations_riverbed.uf_gi(asProject, asDONO)
							  
 
	Case 'TPV' /* 01/13 - PCONKL */
	
		If Not isvalid(iu_nvo_tpv) Then
			iu_nvo_tpv = Create u_nvo_edi_confirmations_tpv
		End If
		liRC = iu_nvo_tpv.uf_gi(asProject, asDONO)
		
		
		
	Case 'PHYSIO-MAA', 'PHYSIO-XD'   /* 02/20 - MEA */

		If Not isvalid(iu_nvo_physio_maa) Then
			iu_nvo_physio_maa = Create u_nvo_edi_confirmations_physio_maa
		End If
		
		liRC = 	iu_nvo_physio_maa.uf_gi(asProject, asDONO)
		
	Case 'NYX'   /* 2014/03 TAM -- 2015/05 gwn Turned on for NYX L'Oreal*/

		If Not isvalid(iu_nvo_nyx) Then
			iu_nvo_nyx = Create u_nvo_edi_confirmations_nyx
		End If
		
		liRC = 	iu_nvo_nyx.uf_gi(asProject, asDONO)

//TimA 05/26/15 Removed per Gail to get the build done.
//	Case 'LOREAL'   /*  2015/05 gwn  NYX L'Oreal*/
//
//		If Not isvalid(iu_nvo_loreal) Then
//			iu_nvo_loreal = Create u_nvo_edi_confirmations_loreal
//		End If
//		
//		liRC = 	iu_nvo_loreal.uf_gi(asProject, asDONO)
				
	Case 'KINDERDIJK'  /*04/28/2013 Jxlim */

		If Not isvalid(iu_nvo_kinderdijk) Then
			iu_nvo_kinderdijk = Create u_nvo_edi_confirmations_kinderdijk
		End If
		
		liRC = 	iu_nvo_kinderdijk.uf_gi(asProject, asDONO)
		
	Case 'FUNAI' /*6/3 - MEA */
	
		If Not isvalid(iu_nvo_funai) Then
			iu_nvo_funai = Create u_nvo_edi_confirmations_funai
		End If
		liRC = iu_nvo_funai.uf_gi(asProject, asDONO)
	
	Case 'GIBSON' /*1/2015 - TAM */
	
		If Not isvalid(iu_nvo_gibson) Then
			iu_nvo_gibson = Create u_nvo_edi_confirmations_gibson
		End If
		liRC = iu_nvo_gibson.uf_gi(asProject, asDONO)
	
//	Case 'ARIENS'   //dts - 7/5/2013 
//
//		  If Not isvalid(iu_nvo_ariens) Then
//			iu_nvo_ariens = Create u_nvo_edi_confirmations_ariens
//		  End If                    
//
//		  //liRC = iu_nvo_ariens.uf_gi(asProject, asDONO, 'GI')
//		  //using this as test bed to call uf_ship_confirm (asDONO is really ship ID)
//		  //Jxlim 08/01/2013 Ariens; asDono is the shipID
//		  liRC = iu_nvo_ariens.uf_Ship_Confirm(asProject, asDONO, aitransid)

	Case 'FRIEDRICH'   /* TAM - 2013/10 - Addred Friedrich */

		If Not isvalid(iu_nvo_friedrich) Then
			iu_nvo_friedrich = Create u_nvo_edi_confirmations_friedrich
		End If
		
		liRC = 	iu_nvo_friedrich.uf_gi(asProject, asDONO)
		
	Case 'PUMA'   /* TAM - 2013/10 - Addred Puma */

		If Not isvalid(iu_nvo_puma) Then
			iu_nvo_puma = Create u_nvo_edi_confirmations_puma
		End If
		
		liRC = 	iu_nvo_puma.uf_gi(asProject, asDONO)
		
	Case 'GARMIN'  //Jxlim 04/30/2014
	
		If Not isvalid(iu_nvo_Garmin) Then
			iu_nvo_Garmin = Create u_nvo_edi_confirmations_garmin
		End If		
		
		//GI to ICC
		liRC = iu_nvo_Garmin.uf_gi(asProject, asDONO)
		
	Case 'ANKI'  //Jxlim 09/05/2014
	
		If Not isvalid(iu_nvo_anki) Then
			iu_nvo_anki = Create u_nvo_edi_confirmations_anki
		End If		
		
		//GI to ICC
		liRC = iu_nvo_anki.uf_gi(asProject, asDONO)

	Case 'HONDA-TH'
	
		If Not isvalid(iu_nvo_honda) Then
			iu_nvo_honda = Create u_nvo_edi_confirmations_honda_new
		End If
		
		
		// Do not send if order type is a transfer
		
		If lsOrdType <> 'T' and lsOrdType <> 'Z' and lsOrdType <> 'H'   Then /*Skip Transfers*/
			liRC = iu_nvo_Honda.uf_gi(asProject, asDONO)
		End IF
		
	Case 'METRO'  //GWM 2014/11 Add Metro
	
		If Not isvalid(iu_nvo_metro) Then
			iu_nvo_metro = Create u_nvo_edi_confirmations_metro
		End If		
		
		//GI to ICC
		liRC = iu_nvo_metro.uf_gi(asProject, asDONO)

	Case 'ASPEN'
	
		If Not isvalid(iu_nvo_aspen) Then
			iu_nvo_aspen = Create u_nvo_edi_confirmations_aspen
		End If
		
		liRC = iu_nvo_aspen.uf_gi(asProject, asDONO, 'GI')
		
	Case 'H2O'  //01/16 - PCONKL
	
		If Not isvalid(iu_nvo_h2o) Then
			iu_nvo_h2o = Create u_nvo_edi_confirmations_h2o
		End If		
		
		//GI to ICC
		liRC = iu_nvo_h2o.uf_gi(asProject, asDONO)
		
	Case 'FABER-CAST'  //06/18 - GailM
	
		If Not isvalid(iu_nvo_fabercast) Then
			iu_nvo_fabercast = Create u_nvo_edi_confirmations_fabercast
		End If		
		
		//GI to ICC
		liRC = iu_nvo_fabercast.uf_gi(asProject, asDONO, 'GI')
		
	Case 'KENDO'  //04/16 - PCONKL
	
		If Not isvalid(iu_nvo_kendo) Then
			iu_nvo_kendo = Create u_nvo_edi_confirmations_kendo
		End If		
		
		//GI to ICC
		liRC = iu_nvo_kendo.uf_gi(asProject, asDONO)
		
	Case  'WS-PR' /* 02/2016 -TAM*/
		
		If Not isvalid(iu_nvo_ws) Then
			iu_nvo_WS = Create u_nvo_edi_confirmations_ws
		End If		
			
		liRC = iu_nvo_ws.uf_gi(asProject, asDONO)		

	//02-FEB-2018 :Madhu S15431- REMA 945 Ship confirmation
	Case  'REMA' 
	
		If Not isvalid(iu_nvo_rema) Then
			iu_nvo_rema = Create u_nvo_edi_confirmations_rema
		End If		
			
		liRC = iu_nvo_rema.uf_process_gi_om(asProject, asDONO, aitransid, astransparm)

		// TAM 2018/07/03 S20885 - also send a flatfile 
		If liRC >= 0 Then 
			liRC = iu_nvo_rema.uf_gi(asProject, asDONO)
		End If

	
	Case 'COTY'  //GWM 2018/04 Add Coty
	
		If Not isvalid(iu_nvo_coty) Then
			iu_nvo_coty = Create u_nvo_edi_confirmations_coty
		End If		
		
		//GI to ICC
		liRC = iu_nvo_coty.uf_gi(asProject, asDONO)
	
	//16-Jan-2019 :Madhu S28196 Bosch Post GoodsIssueRequest to Websphere.
	Case 'BOSCH'
		If Not isvalid(iu_nvo_bosch) Then iu_nvo_bosch = Create u_nvo_edi_confirmations_bosch
		liRC = iu_nvo_bosch.uf_gi(asproject, aitransid)

	Case Else /* not being processed, delete record */
		
		liRC = 99
		
End Choose


Return liRC

end function

public function integer uf_shipment_confirmation (string asproject, string asdono, long aitransid, string astransparm, datetime dtrecordcreatedate); 
//Process a Shipment confirmation Transaction for the proper project
Integer	liRC
String	lsOrdType, lsWarehouseType, lsWH, lsdono


Select Trans_parm Into :lsdono		
From Batch_transaction
Where Trans_id = :aitransid and  project_id =:asproject; //Jxlim 08/01/2013 asDono this ship_id for Ariens from Batch_transaction

//We need the order type to determine Sale vs Transfer, etc.
Select Ord_type Into :lsOrdtype
From Delivery_master
Where do_no = :lsDoNo;

////Jxlim 07/30/2013 Get shipId (consolidation_no)
//String lsShipID
//Select Consolidation_no Into :lsshipID
//From Delivery_master
//Where do_no = :asDoNo;

Choose Case Upper(asproject)
	
		
	Case 'GARMIN'  //Jxlim 04/30/2014
	
		If Not isvalid(iu_nvo_Garmin) Then
			iu_nvo_Garmin = Create u_nvo_edi_confirmations_garmin
		End If		
		
		//GI to ICC
		liRC = iu_nvo_Garmin.uf_sc(asProject, asDONO)
		
	
	Case Else /* not being processed, delete record */
		
		liRC = 99
		
End Choose


Return liRC

end function

public function integer uf_commercial_invoice_confirmation (string asproject, string asdono, long aitransid, string astransparm, datetime dtrecordcreatedate); 
//Send a file for communicating Commercial Invoice data
Integer	liRC
String lsOrdtype, ls_OM_Conf_Type, ls_wh_code, ls_om_enabled

//07-SEP-2017 :Madhu PINT-945 - CI -START
Select Ord_type, OM_Confirmation_type, wh_code Into :lsOrdtype, :ls_OM_Conf_Type, :ls_wh_code
From Delivery_Master with(nolock)
Where do_no = :asdono
using sqlca;
//07-SEP-2017 :Madhu PINT-945 - CI -END

//02-Feb-2018 :Madhu Added PINT-945 -CI - Get WH Level OM Ind
select OM_Enabled_Ind into :ls_om_enabled 
from Warehouse with(nolock)  Where wh_code= :ls_wh_code
using sqlca;

If IsNull(ls_OM_Conf_Type) then ls_OM_Conf_Type ='N' //If OM_Conf_Type= null, set to N.


Choose Case Upper(asproject)
			
	Case 'PANDORA'
		If Not isvalid(iu_nvo_pandora) Then
			iu_nvo_pandora = Create u_nvo_edi_confirmations_pandora
		End If
		
		//07-SEP-2017 :Madhu PINT-945 - CI - START
		If (upper(ls_OM_Conf_Type) ='E'  OR (upper(ls_om_conf_type) <> 'R' and upper(ls_om_enabled) ='Y')) Then
			liRC =  iu_nvo_pandora.uf_process_ci_om( asproject, asdono, aitransid, astransparm, dtrecordcreatedate)
		else
			liRC = iu_nvo_pandora.uf_ci(asProject, asDONO)	
		End If
		//07-SEP-2017 :Madhu PINT-945 - CI - END
	
	Case Else /* not being processed, delete record */
		liRC = 99
End Choose

Return liRC

end function

public function integer uf_delivery_void_confirmation (string asproject, string asdono, long altransid); 
//Process a Void confirmation Transaction for the proper project
Integer	liRC
String	lsOrdtype, ls_wh_code
long 	ll_change_req_nbr

//03-MAY-2018 :Madhu S18653 - Back/Duplicate Order Process  - START
Select Ord_type, OM_CHANGE_REQUEST_NBR, wh_code Into :lsOrdtype, :ll_change_req_nbr, :ls_wh_code
From Delivery_Master with(nolock)
Where Project_Id =:asproject and do_no = :asdono
using sqlca;

If IsNull(ll_change_req_nbr) then ll_change_req_nbr =0

//03-MAY-2018 :Madhu S18653 - Back/Duplicate Order Process  - END

Choose Case Upper(asproject)
		
	Case 'NIKE-SG', 'NIKE-MY'
	
		If Not isvalid(iu_edi_confirmations_nike) Then
			iu_edi_confirmations_nike = Create u_nvo_edi_confirmations_nike
		End If
		
		liRC = iu_edi_confirmations_nike.uf_void(asProject, asDONO)		
		
	Case 'REMA'
		
		IF ll_change_req_nbr > 0 THEN
			If Not isvalid(iu_nvo_rema) Then iu_nvo_rema = create u_nvo_edi_confirmations_rema
			liRC = iu_nvo_rema.uf_process_gi_void_om( asproject, asdono, altransid)
			
		ELSE
			liRC =99
		END IF
		
	//07-MAR-2019 :Madhu S29714 PhilipsBlueHeart Product Picked
	Case 'PHILIPSCLS'
	
	IF Not IsValid(iu_nvo_philipscls) Then
		iu_nvo_philipscls = create u_nvo_edi_confirmations_philipscls
	End IF
	
	liRC = iu_nvo_philipscls.uf_product_picked( asproject, asdono)
			
	Case Else /* not being processed, delete record */
		
		liRC = 99
		
End Choose


Return liRC


end function

public function integer uf_lwon (string asproject, string asloadid, long aitransid, string astransparm, datetime dtrecordcreatedate); 
//Process a Load Lock Transaction for the proper project
Integer	liRC


Choose Case Upper(asproject)
	
		
	Case 'PANDORA'  
	
		If Not isvalid(iu_nvo_pandora) Then
			iu_nvo_pandora = Create u_nvo_edi_confirmations_pandora
		End If		
		
		//LWON to ICC
		//05-FEB-2019 :Madhu DE8493 Added TransParam (Do_No)
		liRC = iu_nvo_pandora.uf_process_lwon(asProject, dtrecordcreatedate, asloadid, astransparm)
		
	
	Case Else /* not being processed, delete record */
		
		liRC = 99
		
End Choose


Return liRC

end function

public function integer uf_event_status (string asproject, string astranstype, string asdono, string astransparm);

//TAM 2019/02/28 S29919 -PhilipsCLS BlueHeart OutboundShipmentUpdateStatus
//send Delivery status file, if Delivery Date is sent in the interface file.
//Made this Generic Enough to use Trans Type 'ES' for future Status Files.  The Type of Status will be sent in the 'asTransParm'

Integer li_rc

CHOOSE CASE Upper(asproject)
	CASE 'PHILIPSCLS'
		IF Not IsValid(iu_nvo_philipscls) THEN  iu_nvo_philipscls = create u_nvo_edi_confirmations_philipscls
		li_rc = iu_nvo_philipscls.uf_event_status( asproject, asdono, astranstype, astransparm )
		
	CASE ELSE
		li_rc =99
END CHOOSE

Return li_rc
end function

public function integer uf_rd_sd_change_confirmation (string asproject, string astranstype, string asdono);//15-FEB-2019 :Madhu S29511 -PhilipsCLS BlueHeart OutboundDeliveryUpdateStatus
//send confirmation file, if Request Date /Schedule Date change.

Integer li_rc

CHOOSE CASE Upper(asproject)
	CASE 'PHILIPSCLS'
		IF Not IsValid(iu_nvo_philipscls) THEN  iu_nvo_philipscls = create u_nvo_edi_confirmations_philipscls
		li_rc = iu_nvo_philipscls.uf_rd_sd_change( asproject, asdono, astranstype )
		
	CASE ELSE
		li_rc =99
END CHOOSE

Return li_rc
end function

public function integer uf_receipt_void_confirmation (string asproject, string asorderid, long aitransid, string astransparm);//13-MAY-2019 :Madhu Goods Receipt Void Confirmation
int liRC

CHOOSE CASE upper(asproject)
	CASE 'PHILIPSCLS'
		IF not IsValid(iu_nvo_philipscls) THEN 
			iu_nvo_philipscls = create u_nvo_edi_confirmations_philipscls
		END IF
		
		liRC = iu_nvo_philipscls.uf_gr( asproject, asorderid)
		
END CHOOSE


Return liRC

end function

on u_nvo_edi_confirmations.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;

If isValid(iu_nvo_Phoenix) Then
	Destroy iu_nvo_Phoenix
End IF


		
If isValid(iu_nvo_hillman) Then
	Destroy iu_nvo_hillman
End IF

end event

