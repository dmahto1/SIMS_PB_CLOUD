HA$PBExportHeader$w_pandora_serial_no_rpt.srw
$PBExportComments$Window used for processing Pandora Serial Number information
forward
global type w_pandora_serial_no_rpt from w_std_report
end type
type cbx_parents_only from checkbox within w_pandora_serial_no_rpt
end type
end forward

global type w_pandora_serial_no_rpt from w_std_report
integer width = 4613
integer height = 2224
string title = "Serial Number Inventory Report"
cbx_parents_only cbx_parents_only
end type
global w_pandora_serial_no_rpt w_pandora_serial_no_rpt

type variables
String	is_OrigSql

datastore ids_find_warehouse
Private boolean ib_sortascending

DatawindowChild	 idwc_Owner
end variables

forward prototypes
public function integer wf_new_rw_return_row (ref datastore returns_dw, long report_row, long return_row, integer ageing)
end prototypes

public function integer wf_new_rw_return_row (ref datastore returns_dw, long report_row, long return_row, integer ageing);

dw_report.SetItem(report_row, "content_summary_project_id", returns_dw.GetItemString( return_row, "content_summary_project_id"))
dw_report.SetItem(report_row, "content_summary_wh_code", returns_dw.GetItemString( return_row, "content_summary_wh_code"))
dw_report.SetItem(report_row, "content_summary_supp_code", returns_dw.GetItemString( return_row, "content_summary_supp_code"))
dw_report.SetItem(report_row, "supp_name", returns_dw.GetItemString( return_row, "supp_name"))
dw_report.SetItem(report_row, "content_summary_sku", returns_dw.GetItemString( return_row, "content_summary_sku"))
dw_report.SetItem(report_row, "item_master_alternate_sku", returns_dw.GetItemString( return_row, "item_master_alternate_sku"))
dw_report.SetItem(report_row, "item_master_description", returns_dw.GetItemString( return_row, "item_master_description"))
dw_report.SetItem(report_row, "item_master_std_cost", returns_dw.GetItemDecimal( return_row, "item_master_std_cost"))
dw_report.SetItem(report_row, "project_name", returns_dw.GetItemString( return_row, "project_name"))
dw_report.SetItem(report_row, "avail_qty", returns_dw.GetItemDecimal( return_row, "avail_qty"))
dw_report.SetItem(report_row, "season_code", returns_dw.GetItemString( return_row, "season_code"))
dw_report.SetItem(report_row, "brand", returns_dw.GetItemString( return_row, "brand"))	
dw_report.SetItem(report_row, "sub_category", returns_dw.GetItemString( return_row, "sub_category"))
dw_report.SetItem(report_row, "gender_category", returns_dw.GetItemString( return_row, "gender_category"))
dw_report.SetItem(report_row, "product_attribute", returns_dw.GetItemString( return_row, "product_attribute"))
dw_report.SetItem(report_row, "ageing", ageing)
dw_report.SetItem(report_row, "content_summary_cost_price", returns_dw.GetItemString( return_row, "content_summary_cost_price"))
//dw_report.SetItem(report_row, "order_type", returns_dw.GetItemString( return_row, "order_type"))

Return 0
end function

on w_pandora_serial_no_rpt.create
int iCurrent
call super::create
this.cbx_parents_only=create cbx_parents_only
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_parents_only
end on

on w_pandora_serial_no_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_parents_only)
end on

event open;call super::open;Integer  li_pos

is_OrigSql = dw_report.getsqlselect()


end event

event resize;//dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
//TimA 09/14/11 fix the DW resize
dw_report.Resize(workspacewidth() - 30,workspaceHeight()-350)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_retrieve;String ls_where
String ls_sni_OrigSql, ls_sni_select
string ls_union_single, ls_union_parent, ls_union_child // 01/03/2011 ujh: S/N_Pc:
string  ls_select_StandAlone, ls_select_ParentChild, ls_join // 01/03/2011 ujh: S/N_Pc:
long ll_tfr_in, ll_tfr_out

string ls_sql 

datastore lds_sni

