$PBExportHeader$w_ironport_shipment_rpt.srw
$PBExportComments$Ironport Shipment Report
forward
global type w_ironport_shipment_rpt from w_std_report
end type
type uo_order_status_search from uo_multi_select_search within w_ironport_shipment_rpt
end type
type st_1 from statictext within w_ironport_shipment_rpt
end type
type st_2 from statictext within w_ironport_shipment_rpt
end type
end forward

global type w_ironport_shipment_rpt from w_std_report
integer width = 3730
integer height = 2132
string title = "Ironport Shipment Report"
uo_order_status_search uo_order_status_search
st_1 st_1
st_2 st_2
end type
global w_ironport_shipment_rpt w_ironport_shipment_rpt

type variables
DataWindowChild idwc_warehouse
String	isOrigSql

boolean ib_order_from_first
boolean ib_order_to_first 
boolean ib_sched_from_first
boolean ib_sched_to_first
boolean ib_complete_from_first
boolean ib_complete_to_first
boolean ib_receive_from_first
boolean ib_receive_to_first
end variables

on w_ironport_shipment_rpt.create
int iCurrent
call super::create
this.uo_order_status_search=create uo_order_status_search
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_order_status_search
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
end on

on w_ironport_shipment_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_order_status_search)
destroy(this.st_1)
destroy(this.st_2)
end on

event open;call super::open;

isOrigSql = dw_report.getsqlselect()

uo_order_status_search.uf_init("d_ord_status_search_list", "delivery_master.Ord_Status", "ord_status")




end event

event ue_retrieve;String  lsWhere, lsNewSql, ls_from_date, ls_order_status
Date ldFromDate, ldtodate
Long ll_balance, i, ll_cnt, llPos
boolean 	lb_order_from, lb_order_to, lb_complete_from, lb_complete_to,  lb_sched_from, lb_sched_to
Boolean lb_where			

If dw_select.AcceptText() = -1 Then Return

//Initialize date flags
lb_order_from 		= FALSE
lb_order_to 		= FALSE
lb_complete_from 	= FALSE
lb_complete_to 	= FALSE
lb_sched_from 		= FALSE
lb_sched_to 		= FALSE
lb_where          = FALSE
SetPointer(HourGlass!)
dw_report.Reset()

lsWhere = ''

//always tackon Project
lsWhere += " and Delivery_Master.project_id = '" + gs_project + "'"

