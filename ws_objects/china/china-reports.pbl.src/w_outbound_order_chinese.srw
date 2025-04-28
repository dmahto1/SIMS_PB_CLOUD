$PBExportHeader$w_outbound_order_chinese.srw
$PBExportComments$OutBound Order Report (GAP - 8/02)
forward
global type w_outbound_order_chinese from w_std_report
end type
type uo_order_status_search from uo_multi_select_search within w_outbound_order_chinese
end type
end forward

global type w_outbound_order_chinese from w_std_report
integer width = 3566
integer height = 2100
string title = "Outbound Order"
event ue_load_philips_notes ( )
uo_order_status_search uo_order_status_search
end type
global w_outbound_order_chinese w_outbound_order_chinese

type variables
string 			is_origsql
string       	is_warehouse_code
string  			is_warehouse_name
string       	is_ord_type
string  			is_ord_type_desc
string       	is_ord_status
string  			is_ord_status_desc
datastore 		ids_find_warehouse
datastore 		ids_find_ord_type
DataWindowChild idwc_warehouse
boolean 			ib_first_time
boolean 			ib_movement_from_first
boolean 			ib_movement_to_first
boolean 			ib_movement_fromComp_first
boolean 			ib_movement_toComp_first
end variables

event ue_load_philips_notes();
//Load the Header Level Delivery Notes for Philips

Datastore	ldsNotes
String		lsDONO, lsDoNoPrev, lsNotes
Long	llRowPos, llRowCount, llNotesPos, llNotesCount



ldsNotes = Create DataStore
ldsNotes.dataobject = 'd_dono_notes'
ldsNotes.SetTransObject(SQLCA)

//For each report, retrieve notes when dono changes
llRowCount = dw_report.RowCount()
For llRowPos = 1 to llRowCount
	
	lsDONO = dw_report.GetItemString(lLRowPos,'do_no')
	
	If lsDoNo <> lsDoNoPrev Then
		
		lsNotes = ""
		
		llNotesCount = ldsNotes.Retrieve(gs_project,lsDONO)
		For llNotesPos = 1 to llNotesCount
			
			//Only want header notes
			If ldsNotes.GetItemNumber(llNotesPos,'line_item_No') = 0 Then
				lsNotes += ldsNotes.GetITemString(llNotesPos,'note_text') + " "
			End If
				
		Next
		
		lsDONOPrev = lsDONO
		
	End If /*dono changed*/
	
	dw_report.SetITem(llRowPos,'delivery_notes',lsNotes)
	
Next /*Report Row */
end event

on w_outbound_order_chinese.create
int iCurrent
call super::create
this.uo_order_status_search=create uo_order_status_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_order_status_search
end on

on w_outbound_order_chinese.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_order_status_search)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-450)
end event

event ue_retrieve;String 	ls_Where, 				&
 			ls_warehouse, 			&
 			ls_warehouse_name, 	&
 			ls_NewSql, 				&
 			ls_selection, 			&
 			ls_value, 				&
 			ls_whcode, 				&
 			ls_sku,					&
			ls_order_status

integer 	li_y, liRC

Long 		ll_balance, 			& 
			i, 						& 
			ll_row, 					&
			ll_cnt, 					& 
			ll_find_row
			
boolean 	lb_where

DateTime ldt_s, ldt_e


string lsSelect, lsendWhere, lsgroup
integer li_find_wherepos, li_find_grouppos

If dw_select.AcceptText() = -1 Then Return
lb_where = false

SetPointer(HourGlass!)
dw_report.Reset()

is_warehouse_code = dw_select.GetItemString(1, "wh_name")
IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
	MessageBox("ERROR", "Please select a warehouse",stopsign!)
ELSE
 
	// 7/02 GAP - Always tackon  Project id and warehouse
	ls_Where = ls_Where + " and delivery_master.Project_id = '" + gs_project + "'"
	ls_Where = ls_Where + " and delivery_master.WH_Code = '" + is_warehouse_code + "'"
	
	// 7/02 GAP - tackon  Order Type
	If dw_select.GetItemString(1, "ord_type") <> "" Then
		ls_Where = ls_Where + " and delivery_master.Ord_Type = '" + Left(dw_select.GetItemString(1, "ord_type"),1) + "'"
		lb_where = True
	end if
	
	// 7/02 GAP -  tackon  Order Status
//	If dw_select.GetItemString(1, "ord_status") <> "" Then

	ls_order_status = uo_order_status_search.uf_build_search(true)	

	
	if ls_order_status > "" then	
		
