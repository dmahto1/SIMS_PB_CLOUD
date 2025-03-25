HA$PBExportHeader$u_nvo_custom_wo_picklists.sru
$PBExportComments$Project Specific Workorder Pick list logic
forward
global type u_nvo_custom_wo_picklists from nonvisualobject
end type
end forward

global type u_nvo_custom_wo_picklists from nonvisualobject
end type
global u_nvo_custom_wo_picklists u_nvo_custom_wo_picklists

type variables
Datawindow idw_print, idw_pick, idw_other, &
				 idw_detail, idw_main
String is_title
Boolean ib_changed

w_do iw_window
end variables

forward prototypes
public function integer uf_wo_pickprint_riverbed ()
end prototypes

public function integer uf_wo_pickprint_riverbed ();Long	llRowCount,	&
		llRowPos,	&
		llNewRow, llfind, llLine_Item_No

String	lsSKU,	&
			lsSupplier,	&
			lsDescription, ls_sku_parent, lsFind, ls_line_item_notes 
			
Decimal	ldLength, ldWidth, ldHeight
			

w_workorder.idw_pick_Print.Reset()

w_workorder.tab_main.tabpage_picking.dw_pick_print.dataobject = 'd_workorder_picking_prt_riverbed' /* assign custom print DW */

llRowCount = w_workorder.idw_pick.RowCount()

For llRowPos = 1 to llRowCount /*for each Pick Row */
	
	llNewRow = w_workorder.idw_pick_Print.InsertRow(0)
	
	//From Header
	w_workorder.idw_pick_print.SetITem(llNewRow,'Project_id',w_workorder.idw_main.GetITemString(1,'project_id'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'workorder_nbr',w_workorder.idw_main.GetITemString(1,'workorder_number'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'ord_date',w_workorder.idw_main.GetITemDateTime(1,'ord_date'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'sched_Date',w_workorder.idw_main.GetITemDateTime(1,'sched_date'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'remark',w_workorder.idw_main.GetITemString(1,'remarks'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'wh_code',w_workorder.idw_main.GetITemString(1,'wh_code'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'delivery_order_nbr',w_workorder.idw_main.GetITemString(1,'delivery_invoice_no'))
	
	//From Picking
	w_workorder.idw_pick_print.SetITem(llNewRow,'SKU',w_workorder.idw_pick.GetITemString(llRowPos,'SKU'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'supp_code',w_workorder.idw_pick.GetITemString(llRowPos,'supp_code'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'l_code',w_workorder.idw_pick.GetITemString(llRowPos,'l_code'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'deliver_to_location',w_workorder.idw_pick.GetITemString(llRowPos,'deliver_to_location'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'lot_no',w_workorder.idw_pick.GetITemString(llRowPos,'lot_no'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'serial_no',w_workorder.idw_pick.GetITemString(llRowPos,'serial_No'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'po_no',w_workorder.idw_pick.GetITemString(llRowPos,'po_no'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'po_no2',w_workorder.idw_pick.GetITemString(llRowPos,'po_no2'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'container_id',w_workorder.idw_pick.GetITemString(llRowPos,'container_id'))			//GAP 11-02
	w_workorder.idw_pick_print.SetITem(llNewRow,'expiration_date',w_workorder.idw_pick.GetITemdatetime(llRowPos,'expiration_date'))	//GAP 11-02
	w_workorder.idw_pick_print.SetITem(llNewRow,'inventory_Type',w_workorder.idw_pick.GetITemString(llRowPos,'inventory_Type'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'coo',w_workorder.idw_pick.GetITemString(llRowPos,'Country_of_Origin'))
	w_workorder.idw_pick_print.SetITem(llNewRow,'quantity',w_workorder.idw_pick.GetITemNumber(llRowPos,'quantity'))
	
	//From Detail

//TAM 12/13/04 load order detail
	ls_sku_parent =  w_workorder.idw_pick.GetITemString(llRowPos,'SKU_Parent')
	llLine_Item_No = w_workorder.idw_pick.GetITemNumber(llRowPos,'Line_Item_No')
	
	lsFind = "Upper(sku) = '" + Upper(ls_sku_parent) + "' and line_item_no = " + string(llLine_Item_No)
    llfind = w_workorder.idw_detail.Find(lsFind,1,w_workorder.idw_detail.RowCount())
 
		if llfind > 0 Then
			w_workorder.idw_pick_print.SetITem(llNewRow,'parent_qty', w_workorder.idw_detail.GetITemNumber(llfind,'req_qty'))
			w_workorder.idw_pick_print.SetITem(llNewRow,'parent_sku', ls_sku_parent)
			w_workorder.idw_pick_print.SetITem(llNewRow,'parent_description', Trim(w_workorder.idw_detail.getitemstring(llFind, "user_field3")))
		End If	
	
	
	//need description and dimensions (for GM) from ITem Master
	lsSku = w_workorder.idw_pick.GetITemString(llRowPos,'SKU')
	lsSupplier = w_workorder.idw_pick.GetITemString(llRowPos,'Supp_code')
	
	Select Description, length_1, width_1, height_1 
	Into	:lsDescription, :ldLength, :ldWidth, :ldHeight
	From ITem_MAster
	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
	
	
	If isnull(ldLength) then ldLength = 0
	If isnull(ldWidth) then ldWidth = 0
	If isnull(ldHeight) then ldHeight = 0
	
	w_workorder.idw_pick_print.SetITem(llNewRow,'description',lsDescription)
	
	If ldLength = 0 and ldWidth = 0 and ldHeight = 0 Then
	Else
		w_workorder.idw_pick_print.SetITem(llNewRow,'dimensions', String(ldLength,"####0.##") + " x " +  String(ldWidth,"####0.##") + " x " +  String(ldHeight,"####0.##"))
	End If

	
Next /*Pick Row */

w_workorder.idw_pick_print.Sort()
w_workorder.idw_pick_print.GroupCalc()

OpenWithParm(w_dw_print_options,w_workorder.idw_pick_print) 

Return 0

end function

on u_nvo_custom_wo_picklists.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_custom_wo_picklists.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

