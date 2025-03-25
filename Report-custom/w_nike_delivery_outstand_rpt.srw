HA$PBExportHeader$w_nike_delivery_outstand_rpt.srw
forward
global type w_nike_delivery_outstand_rpt from window
end type
type ddlb_status from dropdownlistbox within w_nike_delivery_outstand_rpt
end type
type sle_region from singlelineedit within w_nike_delivery_outstand_rpt
end type
type st_3 from statictext within w_nike_delivery_outstand_rpt
end type
type sle_transporter from singlelineedit within w_nike_delivery_outstand_rpt
end type
type st_2 from statictext within w_nike_delivery_outstand_rpt
end type
type st_1 from statictext within w_nike_delivery_outstand_rpt
end type
type cb_print from commandbutton within w_nike_delivery_outstand_rpt
end type
type dw_ppl from datawindow within w_nike_delivery_outstand_rpt
end type
type dw_report from datawindow within w_nike_delivery_outstand_rpt
end type
end forward

global type w_nike_delivery_outstand_rpt from window
integer x = 823
integer y = 364
integer width = 1993
integer height = 976
boolean titlebar = true
string title = "Outstanding Delivery Report"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_print ( )
event ue_retrieve ( )
ddlb_status ddlb_status
sle_region sle_region
st_3 st_3
sle_transporter sle_transporter
st_2 st_2
st_1 st_1
cb_print cb_print
dw_ppl dw_ppl
dw_report dw_report
end type
global w_nike_delivery_outstand_rpt w_nike_delivery_outstand_rpt

type variables
String      is_title, is_org_sql
m_report im_menu
end variables

event ue_print();String ls_status, ls_dono,ls_transporter,ls_region
OLEObject xl, xs
String filename,	ls_gpc,ls_gpcdet
String lineout[]
Long i, j, ll_cnt, ll_qty, pos
String dummy,ls

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
		case  'Hold'
			 ls_status = 'H'	  
End Choose			  

If ls_status = 'ALL' then
	ls_status = "%"
ELse
	ls_status = ls_status + "%"
End if	

If isnull(sle_transporter.text) or sle_transporter.text = '' Then
	ls_transporter = "%"
else
	ls_transporter = sle_transporter.text + '%'
End if

If isnull(sle_region.text) or sle_region.text = '' Then
	ls_region = "%"
else
	ls_region = sle_region.text + '%'
End if

ll_cnt = dw_report.Retrieve(gs_project, ls_status,ls_transporter,ls_region)

							
If ll_cnt < 1 Then 												
	MessageBox(is_title, "No record found!")				
	Return															
End If																		
												
SetPointer(HourGlass!)

SetMicroHelp("Opening Excel ...")
filename = gs_syspath + "Reports\Outstand.xls"

If not fileexists(filename) Then
	Messagebox("EWMS","The excel template " + filename + " not found. Pls check")
	Return
End If	

xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(filename,0,True)
xs = xl.application.workbooks(1).worksheets(1)

SetMicroHelp("Printing report heading...")

xs.cells(1,1).Value = "Printed on: " + String(Today(),"mm/dd/yyyy hh:mm")

pos = 4
For i = 1 to ll_cnt
	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
	pos += 1 
	If i + 2 <= ll_cnt Then xs.rows(pos + 1).Insert
	ls_dono = dw_report.GetItemString(i, "do_no")
	
// ls_ppl = ""
// dw_ppl.Retrieve(ls_dono)

//	For j = 1 to dw_ppl.RowCount()
//		ls_ppl += Trim(dw_ppl.GetItemString(j, "ppl_no")) + ", "
//	Next
//	If Len(ls_ppl) > 0 Then
//		ls_ppl = Left(ls_ppl, Len(ls_ppl) - 2)
//	End If 
   
//	ll_qty = 0
//	Select Sum(req_qty) Into :ll_qty
//		From delivery_detail
//		Where do_no = :ls_dono;
//	If IsNull(ll_qty) Then ll_qty = 0
	
// lineout[1] = ''
	lineout[1] = dw_report.GetItemString(i, "ship_cost") //, "####") //Sarun Ver : EWMS 2.0 080707	
	lineout[2] =  dw_report.GetItemString(i, "invoice_no")     //ls_dono 
	lineout[3] = String(dw_report.GetItemDateTime(i, "ord_date"), "mm/dd/yyyy hh:mm") 
	
	Choose Case dw_report.GetItemString(i, "ord_status")
		Case 'N'
			lineout[4] = "New"
		Case 'P'
			lineout[4] = "Process"
		Case 'I'
			lineout[4] = "Picking"
		Case 'C'	
			lineout[4] = "Complete"
		Case 'A'		
			lineout[4] = "Packing"
		Case 'H'		
			lineout[4] = "Hold"
	End Choose		

	lineout[5] = dw_report.GetItemString(i, "customer")  
	
	lineout[6] = dw_report.GetItemString(i, "region") 
	ls = dw_report.GetItemString(i, "region") 
