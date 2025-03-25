$PBExportHeader$w_import.srw
$PBExportComments$Import tab files for various files
forward
global type w_import from window
end type
type cb_convert from commandbutton within w_import
end type
type cb_option1 from commandbutton within w_import
end type
type cb_print from commandbutton within w_import
end type
type cb_archive from commandbutton within w_import
end type
type cb_help from commandbutton within w_import
end type
type cb_insert from commandbutton within w_import
end type
type cb_delete from commandbutton within w_import
end type
type st_validation from statictext within w_import
end type
type cb_cancel from commandbutton within w_import
end type
type cb_ok from commandbutton within w_import
end type
type cb_save from commandbutton within w_import
end type
type cb_validate from commandbutton within w_import
end type
type cb_import from commandbutton within w_import
end type
type dw_layout_list from datawindow within w_import
end type
end forward

global type w_import from window
integer x = 823
integer y = 360
integer width = 3799
integer height = 2164
boolean titlebar = true
string title = "Import"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_postopen ( )
event ue_set_dw ( )
event ue_import ( )
event ue_validate ( )
event ue_delete ( )
event ue_save ( )
event ue_help ( )
event ue_archive ( )
event ue_print ( )
event ue_save_server ( )
event ue_send_otm ( )
cb_convert cb_convert
cb_option1 cb_option1
cb_print cb_print
cb_archive cb_archive
cb_help cb_help
cb_insert cb_insert
cb_delete cb_delete
st_validation st_validation
cb_cancel cb_cancel
cb_ok cb_ok
cb_save cb_save
cb_validate cb_validate
cb_import cb_import
dw_layout_list dw_layout_list
end type
global w_import w_import

type prototypes
Function boolean MoveFile (ref string lpExistingFileName, ref string lpNewFileName ) LIBRARY "kernel32.dll" ALIAS FOR "MoveFileA;Ansi"
end prototypes

type variables
u_dw_import	dw_import
Boolean	ibCancel,ibValError,ibChanged, ibProcessOnServer
Long	ilCurrValRow, ilHelpTopicID, ilImportThreshhold
String	isHelpKeyword, &
			isImportFile,	&
			isLayout,		&
			isPath
			
// pvh - 12/05/06 - websphere - instance vars
boolean ibAMS
// pvh - 12/05/06 - websphere import
//
// Change UseWebsphere to true when activating App Server processing.
constant boolean UseWebsphere = true
inet	linit
u_nvo_websphere_post	iuoWebsphere

String is_delete_sku, is_delete_supp_cd	// TimA 01/14/13 OTM additions

Dec id_length_1, id_width_1, id_height_1, id_weight_1	// TimA 01/14/13 OTM additions

end variables

forward prototypes
public subroutine setams (boolean value)
public function boolean getams ()
public subroutine wf_set_otm_dims ()
public function boolean wf_otm_fields_modified ()
public function string wf_format_date (string asindate)
end prototypes

event ue_postopen();datawindowchild	ldwc

dw_layout_list.getChild('import_file',ldwc)
dw_layout_list.InsertRow(0)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project, 'IMPRT')

cb_validate.Enabled = False
cb_save.Enabled = False
cb_import.enabled = False
cb_delete.Enabled = False
cb_insert.Enabled = False
cb_Archive.Enabled = False
cb_Print.Enabled = False

dw_layout_list.Setfocus()

//Websphere objects
iuoWebsphere = CREATE u_nvo_websphere_post
linit = Create Inet
end event

event ue_set_dw();String	lslayout,	&
			lsTitle,		&
			lsModify
			
long ll_count
			
//Load the proper DW into the generic processor - storing in instance variable - some of the functions may need to refrence (ie Hahn Itemmaster)

isLayout = dw_layout_list.GetItemString(1,"import_file")

cb_option1.Visible = False
cb_option1.Enabled = False
cb_save.Enabled = False

cb_import.Enabled = True
cb_insert.Enabled = True
cb_delete.Enabled = True

ibProcessOnServer = False

ilImportThreshhold = 0

