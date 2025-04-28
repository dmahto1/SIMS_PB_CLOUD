HA$PBExportHeader$w_print_ship_docs.srw
$PBExportComments$Print Shipment Documents (BOL, labels, PL, etc.)
forward
global type w_print_ship_docs from w_response_ancestor
end type
type cb_1 from commandbutton within w_print_ship_docs
end type
type dw_ship_docs from datawindow within w_print_ship_docs
end type
end forward

global type w_print_ship_docs from w_response_ancestor
integer width = 2446
integer height = 1040
string title = "Print Shipment Documents"
string menuname = "m_simple_edit_gemini"
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = main!
event ue_load_printers ( )
cb_1 cb_1
dw_ship_docs dw_ship_docs
end type
global w_print_ship_docs w_print_ship_docs

type variables

u_nvo_ship_documents	iu_ship_docs
end variables

event ue_load_printers();//Load available printers into printer dropdown

datawindowChild	ldwc
String	lsPrinterlist, lsPrinter
Long	llnewRow, llPos

dw_ship_docs.GetChild('printer',ldwc)

lsPrinterlist = PrintGetPrinters()

If lsPrinterList > '' Then
	
	Do While lsPrinterList > ''
		
		llPos = Pos(lsPrinterList, "~n")
		If llPos > 0 Then
			lsPrinter = Left(lsPrinterList,(llPos - 1))
			lsPrinterList = Mid(lsPrinterList, (llPos + 1))
		Else
			lsPrinter = lsPrinterList
			lsPrinterList = ''
		End If
		
		llNewRow = ldwc.InsertRow(0)
		ldwc.SetItem(llNewRow,'Printer', lsPrinter)
				
	Loop
	
End If

end event

on w_print_ship_docs.create
int iCurrent
call super::create
if this.MenuName = "m_simple_edit_gemini" then this.MenuID = create m_simple_edit_gemini
this.cb_1=create cb_1
this.dw_ship_docs=create dw_ship_docs
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_ship_docs
end on

on w_print_ship_docs.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_ship_docs)
end on

event ue_postopen;call super::ue_postopen;
//Load Printer List
This.triggerEvent('ue_load_printers')

//Create the appropriate UO depending on the project
Choose Case Upper(gs_project)
		
	Case '3COM_NASH'
		
		iu_ship_docs = Create u_nvo_ship_documents_3COM
		
End Choose

//Load the datawindow of reports to print
iu_ship_docs.wf_load_documents(dw_ship_docs)
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_print_ship_docs
integer x = 1422
integer y = 728
integer height = 92
end type

type cb_ok from w_response_ancestor`cb_ok within w_print_ship_docs
integer x = 987
integer y = 728
integer height = 92
end type

type cb_1 from commandbutton within w_print_ship_docs
integer x = 535
integer y = 728
integer width = 279
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;
iu_ship_docs.wf_print(dw_ship_docs)
end event

type dw_ship_docs from datawindow within w_print_ship_docs
integer y = 12
integer width = 2386
integer height = 660
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_print_ship_docs"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

