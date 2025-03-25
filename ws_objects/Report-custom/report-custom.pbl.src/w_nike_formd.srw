$PBExportHeader$w_nike_formd.srw
forward
global type w_nike_formd from w_nike_report_ancestor
end type
type sle_filename from singlelineedit within w_nike_formd
end type
type st_1 from statictext within w_nike_formd
end type
type cb_browse from commandbutton within w_nike_formd
end type
type lb_ordtype from listbox within w_nike_formd
end type
type st_2 from statictext within w_nike_formd
end type
type em_date from editmask within w_nike_formd
end type
type st_3 from statictext within w_nike_formd
end type
type dw_list from datawindow within w_nike_formd
end type
type cb_search from commandbutton within w_nike_formd
end type
end forward

global type w_nike_formd from w_nike_report_ancestor
integer width = 2194
integer height = 2152
string title = "FormD Report"
long backcolor = 81324524
sle_filename sle_filename
st_1 st_1
cb_browse cb_browse
lb_ordtype lb_ordtype
st_2 st_2
em_date em_date
st_3 st_3
dw_list dw_list
cb_search cb_search
end type
global w_nike_formd w_nike_formd

on w_nike_formd.create
int iCurrent
call super::create
this.sle_filename=create sle_filename
this.st_1=create st_1
this.cb_browse=create cb_browse
this.lb_ordtype=create lb_ordtype
this.st_2=create st_2
this.em_date=create em_date
this.st_3=create st_3
this.dw_list=create dw_list
this.cb_search=create cb_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_filename
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_browse
this.Control[iCurrent+4]=this.lb_ordtype
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.em_date
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.dw_list
this.Control[iCurrent+9]=this.cb_search
end on

on w_nike_formd.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_filename)
destroy(this.st_1)
destroy(this.cb_browse)
destroy(this.lb_ordtype)
destroy(this.st_2)
destroy(this.em_date)
destroy(this.st_3)
destroy(this.dw_list)
destroy(this.cb_search)
end on

event open;call super::open;em_date.text = String(today())

end event

event ue_retrieve;cb_search.triggerevent(clicked!)
end event

event ue_print;//OverRide

IF dw_report.RowCount() > 0 THEN
	OpenwithParm(w_dw_print_options,dw_list) 
ELSE
	MessageBox(is_title,"No record to print",Exclamation!,Ok!,1)
	Return
END IF
	
end event

type dw_report from w_nike_report_ancestor`dw_report within w_nike_formd
boolean visible = false
integer x = 2213
integer y = 444
integer width = 1751
integer height = 1456
integer taborder = 60
string dataobject = "d_nike_formd"
end type

type dw_query from w_nike_report_ancestor`dw_query within w_nike_formd
boolean visible = false
integer taborder = 70
end type

type sle_filename from singlelineedit within w_nike_formd
integer x = 357
integer y = 36
integer width = 1390
integer height = 100
integer taborder = 10
boolean bringtotop = true
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

type st_1 from statictext within w_nike_formd
integer x = 5
integer y = 52
integer width = 343
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Select File"
boolean focusrectangle = false
end type

type cb_browse from commandbutton within w_nike_formd
integer x = 1783
integer y = 32
integer width = 329
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Browse"
end type

event clicked;string docname, named
integer k
k = GetFileOpenName("Select File", docname, named, "XLS*", + "Excel Files (*.xls*),*.xls*")

IF TRIM(sle_filename.TEXT)<>DOCNAME AND TRIM(DOCNAME)<>"" THEN	
	sle_filename.TEXT=DOCNAME
END IF


end event

type lb_ordtype from listbox within w_nike_formd
integer x = 361
integer y = 144
integer width = 430
integer height = 212
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Supplier Order","Goods Return","All"}
end type

type st_2 from statictext within w_nike_formd
integer x = 5
integer y = 172
integer width = 343
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Order Type"
boolean focusrectangle = false
end type

