HA$PBExportHeader$w_nike_rcv_dly_sku.srw
forward
global type w_nike_rcv_dly_sku from w_nike_report_ancestor
end type
type gb_1 from groupbox within w_nike_rcv_dly_sku
end type
type rb_receive from radiobutton within w_nike_rcv_dly_sku
end type
type rb_delivery from radiobutton within w_nike_rcv_dly_sku
end type
type cbx_detail from checkbox within w_nike_rcv_dly_sku
end type
type dw_report_dt from datawindow within w_nike_rcv_dly_sku
end type
type lb_ordtype from listbox within w_nike_rcv_dly_sku
end type
type st_ordtype from statictext within w_nike_rcv_dly_sku
end type
end forward

global type w_nike_rcv_dly_sku from w_nike_report_ancestor
integer width = 3177
integer height = 1236
string title = "Inbound and Outbound Report for SKU"
gb_1 gb_1
rb_receive rb_receive
rb_delivery rb_delivery
cbx_detail cbx_detail
dw_report_dt dw_report_dt
lb_ordtype lb_ordtype
st_ordtype st_ordtype
end type
global w_nike_rcv_dly_sku w_nike_rcv_dly_sku

event open;call super::open;DateTime ld_sdate, ld_edate
Time     lt_stime, lt_etime
String ls_sdate

//lt_stime = 00:00:00
//lt_etime = 23:59:59
//ld_sdate = DateTime(RelativeDate(Today(), -30), lt_stime)
//ld_edate = DateTime(Today(), lt_etime)

dw_query.InsertRow(0)
dw_query.SetItem(1, "wh_code", gs_default_wh)
dw_query.SetItem(1,"s_date", today())
dw_query.SetItem(1,"e_date", today())
lb_ordtype.visible 		= true
rb_Receive.checked 		= true
st_ordtype.visible 		= true
lb_ordtype.selectitem(1)

// Loading from USer Warehouse Datastore 
DataWindowChild ldwc_warehouse,ldwc_warehouse2

dw_query.GetChild("wh_code", ldwc_warehouse)

ldwc_warehouse.SetTransObject(sqlca)

g.of_set_warehouse_dropdown(ldwc_warehouse)

dw_query.SetITem(1,'wh_code',gs_default_WH)


end event

on w_nike_rcv_dly_sku.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_receive=create rb_receive
this.rb_delivery=create rb_delivery
this.cbx_detail=create cbx_detail
this.dw_report_dt=create dw_report_dt
this.lb_ordtype=create lb_ordtype
this.st_ordtype=create st_ordtype
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_receive
this.Control[iCurrent+3]=this.rb_delivery
this.Control[iCurrent+4]=this.cbx_detail
this.Control[iCurrent+5]=this.dw_report_dt
this.Control[iCurrent+6]=this.lb_ordtype
this.Control[iCurrent+7]=this.st_ordtype
end on

on w_nike_rcv_dly_sku.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_receive)
destroy(this.rb_delivery)
destroy(this.cbx_detail)
destroy(this.dw_report_dt)
destroy(this.lb_ordtype)
destroy(this.st_ordtype)
end on

event ue_retrieve;DateTime 	ld_sdate, ld_edate
Long 			pos,ll_rowcnt,i, j, ll_row, ll_item, ll_qty, ll_tot_qty, col
String 		ls_sku, ls_wh_code,filename,lineout[1 to 7],ls_ordType
OLEObject 	xl, xs

SetPointer(HourGlass!)

If dw_query.AcceptText() = -1 Then Return

dw_report.Reset()

ls_wh_code 	= dw_query.GetItemString(1, "wh_code")
ld_sdate 	= dw_query.GetItemDateTime(1,"s_date")
ld_edate 	= dw_query.GetItemDateTime(1,"e_date")
ls_ordType	= lb_ordtype.selecteditem()

If isNull(ls_wh_code) Then 
	MessageBox(is_title, "Please choose a warehouse first!")
	Return
End If

If len(trim(ls_ordType)) = 0 Then
	Messagebox("FormD", "Please select the Order Type")
	Return
End If

Choose Case ls_ordType
	case 'All'
		ls_OrdType = '%'		
	case 'Supplier Order'
		ls_OrdType = 'S'
	case 'Goods Return'
		ls_OrdType = 'X'
	case 'Others'	
		ls_OrdType = 'O'
end choose


If cbx_detail.Checked = False Then
	
	if rb_Receive.checked=true then
		dw_report.DataObject = 'd_nike_receive_sku'
		dw_report.SetTransObject(Sqlca)
		ll_rowcnt  = dw_report.Retrieve(gs_project, ls_wh_code, ld_sdate, ld_edate,ls_ordtype)		
	end if	
	if rb_delivery.checked=true then
		dw_report.DataObject = 'd_nike_delivery_sku'
		dw_report.SetTransObject(Sqlca)
		ll_rowcnt  = dw_report.Retrieve(gs_project, ls_wh_code, ld_sdate, ld_edate)
	end if

	IF ll_rowcnt > 0 THEN
		im_menu.m_file.m_print.Enabled = True
	ELSE
		MessageBox(is_title, "No record found!")
		im_menu.m_file.m_print.Enabled = False
	END IF
