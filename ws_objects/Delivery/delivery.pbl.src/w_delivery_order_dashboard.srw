$PBExportHeader$w_delivery_order_dashboard.srw
forward
global type w_delivery_order_dashboard from w_std_master_detail
end type
type st_non_otm_t from statictext within w_delivery_order_dashboard
end type
type st_otm_hold_t from statictext within w_delivery_order_dashboard
end type
type st_planning_t from statictext within w_delivery_order_dashboard
end type
type st_ready_t from statictext within w_delivery_order_dashboard
end type
type cb_n_n from commandbutton within w_delivery_order_dashboard
end type
type cb_n_p from commandbutton within w_delivery_order_dashboard
end type
type dw_select from datawindow within w_delivery_order_dashboard
end type
type cb_do_search from commandbutton within w_delivery_order_dashboard
end type
type st_new_status_t from statictext within w_delivery_order_dashboard
end type
type st_in_process_t from statictext within w_delivery_order_dashboard
end type
type st_picking_t from statictext within w_delivery_order_dashboard
end type
type st_packing_t from statictext within w_delivery_order_dashboard
end type
type cb_n_i from commandbutton within w_delivery_order_dashboard
end type
type cb_n_a from commandbutton within w_delivery_order_dashboard
end type
type cb_h_n from commandbutton within w_delivery_order_dashboard
end type
type cb_h_p from commandbutton within w_delivery_order_dashboard
end type
type cb_h_i from commandbutton within w_delivery_order_dashboard
end type
type cb_h_a from commandbutton within w_delivery_order_dashboard
end type
type cb_p_n from commandbutton within w_delivery_order_dashboard
end type
type cb_p_p from commandbutton within w_delivery_order_dashboard
end type
type cb_p_i from commandbutton within w_delivery_order_dashboard
end type
type cb_p_a from commandbutton within w_delivery_order_dashboard
end type
type cb_r_n from commandbutton within w_delivery_order_dashboard
end type
type cb_r_p from commandbutton within w_delivery_order_dashboard
end type
type cb_r_i from commandbutton within w_delivery_order_dashboard
end type
type cb_r_a from commandbutton within w_delivery_order_dashboard
end type
type cb_do_clear from commandbutton within w_delivery_order_dashboard
end type
type st_main_header_t from statictext within w_delivery_order_dashboard
end type
type cb_3 from commandbutton within w_delivery_order_dashboard
end type
type st_auto from statictext within w_delivery_order_dashboard
end type
type st_sims_header_t from statictext within w_delivery_order_dashboard
end type
type st_o_t from statictext within w_delivery_order_dashboard
end type
type st_t_t from statictext within w_delivery_order_dashboard
end type
type st_m_t from statictext within w_delivery_order_dashboard
end type
type r_otm_box_t from statictext within w_delivery_order_dashboard
end type
type st_filler_t from statictext within w_delivery_order_dashboard
end type
type st_receipt_t from statictext within w_delivery_order_dashboard
end type
type cb_n_r from commandbutton within w_delivery_order_dashboard
end type
type cb_h_r from commandbutton within w_delivery_order_dashboard
end type
type cb_p_r from commandbutton within w_delivery_order_dashboard
end type
type cb_r_r from commandbutton within w_delivery_order_dashboard
end type
end forward

global type w_delivery_order_dashboard from w_std_master_detail
integer width = 3045
integer height = 1692
boolean center = true
event ue_search ( )
st_non_otm_t st_non_otm_t
st_otm_hold_t st_otm_hold_t
st_planning_t st_planning_t
st_ready_t st_ready_t
cb_n_n cb_n_n
cb_n_p cb_n_p
dw_select dw_select
cb_do_search cb_do_search
st_new_status_t st_new_status_t
st_in_process_t st_in_process_t
st_picking_t st_picking_t
st_packing_t st_packing_t
cb_n_i cb_n_i
cb_n_a cb_n_a
cb_h_n cb_h_n
cb_h_p cb_h_p
cb_h_i cb_h_i
cb_h_a cb_h_a
cb_p_n cb_p_n
cb_p_p cb_p_p
cb_p_i cb_p_i
cb_p_a cb_p_a
cb_r_n cb_r_n
cb_r_p cb_r_p
cb_r_i cb_r_i
cb_r_a cb_r_a
cb_do_clear cb_do_clear
st_main_header_t st_main_header_t
cb_3 cb_3
st_auto st_auto
st_sims_header_t st_sims_header_t
st_o_t st_o_t
st_t_t st_t_t
st_m_t st_m_t
r_otm_box_t r_otm_box_t
st_filler_t st_filler_t
st_receipt_t st_receipt_t
cb_n_r cb_n_r
cb_h_r cb_h_r
cb_p_r cb_p_r
cb_r_r cb_r_r
end type
global w_delivery_order_dashboard w_delivery_order_dashboard

