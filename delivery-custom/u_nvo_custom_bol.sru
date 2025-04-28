HA$PBExportHeader$u_nvo_custom_bol.sru
$PBExportComments$Project Specific BOL logic
forward
global type u_nvo_custom_bol from nonvisualobject
end type
end forward

global type u_nvo_custom_bol from nonvisualobject
end type
global u_nvo_custom_bol u_nvo_custom_bol

type variables
string isCarrier

end variables

forward prototypes
public function integer uf_print_bol_3com ()
public function integer uf_process_bol_sears_fix (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_3com ()
public function string fu_quotestring (string quote_string, string quote_char)
public function integer uf_process_bol_phxbrands (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_linksys (string as_dono, ref datawindow adw_bol)
public function integer uf_print_bol_linksys ()
public function integer uf_process_bol_logitech (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_gmbattery (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_globalrush (string as_dono, ref datawindow adw_bol)
public subroutine setcarrier (string ascarrier)
public function string getcarrier ()
public function integer uf_process_bol_pwrofdream (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol (string as_dono, ref datawindow adw_bol, datawindow adw_print)
public function integer uf_process_bol_generic (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_petco (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_scitex (string as_dono, ref datawindow adw_bol)
public function integer uf_process_sli_netapp (string asdono, ref datawindow adw_sli)
public function integer uf_process_bol_sika (string as_dono, ref datawindow adw_bol)
public function integer uf_process_eut_do (string asdono, ref datawindow adw_sli)
public function integer uf_process_rw_do (string asdono, ref datawindow adw_sli)
public function integer uf_process_bol_maquet (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_pandora (string as_dono, ref datawindow adw_bol)
public function boolean f_getcostcenter (long al_pickrow, ref decimal ad_cost)
public function boolean f_getdwtaborder (readonly datawindow adw_toparse, long al_starttabseq, ref string as_taborder[])
public function boolean of_parsetoarray (string as_source, string as_delimiter, ref string as_array[])
public function integer uf_process_ws_do (string asdono, ref datawindow adw_sli)
public function integer uf_process_sli_riverbed (string asdono, ref datawindow adw_sli)
public function integer uf_process_bol_klonelab (string as_dono, ref datawindow adw_bol)
public function integer uf_process_vics_bol (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_ariens_old (string as_dono, datawindow adw_bol)
public function integer uf_process_bol_ariens (string as_dono, datawindow adw_bol)
public function integer uf_process_bol_nycsp (string as_dono, ref datawindow adw_bol)
public function integer uf_process_vics_bol_combine (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_anki (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_bosch (string as_dono, ref datawindow adw_bol, string as_consolidation_no)
public function integer uf_process_vics_bol_singleorder (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_friedrich_combined (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_friedrich_singleorder (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_baseline_singleorder (string as_dono, ref datawindow adw_bol)
public function integer uf_process_vics_bol_pandora_combine (string as_dono, ref datawindow adw_bol)
public function integer uf_process_vics_bol_pandora_singleorder (string as_dono, ref datawindow adw_bol)
public subroutine uf_set_carrier_information (datawindowchild adwc_items)
public function integer uf_is_pandora_hazmat_turned_on (string as_dono, string as_consolidation_no)
public subroutine uf_set_sort (datawindowchild adwc_target)
public function integer uf_process_bol_rema (string as_dono, datawindow adw_bol)
public function integer uf_process_bol_rema_combined (string as_dono, datawindow adw_bol)
public function integer uf_process_bol_cree_singleorder (string as_dono, ref datawindow adw_bol)
public function integer uf_process_bol_cree_combined (string as_dono, ref datawindow adw_bol)
public function integer uf_process_master_bol_pandora (string as_load_id, ref datawindow adw_bol)
public function integer uf_process_child_bol_pandora (string as_shipment_id, ref datawindow adw_bol)
public function integer uf_process_bol_kendo (string as_dono, ref datawindow adw_bol)
end prototypes

public function integer uf_print_bol_3com ();String	lsPrinter
Long	llCopies

// 04/04 - PCONKL - 3COM SLI needs to hide tags and remove box borders from editable columns before printing

		
//	w_do.idw_bol.Modify("title1_t.visible=0 title2_t.visible=0 carrier_t.visible=0 pro_t.visible=0 dn_t.visible=0 consignee_t.visible=0 phone_t.visible=0 shipper_t.visible=0 date_t.visible=0 route_t.visible=0 vehicle_t.visible=0 pieces_t.visible=0 description_t.visible=0 reference_t.visible=0 weight_t.visible=0 shipmentcontains_t.visible=0 instructions_t.visible = 0")
//	w_do.idw_bol.Modify("pallets_t.visible=0 cartons_t.visible=0 billto_t.visible=0 bt_shipper_t.visible=0 bt_consignee_t.visible = 0 bt_3rd_t.visible = 0 shipper2_t.visible=0 carrier2_t.visible=0 per1_t.visible=0 per2_t.visible = 0")
//		

w_do.idw_bol.AcceptText()

w_do.idw_bol.SetITem(1,'c_print_ind','Y')
	
//If printing from doc print window, we may set the number of copies
If g.ilPrintCopies > 0 Then /* print ship docs window may set number of copies*/
	llCopies = g.ilPrintCopies
Else
	llCopies = 1
End If

// 09/04 - PCONKL - We may want to print without prompting (if coming from Print Shipment Docs, etc.)
If g.ibNoPromptPrint Then
	w_do.idw_bol.Object.DataWindow.Print.Copies = llCOpies
	Print(w_do.idw_bol)
Else
	OpenWithParm(w_dw_print_options,w_do.idw_bol) 
End If

// 09/04 - PCONKL - We want to store the last printer used for Printing the Pack List for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','BOL',lsPrinter)

//w_do.idw_bol.Modify("title1_t.visible=1 title2_t.visible=1 carrier_t.visible=1 pro_t.visible=1 dn_t.visible=1 consignee_t.visible=1 phone_t.visible=1 shipper_t.visible=1 date_t.visible=1 route_t.visible=1 vehicle_t.visible=1 pieces_t.visible=1 description_t.visible=1 reference_t.visible=1 weight_t.visible=1 shipmentcontains_t.visible=1 instructions_t.visible = 1")
//w_do.idw_bol.Modify("pallets_t.visible=1 cartons_t.visible=1 billto_t.visible=1 bt_shipper_t.visible=1 bt_consignee_t.visible = 1 bt_3rd_t.visible = 1 shipper2_t.visible=1 carrier2_t.visible=1 per1_t.visible=1 per2_t.visible = 1")
//	

w_do.idw_bol.SetITem(1,'c_print_ind','N')

Return 0
end function

public function integer uf_process_bol_sears_fix (string as_dono, ref datawindow adw_bol);integer li_current_id = 47  //Last Column ID in the select to know where to start.
integer li_start_y = 1384, li_y, li_height = 100, li_space = 104, li_start_tab = 30, li_tab_order, li_offset
LONG    ll_nbrobjects
string  ls_dwobjs[]
string  ls_objects
string ls_col_name
integer li_tab, i
integer li_change_tab[], li_max_tab, li_min_tab
string ls_change_tab[], ls_change_tab_temp[]
integer i2, li_rtn2, li_idx
string ls_cust_code, ls_cust_order_no
string ls_select
datastore lds_ds, lds_po, lds_po_multi
integer li_rtn_item, li_idx_rtn_item, li_from_pos
string ls_po
boolean lb_multi_run
integer li_rtn3
integer li_idx2
string ls_po_list
string ls_add_select, ls_new_select
string ls_add_column
string ls_add_table
string ls_add_table_column
string ls_compute_piece, ls_compute_weight
string ls_syntax
integer li_retrive_pos, li_text_pos
integer li_alloc_qty 
string ls_invoice_no
double ld_quantity
string ls_tab_change
string ls_last_col

string ls_po_temp[], ls_reset_po_temp[]	
boolean ib_found
integer p

	
//Loop through and get old tab orders.

ls_objects = adw_bol.Describe('Datawindow.Objects')
	
of_parsetoArray(ls_objects,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)

For i = 1 to ll_nbrobjects
	
	  li_tab = integer(adw_bol.Describe(ls_dwobjs[i]+'.TabSequence'))
		ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')

	  if li_tab >= li_start_tab then
			ls_change_tab[UpperBound(ls_change_tab)+1] = ls_col_name
			li_change_tab[UpperBound(ls_change_tab)] = li_tab
			
			if li_tab > li_max_tab then
				li_max_tab = li_tab
			end if

			if li_tab < li_min_tab then
				li_min_tab = li_tab
			end if
			
			
	  end if
NEXT



for i = li_min_tab to li_max_tab step 10
	
	for i2 = 1 to UpperBound(ls_change_tab)
		if i = li_change_tab[i2] then
			ls_change_tab_temp[UpperBound(ls_change_tab_temp) + 1] = ls_change_tab[i2]
			
			EXIT;		
		end if
	next
	
next

ls_change_tab = ls_change_tab_temp




lds_ds = CREATE datastore

lds_ds.dataobject = "d_sears_bol_item_list"

lds_ds.SetTransObject(SQLCA)




select cust_code,cust_order_no into :ls_cust_code,:ls_cust_order_no from delivery_master where do_no = :as_dono and project_id = :gs_project;


li_rtn_item = lds_ds.Retrieve(ls_cust_code, ls_cust_order_no, gs_project)

li_y = li_start_y
li_tab_order = li_start_tab

long ll_row_per_page = 9, ll_num_total_rows

//if mod(li_rtn_item, ll_row_per_page) <> 0 then

	ll_num_total_rows = (1 + (integer((li_rtn_item/ll_row_per_page)))) * ll_row_per_page


//end if

for li_idx_rtn_item = 1 to ll_num_total_rows

	//Everything must in the correct order!

	ls_add_select = ls_add_select + ", 000 as c_pieces" + string(li_idx_rtn_item) + ",   ~~~'                                 ~~~' as c_desc"+string(li_idx_rtn_item) + ", 0000.00 as c_rate" + string(li_idx_rtn_item)+ + ", 0000.00 as c_weight"+string(li_idx_rtn_item) + ",	0000.00 as c_charges"

	

	ls_add_table_column = ls_add_table_column + " column=(type=long updatewhereclause=yes name=c_pieces"+string(li_idx_rtn_item)+" dbname=~"c_pieces"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=char(33) updatewhereclause=yes name=c_desc"+string(li_idx_rtn_item)+" dbname=~"c_desc"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_rate"+string(li_idx_rtn_item)+" dbname=~"c_rate"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_weight"+string(li_idx_rtn_item)+" dbname=~"c_weight"+string(li_idx_rtn_item)+"~"  ) " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_charges"+string(li_idx_rtn_item)+" dbname=~"c_charges"+string(li_idx_rtn_item)+"~" ) " 

	if li_idx_rtn_item > 1 then ls_compute_piece = ls_compute_piece + " + "
	ls_compute_piece 	= ls_compute_piece + " c_pieces" +string(li_idx_rtn_item)

	if li_idx_rtn_item > 1 then ls_compute_weight = ls_compute_weight + " + "
	ls_compute_weight	= ls_compute_weight + " c_weight" +string(li_idx_rtn_item)


	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"100~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "

	li_current_id = li_current_id + 1

	li_tab_order = li_tab_order + 1
	
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"100~" width=~"2162~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2446~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2898~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
	//Column place holder for c_charges. We don't use here, but in the original. Might be used with other customers.
	
	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
	li_y = li_y + li_space
	
	li_offset = li_offset + li_space
	
	ls_last_col = "c_weight"+string(li_idx_rtn_item)

next


ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_weight+"~" border=~"2~" color=~"0~" x=~"2898~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_weight_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece+"~" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"100~" width=~"265~" format=~"[general]~"  name=c_piece_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

ls_syntax = adw_bol.Describe("DataWindow.Syntax")

ls_add_select = ls_add_select + " "


ls_select = adw_bol.Describe("Datawindow.Table.Select")

ls_new_select = ls_syntax

li_retrive_pos = Pos(lower(ls_new_select), "retrieve=")

ls_new_select = left( ls_new_select, li_retrive_pos - 1) + ls_add_table_column + mid( ls_new_select, li_retrive_pos - 1)

//	Messagebox (string(li_retrive_pos), ls_new_select)


li_from_pos = POS(upper(ls_new_select), " FROM ")

ls_new_select = left( ls_new_select, li_from_pos - 2) + ls_add_select + mid( ls_new_select, li_from_pos - 2)  


li_text_pos = POS(lower(ls_new_select), "text(")

ls_new_select = left( ls_new_select, li_text_pos - 1) + ls_add_column + mid( ls_new_select, li_text_pos - 1)  

ls_new_select = fu_quotestring(ls_new_select, "'")


//	MessageBox ("newselect", ls_new_select)
	
adw_bol.Create(ls_new_select)

//Retrieve Carrie Datawindow

datawindowchild ldw_child

adw_bol.GetChild( "delivery_master_carrier", ldw_child)

ldw_child.SetTransObject(SQLCA)

ldw_child.Retrieve(gs_project)


//Retrieve the report

adw_bol.SetTransObject(sqlca)

adw_bol.Retrieve(gs_project, as_dono)

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

	
//Set the default data.	


for li_idx_rtn_item = 1 to li_rtn_item

	ClipBoard(ls_new_select)	
	
	li_alloc_qty = lds_ds.GetItemNumber( li_idx_rtn_item, "alloc_qty")
	ls_invoice_no = lds_ds.GetItemString( li_idx_rtn_item, "description")
	ld_quantity = double(lds_ds.GetItemString( li_idx_rtn_item, "quantity"))

	if NOT IsNull(li_alloc_qty) then &
		adw_bol.SetItem(adw_bol.GetRow(), "c_pieces" + string(li_idx_rtn_item), li_alloc_qty )		
	if NOT IsNull(ls_invoice_no) then &		
		adw_bol.SetItem(adw_bol.GetRow(), "c_desc" + string(li_idx_rtn_item), ls_invoice_no )		
	if NOT IsNull(ld_quantity) then &
		adw_bol.SetItem(adw_bol.GetRow(), "c_weight" + string(li_idx_rtn_item), ld_quantity )		

next
	
//Push Footer Down

ls_objects = adw_bol.Describe('Datawindow.Objects')

of_parsetoArray(ls_objects,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)

string ls_type

For i = 1 to ll_nbrobjects

		ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
		ls_type = trim(adw_bol.Describe(ls_dwobjs[i]+'.type'))


		if ls_type = "line" then
		   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y1'))
		else
		   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y'))
		end if
		

//			Messagebox ("ok", ls_col_name)

	  if (li_y >= li_start_y) and &
		  (left(ls_col_name, 6) <> "c_piec" and &
			left(ls_col_name, 6) <> "c_desc" and &
			left(ls_col_name, 6) <> "c_rate" and &
			left(ls_col_name, 6) <> "c_weig") then

			if ls_type = "line"  then

				adw_bol.Modify(ls_dwobjs[i] + ".y1=" + string(li_y + li_offset) + " " + ls_dwobjs[i] + ".y2=" + string(li_y + li_offset))

				
			else

				adw_bol.Modify(ls_dwobjs[i] + ".y=" + string(li_y + li_offset))
	
			end if
	
	  END IF
NEXT

li_tab_order =  integer(adw_bol.describe(ls_last_col+".TabSequence")) + 1

for i = 1 to UpperBound(ls_change_tab)
	
	adw_bol.modify(ls_change_tab[i]+".TabSequence=0")
	
	ls_tab_change = ls_tab_change + " " + ls_change_tab[i]+".TabSequence=" + string(li_tab_order) + " "

	li_tab_order = li_tab_order + 10
	
next	

adw_bol.Modify(ls_tab_change)

adw_bol.SetRedraw(true)

//Start Multi-PO

/* 05/2004 MA - Added Multi-PO Support */

lds_po = create datastore;
lds_po_multi = create datastore;


lds_po.dataobject = "d_sears_bol_po_order"
lds_po_multi.dataobject = "d_sears_bol_multipo"

lds_po.SetTransObject(SQLCA)
lds_po_multi.SetTransObject(SQLCA)

li_rtn2 = lds_po.Retrieve(ls_cust_code, ls_cust_order_no, gs_project)		

string ls_sub_do_no

if li_rtn2 > 0 then

	for li_idx = 1 to li_rtn2
		
		ls_po = lds_po.GetItemString(li_idx, "po_no")
		
		
		if upper(ls_po) = "MULTIPO" then
		
			if not lb_multi_run then
			
				ls_sub_do_no = lds_po.GetItemString(li_idx, "do_no")
			
				li_rtn3 = lds_po_multi.Retrieve(ls_sub_do_no)
		
				if li_rtn3 > 0 then
				
					lb_multi_run = true
					
					for li_idx2 = 1 to li_rtn3
					
						ls_po = lds_po_multi.GetItemString(li_idx2, "receive_xref_po_no")
					
						ib_found = false

						for p = 1 to UpperBound(ls_po_temp[])
							if ls_po = ls_po_temp[p] then
								ib_found = true
								EXIT
							end if
						next

						if Not ib_found then
							
							ls_po_temp[UpperBound(ls_po_temp) + 1] = ls_po

							if UpperBound(ls_po_temp) > 1 then
								ls_po_list = ls_po_list + ", "
							end if
						
							ls_po_list = ls_po_list + ls_po
		
						end if
					
					next
		
				end if
	
			end if

		else

			ib_found = false

			for p = 1 to UpperBound(ls_po_temp[])
				if ls_po = ls_po_temp[p] then
					ib_found = true
					EXIT
				end if
			next

			if Not ib_found then
							
				ls_po_temp[UpperBound(ls_po_temp) + 1] = ls_po

				if UpperBound(ls_po_temp) > 1 then
					ls_po_list = ls_po_list + ", "
				end if
						
				ls_po_list = ls_po_list + ls_po
		
			end if
	
		end if
	
	next

else
	
	ls_po_list = ""

end if

destroy lds_po;
destroy lds_po_multi;		
		

adw_bol.setitem( 1, "c_po_list", ls_po_list)


adw_bol.SetRedraw(false)

long ll_height

ll_height = long(adw_bol.Describe("DataWindow.detail.height"))

ll_height = ll_height + li_offset

adw_bol.Modify("DataWindow.detail.height="+string(ll_height))

adw_bol.SetRedraw(true)


//-- End Multi-PO

RETURN 1
end function

public function integer uf_process_bol_3com ();Long	llCount, llRowCount, llRowPos, llBoxCount
Decimal ldWeight,ld_tot
String	lsInvoiceNo, lsDONO,	lsBOLDesc,ls_wh_code,ls_shipper,ls_bol_carrier, lsCustPO, lsTemp, lsFind
string ls_note,ls_carrier,ls_carrier_code, ls_weight,        		lsCarton, lsCartonPRev	 //GAP 9/26/03
string ls_type,ls_name, ls_address_1,ls_address_2,ls_address_3,ls_address_4,ls_city,ls_state,ls_country,ls_zip, lsWHName 
int li_rtn,i,li_row

// 04/04 - PCONKL - SIN uses pre-printed shippers letter of intent instead of BOL
Choose Case Upper (w_do.idw_main.GetITemString(1,'wh_Code'))		
	Case '3COM-SIN'
		w_do.tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_3com_sli_prt'
	Case Else
		
		// 01/08 - PCONKL - If a TippingPoint ORder, use the TiP BOL
		If w_do.idw_main.GetITemString(1,'ord_type') = 'P' /*Tipping Point */ Then
			//Jxlim 05/18/2010  us hp data object for Nashville since the 3COM has renamed to Hp on this report.
			//w_do.tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_3com_tp_bol_prt'			
			If w_do.idw_main.GetITemString(1,'wh_Code') = 'NASHVILLE' Then
				w_do.tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_hp_tp_bol_prt'
			else
				w_do.tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_3com_tp_bol_prt'
			End If
		Else
			//Jxlim 05/05/2010  us hp data object since the 3COM has renamed to Hp on this report.
			If w_do.idw_main.GetITemString(1,'wh_Code') = 'NASHVILLE' Then
				w_do.tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_hp_bol_prt'
			else
				w_do.tab_main.tabpage_bol.dw_bol_prt.dataobject = 'd_3com_bol_prt'
			End If
		End If
			//Jxlim 05/05/2010 end of changed for hp dataobject.
End CHoose

ls_wh_code= w_do.idw_main.object.wh_code[1]
lsDONO = w_do.idw_main.GetITemString(1,"do_no")                    //wason 9/25

w_do.tab_main.tabpage_bol.dw_bol_prt.settransobject(sqlca)         //wason 9/25
w_do.tab_main.tabpage_bol.dw_bol_prt.Retrieve(lsDONO)              //wason 9/25

If w_do.tab_main.tabpage_bol.dw_bol_prt.RowCount() = 0 Then       //wason 9/25
	w_do.tab_main.tabpage_bol.dw_bol_prt.InsertRow(0)              //wason 9/25
End If                                                       		//wason 9/25
		
//01/08 - PCONKL - If TippingPoint, we need to replace 3COM with TippingPoint in the Ship From Name
If w_do.idw_main.GetITemString(1,'ord_type') = 'P' /*Tipping Point */ Then

	lsWHName = w_do.tab_main.tabpage_bol.dw_bol_prt.GetITemString(1,'warehouse_wh_name')

	If Pos(Upper(lsWhName),'3COM') > 0 Then
		lsWhName = Replace(lsWhName,Pos(Upper(lsWhName),'3COM'),4,'TippingPoint')
	End If
	
	For llRowPos = 1 to w_do.tab_main.tabpage_bol.dw_bol_prt.RowCount()
		w_do.tab_main.tabpage_bol.dw_bol_prt.SetItem(llRowPos,'warehouse_wh_name',lsWHNAme)
		w_do.tab_main.tabpage_bol.dw_bol_prt.SetItem(llRowPos,'warehouse_wh_name_1',lsWHNAme)
	Next
	
End If /* Tipping Point*/

//gap 9/25/03 (pacific) Moved some of Wason's code from ue_printbol to show on screen before printing
select address_type,name, address_1, address_2, address_3, address_4, city, state, zip, country		
into :ls_type,:ls_name,:ls_address_1,:ls_address_2,:ls_address_3,:ls_address_4,:ls_city,:ls_state,:ls_zip,:ls_country 
from delivery_alt_address 
where project_id= :gs_project and do_no = :lsDONO and address_type = 'IT';

if ls_type='IT' then
 	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_cust_name',ls_name)
   w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_address_1',ls_address_1)
   w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_address_2',ls_address_2)
	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_address_3',ls_address_3) //GAP 9/26
   w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_address_4',ls_address_4) //GAP 9/26
	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_city',ls_city)
	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_state',ls_state)
	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_country',ls_country)
	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'delivery_master_zip',ls_zip)
end if

//gap 9/26/03 get Carrier Name from Carrier table
ls_carrier_code = w_do.idw_main.GetITemString(1,"carrier")         //GAP 9/26/03
SELECT carrier_name
into :ls_carrier
FROM carrier_master
WHERE 	( carrier_master.project_id = :gs_project )    AND  
   		( carrier_master.carrier_code = :ls_carrier_code );
			
If isnull(ls_carrier)  or ls_carrier = "" Then ls_carrier = ls_carrier_code

ls_note = w_do.idw_main.GetITemString(1,"packlist_notes") /* 09/04 - PCONKL - Take from DO Screen (loaded in sweeper) */

//gap 9/25 pacific
If w_do.idw_pack.RowCount() > 0 Then																// gap 10/03
	ls_weight = String(w_do.idw_pack.GetItemNumber(1,"c_weight")) // gap 10/03
else
	ls_weight =  "0"
end if 		

// gap 10/03
w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "ActualWeight",ls_weight) // gap 10/03
w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "carrier",ls_carrier)	
w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "special",ls_note)

If w_do.idw_main.GetITemString(1,'wh_Code') = '3COM-SIN' Then
	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1,'Prono',w_do.idw_main.GetITemString(1,'awb_Bol_no'))
End If

// 03/05 - PCONKL - Customer PO's being loaded from Delivery Detail UF 5, not Customer Order number (unless it is not present on DD)
llRowCount = w_do.idw_Detail.RowCount()
For lLRowPos = 1 to llRowCount
	
	If w_do.idw_Detail.GetITemString(lLRowPos,'user_field5') > '' Then
		lsFind = ' ' + w_do.idw_Detail.GetITemString(lLRowPos,'user_field5') + ','
		If Pos(lsCustPo,lsFind) = 0 Then /*only need to print once per PO */
			lsCustPo += w_do.idw_Detail.GetITemString(lLRowPos,'user_field5') + ", "
		End If
		
	End If
	
Next /*delivery_detail Record*/

//If not present on Details, Take from header
If lsCustPo > '' Then
	lsCustPO = Left(lsCustPO,(len(lsCustPo) - 2)) /*strip off last comma*/
Else
	lsCustPo = w_do.idw_main.GetITemString(1,'cust_order_no')
End If

//We may need to break the Cust PO list onto multiple lines
If len(lsCustPO) > 40 Then
	
	//First row of 40
	lsTemp = Right(lsCustPo,40)
	lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "c_cust_po1",lstemp)
	lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
	
	//2nd row of 40
	If len(lsCustPo) > 40 Then
		lsTemp = Right(lsCustPo,40)
		If pos(lsTemp,',') > 0 Then
			lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
		End If
	Else
		lsTemp = lsCustPo
	End If
	
	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "c_cust_po2",lstemp)
	lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
	
	//3rd row of 40
	If len(lsCustPo) > 40 Then
		lsTemp = Right(lsCustPo,40)
		If pos(lsTemp,',') > 0 Then
			lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
		End If
	Else
		lsTemp = lsCustPo
	End If
	
	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "c_cust_po3",lstemp)
	lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
	
	//4th row of 40
	If len(lsCustPo) > 40 Then
		lsTemp = Right(lsCustPo,40)
		If pos(lsTemp,',') > 0 Then
			lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
		End If
	Else
		lsTemp = lsCustPo
	End If
	
	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "c_cust_po4",lstemp)
	lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
	
	//5th row of 40
	If len(lsCustPo) > 40 Then
		lsTemp = Right(lsCustPo,40)
		If pos(lsTemp,',') > 0 Then
			lsTemp = Mid(lsTemp,(pos(lsTemp,',') + 2),40)
		End If
	Else
		lsTemp = lsCustPo
	End If
	
	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "c_cust_po5",lstemp)
	lsCustPo = Left(lsCustPo,(len(lsCustPo) - len(lsTemp)))
	
Else
	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem( 1, "c_cust_po1",lsCustPO)
End If

//03/07 - PCONKL - Calculate Pallet and Box Count
Select Count(distinct carton_no) into :llCount
From Delivery_packing
Where do_no = :lsDONO and carton_type like "pallet%";

If llCount > 0 Then
	
	w_do.tab_main.tabpage_bol.dw_bol_prt.SetITem(1,'pallets', string(llCOunt))
	
	//Scroll through packing and sum box count (UF1) for unique carton 
	llRowCount = w_do.idw_Pack.RowCount()
	For lLRowPos = 1 to llRowCount
		
		If w_do.idw_Pack.GetITEmString(llRowPos,'carton_no') <> lsCartonPrev Then
			
			If isNumber(Trim(w_do.idw_Pack.GetITEmString(llRowPos,'user_Field1'))) Then
				llBoxCount += Long(Trim(w_do.idw_Pack.GetITEmString(llRowPos,'user_Field1')))
			End If
			
		End If
		
		lsCartonPrev = w_do.idw_Pack.GetITEmString(llRowPos,'carton_no')
		
	Next
	
	w_do.tab_main.tabpage_bol.dw_bol_prt.SetITem(1,'cartons', string(llBoxCount))
	
Else
	
	Select Count(distinct carton_no) into :llCount
	From Delivery_packing
	Where do_no = :lsDONO ;
	
	w_do.tab_main.tabpage_bol.dw_bol_prt.SetITem(1,'pallets', '0')
	w_do.tab_main.tabpage_bol.dw_bol_prt.SetITem(1,'cartons', string(llCOunt))
	
End IF
w_do.tab_main.tabpage_bol.dw_bol_prt.accepttext()							 //wason 9/25
			
w_do.tab_main.tabpage_bol.cb_bol_print.Enabled = True /*Enable printing of BOL*/	

Return 0	
end function

public function string fu_quotestring (string quote_string, string quote_char);
//******************************************************************
//  PO Module     : n_POManager
//  Function      : fu_QuoteString
//  Description   : Adds the PowerBuilder escape character ("~")
//                  to prevent PowerBuilder from doing special
//                  interpetion of the character specifed by
//                  Quote_Char.
//
//  Parameters    : STRING Quote_String -
//                     The string that needs to be quoted.
//
//                  STRING Quote_Char
//                     The character to be quoted.
//
//  Return Value  : STRING -
//                     The result of the quoting operation.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//

BOOLEAN  l_Quoted
Long  l_StartPos, l_Idx
long		l_QuotePos, l_length
STRING   l_QuotedChar, l_FixedStr, l_TmpChar, &
			lqA1			

//------------------------------------------------------------------
//  See if there are any characters to be quoted in Quote_String.
//  If there are not, then we can just return Quote_String.
//------------------------------------------------------------------

l_QuotePos = Pos(Quote_String, Quote_Char)
l_length = len(quote_string)
IF l_QuotePos = 0 THEN
   l_FixedStr = Quote_String
   RETURN l_FixedStr
END IF

lqa1 = Mid(Quote_String, l_quotepos - 40, 200)

//------------------------------------------------------------------
//  For every character to be quoted in Fix_String, we need to
//  precede it with the PowerBuilder quote character (~), if it
//  has not already been quoted.
//------------------------------------------------------------------

l_FixedStr   = ""
l_StartPos   = 1
l_QuotedChar = "~~" + Quote_Char

DO WHILE l_QuotePos > 0

   //---------------------------------------------------------------
   //  We found a character that needs to be quoted.  Make sure
   //  that it is not already quoted.
   //---------------------------------------------------------------

   l_Quoted = FALSE
   IF l_QuotePos > 1 THEN
      l_Idx     = l_QuotePos - 1
      l_TmpChar = Mid(Quote_String, l_Idx, 1)

      DO WHILE l_TmpChar = "~~"
         l_Quoted = (NOT l_Quoted)
         l_Idx    = l_Idx - 1
         IF l_Idx > 0 THEN
            l_TmpChar = Mid(Quote_String, l_Idx, 1)
         ELSE
            l_TmpChar = ""
         END IF
      LOOP
   END IF

   //---------------------------------------------------------------
   //  If the character has not already been quoted, then add
   //  the string and the quoted character.
   //---------------------------------------------------------------

   IF NOT l_Quoted THEN
      l_FixedStr = l_FixedStr +                   &
                   Mid(Quote_String, l_StartPos,    &
                       l_QuotePos - l_StartPos) + &
                   l_QuotedChar
      l_StartPos = l_QuotePos + 1
   END IF

   //---------------------------------------------------------------
   //  Find the next character to be quoted.
   //---------------------------------------------------------------

   l_QuotePos = Pos(Quote_String, Quote_Char, l_QuotePos + 1)
LOOP

//------------------------------------------------------------------
//  Add what remains of the string after the last quoted character.
//------------------------------------------------------------------

l_FixedStr = l_FixedStr + Mid(Quote_String, l_StartPos)

RETURN l_FixedStr
end function

public function integer uf_process_bol_phxbrands (string as_dono, ref datawindow adw_bol);/*dts - 4/27/05: 
  This is in a state of migration from original manual, all-in-detail method
    to header/detail/footer method to allow for multiple pages
    PHX wanted it moved to production even though questions remained (about updatable fields, footer position, etc.)
  Still need to tie up loose ends, but I suspect that we'll be going back
    to (modified) manual method so work-in-progress remains.
*/               
integer li_current_id = 45  //Last Column ID in the select to know where to start.
integer li_start_y = 1308, li_y, li_height = 72, li_space = 76, li_start_tab = 30, li_tab_order, li_offset
//integer li_start_y = 191, li_y, li_height = 72, li_space = 76, li_start_tab = 30, li_tab_order, li_offset
LONG    ll_nbrobjects
string  ls_dwobjs[]
string  ls_objects
string ls_col_name, ls_cust_name
integer li_tab, i
integer li_change_tab[], li_max_tab, li_min_tab
string ls_change_tab[], ls_change_tab_temp[]
integer i2, li_rtn2, li_idx
string ls_cust_code, ls_cust_order_no
string ls_select
datastore lds_ds, lds_po, lds_po_multi, lds_notes
integer li_rtn_item, li_idx_rtn_item, li_from_pos
string ls_po
boolean lb_multi_run
integer li_rtn3
integer li_idx2
string ls_po_list
string ls_add_select, ls_new_select
string ls_add_column
string ls_add_table
string ls_add_table_column
string ls_compute_piece, ls_compute_weight, ls_compute_charge
string ls_syntax
integer li_retrive_pos, li_text_pos
integer li_qty 
string ls_desc
double ld_weight
string ls_tab_change
string ls_last_col
string ls_chep_pallets, ls_notes, ls_dono, ls_note_separator, ls_chep_pallets_half, lsChepMsg,lsWhiteWoodPallet,lsWhiteWoodMsg
long	 ll_count, ll_row

string ls_po_temp[], ls_reset_po_temp[]	
boolean ib_found
integer p
integer li_note_ht
integer li_offset_notes, li_len

//Jxlim 08/25/2010 Modified for PHXBrands Family Dollar BOL report
ls_cust_name = w_do.idw_main.GetItemString(1, 'Cust_name')
li_len = Len( "FAMILY DOLLAR")

If Mid(ls_cust_name, 1, li_len) = "FAMILY DOLLAR" Then
	adw_bol.dataobject = "d_phxbrands_bol_family_dollar_prt"
Else
	adw_bol.dataobject = "d_phxbrands_bol_prt"
End If
//Jxlim 08/25/2010 End of modified for PHXBrands Family Dollar BOL report

adw_bol.SetTransObject(SQLCA)
	
	li_y = li_start_y
	li_tab_order = li_start_tab
	
	//dts 4/5/05 - changed ll_row_per_page from 5 to 7
	long ll_row_per_page = 7, ll_num_total_rows
	
	//if mod(li_rtn_item, ll_row_per_page) <> 0 then
	
		//dts ll_num_total_rows = (1 + (integer((li_rtn_item/ll_row_per_page)))) * ll_row_per_page
		ll_num_total_rows = max(ll_row_per_page, li_rtn_item)
	
	//end if
	

//Retrieve the report

//adw_bol.SetTransObject(sqlca)

//adw_bol.Retrieve(gs_project, as_dono)
li_rtn_item = adw_bol.Retrieve(gs_project, as_dono) //lds_ds.Retrieve(as_dono, gs_project)
	// Add 1 row for chep pallets(user_field9)
	//  - and/or for Half Pallets (user_field11)
	If w_do.idw_other.RowCount() > 0 Then
		
		
		lsWhiteWoodPallet = ''
		
		lsWhiteWoodPallet = w_do.idw_other.GetItemString(1,"user_field21")
		
		if len(lsWhiteWoodPallet)  = 0 or lsWhiteWoodPallet = '' or isnull(lsWhiteWoodPallet)  then 
			lsWhiteWoodPallet = '0'
		end if
		
	
//		If isnumber(lsWhiteWoodPallet) Then lsWhiteWoodMsg = lsWhiteWoodPallet + " - White Wood Pallets"

		
		
		
		lsChepMsg = ''
		ls_chep_pallets = w_do.idw_other.GetItemString(1,"user_field9")
		If isnumber(ls_chep_pallets) Then
			lsChepMsg = ls_chep_pallets + " - Chep Pallets"
			/* Adding this row below, with the combined 'CHEP' and 'HALF' pallet info
			//li_rtn_item = adw_bol.InsertRow(0)
			//dwcontrol.RowsCopy ( long startrow, long endrow, DWBuffer copybuffer, datawindow targetdw, long beforerow, DWBuffer targetbuffer)
			//li_rtn_item = adw_bol.RowsCopy (1, 1, Primary!, adw_bol, 99, Primary!)
			adw_bol.RowsCopy (1, 1, Primary!, adw_bol, li_rtn_item +1, Primary!)
			//lds_ds.setitem(li_rtn_item,'group_desc',"Chep Pallets")
			adw_bol.setitem(li_rtn_item + 1,'units',0)
			adw_bol.setitem(li_rtn_item + 1,'group_desc',ls_chep_pallets + " - Chep Pallets")
			//adw_bol.setitem(li_rtn_item,'item_weight',0)
			adw_bol.setitem(li_rtn_item + 1,'weight',0)
			adw_bol.setitem(li_rtn_item + 1,'rate',0)
			//lds_ds.setitem(li_rtn_item,'item_quantity',integer(ls_chep_pallets))
			//adw_bol.setitem(li_rtn_item,'item_quantity','')
			//adw_bol.setitem(li_rtn_item,'units','')
			// pvh
			li_rtn_item ++
			*/
		end if 	
		
		// dts - 06/14/06 - Capturing Half Pallets in UF11
		ls_chep_pallets_half = w_do.idw_other.GetItemString(1,"user_field11")
		If IsNumber(ls_chep_pallets_half) and integer(ls_chep_pallets_half) > 0 Then
			lsChepMsg += ",  " + ls_chep_pallets_half + " - Half Pallets"
			/* Adding this row below, with the combined 'CHEP' and 'HALF' pallet info
			adw_bol.RowsCopy (1, 1, Primary!, adw_bol, li_rtn_item +1, Primary!)
			adw_bol.setitem(li_rtn_item + 1,'units',0)
			adw_bol.setitem(li_rtn_item + 1,'group_desc',ls_chep_pallets_half + " - Half Pallets")
			adw_bol.setitem(li_rtn_item + 1,'weight',0)
			adw_bol.setitem(li_rtn_item + 1,'rate',0)
			li_rtn_item ++
			*/
		end if
		
//SARUN2015JUNE29 :1st row should be displayed as $$HEX2$$1c202000$$ENDHEX$$1 Packing List$$HEX2$$1d202000$$ENDHEX$$(1 is by default value and no hyphen is required		

//		li_rtn_item = adw_bol.insertrow(0)	//SARUN2015SEP10 : MINOR CORRECTION
//30-Sep-2015 :Madhu- Display Pack List only for Customer # C & S
	IF Pos(left(ls_cust_name,5), "C & S") > 0 THEN
		adw_bol.RowsCopy (1, 1, Primary!, adw_bol, li_rtn_item +1, Primary!)				
		adw_bol.setitem(li_rtn_item + 1,'units',1)			
		adw_bol.setitem(li_rtn_item + 1,'group_desc',"Pack List")
		adw_bol.setitem(li_rtn_item + 1,'weight',0)
		adw_bol.setitem(li_rtn_item + 1,'rate',0)

		li_rtn_item ++
	END IF

//SARUN2015JUNE29 : 2nd row should be displayed as $$HEX2$$1c202000$$ENDHEX$$XX White wood Pallets$$HEX2$$1d202000$$ENDHEX$$(XX refers to the count). If no White wood pallets are available, display it as 0 White wood Pallets
//30-Sep-2015 :Madhu- Display White Wood Pallets only for Customer # C & S
		if lsWhiteWoodPallet > ''  and Pos(left(ls_cust_name,5), "C & S") > 0 then
//			li_rtn_item = adw_bol.insertrow(0)
			adw_bol.RowsCopy (1, 1, Primary!, adw_bol, li_rtn_item +1, Primary!)				
			adw_bol.setitem(li_rtn_item + 1,'units',long(lsWhiteWoodPallet)			)
			adw_bol.setitem(li_rtn_item + 1,'group_desc',"White Wood Pallets")
			adw_bol.setitem(li_rtn_item + 1,'weight',0)
			adw_bol.setitem(li_rtn_item + 1,'rate',0)
			li_rtn_item ++
		end if
		
//SARUN2015JUNE29 :		3rd row should be displayed as $$HEX2$$1c202000$$ENDHEX$$XX CHEP Pallets$$HEX2$$1d202000$$ENDHEX$$(XX refers to the count). If no White wood pallets are available, display it as 0 CHEP Pallets
		if lsChepMsg > '' then
//			li_rtn_item = adw_bol.insertrow(0)
			adw_bol.RowsCopy (1, 1, Primary!, adw_bol, li_rtn_item +1, Primary!)
			//20-Nov-2015 :Madhu- Added, Non C&S customers, display CHEP or White Wood Pallets in a single row -START
			If Pos(left(ls_cust_name,5), "C & S") > 0 then
				adw_bol.setitem(li_rtn_item + 1,'units',long(ls_chep_pallets))
				adw_bol.setitem(li_rtn_item + 1,'group_desc',"Chep Pallets")
			else
				adw_bol.setitem(li_rtn_item + 1,'units',0)
				adw_bol.setitem(li_rtn_item + 1,'group_desc',"Chep or White Wood Pallets")
			end if
			//20-Nov-2015 :Madhu- Added, Non C&S customers, display CHEP or White Wood Pallets in a single row -END
			adw_bol.setitem(li_rtn_item + 1,'weight',0)
			adw_bol.setitem(li_rtn_item + 1,'rate',0)
			li_rtn_item ++
		end if

// pvh 02.16.06
//, if carrier = WICO, replace the Remit To name and address with COLLECT
		if 	Upper( getcarrier() ) = 'WICO' then
			adw_bol.object.project_client_name[ li_rtn_item ] = 'COLLECT'
			adw_bol.object.project_address_1[ li_rtn_item ] = ''
			adw_bol.object.project_address_2[ li_rtn_item ] = ''
			adw_bol.object.project_address_3[ li_rtn_item ] = ''
			adw_bol.object.project_city[ li_rtn_item ] = ''
			adw_bol.object.project_state[ li_rtn_item ] = ''
			adw_bol.object.project_zip[ li_rtn_item ] = ''
			adw_bol.object.project_country[ li_rtn_item ] = ''
		end if
// pvh 02.16.06 - EOM
	end if 		


	//***NOTES***//
	//populate Delivery Notes - not done automatically since dw not being retrieved
			ls_DONO = w_do.idw_main.GetItemString(1,"do_no")
	
			lds_notes = Create datastore
			lds_notes.DataObject = 'd_phxbrands_bol_notes'
			lds_notes.SetTransObject(sqlca)
			ll_count = lds_notes.Retrieve(gs_project, ls_DONO) 			
	
	/*Loop through each row in notes and populate columns on BOL
	  - if there are more than 7 lines of notes, don't create new line for each
	    but just string them together instead (with some spaces in between) */
		ls_notes = ''
		if ll_count > 7 then
			ls_note_separator = '   '
		else
			ls_note_separator = '~r'
		end if
		For ll_row = 1 to ll_count
			ls_notes += lds_notes.GetItemString(ll_row,'Note_Text') + ls_note_separator
		Next
		
		//Need to handle Ampersands

		integer li_pos
		
		li_Pos = 1
		
		DO
			
			li_Pos = Pos(ls_notes, "&", li_Pos)
			
			if li_Pos > 0 then
	
				ls_notes = left(ls_notes, li_Pos) + "&" + mid(ls_notes, li_Pos + 1)
				
				li_Pos = li_Pos + 2
			
			end if
			
		LOOP UNTIL li_pos = 0 or li_pos >= len(ls_notes)

		
		adw_bol.Modify("t_notes.text='" + ls_notes + "'")
		
RETURN 1
end function

public function integer uf_process_bol_linksys (string as_dono, ref datawindow adw_bol);integer li_current_id = 52  //Last Column ID in the select to know where to start.
integer li_start_y = 1950, li_y, li_height = 100, li_space = 104, li_start_tab = 30, li_tab_order, li_offset
LONG    ll_nbrobjects
string  ls_dwobjs[]
string  ls_objects
string ls_col_name
integer li_tab, i
integer li_change_tab[], li_max_tab, li_min_tab
string ls_change_tab[], ls_change_tab_temp[]
integer i2, li_rtn2, li_idx
string ls_cust_code, ls_cust_order_no
string ls_select
datastore lds_ds, lds_po, lds_po_multi
integer li_rtn_item, li_idx_rtn_item, li_from_pos
string ls_po
boolean lb_multi_run
integer li_rtn3
integer li_idx2
string ls_po_list
string ls_add_select, ls_new_select
string ls_add_column
string ls_add_table
string ls_add_table_column
string ls_compute_piece, ls_compute_weight
string ls_syntax
integer li_retrive_pos
// pvh - 08/21/06 - used to be an int, large orders caused problems
long li_text_pos
integer li_alloc_qty 
string ls_invoice_no
double ld_quantity
string ls_tab_change
string ls_last_col

string ls_po_temp[], ls_reset_po_temp[]	
boolean ib_found
integer p

	
//Loop through and get old tab orders.

ls_objects = adw_bol.Describe('Datawindow.Objects')
	
of_parsetoArray(ls_objects,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)

//For i = 1 to ll_nbrobjects
//	
//	  li_tab = integer(adw_bol.Describe(ls_dwobjs[i]+'.TabSequence'))
//		ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
//
//	  if li_tab >= li_start_tab then
//			ls_change_tab[UpperBound(ls_change_tab)+1] = ls_col_name
//			li_change_tab[UpperBound(ls_change_tab)] = li_tab
//			
//			if li_tab > li_max_tab then
//				li_max_tab = li_tab
//			end if
//
//			if li_tab < li_min_tab then
//				li_min_tab = li_tab
//			end if
//			
//			
//	  end if
//NEXT



for i = li_min_tab to li_max_tab step 10
	
	for i2 = 1 to UpperBound(ls_change_tab)
		if i = li_change_tab[i2] then
			ls_change_tab_temp[UpperBound(ls_change_tab_temp) + 1] = ls_change_tab[i2]
			
			EXIT;		
		end if
	next
	
next

ls_change_tab = ls_change_tab_temp




lds_ds = CREATE datastore

lds_ds.dataobject = "d_linksys_bol_item_list"

lds_ds.SetTransObject(SQLCA)




//select cust_code,cust_order_no into :ls_cust_code,:ls_cust_order_no from delivery_master where do_no = :as_dono and project_id = :gs_project;


li_rtn_item = lds_ds.Retrieve(as_dono, gs_project)

li_y = li_start_y
li_tab_order = li_start_tab

long ll_row_per_page = 9, ll_num_total_rows

//if mod(li_rtn_item, ll_row_per_page) <> 0 then

	ll_num_total_rows = (1 + (integer((li_rtn_item/ll_row_per_page)))) * ll_row_per_page


//end if

for li_idx_rtn_item = 1 to ll_num_total_rows

	//Everything must in the correct order!

	ls_add_select = ls_add_select + ",   ~~~'                                 ~~~' as c_pallet"+string(li_idx_rtn_item) + ",   ~~~'                                 ~~~' as c_desc"+string(li_idx_rtn_item)   



	ls_add_table_column = ls_add_table_column + " column=(type=char(33) updatewhereclause=yes name=c_pallet"+string(li_idx_rtn_item)+" dbname=~"c_pallet"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=char(33) updatewhereclause=yes name=c_desc"+string(li_idx_rtn_item)+" dbname=~"c_desc"+string(li_idx_rtn_item)+"~" ) "
//															  + &
//															  " column=(type=char(33) updatewhereclause=yes name=c_freight_terms"+string(li_idx_rtn_item)+" dbname=~"c_freight_terms"+string(li_idx_rtn_item)+"~" ) " 

   ls_add_column = ls_add_column + " line(band=detail x1=~"160~" y1=~""+string(li_y)+"~" x2=~"160~" y2=~""+string(li_y + li_height + 10)+"~"  name=lines1"+string(li_idx_rtn_item)+" visible=~"1~" pen.style=~"0~" pen.width=~"5~" pen.color=~"0~"  background.mode=~"2~" background.color=~"16777215~" ) "
								
								

//	ls_add_column = ls_add_column + " line(band=detail x1=~"14~" y1="+string(li_y)+" x2=~"14~" y2=~"1616~"  name=l1_"+string(li_idx_rtn_item)+" visible=~"1~" pen.style=~"0~" pen.width=~"5~" pen.color=~"0~"  background.mode=~"2~" background.color=~"16777215~" )"


	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"0~" tabsequence=0 border=~"0~" color=~"0~" x=~"338~" y=~""+string(li_y)+"~" height=~"100~" width=~"850~" format=~"[general]~"  name=c_pallet"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-7~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	li_current_id = li_current_id + 1

	li_tab_order = li_tab_order + 1

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"0~" tabsequence=0 border=~"0~" color=~"0~" x=~"1216~" y=~""+string(li_y)+"~" height=~"100~" width=~"1431~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-7~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

//	ls_add_column = ls_add_column + " line(band=detail x1=~"283~" y1=~""+string(li_y)+"~" x2=~"283~" y2=~""+string(li_y + li_height + 10)+"~"  name=l2_"+string(li_idx_rtn_item)+" visible=~"1~" pen.style=~"0~" pen.width=~"5~" pen.color=~"0~"  background.mode=~"2~" background.color=~"16777215~" ) "
	ls_add_column = ls_add_column + " line(band=detail x1=~"283~" y1=~""+string(li_y)+"~" x2=~"283~" y2=~""+string(li_y + li_height + 10)+"~"  name=lines2"+string(li_idx_rtn_item)+" visible=~"1~" pen.style=~"0~" pen.width=~"5~" pen.color=~"0~"  background.mode=~"2~" background.color=~"16777215~" ) "

	ls_add_column = ls_add_column + " line(band=detail x1=~"2693~" y1=~""+string(li_y)+"~" x2=~"2693~" y2=~""+string(li_y + li_height + 10)+"~"  name=lines3"+string(li_idx_rtn_item)+" visible=~"1~" pen.style=~"0~" pen.width=~"5~" pen.color=~"0~"  background.mode=~"2~" background.color=~"16777215~" ) "
	
	
	

	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"0~" tabsequence=0 border=~"0~" color=~"0~" x=~"2519~" y=~""+string(li_y)+"~" height=~"100~" width=~"600~" format=~"[general]~"  name=c_freight_terms"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

//	li_current_id = li_current_id + 1
	
//	li_tab_order = li_tab_order + 1
	
	li_y = li_y + li_space
	
	li_offset = li_offset + li_space
	
	ls_last_col = "c_desc"+string(li_idx_rtn_item)

next

ls_syntax = adw_bol.Describe("DataWindow.Syntax")

ls_add_select = ls_add_select + " "


ls_select = adw_bol.Describe("Datawindow.Table.Select")

ls_new_select = ls_syntax

li_retrive_pos = Pos(lower(ls_new_select), "retrieve=")

ls_new_select = left( ls_new_select, li_retrive_pos - 1) + ls_add_table_column + mid( ls_new_select, li_retrive_pos - 1)



li_from_pos = POS(upper(ls_new_select), " FROM ")

ls_new_select = left( ls_new_select, li_from_pos - 2) + ls_add_select + mid( ls_new_select, li_from_pos - 2)  


li_text_pos = POS(lower(ls_new_select), "text(")

ls_new_select = left( ls_new_select, li_text_pos - 1) + ls_add_column + mid( ls_new_select, li_text_pos - 1)  

//ls_new_select = fu_quotestring(ls_new_select, "'")

	
adw_bol.Create(ls_new_select)

//Retrieve Carrie Datawindow

datawindowchild ldw_child

adw_bol.GetChild( "delivery_master_carrier", ldw_child)

ldw_child.SetTransObject(SQLCA)

ldw_child.Retrieve(gs_project)


//Retrieve the report

adw_bol.SetTransObject(sqlca)

//MessageBox ("ok", as_dono)

adw_bol.Retrieve(gs_project, as_dono)

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If



string ls_pallet, ls_desc, ls_freight_terms
	
//Set the default data.	

integer li_total_pallets, idx_pallet
boolean ib_pallet_found
string ls_sku, ls_freight_code


string ls_pallet_count[]

for li_idx_rtn_item = 1 to li_rtn_item

	ls_pallet = lds_ds.GetItemString( li_idx_rtn_item, "carton_no")
	ls_desc = lds_ds.GetItemString( li_idx_rtn_item, "description")
	ls_sku = trim(lds_ds.GetItemString( li_idx_rtn_item, "sku"))
//	ls_freight_terms = lds_ds.GetItemString( li_idx_rtn_item, "freight_terms")

	if IsNull(ls_sku) then ls_sku = ""

	ib_pallet_found = false

	for idx_pallet = 1 to UpperBound(ls_pallet_count)

		if trim(ls_pallet) = ls_pallet_count[idx_pallet] then
			ib_pallet_found = true
			exit
		end if

	next

	if not ib_pallet_found then
		ls_pallet_count[UpperBound(ls_pallet_count[])+1] = trim(ls_pallet)
	end if


	if NOT IsNull(ls_pallet) then &
		adw_bol.SetItem(adw_bol.GetRow(), "c_pallet" + string(li_idx_rtn_item), "PALLET # " +  ls_pallet )		
	if NOT IsNull(ls_desc) then &		
		adw_bol.SetItem(adw_bol.GetRow(), "c_desc" + string(li_idx_rtn_item), 'contains ' + ls_sku + ' ' + ls_desc )		
//	if NOT IsNull(ls_freight_terms) then &
//		adw_bol.SetItem(adw_bol.GetRow(), "c_freight_terms" + string(li_idx_rtn_item), ls_freight_terms )		





next
	
li_total_pallets = 	UpperBound(ls_pallet_count)
	
//Push Footer Down

ls_objects = adw_bol.Describe('Datawindow.Objects')

of_parsetoArray(ls_objects,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)

string ls_type

For i = 1 to ll_nbrobjects

		ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
		ls_type = trim(adw_bol.Describe(ls_dwobjs[i]+'.type'))


		if ls_type = "line" then
		   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y1'))
		else
		   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y'))
		end if
		

//			Messagebox ("ok", ls_col_name)

	  if (li_y >= li_start_y) and &
		  (left(ls_col_name, 6) <> "c_pall" and &
			left(ls_col_name, 6) <> "c_desc" and &
			left(ls_col_name, 6) <> "lines1" and &
			left(ls_col_name, 6) <> "lines2" and &
			left(ls_col_name, 6) <> "lines3") then

			if ls_type = "line"  then

				integer li_y_diff

				li_y_diff = long(adw_bol.Describe(ls_dwobjs[i] + ".y2")) - long(adw_bol.Describe(ls_dwobjs[i] + ".y1"))

				adw_bol.Modify(ls_dwobjs[i] + ".y1=" + string(li_y + li_offset) + " " + ls_dwobjs[i] + ".y2=" + string(li_y + li_offset + li_y_diff))

				
			else

				adw_bol.Modify(ls_dwobjs[i] + ".y=" + string(li_y + li_offset))
	
			end if
	
	  END IF
NEXT

//li_tab_order =  40//integer(adw_bol.describe(ls_last_col+".TabSequence")) + 1
//
//for i = 1 to UpperBound(ls_change_tab)
//	
//	adw_bol.modify(ls_change_tab[i]+".TabSequence=0")
//	
//	Messagebox ("ok", ls_change_tab[i])
//	
//	ls_tab_change = ls_tab_change + " " + ls_change_tab[i]+".TabSequence=" + string(li_tab_order) + " "
//
//	li_tab_order = li_tab_order + 10
//	
//next	

integer li_carton_count 


decimal ld_gross_weight, ld_net_weight, ld_tare_weight

if lds_ds.RowCount() > 0 then

	li_carton_count = lds_ds.GetItemNumber( 1, "total_carton_count") 

	adw_bol.SetItem(1, "enter_carton", li_carton_count)
	adw_bol.SetItem(1, "enter_carton_1", li_carton_count)

	adw_bol.SetItem(1, "enter_pallet", li_total_pallets)


//	adw_bol.Modify("t_total_carton.text='"+string(li_carton_count)+"'")
//	adw_bol.Modify("t_total_carton_2.text='"+string(li_carton_count)+"'")
//
//	adw_bol.Modify("t_total_pallet.text='"+string(li_total_pallets)+"'")
//

	ls_freight_code = Upper(w_do.idw_other.GetITemString(1,"freight_terms"))

	if IsNull(ls_freight_code) then 
		ls_freight_code = "DEFAULT"
		adw_bol.SetItem( adw_bol.GetRow(), "freight_terms", "DEFAULT")
	end if



	ld_gross_weight  = lds_ds.GetItemNumber( 1, "total_weight_gross")
	ld_net_weight  = lds_ds.GetItemNumber( 1, "total_weight_net")
	
	ld_tare_weight = ld_gross_weight - ld_net_weight
	
	adw_bol.Modify("t_gross_weight.text='"+string(ld_gross_weight, "####.0")+"'")
	adw_bol.Modify("t_net_weight.text='"+string(ld_net_weight, "####.0")+"'")
	adw_bol.Modify("t_tare_weight.text='"+string(ld_tare_weight, "####")+"'")




end if



adw_bol.SetRedraw(false)

long ll_height

ll_height = long(adw_bol.Describe("DataWindow.detail.height"))

ll_height = ll_height + li_offset

adw_bol.Modify("DataWindow.detail.height="+string(ll_height))

adw_bol.SetRedraw(true)





RETURN 1
end function

public function integer uf_print_bol_linksys ();

//Need to print a shipper's copy and a driver's copy.

w_do.idw_bol.Modify("t_copy_text.text = 'SHIPPER~~~'S COPY'")
	
OpenWithParm(w_dw_print_options,w_do.idw_bol) 

if message.DoubleParm <> -1 then
	
	w_do.idw_bol.Modify("t_copy_text.text = 'DRIVER~~~'S COPY'")
	
	w_do.idw_bol.Print()

end if

w_do.idw_bol.Modify("t_copy_text.text = ''")

Return 0
end function

public function integer uf_process_bol_logitech (string as_dono, ref datawindow adw_bol);integer li_current_id = 47  //Last Column ID in the select to know where to start.
integer li_start_y = 1308, li_y, li_height = 72, li_space = 76, li_start_tab = 30, li_tab_order, li_offset
LONG    ll_nbrobjects
string  ls_dwobjs[]
string  ls_objects
string ls_col_name
long li_tab, i
long li_change_tab[], li_max_tab, li_min_tab
string ls_change_tab[], ls_change_tab_temp[]
long i2, li_rtn2, li_idx
string ls_cust_code, ls_cust_order_no
string ls_select
datastore lds_ds, lds_po, lds_po_multi, lds_notes
long li_rtn_item, li_idx_rtn_item, li_from_pos
string ls_po
boolean lb_multi_run
long li_rtn3
long li_idx2
string ls_po_list
string ls_add_select, ls_new_select
string ls_add_column
string ls_add_table
string ls_add_table_column
string ls_compute_piece, ls_compute_weight, ls_compute_charge
string ls_syntax
long li_retrive_pos, li_text_pos
long li_qty 
string ls_desc
double ld_weight
string ls_tab_change
string ls_last_col
string ls_chep_pallets, ls_notes, ls_dono
long	 ll_count, ll_row

string ls_po_temp[], ls_reset_po_temp[]	
boolean ib_found
long p

adw_bol.dataobject = "d_logitech_bol_prt"

adw_bol.SetTransObject(SQLCA)
	
//Loop through and get old tab orders.

ls_objects = adw_bol.Describe('Datawindow.Objects')
	
of_parsetoArray(ls_objects,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)

For i = 1 to ll_nbrobjects
	
	  li_tab = integer(adw_bol.Describe(ls_dwobjs[i]+'.TabSequence'))
		ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')

	  if li_tab >= li_start_tab then
			ls_change_tab[UpperBound(ls_change_tab)+1] = ls_col_name
			li_change_tab[UpperBound(ls_change_tab)] = li_tab
			
			if li_tab > li_max_tab then
				li_max_tab = li_tab
			end if

			if li_tab < li_min_tab then
				li_min_tab = li_tab
			end if
			
			
	  end if
NEXT



for i = li_min_tab to li_max_tab step 10
	
	for i2 = 1 to UpperBound(ls_change_tab)
		if i = li_change_tab[i2] then
			ls_change_tab_temp[UpperBound(ls_change_tab_temp) + 1] = ls_change_tab[i2]
			
			EXIT;		
		end if
	next
	
next

ls_change_tab = ls_change_tab_temp




lds_ds = CREATE datastore

lds_ds.dataobject = "d_logitech_bol_group_details"

lds_ds.SetTransObject(SQLCA)


li_rtn_item = lds_ds.Retrieve(as_dono, gs_project)


//// Add 1 row for chep pallets(user_field9)
//If w_do.idw_other.RowCount() > 0 Then																
//	ls_chep_pallets = w_do.idw_other.GetItemString(1,"user_field9")
//	If isnumber(ls_chep_pallets) Then
//		li_rtn_item = lds_ds.InsertRow(0)
////		lds_ds.setitem(li_rtn_item,'group_desc',"Chep Pallets")
//		lds_ds.setitem(li_rtn_item,'item_weight',0)
//		lds_ds.setitem(li_rtn_item,'item_quantity',integer(ls_chep_pallets))
//	end if 		
//end if 		



li_y = li_start_y
li_tab_order = li_start_tab

long ll_row_per_page = 10, ll_num_total_rows

//if ll_num_total_rows = 0 then
//
//	ll_num_total_rows = ll_row_per_page
//
//else

	//if mod(li_rtn_item, ll_row_per_page) <> 0 then
	
		ll_num_total_rows = (1 + (integer((li_rtn_item/ll_row_per_page)))) * ll_row_per_page
		
//	end if
//end if

for li_idx_rtn_item = 1 to ll_num_total_rows

	//Everything must in the correct order!

	ls_add_select = ls_add_select + ", 0000 as c_pieces" + string(li_idx_rtn_item) + ", 0000 as c_pieces_2" + string(li_idx_rtn_item) + ", 0000 as c_pieces_3" + string(li_idx_rtn_item) +  ",   ~~~'                                 ~~~' as c_desc"+string(li_idx_rtn_item) + ", 0000.00 as c_weight"+string(li_idx_rtn_item) + ", '     ' as c_weight_ind"+string(li_idx_rtn_item) + ", ~~~'                                 ~~~' as c_ped_no" + string(li_idx_rtn_item) + ", ~~~'                                 ~~~' as c_coo "


 	ls_add_table_column = ls_add_table_column + " column=(type=long updatewhereclause=yes name=c_pieces"+string(li_idx_rtn_item)+" dbname=~"c_pieces"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=long updatewhereclause=yes name=c_pieces_2"+string(li_idx_rtn_item)+" dbname=~"c_pieces_2"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=long updatewhereclause=yes name=c_pieces_3"+string(li_idx_rtn_item)+" dbname=~"c_pieces_3"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=char(33) updatewhereclause=yes name=c_desc"+string(li_idx_rtn_item)+" dbname=~"c_desc"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_weight"+string(li_idx_rtn_item)+" dbname=~"c_weight"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=char(5) updatewhereclause=yes name=c_weight_ind"+string(li_idx_rtn_item)+" dbname=~"c_weight_ind"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=char(50) updatewhereclause=yes name=c_ped_no"+string(li_idx_rtn_item)+" dbname=~"c_ped_no"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=char(50) updatewhereclause=yes name=c_coo"+string(li_idx_rtn_item)+" dbname=~"c_coo"+string(li_idx_rtn_item)+"~" ) "

string ls_compute_piece_2, ls_compute_piece_3

if li_idx_rtn_item > 1 then ls_compute_piece = ls_compute_piece + " + "
ls_compute_piece 	= ls_compute_piece + " c_pieces" +string(li_idx_rtn_item)

if li_idx_rtn_item > 1 then ls_compute_piece_2 = ls_compute_piece_2 + " + "
ls_compute_piece_2 	= ls_compute_piece_2 + " c_pieces_2" +string(li_idx_rtn_item)

if li_idx_rtn_item > 1 then ls_compute_piece_3 = ls_compute_piece_3 + " + "
ls_compute_piece_3 	= ls_compute_piece_3 + " c_pieces_3" +string(li_idx_rtn_item)



	if li_idx_rtn_item > 1 then ls_compute_weight = ls_compute_weight + " + "
	ls_compute_weight	= ls_compute_weight + " c_weight" +string(li_idx_rtn_item)

	if li_idx_rtn_item > 1 then ls_compute_charge = ls_compute_charge + " + "
	ls_compute_charge	= ls_compute_charge + " c_pieces_rate_sub" +string(li_idx_rtn_item)




//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"100~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"5~" y=~""+string(li_y)+"~" height=~"72~" width=~"229~" format=~"#,###~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "


	li_current_id = li_current_id + 1

	li_tab_order = li_tab_order + 1


	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"238~" y=~""+string(li_y)+"~" height=~"72~" width=~"247~" format=~"#,###~"  name=c_pieces_2"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "


	li_current_id = li_current_id + 1

	li_tab_order = li_tab_order + 1
	

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"489~" y=~""+string(li_y)+"~" height=~"72~" width=~"229~" format=~"#,###~"  name=c_pieces_3"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "


	li_current_id = li_current_id + 1

	li_tab_order = li_tab_order + 1	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"100~" width=~"2162~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"722~" y=~""+string(li_y)+"~" height=~"72~" width=~"946~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2446~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1673~" y=~""+string(li_y)+"~" height=~"72~" width=~"361~"  name=t_filler"+string(li_idx_rtn_item)+" font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


												//text(band=detail alignment="2" text="COD FEE" border="2" color="0" x="1737" y="3856" height="100" width="480" html.valueishtml="0"  name=t_7 visible="1"  font.face="Arial" font.height="-9" font.weight="700"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912" )


	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"1673~" y=~""+string(li_y)+"~" height=~"72~" width=~"231~" format=~"###,###.##~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

//558

	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2446~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"1904~" y=~""+string(li_y)+"~" height=~"72~" width=~"130~" format=~"[general]~"  name=c_weight_ind"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	


	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2898~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2039~" y=~""+string(li_y)+"~" height=~"72~" width=~"489~" format=~"[general]~"  name=c_ped_no"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


	ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~" c_pieces"+string(li_idx_rtn_item)+" * c_coo"+string(li_idx_rtn_item)+" ~"border=~"2~" color=~"0~" x=~"2912~" y=~""+string(li_y)+"~" height=~"72~" width=~"434~" format=~"###,###.00~"  name=c_pieces_coo_sub"+string(li_idx_rtn_item)+"  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2898~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2533~" y=~""+string(li_y)+"~" height=~"72~" width=~"375~" format=~"[general]~"  name=c_coo"+string(li_idx_rtn_item)+" edit.limit=2 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "



	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
	
	li_y = li_y + li_space
	
	li_offset = li_offset + li_space
	
	ls_last_col = "c_coo"+string(li_idx_rtn_item)

next


ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece+"~" border=~"2~" color=~"0~" x=~"5~" y=~""+string(li_y)+"~" height=~"72~" width=~"229~" format=~"#,##0~"  name=c_piece_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece_2 +"~" border=~"2~" color=~"0~" x=~"238~" y=~""+string(li_y)+"~" height=~"72~" width=~"247~" format=~"#,##0~"  name=c_piece_total_2  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece_3 +"~" border=~"2~" color=~"0~" x=~"489~" y=~""+string(li_y)+"~" height=~"72~" width=~"229~" format=~"#,##0~"  name=c_piece_total_3  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1673~" y=~""+string(li_y)+"~" height=~"72~" width=~"361~"  name=t_filler_weight font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~""+ls_compute_weight+"~" border=~"0~" color=~"0~" x=~"1673~" y=~""+string(li_y)+"~" height=~"72~" width=~"231~" format=~"###,###.00~"  name=c_weight_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

string ls_delivery_packing_standard_of_measure_1

if lds_ds.RowCount() > 0 then
	//ls_delivery_packing_standard_of_measure_1 = lds_ds.GetItemString( 1, "delivery_packing_standard_of_measure")

//	if Isnull(ls_delivery_packing_standard_of_measure_1) then ls_delivery_packing_standard_of_measure_1 = ""

//	CHOOSE CASE Upper(ls_delivery_packing_standard_of_measure_1)
//	CASE 'M'
		ls_delivery_packing_standard_of_measure_1 = "Kgs"
//	CASE 'E'
//		ls_delivery_packing_standard_of_measure_1 = "Lbs"
//	END CHOOSE

	ls_add_column = ls_add_column + " text(band=detail alignment=~"1~" text=~""+ls_delivery_packing_standard_of_measure_1+"~" border=~"0~" color=~"0~" x=~"1904~" y=~""+string(li_y)+"~" height=~"72~" width=~"130~"  name=t_filler_weight_total font.face=~"Arial~" font.height=~"-8~" font.weight=~"130~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

end if




li_offset = li_offset + li_space


ls_syntax = adw_bol.Describe("DataWindow.Syntax")

ls_add_select = ls_add_select + " "


ls_select = adw_bol.Describe("Datawindow.Table.Select")

ls_new_select = ls_syntax

li_retrive_pos = Pos(lower(ls_new_select), "retrieve=")

ls_new_select = left( ls_new_select, li_retrive_pos - 1) + ls_add_table_column + mid( ls_new_select, li_retrive_pos - 1)

//	Messagebox (string(li_retrive_pos), ls_new_select)


li_from_pos = POS(upper(ls_new_select), " FROM ")

ls_new_select = left( ls_new_select, li_from_pos - 2) + ls_add_select + mid( ls_new_select, li_from_pos - 2)  


li_text_pos = POS(lower(ls_new_select), "text(")

ls_new_select = left( ls_new_select, li_text_pos - 1) + ls_add_column + mid( ls_new_select, li_text_pos - 1)  

ls_new_select = fu_quotestring(ls_new_select, "'")


//	MessageBox ("newselect", ls_new_select)
	
adw_bol.Create(ls_new_select)


adw_bol.Modify("c_total.Expression='"+ls_compute_charge+"'")

//Retrieve the report

adw_bol.SetTransObject(sqlca)

adw_bol.Retrieve(gs_project, as_dono)

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

	
//Set the default data.	

string ls_delivery_packing_standard_of_measure

integer li_case_qty, li_cont_qty


for li_idx_rtn_item = 1 to li_rtn_item

	
	li_qty = lds_ds.GetItemNumber( li_idx_rtn_item, "item_quantity")
	li_case_qty = lds_ds.GetItemNumber( li_idx_rtn_item, "case_count")
	li_cont_qty = lds_ds.GetItemNumber( li_idx_rtn_item, "sku_carton_count")

	ls_desc = lds_ds.GetItemString( li_idx_rtn_item, "item_master_sku")
	
	//ld_weight = li_Qty * lds_ds.GetITemNumber(li_idx_rtn_item,'item_master_weight_1') //23-Sep-2013 :Madhu commented -Weights into BOL. CR
	//ld_weight = lds_ds.GetItemNumber( li_idx_rtn_item, "item_weight")
	ld_weight =li_case_qty * lds_ds.GetITemNumber(li_idx_rtn_item,'item_master_weight_1')   //23-Sep-2013 :Madhu Added -Weights into BOL. CR

	string ls_lot_no, ls_coo

	ls_lot_no = lds_ds.GetItemString( li_idx_rtn_item, "delivery_picking_lot_no")
	ls_coo = lds_ds.GetItemString( li_idx_rtn_item, "delivery_picking_country_of_origin")


	//ls_delivery_packing_standard_of_measure = lds_ds.GetItemString( li_idx_rtn_item, "delivery_packing_standard_of_measure")

	//CHOOSE CASE Upper(ls_delivery_packing_standard_of_measure)
	//CASE 'M'
		ls_delivery_packing_standard_of_measure = "Kgs"
	//CASE 'E'
	//	ls_delivery_packing_standard_of_measure = "Lbs"
	//END CHOOSE


	if NOT IsNull(li_qty) then &
		adw_bol.SetItem(adw_bol.GetRow(), "c_pieces" + string(li_idx_rtn_item), li_case_qty )		

	if NOT IsNull(li_qty) then &
		adw_bol.SetItem(adw_bol.GetRow(), "c_pieces_2" + string(li_idx_rtn_item), li_cont_qty )		

	if NOT IsNull(li_qty) then &
		adw_bol.SetItem(adw_bol.GetRow(), "c_pieces_3" + string(li_idx_rtn_item), li_qty )		


	
	
	if NOT IsNull(ls_desc) then &		
		adw_bol.SetItem(adw_bol.GetRow(), "c_desc" + string(li_idx_rtn_item), ls_desc )		
	if NOT IsNull(ld_weight) then &
		adw_bol.SetItem(adw_bol.GetRow(), "c_weight" + string(li_idx_rtn_item), ld_weight )		

	if NOT IsNull(ls_lot_no) then &
		adw_bol.SetItem(adw_bol.GetRow(), "c_ped_no" + string(li_idx_rtn_item), ls_lot_no )		
	if NOT IsNull(ls_coo) then &
		adw_bol.SetItem(adw_bol.GetRow(), "c_coo" + string(li_idx_rtn_item), ls_coo )		





	if NOT IsNull(ls_delivery_packing_standard_of_measure) then &
		adw_bol.SetItem(adw_bol.GetRow(), "c_weight_ind" + string(li_idx_rtn_item), ls_delivery_packing_standard_of_measure )		


next

//***NOTES***//
//populate Delivery Notes - not done automatically since dw not being retrieved
		ls_DONO = w_do.idw_main.GetITemString(1,"do_no")

		lds_notes = Create datastore
		lds_notes.DataObject = 'd_phxbrands_bol_notes'
		lds_notes.SetTransObject(sqlca)
		ll_count = lds_notes.Retrieve(gs_project, ls_DONO) 			

//Loop through each row in notes and populate columns on BOL
	ls_notes = ''

	For ll_row = 1 to ll_count
		ls_notes += lds_notes.GetItemString(ll_row,'Note_Text') + '~r'
	Next

	w_do.tab_main.tabpage_bol.dw_bol_prt.setitem(1,'c_notes',ls_notes)
	
	
	
	
//Push Footer Down

ls_objects = adw_bol.Describe('Datawindow.Objects')

of_parsetoArray(ls_objects,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)

string ls_type

For i = 1 to ll_nbrobjects

		ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
		ls_type = trim(adw_bol.Describe(ls_dwobjs[i]+'.type'))


		if ls_type = "line" then
		   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y1'))
		else
		   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y'))
		end if
		

//			Messagebox ("ok", ls_col_name)

	  if (li_y >= li_start_y) and &
		  (left(ls_col_name, 6) <> "c_piec" and &
			left(ls_col_name, 6) <> "c_desc" and &
			left(ls_col_name, 6) <> "c_ped_" and &
			left(ls_col_name, 5) <> "c_coo" and &
			left(ls_col_name, 6) <> "c_weig" and &
			left(ls_col_name, 6) <> "t_fill") then

			if ls_type = "line"  then

				adw_bol.Modify(ls_dwobjs[i] + ".y1=" + string(li_y + li_offset) + " " + ls_dwobjs[i] + ".y2=" + string(li_y + li_offset))

				
			else

				adw_bol.Modify(ls_dwobjs[i] + ".y=" + string(li_y + li_offset))
	
			end if
	
	  END IF
NEXT

li_tab_order =  integer(adw_bol.describe(ls_last_col+".TabSequence")) + 1

for i = 1 to UpperBound(ls_change_tab)
	
	adw_bol.modify(ls_change_tab[i]+".TabSequence=0")
	
	ls_tab_change = ls_tab_change + " " + ls_change_tab[i]+".TabSequence=" + string(li_tab_order) + " "

	li_tab_order = li_tab_order + 10
	
next	

adw_bol.Modify(ls_tab_change)

long ll_height

ll_height = long(adw_bol.Describe("DataWindow.detail.height"))

ll_height = ll_height + li_offset

adw_bol.Modify("DataWindow.detail.height="+string(ll_height))


STRING	ls_alt_address[]

SELECT alt_cust_code,
		 address_1,
		 address_2,
		 address_3,
		 address_4,
		 city,
		 state,
		 zip,
		 name
		 INTO 
		 :ls_alt_address[1],
		 :ls_alt_address[2],
		 :ls_alt_address[3],
		 :ls_alt_address[4],
		 :ls_alt_address[5],
		 :ls_alt_address[6],
		 :ls_alt_address[7],
		 :ls_alt_address[8],
		 :ls_alt_address[9]
		FROM Delivery_Alt_Address
WHERE Address_Type = 'IT' AND
DO_No = :as_dono USING SQLCA;

if sqlca.sqlcode = 0 then
	
	adw_bol.SetItem(1, "delivery_master_cust_code", ls_alt_address[1])
	adw_bol.SetItem(1, "cust_name", ls_alt_address[9])
	adw_bol.SetItem(1, "address_1", ls_alt_address[2])
	adw_bol.SetItem(1, "address_2", ls_alt_address[3])
	adw_bol.SetItem(1, "address_3", ls_alt_address[4])
	adw_bol.SetItem(1, "address_4", ls_alt_address[5])
	adw_bol.SetItem(1, "city", ls_alt_address[6])
	adw_bol.SetItem(1, "delivery_master_state", ls_alt_address[7])
	adw_bol.SetItem(1, "delivery_master_zip", ls_alt_address[8])

end if


adw_bol.SetRedraw(true)



RETURN 1
end function

public function integer uf_process_bol_gmbattery (string as_dono, ref datawindow adw_bol);
integer li_current_id = 45  //Last Column ID in the select to know where to start.
integer li_start_y = 1360, li_y, li_height = 72, li_space = 76, li_start_tab = 30, li_tab_order, li_offset
// li_start_y = 1308
LONG    ll_nbrobjects
string  ls_dwobjs[]
string  ls_objects
string ls_col_name
integer li_tab, i
integer li_change_tab[], li_max_tab, li_min_tab
string ls_change_tab[], ls_change_tab_temp[]
integer i2, li_rtn2, li_idx
string ls_cust_code, ls_cust_order_no
string ls_select
datastore lds_ds, lds_po, lds_po_multi, lds_notes
integer li_rtn_item, li_idx_rtn_item, li_from_pos
string ls_po
boolean lb_multi_run
integer li_rtn3
integer li_idx2
string ls_po_list
string ls_add_select, ls_new_select
string ls_add_column
string ls_add_table
string ls_add_table_column
string ls_compute_piece, ls_compute_weight, ls_compute_charge
string ls_syntax
integer li_retrive_pos, li_text_pos
integer li_qty
string ls_desc, lsdesc2, lsdesc3, lsdesc4
double ld_weight
long  ll_carton
string ls_tab_change
string ls_last_col
string ls_notes, ls_dono
long	 ll_count, ll_row

string ls_po_temp[], ls_reset_po_temp[]	
boolean ib_found
integer p

string ls_Remit_Name, ls_Remit_address1, ls_Remit_address2, ls_Remit_address3, ls_Remit_city, ls_Remit_state, ls_Remit_Zip
string ls_AWB_BOL
adw_bol.dataobject = "d_gmbattery_bol_prt"

adw_bol.SetTransObject(SQLCA)
	
//Loop through and get old tab orders.

ls_objects = adw_bol.Describe('Datawindow.Objects')
	
of_parsetoArray(ls_objects,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)

For i = 1 to ll_nbrobjects
	
	  li_tab = integer(adw_bol.Describe(ls_dwobjs[i]+'.TabSequence'))
		ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')

	  if li_tab >= li_start_tab then
			ls_change_tab[UpperBound(ls_change_tab)+1] = ls_col_name
			li_change_tab[UpperBound(ls_change_tab)] = li_tab
			
			if li_tab > li_max_tab then
				li_max_tab = li_tab
			end if

			if li_tab < li_min_tab then
				li_min_tab = li_tab
			end if
			
			
	  end if
NEXT



for i = li_min_tab to li_max_tab step 10
	
	for i2 = 1 to UpperBound(ls_change_tab)
		if i = li_change_tab[i2] then
			ls_change_tab_temp[UpperBound(ls_change_tab_temp) + 1] = ls_change_tab[i2]
			
			EXIT;		
		end if
	next
	
next

ls_change_tab = ls_change_tab_temp




lds_ds = CREATE datastore

lds_ds.dataobject = "d_gmbattery_bol_group_details"

lds_ds.SetTransObject(SQLCA)



li_rtn_item = lds_ds.Retrieve(as_dono)

  SELECT sum(dbo.Delivery_Packing.Weight_Gross)  
    INTO :ld_weight 
    FROM dbo.Delivery_Packing  
   WHERE dbo.Delivery_Packing.DO_No = :as_dono   
;

  SELECT dbo.Lookup_Table.code_descript  
    INTO :lsdesc2 
    FROM dbo.Lookup_Table  
   WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
	and dbo.Lookup_Table.Code_ID = 'BOLDESC2'
;
  SELECT dbo.Lookup_Table.code_descript  
    INTO :lsdesc3 
    FROM dbo.Lookup_Table  
   WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
	and dbo.Lookup_Table.Code_ID = 'BOLDESC3'
;
  SELECT dbo.Lookup_Table.code_descript  
    INTO :lsdesc4 
    FROM dbo.Lookup_Table  
   WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
	and dbo.Lookup_Table.Code_ID = 'BOLDESC4'
;

  SELECT  count(distinct(dbo.Delivery_Packing.Carton_No))  
    INTO :ll_carton  
    FROM dbo.Delivery_Packing  
   WHERE dbo.Delivery_Packing.DO_No = :as_dono
           ;

li_y = li_start_y
li_tab_order = li_start_tab

for li_idx_rtn_item = 1 to 5 // ll_num_total_rows

	//Everything must in the correct order!

	ls_add_select = ls_add_select + ", 0000 as c_pieces" + string(li_idx_rtn_item) + ",   ~~~'                                 ~~~' as c_desc"+string(li_idx_rtn_item) + ", 0000.00 as c_weight"+string(li_idx_rtn_item) + ", '     ' as c_weight_ind"+string(li_idx_rtn_item) + ", 0000.00 as c_rate" + string(li_idx_rtn_item)


 	ls_add_table_column = ls_add_table_column + " column=(type=long updatewhereclause=yes name=c_pieces"+string(li_idx_rtn_item)+" dbname=~"c_pieces"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=char(33) updatewhereclause=yes name=c_desc"+string(li_idx_rtn_item)+" dbname=~"c_desc"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_weight"+string(li_idx_rtn_item)+" dbname=~"c_weight"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=char(5) updatewhereclause=yes name=c_weight_ind"+string(li_idx_rtn_item)+" dbname=~"c_weight_ind"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_rate"+string(li_idx_rtn_item)+" dbname=~"c_rate"+string(li_idx_rtn_item)+"~" ) "

	if li_idx_rtn_item > 1 then ls_compute_piece = ls_compute_piece + " + "
	ls_compute_piece 	= ls_compute_piece + " c_pieces" +string(li_idx_rtn_item)

	if li_idx_rtn_item > 1 then ls_compute_weight = ls_compute_weight + " + "
	ls_compute_weight	= ls_compute_weight + " c_weight" +string(li_idx_rtn_item)

	if li_idx_rtn_item > 1 then ls_compute_charge = ls_compute_charge + " + "
	ls_compute_charge	= ls_compute_charge + " c_pieces_rate_sub" +string(li_idx_rtn_item)




//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"100~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "


	li_current_id = li_current_id + 1

	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"100~" width=~"2162~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"72~" width=~"1582~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2446~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler"+string(li_idx_rtn_item)+" font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


												//text(band=detail alignment="2" text="COD FEE" border="2" color="0" x="1737" y="3856" height="100" width="480" html.valueishtml="0"  name=t_7 visible="1"  font.face="Arial" font.height="-9" font.weight="700"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912" )


	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

//558

	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2446~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	//MA - change to make not visible.

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"2220~" y=~""+string(li_y)+"~" height=~"72~" width=~"130~" format=~"[general]~"  name=c_weight_ind"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~"  visible =~"0~") "
	


	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2898~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2427~" y=~""+string(li_y)+"~" height=~"72~" width=~"480~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


	ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~" c_pieces"+string(li_idx_rtn_item)+" * c_rate"+string(li_idx_rtn_item)+" ~"border=~"2~" color=~"0~" x=~"2912~" y=~""+string(li_y)+"~" height=~"72~" width=~"434~" format=~"###,###.00~"  name=c_pieces_rate_sub"+string(li_idx_rtn_item)+"  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "



	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
	
	li_y = li_y + li_space
	
	li_offset = li_offset + li_space
	
	ls_last_col = "c_rate"+string(li_idx_rtn_item)

next


ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece+"~" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_piece_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler_weight font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~""+ls_compute_weight+"~" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


li_offset = li_offset + li_space


ls_syntax = adw_bol.Describe("DataWindow.Syntax")

ls_add_select = ls_add_select + " "


ls_select = adw_bol.Describe("Datawindow.Table.Select")

ls_new_select = ls_syntax

li_retrive_pos = Pos(lower(ls_new_select), "retrieve=")

ls_new_select = left( ls_new_select, li_retrive_pos - 1) + ls_add_table_column + mid( ls_new_select, li_retrive_pos - 1)

//	Messagebox (string(li_retrive_pos), ls_new_select)


li_from_pos = POS(upper(ls_new_select), " FROM ")

ls_new_select = left( ls_new_select, li_from_pos - 2) + ls_add_select + mid( ls_new_select, li_from_pos - 2)  


li_text_pos = POS(lower(ls_new_select), "text(")

ls_new_select = left( ls_new_select, li_text_pos - 1) + ls_add_column + mid( ls_new_select, li_text_pos - 1)  

ls_new_select = fu_quotestring(ls_new_select, "'")


//	MessageBox ("newselect", ls_new_select)
	
adw_bol.Create(ls_new_select)


adw_bol.Modify("c_total.Expression='"+ls_compute_charge+"'")

  SELECT dbo.Customer.Cust_name, dbo.Customer.Address_1, dbo.Customer.address_2, dbo.Customer.address_3, dbo.Customer.city, dbo.Customer.state, dbo.Customer.zip   
    INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
    FROM dbo.Customer  
   WHERE dbo.Customer.Project_id = :gs_project  and dbo.Customer.cust_code = '123BILLING'   
;

IF IsNull(ls_Remit_Name) then ls_Remit_Name = ""
IF IsNull(ls_Remit_address1) then ls_Remit_address1 = ""
IF IsNull(ls_Remit_address2) then ls_Remit_address2 = ""
IF IsNull(ls_Remit_address3) then ls_Remit_address3 = ""
IF IsNull(ls_Remit_city) then ls_Remit_city = ""
IF IsNull(ls_Remit_state) then ls_Remit_state = ""
IF IsNull(ls_Remit_Zip) then ls_Remit_Zip = ""

string ls_remit

if ls_Remit_Name <> "" then
	ls_remit = ls_remit_name + "~r~n"
end if


if ls_Remit_address1 <> "" then
	ls_remit = ls_remit + ls_Remit_address1 + "~r~n"
end if 

if ls_Remit_address2 <> "" then
	ls_remit = ls_remit + ls_Remit_address2 + "~r~n"
end if

if ls_Remit_address3 <> "" then
	ls_remit = ls_remit + ls_Remit_address3 + "~r~n"
end if

ls_remit = ls_remit + ls_remit_city + ", " + ls_remit_state + ", " + ls_remit_zip 

adw_bol.Modify("c_remit_name.Expression=~'~""+ls_remit+"~"~'")


//Retrieve the report

adw_bol.SetTransObject(sqlca)

adw_bol.Retrieve(gs_project, as_dono)

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

	
//Set the default data.	


//		ll_carton = lds_ds.GetItemNumber( 1, "Carton_No")
		adw_bol.SetItem(1, "c_pieces1", ll_Carton )		
		ls_desc = lds_ds.GetItemstring( 1, "Code_Description") + lsDesc2
		adw_bol.SetItem(1, "c_desc1" , ls_desc )		
		adw_bol.SetItem(1, "c_weight1" , ld_weight  )		

		adw_bol.SetItem(1, "c_desc2" , lsdesc3 )
		adw_bol.SetItem(1, "c_desc3" , lsdesc4 )
		
	// Fill AWB BOL into C_ROUTE
		ls_AWB_BOL = w_do.idw_other.GetItemString(1,"AWB_BOL_NO")
		If Not isnull(ls_AWB_BOL) Then
			adw_bol.setitem(1,'c_route',ls_awb_bol)
		end if 		

	
//Push Footer Down

ls_objects = adw_bol.Describe('Datawindow.Objects')

of_parsetoArray(ls_objects,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)

string ls_type

For i = 1 to ll_nbrobjects

		ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
		ls_type = trim(adw_bol.Describe(ls_dwobjs[i]+'.type'))


		if ls_type = "line" then
		   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y1'))
		else
		   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y'))
		end if
		

//			Messagebox ("ok", ls_col_name)

	  if (li_y >= li_start_y) and &
		  (left(ls_col_name, 6) <> "c_piec" and &
			left(ls_col_name, 6) <> "c_desc" and &
			left(ls_col_name, 6) <> "c_rate" and &
			left(ls_col_name, 6) <> "c_weig" and &
			left(ls_col_name, 6) <> "t_fill") then

			if ls_type = "line"  then

				adw_bol.Modify(ls_dwobjs[i] + ".y1=" + string(li_y + li_offset) + " " + ls_dwobjs[i] + ".y2=" + string(li_y + li_offset))

				
			else

				adw_bol.Modify(ls_dwobjs[i] + ".y=" + string(li_y + li_offset))
	
			end if
	
	  END IF
NEXT

li_tab_order =  integer(adw_bol.describe(ls_last_col+".TabSequence")) + 1

for i = 1 to UpperBound(ls_change_tab)
	
	adw_bol.modify(ls_change_tab[i]+".TabSequence=0")
	
	ls_tab_change = ls_tab_change + " " + ls_change_tab[i]+".TabSequence=" + string(li_tab_order) + " "

	li_tab_order = li_tab_order + 10
	
next	

adw_bol.Modify(ls_tab_change)

long ll_height

ll_height = long(adw_bol.Describe("DataWindow.detail.height"))

ll_height = ll_height + li_offset

adw_bol.Modify("DataWindow.detail.height="+string(ll_height))

adw_bol.SetRedraw(true)



RETURN 1
end function

public function integer uf_process_bol_globalrush (string as_dono, ref datawindow adw_bol);
integer li_current_id = 45  //Last Column ID in the select to know where to start.
integer li_start_y = 1360, li_y, li_height = 72, li_space = 76, li_start_tab = 30, li_tab_order, li_offset
// li_start_y = 1308
LONG    ll_nbrobjects
string  ls_dwobjs[]
string  ls_objects
string ls_col_name
integer li_tab, i
integer li_change_tab[], li_max_tab, li_min_tab
string ls_change_tab[], ls_change_tab_temp[]
integer i2, li_rtn2, li_idx
string ls_cust_code, ls_cust_order_no
string ls_select
datastore lds_ds, lds_po, lds_po_multi, lds_notes
integer li_rtn_item, li_idx_rtn_item, li_from_pos
string ls_po
boolean lb_multi_run
integer li_rtn3
integer li_idx2
string ls_po_list
string ls_add_select, ls_new_select
string ls_add_column
string ls_add_table
string ls_add_table_column
string ls_compute_piece, ls_compute_weight, ls_compute_charge
string ls_syntax
integer li_retrive_pos, li_text_pos
integer li_qty
string ls_desc
double ld_weight
long  ll_carton
string ls_tab_change
string ls_last_col
string ls_notes, ls_dono
long	 ll_count, ll_row

string ls_po_temp[], ls_reset_po_temp[]	
boolean ib_found
integer p

string ls_Remit_Name, ls_Remit_address1, ls_Remit_address2, ls_Remit_address3, ls_Remit_city, ls_Remit_state, ls_Remit_Zip

adw_bol.dataobject = "d_globalrush_bol_prt"

adw_bol.SetTransObject(SQLCA)
	
//Loop through and get old tab orders.

ls_objects = adw_bol.Describe('Datawindow.Objects')
	
of_parsetoArray(ls_objects,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)

For i = 1 to ll_nbrobjects
	
	  li_tab = integer(adw_bol.Describe(ls_dwobjs[i]+'.TabSequence'))
		ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')

	  if li_tab >= li_start_tab then
			ls_change_tab[UpperBound(ls_change_tab)+1] = ls_col_name
			li_change_tab[UpperBound(ls_change_tab)] = li_tab
			
			if li_tab > li_max_tab then
				li_max_tab = li_tab
			end if

			if li_tab < li_min_tab then
				li_min_tab = li_tab
			end if
			
			
	  end if
NEXT



for i = li_min_tab to li_max_tab step 10
	
	for i2 = 1 to UpperBound(ls_change_tab)
		if i = li_change_tab[i2] then
			ls_change_tab_temp[UpperBound(ls_change_tab_temp) + 1] = ls_change_tab[i2]
			
			EXIT;		
		end if
	next
	
next

ls_change_tab = ls_change_tab_temp




lds_ds = CREATE datastore

lds_ds.dataobject = "d_gmbattery_bol_group_details"

lds_ds.SetTransObject(SQLCA)



li_rtn_item = lds_ds.Retrieve(as_dono)

  SELECT sum(dbo.Delivery_Packing.Weight_Gross)  
    INTO :ld_weight 
    FROM dbo.Delivery_Packing  
   WHERE dbo.Delivery_Packing.DO_No = :as_dono   
;

  SELECT  count(distinct(dbo.Delivery_Packing.Carton_No))  
    INTO :ll_carton  
    FROM dbo.Delivery_Packing  
   WHERE dbo.Delivery_Packing.DO_No = :as_dono
           ;

li_y = li_start_y
li_tab_order = li_start_tab

for li_idx_rtn_item = 1 to 5 // ll_num_total_rows

	//Everything must in the correct order!

	ls_add_select = ls_add_select + ", 0000 as c_pieces" + string(li_idx_rtn_item) + ",   ~~~'                                 ~~~' as c_desc"+string(li_idx_rtn_item) + ", 0000.00 as c_weight"+string(li_idx_rtn_item) + ", '     ' as c_weight_ind"+string(li_idx_rtn_item) + ", 0000.00 as c_rate" + string(li_idx_rtn_item)


 	ls_add_table_column = ls_add_table_column + " column=(type=long updatewhereclause=yes name=c_pieces"+string(li_idx_rtn_item)+" dbname=~"c_pieces"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=char(33) updatewhereclause=yes name=c_desc"+string(li_idx_rtn_item)+" dbname=~"c_desc"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_weight"+string(li_idx_rtn_item)+" dbname=~"c_weight"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=char(5) updatewhereclause=yes name=c_weight_ind"+string(li_idx_rtn_item)+" dbname=~"c_weight_ind"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_rate"+string(li_idx_rtn_item)+" dbname=~"c_rate"+string(li_idx_rtn_item)+"~" ) "

	if li_idx_rtn_item > 1 then ls_compute_piece = ls_compute_piece + " + "
	ls_compute_piece 	= ls_compute_piece + " c_pieces" +string(li_idx_rtn_item)

	if li_idx_rtn_item > 1 then ls_compute_weight = ls_compute_weight + " + "
	ls_compute_weight	= ls_compute_weight + " c_weight" +string(li_idx_rtn_item)

	if li_idx_rtn_item > 1 then ls_compute_charge = ls_compute_charge + " + "
	ls_compute_charge	= ls_compute_charge + " c_pieces_rate_sub" +string(li_idx_rtn_item)




//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"100~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "


	li_current_id = li_current_id + 1

	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"100~" width=~"2162~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"72~" width=~"1582~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2446~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler"+string(li_idx_rtn_item)+" font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


												//text(band=detail alignment="2" text="COD FEE" border="2" color="0" x="1737" y="3856" height="100" width="480" html.valueishtml="0"  name=t_7 visible="1"  font.face="Arial" font.height="-9" font.weight="700"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912" )


	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

//558

	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2446~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	//MA - change to make not visible.

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"2220~" y=~""+string(li_y)+"~" height=~"72~" width=~"130~" format=~"[general]~"  name=c_weight_ind"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~"  visible =~"0~") "
	


	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2898~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2427~" y=~""+string(li_y)+"~" height=~"72~" width=~"480~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


	ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~" c_pieces"+string(li_idx_rtn_item)+" * c_rate"+string(li_idx_rtn_item)+" ~"border=~"2~" color=~"0~" x=~"2912~" y=~""+string(li_y)+"~" height=~"72~" width=~"434~" format=~"###,###.00~"  name=c_pieces_rate_sub"+string(li_idx_rtn_item)+"  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "



	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
	
	li_y = li_y + li_space
	
	li_offset = li_offset + li_space
	
	ls_last_col = "c_rate"+string(li_idx_rtn_item)

next


ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece+"~" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_piece_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler_weight font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~""+ls_compute_weight+"~" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


li_offset = li_offset + li_space


ls_syntax = adw_bol.Describe("DataWindow.Syntax")

ls_add_select = ls_add_select + " "


ls_select = adw_bol.Describe("Datawindow.Table.Select")

ls_new_select = ls_syntax

li_retrive_pos = Pos(lower(ls_new_select), "retrieve=")

ls_new_select = left( ls_new_select, li_retrive_pos - 1) + ls_add_table_column + mid( ls_new_select, li_retrive_pos - 1)

//	Messagebox (string(li_retrive_pos), ls_new_select)


li_from_pos = POS(upper(ls_new_select), " FROM ")

ls_new_select = left( ls_new_select, li_from_pos - 2) + ls_add_select + mid( ls_new_select, li_from_pos - 2)  


li_text_pos = POS(lower(ls_new_select), "text(")

ls_new_select = left( ls_new_select, li_text_pos - 1) + ls_add_column + mid( ls_new_select, li_text_pos - 1)  

ls_new_select = fu_quotestring(ls_new_select, "'")


//	MessageBox ("newselect", ls_new_select)
	
adw_bol.Create(ls_new_select)


adw_bol.Modify("c_total.Expression='"+ls_compute_charge+"'")

  SELECT dbo.Customer.Cust_name, dbo.Customer.Address_1, dbo.Customer.address_2, dbo.Customer.address_3, dbo.Customer.city, dbo.Customer.state, dbo.Customer.zip   
    INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
    FROM dbo.Customer  
   WHERE dbo.Customer.Project_id = :gs_project  and dbo.Customer.cust_code = '123BILLING'   
;

IF IsNull(ls_Remit_Name) then ls_Remit_Name = ""
IF IsNull(ls_Remit_address1) then ls_Remit_address1 = ""
IF IsNull(ls_Remit_address2) then ls_Remit_address2 = ""
IF IsNull(ls_Remit_address3) then ls_Remit_address3 = ""
IF IsNull(ls_Remit_city) then ls_Remit_city = ""
IF IsNull(ls_Remit_state) then ls_Remit_state = ""
IF IsNull(ls_Remit_Zip) then ls_Remit_Zip = ""

string ls_remit

if ls_Remit_Name <> "" then
	ls_remit = ls_remit_name + "~r~n"
end if


if ls_Remit_address1 <> "" then
	ls_remit = ls_remit + ls_Remit_address1 + "~r~n"
end if 

if ls_Remit_address2 <> "" then
	ls_remit = ls_remit + ls_Remit_address2 + "~r~n"
end if

if ls_Remit_address3 <> "" then
	ls_remit = ls_remit + ls_Remit_address3 + "~r~n"
end if

ls_remit = ls_remit + ls_remit_city + ", " + ls_remit_state + ", " + ls_remit_zip 

adw_bol.Modify("c_remit_name.Expression=~'~""+ls_remit+"~"~'")


//Retrieve the report

adw_bol.SetTransObject(sqlca)

adw_bol.Retrieve(gs_project, as_dono)

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

	
//Set the default data.	


//		ll_carton = lds_ds.GetItemNumber( 1, "Carton_No")
		adw_bol.SetItem(1, "c_pieces1", ll_Carton )		
		ls_desc = lds_ds.GetItemstring( 1, "Code_Description")
		adw_bol.SetItem(1, "c_desc1" , ls_desc )		
		adw_bol.SetItem(1, "c_weight1" , ld_weight  )		

	
//Push Footer Down

ls_objects = adw_bol.Describe('Datawindow.Objects')

of_parsetoArray(ls_objects,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)

string ls_type

For i = 1 to ll_nbrobjects

		ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
		ls_type = trim(adw_bol.Describe(ls_dwobjs[i]+'.type'))


		if ls_type = "line" then
		   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y1'))
		else
		   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y'))
		end if
		

//			Messagebox ("ok", ls_col_name)

	  if (li_y >= li_start_y) and &
		  (left(ls_col_name, 6) <> "c_piec" and &
			left(ls_col_name, 6) <> "c_desc" and &
			left(ls_col_name, 6) <> "c_rate" and &
			left(ls_col_name, 6) <> "c_weig" and &
			left(ls_col_name, 6) <> "t_fill") then

			if ls_type = "line"  then

				adw_bol.Modify(ls_dwobjs[i] + ".y1=" + string(li_y + li_offset) + " " + ls_dwobjs[i] + ".y2=" + string(li_y + li_offset))

				
			else

				adw_bol.Modify(ls_dwobjs[i] + ".y=" + string(li_y + li_offset))
	
			end if
	
	  END IF
NEXT

li_tab_order =  integer(adw_bol.describe(ls_last_col+".TabSequence")) + 1

for i = 1 to UpperBound(ls_change_tab)
	
	adw_bol.modify(ls_change_tab[i]+".TabSequence=0")
	
	ls_tab_change = ls_tab_change + " " + ls_change_tab[i]+".TabSequence=" + string(li_tab_order) + " "

	li_tab_order = li_tab_order + 10
	
next	

adw_bol.Modify(ls_tab_change)

long ll_height

ll_height = long(adw_bol.Describe("DataWindow.detail.height"))

ll_height = ll_height + li_offset

adw_bol.Modify("DataWindow.detail.height="+string(ll_height))

adw_bol.SetRedraw(true)



RETURN 1
end function

public subroutine setcarrier (string ascarrier);// setCarrier( string asCarrier )
isCarrier = asCarrier

end subroutine

public function string getcarrier ();// string = getCarrier()
return isCarrier

end function

public function integer uf_process_bol_pwrofdream (string as_dono, ref datawindow adw_bol);// int = uf_process_bol_pwrofdream( string as_dono, ref datawindow adw_bol )

integer 		li_current_id = 45  //Last Column ID in the select to know where to start.
integer 		li_start_y = 1804
integer 		li_y 
integer 		li_height = 72 
integer 		li_space = 76 
integer 		li_start_tab = 30 
integer 		li_tab_order 
integer 		li_offset
integer 		li_tab
integer 		i, i2
integer 		li_change_tab[]
integer 		li_max_tab
integer 		li_min_tab
integer 		li_rtn_item 
integer 		li_idx_rtn_item 
integer 		li_from_pos
integer 		li_retrive_pos
integer 		li_text_pos

string ls_dwobjs[]
string ls_col_name
string ls_change_tab[]
string ls_change_tab_temp[]
string ls_select
string ls_add_select
string ls_new_select
string ls_add_column
string ls_add_table_column
string ls_compute_piece
string ls_compute_weight
string ls_compute_charge
string ls_syntax
string ls_desc
string lsdesc2
string lsdesc3
string  lsdesc4
string ls_tab_change
string ls_last_col
string ls_Remit_Name
string ls_Remit_address1
string ls_Remit_address2
string ls_Remit_address3
string ls_Remit_city
string ls_Remit_state
string ls_Remit_Zip
string ls_AWB_BOL
string ls_type
string ls_remit

long	ll_nbrobjects
long 	ll_height
long  ll_carton

double ld_weight

datastore lds_ds

adw_bol.dataobject = "d_powerofthedream_bol_prt"
adw_bol.SetTransObject(SQLCA)
	
//Loop through and get old tab orders.
of_parsetoArray( adw_bol.Describe('Datawindow.Objects') ,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)
For i = 1 to ll_nbrobjects
	li_tab = integer(adw_bol.Describe(ls_dwobjs[i]+'.TabSequence'))
	ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
	if li_tab >= li_start_tab then
		ls_change_tab[UpperBound(ls_change_tab)+1] = ls_col_name
		li_change_tab[UpperBound(ls_change_tab)] = li_tab
		if li_tab > li_max_tab then
			li_max_tab = li_tab
		end if
		if li_tab < li_min_tab then
			li_min_tab = li_tab
		end if
	end if
next
for i = li_min_tab to li_max_tab step 10
	for i2 = 1 to UpperBound(ls_change_tab)
		if i = li_change_tab[i2] then
			ls_change_tab_temp[UpperBound(ls_change_tab_temp) + 1] = ls_change_tab[i2]
			EXIT;		
		end if
	next
next

ls_change_tab = ls_change_tab_temp

lds_ds = f_datastoreFactory("d_gmbattery_bol_group_details")
li_rtn_item = lds_ds.Retrieve(as_dono)

SELECT sum(dbo.Delivery_Packing.Weight_Gross)  
 INTO :ld_weight 
 FROM dbo.Delivery_Packing  
WHERE dbo.Delivery_Packing.DO_No = :as_dono ;

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc2 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC2';

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc3 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC3';

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc4 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC4';

SELECT  count(distinct(dbo.Delivery_Packing.Carton_No))  
 INTO :ll_carton  
 FROM dbo.Delivery_Packing  
WHERE dbo.Delivery_Packing.DO_No = :as_dono ;

li_y = li_start_y
li_tab_order = li_start_tab

for li_idx_rtn_item = 1 to 5 // ll_num_total_rows

	//Everything must in the correct order!

	ls_add_select = ls_add_select + ", 0000 as c_pieces" + string(li_idx_rtn_item) + ",   ~~~'                                 ~~~' as c_desc"+string(li_idx_rtn_item) + ", 0000.00 as c_weight"+string(li_idx_rtn_item) + ", '     ' as c_weight_ind"+string(li_idx_rtn_item) + ", 0000.00 as c_rate" + string(li_idx_rtn_item)
 	ls_add_table_column = ls_add_table_column + " column=(type=long updatewhereclause=yes name=c_pieces"+string(li_idx_rtn_item)+" dbname=~"c_pieces"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=char(33) updatewhereclause=yes name=c_desc"+string(li_idx_rtn_item)+" dbname=~"c_desc"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_weight"+string(li_idx_rtn_item)+" dbname=~"c_weight"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=char(5) updatewhereclause=yes name=c_weight_ind"+string(li_idx_rtn_item)+" dbname=~"c_weight_ind"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_rate"+string(li_idx_rtn_item)+" dbname=~"c_rate"+string(li_idx_rtn_item)+"~" ) "

	if li_idx_rtn_item > 1 then ls_compute_piece = ls_compute_piece + " + "
	ls_compute_piece 	= ls_compute_piece + " c_pieces" +string(li_idx_rtn_item)
	if li_idx_rtn_item > 1 then ls_compute_weight = ls_compute_weight + " + "
	ls_compute_weight	= ls_compute_weight + " c_weight" +string(li_idx_rtn_item)
	if li_idx_rtn_item > 1 then ls_compute_charge = ls_compute_charge + " + "
	ls_compute_charge	= ls_compute_charge + " c_pieces_rate_sub" +string(li_idx_rtn_item)
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"72~" width=~"1582~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler"+string(li_idx_rtn_item)+" font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"2220~" y=~""+string(li_y)+"~" height=~"72~" width=~"130~" format=~"[general]~"  name=c_weight_ind"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~"  visible =~"0~") "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2427~" y=~""+string(li_y)+"~" height=~"72~" width=~"480~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~" c_pieces"+string(li_idx_rtn_item)+" * c_rate"+string(li_idx_rtn_item)+" ~"border=~"2~" color=~"0~" x=~"2912~" y=~""+string(li_y)+"~" height=~"72~" width=~"434~" format=~"###,###.00~"  name=c_pieces_rate_sub"+string(li_idx_rtn_item)+"  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	li_y = li_y + li_space
	li_offset = li_offset + li_space
	ls_last_col = "c_rate"+string(li_idx_rtn_item)
next
ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece+"~" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_piece_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler_weight font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~""+ls_compute_weight+"~" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
li_offset = li_offset + li_space
ls_syntax = adw_bol.Describe("DataWindow.Syntax")
ls_add_select = ls_add_select + " "
ls_select = adw_bol.Describe("Datawindow.Table.Select")
ls_new_select = ls_syntax
li_retrive_pos = Pos(lower(ls_new_select), "retrieve=")
ls_new_select = left( ls_new_select, li_retrive_pos - 1) + ls_add_table_column + mid( ls_new_select, li_retrive_pos - 1)
li_from_pos = POS(upper(ls_new_select), " FROM ")
ls_new_select = left( ls_new_select, li_from_pos - 2) + ls_add_select + mid( ls_new_select, li_from_pos - 2)  
li_text_pos = POS(lower(ls_new_select), "text(")
ls_new_select = left( ls_new_select, li_text_pos - 1) + ls_add_column + mid( ls_new_select, li_text_pos - 1)  
ls_new_select = fu_quotestring(ls_new_select, "'")
adw_bol.Create(ls_new_select)
adw_bol.Modify("c_total.Expression='"+ls_compute_charge+"'")

SELECT dbo.Customer.Cust_name, dbo.Customer.Address_1, dbo.Customer.address_2, dbo.Customer.address_3, dbo.Customer.city, dbo.Customer.state, dbo.Customer.zip   
 INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
 FROM dbo.Customer  
WHERE dbo.Customer.Project_id = :gs_project  and dbo.Customer.cust_code = '123BILLING' ;

IF IsNull(ls_Remit_Name) then ls_Remit_Name = ""
IF IsNull(ls_Remit_address1) then ls_Remit_address1 = ""
IF IsNull(ls_Remit_address2) then ls_Remit_address2 = ""
IF IsNull(ls_Remit_address3) then ls_Remit_address3 = ""
IF IsNull(ls_Remit_city) then ls_Remit_city = ""
IF IsNull(ls_Remit_state) then ls_Remit_state = ""
IF IsNull(ls_Remit_Zip) then ls_Remit_Zip = ""

if ls_Remit_Name <> "" then
	ls_remit = ls_remit_name + "~r~n"
end if

if ls_Remit_address1 <> "" then
	ls_remit = ls_remit + ls_Remit_address1 + "~r~n"
end if 

if ls_Remit_address2 <> "" then
	ls_remit = ls_remit + ls_Remit_address2 + "~r~n"
end if

if ls_Remit_address3 <> "" then
	ls_remit = ls_remit + ls_Remit_address3 + "~r~n"
end if

ls_remit = ls_remit + ls_remit_city + ", " + ls_remit_state + ", " + ls_remit_zip 

adw_bol.Modify("c_remit_name.Expression=~'~""+ls_remit+"~"~'")

//Retrieve the report

adw_bol.SetTransObject(sqlca)

adw_bol.Retrieve(gs_project, as_dono)

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetItem(1, "c_pieces1", ll_Carton )		
if lds_ds.rowcount() > 0 then
	ls_desc = lds_ds.GetItemstring( 1, "Code_Description") + lsDesc2
else
	ls_desc = lsDesc2
	if isNull( lsDesc2) or len( trim( lsDesc2 ) ) = 0 then ls_desc = 'No Description Available'
end if
adw_bol.SetItem(1, "c_desc1" , ls_desc )		
adw_bol.SetItem(1, "c_weight1" , ld_weight  )		
adw_bol.SetItem(1, "c_desc2" , lsdesc3 )
adw_bol.SetItem(1, "c_desc3" , lsdesc4 )
		
// Fill AWB BOL into C_ROUTE
ls_AWB_BOL = w_do.idw_other.GetItemString(1,"AWB_BOL_NO")
If Not isnull(ls_AWB_BOL) Then
	adw_bol.setitem(1,'c_route',ls_awb_bol)
end if 		
	
//Push Footer Down
of_parsetoArray( adw_bol.Describe('Datawindow.Objects') ,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)
For i = 1 to ll_nbrobjects
	ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
	ls_type = trim(adw_bol.Describe(ls_dwobjs[i]+'.type'))
	if ls_type = "line" then
	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y1'))
	else
	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y'))
	end if
	if (li_y >= li_start_y) and &
		(left(ls_col_name, 6) <> "c_piec" and &
		left(ls_col_name, 6) <> "c_desc" and &
		left(ls_col_name, 6) <> "c_rate" and &
		left(ls_col_name, 6) <> "c_weig" and &
		left(ls_col_name, 6) <> "t_fill") then
			if ls_type = "line"  then
				adw_bol.Modify(ls_dwobjs[i] + ".y1=" + string(li_y + li_offset) + " " + ls_dwobjs[i] + ".y2=" + string(li_y + li_offset))
			else
				adw_bol.Modify(ls_dwobjs[i] + ".y=" + string(li_y + li_offset))
			end if
	  END IF
NEXT

li_tab_order =  integer(adw_bol.describe(ls_last_col+".TabSequence")) + 1

for i = 1 to UpperBound(ls_change_tab)
	adw_bol.modify(ls_change_tab[i]+".TabSequence=0")
	ls_tab_change = ls_tab_change + " " + ls_change_tab[i]+".TabSequence=" + string(li_tab_order) + " "
	li_tab_order = li_tab_order + 10
next	
adw_bol.Modify(ls_tab_change)

ll_height = long(adw_bol.Describe("DataWindow.detail.height"))

ll_height = ll_height + li_offset

adw_bol.Modify("DataWindow.detail.height="+string(ll_height))

adw_bol.SetRedraw(true)

RETURN 1
end function

public function integer uf_process_bol (string as_dono, ref datawindow adw_bol, datawindow adw_print);// int = uf_process_bol_pwrofdream( string as_dono, ref datawindow adw_bol, datawindwo adw_print )

integer 		li_current_id = 45  //Last Column ID in the select to know where to start.
integer 		li_start_y = 1804
integer 		li_y 
integer 		li_height = 72 
integer 		li_space = 76 
integer 		li_start_tab = 30 
integer 		li_tab_order 
integer 		li_offset
integer 		li_tab
integer 		i, i2
integer 		li_change_tab[]
integer 		li_max_tab
integer 		li_min_tab
integer 		li_rtn_item 
integer 		li_idx_rtn_item 
integer 		li_from_pos
integer 		li_retrive_pos
integer 		li_text_pos

string ls_dwobjs[]
string ls_col_name
string ls_change_tab[]
string ls_change_tab_temp[]
string ls_select
string ls_add_select
string ls_new_select
string ls_add_column
string ls_add_table_column
string ls_compute_piece
string ls_compute_weight
string ls_compute_charge
string ls_syntax
string ls_desc
string lsdesc2
string lsdesc3
string  lsdesc4
string ls_tab_change
string ls_last_col
string ls_Remit_Name
string ls_Remit_address1
string ls_Remit_address2
string ls_Remit_address3
string ls_Remit_city
string ls_Remit_state
string ls_Remit_Zip
string ls_AWB_BOL
string ls_type
string ls_remit

long	ll_nbrobjects
long 	ll_height
long  ll_carton

double ld_weight

datastore lds_ds

//adw_bol.dataobject = "d_powerofthedream_bol_prt"
adw_bol = adw_print
//adw_bol.SetTransObject(SQLCA)
	
//Loop through and get old tab orders.
of_parsetoArray( adw_bol.Describe('Datawindow.Objects') ,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)
For i = 1 to ll_nbrobjects
	li_tab = integer(adw_bol.Describe(ls_dwobjs[i]+'.TabSequence'))
	ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
	if li_tab >= li_start_tab then
		ls_change_tab[UpperBound(ls_change_tab)+1] = ls_col_name
		li_change_tab[UpperBound(ls_change_tab)] = li_tab
		if li_tab > li_max_tab then
			li_max_tab = li_tab
		end if
		if li_tab < li_min_tab then
			li_min_tab = li_tab
		end if
	end if
next
for i = li_min_tab to li_max_tab step 10
	for i2 = 1 to UpperBound(ls_change_tab)
		if i = li_change_tab[i2] then
			ls_change_tab_temp[UpperBound(ls_change_tab_temp) + 1] = ls_change_tab[i2]
			EXIT;		
		end if
	next
next

ls_change_tab = ls_change_tab_temp

lds_ds = f_datastoreFactory("d_gmbattery_bol_group_details")
li_rtn_item = lds_ds.Retrieve(as_dono)

SELECT sum(dbo.Delivery_Packing.Weight_Gross)  
 INTO :ld_weight 
 FROM dbo.Delivery_Packing  
WHERE dbo.Delivery_Packing.DO_No = :as_dono ;

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc2 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC2';

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc3 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC3';

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc4 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC4';

SELECT  count(distinct(dbo.Delivery_Packing.Carton_No))  
 INTO :ll_carton  
 FROM dbo.Delivery_Packing  
WHERE dbo.Delivery_Packing.DO_No = :as_dono ;

li_y = li_start_y
li_tab_order = li_start_tab

for li_idx_rtn_item = 1 to 5 // ll_num_total_rows

	//Everything must in the correct order!

	ls_add_select = ls_add_select + ", 0000 as c_pieces" + string(li_idx_rtn_item) + ",   ~~~'                                 ~~~' as c_desc"+string(li_idx_rtn_item) + ", 0000.00 as c_weight"+string(li_idx_rtn_item) + ", '     ' as c_weight_ind"+string(li_idx_rtn_item) + ", 0000.00 as c_rate" + string(li_idx_rtn_item)
 	ls_add_table_column = ls_add_table_column + " column=(type=long updatewhereclause=yes name=c_pieces"+string(li_idx_rtn_item)+" dbname=~"c_pieces"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=char(33) updatewhereclause=yes name=c_desc"+string(li_idx_rtn_item)+" dbname=~"c_desc"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_weight"+string(li_idx_rtn_item)+" dbname=~"c_weight"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=char(5) updatewhereclause=yes name=c_weight_ind"+string(li_idx_rtn_item)+" dbname=~"c_weight_ind"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_rate"+string(li_idx_rtn_item)+" dbname=~"c_rate"+string(li_idx_rtn_item)+"~" ) "

	if li_idx_rtn_item > 1 then ls_compute_piece = ls_compute_piece + " + "
	ls_compute_piece 	= ls_compute_piece + " c_pieces" +string(li_idx_rtn_item)
	if li_idx_rtn_item > 1 then ls_compute_weight = ls_compute_weight + " + "
	ls_compute_weight	= ls_compute_weight + " c_weight" +string(li_idx_rtn_item)
	if li_idx_rtn_item > 1 then ls_compute_charge = ls_compute_charge + " + "
	ls_compute_charge	= ls_compute_charge + " c_pieces_rate_sub" +string(li_idx_rtn_item)
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"72~" width=~"1582~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler"+string(li_idx_rtn_item)+" font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"2220~" y=~""+string(li_y)+"~" height=~"72~" width=~"130~" format=~"[general]~"  name=c_weight_ind"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~"  visible =~"0~") "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2427~" y=~""+string(li_y)+"~" height=~"72~" width=~"480~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~" c_pieces"+string(li_idx_rtn_item)+" * c_rate"+string(li_idx_rtn_item)+" ~"border=~"2~" color=~"0~" x=~"2912~" y=~""+string(li_y)+"~" height=~"72~" width=~"434~" format=~"###,###.00~"  name=c_pieces_rate_sub"+string(li_idx_rtn_item)+"  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	li_y = li_y + li_space
	li_offset = li_offset + li_space
	ls_last_col = "c_rate"+string(li_idx_rtn_item)
next
ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece+"~" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_piece_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler_weight font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~""+ls_compute_weight+"~" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
li_offset = li_offset + li_space
ls_syntax = adw_bol.Describe("DataWindow.Syntax")
ls_add_select = ls_add_select + " "
ls_select = adw_bol.Describe("Datawindow.Table.Select")
ls_new_select = ls_syntax
li_retrive_pos = Pos(lower(ls_new_select), "retrieve=")
ls_new_select = left( ls_new_select, li_retrive_pos - 1) + ls_add_table_column + mid( ls_new_select, li_retrive_pos - 1)
li_from_pos = POS(upper(ls_new_select), " FROM ")
ls_new_select = left( ls_new_select, li_from_pos - 2) + ls_add_select + mid( ls_new_select, li_from_pos - 2)  
li_text_pos = POS(lower(ls_new_select), "text(")
ls_new_select = left( ls_new_select, li_text_pos - 1) + ls_add_column + mid( ls_new_select, li_text_pos - 1)  
ls_new_select = fu_quotestring(ls_new_select, "'")
adw_bol.Create(ls_new_select)
adw_bol.Modify("c_total.Expression='"+ls_compute_charge+"'")

SELECT dbo.Customer.Cust_name, dbo.Customer.Address_1, dbo.Customer.address_2, dbo.Customer.address_3, dbo.Customer.city, dbo.Customer.state, dbo.Customer.zip   
 INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
 FROM dbo.Customer  
WHERE dbo.Customer.Project_id = :gs_project  and dbo.Customer.cust_code = '123BILLING' ;

IF IsNull(ls_Remit_Name) then ls_Remit_Name = ""
IF IsNull(ls_Remit_address1) then ls_Remit_address1 = ""
IF IsNull(ls_Remit_address2) then ls_Remit_address2 = ""
IF IsNull(ls_Remit_address3) then ls_Remit_address3 = ""
IF IsNull(ls_Remit_city) then ls_Remit_city = ""
IF IsNull(ls_Remit_state) then ls_Remit_state = ""
IF IsNull(ls_Remit_Zip) then ls_Remit_Zip = ""

if ls_Remit_Name <> "" then
	ls_remit = ls_remit_name + "~r~n"
end if

if ls_Remit_address1 <> "" then
	ls_remit = ls_remit + ls_Remit_address1 + "~r~n"
end if 

if ls_Remit_address2 <> "" then
	ls_remit = ls_remit + ls_Remit_address2 + "~r~n"
end if

if ls_Remit_address3 <> "" then
	ls_remit = ls_remit + ls_Remit_address3 + "~r~n"
end if

ls_remit = ls_remit + ls_remit_city + ", " + ls_remit_state + ", " + ls_remit_zip 

adw_bol.Modify("c_remit_name.Expression=~'~""+ls_remit+"~"~'")

//Retrieve the report

adw_bol.SetTransObject(sqlca)

adw_bol.Retrieve(gs_project, as_dono)

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetItem(1, "c_pieces1", ll_Carton )		
if lds_ds.rowcount() > 0 then
	ls_desc = lds_ds.GetItemstring( 1, "Code_Description") + lsDesc2
else
	ls_desc = lsDesc2
	if isNull( lsDesc2) or len( trim( lsDesc2 ) ) = 0 then ls_desc = 'No Description Available'
end if
adw_bol.SetItem(1, "c_desc1" , ls_desc )		
adw_bol.SetItem(1, "c_weight1" , ld_weight  )		
adw_bol.SetItem(1, "c_desc2" , lsdesc3 )
adw_bol.SetItem(1, "c_desc3" , lsdesc4 )
		
// Fill AWB BOL into C_ROUTE
ls_AWB_BOL = w_do.idw_other.GetItemString(1,"AWB_BOL_NO")
If Not isnull(ls_AWB_BOL) Then
	adw_bol.setitem(1,'c_route',ls_awb_bol)
end if 		
	
//Push Footer Down
of_parsetoArray( adw_bol.Describe('Datawindow.Objects') ,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)
For i = 1 to ll_nbrobjects
	ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
	ls_type = trim(adw_bol.Describe(ls_dwobjs[i]+'.type'))
	if ls_type = "line" then
	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y1'))
	else
	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y'))
	end if
	if (li_y >= li_start_y) and &
		(left(ls_col_name, 6) <> "c_piec" and &
		left(ls_col_name, 6) <> "c_desc" and &
		left(ls_col_name, 6) <> "c_rate" and &
		left(ls_col_name, 6) <> "c_weig" and &
		left(ls_col_name, 6) <> "t_fill") then
			if ls_type = "line"  then
				adw_bol.Modify(ls_dwobjs[i] + ".y1=" + string(li_y + li_offset) + " " + ls_dwobjs[i] + ".y2=" + string(li_y + li_offset))
			else
				adw_bol.Modify(ls_dwobjs[i] + ".y=" + string(li_y + li_offset))
			end if
	  END IF
NEXT

li_tab_order =  integer(adw_bol.describe(ls_last_col+".TabSequence")) + 1

for i = 1 to UpperBound(ls_change_tab)
	adw_bol.modify(ls_change_tab[i]+".TabSequence=0")
	ls_tab_change = ls_tab_change + " " + ls_change_tab[i]+".TabSequence=" + string(li_tab_order) + " "
	li_tab_order = li_tab_order + 10
next	
adw_bol.Modify(ls_tab_change)

ll_height = long(adw_bol.Describe("DataWindow.detail.height"))

ll_height = ll_height + li_offset

adw_bol.Modify("DataWindow.detail.height="+string(ll_height))

adw_bol.SetRedraw(true)

RETURN 1
end function

public function integer uf_process_bol_generic (string as_dono, ref datawindow adw_bol);// int = uf_process_bol_generic( string as_dono, ref datawindow adw_bol )

integer 		li_current_id = 46   //Last Column ID in the select to know where to start.
integer 		li_start_y = 1976 // 1804
integer 		li_y 
integer 		li_height = 72 
integer 		li_space = 76 
integer 		li_start_tab = 30 
integer 		li_tab_order 
integer 		li_offset
integer 		li_tab
integer 		i, i2
integer 		li_change_tab[]
integer 		li_max_tab
integer 		li_min_tab
integer 		li_rtn_item 
integer 		li_idx_rtn_item 
integer 		li_from_pos
integer 		li_retrive_pos
integer 		li_text_pos
integer		liCheck

string ls_dwobjs[]
string ls_col_name
string ls_change_tab[]
string ls_change_tab_temp[]
string ls_select
string ls_add_select
string ls_new_select
string ls_add_column
string ls_add_table_column
string ls_compute_piece
string ls_compute_weight
string ls_compute_charge
string ls_syntax
string ls_desc
string lsdesc2
string lsdesc3
string  lsdesc4
string ls_tab_change
string ls_last_col
string ls_Remit_Name
string ls_Remit_address1
string ls_Remit_address2
string ls_Remit_address3
string ls_Remit_city
string ls_Remit_state
string ls_Remit_Zip
string ls_AWB_BOL
string ls_type
string ls_remit
string	sql_syntax, ERRORS
String	lsSpecIns, lsCustCode, lsWhCode, lsDoNo6, lsUCCS
String lsVicsBol, lsCompanyPrefix, lsUccLocationPrefix

long	ll_nbrobjects
long 	ll_height
long  ll_carton
long	llRowPos, llRowCount
long ll_count

double ld_weight

datastore lds_ds, ldsPack
	
//Loop through and get old tab orders.
of_parsetoArray( adw_bol.Describe('Datawindow.Objects') ,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)
For i = 1 to ll_nbrobjects
	li_tab = integer(adw_bol.Describe(ls_dwobjs[i]+'.TabSequence'))
	ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
	if li_tab >= li_start_tab then
		ls_change_tab[UpperBound(ls_change_tab)+1] = ls_col_name
		li_change_tab[UpperBound(ls_change_tab)] = li_tab
		if li_tab > li_max_tab then
			li_max_tab = li_tab
		end if
		if li_tab < li_min_tab then
			li_min_tab = li_tab
		end if
	end if
next
for i = li_min_tab to li_max_tab step 10
	for i2 = 1 to UpperBound(ls_change_tab)
		if i = li_change_tab[i2] then
			ls_change_tab_temp[UpperBound(ls_change_tab_temp) + 1] = ls_change_tab[i2]
			EXIT;		
		end if
	next
next

ls_change_tab = ls_change_tab_temp

lds_ds = f_datastoreFactory("d_gmbattery_bol_group_details")
li_rtn_item = lds_ds.Retrieve(as_dono)

// 11/07 - PCONKL - All packing rows for a carton have the same gross weight. We need the sum for each distinct carton_no 
//							not sure how to do that in SQL so retreiving into DS and summing

//select sum(distinct (dbo.Delivery_Packing.weight_gross)  ) 
// INTO :ld_weight 
// FROM dbo.Delivery_Packing  
//WHERE dbo.Delivery_Packing.DO_No = :as_dono ;

ldsPack = Create Datastore

//Create the Datastore...
sql_syntax = "select distinct carton_no, weight_gross from delivery_PAcking where do_no = '" + as_dono + "';" 
ldsPack.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
ldsPack.SetTransobject(sqlca)

ld_weight = 0
lLRowCount = ldsPack.Retrieve()
If llRowCount > 0 Then
	For llRowPOs = 1 to llRowCount
		If ldsPAck.GetITemNumber(llRowPos,'weight_gross') > 0 Then
			ld_weight += ldsPAck.GetITemNumber(llRowPos,'weight_gross')
		End If
	next
End If

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc2 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC2';

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc3 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC3';

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc4 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC4';

SELECT  count(distinct(dbo.Delivery_Packing.Carton_No))  
 INTO :ll_carton  
 FROM dbo.Delivery_Packing  
WHERE dbo.Delivery_Packing.DO_No = :as_dono ;

li_y = li_start_y
li_tab_order = li_start_tab

for li_idx_rtn_item = 1 to 5 // ll_num_total_rows

	//Everything must in the correct order!

	ls_add_select = ls_add_select + ", 0000 as c_pieces" + string(li_idx_rtn_item) + ",   ~~~'                                 ~~~' as c_desc"+string(li_idx_rtn_item) + ", 0000.00 as c_weight"+string(li_idx_rtn_item) + ", '     ' as c_weight_ind"+string(li_idx_rtn_item) + ", 0000.00 as c_rate" + string(li_idx_rtn_item)
 	ls_add_table_column = ls_add_table_column + " column=(type=long updatewhereclause=yes name=c_pieces"+string(li_idx_rtn_item)+" dbname=~"c_pieces"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=char(33) updatewhereclause=yes name=c_desc"+string(li_idx_rtn_item)+" dbname=~"c_desc"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_weight"+string(li_idx_rtn_item)+" dbname=~"c_weight"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=char(5) updatewhereclause=yes name=c_weight_ind"+string(li_idx_rtn_item)+" dbname=~"c_weight_ind"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_rate"+string(li_idx_rtn_item)+" dbname=~"c_rate"+string(li_idx_rtn_item)+"~" ) "

	if li_idx_rtn_item > 1 then ls_compute_piece = ls_compute_piece + " + "
	ls_compute_piece 	= ls_compute_piece + " c_pieces" +string(li_idx_rtn_item)
	if li_idx_rtn_item > 1 then ls_compute_weight = ls_compute_weight + " + "
	ls_compute_weight	= ls_compute_weight + " c_weight" +string(li_idx_rtn_item)
	if li_idx_rtn_item > 1 then ls_compute_charge = ls_compute_charge + " + "
	ls_compute_charge	= ls_compute_charge + " c_pieces_rate_sub" +string(li_idx_rtn_item)
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"72~" width=~"1582~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler"+string(li_idx_rtn_item)+" font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"2220~" y=~""+string(li_y)+"~" height=~"72~" width=~"130~" format=~"[general]~"  name=c_weight_ind"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~"  visible =~"0~") "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2427~" y=~""+string(li_y)+"~" height=~"72~" width=~"480~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~" c_pieces"+string(li_idx_rtn_item)+" * c_rate"+string(li_idx_rtn_item)+" ~"border=~"2~" color=~"0~" x=~"2912~" y=~""+string(li_y)+"~" height=~"72~" width=~"434~" format=~"###,###.00~"  name=c_pieces_rate_sub"+string(li_idx_rtn_item)+"  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	li_y = li_y + li_space
	li_offset = li_offset + li_space
	ls_last_col = "c_rate"+string(li_idx_rtn_item)
next
ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece+"~" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_piece_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler_weight font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~""+ls_compute_weight+"~" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
li_offset = li_offset + li_space
ls_syntax = adw_bol.Describe("DataWindow.Syntax")
ls_add_select = ls_add_select + " "
ls_select = adw_bol.Describe("Datawindow.Table.Select")
ls_new_select = ls_syntax
li_retrive_pos = Pos(lower(ls_new_select), "retrieve=")
ls_new_select = left( ls_new_select, li_retrive_pos - 1) + ls_add_table_column + mid( ls_new_select, li_retrive_pos - 1)
li_from_pos = POS(upper(ls_new_select), " FROM ")
ls_new_select = left( ls_new_select, li_from_pos - 2) + ls_add_select + mid( ls_new_select, li_from_pos - 2)  
li_text_pos = POS(lower(ls_new_select), "text(")
ls_new_select = left( ls_new_select, li_text_pos - 1) + ls_add_column + mid( ls_new_select, li_text_pos - 1)  
ls_new_select = fu_quotestring(ls_new_select, "'")
adw_bol.Create(ls_new_select)
adw_bol.Modify("c_total.Expression='"+ls_compute_charge+"'")

//SELECT dbo.Customer.Cust_name, dbo.Customer.Address_1, dbo.Customer.address_2, dbo.Customer.address_3, dbo.Customer.city, dbo.Customer.state, dbo.Customer.zip   
// INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
// FROM dbo.Customer  
//WHERE dbo.Customer.Project_id = :gs_project  and dbo.Customer.cust_code = '123BILLING' ;
//

// Add the Bill To Address in the existing Bill To Box. Currently, it is being pulled from customer master where cust_code = ' 123BILLING'. 
//We should take it from the Bill To Address on the Delivery_Alt_Address where the code is 'BT'.

// 10/09 - Comcast is hardcoded, otherwise take from Delivery_Alt_address (just switched Comcast to use baseline)
If gs_project = 'COMCAST' Then
	
	//ls_remit = "Menlo - COM~rPO Box 5159~rPortland, OR 97208"
	ls_remit = "Comcast~r%XPO Logistics~rPO Box 5159~rPortland, OR 97208"
	
Else

	SELECT dbo.Delivery_Alt_Address.Name, dbo.Delivery_Alt_Address.Address_1, dbo.Delivery_Alt_Address.address_2, dbo.Delivery_Alt_Address.address_3, dbo.Delivery_Alt_Address.city, dbo.Delivery_Alt_Address.state, dbo.Delivery_Alt_Address.zip   
	 INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
	 FROM dbo.Delivery_Alt_Address  
	WHERE dbo.Delivery_Alt_Address.Do_No = :as_dono AND dbo.Delivery_Alt_Address.Project_id = :gs_project  and dbo.Delivery_Alt_Address.address_type = 'BT' ;

	IF IsNull(ls_Remit_Name) then ls_Remit_Name = ""
	IF IsNull(ls_Remit_address1) then ls_Remit_address1 = ""
	IF IsNull(ls_Remit_address2) then ls_Remit_address2 = ""
	IF IsNull(ls_Remit_address3) then ls_Remit_address3 = ""
	IF IsNull(ls_Remit_city) then ls_Remit_city = ""
	IF IsNull(ls_Remit_state) then ls_Remit_state = ""
	IF IsNull(ls_Remit_Zip) then ls_Remit_Zip = ""

	if ls_Remit_Name <> "" then
		ls_remit = ls_remit_name + "~r~n"
	end if

	if ls_Remit_address1 <> "" then
		ls_remit = ls_remit + ls_Remit_address1 + "~r~n"
	end if 

	if ls_Remit_address2 <> "" then
		ls_remit = ls_remit + ls_Remit_address2 + "~r~n"
	end if

	if ls_Remit_address3 <> "" then
		ls_remit = ls_remit + ls_Remit_address3 + "~r~n"
	end if

	ls_remit = ls_remit + ls_remit_city + ", " + ls_remit_state + ", " + ls_remit_zip 
	
End If

adw_bol.Modify("c_remit_name.Expression=~'~""+ls_remit+"~"~'")

//Retrieve the report

adw_bol.SetTransObject(sqlca)

adw_bol.Retrieve(gs_project, as_dono)

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetItem(1, "c_pieces1", ll_Carton )		
if lds_ds.rowcount() > 0 then
	ls_desc = lds_ds.GetItemstring( 1, "Code_Description") + lsDesc2
else
	ls_desc = lsDesc2
	if isNull( lsDesc2) or len( trim( lsDesc2 ) ) = 0 then ls_desc = 'No Description Available'
end if
adw_bol.SetItem(1, "c_desc1" , ls_desc )		
adw_bol.SetItem(1, "c_weight1" , ld_weight  )		
adw_bol.SetItem(1, "c_desc2" , lsdesc3 )
adw_bol.SetItem(1, "c_desc3" , lsdesc4 )

// Fill AWB BOL into C_ROUTE
ls_AWB_BOL = w_do.idw_other.GetItemString(1,"AWB_BOL_NO")

//GailM 12/10/2017 - I518 F5914 S14069 - KDO - Generate and print 17-digit number on BOL
If upper(gs_project) = 'KENDO' Then
	lsCustCode = adw_bol.GetItemString( 1, 'delivery_master_cust_code' )
	lsWhCode = w_do.idw_other.GetItemString( 1, 'wh_code' )
	SELECT count(*) INTO :ll_count FROM customer WHERE project_id = 'KENDO' AND cust_code = :lsCustCode AND user_field1 = 'JCP' USING sqlca;
	If ll_count > 0 Then
		SELECT ucc_company_prefix INTO :lsCompanyPrefix FROM project WHERE project_id = 'KENDO' USING sqlca;
		SELECT ucc_location_prefix INTO :lsUccLocationPrefix FROM warehouse WHERE wh_code = :lsWhCode USING sqlca;
		lsDoNo6 = RIGHT( w_do.idw_other.GetItemString(1,"do_no"), 6 )
		If Len( lsCompanyPrefix ) = 8 AND isNumber( lsCompanyPrefix ) Then
			If isNull( lsUccLocationPrefix ) OR lsUccLocationPrefix = '' Then
				lsUccLocationPrefix = '00'
			ElseIf  Len( lsUccLocationPrefix ) = 1 AND isNumber( lsUccLocationPrefix ) Then
				lsUccLocationPrefix = '0' + lsUccLocationPrefix
			ElseIf NOT  isNumber( lsUccLocationPrefix ) Then
				messagebox( "Error with AWB BOL number", "Kendo's WH " + lsWhCode + " , UccLocationPrefix: " + lsUccLocationPrefix + " is invalid" )
			End If
			If NOT isNumber(lsDoNo6) Then
				lsDoNo6 = Right( lsDoNo6,5 ) + '0'	//Not needed but entered in case the 6 digit number is not a number
			End if
			
			lsUCCS =  trim( lsCompanyPrefix + lsUccLocationPrefix + lsDoNo6 )
			liCheck = f_var_len_uccs_check_digit( lsUCCS ) 		
			If liCheck >= 0 Then
				ls_AWB_BOL = lsUCCS + string( liCheck )
			Else
				messagebox("Error with AWB BOL number", "Kendo's AWB BOL number: " + lsUCCS + " is invalid.  Check project UCC company prefix and warehouse UCC location prefix." )
			End If
		Else
			messagebox("Error with AWB BOL number", "Kendo's UCC company prefix: " + lsCompanyPrefix + " is invalid.  Must be a number and 8 digits." )
		End If
	End If
End If
		
If Not isnull(ls_AWB_BOL) Then
	adw_bol.setitem( 1, 'c_route', ls_awb_bol )
	w_do.idw_other.SetItem( 1, "AWB_BOL_NO", ls_awb_bol )  // ib_changed in w_do will be set to True to ensure number is saved to OtherInfo Tab
end if 		
	
//Push Footer Down
of_parsetoArray( adw_bol.Describe('Datawindow.Objects') ,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)
For i = 1 to ll_nbrobjects
	ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
	ls_type = trim(adw_bol.Describe(ls_dwobjs[i]+'.type'))
	if ls_type = "line" then
	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y1'))
	else
	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y'))
	end if
	if (li_y >= li_start_y) and &
		(left(ls_col_name, 6) <> "c_piec" and &
		left(ls_col_name, 6) <> "c_desc" and &
		left(ls_col_name, 6) <> "c_rate" and &
		left(ls_col_name, 6) <> "c_weig" and &
		left(ls_col_name, 6) <> "t_fill") then
			if ls_type = "line"  then
				adw_bol.Modify(ls_dwobjs[i] + ".y1=" + string(li_y + li_offset) + " " + ls_dwobjs[i] + ".y2=" + string(li_y + li_offset))
			else
				adw_bol.Modify(ls_dwobjs[i] + ".y=" + string(li_y + li_offset))
			end if
	  END IF
NEXT

li_tab_order =  integer(adw_bol.describe(ls_last_col+".TabSequence")) + 1

for i = 1 to UpperBound(ls_change_tab)
	adw_bol.modify(ls_change_tab[i]+".TabSequence=0")
	ls_tab_change = ls_tab_change + " " + ls_change_tab[i]+".TabSequence=" + string(li_tab_order) + " "
	li_tab_order = li_tab_order + 10
next	
adw_bol.Modify(ls_tab_change)

ll_height = long(adw_bol.Describe("DataWindow.detail.height"))

ll_height = ll_height + li_offset

adw_bol.Modify("DataWindow.detail.height="+string(ll_height))

//10/08 - PCONKL - Add special instructions (Customer UF9) for Comcast - Not really baseine but using a variance of the baseline BOL
If gs_project = 'COMCAST' and adw_bol.RowCount() > 0 Then
	
	lsCustCode = adw_bol.GetITemString(1,'Delivery_Master_Cust_Code')
	
	Select User_Field9 into :lsSpecIns
	From Customer
	Where project_id = :gs_Project and cust_Code = :lsCustCode;
	
	If lsSpecIns > '' Then
		adw_bol.Modify("special_instructions_t.text='" + lsSpecIns + "'")
	End If
	
End If
	
adw_bol.SetRedraw(true)


RETURN 1
end function

public function integer uf_process_bol_petco (string as_dono, ref datawindow adw_bol);// uf_process_bol_petco()

/*dts - 4/27/05: 
  This is in a state of migration from original manual, all-in-detail method
    to header/detail/footer method to allow for multiple pages
    PHX wanted it moved to production even though questions remained (about updatable fields, footer position, etc.)
  Still need to tie up loose ends, but I suspect that we'll be going back
    to (modified) manual method so work-in-progress remains.
*/               
integer li_current_id = 45  //Last Column ID in the select to know where to start.
integer li_start_y = 1308, li_y, li_height = 72, li_space = 76, li_start_tab = 30, li_tab_order, li_offset
//integer li_start_y = 191, li_y, li_height = 72, li_space = 76, li_start_tab = 30, li_tab_order, li_offset
LONG    ll_nbrobjects
string  ls_dwobjs[]
string  ls_objects
string ls_col_name
integer li_tab, i
integer li_change_tab[], li_max_tab, li_min_tab
string ls_change_tab[], ls_change_tab_temp[]
integer i2, li_rtn2, li_idx
string ls_cust_code, ls_cust_order_no
string ls_select
datastore lds_ds, lds_po, lds_po_multi, lds_notes
integer li_rtn_item, li_idx_rtn_item, li_from_pos
string ls_po
boolean lb_multi_run
integer li_rtn3
integer li_idx2
string ls_po_list
string ls_add_select, ls_new_select
string ls_add_column
string ls_add_table
string ls_add_table_column
string ls_compute_piece, ls_compute_weight, ls_compute_charge
string ls_syntax
integer li_retrive_pos, li_text_pos
integer li_qty 
string ls_desc
double ld_weight
string ls_tab_change
string ls_last_col
string ls_chep_pallets, ls_notes, ls_dono, ls_note_separator, ls_chep_pallets_half, lsChepMsg
long	 ll_count, ll_row

string ls_po_temp[], ls_reset_po_temp[]	
boolean ib_found
integer p
integer li_note_ht
integer li_offset_notes

adw_bol.dataobject = "d_petco_bol_prt"

adw_bol.SetTransObject(SQLCA)

	
	li_y = li_start_y
	li_tab_order = li_start_tab
	
	//dts 4/5/05 - changed ll_row_per_page from 5 to 7
	long ll_row_per_page = 7, ll_num_total_rows
	
	//if mod(li_rtn_item, ll_row_per_page) <> 0 then
	
		//dts ll_num_total_rows = (1 + (integer((li_rtn_item/ll_row_per_page)))) * ll_row_per_page
		ll_num_total_rows = max(ll_row_per_page, li_rtn_item)
	
	//end if
	

//Retrieve the report

//adw_bol.SetTransObject(sqlca)

//adw_bol.Retrieve(gs_project, as_dono)
li_rtn_item = adw_bol.Retrieve(gs_project, as_dono) //lds_ds.Retrieve(as_dono, gs_project)
	// Add 1 row for chep pallets(user_field9)
	//  - and/or for Half Pallets (user_field11)
	If w_do.idw_other.RowCount() > 0 Then
		lsChepMsg = ''
		ls_chep_pallets = w_do.idw_other.GetItemString(1,"user_field9")
		If isnumber(ls_chep_pallets) Then
			lsChepMsg = ls_chep_pallets + " - Chep Pallets"
		end if 	
		
		// dts - 06/14/06 - Capturing Half Pallets in UF11
		ls_chep_pallets_half = w_do.idw_other.GetItemString(1,"user_field11")
		If IsNumber(ls_chep_pallets_half) and integer(ls_chep_pallets_half) > 0 Then
			lsChepMsg += ",  " + ls_chep_pallets_half + " - Half Pallets"
		end if
		
		if lsChepMsg > '' then
			adw_bol.RowsCopy (1, 1, Primary!, adw_bol, li_rtn_item +1, Primary!)
			adw_bol.setitem(li_rtn_item + 1,'units',0)
			adw_bol.setitem(li_rtn_item + 1,'group_desc',lsChepMsg)
			adw_bol.setitem(li_rtn_item + 1,'weight',0)
			adw_bol.setitem(li_rtn_item + 1,'rate',0)
			li_rtn_item ++
		end if

// pvh 02.16.06
//, if carrier = WICO, replace the Remit To name and address with COLLECT
//		if 	Upper( getcarrier() ) = 'WICO' then
//			adw_bol.object.project_client_name[ li_rtn_item ] = 'COLLECT'
//			adw_bol.object.project_address_1[ li_rtn_item ] = ''
//			adw_bol.object.project_address_2[ li_rtn_item ] = ''
//			adw_bol.object.project_address_3[ li_rtn_item ] = ''
//			adw_bol.object.project_city[ li_rtn_item ] = ''
//			adw_bol.object.project_state[ li_rtn_item ] = ''
//			adw_bol.object.project_zip[ li_rtn_item ] = ''
//			adw_bol.object.project_country[ li_rtn_item ] = ''
//		end if
// pvh 02.16.06 - EOM
	end if 		


	//***NOTES***//
	//populate Delivery Notes - not done automatically since dw not being retrieved
			ls_DONO = w_do.idw_main.GetItemString(1,"do_no")
	
			lds_notes = Create datastore
			lds_notes.DataObject = 'd_phxbrands_bol_notes'
			lds_notes.SetTransObject(sqlca)
			ll_count = lds_notes.Retrieve(gs_project, ls_DONO) 			
	
	/*Loop through each row in notes and populate columns on BOL
	  - if there are more than 7 lines of notes, don't create new line for each
	    but just string them together instead (with some spaces in between) */
		ls_notes = ''
		if ll_count > 7 then
			ls_note_separator = '   '
		else
			ls_note_separator = '~r'
		end if
		For ll_row = 1 to ll_count
			ls_notes += lds_notes.GetItemString(ll_row,'Note_Text') + ls_note_separator
		Next
		adw_bol.Modify("t_notes.text='" + ls_notes + "'")

RETURN 1
end function

public function integer uf_process_bol_scitex (string as_dono, ref datawindow adw_bol);integer li_rtn_item  
string ls_nbr_pallets, ls_dono, lsnbrMsg

adw_bol.dataobject = "d_scitex_bol_prt"

adw_bol.SetTransObject(SQLCA)

li_rtn_item = adw_bol.Retrieve(as_dono) 
	// Add 1 row for nbr pallets(user_field9)
	If w_do.idw_other.RowCount() > 0 Then
		lsnbrMsg = ''
		ls_nbr_pallets = w_do.idw_other.GetItemString(1,"user_field9")
		If isnumber(ls_nbr_pallets) Then
			lsnbrMsg =  "   *** Total Number of Pallets = " + ls_nbr_pallets
		end if 	
		
		if lsnbrMsg > '' then
			adw_bol.RowsCopy (1, 1, Primary!, adw_bol, li_rtn_item +1, Primary!)
			adw_bol.setitem(li_rtn_item + 1,'units',0)
			adw_bol.setitem(li_rtn_item + 1,'item_master_description',lsnbrMsg)
			adw_bol.setitem(li_rtn_item + 1,'uom_1','')
			adw_bol.setitem(li_rtn_item + 1,'weight',0)
			adw_bol.setitem(li_rtn_item + 1,'uom','')
			li_rtn_item ++
		end if

	end if 		

RETURN 1
end function

public function integer uf_process_sli_netapp (string asdono, ref datawindow adw_sli);
Long	llRowCount, llRowPos, llPackPos, llPAckCount, llCartonCount
Int	liPageSize, liEmptyRows, liMod
Decimal ldWeight
String	lsCartonSave, lsSOM

liPageSize = 23 /* currently 23 row per page */

If w_do.idw_Pack.RowCount() < 1 Then Return 0

adw_sli.SetTransObject(SQLCA)
llRowCOunt = adw_sli.Retrieve(asDONO)

//Pad to the correct number of lines so footer is at bottom
liEmptyRows = 0
If llRowCOunt < liPageSize Then
	liEmptyRows = liPageSize - llRowCOunt
ElseIf adw_sli.RowCount() > liPageSize Then
	liMod = Mod(llRowCOunt, liPageSize)
	If liMod > 0 Then
		liEmptyRows = liPageSize - liMod
	End IF
End If

If liEmptyRows > 0 Then
	For llRowPos = 1 to liEmptyRows
		adw_sli.InsertRow(0)
	Next
End If

ldWEight = 0
llCartonCount = 0

//Carton Coutn and Gross Weight
llPAckCount = w_do.idw_PAck.RowCount()
For llPAckPOs = 1 to llPAckCount
	
	If lscartonSave <> w_do.idw_PAck.GetITEmString(llPackPOs,'carton_no') Then
		
		llCartonCount ++
		
		If w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross') > 0 And Not isnull(w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross')) Then
			ldWEight += w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross')
		End If
		
	End If
	
	lsCartonSave = w_do.idw_PAck.GetITEmString(llPackPOs,'carton_no')
	
Next

// Carton Count may also be represented in Delivery Picking
// Box Count is entered in po_no2. A Single Line ITem may be a qty of 1 (or more) but have multiple cartons that need to be included in the total here 
// (but can't be included as seperate cartons on the PAcking List since a qty of 1 can't be split across multiple cartons 
llRowCount = w_do.idw_pick.RowCount()
For llRowPOs = 1 to llRowCount
	
	If isnumber(w_do.idw_Pick.GetITemString(llRowPOs,'po_no2')) Then
		llCartonCount += Long(w_do.idw_Pick.GetITemString(llRowPOs,'po_no2')) - 1 /*first carton is already counted in Packing Count */
	End If
	
Next /*Picking Row */

adw_sli.Modify("total_cartons_t.Text = '" + String(llCartonCount,"###0") + "'")
	
If w_do.idw_Pack.GetITemString(1,'standard_of_measure') = 'E' Then
	lsSOM = ' LBS'
Else
	lsSOM = ' KGS'
End If
	
adw_sli.MOdify("total_Weight_t.text = '" + String(ldWEight,"#####0.00") + lsSOM + "'")
	
Return 0
end function

public function integer uf_process_bol_sika (string as_dono, ref datawindow adw_bol);/*dts - 12/20/07: 
Modeled after Phxbrands, which was in a state of migration from original manual, 
	all-in-detail method to header/detail/footer method to allow for multiple pages
   PHX wanted it moved to production even though questions remained (about updatable fields, footer position, etc.)
	Still need to tie up loose ends, but I suspect that we'll be going back
   to (modified) manual method so work-in-progress remains.
	
For SIKA, we want to group/print by Freight Class (and Haz code/desc, UOM, ...?)
	
Consolidated BOL:
  We also want to check for other orders with the same ________ (awb_bol_no? Consolidation_NO?)
  so that we may consolidate the BOL.  Not applicable to multi-stop orders as 
  originally described - only Consolidated orders.

may want to use Get/Set SqlSelect to change the where clause depending on if we're
running a single BOL or a Consolidated one.
We'll want to check Status, Address, etc for eligible orders (see Shipments?)
string lsSQL
lssql = adw_bol.GetSqlSelect()
*/               
integer liBOLRows, liHeight, liLines
string lsCarrier, lsTemp, lsNote, lsNotes, lsNotes2, lsNotes3, lsBorder, lsModString
int li, liMaxLines, i, liLastSpace

datastore ldsNotes, ldsDetailLines//, ldsHeaderNotes
string Presentation_Str, lsSQL, dwSyntax_Str, lsErrText
string lsHazCd, lsProperShipName, lsLine
integer liNotes, liDetailLine, liDetailLines, liBOLRow, liFind

datastore ldsConsol
string lsConsolNo
int liConsol, liConsols

//Check for Consolidation Canditates...
ldsConsol = Create Datastore
presentation_str = "style(type=grid)"
lsConsolNo = w_do.idw_other.GetItemString(1, 'awb_bol_no') //w_do.idw_main.GetItemString(1,"do_no")

lsSQl = "Select do_no, invoice_no, ord_status from delivery_master " 
lsSQL += " Where project_id = 'SIKA' and awb_bol_no = '" + lsConsolNO + "'"
// dts - 06/02/08 - added condition to eliminate Voided orders...
lsSQL += " and ord_status <> 'V'"
//lsSQL += " and do_no <> '"  + as_DONO + "'"
dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsConsol.Create(dwsyntax_str, lsErrText)
ldsConsol.SetTransObject(SQLCA)
liConsols = ldsConsol.Retrieve()
string lsDONOList, lstDONO, lsThisOrder, lsNextOrder

lsDONOList = "'" + as_DONO + "'"
//string DO_NOs together to build Where clause for notes
if liConsols > 1 then
	for i = 1 to liConsols
		lstDONO = ldsConsol.GetItemString(i, "do_no")
		if lstDONO <> as_DONO then
			if ldsConsol.GetItemString(i, "ord_status") <> 'C' and ldsConsol.GetItemString(i, "ord_status") <> 'A' then
				//TEMPO - Do we want to force all orders to be in Packing
				// - is Completed ok?  What about reprinting BOL???...
				lsTemp = ldsConsol.GetItemString(i, "invoice_no")
				messageBox("Consolidation", "Order needs to be consolidated with order '" + lsTemp + "' and it's not Complete or in 'Packing' status")
				return 0
			end if
			lsDONOList += ", '" + lstDONO + "'"
		end if
	next
	/* Can we share the datawindow for BOL and Consolidated BOL???
					//change sql to use awb_bol_No...
					int liWherePos
					lsSQL = adw_bol.GetSqlSelect()
					liWherePos = Pos(lsSQL, 'DM.do_no = :as_dono', 1)
					lsSQL = replace(lsSQL, liWherePos, 19, 'DM.awb_bol_No = :as_dono')
					messagebox("TEMPO", lssql)
					lsTemp = adw_bol.Modify("DataWindow.Table.Select='" + lsSQL + "'")
					messagebox("TEMPO - dw Modify Rtn Value", lsTemp)
					lsSQL = adw_bol.GetSqlSelect()
					messagebox("TEMPO-after SetSQL", lssql)
					*/
	adw_bol.dataobject = "d_sika_bol_consol_prt"
	adw_bol.SetTransObject(SQLCA)
	liBOLRows = adw_bol.Retrieve(gs_project, lsConsolNo)
else
	adw_bol.dataobject = "d_sika_bol_prt"
	adw_bol.SetTransObject(SQLCA)
	liBOLRows = adw_bol.Retrieve(gs_project, as_dono)
end if

if liBOLRows < 1 then
	MessageBox ("BOL", "No BOL data found. Make sure all Items have valid HazTextCd entries")
	return 0
end if
//look up carrier name based on DM.Carrier
lsTemp = adw_bol.GetItemString(1, 'Delivery_master_Carrier')
select carrier_name into :lsCarrier
from Carrier_Master
where project_id = 'SIKA'
and carrier_code = :lsTemp;

//if lsCarrier = '' then 
adw_bol.Modify("t_CarrierName.text='" + lsCarrier + "'")

ldsNotes = Create Datastore
ldsDetailLines = Create Datastore
presentation_str = "style(type=grid)"

//for liConsol = 1 to liConsols
lsSQl = "Select do_no, line_item_no, note_text from delivery_notes " 
//lsSQL += " Where do_no = '" + as_DONO + "' and note_type in ('BL', 'PB')"
lsSQL += " Where do_no in (" + lsDONOList +") and note_type in ('BL', 'PB')"
dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
//		messagebox("TEMPO", 'dwsyntax_str: ' + dwsyntax_str)
ldsNotes.Create(dwsyntax_str, lsErrText)
ldsNotes.SetTransObject(SQLCA)
liNotes = ldsNotes.Retrieve()

For liBOLRow = 1 to liBOLRows
	/*BOL Notes could be at the line level
	  - But that doesn't make sense as we're grouping by FrtClass/HazClass...
	  - So, Find the line #s associated with the BOL Roll-up (same Frt Class, HazCd, ...*/
	lsHazCd = adw_bol.GetItemString(liBOLRow, "hazard_text_cd")
	lsProperShipName = adw_bol.GetItemString(liBOLRow, "Group_Desc")
	lsThisOrder = adw_bol.GetItemString(liBOLRow, "do_no")
	if liBOLRow = liBOLRows then
		lsNextOrder = 'NONE'
	else
		lsNextOrder = adw_bol.GetItemString(liBOLRow + 1, "do_no") 
	end if
	//messagebox("TEMPO", "ThisOrder: " + lsThisorder +", NextOrder: " +lsNextOrder)
	lsSQL = " select line_item_no from delivery_detail dd, item_master im"
	lsSQL += " where project_id = 'sika'"
	lsSQL += " and dd.sku = im.sku"
	//lsSQL += " and do_no = '" + as_dono + "'" //????? why did this work? Don't we need to vary dono as we scroll through?
	lsSQL += " and do_no = '" + lsThisOrder + "'"
	lsSQL += " and hazard_text_cd = '" + lsHazCd + "'"
	lsSQL += " and user_field15 = '" + lsProperShipName + "'" //Freight Class Description is stored in IM.UF15
	//TEMPO - Need to add UOM to this ???
	dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
	ldsDetailLines.Create(dwsyntax_str, lsErrText)
	ldsDetailLines.SetTransObject(SQLCA)
	liDetailLines = ldsDetailLines.Retrieve()
	
	lsNotes = ''
	lsBorder = '#**************************************************************************************************#'
	for liDetailLine = 1 to liDetailLines
		//grab the notes for this line...
		lsLine = string(ldsDetailLines.GetItemNumber(liDetailLine, "line_item_no"))
		liFind = ldsNotes.Find("do_no='" +lsThisOrder +"' and line_item_no = " + lsLine, 1, liNotes+1) //liDetailLines)
		do while liFind > 0
			if len(lsNotes) = 0 then
				//build the notes block - only first line for given Frt/Haz
				lsNotes = lsBorder
			end if
			lsNote = ldsNotes.GetItemString(liFind, "Note_Text")
			if Pos(Upper(lsNotes), Upper(lsNote), 1) = 0 then
				//don't add to Notes if we already have the same note from another line
				//lsNotes += '~r**      ' + lsNote + space(44 - len(lsNote)) + '**'
				lsNotes += ' ' + lsNote
			end if
			liFind = ldsNotes.Find("do_no='" +lsThisOrder +"' and line_item_no = " + lsLine, liFind+1, liNotes+1) //liDetailLines)
			i++ //TEMPO - Do we want to limit the notes?
			//if i > 5 then
			if len(lsNotes) > 500 then
				liFind = 0
			end if
		loop //finding notes for current detail line (not BOL line, detail line)
	next //Next Delivery Detail line (for given BOL Line)
	if len(lsNotes) > 0 then
		//lsNotes += '~r******************************************************'
		lsNotes3 = lsBorder
	end if
	//messagebox("TEMPO-setting c_notes", string(liBOLRow) + lsnotes)
	adw_bol.SetItem(liBOLRow, "c_notes", lsNotes)
	adw_bol.SetItem(liBOLRow, "c_notes2", lsNotes2)
	adw_bol.SetItem(liBOLRow, "c_notes3", lsNotes3)
	
	//if liBOLRow = liBOLRows then
	if lsThisOrder <> lsNextOrder then
		//Last BOLRow - add Order BOL Notes (will need to change this for consolidated BOL)
		//Last Row for Order - add Order Header BOL Notes
		liFind = ldsNotes.Find("do_no='" + lsThisOrder +"' and line_item_no = 0", 1, liNotes+1) //liDetailLines)
		i = 0
		do while liFind > 0
			//looks like a text box has a max of 508 chars (wtf?)
			//, so, throw it all in lsNotes and then chop it in the last space before 508...
			//messagebox("TEMPO-header notes", "BOLRow: " +string(liBOLRow) + ", DetailLine: " + string(liDetailLine) + ", liFind: " + string(liFind))
			lsNote = ldsNotes.GetItemString(liFind, "Note_Text")
			if len(lsNotes) = 0 then
				//build the notes block
				lsNotes = lsBorder + '~r'
				lsNotes += lsNote
			else
				//if it's not the first note, put a space in between...
				lsNotes += ' ' + lsNote
			end if
			
			liFind = ldsNotes.Find("do_no='" + lsThisOrder + "' and line_item_no = 0", liFind+1, liNotes+1) //liDetailLines)
//			messagebox("TEMPO-header notes: i:" +string(i) + ", liFind: " + string(liFind), lsNotes)
			i++
			//if i > 18 then
			if len(lsNotes) > 1000 then 
				liFind = 0
			end if
		loop //finding all Order Header BOL notes (where line_item_no = 0)
		if i > 0 then //len(lsNotes) > 0 then
			liLines = len(lsNotes) / 100 
			liHeight = (liLines + 2) * 50
			//about 100 chars per line of notes, add two for borders then multiply by 50 for height
			if len(lsNotes) > 500 then
				//split on last space before 500....
				liLastSpace = LastPos(lsNotes, ' ', 500)
				if liLastSpace = 0 then liLastSpace = 500
				lsNotes2 = mid(lsNotes, liLastSpace)
				lsNotes = left(lsNotes, liLastSpace)
				if len(lsNotes2) > 500 then
					//split on last space before 500....
					liLastSpace = LastPos(lsNotes2, ' ', 500)
					if liLastSpace = 0 then liLastSpace = 500
					lsNotes3 = mid(lsNotes2, liLastSpace)
					lsNotes2 = left(lsNotes2, liLastSpace)
				end if
			end if
			//messagebox("TEMPO-header notes: i:" +string(i), "Notes: " + string(len(lsNotes)) + ", Notes2: " + string(len(lsNotes2)) + ", LastSpace: " + string(liLastSpace))
			if len(lsNotes3) = 0 then
				//place closing block in the 2nd note...
				lsNotes3 = lsBorder
			else
				//add a new line if there's notes in lsNotes3
				lsNotes3 += '~r' +lsBorder
			end if
		end if

	end if //last BOL Row (liBOLRow = liBOLRows)
	//messagebox("TEMPO-setting c_notes (after header block)", string(liBOLRow) + lsnotes)
	//adw_bol.SetItem(liBOLRows, "c_notes", lsNotes)
	adw_bol.SetItem(liBOLRow, "c_notes", lsNotes)
	if len(lsNotes2) > 0 then
		//messagebox("TEMPO-setting c_notes2", string(liBOLRow) + lsnotes2)
		adw_bol.SetItem(liBOLRow, "c_notes2", lsNotes2)
	end if
	if len(lsNotes3) > 0 then
		//messagebox("TEMPO-setting c_notes2", string(liBOLRow) + lsnotes2)
		adw_bol.SetItem(liBOLRow, "c_notes3", lsNotes3)
		//draw the line to the bottom of c_notes3...
		//adw_bol.object.l_2.y2 = (adw_bol.object.c_notes3.y + adw_bol.object.c_notes3.height)
//modstring = "emp_id.Color='16777215 ~t If(emp_status=~~'A~~',255,16777215)'"	
//liHeight = int(adw_bol.object.c_notes3.y) + int(adw_bol.object.c_notes3.height)

/*TEMPO - Line Height
lstemp = adw_bol.object.c_notes3.y
messagebox("Y", lstemp)
liHeight = liHeight + integer(lsTemp) //add height of notes to starting point...
lsTemp = string(liHeight)
messagebox("height", lsTEmp)
lsModString = "l_2.y2='191 ~t If(len(c_notes3)>0, " + lstemp + ", 40)'"	
messagebox("Mod squad", lsModString)
		adw_bol.Modify(lsModString)
TEMPO!! Line Height!		*/
	end if
Next //next BOL Row...

//insert 'CONSOLIDATED ORDER' into first line of detail section...

/*
if liConsols > 1 then
	adw_bol.InsertRow(1)
	adw_bol.SetItem(1, 'hazard_text', 'CONSOLIDATED ORDER')
	//need to set Header fields!?!
	//lssql = adw_bol.Object.DataWindow.Detail.Height
	//adw_bol.Modify("DataWindow.Detail.Height=60")
	i=adw_bol.SetDetailHeight (1, 1, 55)
	messagebox("tempo2 i=" +string(i), adw_bol.Describe("DataWindow.Detail.Height"))
end if
*/

// insert lines to fill the page... How many lines and what about multiple pages?
//  - this could vary as the size of the line will vary based on the haz description (and NOTES!).
//!! Need to finish this - what about multiple pages???
liMaxLines = 7
For li = 1 to (liMaxLines - liBOLRows) -liNotes //need to subtract something for notes
	adw_bol.InsertRow(0)
next

	/*
	//***NOTES***//
	//populate Delivery Notes - not done automatically since dw not being retrieved
			ls_DONO = w_do.idw_main.GetItemString(1,"do_no")
	
			lds_notes = Create datastore
			lds_notes.DataObject = 'd_phxbrands_bol_notes'
			lds_notes.SetTransObject(sqlca)
			ll_count = lds_notes.Retrieve(gs_project, ls_DONO) 			
	
	/*Loop through each row in notes and populate columns on BOL
	  - if there are more than 7 lines of notes, don't create new line for each
	    but just string them together instead (with some spaces in between) */
		ls_notes = ''
		if ll_count > 7 then
			ls_note_separator = '   '
		else
			ls_note_separator = '~r'
		end if
		For ll_row = 1 to ll_count
			ls_notes += lds_notes.GetItemString(ll_row,'Note_Text') + ls_note_separator
		Next
		adw_bol.Modify("t_notes.text='" + ls_notes + "'")
		*/

RETURN 1

end function

public function integer uf_process_eut_do (string asdono, ref datawindow adw_sli);
Long	llRowCount, llRowPos, llPackPos, llPAckCount, llCartonCount
Int	liPageSize, liEmptyRows, liMod
Decimal ldWeight
String	lsCartonSave, lsSOM

liPageSize = 1 //23 /* currently 23 row per page */

If w_do.idw_Pack.RowCount() < 1 Then Return 0

adw_sli.SetTransObject(SQLCA)
llRowCOunt = adw_sli.Retrieve(asDONO)

//Pad to the correct number of lines so footer is at bottom
liEmptyRows = 0
If llRowCOunt < liPageSize Then
	liEmptyRows = liPageSize - llRowCOunt
ElseIf adw_sli.RowCount() > liPageSize Then
	liMod = Mod(llRowCOunt, liPageSize)
	If liMod > 0 Then
		liEmptyRows = liPageSize - liMod
	End IF
End If

If liEmptyRows > 0 Then
	For llRowPos = 1 to liEmptyRows
		adw_sli.InsertRow(0)
	Next
End If

ldWEight = 0
llCartonCount = 0

//Carton Coutn and Gross Weight
llPAckCount = w_do.idw_PAck.RowCount()
For llPAckPOs = 1 to llPAckCount
	
	If lscartonSave <> w_do.idw_PAck.GetITEmString(llPackPOs,'carton_no') Then
		
		llCartonCount ++
		
		If w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross') > 0 And Not isnull(w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross')) Then
			ldWEight += w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross')
		End If
		
	End If
	
	lsCartonSave = w_do.idw_PAck.GetITEmString(llPackPOs,'carton_no')
	
Next


adw_sli.Modify("total_cartons_t.Text = '" + String(llCartonCount,"###0") + "'")
	
If w_do.idw_Pack.GetITemString(1,'standard_of_measure') = 'E' Then
	lsSOM = ' LBS'
Else
	lsSOM = ' KGS'
End If
	
adw_sli.MOdify("total_Weight_t.text = '" + String(ldWEight,"#####0.00") + lsSOM + "'")
	
Return 0
end function

public function integer uf_process_rw_do (string asdono, ref datawindow adw_sli);
Long	llRowCount, llRowPos, llPackPos, llPAckCount, llCartonCount
Int	liPageSize, liEmptyRows, liMod
Decimal ldWeight
String	lsCartonSave, lsSOM

liPageSize = 1 // 23 /* currently 23 row per page */

If w_do.idw_Pack.RowCount() < 1 Then Return 0

adw_sli.SetTransObject(SQLCA)
llRowCOunt = adw_sli.Retrieve(asDONO)

//Pad to the correct number of lines so footer is at bottom
liEmptyRows = 0
If llRowCOunt < liPageSize Then
	liEmptyRows = liPageSize - llRowCOunt
ElseIf adw_sli.RowCount() > liPageSize Then
	liMod = Mod(llRowCOunt, liPageSize)
	If liMod > 0 Then
		liEmptyRows = liPageSize - liMod
	End IF
End If

If liEmptyRows > 0 Then
	For llRowPos = 1 to liEmptyRows
		adw_sli.InsertRow(0)
	Next
End If

ldWEight = 0
llCartonCount = 0

//Carton Coutn and Gross Weight
llPAckCount = w_do.idw_PAck.RowCount()
For llPAckPOs = 1 to llPAckCount
	
	If lscartonSave <> w_do.idw_PAck.GetITEmString(llPackPOs,'carton_no') Then
		
		llCartonCount ++
		
		If w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross') > 0 And Not isnull(w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross')) Then
			ldWEight += w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross')
		End If
		
	End If
	
	lsCartonSave = w_do.idw_PAck.GetITEmString(llPackPOs,'carton_no')
	
Next

adw_sli.Modify("total_cartons_t.Text = '" + String(llCartonCount,"###0") + "'")
	
If w_do.idw_Pack.GetITemString(1,'standard_of_measure') = 'E' Then
	lsSOM = ' LBS'
Else
	lsSOM = ' KGS'
End If
	
adw_sli.MOdify("total_Weight_t.text = '" + String(ldWEight,"#####0.00") + lsSOM + "'")
	
Return 0
end function

public function integer uf_process_bol_maquet (string as_dono, ref datawindow adw_bol);/*MEA - 12/08 - Copied from PHXBRANDS
*/               
integer li_current_id = 45  //Last Column ID in the select to know where to start.
integer li_start_y = 1308, li_y, li_height = 72, li_space = 76, li_start_tab = 30, li_tab_order, li_offset
//integer li_start_y = 191, li_y, li_height = 72, li_space = 76, li_start_tab = 30, li_tab_order, li_offset
LONG    ll_nbrobjects
string  ls_dwobjs[]
string  ls_objects
string ls_col_name
integer li_tab, i
integer li_change_tab[], li_max_tab, li_min_tab
string ls_change_tab[], ls_change_tab_temp[]
integer i2, li_rtn2, li_idx
string ls_cust_code, ls_cust_order_no
string ls_select
datastore lds_ds, lds_po, lds_po_multi, lds_notes
integer li_rtn_item, li_idx_rtn_item, li_from_pos
string ls_po
boolean lb_multi_run
integer li_rtn3
integer li_idx2
string ls_po_list
string ls_add_select, ls_new_select
string ls_add_column
string ls_add_table
string ls_add_table_column
string ls_compute_piece, ls_compute_weight, ls_compute_charge
string ls_syntax
integer li_retrive_pos, li_text_pos
integer li_qty 
string ls_desc
double ld_weight
string ls_tab_change
string ls_last_col
string ls_chep_pallets, ls_notes, ls_dono, ls_note_separator, ls_chep_pallets_half, lsChepMsg
long	 ll_count, ll_row

string ls_po_temp[], ls_reset_po_temp[]	
boolean ib_found
integer p
integer li_note_ht
integer li_offset_notes

adw_bol.dataobject = "d_maquet_bol_prt"

adw_bol.SetTransObject(SQLCA)

	
	li_y = li_start_y
	li_tab_order = li_start_tab
	
	//dts 4/5/05 - changed ll_row_per_page from 5 to 7
	long ll_row_per_page = 7, ll_num_total_rows
	
	//if mod(li_rtn_item, ll_row_per_page) <> 0 then
	
		//dts ll_num_total_rows = (1 + (integer((li_rtn_item/ll_row_per_page)))) * ll_row_per_page
		ll_num_total_rows = max(ll_row_per_page, li_rtn_item)
	
	//end if
	

//Retrieve the report

//adw_bol.SetTransObject(sqlca)

//adw_bol.Retrieve(gs_project, as_dono)
li_rtn_item = adw_bol.Retrieve(gs_project, as_dono) //lds_ds.Retrieve(as_dono, gs_project)
	// Add 1 row for chep pallets(user_field9)
	//  - and/or for Half Pallets (user_field11)
	If w_do.idw_other.RowCount() > 0 Then
		lsChepMsg = ''
		ls_chep_pallets = w_do.idw_other.GetItemString(1,"user_field9")
		If isnumber(ls_chep_pallets) Then
			lsChepMsg = ls_chep_pallets + " - Chep Pallets"
			/* Adding this row below, with the combined 'CHEP' and 'HALF' pallet info
			//li_rtn_item = adw_bol.InsertRow(0)
			//dwcontrol.RowsCopy ( long startrow, long endrow, DWBuffer copybuffer, datawindow targetdw, long beforerow, DWBuffer targetbuffer)
			//li_rtn_item = adw_bol.RowsCopy (1, 1, Primary!, adw_bol, 99, Primary!)
			adw_bol.RowsCopy (1, 1, Primary!, adw_bol, li_rtn_item +1, Primary!)
			//lds_ds.setitem(li_rtn_item,'group_desc',"Chep Pallets")
			adw_bol.setitem(li_rtn_item + 1,'units',0)
			adw_bol.setitem(li_rtn_item + 1,'group_desc',ls_chep_pallets + " - Chep Pallets")
			//adw_bol.setitem(li_rtn_item,'item_weight',0)
			adw_bol.setitem(li_rtn_item + 1,'weight',0)
			adw_bol.setitem(li_rtn_item + 1,'rate',0)
			//lds_ds.setitem(li_rtn_item,'item_quantity',integer(ls_chep_pallets))
			//adw_bol.setitem(li_rtn_item,'item_quantity','')
			//adw_bol.setitem(li_rtn_item,'units','')
			// pvh
			li_rtn_item ++
			*/
		end if 	
		
		// dts - 06/14/06 - Capturing Half Pallets in UF11
		ls_chep_pallets_half = w_do.idw_other.GetItemString(1,"user_field11")
		If IsNumber(ls_chep_pallets_half) and integer(ls_chep_pallets_half) > 0 Then
			lsChepMsg += ",  " + ls_chep_pallets_half + " - Half Pallets"
			/* Adding this row below, with the combined 'CHEP' and 'HALF' pallet info
			adw_bol.RowsCopy (1, 1, Primary!, adw_bol, li_rtn_item +1, Primary!)
			adw_bol.setitem(li_rtn_item + 1,'units',0)
			adw_bol.setitem(li_rtn_item + 1,'group_desc',ls_chep_pallets_half + " - Half Pallets")
			adw_bol.setitem(li_rtn_item + 1,'weight',0)
			adw_bol.setitem(li_rtn_item + 1,'rate',0)
			li_rtn_item ++
			*/
		end if
		
		if lsChepMsg > '' then
			adw_bol.RowsCopy (1, 1, Primary!, adw_bol, li_rtn_item +1, Primary!)
			adw_bol.setitem(li_rtn_item + 1,'units',0)
			adw_bol.setitem(li_rtn_item + 1,'group_desc',lsChepMsg)
			adw_bol.setitem(li_rtn_item + 1,'weight',0)
			adw_bol.setitem(li_rtn_item + 1,'rate',0)
			li_rtn_item ++
		end if

// pvh 02.16.06
//, if carrier = WICO, replace the Remit To name and address with COLLECT
		if 	Upper( getcarrier() ) = 'WICO' then
			adw_bol.object.project_client_name[ li_rtn_item ] = 'COLLECT'
			adw_bol.object.project_address_1[ li_rtn_item ] = ''
			adw_bol.object.project_address_2[ li_rtn_item ] = ''
			adw_bol.object.project_address_3[ li_rtn_item ] = ''
			adw_bol.object.project_city[ li_rtn_item ] = ''
			adw_bol.object.project_state[ li_rtn_item ] = ''
			adw_bol.object.project_zip[ li_rtn_item ] = ''
			adw_bol.object.project_country[ li_rtn_item ] = ''
		end if
// pvh 02.16.06 - EOM
	end if 		


	//***NOTES***//
	//populate Delivery Notes - not done automatically since dw not being retrieved
			ls_DONO = w_do.idw_main.GetItemString(1,"do_no")
	
			lds_notes = Create datastore
			lds_notes.DataObject = 'd_maquet_bol_notes'
			lds_notes.SetTransObject(sqlca)
			ll_count = lds_notes.Retrieve(gs_project, ls_DONO) 			
	
	/*Loop through each row in notes and populate columns on BOL
	  - if there are more than 7 lines of notes, don't create new line for each
	    but just string them together instead (with some spaces in between) */
		ls_notes = ''
		if ll_count > 7 then
			ls_note_separator = '   '
		else
			ls_note_separator = '~r'
		end if
		For ll_row = 1 to ll_count
			ls_notes += lds_notes.GetItemString(ll_row,'Note_Text') + ls_note_separator
		Next
		adw_bol.Modify("t_notes.text='" + ls_notes + "'")

RETURN 1
end function

public function integer uf_process_bol_pandora (string as_dono, ref datawindow adw_bol);integer 		li_current_id = 48   //Last Column ID in the select to know where to start.
integer 		li_start_y =  1490 // 1804  // 1976 //
integer 		li_height = 144 // orig 72
integer 		li_space = 152 // orig 76
integer 		li_start_tab = 30 
decimal ld_cost
long llownerid
long	ll_nbrobjects, ll_quantity
long 	ll_height
long  ll_carton
long	llRowPos, llRowCount
integer 		li_y, li_tab_order, li_offset, li_tab, i, i2, li_change_tab[], li_max_tab, li_min_tab, li_rtn_item, li_idx_rtn_item, li_from_pos, li_retrive_pos, li_text_pos
string ls_dwobjs[], ls_compute_cartons, ls_cartontype, ls_sku, ls_supplier, ls_userfield14, lsownercd, ls_col_name, ls_userfield, ls_costcenter, as_ordernum
string ls_change_tab[], ls_null[], ls_change_tab_temp[], ls_select, ls_add_select, ls_new_select, ls_add_column, ls_add_table_column, ls_compute_piece
string ls_compute_weight, ls_compute_charge, ls_syntax, ls_desc, lsdesc2, lsdesc3, lsdesc4, ls_tab_change, ls_last_col, ls_Remit_Name, ls_Remit_address1
string ls_Remit_address2, ls_Remit_address3, ls_Remit_city, ls_Remit_state, ls_Remit_Zip, ls_AWB_BOL, ls_type, ls_remit, sql_syntax, ERRORS, lsSpecIns, lsCustCode
double ld_weight
datastore lds_ds, ldsPack
datawindow ldw_pack
string ls_componentind, ls_trackingidtype, ls_firstcartonrow

// Get the original datawindow tab order.
f_getdwtaborder(adw_bol, li_start_tab, ls_change_tab)

////////////////////////////////////////////////////////////////////// Construct the Cost Center /////////////////////////////////////////////////////////////////////////
// Get the cost center.
f_getcostcenter(1, ld_cost)

// Get the order number.
as_ordernum = w_do.tab_main.tabpage_main.sle_order.text

// If the cost is null,
If isnull(ld_cost) then
	
	// Set the cost center to the order number.
	ls_costcenter = as_ordernum
	
// Otherwise, if the cost is not null,
Else
	
	// The cost center is defined as the cost and order number.
	ls_costcenter = string(ld_cost) + "/" + as_ordernum

// End if the cost is not null.
End If

w_do.tab_main.tabpage_bol.dw_bol_prt.object.t_costcenter.text = ls_costcenter
/////////////////////////////////////////////////////////////////////////////////////////

lds_ds = f_datastoreFactory("d_gmbattery_bol_group_details")

li_rtn_item = lds_ds.Retrieve(as_dono)

// 11/07 - PCONKL - All packing rows for a carton have the same gross weight. We need the sum for each distinct carton_no 
//							not sure how to do that in SQL so retreiving into DS and summing

ldsPack = Create Datastore

//Create the Datastore...
sql_syntax = "select distinct carton_no, weight_gross, sku, supp_code from delivery_PAcking where do_no = '" + as_dono + "';" 
ldsPack.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
ldsPack.SetTransobject(sqlca)

ld_weight = 0
lLRowCount = ldsPack.Retrieve()

ldw_pack = w_do.tab_main.tabpage_pack.dw_pack
//lLRowCount = ldw_pack.rowcount()

If llRowCount > 0 Then
	For llRowPOs = 1 to llRowCount
		If ldw_pack.GetITemNumber(llRowPos,'weight_gross') > 0 Then
			
			// Get the component indicator, tracking id type and first carton row.
			ls_componentind = ldw_pack.GetITemstring(llRowPos,'component_Ind')
			ls_trackingidtype = ldw_pack.GetITemstring(llRowPos,'tracking_id_type')
			ls_firstcartonrow = ldw_pack.GetITemstring(llRowPos,'c_first_carton_row')
			
			// If(component_Ind in("Y", "N", "") and  (isnull( tracking_id_type ) or tracking_id_type <> 'T') and  c_first_carton_row  = 'Y',0,1)
			// If the component ID is Y, N or blank,
			If ls_componentind = "Y" or ls_componentind = "N" or ls_componentind = "" and isnull(ls_trackingidtype) then
				
				// If the tracking id type isn't 't' or is null,
				if isnull(ls_trackingidtype) or ls_trackingidtype <> "T" then
					
					// If the first carton row is 'Y',
					if ls_firstcartonrow = "Y" then
			
						// Incriment the weight.
						ld_weight += ldw_pack.GetITemNumber(llRowPos,'weight_gross')
					End If
				End If
			End If
		End If
	next
End If

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc2 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC2';

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc3 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC3';

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc4 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC4';

SELECT  count(distinct(dbo.Delivery_Packing.Carton_No)), sum(quantity)  
 INTO :ll_carton, :ll_quantity
 FROM dbo.Delivery_Packing  
WHERE dbo.Delivery_Packing.DO_No = :as_dono ;

SELECT  carton_type 
 INTO :ls_cartontype
 FROM dbo.Delivery_Packing  
WHERE dbo.Delivery_Packing.carton_no = 
	(select min(carton_no) from dbo.delivery_packing where dbo.Delivery_Packing.DO_No = :as_dono)
and dbo.Delivery_Packing.DO_No = :as_dono ;

// If there is no carton type make it 'ea.'.
if isnull(ls_cartontype) then ls_cartontype = "Ea."

li_y = li_start_y
li_tab_order = li_start_tab

for li_idx_rtn_item = 1 to 5 // ll_num_total_rows

	//Everything must in the correct order!

	ls_add_select = ls_add_select + ", 0000 as c_cartons" + string(li_idx_rtn_item) + ", 0000 as c_pieces" + string(li_idx_rtn_item) + ",   ~~~'                                 ~~~' as c_desc"+string(li_idx_rtn_item) + ", 0000.00 as c_weight"+string(li_idx_rtn_item) + ", '     ' as c_weight_ind"+string(li_idx_rtn_item) + ", 0000.00 as c_rate" + string(li_idx_rtn_item)
 	ls_add_table_column = ls_add_table_column + " column=(type=long updatewhereclause=yes name=c_cartons"+string(li_idx_rtn_item)+" dbname=~"c_cartons"+string(li_idx_rtn_item)+"~" ) " + &
	 														  " column=(type=long updatewhereclause=yes name=c_pieces"+string(li_idx_rtn_item)+" dbname=~"c_pieces"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=char(33) updatewhereclause=yes name=c_desc"+string(li_idx_rtn_item)+" dbname=~"c_desc"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_weight"+string(li_idx_rtn_item)+" dbname=~"c_weight"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=char(5) updatewhereclause=yes name=c_weight_ind"+string(li_idx_rtn_item)+" dbname=~"c_weight_ind"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_rate"+string(li_idx_rtn_item)+" dbname=~"c_rate"+string(li_idx_rtn_item)+"~" ) "

	if li_idx_rtn_item > 1 then ls_compute_cartons = ls_compute_cartons + " + "
	ls_compute_cartons 	= ls_compute_cartons + " c_cartons" +string(li_idx_rtn_item)
	if li_idx_rtn_item > 1 then ls_compute_piece = ls_compute_piece + " + "
	ls_compute_piece 	= ls_compute_piece + " c_pieces" +string(li_idx_rtn_item)
	if li_idx_rtn_item > 1 then ls_compute_weight = ls_compute_weight + " + "
	ls_compute_weight	= ls_compute_weight + " c_weight" +string(li_idx_rtn_item)
	if li_idx_rtn_item > 1 then ls_compute_charge = ls_compute_charge + " + "
	ls_compute_charge	= ls_compute_charge + " c_pieces_rate_sub" +string(li_idx_rtn_item)
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~""+string(li_height)+"~" width=~"130~" format=~"#,##0~"  name=c_cartons"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"139~" y=~""+string(li_y)+"~" height=~""+string(li_height)+"~" width=~"135~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"144~" width=~"1582~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~""+string(li_height)+"~" width=~"558~"  name=t_filler"+string(li_idx_rtn_item)+" font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~""+string(li_height)+"~" width=~"350~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"2220~" y=~""+string(li_y)+"~" height=~""+string(li_height)+"~" width=~"130~" format=~"[general]~"  name=c_weight_ind"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~"  visible =~"0~") "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2427~" y=~""+string(li_y)+"~" height=~""+string(li_height)+"~" width=~"480~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~" c_pieces"+string(li_idx_rtn_item)+" * c_rate"+string(li_idx_rtn_item)+" ~"border=~"2~" color=~"0~" x=~"2912~" y=~""+string(li_y)+"~" height=~""+string(li_height)+"~" width=~"434~" format=~"###,###.00~"  name=c_pieces_rate_sub"+string(li_idx_rtn_item)+"  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	li_y = li_y + li_space
	li_offset = li_offset + li_space
	ls_last_col = "c_rate"+string(li_idx_rtn_item)
next

ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_cartons+"~" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~""+string(li_height)+"~" width=~"130~" format=~"#,##0~"  name=c_cartons_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece+"~" border=~"2~" color=~"0~" x=~"139~" y=~""+string(li_y)+"~" height=~""+string(li_height)+"~" width=~"135~" format=~"#,##0~"  name=c_piece_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~""+string(li_height)+"~" width=~"558~"  name=t_filler_weight font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~""+ls_compute_weight+"~" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~""+string(li_height)+"~" width=~"350~" format=~"###,###.00~"  name=c_weight_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
li_offset = li_offset + li_space
ls_syntax = adw_bol.Describe("DataWindow.Syntax")
ls_add_select = ls_add_select + " "
ls_select = adw_bol.Describe("Datawindow.Table.Select")
ls_new_select = ls_syntax
li_retrive_pos = Pos(lower(ls_new_select), "retrieve=")
ls_new_select = left( ls_new_select, li_retrive_pos - 1) + ls_add_table_column + mid( ls_new_select, li_retrive_pos - 1)
li_from_pos = POS(upper(ls_new_select), " FROM ")
ls_new_select = left( ls_new_select, li_from_pos - 2) + ls_add_select + mid( ls_new_select, li_from_pos - 2)  
li_text_pos = POS(lower(ls_new_select), "text(")
ls_new_select = left( ls_new_select, li_text_pos - 1) + ls_add_column + mid( ls_new_select, li_text_pos - 1)  
ls_new_select = fu_quotestring(ls_new_select, "'")
adw_bol.Create(ls_new_select)
adw_bol.Modify("c_total.Expression='"+ls_compute_charge+"'")

//SELECT dbo.Customer.Cust_name, dbo.Customer.Address_1, dbo.Customer.address_2, dbo.Customer.address_3, dbo.Customer.city, dbo.Customer.state, dbo.Customer.zip   
// INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
// FROM dbo.Customer  
//WHERE dbo.Customer.Project_id = :gs_project  and dbo.Customer.cust_code = '123BILLING' ;
//

// Add the Bill To Address in the existing Bill To Box. Currently, it is being pulled from customer master where cust_code = ' 123BILLING'. 
//We should take it from the Bill To Address on the Delivery_Alt_Address where the code is 'BT'.

SELECT dbo.Delivery_Alt_Address.Name, dbo.Delivery_Alt_Address.Address_1, dbo.Delivery_Alt_Address.address_2, dbo.Delivery_Alt_Address.address_3, dbo.Delivery_Alt_Address.city, dbo.Delivery_Alt_Address.state, dbo.Delivery_Alt_Address.zip   
 INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
 FROM dbo.Delivery_Alt_Address  
WHERE dbo.Delivery_Alt_Address.Do_No = :as_dono AND dbo.Delivery_Alt_Address.Project_id = :gs_project  and dbo.Delivery_Alt_Address.address_type = 'BT' ;

IF IsNull(ls_Remit_Name) then ls_Remit_Name = ""
IF IsNull(ls_Remit_address1) then ls_Remit_address1 = ""
IF IsNull(ls_Remit_address2) then ls_Remit_address2 = ""
IF IsNull(ls_Remit_address3) then ls_Remit_address3 = ""
IF IsNull(ls_Remit_city) then ls_Remit_city = ""
IF IsNull(ls_Remit_state) then ls_Remit_state = ""
IF IsNull(ls_Remit_Zip) then ls_Remit_Zip = ""

if ls_Remit_Name <> "" then
	ls_remit = ls_remit_name + "~r~n"
end if

if ls_Remit_address1 <> "" then
	ls_remit = ls_remit + ls_Remit_address1 + "~r~n"
end if 

if ls_Remit_address2 <> "" then
	ls_remit = ls_remit + ls_Remit_address2 + "~r~n"
end if

if ls_Remit_address3 <> "" then
	ls_remit = ls_remit + ls_Remit_address3 + "~r~n"
end if

ls_remit = ls_remit + ls_remit_city + ", " + ls_remit_state + ", " + ls_remit_zip 

adw_bol.Modify("c_remit_name.Expression=~'~""+ls_remit+"~"~'")

//Retrieve the report

adw_bol.SetTransObject(sqlca)
adw_bol.Retrieve(gs_project, as_dono)
//clipboard(adw_bol.getsqlselect())
//messagebox(as_dono, adw_bol.getsqlselect())

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If


// Set the number of cartons and number of pieces.
adw_bol.SetItem(1, "c_pieces1", ll_Carton )	
adw_bol.SetItem(1, "c_cartons1", ll_quantity )

//ls_cartontype = "zuv"
ls_cartontype = upper(left(ls_cartontype, 1)) + right(ls_cartontype, len(ls_cartontype) - 1)
adw_bol.object.pieces_t.text = ls_cartontype + "/~rPallets"


//if lds_ds.rowcount() > 0 then
//	ls_desc = lds_ds.GetItemstring( 1, "Code_Description") + lsDesc2
//else
//	ls_desc = lsDesc2
//	if isNull( lsDesc2) or len( trim( lsDesc2 ) ) = 0 then ls_desc = 'No Description Available'
//end if
		
llRowCount = ldsPAck.rowcount()
	
If llRowCount > 0 Then
//	For llRowPOs = 1 to llRowCount
//		If ldsPAck.GetITemNumber(1,'weight_gross') > 0 Then
			
			ls_sku = ldsPAck.getitemstring(1, "sku")
			ls_supplier = ldsPAck.getitemstring(1, "supp_code")
		
				// Select the detail data for this sku.
				Select description, user_field14
				Into	 :ls_Desc, :ls_userfield14
				From Item_Master
				Where Project_id = :gs_project and sku = :ls_sku and supp_code = :ls_supplier
				Using SQLCA;
				
				// If there is an error, show error message.
				if sqlca.sqlcode <> 0 then MessageBox ("DB Error", SQLCA.SQLErrText )
				
				// IF user field 14 is not null,
				If not isnull(ls_userfield14) then
					
					// Concatentate user field 14 to the description.
					ls_Desc = ls_Desc + "  " + ls_userfield14
				End If
//		End If
//	next
End If	

adw_bol.SetItem(1, "c_desc1" , ls_desc )
adw_bol.SetItem(1, "c_weight1" , ld_weight  )		
adw_bol.SetItem(1, "c_desc2" , lsdesc3 )
adw_bol.SetItem(1, "c_desc3" , lsdesc4 )
		
// Fill AWB BOL into C_ROUTE
ls_AWB_BOL = w_do.idw_other.GetItemString(1,"AWB_BOL_NO")
If Not isnull(ls_AWB_BOL) Then
	adw_bol.setitem(1,'c_route',ls_awb_bol)
end if 		
	
//Push Footer Down
of_parsetoArray( adw_bol.Describe('Datawindow.Objects') ,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)
For i = 1 to ll_nbrobjects
	ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
	ls_type = trim(adw_bol.Describe(ls_dwobjs[i]+'.type'))
	if ls_type = "line" then
	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y1'))
	else
	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y'))
	end if
	if (li_y >= li_start_y) and &
		(left(ls_col_name, 6) <> "c_cart" and &
		left(ls_col_name, 6) <> "c_piec" and &
		left(ls_col_name, 6) <> "c_desc" and &
		left(ls_col_name, 6) <> "c_rate" and &
		left(ls_col_name, 6) <> "c_weig" and &
		left(ls_col_name, 6) <> "t_fill") then
			if ls_type = "line"  then
				adw_bol.Modify(ls_dwobjs[i] + ".y1=" + string(li_y + li_offset) + " " + ls_dwobjs[i] + ".y2=" + string(li_y + li_offset))
			else
				adw_bol.Modify(ls_dwobjs[i] + ".y=" + string(li_y + li_offset))
			end if
	  END IF
NEXT

li_tab_order =  integer(adw_bol.describe(ls_last_col+".TabSequence")) + 1

for i = 1 to UpperBound(ls_change_tab)
	adw_bol.modify(ls_change_tab[i]+".TabSequence=0")
	ls_tab_change = ls_tab_change + " " + ls_change_tab[i]+".TabSequence=" + string(li_tab_order) + " "
	li_tab_order = li_tab_order + 10
next	
adw_bol.Modify(ls_tab_change)

ll_height = long(adw_bol.Describe("DataWindow.detail.height"))

ll_height = ll_height + li_offset

adw_bol.Modify("DataWindow.detail.height="+string(ll_height))
	
adw_bol.SetRedraw(true)


RETURN 1
end function

public function boolean f_getcostcenter (long al_pickrow, ref decimal ad_cost);string ls_ownercode, ls_cost
long ll_ownerid
			
// Get the cost from the order.
ad_cost = dec(w_do.idw_Main.GetITemString(1,'user_field10'))

// If the cost is 0,
If ad_cost = 0 then

	// Get the owner id.
	ll_ownerid =  w_do.idw_Pick.GetITemNUmber(al_pickrow,'owner_id')
	
	// Get the owner code
	SELECT owner_cd 
	INTO :ls_ownercode 
	FROM Owner
	Where Project_id = :gs_project and owner_id = :ll_ownerid;
	
	// Get the cost from customer master.
	Select user_field7 
	into :ls_cost 
	from customer 
	where project_id = 'PANDORA' 
	and cust_code = :ls_ownercode;	
	
	// convert string to a decimal.
	ad_cost = dec(ls_cost)

// End if the cost is 0.
End If

// Return ad_cost > 0
return ad_cost > 0
end function

public function boolean f_getdwtaborder (readonly datawindow adw_toparse, long al_starttabseq, ref string as_taborder[]);boolean lb_goodsort
string ls_dwobjects[], ls_colname, ls_colnames[]
long ll_numobjects, ll_objectnum, ll_tabseq, ll_tab, ll_mintab, ll_maxtab, ll_tabs[], ll_numvalidtabs
long ll_numtaborders, ll_tabordernum

// Set the datawindow redraw to false.
adw_toparse.SetRedraw(false)
	
// If we can get and parse all the datawindow objects to an array.
if of_parsetoArray( adw_toparse.Describe('Datawindow.Objects') ,'~t',ls_dwobjects) then
	
	// Set lb_goodsort to true.
	lb_goodsort = true

	// Get the number of datawindow objects.
	ll_numobjects = UPPERBOUND(ls_dwobjects)
	
	//////////////////////////////////// Collects all objects with at least the minimum specified tab order ////////////////////////////////////////
	
	// Loop through the datawindow objects.
	For ll_objectnum = 1 to ll_numobjects
		
		// Get the tab sequence and column name.
		ll_tab = integer(adw_toparse.Describe(ls_dwobjects[ll_objectnum]+'.TabSequence'))
		ls_colname = adw_toparse.Describe(ls_dwobjects[ll_objectnum]+'.name')
		
		// If the tab sequence is greater or equal to the start tab,
		if ll_tab >= al_starttabseq then
			
			// Set the tab order and name.
			ll_numvalidtabs++
			ll_tabs[ll_numvalidtabs] = ll_tab
			ls_colnames[ll_numvalidtabs] = ls_colname
			
			// If the tab order is greater than the maximum tab order,
			if ll_tab > ll_maxtab then
				
				// Set the new tab order to the maximum.
				ll_maxtab = ll_tab
			end if
			
			// If the tab order is less than the minimum tab order,
			if ll_tab < ll_mintab then
				
				// Set the new tab order to the minimum.
				ll_mintab = ll_tab
			end if
		end if
	
	// Next tab order.
	next
	
	// Reset ll_numvalidtabs
	ll_numvalidtabs = 0
	
	// Get the qualifying objects (who have the minimum start value).
	ll_numtaborders = upperbound(ls_colnames)
	
	// Now loop from the minimum to maximum tab orders increments of 10.
	for ll_objectnum = ll_mintab to ll_maxtab step 10
		
		// Loop through the column names.
		for ll_tabordernum = 1 to ll_numtaborders
			
			// If this object matches the incrimental tab order
			if ll_objectnum = ll_tabs[ll_tabordernum] then
		
				// Assign the sorted tab order.
				ll_numvalidtabs++
				as_taborder[ll_numvalidtabs] = ls_colnames[ll_tabordernum]
				
				// Quit looking for a match for this tab order.
				exit
			end if
		next
	next
	
// End if we can parse the datawindow to an array.
End If

// Return lb_goodparse
return lb_goodsort
end function

public function boolean of_parsetoarray (string as_source, string as_delimiter, ref string as_array[]);long		ll_DelLen, ll_Pos, ll_Count, ll_Start, ll_Length
string 	ls_holder
boolean lb_goodparse = true

//Check for NULL
IF IsNull(as_source) or IsNull(as_delimiter) Then
	long ll_null
	SetNull(ll_null)
	lb_goodparse = false
End If

//Check for at leat one entry
If Trim (as_source) = '' Then
	lb_goodparse = false
End If

// If we still have a good parse,
if lb_goodparse then

	//Get the length of the delimeter
	ll_DelLen = Len(as_Delimiter)
	
	ll_Pos =  Pos(Upper(as_source), Upper(as_Delimiter))
	
	//Only one entry was found
	if ll_Pos = 0 then
		as_Array[1] = as_source
		
	Else

		//More than one entry was found - loop to get all of them
		ll_Count = 0
		ll_Start = 1
		Do While ll_Pos > 0
			
			//Set current entry
			ll_Length = ll_Pos - ll_Start
			ls_holder = Mid (as_source, ll_start, ll_length)
		
			// Update array and counter
			ll_Count ++
			as_Array[ll_Count] = ls_holder
			
			//Set the new starting position
			ll_Start = ll_Pos + ll_DelLen
		
			ll_Pos =  Pos(Upper(as_source), Upper(as_Delimiter), ll_Start)
		Loop
		
		//Set last entry
		ls_holder = Mid (as_source, ll_start, Len (as_source))
		
		// Update array and counter if necessary
		if Len (ls_holder) > 0 then
			ll_count++
			as_Array[ll_Count] = ls_holder
		end if
	End If
End If

//Return the number of entries found
Return lb_goodparse

end function

public function integer uf_process_ws_do (string asdono, ref datawindow adw_sli);
Long	llRowCount, llRowPos, llPackPos, llPAckCount, llCartonCount
Int	liPageSize, liEmptyRows, liMod
Decimal ldWeight
String	lsCartonSave, lsSOM

liPageSize = 1 // 23 /* currently 23 row per page */

If w_do.idw_Pack.RowCount() < 1 Then Return 0

adw_sli.SetTransObject(SQLCA)
llRowCOunt = adw_sli.Retrieve(asDONO)

//Pad to the correct number of lines so footer is at bottom
liEmptyRows = 0
If llRowCOunt < liPageSize Then
	liEmptyRows = liPageSize - llRowCOunt
ElseIf adw_sli.RowCount() > liPageSize Then
	liMod = Mod(llRowCOunt, liPageSize)
	If liMod > 0 Then
		liEmptyRows = liPageSize - liMod
	End IF
End If

If liEmptyRows > 0 Then
	For llRowPos = 1 to liEmptyRows
		adw_sli.InsertRow(0)
	Next
End If

ldWEight = 0
llCartonCount = 0

//Carton Coutn and Gross Weight
llPAckCount = w_do.idw_PAck.RowCount()
For llPAckPOs = 1 to llPAckCount
	
	If lscartonSave <> w_do.idw_PAck.GetITEmString(llPackPOs,'carton_no') Then
		
		llCartonCount ++
		
		If w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross') > 0 And Not isnull(w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross')) Then
			ldWEight += w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross')
		End If
		
	End If
	
	lsCartonSave = w_do.idw_PAck.GetITEmString(llPackPOs,'carton_no')
	
Next

adw_sli.Modify("total_cartons_t.Text = '" + String(llCartonCount,"###0") + "'")
	
If w_do.idw_Pack.GetITemString(1,'standard_of_measure') = 'E' Then
	lsSOM = ' LBS'
Else
	lsSOM = ' KGS'
End If
	
adw_sli.MOdify("total_Weight_t.text = '" + String(ldWEight,"#####0.00") + lsSOM + "'")
	
Return 0
end function

public function integer uf_process_sli_riverbed (string asdono, ref datawindow adw_sli);
Long	llRowCount, llRowPos, llPackPos, llPAckCount, llCartonCount
Int	liPageSize, liEmptyRows, liMod
Decimal ldWeight
String	lsCartonSave, lsSOM, lsshippinginstructions

liPageSize = 17 /* currently 17 row per page */

If w_do.idw_Pack.RowCount() < 1 Then Return 0

adw_sli.SetTransObject(SQLCA)
llRowCOunt = adw_sli.Retrieve(asDONO)

//Pad to the correct number of lines so footer is at bottom
liEmptyRows = 0
If llRowCOunt < liPageSize Then
	liEmptyRows = liPageSize - llRowCOunt
ElseIf adw_sli.RowCount() > liPageSize Then
	liMod = Mod(llRowCOunt, liPageSize)
	If liMod > 0 Then
		liEmptyRows = liPageSize - liMod
	End IF
End If

If liEmptyRows > 0 Then
	For llRowPos = 1 to liEmptyRows
		adw_sli.InsertRow(0)
	Next
End If

ldWEight = 0
llCartonCount = 0

//Carton Coutn and Gross Weight
llPAckCount = w_do.idw_PAck.RowCount()
For llPAckPOs = 1 to llPAckCount
	
	If lscartonSave <> w_do.idw_PAck.GetITEmString(llPackPOs,'carton_no') Then
		
		llCartonCount ++
		
		If w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross') > 0 And Not isnull(w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross')) Then
			ldWEight += w_do.idw_PAck.GetITEmNumber(llPackPOs,'weight_Gross')
		End If
		
	End If
	
	lsCartonSave = w_do.idw_PAck.GetITEmString(llPackPOs,'carton_no')
	
Next

// Carton Count may also be represented in Delivery Picking
// Box Count is entered in po_no2. A Single Line ITem may be a qty of 1 (or more) but have multiple cartons that need to be included in the total here 
// (but can't be included as seperate cartons on the PAcking List since a qty of 1 can't be split across multiple cartons 
llRowCount = w_do.idw_pick.RowCount()
For llRowPOs = 1 to llRowCount
	
	If isnumber(w_do.idw_Pick.GetITemString(llRowPOs,'po_no2')) Then
		llCartonCount += Long(w_do.idw_Pick.GetITemString(llRowPOs,'po_no2')) - 1 /*first carton is already counted in Packing Count */
	End If
	
Next /*Picking Row */

adw_sli.Modify("total_cartons_t.Text = '" + String(llCartonCount,"###0") + "'")
	
If w_do.idw_Pack.GetITemString(1,'standard_of_measure') = 'E' Then
	lsSOM = ' LBS'
Else
	lsSOM = ' KGS'
End If
	
adw_sli.MOdify("total_Weight_t.text = '" + String(ldWEight,"#####0.00") + lsSOM + "'")

lsshippinginstructions = adw_sli.GetITemString(1,'Delivery_Master_shipping_instructions')
If lsshippinginstructions > '' Then
	adw_sli.Modify("shipping_instructions_t.text='" + lsshippinginstructions + "'")
End If
	
adw_sli.SetRedraw(true)



	
Return 0
end function

public function integer uf_process_bol_klonelab (string as_dono, ref datawindow adw_bol);// int = uf_process_bol_generic( string as_dono, ref datawindow adw_bol )

integer 		li_current_id = 46   //Last Column ID in the select to know where to start.
integer 		li_start_y = 1976 // 1804
integer 		li_y 
integer 		li_height = 72 
integer 		li_space = 76 
integer 		li_start_tab = 30 
integer 		li_tab_order 
integer 		li_offset
integer 		li_tab
integer 		i, i2
integer 		li_change_tab[]
integer 		li_max_tab
integer 		li_min_tab
integer 		li_rtn_item 
integer 		li_idx_rtn_item 
integer 		li_from_pos
integer 		li_retrive_pos
integer 		li_text_pos

string ls_dwobjs[]
string ls_col_name
string ls_change_tab[]
string ls_change_tab_temp[]
string ls_select,ls_awb
string ls_add_select
string ls_new_select
string ls_add_column
string ls_add_table_column
string ls_compute_piece
string ls_compute_weight
string ls_compute_charge
string ls_syntax
string ls_desc
string lsdesc2
string lsdesc3
string  lsdesc4
string ls_tab_change
string ls_last_col
string ls_Remit_Name
string ls_Remit_address1
string ls_Remit_address2
string ls_Remit_address3
string ls_Remit_city
string ls_Remit_state
string ls_Remit_Zip
string ls_AWB_BOL
string ls_type
string ls_remit
string	sql_syntax, ERRORS
String	lsSpecIns, lsCustCode

long	ll_nbrobjects
long 	ll_height
long  ll_carton
long	llRowPos, llRowCount

String ls_cust_order_no
long ll_pallet_count,ll_pallet_carton_count,ll_no_pallet_carton_count
double ld_pallet_weight,ld_no_pallet_weight

double ld_weight

datastore lds_ds, ldsPack

Open(w_klonelab_bol_prompt)

SetPointer(Hourglass!)

str_parms lstr_parms 

lstr_parms = message.PowerObjectParm


if IsValid(lstr_parms) then
	
	
else
	
	Return -1
	
end if
	
//Loop through and get old tab orders.
of_parsetoArray( adw_bol.Describe('Datawindow.Objects') ,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)
For i = 1 to ll_nbrobjects
	li_tab = integer(adw_bol.Describe(ls_dwobjs[i]+'.TabSequence'))
	ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
	if li_tab >= li_start_tab then
		ls_change_tab[UpperBound(ls_change_tab)+1] = ls_col_name
		li_change_tab[UpperBound(ls_change_tab)] = li_tab
		if li_tab > li_max_tab then
			li_max_tab = li_tab
		end if
		if li_tab < li_min_tab then
			li_min_tab = li_tab
		end if
	end if
next
for i = li_min_tab to li_max_tab step 10
	for i2 = 1 to UpperBound(ls_change_tab)
		if i = li_change_tab[i2] then
			ls_change_tab_temp[UpperBound(ls_change_tab_temp) + 1] = ls_change_tab[i2]
			EXIT;		
		end if
	next
next

ls_change_tab = ls_change_tab_temp

lds_ds = f_datastoreFactory("d_gmbattery_bol_group_details")
li_rtn_item = lds_ds.Retrieve(as_dono)

// 11/07 - PCONKL - All packing rows for a carton have the same gross weight. We need the sum for each distinct carton_no 
//							not sure how to do that in SQL so retreiving into DS and summing

//select sum(distinct (dbo.Delivery_Packing.weight_gross)  ) 
// INTO :ld_weight 
// FROM dbo.Delivery_Packing  
//WHERE dbo.Delivery_Packing.DO_No = :as_dono ;

ldsPack = Create Datastore

//Create the Datastore...
//sql_syntax = "select distinct carton_no, weight_gross from delivery_PAcking where do_no = '" + as_dono + "';" 
//ldsPack.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
ldsPack.dataobject = 'd_klonelab_bol_awb'
ldsPack.SetTransobject(sqlca)

//SELECT dbo.Lookup_Table.code_descript  
// INTO :lsdesc2 
// FROM dbo.Lookup_Table  
//WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
//and dbo.Lookup_Table.Code_ID = 'BOLDESC2';
//
//SELECT dbo.Lookup_Table.code_descript  
// INTO :lsdesc3 
// FROM dbo.Lookup_Table  
//WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
//and dbo.Lookup_Table.Code_ID = 'BOLDESC3';
//
//SELECT dbo.Lookup_Table.code_descript  
// INTO :lsdesc4 
// FROM dbo.Lookup_Table  
//WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
//and dbo.Lookup_Table.Code_ID = 'BOLDESC4';
//
//SELECT  count(distinct(dbo.Delivery_Packing.Carton_No))  
// INTO :ll_carton  
// FROM dbo.Delivery_Packing  
//WHERE dbo.Delivery_Packing.DO_No = :as_dono ;
//
//li_y = li_start_y
//li_tab_order = li_start_tab
//
//for li_idx_rtn_item = 1 to 5 // ll_num_total_rows
//
//	//Everything must in the correct order!
//
//	ls_add_select = ls_add_select + ", 0000 as c_pieces" + string(li_idx_rtn_item) + ",   ~~~'                                 ~~~' as c_desc"+string(li_idx_rtn_item) + ", 0000.00 as c_weight"+string(li_idx_rtn_item) + ", '     ' as c_weight_ind"+string(li_idx_rtn_item) + ", 0000.00 as c_rate" + string(li_idx_rtn_item)
// 	ls_add_table_column = ls_add_table_column + " column=(type=long updatewhereclause=yes name=c_pieces"+string(li_idx_rtn_item)+" dbname=~"c_pieces"+string(li_idx_rtn_item)+"~" ) " + &
//															  " column=(type=char(33) updatewhereclause=yes name=c_desc"+string(li_idx_rtn_item)+" dbname=~"c_desc"+string(li_idx_rtn_item)+"~" ) " + &
//															  " column=(type=decimal(2) updatewhereclause=yes name=c_weight"+string(li_idx_rtn_item)+" dbname=~"c_weight"+string(li_idx_rtn_item)+"~") " + &
//															  " column=(type=char(5) updatewhereclause=yes name=c_weight_ind"+string(li_idx_rtn_item)+" dbname=~"c_weight_ind"+string(li_idx_rtn_item)+"~") " + &
//															  " column=(type=decimal(2) updatewhereclause=yes name=c_rate"+string(li_idx_rtn_item)+" dbname=~"c_rate"+string(li_idx_rtn_item)+"~" ) "
//
//	if li_idx_rtn_item > 1 then ls_compute_piece = ls_compute_piece + " + "
//	ls_compute_piece 	= ls_compute_piece + " c_pieces" +string(li_idx_rtn_item)
//	if li_idx_rtn_item > 1 then ls_compute_weight = ls_compute_weight + " + "
//	ls_compute_weight	= ls_compute_weight + " c_weight" +string(li_idx_rtn_item)
//	if li_idx_rtn_item > 1 then ls_compute_charge = ls_compute_charge + " + "
//	ls_compute_charge	= ls_compute_charge + " c_pieces_rate_sub" +string(li_idx_rtn_item)
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "
//	li_current_id = li_current_id + 1
//	li_tab_order = li_tab_order + 1
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"72~" width=~"1582~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
//	li_current_id = li_current_id + 1
//	li_tab_order = li_tab_order + 1
//	ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler"+string(li_idx_rtn_item)+" font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
//	li_current_id = li_current_id + 1
//	li_tab_order = li_tab_order + 1
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"2220~" y=~""+string(li_y)+"~" height=~"72~" width=~"130~" format=~"[general]~"  name=c_weight_ind"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~"  visible =~"0~") "
//	li_current_id = li_current_id + 1
//	li_tab_order = li_tab_order + 1
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2427~" y=~""+string(li_y)+"~" height=~"72~" width=~"480~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
//	ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~" c_pieces"+string(li_idx_rtn_item)+" * c_rate"+string(li_idx_rtn_item)+" ~"border=~"2~" color=~"0~" x=~"2912~" y=~""+string(li_y)+"~" height=~"72~" width=~"434~" format=~"###,###.00~"  name=c_pieces_rate_sub"+string(li_idx_rtn_item)+"  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
//	li_current_id = li_current_id + 1
//	li_tab_order = li_tab_order + 1
//	li_y = li_y + li_space
//	li_offset = li_offset + li_space
//	ls_last_col = "c_rate"+string(li_idx_rtn_item)
//next
//ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece+"~" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_piece_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
//ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler_weight font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
//ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~""+ls_compute_weight+"~" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
//li_offset = li_offset + li_space
//ls_syntax = adw_bol.Describe("DataWindow.Syntax")
//ls_add_select = ls_add_select + " "
//ls_select = adw_bol.Describe("Datawindow.Table.Select")
//ls_new_select = ls_syntax
//li_retrive_pos = Pos(lower(ls_new_select), "retrieve=")
//ls_new_select = left( ls_new_select, li_retrive_pos - 1) + ls_add_table_column + mid( ls_new_select, li_retrive_pos - 1)
//li_from_pos = POS(upper(ls_new_select), " FROM ")
//ls_new_select = left( ls_new_select, li_from_pos - 2) + ls_add_select + mid( ls_new_select, li_from_pos - 2)  
//li_text_pos = POS(lower(ls_new_select), "text(")
//ls_new_select = left( ls_new_select, li_text_pos - 1) + ls_add_column + mid( ls_new_select, li_text_pos - 1)  
//ls_new_select = fu_quotestring(ls_new_select, "'")
//adw_bol.Create(ls_new_select)
//adw_bol.Modify("c_total.Expression='"+ls_compute_charge+"'")
//
////SELECT dbo.Customer.Cust_name, dbo.Customer.Address_1, dbo.Customer.address_2, dbo.Customer.address_3, dbo.Customer.city, dbo.Customer.state, dbo.Customer.zip   
//// INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
//// FROM dbo.Customer  
////WHERE dbo.Customer.Project_id = :gs_project  and dbo.Customer.cust_code = '123BILLING' ;
////
//
//// Add the Bill To Address in the existing Bill To Box. Currently, it is being pulled from customer master where cust_code = ' 123BILLING'. 
////We should take it from the Bill To Address on the Delivery_Alt_Address where the code is 'BT'.


SELECT dbo.Delivery_Alt_Address.Name, dbo.Delivery_Alt_Address.Address_1, dbo.Delivery_Alt_Address.address_2, dbo.Delivery_Alt_Address.address_3, dbo.Delivery_Alt_Address.city, dbo.Delivery_Alt_Address.state, dbo.Delivery_Alt_Address.zip   
 INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
 FROM dbo.Delivery_Alt_Address  
WHERE dbo.Delivery_Alt_Address.Do_No = :as_dono AND dbo.Delivery_Alt_Address.Project_id = :gs_project  and dbo.Delivery_Alt_Address.address_type = 'BT' ;

IF IsNull(ls_Remit_Name) then ls_Remit_Name = ""
IF IsNull(ls_Remit_address1) then ls_Remit_address1 = ""
IF IsNull(ls_Remit_address2) then ls_Remit_address2 = ""
IF IsNull(ls_Remit_address3) then ls_Remit_address3 = ""
IF IsNull(ls_Remit_city) then ls_Remit_city = ""
IF IsNull(ls_Remit_state) then ls_Remit_state = ""
IF IsNull(ls_Remit_Zip) then ls_Remit_Zip = ""

if ls_Remit_Name <> "" then
	ls_remit = ls_remit_name + "~r~n"
end if

if ls_Remit_address1 <> "" then
	ls_remit = ls_remit + ls_Remit_address1 + "~r~n"
end if 

if ls_Remit_address2 <> "" then
	ls_remit = ls_remit + ls_Remit_address2 + "~r~n"
end if

if ls_Remit_address3 <> "" then
	ls_remit = ls_remit + ls_Remit_address3 + "~r~n"
end if

ls_remit = ls_remit + ls_remit_city + ", " + ls_remit_state + ", " + ls_remit_zip 
	


adw_bol.Modify("c_remit_name.Expression=~'~""+ls_remit+"~"~'")

//Retrieve the report

adw_bol.SetTransObject(sqlca)

adw_bol.Retrieve(gs_project, as_dono)


datastore lds_d_do_address_alt

lds_d_do_address_alt = create datastore
lds_d_do_address_alt.dataobject = "d_do_address_alt"
lds_d_do_address_alt.SetTransObject(SQLCA)

if lds_d_do_address_alt.Retrieve(as_dono, '3P') > 0 then

	adw_bol.SetItem(1, "third_party_name", lds_d_do_address_alt.GetItemString(1, "name"))		
	adw_bol.SetItem(1, "third_party_address_1", lds_d_do_address_alt.GetItemString(1, "address_1"))
	adw_bol.SetItem(1, "third_party_address_2", lds_d_do_address_alt.GetItemString(1, "address_2"))
	adw_bol.SetItem(1, "third_party_address_3", lds_d_do_address_alt.GetItemString(1, "address_3"))
	adw_bol.SetItem(1, "third_party_address_4", lds_d_do_address_alt.GetItemString(1, "address_4"))
	adw_bol.SetItem(1, "third_party_city", lds_d_do_address_alt.GetItemString(1, "city"))
	adw_bol.SetItem(1, "third_party_state", lds_d_do_address_alt.GetItemString(1, "state"))
	adw_bol.SetItem(1, "third_party_zip", lds_d_do_address_alt.GetItemString(1, "zip"))
	adw_bol.SetItem(1, "third_party_country", lds_d_do_address_alt.GetItemString(1, "country"))

end if

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

//adw_bol.SetItem(1, "c_pieces1", ll_Carton )		
//if lds_ds.rowcount() > 0 then
//	ls_desc = lds_ds.GetItemstring( 1, "Code_Description") + lsDesc2
//else
//	ls_desc = lsDesc2
//	if isNull( lsDesc2) or len( trim( lsDesc2 ) ) = 0 then ls_desc = 'No Description Available'
//end if
//adw_bol.SetItem(1, "c_desc1" , ls_desc )		
//adw_bol.SetItem(1, "c_weight1" , ld_weight  )		
//adw_bol.SetItem(1, "c_desc2" , lsdesc3 )
//adw_bol.SetItem(1, "c_desc3" , lsdesc4 )
//		
//// Fill AWB BOL into C_ROUTE
//ls_AWB_BOL = w_do.idw_other.GetItemString(1,"AWB_BOL_NO")
//If Not isnull(ls_AWB_BOL) Then
//	adw_bol.setitem(1,'c_route',ls_awb_bol)
//end if 		
//	
////Push Footer Down
//of_parsetoArray( adw_bol.Describe('Datawindow.Objects') ,'~t',ls_dwobjs)
//ll_nbrobjects = UPPERBOUND(ls_dwobjs)
//
//adw_bol.SetRedraw(false)
//For i = 1 to ll_nbrobjects
//	ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
//	ls_type = trim(adw_bol.Describe(ls_dwobjs[i]+'.type'))
//	if ls_type = "line" then
//	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y1'))
//	else
//	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y'))
//	end if
//	if (li_y >= li_start_y) and &
//		(left(ls_col_name, 6) <> "c_piec" and &
//		left(ls_col_name, 6) <> "c_desc" and &
//		left(ls_col_name, 6) <> "c_rate" and &
//		left(ls_col_name, 6) <> "c_weig" and &
//		left(ls_col_name, 6) <> "t_fill") then
//			if ls_type = "line"  then
//				adw_bol.Modify(ls_dwobjs[i] + ".y1=" + string(li_y + li_offset) + " " + ls_dwobjs[i] + ".y2=" + string(li_y + li_offset))
//			else
//				adw_bol.Modify(ls_dwobjs[i] + ".y=" + string(li_y + li_offset))
//			end if
//	  END IF
//NEXT
//
//li_tab_order =  integer(adw_bol.describe(ls_last_col+".TabSequence")) + 1
//
//for i = 1 to UpperBound(ls_change_tab)
//	adw_bol.modify(ls_change_tab[i]+".TabSequence=0")
//	ls_tab_change = ls_tab_change + " " + ls_change_tab[i]+".TabSequence=" + string(li_tab_order) + " "
//	li_tab_order = li_tab_order + 10
//next	
//adw_bol.Modify(ls_tab_change)
//
//ll_height = long(adw_bol.Describe("DataWindow.detail.height"))
//
//ll_height = ll_height + li_offset
//
//adw_bol.Modify("DataWindow.detail.height="+string(ll_height))
//
////10/08 - PCONKL - Add special instructions (Customer UF9) for Comcast - Not really baseine but using a variance of the baseline BOL
//If gs_project = 'COMCAST' and adw_bol.RowCount() > 0 Then
//	
//	lsCustCode = adw_bol.GetITemString(1,'Delivery_Master_Cust_Code')
//	
//	Select User_Field9 into :lsSpecIns
//	From Customer
//	Where project_id = :gs_Project and cust_Code = :lsCustCode;
//	
//	If lsSpecIns > '' Then
//		adw_bol.Modify("special_instructions_t.text='" + lsSpecIns + "'")
//	End If
//	
//End If

string lsTemp 

//Items passed from Params screen.

lsTemp= lstr_parms.string_arg[1]

if Not IsNull(lsTemp) and trim(lsTemp) <> ''  then
	adw_bol.SetItem( 1, "trailer_number", lsTemp)
end if

lsTemp= lstr_parms.string_arg[2]

if Not IsNull(lsTemp) and trim(lsTemp) <> ''  then
	adw_bol.SetItem( 1, "seal_number", lsTemp)
end if

lsTemp= lstr_parms.string_arg[3]

if Not IsNull(lsTemp) and trim(lsTemp) <> ''  then
	adw_bol.SetItem( 1, "trailer_loaded", lsTemp)
end if


lsTemp= lstr_parms.string_arg[4] 

if Not IsNull(lsTemp) and trim(lsTemp) <> ''  then
	adw_bol.SetItem( 1, "freight_counted", lsTemp)
end if

//SARUN2013DEC2012 : Start  Combined BOL 

Select Awb_Bol_No into :ls_awb from Delivery_Master where Project_Id = :gs_project AND do_no = :as_dono;

if adw_bol.dataobject = 'd_klonelab_bol_consol_prt' then

	lLRowCount = ldsPack.Retrieve( gs_project,ls_awb)
	if lLRowCount > 1 and not isnull(ls_awb) then
		For llRowPOs = 1 to lLRowCount
			if llRowPOs <= 4 then
				adw_bol.SetItem( 1, "cust_order_no"					+string(llRowPOs),ldsPAck.GetITemString(llRowPos,'cust_order_no'))	
				adw_bol.SetItem( 1, "pallet_count"					+string(llRowPOs),ldsPAck.GetITemNumber(llRowPos,'pallet_count'))
				adw_bol.SetItem( 1, "pallet_carton_count"		+string(llRowPOs),ldsPAck.GetITemNumber(llRowPos,'pallet_carton_count'))
				adw_bol.SetItem( 1, "no_pallet_carton_count"	+string(llRowPOs),ldsPAck.GetITemNumber(llRowPos,'no_pallet_carton_count'))
				adw_bol.SetItem( 1, "pallet_weight"					+string(llRowPOs),ldsPAck.GetITemNumber(llRowPos,'pallet_weight'))
				adw_bol.SetItem( 1, "no_pallet_weight"			+string(llRowPOs),ldsPAck.GetITemNumber(llRowPos,'no_pallet_weight'))	
			
			else
				if len(ls_cust_order_no) > 0 then
					ls_cust_order_no		 = ls_cust_order_no + ',' + ldsPAck.GetITemString(llRowPos,'cust_order_no')
				else 
					ls_cust_order_no		 = ldsPAck.GetITemString(llRowPos,'cust_order_no')
				end if
					ll_pallet_count 			= ll_pallet_count + ldsPAck.GetITemNumber(llRowPos,'pallet_count')
					ll_pallet_carton_count = ll_pallet_carton_count + ldsPAck.GetITemNumber(llRowPos,'pallet_carton_count')
					ll_no_pallet_carton_count = ll_no_pallet_carton_count + ldsPAck.GetITemNumber(llRowPos,'no_pallet_carton_count')
					ld_pallet_weight = ld_pallet_weight + ldsPAck.GetITemDecimal(llRowPos,'pallet_weight')
					ld_no_pallet_weight = ld_no_pallet_weight + ldsPAck.GetITemDecimal(llRowPos,'no_pallet_weight')
	
			end if
	
			if llRowPOs = lLRowCount then
				adw_bol.SetItem( 1, "cust_order_no5"					 ,ls_cust_order_no)	
				adw_bol.SetItem( 1, "pallet_count5"					 ,ll_pallet_count)
				adw_bol.SetItem( 1, "pallet_carton_count5"		 ,ll_pallet_carton_count)
				adw_bol.SetItem( 1, "no_pallet_carton_count5"	 ,ll_no_pallet_carton_count)
				adw_bol.SetItem( 1, "pallet_weight5"					 ,ld_pallet_weight)
				adw_bol.SetItem( 1, "no_pallet_weight5"			 ,ld_no_pallet_weight)
			end if
	
		Next	
	end if	
end if

//SARUN2013DEC2012 : END  Combined BOL 



	
adw_bol.SetRedraw(true)


RETURN 1
end function

public function integer uf_process_vics_bol (string as_dono, ref datawindow adw_bol);// int = uf_process_bol_generic( string as_dono, ref datawindow adw_bol )

integer 		li_current_id = 46   //Last Column ID in the select to know where to start.
integer 		li_start_y = 1976 // 1804
integer 		li_y 
integer 		li_height = 72 
integer 		li_space = 76 
integer 		li_start_tab = 30 
integer 		li_tab_order 
integer 		li_offset
integer 		li_tab
integer 		i, i2
integer 		li_change_tab[]
integer 		li_max_tab
integer 		li_min_tab
integer 		li_rtn_item 
integer 		li_idx_rtn_item 
integer 		li_from_pos
integer 		li_retrive_pos
integer 		li_text_pos

string ls_dwobjs[]
string ls_col_name
string ls_change_tab[]
string ls_change_tab_temp[]
string ls_select
string ls_add_select
string ls_new_select
string ls_add_column
string ls_add_table_column
string ls_compute_piece
string ls_compute_weight
string ls_compute_charge
string ls_syntax
String ls_sku, ls_asku,  ls_supplier
string ls_desc
string lsdesc2
string lsdesc3
string  lsdesc4
string ls_tab_change
string ls_last_col
string ls_Remit_Name
string ls_Remit_address1
string ls_Remit_address2
string ls_Remit_address3
string ls_Remit_city
string ls_Remit_state
string ls_Remit_Zip
string ls_AWB_BOL
string ls_type
string ls_remit
string	sql_syntax, ERRORS
String	lsSpecIns, lsCustCode

long	ll_nbrobjects
long 	ll_height
long   ll_carton_count
long	llRowPos, llRowCount, llPickRowcount, ll_rtnBT


double ld_weight

string ls_vics_bol_no,  ls_awb_bol_no,lsSSCC, ls_Fclass, ls_InvClass
n_warehouse l_nwarehouse  //Jxlim 07/08/2013 SSCC fo BOL and VICS
l_nwarehouse		= Create n_warehouse

datastore lds_ds, ldsPack
ldsPack = Create Datastore

//Create the Datastore...
sql_syntax = "select distinct carton_no, weight_gross from delivery_PAcking where do_no = '" + as_dono + "';" 
ldsPack.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
ldsPack.SetTransobject(sqlca)

ld_weight = 0
lLRowCount = ldsPack.Retrieve()
If llRowCount > 0 Then
	For llRowPOs = 1 to llRowCount
		If ldsPAck.GetITemNumber(llRowPos,'weight_gross') > 0 Then
			ld_weight += ldsPAck.GetITemNumber(llRowPos,'weight_gross')
		End If
	next
End If

SELECT dbo.Delivery_Alt_Address.Name, dbo.Delivery_Alt_Address.Address_1, dbo.Delivery_Alt_Address.address_2, dbo.Delivery_Alt_Address.address_3, dbo.Delivery_Alt_Address.city, dbo.Delivery_Alt_Address.state, dbo.Delivery_Alt_Address.zip   
 INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
 FROM dbo.Delivery_Alt_Address  
WHERE dbo.Delivery_Alt_Address.Do_No = :as_dono AND dbo.Delivery_Alt_Address.Project_id = :gs_project  and dbo.Delivery_Alt_Address.address_type = 'BT' ;

IF IsNull(ls_Remit_Name) then ls_Remit_Name = ""
IF IsNull(ls_Remit_address1) then ls_Remit_address1 = ""
IF IsNull(ls_Remit_address2) then ls_Remit_address2 = ""
IF IsNull(ls_Remit_address3) then ls_Remit_address3 = ""
IF IsNull(ls_Remit_city) then ls_Remit_city = ""
IF IsNull(ls_Remit_state) then ls_Remit_state = ""
IF IsNull(ls_Remit_Zip) then ls_Remit_Zip = ""

if ls_Remit_Name <> "" then
	ls_remit = ls_remit_name + "~r~n"
end if

if ls_Remit_address1 <> "" then
	ls_remit = ls_remit + ls_Remit_address1 + "~r~n"
end if 

if ls_Remit_address2 <> "" then
	ls_remit = ls_remit + ls_Remit_address2 + "~r~n"
end if

if ls_Remit_address3 <> "" then
	ls_remit = ls_remit + ls_Remit_address3 + "~r~n"
end if

ls_remit = ls_remit + ls_remit_city + ", " + ls_remit_state + ", " + ls_remit_zip 

adw_bol.Modify("c_remit_name.Expression=~'~""+ls_remit+"~"~'")

//Retrieve the report

adw_bol.SetTransObject(sqlca)

adw_bol.Retrieve(gs_project, as_dono)	

datastore lds_d_do_address_alt

lds_d_do_address_alt = create datastore
lds_d_do_address_alt.dataobject = "d_do_address_alt"
lds_d_do_address_alt.SetTransObject(SQLCA)

if lds_d_do_address_alt.Retrieve(as_dono, '3P') > 0 then

	adw_bol.SetItem(1, "third_party_name", lds_d_do_address_alt.GetItemString(1, "name"))		
	adw_bol.SetItem(1, "third_party_address_1", lds_d_do_address_alt.GetItemString(1, "address_1"))
	adw_bol.SetItem(1, "third_party_address_2", lds_d_do_address_alt.GetItemString(1, "address_2"))
	adw_bol.SetItem(1, "third_party_address_3", lds_d_do_address_alt.GetItemString(1, "address_3"))
	adw_bol.SetItem(1, "third_party_address_4", lds_d_do_address_alt.GetItemString(1, "address_4"))
	adw_bol.SetItem(1, "third_party_city", lds_d_do_address_alt.GetItemString(1, "city"))
	adw_bol.SetItem(1, "third_party_state", lds_d_do_address_alt.GetItemString(1, "state"))
	adw_bol.SetItem(1, "third_party_zip", lds_d_do_address_alt.GetItemString(1, "zip"))
	adw_bol.SetItem(1, "third_party_country", lds_d_do_address_alt.GetItemString(1, "country"))

end if

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

//Jxlim 07/07/2013 End of SSCC for Bol and Vics value Pandora BRD 610   
ls_vics_bol_no =  w_do.idw_other.GetItemString(1,'vics_bol_no')
ls_awb_bol_no =  w_do.idw_other.GetItemString(1,"awb_bol_no")	

IF IsNull(ls_vics_bol_no) OR Trim(ls_vics_bol_no) = '' then
	ls_vics_bol_no = l_nwarehouse.of_get_sscc_bol(gs_project,'BOL_No')  //(use 17 digits)
	If ls_vics_bol_no = '' OR IsNull(ls_vics_bol_no) Then
		MessageBox ("Error", "There was a problem creating the SSCC Number.  Please check with support")
		Return 1
	Else
		//w_do.idw_other.setitem(1,'vics_bol_no',ls_vics_bol_no)    //This required calling safe; 
		//use embeded sql to update directly to db instead after generate the vics_bol_no to avoid hard refresh
		Execute Immediate "Begin Transaction" using SQLCA;
		Update dbo.Delivery_master
		Set Vics_Bol_no =:ls_vics_bol_no
		Where Project_id =:gs_Project and Do_no = :as_dono	
		Using SQLCA;
		Execute Immediate "COMMIT" using SQLCA;		
	End if				
End if

//Jxlim 02/05/2014 BIll To (BT) address from Carrier Maintenance on Pandora Vics Bol BRD 690  
String lsCarrier, ls_bt_name, ls_bt_addr, ls_bt_city, ls_bt_state, ls_bt_zip
lsCarrier = w_do.idw_other.getitemstring(1,"Carrier")
Select address_3,address_4, city, state,zip
Into	:ls_bt_name, :ls_bt_addr, :ls_bt_city, :ls_bt_state,:ls_bt_zip
From Carrier_Master
Where Project_ID =:gs_project and Carrier_Code = :lscarrier and (inactive is null or inactive = 0)
Using SQLCA;

If Upper(gs_project) ='PANDORA' Then
	ll_rtnBt =  lds_d_do_address_alt.Retrieve(as_dono, 'BT')
	If ll_rtnBt = 0 Then //if no record then insert 		 
		//Set third party address (BT) from carrier maintenance info into.Delivery_Alt_Address table
//		 lds_d_do_address_alt.InsertRow(0)
//		 lds_d_do_address_alt.SetItem(1, "project_id", gs_project)
//		 lds_d_do_address_alt.SetItem(1, "do_no", as_dono)
//		 lds_d_do_address_alt.SetItem(1 ,"address_type", 'BT')
//		 lds_d_do_address_alt.SetItem(1, "name",ls_bt_name)	//Carrier_master. address3 = Bill To.Name	
//		 lds_d_do_address_alt.SetItem(1, "address_1",ls_bt_addr)	//Carrier_master. address4 = Bill To.Address	
//		 lds_d_do_address_alt.SetItem(1, "city", ls_bt_city)
//		 lds_d_do_address_alt.SetItem(1, "state",ls_bt_state)
//		 lds_d_do_address_alt.SetItem(1, "zip",ls_bt_zip)		
		 
		//use embeded sql to insert directly to db instead after generate the vics_bol_no to avoid hard refresh becasue the datawindow update properties for this lds_d_do_address_alt dw is update and not delete then insert.
		Execute Immediate "Begin Transaction" using SQLCA;		
		Insert Into  Delivery_Alt_Address  (project_id, do_no, address_type, name,address_1, city, state, zip)
		Values		(:gs_project, :as_dono, 'BT',:ls_bt_name,:ls_bt_addr,:ls_bt_city,:ls_bt_state,:ls_bt_zip)		
		Using SQLCA;
		Execute Immediate "COMMIT" using SQLCA;	
	End If
End If

//Jxim 09/16/2013 Use tab pack dw otherwise getting invalid row/column datawindow
Datawindow ldw_Pack
ldw_Pack = w_do.tab_main.tabpage_pack.dw_pack
If llRowCount > 0 Then
	For llRowPOs = 1 to llRowCount
			ls_sku = ldw_Pack.getitemstring(llRowPos, "sku")
			ls_supplier = ldw_Pack.getitemstring(llRowPos, "supp_code")
		
			// Select the detail data for this sku.
			Select Alternate_sku, Description, Freight_class, Inventory_class
			Into	 :ls_asku, :ls_Desc, :ls_Fclass, :ls_InvClass
			From 	 Item_Master
			Where Project_id = :gs_project and sku = :ls_sku and supp_code = :ls_supplier
			Using   SQLCA;
			
			// If there is an error, show error message.
			if sqlca.sqlcode <> 0 then MessageBox ("DB Error", SQLCA.SQLErrText )	
								
			// Concatentate user field 14 to the description.
			If Trim(ls_asku) > '' Then
				ls_Desc = ls_asku + ": " +  ls_Desc	
			Else
				ls_Desc = ls_sku + ": " +  ls_Desc	
			End If
		Next
End If	

adw_bol.SetItem(1, "SkuDescription", ls_desc )
adw_bol.SetItem(1, "Freight_class", ls_Fclass )  //Pandora BRD 690
adw_bol.SetItem(1, "Inventory_class", ls_InvClass ) //Pandora BRD 690

//Jxlim 09/16/2013 Pandora BRD #651; Set Number of Picking Rows as ctns
//llPickRowCount = w_do.tab_main.tabpage_pick.dw_pick.RowCount()			// LTK 20150115 commented out for Pandora #932
//adw_bol.object.pickrowCount_t.text = string(llPickRowCount) + " ctns"

// LTK 20150115  Pandora #932  Package QTY now must display the total number of item, not the number of cartons
//if IsNumber(w_do.tab_main.tabpage_pick.dw_pick.Object.total_qty_t[1]) then
if IsNumber( String(w_do.tab_main.tabpage_pick.dw_pick.Object.total_qty_t[1]) ) then
	llPickRowCount = Integer(w_do.tab_main.tabpage_pick.dw_pick.Object.total_qty_t[1])
	llPickRowCount = Integer( String(w_do.tab_main.tabpage_pick.dw_pick.Object.total_qty_t[1]) )
end if
// GWM 02/24/2015 Pandora #942 - Unit Qty on Vics BOL - Change to report # of cartons on the order in Carrier
	ll_carton_count = sqlca.sp_get_carton_count(gs_project,as_dono)

adw_bol.setitem(1,"Pickrowcount", llPickrowcount)
adw_bol.setitem(1,'CartonCount', ll_carton_count)

//set vics_bol_no to BOL report
adw_bol.setitem(1,'vics_bol_no',ls_vics_bol_no)    		
 //Jxlim 07/07/2013 End of SSCC for Bol and Vics value	
 w_do.tab_main.tabpage_main.dw_main.SetItem(1,'vics_bol_no',ls_vics_bol_no)		// GailM 01/10/2014 Update main DW 
 
 //Jxlim 02/05/2014 Pandora BRD 690
//Set third party address (BT) from carrier maintenance info into the Vics Bol report.
//This could be down above prior to insert but to ensure no refresh is needed we will validate by retrieve the BT address type.
If  lds_d_do_address_alt.Retrieve(as_dono, 'BT') > 0 Then
	adw_bol.SetItem(1, "third_party_name",ls_bt_name)	//Carrier_master. address3 = Bill To.Name	
	adw_bol.SetItem(1, "third_party_address_1",ls_bt_addr)	//Carrier_master. address4 = Bill To.Address	
	adw_bol.SetItem(1, "third_party_city", ls_bt_city)
	adw_bol.SetItem(1, "third_party_state",ls_bt_state)
	adw_bol.SetItem(1, "third_party_zip",ls_bt_zip)
End If
		
adw_bol.SetRedraw(true)

RETURN 1
end function

public function integer uf_process_bol_ariens_old (string as_dono, datawindow adw_bol);//copied from Globalrush BOL...
integer li_current_id = 45  //Last Column ID in the select to know where to start.
integer li_start_y = 1360, li_y, li_height = 72, li_space = 76, li_start_tab = 30, li_tab_order, li_offset
// li_start_y = 1308
LONG    ll_nbrobjects
string  ls_dwobjs[]
string  ls_objects
string ls_col_name
integer li_tab, i
integer li_change_tab[], li_max_tab, li_min_tab
string ls_change_tab[], ls_change_tab_temp[]
integer i2, li_rtn2, li_idx
string ls_cust_code, ls_cust_order_no
string ls_select
datastore lds_ds, lds_po, lds_po_multi, lds_notes
integer li_rtn_item, li_idx_rtn_item, li_from_pos
string ls_po
boolean lb_multi_run
integer li_rtn3
integer li_idx2
string ls_po_list
string ls_add_select, ls_new_select
string ls_add_column
string ls_add_table
string ls_add_table_column
string ls_compute_piece, ls_compute_weight, ls_compute_charge
string ls_syntax
integer li_retrive_pos, li_text_pos
integer li_qty
string ls_desc
double ld_weight
long  ll_carton
string ls_tab_change
string ls_last_col
string ls_notes, ls_dono, lssku, lsdesc
long	 ll_count, ll_row, llSkucount

string ls_po_temp[], ls_reset_po_temp[]	
boolean ib_found
integer p

string ls_Remit_Name, ls_Remit_address1, ls_Remit_address2, ls_Remit_address3, ls_Remit_city, ls_Remit_state, ls_Remit_Zip

adw_bol.dataobject = "d_ariens_bol_prt"

adw_bol.SetTransObject(SQLCA)
	
//Loop through and get old tab orders.

ls_objects = adw_bol.Describe('Datawindow.Objects')
	
of_parsetoArray(ls_objects,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)

For i = 1 to ll_nbrobjects
	
	  li_tab = integer(adw_bol.Describe(ls_dwobjs[i]+'.TabSequence'))
		ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')

	  if li_tab >= li_start_tab then
			ls_change_tab[UpperBound(ls_change_tab)+1] = ls_col_name
			li_change_tab[UpperBound(ls_change_tab)] = li_tab
			
			if li_tab > li_max_tab then
				li_max_tab = li_tab
			end if

			if li_tab < li_min_tab then
				li_min_tab = li_tab
			end if
			
			
	  end if
NEXT



for i = li_min_tab to li_max_tab step 10
	
	for i2 = 1 to UpperBound(ls_change_tab)
		if i = li_change_tab[i2] then
			ls_change_tab_temp[UpperBound(ls_change_tab_temp) + 1] = ls_change_tab[i2]
			
			EXIT;		
		end if
	next
	
next

ls_change_tab = ls_change_tab_temp




lds_ds = CREATE datastore

lds_ds.dataobject = "d_gmbattery_bol_group_details"

lds_ds.SetTransObject(SQLCA)



li_rtn_item = lds_ds.Retrieve(as_dono)

  SELECT sum(dbo.Delivery_Packing.Weight_Gross)  
    INTO :ld_weight 
    FROM dbo.Delivery_Packing  
   WHERE dbo.Delivery_Packing.DO_No = :as_dono   
;

  SELECT  count(distinct(dbo.Delivery_Packing.Carton_No))  
    INTO :ll_carton  
    FROM dbo.Delivery_Packing  
   WHERE dbo.Delivery_Packing.DO_No = :as_dono
           ;

li_y = li_start_y
li_tab_order = li_start_tab

for li_idx_rtn_item = 1 to 5 // ll_num_total_rows

	//Everything must in the correct order!

	ls_add_select = ls_add_select + ", 0000 as c_pieces" + string(li_idx_rtn_item) + ",   ~~~'                                 ~~~' as c_desc"+string(li_idx_rtn_item) + ", 0000.00 as c_weight"+string(li_idx_rtn_item) + ", '     ' as c_weight_ind"+string(li_idx_rtn_item) + ", 0000.00 as c_rate" + string(li_idx_rtn_item)


 	ls_add_table_column = ls_add_table_column + " column=(type=long updatewhereclause=yes name=c_pieces"+string(li_idx_rtn_item)+" dbname=~"c_pieces"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=char(33) updatewhereclause=yes name=c_desc"+string(li_idx_rtn_item)+" dbname=~"c_desc"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_weight"+string(li_idx_rtn_item)+" dbname=~"c_weight"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=char(5) updatewhereclause=yes name=c_weight_ind"+string(li_idx_rtn_item)+" dbname=~"c_weight_ind"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_rate"+string(li_idx_rtn_item)+" dbname=~"c_rate"+string(li_idx_rtn_item)+"~" ) "

	if li_idx_rtn_item > 1 then ls_compute_piece = ls_compute_piece + " + "
	ls_compute_piece 	= ls_compute_piece + " c_pieces" +string(li_idx_rtn_item)

	if li_idx_rtn_item > 1 then ls_compute_weight = ls_compute_weight + " + "
	ls_compute_weight	= ls_compute_weight + " c_weight" +string(li_idx_rtn_item)

	if li_idx_rtn_item > 1 then ls_compute_charge = ls_compute_charge + " + "
	ls_compute_charge	= ls_compute_charge + " c_pieces_rate_sub" +string(li_idx_rtn_item)




//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"100~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "


	li_current_id = li_current_id + 1

	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"100~" width=~"2162~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"72~" width=~"1582~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2446~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler"+string(li_idx_rtn_item)+" font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


												//text(band=detail alignment="2" text="COD FEE" border="2" color="0" x="1737" y="3856" height="100" width="480" html.valueishtml="0"  name=t_7 visible="1"  font.face="Arial" font.height="-9" font.weight="700"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912" )


	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

//558

	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2446~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	//MA - change to make not visible.

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"2220~" y=~""+string(li_y)+"~" height=~"72~" width=~"130~" format=~"[general]~"  name=c_weight_ind"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~"  visible =~"0~") "
	


	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
//	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2898~" y=~""+string(li_y)+"~" height=~"100~" width=~"448~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2427~" y=~""+string(li_y)+"~" height=~"72~" width=~"480~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


	ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~" c_pieces"+string(li_idx_rtn_item)+" * c_rate"+string(li_idx_rtn_item)+" ~"border=~"2~" color=~"0~" x=~"2912~" y=~""+string(li_y)+"~" height=~"72~" width=~"434~" format=~"###,###.00~"  name=c_pieces_rate_sub"+string(li_idx_rtn_item)+"  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "



	li_current_id = li_current_id + 1
	
	li_tab_order = li_tab_order + 1
	
	
	li_y = li_y + li_space
	
	li_offset = li_offset + li_space
	
	ls_last_col = "c_rate"+string(li_idx_rtn_item)

next


ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece+"~" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_piece_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "

ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler_weight font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~""+ls_compute_weight+"~" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "


li_offset = li_offset + li_space


ls_syntax = adw_bol.Describe("DataWindow.Syntax")

ls_add_select = ls_add_select + " "


ls_select = adw_bol.Describe("Datawindow.Table.Select")

ls_new_select = ls_syntax

li_retrive_pos = Pos(lower(ls_new_select), "retrieve=")

ls_new_select = left( ls_new_select, li_retrive_pos - 1) + ls_add_table_column + mid( ls_new_select, li_retrive_pos - 1)

//	Messagebox (string(li_retrive_pos), ls_new_select)


li_from_pos = POS(upper(ls_new_select), " FROM ")

ls_new_select = left( ls_new_select, li_from_pos - 2) + ls_add_select + mid( ls_new_select, li_from_pos - 2)  


li_text_pos = POS(lower(ls_new_select), "text(")

ls_new_select = left( ls_new_select, li_text_pos - 1) + ls_add_column + mid( ls_new_select, li_text_pos - 1)  

ls_new_select = fu_quotestring(ls_new_select, "'")


//	MessageBox ("newselect", ls_new_select)
	
adw_bol.Create(ls_new_select)


adw_bol.Modify("c_total.Expression='"+ls_compute_charge+"'")

  SELECT dbo.Customer.Cust_name, dbo.Customer.Address_1, dbo.Customer.address_2, dbo.Customer.address_3, dbo.Customer.city, dbo.Customer.state, dbo.Customer.zip   
    INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
    FROM dbo.Customer  
   WHERE dbo.Customer.Project_id = :gs_project  and dbo.Customer.cust_code = '123BILLING'   
;

IF IsNull(ls_Remit_Name) then ls_Remit_Name = ""
IF IsNull(ls_Remit_address1) then ls_Remit_address1 = ""
IF IsNull(ls_Remit_address2) then ls_Remit_address2 = ""
IF IsNull(ls_Remit_address3) then ls_Remit_address3 = ""
IF IsNull(ls_Remit_city) then ls_Remit_city = ""
IF IsNull(ls_Remit_state) then ls_Remit_state = ""
IF IsNull(ls_Remit_Zip) then ls_Remit_Zip = ""

string ls_remit

if ls_Remit_Name <> "" then
	ls_remit = ls_remit_name + "~r~n"
end if


if ls_Remit_address1 <> "" then
	ls_remit = ls_remit + ls_Remit_address1 + "~r~n"
end if 

if ls_Remit_address2 <> "" then
	ls_remit = ls_remit + ls_Remit_address2 + "~r~n"
end if

if ls_Remit_address3 <> "" then
	ls_remit = ls_remit + ls_Remit_address3 + "~r~n"
end if

ls_remit = ls_remit + ls_remit_city + ", " + ls_remit_state + ", " + ls_remit_zip 

adw_bol.Modify("c_remit_name.Expression=~'~""+ls_remit+"~"~'")


//Retrieve the report

adw_bol.SetTransObject(sqlca)

adw_bol.Retrieve(gs_project, as_dono)

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

//Set the default data.	

//		ll_carton = lds_ds.GetItemNumber( 1, "Carton_No")
		adw_bol.SetItem(1, "c_pieces1", ll_Carton )		
		
		//Jxlim 08/09/2013 Ariens Item description from Item_master instead
		//ls_desc = lds_ds.GetItemstring( 1, "Code_Description")
		//ls_desc = 'TEMPORARY DESC!!!'
		
		//Jxlim 08/09/2013 Ariens Item description
		Select Description Into :ls_desc
		From Item_Master 
		where Project_Id=:gs_project
		and SKU in(
		 SELECT  dbo.Delivery_Packing.SKU 
		 FROM dbo.Delivery_Packing  
		WHERE dbo.Delivery_Packing.DO_No =:as_dono)
		Using SQLCA;

		adw_bol.SetItem(1, "c_desc1" , ls_desc )		
		adw_bol.SetItem(1, "c_weight1" , ld_weight  )		

	
//Push Footer Down

ls_objects = adw_bol.Describe('Datawindow.Objects')

of_parsetoArray(ls_objects,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)

string ls_type

For i = 1 to ll_nbrobjects

		ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
		ls_type = trim(adw_bol.Describe(ls_dwobjs[i]+'.type'))


		if ls_type = "line" then
		   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y1'))
		else
		   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y'))
		end if
		

//			Messagebox ("ok", ls_col_name)

	  if (li_y >= li_start_y) and &
		  (left(ls_col_name, 6) <> "c_piec" and &
			left(ls_col_name, 6) <> "c_desc" and &
			left(ls_col_name, 6) <> "c_rate" and &
			left(ls_col_name, 6) <> "c_weig" and &
			left(ls_col_name, 6) <> "t_fill") then

			if ls_type = "line"  then

				adw_bol.Modify(ls_dwobjs[i] + ".y1=" + string(li_y + li_offset) + " " + ls_dwobjs[i] + ".y2=" + string(li_y + li_offset))

				
			else

				adw_bol.Modify(ls_dwobjs[i] + ".y=" + string(li_y + li_offset))
	
			end if
	
	  END IF
NEXT

li_tab_order =  integer(adw_bol.describe(ls_last_col+".TabSequence")) + 1

for i = 1 to UpperBound(ls_change_tab)
	
	adw_bol.modify(ls_change_tab[i]+".TabSequence=0")
	
	ls_tab_change = ls_tab_change + " " + ls_change_tab[i]+".TabSequence=" + string(li_tab_order) + " "

	li_tab_order = li_tab_order + 10
	
next	

adw_bol.Modify(ls_tab_change)

long ll_height

ll_height = long(adw_bol.Describe("DataWindow.detail.height"))

ll_height = ll_height + li_offset

adw_bol.Modify("DataWindow.detail.height="+string(ll_height))

adw_bol.SetRedraw(true)



RETURN 1
end function

public function integer uf_process_bol_ariens (string as_dono, datawindow adw_bol);//Jxlim 08/12/2013 clone from Phxbrands for Ariens

/*dts - 4/27/05: 
  This is in a state of migration from original manual, all-in-detail method
    to header/detail/footer method to allow for multiple pages
    PHX wanted it moved to production even though questions remained (about updatable fields, footer position, etc.)
  Still need to tie up loose ends, but I suspect that we'll be going back
    to (modified) manual method so work-in-progress remains.
*/               
integer li_current_id = 45  //Last Column ID in the select to know where to start.
integer li_start_y = 1308, li_y, li_height = 72, li_space = 76, li_start_tab = 30, li_tab_order, li_offset
//integer li_start_y = 191, li_y, li_height = 72, li_space = 76, li_start_tab = 30, li_tab_order, li_offset
LONG    ll_nbrobjects
string  ls_dwobjs[]
string  ls_objects
string ls_col_name, ls_cust_name
integer li_tab, i
integer li_change_tab[], li_max_tab, li_min_tab
string ls_change_tab[], ls_change_tab_temp[]
integer i2, li_rtn2, li_idx
string ls_cust_code, ls_cust_order_no
string ls_select
datastore lds_ds, lds_po, lds_po_multi, lds_notes
integer li_rtn_item, li_idx_rtn_item, li_from_pos
string ls_po
boolean lb_multi_run
integer li_rtn3
integer li_idx2
string ls_po_list
string ls_add_select, ls_new_select
string ls_add_column
string ls_add_table
string ls_add_table_column
string ls_compute_piece, ls_compute_weight, ls_compute_charge
string ls_syntax
integer li_retrive_pos, li_text_pos
integer li_qty 
string ls_desc
double ld_weight
string ls_tab_change
string ls_last_col
string ls_chep_pallets, ls_notes, ls_dono, ls_note_separator, ls_chep_pallets_half, lsChepMsg
long	 ll_count, ll_row

string ls_po_temp[], ls_reset_po_temp[]	
boolean ib_found
integer p
integer li_note_ht
integer li_offset_notes, li_len

//dts 8/22/13 adw_bol.dataobject = "d_ariens_bol_prt"

adw_bol.SetTransObject(SQLCA)
	
	li_y = li_start_y
	li_tab_order = li_start_tab
	
	//dts 4/5/05 - changed ll_row_per_page from 5 to 7
	long ll_row_per_page = 7, ll_num_total_rows
	
	//if mod(li_rtn_item, ll_row_per_page) <> 0 then
	
		//dts ll_num_total_rows = (1 + (integer((li_rtn_item/ll_row_per_page)))) * ll_row_per_page
		ll_num_total_rows = max(ll_row_per_page, li_rtn_item)
	
	//end if
	

//Retrieve the report

//adw_bol.SetTransObject(sqlca)

//adw_bol.Retrieve(gs_project, as_dono)
li_rtn_item = adw_bol.Retrieve(gs_project, as_dono) //lds_ds.Retrieve(as_dono, gs_project)
	// Add 1 row for chep pallets(user_field9)
	//  - and/or for Half Pallets (user_field11)
	If w_do.idw_other.RowCount() > 0 Then
		
// TAM 2014/04 - -	If Carrier is MLOG, we use the Ship To information as the Remit Address
		if 	Left(Upper(w_do.idw_other.GetItemString(1,"Carrier") ),4) = 'MLOG' then
			adw_bol.setitem(li_rtn_item,'project_client_name',w_do.idw_other.GetItemString(1,"Cust_Name"))
			adw_bol.setitem(li_rtn_item,'project_address_1',w_do.idw_other.GetItemString(1,"Address_1"))
			adw_bol.setitem(li_rtn_item,'project_address_2',w_do.idw_other.GetItemString(1,"Address_2"))
			adw_bol.setitem(li_rtn_item,'project_address_3',w_do.idw_other.GetItemString(1,"Address_3"))
			adw_bol.setitem(li_rtn_item,'project_address_3',w_do.idw_other.GetItemString(1,"Address_4"))
			adw_bol.setitem(li_rtn_item,'project_city',w_do.idw_other.GetItemString(1,"City"))
			adw_bol.setitem(li_rtn_item,'project_state',w_do.idw_other.GetItemString(1,"State"))
			adw_bol.setitem(li_rtn_item,'project_zip',w_do.idw_other.GetItemString(1,"Zip"))
			adw_bol.setitem(li_rtn_item,'project_country',w_do.idw_other.GetItemString(1,"Country"))
		end if
		
		
		lsChepMsg = ''
		ls_chep_pallets = w_do.idw_other.GetItemString(1,"user_field9")
		If isnumber(ls_chep_pallets) Then
			lsChepMsg = ls_chep_pallets + " - Chep Pallets"
			/* Adding this row below, with the combined 'CHEP' and 'HALF' pallet info
			//li_rtn_item = adw_bol.InsertRow(0)
			//dwcontrol.RowsCopy ( long startrow, long endrow, DWBuffer copybuffer, datawindow targetdw, long beforerow, DWBuffer targetbuffer)
			//li_rtn_item = adw_bol.RowsCopy (1, 1, Primary!, adw_bol, 99, Primary!)
			adw_bol.RowsCopy (1, 1, Primary!, adw_bol, li_rtn_item +1, Primary!)
			//lds_ds.setitem(li_rtn_item,'group_desc',"Chep Pallets")
			adw_bol.setitem(li_rtn_item + 1,'units',0)
			adw_bol.setitem(li_rtn_item + 1,'group_desc',ls_chep_pallets + " - Chep Pallets")
			//adw_bol.setitem(li_rtn_item,'item_weight',0)
			adw_bol.setitem(li_rtn_item + 1,'weight',0)
			adw_bol.setitem(li_rtn_item + 1,'rate',0)
			//lds_ds.setitem(li_rtn_item,'item_quantity',integer(ls_chep_pallets))
			//adw_bol.setitem(li_rtn_item,'item_quantity','')
			//adw_bol.setitem(li_rtn_item,'units','')
			// pvh
			li_rtn_item ++
			*/
		end if 	
		
		// dts - 06/14/06 - Capturing Half Pallets in UF11
		ls_chep_pallets_half = w_do.idw_other.GetItemString(1,"user_field11")
		If IsNumber(ls_chep_pallets_half) and integer(ls_chep_pallets_half) > 0 Then
			lsChepMsg += ",  " + ls_chep_pallets_half + " - Half Pallets"
			/* Adding this row below, with the combined 'CHEP' and 'HALF' pallet info
			adw_bol.RowsCopy (1, 1, Primary!, adw_bol, li_rtn_item +1, Primary!)
			adw_bol.setitem(li_rtn_item + 1,'units',0)
			adw_bol.setitem(li_rtn_item + 1,'group_desc',ls_chep_pallets_half + " - Half Pallets")
			adw_bol.setitem(li_rtn_item + 1,'weight',0)
			adw_bol.setitem(li_rtn_item + 1,'rate',0)
			li_rtn_item ++
			*/
		end if
		
		if lsChepMsg > '' then
			adw_bol.RowsCopy (1, 1, Primary!, adw_bol, li_rtn_item +1, Primary!)
			adw_bol.setitem(li_rtn_item + 1,'units',0)
			adw_bol.setitem(li_rtn_item + 1,'group_desc',lsChepMsg)
			adw_bol.setitem(li_rtn_item + 1,'weight',0)
			adw_bol.setitem(li_rtn_item + 1,'rate',0)
			li_rtn_item ++
		end if

	end if 		


//	//***NOTES***//
//	//populate Delivery Notes - not done automatically since dw not being retrieved
//			ls_DONO = w_do.idw_main.GetItemString(1,"do_no")
//	
//			lds_notes = Create datastore
//			lds_notes.DataObject = 'd_phxbrands_bol_notes'
//			lds_notes.SetTransObject(sqlca)
//			ll_count = lds_notes.Retrieve(gs_project, ls_DONO) 			
//	
//	/*Loop through each row in notes and populate columns on BOL
//	  - if there are more than 7 lines of notes, don't create new line for each
//	    but just string them together instead (with some spaces in between) */
//		ls_notes = ''
//		if ll_count > 7 then
//			ls_note_separator = '   '
//		else
//			ls_note_separator = '~r'
//		end if
//		For ll_row = 1 to ll_count
//			ls_notes += lds_notes.GetItemString(ll_row,'Note_Text') + ls_note_separator
//		Next
//		
//		//Need to handle Ampersands
//
//		integer li_pos
//		
//		li_Pos = 1
//		
//		DO
//			
//			li_Pos = Pos(ls_notes, "&", li_Pos)
//			
//			if li_Pos > 0 then
//	
//				ls_notes = left(ls_notes, li_Pos) + "&" + mid(ls_notes, li_Pos + 1)
//				
//				li_Pos = li_Pos + 2
//			
//			end if
//			
//		LOOP UNTIL li_pos = 0 or li_pos >= len(ls_notes)
//
//		
//		adw_bol.Modify("t_notes.text='" + ls_notes + "'")
//		
RETURN 1
end function

public function integer uf_process_bol_nycsp (string as_dono, ref datawindow adw_bol);//12-Dec-2013 :Madhu- Added code to generate newly designed BOL for NYCSP

string ls_c_name,ls_c_add1,ls_c_add2,ls_c_add3,ls_c_add4,ls_c_city,ls_c_state,ls_c_zip


	adw_bol.SetTransObject(SQLCA)
	
	adw_bol.Retrieve(gs_project, as_dono)
	
	select Cust_Name,Address_1,Address_2,Address_3,Address_4,City,State,Zip 
		into :ls_c_name,:ls_c_add1,:ls_c_add2,:ls_c_add3,:ls_c_add4,:ls_c_city,:ls_c_state,:ls_c_zip
	from Customer 
	where Project_Id =:gs_project
	and Cust_Code='NYCSP-BILLING'
	using sqlca;

	adw_bol.setItem(1,"cust_contact",ls_c_name)
	adw_bol.setItem(1,"cust_addr1",ls_c_add1)
	adw_bol.setItem(1,"cust_addr2",ls_c_add2)
	adw_bol.setItem(1,"cust_addr3",ls_c_add3)
	adw_bol.setItem(1,"cust_addr4",ls_c_add4)
	adw_bol.setItem(1,"cust_city",ls_c_city)	
	adw_bol.setItem(1,"cust_state",ls_c_state)
	adw_bol.setItem(1,"cust_zip",ls_c_zip)
	//adw_bol.setItem(1,"shipping_instructions","NYC Emergency Supply Stockpile") //28-Dec-2015 :Madhu Added
	
RETURN  1
end function

public function integer uf_process_vics_bol_combine (string as_dono, ref datawindow adw_bol);//Jxlim 12/10/2013 Freidrich Vics BOL up to 5 orders
//This is an external datawindow useb by manipulating datastores to produce a combine Vics BOL up to 5 detail/NMFC rows
//to fit into one single page of International standard Vics BOL.  (Strickly no extra page).  
//In the event that the order exist 5 rows, a supplement page will be created to handle this and it will be a separate code from this.
//This Vics BOL is officially name a Single page Vics BOL requested by Friedrich.
//This report contains:
//1. Header warehouse and order master, carrier from delivery_master and warehouse and Carrier_Master
//2. Third party address from Delivery_alt_address where address_type ='BT'
//Created a new datawindow for delivery alt address based on consolidation_no since we may have multiple do_no. 
//Baseline should be able to fulfill this however, 
//since we already have the consolidation_no variable within this code it is easier to just retrieve based on consolidation_no.
//The existing baseline third party address datawindow is based on do_no
//Customer Order Information and Carrier Information have to separate into 2 different query although they are source from the same table.
//This is because Customer detail required to group by order and Carrier information required to group by item.
//3. group by order: Order information detail from Delivery Master and Packing; and the weight is getting from item_master.weight_1
//--Total Packing Weight = Sum(Delivery_Packing.Qty * Item_Master.Weight_1)	
//4. group by NMFC: Carrier Information from Item_Master and Number of carton_no (count of carton_no) from delivery_packing 
//--Total item Weight = Sum(Delivery_Packing.Qty * Item_Master.Weight_1)	
//This is done through group by NMFC not carton_no
//If an order with 2 different NMFC code (2 Items) pack into one pallet together
//then the carton_no should show only 1 pallet this is done through group by carton_no
//supplmental detail and nmfc datawindow will be used regradless 5 or less orders in a shipment

Long   i, ll_consl_rowcount,	ll_detail_suplm_rowcount, ll_nmfc_suplm_rowcount, ll_detail_rowcount, ll_nmfc_rowcount, ll_alt_address_rowcount, ll_nmfc_carton_rowcount
Long   ll_carton_count1, ll_carton_count2,ll_carton_count3,ll_carton_count4,ll_carton_count5,ll_total_carton_count,ll_bol_suplm
String ls_custcode,ls_custname, ls_carton_type
Decimal ld_Pack_qty1,ld_Pack_qty2,ld_Pack_qty3,ld_Pack_qty4,ld_Pack_qty5
Decimal ld_total_item_qty, ld_total_pack_qty
Decimal ld_weight1,ld_weight2,ld_weight3,ld_weight4,ld_weight5, ld_total_net_w, ld_total_pack_weight
Decimal ld_totalw1, ld_totalw2,ld_totalw3,ld_totalw4,ld_totalw5
String ls_carton_type1,ls_carton_type2,ls_carton_type3,ls_carton_type4,ls_carton_type5
String ls_nmfcdescription1, ls_nmfcdescription2,ls_nmfcdescription3,ls_nmfcdescription4,ls_nmfcdescription5, ls_nmfc1,ls_nmfc2,ls_nmfc3,ls_nmfc4,ls_nmfc5
String ls_class1,ls_class2,ls_class3,ls_class4,ls_class5
String ls_cust_ord_nbr1,ls_cust_ord_nbr2,ls_cust_ord_nbr3,ls_cust_ord_nbr4,ls_cust_ord_nbr5
String ls_invoice_no1, ls_invoice_no2,  ls_invoice_no3, ls_invoice_no4, ls_invoice_no5
Decimal ld_item_qty1,ld_item_qty2,ld_item_qty3,ld_item_qty4,ld_item_qty5
Datawindowchild ldwc_detail_suplm,ldwc_nmfcitem_suplm
Boolean lb_suplm

n_warehouse l_nwarehouse  //Jxlim 07/08/2013 SSCC fo BOL and VICS
l_nwarehouse		= Create n_warehouse

lb_suplm=False

//03-Jan-2014 :Madhu -Added code to verify whether all serial no's are scanned? -START
Long 	llpackqty,llscannedqty ,llserialcnt,lleligiblecnt

//14-Aug-2015 :Madhu- Added code to print Carton and Pallet count separetly on BOL
int row
string lscarton_type
long ll_total_pallet_count


//get eligible records for scanning
// TAM 2014/01/15 - Changed from Count to Sum.  Not all items are scannable and we only want to compare the number of Scannable with the number of serials
//select count(*) into :lleligiblecnt from Delivery_Packing,Item_Master
select sum(Quantity) into :lleligiblecnt from Delivery_Packing,Item_Master
where Delivery_Packing.SKU = Item_Master.SKU
and Delivery_Packing.DO_No= :as_dono
and Item_Master.Project_Id=:gs_project
and Item_Master.Serialized_Ind in ('Y','B')
using SQLCA;

If lleligiblecnt >0 Then
//TAM	Select sum(Quantity) into :llpackqty from Delivery_Packing where Do_No =:as_dono using SQLCA;
	Select Sum(quantity) into :llScannedQty from delivery_serial_detail Where Id_no in (select id_no from delivery_picking_detail where do_no = :as_dono) using SQLCA;
	
	If IsNull(llScannedQty) then 
		llScannedQty =0 
	end if
	
//TAM 	If llpackqty <> llScannedQty Then
	If lleligiblecnt <> llScannedQty Then
		MessageBox(w_do.is_title,"All Serial no's are not being scanned. Please check.",Stopsign!)
		Return 0
	End if 
End if 

//03-Jan-2014 :Madhu - Added code to verify whether all serial no's are scanned? -END

//Jxlim; Created data store to Retrieve report contains, then get the value from this datastore to set it to ext dw
Datastore  lds_bol_suplm,lds_bol_combine_header, lds_bol_combine_alt_address
Datastore  lds_nmfc_carton_count, ldwc_detail_suplm_suplm

//Jxlim; may not need this datastore but for now 
//Datastore for Report header section
lds_bol_combine_header = create datastore
lds_bol_combine_header.dataobject = 'd_vics_bol_prt_combined_header'
lds_bol_combine_header.SetTransObject(SQLCA)
lds_bol_combine_header.Retrieve(gs_project, as_dono)
ll_consl_rowcount = lds_bol_combine_header.Rowcount()

//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss
lds_bol_combine_alt_address = create datastore
lds_bol_combine_alt_address.dataobject = 'd_vics_bol_prt_combined_alt_address'
lds_bol_combine_alt_address.SetTransObject(SQLCA)
lds_bol_combine_alt_address.Retrieve(gs_project, as_dono, 'BT')  //as_dono(consolidation No) asType=BT (Bill To for BOL) --3P is for Trax/Third Party
ll_alt_address_rowcount=lds_bol_combine_alt_address.Rowcount()

lds_bol_suplm = Create datastore
lds_bol_suplm.dataobject = 'd_vics_bol_prt_combined_suplm_composite_rpt'

lds_bol_suplm.GetChild('dw_detail_suplm', ldwc_detail_suplm)
ldwc_detail_suplm.SetTransObject(SQLCA)	
ldwc_detail_suplm.Retrieve(gs_project, as_dono)
ll_detail_suplm_rowcount=ldwc_detail_suplm.RowCount()

lds_bol_suplm.GetChild('dw_nmfcitem_suplm', ldwc_nmfcitem_suplm)
ldwc_nmfcitem_suplm.SetTransObject(SQLCA)	
ldwc_nmfcitem_suplm.Retrieve(gs_project, as_dono)
ll_nmfc_suplm_rowcount=ldwc_nmfcitem_suplm.Rowcount()


//Jxlim Insert row to begin for external dw
adw_bol.InsertRow(0)
//Header Info
		//Using  lds_bol_combine_header datastore for Header section
		//Ship From address from Warehouse Table
	
		//adw_bol.SetItem(1,"wh_code",  lds_bol_combine_header.GetitemString(1, "wh_code"))
		adw_bol.SetItem(1,"wh_name", lds_bol_combine_header.GetitemString(1, "wh_Name"))
		adw_bol.SetItem(1,"wh_addr1", lds_bol_combine_header.GetitemString(1,"wh_Addr1" ))  
		adw_bol.SetItem(1,"wh_addr2", lds_bol_combine_header.GetitemString(1,"wh_Addr2" ))   
		adw_bol.SetItem(1,"wh_addr3", lds_bol_combine_header.GetitemString(1,"wh_Addr3"))    
		adw_bol.SetItem(1,"wh_addr4", lds_bol_combine_header.GetitemString(1,"wh_Addr4" ))   
		adw_bol.SetItem(1,"wh_city", lds_bol_combine_header.GetitemString(1,"wh_City" ))  
		adw_bol.SetItem(1,"wh_state", lds_bol_combine_header.GetitemString(1,"wh_State" ))     
		adw_bol.SetItem(1,"wh_zip", lds_bol_combine_header.GetitemString(1,"wh_Zip" ))    
		
		//Ship To from Delivery_Master Table
		adw_bol.SetItem(1,"cust_code",  lds_bol_combine_header.GetitemString(1, "Cust_code"))
		adw_bol.SetItem(1,"cust_name", lds_bol_combine_header.GetitemString(1, "Cust_Name"))
		adw_bol.SetItem(1,"cust_addr1", lds_bol_combine_header.GetitemString(1,"Address_1" ))  
		adw_bol.SetItem(1,"cust_addr2", lds_bol_combine_header.GetitemString(1,"Address_2" ))   
		adw_bol.SetItem(1,"cust_addr3", lds_bol_combine_header.GetitemString(1,"Address_3"))    
		adw_bol.SetItem(1,"cust_addr4", lds_bol_combine_header.GetitemString(1,"Address_4" ))   
		adw_bol.SetItem(1,"cust_city", lds_bol_combine_header.GetitemString(1,"City" ))  
		adw_bol.SetItem(1,"cust_state", lds_bol_combine_header.GetitemString(1,"State" ))     
		adw_bol.SetItem(1,"cust_zip", lds_bol_combine_header.GetitemString(1,"Zip" ))    
		adw_bol.SetItem(1,"contact_person", lds_bol_combine_header.GetitemString(1,"Contact_person"  ))  
		adw_bol.SetItem(1,"tel", lds_bol_combine_header.GetitemString(1,"Tel"  )) 
		adw_bol.SetItem(1,"cust_country", lds_bol_combine_header.GetitemString(1,"Country"  ))  //13-Aug-2015 Madhu Added customer Country
		
		adw_bol.SetItem(1,"shipping_instr", lds_bol_combine_header.GetitemString(1,"shipping_instr"))  
		adw_bol.SetItem(1,"awb_bol_no", lds_bol_combine_header.GetitemString(1,"awb_bol_no"  ))  
		adw_bol.SetItem(1,"consl_no", lds_bol_combine_header.GetitemString(1,"consolidation_no"  ))  
		adw_bol.SetItem(1,"trailer_no", lds_bol_combine_header.GetitemString(1,"Trailer_no"  ))  		 //DM.user_field2
		adw_bol.SetItem(1,"pro_no", lds_bol_combine_header.GetitemString(1,"Carrier_Pro_No"  )) 	//DM.user_field7  Jxlim 04/02/2014 Replaced with carrier_pro_no name field
		adw_bol.SetItem(1,"scac", lds_bol_combine_header.GetitemString(1,"scac"  ))  					// Carrier_Master.Carrier_code first 4 digits
		adw_bol.SetItem(1,"Freight_Terms", lds_bol_combine_header.GetitemString(1,"Freight_Terms"  )) //Frieght_terms, X mark visible based on frieght_terms 		
		
		//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss --BOL third party address uses Bill TO ('BT') address type			
		If	ll_alt_address_rowcount > 0 Then	
			adw_bol.SetItem(1, "alt_name", lds_bol_combine_alt_address.GetItemString(1, "name"))		
			adw_bol.SetItem(1, "alt_addr1", lds_bol_combine_alt_address.GetItemString(1, "address_1"))
			adw_bol.SetItem(1, "alt_addr2", lds_bol_combine_alt_address.GetItemString(1, "address_2"))
			adw_bol.SetItem(1, "alt_addr3", lds_bol_combine_alt_address.GetItemString(1, "address_3"))
			adw_bol.SetItem(1, "alt_addr4", lds_bol_combine_alt_address.GetItemString(1, "address_4"))
			adw_bol.SetItem(1, "alt_city",    lds_bol_combine_alt_address.GetItemString(1, "city"))
			adw_bol.SetItem(1, "alt_state",  lds_bol_combine_alt_address.GetItemString(1, "state"))
			adw_bol.SetItem(1, "alt_zip",     lds_bol_combine_alt_address.GetItemString(1, "zip"))
		End If

//Print supplementan page if more than 5 orders
If ll_consl_rowcount  > 5 Then //Print supplementan page
	adw_bol.SetItem(1, "order_count",  ll_detail_suplm_rowcount)
	lb_suplm= True
Else
	lb_suplm= False
End If

If lb_suplm = False and ll_nmfc_suplm_rowcount > 5 Then
	adw_bol.SetItem(1, "nmfc_count",  ll_nmfc_suplm_rowcount)
	lb_suplm = True		
Else
	//Detail order Information--------------------------------------------------------------------------------------------------------------	
	If	ll_detail_suplm_rowcount <=5 Then
			//For i = 1 to ll_detail_rowcount	
			For i = 1 to 	ll_detail_suplm_rowcount
				If i = 1 Then
						ls_cust_ord_nbr1= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr1",ls_cust_ord_nbr1)
						
						ld_pack_qty1=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty1",ld_pack_qty1)
						
						ld_totalw1=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight1",ld_totalw1)
							
						ls_invoice_no1=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no1",ls_invoice_no1)
						
				ElseIf i = 2 Then
						ls_cust_ord_nbr2= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr2",ls_cust_ord_nbr2)
						
						ld_pack_qty2=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty2",ld_pack_qty2)
						
						ld_totalw2=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight2",ld_totalw2)
							
						ls_invoice_no2=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no2",ls_invoice_no2)
						
				ElseIf i = 3 Then
						ls_cust_ord_nbr3= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr3",ls_cust_ord_nbr3)
							
						ld_pack_qty3=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty3",ld_pack_qty3)
						
						ld_totalw3=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight3",ld_totalw3)
						
						ls_invoice_no3=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no3",ls_invoice_no3)		
						  
				ElseIf i = 4 Then
						ls_cust_ord_nbr4= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr4",ls_cust_ord_nbr4)
						
						ld_pack_qty4=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty4",ld_pack_qty4)
						
						ld_totalw4=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight4",ld_totalw4)
						
						ls_invoice_no4=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no4",ls_invoice_no4)
						
				ElseIf i = 5 Then	
						ls_cust_ord_nbr5= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr5",ls_cust_ord_nbr2)
							
						ld_pack_qty5=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty5",ld_pack_qty5)
						
						ld_totalw5=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight5",ld_totalw5)
						
						ls_invoice_no5=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no5",ls_invoice_no5)				
				End if
			Next	
			//Total Qty and total Weight by Order number
			ld_total_pack_qty=  ldwc_detail_suplm.GetitemDecimal(1,"total_pack_qty")  //sum of total pack qty
			ld_total_pack_weight= ldwc_detail_suplm.GetitemDecimal(1,"total_pack_weight")  //sum of total weight
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child
			adw_bol.SetItem(1,"total_pack_qty",ld_total_pack_qty)
			adw_bol.SetItem(1,"total_pack_Weight",ld_total_pack_Weight)	
		End If
	
		//Carrier Information --NMFC--------------------------------------------------------------------------------------------------------------		
		If ll_nmfc_suplm_rowcount <=5  Then					
			For i = 1 to ll_nmfc_suplm_rowcount	
			If i = 1 Then					
					ld_Item_qty1= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty1",ld_item_qty1)
					
					ld_Weight1= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight1",ld_Weight1)
					
					ls_nmfcdescription1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription1",ls_nmfcdescription1)
					
					ls_nmfc1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc1",ls_nmfc1)
					
					ls_class1= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class1",ls_class1)						
				
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count1",ll_carton_count1)
					ls_carton_type1= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")	
					adw_bol.SetItem(1,"carton_type1",ls_carton_type1)			
					
			ElseIf i = 2 Then		
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count2",ll_carton_count2)
					ls_carton_type2= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type2",ls_carton_type2)
					
					ld_Item_qty2= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty2",ld_item_qty2)
					
					ld_Weight2= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight2",ld_Weight2)
					
					ls_nmfcdescription2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription2",ls_nmfcdescription2)
					
					ls_nmfc2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc2",ls_nmfc2)
					
					ls_class2= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class2",ls_class2)
					
			ElseIf i = 3 Then
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count3",ll_carton_count3)
					ls_carton_type3= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type3",ls_carton_type3)
					
					ld_Item_qty3= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty3",ld_item_qty3)
					
					ld_Weight3= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight3",ld_Weight3)
					
					ls_nmfcdescription3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription3",ls_nmfcdescription3)
					
					ls_nmfc3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc3",ls_nmfc3)
					
					ls_class3= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class3",ls_class3)
					
			ElseIf i = 4 Then
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count4",ll_carton_count4)
					ls_carton_type4= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type4",ls_carton_type4)
					
					ld_Item_qty4= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty4",ld_item_qty4)
					
					ld_Weight4= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight4",ld_Weight4)
					
					ls_nmfcdescription4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription4",ls_nmfcdescription4)
					
					ls_nmfc4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc4",ls_nmfc4)
					
					ls_class4= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class4",ls_class4)
			ElseIf i = 5 Then
				//	ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")				
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count5",ll_carton_count5)
					ls_carton_type5= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type5",ls_carton_type5)
					
					ld_Item_qty5= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty5",ld_item_qty5)
					
					ld_Weight5= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight5",ld_Weight5)
					
					ls_nmfcdescription5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription5",ls_nmfcdescription5)
					
					ls_nmfc5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc5",ls_nmfc5)
					
					ls_class5= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class5",ls_class5)
				End if
			Next			
			//Total of all Number of carton from all orders group by carton_no with multiple Item. Examp one order with multiple line and multple NMFC pack together in one pallet

			//14-Aug-2015 :Madhu- Added code to print Carton and Pallet count separetly on BOL - START
			//ll_total_carton_count= ldwc_nmfcitem_suplm.GetitemNumber(1, "total_carton_count")  //14-Aug-2015 :Madhu commented
			//adw_bol.SetItem(1,"total_carton_count", ll_total_carton_count ) //14-Aug-2015 :Madhu commented
			FOR  row =1 to ldwc_nmfcitem_suplm.rowcount( )
				lscarton_type =ldwc_nmfcitem_suplm.GetitemString(row, "cf_carton_type")
				
				CHOOSE CASE Upper(lscarton_type)
					CASE 'PALLET', 'PL','PLTS'
								ll_total_pallet_count += ldwc_nmfcitem_suplm.GetitemNumber(row, "cf_carton_countvisible")
								adw_bol.SetItem(1,"total_pallet_count", ll_total_pallet_count )
					CASE ELSE
								ll_total_carton_count += ldwc_nmfcitem_suplm.GetitemNumber(row, "cf_carton_countvisible")
								adw_bol.SetItem(1,"total_carton_count", ll_total_carton_count )				
					END CHOOSE
			Next
			
			// ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
			//14-Aug-2015 :Madhu- Added code to print Carton and Pallet count separetly on BOL - END
			
//			//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
//			ls_carton_type= ldwc_nmfcitem_suplm.GetitemString(1, "carton_type")
//			adw_bol.SetItem(1,"carton_type",ls_carton_type)
//			
			//Total Qty and total Weight by NMFC (Item_master)
			ld_total_item_qty=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_item_qty")
			adw_bol.SetItem(1,"total_item_qty",ld_total_item_qty)
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child			
			ld_total_net_w=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_net_w")
			adw_bol.SetItem(1,"total_net_w",ld_total_net_w)
		End If //NMFC 
End If

If lb_suplm = True Then
	//Print(lds_bol_suplm)	//no print dialog
	OpenWithParm(w_dw_print_options,lds_bol_suplm) //print dialog
End If
	
If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetRedraw(true)

RETURN 1
end function

public function integer uf_process_bol_anki (string as_dono, ref datawindow adw_bol);// int = uf_process_bol_generic( string as_dono, ref datawindow adw_bol )

integer 		li_current_id = 46   //Last Column ID in the select to know where to start.
integer 		li_start_y = 1976 // 1804
integer 		li_y 
integer 		li_height = 72 
integer 		li_space = 76 
integer 		li_start_tab = 30 
integer 		li_tab_order 
integer 		li_offset
integer 		li_tab
integer 		i, i2
integer 		li_change_tab[]
integer 		li_max_tab
integer 		li_min_tab
integer 		li_rtn_item 
integer 		li_idx_rtn_item 
integer 		li_from_pos
integer 		li_retrive_pos
integer 		li_text_pos

string ls_dwobjs[]
string ls_col_name
string ls_change_tab[]
string ls_change_tab_temp[]
string ls_select
string ls_add_select
string ls_new_select
string ls_add_column
string ls_add_table_column
string ls_compute_piece
string ls_compute_weight
string ls_compute_charge
string ls_syntax
string ls_desc
string lsdesc2
string lsdesc3
string  lsdesc4
string ls_tab_change
string ls_last_col
string ls_Remit_Name
string ls_Remit_address1
string ls_Remit_address2
string ls_Remit_address3
string ls_Remit_city
string ls_Remit_state
string ls_Remit_Zip
string ls_AWB_BOL
string ls_type
string ls_remit
string	sql_syntax, ERRORS
String	lsSpecIns, lsCustCode

long	ll_nbrobjects
long 	ll_height
long  ll_carton
long	llRowPos, llRowCount

double ld_weight

datastore lds_ds, ldsPack
	
//Loop through and get old tab orders.
of_parsetoArray( adw_bol.Describe('Datawindow.Objects') ,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)
For i = 1 to ll_nbrobjects
	li_tab = integer(adw_bol.Describe(ls_dwobjs[i]+'.TabSequence'))
	ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
	if li_tab >= li_start_tab then
		ls_change_tab[UpperBound(ls_change_tab)+1] = ls_col_name
		li_change_tab[UpperBound(ls_change_tab)] = li_tab
		if li_tab > li_max_tab then
			li_max_tab = li_tab
		end if
		if li_tab < li_min_tab then
			li_min_tab = li_tab
		end if
	end if
next
for i = li_min_tab to li_max_tab step 10
	for i2 = 1 to UpperBound(ls_change_tab)
		if i = li_change_tab[i2] then
			ls_change_tab_temp[UpperBound(ls_change_tab_temp) + 1] = ls_change_tab[i2]
			EXIT;		
		end if
	next
next

ls_change_tab = ls_change_tab_temp

lds_ds = f_datastoreFactory("d_gmbattery_bol_group_details")
li_rtn_item = lds_ds.Retrieve(as_dono)

// 11/07 - PCONKL - All packing rows for a carton have the same gross weight. We need the sum for each distinct carton_no 
//							not sure how to do that in SQL so retreiving into DS and summing

//select sum(distinct (dbo.Delivery_Packing.weight_gross)  ) 
// INTO :ld_weight 
// FROM dbo.Delivery_Packing  
//WHERE dbo.Delivery_Packing.DO_No = :as_dono ;

ldsPack = Create Datastore

//Create the Datastore...
sql_syntax = "select distinct carton_no, weight_gross from delivery_PAcking where do_no = '" + as_dono + "';" 
ldsPack.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
ldsPack.SetTransobject(sqlca)

ld_weight = 0
lLRowCount = ldsPack.Retrieve()
If llRowCount > 0 Then
	For llRowPOs = 1 to llRowCount
		If ldsPAck.GetITemNumber(llRowPos,'weight_gross') > 0 Then
			ld_weight += ldsPAck.GetITemNumber(llRowPos,'weight_gross')
		End If
	next
End If

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc2 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC2';

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc3 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC3';

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc4 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC4';

SELECT  count(distinct(dbo.Delivery_Packing.Carton_No))  
 INTO :ll_carton  
 FROM dbo.Delivery_Packing  
WHERE dbo.Delivery_Packing.DO_No = :as_dono ;

li_y = li_start_y
li_tab_order = li_start_tab

for li_idx_rtn_item = 1 to 5 // ll_num_total_rows

	//Everything must in the correct order!

	ls_add_select = ls_add_select + ", 0000 as c_pieces" + string(li_idx_rtn_item) + ",   ~~~'                                 ~~~' as c_desc"+string(li_idx_rtn_item) + ", 0000.00 as c_weight"+string(li_idx_rtn_item) + ", '     ' as c_weight_ind"+string(li_idx_rtn_item) + ", 0000.00 as c_rate" + string(li_idx_rtn_item)
 	ls_add_table_column = ls_add_table_column + " column=(type=long updatewhereclause=yes name=c_pieces"+string(li_idx_rtn_item)+" dbname=~"c_pieces"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=char(33) updatewhereclause=yes name=c_desc"+string(li_idx_rtn_item)+" dbname=~"c_desc"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_weight"+string(li_idx_rtn_item)+" dbname=~"c_weight"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=char(5) updatewhereclause=yes name=c_weight_ind"+string(li_idx_rtn_item)+" dbname=~"c_weight_ind"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_rate"+string(li_idx_rtn_item)+" dbname=~"c_rate"+string(li_idx_rtn_item)+"~" ) "

	if li_idx_rtn_item > 1 then ls_compute_piece = ls_compute_piece + " + "
	ls_compute_piece 	= ls_compute_piece + " c_pieces" +string(li_idx_rtn_item)
	if li_idx_rtn_item > 1 then ls_compute_weight = ls_compute_weight + " + "
	ls_compute_weight	= ls_compute_weight + " c_weight" +string(li_idx_rtn_item)
	if li_idx_rtn_item > 1 then ls_compute_charge = ls_compute_charge + " + "
	ls_compute_charge	= ls_compute_charge + " c_pieces_rate_sub" +string(li_idx_rtn_item)
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"72~" width=~"1582~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler"+string(li_idx_rtn_item)+" font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"2220~" y=~""+string(li_y)+"~" height=~"72~" width=~"130~" format=~"[general]~"  name=c_weight_ind"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~"  visible =~"0~") "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2427~" y=~""+string(li_y)+"~" height=~"72~" width=~"480~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~" c_pieces"+string(li_idx_rtn_item)+" * c_rate"+string(li_idx_rtn_item)+" ~"border=~"2~" color=~"0~" x=~"2912~" y=~""+string(li_y)+"~" height=~"72~" width=~"434~" format=~"###,###.00~"  name=c_pieces_rate_sub"+string(li_idx_rtn_item)+"  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	li_y = li_y + li_space
	li_offset = li_offset + li_space
	ls_last_col = "c_rate"+string(li_idx_rtn_item)
next
ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece+"~" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_piece_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler_weight font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~""+ls_compute_weight+"~" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
li_offset = li_offset + li_space
ls_syntax = adw_bol.Describe("DataWindow.Syntax")
ls_add_select = ls_add_select + " "
ls_select = adw_bol.Describe("Datawindow.Table.Select")
ls_new_select = ls_syntax
li_retrive_pos = Pos(lower(ls_new_select), "retrieve=")
ls_new_select = left( ls_new_select, li_retrive_pos - 1) + ls_add_table_column + mid( ls_new_select, li_retrive_pos - 1)
li_from_pos = POS(upper(ls_new_select), " FROM ")
ls_new_select = left( ls_new_select, li_from_pos - 2) + ls_add_select + mid( ls_new_select, li_from_pos - 2)  
li_text_pos = POS(lower(ls_new_select), "text(")
ls_new_select = left( ls_new_select, li_text_pos - 1) + ls_add_column + mid( ls_new_select, li_text_pos - 1)  
ls_new_select = fu_quotestring(ls_new_select, "'")
adw_bol.Create(ls_new_select)
adw_bol.Modify("c_total.Expression='"+ls_compute_charge+"'")

//SELECT dbo.Customer.Cust_name, dbo.Customer.Address_1, dbo.Customer.address_2, dbo.Customer.address_3, dbo.Customer.city, dbo.Customer.state, dbo.Customer.zip   
// INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
// FROM dbo.Customer  
//WHERE dbo.Customer.Project_id = :gs_project  and dbo.Customer.cust_code = '123BILLING' ;
//

// Add the Bill To Address in the existing Bill To Box. Currently, it is being pulled from customer master where cust_code = ' 123BILLING'. 
//We should take it from the Bill To Address on the Delivery_Alt_Address where the code is 'BT'.

// 10/09 - Comcast is hardcoded, otherwise take from Delivery_Alt_address (just switched Comcast to use baseline)
If gs_project = 'COMCAST' Then
	
	//ls_remit = "Menlo - COM~rPO Box 5159~rPortland, OR 97208"
	ls_remit = "Comcast~r%XPO Logistics~rPO Box 5159~rPortland, OR 97208"
	
Else

	SELECT dbo.Delivery_Alt_Address.Name, dbo.Delivery_Alt_Address.Address_1, dbo.Delivery_Alt_Address.address_2, dbo.Delivery_Alt_Address.address_3, dbo.Delivery_Alt_Address.city, dbo.Delivery_Alt_Address.state, dbo.Delivery_Alt_Address.zip   
	 INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
	 FROM dbo.Delivery_Alt_Address  
	WHERE dbo.Delivery_Alt_Address.Do_No = :as_dono AND dbo.Delivery_Alt_Address.Project_id = :gs_project  and dbo.Delivery_Alt_Address.address_type = 'BT' ;

	IF IsNull(ls_Remit_Name) then ls_Remit_Name = ""
	IF IsNull(ls_Remit_address1) then ls_Remit_address1 = ""
	IF IsNull(ls_Remit_address2) then ls_Remit_address2 = ""
	IF IsNull(ls_Remit_address3) then ls_Remit_address3 = ""
	IF IsNull(ls_Remit_city) then ls_Remit_city = ""
	IF IsNull(ls_Remit_state) then ls_Remit_state = ""
	IF IsNull(ls_Remit_Zip) then ls_Remit_Zip = ""

	if ls_Remit_Name <> "" then
		ls_remit = ls_remit_name + "~r~n"
	end if

	if ls_Remit_address1 <> "" then
		ls_remit = ls_remit + ls_Remit_address1 + "~r~n"
	end if 

	if ls_Remit_address2 <> "" then
		ls_remit = ls_remit + ls_Remit_address2 + "~r~n"
	end if

	if ls_Remit_address3 <> "" then
		ls_remit = ls_remit + ls_Remit_address3 + "~r~n"
	end if

	ls_remit = ls_remit + ls_remit_city + ", " + ls_remit_state + ", " + ls_remit_zip 
	
End If

adw_bol.Modify("c_remit_name.Expression=~'~""+ls_remit+"~"~'")

//Retrieve the report

adw_bol.SetTransObject(sqlca)

adw_bol.Retrieve(gs_project, as_dono)

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetItem(1, "c_pieces1", ll_Carton )		
if lds_ds.rowcount() > 0 then
	ls_desc = lds_ds.GetItemstring( 1, "Code_Description") + lsDesc2
else
	ls_desc = lsDesc2
	if isNull( lsDesc2) or len( trim( lsDesc2 ) ) = 0 then ls_desc = 'No Description Available'
end if

//ls_desc = lds_ds.GetItemstring( 1, "Code_Description")
//ls_desc = 'TEMPORARY DESC!!!'
		
		//Jxlim 08/09/2013 Ariens Item description
		Select Description Into :ls_desc
		From Item_Master 
		where Project_Id=:gs_project
		and SKU in(
		 SELECT  dbo.Delivery_Packing.SKU 
		 FROM dbo.Delivery_Packing  
		WHERE dbo.Delivery_Packing.DO_No =:as_dono)
		Using SQLCA;
adw_bol.SetItem(1, "c_desc1" , ls_desc )		
adw_bol.SetItem(1, "c_weight1" , ld_weight  )		
adw_bol.SetItem(1, "c_desc2" , lsdesc3 )
adw_bol.SetItem(1, "c_desc3" , lsdesc4 )
		
// Fill AWB BOL into C_ROUTE
ls_AWB_BOL = w_do.idw_other.GetItemString(1,"AWB_BOL_NO")
If Not isnull(ls_AWB_BOL) Then
	adw_bol.setitem(1,'c_route',ls_awb_bol)
end if 		
	
//Push Footer Down
of_parsetoArray( adw_bol.Describe('Datawindow.Objects') ,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)
For i = 1 to ll_nbrobjects
	ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
	ls_type = trim(adw_bol.Describe(ls_dwobjs[i]+'.type'))
	if ls_type = "line" then
	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y1'))
	else
	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y'))
	end if
	if (li_y >= li_start_y) and &
		(left(ls_col_name, 6) <> "c_piec" and &
		left(ls_col_name, 6) <> "c_desc" and &
		left(ls_col_name, 6) <> "c_rate" and &
		left(ls_col_name, 6) <> "c_weig" and &
		left(ls_col_name, 6) <> "t_fill") then
			if ls_type = "line"  then
				adw_bol.Modify(ls_dwobjs[i] + ".y1=" + string(li_y + li_offset) + " " + ls_dwobjs[i] + ".y2=" + string(li_y + li_offset))
			else
				adw_bol.Modify(ls_dwobjs[i] + ".y=" + string(li_y + li_offset))
			end if
	  END IF
NEXT

li_tab_order =  integer(adw_bol.describe(ls_last_col+".TabSequence")) + 1

for i = 1 to UpperBound(ls_change_tab)
	adw_bol.modify(ls_change_tab[i]+".TabSequence=0")
	ls_tab_change = ls_tab_change + " " + ls_change_tab[i]+".TabSequence=" + string(li_tab_order) + " "
	li_tab_order = li_tab_order + 10
next	
adw_bol.Modify(ls_tab_change)

ll_height = long(adw_bol.Describe("DataWindow.detail.height"))

ll_height = ll_height + li_offset

adw_bol.Modify("DataWindow.detail.height="+string(ll_height))

//10/08 - PCONKL - Add special instructions (Customer UF9) for Comcast - Not really baseine but using a variance of the baseline BOL
If gs_project = 'COMCAST' and adw_bol.RowCount() > 0 Then
	
	lsCustCode = adw_bol.GetITemString(1,'Delivery_Master_Cust_Code')
	
	Select User_Field9 into :lsSpecIns
	From Customer
	Where project_id = :gs_Project and cust_Code = :lsCustCode;
	
	If lsSpecIns > '' Then
		adw_bol.Modify("special_instructions_t.text='" + lsSpecIns + "'")
	End If
	
End If
	
adw_bol.SetRedraw(true)


RETURN 1
end function

public function integer uf_process_bol_bosch (string as_dono, ref datawindow adw_bol, string as_consolidation_no);//Jxlim 12/26/2013 Vics bol for single order
//For single order with single NMFC code use inline report query (d_vics_bol_prt_singleorder)
//For single order with multple NMFC code use external datawindow report and:
//1. Write the information line by line up to 5 rows
//2. If more than 5 NMFC code on a single order then print Carrier Information supplemental page
Long   i, ll_bol_rowcount,ll_detailrowcount, ll_suplm_rowcount, ll_detail_rowcount, ll_nmfc_rowcount, ll_alt_address_rowcount, ll_nmfc_carton_rowcount
Long   ll_carton_count1, ll_carton_count2,ll_carton_count3,ll_carton_count4,ll_carton_count5,ll_total_carton_count,ll_bol_suplm,  ll_print_rtn
String ls_custcode,ls_custname, ls_carton_type

Decimal ld_Pack_qty1,ld_Pack_qty2,ld_Pack_qty3,ld_Pack_qty4,ld_Pack_qty5,ld_Pack_qty6,ld_Pack_qty7,ld_Pack_qty8, &
			ld_Pack_qty9,ld_Pack_qty10,ld_Pack_qty11,ld_Pack_qty12,ld_Pack_qty13,ld_Pack_qty14,ld_Pack_qty15,ld_Pack_qty16

Decimal ld_total_item_qty, ld_total_pack_qty, ld_total_thd_qty, ld_total_thd_weight
Decimal ld_weight1,ld_weight2,ld_weight3,ld_weight4,ld_weight5, ld_total_net_w, ld_total_pack_weight
Decimal ld_totalw1, ld_totalw2,ld_totalw3,ld_totalw4,ld_totalw5
Decimal ld_totalw6, ld_totalw7,ld_totalw8,ld_totalw9,ld_totalw10
Decimal ld_totalw11, ld_totalw12,ld_totalw13,ld_totalw14,ld_totalw15,ld_totalw16
long ll_supplemental_count,ll_NoofPages,ll_page,ll_count //29-Aug-2015 :Madhu Added ll_NoofPages,ll_page
String ls_carton_type1, ls_carton_type2, ls_carton_type3, ls_carton_type4, ls_carton_type5

String ls_nmfcdescription1, ls_nmfcdescription2,ls_nmfcdescription3,ls_nmfcdescription4,ls_nmfcdescription5, &
		ls_nmfcdescription6, ls_nmfcdescription7,ls_nmfcdescription8,ls_nmfcdescription9,ls_nmfcdescription10, &
		ls_nmfcdescription11, ls_nmfcdescription12,ls_nmfcdescription13,ls_nmfcdescription14,ls_nmfcdescription15,ls_nmfcdescription16

String ls_nmfc1,ls_nmfc2,ls_nmfc3,ls_nmfc4,ls_nmfc5,ls_nmfc6,ls_nmfc7,ls_nmfc8, &
		ls_nmfc9,ls_nmfc10,ls_nmfc11,ls_nmfc12,ls_nmfc13,ls_nmfc14,ls_nmfc15,ls_nmfc16

String ls_class1,ls_class2,ls_class3,ls_class4,ls_class5, ls_class6,ls_class7,ls_class8,ls_class9,ls_class10, &
		ls_class11,ls_class12,ls_class13,ls_class14,ls_class15,ls_class16

String ls_cust_ord_nbr1,ls_cust_ord_nbr2,ls_cust_ord_nbr3,ls_cust_ord_nbr4,ls_cust_ord_nbr5, &
		ls_cust_ord_nbr6,ls_cust_ord_nbr7,ls_cust_ord_nbr8,ls_cust_ord_nbr9,ls_cust_ord_nbr10, &
		ls_cust_ord_nbr11,ls_cust_ord_nbr12,ls_cust_ord_nbr13,ls_cust_ord_nbr14,ls_cust_ord_nbr15, ls_cust_ord_nbr16		
String ls_invoice_no_hdr
String ls_invoice_no1, ls_invoice_no2,  ls_invoice_no3, ls_invoice_no4, ls_invoice_no5, &
		ls_invoice_no6, ls_invoice_no7,  ls_invoice_no8, ls_invoice_no9, ls_invoice_no10, &
		 ls_invoice_no11, ls_invoice_no12,  ls_invoice_no13, ls_invoice_no14, ls_invoice_no15, ls_invoice_no16
Decimal ld_item_qty1,ld_item_qty2,ld_item_qty3,ld_item_qty4,ld_item_qty5
DataStore lds_bol_header,lds_bol_detail, lds_bol_suplm
DatawindowChild ldwc_suplm

Int liNbrPages, liModPages

Boolean lb_suplm

lb_suplm = False

Long 	llpackqty,llscannedqty ,llserialcnt,lleligiblecnt

// TAM 2018/07/20 - S21706 
string	lsCustName
boolean lbTHD

//get eligible records for scanning
// TAM 2014/01/15 - Changed from Count to Sum.  Not all items are scannable and we only want to compare the number of Scannable with the number of serials
//select count(*) into :lleligiblecnt from Delivery_Packing,Item_Master
select sum(Quantity) into :lleligiblecnt from Delivery_Packing,Item_Master
where Delivery_Packing.SKU = Item_Master.SKU
and Delivery_Packing.DO_No= :as_dono
and Item_Master.Project_Id=:gs_project
and Item_Master.Serialized_Ind in ('Y','B')
using SQLCA;

If lleligiblecnt >0 Then
//TAM	Select sum(Quantity) into :llpackqty from Delivery_Packing where Do_No =:as_dono using SQLCA;
	Select Sum(quantity) into :llScannedQty from delivery_serial_detail Where Id_no in (select id_no from delivery_picking_detail where do_no = :as_dono) using SQLCA;
	
	If IsNull(llScannedQty) then 
		llScannedQty =0 
	end if
	
// TAM	If llpackqty <> llScannedQty Then
	If lleligiblecnt <> llScannedQty Then
		MessageBox(w_do.is_title,"All Serial no's are not being scanned. Please check.",Stopsign!)
		Return 0
	End if 
End if 

// TAM 2018/07/20 - S21706 Added Home Depot BOL. Determined By Cust_Name Starting with "THD-"
lbTHD = False

// TAM - 8/16/2018 - DE5810 - Only print the THD BOL if it is a Single BOL. The New THD values don't exist in the Consolidated DW Objects and an error occures if we try to load them. Leaving lbTHD = False will skip loading the New Values
// GWM 9/5/2019 - DE12480 - Added consolidated for THD back in
//TAM - 2019/1/09 - S25314 - Removed consolidated for THD
//TAM - 2018/12/08 - S25314 - Added consolidated for THD
//TAM - 2018/11/08 - S25314 -Removed consolidated for THD
//If as_consolidation_no = '' Then
	
	select Cust_Name into :lsCustName from Delivery_Master
	where Delivery_Master.DO_No= :as_dono
	and Delivery_Master.Cust_Name like 'THD-%'
	using SQLCA;
	if lsCustName > '' Then lbTHD = True

//End If


//Datastore for Report header section
lds_bol_header = create datastore
// TAM 2018/07/20 - S21706 
If lbTHD = false then
	lds_bol_header.dataobject = 'd_bosch_bol_prt_header'
else
	lds_bol_header.dataobject = 'd_bosch_bol_prt_header_thd'
end if

lds_bol_header.SetTransObject(SQLCA)
lds_bol_header.Retrieve(gs_project, as_dono)


//Datastore for Report detail section
If as_consolidation_no = '' then
	lds_bol_detail = create datastore
	// TAM 2018/07/20 - S21706 
	If lbTHD = false then
		lds_bol_detail.dataobject = 'd_bosch_bol_prt_single_detail'
	else
		lds_bol_detail.dataobject = 'd_bosch_bol_prt_single_detail_thd'
	end if
	lds_bol_detail.SetTransObject(SQLCA)
	lds_bol_detail.Retrieve(gs_project, as_dono)
	ll_detailrowcount=lds_bol_detail.rowcount()
// TAM 2014/11/5 Added Supplemetal Report if more than one page
	//Suplemental page
	lds_bol_suplm = Create datastore
	// TAM 2018/07/20 - S21706 
	If lbTHD = false then
		lds_bol_suplm.dataobject = 'd_bosch_bol_prt_singleorder_suplm_rpt'   //Supplemental Page report
		lds_bol_suplm.GetChild('dw_bosch_singleorder_suplm', ldwc_suplm)
	Else
		lds_bol_suplm.dataobject = 'd_bosch_bol_prt_singleorder_suplm_rpt_thd'   //Supplemental Page report
		lds_bol_suplm.GetChild('dw_bosch_singleorder_suplm_thd', ldwc_suplm)
	End If
	
	ldwc_suplm.SetTransObject(SQLCA)	
	ldwc_suplm.Retrieve(gs_project, as_dono)
else
	lds_bol_detail = create datastore
	If lbTHD = false then
		lds_bol_detail.dataobject = 'd_bosch_bol_prt_consolidated_detail'
	Else
		lds_bol_detail.dataobject = 'd_bosch_bol_prt_consolidated_detail_thd'
	End If
	lds_bol_detail.SetTransObject(SQLCA)
	lds_bol_detail.Retrieve(gs_project, as_consolidation_no)
	ll_detailrowcount=lds_bol_detail.rowcount()
// TAM 2014/11/5 Added Supplemetal Report if more than one page
	//Suplemental page
	lds_bol_suplm = Create datastore
	If lbTHD = false then
		lds_bol_suplm.dataobject = 'd_bosch_bol_prt_consolidated_suplm_rpt'   //Supplemental Page report
		lds_bol_suplm.GetChild('dw_bosch_consolidated_suplm', ldwc_suplm)
	Else
		lds_bol_suplm.dataobject = 'd_bosch_bol_prt_consolidated_suplm_rpt_thd'   //Supplemental Page report
		lds_bol_suplm.GetChild('dw_bosch_consolidated_suplm_thd', ldwc_suplm)
	End If
	ldwc_suplm.SetTransObject(SQLCA)	
	ll_supplemental_count = ldwc_suplm.Retrieve(gs_project, as_consolidation_no)
End If	

If as_consolidation_no = '' Then 
	// TAM 2018/07/20 - S21706 
	If lbTHD = false then
		adw_bol.dataobject = 'd_bosch_bol_prt_single_ext'
	Else
		adw_bol.dataobject = 'd_bosch_bol_prt_single_ext_thd'
	End If
Else 
	If lbTHD = false then
		adw_bol.dataobject = 'd_bosch_bol_prt_consolidated_ext'
	Else
		adw_bol.dataobject = 'd_bosch_bol_prt_consolidated_ext_thd'
	End If
End If

adw_bol.SetTransObject(SQLCA)
adw_bol.Retrieve(gs_project, as_dono) 
ll_bol_rowcount= adw_bol.Rowcount()

liNbrPages = Int( ll_detailrowcount / 16 )
liModPages = Mod( ll_detailrowcount,16 )
//ll_NoofPages = ll_detailrowcount /16  replaced

If liModPages > 0 THEN //16 rows per each BOL
	liNbrPages +=1
END IF
//04-Dec-2017 :GailM - Get the number of pages needed
//29-Aug-2015 :Madhu- Added to get No of Pages to Print BOL - END

For ll_page=1 to liNbrPages //29-Aug-2015 :Madhu- Loop through each BOL to Print
	
	IF ll_page > 1 THEN ll_count +=16 else ll_count =0 //increment the row value (Get next 16 records for each new page)
	
	//Jxlim Insert row to begin for external dw
	adw_bol.InsertRow(0)
	//Header Info
		//Ship From address from Warehouse Table
		adw_bol.SetItem(ll_page,"wh_name", lds_bol_header.GetitemString(1, "wh_Name"))
		adw_bol.SetItem(ll_page,"wh_addr1", lds_bol_header.GetitemString(1,"wh_Addr1" ))  
		adw_bol.SetItem(ll_page,"wh_addr2", lds_bol_header.GetitemString(1,"wh_Addr2" ))   
		adw_bol.SetItem(ll_page,"wh_addr3", lds_bol_header.GetitemString(1,"wh_Addr3"))    
		adw_bol.SetItem(ll_page,"wh_addr4", lds_bol_header.GetitemString(1,"wh_Addr4" ))   
		adw_bol.SetItem(ll_page,"wh_city", lds_bol_header.GetitemString(1,"wh_City" ))  
		adw_bol.SetItem(ll_page,"wh_state", lds_bol_header.GetitemString(1,"wh_State" ))     
		adw_bol.SetItem(ll_page,"wh_zip", lds_bol_header.GetitemString(1,"wh_Zip" ))    
		
		//Ship To from Delivery_Master Table
		adw_bol.SetItem(ll_page,"cust_code",  lds_bol_header.GetitemString(1, "Cust_code"))
		adw_bol.SetItem(ll_page,"cust_name", lds_bol_header.GetitemString(1, "Cust_Name"))
		adw_bol.SetItem(ll_page,"cust_addr1", lds_bol_header.GetitemString(1,"Address_1" ))  
		adw_bol.SetItem(ll_page,"cust_addr2", lds_bol_header.GetitemString(1,"Address_2" ))   
		adw_bol.SetItem(ll_page,"cust_addr3", lds_bol_header.GetitemString(1,"Address_3"))    
		adw_bol.SetItem(ll_page,"cust_addr4", lds_bol_header.GetitemString(1,"Address_4" ))   
		adw_bol.SetItem(ll_page,"cust_city", lds_bol_header.GetitemString(1,"City" ))  
		adw_bol.SetItem(ll_page,"cust_state", lds_bol_header.GetitemString(1,"State" ))     
		adw_bol.SetItem(ll_page,"cust_zip", lds_bol_header.GetitemString(1,"Zip" ))    
		adw_bol.SetItem(ll_page,"contact_person", lds_bol_header.GetitemString(1,"Contact_person"  ))  
		adw_bol.SetItem(ll_page,"tel", lds_bol_header.GetitemString(1,"Tel"  ))  
		adw_bol.SetItem(ll_page,"shipping_instr", lds_bol_header.GetitemString(1,"shipping_instr"))  
		 ls_invoice_no_hdr =  lds_bol_header.GetitemString(1,"invoice_no"  )
 		adw_bol.SetItem(ll_page,"invoice_no", lds_bol_header.GetitemString(1,"invoice_no"  ))  
		adw_bol.SetItem(ll_page,"consol_no", lds_bol_header.GetitemString(1,"consolidation_no"  ))   //There won't be consolidation_no for single order
		adw_bol.SetItem(ll_page,"awb_bol_no", lds_bol_header.GetitemString(1,"awb_bol_no"  ))  
		adw_bol.SetItem(ll_page,"trailer_no", lds_bol_header.GetitemString(1,"Trailer_no"  ))  		 //DM.user_field2		
		adw_bol.SetItem(ll_page,"pro_no", lds_bol_header.GetitemString(1,"Carrier_Pro_No"  )) 	//DM.user_field7  Jxlim 04/02/2014 Replaced with carrier_pro_no name field
		adw_bol.SetItem(ll_page,"scac", lds_bol_header.GetitemString(1,"scac"  ))  					// Carrier_Master.Carrier_code first 4 digits
		adw_bol.SetItem(ll_page,"Freight_Terms", lds_bol_header.GetitemString(1,"Freight_Terms"  )) //Frieght_terms, X mark visible based on frieght_terms 		
		// TAM 2018/07/20 - S21706 
		If lbTHD = True then
			adw_bol.SetItem(ll_page,"user_field1", lds_bol_detail.GetitemString(1,"User_Field1"  )) //PO Number
			adw_bol.SetItem(ll_page,"user_field3", lds_bol_header.GetitemString(1,"User_Field3"  )) // MCODE
			adw_bol.SetItem(ll_page,"user_field4", lds_bol_header.GetitemString(1,"User_Field4"  )) // Store Code		
			adw_bol.SetItem(ll_page,"user_field5", lds_bol_header.GetitemString(1,"User_Field5"  )) // MS#		
		End If
		
		//Order information--------------------------------------------------------------------------------------------------			
// TAM 2014/11/02 - Added multipe pages to print
//29-Aug-2015 :Madhu- commented to don't print Supplemental page
//		If	ll_detailrowcount > 16 Then
//			adw_bol.Modify("ordercount_t.visible=1 compute_3.visible=0 compute_5.visible=1" )
//		else
//			adw_bol.Modify("ordercount_t.visible=0 compute_3.visible=1 compute_5.visible=0" )
//		End If
			
			For i = ll_count+1 to 	ll_detailrowcount
				If i = ll_count+1 Then
						ls_cust_ord_nbr1= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr1",ls_cust_ord_nbr1)
						
						ld_pack_qty1=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty1",ld_pack_qty1)
						
						ld_totalw1=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight1",ld_totalw1)
							
						ls_invoice_no1=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no1",ls_invoice_no1)
						
						ls_nmfcdescription1=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription1",ls_nmfcdescription1)
					
						ls_nmfc1= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc1",ls_nmfc1)
					
						ls_class1=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class1",ls_class1)
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku1",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial1",lds_bol_detail.GetitemString(i, "serial_no"))
							
							adw_bol.SetItem(ll_page,"total_weight1",adw_bol.GetItemDecimal(ll_page,"total_weight1")/adw_bol.GetItemDecimal(ll_page,"pack_qty1"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight1")
							
							adw_bol.SetItem(ll_page,"pack_qty1", 1)		//***
							ld_total_thd_qty ++
						End If
				
				ElseIf i = ll_count+2 Then
						ls_cust_ord_nbr2= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr2",ls_cust_ord_nbr2)
						
						ld_pack_qty2=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty2",ld_pack_qty2)
						
						ld_totalw2=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight2",ld_totalw2)
							
						ls_invoice_no2=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no2",ls_invoice_no2)
						
						ls_nmfcdescription2=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription2",ls_nmfcdescription2)
					
						ls_nmfc2= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc2",ls_nmfc2)
					
						ls_class2=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class2",ls_class2)

						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku2",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial2",lds_bol_detail.GetitemString(i, "serial_no"))
							
							adw_bol.SetItem(ll_page,"total_weight2",adw_bol.GetItemDecimal(ll_page,"total_weight2")/adw_bol.GetItemDecimal(ll_page,"pack_qty2"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight2")
							
							adw_bol.SetItem(ll_page,"pack_qty2", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+3 Then
						ls_cust_ord_nbr3= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr3",ls_cust_ord_nbr3)
							
						ld_pack_qty3=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty3",ld_pack_qty3)
						
						ld_totalw3=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight3",ld_totalw3)
						
						ls_invoice_no3=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no3",ls_invoice_no3)		
						
						ls_nmfcdescription3=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription3",ls_nmfcdescription1)
					
						ls_nmfc3= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc3",ls_nmfc3)
					
						ls_class3=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class3",ls_class3)
						  
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku3",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial3",lds_bol_detail.GetitemString(i, "serial_no"))
							
							adw_bol.SetItem(ll_page,"total_weight3",adw_bol.GetItemDecimal(ll_page,"total_weight3")/adw_bol.GetItemDecimal(ll_page,"pack_qty3"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight3")
							
							adw_bol.SetItem(ll_page,"pack_qty3", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+4 Then
						ls_cust_ord_nbr4= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr4",ls_cust_ord_nbr4)
						
						ld_pack_qty4=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty4",ld_pack_qty4)
						
						ld_totalw4=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight4",ld_totalw4)
						
						ls_invoice_no4=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no4",ls_invoice_no4)
						
						ls_nmfcdescription4=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription4",ls_nmfcdescription4)
					
						ls_nmfc4= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc4",ls_nmfc4)
					
						ls_class4=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class4",ls_class4)
				
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku4",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial4",lds_bol_detail.GetitemString(i, "serial_no"))
								
							adw_bol.SetItem(ll_page,"total_weight4",adw_bol.GetItemDecimal(ll_page,"total_weight4")/adw_bol.GetItemDecimal(ll_page,"pack_qty4"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight4")

							adw_bol.SetItem(ll_page,"pack_qty4", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+5 Then	
						ls_cust_ord_nbr5= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr5",ls_cust_ord_nbr5)
							
						ld_pack_qty5=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty5",ld_pack_qty5)
						
						ld_totalw5=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight5",ld_totalw5)
						
						ls_invoice_no5=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no5",ls_invoice_no5)				
						
						ls_nmfcdescription5=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription5",ls_nmfcdescription5)
					
						ls_nmfc5= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc5",ls_nmfc5)
					
						ls_class5=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class5",ls_class5)
				
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku5",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial5",lds_bol_detail.GetitemString(i, "serial_no"))
								
							adw_bol.SetItem(ll_page,"total_weight5",adw_bol.GetItemDecimal(ll_page,"total_weight5")/adw_bol.GetItemDecimal(ll_page,"pack_qty5"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight5")

							adw_bol.SetItem(ll_page,"pack_qty5", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+6 Then	
						ls_cust_ord_nbr6= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr6",ls_cust_ord_nbr6)
							
						ld_pack_qty6=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty6",ld_pack_qty6)
						
						ld_totalw6=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight6",ld_totalw6)
						
						ls_invoice_no6=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no6",ls_invoice_no6)				
						
						ls_nmfcdescription6=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription6",ls_nmfcdescription6)
					
						ls_nmfc6= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc6",ls_nmfc6)
					
						ls_class6=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class6",ls_class6)
				
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku6",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial6",lds_bol_detail.GetitemString(i, "serial_no"))
								
							adw_bol.SetItem(ll_page,"total_weight6",adw_bol.GetItemDecimal(ll_page,"total_weight6")/adw_bol.GetItemDecimal(ll_page,"pack_qty6"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight6")

							adw_bol.SetItem(ll_page,"pack_qty6", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+7 Then
						ls_cust_ord_nbr7= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr7",ls_cust_ord_nbr7)
						
						ld_pack_qty7=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty7",ld_pack_qty7)
						
						ld_totalw7=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight7",ld_totalw7)
							
						ls_invoice_no7=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no7",ls_invoice_no7)
						
						ls_nmfcdescription7=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription7",ls_nmfcdescription7)
					
						ls_nmfc7= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc7",ls_nmfc7)
					
						ls_class7=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class7",ls_class7)
				
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku7",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial7",lds_bol_detail.GetitemString(i, "serial_no"))
								
							adw_bol.SetItem(ll_page,"total_weight7",adw_bol.GetItemDecimal(ll_page,"total_weight7")/adw_bol.GetItemDecimal(ll_page,"pack_qty7"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight7")

							adw_bol.SetItem(ll_page,"pack_qty7", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+8 Then
						ls_cust_ord_nbr8= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr8",ls_cust_ord_nbr8)
						
						ld_pack_qty8=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty8",ld_pack_qty8)
						
						ld_totalw8=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight8",ld_totalw8)
							
						ls_invoice_no8=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no8",ls_invoice_no8)
						
						ls_nmfcdescription8=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription8",ls_nmfcdescription8)
					
						ls_nmfc8= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc8",ls_nmfc8)
					
						ls_class8=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class8",ls_class8)
						
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku8",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial8",lds_bol_detail.GetitemString(i, "serial_no"))
								
							adw_bol.SetItem(ll_page,"total_weight8",adw_bol.GetItemDecimal(ll_page,"total_weight8")/adw_bol.GetItemDecimal(ll_page,"pack_qty8"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight8")

							adw_bol.SetItem(ll_page,"pack_qty8", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+9 Then
						ls_cust_ord_nbr9= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr9",ls_cust_ord_nbr9)
							
						ld_pack_qty9=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty9",ld_pack_qty9)
						
						ld_totalw9=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight9",ld_totalw9)
						
						ls_invoice_no9=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no9",ls_invoice_no9)		
						
						ls_nmfcdescription9=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription9",ls_nmfcdescription1)
					
						ls_nmfc9= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc9",ls_nmfc9)
					
						ls_class9=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class9",ls_class9)
						  
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku9",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial9",lds_bol_detail.GetitemString(i, "serial_no"))
								
							adw_bol.SetItem(ll_page,"total_weight9",adw_bol.GetItemDecimal(ll_page,"total_weight9")/adw_bol.GetItemDecimal(ll_page,"pack_qty9"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight9")

							adw_bol.SetItem(ll_page,"pack_qty9", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+10 Then
						ls_cust_ord_nbr10= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr10",ls_cust_ord_nbr10)
						
						ld_pack_qty10=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty10",ld_pack_qty10)
						
						ld_totalw10=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight10",ld_totalw10)
						
						ls_invoice_no10=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no10",ls_invoice_no10)
						
						ls_nmfcdescription10=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription10",ls_nmfcdescription10)
					
						ls_nmfc10= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc10",ls_nmfc10)
					
						ls_class10=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class10",ls_class10)
				
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku10",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial10",lds_bol_detail.GetitemString(i, "serial_no"))
								
							adw_bol.SetItem(ll_page,"total_weight10",adw_bol.GetItemDecimal(ll_page,"total_weight10")/adw_bol.GetItemDecimal(ll_page,"pack_qty10"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight10")

							adw_bol.SetItem(ll_page,"pack_qty10", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+11 Then	
						ls_cust_ord_nbr11= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr11",ls_cust_ord_nbr11)
							
						ld_pack_qty11=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty11",ld_pack_qty11)
						
						ld_totalw11=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight11",ld_totalw11)
						
						ls_invoice_no11=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no11",ls_invoice_no11)				
						
						ls_nmfcdescription11=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription11",ls_nmfcdescription11)
					
						ls_nmfc11= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc11",ls_nmfc11)
					
						ls_class11=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class11",ls_class11)
				
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku11",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial11",lds_bol_detail.GetitemString(i, "serial_no"))
								
							adw_bol.SetItem(ll_page,"total_weight11",adw_bol.GetItemDecimal(ll_page,"total_weight11")/adw_bol.GetItemDecimal(ll_page,"pack_qty11"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight11")

							adw_bol.SetItem(ll_page,"pack_qty11", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+12 Then	
						ls_cust_ord_nbr12= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr12",ls_cust_ord_nbr12)
							
						ld_pack_qty12=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty12",ld_pack_qty12)
						
						ld_totalw12=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight12",ld_totalw12)
						
						ls_invoice_no12=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no12",ls_invoice_no12)				
						
						ls_nmfcdescription12=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription12",ls_nmfcdescription12)
					
						ls_nmfc12= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc12",ls_nmfc12)
					
						ls_class12=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class12",ls_class12)
				
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku12",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial12",lds_bol_detail.GetitemString(i, "serial_no"))
								
							adw_bol.SetItem(ll_page,"total_weight12",adw_bol.GetItemDecimal(ll_page,"total_weight12")/adw_bol.GetItemDecimal(ll_page,"pack_qty12"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight12")

							adw_bol.SetItem(ll_page,"pack_qty12", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+13 Then
						ls_cust_ord_nbr13= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr13",ls_cust_ord_nbr13)
							
						ld_pack_qty13=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty13",ld_pack_qty13)
						
						ld_totalw13=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight13",ld_totalw13)
						
						ls_invoice_no13=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no13",ls_invoice_no13)		
						
						ls_nmfcdescription13=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription13",ls_nmfcdescription1)
					
						ls_nmfc13= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc13",ls_nmfc13)
					
						ls_class13=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class13",ls_class13)
						  
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku13",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial13",lds_bol_detail.GetitemString(i, "serial_no"))
								
							adw_bol.SetItem(ll_page,"total_weight13",adw_bol.GetItemDecimal(ll_page,"total_weight13")/adw_bol.GetItemDecimal(ll_page,"pack_qty13"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight13")

							adw_bol.SetItem(ll_page,"pack_qty13", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+14 Then
						ls_cust_ord_nbr14= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr14",ls_cust_ord_nbr14)
						
						ld_pack_qty14=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty14",ld_pack_qty14)
						
						ld_totalw14=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight14",ld_totalw14)
						
						ls_invoice_no14=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no14",ls_invoice_no14)
						
						ls_nmfcdescription14=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription14",ls_nmfcdescription14)
					
						ls_nmfc14= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc14",ls_nmfc14)
					
						ls_class14=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class14",ls_class14)
				
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku14",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial14",lds_bol_detail.GetitemString(i, "serial_no"))
								
							adw_bol.SetItem(ll_page,"total_weight14",adw_bol.GetItemDecimal(ll_page,"total_weight14")/adw_bol.GetItemDecimal(ll_page,"pack_qty14"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight14")

							adw_bol.SetItem(ll_page,"pack_qty14", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+15 Then	
						ls_cust_ord_nbr15= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr15",ls_cust_ord_nbr15)
							
						ld_pack_qty15=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty15",ld_pack_qty15)
						
						ld_totalw15=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight15",ld_totalw15)
						
						ls_invoice_no15=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no15",ls_invoice_no15)				
						
						ls_nmfcdescription15=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription15",ls_nmfcdescription15)
					
						ls_nmfc15= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc15",ls_nmfc15)
					
						ls_class15=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class15",ls_class15)
				
						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku15",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial15",lds_bol_detail.GetitemString(i, "serial_no"))
								
							adw_bol.SetItem(ll_page,"total_weight15",adw_bol.GetItemDecimal(ll_page,"total_weight15")/adw_bol.GetItemDecimal(ll_page,"pack_qty15"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight15")

							adw_bol.SetItem(ll_page,"pack_qty15", 1)		//***
							ld_total_thd_qty ++
						End If
						
				ElseIf i = ll_count+16 Then	
						ls_cust_ord_nbr16= lds_bol_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(ll_page,"cust_ord_nbr16",ls_cust_ord_nbr16)
							
						ld_pack_qty16=lds_bol_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(ll_page,"pack_qty16",ld_pack_qty16)
						
						ld_totalw16=lds_bol_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(ll_page,"total_weight16",ld_totalw16)
						
						ls_invoice_no16=lds_bol_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(ll_page,"invoice_no16",ls_invoice_no16)				
						
						ls_nmfcdescription16=lds_bol_detail.GetitemString(i,"nmfc_description")
						adw_bol.SetItem(ll_page,"nmfcdescription16",ls_nmfcdescription16)
					
						ls_nmfc16= lds_bol_detail.GetitemString(i,"nmfc"  )
						adw_bol.SetItem(ll_page,"nmfc16",ls_nmfc16)
					
						ls_class16=lds_bol_detail.GetitemString(i,"class" )
						adw_bol.SetItem(ll_page,"class16",ls_class16)

						// TAM 2018/07/20 - S21706 
						If lbTHD = true then
							adw_bol.SetItem(ll_page,"sku16",lds_bol_detail.GetitemString(i, "sku"))
							adw_bol.SetItem(ll_page,"serial16",lds_bol_detail.GetitemString(i, "serial_no"))
								
							adw_bol.SetItem(ll_page,"total_weight16",adw_bol.GetItemDecimal(ll_page,"total_weight16")/adw_bol.GetItemDecimal(ll_page,"pack_qty16"))
							ld_total_thd_weight += adw_bol.GetItemDecimal(ll_page,"total_weight16")

							adw_bol.SetItem(ll_page,"pack_qty16", 1)		//***
							ld_total_thd_qty ++
						End If
						
				End if
			Next	
		
			//Total Qty and total Weight by Order number
			If lbTHD then
				ld_total_pack_qty= ld_total_thd_qty  //sum of total pack qty if THD
				ld_total_pack_weight= ld_total_thd_weight  //sum of total weight if THD
			Else
				ld_total_pack_qty=  lds_bol_detail.GetitemDecimal(1,"total_pack_qty")  //sum of total pack qty
				ld_total_pack_weight= lds_bol_detail.GetitemDecimal(1,"total_pack_weight")  //sum of total weight
			End If
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child
			adw_bol.SetItem(ll_page,"total_pack_qty",ld_total_pack_qty)
			adw_bol.SetItem(ll_page,"total_pack_Weight",ld_total_pack_Weight)	
//		End If
			

		//End If //End for external dw report
			
		//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss
		DataStore lds_bol_alt_address
		Long ll_alt_addr_count
		lds_bol_alt_address = create datastore
		lds_bol_alt_address.dataobject = 'd_do_address_alt'
		lds_bol_alt_address.SetTransObject(SQLCA)
		lds_bol_alt_address.Retrieve(as_dono, 'BT')  //as_dono asType=BT (Bill To for BOL) --3P is for Trax/Third Party
		ll_alt_addr_count=lds_bol_alt_address.Rowcount()
		
		//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss --BOL third party address uses Bill TO ('BT') address type			
		If	ll_alt_addr_count > 0 Then	
			adw_bol.SetItem(ll_page, "alt_name", lds_bol_alt_address.GetItemString(1, "name"))		
			adw_bol.SetItem(ll_page, "alt_addr1", lds_bol_alt_address.GetItemString(1, "address_1"))
			adw_bol.SetItem(ll_page, "alt_addr2", lds_bol_alt_address.GetItemString(1, "address_2"))
			adw_bol.SetItem(ll_page, "alt_addr3", lds_bol_alt_address.GetItemString(1, "address_3"))
			adw_bol.SetItem(ll_page, "alt_addr4", lds_bol_alt_address.GetItemString(1, "address_4"))
			adw_bol.SetItem(ll_page, "alt_city",    lds_bol_alt_address.GetItemString(1, "city"))
			adw_bol.SetItem(ll_page, "alt_state",  lds_bol_alt_address.GetItemString(1, "state"))
			adw_bol.SetItem(ll_page, "alt_zip",     lds_bol_alt_address.GetItemString(1, "zip"))
		End If

Next //29-Aug-2015 :Madhu- Loop through each BOL to Print

////If 	Row Count > 16 print the supplimental page
//		If	ll_detailrowcount > 16 Then
//			For i = 1 to 16 /*each Order*/
//				lds_bol_suplm.DeleteRow(0)
//			Next
//		End If

//29-Aug-2015 :Madhu- commented to don't print Supplemental page
//If 	ll_detailrowcount > 16 Then
//	ll_print_rtn = OpenWithParm(w_dw_print_options,lds_bol_suplm) //print dialog
//	If ll_print_rtn > 0 then
//		Print(adw_bol)
//	End If
//End If

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetRedraw(true)

RETURN 1
end function

public function integer uf_process_vics_bol_singleorder (string as_dono, ref datawindow adw_bol);//Jxlim 12/26/2013 Vics bol for single order
//For single order with single NMFC code use inline report query (d_vics_bol_prt_singleorder)
//For single order with multple NMFC code use external datawindow report and:
//1. Write the information line by line up to 5 rows
//2. If more than 5 NMFC code on a single order then print Carrier Information supplemental page
Long   i, ll_bol_rowcount,ll_detailrowcount, ll_nmfc_suplm_rowcount, ll_detail_rowcount, ll_nmfc_rowcount, ll_alt_address_rowcount, ll_nmfc_carton_rowcount
Long   ll_carton_count1, ll_carton_count2,ll_carton_count3,ll_carton_count4,ll_carton_count5,ll_total_carton_count,ll_bol_suplm
String ls_custcode,ls_custname, ls_carton_type
Decimal ld_Pack_qty1,ld_Pack_qty2,ld_Pack_qty3,ld_Pack_qty4,ld_Pack_qty5
Decimal ld_total_item_qty, ld_total_pack_qty
Decimal ld_weight1,ld_weight2,ld_weight3,ld_weight4,ld_weight5, ld_total_net_w, ld_total_pack_weight
Decimal ld_totalw1, ld_totalw2,ld_totalw3,ld_totalw4,ld_totalw5
String ls_carton_type1, ls_carton_type2, ls_carton_type3, ls_carton_type4, ls_carton_type5
String ls_nmfcdescription1, ls_nmfcdescription2,ls_nmfcdescription3,ls_nmfcdescription4,ls_nmfcdescription5, ls_nmfc1,ls_nmfc2,ls_nmfc3,ls_nmfc4,ls_nmfc5
String ls_class1,ls_class2,ls_class3,ls_class4,ls_class5
String ls_cust_ord_nbr1,ls_cust_ord_nbr2,ls_cust_ord_nbr3,ls_cust_ord_nbr4,ls_cust_ord_nbr5
String ls_invoice_no1, ls_invoice_no2,  ls_invoice_no3, ls_invoice_no4, ls_invoice_no5
Decimal ld_item_qty1,ld_item_qty2,ld_item_qty3,ld_item_qty4,ld_item_qty5
DataStore lds_bol_singleorder_header,lds_bol_singleorder_detail
Boolean lb_suplm

//14-Aug-2015 :Madhu- Added code to print Carton and Pallet count separetly on BOL - START
int row
string lscarton_type
long ll_total_pallet_count
//14-Aug-2015 :Madhu- Added code to print Carton and Pallet count separetly on BOL - END

lb_suplm = False

//03-Jan-2014 :Madhu -Added code to verify whether all serial no's are scanned? -START
Long 	llpackqty,llscannedqty ,llserialcnt,lleligiblecnt

//get eligible records for scanning
// TAM 2014/01/15 - Changed from Count to Sum.  Not all items are scannable and we only want to compare the number of Scannable with the number of serials
//select count(*) into :lleligiblecnt from Delivery_Packing,Item_Master
//20-Aug-2015 :Madhu- Added "Project Id" condition to avoid to retrieve same SKU records which have been associated with different Projects.
select sum(Quantity) into :lleligiblecnt from Delivery_Packing,Item_Master
where Delivery_Packing.SKU = Item_Master.SKU
and Delivery_Packing.DO_No= :as_dono
and Item_Master.Project_Id=:gs_project
and Item_Master.Serialized_Ind in ('Y','B')
using SQLCA;

If lleligiblecnt >0 Then
//TAM	Select sum(Quantity) into :llpackqty from Delivery_Packing where Do_No =:as_dono using SQLCA;
	Select Sum(quantity) into :llScannedQty from delivery_serial_detail Where Id_no in (select id_no from delivery_picking_detail where do_no = :as_dono) using SQLCA;
	
	If IsNull(llScannedQty) then 
		llScannedQty =0 
	end if
	
// TAM	If llpackqty <> llScannedQty Then
	If lleligiblecnt <> llScannedQty Then
		MessageBox(w_do.is_title,"All Serial no's are not being scanned. Please check.",Stopsign!)
		Return 0
	End if 
End if 

//03-Jan-2014 :Madhu - Added code to verify whether all serial no's are scanned? -END

//Datastore for Report header section
lds_bol_singleorder_header = create datastore
lds_bol_singleorder_header.dataobject = 'd_vics_bol_prt_singleorder_header'
lds_bol_singleorder_header.SetTransObject(SQLCA)
lds_bol_singleorder_header.Retrieve(gs_project, as_dono)

//Datastore for Report header section
lds_bol_singleorder_detail = create datastore
lds_bol_singleorder_detail.dataobject = 'd_vics_bol_prt_singleorder_detail'
lds_bol_singleorder_detail.SetTransObject(SQLCA)
lds_bol_singleorder_detail.Retrieve(gs_project, as_dono)
ll_detailrowcount=lds_bol_singleorder_detail.rowcount()

//Suplemental page
DatawindowChild ldwc_nmfcitem_suplm
Datastore lds_bol_suplm
lds_bol_suplm = Create datastore
lds_bol_suplm.dataobject = 'd_vics_bol_prt_singleorder_suplm_composite_rpt'   //composite report

lds_bol_suplm.GetChild('dw_single_nmfcitem_suplm', ldwc_nmfcitem_suplm)
ldwc_nmfcitem_suplm.SetTransObject(SQLCA)	
ldwc_nmfcitem_suplm.Retrieve(gs_project, as_dono)
ll_nmfc_suplm_rowcount=ldwc_nmfcitem_suplm.Rowcount()

adw_bol.SetTransObject(SQLCA)
adw_bol.Retrieve(gs_project, as_dono) 
ll_bol_rowcount= adw_bol.Rowcount()

//If more than 1 row use external dw otherwise use inline sql on report (d_vics_bol_prt_singleorder)
If ll_bol_rowcount > 1 Then 
	adw_bol.dataobject = 'd_vics_bol_prt_combine_ext'
	//Jxlim Insert row to begin for external dw
	adw_bol.InsertRow(0)
	//Header Info
		//Using  lds_bol_singleorder_header datastore for Header section
		//Ship From address from Warehouse Table
	
		//adw_bol.SetItem(1,"wh_code",  lds_bol_singleorder_header.GetitemString(1, "wh_code"))
		adw_bol.SetItem(1,"wh_name", lds_bol_singleorder_header.GetitemString(1, "wh_Name"))
		adw_bol.SetItem(1,"wh_addr1", lds_bol_singleorder_header.GetitemString(1,"wh_Addr1" ))  
		adw_bol.SetItem(1,"wh_addr2", lds_bol_singleorder_header.GetitemString(1,"wh_Addr2" ))   
		adw_bol.SetItem(1,"wh_addr3", lds_bol_singleorder_header.GetitemString(1,"wh_Addr3"))    
		adw_bol.SetItem(1,"wh_addr4", lds_bol_singleorder_header.GetitemString(1,"wh_Addr4" ))   
		adw_bol.SetItem(1,"wh_city", lds_bol_singleorder_header.GetitemString(1,"wh_City" ))  
		adw_bol.SetItem(1,"wh_state", lds_bol_singleorder_header.GetitemString(1,"wh_State" ))     
		adw_bol.SetItem(1,"wh_zip", lds_bol_singleorder_header.GetitemString(1,"wh_Zip" ))    
		
		//Ship To from Delivery_Master Table
		adw_bol.SetItem(1,"cust_code",  lds_bol_singleorder_header.GetitemString(1, "Cust_code"))
		adw_bol.SetItem(1,"cust_name", lds_bol_singleorder_header.GetitemString(1, "Cust_Name"))
		adw_bol.SetItem(1,"cust_addr1", lds_bol_singleorder_header.GetitemString(1,"Address_1" ))  
		adw_bol.SetItem(1,"cust_addr2", lds_bol_singleorder_header.GetitemString(1,"Address_2" ))   
		adw_bol.SetItem(1,"cust_addr3", lds_bol_singleorder_header.GetitemString(1,"Address_3"))    
		adw_bol.SetItem(1,"cust_addr4", lds_bol_singleorder_header.GetitemString(1,"Address_4" ))   
		adw_bol.SetItem(1,"cust_city", lds_bol_singleorder_header.GetitemString(1,"City" ))  
		adw_bol.SetItem(1,"cust_state", lds_bol_singleorder_header.GetitemString(1,"State" ))     
		adw_bol.SetItem(1,"cust_zip", lds_bol_singleorder_header.GetitemString(1,"Zip" ))    
		adw_bol.SetItem(1,"contact_person", lds_bol_singleorder_header.GetitemString(1,"Contact_person"  ))  
		adw_bol.SetItem(1,"tel", lds_bol_singleorder_header.GetitemString(1,"Tel"  ))  
		adw_bol.SetItem(1,"cust_country", lds_bol_singleorder_header.GetitemString(1,"Country"  ))  //13-Aug-2015 Madhu Added customer Country
		adw_bol.SetItem(1,"shipping_instr", lds_bol_singleorder_header.GetitemString(1,"shipping_instr"))  
		adw_bol.SetItem(1,"awb_bol_no", lds_bol_singleorder_header.GetitemString(1,"awb_bol_no"  ))  
		//adw_bol.SetItem(1,"consl_no", lds_bol_singleorder_header.GetitemString(1,"consolidation_no"  ))   //There won't be consolidation_no for single order
		adw_bol.SetItem(1,"trailer_no", lds_bol_singleorder_header.GetitemString(1,"Trailer_no"  ))  		 //DM.user_field2		
		adw_bol.SetItem(1,"pro_no", lds_bol_singleorder_header.GetitemString(1,"Carrier_Pro_No"  )) 	//DM.user_field7  Jxlim 04/02/2014 Replaced with carrier_pro_no name field
		adw_bol.SetItem(1,"scac", lds_bol_singleorder_header.GetitemString(1,"scac"  ))  					// Carrier_Master.Carrier_code first 4 digits
		adw_bol.SetItem(1,"Carrier", lds_bol_singleorder_header.GetitemString(1,"carrier"  ))  					// Carrier_Master.Carrier_code 
		adw_bol.SetItem(1,"Freight_Terms", lds_bol_singleorder_header.GetitemString(1,"Freight_Terms"  )) //Frieght_terms, X mark visible based on frieght_terms 		
		
		//for singleorder this should always be 1 row, who now friedrich will have multple cust code for one order
		//Order information--------------------------------------------------------------------------------------------------			
		If	ll_detailrowcount <=5 Then
			//For i = 1 to ll_detail_rowcount	
			For i = 1 to 	ll_detailrowcount
				If i = 1 Then
						ls_cust_ord_nbr1= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr1",ls_cust_ord_nbr1)
						
						ld_pack_qty1=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty1",ld_pack_qty1)
						
						ld_totalw1=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight1",ld_totalw1)
							
						ls_invoice_no1=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no1",ls_invoice_no1)
						
				ElseIf i = 2 Then
						ls_cust_ord_nbr2= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr2",ls_cust_ord_nbr2)
						
						ld_pack_qty2=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty2",ld_pack_qty2)
						
						ld_totalw2=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight2",ld_totalw2)
							
						ls_invoice_no2=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no2",ls_invoice_no2)
						
				ElseIf i = 3 Then
						ls_cust_ord_nbr3= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr3",ls_cust_ord_nbr3)
							
						ld_pack_qty3=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty3",ld_pack_qty3)
						
						ld_totalw3=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight3",ld_totalw3)
						
						ls_invoice_no3=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no3",ls_invoice_no3)		
						  
				ElseIf i = 4 Then
						ls_cust_ord_nbr4= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr",ls_cust_ord_nbr4)
						
						ld_pack_qty4=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty4",ld_pack_qty4)
						
						ld_totalw4=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight4",ld_totalw4)
						
						ls_invoice_no4=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no4",ls_invoice_no4)
				ElseIf i = 5 Then	
						ls_cust_ord_nbr5= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr2",ls_cust_ord_nbr2)
							
						ld_pack_qty5=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty5",ld_pack_qty5)
						
						ld_totalw5=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight5",ld_totalw5)
						
						ls_invoice_no5=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no5",ls_invoice_no5)				
				End if
			Next	
			//Total Qty and total Weight by Order number
			ld_total_pack_qty=  lds_bol_singleorder_detail.GetitemDecimal(1,"total_pack_qty")  //sum of total pack qty
			ld_total_pack_weight= lds_bol_singleorder_detail.GetitemDecimal(1,"total_pack_weight")  //sum of total weight
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child
			adw_bol.SetItem(1,"total_pack_qty",ld_total_pack_qty)
			adw_bol.SetItem(1,"total_pack_Weight",ld_total_pack_Weight)	
		End If
			
		//Carrier Information --NMFC--------------------------------------------------------------------------------------------------------------		
		If ll_nmfc_suplm_rowcount <= 5  Then					
			For i = 1 to ll_nmfc_suplm_rowcount	
			If i = 1 Then				
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count1",ll_carton_count1)
					ls_carton_type1= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")					
					adw_bol.SetItem(1,"carton_type1",ls_carton_type1)
					
					ld_Item_qty1= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty1",ld_item_qty1)
					
					ld_Weight1= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight1",ld_Weight1)
					
					ls_nmfcdescription1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription1",ls_nmfcdescription1)
					
					ls_nmfc1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc1",ls_nmfc1)
					
					ls_class1= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class1",ls_class1)
					
			ElseIf i = 2 Then		
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")					
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count2",ll_carton_count2)
					ls_carton_type2= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type2",ls_carton_type2)
					
					ld_Item_qty2= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty2",ld_item_qty2)
					
					ld_Weight2= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight2",ld_Weight2)
					
					ls_nmfcdescription2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription2",ls_nmfcdescription2)
					
					ls_nmfc2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc2",ls_nmfc2)
					
					ls_class2= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class2",ls_class2)
					
			ElseIf i = 3 Then
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count3",ll_carton_count3)
					ls_carton_type3= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type3",ls_carton_type3)
					
					ld_Item_qty3= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty3",ld_item_qty3)
					
					ld_Weight3= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight3",ld_Weight3)
					
					ls_nmfcdescription3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription3",ls_nmfcdescription3)
					
					ls_nmfc3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc3",ls_nmfc3)
					
					ls_class3= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class3",ls_class3)
					
			ElseIf i = 4 Then
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count4 =ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count4",ll_carton_count4)
					ls_carton_type4= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type4",ls_carton_type4)
					
					ld_Item_qty4= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty4",ld_item_qty4)
					
					ld_Weight4= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight4",ld_Weight4)
					
					ls_nmfcdescription4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription4",ls_nmfcdescription4)
					
					ls_nmfc4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc4",ls_nmfc4)
					
					ls_class4= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class4",ls_class4)
			ElseIf i = 5 Then
				//	ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count5",ll_carton_count5)
					ls_carton_type5= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type5",ls_carton_type5)
					
					ld_Item_qty5= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty5",ld_item_qty5)
					
					ld_Weight5= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight5",ld_Weight5)
					
					ls_nmfcdescription5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription5",ls_nmfcdescription5)
					
					ls_nmfc5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc5",ls_nmfc5)
					
					ls_class5= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class5",ls_class5)
				End if
			Next			
			//Total of all Number of carton from all orders group by carton_no with multiple Item. Examp one order with multiple line and multple NMFC pack together in one pallet
			//14-Aug-2015 :Madhu- Added code to print Carton and Pallet count separetly on BOL - START
			//ll_total_carton_count= ldwc_nmfcitem_suplm.GetitemNumber(1, "total_carton_count")  //14-Aug-2015 :Madhu commented
			//adw_bol.SetItem(1,"total_carton_count", ll_total_carton_count ) //14-Aug-2015 :Madhu commented
			FOR  row =1 to ldwc_nmfcitem_suplm.rowcount( )
				lscarton_type =ldwc_nmfcitem_suplm.GetitemString(row, "cf_carton_type")
				
				CHOOSE CASE Upper(lscarton_type)
					CASE 'PALLET', 'PL'
								ll_total_pallet_count += ldwc_nmfcitem_suplm.GetitemNumber(row, "cf_carton_countvisible")
								adw_bol.SetItem(1,"total_pallet_count", ll_total_pallet_count )
					CASE ELSE
								ll_total_carton_count += ldwc_nmfcitem_suplm.GetitemNumber(row, "cf_carton_countvisible")
								adw_bol.SetItem(1,"total_carton_count", ll_total_carton_count )				
					END CHOOSE
			Next
			
			// ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
			//14-Aug-2015 :Madhu- Added code to print Carton and Pallet count separetly on BOL - END
			
			//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
//			ls_carton_type= ldwc_nmfcitem_suplm.GetitemString(1, "carton_type")
//			adw_bol.SetItem(1,"carton_type",ls_carton_type)
			
			//Total Qty and total Weight by NMFC (Item_master)
			ld_total_item_qty=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_item_qty")
			adw_bol.SetItem(1,"total_item_qty",ld_total_item_qty)
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child			
			ld_total_net_w=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_net_w")
			adw_bol.SetItem(1,"total_net_w",ld_total_net_w)
		End If //NMFC 	
End If //End for external dw report
	
//Jxlim 12/19/2013 Friedrich Third party add on BOL is Bill To (BT address type)
//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss
DataStore lds_bol_alt_address
Long ll_alt_addr_count
lds_bol_alt_address = create datastore
lds_bol_alt_address.dataobject = 'd_do_address_alt'
lds_bol_alt_address.SetTransObject(SQLCA)
lds_bol_alt_address.Retrieve(as_dono, 'BT')  //as_dono asType=BT (Bill To for BOL) --3P is for Trax/Third Party
ll_alt_addr_count=lds_bol_alt_address.Rowcount()

//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss --BOL third party address uses Bill TO ('BT') address type			
		If	ll_alt_addr_count > 0 Then	
			adw_bol.SetItem(1, "alt_name", lds_bol_alt_address.GetItemString(1, "name"))		
			adw_bol.SetItem(1, "alt_addr1", lds_bol_alt_address.GetItemString(1, "address_1"))
			adw_bol.SetItem(1, "alt_addr2", lds_bol_alt_address.GetItemString(1, "address_2"))
			adw_bol.SetItem(1, "alt_addr3", lds_bol_alt_address.GetItemString(1, "address_3"))
			adw_bol.SetItem(1, "alt_addr4", lds_bol_alt_address.GetItemString(1, "address_4"))
			adw_bol.SetItem(1, "alt_city",    lds_bol_alt_address.GetItemString(1, "city"))
			adw_bol.SetItem(1, "alt_state",  lds_bol_alt_address.GetItemString(1, "state"))
			adw_bol.SetItem(1, "alt_zip",     lds_bol_alt_address.GetItemString(1, "zip"))
		End If

//If NMFC more than 5 rows print supplemental page
If 	ll_nmfc_suplm_rowcount > 5 Then
	adw_bol.SetItem(1, "nmfc_count",  ll_nmfc_suplm_rowcount)
   	lb_suplm = True
	//Print(lds_bol_suplm)	//no print dialog
	OpenWithParm(w_dw_print_options,lds_bol_suplm) //print dialog
End If

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetRedraw(true)

RETURN 1
end function

public function integer uf_process_bol_friedrich_combined (string as_dono, ref datawindow adw_bol);//Jxlim 12/10/2013 Freidrich Vics BOL up to 5 orders
//This is an external datawindow useb by manipulating datastores to produce a combine Vics BOL up to 5 detail/NMFC rows
//to fit into one single page of International standard Vics BOL.  (Strickly no extra page).  
//In the event that the order exist 5 rows, a supplement page will be created to handle this and it will be a separate code from this.
//This Vics BOL is officially name a Single page Vics BOL requested by Friedrich.
//This report contains:
//1. Header warehouse and order master, carrier from delivery_master and warehouse and Carrier_Master
//2. Third party address from Delivery_alt_address where address_type ='BT'
//Created a new datawindow for delivery alt address based on consolidation_no since we may have multiple do_no. 
//Baseline should be able to fulfill this however, 
//since we already have the consolidation_no variable within this code it is easier to just retrieve based on consolidation_no.
//The existing baseline third party address datawindow is based on do_no
//Customer Order Information and Carrier Information have to separate into 2 different query although they are source from the same table.
//This is because Customer detail required to group by order and Carrier information required to group by item.
//3. group by order: Order information detail from Delivery Master and Packing; and the weight is getting from item_master.weight_1
//--Total Packing Weight = Sum(Delivery_Packing.Qty * Item_Master.Weight_1)	
//4. group by NMFC: Carrier Information from Item_Master and Number of carton_no (count of carton_no) from delivery_packing 
//--Total item Weight = Sum(Delivery_Packing.Qty * Item_Master.Weight_1)	
//This is done through group by NMFC not carton_no
//If an order with 2 different NMFC code (2 Items) pack into one pallet together
//then the carton_no should show only 1 pallet this is done through group by carton_no
//supplmental detail and nmfc datawindow will be used regradless 5 or less orders in a shipment

Long   i, ll_consl_rowcount,	ll_detail_suplm_rowcount, ll_nmfc_suplm_rowcount, ll_detail_rowcount, ll_nmfc_rowcount, ll_alt_address_rowcount, ll_nmfc_carton_rowcount
Long   ll_carton_count1, ll_carton_count2,ll_carton_count3,ll_carton_count4,ll_carton_count5,ll_total_carton_count,ll_bol_suplm
String ls_custcode,ls_custname, ls_carton_type
Decimal ld_Pack_qty1,ld_Pack_qty2,ld_Pack_qty3,ld_Pack_qty4,ld_Pack_qty5
Decimal ld_total_item_qty, ld_total_pack_qty
Decimal ld_weight1,ld_weight2,ld_weight3,ld_weight4,ld_weight5, ld_total_net_w, ld_total_pack_weight
Decimal ld_totalw1, ld_totalw2,ld_totalw3,ld_totalw4,ld_totalw5
String ls_carton_type1,ls_carton_type2,ls_carton_type3,ls_carton_type4,ls_carton_type5
String ls_nmfcdescription1, ls_nmfcdescription2,ls_nmfcdescription3,ls_nmfcdescription4,ls_nmfcdescription5, ls_nmfc1,ls_nmfc2,ls_nmfc3,ls_nmfc4,ls_nmfc5
String ls_class1,ls_class2,ls_class3,ls_class4,ls_class5
String ls_cust_ord_nbr1,ls_cust_ord_nbr2,ls_cust_ord_nbr3,ls_cust_ord_nbr4,ls_cust_ord_nbr5
String ls_invoice_no1, ls_invoice_no2,  ls_invoice_no3, ls_invoice_no4, ls_invoice_no5
Decimal ld_item_qty1,ld_item_qty2,ld_item_qty3,ld_item_qty4,ld_item_qty5
Datawindowchild ldwc_detail_suplm,ldwc_nmfcitem_suplm
Boolean lb_suplm

n_warehouse l_nwarehouse  //Jxlim 07/08/2013 SSCC fo BOL and VICS
l_nwarehouse		= Create n_warehouse

lb_suplm=False

//03-Jan-2014 :Madhu -Added code to verify whether all serial no's are scanned? -START
Long 	llpackqty,llscannedqty ,llserialcnt,lleligiblecnt

//get eligible records for scanning
// TAM 2014/01/15 - Changed from Count to Sum.  Not all items are scannable and we only want to compare the number of Scannable with the number of serials
//select count(*) into :lleligiblecnt from Delivery_Packing,Item_Master
select sum(Quantity) into :lleligiblecnt from Delivery_Packing,Item_Master
where Delivery_Packing.SKU = Item_Master.SKU
and Delivery_Packing.DO_No= :as_dono
and Item_Master.Serialized_Ind in ('Y','B')
using SQLCA;

If lleligiblecnt >0 Then
//TAM	Select sum(Quantity) into :llpackqty from Delivery_Packing where Do_No =:as_dono using SQLCA;
	Select Sum(quantity) into :llScannedQty from delivery_serial_detail Where Id_no in (select id_no from delivery_picking_detail where do_no = :as_dono) using SQLCA;
	
	If IsNull(llScannedQty) then 
		llScannedQty =0 
	end if
	
//TAM 	If llpackqty <> llScannedQty Then
	If lleligiblecnt <> llScannedQty Then
		MessageBox(w_do.is_title,"All Serial no's are not being scanned. Please check.",Stopsign!)
		Return 0
	End if 
End if 

//03-Jan-2014 :Madhu - Added code to verify whether all serial no's are scanned? -END

//Jxlim; Created data store to Retrieve report contains, then get the value from this datastore to set it to ext dw
Datastore  lds_bol_suplm,lds_bol_combine_header, lds_bol_combine_alt_address
Datastore  lds_nmfc_carton_count, ldwc_detail_suplm_suplm

//Jxlim; may not need this datastore but for now 
//Datastore for Report header section
lds_bol_combine_header = create datastore
lds_bol_combine_header.dataobject = 'd_vics_bol_prt_combined_header'
lds_bol_combine_header.SetTransObject(SQLCA)
lds_bol_combine_header.Retrieve(gs_project, as_dono)
ll_consl_rowcount = lds_bol_combine_header.Rowcount()

//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss
lds_bol_combine_alt_address = create datastore
lds_bol_combine_alt_address.dataobject = 'd_vics_bol_prt_combined_alt_address'
lds_bol_combine_alt_address.SetTransObject(SQLCA)
lds_bol_combine_alt_address.Retrieve(gs_project, as_dono, 'BT')  //as_dono(consolidation No) asType=BT (Bill To for BOL) --3P is for Trax/Third Party
ll_alt_address_rowcount=lds_bol_combine_alt_address.Rowcount()

lds_bol_suplm = Create datastore
lds_bol_suplm.dataobject = 'd_vics_bol_prt_combined_suplm_composite_rpt'

lds_bol_suplm.GetChild('dw_detail_suplm', ldwc_detail_suplm)
ldwc_detail_suplm.SetTransObject(SQLCA)	
ldwc_detail_suplm.Retrieve(gs_project, as_dono)
ll_detail_suplm_rowcount=ldwc_detail_suplm.RowCount()

lds_bol_suplm.GetChild('dw_nmfcitem_suplm', ldwc_nmfcitem_suplm)
ldwc_nmfcitem_suplm.SetTransObject(SQLCA)	
ldwc_nmfcitem_suplm.Retrieve(gs_project, as_dono)
ll_nmfc_suplm_rowcount=ldwc_nmfcitem_suplm.Rowcount()


//Jxlim Insert row to begin for external dw
adw_bol.InsertRow(0)
//Header Info
		//Using  lds_bol_combine_header datastore for Header section
		//Ship From address from Warehouse Table
	
		//adw_bol.SetItem(1,"wh_code",  lds_bol_combine_header.GetitemString(1, "wh_code"))
		adw_bol.SetItem(1,"wh_name", lds_bol_combine_header.GetitemString(1, "wh_Name"))
		adw_bol.SetItem(1,"wh_addr1", lds_bol_combine_header.GetitemString(1,"wh_Addr1" ))  
		adw_bol.SetItem(1,"wh_addr2", lds_bol_combine_header.GetitemString(1,"wh_Addr2" ))   
		adw_bol.SetItem(1,"wh_addr3", lds_bol_combine_header.GetitemString(1,"wh_Addr3"))    
		adw_bol.SetItem(1,"wh_addr4", lds_bol_combine_header.GetitemString(1,"wh_Addr4" ))   
		adw_bol.SetItem(1,"wh_city", lds_bol_combine_header.GetitemString(1,"wh_City" ))  
		adw_bol.SetItem(1,"wh_state", lds_bol_combine_header.GetitemString(1,"wh_State" ))     
		adw_bol.SetItem(1,"wh_zip", lds_bol_combine_header.GetitemString(1,"wh_Zip" ))    
		
		//Ship To from Delivery_Master Table
		adw_bol.SetItem(1,"cust_code",  lds_bol_combine_header.GetitemString(1, "Cust_code"))
		adw_bol.SetItem(1,"cust_name", lds_bol_combine_header.GetitemString(1, "Cust_Name"))
		adw_bol.SetItem(1,"cust_addr1", lds_bol_combine_header.GetitemString(1,"Address_1" ))  
		adw_bol.SetItem(1,"cust_addr2", lds_bol_combine_header.GetitemString(1,"Address_2" ))   
		adw_bol.SetItem(1,"cust_addr3", lds_bol_combine_header.GetitemString(1,"Address_3"))    
		adw_bol.SetItem(1,"cust_addr4", lds_bol_combine_header.GetitemString(1,"Address_4" ))   
		adw_bol.SetItem(1,"cust_city", lds_bol_combine_header.GetitemString(1,"City" ))  
		adw_bol.SetItem(1,"cust_state", lds_bol_combine_header.GetitemString(1,"State" ))     
		adw_bol.SetItem(1,"cust_zip", lds_bol_combine_header.GetitemString(1,"Zip" ))    
		adw_bol.SetItem(1,"cust_country", lds_bol_combine_header.GetitemString(1,"Country"  ))  //29-Sep-2015 Madhu Added customer Country
		adw_bol.SetItem(1,"contact_person", lds_bol_combine_header.GetitemString(1,"Contact_person"  ))  
		adw_bol.SetItem(1,"tel", lds_bol_combine_header.GetitemString(1,"Tel"  ))  
		adw_bol.SetItem(1,"shipping_instr", lds_bol_combine_header.GetitemString(1,"shipping_instr"))  
		adw_bol.SetItem(1,"awb_bol_no", lds_bol_combine_header.GetitemString(1,"awb_bol_no"  ))  
		adw_bol.SetItem(1,"consl_no", lds_bol_combine_header.GetitemString(1,"consolidation_no"  ))  
		adw_bol.SetItem(1,"trailer_no", lds_bol_combine_header.GetitemString(1,"Trailer_no"  ))  		 //DM.user_field2
		adw_bol.SetItem(1,"pro_no", lds_bol_combine_header.GetitemString(1,"Carrier_Pro_No"  )) 	//DM.user_field7  Jxlim 04/02/2014 Replaced with carrier_pro_no name field
		adw_bol.SetItem(1,"scac", lds_bol_combine_header.GetitemString(1,"scac"  ))  					// Carrier_Master.Carrier_code first 4 digits
		adw_bol.SetItem(1,"Freight_Terms", lds_bol_combine_header.GetitemString(1,"Freight_Terms"  )) //Frieght_terms, X mark visible based on frieght_terms 		
		
		//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss --BOL third party address uses Bill TO ('BT') address type			
		If	ll_alt_address_rowcount > 0 Then	
			adw_bol.SetItem(1, "alt_name", lds_bol_combine_alt_address.GetItemString(1, "name"))		
			adw_bol.SetItem(1, "alt_addr1", lds_bol_combine_alt_address.GetItemString(1, "address_1"))
			adw_bol.SetItem(1, "alt_addr2", lds_bol_combine_alt_address.GetItemString(1, "address_2"))
			adw_bol.SetItem(1, "alt_addr3", lds_bol_combine_alt_address.GetItemString(1, "address_3"))
			adw_bol.SetItem(1, "alt_addr4", lds_bol_combine_alt_address.GetItemString(1, "address_4"))
			adw_bol.SetItem(1, "alt_city",    lds_bol_combine_alt_address.GetItemString(1, "city"))
			adw_bol.SetItem(1, "alt_state",  lds_bol_combine_alt_address.GetItemString(1, "state"))
			adw_bol.SetItem(1, "alt_zip",     lds_bol_combine_alt_address.GetItemString(1, "zip"))
		End If

//Print supplementan page if more than 5 orders
If ll_consl_rowcount  > 5 Then //Print supplementan page
	adw_bol.SetItem(1, "order_count",  ll_detail_suplm_rowcount)
	lb_suplm= True
Else
	lb_suplm= False
End If

If lb_suplm = False and ll_nmfc_suplm_rowcount > 5 Then
	adw_bol.SetItem(1, "nmfc_count",  ll_nmfc_suplm_rowcount)
	lb_suplm = True		
Else
	//Detail order Information--------------------------------------------------------------------------------------------------------------	
	If	ll_detail_suplm_rowcount <=5 Then
			//For i = 1 to ll_detail_rowcount	
			For i = 1 to 	ll_detail_suplm_rowcount
				If i = 1 Then
						ls_cust_ord_nbr1= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr1",ls_cust_ord_nbr1)
						
						ld_pack_qty1=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty1",ld_pack_qty1)
						
						ld_totalw1=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight1",ld_totalw1)
							
						ls_invoice_no1=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no1",ls_invoice_no1)
						
				ElseIf i = 2 Then
						ls_cust_ord_nbr2= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr2",ls_cust_ord_nbr2)
						
						ld_pack_qty2=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty2",ld_pack_qty2)
						
						ld_totalw2=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight2",ld_totalw2)
							
						ls_invoice_no2=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no2",ls_invoice_no2)
						
				ElseIf i = 3 Then
						ls_cust_ord_nbr3= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr3",ls_cust_ord_nbr3)
							
						ld_pack_qty3=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty3",ld_pack_qty3)
						
						ld_totalw3=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight3",ld_totalw3)
						
						ls_invoice_no3=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no3",ls_invoice_no3)		
						  
				ElseIf i = 4 Then
						ls_cust_ord_nbr4= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr4",ls_cust_ord_nbr4)
						
						ld_pack_qty4=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty4",ld_pack_qty4)
						
						ld_totalw4=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight4",ld_totalw4)
						
						ls_invoice_no4=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no4",ls_invoice_no4)
						
				ElseIf i = 5 Then	
						ls_cust_ord_nbr5= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr5",ls_cust_ord_nbr2)
							
						ld_pack_qty5=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty5",ld_pack_qty5)
						
						ld_totalw5=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight5",ld_totalw5)
						
						ls_invoice_no5=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no5",ls_invoice_no5)				
				End if
			Next	
			//Total Qty and total Weight by Order number
			ld_total_pack_qty=  ldwc_detail_suplm.GetitemDecimal(1,"total_pack_qty")  //sum of total pack qty
			ld_total_pack_weight= ldwc_detail_suplm.GetitemDecimal(1,"total_pack_weight")  //sum of total weight
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child
			adw_bol.SetItem(1,"total_pack_qty",ld_total_pack_qty)
			adw_bol.SetItem(1,"total_pack_Weight",ld_total_pack_Weight)	
		End If
	
		//Carrier Information --NMFC--------------------------------------------------------------------------------------------------------------		
		If ll_nmfc_suplm_rowcount <=5  Then					
			For i = 1 to ll_nmfc_suplm_rowcount	
			If i = 1 Then					
					ld_Item_qty1= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty1",ld_item_qty1)
					
					ld_Weight1= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight1",ld_Weight1)
					
					ls_nmfcdescription1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription1",ls_nmfcdescription1)
					
					ls_nmfc1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc1",ls_nmfc1)
					
					ls_class1= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class1",ls_class1)						
				
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count1",ll_carton_count1)
					ls_carton_type1= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")	
					adw_bol.SetItem(1,"carton_type1",ls_carton_type1)			
					
			ElseIf i = 2 Then		
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count2",ll_carton_count2)
					ls_carton_type2= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type2",ls_carton_type2)
					
					ld_Item_qty2= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty2",ld_item_qty2)
					
					ld_Weight2= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight2",ld_Weight2)
					
					ls_nmfcdescription2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription2",ls_nmfcdescription2)
					
					ls_nmfc2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc2",ls_nmfc2)
					
					ls_class2= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class2",ls_class2)
					
			ElseIf i = 3 Then
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count3",ll_carton_count3)
					ls_carton_type3= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type3",ls_carton_type3)
					
					ld_Item_qty3= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty3",ld_item_qty3)
					
					ld_Weight3= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight3",ld_Weight3)
					
					ls_nmfcdescription3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription3",ls_nmfcdescription3)
					
					ls_nmfc3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc3",ls_nmfc3)
					
					ls_class3= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class3",ls_class3)
					
			ElseIf i = 4 Then
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count4",ll_carton_count4)
					ls_carton_type4= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type4",ls_carton_type4)
					
					ld_Item_qty4= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty4",ld_item_qty4)
					
					ld_Weight4= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight4",ld_Weight4)
					
					ls_nmfcdescription4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription4",ls_nmfcdescription4)
					
					ls_nmfc4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc4",ls_nmfc4)
					
					ls_class4= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class4",ls_class4)
			ElseIf i = 5 Then
				//	ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")				
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count5",ll_carton_count5)
					ls_carton_type5= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type5",ls_carton_type5)
					
					ld_Item_qty5= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty5",ld_item_qty5)
					
					ld_Weight5= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight5",ld_Weight5)
					
					ls_nmfcdescription5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription5",ls_nmfcdescription5)
					
					ls_nmfc5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc5",ls_nmfc5)
					
					ls_class5= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class5",ls_class5)
				End if
			Next			
			//Total of all Number of carton from all orders group by carton_no with multiple Item. Examp one order with multiple line and multple NMFC pack together in one pallet
			ll_total_carton_count= ldwc_nmfcitem_suplm.GetitemNumber(1, "total_carton_count") 
			adw_bol.SetItem(1,"total_carton_count", ll_total_carton_count )
			
//			//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
//			ls_carton_type= ldwc_nmfcitem_suplm.GetitemString(1, "carton_type")
//			adw_bol.SetItem(1,"carton_type",ls_carton_type)
//			
			//Total Qty and total Weight by NMFC (Item_master)
			ld_total_item_qty=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_item_qty")
			adw_bol.SetItem(1,"total_item_qty",ld_total_item_qty)
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child			
			ld_total_net_w=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_net_w")
			adw_bol.SetItem(1,"total_net_w",ld_total_net_w)
		End If //NMFC 
End If

If lb_suplm = True Then
	//Print(lds_bol_suplm)	//no print dialog
	OpenWithParm(w_dw_print_options,lds_bol_suplm) //print dialog
End If
	
If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetRedraw(true)

RETURN 1
end function

public function integer uf_process_bol_friedrich_singleorder (string as_dono, ref datawindow adw_bol);//Jxlim 12/26/2013 Vics bol for single order
//For single order with single NMFC code use inline report query (d_vics_bol_prt_singleorder)
//For single order with multple NMFC code use external datawindow report and:
//1. Write the information line by line up to 5 rows
//2. If more than 5 NMFC code on a single order then print Carrier Information supplemental page
Long   i, ll_bol_rowcount,ll_detailrowcount, ll_nmfc_suplm_rowcount, ll_detail_rowcount, ll_nmfc_rowcount, ll_alt_address_rowcount, ll_nmfc_carton_rowcount
Long   ll_carton_count1, ll_carton_count2,ll_carton_count3,ll_carton_count4,ll_carton_count5,ll_total_carton_count,ll_bol_suplm
String ls_custcode,ls_custname, ls_carton_type
Decimal ld_Pack_qty1,ld_Pack_qty2,ld_Pack_qty3,ld_Pack_qty4,ld_Pack_qty5
Decimal ld_total_item_qty, ld_total_pack_qty
Decimal ld_weight1,ld_weight2,ld_weight3,ld_weight4,ld_weight5, ld_total_net_w, ld_total_pack_weight
Decimal ld_totalw1, ld_totalw2,ld_totalw3,ld_totalw4,ld_totalw5
String ls_carton_type1, ls_carton_type2, ls_carton_type3, ls_carton_type4, ls_carton_type5
String ls_nmfcdescription1, ls_nmfcdescription2,ls_nmfcdescription3,ls_nmfcdescription4,ls_nmfcdescription5, ls_nmfc1,ls_nmfc2,ls_nmfc3,ls_nmfc4,ls_nmfc5
String ls_class1,ls_class2,ls_class3,ls_class4,ls_class5
String ls_cust_ord_nbr1,ls_cust_ord_nbr2,ls_cust_ord_nbr3,ls_cust_ord_nbr4,ls_cust_ord_nbr5
String ls_invoice_no1, ls_invoice_no2,  ls_invoice_no3, ls_invoice_no4, ls_invoice_no5
Decimal ld_item_qty1,ld_item_qty2,ld_item_qty3,ld_item_qty4,ld_item_qty5
DataStore lds_bol_singleorder_header,lds_bol_singleorder_detail
Boolean lb_suplm

lb_suplm = False

//03-Jan-2014 :Madhu -Added code to verify whether all serial no's are scanned? -START
Long 	llpackqty,llscannedqty ,llserialcnt,lleligiblecnt

//get eligible records for scanning
// TAM 2014/01/15 - Changed from Count to Sum.  Not all items are scannable and we only want to compare the number of Scannable with the number of serials
//select count(*) into :lleligiblecnt from Delivery_Packing,Item_Master
select sum(Quantity) into :lleligiblecnt from Delivery_Packing,Item_Master
where Delivery_Packing.SKU = Item_Master.SKU
and Delivery_Packing.DO_No= :as_dono
and Delivery_Packing.Supp_Code=Item_Master.Supp_Code
and Item_Master.Serialized_Ind in ('Y','B')
using SQLCA;

If lleligiblecnt >0 Then
//TAM	Select sum(Quantity) into :llpackqty from Delivery_Packing where Do_No =:as_dono using SQLCA;
	Select Sum(quantity) into :llScannedQty from delivery_serial_detail Where Id_no in (select id_no from delivery_picking_detail where do_no = :as_dono) using SQLCA;
	
	If IsNull(llScannedQty) then 
		llScannedQty =0 
	end if
	
// TAM	If llpackqty <> llScannedQty Then
	If lleligiblecnt <> llScannedQty Then
		MessageBox(w_do.is_title,"All Serial no's are not being scanned. Please check.",Stopsign!)
		Return 0
	End if 
End if 

//03-Jan-2014 :Madhu - Added code to verify whether all serial no's are scanned? -END

//Datastore for Report header section
lds_bol_singleorder_header = create datastore
lds_bol_singleorder_header.dataobject = 'd_vics_bol_prt_singleorder_header'
lds_bol_singleorder_header.SetTransObject(SQLCA)
lds_bol_singleorder_header.Retrieve(gs_project, as_dono)

//Datastore for Report header section
lds_bol_singleorder_detail = create datastore
lds_bol_singleorder_detail.dataobject = 'd_vics_bol_prt_singleorder_detail'
lds_bol_singleorder_detail.SetTransObject(SQLCA)
lds_bol_singleorder_detail.Retrieve(gs_project, as_dono)
ll_detailrowcount=lds_bol_singleorder_detail.rowcount()

//Suplemental page
DatawindowChild ldwc_nmfcitem_suplm
Datastore lds_bol_suplm
lds_bol_suplm = Create datastore
lds_bol_suplm.dataobject = 'd_vics_bol_prt_singleorder_suplm_composite_rpt'   //composite report

lds_bol_suplm.GetChild('dw_single_nmfcitem_suplm', ldwc_nmfcitem_suplm)
ldwc_nmfcitem_suplm.SetTransObject(SQLCA)	
ldwc_nmfcitem_suplm.Retrieve(gs_project, as_dono)
ll_nmfc_suplm_rowcount=ldwc_nmfcitem_suplm.Rowcount()

adw_bol.SetTransObject(SQLCA)
adw_bol.Retrieve(gs_project, as_dono) 
ll_bol_rowcount= adw_bol.Rowcount()

//If more than 1 row use external dw otherwise use inline sql on report (d_vics_bol_prt_singleorder)
If ll_bol_rowcount > 1 Then 
	adw_bol.dataobject = 'd_friedrich_bol_prt_combine_ext'
	//Jxlim Insert row to begin for external dw
	adw_bol.InsertRow(0)
	//Header Info
		//Using  lds_bol_singleorder_header datastore for Header section
		//Ship From address from Warehouse Table
	
		//adw_bol.SetItem(1,"wh_code",  lds_bol_singleorder_header.GetitemString(1, "wh_code"))
		adw_bol.SetItem(1,"wh_name", lds_bol_singleorder_header.GetitemString(1, "wh_Name"))
		adw_bol.SetItem(1,"wh_addr1", lds_bol_singleorder_header.GetitemString(1,"wh_Addr1" ))  
		adw_bol.SetItem(1,"wh_addr2", lds_bol_singleorder_header.GetitemString(1,"wh_Addr2" ))   
		adw_bol.SetItem(1,"wh_addr3", lds_bol_singleorder_header.GetitemString(1,"wh_Addr3"))    
		adw_bol.SetItem(1,"wh_addr4", lds_bol_singleorder_header.GetitemString(1,"wh_Addr4" ))   
		adw_bol.SetItem(1,"wh_city", lds_bol_singleorder_header.GetitemString(1,"wh_City" ))  
		adw_bol.SetItem(1,"wh_state", lds_bol_singleorder_header.GetitemString(1,"wh_State" ))     
		adw_bol.SetItem(1,"wh_zip", lds_bol_singleorder_header.GetitemString(1,"wh_Zip" ))    
		
		//Ship To from Delivery_Master Table
		adw_bol.SetItem(1,"cust_code",  lds_bol_singleorder_header.GetitemString(1, "Cust_code"))
		adw_bol.SetItem(1,"cust_name", lds_bol_singleorder_header.GetitemString(1, "Cust_Name"))
		adw_bol.SetItem(1,"cust_addr1", lds_bol_singleorder_header.GetitemString(1,"Address_1" ))  
		adw_bol.SetItem(1,"cust_addr2", lds_bol_singleorder_header.GetitemString(1,"Address_2" ))   
		adw_bol.SetItem(1,"cust_addr3", lds_bol_singleorder_header.GetitemString(1,"Address_3"))    
		adw_bol.SetItem(1,"cust_addr4", lds_bol_singleorder_header.GetitemString(1,"Address_4" ))   
		adw_bol.SetItem(1,"cust_city", lds_bol_singleorder_header.GetitemString(1,"City" ))  
		adw_bol.SetItem(1,"cust_state", lds_bol_singleorder_header.GetitemString(1,"State" ))     
		adw_bol.SetItem(1,"cust_zip", lds_bol_singleorder_header.GetitemString(1,"Zip" ))    
		adw_bol.SetItem(1,"contact_person", lds_bol_singleorder_header.GetitemString(1,"Contact_person"  ))  
		adw_bol.SetItem(1,"tel", lds_bol_singleorder_header.GetitemString(1,"Tel"  ))  
		adw_bol.SetItem(1,"cust_country", lds_bol_singleorder_header.GetitemString(1,"Country"  ))  //07-Apr-2015 Madhu Added customer Country
		adw_bol.SetItem(1,"shipping_instr", lds_bol_singleorder_header.GetitemString(1,"shipping_instr"))  
		adw_bol.SetItem(1,"awb_bol_no", lds_bol_singleorder_header.GetitemString(1,"awb_bol_no"  ))  
		//adw_bol.SetItem(1,"consl_no", lds_bol_singleorder_header.GetitemString(1,"consolidation_no"  ))   //There won't be consolidation_no for single order
		adw_bol.SetItem(1,"trailer_no", lds_bol_singleorder_header.GetitemString(1,"Trailer_no"  ))  		 //DM.user_field2		
		adw_bol.SetItem(1,"pro_no", lds_bol_singleorder_header.GetitemString(1,"Carrier_Pro_No"  )) 	//DM.user_field7  Jxlim 04/02/2014 Replaced with carrier_pro_no name field
		adw_bol.SetItem(1,"scac", lds_bol_singleorder_header.GetitemString(1,"scac"  ))  					// Carrier_Master.Carrier_code first 4 digits
		adw_bol.SetItem(1,"Carrier", lds_bol_singleorder_header.GetitemString(1,"carrier"  ))  					// Carrier_Master.Carrier_code 
		adw_bol.SetItem(1,"Freight_Terms", lds_bol_singleorder_header.GetitemString(1,"Freight_Terms"  )) //Frieght_terms, X mark visible based on frieght_terms 		
		
		//for singleorder this should always be 1 row, who now friedrich will have multple cust code for one order
		//Order information--------------------------------------------------------------------------------------------------			
		If	ll_detailrowcount <=5 Then
			//For i = 1 to ll_detail_rowcount	
			For i = 1 to 	ll_detailrowcount
				If i = 1 Then
						ls_cust_ord_nbr1= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr1",ls_cust_ord_nbr1)
						
						ld_pack_qty1=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty1",ld_pack_qty1)
						
						ld_totalw1=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight1",ld_totalw1)
							
						ls_invoice_no1=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no1",ls_invoice_no1)
						
				ElseIf i = 2 Then
						ls_cust_ord_nbr2= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr2",ls_cust_ord_nbr2)
						
						ld_pack_qty2=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty2",ld_pack_qty2)
						
						ld_totalw2=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight2",ld_totalw2)
							
						ls_invoice_no2=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no2",ls_invoice_no2)
						
				ElseIf i = 3 Then
						ls_cust_ord_nbr3= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr3",ls_cust_ord_nbr3)
							
						ld_pack_qty3=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty3",ld_pack_qty3)
						
						ld_totalw3=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight3",ld_totalw3)
						
						ls_invoice_no3=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no3",ls_invoice_no3)		
						  
				ElseIf i = 4 Then
						ls_cust_ord_nbr4= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr",ls_cust_ord_nbr4)
						
						ld_pack_qty4=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty4",ld_pack_qty4)
						
						ld_totalw4=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight4",ld_totalw4)
						
						ls_invoice_no4=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no4",ls_invoice_no4)
				ElseIf i = 5 Then	
						ls_cust_ord_nbr5= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr2",ls_cust_ord_nbr2)
							
						ld_pack_qty5=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty5",ld_pack_qty5)
						
						ld_totalw5=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight5",ld_totalw5)
						
						ls_invoice_no5=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no5",ls_invoice_no5)				
				End if
			Next	
			//Total Qty and total Weight by Order number
			ld_total_pack_qty=  lds_bol_singleorder_detail.GetitemDecimal(1,"total_pack_qty")  //sum of total pack qty
			ld_total_pack_weight= lds_bol_singleorder_detail.GetitemDecimal(1,"total_pack_weight")  //sum of total weight
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child
			adw_bol.SetItem(1,"total_pack_qty",ld_total_pack_qty)
			adw_bol.SetItem(1,"total_pack_Weight",ld_total_pack_Weight)	
		End If
			
		//Carrier Information --NMFC--------------------------------------------------------------------------------------------------------------		
		If ll_nmfc_suplm_rowcount <= 5  Then
			For i = 1 to ll_nmfc_suplm_rowcount	
			If i = 1 Then				
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count1",ll_carton_count1)
					ls_carton_type1= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")					
					adw_bol.SetItem(1,"carton_type1",ls_carton_type1)
					
					ld_Item_qty1= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty1",ld_item_qty1)
					
					ld_Weight1= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight1",ld_Weight1)
					
					ls_nmfcdescription1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription1",ls_nmfcdescription1)
					
					ls_nmfc1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc1",ls_nmfc1)
					
					ls_class1= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class1",ls_class1)
					
			ElseIf i = 2 Then		
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")					
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count2",ll_carton_count2)
					ls_carton_type2= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type2",ls_carton_type2)
					
					ld_Item_qty2= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty2",ld_item_qty2)
					
					ld_Weight2= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight2",ld_Weight2)
					
					ls_nmfcdescription2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription2",ls_nmfcdescription2)
					
					ls_nmfc2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc2",ls_nmfc2)
					
					ls_class2= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class2",ls_class2)
					
			ElseIf i = 3 Then
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count3",ll_carton_count3)
					ls_carton_type3= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type3",ls_carton_type3)
					
					ld_Item_qty3= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty3",ld_item_qty3)
					
					ld_Weight3= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight3",ld_Weight3)
					
					ls_nmfcdescription3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription3",ls_nmfcdescription3)
					
					ls_nmfc3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc3",ls_nmfc3)
					
					ls_class3= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class3",ls_class3)
					
			ElseIf i = 4 Then
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count4 =ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count4",ll_carton_count4)
					ls_carton_type4= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type4",ls_carton_type4)
					
					ld_Item_qty4= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty4",ld_item_qty4)
					
					ld_Weight4= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight4",ld_Weight4)
					
					ls_nmfcdescription4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription4",ls_nmfcdescription4)
					
					ls_nmfc4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc4",ls_nmfc4)
					
					ls_class4= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class4",ls_class4)
			ElseIf i = 5 Then
				//	ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count5",ll_carton_count5)
					ls_carton_type5= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type5",ls_carton_type5)
					
					ld_Item_qty5= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty5",ld_item_qty5)
					
					ld_Weight5= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight5",ld_Weight5)
					
					ls_nmfcdescription5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription5",ls_nmfcdescription5)
					
					ls_nmfc5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc5",ls_nmfc5)
					
					ls_class5= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class5",ls_class5)
				End if
			Next			
			//Total of all Number of carton from all orders group by carton_no with multiple Item. Examp one order with multiple line and multple NMFC pack together in one pallet
			ll_total_carton_count= ldwc_nmfcitem_suplm.GetitemNumber(1, "total_carton_count") 
			adw_bol.SetItem(1,"total_carton_count", ll_total_carton_count )
			
			//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
//			ls_carton_type= ldwc_nmfcitem_suplm.GetitemString(1, "carton_type")
//			adw_bol.SetItem(1,"carton_type",ls_carton_type)
			
			//Total Qty and total Weight by NMFC (Item_master)
			ld_total_item_qty=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_item_qty")
			adw_bol.SetItem(1,"total_item_qty",ld_total_item_qty)
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child			
			ld_total_net_w=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_net_w")
			adw_bol.SetItem(1,"total_net_w",ld_total_net_w)
		End If //NMFC 	
End If //End for external dw report
	
//Jxlim 12/19/2013 Friedrich Third party add on BOL is Bill To (BT address type)
//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss
DataStore lds_bol_alt_address
Long ll_alt_addr_count
lds_bol_alt_address = create datastore
lds_bol_alt_address.dataobject = 'd_do_address_alt'
lds_bol_alt_address.SetTransObject(SQLCA)
lds_bol_alt_address.Retrieve(as_dono, 'BT')  //as_dono asType=BT (Bill To for BOL) --3P is for Trax/Third Party
ll_alt_addr_count=lds_bol_alt_address.Rowcount()

//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss --BOL third party address uses Bill TO ('BT') address type			
		If	ll_alt_addr_count > 0 Then	
			adw_bol.SetItem(1, "alt_name", lds_bol_alt_address.GetItemString(1, "name"))		
			adw_bol.SetItem(1, "alt_addr1", lds_bol_alt_address.GetItemString(1, "address_1"))
			adw_bol.SetItem(1, "alt_addr2", lds_bol_alt_address.GetItemString(1, "address_2"))
			adw_bol.SetItem(1, "alt_addr3", lds_bol_alt_address.GetItemString(1, "address_3"))
			adw_bol.SetItem(1, "alt_addr4", lds_bol_alt_address.GetItemString(1, "address_4"))
			adw_bol.SetItem(1, "alt_city",    lds_bol_alt_address.GetItemString(1, "city"))
			adw_bol.SetItem(1, "alt_state",  lds_bol_alt_address.GetItemString(1, "state"))
			adw_bol.SetItem(1, "alt_zip",     lds_bol_alt_address.GetItemString(1, "zip"))
		End If

//If NMFC more than 5 rows print supplemental page
If 	ll_nmfc_suplm_rowcount > 5 Then
	adw_bol.SetItem(1, "nmfc_count",  ll_nmfc_suplm_rowcount)
   	lb_suplm = True
	//Print(lds_bol_suplm)	//no print dialog
	OpenWithParm(w_dw_print_options,lds_bol_suplm) //print dialog
End If

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetRedraw(true)

RETURN 1
end function

public function integer uf_process_bol_baseline_singleorder (string as_dono, ref datawindow adw_bol);//Jxlim 12/26/2013 Vics bol for single order
//For single order with single NMFC code use inline report query (d_vics_bol_prt_singleorder)
//For single order with multple NMFC code use external datawindow report and:
//1. Write the information line by line up to 5 rows
//2. If more than 5 NMFC code on a single order then print Carrier Information supplemental page
Long   i, ll_bol_rowcount,ll_detailrowcount, ll_nmfc_suplm_rowcount, ll_detail_rowcount, ll_nmfc_rowcount, ll_alt_address_rowcount, ll_nmfc_carton_rowcount
Long   ll_carton_count1, ll_carton_count2,ll_carton_count3,ll_carton_count4,ll_carton_count5,ll_total_carton_count,ll_bol_suplm
String ls_custcode,ls_custname, ls_carton_type
Decimal ld_Pack_qty1,ld_Pack_qty2,ld_Pack_qty3,ld_Pack_qty4,ld_Pack_qty5
Decimal ld_total_item_qty, ld_total_pack_qty
Decimal ld_weight1,ld_weight2,ld_weight3,ld_weight4,ld_weight5, ld_total_net_w, ld_total_pack_weight
Decimal ld_totalw1, ld_totalw2,ld_totalw3,ld_totalw4,ld_totalw5
String ls_carton_type1, ls_carton_type2, ls_carton_type3, ls_carton_type4, ls_carton_type5
String ls_nmfcdescription1, ls_nmfcdescription2,ls_nmfcdescription3,ls_nmfcdescription4,ls_nmfcdescription5, ls_nmfc1,ls_nmfc2,ls_nmfc3,ls_nmfc4,ls_nmfc5
String ls_class1,ls_class2,ls_class3,ls_class4,ls_class5
String ls_cust_ord_nbr1,ls_cust_ord_nbr2,ls_cust_ord_nbr3,ls_cust_ord_nbr4,ls_cust_ord_nbr5
String ls_invoice_no1, ls_invoice_no2,  ls_invoice_no3, ls_invoice_no4, ls_invoice_no5
Decimal ld_item_qty1,ld_item_qty2,ld_item_qty3,ld_item_qty4,ld_item_qty5
DataStore lds_bol_singleorder_header,lds_bol_singleorder_detail
Boolean lb_suplm

lb_suplm = False

//03-Jan-2014 :Madhu -Added code to verify whether all serial no's are scanned? -START
Long 	llpackqty,llscannedqty ,llserialcnt,lleligiblecnt

//get eligible records for scanning
// TAM 2014/01/15 - Changed from Count to Sum.  Not all items are scannable and we only want to compare the number of Scannable with the number of serials
//select count(*) into :lleligiblecnt from Delivery_Packing,Item_Master
select sum(Quantity) into :lleligiblecnt from Delivery_Packing,Item_Master
where Delivery_Packing.SKU = Item_Master.SKU
and Delivery_Packing.DO_No= :as_dono
and Item_Master.Serialized_Ind in ('Y','B')
using SQLCA;

If lleligiblecnt >0 Then
//TAM	Select sum(Quantity) into :llpackqty from Delivery_Packing where Do_No =:as_dono using SQLCA;
	Select Sum(quantity) into :llScannedQty from delivery_serial_detail Where Id_no in (select id_no from delivery_picking_detail where do_no = :as_dono) using SQLCA;
	
	If IsNull(llScannedQty) then 
		llScannedQty =0 
	end if
	
// TAM	If llpackqty <> llScannedQty Then
	If lleligiblecnt <> llScannedQty Then
		MessageBox(w_do.is_title,"All Serial no's are not being scanned. Please check.",Stopsign!)
		Return 0
	End if 
End if 

//03-Jan-2014 :Madhu - Added code to verify whether all serial no's are scanned? -END

//Datastore for Report header section
lds_bol_singleorder_header = create datastore
lds_bol_singleorder_header.dataobject = 'd_vics_bol_prt_singleorder_header'
lds_bol_singleorder_header.SetTransObject(SQLCA)
lds_bol_singleorder_header.Retrieve(gs_project, as_dono)

//Datastore for Report header section
lds_bol_singleorder_detail = create datastore
lds_bol_singleorder_detail.dataobject = 'd_vics_bol_prt_singleorder_detail'
lds_bol_singleorder_detail.SetTransObject(SQLCA)
lds_bol_singleorder_detail.Retrieve(gs_project, as_dono)
ll_detailrowcount=lds_bol_singleorder_detail.rowcount()

//Suplemental page
DatawindowChild ldwc_nmfcitem_suplm
Datastore lds_bol_suplm
lds_bol_suplm = Create datastore
lds_bol_suplm.dataobject = 'd_vics_bol_prt_singleorder_suplm_composite_rpt'   //composite report

lds_bol_suplm.GetChild('dw_single_nmfcitem_suplm', ldwc_nmfcitem_suplm)
ldwc_nmfcitem_suplm.SetTransObject(SQLCA)	
ldwc_nmfcitem_suplm.Retrieve(gs_project, as_dono)
ll_nmfc_suplm_rowcount=ldwc_nmfcitem_suplm.Rowcount()

adw_bol.SetTransObject(SQLCA)
adw_bol.Retrieve(gs_project, as_dono) 
ll_bol_rowcount= adw_bol.Rowcount()

//If more than 1 row use external dw otherwise use inline sql on report (d_vics_bol_prt_singleorder)
If ll_bol_rowcount > 1 Then 
	adw_bol.dataobject = 'd_friedrich_bol_prt_combine_ext'
	//Jxlim Insert row to begin for external dw
	adw_bol.InsertRow(0)
	//Header Info
		//Using  lds_bol_singleorder_header datastore for Header section
		//Ship From address from Warehouse Table
	
		//adw_bol.SetItem(1,"wh_code",  lds_bol_singleorder_header.GetitemString(1, "wh_code"))
		adw_bol.SetItem(1,"wh_name", lds_bol_singleorder_header.GetitemString(1, "wh_Name"))
		adw_bol.SetItem(1,"wh_addr1", lds_bol_singleorder_header.GetitemString(1,"wh_Addr1" ))  
		adw_bol.SetItem(1,"wh_addr2", lds_bol_singleorder_header.GetitemString(1,"wh_Addr2" ))   
		adw_bol.SetItem(1,"wh_addr3", lds_bol_singleorder_header.GetitemString(1,"wh_Addr3"))    
		adw_bol.SetItem(1,"wh_addr4", lds_bol_singleorder_header.GetitemString(1,"wh_Addr4" ))   
		adw_bol.SetItem(1,"wh_city", lds_bol_singleorder_header.GetitemString(1,"wh_City" ))  
		adw_bol.SetItem(1,"wh_state", lds_bol_singleorder_header.GetitemString(1,"wh_State" ))     
		adw_bol.SetItem(1,"wh_zip", lds_bol_singleorder_header.GetitemString(1,"wh_Zip" ))    
		
		//Ship To from Delivery_Master Table
		adw_bol.SetItem(1,"cust_code",  lds_bol_singleorder_header.GetitemString(1, "Cust_code"))
		adw_bol.SetItem(1,"cust_name", lds_bol_singleorder_header.GetitemString(1, "Cust_Name"))
		adw_bol.SetItem(1,"cust_addr1", lds_bol_singleorder_header.GetitemString(1,"Address_1" ))  
		adw_bol.SetItem(1,"cust_addr2", lds_bol_singleorder_header.GetitemString(1,"Address_2" ))   
		adw_bol.SetItem(1,"cust_addr3", lds_bol_singleorder_header.GetitemString(1,"Address_3"))    
		adw_bol.SetItem(1,"cust_addr4", lds_bol_singleorder_header.GetitemString(1,"Address_4" ))   
		adw_bol.SetItem(1,"cust_city", lds_bol_singleorder_header.GetitemString(1,"City" ))  
		adw_bol.SetItem(1,"cust_state", lds_bol_singleorder_header.GetitemString(1,"State" ))     
		adw_bol.SetItem(1,"cust_zip", lds_bol_singleorder_header.GetitemString(1,"Zip" ))    
		adw_bol.SetItem(1,"contact_person", lds_bol_singleorder_header.GetitemString(1,"Contact_person"  ))  
		adw_bol.SetItem(1,"tel", lds_bol_singleorder_header.GetitemString(1,"Tel"  ))  
		adw_bol.SetItem(1,"cust_country", lds_bol_singleorder_header.GetitemString(1,"Country"  ))  //07-Apr-2015 Madhu Added customer Country
		adw_bol.SetItem(1,"shipping_instr", lds_bol_singleorder_header.GetitemString(1,"shipping_instr"))  
		adw_bol.SetItem(1,"awb_bol_no", lds_bol_singleorder_header.GetitemString(1,"awb_bol_no"  ))  
		//adw_bol.SetItem(1,"consl_no", lds_bol_singleorder_header.GetitemString(1,"consolidation_no"  ))   //There won't be consolidation_no for single order
		adw_bol.SetItem(1,"trailer_no", lds_bol_singleorder_header.GetitemString(1,"Trailer_no"  ))  		 //DM.user_field2		
		adw_bol.SetItem(1,"pro_no", lds_bol_singleorder_header.GetitemString(1,"Carrier_Pro_No"  )) 	//DM.user_field7  Jxlim 04/02/2014 Replaced with carrier_pro_no name field
		adw_bol.SetItem(1,"scac", lds_bol_singleorder_header.GetitemString(1,"scac"  ))  					// Carrier_Master.Carrier_code first 4 digits
		adw_bol.SetItem(1,"Carrier", lds_bol_singleorder_header.GetitemString(1,"carrier"  ))  					// Carrier_Master.Carrier_code 
		adw_bol.SetItem(1,"Freight_Terms", lds_bol_singleorder_header.GetitemString(1,"Freight_Terms"  )) //Frieght_terms, X mark visible based on frieght_terms 		
		
		//for singleorder this should always be 1 row, who now friedrich will have multple cust code for one order
		//Order information--------------------------------------------------------------------------------------------------			
		If	ll_detailrowcount <=5 Then
			//For i = 1 to ll_detail_rowcount	
			For i = 1 to 	ll_detailrowcount
				If i = 1 Then
						ls_cust_ord_nbr1= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr1",ls_cust_ord_nbr1)
						
						ld_pack_qty1=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty1",ld_pack_qty1)
						
						ld_totalw1=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight1",ld_totalw1)
							
						ls_invoice_no1=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no1",ls_invoice_no1)
						
				ElseIf i = 2 Then
						ls_cust_ord_nbr2= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr2",ls_cust_ord_nbr2)
						
						ld_pack_qty2=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty2",ld_pack_qty2)
						
						ld_totalw2=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight2",ld_totalw2)
							
						ls_invoice_no2=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no2",ls_invoice_no2)
						
				ElseIf i = 3 Then
						ls_cust_ord_nbr3= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr3",ls_cust_ord_nbr3)
							
						ld_pack_qty3=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty3",ld_pack_qty3)
						
						ld_totalw3=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight3",ld_totalw3)
						
						ls_invoice_no3=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no3",ls_invoice_no3)		
						  
				ElseIf i = 4 Then
						ls_cust_ord_nbr4= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr",ls_cust_ord_nbr4)
						
						ld_pack_qty4=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty4",ld_pack_qty4)
						
						ld_totalw4=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight4",ld_totalw4)
						
						ls_invoice_no4=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no4",ls_invoice_no4)
				ElseIf i = 5 Then	
						ls_cust_ord_nbr5= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr2",ls_cust_ord_nbr2)
							
						ld_pack_qty5=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty5",ld_pack_qty5)
						
						ld_totalw5=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight5",ld_totalw5)
						
						ls_invoice_no5=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no5",ls_invoice_no5)				
				End if
			Next	
			//Total Qty and total Weight by Order number
			ld_total_pack_qty=  lds_bol_singleorder_detail.GetitemDecimal(1,"total_pack_qty")  //sum of total pack qty
			ld_total_pack_weight= lds_bol_singleorder_detail.GetitemDecimal(1,"total_pack_weight")  //sum of total weight
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child
			adw_bol.SetItem(1,"total_pack_qty",ld_total_pack_qty)
			adw_bol.SetItem(1,"total_pack_Weight",ld_total_pack_Weight)	
		End If
			
		//Carrier Information --NMFC--------------------------------------------------------------------------------------------------------------		
		If ll_nmfc_suplm_rowcount <= 5  Then
			For i = 1 to ll_nmfc_suplm_rowcount	
			If i = 1 Then				
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count1",ll_carton_count1)
					ls_carton_type1= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")					
					adw_bol.SetItem(1,"carton_type1",ls_carton_type1)
					
					ld_Item_qty1= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty1",ld_item_qty1)
					
					ld_Weight1= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight1",ld_Weight1)
					
					ls_nmfcdescription1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription1",ls_nmfcdescription1)
					
					ls_nmfc1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc1",ls_nmfc1)
					
					ls_class1= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class1",ls_class1)
					
			ElseIf i = 2 Then		
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")					
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count2",ll_carton_count2)
					ls_carton_type2= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type2",ls_carton_type2)
					
					ld_Item_qty2= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty2",ld_item_qty2)
					
					ld_Weight2= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight2",ld_Weight2)
					
					ls_nmfcdescription2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription2",ls_nmfcdescription2)
					
					ls_nmfc2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc2",ls_nmfc2)
					
					ls_class2= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class2",ls_class2)
					
			ElseIf i = 3 Then
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count3",ll_carton_count3)
					ls_carton_type3= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type3",ls_carton_type3)
					
					ld_Item_qty3= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty3",ld_item_qty3)
					
					ld_Weight3= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight3",ld_Weight3)
					
					ls_nmfcdescription3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription3",ls_nmfcdescription3)
					
					ls_nmfc3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc3",ls_nmfc3)
					
					ls_class3= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class3",ls_class3)
					
			ElseIf i = 4 Then
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count4 =ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count4",ll_carton_count4)
					ls_carton_type4= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type4",ls_carton_type4)
					
					ld_Item_qty4= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty4",ld_item_qty4)
					
					ld_Weight4= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight4",ld_Weight4)
					
					ls_nmfcdescription4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription4",ls_nmfcdescription4)
					
					ls_nmfc4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc4",ls_nmfc4)
					
					ls_class4= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class4",ls_class4)
			ElseIf i = 5 Then
				//	ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count5",ll_carton_count5)
					ls_carton_type5= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type5",ls_carton_type5)
					
					ld_Item_qty5= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty5",ld_item_qty5)
					
					ld_Weight5= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight5",ld_Weight5)
					
					ls_nmfcdescription5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription5",ls_nmfcdescription5)
					
					ls_nmfc5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc5",ls_nmfc5)
					
					ls_class5= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class5",ls_class5)
				End if
			Next			
			//Total of all Number of carton from all orders group by carton_no with multiple Item. Examp one order with multiple line and multple NMFC pack together in one pallet
			ll_total_carton_count= ldwc_nmfcitem_suplm.GetitemNumber(1, "total_carton_count") 
			adw_bol.SetItem(1,"total_carton_count", ll_total_carton_count )
			
			//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
//			ls_carton_type= ldwc_nmfcitem_suplm.GetitemString(1, "carton_type")
//			adw_bol.SetItem(1,"carton_type",ls_carton_type)
			
			//Total Qty and total Weight by NMFC (Item_master)
			ld_total_item_qty=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_item_qty")
			adw_bol.SetItem(1,"total_item_qty",ld_total_item_qty)
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child			
			ld_total_net_w=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_net_w")
			adw_bol.SetItem(1,"total_net_w",ld_total_net_w)
		End If //NMFC 	
End If //End for external dw report
	
//Jxlim 12/19/2013 Friedrich Third party add on BOL is Bill To (BT address type)
//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss
DataStore lds_bol_alt_address
Long ll_alt_addr_count
lds_bol_alt_address = create datastore
lds_bol_alt_address.dataobject = 'd_do_address_alt'
lds_bol_alt_address.SetTransObject(SQLCA)
lds_bol_alt_address.Retrieve(as_dono, 'BT')  //as_dono asType=BT (Bill To for BOL) --3P is for Trax/Third Party
ll_alt_addr_count=lds_bol_alt_address.Rowcount()

//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss --BOL third party address uses Bill TO ('BT') address type			
		If	ll_alt_addr_count > 0 Then	
			adw_bol.SetItem(1, "alt_name", lds_bol_alt_address.GetItemString(1, "name"))		
			adw_bol.SetItem(1, "alt_addr1", lds_bol_alt_address.GetItemString(1, "address_1"))
			adw_bol.SetItem(1, "alt_addr2", lds_bol_alt_address.GetItemString(1, "address_2"))
			adw_bol.SetItem(1, "alt_addr3", lds_bol_alt_address.GetItemString(1, "address_3"))
			adw_bol.SetItem(1, "alt_addr4", lds_bol_alt_address.GetItemString(1, "address_4"))
			adw_bol.SetItem(1, "alt_city",    lds_bol_alt_address.GetItemString(1, "city"))
			adw_bol.SetItem(1, "alt_state",  lds_bol_alt_address.GetItemString(1, "state"))
			adw_bol.SetItem(1, "alt_zip",     lds_bol_alt_address.GetItemString(1, "zip"))
		End If

//If NMFC more than 5 rows print supplemental page
If 	ll_nmfc_suplm_rowcount > 5 Then
	adw_bol.SetItem(1, "nmfc_count",  ll_nmfc_suplm_rowcount)
   	lb_suplm = True
	//Print(lds_bol_suplm)	//no print dialog
	OpenWithParm(w_dw_print_options,lds_bol_suplm) //print dialog
End If

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetRedraw(true)

RETURN 1
end function

public function integer uf_process_vics_bol_pandora_combine (string as_dono, ref datawindow adw_bol);// LTK 20151008  This method was modeled after uf_process_vics_bol_combine, all comments, etc. were copied below

//Jxlim 12/10/2013 Freidrich Vics BOL up to 5 orders
//This is an external datawindow useb by manipulating datastores to produce a combine Vics BOL up to 5 detail/NMFC rows
//to fit into one single page of International standard Vics BOL.  (Strickly no extra page).  
//In the event that the order exist 5 rows, a supplement page will be created to handle this and it will be a separate code from this.
//This Vics BOL is officially name a Single page Vics BOL requested by Friedrich.
//This report contains:
//1. Header warehouse and order master, carrier from delivery_master and warehouse and Carrier_Master
//2. Third party address from Delivery_alt_address where address_type ='BT'
//Created a new datawindow for delivery alt address based on consolidation_no since we may have multiple do_no. 
//Baseline should be able to fulfill this however, 
//since we already have the consolidation_no variable within this code it is easier to just retrieve based on consolidation_no.
//The existing baseline third party address datawindow is based on do_no
//Customer Order Information and Carrier Information have to separate into 2 different query although they are source from the same table.
//This is because Customer detail required to group by order and Carrier information required to group by item.
//3. group by order: Order information detail from Delivery Master and Packing; and the weight is getting from item_master.weight_1
//--Total Packing Weight = Sum(Delivery_Packing.Qty * Item_Master.Weight_1)	
//4. group by NMFC: Carrier Information from Item_Master and Number of carton_no (count of carton_no) from delivery_packing 
//--Total item Weight = Sum(Delivery_Packing.Qty * Item_Master.Weight_1)	
//This is done through group by NMFC not carton_no
//If an order with 2 different NMFC code (2 Items) pack into one pallet together
//then the carton_no should show only 1 pallet this is done through group by carton_no
//supplmental detail and nmfc datawindow will be used regradless 5 or less orders in a shipment

Long   i, ll_consl_rowcount,	ll_detail_suplm_rowcount, ll_nmfc_suplm_rowcount, ll_detail_rowcount, ll_nmfc_rowcount, ll_alt_address_rowcount, ll_nmfc_carton_rowcount
Long   ll_carton_count1, ll_carton_count2,ll_carton_count3,ll_carton_count4,ll_carton_count5,ll_total_carton_count,ll_bol_suplm
String ls_custcode,ls_custname, ls_carton_type
Decimal ld_Pack_qty1,ld_Pack_qty2,ld_Pack_qty3,ld_Pack_qty4,ld_Pack_qty5
Decimal ld_total_item_qty, ld_total_pack_qty
Decimal ld_weight1,ld_weight2,ld_weight3,ld_weight4,ld_weight5, ld_total_net_w, ld_total_pack_weight
Decimal ld_totalw1, ld_totalw2,ld_totalw3,ld_totalw4,ld_totalw5
String ls_carton_type1,ls_carton_type2,ls_carton_type3,ls_carton_type4,ls_carton_type5
String ls_nmfcdescription1, ls_nmfcdescription2,ls_nmfcdescription3,ls_nmfcdescription4,ls_nmfcdescription5, ls_nmfc1,ls_nmfc2,ls_nmfc3,ls_nmfc4,ls_nmfc5
String ls_class1,ls_class2,ls_class3,ls_class4,ls_class5
String ls_cust_ord_nbr1,ls_cust_ord_nbr2,ls_cust_ord_nbr3,ls_cust_ord_nbr4,ls_cust_ord_nbr5
String ls_invoice_no1, ls_invoice_no2,  ls_invoice_no3, ls_invoice_no4, ls_invoice_no5
Decimal ld_item_qty1,ld_item_qty2,ld_item_qty3,ld_item_qty4,ld_item_qty5
Datawindowchild ldwc_detail_suplm,ldwc_nmfcitem_suplm
Boolean lb_suplm

n_warehouse l_nwarehouse  //Jxlim 07/08/2013 SSCC fo BOL and VICS
l_nwarehouse		= Create n_warehouse

lb_suplm=False

//03-Jan-2014 :Madhu -Added code to verify whether all serial no's are scanned? -START
Long 	llpackqty,llscannedqty ,llserialcnt,lleligiblecnt

//14-Aug-2015 :Madhu- Added code to print Carton and Pallet count separetly on BOL
int row
string lscarton_type
long ll_total_pallet_count


// LTK 20151113  Configurable hard stop if HazMat is found on order, message displayed in method
if uf_is_pandora_hazmat_turned_on( "", as_dono ) < 0 then	// NOTE: as_dono is consolidation_no in this case
	Return 0
end if


//get eligible records for scanning
// TAM 2014/01/15 - Changed from Count to Sum.  Not all items are scannable and we only want to compare the number of Scannable with the number of serials
//select count(*) into :lleligiblecnt from Delivery_Packing,Item_Master
select sum(Quantity) into :lleligiblecnt from Delivery_Packing,Item_Master
where Delivery_Packing.SKU = Item_Master.SKU
and Delivery_Packing.DO_No= :as_dono
and Item_Master.Project_Id=:gs_project
and Item_Master.Serialized_Ind in ('Y','B')
using SQLCA;

If lleligiblecnt >0 Then
//TAM	Select sum(Quantity) into :llpackqty from Delivery_Packing where Do_No =:as_dono using SQLCA;
	Select Sum(quantity) into :llScannedQty from delivery_serial_detail Where Id_no in (select id_no from delivery_picking_detail where do_no = :as_dono) using SQLCA;
	
	If IsNull(llScannedQty) then 
		llScannedQty =0 
	end if
	
//TAM 	If llpackqty <> llScannedQty Then
	If lleligiblecnt <> llScannedQty Then
		MessageBox(w_do.is_title,"All Serial no's are not being scanned. Please check.",Stopsign!)
		Return 0
	End if 
End if 

//03-Jan-2014 :Madhu - Added code to verify whether all serial no's are scanned? -END


// LTK 20151102  When IM.hazard_cd is set, validate IM.proper_shipping_name is also set or halt BOL generation
long ll_hazmat_description_errors
String ls_erroneous_sku

select count(*), Max(SKU)
into :ll_hazmat_description_errors, :ls_erroneous_sku 
from Item_Master
where project_id = :gs_project
and hazard_cd is not null 
and Len( LTRIM(RTRIM( hazard_cd )) ) > 0 
and ( proper_shipping_name is null or LTRIM(RTRIM( proper_shipping_name ))  = '' ) 
and SKU in
	(select SKU
	from Delivery_Detail
	where do_no in
		(select do_no
		from delivery_master
		where project_id = :gs_project
		and consolidation_no = :as_dono) );		// as_dono is actually consolidation_no

if ll_hazmat_description_errors > 0 then
	MessageBox(w_do.is_title, "GPN(s) exist marked as hazardous without proper shipping names, such as GPN:  "  + ls_erroneous_sku + &
										"~r~rPlease set the proper shipping name in the Item Master Maintenance.")
	return 0
end if


//Jxlim; Created data store to Retrieve report contains, then get the value from this datastore to set it to ext dw
Datastore  lds_bol_suplm,lds_bol_combine_header, lds_bol_combine_alt_address
Datastore  lds_nmfc_carton_count, ldwc_detail_suplm_suplm

//Jxlim; may not need this datastore but for now 
//Datastore for Report header section
lds_bol_combine_header = create datastore
lds_bol_combine_header.dataobject = 'd_vics_bol_prt_combined_pandora_header'
lds_bol_combine_header.SetTransObject(SQLCA)

lds_bol_combine_header.Retrieve(gs_project, as_dono)	// Consolidation is being passed in
ll_consl_rowcount = lds_bol_combine_header.Rowcount()

//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss
lds_bol_combine_alt_address = create datastore
lds_bol_combine_alt_address.dataobject = 'd_vics_bol_prt_combined_alt_address'
lds_bol_combine_alt_address.SetTransObject(SQLCA)
lds_bol_combine_alt_address.Retrieve(gs_project, as_dono, 'BT')  //as_dono(consolidation No) asType=BT (Bill To for BOL) --3P is for Trax/Third Party
ll_alt_address_rowcount=lds_bol_combine_alt_address.Rowcount()

lds_bol_suplm = Create datastore
//lds_bol_suplm.dataobject = 'd_vics_bol_prt_combined_suplm_composite_rpt'
lds_bol_suplm.dataobject ='d_vics_bol_prt_combined_suplm_composite_rpt_pandora'		// LTK 20151008

lds_bol_suplm.GetChild('dw_detail_suplm', ldwc_detail_suplm)
ldwc_detail_suplm.SetTransObject(SQLCA)	
ldwc_detail_suplm.Retrieve(gs_project, as_dono)
ll_detail_suplm_rowcount=ldwc_detail_suplm.RowCount()

lds_bol_suplm.GetChild('dw_nmfcitem_suplm', ldwc_nmfcitem_suplm)
ldwc_nmfcitem_suplm.SetTransObject(SQLCA)	
ldwc_nmfcitem_suplm.Retrieve(gs_project, as_dono)
ll_nmfc_suplm_rowcount=ldwc_nmfcitem_suplm.Rowcount()
// Set carrier information from w_do fields
uf_set_carrier_information( ldwc_nmfcitem_suplm )

// LTK 20151120  Calculate the sort column and sort the item DW appropriately given we sort hazardous materials to the top
uf_set_sort( ldwc_nmfcitem_suplm )

//Jxlim Insert row to begin for external dw
adw_bol.InsertRow(0)
//Header Info
		//Using  lds_bol_combine_header datastore for Header section
		//Ship From address from Warehouse Table
	
		//adw_bol.SetItem(1,"wh_code",  lds_bol_combine_header.GetitemString(1, "wh_code"))
		adw_bol.SetItem(1,"wh_name", lds_bol_combine_header.GetitemString(1, "wh_Name"))
		adw_bol.SetItem(1,"wh_addr1", lds_bol_combine_header.GetitemString(1,"wh_Addr1" ))  
		adw_bol.SetItem(1,"wh_addr2", lds_bol_combine_header.GetitemString(1,"wh_Addr2" ))   
		adw_bol.SetItem(1,"wh_addr3", lds_bol_combine_header.GetitemString(1,"wh_Addr3"))    
		adw_bol.SetItem(1,"wh_addr4", lds_bol_combine_header.GetitemString(1,"wh_Addr4" ))   
		adw_bol.SetItem(1,"wh_city", lds_bol_combine_header.GetitemString(1,"wh_City" ))  
		adw_bol.SetItem(1,"wh_state", lds_bol_combine_header.GetitemString(1,"wh_State" ))     
		adw_bol.SetItem(1,"wh_zip", lds_bol_combine_header.GetitemString(1,"wh_Zip" ))    
		
		//Ship To from Delivery_Master Table
		adw_bol.SetItem(1,"cust_code",  lds_bol_combine_header.GetitemString(1, "Cust_code"))
		adw_bol.SetItem(1,"cust_name", lds_bol_combine_header.GetitemString(1, "Cust_Name"))
		adw_bol.SetItem(1,"cust_addr1", lds_bol_combine_header.GetitemString(1,"Address_1" ))  
		adw_bol.SetItem(1,"cust_addr2", lds_bol_combine_header.GetitemString(1,"Address_2" ))   
		adw_bol.SetItem(1,"cust_addr3", lds_bol_combine_header.GetitemString(1,"Address_3"))    
		adw_bol.SetItem(1,"cust_addr4", lds_bol_combine_header.GetitemString(1,"Address_4" ))   
		adw_bol.SetItem(1,"cust_city", lds_bol_combine_header.GetitemString(1,"City" ))  
		adw_bol.SetItem(1,"cust_state", lds_bol_combine_header.GetitemString(1,"State" ))     
		adw_bol.SetItem(1,"cust_zip", lds_bol_combine_header.GetitemString(1,"Zip" ))    
		adw_bol.SetItem(1,"contact_person", lds_bol_combine_header.GetitemString(1,"Contact_person"  ))  
		adw_bol.SetItem(1,"tel", lds_bol_combine_header.GetitemString(1,"Tel"  )) 
		adw_bol.SetItem(1,"cust_country", lds_bol_combine_header.GetitemString(1,"Country"  ))  //13-Aug-2015 Madhu Added customer Country
		
		adw_bol.SetItem(1,"shipping_instr", lds_bol_combine_header.GetitemString(1,"shipping_instr"))  
		adw_bol.SetItem(1,"awb_bol_no", lds_bol_combine_header.GetitemString(1,"awb_bol_no"  ))  
		//adw_bol.SetItem(1,"consl_no", lds_bol_combine_header.GetitemString(1,"consolidation_no"  ))  
		adw_bol.SetItem(1,"vics_bol_no", lds_bol_combine_header.GetitemString(1,"delivery_master_vics_bol_no"  ))  
		//adw_bol.SetItem(1,"trailer_no", lds_bol_combine_header.GetitemString(1,"Trailer_no"  ))  		 //DM.user_field2
		adw_bol.SetItem(1,"pro_no", lds_bol_combine_header.GetitemString(1,"delivery_master_carrier_pro_no"  )) 	//DM.user_field7  Jxlim 04/02/2014 Replaced with carrier_pro_no name field
		//adw_bol.SetItem(1,"scac", lds_bol_combine_header.GetitemString(1,"scac"  ))  					// Carrier_Master.Carrier_code first 4 digits
		adw_bol.SetItem(1,"scac", lds_bol_combine_header.GetitemString(1,"carrier"  )) 
		adw_bol.SetItem(1,"carrier", lds_bol_combine_header.GetitemString(1,"ship_via"  )) 		
		adw_bol.SetItem(1,"Freight_Terms", lds_bol_combine_header.GetitemString(1,"Freight_Terms"  )) //Frieght_terms, X mark visible based on frieght_terms 		
		adw_bol.SetItem(1,"ord_date", lds_bol_combine_header.GetitemDateTime(1,"delivery_master_ord_date"  )) 
		adw_bol.SetItem(1,"user_field10", lds_bol_combine_header.GetitemString(1,"user_field10"  )) 
		adw_bol.SetItem(1,"special_instr_invoice_no", lds_bol_combine_header.GetitemString(1,"invoice_no"  )) 

		//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss --BOL third party address uses Bill TO ('BT') address type			
		If	ll_alt_address_rowcount > 0 Then	
			adw_bol.SetItem(1, "alt_name", lds_bol_combine_alt_address.GetItemString(1, "name"))		
			adw_bol.SetItem(1, "alt_addr1", lds_bol_combine_alt_address.GetItemString(1, "address_1"))
			adw_bol.SetItem(1, "alt_addr2", lds_bol_combine_alt_address.GetItemString(1, "address_2"))
			adw_bol.SetItem(1, "alt_addr3", lds_bol_combine_alt_address.GetItemString(1, "address_3"))
			adw_bol.SetItem(1, "alt_addr4", lds_bol_combine_alt_address.GetItemString(1, "address_4"))
			adw_bol.SetItem(1, "alt_city",    lds_bol_combine_alt_address.GetItemString(1, "city"))
			adw_bol.SetItem(1, "alt_state",  lds_bol_combine_alt_address.GetItemString(1, "state"))
			adw_bol.SetItem(1, "alt_zip",     lds_bol_combine_alt_address.GetItemString(1, "zip"))
		End If


//Print supplementan page if more than 5 orders or more than 5 items
lb_suplm= FALSE

If ll_consl_rowcount  > 5 Then //Print supplementan page
	adw_bol.SetItem(1, "order_count",  ll_detail_suplm_rowcount)
	lb_suplm= True
End If

If ll_nmfc_suplm_rowcount > 5 Then
	adw_bol.SetItem(1, "nmfc_count",  ll_nmfc_suplm_rowcount)
	lb_suplm = True		
end if

if lb_suplm = FALSE then
	//Detail order Information--------------------------------------------------------------------------------------------------------------	
	If	ll_detail_suplm_rowcount <=5 Then
			//For i = 1 to ll_detail_rowcount	
			For i = 1 to 	ll_detail_suplm_rowcount
				If i = 1 Then
						ls_cust_ord_nbr1= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr1",ls_cust_ord_nbr1)
						
						ld_pack_qty1=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty1",ld_pack_qty1)
						
						ld_totalw1=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight1",ld_totalw1)
							
						ls_invoice_no1=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no1",ls_invoice_no1)
						
				ElseIf i = 2 Then
						ls_cust_ord_nbr2= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr2",ls_cust_ord_nbr2)
						
						ld_pack_qty2=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty2",ld_pack_qty2)
						
						ld_totalw2=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight2",ld_totalw2)
							
						ls_invoice_no2=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no2",ls_invoice_no2)
						
				ElseIf i = 3 Then
						ls_cust_ord_nbr3= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr3",ls_cust_ord_nbr3)
							
						ld_pack_qty3=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty3",ld_pack_qty3)
						
						ld_totalw3=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight3",ld_totalw3)
						
						ls_invoice_no3=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no3",ls_invoice_no3)		
						  
				ElseIf i = 4 Then
						ls_cust_ord_nbr4= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr4",ls_cust_ord_nbr4)
						
						ld_pack_qty4=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty4",ld_pack_qty4)
						
						ld_totalw4=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight4",ld_totalw4)
						
						ls_invoice_no4=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no4",ls_invoice_no4)
						
				ElseIf i = 5 Then	
						ls_cust_ord_nbr5= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr5",ls_cust_ord_nbr2)
							
						ld_pack_qty5=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty5",ld_pack_qty5)
						
						ld_totalw5=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight5",ld_totalw5)
						
						ls_invoice_no5=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no5",ls_invoice_no5)				
				End if
			Next	
			//Total Qty and total Weight by Order number
			ld_total_pack_qty=  ldwc_detail_suplm.GetitemDecimal(1,"total_pack_qty")  //sum of total pack qty
			ld_total_pack_weight= ldwc_detail_suplm.GetitemDecimal(1,"total_pack_weight")  //sum of total weight
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child
			adw_bol.SetItem(1,"total_pack_qty",ld_total_pack_qty)
			adw_bol.SetItem(1,"total_pack_Weight",ld_total_pack_Weight)	
		End If

		//Carrier Information --NMFC--------------------------------------------------------------------------------------------------------------		
		If ll_nmfc_suplm_rowcount <=5  Then
			For i = 1 to ll_nmfc_suplm_rowcount	
			If i = 1 Then					
					ld_Item_qty1= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty1",ld_item_qty1)
					
					ld_Weight1= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight1",ld_Weight1)
					
					if ldwc_nmfcitem_suplm.GetitemString(i,"hazard_tag") = 'HAZARDOUS' then
						adw_bol.SetItem(1,"hazmat_1",'X')
					end if

//					ls_nmfcdescription1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
//					ls_nmfcdescription1= ldwc_nmfcitem_suplm.GetitemString(i,"item_master_hazard_cd_commodity_cd")			// LTK 20151008
					ls_nmfcdescription1= ldwc_nmfcitem_suplm.GetitemString(i,"compute_commodity_description")			// LTK 20151008
					adw_bol.SetItem(1,"nmfcdescription1",ls_nmfcdescription1)
//					
//					ls_nmfc1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
//					adw_bol.SetItem(1,"nmfc1",ls_nmfc1)
//					
//					ls_class1= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
//					adw_bol.SetItem(1,"class1",ls_class1)						
				
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					ll_carton_count1= Long( ldwc_nmfcitem_suplm.GetitemString(i, "carton_count") )
					adw_bol.SetItem(1,"carton_count1",ll_carton_count1)
					ls_carton_type1= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")	
					adw_bol.SetItem(1,"carton_type1",ls_carton_type1)			
					
			ElseIf i = 2 Then		
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					ll_carton_count2= Long( ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_countvisible") )
					adw_bol.SetItem(1,"carton_count2",ll_carton_count2)
					ls_carton_type2= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type2",ls_carton_type2)
					
					ld_Item_qty2= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty2",ld_item_qty2)
					
					ld_Weight2= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight2",ld_Weight2)

					if ldwc_nmfcitem_suplm.GetitemString(i,"hazard_tag") = 'HAZARDOUS' then
						adw_bol.SetItem(1,"hazmat_2",'X')
					end if

//					ls_nmfcdescription2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
//					ls_nmfcdescription2= ldwc_nmfcitem_suplm.GetitemString(i,"item_master_hazard_cd_commodity_cd")			// LTK 20151008
					ls_nmfcdescription2= ldwc_nmfcitem_suplm.GetitemString(i,"compute_commodity_description")			// LTK 20151008
					adw_bol.SetItem(1,"nmfcdescription2",ls_nmfcdescription2)
//					
//					ls_nmfc2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
//					adw_bol.SetItem(1,"nmfc2",ls_nmfc2)
//					
//					ls_class2= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
//					adw_bol.SetItem(1,"class2",ls_class2)
					
			ElseIf i = 3 Then
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					ll_carton_count3= Long( ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_countvisible") )
					adw_bol.SetItem(1,"carton_count3",ll_carton_count3)
					ls_carton_type3= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type3",ls_carton_type3)
					
					ld_Item_qty3= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty3",ld_item_qty3)
					
					ld_Weight3= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight3",ld_Weight3)
					
					if ldwc_nmfcitem_suplm.GetitemString(i,"hazard_tag") = 'HAZARDOUS' then
						adw_bol.SetItem(1,"hazmat_3",'X')
					end if

//					ls_nmfcdescription3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
//					ls_nmfcdescription3= ldwc_nmfcitem_suplm.GetitemString(i,"item_master_hazard_cd_commodity_cd")			// LTK 20151008
					ls_nmfcdescription3= ldwc_nmfcitem_suplm.GetitemString(i,"compute_commodity_description")			// LTK 20151008
					adw_bol.SetItem(1,"nmfcdescription3",ls_nmfcdescription3)
//					
//					ls_nmfc3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
//					adw_bol.SetItem(1,"nmfc3",ls_nmfc3)
//					
//					ls_class3= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
//					adw_bol.SetItem(1,"class3",ls_class3)
					
			ElseIf i = 4 Then
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					ll_carton_count4= Long( ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_countvisible") )
					adw_bol.SetItem(1,"carton_count4",ll_carton_count4)
					ls_carton_type4= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type4",ls_carton_type4)
					
					ld_Item_qty4= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty4",ld_item_qty4)
					
					ld_Weight4= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight4",ld_Weight4)

					if ldwc_nmfcitem_suplm.GetitemString(i,"hazard_tag") = 'HAZARDOUS' then
						adw_bol.SetItem(1,"hazmat_4",'X')
					end if

//					ls_nmfcdescription4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
//					ls_nmfcdescription4= ldwc_nmfcitem_suplm.GetitemString(i,"item_master_hazard_cd_commodity_cd")			// LTK 20151008
					ls_nmfcdescription4= ldwc_nmfcitem_suplm.GetitemString(i,"compute_commodity_description")			// LTK 20151008
					adw_bol.SetItem(1,"nmfcdescription4",ls_nmfcdescription4)
//					
//					ls_nmfc4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
//					adw_bol.SetItem(1,"nmfc4",ls_nmfc4)
//					
//					ls_class4= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
//					adw_bol.SetItem(1,"class4",ls_class4)
			ElseIf i = 5 Then
				//	ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")				
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					ll_carton_count5= Long( ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_countvisible") )
					adw_bol.SetItem(1,"carton_count5",ll_carton_count5)
					ls_carton_type5= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type5",ls_carton_type5)
					
					ld_Item_qty5= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty5",ld_item_qty5)
					
					ld_Weight5= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight5",ld_Weight5)
					
					if ldwc_nmfcitem_suplm.GetitemString(i,"hazard_tag") = 'HAZARDOUS' then				// LTK 20151008
						adw_bol.SetItem(1,"hazmat_5",'X')
					end if

//					ls_nmfcdescription5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
//					ls_nmfcdescription5= ldwc_nmfcitem_suplm.GetitemString(i,"item_master_hazard_cd_commodity_cd")			// LTK 20151008
					ls_nmfcdescription5= ldwc_nmfcitem_suplm.GetitemString(i,"compute_commodity_description")			// LTK 20151008
					adw_bol.SetItem(1,"nmfcdescription5",ls_nmfcdescription5)
					
//					ls_nmfc5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
//					adw_bol.SetItem(1,"nmfc5",ls_nmfc5)
//					
//					ls_class5= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
//					adw_bol.SetItem(1,"class5",ls_class5)
				End if
			Next			
			//Total of all Number of carton from all orders group by carton_no with multiple Item. Examp one order with multiple line and multple NMFC pack together in one pallet

			//14-Aug-2015 :Madhu- Added code to print Carton and Pallet count separetly on BOL - START
			//ll_total_carton_count= ldwc_nmfcitem_suplm.GetitemNumber(1, "total_carton_count")  //14-Aug-2015 :Madhu commented
			//adw_bol.SetItem(1,"total_carton_count", ll_total_carton_count ) //14-Aug-2015 :Madhu commented
			FOR  row =1 to ldwc_nmfcitem_suplm.rowcount( )
				lscarton_type =ldwc_nmfcitem_suplm.GetitemString(row, "cf_carton_type")
				
				CHOOSE CASE Upper(lscarton_type)
					CASE 'PALLET', 'PL','PLTS'
								ll_total_pallet_count += ldwc_nmfcitem_suplm.GetitemNumber(row, "cf_carton_countvisible")
								adw_bol.SetItem(1,"total_pallet_count", ll_total_pallet_count )
					CASE ELSE
								ll_total_carton_count += ldwc_nmfcitem_suplm.GetitemNumber(row, "cf_carton_countvisible")
								adw_bol.SetItem(1,"total_carton_count", ll_total_carton_count )				
					END CHOOSE
			Next
			
			// ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
			//14-Aug-2015 :Madhu- Added code to print Carton and Pallet count separetly on BOL - END
			
//			//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
//			ls_carton_type= ldwc_nmfcitem_suplm.GetitemString(1, "carton_type")
//			adw_bol.SetItem(1,"carton_type",ls_carton_type)
//			
			//Total Qty and total Weight by NMFC (Item_master)
			ld_total_item_qty=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_item_qty")
			adw_bol.SetItem(1,"total_item_qty",ld_total_item_qty)
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child			
			ld_total_net_w=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_net_w")
			adw_bol.SetItem(1,"total_net_w",ld_total_net_w)
		End If //NMFC 
End If

// LTK 20151022  Always display this, suplement or no
//Total Qty and total Weight by NMFC (Item_master)
ld_total_item_qty=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_item_qty")
adw_bol.SetItem(1,"total_item_qty",ld_total_item_qty)

// LTK 20160114  Copied following block to set Vics_Bol_No on order
//Jxlim 07/07/2013 End of SSCC for Bol and Vics value Pandora BRD 610   
String ls_vics_bol_no
ls_vics_bol_no =  w_do.idw_other.GetItemString(1,'vics_bol_no')

IF IsNull(ls_vics_bol_no) OR Trim(ls_vics_bol_no) = '' then
	ls_vics_bol_no = l_nwarehouse.of_get_sscc_bol(gs_project,'BOL_No')  //(use 17 digits)
	If ls_vics_bol_no = '' OR IsNull(ls_vics_bol_no) Then
		MessageBox ("Error", "There was a problem creating the SSCC Number.  Please check with support")
		Return 1
	Else
		//w_do.idw_other.setitem(1,'vics_bol_no',ls_vics_bol_no)    //This required calling safe; 
		//use embeded sql to update directly to db instead after generate the vics_bol_no to avoid hard refresh
		Execute Immediate "Begin Transaction" using SQLCA;
		Update dbo.Delivery_master
		Set Vics_Bol_no =:ls_vics_bol_no
		//Where Project_id =:gs_Project and Do_no = :as_dono	
		Where Project_id =:gs_Project and Do_no = :w_do.is_dono
		Using SQLCA;
		Execute Immediate "COMMIT" using SQLCA;		
	End if				
	
	w_do.tab_main.tabpage_main.dw_main.SetItem(1,'vics_bol_no',ls_vics_bol_no)		// GailM 01/10/2014 Update main DW 
	w_do.idw_other.setitem(1,'vics_bol_no',ls_vics_bol_no)
End if
//set vics_bol_no to BOL report
adw_bol.setitem(1,'vics_bol_no',ls_vics_bol_no)    		
//Jxlim 07/07/2013 End of SSCC for Bol and Vics value	
// End of set Vics_Bol_No on order


String ls_page_count
long ll_pages = 1

If lb_suplm = True Then

	// LTK 20151022  Print new message if hazardous materials and supplemental page exists
	for i = 1 to ldwc_nmfcitem_suplm.RowCount()
		if ldwc_nmfcitem_suplm.GetitemString(i,"hazard_tag") = 'HAZARDOUS' then
			adw_bol.Object.ordercount_t.text = "Hazardous Material - See Attached Supplemental Page(s)"
			adw_bol.Object.nmfccount_t.text = "Hazardous Material - See Attached Supplemental Page(s)"
			exit
		end if
	next

	// Set the page count for the main page here by adding the supplemental pages to the count
	ls_page_count = ldwc_detail_suplm.Describe( "Evaluate('pagecount()', 1)")
	if IsNumber( ls_page_count ) then
		ll_pages = Long( ls_page_count ) + 1
	end if
	adw_bol.Object.t_page_count_display.text = 'Page: 1 of ' + String( ll_pages )

	//Print(lds_bol_suplm)	//no print dialog
	OpenWithParm(w_dw_print_options,lds_bol_suplm) //print dialog
Else
	adw_bol.Object.t_page_count_display.text = 'Page: 1 of ' + String( ll_pages )
End If
	
If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetRedraw(true)

RETURN 1
end function

public function integer uf_process_vics_bol_pandora_singleorder (string as_dono, ref datawindow adw_bol);// LTK 20151008  This method was modeled after uf_process_vics_bol_combine, all comments, etc. were copied below

//Jxlim 12/10/2013 Freidrich Vics BOL up to 5 orders
//This is an external datawindow useb by manipulating datastores to produce a combine Vics BOL up to 5 detail/NMFC rows
//to fit into one single page of International standard Vics BOL.  (Strickly no extra page).  
//In the event that the order exist 5 rows, a supplement page will be created to handle this and it will be a separate code from this.
//This Vics BOL is officially name a Single page Vics BOL requested by Friedrich.
//This report contains:
//1. Header warehouse and order master, carrier from delivery_master and warehouse and Carrier_Master
//2. Third party address from Delivery_alt_address where address_type ='BT'
//Created a new datawindow for delivery alt address based on consolidation_no since we may have multiple do_no. 
//Baseline should be able to fulfill this however, 
//since we already have the consolidation_no variable within this code it is easier to just retrieve based on consolidation_no.
//The existing baseline third party address datawindow is based on do_no
//Customer Order Information and Carrier Information have to separate into 2 different query although they are source from the same table.
//This is because Customer detail required to group by order and Carrier information required to group by item.
//3. group by order: Order information detail from Delivery Master and Packing; and the weight is getting from item_master.weight_1
//--Total Packing Weight = Sum(Delivery_Packing.Qty * Item_Master.Weight_1)	
//4. group by NMFC: Carrier Information from Item_Master and Number of carton_no (count of carton_no) from delivery_packing 
//--Total item Weight = Sum(Delivery_Packing.Qty * Item_Master.Weight_1)	
//This is done through group by NMFC not carton_no
//If an order with 2 different NMFC code (2 Items) pack into one pallet together
//then the carton_no should show only 1 pallet this is done through group by carton_no
//supplmental detail and nmfc datawindow will be used regradless 5 or less orders in a shipment

Long   i, ll_consl_rowcount,	ll_detail_suplm_rowcount, ll_nmfc_suplm_rowcount, ll_detail_rowcount, ll_nmfc_rowcount, ll_alt_address_rowcount, ll_nmfc_carton_rowcount
Long   ll_carton_count1, ll_carton_count2,ll_carton_count3,ll_carton_count4,ll_carton_count5,ll_total_carton_count,ll_bol_suplm
String ls_custcode,ls_custname, ls_carton_type
Decimal ld_Pack_qty1,ld_Pack_qty2,ld_Pack_qty3,ld_Pack_qty4,ld_Pack_qty5
Decimal ld_total_item_qty, ld_total_pack_qty
Decimal ld_weight1,ld_weight2,ld_weight3,ld_weight4,ld_weight5, ld_total_net_w, ld_total_pack_weight
Decimal ld_totalw1, ld_totalw2,ld_totalw3,ld_totalw4,ld_totalw5, ld_total_carton_count
String ls_carton_type1,ls_carton_type2,ls_carton_type3,ls_carton_type4,ls_carton_type5
String ls_nmfcdescription1, ls_nmfcdescription2,ls_nmfcdescription3,ls_nmfcdescription4,ls_nmfcdescription5, ls_nmfc1,ls_nmfc2,ls_nmfc3,ls_nmfc4,ls_nmfc5
String ls_class1,ls_class2,ls_class3,ls_class4,ls_class5
String ls_cust_ord_nbr1,ls_cust_ord_nbr2,ls_cust_ord_nbr3,ls_cust_ord_nbr4,ls_cust_ord_nbr5
String ls_invoice_no1, ls_invoice_no2,  ls_invoice_no3, ls_invoice_no4, ls_invoice_no5
Decimal ld_item_qty1,ld_item_qty2,ld_item_qty3,ld_item_qty4,ld_item_qty5
//Datawindowchild ldwc_detail_suplm,ldwc_nmfcitem_suplm
Datawindowchild ldwc_nmfcitem_suplm
Datastore lds_detail_suplm
Boolean lb_suplm
String ls_carton_count

n_warehouse l_nwarehouse  //Jxlim 07/08/2013 SSCC fo BOL and VICS
l_nwarehouse		= Create n_warehouse

lb_suplm=False

//03-Jan-2014 :Madhu -Added code to verify whether all serial no's are scanned? -START
Long 	llpackqty,llscannedqty ,llserialcnt,lleligiblecnt

//14-Aug-2015 :Madhu- Added code to print Carton and Pallet count separetly on BOL
int row
string lscarton_type
long ll_total_pallet_count

// LTK 20151113  Configurable hard stop if HazMat is found on order, message displayed in method
if uf_is_pandora_hazmat_turned_on( as_dono, "" ) < 0 then
	Return 0
end if

//get eligible records for scanning
// TAM 2014/01/15 - Changed from Count to Sum.  Not all items are scannable and we only want to compare the number of Scannable with the number of serials
//select count(*) into :lleligiblecnt from Delivery_Packing,Item_Master
select sum(Quantity) into :lleligiblecnt from Delivery_Packing,Item_Master
where Delivery_Packing.SKU = Item_Master.SKU
and Delivery_Packing.DO_No= :as_dono
and Item_Master.Project_Id=:gs_project
and Item_Master.Serialized_Ind in ('Y','B')
using SQLCA;

If lleligiblecnt >0 Then
//TAM	Select sum(Quantity) into :llpackqty from Delivery_Packing where Do_No =:as_dono using SQLCA;
	Select Sum(quantity) into :llScannedQty from delivery_serial_detail Where Id_no in (select id_no from delivery_picking_detail where do_no = :as_dono) using SQLCA;
	
	If IsNull(llScannedQty) then 
		llScannedQty =0 
	end if
	
//TAM 	If llpackqty <> llScannedQty Then
	If lleligiblecnt <> llScannedQty Then
		MessageBox(w_do.is_title,"All Serial no's are not being scanned. Please check.",Stopsign!)
		Return 0
	End if 
End if 

//03-Jan-2014 :Madhu - Added code to verify whether all serial no's are scanned? -END


// LTK 20151102  When IM.hazard_cd is set, validate IM.proper_shipping_name is also set or halt BOL generation
long ll_hazmat_description_errors
String ls_erroneous_sku

select count(*), Max(SKU)
into :ll_hazmat_description_errors, :ls_erroneous_sku 
from Item_Master
where project_id = :gs_project
and hazard_cd is not null 
and Len( LTRIM(RTRIM( hazard_cd )) ) > 0 
and ( proper_shipping_name is null or LTRIM(RTRIM( proper_shipping_name ))  = '' ) 
and SKU in
	(select SKU
	from Delivery_Detail
	where do_no = :as_dono);

if ll_hazmat_description_errors > 0 then
	MessageBox(w_do.is_title, "GPN(s) exist marked as hazardous without proper shipping names, such as GPN:  "  + ls_erroneous_sku + &
										"~r~rPlease set the proper shipping name in the Item Master Maintenance.")
	return 0
end if

//Jxlim; Created data store to Retrieve report contains, then get the value from this datastore to set it to ext dw
Datastore  lds_bol_suplm,lds_bol_combine_header, lds_bol_combine_alt_address
Datastore  lds_nmfc_carton_count, ldwc_detail_suplm_suplm

//Jxlim; may not need this datastore but for now 
//Datastore for Report header section
lds_bol_combine_header = create datastore
lds_bol_combine_header.dataobject ='d_vics_bol_prt_singleorder_pandora_header' 		//'d_vics_bol_prt_combined_pandora_header'
lds_bol_combine_header.SetTransObject(SQLCA)

lds_bol_combine_header.Retrieve(gs_project, as_dono)	// Consolidation is being passed in
ll_consl_rowcount = lds_bol_combine_header.Rowcount()

//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss
lds_bol_combine_alt_address = create datastore
lds_bol_combine_alt_address.dataobject ='d_vics_bol_prt_singleorder_alt_address' 		//'d_vics_bol_prt_combined_alt_address'
lds_bol_combine_alt_address.SetTransObject(SQLCA)
lds_bol_combine_alt_address.Retrieve(gs_project, as_dono, 'BT')  //as_dono(consolidation No) asType=BT (Bill To for BOL) --3P is for Trax/Third Party
ll_alt_address_rowcount=lds_bol_combine_alt_address.Rowcount()

lds_bol_suplm = Create datastore
//lds_bol_suplm.dataobject = 'd_vics_bol_prt_combined_suplm_composite_rpt'
lds_bol_suplm.dataobject ='d_vics_bol_prt_singleorder_suplm_composite_pandora_rpt'	//'d_vics_bol_prt_combined_suplm_composite_rpt_pandora'		// LTK 20151008

//lds_bol_suplm.GetChild('dw_detail_suplm', ldwc_detail_suplm)
lds_detail_suplm = CREATE datastore
//lds_detail_suplm.DataObject = 'd_vics_bol_prt_singleorder_detail'	// LTK 20151008
lds_detail_suplm.DataObject = 'd_vics_bol_prt_singleorder_detail_pandora'	// LTK 20151008
lds_detail_suplm.SetTransObject(SQLCA)	
lds_detail_suplm.Retrieve(gs_project, as_dono)
ll_detail_suplm_rowcount=lds_detail_suplm.RowCount()


lds_bol_suplm.GetChild('dw_single_nmfcitem_suplm', ldwc_nmfcitem_suplm)
ldwc_nmfcitem_suplm.SetTransObject(SQLCA)	
ldwc_nmfcitem_suplm.Retrieve(gs_project, as_dono)
ll_nmfc_suplm_rowcount=ldwc_nmfcitem_suplm.Rowcount()


//Jxlim Insert row to begin for external dw
adw_bol.InsertRow(0)
//Header Info
		//Using  lds_bol_combine_header datastore for Header section
		//Ship From address from Warehouse Table
	
		//adw_bol.SetItem(1,"wh_code",  lds_bol_combine_header.GetitemString(1, "wh_code"))
		adw_bol.SetItem(1,"wh_name", lds_bol_combine_header.GetitemString(1, "wh_Name"))
		adw_bol.SetItem(1,"wh_addr1", lds_bol_combine_header.GetitemString(1,"wh_Addr1" ))  
		adw_bol.SetItem(1,"wh_addr2", lds_bol_combine_header.GetitemString(1,"wh_Addr2" ))   
		adw_bol.SetItem(1,"wh_addr3", lds_bol_combine_header.GetitemString(1,"wh_Addr3"))    
		adw_bol.SetItem(1,"wh_addr4", lds_bol_combine_header.GetitemString(1,"wh_Addr4" ))   
		adw_bol.SetItem(1,"wh_city", lds_bol_combine_header.GetitemString(1,"wh_City" ))  
		adw_bol.SetItem(1,"wh_state", lds_bol_combine_header.GetitemString(1,"wh_State" ))     
		adw_bol.SetItem(1,"wh_zip", lds_bol_combine_header.GetitemString(1,"wh_Zip" ))    
		
		//Ship To from Delivery_Master Table
		adw_bol.SetItem(1,"cust_code",  lds_bol_combine_header.GetitemString(1, "Cust_code"))
		adw_bol.SetItem(1,"cust_name", lds_bol_combine_header.GetitemString(1, "Cust_Name"))
		adw_bol.SetItem(1,"cust_addr1", lds_bol_combine_header.GetitemString(1,"Address_1" ))  
		adw_bol.SetItem(1,"cust_addr2", lds_bol_combine_header.GetitemString(1,"Address_2" ))   
		adw_bol.SetItem(1,"cust_addr3", lds_bol_combine_header.GetitemString(1,"Address_3"))    
		adw_bol.SetItem(1,"cust_addr4", lds_bol_combine_header.GetitemString(1,"Address_4" ))   
		adw_bol.SetItem(1,"cust_city", lds_bol_combine_header.GetitemString(1,"City" ))  
		adw_bol.SetItem(1,"cust_state", lds_bol_combine_header.GetitemString(1,"State" ))     
		adw_bol.SetItem(1,"cust_zip", lds_bol_combine_header.GetitemString(1,"Zip" ))    
		adw_bol.SetItem(1,"contact_person", lds_bol_combine_header.GetitemString(1,"Contact_person"  ))  
		adw_bol.SetItem(1,"tel", lds_bol_combine_header.GetitemString(1,"Tel"  )) 
		adw_bol.SetItem(1,"cust_country", lds_bol_combine_header.GetitemString(1,"Country"  ))  //13-Aug-2015 Madhu Added customer Country
		
		adw_bol.SetItem(1,"shipping_instr", lds_bol_combine_header.GetitemString(1,"shipping_instr"))  
		adw_bol.SetItem(1,"awb_bol_no", lds_bol_combine_header.GetitemString(1,"awb_bol_no"  ))  
		//adw_bol.SetItem(1,"consl_no", lds_bol_combine_header.GetitemString(1,"consolidation_no"  ))  
		adw_bol.SetItem(1,"vics_bol_no", lds_bol_combine_header.GetitemString(1,"delivery_master_vics_bol_no"  ))  
		//adw_bol.SetItem(1,"trailer_no", lds_bol_combine_header.GetitemString(1,"Trailer_no"  ))  		 //DM.user_field2
		adw_bol.SetItem(1,"pro_no", lds_bol_combine_header.GetitemString(1,"delivery_master_carrier_pro_no"  )) 	//DM.user_field7  Jxlim 04/02/2014 Replaced with carrier_pro_no name field
		//adw_bol.SetItem(1,"scac", lds_bol_combine_header.GetitemString(1,"scac"  ))  					// Carrier_Master.Carrier_code first 4 digits
		adw_bol.SetItem(1,"scac", lds_bol_combine_header.GetitemString(1,"carrier"  )) 
		
		String ls_carrier_code, ls_carrier_name
		ls_carrier_code = lds_bol_combine_header.GetitemString(1,"carrier"  )
		SELECT carrier_name
		INTO :ls_carrier_name
		FROM carrier_master
		WHERE 	( carrier_master.project_id = :gs_project )    AND  
					( carrier_master.carrier_code = :ls_carrier_code );
		
		adw_bol.SetItem(1,"carrier", ls_carrier_name) 		
		adw_bol.SetItem(1,"Freight_Terms", lds_bol_combine_header.GetitemString(1,"Freight_Terms"  )) //Frieght_terms, X mark visible based on frieght_terms 		
		adw_bol.SetItem(1,"ord_date", lds_bol_combine_header.GetitemDateTime(1,"delivery_master_ord_date"  )) 
		adw_bol.SetItem(1,"user_field10", lds_bol_combine_header.GetitemString(1,"user_field10"  )) 
		adw_bol.SetItem(1,"special_instr_invoice_no", lds_bol_combine_header.GetitemString(1,"invoice_no"  )) 

		//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss --BOL third party address uses Bill TO ('BT') address type			
		If	ll_alt_address_rowcount > 0 Then	
			adw_bol.SetItem(1, "alt_name", lds_bol_combine_alt_address.GetItemString(1, "name"))		
			adw_bol.SetItem(1, "alt_addr1", lds_bol_combine_alt_address.GetItemString(1, "address_1"))
			adw_bol.SetItem(1, "alt_addr2", lds_bol_combine_alt_address.GetItemString(1, "address_2"))
			adw_bol.SetItem(1, "alt_addr3", lds_bol_combine_alt_address.GetItemString(1, "address_3"))
			adw_bol.SetItem(1, "alt_addr4", lds_bol_combine_alt_address.GetItemString(1, "address_4"))
			adw_bol.SetItem(1, "alt_city",    lds_bol_combine_alt_address.GetItemString(1, "city"))
			adw_bol.SetItem(1, "alt_state",  lds_bol_combine_alt_address.GetItemString(1, "state"))
			adw_bol.SetItem(1, "alt_zip",     lds_bol_combine_alt_address.GetItemString(1, "zip"))
		End If

// Set carrier information from w_do fields
uf_set_carrier_information( ldwc_nmfcitem_suplm )

// LTK 20151120  Calculate the sort column and sort the item DW appropriately given we sort hazardous materials to the top
uf_set_sort( ldwc_nmfcitem_suplm )

//Print supplementan page if more than 5 orders
If ll_consl_rowcount  > 5 Then //Print supplementan page
	adw_bol.SetItem(1, "order_count",  ll_detail_suplm_rowcount)
	lb_suplm= True
Else
	lb_suplm= False
End If

If lb_suplm = False and ll_nmfc_suplm_rowcount > 5 Then
	adw_bol.SetItem(1, "nmfc_count",  ll_nmfc_suplm_rowcount)
	lb_suplm = True		
Else	
		//Carrier Information --NMFC--------------------------------------------------------------------------------------------------------------		
		If ll_nmfc_suplm_rowcount <=5  Then
			For i = 1 to ll_nmfc_suplm_rowcount	
			If i = 1 Then					
					ld_Item_qty1= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty1",ld_item_qty1)
					
					ld_Weight1= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight1",ld_Weight1)
					
					if ldwc_nmfcitem_suplm.GetitemString(i,"hazard_tag") = 'HAZARDOUS' then
						adw_bol.SetItem(1,"hazmat_1",'X')
					end if
					
//					ls_nmfcdescription1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
//					ls_nmfcdescription1= ldwc_nmfcitem_suplm.GetitemString(i,"item_master_hazard_cd_commodity_cd")			// LTK 20151008
					ls_nmfcdescription1= ldwc_nmfcitem_suplm.GetitemString(i,"compute_commodity_description")			// LTK 20151008
					adw_bol.SetItem(1,"nmfcdescription1",ls_nmfcdescription1)
//					
//					ls_nmfc1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )	
//					adw_bol.SetItem(1,"nmfc1",ls_nmfc1)
//					
//					ls_class1= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
//					adw_bol.SetItem(1,"class1",ls_class1)						
				
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					//adw_bol.SetItem(1,"carton_count1",ll_carton_count1)
					adw_bol.SetItem(1,"carton_count1", Long( ldwc_nmfcitem_suplm.GetitemString(i, "carton_count") ))					
					ls_carton_type1= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")	
					adw_bol.SetItem(1,"carton_type1",ls_carton_type1)			
					
			ElseIf i = 2 Then		
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					//adw_bol.SetItem(1,"carton_count2",ll_carton_count2)
					adw_bol.SetItem(1,"carton_count2", Long( ldwc_nmfcitem_suplm.GetitemString(i, "carton_count") ))					
					ls_carton_type2= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type2",ls_carton_type2)
					
					ld_Item_qty2= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty2",ld_item_qty2)
					
					ld_Weight2= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight2",ld_Weight2)

					if ldwc_nmfcitem_suplm.GetitemString(i,"hazard_tag") = 'HAZARDOUS' then
						adw_bol.SetItem(1,"hazmat_2",'X')
					end if

//					ls_nmfcdescription2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
//					ls_nmfcdescription2= ldwc_nmfcitem_suplm.GetitemString(i,"item_master_hazard_cd_commodity_cd")			// LTK 20151008
					ls_nmfcdescription2= ldwc_nmfcitem_suplm.GetitemString(i,"compute_commodity_description")			// LTK 20151008
					adw_bol.SetItem(1,"nmfcdescription2",ls_nmfcdescription2)
//					
//					ls_nmfc2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
//					adw_bol.SetItem(1,"nmfc2",ls_nmfc2)
//					
//					ls_class2= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
//					adw_bol.SetItem(1,"class2",ls_class2)
					
			ElseIf i = 3 Then
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					//adw_bol.SetItem(1,"carton_count3",ll_carton_count3)
					adw_bol.SetItem(1,"carton_count3", Long( ldwc_nmfcitem_suplm.GetitemString(i, "carton_count") ))					
					ls_carton_type3= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type3",ls_carton_type3)
					
					ld_Item_qty3= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty3",ld_item_qty3)
					
					ld_Weight3= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight3",ld_Weight3)
					
					if ldwc_nmfcitem_suplm.GetitemString(i,"hazard_tag") = 'HAZARDOUS' then
						adw_bol.SetItem(1,"hazmat_3",'X')
					end if

//					ls_nmfcdescription3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
//					ls_nmfcdescription3= ldwc_nmfcitem_suplm.GetitemString(i,"item_master_hazard_cd_commodity_cd")			// LTK 20151008
					ls_nmfcdescription3= ldwc_nmfcitem_suplm.GetitemString(i,"compute_commodity_description")			// LTK 20151008
					adw_bol.SetItem(1,"nmfcdescription3",ls_nmfcdescription3)
//					
//					ls_nmfc3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
//					adw_bol.SetItem(1,"nmfc3",ls_nmfc3)
//					
//					ls_class3= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
//					adw_bol.SetItem(1,"class3",ls_class3)
					
			ElseIf i = 4 Then
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					//adw_bol.SetItem(1,"carton_count4",ll_carton_count4)
					adw_bol.SetItem(1,"carton_count4", Long( ldwc_nmfcitem_suplm.GetitemString(i, "carton_count") ))					
					ls_carton_type4= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type4",ls_carton_type4)
					
					ld_Item_qty4= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty4",ld_item_qty4)
					
					ld_Weight4= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight4",ld_Weight4)

					if ldwc_nmfcitem_suplm.GetitemString(i,"hazard_tag") = 'HAZARDOUS' then
						adw_bol.SetItem(1,"hazmat_4",'X')
					end if

//					ls_nmfcdescription4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
//					ls_nmfcdescription4= ldwc_nmfcitem_suplm.GetitemString(i,"item_master_hazard_cd_commodity_cd")			// LTK 20151008
					ls_nmfcdescription4= ldwc_nmfcitem_suplm.GetitemString(i,"compute_commodity_description")			// LTK 20151008
					adw_bol.SetItem(1,"nmfcdescription4",ls_nmfcdescription4)
//					
//					ls_nmfc4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
//					adw_bol.SetItem(1,"nmfc4",ls_nmfc4)
//					
//					ls_class4= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
//					adw_bol.SetItem(1,"class4",ls_class4)
			ElseIf i = 5 Then
				//	ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")				
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					//adw_bol.SetItem(1,"carton_count5",ll_carton_count5)
					adw_bol.SetItem(1,"carton_count5", Long( ldwc_nmfcitem_suplm.GetitemString(i, "carton_count") ))					
					ls_carton_type5= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type5",ls_carton_type5)
					
					ld_Item_qty5= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty5",ld_item_qty5)
					
					ld_Weight5= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight5",ld_Weight5)
					
					if ldwc_nmfcitem_suplm.GetitemString(i,"hazard_tag") = 'HAZARDOUS' then				// LTK 20151008
						adw_bol.SetItem(1,"hazmat_5",'X')
					end if

//					ls_nmfcdescription5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
//					ls_nmfcdescription5= ldwc_nmfcitem_suplm.GetitemString(i,"item_master_hazard_cd_commodity_cd")			// LTK 20151008
					ls_nmfcdescription5= ldwc_nmfcitem_suplm.GetitemString(i,"compute_commodity_description")			// LTK 20151008
					adw_bol.SetItem(1,"nmfcdescription5",ls_nmfcdescription5)
					
//					ls_nmfc5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
//					adw_bol.SetItem(1,"nmfc5",ls_nmfc5)
//					
//					ls_class5= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
//					adw_bol.SetItem(1,"class5",ls_class5)
				End if
			Next			
			//Total of all Number of carton from all orders group by carton_no with multiple Item. Examp one order with multiple line and multple NMFC pack together in one pallet

			//14-Aug-2015 :Madhu- Added code to print Carton and Pallet count separetly on BOL - START
			//ll_total_carton_count= ldwc_nmfcitem_suplm.GetitemNumber(1, "total_carton_count")  //14-Aug-2015 :Madhu commented
			//adw_bol.SetItem(1,"total_carton_count", ll_total_carton_count ) //14-Aug-2015 :Madhu commented
			FOR  row =1 to ldwc_nmfcitem_suplm.rowcount( )
				lscarton_type =ldwc_nmfcitem_suplm.GetitemString(row, "cf_carton_type")
				
				CHOOSE CASE Upper(lscarton_type)
					CASE 'PALLET', 'PL','PLTS'
								ll_total_pallet_count += ldwc_nmfcitem_suplm.GetitemNumber(row, "cf_carton_countvisible")
								//adw_bol.SetItem(1,"total_pallet_count", ll_total_pallet_count )	// LTK 20151110
					CASE ELSE
								ll_total_carton_count += ldwc_nmfcitem_suplm.GetitemNumber(row, "cf_carton_countvisible")
								//adw_bol.SetItem(1,"total_carton_count", ll_total_carton_count )	// LTK 20151110			
					END CHOOSE
			Next
			
			// ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
			//14-Aug-2015 :Madhu- Added code to print Carton and Pallet count separetly on BOL - END
			
//			//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
//			ls_carton_type= ldwc_nmfcitem_suplm.GetitemString(1, "carton_type")
//			adw_bol.SetItem(1,"carton_type",ls_carton_type)
//			
			//Total Qty and total Weight by NMFC (Item_master)
			ld_total_item_qty=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_item_qty")
			adw_bol.SetItem(1,"total_item_qty",ld_total_item_qty)
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child			
			ld_total_net_w=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_net_w")
			adw_bol.SetItem(1,"total_net_w",ld_total_net_w)

			long ll_pack_count
			if w_do.idw_Pack.RowCount() > 0 then
				ll_pack_count = w_do.idw_Pack.GetItemNumber( 1, "c_carton_count")
			end if
			adw_bol.SetItem(1,"total_carton_count", ll_pack_count)

		End If //NMFC 
End If

// LTK 20151022  Always display this, suplement or no
//Total Qty and total Weight by NMFC (Item_master)
ld_total_item_qty=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_item_qty")
adw_bol.SetItem(1,"total_item_qty",ld_total_item_qty)

//Detail order Information--------------------------------------------------------------------------------------------------------------	
If	ll_detail_suplm_rowcount <=5 Then
	//For i = 1 to ll_detail_rowcount	
	For i = 1 to 	ll_detail_suplm_rowcount
		If i = 1 Then
				ls_cust_ord_nbr1= lds_detail_suplm.GetitemString(i,"cust_order_no")
				adw_bol.SetItem(1,"cust_ord_nbr1",ls_cust_ord_nbr1)
				
				ld_pack_qty1=lds_detail_suplm.GetitemDecimal(i, "pack_qty")
				//adw_bol.SetItem(1,"pack_qty1",ld_pack_qty1)
				
				ld_totalw1=lds_detail_suplm.GetitemDecimal(i, "total_weight")
				adw_bol.SetItem(1,"total_weight1",ld_totalw1)

//				ls_invoice_no1=lds_detail_suplm.GetitemString(i, "invoice_no")
//				adw_bol.SetItem(1,"invoice_no2",ls_invoice_no1)

				ls_carton_count = String( lds_detail_suplm.GetItemNumber(i, "carton_count") )
				//adw_bol.SetItem(1,"invoice_no1", ls_carton_count )		// using existing invoice col for carton count
				adw_bol.SetItem(1,"pack_qty1", Long(ls_carton_count))
				
		ElseIf i = 2 Then
				ls_cust_ord_nbr2= lds_detail_suplm.GetitemString(i,"cust_order_no")
				adw_bol.SetItem(1,"cust_ord_nbr2",ls_cust_ord_nbr2)
				
				ld_pack_qty2=lds_detail_suplm.GetitemDecimal(i, "pack_qty")
				//adw_bol.SetItem(1,"pack_qty2",ld_pack_qty2)
				
				ld_totalw2=lds_detail_suplm.GetitemDecimal(i, "total_weight")
				adw_bol.SetItem(1,"total_weight2",ld_totalw2)
					
//				ls_invoice_no2=lds_detail_suplm.GetitemString(i, "invoice_no")
//				adw_bol.SetItem(1,"invoice_no2",ls_invoice_no2)
				
				ls_carton_count = String( lds_detail_suplm.GetItemNumber(i, "carton_count") )
				//adw_bol.SetItem(1,"invoice_no2", ls_carton_count )		// using existing invoice col for carton count
				adw_bol.SetItem(1,"pack_qty2", Long(ls_carton_count))
				
				
		ElseIf i = 3 Then
				ls_cust_ord_nbr3= lds_detail_suplm.GetitemString(i,"cust_order_no")
				adw_bol.SetItem(1,"cust_ord_nbr3",ls_cust_ord_nbr3)
					
				ld_pack_qty3=lds_detail_suplm.GetitemDecimal(i, "pack_qty")
				//adw_bol.SetItem(1,"pack_qty3",ld_pack_qty3)
				
				ld_totalw3=lds_detail_suplm.GetitemDecimal(i, "total_weight")
				adw_bol.SetItem(1,"total_weight3",ld_totalw3)
				
//				ls_invoice_no3=lds_detail_suplm.GetitemString(i, "invoice_no")
//				adw_bol.SetItem(1,"invoice_no3",ls_invoice_no3)		
				
				ls_carton_count = String( lds_detail_suplm.GetItemNumber(i, "carton_count") )
				//adw_bol.SetItem(1,"invoice_no3", ls_carton_count )		// using existing invoice col for carton count
				adw_bol.SetItem(1,"pack_qty3", Long(ls_carton_count))

		ElseIf i = 4 Then
				ls_cust_ord_nbr4= lds_detail_suplm.GetitemString(i,"cust_order_no")
				adw_bol.SetItem(1,"cust_ord_nbr4",ls_cust_ord_nbr4)
				
				ld_pack_qty4=lds_detail_suplm.GetitemDecimal(i, "pack_qty")
				//adw_bol.SetItem(1,"pack_qty4",ld_pack_qty4)
				
				ld_totalw4=lds_detail_suplm.GetitemDecimal(i, "total_weight")
				adw_bol.SetItem(1,"total_weight4",ld_totalw4)
				
//				ls_invoice_no4=lds_detail_suplm.GetitemString(i, "invoice_no")
//				adw_bol.SetItem(1,"invoice_no4",ls_invoice_no4)
				
				ls_carton_count = String( lds_detail_suplm.GetItemNumber(i, "carton_count") )
				//adw_bol.SetItem(1,"invoice_no4", ls_carton_count )		// using existing invoice col for carton count
				adw_bol.SetItem(1,"pack_qty4",Long(ls_carton_count))

		ElseIf i = 5 Then	
				ls_cust_ord_nbr5= lds_detail_suplm.GetitemString(i,"cust_order_no")
				adw_bol.SetItem(1,"cust_ord_nbr5",ls_cust_ord_nbr2)
					
				ld_pack_qty5=lds_detail_suplm.GetitemDecimal(i, "pack_qty")
				//adw_bol.SetItem(1,"pack_qty5",ld_pack_qty5)
				
				ld_totalw5=lds_detail_suplm.GetitemDecimal(i, "total_weight")
				adw_bol.SetItem(1,"total_weight5",ld_totalw5)
				
//				ls_invoice_no5=lds_detail_suplm.GetitemString(i, "invoice_no")
//				adw_bol.SetItem(1,"invoice_no5",ls_invoice_no5)				
				
				ls_carton_count = String( lds_detail_suplm.GetItemNumber(i, "carton_count") )
				//adw_bol.SetItem(1,"invoice_no5", ls_carton_count )		// using existing invoice col for carton count
				adw_bol.SetItem(1,"pack_qty5",Long(ls_carton_count))

		End if
	Next	
	//Total Qty and total Weight by Order number
	ld_total_pack_qty=  lds_detail_suplm.GetitemDecimal(1,"total_pack_qty")  //sum of total pack qty
	ld_total_pack_weight= lds_detail_suplm.GetitemDecimal(1,"total_pack_weight")  //sum of total weight
	
	//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
	//always row 1 for ext dw assuming 1Master treating detail as child
	//adw_bol.SetItem(1,"total_pack_qty",ld_total_pack_qty)
	ld_total_carton_count = lds_detail_suplm.GetitemDecimal(1,"total_carton_count")
	adw_bol.SetItem(1,"total_pack_qty",ld_total_carton_count)
	adw_bol.SetItem(1,"total_pack_Weight",ld_total_pack_Weight)	
End If

// LTK 20160114  Copied following block to set Vics_Bol_No on order
//Jxlim 07/07/2013 End of SSCC for Bol and Vics value Pandora BRD 610   
String ls_vics_bol_no
ls_vics_bol_no =  w_do.idw_other.GetItemString(1,'vics_bol_no')

IF IsNull(ls_vics_bol_no) OR Trim(ls_vics_bol_no) = '' then
	ls_vics_bol_no = l_nwarehouse.of_get_sscc_bol(gs_project,'BOL_No')  //(use 17 digits)
	If ls_vics_bol_no = '' OR IsNull(ls_vics_bol_no) Then
		MessageBox ("Error", "There was a problem creating the SSCC Number.  Please check with support")
		Return 1
	Else
		//w_do.idw_other.setitem(1,'vics_bol_no',ls_vics_bol_no)    //This required calling safe; 
		//use embeded sql to update directly to db instead after generate the vics_bol_no to avoid hard refresh
		Execute Immediate "Begin Transaction" using SQLCA;
		Update dbo.Delivery_master
		Set Vics_Bol_no =:ls_vics_bol_no
		Where Project_id =:gs_Project and Do_no = :as_dono	
		Using SQLCA;
		Execute Immediate "COMMIT" using SQLCA;		
	End if				
	
	w_do.tab_main.tabpage_main.dw_main.SetItem(1,'vics_bol_no',ls_vics_bol_no)		// GailM 01/10/2014 Update main DW 
	w_do.idw_other.setitem(1,'vics_bol_no',ls_vics_bol_no)
End if
//set vics_bol_no to BOL report
adw_bol.setitem(1,'vics_bol_no',ls_vics_bol_no)    		
//Jxlim 07/07/2013 End of SSCC for Bol and Vics value	
// End of set Vics_Bol_No on order


String ls_page_count
long ll_pages = 1

If lb_suplm = True Then
	
	// LTK 20151022  Print new message if hazardous materials and supplemental page exists
	for i = 1 to ldwc_nmfcitem_suplm.RowCount()
		if ldwc_nmfcitem_suplm.GetitemString(i,"hazard_tag") = 'HAZARDOUS' then
			adw_bol.Object.ordercount_t.text = "Hazardous Material - See Attached Supplemental Page(s)"
			adw_bol.Object.nmfccount_t.text = "Hazardous Material - See Attached Supplemental Page(s)"
			exit
		end if
	next

	// Set the page count for the main page here by adding the supplemental pages to the count
	ls_page_count = lds_bol_suplm.Describe( "Evaluate('pagecount()', 1)")
	if IsNumber( ls_page_count ) then
		ll_pages = Long( ls_page_count ) + 1
	end if
	adw_bol.Object.t_page_count_display.text = 'Page: 1 of ' + String( ll_pages )

	//Print(lds_bol_suplm)	//no print dialog
	OpenWithParm(w_dw_print_options,lds_bol_suplm) //print dialog
Else
	adw_bol.Object.t_page_count_display.text = 'Page: 1 of ' + String( ll_pages )
End If

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetRedraw(true)

RETURN 1
end function

public subroutine uf_set_carrier_information (datawindowchild adwc_items);// TODO: implement...

Return
end subroutine

public function integer uf_is_pandora_hazmat_turned_on (string as_dono, string as_consolidation_no);// Hard Stop on BOL generation if DB flag is set and hazardous materials exist on order or within list of consolided orders

int li_return
li_return = 1

String ls_work, ls_sql_syntax_SKU, ERRORS
long ll_rows, i
boolean lb_use_hazard_cd_column	// if true, use IM.hazard_cd else use IM.UF11
datastore lds_sku_list

if f_retrieve_parm(gs_project, 'BOL_CHECK', 'VALIDATE_HAZARDOUS_MAT') = 'Y' then

	lds_sku_list = Create datastore

	if Len(Trim( as_consolidation_no )) > 0 then			
		ls_sql_syntax_SKU = 		" Select distinct sku, hazard_cd, user_field11 "
		ls_sql_syntax_SKU += 	" from item_master "
		ls_sql_syntax_SKU += 	" where project_id = '" + gs_project + "' " 
		ls_sql_syntax_SKU += 	" and sku in (Select SKU from delivery_detail Where do_no in "
		ls_sql_syntax_SKU +=	" (Select Do_No "
		ls_sql_syntax_SKU +=	" from Delivery_Master "
		ls_sql_syntax_SKU +=	" where Project_Id = '" + gs_project + "' "
		ls_sql_syntax_SKU +=	" and consolidation_no = '" + as_consolidation_no + "')) "

		lds_sku_list.Create(SQLCA.SyntaxFromSQL(ls_sql_syntax_SKU, "", ERRORS))
		if Len(Errors) > 0 then
			MessageBox(w_do.is_title, "*** Unable to create datastore for list of SKUs.~r~r" + ERRORS)
			return -1
		end if	
	else
		ls_sql_syntax_SKU = "Select distinct sku, hazard_cd, user_field11"
		ls_sql_syntax_SKU += " from item_master"
		ls_sql_syntax_SKU += " where project_id = 'PANDORA'"
		ls_sql_syntax_SKU += " and sku in(Select SKU from delivery_detail Where do_no = '" + as_dono + "')"
		lds_sku_list.Create(SQLCA.SyntaxFromSQL(ls_sql_syntax_SKU, "", ERRORS))
		if Len(Errors) > 0 then
			MessageBox(w_do.is_title, "*** Unable to create datastore for list of SKUs.~r~r" + ERRORS)
			return -1
		end if
	end if

	lds_sku_list.SetTransObject(SQLCA)	
	ll_rows = lds_sku_list.Retrieve()

	lb_use_hazard_cd_column = ( f_retrieve_parm(gs_project, 'BOL_CHECK', 'USE_IM_HAZARD_CD') = 'Y' )

	for i = 1 to ll_rows
		if lb_use_hazard_cd_column then
			ls_work = lds_sku_list.GetItemString( i, 'hazard_cd' )
		else
			ls_work = lds_sku_list.GetItemString( i, 'user_field11' )
		end if
	
		if NOT IsNull( ls_work ) and Len( Trim( ls_work ) ) > 0 then
			MessageBox(w_do.is_title, f_retrieve_parm(gs_project, 'BOL_CHECK', 'VALIDATION_ERROR_MESSAGE', 'USER_FIELD1' ))
			f_method_trace_special( gs_project, "w_do" + ' - ue_process_bol', 'Hazardous material found upon BOL generation, SKU: ' + lds_sku_list.GetItemString( i, 'sku' ) ,as_dono, ' ',' ','')
			return -1
		end if
	next

end if

return li_return
end function

public subroutine uf_set_sort (datawindowchild adwc_target);//	1. Set a sort column on the item DW:  DO_NO + Carton_No + H	// H for hazardous or N for non-hazardous
//	2. Sort the DW using the newly set sort column
//	3. Set the HU qty once for a carton (not on the sibling rows)

long i
int li_temp
String ls_sort_cd
boolean lb_hazardous

for i = 1 to adwc_target.RowCount()
	if Left( ls_sort_cd, Len( ls_sort_cd ) -1 ) <> Left( adwc_target.GetItemString( i, 'Sorting_Cd' ), ( Len( adwc_target.GetItemString( i, 'Sorting_Cd' )) - 1 ) ) then

		ls_sort_cd = Trim( adwc_target.GetItemString( i, 'Sorting_Cd' ) )

		//adwc_target.SetItem( i, 'Carton_Count', '1' )
		
		if Right( ls_sort_cd, 1 ) = 'H' then
			lb_hazardous = TRUE
		else
			lb_hazardous = FALSE			
		end if
	end if

	if lb_hazardous then
		adwc_target.SetItem( i, 'Sorting_Cd', '_' + adwc_target.GetItemString( i, 'Sorting_Cd' ) )
	end if
	
next

adwc_target.Sort()

// Need to set carton_count after the sort
ls_sort_cd = ""
for i = 1 to adwc_target.RowCount()
	if Left( ls_sort_cd, Len( ls_sort_cd ) -1 ) <> Left( adwc_target.GetItemString( i, 'Sorting_Cd' ), ( Len( adwc_target.GetItemString( i, 'Sorting_Cd' )) - 1 ) ) then
		ls_sort_cd = Trim( adwc_target.GetItemString( i, 'Sorting_Cd' ) )
		adwc_target.SetItem( i, 'Carton_Count', '1' )
	end if
next

end subroutine

public function integer uf_process_bol_rema (string as_dono, datawindow adw_bol);// GailM 03/13/2018 - S16749 F7146 I805 - Rema Foods-BOL Changes
int li_NbrRows, li_Row, li_y, li_offset
string ls_c_name,ls_c_add1,ls_c_add2,ls_c_add3,ls_c_add4,ls_c_city,ls_c_state,ls_c_zip
string ls_p_name,ls_p_add1,ls_p_add2,ls_p_add3,ls_p_add4,ls_p_city,ls_p_state,ls_p_zip
string ls_sku_lotno, ls_sku, ls_sku_prev, ls_qty
long ll_qty
DateTime	ldtToday
double ld_net_weight, ld_cube_weight, ld_gross_weight

li_offset = 20	//Line height offset 
ls_sku_prev = ''
ldtToday = DateTime(today(),Now())

	adw_bol.SetTransObject(SQLCA)
	
	li_NbrRows = adw_bol.Retrieve(gs_project, as_dono)
	adw_bol.setsort('sku A, lot_no A') 		
	adw_bol.sort()
	
	For li_Row = 1 to li_NbrRows
		ls_sku = adw_bol.GetItemString( li_Row, 'sku' )
		ll_qty = adw_bol.GetItemNumber( li_Row, 'qty' )
		ls_qty = right(space(5) + string(ll_qty), 5 )
		
		If ls_sku_prev = ls_sku Then
			ls_sku_lotno += "~r" + ls_qty + space(5) + adw_bol.GetItemString( li_row, 'lot_no' ) + space(5)  + adw_bol.GetItemString( li_row, 'production_code' )
			adw_bol.SetItem( li_Row -1, 'qty', adw_bol.GetItemNumber( li_Row -1, 'qty' ) + adw_bol.GetItemNumber( li_Row, 'qty' ) )
			adw_bol.SetItem( li_Row -1, 'SumGrossWgt', adw_bol.GetItemNumber( li_Row -1, 'SumGrossWgt' ) + adw_bol.GetItemNumber( li_Row, 'SumGrossWgt' ) )
			adw_bol.DeleteRow( li_Row )
			li_Row --
			li_NbrRows --
			
			adw_bol.SetItem( li_Row, 'offset', adw_bol.GetItemNumber( li_Row, 'offset' ) + 1 )

		Else
			ls_sku_lotno = ls_qty +  space(5) + adw_bol.GetItemString( li_row, 'lot_no' ) +  space(5)  + adw_bol.GetItemString( li_row, 'production_code' )
			adw_bol.SetItem( li_Row, 'offset', 1 )
		End If
		
		ls_sku_prev = ls_sku
		adw_bol.SetItem( li_Row, 'production_code', ls_sku_lotno )
		
		
		//Use DeliveryDate as ShipDate for Today's Date on BOL
		adw_bol.SetITem(li_Row,'delivery_master_delivery_date',ldtToday)
		
		// HardCode ShipFrom Address for Rema Foods BOL
		adw_bol.setItem(li_Row,"warehouse_wh_name","Rema Foods" )
		adw_bol.setItem(li_Row,"w_addr1","C/O Jacobson Warehouse Company, Inc" )
		adw_bol.setItem(li_Row,"w_addr2","DBA XPO Logistics" )
		adw_bol.setItem(li_Row,"w_addr3","2353 US Highway 130" )
		adw_bol.setItem(li_Row,"w_addr4","Dayton, NJ 08810" )
			
		//Roll City, State and Zip into customer address_4
		ls_c_city = adw_bol.getItemString(li_Row,"c_city")
		ls_c_state = adw_bol.getItemString(li_Row,"c_state")
		ls_c_zip = adw_bol.getItemString(li_Row,"c_zip")
		ls_c_add4 = ls_c_city + ", " + ls_c_state + " " + ls_c_zip
		adw_bol.setItem(li_Row,"c_addr4", ls_c_add4 )
		
		//HardCode Shipper/Consignor address for Rema Foods BOL
		adw_bol.setItem(li_Row,"p_addr1","REMA FOODS, INC." )
		//adw_bol.setItem(li_Row,"p_addr2","ATTN: ELLIOT SCHECK" )		//GailM 3/30/2018 Ops and Client requested Attn block be removed
		adw_bol.setItem(li_Row,"p_addr2","140 SYLVAN AVENUE" )
		adw_bol.setItem(li_Row,"p_addr3","ENGLEWOOD CLIFFS, NJ 07632" )
		
	Next

	adw_bol.setsort( "" ) 		
	adw_bol.sort()

//			li_Y = long( adw_bol.Describe( "l_15.Y1" ) )
//			adw_bol.Modify("l_15.Y1=" + string( li_Y + li_offset ) )
//			adw_bol.Modify("l_15.Y2=" + string( li_Y + li_offset ) )
//			adw_bol.Modify("l_22.Y2=" + string( li_Y + li_offset ) )
//			adw_bol.Modify("l_16.Y2=" + string( li_Y + li_offset ) )
//			adw_bol.Modify("l_17.Y2=" + string( li_Y + li_offset ) )
//			adw_bol.Modify("l_18.Y2=" + string( li_Y + li_offset ) )
//			adw_bol.Modify("l_19.Y2=" + string( li_Y + li_offset ) )
//			adw_bol.Modify("l_21.Y2=" + string( li_Y + li_offset ) )


//		//A stab at getting the SlideUp working properly
//		if isNull(adw_bol.getItemString(1,"c_addr2" ))  Then
//			adw_bol.object.c_addr2.height = "0"
//			adw_bol.object.c_addr2_1.height = "0"
//		End If
//		if isNull(adw_bol.getItemString(1,"c_addr3" ))  Then
//			adw_bol.object.c_addr3.height = "0"
//			adw_bol.object.c_addr3_1.height = "0"
//		End If
//		
//		adw_bol.object.c_addr4_1.y = 988
//		adw_bol.setItem(1,"seal_nbr","addr4.y=" + string( adw_bol.object.c_addr4_1.y )  )


RETURN  1
end function

public function integer uf_process_bol_rema_combined (string as_dono, datawindow adw_bol);//04-MAY-2018 :Madhu S18653 - Rema Back/Duplicate Order Process
//Print Combined BOL

int li_NbrRows, li_Row, li_y, li_offset
string ls_c_name,ls_c_add1,ls_c_add2,ls_c_add3,ls_c_add4,ls_c_city,ls_c_state,ls_c_zip
string ls_p_name,ls_p_add1,ls_p_add2,ls_p_add3,ls_p_add4,ls_p_city,ls_p_state,ls_p_zip
string ls_sku_lotno, ls_sku, ls_sku_prev, ls_qty
long ll_qty
DateTime	ldtToday
double ld_net_weight, ld_cube_weight, ld_gross_weight

li_offset = 20	//Line height offset 
ls_sku_prev = ''
ldtToday = DateTime(today(),Now())

adw_bol.SetTransObject(SQLCA)

li_NbrRows = adw_bol.Retrieve(gs_project, as_dono)
adw_bol.setsort('sku A, lot_no A') 		
adw_bol.sort()

For li_Row = 1 to li_NbrRows
	ls_sku = adw_bol.GetItemString( li_Row, 'sku' )
	ll_qty = adw_bol.GetItemNumber( li_Row, 'qty' )
	ls_qty = right(space(5) + string(ll_qty), 5 )
	
	If ls_sku_prev = ls_sku Then
		ls_sku_lotno += "~r" + ls_qty + space(5) + adw_bol.GetItemString( li_row, 'lot_no' ) + space(5)  + adw_bol.GetItemString( li_row, 'production_code' )
		adw_bol.SetItem( li_Row -1, 'qty', adw_bol.GetItemNumber( li_Row -1, 'qty' ) + adw_bol.GetItemNumber( li_Row, 'qty' ) )
		adw_bol.SetItem( li_Row -1, 'SumGrossWgt', adw_bol.GetItemNumber( li_Row -1, 'SumGrossWgt' ) + adw_bol.GetItemNumber( li_Row, 'SumGrossWgt' ) )
		adw_bol.DeleteRow( li_Row )
		li_Row --
		li_NbrRows --
		
		adw_bol.SetItem( li_Row, 'offset', adw_bol.GetItemNumber( li_Row, 'offset' ) + 1 )
	
	Else
		ls_sku_lotno = ls_qty +  space(5) + adw_bol.GetItemString( li_row, 'lot_no' ) +  space(5)  + adw_bol.GetItemString( li_row, 'production_code' )
		adw_bol.SetItem( li_Row, 'offset', 1 )
	End If
	
	ls_sku_prev = ls_sku
	adw_bol.SetItem( li_Row, 'production_code', ls_sku_lotno )
	
	
	//Use DeliveryDate as ShipDate for Today's Date on BOL
	adw_bol.SetITem(li_Row,'delivery_master_delivery_date',ldtToday)
	
	// HardCode ShipFrom Address for Rema Foods BOL
	adw_bol.setItem(li_Row,"warehouse_wh_name","Rema Foods" )
	adw_bol.setItem(li_Row,"w_addr1","C/O Jacobson Warehouse Company, Inc" )
	adw_bol.setItem(li_Row,"w_addr2","DBA XPO Logistics" )
	adw_bol.setItem(li_Row,"w_addr3","2353 US Highway 130" )
	adw_bol.setItem(li_Row,"w_addr4","Dayton, NJ 08810" )
	
	//Roll City, State and Zip into customer address_4
	ls_c_city = adw_bol.getItemString(li_Row,"c_city")
	ls_c_state = adw_bol.getItemString(li_Row,"c_state")
	ls_c_zip = adw_bol.getItemString(li_Row,"c_zip")
	ls_c_add4 = ls_c_city + ", " + ls_c_state + " " + ls_c_zip
	adw_bol.setItem(li_Row,"c_addr4", ls_c_add4 )
	
	//HardCode Shipper/Consignor address for Rema Foods BOL
	adw_bol.setItem(li_Row,"p_addr1","REMA FOODS, INC." )
	adw_bol.setItem(li_Row,"p_addr2","140 SYLVAN AVENUE" )
	adw_bol.setItem(li_Row,"p_addr3","ENGLEWOOD CLIFFS, NJ 07632" )

Next

adw_bol.setsort( "" ) 		
adw_bol.sort()

RETURN  1
end function

public function integer uf_process_bol_cree_singleorder (string as_dono, ref datawindow adw_bol);//TAM 06/20/2018 - S20314 -  Vics bol for single order
//For single order with single NMFC code use inline report query (d_vics_bol_prt_singleorder)
//For single order with multple NMFC code use external datawindow report and:
//1. Write the information line by line up to 5 rows
//2. If more than 5 NMFC code on a single order then print Carrier Information supplemental page
Long   i, ll_bol_rowcount,ll_detailrowcount, ll_nmfc_suplm_rowcount, ll_detail_rowcount, ll_nmfc_rowcount, ll_alt_address_rowcount, ll_nmfc_carton_rowcount
Long   ll_carton_count1, ll_carton_count2,ll_carton_count3,ll_carton_count4,ll_carton_count5,ll_total_carton_count,ll_bol_suplm
String ls_custcode,ls_custname, ls_carton_type
Decimal ld_Pack_qty1,ld_Pack_qty2,ld_Pack_qty3,ld_Pack_qty4,ld_Pack_qty5
Decimal ld_total_item_qty, ld_total_pack_qty
Decimal ld_weight1,ld_weight2,ld_weight3,ld_weight4,ld_weight5, ld_total_net_w, ld_total_pack_weight
Decimal ld_totalw1, ld_totalw2,ld_totalw3,ld_totalw4,ld_totalw5
String ls_carton_type1, ls_carton_type2, ls_carton_type3, ls_carton_type4, ls_carton_type5
String ls_nmfcdescription1, ls_nmfcdescription2,ls_nmfcdescription3,ls_nmfcdescription4,ls_nmfcdescription5, ls_nmfc1,ls_nmfc2,ls_nmfc3,ls_nmfc4,ls_nmfc5
String ls_class1,ls_class2,ls_class3,ls_class4,ls_class5
String ls_cust_ord_nbr1,ls_cust_ord_nbr2,ls_cust_ord_nbr3,ls_cust_ord_nbr4,ls_cust_ord_nbr5
String ls_invoice_no1, ls_invoice_no2,  ls_invoice_no3, ls_invoice_no4, ls_invoice_no5
Decimal ld_item_qty1,ld_item_qty2,ld_item_qty3,ld_item_qty4,ld_item_qty5
DataStore lds_bol_singleorder_header,lds_bol_singleorder_detail
Boolean lb_suplm

lb_suplm = False

//03-Jan-2014 :Madhu -Added code to verify whether all serial no's are scanned? -START
Long 	llpackqty,llscannedqty ,llserialcnt,lleligiblecnt

//get eligible records for scanning
// TAM 2014/01/15 - Changed from Count to Sum.  Not all items are scannable and we only want to compare the number of Scannable with the number of serials
//select count(*) into :lleligiblecnt from Delivery_Packing,Item_Master
select sum(Quantity) into :lleligiblecnt from Delivery_Packing,Item_Master
where Delivery_Packing.SKU = Item_Master.SKU
and Delivery_Packing.DO_No= :as_dono
and Delivery_Packing.Supp_Code=Item_Master.Supp_Code
and Item_Master.Serialized_Ind in ('Y','B')
using SQLCA;

If lleligiblecnt >0 Then
//TAM	Select sum(Quantity) into :llpackqty from Delivery_Packing where Do_No =:as_dono using SQLCA;
	Select Sum(quantity) into :llScannedQty from delivery_serial_detail Where Id_no in (select id_no from delivery_picking_detail where do_no = :as_dono) using SQLCA;
	
	If IsNull(llScannedQty) then 
		llScannedQty =0 
	end if
	
// TAM	If llpackqty <> llScannedQty Then
	If lleligiblecnt <> llScannedQty Then
		MessageBox(w_do.is_title,"All Serial no's are not being scanned. Please check.",Stopsign!)
		Return 0
	End if 
End if 

//03-Jan-2014 :Madhu - Added code to verify whether all serial no's are scanned? -END

//Datastore for Report header section
lds_bol_singleorder_header = create datastore
lds_bol_singleorder_header.dataobject = 'd_vics_bol_prt_singleorder_header'
lds_bol_singleorder_header.SetTransObject(SQLCA)
lds_bol_singleorder_header.Retrieve(gs_project, as_dono)

//Datastore for Report header section
lds_bol_singleorder_detail = create datastore
lds_bol_singleorder_detail.dataobject = 'd_vics_bol_prt_singleorder_detail'
lds_bol_singleorder_detail.SetTransObject(SQLCA)
lds_bol_singleorder_detail.Retrieve(gs_project, as_dono)
ll_detailrowcount=lds_bol_singleorder_detail.rowcount()

//Suplemental page
DatawindowChild ldwc_nmfcitem_suplm
Datastore lds_bol_suplm
lds_bol_suplm = Create datastore
lds_bol_suplm.dataobject = 'd_vics_bol_prt_singleorder_suplm_composite_rpt'   //composite report

lds_bol_suplm.GetChild('dw_single_nmfcitem_suplm', ldwc_nmfcitem_suplm)
ldwc_nmfcitem_suplm.SetTransObject(SQLCA)	
ldwc_nmfcitem_suplm.Retrieve(gs_project, as_dono)
ll_nmfc_suplm_rowcount=ldwc_nmfcitem_suplm.Rowcount()

adw_bol.SetTransObject(SQLCA)
adw_bol.Retrieve(gs_project, as_dono) 
ll_bol_rowcount= adw_bol.Rowcount()

//If more than 1 row use external dw otherwise use inline sql on report (d_vics_bol_prt_singleorder)
If ll_bol_rowcount > 1 Then 
	adw_bol.dataobject = 'd_cree_bol_prt_combine_ext'
	//Jxlim Insert row to begin for external dw
	adw_bol.InsertRow(0)
	//Header Info
		//Using  lds_bol_singleorder_header datastore for Header section
		//Ship From address from Warehouse Table
	
		//adw_bol.SetItem(1,"wh_code",  lds_bol_singleorder_header.GetitemString(1, "wh_code"))
		adw_bol.SetItem(1,"wh_name", lds_bol_singleorder_header.GetitemString(1, "wh_Name"))
		adw_bol.SetItem(1,"wh_addr1", lds_bol_singleorder_header.GetitemString(1,"wh_Addr1" ))  
		adw_bol.SetItem(1,"wh_addr2", lds_bol_singleorder_header.GetitemString(1,"wh_Addr2" ))   
		adw_bol.SetItem(1,"wh_addr3", lds_bol_singleorder_header.GetitemString(1,"wh_Addr3"))    
		adw_bol.SetItem(1,"wh_addr4", lds_bol_singleorder_header.GetitemString(1,"wh_Addr4" ))   
		adw_bol.SetItem(1,"wh_city", lds_bol_singleorder_header.GetitemString(1,"wh_City" ))  
		adw_bol.SetItem(1,"wh_state", lds_bol_singleorder_header.GetitemString(1,"wh_State" ))     
		adw_bol.SetItem(1,"wh_zip", lds_bol_singleorder_header.GetitemString(1,"wh_Zip" ))    
		
		//Ship To from Delivery_Master Table
		adw_bol.SetItem(1,"cust_code",  lds_bol_singleorder_header.GetitemString(1, "Cust_code"))
		adw_bol.SetItem(1,"cust_name", lds_bol_singleorder_header.GetitemString(1, "Cust_Name"))
		adw_bol.SetItem(1,"cust_addr1", lds_bol_singleorder_header.GetitemString(1,"Address_1" ))  
		adw_bol.SetItem(1,"cust_addr2", lds_bol_singleorder_header.GetitemString(1,"Address_2" ))   
		adw_bol.SetItem(1,"cust_addr3", lds_bol_singleorder_header.GetitemString(1,"Address_3"))    
		adw_bol.SetItem(1,"cust_addr4", lds_bol_singleorder_header.GetitemString(1,"Address_4" ))   
		adw_bol.SetItem(1,"cust_city", lds_bol_singleorder_header.GetitemString(1,"City" ))  
		adw_bol.SetItem(1,"cust_state", lds_bol_singleorder_header.GetitemString(1,"State" ))     
		adw_bol.SetItem(1,"cust_zip", lds_bol_singleorder_header.GetitemString(1,"Zip" ))    
		adw_bol.SetItem(1,"contact_person", lds_bol_singleorder_header.GetitemString(1,"Contact_person"  ))  
		adw_bol.SetItem(1,"tel", lds_bol_singleorder_header.GetitemString(1,"Tel"  ))  
		adw_bol.SetItem(1,"cust_country", lds_bol_singleorder_header.GetitemString(1,"Country"  ))  //07-Apr-2015 Madhu Added customer Country
		adw_bol.SetItem(1,"shipping_instr", lds_bol_singleorder_header.GetitemString(1,"shipping_instr"))  
		adw_bol.SetItem(1,"awb_bol_no", lds_bol_singleorder_header.GetitemString(1,"awb_bol_no"  ))  
		//adw_bol.SetItem(1,"consl_no", lds_bol_singleorder_header.GetitemString(1,"consolidation_no"  ))   //There won't be consolidation_no for single order
		adw_bol.SetItem(1,"trailer_no", lds_bol_singleorder_header.GetitemString(1,"Trailer_no"  ))  		 //DM.user_field2		
		adw_bol.SetItem(1,"pro_no", lds_bol_singleorder_header.GetitemString(1,"Carrier_Pro_No"  )) 	//DM.user_field7  Jxlim 04/02/2014 Replaced with carrier_pro_no name field
		adw_bol.SetItem(1,"scac", lds_bol_singleorder_header.GetitemString(1,"scac"  ))  					// Carrier_Master.Carrier_code first 4 digits
		adw_bol.SetItem(1,"Carrier", lds_bol_singleorder_header.GetitemString(1,"carrier"  ))  					// Carrier_Master.Carrier_code 
		adw_bol.SetItem(1,"Freight_Terms", lds_bol_singleorder_header.GetitemString(1,"Freight_Terms"  )) //Frieght_terms, X mark visible based on frieght_terms 		
		
		//for singleorder this should always be 1 row, who now cree will have multple cust code for one order
		//Order information--------------------------------------------------------------------------------------------------			
		If	ll_detailrowcount <=5 Then
			//For i = 1 to ll_detail_rowcount	
			For i = 1 to 	ll_detailrowcount
				If i = 1 Then
						ls_cust_ord_nbr1= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr1",ls_cust_ord_nbr1)
						
						ld_pack_qty1=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty1",ld_pack_qty1)
						
						ld_totalw1=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight1",ld_totalw1)
							
						ls_invoice_no1=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no1",ls_invoice_no1)
						
				ElseIf i = 2 Then
						ls_cust_ord_nbr2= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr2",ls_cust_ord_nbr2)
						
						ld_pack_qty2=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty2",ld_pack_qty2)
						
						ld_totalw2=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight2",ld_totalw2)
							
						ls_invoice_no2=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no2",ls_invoice_no2)
						
				ElseIf i = 3 Then
						ls_cust_ord_nbr3= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr3",ls_cust_ord_nbr3)
							
						ld_pack_qty3=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty3",ld_pack_qty3)
						
						ld_totalw3=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight3",ld_totalw3)
						
						ls_invoice_no3=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no3",ls_invoice_no3)		
						  
				ElseIf i = 4 Then
						ls_cust_ord_nbr4= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr",ls_cust_ord_nbr4)
						
						ld_pack_qty4=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty4",ld_pack_qty4)
						
						ld_totalw4=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight4",ld_totalw4)
						
						ls_invoice_no4=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no4",ls_invoice_no4)
				ElseIf i = 5 Then	
						ls_cust_ord_nbr5= lds_bol_singleorder_detail.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr2",ls_cust_ord_nbr2)
							
						ld_pack_qty5=lds_bol_singleorder_detail.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty5",ld_pack_qty5)
						
						ld_totalw5=lds_bol_singleorder_detail.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight5",ld_totalw5)
						
						ls_invoice_no5=lds_bol_singleorder_detail.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no5",ls_invoice_no5)				
				End if
			Next	
			//Total Qty and total Weight by Order number
			ld_total_pack_qty=  lds_bol_singleorder_detail.GetitemDecimal(1,"total_pack_qty")  //sum of total pack qty
			ld_total_pack_weight= lds_bol_singleorder_detail.GetitemDecimal(1,"total_pack_weight")  //sum of total weight
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child
			adw_bol.SetItem(1,"total_pack_qty",ld_total_pack_qty)
			adw_bol.SetItem(1,"total_pack_Weight",ld_total_pack_Weight)	
		End If
			
		//Carrier Information --NMFC--------------------------------------------------------------------------------------------------------------		
		If ll_nmfc_suplm_rowcount <= 5  Then
			For i = 1 to ll_nmfc_suplm_rowcount	
			If i = 1 Then				
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count1",ll_carton_count1)
					ls_carton_type1= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")					
					adw_bol.SetItem(1,"carton_type1",ls_carton_type1)
					
					ld_Item_qty1= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty1",ld_item_qty1)
					
					ld_Weight1= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight1",ld_Weight1)
					
					ls_nmfcdescription1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription1",ls_nmfcdescription1)
					
					ls_nmfc1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc1",ls_nmfc1)
					
					ls_class1= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class1",ls_class1)
					
			ElseIf i = 2 Then		
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")					
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count2",ll_carton_count2)
					ls_carton_type2= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type2",ls_carton_type2)
					
					ld_Item_qty2= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty2",ld_item_qty2)
					
					ld_Weight2= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight2",ld_Weight2)
					
					ls_nmfcdescription2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription2",ls_nmfcdescription2)
					
					ls_nmfc2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc2",ls_nmfc2)
					
					ls_class2= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class2",ls_class2)
					
			ElseIf i = 3 Then
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count3",ll_carton_count3)
					ls_carton_type3= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type3",ls_carton_type3)
					
					ld_Item_qty3= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty3",ld_item_qty3)
					
					ld_Weight3= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight3",ld_Weight3)
					
					ls_nmfcdescription3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription3",ls_nmfcdescription3)
					
					ls_nmfc3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc3",ls_nmfc3)
					
					ls_class3= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class3",ls_class3)
					
			ElseIf i = 4 Then
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count4 =ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count4",ll_carton_count4)
					ls_carton_type4= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type4",ls_carton_type4)
					
					ld_Item_qty4= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty4",ld_item_qty4)
					
					ld_Weight4= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight4",ld_Weight4)
					
					ls_nmfcdescription4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription4",ls_nmfcdescription4)
					
					ls_nmfc4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc4",ls_nmfc4)
					
					ls_class4= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class4",ls_class4)
			ElseIf i = 5 Then
				//	ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count5",ll_carton_count5)
					ls_carton_type5= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type5",ls_carton_type5)
					
					ld_Item_qty5= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty5",ld_item_qty5)
					
					ld_Weight5= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight5",ld_Weight5)
					
					ls_nmfcdescription5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription5",ls_nmfcdescription5)
					
					ls_nmfc5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc5",ls_nmfc5)
					
					ls_class5= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class5",ls_class5)
				End if
			Next			
			//Total of all Number of carton from all orders group by carton_no with multiple Item. Examp one order with multiple line and multple NMFC pack together in one pallet
			ll_total_carton_count= ldwc_nmfcitem_suplm.GetitemNumber(1, "total_carton_count") 
			adw_bol.SetItem(1,"total_carton_count", ll_total_carton_count )
			
			//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
//			ls_carton_type= ldwc_nmfcitem_suplm.GetitemString(1, "carton_type")
//			adw_bol.SetItem(1,"carton_type",ls_carton_type)
			
			//Total Qty and total Weight by NMFC (Item_master)
			ld_total_item_qty=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_item_qty")
			adw_bol.SetItem(1,"total_item_qty",ld_total_item_qty)
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child			
			ld_total_net_w=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_net_w")
			adw_bol.SetItem(1,"total_net_w",ld_total_net_w)
		End If //NMFC 	
End If //End for external dw report
	
//Cree Third party add on BOL is Bill To (BT address type)
//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss
DataStore lds_bol_alt_address
Long ll_alt_addr_count
lds_bol_alt_address = create datastore
lds_bol_alt_address.dataobject = 'd_do_address_alt'
lds_bol_alt_address.SetTransObject(SQLCA)
lds_bol_alt_address.Retrieve(as_dono, 'BT')  //as_dono asType=BT (Bill To for BOL) --3P is for Trax/Third Party
ll_alt_addr_count=lds_bol_alt_address.Rowcount()

//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss --BOL third party address uses Bill TO ('BT') address type			
		If	ll_alt_addr_count > 0 Then	
			adw_bol.SetItem(1, "alt_name", lds_bol_alt_address.GetItemString(1, "name"))		
			adw_bol.SetItem(1, "alt_addr1", lds_bol_alt_address.GetItemString(1, "address_1"))
			adw_bol.SetItem(1, "alt_addr2", lds_bol_alt_address.GetItemString(1, "address_2"))
			adw_bol.SetItem(1, "alt_addr3", lds_bol_alt_address.GetItemString(1, "address_3"))
			adw_bol.SetItem(1, "alt_addr4", lds_bol_alt_address.GetItemString(1, "address_4"))
			adw_bol.SetItem(1, "alt_city",    lds_bol_alt_address.GetItemString(1, "city"))
			adw_bol.SetItem(1, "alt_state",  lds_bol_alt_address.GetItemString(1, "state"))
			adw_bol.SetItem(1, "alt_zip",     lds_bol_alt_address.GetItemString(1, "zip"))
		End If

//If NMFC more than 5 rows print supplemental page
If 	ll_nmfc_suplm_rowcount > 5 Then
	adw_bol.SetItem(1, "nmfc_count",  ll_nmfc_suplm_rowcount)
   	lb_suplm = True
	//Print(lds_bol_suplm)	//no print dialog
	OpenWithParm(w_dw_print_options,lds_bol_suplm) //print dialog
End If

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetRedraw(true)

RETURN 1
end function

public function integer uf_process_bol_cree_combined (string as_dono, ref datawindow adw_bol);//TAM  06/20/2018 S20314 - Cree Vics BOL up to 5 orders
//This is an external datawindow useb by manipulating datastores to produce a combine Vics BOL up to 5 detail/NMFC rows
//to fit into one single page of International standard Vics BOL.  (Strickly no extra page).  
//In the event that the order exist 5 rows, a supplement page will be created to handle this and it will be a separate code from this.
//This Vics BOL is officially name a Single page Vics BOL requested by Cree.
//This report contains:
//1. Header warehouse and order master, carrier from delivery_master and warehouse and Carrier_Master
//2. Third party address from Delivery_alt_address where address_type ='BT'
//Created a new datawindow for delivery alt address based on consolidation_no since we may have multiple do_no. 
//Baseline should be able to fulfill this however, 
//since we already have the consolidation_no variable within this code it is easier to just retrieve based on consolidation_no.
//The existing baseline third party address datawindow is based on do_no
//Customer Order Information and Carrier Information have to separate into 2 different query although they are source from the same table.
//This is because Customer detail required to group by order and Carrier information required to group by item.
//3. group by order: Order information detail from Delivery Master and Packing; and the weight is getting from item_master.weight_1
//--Total Packing Weight = Sum(Delivery_Packing.Qty * Item_Master.Weight_1)	
//4. group by NMFC: Carrier Information from Item_Master and Number of carton_no (count of carton_no) from delivery_packing 
//--Total item Weight = Sum(Delivery_Packing.Qty * Item_Master.Weight_1)	
//This is done through group by NMFC not carton_no
//If an order with 2 different NMFC code (2 Items) pack into one pallet together
//then the carton_no should show only 1 pallet this is done through group by carton_no
//supplmental detail and nmfc datawindow will be used regradless 5 or less orders in a shipment

Long   i, ll_consl_rowcount,	ll_detail_suplm_rowcount, ll_nmfc_suplm_rowcount, ll_detail_rowcount, ll_nmfc_rowcount, ll_alt_address_rowcount, ll_nmfc_carton_rowcount
Long   ll_carton_count1, ll_carton_count2,ll_carton_count3,ll_carton_count4,ll_carton_count5,ll_total_carton_count,ll_bol_suplm
String ls_custcode,ls_custname, ls_carton_type
Decimal ld_Pack_qty1,ld_Pack_qty2,ld_Pack_qty3,ld_Pack_qty4,ld_Pack_qty5
Decimal ld_total_item_qty, ld_total_pack_qty
Decimal ld_weight1,ld_weight2,ld_weight3,ld_weight4,ld_weight5, ld_total_net_w, ld_total_pack_weight
Decimal ld_totalw1, ld_totalw2,ld_totalw3,ld_totalw4,ld_totalw5
String ls_carton_type1,ls_carton_type2,ls_carton_type3,ls_carton_type4,ls_carton_type5
String ls_nmfcdescription1, ls_nmfcdescription2,ls_nmfcdescription3,ls_nmfcdescription4,ls_nmfcdescription5, ls_nmfc1,ls_nmfc2,ls_nmfc3,ls_nmfc4,ls_nmfc5
String ls_class1,ls_class2,ls_class3,ls_class4,ls_class5
String ls_cust_ord_nbr1,ls_cust_ord_nbr2,ls_cust_ord_nbr3,ls_cust_ord_nbr4,ls_cust_ord_nbr5
String ls_invoice_no1, ls_invoice_no2,  ls_invoice_no3, ls_invoice_no4, ls_invoice_no5
Decimal ld_item_qty1,ld_item_qty2,ld_item_qty3,ld_item_qty4,ld_item_qty5
Datawindowchild ldwc_detail_suplm,ldwc_nmfcitem_suplm
Boolean lb_suplm

n_warehouse l_nwarehouse  //Jxlim 07/08/2013 SSCC fo BOL and VICS
l_nwarehouse		= Create n_warehouse

lb_suplm=False

//03-Jan-2014 :Madhu -Added code to verify whether all serial no's are scanned? -START
Long 	llpackqty,llscannedqty ,llserialcnt,lleligiblecnt

//get eligible records for scanning
// TAM 2014/01/15 - Changed from Count to Sum.  Not all items are scannable and we only want to compare the number of Scannable with the number of serials
//select count(*) into :lleligiblecnt from Delivery_Packing,Item_Master
select sum(Quantity) into :lleligiblecnt from Delivery_Packing,Item_Master
where Delivery_Packing.SKU = Item_Master.SKU
and Delivery_Packing.DO_No= :as_dono
and Item_Master.Serialized_Ind in ('Y','B')
using SQLCA;

If lleligiblecnt >0 Then
//TAM	Select sum(Quantity) into :llpackqty from Delivery_Packing where Do_No =:as_dono using SQLCA;
	Select Sum(quantity) into :llScannedQty from delivery_serial_detail Where Id_no in (select id_no from delivery_picking_detail where do_no = :as_dono) using SQLCA;
	
	If IsNull(llScannedQty) then 
		llScannedQty =0 
	end if
	
//TAM 	If llpackqty <> llScannedQty Then
	If lleligiblecnt <> llScannedQty Then
		MessageBox(w_do.is_title,"All Serial no's are not being scanned. Please check.",Stopsign!)
		Return 0
	End if 
End if 

//03-Jan-2014 :Madhu - Added code to verify whether all serial no's are scanned? -END

//Jxlim; Created data store to Retrieve report contains, then get the value from this datastore to set it to ext dw
Datastore  lds_bol_suplm,lds_bol_combine_header, lds_bol_combine_alt_address
Datastore  lds_nmfc_carton_count, ldwc_detail_suplm_suplm

//Jxlim; may not need this datastore but for now 
//Datastore for Report header section
lds_bol_combine_header = create datastore
lds_bol_combine_header.dataobject = 'd_vics_bol_prt_combined_header'
lds_bol_combine_header.SetTransObject(SQLCA)
lds_bol_combine_header.Retrieve(gs_project, as_dono)
ll_consl_rowcount = lds_bol_combine_header.Rowcount()

//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss
lds_bol_combine_alt_address = create datastore
lds_bol_combine_alt_address.dataobject = 'd_vics_bol_prt_combined_alt_address'
lds_bol_combine_alt_address.SetTransObject(SQLCA)
lds_bol_combine_alt_address.Retrieve(gs_project, as_dono, 'BT')  //as_dono(consolidation No) asType=BT (Bill To for BOL) --3P is for Trax/Third Party
ll_alt_address_rowcount=lds_bol_combine_alt_address.Rowcount()

lds_bol_suplm = Create datastore
lds_bol_suplm.dataobject = 'd_vics_bol_prt_combined_suplm_composite_rpt'

lds_bol_suplm.GetChild('dw_detail_suplm', ldwc_detail_suplm)
ldwc_detail_suplm.SetTransObject(SQLCA)	
ldwc_detail_suplm.Retrieve(gs_project, as_dono)
ll_detail_suplm_rowcount=ldwc_detail_suplm.RowCount()

lds_bol_suplm.GetChild('dw_nmfcitem_suplm', ldwc_nmfcitem_suplm)
ldwc_nmfcitem_suplm.SetTransObject(SQLCA)	
ldwc_nmfcitem_suplm.Retrieve(gs_project, as_dono)
ll_nmfc_suplm_rowcount=ldwc_nmfcitem_suplm.Rowcount()


//Jxlim Insert row to begin for external dw
adw_bol.InsertRow(0)
//Header Info
		//Using  lds_bol_combine_header datastore for Header section
		//Ship From address from Warehouse Table
	
		//adw_bol.SetItem(1,"wh_code",  lds_bol_combine_header.GetitemString(1, "wh_code"))
		adw_bol.SetItem(1,"wh_name", lds_bol_combine_header.GetitemString(1, "wh_Name"))
		adw_bol.SetItem(1,"wh_addr1", lds_bol_combine_header.GetitemString(1,"wh_Addr1" ))  
		adw_bol.SetItem(1,"wh_addr2", lds_bol_combine_header.GetitemString(1,"wh_Addr2" ))   
		adw_bol.SetItem(1,"wh_addr3", lds_bol_combine_header.GetitemString(1,"wh_Addr3"))    
		adw_bol.SetItem(1,"wh_addr4", lds_bol_combine_header.GetitemString(1,"wh_Addr4" ))   
		adw_bol.SetItem(1,"wh_city", lds_bol_combine_header.GetitemString(1,"wh_City" ))  
		adw_bol.SetItem(1,"wh_state", lds_bol_combine_header.GetitemString(1,"wh_State" ))     
		adw_bol.SetItem(1,"wh_zip", lds_bol_combine_header.GetitemString(1,"wh_Zip" ))    
		
		//Ship To from Delivery_Master Table
		adw_bol.SetItem(1,"cust_code",  lds_bol_combine_header.GetitemString(1, "Cust_code"))
		adw_bol.SetItem(1,"cust_name", lds_bol_combine_header.GetitemString(1, "Cust_Name"))
		adw_bol.SetItem(1,"cust_addr1", lds_bol_combine_header.GetitemString(1,"Address_1" ))  
		adw_bol.SetItem(1,"cust_addr2", lds_bol_combine_header.GetitemString(1,"Address_2" ))   
		adw_bol.SetItem(1,"cust_addr3", lds_bol_combine_header.GetitemString(1,"Address_3"))    
		adw_bol.SetItem(1,"cust_addr4", lds_bol_combine_header.GetitemString(1,"Address_4" ))   
		adw_bol.SetItem(1,"cust_city", lds_bol_combine_header.GetitemString(1,"City" ))  
		adw_bol.SetItem(1,"cust_state", lds_bol_combine_header.GetitemString(1,"State" ))     
		adw_bol.SetItem(1,"cust_zip", lds_bol_combine_header.GetitemString(1,"Zip" ))    
		adw_bol.SetItem(1,"cust_country", lds_bol_combine_header.GetitemString(1,"Country"  ))  //29-Sep-2015 Madhu Added customer Country
		adw_bol.SetItem(1,"contact_person", lds_bol_combine_header.GetitemString(1,"Contact_person"  ))  
		adw_bol.SetItem(1,"tel", lds_bol_combine_header.GetitemString(1,"Tel"  ))  
		adw_bol.SetItem(1,"shipping_instr", lds_bol_combine_header.GetitemString(1,"shipping_instr"))  
		adw_bol.SetItem(1,"awb_bol_no", lds_bol_combine_header.GetitemString(1,"awb_bol_no"  ))  
		adw_bol.SetItem(1,"consl_no", lds_bol_combine_header.GetitemString(1,"consolidation_no"  ))  
		adw_bol.SetItem(1,"trailer_no", lds_bol_combine_header.GetitemString(1,"Trailer_no"  ))  		 //DM.user_field2
		adw_bol.SetItem(1,"pro_no", lds_bol_combine_header.GetitemString(1,"Carrier_Pro_No"  )) 	//DM.user_field7  Jxlim 04/02/2014 Replaced with carrier_pro_no name field
		adw_bol.SetItem(1,"scac", lds_bol_combine_header.GetitemString(1,"scac"  ))  					// Carrier_Master.Carrier_code first 4 digits
		adw_bol.SetItem(1,"Freight_Terms", lds_bol_combine_header.GetitemString(1,"Freight_Terms"  )) //Frieght_terms, X mark visible based on frieght_terms 		
		
		//Header Third Party alt address(DropShip) from Alt_Delivery_Addresss --BOL third party address uses Bill TO ('BT') address type			
		If	ll_alt_address_rowcount > 0 Then	
			adw_bol.SetItem(1, "alt_name", lds_bol_combine_alt_address.GetItemString(1, "name"))		
			adw_bol.SetItem(1, "alt_addr1", lds_bol_combine_alt_address.GetItemString(1, "address_1"))
			adw_bol.SetItem(1, "alt_addr2", lds_bol_combine_alt_address.GetItemString(1, "address_2"))
			adw_bol.SetItem(1, "alt_addr3", lds_bol_combine_alt_address.GetItemString(1, "address_3"))
			adw_bol.SetItem(1, "alt_addr4", lds_bol_combine_alt_address.GetItemString(1, "address_4"))
			adw_bol.SetItem(1, "alt_city",    lds_bol_combine_alt_address.GetItemString(1, "city"))
			adw_bol.SetItem(1, "alt_state",  lds_bol_combine_alt_address.GetItemString(1, "state"))
			adw_bol.SetItem(1, "alt_zip",     lds_bol_combine_alt_address.GetItemString(1, "zip"))
		End If

//Print supplementan page if more than 5 orders
If ll_consl_rowcount  > 5 Then //Print supplementan page
	adw_bol.SetItem(1, "order_count",  ll_detail_suplm_rowcount)
	lb_suplm= True
Else
	lb_suplm= False
End If

If lb_suplm = False and ll_nmfc_suplm_rowcount > 5 Then
	adw_bol.SetItem(1, "nmfc_count",  ll_nmfc_suplm_rowcount)
	lb_suplm = True		
Else
	//Detail order Information--------------------------------------------------------------------------------------------------------------	
	If	ll_detail_suplm_rowcount <=5 Then
			//For i = 1 to ll_detail_rowcount	
			For i = 1 to 	ll_detail_suplm_rowcount
				If i = 1 Then
						ls_cust_ord_nbr1= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr1",ls_cust_ord_nbr1)
						
						ld_pack_qty1=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty1",ld_pack_qty1)
						
						ld_totalw1=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight1",ld_totalw1)
							
						ls_invoice_no1=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no1",ls_invoice_no1)
						
				ElseIf i = 2 Then
						ls_cust_ord_nbr2= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr2",ls_cust_ord_nbr2)
						
						ld_pack_qty2=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty2",ld_pack_qty2)
						
						ld_totalw2=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight2",ld_totalw2)
							
						ls_invoice_no2=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no2",ls_invoice_no2)
						
				ElseIf i = 3 Then
						ls_cust_ord_nbr3= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr3",ls_cust_ord_nbr3)
							
						ld_pack_qty3=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty3",ld_pack_qty3)
						
						ld_totalw3=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight3",ld_totalw3)
						
						ls_invoice_no3=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no3",ls_invoice_no3)		
						  
				ElseIf i = 4 Then
						ls_cust_ord_nbr4= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr4",ls_cust_ord_nbr4)
						
						ld_pack_qty4=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty4",ld_pack_qty4)
						
						ld_totalw4=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight4",ld_totalw4)
						
						ls_invoice_no4=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no4",ls_invoice_no4)
						
				ElseIf i = 5 Then	
						ls_cust_ord_nbr5= ldwc_detail_suplm.GetitemString(i,"cust_order_no")
						adw_bol.SetItem(1,"cust_ord_nbr5",ls_cust_ord_nbr2)
							
						ld_pack_qty5=ldwc_detail_suplm.GetitemDecimal(i, "pack_qty")
						adw_bol.SetItem(1,"pack_qty5",ld_pack_qty5)
						
						ld_totalw5=ldwc_detail_suplm.GetitemDecimal(i, "total_weight")
						adw_bol.SetItem(1,"total_weight5",ld_totalw5)
						
						ls_invoice_no5=ldwc_detail_suplm.GetitemString(i, "invoice_no")
						adw_bol.SetItem(1,"invoice_no5",ls_invoice_no5)				
				End if
			Next	
			//Total Qty and total Weight by Order number
			ld_total_pack_qty=  ldwc_detail_suplm.GetitemDecimal(1,"total_pack_qty")  //sum of total pack qty
			ld_total_pack_weight= ldwc_detail_suplm.GetitemDecimal(1,"total_pack_weight")  //sum of total weight
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child
			adw_bol.SetItem(1,"total_pack_qty",ld_total_pack_qty)
			adw_bol.SetItem(1,"total_pack_Weight",ld_total_pack_Weight)	
		End If
	
		//Carrier Information --NMFC--------------------------------------------------------------------------------------------------------------		
		If ll_nmfc_suplm_rowcount <=5  Then					
			For i = 1 to ll_nmfc_suplm_rowcount	
			If i = 1 Then					
					ld_Item_qty1= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty1",ld_item_qty1)
					
					ld_Weight1= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight1",ld_Weight1)
					
					ls_nmfcdescription1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription1",ls_nmfcdescription1)
					
					ls_nmfc1= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc1",ls_nmfc1)
					
					ls_class1= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class1",ls_class1)						
				
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count1= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count1",ll_carton_count1)
					ls_carton_type1= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")	
					adw_bol.SetItem(1,"carton_type1",ls_carton_type1)			
					
			ElseIf i = 2 Then		
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count2= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count2",ll_carton_count2)
					ls_carton_type2= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type2",ls_carton_type2)
					
					ld_Item_qty2= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty2",ld_item_qty2)
					
					ld_Weight2= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight2",ld_Weight2)
					
					ls_nmfcdescription2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription2",ls_nmfcdescription2)
					
					ls_nmfc2= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc2",ls_nmfc2)
					
					ls_class2= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class2",ls_class2)
					
			ElseIf i = 3 Then
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count3= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count3",ll_carton_count3)
					ls_carton_type3= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type3",ls_carton_type3)
					
					ld_Item_qty3= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty3",ld_item_qty3)
					
					ld_Weight3= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight3",ld_Weight3)
					
					ls_nmfcdescription3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription3",ls_nmfcdescription3)
					
					ls_nmfc3= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc3",ls_nmfc3)
					
					ls_class3= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class3",ls_class3)
					
			ElseIf i = 4 Then
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count4= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count4",ll_carton_count4)
					ls_carton_type4= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type4",ls_carton_type4)
					
					ld_Item_qty4= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty4",ld_item_qty4)
					
					ld_Weight4= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight4",ld_Weight4)
					
					ls_nmfcdescription4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription4",ls_nmfcdescription4)
					
					ls_nmfc4= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc4",ls_nmfc4)
					
					ls_class4= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class4",ls_class4)
			ElseIf i = 5 Then
				//	ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")				
//					//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
					//ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "carton_count")
					ll_carton_count5= ldwc_nmfcitem_suplm.GetitemNumber(i, "cf_carton_countvisible")
					adw_bol.SetItem(1,"carton_count5",ll_carton_count5)
					ls_carton_type5= ldwc_nmfcitem_suplm.GetitemString(i, "cf_carton_type")
					adw_bol.SetItem(1,"carton_type5",ls_carton_type5)
					
					ld_Item_qty5= ldwc_nmfcitem_suplm.GetitemDecimal(i, "item_qty")
					adw_bol.SetItem(1,"item_qty5",ld_item_qty5)
					
					ld_Weight5= ldwc_nmfcitem_suplm.GetitemDecimal(i,"total_item_w")
					adw_bol.SetItem(1,"Item_Weight5",ld_Weight5)
					
					ls_nmfcdescription5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfcdescription")
					adw_bol.SetItem(1,"nmfcdescription5",ls_nmfcdescription5)
					
					ls_nmfc5= ldwc_nmfcitem_suplm.GetitemString(i,"nmfc"  )
					adw_bol.SetItem(1,"nmfc5",ls_nmfc5)
					
					ls_class5= ldwc_nmfcitem_suplm.GetitemString(i,"class" )
					adw_bol.SetItem(1,"class5",ls_class5)
				End if
			Next			
			//Total of all Number of carton from all orders group by carton_no with multiple Item. Examp one order with multiple line and multple NMFC pack together in one pallet
			ll_total_carton_count= ldwc_nmfcitem_suplm.GetitemNumber(1, "total_carton_count") 
			adw_bol.SetItem(1,"total_carton_count", ll_total_carton_count )
			
//			//Handling unit Type from delivery_packing carton_type; one for all either all pallet or all Carton, only print once
//			ls_carton_type= ldwc_nmfcitem_suplm.GetitemString(1, "carton_type")
//			adw_bol.SetItem(1,"carton_type",ls_carton_type)
//			
			//Total Qty and total Weight by NMFC (Item_master)
			ld_total_item_qty=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_item_qty")
			adw_bol.SetItem(1,"total_item_qty",ld_total_item_qty)
			
			//The Net Weight for the Carrier Information section should always match the Total weight of the Customer Order Information.
			//always row 1 for ext dw assuming 1Master treating detail as child			
			ld_total_net_w=  ldwc_nmfcitem_suplm.GetitemDecimal(1,"total_net_w")
			adw_bol.SetItem(1,"total_net_w",ld_total_net_w)
		End If //NMFC 
End If

If lb_suplm = True Then
	//Print(lds_bol_suplm)	//no print dialog
	OpenWithParm(w_dw_print_options,lds_bol_suplm) //print dialog
End If
	
If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetRedraw(true)

RETURN 1
end function

public function integer uf_process_master_bol_pandora (string as_load_id, ref datawindow adw_bol);//30-AUG-2018 :Madhu S23059 - TMS Master BOL

string ls_sql, presentation_str, ls_error, ls_child_bol, ls_do_no
long ll_count, ll_bol_count, ll_remain_count, ll_Row, ll_New_Row, ll_pack_count
long ll_prev_max_limit, ll_max_limit, ll_sequence, ll_RowPos, ll_stop_id
Datastore lds_ShipAddress, lds_AltAddress, lds_DeliveryPack


//a. get Ship From/To Address
lds_ShipAddress = create u_ds_datastore
presentation_str = "style(type=grid)"
ls_sql = " SELECT  DISTINCT W.WH_Name as wh_name, W.Address_1 as wh_addr1, W.Address_2 as wh_addr2, W.Address_3 as wh_addr3, W.Address_4 as wh_addr4, "  
ls_sql += " W.City as wh_City, W.State as wh_State, W.Zip as wh_Zip, W.Country as wh_Country, DM.DO_NO,  DM.Cust_Code, "
ls_sql += " DM.Cust_Name, DM.Address_1, DM.Address_2, DM.Address_3, DM.Address_4, "
ls_sql += " DM.City, DM.State, DM.Zip, DM.Country, DM.Carrier, DM.Awb_bol_no, "
ls_sql +=	 " DM.User_Field2 as Trailer_no, DM.Carrier_pro_no, DM.Contact_person,  DM.Tel, "
ls_sql +=	 " substring(DM.Carrier, 1, 4) as scac, DM.Freight_Terms, DM.Master_Bol, DM.Stop_Id "
ls_sql += " FROM	Delivery_Master DM with(nolock) INNER JOIN Project with(nolock) ON DM.Project_Id = Project.Project_Id "
ls_sql += " INNER JOIN Warehouse W with(nolock) ON DM.WH_Code = W.WH_Code "
ls_sql += " WHERE DM.Project_Id ='"+gs_project+"' AND DM.Load_Id = '"+as_load_id+"'"
ls_sql += " AND DM.Ord_Status in ('I', 'A', 'C', 'D') "
ls_sql += " ORDER BY DM.Stop_Id "

lds_ShipAddress.create( SQLCA.syntaxfromsql( ls_sql, presentation_str, ls_error))
lds_ShipAddress.settransobject( SQLCA)
lds_ShipAddress.retrieve( )
ll_count = lds_ShipAddress.rowcount( )

//b. calculate, how many BOL's needs to be printed based on Stop Id's.
ll_bol_count =0
ll_remain_count =ll_count

DO WHILE ll_remain_count > 0
	ll_bol_count++
	if ll_bol_count = 1 Then
		ll_remain_count = ll_remain_count -5
	else
		ll_remain_count = ll_remain_count -6
	end if
LOOP 

FOR ll_Row = 1 to ll_bol_count
	ll_New_Row = adw_bol.insertrow(0)
	
	//c. assign Ship From Address
	adw_bol.setItem(ll_New_Row, 'wh_name', lds_ShipAddress.getItemString( 1, 'wh_name'))
	adw_bol.setItem(ll_New_Row, 'wh_addr1', lds_ShipAddress.getItemString( 1, 'wh_addr1'))
	adw_bol.setItem(ll_New_Row, 'wh_addr2', lds_ShipAddress.getItemString( 1, 'wh_addr2'))
	adw_bol.setItem(ll_New_Row, 'wh_addr3', lds_ShipAddress.getItemString( 1, 'wh_addr3'))
	adw_bol.setItem(ll_New_Row, 'wh_addr4', lds_ShipAddress.getItemString( 1, 'wh_addr4'))
	adw_bol.setItem(ll_New_Row, 'wh_city', lds_ShipAddress.getItemString( 1, 'wh_city'))
	adw_bol.setItem(ll_New_Row, 'wh_state', lds_ShipAddress.getItemString( 1, 'wh_state'))
	adw_bol.setItem(ll_New_Row, 'wh_zip', lds_ShipAddress.getItemString( 1, 'wh_zip'))

	//d. assign Ship To Address (Last Stop Id Address)
	adw_bol.SetItem(ll_New_Row,"cust_code",  lds_ShipAddress.GetitemString(ll_count, "Cust_code"))
	adw_bol.SetItem(ll_New_Row,"cust_name", lds_ShipAddress.GetitemString(ll_count, "Cust_Name"))
	adw_bol.SetItem(ll_New_Row,"cust_addr1", lds_ShipAddress.GetitemString(ll_count,"Address_1" ))  
	adw_bol.SetItem(ll_New_Row,"cust_addr2", lds_ShipAddress.GetitemString(ll_count,"Address_2" ))   
	adw_bol.SetItem(ll_New_Row,"cust_addr3", lds_ShipAddress.GetitemString(ll_count,"Address_3"))    
	adw_bol.SetItem(ll_New_Row,"cust_addr4", lds_ShipAddress.GetitemString(ll_count,"Address_4" ))   
	adw_bol.SetItem(ll_New_Row,"cust_city", lds_ShipAddress.GetitemString(ll_count,"City" ))  
	adw_bol.SetItem(ll_New_Row,"cust_state", lds_ShipAddress.GetitemString(ll_count,"State" ))     
	adw_bol.SetItem(ll_New_Row,"cust_zip", lds_ShipAddress.GetitemString(ll_count,"Zip" ))    
	adw_bol.SetItem(ll_New_Row,"cust_country", lds_ShipAddress.GetitemString(ll_count,"Country"  ))
	adw_bol.SetItem(ll_New_Row,"contact_person", lds_ShipAddress.GetitemString(ll_count,"Contact_person"  ))  
	adw_bol.SetItem(ll_New_Row,"tel", lds_ShipAddress.GetitemString(ll_count,"Tel"  )) 
	
	ls_do_no= lds_ShipAddress.GetitemString(ll_count,"Do_No")
	
	//e. assign Carrier Details
	adw_bol.SetItem(ll_New_Row,"master_bol", lds_ShipAddress.GetitemString(ll_count,"Master_bol" ))  
	adw_bol.SetItem(ll_New_Row,"carrier", lds_ShipAddress.GetitemString(ll_count,"carrier" ))  
	adw_bol.SetItem(ll_New_Row,"trailer_no", lds_ShipAddress.GetitemString(ll_count,"Trailer_no" ))
	adw_bol.SetItem(ll_New_Row,"load_id", as_load_id)  
	adw_bol.SetItem(ll_New_Row,"pro_no", lds_ShipAddress.GetitemString(ll_count,"Carrier_Pro_No" ))
	adw_bol.SetItem(ll_New_Row,"scac", lds_ShipAddress.GetitemString(ll_count,"scac" ))
	adw_bol.SetItem(ll_New_Row,"Freight_Terms", lds_ShipAddress.GetitemString(ll_count,"Freight_Terms" ))

	
	//f. assign Alternate Address
	lds_AltAddress = create u_ds_datastore
	lds_AltAddress.dataobject = 'd_do_address_alt'
	lds_AltAddress.SetTransObject(SQLCA)
	lds_AltAddress.Retrieve(ls_do_no, 'BT')  //Bill To for BOL
	
	IF	lds_AltAddress.Rowcount() > 0 THEN
		adw_bol.SetItem(ll_New_Row, "alt_cust_code", lds_AltAddress.GetItemString(1, "cust_code"))
		adw_bol.SetItem(ll_New_Row, "alt_name", lds_AltAddress.GetItemString(1, "name"))
		adw_bol.SetItem(ll_New_Row, "alt_addr1", lds_AltAddress.GetItemString(1, "address_1"))
		adw_bol.SetItem(ll_New_Row, "alt_addr2", lds_AltAddress.GetItemString(1, "address_2"))
		adw_bol.SetItem(ll_New_Row, "alt_addr3", lds_AltAddress.GetItemString(1, "address_3"))
		adw_bol.SetItem(ll_New_Row, "alt_addr4", lds_AltAddress.GetItemString(1, "address_4"))
		adw_bol.SetItem(ll_New_Row, "alt_city",  lds_AltAddress.GetItemString(1, "city"))
		adw_bol.SetItem(ll_New_Row, "alt_state", lds_AltAddress.GetItemString(1, "state"))
		adw_bol.SetItem(ll_New_Row, "alt_zip", lds_AltAddress.GetItemString(1, "zip"))
	END IF
	
	//g. assign Stop Id + Child BOL Details (Max - 5 stop's on 1st BOL, 6 stop's from 2nd BOL Onwards)
	IF ll_Row = 1 THEN
		adw_bol.setItem(ll_New_Row, 'stop_1', 'Stop #1: PickUp Loc')	
		
		//set maximum limit for loop through
		If ll_count > 5 Then 
			ll_max_limit = 5
		else
			ll_max_limit = ll_count
		End If
		
		ll_sequence = 1 //set sequence value
		
		FOR ll_RowPos = 1 to ll_max_limit
			ll_sequence++ //1st time, starts from stop_2
			ll_stop_id = lds_ShipAddress.getItemNumber(ll_RowPos, 'Stop_id')
			ls_child_bol = lds_ShipAddress.getItemString(ll_RowPos, 'Awb_bol_no')
			
			adw_bol.setItem(ll_New_Row, 'stop_'+string(ll_sequence), 'Stop #'+string(ll_stop_id)+': ' +nz(ls_child_bol,'-') )
		Next
		
		ll_prev_max_limit = ll_max_limit //store Max Limit
	ELSE
		
		ll_sequence =0 //re-set sequence value
		
		//set maximum limit for loop through
		If ll_prev_max_limit + 6 > ll_count Then
			ll_max_limit = ll_count
		else
			ll_max_limit = ll_prev_max_limit + 6
		End If
		
		FOR ll_RowPos = ll_prev_max_limit +1 to ll_max_limit
			ll_sequence++ //start from stop_1 for 2nd time onwards...
			ll_stop_id = lds_ShipAddress.getItemNumber(ll_RowPos, 'Stop_id')
			ls_child_bol = lds_ShipAddress.getItemString(ll_RowPos, 'Awb_bol_no')
			
			adw_bol.setItem(ll_New_Row, 'stop_'+string(ll_sequence), 'Stop #'+string(ll_stop_id)+': ' +ls_child_bol )
		Next
		
		ll_prev_max_limit += ll_max_limit //store Max Limit
	END IF
	
	//h. assign Packing  Weight Details
	lds_DeliveryPack = create u_ds_datastore
	ls_sql =" SELECT   Count(DISTINCT (dp.carton_no)) as carton_count, "
	ls_sql += " SUM(DP.QUANTITY) as toal_qty, SUM(DP.QUANTITY * IM.Weight_1) as total_weight "
	ls_sql += " From  Item_Master IM with(nolock) INNER JOIN 	Delivery_Master DM with(nolock) ON IM.Project_Id=DM.Project_Id "
	ls_sql += " INNER JOIN  Delivery_Packing DP with(nolock) ON DM.DO_No=DP.DO_NO AND DP.SKU=IM.SKU AND DP.Supp_Code=IM.Supp_Code "
	ls_sql +=" Where	IM.Project_Id ='"+gs_project+"' AND DM.Load_Id='"+as_load_id+"'"
	
	lds_DeliveryPack.create( SQLCA.syntaxfromsql( ls_sql, presentation_str, ls_error))
	lds_DeliveryPack.settransobject( SQLCA)
	lds_DeliveryPack.retrieve( )
	ll_pack_count = lds_DeliveryPack.rowcount( )
	
	IF ll_pack_count > 0 THEN
		adw_bol.setItem(ll_New_Row, 'total_carton_count' , lds_DeliveryPack.getItemDecimal( 1, 'carton_count'))
		adw_bol.setItem(ll_New_Row, 'total_pack_weight' , lds_DeliveryPack.getItemDecimal( 1, 'total_weight'))
	END IF
	
	
NEXT

adw_bol.setredraw(true)


destroy lds_ShipAddress
destroy lds_AltAddress
destroy lds_DeliveryPack

Return 1
end function

public function integer uf_process_child_bol_pandora (string as_shipment_id, ref datawindow adw_bol);//30-AUG-2018 :Madhu S23059 - TMS Master BOL

string ls_sql, presentation_str, ls_error, ls_child_bol, ls_do_no
long ll_count, ll_bol_count, ll_remain_count, ll_Row, ll_New_Row, ll_pack_count
long ll_prev_max_limit, ll_max_limit, ll_sequence, ll_RowPos, ll_stop_id
long ll_Pack_Row, ll_total_carton_count
decimal ld_total_weight

Datastore lds_ShipAddress, lds_AltAddress, lds_DeliveryPack


//a. get Ship From/To Address
lds_ShipAddress = create u_ds_datastore
presentation_str = "style(type=grid)"
ls_sql = " SELECT  DISTINCT W.WH_Name as wh_name, W.Address_1 as wh_addr1, W.Address_2 as wh_addr2, W.Address_3 as wh_addr3, W.Address_4 as wh_addr4, "  
ls_sql += " W.City as wh_City, W.State as wh_State, W.Zip as wh_Zip, W.Country as wh_Country, "
ls_sql += " DM.DO_NO, DM.Invoice_No, DM.Client_Cust_Po_Nbr, DM.Cust_Code, "
ls_sql += " DM.Cust_Name, DM.Address_1, DM.Address_2 , DM.Address_3 , DM.Address_4 , "
ls_sql += " DM.City , DM.State , DM.Zip , DM.Country , DM.Carrier , DM.Awb_bol_no , "
ls_sql +=	 " DM.User_Field2 as Trailer_no, DM.Carrier_pro_no , DM.Contact_person , DM.Tel , "
ls_sql +=	 " substring(DM.Carrier, 1, 4) as scac, DM.Freight_Terms , DM.Master_Bol , DM.Load_Id, DM.Stop_Id, "
ls_sql += " DM.Load_Sequence, DM.User_Field10 as Cost_Center, DM.Request_Date "
ls_sql += " FROM	Delivery_Master DM with(nolock) INNER JOIN Project with(nolock) ON DM.Project_Id = Project.Project_Id "
ls_sql += " INNER JOIN Warehouse W with(nolock) ON DM.WH_Code = W.WH_Code "
ls_sql += " WHERE DM.Project_Id ='"+gs_project+"' AND DM.Shipment_Id = '"+as_shipment_id+"'"
ls_sql += " AND DM.Ord_Status in ('I', 'A', 'C', 'D') "
ls_sql += " ORDER BY DM.Stop_Id "

lds_ShipAddress.create( SQLCA.syntaxfromsql( ls_sql, presentation_str, ls_error))
lds_ShipAddress.settransobject( SQLCA)
lds_ShipAddress.retrieve( )
ll_count = lds_ShipAddress.rowcount( )

//Print One BOL per Order No.
FOR ll_Row = 1 to ll_count
	
	ll_max_limit = 0
	ll_prev_max_limit =0
	
	ls_do_no= lds_ShipAddress.GetItemString(ll_Row,"Do_No")
		
	//b. calculate, how many BOL's needs to be printed based on Order's Pack Count (Max Limit =5).
	lds_DeliveryPack = create u_ds_datastore
	ls_sql =" SELECT   Count(DISTINCT dp.carton_no ) as carton_count, DP.Carton_Type, IM.Weight_1 as item_weight, "
	ls_sql += " IM.User_Field14 as nmfcdescription, IM.User_Field1 as nmfc, IM.Freight_Class as class, DP.QUANTITY, "
	ls_sql += " SUM(DP.QUANTITY) as toal_qty, SUM(DP.QUANTITY * IM.Weight_1) as total_weight "
	ls_sql += " From  Item_Master IM with(nolock) INNER JOIN 	Delivery_Master DM with(nolock) ON IM.Project_Id=DM.Project_Id "
	ls_sql += " INNER JOIN  Delivery_Packing DP with(nolock) ON DM.DO_No=DP.DO_NO AND DP.SKU=IM.SKU AND DP.Supp_Code=IM.Supp_Code "
	ls_sql +=" Where	IM.Project_Id ='"+gs_project+"' AND DM.Do_No='"+ls_do_no+"'"
	ls_sql +=" Group By DP.Carton_Type, IM.Weight_1, IM.User_Field14, IM.User_Field1, IM.Freight_Class, DP.QUANTITY "
	
	lds_DeliveryPack.create( SQLCA.syntaxfromsql( ls_sql, presentation_str, ls_error))
	lds_DeliveryPack.settransobject( SQLCA)
	lds_DeliveryPack.retrieve( )
	ll_pack_count = lds_DeliveryPack.rowcount( )

	//calculate total carton count and total weight
	ld_total_weight = 0
	ll_total_carton_count = 0
	
	For ll_Pack_Row = 1 to lds_DeliveryPack.rowcount( )
		ll_total_carton_count += lds_DeliveryPack.GetItemNumber( ll_Pack_Row, 'carton_count')
		ld_total_weight += lds_DeliveryPack.getItemDecimal(ll_Pack_Row, 'total_weight')
	Next
	
	//calculate, how many BOL's are printed against Pack Record count (Max Limit  = 5)
	ll_bol_count =0
	ll_remain_count =ll_pack_count
	
	DO WHILE ll_remain_count > 0
		ll_bol_count++
		ll_remain_count = ll_remain_count -5
	LOOP 

	FOR ll_Pack_Row = 1 to ll_bol_count
		ll_New_Row = adw_bol.insertrow(0)
	
		//c. assign Ship From Address
		adw_bol.setItem(ll_New_Row, 'wh_name', lds_ShipAddress.GetItemString( ll_Row, 'wh_name'))
		adw_bol.setItem(ll_New_Row, 'wh_addr1', lds_ShipAddress.GetItemString( ll_Row, 'wh_addr1'))
		adw_bol.setItem(ll_New_Row, 'wh_addr2', lds_ShipAddress.GetItemString( ll_Row, 'wh_addr2'))
		adw_bol.setItem(ll_New_Row, 'wh_addr3', lds_ShipAddress.GetItemString( ll_Row, 'wh_addr3'))
		adw_bol.setItem(ll_New_Row, 'wh_addr4', lds_ShipAddress.GetItemString( ll_Row, 'wh_addr4'))
		adw_bol.setItem(ll_New_Row, 'wh_city', lds_ShipAddress.GetItemString( ll_Row, 'wh_city'))
		adw_bol.setItem(ll_New_Row, 'wh_state', lds_ShipAddress.GetItemString( ll_Row, 'wh_state'))
		adw_bol.setItem(ll_New_Row, 'wh_zip', lds_ShipAddress.GetItemString( ll_Row, 'wh_zip'))
	
		//d. assign Ship To Address (Last Stop Id Address)
		adw_bol.SetItem(ll_New_Row,"cust_code",  lds_ShipAddress.GetItemString(ll_Row, "Cust_code"))
		adw_bol.SetItem(ll_New_Row,"cust_name", lds_ShipAddress.GetItemString(ll_Row, "Cust_Name"))
		adw_bol.SetItem(ll_New_Row,"cust_addr1", lds_ShipAddress.GetItemString(ll_Row,"Address_1" ))  
		adw_bol.SetItem(ll_New_Row,"cust_addr2", lds_ShipAddress.GetItemString(ll_Row,"Address_2" ))   
		adw_bol.SetItem(ll_New_Row,"cust_addr3", lds_ShipAddress.GetItemString(ll_Row,"Address_3"))    
		adw_bol.SetItem(ll_New_Row,"cust_addr4", lds_ShipAddress.GetItemString(ll_Row,"Address_4" ))   
		adw_bol.SetItem(ll_New_Row,"cust_city", lds_ShipAddress.GetItemString(ll_Row,"City" ))  
		adw_bol.SetItem(ll_New_Row,"cust_state", lds_ShipAddress.GetItemString(ll_Row,"State" ))     
		adw_bol.SetItem(ll_New_Row,"cust_zip", lds_ShipAddress.GetItemString(ll_Row,"Zip" ))    
		adw_bol.SetItem(ll_New_Row,"cust_country", lds_ShipAddress.GetItemString(ll_Row,"Country"  ))
		adw_bol.SetItem(ll_New_Row,"contact_person", lds_ShipAddress.GetItemString(ll_Row,"Contact_person"  ))  
		adw_bol.SetItem(ll_New_Row,"tel", lds_ShipAddress.GetItemString(ll_Row,"Tel"  )) 
		
		//e. assign Carrier Details
		adw_bol.SetItem(ll_New_Row,"awb_bol_no", lds_ShipAddress.GetItemString(ll_Row,"awb_bol_no" ))
		adw_bol.SetItem(ll_New_Row,"carrier", lds_ShipAddress.GetItemString(ll_Row,"carrier" ))  
		adw_bol.SetItem(ll_New_Row,"trailer_no", lds_ShipAddress.GetItemString(ll_Row,"Trailer_no" ))
		adw_bol.SetItem(ll_New_Row,"load_id", lds_ShipAddress.GetItemString(ll_Row,"Load_Id" )) 
		adw_bol.SetItem(ll_New_Row,"load_sequence", lds_ShipAddress.GetItemNumber(ll_Row,"Load_sequence" ))
		adw_bol.SetItem(ll_New_Row,"stop_id", lds_ShipAddress.GetItemNumber(ll_Row,"stop_id" ))
		adw_bol.SetItem(ll_New_Row,"scac", lds_ShipAddress.GetItemString(ll_Row,"scac" ))
		adw_bol.SetItem(ll_New_Row,"pro_no", lds_ShipAddress.GetItemString(ll_Row,"Carrier_Pro_No" ))
	
		adw_bol.SetItem(ll_New_Row,"Freight_Terms", lds_ShipAddress.GetItemString(ll_Row,"Freight_Terms" ))
	
		adw_bol.SetItem(ll_New_Row,"cost_center", lds_ShipAddress.GetItemString(ll_Row,"Cost_Center" ))
		adw_bol.SetItem(ll_New_Row,"request_date", lds_ShipAddress.GetItemDateTime(ll_Row,"Request_Date" ))
		adw_bol.SetItem(ll_New_Row,"master_bol", lds_ShipAddress.GetItemString(ll_Row,"Master_bol" ))  
		adw_bol.SetItem(ll_New_Row,"invoice_no", lds_ShipAddress.GetItemString(ll_Row,"invoice_no" ))
		adw_bol.SetItem(ll_New_Row,"cust_ord_nbr", lds_ShipAddress.GetItemString(ll_Row,"client_cust_po_nbr" ))
	
		//f. assign Alternate Address
		lds_AltAddress = create u_ds_datastore
		lds_AltAddress.dataobject = 'd_do_address_alt'
		lds_AltAddress.SetTransObject(SQLCA)
		lds_AltAddress.Retrieve(ls_do_no, 'BT')  //Bill To for BOL
		
		IF	lds_AltAddress.Rowcount() > 0 THEN
			adw_bol.SetItem(ll_New_Row, "alt_cust_code", lds_AltAddress.GetItemString(1, "cust_code"))
			adw_bol.SetItem(ll_New_Row, "alt_name", lds_AltAddress.GetItemString(1, "name"))
			adw_bol.SetItem(ll_New_Row, "alt_addr1", lds_AltAddress.GetItemString(1, "address_1"))
			adw_bol.SetItem(ll_New_Row, "alt_addr2", lds_AltAddress.GetItemString(1, "address_2"))
			adw_bol.SetItem(ll_New_Row, "alt_addr3", lds_AltAddress.GetItemString(1, "address_3"))
			adw_bol.SetItem(ll_New_Row, "alt_addr4", lds_AltAddress.GetItemString(1, "address_4"))
			adw_bol.SetItem(ll_New_Row, "alt_city",  lds_AltAddress.GetItemString(1, "city"))
			adw_bol.SetItem(ll_New_Row, "alt_state", lds_AltAddress.GetItemString(1, "state"))
			adw_bol.SetItem(ll_New_Row, "alt_zip", lds_AltAddress.GetItemString(1, "zip"))
		END IF
		
		//g. assign Pack Details
		adw_bol.setItem(ll_New_Row, 'total_carton_count', ll_total_carton_count)
		adw_bol.setItem(ll_New_Row, 'total_item_weight', ld_total_weight)
		
		If ll_max_limit + 5 > ll_pack_count Then 
			ll_max_limit = ll_pack_count
		else
			ll_max_limit = 5
		End If
		
		ll_sequence = 0 //set sequence value
		FOR ll_RowPos = ll_prev_max_limit +1 to ll_max_limit
			ll_sequence++
		
			adw_bol.setItem(ll_New_Row, 'item_qty'+string(ll_sequence),  lds_DeliveryPack.getItemNumber( ll_RowPos, 'toal_qty'))
			adw_bol.setItem(ll_New_Row, 'carton_type'+string(ll_sequence),  lds_DeliveryPack.getItemString( ll_RowPos, 'Carton_Type'))
			adw_bol.setItem(ll_New_Row, 'item_weight'+string(ll_sequence),  lds_DeliveryPack.getItemDecimal( ll_RowPos, 'item_weight'))
			adw_bol.setItem(ll_New_Row, 'nmfcdescription'+string(ll_sequence),  lds_DeliveryPack.getItemString( ll_RowPos, 'nmfcdescription'))
			adw_bol.setItem(ll_New_Row, 'nmfc'+string(ll_sequence),  lds_DeliveryPack.getItemString( ll_RowPos, 'nmfc'))
			adw_bol.setItem(ll_New_Row, 'class'+string(ll_sequence),  lds_DeliveryPack.getItemString( ll_RowPos, 'class'))
		NEXT
		
		ll_prev_max_limit = ll_max_limit //store Max Limit
	NEXT
NEXT

destroy lds_ShipAddress
destroy lds_AltAddress
destroy lds_DeliveryPack

Return 1
end function

public function integer uf_process_bol_kendo (string as_dono, ref datawindow adw_bol);//TAM 2019/05/02 - F15316 (Kendo) - Added custom BOL

// int = uf_process_bol_generic( string as_dono, ref datawindow adw_bol )

integer 		li_current_id = 46   //Last Column ID in the select to know where to start.
integer 		li_start_y = 1976 // 1804
integer 		li_y 
integer 		li_height = 72 
integer 		li_space = 76 
integer 		li_start_tab = 30 
integer 		li_tab_order 
integer 		li_offset
integer 		li_tab
integer 		i, i2
integer 		li_change_tab[]
integer 		li_max_tab
integer 		li_min_tab
integer 		li_rtn_item 
integer 		li_idx_rtn_item 
integer 		li_from_pos
integer 		li_retrive_pos
integer 		li_text_pos
integer		liCheck

string ls_dwobjs[]
string ls_col_name
string ls_change_tab[]
string ls_change_tab_temp[]
string ls_select
string ls_add_select
string ls_new_select
string ls_add_column
string ls_add_table_column
string ls_compute_piece
string ls_compute_weight
string ls_compute_charge
string ls_syntax
string ls_desc
string lsdesc2
string lsdesc3
string  lsdesc4
string ls_tab_change
string ls_last_col
string ls_Remit_Name
string ls_Remit_address1
string ls_Remit_address2
string ls_Remit_address3
string ls_Remit_city
string ls_Remit_state
string ls_Remit_Zip
string ls_AWB_BOL
string ls_type
string ls_remit
string	sql_syntax, ERRORS
String	lsSpecIns, lsCustCode, lsWhCode, lsDoNo6, lsUCCS
String lsVicsBol, lsCompanyPrefix, lsUccLocationPrefix

long	ll_nbrobjects
long 	ll_height
long  ll_carton
long	llRowPos, llRowCount
long ll_count

double ld_weight

datastore lds_ds, ldsPack
	
//Loop through and get old tab orders.
of_parsetoArray( adw_bol.Describe('Datawindow.Objects') ,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)
For i = 1 to ll_nbrobjects
	li_tab = integer(adw_bol.Describe(ls_dwobjs[i]+'.TabSequence'))
	ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
	if li_tab >= li_start_tab then
		ls_change_tab[UpperBound(ls_change_tab)+1] = ls_col_name
		li_change_tab[UpperBound(ls_change_tab)] = li_tab
		if li_tab > li_max_tab then
			li_max_tab = li_tab
		end if
		if li_tab < li_min_tab then
			li_min_tab = li_tab
		end if
	end if
next
for i = li_min_tab to li_max_tab step 10
	for i2 = 1 to UpperBound(ls_change_tab)
		if i = li_change_tab[i2] then
			ls_change_tab_temp[UpperBound(ls_change_tab_temp) + 1] = ls_change_tab[i2]
			EXIT;		
		end if
	next
next

ls_change_tab = ls_change_tab_temp

lds_ds = f_datastoreFactory("d_gmbattery_bol_group_details")
li_rtn_item = lds_ds.Retrieve(as_dono)


ldsPack = Create Datastore

//Create the Datastore...
sql_syntax = "select distinct carton_no, weight_gross from delivery_PAcking where do_no = '" + as_dono + "';" 
ldsPack.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
ldsPack.SetTransobject(sqlca)

ld_weight = 0
lLRowCount = ldsPack.Retrieve()
If llRowCount > 0 Then
	For llRowPOs = 1 to llRowCount
		If ldsPAck.GetITemNumber(llRowPos,'weight_gross') > 0 Then
			ld_weight += ldsPAck.GetITemNumber(llRowPos,'weight_gross')
		End If
	next
End If

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc2 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC2';

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc3 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC3';

SELECT dbo.Lookup_Table.code_descript  
 INTO :lsdesc4 
 FROM dbo.Lookup_Table  
WHERE dbo.Lookup_Table.Project_Id = :gs_project and dbo.Lookup_Table.Code_Type = 'BOLDS' &
and dbo.Lookup_Table.Code_ID = 'BOLDESC4';

SELECT  count(distinct(dbo.Delivery_Packing.Carton_No))  
 INTO :ll_carton  
 FROM dbo.Delivery_Packing  
WHERE dbo.Delivery_Packing.DO_No = :as_dono ;

li_y = li_start_y
li_tab_order = li_start_tab

for li_idx_rtn_item = 1 to 5 // ll_num_total_rows

	//Everything must in the correct order!

	ls_add_select = ls_add_select + ", 0000 as c_pieces" + string(li_idx_rtn_item) + ",   ~~~'                                 ~~~' as c_desc"+string(li_idx_rtn_item) + ", 0000.00 as c_weight"+string(li_idx_rtn_item) + ", '     ' as c_weight_ind"+string(li_idx_rtn_item) + ", 0000.00 as c_rate" + string(li_idx_rtn_item)
 	ls_add_table_column = ls_add_table_column + " column=(type=long updatewhereclause=yes name=c_pieces"+string(li_idx_rtn_item)+" dbname=~"c_pieces"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=char(33) updatewhereclause=yes name=c_desc"+string(li_idx_rtn_item)+" dbname=~"c_desc"+string(li_idx_rtn_item)+"~" ) " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_weight"+string(li_idx_rtn_item)+" dbname=~"c_weight"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=char(5) updatewhereclause=yes name=c_weight_ind"+string(li_idx_rtn_item)+" dbname=~"c_weight_ind"+string(li_idx_rtn_item)+"~") " + &
															  " column=(type=decimal(2) updatewhereclause=yes name=c_rate"+string(li_idx_rtn_item)+" dbname=~"c_rate"+string(li_idx_rtn_item)+"~" ) "

	if li_idx_rtn_item > 1 then ls_compute_piece = ls_compute_piece + " + "
	ls_compute_piece 	= ls_compute_piece + " c_pieces" +string(li_idx_rtn_item)
	if li_idx_rtn_item > 1 then ls_compute_weight = ls_compute_weight + " + "
	ls_compute_weight	= ls_compute_weight + " c_weight" +string(li_idx_rtn_item)
	if li_idx_rtn_item > 1 then ls_compute_charge = ls_compute_charge + " + "
	ls_compute_charge	= ls_compute_charge + " c_pieces_rate_sub" +string(li_idx_rtn_item)
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_pieces"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"2~" background.color=~"1073741824~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"279~" y=~""+string(li_y)+"~" height=~"72~" width=~"1582~" format=~"[general]~"  name=c_desc"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler"+string(li_idx_rtn_item)+" font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"1~" tabsequence="+string(li_tab_order)+" border=~"0~" color=~"0~" x=~"2220~" y=~""+string(li_y)+"~" height=~"72~" width=~"130~" format=~"[general]~"  name=c_weight_ind"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.autoselect=yes  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~"  visible =~"0~") "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	ls_add_column = ls_add_column + " column(band=detail id="+string(li_current_id)+" alignment=~"2~" tabsequence="+string(li_tab_order)+" border=~"2~" color=~"0~" x=~"2427~" y=~""+string(li_y)+"~" height=~"72~" width=~"480~" format=~"###,###.00~"  name=c_rate"+string(li_idx_rtn_item)+" edit.limit=0 edit.case=any edit.focusrectangle=no edit.autoselect=no  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~" c_pieces"+string(li_idx_rtn_item)+" * c_rate"+string(li_idx_rtn_item)+" ~"border=~"2~" color=~"0~" x=~"2912~" y=~""+string(li_y)+"~" height=~"72~" width=~"434~" format=~"###,###.00~"  name=c_pieces_rate_sub"+string(li_idx_rtn_item)+"  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
	li_current_id = li_current_id + 1
	li_tab_order = li_tab_order + 1
	li_y = li_y + li_space
	li_offset = li_offset + li_space
	ls_last_col = "c_rate"+string(li_idx_rtn_item)
next
ls_add_column = ls_add_column + " compute(band=detail alignment=~"2~" expression=~""+ls_compute_piece+"~" border=~"2~" color=~"0~" x=~"9~" y=~""+string(li_y)+"~" height=~"72~" width=~"265~" format=~"#,##0~"  name=c_piece_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
ls_add_column = ls_add_column + " text(band=detail alignment=~"2~" text=~"~" border=~"2~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"558~"  name=t_filler_weight font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
ls_add_column = ls_add_column + " compute(band=detail alignment=~"1~" expression=~""+ls_compute_weight+"~" border=~"0~" color=~"0~" x=~"1865~" y=~""+string(li_y)+"~" height=~"72~" width=~"350~" format=~"###,###.00~"  name=c_weight_total  font.face=~"Arial~" font.height=~"-8~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" background.mode=~"1~" background.color=~"536870912~" ) "
li_offset = li_offset + li_space
ls_syntax = adw_bol.Describe("DataWindow.Syntax")
ls_add_select = ls_add_select + " "
ls_select = adw_bol.Describe("Datawindow.Table.Select")
ls_new_select = ls_syntax
li_retrive_pos = Pos(lower(ls_new_select), "retrieve=")
ls_new_select = left( ls_new_select, li_retrive_pos - 1) + ls_add_table_column + mid( ls_new_select, li_retrive_pos - 1)
li_from_pos = POS(upper(ls_new_select), " FROM ")
ls_new_select = left( ls_new_select, li_from_pos - 2) + ls_add_select + mid( ls_new_select, li_from_pos - 2)  
li_text_pos = POS(lower(ls_new_select), "text(")
ls_new_select = left( ls_new_select, li_text_pos - 1) + ls_add_column + mid( ls_new_select, li_text_pos - 1)  
ls_new_select = fu_quotestring(ls_new_select, "'")
adw_bol.Create(ls_new_select)
adw_bol.Modify("c_total.Expression='"+ls_compute_charge+"'")


SELECT dbo.Delivery_Alt_Address.Name, dbo.Delivery_Alt_Address.Address_1, dbo.Delivery_Alt_Address.address_2, dbo.Delivery_Alt_Address.address_3, dbo.Delivery_Alt_Address.city, dbo.Delivery_Alt_Address.state, dbo.Delivery_Alt_Address.zip   
 INTO :ls_Remit_Name, :ls_Remit_address1, :ls_Remit_address2, :ls_Remit_address3, :ls_Remit_city, :ls_Remit_state, :ls_Remit_Zip  
 FROM dbo.Delivery_Alt_Address  
WHERE dbo.Delivery_Alt_Address.Do_No = :as_dono AND dbo.Delivery_Alt_Address.Project_id = :gs_project  and dbo.Delivery_Alt_Address.address_type = 'BT' ;
IF IsNull(ls_Remit_Name) then ls_Remit_Name = ""
IF IsNull(ls_Remit_address1) then ls_Remit_address1 = ""
IF IsNull(ls_Remit_address2) then ls_Remit_address2 = ""
IF IsNull(ls_Remit_address3) then ls_Remit_address3 = ""
IF IsNull(ls_Remit_city) then ls_Remit_city = ""
IF IsNull(ls_Remit_state) then ls_Remit_state = ""
IF IsNull(ls_Remit_Zip) then ls_Remit_Zip = ""
if ls_Remit_Name <> "" then
	ls_remit = ls_remit_name + "~r~n"
end if
if ls_Remit_address1 <> "" then
	ls_remit = ls_remit + ls_Remit_address1 + "~r~n"
end if 
	if ls_Remit_address2 <> "" then
	ls_remit = ls_remit + ls_Remit_address2 + "~r~n"
end if
if ls_Remit_address3 <> "" then
	ls_remit = ls_remit + ls_Remit_address3 + "~r~n"
end if

ls_remit = ls_remit + ls_remit_city + ", " + ls_remit_state + ", " + ls_remit_zip 
	
adw_bol.Modify("c_remit_name.Expression=~'~""+ls_remit+"~"~'")

//Retrieve the report

adw_bol.SetTransObject(sqlca)

adw_bol.Retrieve(gs_project, as_dono)

If adw_bol.RowCount() = 0 Then
	adw_bol.InsertRow(0)
End If

adw_bol.SetItem(1, "c_pieces1", ll_Carton )		
if lds_ds.rowcount() > 0 then
	ls_desc = lds_ds.GetItemstring( 1, "Code_Description") + lsDesc2
else
	ls_desc = lsDesc2
	if isNull( lsDesc2) or len( trim( lsDesc2 ) ) = 0 then ls_desc = 'No Description Available'
end if
adw_bol.SetItem(1, "c_desc1" , ls_desc )		
adw_bol.SetItem(1, "c_weight1" , ld_weight  )		
adw_bol.SetItem(1, "c_desc2" , lsdesc3 )
adw_bol.SetItem(1, "c_desc3" , lsdesc4 )

// Fill AWB BOL into C_ROUTE
ls_AWB_BOL = w_do.idw_other.GetItemString(1,"AWB_BOL_NO")

//GailM 12/10/2017 - I518 F5914 S14069 - KDO - Generate and print 17-digit number on BOL
lsCustCode = adw_bol.GetItemString( 1, 'delivery_master_cust_code' )
lsWhCode = w_do.idw_other.GetItemString( 1, 'wh_code' )
SELECT count(*) INTO :ll_count FROM customer WHERE project_id = 'KENDO' AND cust_code = :lsCustCode AND user_field1 = 'JCP' USING sqlca;
If ll_count > 0 Then
	SELECT ucc_company_prefix INTO :lsCompanyPrefix FROM project WHERE project_id = 'KENDO' USING sqlca;
	SELECT ucc_location_prefix INTO :lsUccLocationPrefix FROM warehouse WHERE wh_code = :lsWhCode USING sqlca;
	lsDoNo6 = RIGHT( w_do.idw_other.GetItemString(1,"do_no"), 6 )
	If Len( lsCompanyPrefix ) = 8 AND isNumber( lsCompanyPrefix ) Then
		If isNull( lsUccLocationPrefix ) OR lsUccLocationPrefix = '' Then
			lsUccLocationPrefix = '00'
		ElseIf  Len( lsUccLocationPrefix ) = 1 AND isNumber( lsUccLocationPrefix ) Then
			lsUccLocationPrefix = '0' + lsUccLocationPrefix
		ElseIf NOT  isNumber( lsUccLocationPrefix ) Then
			messagebox( "Error with AWB BOL number", "Kendo's WH " + lsWhCode + " , UccLocationPrefix: " + lsUccLocationPrefix + " is invalid" )
		End If
		If NOT isNumber(lsDoNo6) Then
			lsDoNo6 = Right( lsDoNo6,5 ) + '0'	//Not needed but entered in case the 6 digit number is not a number
		End if
		
		lsUCCS =  trim( lsCompanyPrefix + lsUccLocationPrefix + lsDoNo6 )
		liCheck = f_var_len_uccs_check_digit( lsUCCS ) 		
		If liCheck >= 0 Then
			ls_AWB_BOL = lsUCCS + string( liCheck )
		Else
			messagebox("Error with AWB BOL number", "Kendo's AWB BOL number: " + lsUCCS + " is invalid.  Check project UCC company prefix and warehouse UCC location prefix." )
		End If
	Else
		messagebox("Error with AWB BOL number", "Kendo's UCC company prefix: " + lsCompanyPrefix + " is invalid.  Must be a number and 8 digits." )
	End If
End If
		
If Not isnull(ls_AWB_BOL) Then
	adw_bol.setitem( 1, 'c_route', ls_awb_bol )
	w_do.idw_other.SetItem( 1, "AWB_BOL_NO", ls_awb_bol )  // ib_changed in w_do will be set to True to ensure number is saved to OtherInfo Tab
end if 		
	
//Push Footer Down
of_parsetoArray( adw_bol.Describe('Datawindow.Objects') ,'~t',ls_dwobjs)
ll_nbrobjects = UPPERBOUND(ls_dwobjs)

adw_bol.SetRedraw(false)
For i = 1 to ll_nbrobjects
	ls_col_name = adw_bol.Describe(ls_dwobjs[i]+'.name')
	ls_type = trim(adw_bol.Describe(ls_dwobjs[i]+'.type'))
	if ls_type = "line" then
	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y1'))
	else
	   li_y = long(adw_bol.Describe(ls_dwobjs[i]+'.y'))
	end if
	if (li_y >= li_start_y) and &
		(left(ls_col_name, 6) <> "c_piec" and &
		left(ls_col_name, 6) <> "c_desc" and &
		left(ls_col_name, 6) <> "c_rate" and &
		left(ls_col_name, 6) <> "c_weig" and &
		left(ls_col_name, 6) <> "t_fill") then
			if ls_type = "line"  then
				adw_bol.Modify(ls_dwobjs[i] + ".y1=" + string(li_y + li_offset) + " " + ls_dwobjs[i] + ".y2=" + string(li_y + li_offset))
			else
				adw_bol.Modify(ls_dwobjs[i] + ".y=" + string(li_y + li_offset))
			end if
	  END IF
NEXT

li_tab_order =  integer(adw_bol.describe(ls_last_col+".TabSequence")) + 1

for i = 1 to UpperBound(ls_change_tab)
	adw_bol.modify(ls_change_tab[i]+".TabSequence=0")
	ls_tab_change = ls_tab_change + " " + ls_change_tab[i]+".TabSequence=" + string(li_tab_order) + " "
	li_tab_order = li_tab_order + 10
next	
adw_bol.Modify(ls_tab_change)

ll_height = long(adw_bol.Describe("DataWindow.detail.height"))

ll_height = ll_height + li_offset

adw_bol.Modify("DataWindow.detail.height="+string(ll_height))

//10/08 - PCONKL - Add special instructions (Customer UF9) for Comcast - Not really baseine but using a variance of the baseline BOL
If gs_project = 'COMCAST' and adw_bol.RowCount() > 0 Then
	
	lsCustCode = adw_bol.GetITemString(1,'Delivery_Master_Cust_Code')
	
	Select User_Field9 into :lsSpecIns
	From Customer
	Where project_id = :gs_Project and cust_Code = :lsCustCode;
	
	If lsSpecIns > '' Then
		adw_bol.Modify("special_instructions_t.text='" + lsSpecIns + "'")
	End If
	
End If
	
adw_bol.SetRedraw(true)


RETURN 1
end function

on u_nvo_custom_bol.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_custom_bol.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