Choose case isLayout
		
	// Pandora Alternative Address
	Case "ALT_ADDRESS"
		// Create the Pandora Alternative Address Datawindow.
		dw_import = create u_dw_import_pandora_alt_address
		
	// pvh - 12/28/05
	Case "AMS" //hdc this is the string that identifies a crossdock import
		dw_import = create u_dw_import_ams
		ibProcessOnServer = True /* 03/07 - PCONKL -  Validate and Save on Websphere */
	Case "FedEx-Track" /* Saltillo - Update Delivery Packing with Fedex Tracking # */
		dw_import = Create u_dw_import_fedex_tracking
	Case "im-part" /* Saltillo - ItemMaster Part Insert/Update*/
		dw_import = Create u_dw_import_item_part
	Case "im-pack" /* Saltillo */
		dw_import = Create u_dw_import_item_package
	Case "im-acsku" /* Saltillo */
		dw_import = Create u_dw_import_item_acdelco
	Case "im-coty" /* COTY - Has SKU, Alt_SKU, DESCRIPTION, Supplier, COMMODITY, UF14(FRENCH DESC) */
		dw_import = Create u_dw_import_item_coty
	Case "im-weight" /* Saltillo */
		dw_import = Create u_dw_import_item_weight
	Case "im-price" /* Saltillo */
		dw_import = Create u_dw_import_item_price
	Case "po-coty" /* COTY Inbound Order (waiting for ICC to get going with interfaces) */
		dw_import = Create u_dw_import_po_coty
	Case "WS-PO"	/* TAM W&S 2011 - Wine and Spirit PO */ 
 		dw_import = Create u_dw_import_ws_po		
	Case "WS-SO"	/* TAM W&S 2011 - Wine and Spirit SO */ 
 		dw_import = Create u_dw_import_ws_so	
	Case "WS-SO-BMS"	/* TAM W&S 2011/04 - Wine and Spirit SO for Bacardi*/ 
 		dw_import = Create u_dw_import_ws_so_bms		
 	Case "dm-complete" /* COTY Mass completes */
		if gs_role = string(-1) or gs_role = string(0) or gs_role = string(1) then
			// dts - 05/16/08 - added Admins...
			dw_import = Create u_dw_import_coty_mass_completes
			ilImportThreshhold = 100 /*Limit to 100 records at a time*/
		else
			MessageBox("Not Authorized", "Not authorized to use this function.")
			Return
		end if
	Case "supplier" /* Saltillo */
		dw_import = Create u_dw_import_supplier
	Case "locations" /* Saltillo */
		dw_import = Create u_dw_import_locations
	case "customer" /* Saltillo */
		dw_import = Create u_dw_import_customer
	case "im-dimen" /* Saltillo */
		dw_import = Create u_dw_import_item_dimention
 	case "sal-pdc" /* Saltillo */
 		dw_import = Create u_dw_import_sal_pdc_orders	
 	case "Transfers" /* AMS-MUSER mass Stock Transfers (new warehouse locations) */
 		dw_import = Create u_dw_import_location_transfers
	// TAM 2009/05 Added Bluecoat Pallet Import
	Case "bluecoat_pallet"
		dw_import = Create u_dw_import_bluecoat_pallet_serial
	// TAM 2009/05 Added BOM Import
	Case "im-bom"
		dw_import = Create u_dw_import_item_bom
	Case "generic-SO" /* 08/12/04 - generic Sales Order*/
		dw_import = Create u_dw_import_server
		dw_import.dataobject = 'd_import_so'
		ibProcessOnServer = True /* 03/07 - PCONKL - Validate and Save on Websphere */
		ilImportThreshhold = 10000 /*Limit to 1000 records* - 06/13 - PCONKL - changed to 10,000 for Starbucks*/
	Case "3COM-IM" /* 07/07 - 3COM Item Master file*/
		dw_import = Create u_dw_import_server
		dw_import.dataobject = 'd_import_3com_itemmaster'
		ibProcessOnServer = True /*Validate and Save on Websphere */
		ilImportThreshhold = 10000 /*Limit to 10,000 records*/
	Case "im-full" /* 07/07 - Full Item Master file*/
		dw_import = Create u_dw_import_server
		dw_import.dataobject = 'd_import_full_itemmaster'
		ibProcessOnServer = True /*Validate and Save on Websphere */
		ilImportThreshhold = 10000 /*Limit to 10,000 records*/
	Case "stanley-po" /* 11/07 - Stanley PO File */
		dw_import = Create u_dw_import_server
		dw_import.dataobject = 'd_import_stanley_po'
		ibProcessOnServer = True /*Validate and Save on Websphere */
		ilImportThreshhold = 1000 /*Limit to 1000 records*/
	Case "powerwave-po" /* 12/07 - Powerwave PO File */
		dw_import = Create u_dw_import_server
		dw_import.dataobject = 'd_import_powerwave_po'
		ibProcessOnServer = True /*Validate and Save on Websphere */
		ilImportThreshhold = 1000 /*Limit to 1000 records*/
	Case "powerwave-ord-ship"		/* Shipment Status Update */
		dw_import = Create u_dw_import_powerwave_ord_ship_status	
	Case "diebold-po" /* 03/08 - Diebold PO File */
		dw_import = Create u_dw_import_server
		dw_import.dataobject = 'd_import_diebold_po'
		ibProcessOnServer = True /*Validate and Save on Websphere */
	Case "EUTUP"	/* 06/08 - EUT File */ 
 		dw_import = Create u_dw_import_eut_orders
	Case "RUN-WORLD-PO"	/* 07/08 - Runner's World File */ 
		dw_import = Create u_dw_import_server
		dw_import.dataobject = 'd_import_rw_po'
		ibProcessOnServer = True /*Validate and Save on Websphere */
		ilImportThreshhold = 1000 /*Limit to 1000 records*/
	Case "RUN-WORLD-DO"	/* 07/08 - Runner's World File */ 
 		dw_import = Create u_dw_import_rw_do		
	Case "diebold-hu"	/* 07/08 - Diebold Headsup file (release 2B PO's and WO's) */ 
		dw_import = Create u_dw_import_server
		dw_import.dataobject = 'd_import_diebold_headsup'
		ibProcessOnServer = True /*Validate and Save on Websphere */
		ilImportThreshhold = 1000 /*Limit to 1000 records*/
	Case "inbound_order"
		dw_import = Create u_dw_import_server
		if gs_project = "PHYSIO-MAA" then /* Physio Control */			
			 dw_import.dataobject = "d_import_physio-control"  //hdc 09272012
		else
			dw_import.dataobject = 'd_import_po'
		end if
		ibProcessOnServer = True /*Validate and Save on Websphere */
		if gs_project = 'PANDORA' THEN
			//ilImportThreshhold = 14000 /*Limit increased to 14000 for LPN project.*/
			ilImportThreshhold = 7000 /*Limit decreased to 7000 per Roy for LPN project.*/
		else
			ilImportThreshhold = 10000
		end if
	Case "BLUECOAT-PO"
		dw_import = Create u_dw_import_server
		dw_import.dataobject = 'd_import_bluecoat_po'
		ibProcessOnServer = True /*Validate and Save on Websphere */
		ilImportThreshhold = 1000 /*Limit to 1000 records*/		
	Case "pandora-cb-so"
		dw_import = Create u_dw_import_server
		dw_import.dataobject = 'd_import_pandora_cb_so'
		ibProcessOnServer = True /*Validate and Save on Websphere */
	Case "PRICE_DATA"
		dw_import = Create u_dw_import_server
		dw_import.dataobject = 'd_import_price_data'
		// ibProcessOnServer = True /*Validate and Save on Websphere */
	Case "mmd-po"
		dw_import = Create u_dw_import_server
		dw_import.dataobject = 'd_import_mmd_po'
		ibProcessOnServer = True /*Validate and Save on Websphere */
		ilImportThreshhold = 1000 /*Limit to 1000 records*/		
	Case "FINANCE_DATA"
		// 8/3/12 dts - controlling this from lookup table now
		//if gs_UserID = 'VEJONES' OR gs_UserID = 'DTS' then
		select count(*)
		into :ll_count
		from lookup_table
		where project_id = 'PANDORA'
		and code_type = 'IMPRT_FIN'
		and code_ID = :gs_UserID;
		
		if ll_count > 0 then
			dw_import = Create u_dw_import_pandora_finance_data
			dw_import.dataobject = 'd_import_pandora_finance_data'
			cb_import.Enabled   = True
			cb_insert.Enabled    =  FALSE
			cb_delete.Enabled   =  FALSE
			cb_validate.Enabled =  FALSE
		else
			messagebox ("Pandora Finance Data", "Not authorized to Import Finance Data.")
		end if
		
	Case "stock-adjustment" /* 03/10 - PCONKL - Import stock adjustments*/
		if gs_role = string(-1) or gs_role = string(0) or gs_role = string(1) then /* limited to Admin or Super*/
			dw_import = Create u_dw_import_server
			dw_import.dataobject = 'd_import_stock_adjustments'
			ibProcessOnServer = True /*Validate and Save on Websphere */
			ilImportThreshhold = 250 /*Limit to 250 records*/
		else
			MessageBox("Not Authorized", "Not authorized to use this function.")
			Return
		end if
	Case "phx-chep-inbound"	/* 04/19/10 -Jxlim - Added chep inbound-import for Phoenix brand */ 
 		dw_import = Create u_dw_import_phx_inbound_chep
		dw_import.dataobject = 'd_import_phx_inbound_chep'
	Case "phx-chep-outbnd"	/* 04/19/10 -Jxlim - Added chep outbound-import for Phoenix brand */ 
 		dw_import = Create u_dw_import_phx_outbound_chep	
		dw_import.dataobject = 'd_import_phx_outbound_chep'
	case "pulse-pull" /* 12/02 - Pconkl - Pulse Pull Order  - MEA Added 03/10 */
		dw_import = Create u_dw_pulse_import_pull
	Case "pulse-shlf" /* 12/02 - Pconkl - Pulse Shelf Life Update  - MEA Added 03/10 */
		dw_import = Create u_dw_pulse_import_shelflife
	Case "pulse-iotl" /* MEA - Used to do initial import from Pulse */
		dw_import = Create u_dw_import_pulse_inbound_order_transfer
		dw_import.dataobject = 'd_pulse_import_po'
		ibProcessOnServer = True /*Validate and Save on Websphere */
		ilImportThreshhold = 1000 /*Limit to 1000 records*/	
	Case "pulse-putaway"		// cawikholm 05/02/11 - Added Inbound Order Putaway Update - This layout was missing
		dw_import = Create u_dw_pulse_import_putaway_detail_update
		dw_import.dataobject = 'd_pulse_import_putaway_update'
	//Jxlim 03/01/2011 Added ItemMaster MIN/MAX Baseline initiated by Pandora
	Case "im-m/m"
		dw_import = Create u_dw_import_item_min_max
		dw_import.dataobject = 'd_import_itemaster_min_max'
	Case "update-order-ship" //MEA - 05/12 Added for Nike 
		dw_import = Create u_dw_import_update_nike_order	
	Case "Pandora Min-Max"  // ET3 - 05/12 Added for Pandora
		dw_import = Create u_dw_import_pandora_minmax

	Case "sn-import" //TimA 09/02/13
		dw_import = Create u_dw_import_pandora_serial_no

	Case "import-mrp" //MEA - 06/12 Added for Stryker
		dw_import = Create u_dw_import_stryker_mrp	
	
	//13-Dec-2013 :Madhu -Added -ItemMaster-PutawayStorageRule -START
	Case "im-storagerule"
		dw_import =Create u_dw_import_item_storage_rule
	//13-Dec-2013 :Madhu -Added -ItemMaster-PutawayStorageRule -END
	
	//18-Dec-2013 :Madhu -Added -Item -SerialPrefix -START
	Case "im-serialprefix"
		dw_import =Create u_dw_import_item_serial_prefix
	//18-Dec-2013 :Madhu -Added -Item -SerialPrefix -END
	
	Case "klonelab-globaledit" //MEA - 03/13 Added for Klonelab
		dw_import = Create u_dw_import_update_klonelab_3rd_global_edit	
	Case "starbucks-pod_update" //MEA - 06/13 Added for Starbucks
		dw_import = Create u_dw_import_starbucks_delivery_date_update			
	//Jxlim 07/03/2013 Added Inventory Toggle to import list
	//Case "Inv-Toggle" /* Jxlim 07/03/2013  - Update Inventory (Content) based on criteria - Arien*/		
		//dw_import = Create u_dw_import_arien
		//ibProcessOnServer = True /*Validate and Save on Websphere */
		//ilImportThreshhold = 1000 /*Limit to 1000 records*/	
	Case "SKU_Serial_Hold" /* Jxlim 07/17/2013  - Import to SKU_Serial_Hold table from - Arien*/		
		dw_import = Create u_dw_import_skuserialhold	
	//06-Dec-2013 :Madhu- Added- Update Stryker Outbound Orders -START	
	Case "Stryker-OB-Update"
		dw_import = Create u_dw_import_stryker_outbound_update
	//06-Dec-2013 :Madhu- Added- Update Stryker Outbound Orders -END

	//06-Jan-2014 :Madhu- Added- Upload RIVERBED Serialno's into Orders -START	
	Case "Serial Upload"
		dw_import = Create u_dw_import_riverbed_serial_upload
	//06-Jan-2014 :Madhu- Added- Upload RIVERBED  -END

	
	// start- Added for forward pick replensihment - Nxjain : 20140219
	
	Case "FP_PICK"
		dw_import =  Create u_dw_import_forwardpick	
	
	//end -Added for forward pick replensihment -Nxjain : 20140219
	
	//22-Apr-2014 :Madhu- Added- Carton Serial Upload - START
	Case "Carton-Serial"
		dw_import = Create u_dw_import_carton_serial_upload
	//22-Apr-2014 :Madhu- Added - Carton Serial Upload - END
	
	//19-Jan-2016 Madhu- added New Template for Item Master -START
	Case "im-full-new"
	dw_import = Create u_dw_import_server
	dw_import.dataobject = 'd_import_item_master_new'
	ibProcessOnServer = True
	ilImportThreshhold = 10000
	//19-Jan-2016 Madhu- added New Template for Item Master -END
	
	//24-Apr-2017 :Madhu PEVS-567- KNY– Custom Wave Plan input sheet -START
	Case "wave-plan"
		dw_import =Create u_dw_import_wave_plan
		dw_import.dataobject ='d_baseline_unicode_generic_import'
	//24-Apr-2017 :Madhu PEVS-567- KNY– Custom Wave Plan input sheet -END
	
	Case Else
	Return		
End Choose

// 02/07 - If processing on server, server will also perform validation, no need for 2 step process
If ibProcessOnServer Then
	cb_validate.Enabled = False
Else
	cb_validate.Enabled = True
End If

OpenuserObject(dw_import)

dw_import.visible = True
dw_import.Enabled = True
dw_import.x = 0
dw_import.y = 152
dw_import.width = 3700
dw_import.height = 1600

If lsTitle > '' Then
	lsModify = "Title_t.Text='" + lsTitle + "'"
	dw_import.Modify(lsModify)
End If

dw_import.Reset()

ibChanged = False

end event

event ue_import();String	lsFile,	&
			lsLayout,	&
			lsSaveFile
String lsfilter, lsDoNo,  lsOrderNo, lsTrackingNo, lsSku, lsSerial_no, lsHold, lsCurrent_InvType, lsnew_invtype
Integer liRC,  liFedEx,liPos, liLen, lirow, liCartonNo, liLineItemNo

Long		llRowCount, &
			llCount, 	&
			llcnt, &
			llRows
Decimal ldQty

Str_Parms	lStrParms
datastore lds_FedEx, lds_InvAdj

st_validation.Text = ''
cb_Archive.Enabled = False

If dw_import.RowCount() > 0 Then
	Choose Case Messagebox("Import","Would you like to clear the existing records first?",Question!,yesNoCancel!,2)
		Case 1 /*yes*/
			dw_import.Reset()
		Case 3 /*cancel*/
			Return
	End Choose
End If

//See if there is a default export file for this layout
lsLayout = dw_layout_list.getItemString(1,'import_file')
isPath = ProfileString(gs_inifile,"import",lsLayout,"")

//04/02 - PCONKL - If there is a default, allow to pick directly - We can't default the file using FileOpen
If isPAth > '' Then
	lStrparms.String_arg[1] = isPath
	OpenWithParm(w_select_Import_File,lstrparms)
	LstrParms = Message.PowerObjectParm
	If lStrParms.String_Arg[1] > '' Then
		lsFile = LstrParms.String_arg[1]
	Else
		Return
	End If
	
Else	/*No default exists in ini file - open windows prompt*/
	
	//24-Apr-2017 :Madhu PEVS-567- KNY– Custom Wave Plan input sheet -START
	//Allow to Import TXT, CSV Files
	If upper(gs_project)='NYCSP' and lsLayout='wave-plan' Then
		liRC = getFileOpenName("Select FIle to Import",isPath, lsFile,"TXT","Text Files (*.*),*.*,CSV Files(*.*),*.*,")
	else
		liRC = getFileOpenName("Select FIle to Import",isPath, lsFile,"TXT","Text Files (*.*),")
	End If
	//24-Apr-2017 :Madhu PEVS-567- KNY– Custom Wave Plan input sheet -END

	If liRC <>1 Then Return
	
