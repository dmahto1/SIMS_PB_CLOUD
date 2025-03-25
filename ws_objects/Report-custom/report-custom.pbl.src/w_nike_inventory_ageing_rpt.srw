$PBExportHeader$w_nike_inventory_ageing_rpt.srw
forward
global type w_nike_inventory_ageing_rpt from window
end type
type dw_invquery from datawindow within w_nike_inventory_ageing_rpt
end type
type dw_ageing from datawindow within w_nike_inventory_ageing_rpt
end type
end forward

global type w_nike_inventory_ageing_rpt from window
integer x = 846
integer y = 372
integer width = 3648
integer height = 1820
boolean titlebar = true
string title = "Inventory Ageing Report"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 80269524
event ue_retrieve ( )
event ue_print ( )
dw_invquery dw_invquery
dw_ageing dw_ageing
end type
global w_nike_inventory_ageing_rpt w_nike_inventory_ageing_rpt

type variables
String      is_title
m_report im_menu
end variables

event ue_retrieve();long ll_cnt
String ls_inv_type

ls_inv_type = dw_invquery.GetItemString(1, "invtype")
//Check inventory type entry
If isNull(ls_inv_type) Then 
	MessageBox(is_title, "Please choose a inventory  type first!")
	Return
End If

ll_cnt = dw_ageing.retrieve(gs_project, ls_inv_type)

If ll_cnt < 1 then

MessageBox(is_title, "No record found!")
Return
	
End If


end event

event ue_print;long ll_cnt

ll_cnt = dw_ageing.rowcount()

If ll_cnt < 1 then

MessageBox(is_title, "Nothing to print!")
Return
	
End If


OpenWithParm(w_dw_print_options,dw_ageing)
end event

on w_nike_inventory_ageing_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.dw_invquery=create dw_invquery
this.dw_ageing=create dw_ageing
this.Control[]={this.dw_invquery,&
this.dw_ageing}
end on

on w_nike_inventory_ageing_rpt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_invquery)
destroy(this.dw_ageing)
end on

event open;This.Move(0,0)


dw_ageing.SetTransObject(Sqlca)

//is_title = This.Title
im_menu = This.Menuid

im_menu.m_file.m_print.Enabled = True

dw_invquery.settransobject(sqlca)
dw_invquery.insertrow(0)

// Loading Inventory Dropdown
DataWindowChild ldwc_inv_type

dw_invquery.GetChild("invtype", ldwc_inv_type)

ldwc_inv_type.SetTransObject(sqlca)

ldwc_inv_type.Retrieve(gs_project)


end event

type dw_invquery from datawindow within w_nike_inventory_ageing_rpt
integer x = 59
integer y = 24
integer width = 1038
integer height = 140
integer taborder = 10
string dataobject = "d_nike_invquery"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_ageing from datawindow within w_nike_inventory_ageing_rpt
integer x = 50
integer y = 188
integer width = 3506
integer height = 1432
integer taborder = 10
string dataobject = "d_nike_inventory_ageing_rpt"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

