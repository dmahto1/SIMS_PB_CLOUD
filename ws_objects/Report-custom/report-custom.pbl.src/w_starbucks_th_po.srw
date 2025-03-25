$PBExportHeader$w_starbucks_th_po.srw
$PBExportComments$Starbucks TH PO
forward
global type w_starbucks_th_po from w_std_report
end type
end forward

global type w_starbucks_th_po from w_std_report
integer width = 3488
integer height = 2044
string title = "Starbucks PO"
end type
global w_starbucks_th_po w_starbucks_th_po

type variables
DataWindowChild idwc_warehouse,idwc_supp

boolean ib_movement_from_first
boolean ib_movement_to_first
boolean ib_select_sku
boolean ib_select_date_start
boolean ib_select_date_end

String	isoriqsqldropdown
Datawindow   idw_main, idw_search,idw_query, idw_avail_inv, idw_avail_inv_search
Datawindow idw_receive_search, idw_delivery_search
Datawindow idw_receive,idw_delivery,idw_transfer
Datawindow idw_select,idwCurrent,idw_Pick,idw_pack, idw_adjust
//TimA 07/05/12 Pandora issue #360 add Owner to the search
Datawindowchild	idw_Avail_child_owner, idw_All_child_owner
Datawindowchild	idw_Receive_child_owner, idw_Delivery_child_owner

String  is_org_sql,isOrigsql_main,isorigsql_receive,isorigsql_delivery,isorigsql_transfer,isorigsql_adjust,isorigsql_loc
String isWarehouse
Protected String isSku
integer ii_height
String  isorigsql_pick,isOrigsql_pack,isOrigSql_bol, isorigSql_avail_inv
w_stockinquiry iw_window
boolean ib_rcv_complete_from_first
boolean ib_rcv_complete_to_first
boolean ib_rcv_order_from_first
boolean ib_rcv_order_to_first
boolean ib_trn_order_from_first 	
boolean ib_trn_order_to_first 	
boolean ib_rcv_sched_from_first
boolean ib_rcv_sched_to_first
boolean ib_dlv_complete_from_first
boolean ib_dlv_complete_to_first
boolean ib_dlv_order_from_first
boolean ib_dlv_order_to_first
boolean ib_dlv_sched_from_first
boolean ib_dlv_sched_to_first
boolean ib_pick_order_from_first
boolean ib_pick_order_to_first
boolean ib_pack_order_from_first
boolean ib_pack_order_to_first
boolean ib_adj_order_from_first
boolean ib_adj_order_to_first
n_ds_content  ids_damaris



end variables

on w_starbucks_th_po.create
call super::create
end on

on w_starbucks_th_po.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;String	lsRONO
If isvalid(w_ro) Then
	lsRONO = w_ro.idw_Main.GetITemString(1,'ro_no')
	dw_report.retrieve(w_ro.idw_Main.GetITemString(1,'ro_no'))
	im_menu.m_file.m_print.Enabled = True
End IF
end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-50)
end event

event ue_postopen;call super::ue_postopen;triggerEvent('ue_retrieve')
end event

type dw_select from w_std_report`dw_select within w_starbucks_th_po
boolean visible = false
integer x = 18
integer width = 3131
boolean enabled = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;ib_movement_from_first 	= TRUE
ib_movement_to_first 	= TRUE
ib_select_sku 				= FALSE
ib_select_date_start 	= FALSE
ib_select_date_end   	= FALSE
end event

event dw_select::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

end event

event dw_select::itemchanged;long ll_rtn
String	lsDDSQl

IF dwo.name = 'sku' THEN
	ll_rtn=i_nwarehouse.of_item_sku(gs_project,data)
	IF ll_rtn = 1 THEN 
		this.object.supp_code[row] = i_nwarehouse.ids_sku.object.supp_code[1]
		//post f_setfocus(dw_select,row,'s_date')
	ELSEIF ll_rtn > 1 THEN
		lsDDSQl = Replace(isoriqsqldropdown,pos(isoriqsqldropdown,'xxxxxxxxxx'),10,gs_project)
		lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,'zzzzzzzzzz'),10,data)
		idwc_supp.SetSqlSelect(lsDDSQL)
		idwc_supp.Retrieve()
		
	ELSE
		Messagebox(is_title,"Invalid Sku please Re-enter")
		post f_setfocus(dw_select,row,'sku')
		Return 2
	END IF	
END IF	

//IF dwo.name = 'supp_code' THEN  //TAM 04/29/2011  For Wine and Spirit they want All supplier codes
//	If Left(gs_project,3) = 'WS-)' Then
//		lsDDSQl = Replace(isoriqsqldropdown,pos(isoriqsqldropdown,"xxxxxxxxxx' ) AND"),17,gs_project)
//		lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,"( Item_Master.SKU = 'zzzzzzzzzz' ) )"),36,'')
//		idwc_supp.SetSqlSelect(lsDDSQL)
//		idwc_supp.Retrieve()
//	END IF	
//END IF	
//
end event

type cb_clear from w_std_report`cb_clear within w_starbucks_th_po
integer x = 3154
integer y = 12
integer width = 270
end type

event cb_clear::clicked;call super::clicked;If idwc_warehouse.RowCount() > 0 Then
	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
End If

end event

type dw_report from w_std_report`dw_report within w_starbucks_th_po
integer x = 18
integer y = 32
integer width = 3401
integer height = 1704
string dataobject = "d_starbucks_th_po"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

