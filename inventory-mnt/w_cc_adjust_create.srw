HA$PBExportHeader$w_cc_adjust_create.srw
forward
global type w_cc_adjust_create from window
end type
type cb_cancel from commandbutton within w_cc_adjust_create
end type
type cb_generate from commandbutton within w_cc_adjust_create
end type
type dw_create_adjust from datawindow within w_cc_adjust_create
end type
end forward

global type w_cc_adjust_create from window
integer width = 3666
integer height = 1384
boolean titlebar = true
string title = "Create Adjustment"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
cb_generate cb_generate
dw_create_adjust dw_create_adjust
end type
global w_cc_adjust_create w_cc_adjust_create

on w_cc_adjust_create.create
this.cb_cancel=create cb_cancel
this.cb_generate=create cb_generate
this.dw_create_adjust=create dw_create_adjust
this.Control[]={this.cb_cancel,&
this.cb_generate,&
this.dw_create_adjust}
end on

on w_cc_adjust_create.destroy
destroy(this.cb_cancel)
destroy(this.cb_generate)
destroy(this.dw_create_adjust)
end on

event open;
integer li_idx
//dw_create_adjust

//MEA - Added per Dave - 06/23/2010

if Upper(gs_project) = 'PANDORA' then
	this.title = 'Cycle Count Reasons'
	cb_generate.text = "&OK"
	
end if

w_cc.idw_si.ShareData(dw_create_adjust)

dw_create_adjust.SetFilter("difference <> 0") 
dw_create_adjust.Filter()

for li_idx = 1 to dw_create_adjust.RowCount()
	
	dw_create_adjust.SetItem( li_idx, "generate_adjustment", 1)
	
next


datawindowchild ldwc

dw_create_adjust.GetChild("reason",ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_project,'IA')



dw_create_adjust.SetFocus()
dw_create_adjust.SetColumn("reason")
end event

type cb_cancel from commandbutton within w_cc_adjust_create
integer x = 1792
integer y = 1140
integer width = 411
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;
CloseWithReturn(parent, -1)
end event

type cb_generate from commandbutton within w_cc_adjust_create
integer x = 1029
integer y = 1140
integer width = 562
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Create Adjustment"
boolean default = true
end type

event clicked;
integer li_idx
string ls_remark

dw_create_adjust.AcceptText()

for li_idx = 1 to dw_create_adjust.RowCount()

	//PANDORA
	//MEA - 06/23/2010 - See Dave
	
	if Upper(gs_project) = 'PANDORA'  and dw_create_adjust.GetItemNumber( li_idx, "difference") < 0 then

		ls_remark = dw_create_adjust.GetItemString( li_idx, "reason")

		if IsNull(ls_remark) OR trim(ls_remark) = "" then
			
			MessageBox ("Reason Required", "Must enter reason for Cycle Count.")
			
			dw_create_adjust.SetRow(li_idx)
			dw_create_adjust.ScrollToRow(li_idx)
			dw_create_adjust.SetColumn("reason")
			
			RETURN -1
			
		end if
			
		
	end if
	
	
	if dw_create_adjust.GetItemNumber( li_idx, "generate_adjustment") = 1 then
		
		ls_remark = dw_create_adjust.GetItemString( li_idx, "reason")

		if IsNull(ls_remark) OR trim(ls_remark) = "" then
			
			MessageBox ("Reason Required", "Must enter reason for adjustment.")
			
			dw_create_adjust.SetRow(li_idx)
			dw_create_adjust.ScrollToRow(li_idx)
			dw_create_adjust.SetColumn("reason")
			
			RETURN -1
			
		end if
		
	end if
	
next


CloseWithReturn(parent, 1)
end event

type dw_create_adjust from datawindow within w_cc_adjust_create
integer x = 37
integer y = 44
integer width = 3589
integer height = 1020
integer taborder = 10
string title = "none"
string dataobject = "d_cc_adjustment"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