End If

SetPointer(Hourglass!)

//08/02 - PCONKL - For GM_Hahn (in addition to SAltillo/Detroit), don't allow file to be imported more than once
If Upper(Left(gs_project,4)) = 'GM_M'  or &
	Upper(gs_project) = "GM_HAHN"	 or &
	Upper(gs_project) = "SEARS-FIX"	 or &
	Upper(gs_project) = "PULSE"	then // Check to see if this file has been processed previously! (GM_M only)
	lsSaveFile = Right(lsFile,30) /*we can only save 30 char of the file name, left 30 may not be unique - imports will save the last 30 to User_field 8*/
	Select Count(*) into :llCount
	From Delivery_Master
	Where project_id = :gs_Project and User_Field8 = :lsSaveFile; /*only compare last (right) 30 */
Else
	llCount = 0
End IF

/**************************************/
if upper(gs_project) = 'METRO' and upper(lsLayout) = 'INBOUND_ORDER' Then
		dw_import.event ue_pre_import( )
		llRowCount = dw_import.RowCount()
		this.cb_save.Enabled = TRUE
Elseif upper(gs_project) = 'METRO' and upper(lsLayout) = 'GENERIC-SO' then
		dw_import.event ue_pre_import( )
		llRowCount = dw_import.RowCount()
		this.cb_save.Enabled = TRUE
Else 
	If llCount > 0  Then  // Error message
		Messagebox("Import", "Warning! This file has been processed before.  Import a file with a different name to avoid Duplicate Orders.")
		return 
	
	else // Continue to process if llCount is = 0 
		
		isImportFile = lsFile
	// TAM 2011/05/11 W&S  One of the imports is coming with a .PRT extention but is a text file.  Allow this.
		dw_import.setImportFile( isPath, lsFile )   //ET3 2012/05/18: for internal usage of dw_import
		
		// ET3 - Pandora Min-Max does not actually use the dw_import.ImportFile function
		IF dw_layout_list.GetItemString(1,"import_file") = "Pandora Min-Max" THEN
			If IsValid(w_import) Then
				this.cb_validate.Enabled = FALSE
				this.cb_convert.Enabled = FALSE
				this.cb_archive.Enabled = FALSE
				this.cb_save.Enabled = FALSE
				this.cb_insert.Enabled = FALSE
				this.cb_delete.Enabled = FALSE
				this.cb_print.Enabled = FALSE
				this.cb_ok.Enabled = FALSE
				this.cb_import.Enabled = FALSE
			End If
	
			dw_import.postevent( "ue_pre_import")
			
		ELSEIF 	dw_layout_list.GetItemString(1,"import_file") = "sn-import" THEN
			
			If IsValid(w_import) Then
				this.cb_validate.Enabled = FALSE
				this.cb_convert.Enabled = FALSE
				this.cb_archive.Enabled = FALSE
				this.cb_save.Enabled = FALSE
				this.cb_insert.Enabled = FALSE
				this.cb_delete.Enabled = FALSE
				this.cb_print.Enabled = FALSE
				this.cb_ok.Enabled = FALSE
				this.cb_import.Enabled = FALSE
			End If
	
			dw_import.postevent( "ue_pre_import")
		//24-Apr-2017 :Madhu PEVS-567- KNY– Custom Wave Plan input sheet -START	
		ELSEIF dw_layout_list.GetItemString(1,"import_file") = "wave-plan" THEN
			If IsValid(w_import) Then
				this.cb_validate.Enabled = FALSE
				this.cb_convert.Enabled = FALSE
				this.cb_archive.Enabled = FALSE
				this.cb_save.Enabled = FALSE
				this.cb_insert.Enabled = FALSE
				this.cb_delete.Enabled = FALSE
				this.cb_print.Enabled = FALSE
				this.cb_ok.Enabled = FALSE
				this.cb_import.Enabled = FALSE				
			End If
			
			dw_import.postevent( "ue_pre_import")
		
		//24-Apr-2017 :Madhu PEVS-567- KNY– Custom Wave Plan input sheet -END
		ELSE
			If Upper(Left(gs_project,3)) = 'WS-'  and upper(right(trim(lsFile),4)) = '.PRT' Then
				dw_import.ImportFile(Text!,lsFile)
			Else
				//llRows = dw_import.ImportFile(lsFile)  gwm llRows is not tested!!!
				llRowCount = dw_import.ImportFile(lsFile)
			End If
		END IF
	END IF

	If llRowCount > 0 Then
		
		// 03/07 - PCONKL - If processing on Server, enable save and disable validation - will be done at same time on server
		If ibprocessonserver Then
			cb_validate.Enabled = False
			cb_save.Enabled = True
		Else
			cb_validate.Enabled = True
			cb_save.Enabled = False
		End If
		
		cb_Archive.Enabled = True
		cb_delete.Enabled = True
		cb_Print.Enabled = True
		
		dw_import.doLockDW( true ) // unlock for editing
		
		ilCurrValRow = 1 /*first row to validate*/
		
		//gap 5/03 Used to bring back daily Fedex tracking information 
		if dw_import.DataObject = 'd_import_fedex_return' then 
			lds_FedEx = CREATE u_ds
			lds_FedEx.DataObject = 'd_import_fedex_tracking'
			lds_FedEx.SetTransObject(SQLCA)
			lirow = 0
			for llcnt = 1 to llRowCOunt
    			lsfilter =  dw_import.getitemstring(llcnt,'fedexreturn')
				liPos =  pos(lsfilter,",")
				liFedEx = integer(left(lsfilter,(liPos - 1))) // get fedex line code
				liLen = len(lsfilter)
				lsfilter = right(lsfilter, (liLen - (liPos + 1) )) // strip leading "
				liLen = len(lsfilter)
				lsfilter = left(lsfilter, (liLen - 1)) // strip trailing "
				if liFedEx =  1 then //fedex return sims info
					lirow = lirow + 1 // set row index
					liLen = len(lsfilter)
					liPos = pos(lsfilter ,"|" )
					lsDoNo = left(lsfilter, (liPos - 1)) // get dono
					lsfilter = right(lsfilter, (liLen - liPos))
					liLen = len(lsfilter)
					liPos = pos(lsfilter ,"|" )
					liCartonNo = integer(left(lsfilter, (liPos - 1))) // get carton
					lsfilter = right(lsfilter, (liLen - liPos))
					liLen = len(lsfilter)
					liPos = pos(lsfilter ,"|" )
					liLineItemNo = integer(left(lsfilter, (liPos - 1))) // get line no
					lsfilter = right(lsfilter, (liLen - liPos))
					lsOrderNo = lsfilter  // get order no
					//set lds_FedEx.DataObjects to lirow index 
					lds_FedEx.insertrow(lirow) 
					lds_FedEx.setitem(lirow, 'dono', lsDoNo)
					lds_FedEx.setitem(lirow, 'cartonno', liCartonNo)
					lds_FedEx.setitem(lirow, 'lineitemno', liLineItemNo)
					lds_FedEx.setitem(lirow, 'orderNo', lsOrderNo)
				elseif liFedEx =  29 then // fedex returns tracking no
					lsTrackingNo = lsfilter // get tracking no
					//set lds_FedEx.TrackingNo to lirow index 
					lds_FedEx.setitem(lirow, 'TrackingNo', lsTrackingNo)
				end if
			next
			llcnt = lds_FedEx.RowCount()
			// update DW with parsed FedEx-returned-data
			dw_import.clear()  
			dw_import.DataObject = 'd_import_fedex_tracking'
			dw_import.SetTransObject(SQLCA)
			for lirow = 1 to llcnt
					dw_import.insertrow(lirow)
					dw_import.setitem(lirow, 'dono', lds_FedEx.getitemstring(lirow,'DoNo'))
					dw_import.setitem(lirow, 'cartonno', lds_FedEx.getitemnumber(lirow,'cartonno'))
					dw_import.setitem(lirow, 'lineitemno', lds_FedEx.getitemnumber(lirow,'lineitemno'))
					dw_import.setitem(lirow, 'TrackingNo', lds_FedEx.getitemstring(lirow,'TrackingNo'))
					dw_import.setitem(lirow, 'orderNo', lds_FedEx.getitemstring(lirow,'orderNo'))
			next	
		end if //end of Fedex tracking information 	
		
		