//Tackon From Order Date
If date(dw_select.GetItemDateTime(1,"Order_from_date")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and Delivery_Master.Ord_Date >= '" + string(dw_select.GetItemDateTime(1,"order_from_date"),'mm-dd-yyyy hh:mm') + "'"
		lb_order_from = TRUE
		lb_where = TRUE		 
End If

//Tackon To Order Date
If date(dw_select.GetItemDateTime(1,"order_to_date")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and Delivery_Master.Ord_Date <= '" + string(dw_select.GetItemDateTime(1,"order_to_date"),'mm-dd-yyyy hh:mm') + "'"
		lb_order_to = TRUE
		lb_where = TRUE
End If

//Tackon From complete Date
If Date(dw_select.GetItemDateTime(1,"complete_from_date")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and  Delivery_Master.Complete_Date >= '" + string(dw_select.GetItemDateTime(1,"complete_from_date"),'mm-dd-yyyy hh:mm') + "'"
		lb_complete_from = TRUE
		lb_where = TRUE
End If

//Tackon To complete Date 
If Date(dw_select.GetItemDateTime(1,"complete_to_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and  Delivery_Master.Complete_Date <= '" + string(dw_select.GetItemDateTime(1,"complete_to_date"),'mm-dd-yyyy hh:mm') + "'"
	lb_complete_to = TRUE
	lb_where = TRUE
End If

//Tackon From Schedule Date
If Date(dw_select.GetItemDateTime(1,"sched_date_from")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and  Delivery_Master.schedule_Date >= '" + string(dw_select.GetItemDateTime(1,"sched_date_from"),'mm-dd-yyyy hh:mm') + "'"
		lb_sched_from = TRUE
		lb_where = TRUE
End If

//Tackon To Schedule Date 
If Date(dw_select.GetItemDateTime(1,"sched_date_to")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and  Delivery_Master.schedule_Date <= '" + string(dw_select.GetItemDateTime(1,"sched_date_to"),'mm-dd-yyyy hh:mm') + "'"
	lb_sched_to = TRUE
	lb_where = TRUE
End If

//Order Status from UO
ls_order_status = uo_order_status_search.uf_build_search(true)	
If ls_order_status > "" then	
	lsWhere = lsWhere + ls_order_status
	lb_where = True
end if
	
//Where clause needs to be appended in 2 places since there is a Union - Right before the Union and at the end

If lsWhere > '  ' Then
	
	lsNewSql = isOrigSql + lsWhere /*second Where */
	
	//First Sql before Union
	llPOs = Pos(upper(lsNEWSQL),"UNION")
	If llPos > 0 Then
		lsNewSQl = Replace(lsNewSql,(llPos  - 1),1,lsWhere + " ")
	End If
	
	dw_report.setsqlselect(lsNewsql) 
	
Else
	dw_report.setsqlselect(isOrigSql)
End If

//Check Order Date range for any errors prior to retrieving
IF 	((lb_order_to = TRUE and lb_order_from = FALSE) 	OR &
		 (lb_order_from = TRUE and lb_order_to = FALSE)  	OR &
		 (lb_order_from = FALSE and lb_order_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Order Date Range", Stopsign!)
		Return
END IF

//Check Complete Date range for any errors prior to retrieving
IF 	((lb_complete_to = TRUE and lb_complete_from = FALSE) 	OR &
		 (lb_complete_from = TRUE and lb_complete_to = FALSE)  	OR &
		 (lb_complete_from = FALSE and lb_complete_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Complete Date Range", Stopsign!)
		Return
END IF	


//Check Schedule Date range for any errors prior to retrieving
IF 	((lb_sched_to = TRUE and lb_sched_from = FALSE) 	OR &
		 (lb_sched_from = TRUE and lb_sched_to = FALSE)  	OR &
		 (lb_sched_from = FALSE and lb_sched_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Sched Date Range", Stopsign!)
		Return
END IF	

if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF	 

ll_cnt = dw_report.Retrieve()
If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If



end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-310)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

uo_order_status_search.uf_clear_list()


end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc
String	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve()

//Filter Warehouse dropdown by Current Project
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()


dw_select.GetChild('inv_type', ldwc)
ldwc.SetTransObject(Sqlca)
////added by dgm
//Messagebox("Ret",i_nwarehouse.of_init_inv_ddw(dw_select) )
ldwc.Retrieve()
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()

end event

type dw_select from w_std_report`dw_select within w_ironport_shipment_rpt
integer x = 18
integer y = 0
integer width = 2706
integer height = 252
string dataobject = "d_ironport_shipment_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;ib_order_from_first 		= TRUE
ib_order_to_first 		= TRUE
ib_sched_from_first 		= TRUE
ib_sched_to_first 		= TRUE
ib_complete_from_first 	= TRUE
ib_complete_to_first 	= TRUE
ib_receive_to_first 		= TRUE
ib_receive_from_first	= TRUE
end event

event dw_select::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "order_from_date"
		
		IF ib_order_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("order_from_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_order_from_first = FALSE
			
		END IF
		
	CASE "order_to_date"
		
		IF ib_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("order_to_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_order_to_first = FALSE
			
		END IF
		
	CASE "receive_date_from"
		
		IF ib_receive_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("receive_date_from")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_receive_from_first = FALSE
			
		END IF
		
	CASE "receive_date_to"
		
		IF ib_receive_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("receive_date_to")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_receive_to_first = FALSE
			
		END IF
		
	CASE "complete_from_date"
		
		IF ib_complete_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("complete_from_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_complete_from_first = FALSE
			
		END IF
		
	CASE "complete_to_date"
		
		IF ib_complete_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("complete_to_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_complete_to_first = FALSE
			
		END IF
		
	CASE "sched_date_from"
		
		IF ib_sched_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("sched_date_from")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_sched_from_first = FALSE
			
		END IF
		
	CASE "sched_date_to"
		
		IF ib_sched_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("sched_date_to")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_sched_to_first = FALSE
			
		END IF
		
	CASE ELSE
		
END CHOOSE

end event

type cb_clear from w_std_report`cb_clear within w_ironport_shipment_rpt
integer x = 2423
integer y = 164
integer width = 430
end type

type dw_report from w_std_report`dw_report within w_ironport_shipment_rpt
integer x = 0
integer y = 280
integer width = 3625
integer height = 1592
integer taborder = 30
string dataobject = "d_ironport_shipment_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type uo_order_status_search from uo_multi_select_search within w_ironport_shipment_rpt
integer x = 2990
integer height = 276
integer taborder = 40
boolean bringtotop = true
end type

on uo_order_status_search.destroy
call uo_multi_select_search::destroy
end on

type st_1 from statictext within w_ironport_shipment_rpt
integer x = 2766
integer y = 28
integer width = 192
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Order"
boolean focusrectangle = false
end type

type st_2 from statictext within w_ironport_shipment_rpt
integer x = 2766
integer y = 84
integer width = 183
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Status:"
boolean focusrectangle = false
end type

