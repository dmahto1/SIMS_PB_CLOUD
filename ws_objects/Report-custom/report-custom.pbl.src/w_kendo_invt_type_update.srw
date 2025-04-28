$PBExportHeader$w_kendo_invt_type_update.srw
$PBExportComments$GMM Outbound Report
forward
global type w_kendo_invt_type_update from w_std_report
end type
type cb_1 from commandbutton within w_kendo_invt_type_update
end type
type cb_2 from commandbutton within w_kendo_invt_type_update
end type
end forward

global type w_kendo_invt_type_update from w_std_report
integer width = 3488
integer height = 2044
string title = "KENDO INVETORY TYPE CHANGE REPORT"
cb_1 cb_1
cb_2 cb_2
end type
global w_kendo_invt_type_update w_kendo_invt_type_update

type variables
DataWindowChild idwc_warehouse
String	isOrigSql

boolean ib_movement_from_first
boolean ib_movement_to_first
boolean ib_movement_fromSched_first
boolean ib_movement_toSched_first
end variables

on w_kendo_invt_type_update.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
end on

on w_kendo_invt_type_update.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event open;call super::open;

//5/00 PCONKL - Default from/to dates to today

//dw_select.SetItem(1,"s_date",today())
//dw_select.SetItem(1,"e_date",today())
//
isOrigSql = dw_report.getsqlselect()




end event

event ue_retrieve;String ls_whcode, ls_sku, lsWhere, lsNewSql,ls_user =  'Sweeper'
DateTime ldt_s, ldt_e
integer li_y
Long ll_balance, i, ll_cnt
boolean lb_where
If dw_select.AcceptText() = -1 Then Return
lb_where = false
SetPointer(HourGlass!)
dw_report.Reset()

ldt_s = dw_select.GetItemDateTime(1, "s_date")
ldt_e = dw_select.GetItemDateTime(1, "e_date")

// 1/01 PCONKL - Always tackon Project
lsWhere = lsWhere + " WHERE Adjustment.Project_id = '" + gs_project + "'"
// 9/02 GAP - Tackon Order Type <> Packaging
lswhere = lsWhere + " and Adjustment.last_user = '" + ls_user + "'"


//Tackon BOL NBR 
If Not isnull(dw_select.GetiTemString(1,"Sku")) Then
	lsWhere = lsWhere + " and Adjustment.Sku = '" + dw_select.GetiTemString(1,"Sku") + "'"
	lb_where = True
End If
	
//Tackon From Order Date
If date(dw_select.GetItemDateTime(1, "s_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and Adjustment.last_update >= '" + string(dw_select.GetItemDateTime(1, "s_date"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = True
End If
	
//Tackon To Order Date
If date(dw_select.GetItemDateTime(1, "e_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and Adjustment.last_update  <= '" + string(dw_select.GetItemDateTime(1, "e_date"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = True
End If

////Tackon From Sched Date
//If date(dw_select.GetItemDateTime(1, "sched_date_from")) > date('01-01-1900') Then
//	lsWhere = lsWhere + " and schedule_date >= '" + string(dw_select.GetItemDateTime(1, "sched_date_from"),'mm-dd-yyyy hh:mm') + "'"
//	lb_where = True
//End If
//	
////Tackon To Sched Date
//If date(dw_select.GetItemDateTime(1, "sched_date_to")) > date('01-01-1900') Then
//	lsWhere = lsWhere + " and schedule_date <= '" + string(dw_select.GetItemDateTime(1, "sched_date_to"),'mm-dd-yyyy hh:mm') + "'"
//	lb_where = True
//End If


If lsWhere > '  ' Then
	lsNewSql = isOrigSql + lsWhere 
	dw_report.setsqlselect(lsNewsql)
Else
	dw_report.setsqlselect(isOrigSql)
End If

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF	

ll_cnt = dw_report.Retrieve()
If ll_cnt > 0 Then
//	li_y = integer(dw_report.object.cf_city.Y)
//	Messagebox("",string(li_y))
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If



end event

event resize;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-225)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
dw_select.SetFocus()
end event

type dw_select from w_std_report`dw_select within w_kendo_invt_type_update
integer x = 9
integer y = 48
integer width = 2921
integer height = 136
string dataobject = "d_search_criteria"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;call super::constructor;ib_movement_from_first = TRUE
ib_movement_to_first  = TRUE
ib_movement_fromSched_first = TRUE
ib_movement_toSched_first = TRUE
end event

event dw_select::clicked;call super::clicked;string 	ls_column

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

type cb_clear from w_std_report`cb_clear within w_kendo_invt_type_update
end type

type dw_report from w_std_report`dw_report within w_kendo_invt_type_update
integer x = 0
integer y = 244
integer width = 3401
integer height = 1532
integer taborder = 30
string dataobject = "d_kendo_invt_type_update"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type cb_1 from commandbutton within w_kendo_invt_type_update
integer x = 2949
integer y = 20
integer width = 402
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Run"
end type

event clicked;parent.triggerevent('ue_retrieve')
end event

type cb_2 from commandbutton within w_kendo_invt_type_update
integer x = 2958
integer y = 136
integer width = 398
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear"
end type

event clicked;parent.triggerevent('ue_clear')
end event

