HA$PBExportHeader$w_shipments.srw
$PBExportComments$Shipments
forward
global type w_shipments from w_std_master_detail
end type
type tab_locations from tab within tabpage_main
end type
type tabpage_origin from userobject within tab_locations
end type
type dw_origin from u_dw_ancestor within tabpage_origin
end type
type tabpage_origin from userobject within tab_locations
dw_origin dw_origin
end type
type tabpage_dest from userobject within tab_locations
end type
type dw_dest from u_dw_ancestor within tabpage_dest
end type
type tabpage_dest from userobject within tab_locations
dw_dest dw_dest
end type
type tab_locations from tab within tabpage_main
tabpage_origin tabpage_origin
tabpage_dest tabpage_dest
end type
type cb_geteta from commandbutton within tabpage_main
end type
type cb_getetd from commandbutton within tabpage_main
end type
type cb_etamaint from commandbutton within tabpage_main
end type
type dw_master from u_dw_ancestor within tabpage_main
end type
type sle_awb from singlelineedit within tabpage_main
end type
type st_shipment_awb_bol_nbr from statictext within tabpage_main
end type
type cb_shipment_clear from commandbutton within tabpage_search
end type
type cb_shipment_search from commandbutton within tabpage_search
end type
type dw_search_result from u_dw_ancestor within tabpage_search
end type
type dw_search_entry from datawindow within tabpage_search
end type
type tabpage_order from userobject within tab_main
end type
type cb_otmchanged from commandbutton within tabpage_order
end type
type dw_packprint from datawindow within tabpage_order
end type
type dw_order from u_dw_ancestor within tabpage_order
end type
type cb_confirm from commandbutton within tabpage_order
end type
type cb_printci from commandbutton within tabpage_order
end type
type cb_delete_order from commandbutton within tabpage_order
end type
type cb_clearall_orders from commandbutton within tabpage_order
end type
type cb_selectall_orders from commandbutton within tabpage_order
end type
type st_1 from statictext within tabpage_order
end type
type cb_printpack from commandbutton within tabpage_order
end type
type cb_add from commandbutton within tabpage_order
end type
type tabpage_order from userobject within tab_main
cb_otmchanged cb_otmchanged
dw_packprint dw_packprint
dw_order dw_order
cb_confirm cb_confirm
cb_printci cb_printci
cb_delete_order cb_delete_order
cb_clearall_orders cb_clearall_orders
cb_selectall_orders cb_selectall_orders
st_1 st_1
cb_printpack cb_printpack
cb_add cb_add
end type
type tabpage_detail from userobject within tab_main
end type
type st_double_click_on_order_to_edit from statictext within tabpage_detail
end type
type cb_clearall_detail from commandbutton within tabpage_detail
end type
type cb_selectall_detail from commandbutton within tabpage_detail
end type
type cb_delete_orders from commandbutton within tabpage_detail
end type
type cb_add_orders from commandbutton within tabpage_detail
end type
type dw_detail from u_dw_ancestor within tabpage_detail
end type
type tabpage_detail from userobject within tab_main
st_double_click_on_order_to_edit st_double_click_on_order_to_edit
cb_clearall_detail cb_clearall_detail
cb_selectall_detail cb_selectall_detail
cb_delete_orders cb_delete_orders
cb_add_orders cb_add_orders
dw_detail dw_detail
end type
type tabpage_status from userobject within tab_main
end type
type cb_orphans from commandbutton within tabpage_status
end type
type cb_clearall_status from commandbutton within tabpage_status
end type
type cb_selectall_status from commandbutton within tabpage_status
end type
type cb_delete_status from commandbutton within tabpage_status
end type
type cb_add_status from commandbutton within tabpage_status
end type
type dw_status from u_dw_ancestor within tabpage_status
end type
type tabpage_status from userobject within tab_main
cb_orphans cb_orphans
cb_clearall_status cb_clearall_status
cb_selectall_status cb_selectall_status
cb_delete_status cb_delete_status
cb_add_status cb_add_status
dw_status dw_status
end type
type tabpage_bol from userobject within tab_main
end type
type cb_bol_print from commandbutton within tabpage_bol
end type
type cb_generate_bol from commandbutton within tabpage_bol
end type
type dw_bol_prt from u_dw_ancestor within tabpage_bol
end type
type dw_bol_entry from datawindow within tabpage_bol
end type
type tabpage_bol from userobject within tab_main
cb_bol_print cb_bol_print
cb_generate_bol cb_generate_bol
dw_bol_prt dw_bol_prt
dw_bol_entry dw_bol_entry
end type
end forward

global type w_shipments from w_std_master_detail
integer width = 3814
integer height = 2365
string title = "Shipments"
event ue_print_bol ( )
event ue_process_bol ( )
end type
global w_shipments w_shipments

type variables

w_shipments	iw_window
u_nvo_shipments	iu_Shipments
SingleLineEdit	Isle_AWB
DataWindow	Idw_Main, Idw_Detail, Idw_Status, Idw_Search, Idw_Result, Idw_Origin, Idw_Dest,  idw_bol, idw_Order, idw_packPrint //Jxlim 12/22/2011 Pandora-OTM #337 order tab
DataStore ids_do_main, ids_do_other,ids_do_detail,  ids_pick, ids_pack, ids_serial   //Jxlim 12/22/2011 Pandora-OTM #337 Datawindow from w_do

String 	isOrigSQL, isShipNo, is_OldNew, is_bolno, is_dono, is_text[], isrodono
Boolean	ibOrdersAdded, ibStatChanged, ibAWBChanged, ibZipChanged, ibCarrierChanged, ibMorkKitOrder, ib_UpdateOrderRemoveStatus
integer	ii_bol_current_page, ii_bol_current_row



end variables

forward prototypes
public function integer wf_clear_screen ()
public function integer wf_validation ()
public function integer wf_check_status ()
public function integer wf_process_bol_3com ()
public function integer uf_print_bol_3com ()
public function integer wf_check_bol_new_page ()
public function boolean f_packprint_pandora ()
public function integer wf_create_inbound (ref datastore adwmain, string asdono)
public function string pandora_getwarehouse (string as_cust)
public function string pandora_getowner (string astype, string asvalue)
public function integer wf_lock (boolean ab_lock)
end prototypes

event ue_print_bol();

idw_bol.accepttext() 
	
//uf_print_bol_3com()
			
OpenWithParm(w_dw_print_options,idw_bol)
	

end event

event ue_process_bol();Long	llCount
Decimal ldWeight,ld_tot
String	lsInvoiceNo, lsDONO,	lsBOLDesc,ls_wh_code,ls_shipper,ls_bol_carrier
string ls_note,ls_carrier,ls_carrier_code, ls_weight           			 //GAP 9/26/03
string ls_type,ls_name, ls_address_1,ls_address_2,ls_address_3,ls_address_4,ls_city,ls_state,ls_country,ls_zip 
int li_rtn,i,li_row
U_Nvo_Custom_BOL	lu_BOL
datastore lds_po, lds_po_multi
integer li_rtn2, li_idx
string ls_po, ls_po_list, lsBOL, lsBT
boolean lb_multi_run
integer li_rtn3, li_idx2

datastore ldsSKUs
string ls_sql_syntax_SKU, lsTemp, lsHazCd, ERRORS
long llSKUCount

lu_bol = Create u_nvo_Custom_Bol

// Set Defaults
is_OldNew = "NEW"
tab_main.tabpage_bol.dw_bol_entry.visible = False

////GAP 05/03  Get the BOL Ready for Print
//CHOOSE CASE upper(gs_project)
//	// pvh - 10/05/06 - petco	
//	CASE "PETCO"
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_petco_bol_prt'	
//		// pvh - 08/10/06 - PowerOfDream :)
//	case "PWROFDREAM"	
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_powerofthedream_bol_prt'
////	CASE "SEARS-FIX"
////		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_sears_bol_prt'
//	CASE "PHXBRANDS"
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_phxbrands_bol_prt'
//	CASE "AMBIT"
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_ambit_bol_prt'	
//		 i_order.POST of_generate_ambit_bol(idw_pack,idw_bol)
//	CASE "GM_MONTRY"                                                //wason 11/22
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_gm_bol_prt'//wason 11/22
////	CASE "LINKSYS"
////		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_linksys_bol_prt'
//	CASE "LOGITECH"
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_logitech_bol_prt'
//	CASE "GM-BATTERY"  //TAM 2004/12/06
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_gmbattery_bol_prt'
//	CASE "GLOBALRUSH"  //TAM 2004/12/14
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_globalrush_bol_prt'
//	CASE "BLUECOAT"  // pvh - 09/15/06
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_bluecoat_bol_prt'
//	CASE "INGRAM"  // tam - 2007/05/31
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_generic_bol_prt'
//	CASE "SCITEX-IID"  // tam - 10/11/06
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_scitex_bol_new_prt'
//	CASE "NYCSP"  // tam - 08/09/2007
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_generic_bol_prt'
//	CASE "COTY"  // tam - 08/09/2007
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_generic_bol_prt'
//	CASE "SMYRNA-MU" //TAM - 2007/05/09
//		ls_wh_code= idw_main.object.wh_code[1]
//		CHOOSE CASE upper(ls_wh_code)
//			Case "IBCC"
//				tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_smyrna-mu-ibcc_bol_prt'
//			Case Else
//				tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_smyrna-mu_bol_prt'
//		END CHOOSE
//	Case "NETAPP" /* 07/07 - PCONKL*/
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_netapp_sli_prt'
//	Case "SIKA" /* 12/07 - dts */
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_sika_bol_prt'
//	Case "EUT" /* 07/08 - MEA*/
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_eut_outbound_delivery_prt'		
//	Case "RUN-WORLD" /* 07/08 - MEA*/
//		tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_rw_outbound_delivery_prt'			
////	CASE else
////		is_OldNew = "OLD"
////		tab_main.tabpage_bol.dw_bol_entry.visible = True
//	Case 'DIEBOLD'
//			tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_diebold_bol_prt'
//
//END CHOOSE

//Save changes first
If ib_changed Then
	messagebox(is_title,'Please save changes before generating BOL!')
	return
End If

ls_wh_code= idw_main.object.wh_code[1]
//gap 5/2003 NEW BOL PROCESS get out if no picking list yet!
if 	is_OldNew = "NEW" then 
	
	If idw_detail.RowCount() > 0 Then
	Else
		Messagebox("Validation Error","You must create a picking list before you can generate the BOL!")
		tab_main.tabpage_bol.cb_bol_print.Enabled = False /*Disable printing of BOL*/
		Return
	End If
	
  CHOOSE CASE upper(gs_project)                                   
	
	CASE  '3COM_NASH'                                           
		
				
		wf_process_bol_3COM()


 END CHOOSE                                                              
 

end if // gap 5/2003 end of OLD BOL ******************************************

tab_main.tabpage_bol.cb_bol_print.Enabled = True /*Enable printing of BOL*/	


end event

public function integer wf_clear_screen ();
idw_main.Reset()
idw_Detail.Reset()
idw_status.Reset()
idw_Dest.Reset()
idw_Origin.Reset()


Return 0
end function

public function integer wf_validation ();
If idw_main.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	Return -1
End If
If idw_detail.AcceptText() = -1 Then 
	tab_main.SelectTab(2) 
	idw_detail.SetFocus()
	Return -1
End If
If idw_status.AcceptText() = -1 Then
	tab_main.SelectTab(3) 
	idw_status.SetFocus()
	Return -1
End If
  
 // Check if all required fields are filled
If f_check_required(is_title, idw_main) = -1 Then
	tab_main.SelectTab(1) 
	Return -1
End If

If f_check_required(is_title, idw_detail) = -1 Then
	tab_main.SelectTab(2) 
	Return -1
End If

If f_check_required(is_title, idw_status) = -1 Then
	tab_main.SelectTab(3) 
	Return -1
End If

//Other Required Fields
If isnull(idw_main.GetITemString(1,'wh_code')) or idw_main.GetITemString(1,'wh_code') = '' Then
	messagebox(is_title, 'Warehouse is Required')
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	idw_main.SetColumn('wh_Code')
	Return -1
End If

Return 0
end function

public function integer wf_check_status ();tab_main.Tabpage_Detail.Enabled = True
Tab_Main.Tabpage_Status.Enabled = True

if tab_main.tabpage_bol.Visible then
	tab_main.tabpage_bol.Enabled = True
end if

tab_main.tabpage_main.tab_locations.Show()

//Jxlim 06/22/2012 BRD #441 Set Shipment Ord_status based on order Ord_status
//All orders must be in Completed status 
String lsfind
long llrowcount, llFindRow

lsfind = "ord_status <> 'C'"
llrowcount = idw_order.Rowcount()
llFindRow =idw_Order.Find(lsfind,1, idw_order.Rowcount())	
		
//If any of the orders is not a complete status then set it to process.	
Do While llFindRow > 0		
	idw_main.SetItem(1,"ord_status", 'P')
	// Collect found row
		llFindRow++
		 // Prevent endless loop
		 IF llFindRow > llrowcount THEN EXIT
Loop
//Jxlim 06/22/2012 BRD #441 End of code

//Jxlim 05/10/2012 check for null status
String ls_status
ls_status = idw_main.GetItemString(1,"ord_status")

If isNull(ls_status) Then
	ls_status = ''
End If
//Choose Case idw_main.GetItemString(1,"ord_status")
Choose Case ls_status
	/* dts 051206 - replacing old check_status since 'N' is not valid and 'I' was never really used...
						 Now choosing between delivered, and everything else
	
	Case "N" /*New*/
		
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_refresh.Enabled = True
		
		If ib_edit Then
			im_menu.m_record.m_delete.Enabled = True
			im_menu.m_file.m_retrieve.Enabled = True			
		Else
			im_menu.m_record.m_delete.Enabled = False
			im_menu.m_file.m_retrieve.Enabled = False
		End If
		
		tab_main.tabpage_Detail.Enabled = True
		tab_main.tabpage_Status.Enabled = True
		
		tab_main.tabpage_Detail.cb_add_orders.Enabled = True
		tab_main.tabpage_Status.cb_add_status.Enabled = True
		
		tab_main.tabpage_Detail.cb_add_orders.Enabled = True
		tab_main.tabpage_Detail.cb_selectall_detail.Enabled = True
		tab_main.tabpage_Detail.cb_clearall_detail.Enabled = True
		
		tab_main.tabpage_Status.cb_add_status.Enabled = True
		tab_main.tabpage_Status.cb_selectall_status.Enabled = True
		tab_main.tabpage_Status.cb_clearall_status.Enabled = True
		
		idw_detail.object.datawindow.Readonly = false
		idw_status.object.datawindow.Readonly = False
		
	Case "I" /*In-Transit */
		
		tab_main.tabpage_Detail.cb_add_orders.Enabled = True
		tab_main.tabpage_Detail.cb_selectall_detail.Enabled = True
		tab_main.tabpage_Detail.cb_clearall_detail.Enabled = True
		
		tab_main.tabpage_Status.cb_add_status.Enabled = True
		tab_main.tabpage_Status.cb_selectall_status.Enabled = True
		tab_main.tabpage_Status.cb_clearall_status.Enabled = True
		
		idw_detail.object.datawindow.Readonly = false
		idw_status.object.datawindow.Readonly = False
		
	Case "D" /*Delivered*/
		
		tab_main.tabpage_Detail.cb_add_orders.Enabled = False
		tab_main.tabpage_Detail.cb_selectall_detail.Enabled = False
		tab_main.tabpage_Detail.cb_clearall_detail.Enabled = False
		
		tab_main.tabpage_Status.cb_add_status.Enabled = False
		tab_main.tabpage_Status.cb_selectall_status.Enabled = False
		tab_main.tabpage_Status.cb_clearall_status.Enabled = False
		
		idw_detail.object.datawindow.Readonly = True
		idw_status.object.datawindow.Readonly = True
	*/		
	
	//Jxlim 04/26/2012 BRD #404 Shipment screen lock - Pandora
	//When a shipment is first dropped (Shipment_Ord_status = $$HEX1$$1820$$ENDHEX$$N$$HEX2$$19202000$$ENDHEX$$or $$HEX1$$1820$$ENDHEX$$P$$HEX2$$19202000$$ENDHEX$$) to SIMS we need the following fields locked from edit 	
    	Case "N", "P" , ''  /*Shipment first drop to ship */					
		If gs_project = 'PANDORA' Then
			wf_lock(True)			
			idw_main.Enabled=True			
		Else 
			wf_lock(False)			
			idw_main.Enabled=False
		End IF
		im_menu.m_file.m_save.Enabled =True
	
	//Jxlim 04/26/2012 BRD #404 
	Case "C", "V"   /*Completed or Void lock shipment edit screen entirely. */
		If gs_project = 'PANDORA' Then
			wf_lock(True)
		Else 
			wf_lock(False)
		End IF	
		
	Case "D", "D1" /*Delivered*/
		
		tab_main.tabpage_Detail.cb_add_orders.Enabled = False
		tab_main.tabpage_Detail.cb_selectall_detail.Enabled = False
		tab_main.tabpage_Detail.cb_clearall_detail.Enabled = False
		
		tab_main.tabpage_Status.cb_add_status.Enabled = False
		tab_main.tabpage_Status.cb_selectall_status.Enabled = False
		tab_main.tabpage_Status.cb_clearall_status.Enabled = False
		
		idw_detail.object.datawindow.Readonly = True
		idw_status.object.datawindow.Readonly = True
		
		//Jxlim 04/26/2012 BRD #404 
		If gs_project = 'PANDORA' Then
			wf_lock(True)
		Else 
			wf_lock(False)
		End IF	
	Case else
		
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_refresh.Enabled = True
		
		If ib_edit Then
			im_menu.m_record.m_delete.Enabled = True
			im_menu.m_file.m_retrieve.Enabled = True			
		Else
			im_menu.m_record.m_delete.Enabled = False
			im_menu.m_file.m_retrieve.Enabled = False
		End If
		
		tab_main.tabpage_Detail.Enabled = True
		tab_main.tabpage_Status.Enabled = True

		if tab_main.tabpage_bol.Visible then
			tab_main.tabpage_bol.Enabled = True
		end if		
		
		
		tab_main.tabpage_Detail.cb_add_orders.Enabled = True
		tab_main.tabpage_Detail.cb_selectall_detail.Enabled = True
		tab_main.tabpage_Detail.cb_clearall_detail.Enabled = True
		
		tab_main.tabpage_Status.cb_add_status.Enabled = True
		tab_main.tabpage_Status.cb_selectall_status.Enabled = True
		tab_main.tabpage_Status.cb_clearall_status.Enabled = True
		
		idw_detail.object.datawindow.Readonly = false
		idw_status.object.datawindow.Readonly = False
		
		//Jxlim 04/26/2012 Pandora; reset if not fall into any of the above
		If gs_project = 'PANDORA' Then
			wf_lock(False)
		End If

End Choose

Return 0
end function

public function integer wf_process_bol_3com ();
Long	llCount, llRowCount, llRowPos, llBoxCount, ll_ctn_cnt
Decimal ldWeight,ld_tot
String	lsInvoiceNo, lsDONO,	lsBOLDesc,ls_wh_code,ls_shipper,ls_bol_carrier, lsCustPO, lsTemp, lsFind
string ls_note,ls_carrier,ls_carrier_code, ls_weight,        		lsCarton, lsCartonPRev	 
string ls_type,ls_name, ls_address_1,ls_address_2,ls_address_3,ls_address_4,ls_city,ls_state,ls_country,ls_zip, lsWHName 
int li_rtn,i,li_row, li_idx, li_detail_return, li_idx_new
decimal ld_weight,ld_total_weight, ld_total_pallet, ld_total_carton, ld_weight_gross

datastore ldsDOHeader, ldsDODetail, ldsDOPack

string  ls_ship_no, ls_reference

If Idw_Detail.Rowcount() <= 0 then return 0


//ldsDOHeader = Create Datastore
//ldsDOHeader.Dataobject = 'd_3com_shipment_bol_master'
//ldsDOHeader.SetTransObject(SQLCA)
//
//
//ldsDODetail = Create Datastore
//ldsDODetail.Dataobject = 'd_3com_bol_order_detail'
//ldsDODetail.SetTransObject(SQLCA)


ldsDOPack = Create Datastore
ldsDOPack.Dataobject = 'd_do_packing_grid'
ldsDOPack.SetTransObject(SQLCA)


if idw_main.GetITemString(1,'ord_type') = 'I' then
	
	MessageBox ("Error", "This is not a delivery order")
	
	Return -1
	
end if

ls_ship_no = idw_Main.GetItemString( 1, "ship_no")


	
If this.tab_main.tabpage_bol.dw_bol_prt.RowCount() = 0 Then      
	this.tab_main.tabpage_bol.dw_bol_prt.InsertRow(0)             
End If   

ii_bol_current_page = 1
ii_bol_current_row = 1


ldsDOHeader.Retrieve(ls_ship_no)

for li_idx = 1 TO ldsDOHeader.Rowcount()

	lsDONO = ldsDOHeader.GetItemString( li_idx, "rodo_no")
	

	//Set up the type

	if li_idx = 1 then
	

//		If  ldsDOHeader.GetITemString(1,'ord_type') = 'P' /*Tipping Point */ Then
//			tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_3com_tp_bol_shipment_prt'
//		else
			tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_3com_bol_shipment_prt'
//		end if

		tab_main.tabpage_bol.dw_bol_prt.SetTransObject(SQLCA)
		tab_main.tabpage_bol.dw_bol_prt.Retrieve( ls_ship_no)		
				
		
	end if

	
	wf_check_bol_new_page()
	
	
	
	ls_reference = ldsDOHeader.GetItemString( li_idx, "delivery_master_user_field6")
	
	tab_main.tabpage_bol.dw_bol_prt.SetItem(ii_bol_current_page, "c_reference" + string(ii_bol_current_row), ls_reference )

	ll_ctn_cnt =  ldsDOHeader.GetItemNumber( li_idx, "ctn_cnt" )

	tab_main.tabpage_bol.dw_bol_prt.SetItem(ii_bol_current_page, "c_ctn_cnt" + string(ii_bol_current_row), string(ll_ctn_cnt))



//	ls_reference = ldsDOHeader.GetItemString( li_idx, "delivery_detail_user_field5")
//	
//	tab_main.tabpage_bol.dw_bol_prt.SetItem(ii_bol_current_page, "c_cust_po" + string(ii_bol_current_row), ls_reference )

	llRowCount = ldsDODetail.Retrieve(lsDONO)
	
	For lLRowPos = 1 to llRowCount
			
		If ldsDODetail.GetITemString(lLRowPos,'user_field5') > '' Then
			lsFind = ' ' + ldsDODetail.GetITemString(lLRowPos,'user_field5') + ','
			If Pos(lsCustPo,lsFind) = 0 Then /*only need to print once per PO */
				lsCustPo += ldsDODetail.GetITemString(lLRowPos,'user_field5') + ", "
			End If
			
		End If
		
	Next /*delivery_detail Record*/
	
	//If not present on Details, Take from header
	If lsCustPo > '' Then
		lsCustPO = Left(lsCustPO,(len(lsCustPo) - 2)) /*strip off last comma*/
	Else
		lsCustPo = ldsDOHeader.GetITemString(1,'cust_order_no')
	End If	

		

	if ldsDOPack.Retrieve(lsDONO) > 0 then

			tab_main.tabpage_bol.dw_bol_prt.SetItem(ii_bol_current_page, "c_weight" + string(ii_bol_current_row), string( ldsDOPack.GetItemDecimal( 1, "c_weight"), "0.00000"))

	end if		
	
	
	Select Count(distinct carton_no) into :llCount
	From Delivery_packing
	Where do_no = :lsDONO and carton_type like "pallet%";
	
	If llCount > 0 Then
		
		ld_total_pallet = ld_total_pallet + llCOunt
		
		//Scroll through packing and sum box count (UF1) for unique carton 
		llRowCount = ldsDOPack.RowCount()
		For lLRowPos = 1 to llRowCount
			
			If ldsDOPack.GetITEmString(llRowPos,'carton_no') <> lsCartonPrev Then
				
				If isNumber(Trim(ldsDOPack.GetITEmString(llRowPos,'user_Field1'))) Then
					llBoxCount += Long(Trim(ldsDOPack.GetITEmString(llRowPos,'user_Field1')))
				End If
				
			End If
			
			lsCartonPrev = ldsDOPack.GetITEmString(llRowPos,'carton_no')
			
		Next
		
		ld_total_carton = ld_total_carton + llBoxCount
		
	Else
		
		Select Count(distinct carton_no) into :llCount
		From Delivery_packing
		Where do_no = :lsDONO ;
		
		ld_total_pallet = ld_total_pallet + 0
		ld_total_carton = ld_total_carton + llCOunt
		
	End IF



	//We may need to break the Cust PO list onto multiple lines
	If len(lsCustPO) > 40 Then
		
		//First row of 40
		lsTemp = Right(lsCustPo,40)
		lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
		tab_main.tabpage_bol.dw_bol_prt.setitem( ii_bol_current_page, "c_cust_po" + string(ii_bol_current_row),lstemp)
		lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
		
		If trim(lsTemp)  <> "" then
		
			ii_bol_current_row = ii_bol_current_row + 1
		
			wf_check_bol_new_page()
		
		
			//2nd row of 40
			If len(lsCustPo) > 40 Then
				lsTemp = Right(lsCustPo,40)
				If pos(lsTemp,',') > 0 Then
					lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
				End If
			Else
				lsTemp = lsCustPo
			End If
			
			tab_main.tabpage_bol.dw_bol_prt.setitem( ii_bol_current_page, "c_cust_po" + string(ii_bol_current_row),lstemp)
			lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
		
		End If

		If trim(lsTemp)  <> "" then	
	
			ii_bol_current_row = ii_bol_current_row + 1
	
			wf_check_bol_new_page()
	
			//3rd row of 40
			If len(lsCustPo) > 40 Then
				lsTemp = Right(lsCustPo,40)
				If pos(lsTemp,',') > 0 Then
					lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
				End If
			Else
				lsTemp = lsCustPo
			End If
			
			tab_main.tabpage_bol.dw_bol_prt.setitem( ii_bol_current_page, "c_cust_po" + string(ii_bol_current_row),lstemp)
			lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))

		End If
		
		If trim(lsTemp)  <> "" then		
		
			ii_bol_current_row = ii_bol_current_row + 1	
		
			wf_check_bol_new_page()		
		
			//4th row of 40
			If len(lsCustPo) > 40 Then
				lsTemp = Right(lsCustPo,40)
				If pos(lsTemp,',') > 0 Then
					lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
				End If
			Else
				lsTemp = lsCustPo
			End If
			
			tab_main.tabpage_bol.dw_bol_prt.setitem( ii_bol_current_page, "c_cust_po" + string(ii_bol_current_row),lstemp)
			lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
		
		End If		
		
		If trim(lsTemp)  <> "" then
	
			ii_bol_current_row = ii_bol_current_row + 1
	
			wf_check_bol_new_page()
	
			//5th row of 40
			If len(lsCustPo) > 40 Then
				lsTemp = Right(lsCustPo,40)
				If pos(lsTemp,',') > 0 Then
					lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
				End If
			Else
				lsTemp = lsCustPo
			End If
			
			tab_main.tabpage_bol.dw_bol_prt.setitem( ii_bol_current_page, "c_cust_po" + string(ii_bol_current_row),lstemp)
			lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
		
		End If
		
	Else
		tab_main.tabpage_bol.dw_bol_prt.setitem( ii_bol_current_page, "c_cust_po" + string(ii_bol_current_row),lsCustPO)
	End If	
	
	
	ii_bol_current_row = ii_bol_current_row + 1	
	



