HA$PBExportHeader$w_starbucks_short_shipped_rpt.srw
$PBExportComments$Starbucks consolidated DN
forward
global type w_starbucks_short_shipped_rpt from w_std_report
end type
type cb_1 from commandbutton within w_starbucks_short_shipped_rpt
end type
end forward

global type w_starbucks_short_shipped_rpt from w_std_report
integer width = 5207
integer height = 2100
string title = "Starbucks Short Picked Report"
cb_1 cb_1
end type
global w_starbucks_short_shipped_rpt w_starbucks_short_shipped_rpt

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

on w_starbucks_short_shipped_rpt.create
int iCurrent
call super::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_starbucks_short_shipped_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-300)
end event

event ue_retrieve;String 	ls_Where, lsNewSQL, lsOrigSql, lsCustHold, lsCustCode, lsMultCust
Long	ll_Cnt, llPos, llRowPos, llRowNum
boolean 	lb_where

DateTime ldt_s, ldt_e, ldt
Date	 ldSchedDateHold

String ls_projectid,ls_dono,ls_whname,ls_invoiceno,ls_ordstatus,ls_ordtype,ls_custname,ls_custorderno,ls_carrier,ls_deliverynote,ls_sku,ls_skup,ls_pcomponentind,ls_icomponentind
Datetime		ldt_notifieddate
Long	ld_lineitemno,ld_reqqty,ld_allocqty,ld_pickingqty,ld_ownerid

dw_select.AcceptText()

lsOrigSql = is_OrigSql



SetPointer(HourGlass!)
dw_report.Reset()
dw_report.SetRedraw(False)

// Always tackon  Project id 
//ls_Where = ls_Where + " and delivery_master.Project_id = '" + gs_project + "'"
		
// tackon  Order Type
If dw_select.GetItemString(1, "ord_type") <> "" Then
	ls_Where = ls_Where + " and delivery_master.Ord_Type = '" + Left(dw_select.GetItemString(1, "ord_type"),1) + "'"
	lb_where = True
end if

//tackon one or more customer codes
lsCustCode = dw_select.GetItemString(1,'cust_code')
If  lsCustCode > '' Then
	
	If pos(lsCustCode,',') > 0 Then /* multiple customers*/
	
		ll_cnt = Len(lsCustCode)
		for llPos = 1 to ll_cnt
			
			If Mid(lsCustCode,llPos,1) = ' ' THen Continue
			
			If Mid(lsCustCode,llPos,1) = ',' Then
				lsMultCust += "'" + Mid(lsCustCode,llPos,1)  + "'"
			Else
				lsMultCust +=Mid(lsCustCode,llPos,1)
			End If
			
		Next
		
		lsMultCust ="'" + lsMultCust + "'"
		
		ls_Where += " and Delivery_Master.cust_code in (" + lsMultCust + ") "
		
	Else
		ls_Where += " and Delivery_Master.cust_code = '" + lsCustCode + "'"
	End If
			
End If
	
//Tackon From Sched Date
If date(dw_select.GetItemDateTime(1, "sched_date_from")) > date('01-01-1900') Then
	ls_Where = ls_Where + " and schedule_date >= '" + string(dw_select.GetItemDateTime(1, "sched_date_from"),'mm-dd-yyyy 00:00') + "'"
	ldt_s = dw_select.GetItemDateTime(1, "sched_date_from")
	lb_where = True
End If
	
//Tackon To Sched Date
If date(dw_select.GetItemDateTime(1, "sched_date_to")) > date('01-01-1900') Then
	ls_Where = ls_Where + " and schedule_date <= '" + string(dw_select.GetItemDateTime(1, "sched_date_to"),'mm-dd-yyyy 23:59') + "'"
	ldt_e = dw_select.GetItemDateTime(1, "sched_date_to")
	lb_where = True
End If

//Tackon From Order Date
If date(dw_select.GetItemDateTime(1, "order_date_from")) > date('01-01-1900') Then
	ls_Where = ls_Where + " and ord_date >= '" + string(dw_select.GetItemDateTime(1, "order_date_from"),'mm-dd-yyyy 00:00') + "'"