type variables
Datawindow    idw_select
Datastore ids_Outbound_Count

String is_sql
boolean ib_sched_from_first
boolean ib_sched_to_first

Private boolean ib_auto


end variables

forward prototypes
public subroutine setbuttonvalues (string asbutton, string asvalue)
public subroutine clearbuttons ()
public function integer uf_get_w_do ()
public function integer of_getparentwindow (window aw_parent)
public subroutine uf_searchdrilldown (string as_otmstatus, string as_ordstatus, boolean ab_shuttlesearchflag)
end prototypes

event ue_search();DateTime ldt_date, ldtGMT
Date ld_Local
String str_eds_to, str_eds_from
String ls_string,   ls_sql 
Boolean	lsUseSku
Boolean  lsuseCONTID,lsusePONO
Boolean lb_order_from, lb_order_to, lb_complete_from, lb_complete_to,lb_where
Long llRowCount, llRowPos
String str_OTM_Status, str_Ord_Status, strBtnGrid
Long ll_Total

//TimA 07/13/12 Pandora issue 452.  Add counds for completed orders that have DOS in User_Field1 or Shuttle orders
String lsSelect, lsWhereSchDT, lsGroup , lsWhere1, lsWhere2, lsUnion

ids_Outbound_Count = create datastore
ids_Outbound_Count.Dataobject = 'd_do_dashboard_count'
ids_Outbound_Count.settransobject(sqlca)

is_sql = ids_Outbound_Count.GetSQLSelect()

//Initialize Date Flags
lb_order_from 		= FALSE
lb_order_to 		= FAlSE
lb_complete_from 	= FALSE
lb_complete_to 	= FALSE

lb_where = False

If idw_select.AcceptText() = -1 Then Return

ClearButtons()

//select OTM_Status, ord_status, count(*) as total 
//from Delivery_Master 
//where 
//Project_ID = :as_project
//And (Schedule_Date < dateadd(month,((YEAR(:ad_WH_Date)-1900)*12)+MONTH(:ad_WH_Date)-1,DAY(:ad_WH_Date)-1) + ' 23:59:59' or Schedule_Date Is Null)
//and ord_status In('N','P','I','A')
//and OTM_Status in('N','H','P','R')
//group by OTM_Status,Ord_Status

lsSelect = "select OTM_Status, ord_status, count(*) as total from Delivery_Master "

lsWhereSchDT = " where delivery_master.project_id = '" + gs_project + "' "

ls_string = idw_select.GetItemString(1,"warehouse")
if not isNull(ls_string) then
	lsWhereSchDT += " and delivery_master.wh_code = '" + ls_string + "' "
	lb_where = TRUE
end if

ldt_date = idw_select.GetItemDateTime(1,"sched_delivery_date_s") //From
If  Not IsNull(ldt_date) Then
	str_eds_from = string(ldt_date)
	lsWhereSchDT += " and delivery_master.schedule_date >= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
		
	//is_where += " and delivery_master.schedule_date >= '" + &
	//	String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_complete_from = TRUE
	lb_where = TRUE
End If

ldt_date = idw_select.GetItemDateTime(1,"sched_delivery_date_e") //To
If  Not IsNull(ldt_date) Then
	str_eds_to = string(ldt_date)
End If

If   IsNull(str_eds_to) or  str_eds_to = '' Then
	//If the To Date is not set default to the local date and time at 23:59:59
	ld_Local = today()
	lsWhereSchDT += " And (Schedule_Date <= dateadd(month,((YEAR('" + String(ld_Local) + "')-1900)*12)+MONTH('" + String(ld_Local) + "')-1,DAY('" + String(ld_Local) + "')-1) + ' 23:59:59' or Schedule_Date Is Null)"
	//is_where += " And (Schedule_Date <= dateadd(month,((YEAR(GetDate())-1900)*12)+MONTH(GetDate())-1,DAY(GetDate())-1) + ' 23:59:59' or Schedule_Date Is Null)"
Else
	lsWhereSchDT += " And (Schedule_Date <= '" + str_eds_to + "' or Schedule_Date Is Null)"
	//is_where += " And (Schedule_Date <= '" + str_eds_to + "' or Schedule_Date Is Null)"
End if

lsWhere1 += " and ord_status In('N','P','I','A') and OTM_Status in('N','H','P','R')"
lsGroup = " group by OTM_Status,Ord_Status"

ls_sql += lsSelect + lsWhereSchDT + lsWhere1 + lsGroup

lsUnion = " Union All "

