$PBExportHeader$w_friedrich_orders_to_otm_rpt.srw
$PBExportComments$Friedrich Orders to OTM
forward
global type w_friedrich_orders_to_otm_rpt from w_std_report
end type
type dw_saveas from datawindow within w_friedrich_orders_to_otm_rpt
end type
type cb_1 from commandbutton within w_friedrich_orders_to_otm_rpt
end type
end forward

global type w_friedrich_orders_to_otm_rpt from w_std_report
integer width = 3730
integer height = 2132
string title = "Orders to send to OTM"
dw_saveas dw_saveas
cb_1 cb_1
end type
global w_friedrich_orders_to_otm_rpt w_friedrich_orders_to_otm_rpt

type variables
DataWindowChild idwc_warehouse
String	isOrigSql, is_warehouse_code

boolean ib_order_from_first
boolean ib_order_to_first 
boolean ib_sched_from_first
boolean ib_sched_to_first
boolean ib_complete_from_first
boolean ib_complete_to_first
boolean ib_receive_from_first
boolean ib_receive_to_first

integer	ii_max_col
end variables

on w_friedrich_orders_to_otm_rpt.create
int iCurrent
call super::create
this.dw_saveas=create dw_saveas
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_saveas
this.Control[iCurrent+2]=this.cb_1
end on

on w_friedrich_orders_to_otm_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_saveas)
destroy(this.cb_1)
end on

event open;call super::open;

//isOrigSql = dw_report.getsqlselect()




end event

event ue_retrieve;String ls_whcode, ls_sku, lsWhere, lsNewSql, ls_from_date, lsoutstring
Date ldFromDate, ldtodate
Long ll_balance, i, ll_cnt
boolean 	lb_order_from, lb_order_to, lb_receive_from, &
			lb_receive_to, lb_sched_from, lb_sched_to
Boolean lb_where		
integer llrowpos, llnewrow, li_pos
long		ll_row
integer	li_blank, li_insert_blank_tot, li_rc
string	ls_do_no

SetPointer( Hourglass! )
SetRedraw( FALSE )


isOrigSql = dw_report.getsqlselect()

If dw_select.AcceptText() = -1 Then Return


//Initialize date flags
lb_order_from 		= FALSE
lb_order_to 		= FALSE
lb_receive_from 	= FALSE
lb_receive_to 		= FALSE
lb_sched_from 		= FALSE
lb_sched_to 		= FALSE
lb_where          = FALSE
SetPointer(HourGlass!)
dw_report.Reset()

lsWhere = ''

//always tackon Project
lsWhere += " and m.project_id = '" + gs_project + "'"

//Tackon Warehouse
if  not isnull(dw_select.GetItemString(1,"warehouse")) then
	lswhere += " and m.wh_code = '" + dw_select.GetItemString(1,"warehouse") + "'"
	lb_where = TRUE
end if

lswhere += " and m.ord_status = '" + "P" + "'"
lswhere += " and upper(m.Freight_Terms) in ('PREPAID', 'PREPAIDADD') "

//Tackon BOL Nbr
if  not isnull(dw_select.GetItemString(1,"bol_nbr")) then
	lswhere += " and m.Invoice_No Like '%" + dw_select.GetItemString(1,"bol_nbr") + "%'"
	lb_where = TRUE
end if

//Tackon Cust Code
if  not isnull(dw_select.GetItemString(1,"cust_code")) then
	lswhere += " and m.Cust_Code = '" + dw_select.GetItemString(1,"cust_code") + "'"
	lb_where = TRUE
end if

