HA$PBExportHeader$w_nike_houskeeping_report.srw
$PBExportComments$Stock Transfer Report
forward
global type w_nike_houskeeping_report from w_std_report
end type
type lb_ordtype from listbox within w_nike_houskeeping_report
end type
end forward

global type w_nike_houskeeping_report from w_std_report
integer width = 3767
integer height = 2044
string title = "Inventory Housekeeping Report"
lb_ordtype lb_ordtype
end type
global w_nike_houskeeping_report w_nike_houskeeping_report

type variables
String	isOrigSQL
end variables

on w_nike_houskeeping_report.create
int iCurrent
call super::create
this.lb_ordtype=create lb_ordtype
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.lb_ordtype
end on

on w_nike_houskeeping_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.lb_ordtype)
end on

event ue_retrieve;String	lsLoc,		&
		lsWhere,		&
		lsSKU,		&
		lsNewSQL,   &
		lsInvType
		
Long llPos

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

lsSKU = trim(dw_select.GetItemString(1, "sku"))
lsLoc = trim(dw_select.GetItemString(1, "location"))
lsInvType	= lb_ordtype.selecteditem()

if IsNull(lsSKU) or lsSKU = '' then 
	lsSKU = "%"
else
	lsSku = lsSku + "%"
end if


if IsNull(lsLoc) or lsLoc = '' then 
	lsLoc = "%"
else
	lsLoc = lsLoc + "%"
end if

if lsSKU = "%" and  lsLoc = "%" then
	
	Messagebox(this.Title, "Must enter sku/material no or location!")
	dw_select.SetColumn("sku")
	dw_select.SetFocus()
	RETURN 

end if

If len(trim(lsInvType)) = 0 Then
	lsInvType = 'All'
	lb_ordtype.SelectItem("All", 0)
End If

Choose Case lsInvType
	case 'All'
		lsInvType = '%'		
	case 'Restricted'
		lsInvType = 'R'
	case 'Stock Return'
		lsInvType = 'S'
	case 'Unrestricted'	
		lsInvType = 'U'
end choose


SetPointer(Arrow!)
If dw_report.Retrieve(gs_project, lsSKU, lsLoc, lsInvType) > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Modify( "style_t.text='"+lsSku+"'")
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If



end event

event resize;dw_report.Resize(workspacewidth() - 65,workspaceHeight()-425)
end event

event ue_clear;
dw_select.Reset()
dw_select.InsertRow(0)



end event

event ue_postopen;call super::ue_postopen;string	lsFilter
DatawindowChild	ldwc

If gs_project = 'WARNER' then 
	dw_report.dataobject = "d_warner_transfer_report"
	dw_report.SetTransObject(SQLCA)
End If

dw_select.GetChild('wh_code', ldwc)
ldwc.SetTransObject(sqlca)

If ldwc.Retrieve() > 0 Then
	//Filter Warehouse dropdown by Current Project
	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
	ldwc.SetFilter(lsFilter)
	ldwc.Filter()
End If

isOrigSQL = dw_report.GetSQlSelect() /*capture original SQL*/
end event

type dw_select from w_std_report`dw_select within w_nike_houskeeping_report
integer x = 114
integer y = 60
integer width = 1577
integer height = 260
string dataobject = "d_nike_inventory_housekeeping_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_nike_houskeeping_report
integer x = 3269
integer y = 0
end type

type dw_report from w_std_report`dw_report within w_nike_houskeeping_report
integer x = 5
integer y = 356
integer width = 3703
integer height = 1448
string dataobject = "d_nike_inventory_housekeeping"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type lb_ordtype from listbox within w_nike_houskeeping_report
integer x = 2025
integer y = 24
integer width = 430
integer height = 300
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"All","Restricted","Stock Return","Unrestricted"}
end type

