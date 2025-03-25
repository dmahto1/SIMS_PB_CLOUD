$PBExportHeader$w_phxbrands_shipment_mtd.srw
$PBExportComments$Allocation Report
forward
global type w_phxbrands_shipment_mtd from w_std_report
end type
end forward

global type w_phxbrands_shipment_mtd from w_std_report
integer width = 3730
integer height = 2244
string title = "Shipment Month To Date Report"
end type
global w_phxbrands_shipment_mtd w_phxbrands_shipment_mtd

type variables
String	isOrigSql

String is_where = ""
end variables

on w_phxbrands_shipment_mtd.create
call super::create
end on

on w_phxbrands_shipment_mtd.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;

isOrigSql = dw_report.getsqlselect()





end event

event ue_retrieve;
SetPointer(Hourglass!)




// uf_process_shipments_mtd
//Process the PHXBRANDS Shipment MTD Report File


long llRowCount


isOrigSql = dw_report.getsqlselect()


date ldt_search_date

dw_select.AcceptText()

ldt_search_date = date(dw_select.GetItemDateTime(1, "month_date"))


llRowCount  = dw_report.Retrieve(Month(ldt_search_date), Year(ldt_search_date))

If llRowCount > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If


SetPointer(Arrow!)
//
end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-380)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)


dw_select.SetItem(1, "month_date", date(today))



end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc, ldwc2
String	lsFilter


dw_select.SetItem(1, "month_date", date(today))





end event

event ue_sort;call super::ue_sort;//dw_Report.GroupCalc()
Return 0
end event

type dw_select from w_std_report`dw_select within w_phxbrands_shipment_mtd
integer x = 14
integer y = 4
integer width = 3351
integer height = 292
string dataobject = "d_shipment_mtd_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;
If g.is_owner_ind <> 'Y' Then
	This.modify("allow_alt_owner_ind.visible=False")
End If
end event

type cb_clear from w_std_report`cb_clear within w_phxbrands_shipment_mtd
integer x = 3154
integer y = 20
integer width = 55
integer height = 64
end type

type dw_report from w_std_report`dw_report within w_phxbrands_shipment_mtd
integer x = 14
integer y = 336
integer width = 3625
integer height = 1672
integer taborder = 30
string dataobject = "d_phxbrands_mtd_shipments"
boolean hscrollbar = true
end type

event dw_report::sqlpreview;call super::sqlpreview;integer li_pos
string lsNewSQL
	

if is_Where <> "" then


	
	li_pos = Pos (sqlsyntax, "GROUP")
	
	lsNewSQL = Left(sqlsyntax, (li_pos -1)) + is_Where +" " +  Mid( sqlsyntax, li_Pos )

	this.SetSQLPreview( lsNewSQL)

end if


end event

