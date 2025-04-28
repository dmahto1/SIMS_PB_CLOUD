HA$PBExportHeader$w_pandora_proforma_rpt.srw
$PBExportComments$Delivery Report
forward
global type w_pandora_proforma_rpt from w_std_report
end type
type sle_order from singlelineedit within w_pandora_proforma_rpt
end type
type st_1 from statictext within w_pandora_proforma_rpt
end type
type cb_print from commandbutton within w_pandora_proforma_rpt
end type
end forward

global type w_pandora_proforma_rpt from w_std_report
integer width = 3506
integer height = 2268
string title = "Proforma Invoice"
sle_order sle_order
st_1 st_1
cb_print cb_print
end type
global w_pandora_proforma_rpt w_pandora_proforma_rpt

type variables
String isOrigSql
Datastore ids_packing_carton

end variables

event ue_retrieve;call super::ue_retrieve;//Jxlim 12/01/2011 BRD #346 Pandora Proforma Invoice Report
String  ls_order, ls_dono

If dw_select.AcceptText() = -1 Then Return

//Traking Order
ls_order = sle_order.Text

SetPointer(HourGlass!)
dw_report.Reset()
dw_report.setredraw(False)

		If  ls_order <> '' then
			ls_order = Trim(ls_order)
				
			Select  do_no into :ls_dono 
			From   delivery_master
			Where delivery_master.Project_id = :gs_project
			And	 delivery_master.invoice_no = :ls_order 
			Using   SQLCA;
			
			dw_report.Retrieve(ls_dono)
		End If
		
dw_report.setredraw(True)

If dw_report.RowCount() < 1 Then
	messagebox(is_title,"No record found!")
	im_menu.m_file.m_print.Enabled = False
	cb_print.enabled = False
Else 
	im_menu.m_file.m_print.Enabled = True
	cb_print.enabled= True
End If
end event

event ue_postopen;call super::ue_postopen;//Jxlim 08/30/2010
dw_report.Resize(workspacewidth() - 40,workspaceHeight()-200)
end event

event resize;call super::resize;//Jxlim 08/30/2010
dw_report.Resize(workspacewidth() - 30,workspaceHeight()-270)
end event

on w_pandora_proforma_rpt.create
int iCurrent
call super::create
this.sle_order=create sle_order
this.st_1=create st_1
this.cb_print=create cb_print
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_order
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_print
end on

on w_pandora_proforma_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_order)
destroy(this.st_1)
destroy(this.cb_print)
end on

event open;call super::open;isOrigSql = dw_report.getsqlselect()
end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

type dw_select from w_std_report`dw_select within w_pandora_proforma_rpt
boolean visible = false
integer x = 64
integer y = 1728
integer width = 3209
integer height = 136
integer taborder = 0
boolean enabled = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_pandora_proforma_rpt
integer x = 2761
integer y = 1736
integer taborder = 0
end type

type dw_report from w_std_report`dw_report within w_pandora_proforma_rpt
string tag = "Proforma Invoice"
integer x = 46
integer y = 176
integer width = 3401
integer height = 1804
integer taborder = 0
string title = "Proforma Invoice"
string dataobject = "d_pandora_proforma_invoice"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type sle_order from singlelineedit within w_pandora_proforma_rpt
integer x = 453
integer y = 40
integer width = 805
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

event modified;Parent.TriggerEvent('ue_retrieve')
end event

type st_1 from statictext within w_pandora_proforma_rpt
integer x = 105
integer y = 52
integer width = 338
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
string text = "Order Nbr:"
boolean focusrectangle = false
end type

type cb_print from commandbutton within w_pandora_proforma_rpt
integer x = 1518
integer y = 32
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Print"
end type

event clicked;//Jxlim 12/13/2011 Adding print button BRD #346
Parent.TriggerEvent("ue_print")
end event