//		//Jxlim 07/03/2013 Arien- Retreive inventory information from content based on incoming file (SKU, Serial#, Hold Y/N)		
//		If dw_import.DataObject = 'd_import_skuserialhold_in' Then     //Incoming file from Arien
//		//If dw_import.DataObject = 'd_import_inventory_toggle' Then     //Incoming file from Arien
//			lds_InvAdj = CREATE u_ds
//			lds_InvAdj.DataObject = 'd_import_content_info'  //project and sku
//			lds_InvAdj.SetTransObject(SQLCA)
//			lirow = 0
//			For llcnt = 1 to llRowCOunt    					
//					lsSku =  Trim(dw_import.getitemstring(llcnt,'sku'))			
//					lsSerial_no =  Trim(dw_import.getitemstring(llcnt,'serial_no'))	
//					//lsHold =  Trim(dw_import.getitemstring(llcnt,'inventory_type'))	  //Inventory type Hold Y/N?		//don't need becasue it is always going to be 'H' type.
//					lsHold ='H'
//					//Retrieve Inventory info from content based on specified criteria (project, Sku)
//					//lds_InvAdj.Retrieve(gs_project, lsSku)
//					
//					//Retrieve Inventory info from content based on Project_id
//					lds_InvAdj.Retrieve(gs_project)
////					long lLContentcount, ll_row, ll_found 
////					llContentcount= lds_InvAdj.rowcount()
////
////					// Get the row num. for the beginning of the search
////					// from the instance variable, il_found
////
////								ll_row = ll_found
////
////								// Search using predefined criteria; search all SKu from content where inventory type ='H'
////								//a.	If found bring it to the import screen.  Since these are all ‘H; type what are we doing on the adjustment? 
////								//Do we set new/old inventory type = ‘H’ just like the location and qty?
////								ll_row = lds_InvAdj.Find( "Inventory_type = 'H'",   ll_row, llContentcount)								
////								IF ll_row > 0 THEN
////										  // Row found, scroll to it and make it current
////									//	  lds_InvAdj.ScrollToRow(ll_row)								
////								ELSE
////										  // No row was found
////										  MessageBox("Not Found", "No row found.")										  
////										//b.	If not found; do another find with SKU = SKU from Arien file and Serial_no =Serial_no = Serial_no from Arien file (Imported file)
////										//c.	If found bring in to the import screen and do adjustment (just like the original design)
////										//Is this sound right?																	
////								END IF
////								
////								// Save the number of the next row for the start of the next search. If no row was found,
////								// ll_row is 0, making il_found 1, so that the next search begins again at the beginning
////								ll_found = ll_row + 1
//					
//			Next
//					llcnt = lds_InvAdj.RowCount()   //content rowcount per criteria
//					// update DW with Import Content Inventory data
//					dw_import.clear()  
//					dw_import.DataObject =  'd_import_stock_adjustments'
//					dw_import.SetTransObject(SQLCA)
//					For lirow = 1 to llcnt
//							dw_import.insertrow(lirow)
//							dw_import.setitem(lirow, 'Project_id', lds_InvAdj.getitemstring(lirow,'project_id'))
//							dw_import.setitem(lirow, 'wh_code', lds_InvAdj.getitemstring(lirow,'wh_code'))
//							dw_import.setitem(lirow, 'sku', lds_InvAdj.getitemstring(lirow,'sku'))
//							//dw_import.setitem(lirow, 'serial_no', lds_InvAdj.getitemstring(lirow,'serial_no'))	
//							dw_import.setitem(lirow, 'supp_code', lds_InvAdj.getitemstring(lirow,'supp_code'))
//							dw_import.setitem(lirow, 'l_code', lds_InvAdj.getitemstring(lirow,'l_code'))
//							dw_import.setitem(lirow, 'new_l_code', lds_InvAdj.getitemstring(lirow,'l_code'))							
//							//Change Inventory type to Hold
//							lsCurrent_InvType =  lds_InvAdj.getitemstring(lirow,'inventory_type')
//							lsNew_InvType = lds_InvAdj.getitemstring(lirow,'inventory_type')
//							If lsCurrent_InvType <> 'H' Then			//If sku in content <> 'H' then will adjust to 'H'			
//								//dw_import.setitem(lirow, 'new_inventory_type', lds_InvAdj.getitemstring(lirow,'inventory_type'))
//								dw_import.setitem(lirow, 'new_inventory_type', lsHold)    //lsHold is always 'H'
//								dw_import.setitem(lirow, 'old_inventory_type', lsCurrent_InvType)
//							Else   //if this importing SKU is already 'H' then what are we doing?
//								dw_import.setitem(lirow, 'new_inventory_type', lds_InvAdj.getitemstring(lirow,'inventory_type'))
//								dw_import.setitem(lirow, 'old_inventory_type', lds_InvAdj.getitemstring(lirow,'inventory_type'))
//							//If  sku in the inventory content table are 'H' what are we doing?
//							End If	
//							dw_import.setitem(lirow, 'old_qty', String(lds_InvAdj.getitemDecimal(lirow,'avail_qty'))) 
//							dw_import.setitem(lirow, 'new_qty', String(lds_InvAdj.getitemDecimal(lirow,'avail_qty')))
//							dw_import.setitem(lirow, 'ref_nbr', lds_InvAdj.getitemstring(lirow,'sku'))
//							dw_import.setitem(lirow, 'reason', lds_InvAdj.getitemstring(lirow,'reason_cd'))	
//					Next	
//		End if //End of Inventory Information 		//07/03/2013 Jxlim Arien
		
	End If
	
	//Jxlim 07/18/2013 Disabled validate button on Import skueserialhold
	IF lslayout = "SKU_Serial_Hold" THEN
		If IsValid(w_import) Then
			this.cb_validate.Enabled = FALSE
			this.cb_save.Enabled = TRUE
		End If
	End If

	//If the first row is headings, we will want to delete it!
	If llRowCOunt > 0 Then
		st_validation.text = String(dw_import.RowCount()) + ' Records Imported. If your first row is column headings, you will need to delete it.'
		
		//There may be some manipulating, etc necessary after importing the rows
		dw_import.TriggerEvent('ue_post_import')
	
	End If

	ibValError = False
	ibChanged = True

End If

If dw_Import.RowCount() > 0 Then
	dw_import.SetRow(1)
	dw_import.ScrollToRow(1)
End If

SetPointer(Arrow!)

st_validation.text = ""
end event

event ue_validate();Long	llRowCount, llFindRow
string	lsMsg, lsFind


SetPointer(Hourglass!)

dw_import.acceptText()
cb_save.Enabled = False

dw_import.doLockDW( true ) // unlock for editing

st_validation.text = ''
llRowCount = dw_import.RowCount()

if llRowCount = 0 Then Return

If ilImportThreshhold > 0 Then
	If ilImportThreshhold < llRowCount Then
		Messagebox("Import","This import is limited to " + String(ilImportThreshhold) + " records. ")
		return
	End If
End If

//Any pre validation requirements
//if dw_import.event ue_pre_validate() < 0 then return

//Any pre validation requirements

if dw_import.event ue_pre_validate() =1  then 
return 
end if 


If ilCurrvalrow = 0 or isnull(ilCurrValRow) or ilCurrValRow > llRowCount Then
	ilCurrvalrow = 1
End If

// pvh 12/05/06 - websphere
//if getAMS() then
//	lsMsg = dw_import.dynamic doValidate(  )
//	if lsMsg > '' then
//		st_validation.text = lsMsg + "    Click 'Validate' to continue..."
//		SetPointer(Arrow!)
//		ibValError = True	
//		return
//	end if
//else
	Do While ilcurrvalrow <= llRowCount and llRowCount > 0
		w_main.SetMicroHelp("validating Row " + string(ilCurrValRow) + ' of ' + string(llRowCount))
		lsMsg = dw_import.wf_validate(ilCurrValRow)
		If lsMsg > '' Then
			//dw_import.SetRow(ilcurrvalrow)
			dw_import.ScrolltoRow(ilcurrvalrow)
			st_validation.text = 'Row ' + string(ilCurrValRow) + ': ' + lsMsg + "    Click 'Validate' to continue..."
			SetPointer(Arrow!)
			ibValError = True
			ilcurrvalrow ++
			Return
		End If
		ilcurrvalrow ++
	Loop
//end if

If Not ibValError Then
	//Jxlim 03/14/2011  Added messgaebox to warn for delete record/s when qty fields are 0 or blank (Import min_max for Pandora)
	//Find if any 0 qty fields exist on the import dw
	//Jxlim 04/23/2011 This window  is  shared by all import data windows most of which don’t have these column, therefore add a specific call for min_max dataobject only.
     If dw_import.dataobject= "d_import_itemaster_min_max" Then
		lsFind = "IsNull(Upper(min_rop)) or min_rop = '0'"
		lsFind += " And IsNull(Upper(max_supply)) or max_supply = '0'"
		lsFind += " And IsNull(Upper(reorder_qty)) or reorder_qty = '0'"
	
		llFindRow = dw_import.Find(lsFind, 1, dw_import.RowCount())
		If llFindRow > 0 Then		
			If Messagebox("Import", "Validation Complete!~r~rRecord containing 0 or blank qty on all qty fields will be deleted from SIMs!~r~rAre you sure you want to continue?",Question!,YesNo!,1) = 1 Then
				cb_save.Enabled = True
			Else
				Return
			End If	
		Else 
			Messagebox("Import", "Validation Complete!")
		End If	
	Else 
		Messagebox("Import", "Validation Complete!")
	End If
Else
	if Messagebox("Import","Validation Complete!~r~rErrors were encountered, would you like to re-validate from the beginning?",Question!,yesNo!,1) = 1 Then
		ilCurrvalRow = 1
		st_validation.text = ''
		cb_save.Enabled = FALSE
		ibValError = FALSE

		This.PostEvent("ue_validate")
	End If
End If

ilCurrvalRow = 1
st_validation.text = ''
cb_save.Enabled = True
//dw_import.doLockDW( false ) // lock for saving

w_main.SetMicroHelp("Ready")
SetPointer(Arrow!)
end event

event ue_delete();Long	lLRow
String ls_sku, lserrtext

llRow = dw_import.GetRow()
If llRow > 0 Then
	
	//Jxlim 03/10/2011 //When delete from dw_import also delete this sku record from reorder_point table.
	//04/13/11 caw - Some layouts do not process at sku level so do not try and delete from reorder_point table 
	// only issue warning message.  Other layouts may have this same issue and need to be added?
//	IF isLayout = "AMS"  OR isLayout = "powerwave-ord-ship" THEN
//			if Messagebox("Confirm Delete","Are you sure you want to DELETE this row?",Question!,YesNo!,2) = 1 Then
//				dw_import.DeleteRow(llRow)
//			end if
//	ELSE		
	//For import min_max Pandora
	IF gs_project = 'PANDORA' AND isLayout = 'im-m/m' THEN
		
		ls_sku = dw_import.GetItemString(llRow, 'sku')	
		if Messagebox("Confirm Delete","Are you sure you want to DELETE this row?",Question!,YesNo!,2) = 1 Then
			dw_import.DeleteRow(llRow)
			//When delete from dw_import also delete this sku record from reorder_point table.
			//04/15/11 - cawikholm - Added project_id and wh_code to delete
			Delete From dbo.Reorder_Point
			Where PROJECT_ID = :gs_project
			     And SKU = :ls_sku
			USing SQLCA;
			
			If sqlca.sqlcode <> 0 Then
				lsErrText = sqlca.sqlerrtext /* sql error text returned */
				Messagebox("Import","Unable to delete existing rows in database!~r~r" + lsErrText)
				SetPointer(Arrow!)		
			End If
		End If
		
	ELSEIF upper(gs_project) = 'METRO' AND isLayout = 'im-full' THEN
		ls_sku = dw_import.GetItemString(llRow, 'sku')	
		if Messagebox("Confirm Delete","Are you sure you want to DELETE this row?",Question!,YesNo!,2) = 1 Then
			dw_import.DeleteRow(llRow)
			Delete From dbo.Item_Master
			Where PROJECT_ID = :gs_project
			     And SKU = :ls_sku
			USing SQLCA;
			
			If sqlca.sqlcode <> 0 Then
				lsErrText = sqlca.sqlerrtext /* sql error text returned */
				Messagebox("Import","Unable to delete existing rows in database!~r~r" + lsErrText)
				SetPointer(Arrow!)		
			End If
		End If

ELSE
		
		dw_import.DeleteRow(llRow)
		
	END IF  
