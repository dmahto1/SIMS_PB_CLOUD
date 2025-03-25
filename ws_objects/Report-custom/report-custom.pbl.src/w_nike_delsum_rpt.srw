$PBExportHeader$w_nike_delsum_rpt.srw
forward
global type w_nike_delsum_rpt from window
end type
type dw_dt_category from datawindow within w_nike_delsum_rpt
end type
type dw_report from datawindow within w_nike_delsum_rpt
end type
type dw_query from datawindow within w_nike_delsum_rpt
end type
end forward

global type w_nike_delsum_rpt from window
integer x = 823
integer y = 360
integer width = 2336
integer height = 976
boolean titlebar = true
string title = "Delivery Summary Report"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_print ( )
event ue_retrieve ( )
dw_dt_category dw_dt_category
dw_report dw_report
dw_query dw_query
end type
global w_nike_delsum_rpt w_nike_delsum_rpt

type variables
String      is_title, is_org_sql
m_report im_menu
end variables

event ue_print();String ls_whcode, ls_transport, ls_dono, ls_cust_code, ls_cust_name,ls_shipadd
DateTime ld_sdate, ld_edate
OLEObject xl, xs
String filename, ls_ordstatus,ls_invoice,ls_po,ls_dtime,ls_region
Long i, j, ll_cnt, ll_qty, pos, ll_cnt_dt
String dummy,ls_markfor,ls_maddress1

If dw_query.AcceptText() = -1 Then Return

ls_whcode = dw_query.GetItemString(1, "wh_code")

If IsNull(ls_whcode) Then
	MessageBox(is_title, "Please choose a warehouse!")
	dw_query.SetFocus()
	dw_query.SetColumn("wh_code")
	Return
End If

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

//If IsNull(ls_transport) Then
//	 MessageBox(is_title, "Please choose a transporter")
//	 dw_query.SetFocus()
//	 dw_query.SetColumn("transport")
//	 Return
//End If

ld_sdate = dw_query.GetItemDateTime(1, "s_date")
ld_edate = dw_query.GetItemDatetime(1, "e_date")

ll_cnt = dw_report.Retrieve(gs_project, ld_sdate, ld_edate, ls_whcode, ls_transport,ls_region)

If ll_cnt = 0 Then 
	MessageBox(is_title, "No record found!") 
	Return
Elseif ll_cnt < 0 Then 
	Messagebox(is_title,'Pls check. Error to retrieve from the database')  
	Return  
End If 

SetPointer(HourGlass!)

SetMicroHelp("Opening Excel ...")
filename = gs_syspath + "Reports\Delsumm.xls"

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

xs.cells(3,10).Value = String(Today(),"dd mmm yyyy hh:mm")
IF ls_transport <> "%" Then
 xs.cells(3,2).Value = left(ls_transport,len(ls_transport) -1 ) //This is to exclude % on display
END IF 

pos = 5
For i = 1 to ll_cnt
	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
	pos += 1
	xs.rows(pos + 1).Insert
	xs.cells(pos,1).value = string(i)
	xs.cells(pos,2).value = dw_report.getitemstring(i,"cust_name")
	xs.cells(pos,3).value = dw_report.GetItemstring(i, "invoice_no")
