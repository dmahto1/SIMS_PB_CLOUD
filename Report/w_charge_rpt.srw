HA$PBExportHeader$w_charge_rpt.srw
$PBExportComments$Monthly warehouse handling charge report
forward
global type w_charge_rpt from Window
end type
type dw_query from datawindow within w_charge_rpt
end type
type dw_report from datawindow within w_charge_rpt
end type
end forward

global type w_charge_rpt from Window
int X=823
int Y=360
int Width=1787
int Height=1040
boolean TitleBar=true
string Title="Receive Summary Report"
string MenuName="m_report"
long BackColor=79741120
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
event ue_print ( )
event ue_retrieve ( )
dw_query dw_query
dw_report dw_report
end type
global w_charge_rpt w_charge_rpt

type variables
String      is_title, is_org_sql
m_report im_menu
end variables

event ue_print;String ls_whcode,ls_itype,ls_type
Date ld_sdate, ld_edate
OLEObject xl, xs
String filename
String lineout[1 to 8]
String lineout1[1 to 8]
Long i, ll_cnt, pos ,pos1 
String dummy

If dw_query.AcceptText() = -1 Then Return

ls_whcode = dw_query.GetItemString(1, "wh_code")

If IsNull(ls_whcode) Then
	MessageBox(is_title, "Please choose a warehouse!")
	Return
End If

ld_sdate = dw_query.GetItemDate(1, "s_date")
ld_edate = RelativeDate(dw_query.GetItemDate(1, "e_date"),1)

ll_cnt = dw_report.Retrieve(ls_whcode, ld_sdate, ld_edate)

If ll_cnt < 1 Then 
	MessageBox(is_title, "No record found!")
	Return
End If


SetPointer(HourGlass!)

SetMicroHelp("Opening Excel ...")
filename = ProfileString(gs_inifile,"ewms","syspath","") + "ShipRpt.xls"

If not fileexists(filename) Then
	MessageBox(is_title, "File " + filename + " not found!")
	Return
End If

xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(filename,0,True)
xs = xl.application.workbooks(1).worksheets(1)

SetMicroHelp("Printing report heading...")

xs.cells(1,1).Value = "Printed on: " + String(Today(),"mm/dd/yyyy hh:mm")
xs.cells(3,1).Value = "( " + String(dw_query.GetItemDate(1, "s_date")) + " - " + &
	String(dw_query.GetItemDate(1, "e_date")) + " )" 

 
pos = 5
pos1 = 5
For i = 1 to ll_cnt
	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
	pos += 1  
	if (lineout[1] <> lineout1[1]) and ( not isnull(lineout1[1]) and lineout1[1] <> '') then	
			xs.rows(pos1 + 1).Insert
	end if

	lineout1[1] = lineout[1]
	lineout[1] = dw_report.GetItemString(i, "do_no")
	lineout[2] = String(dw_report.GetItemDateTime(i, "ord_date"), "mm/dd/yyyy hh:mm")
	lineout[3] = String(dw_report.GetItemDateTime(i, "complete_date"), "mm/dd/yyyy hh:mm")
	ls_itype = dw_report.getitemstring(i,"inventory_type")
	select inv_type_desc into :ls_type from inventory_type
		where inv_type = :ls_itype;
	lineout[4] = ls_type
//	lineout[4] = dw_report.GetItemString(i,"inventory_type")
	lineout[5] = string(dw_report.GetItemnumber(i, "groupcbm"))
	lineout[6] = string(dw_report.GetItemnumber(i, "groupweight"))	
	lineout[7] = string(dw_report.GetItemnumber(i, "groupqty"))	
////	lineout[6] = String(dw_report.GetItemNumber(i, "ctn_cnt"))
////	lineout[7] = String(dw_report.GetItemNumber(i, "qty"))
////	lineout[8] = String(0)0
	if (lineout[1] = lineout1[1]) then continue
	pos1 += 1
	xs.range("a" + String(pos1) + ":h" +  String(pos1)).Value = lineout
	
//	xs.cells(pos,5).value=dw_report.GetItemNumber(i, "cbm")
//	xs.cells(pos,6).value=dw_report.GetItemNumber(i, "weight")
//	xs.cells(pos,7).value=dw_report.GetItemNumber(i, "quantity")
//	xs.cells(pos,8).value=0
Next
	xs.rows(pos1 + 1).Delete
	xs.cells(pos1 + 1,5).value = string(dw_report.GetItemNumber(1,"sumcbm"))
	xs.cells(pos1 + 1,6).value = string(dw_report.GetItemNumber(1,"sumweight"))
	xs.cells(pos1 + 1,7).value = string(dw_report.GetItemNumber(1,"sumqty"))	
SetMicroHelp("Complete!")
xl.Visible = True
xl.DisconnectObject()
end event

event ue_retrieve;This.Trigger Event ue_print()
end event

on w_charge_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.dw_query=create dw_query
this.dw_report=create dw_report
this.Control[]={this.dw_query,&
this.dw_report}
end on

on w_charge_rpt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_query)
destroy(this.dw_report)
end on

event open;This.Move(0,0)

dw_query.SetTransObject(Sqlca)
dw_report.SetTransObject(Sqlca)

is_title = This.Title
im_menu = This.Menuid

dw_query.InsertRow(0)
dw_query.SetItem(1,"s_date",Today())
dw_query.SetItem(1,"e_date",Today())

im_menu.m_file.m_print.Enabled = True

end event

type dw_query from datawindow within w_charge_rpt
int X=169
int Y=200
int Width=1403
int Height=288
int TabOrder=10
string DataObject="d_receive_summary_search"
boolean Border=false
boolean LiveScroll=true
end type

type dw_report from datawindow within w_charge_rpt
int X=18
int Y=96
int Width=699
int Height=600
boolean Visible=false
string DataObject="d_delivery_summary"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