Else
	messagebox("Import","Nothing to delete!")
End If
end event

event ue_save();Integer li_save_return

dw_import.acceptText()

if dw_import.RowCount() <=0 Then Return

 li_save_return = dw_import.wf_save()

CHOOSE CASE  li_save_return

   CASE -87 /* FInancial Data NOT Saved*/
	ibchanged 				= TRUE
	cb_save.Enabled 		= TRUE 
	cb_validate.Enabled 	= TRUE
	cb_insert.enabled      = FALSE
	cb_delete.enabled      = TRUE
	
   CASE 87 /* FInancial Data  Saved*/
	ibchanged 				= FALSE
	cb_save.Enabled 		= FALSE 
	cb_validate.Enabled 	= FALSE
	cb_insert.enabled      = FALSE
	cb_delete.enabled      = FALSE

CASE ELSE  /* Catch all processing used by previous import */
	
			If	 li_save_return >= 0 Then
				ibchanged = False
				cb_save.Enabled = False /*to stop users (Carmen) from saving twice */
				cb_validate.Enabled = False
			End If
	
END CHOOSE 

end event

event ue_archive;String	lsNewFile, lsPath
Boolean	lbRet
//archive the file that was opened

lsPath = ispath

If GetFileSaveName('Archive (Rename) File to:',lsPath, lsNewFile) = 1 Then
	lbret=MoveFile(ispath,lspath) /*isPAth is File that was opened*/
	If lbret Then
		st_validation.Text = 'File successfully renamed to: ' + lsPath
	Else /*unable to archive file*/
		Messagebox('Import','Unable to Archive File.')
	End If
End If




end event

event ue_print;
If isValid(dw_import) Then	OpenWithParm(w_dw_print_options,dw_import) 
end event

event ue_save_server();
String	lsXML, lsXMLResponse, lsReturnCode, lsReturnDesc, lsString
Long		llRC, llPos
Boolean	lbError
str_parms	lstrparms
Boolean	lb_override_rw_project_id
long		ll_start_pos, ll_pos1, ll_pos2

//Process validation and Save on Websphere

//04/08 - PCONKL - we may limit the number of records to import
If ilImportThreshhold > 0 Then
	If ilImportThreshhold < dw_Import.RowCount() Then
		Messagebox("Import","This import is limited to " + String(ilImportThreshhold) + " records. ")
		return
	End If
End If

// gwm 20141106 - Allow date format yyyymmdd - Metro
/*
If isLayout = 'inbound_order' Then
	if dw_import.dataobject = 'd_import_po' Then
		lsString = dw_import.GetItemString(1,'order_date')
		ll_pos1 = pos(lsString,'-')
		ll_pos2 = pos(lsString,'/')
		if len(lsString) = 8 and ll_pos1 = 0 and ll_pos2 = 0 Then
			dw_import.SetItem(1,'order_date',wf_format_date(lsString))
		End If
		lsString = dw_import.GetItemString(1,'scheduled_date')
		ll_pos1 = pos(lsString,'-')
		ll_pos2 = pos(lsString,'/')
		if len(lsString) = 8 and ll_pos1 = 0 and ll_pos2 = 0 Then
			dw_import.SetItem(1,'scheduled_date',wf_format_date(lsString))		
		End If
	End If
	if dw_import.dataobject = 'd_import_so' Then
		lsString = dw_import.GetItemString(1,'order_date')
		ll_pos1 = pos(lsString,'-')
		ll_pos2 = pos(lsString,'/')
		if len(lsString) = 8 and ll_pos1 = 0 and ll_pos2 = 0 Then
			dw_import.SetItem(1,'order_date',wf_format_date(lsString))
		End If
		lsString = dw_import.GetItemString(1,'scheduled_date')
		ll_pos1 = pos(lsString,'-')
		ll_pos2 = pos(lsString,'/')
		if len(lsString) = 8 and ll_pos1 = 0 and ll_pos2 = 0 Then
			dw_import.SetItem(1,'scheduled_date',wf_format_date(lsString))
		End If
		lsString = dw_import.GetItemString(1,'request_date')
		ll_pos1 = pos(lsString,'-')
		ll_pos2 = pos(lsString,'/')
		if len(lsString) = 8 and ll_pos1 = 0 and ll_pos2 = 0 Then
			dw_import.SetItem(1,'request_date',wf_format_date(lsString))
		End If
	End If
End If
*/
dw_import.AcceptText()
w_main.setmicrohelp("Exporting XML to server...")

SetPointer(Hourglass!)

// 05/4/11 - cawikholm - Special Check for GIGA using Run-worlds import file
IF UPPER(gs_project) = 'GIGA' THEN
	
	IF dw_import.RowCount() > 0 THEN
		
		lb_override_rw_project_id = TRUE
			
	END IF
	
END IF

//Get XML to send to server
lsXML = dw_import.wf_export_xml()

//set placeholder attributes
lsXml = Replace(lsXML,pos(lsxml,"*server*"),8,sqlca.servername)
lsXml = Replace(lsXML,pos(lsxml,"*database*"),10,sqlca.database)
lsXml = Replace(lsXML,pos(lsxml,"*userid*"),8,gs_userid)
lsXml = Replace(lsXML,pos(lsxml,"*dataSource*"),12,g.isWebsphereDatasource) // 11/12 - PCONKL - Added placeholder for datasource

// Override Project ID for Run-World using the 'GIGA' warehouse.  cwikholm 05/04/11
IF lb_override_rw_project_id = TRUE THEN
	
	lsXml = Replace(lsXML,pos(lsxml,"*projectid*"),11,'GIGA')
	
	// Find the first occurrence of old_str.
	ll_start_pos = Pos(lsXML, '<ProjectID>RUN-WORLD<', 1)

		
	// Only enter the loop if we find run-world as the project
	DO WHILE ll_start_pos > 0
			
		lsXml = Replace(lsXML,ll_start_pos,21,'<ProjectID>GIGA<')
								
		ll_start_pos = Pos(lsXML, '<ProjectID>RUN-WORLD<', ll_start_pos + 16)
		
	LOOP
		
ELSE
	
	lsXml = Replace(lsXML,pos(lsxml,"*projectid*"),11,gs_project)
	
END IF

lsXml = Replace(lsXML,pos(lsxml,"*requestaction*"),15,"Save") /*Save (will validate as well)*/



w_main.setmicrohelp("Processing import on Application Server...")
//Send to Server
lsXMLResponse = iuoWebsphere.uf_post_url( lsXML )

//messagebox( "XML", lsXMLResponse )


//Process results from server
If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
	Messagebox("Websphere Fatal Exception Error","Unable to Validate/Save Import: ~r~r" + lsXMLResponse,StopSign!)
	Return 
End If

//Check the return code and return description for any trapped errors


lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		
		Messagebox("Websphere Operational Exception Error","Unable to Save Import: ~r~r" + lsReturnDesc,StopSign!)
		Return 
	
	Case Else
		
		llRc = Long(lsReturnCode)
		
		If llRc > 0 Then /* Validation Error llrc contains row number with error */
			
			dw_import.SetRow(llRC)
			dw_import.ScrolltoRow(llRC)
			
			//st_validation.text = 'Row ' + string(llRc) + ': ' + lsReturnDesc + "    Click 'Save' to continue..."
			//MessageBox("Validation Errors",lsReturnDesc)
					
									
			lstrparms.String_arg[1] = lsReturnDesc
			OpenWithParm(w_import_Errors,lstrparms)
			lbError = True
			
		ElseIf llRC < 0 Then /*save error */
			
			Messagebox("Import","Unable to Save Import: ~r~r" + lsReturnDesc,StopSign!)
			lbError = True
			
		Else
			//TimA 01/15/13 Pandora issue #202
			//Call OTM on Item Master Imports
			If Upper(g.is_OTM_Item_Master_Send_Ind) = 'Y' then
				//For import min_max Pandora
				//TimA 04/04/14 Add Item Master Full Layout per James request
				IF UPPER(gs_project) = 'PANDORA' AND (isLayout = 'im-m/m' or isLayout = 'im-full' ) THEN
					TriggerEvent("ue_send_otm")
				End if	
			End if
			dw_import.TriggerEvent("ue_after_save")
			
			st_validation.text = ""
			messagebox("Import", "Save successful!~r~r" + lsReturnDesc)
			cb_save.Enabled = False
			
		End If
					
End Choose

If Not lbError Then
	ibchanged = False
End If

SetPointer(Arrow!)
w_main.setmicrohelp("Ready")
end event

event ue_send_otm();//TimA 01/15/13 Pandora issue #202
//Call OTM on Item Master Imports
Integer li_ret
String ls_serial_number,ls_lot_controlled ,ls_po_controlled,  lsProj, lsSupplier, lsOrigSupplier, lsSku, lsemptyArray[]
Long	llArrayPos,llPos
String ls_action
Boolean lb_otm_field_changes

Long llCount,ll_OTM_Return
String ls_return_cd, ls_error_message
String ls_length,ls_width,ls_height,ls_weight 	//17-Feb-2015 :Madhu- Added Get dimension values


n_otm ln_otm
Datastore ldsItem

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master'
ldsItem.SetTransObject(SQLCA)

lsProj = UPPER(gs_project)
If Upper(g.is_OTM_Item_Master_Send_Ind) = 'Y' then

	If Not isvalid(ln_otm) Then
		ln_otm = CREATE n_otm
	End if
	
	For llPos = 1 to dw_import.RowCount()
		lsSku = dw_import.Getitemstring(llPos,"SKU")
		lsSupplier = dw_import.Getitemstring(llPos,"supp_code")
		//17-Feb-2015 :Madhu- Added Get dimension values -START
		ls_length =dw_import.getitemstring(llPos,"length_1")
		ls_width =dw_import.getitemstring(llPos,"width_1")
		ls_height =dw_import.getitemstring(llPos,"height_1")
		ls_weight =dw_import.getitemstring(llPos,"weight_1")
		//17-Feb-2015 :Madhu- Added Get dimension values -END

		llCount = ldsItem.Retrieve(lsProj, lsSKU)	
	
	IF ((not isnull(ls_length) and Integer(ls_length) > 0) and (not isnull(ls_width) and Integer(ls_width) > 0) &
		and (not isnull(ls_height) and Integer(ls_height) > 0) and (not isnull(ls_weight) and Integer(ls_weight) > 0))THEN 	//17-Feb-2015 :Madhu- If dimensions are greater than zero then only push to OTM -Added	
			
		If llCount > 0 then
			ls_action = 'U'
		Else
			ls_action = 'I'
		End if
	
		if ls_action = 'D' then
			// Action is Delete.  Send the stored IM keys to OTM via a WebSphere call.
			ln_otm.uf_push_otm_item_master(ls_action, gs_project, is_delete_sku, is_delete_supp_cd, ls_return_cd, ls_error_message)
		elseif (ls_action = 'I' or ls_action = 'U')  then
			
			//			elseif (ls_action = 'I' or ls_action = 'U') and lb_otm_field_changes and dw_import.RowCount() > 0 then				
			// If data has been modified in the OTM fields, send the IM keys to OTM via a WebSphere call.
			ll_OTM_Return = ln_otm.uf_push_otm_item_master(ls_action, lsProj, lsSku, lsSupplier, ls_return_cd, ls_error_message)
			//				ln_otm.uf_push_otm_item_master(ls_action, dw_import.Object.project_id[1], dw_import.Object.sku[1], dw_import.Object.Supp_Code[1], ls_return_cd, ls_error_message)				
		
			If ll_OTM_Return = -1 then
				//Error OTM
				Messagebox('OTM Error Call','Unable to delete order from OTM')
			end if
		end if
	END IF 	//17-Feb-2015 :Madhu- If dimensions are greater than zero then only push to OTM -Added	