Long li_pos, li_len,  ll_row, ll_insert_row, ll_owner_id, ll_owner_id_save,  ll_owner_id_content, ll_row_cnt,  ll_avail_qty, ll_alloc_qty
string ls_warehouse, ls_warehouse_save, ls_warehouse_content, ls_SKU, ls_sku_save, ls_sku_content, ls_value, ls_serial_no,ls_owner_cd 
string ls_component_ind  // 01/03/2011 ujh: S/N_P
String ls_l_code, ls_po_no	// LTK 20160421

lds_sni = create datastore
lds_sni.dataobject = 'd_pandora_serial_no_inv_list'
lds_sni.settransobject(sqlca)
ls_sni_OrigSql = lds_sni.GetSQLSelect()
ls_sni_select = ls_sni_OrigSql


If dw_select.AcceptText() = -1 Then Return

// KRZ Set the report redraw off.
dw_report.setredraw(false)

SetPointer(HourGlass!)
dw_report.Reset()

//TimA 09/14/11
//Pandora issue #268
//Because this report takes so long we needed to speed it up
ls_value = dw_select.GetItemString(1,"sku")
if  (NOT isnull(ls_value) AND (ls_value > ' ')) THEN

	//Always add project
	// 01/03/2011 ujh: S/N_Pc:  REMEMBER with these that the pos function is CASE SENSITIVE
	ls_where = " Serial_Number_Inventory.project_id = '" + gs_project + "' "  
	ls_join = " join Serial_number_inventory si2 on si2.Component_no = si1.Component_no "
	ls_union_single = ''
	ls_union_parent = ''
	ls_union_child = ''

	
	////Tackon Warehouse if present
	ls_value = dw_select.GetItemString(1,"warehouse")
	// 01/03/2011 ujh: S/N_Pc  replace ls_where so parents and children appear when either is sought. Now add warehouse
	if  (NOT isnull(ls_value) AND (ls_value > ' ')) THEN
	//	ls_where += " and Serial_Number_Inventory.WH_Code = '" + ls_value + "'"
		ls_union_single +=   " and serial_number_inventory.wh_code = '" + ls_value + "'"
		// 01/03/2011 ujh: S/N_Pfx2  add si2.wh_code.... as both need to be in where clause
		ls_union_parent +=  " and si1.wh_code = '" + ls_value + "'" +  " and si2.wh_code = '" + ls_value + "'"
		ls_union_child   +=   " and si1.wh_code = '" + ls_value + "'" +  " and si2.wh_code = '" + ls_value + "'"
	end if
	
	//Tackon SKU if present
	ls_value = dw_select.GetItemString(1,"sku")
	// 01/03/2011 ujh: S/N_Pc  replace ls_where so parents and children appear when either is sought
	if  (NOT isnull(ls_value) AND (ls_value > ' ')) THEN
	//	ls_where += " and Serial_Number_Inventory.SKU = '" + ls_value + "'"
	
	//	ls_where += " and serial_number_inventory.sku like '" + ls_sku + "%' "
		ls_union_single    += " and serial_number_inventory.SKU = '" + ls_value + "'"
	//	ls_union_single    += " and serial_number_inventory.Component_ind not in ('Y','*') " 
		if cbx_Parents_only.checked = true then
			ls_union_single      +=  " and serial_number_inventory.Component_ind <> 'N'"  
		else
			ls_union_single    += " and serial_number_inventory.Component_ind not in ('Y','*') " 
		end if
	//	ls_union_parent   += "join Serial_number_inventory si2 on si2.Component_no = si1.Component_no"
		ls_union_parent   += " and si1.sku = '" + ls_value + "'"  
		ls_union_parent   += " and si2.Component_ind = 'Y'"   
		//	ls_union_child      += "join Serial_number_inventory si2 on si2.Component_no = si1.Component_no"
			ls_union_child      += " and si1.sku = '" + ls_value + "'"
		if cbx_Parents_only.checked = true then
			ls_union_child      +=  " and si2.Component_ind <> '*'"  
		else
			ls_union_child      +=  " and si2.Component_ind = '*'"  
		end if
	end if
	
	
	//Tackon Owner Code if Present
	ls_value = dw_select.GetItemString(1,"owner_cd")
	// 01/03/2011 ujh: S/N_Pc  replace ls_where so parents and children appear when either is sought
	if  (NOT isnull(dw_select.GetItemString(1,"owner_cd")) AND (dw_select.GetItemString(1,"owner_cd") > ' ')) THEN
	//	ls_where += " and Serial_Number_Inventory.Owner_Cd = '" + ls_value + "'"
		
		ls_union_single +=   " and serial_number_inventory.Owner_Cd = '" + ls_value + "'"
		
		// 01/03/2011 ujh: S/N_Pfx2  add si2.owner_cd.... as both need to be in where clause
		ls_union_parent +=  " and si1.Owner_Cd = '" + ls_value + "'"  +  " and si2.Owner_Cd = '" + ls_value + "'"
		ls_union_child   +=   " and si1.Owner_Cd = '" + ls_value + "'"  +  " and si2.Owner_Cd = '" + ls_value + "'"
	
	end if
	
	//Tackon Serial Number if Present
	ls_value = dw_select.GetItemString(1,"serial_no")
	// 01/03/2011 ujh: S/N_Pc  replace ls_where so parents and children appear when either is sought
	if  (NOT isnull(dw_select.GetItemString(1,"serial_no")) AND (dw_select.GetItemString(1,"serial_no") > ' ')) THEN
	
		ls_union_single +=    " and serial_number_inventory.Serial_No = '" + ls_value + "'"
		ls_union_parent +=  " and si1.Serial_No = '" + ls_value + "'"
		ls_union_child   +=   " and si1.Serial_No = '" + ls_value + "'"
	end if
	
	ls_sni_select = Replace (ls_sni_select, pos( ls_sni_select,"Serial_Number_Inventory.Project_Id = 'PROJECT'",1), Len("Serial_Number_Inventory.Project_Id = 'PROJECT'"), ls_where )
	
	// 01/03/2011 ujh: S/N_Pc:  Create correct Select for the unions
	ls_select_StandAlone = ls_sni_select
	ls_select_ParentChild = ls_sni_select
	
	// 01/03/2011 ujh: S/N_Pc:  Note that 'as si1 '  was added to give an alias to the table before the join
	ls_select_ParentChild =  Replace(ls_select_ParentChild, pos(ls_select_ParentChild,"WHERE ",1), Len("Where "), ' as si1 ' +ls_join + ' And ')
	
	// 01/03/2011 ujh: S/N_Pc:
	Do while pos(ls_select_ParentChild,"Serial_Number_Inventory.", 1)  <> 0
		ls_select_ParentChild =  Replace(ls_select_ParentChild, pos(ls_select_ParentChild,"Serial_Number_Inventory.",1), Len("Serial_Number_Inventory."), "si2.")
	Loop 
	
	ls_sni_select = ls_select_StandAlone + ls_union_single
	ls_sni_select += 'UNION ' + ls_select_ParentChild + ls_union_Parent
	ls_sni_select += 'UNION ' + ls_select_ParentChild + ls_union_Child
	//ls_sni_select += ' order by  Component_no, component_ind desc, SKU'   // 01/03/2011 ujh: S/N_P:  This is what is done on modifie window
	ls_sni_select += ' order by SKU, component_ind desc, serial_no'
	
	lds_sni.setsqlselect(ls_sni_select)
	ll_row_cnt = lds_sni.Retrieve()
	
	long ll_component_no  // 01/03/2011 ujh: S/N_P:  testing  remove
	for ll_row = 1 to ll_row_cnt
			
			ls_serial_no = lds_sni.getitemString(ll_row,"serial_no")
			ls_SKU = lds_sni.getitemString(ll_row,"sku")
			ll_owner_id = lds_sni.getitemNumber(ll_row,"owner_id")
			ls_owner_cd = lds_sni.getitemString(ll_row,"owner_cd")
			ls_warehouse = lds_sni.getitemString(ll_row,"wh_code")
			ls_component_ind =  lds_sni.getitemString(ll_row,"component_ind")  // 01/03/2011 ujh: S/N_P:
			ll_component_no =  lds_sni.getitemNumber(ll_row,"component_no")  // 01/03/2011 ujh: S/N_P:  testing remove
			ls_l_code = lds_sni.getItemString(ll_row,"l_code")		// LTK 20160421
			ls_po_no = lds_sni.getItemString(ll_row,"po_no")		// LTK 20160421
			
			ll_insert_row= dw_report.insertrow(0)
			dw_report.setitem(ll_insert_row,"serial_no",ls_serial_no)
			dw_report.setitem(ll_insert_row,"sku",ls_sku)
			dw_report.setitem(ll_insert_row,"wh_code",ls_warehouse)	
			dw_report.setitem(ll_insert_row,"owner_id",ll_owner_id)		
			dw_report.setitem(ll_insert_row,"owner_cd",ls_owner_cd)		
			dw_report.setitem(ll_insert_row,"component_ind",ls_component_ind)		// 01/03/2011 ujh: S/N_P:
			dw_report.setitem(ll_insert_row,"component_no",ll_component_no)		// 01/03/2011 ujh: S/N_P:  testing
			dw_report.setitem(ll_insert_row,"l_code",ls_l_code)		// LTK 20160421
			dw_report.setitem(ll_insert_row,"po_no",ls_po_no)		// LTK 20160421

	
			// If values change then get the new content totals
			IF ls_warehouse_save <> ls_warehouse or ll_owner_id_save <> ll_owner_id or ls_sku_save <> ls_sku Then
				SELECT SUM(Avail_Qty), SUM(Alloc_Qty)  , SUM(TFR_IN) , SUM(TFR_OUT) 
				INTO  :ll_avail_qty, :ll_alloc_qty, :ll_tfr_in, :ll_tfr_out
				FROM Content_Summary  
				WHERE ( Project_ID = 'PANDORA' ) AND  ( WH_Code = :ls_warehouse ) AND  ( Owner_ID = :ll_owner_id ) AND  ( SKU = :ls_sku )   
				GROUP BY Project_ID,  WH_Code, Owner_ID,  SKU  ;
				
				// If there is nothing found,
				if sqlca.sqlcode = 100 then
					
					// Set all values to 0.
					ll_avail_qty = 0
					ll_alloc_qty = 0
					ll_tfr_in = 0
					ll_tfr_out = 0
					
				End If
				
				ls_sku_save = ls_sku
				ll_owner_id_save = ll_owner_id
				ls_warehouse_save = ls_warehouse
			End If
			
			If ls_component_ind <> '*' then  //01/03/2011 ujh: S/N_P;  If not a component, show the qty
				dw_report.setitem(ll_insert_row,"avail_qty",ll_avail_qty)		
				dw_report.setitem(ll_insert_row,"alloc_qty",ll_alloc_qty)	
				dw_report.setitem(ll_insert_row,"tfr_in",ll_tfr_in)
				dw_report.setitem(ll_insert_row,"tfr_out",ll_tfr_out)		
			end if 
	
	next		
