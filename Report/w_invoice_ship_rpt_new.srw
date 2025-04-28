HA$PBExportHeader$w_invoice_ship_rpt_new.srw
forward
global type w_invoice_ship_rpt_new from w_std_report
end type
end forward

global type w_invoice_ship_rpt_new from w_std_report
integer width = 3557
integer height = 2000
string title = "Invoice ship Report"
end type
global w_invoice_ship_rpt_new w_invoice_ship_rpt_new

type variables
string is_sql
end variables

forward prototypes
public function string wf_sql (string as_ind)
end prototypes

public function string wf_sql (string as_ind);	string ls_sql
	
IF as_ind = 'O' THEN	//this means if sku 418-FS228 & 418-FS320A Is included

	//	ls_sql = " and  delivery_master.do_no in (select do_no from delivery_detail where sku = '418-F228' ) "+&  
	//            " and delivery_master.do_no in (select do_no from delivery_detail where sku = '418-FS320A')"  

	//4/01 PCONKL - changed to include orders where either 418-f228 or 418-FS320A is present, not only orders where both are present
	ls_sql = " and  delivery_master.do_no in (select do_no from delivery_detail where sku = '418-F228' or sku = '418-FS320A' ) "

ELSEIF as_ind = 'F' THEN //this means if sku 418-FS228 & 418-FS320A Is not included				
	
        // ls_sql = " and  delivery_master.do_no not in (select do_no from delivery_detail where sku = '418-F228' ) "+&  
        //    		" and delivery_master.do_no not in (select do_no from delivery_detail where sku = '418-FS320A')" 
		  
		  ls_sql = " and  delivery_master.do_no not in (select do_no from delivery_detail where sku = '418-F228' or sku = '418-FS320A' ) "
			
END IF				
   
return  ls_sql
end function

on w_invoice_ship_rpt_new.create
call super::create
end on

on w_invoice_ship_rpt_new.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;String ls_sql,lsFilter,ls_dealer_code,ls_country,ls_do,ls_exp,ls_null,ls_option
Datetime ldt_start,ldt_end,ldt_null
 long ll_temp,i,ll_row,ll_null
Boolean lb_where 
ls_sql = is_sql

SetNull(ls_null)
Setnull(ll_null)
Setnull(ldt_null)

dw_select.AcceptText()
dw_report.Reset()
lb_where = false

dw_report.Setfilter("")
dw_report.object.t_selection.text=""

ldt_start= dw_select.object.start_date[1]
ldt_end =dw_select.object.enddate[1]
ls_dealer_code =dw_select.object.dealer_code[1]
ls_country =dw_select.object.country_code[1]
ls_option = dw_select.object.option[1]

//04/01 PConkl - search criteria in SQl instead of filter

//always tackon Project
ls_sql += " and Delivery_master.project_id = '" + gs_project + "'"

//Complete Date
IF Not ISNULL(ldt_start) THEN
	ls_sql += " and Delivery_master.complete_date >= '" + string(ldt_start,'mm-dd-yyyy hh:mm') + "'"
	lb_where = True
End If

IF Not ISNULL(ldt_end) THEN
	ls_sql += " and Delivery_master.complete_date <= '" + string(ldt_end,'mm-dd-yyyy hh:mm') + "'"
	lb_where = True
End If

//Dealer Code
IF Not ISNULL(ls_dealer_code)  and ls_dealer_code <> " " THEN
	ls_sql += " and Delivery_master.cust_code = '" + ls_dealer_code  + "' "
	lb_where = True
End If

//Country
IF Not ISNULL(ls_country) and ls_country <> " " THEN
	ls_sql += " and Delivery_master.country like '" + ls_country + "%' "
	lb_where = True
End If

IF ls_option = 'O' THEN //this means if sku 418-FS228 & 418-FS320A Is included
	ls_sql +=wf_sql('O')
	dw_report.object.t_selection.text="Orders with parts 418-F228 or 418-FS320A"
	lb_where = True
ELSEIF ls_option = 'F' THEN //this means if sku 418-FS228 & 418-FS320A Is not included
	  dw_report.object.t_selection.text="Orders without parts 418-F228 and 418-FS320A"
     ls_sql +=wf_sql('F') 
	  lb_where = True
END IF	  

dw_report.SetSQLSelect(ls_sql)

dw_report.SetRedraw(False)

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF	  

IF dw_report.Retrieve() = 0 THEN
	MessageBox(is_title,"No Records found")		
   im_menu.m_file.m_print.Enabled = FALSE
	//Return
ELSE
 	im_menu.m_file.m_print.Enabled = TRUE
END IF

//If Showing orders with 418-FS228 or 418-FS320A, Filter to show only those
IF ls_option = 'O' THEN
	lsFilter = "Upper(delivery_detail_SKU) = '418-FS228' or Upper(delivery_detail_SKU) = '418-FS320A'"
	dw_report.SetFilter(lsFilter)
	dw_report.Filter()
Elseif ls_option = 'F' Then /*without, only need to show 1 line per order*/
	lsFilter = " isnull(cust_order_no) or getrow() = 1 or cust_order_no[0] <> cust_order_no[-1] "
	dw_report.SetFilter(lsFilter)
	dw_report.Filter()
End If

dw_report.SetRedraw(True)
end event

event ue_clear;dw_report.Reset()
dw_select.Reset()
dw_select.Insertrow(0)
dw_report.object.t_selection.text=""

end event

event ue_print;//Overide the print statement
dw_report.Modify("DataWindow.Print.Orientation = 1")
OpenWithParm(w_dw_print_options,dw_report) 

end event

event resize;call super::resize;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-225)
end event

event ue_postopen;call super::ue_postopen;is_sql = dw_report.GetSQLSelect()
end event

type dw_select from w_std_report`dw_select within w_invoice_ship_rpt_new
integer y = 32
integer width = 3401
integer height = 188
string dataobject = "d_invoice_location_rpt_search_new"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::clicked;datetime	ldt_begin_date
datetime	ldt_end_date

CHOOSE CASE DWO.Name
		
	CASE "start_date"
			   ldt_begin_date= this.object.start_date[row]
				IF ISNULL(ldt_begin_date) THEN
					ldt_begin_date = f_get_date("BEGIN")
					this.object.start_date[row]=ldt_begin_date
				END IF	

	CASE "enddate"
			ldt_end_date= this.object.enddate[row]
			IF ISNULL(ldt_end_date) THEN
		   	ldt_end_date = f_get_date("END")
				this.object.enddate[row]=ldt_end_date
			END IF	

END CHOOSE

end event

event dw_select::itemfocuschanged;call super::itemfocuschanged;//CHOOSE CASE dwo.Name
//	CASE "country_code","dealer_code"
//		w_invoice_ship_rpt_new.SetMicroHelp(This.object.country_code.Tag)
//	CASE ELSE
//		w_invoice_ship_rpt_new.SetMicroHelp("Ready")
//END CHOOSE
// 
end event

event dw_select::itemchanged;call super::itemchanged;
//reset report if option changed
If dwo.name = 'option' then
	dw_report.reset()
End If
end event

type cb_clear from w_std_report`cb_clear within w_invoice_ship_rpt_new
end type

type dw_report from w_std_report`dw_report within w_invoice_ship_rpt_new
integer x = 5
integer y = 216
integer width = 3497
integer height = 1552
string dataobject = "d_invoice_location_rpt_new"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