lsWhere2 = " and ord_status In('C') and User_Field1 = 'DOS' "
//lsWhere2 = " and Delivery_Date is Null and ord_status In('C') and User_Field1 = 'DOS' "

ls_sql += lsUnion +lsSelect + lsWhereSchDT + lsWhere2 + lsGroup

//ClipBoard(ls_sql)
//MessageBox ("sql", ls_sql)

ids_Outbound_Count.SetSqlSelect(ls_sql)
ids_Outbound_Count.Retrieve()

llRowCount = ids_Outbound_Count.rowcount()
For llRowPos = 1 to llRowCount
	str_OTM_Status = ids_Outbound_Count.getitemstring(llRowPos,'OTM_Status')
	str_Ord_Status = ids_Outbound_Count.getitemstring(llRowPos,'Ord_Status')
	ll_Total = ids_Outbound_Count.getitemNumber(llRowPos,'total')
	strBtnGrid = 'cb_' + str_OTM_Status + '_' + str_Ord_Status
	
	setbuttonvalues(strBtnGrid, String(ll_total))
	
	
next

If ids_Outbound_Count.Retrieve() = 0 Then
//	messagebox(is_title,"No records found!")
End If

SetPointer(arrow!)
end event

public subroutine setbuttonvalues (string asbutton, string asvalue);//TimA 07/13/12 Pandora issue #452 add new count buttons for completed orders.

	Choose case asbutton
		Case 'cb_N_N'		//non OTM
			This.cb_n_n.Text = asvalue
		Case 'cb_N_P'
			This.cb_n_p.Text = asvalue			
		Case 'cb_N_I'	
			This.cb_n_i.Text = asvalue						
		Case 'cb_N_A'
			This.cb_n_a.Text = asvalue
		Case 'cb_N_C'
			This.cb_n_r.Text = asvalue			
		Case 'cb_H_N'    //OTM Hold
			This.cb_h_n.Text = asvalue
		Case 'cb_H_P'
			This.cb_h_p.Text = asvalue
		Case 'cb_H_I'
			This.cb_h_i.Text = asvalue
		Case 'cb_H_A'
			This.cb_h_a.Text = asvalue
		Case 'cb_H_C'
			This.cb_h_r.Text = asvalue			
		Case 'cb_P_N'    //Planning
			This.cb_p_n.Text = asvalue
		Case 'cb_P_P'
			This.cb_p_p.Text = asvalue
		Case 'cb_P_I'
			This.cb_p_i.Text = asvalue
		Case 'cb_P_A'
			This.cb_p_a.Text = asvalue
		Case 'cb_P_C'
			This.cb_p_r.Text = asvalue			
		Case 'cb_R_N'    //Ready
			This.cb_r_n.Text = asvalue
		Case 'cb_R_P'
			This.cb_r_p.Text = asvalue
		Case 'cb_R_I'
			This.cb_r_i.Text = asvalue
		Case 'cb_R_A'
			This.cb_r_a.Text = asvalue									
		Case 'cb_R_C'
			This.cb_r_r.Text = asvalue												
	End Choose
end subroutine

public subroutine clearbuttons ();//TimA 07/13/12 Pandora issue #452 add new count buttons for completed orders.

		setbuttonvalues( 'cb_N_N','')		//non OTM

		setbuttonvalues( 'cb_N_P','')

		setbuttonvalues( 'cb_N_I','')	

		setbuttonvalues( 'cb_N_A','')
		
		setbuttonvalues( 'cb_N_C','')

		setbuttonvalues( 'cb_H_N' ,'')   //OTM Hold

		setbuttonvalues( 'cb_H_P','')

		setbuttonvalues( 'cb_H_I','')

		setbuttonvalues( 'cb_H_A','')
		
		setbuttonvalues( 'cb_H_C','')		

		setbuttonvalues( 'cb_P_N','')    //Planning

		setbuttonvalues( 'cb_P_P','')

		setbuttonvalues( 'cb_P_I','')

		setbuttonvalues( 'cb_P_A','')
		
		setbuttonvalues( 'cb_P_C','')		

		setbuttonvalues( 'cb_R_N','')    //Ready

		setbuttonvalues( 'cb_R_P','')

		setbuttonvalues( 'cb_R_I','')

		setbuttonvalues( 'cb_R_A','')

		setbuttonvalues( 'cb_R_C','')
end subroutine

public function integer uf_get_w_do ();Long	ll_Open
Str_parms	lStrparms
	
Lstrparms.String_arg[1] = "W_DOR"
//MessageBox("Outbound not Open", "To avoid this message in the future make sure the Outbound screen is open before you drill down the search")