Else
	//Pandora issue #268
	ls_where = " where smi.Project_id= '" + gs_project + "' "  
	ls_join = " left outer join content_summary cs on smi.Project_id=cs.Project_ID and smi.Wh_Code=cs.WH_Code and smi.Owner_id=cs.Owner_ID and smi.SKU=cs.SKU "
	
//	ls_sni_select = 'select smi.project_id,smi.Wh_Code, smi.Owner_Id, smi.Owner_cd, smi.SKU, smi.Serial_No, smi.Component_Ind, smi.Component_No,  sum(avail_qty) AvailQty, SUM(alloc_qty) AllocQty, SUM(sit_qty) SITQty, smi.Owner_id from Serial_Number_Inventory smi  '
	// LTK 20160427  Adding po_no and l_code
	ls_sni_select = 'select smi.project_id,smi.Wh_Code, smi.Owner_Id, smi.Owner_cd, smi.SKU, smi.Serial_No, smi.Component_Ind, smi.Component_No,  sum(avail_qty) AvailQty, SUM(alloc_qty) AllocQty, SUM(sit_qty) SITQty, smi.Owner_id, smi.po_no, smi.l_code from Serial_Number_Inventory smi  '

	ls_sni_select += ls_Join
	ls_sni_select += ls_where
	
	ls_value = dw_select.GetItemString(1,"warehouse")
	if  (NOT isnull(ls_value) AND (ls_value > ' ')) THEN
		ls_sni_select +=   " and smi.wh_code = '" + ls_value + "'"
	end if

	ls_value = dw_select.GetItemString(1,"owner_cd")
	if  (NOT isnull(dw_select.GetItemString(1,"owner_cd")) AND (dw_select.GetItemString(1,"owner_cd") > ' ')) THEN
		ls_sni_select +=   " and smi.Owner_Cd = '" + ls_value + "'"
	end if

	ls_value = dw_select.GetItemString(1,"serial_no")
	if  (NOT isnull(dw_select.GetItemString(1,"serial_no")) AND (dw_select.GetItemString(1,"serial_no") > ' ')) THEN
		ls_sni_select +=    " and smi.Serial_No = '" + ls_value + "'"
	end if

	if cbx_Parents_only.checked = true then
		ls_sni_select      +=  " and smi.Component_ind <> 'N'"  
	else
		ls_sni_select    += " and smi.Component_ind not in ('Y','*') " 
	end if
	
	//ls_sni_select += "	group by smi.project_id,smi.Wh_Code, smi.Owner_Id, smi.Owner_cd, smi.SKU, smi.Serial_No,smi.Component_Ind, smi.Component_No,  smi.Owner_id"
	// LTK 20160427  Adding po_no and l_code
	ls_sni_select += "	group by smi.project_id,smi.Wh_Code, smi.Owner_Id, smi.Owner_cd, smi.SKU, smi.Serial_No,smi.Component_Ind, smi.Component_No,  smi.Owner_id, smi.po_no, smi.l_code"
	
	dw_report.setsqlselect( ls_sni_select)
	ll_row_cnt = dw_report.Retrieve()

