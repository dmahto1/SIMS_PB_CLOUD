$PBExportHeader$w_receive_summary_rpt.srw
forward
global type w_receive_summary_rpt from Window
end type
type dw_query from datawindow within w_receive_summary_rpt
end type
type dw_report from datawindow within w_receive_summary_rpt
end type
type dw_report_d from datawindow within w_receive_summary_rpt
end type
end forward

global type w_receive_summary_rpt from Window
int X=823
int Y=360
int Width=1605
int Height=836
boolean TitleBar=true
string Title="Monthly warehouse handling charge report"
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
dw_report_d dw_report_d
end type
global w_receive_summary_rpt w_receive_summary_rpt

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
String lineout2[1 to 8]
String lineout3[1 to 8]
Long i, ll_cnt, pos ,pos1 ,ll_weight,ll_cbm,ll_ft,ll_ft_total,ll_charge_in,ll_charge_in_total
long ll_van,ll_van_total,ll_sum,ll_sum_total, ll_result,ll_charge_out,ll_charge_out_total
String dummy

If dw_query.AcceptText() = -1 Then Return

ld_sdate = dw_query.GetItemDate(1, "s_date")
ld_edate = RelativeDate(dw_query.GetItemDate(1, "e_date"),1)

ll_cnt = dw_report.Retrieve(gs_project, ld_sdate, ld_edate)

SetPointer(HourGlass!)

SetMicroHelp("Opening Excel ...")
filename = ProfileString(gs_inifile,"ewms","syspath","") + "warehouse handling charge report.xls"

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
xs.cells(3,1).Value = "( " + String(dw_query.GetItemDate(1, "s_date"),"mm/dd/yyyy") + " - " + &
	String(dw_query.GetItemDate(1, "e_date"),"mm/dd/yyyy") + " )" 

 
pos = 5
pos1 = 5
For i = 1 to ll_cnt
	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
	pos += 1  
	if (lineout[1] <> lineout1[1]) and ( not isnull(lineout1[1]) and lineout1[1] <> '') then	
			xs.rows(pos1 + 1).Insert
	end if

	lineout1[1] = lineout[1]
	lineout[1] = dw_report.GetItemString(i, "ro_no")
	ll_cbm = dw_report.GetItemnumber(i, "groupcbm")
	lineout[2] = string(ll_cbm)
	ll_weight = dw_report.GetItemnumber(i, "groupweight")
	lineout[3] = string(ll_weight)
	if ll_cbm * 2 > ll_weight then
		 ll_ft = ll_cbm * 2
		 lineout[4] = string(ll_ft)
	else
		ll_ft = ll_weight
		lineout[4] = string(ll_ft)
	end if
	ll_charge_in = ll_ft * 25
	lineout[5] = string(ll_charge_in)
	if (lineout[1] = lineout1[1]) then continue
	pos1 += 1
	ll_ft_total = ll_ft_total + ll_ft
	ll_charge_in_total = ll_charge_in_total + ll_charge_in
	xs.range("a" + String(pos1) + ":h" +  String(pos1)).Value = lineout
	
Next
	xs.rows(pos1 + 1).Delete
	if dw_report.rowcount() > 0 then
		xs.cells(pos1 + 1,2).value = string(dw_report.GetItemNumber(1,"sumcbm"))
		xs.cells(pos1 + 1,3).value = string(dw_report.GetItemNumber(1,"sumweight"))
		xs.cells(pos1 + 1,4).value = string(ll_ft_total)	
		xs.cells(pos1 + 1,5).value = string(ll_charge_in_total)	
	end if
/////////////////////////////
// handle delivery charge
/////////////////////////////

If dw_query.AcceptText() = -1 Then Return

ld_sdate = dw_query.GetItemDate(1, "s_date")
ld_edate = RelativeDate(dw_query.GetItemDate(1, "e_date"),1)

ll_cnt = dw_report_d.Retrieve(gs_project, ld_sdate, ld_edate)

ll_ft_total = 0
ll_weight = 0
ll_cbm = 0
ll_ft = 0
ll_van = 0
ll_van_total = 0
ll_sum = 0
ll_sum_total = 0
ll_result = 0
i = 0