Else

	SetMicroHelp("Retrieving data, please wait...")

	if rb_Receive.checked=true then
		dw_report_dt.DataObject = 'd_nike_receivedt_sku'
		dw_report_dt.SetTransObject(Sqlca)
		ll_rowcnt  = dw_report_dt.Retrieve(gs_project, ls_wh_code, ld_sdate, ld_edate,ls_ordtype)
	end if	
	
	if rb_delivery.checked=true then
		dw_report_dt.DataObject = 'd_nike_deliverydt_sku'
		dw_report_dt.SetTransObject(Sqlca)
		ll_rowcnt  = dw_report_dt.Retrieve(gs_project, ls_wh_code, ld_sdate, ld_edate)
	end if

	If ll_rowcnt < 1 Then 
		MessageBox(is_title, "No record found!")
		Return
	End If
	
	ll_rowcnt = dw_report_dt.RowCount()
	SetPointer(HourGlass!)

	SetMicroHelp("Opening Excel ...")
	filename = gs_syspath + "Reports\rcv_dly.xls"

	If not fileexists(filename) Then
		Messagebox('EWMS','The template file ' + filename + ' not found. pls check')
		Return
	End If	

	xl = CREATE OLEObject
	xs = CREATE OLEObject
	xl.ConnectToNewObject("Excel.Application")
	xl.Workbooks.Open(filename,0,True)
	xs = xl.application.workbooks(1).worksheets(1) 
	 
	SetMicroHelp("Printing report heading...") 
	if rb_Receive.checked=true then
		xs.cells(1,1).value = 'Inbound Report'
	end if	
	if rb_delivery.checked=true then
		xs.cells(1,1).value = 'Outbound Report'
	end if

	xs.cells(2,1).Value = "( " + String(dw_query.GetItemDateTime(1, "s_date")) + " - " + String(dw_query.GetItemDateTime(1, "e_date")) + " )" 
	xs.cells(3,5).Value = String(Today(),"mm/dd/yyyy hh:mm")
	
	ll_row = 6
	
	For i = 1 to ll_rowcnt
	
		SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_rowcnt))
		
		ls_sku = dw_report_dt.GetItemString(i, "sku") 
		ll_qty = dw_report_dt.GetItemNumber(i,"alloc_qty") 
		If ll_qty = 0 Then Continue 
		ll_row += 1
		xs.rows(ll_row+1).insert
		xs.cells(ll_row,1).value = dw_report_dt.GetItemdatetime(i, "complete_date")
		xs.cells(ll_row,2).value = dw_report_dt.GetItemString(i, "order_no")
		xs.cells(ll_row,3).value = dw_report_dt.GetItemString(i, "sku")
		xs.cells(ll_row,4).value = dw_report_dt.GetItemString(i, "grp")
		xs.cells(ll_row,5).value = dw_report_dt.GetItemnumber(i, "alloc_qty")
	Next
	
	SetMicroHelp("Complete!")
	xl.Visible = True
	xl.DisconnectObject()
	destroy xl
	destroy xs
End If
end event

type dw_report from w_nike_report_ancestor`dw_report within w_nike_rcv_dly_sku
integer x = 37
integer y = 400
integer width = 3077
integer height = 612
string dataobject = "d_nike_receive_sku"
end type

type dw_query from w_nike_report_ancestor`dw_query within w_nike_rcv_dly_sku
integer x = 27
integer y = 84
integer width = 1637
integer height = 220
string dataobject = "d_nike_completedate_search"
end type

type gb_1 from groupbox within w_nike_rcv_dly_sku
integer x = 1733
integer y = 20
integer width = 517
integer height = 360
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report Type  "
end type

type rb_receive from radiobutton within w_nike_rcv_dly_sku
integer x = 1810
integer y = 128
integer width = 375
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inbound"
boolean lefttext = true
end type

event clicked;dw_report.DataObject = 'd_nike_receive_sku'
dw_report.SetTransObject(Sqlca)
lb_ordtype.visible = true
st_ordtype.visible = true

end event

type rb_delivery from radiobutton within w_nike_rcv_dly_sku
integer x = 1810
integer y = 256
integer width = 375
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Outbound"
boolean lefttext = true
end type

event clicked;dw_report.DataObject = 'd_nike_delivery_sku'
dw_report.SetTransObject(Sqlca)
lb_ordtype.visible = false
st_ordtype.visible = false

end event

type cbx_detail from checkbox within w_nike_rcv_dly_sku
integer x = 2263
integer y = 300
integer width = 251
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "Detail"
boolean lefttext = true
end type

type dw_report_dt from datawindow within w_nike_rcv_dly_sku
boolean visible = false
integer x = 498
integer y = 316
integer width = 494
integer height = 360
integer taborder = 30
boolean bringtotop = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type lb_ordtype from listbox within w_nike_rcv_dly_sku
integer x = 2624
integer y = 32
integer width = 430
integer height = 212
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"All","Supplier Order","Goods Return"}
end type

type st_ordtype from statictext within w_nike_rcv_dly_sku
integer x = 2263
integer y = 44
integer width = 343
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Order Type :"
boolean focusrectangle = false
end type

