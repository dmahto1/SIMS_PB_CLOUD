$PBExportHeader$w_nike_replenishment_report.srw
forward
global type w_nike_replenishment_report from w_nike_report_ancestor
end type
type cb_retreive from commandbutton within w_nike_replenishment_report
end type
type cb_excel from commandbutton within w_nike_replenishment_report
end type
end forward

global type w_nike_replenishment_report from w_nike_report_ancestor
integer width = 3931
string title = "Replenishment Report"
long backcolor = 81324524
cb_retreive cb_retreive
cb_excel cb_excel
end type
global w_nike_replenishment_report w_nike_replenishment_report

on w_nike_replenishment_report.create
int iCurrent
call super::create
this.cb_retreive=create cb_retreive
this.cb_excel=create cb_excel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retreive
this.Control[iCurrent+2]=this.cb_excel
end on

on w_nike_replenishment_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_retreive)
destroy(this.cb_excel)
end on

event open;call super::open;DateTime ld_sdate, ld_edate
Time     lt_stime, lt_etime

lt_stime = 00:00:00
lt_etime = 23:59:59

ld_sdate = DateTime(Today(), lt_stime)
ld_edate = DateTime(Today(), lt_etime)

dw_query.InsertRow(0)
dw_query.SetItem(1,"wh_code",gs_default_wh)
dw_query.SetItem(1,"s_date",ld_sdate)
dw_query.SetItem(1,"e_date",ld_edate)

// Loading from USer Warehouse Datastore 
DataWindowChild ldwc_warehouse,ldwc_warehouse2

dw_query.GetChild("wh_code", ldwc_warehouse)

ldwc_warehouse.SetTransObject(sqlca)

g.of_set_warehouse_dropdown(ldwc_warehouse)

dw_query.SetITem(1,'wh_code',gs_default_WH)



end event

event ue_retrieve;String 	ls_whcode,ls_div
DateTime	ld_sdate, ld_edate
Time     lt_stime = 00:00:00, lt_etime = 23:59:59
Long 		ll_cnt,ll_dd

SetPointer(HourGlass!)

If dw_query.AcceptText() = -1 Then Return
dw_report.Reset()

ls_whcode = dw_query.GetItemString(1, "wh_code")


If IsNull(ls_whcode) Then
	MessageBox(is_title, "Please choose a warehouse!")
	Return
End If

ls_div = dw_query.GetItemString(1, "div_code")

If IsNull(ls_div) or len(ls_div) <= 0  Then
	MessageBox(is_title, "Please choose a Div Code!")
	Return
End If

ld_sdate = DateTime(dw_query.GetItemDate(1,"s_date"), lt_stime)
ld_edate = DateTime(dw_query.GetItemDate(1,"e_date"), lt_etime)

ll_dd = DaysAfter(date(ld_sdate),date(ld_edate))


if ll_dd > 6 then 
	MessageBox(is_title, "Ship Date range should not more than 7 Days")
	return
end if

ll_cnt = dw_report.Retrieve(ls_whcode,ls_div,ld_sdate, ld_edate)

ll_cnt = dw_report.Rowcount()

If ll_cnt < 1 Then
	MessageBox(is_title, "No record found!")
	im_menu.m_file.m_print.Enabled = False
	Return
else
	im_menu.m_file.m_print.Enabled = True
End If
end event

type dw_report from w_nike_report_ancestor`dw_report within w_nike_replenishment_report
integer x = 32
integer y = 148
integer width = 3653
integer height = 1736
string dataobject = "d_nike_replenishment_report"
end type

type dw_query from w_nike_report_ancestor`dw_query within w_nike_replenishment_report
integer width = 2757
integer height = 120
string dataobject = "d_nike_replenishment_report_search"
end type

type cb_retreive from commandbutton within w_nike_replenishment_report
integer x = 2821
integer y = 28
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;parent.triggerevent("ue_retrieve")
end event

type cb_excel from commandbutton within w_nike_replenishment_report
integer x = 3186
integer y = 28
integer width = 507
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Export to Excel"
end type

event clicked;String 	ls_whcode,ls_div,filename,lineout[1 to 10]
DateTime	ld_sdate, ld_edate
Time     lt_stime = 00:00:00, lt_etime = 23:59:59
OLEObject xl, xs
Long i, j, k, l, ll_cnt, pos

ll_cnt = dw_report.rowcount()

if ll_cnt <= 0 then
	MessageBox(is_title, "No Data to Export!")
	return
end if

SetPointer(HourGlass!)

ld_sdate = DateTime(dw_query.GetItemDate(1,"s_date"), lt_stime)
ld_edate = DateTime(dw_query.GetItemDate(1,"e_date"), lt_etime)

SetMicroHelp("Opening Excel ...")
filename = gs_syspath + "Reports\Replishment.xls"

xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(filename,0,True)
xs = xl.application.workbooks(1).worksheets(1)

SetMicroHelp("Printing report heading...")

xs.cells(1,1).Value = "Printed on: " + String(Today(),"mm/dd/yyyy hh:mm")
xs.cells(3,1).Value = "( " + String(ld_sdate,"mm/dd/yyyy") + " - " + String(ld_edate,"mm/dd/yyyy") + " )" 

pos = 5

For i = 1 to ll_cnt
	pos += 1 	
	xs.rows(pos).Insert
	SetMicroHelp("Calculating order " + String(i) + " of " + String(ll_cnt))
	lineout[1] = dw_report.GetItemString(i, "div")
	lineout[2] = dw_report.GetItemString(i, "sku")
	lineout[3] = dw_report.GetItemString(i, "location")
	lineout[4] = ""
	lineout[5] = String(dw_report.GetItemNumber(i, "avail_qty"))
	lineout[6] = String(dw_report.GetItemNumber(i, "alloc_qty"))
	lineout[7] = String(dw_report.GetItemDatetime(i, "receipt_date"),'mm/dd/yyyy')
	lineout[8] = dw_report.GetItemString(i, "coo")
	lineout[9] = dw_report.GetItemString(i, "cat_type")
	lineout[10] = dw_report.GetItemString(i, "uom")
	xs.range("a" + String(pos) + ":j" +  String(pos)).Value = lineout
Next	
xs.rows(5).Delete
SetMicroHelp("Complete!")
xl.Visible = True
xl.DisconnectObject()

end event