//	ls_invoice = dw_report.GetItemstring(i, "invoice")
//	ls_po = dw_report.GetItemstring(i, "po")
//	ls_dtime = dw_report.GetItemstring(i, "d_time")
//	
//	if not Isnull(ls_invoice) and len(trim(ls_invoice))>0 then
//		xs.cells(pos,10).value = ls_invoice
//	end if
//	
//	if not Isnull(ls_po) and len(trim(ls_po))>0 then
//		xs.cells(pos,11).value = ls_po
//	end if
//	
//	if not Isnull(ls_dtime) and len(trim(ls_dtime))>0 then
//		xs.cells(pos,12).value = ls_dtime
//	end if
	
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
			ls_ordstatus = "Hold"
		CASE "V"
			ls_ordstatus = "Void"
		CASE "D"
			ls_ordstatus = "Delivered"
		CASE ELSE
			ls_ordstatus = dw_report.GetitemString(i, "ord_status")
	END CHOOSE
	xs.cells(pos,4).value = ls_ordstatus

	ls_dono = dw_report.GetItemstring(i, "do_no")		
	ll_cnt_dt = dw_dt_category.Retrieve(ls_dono)			
	
	If ll_cnt_dt > 0 Then
		xs.cells(pos,5).value = dw_dt_category.GetitemNumber(1, "division_10_qty")
		xs.cells(pos,6).value = dw_dt_category.GetitemNumber(1, "division_20_qty")
		xs.cells(pos,7).value = dw_dt_category.GetitemNumber(1, "division_30_qty")
		xs.cells(pos,8).value = dw_dt_category.GetitemNumber(1, "division_40_qty")
		xs.cells(pos,9).value = dw_dt_category.GetitemNumber(1, "tot_qty")
	End If
	
	xs.cells(pos,10).value = dw_report.GetItemnumber(i, "ctn_cnt")
	xs.cells(pos,11).value = dw_report.GetItemString(i, "remark")

	ls_shipadd=dw_report.getitemstring(i,"shipadd1") 
   if not Isnull(ls_shipadd) and len(trim(ls_shipadd))>0 then 
		pos += 1 
		xs.rows(pos + 1).Insert 
		xs.cells(pos,2).value=ls_shipadd  
	end if	 
               
	ls_shipadd=dw_report.getitemstring(i,"shipadd2") 
   if not Isnull(ls_shipadd) and len(trim(ls_shipadd))>0 then 
		pos += 1 
		xs.rows(pos + 1).Insert 
		xs.cells(pos,2).value=ls_shipadd  
	end if	

	ls_shipadd=dw_report.getitemstring(i,"shipadd3") 
   if not Isnull(ls_shipadd) and len(trim(ls_shipadd))>0 then 
		pos += 1 
		xs.rows(pos + 1).Insert 
		xs.cells(pos,2).value=ls_shipadd  
	end if	 
 
 // Ver :	EWMS 2.0 090326 Start
 	ls_shipadd=dw_report.getitemstring(i,"shipadd6") 
   if not Isnull(ls_shipadd) and len(trim(ls_shipadd))>0 then 
		pos += 1 
		xs.rows(pos + 1).Insert 
		xs.cells(pos,2).value=ls_shipadd  
	end if	
 // Ver :	EWMS 2.0 090326 End	
	ls_shipadd=dw_report.getitemstring(i,"shipadd4")
   if not Isnull(ls_shipadd) and len(trim(ls_shipadd))>0 then
		pos += 1
		xs.rows(pos + 1).Insert
		xs.cells(pos,2).value=ls_shipadd 
	end if	
	
	ls_markfor = dw_report.Getitemstring(i,"markfor")
	ls_maddress1 = dw_report.Getitemstring(i,"maddress1")
	
	If not Isnull(ls_markfor) and len(trim(ls_markfor)) >0 then
		If not Isnull(ls_maddress1) and len(trim(ls_maddress1)) >0 then
			ls_markfor = ls_markfor + " , " + ls_maddress1
		end if
	xs.cells(pos,12).value = ls_markfor
  end if
	
Next
xs.rows(pos + 1).Delete
xs.rows(pos + 1).Delete
SetMicroHelp("Complete!")

xl.Visible = True
xl.DisconnectObject()

end event

event ue_retrieve;This.Trigger Event ue_print()
end event

on w_nike_delsum_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.dw_dt_category=create dw_dt_category
this.dw_report=create dw_report
this.dw_query=create dw_query
this.Control[]={this.dw_dt_category,&
this.dw_report,&
this.dw_query}
end on

on w_nike_delsum_rpt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_dt_category)
destroy(this.dw_report)
destroy(this.dw_query)
end on

event open;This.Move(0,0)

dw_query.SetTransObject(Sqlca)
dw_report.SetTransObject(Sqlca)
dw_dt_category.SetTransObject(Sqlca)

is_title = This.Title
im_menu = This.Menuid

dw_query.InsertRow(0)
dw_query.SetItem(1, "wh_code", gs_default_wh)
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

type dw_dt_category from datawindow within w_nike_delsum_rpt
boolean visible = false
integer x = 1755
integer y = 120
integer width = 494
integer height = 360
integer taborder = 20
string dataobject = "d_nike_do_detail_category"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_report from datawindow within w_nike_delsum_rpt
boolean visible = false
integer x = 91
integer y = 412
integer width = 809
integer height = 360
integer taborder = 10
string dataobject = "d_nike_delsumm_rpt"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_query from datawindow within w_nike_delsum_rpt
integer x = 293
integer y = 64
integer width = 1678
integer height = 476
integer taborder = 20
string dataobject = "d_nike_delsum_search"
boolean border = false
boolean livescroll = true
end type