ll_open = OpenSheetwithparm(w_do,lStrparms, w_main , gi_menu_pos,Original!)
this.setfocus( )	
//Send(Handle(w_do), 274, 61472, 0) //to minimize

//Send(Handle(dw_whatever), 274, 61488, 0) //to maximize

//Send(Handle(dw_whatever), 274, 61728, 0) //to restore to normal
return ll_open
end function

public function integer of_getparentwindow (window aw_parent);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_GetParentWindow
//
//	Access:  public
//
//	Arguments:
//	aw_parent   The Parent window for this object (passed by reference).
//	   If a parent window is not found, aw_parent is NULL
//
//	Returns:  integer
//	 1 = success
//	-1 = error
//
//	Description:	 Calculates the parent window of a window object
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

powerobject	lpo_parent

lpo_parent = this.GetParent()

// Loop getting the parent of the object until it is of type window!
do while IsValid (lpo_parent) 
	if lpo_parent.TypeOf() <> window! then
		lpo_parent = lpo_parent.GetParent()
	else
		exit
	end if
loop

if IsNull(lpo_parent) Or not IsValid (lpo_parent) then
	setnull(aw_parent)	
	return -1
end If

aw_parent = lpo_parent
return 1

end function

public subroutine uf_searchdrilldown (string as_otmstatus, string as_ordstatus, boolean ab_shuttlesearchflag);Datetime ld_EST_From, ld_EST_To
String ls_StrSelect, ls_SQL
String ls_WH, User_Field1

If Not isvalid(w_do) Then
	If uf_get_w_do() = -1 then
		Messagebox ("","Error opening the outbound screen")
		Return
	End if
End if

ld_EST_To = idw_select.GetItemDateTime(1,"sched_delivery_date_e") //To
ld_EST_From = idw_select.GetItemDateTime(1,"sched_delivery_date_s") //From

ls_WH = idw_select.GetItemString(1,"warehouse")

	If isvalid(w_do) then
		//w_do.tab_main.SelectTab(10) //13-May-2014 :Madhu- commented 
		w_do.tab_main.SelectTab(11) //13-May-2014 :Madhu- Search Tab changed to 11.
		w_do.tab_main.tabpage_search.setfocus()
		/* Gailm Issue 605 - MultiSelect status change
		w_do.tab_main.tabpage_search.dw_search.Object.ord_status[1] = as_OrdStatus
		w_do.tab_main.tabpage_search.dw_search.Object.contract_order[1] = as_OTMStatus */

	  	w_do.tab_main.tabpage_search.uo_ord_status.uf_init("d_ord_status_search_list","delivery_master.ord_status","ord_status")
		w_do.tab_main.tabpage_search.uo_otm_ord_status.uf_init("d_do_otm_status_list","delivery_master.otm_status","otm_status")

		w_do.tab_main.tabpage_search.uo_ord_status.uf_clear_list( ) 
		w_do.tab_main.tabpage_search.uo_otm_ord_status.uf_clear_list( ) 
		
		w_do.tab_main.tabpage_search.uo_ord_status.uf_set_selected(as_OrdStatus)
		w_do.tab_main.tabpage_search.uo_otm_ord_status.uf_set_selected(as_OTMStatus)
		
		If not IsNull(ls_WH) then
			w_do.tab_main.tabpage_search.dw_search.Object.WH_Code[1] = ls_WH
		End if
		w_do.tab_main.tabpage_search.dw_search.Object.sched_delivery_date_s[1] = ld_EST_From
		w_do.tab_main.tabpage_search.dw_search.Object.sched_delivery_date_e[1] = ld_EST_To
		//TimA 07/13/12 Pandora issue #452 add new count buttons for completed orders.
		If ab_shuttlesearchflag = True then
			w_do.tab_main.tabpage_search.dw_search.Object.user_field1[1] = 'DOS'		
		Else
			w_do.tab_main.tabpage_search.dw_search.Object.user_field1[1] = ''
		End if
		w_do.ib_SearchCalledFromDashboard = true
		w_do.tab_main.tabpage_search.cb_do_search.POST Event clicked ( )
		w_do.setfocus()
		//w_do.tab_main.POST SelectTab(10) //13-May-2014 :Madhu- commented
		w_do.tab_main.POST SelectTab(11) //13-May-2014 :Madhu- Search Tab changed to 11.

		//Send(Handle(w_do), 274, 61728, 0) //to restore to normal
	end if
end subroutine

