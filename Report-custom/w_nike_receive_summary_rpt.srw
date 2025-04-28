HA$PBExportHeader$w_nike_receive_summary_rpt.srw
forward
global type w_nike_receive_summary_rpt from window
end type
type dw_report from datawindow within w_nike_receive_summary_rpt
end type
type dw_query from datawindow within w_nike_receive_summary_rpt
end type
end forward

global type w_nike_receive_summary_rpt from window
integer x = 823
integer y = 360
integer width = 2016
integer height = 976
boolean titlebar = true
string title = "Receive Summary Report"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_print ( )
event ue_retrieve ( )
dw_report dw_report
dw_query dw_query
end type
global w_nike_receive_summary_rpt w_nike_receive_summary_rpt

type variables
String      is_title, is_org_sql
m_report im_menu
end variables

event ue_print();String ls_whcode
Date ld_sdate, ld_edate
OLEObject xl, xs
String filename
String lineout[1 to 20]
Long i, ll_cnt, pos
String dummy, lsord_type

If dw_query.AcceptText() = -1 Then Return

ls_whcode = dw_query.GetItemString(1, "wh_code")

If IsNull(ls_whcode) Then
	MessageBox(is_title, "Please choose a warehouse!")
	Return
End If

lsord_type = dw_query.GetItemString(1, "ord_type")

If IsNull(lsord_type) Then
	MessageBox(is_title, "Please choose order type!")
	Return
End If


ld_sdate = dw_query.GetItemDate(1, "s_date")
ld_edate = RelativeDate(dw_query.GetItemDate(1, "e_date"),1)

ll_cnt = dw_report.Retrieve(gs_project, ls_whcode, ld_sdate, ld_edate,lsord_type)

If ll_cnt < 1 Then 
	MessageBox(is_title, "No record found!")
	Return
End If

SetPointer(HourGlass!)

SetMicroHelp("Opening Excel ...")
filename = gs_syspath + "Reports\RcvSumm.xls"

If Not fileexists(filename) Then
	Messagebox('EWMS','Receiving summary report template file ' + filename + ' not available. Pls check')  
	Return 
End if	
	
xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(filename,0,True)
xs = xl.application.workbooks(1).worksheets(1)

SetMicroHelp("Printing report heading...")

xs.cells(1,1).Value = "Printed on: " + String(Today(),"mm/dd/yyyy hh:mm")
xs.cells(3,1).Value = "( " + String(dw_query.GetItemDate(1, "s_date")) + " - " + &
	String(dw_query.GetItemDate(1, "e_date")) + " )" 
 
pos = 5 

For i = 1 to ll_cnt  
	
	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))  
  
	pos += 1   
   xs.cells(pos,1).value = i   
	 
	lineout[1] = dw_report.GetItemString(i, "supp_invoice_no") 
	lineout[2] = dw_report.GetItemString(i, "supp_order_no") 
	lineout[3] = String(dw_report.GetItemDateTime(i, "ord_date"), "mm/dd/yyyy hh:mm")  
	lineout[4] = String(dw_report.GetItemDateTime(i, "request_Date"), "mm/dd/yyyy hh:mm")       
	lineout[5] = String(dw_report.GetItemDateTime(i, "complete_date"), "mm/dd/yyyy hh:mm")
	lineout[6] = dw_report.GetItemString(i, "container_no")
	lineout[7] = dw_report.GetItemString(i, "carrier")
	lineout[8] = dw_report.GetItemString(i, "vessel_name")
	lineout[9] = dw_report.GetItemString(i, "awb_bol_no")
	lineout[10] = dw_report.GetItemString(i, "container_type_code")
	xs.range("b" + String(pos) + ":k" +  String(pos)).Value = lineout

	xs.cells(pos,12).value=dw_report.GetItemNumber(i, "ctn_cnt")
	xs.cells(pos,13).value=dw_report.GetItemNumber(i, "division_10_qty")
	xs.cells(pos,14).value=dw_report.GetItemNumber(i, "division_20_qty")
	xs.cells(pos,15).value=dw_report.GetItemNumber(i, "division_30_qty")
	xs.cells(pos,16).value=dw_report.GetItemNumber(i, "division_40_qty")
	xs.cells(pos,17).value=dw_report.GetItemNumber(i, "total_pcs")
	xs.cells(pos,18).value=String(dw_report.GetItemDateTime(i, "arrival_date"), "dd-mmm-yy")
	xs.cells(pos,19).value = dw_report.GetItemString(i, "remark") 
	xs.cells(pos,20).value = dec(dw_report.GetItemString(i, "freight_cost"))
	xs.cells(pos,21).value = dec(dw_report.GetItemString(i, "other_cost"))
	
	If i + 2  <= ll_cnt Then xs.rows(pos + 1).Insert  
	
Next

SetMicroHelp("Complete!")
xl.Visible = True
xl.DisconnectObject()
end event

event ue_retrieve;This.Trigger Event ue_print()
end event

on w_nike_receive_summary_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.dw_report=create dw_report
this.dw_query=create dw_query
this.Control[]={this.dw_report,&
this.dw_query}
end on

on w_nike_receive_summary_rpt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
destroy(this.dw_query)
end on

event open;This.Move(0,0)

dw_query.SetTransObject(Sqlca)
dw_report.SetTransObject(Sqlca)

is_title = This.Title
im_menu = This.Menuid

dw_query.InsertRow(0)
dw_query.SetItem(1,"s_date",Today())
dw_query.SetItem(1,"e_date",Today())

im_menu.m_file.m_print.Enabled = True

// Loading from USer Warehouse Datastore 
DataWindowChild ldwc_warehouse,ldwc_warehouse2

dw_query.GetChild("wh_code", ldwc_warehouse)

ldwc_warehouse.SetTransObject(sqlca)

g.of_set_warehouse_dropdown(ldwc_warehouse)

dw_query.SetITem(1,'wh_code',gs_default_WH)


end event

type dw_report from datawindow within w_nike_receive_summary_rpt
boolean visible = false
integer x = 823
integer y = 92
integer width = 878
integer height = 572
integer taborder = 20
string dataobject = "d_nike_receive_summary"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_query from datawindow within w_nike_receive_summary_rpt
integer x = 306
integer y = 180
integer width = 1394
integer height = 472
integer taborder = 10
string dataobject = "d_nike_receive_summary_search"
boolean border = false
boolean livescroll = true
end type