//	ldt_s = dw_select.GetItemDateTime(1, "sched_date_from")
	lb_where = True
End If
	
//Tackon To order Date
If date(dw_select.GetItemDateTime(1, "order_date_to")) > date('01-01-1900') Then
	ls_Where = ls_Where + " and ord_date <= '" + string(dw_select.GetItemDateTime(1, "order_date_to"),'mm-dd-yyyy 23:59') + "'"
//	ldt_e = dw_select.GetItemDateTime(1, "sched_date_to")
	lb_where = True
End If
		
// Tackon 'Where' before 'ORDER BY'
llPos = Pos(lsOrigSql,'ORDER BY')
lsNewSQL = Left(lsOrigSql, (llPos - 1)) + ls_Where + '      ' + Mid(lsOrigSql,llPos,99999)

//Messagebox ("sql", lsNewSQL)
dw_report.setsqlselect(lsNewSQL)

//Messagebox("",lsNewSQL)

ll_cnt = dw_report.retrieve()
dw_report.Sort()

////Set the line numbers per report break - I cant figure out how to reset the row numbers at the group level
//For llRowPos = 1 to ll_cnt
//	
//	If dw_report.GetItemString(llRowPos,'Cust_Code') <> lsCustHold or Date(dw_report.GetItemDateTime(llRowPos,'schedule_Date')) <> ldSchedDateHold Then
//		llRowNum = 0
//		lsCustHold = dw_report.GetItemString(llRowPos,'Cust_Code')
//		ldSchedDateHold = Date(dw_report.GetItemDateTime(llRowPos,'schedule_Date'))
//	End If
//	
//	llRowNum ++
//	dw_report.SetItem(llrowPos,'c_row',llRowNum)
//	
//next

//dw_report.GroupCalc()
	
IF ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If 


dw_report.SetRedraw(True)






end event

event open;call super::open;is_OrigSql = dw_report.getsqlselect()



end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
dw_select.SetFocus()


end event

event ue_postopen;call super::ue_postopen;
is_OrigSql = dw_report.getsqlselect()
end event

type dw_select from w_std_report`dw_select within w_starbucks_short_shipped_rpt
event process_enter pbm_dwnprocessenter
integer x = 0
integer y = 0
integer width = 3419
integer height = 288
string dataobject = "d_starbucks_th_dn_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::process_enter;Send(Handle(This),256,9,Long(0,0))
 Return 1
end event

event dw_select::clicked;call super::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()

end event

event dw_select::constructor;call super::constructor;
Long	ll_find_row, i
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

type cb_clear from w_std_report`cb_clear within w_starbucks_short_shipped_rpt
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_starbucks_short_shipped_rpt
integer x = 5
integer y = 296
integer width = 5143
integer height = 1448
integer taborder = 30
string title = "Starbucks-TH Consolidated Delivery Note"
string dataobject = "d_starbucks_short_shipped_rpt"
boolean minbox = true
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type cb_1 from commandbutton within w_starbucks_short_shipped_rpt
integer x = 9
integer y = 164
integer width = 503
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Customer (Store):"
end type

event clicked;str_parms	lstrparms
long	llCount, llPos
String	lsCust


Open(w_select_customer)
lstrparms = message.PowerobjectParm

If Not lstrparms.Cancelled Then
	
	// 05/13 - PCONKL - Allowing multiple customers to be selected
	If upperbound( Lstrparms.String_arg) > 0 Then
		
		If Lstrparms.String_arg[1] > '' Then
		
			SetPointer(Hourglass!)
		
			llCount = upperbound( Lstrparms.String_arg)
			for llPos = 1 to llCount
				lsCust += lstrparms.String_arg[llPos] + ","
			Next
		
			lsCust = left(lsCust,Len(lsCust) - 1)
			dw_select.SetItem(1,"cust_code",lsCust)
		
		End If
		
	End If
	
End If
end event