next
end if


end event

public subroutine setams (boolean value);ibAMS = value
end subroutine

public function boolean getams ();return ibAMS

end function

public subroutine wf_set_otm_dims ();// LTK 20120427 OTM additions
//if idw_main.RowCount() > 0 then
//	id_length_1 = idw_main.Object.length_1[1]
//	id_width_1 = idw_main.Object.width_1[1]
//	id_height_1 = idw_main.Object.height_1[1]
//	id_weight_1 = idw_main.Object.weight_1[1]
//end if
//
end subroutine

public function boolean wf_otm_fields_modified ();// LTK 20120427 OTM additions
boolean lb_return

if dw_import.RowCount() > 0 then

	lb_return = 	( IsNull(id_length_1) AND NOT IsNull(dw_import.Object.length_1[1]) ) OR &
					( NOT IsNull(id_length_1) AND IsNull(dw_import.Object.length_1[1]) ) OR &
					( IsNull(id_width_1) AND NOT IsNull(dw_import.Object.width_1[1]) ) OR &
					( NOT IsNull(id_width_1) AND IsNull(dw_import.Object.width_1[1]) ) OR &
					( IsNull(id_height_1) AND NOT IsNull(dw_import.Object.height_1[1]) ) OR &
					( NOT IsNull(id_height_1) AND IsNull(dw_import.Object.height_1[1]) ) OR &
					( IsNull(id_weight_1) AND NOT IsNull(dw_import.Object.weight_1[1]) ) OR &
					( NOT IsNull(id_weight_1) AND IsNull(dw_import.Object.weight_1[1]) ) 

	if NOT lb_return then
		lb_return = NOT ( id_length_1 = dw_import.Object.length_1[1] AND &
								id_width_1 = dw_import.Object.width_1[1] AND &
								id_height_1 = dw_import.Object.height_1[1] AND &
								id_weight_1 = dw_import.Object.weight_1[1] )
	end if
end if

if lb_return then
	// All 4 DIM fields must contain data to be sent to OTM
//	lb_return =	dw_import.Object.length_1[1] <> 0 AND NOT IsNull(dw_import.Object.length_1[1])  AND &
//					dw_import.Object.width_1[1] <> 0 AND NOT IsNull(dw_import.Object.width_1[1]) AND &
//					dw_import.Object.height_1[1] <> 0 AND NOT IsNull(dw_import.Object.height_1[1]) AND &
//					dw_import.Object.weight_1[1] <> 0 AND NOT IsNull(dw_import.Object.weight_1[1]) 
//					

	lb_return =	NOT (IsNull(dw_import.Object.length_1[1])  OR &
					IsNull(dw_import.Object.width_1[1]) OR &
					IsNull(dw_import.Object.height_1[1]) OR &
					IsNull(dw_import.Object.weight_1[1]) )

	if lb_return then

		lb_return =	dw_import.Object.length_1[1] <> 0 AND &
						dw_import.Object.width_1[1] <> 0 AND &
						dw_import.Object.height_1[1] <> 0 AND &
						dw_import.Object.weight_1[1] <> 0 
	end if
	
end if

return lb_return

end function

public function string wf_format_date (string asindate);/* gwm 11/6/2014                                    */
/* For date from yyyymmdd to yyyy-mm-dd */
String lsReturn

	lsReturn = left(asindate,4) + '-' + mid(asindate,5,2) + '-' + right(asindate,2)

return lsReturn

end function

on w_import.create
this.cb_convert=create cb_convert
this.cb_option1=create cb_option1
this.cb_print=create cb_print
this.cb_archive=create cb_archive
this.cb_help=create cb_help
this.cb_insert=create cb_insert
this.cb_delete=create cb_delete
this.st_validation=create st_validation
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cb_save=create cb_save
this.cb_validate=create cb_validate
this.cb_import=create cb_import
this.dw_layout_list=create dw_layout_list
this.Control[]={this.cb_convert,&
this.cb_option1,&
this.cb_print,&
this.cb_archive,&
this.cb_help,&
this.cb_insert,&
this.cb_delete,&
this.st_validation,&
this.cb_cancel,&
this.cb_ok,&
this.cb_save,&
this.cb_validate,&
this.cb_import,&
this.dw_layout_list}
end on

on w_import.destroy
destroy(this.cb_convert)
destroy(this.cb_option1)
destroy(this.cb_print)
destroy(this.cb_archive)
destroy(this.cb_help)
destroy(this.cb_insert)
destroy(this.cb_delete)
destroy(this.st_validation)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cb_save)
destroy(this.cb_validate)
destroy(this.cb_import)
destroy(this.dw_layout_list)
end on

event open;Integer			li_ScreenH, li_ScreenW
Environment	le_Env

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2


This.PostEvent("ue_postopen")

end event

event closequery;Integer	liMsg
If ibCancel Then
	Return 0
End If

If isvalid(w_import_Errors) Then close(w_import_errors)

// pvh - 04/28/06 - plug the hole
// if the validation fails and you click OK, then yes, the data is saved regardless of the import validation.
// cb_save is disabled until validation passes, so...
/* if cb_save.enabled then  //hdc 10/18/2012  Pete says this isn't needed and it's causing a runtime error
		
	if ibChanged Then
		liMsg = Messagebox("Import","Would you like to save your changes?",Question!,yesNoCancel!,1)
	Else
		Return 0
	End If
	
	If liMsg = 2 Then /*dont save*/
		return 0
	Elseif liMsg = 3 Then /*cancel*/
		Return 1
	End If
	
	//Save changes
	if dw_import.wf_save() < 0 Then
		Return 1
	Else
		Return 0
	End If
end if */
return 0
// eom

end event

type cb_convert from commandbutton within w_import
boolean visible = false
integer x = 2007
integer y = 20
integer width = 448
integer height = 100
integer taborder = 160
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "SKU Conversion"
end type

event clicked;//messagebox("!!!!", "Fix 832 Import!!! (see sku 006061154 - Should have both MCC and MCP)")
//messagebox("NOTE!!", "Set some user field to original supplier for all record types")
/*
Create new function Someplace on SIMS CLient:

Cycle through Content (where Supp_code not in ('MAQUET', 'JH', 'MCP', 'MCC'))
For each Sku:
  See if it's in new Item Master...
   - With supposed New Supplier (translated)
   - With any supplier
   - Adding '0' or '00'

  If Found
    Update content for sku (supplier?)
    Update Receive Detail/Putaway (What about Receive Master???)
    Update Delivery Detail/Picking/PickingDetail/Packing
    Update Transfer Detail/DetailContent
    Update Adjustment
  end if
next

Cycle through ReceiveDetail (where Supp_code not in ('MAQUET', 'JH', 'MCP', 'MCC')
For each Sku:
  See if it's in new Item Master...
   - With supposed New Supplier (translated)
   - With any supplier
   - Adding '0' or '00'

  If Found
    Update Receive Detail/Putaway
    Update Delivery Detail/Picking/PickingDetail/Packing
    Update Transfer Detail/DetailContent
    Update Adjustment
  end if
next

Cycle through DeliveryDetail (where Supp_code not in ('MAQUET', 'JH', 'MCP', 'MCC')
For each Sku:
  See if it's in new Item Master...
   - With supposed New Supplier (translated)
   - With any supplier
   - Adding '0' or '00'

  If Found
    Update Delivery Detail/Picking/PickingDetail/Packing
    Update Transfer Detail/DetailContent
    Update Adjustment
  end if
next
.... Cycle through Transfers and Adjustments as well
*/

string 		sql_syntax, errors, lsSKU, lsNewSku, lsSupp
Datastore 	ldsSKUs
long			llRowCount, llRowPos, llCount
integer		liMissing, li_FileNum, li_FileNumLeading, liTCount, liUpdated, liAddZero

li_FileNum = FileOpen("C:\projects\SIMS\Maquet\MissingSKUs.TXT", LineMode!, Write!, LockWrite!, Append!)
FileWrite(li_FileNum, "Missing SKUS: " + string(now()))

li_FileNumLeading = FileOpen("C:\projects\SIMS\Maquet\LeadingZeros.TXT", LineMode!, Write!, LockWrite!, Append!)
FileWrite(li_FileNumLeading, "Leading Zeros: " + string(now()))



//-------------------------------------------------------------------------------------------------

st_validation.text = "Updating Receive_Master and Adjustment tables..."
Update Receive_Master set User_Field1 = supp_code where Project_id = 'Maquet' and user_field1 is null;
Update Adjustment set Old_PO_NO = supp_code where Project_id = 'Maquet' and old_po_no is null;

Update Receive_Master set Supp_code = 'MAQUET' where Project_id = 'Maquet' and Supp_code not in('442215', '72788', '78131', 'MCC', 'MCP', 'JH', 'MAQUET') and user_field1 is null;
Update Adjustment set Supp_code = 'MAQUET' where Project_id = 'Maquet' and Supp_code not in('442215', '72788', '78131', 'MCC', 'MCP', 'JH', 'MAQUET') and old_po_no is null; 

//Analysis indicated 442215 should become 'MCP', but data indicated it should be 'JH'
Update Receive_Master set Supp_code = 'JH' where Project_id = 'Maquet' and Supp_code = '442215' and user_field1 is null;
Update Adjustment set Supp_code = 'JH' where Project_id = 'Maquet' and Supp_code = '442215' and old_po_no is null;

