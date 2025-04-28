$PBExportHeader$w_export.srw
$PBExportComments$Export specific layouts
forward
global type w_export from window
end type
type dw_search from datawindow within w_export
end type
type rb_comma from radiobutton within w_export
end type
type rb_tab from radiobutton within w_export
end type
type cb_export_retrieve from commandbutton within w_export
end type
type cb_export_clearall from commandbutton within w_export
end type
type cb_export_selectall from commandbutton within w_export
end type
type cb_export_help from commandbutton within w_export
end type
type cb_export_ok from commandbutton within w_export
end type
type cb_export_export from commandbutton within w_export
end type
type dw_layout_list from datawindow within w_export
end type
type gb_delimiter from groupbox within w_export
end type
end forward

global type w_export from window
integer x = 823
integer y = 360
integer width = 3360
integer height = 1916
boolean titlebar = true
string title = "export"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
event ue_postopen ( )
event ue_set_dw ( )
event ue_delete ( )
event ue_save ( )
event ue_help ( )
event ue_retrieve ( )
event ue_export ( )
dw_search dw_search
rb_comma rb_comma
rb_tab rb_tab
cb_export_retrieve cb_export_retrieve
cb_export_clearall cb_export_clearall
cb_export_selectall cb_export_selectall
cb_export_help cb_export_help
cb_export_ok cb_export_ok
cb_export_export cb_export_export
dw_layout_list dw_layout_list
gb_delimiter gb_delimiter
end type
global w_export w_export

type variables
u_dw_export	dw_export
Boolean	ibCancel,ibValError,ibChanged
Long	ilCurrValRow, ilHelpTopicID
String	isHelpKeyword

end variables

event ue_postopen();datawindowchild	ldwc
String	lsDelimiter

dw_layout_list.getChild('export_file',ldwc)
dw_layout_list.InsertRow(0)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project, 'EXPRT')

cb_export_selectall.Enabled = False
cb_export_clearall.Enabled = False
cb_export_export.Enabled = False
cb_export_retrieve.Enabled = False

dw_layout_list.Setfocus()

//default delimiter if present
lsDelimiter = ProfileString(gs_inifile,"export","delimit","")

Choose Case Upper(lsDelimiter)
	Case "TAB"
		rb_tab.checked = True
	Case "COMMA"
		rb_comma.checked = True
	Case Else
		rb_tab.checked = True
End Choose
end event

event ue_set_dw();Boolean	lbSearchEnabled
DatawindowChild	ldwc

cb_export_selectall.Enabled = False
cb_export_clearall.Enabled = False
cb_export_export.Enabled = False

rb_tab.Enabled = False
rb_comma.Enabled = FAlse
gb_delimiter.Enabled = False

//save any changes if necessary
If isValid(dw_export) Then
	dw_export.wf_save()
End If

Choose Case dw_layout_list.getItemString(1,'export_file')
		
	Case 'wd-scan-ro' /*western digital scanner - receive order*/
		dw_export = Create u_dw_wd_export_scanner_ro
	Case 'wd-scan-do' /*western digital scanner - delivery order*/
		dw_export = Create u_dw_wd_export_scanner_do
	Case "PRICE_DATA"
		dw_export = Create u_dw_price_export_scanner
		dw_export.dataobject = 'd_export_price_data'
		cb_export_export.enabled = true
	Case "ITEM_DATA"
		dw_export = Create u_dw_item_export_scanner
		dw_export.dataobject = 'd_export_full_itemmaster'
		cb_export_export.enabled = true
//	Case 'hahn-emer' /*HAHN Order Confirmations*/
//		dw_export = Create u_dw_hahn_export_emerinv
//	Case 'hahn-ka44' /*HAHN Order Discrepancies*/
//		dw_export = Create u_dw_hahn_export_emerka44
	Case 'pulse-receive' /* 12/02 - Pconkl - Pulse Receiving Report */
		dw_export = Create u_dw_pulse_export_receiving
		lbSearchEnabled = True
		dw_search.dataobject = 'd_pulse_export_receiving_srch'
		dw_search.GetChild('wh_code',ldwc)
		ldwc.SetTransObject(SQLCA)
		ldwc.Retrieve(gs_project)
	Case 'pulse-receive-me' /* 07/03 - Pconkl - Pulse Receiving Report - Month End */
		dw_export = Create u_dw_pulse_export_receiving_me
		lbSearchEnabled = True
		dw_search.dataobject = 'd_pulse_export_receiving_srch'
		dw_search.GetChild('wh_code',ldwc)
		ldwc.SetTransObject(SQLCA)
		ldwc.Retrieve(gs_project)
	Case 'pulse-tpl' /* 12/02 - Pconkl - Pulse Transportation Packing List Report */
		dw_export = Create u_dw_pulse_export_tpl
		lbSearchEnabled = True
		dw_search.dataobject = 'd_pulse_export_receiving_srch'
	Case 'ADDR_VAL' 		/* 01/31/2012 - GXMOR - Comcast UPS Address Validation log Export */
		dw_export = Create u_dw_comcast_ups_log
		lbSearchEnabled = True
		dw_search.dataobject = 'd_comcast_export_ups_log_srch'
		dw_search.GetChild(gs_project,ldwc)
		ldwc.SetTransObject(SQLCA)
		ldwc.Retrieve(gs_project)
End Choose

