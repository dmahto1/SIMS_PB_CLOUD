$PBExportHeader$w_nike_outbound_dailyactivity_rpt.srw
forward
global type w_nike_outbound_dailyactivity_rpt from window
end type
type dw_delivery_detail from datawindow within w_nike_outbound_dailyactivity_rpt
end type
type dw_nike_request from datawindow within w_nike_outbound_dailyactivity_rpt
end type
type dw_query from datawindow within w_nike_outbound_dailyactivity_rpt
end type
type dw_report from datawindow within w_nike_outbound_dailyactivity_rpt
end type
type cb_search from commandbutton within w_nike_outbound_dailyactivity_rpt
end type
end forward

global type w_nike_outbound_dailyactivity_rpt from window
integer x = 823
integer y = 360
integer width = 2021
integer height = 912
boolean titlebar = true
string title = "DAILY ACTIVITIES FOR OUTBOUND "
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_retrieve ( )
event ue_print ( )
dw_delivery_detail dw_delivery_detail
dw_nike_request dw_nike_request
dw_query dw_query
dw_report dw_report
cb_search cb_search
end type
global w_nike_outbound_dailyactivity_rpt w_nike_outbound_dailyactivity_rpt

type variables
String      is_title, is_org_sql
m_report im_menu
end variables

event ue_retrieve();string ls_whcode, filename, ls_dono
date ld_sdate, ld_edate
long pos, i, j, ll_cnt_dt, ll_cnt
Long ll_nike_request, ll_request, ll_line, ll_ship
long ll_line_fill, ll_cnt_fill, ll_line_partial
OLEObject xl, xs

SetPointer(HourGlass!)

If dw_query.AcceptText() = -1 Then Return

ls_whcode = dw_query.GetItemString(1, "wh_code")
if isNull(ls_whcode) Then
 	MessageBox(is_title, "Please enter warehouse code!")
	 dw_query.setcolumn("wh_code")
	 dw_query.setfocus()
	Return
end if

ld_sdate = dw_query.GetItemDate(1, "s_date")
if isNull(ls_whcode) Then
 	MessageBox(is_title, "Please enter Date!")
	 dw_query.setcolumn("s_date")
	 dw_query.setfocus()
	Return
end if

ld_edate = relativedate(ld_sdate, 1)

SetPointer(HourGlass!)

// Retrieve do_no not 100% fulfilled
ll_nike_request = 0
If dw_nike_request.Retrieve(gs_project, ls_whcode, ld_sdate, ld_edate) > 0 Then
	ll_nike_request = dw_nike_request.Getitemnumber(1, "request_qty")
End If


ll_cnt = dw_report.Retrieve(gs_project, ls_whcode, ld_sdate, ld_edate)

ll_request = 0
ll_ship = 0
ll_line = 0
ll_cnt_fill = 0
ll_line_fill = 0
ll_line_partial = 0
For i = 1 to ll_cnt
	SetMicroHelp("Calculating order " + String(i) + " of " + String(ll_cnt))
	ls_dono = dw_report.GetItemString(i, "do_no")
	ll_request += dw_report.GetItemNumber(i, "request_qty")
	ll_ship += dw_report.GetItemNumber(i, "ship_qty")
	ll_line += dw_report.GetItemNumber(i, "line")
	
	If dw_report.GetItemNumber(i, "request_qty") = dw_report.GetItemNumber(i, "ship_qty") Then
		ll_line_fill += dw_report.GetItemNumber(i, "line")
		ll_cnt_fill += 1
	Else
		ll_cnt_dt = dw_delivery_detail.Retrieve(ls_dono)
		For j = 1 to ll_cnt_dt
			If dw_delivery_detail.GetItemNumber(j, "req_qty") = dw_delivery_detail.GetItemNumber(j, "alloc_qty") Then
				ll_line_fill += 1
			Else
				ll_line_partial += 1
			End If
		Next
	End If
	
Next


