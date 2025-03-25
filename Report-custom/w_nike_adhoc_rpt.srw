HA$PBExportHeader$w_nike_adhoc_rpt.srw
forward
global type w_nike_adhoc_rpt from window
end type
type dw_invquery from datawindow within w_nike_adhoc_rpt
end type
type dw_report from datawindow within w_nike_adhoc_rpt
end type
end forward

global type w_nike_adhoc_rpt from window
integer x = 78
integer y = 48
integer width = 4197
integer height = 2120
boolean titlebar = true
string title = "Month end GI and GR Aging Report"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 81324524
event ue_print ( )
event ue_retrieve ( )
dw_invquery dw_invquery
dw_report dw_report
end type
global w_nike_adhoc_rpt w_nike_adhoc_rpt

type variables
String      is_title, is_org_sql
m_report im_menu
end variables

event ue_print();long ll_cnt

ll_cnt = dw_report.rowcount()

If ll_cnt < 1 then

MessageBox(is_title, "Nothing to print!")
Return
	
End If

OpenWithParm(w_dw_print_options,dw_report)

/*
String ls_whcode, ls_transport, ls_dono, ls_cust_code, ls_cust_name,ls_shipadd
Date ld_sdate, ld_edate
OLEObject xl, xs
String filename, ls_ordstatus,ls_invoice,ls_po,ls_dtime,ls_region
Long i, j, ll_cnt, ll_qty, pos, ll_cnt_dt
String dummy,ls_markfor,ls_maddress1

ld_sdate = date(em_1.text)
ld_edate = date(em_2.text)

ll_cnt = dw_report.Retrieve(ld_sdate, ld_edate, ls_whcode, ls_transport,ls_region)

If ll_cnt = 0 Then 
	MessageBox(is_title, "No record found!") 
	Return
Elseif ll_cnt < 0 Then 
	Messagebox(is_title,'Pls check. Error to retrieve from the database')  
	Return  
End If 

SetPointer(HourGlass!)

SetMicroHelp("Opening Excel ...")
filename = gs_syspath + "adhoc.xls"

If not fileexists(filename) then
	Messagebox("EWMS","The excel template file " + filename + " not found. Pls check")
	Return
End If	

xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(filename,0,True)
xs = xl.application.workbooks(1).worksheets(1)

SetMicroHelp("Printing report heading...")

xs.cells(3,1).Value = "From Date " + em_1.text + " to " + em_2.text

pos = 5

For i = 1 to ll_cnt
	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
	pos += 1
	xs.rows(pos + 1).Insert
	xs.cells(pos,1).value = dw_report.getitemstring(i,"division")
	xs.cells(pos,2).value = dw_report.getitemstring(i,"sku")
	xs.cells(pos,3).value = dw_report.GetItemstring(i, "description")
	xs.cells(pos,4).value = dw_report.GetItemNumber(i, "quantity")
	xs.cells(pos,5).value = String(dw_report.GetItemDatetime(i, "last_receipt_date"),'DD/MM/YYYY')
	xs.cells(pos,6).value = String(dw_report.GetItemDatetime(i, "last_gi_date"),'DD/MM/YYYY')
	xs.cells(pos,7).value = dw_report.GetItemstring(i, "category")
Next

xs.rows(pos + 1).Delete
xs.rows(pos + 1).Delete
SetMicroHelp("Complete!")

xl.Visible = True
xl.DisconnectObject()
*/
end event

event ue_retrieve();long ll_cnt
String ls_inv_type

ls_inv_type = dw_invquery.GetItemString(1, "invtype")

If isNull(ls_inv_type) Then 
	MessageBox(is_title, "Please choose a inventory  type first!")
	Return
End If

SetPointer(Hourglass!)

ll_cnt = dw_report.retrieve(gs_project, ls_inv_type)

If ll_cnt < 1 then

MessageBox(is_title, "No record found!")
Return
	
End If


end event

on w_nike_adhoc_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.dw_invquery=create dw_invquery
this.dw_report=create dw_report
this.Control[]={this.dw_invquery,&
this.dw_report}
end on

on w_nike_adhoc_rpt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_invquery)
destroy(this.dw_report)
end on

event open;This.Move(0,0)


dw_report.SetTransObject(Sqlca)

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

type dw_invquery from datawindow within w_nike_adhoc_rpt
integer width = 1111
integer height = 132
integer taborder = 10
string dataobject = "d_nike_invquery"
boolean border = false
boolean livescroll = true
end type

type dw_report from datawindow within w_nike_adhoc_rpt
integer x = 18
integer y = 172
integer width = 4123
integer height = 1700
integer taborder = 20
string dataobject = "d_nike_adhoc2"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

