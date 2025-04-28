HA$PBExportHeader$w_nike_report_ancestor.srw
forward
global type w_nike_report_ancestor from window
end type
type dw_report from datawindow within w_nike_report_ancestor
end type
type dw_query from datawindow within w_nike_report_ancestor
end type
end forward

global type w_nike_report_ancestor from window
integer x = 5
integer y = 4
integer width = 3579
integer height = 2136
boolean titlebar = true
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_retrieve ( )
event ue_refresh ( )
event ue_saveas ( )
event ue_print ( )
event ue_preview ( )
event ue_file ( )
dw_report dw_report
dw_query dw_query
end type
global w_nike_report_ancestor w_nike_report_ancestor

type variables
String      is_title, is_org_sql
m_report im_menu
end variables

event ue_refresh;dw_report.Reset()

end event

event ue_saveas;IF dw_report.RowCount() > 0 THEN
	dw_report.SaveAs()
END IF
end event

event ue_print;IF dw_report.RowCount() > 0 THEN
	OpenwithParm(w_dw_print_options,dw_report) 
ELSE
	MessageBox(is_title,"No record to print",Exclamation!,Ok!,1)
	Return
END IF
	
end event

event ue_file();
IF dw_report.RowCount() > 0 THEN
	dw_report.SaveAs()
END IF
end event

on w_nike_report_ancestor.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.dw_report=create dw_report
this.dw_query=create dw_query
this.Control[]={this.dw_report,&
this.dw_query}
end on

on w_nike_report_ancestor.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
destroy(this.dw_query)
end on

event open;// Initialize
This.X = 0
This.Y = 0

dw_query.SetTransObject(Sqlca)

dw_report.SetTransObject(Sqlca)

is_title = This.Title
im_menu = This.Menuid
is_org_sql = dw_report.GetSqlSelect()
end event

type dw_report from datawindow within w_nike_report_ancestor
integer x = 41
integer y = 412
integer width = 3058
integer height = 1512
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_query from datawindow within w_nike_report_ancestor
integer x = 32
integer y = 28
integer width = 3067
integer height = 360
integer taborder = 10
boolean border = false
boolean livescroll = true
end type