//	If  ldsDOHeader.GetITemString(1,'ord_type') = 'P' /*Tipping Point */ Then
//	
//		lsWHName = this.tab_main.tabpage_bol.dw_bol_prt.GetITemString(1,'warehouse_wh_name')
//	
//		If Pos(Upper(lsWhName),'3COM') > 0 Then
//			lsWhName = Replace(lsWhName,Pos(Upper(lsWhName),'3COM'),4,'TippingPoint')
//		End If
//		
//		For llRowPos = 1 to this.tab_main.tabpage_bol.dw_bol_prt.RowCount()
//			this.tab_main.tabpage_bol.dw_bol_prt.SetItem(llRowPos,'warehouse_wh_name',lsWHNAme)
//			this.tab_main.tabpage_bol.dw_bol_prt.SetItem(llRowPos,'warehouse_wh_name_1',lsWHNAme)
//		Next
//		
//	End If /* Tipping Point*/
//	
//	If li_idx = 1 then	
//
//		ls_wh_code= ldsDOHeader.GetItemString(1, "wh_code")
//
//		select address_type,name, address_1, address_2, address_3, address_4, city, state, zip, country		
//		into :ls_type,:ls_name,:ls_address_1,:ls_address_2,:ls_address_3,:ls_address_4,:ls_city,:ls_state,:ls_zip,:ls_country 
//		from delivery_alt_address 
//		where project_id= :gs_project and do_no = :ls_do_no and address_type = 'IT';
//		
//		if ls_type='IT' then
//			this.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_cust_name',ls_name)
//			this.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_address_1',ls_address_1)
//			this.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_address_2',ls_address_2)
//			this.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_address_3',ls_address_3) //GAP 9/26
//			this.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_address_4',ls_address_4) //GAP 9/26
//			this.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_city',ls_city)
//			this.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_state',ls_state)
//			this.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_country',ls_country)
//			this.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_zip',ls_zip)
//		end if
//		
//		ls_carrier_code = ldsDOHeader.GetITemString(1,"carrier")       
//		SELECT carrier_name
//		into :ls_carrier
//		FROM carrier_master
//		WHERE 	( carrier_master.project_id = :gs_project )    AND  
//					( carrier_master.carrier_code = :ls_carrier_code );
//					
//		If isnull(ls_carrier)  or ls_carrier = "" Then ls_carrier = ls_carrier_code
//		
//		ls_note =  ldsDOHeader.GetITemString(1,"packlist_notes") 
//
//		llRowCount = ldsDODetail.RowCount()
//	
//	
//	end if
//	
//	ld_weight =  ldsDOHeader.GetItemNumber(1,"weight")
//		
//	if IsNull(ld_weight) then ld_weight = 0
//		
//	ld_total_weight = ld_total_weight+  ld_weight
//		
//	this.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "carrier",ls_carrier)	
//	this.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "special",ls_note)
//	
//	
//	
//	//If this.idw_main.GetITemString(1,'wh_Code') = '3COM-SIN' Then
//	//	this.tab_main.tabpage_bol.dw_bol_prt.setitem( 1,'Prono',this.idw_main.GetITemString(1,'awb_Bol_no'))
//	//End If
//	
//
//	
//	//We may need to break the Cust PO list onto multiple lines
//	If len(lsCustPO) > 40 Then
//		
//		//First row of 40
//		lsTemp = Right(lsCustPo,40)
//		lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
//		this.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "c_cust_po1",lstemp)
//		lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
//		
//		//2nd row of 40
//		If len(lsCustPo) > 40 Then
//			lsTemp = Right(lsCustPo,40)
//			If pos(lsTemp,',') > 0 Then
//				lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
//			End If
//		Else
//			lsTemp = lsCustPo
//		End If
//		
//		this.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "c_cust_po2",lstemp)
//		lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
//		
//		//3rd row of 40
//		If len(lsCustPo) > 40 Then
//			lsTemp = Right(lsCustPo,40)
//			If pos(lsTemp,',') > 0 Then
//				lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
//			End If
//		Else
//			lsTemp = lsCustPo
//		End If
//		
//		this.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "c_cust_po3",lstemp)
//		lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
//		
//		//4th row of 40
//		If len(lsCustPo) > 40 Then
//			lsTemp = Right(lsCustPo,40)
//			If pos(lsTemp,',') > 0 Then
//				lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
//			End If
//		Else
//			lsTemp = lsCustPo
//		End If
//		
//		this.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "c_cust_po4",lstemp)
//		lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
//		
//		//5th row of 40
//		If len(lsCustPo) > 40 Then
//			lsTemp = Right(lsCustPo,40)
//			If pos(lsTemp,',') > 0 Then
//				lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
//			End If
//		Else
//			lsTemp = lsCustPo
//		End If
//		
//		this.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "c_cust_po5",lstemp)
//		lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
//		
//	Else
//		this.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "c_cust_po1",lsCustPO)
//	End If



next

for li_idx = 1 to tab_main.tabpage_bol.dw_bol_prt.RowCount() 

	this.tab_main.tabpage_bol.dw_bol_prt.SetITem(li_idx,'pallets', string(ld_total_pallet,"0.0"))
	this.tab_main.tabpage_bol.dw_bol_prt.SetITem(li_idx,'cartons', string(ld_total_carton,"0.0"))
	this.tab_main.tabpage_bol.dw_bol_prt.setitem( li_idx, "ActualWeight",string(ld_total_weight, "0.0"))

next


this.tab_main.tabpage_bol.dw_bol_prt.accepttext()							
			
this.tab_main.tabpage_bol.cb_bol_print.Enabled = True /*Enable printing of BOL*/	

destroy ldsDOPack


Return 0	

//---

//Long	llCount, llRowCount, llRowPos, llBoxCount
//Decimal ldWeight,ld_tot
//String	lsInvoiceNo, lsDONO,	lsBOLDesc,ls_wh_code,ls_shipper,ls_bol_carrier, lsCustPO, lsTemp, lsFind
//string ls_note,ls_carrier,ls_carrier_code, ls_weight,        		lsCarton, lsCartonPRev	 //GAP 9/26/03
//string ls_type,ls_name, ls_address_1,ls_address_2,ls_address_3,ls_address_4,ls_city,ls_state,ls_country,ls_zip, lsWHName 
//int li_rtn,i,li_row
//
//// 04/04 - PCONKL - SIN uses pre-printed shippers letter of intent instead of BOL
//Choose Case Upper (w_do.idw_main.GetITemString(1,'wh_Code'))
//	Case '3COM-SIN'
//		w_do.tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_3com_sli_prt'
//	Case Else
//		
//		// 01/08 - PCONKL - If a TippingPoint ORder, use the TiP BOL
//		If w_do.idw_main.GetITemString(1,'ord_type') = 'P' /*Tipping Point */ Then
//			w_do.tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_3com_tp_bol_prt'
//		Else
//			w_do.tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_3com_bol_prt'
//		End If
//		
//End CHoose
//
//ls_wh_code= w_do.idw_main.object.wh_code[1]
//lsDONO = w_do.idw_main.GetITemString(1,"do_no")                    //wason 9/25
//
//w_do.tab_main.tabpage_bol.dw_bol_prt.settransobject(sqlca)         //wason 9/25
//w_do.tab_main.tabpage_bol.dw_bol_prt.Retrieve(lsDONO)              //wason 9/25
//
//If w_do.tab_main.tabpage_bol.dw_bol_prt.RowCount() = 0 Then       //wason 9/25
//	w_do.tab_main.tabpage_bol.dw_bol_prt.InsertRow(0)              //wason 9/25
//End If                                                       		//wason 9/25
//		
////01/08 - PCONKL - If TippingPoint, we need to replace 3COM with TippingPoint in the Ship From Name
//If w_do.idw_main.GetITemString(1,'ord_type') = 'P' /*Tipping Point */ Then
//
//	lsWHName = w_do.tab_main.tabpage_bol.dw_bol_prt.GetITemString(1,'warehouse_wh_name')
//
//	If Pos(Upper(lsWhName),'3COM') > 0 Then
//		lsWhName = Replace(lsWhName,Pos(Upper(lsWhName),'3COM'),4,'TippingPoint')
//	End If
//	
//	For llRowPos = 1 to w_do.tab_main.tabpage_bol.dw_bol_prt.RowCount()
//		w_do.tab_main.tabpage_bol.dw_bol_prt.SetItem(llRowPos,'warehouse_wh_name',lsWHNAme)
//		w_do.tab_main.tabpage_bol.dw_bol_prt.SetItem(llRowPos,'warehouse_wh_name_1',lsWHNAme)
//	Next
//	
//End If /* Tipping Point*/
//
////gap 9/25/03 (pacific) Moved some of Wason's code from ue_printbol to show on screen before printing
//select address_type,name, address_1, address_2, address_3, address_4, city, state, zip, country		
//into :ls_type,:ls_name,:ls_address_1,:ls_address_2,:ls_address_3,:ls_address_4,:ls_city,:ls_state,:ls_zip,:ls_country 
//from delivery_alt_address 
//where project_id= :gs_project and do_no = :lsDONO and address_type = 'IT';
//
//if ls_type='IT' then
// 	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_cust_name',ls_name)
//   w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_address_1',ls_address_1)
//   w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_address_2',ls_address_2)
//	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_address_3',ls_address_3) //GAP 9/26
//   w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_address_4',ls_address_4) //GAP 9/26
//	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_city',ls_city)
//	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_state',ls_state)
//	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_country',ls_country)
//	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_zip',ls_zip)
//end if
//
////gap 9/26/03 get Carrier Name from Carrier table
//ls_carrier_code = w_do.idw_main.GetITemString(1,"carrier")         //GAP 9/26/03
//SELECT carrier_name
//into :ls_carrier
//FROM carrier_master
//WHERE 	( carrier_master.project_id = :gs_project )    AND  
//   		( carrier_master.carrier_code = :ls_carrier_code );
//			
//If isnull(ls_carrier)  or ls_carrier = "" Then ls_carrier = ls_carrier_code
//
//ls_note = w_do.idw_main.GetITemString(1,"packlist_notes") /* 09/04 - PCONKL - Take from DO Screen (loaded in sweeper) */
//
////gap 9/25 pacific
//If w_do.idw_pack.RowCount() > 0 Then																// gap 10/03
//	ls_weight = String(w_do.idw_pack.GetItemNumber(1,"c_weight")) // gap 10/03
//else
//	ls_weight =  "0"
//end if 		
//
//// gap 10/03
//w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "ActualWeight",ls_weight) // gap 10/03
//w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "carrier",ls_carrier)	
//w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "special",ls_note)
//
//If w_do.idw_main.GetITemString(1,'wh_Code') = '3COM-SIN' Then
//	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1,'Prono',w_do.idw_main.GetITemString(1,'awb_Bol_no'))
//End If
//
//// 03/05 - PCONKL - Customer PO's being loaded from Delivery Detail UF 5, not Customer Order number (unless it is not present on DD)
//llRowCount = w_do.idw_Detail.RowCount()
//For lLRowPos = 1 to llRowCount
//	
//	If w_do.idw_Detail.GetITemString(lLRowPos,'user_field5') > '' Then
//		lsFind = ' ' + w_do.idw_Detail.GetITemString(lLRowPos,'user_field5') + ','
//		If Pos(lsCustPo,lsFind) = 0 Then /*only need to print once per PO */
//			lsCustPo += w_do.idw_Detail.GetITemString(lLRowPos,'user_field5') + ", "
//		End If
//		
//	End If
//	
//Next /*delivery_detail Record*/
//
////If not present on Details, Take from header
//If lsCustPo > '' Then
//	lsCustPO = Left(lsCustPO,(len(lsCustPo) - 2)) /*strip off last comma*/
//Else
//	lsCustPo = w_do.idw_main.GetITemString(1,'cust_order_no')
//End If
//

//
////03/07 - PCONKL - Calculate Pallet and Box Count
//Select Count(distinct carton_no) into :llCount
//From Delivery_packing
//Where do_no = :lsDONO and carton_type like "pallet%";
//
//If llCount > 0 Then
//	
//	w_do.tab_main.tabpage_bol.dw_bol_prt.SetITem(1,'pallets', string(llCOunt))
//	
//	//Scroll through packing and sum box count (UF1) for unique carton 
//	llRowCount = w_do.idw_Pack.RowCount()
//	For lLRowPos = 1 to llRowCount
//		
//		If w_do.idw_Pack.GetITEmString(llRowPos,'carton_no') <> lsCartonPrev Then
//			
//			If isNumber(Trim(w_do.idw_Pack.GetITEmString(llRowPos,'user_Field1'))) Then
//				llBoxCount += Long(Trim(w_do.idw_Pack.GetITEmString(llRowPos,'user_Field1')))
//			End If
//			
//		End If
//		
//		lsCartonPrev = w_do.idw_Pack.GetITEmString(llRowPos,'carton_no')
//		
//	Next
//	
//	w_do.tab_main.tabpage_bol.dw_bol_prt.SetITem(1,'cartons', string(llBoxCount))
//	
//Else
//	
//	Select Count(distinct carton_no) into :llCount
//	From Delivery_packing
//	Where do_no = :lsDONO ;
//	
//	w_do.tab_main.tabpage_bol.dw_bol_prt.SetITem(1,'pallets', '0')
//	w_do.tab_main.tabpage_bol.dw_bol_prt.SetITem(1,'cartons', string(llCOunt))
//	
//End IF
//w_do.tab_main.tabpage_bol.dw_bol_prt.accepttext()							 //wason 9/25
//			
//w_do.tab_main.tabpage_bol.cb_bol_print.Enabled = True /*Enable printing of BOL*/	
//
//Return 0	
end function

public function integer uf_print_bol_3com ();String	lsPrinter
Long	llCopies

	

idw_bol.AcceptText()

idw_bol.SetITem(1,'c_print_ind','Y')
	
//If printing from doc print window, we may set the number of copies
If g.ilPrintCopies > 0 Then /* print ship docs window may set number of copies*/
	llCopies = g.ilPrintCopies
Else
	llCopies = 1
End If

If g.ibNoPromptPrint Then
	idw_bol.Object.DataWindow.Print.Copies = llCOpies
	Print(idw_bol)
Else
	OpenWithParm(w_dw_print_options,idw_bol) 
End If

lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','BOL',lsPrinter)


idw_bol.SetITem(1,'c_print_ind','N')

Return 0
end function

public function integer wf_check_bol_new_page ();integer li_idx_new

if ii_bol_current_row = 7 then
	
	tab_main.tabpage_bol.dw_bol_prt.RowsCopy(1, 1, Primary!, tab_main.tabpage_bol.dw_bol_prt, tab_main.tabpage_bol.dw_bol_prt.RowCount() + 1, Primary!)
	
	ii_bol_current_page = ii_bol_current_page + 1
	ii_bol_current_row = 1

	
	for li_idx_new = 1 to 6
		
		tab_main.tabpage_bol.dw_bol_prt.SetItem(ii_bol_current_page, "c_reference" + string(li_idx_new), "" )
		tab_main.tabpage_bol.dw_bol_prt.SetItem(ii_bol_current_page, "c_cust_po" + string(li_idx_new), "" )
		tab_main.tabpage_bol.dw_bol_prt.SetItem(ii_bol_current_page, "c_ctn_cnt" + string(li_idx_new), "" )
		 tab_main.tabpage_bol.dw_bol_prt.SetItem(ii_bol_current_page, "c_weight" + string(li_idx_new), "" )
				

			
	next
	
end if	

return 0
end function

public function boolean f_packprint_pandora ();// This event prints the Packing List which is currently visible on the screen 
// and not from the database - JC
 
// Any custom Pack Print routines are called from the clicked event of the print button
 
// pvh - 09/15/06 bluecoat
string trackingids = 'Tracking Ids: ', ls_noteline
string acomma = ", ", ls_notes
 
Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos, llNotesCount, llNotesPos, ll_ownercode, ll_ownerid

Decimal ld_weight, ld_costcenter, ld_cost
String ls_address,lsfind,ls_text[], lscusttype, lscustcode, lsSerial, lsNotes
String ls_project_id , ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName, lsDONO
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT, lsUPC, lsPrinter, lsVol, lsNativeDesc, lsGrp
String lsUserField14, lscust_name
Datastore       ldsHazmat, ldsNotes 
string ls_dono, ls_cost, ls_ownercode, ls_first_carton_row

ids_do_main = Create Datastore
ids_do_main.Dataobject = 'd_do_master'
ids_do_main.SetTransObject(SQLCA)

ids_do_other = Create Datastore
ids_do_other.Dataobject = 'd_do_master2'
ids_do_other.SetTransObject(SQLCA)

ids_do_detail = Create Datastore
ids_do_detail.Dataobject = 'd_do_detail'
ids_do_detail.SetTransObject(SQLCA)

ids_Pack = Create Datastore
ids_Pack.Dataobject = 'd_do_packing_grid'
ids_Pack.SetTransObject(SQLCA)

ids_serial = Create Datastore
ids_serial.Dataobject = 'd_do_outbound_serial'
ids_serial.SetTransObject(SQLCA)

SetPointer(HourGlass!)
If idw_order.AcceptText() = -1 Then
        tab_main.SelectTab(2) 
        idw_order.SetFocus()
        Return False
End If
 
If ib_changed then /* we want to make sure the validation routine is run before printing*/
        Messagebox(is_title,'Please save changes before printing Pack List.')
        Return false
End If
 
ids_do_main.Retrieve(is_dono)
ids_do_other.Retrieve(is_dono)
ids_do_detail.Retrieve(is_dono)	
ids_pack.Retrieve(is_dono)

//No row means no Print
ll_cnt = ids_pack.rowcount()
If ll_cnt = 0 Then
        MessageBox("Print Packing List"," No records to print!")
        Return false
End If
 
//Clear the Report Window (hidden datawindow)
idw_packprint.SetTransObject(SQLCA)
idw_packprint.Reset()

	ls_project_id = idw_main.getitemstring(1,"project_id")     
     lsWHCode = idw_main.getitemstring(1,"wh_code")
        
        Select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
        Into    :lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
        From warehouse
        Where WH_Code = :lsWHCode
        Using Sqlca;
		  
	 
////02/02 - PCONKL - Hazardous material stuff for GM hahn
//ldsHazmat = Create Datastore
//ldshazmat.dataobject = 'd_hazard_text'
//ldshazmat.SetTransObject(SQLCA)
// 
//lsTransPortMode= idw_main.GetITemString(1,'transport_Mode') /* used for printing haz mat info*/
	
	// Get the cost center.
	nvo_order lnvo_order
	lnvo_order = Create nvo_order
	lnvo_order.f_getcostcenter(1, ld_costcenter)
	Destroy lnvo_order

//Loop through each row in Tab pages and grab the coresponding info
For i = 1 to ll_cnt
        
        j = idw_packprint.InsertRow(0)        
 
        //Get SKU, Description and Quantities  04/05/00 PCONKL - include user field5 as pdc_whse_loc
        // 02/02 - PConkl - include hazardous text cd
        
        ls_sku = ids_pack.getitemstring(i,"sku")
        ls_supplier = ids_pack.getitemstring(i,"supp_code")
        llLineItemNo = ids_pack.GetITemNumber(i,'line_item_no')
        
        If ls_SKU <> lsSKUHold Then
                //10/11/2010 ujh adding user_Field14 to get the rest of description when printing the Packing tab for Pandora
                select description, weight_1, hazard_text_cd, part_upc_Code, user_field8, native_description, grp,isnull(User_field14, '')    /* 05/09 - PCONKL - UF8 = Volume for Philips */
                into :ls_description, :ld_weight, :lshazCode, :lsUPC, :lsVol, :lsnativeDesc, :lsGrp, :lsUserField14 
                from item_master 
                where project_id = :ls_project_id and sku = :ls_sku and supp_code = :ls_supplier ;
                
        End If /*Sku Changed*/
        
        lsSkuHold = ls_SKU
 
			If upper(gs_Project) = 'PANDORA'  Then   // 10/11/2010 ujh: Extending the Description when printing from the packing tab.
	      	  ls_description = trim(ls_description) + trim(lsUserField14)
			  lsUserField14 = ''
			Else 
				ls_description = trim(ls_description)
			End If
        
//        // 02/02 PCONKL - If there is hazardous material text for this SKU/Ship Method, retrieve the text for the report
//        lshazText = ''
//        If lshazCode > '' Then /*haz text exists for this sku*/
//                llhazCount = ldsHazmat.Retrieve(gs_project,lshazCode,lsTransportMode)
//                If llHazCount > 0 Then
//                        For llHazPos = 1 to llHazCount
//                                lsHazText += ldshazMat.GetItemString(llHazPos,'hazard_text') + '~r'
//                        Next
//                End If
//        End If /*haz text exists*/
 
         //Set all Items on the Report by grabbing info from tab pages
	
		//Get  full invoice_no //jxlim BRD #337 Pandora-OTM
	   //is_bolno = Right(ids_do_main.GetItemString(1,'invoice_no'),7)
	   is_bolno = ids_do_main.GetItemString(1,'invoice_no')
	   idw_packprint.setitem(j,"ord_no",ids_do_main.getitemstring(1,"cust_order_no"))				
        idw_packprint.setitem(j,"costcenter", string(ld_costcenter))
        idw_packprint.setitem(j,"carton_no",ids_pack.getitemString(i,"carton_no")) /*Printed report should show carton # from screen instead of row #*/	
        idw_packprint.setitem(j,"bol_no",is_bolno)
        idw_packprint.setitem(j,"freight_terms",ids_do_other.getitemstring(1,"freight_terms"))     
        idw_packprint.setitem(j,"cust_code",ids_do_other.getitemstring(1,"cust_code")) 
        idw_packprint.setitem(j,"city",idw_dest.getitemstring(1,"city"))
        idw_packprint.setitem(j,"country",idw_dest.getitemstring(1,"country"))
        idw_packprint.setitem(j,"ord_date",ids_do_main.getitemdatetime(1,"ord_date"))
        idw_packprint.setitem(j,"complete_date",ids_do_main.getitemdatetime(1,"complete_date"))		 
   	   idw_packprint.setitem(j,"schedule_date",ids_do_main.getitemdatetime(1,"schedule_date"))			
		
		  
        idw_packprint.setitem(j,"sku",ls_sku)    
        idw_packprint.setitem(j,"description",ls_description)
		  
		//TimA 08/04/11 Idenify Mork orders Issue #192
		If ids_do_other.GetItemString(1,'user_field21')='Y' then
			ibMorkKitOrder = True
		else
			ibMorkKitOrder = False
		end if
 
 		//TimA 08/09/11 Pandora issue #192
	  	//On MORK orders we are showing the children so the search for the parent won't work down below where the Find is.
		If ibMorkKitOrder = true then
			idw_packprint.setitem(j,"ord_qty",ids_pack.getitemNumber(i,"quantity"))
		end if
 
        idw_packprint.setitem(j,"unit_weight",ids_pack.getitemDecimal(i,"weight_net")) 		  
        idw_packprint.setitem(j,"standard_of_measure",ids_pack.getitemString(i,"standard_of_measure"))
        idw_packprint.setitem(j,"carrier", ids_do_other.getitemString(1,"carrier") )
        idw_packprint.setitem(j,"ship_via",ids_do_other.getitemString(1,"ship_via")) 
        idw_packprint.setitem(j,"sch_cd",ids_do_other.getitemString(1,"user_field1")) //schedule code
        idw_packprint.setitem(j,"packlist_notes",ids_do_main.getitemString(1,"packlist_notes")) 
	  	 //Jxlim 03/02/2012 BRD #337 Pandora-OTM set to blank when upc code is 0
		If lsUPC = '0' Then
			lsUPC = ''
		End If
	   idw_packprint.setitem(j,"upc_Code",lsUPC) 
        idw_packprint.setitem(j,"project_id",gs_project) 
        idw_packprint.setitem(j,"HazText",lshazText) 
		  
	    //Initialize screen for  English to Metrics (etom) values
	    is_text[1]=String(idw_packprint.Describe("unit_w_t.Text"))
	    is_text[2]=String(idw_packprint.Describe("ext_w_t.Text"))	
        //For English to Metrics changes added L or K based on E or M
        ls_etom=idw_packprint.getitemString(j,"standard_of_measure")
        IF ls_etom <> "" and not isnull(ls_etom) and j=1 THEN
                IF ls_etom = 'E' THEN
                        ls_text[1]="unit_w_t.Text='"+is_text[1]+"L'"                    
                        ls_text[2]="ext_w_t.Text='"+is_text[2]+"L'"
                        ls_text[3]="etom_t.Text='INCHES'"
                ELSE
                        ls_text[1]="unit_w_t.Text='"+is_text[1]+"K'"
                        ls_text[2]="ext_w_t.Text='"+is_text[2]+"K'"
                        ls_text[3]="etom_t.Text='CENTIMETERS'"
                END IF
        END IF  
        
        // 5/4/00 PCONKL - find matching row in detail to get ordered quantity and CNTL Number
        
        // 09/01 - PCONKL - we may have multiple pack rows that match to a single detail row. THis will cause the Order qty
        //                  to be wrong if we simply copy it for each row (it will be multiplied by each additional row). 
        //                                                If the ordered qty on the order detail = the shipped qty, we will just set the ord qty = shipped qty
        //                                                If Ord Qty > shipped qty, we will set the difference on the last row for the sku, the rest will be equal
        //                                              This assumes that the Shipped QTY on Packing List = Alloc QTY on DEtail. This will be validated before allowing to print (wf_val)
        
	  //TimA 08/09/11 See Comment Above on issue #192
	  //This find look for the sku in the detail screen however that contains the parent sku.  So on a MORK order it is not found and the quanities are not found.
        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLineItemNo)
        llRow = ids_do_detail.Find(lsFind,1,ids_do_detail.RowCount())
        
        if llRow > 0 Then
			 idw_packprint.setitem(j,"cntl_number",ids_do_detail.getitemString(llRow,"user_field1")) /* Cntrl num // detail Weight for Sears*/
                idw_packprint.setitem(j,"user_field2",ids_do_detail.getitemString(llRow,"user_field2")) /* 12/01 for Saltillo*/
                idw_packprint.setitem(j,"alt_sku",ids_do_detail.getitemString(llRow,"alternate_sku"))
            	 idw_packprint.setitem(j,"ord_qty",ids_do_detail.getitemnumber(llRow,"req_qty"))                      
        Else /*row not found (should never happen), set req qty to 0*/
                idw_packprint.setitem(j,"cntl_number",'')
        End If        
        idw_packprint.setitem(j,"picked_quantity",ids_pack.getitemNumber(i,"quantity"))         
	   idw_packprint.setitem(j,"volume",ids_pack.getitemDecimal(i,"cbm")) 
             
          //Jxlim 03/02/2012 Print Consolidated carton type once. BRD #337 Pandora-OTM  (Same carton type for multiple line)
		//On delivery screen the packing list is printed while the packing tab datawindow is open. Thus we can check the status on c_first_carton_row.
		//However this can not be done on Shipment screen, the shipment screen will get the value of 'Y' because it retrieves from ids_pack datastore not datawindow.
		//We will check the arton_no on shipment screen to supress duplicated value when a multiple row has the same carton_no. 
		//If ids_pack.getitemDecimal(i,"cbm") > 0 Then
         //idw_packprint.setitem(j,'dimensions',string(ids_pack.getitemDecimal(i,"length")) + ' x ' + string(ids_pack.getitemDecimal(i,"width")) + ' x ' + string(ids_pack.getitemDecimal(i,"height"))) /* 02/01 - PCONKL*/
        	//End If	  
		If ids_pack.getitemDecimal(i,"cbm") > 0 Then			
				If upper(gs_project) = 'PANDORA'  Then 		
					String ls_carton_no, ls_prev_carton_no
					ls_carton_no = ids_pack.getitemString(i,"carton_no")	
					If ls_carton_no <> ls_prev_carton_no Then
						  idw_packprint.setitem(j,'dimensions',string(ids_pack.getitemDecimal(i,"length")) + ' x ' + string(ids_pack.getitemDecimal(i,"width")) + ' x ' + string(ids_pack.getitemDecimal(i,"height"))) /* 02/01 - PCONKL*/
						  ls_prev_carton_no =	ls_carton_no
					End If		
				Else
					  idw_packprint.setitem(j,'dimensions',string(ids_pack.getitemDecimal(i,"length")) + ' x ' + string(ids_pack.getitemDecimal(i,"width")) + ' x ' + string(ids_pack.getitemDecimal(i,"height"))) /* 02/01 - PCONKL*/
				End If
		End If
		
        idw_packprint.setitem(j,"country_of_origin",ids_pack.getitemstring(i,"country_of_origin")) 
        idw_packprint.setitem(j,"supp_code",ids_pack.getitemstring(i,"supp_code")) 
        
        // 10/07 - PCONKL - Get Serial Numbers from serial tab(Outbound)
        If ids_serial.RowCount() > 0 Then
                
                lsSerial = ""
                lsFind = "Upper(Carton_No) = '" + Upper(ids_Pack.GetItemString(i,'carton_no')) + "' and line_item_No = " + String(ids_Pack.GetITemNumber(i,'line_item_No'))
                llFindRow = ids_serial.Find(lsFind,1,ids_serial.RowCOunt())
                Do While llFindRow > 0
                
                        lsSerial += ", " + ids_serial.GetItemString(llFindRow,'serial_no')
                
                        llFindRow ++
                        If llFindRow > ids_serial.RowCount() Then
                                lLFindRow = 0
                        Else
                                llFindRow = ids_serial.Find(lsFind,llFindRow,ids_serial.RowCOunt())
                        End If
                
                Loop
                
                If Left(lsSerial,2) = ', ' Then lsSerial = mid(lsSerial,3,999999999)
                idw_packprint.setitem(j,"serial_no",lsSerial)
        
        End If /*serial numbers exist*/
                
        //idw_packprint.setitem(j,"serial_no",idw_pack.getitemstring(i,"free_form_serial_no")) /* 02/01 - PCONKL*/
        
        idw_packprint.setitem(j,"component_ind",ids_pack.getitemstring(i,"component_ind")) /* 02/01 - PCONKL - sort component master to top*/
                
        idw_packprint.setitem(j,"cust_name",idw_dest.getitemstring(1,"name"))
        idw_packprint.setitem(j,"delivery_address1",idw_dest.getitemstring(1,"address_1"))
        idw_packprint.setitem(j,"delivery_address2",idw_dest.getitemstring(1,"address_2"))
        idw_packprint.setitem(j,"delivery_address3",idw_dest.getitemstring(1,"address_3"))
        idw_packprint.setitem(j,"delivery_address4",idw_dest.getitemstring(1,"address_4"))
        idw_packprint.setitem(j,"delivery_state",idw_dest.getitemstring(1,"state"))
        idw_packprint.setitem(j,"delivery_zip",idw_dest.getitemstring(1,"zip"))
       idw_packprint.setitem(j,"remark",ids_do_main.getitemstring(1,"remark"))
        
        // 07/00 PCONKL - Ship from info is coming from Project Table  
        idw_packprint.setitem(j,"ship_from_name",lsName)
        idw_packprint.setitem(j,"ship_from_address1",lsaddr1)
        idw_packprint.setitem(j,"ship_from_address2",lsaddr2)
        idw_packprint.setitem(j,"ship_from_address3",lsaddr3)
        idw_packprint.setitem(j,"ship_from_address4",lsaddr4)
        idw_packprint.setitem(j,"ship_from_city",lsCity)
        idw_packprint.setitem(j,"ship_from_state",lsstate)
        idw_packprint.setitem(j,"ship_from_zip",lszip)
        idw_packprint.setitem(j,"ship_from_country",lscountry)
 
        
		// LTK 20111129	Pandora #334 If the order type is a warehouse transfer and the 
		//						QA Pkg indicator is set, display a message on a line under the sku.
		if gs_Project = 'PANDORA' and ids_do_main.Object.ord_type[1] = 'Z' and ids_pack.Object.QA_Check_Ind[i] = 'P' then
			idw_packprint.setitem(j,"co_pkg_msg","GPN is flagged to check for Defective Packaging.  If packaging is defective please contact your Local CSR.")
			idw_packprint.Object.co_pkg_msg.visible = TRUE
			idw_packprint.Object.co_pkg_msg.y = 180	// Move the message down in the detail band so it's displayed.
		End if
		
		//GailM 1/2/2018 I357 F5734 S14571 PAN - HRI Alert for High Risk Inventory
		if gs_Project = 'PANDORA' and ids_pack.Object.QA_Check_Ind[i] = 'H' then
			idw_packprint.setitem(j,"co_pkg_msg","Attention! This is a High Risk Part.  Please follow Instruction according SWI WORK43225")
			idw_packprint.Object.co_pkg_msg.visible = TRUE
			idw_packprint.Object.co_pkg_msg.y = 180	// Move the message down in the detail band so it's displayed.
		End if
		