on w_delivery_order_dashboard.create
int iCurrent
call super::create
this.st_non_otm_t=create st_non_otm_t
this.st_otm_hold_t=create st_otm_hold_t
this.st_planning_t=create st_planning_t
this.st_ready_t=create st_ready_t
this.cb_n_n=create cb_n_n
this.cb_n_p=create cb_n_p
this.dw_select=create dw_select
this.cb_do_search=create cb_do_search
this.st_new_status_t=create st_new_status_t
this.st_in_process_t=create st_in_process_t
this.st_picking_t=create st_picking_t
this.st_packing_t=create st_packing_t
this.cb_n_i=create cb_n_i
this.cb_n_a=create cb_n_a
this.cb_h_n=create cb_h_n
this.cb_h_p=create cb_h_p
this.cb_h_i=create cb_h_i
this.cb_h_a=create cb_h_a
this.cb_p_n=create cb_p_n
this.cb_p_p=create cb_p_p
this.cb_p_i=create cb_p_i
this.cb_p_a=create cb_p_a
this.cb_r_n=create cb_r_n
this.cb_r_p=create cb_r_p
this.cb_r_i=create cb_r_i
this.cb_r_a=create cb_r_a
this.cb_do_clear=create cb_do_clear
this.st_main_header_t=create st_main_header_t
this.cb_3=create cb_3
this.st_auto=create st_auto
this.st_sims_header_t=create st_sims_header_t
this.st_o_t=create st_o_t
this.st_t_t=create st_t_t
this.st_m_t=create st_m_t
this.r_otm_box_t=create r_otm_box_t
this.st_filler_t=create st_filler_t
this.st_receipt_t=create st_receipt_t
this.cb_n_r=create cb_n_r
this.cb_h_r=create cb_h_r
this.cb_p_r=create cb_p_r
this.cb_r_r=create cb_r_r
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_non_otm_t
this.Control[iCurrent+2]=this.st_otm_hold_t
this.Control[iCurrent+3]=this.st_planning_t
this.Control[iCurrent+4]=this.st_ready_t
this.Control[iCurrent+5]=this.cb_n_n
this.Control[iCurrent+6]=this.cb_n_p
this.Control[iCurrent+7]=this.dw_select
this.Control[iCurrent+8]=this.cb_do_search
this.Control[iCurrent+9]=this.st_new_status_t
this.Control[iCurrent+10]=this.st_in_process_t
this.Control[iCurrent+11]=this.st_picking_t
this.Control[iCurrent+12]=this.st_packing_t
this.Control[iCurrent+13]=this.cb_n_i
this.Control[iCurrent+14]=this.cb_n_a
this.Control[iCurrent+15]=this.cb_h_n
this.Control[iCurrent+16]=this.cb_h_p
this.Control[iCurrent+17]=this.cb_h_i
this.Control[iCurrent+18]=this.cb_h_a
this.Control[iCurrent+19]=this.cb_p_n
this.Control[iCurrent+20]=this.cb_p_p
this.Control[iCurrent+21]=this.cb_p_i
this.Control[iCurrent+22]=this.cb_p_a
this.Control[iCurrent+23]=this.cb_r_n
this.Control[iCurrent+24]=this.cb_r_p
this.Control[iCurrent+25]=this.cb_r_i
this.Control[iCurrent+26]=this.cb_r_a
this.Control[iCurrent+27]=this.cb_do_clear
this.Control[iCurrent+28]=this.st_main_header_t
this.Control[iCurrent+29]=this.cb_3
this.Control[iCurrent+30]=this.st_auto
this.Control[iCurrent+31]=this.st_sims_header_t
this.Control[iCurrent+32]=this.st_o_t
this.Control[iCurrent+33]=this.st_t_t
this.Control[iCurrent+34]=this.st_m_t
this.Control[iCurrent+35]=this.r_otm_box_t
this.Control[iCurrent+36]=this.st_filler_t
this.Control[iCurrent+37]=this.st_receipt_t
this.Control[iCurrent+38]=this.cb_n_r
this.Control[iCurrent+39]=this.cb_h_r
this.Control[iCurrent+40]=this.cb_p_r
this.Control[iCurrent+41]=this.cb_r_r
end on

on w_delivery_order_dashboard.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_non_otm_t)
destroy(this.st_otm_hold_t)
destroy(this.st_planning_t)
destroy(this.st_ready_t)
destroy(this.cb_n_n)
destroy(this.cb_n_p)
destroy(this.dw_select)
destroy(this.cb_do_search)
destroy(this.st_new_status_t)
destroy(this.st_in_process_t)
destroy(this.st_picking_t)
destroy(this.st_packing_t)
destroy(this.cb_n_i)
destroy(this.cb_n_a)
destroy(this.cb_h_n)
destroy(this.cb_h_p)
destroy(this.cb_h_i)
destroy(this.cb_h_a)
destroy(this.cb_p_n)
destroy(this.cb_p_p)
destroy(this.cb_p_i)
destroy(this.cb_p_a)
destroy(this.cb_r_n)
destroy(this.cb_r_p)
destroy(this.cb_r_i)
destroy(this.cb_r_a)
destroy(this.cb_do_clear)
destroy(this.st_main_header_t)
destroy(this.cb_3)
destroy(this.st_auto)
destroy(this.st_sims_header_t)
destroy(this.st_o_t)
destroy(this.st_t_t)
destroy(this.st_m_t)
destroy(this.r_otm_box_t)
destroy(this.st_filler_t)
destroy(this.st_receipt_t)
destroy(this.cb_n_r)
destroy(this.cb_h_r)
destroy(this.cb_p_r)
destroy(this.cb_r_r)
end on

