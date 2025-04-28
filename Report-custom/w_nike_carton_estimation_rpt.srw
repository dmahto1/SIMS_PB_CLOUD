HA$PBExportHeader$w_nike_carton_estimation_rpt.srw
forward
global type w_nike_carton_estimation_rpt from window
end type
type dw_dt_category_newstatus from datawindow within w_nike_carton_estimation_rpt
end type
type dw_report_detail2 from datawindow within w_nike_carton_estimation_rpt
end type
type st_1 from statictext within w_nike_carton_estimation_rpt
end type
type ddlb_status from dropdownlistbox within w_nike_carton_estimation_rpt
end type
type dw_dt_category from datawindow within w_nike_carton_estimation_rpt
end type
type dw_report from datawindow within w_nike_carton_estimation_rpt
end type
type dw_query from datawindow within w_nike_carton_estimation_rpt
end type
end forward

global type w_nike_carton_estimation_rpt from window
integer x = 823
integer y = 360
integer width = 2153
integer height = 952
boolean titlebar = true
string title = "Carton Estimation Report"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 81324524
event ue_print ( )
event ue_retrieve ( )
dw_dt_category_newstatus dw_dt_category_newstatus
dw_report_detail2 dw_report_detail2
st_1 st_1
ddlb_status ddlb_status
dw_dt_category dw_dt_category
dw_report dw_report
dw_query dw_query
end type
global w_nike_carton_estimation_rpt w_nike_carton_estimation_rpt

type variables
String      is_title, is_org_sql
m_report im_menu
end variables

event ue_print();String ls_whcode, ls_transport, ls_dono, ls_status,ls_region,filename, ls_ordstatus
DateTime ld_sdate, ld_edate

OLEObject xl, xs
Long i, j, ll_cnt, ll_qty, pos, ll_cnt_dt,ll

If dw_query.AcceptText() = -1 Then Return

ls_whcode = dw_query.GetItemString(1, "wh_code")

If IsNull(ls_whcode) Then
	MessageBox(is_title, "Please choose a warehouse!")
	dw_query.SetFocus()
	dw_query.SetColumn("wh_code")
	Return
End If

Choose case ddlb_status.text
       case 'ALL'
			 ls_status='ALL'
		 case  'New'
			 ls_status = 'N'
		 case	'Process'
			 ls_status = 'P'
		 case	'Picking'
			 ls_status = 'I'
		 case	 'Packing'
			  ls_status = 'A'
End Choose			  

If ls_status = 'ALL' then
	ls_status = "%"
ELse
	ls_status = ls_status + "%"
End if	

ls_transport = dw_query.GetItemString(1, "transport")
ls_region = dw_query.GetItemString(1, "region") 

If isnull(ls_transport) or ls_transport = '' Then
	ls_transport = "%"
Else
	ls_transport = ls_transport + '%'
End if

If isnull(ls_region) or ls_region = '' Then
	ls_region = "%"
Else
	ls_region = ls_region + '%'
End if

ld_sdate = dw_query.GetItemDateTime(1, "s_date")
ld_edate = dw_query.GetItemDatetime(1, "e_date")

ll_cnt = dw_report.Retrieve(gs_project, ld_sdate, ld_edate, ls_whcode, ls_transport,ls_region,ls_status)

If ll_cnt = 0 Then 
	MessageBox(is_title, "No record found!") 
	Return
Elseif ll_cnt < 0 Then 
	Messagebox(is_title,'Pls check. Error to retrieve from the database')  
	Return  
End If 

SetPointer(HourGlass!)

SetMicroHelp("Opening Excel ...")
filename = gs_syspath + "Reports\ContEstimate.xls"

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

xs.cells(3,2).Value = String(ld_sdate,'mm/dd/yyyy')  + " - " + String(ld_edate,'mm/dd/yyyy')

pos = 5

For i = 1 to ll_cnt
	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
	pos += 1
	xs.rows(pos + 1).Insert
	xs.cells(pos,1).value = string(i)
	xs.cells(pos,2).value = dw_report.getitemstring(i,"cust_name")
	xs.cells(pos,3).value = dw_report.GetItemstring(i, "invoice_no")
	
	CHOOSE CASE dw_report.GetitemString(i, "ord_status")
		CASE "N"
			ls_ordstatus = "New"
		CASE "P"
			ls_ordstatus = "Process"
		CASE "I"
			ls_ordstatus = "Picking"
		CASE "A"
			ls_ordstatus = "Packing"
		CASE "C"
			ls_ordstatus = "Complete"
		CASE "H"
			ls_ordstatus = "Stop"
		CASE ELSE
			ls_ordstatus = dw_report.GetitemString(i, "ord_status")
	END CHOOSE
	xs.cells(pos,4).value = ls_ordstatus
	ls_dono 		= dw_report.GetItemstring(i, "do_no")		

	if ls_ordstatus = "New" then
			ll_cnt_dt = dw_dt_category_newstatus.Retrieve(ls_dono)			
			If ll_cnt_dt > 0 Then
				xs.cells(pos,5).value = dw_dt_category_newstatus.GetitemNumber(1, "division_10_qty")
				xs.cells(pos,6).value = dw_dt_category_newstatus.GetitemNumber(1, "division_20_qty")
				xs.cells(pos,7).value = dw_dt_category_newstatus.GetitemNumber(1, "division_30_qty")
				xs.cells(pos,8).value = dw_dt_category_newstatus.GetitemNumber(1, "tot_qty")
			end if
	else
		ll_cnt_dt 	= dw_dt_category.Retrieve(ls_dono)			
		If ll_cnt_dt > 0 Then
			xs.cells(pos,5).value = dw_dt_category.GetitemNumber(1, "division_10_qty")
			xs.cells(pos,6).value = dw_dt_category.GetitemNumber(1, "division_20_qty")
			xs.cells(pos,7).value = dw_dt_category.GetitemNumber(1, "division_30_qty")
			xs.cells(pos,8).value = dw_dt_category.GetitemNumber(1, "tot_qty")
		end If
	end if	
	
	if ls_ordstatus = "Complete" then
		ll_cnt_dt = dw_report_detail2.Retrieve(ls_dono)			
		If ll_cnt_dt > 0 Then
			xs.cells(pos,9).value  = dw_report_detail2.GetitemNumber(1, "division_10_qty")
			xs.cells(pos,10).value = dw_report_detail2.GetitemNumber(1, "division_20_qty")
			xs.cells(pos,11).value = dw_report_detail2.GetitemNumber(1, "division_30_qty")
		end if
	else
		xs.cells(pos,09).value = '=IF(D' + string(pos) + '="Complete",E' + string(pos) + ',E' + string(pos) + '/$I$4)'
		xs.cells(pos,10).value = '=IF(D' + string(pos) + '="Complete",F' + string(pos) + ',F' + string(pos) + '/$J$4)'
		xs.cells(pos,11).value = '=IF(D' + string(pos) + '="Complete",G' + string(pos) + ',G' + string(pos) + '/$K$4)'
	end if
	xs.cells(pos,12).value = '=SUM(I' + string(pos) + ':K' + string(pos) + ')'
	xs.cells(pos,13).value = dw_report.GetItemString(i, "remark")