Next /*Packing Row */
        
/////////////////Packing Rows////////////////////////////////////////

// Declare the cursor.
DECLARE NOTES CURSOR FOR
select note_text
from delivery_notes
where project_id = :GS_Project and do_no = :is_dono ;

// Open the cursor
OPEN NOTES;

// If we can open the cursor,
If SQLCA.SQLCODE = 0 then
		
	// Fetch the record.
	Fetch NOTES into :ls_noteline;
	
	// Loop through the SIMS records.
	Do While SQLCA.SQLCODE<> 100
	
		ls_notes = ls_notes + " " + ls_noteline
		
		// Fetch the record.
		Fetch NOTES into :ls_noteline;
		
	// Next Sims record
	Loop
	
// End if we can open the cursor.
End If

// Close the cursor.
CLOSE NOTES;

// Notes
idw_packprint.setitem(j,"packlist_notes", ls_notes )
 
i=1
FOR i = 1 TO UpperBound(ls_text[])
        idw_packprint.Modify(ls_text[i])
        ls_text[i]=""
NEXT
 
idw_packprint.Sort()
idw_packprint.GroupCalc()
 
// 09/04 - PCONKL - If we have a default printer for PackList, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','PACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

idw_packprint.Object.t_costcenter.Y= long(idw_packprint.Describe("costcenter.y"))
 
//Send the report to the Print report window
OpenWithParm(w_dw_print_options,idw_packprint) 
 
// 09/04 - PCONKL - We want to store the last printer used for Printing the Pack List for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','PACKLIST',lsPrinter)
 
 
If message.doubleparm = 1 then
        If idw_main.GetItemString(1,"ord_status") = "N" or &
                idw_main.GetItemString(1,"ord_status") = "P" or &
                idw_main.GetItemString(1,"ord_status") = "I" Then 
                idw_main.SetItem(1,"ord_status","A")
                ib_changed = TRUE
                iw_window.trigger event ue_save()
        End If
End If
 
Return True
end function

public function integer wf_create_inbound (ref datastore adwmain, string asdono);//Jxlim 02/16/2012 BRD #337 Pandora -Otm clone this function from w_do

//  ***!!!NEED TO COMPLETE SETTING OF 'FROM PROJECT' (po_no --> RM.UF8)

//Create matching Inbound order into receiving Warehouse
/* dts - 08/26/05 - created from Bobcat's uf_create_inbound to be generic
	- still passing datawindow reference for ease of implementation
*/
Long			llNo, llRowCount, llRowPos, llFindRow, llNewRow, llLineItemNo, llOwner, llNewBatchSeq, llLinePos 
String		lsDONO, lsOrderNo, lsCarrier, lsWarehouse, lsAWB, lsSKU, lsSupplier, lsPO, lsDORONO, lsNewRoNO, lsErrText, lsSQL, &
				presentation_str, dwsyntax_str, lsCOO, lsInvoiceNo, lsSerialNo
string		lsOrdType //dts - 08/26/05
string		lsSubInventoryLoc, lsOwner, lsFromLoc, lsUF7, lsInvType, lsUF8, lsUF2, lsUF6, lsReceiveMasterUF6  // 02/09 - Pandora (lsUF8 added 5/04)
string		lsRemark // added 3/17/2010 for Pandora (sending DM.Remark to RM.Remark)
string		lsDOInvoice, lsShipRef,lsuf1,lsuf3,lsuf4 // TAM W&S 2011/04

DateTime		ldtToday
Decimal		ldQTY
Decimal{2}	ldPrice //TimA 07/12/11 Pandora Issue #255
Integer		liRC
Datastore	ldsDetail, ldsPickDetail

ldsDetail = Create Datastore
ldsDetail.Dataobject = 'd_ro_detail'
ldsDetail.SetTransObject(SQLCA)

// pvh 02.15.06
//ldtToday = DateTime(today(),Now())

//Jxlim 02/16/2012 BRD #337 Pandora-OTM
ids_do_main.Retrieve(asdono)
lsDONO = adwMain.GetItemString(1,'do_no')

//Retrieve the Delivery Picking records for this order
ldsPickDetail = Create Datastore
// 05/09 lsSQL =  "Select Line_Item_No, SKU, Supp_Code, Owner_ID, Country_of_Origin, ro_no, Quantity from Delivery_Picking_Detail "
// 08/09	lsSQL =  "Select Line_Item_No, SKU, Supp_Code, Owner_ID, Country_of_Origin, ro_no, Quantity, po_no from Delivery_Picking_Detail "
// 02/10 - Exclude component children
// TAM 2010/03/30 $$HEX1$$1320$$ENDHEX$$Excluding Delivery BOM children
//lsSQL =  "Select dpd.Line_Item_No, dpd.SKU, dpd.Supp_Code, dpd.Owner_ID, dpd.Country_of_Origin, ro_no, Quantity, dpd.po_no, dd.user_field6" 
// LTK 20111005 Pandora #297 add component_no
//lsSQL =  "Select dpd.Line_Item_No, dpd.SKU, dpd.Supp_Code, dpd.Owner_ID, dpd.Country_of_Origin, ro_no, Quantity, dpd.po_no, dd.user_field6" 
lsSQL =  "Select dpd.Line_Item_No, dpd.SKU, dpd.Supp_Code, dpd.Owner_ID, dpd.Country_of_Origin, ro_no, Quantity, dpd.po_no, dd.user_field6, dpd.component_ind " 

lsSQL += " from Delivery_Picking_Detail dpd, delivery_detail dd"
//lsSQL += " Where dpd.do_no = dd.do_no and dpd.Line_Item_No = dd.Line_Item_No and dpd.component_ind <> '*' and  dpd.component_ind <> 'W' "
// 4/27/10 - added clause for dpd.sku = dd.sku
//lsSQL += " Where dpd.do_no = dd.do_no and dpd.Line_Item_No = dd.Line_Item_No and dpd.sku = dd.sku and dpd.component_ind <> '*' and  dpd.component_ind <> 'W' "

// LTK 20110927	Pandora #297 exclude parents for MORK assemblies, include the children.
if gs_project = 'PANDORA' and Upper(Trim(adwMain.Object.user_field21[1])) = 'Y' then
	lsSQL += " Where dpd.do_no = dd.do_no and dpd.Line_Item_No = dd.Line_Item_No and dpd.component_ind <> 'Y' "
else
	lsSQL += " Where dpd.do_no = dd.do_no and dpd.Line_Item_No = dd.Line_Item_No and dpd.sku = dd.sku and dpd.component_ind <> '*' and  dpd.component_ind <> 'W' "
end if

lsSQL += " and dpd.do_no = '" + lsDONO + "'"

presentation_str = "style(type=grid)"

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)

ldsPickDetail.Create( dwsyntax_str, lsErrText)
ldsPickDetail.SetTransObject(SQLCA)

//Create a new Receive Master Record

//generate ro_no
llno = g.of_next_db_seq(gs_project,'Receive_Master','RO_No')
If llno <= 0 Then
	messagebox("Receive Order", "Unable to retrieve the next available order Number!")
	Return -1
End If
	
lsNewRONO = Trim(Left(gs_project,9)) + String(llno,"000000")
//TAM 2007/02/22 Use Delivery Order Number as Receive Order Number
//lsOrderNo = String(llNo,'000000')
lsOrderNo = adwMain.GetItemString(1,'Invoice_no')
lsCarrier = adwMain.GetItemString(1,'carrier') 
lsInvoiceNo = adwMain.GetItemString(1,'Invoice_no') 
lsAWB = adwMain.GetItemString(1,'awb_bol_no') 
//wf_validation will validate that cust_code in Delivery Master is a valid warehouse code for receiving into

llRowCount = ldsPickDetail.Retrieve() //moved from below to be available for setting of lsUF8 for Pandora...

lsOrdType = adwMain.GetItemString(1,'ord_type') 

if gs_project = 'PANDORA' then
//2009/07/08 TAM Added logic for the Return Defective to use the MRB warehouse code (Concatinate an 'M' on the end)
//2009/07/09 TAM Remove logic to create inbound order for return defective (Commenting out in case they change their mind again)
//   If lsOrdType = 'Y' Then
// 		lsSubInventoryLoc = adwMain.GetItemString(1, 'User_Field2') + 'M'
//		lsFromLoc = adwMain.GetItemString(1, 'user_field2') + 'M' 
//	Else
		lsSubInventoryLoc = adwMain.GetItemString(1, 'cust_code')
	//04-12-09 - now seeding DM.UF2 on interface...
		lsFromLoc = adwMain.GetItemString(1, 'user_field2') // should we get this from the owner (from a detail line)?
//	End If
		lsWarehouse = Pandora_GetWarehouse(lsSubInventoryLoc)  
	 	lsOwner = Pandora_GetOwner("ID", lsSubInventoryLoc)		
		lsUF7 = 'MATERIAL RECEIPT'
		
		// 03/17/10 - dts - for Pandora, now sending remark to inbound half of wh x-fer
		lsRemark = adwMain.GetItemString(1, 'remark')
		
		//MEA 9/20/2009
		//Named it lsReceiveMasterUF6 because there already is a lsReceiveMasterUF6 that is used on the Receive_Detail and didn't want to
		//changed anything with that code. Ian directed me on how this is to wok. Will have Dave review when he is back.
		
		// 10/09 - PCONKL - We dont really want to set Receive Master UF6 from the Header Level (at least for now!). Project really needs to come from the Detail Level
		
	//	lsReceiveMasterUF6 = adwMain.GetItemString( 1, "user_field8")
//12/09/09 UJHALL Removed: part of no more entries in UF6 and UF8 at header level for Pandora
//	if llRowCount > 0 then
//		lsUF8 = ldsPickDetail.GetItemString(1, 'po_no')  //what if there is more than one 'From Project'?
//	else
//		//message that there are no picking
//	end if
else
	lsWarehouse = adwMain.GetItemString(1,'cust_Code') 
end if


// pvh 02.15.06 - gmt
ldtToday = f_getLocalWorldTime( lsWarehouse ) 

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

if gs_project <> 'PANDORA' then
	//Supplier is hard-coded as 'N/A' since there could be multiple suppliers on the outbound order
	//  (RI requires Supplier to exist. Nulls are allowed, but then Search doesn't work)
	//if 'N/A' doesn't exist for this project, create it
	select supp_code into :lsSupplier
	from supplier
	where project_id = :gs_Project
	and supp_code = 'N/A';
	
	If isNull(lsSupplier) or lsSupplier = '' Then 
		insert into supplier(Project_id, Supp_code, Supp_Name, last_user, last_update)
		values (:gs_Project, 'N/A', 'Used For Warehouse Transfer', :gs_userid, :ldtToday)
		Using SQLCA;
	end if
	lsSupplier = 'N/A'
	lsInvType = 'N'
else
	lsSupplier = 'PANDORA'
	lsInvType = 'N' // tempo! get the inv type from outbound order (what about lines?)
end if

//TAM W&S 2011/04 
if left(gs_project,3) = 'WS-' then
	lsDOInvoice = adwMain.GetItemString(1,'Invoice_no')
		//TAM - W&S 2011/04  -   Order Number is Formatted.  We will not allow entry into this field.  
		//Format is (WH_CODE(4th and 5TH Char)) + "S" + (Year(2 digit)) + (Month(2 Digit)) + (4 Digit Running number from Lookup table) 
		//Left 2 characters = WS for Wine and Spirt.
	lsOrderNO =  Mid(gs_project,4,2) + '-A' + String(Today,'YYMM') + Right(string(llno,'0000'), 4) //TAM W&S 04/21/2011
	lsInvoiceNo = lsOrderNO
	lsSupplier = idw_detail.GetItemString(1,'supp_Code')
	lsShipRef = idw_detail.GetItemString(1,'User_field3') 
End If


//// TAM 6/26/2009  Create And EDI_INBOUND_HEADER for Return Defective order types.  Only the shell is needed since we are only trying to cary over the Defective Serial Number to Receiving
//// 09/07/09 TAM Remove logic to create inbound order for return defective (Commenting out in case they change their mind again)
//  //	If lsOrdType = 'Y' Then
//		llNewBatchSeq =  g.of_next_db_seq(gs_project,'EDI_Inbound_Header','EDI_Batch_Seq_No')
//	//Create a new EDI_Inbound_Header Record (just the shell needed to avoid FK violation on the detail records)
//		Execute Immediate "Begin Transaction" using SQLCA;
//		Insert Into EDI_Inbound_Header (project_id, edi_batch_seq_no, order_seq_no, order_no, status_cd, Status_message) 
//		values								(:gs_Project, :llNewBatchSeq, 1, :lsNewRONO, 'C', 'Return Replacement');
////		Execute Immediate "COMMIT" using SQLCA;
//	End If


/*
Insert Into Receive_Master (ro_no, project_id, ord_date, ord_status, ord_type, Inventory_type, wh_Code, Supp_Code, 
										Supp_Invoice_No, carrier, awb_bol_no, USer_field1, Request_Date,	Last_user, Last_Update, do_no)
										
//					Values		(:lsNewRONO, :gs_Project, :ldtToday, "N", "C", "N", :lsWareHouse, "BOBCAT", 
					Values		(:lsNewRONO, :gs_Project, :ldtToday, "N", :lsOrdType, "N", :lsWareHouse, "N/A", 
										:lsOrderNo, :lsCarrier, :lsAWB, :lsInvoiceNo, :ldtToday, :gs_userid, :ldtToday, :lsDONO)
										*/
/* For Pandora, set RM.UF2 = SubInventory Loc from Outbound Order
				    set RM.UF3 = From Location (user_field2)
				    set RM.UF7 = 'MATERIAL TRANSFER'
				    set Supplier to 'PANDORA') 
				    set RM.UF8 = From Project (po_no) */
//Added EDI_Batch Sequence Number to Link EDI Transaction  
//Insert Into Receive_Master (ro_no, project_id, ord_date, ord_status, ord_type, Inventory_type, wh_Code, Supp_Code, 
//										Supp_Invoice_No, carrier, awb_bol_no, USer_field1, User_Field2, user_field3, user_field7, user_field8, Request_Date,	Last_user, Last_Update, do_no)
//										
//					Values		(:lsNewRONO, :gs_Project, :ldtToday, "N", :lsOrdType, :lsInvType, :lsWareHouse, :lsSupplier, 
//										:lsOrderNo, :lsCarrier, :lsAWB, :lsInvoiceNo, :lsSubInventoryLoc, :lsFromLoc, :lsUF7, :lsUF8, :ldtToday, :gs_userid, :ldtToday, :lsDONO)

// 10/09 - PCONKL - Removed Setting of Receive Master.UF6 ('To Project'). This really needs to be handled at the Detail Level
	//12/09/09 UJHALL: For Pandora, moving UF3 to UF6 and removing UF8
	// 03/17/10 - dts - adding header-level remarks...
	// dts - 10/08/10 - adding crossdock_ind
string lsCrossdock
	lsCrossdock = adwMain.GetItemString(1, 'crossdock_ind')
	if gs_project = 'PANDORA' then
		//if left(Upper(lsOrderNo), 4) = 'FMOR' then // dts 10/14/10 - the Final Move Order (FMOR...) should not be recevied into general inventory - not cross-docked
		if left(Upper(lsOrderNo), 4) = 'FMOR'  or left(Upper(lsOrderNo), 4) = 'FMTR' then // dts 02/22/11 - added 'FMTR' to the condition.
			lsCrossdock = 'N'
		end if
		Insert Into Receive_Master (ro_no, project_id, ord_date, ord_status, ord_type, Inventory_type, wh_Code, Supp_Code, 
										Supp_Invoice_No, carrier, awb_bol_no, USer_field1, User_Field2, user_field6,  user_field7,  Request_Date,	create_user, Last_user, Last_Update, do_no, edi_batch_seq_no, Remark, crossdock_ind)
										
					Values		(:lsNewRONO, :gs_Project, :ldtToday, "N", :lsOrdType, :lsInvType, :lsWareHouse, :lsSupplier, 
										:lsOrderNo, :lsCarrier, :lsAWB, :lsInvoiceNo, :lsSubInventoryLoc, :lsFromLoc,  :lsUF7, :ldtToday, :gs_userid, :gs_userid, :ldtToday, :lsDONO, :llNewBatchSeq, :lsRemark, :lsCrossdock)
		Using SQLCA;
	else
// TAM W&S 2011/04  Added W&S and pop Ship Ref and blanked UF1
		if left(gs_project,3) = 'WS-' then
			Insert Into Receive_Master (ro_no, project_id, ord_date, ord_status, ord_type, Inventory_type, wh_Code, Supp_Code, 
										Supp_Invoice_No, carrier, awb_bol_no, USer_field1, User_Field2, user_field3,  user_field7, user_field8, Request_Date,	create_user, Last_user, Last_Update, do_no, edi_batch_seq_no, crossdock_ind,Ship_Ref)
										
					Values		(:lsNewRONO, :gs_Project, :ldtToday, "N", :lsOrdType, :lsInvType, :lsWareHouse, :lsSupplier, 
										:lsOrderNo, :lsCarrier, :lsAWB, '', :lsSubInventoryLoc, :lsFromLoc,  :lsUF7, :lsUF8, :ldtToday, :gs_userid, :gs_userid, :ldtToday, :lsDONO, :llNewBatchSeq, :lsCrossdock, :lsShipRef)
			Using SQLCA;
		Else
			Insert Into Receive_Master (ro_no, project_id, ord_date, ord_status, ord_type, Inventory_type, wh_Code, Supp_Code, 
											Supp_Invoice_No, carrier, awb_bol_no, USer_field1, User_Field2, user_field3,  user_field7, user_field8, Request_Date,	create_user, Last_user, Last_Update, do_no, edi_batch_seq_no, crossdock_ind)
										
						Values		(:lsNewRONO, :gs_Project, :ldtToday, "N", :lsOrdType, :lsInvType, :lsWareHouse, :lsSupplier, 
											:lsOrderNo, :lsCarrier, :lsAWB, :lsInvoiceNo, :lsSubInventoryLoc, :lsFromLoc,  :lsUF7, :lsUF8, :ldtToday, :gs_userid, :gs_userid, :ldtToday, :lsDONO, :llNewBatchSeq, :lsCrossdock)
			Using SQLCA;
		End If
	End If

If sqlca.sqlcode <> 0 Then
	lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Create Inbound", "Unable to save new Receiving Order to database!~r~r" + lsErrText)
	Return -1
End If

// LTK 20111005	Pandora #297 Need to set the user_line_item on the receiving order to the value stored in Delivery_BOM.
boolean lb_pandora_mork
if Upper(gs_project) = 'PANDORA' and Upper(Trim(adwMain.Object.user_field21[1])) = 'Y' then
	// A Pandora MORK order
	lb_pandora_mork = true
end if

datastore lds_delivery_bom_recs

if lb_pandora_mork then
	// Retrieve the Delivery_BOM records here for later use.
	string ls_sql
	presentation_str = "style(type=grid)"
	lds_delivery_bom_recs = CREATE datastore
	ls_sql =   " SELECT user_field1, sku_parent, sku_child, line_item_no "
	ls_sql += " FROM dbo.Delivery_BOM "
	ls_sql += " WHERE project_id = '" + gs_project + "' "
	ls_sql += " AND do_no = '" + lsDONO + "' "

	dwsyntax_str = SQLCA.SyntaxFromSQL(ls_sql, presentation_str, lsErrText)
	lds_delivery_bom_recs.Create( dwsyntax_str, lsErrText)
	lds_delivery_bom_recs.SetTransObject(SQLCA)	
	
	if  lds_delivery_bom_recs.Retrieve() < 0 then
		Messagebox("Create Inbound", "Unable to find child line item numbers for system number: "  + lsDONO)
		Return -1
	end if
end if
// end of Pandora #297 block

//Create a Receive Detail record for each SKU - loop by Pick Detail so we can include original PO (from RO_NO)

//now Retrieved above (for Pandora's po_no --> UF8)... llRowCount = ldsPickDetail.Retrieve()
For llRowPos = 1 to llRowCount
	
	lsSKU = ldsPickDetail.GetItemString(llRowPos,'SKU')
	lsSupplier = ldsPickDetail.GetItemString(llRowPos,'supp_Code')
	lsCoo = ldsPickDetail.GetItemString(llRowPos,'Country_of_Origin')
	ldQTY = ldsPickDetail.GetItemNumber(llRowPos,'Quantity')
	llLineItemNo = ldsPickDetail.GetItemNumber(llRowPos,'Line_Item_No')
// TAM W&S 2011/04 Added fields for wine and spirit
	if Left(gs_project,3) = 'WS-' then
		llFindRow = idw_detail.Find("Upper(sku) = '" + Upper(lsSKU) + "' and Line_Item_No = " + string(llLineItemNo), 1, idw_detail.RowCount())
		lsUF1 = idw_detail.GetItemString(llFindRow,'user_field1')
		lsUF2 = idw_detail.GetItemString(llFindRow,'user_field2')
		lsUF3 = idw_detail.GetItemString(llFindRow,'user_field7')
		lsUF4 = idw_detail.GetItemString(llFindRow,'user_field4')
	end if

	if gs_project = 'PANDORA' then
		//TimA 07/12/11 Pandora Issue #255
		//Get the order Delivery detail Price
		llFindRow = idw_detail.Find("Upper(sku) = '" + Upper(lsSKU) + "' and Line_Item_No = " + string(llLineItemNo), 1, idw_detail.RowCount())
			
		// LTK 20110927 Pandora #297 For MORK orders, the children will not be found on the detail tab, only the pick tab.
		//ldPrice = idw_detail.GetItemNumber(llFindRow,'Price')
		if llFindRow > 0 then
			ldPrice = idw_detail.GetItemNumber(llFindRow,'Price')
		end if
		
		llOwner = long(lsOwner)
		lsUF2 = ldsPickDetail.GetItemString(llRowPos, 'po_no')  //TAM 2009/07/07 - Now loading from project into receive_detail UF2
		lsUF6 = ldsPickDetail.GetItemString(llRowPos, 'user_field6')  //dts 8/09 - for Pandora, POP Location is stored in UF6 and needs to move from Outbound to Inbound
	else
		llOwner = ldsPickDetail.GetItemNumber(llRowPos,'Owner_ID')
	end if
	
	//Get the original PO Number for this stock
	lsDORONO = ldsPickDetail.GetItemString(llRowPos, 'ro_no')
	
	Select Supp_invoice_No into :lsPO
	From Receive_Master
	Where ro_no = :lsDORONO;
	
	If isNull(lsPO) Then lsPO = ''
	
	//Rollup to SKU/Supplier
	// - Doing this for BOBCAT to maintain the functionality of Bobcat's uf_create_inbound
	// - For non-BOBCAT (WH Xfers) rolling up to SKU/Line so generate putaway 
	//   works on inbound side (need to know what line to get proper Qty/lot-able fields relationship)
	//   - Could we use a lot-able fields Find? If there is no difference other than line,
	//		 won't we end up with 'extra' rows on receiving?
	if gs_project = 'BOBCAT' then
		llFindRow = ldsDetail.Find("Upper(sku) = '" + Upper(lsSKU) + "' and Upper(Supp_Code) = '" + Upper(lsSupplier) + "'",1, ldsDetail.RowCount())
	else
		//llFindRow = ldsDetail.Find("Upper(sku) = '" + Upper(lsSKU) + "' and Upper(Supp_Code) = '" + Upper(lsSupplier) + "' and Line_Item_No = " + string(llLineItemNo), 1, ldsDetail.RowCount())
		llFindRow = ldsDetail.Find("Upper(sku) = '" + Upper(lsSKU) + "' and Line_Item_No = " + string(llLineItemNo), 1, ldsDetail.RowCount())
	end if
	
	If llFindRow > 0 Then
		ldsDetail.SetItem(llFindRow, 'Req_Qty',(ldsDetail.GetItemNumber(llFindRow,'req_Qty') + ldQty))
// TAM W&S 2011/07 Do Not append PO to UF1 for W&S.  W&S is using User field 1 to store the Recieve Quantity at the Case level.  
		If Left(gs_project,3) <> 'WS-' then
			ldsDetail.SetItem(llFindRow, 'User_field1',ldsDetail.GetItemString(llFindRow,'User_field1') + ', ' + lsPO)
		End If
		
	Else
		llNewRow = ldsDetail.InsertRow(0)
		ldsDetail.SetItem(llNewRow,'ro_no',lsNewRONO)
		ldsDetail.SetItem(llNewRow,'Line_Item_No',llLineItemNO)
//// TAM 09/10/2009 - Added Line Item Number to User Line Item Number
//		ldsDetail.SetItem(llNewRow,'User_Line_Item_No',string(llLineItemNO))

		// LTK 20111005 Pandora #297 set user line item to the value stored in delivery_BOM for Pandora MORK orders
		if lb_pandora_mork and ldsPickDetail.GetItemString(llRowPos,'component_ind') = 'W' then
			long ll_found
			ll_found = lds_delivery_bom_recs.find("Sku_Child = '" + lsSKU + "'  and line_item_no = " + String(llLineItemNo), 1, lds_delivery_bom_recs.RowCount())
			if ll_found < 1 then
				Messagebox("Create Inbound", "Unable to find child line item numbers for system number: "  + lsDONO)
				Return -1
			end if

			ldsDetail.SetItem(llNewRow,'User_Line_Item_No',lds_delivery_bom_recs.GetItemString(ll_found,"user_field1"))
			
		else
			ldsDetail.SetItem(llNewRow,'User_Line_Item_No',string(llLineItemNO))
		end if
		
		ldsDetail.SetItem(llNewRow,'sku',lsSKU)
		ldsDetail.SetItem(llNewRow,'alternate_sku',lsSKU)
		ldsDetail.SetItem(llNewRow,'supp_Code',lsSUpplier)
		ldsDetail.SetItem(llNewRow,'req_qty',ldQty)
		ldsDetail.SetItem(llNewRow,'Cost',ldPrice)  //TimA 07/12/11 Pandora Issue #255		
		ldsDetail.SetItem(llNewRow,'owner_ID',llOwner)
		ldsDetail.SetItem(llNewRow,'Country_of_Origin',lsCOO)
		ldsDetail.SetItem(llNewRow,'User_Field1',lsPO)
