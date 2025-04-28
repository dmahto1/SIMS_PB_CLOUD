HA$PBExportHeader$w_nike_delivery_summary_rpt.srw
forward
global type w_nike_delivery_summary_rpt from window
end type
type cbx_all from checkbox within w_nike_delivery_summary_rpt
end type
type dw_dispatch from datawindow within w_nike_delivery_summary_rpt
end type
type dw_query from datawindow within w_nike_delivery_summary_rpt
end type
end forward

global type w_nike_delivery_summary_rpt from window
integer x = 823
integer y = 364
integer width = 1797
integer height = 1056
boolean titlebar = true
string title = "Dispatch Summary Report"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
event ue_print ( )
event ue_retrieve ( )
cbx_all cbx_all
dw_dispatch dw_dispatch
dw_query dw_query
end type
global w_nike_delivery_summary_rpt w_nike_delivery_summary_rpt

type variables
String      is_title, is_org_sql
m_report im_menu

end variables

event ue_print();String ls_whcode,ls_customer,ls_invoiceno,ls_prev_dono,ls_temp
Boolean lb_write_flag
DateTime ld_sdate, ld_edate
//Datastore ds_report
OLEObject xl, xs
String filename
String lineout[1 to 12]
Long i, j, ll_cnt, ll_qty, pos
String dummy,ls_region, ls_do_no, ls_ordstatus


If dw_query.AcceptText() = -1 Then Return

ls_whcode 	= dw_query.GetItemString(1, "wh_code")
ls_customer =  dw_query.GetItemString(1, "customer")
ls_region 	= dw_query.GetItemString(1,"ship_ref")

If IsNull(ls_region) or ls_region="" then
	ls_region ='%'
else
	ls_region = ls_region+"%"
end if

If IsNull(ls_whcode) Then
	MessageBox(is_title, "Please choose a warehouse!")
	Return
End If

if isnull(ls_Customer) and cbx_all.checked = false then
	MessageBox(is_title, "Please enter ship to Id")
	Return
End If

//if cbx_all.checked = true then
//	ds_report = create datastore
//	ds_report.dataobject = 'd_delivery_discrepancy_all'    
//	ds_report.settransobject(sqlca)
//else
//	ds_report = create datastore                       
//	ds_report.dataobject = 'd_delivery_discrepancy_select'    
//	ds_report.settransobject(sqlca)
//end if

ld_sdate = DateTime(dw_query.GetItemDate(1, "s_date"), Time("00:00"))
ld_edate = DateTime(RelativeDate(dw_query.GetItemDate(1, "e_date"),1), Time("00:00"))

//ds_report.reset()
//if cbx_all.checked = true then
//	ll_cnt = ds_report.Retrieve(ld_sdate, ld_edate, ls_whcode)
//else 
//	ll_cnt = ds_report.Retrieve(ld_sdate, ld_edate, ls_whcode, ls_customer)
//end if

SetPointer(HourGlass!)	

SetMicroHelp("Opening Excel ...")	
filename =   gs_syspath + "Reports\DispRpt.xls"	
	
If Not fileexists(filename) Then 	
	Messagebox('EWMS','Dispatch report template file ' + filename + ' not available. Pls check')  	
	Return 
End if		
	
xl = CREATE OLEObject	
xs = CREATE OLEObject	
xl.ConnectToNewObject("Excel.Application")		
xl.Workbooks.Open(filename,0,True)		
xs = xl.application.workbooks(1).worksheets(1)		
		
SetMicroHelp("Printing report heading...")	
	
xs.cells(1,1).Value = "Printed on: " + String(Today(),"mm/dd/yyyy hh:mm") 
xs.cells(3,1).Value = "( " + String(dw_query.GetItemDate(1, "s_date")) + " - " + String(dw_query.GetItemDate(1, "e_date")) + " )"             
	
	
If cbx_all.checked = true then
	ll_cnt=dw_dispatch.Retrieve(gs_project, ls_whcode,ld_sdate,ld_edate,'%',ls_region)
Else	
	ls_customer = ls_customer+"%"
  ll_cnt=dw_dispatch.Retrieve(gs_project, ls_whcode,ld_sdate,ld_edate,ls_customer,ls_region)
END IF

If ll_cnt = 0 Then 	
	MessageBox(is_title, "No record found!")	
	Return	
End If	

pos = 5

ls_invoiceno 			= dw_dispatch.GetItemString(1, "invoice_no")
ls_prev_dono 	= ls_invoiceno

