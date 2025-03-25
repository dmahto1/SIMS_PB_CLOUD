$PBExportHeader$w_nike_manifest_rpt.srw
forward
global type w_nike_manifest_rpt from window
end type
type cbx_all from checkbox within w_nike_manifest_rpt
end type
type dw_dispatch from datawindow within w_nike_manifest_rpt
end type
type dw_query from datawindow within w_nike_manifest_rpt
end type
end forward

global type w_nike_manifest_rpt from window
integer x = 823
integer y = 364
integer width = 1819
integer height = 804
boolean titlebar = true
string title = "Manifest"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 81324524
event ue_print ( )
event ue_retrieve ( )
cbx_all cbx_all
dw_dispatch dw_dispatch
dw_query dw_query
end type
global w_nike_manifest_rpt w_nike_manifest_rpt

type variables
String      is_title, is_org_sql
m_report im_menu

end variables

event ue_print();String ls_whcode,ls_customer,ls_dono,ls_prev_dono,ls_temp
Boolean lb_write_flag
DateTime ld_sdate, ld_edate
Long llwarehouseRow
string lsCity, lsState, ls_Zip, lsCounty

OLEObject xl, xs
String filename
String lineout[1 to 12]
Long i, j, ll_cnt, ll_qty, pos
String dummy,ls_region

If dw_query.AcceptText() = -1 Then Return

ls_whcode 	=  dw_query.GetItemString(1,"wh_code")
ls_customer =  dw_query.GetItemString(1,"customer")
ls_region 	=  dw_query.GetItemString(1,"ship_ref")

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

ld_sdate = DateTime(dw_query.GetItemDate(1, "s_date"), Time("00:00"))
ld_edate = DateTime(RelativeDate(dw_query.GetItemDate(1, "e_date"),1), Time("00:00"))

SetPointer(HourGlass!)	

SetMicroHelp("Opening Excel ...")	
filename = gs_syspath + "Reports\Manifest.xls"	
	
If Not fileexists(filename) Then 	
	Messagebox('EWMS','Manifest report template file ' + filename + ' not available. Pls check')  	
	Return 
End if		
	
xl = CREATE OLEObject	
xs = CREATE OLEObject	
xl.ConnectToNewObject("Excel.Application")		
xl.Workbooks.Open(filename,0,True)		
xs = xl.application.workbooks(1).worksheets(1)		
		
SetMicroHelp("Printing report heading...")	
	
xs.cells(1,5).Value = "Printed on: " + String(Today(),"mm/dd/yyyy hh:mm") 
xs.cells(3,5).Value = "Dispatch Date " + String(dw_query.GetItemDate(1, "s_date")) + " - " + String(dw_query.GetItemDate(1, "e_date"))

llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(ls_whcode) + "'",1,g.ids_project_warehouse.rowCount())

if llwarehouseRow > 0 then

	xs.cells(1,2).Value =	g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name')
	xs.cells(2,2).Value =	g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1')
	xs.cells(3,2).Value =	g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2')
	xs.cells(4,2).Value =	g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3')
	xs.cells(5,2).Value =	g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4')

	lsCity = g.ids_project_warehouse.GetITemString(llWarehouseRow,'city')
	lsState = g.ids_project_warehouse.GetITemString(llWarehouseRow,'state')
	lsCounty = g.ids_project_warehouse.GetITemString(llWarehouseRow,'country')
	ls_Zip = g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip')
	
	If IsNull(lsCity) then lsCity = ''
	If IsNull(lsState) then lsState = ''
	If IsNull(lsCounty) then lsCounty = ''
	If IsNull(ls_Zip) then ls_Zip = ''
		
	xs.cells(6,2).Value =	lsCity + ", " + lsState + ", " + ls_Zip + ", " + lsCounty
	
	
	
end if	
	
	
	
//If cbx_all.checked = true then
	ll_cnt=dw_dispatch.Retrieve(gs_project, ls_whcode,ld_sdate,ld_edate,ls_region)
//Else	
//	ls_customer = ls_customer+"%"
//  ll_cnt=dw_dispatch.Retrieve(gs_project, ls_whcode,ld_sdate,ld_edate,ls_customer,ls_region)
//END IF

If ll_cnt = 0 Then 	
	MessageBox(is_title, "No record found!")	
	Return	
End If	

//xs.cells(17,2).value = String(ll_cnt)

pos = 18

ls_dono 			= dw_dispatch.GetItemString(1, "do_no")
ls_prev_dono 	= ls_dono
string l1
long l2



For i = 1 to ll_cnt
	
	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
	
	pos += 1 
	If i + 2 <= ll_cnt Then xs.rows(pos + 1).Insert
	 
	ls_dono = dw_dispatch.GetItemString(i, "do_no")
	
	if i=1 then lb_write_flag = True
	If i<>1 Then
		if ls_dono = ls_prev_dono Then
			lb_write_flag = FALSE
		elseif ls_dono<> ls_prev_dono then
			lb_write_flag = TRUE
			ls_prev_dono = ls_dono
		END IF
	END IF	
	lineout[1] = String(i)
	lineout[2] = dw_dispatch.GetItemString(i, "invoice_no")
	lineout[3] = dw_dispatch.GetItemString(i, "ship_to_name")

	xs.range("a" + String(pos) + ":i" +  String(pos)).Value = lineout
	
	l1 = dw_dispatch.GetItemString(i, "ship_ref")
	xs.cells(pos,4).value = l1
	l2 = dw_dispatch.GetItemNumber(i, "ctn_cnt")
  	xs.cells(pos,5).value=l2
	xs.cells(pos,7).value=dw_dispatch.GetItemString(i, "remark")
	xs.cells(pos,8).value=dw_dispatch.GetItemString(i, "ord_status")
	
Next

SetMicroHelp("Complete!")
xl.Visible = True
xl.DisconnectObject()

destroy xl
end event

event ue_retrieve;This.Trigger Event ue_print()
end event

on w_nike_manifest_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.cbx_all=create cbx_all
this.dw_dispatch=create dw_dispatch
this.dw_query=create dw_query
this.Control[]={this.cbx_all,&
this.dw_dispatch,&
this.dw_query}
end on

on w_nike_manifest_rpt.destroy
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

type cbx_all from checkbox within w_nike_manifest_rpt
boolean visible = false
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
boolean checked = true
end type

type dw_dispatch from datawindow within w_nike_manifest_rpt
boolean visible = false
integer x = 1550
integer y = 12
integer width = 567
integer height = 364
integer taborder = 10
string dataobject = "d_nike_manifest_rpt"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_query from datawindow within w_nike_manifest_rpt
integer x = 261
integer y = 124
integer width = 1417
integer height = 396
integer taborder = 20
string dataobject = "d_nike_mainfest_search"
boolean border = false
boolean livescroll = true
end type

