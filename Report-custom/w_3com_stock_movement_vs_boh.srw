HA$PBExportHeader$w_3com_stock_movement_vs_boh.srw
$PBExportComments$Stock Movement vesus Balance on Hand
forward
global type w_3com_stock_movement_vs_boh from w_std_report
end type
type rb_all from radiobutton within w_3com_stock_movement_vs_boh
end type
type rb_diff from radiobutton within w_3com_stock_movement_vs_boh
end type
type gb_1 from groupbox within w_3com_stock_movement_vs_boh
end type
end forward

global type w_3com_stock_movement_vs_boh from w_std_report
integer width = 4270
integer height = 2036
string title = "Stock Movement vs BOH Report"
rb_all rb_all
rb_diff rb_diff
gb_1 gb_1
end type
global w_3com_stock_movement_vs_boh w_3com_stock_movement_vs_boh

type variables
DataWindowChild idwc_warehouse,idwc_supp

//boolean ib_movement_from_first
//boolean ib_movement_to_first
//boolean ib_select_sku
//boolean ib_select_date_start
//boolean ib_select_date_end

String	isoriqsqldropdown, isOrigRptSQL
end variables

on w_3com_stock_movement_vs_boh.create
int iCurrent
call super::create
this.rb_all=create rb_all
this.rb_diff=create rb_diff
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_all
this.Control[iCurrent+2]=this.rb_diff
this.Control[iCurrent+3]=this.gb_1
end on

on w_3com_stock_movement_vs_boh.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_all)
destroy(this.rb_diff)
destroy(this.gb_1)
end on

event ue_retrieve;String ls_whcode, ls_ord_type
DateTime ldt_s, ldt_e
Long  i, ll_cnt,j,ll_adj
decimal ld_balance
decimal ld_in_count
decimal ld_out_count
decimal ld_old_quantity
decimal ld_difference
decimal ld_quantity, ld_bal
decimal ld_n_bal_qty,ld_n_in_count,ld_n_out_count

SetPointer(HourGlass!)

dw_report.Reset()
dw_report.SetRedraw(False)

dw_report.SetFilter("")
dw_report.Filter()

ls_whcode = dw_select.GetITemString(1,'wh_code')

ll_cnt = dw_report.Retrieve(gs_project,ls_whcode) 

dw_report.TriggerEVent('ue_filter')
 
ll_cnt=dw_report.Rowcount()

If ll_cnt > 0 Then
	
	im_menu.m_file.m_print.Enabled = True
//	Select Sum(Avail_Qty + Alloc_Qty + Tfr_Out + wip_qty) Into :ld_balance
//					From content_full (NOLOCK)
//						Where project_id 	= :gs_project and 
//								wh_code 		= :ls_whcode;
//								
//	If sqlca.sqlcode <> 0 Then 
		ld_balance = 0
//	END IF
	
	//dw_report.SetItem(ll_cnt, "bal_qty", ld_balance)
	
//	ll_cnt -= 1

Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If

dw_report.SetRedraw(True)
end event

event ue_clear;dw_select.Reset()
dw_report.Reset()
dw_select.InsertRow(0)

end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_postopen;call super::ue_postopen;string	lsFilter
DatawindowChild	ldwc

dw_select.GetChild('wh_code', idwc_warehouse)

idwc_warehouse.SetTransObject(sqlca)

//If idwc_warehouse.Retrieve(gs_project) > 0 Then
//	dw_select.SetItem(1, "wh_code" , gs_default_wh)
//End If

// LTK 20150922  Commented out block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
dw_select.GetChild("wh_code", idwc_warehouse)
idwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(idwc_warehouse)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "wh_code", gs_default_wh)
end if


rb_all.Checked = True
end event

type dw_select from w_std_report`dw_select within w_3com_stock_movement_vs_boh
integer x = 18
integer y = 32
integer width = 2779
integer height = 192
string dataobject = "d_stock_movement_rpt_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;
//Hide unused Criteria (shared with Stock Movement by SKU Report) 
This.Modify("supp_t.visible=false supp_code.visible=false sku_t.visible=false sku.visible=false t_1.visible=False t_2.visible=False s_date_t.visible=false s_date.visible = false e_date.visible=false")
end event

event dw_select::itemchanged;long ll_rtn
String	lsDDSQl

IF dwo.name = 'sku' THEN
	ll_rtn=i_nwarehouse.of_item_sku(gs_project,data)
	IF ll_rtn = 1 THEN 
		this.object.supp_code[row] = i_nwarehouse.ids_sku.object.supp_code[1]
		post f_setfocus(dw_select,row,'s_date')
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
end event

type cb_clear from w_std_report`cb_clear within w_3com_stock_movement_vs_boh
integer x = 3205
integer y = 0
integer width = 46
end type

event cb_clear::clicked;call super::clicked;If idwc_warehouse.RowCount() > 0 Then
	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
End If

end event

type dw_report from w_std_report`dw_report within w_3com_stock_movement_vs_boh
event ue_filter ( )
integer x = 18
integer y = 256
integer width = 4133
integer height = 1424
string dataobject = "d_3com_stock_vs_boh"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_report::ue_filter();
If rb_all.checked Then
	This.SetFilter("")
Else
	this.SetFilter("compute_7 <> 0")
End If

This.Filter()
end event

type rb_all from radiobutton within w_3com_stock_movement_vs_boh
integer x = 2866
integer y = 60
integer width = 1161
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show &All SKU~'s"
end type

event clicked;
dw_report.TriggerEvent('ue_filter')
end event

type rb_diff from radiobutton within w_3com_stock_movement_vs_boh
integer x = 2866
integer y = 124
integer width = 1161
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show &Only SKU~'s with a difference"
end type

event clicked;
dw_report.TriggerEvent('ue_filter')
end event

type gb_1 from groupbox within w_3com_stock_movement_vs_boh
integer x = 2830
integer y = 16
integer width = 1275
integer height = 196
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