Update Receive_Master set Supp_code = 'MCC' where Project_id = 'Maquet' and Supp_code in('72788', '78131') and user_field1 is null;
Update Adjustment set Supp_code = 'MCC' where Project_id = 'Maquet' and Supp_code in('72788', '78131') and old_po_no is null;

//Default 'Pkg Code' (PO_NO) to 'NRM' for all inventory
Update Content set PO_NO = 'NRM' where Project_ID = 'Maquet';

//-------------------------------------------------------------------------------------------------

//Create the datastores dynamically (no physical datastore object)
ldsSKUs = Create Datastore		
sql_syntax = "select distinct SKU, Supp_Code from content where Project_ID = 'MAQUET' and Supp_code not in ('MAQUET', 'JH', 'MCP', 'MCC')"
//sql_syntax += " and complete_date > getdate() - " + lsDays

//messagebox("TEMPO", sql_syntax)
ldsSkus.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", Errors))
IF Len(Errors) > 0 THEN
	messagebox("TEMPO", "*** Unable to create datastore for Content Records.~r~r" + Errors)
   Return - 1
END IF

ldsSKUs.SetTransObject(SQLCA)

llRowCount = ldsSKUs.Retrieve()

st_validation.text = "Distinct SKUs needing Conversion in Content: " + String(llRowCount)
messagebox("COUNT of Content", "Distinct SKUs needing Conversion: " + String(llRowCount))

FileWrite(li_FileNum, "Content SKUs missing from new Item Master...")
for llRowPos = 1 to llRowCount
	st_validation.text = "Processing Content record " + string(llRowPos) + " out of " + String(llRowCount)
	lsSKU = ldsSKUs.getItemString(llRowPos, "SKU")
	lsSupp = ldsSKUs.getItemString(llRowPos, "Supp_code")
	
	lsNewSku = lsSKU	
	Select Count(*) Into :llCount from item_master where project_id = 'maquet' and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
	if llCount = 0 then
		lsNewSku = '0' + lsSku
		Select Count(*) Into :llCount from item_master where project_id = 'maquet' and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
		if llCount > 0 then
			FileWrite(li_FileNumLeading, "Added a '0' and found sku: " + lsSKU)
			liAddZero ++
		else
			lsNewSku = '0' + lsNewSku
			Select Count(*) Into :llCount from item_master where project_id = 'maquet' and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
			if llCount > 0 then
				FileWrite(li_FileNumLeading, "Added a '00' and found sku: " + lsSKU)
				liAddZero ++
			end if
		end if
	end if
	
	If llCount = 0 Then
		//messagebox('SKU Not in Item Master', lsSKU +", Supp: " +ldsSKUs.getItemString(llRowPos, "Supp_code"))
		//TEMPO! FileWrite(li_FileNum, "SKU: " + mid(lsSKU,3) + ", Supp: " +ldsSKUs.getItemString(llRowPos, "Supp_code"))
		//TEMPO - For continuing conversion, need to resolve SKU/NewSKU use to get right supplier (and to write right SKU to 'Missing' file)
		FileWrite(li_FileNum, "SKU: " + lsSKU + ", Supp: " +ldsSKUs.getItemString(llRowPos, "Supp_code"))
		liMissing ++
	elseif llCount = 1 then
		liUpdated ++
		select Supp_Code into :lsSupp from item_master where project_id = 'maquet' 
		and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
		//messagebox ("Found ONE new IM Record", "Supplier: " + lsSupp)
		//Update content set supp_code = :lsSupp where project_id = 'MAQUET' and sku = :lsSKU;
		//IF SQLCA.SQLCode = -1 THEN MessageBox("SQL error", SQLCA.SQLErrText)
		Update content set sku = :lsNewSKU, supp_code = :lsSupp where ro_no like 'MAQUET%' and sku = :lsSKU;
		
		/* TEMP - SKipping for Implementation
		Update Receive_Detail set supp_code = :lsSupp where ro_no like 'MAQUET%' and sku = :lsSKU;
		IF SQLCA.SQLCode = -1 THEN MessageBox("SQL error", SQLCA.SQLErrText)
		Update Receive_Putaway set supp_code = :lsSupp where ro_no like 'MAQUET%' and sku = :lsSKU;
		IF SQLCA.SQLCode = -1 THEN MessageBox("SQL error", SQLCA.SQLErrText)

		Update Delivery_Detail set supp_code = :lsSupp where do_no like 'MAQUET%' and sku = :lsSKU;
		IF SQLCA.SQLCode = -1 THEN MessageBox("SQL error", SQLCA.SQLErrText)
		Update Delivery_Picking set supp_code = :lsSupp where do_no like 'MAQUET%' and sku = :lsSKU;
		IF SQLCA.SQLCode = -1 THEN MessageBox("SQL error", SQLCA.SQLErrText)
		Update Delivery_Picking_Detail set supp_code = :lsSupp where do_no like 'MAQUET%' and sku = :lsSKU;
		IF SQLCA.SQLCode = -1 THEN MessageBox("SQL error", SQLCA.SQLErrText)
		Update Delivery_Packing set supp_code = :lsSupp where do_no like 'MAQUET%' and sku = :lsSKU;
		IF SQLCA.SQLCode = -1 THEN MessageBox("SQL error", SQLCA.SQLErrText)

		Update Transfer_Detail set supp_code = :lsSupp where to_no like 'MAQUET%' and sku = :lsSKU;
		IF SQLCA.SQLCode = -1 THEN MessageBox("SQL error", SQLCA.SQLErrText)
		Update Transfer_Detail_Content set supp_code = :lsSupp where to_no like 'MAQUET%' and sku = :lsSKU;
		IF SQLCA.SQLCode = -1 THEN MessageBox("SQL error", SQLCA.SQLErrText)
		*/
	else
		messagebox ("Found MORE than ONE new IM Record!!", "SKU: " + lsSKU)
	End If
next
messagebox ("Conversion", "Done with Content SKUs. Updated: " + string(liUpdated) +", Missing: " +string(liMissing))

/*------ Receive Detail/Putaway --------------------------------------------------------------------------------*/

//Create the datastore dynamically (no physical datastore object)
//ldsSKUs = Create Datastore		
ldsSKUs.reset()
sql_syntax = "select distinct SKU, Supp_Code from receive_detail where ro_no like 'MAQUET%' and Supp_code not in ('MAQUET', 'JH', 'MCP', 'MCC') order by sku"
//sql_syntax += " and complete_date > getdate() - " + lsDays

//messagebox("TEMPO", sql_syntax)
ldsSkus.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", Errors))
IF Len(Errors) > 0 THEN
	messagebox("TEMPO", "*** Unable to create datastore for ReceiveDetail records.~r~r" + Errors)
   Return - 1
END IF

ldsSKUs.SetTransObject(SQLCA)

llRowCount = ldsSKUs.Retrieve()

//messagebox("COUNT of ReceiveDetail", "Distinct SKUs needing Conversion: " + String(llRowCount))
st_validation.text = "Distinct SKUs needing Conversion in Receive Detail: " + String(llRowCount)

FileWrite(li_FileNum, "Receive Detail SKUs missing from new Item Master...")
for llRowPos = 1 to llRowCount
	liTCount ++
	if liTCount = 10 then
		st_validation.text = "Processing ReceiveDetail record " + string(llRowPos) + " out of " + String(llRowCount)
		litCount = 0
	end if
	lsSKU = ldsSKUs.getItemString(llRowPos, "SKU")
	lsSupp = ldsSKUs.getItemString(llRowPos, "Supp_code")
	
	lsNewSku = lsSKU
	Select Count(*) Into :llCount from item_master where project_id = 'maquet' and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
	if llCount = 0 then
		lsNewSku = '0' + lsSku
		Select Count(*) Into :llCount from item_master where project_id = 'maquet' and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
		if llCount > 0 then
			FileWrite(li_FileNumLeading, "Added a '0' and found sku: " + lsNewSKU)
			liAddZero ++
		else
			lsNewSku = '0' + lsNewSku
			Select Count(*) Into :llCount from item_master where project_id = 'maquet' and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
			if llCount > 0 then
				FileWrite(li_FileNumLeading, "Added a '00' and found sku: " + lsNewSKU)
				liAddZero ++
			end if
		end if
	end if
	
	If llCount = 0 Then
		//messagebox('SKU Not in Item Master', lsSKU +", Supp: " +ldsSKUs.getItemString(llRowPos, "Supp_code"))
		FileWrite(li_FileNum, "SKU: " + lsSKU + ", Supp: " + lsSupp)
		liMissing ++
	elseif llCount = 1 then
		liUpdated ++
		select Supp_Code into :lsSupp from item_master where project_id = 'maquet' 
		//and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsSKU;
		and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
		//Content updated above... Update content set supp_code = :lsSupp where project_id = 'MAQUET' and sku = :lsSKU;
		
		Update Receive_Detail set sku = :lsNewSKU, supp_code = :lsSupp where ro_no like 'MAQUET%' and sku = :lsSKU;
		Update Receive_Putaway set sku = :lsNewSKU, supp_code = :lsSupp where ro_no like 'MAQUET%' and sku = :lsSKU;

		Update Delivery_Detail set sku = :lsNewSKU, supp_code = :lsSupp where do_no like 'MAQUET%' and sku = :lsSKU;
		Update Delivery_Picking set sku = :lsNewSKU, supp_code = :lsSupp where do_no like 'MAQUET%' and sku = :lsSKU;
		Update Delivery_Picking_Detail set sku = :lsNewSKU, supp_code = :lsSupp where do_no like 'MAQUET%' and sku = :lsSKU;
		Update Delivery_Packing set sku = :lsNewSKU, supp_code = :lsSupp where do_no like 'MAQUET%' and sku = :lsSKU;

		Update Transfer_Detail set sku = :lsNewSKU, supp_code = :lsSupp where to_no like 'MAQUET%' and sku = :lsSKU;
		Update Transfer_Detail_Content set sku = :lsNewSKU, supp_code = :lsSupp where to_no like 'MAQUET%' and sku = :lsSKU;
	else
		messagebox ("Found MORE than ONE new IM Record!!", "SKU: " + lsSKU)
	End If
next
//Execute Immediate "COMMIT" using SQLCA;
messagebox ("TEMPO!", "Done with Receive Detail SKUs")

/*------ Delivery Detail/Picking/Picking_Detail/Packing --------------------------------------------------------------------------------*/

//Create the datastore dynamically (no physical datastore object)
//ldsSKUs = Create Datastore		
ldsSKUs.reset()
sql_syntax = "select distinct SKU, Supp_Code from delivery_detail where do_no like 'MAQUET%' and Supp_code not in ('MAQUET', 'JH', 'MCP', 'MCC')"