event ue_postopen;call super::ue_postopen;datawindowchild	ldwc, ldwc2, ldwcgrp, ldwcgrp2
datetime ldt_end_date
Long llRow

idw_select = dw_select

idw_select.GetChild('warehouse', ldwc)
ldwc.SetTransObject(Sqlca)
g.of_set_warehouse_dropdown(ldwc)

idw_select.insertrow(0)

llRow = idw_select.getrow()

ldt_end_date = f_get_date("END")
idw_select.SetItem(llRow, 'sched_delivery_date_e', ldt_end_date) 

If gs_default_WH > '' Then
	idw_select.SetITem(llRow,'warehouse',gs_default_WH) 
End IF

st_auto.visible = false
cb_do_search.Event clicked()
cb_do_search.setfocus()



end event

event timer;call super::timer;string ls_now
long ll_hr
boolean lb_process = true

this.event ue_search( )

// Compute the current time.
ls_now = string(datetime(today(), now()))
				

end event

event ue_preopen;call super::ue_preopen;Long ll_TurnOnResize
ll_TurnOnResize = This.of_SetResize(True)

//inv_resize.of_SetMinSize( 1500, (cb_clear.Height + 30) * 3)

//inv_resize.of_SetMinSize( cbx_batchmode.X + cb_clear.Width *3 + 145,   mle_history.Y + cb_clear.Height *3 + 90)

 //This.inv_resize.of_Register(dw_select, this.inv_resize.SCALEBOTTOM)
If ll_TurnOnResize = 1 then
//This.width = 2600
//TimA 07/13/12 Pandora issue #452 add new count buttons for completed orders.
This.width = 3000
this.height = 1700
	This.inv_resize.of_SetMinSize( 2500 ,  1732 )	
	
	//Main Header and datawindow
	This.inv_resize.of_Register(st_Main_header_t, this.inv_resize.SCALERIGHT)
	//This.inv_resize.of_Register(dw_select, this.inv_resize.SCALE)
	//This.inv_resize.of_Register(cb_do_search, this.inv_resize.SCALE)
	//This.inv_resize.of_Register(cb_do_clear, this.inv_resize.SCALE)
	
	//Ord Status Headers
	This.inv_resize.of_Register(st_SIMS_Header_t, this.inv_resize.SCALE)
	This.inv_resize.of_Register(st_new_status_t, this.inv_resize.SCALE)
	This.inv_resize.of_Register(st_In_Process_t, this.inv_resize.SCALE)
	This.inv_resize.of_Register(st_Picking_t, this.inv_resize.SCALE)
	This.inv_resize.of_Register(st_packing_t, this.inv_resize.SCALE)
	This.inv_resize.of_Register(st_Filler_t, this.inv_resize.SCALE)	
	
	
	//Count Buttons
	This.inv_resize.of_Register(cb_n_n, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_n_p, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_n_i, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_n_a, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_n_r, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_h_n, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_h_p, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_h_i, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_h_a, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_h_r, this.inv_resize.SCALE)	
	This.inv_resize.of_Register(cb_p_n, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_p_p, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_p_i, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_p_a, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_p_r, this.inv_resize.SCALE)	
	This.inv_resize.of_Register(cb_r_n, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_r_p, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_r_i, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_r_a, this.inv_resize.SCALE)
	This.inv_resize.of_Register(cb_r_r, this.inv_resize.SCALE)	
	
	//OTM Header labels
	This.inv_resize.of_Register(r_otm_box_t, this.inv_resize.SCALE)
	This.inv_resize.of_Register(st_o_t, this.inv_resize.SCALE)
	This.inv_resize.of_Register(st_t_t, this.inv_resize.SCALE)
	This.inv_resize.of_Register(st_m_t, this.inv_resize.SCALE)
	This.inv_resize.of_Register(st_non_otm_t, this.inv_resize.SCALE)
	This.inv_resize.of_Register(st_otm_hold_t, this.inv_resize.SCALE)
	This.inv_resize.of_Register(st_planning_t, this.inv_resize.SCALE)
	This.inv_resize.of_Register(st_ready_t, this.inv_resize.SCALE)
	This.inv_resize.of_Register(st_receipt_t, this.inv_resize.SCALE)
	 
	//Auto Time Button 
	This.inv_resize.of_Register(cb_3, this.inv_resize.FIXEDRIGHTBOTTOM)
	This.inv_resize.of_Register(st_auto, this.inv_resize.FIXEDRIGHTBOTTOM)