Next
xs.rows(pos + 1).Delete
xs.rows(pos + 1).Delete
SetMicroHelp("Complete!")

xl.Visible = True
xl.DisconnectObject()

end event

event ue_retrieve;This.Trigger Event ue_print()
end event

on w_nike_carton_estimation_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.dw_dt_category_newstatus=create dw_dt_category_newstatus
this.dw_report_detail2=create dw_report_detail2
this.st_1=create st_1
this.ddlb_status=create ddlb_status
this.dw_dt_category=create dw_dt_category
this.dw_report=create dw_report
this.dw_query=create dw_query
this.Control[]={this.dw_dt_category_newstatus,&
this.dw_report_detail2,&
this.st_1,&
this.ddlb_status,&
this.dw_dt_category,&
this.dw_report,&
this.dw_query}
end on

on w_nike_carton_estimation_rpt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_dt_category_newstatus)
destroy(this.dw_report_detail2)
destroy(this.st_1)
destroy(this.ddlb_status)
destroy(this.dw_dt_category)
destroy(this.dw_report)
destroy(this.dw_query)
end on

event open;This.Move(0,0)

dw_query.SetTransObject(Sqlca)
dw_report.SetTransObject(Sqlca)
dw_dt_category.SetTransObject(Sqlca)
dw_report_detail2.SetTransObject(Sqlca)
dw_dt_category_newstatus.SetTransObject(Sqlca)

is_title = This.Title
im_menu = This.Menuid

dw_query.InsertRow(0)
dw_query.SetItem(1, "wh_code", gs_default_wh)
dw_query.SetItem(1,"s_date",Today())
dw_query.SetItem(1,"e_date",Today())

im_menu.m_file.m_print.Enabled = True
ddlb_status.text='All'

// Loading from USer Warehouse Datastore 
DataWindowChild ldwc_warehouse,ldwc_warehouse2

dw_query.GetChild("wh_code", ldwc_warehouse)

ldwc_warehouse.SetTransObject(sqlca)

g.of_set_warehouse_dropdown(ldwc_warehouse)

dw_query.SetITem(1,'wh_code',gs_default_WH)

end event

type dw_dt_category_newstatus from datawindow within w_nike_carton_estimation_rpt
boolean visible = false
integer x = 2345
integer y = 836
integer width = 1349
integer height = 360
integer taborder = 20
string dataobject = "d_nike_carton_estimation_qty_newstatus"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_report_detail2 from datawindow within w_nike_carton_estimation_rpt
boolean visible = false
integer x = 2313
integer y = 1224
integer width = 1399
integer height = 360
integer taborder = 30
string dataobject = "d_nike_carton_estimation_rpt_detail"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_nike_carton_estimation_rpt
integer x = 411
integer y = 568
integer width = 229
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Status"
boolean focusrectangle = false
end type

type ddlb_status from dropdownlistbox within w_nike_carton_estimation_rpt
integer x = 677
integer y = 556
integer width = 535
integer height = 416
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = true
boolean hscrollbar = true
boolean vscrollbar = true
string item[] = {"All","New","Process","Picking","Packing"}
borderstyle borderstyle = stylelowered!
end type

type dw_dt_category from datawindow within w_nike_carton_estimation_rpt
boolean visible = false
integer x = 2377
integer y = 460
integer width = 1134
integer height = 360
integer taborder = 60
string dataobject = "d_nike_carton_estimation_qty_detail"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_report from datawindow within w_nike_carton_estimation_rpt
boolean visible = false
integer x = 2400
integer y = 52
integer width = 1029
integer height = 360
integer taborder = 50
string dataobject = "d_nike_carton_estimation_rpt"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_query from datawindow within w_nike_carton_estimation_rpt
integer x = 293
integer y = 64
integer width = 1678
integer height = 476
integer taborder = 10
string dataobject = "d_nike_delsum_search"
boolean border = false
boolean livescroll = true
end type