ldsSkus.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", Errors))
IF Len(Errors) > 0 THEN
	messagebox("TEMPO", "*** Unable to create datastore for Delivery Detail records.~r~r" + Errors)
   Return - 1
END IF

ldsSKUs.SetTransObject(SQLCA)

llRowCount = ldsSKUs.Retrieve()

messagebox("COUNT of Delivery Detail", "Distinct SKUs needing Conversion: " + String(llRowCount))

for llRowPos = 1 to llRowCount
	st_validation.text = "Processing DeliveryDetail record " + string(llRowPos) + " out of " + String(llRowCount)
	lsSKU = ldsSKUs.getItemString(llRowPos, "SKU")
	lsSupp = ldsSKUs.getItemString(llRowPos, "Supp_code")
	
	lsNewSku = lsSKU
	Select Count(*) Into :llCount from item_master where project_id = 'maquet' and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
	if llCount = 0 then
		lsNewSku = '0' + lsSku
		Select Count(*) Into :llCount from item_master where project_id = 'maquet' and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
		if llCount > 0 then
			FileWrite(li_FileNumLeading, "Added a '0' and found sku: " + lsSKU)
			liAddZero ++
		else
			lsNewSku = '0' + lsNewSku
			Select Count(*) Into :llCount from item_master where project_id = 'maquet' and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
			if llCount > 0 then
				FileWrite(li_FileNumLeading, "Added a '00' and found sku: " + lsSKU)
				liAddZero ++
			end if
		end if
	end if
	
	If llCount = 0 Then
		//messagebox('SKU Not in Item Master', lsSKU +", Supp: " +ldsSKUs.getItemString(llRowPos, "Supp_code"))
		FileWrite(li_FileNum, "SKU: " + lsSKU + ", Supp: " +ldsSKUs.getItemString(llRowPos, "Supp_code"))
		liMissing ++
	elseif llCount = 1 then
		liUpdated ++
		select Supp_Code into :lsSupp from item_master where project_id = 'maquet' 
		and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
		/* Content and Receipts updated above... 
		Update content set supp_code = :lsSupp where project_id = 'MAQUET' and sku = :lsSKU;		
		Update Receive_Detail set sku = :lsNewSKU, supp_code = :lsSupp where ro_no like 'MAQUET%' and sku = :lsSKU;
		IF SQLCA.SQLCode = -1 THEN MessageBox("SQL error (RD)", SQLCA.SQLErrText)
		Update Receive_Putaway set sku = :lsNewSKU, supp_code = :lsSupp where ro_no like 'MAQUET%' and sku = :lsSKU;
		IF SQLCA.SQLCode = -1 THEN MessageBox("SQL error (RP)", SQLCA.SQLErrText)
		*/
		Update Delivery_Detail set sku = :lsNewSKU, supp_code = :lsSupp where do_no like 'MAQUET%' and sku = :lsSKU;
		Update Delivery_Picking set sku = :lsNewSKU, supp_code = :lsSupp where do_no like 'MAQUET%' and sku = :lsSKU;
		Update Delivery_Picking_Detail set sku = :lsNewSKU, supp_code = :lsSupp where do_no like 'MAQUET%' and sku = :lsSKU;
		Update Delivery_Packing set sku = :lsNewSKU, supp_code = :lsSupp where do_no like 'MAQUET%' and sku = :lsSKU;

		Update Transfer_Detail set sku = :lsNewSKU, supp_code = :lsSupp where to_no like 'MAQUET%' and sku = :lsSKU;
		Update Transfer_Detail_Content set sku = :lsNewSKU, supp_code = :lsSupp where to_no like 'MAQUET%' and sku = :lsSKU;
	else
		messagebox ("Found MORE than ONE new IM Record!!", "SKU: " + lsSKU)
	End If
next
messagebox ("Conversion", "Done with Delivery Detail SKUs")

/*------ Transfer Detail/Detail_content --------------------------------------------------------------------------------*/

//Create the datastore dynamically (no physical datastore object)
ldsSKUs.reset()
sql_syntax = "select distinct SKU, Supp_Code from transfer_detail where to_no like 'MAQUET%' and Supp_code not in ('MAQUET', 'JH', 'MCP', 'MCC')"

ldsSkus.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", Errors))
IF Len(Errors) > 0 THEN
	messagebox("TEMPO", "*** Unable to create datastore for Delivery Detail records.~r~r" + Errors)
   Return - 1
END IF

ldsSKUs.SetTransObject(SQLCA)

llRowCount = ldsSKUs.Retrieve()

messagebox("COUNT of Transfer Detail", "Distinct SKUs needing Conversion: " + String(llRowCount))

for llRowPos = 1 to llRowCount
	st_validation.text = "Processing Transfer record " + string(llRowPos) + " out of " + String(llRowCount)
	lsSKU = ldsSKUs.getItemString(llRowPos, "SKU")
	lsSupp = ldsSKUs.getItemString(llRowPos, "Supp_code")

	lsNewSku = lsSKU
	Select Count(*) Into :llCount from item_master where project_id = 'maquet' and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
	if llCount = 0 then
		lsNewSku = '0' + lsSku
		Select Count(*) Into :llCount from item_master where project_id = 'maquet' and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
		if llCount > 0 then
			FileWrite(li_FileNumLeading, "Added a '0' and found sku: " + lsSKU)
			liAddZero ++
		else
			lsNewSku = '0' + lsNewSku
			Select Count(*) Into :llCount from item_master where project_id = 'maquet' and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
			if llCount > 0 then
				FileWrite(li_FileNumLeading, "Added a '00' and found sku: " + lsSKU)
				liAddZero ++
			end if
		end if
	end if
	
	If llCount = 0 Then
		//messagebox('SKU Not in Item Master', lsSKU +", Supp: " +ldsSKUs.getItemString(llRowPos, "Supp_code"))
		FileWrite(li_FileNum, "SKU: " + lsSKU + ", Supp: " +ldsSKUs.getItemString(llRowPos, "Supp_code"))
		liMissing ++
	elseif llCount = 1 then
		liUpdated ++
		select Supp_Code into :lsSupp from item_master where project_id = 'maquet' 
		and Supp_code in ('MAQUET', 'JH', 'MCP', 'MCC') and sku = :lsNewSKU;
		/* Content, Receipts and Deliveries updated above... 		*/

		Update Transfer_Detail set sku = :lsNewSKU, supp_code = :lsSupp where to_no like 'MAQUET%' and sku = :lsSKU;
		Update Transfer_Detail_Content set sku = :lsNewSKU, supp_code = :lsSupp where to_no like 'MAQUET%' and sku = :lsSKU;
	else
		messagebox ("Found MORE than ONE new IM Record!!", "SKU: " + lsSKU)
	End If
next

messagebox("Conversion", "DONE. " + string(liUpdated) + " records were updated. There were " + string(liMissing) + " missing records.")


st_validation.text = "DONE. " + string(liUpdated) + " records were updated (adding '0' or '00' to " + string(liAddZero) +"). There were " + string(liMissing) + " missing records."


end event

type cb_option1 from commandbutton within w_import
boolean visible = false
integer x = 1902
integer y = 1900
integer width = 430
integer height = 80
integer taborder = 120
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
end type

event clicked;
dw_import.TriggerEvent('ue_cmd_option_1')
end event

type cb_print from commandbutton within w_import
integer x = 1413
integer y = 1844
integer width = 247
integer height = 76
integer taborder = 110
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;Parent.TriggerEvent('ue_print')
end event

type cb_archive from commandbutton within w_import
integer x = 55
integer y = 1940
integer width = 315
integer height = 76
integer taborder = 140
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Archive..."
end type

event clicked;Parent.TriggerEvent("ue_archive")
end event

type cb_help from commandbutton within w_import
integer x = 1413
integer y = 1940
integer width = 247
integer height = 76
integer taborder = 130
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Help"
end type

event clicked;ShowHelp(g.is_helpfile,topic!,543) /*open by topic ID*/
end event

type cb_insert from commandbutton within w_import
integer x = 1001
integer y = 1844
integer width = 265
integer height = 76
integer taborder = 130
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I&nsert"
end type

event clicked;Long	llNewRow

llNewRow = dw_import.Getrow()
dw_import.InsertRow(llNewRow)
dw_import.SetFocus()
dw_import.SetRow(llNewRow)
dw_import.ScrollToRow(llNewRow)
dw_import.SetColumn(1)


// 07/07 - PCONKL - want to amke sure that we can save if we have only inserted a row instead of importing
If ibProcessOnServer Then
	cb_save.Enabled = True
Else
	cb_validate.Enabled = True
End If
end event

type cb_delete from commandbutton within w_import
integer x = 1001
integer y = 1940
integer width = 265
integer height = 76
integer taborder = 140
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;parent.TriggerEvent("ue_delete")
end event

type st_validation from statictext within w_import
integer x = 87
integer y = 1760
integer width = 3200
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_import
integer x = 2971
integer y = 1900
integer width = 279
integer height = 76
integer taborder = 120
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;
If isvalid(w_import_Errors) Then close(w_import_errors)

ibCancel = True
Close(Parent)
end event

type cb_ok from commandbutton within w_import
integer x = 2587
integer y = 1900
integer width = 247
integer height = 76
integer taborder = 110
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;
Close(parent)
end event

type cb_save from commandbutton within w_import
integer x = 539
integer y = 1940
integer width = 247
integer height = 76
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save"
end type

event clicked;
If isvalid(w_import_Errors) Then close(w_import_errors)

If ibprocessonserver Then
	parent.TriggerEvent("ue_save_server")
Else
	parent.TriggerEvent("ue_save")
End If
end event

type cb_validate from commandbutton within w_import
integer x = 539
integer y = 1844
integer width = 247
integer height = 76
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Validate"
end type

event clicked;// 02/07 - PCONKL - We may be processing certain imports on Websphere, triggered from Save

If Not ibprocessonserver Then
	parent.TriggerEvent("ue_validate")
End If
end event

type cb_import from commandbutton within w_import
integer x = 55
integer y = 1844
integer width = 315
integer height = 76
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Import..."
end type

event clicked;If isvalid(w_import_Errors) Then close(w_import_errors)

parent.triggerEvent("ue_import")
end event

type dw_layout_list from datawindow within w_import
integer x = 14
integer y = 16
integer width = 1605
integer height = 100
integer taborder = 150
string dataobject = "d_import_layout_list"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;
Parent.PostEvent("ue_set_dw")
end event

