HA$PBExportHeader$w_nike_ppl_accuracy_rpt.srw
forward
global type w_nike_ppl_accuracy_rpt from window
end type
type dw_ppl_exclusion from datawindow within w_nike_ppl_accuracy_rpt
end type
type dw_query from datawindow within w_nike_ppl_accuracy_rpt
end type
type dw_ppl_detail from datawindow within w_nike_ppl_accuracy_rpt
end type
type dw_ppl from datawindow within w_nike_ppl_accuracy_rpt
end type
type dw_detail from datawindow within w_nike_ppl_accuracy_rpt
end type
type dw_report from datawindow within w_nike_ppl_accuracy_rpt
end type
type cb_search from commandbutton within w_nike_ppl_accuracy_rpt
end type
end forward

global type w_nike_ppl_accuracy_rpt from window
integer x = 823
integer y = 360
integer width = 2030
integer height = 824
boolean titlebar = true
string title = "Delivery  Accuracy Report"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 80269524
event ue_retrieve ( )
event ue_print ( )
dw_ppl_exclusion dw_ppl_exclusion
dw_query dw_query
dw_ppl_detail dw_ppl_detail
dw_ppl dw_ppl
dw_detail dw_detail
dw_report dw_report
cb_search cb_search
end type
global w_nike_ppl_accuracy_rpt w_nike_ppl_accuracy_rpt

type variables
String      is_title, is_org_sql
m_report im_menu
end variables

event ue_retrieve();string ls_whcode, filename, ls_dono, ls_ppl, ls_sku, ls_exclude
String ls_gpc,ls_division
datetime ld_sdate, ld_edate
long pos, ll_reqqty, ll_allocqty
long ll_cnt, ll_cntdt, ll_ppl_cnt, ll_ppl_cntdt
long i, j,  k, l, ll_failed, ll_total, ll_excluded
long ll_tot_req, ll_tot_ship, ll_i
OLEObject xl, xs

SetPointer(HourGlass!)

If dw_query.AcceptText() = -1 Then Return

ls_whcode = Dw_query.GetItemString(1, "wh_code")
if isNull(ls_whcode) Then
 	MessageBox(is_title, "Please enter warehouse code!")
	Return
end if

SetPointer(HourGlass!)

ld_sdate = DateTime(Date(dw_query.GetItemDateTime(1, "s_date")), time("00:00"))
ld_edate = DateTime(Date(dw_query.GetItemDateTime(1, "e_date")), time("23:59:59"))


// get total ppl in this month
ll_total = 0
Select Count(distinct b.User_Field1) Into :ll_total 
			From Delivery_Master a, delivery_detail b
  			Where b.do_no = a.do_no and a.project_Id = :gs_project and  (a.wh_code = :ls_whcode and ( a.ord_status = "C" or a.ord_status='H' or a.ord_status='A') and 			  		a.schedule_date >= :ld_sdate and a.schedule_date < :ld_edate) ;
If ll_total = 0 Then
	Messagebox(is_title, "No Nike Delivery No found for the selected date range!")
	Return
End If

// get total failed
ll_failed =0
	
//	SELECT   Count(distinct Delivery_Detail.User_Field1) Into :ll_failed 
//    FROM Delivery_Master, Delivery_Detail
//	 WHERE  ( Delivery_Master.do_no = Delivery_Detail.do_no) and
//	 			( Delivery_Master.project_id = :gs_project)  AND 
//				( Delivery_Master.wh_code = :ls_whcode )  AND 
//      		  ( ( Delivery_Master.ord_date >= :ld_sdate ) AND   
//         		( Delivery_Master.ord_date <= :ld_edate ) )  AND 
//      	   ( ( Delivery_Master.Ord_Status = "C" or Delivery_master.ord_status='H' or Delivery_master.ord_status='A')   AND
//			(IsNull(  (Select sum(Req_Qty)  From Delivery_Detail Where Delivery_Detail.Do_No =  Delivery_Master.Do_No  ),0)  <> IsNull(  (Select sum(Quantity)  From Delivery_Packing Where Delivery_Packing.Do_No =  Delivery_Master.Do_No  ),0)  ));

