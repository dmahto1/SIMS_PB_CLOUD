HA$PBExportHeader$w_comcast_sik_order_detail_report.srw
$PBExportComments$BCR: Window for viewing SIK order detail results
forward
global type w_comcast_sik_order_detail_report from w_std_report
end type
type cb_reroute from commandbutton within w_comcast_sik_order_detail_report
end type
type st_note from statictext within w_comcast_sik_order_detail_report
end type
type cb_select from commandbutton within w_comcast_sik_order_detail_report
end type
type dw_reroute from datawindow within w_comcast_sik_order_detail_report
end type
end forward

global type w_comcast_sik_order_detail_report from w_std_report
integer width = 3410
integer height = 2260
string title = "Comcast SIK Order Detail Report"
cb_reroute cb_reroute
st_note st_note
cb_select cb_select
dw_reroute dw_reroute
end type
global w_comcast_sik_order_detail_report w_comcast_sik_order_detail_report

type variables
Str_Parms	iStrParms
string is_origsql, is_reroute, is_msg




end variables

on w_comcast_sik_order_detail_report.create
int iCurrent
call super::create
this.cb_reroute=create cb_reroute
this.st_note=create st_note
this.cb_select=create cb_select
this.dw_reroute=create dw_reroute
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_reroute
this.Control[iCurrent+2]=this.st_note
this.Control[iCurrent+3]=this.cb_select
this.Control[iCurrent+4]=this.dw_reroute
end on

on w_comcast_sik_order_detail_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_reroute)
destroy(this.st_note)
destroy(this.cb_select)
destroy(this.dw_reroute)
end on

event open;call super::open;is_OrigSql = dw_report.getsqlselect()
is_Reroute = "S"

cb_reroute.Text = "Select for Reroute"
cb_select.Visible = False
cb_clear.Visible = False
end event

event ue_postopen;call super::ue_postopen;DataWindowChild ldwc_warehouse,ldwc_warehouse2
string lsFilter
long llRowPos

dw_select.InsertRow(0)


dw_select.GetChild("wh_code", ldwc_warehouse)

ldwc_warehouse.SetTransObject(sqlca)

//Loading from USer Warehouse datawindow
g.of_set_warehouse_dropdown(ldwc_warehouse)

//Filter out all Comcast warehouses except SIK
lsFilter = "wh_code like ('COM-SIK%')"
ldwc_warehouse.SetFilter(lsFilter)
ldwc_warehouse.Filter()




end event

event ue_retrieve;call super::ue_retrieve;//GWM 031-MAY-2011 Comcast SIK Order Detail Report
Boolean lb_where
String ls_Where, ls_NewSql, ls_string, ls_Order

Long	llRowCount,	&
		llRowPos	

//Initialize		
lb_where = False
ls_Order = "ORDER BY dm.Invoice_no, dm.wh_code,dd.Line_Item_No,csod.priority"

dw_select.accepttext()

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

dw_report.SetRedraw(False)

//If present, tackon the following...

//Warehouse Cd
ls_string = dw_select.GetItemString(1,"wh_code")
If not isNull(ls_string) then
	ls_where += " and dm.wh_code = '" + ls_string + "' "
	lb_where = TRUE
End If

//Order Number
ls_string = dw_select.GetItemString(1,"ord_no")
If not isNull(ls_string) and ls_string <> "" then
	ls_where += " and dm.invoice_no = '" + trim(ls_string) + "' "
	lb_where = TRUE
End If

//Order Status
ls_string = dw_select.GetItemString(1,"ord_status")
If not isNull(ls_string) then
	ls_where += " and dm.ord_status = '" + ls_string + "' "
	lb_where = TRUE
End If

//Current SKU
ls_string = dw_select.GetItemString(1,"current_sku")
If not isNull(ls_string) and ls_string <> "" then
	ls_where += " and dd.sku = '" + ls_string + "' "
	lb_where = TRUE
End If

//Valid SKUs
ls_string = dw_select.GetItemString(1,"valid_skus")
If not isNull(ls_string) and ls_string <> "" then
	ls_where += " and csod.sku = '" + ls_string + "' "
	lb_where = TRUE
End If

//Modify SQL
If 	lb_where = True Then
	ls_NewSql = is_origsql + ls_Where + ls_Order
	dw_report.setsqlselect(ls_Newsql)
Else
	ls_NewSql = is_origsql + ls_Order
	dw_report.setsqlselect(ls_Newsql)
End If