//		ls_Where = ls_Where + " and delivery_master.Ord_Status = '" + dw_select.GetItemString(1, "ord_status") + "'"

		ls_where = ls_where + ls_order_status

		lb_where = True
	end if
	
	//Tackon From Order Date
	If date(dw_select.GetItemDateTime(1, "ord_date_from")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and ord_date >= '" + string(dw_select.GetItemDateTime(1, "ord_date_from"),'mm-dd-yyyy hh:mm') + "'"
		ldt_s = dw_select.GetItemDateTime(1, "ord_date_from")
		lb_where = True
	End If
	
	//Tackon To Order Date
	If date(dw_select.GetItemDateTime(1, "ord_date_to")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and ord_date <= '" + string(dw_select.GetItemDateTime(1, "ord_date_to"),'mm-dd-yyyy hh:mm') + "'"
		ldt_e = dw_select.GetItemDateTime(1, "ord_date_to")
		lb_where = True
	End If
	
	//Tackon From Req Date
	If date(dw_select.GetItemDateTime(1, "req_date_from")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and request_date >= '" + string(dw_select.GetItemDateTime(1, "req_date_from"),'mm-dd-yyyy hh:mm') + "'"
		ldt_s = dw_select.GetItemDateTime(1, "req_date_from")
		lb_where = True
	End If
	
	//Tackon To Req Date
	If date(dw_select.GetItemDateTime(1, "req_date_to")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and request_date <= '" + string(dw_select.GetItemDateTime(1, "req_date_to"),'mm-dd-yyyy hh:mm') + "'"
		ldt_e = dw_select.GetItemDateTime(1, "req_date_to")
		lb_where = True
	End If
	
	//Tackon From Sched Date
	If date(dw_select.GetItemDateTime(1, "sched_date_from")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and schedule_date >= '" + string(dw_select.GetItemDateTime(1, "sched_date_from"),'mm-dd-yyyy hh:mm') + "'"
		ldt_s = dw_select.GetItemDateTime(1, "sched_date_from")
		lb_where = True
	End If
	
	//Tackon To Sched Date
	If date(dw_select.GetItemDateTime(1, "sched_date_to")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and schedule_date <= '" + string(dw_select.GetItemDateTime(1, "sched_date_to"),'mm-dd-yyyy hh:mm') + "'"
		ldt_e = dw_select.GetItemDateTime(1, "sched_date_to")
		lb_where = True
	End If
	

	//Tackon From Complete Date
	If date(dw_select.GetItemDateTime(1, "comp_date_from")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and complete_date >= '" + string(dw_select.GetItemDateTime(1, "comp_date_from"),'mm-dd-yyyy hh:mm') + "'"
		ldt_s = dw_select.GetItemDateTime(1, "comp_date_from")
		lb_where = True
	End If
	
	//Tackon To Complete Date
	If date(dw_select.GetItemDateTime(1, "comp_date_to")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and complete_date <= '" + string(dw_select.GetItemDateTime(1, "comp_date_to"),'mm-dd-yyyy hh:mm') + "'"
		ldt_e = dw_select.GetItemDateTime(1, "comp_date_to")	
		lb_where = True
	End If
	
	// 08/04 - PCONKL - Tackon Carrier Notified FRom Date
	If date(dw_select.GetItemDateTime(1, "Carrier_notified_from")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and Carrier_notified_date >= '" + string(dw_select.GetItemDateTime(1, "Carrier_notified_from"),'mm-dd-yyyy hh:mm') + "'"
		lb_where = True
	End If
	
	////08/04 - PCONKL - Tackon Carrier Notified To Date
	If date(dw_select.GetItemDateTime(1, "Carrier_notified_to")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and Carrier_notified_date <= '" + string(dw_select.GetItemDateTime(1, "Carrier_notified_to"),'mm-dd-yyyy hh:mm') + "'"
		lb_where = True
	End If
	
	if  not isnull(dw_select.GetItemString(1,"owner")) then
		
		
		ls_Where += " and Delivery_Detail.Owner_ID = " + dw_select.GetItemString(1,"owner") 
		lb_where = TRUE
		
	end if	
	

	// 8/02 GAP - Tackon Order BY
	//ls_Where = ls_Where + " ORDER BY Delivery_Master.Project_ID ASC," &  
   //      								+ " Warehouse.WH_Name ASC," & 
	//										+ " Delivery_Master.DO_No ASC," &  
   //      								+ " Delivery_Master.Invoice_No ASC"            								

//JXlim 07/22/2010 for 'SG_MUSER'   (d_outbound_order_sg_muser)		
If gs_project = 'SG-MUSER' Then
	//JXLIM 05/27/2010 Modify query due to sum of volumn in the select statment that required group by.
	ls_NewSQL = is_OrigSql
	lsSelect = ls_NewSQL
	
					
	
		//Removed Group by from query to form a new select statement up to the end of where
		li_find_wherepos = Pos(ls_NewSQL, "Group By") - 1				
		
		if li_find_wherepos > 0 then 
		
			ls_Newsql = left(ls_Newsql, li_find_wherepos)	
			
			//Strip out Group by for itself in order to add it to the end of the query.				
			li_find_grouppos = Pos(lsSelect, "Group By")
			lsgroup = Mid(lsSelect, li_find_grouppos)
		
		end if
						
		If ls_Where > '  ' Then
			//Jxlim 05/27/2010 reformat the query
			//ls_NewSql = is_OrigSql + ls_Where 
			ls_NewSql +=  ls_Where + lsGroup
			lirc = dw_report.setsqlselect(ls_Newsql)
		Else
			liRC = 	dw_report.setsqlselect(is_OrigSql)		
		End If
//Jxlim if not 'SG-MUSER stay original without group by (d_outbound_order)		
ELSE
	If ls_Where > '  ' Then			
			ls_NewSql = is_OrigSql + ls_Where 		
			lirc = dw_report.setsqlselect(ls_Newsql)
		Else
			liRC = 	dw_report.setsqlselect(is_OrigSql)		
		End If
END IF
//JXlim 07/22/2010 end of changed.	
		
	//DGM For giving warning for all no search criteria
	if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
	END IF	

	//ll_cnt = dw_report.Retrieve(ldt_s, ldt_e)
	dw_report.SetRedraw(False)
	ll_cnt = dw_report.Retrieve()
	IF ll_cnt > 0 Then
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
	Else
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
	End If 
END IF

// 05/09 - PCONKL - For Philips, we want to retrieve the Delivery Notes
//3-FEB-2019 :Madhu S28945 Added PHILIPSCLS
//Dinesh - 11/19/2020- S51443- Philips-DA
If gs_project = 'PHILIPS-SG'  or gs_project ='PHILIPSCLS' or gs_project ='PHILIPS-DA' Then
	This.TriggerEvent("ue_load_philips_Notes")
End If

dw_report.SetRedraw(True)




end event

event open;call super::open;//**********************************************************************************************************
// Any changes made in in this d_outbound_order Should also change in
//  d_3com_outbound_order
//  DGM 07/11/2005
//**********************************************************************************************************

// 05/09 - PCONKL - Different format for Philips
//3-FEB-2019 :Madhu S28945 Added PHILIPSCLS
//Dinesh - 11/19/2020- S51443- Philips-DA
If gs_project = 'PHILIPS-SG'  or gs_project ='PHILIPSCLS' or gs_project ='PHILIPS-DA' Then
	dw_report.dataobject = "d_outbound_order_philips"
	dw_report.SetTransObject(SQLCA)
End If

// Jxlim 07/22/2010 - Different format for SG-MUSER
If gs_project = 'SG-MUSER' Then
	dw_report.dataobject = "d_outbound_order_sg_muser"
	dw_report.SetTransObject(SQLCA)
End If

is_OrigSql = dw_report.getsqlselect()

uo_order_status_search.uf_init("d_ord_status_search_list_chinese", "delivery_master.Ord_Status", "ord_status")


end event

event ue_postopen;call super::ue_postopen;string ls_filter
DatawindowChild	ldwc_warehouse, ldc


//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(Sqlca)
ldwc_warehouse.Retrieve(gs_project)


dw_select.GetChild('owner', ldc)
ldc.SetTransObject(Sqlca)
ldc.Retrieve(gs_project)

end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
dw_select.SetFocus()

uo_order_status_search.uf_clear_list()
end event

type dw_select from w_std_report`dw_select within w_outbound_order_chinese
event process_enter pbm_dwnprocessenter
integer x = 0
integer y = 0
integer width = 3419
integer height = 464
string dataobject = "d_outbound_order_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::process_enter;Send(Handle(This),256,9,Long(0,0))
 Return 1
end event

event dw_select::constructor;call super::constructor;integer i, ll_row, ll_find_row

g.of_check_label(this) 

ib_movement_from_first = TRUE
ib_movement_to_first  = TRUE
ib_movement_fromComp_first = TRUE
ib_movement_toComp_first = TRUE

ib_first_time = true
ll_row = dw_select.insertrow(0)

//Create the locating warehouse name datastore
ids_find_warehouse = CREATE Datastore 
ids_find_warehouse.dataobject = 'd_project_warehouse'
ids_find_warehouse.SetTransObject(SQLCA)
ids_find_warehouse.Retrieve(gs_project)
ll_find_row = ids_find_warehouse.RowCount()
IF ll_find_row > 0 THEN
	i = 1
	DO while i <= ll_find_row
		is_warehouse_code = ids_find_warehouse.GetItemString(i,"wh_code")
		dw_select.SetValue("wh_name",i,is_warehouse_code)
		i +=1
	loop	
END IF
dw_select.SetItem(1,"wh_name",gs_default_wh)

//Create the locating warehouse name datastore
ids_find_ord_type = CREATE Datastore 
ids_find_ord_type.dataobject = 'dddw_delivery_order_type'
ids_find_ord_type.SetTransObject(SQLCA)
ids_find_ord_type.Retrieve(gs_project)
ll_find_row = ids_find_ord_type.RowCount()

IF ll_find_row > 0 THEN
	i = 1
	DO while i <= ll_find_row
		is_ord_type = ids_find_ord_type.GetItemString(i,"ord_type")
		is_ord_type_desc = ids_find_ord_type.GetItemString(i,"ord_type_desc")
		dw_select.SetValue("ord_type",i,  is_ord_type + " - " + is_ord_type_desc)
		//dw_products.SetValue("product_col", i, & prod_name + "~t" + String(prod_code))
		i +=1
	loop	
END IF



end event

event dw_select::clicked;call super::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "ord_date_from"
		
		IF ib_movement_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("ord_date_from")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_movement_from_first = FALSE
			
		END IF
		
	CASE "ord_date_to"
		
		IF ib_movement_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("ord_date_to")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_movement_to_first = FALSE
			
		END IF

CASE "comp_date_from"
		
		IF ib_movement_fromComp_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("comp_date_from")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			 ib_movement_fromComp_first = FALSE
			
		END IF
		
	CASE "comp_date_to"
		
		IF ib_movement_toComp_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("comp_date_to")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_movement_toComp_first = FALSE
			
		END IF
		
	CASE ELSE
		
END CHOOSE
end event

event dw_select::dberror;call super::dberror;messagebox("", sqlerrtext)
end event

type cb_clear from w_std_report`cb_clear within w_outbound_order_chinese
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_outbound_order_chinese
integer x = 5
integer y = 460
integer width = 3429
integer height = 1400
integer taborder = 30
string dataobject = "d_outbound_order_chinese"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_report::retrieveend;call super::retrieveend;Long	llRowCount,	llRowPos, llOwnerID
String	lsOwnerCd, lsOwnerType

//retrieve the Owner Name - with outer join to Picking LIst, we can't inner join to Owner Table 
If g.is_owner_ind = 'Y' Then
	
	This.SetRedraw(false)
	SetPointer(Hourglass!)
	lLRowCount = This.RowCount()
	For llRowPos = 1 to llRowCount
		
		llOWnerID = This.GetITemNumber(lLRowPos,'owner_id')
		If Not isnull(llOWnerID) Then
			
			Select Owner_cd, Owner_Type 
			Into	 :lsOWnerCd, :lsOwnerType
			From	 Owner
			Where Owner_id = :llOWnerID and project_id = :gs_Project;
			
			This.SetItem(llRowPos,'cf_owner_Name',Trim(lsOwnerCd) + '(' + lsOwnerType + ')')
			
		End If
		
	Next
	
	This.SetRedraw(True)
	SetPointer(Arrow!)
	
End If
end event

event dw_report::constructor;//*************************************************************************
// Any changes made in in this d_outbound_order Should also change in
//  d_3com_outbound_order
//  DGM 07/11/2005
//**********************************************************************************************************
IF gs_project = '3COM_NASH' THEN
	This.Dataobject = 'd_3com_outbound_order'
	This.SetTransObject(SQLCA)
END IF	
idw_current = this
//g.of_check_label(this) 
end event

event dw_report::dberror;call super::dberror;messagebox("", sqlerrtext)
end event

type uo_order_status_search from uo_multi_select_search within w_outbound_order_chinese
integer x = 361
integer y = 160
integer width = 672
integer taborder = 30
boolean bringtotop = true
end type

on uo_order_status_search.destroy
call uo_multi_select_search::destroy
end on