End if

//TimA 04/26/11 Pandora Issue #122
ll_row_cnt = dw_report.rowcount()
if ll_row_cnt > 0 then
	//TimA changed Owner_ID to Owner_CD per conversation with Roy on 09/14/11
	dw_report.SetSort("WH_Code, Owner_CD, Component_no, Component_ind desc, SKU")	
	//dw_report.SetSort("WH_Code, Owner_ID, Component_no, Component_ind desc, SKU")
	dw_report.Sort()
	// KRZ Set the report redraw on.
	dw_report.setredraw(true)
else
	Messagebox('No records','No records found.')
	dw_report.Reset()
	dw_report.InsertRow(0)
	dw_report.setredraw(true)
end if




end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc_warehouse, ldwc
string	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('inv_type', ldwc)
ldwc.SetTransObject(sqlca)
ldwc.Retrieve()
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()
	
//TimA 04/26/11 Pandora Issue #122
dw_select.GetChild('owner_cd', idwc_Owner)
idwc_Owner.SetTransObject(sqlca)
	
//dw_select.GetChild('owner_cd', ldwc)
//ldwc.SetTransObject(sqlca)
//ldwc.Retrieve(gs_project)

//dw_select.GetChild('warehouse', ldwc_warehouse)
//ldwc_warehouse.SetTransObject(sqlca)
//
//If ldwc_warehouse.Retrieve(gs_project) > 0 Then
//	
//	//Filter Warehouse dropdown by Current Project
//	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
//	ldwc_warehouse.SetFilter(lsFilter)
//	ldwc_warehouse.Filter()
//	
////	If ldwc_warehouse.RowCount() > 0 Then
////		dw_select.SetItem(1, "warehouse" , ldwc_warehouse.GetItemString(1, "wh_code"))
////	End If
//	
//End If