//Tackon From Order Date
If date(dw_select.GetItemDateTime(1,"Order_from_date")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and m.Ord_Date >= '" + string(dw_select.GetItemDateTime(1,"order_from_date"),'mm-dd-yyyy hh:mm') + "'"
		lb_order_from = TRUE
		lb_where = TRUE		 
End If

//Tackon To Order Date
If date(dw_select.GetItemDateTime(1,"order_to_date")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and m.Ord_Date <= '" + string(dw_select.GetItemDateTime(1,"order_to_date"),'mm-dd-yyyy hh:mm') + "'"
		lb_order_to = TRUE
		lb_where = TRUE
End If

//Tackon From Receive Date
If Date(dw_select.GetItemDateTime(1,"receive_date_from")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and  m.receive_Date >= '" + string(dw_select.GetItemDateTime(1,"receive_date_from"),'mm-dd-yyyy hh:mm') + "'"
		lb_receive_from = TRUE 
		lb_where = TRUE
End If

//Tackon To receive Date 
If Date(dw_select.GetItemDateTime(1,"receive_date_to")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and  m.receive_Date <= '" + string(dw_select.GetItemDateTime(1,"receive_date_to"),'mm-dd-yyyy hh:mm') + "'"
	lb_receive_to = TRUE
	lb_where = TRUE
End If

//Tackon From Schedule Date
If Date(dw_select.GetItemDateTime(1,"sched_date_from")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and  m.schedule_Date >= '" + string(dw_select.GetItemDateTime(1,"sched_date_from"),'mm-dd-yyyy hh:mm') + "'"
		lb_sched_from = TRUE
		lb_where = TRUE
End If

//Tackon To Schedule Date 
If Date(dw_select.GetItemDateTime(1,"sched_date_to")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and  m.schedule_Date <= '" + string(dw_select.GetItemDateTime(1,"sched_date_to"),'mm-dd-yyyy hh:mm') + "'"
	lb_sched_to = TRUE
	lb_where = TRUE
End If

	
If lsWhere > '  ' Then
	
	li_Pos = Pos(isOrigSql, "GROUP BY",1)

	if li_Pos > 0 then
	
		lsNewsql = left(isOrigSql, li_Pos -1) + lsWhere + mid(isOrigSql, li_Pos)
	
	else
	
		lsNewsql = isOrigSql + lsWhere 

	end if

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

//Warehouse is required
	is_warehouse_code = dw_select.GetItemString(1,"warehouse")
	  
//IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
//	MessageBox("ERROR", "Please select a warehouse",stopsign!)
//	Return
//END IF


//Check Arrival Date range for any errors prior to retrieving
IF 	((lb_receive_to = TRUE and lb_receive_from = FALSE) 	OR &
		 (lb_receive_from = TRUE and lb_receive_to = FALSE)  	OR &
		 (lb_receive_from = FALSE and lb_receive_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Receive Date Range", Stopsign!)
		Return
END IF

//Check Schedule Date range for any errors prior to retrieving
IF 	((lb_sched_to = TRUE and lb_sched_from = FALSE) 	OR &
		 (lb_sched_from = TRUE and lb_sched_to = FALSE)  	OR &
		 (lb_sched_from = FALSE and lb_sched_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Sched Date Range", Stopsign!)
		Return
END IF	

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF	 

//Get DO_NO from datastore so we can load each order to the n-up display 
	ll_cnt = dw_report.Retrieve()

//	ll_cnt = dw_report.Retrieve(gs_project,is_warehouse_code)
	IF ll_cnt > 0 Then
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
		llNewRow = dw_saveas.insertRow(0)
	
		lsOutString = 'invoice_no,do_no,wh_code,cust_code,cust_name,address,city,state,zip,country,Early_Pickup_Date,Early_Pickup_Time,Late_Pickup_Date,Late_Pickup_Time,Early_Delivery_Date,Early_Delivery_Time,Late_Delivery_Date,Late_Delivery_Time,Freight_Terms,Bill_To,Transport_Mode,Date_Emphasis,remark,shipping_instructions,Carrier,carrier_pro,ZWF_NOLT,TOTVol,volumeUOM,awb_bol_no,Cust_Order_No,line_item_no,sku,Alloc_Qty,TotWght,WeightUOM,Hazard_Cd'
	
		dw_saveas.SetItem(llNewRow,'outString', lsOutString)

		For llRowPos = 1 to ll_cnt

			llNewRow = dw_saveas.insertRow(0)
	
			if IsNull(dw_report.GetItemString(llRowPos,'invoice_no')) Then		
				lsOutString = ','	
			else		
				lsOutString = dw_report.GetItemString(llRowPos,'invoice_no') + ','
			end if
			
			if IsNull(dw_report.GetItemString(llRowPos,'do_no'))	 Then		
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'do_no') + ','
			end if		
			
			if IsNull(dw_report.GetItemString(llRowPos,'wh_code')) Then			
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'wh_code')+ ','
			end if		
			
			if IsNull(dw_report.GetItemString(llRowPos,'cust_code')) Then			
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'cust_code')+ ','
			end if		
			
			if IsNull(dw_report.GetItemString(llRowPos,'cust_name')) Then			
			lsOutString += ','	
			else		
				lsOutString += '"' + dw_report.GetItemString(llRowPos,'cust_name')+ '",'
			end if

			string ls_add1,ls_add2, ls_add3,ls_add4

			if IsNull(dw_report.GetItemString(llRowPos,'address_1'))	 Then	
				ls_add1 = ''
			else
				ls_add1 = dw_report.GetItemString(llRowPos,'address_1')	
			end if

			if IsNull(dw_report.GetItemString(llRowPos,'address_2'))	 Then	
				ls_add2 = ''
			else
				ls_add2 = dw_report.GetItemString(llRowPos,'address_2')	 
			end if

			if IsNull(dw_report.GetItemString(llRowPos,'address_3'))	 Then	
				ls_add3 = ''
			else
				ls_add3 = dw_report.GetItemString(llRowPos,'address_3')
			end if

			if IsNull(dw_report.GetItemString(llRowPos,'address_4'))	 Then	
				ls_add4 = ''
			else
				ls_add4 = dw_report.GetItemString(llRowPos,'address_4') 	
			end if

			lsOutString += '"' + ls_add1 + ' ' + ls_add2 + ' ' + ls_add3 + ' ' +  ls_add4 + '",'
			
			if IsNull(dw_report.GetItemString(llRowPos,'city')) Then			
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'city') + ','
			end if		
			
			if IsNull(dw_report.GetItemString(llRowPos,'state')) Then			
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'state') + ','
			end if		
			
			if IsNull(dw_report.GetItemString(llRowPos,'zip'))	 Then		
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'zip')+ ','
			end if		
			
			if IsNull(dw_report.GetItemString(llRowPos,'country'))	 Then		
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'country')+ ','
			end if

			lsOutString += '' + ',' //Early Pickup Date
			lsOutString += '' + ',' //Early Pickup Time
			
			if IsNull(dw_report.GetItemDateTime(llRowPos,'ord_date'))	 Then		
				lsOutString += ','	
				lsOutString += ','	
			else		
				lsOutString += String(dw_report.GetItemDateTime(llRowPos,'ord_date'),'MM.DD.YYYY') + ',' //Late Pickup Date
				lsOutString += String(dw_report.GetItemDateTime(llRowPos,'ord_date'),'hh:mm') + ',' // Late Pickup Time
			end if
			lsOutString += '' + ',' //Early Delivery Date
			lsOutString += '' + ',' //Early Delivery Time
			lsOutString += '' + ',' //Late Delivery Date
			lsOutString += '' + ',' //Late Delivery Time
	
			if (Upper(dw_report.GetItemString(llRowPos,'Freight_Terms')) = 'PREPAID') Then			
				lsOutString += 'PPD,'
			elseif (Upper(dw_report.GetItemString(llRowPos,'Freight_Terms')) = 'PREPAIDADD') Then		
				lsOutString += 'PPC,'
			else
				lsOutString += ','
			end if
	
			lsOutString += '' + ',' //Bill To
	
			if IsNull(dw_report.GetItemString(llRowPos,'Transport_Mode')) Then			
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'Transport_Mode')+ ','
			end if
	
			lsOutString += '' + ',' //Date Emphasis
	
			if IsNull(dw_report.GetItemString(llRowPos,'remark'))	 Then		
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'remark') + ','
			end if		
			
			if IsNull(dw_report.GetItemString(llRowPos,'shipping_instructions'))	 Then		
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'shipping_instructions') + ','
			end if		
				
			if IsNull(dw_report.GetItemString(llRowPos,'Scac_Code'))	 Then		
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'Scac_Code')+ ','
			end if		

			if IsNull(dw_report.GetItemString(llRowPos,'carrier_pro')) Then			
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'carrier_pro')+ ','
			end if
	
			lsOutString += '' + ',' //ZWF_NOLT
			
			if IsNull(dw_report.GetItemNumber(llRowPos,'TOTVol'))	 Then		
				lsOutString += ','	
			else		
				lsOutString += String(dw_report.GetItemNumber(llRowPos,'TOTVol'))+ ','
			end if		
			
			if IsNull(dw_report.GetItemString(llRowPos,'volumeUOM'))	 Then		
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'VolumeUOM')+ ','
			end if		
			
			if IsNull(dw_report.GetItemString(llRowPos,'awb_bol_no')) Then			
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'awb_bol_no')+ ','
			end if		
	
			if IsNull(dw_report.GetItemString(llRowPos,'Cust_Order_No')) Then			
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'Cust_Order_No')+ ','
			end if		
			
			if IsNull(dw_report.GetItemNumber(llRowPos,'line_item_no'))	 Then		
				lsOutString += ','	
			else		
				lsOutString += String(dw_report.GetItemNumber(llRowPos,'line_item_no'))+ ','
			end if		
			
			if IsNull(dw_report.GetItemString(llRowPos,'sku'))	 Then		
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'sku')+ ','
			end if		
			
			if IsNull(dw_report.GetItemNumber(llRowPos,'Alloc_Qty'))	 Then		
				lsOutString += ','	
			else		
				lsOutString += String(dw_report.GetItemNumber(llRowPos,'Alloc_Qty'))+ ','
			end if		
			
			if IsNull(dw_report.GetItemNumber(llRowPos,'TotWght')) Then			
				lsOutString += ','	
			else		
				lsOutString += String(dw_report.GetItemNumber(llRowPos,'TotWght'))+ ','
			end if		
			
			if IsNull(dw_report.GetItemString(llRowPos,'WeightUOM'))	 Then		
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'WeightUOM')+ ','
			end if		
	
			if IsNull(dw_report.GetItemString(llRowPos,'Hazard_Cd'))	 Then		
				lsOutString += ','	
			else		
				lsOutString += dw_report.GetItemString(llRowPos,'Hazard_Cd')+ ','
			end if	

			dw_saveas.SetItem(llNewRow,'outString', lsOutString)

		Next

	Else
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
	End If