//	lineout[8] = dw_report.GetItemString(i, "Transporter") 
	lineout[7] = String(dw_report.GetItemDateTime(i, "reschedule_date"), "mm/dd/yyyy hh:mm")  
//	lineout[10] = dw_report.GetItemString(i, "vas1")
	lineout[8] = dw_report.GetItemString(i, "delivery_no")
	xs.range("a" + String(pos) + ":H" +  String(pos)).Value = lineout
   xs.cells(pos,9).value=dw_report.GetItemNumber(i, "qty")

	ls_gpc = dw_report.GetItemString(i, "grp")
	Choose Case ls_gpc
		Case '10'
			ls_gpcdet = 'AP'
		Case '20'
			ls_gpcdet = 'FT'
		Case '30'
			ls_gpcdet = 'QQ'
		Case '40'
			ls_gpcdet = 'POP'
		Case else
			ls_gpcdet = ls_gpc
	End choose
	xs.cells(pos,10).value=ls_gpcdet
	
	xs.cells(pos,11).value= dw_report.GetItemString(i, "last_user")  
Next

SetMicroHelp("Complete!")
xl.Visible = True
xl.DisconnectObject()


 
end event

event ue_retrieve;This.Trigger Event ue_print()
end event

on w_nike_delivery_outstand_rpt.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.ddlb_status=create ddlb_status
this.sle_region=create sle_region
this.st_3=create st_3
this.sle_transporter=create sle_transporter
this.st_2=create st_2
this.st_1=create st_1
this.cb_print=create cb_print
this.dw_ppl=create dw_ppl
this.dw_report=create dw_report
this.Control[]={this.ddlb_status,&
this.sle_region,&
this.st_3,&
this.sle_transporter,&
this.st_2,&
this.st_1,&
this.cb_print,&
this.dw_ppl,&
this.dw_report}
end on

on w_nike_delivery_outstand_rpt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_status)
destroy(this.sle_region)
destroy(this.st_3)
destroy(this.sle_transporter)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_print)
destroy(this.dw_ppl)
destroy(this.dw_report)
end on

event open;This.Move(0,0)

dw_report.SetTransObject(Sqlca)
dw_ppl.SetTransObject(Sqlca)

is_title = This.Title
im_menu = This.Menuid

im_menu.m_file.m_print.Enabled = True

ddlb_status.text='All'


end event

type ddlb_status from dropdownlistbox within w_nike_delivery_outstand_rpt
integer x = 654
integer y = 128
integer width = 535
integer height = 416
integer taborder = 30
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
string item[] = {"All","New","Process","Picking","Packing","Hold"}
borderstyle borderstyle = stylelowered!
end type

type sle_region from singlelineedit within w_nike_delivery_outstand_rpt
integer x = 654
integer y = 412
integer width = 535
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_nike_delivery_outstand_rpt
integer x = 178
integer y = 428
integer width = 453
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Region"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_transporter from singlelineedit within w_nike_delivery_outstand_rpt
integer x = 654
integer y = 268
integer width = 535
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_nike_delivery_outstand_rpt
integer x = 165
integer y = 284
integer width = 453
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Transporter"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_nike_delivery_outstand_rpt
integer x = 389
integer y = 140
integer width = 229
integer height = 92
integer textsize = -10
integer weight = 700
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

type cb_print from commandbutton within w_nike_delivery_outstand_rpt
integer x = 635
integer y = 628
integer width = 498
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
boolean default = true
end type

event clicked;Parent.Trigger Event ue_print()
end event

type dw_ppl from datawindow within w_nike_delivery_outstand_rpt
boolean visible = false
integer x = 123
integer y = 60
integer width = 494
integer height = 364
integer taborder = 10
string dataobject = "d_delivery_ppl"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_report from datawindow within w_nike_delivery_outstand_rpt
boolean visible = false
integer x = 1339
integer y = 140
integer width = 878
integer height = 572
integer taborder = 20
string dataobject = "d_nike_delivery_outstand_rpt"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