//TAM 07/07/2009 Add User Field2 for Pandora -coming from delivery_picking po_no 	
		ldsDetail.SetItem(llNewRow,'User_Field2',lsUF2)
		//POP Location for Pandora....
		ldsDetail.SetItem(llNewRow,'User_Field6',lsUF6)
// TAM 2011/04 W&S Customize Fields for Transfer
	if left(gs_project,3) = 'WS-' then
		ldsDetail.SetItem(llNewRow,'User_Field1',lsUF1)
		ldsDetail.SetItem(llNewRow,'User_Field2',lsUF2)
		ldsDetail.SetItem(llNewRow,'User_Field3',lsUF3)
		ldsDetail.SetItem(llNewRow,'User_Field4',lsUF4)
	end if

//TAM 06/26/2009 Add EDI_Outbound_Detail Row Here for Return Defective	
//09/07/09 TAM Remove logic to create inbound order for return defective (Commenting out in case they change their mind again)
//  		If lsOrdType = 'Y' Then
//				if gs_project = 'PANDORA' then
//					llFindRow =  idw_Detail.Find("Upper(sku) = '" + Upper(lsSKU) + "' and Line_Item_No = " + string(llLineItemNo), 1, idw_Detail.RowCount())
//  				lsSerialNo = idw_Detail.GetItemString(llFindRow,'user_field3') 
//			end if
//			llLinePos ++
//	
//			Insert Into EDI_Inbound_Detail (project_id, edi_batch_seq_no, order_seq_no, order_line_no, order_no, sku, line_item_no, Inventory_Type, Country_of_Origin, lot_no, po_no, po_no2, Quantity, Status_CD, Status_message,  Serial_No) 
//			values								(:gs_Project, :llNewBatchSeq, 1, :llLinePos, :lsORderNo, :lsSKU, :llLineItemNo, 'N',:lsCOO, '-', :lsPO, '-', :ldQty, 'C', 'Return Replacement', :lsSerialNo);
//
//		End If
	End If

Next /*Pick Detail Record */

// LTK 20111005 Pandora #297
if IsValid(lds_delivery_bom_recs) then DESTROY lds_delivery_bom_recs

//Update Details
liRC = ldsDetail.Update()
If liRC = 1 Then
	Execute Immediate "COMMIT" using SQLCA;
Else
	lsErrText = sqlca.sqlerrtext
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Create Inbound", "Unable to save new Receiving Order Detail records to database!~r~r" + lsErrText)
	Return -1
End If


//Jxlim 02/22/2012 testing
//MessageBox("Create Inbound", "Matching Inbound Order successfully created for " + lswarehouse)

Return 0
end function

public function string pandora_getwarehouse (string as_cust);//Jxlim 02/16/2012 BRD #337 Pandora -Otm clone this function from w_do

string lsWH
select user_field2 into :lsWH
from customer
where project_id = 'pandora'
and cust_code = :as_cust;
return lsWH
end function

public function string pandora_getowner (string astype, string asvalue);//Jxlim 02/16/2012 BRD #337 Pandora -Otm clone this function from w_do

string lsReturn
long llOwnerID
if asType = 'CODE' then
	select Owner_CD into :lsReturn
	from owner
	where project_id = 'PANDORA'
	and owner_id = :asValue;
else // type = 'ID'
	select Owner_id into :llOwnerID
	from owner
	where project_id = 'PANDORA'
	and owner_cd = :asValue;
	lsReturn = string(llOwnerID)
end if
return lsReturn
end function

public function integer wf_lock (boolean ab_lock);//Jxlim 04/26/2012 Lock and unlock backgrrund color
String ls_color, ls_dw_color, ls_status
Boolean lb_display_only, lb_enabled, lb_saveMenu  

ls_status = idw_main.GetItemString(1,"ord_status")

ls_dw_color = idw_main.object.datawindow.color
	
IF ab_lock THEN  //if true
	ls_color = ls_dw_color // string(RGB(128, 128, 128))  dw background color
	lb_display_only = true
	lb_enabled = false
	lb_saveMenu  = false
ELSE
	ls_color = string(RGB(255, 255, 255))  //white
	lb_display_only = false
	lb_enabled = true
	lb_saveMenu  = True
END IF
	