// LTK 20150908  Commented out block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
dw_select.GetChild("warehouse", ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_warehouse)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "warehouse", gs_default_wh)
end if
end event

type dw_select from w_std_report`dw_select within w_pandora_serial_no_rpt
integer x = 0
integer width = 4265
integer height = 304
string dataobject = "d_pandora_serial_no_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::clicked;call super::clicked;string 	ls_column
DatawindowChild	ldwc
long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()


end event

event dw_select::itemchanged;call super::itemchanged;//TimA 04/26/11 Pandora Issue #122
// ET3 - 2012-07-05 Pandora 447 - cleanup SN's by removing leading/trailing '.' and '-'

String ls_Null
BOOLEAN lb_SN_cleaned = FALSE
LONG    ll_Rtn = 0


Choose Case Upper(dwo.name)		

	case "WAREHOUSE"
		SetNull ( ls_Null )
		idwc_Owner.Retrieve ( data )
		this.Object.Owner_cd[1] = ls_Null

	CASE 'SERIAL_NO'
		IF UPPER(gs_project) = 'PANDORA' THEN
			// ET3 - 2012-07-05 Pandora 447 - cleanup SN's by removing leading/trailing '.' and '-'
			data = TRIM(data)
			If len(data) > 1 Then
				// strip extraneous Trailing chars
				DO WHILE MATCH( data, "[-\.]$" )
					data = MID(data, 1, len(data) - 1 )
					lb_SN_cleaned = TRUE
				LOOP
				
				// strip extraneous Leading chars
				DO WHILE MATCH( data, "^[-\.]")
					data = MID(data, 2, len(data) - 1 )
					lb_SN_cleaned = TRUE
				LOOP
				
			End If
			
		END IF  // Pandora

END CHOOSE


IF lb_SN_cleaned THEN
	ll_Rtn = 2
	this.setitem( row, dwo.name, data )
ELSE
	ll_Rtn = 0

END IF

RETURN ll_Rtn
end event

type cb_clear from w_std_report`cb_clear within w_pandora_serial_no_rpt
boolean visible = true
integer x = 4279
integer y = 8
integer width = 261
integer taborder = 20
end type

