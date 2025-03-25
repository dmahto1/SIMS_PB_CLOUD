$PBExportHeader$w_cc.srw
$PBExportComments$Cycle Count
forward
global type w_cc from w_std_master_detail
end type
type cb_commodity from commandbutton within tabpage_main
end type
type cb_adjustments from commandbutton within tabpage_main
end type
type rb_location from radiobutton within tabpage_main
end type
type rb_sku from radiobutton within tabpage_main
end type
type cb_export from commandbutton within tabpage_main
end type
type cb_void from commandbutton within tabpage_main
end type
type st_cc_owner_nbr from statictext within tabpage_main
end type
type cb_generate from commandbutton within tabpage_main
end type
type cb_report from commandbutton within tabpage_main
end type
type cb_confirm from commandbutton within tabpage_main
end type
type sle_no from singlelineedit within tabpage_main
end type
type cb_import_sku from commandbutton within tabpage_main
end type
type gb_1 from groupbox within tabpage_main
end type
type cb_stock_verification_report from commandbutton within tabpage_main
end type
type st_4 from statictext within tabpage_main
end type
type sle_start_loc from singlelineedit within tabpage_main
end type
type st_5 from statictext within tabpage_main
end type
type sle_end_loc from singlelineedit within tabpage_main
end type
type uo_commodity_code1 from uo_multi_select_search within tabpage_main
end type
type select_commodity_t from statictext within tabpage_main
end type
type gb_import_sku from groupbox within tabpage_main
end type
type dw_sku from datawindow within tabpage_main
end type
type dw_main from u_dw_ancestor within tabpage_main
end type
type cb_search from commandbutton within tabpage_search
end type
type dw_search from datawindow within tabpage_search
end type
type cb_clear from commandbutton within tabpage_search
end type
type dw_result from u_dw_ancestor within tabpage_search
end type
type tabpage_si from userobject within tab_main
end type
type cb_release from commandbutton within tabpage_si
end type
type st_cc_warehouse_print_flag_set_to from statictext within tabpage_si
end type
type st_cc_warehouise_flag_set_to from statictext within tabpage_si
end type
type st_msg2 from statictext within tabpage_si
end type
type st_msg1 from statictext within tabpage_si
end type
type cb_si_delete from commandbutton within tabpage_si
end type
type cb_si_insert from commandbutton within tabpage_si
end type
type dw_si from u_dw_ancestor within tabpage_si
end type
type tabpage_si from userobject within tab_main
cb_release cb_release
st_cc_warehouse_print_flag_set_to st_cc_warehouse_print_flag_set_to
st_cc_warehouise_flag_set_to st_cc_warehouise_flag_set_to
st_msg2 st_msg2
st_msg1 st_msg1
cb_si_delete cb_si_delete
cb_si_insert cb_si_insert
dw_si dw_si
end type
type tabpage_result1 from userobject within tab_main
end type
type cbx_include_components1 from checkbox within tabpage_result1
end type
type cb_insert from commandbutton within tabpage_result1
end type
type em_limit_loc_print_1 from editmask within tabpage_result1
end type
type st_1 from statictext within tabpage_result1
end type
type cb_selectall1 from commandbutton within tabpage_result1
end type
type cb_delete1 from commandbutton within tabpage_result1
end type
type cb_generate1 from commandbutton within tabpage_result1
end type
type cb_print1 from commandbutton within tabpage_result1
end type
type dw_result1 from u_dw_ancestor within tabpage_result1
end type
type tabpage_result1 from userobject within tab_main
cbx_include_components1 cbx_include_components1
cb_insert cb_insert
em_limit_loc_print_1 em_limit_loc_print_1
st_1 st_1
cb_selectall1 cb_selectall1
cb_delete1 cb_delete1
cb_generate1 cb_generate1
cb_print1 cb_print1
dw_result1 dw_result1
end type
type tabpage_result2 from userobject within tab_main
end type
type cbx_include_components2 from checkbox within tabpage_result2
end type
type em_limit_loc_print_2 from editmask within tabpage_result2
end type
type st_2 from statictext within tabpage_result2
end type
type st_c2_msg from statictext within tabpage_result2
end type
type st_cc2_genereate_differences_only from statictext within tabpage_result2
end type
type cb_selectall2 from commandbutton within tabpage_result2
end type
type cb_print2 from commandbutton within tabpage_result2
end type
type cb_generate2 from commandbutton within tabpage_result2
end type
type cb_delete2 from commandbutton within tabpage_result2
end type
type dw_result2 from u_dw_ancestor within tabpage_result2
end type
type tabpage_result2 from userobject within tab_main
cbx_include_components2 cbx_include_components2
em_limit_loc_print_2 em_limit_loc_print_2
st_2 st_2
st_c2_msg st_c2_msg
st_cc2_genereate_differences_only st_cc2_genereate_differences_only
cb_selectall2 cb_selectall2
cb_print2 cb_print2
cb_generate2 cb_generate2
cb_delete2 cb_delete2
dw_result2 dw_result2
end type
type tabpage_result3 from userobject within tab_main
end type
type cbx_include_components3 from checkbox within tabpage_result3
end type
type em_limit_loc_print_3 from editmask within tabpage_result3
end type
type st_3 from statictext within tabpage_result3
end type
type st_c3_msg from statictext within tabpage_result3
end type
type st_cc3_genereate_differences_only from statictext within tabpage_result3
end type
type cb_selectall3 from commandbutton within tabpage_result3
end type
type cb_generate3 from commandbutton within tabpage_result3
end type
type cb_print3 from commandbutton within tabpage_result3
end type
type cb_delete3 from commandbutton within tabpage_result3
end type
type dw_result3 from u_dw_ancestor within tabpage_result3
end type
type tabpage_result3 from userobject within tab_main
cbx_include_components3 cbx_include_components3
em_limit_loc_print_3 em_limit_loc_print_3
st_3 st_3
st_c3_msg st_c3_msg
st_cc3_genereate_differences_only st_cc3_genereate_differences_only
cb_selectall3 cb_selectall3
cb_generate3 cb_generate3
cb_print3 cb_print3
cb_delete3 cb_delete3
dw_result3 dw_result3
end type
type tabpage_mobile from userobject within tab_main
end type
type cb_delete_location from commandbutton within tabpage_mobile
end type
type dw_mobile from u_dw_ancestor within tabpage_mobile
end type
type tabpage_mobile from userobject within tab_main
cb_delete_location cb_delete_location
dw_mobile dw_mobile
end type
type tabpage_system_generated from userobject within tab_main
end type
type dw_system_generated from u_dw_ancestor within tabpage_system_generated
end type
type tabpage_system_generated from userobject within tab_main
dw_system_generated dw_system_generated
end type
type tabpage_serial_numbers from userobject within tab_main
end type
type cb_3 from commandbutton within tabpage_serial_numbers
end type
type cb_2 from commandbutton within tabpage_serial_numbers
end type
type cb_1 from commandbutton within tabpage_serial_numbers
end type
type dw_serial_numbers from u_dw_ancestor within tabpage_serial_numbers
end type
type tabpage_serial_numbers from userobject within tab_main
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_serial_numbers dw_serial_numbers
end type
type tabpage_container from userobject within tab_main
end type
type dw_cc_container from datawindow within tabpage_container
end type
type cb_6 from commandbutton within tabpage_container
end type
type cb_5 from commandbutton within tabpage_container
end type
type cb_4 from commandbutton within tabpage_container
end type
type tabpage_container from userobject within tab_main
dw_cc_container dw_cc_container
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
end type
type p_arrow from picture within w_cc
end type
end forward

global type w_cc from w_std_master_detail
integer width = 4375
integer height = 2612
string title = "Cycle Count"
event ue_selector ( boolean _selector )
event ue_getowner ( )
p_arrow p_arrow
end type
global w_cc w_cc

type variables
Datawindow   idw_main, idw_search,idw_result
Datawindow idw_si,idw_report , idw_cc_container
Datawindow idw_result1,idw_result2,idw_result3, idw_mobile, idw_system_generated,idw_serial_numbers
datawindowchild idwc_count1_supp,idwc_count2_supp,idwc_count3_supp
SingleLineEdit isle_code

string is_sql
string is_max_lcode,is_min_lcode
string is_max_sku,is_min_sku

w_cc iw_window
n_warehouse i_nwarehouse

boolean ib_order_from_first
boolean ib_order_to_first
boolean ib_complete_from_first
boolean ib_complete_to_first
Boolean ib_NeedCitrix
Boolean ib_Adjustments_Allowed
Boolean ib_show_commodity_list //TAM PEVS-513
Boolean ib_Filter_Allocated//TAM PEVS-420
Boolean ib_Foot_Print_SKU =FALSE //24-APR-2018 :Madhu S18502 - FootPrint Cycle Count

// pvh - 06/08/06 - ccmods
u_sqlutil	SqlUtil

integer iiCountTab

datastore idsLocations
datastore idsReport
datastore idsItemMaster

datastore idsGroup
datastore idsClass
datastore ids_CC_UpCountZero_Result
datastore ids_ro_main
datastore ids_ro_detail
datastore ids_ro_putaway
datastore ids_ro_content
datastore ids_ro_serial

datawindowchild idwc_group
datawindowchild idwc_class
datawindowchild idwc_commodity_list
datawindowchild idwc_owner

string isSortOrder
string isWarehouse
string isBlindKnownFlag
string isBlindKnownPrtFlag
string isCountDiff
string isOrderType
string isSkuArray[]
string isSupplierArray[]
string isOrigGroupSQL
string isOrigClassSQL
string isCCOrder
string isDeleteCCValues

//constant int failure = -1
//constant int success = 0

boolean ib_freeze_cc_inventory
boolean ib_up_count_zero_cc = FALSE

inet	linit
u_nvo_websphere_post	iuoWebsphere

// LTK 20150508  Lot-able rollup
constant int CC_RESULTS1_TAB = 3
constant int CC_RESULTS2_TAB = 4
constant int CC_RESULTS3_TAB = 5

// LTK 20150508  Lot-able rollup
constant int DECODE_SERIAL_NO 		= 1
constant int DECODE_CONTAINER_ID 	= 2
constant int DECODE_LOT_NO	 			= 3
constant int DECODE_PO_NO	 			= 4
constant int DECODE_PO_NO2	 			= 5
constant int DECODE_EXP_DT	 			= 6
constant int DECODE_INV_TYPE	 		= 7
constant int DECODE_COO		 			= 8

n_string_util in_string_util
boolean ib_verbose_tracing

constant int PROTECT			= 1
constant int UNPROTECT		= 0

end variables

forward prototypes
public subroutine wf_clear_screen ()
public subroutine wf_sort ()
public function integer wf_validation ()
public subroutine wf_check_status ()
public subroutine setcounttab (integer _tab)
public function integer getcounttab ()
public function integer doprintcountsheets ()
public function boolean dovalidskuquantitycheck (ref datawindow _dw)
public function integer gettabpagefordw (ref datawindow _dw)
public function boolean doduplicatecheck (ref datawindow _dw, integer arow)
public function integer doaccepttext ()
public function integer dorequiredfieldcheck ()
public subroutine setdwredraw (boolean _switch)
public function integer dovalidate (ref datawindow _dw)
public subroutine setsortorder (string _value)
public function string getsortorder ()
public subroutine setwarehouse (string _value)
public function string getwarehouse ()
public subroutine setblindknown ()
public subroutine setblindknownprt ()
public subroutine setblindmessage (string _value)
public subroutine setprtblindmessage (string _value)
public subroutine setcountdiff ()
public function string getblindknown ()
public function string getcountdiff ()
public subroutine dodisplaysysqty (boolean _flag)
public subroutine docountdiffrefresh (ref datawindow _dw)
public subroutine setsysquantityoncount (ref datawindow _dw, boolean _flag)
public function string getblindknownprt ()
public subroutine setordertype (string _value)
public function string getordertype ()
public function integer doupdateitemmastercompletedate (string _sku, string _supplier, datetime _completedate)
public function boolean getupdatedsku (string _sku, string _supplier)
public subroutine setupdatedsku (string _sku, string _supplier)
public subroutine docomparesysinv ()
public subroutine dofilterdropdown (ref datawindowchild _child, string _column, string _value)
public function boolean getisskuingroup (string _sku, string _supplier)
public function boolean getisskuinclass (string _sku, string _supplier)
public subroutine dodisplayownername (long _id)
public function boolean getisskuowner (string _sku, string _supplier)
public function integer setlocationcompletedate (datetime _value)
public subroutine setsysteminventorydisplay (boolean _flag)
public function long getsysinvrow (long _lineitemno)
public function long getresultrow (ref datawindow _dw, long _lineitemno)
public subroutine setcountsheetdisplay (boolean _flag)
public subroutine settitle (string _value)
public function string gettitle ()
public subroutine setccorder (string _value)
public function string getccorder ()
public function datastore getcomparesysinv ()
public function integer setitemmastercompletedate (datetime _value)
public function long getemptylinenumberforloc (string lcode)
public function integer wf_assign_random_locations (string aswarehouse)
public function integer uf_load_sys_inv (datastore ads)
public function integer wf_print_export_report (integer arg_print_export)
public function string wf_find_greatest_allocated (integer al_row)
public function integer wf_check_status_mobile ()
public function boolean wf_run_on_citrix (integer al_rows)
public function long wf_find_existing_count_row (datawindow adw_count, long al_row, integer ai_tab_no)
public function string wf_build_encoded_rollup_code (integer ai_tab_no)
public function boolean wf_decode_indicators (string as_encoded_indicators, integer ai_position)
public function decimal wf_sum_si_quantity (any aa_row_number_array)
public function boolean wf_is_current_count_more_granular (string as_previous_count_indicators, string as_current_count_indicators)
public function any wf_find_si_sibling_set (integer ai_line_item_no, integer ai_count_tab)
public function any wf_find_corresponding_si_rows (datawindow adw_count, long al_row, boolean ab_has_zero_qty)
public subroutine wf_clear_si_count_results (integer ai_count)
public subroutine of_protectresults (datawindow adw_results, integer ai_protect)
public function decimal getsysqtyforline (integer ai_tab, long index)
public function boolean wf_is_null_quantities_on_last_count ()
public function boolean wf_is_cc_processed_in_old_sims_version ()
public function string wf_get_rollup_release_lines (any aa_row_number_array)
public function any wf_find_corresponding_release_lines (datawindow adw_count, long al_row, boolean ab_has_zero_qty)
public function long getresultrowrollup (ref datawindow _dw, string _releaselinelist)
public function string wf_find_greatest_allocated_rollup (integer al_row, string as_encoded_indicators)
public subroutine wf_multi_select_commodity_code ()
public function integer dovalidateserialnumbers (ref datawindow _dw)
public function boolean wf_check_if_skus_are_serialized ()
public function integer wf_compare_count_to_serials ()
public function string of_parse_numeric_sys_no (string as_sys_no)
public function integer wf_check_status_serial_numbers ()
public function integer wf_check_status_system_generated ()
public function long wf_is_sn_scan_required ()
public subroutine wf_remove_filter ()
public function boolean wf_is_sku_foot_print (string as_sku, string as_supp_code)
public function integer wf_check_status_container ()
public function integer wf_find_foot_print_container_on_count3 (long al_row)
public function integer wf_validate_save_foot_print_containers ()
public function integer wf_process_foot_print_container_serials ()
public function integer wf_validate_save_foot_print_serials ()
public function integer wf_change_color_of_discrepancy_serials ()
public function integer wf_populate_foot_print_container_serial (string as_sku, string as_wh_code, string as_loc, string as_container_id)
public function integer wf_reveal_matched_container_on_count3 ()
public function integer dovalidatecontainerids (datawindow _dw)
public function integer wf_get_count_of_serial_no (string as_find)
public function integer wf_generate_up_count_zero_records (datawindow _dw, integer ai_count_tab)
public function integer wf_remove_result_filter ()
public function integer wf_find_up_count_zero_sku_loc (string as_type, string as_sku_loc)
public function integer wf_create_up_count_zero_cc_records ()
public function boolean wf_is_sku_serialized (string as_sku, string as_supp_code)
public function long getsysinventorymaxlineitemno ()
public function boolean wf_is_up_count_location_empty (string as_sku, string as_loc)
public function integer dogeneratecountsheet (ref datawindow _dw, ref checkbox _cb)
end prototypes

event ue_selector(boolean _selector);// ue_selector( boolean _selector )

string _value
int index
int max

datawindow adw
adw = create datawindow

choose case getCountTab()
	case 3
		adw = idw_result1
	case 4
		adw = idw_result2
	case 5
		adw = idw_result3
end choose

_value = 'N'
if _selector then _value = 'Y'

max = adw.rowcount()
for index = 1 to max
	adw.object.sysinvmatch[index] = _value
	if _value = 'Y' then
		//adw.object.quantity[ index ] = 	idw_si.object.quantity[ getSysInvRow( long( adw.object.line_item_no[ index ] )) ] 
		adw.object.quantity[ index ] = 	adw.object.sysquantity[ index ]	// LTK 20150717
	else
		adw.object.quantity[ index ] = 	0
	end if
next
adw.accepttext()


	
end event

event ue_getowner();str_parms	lstrparms

open(w_select_owner)
lstrparms = Message.PowerObjectParm
If Not lstrparms.Cancelled and UpperBound(lstrparms.Long_arg) > 0 Then
	idw_main.object.owner_id[ 1 ] = Lstrparms.Long_arg[1]
	idw_main.object.t_ownerName.text = Lstrparms.string_arg[1]
end if


end event

public subroutine wf_clear_screen ();tab_main.tabpage_si.enabled = false
tab_main.tabpage_result1.enabled = false
tab_main.tabpage_result2.enabled = false
tab_main.tabpage_result3.enabled = false
tab_main.tabpage_mobile.enabled = false /* 04/15 - PCONKL */
tab_main.tabpage_system_generated.enabled = false /* TAM 2017/11 - 3PL CC */
tab_main.tabpage_serial_numbers.enabled = false /* TAM 2017/11 - 3PL CC */
tab_main.tabpage_container.enabled = false //24-APR-2018 :Madhu S18502 - FootPrint Cycle Count


idw_main.Reset()

tab_main.SelectTab(1) 
idw_main.Hide()

//tab_main.tabpage_si.Enabled = False
//tab_main.tabpage_result1.Enabled = False
//tab_main.tabpage_result2.Enabled = False
//tab_main.tabpage_result3.Enabled = False

isle_code.Text = ""

//12/5/11 - MEA - Added for Import SKU
integer i 

For i = 1 to 5
	tab_main.tabpage_main.dw_sku.InsertRow(0)
Next

Return

end subroutine

public subroutine wf_sort ();// Begin - Dinesh - 07/02/2021- S57097- NYCSP - KNY: Order Cycle Count Data
if upper(gs_project) ='NYCSP' then
	
idw_si.setSort( getSortOrder() )
idw_result1.setSort('l_code,Inventory_Type d,sku')
idw_result2.setSort('l_code,Inventory_Type d,sku')
idw_result3.setSort('l_code,Inventory_Type d,sku')
idw_si.Sort()
idw_result1.Sort()
idw_result2.Sort()
idw_result3.Sort()
// End - Dinesh - 07/02/2021- S57097- NYCSP - KNY: Order Cycle Count Data
else
	
idw_si.setSort( getSortOrder() )
idw_result1.setSort( getSortOrder() )
idw_result2.setSort( getSortOrder() )
idw_result3.setSort( getSortOrder() )
idw_si.Sort()
idw_result1.Sort()
idw_result2.Sort()
idw_result3.Sort()

end if

	

end subroutine

public function integer wf_validation ();// wf_validation()

idsLocations = f_DatastoreFactory('d_locations_by_wh_code')
idsLocations.retrieve( idw_main.GetItemString(1,"wh_code") )

if doAcceptText() < 0 then return -1

SetMicroHelp("Checking required fields...")
if doRequiredFieldCheck() < 0 then return -1

SetMicroHelp("Validating Data on Count Sheet 1...")
if doValidate( idw_result1 ) < 0 then return -1
SetMicroHelp("Validating Data on Count Sheet 2...")
if doValidate( idw_result2 ) < 0 then return -1
SetMicroHelp("Validating Data on Count Sheet 3...")
if doValidate( idw_result3 ) < 0 then return -1

// make sure they don't have a quantity for an 'EMPTY' sku
SetMicroHelp("Validating Quantity Rows on Count Sheet 1...")
if doValidSkuQuantityCheck( idw_result1 ) then return -1
SetMicroHelp("Validating Quantity Rows on Count Sheet 2...")
if doValidSkuQuantityCheck( idw_result2 ) then return -1
SetMicroHelp("Validating Quantity Rows on Count Sheet 3...")
if doValidSkuQuantityCheck( idw_result3 ) then return -1

SetMicroHelp("Validating  Rows on Serial Numbers Tab...")
if doValidateSerialNumbers( idw_serial_numbers ) < 0 Then return -1

//30-APR-2018 :Madhu S18502 - FootPrint Cycle Count
SetMicroHelp("Validating  Rows on Container Tab...")
If dovalidatecontainerIds(idw_cc_container) < 0 Then Return -1


destroy( idsLocations )
SetMicroHelp("Validation complete!")

Return 0
end function

public subroutine wf_check_status ();isle_code.DisplayOnly = True
isle_code.TabOrder = 0
isle_code.backcolor=12639424 /* 01/01 PCONKL */
string status, ls_Status //dts added 2nd 'Status' variable to control Case statement, in case we're locking due to non-Citrix MAX exceeded.

f_method_trace_special( gs_project, this.ClassName() , 'Start check status ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

idw_Main.acceptText()

im_menu.m_file.m_print.Enabled = False

status = idw_main.GetItemString(1,"ord_status")
ls_Status = status
tab_main.tabpage_si.cb_si_insert.enabled = false
tab_main.tabpage_si.cb_si_delete.enabled = false
// dts - 3/3/13 - Pandora 556 (release inventory in cycle count)
tab_main.tabpage_si.cb_release.enabled = false
tab_main.tabpage_si.cb_release.visible = false
//07-May-2017 :TAM - PEVS-513 -Stock Inventory Commodity Codes - START
tab_main.tabpage_main.select_commodity_t.visible = false
tab_main.tabpage_main.cb_commodity.visible = false
tab_main.tabpage_main.uo_commodity_code1.visible = false
tab_main.tabpage_main.uo_commodity_code1.dw_search.visible =false
//tab_main.tabpage_main.uo_commodity_code1.bringtotop = true

//07-May-2017 :TAM - PEVS-513 -Stock Inventory Commodity Codes - END

f_method_trace_special( gs_project, this.ClassName() , 'Process check status, current status is: ' +status ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

// dts - 11/24/14 - force 'Large' cycle counts to be processed on Citrix....
if ib_NeedCitrix then
	ls_Status = 'C'
	f_method_trace_special( gs_project, this.ClassName() , 'Locking Cycle Count due to MAX Non-Citrix limit exceeded' ,isCCOrder, '','',isCCOrder)
end if
	
// LTK 20150806  Set CC to readonly if it is in process and was processed with a version of SIMS prior to 7/24/2015 (the CC Rolllup release)
if wf_is_cc_processed_in_old_sims_version() then
	ls_Status = 'C'
	MessageBox( is_title, "This Cycle Count was partially processed in a previous version of SIMS. ~r~rPlease finish processing this Cycle Count in SIMS version 7/10/2015 or earlier." )
	f_method_trace_special( gs_project, this.ClassName() , 'Locking Cycle Count due to it was partially processed in an older version (prior to 7/24/2015) of SIMS.' ,isCCOrder, '','',isCCOrder)
end if	
	
if status = 'P' then
	tab_main.tabpage_si.cb_si_insert.enabled = true and not ib_NeedCitrix
	tab_main.tabpage_si.cb_si_delete.enabled = true and not ib_NeedCitrix
end if	
	
Choose Case ls_Status //status
	// TAM 2017/05  SIMSPEVS-420 If Status = Allocated then Lock down fields from Changing
	//Case "N" 
	Case "N" , "A"
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_refresh.Enabled = False
		//
		// what kind of crap is this?
//		If ib_edit Then
//			im_menu.m_file.m_retrieve.Enabled = True
//			im_menu.m_record.m_delete.Enabled = True
//		Else
//			im_menu.m_record.m_delete.Enabled = False
//			im_menu.m_file.m_retrieve.Enabled = False
//		End If
		// pvh this does the same thing
		im_menu.m_file.m_retrieve.Enabled = ib_edit
		im_menu.m_record.m_delete.Enabled = ib_edit
		//
		
		tab_main.tabpage_main.cb_confirm.enabled = False
		tab_main.tabpage_main.cb_report.enabled = False
		tab_main.tabpage_main.cb_export.enabled = False
		tab_main.tabpage_main.cb_generate.enabled = True
		tab_main.tabpage_main.cb_adjustments.enabled = False /* 02/16 - PCONKL */
		tab_main.tabpage_result1.cb_generate1.enabled = False
		tab_main.tabpage_result2.cb_generate2.enabled = False
		tab_main.tabpage_result3.cb_generate3.enabled = False
		tab_main.tabpage_main.cb_void.enabled = True
		// tab_main.tabpage_result1.cb_insert.enabled = False
		// tab_main.tabpage_result1.cb_delete1.enabled = False
		// tab_main.tabpage_result2.cb_delete2.enabled = False
		// tab_main.tabpage_result3.cb_delete3.enabled = False
		tab_main.tabpage_si.Enabled = False
		tab_main.tabpage_result1.Enabled = False
		tab_main.tabpage_result2.Enabled = False
		tab_main.tabpage_result3.Enabled = False

		idw_main.SetTabOrder("ord_type",10)
		idw_main.SetTabOrder("ord_date", 20)
		idw_main.SetTabOrder("count1_complete", 30)
		idw_main.SetTabOrder("count2_complete", 40)
		idw_main.SetTabOrder("count3_complete", 50)
		idw_main.SetTabOrder("complete_date", 60)
		idw_main.SetTabOrder("wh_code", 70)
		idw_main.SetTabOrder("range_start", 80)
		idw_main.SetTabOrder("range_end", 90)
		idw_main.SetTabOrder("range_cnt", 100)
		idw_main.SetTabOrder("user_field1",110)
		idw_main.SetTabOrder("user_field2",120)
		idw_main.SetTabOrder("user_field3",130)

		idw_main.SetTabOrder("group",140)
		idw_main.SetTabOrder("class",150)
		idw_main.SetTabOrder("owner_id",160)		
		idw_main.Modify("b_owner.enabled='true'")		
	
		idw_main.SetTabOrder("remark",170)


		idw_result1.SetTabOrder("sku",10)
		idw_result1.SetTabOrder("sysinvmatch",13)
		idw_result1.SetTabOrder("supp_code",20)
		idw_result1.SetTabOrder("country_of_origin",25)
		idw_result1.SetTabOrder("l_code",30)
		idw_result1.SetTabOrder("inventory_type",40)
		idw_result1.SetTabOrder("lot_no",50)
		idw_result1.SetTabOrder("serial_no",60)		
		idw_result1.SetTabOrder("po_no",70)
		idw_result1.SetTabOrder("po_no2",80)
		idw_result1.SetTabOrder("container_ID",90) //GAP 11-02
		idw_result1.SetTabOrder("expiration_date",100) //GAP 11-02
		idw_result1.SetTabOrder("quantity",110)
		idw_result1.SetTabOrder("uom_1",120)
		idw_result1.SetTabOrder("grp",130)


		idw_result2.SetTabOrder("sku",10)
		idw_result2.SetTabOrder("sysinvmatch",13)
		idw_result2.SetTabOrder("supp_code",15)
		idw_result2.SetTabOrder("l_code",20)
		idw_result2.SetTabOrder("country_of_origin",25)
		idw_result2.SetTabOrder("inventory_type",30)
		idw_result2.SetTabOrder("lot_no",40)
		idw_result2.SetTabOrder("serial_no",50)
		idw_result2.SetTabOrder("po_no",60)
		idw_result2.SetTabOrder("po_no2",70)
		idw_result2.SetTabOrder("container_ID",90) //GAP 11-02
		idw_result2.SetTabOrder("expiration_date",100) //GAP 11-02
		idw_result2.SetTabOrder("quantity",110)
		idw_result2.SetTabOrder("uom_1",120)
		idw_result2.SetTabOrder("grp",130)

		idw_result3.SetTabOrder("sku",10)
		idw_result3.SetTabOrder("sysinvmatch",13)
		idw_result3.SetTabOrder("supp_code",15)
		idw_result3.SetTabOrder("l_code",20)
		idw_result3.SetTabOrder("country_of_origin",25)
		idw_result3.SetTabOrder("inventory_type",30)
		idw_result3.SetTabOrder("lot_no",40)
		idw_result3.SetTabOrder("serial_no",50)
		idw_result3.SetTabOrder("po_no",60)
		idw_result3.SetTabOrder("po_no2",70)
		idw_result3.SetTabOrder("container_ID",90) //GAP 11-02
		idw_result3.SetTabOrder("expiration_date",100) //GAP 11-02
		idw_result3.SetTabOrder("quantity",110)
		idw_result3.SetTabOrder("uom_1",120)
		idw_result3.SetTabOrder("grp",130)

		// TAM 2017/05  SIMSPEVS-420 If Status = Allocated then Lock down fields from Changing
		//TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off
		if (status = 'A' and ib_Filter_Allocated = True) OR &
		   (idw_main.GetItemString(1, "ord_type") = "F" ) then  //Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
			idw_main.SetTabOrder("wh_code", 0)
			idw_main.SetTabOrder("range_start", 0)
			idw_main.SetTabOrder("range_end", 0)
			idw_main.SetTabOrder("range_cnt", 0)
			idw_main.SetTabOrder("ord_type",0)
			idw_main.SetTabOrder("ord_date", 0)
			idw_main.SetTabOrder("group",0)
			idw_main.SetTabOrder("class",0)
			idw_main.SetTabOrder("owner_id",0)		
// TAM 2017/06 PEVS-637 Lock Down Fields
		 	idw_main.SetTabOrder("count1_complete", 0)
		 	idw_main.SetTabOrder("count2_complete", 0)
		 	idw_main.SetTabOrder("count3_complete", 0)
			idw_main.SetTabOrder("User_field4",0)		
			idw_main.SetTabOrder("User_field5",0)		
			idw_main.SetTabOrder("User_field6",0)		
			idw_main.Modify("b_owner.enabled='false'")		
		End If 

//TAM 2015/01/19 - If Order type = "X" (System Generated) then Lock the fields
		if  idw_main.GetItemString(1, "ord_type") = 'X' Then 
			idw_main.SetTabOrder("wh_code", 0)
			idw_main.SetTabOrder("ord_type",0)
			idw_main.SetTabOrder("range_start", 0)
			idw_main.SetTabOrder("range_end", 0)
			idw_main.SetTabOrder("range_cnt", 0)
			idw_main.SetTabOrder("ord_date", 0)
			idw_main.SetTabOrder("group",0)
			idw_main.SetTabOrder("class",0)
			idw_main.SetTabOrder("owner_id",0)		
		End If 
		
		//if left (gs_project,4) = "NIKE" and idw_main.GetItemString(1, "ord_type") = 'I' then
		if idw_main.GetItemString(1, "ord_type") = 'I' then	// LTK 20150722  Change this code so it matches the itemchanged code.  This method is now being
																		// called from postitemchanged so the two must match, which will alleviate the issue of the import
																		// datawindow flashing visible upon item change and then being set to invisible here.

			tab_main.tabpage_main.gb_import_sku.visible = true
				
			tab_main.tabpage_main.dw_sku.visible = true
			tab_main.tabpage_main.cb_import_sku.visible = true

			tab_main.tabpage_main.rb_sku.visible = true			
			tab_main.tabpage_main.rb_location.visible = true


			tab_main.tabpage_main.gb_import_sku.SetPosition(Behind!, tab_main.tabpage_main.dw_sku)

			tab_main.tabpage_main.dw_sku.SetPosition(TopMost!)
			tab_main.tabpage_main.cb_import_sku.SetPosition(TopMost!)

		else

			tab_main.tabpage_main.gb_import_sku.visible = false
				
			tab_main.tabpage_main.dw_sku.visible = false
			tab_main.tabpage_main.cb_import_sku.visible = false

			tab_main.tabpage_main.rb_sku.visible = false			
			tab_main.tabpage_main.rb_location.visible = false

		end if

		//07-May-2017 :TAM - PEVS-513 -Stock Inventory Commodity Codes - START
		if idw_main.GetItemString(1, "ord_type") = 'C' and Status = 'N' then	// LTK 20150722  Change this code so it matches the itemchanged code.  This method is now being
																		// called from postitemchanged so the two must match, which will alleviate the issue of the import
																		// datawindow flashing visible upon item change and then being set to invisible here.
			tab_main.tabpage_main.select_commodity_t.visible = true
			tab_main.tabpage_main.cb_commodity.visible = true
			tab_main.tabpage_main.uo_commodity_code1.visible = true
			tab_main.tabpage_main.uo_commodity_code1.dw_search.visible = true
//			tab_main.tabpage_main.select_commodity_t.bringtotop = true
//			tab_main.tabpage_main.cb_commodity.bringtotop = true
//			tab_main.tabpage_main.uo_commodity_code1.bringtotop = true

			tab_main.tabpage_main.select_commodity_t.SetPosition(Behind!, tab_main.tabpage_main.uo_commodity_code1)
			tab_main.tabpage_main.uo_commodity_code1.SetPosition(TopMost!)
			tab_main.tabpage_main.cb_commodity.SetPosition(TopMost!)

//			tab_main.tabpage_main.uo_commodity_code1.SetPosition(TopMost!)
//			tab_main.tabpage_main.select_commodity_t.setposition(Behind!)
//			tab_main.tabpage_main.cb_commodity.SetPosition(TopMost!)
		else
			tab_main.tabpage_main.select_commodity_t.visible = false
			tab_main.tabpage_main.cb_commodity.visible = false
			tab_main.tabpage_main.uo_commodity_code1.visible = false
		end if
		//07-May-2017 :TAM - PEVS-513 -Stock Inventory Commodity Codes - END
		
		tab_main.tabpage_main.cb_stock_verification_report.enabled = true
		tab_main.tabpage_main.sle_start_loc.enabled = true
		tab_main.tabpage_main.sle_end_loc.enabled = true
		
		 tab_main.tabpage_result1.cbx_include_components1.visible = false
		 tab_main.tabpage_result2.cbx_include_components2.visible = false
		 tab_main.tabpage_result3.cbx_include_components3.visible = false
		

	Case "P", "1", "2", "3"
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_refresh.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = True
		im_menu.m_record.m_delete.Enabled = True
		tab_main.tabpage_main.cb_confirm.enabled = True
		tab_main.tabpage_main.cb_report.enabled = True	
		tab_main.tabpage_main.cb_export.enabled = True
		tab_main.tabpage_main.cb_generate.enabled = False	
		tab_main.tabpage_main.cb_adjustments.enabled = False /* 02/16 - PCONKL */
		tab_main.tabpage_result1.cb_generate1.enabled = True
		tab_main.tabpage_result2.cb_generate2.enabled = True
		tab_main.tabpage_result3.cb_generate3.enabled = True
		tab_main.tabpage_main.cb_void.enabled = True		
//		tab_main.tabpage_result1.cb_insert.enabled = True
//		tab_main.tabpage_result1.cb_delete1.enabled = True
//     	tab_main.tabpage_result2.cb_delete2.enabled = True	
//		tab_main.tabpage_result3.cb_delete3.enabled = True

		// ET3 2013-01-07 - Pandora 556; enable row delete in counts
		// ET3 2013-02-21 - Turning this off temporarily till phase II is ready
		// dts - 2/27/2013 - turning back on for 556 Phase 2 (setting a deleted line's qty to Allocated)
		// dts - 3/3/13 - now exposing 556 functionality via the 'Release Line' button 
		//if UPPER(gs_project) = 'PANDORA' then  //may want to make this baseline
		//now using ib_freeze_cc_inventory (project-level setting)
		if ib_freeze_cc_inventory then  //may want to make this baseline
//			tab_main.tabpage_result1.cb_delete1.enabled = True
//			tab_main.tabpage_result2.cb_delete2.enabled = True
//			tab_main.tabpage_result3.cb_delete3.enabled = True
			
//			tab_main.tabpage_result1.cb_delete1.visible = True
//			tab_main.tabpage_result2.cb_delete2.visible = True
//			tab_main.tabpage_result3.cb_delete3.visible = True
			// dts - 3/3/13 - Pandora 556 (release inventory in cycle count)
			tab_main.tabpage_si.cb_release.visible = true
			//dts - 03/19/13 Now also exposing 'Release' functionality if CC is in Process status.
			//if status <> 'P' then //enable 'Release' if status is either 1, 2, or 3
				tab_main.tabpage_si.cb_release.enabled = true
			//else
			//	tab_main.tabpage_si.cb_release.enabled = false
			//end if
		end if			
		
		//14-MAY-2018 :Madhu S19286 - Up count from Non existing qty
		if upper(gs_project) ='PANDORA' and (ls_Status ='P' or ls_Status ='1') Then
			tab_main.tabpage_result1.cb_insert.visible =true
			tab_main.tabpage_result1.cb_delete1.visible =true
			
		else
			tab_main.tabpage_result1.cb_insert.visible =false
			tab_main.tabpage_result1.cb_delete1.visible =false
		end if
		
		tab_main.tabpage_si.Enabled = True
		tab_main.tabpage_result1.Enabled = True
		tab_main.tabpage_result2.Enabled = True
		tab_main.tabpage_result3.Enabled = True

		idw_main.SetTabOrder("ord_type",0)
		idw_main.SetTabOrder("ord_date", 20)
		idw_main.SetTabOrder("count1_complete", 30)
		idw_main.SetTabOrder("count2_complete", 40)
		idw_main.SetTabOrder("count3_complete", 50)
		idw_main.SetTabOrder("complete_date", 60)
		idw_main.SetTabOrder("wh_code", 0)
		idw_main.SetTabOrder("range_start", 0)
		idw_main.SetTabOrder("range_end", 0)
		idw_main.SetTabOrder("range_cnt", 0)
		
		//12/11 - MEA - Added for NIKE - Can only change on new
		
		if left(gs_project,4) = "NIKE" then
			
		 	idw_main.SetTabOrder("user_field1", 0)
			idw_main.SetTabOrder("user_field2",0)
			idw_main.SetTabOrder("user_field3",110)
		
		else
		
			idw_main.SetTabOrder("user_field1",110)
			idw_main.SetTabOrder("user_field2",120)
			idw_main.SetTabOrder("user_field3",130)

		end if

// TAM 2017/06 PEVS-637 Lock Down Pandora Fields
		if left(gs_project,4) = "PANDORA" then
		 	idw_main.SetTabOrder("count1_complete", 0)
		 	idw_main.SetTabOrder("count2_complete", 0)
		 	idw_main.SetTabOrder("count3_complete", 0)
		 	idw_main.SetTabOrder("user_field4", 0)
			idw_main.SetTabOrder("user_field5",0)
			idw_main.SetTabOrder("user_field6",0)
		end if

		idw_main.SetTabOrder("group",140)
		idw_main.SetTabOrder("class",150)
		idw_main.SetTabOrder("owner_id",160)		
		idw_main.Modify("b_owner.enabled='true'")		

		idw_main.SetTabOrder("remark",170)	
		

		idw_result1.SetTabOrder("sku",10)
		idw_result1.SetTabOrder("sysinvmatch",13)
		idw_result1.SetTabOrder("supp_code",15)
		idw_result1.SetTabOrder("l_code",20)
		idw_result1.SetTabOrder("country_of_origin",25)
		idw_result1.SetTabOrder("inventory_type",30)		
		idw_result1.SetTabOrder("lot_no",40)
		idw_result1.SetTabOrder("serial_no",50)
		idw_result1.SetTabOrder("po_no",60)
		idw_result1.SetTabOrder("po_no2",70)
		idw_result1.SetTabOrder("container_ID",90)  //GAP 11-02
		idw_result1.SetTabOrder("expiration_date",100)//GAP 11-02
		idw_result1.SetTabOrder("quantity",110)
		idw_result1.SetTabOrder("uom_1",120)
		idw_result1.SetTabOrder("grp",130)

		idw_result2.SetTabOrder("sku",10)
		idw_result2.SetTabOrder("sysinvmatch",13)
		idw_result2.SetTabOrder("supp_code",15)
		idw_result2.SetTabOrder("l_code",20)
		idw_result2.SetTabOrder("country_of_origin",25)
		idw_result2.SetTabOrder("inventory_type",30)
		idw_result2.SetTabOrder("lot_no",40)
		idw_result2.SetTabOrder("serial_no",50)		
		idw_result2.SetTabOrder("po_no",60)
		idw_result2.SetTabOrder("po_no2",70)
		idw_result2.SetTabOrder("container_ID",90)//GAP 11-02
		idw_result2.SetTabOrder("expiration_date",100)//GAP 11-02
		idw_result2.SetTabOrder("quantity",110)
		idw_result2.SetTabOrder("uom_1",120)
		idw_result2.SetTabOrder("grp",130)

		idw_result3.SetTabOrder("sku",10)
		idw_result3.SetTabOrder("sysinvmatch",13)
		idw_result3.SetTabOrder("supp_code",15)
		idw_result3.SetTabOrder("l_code",20)
		idw_result3.SetTabOrder("country_of_origin",25)
		idw_result3.SetTabOrder("inventory_type",30)
		idw_result3.SetTabOrder("lot_no",40)
		idw_result3.SetTabOrder("serial_no",50)
		idw_result3.SetTabOrder("po_no",60)
		idw_result3.SetTabOrder("po_no2",70)
		idw_result3.SetTabOrder("container_ID",90)//GAP 11-02
		idw_result3.SetTabOrder("expiration_date",100)//GAP 11-02
		idw_result3.SetTabOrder("quantity",110)
		idw_result3.SetTabOrder("uom_1",120)
		idw_result3.SetTabOrder("grp",130)

		
		tab_main.tabpage_main.cb_stock_verification_report.enabled = true
		tab_main.tabpage_main.sle_start_loc.enabled = true
		tab_main.tabpage_main.sle_end_loc.enabled = true	
		
		If upper(gs_project) ='NYCSP' 	Then  // Dinesh -F24934/S50765/- 10/29/2020 - Component on cycle count for order type SKU as well
		 
			 tab_main.tabpage_result1.cbx_include_components1.visible = true
			 tab_main.tabpage_result2.cbx_include_components2.visible = true
			 tab_main.tabpage_result3.cbx_include_components3.visible = true
			 
		Else
			
			 tab_main.tabpage_result1.cbx_include_components1.visible = false
			 tab_main.tabpage_result2.cbx_include_components2.visible = false
			 tab_main.tabpage_result3.cbx_include_components3.visible = false
			
		
		End IF
		

	Case "C", "D"  /* 04/15 - PCONKL - added D for discpreancy */
		im_menu.m_file.m_save.Enabled = False
		im_menu.m_file.m_refresh.Enabled = False
		im_menu.m_file.m_retrieve.Enabled = True
		im_menu.m_record.m_delete.Enabled = False
		tab_main.tabpage_main.cb_confirm.enabled = False
		tab_main.tabpage_main.cb_report.enabled = True	
		tab_main.tabpage_main.cb_export.enabled = True	
		tab_main.tabpage_main.cb_generate.enabled = False	
		tab_main.tabpage_result1.cb_generate1.enabled = False
		tab_main.tabpage_result2.cb_generate2.enabled = False
		tab_main.tabpage_result3.cb_generate3.enabled = False
		tab_main.tabpage_main.cb_void.enabled = False			
//		tab_main.tabpage_result1.cb_insert.enabled = False
//		tab_main.tabpage_result1.cb_delete1.enabled = False
//		tab_main.tabpage_result2.cb_delete2.enabled = False
//		tab_main.tabpage_result3.cb_delete3.enabled = False

		tab_main.tabpage_si.Enabled = True
		tab_main.tabpage_result1.Enabled = True
		tab_main.tabpage_result2.Enabled = True
		tab_main.tabpage_result3.Enabled = True

		idw_main.SetTabOrder("ord_type",0)
		idw_main.SetTabOrder("ord_date", 0)
		idw_main.SetTabOrder("count1_complete", 0)
		idw_main.SetTabOrder("count2_complete", 0)
		idw_main.SetTabOrder("count3_complete", 0)
		idw_main.SetTabOrder("complete_date", 0)
		idw_main.SetTabOrder("wh_code", 0)
		idw_main.SetTabOrder("priority", 0)
		idw_main.SetTabOrder("range_start", 0)
		idw_main.SetTabOrder("range_end", 0)
		idw_main.SetTabOrder("range_cnt", 0)
		idw_main.SetTabOrder("user_field1",0)
		idw_main.SetTabOrder("user_field2",0)
		idw_main.SetTabOrder("user_field3",0)
		idw_main.SetTabOrder("remark",0)

		idw_main.SetTabOrder("group",0)
		idw_main.SetTabOrder("class",0)
		idw_main.SetTabOrder("owner_id",0)		
		idw_main.Modify("b_owner.enabled='false'")		

// TAM 2017/06 PEVS-637 Lock Down Pandora Fields
	 	idw_main.SetTabOrder("user_field4", 0)
		idw_main.SetTabOrder("user_field5",0)
		idw_main.SetTabOrder("user_field6",0)

		idw_result1.SetTabOrder("sku",0)
		idw_result1.SetTabOrder("sysinvmatch",0)
		idw_result1.SetTabOrder("supp_code",0)
		idw_result1.SetTabOrder("l_code",0)
		idw_result1.SetTabOrder("country_of_origin",0)
		idw_result1.SetTabOrder("inventory_type",0)
		idw_result1.SetTabOrder("serial_no",0)
		idw_result1.SetTabOrder("lot_no",0)
		idw_result1.SetTabOrder("po_no",0)
		idw_result1.SetTabOrder("po_no2",0)
		idw_result1.SetTabOrder("container_ID",0)//GAP 11-02
		idw_result1.SetTabOrder("expiration_date",0)//GAP 11-02
		idw_result1.SetTabOrder("quantity",0)
		idw_result1.SetTabOrder("uom_1",0)
		idw_result1.SetTabOrder("grp",0)

		idw_result2.SetTabOrder("sku",0)
		idw_result2.SetTabOrder("sysinvmatch",0)
		idw_result2.SetTabOrder("supp_code",0)
		idw_result2.SetTabOrder("l_code",0)
		idw_result2.SetTabOrder("country_of_origin",0)
		idw_result2.SetTabOrder("inventory_type",0)
		idw_result2.SetTabOrder("serial_no",0)
		idw_result2.SetTabOrder("lot_no",0)
		idw_result2.SetTabOrder("po_no",0)
		idw_result2.SetTabOrder("po_no2",0)
		idw_result2.SetTabOrder("container_ID",0)//GAP 11-02
		idw_result2.SetTabOrder("expiration_date",0)//GAP 11-02
		idw_result2.SetTabOrder("quantity",0)
		idw_result2.SetTabOrder("uom_1",0)
		idw_result2.SetTabOrder("grp",0)

		idw_result3.SetTabOrder("sku",0)
		idw_result3.SetTabOrder("sysinvmatch",0)
		idw_result3.SetTabOrder("supp_code",0)
		idw_result3.SetTabOrder("l_code",0)
		idw_result3.SetTabOrder("country_of_origin",0)
		idw_result3.SetTabOrder("inventory_type",0)
		idw_result3.SetTabOrder("serial_no",0)
		idw_result3.SetTabOrder("lot_no",0)
		idw_result3.SetTabOrder("po_no",0)
		idw_result3.SetTabOrder("po_no2",0)
		idw_result3.SetTabOrder("container_ID",0)//GAP 11-02
		idw_result3.SetTabOrder("expiration_date",0)//GAP 11-02
		idw_result3.SetTabOrder("quantity",0)
		idw_result3.SetTabOrder("uom_1",0)
		idw_result3.SetTabOrder("grp",0)

		tab_main.tabpage_main.cb_stock_verification_report.enabled = false
		tab_main.tabpage_main.sle_start_loc.enabled = false
		tab_main.tabpage_main.sle_end_loc.enabled = false
		
		 tab_main.tabpage_result1.cbx_include_components1.visible = false
		 tab_main.tabpage_result2.cbx_include_components2.visible = false
		 tab_main.tabpage_result3.cbx_include_components3.visible = false
		
		
		//04/15 - PCONKL
		if ls_status = 'D' Then
			tab_main.tabpage_main.cb_confirm.enabled = true
		End If
		
		//02/16 - PCONKL - If project allows and user authorized, enable the Adjustments button
		If ib_Adjustments_Allowed Then
			tab_main.tabpage_main.cb_adjustments.enabled = True 
		Else
			tab_main.tabpage_main.cb_adjustments.enabled = False 
		End If

CASE "V"
	
	
		im_menu.m_file.m_save.Enabled = False	
		im_menu.m_file.m_refresh.Enabled = False
		im_menu.m_file.m_retrieve.Enabled = True
		im_menu.m_record.m_delete.Enabled = False
		tab_main.tabpage_main.cb_confirm.enabled = False
		tab_main.tabpage_main.cb_report.enabled = False	
		tab_main.tabpage_main.cb_export.enabled = False
		tab_main.tabpage_main.cb_generate.enabled = False	
		tab_main.tabpage_result1.cb_generate1.enabled = False
		tab_main.tabpage_result2.cb_generate2.enabled = False
		tab_main.tabpage_result3.cb_generate3.enabled = False
		tab_main.tabpage_main.cb_void.enabled = False			
//		tab_main.tabpage_result1.cb_insert.enabled = False
//		tab_main.tabpage_result1.cb_delete1.enabled = False
//		tab_main.tabpage_result2.cb_delete2.enabled = False
//		tab_main.tabpage_result3.cb_delete3.enabled = False

		tab_main.tabpage_si.Enabled = False
		tab_main.tabpage_result1.Enabled = False
		tab_main.tabpage_result2.Enabled = False
		tab_main.tabpage_result3.Enabled = False

		idw_main.SetTabOrder("ord_type",0)
		idw_main.SetTabOrder("ord_date", 0)
		idw_main.SetTabOrder("count1_complete", 0)
		idw_main.SetTabOrder("count2_complete", 0)
		idw_main.SetTabOrder("count3_complete", 0)
		idw_main.SetTabOrder("complete_date", 0)
		idw_main.SetTabOrder("wh_code", 0)
		idw_main.SetTabOrder("priority", 0)
		idw_main.SetTabOrder("range_start", 0)
		idw_main.SetTabOrder("range_end", 0)
		idw_main.SetTabOrder("range_cnt", 0)
		idw_main.SetTabOrder("user_field1",0)
		idw_main.SetTabOrder("user_field2",0)
		idw_main.SetTabOrder("user_field3",0)
		idw_main.SetTabOrder("remark",0)

		idw_main.SetTabOrder("group",0)
		idw_main.SetTabOrder("class",0)
		idw_main.SetTabOrder("owner_id",0)		
		idw_main.Modify("b_owner.enabled='false'")		

// TAM 2017/06 PEVS-637 Lock Down Pandora Fields
	 	idw_main.SetTabOrder("user_field4", 0)
		idw_main.SetTabOrder("user_field5",0)
		idw_main.SetTabOrder("user_field6",0)


		idw_result1.SetTabOrder("sku",0)
		idw_result1.SetTabOrder("sysinvmatch",0)
		idw_result1.SetTabOrder("supp_code",0)
		idw_result1.SetTabOrder("l_code",0)
		idw_result1.SetTabOrder("country_of_origin",0)
		idw_result1.SetTabOrder("inventory_type",0)
		idw_result1.SetTabOrder("serial_no",0)
		idw_result1.SetTabOrder("lot_no",0)
		idw_result1.SetTabOrder("po_no",0)
		idw_result1.SetTabOrder("po_no2",0)
		idw_result1.SetTabOrder("container_ID",0)//GAP 11-02
		idw_result1.SetTabOrder("expiration_date",0)//GAP 11-02
		idw_result1.SetTabOrder("quantity",0)
		idw_result1.SetTabOrder("uom_1",0)
		idw_result1.SetTabOrder("grp",0)

		idw_result2.SetTabOrder("sku",0)
		idw_result2.SetTabOrder("sysinvmatch",0)
		idw_result2.SetTabOrder("supp_code",0)
		idw_result2.SetTabOrder("l_code",0)
		idw_result2.SetTabOrder("country_of_origin",0)
		idw_result2.SetTabOrder("inventory_type",0)
		idw_result2.SetTabOrder("serial_no",0)
		idw_result2.SetTabOrder("lot_no",0)
		idw_result2.SetTabOrder("po_no",0)
		idw_result2.SetTabOrder("po_no2",0)
		idw_result2.SetTabOrder("container_ID",0)//GAP 11-02
		idw_result2.SetTabOrder("expiration_date",0)//GAP 11-02
		idw_result2.SetTabOrder("quantity",0)
		idw_result2.SetTabOrder("uom_1",0)
		idw_result2.SetTabOrder("grp",0)

		idw_result3.SetTabOrder("sku",0)
		idw_result3.SetTabOrder("sysinvmatch",0)
		idw_result3.SetTabOrder("supp_code",0)
		idw_result3.SetTabOrder("l_code",0)
		idw_result3.SetTabOrder("country_of_origin",0)
		idw_result3.SetTabOrder("inventory_type",0)
		idw_result3.SetTabOrder("serial_no",0)
		idw_result3.SetTabOrder("lot_no",0)
		idw_result3.SetTabOrder("po_no",0)
		idw_result3.SetTabOrder("po_no2",0)
		idw_result3.SetTabOrder("container_ID",0)//GAP 11-02
		idw_result3.SetTabOrder("expiration_date",0)//GAP 11-02
		idw_result3.SetTabOrder("quantity",0)
		idw_result3.SetTabOrder("uom_1",0)
		idw_result3.SetTabOrder("grp",0)

		tab_main.tabpage_main.cb_stock_verification_report.enabled = false
		tab_main.tabpage_main.sle_start_loc.enabled = false
		tab_main.tabpage_main.sle_end_loc.enabled = false
		//07-May-2017 :TAM - PEVS-513 -Stock Inventory Commodity Codes - Start
		tab_main.tabpage_main.select_commodity_t.visible = false
		tab_main.tabpage_main.cb_commodity.visible = false
		tab_main.tabpage_main.uo_commodity_code1.visible = false
		//07-May-2017 :TAM - PEVS-513 -Stock Inventory Commodity Codes - END


		 tab_main.tabpage_result1.cbx_include_components1.visible = false
		 tab_main.tabpage_result2.cbx_include_components2.visible = false
		 tab_main.tabpage_result3.cbx_include_components3.visible = false

End Choose

// LTK 20151022  Prevent Pandora from generating a count once it has been generated
if gs_project = 'PANDORA' then
	if status = "3" then
		tab_main.tabpage_result1.cb_generate1.enabled = FALSE
		tab_main.tabpage_result2.cb_generate2.enabled = FALSE
		tab_main.tabpage_result3.cb_generate3.enabled = FALSE
	elseif status = "2" then
		tab_main.tabpage_result1.cb_generate1.enabled = FALSE
		tab_main.tabpage_result2.cb_generate2.enabled = FALSE
	elseif status = "1" then
		tab_main.tabpage_result1.cb_generate1.enabled = FALSE
	end if
end if

//15-Feb-2017 :Madhu -SIMSPEVS-455 - Disabled Insert, Delete buttons on System Inventory tab -START
tab_main.tabpage_si.cb_si_insert.enabled = false
tab_main.tabpage_si.cb_si_delete.enabled = false
//15-Feb-2017 :Madhu -SIMSPEVS-455 - Disabled Insert, Delete buttons on System Inventory tab -END

// 04/15 - PCONKL - Mobile validations
wf_check_status_Mobile()

// 2017/12/04 - TAM - Serial Number validations
wf_check_status_Serial_Numbers()
// 2017/12/04 - TAM - Serial Number validations
wf_check_status_system_generated()

//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count - START
wf_check_status_container() 
wf_change_color_of_discrepancy_serials()
wf_reveal_matched_container_on_count3()
//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count - END

//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
//CC Serial Reconciliation cannot set to VOID this type of cycle count

if tab_main.tabpage_main.dw_main.GetItemString(1, 'ord_type') = 'F' then
	idw_serial_numbers.visible = True
	tab_main.tabpage_main.cb_void.enabled = False
end if

f_method_trace_special( gs_project, this.ClassName() , 'End check status '  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

Return
end subroutine

public subroutine setcounttab (integer _tab);// setCountTab( integer _tab )
iiCountTab = _tab

end subroutine

public function integer getcounttab ();// integer = getCountTab()
return iiCountTab

end function

public function integer doprintcountsheets ();// integer = doPrintCountSheets(  )

// pvh - 06/08/06 - ccmods
string ls_order
String ls_lcode
string ls_wh_code
string ls_setting
String ls_order_type
Long ll_retrows
Long i, j, k
Long ll_tot
Long ll_empty
Datetime ldt_order
datastore dsPrintCountSheet
datastore dsPrintCountSheetPandora // 12/14/2010 ujh: Simplify CC report
String ls_user_field14, ls_hold_sku // 12/14/2010 ujh: Simplify CC report
string datasource
string printEmpty
boolean lbPrintOneSkuPage = false

long test
long index, max
long nullvalue
string lsAltSKU, lsLastSku, lsCurrentSku

setNull( nullvalue )

f_method_trace_special( gs_project, this.ClassName() , 'Start PrintCountSheet ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

If ib_changed Then
	MessageBox(is_title, "Please save changes first!")
	Return -1
End If

setBlindKnownPrt(  )

f_method_trace_special( gs_project, this.ClassName() , 'Process PrintCountSheet current Tab is: '+ String(getCountTab()) ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

choose case getCountTab()
	case 3  // tab results 1
		//JXlim 06/11/2010 For Phoenix Brands
		IF gs_project = 'PHXBRANDS' THEN			
			datasource = 'd_cc_count_sheet1_phx'
			printEmpty = 'cc_result_1'
		ELSE
			/* 07/06/2010 ujhall: 01 of 04 Empty locations on Cycle Count Screen:  
				Use datawindow object that unions back the rows where SKU = empty  
				Thee new datawindow objects were created  d_cc_count_sheet#_Pandora where # = 1,2,3 */
			If upper(gs_project) = 'PANDORA' then
				datasource = 'd_cc_count_sheet1_pandora'
				dsPrintCountSheetPandora =   f_datastoreFactory(  'd_cc_count_sheet1_pandora_simple' )  // 12/14/2010 ujh: Simple
			else
				If left(upper(gs_project),4) = 'NIKE' then
					datasource = 'd_cc_count_sheet1_nike'   //MEA - 02/12 - Added nike count sheet
				else
					
					datasource = 'd_cc_count_sheet1'
			
				end if
			end if
			printEmpty = 'cc_result_1'
		END IF
		//JXLIM 06/11/2010 end of PHX enhancement.
	case 4 // tab results 2
			// 07/06/2010 ujhall: 02 of 04 Empty locations on Cycle Count Screen:
			If upper(gs_project) = 'PANDORA' then
				datasource = 'd_cc_count_sheet2_pandora'
				dsPrintCountSheetPandora =   f_datastoreFactory(  'd_cc_count_sheet2_pandora_simple' )  // 12/14/2010 ujh: Simple
			else
				If left(upper(gs_project),4) = 'NIKE' then
					datasource = 'd_cc_count_sheet2_nike'  //MEA - 02/12 - Added nike count sheet
				else
					datasource = 'd_cc_count_sheet2'
				end if
			end if
		printEmpty = 'cc_result_2'
	case 5 // tab results 3
			// 07/06/2010 ujhall: 03 of 04 Empty locations on Cycle Count Screen:
			If upper(gs_project) = 'PANDORA' then
				datasource = 'd_cc_count_sheet3_pandora'
				dsPrintCountSheetPandora =   f_datastoreFactory(  'd_cc_count_sheet3_pandora_simple' )  // 12/14/2010 ujh: Simple
			else
				If left(upper(gs_project),4) = 'NIKE' then
					datasource = 'd_cc_count_sheet3_nike'   //MEA - 02/12 - Added nike count sheet
				else
					datasource = 'd_cc_count_sheet3'
				end if
			end if
		printEmpty = 'cc_result_3'
end choose

dsPrintCountSheet = f_datastoreFactory( datasource )
dsPrintCountSheet.setSort( getSortOrder() )

If upper(gs_project) = 'NIKE-SG' OR upper(gs_project) = 'NIKE-MY'  Then
	integer li_per_page, li_current_page, li_per_page_count
	choose case getCountTab()
		case 3  
			li_per_page = long(tab_main.tabpage_result1.em_limit_loc_print_1.text)
		case 4  
			li_per_page = long(tab_main.tabpage_result2.em_limit_loc_print_2.text)
		case 5 
			li_per_page = long(tab_main.tabpage_result3.em_limit_loc_print_3.text)			
	end choose
	
	if li_per_page = 9999 then lbPrintOneSkuPage = true

End if 

string ls_last_l_code

li_current_page = 1
li_per_page_count = 0

ls_order = idw_main.GetItemString(1, "cc_no")
ll_empty = i_nwarehouse.of_print_empty( ls_order , printEmpty )
If dsPrintCountSheet.Retrieve(ls_order) > 0 or ll_empty > 0 Then
	ls_wh_code = idw_main.GetItemString(1,"wh_code")	
   	ls_order_type= idw_main.GetItemString(1,"ord_type")
	//IF upper(ls_order_type) = 'L' THEN
	IF upper(ls_order_type) = 'L' or upper(ls_order_type) = 'B' THEN
		ll_tot=dsPrintCountSheet.Rowcount()
		ldt_order = idw_main.object.ord_date[1]
		IF ll_empty > 0 THEN
			FOR i =1 TO i_nwarehouse.ids_print_em.Rowcount()		
				
				ll_tot =dsPrintCountSheet.InsertRow(0)
			  	ls_lcode=i_nwarehouse.ids_print_em.object.l_code[i] 
				 test = getEmptyLineNumberForLoc( ls_lcode )  
				dsPrintCountSheet.object.line_item_no[ll_tot]= getEmptyLineNumberForLoc( ls_lcode ) 
			  	dsPrintCountSheet.object.l_code[ll_tot]=ls_lcode
			  	dsPrintCountSheet.object.cc_no[ll_tot]= ls_order
			  	dsPrintCountSheet.object.project_id[ll_tot]= gs_project	
			  	dsPrintCountSheet.object.wh_code[ll_tot]= ls_wh_code
			  	dsPrintCountSheet.object.ord_type[ll_tot]= ls_order_type
			  	dsPrintCountSheet.object.ord_date[ll_tot]= ldt_order
			  	dsPrintCountSheet.object.supp_code[ll_tot]='-'
			  	dsPrintCountSheet.object.description[ll_tot]='-'
			  	dsPrintCountSheet.object.lot_no[ll_tot]='-'
			  	dsPrintCountSheet.object.serial_no[ll_tot]='-'
			  	dsPrintCountSheet.object.inv_type_desc[ll_tot]='-'
			  	dsPrintCountSheet.object.po_no[ll_tot]='-'
			  	dsPrintCountSheet.object.po_no2[ll_tot]='-'
			  	dsPrintCountSheet.object.container_id[ll_tot]='-'	  
			  	dsPrintCountSheet.object.expiration_date[ll_tot]= DateTime( date('12/31/2999'), time( '00:00:00') )	//GAP 11-02		
				  
			NEXT
		end if		
	end if
	max = dsPrintCountSheet.rowcount()
	
	If upper(gs_project) = 'NIKE-SG' OR upper(gs_project) = 'NIKE-MY'  Then
		if lbPrintOneSkuPage then
			dsPrintCountSheet.SetSort("sku A l_code A")
		end if
		
		dsPrintCountSheet.Sort()
	End IF
	 // Begin - S57097- Dinesh - 07/19/2021- NYCSP - Order cycle count
	If upper(gs_project) = 'NYCSP' then 
		dsPrintCountSheet.SetSort('l_code,Inventory_Type d,sku')
		dsPrintCountSheet.Sort()
	End IF
	 // End - S57097- Dinesh - 07/19/2021- NYCSP - Order cycle count
	for index = 1 to max
		
	
		ls_lcode = dsPrintCountSheet.object.l_code[ index ]
		
		// 07/06/2010 ujhall: 04 of 04  Empty locations on Cycle Count Screen:  Note:
		if upper(gs_project) = 'PANDORA' then
			/* skip the  possible 'continue' that was originally here.  I don't think it could have done anything in the original because
			  no 'Empty' SKUs were getting retrieved.  Must avoid it now that Pandora wants to see those "Empty" SKUs */
		else
			if dsPrintCountSheet.object.sku[ index ]  = 'EMPTY' then continue
		end if
		if getBlindKnownPrt() = 'K' then
			//dsPrintCountSheet.object.system_quantity[ index ] = getSysQtyForLine( dsPrintCountSheet.object.line_item_no[ index] )
			dsPrintCountSheet.object.system_quantity[ index ] = getSysQtyForLine( getCountTab(), dsPrintCountSheet.object.line_item_no[ index] )
		else
			dsPrintCountSheet.object.system_quantity[ index ] = nullvalue
		end if
		
		if li_per_page > 0 then
			
			if lbPrintOneSkuPage then
				
//				lsCurrentSku = dsPrintCountSheet.GetItemString( index, "sku")
				
//				if lsLastSku <> lsCurrentSku then
					li_current_page = li_current_page + 1
//					lsLastSku = lsCurrentSku
//				end if
				
			else

				if  ls_last_l_code <> ls_lcode then
					li_per_page_count = li_per_page_count + 1
					
					ls_last_l_code = ls_lcode
						
					 if li_per_page_count > li_per_page then
						li_per_page_count = 1
						li_current_page = li_current_page + 1
					end if
				end if	
				
			end if
				
			dsPrintCountSheet.object.pagebreak[index] = li_current_page

		end if
		
	next
	
	
//	dsPrintCountSheet.GroupCalc()
	
	// 12/14/2010 ujh: Simple; If pandora, order so sku and location can be grouped
	If upper(gs_project) = 'PANDORA' then
		//2011/01/04 dsPrintCountSheet.setSort( "SKU asc, 'l_code asc ")
		dsPrintCountSheet.setSort( "l_code, SKU, l_code" )
	else
		dsPrintCountSheet.setSort( getSortOrder() )
	end if
	dsPrintCountSheet.Sort()	
	dsPrintCountSheet.GroupCalc()
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// 12/14/2010 ujh: Simple
	if upper(gs_Project) = 'PANDORA' then
		dsPrintCountSheetPandora.InsertRow(0)  // Insert row to get header information
		dsPrintCountSheetPandora.SetItem(1,"cc_no",dsPrintCountSheet.GetItemString(1,"cc_no") )
		dsPrintCountSheetPandora.SetItem(1,"Ord_type",dsPrintCountSheet.GetItemString(1,"ord_type") )  
		dsPrintCountSheetPandora.SetItem(1,"Ord_Date",dsPrintCountSheet.GetItemDateTime(1,"Ord_Date") )
		dsPrintCountSheetPandora.SetItem(1,"WH_Code",dsPrintCountSheet.GetItemString(1,"WH_Code") )  
		
		For k = 1 to dsPrintCountSheet.RowCount()
			if k > 1  Then  // if this is the first row, skip testing against previous row
		// If the previous row's location(j variable) and SKU are same as current (k variable), add the qty to previous and don't create new row
				If  (Trim(dsPrintCountSheetPandora.GetItemString(j,"l_code")) = Trim(dsPrintCountSheet.GetItemString(k,"l_code")) &
						and  ls_hold_sku =Trim( dsPrintCountSheet.GetItemString(k,"SKU")))  Then
				 	dsPrintCountSheetPandora.SetItem(j,"System_quantity", dsPrintCountSheetPandora.GetItemNumber(j,"System_quantity") + dsPrintCountSheet.GetItemNumber(k ,"System_quantity"))
					Continue
				end if
			End if
			j ++ // increment counter for the summary print datawindow
			If j <> 1  then  // Insert except for the first row.  The first row has already been inserted.
				dsPrintCountSheetPandora.InsertRow(j)
				//14-Mar-2018 :Madhu S16312 - Populate Header Fields on Print Sheet - START
				dsPrintCountSheetPandora.SetItem(j,"cc_no",dsPrintCountSheet.GetItemString(1,"cc_no") )
				dsPrintCountSheetPandora.SetItem(j,"Ord_type",dsPrintCountSheet.GetItemString(1,"ord_type") )  
				dsPrintCountSheetPandora.SetItem(j,"Ord_Date",dsPrintCountSheet.GetItemDateTime(1,"Ord_Date") )
				dsPrintCountSheetPandora.SetItem(j,"WH_Code",dsPrintCountSheet.GetItemString(1,"WH_Code") ) 
				//14-Mar-2018 :Madhu S16312 - Populate Header Fields on Print Sheet - END
			End if
			
			dsPrintCountSheetPandora.SetItem(j,"line_item_no", j )  // For now overwrite line_item_number
			dsPrintCountSheetPandora.SetItem(j,"l_code",dsPrintCountSheet.GetItemString(k,"l_code") )
			// dts - 1/4/11 - allow for null alt_sku without null-ing the sku...
			lsAltSku = dsPrintCountSheet.GetItemString(k,"Alternate_SKU")
			if isNull(lsAltSku) then lsAltSku = ''
			dsPrintCountSheetPandora.SetItem(j, "SKU", dsPrintCountSheet.GetItemString(k,"SKU") + "~r"+ lsAltSku)
			ls_hold_sku = trim(dsPrintCountSheet.GetItemString(k,"SKU"))
			ls_user_field14 = dsPrintCountSheet.GetItemString(k,"User_Field14")
			If isnull(ls_user_field14) then 
				ls_user_field14 = "" 
			end if
			dsPrintCountSheetPandora.SetItem(j,"Description",dsPrintCountSheet.GetItemString(k,"Description")  &
					+ ls_user_field14 )
			dsPrintCountSheetPandora.SetItem(j,"System_quantity",dsPrintCountSheet.GetItemNumber(k,"System_quantity") )
// TAM 6/2017 - SIMSPEVS-420 - Added PO_NO(Project( to the report
			dsPrintCountSheetPandora.SetItem(j,"Po_No",dsPrintCountSheet.GetItemString(k,"Po_No") )

		next
		OpenWithParm(w_dw_print_options,dsPrintCountSheetPandora)
   		
	else
		OpenWithParm(w_dw_print_options,dsPrintCountSheet)
	end if
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Else
	MessageBox(is_title, "Nothing to print!")
End If	

f_method_trace_special( gs_project, this.ClassName() , 'End PrintCountSheet ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

return 0


end function

public function boolean dovalidskuquantitycheck (ref datawindow _dw);// integer = doValidSkuQuantityCheck( ref datawindow _dw )
int index
int max
string sku, ls_sku, ls_loc, lsFind
decimal{5} quantity
integer tabpage
long llFindRow
dwitemstatus		lStatus

tabpage = getTabPageForDw( _dw )

max = _dw.rowcount()
for index = 1 to max
	lStatus = _dw.getItemStatus( index, 0, primary! )
	choose case lStatus
		case New!, NotModified!
			continue
	end choose	
	sku = Upper( _dw.object.sku[ index ] )
	quantity = _dw.object.quantity[ index ]
	if quantity > 0 and sku = 'EMPTY' then
		messagebox( "Cycle Counts","You can not have a sku labeled ~'EMPTY~'' and a quantity > 0!",stopsign! )
		tab_main.selecttab( tabpage )
		f_setfocus(_dw, index , "sku")
		return true
	end if
	
next

//15-JUNE-2018 :Madhu S19286 - DE4796 Up count from Non existing qty - START
//shouldn't add same SKU & Loc for Up Count records
For index = 1 to max

	IF upper(_dw.object.up_count_zero[index]) ='Y' THEN
		
		ls_sku = _dw.object.sku[index]
		ls_loc = _dw.object.l_code[index]
		
		lsFind ="sku='"+ls_sku+"' and l_code='"+ls_loc+"' and up_count_zero ='N'"
		llFindRow =_dw.find(lsFind, 1, _dw.rowcount())
		
		If llFindRow > 0 Then
			messagebox( "Cycle Counts","You shouldn't add existing SKU# "+trim(ls_sku) +" and Location# " +trim(ls_loc) +" ~n~rFor UP Count from Non-Existing Qty!",stopsign! )
			tab_main.selecttab( tabpage )
			f_setfocus(_dw, index , "sku")
			return true
		End If
	END IF
	
Next

//15-JUNE-2018 :Madhu S19286 -DE4796 Up count from Non existing qty - END

return false

end function

public function integer gettabpagefordw (ref datawindow _dw);// integer = getTabpageForDw( ref datawindow _dw )

choose case _dw.dataobject
	case 'd_cc_result1'
		return 3
	case 'd_cc_result2'
		return 4
	case 'd_cc_result3'
		return 5
end choose

return 3 // default

end function

public function boolean doduplicatecheck (ref datawindow _dw, integer arow);// boolean doDuplicateCheck( ref datawindow, int arow )
//
//
string sku
string loc
string inventoryType
string serialnbr
string lot
string Supplier
string PO
string PO2
string COO
string containerid
string sortedby
string filterfor
boolean returnCode
datetime ldtExpirationDate
long owner
string ro_no		// LTK 20150310 Removed ro_no

//
returnCode = false

// Grab the data to test

 sku = _dw.GetItemString( arow, "sku")
 Supplier = _dw.GetItemString( arow, "supp_code")
 owner = _dw.GetItemNumber( arow, "owner_id")
 loc = _dw.GetItemString( arow, "l_code")
 serialnbr = _dw.GetItemString( arow, "serial_no")
 lot = _dw.GetItemstring( arow, "lot_no")	
 po = _dw.GetItemstring( arow, "po_no")
 po2 = _dw.GetItemstring( arow, "po_no2")
 containerid = _dw.GetItemstring( arow, "container_id")	
 ldtExpirationDate = _dw.GetItemDateTime( arow, "expiration_date")
 coo = _dw.GetItemstring( arow, "country_of_origin")
 inventoryType = _dw.GetItemstring( arow, "inventory_type")	
 ro_No = _dw.GetItemstring( arow, "ro_no")	

// can't have nulls

if isnull(serialnbr ) then serialnbr = '-'
if isnull( lot ) then lot = '-'
if isnull( po ) then po = '-'
if isnull( po2 ) then po2 = '-'
if isnull( containerid ) then containerid = '-'
if isnull(inventoryType ) then inventoryType = '-'
if isnull( supplier ) then supplier = '-'
if isnull( COO ) then COO = '-'
if isnull( supplier ) then supplier = '-'
if isnull( ro_no ) then ro_no = '-'

// build the filter string
filterFor   = "Trim(sku) = ~'" + sku + "~' and  Trim(l_code)  = ~'" + loc + "~' and Trim(inventory_type) = ~'" +  inventoryType + "~'"
filterFor += " and serial_no = ~'" + serialnbr + "~' and lot_no = ~'" + lot + "~' and po_no = ~'" + po + "~'"
filterFor += " and po_no2 = ~'" + po2 + "~' and supp_code = ~'" + supplier + "~'"
filterFor += " and country_of_origin = ~'" + COO + "~'"
if owner > 0 then filterFor += " and owner_id = " +String(  owner ) 
filterFor += " and container_id = ~'" +  containerid  + "~'"
filterFor += " and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldtExpirationDate,'mm/dd/yyyy hh:mm')  + "~'"
filterFor += " and ro_no = ~'" +  ro_no  + "~'"

_dw.setfilter( filterFor )
_dw.filter()

if _dw.rowcount() > 1 then returnCode = true

_dw.setfilter( "" )
_dw.filter()
_dw.setsort( getSortorder() )
_dw.sort()

return returnCode

end function

public function integer doaccepttext ();// integer = doAcceptText().

If idw_main.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	return -1
End If

If idw_result1.AcceptText() = -1 Then
	tab_main.SelectTab(3) 
	idw_result1.SetFocus()
	return -1
End If

If idw_result2.AcceptText() = -1 Then
	tab_main.SelectTab(4) 
	idw_result2.SetFocus()
	return -1
End If

If idw_result3.AcceptText() = -1 Then
	tab_main.SelectTab(5) 
	idw_result3.SetFocus()
	return -1
End If

//TAM 2017/11 3PL CC - Added an new Serial Numbers Tab
If idw_serial_numbers.AcceptText() = -1 Then
	tab_main.SelectTab(8) 
	idw_serial_numbers.SetFocus()
	return -1
End If

//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count
If idw_cc_container.AcceptText() = -1 Then
	tab_main.SelectTab(9) 
	idw_cc_container.SetFocus()
	return -1
End If

return 0

end function

public function integer dorequiredfieldcheck ();// int = doRequiredFieldCheck()

// Check required fields for master record

If f_check_required(is_title, idw_main) = -1 Then
	tab_main.SelectTab(1) 
	return -1
End If

// Check required fields for count resutls

If f_check_required(is_title, idw_result1) = -1 Then
	tab_main.SelectTab(3) 
	return -1
End If

If f_check_required(is_title, idw_result2) = -1 Then
	tab_main.SelectTab(4) 
	return -1
End If

If f_check_required(is_title, idw_result1) = -1 Then
	tab_main.SelectTab(5) 
	return -1
End If

return 0

end function

public subroutine setdwredraw (boolean _switch);// setDWRedraw( boolean _switch )

idw_result1.setredraw( _switch )
idw_result2.setredraw( _switch )
idw_result3.setredraw( _switch )

end subroutine

public function integer dovalidate (ref datawindow _dw);// int = DoValidate( ref datawindow _dw  )

Integer 				index
integer 				max
string 				sku
string 				supplier
string 				location
string 				filterThis

boolean 			foundError
integer				dwtabpage		
string				findThis
long					foundRow
dwitemstatus		lStatus

dwTabPage = getTabpageForDw(  _dw )

founderror = false

_dw.setredraw( false )

max = _dw.RowCount()
if max = 0 then return 0
For index = 1 to max 
	lStatus = _dw.getItemStatus( index, 0, primary! )
	choose case lStatus
		case New!
			// change the status to newmodified to save the row.
			_dw.setItemStatus( index, 0, primary!, NewModified! )
			continue
		case NotModified!
			continue
	end choose
	sku = _dw.object.sku[ index ]
	
	
	//MikeA - DE15068 - SIMS QAT DEFECT - Issue voiding / Deleting CC for an Empty location count
	
	if Upper( sku ) = 'EMPTY' then 
		
		if _dw.Find("sku <> 'EMPTY' and  line_item_no = "+string( _dw.object.line_item_no[ index ]), 1, _dw.RowCount()) > 1 then
			MessageBox(is_title, "There cannot be a count for EMPTY and a sku for the same line item no!")
			tab_main.selecttab( dwTabPage )
			f_setfocus(_dw, index , "sku")
			foundError = true
			exit
		end if
		
		continue
	end if
	
	supplier = _dw.object.supp_code[ index ]
	location = Trim( _dw.object.l_code[ index ] )
	findThis = "l_code = ~'" + location + "~'"

	IF 	i_nwarehouse.of_item_master(gs_project, sku , supplier ) <> 1 THEN	
		MessageBox(is_title, "Invalid SKU, please re-enter!") 
		tab_main.selecttab( dwTabPage )
		f_setfocus(_dw, index , "sku")
		foundError = true
		exit
	END IF

	if _dw.object.quantity[ index ] > 0 then 
		foundrow = idsLocations.find( 	findThis, 1, idsLocations.rowcount() )
		if foundRow <= 0 then
			// dts 08/10/10 for Pandora, need to allow 'ALLOCATED' to be a valid location on the cycle count.
			//if not (gs_project = 'PANDORA' and upper(findthis) = 'ALLOCATED') then
			//if not (gs_project = 'PANDORA' and upper(Location) = 'ALLOCATED') then
			//TAM 2016/12/16  for Pandora, need to allow 'NO_COUNT' to also be a valid location on the cycle count.
//			if not (Upper(gs_project) = 'PANDORA' and Left(upper(Location), 9) = 'ALLOCATED') then	// LTK 20140807  Pandora #882 change
			if not (Upper(gs_project) = 'PANDORA' and (Left(upper(Location), 9) = 'ALLOCATED' or upper(Location) = 'NO_COUNT' )) then	// LTK 20140807  Pandora #882 change
				MessageBox(is_title, "Invalid location, please re-enter!") 
				tab_main.selecttab( dwTabPage )
				f_setfocus( _dw, index, "l_code")	
				foundError = true
				exit
			end if
		end if
	end if
	
	SetMicroHelp("Duplicate Row Check For Row : " + string( index ) + "...")	
	if doDuplicateCheck( _dw, index  ) then
		Messagebox(is_title,"Found duplicates in count data, please check!",StopSign!)
		tab_main.selecttab( dwTabPage )
		f_setfocus(_dw, index, "sku")
		foundError = true
		exit
	end if	
	
next
_dw.setredraw( true )

if foundError then return -1
return 0

end function

public subroutine setsortorder (string _value);// setSortOrder( string _value )
isSortOrder = _value

end subroutine

public function string getsortorder ();// string = getSortOrder()
return isSortOrder

end function

public subroutine setwarehouse (string _value);// setWarehouse( string _value )
isWarehouse = _value

end subroutine

public function string getwarehouse ();// string = getWarehouse()
return isWarehouse

end function

public subroutine setblindknown ();// setBlindKnown(  )

string findthis
long	foundrow
string value
string warehouse 

if NOT isValid( g.ids_project_warehouse ) then return
if isNull( getWarehouse() ) or len( getWarehouse() ) = 0 then return

isBlindKnownFlag = 'K'  // Known

// get the warehouse row...
warehouse = getWarehouse()
foundrow = g.of_project_warehouse( gs_project, warehouse )
if foundRow <= 0 then return
//	messagebox( is_title, "Error Setting Warehouse Screen Indicators!~r~nUsing Default.",stopsign! )
//	return
//end if
value =  g.ids_project_warehouse.object.blindflag[ foundRow ]
if isNull( value ) or len( value ) = 0 then value = 'K' // default
isBlindKnownFlag = value
setBlindMessage( value )


end subroutine

public subroutine setblindknownprt ();// setBlindKnownPrt(  )

string findthis
long	foundrow
string value
string warehouse 

if NOT isValid( g.ids_project_warehouse ) then return
if isNull( getWarehouse() ) or len( getWarehouse() ) = 0 then return

isBlindKnownPrtFlag = 'K'  // Known

// get the warehouse row....
warehouse = getWarehouse()
foundrow = g.of_project_warehouse( gs_project, warehouse )
if foundRow <= 0 then return
//	messagebox( is_title, "Error Setting Warehouse Print Indicators!~r~nUsing Default.",stopsign! )
//	return	
//end if
value =  g.ids_project_warehouse.object.prtblindflag[ foundRow ]
if isNull( value ) or len( value ) = 0 then value = 'K' // default
isBlindKnownPrtFlag = value
setPrtBlindMessage( value )

end subroutine

public subroutine setblindmessage (string _value);// setBlindMessage( string _value )
string msg

choose case _value
	case 'K'
		IF Upper(gs_project) = 'CHINASIMS' THEN
			msg = " ????"
		ELSE		
			msg = " Known Quatities"
		END IF
	case 'B'
		msg = " Blind Quatities"
	case else
		msg = '' // blank it out
end choose

tab_main.tabpage_si.st_msg1.text = msg


end subroutine

public subroutine setprtblindmessage (string _value);// setPrtBlindMessage( string _value )

string msg

choose case _value
	case 'K'
		IF Upper(gs_project) = 'CHINASIMS' THEN
			msg = " ????"
		ELSE		
			msg = " Known Quantities"
		END IF
	case 'B'
		msg = " Blind Quantities"
	case else
		msg = '' // blank it out
end choose

tab_main.tabpage_si.st_msg2.text = msg


end subroutine

public subroutine setcountdiff ();// setCountDiff(  )

string findthis
long	foundrow
string value
string msg
string warehouse

isCountDiff = 'N'  

// get the warehouse row...
warehouse = getWarehouse()
foundrow = g.of_project_warehouse( gs_project, warehouse )
if foundRow <= 0 then return

value =  g.ids_project_warehouse.object.countdiff[ foundRow ]
if isNull( value ) or len( value ) = 0 then value = 'N' // default
isCountDiff = value

if Upper(gs_project) = 'CHINASIMS' then

	msg = '?'
	if value = 'Y' then
		msg = '?'
	end if
	
	
else
	

	msg = 'Off'
	if value = 'Y' then
		msg = 'On'
	end if

end if 
tab_main.tabpage_result2.st_c2_msg.text = msg
tab_main.tabpage_result3.st_c3_msg.text = msg



end subroutine

public function string getblindknown ();// string = getBlindKnown()
return isBlindKnownFlag

end function

public function string getcountdiff ();// string = getCountDiff()
return isCountDiff

end function

public subroutine dodisplaysysqty (boolean _flag);// doDisplaySysQty()

if NOT isValid( idw_si ) then return

if idw_si.rowcount() > 0 then setSystemInventoryDisplay( _flag )

setCountSheetDisplay( _flag )

if NOT _flag then return

if idw_result1.rowcount() > 0 then setSysQuantityonCount( idw_result1, _flag )
if idw_result2.rowcount() > 0 then setSysQuantityonCount( idw_result2, _flag )
if idw_result3.rowcount() > 0 then setSysQuantityonCount( idw_result3, _flag )




	






end subroutine

public subroutine docountdiffrefresh (ref datawindow _dw);//// doCountDiffRefresh( datawindow _dw )
int index
int max
string selectall = 'Select All'
string deselectall = 'De-Select All'
string whichone
Long	llSysInvLine
Boolean lb_UserModified

IF Upper(gs_project) = 'CHINASIMS' THEN
	selectall = '????'
	deselectall = '????'
END IF		

if NOT isValid( _dw ) then return
max = _dw.rowcount()
whichone = selectall

// 1/21/2011; David C; Check if user modified the data on the DW before setting the status to NotModified below
// 04/15 - PCONKL - fix bug where count rec has SKU not in Sys Inventory

if _dw.ModifiedCount ( ) > 0 or _dw.DeletedCount ( ) > 0 then lb_UserModified = true

for index = 1 to max
	
	llSysInvLine = getSysInvRow( Long( _dw.object.line_item_no[ index ] ) )
	If llSysInvLine > 0 Then
		
		//if idw_si.object.quantity[ llSysInvLine ] = _dw.object.quantity[ index ] then
		if _dw.object.sysquantity[ index ] = _dw.object.quantity[ index ] then		// Set match cbx based on the Sys Inv Qty on the count tab
			_dw.object.sysinvmatch[ index ] = 'Y'
			whichone = deselectall
		end if
		
	End If
	
	if not lb_UserModified then
		_dw.setItemStatus( index, 0, primary!, NotModified! )
	end if
	
next

choose case getcountTab()
	case 3
		tab_main.tabpage_result1.cb_selectall1.text = whichone
	case 4
		tab_main.tabpage_result2.cb_selectall2.text = whichone
	case 5
		tab_main.tabpage_result3.cb_selectall3.text = whichone
end choose


end subroutine

public subroutine setsysquantityoncount (ref datawindow _dw, boolean _flag);// setSysQuantityonCount( ref datawindow _dw, boolean _flag )

long index, llSYsInvRow
long max

Boolean lb_UserModified

max = _dw.rowcount()

// 1/21/2011; David C; Check if user modified the data on the DW before setting the status to NotModified below
if _dw.ModifiedCount ( ) > 0 or _dw.DeletedCount ( ) > 0 then lb_UserModified = true

//BCR 18-OCT-2011: An ancient bug finally got caught here!
// 04/15 - PCONKL - fixed bug when there is a SKU on the count that doesn't exist on the SYS Inventory
IF max >= 1 THEN

	for index = 1 to max
		
//		llSYsInvRow = getSysInvRow( Long( _dw.object.line_item_no[ index ] ) )
//		If llSysInvRow > 0 Then
//			
//			// LTK 20150508  Now calculating system inventory
//			//_dw.object.sysquantity[ index ] = idw_si.object.quantity[llSYsInvRow]
//			_dw.object.sysquantity[ index ] = Round( wf_sum_si_quantity( wf_find_corresponding_si_rows( _dw, index ) ), 5 )
//
//		Else
//			_dw.object.sysquantity[ index ] = 0
//		End If

		// LTK 20150508  Now calculating system inventory
		_dw.object.sysquantity[ index ] = Round( wf_sum_si_quantity( wf_find_corresponding_si_rows( _dw, index, FALSE ) ), 5 )

		
		//_dw.object.sysquantity[ index ] = idw_si.object.quantity[ getSysInvRow( Long( _dw.object.line_item_no[ index ] ) ) ]
		
		if not lb_UserModified then
			_dw.setItemStatus( index, 0, primary!, NotModified! )
		end if
		
	next
	
END IF

end subroutine

public function string getblindknownprt ();// string = getBlindKnownPrt(  )
return isBlindKnownPrtFlag


end function

public subroutine setordertype (string _value);// setOrderType( string _value )

isOrderType = Trim( Upper(  _value ) )

end subroutine

public function string getordertype ();// string = getOrderType()
return isOrderType

end function

public function integer doupdateitemmastercompletedate (string _sku, string _supplier, datetime _completedate);// doUpdateItemMasterCompleteDate( string _sku, string _supplier, datetime _completeDate )

long arow

if GetUpdatedSku( _sku , _supplier ) then return success // sku already updated

arow = idsItemMaster.retrieve( gs_project, _sku, _supplier )
if arow <= 0 then return failure

idsItemMaster.object.last_cycle_cnt_date[ arow ] = _completeDate
idsItemMaster.object.last_cc_no[ arow ] = getCCOrder()

if idsItemMaster.update() <> 1 then return failure

SetUpdatedSku( _sku , _supplier )  

return success


end function

public function boolean getupdatedsku (string _sku, string _supplier);// boolean = getUpdatedSku( string _sku, string _supplier )

// check to see if the sku and supplier have already been update with the complete date
// return true if they have

long index
long max
boolean foundit

max = upperbound( isSkuArray )
if isNull( Max ) or max = 0 then return false  // if it isn't here, it wasn't done

for index = 1 to max
	if _sku = isSkuArray[ index ] then
		foundit = true
		exit
	end if
next
if NOT foundit then return false

foundit = false
// if the sku was found check the supplier
for index = 1 to max
	if _supplier = isSupplierArray[ index ] then
		foundit = true
		exit
	end if
next
if NOT foundit then return false
return true



end function

public subroutine setupdatedsku (string _sku, string _supplier);// setUpdatedSku( string _sku, string _supplier )

long max

max = upperbound( isSkuArray )
if isNull( max ) then max = 0

max++
isSkuArray[ max ] = _sku
isSupplierArray[ max ] = _supplier

return

end subroutine

public subroutine docomparesysinv ();// doCompareSysInv()

/*
 	Compare the curent system inventory with a "Fresh" regenerate. 
	If there are differences, display a message and prompt to produce a decrepancy report.
*/

/* 2012-03-20   Ermine Todd
	Added container_id to the find parameter to resolve bug with discrepency reports
*/

string 		apploc
string 		sysloc
string		appsku
long 			insertrow
long 			Index
long			max
long 			foundrow
string 		findLine = 'line_item_no = '
long			lineItem
string 		findthis 
decimal 	sysQty, sysComponentQty
decimal 	appQty, appComponentQty
datastore 	dsSys
datastore 	dsDecrepancy
boolean 	decrepancy
string 		Description
str_parms lstrparms
// -=-
string _and = "and "
string quote = "' "
string fsku = "sku = '"
string floc = "l_code = '"
string fsup = "supp_code = '"
string finvtype = "inventory_type = '"
string fserial = "serial_no = '"
string flot_no = "lot_no = '"
string fcoo = "country_of_origin = '"
string fqty = "quantity = "
string fowner = "owner_id = "
//string fro_no = "ro_no = '"
string fcon_id = "container_id = '"

string fqtyvalue
string sContainer_Id = ''
//-=-

f_method_trace_special( gs_project, this.ClassName() , 'Start compare system inventory ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.


//NOV 2019 - MikeA F17679 S36894 I2538 - KNY - City of New York EM - Ability to Cycle Count Components

if upper(gs_project) ='NYCSP'   then
	dsSys = f_datastoreFactory( 'd_sys_inv_by_item_master_component')
else
	dsSys = f_datastoreFactory( 'd_sys_inv_by_item_master' )
end if 

dsSys = getcomparesysinv()
dsSys.setSort( getSortOrder() )
dsSys.sort()

dsDecrepancy = f_datastoreFactory( 'd_cc_decrepancy_rpt' )

max = idw_si.rowcount()
for Index = 1 to max
	
	//Skip Empty rows?
	If Upper(idw_si.object.sku[ Index ] ) = 'EMPTY' Then Continue
	
	lineItem = idw_si.object.line_item_no[ index ]
	description = ''
	decrepancy = false
	appsku = idw_si.object.sku[ Index ] 
	appQty = idw_si.object.quantity[ Index ] 
	apploc = idw_si.object.l_code[ index ]
	
	//NOV 2019 - MikeA F17679 S36894 I2538 - KNY - City of New York EM - Ability to Cycle Count Components
	if upper(gs_project) ='NYCSP'   then	appComponentQty =  idw_si.object.component_qty[ index ]
	
	fqtyvalue = string( appQty )
	findthis = 	fsku + idw_si.object.sku[ index ] + quote + _and 
	findthis += floc  + idw_si.object.l_code[ index ] + quote + _and 
	findthis += fsup+ idw_si.object.supp_code[ index ] + quote + _and 
	findthis += finvtype + idw_si.object.inventory_type[ index ] + quote + _and 
	findthis += fserial + idw_si.object.serial_no[ index ] + quote + _and 
	findthis += flot_no+ idw_si.object.lot_no[ index ] + quote + _and 
	findthis += fcoo + idw_si.object.country_of_origin[ index ] + quote + _and 
	findthis += fowner + string( idw_si.object.owner_id[ index ] ) + " " // + _and
//	findthis += fro_no + idw_si.object.ro_no[ index ] + quote 			// LTK 20150310  Remove ro_no from CC
	
	sContainer_Id = idw_si.object.container_id[ index ]
	IF (NOT IsNull(sContainer_Id) ) and (sContainer_Id <> '') and (sContainer_Id <> '-') THEN
		findthis += _and + fcon_id + idw_si.object.container_id[ index ] + quote
	END IF
		
	foundRow = dsSys.find( findthis, 1, dsSys.rowcount() )

	if foundrow <=0 then
		decrepancy = true
		description = 'No System Data Found, '
		sysloc = ''
		sysqty = 0
	else
		sysQty = dsSys.object.quantity[ foundrow ] 
		// need to include container locations even if 
		if sysQty <> appQty then
			decrepancy = true
			description += 'Quantity Mismatch, '		
		end if
		sysloc = dsSys.object.l_code[ foundrow ]
		if sysloc <> apploc then
			decrepancy = true
			description += 'Location Mismatch, '		
		end if
		
		//NOV 2019 - MikeA F17679 S36894 I2538 - KNY - City of New York EM - Ability to Cycle Count Components
		if upper(gs_project) ='NYCSP'   then	
			sysComponentQty = dsSys.object.Component_Qty[ foundrow ] 
			if sysComponentQty <> appComponentQty then
				decrepancy = true
				description += 'Component Quantity Mismatch, '		
			end if
		end if
	end if
	
	if decrepancy then
		description = left( description, ( len( description ) -2 ) )
		insertrow = dsDecrepancy.insertRow( 0 )
		dsDecrepancy.object.sku[ insertRow ] 			= appsku
		dsDecrepancy.object.description[ insertRow ] = description
		dsDecrepancy.object.apploc[ insertRow ] 		= apploc
		dsDecrepancy.object.sysloc[ insertRow ] 		= sysloc
		dsDecrepancy.object.appQty[ insertRow ] 		= appQty
		dsDecrepancy.object.sysQty[ insertRow ] 		= sysQty
	end if

next

if dsDecrepancy.rowcount() = 0 then return

dsDecrepancy.object.warehouse[ 1 ] 	= idw_main.object.wh_code[ 1 ]
dsDecrepancy.object.ordnumber[ 1 ] 	= idw_main.object.CC_No[ 1 ]
dsDecrepancy.object.ordtype[ 1 ] 	= idw_main.object.ord_type[ 1 ]
dsDecrepancy.object.orddate[ 1 ] 	= idw_main.object.ord_date[ 1 ]
dsDecrepancy.object.ordstatus[ 1 ] 	= idw_main.object.ord_status[ 1 ]

IF NOT ib_freeze_cc_inventory THEN //Data should not change since it is locked down. = MA - 06/23/2010 - Discussed with Dave.

	if messagebox( is_title, "System Data Has Changed Since Initial Generation, Print Discrepancy Report?",question!, yesno! ) = 1 then
		OpenWithParm(w_dw_print_options,dsDecrepancy) 
	end if
	
END IF


f_method_trace_special( gs_project, this.ClassName() , 'END compare system inventory ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
end subroutine

public subroutine dofilterdropdown (ref datawindowchild _child, string _column, string _value);// doFilterDropDown( ref datawindowchild _child, string _column, string _value )

string filterThis

if IsNull( _value ) or len( _value ) = 0 then
	filterThis = ''
else
	filterThis = _column + "= ~'" + trim( _value ) + "'"
end if

_child.setFilter( filterThis )
_child.filter()

end subroutine

public function boolean getisskuingroup (string _sku, string _supplier);// getIsSkuInGroup( string _sku )

long arow

// if the sku passed in is within the desired group return true
// else return false

// if there is no group code selected return true
if IsNull( idw_main.object.group[1] ) or len( string( idw_main.object.group[1] )  ) = 0 then return true

arow = idsItemMaster.retrieve( gs_project, _sku, _supplier )
if arow <= 0 then return false

if idsItemMaster.object.cc_group_code[ arow ] = idw_main.object.group[1] then return true

return false

end function

public function boolean getisskuinclass (string _sku, string _supplier);// boolean = getIsSkuInClass( string _sku )
long arow

// if the sku is in the desired class, return true
// else return false

// if there is no class code selected return true
if IsNull( idw_main.object.class[1] ) or len( string( idw_main.object.class[1] )  ) = 0 then return true

arow = idsItemMaster.retrieve( gs_project, _sku, _supplier )
if arow <=0 then return false

if idsItemMaster.object.cc_class_code[ arow ] = idw_main.object.class[1] then return true
return false

end function

public subroutine dodisplayownername (long _id);// doDisplayOwnerName( string _id )
		
if isNull( _id ) or _id = 0 then return // don't have one yet

idw_main.object.t_ownerName.text = f_get_owner_name( _id )

return



end subroutine

public function boolean getisskuowner (string _sku, string _supplier);// boolean = getIsSkuOwner( string _sku, string _supplier )
long arow

// if the sku is in the desired Owner, return true
// else return false

// if there is no class code selected return true
if IsNull( idw_main.object.owner_id[1] ) or len( string( idw_main.object.owner_id[1] )  ) = 0 then return true

arow = idsItemMaster.retrieve( gs_project, _sku, _supplier )

if arow <=0 then return false
if idsItemMaster.object.owner_id[ arow ] = idw_main.object.owner_id[1] then return true
return false


end function

public function integer setlocationcompletedate (datetime _value);// setLocationCompleteDate( datetime _value )
// ET3 - 2012-04-09: Modify behavior to also set date when type = 'S'
//TimA 05/11/12 Per Ermin change to 'Q' when type = 'Q'

// must be a Location or Random type cycle count
// 

//TimA 05/11/12 Per Ermin change to 'Q' when type = 'Q'
if getOrderType() <> 'L' and getOrderType() <> 'R' and getOrderType() <> 'Q' then return success
//if getOrderType() <> 'L' and getOrderType() <> 'R' and getOrderType() <> 'S' then return success

// value test
if IsNull( _value ) or NOT isDate( String( Date( _value ) )  ) then return success

long locRows

datastore Locations
Locations = f_DatastoreFactory('d_locations_by_wh_code')
locRows = Locations.retrieve( getWarehouse() )
if locRows<= 0 then return failure

long index
long max
string findThis
long foundRow

max = idw_si.rowcount()
for index = 1 to max
	findThis = "l_code = '" + idw_si.object.l_code[ index ] + "'"
	foundRow = Locations.find( findThis, 1, locRows )
	if foundRow > 0 then
		Locations.object.last_cycle_cnt_date[ foundRow ] = _value
		
		If idw_main.GetItemString(1,"ord_Type") = 'R' &
		OR idw_main.GetItemString(1,"ord_Type") = 'Q' &
		OR idw_main.GetItemString(1,"ord_Type") = 'S' &
		Then 
			/* 09/09 - PCONKL - Update Random Date if a Random count */
			// 04-09 - ET3: Update rnd cycle count date if Random or Sequential 
			Locations.object.Last_Rnd_Cycle_Count_Date[ foundRow ] = _value
			Locations.object.CC_Rnd_Cnt_Ind[ foundRow ] = "Y"
		End If
		
	end if
next

if Locations.update() <> 1 then
	Execute Immediate "ROLLBACK" using SQLCA;
	return failure
else
	Execute Immediate "COMMIT" using SQLCA;
	return success;
end if



end function

public subroutine setsysteminventorydisplay (boolean _flag);// setSystemInventoryDisplay( boolean _flag )

int iwidth

if _flag then iwidth = 448
idw_si.object.quantity.width = iwidth
idw_si.object.quantity_t.width = iwidth
idw_si.object.difference.width = iwidth
idw_si.object.difference_t.width = iwidth

end subroutine

public function long getsysinvrow (long _lineitemno);// long = getSysInvRow( long _lineItemNo )

string findthis
Integer max

max = idw_si.rowcount()
findthis = "line_item_no = " +String( _lineitemno )

return idw_si.find( findthis, 0, max )

end function

public function long getresultrow (ref datawindow _dw, long _lineitemno);// long = getResultRow( long _lineItemNo )

string findthis
Integer max

max = _dw.rowcount()
findthis = "line_item_no = " +String( _lineitemno )
return  _dw.find( findthis, 0, max )


end function

public subroutine setcountsheetdisplay (boolean _flag);// doDisplayCountDiff()
string setter
int iWidth 

tab_main.tabpage_result1.cb_selectall1.visible = _flag
tab_main.tabpage_result2.cb_selectall2.visible = _flag
tab_main.tabpage_result3.cb_selectall3.visible = _flag

if _flag then iWidth = 448
setter = '0'
if _flag then setter = '1'

idw_result1.object.sysinvmatch_t.visible  = setter
idw_result1.object.sysquantity_t.visible  = setter
idw_result1.object.sysinvmatch.visible  = setter
idw_result1.object.sysquantity.visible  = setter

idw_result2.object.sysinvmatch_t.visible  = setter
idw_result2.object.sysquantity_t.visible  = setter
idw_result2.object.sysinvmatch.visible  = setter
idw_result2.object.sysquantity.visible  = setter

idw_result3.object.sysinvmatch_t.visible  = setter
idw_result3.object.sysquantity_t.visible  = setter
idw_result3.object.sysinvmatch.visible  = setter
idw_result3.object.sysquantity.visible  = setter


// LTK 20120416	Pandora #354, however this is a baseline change.  The sysinvmatch and sysquantity columns were requested to be moved
// 						to the right of the quantity column.  However, when a grid column is set to invisible and then visible again, it moves to the 
// 						end (right most) of the grid.  Since this window can retrieve multiple cycle counts (without the window closing) the columns
//						may be invisible first and visible for the next CC.  To keep the sysinvmatch and sysquantity columns just to the right of quantity
//						when they are visible, scroll through the rest of the columns setting them invisible and then back to visible (or what ever state
//						they were in prior).  This approach seems convoluted even to me.
String ls_visible_setting

idw_result1.SetRedraw(FALSE)
ls_visible_setting = idw_result1.object.alternate_sku.visible
idw_result1.object.alternate_sku.visible = '0'
idw_result1.object.alternate_sku_t.visible = '0'
idw_result1.object.alternate_sku.visible = ls_visible_setting
idw_result1.object.alternate_sku_t.visible = ls_visible_setting

ls_visible_setting = idw_result1.object.supp_code.visible
idw_result1.object.supp_code.visible = '0'
idw_result1.object.supplier_t.visible = '0'
idw_result1.object.supp_code.visible = ls_visible_setting
idw_result1.object.supplier_t.visible = ls_visible_setting

ls_visible_setting = idw_result1.object.country_of_origin.visible
idw_result1.object.country_of_origin.visible = '0'
idw_result1.object.country_of_origin_t.visible = '0'
idw_result1.object.country_of_origin.visible = ls_visible_setting
idw_result1.object.country_of_origin_t.visible = ls_visible_setting

ls_visible_setting = idw_result1.object.inventory_type.visible
idw_result1.object.inventory_type.visible = '0'
idw_result1.object.inventory_type_t.visible = '0'
idw_result1.object.inventory_type.visible = ls_visible_setting
idw_result1.object.inventory_type_t.visible = ls_visible_setting

ls_visible_setting = idw_result1.object.lot_no.visible
idw_result1.object.lot_no.visible = '0'
idw_result1.object.lot_no_t.visible = '0'
idw_result1.object.lot_no.visible = ls_visible_setting
idw_result1.object.lot_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result1.object.serial_no.visible
idw_result1.object.serial_no.visible = '0'
idw_result1.object.serial_no_t.visible = '0'
idw_result1.object.serial_no.visible = ls_visible_setting
idw_result1.object.serial_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result1.object.serial_no.visible
idw_result1.object.serial_no.visible = '0'
idw_result1.object.serial_no_t.visible = '0'
idw_result1.object.serial_no.visible = ls_visible_setting
idw_result1.object.serial_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result1.object.po_no.visible
idw_result1.object.po_no.visible = '0'
idw_result1.object.po_no_t.visible = '0'
idw_result1.object.po_no.visible = ls_visible_setting
idw_result1.object.po_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result1.object.po_no2.visible
idw_result1.object.po_no2.visible = '0'
idw_result1.object.po_no2_t.visible = '0'
idw_result1.object.po_no2.visible = ls_visible_setting
idw_result1.object.po_no2_t.visible = ls_visible_setting

ls_visible_setting = idw_result1.object.container_id.visible
idw_result1.object.container_id.visible = '0'
idw_result1.object.container_id_t.visible = '0'
idw_result1.object.container_id.visible = ls_visible_setting
idw_result1.object.container_id_t.visible = ls_visible_setting

ls_visible_setting = idw_result1.object.expiration_date.visible
idw_result1.object.expiration_date.visible = '0'
idw_result1.object.exp_date_t.visible = '0'
idw_result1.object.expiration_date.visible = ls_visible_setting
idw_result1.object.exp_date_t.visible = ls_visible_setting

//ls_visible_setting = idw_result1.object.ro_no.visible	// LTK 20150310  Remove ro_no from CC
idw_result1.object.ro_no.visible = '0'
idw_result1.object.ro_no_t.visible = '0'
//idw_result1.object.ro_no.visible = ls_visible_setting
//idw_result1.object.ro_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result1.object.uom_1.visible
idw_result1.object.uom_1.visible = '0'
idw_result1.object.uom_1_t.visible = '0'
idw_result1.object.uom_1.visible = ls_visible_setting
idw_result1.object.uom_1_t.visible = ls_visible_setting

ls_visible_setting = idw_result1.object.grp.visible
idw_result1.object.grp.visible = '0'
idw_result1.object.grp_t.visible = '0'
idw_result1.object.grp.visible = ls_visible_setting
idw_result1.object.grp_t.visible = ls_visible_setting
idw_result1.SetRedraw(TRUE)

idw_result2.SetRedraw(FALSE)
ls_visible_setting = idw_result2.object.alternate_sku.visible
idw_result2.object.alternate_sku.visible = '0'
idw_result2.object.alternate_sku_t.visible = '0'
idw_result2.object.alternate_sku.visible = ls_visible_setting
idw_result2.object.alternate_sku_t.visible = ls_visible_setting

ls_visible_setting = idw_result2.object.supp_code.visible
idw_result2.object.supp_code.visible = '0'
idw_result2.object.supplier_t.visible = '0'
idw_result2.object.supp_code.visible = ls_visible_setting
idw_result2.object.supplier_t.visible = ls_visible_setting

ls_visible_setting = idw_result2.object.country_of_origin.visible
idw_result2.object.country_of_origin.visible = '0'
idw_result2.object.country_of_origin_t.visible = '0'
idw_result2.object.country_of_origin.visible = ls_visible_setting
idw_result2.object.country_of_origin_t.visible = ls_visible_setting

ls_visible_setting = idw_result2.object.inventory_type.visible
idw_result2.object.inventory_type.visible = '0'
idw_result2.object.inventory_type_t.visible = '0'
idw_result2.object.inventory_type.visible = ls_visible_setting
idw_result2.object.inventory_type_t.visible = ls_visible_setting

ls_visible_setting = idw_result2.object.lot_no.visible
idw_result2.object.lot_no.visible = '0'
idw_result2.object.lot_no_t.visible = '0'
idw_result2.object.lot_no.visible = ls_visible_setting
idw_result2.object.lot_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result2.object.serial_no.visible
idw_result2.object.serial_no.visible = '0'
idw_result2.object.serial_no_t.visible = '0'
idw_result2.object.serial_no.visible = ls_visible_setting
idw_result2.object.serial_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result2.object.serial_no.visible
idw_result2.object.serial_no.visible = '0'
idw_result2.object.serial_no_t.visible = '0'
idw_result2.object.serial_no.visible = ls_visible_setting
idw_result2.object.serial_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result2.object.po_no.visible
idw_result2.object.po_no.visible = '0'
idw_result2.object.po_no_t.visible = '0'
idw_result2.object.po_no.visible = ls_visible_setting
idw_result2.object.po_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result2.object.po_no2.visible
idw_result2.object.po_no2.visible = '0'
idw_result2.object.po_no2_t.visible = '0'
idw_result2.object.po_no2.visible = ls_visible_setting
idw_result2.object.po_no2_t.visible = ls_visible_setting

ls_visible_setting = idw_result2.object.container_id.visible
idw_result2.object.container_id.visible = '0'
idw_result2.object.container_id_t.visible = '0'
idw_result2.object.container_id.visible = ls_visible_setting
idw_result2.object.container_id_t.visible = ls_visible_setting

ls_visible_setting = idw_result2.object.expiration_date.visible
idw_result2.object.expiration_date.visible = '0'
idw_result2.object.exp_date_t.visible = '0'
idw_result2.object.expiration_date.visible = ls_visible_setting
idw_result2.object.exp_date_t.visible = ls_visible_setting

//ls_visible_setting = idw_result2.object.ro_no.visible	// LTK 20150310  Remove ro_no from CC
idw_result2.object.ro_no.visible = '0'
idw_result2.object.ro_no_t.visible = '0'
//idw_result2.object.ro_no.visible = ls_visible_setting
//idw_result2.object.ro_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result2.object.uom_1.visible
idw_result2.object.uom_1.visible = '0'
idw_result2.object.uom_1_t.visible = '0'
idw_result2.object.uom_1.visible = ls_visible_setting
idw_result2.object.uom_1_t.visible = ls_visible_setting

ls_visible_setting = idw_result2.object.grp.visible
idw_result2.object.grp.visible = '0'
idw_result2.object.grp_t.visible = '0'
idw_result2.object.grp.visible = ls_visible_setting
idw_result2.object.grp_t.visible = ls_visible_setting
idw_result2.SetRedraw(TRUE)

idw_result3.SetRedraw(FALSE)
ls_visible_setting = idw_result3.object.alternate_sku.visible
idw_result3.object.alternate_sku.visible = '0'
idw_result3.object.alternate_sku_t.visible = '0'
idw_result3.object.alternate_sku.visible = ls_visible_setting
idw_result3.object.alternate_sku_t.visible = ls_visible_setting

ls_visible_setting = idw_result3.object.supp_code.visible
idw_result3.object.supp_code.visible = '0'
idw_result3.object.supplier_t.visible = '0'
idw_result3.object.supp_code.visible = ls_visible_setting
idw_result3.object.supplier_t.visible = ls_visible_setting

ls_visible_setting = idw_result3.object.country_of_origin.visible
idw_result3.object.country_of_origin.visible = '0'
idw_result3.object.country_of_origin_t.visible = '0'
idw_result3.object.country_of_origin.visible = ls_visible_setting
idw_result3.object.country_of_origin_t.visible = ls_visible_setting

ls_visible_setting = idw_result3.object.inventory_type.visible
idw_result3.object.inventory_type.visible = '0'
idw_result3.object.inventory_type_t.visible = '0'
idw_result3.object.inventory_type.visible = ls_visible_setting
idw_result3.object.inventory_type_t.visible = ls_visible_setting

ls_visible_setting = idw_result3.object.lot_no.visible
idw_result3.object.lot_no.visible = '0'
idw_result3.object.lot_no_t.visible = '0'
idw_result3.object.lot_no.visible = ls_visible_setting
idw_result3.object.lot_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result3.object.serial_no.visible
idw_result3.object.serial_no.visible = '0'
idw_result3.object.serial_no_t.visible = '0'
idw_result3.object.serial_no.visible = ls_visible_setting
idw_result3.object.serial_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result3.object.serial_no.visible
idw_result3.object.serial_no.visible = '0'
idw_result3.object.serial_no_t.visible = '0'
idw_result3.object.serial_no.visible = ls_visible_setting
idw_result3.object.serial_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result3.object.po_no.visible
idw_result3.object.po_no.visible = '0'
idw_result3.object.po_no_t.visible = '0'
idw_result3.object.po_no.visible = ls_visible_setting
idw_result3.object.po_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result3.object.po_no2.visible
idw_result3.object.po_no2.visible = '0'
idw_result3.object.po_no2_t.visible = '0'
idw_result3.object.po_no2.visible = ls_visible_setting
idw_result3.object.po_no2_t.visible = ls_visible_setting

ls_visible_setting = idw_result3.object.container_id.visible
idw_result3.object.container_id.visible = '0'
idw_result3.object.container_id_t.visible = '0'
idw_result3.object.container_id.visible = ls_visible_setting
idw_result3.object.container_id_t.visible = ls_visible_setting

ls_visible_setting = idw_result3.object.expiration_date.visible
idw_result3.object.expiration_date.visible = '0'
idw_result3.object.exp_date_t.visible = '0'
idw_result3.object.expiration_date.visible = ls_visible_setting
idw_result3.object.exp_date_t.visible = ls_visible_setting

//ls_visible_setting = idw_result3.object.ro_no.visible	// LTK 20150310  Remove ro_no from CC
idw_result3.object.ro_no.visible = '0'
idw_result3.object.ro_no_t.visible = '0'
//idw_result3.object.ro_no.visible = ls_visible_setting
//idw_result3.object.ro_no_t.visible = ls_visible_setting

ls_visible_setting = idw_result3.object.uom_1.visible
idw_result3.object.uom_1.visible = '0'
idw_result3.object.uom_1_t.visible = '0'
idw_result3.object.uom_1.visible = ls_visible_setting
idw_result3.object.uom_1_t.visible = ls_visible_setting

ls_visible_setting = idw_result3.object.grp.visible
idw_result3.object.grp.visible = '0'
idw_result3.object.grp_t.visible = '0'
idw_result3.object.grp.visible = ls_visible_setting
idw_result3.object.grp_t.visible = ls_visible_setting
idw_result3.SetRedraw(TRUE)
// End Pandora #354

if NOT _flag then return

// check any and all that match
//doCountDiffRefresh( idw_result1 )
//doCountDiffRefresh( idw_result2 )
//doCountDiffRefresh( idw_result3 )

end subroutine

public subroutine settitle (string _value);// setTitle( string _value )
is_title = _value

end subroutine

public function string gettitle ();// string = getTitle()
return is_title

end function

public subroutine setccorder (string _value);isCCOrder = _value

end subroutine

public function string getccorder ();return isCCOrder

end function

public function datastore getcomparesysinv ();String ls_s, ls_e, ls_wh, ls_type, ls_sku, ls_loc, ls_serial, ls_lot, ls_po, ls_order, ls_ro_no, sql_syntax, Errors
string ls_supp,ls_po2,ls_container_id, ls_coo //GAP 11-02 added container
datetime ldt_expiration_date  //GAP 11-02
Long i,  ll_cnt,ll_ctr,ll_ret,ll_owner, llRowCount
decimal ld_qty, ld_component_qty //GAP 11-02 convert to decimal
ll_ctr=0

long lOwner
string lsGroup
string lsClass
string lsWhere
string lsGroupWhere 	= " Item_Master.cc_group_code = '"
string lsClassWhere 	= " item_Master.cc_class_code = '"
string lsOwnerWhere 	= " content_summary.owner_id  = "
string lsAnd = ' and '
string lsQuote = "' "
long sysInvRows
long index

datastore lds_cc
datastore ldsSysInv
datastore ldsReturnds

ldsReturnds 	= f_datastoreFactory('d_cc_inventory')
 //Begin - Dinesh -F24934/S50765/- 10/29/2020 - Include component on cycle count for order type SKU as well
 If upper(gs_project) ='NYCSP' then
	lds_cc 			= f_datastoreFactory( 'd_cc_qty_rollup_ro_no_component') 
else
	lds_cc 			= f_datastoreFactory( 'd_cc_qty_rollup_ro_no')
end if
 // End -Dinesh -F24934/S50765/- 10/29/2020 - Include component on cycle count for order type SKU as well
ldsSysInv 		= f_datastoreFactory( 'd_sys_inv_by_item_master')
SqlUtil.setOriginalSql( ldsSysInv.GetSQLSelect() )
SqlUtil.doParseSql()

SetPointer(hourglass!)

f_method_trace_special( gs_project, this.ClassName() , 'Start comparesysinventory ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

ls_s = idw_main.GetItemString(1, "range_start")
ls_e = idw_main.GetItemString(1, "range_end")
ls_wh = idw_main.GetItemstring(1, "wh_code")
ls_order = idw_main.GetItemstring(1, "cc_no")
lsGroup = idw_main.object.Group[1]
lsClass = idw_main.object.Class[1]
lOwner = idw_main.object.owner_id[1]

setwarehouse( ls_wh )
setBlindKnown()
setBlindKnownprt()
setCountDiff()

ldsReturnds.reset()
string ls_order_type
ls_order_type=idw_main.GetItemString(1, "ord_type") // Dinesh -F24934/S50765/- 10/29/2020 - Include component on cycle count for order type SKU as well
//If idw_main.GetItemString(1, "ord_type") = "L" Then
// dts - 8/26/10 - TODO! need to implement Ord_Type 'B' - just slamming it in to get it in the hands of testers.
//If idw_main.GetItemString(1, "ord_type") = "L" or idw_main.GetItemString(1, "ord_type") = "B"  or idw_main.GetItemString(1, "ord_type") = "S" Then  // Dinesh -F24934/S50765/- 10/29/2020 - Include component on cycle count for order type SKU as well
If idw_main.GetItemString(1, "ord_type") = "L" or idw_main.GetItemString(1, "ord_type") = "B"   Then // 12/22/2020 - Dinesh
// 05/00 - PCONKL - Allow for empty range
	If isNull(ls_s) or ls_s = '' Then ls_S = '0'
	If isnull(ls_e) or ls_e = '' Then ls_e = 'ZZZZZZZZZZ'
	
	 // Dinesh -F24934/S50765/- 10/29/2020 - Include component on cycle count for order type SKU as well
	
	IF lds_cc.Retrieve(gs_project,ls_wh,ls_s,ls_e) <=0 THEN 	Return ldsReturnds 
	
elseIf upper(gs_project) ='NYCSP' and idw_main.GetItemString(1, "ord_type") = "S"  then
		
	IF lds_cc.Retrieve(gs_project,ls_wh,ls_s,ls_e,ls_order_type) <=0 THEN 	Return ldsReturnds 
	
	
	if  upper(gs_project) ='NYCSP'  then
		lds_cc.SetFilter("")
		lds_cc.Filter()
		
		// Begin - Dinesh - F24934/S50765/- 11/17/2020 - Include component on cycle count for order type SKU as well
		string ls_sort
		ls_sort='inventory_type d'
		lds_cc.setsort(ls_sort)
		lds_cc.sort()
		//End - Dinesh -F24934/S50765/- 11/17/2020 - Include component on cycle count for order type SKU as well
	end if

	
	//Call the store procedure sp_cc_qty
	
	llRowCount = lds_cc.rowcount()
	
	f_method_trace_special( gs_project, this.ClassName() , 'Process comparesysinventory and count is: ' +String(llRowCount) ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
	
	For ll_ctr = 1 to llRowCount
		
			i = ldsReturnds.Insertrow(0)

			ls_loc=lds_cc.object.l_code[ll_ctr]
			ldsReturnds.setitem(i, "cc_no", ls_order)
			ldsReturnds.SetItem(i, "l_code", ls_loc)
			ld_qty = lds_cc.object.tot_avail_qty[ll_ctr]

			//NOV 2019 - MikeA F17679 S36894 I2538 - KNY - City of New York EM - Ability to Cycle Count Components
			If upper(gs_project) ='NYCSP' Then 
				ld_component_qty = lds_cc.object.component_qty[ll_ctr]
			Else 
				ld_component_qty = 0 
			End If
			
			If ld_qty > 0 OR ld_component_qty > 0 Then
				ldsReturnds.object.line_item_no[ i ] = i	 
				ls_sku = lds_cc.object.sku[ll_ctr]
				ls_supp = lds_cc.object.supp_code[ll_ctr]
				ll_owner = lds_cc.object.owner_id[ll_ctr]

				ls_serial = lds_cc.object.serial_no[ll_ctr]
				ls_lot = lds_cc.object.lot_no[ll_ctr]
				ls_po = lds_cc.object.po_no[ll_ctr]
				ls_po2 = lds_cc.object.po_no2[ll_ctr]
				ls_container_id = lds_cc.object.container_id[ll_ctr]			
				ldt_expiration_date= lds_cc.object.expiration_date[ll_ctr]	
//				ls_ro_no =  lds_cc.object.ro_no[ll_ctr]		// LTK 20150310  Remove ro_no from CC
				
				if ib_freeze_cc_inventory then
				
					ls_type = lds_cc.object.old_inventory_type[ll_ctr]				
					ls_coo = lds_cc.object.old_country_of_origin[ll_ctr]
					
					
				else
				
					ls_type = lds_cc.object.inventory_type[ll_ctr]				
					ls_coo = lds_cc.object.country_of_origin[ll_ctr]
					
				end if
					
				//Seting data
				ldsReturnds.SetItem(i, "sku", ls_sku)
				ldsReturnds.SetItem(i, "supp_code", ls_supp)
				ldsReturnds.SetItem(i, "owner_id", ll_owner)
				ldsReturnds.SetItem(i, "inventory_type", ls_type)
				ldsReturnds.SetItem(i, "serial_no", ls_serial)
				ldsReturnds.SetItem(i, "lot_no", ls_lot)
				ldsReturnds.SetItem(i, "po_no", ls_po)
//				ldsReturnds.SetItem(i, "ro_no", ls_ro_no)
				ldsReturnds.SetItem(i, "po_no2", ls_po2)					
				ldsReturnds.SetItem(i, "container_id", ls_container_id)				
				ldsReturnds.SetItem(i, "expiration_date", ldt_expiration_date)
				ldsReturnds.SetItem(i, "country_of_origin", ls_coo)
				ldsReturnds.setitem(i, "quantity", ld_qty)
			Else
				ldsReturnds.Deleterow(i)
		End IF
	Next
	
ElseIf idw_main.GetItemString(1, "ord_type") = "R" OR idw_main.GetItemString(1, "ord_type") = "Q" Then /* 09/09 - PCONKL - Random */
	
	//Build and Retrieve by Datastore
	lds_cc = Create DAtaStore
	
	//*************BCR 27-JUN-2011: SQL 2008 Compatibility Project to convert "*=" to LEFT JOIN
	
//	sql_syntax = "Select  Location.L_Code,Content.sku,Content.supp_code,Content.owner_id, Content.inventory_type,Content.serial_no, Content.lot_no,Content.po_no,Content.po_no2,Content.avail_qty as tot_avail_qty, "
//	sql_syntax += " Content.country_of_origin,Container_ID,Expiration_Date,Content.ro_no,Content.old_country_of_origin,Content.old_inventory_type "
//	sql_syntax += "FROM 	Location (nolock),  Content (nolock) "
//	sql_syntax += " where content.project_id = '" + gs_Project + "' and  Content.Component_Qty = 0 and content.wh_code = '" + ls_wh + "' and  Location.wh_code = '" + ls_wh + "' and Location.L_Code *= Content.L_Code "
//	sql_syntax += " and  CC_Rnd_Cnt_Ind = 'Y'  "
	
	sql_syntax = "SELECT  Location.L_Code, Content.sku, Content.supp_code, Content.owner_id, Content.inventory_type, Content.serial_no, Content.lot_no, Content.po_no, Content.po_no2, Content.avail_qty as tot_avail_qty, "
//	sql_syntax += " Content.country_of_origin, Content.Container_ID , Content.Expiration_Date, Content.ro_no, Content.old_country_of_origin, Content.old_inventory_type "		// LTK 20150310  Remove ro_no from CC
	sql_syntax += " Content.country_of_origin, Content.Container_ID , Content.Expiration_Date, Content.old_country_of_origin, Content.old_inventory_type "
	sql_syntax += "FROM 	Location (nolock) LEFT JOIN Content (nolock) ON Location.L_Code = Content.L_Code "
 	sql_syntax += " and  Content.project_id = '" + gs_Project + "' and  Content.Component_Qty = 0 and Content.wh_code = '" + ls_wh + "' "
	sql_syntax += " WHERE  Location.wh_code = '" + ls_wh + "'  "
	sql_syntax += " and  Location.CC_Rnd_Cnt_Ind = 'Y'  "
	//*********************************************
		
	lds_cc.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
	lds_cc.SetTransobject(sqlca)
	
	lds_cc.Retrieve() 
	
	llRowCount = lds_cc.rowcount()
	
	For ll_ctr = 1 to llRowCount
		
			i = ldsReturnds.Insertrow(0)

			ls_loc=lds_cc.object.l_code[ll_ctr]
			ldsReturnds.setitem(i, "cc_no", ls_order)
			ldsReturnds.SetItem(i, "l_code", ls_loc)
			ld_qty = lds_cc.object.tot_avail_qty[ll_ctr]
			
			If ld_qty > 0 Then
				ldsReturnds.object.line_item_no[ i ] = i	 
				ls_sku = lds_cc.object.sku[ll_ctr]
				ls_supp = lds_cc.object.supp_code[ll_ctr]
				ll_owner = lds_cc.object.owner_id[ll_ctr]

				ls_serial = lds_cc.object.serial_no[ll_ctr]
				ls_lot = lds_cc.object.lot_no[ll_ctr]
				ls_po = lds_cc.object.po_no[ll_ctr]
				ls_po2 = lds_cc.object.po_no2[ll_ctr]
				ls_container_id = lds_cc.object.container_id[ll_ctr]			
				ldt_expiration_date= lds_cc.object.expiration_date[ll_ctr]	
//				ls_ro_no =  lds_cc.object.ro_no[ll_ctr]	
				
				if ib_freeze_cc_inventory then
				
					ls_type = lds_cc.object.old_inventory_type[ll_ctr]				
					ls_coo = lds_cc.object.old_country_of_origin[ll_ctr]
					
					
				else
				
					ls_type = lds_cc.object.inventory_type[ll_ctr]				
					ls_coo = lds_cc.object.country_of_origin[ll_ctr]
					
				end if
					
				//Seting data
				ldsReturnds.SetItem(i, "sku", ls_sku)
				ldsReturnds.SetItem(i, "supp_code", ls_supp)
				ldsReturnds.SetItem(i, "owner_id", ll_owner)
				ldsReturnds.SetItem(i, "inventory_type", ls_type)
				ldsReturnds.SetItem(i, "serial_no", ls_serial)
				ldsReturnds.SetItem(i, "lot_no", ls_lot)
				ldsReturnds.SetItem(i, "po_no", ls_po)
//				ldsReturnds.SetItem(i, "ro_no", ls_ro_no)
				ldsReturnds.SetItem(i, "po_no2", ls_po2)					
				ldsReturnds.SetItem(i, "container_id", ls_container_id)				
				ldsReturnds.SetItem(i, "expiration_date", ldt_expiration_date)
				ldsReturnds.SetItem(i, "country_of_origin", ls_coo)
				ldsReturnds.setitem(i, "quantity", ld_qty)
			Else
				ldsReturnds.Deleterow(i)
		End IF
	Next
	
Else	/*by Sku*/
	
	// 05/00 - PCONKL - Allow for empty range
	// 07/00 - PCONKL - include PO and check for reserved Locations
	If isNull(ls_s) or ls_s = '' Then ls_s = '0'
	If isnull(ls_e) or ls_e = '' Then ls_e = 'ZZZZZZZZZZ'

	// pvh - 08/03/06 - ccmods
	lsWhere = SqlUtil.getWhere()
	lsWhere += " and  content.wh_code = '" + ls_wh + lsQuote + lsand + "dbo.content.Project_ID = '" + gs_project + lsQuote
	lsWhere += lsAnd + "dbo.content.SKU >= '" + ls_s + lsQuote + lsAnd + "dbo.content.SKU <= '" + ls_e + lsQuote 

	if NOT isNull( lsGroup ) and len( lsGroup ) > 0 then	lsWhere += lsAnd + lsGroupWhere + lsGroup + lsQuote
	if NOT isNull( lsClass ) and len( lsClass ) > 0 then		lsWhere += lsAnd + lsClassWhere + lsClass + lsQuote
	if NOT isNull( lOwner ) and lOwner  > 0 then				lsWhere += lsAnd + lsOwnerWhere + string( lOwner )

	SqlUtil.setWhere( lsWhere )
	ldsSysInv.SetSQLSelect ( SqlUtil.getSql() )

	sysInvRows = ldsSysInv.retrieve(  )
	for index = 1 to sysInvRows
		
		ls_loc 						= ldsSysInv.object.l_code[ index ]
		ls_sku						= ldsSysInv.object.sku[ index ] 
		ls_supp						= ldsSysInv.object.supp_code[ index ]
		ll_owner					= ldsSysInv.object.owner_id[ index ] 

		ls_serial					= ldsSysInv.object.serial_no[ index ]
		ls_lot							= ldsSysInv.object.lot_no[ index ] 
		ls_po						= ldsSysInv.object.po_no[ index ]
		ls_po2						= ldsSysInv.object.po_no2[ index ] 
		ls_container_id			= ldsSysInv.object.container_id[ index ] 
		ldt_expiration_date	= ldsSysInv.object.expiration_date[ index ]

		ld_qty 						= ldsSysInv.object.quantity[ index ]
//		ls_ro_no 					= ldsSysInv.object.ro_no[ index ]
		
		if ib_freeze_cc_inventory then

			ls_coo						= ldsSysInv.object.old_country_of_origin[ index ]	
			ls_type						= ldsSysInv.object.old_inventory_type[ index ]		
			
			
		else
		
			ls_coo						= ldsSysInv.object.country_of_origin[ index ]	
			ls_type						= ldsSysInv.object.inventory_type[ index ]
		
		end if
		
		if IsNull( ld_qty) then ld_qty = 0
		if IsNull( ls_loc) or len( Trim( ls_loc ) ) = 0 then ls_loc = "-"
		ll_ret=ldsReturnds.Find("sku = '" + ls_sku + "' and l_code = '" + ls_loc + &
									"' and serial_no = '" + ls_serial + "' and lot_no = '" + ls_lot + &
									"' and supp_code = '" + ls_supp + "' and owner_id = " + string(ll_owner) + &
									" and po_no = '" + ls_po + "' and po_no2 = '" + ls_po2 + &
									"' and inventory_type = '" + ls_type + "' and container_id = '" + ls_Container_id + "' and country_of_origin = '" +ls_coo + "'", 1, ldsReturnds.RowCount())		
//									"' and inventory_type = '" + ls_type + "' and container_id = '" + ls_Container_id + "' and country_of_origin = '" +ls_coo + "' and ro_no = '" + ls_ro_no + "'", 1, ldsReturnds.RowCount())		// LTK 20150310  Remove ro_no from CC
		
//		if ll_ret <= 0 THEN
//			
//			i = ldsReturnds.Insertrow(0)
//			ldsReturnds.object.line_item_no[ i ] = i
//			ldsReturnds.setitem(i, "cc_no", ls_order)
//			ldsReturnds.SetItem(i, "sku", ls_sku)
//			ldsReturnds.SetItem(i, "supp_code", ls_supp)
//			ldsReturnds.SetItem(i, "owner_id", ll_owner)
//			ldsReturnds.SetItem(i, "inventory_type", ls_type)
//			ldsReturnds.SetItem(i, "serial_no", ls_serial)
//			ldsReturnds.SetItem(i, "lot_no", ls_lot)
//			ldsReturnds.SetItem(i, "po_no", ls_po)
//			ldsReturnds.SetItem(i, "po_no2", ls_po2)					
//			ldsReturnds.SetItem(i, "container_id", ls_container_id)				
//			ldsReturnds.SetItem(i, "expiration_date", ldt_expiration_date)
//			ldsReturnds.SetItem(i, "country_of_origin", ls_coo)
//			ldsReturnds.setitem(i, "quantity", ld_qty)	
//			ldsReturnds.SetItem(i, "l_code",ls_loc)
//			ldsReturnds.SetItem(i, "ro_no",ls_ro_no)			
//		else
//			ldsReturnds.object.quantity[ ll_ret ] = ldsReturnds.object.quantity[ ll_ret ] + ld_qty
//		end if
		
		
		If ll_ret > 0 Then
			ldsReturnds.object.quantity[ ll_ret ] = ldsReturnds.object.quantity[ ll_ret ] + ld_qty
		Else
			i = ldsReturnds.Insertrow(0)
			ldsReturnds.object.line_item_no[ i ] = i
			ldsReturnds.setitem(i, "cc_no", ls_order)
			ldsReturnds.SetItem(i, "sku", ls_sku)
			ldsReturnds.SetItem(i, "supp_code", ls_supp)
			ldsReturnds.SetItem(i, "owner_id", ll_owner)
			ldsReturnds.SetItem(i, "inventory_type", ls_type)
			ldsReturnds.SetItem(i, "serial_no", ls_serial)
			ldsReturnds.SetItem(i, "lot_no", ls_lot)
			ldsReturnds.SetItem(i, "po_no", ls_po)
			ldsReturnds.SetItem(i, "po_no2", ls_po2)					
			ldsReturnds.SetItem(i, "container_id", ls_container_id)				
			ldsReturnds.SetItem(i, "expiration_date", ldt_expiration_date)
			ldsReturnds.SetItem(i, "country_of_origin", ls_coo)
			ldsReturnds.setitem(i, "quantity", ld_qty)	
			ldsReturnds.SetItem(i, "l_code",ls_loc)
//			ldsReturnds.SetItem(i, "ro_no",ls_ro_no)		
		End If
		
	next
end if

f_method_trace_special( gs_project, this.ClassName() , 'End comparesysinventory ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

return ldsReturnds

end function

public function integer setitemmastercompletedate (datetime _value);// setItemMasterCompleteDate( dateTime _value )

// if the count type is sku, then update the item master last cycle count date with the complete date where values are counted.

int index
int max
decimal{2} CountTotal
decimal{2} aCount

if getOrderType() <> 'S' then return success

max = idw_si.rowcount()
for index = 1 to max
	aCount = idw_si.object.result_1[ index ]
	if isNull( aCount ) then aCount = 0
	CountTotal += aCount
	aCount = idw_si.object.result_2[ index ]
	if isNull( aCount ) then aCount = 0
	CountTotal += aCount
	aCount = idw_si.object.result_3[ index ]
	if isNull( aCount ) then aCount = 0
	CountTotal += aCount
	if CountTotal = 0 then continue
	string msg
	if doUpdateItemMasterCompleteDate( idw_si.object.sku[ index ], idw_si.object.supp_code[ index ], _value ) = failure then
		msg = "Unable to update Item Master Complete Date~r~nSku: " + idw_si.object.sku[ index ] 	+ " Supplier: " + idw_si.object.supp_code[ index ] 	+ "~r~nIndex: " + string( index )
		messagebox( is_Title , msg, stopsign! )
		return failure
	end if

next
return success


end function

public function long getemptylinenumberforloc (string lcode);// long = getEmptyLineNumberForLoc( string lcode )

string lookfor
long foundrow
long line

lookfor = "l_code = '" + lcode + "' and sku = 'EMPTY'"
foundRow = idw_si.find( lookfor, 1, idw_si.rowcount() )
if foundRow > 0 then 
	line = idw_si.object.line_item_no[ foundRow ]
else
	line = 0
end if
return line


end function

public function integer wf_assign_random_locations (string aswarehouse);
//09/09 - Pconkl - Assign a random number to each location
DataStore	ldsLocation
Long			llRowCOunt, llRowPos
String		lsSQL, lsXML, lsXMLResponse, lsReturnCode, lsReturnDesc
Integer		liReturn
DateTime		ldtToday

SetPointer(Hourglass!)

f_method_trace_special( gs_project, this.ClassName() , 'Start Assign random locations ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

If not isvalid(iuoWebsphere) Then
	iuoWebsphere = CREATE u_nvo_websphere_post
	linit = Create Inet
End If
	
lsXML = iuoWebsphere.uf_request_header("AssignRandomLocationID", "WarehouseCode='" + asWarehouse + "'")
lsXML = iuoWebsphere.uf_request_footer(lsXML)

f_method_trace_special( gs_project, this.ClassName() , 'Process Calling Websphere by passing XML ' ,isCCOrder, '',lsXML,isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

w_main.SetMicroHelp("Assigning Random Locations on server...")

lsXMLResponse = iuoWebsphere.uf_post_url(lsXML)

f_method_trace_special( gs_project, this.ClassName() , 'Process Response back from websphere ' ,isCCOrder, '',lsXMLResponse,isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
	Messagebox("Websphere Fatal Exception Error","Unable to assign Random warehouse location IDs: ~r~r" + lsXMLResponse,StopSign!)
	Return -1
End If

//Check the return code and return description for any trapped errors
lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		
		Messagebox("Websphere Operational Exception Error","Unable to assign Random warehouse location IDs: ~r~r" + lsReturnDesc,StopSign!)
		Return -1
	
	Case Else
		
		If lsReturnDesc > '' Then
			Messagebox("",lsReturnDesc)
		End If
			
End Choose

ldtToday = DateTime(Today(),Now())

Execute Immediate "Begin Transaction" using SQLCA;
	
Update Project_Warehouse
Set CC_Rnd_Freq_start_DT = :ldtToday
Where Project_id = :gs_project and wh_code = :asWarehouse;
	
Execute Immediate "COMMIT" using SQLCA;
	
SetPointer(Arrow!)

w_main.SetMicroHelp("Ready")

//ldtToday = DateTime(Today(),Now())
//
//ldsLocation = Create DataStore
//ldsLocation.dataobject = 'd_maintanence_location'
//ldsLocation.SetTransObject(SQLCA)
//
//lsSQL = ldsLocation.GetSqlSelect()
//lsSql += "  Where wh_code = '" + asWarehouse + "' "
//ldsLocation.SetSqlSelect(lsSql)
//llRowCount = ldsLocation.Retrieve()
//
//If lLRowCount < 1 Then
//	messagebox(is_title,'No warehouse Locations retrieved. Unable to assign random location numbers')
//	Return -1
//End If
//
//Open(w_update_status)
//w_update_status.st_status.text = 'Assigning Random Locations to Warehouse Locations...'
//w_update_status.hpb_status.MaxPosition = llRowCount
////Assign each location a random number. It doesn't matter if multiple locations get the same number (it is still a random sort order)
//For lLRowPos = 1 to llRowCount
//	w_update_status.hpb_status.Position = llRowPos
//	ldsLocation.SetITem(llRowPos,'cc_rnd_loc_nbr',rand(32767)) /* 32,767 is highest number. Should be way higher than number of locations. will reduce duplicates*/
//	ldsLocation.SetItem(llRowPos,'CC_Rnd_Cnt_Ind','N') /* reset flag*/
//Next
//
//w_update_status.st_status.text = 'Saving Random Location Information...'
//Execute Immediate "Begin Transaction" using SQLCA;
//If ldsLocation.Update() = 1 Then
//	Execute Immediate "COMMIT" using SQLCA;
//	liReturn = 0
//	
//	//Set the random cycle start date on Project Warehouse...
//	
//	Execute Immediate "Begin Transaction" using SQLCA;
//	
//	Update Project_Warehouse
//	Set CC_Rnd_Freq_start_DT = :ldtToday
//	Where Project_id = :gs_project and wh_code = :asWarehouse;
//	
//	Execute Immediate "COMMIT" using SQLCA;
//	
//Else
//	Execute Immediate "ROLLBACK" using SQLCA;
//	messagebox(is_title,'Unable to assign random location numbers')
//	liReturn = -1
//End If
//
//Close(w_update_status)


f_method_trace_special( gs_project, this.ClassName() , 'End Assign random locations ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.


Return 0
end function

public function integer uf_load_sys_inv (datastore ads);Long	llRowCount, ll_Ctr, ll_Owner, i, ll_Ret, ll_Component_No
String	ls_SKU, ls_Loc, ls_Supp, ls_type, ls_Order, ls_serial, ls_lot, ls_po, ls_po2, ls_container_id, ls_Coo, ls_ro_no, ls_component_ind
Decimal	ld_qty, ld_component_qty
DateTime	ldt_expiration_date

f_method_trace_special( gs_project, this.ClassName() , 'Start Load sys inv ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

if isOrderType <> 'B' then
	llRowCount = ads.rowcount()

	If  wf_run_on_citrix ( llRowCount) = True Then
		Return -1
	End if


	//Check to see if any skus are used in another Cyclecount if ib_freeze_cc_inventory = true
	IF ib_freeze_cc_inventory THEN
		For ll_ctr = 1 to llRowCount
			ls_sku = ads.object.sku[ll_ctr]
			ls_type = ads.object.inventory_type[ll_ctr]
			if ls_type = "*" then
				MessageBox ("Cycle Count Error", "SKU " + ls_sku + " is currently assigned to another cycle count, cannot continue with this count." )
				Return -1
			end if
		Next	
	END IF
	
f_method_trace_special( gs_project, this.ClassName() , 'Process Load sys inv, count is: '+String(llRowCount) ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
	
	ls_order = idw_main.GetItemString(1, "cc_no")
	
	For ll_ctr = 1 to llRowCount

			//NOV 2019 - MikeA F17679 S36894 I2538 - KNY - City of New York EM - Ability to Cycle Count Components
			
			ld_qty = ads.object.tot_avail_qty[ll_ctr]

			// 02/20/20 - MikeA - DE14869 - Removed to allow empty locations. 
			//If upper(gs_project) <> 'NYCSP' AND ld_qty = 0 Then Continue

			i = idw_si.Insertrow(0)
			ls_loc=ads.object.l_code[ll_ctr]
			idw_si.setitem(i, "cc_no", ls_order)
			idw_si.SetItem(i, "l_code", ls_loc)
			ld_qty = ads.object.tot_avail_qty[ll_ctr]
			
			//NOV 2019 - MikeA F17679 S36894 I2538 - KNY - City of New York EM - Ability to Cycle Count Components
			//Added component 
			//DE14702  02/10/2020 - MikeA Unable to generate cycle count report (count by: sequential )
			//Only allow "L" location type to do handle components. 

			if isOrderType = 'L' or isOrderType = 'S' then   // Dinesh -F24934/S50765/- 10/29/2020 - Include component on cycle count for order type SKU as well
				ld_component_qty = ads.object.component_qty[ll_ctr]
			else
				ld_component_qty = 0
			end if
			
			If ld_qty > 0 OR ld_component_qty > 0  Then
				idw_si.object.line_item_no[ i ] = i	 
				ls_sku = ads.object.sku[ll_ctr]
				ls_supp = ads.object.supp_code[ll_ctr]
				ll_owner = ads.object.owner_id[ll_ctr]
				ls_type = ads.object.inventory_type[ll_ctr]
				ls_serial = ads.object.serial_no[ll_ctr]
				ls_lot = ads.object.lot_no[ll_ctr]
				ls_po = ads.object.po_no[ll_ctr]
				ls_po2 = ads.object.po_no2[ll_ctr]
				ls_container_id = ads.object.container_id[ll_ctr]			
				ldt_expiration_date= ads.object.expiration_date[ll_ctr]	
				ls_coo = ads.object.country_of_origin[ll_ctr]
				
				//DE14702  02/10/2020 - MikeA Unable to generate cycle count report (count by: sequential )
				//Only allow "L" location type to do handle components. 
				
				If isOrderType = 'L'  or isOrderType = 'S' Then  // Dinesh -F24934/S50765/- 10/29/2020 - Include component on cycle count for order type SKU as well
					ld_component_qty	= ads.object.component_qty[ll_ctr]
					ll_component_no =  ads.object.component_no[ll_ctr]
					ls_component_ind = ads.object.component_ind [ll_ctr] // 02/20/20 - MikeA - DE14869 - Will always return 'N' from proc.
				Else
					ls_component_ind = 'N'
				End If
				
//				ls_alternate_sku			= ads.object.alternate_sku[ ll_ctr ]
//				ls_ro_no 					= ads.object.ro_no[ ll_ctr ]						// LTK 20150310  Removed ro_no
				
				//Seting data
				idw_si.SetItem(i, "sku", ls_sku)
				idw_si.SetItem(i, "supp_code", ls_supp)
				idw_si.SetItem(i, "owner_id", ll_owner)
				idw_si.SetItem(i, "inventory_type", ls_type)
				idw_si.SetItem(i, "serial_no", ls_serial)
				idw_si.SetItem(i, "lot_no", ls_lot)
				idw_si.SetItem(i, "po_no", ls_po)
				idw_si.SetItem(i, "po_no2", ls_po2)					
				idw_si.SetItem(i, "container_id", ls_container_id)				
				idw_si.SetItem(i, "expiration_date", ldt_expiration_date)
				idw_si.SetItem(i, "country_of_origin", ls_coo)
				idw_si.setitem(i, "quantity", ld_qty)

				idw_si.setitem(i, "component_qty", ld_component_qty)
				idw_si.setitem(i, "component_no", ll_component_no)
				idw_si.setitem(i, "component_ind", ls_component_ind)

//				idw_si.SetItem(i, "ro_no",ls_ro_no)
//				idw_si.SetItem(i, "alternate_sku",ls_alternate_sku)						
				
			Else
				ll_ret=idw_si.Find("upper(sku) ='EMPTY' and supp_code = '-' and  l_code ='"+ ls_loc+"'",1,idw_si.rowcount())
				IF ll_ret = 0 THEN
					idw_si.object.line_item_no[ i ] = i	 
					idw_si.SetItem(i, "sku", "EMPTY")
					idw_si.SetItem(i, "owner_id", 0)
					idw_si.SetItem(i, "supp_code", "-")
					idw_si.SetItem(i, "inventory_type", "-")
					idw_si.SetItem(i, "serial_no", "-")
					idw_si.SetItem(i, "lot_no", "-")
					idw_si.SetItem(i, "po_no", "-")
					idw_si.SetItem(i, "po_no2", "-")
					idw_si.SetItem(i, "container_id", ls_container_id)				//GAP 11-02
					idw_si.SetItem(i, "expiration_date", ldt_expiration_date)	//GAP 11-02
					idw_si.SetItem(i, "country_of_origin", "-")
//					idw_si.SetItem(i, "ro_no", "-")
					idw_si.setitem(i, "quantity", 0)
					idw_si.setitem(i, "component_qty", 0)
				else 
					idw_si.Deleterow(i)
			   END IF	
		End IF
	Next
	
	
else  //Order Type is 'B'
	llRowCount = ads.rowcount()
	
	For ll_ctr = 1 to llRowCount
		ls_loc=ads.object.l_code[ll_ctr]
		ld_qty = ads.object.tot_avail_qty[ll_ctr]
		If ld_qty > 0 Then
			// don't do anything... Location not blank
		else
			//Blank Location...
		i = idw_si.Insertrow(0)
		idw_si.setitem(i, "cc_no", ls_order)
		idw_si.SetItem(i, "l_code", ls_loc)
			ll_ret=idw_si.Find("upper(sku) ='EMPTY' and supp_code = '-' and  l_code ='"+ ls_loc+"'",1,idw_si.rowcount())
			IF ll_ret = 0 THEN
				idw_si.object.line_item_no[ i ] = i	 
				idw_si.SetItem(i, "sku", "EMPTY")
				idw_si.SetItem(i, "owner_id", 0)
				idw_si.SetItem(i, "supp_code", "-")
				idw_si.SetItem(i, "inventory_type", "-")
				idw_si.SetItem(i, "serial_no", "-")
				idw_si.SetItem(i, "lot_no", "-")
				idw_si.SetItem(i, "po_no", "-")
				idw_si.SetItem(i, "po_no2", "-")
				idw_si.SetItem(i, "container_id", ls_container_id)				//GAP 11-02
				idw_si.SetItem(i, "expiration_date", ldt_expiration_date)	//GAP 11-02
				idw_si.SetItem(i, "country_of_origin", "-")
//				idw_si.SetItem(i, "ro_no", "-")
				idw_si.setitem(i, "quantity", 0)
				idw_si.setitem(i, "component_qty", 0)
			else 
				idw_si.Deleterow(i)
			END IF
		end if //Blank Location
	next
end if //order type <> 'B'

//NOV 2019 - MikeA F17679 S36894 I2538 - KNY - City of New York EM - Ability to Cycle Count Components

IF upper(gs_project) <> 'NYCSP'  Then
//	idw_si.SetFilter("component_ind = 'N'") // 02/20/20 - MikeA - DE14869
	idw_si.SetFilter("component_no = 0 or isNull(component_no )") 
	idw_si.Filter()
END IF


f_method_trace_special( gs_project, this.ClassName() , 'End Load sys inv ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
Return 0
end function

public function integer wf_print_export_report (integer arg_print_export);
long NbrRows, lArr_Qty[]
int index
int max
string ls_name, ls_path, ls_date
long ll_return

w_cc.TriggerEvent("ue_refresh")
DatawindowChild	ldwc, ldwc2

f_method_trace_special( gs_project, this.ClassName() , 'Start Print export report ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

//DGM Make owner name invisible based in indicator
//Added code by dgm for adding owner name 
//IF Upper(g.is_owner_ind) = 'Y' THEN
//	idsReport.dataobject = 'd_cc_report_owner'
//	idsReport.SetTransObject(SQLCA)	
//End IF

// 03/02 - PCONKL - Share Inventory Type dropdown with SYS Inv DW
idw_si.GetChild('inventory_type',ldwc)
idsReport.GetChild('Inventory_Type',ldwc2)
ldwc2.SetTransObject(SQLCA)
ldwc.ShareData(ldwc2)

idsReport.retrieve(isle_code.text)

// LTK 20150723  CC Rollup channge - the following block was necessary to "spread" any rolled up values to the count result values of all three count columns.
// The SI datawindow contains the "spread out" values of any rolled up quantities.  Copy those values to the print datawindow.
String ls_find
long i, ll_row_found
for i = 1 to idw_si.RowCount()

	//  Take SI row and find corresponding idsReport row (should be same)
	ls_find = "line_item_no = " + String( idw_si.Object.line_item_no[ i ] )
	ll_row_found = idsReport.Find( ls_find, 1, idsReport.RowCount() )
	if ll_row_found > 0 then
		//  Set all three columns
		idsReport.Object.Result_1[ ll_row_found ] = idw_si.Object.Result_1[ i ]
		idsReport.Object.Result_2[ ll_row_found ] = idw_si.Object.Result_2[ i ]
		idsReport.Object.Result_3[ ll_row_found ] = idw_si.Object.Result_3[ i ]
	end if
next


// pvh - 06/30/06 - ccmods
idsReport.Setsort( getSortOrder() )
// if flag set in warehouse...project warehouse then populate qty
setBlindKnownprt( )
if getBlindKnownprt() = 'B' then
	max = idsReport.rowcount()
	for index = 1 to max
		//BCR 07-OCT-2011: First save up the existing Qties in a local Array for later use...
		lArr_Qty[index] = idw_si.GetItemNumber(index, 'quantity')
		//...Then set all quantities to zero to make it "blind"
		idw_si.object.quantity[ index ] = 0 
	next
end if
idsReport.Sort()

if arg_print_export = 1 then
	Openwithparm(w_dw_print_options,idsReport) 
else

	//MEA - 12-11 - Added for Nike EWMS - Export to Excel (Copied from EWMS)

	ls_date = string(today(),"mmm dd, yyyy hhmm")

	ls_name = "CycleCount Report - " + ls_date
	ls_path = ProfileString(gs_inifile,"ewms","UploadPath","") + ls_name
	ll_return = GetFileSaveName("Save As File", ls_path, ls_name, "XLS", &
		" Excel Files (*.XLS), *.XLS")
	If ll_return = 1 Then
//		st_1.text = "Saving excel file ..."
		ll_return = idsReport.SaveAs(ls_path, Excel5!, True)
		if ll_return <> 1 Then
			Messagebox(is_title, "Error when saveing excel file!")
		Else
//			st_1.text = "Saved excel file completely"
		End If
	Else
		If ll_return = 0 Then
//			st_1.text = "Saving cancelled"
		Else
//			st_1.text = "Please check saveas file name!"
		End If
	End If
f_method_trace_special( gs_project, this.ClassName() , 'Generated print export report path is: ' +ls_path ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
end if

//BCR 07-OCT-2011: Restore qty values after print with zeroes for BlindKnownPrint...
if getBlindKnownprt() = 'B' then
	max = idsReport.rowcount()
	for index = 1 to max
		idw_si.object.quantity[ index ] = lArr_Qty[index] //Restore all qties to their original values...
	next
end if

f_method_trace_special( gs_project, this.ClassName() , 'End Print export report ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

Return 0

end function

public function string wf_find_greatest_allocated (integer al_row);// Added method for Pandora #882

String ls_return = ""
String findthis
String lsContainerID
String ls_lcode
String ls_work
long ll_SI_Row, llfoundrow
int li_greatest = 0

//ll_SI_Row = idw_si.GetRow()		// LTK 20140807  Now passing in row num so it can be used in ue_save as well
ll_SI_Row = al_row

findthis = "sku ='" + idw_si.object.sku[ll_SI_Row] + "' and "
findthis += "Pos(l_code,'Allocated') > 0 and "
findthis += "supp_code = '" + idw_si.object.supp_code[ll_SI_Row] + "' and "
findthis += "inventory_type ='" + idw_si.object.inventory_type[ll_SI_Row] + "' and " 
findthis += "serial_no ='" + idw_si.object.serial_no[ll_SI_Row] + "' and "
findthis += "lot_no ='" + idw_si.object.lot_no[ll_SI_Row] + "' and " 
findthis += "country_of_origin ='" + idw_si.object.country_of_origin[ll_SI_Row] + "' and "
findthis += "owner_id =" + string( idw_si.object.owner_id[ll_SI_Row] ) //+ " and "
//findthis += "ro_no = '" + idw_si.object.ro_no[ll_SI_Row] + "'" 		// LTK 20150310  Remove ro_no from CC

lsContainerID = idw_si.object.container_id[ll_SI_Row]
IF (NOT IsNull(lsContainerID) ) and (lsContainerID <> '') and (lsContainerID <> '-') THEN
	findthis += " and container_id ='" + idw_si.object.container_id[ll_SI_Row] + "'"
END IF

llFoundRow = idw_si.find( findthis, 1, idw_si.rowcount() )
do until llFoundRow <= 0
	ls_return = "1"
	ls_lcode = idw_si.object.l_code[llFoundRow]
	if Len(ls_lcode) > 9 then
		ls_work = Right(ls_lcode, Len(ls_lcode) - 9)
		if ls_work <> "" then
			if Integer(ls_work) > li_greatest then
				li_greatest = Integer(ls_work)
			end if
		end if
	end if

	if llFoundRow < idw_si.rowcount() then
		llFoundRow = idw_si.find( findthis, llFoundRow + 1, idw_si.rowcount() )
	else
		llFoundRow = 0
	end if
loop

if li_greatest > 0 then
	ls_return = String(li_greatest + 1)
end if

return ls_return
end function

public function integer wf_check_status_mobile ();
String	lsWarehouse, lsFindStr, lsMobileStatus, lsOrdStatus
Integer	i

lsMobileStatus = idw_main.GetItemString(1, "mobile_status_Ind")
lsOrdStatus = idw_main.GetItemString(1, "Ord_status")

If isNull(lsMobileStatus) Then lsMobileStatus = ''

lsWarehouse = idw_main.GetItemString(1, "wh_code")
lsFindStr = "wh_code = '" + lsWarehouse + "'"
i = g.ids_project_warehouse.Find(lsFindStr,1,g.ids_project_warehouse.rowcount())
If i > 0 Then
	
	If g.ids_project_warehouse.GetItemString(i, "Mobile_Enabled_Ind") = 'Y' Then
		
		
		//Header fields
		idw_Main.Modify("mobile_status_ind.visible=true mobile_Status_ind_t.visible=true mobile_enabled_ind.visible=true mobile_user_assigned.visible=true mobile_user_assigned_visible_t.visible=true")
		idw_Main.modify("mobile_released_time.visible=true mobile_released_time_t.visible=true mobile_count_start_time.visible=true mobile_count_start_time_t.visible=true mobile_count_complete_time.visible=true mobile_count_complete_time_t.visible=true")
		
		if lsOrdStatus = 'N' or lsOrdStatus = 'P' Then
			idw_Main.Modify("t_mobile.visible=true")
		Else
			idw_Main.Modify("t_mobile.visible=false")
		End If
		
		tab_main.tabpage_Mobile.visible=true
		
		//Only enabled for count by location right now
		if idw_main.GetItemString(1,'ord_type') = 'L' Then
			tab_main.tabpage_Mobile.Enabled=true
		Else
			tab_main.tabpage_Mobile.Enabled=false
		End If
			
	Else /* Not mobile Enabled */
		
			
		//Header fields
		idw_Main.Modify("mobile_status_ind.visible=false mobile_Status_ind_t.visible=false mobile_enabled_ind.visible=false mobile_user_assigned.visible=false mobile_user_assigned_t.visible=false")
		idw_Main.modify("mobile_released_time.visible=false mobile_released_time_t.visible=false mobile_count_start_time.visible=false mobile_count_start_time_t.visible=false mobile_count_complete_time.visible=false mobile_count_complete_time_t.visible=false")
		
		//Search fields
		idw_search.modify("mobile_status.visible=false mobile_status_t.visible=false")
		idw_result.modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
		
		idw_Main.Modify("t_mobile.visible=false")
		
		tab_main.tabpage_Mobile.visible=false
		tab_main.tabpage_Mobile.Enabled=false
		
	End If
	
Else /* waresehouse not found, must be a new record - default to non mobile. When warehouse changed, this function will be triggered again*/
	
		//Header fields
		idw_Main.Modify("mobile_status_ind.visible=false mobile_Status_ind_t.visible=false mobile_enabled_ind.visible=false mobile_user_assigned.visible=false mobile_user_assigned_t.visible=false")
		idw_Main.modify("mobile_released_time.visible=false mobile_released_time_t.visible=false mobile_count_start_time.visible=false mobile_count_start_time_t.visible=false mobile_count_complete_time.visible=false mobile_count_complete_time_t.visible=false")
		
		//Search fields
		idw_search.modify("mobile_status.visible=false mobile_status_t.visible=false")
		idw_result.modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
		
		idw_Main.Modify("t_mobile.visible=false")
		
		tab_main.tabpage_Mobile.visible=false
		tab_main.tabpage_Mobile.Enabled=false
		
End If

If idw_Main.GetItemString(1,"mobile_enabled_ind") = "Y" Then
	
	//Generate buttons disabled if released to Mobile
	tab_main.tabpage_main.cb_generate.enabled = False	
	tab_main.tabpage_result1.cb_generate1.enabled = False
	tab_main.tabpage_result2.cb_generate2.enabled = False
	tab_main.tabpage_result3.cb_generate3.enabled = False
	
	tab_main.tabpage_si.cb_si_insert.enabled = False
	tab_main.tabpage_result1.cb_delete1.enabled = False
    	tab_main.tabpage_result2.cb_delete2.enabled = False
	tab_main.tabpage_result3.cb_delete3.enabled = False
	
	//Tabs should be enabled but read only if released to mobile (data will be populated on mobile device)
	tab_main.tabpage_si.Enabled = True
	tab_main.tabpage_result1.Enabled = True
	tab_main.tabpage_result2.Enabled = True
	tab_main.tabpage_result3.Enabled = True
	
	tab_main.tabpage_result1.dw_result1.Object.Datawindow.ReadOnly = True
	tab_main.tabpage_result2.dw_result2.Object.Datawindow.ReadOnly = True
	tab_main.tabpage_result3.dw_result3.Object.Datawindow.ReadOnly = True
	
End If

//If Mobile Enabled and already released and counting by Location
If (lsMObileStatus = '' or lsMobileStatus = 'R') and (lsOrdStatus = 'N' or lsOrdStatus = 'P') and idw_main.getItemString(1,'ord_Type') = 'L'   Then
		
	idw_main.Modify("mobile_Enabled_ind.Protect=0 ")
	tab_main.tabpage_mobile.cb_delete_location.enabled=true
	
else /* being processed already, can't unrelease or change assigned user*/
		
	idw_main.Modify("mobile_Enabled_ind.Protect=1 mobile_user_assigned.protect=1 ")
	tab_main.tabpage_mobile.cb_delete_location.enabled=False
	
End If

Return 0
end function

public function boolean wf_run_on_citrix (integer al_rows);ulong lul_name_size = 32
String	ls_machine_name = Space (32)
String ls_Max
Boolean lbNeedCitrix

//TimA 04/10/15 added this new function because we also need to check when new cycle counts are created
//Allow  SuperDuper Users to run large Cycle Counts
If gs_role > "-1" Then 	
	g.GetComputerNameA (ls_machine_name, lul_name_size)
	//original assumption was that the Citrix servers would follow the mask of 'DCXVRC*'
	//  May need to allow for multiple masks (given by presence in the lookup_table), but still assuming that the 1st 6 characters are what's pertinent....
	if left(ls_machine_name, 6) <> 'DCXVRC' then
		lbNeedCitrix = False
			
		SELECT Code_Descript INTO :ls_Max FROM Lookup_Table with(nolock)
		Where project_id = :gs_project and Code_type = 'CycleCount' and Code_ID = 'MAX';
		if IsNumber(ls_Max) then
			if al_rows > long(ls_Max) then
				MessageBox("Cycle Count Max", "This Cycle Count must be processed via SIMS Citrix as the Line Count (" + string(al_rows) +") exceeds the non-CITRIX MAX ("+ ls_Max +")")
				lbNeedCitrix = True
			end if
		end if 
	end if //is machine a Citrix machine?
Else
		lbNeedCitrix = False
End if

Return lbNeedCitrix
end function

public function long wf_find_existing_count_row (datawindow adw_count, long al_row, integer ai_tab_no);long ll_row_found
String ls_find_str, 	ls_encoded_indicators

// Use common fields and then dynamically add lottables
//01-June-2018 :Madhu DE4513- Don't include Owner Code, if it is Blind Count

if adw_count.RowCount() > 0 then

	ls_find_str = "sku = '" + idw_si.Object.sku[ al_row ] + "' "
	ls_find_str += "and l_code = '" + idw_si.Object.l_code[ al_row ] + "' "
//	ls_find_str += "and Inventory_Type = '" + idw_si.Object.Inventory_Type[ al_row ] + "' "
//	ls_find_str += "and Supp_Code = '" + idw_si.Object.Supp_Code[ al_row ] + "' "
	ls_find_str += "and Supp_Code = '" + Upper( idw_si.Object.Supp_Code[ al_row ] ) + "' "
	If this.getblindknown( ) ='K' Then ls_find_str += "and Owner_ID = " + String( idw_si.Object.Owner_ID[ al_row ] ) + "  "

	ls_encoded_indicators = wf_build_encoded_rollup_code( ai_tab_no )

	if wf_decode_indicators( ls_encoded_indicators, DECODE_SERIAL_NO ) then
		ls_find_str += "and Serial_No = '" + String( idw_si.Object.Serial_No[ al_row ] ) + "' "
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_CONTAINER_ID ) then
		ls_find_str += "and Container_Id = '" + String( idw_si.Object.container_id[ al_row ] ) + "' "
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_LOT_NO ) then
		ls_find_str += "and Lot_No = '" + String( idw_si.Object.Lot_No[ al_row ] ) + "' "
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO ) then
		ls_find_str += "and Po_No = '" + String( idw_si.Object.Po_No[ al_row ] ) + "' "
	end if
	
	if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO2 ) then
		ls_find_str += "and Po_No2 = '" + String( idw_si.Object.Po_No2[ al_row ] ) + "' "
	end if
	
	if wf_decode_indicators( ls_encoded_indicators, DECODE_EXP_DT ) then
		ls_find_str += "and String(expiration_date,'mm/dd/yyyy hh:mm:ss') = '" + String( idw_si.getItemDateTime( al_row, "Expiration_Date"), 'mm/dd/yyyy hh:mm:ss' ) + "' "
	end if

	//if wf_decode_indicators( ls_encoded_indicators, DECODE_INV_TYPE ) then
		ls_find_str += "and Inventory_Type = '" + String( idw_si.Object.Inventory_Type[ al_row ] ) + "' "
	//end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_COO ) then
		ls_find_str += "and Country_of_Origin = '" + String( idw_si.Object.Country_of_Origin[ al_row ] ) + "' "
	end if

	ll_row_found = adw_count.Find( ls_find_str, 1, adw_count.RowCount() )

end if

return ll_row_found

end function

public function string wf_build_encoded_rollup_code (integer ai_tab_no);// This encoded string will represent the project warehouse rollup indicator settings which are the 8 lot-able indicator checkboxes whose value is "Y" or "N".
// All 8 "Y" or "N" values will be concatenated into a string and stored in cc_master upon a count generation so they can be used later to determine how inventory was rolled up.  
// The columns corresponding to the positions can be found below.

//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count - Assume, PoNo2 & Container Id Flags are Enabled.
String ls_return

long ll_wareshoue_row
String ls_wh_code
ls_wh_code = idw_main.Object.wh_code[1]
ll_wareshoue_row = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(ls_wh_code) + "'",1,g.ids_project_warehouse.rowCount())

if ll_wareshoue_row > 0 then
	
	if (   ai_tab_no = CC_RESULTS1_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt1_serial_no_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS2_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt2_serial_no_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS3_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt3_serial_no_req_ind[ ll_wareshoue_row ] = 'Y' ) then 
	
		ls_return = "Y"
	else
		ls_return = "N"
	end if
		
	if (   ai_tab_no = CC_RESULTS1_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt1_container_id_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS2_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt2_container_id_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS3_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt3_container_id_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS3_TAB AND ib_Foot_Print_SKU) then 
	
		ls_return += "Y"
	else
		ls_return += "N"
	end if
	
	if (   ai_tab_no = CC_RESULTS1_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt1_lot_no_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS2_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt2_lot_no_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS3_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt3_lot_no_req_ind[ ll_wareshoue_row ] = 'Y' ) then 
	
		ls_return += "Y"
	else
		ls_return += "N"
	end if
		
	if (   ai_tab_no = CC_RESULTS1_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt1_po_no_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS2_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt2_po_no_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS3_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt3_po_no_req_ind[ ll_wareshoue_row ] = 'Y' ) then 
	
		ls_return += "Y"
	else
		ls_return += "N"
	end if
		
	if (   ai_tab_no = CC_RESULTS1_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt1_po_no2_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS2_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt2_po_no2_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS3_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt3_po_no2_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS3_TAB AND ib_Foot_Print_SKU) then 
	
		ls_return += "Y"
	else
		ls_return += "N"
	end if
		
	if (   ai_tab_no = CC_RESULTS1_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt1_exp_dt_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS2_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt2_exp_dt_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS3_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt3_exp_dt_req_ind[ ll_wareshoue_row ] = 'Y' ) then 
	
		ls_return += "Y"
	else
		ls_return += "N"
	end if
		
	if (   ai_tab_no = CC_RESULTS1_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt1_invtype_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS2_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt2_invtype_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS3_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt3_invtype_req_ind[ ll_wareshoue_row ] = 'Y' ) then 
	
		ls_return += "Y"
	else
		ls_return += "N"
	end if
	
	if (   ai_tab_no = CC_RESULTS1_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt1_coo_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS2_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt2_coo_req_ind[ ll_wareshoue_row ] = 'Y' ) OR &
		( ai_tab_no = CC_RESULTS3_TAB AND g.ids_project_warehouse.Object.project_warehouse_cc_cnt3_coo_req_ind[ ll_wareshoue_row ] = 'Y' ) then 
	
		ls_return += "Y"
	else
		ls_return += "N"
	end if
end if

if Len(ls_return) = 0 then
	ls_return = "NNNNNNNN"	
end if

return ls_return

end function

public function boolean wf_decode_indicators (string as_encoded_indicators, integer ai_position);boolean lb_return


if Len( as_encoded_indicators ) >= ai_position then
	lb_return = Mid( as_encoded_indicators, ai_position, 1 ) = 'Y'
end if

return lb_return

end function

public function decimal wf_sum_si_quantity (any aa_row_number_array);decimal{5} ld_return
long ll_row_number_array[], ll_elements, i

ll_row_number_array = aa_row_number_array

for i = 1 to UpperBound( ll_row_number_array )

	//ld_return += idw_si.Object.quantity[ ll_row_number_array[ i ] ]	// now capturing line item no
	ld_return += idw_si.Object.quantity[ getSysInvRow( ll_row_number_array[ i ] ) ]

next

return ld_return

end function

public function boolean wf_is_current_count_more_granular (string as_previous_count_indicators, string as_current_count_indicators);// If the indicator strings don't match and the current indicator string contains the same number of Y's or more, then it is more granular and TRUE will be returned, otherwise FALSE

boolean lb_return

if IsNull( as_previous_count_indicators ) then
	as_previous_count_indicators = ""
end if

if IsNull( as_current_count_indicators ) then
	as_current_count_indicators = ""
end if

if as_previous_count_indicators <> as_current_count_indicators then
	
	int li_count1, li_count2, i
	
	for i = 1 to Len( as_previous_count_indicators )
		if Mid( as_previous_count_indicators, i, 1 ) = "Y" then
			li_count1++
		end if
	next
	
	for i = 1 to Len( as_current_count_indicators )
		if Mid( as_current_count_indicators, i, 1 ) = "Y" then
			li_count2++
		end if
	next
	
	if li_count2 >= li_count1 then
		lb_return = true
	end if
end if

return lb_return

end function

public function any wf_find_si_sibling_set (integer ai_line_item_no, integer ai_count_tab);// Accepts SI line_item_no and count number
// Find set of corresponding SI sibling rows using indicator string and spread flag

long ll_rows[]
long ll_row_found, ll_last_search_row, ll_si_row
String ls_find_str
String ls_encoded_indicators
boolean lb_is_count2, lb_is_count3, lb_is_a_sibling

ll_si_row = getSysInvRow( ai_line_item_no )

if ai_count_tab = CC_RESULTS2_TAB then
	lb_is_count2 = TRUE
	lb_is_a_sibling = idw_si.Object.Count1_Spread[ ll_si_row ] = "Y"
	ls_encoded_indicators = idw_main.Object.Count1_Rollup_Code[1]
elseif ai_count_tab = CC_RESULTS3_TAB then
	lb_is_count3 = TRUE
	lb_is_a_sibling = ( idw_si.Object.Count1_Spread[ ll_si_row ] = "Y" or idw_si.Object.Count2_Spread[ ll_si_row ] = "Y" )
	ls_encoded_indicators = idw_main.Object.Count2_Rollup_Code[1]
end if

if ll_si_row > 0 and ( lb_is_count2 or lb_is_count3 ) and lb_is_a_sibling then

	// Core 4
	ls_find_str = "sku = '" + idw_si.Object.sku[ ll_si_row ] + "' "
	ls_find_str += "and l_code = '" + idw_si.Object.l_code[ ll_si_row ] + "' "
	ls_find_str += "and Supp_Code = '" + idw_si.Object.Supp_Code[ ll_si_row ] + "' "
	ls_find_str += "and Owner_ID = " + String( idw_si.Object.Owner_ID[ ll_si_row ] ) + "  "
	
	// Lot-ables
	if wf_decode_indicators( ls_encoded_indicators, DECODE_SERIAL_NO ) then
		ls_find_str += "and Serial_No = '" + String( idw_si.Object.Serial_No[ ll_si_row ] ) + "' "
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_CONTAINER_ID ) then
		ls_find_str += "and Container_Id = '" + String( idw_si.Object.container_id[ ll_si_row ] ) + "' "
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_LOT_NO ) then
		ls_find_str += "and Lot_No = '" + String( idw_si.Object.Lot_No[ ll_si_row ] ) + "' "
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO ) then
		ls_find_str += "and Po_No = '" + String( idw_si.Object.Po_No[ ll_si_row ] ) + "' "
	end if
	
	if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO2 ) then
		ls_find_str += "and Po_No2 = '" + String( idw_si.Object.Po_No2[ ll_si_row ] ) + "' "
	end if
	
	if wf_decode_indicators( ls_encoded_indicators, DECODE_EXP_DT ) then
		ls_find_str += "and String(expiration_date,'mm/dd/yyyy hh:mm:ss') = '" + String( idw_si.getItemDateTime( ll_si_row, "Expiration_Date"), 'mm/dd/yyyy hh:mm:ss' ) + "' "
	end if

	//if wf_decode_indicators( ls_encoded_indicators, DECODE_INV_TYPE ) then
		ls_find_str += "and Inventory_Type = '" + String( idw_si.Object.Inventory_Type[ ll_si_row ] ) + "' "
	//end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_COO ) then
		ls_find_str += "and Country_of_Origin = '" + String( idw_si.Object.Country_of_Origin[ ll_si_row ] ) + "' "
	end if

	
	ll_last_search_row = idw_si.RowCount() + 1
	ll_row_found = idw_si.Find( ls_find_str, 1, ll_last_search_row )

	do while ll_row_found > 0

		ll_rows[ UpperBound( ll_rows ) + 1  ] = idw_si.Object.line_item_no[ ll_row_found ]
		ll_row_found = idw_si.Find( ls_find_str, ll_row_found + 1, ll_last_search_row )			// leave the +1 so no endless looping

	loop

end if

return ll_rows

end function

public function any wf_find_corresponding_si_rows (datawindow adw_count, long al_row, boolean ab_has_zero_qty);// adw_count could be any of the 3 count datawindows
// al_row is the row in adw_count
//01-June-2018 :Madhu DE4513- Don't include Owner Code, if it is Blind Count

long ll_rows[]
long ll_row_found, ll_last_search_row
String ls_find_str
String ls_encoded_indicators


if adw_count.RowCount() >= al_row and idw_si.RowCount() > 0 and idw_main.RowCount() > 0 then

	// Find string
	ls_find_str = "sku = '" + adw_count.Object.sku[ al_row ] + "' "
	ls_find_str += "and l_code = '" + adw_count.Object.l_code[ al_row ] + "' "
//	ls_find_str += "and Inventory_Type = '" + adw_count.Object.Inventory_Type[ al_row ] + "' "
	ls_find_str += "and Supp_Code = '" + Upper( adw_count.Object.Supp_Code[ al_row ] ) + "' "
	If this.getblindknown( ) ='K' Then ls_find_str += "and Owner_ID = " + String( adw_count.Object.Owner_ID[ al_row ] ) + "  "


	if adw_count = idw_result1 then
		ls_encoded_indicators = idw_main.Object.Count1_Rollup_Code[1]
	elseif adw_count = idw_result2 then
		ls_encoded_indicators = idw_main.Object.Count2_Rollup_Code[1]
		if ab_has_zero_qty then
			//ls_find_str += "and (Result_1 = 0 or IsNull( Result_1 ) ) "
			ls_find_str += "and ( (Result_1 = 0) or IsNull( Result_1 ) or (Result_1 <> quantity) ) "
		end if

	elseif adw_count = idw_result3 then
		ls_encoded_indicators = idw_main.Object.Count3_Rollup_Code[1]
		if ab_has_zero_qty then
			//ls_find_str += "and (Result_1 = 0 or IsNull( Result_1 ) ) and (Result_2 = 0 or IsNull( Result_2 ) ) "
			ls_find_str += "and (Result_1 = 0 or IsNull( Result_1 ) or (Result_1 <> quantity) ) and (Result_2 = 0 or IsNull( Result_2 ) or (Result_2 <> quantity) ) "
		end if
	end if

	// LTK 20150806  	This change allows the correct calculation of SI qty on the count tabs using the new version of SIMS 
	//						when viewing CCs processed with previous versions (version < 07/24/2015)
	if IsNull(ls_encoded_indicators) then
		//ls_encoded_indicators = 'YYYYYYYY'
		// LTK 20151214  If date > initial deployment date, use the project/warehouse configuration
		if NOT IsNull( idw_main.Object.Record_Create_Date[1] ) and ( Date( idw_main.Object.Record_Create_Date[1] ) > Date( "2015/07/24" ) ) then
			ls_encoded_indicators = wf_build_encoded_rollup_code( getCountTab() )
		else
			ls_encoded_indicators = 'YYYYYYYY'
		end if
		
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_SERIAL_NO ) then
		ls_find_str += "and Serial_No = '" + String( adw_count.Object.Serial_No[ al_row ] ) + "' "
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_CONTAINER_ID ) then
		ls_find_str += "and Container_Id = '" + String( adw_count.Object.container_id[ al_row ] ) + "' "
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_LOT_NO ) then
		ls_find_str += "and Lot_No = '" + String( adw_count.Object.Lot_No[ al_row ] ) + "' "
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO ) then
		ls_find_str += "and Po_No = '" + String( adw_count.Object.Po_No[ al_row ] ) + "' "
	end if
	
	if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO2 ) then
		ls_find_str += "and Po_No2 = '" + String( adw_count.Object.Po_No2[ al_row ] ) + "' "
	end if
	
	if wf_decode_indicators( ls_encoded_indicators, DECODE_EXP_DT ) then
		ls_find_str += "and String(expiration_date,'mm/dd/yyyy hh:mm:ss') = '" + String( adw_count.getItemDateTime( al_row, "Expiration_Date"), 'mm/dd/yyyy hh:mm:ss' ) + "' "
	end if

	//if wf_decode_indicators( ls_encoded_indicators, DECODE_INV_TYPE ) then
		ls_find_str += "and Inventory_Type = '" + String( adw_count.Object.Inventory_Type[ al_row ] ) + "' "
	//end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_COO ) then
		ls_find_str += "and Country_of_Origin = '" + String( adw_count.Object.Country_of_Origin[ al_row ] ) + "' "
	end if

	ll_last_search_row = idw_si.RowCount() + 1
	ll_row_found = idw_si.Find( ls_find_str, 1, ll_last_search_row )

	do while ll_row_found > 0

		ll_rows[ UpperBound( ll_rows ) + 1  ] = idw_si.Object.line_item_no[ ll_row_found ] 		// now capturing line item no
		ll_row_found = idw_si.Find( ls_find_str, ll_row_found + 1, ll_last_search_row )			// leave the +1 so no endless looping

	loop

end if

return ll_rows

end function

public subroutine wf_clear_si_count_results (integer ai_count);long ll_row, i
dec ld_null
SetNull( ld_null )

for i = 1 to idw_si.RowCount()

	if ai_count = 1 then
		idw_si.Object.result_1[ i ] = ld_null
	elseif ai_count = 2 then
		idw_si.Object.result_2[ i ] = ld_null
	elseif ai_count = 3 then
		idw_si.Object.result_3[ i ] = ld_null
	end if

next

end subroutine

public subroutine of_protectresults (datawindow adw_results, integer ai_protect);///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Function: of_ProtectResults
//
// Author: David Cervenan
//
// Access: Public
//
// Description: This function protects all columns on the passed results DW
//
// Modifications: 
// 1/24/2011; DC; Initial version
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
adw_results.Object.l_code.Protect				= ai_protect
adw_results.Object.sku.Protect					= ai_protect
adw_results.Object.supp_code.Protect			= ai_protect
adw_results.Object.country_of_origin.Protect	= ai_protect
adw_results.Object.inventory_type.Protect	= ai_protect
adw_results.Object.lot_no.Protect				= ai_protect
adw_results.Object.serial_no.Protect			= ai_protect
adw_results.Object.po_no.Protect				= ai_protect
adw_results.Object.po_no2.Protect				= ai_protect
adw_results.Object.container_id.Protect		= ai_protect
adw_results.Object.expiration_date.Protect	= ai_protect
//adw_results.Object.ro_no.Protect                 = 1
adw_results.Object.quantity.Protect				= ai_protect
adw_results.Object.sysinvmatch.Protect		= ai_protect

end subroutine

public function decimal getsysqtyforline (integer ai_tab, long index);//// decimal = getSysQtyForLine( long Index )
//
//if index = 0 or isNull( index ) then return 0
//long tester
//tester = getSysInvRow( Index )
//tester =  idw_si.object.quantity[ getSysInvRow( Index ) ]
//
//return tester
////return idw_si.object.quantity[ getSysInvRow( Index ) ]
//


// LTK 20150721  Rewrote function due to CC rollup

String ls_search
datawindow ldw_work
long ll_row_found
dec ld_return

if index > 0 and NOT isNull( index ) then

	choose case ai_tab
	
		case CC_RESULTS1_TAB
			ldw_work	 = idw_result1

		case CC_RESULTS2_TAB
			ldw_work	 = idw_result2

		case CC_RESULTS3_TAB
			ldw_work	 = idw_result3

	end choose

	ls_search = "line_item_no = " + String( index )
	ll_row_found = ldw_work.Find( ls_search, 1, ldw_work.RowCount() )

	if NOT IsNull( ll_row_found ) and ll_row_found > 0 then
		ld_return = ldw_work.Object.sysquantity[ ll_row_found ]
	end if

end if

return ld_return

end function

public function boolean wf_is_null_quantities_on_last_count ();boolean lb_return
long i

if NOT IsNull(idw_result3) then
	if idw_result3.RowCount() > 0 then
		
		for i = 1 to idw_result3.RowCount()
			if IsNull( idw_result3.Object.quantity[ i ] ) then
				lb_return = TRUE
				exit
			end if
		next
		return lb_return
	end if
end if

if NOT IsNull(idw_result2) then
	if idw_result2.RowCount() > 0 then
		
		for i = 1 to idw_result2.RowCount()
			if IsNull( idw_result2.Object.quantity[ i ] ) then
				lb_return = TRUE
				exit
			end if
		next
		return lb_return
	end if
end if

if NOT IsNull(idw_result1) then
	if idw_result1.RowCount() > 0 then
		
		for i = 1 to idw_result1.RowCount()
			if IsNull( idw_result1.Object.quantity[ i ] ) then
				lb_return = TRUE
				exit
			end if
		next
		return lb_return
	end if
end if

return lb_return

end function

public function boolean wf_is_cc_processed_in_old_sims_version ();boolean lb_return
String ls_status

if idw_main.RowCount() > 0 then

	ls_status = idw_main.Object.ord_status[ 1 ]

	if ( ls_status = "1" and IsNull(idw_main.Object.Count1_Rollup_Code[1]) ) or &
		( ls_status = "2" and  ( IsNull(idw_main.Object.Count1_Rollup_Code[1] ) or IsNull(idw_main.Object.Count2_Rollup_Code[1]) )) or &
		( ls_status = "3" and  ( IsNull(idw_main.Object.Count1_Rollup_Code[1] ) or IsNull(idw_main.Object.Count2_Rollup_Code[1] ) or IsNull(idw_main.Object.Count3_Rollup_Code[1] ) )) then

		lb_return = TRUE
 
	end if
end if

return lb_return

end function

public function string wf_get_rollup_release_lines (any aa_row_number_array);string  ls_return
long ll_row_number_array[], ll_elements, i

ll_row_number_array = aa_row_number_array

for i = 1 to UpperBound( ll_row_number_array )

	//ld_return += idw_si.Object.quantity[ ll_row_number_array[ i ] ]	// now capturing line item no
	ls_return = ls_return + String(idw_si.Object.line_item_no[ getSysInvRow( ll_row_number_array[ i ])  ] ) + ','

next

return ls_return

end function

public function any wf_find_corresponding_release_lines (datawindow adw_count, long al_row, boolean ab_has_zero_qty);// adw_count could be any of the 3 count datawindows
// al_row is the row in adw_count

long ll_rows[]
long ll_row_found, ll_last_search_row
String ls_find_str
String ls_encoded_indicators


if adw_count.RowCount() >= al_row and idw_si.RowCount() > 0 and idw_main.RowCount() > 0 then

	// Find string
	ls_find_str = "sku = '" + adw_count.Object.sku[ al_row ] + "' "
	ls_find_str += "and l_code = '" + adw_count.Object.l_code[ al_row ] + "' "
//	ls_find_str += "and Inventory_Type = '" + adw_count.Object.Inventory_Type[ al_row ] + "' "
	ls_find_str += "and Supp_Code = '" + Upper( adw_count.Object.Supp_Code[ al_row ] ) + "' "
	ls_find_str += "and Owner_ID = " + String( adw_count.Object.Owner_ID[ al_row ] ) + "  "


	ls_encoded_indicators = idw_main.Object.Count1_Rollup_Code[1]

	// LTK 20150806  	This change allows the correct calculation of SI qty on the count tabs using the new version of SIMS 
	//						when viewing CCs processed with previous versions (version < 07/24/2015)
	if IsNull(ls_encoded_indicators) then
		//ls_encoded_indicators = 'YYYYYYYY'
		// LTK 20151214  If date > initial deployment date, use the project/warehouse configuration
		if NOT IsNull( idw_main.Object.Record_Create_Date[1] ) and ( Date( idw_main.Object.Record_Create_Date[1] ) > Date( "2015/07/24" ) ) then
			ls_encoded_indicators = wf_build_encoded_rollup_code( getCountTab() )
		else
			ls_encoded_indicators = 'YYYYYYYY'
		end if
		
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_SERIAL_NO ) then
		ls_find_str += "and Serial_No = '" + String( adw_count.Object.Serial_No[ al_row ] ) + "' "
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_CONTAINER_ID ) then
		ls_find_str += "and Container_Id = '" + String( adw_count.Object.container_id[ al_row ] ) + "' "
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_LOT_NO ) then
		ls_find_str += "and Lot_No = '" + String( adw_count.Object.Lot_No[ al_row ] ) + "' "
	end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO ) then
		ls_find_str += "and Po_No = '" + String( adw_count.Object.Po_No[ al_row ] ) + "' "
	end if
	
	if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO2 ) then
		ls_find_str += "and Po_No2 = '" + String( adw_count.Object.Po_No2[ al_row ] ) + "' "
	end if
	
	if wf_decode_indicators( ls_encoded_indicators, DECODE_EXP_DT ) then
		ls_find_str += "and String(expiration_date,'mm/dd/yyyy hh:mm:ss') = '" + String( adw_count.getItemDateTime( al_row, "Expiration_Date"), 'mm/dd/yyyy hh:mm:ss' ) + "' "
	end if

	//if wf_decode_indicators( ls_encoded_indicators, DECODE_INV_TYPE ) then
		ls_find_str += "and Inventory_Type = '" + String( adw_count.Object.Inventory_Type[ al_row ] ) + "' "
	//end if

	if wf_decode_indicators( ls_encoded_indicators, DECODE_COO ) then
		ls_find_str += "and Country_of_Origin = '" + String( adw_count.Object.Country_of_Origin[ al_row ] ) + "' "
	end if

	ll_last_search_row = idw_si.RowCount() + 1
	ll_row_found = idw_si.Find( ls_find_str, 1, ll_last_search_row )

	do while ll_row_found > 0

		ll_rows[ UpperBound( ll_rows ) + 1  ] = idw_si.Object.line_item_no[ ll_row_found ] 		// now capturing line item no
		ll_row_found = idw_si.Find( ls_find_str, ll_row_found + 1, ll_last_search_row )			// leave the +1 so no endless looping

	loop

end if

return ll_rows

end function

public function long getresultrowrollup (ref datawindow _dw, string _releaselinelist);// long = getResultRowRRollup( long _lineItemNo )

string findthis
string lstemp

Long llLineItemNo, ll_SI_Rollup_Row, lipos
Integer max

max = _dw.rowcount()

lipos = pos(_releaselinelist,',')
if liPos = 0 and _releaselinelist > '' Then
	lsTemp = _releaselinelist
	_releaselinelist = ''
Else 
	lsTemp = Left(_releaselinelist,(lipos - 1))
	_releaselinelist = Replace(_releaselinelist, 1, lipos, '' )
End If
If IsNumber(lsTemp) then
	ll_SI_Rollup_Row = Long(lsTemp)
End If

//	ll_SI_Rollup_Row = 
Do While ll_SI_Rollup_Row > 0

	findthis = "line_item_no = " + string(ll_SI_Rollup_Row) 
	llLineItemNo = _dw.find( findthis,0, max )

	if llLineItemNo > 0 then return llLineItemNo


	lipos = pos(_releaselinelist,',')

	if liPos = 0 and _releaselinelist > '' Then
		lsTemp = _releaselinelist
		_releaselinelist = ''
	Else 
		lsTemp = Left(_releaselinelist,(lipos - 1))
		_releaselinelist = Replace(_releaselinelist, 1, lipos, '' )
	End If

	If IsNumber(lsTemp) then
		ll_SI_Rollup_Row = Long(lsTemp)
	Else
		ll_SI_Rollup_Row = 0
	End If
	
Loop

return  0


end function

public function string wf_find_greatest_allocated_rollup (integer al_row, string as_encoded_indicators);// Added method for Pandora #882

String ls_return = ""
String findthis
String lsContainerID
String ls_lcode
String ls_work
long ll_SI_Row, llfoundrow
int li_greatest = 0

//ll_SI_Row = idw_si.GetRow()		// LTK 20140807  Now passing in row num so it can be used in ue_save as well
ll_SI_Row = al_row

findthis = "sku ='" + idw_si.object.sku[ll_SI_Row] + "' and "
findthis += "Pos(l_code,'Allocated') > 0 and "
findthis += "supp_code = '" + idw_si.object.supp_code[ll_SI_Row] + "' and "
findthis += "owner_id =" + string( idw_si.object.owner_id[ll_SI_Row] ) + " and "

if wf_decode_indicators( as_encoded_indicators, DECODE_SERIAL_NO ) then
	findthis += "serial_no ='" + idw_si.object.serial_no[ll_SI_Row] + "' and "
end if
if wf_decode_indicators( as_encoded_indicators, DECODE_CONTAINER_ID ) then
	lsContainerID = idw_si.object.container_id[ll_SI_Row]
	IF (NOT IsNull(lsContainerID) ) and (lsContainerID <> '') and (lsContainerID <> '-') THEN
		findthis += "container_id ='" + idw_si.object.container_id[ll_SI_Row] + "' and "
	END IF
end if
if wf_decode_indicators( as_encoded_indicators, DECODE_LOT_NO ) then
	findthis += "lot_no ='" + idw_si.object.lot_no[ll_SI_Row] + "' and " 
end if
if wf_decode_indicators( as_encoded_indicators, DECODE_PO_NO ) then
	findthis += "Po_No ='" + idw_si.object.Po_No[ll_SI_Row] + "' and "
end if
if wf_decode_indicators( as_encoded_indicators, DECODE_PO_NO2 ) then
	findthis += "Po_No2 ='" + idw_si.object.Po_No2[ll_SI_Row] + "' and "
end if
if wf_decode_indicators( as_encoded_indicators, DECODE_COO ) then
	findthis += "country_of_origin ='" + idw_si.object.country_of_origin[ll_SI_Row] + "' and "
end if

findthis += "Inventory_Type = '" +  idw_si.Object.Inventory_Type[ ll_SI_Row ] + "' "

llFoundRow = idw_si.find( findthis, 1, idw_si.rowcount() )
do until llFoundRow <= 0
	ls_return = "1"
	ls_lcode = idw_si.object.l_code[llFoundRow]
	if Len(ls_lcode) > 9 then
		ls_work = Right(ls_lcode, Len(ls_lcode) - 9)
		if ls_work <> "" then
			if Integer(ls_work) > li_greatest then
				li_greatest = Integer(ls_work)
			end if
		end if
	end if

	if llFoundRow < idw_si.rowcount() then
		llFoundRow = idw_si.find( findthis, llFoundRow + 1, idw_si.rowcount() )
	else
		llFoundRow = 0
	end if
loop

if li_greatest > 0 then
	ls_return = String(li_greatest + 1)
end if

return ls_return
end function

public subroutine wf_multi_select_commodity_code ();//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes 

String lsSql, lserror
long ll_row

Datastore lds_commodity

//tab_main.tabpage_main.uo_commodity_code1.visible =true
tab_main.tabpage_main.uo_commodity_code1.width =1275
tab_main.tabpage_main.uo_commodity_code1.dw_search.width =1275
tab_main.tabpage_main.uo_commodity_code1.height = 470
tab_main.tabpage_main.uo_commodity_code1.dw_search.height = 465
//tab_main.tabpage_main.uo_commodity_code1.bringtotop = true
tab_main.tabpage_main.uo_commodity_code1.uf_init("d_commodity_search_list","Lookup_Table.Code_ID","commodity_cd")

//create datastore
lds_commodity =create Datastore
lsSql = " select distinct Code_ID From Lookup_Table with(nolock) "
lsSql += " Where Project_Id ='"+gs_project+"' and Code_Type = 'CCCOMM'"
lsSql += " Order by Lookup_Table.Code_ID ASC"

lds_commodity.create( SQLCA.syntaxfromsql( lsSql, "", lserror))

If len(lserror) > 0 then
	MessageBox("Error", lserror)
else
	lds_commodity.settransobject( sqlca)
	lds_commodity.retrieve( )
End If

Long rowcount //debug
//Assign Code_Id to datastore
For ll_row =1 to lds_commodity.rowcount( )
	rowcount = tab_main.tabpage_main.uo_commodity_code1.dw_search.insertrow( 0)
	tab_main.tabpage_main.uo_commodity_code1.dw_search.setitem( ll_row, 'commodity_cd', trim(lds_commodity.getitemstring(ll_row,'Code_ID')))
	tab_main.tabpage_main.uo_commodity_code1.dw_search.setitem( ll_row, 'selected', 0)
Next

destroy lds_commodity

end subroutine

public function integer dovalidateserialnumbers (ref datawindow _dw);// int = DoValidate( ref datawindow _dw  )

Integer 				index
integer 				max
string					lsMsg, lsScreen
string 					sku
string 					location
string 					serial_no, container_id
string 					filterThis
string					ls_return, ls_stripoff_checked
boolean 				foundError
integer				dwtabpage		
string					findThis
long					foundRow
dwitemstatus		lStatus

dwTabPage = getTabpageForDw(  _dw )

founderror = false

_dw.setredraw( false )

max = _dw.RowCount()
if max = 0 then return 0
For index = 1 to max 
	lStatus = _dw.getItemStatus( index, 0, primary! )
	choose case lStatus
		case New!
			// change the status to newmodified to save the row.
			_dw.setItemStatus( index, 0, primary!, NewModified! )
			continue
		case NotModified!
			continue
	end choose
	sku = _dw.object.sku[ index ]
	location = Trim( _dw.object.l_code[ index ] )
	serial_no = Trim( _dw.object.serial_no[ index ] )
	container_id = Trim( _dw.object.container_id[ index ] )

	//SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process

	IF IsNull(location) OR Trim(location) = '' Then 
			MessageBox(is_title, "Location is required, please enter!") 
			f_setfocus( _dw, index, "l_code")	
			foundError = true
			exit
	End If
	
	IF IsNull(sku) OR Trim(sku) = '' Then 
		MessageBox(is_title, "Sku is required, please enter!")
		f_setfocus( _dw, index, "sku")	
		foundError = true
		exit
	End If

	IF IsNull(serial_no) OR Trim(serial_no) = '' Then 
		MessageBox(is_title, "Serial Number is required, please enter!")
		f_setfocus( _dw, index, "serial_no")	
		foundError = true
		exit
	End If

// Check if valid location on System Inventory
//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
	findThis = "l_code = ~'" + location + "~'"
	foundrow = idw_si.find( 	findThis, 1, idw_si.rowcount() )
	if foundRow <= 0  and wf_find_up_count_zero_sku_loc ('loc', location) = 0 then
		// dts 08/10/10 for Pandora, need to allow 'ALLOCATED' to be a valid location on the cycle count.
		if not (Upper(gs_project) = 'PANDORA' and (Left(upper(Location), 9) = 'ALLOCATED' or upper(Location) = 'NO_COUNT' )) then	// LTK 20140807  Pandora #882 change
			MessageBox(is_title, "Location is not found in System Inventory, please re-enter!") 
			tab_main.selecttab( 8 )
			f_setfocus( _dw, index, "l_code")	
			foundError = true
			exit
		end if
	end if
	
// Check if valid SKU on System Inventory
//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
	findThis = "SKU = ~'" + SKU + "~'"
	foundrow = idw_si.find( 	findThis, 1, idw_si.rowcount() )
	if foundRow <= 0 and wf_find_up_count_zero_sku_loc ('sku', SKU) = 0 then
		// dts 08/10/10 for Pandora, need to allow 'ALLOCATED' to be a valid location on the cycle count.
		if not (Upper(gs_project) = 'PANDORA' and (Left(upper(Location), 9) = 'ALLOCATED' or upper(Location) = 'NO_COUNT' )) then	// LTK 20140807  Pandora #882 change
			MessageBox(is_title, "SKU is not found in System Inventory, please re-enter!") 
			tab_main.selecttab( 8 )
			f_setfocus( _dw, index, "sku")	
			foundError = true
			exit
		end if
	end if

// TAM 2017/11 Check if Duplicate row exist on the Serial Tab and validate Serial number is Correct Format
	findThis = "serial_no = ~'" + SERIAL_NO + "~'"
	foundrow = idw_serial_numbers.find( 	findThis, 1, idw_serial_numbers.rowcount() )
	if foundRow > 0 then

		//Validated SN is not a duplicate
		if foundrow < idw_serial_numbers.rowcount() then //no need to check if its the last one
			foundrow = idw_serial_numbers.find( 	findThis, foundrow+1, idw_serial_numbers.rowcount() )
			// dts 08/10/10 for Pandora, need to allow 'ALLOCATED' to be a valid location on the cycle count.
			if foundRow >1 then
				if not (Upper(gs_project) = 'PANDORA' and (Left(upper(Location), 9) = 'ALLOCATED' or upper(Location) = 'NO_COUNT' )) then	// LTK 20140807  Pandora #882 change
					MessageBox(is_title, "Serial Number has is a duplicate, please re-enter!") 
					tab_main.selecttab( 8 )
					f_setfocus( _dw, foundRow, "serial_no")	
					foundError = true
					exit
				end if
			end if
		end if

	//Check if valid container on System Inventory
	IF ib_Foot_Print_SKU THEN
		findThis = "container_id = ~'" + container_id + "~'"
		foundrow = idw_si.find( 	findThis, 1, idw_si.rowcount() )
			if foundRow <= 0 then
			// dts 08/10/10 for Pandora, need to allow 'ALLOCATED' to be a valid location on the cycle count.
			if not (Upper(gs_project) = 'PANDORA' and (Left(upper(Location), 9) = 'ALLOCATED' or upper(Location) = 'NO_COUNT' )) then	// LTK 20140807  Pandora #882 change
				MessageBox(is_title, "Container Id is not found in System Inventory, please re-enter!") 
				tab_main.selecttab( 8 )
				f_setfocus( _dw, index, "container_id")	
				foundError = true
				exit
			end if
		end if
	END IF

	//08-Oct-2018 :Madhu DE6675 - Added SKU+Loc+Container Id validation
	//Location Count Type, scanning SN's into partial containers (UP Count)
	//GailM 5/21/2019 DE10530 Google CC issue adding SN to container ID - check all counts before system information
	IF container_id <> '-' THEN
		findThis ="SKU = ~'" + SKU + "~' and l_code = ~'" + location + "~' and container_id = ~'" + container_id + "~'"
		lsScreen = ""
		If idw_result3.rowcount() > 0 Then
			foundrow = idw_result3.find( findThis, 1, idw_result3.rowcount() )
			if foundRow <= 0 then
				lsScreen = "Count Result 3"
			end if	
		ElseIf idw_result2.rowcount() > 0 Then
			foundrow = idw_result2.find( findThis, 1, idw_result2.rowcount() )
			if foundRow <= 0 then
				lsScreen = "Count Result 2"
			end if	
		ElseIf idw_result1.rowcount() > 0 Then
			foundrow = idw_result1.find( findThis, 1, idw_result1.rowcount() )
			if foundRow <= 0 then
				lsScreen = "Count Result 1"
			end if	
		ElseIf idw_result1.rowcount() > 0 Then
			foundrow = idw_si.find( findThis, 1, idw_si.rowcount() )
			if foundRow <= 0 then
				lsScreen = "System Inventory"
			end if
		End If			
		
		if not (Upper(gs_project) = 'PANDORA' and (Left(upper(Location), 9) = 'ALLOCATED' or upper(Location) = 'NO_COUNT' )) then	// LTK 20140807  Pandora #882 change
			If lsScreen <> "" Then		//Error
				lsMsg = "Record not found in " + lsScreen + ", please re-enter! ~n"
				MessageBox(is_title, lsMsg + findThis) 
				tab_main.selecttab( 8 )
				f_setfocus( _dw, index, "container_id")	
				foundError = true
				exit
			End If
		end if

	END IF

		//Validated SN format
		//a. check whether SKU is enabled for StripOff First char or not.
		//b. If scanned SN does pass Serial Mask, don't need to check against StripOff 1st char.
		//c. If scanned SN does not pass Serial Mask, need to check against StripOff 1st char and re-do Serial Mask Validation.
		ls_stripoff_checked = i_nwarehouse.of_stripoff_firstcol_checked( Upper(sku), idw_si.GetItemString(1,'supp_code'))	
		ls_return = i_nwarehouse.of_validate_serial_format_ds( Upper(sku), upper(serial_no) , idw_si.GetItemString(1,'supp_code'))	

		If ls_return <> "" and upper(ls_stripoff_checked) ='Y' Then
			serial_no = i_nwarehouse.of_stripoff_firstcol_serialno( Upper(sku) ,   idw_si.GetItemString(1,'supp_code') , upper(serial_no))
			ls_return = i_nwarehouse.of_validate_serial_format_ds( Upper(sku), upper(serial_no) , idw_si.GetItemString(1,'supp_code'))	
		End If

		if ls_return <> "" then
			MessageBox(is_title, "Serial Number is not in the correct format, please re-enter!") 
			tab_main.selecttab( 8 )
			f_setfocus( _dw, index, "sku")	
			foundError = true
			exit
		end if
	end if
	
next
_dw.setredraw( true )

if foundError then return -1
return 0

end function

public function boolean wf_check_if_skus_are_serialized ();boolean lb_return
long i

	if idw_si.RowCount() > 0 then
		
		for i = 1 to idw_si.RowCount()
			if   idw_si.Object.serialized_Ind[ i ] = 'B' or  idw_si.Object.serialized_Ind[ i ] = 'Y' then
				lb_return = TRUE
				exit
			end if
		next
		return lb_return
	end if


return lb_return

end function

public function integer wf_compare_count_to_serials ();// TAM 2017/11 - TAM - 3PL CC - Loop through the SI Rows and compare Each Location with the SN's.  If they dont match return a -1

Int li_Return
Int  i, j, li_siCount, li_siLocCount, li_serialLocCount, li_siLocQty,  li_siDiffQty
String ls_Filter, ls_lcode, ls_lcode_Save, ls_sku, ls_supp_code
long	ll_up_count_zero_qty, ll_serial_count, ll_row

li_return = 0
li_siCount = idw_si.RowCount()

for i = 1 to li_siCount
	ls_lcode= idw_si.GetItemString(i,'l_code')
	ls_sku= idw_si.GetItemString(i,'sku')
//TAM 2018/03/08 -  Defect - We need to validate the serial numbers for 2 reasons.  
	//1. there is a discrepancy (SI.difference <> 0) and 
	//2. There is no discrepancy but they have entered serial numbers anyway.
	
	// To do this we need to do a find on the Serial Number table to see if a the sku was scanned at all. We willthen change the IF statement to validate QTY differences and Scanned Differences.(if found)
	String lsFindStr
	Long llFindRow

	lsFindStr =  "l_code = '" + ls_lcode +"' and sku = '" + ls_sku +"'"
	llFindRow = idw_serial_numbers.Find(lsFindStr, 1, idw_serial_numbers.rowcount( ))

	if  (idw_si.GetItemString(i,'serialized_ind') = 'B' or  idw_si.GetItemString(i,'serialized_ind') = 'Y') and (idw_si.GetItemNumber(i,'difference') <> 0 or llFindRow >= 1) Then 

		// Set filters on L_code
		ls_Filter = "l_code = '" + ls_lcode +"' and sku = '" + ls_sku +"'"
		idw_si.SetFilter(ls_filter)
		idw_si.Filter()
		idw_serial_numbers.SetFilter(ls_filter)
		idw_serial_numbers.Filter()

		li_siLocQty = 0
		li_siDiffQty = 0
		li_siLocCount = idw_si.RowCount()

		for j = 1 to li_siLocCount
			li_siLocQty = li_siLocQty + idw_si.Getitemnumber( j, 'quantity')
			li_siDiffQty = li_siDiffQty + idw_si.Getitemnumber( j, 'difference')
		Next

		li_serialLocCount = idw_serial_numbers.RowCount()

		//Compare Location QTY to Location SN
		If li_serialLocCount <> (li_siLocQty + li_siDiffQty) Then
			//Remove Filters
			wf_remove_filter()
			return -1
		end if

		//Remove Filters
		wf_remove_filter()

	End If
Next

//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty - START
IF ids_CC_UpCountZero_Result.rowcount( ) > 0 THEN
	For ll_row = 1 to ids_CC_UpCountZero_Result.rowcount( )
		ls_sku =	ids_CC_UpCountZero_Result.getItemString(ll_row, 'sku')
		ls_supp_code =	ids_CC_UpCountZero_Result.getItemString(ll_row, 'supp_code')
		ls_lcode = ids_CC_UpCountZero_Result.getItemString(ll_row, 'l_code')
		ll_up_count_zero_qty =	ids_CC_UpCountZero_Result.getItemNumber(ll_row, 'quantity')
		
		//If sku is serialized - compare qty's
		IF wf_is_sku_serialized (ls_sku, ls_supp_code) THEN
			
			ls_Filter = "l_code = '" + ls_lcode +"' and sku = '" + ls_sku +"'"

			idw_serial_numbers.SetFilter(ls_filter)
			idw_serial_numbers.Filter()
			ll_serial_count = idw_serial_numbers.rowcount( )
			
			IF ll_up_count_zero_qty <> ll_serial_count THEN
				wf_remove_filter() //remove filter
				Return -1
			END IF
		END IF
		
		wf_remove_filter() //remove filter
	Next
END IF
//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty - END

return li_Return


end function

public function string of_parse_numeric_sys_no (string as_sys_no);// Method returns the numeric portion of a system number (do_no, ro_no, to_no, etc.)   LTK 20150515
// Copied this code from Pandora confirmation uf_gr_rose and encapusulated into this function.

String ls_return
int li_pos, i

as_sys_no = Trim(as_sys_no)

if Len( as_sys_no ) > 0 then

	for i = 1 to len( as_sys_no )
		if isNumber( mid( as_sys_no, i, 1) ) then
			li_pos = i
			exit
	 	end if
	next

	if li_pos > 0 then
		ls_return = Right( as_sys_no, len( as_sys_no ) - li_Pos + 1)
	end if

end if

return ls_return

end function

public function integer wf_check_status_serial_numbers ();//04-June-2018 :Madhu S19881 - Removed Order Type ='X', should work for all CC Order Type

String	lsFindStr, lsOrdStatus, ls_sku, ls_supp_code, ls_wh_code, lsFind
long 	llSerialized, ll_row, ll_wareshoue_row, ll_findrow
//lsMobileStatus = idw_main.GetItemString(1, "mobile_status_Ind")
lsOrdStatus = idw_main.GetItemString(1, "Ord_status")

ls_wh_code = idw_main.getItemString( 1, 'wh_code')
ll_wareshoue_row = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(ls_wh_code) + "'",1,g.ids_project_warehouse.rowCount())

// Only show for system generated CC's
If upper(gs_project) ='PANDORA'  Then
	// Only Display after the System Inventory has been generated
	if lsOrdStatus <> 'V' and  idw_si.rowcount() > 0 Then
		// Only Display if a SKU is set to serial scanned
		lsFindStr = "serialized_ind <> 'N'" 
		llSerialized = idw_si.Find(lsFindStr,1,idw_si.rowcount())
		If llSerialized > 0 Then
			/*********************************/
			//get Supplier value from System Inventory
			ls_sku = idw_si.GetItemString(llSerialized,'sku')
			lsFind ="upper(sku) ='"+ls_sku+"'"
			ll_FindRow = idw_si.find( lsFind, 1, idw_si.rowcount())
			If ll_FindRow > 0 Then ls_supp_code = idw_si.getItemString( ll_FindRow, 'supp_code')  //Get appropriate Supp Code 
			
			ib_Foot_Print_SKU = wf_is_sku_foot_print(ls_sku, ls_supp_code) 		//Is SKU Foot Print?
			/*********************************/
			
			//26-APR-2018 :Madhu S18502 - FootPrint Cycle Count
			//If SKU is Foot Print and Ord Status =3, make visible /enable Serial Tab else make Non-visible /Non-Enable
			//If SKU is Not-Foot Print , make visible /enable Serial Tab.
			//03/20 - MikeA - DE15274 - SIMS-Google - Unable to scan SN's until 3rd count for type 'F' (recon)
			If ib_Foot_Print_SKU and (lsOrdStatus ='1' or lsOrdStatus ='2' or lsOrdStatus ='3') Then
				tab_main.tabpage_serial_numbers.visible=true
				tab_main.tabpage_serial_numbers.Enabled=true
				idw_serial_numbers.Modify( "container_id_t.visible =TRUE container_id.visible =TRUE")
				idw_serial_numbers.setredraw( true)
			elseif ib_Foot_Print_SKU Then
				tab_main.tabpage_serial_numbers.visible=false
				tab_main.tabpage_serial_numbers.Enabled=false
			else
				tab_main.tabpage_serial_numbers.visible=true
				tab_main.tabpage_serial_numbers.Enabled=true

				//08-Oct-2018 :Madhu DE6675 - Make visible /Non-Visible of Container Id on Serial No Tab.
				IF (g.ids_project_warehouse.Object.project_warehouse_cc_cnt1_container_id_req_ind[ ll_wareshoue_row ] = 'Y'  OR &
					g.ids_project_warehouse.Object.project_warehouse_cc_cnt2_container_id_req_ind[ ll_wareshoue_row ] = 'Y'  OR &
					g.ids_project_warehouse.Object.project_warehouse_cc_cnt3_container_id_req_ind[ ll_wareshoue_row ] = 'Y' ) THEN
					idw_serial_numbers.Modify( "container_id_t.visible =TRUE container_id.visible =TRUE")
				ELSE
					idw_serial_numbers.Modify( "container_id_t.visible =FALSE container_id.visible =FALSE")
				END IF
			
			End If
			
			tab_main.tabpage_serial_numbers.cb_1.enabled=true
			tab_main.tabpage_serial_numbers.cb_2.enabled=true
			tab_main.tabpage_serial_numbers.cb_3.enabled=true

			idw_serial_numbers.SetTabOrder("l_code",10)
			idw_serial_numbers.SetTabOrder("sku", 20)
			idw_serial_numbers.SetTabOrder("serial_no", 30)
			//If Status is "Complete" then Tabs should be enabled but read only
			If lsOrdStatus = "C" Then
				tab_main.tabpage_serial_numbers.cb_1.enabled=false
				tab_main.tabpage_serial_numbers.cb_2.enabled=false
				tab_main.tabpage_serial_numbers.cb_3.enabled=false
				tab_main.tabpage_serial_numbers.Enabled=true
				tab_main.tabpage_serial_numbers.dw_serial_numbers.Object.Datawindow.ReadOnly = True
			End If
		Else
			//10-JULY-2018 :Madhu DE5018 - Enable Serial Numbers Tab for UP Count Zero Serialized SKU's
			For ll_row = 1 to idw_result1.rowcount( )
				IF idw_result1.getItemString( ll_row, 'up_count_zero') ='Y' THEN
					ls_sku = idw_result1.getItemString( ll_row, 'sku')
					ls_supp_code = idw_result1.getItemString( ll_row, 'supp_code')
					
					IF this.wf_is_sku_serialized( ls_sku, ls_supp_code) THEN
						llSerialized++
					END IF
				END IF
			Next

			IF llSerialized > 0 Then
				tab_main.tabpage_serial_numbers.Enabled=true
			else				
				tab_main.tabpage_serial_numbers.visible=false				
			End IF
		End If
	else
		tab_main.tabpage_serial_numbers.visible=false
	End If
Else /* Not System Generated CC */
		tab_main.tabpage_serial_numbers.visible=false
End If

Return 0
end function

public function integer wf_check_status_system_generated ();
String	lsFindStr, lsOrdStatus
long 	llSerialized
//lsMobileStatus = idw_main.GetItemString(1, "mobile_status_Ind")
lsOrdStatus = idw_main.GetItemString(1, "Ord_status")

// Only show for system generated CC's
If upper(gs_project) ='PANDORA'  and  idw_main.GetItemString(1, "Ord_type") = 'X' and lsOrdStatus <> 'V' Then
	tab_main.tabpage_system_generated.visible=true
	tab_main.tabpage_system_generated.Enabled=true
Else /* Not System Generated CC */
	tab_main.tabpage_system_generated.visible=false
	tab_main.tabpage_system_generated.Enabled=false
End If

Return 0

end function

public function long wf_is_sn_scan_required ();//17-APR-2018 :Madhu S18353  - Google - SIMS to provide option for scanning serial number when there is no discrepancy

//a. If Discrepncy found, return "false" to scan SN.
//b. If No Discrepancy found and CC_SN_SCAN_REQUIRED ='Y', should required to scan SN.
//c. If No Discrepancy found and CC_SN_SCAN_REQUIRED ='N', should not required to scan SN.
string ls_sku, ls_loc, lsFilter, ls_serialized_Ind, ls_prev_sku, ls_prev_loc
long ll_SI_No_diff_count, ll_qty, ll_row, ll_Scanned_SN_count, ll_return, ll_difference, i
boolean lbSNScanRequired

//Is it Required to Scan SN for No Discrepancy
lbSNScanRequired = (f_retrieve_parm(gs_project, 'CycleCount', 'CC_SN_SCAN_REQUIRED', 'USER_UPDATEABLE_IND') ='Y')

//SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
//Scan is required.
If idw_main.GetItemString(1, "ord_type") = "F" Then
	lbSNScanRequired=True
End If

//If it is TRUE, scanning is required
IF lbSNScanRequired and idw_si.rowcount( ) > 0 THEN
	
	FOR ll_row =1 to idw_si.rowcount( )
		ls_sku = idw_si.getItemString( ll_row, 'sku')
		ls_loc = idw_si.getItemString( ll_row, 'l_code')
		ls_serialized_Ind = idw_si.getItemString( ll_row, 'serialized_ind')
		ll_difference = idw_si.getItemNumber( ll_row, 'difference')
		
		IF ( (ls_serialized_Ind ='Y' or ls_serialized_Ind ='B') and (ll_difference =0) and ls_sku <> ls_prev_sku and ls_loc <> ls_prev_loc ) Then
			
			//apply filter on SI Records
			lsFilter ="sku ='"+ls_sku+"' and l_code ='"+ls_loc+"' and serialized_ind IN ('Y', 'B') and difference =0"
			idw_si.setfilter( lsFilter)
			idw_si.filter( )
			ll_SI_No_diff_count = idw_si.rowcount( )
			
			ll_qty = 0
			For i =1 to ll_SI_No_diff_count
				ll_qty = ll_qty + idw_si.getItemNumber( i, 'quantity')
			Next
			
			//apply filter on Scanned SN Records
			lsFilter ="sku ='"+ls_sku+"' and l_code ='"+ls_loc+"'"
			idw_serial_numbers.setfilter( lsFilter)
			idw_serial_numbers.filter( )
			ll_Scanned_SN_count = idw_serial_numbers.rowcount( )
			
			If ll_qty <> ll_Scanned_SN_count Then
				wf_remove_filter() //remove filter
				
				MessageBox("Cycle Count", "Serial Number Scan is required. Would you please scan Serial No's for SKU# "+ls_sku+" and Location# "+ls_loc+"")	
				Return -1
			End If
	
			wf_remove_filter() //remove filter
			
		End IF
		
		ls_prev_sku = ls_sku
		ls_prev_loc = ls_loc
	NEXT
	
	ll_return =0
ELSE
	
	ll_return = 0 //If it is False, scanning is not required.	
END IF


Return ll_return
end function

public subroutine wf_remove_filter ();//17-APR-2018 :Madhu S18353 - Google - SIMS to provide option for scanning serial number when there is no discrepancy

//remove filter
idw_si.setfilter( "")
idw_si.filter( )
idw_si.rowcount( )

//remove filter
idw_serial_numbers.setfilter( "")
idw_serial_numbers.filter( )
idw_serial_numbers.rowcount( )
end subroutine

public function boolean wf_is_sku_foot_print (string as_sku, string as_supp_code);//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count
//check - Is SKU related to Foot Print?

string lsFind, ls_serialized_Ind, ls_pono2_Ind, ls_container_Ind
long ll_count, llFindRow
boolean lb_FootPrint = FALSE

//check above SKU is Foot Print?
ll_count = i_nwarehouse.of_item_master( gs_project, as_sku, as_supp_code)

lsFind ="Project_Id ='"+gs_project+"' and sku ='"+as_sku+"' and supp_code = upper('"+as_supp_code+"')"
llFindRow = i_nwarehouse.ids.find( lsFind, 1, i_nwarehouse.ids.rowcount())

If llFindRow > 0 Then
	ls_pono2_Ind = i_nwarehouse.ids.getItemString(llFindRow, 'PO_No2_Controlled_Ind')
	ls_container_Ind = i_nwarehouse.ids.getItemString(llFindRow, 'Container_Tracking_Ind')
	ls_serialized_Ind = i_nwarehouse.ids.getItemString(llFindRow, 'Serialized_Ind')
	
	//10SEPT-2018 :MEA S23046 F9270 - I1304 - Google - SIMS Footprints Containerization - Outbound
	//Use Foot_Prints_Ind Flag

	/* (ls_serialized_Ind ='B'  and ls_pono2_Ind ='Y' and ls_container_Ind ='Y')*/
	
	If  f_is_sku_foot_print( as_sku, as_supp_code)  Then
		lb_FootPrint = TRUE
	else
		lb_FootPrint = FALSE
	End If
END IF

Return lb_FootPrint
end function

public function integer wf_check_status_container ();//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count
//04-June-2018 :Madhu S19881 - Removed Order Type ='X', should work for all CC Order Type

string ls_Ord_Status, ls_Ord_Type, lsFind, ls_sku, ls_supp_code
long ll_FindRow


//Get Order Status
ls_Ord_Status 	= idw_main.getItemString( 1, 'Ord_status')
ls_Ord_Type =  idw_main.getItemString( 1, 'Ord_type')

IF upper(gs_project) ='PANDORA'  and idw_si.rowcount() > 0  and upper(ls_Ord_Status) <> 'V' THEN

	//Serialized SKU should have only one SKU.
	lsFind ="Count_Type ='S'"
	ll_FindRow = idw_system_generated.find( lsFind, 1, idw_system_generated.rowcount( ))
	
	If ll_FindRow > 0 Then
		ls_sku = idw_system_generated.getItemString( ll_FindRow, 'Count_Value')
		
		//get Supplier value from System Inventory
		lsFind ="upper(sku) ='"+ls_sku+"'"
		ll_FindRow = idw_si.find( lsFind, 1, idw_si.rowcount())
		If ll_FindRow > 0 Then ls_supp_code = idw_si.getItemString( ll_FindRow, 'supp_code')  //Get appropriate Supp Code 
		
		ib_Foot_Print_SKU = wf_is_sku_foot_print(ls_sku, ls_supp_code) 		//Is SKU Foot Print?
	else
		ib_Foot_Print_SKU = FALSE
	END IF
	
	//If SKU is FootPrint
	If ib_Foot_Print_SKU THEN
			//Protect Quantity field on 3rd Count for Foot Print
			idw_result3.modify("quantity.protect =1")
			idw_result3.modify( "po_no2.protect =1")
			idw_result3.modify( "container_id.protect =1")
			idw_main.setItem( 1, 'Count3_Rollup_Code', wf_build_encoded_rollup_code(5)) //Set RolledUp by 3rd Count

			 if upper(ls_Ord_Status) = '3' Then
				
				//Make Visible/Enable FP_Container Tab
				tab_main.tabpage_container.visible=true
				tab_main.tabpage_container.Enabled=true
				tab_main.tabpage_container.dw_cc_container.visible =true
				tab_main.tabpage_container.cb_4.enabled=true
				tab_main.tabpage_container.cb_5.enabled=true
				tab_main.tabpage_container.cb_6.enabled=true
				
				//Make Visible/Enable Serial Tab
				tab_main.tabpage_serial_numbers.visible =true
				tab_main.tabpage_serial_numbers.enabled =true				
				tab_main.tabpage_serial_numbers.dw_serial_numbers.Modify( "container_id_t.visible =TRUE container_id.visible =TRUE")
	
			elseif upper(ls_Ord_Status) = 'C' Then
				
				//Make Visible/Enable FP_Container Tab
				tab_main.tabpage_container.visible=true
				tab_main.tabpage_container.Enabled=true
				tab_main.tabpage_container.cb_4.enabled=false
				tab_main.tabpage_container.cb_5.enabled=false
				tab_main.tabpage_container.cb_6.enabled=false
				tab_main.tabpage_container.dw_cc_container.Object.Datawindow.ReadOnly = True
				
				//Make Visible/Enable Serial Tab
				tab_main.tabpage_serial_numbers.visible =true
				tab_main.tabpage_serial_numbers.enabled =true
				tab_main.tabpage_serial_numbers.dw_serial_numbers.Modify( "container_id_t.visible =TRUE container_id.visible =TRUE")
			else
				//Make Non-Visible FP_Container Tab
				tab_main.tabpage_container.visible=false
				
				//Make Non-Visible Serial Tab
				tab_main.tabpage_serial_numbers.visible =false
			end if
			
		else
			idw_result3.modify("quantity.protect =0")
			idw_result3.modify( "po_no2.protect =0")
			idw_result3.modify( "container_id.protect =0")

			tab_main.tabpage_container.visible =FALSE
			tab_main.tabpage_container.enabled =FALSE
	End If
ELSE
	idw_result3.modify("quantity.protect =0")
	idw_result3.modify( "po_no2.protect =0")
	idw_result3.modify( "container_id.protect =0")

	tab_main.tabpage_container.visible =FALSE
	tab_main.tabpage_container.enabled =FALSE
END IF

Return 0
end function

public function integer wf_find_foot_print_container_on_count3 (long al_row);//25-APR-2018 :Madhu S18502 - FootPrint Cycle Count
//Find matching Container Id on 3rd Count.

string ls_sku, ls_loc, ls_container_Id, lsFind, ls_wh_code
long ll_container_qty, llFindRow, ll_SN_count, ll_serial_count
long ll_container_count, ll_count3_qty, ll_count3_sys_qty, llFindSysRow
boolean lb_discrepancy, lb_populate_SN

ls_wh_code = idw_main.getItemString( 1, 'wh_code')
ll_container_count = idw_cc_container.rowcount( )

//get respective row values from FP_Container Tab
ls_sku = idw_cc_container.getItemString( al_row, 'sku')
ls_loc =idw_cc_container.getItemString( al_row, 'l_code')
ls_container_Id = idw_cc_container.getItemString( al_row, 'container_id')
ll_container_qty = idw_cc_container.getItemNumber( al_row, 'quantity')


//find matching container Id on 3rd Count Records
lsFind ="sku ='"+ls_sku+"' and l_code ='"+ls_loc+"' and container_Id ='"+ls_container_Id+"'"
llFindRow = idw_result3.find( lsFind, 1, idw_result3.rowcount())

IF llFindRow > 0 Then 
	ll_count3_qty = idw_result3.getItemNumber( llFindRow, 'quantity')
	ll_count3_sys_qty = idw_result3.getItemNumber( llFindRow, 'sysquantity')
	
	//If sysquantity =0, find a record on System Inventory tab
	IF ll_count3_sys_qty = 0 THEN
		lsFind ="sku='"+idw_result3.getItemString( llFindRow, 'sku')+"' and supp_Code ='"+idw_result3.getItemString( llFindRow, 'supp_code')+"'" 
		lsFind += " and Owner_Id ="+string(idw_result3.getItemNumber( llFindRow, 'owner_id'))+" and l_code ='"+idw_result3.getItemString( llFindRow, 'l_code')+"'"
		lsFind += " and Po_No2 ='"+idw_result3.getItemString( llFindRow, 'po_no2')+"' and Container_Id ='"+idw_result3.getItemString( llFindRow, 'container_id')+"'"
				
		llFindSysRow = idw_si.find( lsFind, 1, idw_si.rowcount() +1 )
		IF llFindSysRow > 0 THEN	ll_count3_sys_qty = idw_si.getItemNumber( llFindSysRow, 'quantity')
	END IF	

	//Compare Count_3.QTY v/s Container_Id.QTY
	IF IsNull(ll_count3_qty) Then ll_count3_qty =0
	
	IF ((ll_count3_qty = 0) OR (ll_count3_qty = ll_container_qty)) THEN
		idw_result3.setItem( llFindRow, 'quantity', ll_container_qty)  //update Count_3.QTY
		ll_count3_qty = ll_container_qty
	END IF
	
	IF ll_count3_qty > ll_container_qty and ll_count3_qty > 0  THEN
		idw_cc_container.setItem( al_row, 'discrepancy', 'Y')
		MessageBox("Foot Print CC", "3rd Count quantity ( "+string(ll_count3_qty)+" ) is higher than Imported Container QTY ( "+ string(ll_container_qty)+" )  against Container Id# "+ls_container_Id+". Please update accordingly!")
		Return -1
	ELSEIF ll_count3_qty < ll_container_qty and ll_count3_qty > 0  THEN
		idw_cc_container.setItem( al_row, 'discrepancy', 'Y')
		MessageBox("Foot Print CC", "3rd Count quantity ( "+string(ll_count3_qty)+" ) is lesser than Imported Container QTY ( "+ string(ll_container_qty)+" )  against Container Id# "+ls_container_Id+". Please update accordingly!")
		Return -1
	END IF

	//Set Discrepancy flag value.
	IF ll_count3_qty <> ll_count3_sys_qty THEN
		idw_cc_container.setItem( al_row, 'discrepancy', 'Y')
	ELSE
		idw_cc_container.setItem( al_row, 'discrepancy', 'N')
	END IF
	
ELSE
	idw_cc_container.setItem( al_row, 'discrepancy', 'Y') //No Record found.
END IF


Return 0
end function

public function integer wf_validate_save_foot_print_containers ();//25-APR-2018 :Madhu S18502 - FootPrint Cycle Count

long ll_row, ll_container_count
dwItemStatus ls_dw_status_sku, ls_dw_status_loc, ls_dw_status_container, ls_dw_status_qty

ll_container_count = idw_cc_container.rowcount( )

//Loop through each FP_Container Tab records
For ll_row =1 to ll_container_count

	ls_dw_status_sku = idw_cc_container.getItemStatus( ll_row, 'sku', Primary!)
	ls_dw_status_loc = idw_cc_container.getItemStatus( ll_row, 'l_code', Primary!)
	ls_dw_status_container = idw_cc_container.getItemStatus( ll_row, 'container_id', Primary!)
	ls_dw_status_qty = idw_cc_container.getItemStatus( ll_row, 'quantity', Primary!)
	
	If ls_dw_status_sku =DataModified! or ls_dw_status_loc =DataModified! or ls_dw_status_container =DataModified! or ls_dw_status_qty =DataModified! Then
		//Find Foot Print Container Id on Count 3 Tab.
		If this.wf_find_foot_print_container_on_count3( ll_row) < 0 Then Return -1
	End If
NEXT

//validate & populate container Id associated Serial No's.
this.wf_process_foot_print_container_serials( )

Return 0
end function

public function integer wf_process_foot_print_container_serials ();//25-APR-2018 :Madhu S18502 - FootPrint Cycle Count

//a. get count(SNI) records against Container Id from Serial Number Inventory Table.
//b. If SNI Count = Container_Id.QTY = 3rd count QTY, populate all Serial No's onto Serial Tab else NO.

string ls_sku, ls_loc, ls_container_Id, lsFind, ls_wh_code
long ll_container_qty, llFindRow, ll_row, ll_SN_count, ll_count3_row
long ll_container_count, ll_count3_qty
boolean lb_populate_SN

ls_wh_code = idw_main.getItemString( 1, 'wh_code')
ll_container_count = idw_cc_container.rowcount( )

//Loop through each Container record
For ll_row =1 to ll_container_count 
	ls_sku = idw_cc_container.getItemString( ll_row, 'sku')
	ls_loc =idw_cc_container.getItemString( ll_row, 'l_code')
	ls_container_Id = idw_cc_container.getItemString( ll_row, 'container_id')
	ll_container_qty = idw_cc_container.getItemNumber( ll_row, 'quantity')
	
	//1. get count(Serial No) from SNI Table
	SELECT count(*) into :ll_SN_count FROM Serial_Number_Inventory with(nolock)
	WHERE Project_Id =:gs_project and wh_code =:ls_wh_code 
	and sku =:ls_sku and l_code =:ls_loc and Carton_Id =:ls_container_Id
	using sqlca;
	
	//2. Find matching Container Id on 3rd Count.
	lsFind = "sku='"+ls_sku+"' and l_code ='"+ls_loc+"' and container_Id='"+ls_container_Id+"'"
	ll_count3_row = idw_result3.find( lsFind, 1, idw_result3.rowcount())
	
	//2(a). get 3rd Count QTY
	If ll_count3_row > 0 Then ll_count3_qty = idw_result3.getItemNumber( ll_count3_row, 'quantity')
	If IsNull(ll_count3_qty) Then ll_count3_qty = 0
	
	//3. Populate SN
	IF (ll_container_qty = ll_SN_count)  and (ll_count3_qty = ll_container_qty)  THEN
		lb_populate_SN = true
		idw_cc_container.setItem( ll_row, 'discrepancy', 'N')
	ELSE
		lb_populate_SN = false
		idw_cc_container.setItem( ll_row, 'discrepancy', 'Y')
	END IF
	
	//3(a). populate Serial No's onto Serial Tab
	If lb_populate_SN Then 	this.wf_populate_foot_print_container_serial( ls_sku, ls_wh_code, ls_loc, ls_container_Id)

NEXT

Return 0
end function

public function integer wf_validate_save_foot_print_serials ();//28-APR-2018 :Madhu S18502 - FootPrint Cycle Count

string ls_sku, ls_loc, ls_container_Id, ls_prev_loc, ls_prev_containerId, lsFind, ls_cc_No
long ll_serial_count, ll_serial_qty, llFindRow, ll_container_Qty
long ll_row,  ll_container_count, ll_New_Row

ls_cc_No = idw_main.getItemString( 1, 'cc_no')

//Save Imported Serial No's.
ll_serial_count = idw_serial_numbers.rowcount( )

FOR ll_row = 1 to ll_serial_count
	ls_sku = idw_serial_numbers.getItemString( ll_row, 'sku')
	ls_loc = idw_serial_numbers.getItemString( ll_row, 'l_code')
	ls_container_Id =idw_serial_numbers.getItemString( ll_row, 'container_Id')
	
	//find matching container Id on 3rd Count Records
	lsFind ="sku ='"+ls_sku+"' and l_code ='"+ls_loc+"' and container_Id ='"+ls_container_Id+"'"
	llFindRow = idw_result3.find( lsFind, 1, idw_result3.rowcount())
	
	IF llFindRow =0 Then
		MessageBox("Foot Print CC", "Following Container Id# "+ls_container_Id+"  doesn't exist on 3rd Count. Please Insert Valid Container Id's")
		Return -1
	END IF

	IF 	ls_prev_loc <> ls_loc or ls_prev_containerId <> ls_container_Id THEN
	
		//get No. of serial records of same SKU, Loc, Container Id
		idw_serial_numbers.setfilter( lsFind)
		idw_serial_numbers.filter( )
		ll_serial_qty =idw_serial_numbers.rowcount( ) //get last row of container Id.
		
		this.wf_remove_filter( ) //Remove filter
		
		//find a corresponding record on Container Tab
		llFindRow = idw_cc_container.find( lsFind, 1, idw_cc_container.rowcount())
		
		IF llFindRow > 0 Then 
			ll_container_Qty = idw_cc_container.getItemNumber( llFindRow, 'quantity')
		ELSE
			ll_container_Qty = 0
		END IF

		//Compare Serial No's count v/s Container QTY
		//A. SN Count > Container Id QTY
		IF (ll_serial_qty > ll_container_Qty) and (ll_container_Qty > 0) THEN
			idw_cc_container.setItem(llFindRow, 'quantity', ll_serial_qty) //Increment (Update) QTY
		END IF
		
		//B. SN Count < Container Id QTY
		IF (ll_serial_qty < ll_container_Qty) and (ll_container_Qty > 0) THEN
			idw_cc_container.setItem(llFindRow, 'quantity', ll_serial_qty) //Increment (Update) QTY
		END IF
		
		//C. Container Id Qty =0 and SN Count > 0
		IF (ll_serial_qty > ll_container_Qty) and (ll_container_Qty = 0) THEN
			ll_container_count = idw_cc_container.rowcount( )
			ll_New_Row = idw_cc_container.insertrow( ll_container_count +1)
			
			idw_cc_container.setItem(ll_New_Row, 'cc_no', ls_cc_no)
			idw_cc_container.setItem(ll_New_Row, 'sku', ls_sku)
			idw_cc_container.setItem(ll_New_Row, 'l_code', ls_loc)
			idw_cc_container.setItem(ll_New_Row, 'container_Id', ls_container_Id)
			idw_cc_container.setItem(ll_New_Row, 'quantity', ll_serial_qty)
		END IF
		
		//D. Update 3rd Count QTY..
		llFindRow = idw_result3.find( lsFind, 1, idw_result3.rowcount())
		IF llFindRow > 0 Then idw_result3.setItem(llFindRow , 'quantity', ll_serial_qty)
		
		//Previous values
		ls_prev_loc = ls_loc
		ls_prev_containerId = ls_container_Id
	END IF
NEXT

Return 0
end function

public function integer wf_change_color_of_discrepancy_serials ();//28-APR-2018 :Madhu S18502 - FootPrint Cycle Count
//a. Get any discrepancy Container Id on Container Tab.
//b. If Yes, find appropriate Serial No's on Serial Tab and apply discrepancy too.

string ls_sku, ls_loc, ls_containerId, lsFind
long ll_row, ll_serial_count, ll_serial_row

IF ib_Foot_Print_SKU and idw_cc_container.rowcount( ) > 0 THEN
	For ll_row = 1 to idw_cc_container.rowcount( )
		IF idw_cc_container.getItemString( ll_row, 'discrepancy') ='Y' THEN
			ls_sku = idw_cc_container.getItemString( ll_row,'sku')
			ls_loc = idw_cc_container.getItemString( ll_row,'l_code')
			ls_containerId = idw_cc_container.getItemString( ll_row,'container_Id')
			
			lsFind = "sku ='"+ls_sku+"' and l_code ='"+ls_loc+"' and container_Id ='"+ls_containerId+"'"
			idw_serial_numbers.setfilter( lsFind)
			idw_serial_numbers.filter( )
			ll_serial_count = idw_serial_numbers.rowcount( )
			
			For ll_serial_row = 1 to idw_serial_numbers.rowcount( )
				idw_serial_numbers.setItem( ll_serial_row, 'selected', 'Y')
			Next
		END IF
	NEXT
END IF

this.wf_remove_filter( ) //Remove filter, if any
	
Return 0
end function

public function integer wf_populate_foot_print_container_serial (string as_sku, string as_wh_code, string as_loc, string as_container_id);//25-APR-2018 :Madhu S18502 - FootPrint Cycle Count
//Populate Serial No's onto Serial Tab

string ls_sql, ls_errors, lsFind, ls_serial_no, ls_cc_no
long ll_row, ll_count, llFindRow, ll_SN_Row
Datastore lds_serial

SetPointer(Hourglass!)

ls_cc_no = idw_main.getItemString(1, 'cc_no')

lds_serial = create Datastore
ls_sql =" SELECT * FROM Serial_Number_Inventory with(nolock) "
ls_sql += " WHERE Project_Id ='"+gs_project+"' and wh_code= '"+as_wh_code+"'"
ls_sql += " and sku ='"+as_sku+"' and l_code ='"+as_loc+"' and carton_Id ='"+as_container_Id+"'"

lds_serial.create( SQLCA.syntaxfromsql( ls_sql, "", ls_errors))
lds_serial.settransobject( SQLCA)
ll_count =lds_serial.retrieve( )

For ll_row =1 to ll_count
	ls_serial_no = lds_serial.getItemString( ll_row, 'serial_no')
	
	lsFind ="sku ='"+as_sku+"' and l_code ='"+as_loc+"' and serial_no ='"+ls_serial_no+"' and container_Id ='"+as_container_Id+"'"
	llFindRow = idw_serial_numbers.find( lsFind, 1, idw_serial_numbers.rowcount())
	
	//Insert a SN record onto Serial Tab
	IF llFindRow = 0 Then
		ll_SN_Row = idw_serial_numbers.insertrow( 0)
		idw_serial_numbers.setItem( ll_SN_Row, 'cc_no', ls_cc_no)
		idw_serial_numbers.setItem( ll_SN_Row, 'sku', as_sku)
		idw_serial_numbers.setItem( ll_SN_Row, 'l_code', as_loc)
		idw_serial_numbers.setItem( ll_SN_Row, 'serial_no', ls_serial_no)
		idw_serial_numbers.setItem( ll_SN_Row, 'container_id', as_container_Id)
	End IF
Next

tab_main.tabpage_serial_numbers.dw_serial_numbers.visible =TRUE

destroy lds_serial

Return 0
end function

public function integer wf_reveal_matched_container_on_count3 ();//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count
string ls_sku, ls_loc, ls_containerId, lsFind, ls_cc_no, ls_matched
long 	ll_row,	llFindRow

IF ib_Foot_Print_SKU and idw_cc_container.rowcount( ) > 0 THEN
	
	ls_cc_no = idw_main.getItemString( 1, 'cc_no')
	
	For ll_row =1 to idw_result3.rowcount( )
		ls_sku = idw_result3.getitemstring( ll_row, 'sku')
		ls_loc = idw_result3.getitemstring( ll_row, 'l_code')
		ls_containerId = idw_result3.getitemstring( ll_row, 'container_Id')
		
		lsFind ="sku ='"+ls_sku+"' and l_code ='"+ls_loc+"' and container_Id ='"+ls_containerId+"'"
		llFindRow = idw_cc_container.find( lsFind, 1, idw_cc_container.rowcount())
		
		IF llFindRow > 0 Then
			idw_result3.setItem(ll_row, 'matched', 'Y')
		else
			idw_result3.setItem(ll_row, 'matched', 'N')
		End If
	Next

ELSEIF ib_Foot_Print_SKU and idw_result3.rowcount( ) > 0 THEN
	For ll_row = 1 to idw_result3.rowcount()
		idw_result3.setItem(ll_row, 'matched', 'N')
	Next
ELSE
	For ll_row = 1 to idw_result3.rowcount()
		idw_result3.setItem(ll_row, 'matched', 'Y')
	Next
END IF

idw_result3.setredraw( true)

Return 0
end function

public function integer dovalidatecontainerids (datawindow _dw);//30-APR-2018 :Madhu S18502 - FootPrint Cycle Count

Integer index, max, dwtabpage
string sku, location, container_Id, filterThis, findThis
boolean foundError
long	foundRow
dwitemstatus	lStatus

dwTabPage = getTabpageForDw(  _dw )

founderror = false

_dw.setredraw( false )

max = _dw.RowCount()
if max = 0 then return 0
For index = 1 to max 
	lStatus = _dw.getItemStatus( index, 0, primary! )
	choose case lStatus
		case New!
			// change the status to newmodified to save the row.
			_dw.setItemStatus( index, 0, primary!, NewModified! )
			continue
		case NotModified!
			continue
	end choose
	sku = _dw.object.sku[ index ]
	location = Trim( _dw.object.l_code[ index ] )
	container_Id = Trim( _dw.object.container_Id[ index ] )


// Check if valid location on System Inventory
	findThis = "l_code = ~'" + location + "~'"
	foundrow = idw_si.find( 	findThis, 1, idw_si.rowcount() )
	if foundRow <= 0 then
		// dts 08/10/10 for Pandora, need to allow 'ALLOCATED' to be a valid location on the cycle count.
		if not (Upper(gs_project) = 'PANDORA' and (Left(upper(Location), 9) = 'ALLOCATED' or upper(Location) = 'NO_COUNT' )) then	// LTK 20140807  Pandora #882 change
			MessageBox(is_title, "Location is not found in System Inventory, please re-enter!") 
			tab_main.selecttab( 9 )
			f_setfocus( _dw, index, "l_code")	
			foundError = true
			exit
		end if
	end if
	
// Check if valid SKU on System Inventory
	findThis = "SKU = ~'" + SKU + "~'"
	foundrow = idw_si.find( 	findThis, 1, idw_si.rowcount() )
	if foundRow <= 0 then
		// dts 08/10/10 for Pandora, need to allow 'ALLOCATED' to be a valid location on the cycle count.
		if not (Upper(gs_project) = 'PANDORA' and (Left(upper(Location), 9) = 'ALLOCATED' or upper(Location) = 'NO_COUNT' )) then	// LTK 20140807  Pandora #882 change
			MessageBox(is_title, "SKU is not found in System Inventory, please re-enter!") 
			tab_main.selecttab( 9 )
			f_setfocus( _dw, index, "sku")	
			foundError = true
			exit
		end if
	end if

//Check if valid container on System Inventory
	findThis = "container_id = ~'" + container_id + "~'"
	foundrow = idw_si.find( 	findThis, 1, idw_si.rowcount() )
		if foundRow <= 0 then
		// dts 08/10/10 for Pandora, need to allow 'ALLOCATED' to be a valid location on the cycle count.
		if not (Upper(gs_project) = 'PANDORA' and (Left(upper(Location), 9) = 'ALLOCATED' or upper(Location) = 'NO_COUNT' )) then	// LTK 20140807  Pandora #882 change
			MessageBox(is_title, "Container Id is not found in System Inventory, please re-enter!") 
			tab_main.selecttab( 9 )
			f_setfocus( _dw, index, "container_id")	
			foundError = true
			exit
		end if
	end if
	
	//Check for duplicate entry
	findThis = "SKU = ~'" + SKU + "~' and l_code = ~'" + location + "~' and container_id = ~'" + container_id + "~'"
	foundrow = idw_cc_container.find( 	findThis, 1, idw_cc_container.rowcount() )
	if foundRow < idw_cc_container.rowcount( ) then
		foundrow = idw_cc_container.find( 	findThis, foundrow+1, idw_cc_container.rowcount()+1 )
		
		if foundRow >  1 Then
			if not (Upper(gs_project) = 'PANDORA' and (Left(upper(Location), 9) = 'ALLOCATED' or upper(Location) = 'NO_COUNT' )) then	// LTK 20140807  Pandora #882 change
				MessageBox(is_title, "SKU /Loc / Container Id found has a duplicate, please re-enter!") 
				tab_main.selecttab( 9 )
				f_setfocus( _dw, index, "container_id")	
				foundError = true
				exit
			end if
		end if
	end if	
		
next
_dw.setredraw( true )

if foundError then return -1
return 0

end function

public function integer wf_get_count_of_serial_no (string as_find);//30-APR-2018 :Madhu S18502 - FootPrint Cycle Count
//Return count(serial No) on Serial No Tab based on criteria

long ll_count, llFindRow, llNextFindRow

IF idw_serial_numbers.rowcount( ) > 0 THEN
	
	llFindRow = idw_serial_numbers.find( as_find, 1, idw_serial_numbers.rowcount())
	
	DO WHILE llFindRow > 0
		ll_count++
		llNextFindRow = llFindRow
		llFindRow = idw_serial_numbers.find( as_find, llNextFindRow +1, idw_serial_numbers.rowcount() +1)
	LOOP
END IF

Return ll_count
end function

public function integer wf_generate_up_count_zero_records (datawindow _dw, integer ai_count_tab);//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
string lsFilter
long ll_New_Row, ll_row, ll_Null

lsFilter ="up_count_zero ='Y'"
idw_result1.setfilter(lsFilter)
idw_result1.filter( )

idw_result2.setfilter( lsFilter)
idw_result2.filter( )

setNull(ll_Null)

//copy up_count_zero rows from Count1 Tab to Count2 Tab.
If ai_count_tab = CC_RESULTS2_TAB and idw_result1.rowcount( ) > 0 Then

		For ll_row =1 to idw_result1.rowcount( )
			ll_New_Row = _dw.InsertRow(0)
			_dw.setItem(ll_New_Row, 'cc_no', idw_result1.getItemstring(ll_row, 'cc_no'))
			_dw.setItem(ll_New_Row, 'sku', idw_result1.getItemstring(ll_row, 'SKU'))
			_dw.setItem(ll_New_Row, 'l_code', idw_result1.getItemstring(ll_row, 'L_Code'))
			_dw.setItem(ll_New_Row, 'inventory_type', idw_result1.getItemstring(ll_row, 'Inventory_Type'))
			_dw.setItem(ll_New_Row, 'serial_no', idw_result1.getItemstring(ll_row, 'Serial_No'))
			_dw.setItem(ll_New_Row, 'lot_no', idw_result1.getItemstring(ll_row, 'Lot_No'))
			_dw.setItem(ll_New_Row, 'po_no', idw_result1.getItemstring(ll_row, 'PO_No'))
			_dw.setItem(ll_New_Row, 'quantity', ll_Null)
			_dw.setItem(ll_New_Row, 'supp_code', idw_result1.getItemstring(ll_row, 'Supp_Code'))
			_dw.setItem(ll_New_Row, 'owner_id', idw_result1.getItemNumber(ll_row, 'Owner_ID'))
			_dw.setItem(ll_New_Row, 'country_of_origin', idw_result1.getItemstring(ll_row, 'Country_of_Origin'))
			_dw.setItem(ll_New_Row, 'po_no2', idw_result1.getItemstring(ll_row, 'PO_No2'))
			_dw.setItem(ll_New_Row, 'container_id', idw_result1.getItemstring(ll_row, 'container_ID'))
			_dw.setItem(ll_New_Row, 'expiration_date', idw_result1.getItemdatetime(ll_row, 'Expiration_Date'))
			_dw.setItem(ll_New_Row, 'sysinvmatch', 'N')
			_dw.setItem(ll_New_Row, 'sysQuantity', 0)
			_dw.setItem(ll_New_Row, 'line_item_no', idw_result1.getItemNumber(ll_row, 'line_item_no'))
			_dw.setItem(ll_New_Row, 'alternate_sku', idw_result1.getItemstring(ll_row, 'Alternate_SKU'))
			_dw.setItem(ll_New_Row, 'ro_no', idw_result1.getItemstring(ll_row, 'Ro_No'))
			_dw.setItem(ll_New_Row, 'uom_1', idw_result1.getItemstring(ll_row, 'UOM_1'))
			_dw.setItem(ll_New_Row, 'grp', idw_result1.getItemstring(ll_row, 'GRP'))
			_dw.setItem(ll_New_Row, 'up_count_zero', idw_result1.getItemstring(ll_row, 'Up_Count_Zero'))
		Next
End If


//copy up_count_zero rows from Count2 Tab to Count3 Tab.
If ai_count_tab = CC_RESULTS3_TAB and idw_result2.rowcount( ) > 0 Then
		For ll_row =1 to idw_result1.rowcount( )
			ll_New_Row = _dw.InsertRow(0)
			_dw.setItem(ll_New_Row, 'cc_no', idw_result2.getItemstring(ll_row, 'cc_no'))
			_dw.setItem(ll_New_Row, 'sku', idw_result2.getItemstring(ll_row, 'SKU'))
			_dw.setItem(ll_New_Row, 'l_code', idw_result2.getItemstring(ll_row, 'L_Code'))
			_dw.setItem(ll_New_Row, 'inventory_type', idw_result2.getItemstring(ll_row, 'Inventory_Type'))
			_dw.setItem(ll_New_Row, 'serial_no', idw_result2.getItemstring(ll_row, 'Serial_No'))
			_dw.setItem(ll_New_Row, 'lot_no', idw_result2.getItemstring(ll_row, 'Lot_No'))
			_dw.setItem(ll_New_Row, 'po_no', idw_result2.getItemstring(ll_row, 'PO_No'))
			_dw.setItem(ll_New_Row, 'quantity', ll_Null)
			_dw.setItem(ll_New_Row, 'supp_code', idw_result2.getItemstring(ll_row, 'Supp_Code'))
			_dw.setItem(ll_New_Row, 'owner_id', idw_result2.getItemNumber(ll_row, 'Owner_ID'))
			_dw.setItem(ll_New_Row, 'country_of_origin', idw_result2.getItemstring(ll_row, 'Country_of_Origin'))
			_dw.setItem(ll_New_Row, 'po_no2', idw_result2.getItemstring(ll_row, 'PO_No2'))
			_dw.setItem(ll_New_Row, 'container_id', idw_result2.getItemstring(ll_row, 'container_ID'))
			_dw.setItem(ll_New_Row, 'expiration_date', idw_result2.getItemdatetime(ll_row, 'Expiration_Date'))
			_dw.setItem(ll_New_Row, 'sysinvmatch', 'N')
			_dw.setItem(ll_New_Row, 'sysQuantity', 0)
			_dw.setItem(ll_New_Row, 'line_item_no', idw_result2.getItemNumber(ll_row, 'line_item_no'))
			_dw.setItem(ll_New_Row, 'alternate_sku', idw_result2.getItemstring(ll_row, 'Alternate_SKU'))
			_dw.setItem(ll_New_Row, 'ro_no', idw_result2.getItemstring(ll_row, 'Ro_No'))
			_dw.setItem(ll_New_Row, 'uom_1', idw_result2.getItemstring(ll_row, 'UOM_1'))
			_dw.setItem(ll_New_Row, 'grp', idw_result2.getItemstring(ll_row, 'GRP'))
			_dw.setItem(ll_New_Row, 'up_count_zero', idw_result2.getItemstring(ll_row, 'Up_Count_Zero'))
		Next
End If

wf_remove_result_filter() //Remove filter

Return 0
end function

public function integer wf_remove_result_filter ();//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
//Remove filter from Results

idw_result1.setfilter( "")
idw_result1.filter( )

idw_result2.setfilter( "")
idw_result2.filter( )

idw_result3.setfilter( "")
idw_result3.filter( )

Return 0
end function

public function integer wf_find_up_count_zero_sku_loc (string as_type, string as_sku_loc);//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
//find sku /location on Count3 /Count2/ Count1 tab of up_count_zero

string lsFind
long llFindRow

CHOOSE CASE upper(as_type)
	CASE 'LOC'
		lsFind = "l_code = '" + as_sku_loc + "' and up_count_zero='Y'"
	CASE 'SKU'
		lsFind = "sku = '" + as_sku_loc + "' and up_count_zero='Y'"		
END CHOOSE

//find a record on count Tab's
llFindRow = idw_result3.find( lsFind, 1, idw_result3.rowcount())
IF llFindRow = 0 Then  llFindRow = idw_result2.find( lsFind, 1, idw_result2.rowcount())
IF llFindRow = 0 Then  llFindRow = idw_result1.find( lsFind, 1, idw_result1.rowcount())

Return llFindRow
end function

public function integer wf_create_up_count_zero_cc_records ();//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
//create Up Count Zero Records

string lsFilter
int liRowCnt

SetPointer(Hourglass!)

//Up Count Zero Result
IF Not Isvalid(ids_CC_UpCountZero_Result) Then
	ids_CC_UpCountZero_Result = create Datastore
	ids_CC_UpCountZero_Result.dataobject ='d_cc_up_count_zero_result'
End IF

lsFilter ="up_count_zero ='Y'"

//find up_count_zero records on Count3
idw_result3.setfilter( lsFilter)
idw_result3.filter( )

//find up_count_zero records on Count2
idw_result2.setfilter( lsFilter)
idw_result2.filter( )

//find up_count_zero records on Count1
idw_result1.setfilter( lsFilter)
idw_result1.filter( )

//store onto Up Count Zero data store
IF idw_result3.rowcount( ) > 0 Then	
	idw_result3.rowscopy( idw_result3.getRow(), idw_result3.Rowcount(), Primary!, ids_CC_UpCountZero_Result, 1, Primary!) //copy from Count3
	
elseIf idw_result3.rowcount( ) = 0 and idw_result2.rowcount( ) > 0 Then
	idw_result2.rowscopy( idw_result2.getRow(), idw_result2.Rowcount(), Primary!, ids_CC_UpCountZero_Result, 1, Primary!) //copy from Count2
	
elseIf idw_result3.rowcount( ) = 0 and idw_result2.rowcount( ) = 0 and idw_result1.rowcount( ) > 0 Then
	idw_result1.rowscopy( idw_result1.getRow(), idw_result1.Rowcount(), Primary!, ids_CC_UpCountZero_Result, 1, Primary!) //copy from Count1
End IF

liRowCnt = ids_CC_UpCountZero_Result.rowcount( )

wf_remove_result_filter() //Remove filter

If liRowCnt > 0 Then			//DE16624 & DE16930 
	ib_up_count_zero_cc =TRUE
End If

Return 0
end function

public function boolean wf_is_sku_serialized (string as_sku, string as_supp_code);//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
//check - Is SKU Serialized ?

string lsFind, ls_serialized_Ind
long ll_count, llFindRow
boolean lb_serialized = FALSE

//check above SKU is Serialized?
ll_count = i_nwarehouse.of_item_master( gs_project, as_sku, as_supp_code)

lsFind ="Project_Id ='"+gs_project+"' and sku ='"+as_sku+"' and supp_code = upper('"+as_supp_code+"')"
llFindRow = i_nwarehouse.ids.find( lsFind, 1, i_nwarehouse.ids.rowcount())

If llFindRow > 0 Then
	ls_serialized_Ind = i_nwarehouse.ids.getItemString(llFindRow, 'Serialized_Ind')
	
	If  (ls_serialized_Ind ='B'  or ls_serialized_Ind ='Y')  Then
		lb_serialized = TRUE
	else
		lb_serialized = FALSE
	End If
END IF

Return lb_serialized
end function

public function long getsysinventorymaxlineitemno ();//18-JUNE-2018 :Madhu S19286 - Up Count Zero For Non-Existing Inventory
//get Max(LineItemNo) value from Sys Inventory

long ll_row, ll_line_item_no, ll_prev_line_item_no, ll_max_line_item_no

For ll_row = 1 to idw_si.rowcount( )
	
	ll_line_item_no = idw_si.getItemNumber( ll_row, 'line_item_no')
	
	IF ll_prev_line_item_no < ll_line_item_no THEN
		
		ll_max_line_item_no = ll_line_item_no
		
	else
		
		ll_max_line_item_no = ll_prev_line_item_no
		
	END IF
	
	ll_prev_line_item_no = ll_line_item_no
	
Next

Return ll_max_line_item_no
end function

public function boolean wf_is_up_count_location_empty (string as_sku, string as_loc);//20-JUNE-2018 :Madhu S19286  DE4885- Up Count from Empty Locations (Non-Existing Inventory)

string ls_wh_code
long ll_count

ls_wh_code = idw_main.getItemString( 1, 'wh_code')

select count(*) into :ll_count 
from content_summary with(nolock)
where Project_Id =:gs_project
and wh_code= :ls_wh_code
and sku =:as_sku and l_code =:as_loc
using sqlca;

If ll_count > 0 Then
	return true
else
	return false
End If
end function

public function integer dogeneratecountsheet (ref datawindow _dw, ref checkbox _cb);// doGenerateCountSheet( ref datawindow _dw )

long index
long innerIndex
long rows
long lRowCnt1, lRowCnt2, lRowCnt3
long lEmptyCnt1 = 0, lEmptyCnt2 = 0, lEmptyCnt3 = 0
long i = 0
long lNull
string countDateColumn
string count1Col= 'count1_complete'
string count2Col= 'count2_complete'
string count3Col= 'count3_complete'
string filterThis
datetime ldtToday
long ll_existing_count_row
string ls_count_rollup_code
string ls_count_1_rollup_code = 'Count1_Rollup_Code'
string ls_count_2_rollup_code = 'Count2_Rollup_Code'
string ls_count_3_rollup_code = 'Count3_Rollup_Code'
string ls_encoded_indicators, ls_filter
boolean adw_count
boolean lb_is_count_more_granular
int li_sibling_rows[]
String ls_siblings_processed[]
string ls_sibling_flag_column
ldtToday = f_getLocalWorldTime( getWarehouse() ) 

SetNull(lNull)

f_method_trace_special( gs_project, this.ClassName() , 'Start GenerateCountSheet ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

// LTK 20150508  Lot-able rollup
ls_encoded_indicators = wf_build_encoded_rollup_code( getCountTab() )

// ET3 2013-01-17  Pandora 542
// modify logic to require quantities be intentionally entered for each count prior to generating subsequent counts

lRowCnt1 = idw_result1.RowCount()
lRowCnt2 = idw_result2.RowCount()
lRowCnt3 = idw_result3.RowCount()

For i = 1 to lRowCnt1 
	// check for unset value
	If IsNull (idw_result1.GetItemNumber(i, 'quantity' ) ) Then lEmptyCnt1++
NEXT 

For i = 1 to lRowCnt2 
	// check for unset value
	If IsNull (idw_result2.GetItemNumber(i, 'quantity' ) ) Then lEmptyCnt2++
NEXT 

f_method_trace_special( gs_project, this.ClassName() , 'Process GenerateCountSheet to get current count Tab is:  ' + String(getCountTab()) ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

choose case getCountTab()
	case CC_RESULTS1_TAB  // tab results 1
		If lRowCnt2 > 0 Then
			MessageBox(is_title, "2nd count records exist, process failed!")
			return failure
		end if
		countDateColumn = count1Col
		ls_count_rollup_code = ls_count_1_rollup_code
	case CC_RESULTS2_TAB // tab results 2
		If lRowCnt1 < 1 OR lEmptyCnt1 > 0 then
			MessageBox(is_title, "Please complete 1st count first!!")
			return failure
		end if
		If lRowCnt3 > 0 Then
			MessageBox(is_title, "3rd count records exist, process failed!")
			return failure
		end If
		countDateColumn = count2Col
		ls_count_rollup_code = ls_count_2_rollup_code
		ls_sibling_flag_column = "count2_spread"
		lb_is_count_more_granular = wf_is_current_count_more_granular( idw_main.Object.Count1_Rollup_Code[1], wf_build_encoded_rollup_code( getCountTab() ) )

	case CC_RESULTS3_TAB // tab results 3
		If lRowCnt2 = 0 OR lEmptyCnt2 > 0 Then
			MessageBox(is_title, "Please complete 2nd count first!")
			return failure
		end if	
		countDateColumn = count3Col		
		ls_count_rollup_code = ls_count_3_rollup_code
		ls_sibling_flag_column = "count3_spread"
		lb_is_count_more_granular = wf_is_current_count_more_granular( idw_main.Object.Count2_Rollup_Code[1], wf_build_encoded_rollup_code( getCountTab() ) )

end choose

SetPointer(hourglass!)

rows = _dw.Rowcount()
If rows > 0 Then
	If MessageBox(is_title, "Remove existing records?", Question!, YesNo!, 2) = 2 Then	Return failure
	_dw.Setredraw(False)
	For index = rows to 1 Step -1
		_dw.DeleteRow( index )
	Next	
End If

w_main.SetMicroHelp("Generating Results...")

_dw.Setredraw(False)
idw_si.setRedraw( false )



// filter out the rows where the difference column is not zero
//if getCountTab() >3 then
//	if getCountDiff() = 'Y'  then 
//		filterThis = 'difference <> 0'
//		idw_si.setFilter( filterThis )
//		idw_si.filter()
//	end if
//end if
//
//NOV 2019 - MikeA F17679 S36894 I2538 - KNY - City of New York EM - Ability to Cycle Count Components
//APR 2020 - MikeA  DE15584 SIMS Defect - Not able to confirm an empty location cycle count

ls_filter = ""

if  upper(gs_project) ='NYCSP'  then
	IF _cb.checked = true then
		ls_filter = " "
	ELSE

		ls_filter = "inventory_type<>'8' "
	END IF 

Else
	
	ls_filter = " (component_no = 0 or isNull(component_no )) "
	

End IF

if getCountTab() >3 then
	if getCountDiff() = 'Y'  then 
		
		if trim(ls_filter) > '' then ls_filter = ls_filter + " and "
		
		ls_filter = ls_filter +  ' difference <> 0'
	end if
end if

idw_si.SetFilter(ls_filter) 
idw_si.filter()


//idw_si.SetFilter("")
//idw_si.filter()

rows = idw_si.RowCount()
f_method_trace_special( gs_project, this.ClassName() , 'Process GenerateCountSheet to get count of SI rows:  ' + String(rows) ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

For index = 1 to rows
	//  LTK 20150501  Attempt to find row in count datawindow that matches the current grouping
	ll_existing_count_row = wf_find_existing_count_row( _dw, index,  getCountTab() )

	if ll_existing_count_row > 0 then

//		_dw.object.quantity[ innerIndex ] = _dw.object.quantity[ innerIndex ] + idw_si.object.quantity[ index ]
//		if getBlindKnown() = 'K' then _dw.object.sysquantity[ innerIndex ] = _dw.object.sysquantity[ innerIndex ] + idw_si.object.quantity[ index ]
		_dw.object.quantity[ ll_existing_count_row ] = _dw.object.quantity[ ll_existing_count_row ] + idw_si.object.quantity[ index ]
		if getBlindKnown() = 'K' then _dw.object.sysquantity[ ll_existing_count_row ] = _dw.object.sysquantity[ ll_existing_count_row ] + idw_si.object.quantity[ index ]
		
	else

		innerIndex = _dw.InsertRow(0)
		_dw.object.line_item_no[ innerIndex] = idw_si.object.line_item_no[ Index] 
		_dw.object.sysinvmatch[ innerIndex ]  = 'N'
		_dw.object.cc_no[ innerIndex ] = idw_si.object.cc_no[ index ]
		_dw.object.sku[ innerIndex ] = idw_si.object.sku[ index ]
		_dw.object.quantity[ innerIndex ] = lNull  // force to Null on generation
		_dw.object.supp_code[ innerIndex ] = idw_si.object.supp_code[ index ]
		
		IF (Trim(Upper( idw_si.object.sku[ index ])) =  'EMPTY') AND getCountTab() = CC_RESULTS1_TAB Then
//			_dw.object.protected[ innerIndex ] = 1
		Else
			_dw.object.owner_id[ innerIndex ] = idw_si.object.owner_id[ index ]
		END IF 
		
		
		_dw.object.l_code[ innerIndex ] = idw_si.object.l_code[ index ]

	//	_dw.object.inventory_type[ innerIndex ] = idw_si.object.inventory_type[ index ]
	//	_dw.object.serial_no[ innerIndex ] = idw_si.object.serial_no[ index ]
	//	_dw.object.lot_no[ innerIndex ] = idw_si.object.lot_no[ index ]
	//	_dw.object.po_no[ innerIndex ] = idw_si.object.po_no[ index ]
	//	_dw.object.po_no2[ innerIndex ] = idw_si.object.po_no2[ index ]
	//	_dw.object.container_id[ innerIndex ] = idw_si.object.container_id[ index ]
	//	_dw.object.expiration_date[ innerIndex ] = idw_si.object.expiration_date[ index ]
	//	_dw.object.country_of_origin[ innerIndex ] = idw_si.object.country_of_origin[ index ]

		// LTK 20150508  Set the lot-able column if indicator is turned on, else value will be the dw default
		if wf_decode_indicators( ls_encoded_indicators, DECODE_SERIAL_NO ) then				
			_dw.object.serial_no[ innerIndex ] = idw_si.object.serial_no[ index ]
		end if
		if wf_decode_indicators( ls_encoded_indicators, DECODE_CONTAINER_ID ) then				
			_dw.object.container_id[ innerIndex ] = idw_si.object.container_id[ index ]
		end if
		if wf_decode_indicators( ls_encoded_indicators, DECODE_LOT_NO ) then				
			_dw.object.lot_no[ innerIndex ] = idw_si.object.lot_no[ index ]
		end if
		if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO ) then
			_dw.object.po_no[ innerIndex ] = idw_si.object.po_no[ index ]
		end if
		if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO2 ) then
			_dw.object.po_no2[ innerIndex ] = idw_si.object.po_no2[ index ]
		end if
		if wf_decode_indicators( ls_encoded_indicators, DECODE_EXP_DT ) then
			_dw.object.expiration_date[ innerIndex ] = idw_si.object.expiration_date[ index ]
		end if
		// NOTE: inventory type needs to be set for the print SQL to work.  Always set it and never set it to '-'
		//if wf_decode_indicators( ls_encoded_indicators, DECODE_INV_TYPE ) then
			_dw.object.inventory_type[ innerIndex ] = idw_si.object.inventory_type[ index ]
		//else
		//	_dw.object.inventory_type[ innerIndex ] = '-'					// Always set inventory type as there is no dw default
		//end if
		if wf_decode_indicators( ls_encoded_indicators, DECODE_COO ) then
			_dw.object.country_of_origin[ innerIndex ] = idw_si.object.country_of_origin[ index ]
		else
			_dw.object.country_of_origin[ innerIndex ] = 'XXX'			// Always set COO as there is no dw default
		end if

		_dw.object.alternate_sku[ innerIndex ] = idw_si.object.alternate_sku[ index ]	
	
		_dw.object.uom_1[ innerIndex ] = idw_si.object.uom_1[ index ]	
		_dw.object.grp[ innerIndex ] = idw_si.object.grp[ index ]	
		
	//	_dw.object.ro_no[ innerIndex ] = idw_si.object.ro_no[ index ]		
		if getBlindKnown() = 'K' then _dw.object.sysquantity[ innerIndex ] = idw_si.object.quantity[ index ]
	end if

	// LTK 20150608  Build sibling row array to be processed later
	if lb_is_count_more_granular and &
		 ( getCountTab() = CC_RESULTS2_TAB and idw_si.Object.count1_spread[ index ] = "Y" )  or &
		( getCountTab() = CC_RESULTS3_TAB and ( idw_si.Object.count1_spread[ index ] = "Y" or idw_si.Object.count2_spread[ index ] = "Y" ) )  then

		li_sibling_rows[ UpperBound( li_sibling_rows ) +1 ] = idw_si.object.line_item_no[ index ]
	end if


	_dw.setItemStatus( innerIndex , 0, primary!, Notmodified! ) // causes the status to be New! on newModified! rows
Next

wf_generate_up_count_zero_records(_dw, getCountTab()) //14-MAY-2018 :Madhu S19286 - DE4781  Up count from Non existing qty

if _dw.rowcount() = 0 then
	messagebox( this.title, "No Rows Generated.")
end if

//  LTK 20160608  Moved this block to end of method
////idw_si.SetSort( getSortOrder() )		// this is executed in wf_sort() called below
////idw_si.Sort()
//idw_si.setRedraw( true )
//_dw.Setredraw(True)
//wf_check_status()
//wf_sort()
//ib_changed = true
//// set the count date
//idw_main.setItem( idw_main.getrow(), countDateColumn , ldtToday )
//idw_main.setItem( idw_main.getrow(), ls_count_rollup_code, wf_build_encoded_rollup_code( getCountTab() ) )


// LTK 20150608  Process sibling row array
//
//	1.  Traverse the li_sibling_rows array
//	2.	Find count row and use it to find corresponding SI rows
//	3.	Travers SI rows
//	4.	If count DW contains exact (use line_item_no) SI row, skip it and go to next
//	5.	If count DW does not contain SI row, then call wf_find_existing_count_row() and either add qty or insert into Count DW
if UpperBound( li_sibling_rows ) > 0 then



	// Add the SI line item #s to the siblings processed array, which will be used later
	long k
	for k = 1 to UpperBound( li_sibling_rows )
		
		// Add the line item numbers being processed here to the processed array
		if in_string_util.uf_contains( ls_siblings_processed, String( li_sibling_rows[ k ] ) ) then
			continue
		else
			ls_siblings_processed[ UpperBound( ls_siblings_processed ) + 1 ] = String( li_sibling_rows[ k ] )
		end if
	next
	if ib_verbose_tracing then
		f_method_trace_special( gs_project, this.ClassName() , 'SI LI# entered: ' + in_string_util.of_format_string( ls_siblings_processed, n_string_util.FORMAT2 ),isCCOrder, '','',isCCOrder)
	end if

	long ll_si_row_num, ll_result_row, ll_corresponding_si_rows[], ll_empty[], j

	for index = 1 to UpperBound( li_sibling_rows )	

		ll_result_row = getResultRow( _dw, li_sibling_rows[ index ] )				
		//ll_corresponding_si_rows = wf_find_corresponding_si_rows( _dw, ll_result_row )
		ll_corresponding_si_rows = wf_find_si_sibling_set( li_sibling_rows[ index ], getCountTab() )

		for j = 1 to UpperBound( ll_corresponding_si_rows )

			//ll_si_row_num = getSysInvRow( li_sibling_rows[ j ] )
			ll_si_row_num = getSysInvRow( ll_corresponding_si_rows[ j ] )

			//if getResultRow( _dw, li_sibling_rows[ index ] ) > 0 then
			if getResultRow( _dw, ll_corresponding_si_rows[ j ] ) > 0 then
				continue		// Line item number already exists in count DW, proceed to next
			end if
	
			// Double check that the SI row has the sibling flag set (it should), otherwise continue to next
			if getCountTab() = CC_RESULTS2_TAB then
				if idw_si.Object.count1_spread[ ll_si_row_num ] <> 'Y' then
					continue
				end if
			elseif getCountTab() = CC_RESULTS3_TAB then
				if idw_si.Object.count1_spread[ ll_si_row_num ] <> 'Y' and idw_si.Object.count2_spread[ ll_si_row_num ] <> 'Y' then
					continue
				end if
			end if

			// Check that lineItemNo is not in the list of processed SI sibling rows so they are not reprocessed
			if in_string_util.uf_contains( ls_siblings_processed, String(ll_corresponding_si_rows[ j ]) ) then
				continue
			else
				ls_siblings_processed[ UpperBound( ls_siblings_processed ) + 1 ] = String( ll_corresponding_si_rows[ j ] )
			end if

			//  LTK 20150501  Attempt to find row in count datawindow that matches the current grouping
			ll_existing_count_row = wf_find_existing_count_row( _dw, ll_si_row_num,  getCountTab() )

			if ll_existing_count_row > 0 then
		
				_dw.object.quantity[ ll_existing_count_row ] = _dw.object.quantity[ ll_existing_count_row ] + idw_si.object.quantity[ ll_si_row_num ]
				if getBlindKnown() = 'K' then _dw.object.sysquantity[ ll_existing_count_row ] = _dw.object.sysquantity[ ll_existing_count_row ] + idw_si.object.quantity[ ll_si_row_num ]
			else
		
				innerIndex = _dw.InsertRow(0)
				_dw.object.line_item_no[ innerIndex] = idw_si.object.line_item_no[ ll_si_row_num] 
				_dw.object.sysinvmatch[ innerIndex ]  = 'N'
				_dw.object.cc_no[ innerIndex ] = idw_si.object.cc_no[ ll_si_row_num ]
				_dw.object.sku[ innerIndex ] = idw_si.object.sku[ ll_si_row_num ]
				_dw.object.quantity[ innerIndex ] = lNull  // force to Null on generation
				_dw.object.supp_code[ innerIndex ] = idw_si.object.supp_code[ ll_si_row_num ]
				
				IF Trim(Upper(  idw_si.object.sku[ index ])) =  'EMPTY' AND getCountTab() = CC_RESULTS1_TAB Then
					_dw.object.protected[ innerIndex ] = 1
				Else
					_dw.object.owner_id[ innerIndex ] = idw_si.object.owner_id[ ll_si_row_num ]
				End If
				
				_dw.object.l_code[ innerIndex ] = idw_si.object.l_code[ ll_si_row_num ]
		
			//	_dw.object.inventory_type[ innerIndex ] = idw_si.object.inventory_type[ index ]
			//	_dw.object.serial_no[ innerIndex ] = idw_si.object.serial_no[ index ]
			//	_dw.object.lot_no[ innerIndex ] = idw_si.object.lot_no[ index ]
			//	_dw.object.po_no[ innerIndex ] = idw_si.object.po_no[ index ]
			//	_dw.object.po_no2[ innerIndex ] = idw_si.object.po_no2[ index ]
			//	_dw.object.container_id[ innerIndex ] = idw_si.object.container_id[ index ]
			//	_dw.object.expiration_date[ innerIndex ] = idw_si.object.expiration_date[ index ]
			//	_dw.object.country_of_origin[ innerIndex ] = idw_si.object.country_of_origin[ index ]
		
				// LTK 20150508  Set the lot-able column if indicator is turned on, else value will be the dw default
				if wf_decode_indicators( ls_encoded_indicators, DECODE_SERIAL_NO ) then				
					_dw.object.serial_no[ innerIndex ] = idw_si.object.serial_no[ ll_si_row_num ]
				end if
				if wf_decode_indicators( ls_encoded_indicators, DECODE_CONTAINER_ID ) then				
					_dw.object.container_id[ innerIndex ] = idw_si.object.container_id[ ll_si_row_num ]
				end if
				if wf_decode_indicators( ls_encoded_indicators, DECODE_LOT_NO ) then				
					_dw.object.lot_no[ innerIndex ] = idw_si.object.lot_no[ ll_si_row_num ]
				end if
				if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO ) then
					_dw.object.po_no[ innerIndex ] = idw_si.object.po_no[ ll_si_row_num ]
				end if
				if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO2 ) then
					_dw.object.po_no2[ innerIndex ] = idw_si.object.po_no2[ ll_si_row_num ]
				end if
				if wf_decode_indicators( ls_encoded_indicators, DECODE_EXP_DT ) then
					_dw.object.expiration_date[ innerIndex ] = idw_si.object.expiration_date[ ll_si_row_num ]
				end if
				// NOTE: inventory type needs to be set for the print SQL to work.  Always set it and never set it to '-'
				//if wf_decode_indicators( ls_encoded_indicators, DECODE_INV_TYPE ) then
					_dw.object.inventory_type[ innerIndex ] = idw_si.object.inventory_type[ ll_si_row_num ]
				//else
				//	_dw.object.inventory_type[ innerIndex ] = '-'					// Always set inventory type as there is no dw default
				//end if
				if wf_decode_indicators( ls_encoded_indicators, DECODE_COO ) then
					_dw.object.country_of_origin[ innerIndex ] = idw_si.object.country_of_origin[ ll_si_row_num ]
				else
					_dw.object.country_of_origin[ innerIndex ] = 'XXX'			// Always set COO as there is no dw default
				end if
		
				_dw.object.alternate_sku[ innerIndex ] = idw_si.object.alternate_sku[ ll_si_row_num ]	
			
				_dw.object.uom_1[ innerIndex ] = idw_si.object.uom_1[ ll_si_row_num ]	
				_dw.object.grp[ innerIndex ] = idw_si.object.grp[ ll_si_row_num ]	
				
			//	_dw.object.ro_no[ innerIndex ] = idw_si.object.ro_no[ index ]		
				if getBlindKnown() = 'K' then _dw.object.sysquantity[ innerIndex ] = idw_si.object.quantity[ ll_si_row_num ]
		
			end if		

			_dw.setItemStatus( innerIndex , 0, primary!, Notmodified! ) // causes the status to be New! on newModified! rows

		next	// corresponding SI rows
	next	// sibling rows
	
end if

if ib_verbose_tracing then
	f_method_trace_special( gs_project, this.ClassName() , 'SI LI# entered WITH SIBLINGS: ' + in_string_util.of_format_string( ls_siblings_processed, n_string_util.FORMAT2 ),isCCOrder, '','',isCCOrder)
end if

// LTK 20151028  Set Sys Qty with common method
setSysQuantityOnCount( _dw, getBlindKnown() = 'K' )

//NOV 2019 - MikeA F17679 S36894 I2538 - KNY - City of New York EM - Ability to Cycle Count Components

if  upper(gs_project) ='NYCSP'  AND _cb.checked = true then
	idw_si.SetFilter("")
	idw_si.Filter()
end if

idw_si.setRedraw( true )
_dw.Setredraw(True)
wf_check_status()
wf_sort()
ib_changed = true
// set the count date
idw_main.setItem( idw_main.getrow(), countDateColumn , ldtToday )
idw_main.setItem( idw_main.getrow(), ls_count_rollup_code, wf_build_encoded_rollup_code( getCountTab() ) )


f_method_trace_special( gs_project, this.ClassName() , 'End GenerateCountSheet ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

return success

end function

on w_cc.create
int iCurrent
call super::create
this.p_arrow=create p_arrow
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_arrow
end on

on w_cc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_arrow)
end on

event ue_edit;// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()

// Tab properties

wf_clear_screen()

isle_code.DisplayOnly = False
isle_code.TabOrder = 10
isle_code.backColor= 16777215 /* 01/01 PCONKL */
isle_code.SetFocus()


end event

event ue_save;Long ll_result
String ls_type, ls_prefix, ls_order
long ll_no, i
string ls_loc, ls_sku, ls_supp, ls_serial, ls_lot, ls_po, ls_po2, ls_container_id, ls_coo, ls_ro_no, lsLocSave
long ll_owner
datetime ldt_expiration_date
integer li_idx
string ls_wh_code, ls_cc_no
string ls_coo_key
integer li_key
boolean ib_update_cc_inventory = false
string ls_max_country_origin
String ls_SQLError
long ll_CurLine, ll_SI_Line, ll_DeleteLine //dts - 2/27/2013 - 556-2; Setting the System Inventory location to ALLOCATED if deleting a line from counts

// Acess Rights
If f_check_access(is_process,"S") = 0 Then return -1

////SEPT2019- MikeA DE12620 - CC up-count from zero with missing owner
//We should not allow the CC to be confirmed (or even the count tab saved) without a valid owner being selected first.

long ll_Idx,ll_OwnerID



If idw_result1.RowCount() > 0 Then
	For ll_Idx = 1 to idw_result1.RowCount()
		
		ll_OwnerID = idw_result1.GetItemNumber(ll_Idx, "owner_id")
		
		If (IsNull(ll_OwnerID) OR ll_OwnerID = 0) AND (Upper(idw_result1.GetItemString(ll_Idx, "sku")) <> 'EMPTY')  Then
			MessageBox (is_title, "Please select Owner on Results 1 Tab before saving.")
//			tab_main.SelectTab(CC_RESULTS1_TAB)
			Return -1
		Else
			
			IF Upper(idw_result1.GetItemString(ll_Idx, "sku")) = 'EMPTY' AND IsNull(ll_OwnerID) THEN  idw_result1.SetItem(ll_Idx, "owner_id",0) //Need this to save Empty Location
			
		End IF
	Next
End If

If idw_result2.RowCount() > 0 Then
	For ll_Idx = 1 to idw_result2.RowCount()
		
			ll_OwnerID = idw_result2.GetItemNumber(ll_Idx, "owner_id")
		
		If (IsNull(ll_OwnerID)  OR ll_OwnerID = 0) AND   (Upper(idw_result2.GetItemString(ll_Idx, "sku")) <> 'EMPTY')  Then 
			MessageBox (is_title, "Please select Owner on Results 2 Tab before saving.")
	//		tab_main.SelectTab(CC_RESULTS2_TAB)
			Return -1
		Else
			
			IF Upper(idw_result2.GetItemString(ll_Idx, "sku")) = 'EMPTY' AND IsNull(ll_OwnerID) THEN  idw_result2.SetItem(ll_Idx, "owner_id",0) //Need this to save Empty Location
	
			
		End IF
		
	Next	
End If

If idw_result3.RowCount() > 0 Then
	For ll_Idx = 1 to idw_result3.RowCount()
			ll_OwnerID = idw_result3.GetItemNumber(ll_Idx, "owner_id")
		
		If (IsNull(ll_OwnerID)  OR ll_OwnerID = 0) AND  (Upper(idw_result3.GetItemString(ll_Idx, "sku")) <> 'EMPTY') Then
			MessageBox (is_title, "Please select Owner on Results 3 Tab before saving.")
//			tab_main.SelectTab(CC_RESULTS3_TAB)
			Return -1

		Else
			
			IF Upper(idw_result3.GetItemString(ll_Idx, "sku")) = 'EMPTY' AND IsNull(ll_OwnerID) THEN  idw_result3.SetItem(ll_Idx, "owner_id",0) //Need this to save Empty Location

		End IF
	Next	
End If




f_method_trace_special( gs_project, this.ClassName() , 'Start ue_save CC order ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

// Validations

SetPointer(HourGlass!)

// pvh 11/30/05 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( g.getCurrentWarehouse(  ) ) 
If idw_main.RowCount() > 0 Then
	idw_main.SetItem(1,'last_update',  ldtToday ) 
	idw_main.SetItem(1,'last_user',gs_userid) 
	If wf_validation() = -1 Then
		SetMicroHelp("Save failed!")
		Return -1
	End If
End If

SetMicroHelp("Saving Data...")

if ib_edit = false then

	// Assign order no. for new order
	
	// 10/00 PCONKL - Using Stored procedure to get next available RO_NO
	//						Prefixing with Project ID to keep Unique within System
			
// 09/09 - PCONKL - Moved to UE_NEW for assigning CC_NO
//	ll_no = g.of_next_db_seq(gs_project,'CC_Master','CC_No')
//	
//	If ll_no <= 0 Then
//		messagebox(is_title,"Unable to retrieve the next available order Number!")
//		Return -1
//	End If
//	
//	ls_order = Trim(Left(gs_project,9)) + String(ll_no,"000000")
//	
//	idw_main.setitem(1,"cc_no",ls_order)	
//	setCCOrder( ls_order )
	
//	idw_main.setitem(1,"project_id",gs_project)	
//	isle_code.Text = ls_order

//	For i = 1 to idw_si.RowCount()
//		idw_si.SetItem(i, "cc_no", ls_order)
//	Next		
	
End If /*New Record */

ls_cc_no = idw_Main.GetITemString(1,'cc_no')

For i = 1 to idw_si.RowCount()
		idw_si.SetItem(i, "cc_no", ls_cc_no )
Next		
	
// Update order status 

If idw_main.RowCount() > 0 Then
	
	If idw_main.GetItemString(1,"ord_status") <> "C" AND  idw_main.GetItemString(1,"ord_status") <> "V"  Then
		
		If idw_result3.RowCount() > 0 Then 
			idw_main.SetItem(1,"ord_status","3")
		Else
			If idw_result2.RowCount() > 0 Then 
				idw_main.SetItem(1,"ord_status","2")
			Else
				If idw_result1.RowCount() > 0 Then 
					idw_main.SetItem(1,"ord_status","1")
				Else
					If idw_si.RowCount() > 0  or (idw_mobile.rowcount() > 0 and idw_Main.getItemString(1,'Mobile_enabled_Ind') = 'Y') Then  /* 04/15 - PCONKL - mbile DW is list of locations, generated instead of SI*/
						idw_main.SetItem(1,"ord_status","P")
					Else
						If idw_main.GetItemString(1, "ord_status") <> 'A' Then		//GailM - 08/30/2017 - New defect.  Do not change status to N if still in Allocated status
							idw_main.SetItem(1,"ord_status","N")			
						End If
					End If
				End If
			End If
		End If
	End If
End If

//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count
//Validate & Process Foot Print Containers
If ib_Foot_Print_SKU and idw_cc_container.rowcount( ) > 0  and getCountTab() =9 Then wf_validate_save_foot_print_containers()
If ib_Foot_Print_SKU and idw_serial_numbers.rowcount( ) > 0  and getCountTab() =8 Then wf_validate_save_foot_print_serials()

//save changes to database
Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If idw_main.RowCount() > 0 Then

	If Upper(gs_project) = 'CHINASIMS'  THEN
		 SQLCA.DBParm = "disablebind =0"
	End If
	
	ll_result  = idw_main.Update(False, False)
	
	If Upper(gs_project) = 'CHINASIMS'  THEN
		 SQLCA.DBParm = "disablebind =1"
	End If	
	
Else
	ll_result = 1
End If

if  ib_freeze_cc_inventory and idw_main.RowCount() > 0 then 
	
	Open(w_update_status)
	
	//Need to go through and lock the inventory if there have been rows inserted.

	if idw_si.ModifiedCount () > 0 then
			
		w_update_status.hpb_status.MaxPosition = idw_si.ModifiedCount ()
		w_update_status.st_status.text = 'Locking CC Inventory Records...'
		
		f_method_trace_special( gs_project, this.ClassName() , 'Process Locking CC Inventory Records and count is : ' + String(idw_si.RowCount()) ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
		
		for li_idx = 1 to idw_si.RowCount()
			
			w_update_status.hpb_status.Position = li_idx
		
			if idw_si.GetItemStatus(li_idx, 0, Primary!) = NewModified! then
		
				ls_wh_code 				= idw_main.object.wh_code[ 1 ]
				ls_loc 						= idw_si.object.l_code[ li_idx ]
				ls_sku						= idw_si.object.sku[ li_idx ] 
				ls_supp						= idw_si.object.supp_code[ li_idx ]
				ll_owner					= idw_si.object.owner_id[ li_idx ] 
				ls_type						= idw_si.object.inventory_type[ li_idx ]
				ls_serial					= idw_si.object.serial_no[ li_idx ]
				ls_lot							= idw_si.object.lot_no[ li_idx ] 
				ls_po						= idw_si.object.po_no[ li_idx ]
				ls_po2						= idw_si.object.po_no2[ li_idx ] 
				ls_container_id			= idw_si.object.container_id[ li_idx ] 
				ldt_expiration_date	= idw_si.object.expiration_date[ li_idx ]
				ls_coo						= idw_si.object.country_of_origin[ li_idx ]
//				ls_ro_no					= idw_si.object.ro_no[ li_idx ]
	
				//Check to see if duplicate content record will be created.
				// 2/9/2011; David C; Note: May need to add a substring statement here just to get the integer portion of the string
				// because the SQL below would evaluate "CC2" to be greater than "CC10" since "country_of_origin" is a character field.
				SELECT MAX(Country_of_Origin) INTO :ls_max_country_origin
					FROM Content With (NoLock)
					WHERE project_id = :gs_project AND
								wh_code = :ls_wh_code AND
								L_Code = :ls_loc AND
								sku = :ls_sku AND
								Supp_Code = :ls_supp AND
								Owner_ID = :ll_owner AND
								Inventory_Type = "*" AND
								Serial_No = :ls_serial AND
								Lot_No = :ls_lot AND
								PO_No = :ls_po AND
								PO_No2 = :ls_po2 AND
								Container_ID = :ls_container_id AND
								Expiration_Date = :ldt_expiration_date 
								USING SQLCA;					
								// LTK 20150310  Removed ro_no from where clause above
			
				if sqlca.sqlcode < 0 then
					ls_SQLError = SQLCA.SQLErrText
					Execute Immediate "ROLLBACK" using SQLCA;
					Close (w_update_status)
					Messagebox ("DB Error", "Select from content failed.  SQL Error reported: " + ls_SQLError )
					Return -1
				end if

				f_method_trace_special( gs_project, this.ClassName() , 'Order in Primary buffer, getting Max(COO) value is : ' + Nz(ls_max_country_origin,'0') ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

	
				//	Due to setting all inventory types to the same value there is a risk of creating duplicate keys,
				//if this is the case, on the duplicate key record set Content.COO = 'CC1'.  
				//If necessary use CC2, then CC3, etc. to break the tie.  (From spec)
				// 2/9/2011; David C; May have to change the "CC" prefix for the variable below. This is because the "country_of_origin" column 
				// is only a 3 character field. If the query above returns a "10" then the value will be truncated to "CC1" instead of "CC10", thus
				// resulting in a primary key violation.
				If IsNull(ls_max_country_origin) Or Trim(ls_max_country_origin) = "" THEN
					
					ls_coo_key = "CC1"
				
				ELSE
							
					li_key = integer(right(ls_max_country_origin, 1))
					li_key = li_key + 1
					ls_coo_key = "CC" + string(li_key) 
					
				END IF	
	
				f_method_trace_special( gs_project, this.ClassName() , 'Order in Primary buffer, updated COO value is : ' + ls_coo_key ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
	
				UPDATE CONTENT
					SET 	inventory_type = "*",	
							Country_of_Origin = :ls_coo_key,
					    	old_inventory_type = :ls_type, 
		   					old_country_of_origin = :ls_coo,
							CC_NO = :ls_cc_no,
							last_user = :gs_userid,
							last_update = :ldtToday
					WHERE project_id = :gs_project AND
								wh_code = :ls_wh_code AND
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
								USING SQLCA;
								// LTK 20150310  Removed ro_no from where clause above
				
				if sqlca.sqlcode < 0 then
					ls_SQLError = SQLCA.SQLErrText
					Execute Immediate "ROLLBACK" using SQLCA;
					Close (w_update_status)
					Messagebox ("DB Error", "Update content failed.  SQL Error reported: " + ls_SQLError)
					Return -1
				end if
				
				f_method_trace_special( gs_project, this.ClassName() , 'Order in Primary buffer, updating Content table'  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
				
				// 09/09 - PCONKL - If Random, set the Random Ind to In Process so we don't put it on a new order */
				//2017/11 - TAM - If System Generated and Location Count, set the Random Ind to not counted */
//				If idw_main.GetItemString(1,"ord_Type") = 'R' OR idw_main.GetItemString(1,"ord_Type") = 'Q' Then
				If idw_main.GetItemString(1,"ord_Type") = 'R' OR idw_main.GetItemString(1,"ord_Type") = 'Q' OR (idw_main.GetItemString(1,"ord_Type") = 'X' and idw_system_generated.GetItemString(1,"Count_Type") = 'L'  ) Then
					
					If ls_loc <> lsLocSave Then
						
						Update Location
						Set CC_Rnd_Cnt_Ind = 'X',
						last_user = :gs_userid,
						last_update = :ldtToday
						Where wh_code = :ls_wh_code and l_code = :ls_loc;
						
						if sqlca.sqlcode < 0 then
							Execute Immediate "ROLLBACK" using SQLCA;
							Close (w_update_status)
							Messagebox ("DB Error", "Unable to update Random Cycle Count Indicator")
							Return -1
						end if
						
						lsLocSave = ls_loc
				
					End If /*loc changed*/
					
				End If /*random CC*/
						
			end if /*New */
			
			// 3/07/13 - dts, Pandora 556 - now 'Releasing' inventory based on change to SI DW (instead of delete from Result DW)
			if idw_si.GetItemStatus(li_idx, "l_code", Primary!) = DataModified! and Left(idw_si.GetItemString(li_idx, "l_code"), 9) = 'Allocated' then	// LTK 20140807  Pandora #882 added the Left() method
				f_method_trace_special( gs_project, this.ClassName() , 'Order in Primary buffer, SI Location =Allocated'  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
				ls_wh_code 				= idw_main.object.wh_code[ 1 ]
				// 3/12/13 - now correctly using idw_si instead of idw_result1 here....
				ls_loc 					= idw_si.GetItemString( li_idx, "l_code", Primary!, True)  //grab the original l_code (before setting to 'Allocated')
				ls_sku						= idw_si.GetItemString( li_idx, "sku")
				ls_supp					= idw_si.GetItemString( li_idx, "supp_code")
				ll_owner					= idw_si.GetItemNumber( li_idx, "owner_id")
				ls_type					= idw_si.GetItemString( li_idx, "inventory_type")
				ls_serial					= idw_si.GetItemString( li_idx, "serial_no")
				ls_lot						= idw_si.GetItemString( li_idx, "lot_no")
				ls_po						= idw_si.GetItemString( li_idx, "po_no")
				ls_po2					= idw_si.GetItemString( li_idx, "po_no2")
				ls_container_id			= idw_si.GetItemString( li_idx, "container_id")
				ldt_expiration_date	= idw_si.GetItemDateTime( li_idx, "expiration_date")
				ls_coo					= idw_si.GetItemString( li_idx, "country_of_origin")
//				ls_ro_no					= idw_si.GetItemString( li_idx, "ro_no")
				
				UPDATE CONTENT
					SET 	inventory_type = :ls_type,	
							Country_of_Origin = :ls_coo,
							old_inventory_type = null, 
							old_country_of_origin = null,
							cc_no = null,
							last_user = :gs_userid,
							last_update = :ldtToday
					WHERE project_id = :gs_project AND
								wh_code = :ls_wh_code AND
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
								Expiration_Date = :ldt_expiration_date AND
								old_country_of_origin = :ls_coo AND
								old_inventory_type =:ls_type 
								USING SQLCA;
								// LTK 20150310  Removed ro_no from where clause above

				if sqlca.sqlcode < 0 then
					ls_SQLError = SQLCA.SQLErrText
					Execute Immediate "ROLLBACK" using SQLCA;
					Close (w_update_status)
					Messagebox ("DB Error", "Update content failed 2.  SQL Error reported: " + ls_SQLError)
					Return -1
				end if
			f_method_trace_special( gs_project, this.ClassName() , 'Order in Primary buffer + SI Location=Allocated & updated Content table'  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
			end if // L_Code modified to 'Allcocated'
		
		next /*SI row */
	
		ib_update_cc_inventory = true
	
	end if /*SI Modified*/

	//Take care of any rows removed.

	// ET3 2013-01-05  Major change to allow for deletion of individual rows from counts 1,2,or 3 for Pandora #556
	/* dts 3/3/13 - changing to 'Release' line from System Inventory tab. The 'Release' function will delete rows from all counts
		- in all cases count 1 should have a deleted line that represents inventory that needs to be released in Content. No need
		  to check counts 2 and 3. Note: should we not allow deleting of SI record (only allow 'Release', even if counts haven't started?)?
		3/7/13 - now not deleting from Count datawindows so triggering the Delete above (when l_code is modified to 'Allocated')	  
	*/
	if ( idw_si.DeletedCount () > 0 OR & 
		  idw_result1.DeletedCount() > 0 OR &
		  idw_result2.DeletedCount() > 0 OR &
		  idw_result3.DeletedCount() > 0 ) &
		and idw_Main.RowCount() > 0 then
		
		lsLocSave = ''
		
		w_update_status.hpb_status.MaxPosition = idw_si.DeletedCount()
		w_update_status.st_status.text = 'Releasing CC Inventory Records...'

		// Note: logic of ue_deleterow() prevents deletion if later count exists 
		IF idw_si.DeletedCount () > 0 THEN
		
			for li_idx = 1 to  idw_si.DeletedCount ()
				
			f_method_trace_special( gs_project, this.ClassName() , 'SI Deleted Count is: ' +String(idw_si.DeletedCount ())  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
			
				w_update_status.hpb_status.Position = li_idx
			
				ls_wh_code 				= idw_main.object.wh_code[ 1 ]
				ls_loc 					= idw_si.GetItemString( li_idx, "l_code", Delete!, false)
				ls_sku					= idw_si.GetItemString( li_idx, "sku", Delete!, false)
				ls_supp					= idw_si.GetItemString( li_idx, "supp_code", Delete!, false)
				ll_owner					= idw_si.GetItemNumber( li_idx, "owner_id", Delete!, false)
				ls_type					= idw_si.GetItemString( li_idx, "inventory_type", Delete!, false)
				ls_serial				= idw_si.GetItemString( li_idx, "serial_no", Delete!, false)
				ls_lot					= idw_si.GetItemString( li_idx, "lot_no", Delete!, false)
				ls_po						= idw_si.GetItemString( li_idx, "po_no", Delete!, false)
				ls_po2					= idw_si.GetItemString( li_idx, "po_no2", Delete!, false)
				ls_container_id		= idw_si.GetItemString( li_idx, "container_id", Delete!, false)
				ldt_expiration_date	= idw_si.GetItemDateTime( li_idx, "expiration_date", Delete!, false)
				ls_coo					= idw_si.GetItemString( li_idx, "country_of_origin", Delete!, false)
//				ls_ro_no					= idw_si.GetItemString( li_idx, "ro_no", Delete!, false)
				
				UPDATE CONTENT
					SET 	inventory_type = :ls_type,	
							Country_of_Origin = :ls_coo,
							old_inventory_type = null, 
							old_country_of_origin = null,
							cc_no = null,
							last_user = :gs_userid,
							last_update = :ldtToday
					WHERE project_id = :gs_project AND
								wh_code = :ls_wh_code AND
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
								Expiration_Date = :ldt_expiration_date AND
								old_country_of_origin = :ls_coo AND
								old_inventory_type =:ls_type 
								USING SQLCA;
								// LTK 20150310  Removed ro_no from where clause above

				if sqlca.sqlcode < 0 then
					ls_SQLError = SQLCA.SQLErrText
					Execute Immediate "ROLLBACK" using SQLCA;
					Close (w_update_status)
					Messagebox ("DB Error", "Update content failed 3.  SQL Error reported: " + ls_SQLError)
					Return -1
				end if
				
				// 09/09 - PCONKL - If Random, reset the Random Ind to not counted so we  */
				// 03/12 - MEA - Added Sequential (Q)
				//2017/11 - TAM - If System Generated and Location Count, set the Random Ind to not counted */
//				If idw_main.GetItemString(1,"ord_Type") = 'R' OR idw_main.GetItemString(1,"ord_Type") = 'Q' Then
				If idw_main.GetItemString(1,"ord_Type") = 'R' OR idw_main.GetItemString(1,"ord_Type") = 'Q' OR (idw_main.GetItemString(1,"ord_Type") = 'X' and idw_system_generated.GetItemString(1,"Count_Type") = 'L'  ) Then
						
						If ls_loc <> lsLocSave Then
							
							Update Location
							Set CC_Rnd_Cnt_Ind = 'N',
							last_user = :gs_userid,
							last_update = :ldtToday
							Where wh_code = :ls_wh_code and l_code = :ls_loc;
							
							if sqlca.sqlcode < 0 then
								Execute Immediate "ROLLBACK" using SQLCA;
								Close (w_update_status)
								Messagebox ("DB Error", "Unable to update Random Cycle Count Indicator2")
								Return -1
							end if
							
							lsLocSave = ls_loc
					
						End If /*loc changed*/
						
				End If /*random CC*/
			
			next /*SI row */
			
		ELSEIF idw_result1.DeletedCount() > 0 AND UPPER(gs_project) = 'PANDORA' THEN
			for li_idx = 1 to  idw_result1.DeletedCount ()
				
			f_method_trace_special( gs_project, this.ClassName() , 'CC1 Deleted Count is: ' +String(idw_result1.DeletedCount ())  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
				
				if idw_result1.getItemString(li_idx, 'up_count_zero', Delete!, false) ='Y' Then continue //14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
				
				
				w_update_status.hpb_status.Position = li_idx
			
				ls_wh_code 				= idw_main.object.wh_code[ 1 ]
				ls_loc 					= idw_result1.GetItemString( li_idx, "l_code", Delete!, false)
				ls_sku					= idw_result1.GetItemString( li_idx, "sku", Delete!, false)
				ls_supp					= idw_result1.GetItemString( li_idx, "supp_code", Delete!, false)
				ll_owner					= idw_result1.GetItemNumber( li_idx, "owner_id", Delete!, false)
				ls_type					= idw_result1.GetItemString( li_idx, "inventory_type", Delete!, false)
				ls_serial				= idw_result1.GetItemString( li_idx, "serial_no", Delete!, false)
				ls_lot					= idw_result1.GetItemString( li_idx, "lot_no", Delete!, false)
				ls_po						= idw_result1.GetItemString( li_idx, "po_no", Delete!, false)
				ls_po2					= idw_result1.GetItemString( li_idx, "po_no2", Delete!, false)
				ls_container_id		= idw_result1.GetItemString( li_idx, "container_id", Delete!, false)
				ldt_expiration_date	= idw_result1.GetItemDateTime( li_idx, "expiration_date", Delete!, false)
				ls_coo					= idw_result1.GetItemString( li_idx, "country_of_origin", Delete!, false)
//				ls_ro_no					= idw_result1.GetItemString( li_idx, "ro_no", Delete!, false)
				//dts - 2/27/2013 - 556-2; Setting the System Inventory location to ALLOCATED if deleting a line from counts
				ll_CurLine				= idw_result1.GetItemNumber( li_idx, "line_item_no", Delete!, false)
				ll_SI_Line = GetSysInvRow(ll_CurLine)
				//idw_SI.SetItem(ll_SI_Line, "l_code", "ALLOCATED")
				idw_SI.SetItem(ll_SI_Line, "l_code", "Allocated" + wf_find_greatest_allocated(ll_SI_Line))	// LTK 20140807  find allocated string which may be Allocated1, Allocated2, etc.
				
				UPDATE CONTENT
					SET 	inventory_type = :ls_type,	
							Country_of_Origin = :ls_coo,
							old_inventory_type = null, 
							old_country_of_origin = null,
							cc_no = null,
							last_user = :gs_userid,
							last_update = :ldtToday
					WHERE project_id = :gs_project AND
								wh_code = :ls_wh_code AND
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
								Expiration_Date = :ldt_expiration_date AND
								old_country_of_origin = :ls_coo AND
								old_inventory_type =:ls_type 
								USING SQLCA;
								// LTK 20150310  Removed ro_no from where clause above

				if sqlca.sqlcode < 0 then
					ls_SQLError = SQLCA.SQLErrText
					Execute Immediate "ROLLBACK" using SQLCA;
					Close (w_update_status)
					Messagebox ("DB Error", "Update content failed 4.  SQL Error reported: " + ls_SQLError)
					Return -1
				end if
				
				// 09/09 - PCONKL - If Random, reset the Random Ind to not counted so we  */
				// 03/12 - MEA - Added Sequential (Q)
				//2017/11 - TAM - If System Generated and Location Count, set the Random Ind to not counted */
//				If idw_main.GetItemString(1,"ord_Type") = 'R' OR idw_main.GetItemString(1,"ord_Type") = 'Q' Then
				If idw_main.GetItemString(1,"ord_Type") = 'R' OR idw_main.GetItemString(1,"ord_Type") = 'Q' OR (idw_main.GetItemString(1,"ord_Type") = 'X' and idw_system_generated.GetItemString(1,"Count_Type") = 'L'  ) Then
						
						If ls_loc <> lsLocSave Then
							
							Update Location
							Set CC_Rnd_Cnt_Ind = 'N',
							last_user = :gs_userid,
							last_update = :ldtToday
							Where wh_code = :ls_wh_code and l_code = :ls_loc;
							
							if sqlca.sqlcode < 0 then
								Execute Immediate "ROLLBACK" using SQLCA;
								Close (w_update_status)
								Messagebox ("DB Error", "Unable to update Random Cycle Count Indicator3")
								Return -1
							end if
							
							lsLocSave = ls_loc
					
						End If /*loc changed*/
						
				End If /*random CC*/
			
			next /*count1 row */
			
		ELSEIF idw_result2.DeletedCount() > 0 AND UPPER(gs_project) = 'PANDORA' THEN

			//dts - 2/28/13 for li_idx = 1 to  idw_si.DeletedCount ()
			for li_idx = 1 to  idw_result2.DeletedCount ()
			
			f_method_trace_special( gs_project, this.ClassName() , 'CC2 Deleted Count is: ' +String(idw_result2.DeletedCount ())  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
				w_update_status.hpb_status.Position = li_idx
			
				ls_wh_code 				= idw_main.object.wh_code[ 1 ]
				ls_loc 					= idw_result2.GetItemString( li_idx, "l_code", Delete!, false)
				ls_sku					= idw_result2.GetItemString( li_idx, "sku", Delete!, false)
				ls_supp					= idw_result2.GetItemString( li_idx, "supp_code", Delete!, false)
				ll_owner					= idw_result2.GetItemNumber( li_idx, "owner_id", Delete!, false)
				ls_type					= idw_result2.GetItemString( li_idx, "inventory_type", Delete!, false)
				ls_serial				= idw_result2.GetItemString( li_idx, "serial_no", Delete!, false)
				ls_lot					= idw_result2.GetItemString( li_idx, "lot_no", Delete!, false)
				ls_po						= idw_result2.GetItemString( li_idx, "po_no", Delete!, false)
				ls_po2					= idw_result2.GetItemString( li_idx, "po_no2", Delete!, false)
				ls_container_id		= idw_result2.GetItemString( li_idx, "container_id", Delete!, false)
				ldt_expiration_date	= idw_result2.GetItemDateTime( li_idx, "expiration_date", Delete!, false)
				ls_coo					= idw_result2.GetItemString( li_idx, "country_of_origin", Delete!, false)
//				ls_ro_no					= idw_result2.GetItemString( li_idx, "ro_no", Delete!, false)
				//dts - 2/27/2013 - 556-2; Setting the System Inventory location to ALLOCATED if deleting a line from counts
				ll_CurLine				= idw_result2.GetItemNumber( li_idx, "line_item_no", Delete!, false)
				ll_SI_Line = GetSysInvRow(ll_CurLine)
				//idw_SI.SetItem(ll_SI_Line, "l_code", "ALLOCATED")
				idw_SI.SetItem(ll_SI_Line, "l_code", "Allocated" + wf_find_greatest_allocated(ll_SI_Line))	// LTK 20140807  find allocated string which may be Allocated1, Allocated2, etc.
			f_method_trace_special( gs_project, this.ClassName() , 'Set Location =Allocated for SI records and  line no is:  ' +String(ll_SI_Line)  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
				//Need to delete from Count 1...
				//idw_result1.find("line_item_no = " +String(ll_CurLine), 0, idw_result1.rowcount())
				ll_DeleteLine = GetResultRow(idw_result1, ll_CurLine)
				//idw_result1.DeleteRow(ll_DeleteLine)		// LTK 20151021  don't delete prior count results
			f_method_trace_special( gs_project, this.ClassName() , 'Deleting CC1 records and line no is:  ' +String(ll_DeleteLine)  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
				
				UPDATE CONTENT
					SET 	inventory_type = :ls_type,	
							Country_of_Origin = :ls_coo,
							old_inventory_type = null, 
							old_country_of_origin = null,
							cc_no = null,
							last_user = :gs_userid,
							last_update = :ldtToday
					WHERE project_id = :gs_project AND
								wh_code = :ls_wh_code AND
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
								Expiration_Date = :ldt_expiration_date AND
								old_country_of_origin = :ls_coo AND
								old_inventory_type =:ls_type 
								USING SQLCA;
								// LTK 20150310  Removed ro_no from where clause above

				if sqlca.sqlcode < 0 then
					ls_SQLError = SQLCA.SQLErrText
					Execute Immediate "ROLLBACK" using SQLCA;
					Close (w_update_status)
					Messagebox ("DB Error", "Update content failed 5.  SQL Error reported: " + ls_SQLError)
					Return -1
				end if
				
				// 09/09 - PCONKL - If Random, reset the Random Ind to not counted so we  */
				// 03/12 - MEA - Added Sequential (Q)
				//2017/11 - TAM - If System Generated and Location Count, set the Random Ind to not counted */
//				If idw_main.GetItemString(1,"ord_Type") = 'R' OR idw_main.GetItemString(1,"ord_Type") = 'Q' Then
				If idw_main.GetItemString(1,"ord_Type") = 'R' OR idw_main.GetItemString(1,"ord_Type") = 'Q' OR (idw_main.GetItemString(1,"ord_Type") = 'X' and idw_system_generated.GetItemString(1,"Count_Type") = 'L'  ) Then
						
						If ls_loc <> lsLocSave Then
							
							Update Location
							Set CC_Rnd_Cnt_Ind = 'N',
							last_user = :gs_userid,
							last_update = :ldtToday
							Where wh_code = :ls_wh_code and l_code = :ls_loc;
							
							if sqlca.sqlcode < 0 then
								Execute Immediate "ROLLBACK" using SQLCA;
								Close (w_update_status)
								Messagebox ("DB Error", "Unable to update Random Cycle Count Indicator4")
								Return -1
							end if
							
							lsLocSave = ls_loc
					
						End If /*loc changed*/
						
				End If /*random CC*/
			
			next /*count2 row */
			

		ELSEIF idw_result3.DeletedCount() > 0 AND UPPER(gs_project) = 'PANDORA' THEN
			
			//dts - 2/28/13 for li_idx = 1 to  idw_si.DeletedCount ()
			for li_idx = 1 to  idw_result3.DeletedCount ()

			f_method_trace_special( gs_project, this.ClassName() , 'CC3 Deleted Count is: ' +String(idw_result3.DeletedCount ())  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.	

				w_update_status.hpb_status.Position = li_idx
			
				ls_wh_code 				= idw_main.object.wh_code[ 1 ]
				ls_loc 					= idw_result3.GetItemString( li_idx, "l_code", Delete!, false)
				ls_sku					= idw_result3.GetItemString( li_idx, "sku", Delete!, false)
				ls_supp					= idw_result3.GetItemString( li_idx, "supp_code", Delete!, false)
				ll_owner					= idw_result3.GetItemNumber( li_idx, "owner_id", Delete!, false)
				ls_type					= idw_result3.GetItemString( li_idx, "inventory_type", Delete!, false)
				ls_serial				= idw_result3.GetItemString( li_idx, "serial_no", Delete!, false)
				ls_lot					= idw_result3.GetItemString( li_idx, "lot_no", Delete!, false)
				ls_po						= idw_result3.GetItemString( li_idx, "po_no", Delete!, false)
				ls_po2					= idw_result3.GetItemString( li_idx, "po_no2", Delete!, false)
				ls_container_id		= idw_result3.GetItemString( li_idx, "container_id", Delete!, false)
				ldt_expiration_date	= idw_result3.GetItemDateTime( li_idx, "expiration_date", Delete!, false)
				ls_coo					= idw_result3.GetItemString( li_idx, "country_of_origin", Delete!, false)
//				ls_ro_no					= idw_result3.GetItemString( li_idx, "ro_no", Delete!, false)
				//dts - 2/27/2013 - 556-2; Setting the System Inventory location to ALLOCATED if deleting a line from counts
				ll_CurLine				= idw_result3.GetItemNumber( li_idx, "line_item_no", Delete!, false)
				ll_SI_Line = GetSysInvRow(ll_CurLine)
				//idw_SI.SetItem(ll_SI_Line, "l_code", "ALLOCATED")
				idw_SI.SetItem(ll_SI_Line, "l_code", "Allocated" + wf_find_greatest_allocated(ll_SI_Line))	// LTK 20140807  find allocated string which may be Allocated1, Allocated2, etc.
				f_method_trace_special( gs_project, this.ClassName() , 'Set Location =Allocated for SI records and  line no is:  ' +String(ll_SI_Line)  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
			//Need to delete from Count 1 and 2...s
				ll_DeleteLine = GetResultRow(idw_result1, ll_CurLine)
				//idw_result1.DeleteRow(ll_DeleteLine)		// LTK 20151021  don't delete prior count results
				ll_DeleteLine = GetResultRow(idw_result2, ll_CurLine)
				//idw_result2.DeleteRow(ll_DeleteLine)		// LTK 20151021  don't delete prior count results
				f_method_trace_special( gs_project, this.ClassName() , 'Deleting CC2 records and line no is:  ' +String(ll_DeleteLine)  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
				
				UPDATE CONTENT
					SET 	inventory_type = :ls_type,	
							Country_of_Origin = :ls_coo,
							old_inventory_type = null, 
							old_country_of_origin = null,
							cc_no = null,
							last_user = :gs_userid,
							last_update = :ldtToday
					WHERE project_id = :gs_project AND
								wh_code = :ls_wh_code AND
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
								Expiration_Date = :ldt_expiration_date AND
								old_country_of_origin = :ls_coo AND
								old_inventory_type =:ls_type 
								USING SQLCA;
								// LTK 20150310  Removed ro_no from where clause above
	
				if sqlca.sqlcode < 0 then
					ls_SQLError = SQLCA.SQLErrText
					Execute Immediate "ROLLBACK" using SQLCA;
					Close (w_update_status)
					Messagebox ("DB Error", "Update content failed 6.  SQL Error reported: " + ls_SQLError)
					Return -1
				end if
				
				// 09/09 - PCONKL - If Random, reset the Random Ind to not counted so we  */
				// 03/12 - MEA - Added Sequential (Q)
				//2017/11 - TAM - If System Generated and Location Count, set the Random Ind to not counted */
//				If idw_main.GetItemString(1,"ord_Type") = 'R' OR idw_main.GetItemString(1,"ord_Type") = 'Q' Then
				If idw_main.GetItemString(1,"ord_Type") = 'R' OR idw_main.GetItemString(1,"ord_Type") = 'Q' OR (idw_main.GetItemString(1,"ord_Type") = 'X' and idw_system_generated.GetItemString(1,"Count_Type") = 'L'  ) Then
						
						If ls_loc <> lsLocSave Then
							
							Update Location
							Set CC_Rnd_Cnt_Ind = 'N',
							last_user = :gs_userid,
							last_update = :ldtToday
							Where wh_code = :ls_wh_code and l_code = :ls_loc;
							
							if sqlca.sqlcode < 0 then
								Execute Immediate "ROLLBACK" using SQLCA;
								Close (w_update_status)
								Messagebox ("DB Error", "Unable to update Random Cycle Count Indicator5")
								Return -1
							end if
							
							lsLocSave = ls_loc
					
						End If /*loc changed*/
						
				End If /*random CC*/
			
			next /*count3 row */
			
		END IF  // checking for deleted rows in all the different counts
	
		ib_update_cc_inventory = true
	
	end if /*Header Exists and deletee rows */
	
// TAM - 2017/12/19 - 3PL CC - Remove System Criteria Rows where inventory was allocated and update Content to show it is not assigned to this Cycle Count. -Start  
String ls_System_Criteria_CC_Value

if idw_main.GetItemString(1,"ord_Type") = 'X' and Not isNull(isDeleteCCValues) and isDeleteCCValues <>  '' then	
	do WHILE isDeleteCCValues <> ''
		f_method_trace_special( gs_project, this.ClassName() , 'Removing Allocated System Criteria Values from '  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
		If Pos(isDeleteCCValues,',' ) > 0 Then
			ls_System_Criteria_CC_Value = Left(isDeleteCCValues,(pos(isDeleteCCValues,',') - 1))
			isDeleteCCValues = Right(isDeleteCCValues,(len(isDeleteCCValues) - (Len(ls_System_Criteria_CC_Value) + 1))) /*strip off to next value */
		Else 
			ls_System_Criteria_CC_Value = isDeleteCCValues
			isDeleteCCValues = ''
		End If
			
		if idw_system_generated.GetItemString(1,"count_type") = 'L'  Then //By Location
			UPDATE CONTENT
				SET 	CC_No = null,
						last_user = :gs_userid,
						last_update = :ldtToday
				WHERE project_id = :gs_project AND
						cc_no = :ls_cc_no AND
						L_Code = :ls_System_Criteria_CC_Value 
						USING SQLCA;
		Else //By Sku
			UPDATE CONTENT
				SET 	CC_No = null,
						last_user = :gs_userid,
						last_update = :ldtToday
				WHERE project_id = :gs_project AND
						cc_no = :ls_cc_no AND
						Sku = :ls_System_Criteria_CC_Value 
						USING SQLCA;
		End If 

		if sqlca.sqlcode < 0 then
			ls_SQLError = SQLCA.SQLErrText
			Execute Immediate "ROLLBACK" using SQLCA;
			Close (w_update_status)
			Messagebox ("DB Error", "Update content failed 7.  SQL Error reported: " + ls_SQLError)
			Return -1
		end if
		
		DELETE FROM CC_SYSTEM_CRITERIA
			WHERE 	cc_no = :ls_cc_no AND
						Count_Value = :ls_System_Criteria_CC_Value 
			USING SQLCA;
		if sqlca.sqlcode < 0 then
			ls_SQLError = SQLCA.SQLErrText
			Execute Immediate "ROLLBACK" using SQLCA;
			Close (w_update_status)
			Messagebox ("DB Error", "Delete from cc_system_criteria failed 8.  SQL Error reported: " + ls_SQLError)
			Return -1
		end if
		f_method_trace_special( gs_project, this.ClassName() , 'Removed Allocated System Criteria Values from'  ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
	Loop

	ib_update_cc_inventory = true
	
end if 
// TAM - 2017/12/19 - 3PL CC - Remove System Criteria Rows where inventory was allocated and update Content to show it is not assigned to this Cycle Count. -Start  

	If idw_main.RowCount() > 0 Then
		
		if  idw_main.GetItemString(1,"ord_status")  = "C" OR &
	 	   idw_main.GetItemString(1,"ord_status")  = "V"  then
		
			w_update_status.hpb_status.MaxPosition = idw_si.RowCount()
			w_update_status.st_status.text = 'Releasing CC Inventory Records...'
			
			lsLocSave = ''
			
			//MEA - 05/12 - Moved code outside of look to use CC_No

			// 09/09 - PCONKL - If Random, reset the Random Ind to not counted so we  */
			//2017/11 - TAM - If System Generated and Location Count, set the Random Ind to counted */
//			If idw_main.GetItemString(1,"ord_Type") = 'R' OR idw_main.GetItemString(1,"ord_Type") = 'Q' Then
			If idw_main.GetItemString(1,"ord_Type") = 'R' OR idw_main.GetItemString(1,"ord_Type") = 'Q' OR (idw_main.GetItemString(1,"ord_Type") = 'X' and idw_system_generated.GetItemString(1,"Count_Type") = 'L') Then
			
				
				for li_idx = 1 to idw_si.RowCount()				
					
					w_update_status.hpb_status.Position = li_idx

					ls_wh_code 				= idw_main.object.wh_code[ 1 ]
					ls_loc 						= idw_si.object.l_code[ li_idx ]				
					
					If ls_loc <> lsLocSave Then
						
						// Set to Y if complete, N if voiding
						If idw_main.GetItemString(1,"ord_status")  = "C" Then
						
							Update Location
							Set CC_Rnd_Cnt_Ind = 'Y',
							last_user = :gs_userid,
							last_update = :ldtToday
							Where wh_code = :ls_wh_code and l_code = :ls_loc;
							
						Else /*Void*/
							
							Update Location
							Set CC_Rnd_Cnt_Ind = 'N',
							last_user = :gs_userid,
							last_update = :ldtToday
							Where wh_code = :ls_wh_code and l_code = :ls_loc;
							
						End If
						
						if sqlca.sqlcode < 0 then
							Execute Immediate "ROLLBACK" using SQLCA;
							Close (w_update_status)
							Messagebox ("DB Error", "Unable to update Random Cycle Count Indicator6")
							Return -1
						end if
						
						lsLocSave = ls_loc
				
					End If /*loc changed*/
					
				next /*Sys Inv Record */
					
			End If /*random CC*/
			
			//MEA - Moved outside of Loop to use CC_No instead
			//2017/11 - TAM - 3PL CC - If confirmed then Update the Last Counted Date(New field)  Otherwise don't update(Split the update into 2 statement for "C" and "V"
			If idw_main.GetItemString(1,"ord_status")  = "C" Then
				UPDATE CONTENT
					SET 	inventory_type = old_inventory_type,	
							Country_of_Origin = old_country_of_origin,
							old_inventory_type = null, 
							old_country_of_origin = null,
							CC_No = null,
							last_user = :gs_userid,
							last_update = :ldtToday,
							last_cycle_count = :ldtToday
					WHERE project_id = :gs_project AND
								CC_No = :ls_cc_no
								USING SQLCA;
			Else ////2017/11 - TAM - 3PL CC - Not confirm so don't set Last Cycle Count Date
				UPDATE CONTENT
					SET 	inventory_type = old_inventory_type,	
							Country_of_Origin = old_country_of_origin,
							old_inventory_type = null, 
							old_country_of_origin = null,
							CC_No = null,
							last_user = :gs_userid,
							last_update = :ldtToday
					WHERE project_id = :gs_project AND
								CC_No = :ls_cc_no
								USING SQLCA;
			
		
			End If

			if sqlca.sqlcode < 0 then
				ls_SQLError = SQLCA.SQLErrText
				Execute Immediate "ROLLBACK" using SQLCA;
				Close (w_update_status)
				Messagebox ("DB Error", "Update content failed 9.  SQL Error reported: " + ls_SQLError)
				Return -1				
			end if	
		
		end if /*Complete or Void */
		
	End If /*Header Exists */
	
//	string ls_reason
//	string ls_ref
//	long ll_new_quantity, ll_old_quantity
//					
//	If idw_main.RowCount() > 0 Then
//		
//		if idw_main.GetItemString(1,"ord_status") = "C"  then
//			
//			w_update_status.st_status.text = 'Generating Stock Adjustments...'
//			w_update_status.hpb_status.MaxPosition = idw_si.RowCount()
//			
//			for li_idx = 1 to idw_si.RowCount()
//				
//				w_update_status.hpb_status.Position = li_idx
//	
//				if idw_si.GetItemNumber( li_idx, "generate_adjustment") = 1 then
//	
//					ls_reason =  idw_si.GetItemstring( li_idx, "reason") 
//
//					ls_wh_code 				= idw_main.object.wh_code[ 1 ]
//					ls_loc 						= idw_si.object.l_code[ li_idx ]
//					ls_sku						= idw_si.object.sku[ li_idx ] 
//					ls_supp						= idw_si.object.supp_code[ li_idx ]
//					ll_owner					= idw_si.object.owner_id[ li_idx ] 
//					ls_type						= idw_si.object.inventory_type[ li_idx ]
//					ls_serial					= idw_si.object.serial_no[ li_idx ]
//					ls_lot							= idw_si.object.lot_no[ li_idx ] 
//					ls_po						= idw_si.object.po_no[ li_idx ]
//					ls_po2						= idw_si.object.po_no2[ li_idx ] 
//					ls_container_id			= idw_si.object.container_id[ li_idx ] 
//					ldt_expiration_date	= idw_si.object.expiration_date[ li_idx ]
//					ls_coo						= idw_si.object.country_of_origin[ li_idx ]
//					ls_ro_no					= idw_si.object.ro_no[ li_idx ]						
//			
//			
//					//Create Adjustment
//				
//					ll_old_quantity = idw_si.GetItemNumber(li_idx,'quantity')
//				
//					ll_new_quantity = idw_si.GetItemNumber(li_idx,'new_quantity')
//
//					ls_ref =   idw_main.object.CC_No[ 1 ]   
//			
//					Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin,&
//													wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no, po_no, old_po_no,po_no2,old_po_no2,
//													container_ID, expiration_date, ro_no,old_quantity,quantity,ref_no,reason,last_user,last_update, Adjustment_Type,
//													old_lot_no) 
//					values						(:gs_project,:ls_sku,:ls_supp,:ll_owner,:ll_owner,:ls_coo,:ls_coo,:ls_wh_code,:ls_loc,:ls_type,:ls_type, &
//													:ls_serial,:ls_lot, :ls_po, :ls_po,:ls_po2,:ls_po2,
//													:ls_container_id, :ldt_expiration_date, :ls_ro_no, :ll_old_quantity, :ll_new_quantity,:ls_Ref,:ls_reason,:gs_userid,:ldtToday,'Q',
//													:ls_lot) 
//												
//					Using SQLCA;
//				
//					IF SQLCA.SQLCode <> 0 THEN
//					
//						MessageBox ("DB Error", SQLCA.SQLErrText )
//				
//						Execute Immediate "ROLLBACK" using SQLCA;
//					
//						return -1
//				
//					ELSE
//	
//						ulong ll_adj_num	
//	
//						SELECT @@IDENTITY INTO :ll_adj_num FROM adjustment;
//
//						idw_si.SetItem( li_idx, "adjust_no", ll_adj_num) 
//
//
//						UPDATE CONTENT
//						SET 	avail_qty = :ll_new_quantity
//						WHERE project_id = :gs_project AND
//								wh_code = :ls_wh_code AND
//								L_Code = :ls_loc AND
//								sku = :ls_sku AND
//								Supp_Code = :ls_supp AND
//								Owner_ID = :ll_owner AND
//								Inventory_Type = :ls_type AND
//								Serial_No = :ls_serial AND
//								Lot_No = :ls_lot AND
//								PO_No = :ls_po AND
//								PO_No2 = :ls_po2 AND
//								Container_ID = :ls_container_id AND
//								Expiration_Date = :ldt_expiration_date AND
//								Country_of_Origin = :ls_coo AND								
//								ro_no = :ls_ro_no
//								USING SQLCA;
//
//						if sqlca.sqlcode < 0 then
//							Execute Immediate "ROLLBACK" using SQLCA;
//							Return -1
//						end if	
//	
//					END IF /*SQLCode */
//		
//				end if /*Creating Adjustment*/
//
//			next /*Sys Inv Row */
//
//		end if /*Status = Complete */
//
//	end if /*Header exists*/
	
	Close(w_update_status)
	
End IF /*ib_freeze_cc_inventory */

If Upper(gs_project) = 'CHINASIMS'  THEN
	 SQLCA.DBParm = "disablebind =0"
End If
li_idx = 0
If ll_result = 1 Then 
	ll_result = idw_si.Update(False, False)
	li_idx++
End If
If ll_result = 1 Then 
	ll_result = idw_result1.Update(False, False)
	li_idx++
End If
If ll_result = 1 Then 
	ll_result = idw_result2.Update(False, False)
	li_idx++
End If
If ll_result = 1 Then 
	ll_result = idw_result3.Update(False, False)
	li_idx++
End If
If ll_result = 1 Then 
	ll_result = idw_mobile.Update(False, False) /* 05/14 - PCONKL*/
	li_idx++
End If
If ll_result = 1 Then 
	ll_result = idw_serial_numbers.Update(False, False) /* 2017/11 - TAM*/
	li_idx++
End If
If ll_result = 1 Then 
	ll_result = idw_cc_container.Update( False, False) //24-APR-2018 :Madhu S18502 - FootPrint Cycle Count
	li_idx++
End If
If idw_main.RowCount() = 0 and ll_result = 1 Then 
	ll_result  = idw_main.Update(False, False)
	li_idx++
End If

If Upper(gs_project) = 'CHINASIMS'  THEN
	 SQLCA.DBParm = "disablebind =1"
End If

If ll_result = 1 Then
	Execute Immediate "COMMIT" using SQLCA;
   If SQLCA.SQLCode = 0 Then
		idw_main.ResetUpdate()
		idw_si.ResetUpdate()
		idw_result1.ResetUpdate()
		idw_result2.resetupdate()
		idw_result3.resetupdate()
		idw_mobile.resetupdate() /* 05/14 - PCONKL*/
		idw_serial_numbers.resetupdate() /* 2017/11 - TAM*/
		idw_cc_container.resetupdate( ) //24-APR-2018 :Madhu S18502 - FootPrint Cycle Count
		If idw_main.RowCount() > 0 Then
			This.Title = is_title + " - Edit"
			ib_changed = False
			ib_edit = True
			wf_check_status()
			idw_main.SetFocus()
			isle_code.Trigger Event Modified()
		End If
		SetMicroHelp("Record Saved!")
		
		// Refresh Match checkboxes if on a count tab
		if getCountTab() = CC_RESULTS1_TAB and idw_result1.RowCount() > 0 then 
			doCountDiffRefresh( idw_result1 )
		end if
		if getCountTab() = CC_RESULTS2_TAB and idw_result2.RowCount() > 0 then 
			doCountDiffRefresh( idw_result2 )
		end if
		if getCountTab() = CC_RESULTS3_TAB and idw_result3.RowCount() > 0 then 
			doCountDiffRefresh( idw_result3 )
		end if
		
		f_method_trace_special( gs_project, this.ClassName() , 'End ue_save CC order ' ,isCCOrder, '','',isCCOrder) 
		Return 0 
   Else
		ls_SQLError = SQLCA.SQLErrText
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox(is_title, "Save failed.  SQL Error reported 10: " + ls_SQLError + "Update #" + String(li_idx))
		SetMicroHelp("Save failed!")
		f_method_trace_special( gs_project, this.ClassName() , 'End ue_save FAILED CC order ' + Nz(ls_SQLError, '') + "Update #" + String(li_idx),isCCOrder, '','',isCCOrder) 
		return -1
	End If
Else
	ls_SQLError = SQLCA.SQLErrText
	Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox(is_title, "Save failed.  SQL Error reported 11: " + ls_SQLError)
  	SetMicroHelp("Save Failed!")
	f_method_trace_special( gs_project, this.ClassName() , 'End ue_save FAILED CC order ' + Nz(ls_SQLError,'') ,isCCOrder, '','',isCCOrder) 
	return -1
End If

IF ib_update_cc_inventory THEN
	idw_si.REtrieve(idw_main.GetItemString(1,"CC_No"))
END IF

end event

event ue_delete;call super::ue_delete;Long i, ll_cnt



f_method_trace_special( gs_project, this.ClassName() , 'Start Delete CC order ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

If f_check_access(is_process,"D") = 0 Then Return

//SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
//Can't void - can't delete.
If idw_main.GetItemString(1, "ord_type") = "F" Then
	Messagebox(is_title, "Unable to delete Serial Reconciliation Cycle Count.") 
	Return
End If



If Messagebox(is_title, "Are you sure you want to delete this record?", Question!,yesno!,2) = 2 Then
	Return
End If

tab_main.SelectTab(1)

SetPointer(HourGlass!)

ll_cnt = idw_result1.Rowcount()
For i = ll_cnt to 1 Step -1
	idw_result1.DeleteRow(i)
Next

ll_cnt = idw_result2.Rowcount()
For i = ll_cnt to 1 Step -1
	idw_result2.DeleteRow(i)
Next

ll_cnt = idw_result3.Rowcount()
For i = ll_cnt to 1 Step -1
	idw_result3.DeleteRow(i)
Next

ll_cnt = idw_si.Rowcount()
For i = ll_cnt to 1 Step -1
	idw_si.DeleteRow(i)
Next

//04/15 - PCONKL
ll_cnt = idw_mobile.Rowcount()
For i = ll_cnt to 1 Step -1
	idw_mobile.DeleteRow(i)
Next

//TAM - 2017/11
ll_cnt = idw_system_generated.Rowcount()
For i = ll_cnt to 1 Step -1
	idw_system_generated.DeleteRow(i)
Next

//TAM - 2017/11
ll_cnt = idw_serial_numbers.Rowcount()
For i = ll_cnt to 1 Step -1
	idw_serial_numbers.DeleteRow(i)
Next
//idw_main.DeleteRow(1)

//09/09 - PCONKL - Save the subordinate tables before deleting the Master...
If This.Trigger Event ue_save() = 0 Then
	SetMicroHelp("Record deleted!")
	
	idw_main.DeleteRow(1)
	
	If This.Trigger Event ue_save() = 0 Then
		SetMicroHelp("Record deleted!")
	Else
		SetMicroHelp("Record	deleted failed!")
	End If
	
Else
	SetMicroHelp("Record	deleted failed!")
End If



ib_changed = False


This.Trigger Event ue_edit()

f_method_trace_special( gs_project, this.ClassName() , 'End Delete CC order ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

end event

event ue_new;// Acess Rights
datetime ldtToday
Long	ll_no
String	ls_order

ldtToday = f_getLocalWorldTime( gs_default_wh ) 

If f_check_access(is_process,"N") = 0 Then Return

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - New"
ib_edit = False
ib_changed = False
idw_si.Reset()
idw_result1.Reset()
idw_result2.Reset()
idw_result3.Reset()
idw_mobile.Reset()

wf_clear_screen()
setPrtBlindMessage( '' )
setBlindMessage( '' )

f_method_trace_special( gs_project, this.ClassName() , 'Start New CC order ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

idw_main.InsertRow(0)
idw_main.SetItem(1, "ord_date", ldtToday )
idw_main.SetITem(1,'wh_Code',gs_default_wh)

// 09/09 - PCONKL - Assign the Order Number here instead of first save
ll_no = g.of_next_db_seq(gs_project,'CC_Master','CC_No')
	
If ll_no <= 0 Then
	messagebox(is_title,"Unable to retrieve the next available order Number!")
	Return 
End If
	
ls_order = Trim(Left(gs_project,9)) + String(ll_no,"000000")
	
idw_main.setitem(1,"cc_no",ls_order)	
setCCOrder( ls_order )
	
idw_main.setitem(1,"project_id",gs_project)	
isle_code.Text = ls_order


// 09/09 - PCONKL - Default to 'Random' for Pandora
// 03/12 - MEA - Changed to 'Q'
If gs_project = 'PANDORA' Then
	idw_Main.SetItem(1,'Ord_type','Q')
End IF

// 12/11 -MEA - Nike
If left(gs_project,4) = 'NIKE' Then
	idw_Main.SetItem(1,'user_field1', '45')
End IF


// pvh - 07/17/06 ccmods
// display the default warehouse
datawindowchild achild
long achildRow
string findthis

idw_main.getchild( "wh_code", achild )
achild.settransobject( sqlca )
findthis = "wh_code = ~'" + Upper(Trim( gs_default_wh)) + "'"
aChildRow = achild.find( findthis,1, achild.rowcount() )
if aChildRow > 0 then
	achild.scrolltorow( achildRow )
	achild.selectrow( achildRow,true )
	achild.setrow( achildRow )
end if
// eod

wf_check_status()

isle_code.DisplayOnly = True
isle_code.TabOrder = 0

idw_main.Show()

idw_main.SetFocus()

// 09/09 - PCONKL - If a default warehouse was assigned and a random count, retreieve the random settings. This is triggered by selecting a warehouse
//							but not being set if a warehouse is already defaulted here
If (Idw_Main.GetITemString(1,'Ord_type') = 'R' OR Idw_Main.GetITemString(1,'Ord_type') = 'Q' ) and idw_Main.GetItemString(1,'wh_code') > '' Then
	idw_main.PostEvent('ue_check_random_settings')
End If

datawindowchild ldwc
long ll_Find

//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
//Don't show the Serial Reconciliation Type if new Cycle count.

idw_main.GetChild('ord_type',ldwc)
ll_Find = ldwc.Find("count_by_data_value='F'", 1, ldwc.RowCount())
if ll_Find > 0 then
	ldwc.DeleteRow(ll_Find)
end if



f_method_trace_special( gs_project, this.ClassName() , 'End New CC order ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

Return





end event

event ue_retrieve;call super::ue_retrieve;isle_code.Trigger Event Modified()

end event

event ue_refresh;//MessageBox(is_title, "Save record to re-fresh the counted quantity!")

end event

event close;call super::close;destroy n_warehouse
f_method_trace_special( gs_project, this.ClassName() , 'Close CC order ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
end event

event ue_postopen;call super::ue_postopen;// ET3 - 12-04-12: Adding user_field1 to search for Pandora


String	lsFilter, lsAdjustment
Long ll_Row, ll_FindRow

String lsOrigSql, lsModify, ls_NewSql, ls_lot

DataWindowChild ldwc_warehouse,&
                          ldwc, &
                          ldwc2, &
                          ldwc_CountBy, &
                          ldwc_OrdTypSearch, &
                          ldwc_OrdTypResult

datawindowchild ldwc_reason
	
ib_changed = False
ib_up_count_zero_cc =FALSE

iw_window = This

//TAM 2017/12/4 - Added 2 new tabs for 3pl cc
//tab_main.MoveTab(2, 8)
tab_main.MoveTab(2, 11)
i_nwarehouse = Create n_warehouse

SqlUtil = Create u_sqlutil

f_method_trace_special( gs_project, this.ClassName() , 'Start Post Opened CC order ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

// SIM-29	LTK 20101216	Pandora specific format changes to the datawindow object.
//				Removed supplier column and widened the Owner field.
// ET3 - no 373; UF1 to search for Pandora
//TimA 04/19/12 changed the lable name to user_field1_t
if upper(gs_project) = 'PANDORA' then	
	idsReport = f_dataStoreFactory( 'd_cc_report_pandora' )
	tab_main.tabpage_search.dw_search.object.user_field1_t.Visible = 1
	tab_main.tabpage_search.dw_search.object.user_field1.Visible = 1
else
	idsReport = f_dataStoreFactory( 'd_cc_report' )
	tab_main.tabpage_search.dw_search.object.user_field1_t.Visible = 0
	tab_main.tabpage_search.dw_search.object.user_field1.Visible = 0
end if

idsItemMaster =  f_dataStoreFactory( 'd_item_master' )

// Storing into variables
idw_main = tab_main.tabpage_main.dw_main
idw_search = tab_main.tabpage_search.dw_search
idw_result = tab_main.tabpage_search.dw_result
idw_si = tab_main.tabpage_si.dw_si
idw_si.setrowfocusindicator( p_arrow )

// pvh 06/13/06
setSortOrder( idw_si.object.DataWindow.Table.Sort )

idw_result1 = tab_main.tabpage_result1.dw_result1
idw_result1.setrowfocusindicator( p_arrow )
idw_result2 = tab_main.tabpage_result2.dw_result2
idw_result2.setrowfocusindicator( p_arrow )
idw_result3 = tab_main.tabpage_result3.dw_result3
idw_result3.setrowfocusindicator( p_arrow )
idw_mobile = tab_main.tabpage_Mobile.dw_mobile /* 04/15 - pconkl*/
idw_system_generated = tab_main.tabpage_System_Generated.dw_system_generated /* TAM - 2017/11 l*/
idw_serial_numbers = tab_main.tabpage_serial_numbers.dw_serial_numbers /* TAM - 2017/11 l*/
idw_serial_numbers.setrowfocusindicator( p_arrow )
idw_cc_container = tab_main.tabpage_container.dw_cc_container //24-APR-2018 :Madhu S18502 - FootPrint Cycle Count
idw_cc_container.setrowfocusindicator( p_arrow )

isle_code = tab_main.tabpage_main.sle_no
isle_code.taborder = 0
idw_main.SetTransObject(Sqlca)
idw_search.SetTransObject(Sqlca)
idw_result.SetTransObject(Sqlca)

idw_si.SetTransObject(Sqlca)

idw_result1.SetTransObject(Sqlca)
idw_result2.SetTransObject(Sqlca)
idw_result3.SetTransObject(Sqlca)
idw_cc_container.settransobject( SQLCA)

//dgm supplier drop down dwc 10/05/00
idw_result1.GetChild('supp_code', idwc_count1_supp)
idw_result2.GetChild('supp_code', idwc_count2_supp)
idw_result3.GetChild('supp_code', idwc_count3_supp)
idwc_count1_supp.SetTransObject(SQLCA)
idwc_count2_supp.SetTransObject(SQLCA)
idwc_count3_supp.SetTransObject(SQLCA)
idw_Main.SetTransObject(SQLCA) /* 04/15 - PCONKL */

idwc_count1_supp.InsertRow(0) //in order to take care of retrieval arguments
idwc_count2_supp.InsertRow(0) //in order to take care of retrieval arguments
idwc_count3_supp.InsertRow(0) //in order to take care of retrieval arguments

idw_search.GetChild("wh_code", ldwc_warehouse)
ldwc_warehouse.SetTransObject(Sqlca)

idw_result1.GetChild("owner_id", idwc_owner)
idwc_owner.SetTransObject(Sqlca)

g.of_set_warehouse_dropdown(ldwc_warehouse) /* 04/04 - PCONKL - Load from User Warehouse Table */

idw_main.GetChild("wh_code",ldwc2)
ldwc_warehouse.ShareData(ldwc2)

idw_search.InsertRow(0)

//added by dgm
//03/02 - PCONKL - Now retrieving by Project (in N_Warehouse) - Results 1,2 & 3 will be shared to Sys Inv
idw_si.GetChild('inventory_type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_project)

//TimA 08/27/12 Pandora issue #446 Show the reason code field
if upper(gs_project) = 'PANDORA' then	
	idw_si.Modify("reason.Visible='1'")
	idw_si.Modify("reason_t.Visible='1'")	

	idw_si.Modify("reason.Edit.Style='dddw'")
	
	idw_si.Modify("reason.dddw.Case='Any'")
	idw_si.Modify("reason.dddw.DataColumn='code_id'")
	idw_si.Modify("reason.dddw.DisplayColumn='compute_1'")
	idw_si.Modify("reason.dddw.Limit=30")
	idw_si.Modify("reason.dddw.Name='dddw_lookup'")
	idw_si.Modify("reason.dddw.PercentWidth=100")
	idw_si.Modify("reason.dddw.VScrollBar=Yes")	
Else
	idw_si.Modify("reason.Visible='0'")
	idw_si.Modify("reason_t.Visible='0'")	
	idw_si.Modify("reason_t.width='0'")
	idw_si.Modify("reason.width='0'")

End if

idw_si.Modify("ro_no_t.Visible='0'")	
idw_si.Modify("ro_no.Visible='0'")	

idw_result1.GetChild('inventory_Type',ldwc2)
ldwc2.SetTransObject(SQLCA)
ldwc.ShareData(ldwc2)

//TimA 08/27/12 Pandora issue #446 Show the reason code field
if upper(gs_project) = 'PANDORA' then	
	idw_si.GetChild("reason",ldwc_reason)
	ldwc_reason.SetTransObject(SQLCA)
	ldwc_reason.Retrieve(gs_project,'IA')
End if

idw_result2.GetChild('inventory_Type',ldwc2)
ldwc2.SetTransObject(SQLCA)
ldwc.ShareData(ldwc2)

idw_result3.GetChild('inventory_Type',ldwc2)
ldwc2.SetTransObject(SQLCA)
ldwc.ShareData(ldwc2)

is_sql = idw_result.GetSQLSelect()

// pvh - 06/28/06 - ccmods
idw_main.Getchild("group", idwc_group )
idwc_group.Settransobject(sqlca)
If idwc_group.Retrieve( gs_project  ) < 1 Then
	idwc_group.InsertRow(0)
End If

idw_main.Getchild("class", idwc_class)
idwc_class.Settransobject(sqlca)
If idwc_class.Retrieve( gs_project  ) < 1 Then
	idwc_class.InsertRow(0)
End If

// 2/9/2011; David C; Add "Pandora Directed" to the "Count By" and "Order Type" dropdowns and 
// change "Random" to "Sequential" for Pandora only

//TAM 2017/05 SIMSPEVS-420 and SIMSPEVS-513  - Added "Commodity" to the "Count By" and "Order Type" and "Allocated" to the "Order Status"
//TAM 2017/11 3PL CC  - Added "System  Generated" to the "Count By" and "Order Type" dropdowns

if Upper ( gs_project ) = "PANDORA" then
	idw_main.GetChild ( "ord_type", ldwc_CountBy )
	idw_search.GetChild ( "ord_type", ldwc_OrdTypSearch )
	idw_result.GetChild ( "ord_type", ldwc_OrdTypResult )
	
	ll_Row = ldwc_CountBy.InsertRow ( 0 )
	ldwc_CountBy.SetItem ( ll_Row, "count_by_display_value", "Pandora Directed" )
	ldwc_CountBy.SetItem ( ll_Row, "count_by_data_value", "P" )
	
	ll_Row = ldwc_OrdTypSearch.InsertRow ( 0 )
	ldwc_OrdTypSearch.SetItem ( ll_Row, "count_by_display_value", "Pandora Directed" )
	ldwc_OrdTypSearch.SetItem ( ll_Row, "count_by_data_value", "P" )
	
	ll_Row = ldwc_OrdTypResult.InsertRow ( 0 )
	ldwc_OrdTypResult.SetItem ( ll_Row, "count_by_display_value", "Pandora Directed" )
	ldwc_OrdTypResult.SetItem ( ll_Row, "count_by_data_value", "P" )

	ll_Row = ldwc_CountBy.InsertRow ( 0 )
	ldwc_CountBy.SetItem ( ll_Row, "count_by_display_value", "System  Generated" )
	ldwc_CountBy.SetItem ( ll_Row, "count_by_data_value", "X" )
	
	ll_Row = ldwc_OrdTypSearch.InsertRow ( 0 )
	ldwc_OrdTypSearch.SetItem ( ll_Row, "count_by_display_value", "System  Generated" )
	ldwc_OrdTypSearch.SetItem ( ll_Row, "count_by_data_value", "X" )
	
	ll_Row = ldwc_OrdTypResult.InsertRow ( 0 )
	ldwc_OrdTypResult.SetItem ( ll_Row, "count_by_display_value", "System  Generated" )
	ldwc_OrdTypResult.SetItem ( ll_Row, "count_by_data_value", "X" )
	
	ll_Row = ldwc_CountBy.InsertRow ( 0 )
	ldwc_CountBy.SetItem ( ll_Row, "count_by_display_value", "Commodity" )
	ldwc_CountBy.SetItem ( ll_Row, "count_by_data_value", "C" )
	
	ll_Row = ldwc_OrdTypSearch.InsertRow ( 0 )
	ldwc_OrdTypSearch.SetItem ( ll_Row, "count_by_display_value", "Commodity" )
	ldwc_OrdTypSearch.SetItem ( ll_Row, "count_by_data_value", "C" )
	
	ll_Row = ldwc_OrdTypResult.InsertRow ( 0 )
	ldwc_OrdTypResult.SetItem ( ll_Row, "count_by_display_value", "Commodity" )
	ldwc_OrdTypResult.SetItem ( ll_Row, "count_by_data_value", "C" )

//MA 3/8/12 - Comment out As Per Pete	
	
//	ll_FindRow = ldwc_CountBy.Find ( "count_by_display_value = 'Random'", 1, ldwc_CountBy.RowCount ( ) )
//	
//	if ll_FindRow > 0 then ldwc_CountBy.SetItem ( ll_FindRow, "count_by_display_value", "Sequential" )
//			
//	ll_FindRow = ldwc_OrdTypSearch.Find ( "count_by_display_value = 'Random'", 1, ldwc_OrdTypSearch.RowCount ( ) )
//	
//	if ll_FindRow > 0 then ldwc_OrdTypSearch.SetItem ( ll_FindRow, "count_by_display_value", "Sequential" )
//	
//	ll_FindRow = ldwc_OrdTypResult.Find ( "count_by_display_value = 'Random'", 1, ldwc_OrdTypResult.RowCount ( ) )
//	
//	if ll_FindRow > 0 then ldwc_OrdTypResult.SetItem ( ll_FindRow, "count_by_display_value", "Sequential" )
end if


datawindowchild ldw_child

if Left( gs_project,4 ) = "NIKE" then
	
	idw_main.Object.user_field2.dddw.Name             = "dddw_inventory_type_by_project"
	idw_main.Object.user_field2.dddw.DataColumn    = "inv_type"
	idw_main.Object.user_field2.dddw.DisplayColumn = "inv_type_desc"
	idw_main.Object.user_field2.dddw.UseAsBorder    = "Yes"
	idw_main.Object.user_field2.dddw.VScrollBar       = "Yes"
	
	idw_main.GetChild ( "user_field2", ldw_child )
	ldw_child.SetTransObject ( SQLCA )
	ldw_child.Retrieve ( gs_project)
	
	integer li_row
	
	li_row = ldw_child.InsertRow(1)
	
	ldw_child.SetItem( li_row, "inv_type", " ")
	ldw_child.SetItem( li_row, "inv_type_desc", "(All)")	
	
end if


// LTK 20150115   Moved the following lines downs
//
//if left(gs_project,4) = 'NIKE' then
//	idw_result1.Object.quantity.EditMask.Mask = "######0"
//	idw_result2.Object.quantity.EditMask.Mask =  "######0"
//	idw_result3.Object.quantity.EditMask.Mask =  "######0"
//end if

//GailM - 1/9/2018 - I365 F5739 S14726 - PAN SIMS Cycle Count do not auto-populate qty field
// LTK 20150115  Allow quantity decimals based on project flag
if g.iballowquantitydecimals then
	idw_result1.Object.quantity.EditMask.Mask = "#######.#####"
	idw_result2.Object.quantity.EditMask.Mask =  "#######.#####"
	idw_result3.Object.quantity.EditMask.Mask =  "#######.#####"
else
//	if left(gs_project,4) = 'NIKE' then
//		idw_result1.Object.quantity.EditMask.Mask = "#######"
//		idw_result2.Object.quantity.EditMask.Mask =  "#######"
//		idw_result3.Object.quantity.EditMask.Mask =  "#######"
//	else
//		idw_result1.Object.quantity.EditMask.Mask = "#######"
//		idw_result2.Object.quantity.EditMask.Mask =  "#######"
//		idw_result3.Object.quantity.EditMask.Mask =  "#######"
//	end if

	if left(gs_project,4) = 'NIKE' then
		idw_result1.Object.quantity.EditMask.Mask = "#######"
		idw_result2.Object.quantity.EditMask.Mask =  "#######"
		idw_result3.Object.quantity.EditMask.Mask =  "#######"
	else
		idw_result1.Object.quantity.EditMask.Mask = "#######"
		idw_result2.Object.quantity.EditMask.Mask =  "#######"
		idw_result3.Object.quantity.EditMask.Mask =  "#######"
	end if

end if

// ET3 2013-01-17 Set initial value for quantity to NULL
idw_result1.Modify("quantity.Initial = 'NULL'")
idw_result2.Modify("quantity.Initial = 'NULL'")
idw_result3.Modify("quantity.Initial = 'NULL'")

// 02/16 - PCONKL - If project allows and User is authorized, we will allow adjustments to be created
If f_check_access ("W_ADJ","") = 1 Then 
	
	//User authorized, check for Project authorzation
	Select Allow_Adjustment_In_CC into :lsAdjustment
	From Project
	Where Project_id = :gs_project
	Using SQLCA;
	
	If lsAdjustment = 'Y' Then
		ib_Adjustments_Allowed = True
	End If
	
End If

////07-May-2017 :TAM - PEVS-420 -Stock Inventory Commodity Codes - START
If upper(gs_project) ='PANDORA' Then
	wf_multi_select_commodity_code()
	idw_main.modify("commodity_select_t.visible =false")
	idw_main.modify("commodity_select.visible =false")
	tab_main.tabpage_main.uo_commodity_code1.bringtotop = false
	tab_main.tabpage_main.uo_commodity_code1.visible = false
End If
//



// Default into edit mode
This.TriggerEvent("ue_edit")

// LTK 20150714  CC Rollup changes
in_string_util = CREATE n_string_util
ib_verbose_tracing = ( f_retrieve_parm( gs_project, "FLAG", "VERBOSE_CC" ) = "Y" )

//NOV 2019 - MikeA F17679 S36894 I2538 - KNY - City of New York EM - Ability to Cycle Count Components

 tab_main.tabpage_result1.cbx_include_components1.visible = false
 tab_main.tabpage_result2.cbx_include_components2.visible = false
 tab_main.tabpage_result3.cbx_include_components3.visible = false

f_method_trace_special( gs_project, this.ClassName() , 'Close Post Opened CC order ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
end event

event open;call super::open;
string ls_cc_freeze_CC_Inventory

ilHelpTopicID = 531 /*Set Help Topic ID */

ib_freeze_cc_inventory = false

f_method_trace_special( gs_project, this.ClassName() , 'Open CC order ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

SELECT freeze_CC_Inventory INTO :ls_cc_freeze_CC_Inventory FROM project WHERE Project_ID = :gs_project USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN
	MessageBox("DB Error", SQLCA.SQLErrText)
END IF

IF ls_cc_freeze_CC_Inventory = "Y" THEN
	ib_freeze_cc_inventory = true
END IF


//04/15 - PCONKL
If Not g.ibMobileEnabled Then
	tab_main.tabpage_mobile.visible=false
End If

//TAM 2017/11 - 3PL CC - Added new system generated tab- invisible until after retrieve
//tab_main.tabpage_System_Generated.visible=false

//TAM 2017/11 - 3PL CC - Added new system generated tab- invisible until after retrieve
//tab_main.tabpage_serial_numbers.visible=false
end event

event resize;call super::resize;tab_main.Resize(workspacewidth(),workspaceHeight())

tab_main.tabpage_si.dw_si.event ue_resize()

//tab_main.tabpage_si.dw_si.Resize(workspacewidth() - 50,workspaceHeight()-130)
tab_main.tabpage_result1.dw_result1.Resize(workspacewidth() - 50,workspaceHeight()-250)
tab_main.tabpage_result2.dw_result2.Resize(workspacewidth() - 50,workspaceHeight()-250)
tab_main.tabpage_result3.dw_result3.Resize(workspacewidth() - 50,workspaceHeight()-250)
tab_main.tabpage_mobile.dw_mobile.Resize(workspacewidth() - 50,workspaceHeight()-120) /* 04/15 - PCONKL */
//TimA 05/16/12 Changed the height from -400 to -475 because it was just not quite small enough.  The scroll bottom arrow was not showing
tab_main.tabpage_search.dw_result.Resize(workspacewidth() - 50,workspaceHeight()-475)
tab_main.tabpage_system_generated.dw_system_generated.Resize(workspacewidth() - 50,workspaceHeight()-120) /* TAM - 2017/11 */
tab_main.tabpage_serial_numbers.dw_serial_numbers.Resize(workspacewidth() - 50,workspaceHeight()-120) /* TAM - 2017/11 */
tab_main.tabpage_container.dw_cc_container.Resize(workspacewidth() - 50,workspaceHeight()-120) //24-APR-2018 :Madhu S18502 - FootPrint Cycle Count

//int index
//int max
//
//max = UpperBound( control )
//for index = 1 to max
//	choose case typeof( control[ index ] )
//		case datawindow!, commandbutton!, userobject!
//			control[index].event dynamic ue_resize()
//	end choose
//next
//

end event

event ue_sort;//This Event displays the sor criterial & sorts by the desire criteria
long ll_ret
String str_null

SetNull(str_null)
IF isvalid(idw_current) THEN
	ll_ret=idw_current.Setsort(str_null)
	ll_ret=idw_current.Sort()
	if isnull(ll_ret) then ll_ret=0
END IF	
setSortOrder( idw_current.object.DataWindow.Table.Sort )
wf_sort()
return ll_ret	

end event

event ue_filter;return 0


end event

event ue_file;
//Ancestor Overridden

String	lsAction
//Triggered from Menu

lsAction = Message.StringParm

Choose CAse Upper(lsACtion)
		
	Case 'SAVEAS' /*export*/

//TimA Change to NIKE per Arun
	If left(gs_project,4) = 'NIKE' Then		
			wf_print_export_report(2)
		else
			idw_Current.SaveAs()
		end if
			
End Choose

end event

type tab_main from w_std_master_detail`tab_main within w_cc
event create ( )
event destroy ( )
integer x = 0
integer y = 0
integer width = 4315
integer height = 2036
integer textsize = -8
tabpage_si tabpage_si
tabpage_result1 tabpage_result1
tabpage_result2 tabpage_result2
tabpage_result3 tabpage_result3
tabpage_mobile tabpage_mobile
tabpage_system_generated tabpage_system_generated
tabpage_serial_numbers tabpage_serial_numbers
tabpage_container tabpage_container
end type

on tab_main.create
this.tabpage_si=create tabpage_si
this.tabpage_result1=create tabpage_result1
this.tabpage_result2=create tabpage_result2
this.tabpage_result3=create tabpage_result3
this.tabpage_mobile=create tabpage_mobile
this.tabpage_system_generated=create tabpage_system_generated
this.tabpage_serial_numbers=create tabpage_serial_numbers
this.tabpage_container=create tabpage_container
call super::create
this.Control[]={this.tabpage_main,&
this.tabpage_search,&
this.tabpage_si,&
this.tabpage_result1,&
this.tabpage_result2,&
this.tabpage_result3,&
this.tabpage_mobile,&
this.tabpage_system_generated,&
this.tabpage_serial_numbers,&
this.tabpage_container}
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_si)
destroy(this.tabpage_result1)
destroy(this.tabpage_result2)
destroy(this.tabpage_result3)
destroy(this.tabpage_mobile)
destroy(this.tabpage_system_generated)
destroy(this.tabpage_serial_numbers)
destroy(this.tabpage_container)
end on

event tab_main::selectionchanging;datawindow idw
setnull(idw)

// LTK 20150330  The change below fixes an issue that was showing up on CC Report #8 which was not reporting inventory correctly (because of l_code on SI and Count Tabs).
// The change below closes a path that allowed lines being released on the System Inventory to not correctly set the l_code to Allocated on the Count Tabs.
// To reproduce the issue:  1. Generate System Inventory (don't save)   2. Generate Count 1 (don't save)   3.  Release line(s) on System Inventory   4.  Save.   5.  Results: l_code mismatched.
// This path was not setting Order Status until the last Save, therefore the Allocated string was not propagating correctly to the Count Tabs.
if oldindex >= 3 and oldindex <= 9 then		// Count Tabs
	if ib_changed then
		MessageBox(is_title, "Please save changes first!")
		return 1
	end if
end if

if IsValid( im_menu ) then wf_check_menu( TRUE, 'sort' )
IF newindex = 1 THEN 
	if IsValid( im_menu ) then wf_check_menu( FALSE, 'sort' )
	idw_current=idw
END IF	
IF newindex = 2 THEN idw_current=idw_si
IF newindex = 3 THEN idw_current=idw_result1
IF newindex = 4 THEN idw_current=idw_result2
IF newindex = 5 THEN idw_current=idw_result3
//IF newindex = 6 THEN idw_current=idw_result
IF newindex = 6 THEN idw_current=idw_mobile	// LTK 20150714  Added the reference to mobile tab and incremented the search to 7
IF newindex = 7 THEN idw_current=idw_system_generated // TAM 2017/11  Added the reference to System Generated tab and incremented the search to 9
IF newindex = 8 THEN idw_current=idw_serial_numbers // TAM 2017/11  Added the reference to Serial Numbers tab and incremented the search to 9
IF newindex = 9 THEN idw_current = idw_cc_container //24-APR-2018 :Madhu S18502 - FootPrint Cycle Count
IF newindex = 10 THEN idw_current=idw_result

setBlindKnown(  )
setBlindKnownPrt(  )
doDisplaySysQty( getBlindKnown() = 'K' )

end event

event tab_main::selectionchanged;call super::selectionchanged;setCountTab( newindex )
choose case newindex
	case 3
		doCountDiffRefresh( idw_result1 )
		If idw_result2.rowcount( ) > 0 Then	of_protectresults(idw_result1, PROTECT) //17-Jun-2014 :Madhu- Added code to Lock CC1, if CC2 has records.
	case 4
		doCountDiffRefresh( idw_result2 )
		If idw_result3.rowcount( ) > 0 Then	of_protectresults(idw_result2, PROTECT) //17-Jun-2014 :Madhu- Added code to Lock CC2, if CC3 has records.
	case 5
		doCountDiffRefresh( idw_result3 )
end choose


end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer y = 104
integer width = 4279
integer height = 1916
string text = "Order Information"
cb_commodity cb_commodity
cb_adjustments cb_adjustments
rb_location rb_location
rb_sku rb_sku
cb_export cb_export
cb_void cb_void
st_cc_owner_nbr st_cc_owner_nbr
cb_generate cb_generate
cb_report cb_report
cb_confirm cb_confirm
sle_no sle_no
cb_import_sku cb_import_sku
gb_1 gb_1
cb_stock_verification_report cb_stock_verification_report
st_4 st_4
sle_start_loc sle_start_loc
st_5 st_5
sle_end_loc sle_end_loc
uo_commodity_code1 uo_commodity_code1
select_commodity_t select_commodity_t
gb_import_sku gb_import_sku
dw_sku dw_sku
dw_main dw_main
end type

on tabpage_main.create
this.cb_commodity=create cb_commodity
this.cb_adjustments=create cb_adjustments
this.rb_location=create rb_location
this.rb_sku=create rb_sku
this.cb_export=create cb_export
this.cb_void=create cb_void
this.st_cc_owner_nbr=create st_cc_owner_nbr
this.cb_generate=create cb_generate
this.cb_report=create cb_report
this.cb_confirm=create cb_confirm
this.sle_no=create sle_no
this.cb_import_sku=create cb_import_sku
this.gb_1=create gb_1
this.cb_stock_verification_report=create cb_stock_verification_report
this.st_4=create st_4
this.sle_start_loc=create sle_start_loc
this.st_5=create st_5
this.sle_end_loc=create sle_end_loc
this.uo_commodity_code1=create uo_commodity_code1
this.select_commodity_t=create select_commodity_t
this.gb_import_sku=create gb_import_sku
this.dw_sku=create dw_sku
this.dw_main=create dw_main
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_commodity
this.Control[iCurrent+2]=this.cb_adjustments
this.Control[iCurrent+3]=this.rb_location
this.Control[iCurrent+4]=this.rb_sku
this.Control[iCurrent+5]=this.cb_export
this.Control[iCurrent+6]=this.cb_void
this.Control[iCurrent+7]=this.st_cc_owner_nbr
this.Control[iCurrent+8]=this.cb_generate
this.Control[iCurrent+9]=this.cb_report
this.Control[iCurrent+10]=this.cb_confirm
this.Control[iCurrent+11]=this.sle_no
this.Control[iCurrent+12]=this.cb_import_sku
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.cb_stock_verification_report
this.Control[iCurrent+15]=this.st_4
this.Control[iCurrent+16]=this.sle_start_loc
this.Control[iCurrent+17]=this.st_5
this.Control[iCurrent+18]=this.sle_end_loc
this.Control[iCurrent+19]=this.uo_commodity_code1
this.Control[iCurrent+20]=this.select_commodity_t
this.Control[iCurrent+21]=this.gb_import_sku
this.Control[iCurrent+22]=this.dw_sku
this.Control[iCurrent+23]=this.dw_main
end on

on tabpage_main.destroy
call super::destroy
destroy(this.cb_commodity)
destroy(this.cb_adjustments)
destroy(this.rb_location)
destroy(this.rb_sku)
destroy(this.cb_export)
destroy(this.cb_void)
destroy(this.st_cc_owner_nbr)
destroy(this.cb_generate)
destroy(this.cb_report)
destroy(this.cb_confirm)
destroy(this.sle_no)
destroy(this.cb_import_sku)
destroy(this.gb_1)
destroy(this.cb_stock_verification_report)
destroy(this.st_4)
destroy(this.sle_start_loc)
destroy(this.st_5)
destroy(this.sle_end_loc)
destroy(this.uo_commodity_code1)
destroy(this.select_commodity_t)
destroy(this.gb_import_sku)
destroy(this.dw_sku)
destroy(this.dw_main)
end on

event tabpage_main::rbuttondown;call super::rbuttondown;String ls_datetime
ls_datetime = String( now(), "YYYYMMDDHHmmss" )

idw_si.SaveAs("c:\temp\si" + ls_datetime + ".csv", csv!, true)
idw_result1.SaveAs("c:\temp\cc1_count" + ls_datetime + ".csv", csv!, true)
idw_result2.SaveAs("c:\temp\cc2_count" + ls_datetime + ".csv", csv!, true)
idw_result3.SaveAs("c:\temp\cc3_count" + ls_datetime + ".csv", csv!, true)

end event

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer y = 104
integer width = 4279
integer height = 1916
cb_search cb_search
dw_search dw_search
cb_clear cb_clear
dw_result dw_result
end type

on tabpage_search.create
this.cb_search=create cb_search
this.dw_search=create dw_search
this.cb_clear=create cb_clear
this.dw_result=create dw_result
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_search
this.Control[iCurrent+2]=this.dw_search
this.Control[iCurrent+3]=this.cb_clear
this.Control[iCurrent+4]=this.dw_result
end on

on tabpage_search.destroy
call super::destroy
destroy(this.cb_search)
destroy(this.dw_search)
destroy(this.cb_clear)
destroy(this.dw_result)
end on

type cb_commodity from commandbutton within tabpage_main
boolean visible = false
integer x = 2807
integer y = 1408
integer width = 576
integer height = 100
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Add Commodities..."
end type

event clicked;
//Add the list of commodity codes select

string lscommodity_string

//07-May-2017 :TAM - PEVS-513 -Stock Inventory Commodity Codes - START
//	if idw_main.GetItemString(1, "Commodity_list") <> "" and not IsNull(idw_main.GetItemString(1, "Commodity_list")) then
	lscommodity_string = tab_main.tabpage_main.uo_commodity_code1.uf_build_component_list(true)
	if lscommodity_string <> "" and not IsNull(lscommodity_string) then
	   	idw_main.SetItem(1, "Commodity_list",lscommodity_string )
	   	idw_main.SetItemStatus(1, "Commodity_list",Primary!, DataModified! )
	End If
//07-May-2017 :TAM - PEVS-513 -Stock Inventory Commodity Codes - END

end event

type cb_adjustments from commandbutton within tabpage_main
integer x = 229
integer y = 1632
integer width = 411
integer height = 100
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Adjustments"
end type

event clicked;
Open(w_cc_create_adjustments)
end event

type rb_location from radiobutton within tabpage_main
boolean visible = false
integer x = 3392
integer y = 108
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Location"
end type

type rb_sku from radiobutton within tabpage_main
boolean visible = false
integer x = 3077
integer y = 108
integer width = 279
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sku"
boolean checked = true
end type

type cb_export from commandbutton within tabpage_main
integer x = 2441
integer y = 1632
integer width = 425
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Export Report"
end type

event clicked;
wf_print_export_report(2)
end event

event constructor;g.of_check_label_button(this)
end event

event getfocus;idsreport.Modify("ccno_t.Text=''")
end event

type cb_void from commandbutton within tabpage_main
integer x = 2007
integer y = 1632
integer width = 411
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Void"
end type

event clicked;String ls_order
integer li_return
long ll_totalrows,i, ll_new
datetime ldtToday

f_method_trace_special( gs_project, this.ClassName() , 'Start  void CC order' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

ldtToday = f_getLocalWorldTime( idw_main.object.wh_code[ 1 ] ) 

If idw_main.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	return 
End If

If ib_changed Then
	messagebox(is_title,'Please save changes first!',StopSign!)
	return
End If

if messagebox(is_title,'Are you sure you want to void this order?',Question!,YesNo!,2) = 2 then
	return
End if

	
idw_main.setitem(1,'ord_status','V')

If iw_window.Trigger Event ue_save() = 0 Then
	//Jxlim 06/24/2010 Insert batch record for Pandora
	//TAM 2017/12/06 3PL CC - Don't insert a record if it is Ord_Type = System Generated
	//	IF gs_project = "PANDORA" THEN	
	
	//MEA 08/2018	- DE5480 - PRB0040886 SOC created without order number
	//Solution to this issue is don$$HEX1$$1920$$ENDHEX$$t insert record in $$HEX1$$1820$$ENDHEX$$Batch_Transaction$$HEX2$$19202000$$ENDHEX$$for other order type. i.e Location, SKU etc. 
	//Commented out code to insert into batch_transaction for all other order types. 
	
	//	IF gs_project = "PANDORA" and idw_main.GetItemString(1, "Ord_Type") <> 'X' THEN			
	//		ls_order = idw_si.GetItemString(idw_si.GetRow(), "cc_no")
	//		// 12/08 - PCONKL - Want to write the record before we show confirmation msgbox
	//		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
	//	
	//		Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
	//								Values(:gs_Project, 'CC', :ls_order,'N', :ldtToday, '');		
	//	
	//		Execute Immediate "COMMIT" using SQLCA;
	//	
	//		w_main.SetMicrohelp("Record Voided!")
	//		MessageBox(is_title, "Record voided!")
	//	Else
			MessageBox(is_title, "Record voided!")
	//	End If
Else
	MessageBox(is_title, "Record void failed!")
End If
//Jxlim 06/24/2010 End of modification to accomodate Pandoro req.

f_method_trace_special( gs_project, this.ClassName() , 'End  void CC order' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
end event

event constructor;
g.of_check_label_button(this)
end event

type st_cc_owner_nbr from statictext within tabpage_main
integer x = 82
integer y = 76
integer width = 306
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Order Nbr:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type cb_generate from commandbutton within tabpage_main
integer x = 704
integer y = 1632
integer width = 411
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Generate"
end type

event clicked;String ls_s, ls_e, ls_wh, ls_type, ls_sku, ls_loc, ls_serial, ls_lot, ls_po, ls_order, sql_syntax, Errors
string ls_supp,ls_po2,ls_container_id, ls_coo //GAP 11-02 added container
datetime ldt_expiration_date  //GAP 11-02
Long i,  ll_cnt,ll_ctr,ll_ret,ll_owner, llRowCount, ll_pos, ll_row
decimal ld_qty //GAP 11-02 convert to decimal
string ls_ro_no, ls_alternate_sku
string ls_uom, ls_grp
Int		liRC
string ls_inventory_type
integer li_day_afters
decimal ld_alloc_qty  //TAM 2017/05 SIMSPEVS-420 and 513
string lsSequence, ls_si_sequence  //TAM 2017/05 SIMSPEVS-420 and 513
string ls_find
string	ls_LCode

ll_ctr=0

long lOwner
string lsGroup
string lsClass
string lsWhere
string lsGroupWhere 	= " Item_Master.cc_group_code = '"
string lsClassWhere 	= " item_Master.cc_class_code = '"
//TAM 2017/05 SIMSPEVS-420 and 513  Build the Commodity Where Clause
//string lsOwnerWhere 	= " content.owner_id  = "
string lsOwnerWhere 	= " content_summary.owner_id  = "
string lsPoNoWhere 	= " content_summary.Po_No  = '" //TAM 2017/05 SIMSPEVS-420 and 513
string lsCommodity //TAM 2017/05 SIMSPEVS-420 and 513
string lsCommodityList //TAM 2017/05 SIMSPEVS-420 and 513
string lsCommodityLike 	= " Item_Master.User_Field5 Like '"  //TAM 2017/05 SIMSPEVS-420 and 513
string lsCommodityWhere //TAM 2017/05 SIMSPEVS-420 and 513
string lsOpenParenth 	= " ("  //TAM 2017/05 SIMSPEVS-420 and 513
string lsCloseParenth 	= ") "  //TAM 2017/05 SIMSPEVS-420 and 513
string lsTemp  //TAM 2017/05 SIMSPEVS-420 and 513
string lsAnd = ' and '
string lsOr = ' or '
string lsQuote = "' "
long sysInvRows
long index
decimal ldAllocQty //TAM 2017/05 SIMSPEVS-420
long llRE //TAM 2017/05 SIMSPEVS-420
long llGenericFieldCount		//GailM 07/12/2017 SIMSPEVS-727
string lsOPWhere	= ''			//Filter owner/project 

datastore lds_cc
datastore ldsSysInv
datastore ldsCCGenericField	//GailM 07/12/2017 PAN SIMS Blind Count

f_method_trace_special( gs_project, parent.ClassName() , 'Start  generate CC Order ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
 //Begin - Dinesh -F24934/S50765/- 10/29/2020 - Include component on cycle count for order type SKU as well

	If upper(gs_project) ='NYCSP' then
		lds_cc 			= f_datastoreFactory( 'd_cc_qty_rollup_ro_no_component') 
	else
		lds_cc 			= f_datastoreFactory( 'd_cc_qty_rollup_ro_no')
	end if

 //End - Dinesh -F24934/S50765/- 10/29/2020 - Include component on cycle count for order type SKU as well
ldsSysInv = f_datastoreFactory( 'd_sys_inv_by_item_master')
ldsCCGenericField = f_datastoreFactory('d_cc_generic_field')
SqlUtil.setOriginalSql( ldsSysInv.GetSQLSelect() )
SqlUtil.doParseSql()

If idw_main.AcceptText() = -1 Then Return
SetPointer(hourglass!)

//TAM 2017/05 SIMSPEVS-420 - All generate for Pandora Directed if the Orders Status is "Allocated"
//If idw_main.GetItemString(1, "ord_type") = "P" Then
If idw_main.GetItemString(1, "ord_type") = "P" and idw_main.GetItemString(1, "ord_status") <> "A"Then
	MessageBox ("Cycle Count", "You cannot generate a Pandora Directed Cycle Count!")
	RETURN -1
End If

ls_s = idw_main.GetItemString(1, "range_start")
ls_e = idw_main.GetItemString(1, "range_end")
ls_wh = idw_main.GetItemstring(1, "wh_code")
ls_order = idw_main.GetItemstring(1, "cc_no")
lsGroup = idw_main.object.Group[1]
lsClass = idw_main.object.Class[1]
lOwner = idw_main.object.owner_id[1]

// TAM - 11/2017  - If CC is System generated then we need a Sequence number. Get it from the Next_Sequence table
If idw_main.GetItemString(1, "ord_type") = "X" Then /* By System Generated */
	lsSequence = of_parse_numeric_sys_no( ls_order)
	If isNull(lsSequence) or lsSequence = '' Then 
		messagebox("Cycle Count","Unable to retrieve the Sequence Number!  Please contact support!")
		Return -1
	End If
End If

ls_Po = idw_main.object.user_Field5[1]//TAM 2017/05 SIMSPEVS-420 and 513 - Get PoNo from User_Field5

// 05/00 PCONKL - Warehouse is required
If isnull(ls_wh) or ls_wh="" or ls_wh=" " Then
	messagebox("Cycle Count","Warehouse is required before generating cycle count!")
	Return
End If

// pvh - 07/11/06 - ccmods
//TAM 2017/05 SIMSPEVS-513 -Commodity Code doesn't have a start or end (START)
// TAM 2017/11 - 3PL CC -System Generated doesn't have a start or end
//If (  isNull(ls_s) or ls_s = '' and isnull(ls_e) or ls_e = '' ) AND idw_main.GetItemString(1, "ord_type")  <> "I"   then
//If (  isNull(ls_s) or ls_s = '' and isnull(ls_e) or ls_e = '' ) AND idw_main.GetItemString(1, "ord_type")  <> "I"    AND idw_main.GetItemString(1, "ord_type")  <> "C"   then
If (  isNull(ls_s) or ls_s = '' and isnull(ls_e) or ls_e = '' ) AND idw_main.GetItemString(1, "ord_type")  <> "I"    AND idw_main.GetItemString(1, "ord_type")  <> "C" AND idw_main.GetItemString(1, "ord_type")  <> "X"   then
	IF messagebox( getTitle(), "Not Entering a Range Will Return All Rows.~r~n" + &
			"This Will Significantly Slow Response Time.~r~n~r~nDo You Wish to Continue?",question!, yesno! ) = 2 THEN Return
end if

lsCommodityList = idw_main.GetItemstring(1, "commodity_list")//TAM 2017/05 SIMSPEVS-420 and 513
lsCommodityWhere = ''
//TAM 2017/05 SIMSPEVS-420 and 513  Build the Commodity Where Clause
If Not IsNull(lsCommodityList) and lsCommodityList<>'' Then
	lsTemp = lsCommodityList
	lsCommodityWhere = lsOpenParenth
	do while lsTemp <> ''
		If Pos(lsTemp,'|') > 0 Then
			 lsCommodity = Left(lsTemp,(pos(lsTemp,'|') - 1))
			 lsCommodityWhere = lsCommodityWhere + lsCommodityLike + lsCommodity + lsQuote + lsOr
			 lsTemp = Right(lsTemp,(len(lsTemp) - (Len(lsCommodity) + 1))) /*strip off to next Commodity */
		Else 
			 lsCommodity = lsTemp
			 lsCommodityWhere = lsCommodityWhere + lsCommodityLike + lsCommodity + lsQuote + lsCloseParenth
			 lsTemp = ''
		End If
	loop
End If

If (  isNull(lsCommodityList) or lsCommodityList = ''  ) AND  idw_main.GetItemString(1, "ord_type")  = "C"   then
	messagebox("Cycle Count","A commodity List is Required for Commodity Order Types before generating cycle count!")
	Return
end if
//TAM 2017/05 SIMSPEVS-513 -Commodity Code doesn't have a start or end (END)

setwarehouse( ls_wh )
setBlindKnown()
setBlindKnownprt()
setCountDiff()
//

//GailM 07/12/2017 PAN SIMS Blind Count - Check whether there are CC Generic Field records to add to the list
llGenericFieldCount = ldsCCGenericField.retrieve( ls_order )
lsOPWhere = lsAnd + lsOpenParenth
for i = 1 to llGenericFieldCount
	lsOPWhere += lsOpenParenth + lsOwnerWhere + ldsCCGenericField.GetItemString( i, 'owner_id' ) + lsAnd + lsPoNoWhere + ldsCCGenericField.GetItemString( i, 'project' ) + lsQuote + lsCloseParenth 
	if i <> llGenericFieldCount Then lsOPWhere += lsOr
next
lsOPWhere += lsCloseParenth

w_main.SetMicroHelp("Generating Item List")

ll_cnt = idw_si.rowcount()
If ll_cnt > 0 Then
	for i = ll_cnt to 1 step -1
		idw_si.deleterow(i)
	next
End If

string ls_order_type

ls_order_type=idw_main.GetItemString(1, "ord_type")



If idw_main.GetItemString(1, "ord_type") = "L"  OR ( idw_main.GetItemString(1, "ord_type") = "S" and upper(gs_project) ='NYCSP' ) Then //* By Location and SKU  - Dinesh -F24934/S50765/- 10/29/2020 - Include component on cycle count for order type SKU as well

	// 05/00 - PCONKL - Allow for empty range
	If isNull(ls_s) or ls_s = '' Then ls_S = '0'
	If isnull(ls_e) or ls_e = '' Then ls_e = 'ZZZZZZZZZZ'
	
	if  upper(gs_project) ='NYCSP'  then
			IF lds_cc.Retrieve(gs_project,ls_wh,ls_s,ls_e,ls_order_type) <=0 THEN 
							MessageBox(is_title, "No system Inventory Generated!")
							Return 
			END IF
	
	else
	
			IF lds_cc.Retrieve(gs_project,ls_wh,ls_s,ls_e) <=0 THEN 
					MessageBox(is_title, "No system Inventory Generated!")
					Return 
			END IF
	end if
	
			
	
	 //* By Location and SKU  - Dinesh -F24934/S50765/- 10/29/2020 - Include component on cycle count for order type SKU as well
	

	if  upper(gs_project) ='NYCSP'  then
		lds_cc.SetFilter("")
		lds_cc.Filter()
		
		// Begin - Dinesh - F24934/S50765/- 11/17/2020 - Include component on cycle count for order type SKU as well
		string ls_sort
		ls_sort='inventory_type d'
		lds_cc.setsort(ls_sort)
		lds_cc.sort()
		//End - Dinesh -F24934/S50765/- 11/17/2020 - Include component on cycle count for order type SKU as well
	end if

//TAM 2017/05 SIMSPEVS-420 - For Location count, If any location has allocated inventory then remove it from the CC

	If ib_filter_allocated = True	 Then //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (Start)
		FOR i = 1 to lds_cc.RowCount()
				
			ls_loc = lds_cc.GetItemString( i, "l_code")
			if trim(ls_loc) <> '' and not IsNull(ls_loc) then
			  SELECT Sum(dbo.content_summary.alloc_qty)  
			    INTO :ld_alloc_qty  
			    FROM dbo.content_summary  
			   WHERE ( dbo.content_summary.project_id = :gs_project ) AND  
	   		      ( dbo.content_summary.wh_code = :ls_wh ) AND  
	  	 	      ( dbo.content_summary.l_code = :ls_loc ) AND  	
	   	  	   ( dbo.content_summary.alloc_qty > 0 )   ;
				// If allocated quantity exist then it cannot be cycle counted at this time
				if ld_alloc_qty > 0 and not isnull(ld_alloc_qty) then 		
					llRE = lds_cc.deleterow(i)
					if llRE = 1 then //step back 1 rowcount
						i = i - 1
					End If
				End If
			End If

		NEXT
	End If //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (End)

	//GailM 04/11/2019 DE10048 - Google Issue_ Unable to generate location count
	If lds_cc.RowCount() = 0 Then
		messagebox("Cycle Count","Location " + ls_loc + " is allocated and will not be processed!")
		Return
	End If

	//TAM 2018/04 -S17607 - Exclude Inventory with Locations = "Research" or "Reconp" or or PoNo = "Research" 
	If gs_project = 'PANDORA' Then 
		FOR i = 1 to lds_cc.RowCount()
			if  (trim(lds_cc.GetItemString( i, "l_code")) >= 'RESEARCH' and trim(lds_cc.GetItemString( i, "l_code")) <= 'RESEARCZ') or trim(lds_cc.GetItemString( i, "l_code")) = 'RECONP' or  trim(lds_cc.GetItemString( i, "po_no")) = 'RESEARCH' then
				llRE = lds_cc.deleterow(i)
				if llRE = 1 then //step back 1 rowcount
					i = i - 1
				End If
			End If
		NEXT
	End If

	// 09/09 - PCONKL - MOved to a function so we can use it for Random load as well - Datastore must have the same columns
	If uf_load_sys_inv (lds_cc) < 0 Then REturn -1
	
ElseIf idw_main.GetItemString(1, "ord_type") = "B" Then /* By Blank Location (added 8/26/2010)*/
	
	// 05/00 - PCONKL - Allow for empty range
	If isNull(ls_s) or ls_s = '' Then ls_S = '0'
	If isnull(ls_e) or ls_e = '' Then ls_e = 'ZZZZZZZZZZ'
	
	
		IF lds_cc.Retrieve(gs_project,ls_wh,ls_s,ls_e) <=0 THEN 
			MessageBox(is_title, "No system Inventory Generated!")
			Return 
		END IF
	

//TAM 2017/05 SIMSPEVS-420 and 513 - For Location count, If any location has allocated inventory then remove it from the CC

	If ib_filter_allocated = True	 Then //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (Start)
		FOR i = 1 to lds_cc.RowCount()
			
			ls_loc = lds_cc.GetItemString( i, "l_code")

			if trim(ls_loc) <> '' and not IsNull(ls_loc) then
			  SELECT Sum(dbo.content_summary.alloc_qty)  
			    INTO :ld_alloc_qty  
			    FROM dbo.content_summary  
			   WHERE ( dbo.content_summary.project_id = :gs_project ) AND  
		   	      ( dbo.content_summary.wh_code = :ls_wh ) AND  
		  	       ( dbo.content_summary.l_code = :ls_loc ) AND  	
		   	      ( dbo.content_summary.alloc_qty > 0 )   ;
				// If allocated quantity exist then it cannot be cycle counted at this time
 				if ld_alloc_qty > 0 and not isnull(ld_alloc_qty) then 		
					llRE = lds_cc.deleterow(i)
					if llRE = 1 then //step back 1 rowcount
						i = i - 1
					End If
				End If
			End If

		NEXT
	End If //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (End)

	//TAM 2018/04 -S17607 - Exclude Inventory with Locations = "Research" or "Reconp" or or PoNo = "Research" 
	If gs_project = 'PANDORA' Then 
		FOR i = 1 to lds_cc.RowCount()
			if  (trim(lds_cc.GetItemString( i, "l_code")) >= 'RESEARCH' and trim(lds_cc.GetItemString( i, "l_code")) <= 'RESEARCZ') or  trim(lds_cc.GetItemString( i, "l_code")) = 'RECONP' or  trim(lds_cc.GetItemString( i, "po_no")) = 'RESEARCH' then
				llRE = lds_cc.deleterow(i)
				if llRE = 1 then //step back 1 rowcount
					i = i - 1
				End If
			End If
		NEXT
	End If
	
	// 09/09 - PCONKL - MOved to a function so we can use it for Random load as well - Datastore must have the same columns
	If uf_load_sys_inv (lds_cc) < 0 Then Return -1
	// 03/12 - MEA - Added "Q"
ElseIf idw_main.GetItemString(1, "ord_type") = "R"  OR  idw_main.GetItemString(1, "ord_type") = "Q" Then /* 09/09 - PCONKL - Random generated locations */
	
	If idw_Main.GetITemNumber(1,'range_cnt') < 1 Then
		Messagebox(is_title,'Please enter a number of locations to count.')
		idw_Main.SetFocus()
		idw_Main.SetColumn('range_cnt')
		Return 
	End If
	
	// If we dont have any remaining to count, start a new cycle and generate new random numbers for the locations
	Select Count(*) into :ll_cnt
	From Location
	Where wh_code = :ls_WH and cc_rnd_cnt_ind = 'N' //;
	// dts - 8/30/2010 -  need to consider location_available_ind ...
	and (location_available_ind = 'Y' or location_available_ind is null);
	
	If ll_cnt = 0 Then
		liRC = wf_assign_random_locations(ls_wh)
		If liRC < 0 Then
			Messagebox(is_title,'Error assigning Random Location IDs. Cycle COunt will not be generated')
			Return
		Else
			Messagebox(is_title,'A new cycle of random counts has been initiated')
		End If
	Elseif ll_cnt < idw_main.GetItemNumber(1,'range_cnt') Then
		Messagebox(is_title,'This is the end of the current random/Sequential cycle.~rOnly ' + String(ll_cnt) + ' locations are available to count randomly/Sequentially.')
	Elseif ll_cnt = idw_main.GetItemNumber(1,'range_cnt') Then
		Messagebox(is_title,'This is the end of the current random/Sequential cycle.~rAll locations have been counted randomly/Sequentially.')
	End If
	
	//Retreive the Inventory - We may move this to a SP
	lds_cc = Create DAtaStore
	
//TAM 2017/05 - SIMSPEVS-420  Skip Locations where inventory is Allocated (Need to change query to look at Content_Summary 

////-----Before
//	sql_syntax = "SELECT  Location.L_Code, Content.sku, Content.supp_code, Content.owner_id, Content.inventory_type, Content.serial_no, Content.lot_no, Content.po_no, Content.po_no2, sum(isnull(Content.avail_qty,0))  as tot_avail_qty, "
//
//	sql_syntax += " Content.country_of_origin, Content.Container_ID , Content.Expiration_Date  "
//	sql_syntax += "FROM 	Location (nolock) LEFT JOIN Content (nolock) ON Location.L_Code = Content.L_Code "
// 	sql_syntax += " and  Content.project_id = '" + gs_Project + "' and  Content.Component_Qty = 0 and Content.wh_code = '" + ls_wh + "' "
//	sql_syntax += " WHERE  Location.wh_code = '" + ls_wh + "'  "
//	sql_syntax += " and Location.L_Code in (Select Top " + String(idw_main.GetItemNumber(1, "range_cnt")) + " l_code from location where wh_code = '" + ls_wh + "' and (location_Available_ind = 'Y' or location_Available_ind is null) and CC_Rnd_Cnt_Ind = 'N' "
//	if idw_main.GetItemString(1, "ord_type") = "Q" then
//		// dts - 8/26/2010 - Pandora wants 'Random' to be sequential (but still use the 'Random Count Settings')
//		sql_syntax += " Order by l_code ) "
//	else
//		sql_syntax += " Order by CC_Rnd_Loc_Nbr ) "
//	end if
//
//	sql_syntax += " Group By Location.L_Code, Content.sku, Content.supp_code, Content.owner_id, Content.inventory_type, Content.serial_no, Content.lot_no, Content.po_no, content.po_no2, Content.country_of_origin, Content.Container_ID , Content.Expiration_Date "
//
//	sql_syntax += " Order by Location.L_Code "
////-----Before

//-----AFTER
	sql_syntax = "SELECT  Location.L_Code, Content_Summary.sku, Content_Summary.supp_code, Content_Summary.owner_id, Content_Summary.inventory_type, Content_Summary.serial_no, Content_Summary.lot_no, Content_Summary.po_no, Content_Summary.po_no2, sum(isnull(Content_Summary.avail_qty,0))  as tot_avail_qty, "

	sql_syntax += " Content_Summary.country_of_origin, Content_Summary.Container_ID , Content_Summary.Expiration_Date  "
	sql_syntax += "FROM 	Location (nolock) LEFT JOIN Content_Summary (nolock) ON Location.L_Code = Content_Summary.L_Code "
// 	sql_syntax += " and  Content_Summary.project_id = '" + gs_Project + "' and  Content_Summary.Component_Qty = 0 and Content_Summary.wh_code = '" + ls_wh + "' "
	If ib_filter_allocated = True	 Then //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (Start)
 		sql_syntax += " and  Content_Summary.project_id = '" + gs_Project + "' and  Content_Summary.Avail_qty > 0 and  Content_Summary.Alloc_qty = 0 and Content_Summary.wh_code = '" + ls_wh + "' "
	Else
 		sql_syntax += " and  Content_Summary.project_id = '" + gs_Project + "' and  Content_Summary.Avail_qty > 0 and  Content_Summary.wh_code = '" + ls_wh + "' "
	End If
	
	sql_syntax += " WHERE  Location.wh_code = '" + ls_wh + "'  "
	sql_syntax += " and Location.L_Code in (Select Top " + String(idw_main.GetItemNumber(1, "range_cnt")) + " l_code from location where wh_code = '" + ls_wh + "' and (location_Available_ind = 'Y' or location_Available_ind is null) and CC_Rnd_Cnt_Ind = 'N' "
	if idw_main.GetItemString(1, "ord_type") = "Q" then
		// dts - 8/26/2010 - Pandora wants 'Random' to be sequential (but still use the 'Random Count Settings')
		sql_syntax += " Order by l_code ) "
	else
		sql_syntax += " Order by CC_Rnd_Loc_Nbr ) "
	end if

	sql_syntax += " Group By Location.L_Code, Content_Summary.sku, Content_Summary.supp_code, Content_Summary.owner_id, Content_Summary.inventory_type, Content_Summary.serial_no, Content_Summary.lot_no, Content_Summary.po_no, Content_Summary.po_no2, Content_Summary.country_of_origin, Content_Summary.Container_ID , Content_Summary.Expiration_Date "
	sql_syntax += " Order by Location.L_Code "
//---AFTER	

	lds_cc.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
	lds_cc.SetTransobject(sqlca)
	
	IF lds_cc.Retrieve() <=0 THEN 
		MessageBox(is_title, "No system Inventory Generated!")
		Return 
	END IF
	
//TAM 2017/05 SIMSPEVS-420 and 513 - For Random(Sequential) count, If any location has allocated inventory then remove it from the CC
	If ib_filter_allocated = True	 Then //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (Start)
		FOR i = 1 to lds_cc.RowCount()
			
			
			ls_loc = lds_cc.GetItemString( i, "l_code")

			if trim(ls_loc) <> '' and not IsNull(ls_loc) then
			  SELECT Sum(dbo.content_summary.alloc_qty)  
			    INTO :ld_alloc_qty  
			    FROM dbo.content_summary  
			   WHERE ( dbo.content_summary.project_id = :gs_project ) AND  
		   	      ( dbo.content_summary.wh_code = :ls_wh ) AND  
		  	       ( dbo.content_summary.l_code = :ls_loc ) AND  	
		   	      ( dbo.content_summary.alloc_qty > 0 )   ;
				// If allocated quantity exist then it cannot be cycle counted at this time
 				if ld_alloc_qty > 0 and not isnull(ld_alloc_qty) then 		
					llRE = lds_cc.deleterow(i)
					if llRE = 1 then //step back 1 rowcount
						i = i - 1
					End If
				End If
			End If

		NEXT
	End If //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (End)

	//TAM 2018/04 -S17607 - Exclude Inventory with Locations = "Research" or "Reconp" or or PoNo = "Research" 
	If gs_project = 'PANDORA' Then 
		FOR i = 1 to lds_cc.RowCount()
			if  (trim(lds_cc.GetItemString( i, "l_code")) >= 'RESEARCH' and trim(lds_cc.GetItemString( i, "l_code")) <= 'RESEARCZ') or  trim(lds_cc.GetItemString( i, "l_code")) = 'RECONP' or  trim(lds_cc.GetItemString( i, "po_no")) = 'RESEARCH' then
				llRE = lds_cc.deleterow(i)
				if llRE = 1 then //step back 1 rowcount
					i = i - 1
				End If
			End If
		NEXT
	End If
	
	If uf_load_sys_inv (lds_cc) < 0 Then REturn -1
		
// TAM 2017/11 - 3PL CC -Start
ElseIf idw_main.GetItemString(1, "ord_type") = "X" Then /*by System Generated*/
	
	if tab_main.tabpage_system_generated.dw_system_generated.RowCount() <= 0 then
		MessageBox ("Cycle Count - System Generated", "There no values in the CC_System_Generated table to Generate!")
		RETURN -1
	end if
	
	string ls_sys_gen_where, ls_sys_gen_type, ls_sys_gen_value

	ls_sys_gen_type =  tab_main.tabpage_system_generated.dw_system_generated.GetItemString(1, "count_type")
	FOR i = 1 to tab_main.tabpage_system_generated.dw_system_generated.RowCount()
		ls_sys_gen_value = tab_main.tabpage_system_generated.dw_system_generated.GetItemString( i, "count_value")
// TODO ((Waiting on requirements) TAM 2017/12/19 - 3PL CC - If the location has any allocated inventory then remove it from the count and reset the content inventory to be counted again
		// Check if allocated inventory			
		If ib_filter_allocated = True	 Then //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (Start)
			if ls_sys_gen_type = 'S' then
				SELECT sum(cs.alloc_qty)  
				INTO :ldAllocQty  
				FROM content_summary cs with (NOLOCK), cc_master cm with (NOLOCK), cc_system_criteria sc  with (NOLOCK)
				WHERE cs.project_id = :gs_project AND
						(cm.cc_no = sc.cc_no) AND
						(cm.wh_code = cs.wh_code) AND
						(cs.sku = :ls_sys_gen_value) AND  
				       	( cm.cc_no = :ls_order )
				      	;		
			else
				SELECT sum(cs.alloc_qty)  
				INTO :ldAllocQty  
				FROM content_summary cs with (NOLOCK), cc_master cm with (NOLOCK), cc_system_criteria sc with (NOLOCK)
				WHERE cs.project_id = :gs_project AND
						(cm.cc_no = sc.cc_no) AND
						(cm.wh_code = cs.wh_code) AND
						(cs.l_code = :ls_sys_gen_value) AND  
			     	  	( cm.cc_no = :ls_order )
			     	 	;
			End If

			If ldAllocQty > 0 Then // If is allocated then add it to the list of count values(SKU's or Locations) that need to be deleted from the Cycle Count and also need to be reset in content to be recounted later 
				If isDeleteCCValues <> '' then 
					isDeleteCCValues = isDeleteCCValues + ","
				End If
				isDeleteCCValues = isDeleteCCValues + ls_sys_gen_value
					
			Else //add it to the generate list
		
				if trim(ls_sys_gen_where) <> '' then
					ls_sys_gen_where = ls_sys_gen_where + ","
				end if
				ls_sys_gen_where = ls_sys_gen_where + "'" + ls_sys_gen_value + "'"
			End If
		Else // Dont Check allocated

				if trim(ls_sys_gen_where) <> '' then
					ls_sys_gen_where = ls_sys_gen_where + ","
				end if
				ls_sys_gen_where = ls_sys_gen_where + "'" + ls_sys_gen_value + "'"

		End If //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (End)
		
	
	NEXT

		lsWhere = SqlUtil.getWhere()
		//TAM - 2017/12/19 - 3PL CC - Ignore "Null" item master class code
		lsWhere += lsAnd + " item_Master.cc_class_code is not NULL " 
		
		if ls_sys_gen_type = 'S' then
//			TAM 2018/11/26 - D7402 -Exclude location like 'RESEARCH', 'RECON' and PoNo like 'RESEARCH'
//			lsWhere += " and  content_summary.sku in ("+ls_sys_gen_where+")  "  
			lsWhere += " and  content_summary.sku in ("+ls_sys_gen_where+") and content_summary.l_code NOT LIKE 'RESEARCH%' and content_summary.l_code <> 'RECONP'  and content_summary.po_no <> 'RESEARCH'  "  
		else
//			TAM 2018/11/26 - D7402 - Exclude location like 'RESEARCH', 'RECON' and PoNo like 'RESEARCH'
//			lsWhere += " and  content_summary.l_code in ("+ls_sys_gen_where+") "  
			lsWhere += " and  content_summary.l_code in ("+ls_sys_gen_where+") and content_summary.l_code NOT LIKE 'RESEARCH%' and content_summary.l_code <> 'RECONP' and content_summary.po_no <> 'RESEARCH'  "  
		end if
		
		lsWhere += " and content_summary.wh_code ='"+ ls_wh +"'" +" " //02-Feb-2017 Madhu - PEVS-453 - Added selected warehouse in WHERE clause instead to look for Inventory across all WH's -START

//	end if

	//02/20 MikeaA - DE14206 - Don't try to retrieve if ls_sys_gen_where is empty. Will cause -1 Error.

	IF trim(ls_sys_gen_where) <> '' THEN

		SqlUtil.setWhere( lsWhere )
		ldsSysInv.SetSQLSelect ( SqlUtil.getSql() )
	
		sysInvRows = ldsSysInv.retrieve(  )
		
	END IF
	
	//02/20 MikeaA - DE14206 - Added check to generate error if te ls_sys_gen_where is empty.
	If sysInvRows <= 0 OR trim(ls_sys_gen_where) = '' Then
		MessageBox(is_title, "No System Inventory Generated. Inventory is Allocated for all records on the System Generated Tab.  Please try later when Inventory is available")
		isDeleteCCValues = ''
		Return 
	End If
	
	//Check to see if any skus are used in another Cyclecount if ib_freeze_cc_inventory = true
	IF ib_freeze_cc_inventory THEN
		for index = 1 to sysInvRows
			ls_sku	  = ldsSysInv.object.sku[ index ] 
			ls_type = ldsSysInv.object.inventory_type[ index ]
			if ls_type = "*" then
				MessageBox ("Cycle Count Error", "SKU " + ls_sku + " is currently assigned to another cycle count, cannot continue with this count." )
				Return -1
			end if
		next
	END IF
	
//TAM 2017/12/12 - 3PL CC- Moved this above.  We are now allowing a CC to ignore allocated Locations or SKU so this needs to be determined earlier
////TAM 2017/12/12 - 3PL CC-If any of the inventory is allocated then don't allow the generate
//	If ib_filter_allocated = True	 Then //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (Start)
//
//		if ls_sys_gen_type = 'S' then
//			SELECT sum(cs.alloc_qty)  
//			INTO :ldAllocQty  
//			FROM content_summary cs with (NOLOCK), cc_master cm with (NOLOCK), cc_system_criteria sc  with (NOLOCK)
//			WHERE cs.project_id = :gs_project AND
//					(cm.cc_no = sc.cc_no) AND
//					(cm.wh_code = cs.wh_code) AND
//					(cs.sku = sc.Count_Value) AND  
//			       	( cm.cc_no = :ls_order )
//			      	;		
//		else
//			SELECT sum(cs.alloc_qty)  
//			INTO :ldAllocQty  
//			FROM content_summary cs with (NOLOCK), cc_master cm with (NOLOCK), cc_system_criteria sc with (NOLOCK)
//			WHERE cs.project_id = :gs_project AND
//					(cm.cc_no = sc.cc_no) AND
//					(cm.wh_code = cs.wh_code) AND
//					(cs.l_code = sc.Count_Value) AND  
//			       	( cm.cc_no = :ls_order )
//			      	;		
//		end if
//
//		If ldAllocQty > 0 Then 
//			Messagebox(is_title,'Inventory is still allocated. Cycle Count will not be generated')
//			Return
//		End If
//	End If //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (End)

	for index = 1 to sysInvRows
		
		ls_loc 						= ldsSysInv.object.l_code[ index ]
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
		ls_alternate_sku		= ldsSysInv.object.alternate_sku[ index ]
		ls_grp						= ldsSysInv.object.item_master_grp[ index ]
		ls_uom					= ldsSysInv.object.item_master_uom[ index ]
		ls_ro_no					= ldsSysInv.object.ro_no[ index ]

		if IsNull( ld_qty) then ld_qty = 0
		if IsNull( ls_loc) or len( Trim( ls_loc ) ) = 0 then ls_loc = "-"
		ll_ret=idw_si.Find("sku = '" + ls_sku + "' and l_code = '" + ls_loc + &
									"' and serial_no = '" + ls_serial + "' and lot_no = '" + ls_lot + &
									"' and supp_code = '" + ls_supp + "' and owner_id = " + string(ll_owner) + &
									" and po_no = '" + ls_po + "' and po_no2 = '" + ls_po2 + &
									"' and inventory_type = '" + ls_type + "' and container_id = '" + ls_Container_id + "' and country_of_origin = '" +ls_coo + "'", 1, idw_si.RowCount())		
		
		if ll_ret <= 0 THEN
			
			i = idw_si.Insertrow(0)
			idw_si.object.line_item_no[ i ] = i
			idw_si.setitem(i, "cc_no", ls_order)
			idw_si.SetItem(i, "sku", ls_sku)
			idw_si.SetItem(i, "supp_code", ls_supp)
			idw_si.SetItem(i, "owner_id", ll_owner)
			idw_si.SetItem(i, "inventory_type", ls_type)
			idw_si.SetItem(i, "serial_no", ls_serial)
			idw_si.SetItem(i, "lot_no", ls_lot)
			idw_si.SetItem(i, "po_no", ls_po)
			idw_si.SetItem(i, "po_no2", ls_po2)					
			idw_si.SetItem(i, "container_id", ls_container_id)				
			idw_si.SetItem(i, "expiration_date", ldt_expiration_date)
			idw_si.SetItem(i, "country_of_origin", ls_coo)
			idw_si.setitem(i, "quantity", ld_qty)	
			idw_si.SetItem(i, "l_code",ls_loc)
			idw_si.SetItem(i, "alternate_sku",ls_alternate_sku)			
			idw_si.SetItem(i, "uom_1",ls_uom)
			idw_si.SetItem(i, "grp",ls_grp)
			idw_si.SetItem(i, "sequence", lsSequence)
			idw_si.SetItem(i, "ro_no", ls_Ro_No)

		else
			idw_si.object.quantity[ ll_ret ] = idw_si.object.quantity[ ll_ret ] + ld_qty
			idw_si.object.l_code[ll_ret] = ls_loc
			idw_si.object.country_of_origin[ll_ret] = ls_coo
			idw_si.object.inventory_type[ll_ret] = ls_type
		end if
		
	next

// TAM 2017/11 - 3PL CC -End

//SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process - START
ElseIf idw_main.GetItemString(1, "ord_type") = "F" Then /*by System Generated - Serial Reconciliation*/
	
	//There should only be one row
	
	if tab_main.tabpage_system_generated.dw_system_generated.RowCount() <= 0 then
		MessageBox ("Cycle Count - System Generated - Serial Reconciliation", "There no values in the CC_System_Generated table to Generate!")
		RETURN -1
	end if

//	//Make Cycle Count locking of inventory configurable
//
//	ls_Wh = idw_main.GetItemString(1, "wh_code")
//	select count(Code_Type) into :ll_cnt from Lookup_Table
//	where project_id = :gs_project and code_type = 'SRCC_LOCK_INV_OFF' and code_id = :ls_wh;
//	if ll_cnt > 0 then
//		f_method_trace_special( gs_project, parent.ClassName() , ' Serial Reconciliation - Inventory not locked' ,isCCOrder, '','',isCCOrder)
//		ib_freeze_cc_inventory = FALSE
////		ib_freeze_cc_inventory = TRUE
//	end if	

//	ls_sys_gen_type =  tab_main.tabpage_system_generated.dw_system_generated.GetItemString(1, "count_type")
//
//	FOR i = 1 to tab_main.tabpage_system_generated.dw_system_generated.RowCount()
//		ls_sys_gen_value = tab_main.tabpage_system_generated.dw_system_generated.GetItemString( i, "count_value")
//// TODO ((Waiting on requirements) TAM 2017/12/19 - 3PL CC - If the location has any allocated inventory then remove it from the count and reset the content inventory to be counted again
//		// Check if allocated inventory			
//		If ib_filter_allocated = True	 Then //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (Start)
//			if ls_sys_gen_type = 'S' then
//				SELECT sum(cs.alloc_qty)  
//				INTO :ldAllocQty  
//				FROM content_summary cs with (NOLOCK), cc_master cm with (NOLOCK), cc_system_criteria sc  with (NOLOCK)
//				WHERE cs.project_id = :gs_project AND
//						(cm.cc_no = sc.cc_no) AND
//						(cm.wh_code = cs.wh_code) AND
//						(cs.sku = :ls_sys_gen_value) AND  
//				       	( cm.cc_no = :ls_order )
//				      	;		
//			else
//				SELECT sum(cs.alloc_qty)  
//				INTO :ldAllocQty  
//				FROM content_summary cs with (NOLOCK), cc_master cm with (NOLOCK), cc_system_criteria sc with (NOLOCK)
//				WHERE cs.project_id = :gs_project AND
//						(cm.cc_no = sc.cc_no) AND
//						(cm.wh_code = cs.wh_code) AND
//						(cs.l_code = :ls_sys_gen_value) AND  
//			     	  	( cm.cc_no = :ls_order )
//			     	 	;
//			End If
//
//			If ldAllocQty > 0 Then // If is allocated then add it to the list of count values(SKU's or Locations) that need to be deleted from the Cycle Count and also need to be reset in content to be recounted later 
//				If isDeleteCCValues <> '' then 
//					isDeleteCCValues = isDeleteCCValues + ","
//				End If
//				isDeleteCCValues = isDeleteCCValues + ls_sys_gen_value
//					
//			Else //add it to the generate list
//		
//				if trim(ls_sys_gen_where) <> '' then
//					ls_sys_gen_where = ls_sys_gen_where + ","
//				end if
//				ls_sys_gen_where = ls_sys_gen_where + "'" + ls_sys_gen_value + "'"
//			End If
//		Else // Dont Check allocated
//
//				if trim(ls_sys_gen_where) <> '' then
//					ls_sys_gen_where = ls_sys_gen_where + ","
//				end if
//				ls_sys_gen_where = ls_sys_gen_where + "'" + ls_sys_gen_value + "'"
//
//		End If //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (End)
//		
//	
//	NEXT

	lsWhere = SqlUtil.getWhere()


	ls_Sku =  tab_main.tabpage_system_generated.dw_system_generated.GetItemString( 1, "count_value")
	ls_LCode =idw_main.GetItemString( 1, "range_start")

	lsWhere += " and  content_summary.sku = ('"+ ls_Sku +"')  and  content_summary.l_code = ('"+ls_LCode+"') "    
	lsWhere += " and content_summary.wh_code ='"+ ls_wh +"'" +" "


	SqlUtil.setWhere( lsWhere )
	ldsSysInv.SetSQLSelect ( SqlUtil.getSql() )

//	ClipBoard(SqlUtil.getSql())

	sysInvRows = ldsSysInv.retrieve(  )
	
	If sysInvRows <= 0 Then
		MessageBox(is_title, "No System Inventory Generated - Serial Reconciliation. Inventory is Allocated for all records on the System Generated Tab.  Please try later when Inventory is available")
		isDeleteCCValues = ''
		Return 
	End If
	
	//Check to see if any skus are used in another Cyclecount if ib_freeze_cc_inventory = true
	IF ib_freeze_cc_inventory THEN
		for index = 1 to sysInvRows
			ls_sku	  = ldsSysInv.object.sku[ index ] 
			ls_type = ldsSysInv.object.inventory_type[ index ]
			if ls_type = "*" then
				MessageBox ("Cycle Count Error", "SKU " + ls_sku + " is currently assigned to another cycle count, cannot continue with this count." )
				Return -1
			end if
		next
	END IF

	for index = 1 to sysInvRows
		
		ls_loc 						= ldsSysInv.object.l_code[ index ]
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
		ls_alternate_sku		= ldsSysInv.object.alternate_sku[ index ]
		ls_grp						= ldsSysInv.object.item_master_grp[ index ]
		ls_uom					= ldsSysInv.object.item_master_uom[ index ]
		ls_ro_no					= ldsSysInv.object.ro_no[ index ]

		if IsNull( ld_qty) then ld_qty = 0
		if IsNull( ls_loc) or len( Trim( ls_loc ) ) = 0 then ls_loc = "-"
		ll_ret=idw_si.Find("sku = '" + ls_sku + "' and l_code = '" + ls_loc + &
									"' and serial_no = '" + ls_serial + "' and lot_no = '" + ls_lot + &
									"' and supp_code = '" + ls_supp + "' and owner_id = " + string(ll_owner) + &
									" and po_no = '" + ls_po + "' and po_no2 = '" + ls_po2 + &
									"' and inventory_type = '" + ls_type + "' and container_id = '" + ls_Container_id + "' and country_of_origin = '" +ls_coo + "'", 1, idw_si.RowCount())		
		
		if ll_ret <= 0 THEN
			
			i = idw_si.Insertrow(0)
			idw_si.object.line_item_no[ i ] = i
			idw_si.setitem(i, "cc_no", ls_order)
			idw_si.SetItem(i, "sku", ls_sku)
			idw_si.SetItem(i, "supp_code", ls_supp)
			idw_si.SetItem(i, "owner_id", ll_owner)
			idw_si.SetItem(i, "inventory_type", ls_type)
			idw_si.SetItem(i, "serial_no", ls_serial)
			idw_si.SetItem(i, "lot_no", ls_lot)
			idw_si.SetItem(i, "po_no", ls_po)
			idw_si.SetItem(i, "po_no2", ls_po2)					
			idw_si.SetItem(i, "container_id", ls_container_id)				
			idw_si.SetItem(i, "expiration_date", ldt_expiration_date)
			idw_si.SetItem(i, "country_of_origin", ls_coo)
			idw_si.setitem(i, "quantity", ld_qty)	
			idw_si.SetItem(i, "l_code",ls_loc)
			idw_si.SetItem(i, "alternate_sku",ls_alternate_sku)			
			idw_si.SetItem(i, "uom_1",ls_uom)
			idw_si.SetItem(i, "grp",ls_grp)
			idw_si.SetItem(i, "sequence", lsSequence)
			idw_si.SetItem(i, "ro_no", ls_Ro_No)

		else
			idw_si.object.quantity[ ll_ret ] = idw_si.object.quantity[ ll_ret ] + ld_qty
			idw_si.object.l_code[ll_ret] = ls_loc
			idw_si.object.country_of_origin[ll_ret] = ls_coo
			idw_si.object.inventory_type[ll_ret] = ls_type
		end if
		
	next

//SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process - END


Else	/*by Sku*/
	
//TAM 2017/05 - SIMSPEVS-420  Added Pandora Directed when Order Status is Allocated SIMSPEVS-513  Added Commodity Code
	IF idw_main.GetItemString(1, "ord_type") = "S" or  idw_main.GetItemString(1, "ord_type") = "P" or  idw_main.GetItemString(1, "ord_type") = "C" THEN
	
	
//  If Pandora Directed Check if the Inventory is still Allocated.  If So then Don't Generated
		//GailM 07/12/2017 SIMSPEVS-727
		If idw_main.GetItemString(1, "ord_type") = "P" Then
			//GailM 07/12/2017 PAN SIMS Blind Count - Check whether there are CC Generic Field records to add to the list
			llGenericFieldCount = ldsCCGenericField.retrieve( ls_order )
			If llGenericFieldCount <= 0 Then
				Messagebox(is_title,'A Pandora Directed Cycle count needs Sequence, Owner and Project Codes saved at cycle count creation. Records missing.  Please report error condition to system Administrator')
				Return
			End If
			
			// Add where clause to limit SysInv to only those owner and project codes requested in Pandora Directed Cycle Count
			lsOPWhere = lsAnd + lsOpenParenth
			for i = 1 to llGenericFieldCount
				lsOPWhere += lsOpenParenth + lsOwnerWhere + ldsCCGenericField.GetItemString( i, 'owner_id' ) + lsAnd + lsPoNoWhere + ldsCCGenericField.GetItemString( i, 'project' ) + lsQuote + lsCloseParenth 
				if i <> llGenericFieldCount Then lsOPWhere += lsOr
			next
			lsOPWhere += lsCloseParenth

			SELECT sum(cs.alloc_qty)  
			INTO :ldAllocQty  
			FROM dbo.content_summary cs, cc_master cm, cc_generic_field gf
			WHERE (cm.project_id = 'PANDORA' ) AND
					(gf.cc_no = cm.cc_no) AND
					(cm.project_id = cs.project_id) AND
					(cm.wh_code = cs.wh_code) AND
					(cm.Range_Start = cs.sku) AND
					(CAST(gf.owner_id AS int) = cs.owner_id) AND
					(gf.project = cs.po_no) AND
			      	(cs.wh_code = :ls_wh ) AND  
			       	( cs.sku = :ls_s ) ;		

//					 AND  
//			       ( dbo.content_summary.Owner_Id = :lOwner ) AND  
//			       ( dbo.content_summary.Po_No = :ls_Po ) AND  
//		  	       ( dbo.content_summary.alloc_qty > 0 )   ;
//
			If ldAllocQty > 0 Then 
				Messagebox(is_title,'Inventory is still allocated. Cycle Count will not be generated')
				Return
			End If
		End If

		// 05/00 - PCONKL - Allow for empty range
		// 07/00 - PCONKL - include PO and check for reserved Locations
		If isNull(ls_s) or ls_s = '' Then ls_s = '0'
		If isnull(ls_e) or ls_e = '' Then ls_e = 'ZZZZZZZZZZ'
	
		// pvh - 08/03/06 - ccmods
		lsWhere = SqlUtil.getWhere()
		
//TAM 2017/05 - SIMSPEVS-420   SIMSPEVS-513  Changed SQL to Content Summary
//		lsWhere += " and  content.wh_code = '" + ls_wh + lsQuote + lsand + "dbo.content.Project_ID = '" + gs_project + lsQuote
//		lsWhere += lsAnd + "dbo.content.SKU >= '" + ls_s + lsQuote + lsAnd + "dbo.content.SKU <= '" + ls_e + lsQuote 
		lsWhere += " and  content_summary.wh_code = '" + ls_wh + lsQuote + lsand + "dbo.content_summary.Project_ID = '" + gs_project + lsQuote
		lsWhere += lsAnd + "dbo.content_summary.SKU >= '" + ls_s + lsQuote + lsAnd + "dbo.content_summary.SKU <= '" + ls_e + lsQuote 
//  If Pandora Directed Also use Owner_Id and Po_No(User_field5)

//GailM 07/12/2017 SIMSPEVS-727 PAN SIMS Blind Count - Count entire SKU when all allocated have been expended
//		If idw_main.GetItemString(1, "ord_type") = "P" Then
//			if NOT isNull( lOwner ) and lOwner  > 0 then lsWhere += lsAnd + lsOwnerWhere + string( lOwner )
//			if NOT isNull( ls_Po ) and ls_Po  <> '' then lsWhere += lsAnd + lsPoNoWhere + ls_Po + lsQuote 
// 		End If

//		If ib_filter_allocated = True	 Then //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off (Start)
//			lsWhere += lsAnd + 'dbo.Content_summary.Alloc_Qty = 0'	
//		End If 
//
		if Left( gs_project,4 ) = "NIKE" then
		
				ls_inventory_type = idw_main.GetItemString( 1, "user_field2")
				li_day_afters = integer(idw_main.GetItemString( 1, "user_field1"))

				if li_day_afters > 0 then
									
					//lsWhere += " and dbo.content.ro_no in (select ro_no from receive_master where project_id = '" + gs_project + lsQuote + " and  datediff(dd, complete_date,getdate() ) >= " + string(li_day_afters) +  ") "
					// LTK 20150310  Removed ro_no from CC
	
				end if
	
				if trim(ls_inventory_type) <> '' and not isnull(ls_inventory_type) then
	
//TAM 2017/05 - SIMSPEVS-420   SIMSPEVS-513  Changed SQL to Content Summary
//					lsWhere += " and  dbo.content.inventory_type = '" + ls_inventory_type + lsQuote + " "
					lsWhere += " and  dbo.content_summary.inventory_type = '" + ls_inventory_type + lsQuote + " "
		
				end if
				
			end if

		//TAM 2018/04 -S17607 - Exclude Inventory with Locations = "Research" or "Reconp" or or PoNo = "Research" 
		If gs_project = 'PANDORA' Then 
			lsWhere += " and  dbo.content_summary.l_code NOT LIKE  'RESEARCH%'  and dbo.content_summary.l_code <> 'RECONP' and dbo.content_summary.po_no <> 'RESEARCH' " 
		End If
	
//TAM 2017/05 - SIMSPEVS-420  If Pandora Directed dont use class other criteria
		If idw_main.GetItemString(1, "ord_type") <> "P" Then
			if NOT isNull( lsGroup ) and len( lsGroup ) > 0 then	lsWhere += lsAnd + lsGroupWhere + lsGroup + lsQuote
			if NOT isNull( lsClass ) and len( lsClass ) > 0 then		lsWhere += lsAnd + lsClassWhere + lsClass + lsQuote
			if NOT isNull( lOwner ) and lOwner  > 0 then				lsWhere += lsAnd + lsOwnerWhere + string( lOwner )
			if NOT isNull( lsCommodityWhere ) and len( lsCommodityWhere ) > 0 then	lsWhere += lsAnd + lsCommodityWhere 
		End If

	ELSE
		string ls_sku_where
//		dw_sku.Reset()
		FOR i = 1 to dw_sku.RowCount()
			ls_sku = dw_sku.GetItemString( i, "sku")
			if trim(ls_sku) <> '' and not IsNull(ls_sku) then
				if trim(ls_sku_where) <> '' then
					ls_sku_where = ls_sku_where + ","
				end if
				ls_sku_where = ls_sku_where + "'" + ls_sku + "'"
			end if
		NEXT

		if len(trim(ls_sku_where)) = 0 then
			MessageBox ("Cycle Count - Import", "There no items in the import list. Nothing to Generate!")
			RETURN -1
		else
			lsWhere = SqlUtil.getWhere()
			if rb_sku.checked then
			
				//lsWhere += " and  left(content.sku, 10) in ("+ls_sku_where+") "  + " and dbo.content.Project_ID = '" + gs_project + lsQuote
				//TAM 2017/05 - SIMSPEVS-420   SIMSPEVS-513  Changed SQL to Content Summary
				//lsWhere += " and  content.sku in ("+ls_sku_where+") "  + " and dbo.content.Project_ID = '" + gs_project + lsQuote
				lsWhere += " and  content_summary.sku in ("+ls_sku_where+") "  + " and dbo.content_summary.Project_ID = '" + gs_project + lsQuote
			
			else
				
				//lsWhere += " and  content.l_code in ("+ls_sku_where+") "  + " and dbo.content.Project_ID = '" + gs_project + lsQuote
				//TAM 2017/05 - SIMSPEVS-420   SIMSPEVS-513  Changed SQL to Content Summary
				lsWhere += " and  content_summary.l_code in ("+ls_sku_where+") "  + " and dbo.content_summary.Project_ID = '" + gs_project + lsQuote

			end if
			

			//TAM 2018/04 -S17607 - Exclude Inventory with Locations = "Research" or "Reconp" or or PoNo = "Research" 
			If gs_project = 'PANDORA' Then 
				lsWhere += " and  content_summary.l_code NOT LIKE  'RESEARCH%'  and content_summary.l_code <> 'RECONP' and content_summary.po_no <> 'RESEARCH' " 
			End If

//TAM 2017/05 - SIMSPEVS-420   SIMSPEVS-513  Changed SQL to Content Summary
//			lsWhere += " and content.wh_code ='"+ ls_wh +"'" +" " //02-Feb-2017 Madhu - PEVS-453 - Added selected warehouse in WHERE clause instead to look for Inventory across all WH's -START
			lsWhere += " and content_summary.wh_code ='"+ ls_wh +"'" +" " //02-Feb-2017 Madhu - PEVS-453 - Added selected warehouse in WHERE clause instead to look for Inventory across all WH's -START

			if Left( gs_project,4 ) = "NIKE" then
				ls_inventory_type = idw_main.GetItemString( 1, "user_field2")
				li_day_afters = integer(idw_main.GetItemString( 1, "user_field1"))
				if li_day_afters > 0 then
					//lsWhere += " and dbo.content.ro_no in (select ro_no from receive_master where project_id = '" + gs_project + lsQuote + " and  datediff(dd, complete_date,getdate() ) >= " + string(li_day_afters) +  ") "
					// LTK 20150310  Removed ro_no from CC
				end if
				if trim(ls_inventory_type) <> '' and not isnull(ls_inventory_type) then
					//TAM 2017/05 - SIMSPEVS-420   SIMSPEVS-513  Changed SQL to Content Summary
					//lsWhere += " and  dbo.content.inventory_type = '" + ls_inventory_type + lsQuote + " "
					lsWhere += " and  dbo.content_summary.inventory_type = '" + ls_inventory_type + lsQuote + " "
				end if
			end if				
		end if
	END IF
	
	//GailM 07/12/2017 SIMSPEVS-727 PAN SIMS Blind Count
	If idw_main.GetItemString(1, "ord_type") = "P" Then
		lsWhere += lsOPWhere
	End If

	SqlUtil.setWhere( lsWhere )
	ldsSysInv.SetSQLSelect ( SqlUtil.getSql() )

	//Clipboard ( SqlUtil.getSql() )
	//MessageBox ("DEBUG", SqlUtil.getSql() )

	sysInvRows = ldsSysInv.retrieve(  )
	
//	MessageBox (string(ldsSysInv.RowCount()), lsWhere + ":2")

	if  idw_main.GetItemString(1, "ord_type") = "I" and sysInvRows = 0 then
		MessageBox ("Error", "There are no valid rows to import.")
		Return -1
	end if
	
	//Check to see if any skus are used in another Cyclecount if ib_freeze_cc_inventory = true
	IF ib_freeze_cc_inventory THEN
		for index = 1 to sysInvRows
			ls_sku	  = ldsSysInv.object.sku[ index ] 
			ls_type = ldsSysInv.object.inventory_type[ index ]
			if ls_type = "*" then
				MessageBox ("Cycle Count Error", "SKU " + ls_sku + " is currently assigned to another cycle count, cannot continue with this count." )
				Return -1
			end if
		next
	END IF
	

	for index = 1 to sysInvRows
		
		ls_loc 						= ldsSysInv.object.l_code[ index ]
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
		
		ls_alternate_sku		= ldsSysInv.object.alternate_sku[ index ]
//		ls_ro_no 					= ldsSysInv.object.ro_no[ index ]

		ls_grp						= ldsSysInv.object.item_master_grp[ index ]
		ls_uom					= ldsSysInv.object.item_master_uom[ index ]

		if IsNull( ld_qty) then ld_qty = 0
		if IsNull( ls_loc) or len( Trim( ls_loc ) ) = 0 then ls_loc = "-"
		ll_ret=idw_si.Find("sku = '" + ls_sku + "' and l_code = '" + ls_loc + &
									"' and serial_no = '" + ls_serial + "' and lot_no = '" + ls_lot + &
									"' and supp_code = '" + ls_supp + "' and owner_id = " + string(ll_owner) + &
									" and po_no = '" + ls_po + "' and po_no2 = '" + ls_po2 + &
									"' and inventory_type = '" + ls_type + "' and container_id = '" + ls_Container_id + "' and country_of_origin = '" +ls_coo + "'", 1, idw_si.RowCount())		
									//"' and inventory_type = '" + ls_type + "' and container_id = '" + ls_Container_id + "' and country_of_origin = '" +ls_coo + "' and ro_no='" +string(ls_ro_no) + "'", 1, idw_si.RowCount())			// LTK 20150310  Removed ro_no from above
		
		if ll_ret <= 0 THEN
			
			i = idw_si.Insertrow(0)
			idw_si.object.line_item_no[ i ] = i
			idw_si.setitem(i, "cc_no", ls_order)
			idw_si.SetItem(i, "sku", ls_sku)
			idw_si.SetItem(i, "supp_code", ls_supp)
			idw_si.SetItem(i, "owner_id", ll_owner)
			idw_si.SetItem(i, "inventory_type", ls_type)
			idw_si.SetItem(i, "serial_no", ls_serial)
			idw_si.SetItem(i, "lot_no", ls_lot)
			idw_si.SetItem(i, "po_no", ls_po)
			idw_si.SetItem(i, "po_no2", ls_po2)					
			idw_si.SetItem(i, "container_id", ls_container_id)				
			idw_si.SetItem(i, "expiration_date", ldt_expiration_date)
			idw_si.SetItem(i, "country_of_origin", ls_coo)
			idw_si.setitem(i, "quantity", ld_qty)	
			idw_si.SetItem(i, "l_code",ls_loc)
//			idw_si.SetItem(i, "ro_no",ls_ro_no)
			idw_si.SetItem(i, "alternate_sku",ls_alternate_sku)			
			idw_si.SetItem(i, "uom_1",ls_uom)
			idw_si.SetItem(i, "grp",ls_grp)
		else
			idw_si.object.quantity[ ll_ret ] = idw_si.object.quantity[ ll_ret ] + ld_qty
			idw_si.object.l_code[ll_ret] = ls_loc
			idw_si.object.country_of_origin[ll_ret] = ls_coo
			idw_si.object.inventory_type[ll_ret] = ls_type
		end if
		
	next
end if


//GailM 07/12/2017 SIMSPEVS-727 PAN SIMS Blind Count - Create No-Count system inventory
if  idw_main.GetItemString(1, "ord_type") = 'P' and ib_filter_allocated = TRUE Then			//and sysInvRows < llGenericFieldCount then
	for index = 1 to llGenericFieldCount
		ll_pos = 1
		ls_find = "sku = '" + ls_sku + "' and supp_code = 'PANDORA' and owner_id = " +  ldsCCGenericField.GetItemString( index, 'owner_id' ) + " and po_no = '" + ldsCCGenericField.GetItemString(index, 'project' ) + "' " 
		ll_ret=idw_si.Find( ls_find, ll_pos, idw_si.RowCount() )
		If ll_ret > 0 Then
			DO WHILE ll_ret > 0	
				ll_ret=idw_si.Find( ls_find, ll_pos, idw_si.RowCount()+1 )
				If ll_ret > 0 Then
					idw_si.SetItem(ll_ret, 'sequence', ldsCCGenericField.GetItemString(index, 'sequence' ) )		
				End If
				ll_pos = ll_ret+1
			LOOP
		Else		
			i = idw_si.InsertRow(0)
			idw_si.SetItem(i, 'cc_no', ls_order )		
			idw_si.SetItem(i, 'SKU', ls_s )			// Start SKU = End SKU
			idw_si.SetItem(i, 'supp_code', 'PANDORA' )		
			idw_si.SetItem(i, 'owner_id', long( ldsCCGenericField.GetItemString(index, 'owner_id' )) )		
			idw_si.SetItem(i, 'l_code', 'NO_COUNT' )		
			idw_si.SetItem(i, 'inventory_type', '*' )		
			idw_si.SetItem(i, 'serial_no', '-' )		
			idw_si.SetItem(i, 'lot_no', '-' )		
			idw_si.SetItem(i, 'po_no', ldsCCGenericField.GetItemString(index, 'project' ))		
			idw_si.SetItem(i, 'po_no2', '-' )		
			idw_si.SetItem(i, 'container_id', '-' )		
			idw_si.SetItem(i, 'expiration_date', '2999-12-31' )		
			idw_si.SetItem(i, 'country_of_origin', '-' )		
			idw_si.SetItem(i, 'quantity', 0 )		
			idw_si.SetItem(i, 'Line_item_no', i )		
			idw_si.SetItem(i, 'sequence', ldsCCGenericField.GetItemString(index, 'sequence' ) )		
		End If
	next
End If


//MEA - 05/12 - Fixed Issue with Exp Date
if left(gs_project, 4) = "NIKE" then
	ll_cnt = idw_si.rowcount()
			//  LTK 20150310  Removed ro_no from CC, so commented code block out below
			//
			//	If ll_cnt > 0 Then
			//		
			//		for i = 1 to ll_cnt 
			//			
			//			ldt_expiration_date	= idw_si.object.expiration_date[ i ]
			////			ls_ro_no 					= idw_si.object.ro_no[ i ]
			//			
			//			
			//			if date(ldt_expiration_date) = Date("2999/12/31") then
			//			
			//				Select complete_date into :ldt_expiration_date from receive_master where ro_no = :ls_ro_no;
			//
			//				If SQLCA.SQLCode < 0 then
			//					MessageBox ("SQL Err", SQLCA.SQLErrText )
			//				end if
			//
			//
			//				IF IsNull(ldt_expiration_date) then ldt_expiration_date = DateTime(Date("2999/12/31"), Time ("00:00"))
			//
			//				
			//				idw_si.SetItem( i, "expiration_date", ldt_expiration_date)
			//
			//			end if		
			//			
			//			
			//			
			//		next
			//	End If
End If

//12-JUNE-2018 :Madhu S19881 - CC Adjustment for all Order Types
//Assign sequence no value, if it is null
lsSequence = of_parse_numeric_sys_no( ls_order)

For ll_row =1 to idw_si.rowcount( )
	ls_si_sequence = idw_si.getItemString( ll_row, 'sequence')
	If isNull(ls_si_sequence) or ls_si_sequence = '' Then  idw_si.setItem( ll_row, 'sequence', lsSequence)
Next

IF i_nwarehouse.ids.modifiedCount() > 0 THEN	i_nwarehouse.ids.update(FALSE,FALSE)
If idw_si.RowCount() = 0 Then
	MessageBox(is_title, "No System Inventory Generated")
Else

	iw_window.Trigger Event ue_save()
	
	dw_sku.visible = false
	cb_import_sku.visible = false
	gb_import_sku.visible = false
	rb_sku.visible = false
	rb_location.visible = false

	uo_commodity_code1.visible = false
	cb_commodity.visible = false
	select_commodity_t.visible = false

End IF
tab_main.tabpage_si.enabled = true


w_main.SetMicroHelp("ready")
idw_si.Sort()

Destroy lds_cc

f_method_trace_special( gs_project, parent.ClassName() , 'End  generate CC Order ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_report from commandbutton within tabpage_main
integer x = 1573
integer y = 1632
integer width = 411
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Print Report"
end type

event getfocus;idsreport.Modify("ccno_t.Text=''")
end event

event constructor;g.of_check_label_button(this)
end event

event clicked;
wf_print_export_report(1)
end event

type cb_confirm from commandbutton within tabpage_main
integer x = 1138
integer y = 1632
integer width = 411
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Confirm"
end type

event clicked;integer li_return
long ll_totalrows,i, ll_new
datetime ldtToday
string ls_order, ls_msg, ls_ord_status, lsOrdStatus

integer liSerialMatch // TAM 2017/11

f_method_trace_special( gs_project, this.ClassName() , 'Start confirm CC Order ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

If idw_main.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	return 
End If

If ib_changed Then
	messagebox(is_title,'Please save changes first!',StopSign!)
	return
End If

//GailM 4/29/2019 - Google (baseline) - prevent CC from being confirmed multiple times
Select ord_status Into :lsOrdStatus From cc_master where project_id = :gs_Project and cc_no = :isCCOrder using SQLCA; 
If lsOrdStatus = 'C' Then
	ls_msg = 'This order has already been confirmed.  Please re-retrieve the order to validation confirmation.'
	messagebox(is_title,ls_msg) 
	return
End If

/*GXMOR - 9/2/2011 - Comcast must ensure actual counts validation prior to confirming.  This is a warning. */
If UPPER(gs_project) = 'COMCAST' then
	ls_msg =  'Ensure that you have validated all zero and no qty~n' +&
	'with actual counted before confirming this order.~n~n' +&
	'Are you sure you want to confirm this order?'
Else
	ls_msg = 'Are you sure you want to confirm this order?'
End if	

if messagebox(is_title,ls_msg,Question!,YesNo!,2) = 2 then
	return
End if

if Upper(gs_project) = 'PANDORA' then
	if f_functionality_manager(gs_Project,'FLAG','CLIENT','CC_CHECK_NULLS',"", "")= 'Y' then
		if wf_is_null_quantities_on_last_count() then
			MessageBox(is_title, "Cycle counts may not be confirmed with blank values on the last count.  ~rPlease populate all count values on the last count.")
			return -1
		end if
	end if
end if

ldtToday = f_getLocalWorldTime( idw_main.object.wh_code[ 1 ] ) 
If IsNull(idw_main.GetItemDateTime(1, 'complete_date')) Then
	idw_main.setitem(1,'complete_date', ldtToday )
End If

if setItemMasterCompleteDate( ldtToday ) = failure then return
if setLocationCompleteDate( ldtToday )= failure then return

doCompareSysInv()
If ib_up_count_zero_cc = FALSE THEN wf_create_up_count_zero_cc_records() //14-MAY-2018 :Madhu S19286 -  create Up Count Zero CC Records


// 02/16 - PCONKL - Changed this to be only for Pandora...
//if  ib_freeze_cc_inventory then
If gs_project = 'PANDORA' Then

	//TAM 2017/11 3PL CC -  If Serial Numbers have been entered then the Quantity counted for each location must match the number of Serial Numbers entered for that location
	//04-June-2018 :Madhu S19881 - Removed Order Type ='X', should work for all CC Order Type
	//If idw_Main.GetItemString(1, 'ord_type') = 'X' then
		If wf_is_sn_scan_required() < 0 Then Return -1  //17-APR-2018 :Madhu S18353  - Google - SIMS to provide option for scanning serial number when there is no discrepancy
		
		liSerialMatch = wf_Compare_Count_To_Serials()
		If liSerialMatch <> 0 then
			MessageBox(is_title, "The Quantity counted at each location does not match the number of serial numbers entered for the location.  ~rPlease and enter the correct number Serial Numbers.")
			Return -1
		End If
	//End If

	//22-Jan-2019 :Madhu S28292 - Don't confirm CC, if discrepancy occur on 1st and 2nd counts - START
	ls_ord_status = idw_main.getItemString(1, 'ord_status' )

	IF (idw_si.Find("(Not IsNull(difference)) AND difference <> 0", 1, idw_si.RowCount()) > 0 and  (ls_ord_status ='2' OR ls_ord_status ='1' )) THEN
		MessageBox(is_title, "Discrepancy found!. Please proceed up to 3rd Count and confirm CC Order", Stopsign!)	
		Return -1
	END IF

	//GailM 7/7/2020 DE16624 Google CC variance on 1st count did not create a 2nd count
	IF (ib_up_count_zero_cc and  (ls_ord_status ='2' OR ls_ord_status ='1' )) THEN
		MessageBox(is_title, "Up Count Zero Found. Please proceed up to 3rd Count and confirm CC Order", Stopsign!)	
		Return -1
	END IF

	//22-Jan-2019 :Madhu S28292 - Don't confirm CC, if discrepancy occur on 1st and 2nd counts - END
	
	if idw_si.Find("(Not IsNull(difference)) AND difference <> 0", 1, idw_si.RowCount()) > 0 then
		Open(w_cc_adjust_create)
		idw_si.SetFilter("")
		idw_si.Filter()
		
		if message.DoubleParm = 1 then
		else
			return -1
		end if
	end if
end if

idw_main.setitem(1,'ord_status','C')

If iw_window.Trigger Event ue_save() = 0 Then

	//BCR 17-AUG-2011: Need to be doubly sure cb_confirm is disabled once Confirm/Save is successful...Once in a blue moon,
	//Confirm button remains enabled after successful confirmation. Reason  not yet identifiable.
	tab_main.tabpage_main.cb_confirm.enabled = False
	
	//Jxlim 06/09/2010 Insert batch record for Pandora
	IF gs_project = "PANDORA" THEN		
		ls_order = idw_si.GetItemString(idw_si.GetRow(), "cc_no")
		// 12/08 - PCONKL - Want to write the record before we show confirmation msgbox
		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
		
		Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
		Values(:gs_Project, 'CC', :ls_order,'N', :ldtToday, '');		
		
		Execute Immediate "COMMIT" using SQLCA;
		
		w_main.SetMicrohelp("Record Confirmed!")
		Messagebox(is_title,'Cycle Count Confirmed!') 
	Else
		MessageBox(is_title, "Record confirmed!")
	End If
Else
	MessageBox(is_title, "Record confirm failed!")	
	Return
End If
//Jxlim 06/09/2010 End of modification to accomodate Pandoro req.

ib_up_count_zero_cc = FALSE //re-set value

f_method_trace_special( gs_project, this.ClassName() , 'End confirm CC Order ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

destroy ids_CC_UpCountZero_Result
end event

event constructor;
g.of_check_label_button(this)
end event

type sle_no from singlelineedit within tabpage_main
integer x = 398
integer y = 60
integer width = 818
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
integer limit = 16
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_order, ls_customer, ls_Max, ls_filter_str, ls_encoded_indicators

Long rows, ll_Result1Rows, ll_Result2Rows, ll_Result3Rows, ll_SIRows

// LTK 20150515  Lot-able rollup variables
long ll_rows, ll_found_row,  ll_found_si_row, i,  j, k
long ll_si_rows[], llUpCountFindRow
decimal{5} ld_quantity
String ls_result_column, ls_spread_column
datawindow ldw_work
Boolean lb_qty_arbitrarily_spread
Int li_line_item_numbers[], li_empty[]
// End of Lot-able rollup

String ls_Wh //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off
Long ll_cnt //TAM 2017/06 Added Flag from Lookup Table to turn functionality on or of

ls_order = This.Text
idw_main.Retrieve(ls_order)


If idw_main.RowCount() > 0 Then
	w_main.SetMicroHelp("Retrieving Cycle Count Information...")
	
	
	idw_si.Retrieve(ls_order)

	
	
	// 11/24/2014 dts - force 'LARGE' cycle counts to be processed via CITRIX (for now defined where machine name starts 'DCXVR*' but could list Citrix Machines in lookup table )'
	if idw_main.GetItemString(1, "Ord_Status") <> "C" and idw_main.GetItemString(1, "Ord_Status") <> "V" then
		//  - 'LARGE' is governed by lookup table value
		//TimA 04/10/15 Moved the blow into a function because it's also needed this called when creating new cycle counts.
		ib_NeedCitrix =  wf_run_on_citrix ( idw_si.rowcount( )) //New Function

//		ulong lul_name_size = 32
//		String	ls_machine_name = Space (32)
//		If gs_role > "-1" Then 	
//		g.GetComputerNameA (ls_machine_name, lul_name_size)
//		//original assumption was that the Citrix servers would follow the mask of 'DCXVRC*'
//		//  May need to allow for multiple masks (given by presence in the lookup_table), but still assuming that the 1st 6 characters are what's pertinent....
//		if left(ls_machine_name, 6) <> 'DCXVRC' then
//			ib_NeedCitrix = False
//			
//			ll_SIRows = idw_si.rowcount( )
//			//if gs_role = '-1' then messagebox("Message for SuperDuper Users:", "System Inventory Rows: " + string(ll_SIRows))
//	
//			SELECT Code_Descript INTO :ls_Max FROM Lookup_Table with(nolock)
//			Where project_id = :gs_project and Code_type = 'CycleCount' and Code_ID = 'MAX';
//			if IsNumber(ls_Max) then
//				if ll_SIRows > long(ls_Max) then
//					MessageBox("Cycle Count Max", "This Cycle Count must be processed via SIMS Citrix as the Line Count (" + string(ll_SIRows) +") exceeds the non-CITRIX MAX ("+ ls_Max +")")
//					ib_NeedCitrix = True
//				end if
//			end if 
//		end if //is machine a Citrix machine?
//		end if
	end if //Order is not Complete or Void.
	
	setCCOrder( ls_order )
	
	f_method_trace_special( gs_project, 'w_cc' , 'START of sle_no.modified()' ,isCCOrder, '','',isCCOrder)

	//TimA 05/04/12 Pandora issue #405 change the sort order to l_code to match reports
//	setCCOrder( 'l_code','sku' )
	
	IF idwc_count1_supp.Rowcount() = 0 THEN idwc_count1_supp.InsertRow(0)
	IF idwc_count2_supp.Rowcount() = 0 THEN idwc_count2_supp.InsertRow(0)
	IF idwc_count3_supp.Rowcount() = 0 THEN idwc_count3_supp.InsertRow(0)
	
	ll_Result1Rows = idw_result1.Retrieve(ls_order)
	ll_Result2Rows = idw_result2.Retrieve(ls_order)
	ll_Result3Rows = idw_result3.Retrieve(ls_order)
	
	idw_mobile.Retrieve(ls_order) /* 04/15 - PCONKL*/

// TAM - 2017/11 - 3PL CC 
	idw_system_generated.Retrieve(ls_order)
// TAM - 2017/11 - 3PL CC 
	idw_serial_numbers.Retrieve(ls_order) 
	idw_cc_container.retrieve( ls_order)  //24-APR-2018 :Madhu S18502 - FootPrint Cycle Count

	
	idw_result1.visible = true
	idw_result2.visible = true
	idw_result3.visible = true
	
	//setSortOrder( idw_si.object.DataWindow.Table.Sort )
	//TimA 05/04/12 Pandora issue #405 change the sort order to l_code to match reports
	//setSortOrder( 'l_code,sku' )
	// LTK 20150608  Added line_item_no to Tim's 2012 change above because PowerBuilder incosistantly sorts (reshulffles rows with each sort invocation) rows containing columns with like data.
	if upper(gs_project) ='NYCSP' then 
		setSortOrder( 'Component_No,Inventory_Type d,l_code,sku' ) //Dinesh 06/15/2021- S57097 - NYCSP - KNY: Order Cycle Count Data
	//setSortOrder( 'line_item_no,l_code,sku' ) //Dinesh 05/17/2021- S57097 - NYCSP - KNY: Order Cycle Count Data
	else
		setSortOrder( 'l_code,sku, line_item_no' ) // Commented by Dinesh - 05/17/2021
	end if
	
	// LTK 20150715  This fixes an issue so the previous order's protection rights are not enforced 
	// upon the newly retrieved order (when retrieving multiple orders without closing the window)
	of_ProtectResults ( idw_result1, UNPROTECT )
	of_ProtectResults ( idw_result2, UNPROTECT )
	tab_main.tabpage_result1.cb_selectall1.Enabled = TRUE
	tab_main.tabpage_result2.cb_selectall2.Enabled = TRUE

	// 1/24/2011; David C; Don't allow editing on 1st count if there are 2nd count rows
	if ll_Result1Rows > 0 and ll_Result2Rows > 0 then
		of_ProtectResults ( idw_result1, PROTECT )
		
		tab_main.tabpage_result1.cb_selectall1.Enabled = false
	end if
	
	// 1/24/2011; David C; Don't allow editing on 2nd count if there are 3rd count rows
	if ll_Result2Rows > 0 and ll_Result3Rows > 0 then
		of_ProtectResults ( idw_result2, PROTECT )
		
		tab_main.tabpage_result2.cb_selectall2.Enabled = false
	end if

	wf_sort()
	wf_check_status()
	ib_changed = False
	idw_main.Show()
	idw_main.SetFocus()
	
	// pvh - 06/18/06 - ccmods
	idw_main.object.t_ownerName.text = ''
	setwarehouse( idw_main.object.wh_code[ 1 ]  )
	
	idwc_owner.retrieve(gs_Project, getWarehouse())
	
	setOrderType( idw_main.object.ord_type[ 1 ]  )
	setBlindKnown()
	setBlindKnownprt()
	setCountDiff()
	//doDisplaySysQty( (getBlindKnown() = 'K' ) )		// LTK 20150608  Moved to bottom of this method
	if getOrderType() = 'S' then doDisplayOwnerName( Long( idw_main.object.owner_id[ 1 ] ) )
	wf_check_menu(false,'sort')
	wf_check_menu(false,'filter')
	// eom

	for k = 1 to 3

		if k = 1 then
			ls_result_column = "result_1"
			ls_spread_column = "count1_spread"
			ldw_work = idw_result1
			ls_encoded_indicators = idw_main.Object.Count1_Rollup_Code[1]
		elseif k = 2 then
			ls_result_column = "result_2"
			ls_spread_column = "count2_spread"
			ldw_work = idw_result2
			ls_encoded_indicators = idw_main.Object.Count2_Rollup_Code[1]
		elseif k = 3 then
			ls_result_column = "result_3"
			ls_spread_column = "count3_spread"
			ldw_work = idw_result3
			ls_encoded_indicators = idw_main.Object.Count3_Rollup_Code[1]
		end if

		lb_qty_arbitrarily_spread = FALSE
		li_line_item_numbers = li_empty 

		ll_rows = ldw_work.RowCount()
		
		//14-JUNE-2018 :Madhu DE4758 - Find Up_Count_Zero ='Y' Records
		//If any row found, spread counts
		llUpCountFindRow = ldw_work.find( "up_count_zero='Y'", 0, ldw_work.rowcount())
		
		if ((ll_rows > 0 and idw_si.RowCount() <> ll_rows) or (ll_rows> 0 and idw_si.RowCount() = ll_rows and llUpCountFindRow > 0)) then

			wf_clear_si_count_results( k )		// Clear the results from the SQL retrieve and set below

			// Traverse the count dw and determine the SI rows
			for i = 1 to ll_rows		
				lb_qty_arbitrarily_spread = FALSE
				ld_quantity = ldw_work.Object.quantity[ i ]
				if NOT IsNull( ld_quantity ) and ld_quantity > 0 then

					//ll_si_rows = wf_find_corresponding_si_rows( ldw_work, i, TRUE )
					ll_si_rows = wf_find_corresponding_si_rows( ldw_work, i, FALSE )
					
					// Sum SI QTY rows and compare it to ld_quantity.  If Sum SI QTY <> ld_quantity then set flag on these rows which will be used by subsequent count 
					// generations which will bring all rows where SIMS has arbitrarily spread count quantities.
					if ld_quantity <> wf_sum_si_quantity( ll_si_rows ) then
						lb_qty_arbitrarily_spread = TRUE
					end if
	
					for j = 1 to UpperBound( ll_si_rows )
	
						ll_found_row = getSysInvRow( ll_si_rows[ j ] )
	
						// Take the count from the count tab and spread it out over the corresponding SI rows
	
						// If count quantities were arbitrarily spread (from rolled up counts), set the corresponding indicator
						if lb_qty_arbitrarily_spread then
							idw_si.SetItem( ll_found_row, ls_spread_column, 'Y' )
							li_line_item_numbers[ UpperBound( li_line_item_numbers ) + 1 ] = idw_si.Object.line_item_no[ ll_found_row ]
						end if

//						if idw_si.Object.difference[ ll_found_row ] = 0 then
//							continue
//						end if

						if ld_quantity > 0 then
							//	if SI qty <= CC SUM qty; set SI CC qty to Sum qty and decrement SUM by SI qty
							//	SI qty > CC SUM qty; set SI CC qty to remaining Sum qty and break loop
							if idw_si.Object.quantity[ ll_found_row ] <= ld_quantity then
								idw_si.SetItem( ll_found_row, ls_result_column, idw_si.Object.quantity[ ll_found_row ] )
								ld_quantity -= idw_si.Object.quantity[ ll_found_row ]
							else
								idw_si.SetItem( ll_found_row, ls_result_column, ld_quantity )
								ld_quantity = 0
							end if
							if ( j = UpperBound( ll_si_rows ) ) and ( ld_quantity <> 0 ) then	// Last row and quantity still exists, assign rest to this last row
								idw_si.SetItem( ll_found_row, ls_result_column, ( idw_si.Object.quantity[ ll_found_row ] + ld_quantity) )
							end if
						else
							idw_si.SetItem( ll_found_row, ls_result_column, ld_quantity )
						end if
//						if ld_quantity = 0 then
//							exit
//						end if
					next
					
				else
//					ll_si_rows = wf_find_corresponding_si_rows( ldw_work, i, TRUE )
					ll_si_rows = wf_find_corresponding_si_rows( ldw_work, i, FALSE )
					for j = 1 to UpperBound( ll_si_rows )
						ll_found_row = getSysInvRow( ll_si_rows[ j ] )
						if ll_found_row > 0 then
							idw_si.SetItem( ll_found_row, ls_result_column, ld_quantity )
						end if
					next
					
				end if
			next
		end if
		
		
		// For any SI rows where the countX_spread is set, also set the countX_spread flag of the sister rows
		for i = 1 to UpperBound( li_line_item_numbers )

			ll_found_si_row = getSysInvRow( li_line_item_numbers[ i ] )
			
			ls_filter_str   = "Trim(sku) = '" + Trim( idw_si.Object.sku[ ll_found_si_row ] ) + "'"
			ls_filter_str += " and Trim(l_code) = '" + Trim( idw_si.Object.l_code[ ll_found_si_row ] ) + "'"
			ls_filter_str += " and Trim(supp_code) = '" + Trim( idw_si.Object.supp_code[ ll_found_si_row ] ) + "'"
			ls_filter_str += " and owner_id = " + String( idw_si.Object.owner_id[ ll_found_si_row ] )

			// Lot-ables
			if wf_decode_indicators( ls_encoded_indicators, DECODE_SERIAL_NO ) then
				ls_filter_str += " and Serial_No = '" + String( idw_si.Object.Serial_No[ ll_found_si_row ] ) + "' "
			end if
		
			if wf_decode_indicators( ls_encoded_indicators, DECODE_CONTAINER_ID ) then
				ls_filter_str += " and Container_Id = '" + String( idw_si.Object.container_id[ ll_found_si_row ] ) + "' "
			end if
		
			if wf_decode_indicators( ls_encoded_indicators, DECODE_LOT_NO ) then
				ls_filter_str += " and Lot_No = '" + String( idw_si.Object.Lot_No[ ll_found_si_row ] ) + "' "
			end if
		
			if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO ) then
				ls_filter_str += " and Po_No = '" + String( idw_si.Object.Po_No[ ll_found_si_row ] ) + "' "
			end if
			
			if wf_decode_indicators( ls_encoded_indicators, DECODE_PO_NO2 ) then
				ls_filter_str += " and Po_No2 = '" + String( idw_si.Object.Po_No2[ ll_found_si_row ] ) + "' "
			end if
			
			if wf_decode_indicators( ls_encoded_indicators, DECODE_EXP_DT ) then
				ls_filter_str += " and String(expiration_date,'mm/dd/yyyy hh:mm:ss') = '" + String( idw_si.getItemDateTime( ll_found_si_row, "Expiration_Date"), 'mm/dd/yyyy hh:mm:ss' ) + "' "
			end if
		
			//if wf_decode_indicators( ls_encoded_indicators, DECODE_INV_TYPE ) then
				ls_filter_str += " and Inventory_Type = '" + String( idw_si.Object.Inventory_Type[ ll_found_si_row ] ) + "' "
			//end if
		
			if wf_decode_indicators( ls_encoded_indicators, DECODE_COO ) then
				ls_filter_str += " and Country_of_Origin = '" + String( idw_si.Object.Country_of_Origin[ ll_found_si_row ] ) + "' "
			end if

		
			idw_si.SetFilter( ls_filter_str )
			idw_si.Filter()
			
			for j = 1 to idw_si.RowCount()
				idw_si.SetItem( j, ls_spread_column, 'Y' )
			next
			idw_si.SetFilter( "" )
			idw_si.Filter()

		next
	next

	// LTK 20150508  End of Lot-able rollup

	//TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off	
	ls_Wh = idw_main.object.wh_code[ 1 ]
	select count(Code_Type) into :ll_cnt from Lookup_Table
	where project_id = :gs_project and code_type = 'FILTER_ALLOCATED' and code_id = :ls_wh;
	if ll_cnt > 0 then
		ib_Filter_Allocated = TRUE
	Else
		ib_Filter_Allocated = FALSE
	end if	

Else
	MessageBox(is_title, "Order not found, please enter again!", Exclamation!)
	This.SetFocus()
	This.SelectText(1,Len(ls_order))
End If

// LTK 20150508  Moved this line from top of the method to here
doDisplaySysQty( (getBlindKnown() = 'K' ) )


idw_si.SetSort( getSortOrder() )
idw_si.Sort()

//17-Jun-2015 :Madhu- Pandora requested to make non-visible of Delete button for Pandora Directed Cycle Count -START
If upper(gs_project) ='PANDORA'  and getOrderType() ='P' Then
	tab_main.tabpage_si.cb_si_delete.visible=false
else
	tab_main.tabpage_si.cb_si_delete.visible=true
End IF
//17-Jun-2015 :Madhu- Pandora requested to make non-visible of Delete button for Pandora Directed Cycle Count-END

//07-May-2017 :TAM - PEVS-513 -Stock Inventory Commodity Codes - START
If upper(gs_project) ='PANDORA'  and getOrderType() ='C' Then
	wf_multi_select_commodity_code()
	idw_main.modify("commodity_cd_t.visible =true")
	idw_main.modify("commodity_cd.visible =true")
	idw_main.modify("commodity_select_t.visible =true")
	idw_main.modify("commodity_select.visible =true")
	tab_main.tabpage_main.uo_commodity_code1.bringtotop = True
	tab_main.tabpage_main.uo_commodity_code1.visible = True
	tab_main.tabpage_main.select_commodity_t.SetPosition(Behind!, tab_main.tabpage_main.uo_commodity_code1)
	tab_main.tabpage_main.cb_commodity.bringtotop = True
	
	ib_show_commodity_list = True
	if idw_main.GetItemString(1, "Commodity_list") <> "" and not IsNull(idw_main.GetItemString(1, "Commodity_list")) then
		tab_main.tabpage_main.uo_commodity_code1.uf_init_selected(idw_main.GetItemString(1, "Commodity_list"))
	End If
else
	idw_main.modify("commodity_cd_t.visible =false")
	idw_main.modify("commodity_cd.visible =false")
	idw_main.modify("commodity_select_t.visible =false")
	idw_main.modify("commodity_select.visible =false")
	tab_main.tabpage_main.uo_commodity_code1.bringtotop = false
	tab_main.tabpage_main.uo_commodity_code1.visible = false
End IF
//07-May-2017 :TAM - PEVS-513 -Stock Inventory Commodity Codes - END

////TAM 2017/11 -  3PL CC - START
//If upper(gs_project) ='PANDORA'  and getOrderType() ='X' Then
//			tab_main.tabpage_system_generated.visible = True
//End IF
////TAM 2017/11 -  3PL CC - END

////TAM 2017/11 -  3PL CC - START
//If upper(gs_project) ='PANDORA'  and getOrderType() ='X' Then
//	// If system inventory is present and the SKU is serial tracked
//	If idw_si.rowcount() > 0 Then
//		If idw_si.getItemString( 1, 'serialized_ind') <> 'N' Then
//			tab_main.tabpage_serial_numbers.visible = True
//		End If
//	End If
//End IF
////TAM 2017/11 -  3PL CC - END

f_method_trace_special( gs_project, 'w_cc' , 'END of sle_no.modified()' ,isCCOrder, '','',isCCOrder)

w_main.SetMicroHelp("Ready")
end event

type cb_import_sku from commandbutton within tabpage_main
boolean visible = false
integer x = 3191
integer y = 1540
integer width = 411
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Import..."
end type

event clicked;
//Added location after designed for sku.

string is_filename, is_fullname
string ls_sku, ls_location
integer i, li_count, li_row
datastore lds_error

lds_error = create datastore
lds_error.dataobject = "d_sku_import_external"

dw_sku.Reset()

//GetFileOpenName("Open", is_fullname, is_filename,   "txt", "Text Files (*.txt)")
GetFileOpenName("Select File", is_filename, is_fullname, "txt", "Text Files (*.txt*), *.txt*")

//If dw_sku.RowCount() > 15 then
//	
//	MessageBox ("Import Error", "Sku Import Limit is 15.")
//	dw_sku.Reset()
//	
//end if

If FileExists(is_filename) Then
	dw_sku.ImportFile(is_filename)
	
	FOR i =  dw_sku.RowCount() to 1 step -1
		
		if rb_sku.checked  then
		
			ls_sku = dw_sku.GetItemString( i, "sku") + "%"
	
			if trim(ls_sku) <> '' and not IsNull(ls_sku) then
				
				Select count(sku) INTO :li_count
					FROM content
					WHERE project_id = :gs_project AND
							  sku like :ls_sku AND
							  avail_qty > 0;
							  
				
				If li_count <= 0 then
					
					//MessageBox ("Error", ls_sku + " has no available inventory. ( Row: " + string(i) + " )")
					
					li_row = lds_error.InsertRow(1)
					lds_error.SetItem( li_row, "sku", (string(i) + ":" +  ls_sku))
	
					dw_sku.DeleteRow(i)
	
	//Validate the sku and  also check that the sku has  inventory.
	//At the end of the upload, throw the list of line no and skus is invalid or zero inventory in to  CC-Error.txt file
	//Prompt user $$HEX2$$1c202000$$ENDHEX$$.  If no records in CC-Error.txt then prompt user $$HEX1$$1c20$$ENDHEX$$complete upload sku$$HEX1$$1d20$$ENDHEX$$
	//For sku that have been uploaded , user can the move on to  click generate to proceed with the cycle count.
						
				end if
	
			end if
			
		else
			
			//Location
			
			ls_location = trim(dw_sku.GetItemString( i, "sku"))
	
			if trim(ls_location) <> '' and not IsNull(ls_location) then
				
				Select count(sku) INTO :li_count
					FROM content
					WHERE project_id = :gs_project AND
							  l_code = :ls_location AND
							  avail_qty > 0;
							  
				
				If li_count <= 0 then
					
					//MessageBox ("Error", ls_sku + " has no available inventory. ( Row: " + string(i) + " )")
					
					li_row = lds_error.InsertRow(1)
					lds_error.SetItem( li_row, "sku", (string(i) + ":" +  ls_location))
	
					dw_sku.DeleteRow(i)
	
				
				end if
		
			end if	
		
		end if
		
	NEXT

	if lds_error.RowCount() > 0 then
		lds_error.SaveAs("CC-Error.txt", csv!, false)
		MessageBox ("Import Error", "Check the CC-Error.txt file")
	else
		MessageBox ("Import Success", "Complete upload")
	end if

End If


end event

type gb_1 from groupbox within tabpage_main
integer x = 741
integer y = 1728
integer width = 2130
integer height = 176
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

event constructor;
if left(gs_project,4) = 'NIKE' then
	this.visible = true
else
	this.visible = false
end if
end event

type cb_stock_verification_report from commandbutton within tabpage_main
integer x = 773
integer y = 1780
integer width = 713
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Stock Verification Report"
end type

event clicked;Long row_cnt, row_no
Long line_gain, line_loss
Long tot_system, tot_count
string ls_cc_no          //   l_lob not used in Nike Shanghai 
string ls_s_loc, ls_e_loc, ls_where, ls_ord_status, ls_sql
Long i, ll_row

datastore ldw_report

ldw_report = create datastore
ldw_report.dataobject = "d_nike_stock_verification_rpt"
ldw_report.SetTransObject(SQLCA)

f_method_trace_special( gs_project, this.ClassName() , 'Start  Print stock verification report ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

//ldw_report.AcceptText()
//if wf_save_changes() = 0 then
//	return
//end if
//
//if dw_main.rowcount() <= 0 Then
//	Messagebox("Cycle Count - Print Stock Verification Report", "No record!")
//	Return
//End If

//dw_search.accepttext()
ldw_report.reset()

ls_cc_no = dw_main.getitemstring(1,"cc_no")
ls_s_loc =  sle_start_loc.text // "KNT-01-03"  // dw_search.getitemstring(1,"s_loc")
ls_e_loc = sle_end_loc.text //  "PNW-26-01" //dw_search.getitemstring(1,"e_loc")

If trim(ls_s_loc) = "" then 
	MessageBox ("Cycle Count - Print Stock Verification Report", "please enter Start Location!")
	sle_start_loc.SetFocus()
	Return
End If

If trim(ls_e_loc) = "" then 
	MessageBox ("Cycle Count - Print Stock Verification Report", "please enter End Location!")
	sle_end_loc.SetFocus()
	Return
End If


If isnull(ls_cc_no) Then
	messagebox("Cycle Count - Print Stock Verification Report", "please enter CC No.!")
	Return
End If

if isnull(ls_s_loc) and isnull(ls_e_loc) then
	messagebox("Cycle Count - Print Stock Verification Report", "Please enter location!")
	Return
End If


row_cnt = ldw_report.Retrieve(ls_cc_no, ls_s_loc, ls_e_loc)

// check pc_master
If row_cnt <= 0 Then
	messagebox("Cycle Count - Print Stock Verification Report", "Not found this order!")
	Return
Else
//	If ldw_report.GetItemString(1, "ord_status") = "C" Then
//		messagebox("Cycle Count - Print Stock Verification Report", "This order is confirmed!")
//		Return
//	End if
end if


If row_cnt <= 0 Then
	messagebox("Cycle Count - Print Stock Verification Report", "No record found!")
	Return
end if


SetPointer(Hourglass!)
line_gain = 0
line_loss = 0
tot_system = 0
tot_count = 0
For row_no = 1 to row_cnt
	tot_system += ldw_report.GetItemNumber(row_no, "systemqty")
	tot_count += ldw_report.GetItemNumber(row_no, "ccountqty")	
	If ldw_report.GetItemNumber(row_no, "stock_diff") > 0 Then
		line_gain = line_gain + 1
	Else
		If ldw_report.GetItemNumber(row_no, "stock_diff") < 0 Then
			line_loss = line_loss + 1
		End If
	End If
Next

ldw_report.Modify("line_gain.expression = '" + String(line_gain) + "'")
ldw_report.Modify("line_loss.expression = '" + String(line_loss) + "'")
ldw_report.Modify("total_line.expression = '" + String(row_cnt) + "'")
ldw_report.Modify("total_system.expression = '" + String(tot_system) + "'")
ldw_report.Modify("total_count.expression = '" + String(tot_count) + "'")
ldw_report.Modify("skucnt.expression = '" + String(row_cnt) + "'")
//ldw_report.SetFilter("stock_diff <> 0")
//ldw_report.Filter()
openwithparm(w_dw_print_options,ldw_report)
ldw_report.SetFilter("")

f_method_trace_special( gs_project, this.ClassName() , 'End  Print stock verification report ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
end event

event constructor;
if left(gs_project,4) = 'NIKE' then
	this.visible = true
else
	this.visible = false
end if
end event

type st_4 from statictext within tabpage_main
integer x = 1509
integer y = 1804
integer width = 265
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Start Loc:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
if left(gs_project,4) = 'NIKE' then
	this.visible = true
else
	this.visible = false
end if
end event

type sle_start_loc from singlelineedit within tabpage_main
integer x = 1801
integer y = 1788
integer width = 370
integer height = 92
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event constructor;
if left(gs_project,4) = 'NIKE' then
	this.visible = true
else
	this.visible = false
end if
end event

type st_5 from statictext within tabpage_main
integer x = 2194
integer y = 1804
integer width = 242
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "End Loc:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
if left(gs_project,4) = 'NIKE' then
	this.visible = true
else
	this.visible = false
end if
end event

type sle_end_loc from singlelineedit within tabpage_main
integer x = 2464
integer y = 1788
integer width = 343
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event constructor;
if left(gs_project,4) = 'NIKE' then
	this.visible = true
else
	this.visible = false
end if
end event

type uo_commodity_code1 from uo_multi_select_search within tabpage_main
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 2469
integer y = 900
integer width = 1303
integer height = 480
integer taborder = 30
end type

on uo_commodity_code1.destroy
call uo_multi_select_search::destroy
end on

type select_commodity_t from statictext within tabpage_main
boolean visible = false
integer x = 2437
integer y = 784
integer width = 1362
integer height = 596
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Select Commodities"
alignment alignment = center!
boolean border = true
long bordercolor = 67108864
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type gb_import_sku from groupbox within tabpage_main
boolean visible = false
integer x = 2962
integer y = 44
integer width = 882
integer height = 1628
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Import"
end type

type dw_sku from datawindow within tabpage_main
boolean visible = false
integer x = 2994
integer y = 208
integer width = 818
integer height = 1300
integer taborder = 60
string title = "none"
string dataobject = "d_sku_import_external"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_main from u_dw_ancestor within tabpage_main
event ue_check_random_settings ( )
integer y = 176
integer width = 3186
integer height = 1428
integer taborder = 20
string dataobject = "d_cc_master"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_check_random_settings();String	ls_wh
Long	ll_Cnt

ls_wh = This.GetItemString(1, "wh_code")

If (This.GetItemString(1,'ord_type')  = 'R' or This.GetItemString(1,'ord_type')  = 'Q')  and ls_wh > ''  Then /*Random - 09/09 - PCONKL */
			
	//Retrieve the Number of Random Locations to count and set as a default
	Select CC_Rnd_loc_Cnt into :ll_cnt
	From Project_warehouse
	Where Project_id = :gs_Project and wh_code = :ls_wh;
		
	If isNull(ll_Cnt) Then ll_Cnt = 0
	This.SetItem(1, "range_cnt", ll_Cnt)
	This.SetItem(1, "range_start", "RND")
	This.SetItem(1, "range_end", "RND")
	
	If ll_Cnt = 0 Then
		Messagebox(is_title, "Random/Sequential Cycle Count parameters have not been set for this warehouse.~rPlease enter a number of locations to count randomly/Sequentially.")
		This.SetColumn('range_cnt')
	End If
		
End If
end event

event itemchanged;call super::itemchanged;Long ll_cnt, i, llRowCount, llRowPos
String ls_s, ls_e, ls_wh, lsAttributes, lsXML, lsXMLResponse, lsReturnCode, lsReturnDesc
DateTime ldtgmt

Choose Case dwo.Name

	case 'group'
		doFilterDropDown( idwc_class , 'group_code', Trim( data )  )
		
		
	// pvh 08/25/05 - GMT
	case 'wh_code'
		
		g.setCurrentWarehouse( data )
		This.SetItem(row, "range_start", "")
		This.SetItem(row, "range_end", "")
		This.SetItem(row, "range_cnt", 0)
		idw_Mobile.TriggerEvent('ue_clear') /* 04/15 - PCONKL*/
		
		This.PostEvent('ue_check_random_Settings') /* 09/09 - PCONKL - Default range and number of locations if a random Count*/
	
		//TAM 2017/06 Added Flag from Lookup Table to turn functionality on or off
		ls_wh = data
		select count(Code_Type) into :ll_cnt from Lookup_Table
		where project_id = :gs_project and code_type = 'FILTER_ALLOCATED' and code_id = :ls_wh;
		if ll_cnt > 0 then
			ib_Filter_Allocated = TRUE
		Else
			ib_Filter_Allocated = FALSE
		end if	

	Case "ord_type"
		
		This.SetItem(row, "range_start", "")
		This.SetItem(row, "range_end", "")
		This.SetItem(row, "range_cnt", 0)
		idw_Mobile.TriggerEvent('ue_clear') /* 04/15 - PCONKL*/
		
		// 04/15 - PCONKL - Mobile not enabled for count by SKU
		if data = 'S' Then
			This.SetItem(row,'mobile_enabled_ind','N')
		End If
		
		setOrderType( data )
		
		This.PostEvent('ue_check_random_Settings') /* 09/09 - PCONKL - Default range and number of locations if a random Count*/
		
		//07-May-2017 :TAM - PEVS-513 -Stock Inventory Commodity Codes - START
		if data = 'C' Then 
			uo_commodity_code1.visible = True
			cb_commodity.visible = true
			select_commodity_t.visible = true
			select_commodity_t.SetPosition(Behind!, uo_commodity_code1)
			uo_commodity_code1.SetPosition(TopMost!)
			cb_commodity.SetPosition(TopMost!)
		
			ib_show_commodity_list = True
			if idw_main.GetItemString(1, "Commodity_list") <> "" and not IsNull(idw_main.GetItemString(1, "Commodity_list")) then
				tab_main.tabpage_main.uo_commodity_code1.uf_init_selected(idw_main.GetItemString(1, "Commodity_list"))
			End If
		else
			uo_commodity_code1.visible = false
			cb_commodity.visible = false
			select_commodity_t.visible = false
		End IF
		//07-May-2017 :TAM - PEVS-513 -Stock Inventory Commodity Codes - END
		
		if data = 'I' then

			gb_import_sku.visible = true
				
			dw_sku.visible = true
			cb_import_sku.visible = true

			rb_sku.visible = true
			rb_location.visible = true

			gb_import_sku.SetPosition(Behind!, dw_sku)

			dw_sku.SetPosition(TopMost!)
			cb_import_sku.SetPosition(TopMost!)

			rb_sku.SetPosition(TopMost!)
			rb_location.SetPosition(TopMost!)			
			
			gb_import_sku.SetPosition(TopMost!)
			
			

		else

			dw_sku.visible = false
			cb_import_sku.visible = false
			gb_import_sku.visible = false
			rb_sku.visible = false
			rb_location.visible = false
			
		end if

		//17-Jun-2015 :Madhu- Pandora requested to make non-visible of Delete button for Pandora Directed Cycle Count -START
			If upper(gs_project) ='PANDORA'  and data ='P' Then
				tab_main.tabpage_si.cb_si_delete.visible=false
			else
				tab_main.tabpage_si.cb_si_delete.visible=true
			End IF
		//17-Jun-2015 :Madhu- Pandora requested to make non-visible of Delete button for Pandora Directed Cycle Count-END

		
	Case "range_start"
		
		This.SetItem(row, "range_end", "")
		This.SetItem(row, "range_cnt", 0)
		idw_Mobile.TriggerEvent('ue_clear') /* 04/15 - PCONKL*/
		
	Case "range_end"
		
		ls_s = This.GetItemString(row, "range_start")
		ls_e = data
		ls_wh = This.GetItemString(row, "wh_code")
		
		// dts - 8/26/2010 - If This.GetItemString(row, "ord_type") = "L" Then
		If This.GetItemString(row, "ord_type") = "L" or This.GetItemString(row, "ord_type") = "B" Then	
			Select Count(*) into :ll_cnt 
				From Location
				Where wh_code = :ls_wh and l_code between :ls_s and :ls_e;
			If sqlca.sqlcode <> 0 Then ll_cnt = 0
			
		ElseIf This.GetItemString(row, "ord_type") = "S" Then
			
			// 04/03 - PCONKL - Valid range should be determined from Item Master, Not Inventory
			Select Count(distinct sku) into :ll_cnt 
			From Item_MAster
			Where Project_ID = :gs_Project and sku between :ls_s and :ls_e;
			
			If sqlca.sqlcode <> 0 Then ll_cnt = 0
			
		End If
		
		If ll_cnt = 0 Then 
			MessageBox(is_title, "No Items found in this range!")
			Return 2
		Else
			This.SetItem(row, "range_cnt", ll_cnt)		
		End If
		
		idw_mobile.PostEvent('ue_build_location_list')
		
	Case "range_cnt"
		
		ls_s = This.GetItemString(row, "range_start")
		ll_cnt = Long(data)
		i = 0
		ls_wh = This.GetItemString(row, "wh_code")
		// dts - 8/26/10 - If This.GetItemString(row, "ord_type") = "L" Then
		If This.GetItemString(row, "ord_type") = "L" or This.GetItemString(row, "ord_type") = "B" Then	
			Declare c_loc cursor for
				Select l_code 
					From location
					Where wh_code = :ls_wh and l_code >= :ls_s
					order by l_code; /* 04/15 - PCONKL - added order by*/
			Open c_loc;
			Do While sqlca.sqlcode = 0 and i < ll_cnt ;
				Fetch c_loc into :ls_e ;
				If sqlca.sqlcode = 0 Then i += 1
			Loop
			Close c_loc;
			
		ElseIf This.GetItemString(row, "ord_type") = "S" Then
			
			// 04/03 - PCONKL - Range should be generated from Item Master, Not inventory
			Declare c_sku cursor for
			Select distinct sku 
					From Item_Master
					Where project_id = :gs_project and  sku >= :ls_s
					Order by sku;

			Open c_sku;
			
			Do While sqlca.sqlcode = 0 and i < ll_cnt ;
				Fetch c_sku into :ls_e ;
				If sqlca.sqlcode = 0 Then i += 1
			Loop
			
			Close c_sku;
			
		ElseIf This.GetItemString(row, "ord_type") = "R" or This.GetItemString(row, "ord_type") = "Q" Then /* by random, or Sequential (03/12 - PCONKL)*/
			
			i = Long(data)
			ls_e = "RND"
			
		End If
		
		If i > 0 Then
			This.SetItem(row, "range_end", ls_e)
			This.SetItem(row, "range_cnt", i)
			idw_mobile.PostEvent('ue_build_location_list')
			Return 2
		Else
			MessageBox(is_title, "No Items found in this range!")
			Return 2
		End If
		
		
		
	case "mobile_enabled_ind"
		
		//If System Inventory has been generated, it will be deleted when releasing to mobile. It will be re-generated when processing starts on the mobile device
		if data = 'Y' Then
			
			If idw_si.RowCount() > 0 Then
				
				If Messagebox("Release to Mobile", "Releasing to Mobile will  delete the System Inventory records.~rThey will be regenerated when processing begins on the mobile device.~r~rContinue?",Question!,YesNo!,1) = 2 Then
					Return 1
				End If
				
				llRowCount = idw_si.RowCount()
				For llRowPos = llRowCount to 1 step - 1
					idw_si.DeleteRow(llRowPos)
				Next
				
			End If
			
			//Set status and Release Time
			ls_wh = idw_Main.GetITemString(1,'wh_code')
			ldtGMT = f_getLocalWorldTime( idw_main.object.wh_code[1] ) 
			This.SetItem(1,'Mobile_status_Ind','R')
			This.SetItem(1,'mobile_released_time',ldtgmt)
				
		else /*turning off, re-enable generate button*/
			
			//Clear release time
			setnull(ldtgmt)
			This.SetItem(1,'Mobile_status_Ind','')
			This.SetItem(1,'Mobile_user_assigned','')
			This.SetItem(1,'mobile_released_time',ldtgmt)
			
		End If
		
		// PostUEItemchanged wwill call wf_check-status()
		
	Case "commodity_list"

	case "mobile_user_assigned"
		
		If Data = "" Then Return
		
		If not isvalid(iuoWebsphere) Then
			iuoWebsphere = CREATE u_nvo_websphere_post
			linit = Create Inet
		End If

		//If a user is assigned, make sure it is a valid user
		lsAttributes = ' UserID = "' + data  + '"'
		lsXML = iuoWebsphere.uf_request_header("ValidateUserExistsRequest", lsAttributes)
		lsXML = iuoWebsphere.uf_request_footer(lsXML)

		w_main.Setmicrohelp("Validating User ID...")
		
		lsXMLResponse = iuoWebsphere.uf_post_url(lsXML)
		
		w_main.Setmicrohelp("Ready")

		//If we didn't receive an XML back, there is a fatal exception error
		If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
			Messagebox("Websphere Fatal Exception Error","Unable to Validate User: ~r~r" + lsXMLResponse,StopSign!)
			Return 
		End If

		lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
		lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

		If lsReturnCode<> "0"  Then
			MessageBox("Assign User","Invalid User ID. Cannot assign to Cycle Count.",StopSign!)
			REturn 1
		End If
		
End Choose
	
ib_changed = True
end event

event itemerror;If dwo.Name = "range_end" or dwo.Name = "range_cnt" Then 
	Return 1
Else
	return 2
End If
end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1

end event

event retrieveend;call super::retrieveend;// pvh 08/25/05 - GMT

if rowcount <= 0 then return AncestorReturnValue

g.setCurrentWarehouse( dw_main.object.wh_code[ 1 ] )

// pvh - 06/28/06 - ccmods
if NOT isNull( idw_main.object.group[ 1 ] ) then	doFilterDropDown( idwc_class , 'group_code',  idw_main.object.group[ 1 ]  )
//
return AncestorReturnValue

end event

event clicked;call super::clicked;
string status

status = idw_main.GetItemString(1,"ord_status")

if status = "V" OR status = "C" then return

choose case dwo.name
	case 'b_owner'
		iw_window.event ue_getOwner()

end choose

end event

event ue_postitemchanged;call super::ue_postitemchanged;
Choose Case dwo.name
		
	case "mobile_enabled_ind", "ord_type", "wh_code"
		
		wf_check_status()
		
End Choose
end event

type cb_search from commandbutton within tabpage_search
integer x = 2907
integer y = 28
integer width = 357
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
end type

event clicked;// ET3 - 12/04/13: Adding UF1 to search options for Pandora

DateTime ldt_date
String ls_string, ls_where, ls_sql 
Boolean lb_order_from, lb_order_to, lb_complete_from, lb_complete_to

//Initialize Date Flags
lb_order_from 		= FALSE
lb_order_to 		= FAlSE
lb_complete_from 	= FALSE
lb_complete_to 	= FALSE

If idw_search.AcceptText() = -1 Then Return

idw_result.Reset()
ls_sql = is_sql

ls_where = " Where project_id = '" + gs_project + "' "

ldt_date = idw_search.GetItemDateTime(1,"ord_date_s")
If  Not IsNull(ldt_date) Then
	ls_where += " and ord_date >= '" + &
		String(ldt_date, "mm/dd/yyyy hh:mm") + "' "
	lb_order_from = TRUE	
End If

ldt_date = idw_search.GetItemDateTime(1,"ord_date_e")
If  Not IsNull(ldt_date) Then
	ls_where += " and ord_date <= '" + &
		String(ldt_date, "mm/dd/yyyy hh:mm") + "' "
	lb_order_to = TRUE	
End If

ldt_date = idw_search.GetItemDateTime(1,"complete_date_s")
If  Not IsNull(ldt_date) Then
	ls_where += " and complete_date >= '" + &
		String(ldt_date, "mm/dd/yyyy hh:mm") + "' "
	lb_complete_from = TRUE	
End If

ldt_date = idw_search.GetItemDateTime(1,"complete_date_e")
If  Not IsNull(ldt_date) Then
	ls_where += " and complete_date <= '" + &
		String(ldt_date, "mm/dd/yyyy hh:mm") + "' "
	lb_complete_to = TRUE	
End If

ls_string = idw_search.GetItemString(1,"ord_type")
if not isNull(ls_string) then
	ls_where += " and ord_type = '" + ls_string + "' "
end if

ls_string = idw_search.GetItemString(1,"ord_status")
if not isNull(ls_string) then
	ls_where += " and ord_status = '" + ls_string + "' "
end if

ls_string = idw_search.GetItemString(1,"wh_code")
if not isNull(ls_string) then
	ls_where += " and wh_code = '" + ls_string + "' "
end if

// ET3 - UF1 added for Pandora
//13-MAR-2018 :Madhu S16312 - Added 'CC_No' to search criteria
ls_string = idw_search.GetItemString(1,"user_field1")
if not isNull(ls_string) then
	ls_where += " and ( user_field1 = '" + ls_string + "' or CC_NO ='" + ls_string +"' )"
end if

ls_string = idw_search.GetItemString(1,"sku_1")
if not isNull(ls_string) then
	ls_where += " and ( CC_master.CC_NO in (select CC_INVENTORY.CC_NO from CC_INVENTORY where CC_INVENTORY.SKU = '" + ls_string + "'))" 
end if

//Check Order Date range for any errors prior to retrieving
IF	((lb_order_to = TRUE and lb_order_from = FALSE) 	OR &
	 (lb_order_from = TRUE and lb_order_to = FALSE)  	OR &
	 (lb_order_from = FALSE and lb_order_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Order Date Range", Stopsign!)
	Return
END IF

//Check Complete Date range for any errors prior to retrieving
IF ((lb_complete_to = TRUE and lb_complete_from = FALSE) 	OR &
	 (lb_complete_from = TRUE and lb_complete_to = FALSE)  	OR &
	 (lb_complete_from = FALSE and lb_complete_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Complete Date Range", Stopsign!)
	Return
END IF

// 04/15 - PCONKL - added mobile status
ls_string = idw_search.GetItemString(1,"mobile_status")
if not isNull(ls_string) then
	ls_where += " and mobile_status_ind = '" + ls_string + "' "
end if

ls_sql += ls_where
idw_result.SetSqlSelect(ls_sql)

If idw_result.Retrieve() = 0 Then
	messagebox(is_title,"No record found!")
End If

end event

event constructor;
g.of_check_label_button(this)
end event

type dw_search from datawindow within tabpage_search
integer x = 41
integer y = 28
integer width = 2821
integer height = 284
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_cc_search"
boolean border = false
end type

event constructor;ib_order_from_first 			= TRUE
ib_order_to_first 			= TRUE
ib_complete_from_first 		= TRUE
ib_complete_to_first 		= TRUE

g.of_check_label(this) 

//04/15 - PCONKL - Make mobile related fields invisible if project not mobile enabled

If Not g.ibMobileEnabled Then
	this.modify("mobile_status.visible=false mobile_status_t.visible=false")
End If
		


end event

event clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_search.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_search.GetRow()

CHOOSE CASE ls_column
		
	CASE "ord_date_s"
		
		IF ib_order_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_search.SetColumn("ord_date_s")
			dw_search.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_order_from_first = FALSE
			
		END IF
		
	CASE "ord_date_e"
		
		IF ib_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_search.SetColumn("ord_date_e")
			dw_search.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_order_to_first = FALSE
			
		END IF
		
	CASE "complete_date_s"
		
		IF ib_complete_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_search.SetColumn("complete_date_s")
			dw_search.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_complete_from_first = FALSE
			
		END IF
		
	CASE "complete_date_e"
		
		IF ib_complete_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_search.SetColumn("complete_date_e")
			dw_search.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_complete_to_first = FALSE
			
		END IF
		
			
	CASE ELSE
		
END CHOOSE

end event

type cb_clear from commandbutton within tabpage_search
integer x = 2907
integer y = 144
integer width = 357
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;idw_result.Reset()
idw_search.Reset()
idw_search.InsertRow(0)
end event

event constructor;g.of_check_label_button(this)
end event

type dw_result from u_dw_ancestor within tabpage_search
integer x = 9
integer y = 348
integer width = 3799
integer height = 1552
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cc_result"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;// Pasting the record to the main entry datawindow
string ls_code

IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	If ib_changed = False and ib_edit = True Then
		ls_code = this.getitemstring(row,'cc_no')
		isle_code.text = ls_code
		isle_code.TriggerEvent(Modified!)
	End If
END IF
end event

event clicked;call super::clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF

end event

event constructor;call super::constructor;ib_filter= true

//04/15 - hide mobile fields if project not mobile enabled
If Not g.ibMobileEnabled Then
	this.modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
End If
end event

type tabpage_si from userobject within tab_main
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 4279
integer height = 1916
long backcolor = 79741120
string text = " System Inventory "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_release cb_release
st_cc_warehouse_print_flag_set_to st_cc_warehouse_print_flag_set_to
st_cc_warehouise_flag_set_to st_cc_warehouise_flag_set_to
st_msg2 st_msg2
st_msg1 st_msg1
cb_si_delete cb_si_delete
cb_si_insert cb_si_insert
dw_si dw_si
end type

on tabpage_si.create
this.cb_release=create cb_release
this.st_cc_warehouse_print_flag_set_to=create st_cc_warehouse_print_flag_set_to
this.st_cc_warehouise_flag_set_to=create st_cc_warehouise_flag_set_to
this.st_msg2=create st_msg2
this.st_msg1=create st_msg1
this.cb_si_delete=create cb_si_delete
this.cb_si_insert=create cb_si_insert
this.dw_si=create dw_si
this.Control[]={this.cb_release,&
this.st_cc_warehouse_print_flag_set_to,&
this.st_cc_warehouise_flag_set_to,&
this.st_msg2,&
this.st_msg1,&
this.cb_si_delete,&
this.cb_si_insert,&
this.dw_si}
end on

on tabpage_si.destroy
destroy(this.cb_release)
destroy(this.st_cc_warehouse_print_flag_set_to)
destroy(this.st_cc_warehouise_flag_set_to)
destroy(this.st_msg2)
destroy(this.st_msg1)
destroy(this.cb_si_delete)
destroy(this.cb_si_insert)
destroy(this.dw_si)
end on

type cb_release from commandbutton within tabpage_si
integer x = 1243
integer y = 20
integer width = 370
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Release Line"
end type

event clicked;idw_si.event dynamic ue_ReleaseRow()

end event

type st_cc_warehouse_print_flag_set_to from statictext within tabpage_si
integer x = 2181
integer y = 60
integer width = 731
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Warehouse Print Flag Set To:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_cc_warehouise_flag_set_to from statictext within tabpage_si
integer x = 2299
integer y = 4
integer width = 613
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Warehouse Flag Set To:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;g.of_check_label_button(this)
end event

type st_msg2 from statictext within tabpage_si
integer x = 2912
integer y = 60
integer width = 549
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_msg1 from statictext within tabpage_si
integer x = 2912
integer y = 4
integer width = 549
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_si_delete from commandbutton within tabpage_si
integer x = 855
integer y = 20
integer width = 370
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;idw_si.event dynamic ue_DeleteRow()

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_si_insert from commandbutton within tabpage_si
integer x = 443
integer y = 20
integer width = 370
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insert"
end type

event clicked;idw_si.event dynamic ue_insertRow()

end event

event constructor;
g.of_check_label_button(this)
end event

type dw_si from u_dw_ancestor within tabpage_si
event ue_insertrow ( )
event ue_deleterow ( )
event ue_releaserow ( )
string tag = "microhelp"
integer y = 128
integer width = 3333
integer height = 1676
integer taborder = 20
string dataobject = "d_cc_inventory"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_insertrow();// ue_insertRow()
long insertRow

if getRow() <=0 then return

// can't allow it if count dws have data
if idw_result1.rowcount() > 0 then
	beep(1)
	return
end if
if idw_result2.rowcount() > 0 then
	beep(1)
	return
end if
if idw_result3.rowcount() > 0 then
	beep(1)
	return
end if
insertRow = insertRow( getRow() )
this.object.line_item_no[ insertRow ] = rowcount()
ib_changed = true
end event

event ue_deleterow();// ue_deleteRow()

if getRow() <= 0 then return

// can't allow it if count dws have data
if idw_result1.rowcount() > 0 then
	beep(1)
	return
end if
if idw_result2.rowcount() > 0 then
	beep(1)
	return
end if
if idw_result3.rowcount() > 0 then
	beep(1)
	return
end if
if messagebox( is_title, "Are you sure you want to delete row " + string ( getRow() ) + "?",question!, yesno! ) <> 1 then return

deleteRow( getRow() )


ib_changed = true

end event

event ue_releaserow();/*ue_ReleaseRow...
  dts - 2/27/2013 - 556-2; Setting the System Inventory location to ALLOCATED and deleting a line from counts
  First, set SI row to 'ALLOCATED' and then delete any Result rows for associated line_item_no (depending on Ord Status = 1, 2, 3)
  The inventory will be Released (taken out of Cycle Count) in ue_save.
*/
long ll_SI_Row, ll_LineItemNo, ll_ResultRow, ll_SI_Rollup_Row, llFindRow
string ls_status, ls_location
string FindThis, lsContainerID
long llFoundRow
String ls_allocated = 'Allocated'		// LTK 20140731  Pandora #882 - allow release of multiple lines
String ls_allocated_count = ''		// LTK 20140731  Pandora #882
String lsReleaseLines, ls_encoded_indicators, lsData, lsTemp //TAM 2017/02
Int liPos

f_method_trace_special( gs_project, this.ClassName() , 'Start Release row ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

ll_SI_Row = GetRow()

if ll_SI_Row <= 0 then return

//need to check l_code here (not 'no_count' or 'allocated')
ls_location = upper(idw_SI.GetItemString(ll_SI_Row, "l_code"))
//if ls_location = 'NO_COUNT' or ls_location = 'ALLOCATED' then
if ls_location = 'NO_COUNT' or Left(ls_location, 9) = 'ALLOCATED' then
	messagebox(is_title, "Release functionality Not Applicable for " + ls_location + " lines.", StopSign!)
	return
end if
//3/19/13 - need to see if a duplicate would be created....

// LTK 20140731  Pandora #882 comment out block below...
//
//	findthis = "sku ='" + idw_si.object.sku[ll_SI_Row] + "' and "
//	//findthis += "l_code ='Allocated' and "		
//	findthis += "Pos(l_code,'Allocated') > 0 and "		// LTK 20140731  Pandora #882
//	findthis += "supp_code = '" + idw_si.object.supp_code[ll_SI_Row] + "' and "
//	findthis += "inventory_type ='" + idw_si.object.inventory_type[ll_SI_Row] + "' and " 
//	findthis += "serial_no ='" + idw_si.object.serial_no[ll_SI_Row] + "' and "
//	findthis += "lot_no ='" + idw_si.object.lot_no[ll_SI_Row] + "' and " 
//	findthis += "country_of_origin ='" + idw_si.object.country_of_origin[ll_SI_Row] + "' and "
//	findthis += "owner_id =" + string( idw_si.object.owner_id[ll_SI_Row] ) + " and "
//	findthis += "ro_no = '" + idw_si.object.ro_no[ll_SI_Row] + "'" 
//	
//	lsContainerID = idw_si.object.container_id[ll_SI_Row]
//	IF (NOT IsNull(lsContainerID) ) and (lsContainerID <> '') and (lsContainerID <> '-') THEN
//		findthis += " and container_id ='" + idw_si.object.container_id[ll_SI_Row] + "'"
//	END IF
//		
//	llFoundRow = idw_si.find( findthis, 1, idw_si.rowcount() )
//	if llFoundRow > 0 then
//		messagebox(is_title, "Can NOT release this line as it will create a duplicate Cycle Count line (when combined with another 'Allocated' line).", StopSign!)
//		return
//	end if



/*
ls_loc 				= idw_result1.GetItemString( li_idx, "l_code", Delete!, false)
ls_sku					= idw_result1.GetItemString( li_idx, "sku", Delete!, false)
ls_supp				= idw_result1.GetItemString( li_idx, "supp_code", Delete!, false)
ll_owner				= idw_result1.GetItemNumber( li_idx, "owner_id", Delete!, false)
ls_type				= idw_result1.GetItemString( li_idx, "inventory_type", Delete!, false)
ls_serial				= idw_result1.GetItemString( li_idx, "serial_no", Delete!, false)
ls_lot					= idw_result1.GetItemString( li_idx, "lot_no", Delete!, false)
ls_po					= idw_result1.GetItemString( li_idx, "po_no", Delete!, false)
ls_po2				= idw_result1.GetItemString( li_idx, "po_no2", Delete!, false)
ls_container_id		= idw_result1.GetItemString( li_idx, "container_id", Delete!, false)
ldt_expiration_date= idw_result1.GetItemDateTime( li_idx, "expiration_date", Delete!, false)
ls_coo				= idw_result1.GetItemString( li_idx, "country_of_origin", Delete!, false)
ls_ro_no				= idw_result1.GetItemString( li_idx, "ro_no", Delete!, false)
*/

 // TAM 02/2017 - If the Cycle Count has a rollup then we need to release all row that are on the rolled up line.  Code changes below will get all lines
 // that are rolled up or will be rolled up on CC1 and "Allocate"  all those lines.
 
ls_allocated_count = wf_find_greatest_allocated(ll_SI_Row)	// LTK 20140731  Pandora #882 - returns the highest allocated number + 1

 // Get Rollup codes on CC1
 ls_encoded_indicators = wf_build_encoded_rollup_code( 3 )
// If Rollup Codes are all 'N' then no rollup and release just one line.
if ls_encoded_indicators = 'YYYYYYYY' Then 
	
	if messagebox(is_title, "Are you sure you want to Release the Inventory for row " + string (ll_SI_Row) + "?",question!, yesno! ) <> 1 then return

	//idw_SI.SetItem(ll_SI_Row, "l_code", "Allocated")	// LTK 20140731  Pandora #882
	idw_SI.SetItem(ll_SI_Row, "l_code", ls_allocated + ls_allocated_count)
	idw_SI.SetItemStatus(ll_SI_Row, "l_code", Primary!, DataModified!)

Else
	ls_allocated_count = wf_find_greatest_allocated_rollup(ll_SI_Row, ls_encoded_indicators )	//TAM 2017/04 If rolloup is turned on then we need to remove have a different method to prevent duplicates - returns the highest allocated number + 1

	// If and Rollup exist then build the find statement and get all the lines that are to be released for the message.
	// Function to build the find statement on System inventory and return the line numbers.
	lsReleaseLines = 	wf_get_rollup_release_lines( wf_find_corresponding_release_lines( this, ll_SI_Row, FALSE ) )
	
	
	if messagebox(is_title, "The Line is Part of a Roll Up for Lines " + lsReleaseLines + "  Are you sure you want to Release Inventory for these lines?",question!, yesno! ) <> 1 then return
		lsData = lsReleaseLines
		lipos = pos(lsData,',')
		if liPos = 0 and lsData > '' Then
			lsTemp = lsData
			lsData = ''
		Else 
			lsTemp = Left(lsData,(lipos - 1))
			lsData = Replace(lsData, 1, lipos, '' )
		End If
		If IsNumber(lsTemp) then
			ll_SI_Rollup_Row = Long(lsTemp)
		End If

//	ll_SI_Rollup_Row = 
	Do While ll_SI_Rollup_Row > 0

		// ET3 2012-10-30 Pandora 496 - Exception for multiple row cartons - skip the DIM/Weight test
		llFindRow = idw_SI.Find("line_item_no = " + String(ll_SI_Rollup_Row) ,1, idw_SI.rowCount())

		idw_SI.SetItem(llFindRow, "l_code", ls_allocated + ls_allocated_count)
		idw_SI.SetItemStatus(llFindRow, "l_code", Primary!, DataModified!)

		lipos = pos(lsData,',')

		if liPos = 0 and lsData > '' Then
			lsTemp = lsData
			lsData = ''
		Else 
			lsTemp = Left(lsData,(lipos - 1))
			lsData = Replace(lsData, 1, lipos, '' )
		End If

		If IsNumber(lsTemp) then
			ll_SI_Rollup_Row = Long(lsTemp)
		Else
			ll_SI_Rollup_Row = 0
		End If
	
	Loop
End If
 // TAM 02/2017 - END

//Need to delete from Count 1, 2, and 3 (if ord_status indicates). Start by getting the LineItemNo. Then get the DW line for the LineItemNo
// dts 3/07/13 - now not deleting Count lines, but setting the Location to 'Allocated' on the counts as well
ll_LineItemNo = idw_SI.GetItemNumber(ll_SI_Row, "line_item_no")
ls_Status = idw_Main.GetItemString(1, "ord_status")

f_method_trace_special( gs_project, this.ClassName() , 'Process Release row, status is: '+ls_Status ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.

//'Release' from count 1 (we'll have to do that if the order is in count 1, 2, or 3)
if ls_status = '1' or ls_status = '2' or ls_status = '3' then 
//TAM 2017/04 - If the release is part of a rollup then find the lineitemnumber of the corresponding  CC row otherwise use the lineitemnumber being released
	If lsReleaseLines > '' or Not Isnull(lsReleaseLines) then
		ll_ResultRow = GetResultRowRollup(idw_result1, lsReleaseLines)
	Else	
		ll_ResultRow = GetResultRow(idw_result1, ll_LineItemNo)
	End If
	if ll_ResultRow > 0 then
		// 3/07 dts - idw_result1.DeleteRow(ll_ResultRow)
		//idw_result1.SetItem(ll_ResultRow, "l_code", "Allocated")		// LTK 20140731  Pandora #882
		idw_result1.SetItem(ll_ResultRow, "l_code", ls_allocated + ls_allocated_count)
	end if
end if
//'Release' from count 2 (we'll have to do that if the order is in count  2 or 3)
if ls_status = '2' or ls_status = '3' then 
//TAM 2017/04 - If the release is part of a rollup then find the lineitemnumber of the corresponding  CC row otherwise use the lineitemnumber being released
	If lsReleaseLines > '' or Not Isnull(lsReleaseLines) then
		ll_ResultRow = GetResultRowRollup(idw_result2, lsReleaseLines)
	Else	
		ll_ResultRow = GetResultRow(idw_result2, ll_LineItemNo)
	End If

	if ll_ResultRow > 0 then
		// 3/07 dts - idw_result2.DeleteRow(ll_ResultRow)
		//idw_result2.SetItem(ll_ResultRow, "l_code", "Allocated")		// LTK 20140731  Pandora #882
		idw_result2.SetItem(ll_ResultRow, "l_code", ls_allocated + ls_allocated_count)
	end if
end if
//'Release' from count 3 (we'll have to do that if the order is in count 3)
if ls_status = '3' then 
//TAM 2017/04 - If the release is part of a rollup then find the lineitemnumber of the corresponding  CC row otherwise use the lineitemnumber being released
	If lsReleaseLines > '' or Not Isnull(lsReleaseLines) then
		ll_ResultRow = GetResultRowRollup(idw_result3, lsReleaseLines)
	Else	
		ll_ResultRow = GetResultRow(idw_result3, ll_LineItemNo)
	End If

	if ll_ResultRow > 0 then
		// 3/07 dts - idw_result3.DeleteRow(ll_ResultRow)
		//idw_result3.SetItem(ll_ResultRow, "l_code", "Allocated")		// LTK 20140731  Pandora #882
		idw_result3.SetItem(ll_ResultRow, "l_code", ls_allocated + ls_allocated_count)
	end if
end if

ib_changed = true

f_method_trace_special( gs_project, this.ClassName() , 'End Release row ' ,isCCOrder, '','',isCCOrder) //18-Jun-2014 :Madhu- Added Method Trace calls.
end event

event constructor;call super::constructor;ib_filter = true
//DGM Make owner name invisible based in indicator
IF Upper(g.is_owner_ind) <> 'Y' THEN
	this.object.cf_owner_name.visible = 0
	this.object.cf_name_t.visible = 0
End IF

If g.is_coo_ind  <> 'Y' Then
	this.Modify("country_of_origin.visible=0")
End If

if gs_Project = 'PANDORA' then
	this.object.sequence.visible = 1
	this.object.sequence_t.visible = 1
	//this.object.remark.visible = 1
	//this.object.remark_t.visible = 1
end if
end event

event ue_resize;call super::ue_resize;
int iX,iY,iWidth,iHeight

iWidth = parent.width
iHeight = parent.height

this.width = ( iWidth - 10 )
this.height = ( iHeight - 125 )


end event

event itemchanged;call super::itemchanged;ib_changed = true

end event

type tabpage_result1 from userobject within tab_main
integer x = 18
integer y = 104
integer width = 4279
integer height = 1916
long backcolor = 79741120
string text = " Count Result 1 "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cbx_include_components1 cbx_include_components1
cb_insert cb_insert
em_limit_loc_print_1 em_limit_loc_print_1
st_1 st_1
cb_selectall1 cb_selectall1
cb_delete1 cb_delete1
cb_generate1 cb_generate1
cb_print1 cb_print1
dw_result1 dw_result1
end type

on tabpage_result1.create
this.cbx_include_components1=create cbx_include_components1
this.cb_insert=create cb_insert
this.em_limit_loc_print_1=create em_limit_loc_print_1
this.st_1=create st_1
this.cb_selectall1=create cb_selectall1
this.cb_delete1=create cb_delete1
this.cb_generate1=create cb_generate1
this.cb_print1=create cb_print1
this.dw_result1=create dw_result1
this.Control[]={this.cbx_include_components1,&
this.cb_insert,&
this.em_limit_loc_print_1,&
this.st_1,&
this.cb_selectall1,&
this.cb_delete1,&
this.cb_generate1,&
this.cb_print1,&
this.dw_result1}
end on

on tabpage_result1.destroy
destroy(this.cbx_include_components1)
destroy(this.cb_insert)
destroy(this.em_limit_loc_print_1)
destroy(this.st_1)
destroy(this.cb_selectall1)
destroy(this.cb_delete1)
destroy(this.cb_generate1)
destroy(this.cb_print1)
destroy(this.dw_result1)
end on

type cbx_include_components1 from checkbox within tabpage_result1
integer x = 3666
integer y = 32
integer width = 521
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Include Components"
end type

type cb_insert from commandbutton within tabpage_result1
boolean visible = false
integer x = 443
integer y = 20
integer width = 370
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert"
end type

event clicked;//14-MAY-2018 :Madhu S19286 - Up count from Non existing qty
idw_result1.event dynamic ue_insertrow()
end event

type em_limit_loc_print_1 from editmask within tabpage_result1
boolean visible = false
integer x = 2555
integer y = 16
integer width = 160
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

event constructor;
if left(gs_project,4) = 'NIKE' then
	this.visible = true
else
	this.visible = false
end if
end event

type st_1 from statictext within tabpage_result1
boolean visible = false
integer x = 1847
integer y = 36
integer width = 695
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Limit Loc Per Sheet (Print):"
boolean focusrectangle = false
end type

event constructor;
if left(gs_project,4) = 'NIKE' then
	this.visible = true
else
	this.visible = false
end if
end event

type cb_selectall1 from commandbutton within tabpage_result1
integer x = 3086
integer y = 20
integer width = 370
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;string selectall = 'Select All'
string deselectall = 'De-Select All'

IF Upper(gs_project) = 'CHINASIMS' THEN
	selectall = '????'
	deselectall = '????'
END IF	


if this.text = "Select All" then
	iw_window.event ue_selector( true )
	this.text = deselectall
else
	iw_window.event ue_selector( false )
	this.text =selectall
end if	


end event

event constructor;
g.of_check_label_button(this)
end event

type cb_delete1 from commandbutton within tabpage_result1
boolean visible = false
integer x = 855
integer y = 20
integer width = 370
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;ib_changed = True
//idw_result1.DeleteRow(dw_result1.il_curr)

idw_result1.event dynamic ue_DeleteRow()
	
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_generate1 from commandbutton within tabpage_result1
integer x = 14
integer y = 20
integer width = 370
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generate"
end type

event clicked;if doGenerateCountSheet( idw_result1, cbx_include_components1 ) < 0 then return 

end event

event constructor;g.of_check_label_button(this)
end event

type cb_print1 from commandbutton within tabpage_result1
integer x = 1422
integer y = 20
integer width = 370
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;doPrintCountSheets( )

end event

event constructor;
g.of_check_label_button(this)
end event

type dw_result1 from u_dw_ancestor within tabpage_result1
event ue_deleterow ( )
event ue_insertrow ( )
string tag = "microhelp"
integer x = 14
integer y = 140
integer width = 3790
integer height = 1740
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_cc_result1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_deleterow();// ue_deleteRow()

if getRow() <= 0 then return

// can't allow it if count dws have data
//if idw_result1.rowcount() > 0 then
//	beep(1)
//	return
//end if
if idw_result2.rowcount() > 0 then
	beep(1)
	return
end if
if idw_result3.rowcount() > 0 then
	beep(1)
	return
end if

//14-MAY-2018 :Madhu S19286 - Up count from Non existing qty
//Only delete Up_count_zero records else No.
If this.getItemString( getRow(), 'up_count_zero') = 'Y' Then
	if messagebox( is_title, "Are you sure you want to delete row " + string ( getRow() ) + "?",question!, yesno! ) <> 1 then return
else
	MessageBox(is_title, "You shouldn't delete System Generated Cycle Count Records", StopSign!)
	return
End If

deleteRow( getRow() )


ib_changed = true
end event

event ue_insertrow();//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
//Insert UpCount Zero Record

long insertRow, ll_row_count, ll_line_Item_no, ll_row, ll_temp_line_item_no
long	ll_Prev_Line_Item_No, ll_max_line_item_no, ll_sys_inv_line_item_no

//GailM 10/31/2018 Up count must have an owner established on main tab to complete insert
//If isNull(idw_main.GetItemNumber(1, 'owner_id')) or  idw_main.GetItemNumber(1, 'owner_id') = 0 Then
//	MessageBox(is_title, "When inserting a new row, an owner must be choosen from the main page.~n~r~n~r        Please choose an owner and return.")
//	tab_main.SelectTab(1) 
//	idw_main.SetFocus()
//	idw_Main.SetColumn('owner_id')
//	return
//End if

ib_changed = true

this.accepttext( )
this.setredraw( true)

ll_Prev_Line_Item_No =0
ll_max_line_item_no =0

//14-JUNE-2018 :Madhu DE4757 - Insert Rows, if and only if rows count > 0
If this.rowcount( ) = 0 Then
	MessageBox(is_title, "No Rows Generated. ~n~rPlease generate Rows before Adding New Records!")
	Return
End If
//Begin - Dinesh - DE18040- 22/10/2020 - Cycle count line item insert issue
string ls_sort
ls_sort='line_item_no'
idw_result1.setsort(ls_sort)
idw_result1.sort()
//End - Dinesh - DE18040- 22/10/2020 - Cycle count line item insert issue
//get Max(Line Item No) from System Inventory Records
ll_sys_inv_line_item_no = getSysInventoryMaxLineItemNo()


//Get max Line Item No from CC1
For ll_row = 1 to this.rowcount()
	ll_line_Item_no = this.getItemnumber( ll_row, 'line_item_no')
	
	If ll_Prev_Line_Item_No > ll_line_Item_no Then
		ll_temp_line_item_no = ll_Prev_Line_Item_No
	else
		ll_temp_line_item_no = ll_line_Item_no		
	end If
	
	ll_Prev_Line_Item_No = ll_line_Item_no
Next

//assign Max Line Item No
If ll_temp_line_item_no >  ll_sys_inv_line_item_no Then
	ll_max_line_item_no = ll_temp_line_item_no
else
	ll_max_line_item_no = ll_sys_inv_line_item_no
End If


ll_row_count = this.rowcount( )
insertRow = insertRow( ll_row_count +1 )
this.SetItem(insertRow,'cc_no', idw_main.getItemString(1,'cc_no'))
this.SetItem(insertRow,'line_item_no', ll_max_line_item_no+1)
this.SetItem(insertRow,'po_no', 'MAIN')
this.SetItem(insertRow,'sysinvmatch', 'N')
this.SetItem(insertRow,'up_count_zero', 'Y')
this.SetItem(insertRow,'protected',1)

IF this.GetItemString( insertRow, "sku") <>  'EMPTY' Then
	this.SetItem(insertRow,'owner_id', this.GetItemNumber(1,'owner_id'))	//Assign first owner in dropdown list
End IF




this.SetFocus()
this.SetRow(insertRow)
this.ScrolltoRow(insertRow)
end event

event getfocus;call super::getfocus;idw_current= this

end event

event itemchanged;long ll_rtn,ll_row,ll_owner_id, ll_count, ll_null
String ls_supp_code,ls_sku,ls_coo, ls_up_count_zero, ls_loc, ls_wh_code, ls_null
String lsCFOwnerName

SetNull(ls_null)


ls_wh_code = idw_main.getItemString( 1, 'wh_code')
		
ib_changed = True
Choose Case dwo.Name

	case 'sysinvmatch'
		if data = 'Y' then
		
			// LTK 20150508  Lot-able rollup
			//this.object.quantity[ row ] = 	idw_si.object.quantity[ getSysInvRow( Long( this.object.line_item_no[ row ] ) ) ] 
			this.object.quantity[ row ] = 	Round( wf_sum_si_quantity( wf_find_corresponding_si_rows( this, row, FALSE ) ), 5 )
		else
			this.object.quantity[ row ] = 	0
		end if
	
	Case 'sku'
		//Check duplicate sku's
		IF i_nwarehouse.of_item_sku(gs_project,data) > 0 THEN	
			//Check in drop down datawindows & insert row just to escape from retrieve
			IF idwc_count1_supp.Retrieve(gs_project,data) > 0 THEN
				ls_supp_code =idwc_count1_supp.Getitemstring(1,"supp_code")		
			END IF
	
			//Check if ddw is 0 then insert to avoid retrival argument pop up
			//IF ddw ret 1 row then assign the value to dupp_code
			IF idwc_count1_supp.RowCount() = 0 THEN 
				idwc_count1_supp.InsertRow( 0 )
			ELSEIF idwc_count1_supp.RowCount() >= 1 THEN
				This.object.supp_code[ row ] = ls_supp_code
				ls_sku = data

				IF idwc_count1_supp.RowCount() = 1 THEN Post f_setfocus(idw_result1,row,'l_code')
				
				//20-JUNE-2018 :Madhu S19286 - Up Count From Empty Location -START
				ls_up_count_zero = this.getItemString( row, 'up_count_zero')
				ls_loc = this.getItemString( row, 'l_code')
				
				If upper(ls_up_count_zero) ='Y' and len(ls_loc) > 0 Then
					If wf_is_up_count_location_empty(data, ls_loc) Then
						MessageBox(is_title, 'Location# '+ls_loc+ ' already has an Inventory!. ~n~rPlease use Empty Locations for Up Count from Non-Existing Inventory!', Stopsign!)
						this.setitem( row, 'sku', '')
						return 1
					end If
				End If
				
				//20-JUNE-2018 :Madhu S19286 - Up Count From Empty Location -END
				
				//August-2018 : MEA DE5934 -  Inbound order is not created or failed against Up\Down count for cycle count
				//If sku is empty, and they change it, need to set up_count_zero = 'Y' 
				//Treat like row that is inserted
	
				if  Upper(this.GetItemString(row, 'sku', Primary!, true)) = 'EMPTY' then
					this.SetItem(row,'po_no', 'MAIN')
					this.SetItem(row,'sysinvmatch', 'N')
					this.SetItem(row,'up_count_zero', 'Y')
					this.SetItem(row,'inventory_type', ls_null)
					
					this.object.protected[ row ] = 1
					this.SetItem(row, "owner_id", ll_null)
				end if
				
				goto pick_data  
			END IF
		Else			
			MessageBox(is_title, "Invalid SKU, please re-enter!",StopSign!)
			return 1
		END IF
	Case 'supp_code'
		ls_sku = this.Getitemstring(row,"sku")
		ls_supp_code = data
		goto pick_data
	
	Case 'l_code'
	
		//20-JUNE-2018 :Madhu S19286 - Up Count From Empty Location -START
		select count(*) into :ll_count from Location with(nolock)
		where wh_code= :ls_wh_code and l_code =:data
		using sqlca;
		
		If ll_count = 0 Then
			MessageBox(is_title, "Location# "+data+ " doesn't exist! Please provide valid Location", Stopsign!)
			this.setitem( row, 'l_code', '')
			return 1
		End If
		
		ls_up_count_zero = this.getItemString( row, 'up_count_zero')
		ls_sku = this.getItemString( row, 'sku')
		
		If upper(ls_up_count_zero) ='Y' and len(ls_sku) > 0 Then
			If wf_is_up_count_location_empty(ls_sku, data) Then
				MessageBox(is_title, 'Location# '+data+ ' already has an Inventory!. ~n~rPlease use Empty Locations for Up Count from Non-Existing Inventory!', Stopsign!)
				this.setitem( row, 'l_code', '')
				return 1
			end If
		End If
		//20-JUNE-2018 :Madhu S19286 - Up Count From Empty Location -END

END Choose			

return	

pick_data:
IF i_nwarehouse.of_item_master(gs_project,ls_sku,ls_supp_code) > 0 THEN
	//Get the values from datastore ids which is item master
	ll_row =i_nwarehouse.ids.Getrow()
	ll_owner_id=i_nwarehouse.ids.GetItemnumber(ll_row,"owner_id")
	ls_coo = i_nwarehouse.ids.GetItemString(ll_row,"Country_of_Origin_Default")
	//Set the values from datastore ids which is item master
//	this.object.owner_id[ row ]=ll_owner_id
	this.Setitem(row,"country_of_origin",ls_coo)
	//Get the owner name
	IF Upper(g.is_owner_ind) = 'Y' THEN
		lsCFOwnerName = g.of_get_owner_name(ll_owner_id)
//		If left(lsCFOwnerName,7) = 'PANDORA' Then
//			ll_owner_id = idw_main.getitemnumber(1, 'owner_id')
//			If isNull(ll_owner_id) or ll_owner_id = 0 Then
//				ll_owner_id = idwc_owner.GetItemNumber(1,'owner_id')
//				MessageBox("Owner Code Mismatch","Owner Code must be valid for this warehouse.  Please choose an Owner.")
//				return 1
//			Else
//				this.object.owner_id[ row ]=ll_owner_id
//			End If
//		End if 
	END IF
		

ELSE
	MessageBox(is_title, "Invalid Supplier, please re-enter!",StopSign!)
END IF

end event

event itemerror;Return 1
end event

event itemfocuschanged;call super::itemfocuschanged;String ls_sku 
 IF dwo.Name = 'supp_code' THEN
	 ls_sku =this.object.sku[ row ]
	 idwc_count1_supp.Retrieve(gs_project,ls_sku) 
END IF	 
 	 
end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event constructor;call super::constructor;ib_filter = true
/* dts 6/1/05
	added check of COO indicator to show/hide COO field
	(in conjunction with fix of where clause in d_cc_inventory to include coo)
*/
If g.is_coo_ind  <> 'Y' Then
	this.Modify("country_of_origin.visible=0")
End If


end event

type tabpage_result2 from userobject within tab_main
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 4279
integer height = 1916
long backcolor = 79741120
string text = " Count Result 2 "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cbx_include_components2 cbx_include_components2
em_limit_loc_print_2 em_limit_loc_print_2
st_2 st_2
st_c2_msg st_c2_msg
st_cc2_genereate_differences_only st_cc2_genereate_differences_only
cb_selectall2 cb_selectall2
cb_print2 cb_print2
cb_generate2 cb_generate2
cb_delete2 cb_delete2
dw_result2 dw_result2
end type

on tabpage_result2.create
this.cbx_include_components2=create cbx_include_components2
this.em_limit_loc_print_2=create em_limit_loc_print_2
this.st_2=create st_2
this.st_c2_msg=create st_c2_msg
this.st_cc2_genereate_differences_only=create st_cc2_genereate_differences_only
this.cb_selectall2=create cb_selectall2
this.cb_print2=create cb_print2
this.cb_generate2=create cb_generate2
this.cb_delete2=create cb_delete2
this.dw_result2=create dw_result2
this.Control[]={this.cbx_include_components2,&
this.em_limit_loc_print_2,&
this.st_2,&
this.st_c2_msg,&
this.st_cc2_genereate_differences_only,&
this.cb_selectall2,&
this.cb_print2,&
this.cb_generate2,&
this.cb_delete2,&
this.dw_result2}
end on

on tabpage_result2.destroy
destroy(this.cbx_include_components2)
destroy(this.em_limit_loc_print_2)
destroy(this.st_2)
destroy(this.st_c2_msg)
destroy(this.st_cc2_genereate_differences_only)
destroy(this.cb_selectall2)
destroy(this.cb_print2)
destroy(this.cb_generate2)
destroy(this.cb_delete2)
destroy(this.dw_result2)
end on

type cbx_include_components2 from checkbox within tabpage_result2
integer x = 3575
integer y = 28
integer width = 512
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Include Components"
end type

type em_limit_loc_print_2 from editmask within tabpage_result2
boolean visible = false
integer x = 1947
integer y = 12
integer width = 160
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

event constructor;

if left(gs_project,4) = 'NIKE' then
	this.visible = true
else
	this.visible = false
end if
end event

type st_2 from statictext within tabpage_result2
boolean visible = false
integer x = 1248
integer y = 36
integer width = 699
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Limit Loc Per Sheet (Print):"
boolean focusrectangle = false
end type

event constructor;

if left(gs_project,4) = 'NIKE' then
	this.visible = true
else
	this.visible = false
end if
end event

type st_c2_msg from statictext within tabpage_result2
integer x = 3378
integer y = 32
integer width = 178
integer height = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Off"
boolean focusrectangle = false
end type

type st_cc2_genereate_differences_only from statictext within tabpage_result2
integer x = 2679
integer y = 36
integer width = 695
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Generate Differances Only:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type cb_selectall2 from commandbutton within tabpage_result2
integer x = 2290
integer y = 20
integer width = 370
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;string selectall = 'Select All'
string deselectall = 'De-Select All'


IF Upper(gs_project) = 'CHINASIMS' THEN
	selectall = '????'
	deselectall = '????'
END IF	


if this.text = "Select All" then
	iw_window.event ue_selector( true )
	this.text = deselectall
else
	iw_window.event ue_selector( false )
	this.text = selectall
end if	
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_print2 from commandbutton within tabpage_result2
integer x = 827
integer y = 20
integer width = 370
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;doPrintCountSheets(  )

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_generate2 from commandbutton within tabpage_result2
integer x = 18
integer y = 20
integer width = 370
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generate"
end type

event clicked;if doGenerateCountSheet( idw_result2, cbx_include_components2 ) < 0 then return 

end event

event constructor;g.of_check_label_button(this)
end event

type cb_delete2 from commandbutton within tabpage_result2
boolean visible = false
integer x = 421
integer y = 20
integer width = 370
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;ib_changed = True
//idw_result2.DeleteRow(dw_result2.il_curr)

idw_result2.event dynamic ue_DeleteRow()

end event

event constructor;
g.of_check_label_button(this)
end event

type dw_result2 from u_dw_ancestor within tabpage_result2
event ue_deleterow ( )
integer y = 128
integer width = 3822
integer height = 1756
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cc_result2"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_deleterow();// ue_deleteRow()

if getRow() <= 0 then return

// can't allow it if count dws have data
//if idw_result1.rowcount() > 0 then
//	beep(1)
//	return
//end if
//if idw_result2.rowcount() > 0 then
//	beep(1)
//	return
//end if
if idw_result3.rowcount() > 0 then
	beep(1)
	return
end if
if messagebox( is_title, "Are you sure you want to delete row " + string ( getRow() ) + "?",question!, yesno! ) <> 1 then return

deleteRow( getRow() )


ib_changed = true


end event

event getfocus;call super::getfocus; idw_current= this
end event

event itemchanged;//ib_changed = True
//Choose Case dwo.Name
//	Case 'sku'
//		//Check duplicate sku's
//		IF  i_nwarehouse.of_item_master(gs_project,data,is_title) = -1 then	return 1		
//END CHOOSE


long ll_rtn,ll_row,ll_owner_id
String ls_supp_code,ls_sku,ls_coo

ib_changed = True
Choose Case dwo.Name
		
	case 'sysinvmatch'
		if data = 'Y' then
			// LTK 20150508  Lot-able rollup
			//this.object.quantity[ row ] = 	idw_si.object.quantity[ getSysInvRow( Long( this.object.line_item_no[ row ] ) ) ] 
			this.object.quantity[ row ] = 	Round( wf_sum_si_quantity( wf_find_corresponding_si_rows( this, row, FALSE ) ), 5 )

		else
			this.object.quantity[ row ] = 	0
		end if
		
	Case 'sku'
		//Check duplicate sku's
		IF i_nwarehouse.of_item_sku(gs_project,data) > 0 THEN	
		//Check in drop down datawindows & insert row just to escape from retrieve
		IF idwc_count2_supp.Retrieve(gs_project,data) > 0 THEN
			ls_supp_code =idwc_count2_supp.Getitemstring(1,"supp_code")		
		END IF
		//Check if ddw is 0 then insert to avoid retrival argument pop up
		//IF ddw ret 1 row then assign the value to dupp_code
   	IF idwc_count2_supp.RowCount() = 0 THEN 
     		 idwc_count2_supp.InsertRow( 0 )
		ELSEIF idwc_count2_supp.RowCount() >=  1 THEN
			  	This.object.supp_code[ row ] = ls_supp_code
				ls_sku = data
				IF idwc_count2_supp.RowCount() = 1 THEN Post f_setfocus(idw_result2,row,'l_code')
			   goto pick_data  
   	END IF
   Else			
		MessageBox(is_title, "Invalid SKU, please re-enter!",StopSign!)
		return 1
	END IF
Case 'supp_code'
	 ls_sku = this.Getitemstring(row,"sku")
	 ls_supp_code = data
	 goto pick_data
END Choose			
return	
	
pick_data:
IF i_nwarehouse.of_item_master(gs_project,ls_sku,ls_supp_code) > 0 THEN
				//Get the values from datastore ids which is item master
				ll_row =i_nwarehouse.ids.Getrow()
				ll_owner_id=i_nwarehouse.ids.GetItemnumber(ll_row,"owner_id")
				ls_coo = i_nwarehouse.ids.GetItemString(ll_row,"Country_of_Origin_Default")
				//Set the values from datastore ids which is item master
				this.object.owner_id[ row ]=ll_owner_id
				this.Setitem(row,"country_of_origin",ls_coo)
				//Get the owner name
//				IF Upper(g.is_owner_ind) = 'Y' THEN
//					this.object.cf_owner_name[ row ] = g.of_get_owner_name(ll_owner_id)
//				END IF	
END IF

end event

event itemerror;return 1

end event

event itemfocuschanged;String ls_sku 
 IF dwo.Name = 'supp_code' THEN
	 ls_sku =this.object.sku[ row ]
	 idwc_count2_supp.Retrieve(gs_project,ls_sku) 
END IF	 
end event

event constructor;call super::constructor;ib_filter = true
/* dts 6/1/05
	added check of COO indicator to show/hide COO field
	(in conjunction with fix of where clause in d_cc_inventory to include coo)
*/
If g.is_coo_ind  <> 'Y' Then
	this.Modify("country_of_origin.visible=0")
End If

end event

type tabpage_result3 from userobject within tab_main
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 4279
integer height = 1916
long backcolor = 79741120
string text = " Count Result 3 "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cbx_include_components3 cbx_include_components3
em_limit_loc_print_3 em_limit_loc_print_3
st_3 st_3
st_c3_msg st_c3_msg
st_cc3_genereate_differences_only st_cc3_genereate_differences_only
cb_selectall3 cb_selectall3
cb_generate3 cb_generate3
cb_print3 cb_print3
cb_delete3 cb_delete3
dw_result3 dw_result3
end type

on tabpage_result3.create
this.cbx_include_components3=create cbx_include_components3
this.em_limit_loc_print_3=create em_limit_loc_print_3
this.st_3=create st_3
this.st_c3_msg=create st_c3_msg
this.st_cc3_genereate_differences_only=create st_cc3_genereate_differences_only
this.cb_selectall3=create cb_selectall3
this.cb_generate3=create cb_generate3
this.cb_print3=create cb_print3
this.cb_delete3=create cb_delete3
this.dw_result3=create dw_result3
this.Control[]={this.cbx_include_components3,&
this.em_limit_loc_print_3,&
this.st_3,&
this.st_c3_msg,&
this.st_cc3_genereate_differences_only,&
this.cb_selectall3,&
this.cb_generate3,&
this.cb_print3,&
this.cb_delete3,&
this.dw_result3}
end on

on tabpage_result3.destroy
destroy(this.cbx_include_components3)
destroy(this.em_limit_loc_print_3)
destroy(this.st_3)
destroy(this.st_c3_msg)
destroy(this.st_cc3_genereate_differences_only)
destroy(this.cb_selectall3)
destroy(this.cb_generate3)
destroy(this.cb_print3)
destroy(this.cb_delete3)
destroy(this.dw_result3)
end on

type cbx_include_components3 from checkbox within tabpage_result3
integer x = 3730
integer y = 36
integer width = 512
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Include Components"
end type

type em_limit_loc_print_3 from editmask within tabpage_result3
boolean visible = false
integer x = 1947
integer y = 16
integer width = 160
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

event constructor;

if left(gs_project,4) = 'NIKE' then
	this.visible = true
else
	this.visible = false
end if
end event

type st_3 from statictext within tabpage_result3
boolean visible = false
integer x = 1248
integer y = 44
integer width = 704
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Limit Loc Per Sheet (Print):"
boolean focusrectangle = false
end type

event constructor;

if left(gs_project,4) = 'NIKE' then
	this.visible = true
else
	this.visible = false
end if
end event

type st_c3_msg from statictext within tabpage_result3
integer x = 3301
integer y = 32
integer width = 178
integer height = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Off"
boolean focusrectangle = false
end type

type st_cc3_genereate_differences_only from statictext within tabpage_result3
integer x = 2601
integer y = 36
integer width = 695
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Generate Differances Only:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type cb_selectall3 from commandbutton within tabpage_result3
integer x = 2181
integer y = 20
integer width = 370
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;
string selectall = 'Select All'
string deselectall = 'De-Select All'


IF Upper(gs_project) = 'CHINASIMS' THEN
	selectall = '????'
	deselectall = '????'
END IF	


if this.text = "Select All" then
	iw_window.event ue_selector( true )
	this.text =deselectall
else
	iw_window.event ue_selector( false )
	this.text =selectall
end if	
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_generate3 from commandbutton within tabpage_result3
integer x = 18
integer y = 20
integer width = 370
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generate"
end type

event clicked;long ll_row
if doGenerateCountSheet( idw_result3, cbx_include_components3 ) < 0 then 
	return 
else
	//26-APR-2018 :Madhu S18502 - FootPrint Cycle Count
	//change PoNo2/ Container Text color to white.
	if idw_result3.rowcount( ) > 0 and ib_Foot_Print_SKU then
		For ll_row = 1 to idw_result3.rowcount( )
			idw_result3.setItem( ll_row, 'matched', 'N')
		Next
	end if
	return
end if

end event

event constructor;g.of_check_label_button(this)
end event

type cb_print3 from commandbutton within tabpage_result3
integer x = 832
integer y = 20
integer width = 370
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;doPrintCountSheets(  )


end event

event constructor;
g.of_check_label_button(this)
end event

type cb_delete3 from commandbutton within tabpage_result3
boolean visible = false
integer x = 434
integer y = 20
integer width = 370
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;ib_changed = True
//idw_result3.DeleteRow(dw_result3.il_curr)

idw_result3.event dynamic ue_DeleteRow()

end event

event constructor;
g.of_check_label_button(this)
end event

type dw_result3 from u_dw_ancestor within tabpage_result3
event ue_deleterow ( )
integer y = 128
integer width = 3831
integer height = 1772
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_cc_result3"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_deleterow();// ue_deleteRow()

if getRow() <= 0 then return

// can't allow it if count dws have data
//if idw_result1.rowcount() > 0 then
//	beep(1)
//	return
//end if
//if idw_result2.rowcount() > 0 then
//	beep(1)
//	return
//end if
//if idw_result3.rowcount() > 0 then
//	beep(1)
//	return
//end if
if messagebox( is_title, "Are you sure you want to delete row " + string ( getRow() ) + "?",question!, yesno! ) <> 1 then return

deleteRow( getRow() )


ib_changed = true


end event

event itemchanged;//ib_changed = True
//ib_changed = True
//Choose Case dwo.Name
//	Case 'sku'
//		//Check duplicate sku's
//		IF  i_nwarehouse.of_item_master(gs_project,data,is_title) = -1 then	return 1		
//END CHOOSE

long ll_rtn,ll_row,ll_owner_id
String ls_supp_code,ls_sku,ls_coo

ib_changed = True
Choose Case dwo.Name
	case 'sysinvmatch'
		
		if data = 'Y' then

			// LTK 20150508  Lot-able rollup
			//this.object.quantity[ row ] = 	idw_si.object.quantity[ getSysInvRow( Long( this.object.line_item_no[ row ] ) ) ] 
			this.object.quantity[ row ] = 	Round( wf_sum_si_quantity( wf_find_corresponding_si_rows( this, row, FALSE ) ), 5 )

		else
			this.object.quantity[ row ] = 	0
		end if
	
	Case 'sku'
		//Check duplicate sku's
		IF i_nwarehouse.of_item_sku(gs_project,data) > 0 THEN	
		//Check in drop down datawindows & insert row just to escape from retrieve
		IF idwc_count3_supp.Retrieve(gs_project,data) > 0 THEN
			ls_supp_code =idwc_count3_supp.Getitemstring(1,"supp_code")		
		END IF
		//Check if ddw is 0 then insert to avoid retrival argument pop up
		//IF ddw ret 1 row then assign the value to dupp_code
   	IF idwc_count3_supp.RowCount() = 0 THEN 
     		 idwc_count3_supp.InsertRow( 0 )
		ELSEIF idwc_count3_supp.RowCount() >=  1 THEN
			  	This.object.supp_code[ row ] = ls_supp_code
				ls_sku = data
				IF idwc_count3_supp.RowCount() = 1 THEN Post f_setfocus(idw_result3,row,'l_code')
			   goto pick_data  
   	END IF
   Else			
		MessageBox(is_title, "Invalid SKU, please re-enter!",StopSign!)
		return 1
	END IF
Case 'supp_code'
	 ls_sku = this.Getitemstring(row,"sku")
	 ls_supp_code = data
	 goto pick_data
END Choose			
return	
	
pick_data:
IF i_nwarehouse.of_item_master(gs_project,ls_sku,ls_supp_code) > 0 THEN
				//Get the values from datastore ids which is item master
				ll_row =i_nwarehouse.ids.Getrow()
				ll_owner_id=i_nwarehouse.ids.GetItemnumber(ll_row,"owner_id")
				ls_coo = i_nwarehouse.ids.GetItemString(ll_row,"Country_of_Origin_Default")
				//Set the values from datastore ids which is item master
				this.object.owner_id[ row ]=ll_owner_id
				this.Setitem(row,"country_of_origin",ls_coo)
				//Get the owner name
//				IF Upper(g.is_owner_ind) = 'Y' THEN
//					this.object.cf_owner_name[ row ] = g.of_get_owner_name(ll_owner_id)
//				END IF	
END IF

end event

event getfocus;call super::getfocus; idw_current= this
end event

event itemfocuschanged;String ls_sku 
 IF dwo.Name = 'supp_code' THEN
	 ls_sku =this.object.sku[ row ]
	 idwc_count3_supp.Retrieve(gs_project,ls_sku) 
END IF	 
 	 
end event

event itemerror;Return 1
end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event constructor;call super::constructor;ib_filter = true
/* dts 6/1/05
	added check of COO indicator to show/hide COO field
	(in conjunction with fix of where clause in d_cc_inventory to include coo)
*/
If g.is_coo_ind  <> 'Y' Then
	this.Modify("country_of_origin.visible=0")
End If

end event

type tabpage_mobile from userobject within tab_main
integer x = 18
integer y = 104
integer width = 4279
integer height = 1916
long backcolor = 79741120
string text = "Mobile"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_delete_location cb_delete_location
dw_mobile dw_mobile
end type

on tabpage_mobile.create
this.cb_delete_location=create cb_delete_location
this.dw_mobile=create dw_mobile
this.Control[]={this.cb_delete_location,&
this.dw_mobile}
end on

on tabpage_mobile.destroy
destroy(this.cb_delete_location)
destroy(this.dw_mobile)
end on

type cb_delete_location from commandbutton within tabpage_mobile
integer x = 50
integer y = 12
integer width = 425
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete checked"
end type

event clicked;
idw_mobile.TriggerEvent('ue_delete_checked')
end event

type dw_mobile from u_dw_ancestor within tabpage_mobile
event ue_clear ( )
event ue_build_location_list ( )
event ue_delete_checked ( )
integer x = 14
integer y = 92
integer width = 3232
integer height = 1648
integer taborder = 20
string dataobject = "d_cc_location"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_clear();
//Clear the existing location records if changing the criteria

Long	llRowCount, llRowPos


lLRowCount = This.RowCount()
If llRowCount > 0 Then
	For llRowPos = llRowCount to 1 Step - 1
		This.DeleteRow(llRowPos)
	next
End If
end event

event ue_build_location_list();
//Build the location List 

Datastore	ldsLocations
String	lsStart, lsEnd, sql_syntax, Errors, lsWarehouse, lsCCNO, lsFindStr
Long	llrangeCount, llRowCount, llRowPos, llNewRow
int	i

lsCCNO = idw_Main.getItemString(1,'cc_no')
lsWarehouse = idw_Main.getItemString(1,'wh_code')
lsStart = idw_Main.getItemString(1,'range_start')
lsEnd = idw_Main.getItemString(1,'range_end')
llRangeCount = idw_Main.GetItemNumber(1,'range_cnt')

//No need to build list if not mobile enabled
lsFindStr = "wh_code = '" + lsWarehouse + "'"
i = g.ids_project_warehouse.Find(lsFindStr,1,g.ids_project_warehouse.rowcount())
If i > 0 Then
	If g.ids_project_warehouse.GetItemString(i, "Mobile_Enabled_Ind") <>'Y' Then
		return
	End If
Else
	return
End If
		


This.TriggerEvent('ue_clear')

If lsWarehouse = "" or lsStart = "" or lsEnd = "" or llrangeCount = 0 Then REturn


Choose Case Upper(idw_Main.getItemString(1,'Ord_type'))
		
	case "L" /* Location*/
		
	sql_syntax = "Select l_code from Location with (NoLock) where wh_code = '" + lsWarehouse + "' "
	sql_syntax += " and l_code between '" + lsStart + "' and '" + lsEnd + "' "
	sql_syntax += " Order by l_code "
	
	ldsLocations = Create Datastore
	ldsLocations.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
	ldsLocations.SetTransobject(sqlca)
		
	llRowCount = ldsLocations.Retrieve()
	IF llRowCount <=0 THEN 
		MessageBox(is_title, "No Location records Generated!")
		Return 
	END IF
		
	For llRowPos = 1 to llRowCount
		llNewRow = This.InsertRow(0)
		This.SetItem(llNewRow,'cc_no',lsCCNO)
		This.SetItem(llNewRow,'l_code', ldsLocations.GetITemString(llRowPos,'l_code'))
		This.SetItem(llNewRow,'mobile_status_ind','N')
		This.SetItem(llNewRow,'current_count',1)
		
	Next
	
End Choose
end event

event ue_delete_checked();
//Delete any checked rows

long	llFindRow

llFindRow = This.Find("c_select= 'Y'",1,this.RowCount())
If llFindRow > 0 Then
	If Messagebox('Delete Rows','Are you sure you want to delete the checked rows?',Question!,YesNo!,1) = 2 Then REturn
End If

Do While llFindRow > 0
	This.DeleteRow(llFindRow)
	llFindRow = This.Find("c_select= 'Y'",1,this.RowCount())
Loop
end event

type tabpage_system_generated from userobject within tab_main
integer x = 18
integer y = 104
integer width = 4279
integer height = 1916
long backcolor = 79741120
string text = "System_Generated"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_system_generated dw_system_generated
end type

on tabpage_system_generated.create
this.dw_system_generated=create dw_system_generated
this.Control[]={this.dw_system_generated}
end on

on tabpage_system_generated.destroy
destroy(this.dw_system_generated)
end on

type dw_system_generated from u_dw_ancestor within tabpage_system_generated
event ue_clear ( )
event ue_build_location_list ( )
event ue_delete_checked ( )
integer y = 12
integer width = 2062
integer height = 1836
integer taborder = 30
string dataobject = "d_cc_system_generated"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_clear();
//Clear the existing location records if changing the criteria

Long	llRowCount, llRowPos


lLRowCount = This.RowCount()
If llRowCount > 0 Then
	For llRowPos = llRowCount to 1 Step - 1
		This.DeleteRow(llRowPos)
	next
End If
end event

event ue_build_location_list();
//Build the location List 

Datastore	ldsLocations
String	lsStart, lsEnd, sql_syntax, Errors, lsWarehouse, lsCCNO, lsFindStr
Long	llrangeCount, llRowCount, llRowPos, llNewRow
int	i

lsCCNO = idw_Main.getItemString(1,'cc_no')
lsWarehouse = idw_Main.getItemString(1,'wh_code')
lsStart = idw_Main.getItemString(1,'range_start')
lsEnd = idw_Main.getItemString(1,'range_end')
llRangeCount = idw_Main.GetItemNumber(1,'range_cnt')

//No need to build list if not mobile enabled
lsFindStr = "wh_code = '" + lsWarehouse + "'"
i = g.ids_project_warehouse.Find(lsFindStr,1,g.ids_project_warehouse.rowcount())
If i > 0 Then
	If g.ids_project_warehouse.GetItemString(i, "Mobile_Enabled_Ind") <>'Y' Then
		return
	End If
Else
	return
End If
		


This.TriggerEvent('ue_clear')

If lsWarehouse = "" or lsStart = "" or lsEnd = "" or llrangeCount = 0 Then REturn


Choose Case Upper(idw_Main.getItemString(1,'Ord_type'))
		
	case "L" /* Location*/
		
	sql_syntax = "Select l_code from Location with (NoLock) where wh_code = '" + lsWarehouse + "' "
	sql_syntax += " and l_code between '" + lsStart + "' and '" + lsEnd + "' "
	sql_syntax += " Order by l_code "
	
	ldsLocations = Create Datastore
	ldsLocations.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
	ldsLocations.SetTransobject(sqlca)
		
	llRowCount = ldsLocations.Retrieve()
	IF llRowCount <=0 THEN 
		MessageBox(is_title, "No Location records Generated!")
		Return 
	END IF
		
	For llRowPos = 1 to llRowCount
		llNewRow = This.InsertRow(0)
		This.SetItem(llNewRow,'cc_no',lsCCNO)
		This.SetItem(llNewRow,'l_code', ldsLocations.GetITemString(llRowPos,'l_code'))
		This.SetItem(llNewRow,'mobile_status_ind','N')
		This.SetItem(llNewRow,'current_count',1)
		
	Next
	
End Choose
end event

type tabpage_serial_numbers from userobject within tab_main
event ue_import ( )
integer x = 18
integer y = 104
integer width = 4279
integer height = 1916
long backcolor = 79741120
string text = "Serial No"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_serial_numbers dw_serial_numbers
end type

event ue_import();string is_filename, is_fullname
long i, rows
string lsCC_No

If ib_changed Then
	messagebox(is_title,'Please save changes before importing Serial Numbers!')
	return
End If


//dw_serial_numbers.Reset()

GetFileOpenName("Select File", is_filename, is_fullname, "txt", "Text Files (*.txt*), *.txt*")

If FileExists(is_filename) Then

	SetPointer(hourglass!)

	rows = idw_serial_numbers.Rowcount()
	If rows > 0 Then
		Choose Case MessageBox(is_title, "Delete existing records?", Question!, YesNoCancel!,3)
			Case 3
				Return
			Case 1
				idw_serial_numbers.Setredraw(False)
				For i = rows to 1 Step -1
					idw_serial_numbers.DeleteRow( i )
				Next
				idw_serial_numbers.Setredraw(True)
		End Choose
	End If

	idw_serial_numbers.ImportFile(is_filename)

	lsCC_No = idw_main.getItemString(1,'cc_no')

	FOR i =  idw_serial_numbers.RowCount() to 1 step -1
		
		idw_serial_numbers.SetItem(i,'cc_no', lsCC_No)
		
	NEXT

	idw_serial_numbers.SetRedraw(True)
	ib_changed = true
	MessageBox ("Import Success", "Complete upload")

End If


end event

on tabpage_serial_numbers.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_serial_numbers=create dw_serial_numbers
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.dw_serial_numbers}
end on

on tabpage_serial_numbers.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_serial_numbers)
end on

type cb_3 from commandbutton within tabpage_serial_numbers
integer x = 27
integer y = 16
integer width = 411
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Import..."
end type

event clicked;string is_filename, is_fullname
long i, rows
string lsCC_No, ls_errtext, ls_serial

If ib_changed Then
	messagebox(is_title,'Please save changes before importing Serial Numbers!')
	return
End If


//dw_serial_numbers.Reset()
lsCC_No = idw_main.getItemString(1,'cc_no')

GetFileOpenName("Select File", is_filename, is_fullname, "txt", "Text Files (*.txt*), *.txt*")

If FileExists(is_filename) Then

	SetPointer(hourglass!)

	rows = idw_serial_numbers.Rowcount()
	If rows > 0 Then
		Choose Case MessageBox(is_title, "Delete existing records? "+&
				"~n Yes - Delete Existing Serial No's and Re-Import All ~n No - Only Import Serial No's. "+&
				"~n Cancel - Don't do Anything ", +&
				Question!, YesNoCancel!,3)
			Case 3
				Return
			Case 1

				//Need to delete any existing serial numbers first
				Execute Immediate "Begin Transaction" using SQLCA; /*PCONKL - Auto Commit Turned on to eliminate DB locks*/
	
				//Delete any CC_Serials entries That currently Exist
				delete from CC_Serial_Numbers 
				where CC_NO =  :lsCC_No
				Using SQLCA;			
					
				If sqlca.sqlcode <> 0 Then
					ls_ErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
					Execute Immediate "Rollback" using SQLCA;
					Messagebox(is_Title, "Unable to Delete the existing serial numbers!~r~r" + ls_ErrText)
					Return -1
				End If
				
				Execute Immediate "Commit" Using Sqlca;
				If sqlca.sqlcode <> 0 Then
					MessageBox(is_title,"Unable to Delete the existing serial numbers!~r~r")
					Return -1
				End If
				
				dw_serial_numbers.Reset()
				idw_serial_numbers.Setredraw(False)
					
				For i = rows to 1 Step -1
					idw_serial_numbers.DeleteRow( i )
				Next
				idw_serial_numbers.Setredraw(True)
		End Choose
	End If

	idw_serial_numbers.ImportFile(is_filename)
	
	FOR i =  idw_serial_numbers.RowCount() to 1 step -1
		idw_serial_numbers.SetItem(i,'cc_no', lsCC_No)
		//1/13/2020 - MIKEA - Fixed Serials to be only upper as per Roy.
		ls_serial = Upper(idw_serial_numbers.GetItemString(i,'serial_no	'))
		idw_serial_numbers.SetItem(i,'serial_no', ls_serial)
			
	NEXT

	dw_serial_numbers.SetRedraw(True)
	ib_changed = true
	MessageBox ("Import Success", "Complete upload")

End If




end event

type cb_2 from commandbutton within tabpage_serial_numbers
integer x = 997
integer y = 20
integer width = 370
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count
long ll_row
ib_changed = True

IF MessageBox( is_title, "Are you sure you want to delete rows?",question!, yesno! ) = 1 Then 
	If ib_Foot_Print_SKU Then
		idw_serial_numbers.event dynamic ue_delete_container_row()
	else
		idw_serial_numbers.event dynamic ue_deleterow()	
	End If
ELSE
	For ll_row = 1 to idw_serial_numbers.rowcount( )
		If idw_serial_numbers.getItemString( ll_row, 'rowfocusindicator') ='Y' Then idw_serial_numbers.setItem( ll_row, 'rowfocusindicator', 'N')
	Next
Return
END IF
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_1 from commandbutton within tabpage_serial_numbers
integer x = 526
integer y = 20
integer width = 370
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insert"
end type

event clicked;idw_serial_numbers.event dynamic ue_insertRow()

end event

event constructor;
g.of_check_label_button(this)
end event

type dw_serial_numbers from u_dw_ancestor within tabpage_serial_numbers
event ue_clear ( )
event ue_build_location_list ( )
event ue_delete_checked ( )
event ue_deleterow ( )
event ue_insertrow ( )
event ue_delete_container_row ( )
integer y = 124
integer width = 2062
integer height = 1836
integer taborder = 40
string dataobject = "d_cc_serial_numbers"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_clear();
//Clear the existing location records if changing the criteria

Long	llRowCount, llRowPos


lLRowCount = This.RowCount()
If llRowCount > 0 Then
	For llRowPos = llRowCount to 1 Step - 1
		This.DeleteRow(llRowPos)
	next
End If
end event

event ue_build_location_list();
//Build the location List 

Datastore	ldsLocations
String	lsStart, lsEnd, sql_syntax, Errors, lsWarehouse, lsCCNO, lsFindStr
Long	llrangeCount, llRowCount, llRowPos, llNewRow
int	i

lsCCNO = idw_Main.getItemString(1,'cc_no')
lsWarehouse = idw_Main.getItemString(1,'wh_code')
lsStart = idw_Main.getItemString(1,'range_start')
lsEnd = idw_Main.getItemString(1,'range_end')
llRangeCount = idw_Main.GetItemNumber(1,'range_cnt')

//No need to build list if not mobile enabled
lsFindStr = "wh_code = '" + lsWarehouse + "'"
i = g.ids_project_warehouse.Find(lsFindStr,1,g.ids_project_warehouse.rowcount())
If i > 0 Then
	If g.ids_project_warehouse.GetItemString(i, "Mobile_Enabled_Ind") <>'Y' Then
		return
	End If
Else
	return
End If
		


This.TriggerEvent('ue_clear')

If lsWarehouse = "" or lsStart = "" or lsEnd = "" or llrangeCount = 0 Then REturn


Choose Case Upper(idw_Main.getItemString(1,'Ord_type'))
		
	case "L" /* Location*/
		
	sql_syntax = "Select l_code from Location with (NoLock) where wh_code = '" + lsWarehouse + "' "
	sql_syntax += " and l_code between '" + lsStart + "' and '" + lsEnd + "' "
	sql_syntax += " Order by l_code "
	
	ldsLocations = Create Datastore
	ldsLocations.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
	ldsLocations.SetTransobject(sqlca)
		
	llRowCount = ldsLocations.Retrieve()
	IF llRowCount <=0 THEN 
		MessageBox(is_title, "No Location records Generated!")
		Return 
	END IF
		
	For llRowPos = 1 to llRowCount
		llNewRow = This.InsertRow(0)
		This.SetItem(llNewRow,'cc_no',lsCCNO)
		This.SetItem(llNewRow,'l_code', ldsLocations.GetITemString(llRowPos,'l_code'))
		This.SetItem(llNewRow,'mobile_status_ind','N')
		This.SetItem(llNewRow,'current_count',1)
		
	Next
	
End Choose
end event

event ue_deleterow();// ue_deleteRow()

if getRow() <= 0 then return

//TAM - 2018/03 - S16310 - Add funtionality to delete multiple rows
//if messagebox( is_title, "Are you sure you want to delete row " + string ( getRow() ) + "?",question!, yesno! ) <> 1 then return

integer i, liCnt 
liCnt = this.RowCount()
For i = 1 to liCnt
	if this.getItemString(i,"rowfocusindicator") = 'Y' then 
		this.deleteRow(i)
		liCnt = liCnt - 1
		i = i - 1
	end if
next

ib_changed = true

end event

event ue_insertrow();// ue_insertRow()
long insertRow, ll_row_count

ib_changed = true

ll_row_count = this.rowcount( )
insertRow = insertRow( ll_row_count +1 )
this.SetItem(insertRow,'cc_no',idw_main.getItemString(1,'cc_no'))


//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process

If idw_main.GetItemString(1, "ord_type") = "F" Then /*by System Generated - Serial Reconciliation*/
	this.SetTabOrder("l_code", 10)
	this.SetTabOrder("sku", 20)
	this.SetTabOrder("serial_no", 30)
	this.SetItem(insertRow,'sku',tab_main.tabpage_system_generated.dw_system_generated.GetItemString( 1, "count_value"))
	this.SetItem(insertRow,'l_code',idw_main.GetItemString( 1, "range_start"))
	this.SetColumn("serial_no")
	
End If

this.SetFocus()
this.SetRow(insertRow)
this.ScrolltoRow(insertRow)
end event

event ue_delete_container_row();//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count
//If SKU is Foot Print, (a) DELETE any Serial No, respective container Id QTY should be updated (decremented) on Container Tab.

string ls_sku, ls_loc, ls_container_Id, lsFind
long  ll_Row, ll_Row_count, llFindRow, ll_container_qty, llFindCountRow, ll_count_qty

ib_changed = true
if getRow() <= 0 then return

ll_Row_count = this.RowCount()
FOR ll_Row = 1 to ll_Row_count
	IF this.getItemString(ll_Row,"rowfocusindicator") = 'Y' THEN
		ls_sku = this.getItemString( ll_Row, 'sku')
		ls_loc = this.getItemString( ll_Row, 'l_code')
		ls_container_Id = this.getItemString( ll_Row, 'container_Id')
		
		//find appropriate record on Container Tab
		lsFind ="sku ='"+ls_sku+"' and l_code ='"+ls_loc+"' and container_Id ='"+ls_container_Id+"'"
		llFindRow = idw_cc_container.find( lsFind, 1, idw_cc_container.rowcount())
		
		IF llFindRow > 0 Then
			ll_container_qty = idw_cc_container.getItemNumber( llFindRow, 'quantity')
			IF ll_container_qty > 0 Then idw_cc_container.setItem( llFindRow, 'quantity', ll_container_qty -1) //decrement by 1
		End IF
		
		//find appropriate record on Count 3 Tab
		llFindCountRow = idw_result3.find( lsFind, 1, idw_result3.rowcount())
		IF llFindCountRow > 0 Then
			ll_count_qty = idw_result3.getItemNumber(llFindCountRow, 'quantity')
			IF ll_count_qty > 0 Then idw_result3.setItem(llFindCountRow, 'quantity', ll_count_qty -1) //decrement by 1
		End IF
		
		//delete serial no row
		this.deleteRow(ll_Row)
		ll_Row_count = ll_Row_count - 1
		ll_Row = ll_Row - 1
	END IF
NEXT


//delete any row has QTY =0 on Container Tab.
ll_Row_count = idw_cc_container.RowCount()
FOR ll_row =1 to ll_Row_count
	IF idw_cc_container.getItemNumber( ll_row, 'quantity') = 0 THEN
		idw_cc_container.deleterow( ll_Row)
		ll_Row_count = ll_Row_count - 1
		ll_Row = ll_Row - 1
	END IF
NEXT
end event

event itemchanged;call super::itemchanged;AcceptText()
end event

type tabpage_container from userobject within tab_main
integer x = 18
integer y = 104
integer width = 4279
integer height = 1916
long backcolor = 79741120
string text = "FP_Container"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_cc_container dw_cc_container
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
end type

on tabpage_container.create
this.dw_cc_container=create dw_cc_container
this.cb_6=create cb_6
this.cb_5=create cb_5
this.cb_4=create cb_4
this.Control[]={this.dw_cc_container,&
this.cb_6,&
this.cb_5,&
this.cb_4}
end on

on tabpage_container.destroy
destroy(this.dw_cc_container)
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.cb_4)
end on

type dw_cc_container from datawindow within tabpage_container
event ue_insertrow ( )
event ue_deleterow ( )
integer y = 124
integer width = 2354
integer height = 1792
integer taborder = 60
string dataobject = "d_cc_sku_container"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_insertrow();//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count

long insertRow, ll_row_count

ib_changed = true

ll_row_count = this.rowcount( ) //get current row count
insertRow = insertRow( ll_row_count+1 ) //insert at the end
this.SetItem(insertRow,'cc_no',idw_main.getItemString(1,'cc_no'))

this.SetFocus()
this.SetRow(insertRow)
this.ScrolltoRow(insertRow)
end event

event ue_deleterow();//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count

string ls_sku, ls_loc, ls_container_Id, lsFind
long ll_row, llFindRow, ll_count, ll_Next_Find, ll_SN_Count, ll_container_qty
long ll_Find_count_row, ll_count_qty

IF getRow() <= 0 then return

ll_count = this.rowcount( )
For ll_row =1 to ll_count
	IF this.getItemString( ll_row, 'rowfocusindicator') ='Y' Then
		ls_sku = this.getItemString( ll_row, 'sku')
		ls_loc = this.getItemString( ll_row, 'l_code')
		ls_container_Id = this.getItemString( ll_row, 'container_Id')
		ll_container_qty = this.getItemNumber( ll_row, 'quantity')

		lsFind ="sku ='"+ls_sku+"' and l_code ='"+ls_loc+"' and container_Id ='"+ls_container_Id+"'"
		
		//get count(serial) from Serail Tab
		IF idw_serial_numbers.rowcount( ) > 0 THEN
			idw_serial_numbers.setfilter( lsFind)
			idw_serial_numbers.filter( )
			ll_SN_Count = idw_serial_numbers.rowcount( )
			
			IF (ll_SN_Count > ll_container_qty)  and (ll_SN_Count > 0) THEN
				wf_remove_filter()
				MessageBox("Foot Print CC", "Serial No Count ( " +string(ll_SN_Count)+" ) is higher than Container Id QTY ( "+string(ll_container_qty)+" ). ~nPlease Delete Serail No's from Serial Tab to reflect Container Id QTY to proceed to Delete Container Id# "+ls_container_Id)
				return
			ELSEIF (ll_SN_Count < ll_container_qty)  and (ll_SN_Count > 0) THEN
				wf_remove_filter()
				MessageBox("Foot Print CC", "Serial No Count ( " +string(ll_SN_Count)+" ) is lesser than Container Id QTY ( "+string(ll_container_qty)+" ). ~nPlease Add Serail No's onto Serial Tab  to proceed to Delete Container Id# "+ls_container_Id)
				return
			END IF

			//remove container Id associated serial no's from Serial Tab.
			llFindRow = idw_serial_numbers.find( lsFind, 1, idw_serial_numbers.rowcount())
			DO WHILE llFindRow > 0 
				ll_Next_Find = llFindRow
				idw_serial_numbers.setItem( llFindRow, 'rowfocusindicator', 'Y')
				llFindRow = idw_serial_numbers.find( lsFind, ll_Next_Find+1, idw_serial_numbers.rowcount()+1)
			LOOP
		END IF

		wf_remove_filter()	 //Remove filter
		
		//Update 3rd Count QTY
		ll_Find_count_row = idw_result3.find( lsFind, 1, idw_result3.rowcount())
		IF ll_Find_count_row > 0 Then 
			ll_count_qty = idw_result3.getItemNumber(ll_Find_count_row, 'quantity')
			IF ll_count_qty > 0 Then idw_result3.setItem( ll_Find_count_row , 'quantity', ll_count_qty - ll_container_qty)
		END IF
		
		//delete current row
		this.deleteRow(ll_row)
		ll_count = ll_count - 1
		ll_row = ll_row - 1
	End IF
Next

wf_remove_filter()	 //Remove filter, if any

//delete respective Serial No's
idw_serial_numbers.event dynamic ue_deleterow()

ib_changed = true
end event

event itemchanged;string ls_sku, ls_loc, ls_container_Id, lsFind, ls_system_sku
long ll_container_qty, ll_serial_count, ll_new_qty, ll_SN_Count, llFindRow, ll_Next_Find

ib_changed =true

ls_sku = this.getItemString( row, 'sku')
ls_loc = this.getItemString( row, 'l_code', Primary!, true)
ls_container_Id = this.getItemString( row, 'container_id', Primary!, true)
ll_container_qty = this.getItemNumber( row, 'quantity', Primary!, true)

lsFind ="sku ='"+ls_sku+"' and l_code ='"+ls_loc+"' and container_Id ='"+ls_container_Id+"'"
If not IsNull(lsFind) Then ll_SN_Count = wf_get_count_of_serial_no( lsFind ) //get Serial No count against above criteria

//find appropriate record on Count 3 Tab and update QTY =0
llFindRow = idw_result3.find( lsFind, 1, idw_result3.rowcount())


CHOOSE CASE dwo.Name
		
	CASE 'sku'
		ls_system_sku = idw_system_generated.getITemString( 1, 'count_value')
		
		IF data <> ls_system_sku THEN
			MessageBox("Foot Print CC", "You can't use different SKU!")
			Return 2
		END IF
		
	CASE 'l_code'
				
		IF data <> ls_loc and ll_SN_Count > 0 THEN
			MessageBox("Foot Print CC", "Following Combination had Serial No's on Serial No. Tab. ~nSKU# "+ls_sku+" , Loc# "+ls_loc+" , Container Id# "+ls_container_Id+" ~n~n Please Add /Delete Serial No's from Serial No. Tab.", StopSign!)
			Return 2
		ELSEIF data <> ls_loc and llFindRow > 0 THEN
			idw_result3.setItem( llFindRow, 'quantity', 0)  //update Count 3 QTY against Previous Location (Primary!)
		END IF
			
	CASE 'quantity'

		ll_new_qty = long(data)
		
		IF ll_new_qty <> ll_container_qty and ll_SN_Count > 0 THEN
			MessageBox("Foot Print CC", "Following Combination had Serial No's on Serial No. Tab. ~nSKU# "+ls_sku+" , Loc# "+ls_loc+" , Container Id# "+ls_container_Id+" ~n~nPlease Add /Delete Serial No's from Serial No. Tab.", StopSign!)
			Return 2
		ELSEIF ll_new_qty <> ll_container_qty and llFindRow > 0 THEN
			idw_result3.setItem( llFindRow, 'quantity', ll_new_qty)  //update Count 3 QTY
		END IF
		
	CASE 'container_id'
		
		IF data <> ls_container_Id and  ll_SN_Count > 0 THEN
			MessageBox("Foot Print CC", "Following Combination had Serial No's on Serial No. Tab. ~nSKU# "+ls_sku+" , Loc# "+ls_loc+" , Container Id# "+ls_container_Id+" ~n~nPlease Add /Delete Serial No's from Serial No. Tab.", StopSign!)
			Return 2
		ELSEIF ll_new_qty <> ll_container_qty and llFindRow > 0 THEN
			idw_result3.setItem( llFindRow, 'quantity', 0)  //update Count 3 QTY
		END IF
		
END CHOOSE
end event

type cb_6 from commandbutton within tabpage_container
integer x = 997
integer y = 16
integer width = 370
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count
long ll_row
ib_changed =true

IF MessageBox( is_title, "Are you sure you want to delete rows?",Question!, YESNO! ) = 1 Then
	idw_cc_container.event dynamic ue_deleterow()	
ELSE
	For ll_row = 1 to idw_cc_container.rowcount( )
		If idw_cc_container.getItemString( ll_row, 'rowfocusindicator') ='Y' Then idw_cc_container.setItem( ll_row, 'rowfocusindicator', 'N')
	Next
	Return
END IF
end event

type cb_5 from commandbutton within tabpage_container
integer x = 526
integer y = 16
integer width = 370
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert"
end type

event clicked;//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count

idw_cc_container.event dynamic ue_insertrow()
end event

type cb_4 from commandbutton within tabpage_container
integer x = 27
integer y = 16
integer width = 411
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Import..."
end type

event clicked;//24-APR-2018 :Madhu S18502 - FootPrint Cycle Count

string ls_FileName, ls_FullName
string ls_CC_No, ls_errtext
long i, ll_row_count

IF ib_changed Then
	Messagebox(is_title,"Please save changes before Importing Container Id's ! ")
	Return
End IF

ls_CC_No = idw_main.getItemString(1,'cc_no')

GetFileOpenName("Select File", ls_FileName, ls_FullName, "txt", "Text Files (*.txt*), *.txt*")

If FileExists(ls_FileName) Then

	SetPointer(HourGlass!)

	ll_row_count = idw_cc_container.Rowcount()
	
	If ll_row_count > 0 Then
		Choose Case MessageBox(is_title, "Delete existing records? "+&
				"~n Yes - Delete Existing Container Id's and Re-Import All ~n No - Import Container Id's without Delete Existing Container Id's. "+&
				"~n Cancel - Don't do Anything ", +&
				Question!, YesNoCancel!,3)
			Case 3
				Return
			Case 1

				//Need to delete any existing Containers first
				Execute Immediate "Begin Transaction" Using SQLCA; /*PCONKL - Auto Commit Turned on to eliminate DB locks*/
	
				//Delete any CC_Sku_Containers entries That currently Exist
				DELETE FROM CC_Sku_Containers WHERE CC_NO = :ls_CC_No
				Using SQLCA;			
				
				//Delete any CC_Serials entries That currently Exist
				DELETE FROM CC_Serial_Numbers where CC_NO = :ls_CC_No
				Using SQLCA;	
				
				If sqlca.sqlcode <> 0 Then
					ls_ErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
					Execute Immediate "Rollback" Using SQLCA;
					Messagebox(is_Title, "Unable to Delete the existing serial numbers!~r~r" + ls_ErrText)
					Return -1
				End If
				
				Execute Immediate "Commit" Using SQLCA;
				If sqlca.sqlcode <> 0 Then
					MessageBox(is_title,"Unable to Delete the existing serial numbers!~r~r")
					Return -1
				End If
				
				//Re-set Serial Tab
				idw_serial_numbers.Reset()
				idw_serial_numbers.Setredraw(False)
					
				For i = ll_row_count to 1 Step -1
					idw_serial_numbers.DeleteRow( i )
				Next

				idw_serial_numbers.Setredraw(True)
				
				//Re-set Container Tab
				dw_cc_container.Reset()
				idw_cc_container.Setredraw(False)
					
				For i = ll_row_count to 1 Step -1
					idw_cc_container.DeleteRow( i )
				Next
				
				idw_cc_container.Setredraw(True)
		End Choose
	End If

	//Import Container Id's from Col2 (SKU)
	idw_cc_container.ImportFile(ls_FileName, 0,0,0,0,2)
	
	FOR i =  idw_cc_container.RowCount() to 1 step -1
		idw_cc_container.SetItem(i,'cc_no', ls_CC_No)
	NEXT

	dw_cc_container.SetRedraw(True)
	ib_changed = true
	MessageBox ("Import Success", "Successfully Imported!")

End IF
end event

type p_arrow from picture within w_cc
boolean visible = false
integer x = 3890
integer y = 16
integer width = 78
integer height = 64
boolean bringtotop = true
string picturename = "Next!"
boolean focusrectangle = false
end type