If ab_lock Then
	im_menu.m_file.m_save.Enabled = lb_saveMenu 
	idw_main.Enabled= lb_enabled 
	idw_main.Object.Ship_id.Protect = lb_display_only
	idw_main.Modify("Ship_id.Background.Color = '" +  ls_dw_color + "'")	
	idw_main.Object.Ord_type.Protect = lb_display_only
	idw_main.Modify("Ord_Type.Background.Color = '" +  ls_dw_color + "'")	
	idw_main.Object.Wh_Code.Protect = lb_display_only
	idw_main.Modify("Wh_Code.Background.Color = '" +  ls_dw_color + "'")
	
	If ls_status = 'C' Then
		idw_main.Object.ord_date.Protect = lb_display_only
		idw_main.Modify("	ord_date.Background.Color = '" +  ls_dw_color + "'")	
		idw_main.Object.freight_terms.Protect = lb_display_only
		idw_main.Modify("freight_terms.Background.Color = '" +  ls_dw_color + "'")			
		idw_main.Object.pro_no.Protect = lb_display_only
		idw_main.Modify("pro_no.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.carrier_code.Protect = lb_display_only
		idw_main.Modify("carrier_code.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.declared_value.Protect = lb_display_only
		idw_main.Modify("declared_value.Background.Color = '" +  ls_dw_color + "'")			
		idw_main.Object.pod_name.Protect = lb_display_only
		idw_main.Modify("pod_name.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.service_level.Protect = lb_display_only
		idw_main.Modify("service_level.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.rated_weight.Protect = lb_display_only
		idw_main.Modify("rated_weight.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.awb_bol_no.Protect = lb_display_only
		idw_main.Modify("awb_bol_no.Background.Color = '" +  ls_dw_color + "'")			
		idw_main.Object.freight_etd.Protect = lb_display_only
		idw_main.Modify("freight_etd.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.freight_ata.Protect = lb_display_only
		idw_main.Modify("freight_ata.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.freight_atd.Protect = lb_display_only
		idw_main.Modify("freight_atd.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.freight_eta.Protect = lb_display_only
		idw_main.Modify("freight_eta.Background.Color = '" +  ls_dw_color + "'")			
		idw_main.Object.est_ctn_cnt.Protect = lb_display_only
		idw_main.Modify("est_ctn_cnt.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.est_weight.Protect = lb_display_only
		idw_main.Modify("est_weight.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.est_weight_uom.Protect = lb_display_only
		idw_main.Modify("est_weight_uom.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.est_volume.Protect = lb_display_only
		idw_main.Modify("est_volume.Background.Color = '" +  ls_dw_color + "'")			
		idw_main.Object.est_vol_uom.Protect = lb_display_only
		idw_main.Modify("est_vol_uom.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.est_weight_qualifier.Protect = lb_display_only
		idw_main.Modify("est_weight_qualifier.Background.Color = '" +  ls_dw_color + "'")	
		idw_main.Object.ctn_cnt.Protect = lb_display_only
		idw_main.Modify("ctn_cnt.Background.Color = '" +  ls_dw_color + "'")			
		idw_main.Object.weight.Protect = lb_display_only
		idw_main.Modify("weight.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.weight_uom.Protect = lb_display_only
		idw_main.Modify("weight_uom.Background.Color = '" +  ls_dw_color + "'")
		idw_main.Object.volume.Protect = lb_display_only
		idw_main.Modify("volume.Background.Color = '" +  ls_dw_color + "'")  
		idw_main.Object.volume_uom.Protect = lb_display_only
		idw_main.Modify("volume_uom.Background.Color = '" +  ls_dw_color + "'") 	
		idw_main.Object.weight_qualifier.Protect = lb_display_only
		idw_main.Modify("weight_qualifier.Background.Color = '" +  ls_dw_color + "'")	
	ElseIf ls_status = 'N' or ls_status = 'P' Then
		lb_display_only = False
		ls_color = string(RGB(255, 255, 255))  //white
		idw_main.Object.ord_date.Protect = lb_display_only
		idw_main.Modify("	ord_date.Background.Color = '" +  ls_color + "'")				
		idw_main.Object.awb_bol_no.Protect = lb_display_only
		idw_main.Modify("awb_bol_no.Background.Color = '" +  ls_color + "'")			
		idw_main.Object.freight_terms.Protect = lb_display_only		
		idw_main.Modify("freight_terms.Background.Color = '" +  ls_color + "'")			
		idw_main.Object.pro_no.Protect = lb_display_only
		idw_main.Modify("pro_no.Background.Color = '" +  ls_color + "'")
		idw_main.Object.carrier_code.Protect = lb_display_only
		idw_main.Modify("carrier_code.Background.Color = '" +  ls_color + "'")
		idw_main.Object.declared_value.Protect = lb_display_only
		idw_main.Modify("declared_value.Background.Color = '" +  ls_color + "'")			
		idw_main.Object.pod_name.Protect = lb_display_only
		idw_main.Modify("pod_name.Background.Color = '" +  ls_color + "'")
		idw_main.Object.service_level.Protect = lb_display_only
		idw_main.Modify("service_level.Background.Color = '" +  ls_color + "'")
		idw_main.Object.rated_weight.Protect = lb_display_only
		idw_main.Modify("rated_weight.Background.Color = '" +  ls_color + "'")			
		idw_main.Object.freight_etd.Protect = lb_display_only
		idw_main.Modify("freight_etd.Background.Color = '" +  ls_color + "'")
		idw_main.Object.freight_ata.Protect = lb_display_only
		idw_main.Modify("freight_ata.Background.Color = '" +  ls_color + "'")
		idw_main.Object.freight_atd.Protect = lb_display_only
		idw_main.Modify("freight_atd.Background.Color = '" +  ls_color + "'")
		idw_main.Object.freight_eta.Protect = lb_display_only
		idw_main.Modify("freight_eta.Background.Color = '" +  ls_color + "'")			
		idw_main.Object.est_ctn_cnt.Protect = lb_display_only
		idw_main.Modify("est_ctn_cnt.Background.Color = '" +  ls_color + "'")
		idw_main.Object.est_weight.Protect = lb_display_only
		idw_main.Modify("est_weight.Background.Color = '" +  ls_color + "'")
		idw_main.Object.est_weight_uom.Protect = lb_display_only
		idw_main.Modify("est_weight_uom.Background.Color = '" +  ls_color + "'")
		idw_main.Object.est_volume.Protect = lb_display_only
		idw_main.Modify("est_volume.Background.Color = '" +  ls_color + "'")			
		idw_main.Object.est_vol_uom.Protect = lb_display_only
		idw_main.Modify("est_vol_uom.Background.Color = '" +  ls_color + "'")
		idw_main.Object.est_weight_qualifier.Protect = lb_display_only
		idw_main.Modify("est_weight_qualifier.Background.Color = '" +  ls_color + "'")	
		idw_main.Object.ctn_cnt.Protect = lb_display_only
		idw_main.Modify("ctn_cnt.Background.Color = '" +  ls_color + "'")			
		idw_main.Object.weight.Protect = lb_display_only
		idw_main.Modify("weight.Background.Color = '" +  ls_color + "'")
		idw_main.Object.weight_uom.Protect = lb_display_only
		idw_main.Modify("weight_uom.Background.Color = '" +  ls_color + "'")
		idw_main.Object.volume.Protect = lb_display_only
		idw_main.Modify("volume.Background.Color = '" +  ls_color + "'")  
		idw_main.Object.volume_uom.Protect = lb_display_only
		idw_main.Modify("volume_uom.Background.Color = '" +  ls_color + "'") 	
		idw_main.Object.weight_qualifier.Protect = lb_display_only
		idw_main.Modify("weight_qualifier.Background.Color = '" +  ls_color + "'")					
		lb_display_only = True
		ls_color = ls_dw_color 
	Else
			
	End If  // Status = 'C'
	
	//Lock all the information on the Ship From tab
	idw_origin.object.datawindow.Readonly = True 	 //Lock all the information on the Ship From tab
	//idw_origin.Modify("datawindow.BackGround.Color = '" +  ls_dw_color + "'")
	idw_Origin.Modify("Name.Background.Color = '" +  ls_dw_color + "'")
	idw_Origin.Modify("address_1.Background.Color = '" +  ls_dw_color + "'")
	idw_Origin.Modify("address_2.Background.Color = '" +   ls_dw_color + "'")
	idw_Origin.Modify("address_3.Background.Color = '" +  ls_dw_color + "'")
	idw_Origin.Modify("address_4.Background.Color = '" +   ls_dw_color + "'")
	idw_Origin.Modify("City.Background.Color = '" +  ls_dw_color + "'")
	idw_Origin.Modify("State.Background.Color = '" +  ls_dw_color + "'")
	idw_Origin.Modify("Zip.Background.Color = '" +   ls_dw_color + "'")
	idw_Origin.Modify("Country.Background.Color = '" +   ls_dw_color + "'")
	idw_Origin.Modify("tel.Background.Color = '" +   ls_dw_color + "'")
	idw_Origin.Modify("fax.Background.Color = '" +   ls_dw_color + "'")
	idw_Origin.Modify("contact_person.Background.Color = '" +  ls_dw_color + "'")
	idw_Origin.Modify("email_address.Background.Color = '" +  ls_dw_color + "'")
		
	//Lock all the information on the Ship To tab		
	idw_dest.object.datawindow.Readonly = True   	 //Lock all the information on the Ship To tab
	//idw_dest.Modify("datawindow.Color  = '" +  ls_dw_color + "'")		
	idw_Dest.Modify("Name.Background.Color = '" +   ls_dw_color + "'")
	idw_Dest.Modify("address_1.Background.Color = '" +  ls_dw_color + "'")
	idw_Dest.Modify("address_2.Background.Color = '" +   ls_dw_color + "'")
	idw_Dest.Modify("address_3.Background.Color = '" +   ls_dw_color + "'")
	idw_Dest.Modify("address_4.Background.Color = '" +   ls_dw_color + "'")
	idw_Dest.Modify("City.Background.Color = '" +   ls_dw_color + "'")
	idw_Dest.Modify("State.Background.Color = '" +  ls_dw_color + "'")
	idw_Dest.Modify("Zip.Background.Color = '" +   ls_dw_color + "'")
	idw_Dest.Modify("Country.Background.Color = '" +  ls_dw_color + "'")
	idw_Dest.Modify("tel.Background.Color = '" +   ls_dw_color + "'")
	idw_Dest.Modify("fax.Background.Color = '" +   ls_dw_color + "'")
	idw_Dest.Modify("contact_person.Background.Color = '" +   ls_dw_color + "'")
	idw_Dest.Modify("email_address.Background.Color = '" +  ls_dw_color + "'")			
				
Else	// Selective unlocks ...
	im_menu.m_file.m_save.Enabled = lb_saveMenu 
	idw_main.Enabled= lb_enabled 
	//Setback for anything else
	idw_main.Object.Ship_Id.Protect =0					 //UnLock  Shipment ID
	idw_main.Modify("Ship_id.Background.Color = '" +  ls_color + "'")			
	idw_main.Object.Ord_Type.Protect = 0				 //UnLock Order Type
	idw_main.Modify("Ord_Type.Background.Color = '" +  ls_color + "'")
	
	idw_main.Object.ord_date.Protect = lb_display_only
	idw_main.Modify("	ord_date.Background.Color = '" +  ls_color + "'")				
	idw_main.Object.awb_bol_no.Protect = lb_display_only
	idw_main.Modify("awb_bol_no.Background.Color = '" +  ls_color + "'")			
	idw_main.Object.freight_terms.Protect = lb_display_only		
	idw_main.Modify("freight_terms.Background.Color = '" +  ls_color + "'")			
	idw_main.Object.pro_no.Protect = lb_display_only
	idw_main.Modify("pro_no.Background.Color = '" +  ls_color + "'")
	idw_main.Object.carrier_code.Protect = lb_display_only
	idw_main.Modify("carrier_code.Background.Color = '" +  ls_color + "'")
	idw_main.Object.declared_value.Protect = lb_display_only
	idw_main.Modify("declared_value.Background.Color = '" +  ls_color + "'")			
	idw_main.Object.pod_name.Protect = lb_display_only
	idw_main.Modify("pod_name.Background.Color = '" +  ls_color + "'")
	idw_main.Object.service_level.Protect = lb_display_only
	idw_main.Modify("service_level.Background.Color = '" +  ls_color + "'")
	idw_main.Object.rated_weight.Protect = lb_display_only
	idw_main.Modify("rated_weight.Background.Color = '" +  ls_color + "'")
	idw_main.Object.ship_id.Protect = lb_display_only
	idw_main.Modify("ship_id.Background.Color = '" +  ls_color + "'")			
	idw_main.Object.freight_etd.Protect = lb_display_only
	idw_main.Modify("freight_etd.Background.Color = '" +  ls_color + "'")
	idw_main.Object.freight_ata.Protect = lb_display_only
	idw_main.Modify("freight_ata.Background.Color = '" +  ls_color + "'")
	idw_main.Object.freight_atd.Protect = lb_display_only
	idw_main.Modify("freight_atd.Background.Color = '" +  ls_color + "'")
	idw_main.Object.freight_eta.Protect = lb_display_only
	idw_main.Modify("freight_eta.Background.Color = '" +  ls_color + "'")			
	idw_main.Object.est_ctn_cnt.Protect = lb_display_only
	idw_main.Modify("est_ctn_cnt.Background.Color = '" +  ls_color + "'")
	idw_main.Object.est_weight.Protect = lb_display_only
	idw_main.Modify("est_weight.Background.Color = '" +  ls_color + "'")
	idw_main.Object.est_weight_uom.Protect = lb_display_only
	idw_main.Modify("est_weight_uom.Background.Color = '" +  ls_color + "'")
	idw_main.Object.est_volume.Protect = lb_display_only
	idw_main.Modify("est_volume.Background.Color = '" +  ls_color + "'")			
	idw_main.Object.est_vol_uom.Protect = lb_display_only
	idw_main.Modify("est_vol_uom.Background.Color = '" +  ls_color + "'")
	idw_main.Object.est_weight_qualifier.Protect = lb_display_only
	idw_main.Modify("est_weight_qualifier.Background.Color = '" +  ls_color + "'")	
	idw_main.Object.ctn_cnt.Protect = lb_display_only
	idw_main.Modify("ctn_cnt.Background.Color = '" +  ls_color + "'")			
	idw_main.Object.weight.Protect = lb_display_only
	idw_main.Modify("weight.Background.Color = '" +  ls_color + "'")
	idw_main.Object.weight_uom.Protect = lb_display_only
	idw_main.Modify("weight_uom.Background.Color = '" +  ls_color + "'")
	idw_main.Object.volume.Protect = lb_display_only
	idw_main.Modify("volume.Background.Color = '" +  ls_color + "'")  
	idw_main.Object.volume_uom.Protect = lb_display_only
	idw_main.Modify("volume_uom.Background.Color = '" +  ls_color + "'") 	
	idw_main.Object.weight_qualifier.Protect = lb_display_only
	idw_main.Modify("weight_qualifier.Background.Color = '" +  ls_color + "'")			
	
	//Lock all the information on the Ship From tab
	idw_origin.object.datawindow.Readonly = False 	 //Lock all the information on the Ship From tab
	//idw_origin.Modify("datawindow.BackGround.Color = '" +  ls_color + "'")
	idw_Origin.Modify("Name.Background.Color = '" +  ls_color + "'")
	idw_Origin.Modify("address_1.Background.Color = '" +  ls_color + "'")
	idw_Origin.Modify("address_2.Background.Color = '" +  ls_color + "'")
	idw_Origin.Modify("address_3.Background.Color = '" +  ls_color + "'")
	idw_Origin.Modify("address_4.Background.Color = '" +  ls_color + "'")
	idw_Origin.Modify("City.Background.Color = '" +  ls_color + "'")
	idw_Origin.Modify("State.Background.Color = '" +  ls_color + "'")
	idw_Origin.Modify("Zip.Background.Color = '" +  ls_color + "'")
	idw_Origin.Modify("Country.Background.Color = '" +  ls_color + "'")
	idw_Origin.Modify("tel.Background.Color = '" +  ls_color + "'")
	idw_Origin.Modify("fax.Background.Color = '" +  ls_color + "'")
	idw_Origin.Modify("contact_person.Background.Color = '" +  ls_color + "'")
	idw_Origin.Modify("email_address.Background.Color = '" +  ls_color + "'")
					
	//Lock all the information on the Ship To tab		
	idw_dest.object.datawindow.Readonly = False   	 //Lock all the information on the Ship To tab
	//idw_dest.Modify("datawindow.Color  = '" +  ls_color + "'")		
	idw_Dest.Modify("Name.Background.Color = '" +  ls_color + "'")
	idw_Dest.Modify("address_1.Background.Color = '" +  ls_color + "'")
	idw_Dest.Modify("address_2.Background.Color = '" +  ls_color + "'")
	idw_Dest.Modify("address_3.Background.Color = '" +  ls_color + "'")
	idw_Dest.Modify("address_4.Background.Color = '" +  ls_color + "'")
	idw_Dest.Modify("City.Background.Color = '" +  ls_color + "'")
	idw_Dest.Modify("State.Background.Color = '" +  ls_color + "'")
	idw_Dest.Modify("Zip.Background.Color = '" +  ls_color + "'")
	idw_Dest.Modify("Country.Background.Color = '" +  ls_color + "'")
	idw_Dest.Modify("tel.Background.Color = '" +  ls_color + "'")
	idw_Dest.Modify("fax.Background.Color = '" +  ls_color + "'")
	idw_Dest.Modify("contact_person.Background.Color = '" +  ls_color + "'")				
	idw_Dest.Modify("email_address.Background.Color = '" +  ls_color + "'")
	
	// ET3 2012-09-28 Pandora 516-503 Locking the Shipments - F10 unlock the Remove From Shipment button
	tab_main.tabpage_order.cb_delete_order.Enabled = TRUE

		
End If  //Jxlim 04/26/2012 End for Pandora BRD #404

// ET3 2012/09/27 - Pandora 503; lock down ALL shipment info from changes
IF Upper(gs_project) = 'PANDORA' AND ab_lock THEN
	idw_main.object.awb_bol_no.protect = TRUE
	LONG i
	STRING sColName, sRtn
	
	FOR i = 1 TO long(idw_main.object.DataWindow.Column.Count)
		sColName = idw_main.Describe( "#" + string(i) + ".Name")
		sRtn = idw_main.modify(sColName + ".protect='1'")
		sRtn = idw_main.modify(sColName + ".Background.Color = '" +  ls_dw_color + "'" )
	NEXT
	
	idw_main.object.datawindow.Readonly = True 

ELSEIF Upper(gs_project) = 'PANDORA' AND ab_lock = FALSE THEN
	idw_main.object.datawindow.Readonly = FALSE 

END IF
						
Return 0
end function

on w_shipments.create
int iCurrent
call super::create
end on

on w_shipments.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc, ldwc2, ldwc_ordstatus, ldwc_shipordstatus

iw_window = This

iu_Shipments = Create u_nvo_shipments

tab_main.MoveTab(2, 99) /* search tab alwasy last*/

// Tabs/DW's assigned to Variables
idw_main = tab_main.tabpage_main.dw_master
idw_detail = tab_main.tabpage_detail.dw_detail
idw_status = tab_main.tabpage_status.dw_status
idw_Search = tab_main.tabpage_search.dw_search_entry
idw_Result = tab_main.tabpage_search.dw_search_result
idw_Origin = tab_main.tabpage_Main.tab_locations.tabpage_origin.dw_origin
idw_Dest = tab_main.tabpage_Main.tab_locations.tabpage_dest.dw_Dest
idw_bol = tab_main.tabpage_bol.dw_bol_prt
idw_order = tab_main.tabpage_order.dw_order	//Jxlim 12/22/2011 Pandora-OTM #337
idw_packprint = tab_main.tabpage_order.dw_packprint  //Jxlim 12/22/2011 Pandora-OTM #337

iSle_AWB = Tab_main.tabpage_main.sle_awb

//Jxlim 12/27/2011 BRD #337 OTM-Sims Shipment tabs for Pandora
If    Upper(gs_project) = "PANDORA" Then
	 idw_main.SetTabOrder("Ship_Id",10)
	 idw_main.SetTabOrder("awb_bol_no", 280)
	 idw_result.dataobject = 'd_shipment_search_result_otm'
	 idw_result.SetTransObject(SQLCA)
	 tab_main.tabpage_detail.visible = False	//Shipment Status tab not visible
	 tab_main.tabpage_status.visible = False	//Shipment Status tab not visible	 
	 tab_main.tabpage_order.visible =True		//Shipment Order tab visible	
	 tab_main.tabpage_search.dw_search_entry.object.ord_type_t.visible =False
	 tab_main.tabpage_search.dw_search_entry.object.ord_type.visible =False
	 tab_main.tabpage_search.dw_search_entry.object.ship_id_t.visible =True	
	 tab_main.tabpage_search.dw_search_entry.object.ship_id.visible =True
	 //SIMS Ord Nbr
	 tab_main.tabpage_search.dw_search_entry.object.invoice_no_t.visible =True
	 tab_main.tabpage_search.dw_search_entry.object.invoice_no_t.X =5
	 tab_main.tabpage_search.dw_search_entry.object.invoice_no_t.Y =172	  
	 
	 tab_main.tabpage_search.dw_search_entry.object.invoice_no.visible =True
	 tab_main.tabpage_search.dw_search_entry.object.invoice_no.X =375
	 tab_main.tabpage_search.dw_search_entry.object.invoice_no.Y =172
//	 tab_main.tabpage_search.dw_search_entry.object.ship_status_t.visible =True
//	 tab_main.tabpage_search.dw_search_entry.object.ship_status.visible =True

Else
	 tab_main.tabpage_detail.visible = True		//Shipment Status tab visible
	 tab_main.tabpage_status.visible = True  	//Shipment status visible
	  tab_main.tabpage_detail.visible = True	//Shipment Status tab not visible
	 tab_main.tabpage_order.visible =False		//Shipment Order tab not visible
	 tab_main.tabpage_search.dw_search_entry.object.ord_type_t.visible =True
	 tab_main.tabpage_search.dw_search_entry.object.ord_type.visible =True
	 tab_main.tabpage_search.dw_search_entry.object.ship_id_t.visible =False
	 tab_main.tabpage_search.dw_search_entry.object.ship_id.visible=False
	 tab_main.tabpage_search.dw_search_entry.object.invoice_no_t.visible =False
	 tab_main.tabpage_search.dw_search_entry.object.invoice_no.visible =False
// 	 tab_main.tabpage_search.dw_search_entry.object.ship_status_t.visible =False
//	 tab_main.tabpage_search.dw_search_entry.object.ship_status.visible =False
End If

//Retrieve and Share DDDWS with Parms

//Warehouse
idw_main.GetChild("wh_code",ldwc)
ldwc.SetTransObject(SQLCA)
g.of_set_warehouse_dropdown(ldwc) /* load from USer Warehouse DS */

idw_search.GetChild("wh_code",ldwc2)
ldwc.ShareData(ldwc2)

//Carrier - no need to retrieve until needed
idw_Search.GetChild("Carrier",ldwc)
ldwc.SetTransObject(SQLCA)

idw_Main.GetChild("Carrier_Code",ldwc2)
ldwc.ShareData(ldwc2)

//Share carrier dropdowns with DS Loaded in Project Open
g.ids_dddw_carrier.ShareData(ldwc)
g.ids_dddw_carrier.ShareData(ldwc2)

//Jxlim 01/05/2011Pandora-Otm BRD #337
If gs_project = 'PANDORA' Then
	//On the shipment search screen
	 idw_search.object.ord_status.dddw.name='dddw_shipment_order_status_otm'
	 idw_search.GetChild("ord_status", ldwc_ordstatus)
	 ldwc_ordstatus.SetTransObject(SQLCA)	
	 ldwc_ordstatus.Retrieve(gs_project)		
	
	//On the shipment main screen
	 idw_main.object.ord_status.dddw.name='dddw_shipment_order_status_otm'		
	 idw_main.object.ord_status.dddw.displaycolumn='description'
	 idw_main.object.ord_status.dddw.datacolumn='ord_status'
	 idw_main.GetChild("ord_status", ldwc_shipordstatus)
	 ldwc_shipordstatus.SetTransObject(SQLCA)	
	 ldwc_shipordstatus.Retrieve(gs_project)		
End If

idw_search.InsertRow(0)

isOrigSql = idw_result.GetSqlSelect() /* orig SQL for Search Criteria */

This.TriggerEvent("ue_edit")

tab_main.tabpage_main.cb_GetETD.visible = false
tab_main.tabpage_main.cb_GetETA.visible = false
tab_main.tabpage_main.cb_ETAmaint.visible = false

// We may be coming from DO/RO with a shipment to open
If UpperBound(Istrparms.String_arg) > 0 Then /*Shipment number present*/
	If Istrparms.String_arg[1] > '' Then
		isShipNo = Istrparms.String_arg[1]
		This.TriggerEvent('ue_retrieve')
	else
		if g.ibEtaMaintEnabled then
		//	tab_main.tabpage_main.cb_GetETD.visible = true
		//	tab_main.tabpage_main.cb_GetETA.visible = true
			tab_main.tabpage_main.cb_ETAmaint.visible = true
		end if
	End If
End If

IF  Upper(gs_project) = "3COM_NASH" THEN

	 tab_main.tabpage_bol.visible = true
	
ELSE

	 tab_main.tabpage_bol.visible = false

END IF


if Upper(gs_project) = 'CHINASIMS' then

	tab_main.tabpage_main.tab_locations.tabpage_origin.text = "$$HEX3$$d153278db965$$ENDHEX$$"
	tab_main.tabpage_main.tab_locations.tabpage_dest.text = "$$HEX3$$3665278db965$$ENDHEX$$"
	
end if

// ET3 2012/09/27 - Pandora 503; lock down ALL shipment info from changes
IF Upper(gs_project) = 'PANDORA' THEN
	idw_main.object.awb_bol_no.protect = TRUE
	LONG i
	STRING sColName, sRtn
	
	FOR i = 1 TO long(idw_main.object.DataWindow.Column.Count)
		sColName = idw_main.Describe( "#" + string(i) + ".Name")
		sRtn = idw_main.modify(sColName + ".protect='1'")
	NEXT

END IF

	
end event

event ue_edit;// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False

// Changing menu properties

im_menu.m_file.m_save.Enabled = False
im_menu.m_file.m_retrieve.Enabled = True
im_menu.m_file.m_print.Enabled = False
im_menu.m_file.m_refresh.Enabled = False
im_menu.m_record.m_delete.Enabled = False

tab_main.tabpage_Detail.Enabled = False
tab_main.tabpage_Status.Enabled = False
tab_main.tabpage_bol.Enabled = False


// Tab properties

isle_AWB.Visible=True
isle_AWB.DisplayOnly = False
isle_AWB.TabOrder = 10

idw_main.Hide()
tab_main.tabpage_Main.tab_locations.Hide()

wf_clear_screen()

isshipno = ''
isle_awb.Text = ''
isle_awb.SetFocus()
end event

event ue_retrieve;
Long	llCount
String lsAWB, lsShipNo

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

lsAWB = isle_awb.Text

//If ShipNo filled in already, a row was double clicked from Search Criteria, otherwise convert AWB entered to ShipNo
If isShipNo = '' or isnull(isSHipNo) Then
	//Jxlim 01/03/2011 Pandora-OTM #337
	If gs_project ='PANDORA' Then
		//There may be more than 1 Shipment for the Ship_Id entered
//		Select Count(*) into :llCount
//		FROM Shipment WITH (NOLOCK)
//		WHERE Shipment.Ship_Id = :lsAwb and Shipment.project_id = :gs_project;

		// ET3 2012-09-27 Pandora 516 - don't bring back if orders in OTM status = P
		Select Count(*) into :llCount
		FROM Shipment WITH (NOLOCK)
		     LEFT OUTER JOIN Delivery_Master WITH (NOLOCK)
			  	ON Shipment.Ship_Id = Delivery_Master.Consolidation_No
				AND Shipment.project_id = Delivery_Master.project_id
		WHERE Shipment.Ship_Id = :lsAwb and Shipment.project_id = :gs_project
			AND Delivery_Master.OTM_Status <> 'P'
		USING SQLCA;
		
	Else	
		//There may be more than 1 Shipment for the AWB entered
		Select Count(*) into :llCount
		FROM Shipment
		WHERE Awb_Bol_No = :lsAwb and project_id = :gs_project;
	End IF
	
	If llCount = 0 or SQLCA.sqlcode <> 0 THEN
		MessageBox(is_title, "Shipment not found, please enter again!", Exclamation!)
		isle_awb.SetFocus()
		isle_awb.SelectText(1,Len(lsAwb))
		RETURN
	ElseIf llCount > 1 Then
		Messagebox(is_title,"Multiple Shipments found for this AWB, please select from search tab!")
		isle_awb.SetFocus()
		isle_awb.SelectText(1,Len(lsAwb))
		Return
	Else /*one record found*/
			//Jxlim 01/03/2011 Pandora-OTM #337
			If gs_project ='PANDORA' Then

//				SELECT Ship_no
//				INTO :isShipNo
//				FROM Shipment
//				WHERE Ship_Id = :lsAwb and project_id = :gs_project;

				// ET3 2012-09-27 Pandora 516 - don't bring back if orders in OTM status = P
				Select Ship_No into :isShipno
				FROM Shipment WITH (NOLOCK)
					  LEFT OUTER JOIN Delivery_Master WITH (NOLOCK)
						ON Shipment.Ship_Id = Delivery_Master.Consolidation_No
						AND Shipment.project_id = Delivery_Master.project_id
				WHERE Shipment.Ship_Id = :lsAwb and Shipment.project_id = :gs_project
					AND Delivery_Master.OTM_Status <> 'P'
				USING SQLCA;

			Else
				SELECT Ship_no
				INTO :isShipNo
				FROM Shipment
				WHERE Awb_Bol_No = :lsAwb and project_id = :gs_project;
			End If

		IF SQLCA.sqlcode <> 0 THEN
			MessageBox(is_title, "Shipment not found, please enter again!", Exclamation!)
			isle_awb.SetFocus()
			isle_awb.SelectText(1,Len(lsAwb))
			RETURN
		End If
	END IF
	
End If /*not selected from Search*/

If isSHipNo = '' Then Return

//Retrieve the Header
idw_Main.Retrieve(isShipNo)

If idw_main.RowCount() <> 1 Then
	MessageBox(is_title, "Unable to Retrieve Shipment!", Exclamation!)
	isle_awb.SetFocus()
	isle_awb.SelectText(1,Len(lsAwb))
	RETURN
End If

idw_Origin.Retrieve(isSHipNo,'O') /* Origin Address*/
If idw_origin.RowCOunt() = 0 Then
	idw_origin.InsertRow(0)
End If

idw_DEst.Retrieve(isSHipNo,'D') /* Dest Addresses */
If idw_DEst.RowCOunt() = 0 Then
	idw_DEst.InsertRow(0)
End If

idw_order.Retrieve(isShipNo) /*order records*/  	//Jxlim 12/22/2011 Pandora-OTM BRD #337

idw_detail.Retrieve(isShipNo) /*detail records*/
idw_Status.Retrieve(isShipNo) /*Status Records*/

/* dts 05/05/06 Now sorting newest to the top */
idw_status.SetSort("status_date D")
idw_status.Sort()

idw_main.Show()
tab_main.tabpage_main.tab_locations.Show()
tab_main.tabpage_detail.Enabled = True
tab_main.tabpage_Status.Enabled = True

if tab_main.tabpage_bol.Visible then
	tab_main.tabpage_bol.Enabled = True
end if

wf_check_status()

tab_main.SelectTab(1)
idw_Main.SetFocus()

tab_main.tabpage_detail.cb_delete_orders.Enabled = False
tab_main.tabpage_status.cb_delete_status.Enabled = False

//Jxlim 01/13/2012 Pandora-OTM #337
//Buttons will only enabled when row is selected, disabled the buttons as soon as order tab is loaded, 
If gs_project = 'PANDORA' Then
	tab_main.tabpage_order.cb_delete_order.Enabled = False
	tab_main.tabpage_order.cb_printPack.Enabled = False
	tab_main.tabpage_order.cb_printCI.Enabled = False
	tab_main.tabpage_order.cb_confirm.Enabled = False
	tab_main.tabpage_order.cb_otmchanged.Enabled = False
End If

if g.ibEtaMaintEnabled then
	tab_main.tabpage_main.cb_GetETD.visible = true
	tab_main.tabpage_main.cb_GetETA.visible = true
	tab_main.tabpage_main.cb_ETAmaint.visible = true
//else
//	tab_main.tabpage_main.cb_GetETD.visible = false
//	tab_main.tabpage_main.cb_GetETA.visible = false
//	tab_main.tabpage_main.cb_ETAmaint.visible = false
end if

tab_main.tabpage_bol.dw_bol_entry.Reset()
tab_main.tabpage_bol.dw_bol_prt.Reset()
tab_main.tabpage_bol.cb_bol_print.Enabled = False /*Disable printing of BOL*/



end event

event resize;call super::resize;tab_main.Resize(workspacewidth(),workspaceHeight())
tab_main.tabpage_detail.dw_detail.Resize(workspacewidth() - 80,workspaceHeight()-260)
tab_main.tabpage_status.dw_status.Resize(workspacewidth() - 80,workspaceHeight()-260)
tab_main.tabpage_search.dw_search_result.Resize(workspacewidth() - 80,workspaceHeight()-550)


end event

event ue_new;
// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

isshipno = ''

// Clear existing data
This.Title = is_title + " - New"
ib_edit = False
ib_changed = False

isle_awb.text = ""

wf_clear_screen()

idw_main.InsertRow(0)

idw_origin.InsertRow(0)
idw_origin.SetItem(1,'location_Type','O')

idw_Dest.InsertRow(0)
idw_Dest.SetItem(1,'location_Type','D')

idw_main.SetItem(1,"project_id",gs_project)
idw_main.SetItem(1,"ord_date",Today())
idw_main.SetItem(1,"ord_status_date",Today())
idw_Main.SetItem(1,'ord_type','O')
//idw_Main.SetItem(1,'ord_Status','N')
//dts 05/05/06 - no longer defaulting ord_status to 'N' (thought to be 'New' but actually 'No paper work ...')
idw_Main.SetItem(1,'ord_Status','NA')  
idw_main.SetItem(1,'Create_user_date',Today()) 
idw_main.SetItem(1,'Create_user',gs_userid)
//idw_main.SetItem(1,"wh_code",gs_default_wh)

isle_awb.Hide()
idw_main.Show()
idw_main.SetFocus()

//Jxlim 01/03/2012 Pandora-Otm BRD #337
If gs_project = 'PANDORA' Then
	idw_main.SetColumn("ship_id")
Else
	idw_main.SetColumn("awb_Bol_no")
End If
tab_main.SelectTab(1)

wf_check_status()

tab_main.tabpage_detail.cb_delete_orders.Enabled = False
tab_main.tabpage_status.cb_delete_status.Enabled = False
end event

event ue_save;
Long	llShipNo, llRowPos, llRowCount, ll_method_trace_id
String	lsOrder
Integer	liRC

integer i
string lsStatus
Boolean lbDelivered // 05/05/06 - now applying all status to shipment (but not over-writing a delivery status)
DateTime ldTempDate, ldStatusDate
string lsDONO, lsPrevDONO, lsList, lsAWB, lsCarrier, lsZip, lsSQL
String  lsShipvia, lsSchCd, lsTransport , ls_Code_Descript

// pvh 02.15.06 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

idw_main.AcceptText()
If idw_main.RowCount() > 0 Then
		
	If wf_validation() = -1 Then
		SetMicroHelp("Save failed!")
		Return -1
	End If
	
	idw_main.SetItem(1,'last_update', ldtToday ) 
	idw_main.SetItem(1,'last_user',gs_userid)
	
End If

// Assign Order No.
If ib_edit = False Then
			
	llShipno = g.of_next_db_seq(gs_project,'Shipment','Ship_no')
	If llShipno <= 0 Then
		messagebox(is_title,"Unable to retrieve the next available Shipment Number!")
		Return -1
	End If
	
	lsorder = Trim(Left(gs_project,9)) + String(llShipno,"000000")
			
	idw_main.SetItem(1,"project_id",gs_project)
	idw_main.SetItem(1,"ship_no",lsorder)
	
	llRowCount = idw_detail.RowCount()
	For lLRowPos = 1 to llRowCount
		idw_detail.SetItem(llRowPos, "ship_no", lsorder)
	Next		
	
	idw_Origin.SetItem(1,'ship_no', lsOrder)
	idw_Dest.SetItem(1,'ship_no', lsOrder)
	
Else /*updating existing record*/	
		
End If


////////////////////////////////////////////////////////////////////////////
//if ibAWBChanged or ibZipChanged or ibCarrierChanged then
if ibAWBChanged or ibCarrierChanged then

		If idw_detail.RowCount() > 0 Or  idw_order.RowCount() > 0 Then
			//Must keep Order(s) in sync with shipment (AWB/Carrier/Zip)
			lsAWB = idw_main.GetItemString(1, 'awb_bol_no')
			lsCarrier = idw_main.GetItemString(1, 'carrier_code')
			//Messagebox(is_title, 'Changing the AWB on associated order(s) as well!', Information!)
			//messagebox("ship no", isShipNo)
			// cycle thru distinct RODO_NOs to create 'update' sql...
			//Jxlim 03/08/2012 BRD #337 Pandora-OTM; Pandora doesn't have detail tab on shipment screen, use order tab
			//For Pandora we don't update AWB on associated order, we only do this on carrier changed.
			If gs_project = 'PANDORA' Then
						llRowCount = idw_order.RowCount()
						For llRowPos = 1 to llRowCount
							lsDONO = idw_order.GetItemString(llRowPos, 'RODO_NO')
							If  lsDONO <> lsPrevDONO then
								lsList = lsList + ",'" + lsDONO + "'"
								lsPrevDONO = lsDONO
							End If
						Next /*next detail row*/
			Else
						llRowCount = idw_detail.RowCount()
						For llRowPos = 1 to llRowCount
							lsDONO = idw_detail.GetItemString(llRowPos, 'RODO_NO')
							If  lsDONO <> lsPrevDONO then
								lsList = lsList + ",'" + lsDONO + "'"
								lsPrevDONO = lsDONO
							End If
						Next /*next detail row*/
			End If
			lsList = mid(lsList, 2)  //strip out preceding comma
//			lsList = lsPrevDONO //TEMPO!!!!
//			messagebox ("TEMPO - AWB" + lsAWB, "Project: " + gs_project + ", do_no: " + lsList)
		  /* - Use datawindow and only commit on save?
			  - Flag it(awb/carrier/zip) as changed then update on save */
			lsSQL = "update delivery_master"
			if ibAWBChanged then lsSQL += " set awb_bol_no = '" + lsAWB + "'"
			if ibCarrierChanged then 
				If ibAWBChanged then
					lsSQL += ", Carrier = '" + lsCarrier + "'"
				Else
					//Jxlim 03/07/2012 BRD #337 If carrier has changed on shipment info screen then
					//Get carrier_code, address_1 for ship_via, user_field1 for Sch_cd, transport_mode from carrier_master
					//Set/update carrier, ship_via, Sch_cd(user_field1), Transport_mode, Req Service (agent_info) on to delivery_master
					//Shipment table is Carrier_code but delivery_master is Carrier
					If gs_project = 'PANDORA' Then									
						//address_1 is for Ship_via, user_field1 is for sch_cd
						//Select Address_1, user_field1 INTO :lsShipVia, :lsSchCD	
						//// LTK Pandora #413 added transport_mode
						//Select Address_1, user_field1, transport_mode INTO :lsShipVia, :lsSchCD, :lsTransport		
						//From Carrier_Master where Project_ID = 'PANDORA' and Carrier_Code = :lsCarrier and inactive is null;
						
						// LTK 20120521  Fix of original #337 - Should have been looking for an inactive code of 
						// null or 0 (the client sets this code to 0 via the checkbox when turning it off)
						Select Address_1, user_field1, transport_mode INTO :lsShipVia, :lsSchCD, :lsTransport		
						From Carrier_Master 	where Project_ID = 'PANDORA' and Carrier_Code = :lsCarrier 
						and ( inactive is null or inactive = '0' ) ;

						//Jxlim Transport_mode is the the last 3 letters from carrier_code)
						//lsTransport = Mid(lscarrier,5,3)		// LTK Pandora #413 now setting DM.tranpsport_mode with CM..tranpsport_mode
						
						//Jxlim Service Level = SL that uses for requested service, agent_info on Deliver_master
						SELECT 	Code_Descript 	INTO :ls_Code_Descript FROM 	Lookup_Table   
						Where 	project_id = :gs_project and Code_type = 'SL' and Code_ID = :lsSchCD;
																	
						lsSQL += " set Carrier = '" + lsCarrier + "'"
						lsSQL +=", Ship_via = '" + lsShipVia + "'"
						lsSQL +=", user_field1 = '" + lsSchCD + "'"
						lsSQL +=", Transport_mode = '" + lsTransport + "'"
						lsSQL +=", Agent_info = '" + ls_Code_Descript	 + "'"							
				
												
					Else
						lsSQL += " set Carrier = '" + lsCarrier + "'"
					End If
				end if
			end if
			//if ibZipChanged....Still need to implement this (for Zip)
			/*if ibZipChanged then 
				if ibAWBChanged or ibCarrierChanged then
					lsSQL += ", zip = '" + lsZip + "'"
				else
					lsSQL += " set zip = '" + lsZip + "'"
				end if
			end if*/
			
			lsSQL += " where project_id = '" + gs_project + "'"
			lsSQL += " and do_no in (" + lsList + ")"
			//messagebox ("TEMPO - lsSQL", lsSQL)
			Execute Immediate :lsSQL Using SQLCA;			
			ibAWBChanged = false
			ibZipChanged = False
			ibCarrierChanged = False	
		End If
end if

////////////////////////////////////////////////////////////////////////////
if ibStatChanged then
	//status data window has changed, so...
	/* cycle through status records to set shipment status (ord_status) */
	lsStatus = idw_main.GetItemString(1, 'ord_status')
	if upper(left(lsStatus, 1)) = 'D' then lbDelivered = true
	
	idw_status.SetSort("status_date")
	idw_status.Sort()
	for i = 1 to idw_status.RowCount()
		lsStatus = idw_status.GetItemString(i, "status_code")
		ldStatusDate = idw_status.GetItemDateTime(i, 'Status_Date')
		if not lbDelivered then 
			idw_main.SetItem(1, 'Ord_status', lsStatus)
			idw_main.SetItem(1, 'Ord_status_Date', ldStatusDate)
		end if
	
			choose case lsStatus 
				case 'D', 'D1'
					lbDelivered = True
					// Put this (update of shipment table) in a subroutine?...
					ldTempDate = idw_main.GetItemDateTime(1, 'Freight_ATA')
					if isnull(ldTempDate) or ldStatusDate < ldTempDate then
						//messagebox ("TEMP", "StatusDate ==> Freight_ATA: " + string(ldStatusDate))
						idw_main.SetItem(1, 'Freight_ATA', ldStatusDate)
						//idw_main.SetItem(1, 'Ord_status', 'D') //Do we want to set Ord_Status on Order(s) also?  
						idw_main.SetItem(1, 'Ord_Status_Date', ldStatusDate)
					else
						//messagebox ("TEMP", "TempDate: " + string(ldTempDate) + "StatusDate: " + string(ldStatusDate))
					end if
				case 'AD', 'AG', 'AJ'
					//AD - Delivery Appointment Date and Time
					//AG - Estimated Delivery
					//AJ - Tendered for Delivery 										
					ldTempDate = idw_main.GetItemDateTime(1, 'Freight_ETA')
					if isnull(ldTempDate) or ldStatusDate < ldTempDate then
						//messagebox ("TEMP", "StatusDate ==> Freight_ETA: " + string(ldStatusDate))
						idw_main.SetItem(1, 'Freight_ETA', ldStatusDate)
					else
						//messagebox ("TEMP", "TempDate: " + string(ldTempDate) + "StatusDate: " + string(ldStatusDate))
					end if
					/*
					if lsStatus = 'AG' then
						ldTempDate = idw_main.GetItemDateTime(1, 'Freight_ATD')
						if isnull(ldTempDate) or ldStatusDate < ldTempDate then
							//messagebox ("TEMP", "StatusDate ==> Freight_ATD: " + string(ldStatusDate))
							idw_main.SetItem(1, 'Freight_ATD', ldStatusDate)
						else
							//messagebox ("TEMP", "TempDate: " + string(ldTempDate) + "StatusDate: " + string(ldStatusDate))
						end if
					end if
					*/
				case 'AF', 'P1' // dts added 05/05/06
					//AF - Departed Pick-up Location
					//P1 - Departed Origin
					ldTempDate = idw_main.GetItemDateTime(1, 'Freight_ATD')
					if isnull(ldTempDate) or ldStatusDate < ldTempDate then
						//messagebox ("TEMP", "StatusDate ==> Freight_ETA: " + string(ldStatusDate))
						idw_main.SetItem(1, 'Freight_ATD', ldStatusDate)
					else
						//messagebox ("TEMP", "TempDate: " + string(ldTempDate) + "StatusDate: " + string(ldStatusDate))
					end if
				case else
					//
			end choose
	
	next
	idw_status.SetSort("status_date D")
	idw_status.Sort()
	ibStatChanged = False // - 04/10/07
	////////////////////////////////////////////////////////////////////////
end if


//Jxlim BRD#526 move from ue_delete event to ue_save. Update ord status when saving the shipment screen only.
String lsordstatus, lsConslNo

If	ib_UpdateOrderRemoveStatus = True Then
	If Upper(gs_project) = 'PANDORA'  THEN	
		//Jxlim BRD #437 If user clicks Yes, do the following: Change Delivery_Master.OTM_Status = $$HEX1$$1820$$ENDHEX$$N$$HEX1$$1d20$$ENDHEX$$, Non OTM and  Set Delivery_Master.Consolidation_no = Null
		lsordstatus = 'N'
		//SetNull(lsConslNo)  //Jxlim can't use set null because pb will set everything to null to the concatenate variable that call below on lsSDQL
		lsConslNo = ''		
		isrodono = mid(isrodono, 2) 		
		
				lsSQL = "Update delivery_master"
				lsSQL += " Set Delivery_Master.OTM_Status  = '" + lsordstatus + "'"					
				lsSQL +=", Delivery_Master.Consolidation_no = '" +  lsConslNo	 + "'"						
				lsSQL += " Where project_id = '" + gs_project + "'"
				lsSQL += " And do_no in (" + isrodono + ")"					
										
				Execute Immediate :lsSQL Using SQLCA;							
				ib_UpdateOrderRemoveStatus = False						
	End If	
End If				
				
/* commented out 05/05/06 (replaced by code above)
//If we have a status record of delivered, set the Shipment Status to 'Delivered'
If idw_status.Find("Upper(Status_Code) = 'D' or Upper(Status_Code) = 'D1'",1,idw_status.RowCount()) > 0 Then
	idw_main.SetItem(1,'ord_status','D')
End If
*/

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If Upper(gs_project) = 'CHINASIMS'  THEN
	 SQLCA.DBParm = "disablebind =0"
End If


If idw_main.RowCount() > 0 Then
	liRC = idw_main.Update()		
Else 
	liRC = 1
End If
if liRC = 1 then liRC = idw_detail.Update()
if liRC = 1 then liRC = idw_status.Update()
//SQLCA.DBParm = "disablebind =0"
if liRC = 1 then liRC = idw_origin.Update()
if liRC = 1 then liRC = idw_Dest.Update()
//SQLCA.DBParm = "disablebind =1"

//Jxlim 12/14/2012 BRD #526 Pandora remove order from shipment and do necessary update to idw_order and idw_main after saved on shipment screen, if not save rollback the remove order.
If Upper(gs_project) = 'PANDORA'  THEN
	If liRC = 1 then liRC = idw_order.Update()	
		//Jxlim 12/16/2012 Pandora BRD #526 moved from ue_delete event to perform the dw_order update when saved.
		//llRC = idw_order.Update()
		IF liRC = 1 then		
			// LTK 20120510  	Pandora #395 Update shipment table with last user and set the datawindow values as well 
			//						in the event that changes have been made to the shipment datawindow
			if 	idw_main.RowCount() > 0 then
				string ls_ship_no, ls_wh_code, ls_project_id
				datetime ldt_wh_time
				ldt_wh_time = f_getlocalworldtime(idw_main.object.wh_code[1])
				ls_ship_no = idw_main.object.ship_no[1]
				ls_wh_code = idw_main.object.wh_code[1]
				ls_project_id = idw_main.object.project_id[1]
				
				update shipment
				set last_user = :gs_userid, last_update = :ldt_wh_time
				where ship_no = :ls_ship_no
				and wh_code = :ls_wh_code
				and project_id = :ls_project_id;
				
				idw_main.object.last_user[1] = gs_userid
				idw_main.object.last_update[1] = ldt_wh_time
			end if			
			//TimA 05/14/13 removed the Commit rollback below because it conflicts with the others.
			//Execute Immediate "COMMIT" using SQLCA;
			//f_method_trace( ll_method_trace_id, iw_window.Classname(), 'End ue_delete: Committed deleted shipment orders.' )	//08-Feb-2013  :Madhu commented
			f_method_trace_special( gs_project, iw_window.Classname() + ' -ue_delete','End ue_delete: Committed deleted shipment orders. ',isrodono,' ',' ',' ' ) //08-Feb-2013  :Madhu added

			ib_changed = False		//Jxlim 12/26/2012 BRD #526 Set to false to prevent from double prompt to save message. True will trigger parent.ue_save		
		//Else
		//	Execute Immediate "ROLLBACK" using SQLCA;
		End If
End If
//Jxlim 12/19/2012 Pandora end of BRD #526


If idw_main.RowCount() = 0 and liRC = 1 Then liRC = idw_main.Update()

If Upper(gs_project) = 'CHINASIMS'  THEN
	 SQLCA.DBParm = "disablebind =1"
End If


IF (liRC = 1) THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		If idw_main.RowCount() > 0 Then 
			ib_changed = False
			ib_edit = True
			This.Title = is_title  + " - Edit"
			wf_check_status()
			SetMicroHelp("Record Saved!")
		End If
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

event ue_delete;call super::ue_delete;Long i, ll_cnt, ll_ret
String	lsRONO

If f_check_access(is_process,"D") = 0 Then Return

// Prompting for deletion
If MessageBox(is_title, "Are you sure you want to delete this Shipment record",Question!,YesNo!,2) = 2 Then
	Return
End If

SetPointer(HourGlass!)

ib_changed = False

tab_main.SelectTab(1)

For i = idw_status.RowCount() to 1 Step -1
	idw_status.DeleteRow(i)
Next

For i = idw_detail.RowCount() to 1 Step -1
	idw_detail.DeleteRow(i)
Next

idw_origin.DeleteRow(1)
idw_dest.DeleteRow(1)

idw_main.DeleteRow(1)

If This.Trigger Event ue_save() = 0 Then
	SetMicroHelp("Record	Deleted!")
	//If the user clicks Yes, do the following Change Delivery_Master.OTM_Status = $$HEX1$$1820$$ENDHEX$$N$$HEX1$$1d20$$ENDHEX$$, Non OTM  Set Delivery_Master.Consolidation_no = Null
Else
	SetMicroHelp("Record	deleted failed!")
End If
This.Trigger Event ue_edit()

end event

event ue_unlock;call super::ue_unlock;//Jxlim 04/26/2012 BRD #404 Lock and unLock Shipment using F10 for access Level < 1
String  ls_status

If gs_project = 'PANDORA' THEN
	//At all stages of the shipment, allow F10 for Super Users to unlock all the fields
        wf_lock(False)
END IF


end event

type tab_main from w_std_master_detail`tab_main within w_shipments
integer x = 0
integer y = 13
integer width = 3708
integer height = 2122
tabpage_order tabpage_order
tabpage_detail tabpage_detail
tabpage_status tabpage_status
tabpage_bol tabpage_bol
end type

on tab_main.create
this.tabpage_order=create tabpage_order
this.tabpage_detail=create tabpage_detail
this.tabpage_status=create tabpage_status
this.tabpage_bol=create tabpage_bol
call super::create
this.Control[]={this.tabpage_main,&
this.tabpage_search,&
this.tabpage_order,&
this.tabpage_detail,&
this.tabpage_status,&
this.tabpage_bol}
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_order)
destroy(this.tabpage_detail)
destroy(this.tabpage_status)
destroy(this.tabpage_bol)
end on

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer x = 15
integer y = 99
integer width = 3679
integer height = 2010
string text = "Shipment Info"
tab_locations tab_locations
cb_geteta cb_geteta
cb_getetd cb_getetd
cb_etamaint cb_etamaint
dw_master dw_master
sle_awb sle_awb
st_shipment_awb_bol_nbr st_shipment_awb_bol_nbr
end type

on tabpage_main.create
this.tab_locations=create tab_locations
this.cb_geteta=create cb_geteta
this.cb_getetd=create cb_getetd
this.cb_etamaint=create cb_etamaint
this.dw_master=create dw_master
this.sle_awb=create sle_awb
this.st_shipment_awb_bol_nbr=create st_shipment_awb_bol_nbr
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_locations
this.Control[iCurrent+2]=this.cb_geteta
this.Control[iCurrent+3]=this.cb_getetd
this.Control[iCurrent+4]=this.cb_etamaint
this.Control[iCurrent+5]=this.dw_master
this.Control[iCurrent+6]=this.sle_awb
this.Control[iCurrent+7]=this.st_shipment_awb_bol_nbr
end on

on tabpage_main.destroy
call super::destroy
destroy(this.tab_locations)
destroy(this.cb_geteta)
destroy(this.cb_getetd)
destroy(this.cb_etamaint)
destroy(this.dw_master)
destroy(this.sle_awb)
destroy(this.st_shipment_awb_bol_nbr)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer x = 15
integer y = 99
integer width = 3679
integer height = 2010
cb_shipment_clear cb_shipment_clear
cb_shipment_search cb_shipment_search
dw_search_result dw_search_result
dw_search_entry dw_search_entry
end type

on tabpage_search.create
this.cb_shipment_clear=create cb_shipment_clear
this.cb_shipment_search=create cb_shipment_search
this.dw_search_result=create dw_search_result
this.dw_search_entry=create dw_search_entry
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_shipment_clear
this.Control[iCurrent+2]=this.cb_shipment_search
this.Control[iCurrent+3]=this.dw_search_result
this.Control[iCurrent+4]=this.dw_search_entry
end on

on tabpage_search.destroy
call super::destroy
destroy(this.cb_shipment_clear)
destroy(this.cb_shipment_search)
destroy(this.dw_search_result)
destroy(this.dw_search_entry)
end on

type tab_locations from tab within tabpage_main
boolean visible = false
integer x = 22
integer y = 909
integer width = 2992
integer height = 877
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_origin tabpage_origin
tabpage_dest tabpage_dest
end type

on tab_locations.create
this.tabpage_origin=create tabpage_origin
this.tabpage_dest=create tabpage_dest
this.Control[]={this.tabpage_origin,&
this.tabpage_dest}
end on

on tab_locations.destroy
destroy(this.tabpage_origin)
destroy(this.tabpage_dest)
end on

type tabpage_origin from userobject within tab_locations
integer x = 15
integer y = 90
integer width = 2962
integer height = 774
long backcolor = 79741120
string text = "Ship From"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_origin dw_origin
end type

on tabpage_origin.create
this.dw_origin=create dw_origin
this.Control[]={this.dw_origin}
end on

on tabpage_origin.destroy
destroy(this.dw_origin)
end on

type dw_origin from u_dw_ancestor within tabpage_origin
integer y = 16
integer width = 2977
integer height = 704
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_shipment_location"
boolean border = false
end type

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event itemchanged;call super::itemchanged;ib_changed = True
end event

type tabpage_dest from userobject within tab_locations
integer x = 15
integer y = 90
integer width = 2962
integer height = 774
long backcolor = 79741120
string text = "Ship To"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_dest dw_dest
end type

on tabpage_dest.create
this.dw_dest=create dw_dest
this.Control[]={this.dw_dest}
end on

on tabpage_dest.destroy
destroy(this.dw_dest)
end on

type dw_dest from u_dw_ancestor within tabpage_dest
integer y = 16
integer width = 3248
integer height = 733
integer taborder = 20
string dataobject = "d_shipment_location"
boolean border = false
end type

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event itemchanged;call super::itemchanged;ib_changed = True
end event

type cb_geteta from commandbutton within tabpage_main
integer x = 900
integer y = 1914
integer width = 402
integer height = 77
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Get ETA"
end type

event clicked;date ldtETD, ldtETA
string lsWH, lsCarrier, lsToCountry, lsZip

ldtETD = date(idw_main.GetItemDateTime(1, 'freight_etd'))
if isnull(ldtETD) then
	messagebox("Get ETA", "Must enter Freight_ETD to calculate ETA.")
	return
end if

lsWH = idw_main.GetItemString(1, 'wh_Code')
lsCarrier = idw_main.GetItemString(1, 'carrier_code')
lsToCountry = idw_dest.GetItemString(1, 'Country') //grabbing dest. country here instead of below (actually, in addition to)
lsZip = idw_dest.GetItemString(1, 'Zip')

ldtETA = iu_shipments.uf_Get_ETA(ldtETD, gs_Project, lsWH, lsCarrier, lsToCountry, lsZip)

if isnull(ldtETA) then
	messagebox("Get ETA", "Null ETA - You must enter an ETA (Freight ETA)")
ElseIf ldtETD = date('1900-01-01') then
	messagebox("Get ETA", "No ETA Data.  You must enter an ETA (Freight ETA)")
Else
	idw_main.SetItem(1, 'freight_eta', ldtETA)
	ib_changed = true
end if


/*
date ldt, ldtStart

ldtStart = date('2007-12-28')

ldt = iu_Shipments.uf_Get_ETA(ldtStart, gs_Project, 'PWAVE-FG', '1BOS', 'DE', '12345')
messagebox ("ETA, Start: " +string(ldtStart), '12345: ' + string(ldt))


ldt = iu_Shipments.uf_Get_ETA(ldtStart, gs_Project, 'PWAVE-FG', '1BOS', 'DE', '75039')
messagebox ("ETA", '75039: ' + string(ldt))

ldt = iu_Shipments.uf_Get_ETA(ldtStart, gs_Project, 'PWAVE-FG', '1BOS', 'DE', '111111')
messagebox ("ETA", '111111: ' + string(ldt))

ldt = iu_Shipments.uf_Get_ETA(ldtStart, gs_Project, 'PWAVE-FG', '1BOS', 'DE', '66000')
messagebox ("ETA", '66000: ' + string(ldt))

ldt = iu_Shipments.uf_Get_ETA(ldtStart, gs_Project, 'PWAVE-FG', '1BOS', 'DEX', '67900')
messagebox ("ETA", 'DEX, 67900: ' + string(ldt))

ldt = iu_Shipments.uf_Get_ETA(ldtStart, gs_Project, 'PWAVE-FG', '1BOS', 'BG', '67900')
messagebox ("ETA", 'BG, 67900: ' + string(ldt))

ldt = iu_Shipments.uf_Get_ETA(ldtStart, gs_Project, 'PWAVE-FG', '1BOS', 'BE', '67900')
messagebox ("ETA", 'BE, 67900: ' + string(ldt))

ldt = iu_Shipments.uf_Get_ETA(ldtStart, gs_Project, 'PWAVE-FG', 'x1BOS', 'DE', '7900')
messagebox ("ETA", 'No Carrier-Country: ' + string(ldt))

if isnull(ldt) then
	messagebox("ETA", "Null - You must enter an ETA (Freight Eta)")
end if

if ldt = date('1900-01-01') then
	messagebox("ETA", "No ETA Data. You must enter an ETA (Freight Eta)")
end if
*/
end event

type cb_getetd from commandbutton within tabpage_main
integer x = 472
integer y = 1914
integer width = 402
integer height = 77
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Get ETD"
end type

event clicked;date ldtETD, ldtStart
string lsWH, lsCarrier, lsToCountry

ldtStart = date(idw_main.GetItemDateTime(1, 'freight_etd'))
if isnull(ldtStart) then
	ldtStart = date(idw_main.GetItemDateTime(1, 'ord_date'))
end if

lsWH = idw_main.GetItemString(1,'wh_Code')
lsCarrier = idw_main.GetItemString(1,'carrier_code')
lsToCountry = idw_dest.GetItemString(1,'Country') //grabbing dest. country here instead of below (actually, in addition to)

//ETD may slide based on carrier departure days.
ldtETD = iu_shipments.uf_Get_ETD(ldtStart, gs_Project, lsWH, lsCarrier, lsToCountry)
//	ldtETA = uf_Get_ETA(date(ldtETD), gs_Project, lsWarehouse, lsCarrier, lsToCountry, lsZip)

if isnull(ldtETD) then
	messagebox("Get ETD", "Null ETD - You must enter an ETD (Freight Etd)")
ElseIf ldtETD = date('1900-01-01') then
	messagebox("ETD", "No ETD Data.  You must enter an ETD (Freight Etd)")
Else
	idw_main.SetItem(1, 'freight_etd', ldtETD)
	ib_changed = true
end if
end event

type cb_etamaint from commandbutton within tabpage_main
integer x = 1331
integer y = 1914
integer width = 402
integer height = 77
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "ETA Maint."
end type

event clicked;/*
If lsShipNo <> "-1" Then 
	lstrparms.String_Arg[1] = lsShipNo
	OpenSheetwithparm(w_shipments,lStrparms, w_main, gi_menu_pos, Original!)
End If
*/


Str_parms	lStrparms

Lstrparms.String_arg[1] = ""
//lstrparms.String_arg[1] = idw_main.GetItemString(1, 'Awb_Bol_no')
//OpenSheetWithParm(w_orphans, lStrparms, w_main, gi_menu_pos, Original!)
//OpenSheet(w_eta_maint, w_main, 2, Original!)
OpenSheetwithparm(w_eta_maint, lStrparms, w_main, gi_menu_pos, Original!)
end event

type dw_master from u_dw_ancestor within tabpage_main
integer y = 19
integer width = 3664
integer height = 1875
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_shipment_header"
boolean border = false
end type

event clicked;call super::clicked;
//DatawindowChild	ldwc
//
//Choose Case Upper(dwo.name)
//		
//	Case 'CARRIER_CODE'
//		
//		//load carrier dropdown if not already loaded
//		This.GetChild('carrier_code',ldwc)
//		If ldwc.RowCount() < 2 Then
//			ldwc.Retrieve(gs_project)
//		End If
//		
//End Choose
end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event itemerror;call super::itemerror;Return 2
end event

event ue_postitemchanged;call super::ue_postitemchanged;
String	lsWarehouse, lsWHNAme, lsaddr1, lsAddr2, lsAddr3, lsAddr4, lsCity, lsState, lsZip, lsCountry,	&
			lsTel, lsFax, lsContact, lsEmail
			
//Jxlim 03/15/2012 BRD #337 Pandora-OTM no need to trigger this for Pandora, it asked to save even thought it is already saved.
If gs_project <> 'PANDORA' Then					
	ib_changed = True
End If

Choose Case Upper(dwo.Name)
		
	Case 'WH_CODE' /* Populate Dest/Origin based on order Type*/
		
		If idw_main.GetITemString(1,'ord_type') > '' THen
			
			lsWarehouse = idw_main.GetITemString(1,'wh_Code')
			
			Select wh_Name, address_1, address_2, address_3, address_4, city, state, zip, country,
					 tel, fax, contact_person, email_address
			Into	:lsWHNAme, :lsAddr1, :lsAddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry,
					:lsTel, :lsFax, :lsContact, :lsEmail
			From Warehouse
			Where wh_Code = :lsWarehouse;
			
			If idw_main.GetITemString(1,'ord_type') = 'I' Then /* Inbound, populate Dest Address*/
				
				idw_Dest.SetITem(1,'Name', lsWHNAme)
				idw_Dest.SetITem(1,'address_1', lsAddr1)
				idw_Dest.SetITem(1,'address_2', lsAddr2)
				idw_Dest.SetITem(1,'address_3', lsAddr3)
				idw_Dest.SetITem(1,'address_4', lsAddr4)
				idw_Dest.SetITem(1,'City', lsCity)
				idw_Dest.SetITem(1,'State', lsState)
				idw_Dest.SetITem(1,'Zip', lsZip)
				idw_Dest.SetITem(1,'Country', lsCountry)
				idw_Dest.SetITem(1,'tel', lsTel)
				idw_Dest.SetITem(1,'fax', lsFax)
				idw_Dest.SetITem(1,'contact_person', lsContact)
				idw_Dest.SetITem(1,'email_address', lsEmail)
											
			Else /* Outbound - Populate Origin Address Info */
				
				idw_Origin.SetITem(1,'Name', lsWHNAme)
				idw_Origin.SetITem(1,'address_1', lsAddr1)
				idw_Origin.SetITem(1,'address_2', lsAddr2)
				idw_Origin.SetITem(1,'address_3', lsAddr3)
				idw_Origin.SetITem(1,'address_4', lsAddr4)
				idw_Origin.SetITem(1,'City', lsCity)
				idw_Origin.SetITem(1,'State', lsState)
				idw_Origin.SetITem(1,'Zip', lsZip)
				idw_Origin.SetITem(1,'Country', lsCountry)
				idw_Origin.SetITem(1,'tel', lsTel)
				idw_Origin.SetITem(1,'fax', lsFax)
				idw_Origin.SetITem(1,'contact_person', lsContact)
				idw_Origin.SetITem(1,'email_address', lsEmail)
				
			End If
			
		End If /* Order Type present */
		
		
End Choose
end event

event itemchanged;call super::itemchanged;//long llRowCount, llRowPos
//string lsDONO, lsPrevDONO, lsList
//messagebox("Tempo - data", data)

//Jxlim 03/08/2012 Added ib_changed = True at the begining of itemchanged event.
ib_changed = True

Choose Case Upper(dwo.Name)
	// pvh 08/25/05 - GMT
	Case 'WH_CODE'
		g.setCurrentWarehouse( data )
		
	Case 'ORD_TYPE'		
		//Dont allow user to change Type if orders have already been added
		If idw_detail.RowCount() > 0 Then
			Messagebox(is_title,'You can not change the Order Type once orders have been added to the shipment!',StopSign!)
			Return 1			
		End If

	Case 'AWB_BOL_NO'
		//Must keep Order(s) in sync with shpment (AWB/Carrier/Zip)
		//What about Carrier/(Country)/Zip?			
		if g.ibEtaMaintEnabled then		
			ibAWBChanged = True
			Messagebox(is_title, 'The AWB on associated order(s) will be changed as well (on save)!', Information!)
		end if

	Case 'CARRIER_CODE'
		//Must keep Order(s) in sync with shpment (AWB/Carrier/Zip)
		//What about Carrier/(Country)/Zip?
		//Jxlim 03/07/2012 BRD #337 Pandora-OTM
		//When carrier code is changed on a shipment all of the orders in the shipment will changed.
		//Pandora does not have the ETA maintenance enable on outbound, we will add a check for Pandora project			
		//if g.ibEtaMaintEnabled then
		If g.ibEtaMaintEnabled Or gs_project = 'PANDORA' then
			ibCarrierChanged = True
			Messagebox(is_title, 'The Carrier on associated order(s) will be changed as well (on save)!', Information!)			
		End if
				
End Choose

end event

event retrieveend;call super::retrieveend;// pvh 08/25/05 - GMT
if rowcount <=0 then return AncestorReturnValue

g.setCurrentWarehouse( dw_master.object.wh_code[ 1 ] )

return AncestorReturnValue

end event

type sle_awb from singlelineedit within tabpage_main
integer x = 530
integer y = 16
integer width = 655
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;
iw_window.TriggerEvent('ue_Retrieve')
end event

type st_shipment_awb_bol_nbr from statictext within tabpage_main
integer y = 35
integer width = 527
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "AWB BOL Nbr:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type cb_shipment_clear from commandbutton within tabpage_search
integer x = 3321
integer y = 211
integer width = 315
integer height = 106
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;
idw_search.REset()
idw_Search.InsertROw(0)
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_shipment_search from commandbutton within tabpage_search
integer x = 3321
integer y = 77
integer width = 315
integer height = 99
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;
idw_Result.TriggerEvent('ue_retrieve')
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_search_result from u_dw_ancestor within tabpage_search
integer x = 4
integer y = 458
integer width = 3635
integer height = 1434
integer taborder = 20
string dataobject = "d_shipment_search_result"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

event ue_retrieve;call super::ue_retrieve;DateTime ldt_date
String ls_string, ls_where, ls_sql , lsShip_no, lsSql_dm
Long llcount

If idw_search.AcceptText() = -1 Then Return

idw_result.Reset()
ls_sql = isOrigsql

ls_where = " and Shipment.project_id = '" + gs_project + "' "

//Order Date From
ldt_date = idw_search.GetItemDateTime(1,"ord_date_from")
If  Not IsNull(ldt_date) Then
	ls_where += " and Shipment.ord_date >= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
End If

//Order Date To
ldt_date = idw_search.GetItemDateTime(1,"ord_date_To")
If  Not IsNull(ldt_date) Then
	ls_where += " and Shipment.ord_date <= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
End If

//Freight ETD Date From
ldt_date = idw_search.GetItemDateTime(1,"freight_etd_from")
If  Not IsNull(ldt_date) Then
	ls_where += " and Shipment.freight_etd >= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
End If

//Freight ETD Date To
ldt_date = idw_search.GetItemDateTime(1,"freight_etd_To")
If  Not IsNull(ldt_date) Then
	ls_where += " and Shipment.freight_etd <= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
End If

//Freight ETA Date From
ldt_date = idw_search.GetItemDateTime(1,"freight_eta_from")
If  Not IsNull(ldt_date) Then
	ls_where += " and Shipment.freight_eta >= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
End If

//Freight ETA Date To
ldt_date = idw_search.GetItemDateTime(1,"freight_eta_To")
If  Not IsNull(ldt_date) Then
	ls_where += " and Shipment.freight_eta <= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
End If

//Order Type
ls_string = idw_search.GetItemString(1,"ord_type")
if not isNull(ls_string) then
	ls_where += " and shipment.ord_type = '" + ls_string + "' "
end if

//Ord_status
//Jxlim 01/05/2012 BRD #337 Commented out for now may need this later for enhancement.
//If gs_project = 'PANDORA' Then	
//	//Get shipment records in which delivery order status is from search entry
//	ls_string = idw_search.GetItemString(1,"ord_status")
//	If not isNull(ls_string) Then				
//		lsSQL_dm = "Select Distinct sl.ship_no From Delivery_Master dm, Shipment_Line_Item sl	Where dm.DO_No = sl.rodo_no And Project_id = 'PANDORA' and dm.Ord_status = '" + ls_string + "' "		
//		If not isNull(lsship_no) Then	
//				ls_where += " and Shipment.ship_no  In (" + lsSql_dm + ")"		
//		End If
//	End If		 //Jxlim 01/05/2012 BRD #337
//Else
	//Order Status
	ls_string = idw_search.GetItemString(1,"ord_Status")
	if not isNull(ls_string) then
		ls_where += " and shipment.ord_Status = '" + ls_string + "' "
	end if
//End If

//Warehouse
ls_string = idw_search.GetItemString(1,"wh_Code")
if not isNull(ls_string) then
	ls_where += " and shipment.wh_Code = '" + ls_string + "' "
end if

//Carrier
ls_string = idw_search.GetItemString(1,"Carrier")
if not isNull(ls_string) then
	ls_where += " and shipment.Carrier_Code = '" + ls_string + "' "
end if

//AWB - Use Like
ls_string = idw_search.GetItemString(1,"awb_bol_no")
if not isNull(ls_string) then
	ls_where += " and shipment.awb_Bol_no Like '" + ls_string + "%' "
end if

//Pro No
ls_string = idw_search.GetItemString(1,"pro_no")
if not isNull(ls_string) then
	ls_where += " and shipment.pro_no =  '" + ls_string + "' "
end if

//Jxlim BRD 12/30/2011 OTM-SIMS Pandora
//Ship_Id
If gs_project = 'PANDORA' Then
	//ship_ID
	ls_string = idw_search.GetItemString(1,"ship_id")
	If not isNull(ls_string) Then
		ls_where += " and Shipment.ship_id = '" + ls_string + "' "
	End If	
	
//	//Invoice_no  //Jxlim may need this later Jxlim 01/05/2011 BRD #337
//	ls_string = idw_search.GetItemString(1,"invoice_no")
//	If not isNull(ls_string) Then
//		ls_where += " and SL.Invoice_no = '" + ls_string + "' "
//	End If	

	//Invoice_no
	ls_string = idw_search.GetItemString(1,"invoice_no")
	If not isNull(ls_string) Then
		Select Ship_No Into : lsShip_no
		From Shipment_Line_Item
		Where Invoice_No = :ls_string
		Using Sqlca;	
		
		If not isNull(lsship_no) Then
			ls_where += " and Shipment.ship_no = '" + lsship_no + "' "
		End If		
	End If	
End If		//Jxlim BRD 01/05/2011 OTM-SIMS Pandora

//IF not lb_where THEN
//   IF	i_nwarehouse.of_msg(is_title,1) <> 1 THEN Return
//END IF	

ls_sql += ls_where

idw_result.SetSqlSelect(ls_sql)

If idw_result.Retrieve() = 0 Then
	messagebox(is_title,"No records found!")
End If

end event

event doubleclicked;call super::doubleclicked;
If Row > 0 Then
	isshipno = This.GetITemString(row,'shipment_ship_no')
	iw_window.TriggerEvent('ue_retrieve')
End If
end event

type dw_search_entry from datawindow within tabpage_search
integer x = 18
integer y = 42
integer width = 3639
integer height = 403
integer taborder = 30
string title = "none"
string dataobject = "d_shipment_search_entry"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;DatawindowChild	ldwc

Choose Case Upper(dwo.name)
		
	Case 'CARRIER'
		
		//load carrier dropdown if not already loaded
		This.GetChild('carrier',ldwc)
		If ldwc.RowCount() < 2 Then
			ldwc.Retrieve(gs_project)
		End If
		
End Choose
end event

event constructor;
g.of_check_label(this) 
end event

type tabpage_order from userobject within tab_main
event create ( )
event destroy ( )
integer x = 15
integer y = 99
integer width = 3679
integer height = 2010
long backcolor = 79741120
string text = "Orders"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_otmchanged cb_otmchanged
dw_packprint dw_packprint
dw_order dw_order
cb_confirm cb_confirm
cb_printci cb_printci
cb_delete_order cb_delete_order
cb_clearall_orders cb_clearall_orders
cb_selectall_orders cb_selectall_orders
st_1 st_1
cb_printpack cb_printpack
cb_add cb_add
end type

on tabpage_order.create
this.cb_otmchanged=create cb_otmchanged
this.dw_packprint=create dw_packprint
this.dw_order=create dw_order
this.cb_confirm=create cb_confirm
this.cb_printci=create cb_printci
this.cb_delete_order=create cb_delete_order
this.cb_clearall_orders=create cb_clearall_orders
this.cb_selectall_orders=create cb_selectall_orders
this.st_1=create st_1
this.cb_printpack=create cb_printpack
this.cb_add=create cb_add
this.Control[]={this.cb_otmchanged,&
this.dw_packprint,&
this.dw_order,&
this.cb_confirm,&
this.cb_printci,&
this.cb_delete_order,&
this.cb_clearall_orders,&
this.cb_selectall_orders,&
this.st_1,&
this.cb_printpack,&
this.cb_add}
end on

on tabpage_order.destroy
destroy(this.cb_otmchanged)
destroy(this.dw_packprint)
destroy(this.dw_order)
destroy(this.cb_confirm)
destroy(this.cb_printci)
destroy(this.cb_delete_order)
destroy(this.cb_clearall_orders)
destroy(this.cb_selectall_orders)
destroy(this.st_1)
destroy(this.cb_printpack)
destroy(this.cb_add)
end on

type cb_otmchanged from commandbutton within tabpage_order
integer x = 2373
integer y = 16
integer width = 581
integer height = 96
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear &OTM Changed"
end type

event clicked;//Jxlim 01/04/2012 Pandora-OTM BRD #337
Long ll_rowcount, llFindRow, llrc
String lsfind

idw_order.SetReDraw(False)

ll_rowcount =  idw_order.Rowcount()

//Selected orders must be in Otm_Changed = 'Y' to clear the status by setting to 'N'
lsfind = "C_select_Ind = 'Y'  And Otm_changed = 'Y'"
llFindRow =idw_Order.Find(lsfind,1, ll_rowcount)

Do While llFindRow > 0
	idw_order.SetItem(llFindRow,'Otm_changed','N')
	 llFindRow++
			 // Prevent endless loop
			 IF llFindRow > ll_rowcount THEN EXIT
			 llFindRow = idw_order.Find(lsFind, llFindRow, ll_rowcount)
Loop

//since we updated Otm_changed, we need to update the order tab and commit
llRC = idw_order.Update()
IF llRC = 1 then
	
	// LTK 20120510  	Pandora #395 Update shipment table with last user and set the datawindow values as well 
	//						in the event that changes have been made to the shipment datawindow
	if 	idw_main.RowCount() > 0 then
		string ls_ship_no, ls_wh_code, ls_project_id
		datetime ldt_wh_time
		ldt_wh_time = f_getlocalworldtime(idw_main.object.wh_code[1])
		ls_ship_no = idw_main.object.ship_no[1]
		ls_wh_code = idw_main.object.wh_code[1]
		ls_project_id = idw_main.object.project_id[1]
		
		update shipment
		set last_user = :gs_userid, last_update = :ldt_wh_time
		where ship_no = :ls_ship_no
		and wh_code = :ls_wh_code
		and project_id = :ls_project_id;
		
		idw_main.object.last_user[1] = gs_userid
		idw_main.object.last_update[1] = ldt_wh_time
	end if
	
	Execute Immediate "COMMIT" using SQLCA;
Else
	Execute Immediate "ROLLBACK" using SQLCA;
End If
	
idw_order.SetRedraw(True)
ib_Changed = True



end event

event constructor;
g.of_check_label_button(this)
end event

type dw_packprint from datawindow within tabpage_order
boolean visible = false
integer x = 1704
integer y = 1040
integer width = 688
integer height = 400
integer taborder = 40
string title = "none"
string dataobject = "d_packing_prt_Pandora"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_order from u_dw_ancestor within tabpage_order
event ue_add_orders ( )
event ue_printpack ( )
event type integer ue_checkstatus ( )
event ue_confirm ( )
event ue_printci ( )
event ue_enable ( )
event ue_clearall ( )
event ue_selectall ( )
integer x = 22
integer y = 125
integer width = 2695
integer height = 1840
integer taborder = 20
string dataobject = "d_shipment_orderlevel"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_add_orders();
Str_Parms	lstrParms
Long			llArrayPos, llArrayCount, llRC
String	lsShipNo, lsAWB, lsCarrier, lsZip, lsShip_id

//make sure changes are saved before adding orders
If ib_changed then
	Messagebox(is_title,'Please save changes before adding orders.')
	Return
End If

If idw_Main.GetItemString(1,'ord_Type') = 'I' Then
	lstrparms.String_arg[1] = 'I'
	lsZip = idw_Origin.GetItemString(1,'Zip')
Else
	lstrparms.String_arg[1] = 'O'
	lsZip = idw_dest.GetItemString(1,'Zip')
End If

//Zip, Carrier and AWB must be entered before adding Orders
If  isNull(idw_Main.GetItemString(1,'Carrier_code')) or isnull(lsZip) Then
	//isNull(idw_Main.GetItemString(1,'Ship_id')) or &  
	//isnull(lsZip) Then
//	isNull(idw_Main.GetItemString(1,'Awb_bol_no')) or &   //Jxlim 01/03/2012	
	//isnull(idw_dest.GetItemString(1,'Zip')) Then
	
	Messagebox(is_Title,'Carrier, AWB and Destination Zip are required before adding Orders!',StopSign!)
	tab_main.SelectTab(1)
	Return
	
End If

Lstrparms.String_arg[2] = idw_Main.GetItemString(1,'Carrier_code')
//Lstrparms.String_arg[3] = idw_dest.GetItemString(1,'Zip')
Lstrparms.String_arg[3] = lsZip

//Jxlim 01/03/2012 Pandora-OTM #337
If gs_project = 'PANDORA' Then
	Lstrparms.String_arg[4] = idw_Main.GetItemString(1,'Ship_id')  
	//Lstrparms.String_arg[4] =idw_Main.GetItemString(1,'ship_no') 		//system number
Else
	Lstrparms.String_arg[4] = idw_Main.GetItemString(1,'Awb_bol_no')
End If

lsShipNo = idw_Main.GetItemString(1,'ship_no')

OpenWithParm(w_select_Shipments,lstrparms)
Lstrparms = Message.PowerObjectParm

//Add the orders to the Shipment
If Not lstrParms.Cancelled Then
	
	
	idw_detail.SetRedraw(False)
	
	lsCarrier = idw_Main.getItemString(1,'Carrier_Code')
	
	//Jxlim 01/03/2012 Pandora-OTM #337
	If   gs_project = 'PANDORA' Then	
		lsShip_Id = idw_Main.getItemString(1,'Ship_Id')  
	Else
		lsAWB = idw_Main.getItemString(1,'AWB_Bol_no')   
	End If
	
	llArrayCount = UpperBound(Lstrparms.String_arg)
	
	If llArrayCount > 0 Then
		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
	End If
	
	For llArrayPos = 1 to llArrayCount
		
		If idw_Main.GetItemString(1,'ord_Type') = 'I' Then
			
			llRC = iu_Shipments.uf_Add_inbound_Order(idw_Main, idw_Detail, Lstrparms.String_arg[llARrayPos])
			
			//Update Receive Master with the Ship Number, Carrier and AWB
			If llRC = 0 Then
				
				Update Receive_master
				Set Carrier = :lsCarrier, awb_bol_no = :lsAWB, Ship_no = :lsShipNo
				Where ro_no = :Lstrparms.String_arg[llARrayPos];
				
			End If
			
		Else /*Outbound*/
			//Jxlim 01/03/2012 Pandora-OTM #337
			//llRC = iu_Shipments.uf_Add_Outbound_Order(idw_Main, idw_Detail, Lstrparms.String_arg[llARrayPos])
			llRC = iu_Shipments.uf_Add_Outbound_Orderlevel(idw_Main, idw_Order, Lstrparms.String_arg[llARrayPos])
			
			//Update Packing with Ship No and master with Carrier and AWB
			If llRC = 0 Then
								
				Update Delivery_Master
				Set Carrier = :lsCarrier, Awb_Bol_no = :lsAWB
				Where do_no = :Lstrparms.String_arg[llARrayPos];
				
				Update Delivery_Packing
				Set ship_no = :lsSHipNo
				Where do_no = :Lstrparms.String_arg[llARrayPos];
				
			End If
			
		End If /* I/O */
		
	Next /*Order selected */
	
	If llArrayCount > 0 Then
		
		//we have issued updates to Delivery/Recive Master and Packing with theAWB, Carrier and Ship_no, we need to update and commit the detail rows here to keep in sync.
		llRC = idw_order.Update()
		IF llRC = 1 then
			Execute Immediate "COMMIT" using SQLCA;
		Else
			Execute Immediate "ROLLBACK" using SQLCA;
		End If
		
		idw_Order.GroupCalc()
		ib_Changed = True
		
	End If /* Orders added */
		
End If /*Not cancelled */

idw_order.SetRedraw(True)
end event

event ue_printpack();//Jxlim 01/04/2011 Pandora - OTM BRD #337
//Print Pack list for any selected rows from the Order
Long ll_rowcount, llFindRow
String lsFind, lsDono, ls_checkInd, ls_ordstatus, lsCI_created
Boolean lb_PrintPack 

lb_PrintPack = False

SetPointer(Hourglass!)
idw_order.SetRedraw(False)

ll_rowcount = idw_order.Rowcount()	

//Enable printing Pack list on selected orders with ord status in Packing(A), Confirmed(C), Delivered(D)
lsfind = "C_select_Ind = 'Y' and ord_status In ( 'A' , 'C' ,'D' )"
llFindRow =idw_Order.Find(lsfind,1, ll_rowcount)

//Loop through each do_no
DO WHILE llFindRow > 0
			// Collect found row
			 is_dono				 = idw_order.GetItemString(llFindRow, 'RODO_No')				 	
			 f_packprint_pandora()			 
			
			 llFindRow++
			 // Prevent endless loop
			 IF llFindRow > ll_rowcount THEN EXIT
			 llFindRow = idw_order.Find(lsFind, llFindRow, ll_rowcount)
LOOP

This.SetRedraw(True)
SetPointer(Arrow!)


end event

event type integer ue_checkstatus();//Jxlim 01/04/2012 BRD #337
//If any of the selected orders have a status of other than Packing (A) or Void (V) then prompt a message.
long  llFindrow, ll_rowcount
string lsFind

ll_rowcount = idw_order.Rowcount()

//If any of the selected order/s are not in Packing (A) or Void status (V) prompt the message, it must be A or V
lsfind = "C_select_Ind = 'Y' and ord_status Not In ( 'A' , 'V' )"

//Jxlim 10/23/2012 All AWB_BOL_No is required for all selected order/s in the shipment	in order to confirm
lsfind += " And IsNull(awb_bol_no) or awb_bol_no = ''"
llFindRow =idw_Order.Find(lsfind,1, idw_order.Rowcount())	

//If found row that is not A and V then prompt message
If 	llFindRow > 0 Then	
	//Messagebox("Order Status", "Not all orders are in Packing status BOL")		
	MessageBox(is_title,"AWB/BOL nbr is required for all of the selected orders." +&
								"~r~rPlease enter the AWB/BOL nbr for the orders from Outbound Order Screen",StopSign!)
								Return	-1	
Else
	//Qualified for shipment confirm
	//Prompt message to confirm
	If  messagebox(is_title,'Are you sure you want to CONFIRM order/s?',Question!,YesNo!,2) = 2 then
		Return -1
	Else
		//And continue with those orders that are in Packing
		idw_order.TriggerEvent("ue_confirm")
	End If
End If

end event

event ue_confirm();//Jxlim 01/04/2012 BRD #337
//Status cheking
Long ll_rowcount, llRowPos, llFindrow, ll_cnt, llRC, ll_numexistingGI
String lsFind, lsDono, ls_checkInd, ls_ordstatus, lsCI_created, lsRono, ls_ordtype, lsbol,lsInvoice, lsPrevDono, lsList, lsfind_dono, lswdo_invoice
Boolean lb_update, lbGenerateGI, lbCreateInbound
DateTime ldttoday

String lswdo_dono

lbGenerateGI = False
lb_update = False
lbCreateInbound = False

idw_order.SetRedraw(False)

ids_do_main = Create Datastore
ids_do_main.Dataobject = 'd_do_master'
ids_do_main.SetTransObject(SQLCA)

ll_rowcount = idw_order.Rowcount()	

// pvh - 08/24/05 - GMT
if idw_main.rowcount() > 0 then
	ldtToday = f_getLocalWorldTime( idw_main.getitemstring(1,'wh_code') ) 
else
	ldtToday = f_getLocalWorldTime( gs_default_wh )
end if
//ldtToday = DateTime(today(), Now())

//Jxlim 10/23/2012 Check to see if w_do is open with the same order being confirmed.
//Don't allow the confirm if w_do is open for the same do_no
If  IsValid(w_do)  then
	lswdo_Invoice = w_do.idw_main.GetItemString(1,'Invoice_no')
	lswdo_dono  = w_do.idw_main.GetItemString(1,'do_no')
	     //Find if the shipment order is open as well on the Outbound order screen
		lsfind_dono= "RODO_No = '" +  lswdo_dono + "'"
		llFindRow =idw_Order.Find(lsfind_dono,1, idw_order.Rowcount())	
		If llFindRow > 0 Then
				MessageBox(is_title,"The Outbound order screen is open for Order number: " + lswdo_invoice + ".  Please close the Outbound order screen before confirming this order.",StopSign!)
				This.SetRedraw(true)
				Return				
		End if	
End if

//Selected orders must be in Packing (A) to confirm
lsfind = "C_select_Ind = 'Y'  And ord_status = 'A'"
//Jxlim 10/23/2012 All AWB_BOL_No is required for all selected order/s in the shipment	in order to confirm
//lsfind += " And Not IsNull(awb_bol_no) or awb_bol_no >''"
llFindRow =idw_Order.Find(lsfind,1, idw_order.Rowcount())	

//If any of the selected orders have a status of other than Packing (A) or Void (V) then prompt a message.	
Do While llFindRow > 0			
	lb_Update = False
	lbCreateInbound = False
	 
	lsDono				 = idw_order.GetItemString(llFindRow, 'RODO_No')	
//Jxlim 10/23/2012 Move the bol validation check to ue_checkstatus event before prompting the assurance on confirmation message and out of this loop
//		//Jxlim 03/08/2012 BRD #337 Pandora-OTM
//		//To confirm a shipment all AWB_BOL_No is required for all of the order/s in the shipment		
//		Select AWB_BOL_No, Invoice_No Into : lsBol, :lsInvoice
//		From Delivery_master
//		Where Do_no = :lsDono
//		Using SQLCA;
//		
//		If Isnull(lsbol) or lsbol ="" Then
//			MessageBox(is_title,"AWB/BOL nbr is required for all of the selected orders." +&
//								"~r~rPlease enter the AWB/BOL nbr for all of the selected orders from Outbound Order Screen",StopSign!)
//			This.SetRedraw(true)
//			Exit							
//		End If
		
		//Jxlim 10/23/2012 Move up and out of this loop
//		//TimA 03/07/12 Check to see if w_do is open with the same order being confirmed.
//		//Don't allow the confirm if w_do is open for the same do_no
//		If IsValid(w_do)  then
//			lswdo_dono  = w_do.idw_main.GetITEmString(1,'do_no')
//			If lsDono = lswdo_dono then
//				MessageBox(is_title,"The Outbound order screen is open for this order.  Please close the Outbound order screen before confirming this order.",StopSign!)
//				This.SetRedraw(true)
//				Return
//			end if		
//		End if
		
		lsCI_created		 = idw_order.GetItemString(llFindRow, 'user_field22')		 //CI - Commercial Invoice	 
		If Isnull(lsCI_created) Then
			lsCI_created	= ''
		End if
	
		If Upper(lsCI_created) = 'Y' Then
			//If order is in Packing status and CI has been created then update the order status to complete ('C')				
			Update Delivery_Master
			Set ord_status = 'C', complete_date = :ldtToday
			Where DO_No = :lsDono;				
			lb_update = True
		Else
				//If not, for each order selected, look up in the customer  table where Delivery_Master.user_field2 = customer.cust_code.  
				//Then compare customer.Country to Delivery_Master.Country.  If they are the same proceed with the confirmation. 
				Select		Count(dm.do_no) Into :ll_cnt				
				From   		Delivery_Master DM, Customer C
				Where 		DM.project_id = 'PANDORA' 
				And 			DM.Project_id = C.project_id
				And			Dm.user_field2 = C.cust_code
				//And 			DM.Country = C.Country
				And			Dm.DO_No = :lsDono
				Group By 	DM.Do_No,DM.user_field2,C.cust_code,DM.Country,C.Country
				Using SQLCA;
				
				//Jxlim 03/13/2012 Message not necessary at this time BRD #337 Pandora-OTM
//				If SQLCA.SQLCode <> 0 Then	
//					Messagebox ("Error comparing countries", "There was a problem comparing the countries.~r~r" + SQLCA.SQLErrText )							
//					Return
//				End if
						
				//If they are the same proceed with the confirmation. 
				If 	ll_cnt > 0 Then
					Update Delivery_Master
					Set ord_status = 'C', complete_date = :ldtToday
					Where DO_No = :lsDono;				
					lb_update = True
				//If different, look up in the Customer table where Delivery_Master.Cust_code = Customer.Cust_code.  
				//Then if Customer.User_Field1 = $$HEX1$$1820$$ENDHEX$$ENT$$HEX2$$19202000$$ENDHEX$$proceed with the order confirmation process. 	
				Else
					Select		Count(dm.do_no) Into : ll_cnt
					From   		Delivery_Master DM, Customer C
					Where 		DM.project_id = 'PANDORA' 
					And	 		DM.Project_id = C.project_id
					And			Dm.Cust_code = C.cust_code
					And			C.user_field1 = 'ENT'					
					And			Dm.DO_No = :lsDono
					Group By 	DM.Do_No,C.user_field2,C.cust_code,DM.Country,C.Country
					Using SQLCA;
					
					If SQLCA.SQLCode <> 0 Then	
							Messagebox ("SQL Error", SQLCA.SQLErrText)							
							Return
					End if
									//Then if Customer.User_Field1 = $$HEX1$$1820$$ENDHEX$$ENT$$HEX2$$19202000$$ENDHEX$$proceed with the order confirmation process. 	
									If 	ll_cnt > 0 Then
										Update Delivery_Master
										Set ord_status = 'C', complete_date = :ldtToday
										Where DO_No = :lsDono;
										Messagebox("Confirm", "Order/s comfirmed")	
										lb_update = True
									Else
										Messagebox("Not Confirm", "CI has not been created for all orders")	
									End If  //end of ENT checking (Customer.Userfield1 = 'ENT')
				End If
		End If  //end of CI checking (Delivery_Master.User_field22 = 'Y')
		 		
				 //Jxlim BRD #337 Pandora-OTM batch transaction process
				 If lb_update = True Then
					 // See if there's an existing GIR record
					Select count(*)
					into :ll_numexistingGI
					from batch_Transaction
					where project_id = 'PANDORA'
					AND trans_type = 'GI'
					and trans_status = 'N'
					and trans_order_id = :lsDono;
		
								// If there isn't an existing GI transaction (in New status) for this order number,
								If ll_numexistingGI = 0 then
									lbGenerateGI = True
								Else
									lbGenerateGI = False
								End If
					
								If lbGenerateGI = True Then
									// Begin a new transaction.
									Execute Immediate "Begin Transaction" using SQLCA;
									// Insert a new record into batch_transaction to create the 3B13 sending GIR (uf_gi_rose)
									Insert Into batch_Transaction
									(project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
									Values(:gs_Project, 'GI', :lsDono, 'N', :ldtToday, '');
									// Commit the transaction.
									Execute Immediate "COMMIT" using SQLCA;
								End if
					End If   //End of Batch transaction process
					
					//Jxlim BRD 3337 Pandora-OTM Create pandora inbound half of wh x-fer 
					//- This will call wf_create_inbound before displaying the message that the order has been confirmed, but the order will have already been confirmed and saved.
					//- a side-effect is that we won't have to manage batch transaction creation (as much) on a 'Re-Confirm' to create the Inbound
					
							//	If lb_update = True  and (ids_do_main.GetItemString(1,'ord_type') = 'Z' and upper(gs_project) ='Pandora' and ids_do_main.GetItemString(1,'ord_type') = 'C') Then 
							If lb_update = True then
								//Check for warehouse transfer order type for this order
								Select ord_type Into :ls_Ordtype
								From Delivery_master
								Where project_id =:gs_Project And do_no =: lsdono
								Using SQLCA;
								
								If 	SQLCA.SQLCode <> 0 Then	
										Messagebox ("SQL Error", "Not a warehouse transfer order type.~r~r" +  SQLCA.SQLErrText)				
										Return
								End if								
//TAM - 10/18/2016 - SKIP inbound create for pandora								
// 								If ls_ordtype = 'Z' Then		
								If ls_ordtype = 'Z'  and gs_Project <>  'PANDORA' Then		
								  lbCreateInbound = True									
												//check to see if Associated Inbound order was already created...
												Select max(ro_no) Into :lsRONO
												From Receive_Master
												Where Project_ID = :gs_Project and Do_no = :lsdono;
												If not isnull(lsRONO) Then
													If messagebox("Auto-Receipt", "Inbound Order already exists for this Order.  Create another associated Inbound Order?", Question!, YesNo!, 2) = 2 then
														lbCreateInbound = false
													End if
												End if
								End if
									If lbCreateInbound then
										SetPointer(Hourglass!)
										If wf_create_inbound(ids_do_main, lsdono) < 0 Then Return
											SetMicroHelp("Inbound Warehouse Transfer created!")										
									End if									
							End if
							//End of Inbound half warehouse transfer  Order type = 'Z'  			
							
		// Collect found row
		llFindRow++
		 // Prevent endless loop
		 IF llFindRow > ll_rowcount THEN EXIT
		 llFindRow = idw_order.Find(lsFind, llFindRow, ll_rowcount)
Loop

If 	lb_update = True Then	
	llRC = idw_order.Update()
	IF llRC = 1 Then	
		Execute Immediate "COMMIT" using SQLCA;
		Messagebox("Complete", "Order/s successfully completed")			
	Else	
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Failed", "Order/s did not complete")			
	End If
End If

String lsShipNo
lsShipNo =idw_Main.GetItemString(1,'ship_no')

If 	lb_update = True Then
	//idw_main.SetItem(1,'ord_status', 'C')	
//	Update Shipment
//	Set ord_status = 'C'
//	Where Ship_no = :lsShipNo;	
	// LTK 20120510  Pandora #395 Added last_user and last_update to statement below
	datetime ldt_wh_time
	ldt_wh_time = f_getlocalworldtime(idw_main.object.wh_code[1])
	Update Shipment
	Set ord_status = 'C', last_user = :gs_userid, last_update = :ldt_wh_time
	Where Ship_no = :lsShipNo;	

	cb_confirm.Enabled= False
	idw_order.Retrieve(isShipNo) /*order records*/  	//Jxlim 12/22/2011 Pandora-OTM BRD #337 Refresh order dw update confirmed.
End If

idw_order.SetRedraw(True)

//ib_Changed = True
//Jxlim 02/16/2012 BRD #337 Pandora-Otm End of ue_confirm




end event

event ue_printci();//Jxlim 01/04/2011 Pandora - OTM BRD #337
//Print Pack list for any selected rows from the Order
Long ll_rowcount, llFindRow
String lsFind, lsDono, ls_checkInd, ls_ordstatus, lsCI_created
Boolean lb_PrintCI
str_parms	lstrParms

lb_PrintCI = False

SetPointer(Hourglass!)
idw_order.SetRedraw(False)

ll_rowcount = idw_order.Rowcount()	

//If any of the selected orders have a status other than Packing (A) or Void (V) then prompt a message.				
//lsfind = "C_select_Ind = 'Y'  And ord_status In ( 'A' ,'V')"
lsfind = "C_select_Ind = 'Y'  And ord_status ='A'"
llFindRow =idw_Order.Find(lsfind,1, ll_rowcount)

//If any of the selected orders have a status of other than Packing (A) or Void (V) then prompt a message.	
DO WHILE llFindRow > 0
			// Collect found row
			 lsDono				 = idw_order.GetItemString(llFindRow, 'RODO_No')	 
			 	/*Open Pandora CI Report window, Websphere Report # 25 */
				lstrparms.String_arg[1] = "w_pan"
				lstrparms.String_arg[2] = '*DONO*' + lsDono  /* *dono will tell DO to retrieve by DONO instead of the default order number */
				OpenSheetwithparm(w_pandora_commercial_invoice_rpt_ws,lStrparms, w_main, gi_menu_pos, Original!)
				
			 llFindRow++
			 // Prevent endless loop
			 IF llFindRow > ll_rowcount THEN EXIT
			 llFindRow = idw_order.Find(lsFind, llFindRow, ll_rowcount)
LOOP

This.SetRedraw(True)
SetPointer(Arrow!)
end event

event ue_enable();//Jxlim 11/01/2012 Enabled or Disabled buttons based on order status and row(s) being selected
//If any of the selected orders have a status of other than Packing (A) or Void (V) then disabled Confirm button
long  llFindrow, ll_rowcount
string lsFind

ll_rowcount = idw_order.Rowcount()

//Jxlim 11/01/2012 If none of the rows are selected disabled all buttons
lsfind = "C_select_Ind = 'Y'"
llFindRow =idw_Order.Find(lsfind,1, idw_order.Rowcount())	

//If found row that is not A and V then prompt message
If 	llFindRow > 0 Then	
	//cb_delete_order.Enabled = True   //Jxlim 12/13/2012 BRD #531 Pandora This button remains lock when click on select all unless using F10
	cb_printpack.Enabled = True
	cb_printCi.Enabled = True
	//cb_confirm.Enabled = True  // Moved this to find
	cb_otmchanged.Enabled = True
Else
	cb_delete_order.Enabled = False
	cb_printpack.Enabled = False
	cb_printCi.Enabled = False
	cb_confirm.Enabled = False 
	cb_otmchanged.Enabled = False
End If				

//If any of the selected order/s are not in Packing (A) or Void status (V) then disabled Confirm button
//lsfind = "C_select_Ind = 'Y' and ord_status Not In ( 'A' , 'V' )"
lsfind = "C_select_Ind = 'Y' and ord_status In ( 'A' , 'V' )"
llFindRow =idw_Order.Find(lsfind,1, idw_order.Rowcount())	

//If found row that is not A and V then prompt message
If 	llFindRow > 0 Then	
	cb_confirm.enabled = True
Else
	cb_confirm.enabled =False
End If				
end event

event ue_clearall();//Jxlim 11/01/2012 
Long	llRowPos, llRowCount

This.SetRedraw(False)

llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	This.SetItem(llRowPos,'c_select_ind','N')
Next

This.SetRedraw(True)

This.TriggerEvent('ue_enable')


//
////Jxlim 01/04/2012 Pandora-OTM BRD #337
//Long llRowCount, llRowPos
//
//This.SetReDraw(False)
//
//llRowCount = This.RowCount()
//For llRowPos = 1 to llRowCount
//	dw_order.SetItem(llRowPos,'c_select_ind','N')
//Next
//
//This.SetRedraw(True)
//
//
////cb_delete_order.Enabled = False
////cb_printpack.Enabled = False
////cb_printCi.Enabled = False
////cb_confirm.Enabled = False
////cb_otmchanged.Enabled = False
//
//This.TriggerEvent('ue_enable')
//

end event

event ue_selectall();//Jxlim 11/01/2012
Long	llRowPos, llRowCount

This.SetRedraw(False)

llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	This.SetItem(llRowPos,'c_select_ind','Y')
Next

This.SetRedraw(True)

This.TriggerEvent('ue_enable')

end event

event clicked;call super::clicked;////Jxlim BRD #337 Pandora-OTM 
//String ls_status
//
////If row is clicked then highlight the row
//IF row > 0 THEN
//	This.SelectRow(0, FALSE)
//	This.SelectRow(row, TRUE)
//	
//			//Jxlim 11/01/2012 Disable Confirm button when selected order have already been completed or New status.
//			ls_status = This.GetitemString(row, "Ord_status")				
//			If ls_status = 'C' or ls_status = 'N' Then	
//				cb_confirm.enabled = False
//			Else
//				cb_confirm.enabled =True
//			End If			
//End If
//
	

end event

event doubleclicked;call super::doubleclicked;
String	lsDONO

str_parms	lstrParms

If row > 0 Then
	
	If idw_main.GetITemString(1,'ord_type') = 'I' Then /*Open Receive Order */
	
		Lstrparms.String_arg[1] = "W_ROD"
		Lstrparms.String_arg[2] = '*RONO*' + This.GetITemString(row,'rodo_no') /* *rono will tell RO to retrieve by DONO instead of the default order number */
		OpenSheetwithparm(w_ro,lStrparms, w_main, gi_menu_pos, Original!)
		
	Else /*Open Delivery Order */
		Lstrparms.String_arg[1] = "W_DOR"
		Lstrparms.String_arg[2] = '*DONO*' + This.GetITemString(row,'rodo_no') /* *dono will tell DO to retrieve by DONO instead of the default order number */
		//Close the w_do before opening another one
		If IsValid(w_do) Then
			Close(w_do)
		End If
		OpenSheetwithparm(w_do,lStrparms, w_main, gi_menu_pos, Original!)
	End If
		
End If
end event

event itemchanged;call super::itemchanged;//Jxlim 01/04/2012 Pandora - OTM BRD #337
If dwo.name <> 'c_select_ind' Then	ib_changed = True


end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event ue_delete;call super::ue_delete;
String	lsrodono, lsDoNoHold, lswdo_dono
Long	llRowCount, llRowPos, llFindRow, llCartonCount, llrc
Decimal	ldWeight
Long ll_method_trace_id

ib_UpdateOrderRemoveStatus =  False   //Jxlim Pandora #526
isrodono = ''

If MessageBox(is_title,"Are you sure you want to remove the selected orders from this shipment?",Question!,YesNo!,2) = 2 Then Return

This.SetRedraw(False)

llRowCOunt = This.RowCount()
For llRowPos = 1 to lLRowCount
	
	If This.GetITemString(llRowPos,'c_Select_Ind') <> 'Y' Then Continue

	lsrodono = This.GetITemString(llRowPos,'rodo_no')
	//TimA 03/07/12 Check to see if w_do is open with the same order being removed.
	//Don't allow the delete if w_do is open
	If IsValid(w_do)  then
		lswdo_dono  = w_do.idw_main.GetITEmString(1,'do_no')
		If lsrodono = lswdo_dono then
			MessageBox(is_title,"The Outbound order screen is open for this order.  Please close the Outbound order screen before you removing this order.",StopSign!)
			This.SetRedraw(true)
			Return
		end if		
	End if
	This.SetItem(llRowPos,'c_delete_ind','Y') /*flag for delete*/
	
	//Find any other rows with this rodono
	If llRowPos < llRowCount Then
		
		llFindRow = This.Find("rodo_no = '" + lsrodono + "'",llRowPos,This.RowCount())
		Do While llFindRow > 0
			This.SetItem(llFindRow,'c_delete_ind','Y') /*flag for delete*/
			llFindRow ++
			If llFindRow > lLRowCount Then
				llFindRow = 0
			Else
				llFindRow = This.Find("rodo_no = '" + lsrodono + "'",llFindRow,This.RowCount())
			End If
		Loop
		
	End If	
	
Next /* Next row */

//TimA 05/09/13 Removed the begine tran because the commit was commented out earlier and this was causing blocking
//Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

//Delete any rows flagged above
lsDoNoHold = ''
For llRowPos = llRowCOunt to 1 step -1
	
	If THis.GetITemString(llRowPos,'c_delete_ind') = 'Y' Then

		SetNull( ll_method_trace_id )

		//We need to deduct the Ctn Cnt and Weights from the header for Outbound Orders
		If idw_Main.GetITemString(1,'ord_type') <> 'I' Then
			
			If This.GetITemstring(llRowPos,'rodo_no') <> lsDoNoHold Then /*we may have more than 1 row per dono*/
				
				lsrodono = This.GetITemString(llRowPos,'rodo_no')			
				//Jxlim 12/15/2012 Pandora #526 Update delivery order status when saving this remove order from shipment. Do not update when before saved.
				isrodono =isrodono + ",'" + lsrodono + "'"			
				ib_UpdateOrderRemoveStatus = True
								
				Select Sum(weight_gross), Count(distinct Carton_no)  Into :ldWeight, :llCartonCount
				From Delivery_Packing
				Where do_no = :lsrodono;

				idw_Main.SetItem(1,'est_ctn_cnt',idw_main.GetITemNumber(1,'est_ctn_cnt') - llCartonCount)
				idw_Main.SetItem(1,'est_weight',idw_main.GetITemNumber(1,'est_weight') - ldWeight)
				
				//We need to remove the Ship_NO from the Delivery Packing Records
				Update Delivery_Packing
				Set Ship_no = null 
				Where do_no = :lsrodono;	
								
				//Jxlim BRD #437 Moved to inside loop to set OTM_STATUS to 'N' for all the selected orderrs 
				//If the user clicks Yes, do the following: Change Delivery_Master.OTM_Status = $$HEX1$$1820$$ENDHEX$$N$$HEX1$$1d20$$ENDHEX$$, Non OTM and  Set Delivery_Master.Consolidation_no = Null
//				Update Delivery_Master
//				Set OTM_Status = 'N' , Consolidation_no = null
//				Where do_no = :lsrodono;
				//Jxlim 04/26/2012 BRD #406 End
				
			End If
			
		End If /*Not inbound*/
		
		lsDoNoHold = This.GetItemstring(llRowPos,'rodo_no')

		//f_method_trace( ll_method_trace_id, iw_window.Classname(), "Deleting do_no: " + lsDoNoHold + " from AWB BOL Nbr(ship_id): " + Idw_Main.Object.ship_id[1] + "  ship_no: " +  Idw_Main.Object.ship_no[1]) //08-Feb-2013  :Madhu commented
		f_method_trace_special( gs_project, iw_window.Classname() + ' -ue_delete',"Deleting do_no: " + lsDoNoHold + " from AWB BOL Nbr(ship_id): " + Idw_Main.Object.ship_id[1] + "  ship_no: " +  Idw_Main.Object.ship_no[1],lsrodono,' ',' ',' ' ) //08-Feb-2013  :Madhu added


		This.DeleteRow(llRowPos)	
		
	End If /*flagged for delete */
	
Next

//Jxlim BRD #437 Moved to inside loop to set OTM_STATUS to 'N' for all the selected orderrs for remove.
//Jxlim 04/26/2012 BRD #406
//If the user clicks Yes, do the following: Change Delivery_Master.OTM_Status = $$HEX1$$1820$$ENDHEX$$N$$HEX1$$1d20$$ENDHEX$$, Non OTM and  Set Delivery_Master.Consolidation_no = Null
//Update Delivery_Master
//Set OTM_Status = 'N' , Consolidation_no = null
//Where do_no = :lsrodono;

//Jxlim 12/16/2012 Pandora BRD #526 moved update when saved.
//llRC = idw_order.Update()
//IF llRC = 1 then
//	
	// LTK 20120510  	Pandora #395 Update shipment table with last user and set the datawindow values as well 
	//						in the event that changes have been made to the shipment datawindow
//	if 	idw_main.RowCount() > 0 then
//		string ls_ship_no, ls_wh_code, ls_project_id
//		datetime ldt_wh_time
//		ldt_wh_time = f_getlocalworldtime(idw_main.object.wh_code[1])
//		ls_ship_no = idw_main.object.ship_no[1]
//		ls_wh_code = idw_main.object.wh_code[1]
//		ls_project_id = idw_main.object.project_id[1]
//		
//		update shipment
//		set last_user = :gs_userid, last_update = :ldt_wh_time
//		where ship_no = :ls_ship_no
//		and wh_code = :ls_wh_code
//		and project_id = :ls_project_id;
//		
//		idw_main.object.last_user[1] = gs_userid
//		idw_main.object.last_update[1] = ldt_wh_time
//	end if
//	
//	Execute Immediate "COMMIT" using SQLCA;
//
//	f_method_trace( ll_method_trace_id, iw_window.Classname(), 'End ue_delete: Committed deleted shipment orders.' )	
//
//Else
//	Execute Immediate "ROLLBACK" using SQLCA;
//End If
	
This.SetRedraw(True)
ib_Changed = True  



end event

event ue_postitemchanged;call super::ue_postitemchanged;//Jxlim 01/04/2012 Pandora - OTM BRD #337
String ls_status, lsFind
Long llFindRow


lsfind = "C_select_Ind = 'Y' and ord_status Not In ( 'A' , 'V' )"
//If any of the selected order/s are not in Packing (A) or Void status (V) prompt the message, it must be A or V

lsfind = "C_select_Ind = 'Y'"
llFindRow =This.Find(lsfind,1,This.Rowcount())
If llFindRow > 0 Then
		// ET3 2012-09-27 Pandora #503 - block delete
		IF UPPER(gs_project) = 'PANDORA' THEN
			cb_delete_order.Enabled = FALSE
		ELSE
			cb_delete_order.Enabled = True
		END IF
		
		cb_printpack.Enabled = True
		cb_printci.Enabled = True
		cb_otmchanged.Enabled = True	
		ls_status = This.GetItemString(llFindRow, 'ord_status' )
		//Jxlim 11/01/2012 If status is not packing or void disabled confirm button
		//If ls_status = 'C' Then
		If ls_status = 'C'  or ls_status = 'N' Then
			cb_confirm.Enabled = False
		Else 
			cb_confirm.Enabled =True
		End If
Else
		cb_delete_order.Enabled = False
		cb_printpack.Enabled = False
		cb_printCi.Enabled = False				
		cb_confirm.Enabled = False
		cb_otmchanged.Enabled = False		
End If

//If Upper(dwo.name) = 'C_SELECT_IND' Then
//	If This.Find("Upper(c_select_Ind) = 'Y'",1,This.RowCount()) > 0 Then
//		cb_delete_order.Enabled = True
//		cb_printpack.Enabled = True
//		cb_printci.Enabled = True
//		cb_otmchanged.Enabled = True
//		ls_status = This.GetItemString(row, 'ord_status' )
//		If ls_status = 'C' Then
//			cb_confirm.Enabled = False
//		Else 
//			cb_confirm.Enabled = True
//		End If
//	Else
//		cb_delete_order.Enabled = False
//		cb_printpack.Enabled = False
//		cb_printCi.Enabled = False				
//		cb_confirm.Enabled = False
//		cb_otmchanged.Enabled = False		
//	End If
//End If


end event

event sqlpreview;call super::sqlpreview;// have to modify the retrieve statement
STRING lsSQL, lsNewSQL 
STRING lsGroup = 'Group by'
STRING lsClause
LONG   lGroupByLocation
LONG   lrtn


lsSQL = sqlsyntax

// ET3 2012-09-27 Pandora 516 - don't bring back if orders in OTM status = P
IF UPPER(gs_project) = 'PANDORA' AND request = PreviewFunctionRetrieve! THEN
	// process the SQL to add in the clause AND Delivery_Master.OTM_Status <> 'P'
	// brute force it for now ...
	lsClause = "AND DM.OTM_Status <> 'P' ~r~n "
	lGroupByLocation = POS( lsSQL, lsGroup, 1 )
	
	lsNewSQL = Replace( lsSQL, lGroupByLocation, 0, lsClause )
	
	lrtn = this.setSQLPreview( lsNewSQL )
	
END IF

Return 0
end event

type cb_confirm from commandbutton within tabpage_order
integer x = 2044
integer y = 16
integer width = 325
integer height = 96
integer taborder = 55
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Confirm"
end type

event clicked;////Jxlim 01/04/2012 Pandora - OTM BRD #337
////Check Packing and Void status, and CI to complete and order/s
//
idw_Order.TriggerEvent("ue_checkstatus") 
//Jxlim 10/23/2012 Moved to ue_checkstatus
//	//Prompt message to confirm
//	If  messagebox(is_title,'Are you sure you want to CONFIRM order/s?',Question!,YesNo!,2) = 2 then
//		Return
//	Else
//		//And continue with those orders that are in Packing
//		idw_order.TriggerEvent("ue_confirm")
//	End If
//End If

end event

type cb_printci from commandbutton within tabpage_order
integer x = 1704
integer y = 16
integer width = 336
integer height = 96
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print C&I"
end type

event clicked;//Jxlim 01/04/2012 Pandora - OTM BRD #337
//Check Packing and Void status

idw_Order.TriggerEvent("ue_checkstatus") 

//And continue with those orders that are in Packing
//Print CI (Pandora Commercial Invoice) report #25 for Packing Status
//iw_window.TriggerEvent("ue_printCI")
idw_Order.TriggerEvent("ue_printCI")
end event

type cb_delete_order from commandbutton within tabpage_order
integer x = 625
integer y = 16
integer width = 691
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Remove From Shipment"
end type

event clicked;//Jxlim BRD #337 Pandora-OTM
dw_order.TriggerEvent('ue_delete')
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_clearall_orders from commandbutton within tabpage_order
integer x = 315
integer y = 16
integer width = 311
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear All"
end type

event clicked;//Jxlim 11/01/2012
idw_order.triggerEvent('ue_clearall')

////Jxlim 01/04/2012 Pandora-OTM BRD #337
//Long llRowCount, llRowPos
//
//This.SetReDraw(False)
//
//llRowCount = This.RowCount()
//For llRowPos = 1 to llRowCount
//	dw_order.SetItem(llRowPos,'c_select_ind','N')
//Next
//
//This.SetRedraw(True)
//
//
////cb_delete_order.Enabled = False
////cb_printpack.Enabled = False
////cb_printCi.Enabled = False
////cb_confirm.Enabled = False
////cb_otmchanged.Enabled = False
//
//This.TriggerEvent('ue_enable')
//
//
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_selectall_orders from commandbutton within tabpage_order
integer y = 16
integer width = 311
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All"
end type

event clicked;//Jxlim 11/01/2012
idw_order.triggerEvent('ue_selectall')

////Jxlim 01/04/2012 Pandora-OTM BRD #337
//Long llRowCount, llRowPos
//
//dw_order.SetReDraw(False)
//
//llRowCount = dw_order.RowCount()
//For llRowPos = 1 to llRowCount
//	dw_order.SetItem(llRowPos,'c_select_ind','Y')
//Next
//
//dw_order.SetReDraw(True)
//
//If llRowCount > 0 Then
//	cb_delete_order.Enabled = True
//	cb_printpack.Enabled = True
//	cb_printCi.Enabled = True
//	//cb_confirm.Enabled = True  // Moved this to find
//	cb_otmchanged.Enabled = True
//End If
//
////This.TriggerEvent('ue_enable')
//
//
////Jxlim 11/01/2012
////If any of the selected orders have a status of other than Packing (A) or Void (V) then disabled Confirm button
//long  llFindrow, ll_rowcount
//string lsFind
//
//ll_rowcount = idw_order.Rowcount()
//
////If any of the selected order/s are not in Packing (A) or Void status (V) then disabled Confirm button
//lsfind = "C_select_Ind = 'Y' and ord_status Not In ( 'A' , 'V' )"
//llFindRow =idw_Order.Find(lsfind,1, idw_order.Rowcount())	
//
////If found row that is not A and V then prompt message
//If 	llFindRow > 0 Then	
//	cb_confirm.enabled = False
//Else
//	cb_confirm.enabled =True
//End If				
//
end event

event constructor;
g.of_check_label_button(this)
end event

type st_1 from statictext within tabpage_order
integer x = 3003
integer y = 26
integer width = 673
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Double click order to edit"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type cb_printpack from commandbutton within tabpage_order
integer x = 1317
integer y = 16
integer width = 391
integer height = 96
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print &Pack"
end type

event clicked;//Jxlim 02/20/2012 Pandora - OTM BRD #337 Enable printing pack list for ord_status in Packing(A), Confirmed(C), Delivered(D)
long  llFindrow
string lsFind

//If any of the selected order/s are not in Packing (A) or Void status (V) prompt the message, it must be A or V
lsfind = "C_select_Ind = 'Y' and ord_status Not In ( 'A' , 'V', 'C','D' )"
llFindRow =idw_order.Find(lsfind,1,idw_order.Rowcount())

//If found row that is not A and V then prompt message
If 	llFindRow > 0 Then
	Messagebox("Order Status", "Not a valid order status for print Pack")	
End If // End of Packing and Void status checking for selected rows

//And continue with those orders that are in Packing
idw_order.TriggerEvent("ue_printPack")


end event

event constructor;//Jxlim 01/04/2012 Pandora - OTM BRD #337
g.of_check_label_button(this)
end event

type cb_add from commandbutton within tabpage_order
boolean visible = false
integer x = 2725
integer y = 26
integer width = 421
integer height = 77
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Add Orders"
end type

event clicked;
dw_order.TriggerEvent('ue_add_Orders')
end event

event constructor;
g.of_check_label_button(this)
end event

type tabpage_detail from userobject within tab_main
integer x = 15
integer y = 99
integer width = 3679
integer height = 2010
long backcolor = 79741120
string text = "Shipment Detail"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_double_click_on_order_to_edit st_double_click_on_order_to_edit
cb_clearall_detail cb_clearall_detail
cb_selectall_detail cb_selectall_detail
cb_delete_orders cb_delete_orders
cb_add_orders cb_add_orders
dw_detail dw_detail
end type

on tabpage_detail.create
this.st_double_click_on_order_to_edit=create st_double_click_on_order_to_edit
this.cb_clearall_detail=create cb_clearall_detail
this.cb_selectall_detail=create cb_selectall_detail
this.cb_delete_orders=create cb_delete_orders
this.cb_add_orders=create cb_add_orders
this.dw_detail=create dw_detail
this.Control[]={this.st_double_click_on_order_to_edit,&
this.cb_clearall_detail,&
this.cb_selectall_detail,&
this.cb_delete_orders,&
this.cb_add_orders,&
this.dw_detail}
end on

on tabpage_detail.destroy
destroy(this.st_double_click_on_order_to_edit)
destroy(this.cb_clearall_detail)
destroy(this.cb_selectall_detail)
destroy(this.cb_delete_orders)
destroy(this.cb_add_orders)
destroy(this.dw_detail)
end on

type st_double_click_on_order_to_edit from statictext within tabpage_detail
integer x = 2948
integer y = 19
integer width = 673
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Double click order to edit"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type cb_clearall_detail from commandbutton within tabpage_detail
integer x = 329
integer y = 16
integer width = 311
integer height = 77
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear All"
end type

event clicked;Long llRowCount, llRowPos

dw_detail.SetReDraw(False)

llRowCount = dw_detail.RowCount()
For llRowPos = 1 to llRowCount
	dw_detail.SetItem(llRowPos,'c_select_ind','N')
Next

dw_detail.SetReDraw(True)

cb_delete_orders.Enabled = False
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_selectall_detail from commandbutton within tabpage_detail
integer y = 16
integer width = 311
integer height = 77
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All"
end type

event clicked;Long llRowCount, llRowPos

dw_detail.SetReDraw(False)

llRowCount = dw_detail.RowCount()
For llRowPos = 1 to llRowCount
	dw_detail.SetItem(llRowPos,'c_select_ind','Y')
Next

dw_detail.SetReDraw(True)

If llRowCount > 0 Then
	cb_delete_orders.Enabled = True
End If
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_delete_orders from commandbutton within tabpage_detail
integer x = 764
integer y = 16
integer width = 673
integer height = 77
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Checked Orders"
end type

event clicked;
dw_detail.TriggerEvent('ue_delete')
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_add_orders from commandbutton within tabpage_detail
integer x = 1463
integer y = 16
integer width = 421
integer height = 77
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Add Orders"
end type

event clicked;
dw_detail.TriggerEvent('ue_add_Orders')
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_detail from u_dw_ancestor within tabpage_detail
event ue_add_orders ( )
integer y = 122
integer width = 3536
integer height = 1706
integer taborder = 20
string dataobject = "d_shipment_detail"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_add_orders();
Str_Parms	lstrParms
Long			llArrayPos, llArrayCount, llRC
String	lsShipNo, lsAWB, lsCarrier, lsZip

//make sure changes are saved before adding orders
If ib_changed then
	Messagebox(is_title,'Please save changes before adding orders.')
	Return
End If

If idw_Main.GetItemString(1,'ord_Type') = 'I' Then
	lstrparms.String_arg[1] = 'I'
	lsZip = idw_Origin.GetItemString(1,'Zip')
Else
	lstrparms.String_arg[1] = 'O'
	lsZip = idw_dest.GetItemString(1,'Zip')
End If

//Zip, Carrier and AWB must be entered before adding Orders
If isNull(idw_Main.GetItemString(1,'Carrier_code')) or &
	isNull(idw_Main.GetItemString(1,'Awb_bol_no')) or &
	isnull(lsZip) Then
	//isnull(idw_dest.GetItemString(1,'Zip')) Then
	
	Messagebox(is_Title,'Carrier, AWB and Destination Zip are required before adding Orders!',StopSign!)
	tab_main.SelectTab(1)
	Return
	
End If

Lstrparms.String_arg[2] = idw_Main.GetItemString(1,'Carrier_code')
//Lstrparms.String_arg[3] = idw_dest.GetItemString(1,'Zip')
Lstrparms.String_arg[3] = lsZip
Lstrparms.String_arg[4] = idw_Main.GetItemString(1,'Awb_bol_no')

lsShipNo = idw_Main.GetItemString(1,'ship_no')

OpenWithParm(w_select_Shipments,lstrparms)
Lstrparms = Message.PowerObjectParm

//Add the orders to the Shipment
If Not lstrParms.Cancelled Then
	
	
	idw_detail.SetRedraw(False)
	
	lsCarrier = idw_Main.getItemString(1,'Carrier_Code')
	lsAWB = idw_Main.getItemString(1,'AWB_Bol_no')
	
	llArrayCount = UpperBound(Lstrparms.String_arg)
	
	If llArrayCount > 0 Then
		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
	End If
	
	For llArrayPos = 1 to llArrayCount
		
		If idw_Main.GetItemString(1,'ord_Type') = 'I' Then
			
			llRC = iu_Shipments.uf_Add_inbound_Order(idw_Main, idw_Detail, Lstrparms.String_arg[llARrayPos])
			
			//Update Receive Master with the Ship Number, Carrier and AWB
			If llRC = 0 Then
				
				Update Receive_master
				Set Carrier = :lsCarrier, awb_bol_no = :lsAWB, Ship_no = :lsShipNo
				Where ro_no = :Lstrparms.String_arg[llARrayPos];
				
			End If
			
		Else /*Outbound*/
			
			llRC = iu_Shipments.uf_Add_Outbound_Order(idw_Main, idw_Detail, Lstrparms.String_arg[llARrayPos])
			
			//Update Packing with Ship No and master with Carrier and AWB
			If llRC = 0 Then
								
				Update Delivery_Master
				Set Carrier = :lsCarrier, Awb_Bol_no = :lsAWB
				Where do_no = :Lstrparms.String_arg[llARrayPos];
				
				Update Delivery_Packing
				Set ship_no = :lsSHipNo
				Where do_no = :Lstrparms.String_arg[llARrayPos];
				
			End If
			
		End If /* I/O */
		
	Next /*Order selected */
	
	If llArrayCount > 0 Then
		
		//we have issued updates to Delivery/Recive Master and Packing with theAWB, Carrier and Ship_no, we need to update and commit the detail rows here to keep in sync.
		llRC = idw_detail.Update()
		IF llRC = 1 then
			Execute Immediate "COMMIT" using SQLCA;
		Else
			Execute Immediate "ROLLBACK" using SQLCA;
		End If
		
		idw_Detail.GroupCalc()
		ib_Changed = True
		
	End If /* Orders added */
		
End If /*Not cancelled */

idw_detail.SetRedraw(True)
end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event itemchanged;call super::itemchanged;
If dwo.name <> 'c_select_ind' Then	ib_changed = True
end event

event ue_postitemchanged;call super::ue_postitemchanged;
If Upper(dwo.name) = 'C_SELECT_IND' Then
	If THis.Find("Upper(c_select_Ind) = 'Y'",1,This.RowCOunt()) > 0 Then
		cb_delete_orders.Enabled = True
	Else
		cb_delete_orders.Enabled = False
	End If
End If
end event

event ue_delete;call super::ue_delete;
String	lsrodono, lsDoNoHold
Long	llRowCount, llRowPos, llFindRow, llCartonCount, llrc
Decimal	ldWeight

If MessageBox(is_title,"Are you sure you want to remove the selected orders from this shipment?",Question!,YesNo!,2) = 2 Then Return

This.SetRedraw(False)

llRowCOunt = This.RowCount()
For llRowPos = 1 to lLRowCount
	
	If This.GetITemString(llRowPos,'c_Select_Ind') <> 'Y' Then Continue
	
	lsrodono = This.GetITemString(llRowPos,'rodo_no')
	This.SetItem(llRowPos,'c_delete_ind','Y') /*flag for delete*/
	
	//Find any other rows with this rodono
	If llRowPos < llRowCount Then
		
		llFindRow = This.Find("rodo_no = '" + lsrodono + "'",llRowPos,This.RowCount())
		Do While llFindRow > 0
			This.SetItem(llFindRow,'c_delete_ind','Y') /*flag for delete*/
			llFindRow ++
			If llFindRow > lLRowCount Then
				llFindRow = 0
			Else
				llFindRow = This.Find("rodo_no = '" + lsrodono + "'",llFindRow,This.RowCount())
			End If
		Loop
		
	End If
	
Next /* Next row */

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

//Delete any rows flagged above
lsDoNoHold = ''
For llRowPos = llRowCOunt to 1 step -1
	
	If THis.GetITemString(llRowPos,'c_delete_ind') = 'Y' Then
		
		//We need to deduct the Ctn Cnt and Weights from the header for Outbound Orders
		If idw_Main.GetITemString(1,'ord_type') <> 'I' Then
			
			If This.GetITemstring(llRowPos,'rodo_no') <> lsDoNoHold Then /*we may have more than 1 row per dono*/
				
				lsrodono = This.GetITemString(llRowPos,'rodo_no')
				
				Select Sum(weight_gross), Count(distinct Carton_no)  Into :ldWeight, :llCartonCount
				From Delivery_Packing
				Where do_no = :lsrodono;

				idw_Main.SetItem(1,'est_ctn_cnt',idw_main.GetITemNumber(1,'est_ctn_cnt') - llCartonCount)
				idw_Main.SetItem(1,'est_weight',idw_main.GetITemNumber(1,'est_weight') - ldWeight)
				
				//We need to remove the Ship_NO from the Delivery Packing Records
				Update Delivery_Packing
				Set Ship_no = null
				Where do_no = :lsrodono;

			End If
			
		End If /*Not inbound*/
		
		lsDoNoHold = This.GetItemstring(llRowPos,'rodo_no')
		
		This.DeleteRow(llRowPos)
				
	End If /*flagged for delete */
	
Next

//since we updated packing, we need to update the detail tab and commit
llRC = idw_detail.Update()
IF llRC = 1 then
	Execute Immediate "COMMIT" using SQLCA;
Else
	Execute Immediate "ROLLBACK" using SQLCA;
End If
	
This.SetRedraw(True)
ib_Changed = True

end event

event clicked;call super::clicked;
//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

event doubleclicked;call super::doubleclicked;
String	lsDONO

str_parms	lstrParms

If row > 0 Then
	
	If idw_main.GetITemString(1,'ord_type') = 'I' Then /*Open Receive Order */
	
		Lstrparms.String_arg[1] = "W_ROD"
		Lstrparms.String_arg[2] = '*RONO*' + This.GetITemString(row,'rodo_no') /* *rono will tell RO to retrieve by DONO instead of the default order number */
		OpenSheetwithparm(w_ro,lStrparms, w_main, gi_menu_pos, Original!)
		
	Else /*Open Delivery Order */
		Lstrparms.String_arg[1] = "W_DOR"
		Lstrparms.String_arg[2] = '*DONO*' + This.GetITemString(row,'rodo_no') /* *dono will tell DO to retrieve by DONO instead of the default order number */
		OpenSheetwithparm(w_do,lStrparms, w_main, gi_menu_pos, Original!)
	End If
		
End If
end event

type tabpage_status from userobject within tab_main
integer x = 15
integer y = 99
integer width = 3679
integer height = 2010
long backcolor = 79741120
string text = "Shipment Status"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_orphans cb_orphans
cb_clearall_status cb_clearall_status
cb_selectall_status cb_selectall_status
cb_delete_status cb_delete_status
cb_add_status cb_add_status
dw_status dw_status
end type

on tabpage_status.create
this.cb_orphans=create cb_orphans
this.cb_clearall_status=create cb_clearall_status
this.cb_selectall_status=create cb_selectall_status
this.cb_delete_status=create cb_delete_status
this.cb_add_status=create cb_add_status
this.dw_status=create dw_status
this.Control[]={this.cb_orphans,&
this.cb_clearall_status,&
this.cb_selectall_status,&
this.cb_delete_status,&
this.cb_add_status,&
this.dw_status}
end on

on tabpage_status.destroy
destroy(this.cb_orphans)
destroy(this.cb_clearall_status)
destroy(this.cb_selectall_status)
destroy(this.cb_delete_status)
destroy(this.cb_add_status)
destroy(this.dw_status)
end on

type cb_orphans from commandbutton within tabpage_status
integer x = 2103
integer y = 16
integer width = 505
integer height = 77
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Orphaned Status"
end type

event clicked;str_parms lstrparms

lstrparms.String_arg[1] = idw_main.GetItemString(1, 'Awb_Bol_no')
/*
(from w_ro?
lstrparms.String_arg[2] = is_rono
lstrparms.Long_arg[3] = idw_Detail.GetItemNumber(1, "Line_Item_No")
lstrparms.String_arg[4] = idw_Detail.GetItemString(1, "SKU")
lstrparms.String_arg[5] = idw_Detail.GetItemString(1, "User_Field1")

//OpenWithparm(w_iqc,lstrparms)
*/
OpenSheetWithParm(w_orphans, lStrparms, w_main, gi_menu_pos, Original!)
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_clearall_status from commandbutton within tabpage_status
integer x = 336
integer y = 16
integer width = 311
integer height = 77
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear All"
end type

event clicked;Long llRowCount, llRowPos

dw_Status.SetReDraw(False)

llRowCount = dw_Status.RowCount()
For llRowPos = 1 to llRowCount
	dw_Status.SetItem(llRowPos,'c_delete_ind','N')
Next

dw_Status.SetReDraw(True)

cb_delete_status.Enabled = False

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_selectall_status from commandbutton within tabpage_status
integer x = 15
integer y = 16
integer width = 311
integer height = 77
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All"
end type

event clicked;Long llRowCount, llRowPos

dw_Status.SetReDraw(False)

llRowCount = dw_Status.RowCount()
For llRowPos = 1 to llRowCount
	dw_Status.SetItem(llRowPos,'c_delete_ind','Y')
Next

dw_Status.SetReDraw(True)

If llRowCount > 0 Then
	cb_delete_status.Enabled = True
End If
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_delete_status from commandbutton within tabpage_status
integer x = 801
integer y = 16
integer width = 655
integer height = 77
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Checked Status"
end type

event clicked;
dw_status.TriggerEvent('ue_delete')
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_add_status from commandbutton within tabpage_status
integer x = 1485
integer y = 16
integer width = 585
integer height = 77
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Add Status"
end type

event clicked;
dw_status.TriggerEvent('ue_Insert')
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_status from u_dw_ancestor within tabpage_status
integer y = 122
integer width = 3463
integer height = 1696
integer taborder = 20
string dataobject = "d_shipment_status"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event itemchanged;call super::itemchanged;If dwo.name <> 'c_Delete_ind' Then	
	ib_changed = True
	ibStatChanged = True
end if
im_menu.m_file.m_save.Enabled = True //05/05/06

end event

event ue_postitemchanged;call super::ue_postitemchanged;

If Upper(dwo.name) = 'C_DELETE_IND' Then
	If THis.Find("Upper(c_DELETE_Ind) = 'Y'",1,This.RowCOunt()) > 0 Then
		cb_delete_status.Enabled = True
	Else
		cb_delete_status.Enabled = False
	End If
End If
end event

event ue_delete;call super::ue_delete;Long	llRowCount, llRowPos


If Messagebox(is_title,'Are you sure you want to delete the checked Status records?',Question!,YesNo!,2) = 2 Then return

llRowCount = This.RowCount()

This.SetRedraw(false)

For llRowPos = llrowCount to 1 Step -1
	
	If THis.GetITemString(llRowPos,'c_delete_ind') = 'Y' Then
		This.DeleteRow(llRowPos)
		ib_Changed = True
	End If
Next

This.SetRedraw(True)
end event

event ue_insert;call super::ue_insert;
Long	llNewRow
DateTime	ldtToday

// pvh 02.15.06 - gmt
ldtToday = f_getLocalWorldTime( gs_default_wh ) 


llNewRow = This.InsertRow(0)
This.ScrolltoRow(llNewRow)

This.SetItem(llNewRow,'Ship_No', idw_Main.GetItemString(1, 'Ship_No'))
This.SetItem(llNewRow,'ship_Status_Line_No',String(llNewRow))
This.SetItem(llNewRow,'last_user', gs_userid)
This.SetItem(llNewRow,'Create_user', gs_userid)
This.SetItem(llNewRow,'last_update', ldtToday)
This.SetItem(llNewRow,'status_Date', ldtToday)
This.SetItem(llNewRow,'Create_user_date', ldtToday)
//dts - 9/15/04 - default to 'N' so it will save
This.SetItem(llNewRow,'c_delete_ind', 'N')
end event

type tabpage_bol from userobject within tab_main
event create ( )
event destroy ( )
integer x = 15
integer y = 99
integer width = 3679
integer height = 2010
long backcolor = 79741120
string text = "BOL"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_bol_print cb_bol_print
cb_generate_bol cb_generate_bol
dw_bol_prt dw_bol_prt
dw_bol_entry dw_bol_entry
end type

on tabpage_bol.create
this.cb_bol_print=create cb_bol_print
this.cb_generate_bol=create cb_generate_bol
this.dw_bol_prt=create dw_bol_prt
this.dw_bol_entry=create dw_bol_entry
this.Control[]={this.cb_bol_print,&
this.cb_generate_bol,&
this.dw_bol_prt,&
this.dw_bol_entry}
end on

on tabpage_bol.destroy
destroy(this.cb_bol_print)
destroy(this.cb_generate_bol)
destroy(this.dw_bol_prt)
destroy(this.dw_bol_entry)
end on

type cb_bol_print from commandbutton within tabpage_bol
integer x = 2297
integer y = 61
integer width = 322
integer height = 96
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;iw_window.triggerEvent("ue_print_bol")
end event

type cb_generate_bol from commandbutton within tabpage_bol
integer x = 1872
integer y = 58
integer width = 336
integer height = 96
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;iw_window.TriggerEvent("ue_process_bol")
end event

type dw_bol_prt from u_dw_ancestor within tabpage_bol
integer x = 22
integer y = 243
integer width = 3493
integer height = 1482
integer taborder = 30
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_bol_entry from datawindow within tabpage_bol
boolean visible = false
integer y = 10
integer width = 1514
integer height = 192
integer taborder = 10
string dataobject = "d_bol_entry"
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;Choose Case dwo.name
	Case "pieces"
		tab_main.tabpage_bol.dw_bol_prt.SetItem(1,"c_pieces",long(data))
	Case "weight"
		tab_main.tabpage_bol.dw_bol_prt.SetItem(1,"c_weight",string(data))
	Case "desc"
		tab_main.tabpage_bol.dw_bol_prt.SetItem(1,"c_desc",data)
End Choose


end event