SetRedraw( TRUE )
SetPointer( Arrow! )



end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-310)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)


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

event ue_file;//String	lsOption,ls_name, lsfilename, lstext, lsEmail
//Str_parms	lstrparms
//ulong lu_rtn,lu_pass
//integer li_rtn
////Triggered from menu
//lu_pass = 300000
//ls_name = space(5000)
// 
//IF IsValid(dw_saveas) and (dw_saveas.rowcount( ) > 0 ) THEN
//
////		ls_name = 'C:\export_orders_to_OTM'
////		boolean lbset
////		lbset = g.SetCurrentDirectoryA(ls_name)
//		lu_rtn = g.GetCurrentDirectoryA(lu_pass,ls_name)
//		lsfilename = ("SIMSPickedOrders" + string(today(), "YYYYMMDDhhmmss") + is_Warehouse_Code + ".csv")	
//		ls_name = ls_name + '\' + ("SIMSPickedOrders" + string(today(), "YYYYMMDDhhmmss") + is_Warehouse_Code + ".csv")	
//		IF  FileExists(ls_name) THEN 	FileDelete ( ls_name ) 
//		li_rtn=dw_report.Saveas(ls_name, CSV!, True)
//			//Send Email to DL that a new extract has been created.
//	Select Code_Descript into :lsEmail
//	From Lookup_Table
//	Where Project_Id = :gs_Project and code_type = 'OTMEXTRACTEMAIL';
//	
//	If lsEmail > '' Then
//		lsText = "Process Orders have been sent to OTM for Project = " + gs_Project + ", Database = " + sqlca.database + ", File Name = " + lsfilename
//		g.uf_send_email(lsEmail, lsText, lsText,ls_name)
////		IF  FileExists(ls_name) THEN 	FileDelete ( ls_name ) 
//		MessageBox(is_title, "Extract File has been sent to OTM!")
//		close(this)
//	End If
//
//END IF
//
//
end event

