HA$PBExportHeader$w_comcast_rawandfinished_inventory_rpt.srw
forward
global type w_comcast_rawandfinished_inventory_rpt from w_std_report
end type
end forward

global type w_comcast_rawandfinished_inventory_rpt from w_std_report
integer width = 3566
integer height = 2100
string title = "Comcast Daily Used Components Report"
event ue_load_philips_notes ( )
end type
global w_comcast_rawandfinished_inventory_rpt w_comcast_rawandfinished_inventory_rpt

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

on w_comcast_rawandfinished_inventory_rpt.create
call super::create
end on

on w_comcast_rawandfinished_inventory_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_retrieve;String 	ls_warehouse, 			&
 			ls_warehouse_name, 	&
 			ls_NewSql, 				&
 			ls_selection, 			&
 			ls_value, 				&
 			ls_whcode, lsLast, lsOldFormat, lsWriteLast
 		

integer 	li_y, liRC

Long 		ll_balance, 			& 
			i, 						& 
			ll_row, 					&
			ll_cnt, ll_rowpos, ll_rowcount, ll_skusum, ll_writesum
			

DateTime ldt_s, ldt_e, dt_start_date, dt_end_date
String fs


string lsSelect, lsWhere, lsGroup
integer li_find_wherepos, li_find_grouppos, iWherePos, iGroupbyPos, iSanity
DatawindowChild	ldwcOFD, ldwcOTD

If dw_select.AcceptText() = -1 Then Return

dw_select.GetChild('ord_date_from', ldwcOFD)
dw_select.GetChild('ord_date_to', ldwcOTD)

SetPointer(HourGlass!)
dw_report.Reset()

ls_warehouse_name = dw_select.GetItemString(1, "wh_name")
if IsNull(ls_warehouse_name) then
	ls_warehouse_name = ''
end if
dt_start_date = dw_select.GetItemDateTime(1, "comp_date_from")
dt_end_date = dw_select.GetItemDateTime(1, "comp_date_to")

dw_report.SetRedraw(False)
ll_cnt = dw_report.Retrieve(Datetime(dt_start_date), Datetime(dt_end_date), ls_warehouse_name)
IF ll_cnt > 0 Then
	ll_rowcount = dw_report.RowCount()
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If 

dw_report.SetRedraw(True)

end event

event ue_postopen;call super::ue_postopen;string ls_filter
DatawindowChild	ldwc_warehouse, ldc

is_origsql = dw_report.getSqlSelect()

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(Sqlca)
ldwc_warehouse.Retrieve(gs_project)
//ldwc_warehouse.InsertRow(0);




end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
dw_select.SetFocus()


end event

type dw_select from w_std_report`dw_select within w_comcast_rawandfinished_inventory_rpt
event process_enter pbm_dwnprocessenter
integer x = 0
integer y = 0
integer width = 3470
integer height = 184
string dataobject = "d_comcast_sik_report_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::process_enter;Send(Handle(This),256,9,Long(0,0))
 Return 1
end event

event dw_select::constructor;call super::constructor;integer i, ll_row, ll_find_row
datetime	ldt_begin_date
datetime	ldt_end_date

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

dw_select.modify('comp_Date_from.visible = true comp_Date_to.Visible = true c_date_from_t.visible = true c_date_to_t.visible = true')
dw_select.modify('ord_date_from.visible = false ord_date_to.Visible = false o_date_to_t.visible = false o_date_from_t.visible = false')

ldt_begin_date = f_get_date("BEGIN")
dw_select.SetColumn("comp_date_from")
dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))

ldt_end_date = f_get_date("END")
dw_select.SetColumn("comp_date_to")
dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))



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

type cb_clear from w_std_report`cb_clear within w_comcast_rawandfinished_inventory_rpt
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_comcast_rawandfinished_inventory_rpt
integer x = 32
integer y = 208
integer width = 3429
integer height = 1588
integer taborder = 30
string dataobject = "d_comcast_rawandfinished_inventory_rpt"
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