For i = 1 to ll_cnt
	
	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
	
	pos += 1 
	If i + 2 <= ll_cnt Then xs.rows(pos + 1).Insert
	 
	ls_invoiceno = dw_dispatch.GetItemString(i, "invoice_no")
	
	if i=1 then lb_write_flag = True
	If i<>1 Then
		if ls_invoiceno = ls_prev_dono Then
			lb_write_flag = FALSE
		elseif ls_invoiceno<> ls_prev_dono then
			lb_write_flag = TRUE
			ls_prev_dono = ls_invoiceno
		END IF
	END IF	
			
  
	lineout[1] = ls_invoiceno
	lineout[2] = String(dw_dispatch.GetItemDateTime(i, "ord_date"), "mm/dd/yy hh:mm")  
	lineout[3] = String(dw_dispatch.GetItemDateTime(i, "complete_date"), "mm/dd/yy hh:mm") 
	lineout[4] = String(dw_dispatch.GetItemDateTime(i, "crd"), "mm/dd/yy hh:mm") 
	lineout[5] = String(dw_dispatch.GetItemDateTime(i, "GID"), "mm/dd/yy hh:mm") 
	lineout[6] = dw_dispatch.GetItemString(i, "ship_to_name")  
	// lineout[7] = String(dw_dispatch.GetItemDateTime(i, "eta_date"), "mm/dd/yy hh:mm") 
	lineout[7] = dw_dispatch.GetItemString(i, "ship_cost") //,"####") 	
	lineout[8] = dw_dispatch.GetItemString(i, "Transporter") 

	lineout[9] = dw_dispatch.GetItemString(i, "Delivery_no")   //ls_invoiceno//

	xs.range("a" + String(pos) + ":i" +  String(pos)).Value = lineout
	xs.cells(pos,10).value=String(dw_dispatch.GetItemstring(i, "csalesorder"))
	xs.cells(pos,11).value=String(dw_dispatch.GetItemstring(i, "ship_ref"))
	
	If lb_write_flag then 
   	xs.cells(pos,12).value=dw_dispatch.GetItemNumber(i, "ctn_cnt")
   End if  
	
	if Not IsNull( dw_dispatch.GetItemNumber(i, "req_qty")) then xs.cells(pos,13).value=String(dw_dispatch.GetItemNumber(i, "req_qty"))
	if Not IsNull( dw_dispatch.GetItemNumber(i, "qty")) then xs.cells(pos,14).value=String(dw_dispatch.GetItemNumber(i, "qty"))
	xs.cells(pos,15).value=String(dw_dispatch.GetItemString(i, "remark"))
	
	
		
	CHOOSE CASE  dw_dispatch.GetItemString(i,"ord_status")
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
			ls_ordstatus = "Hold"
		CASE "V"
			ls_ordstatus = "Void"
		CASE "D"
			ls_ordstatus = "Delivered"
		CASE ELSE
			ls_ordstatus =  dw_dispatch.GetItemString(i,"ord_status")
	END CHOOSE
	
	xs.cells(pos,16).value=ls_ordstatus

Next



SetMicroHelp("Complete!")
xl.Visible = True
xl.DisconnectObject()
							
//destroy ds_report	
	

end event

event ue_retrieve;This.Trigger Event ue_print()
end event

on w_nike_delivery_summary_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.cbx_all=create cbx_all
this.dw_dispatch=create dw_dispatch
this.dw_query=create dw_query
this.Control[]={this.cbx_all,&
this.dw_dispatch,&
this.dw_query}
end on

on w_nike_delivery_summary_rpt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_all)
destroy(this.dw_dispatch)
destroy(this.dw_query)
end on

event open;This.Move(0,0)

dw_query.SetTransObject(Sqlca)
//dw_report.SetTransObject(Sqlca)
dw_dispatch.SetTransObject(Sqlca)

is_title = This.Title
im_menu = This.Menuid

dw_query.InsertRow(0)
dw_query.SetItem(1,"wh_code",gs_default_wh)
dw_query.SetItem(1,"s_date",Today())
dw_query.SetItem(1,"e_date",Today())

im_menu.m_file.m_print.Enabled = True

// Loading from USer Warehouse Datastore 
DataWindowChild ldwc_warehouse,ldwc_warehouse2

dw_query.GetChild("wh_code", ldwc_warehouse)

ldwc_warehouse.SetTransObject(sqlca)

g.of_set_warehouse_dropdown(ldwc_warehouse)

dw_query.SetITem(1,'wh_code',gs_default_WH)

end event

type cbx_all from checkbox within w_nike_delivery_summary_rpt
integer x = 590
integer y = 620
integer width = 539
integer height = 76
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "All customers"
end type

type dw_dispatch from datawindow within w_nike_delivery_summary_rpt
boolean visible = false
integer x = 1623
integer y = 12
integer width = 494
integer height = 364
integer taborder = 10
string dataobject = "d_nike_dispatch_delivery_ppl"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_query from datawindow within w_nike_delivery_summary_rpt
integer x = 261
integer y = 124
integer width = 1394
integer height = 460
integer taborder = 20
string dataobject = "d_nike_delivery_summary_search"
boolean border = false
boolean livescroll = true
end type

