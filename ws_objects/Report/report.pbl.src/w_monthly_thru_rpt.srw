$PBExportHeader$w_monthly_thru_rpt.srw
$PBExportComments$Monthly Thruput Report
forward
global type w_monthly_thru_rpt from w_std_report
end type
end forward

global type w_monthly_thru_rpt from w_std_report
integer width = 3666
integer height = 2196
string title = "Monthly Throughput Report"
end type
global w_monthly_thru_rpt w_monthly_thru_rpt

type variables
string is_origsql

end variables

on w_monthly_thru_rpt.create
call super::create
end on

on w_monthly_thru_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;is_OrigSql = dw_report.getsqlselect()
//messagebox("is origsql", is_origsql)


end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_retrieve;
Long	llRowCount,	&
		llRowPos,	&
		llCount
		
String	lsSku,	&
			lsSupplier,	&
			lsWarehouse,	&
			lsModify

Date		ldFromDate,	&
			ldToDate
SetPointer(HourGlass!)
dw_report.Reset()

dw_select.AcceptText()


ldFromDate = dw_select.GetItemDate(1,"from_date")
ldToDate = RelativeDate(dw_select.GetItemDate(1,"to_date"),1) /* bump by 1 and check foir less than since we're not including time*/

lsWarehouse = dw_select.GetItemString(1,'Warehouse')
If isnull(lswarehouse) Then
	MessageBox(is_title,'Warehouse is Required!')
	Return
End If

//Set date range literal on report
lsModify = "st_date_range.Text = '" + String(ldfromdate,'mm/dd/yyyy') + " Through " + string(ldtodate,'mm/dd/yyyy') + "'"
dw_report.modify(lsModify)

dw_report.SetRedraw(False)

llRowCount = dw_report.Retrieve(gs_project,lsWarehouse)

If llRowCount > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If

//We need to calculate  received and shipp qty's

For llRowPos = 1 to llRowCount
	
	lsSku = dw_report.GetItemString(llRowPos,'SKU')
	//lsWarehouse = dw_report.GetItemString(llRowPos,'wh_code')
	lsSupplier = dw_report.GetItemString(llRowPos,'Supp_code')
	
	//Get Received QTY for day
	Select Sum (receive_putaway.quantity)
	Into	:llCount
	From	Receive_master, receive_putaway
	Where Receive_master.ro_no = receive_putaway.Ro_no and
			Receive_master.Project_id = :gs_project and
			Receive_master.ord_status = 'C' and
			Receive_master.Complete_Date >= :ldfromdate and
			Receive_master.Complete_date < :ldtodate and
			receive_putaway.sku = :lsSku and 
			receive_putaway.supp_code = :lsSupplier and
			Receive_master.wh_code = :lsWarehouse
			Using SQLCA;
			
	If llCount <> 0 Then
		dw_report.SetItem(llRowPos,'received_qty',llCount)
	Else
		dw_report.SetItem(llRowPos,'received_qty',0)
	End If
	
	//Get Delivered QTY for day
	Select Sum (delivery_picking.quantity)
	Into	:llCount
	From	delivery_master, delivery_picking
	Where delivery_master.do_no = delivery_picking.Do_no and
			delivery_master.Project_id = :gs_project and
			delivery_master.ord_status = 'C' and
			delivery_master.Complete_Date >= :ldfromdate and
			delivery_master.Complete_date < :ldtodate and
			delivery_picking.sku = :lsSku and 
			delivery_picking.supp_code = :lsSupplier and
			delivery_master.wh_code = :lsWarehouse
			Using SQLCA;
	
	If llCount <> 0 Then
		dw_report.SetItem(llRowPos,'shipped_qty',llCount)
	Else
		dw_report.SetItem(llRowPos,'shipped_qty',0)
	End If
	
	//Get Allocated QTY for day (picked but not confirmed)
	Select Sum (delivery_picking.quantity)
	Into	:llCount
	From	delivery_master, delivery_picking
	Where delivery_master.do_no = delivery_picking.Do_no and
			delivery_master.Project_id = :gs_project and
			delivery_master.ord_status <> 'C' and 
			delivery_master.ord_status <> 'V' and
			delivery_master.Complete_Date >= :ldfromdate and
			delivery_master.Complete_date < :ldtodate and
			delivery_picking.sku = :lsSku and 
			delivery_picking.supp_code = :lsSupplier and
			delivery_master.wh_code = :lsWarehouse
			Using SQLCA;
	
	If llCount <> 0 Then
		dw_report.SetItem(llRowPos,'alloc_qty',llCount)
	Else
		dw_report.SetItem(llRowPos,'alloc_qty',0)
	End If
	
Next /*report row*/

dw_report.SetRedraw(True)
SetPointer(Arrow!)
end event

event ue_postopen;call super::ue_postopen;Date	ldBeginDt
String	lsDate,	&
			lsFilter
DatawindowChild	ldwc

//populate dropdowns - not done automatically since dw not being retrieved


//dw_select.GetChild('warehouse', ldwc)
//ldwc.SetTransObject(Sqlca)
//ldwc.Retrieve()
//
////Filter Warehouse dropdown by Current Project
//lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
//ldwc.SetFilter(lsFilter)
//ldwc.Filter()
//dw_select.SetITem(1,'warehouse',gs_default_wh)

// LTK 20150827  Commented block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
DataWindowChild ldwc_warehouse
dw_select.GetChild("warehouse", ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_warehouse)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "warehouse", gs_default_wh)
end if



dw_select.SetItem(1,"to_date",today())

lsDate = String(Month(today())) + '/01/' + String(year(today()))
ldBeginDt = Date(lsDate)
dw_select.SetITem(1,'From_date',ldBeginDt)

end event

type dw_select from w_std_report`dw_select within w_monthly_thru_rpt
event type long ue_process_enter ( )
integer x = 14
integer y = 8
integer width = 2519
integer height = 120
string dataobject = "d_throughput_rpt_srch"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::ue_process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

type cb_clear from w_std_report`cb_clear within w_monthly_thru_rpt
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_monthly_thru_rpt
integer x = 9
integer y = 132
integer width = 3570
integer height = 1836
integer taborder = 30
string dataobject = "d_throughput_rpt"
boolean hscrollbar = true
end type