type em_date from editmask within w_nike_formd
integer x = 1769
integer y = 164
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type st_3 from statictext within w_nike_formd
integer x = 1403
integer y = 172
integer width = 343
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Start Date"
boolean focusrectangle = false
end type

type dw_list from datawindow within w_nike_formd
integer x = 50
integer y = 384
integer width = 2062
integer height = 1512
integer taborder = 80
string dataobject = "d_nike_formd"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_search from commandbutton within w_nike_formd
integer x = 1783
integer y = 268
integer width = 329
integer height = 104
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
end type

event clicked;String 	ls_filename,ls_OrdType,ls_matno[],ls_temp
Date 		ldt_strdate
Long		ll_row,ll_newrow,i,J,ll_rowcount,ll_totlist,ll_foundrow

ls_filename = trim(sle_filename.text)
ls_ordType	= lb_ordtype.selecteditem()
ldt_strdate = Date(em_date.text)

If len(trim(ls_filename)) = 0 Then
	Messagebox("FormD", "Please enter file path")
	sle_filename.setfocus()
	Return
End If

If len(trim(ls_ordType)) = 0 Then
	Messagebox("FormD", "Please select the Order Type")
	sle_filename.setfocus()
	Return
End If

If len(trim(String(ldt_strdate))) = 0 Then
	Messagebox("FormD", "Please Enter Date")
	sle_filename.setfocus()
	Return
End If

Choose Case ls_ordType
	case 'Supplier Order'
		ls_OrdType = 'S'
	case 'Goods Return'
		ls_OrdType = 'X'
	case 'All'	
		ls_OrdType = '%'
end choose

// Open Excel file
Setmicrohelp("Opening Excel ...")
SetPointer(HourGlass!)

//Import Nike excel file:
If not FileExists(ls_filename) Then
	Messagebox("FormD", "File " + ls_filename + " not found!")
	Return
End if

OLEObject 	xl, xs

xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(ls_filename,0,True)
xs = xl.application.workbooks(1).worksheets(1)

ll_row = 0 //1
i = 0

dw_list.reset()

Do while True
	Setmicrohelp("Processing excel row " + String(ll_row))
	
	ll_row += 1
	ls_temp = trim(string(xs.cells(ll_row,1).Value))
	
	if len(ls_temp) <= 0 or isnull(ls_temp) then
		exit
	end if
	
	ll_newrow	=	dw_list.insertrow(0)
	
	dw_list.setitem(ll_newrow,'material_no',ls_temp)

	if ll_row >= 1 then
		i +=1
		ls_matno[i] = ls_temp
	end if
	
Loop

xl.application.workbooks(1).Close()
xs.DisconnectObject()
xl.Application.Quit
xl.DisconnectObject()

Destroy xl
Destroy xs


ll_totlist  = dw_list.rowcount()

Setmicrohelp("Retreiving Record for given " + String(ll_totlist) + " Material ")	

if ll_totlist <= 0 then
	Messagebox("FormD", "No Material# find in given file : " + ls_filename)
	Return
end if

dw_report.retrieve(gs_project, ls_OrdType,ldt_strdate,ls_matno)

ll_rowcount = dw_report.rowcount()

if ll_rowcount <= 0 then
	Messagebox("FormD", "No Record Found")
	Return
end if

For j = 1 to ll_rowcount
	ls_Temp = dw_report.getitemString(j,'material_no')
	ll_foundrow = dw_list.Find("material_no = '" + ls_Temp + "'", 1, ll_totlist)
	dw_list.setitem(ll_foundrow,'order_no',dw_report.getitemString(j,'order_no'))
	dw_list.setitem(ll_foundrow,'Complete_date',dw_report.getitemDatetime(j,'complete_date'))
Next

dw_list.setsort("material_no")
dw_list.sort()
	
dw_report.setsort("material_no")
dw_report.sort()

if ll_rowcount > 0 then
	im_menu.m_file.m_print.Enabled = True
else
	im_menu.m_file.m_print.Enabled = False
end if	

Setmicrohelp("Complete")
end event