SetMicroHelp("Opening Excel ...")
filename = gs_syspath + "Reports\dailyactivity_rpt.xls"

xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(filename,0,True)
xs = xl.application.workbooks(1).worksheets(1)

SetMicroHelp("Printing report heading...")

xs.cells(1,1).Value = "Printed on: " + String(Today(),"mm/dd/yyyy hh:mm")
xs.cells(2,1).value = "Daily Activity for Outbound on "+String(ld_sdate, "mm/dd/yyyy")

pos = 6
xs.cells(pos,1).Value = ll_nike_request
xs.cells(pos,2).Value = ll_cnt
xs.cells(pos,3).Value = ll_cnt_fill
xs.cells(pos,4).Value = ll_cnt - ll_cnt_fill
xs.cells(pos,5).Value = ll_line
xs.cells(pos,6).Value = ll_line_fill
xs.cells(pos,7).Value = ll_line_partial
xs.cells(pos,9).Value = ll_request
xs.cells(pos,10).Value = ll_ship


SetMicroHelp("Complete!")
xl.Visible = True
xl.DisconnectObject()
destroy xl
destroy xs

end event

event ue_print;This.Trigger Event ue_print()
end event

event open;This.Move(0,0)

dw_report.SetTransObject(Sqlca)
dw_delivery_detail.SetTransObject(Sqlca)
dw_nike_request.SetTransObject(Sqlca)
dw_query.SetTransObject(Sqlca)

is_title = This.Title
im_menu = This.Menuid

dw_query.InsertRow(0)
dw_query.SetItem(1, "wh_code", gs_default_wh)
dw_query.SetItem(1,"s_date",Today())
dw_query.settaborder("e_date",0)
dw_query.settaborder("customer",0)
dw_query.setcolumn("s_date")
dw_query.setfocus()

// Loading from USer Warehouse Datastore 
DataWindowChild ldwc_warehouse,ldwc_warehouse2

dw_query.GetChild("wh_code", ldwc_warehouse)

ldwc_warehouse.SetTransObject(sqlca)

g.of_set_warehouse_dropdown(ldwc_warehouse)

dw_query.SetITem(1,'wh_code',gs_default_WH)
end event

on w_nike_outbound_dailyactivity_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.dw_delivery_detail=create dw_delivery_detail
this.dw_nike_request=create dw_nike_request
this.dw_query=create dw_query
this.dw_report=create dw_report
this.cb_search=create cb_search
this.Control[]={this.dw_delivery_detail,&
this.dw_nike_request,&
this.dw_query,&
this.dw_report,&
this.cb_search}
end on

on w_nike_outbound_dailyactivity_rpt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_delivery_detail)
destroy(this.dw_nike_request)
destroy(this.dw_query)
destroy(this.dw_report)
destroy(this.cb_search)
end on

type dw_delivery_detail from datawindow within w_nike_outbound_dailyactivity_rpt
boolean visible = false
integer x = 91
integer y = 392
integer width = 494
integer height = 360
integer taborder = 20
string dataobject = "d_nike_delivery_detail"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_nike_request from datawindow within w_nike_outbound_dailyactivity_rpt
boolean visible = false
integer x = 23
integer y = 20
integer width = 494
integer height = 360
integer taborder = 20
string dataobject = "d_nike_outbound_dailyactivity_order"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_query from datawindow within w_nike_outbound_dailyactivity_rpt
integer x = 466
integer y = 92
integer width = 837
integer height = 248
integer taborder = 40
string dataobject = "d_nike_delivery_summary_search"
boolean border = false
boolean livescroll = true
end type

type dw_report from datawindow within w_nike_outbound_dailyactivity_rpt
boolean visible = false
integer x = 1394
integer y = 212
integer width = 878
integer height = 572
integer taborder = 10
string dataobject = "d_nike_outbound_dailyactivity_complete"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_search from commandbutton within w_nike_outbound_dailyactivity_rpt
integer x = 846
integer y = 484
integer width = 283
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;parent.triggerevent("ue_retrieve")

end event

