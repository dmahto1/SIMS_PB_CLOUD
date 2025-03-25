$PBExportHeader$w_serial_history_rpt.srw
forward
global type w_serial_history_rpt from w_std_report
end type
type cbx_1 from checkbox within w_serial_history_rpt
end type
end forward

global type w_serial_history_rpt from w_std_report
integer width = 4725
integer height = 2045
string title = "Stock Movement Report"
cbx_1 cbx_1
end type
global w_serial_history_rpt w_serial_history_rpt

type variables
DataWindowChild idwc_warehouse,idwc_supp

boolean ib_movement_from_first
boolean ib_movement_to_first
boolean ib_select_sku
boolean ib_select_serial
boolean ib_select_date_start
boolean ib_select_date_end

String	isoriqsqldropdown
String isOrigSql 
String isOrigWh
end variables

on w_serial_history_rpt.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
end on

on w_serial_history_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
end on

event ue_retrieve;String ls_whcode, ls_sku, ls_ord_type,ls_filter,ls_supp, lsWhere, lsOrderBy, lsNewSql
String ls_lcode,ls_lot_no,ls_serial_no,ls_inv_type,ls_po_no,ls_po_no2
DateTime ldt_s, ldt_e
Long  i, ll_cnt,j,ll_adj
Boolean  lb_where

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

//Remove filter if any thing already there
dw_report.SetFilter("")
dw_report.Filter()
dw_report.Object.t_date_range.text = 'None'

lsWhere = ''
lb_where = FALSE

//always tackon Project
lsWhere = " WHERE a.project_id = '" + gs_project + "'"
lsOrderBy = " ORDER BY  A.wh_code, A.sku, serial_no, last_update"

ls_whcode = dw_select.GetItemString(1, "wh_code")
ls_sku = dw_select.GetItemString(1, "sku")
ls_supp = dw_select.GetItemString(1, "supp_code")
ls_serial_no= dw_select.getitemstring(1,"serial_no") 

//Tackon Warehouse 
if not isnull(ls_whcode) and ls_whcode <> '' then
	lswhere += " and a.wh_code = '" + ls_whcode + "'"
	lb_where = TRUE
	isOrigWh = ls_whcode
//Else			Added serial number and warehouse/serial number indexes to serial_number_history.  Add this if query gets too long.
//	If Messagebox(is_title,"Requesting data without Warehouse could slow down retrieval.~r~nDo you wish to continue?", Question!, YesNo!) <> 1 Then
//		Return 
//	End If
end if


//Check if sku has been entered
if  not isnull(ls_sku) and ls_sku <> '' then
	ib_select_sku = TRUE
	IF isnull(ls_supp) or ls_supp = "" then 
		ib_select_sku = FALSE
		Messagebox(is_title,"Please enter a Supplier...")
		Return 
	Else
		lswhere += " and a.sku = '" + ls_sku + "' and a.supp_code = '" + ls_supp + "'"
		lb_where = TRUE
	END IF	
END IF

//Check if serial has been entered
if  not isnull(ls_serial_no) and ls_serial_no <> '' then
	ib_select_serial = TRUE
	lswhere += " and a.serial_no = '" + ls_serial_no + "'"
	lb_where = TRUE
else
	ib_select_sku = FALSE
//	Messagebox(is_title,"Please enter a valid SKU...")
//	Return 
END IF


//Check if a start date has been entered
if  not isnull(dw_select.GetItemDateTime(1,"s_date")) then
	ib_select_date_start = TRUE
	ldt_s = dw_select.GetItemDateTime(1, "s_date")
	lsWhere += " and a.create_Date >= '" + string(ldt_s,'mm-dd-yyyy hh:mm') + "'"
else
	ib_select_date_start = FALSE	
END IF

//Check if a end date has been entered
if  not isnull(dw_select.GetItemDateTime(1,"e_date")) then
	ib_select_date_end = TRUE
	ldt_e = dw_select.GetItemDateTime(1, "e_date")
	lsWhere += " and a.create_Date <= '" + string(ldt_e,'mm-dd-yyyy hh:mm') + "'"
else
	ib_select_date_end = FALSE	
END IF

If lsWhere > '  ' Then
	lsNewSql = isOrigSql + lsWhere + lsOrderBy
	dw_report.setsqlselect(lsNewsql)