event cb_clear::clicked;call super::clicked;// Reset both the select and report datawindows.
dw_select.reset()
//dw_select.settransobject(sqlca)
dw_select.insertrow(0)
idwc_Owner.reset()
dw_report.reset()
dw_report.settransobject(sqlca)
end event

type dw_report from w_std_report`dw_report within w_pandora_serial_no_rpt
integer x = 5
integer y = 320
integer width = 4558
integer height = 1704
integer taborder = 30
string dataobject = "d_pandora_serial_no_inv_list"
boolean hscrollbar = true
end type

event dw_report::doubleclicked;call super::doubleclicked;string ls_objectname
string ls_sortstring
string ls_sortdir

// Get the object we doubleclicked.
ls_objectname = GetObjectAtPointer()

// Toggle the sort direction.
ib_sortascending = not ib_sortascending

// Set the sort direction indicator.
If ib_sortascending then
	
	ls_sortdir = "A"
	
Else
	
	ls_sortdir = "D"	
End IF

// If the object is a text label,
If left(ls_objectname, 2) = "t_" then
	
	// take only the left 4 chars for the match.
	ls_objectname = left(ls_objectname, 4)
	
	// Which label was clicked?
	Choose Case ls_objectname
			
		// Warehouse
		Case "t_wa"
			
			ls_sortstring = "wh_code " + ls_sortdir
			
		// Owner
		Case "t_ow"
			
			ls_sortstring = "owner_cd " + ls_sortdir
			
		// SKU
		Case "t_gp"
			
			ls_sortstring = "sku " + ls_sortdir
			
		// Available
		Case "t_av"
			
			ls_sortstring = "avail_qty " + ls_sortdir
		
		// Allocated
		Case "t_al"
			
			ls_sortstring = "alloc_qty " + ls_sortdir
			
		// Transfer In
		Case "t_tr"
			
			ls_sortstring = "tfr_in " + ls_sortdir
			
		// Transfer Out
		Case "t_tr"
			
			ls_sortstring = "tfr_out " + ls_sortdir
			
		// Serial Number
		Case "t_se"
			
			ls_sortstring = "serial_no " + ls_sortdir
			
		// Any other text labels
		Case ELSE
			
			ls_sortstring = ""
			
	// End Which label was clicked.
	End Choose
	
	// Sort the datawindow.
	setsort(ls_sortstring)
	sort()
	
// End If the object is a text label.
End IF

end event

type cbx_parents_only from checkbox within w_pandora_serial_no_rpt
integer x = 2217
integer y = 120
integer width = 430
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parents Only"
end type