End if
end event

type tab_main from w_std_master_detail`tab_main within w_delivery_order_dashboard
boolean visible = false
integer x = 334
integer y = 1368
integer width = 142
integer height = 120
end type

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
boolean visible = false
integer width = 105
integer height = -8
end type

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer width = 105
integer height = -8
end type

type st_non_otm_t from statictext within w_delivery_order_dashboard
integer x = 146
integer y = 760
integer width = 453
integer height = 112
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "NON OTM"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_otm_hold_t from statictext within w_delivery_order_dashboard
integer x = 146
integer y = 868
integer width = 453
integer height = 112
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "OTM Hold"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_planning_t from statictext within w_delivery_order_dashboard
integer x = 146
integer y = 976
integer width = 453
integer height = 112
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Planning"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_ready_t from statictext within w_delivery_order_dashboard
integer x = 146
integer y = 1084
integer width = 453
integer height = 112
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Ready"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_n_n from commandbutton within w_delivery_order_dashboard
integer x = 599
integer y = 760
integer width = 453
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('N','N',False)

end event

type cb_n_p from commandbutton within w_delivery_order_dashboard
integer x = 1047
integer y = 760
integer width = 453
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('N','P',False)
end event

type dw_select from datawindow within w_delivery_order_dashboard
integer x = 37
integer y = 200
integer width = 2821
integer height = 308
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_do_dashboard_search"
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string 	ls_column
DatawindowChild	ldwc
long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "sched_delivery_date_s"
		
		IF ib_sched_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("sched_delivery_date_s")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_sched_from_first = FALSE
			
		END IF
		
	CASE "sched_delivery_date_e"
		
		IF ib_sched_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("sched_delivery_date_e")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_sched_to_first = FALSE
			
		END IF
END CHOOSE
end event

event constructor;ib_sched_from_first 		= TRUE
ib_sched_to_first 		= TRUE
end event

type cb_do_search from commandbutton within w_delivery_order_dashboard
integer x = 2537
integer y = 240
integer width = 270
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;parent.event ue_search( )


end event

event constructor;g.of_check_label_button(this)
end event

type st_new_status_t from statictext within w_delivery_order_dashboard
integer x = 599
integer y = 648
integer width = 453
integer height = 112
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "New"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_in_process_t from statictext within w_delivery_order_dashboard
integer x = 1047
integer y = 648
integer width = 453
integer height = 112
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "In Process"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_picking_t from statictext within w_delivery_order_dashboard
integer x = 1495
integer y = 648
integer width = 453
integer height = 112
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Picking"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_packing_t from statictext within w_delivery_order_dashboard
integer x = 1943
integer y = 648
integer width = 453
integer height = 112
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Packing"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_n_i from commandbutton within w_delivery_order_dashboard
integer x = 1495
integer y = 760
integer width = 453
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('N','I',False)
end event

type cb_n_a from commandbutton within w_delivery_order_dashboard
integer x = 1943
integer y = 760
integer width = 453
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('N','A',False)
end event

type cb_h_n from commandbutton within w_delivery_order_dashboard
integer x = 599
integer y = 868
integer width = 453
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('H','N',False)
end event

type cb_h_p from commandbutton within w_delivery_order_dashboard
integer x = 1047
integer y = 868
integer width = 453
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('H','P',False)
end event

type cb_h_i from commandbutton within w_delivery_order_dashboard
integer x = 1495
integer y = 868
integer width = 453
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('H','I',False)
end event

type cb_h_a from commandbutton within w_delivery_order_dashboard
integer x = 1943
integer y = 868
integer width = 453
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('H','A',False)
end event

type cb_p_n from commandbutton within w_delivery_order_dashboard
integer x = 599
integer y = 976
integer width = 453
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('P','N',False)
end event

type cb_p_p from commandbutton within w_delivery_order_dashboard
integer x = 1047
integer y = 976
integer width = 453
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('P','P',False)
end event

type cb_p_i from commandbutton within w_delivery_order_dashboard
integer x = 1495
integer y = 976
integer width = 453
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('P','I',False)
end event

type cb_p_a from commandbutton within w_delivery_order_dashboard
integer x = 1943
integer y = 976
integer width = 453
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('P','A',False)
end event

type cb_r_n from commandbutton within w_delivery_order_dashboard
integer x = 599
integer y = 1084
integer width = 453
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('R','N',False)
end event

type cb_r_p from commandbutton within w_delivery_order_dashboard
integer x = 1047
integer y = 1084
integer width = 453
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('R','P',False)
end event

type cb_r_i from commandbutton within w_delivery_order_dashboard
integer x = 1495
integer y = 1084
integer width = 453
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('R','I',False)
end event

type cb_r_a from commandbutton within w_delivery_order_dashboard
integer x = 1943
integer y = 1084
integer width = 453
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('R','A',False)
end event

type cb_do_clear from commandbutton within w_delivery_order_dashboard
integer x = 2533
integer y = 360
integer width = 270
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;Long llRow
DateTime ldt_end_date

dw_select.Reset()
dw_select.InsertRow(0)

llRow = idw_select.getrow()

ldt_end_date = f_get_date("END")
idw_select.SetItem(llRow, 'sched_delivery_date_e', ldt_end_date) 

If gs_default_WH > '' Then
	dw_select.SetITem(llRow,'warehouse',gs_default_WH)
	cb_do_search.Event clicked()
End If

//idw_result.Reset()

end event

event constructor;
g.of_check_label_button(this)
end event

type st_main_header_t from statictext within w_delivery_order_dashboard
integer x = 37
integer y = 36
integer width = 2821
integer height = 140
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Planned Shipments"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_delivery_order_dashboard
integer x = 2254
integer y = 1224
integer width = 603
integer height = 120
integer taborder = 40
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Auto Refresh Off"
end type

event clicked;// If were in auto mode,
If ib_auto then
		
	// Reset ib_auto
	ib_auto = false
	
	// Deactivate the timer.
	timer(0)
	st_auto.visible = false

	// Reset the button text.
	text = "Auto Refresh Off"
	
// Otherwise, if were not already in auto mode,
else
	st_auto.visible = true

	// Reset ib_auto
	ib_auto = true
	
	// Activate the timer.
	//timer(30)
	timer(300)
	
	// Reset the button text.
	text = "Auto Refresh On"
	
// End if were not already in auto mode.
End If
end event

event getfocus;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  			getfocus
//
//	(Arguments:		None)
//
//	(Returns:  		None)
//
//	Description:	If appropriate, notify the parent window that this
//						control got focus.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

window 	lw_parent

//Check for microhelp requirements.
//If gnv_app.of_GetMicrohelp() Then
	//Notify the parent.
	of_GetParentWindow(lw_parent)
	If IsValid(lw_parent) Then
		lw_parent.Dynamic Event pfc_ControlGotFocus (this)
	End If
//End If

end event

type st_auto from statictext within w_delivery_order_dashboard
integer x = 2098
integer y = 1368
integer width = 773
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Auto search every 5 minutes"
boolean focusrectangle = false
end type

type st_sims_header_t from statictext within w_delivery_order_dashboard
integer x = 599
integer y = 568
integer width = 2263
integer height = 80
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "SIMS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_o_t from statictext within w_delivery_order_dashboard
integer x = 41
integer y = 852
integer width = 91
integer height = 80
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "O"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_t_t from statictext within w_delivery_order_dashboard
integer x = 41
integer y = 928
integer width = 91
integer height = 80
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "T"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_m_t from statictext within w_delivery_order_dashboard
integer x = 41
integer y = 1004
integer width = 91
integer height = 80
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "M"
alignment alignment = center!
boolean focusrectangle = false
end type

type r_otm_box_t from statictext within w_delivery_order_dashboard
integer x = 27
integer y = 760
integer width = 123
integer height = 436
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "  "
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_filler_t from statictext within w_delivery_order_dashboard
integer x = 27
integer y = 568
integer width = 571
integer height = 192
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "  "
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_receipt_t from statictext within w_delivery_order_dashboard
integer x = 2391
integer y = 648
integer width = 471
integer height = 112
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Receipt Reqd"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_n_r from commandbutton within w_delivery_order_dashboard
integer x = 2391
integer y = 760
integer width = 471
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('N','C',True)
end event

type cb_h_r from commandbutton within w_delivery_order_dashboard
integer x = 2391
integer y = 868
integer width = 471
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('H','C',True)
end event

type cb_p_r from commandbutton within w_delivery_order_dashboard
integer x = 2391
integer y = 976
integer width = 471
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('P','C',True)
end event

type cb_r_r from commandbutton within w_delivery_order_dashboard
integer x = 2391
integer y = 1084
integer width = 471
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
end type

event clicked;uf_SearchDrillDown('R','C',True)
end event

