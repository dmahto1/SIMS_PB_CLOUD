$PBExportHeader$w_nike_delivery_pack_disc_rpt.srw
forward
global type w_nike_delivery_pack_disc_rpt from window
end type
type dw_report from datawindow within w_nike_delivery_pack_disc_rpt
end type
type st_3 from statictext within w_nike_delivery_pack_disc_rpt
end type
type sle_order from singlelineedit within w_nike_delivery_pack_disc_rpt
end type
end forward

global type w_nike_delivery_pack_disc_rpt from window
integer x = 5
integer y = 48
integer width = 3758
integer height = 2064
boolean titlebar = true
string title = "Pack Discrepancy Report"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_print ( )
event ue_retrieve ( )
dw_report dw_report
st_3 st_3
sle_order sle_order
end type
global w_nike_delivery_pack_disc_rpt w_nike_delivery_pack_disc_rpt

type variables
String      is_title, is_org_sql
m_report im_menu
end variables

event ue_print;IF dw_report.RowCount() > 0 THEN
	OpenwithParm(w_dw_print_options,dw_report) 
ELSE
	MessageBox(is_title,"No record to print",Exclamation!,Ok!,1)
	Return
END IF
end event

event ue_retrieve();String temp_no,ls_dn
Long i, row_cnt1, j, row_cnt2,ll_cnt
String ls_sku

dw_report.Reset()
//dw_pack.Reset()
dw_report.SetFilter("")


temp_no = Trim(sle_order.Text)
row_cnt1 = dw_report.Retrieve(gs_project, temp_no)
//row_cnt2 = dw_pack.Retrieve(temp_no)

If row_cnt1 > 0 Then
//	row_cnt2 = dw_pack.Retrieve(temp_no)
Else
	MessageBox(is_title, "Delivery order not found, please enter again!", Exclamation!)
	sle_order.SetFocus()
	sle_order.SelectText(1,Len(temp_no))
End If

	
//For i = 1 to row_cnt1
//	ls_sku = dw_report.GetItemString(i,"delivery_detail_sku")
//	ls_dn = ''
//	ll_cnt = 0
//	For j = 1 to row_cnt2
//		if dw_pack.GetItemString(j,"sku") = ls_sku then
//			ll_cnt++
//			if ll_cnt = 1 then
//				ls_dn = dw_pack.GetItemString(j,"delivery_no")
//			elseif ll_cnt > 1 then
//				ls_dn = ls_dn + ',' + dw_pack.GetItemString(j,"delivery_no")
//			end if
//		end if
//	Next
//	dw_report.SetItem(i, "cdel_no",ls_dn)
//Next

dw_report.SetFilter("pack_diff <> 0")
dw_report.Filter()
end event

on w_nike_delivery_pack_disc_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.dw_report=create dw_report
this.st_3=create st_3
this.sle_order=create sle_order
this.Control[]={this.dw_report,&
this.st_3,&
this.sle_order}
end on

on w_nike_delivery_pack_disc_rpt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
destroy(this.st_3)
destroy(this.sle_order)
end on

event open;This.Move(0,0)

dw_report.SetTransObject(Sqlca)
//dw_pack.SetTransObject(Sqlca)

//dw_pack.SetSort("SKU A")

is_title = This.Title
im_menu = This.Menuid

im_menu.m_file.m_print.Enabled = True


end event

type dw_report from datawindow within w_nike_delivery_pack_disc_rpt
integer x = 64
integer y = 136
integer width = 3634
integer height = 1720
integer taborder = 20
string dataobject = "d_nike_delivery_pack_discrepancy_rpt"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_nike_delivery_pack_disc_rpt
integer x = 27
integer y = 44
integer width = 320
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Order No.:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_order from singlelineedit within w_nike_delivery_pack_disc_rpt
integer x = 366
integer y = 28
integer width = 727
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