Else
	dw_report.setsqlselect(isOrigSql)
End If


//Check start and end date for any errors prior to retrieving
	IF	((ib_select_date_start = TRUE and ib_select_date_end = FALSE) 	OR &
		 (ib_select_date_end = TRUE and ib_select_date_start = FALSE)  	OR &
		 (ib_select_date_start = FALSE and ib_select_date_end = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Movement Date Range", Stopsign!)
		Return
	END IF

dw_report.SetRedraw(False)

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF	 


ll_cnt = dw_report.Retrieve(gs_project)

////Determine which report need to process
//
//IF ib_select_date_start and ib_select_date_end Then
//      ls_filter =  "complete_date between  datetime('" +string(ldt_s) +"') and datetime('"+string(ldt_e)+"')"
//		dw_report.SetFilter(ls_filter)
//		dw_report.Filter()
//		dw_report.Object.t_date_range.text = String(ldt_s,'mm/dd/yyyy hh:mm') + ' To ' + String(ldt_e,'mm/dd/yyyy hh:mm')
// END IF	
// 
//IF not isnull(ls_serial_no) and ls_serial_no <> ''  THEN
//	ls_filter = "serial_no = '"+ls_serial_no+"'"
//	dw_report.setfilter( ls_filter)
//	dw_report.filter( )
//END IF

ll_cnt=dw_report.Rowcount()


If ll_cnt > 0 Then
	
	im_menu.m_file.m_print.Enabled = True
	
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If

dw_report.SetRedraw(True)
end event

event ue_clear;
dw_select.Reset()
dw_report.Reset()
dw_select.InsertRow(0)

If cbx_1.checked = True Then
	If idwc_warehouse.RowCount() > 0 Then
		If isOrigWh <> "" Then
			dw_select.SetItem(1, "wh_code" , isOrigWh)
		Else
			dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
		End If
	End If
End If

end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_postopen;call super::ue_postopen;string	lsFilter
DatawindowCHild	ldwc, ldwc2

dw_select.GetChild('supp_code', idwc_supp)
dw_select.GetChild('wh_code', idwc_warehouse)

dw_report.GetChild('inv_type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)
dw_report.GetChild('old_inv_type',ldwc2)
ldwc2.SetTransObject(SQLCA)
ldwc2.Retrieve(gs_Project)

idwc_warehouse.SetTransObject(sqlca)
idwc_supp.SetTransObject(sqlca)

idwc_supp.Insertrow(0)


// LTK 20150922  Commented out block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
g.of_set_warehouse_dropdown(idwc_warehouse)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "wh_code", gs_default_wh)
end if


isoriqsqldropdown = idwc_supp.GetSqlselect()

isOrigSql = dw_report.getsqlselect()
end event

event open;call super::open;	dw_report.dataobject = 'd_serial_history_rpt_pandora'
	dw_report.SetTransObject(SQLCA)
	
	cbx_1.checked = True
	

end event

type dw_select from w_std_report`dw_select within w_serial_history_rpt
integer x = 18
integer width = 3182
string dataobject = "d_serial_history_rpt_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;ib_movement_from_first 	= TRUE
ib_movement_to_first 	= TRUE
ib_select_sku 				= FALSE
ib_select_serial 				= FALSE
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

CHOOSE CASE ls_column
		
	CASE "s_date"
		
		IF ib_movement_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("s_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_movement_from_first = FALSE
			
		END IF
		
	CASE "e_date"
		
		IF ib_movement_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("e_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_movement_to_first = FALSE
			
		END IF
		
	CASE ELSE
		
END CHOOSE

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

type cb_clear from w_std_report`cb_clear within w_serial_history_rpt
integer x = 3152
integer y = 13
integer width = 271
end type

event cb_clear::clicked;call super::clicked;If idwc_warehouse.RowCount() > 0 Then
	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
End If

end event

type dw_report from w_std_report`dw_report within w_serial_history_rpt
integer y = 189
integer width = 4637
integer height = 1706
string dataobject = "d_serial_history_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type cbx_1 from checkbox within w_serial_history_rpt
integer x = 3262
integer y = 13
integer width = 636
integer height = 83
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Keep warehouse on clear"
end type

