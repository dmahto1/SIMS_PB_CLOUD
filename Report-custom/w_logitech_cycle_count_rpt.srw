HA$PBExportHeader$w_logitech_cycle_count_rpt.srw
$PBExportComments$IAE Shipping Transaction Report
forward
global type w_logitech_cycle_count_rpt from w_std_report
end type
end forward

global type w_logitech_cycle_count_rpt from w_std_report
integer width = 3474
integer height = 2312
string title = "Cycle Count Report"
end type
global w_logitech_cycle_count_rpt w_logitech_cycle_count_rpt

type variables
string is_origsql

end variables

forward prototypes
public function string wf_select ()
end prototypes

public function string wf_select ();String ls_string
//ls_string= "SELECT Delivery_Master.Cust_Code, " +  &
//        "Delivery_Master.Cust_Name, "+ &   
//        " Delivery_Master.Contact_Person, "+ &   
//        " Delivery_Master.Address_1, " + & 
//        " Delivery_Master.Address_2," +   &
//        " Delivery_Master.Address_3," + &  
//        " Delivery_Master.Address_4, " + & 
//        " Delivery_Master.City,   "+ &
//        " Delivery_Master.State,"+ &   
//        " Delivery_Master.Zip,   "+ &
//        " Delivery_Master.Country, "+ &  
//        " Delivery_Master.AWB_BOL_No,"+ &   
//        " Delivery_Master.Complete_Date,"+ &   
//        " Delivery_Master.Cust_Order_No,"+ &
//        " Delivery_Master.do_no,   "+ &
//        " Delivery_Picking_Detail.SKU,"+ &   
//        " Delivery_Picking_Detail.Quantity,"+ &   
//        " Delivery_Serial_Detail.Serial_No  "+ &
//   " FROM Delivery_Master,   "+ &
//   "      Delivery_Picking_Detail,"+ &   
//   "      Delivery_Serial_Detail  "+ &
//   "WHERE ( Delivery_Picking_Detail.ID_No *= Delivery_Serial_Detail.ID_No) and  "+ &
//    "     ( Delivery_Picking_Detail.DO_No = Delivery_Master.DO_No )  and "+ &
//		"	Delivery_master.Ord_status = 'C' "+ &
// "and delivery_master.project_id = 'GENRAD' and "+ & 
//	" delivery_master.Complete_date >= '01-01-2001 00:00' "+ &
//"and delivery_master.Complete_date <= '03-01-2001 23:59' "+ &
ls_string=" and delivery_master.do_no in (select do_no from delivery_detail  "+ &
"where sku = '418-F234' ) and "+ &
"delivery_master.do_no in (select do_no from delivery_detail "+ &
"where sku= '418-F235') "+ &
"Union all "+ &
"SELECT Delivery_Master.Cust_Code,   "+ &
"         Delivery_Master.Cust_Name,   "+ &
 "        Delivery_Master.Contact_Person, "+ &   
 "        Delivery_Master.Address_1,   "+ &
 "        Delivery_Master.Address_2,   "+ &
 "       Delivery_Master.Address_3,   "+ &
  "      Delivery_Master.Address_4,   "+ &
  "     Delivery_Master.City,   "+ &
     "    Delivery_Master.State,  "+ & 
      "   Delivery_Master.Zip,   "+ &
 "        Delivery_Master.Country, "+ &  
 "       Delivery_Master.AWB_BOL_No, "+ &  
 "        Delivery_Master.Complete_Date, "+ &  
 "        Delivery_Master.Cust_Order_No, "+ &
 "        Delivery_Picking_Detail.SKU, "+ &   
 "        Delivery_Picking_Detail.Quantity,"+ &   
 "        Delivery_Serial_Detail.Serial_No  "+ &
 "   FROM Delivery_Master   "+ &
 "   INNER JOIN Delivery_Picking_Detail "+ &
 "       ON  Delivery_Master.DO_No = Delivery_Picking_Detail.DO_No " + &
 "   LEFT OUTER JOIN Delivery_Serial_Detail  "+ &
 "       ON Delivery_Picking_Detail.ID_No = Delivery_Serial_Detail.ID_No " + &
 " WHERE Delivery_master.Ord_status = 'C' "+ &
