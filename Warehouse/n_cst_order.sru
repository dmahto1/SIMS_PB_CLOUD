HA$PBExportHeader$n_cst_order.sru
$PBExportComments$-
forward
global type n_cst_order from nonvisualobject
end type
end forward

global type n_cst_order from nonvisualobject
end type
global n_cst_order n_cst_order

forward prototypes
public function integer of_generate_ambit_bol (datawindow adw_pack, datawindow adw_bol)
end prototypes

public function integer of_generate_ambit_bol (datawindow adw_pack, datawindow adw_bol);String ls_carton_type,ls_old_sort,ls_where,ls_null
Decimal ld_tot
integer i,j
Long ll_rtn,ll_carton_cnt,ll_find
String ls_syntax,ls_setting
setnull(ls_null)
 n_cst_common_tables ln_commmon
//Change the sor Order temporarily
adw_pack.SetRedraw(False)
ls_old_sort=adw_pack.Object.DataWindow.Table.Sort
ll_rtn=adw_pack.Setsort("carton_type A")
ll_rtn=adw_pack.Sort()
IF ll_rtn = 1 THEN
	j= 1
	ll_carton_cnt = 1 //First row is always one
	FOR i = 1 TO adw_pack.Rowcount()
			ld_tot = adw_pack.object.weight_gross[i]
		   DO 				
				ls_carton_type=adw_pack.object.carton_type[i]
				ls_syntax = "carton_type = '"+ ls_carton_type +"'"
				ll_find= adw_pack.Find(ls_syntax,(i + 1),adw_pack.rowcount())
				If isnull(ll_find) Then ll_Find =0
				IF ll_find > 0 THEN
					ld_tot = ld_tot + adw_pack.object.weight_gross[ll_find]
					ll_carton_cnt ++
					 i ++ 
				END IF
				IF i >= adw_pack.Rowcount() THEN Exit				
			LOOP WHILE ll_find > 0			
			IF j < 5 THEN
				CHOOSE CASE j
				CASE 1
					adw_bol.object.c_pieces[1]	   = ll_carton_cnt
					adw_bol.object.remark[1]	   = ls_carton_type
					adw_bol.object.c_weight[1]	   = ld_tot
					
				CASE 2
					adw_bol.object.c_pieces2[1]	= ll_carton_cnt
					adw_bol.object.c_desc2[1]	   = ls_carton_type
					adw_bol.object.c_weight2[1]	   = ld_tot
				CASE 3
					adw_bol.object.c_pieces3[1]	= ll_carton_cnt
					adw_bol.object.c_desc3[1]	   = ls_carton_type
					adw_bol.object.c_weight3[1]	   = ld_tot
	 			CASE 4
					adw_bol.object.c_pieces4[1]	= ll_carton_cnt	
					adw_bol.object.c_desc4[1]	   = ls_carton_type
					adw_bol.object.c_weight4[1]	   = ld_tot
				END CHOOSE				
				j++
				ll_carton_cnt =1				
			END IF			
	NEXT
END IF

IF ln_commmon.of_select_lookup_table() > 0 THEN 
	adw_bol.object.c_desc5[1]=ln_commmon.is_code_desc 
END IF	
ll_rtn=adw_pack.Setsort(ls_old_sort)
ll_rtn=adw_pack.Sort()
adw_pack.SetRedraw(TRUE)
ls_where = " project_id = '" + gs_project + "'~n"+ &
             " and cust_code = 'REMIT-TO'  "
g.i_nwarehouse.of_anytable('customer',ls_where)			 
IF g.i_nwarehouse.ids_any.Rowcount() = 1 THEN
	adw_bol.object.delivery_master_rem_cust_name[1] =g.i_nwarehouse.ids_any.object.cust_name[1] 
	adw_bol.object.delivery_master_rem_address_1[1]=g.i_nwarehouse.ids_any.object.Address_1[1]
	adw_bol.object.delivery_master_rem_address_2[1]=g.i_nwarehouse.ids_any.object.Address_2[1]
	adw_bol.object.delivery_master_rem_address_3[1]=g.i_nwarehouse.ids_any.object.Address_3[1]
	adw_bol.object.delivery_master_rem_address_4[1]=g.i_nwarehouse.ids_any.object.Address_4[1]
	adw_bol.object.delivery_master_rem_city[1]=g.i_nwarehouse.ids_any.object.city[1]
	adw_bol.object.delivery_master_rem_state[1]=g.i_nwarehouse.ids_any.object.state[1]
	adw_bol.object.delivery_master_rem_zip[1]=g.i_nwarehouse.ids_any.object.zip[1]
	adw_bol.object.delivery_master_rem_country[1]=g.i_nwarehouse.ids_any.object.country[1]
	adw_bol.AcceptText()

END IF	
Return ll_rtn
end function

on n_cst_order.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_order.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