llRowCount = dw_report.Retrieve()
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

event resize;call super::resize;dw_report.Resize(workspacewidth() - 75,workspaceHeight()-400)
end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

dw_report.Reset()

end event

type dw_select from w_std_report`dw_select within w_comcast_sik_order_detail_report
integer width = 4206
integer height = 224
string dataobject = "d_comcast_sik_order_detail_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_comcast_sik_order_detail_report
integer x = 1851
integer y = 252
integer height = 76
integer textsize = -8
integer weight = 700
string text = "&Clear All"
end type

event cb_clear::clicked;call super::clicked;long ll_rows, ll_cnt

ll_rows = parent.dw_report.rowcount()

for ll_cnt = 1 to ll_rows
	parent.dw_report.SetItem(ll_cnt,"c_apply_ind","N")
next

end event

type dw_report from w_std_report`dw_report within w_comcast_sik_order_detail_report
integer x = 18
integer y = 352
integer width = 3301
integer height = 1652
string dataobject = "d_comcast_sik_order_detail_report"
boolean hscrollbar = true
end type

event dw_report::retrieveend;call super::retrieveend;/************************************************************
* Populate OriginalSKU field with ValidSKU where Init_Load_Init = "Y"
************************************************************/
Long	llRowCount,	llRowPos, llReturn, llOrigPos, llInitPos, llOrderRow
String	lsOrderNo, lsPrevOrderNo, lsInit, lsValidSku

llReturn = 0

	This.SetRedraw(false)
	SetPointer(Hourglass!)

llRowCount = This.RowCount()

if llRowCount > 0 then
	lsPrevOrderNo = This.GetItemString(1,"Order")
	llOrigPos = 1
	For llRowPos = 1 to llRowCount
		lsOrderNo = This.GetItemString(llRowPos,"Order")
		if lsOrderNo <> lsPrevOrderNo then
			This.SetItem(llOrigPos,"OriginalSKU",lsValidSku)
			
			// Save order record for reroute
			llOrderRow = dw_reroute.InsertRow(0)
			dw_reroute.SetItem(llOrderRow,"r_order",lsPrevOrderNo)
			dw_reroute.SetItem(llOrderRow,"c_apply_ind","N")
			
			lsPrevOrderNo = lsOrderNo
			llOrigPos = llRowPos
			llReturn = llReturn + 1
		end if
		lsInit = This.GetItemString(llRowPos,"Init")
		if lsInit = "Y" then
			llInitPos = llRowPos
			lsValidSku = This.GetItemString(llRowPos,"ValidSKUs")
		end if
	next
	// Ensure last entry is populated
	if This.GetItemString(llOrigPos,"OriginalSKU") = "" then
		This.SetItem(llOrigPos,"OriginalSKU",lsValidSku)
		
			// Save order record for reroute
			llOrderRow = dw_reroute.InsertRow(0)
			dw_reroute.SetItem(llOrderRow,"r_order",lsPrevOrderNo)
			dw_reroute.SetItem(llOrderRow,"c_apply_ind","N")
	end if
end if

is_msg = string(dw_reroute.RowCount()) + " orders displayed"

st_note.text = is_msg

	This.SetRedraw(True)
	SetPointer(Arrow!)

return llRowCount

end event

type cb_reroute from commandbutton within w_comcast_sik_order_detail_report
boolean visible = false
integer x = 2811
integer y = 252
integer width = 503
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select for Reroute"
end type

event clicked;

iStrParms.datawindow_arg[1] = dw_reroute

OpenWithParm(w_comcast_sik_order_reroute,iStrParms)

iStrParms = Message.PowerObjectParm		
If UpperBound(  iStrParms.Datawindow_arg) > 0 Then
	dw_reroute = iStrParms.Datawindow_arg[1]
End If


end event

type st_note from statictext within w_comcast_sik_order_detail_report
integer x = 37
integer y = 252
integer width = 1463
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_select from commandbutton within w_comcast_sik_order_detail_report
boolean visible = false
integer x = 2331
integer y = 252
integer width = 453
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;long ll_rows, ll_cnt

ll_rows = parent.dw_report.rowcount()

for ll_cnt = 1 to ll_rows
	parent.dw_report.SetItem(ll_cnt,"c_apply_ind","Y")
next

end event

type dw_reroute from datawindow within w_comcast_sik_order_detail_report
boolean visible = false
integer x = 2606
integer y = 844
integer width = 686
integer height = 400
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_comcast_sik_order_reroute"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