" and delivery_master.project_id = '"+ gs_project +"' and "+ & 
"	 delivery_master.Complete_date >= '" + string(dw_select.GetItemDateTime(1, "complete_date_from"),'mm-dd-yyyy hh:mm') + "' " + &
"and delivery_master.Complete_date <= '" + string(dw_select.GetItemDateTime(1, "complete_date_to"),'mm-dd-yyyy hh:mm') + "' " + &
"and delivery_master.do_no not in (select a.do_no from delivery_detail a  "+ &
"where a.sku = '418-F234' )"+ &
"and delivery_master.do_no not in (select b.do_no from delivery_detail b  "+ &
"where b.sku = '418-F235' )"
Return ls_string

end function

on w_logitech_cycle_count_rpt.create
call super::create
end on

on w_logitech_cycle_count_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;is_OrigSql = dw_report.getsqlselect()



end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-240)
end event

event ue_clear;
dw_select.Reset()
dw_select.InsertRow(0)


end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc		
String	lsFilter,	lsrc

dw_select.InsertRow(0)

//Change labels on date range in Search screen to show order date instead of conplete date (this screen is also used with receiving trans rpt)
//dw_select.Modify("date_type_t.text='Order'")

//Default from/to dates 
dw_select.SetItem(1,'complete_date_from',f_get_date("BEGIN"))
dw_select.SetItem(1,'complete_date_to',f_get_date("END")) 

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('wh_code', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)
end event

event ue_retrieve;
String ls_Where
String ls_NewSql,	&
			lsModify

Long	llRowCount,	&
		llRowPos

dw_select.accepttext()

If dw_select.AcceptText() = -1 Then Return

lsModify = "user_id_t.Text = '" + gs_userid + "'"
dw_report.Modify(lsModify)

SetPointer(HourGlass!)
dw_report.Reset()

dw_report.SetRedraw(False)

//Always Tack on Project ID 
ls_where += " and CC_master.project_id = '" + gs_project + "'"

// If present, tackon Order Number
If Not isnull(dw_select.GetItemString(1,'sku')) Then
	ls_Where += " and CC_Inventory.sku = '" + dw_select.GetItemString(1,'sku') + "'"
End If

// If present, tackon Warehouse
If Not isnull(dw_select.GetItemString(1,'wh_code')) Then
	ls_Where += " and CC_master.wh_code = '" + dw_select.GetItemString(1,'wh_code') + "'"
ELSE
	MessageBox ("Error", "Warehouse is required to search.")
	dw_select.SetColumn('wh_code')
	dw_select.SetFocus()
	RETURN 
End If

//If present, tackon From and To Complete Dates

//From
If date(dw_select.GetItemDateTime(1, "complete_date_from")) > date('01-01-1900') Then
	ls_Where = ls_Where + " and CC_master.Complete_Date >= '" + string(dw_select.GetItemDateTime(1, "complete_date_from"),'mm-dd-yyyy hh:mm') + "'"
End If

//To
If date(dw_select.GetItemDateTime(1, "complete_date_To")) > date('01-01-1900') Then
	ls_Where = ls_Where + " and CC_master.Complete_Date <= '" + string(dw_select.GetItemDateTime(1, "complete_date_To"),'mm-dd-yyyy hh:mm') + "'"
End If

integer li_pos

li_pos = Pos (upper(is_origsql), "ORDER BY")

ls_NewSql = left(is_origsql, (li_pos -1)) + ls_Where + " " + mid(is_origsql, (li_pos))
dw_report.setsqlselect(ls_Newsql)

//MessageBox ("ok", ls_NewSql)


llRowCount = dw_report.Retrieve(gs_project)
If llRowCount > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If

dw_report.SetRedraw(True)
SetPointer(Arrow!)
end event

type dw_select from w_std_report`dw_select within w_logitech_cycle_count_rpt
integer x = 5
integer y = 16
integer width = 2985
integer height = 168
string dataobject = "d_logitech_cycle_count_rpt_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;call super::constructor;
//sharing dw with other reports, make cust type invisible here
This.Modify('cust_type.visible=0 cust_type_t1.visible=0 cust_type_t2.visible=0')
end event

type cb_clear from w_std_report`cb_clear within w_logitech_cycle_count_rpt
integer width = 293
integer height = 96
end type

type dw_report from w_std_report`dw_report within w_logitech_cycle_count_rpt
integer x = 14
integer y = 196
integer width = 3392
integer height = 1900
string dataobject = "d_logitech_cycle_count_rpt"
boolean hscrollbar = true
end type