type dw_select from w_std_report`dw_select within w_friedrich_orders_to_otm_rpt
integer x = 18
integer y = 0
integer width = 2743
integer height = 288
string dataobject = "d_friedrich_picked_orders_search"
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

type cb_clear from w_std_report`cb_clear within w_friedrich_orders_to_otm_rpt
end type

type dw_report from w_std_report`dw_report within w_friedrich_orders_to_otm_rpt
integer x = 0
integer y = 300
integer width = 3625
integer height = 1592
integer taborder = 30
string dataobject = "d_friedrich_picked_orders"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_report::retrievestart;call super::retrievestart;RETURN 2
end event

type dw_saveas from datawindow within w_friedrich_orders_to_otm_rpt
boolean visible = false
integer x = 3365
integer y = 596
integer width = 686
integer height = 400
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_friedrich_orders_to_otm"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_friedrich_orders_to_otm_rpt
integer x = 2853
integer y = 160
integer width = 457
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Send To OTM"
end type

event clicked;String	lsOption,ls_name, lsfilename, lstext, lsEmail
Str_parms	lstrparms
ulong lu_rtn,lu_pass
integer li_rtn
//Triggered from menu
lu_pass = 300000
ls_name = space(5000)
 
IF IsValid(dw_saveas) and (dw_saveas.rowcount( ) > 0 ) THEN

//		ls_name = 'C:\export_orders_to_OTM'
//		boolean lbset
//		lbset = g.SetCurrentDirectoryA(ls_name)
		lu_rtn = g.GetCurrentDirectoryA(lu_pass,ls_name)
		lsfilename = ("SIMSPickedOrders" + string(today(), "YYYYMMDDhhmmss") + is_Warehouse_Code + ".csv")	
		ls_name = ls_name + '\' + ("SIMSPickedOrders" + string(today(), "YYYYMMDDhhmmss") + is_Warehouse_Code + ".csv")	
		IF  FileExists(ls_name) THEN 	FileDelete ( ls_name ) 
		li_rtn=dw_SaveAs.Saveas(ls_name, TEXT!, False)
			//Send Email to DL that a new extract has been created.
	Select Code_Descript into :lsEmail
	From Lookup_Table
	Where Project_Id = :gs_Project and code_type = 'OTMEXTRACTEMAIL';
	
	If lsEmail > '' Then
		lsText = "Process Orders have been sent to OTM for Project = " + gs_Project + ", Database = " + sqlca.database + ", File Name = " + lsfilename
		g.uf_send_email(lsEmail, lsText, lsText,ls_name)
//		IF  FileExists(ls_name) THEN 	FileDelete ( ls_name ) 
		MessageBox(is_title, "Extract File has been sent to OTM!")
//		close(this)
	End If

END IF


end event

