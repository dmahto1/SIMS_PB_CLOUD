$PBExportHeader$w_nike_order_details_report.srw
forward
global type w_nike_order_details_report from window
end type
type dw_report from datawindow within w_nike_order_details_report
end type
type dw_query from datawindow within w_nike_order_details_report
end type
end forward

global type w_nike_order_details_report from window
integer x = 823
integer y = 360
integer width = 2158
integer height = 796
boolean titlebar = true
string title = "Order Details Report"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 81324524
event ue_print ( )
event ue_retrieve ( )
dw_report dw_report
dw_query dw_query
end type
global w_nike_order_details_report w_nike_order_details_report

type variables
String      is_title, is_org_sql
m_report im_menu
end variables

event ue_print();Long i,ll_cnt,pos
 
String filename,ls_whcode,ls_sizebreak
String lineout[1 to 16]

Date 		ld_sdate, ld_edate,ld_shipstrdt,ld_shipenddt
Datetime ldtm_sdate, ldtm_edate,ldtm_shipstrdt,ldtm_shipenddt

OLEObject xl, xs

If dw_query.AcceptText() = -1 Then Return

ls_whcode 		= dw_query.GetItemString(1, "wh_code")
ls_sizebreak 	= dw_query.GetItemString(1, "size_breakdown")

If IsNull(ls_whcode) or len(ls_whcode) <= 0 Then
	MessageBox(is_title, "Please choose a warehouse!")
	Return
End If


ld_sdate 		= Date(dw_query.GetItemDateTime(1, "s_date"))
ld_edate 		= Date(dw_query.GetItemDateTime(1, "e_date"))
ld_shipstrdt 	= Date(dw_query.GetItemDateTime(1, "ship_frdt"))
ld_shipenddt 	= Date(dw_query.GetItemDateTime(1, "ship_todt"))

//SARUN VER101201
long ll,ll_11,ll_12,ll_21,ll_22,ll_1,ll_2

if isnull(ld_sdate) or ld_sdate < Date(2001,01,01) then 
	ll_11 = 0
else
	ll_11 = 1
end if
if isnull(ld_edate) or ld_edate < Date(2001,01,01) then 
	ll_12 = 0
else
	ll_12 = 1
end if
if isnull(ld_shipstrdt) or ld_shipstrdt < Date(2001,01,01) then 
	ll_21 = 0
else
	ll_21 = 1
end if
if isnull(ld_shipenddt) or ld_shipenddt < Date(2001,01,01) then 
	ll_22 = 0
else
	ll_22 = 1
end if

ll_1 = ll_11 + ll_12
ll_2 = ll_21 + ll_22
ll	  = ll_1  + ll_2	

if ll_1 = 0 and ll_2 = 0 then
	MessageBox(is_title, "Please enter Date")
	return
end if

if ll_1 = 1 or ll_2 = 1  then
	MessageBox(is_title, "Please enter Date")
	return
end if

if (ll = 3) then
	MessageBox(is_title, "Please enter Date")
	return
end if

if ll_1 = 2 and ld_sdate > ld_edate then
	MessageBox(is_title, "End Date should be greater than the start Date")
	return
end if

if ll_2 = 2 and ld_shipstrdt > ld_shipenddt then
	MessageBox(is_title, "End Date should be greater than the start Date")
	//dw_query.setfocus(1)
	
	return
end if

if ll_11 = 0 or ll_12 = 0 then 
	select min(ord_date),max(ord_date) into :ldtm_sdate,:ldtm_edate from delivery_master WHERE project_id = :gs_project ;
	ld_sdate = date(ldtm_sdate)
	ld_edate = date(ldtm_edate)
end if

if ll_21 = 0 or ll_22 = 0  then 
	select min(schedule_date),max(schedule_date) into :ldtm_shipstrdt,:ldtm_shipenddt from delivery_master WHERE project_id = :gs_project;
	ld_shipstrdt = date(ldtm_shipstrdt)
	ld_shipenddt = date(ldtm_shipenddt)
end if

if ls_sizebreak = 'Y' then
	dw_report.dataobject = "d_nike_order_details_report_withsizebrk"
else
	dw_report.dataobject = "d_nike_order_details_report"
end if

dw_report.reset()
dw_report.SetTransObject(Sqlca)
//SARUN VER101201
ll_cnt = dw_report.Retrieve(gs_project, ld_sdate, ld_edate, ls_whcode,ld_shipstrdt,ld_shipenddt)

If ll_cnt < 1 Then
	MessageBox(is_title, "No record found!")
	Return
End If

SetPointer(HourGlass!)

SetMicroHelp("Opening Excel ...")
filename = gs_syspath + "Reports\Order_Details_report.xls"

xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(filename,0,True)
xs = xl.application.workbooks(1).worksheets(1)

SetMicroHelp("Printing report heading...")

xs.cells(1,1).Value = "Printed on: " + String(Today(),"mm/dd/yyyy hh:mm")

if ll = 4 then
	xs.cells(3,1).Value = "Order Date From : " + String(ld_sdate,"mm/dd/yyyy") + " to " + String(ld_edate,"mm/dd/yyyy") + " )" 	
	xs.cells(4,1).Value = "Ship Date From : " + String(ld_shipstrdt,"mm/dd/yyyy") + " to " + String(ld_shipenddt,"mm/dd/yyyy") + " )" 	
else	
	if ll_1= 2 then
		xs.cells(3,1).Value = "Order Date From : " + String(ld_sdate,"mm/dd/yyyy") + " to " + String(ld_edate,"mm/dd/yyyy") + " )" 
	end if
	if ll_2 = 2 then
		xs.cells(3,1).Value = "Ship Date From : " + String(ld_shipstrdt,"mm/dd/yyyy") + " to " + String(ld_shipenddt,"mm/dd/yyyy") + " )" 	
	end if
end if

pos = 5

For i = 1 to ll_cnt
	pos += 1 	
	If i + 2 <= ll_cnt Then xs.rows(pos + 1).Insert
	
	SetMicroHelp("Calculating order " + String(i) + " of " + String(ll_cnt))
	
	lineout[1] = dw_report.GetItemString(i, "shp_no")
	lineout[2] = dw_report.GetItemString(i, "dln_no")
	lineout[3] = dw_report.GetItemString(i, "ord_satatus")
	lineout[4] = dw_report.GetItemString(i, "ship_to_part")
	lineout[5] = dw_report.GetItemString(i, "ship_to_name")
   lineout[6] = mid(dw_report.GetItemString(i, "mat_no"),1,10)
	lineout[7] = mid(dw_report.GetItemString(i, "sku"),12)
	lineout[8] = string(dw_report.GetItemDatetime(i, "Ord_Date"),'mm/dd/yyyy')
	lineout[9] = string(dw_report.GetItemDatetime(i, "Need_Date"),'mm/dd/yyyy')
	lineout[10] = string(dw_report.GetItemDatetime(i, "ATD"),'mm/dd/yyyy')
	lineout[11] = string(dw_report.GetItemDatetime(i, "schedule_Date"),'mm/dd/yyyy')
	lineout[12] = string(dw_report.GetItemDatetime(i, "Complete_Date"),'mm/dd/yyyy')
	lineout[13] = ""
	lineout[14] = ""
	lineout[15] = dw_report.GetItemString(i, "grp")
	lineout[16] = dw_report.GetItemString(i, "category_type")
	

	xs.range("a" + String(pos) + ":P" +  String(pos)).Value = lineout
	xs.cells(pos,13).value = dw_report.GetItemNumber(i, "tot_req")
	xs.cells(pos,14).value = dw_report.GetItemNumber(i, "tot_alloc")

Next	

SetMicroHelp("Complete!")
xl.Visible = True
xl.DisconnectObject()
Destroy xl
Destroy xs


end event

event ue_retrieve;This.Trigger Event ue_print()
end event

on w_nike_order_details_report.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.dw_report=create dw_report
this.dw_query=create dw_query
this.Control[]={this.dw_report,&
this.dw_query}
end on

on w_nike_order_details_report.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
destroy(this.dw_query)
end on

event open;This.Move(0,0)

is_title = This.Title
im_menu = This.Menuid

dw_query.SetTransObject(Sqlca)



dw_query.InsertRow(0)
//dw_query.SetItem(1,"s_date",Today())
//dw_query.SetItem(1,"e_date",Today())

im_menu.m_file.m_print.Enabled = True

// Loading from USer Warehouse Datastore 
DataWindowChild ldwc_warehouse,ldwc_warehouse2

dw_query.GetChild("wh_code", ldwc_warehouse)

ldwc_warehouse.SetTransObject(sqlca)

g.of_set_warehouse_dropdown(ldwc_warehouse)

dw_query.SetITem(1,'wh_code',gs_default_WH)


end event

type dw_report from datawindow within w_nike_order_details_report
boolean visible = false
integer y = 588
integer width = 2610
integer height = 404
integer taborder = 20
string dataobject = "d_nike_order_details_report"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_query from datawindow within w_nike_order_details_report
integer x = 5
integer y = 92
integer width = 1417
integer height = 520
integer taborder = 10
string dataobject = "d_nike_order_details_report_search"
boolean border = false
boolean livescroll = true
end type