//Show search criteria if needed
If lbSearchEnabled Then
	dw_search.Visible = True
	dw_Search.InsertRow(0)
End If

OpenuserObject(dw_export)

dw_export.visible = True
dw_export.Enabled = True
dw_export.x = 0
dw_export.y = 250
dw_export.width = 3287
dw_export.height = 1300

//dw_export.SetTransObject(SQLCA)

cb_export_retrieve.Enabled = True
end event

event ue_retrieve();
//save any changes if necessary
If isValid(dw_export) Then
	dw_export.wf_save()
End If

dw_export.wf_Retrieve()

If dw_export.RowCount() > 0 Then
	cb_export_selectAll.Enabled = True
	cb_export_clearall.Enabled = True
Else
	Messagebox('Export','There no records eligible for exporting.')
End If


end event

event ue_export;
dw_export.wf_export()
end event

on w_export.create
this.dw_search=create dw_search
this.rb_comma=create rb_comma
this.rb_tab=create rb_tab
this.cb_export_retrieve=create cb_export_retrieve
this.cb_export_clearall=create cb_export_clearall
this.cb_export_selectall=create cb_export_selectall
this.cb_export_help=create cb_export_help
this.cb_export_ok=create cb_export_ok
this.cb_export_export=create cb_export_export
this.dw_layout_list=create dw_layout_list
this.gb_delimiter=create gb_delimiter
this.Control[]={this.dw_search,&
this.rb_comma,&
this.rb_tab,&
this.cb_export_retrieve,&
this.cb_export_clearall,&
this.cb_export_selectall,&
this.cb_export_help,&
this.cb_export_ok,&
this.cb_export_export,&
this.dw_layout_list,&
this.gb_delimiter}
end on

on w_export.destroy
destroy(this.dw_search)
destroy(this.rb_comma)
destroy(this.rb_tab)
destroy(this.cb_export_retrieve)
destroy(this.cb_export_clearall)
destroy(this.cb_export_selectall)
destroy(this.cb_export_help)
destroy(this.cb_export_ok)
destroy(this.cb_export_export)
destroy(this.dw_layout_list)
destroy(this.gb_delimiter)
end on

event open;Integer			li_ScreenH, li_ScreenW
Environment	le_Env

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2

dw_search.Visible = False

This.PostEvent("ue_postopen")

end event

event closequery;
Integer	liMsg

If ibCancel or Not(isvalid(dw_export)) Then
	Return 0
End If

//Save changes
if dw_export.wf_save() < 0 Then
	Return 1
Else
	Return 0
End If
end event

type dw_search from datawindow within w_export
integer x = 37
integer y = 116
integer width = 3264
integer height = 132
integer taborder = 160
string title = "none"
boolean livescroll = true
end type

type rb_comma from radiobutton within w_export
integer x = 599
integer y = 1724
integer width = 357
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "C&omma"
end type

event constructor;
g.of_check_label_button(this)
end event

type rb_tab from radiobutton within w_export
integer x = 599
integer y = 1660
integer width = 357
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Tab"
end type

event constructor;
g.of_check_label_button(this)
end event

type cb_export_retrieve from commandbutton within w_export
integer x = 1792
integer y = 1672
integer width = 315
integer height = 108
integer taborder = 140
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;

Parent.TriggerEvent('ue_retrieve')
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_export_clearall from commandbutton within w_export
integer x = 32
integer y = 1704
integer width = 311
integer height = 96
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear All"
end type

event clicked;

Long	llRowPos,	&
		llRowCount

llRowCount = dw_export.RowCount()
For llRowPos = 1 to llRowCount
	dw_export.SetITem(llRowPos,'c_export_ind','N')
Next

cb_export_export.Enabled = False
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_export_selectall from commandbutton within w_export
integer x = 32
integer y = 1596
integer width = 311
integer height = 96
integer taborder = 170
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All"
end type

event clicked;
Long	llRowPos,	&
		llRowCount

llRowCount = dw_export.RowCount()

For llRowPos = 1 to llRowCount
	dw_export.SetITem(llRowPos,'c_export_ind','Y')
Next

If llRowCount > 0 Then
	cb_export_export.Enabled = True
Else
	cb_export_export.enabled = False
End If
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_export_help from commandbutton within w_export
integer x = 2880
integer y = 1672
integer width = 279
integer height = 108
integer taborder = 130
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Help"
end type

event clicked;ShowHelp(g.is_helpfile,topic!,543) /*open by topic ID*/
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_export_ok from commandbutton within w_export
integer x = 2464
integer y = 1672
integer width = 247
integer height = 108
integer taborder = 110
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;
Close(parent)
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_export_export from commandbutton within w_export
integer x = 1266
integer y = 1672
integer width = 315
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Export"
end type

event clicked;parent.triggerEvent("ue_export")
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_layout_list from datawindow within w_export
integer x = 14
integer y = 16
integer width = 1605
integer height = 116
integer taborder = 150
string dataobject = "d_export_layout_list"
boolean border = false
end type

event itemchanged;
Parent.PostEvent("ue_set_dw")
end event

event constructor;
g.of_check_label(this) 
end event

type gb_delimiter from groupbox within w_export
integer x = 535
integer y = 1592
integer width = 480
integer height = 220
integer taborder = 180
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Delimit by"
end type

event constructor;
g.of_check_label_button(this)
end event