SELECT   Count(distinct Delivery_Detail.User_Field1) Into :ll_failed 
   FROM Delivery_Master,   
         Delivery_Detail,item_master  
   WHERE ( Delivery_Detail.DO_No = Delivery_Master.DO_No ) AND   
         ( delivery_detail.sku=item_master.sku) AND 
         ( delivery_detail.supp_code=item_master.supp_code) AND  
		 ( delivery_master.project_id =item_master.project_id) AND
			( Delivery_Master.project_id = :gs_project)  AND 
			( Delivery_Master.wh_code = :ls_whcode )  AND 
        ( ( Delivery_Master.schedule_date >= :ld_sdate ) AND   
         ( Delivery_Master.schedule_date <= :ld_edate ) )  AND 
         ( (( Delivery_Master.Ord_Status = "C" ) OR ( Delivery_Master.Ord_Status = "V" )) AND
			(Req_qty <> IsNull(  (Select sum(Quantity)  From Delivery_Picking Where Delivery_Picking.Do_No =  Delivery_Master.Do_No and Delivery_Picking.sku = Delivery_Detail.sku and Delivery_Picking.supp_code = Delivery_Detail.supp_code and Delivery_Picking.line_item_no = Delivery_Detail.line_item_no  ),0)  ))
;
			
	

	
////get total excluded ppls
//ll_excluded = 0
//Select Count(distinct b.User_Field1) Into :ll_excluded
//			From Delivery_Master a, delivery_detail b, ppl_accuracy_exclusion c
//  			Where b.do_no = a.do_no and (a.wh_code = :ls_whcode and ( a.ord_status = "C" or a.ord_status='H') and 
//			  		a.complete_date >= :ld_sdate and a.complete_date < :ld_edate) and
//					b.delivery_no = c.ppl_no;

// Retrieve do_no not 100% fulfilled
ll_cnt = dw_report.Retrieve(gs_project, ls_whcode, ld_sdate, ld_edate)


SetMicroHelp("Opening Excel ...")
filename = gs_syspath + "Reports\ppl_accuracy.xls"

xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(filename,0,True)
xs = xl.application.workbooks(1).worksheets(2)

SetMicroHelp("Printing report heading...")

xs.cells(1,1).Value = "Printed on: " + String(Today(),"mm/dd/yyyy hh:mm")
xs.cells(3,1).value = "( "+String(ld_sdate, "mm/dd/yyyy hh:mm") + '-' + String(ld_edate, "mm/dd/yyyy hh:mm")+" )"

pos = 5

For i = 1 to ll_cnt
	SetMicroHelp("Calculating order " + String(i) + " of " + String(ll_cnt))
	If dw_report.GetItemNumber(i, "req_qty") = dw_report.GetItemNumber(i, "alloc_qty") Then
		Continue
	End If		
				pos += 1 
				xs.rows(pos +1).insert
				
				
           	xs.cells(pos,1).Value = String(dw_report.GetItemDateTime(i, 'complete_date'), "mm/dd/yy")   
			   xs.cells(pos,2).Value = String(dw_report.GetItemDateTime(i, 'reschedule_date'), "mm/dd/yy")   
				xs.cells(pos,3).Value = String(dw_report.GetItemDateTime(i, 'ord_date'), "mm/dd/yy")   
				xs.cells(pos,4).Value =  dw_report.getitemstring(i,'delivery_no') //dw_report.getitemstring(i,'invoice_no')
				xs.cells(pos,5).Value = dw_report.getitemstring(i,'invoice_no') //dw_report.getitemstring(i,'do_no')
				xs.cells(pos,6).Value = dw_report.getitemstring(i,'ship_to_name')
				xs.cells(pos,8).Value = dw_report.getitemstring(i,'delivery_detail_sku')				
				xs.cells(pos,9).Value = dw_report.getitemnumber(i,'Req_Qty')
				xs.cells(pos,10).Value = dw_report.getitemnumber(i,'alloc_Qty')
				xs.cells(pos,11).Value = dw_report.getitemnumber(i,'diff_qty')
				
				ls_gpc=dw_report.getitemstring(i,'gpc') 
				 
				Choose Case ls_gpc 
					case '10' 
						ls_division = '10 (AD)' 
					case '20'
						ls_division = '20 (FT)'
					case '30'
						ls_division = '30 (QQ)'
					case '40'
						ls_division = '40 (POP)'
					case else
						ls_division = ls_gpc
				End choose			
				
				
				xs.cells(pos,7).Value = ls_gpc
				
			//	xs.cells(pos,4).value = ll_tot_ship
			Next	

xs = xl.application.workbooks(1).worksheets(1)
xs.cells(1,1).Value = "Printed on: " + String(Today(),"mm/dd/yyyy hh:mm")
xs.cells(32,2).value = String(ld_sdate, "mm/dd/yyyy hh:mm") + '-' + String(ld_edate, "mm/dd/yyyy hh:mm")