pos = Pos1 + 3
pos1 = Pos1 + 3
For i = 1 to ll_cnt
	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
	pos += 1  
	if (lineout2[1] <> lineout3[1]) and ( not isnull(lineout3[1]) and lineout3[1] <> '') then	
			xs.rows(pos1 + 1).Insert
	end if

	lineout3[1] = lineout2[1]
	lineout2[1] = dw_report_d.GetItemString(i, "do_no")
	ll_cbm = dw_report_d.GetItemnumber(i, "groupcbm")
	lineout2[2] = string(ll_cbm)
	ll_weight = dw_report_d.GetItemnumber(i, "groupweight")
	lineout2[3] = string(ll_weight)
	if ll_cbm * 2 > ll_weight then
		 ll_ft = ll_cbm * 2
		 lineout2[4] = string(ll_ft)
	else
		ll_ft = ll_weight
		lineout2[4] = string(ll_ft)
	end if
	ll_charge_out = ll_ft * 25
	ll_van = ll_ft * 15
	ll_sum = ll_charge_out + ll_van
	lineout2[5] = string(ll_charge_out)
	lineout2[6] = string(ll_van)
	lineout2[7] = string(ll_sum)
	if (lineout2[1] = lineout3[1]) then continue
	pos1 += 1
	ll_ft_total = ll_ft_total + ll_ft
	ll_charge_out_total = ll_charge_out_total + ll_charge_out
	ll_van_total = ll_van_total + ll_van
	ll_sum_total = ll_sum_total + ll_sum
	xs.range("a" + String(pos1) + ":h" +  String(pos1)).Value = lineout2
	
Next
	xs.rows(pos1 + 1).Delete
	if dw_report_d.rowcount() > 0 then
		xs.cells(pos1 + 1,2).value = string(dw_report_d.GetItemNumber(1,"sumcbm"))
		xs.cells(pos1 + 1,3).value = string(dw_report_d.GetItemNumber(1,"sumweight"))
		xs.cells(pos1 + 1,4).value = string(ll_ft_total)	
		xs.cells(pos1 + 1,5).value = string(ll_charge_out_total)
		xs.cells(pos1 + 1,6).value = string(ll_van_total)
		xs.cells(pos1 + 1,7).value = string(ll_sum_total)
	end if
	ll_result = ll_charge_in_total + ll_sum_total + 30000
	xs.cells(pos1 + 6,7).value = string(ll_result)
SetMicroHelp("Complete!")
xl.Visible = True
xl.DisconnectObject()





end event

event ue_retrieve;This.Trigger Event ue_print()
end event

on w_receive_summary_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.dw_query=create dw_query
this.dw_report=create dw_report
this.dw_report_d=create dw_report_d
this.Control[]={this.dw_query,&
this.dw_report,&
this.dw_report_d}
end on

on w_receive_summary_rpt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_query)
destroy(this.dw_report)
destroy(this.dw_report_d)
end on

event open;This.Move(0,0)

dw_query.SetTransObject(Sqlca)
dw_report.SetTransObject(Sqlca)
dw_report_d.SetTransObject(Sqlca)

is_title = This.Title
main_menu= This.Menuid

dw_query.InsertRow(0)
dw_query.SetItem(1,"s_date",Today())
dw_query.SetItem(1,"e_date",Today())

main_menu.m_file.m_print.Enabled = True

//
////%%%%DGM 8/9/00 just put it in function
//f_menu_update(this)
////%%%%
end event

type dw_query from datawindow within w_receive_summary_rpt
int X=73
int Y=140
int Width=1330
int Height=148
int TabOrder=10
string DataObject="d_receive_summary_search"
boolean Border=false
boolean LiveScroll=true
end type

type dw_report from datawindow within w_receive_summary_rpt
int X=18
int Y=36
int Width=270
int Height=332
boolean Visible=false
string DataObject="d_receive_summary"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_report_d from datawindow within w_receive_summary_rpt
int X=786
int Y=40
int Width=398
int Height=324
int TabOrder=20
boolean Visible=false
string DataObject="d_delivery_summary"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