pos = 1

xs.cells(33,pos+1).value = (ll_total - ll_failed - ll_excluded) / (ll_total - ll_excluded)
xs.cells(34,pos+1).value = ll_total
xs.cells(35,pos+1).value = ll_total - ll_failed - ll_excluded
xs.cells(36,pos+1).value = ll_excluded
                            
SetMicroHelp("Complete!") 
xl.Visible = True 
xl.DisconnectObject() 
destroy xl  
destroy xs  
                                                                 
end event

event ue_print;This.Trigger Event ue_print()
end event

event open;This.Move(0,0)

dw_report.SetTransObject(Sqlca)
dw_detail.SetTransObject(Sqlca)
dw_ppl.SetTransObject(Sqlca)
dw_ppl_detail.SetTransObject(Sqlca)
dw_ppl_exclusion.SetTransObject(Sqlca)
dw_query.SetTransObject(Sqlca)

dw_query.Modify("s_date_t.text='Ship Date:'")

is_title = This.Title
im_menu = This.Menuid

//em_fyear.text=string(year(today()))
//ddlb_fmonth.text=right('0'+string(month(today())),2)

dw_query.InsertRow(0)
dw_query.SetItem(1, "wh_code", gs_default_wh)
dw_query.SetItem(1,"s_date",Today())
dw_query.SetItem(1,"e_date",Today())
dw_query.setcolumn("s_date")
dw_query.setfocus()

// Loading from USer Warehouse Datastore 
DataWindowChild ldwc_warehouse,ldwc_warehouse2

dw_query.GetChild("wh_code", ldwc_warehouse)

ldwc_warehouse.SetTransObject(sqlca)

g.of_set_warehouse_dropdown(ldwc_warehouse)

dw_query.SetITem(1,'wh_code',gs_default_WH)

end event

on w_nike_ppl_accuracy_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.dw_ppl_exclusion=create dw_ppl_exclusion
this.dw_query=create dw_query
this.dw_ppl_detail=create dw_ppl_detail
this.dw_ppl=create dw_ppl
this.dw_detail=create dw_detail
this.dw_report=create dw_report
this.cb_search=create cb_search
this.Control[]={this.dw_ppl_exclusion,&
this.dw_query,&
this.dw_ppl_detail,&
this.dw_ppl,&
this.dw_detail,&
this.dw_report,&
this.cb_search}
end on

on w_nike_ppl_accuracy_rpt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ppl_exclusion)
destroy(this.dw_query)
destroy(this.dw_ppl_detail)
destroy(this.dw_ppl)
destroy(this.dw_detail)
destroy(this.dw_report)
destroy(this.cb_search)
end on

type dw_ppl_exclusion from datawindow within w_nike_ppl_accuracy_rpt
boolean visible = false
integer x = 1536
integer y = 28
integer width = 494
integer height = 360
integer taborder = 20
string dataobject = "d_nike_ppl_exclusion"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_query from datawindow within w_nike_ppl_accuracy_rpt
integer x = 137
integer y = 72
integer width = 1678
integer height = 260
integer taborder = 60
string dataobject = "d_nike_shipdate_search"
boolean border = false
boolean livescroll = true
end type

type dw_ppl_detail from datawindow within w_nike_ppl_accuracy_rpt
boolean visible = false
integer x = 1015
integer y = 88
integer width = 494
integer height = 360
integer taborder = 20
string dataobject = "d_nike_ppl_detail"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_ppl from datawindow within w_nike_ppl_accuracy_rpt
boolean visible = false
integer x = 14
integer y = 88
integer width = 494
integer height = 360
integer taborder = 10
string dataobject = "d_nike_failed_delivery_ppl"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_detail from datawindow within w_nike_ppl_accuracy_rpt
boolean visible = false
integer x = 142
integer y = 504
integer width = 494
integer height = 360
integer taborder = 40
string dataobject = "d_nike_delivery_detail"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_report from datawindow within w_nike_ppl_accuracy_rpt
boolean visible = false
integer x = 1394
integer y = 208
integer width = 878
integer height = 576
integer taborder = 30
string dataobject = "d_nike_do_accuracy"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_search from commandbutton within w_nike_ppl_accuracy_rpt
integer x = 891
integer y = 412
integer width = 283
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;parent.triggerevent("ue_retrieve")

end event

