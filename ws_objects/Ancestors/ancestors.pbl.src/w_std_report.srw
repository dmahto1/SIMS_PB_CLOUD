$PBExportHeader$w_std_report.srw
forward
global type w_std_report from window
end type
type dw_select from datawindow within w_std_report
end type
type cb_clear from commandbutton within w_std_report
end type
type dw_report from datawindow within w_std_report
end type
end forward

global type w_std_report from window
integer width = 3401
integer height = 1792
boolean titlebar = true
string title = "Untitle"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_retrieve ( )
event ue_close ( )
event ue_print ( )
event ue_clear ( )
event ue_file ( )
event ue_postopen ( )
event type integer ue_sort ( )
event ue_help ( )
dw_select dw_select
cb_clear cb_clear
dw_report dw_report
end type
global w_std_report w_std_report

type variables
String     is_title, is_process = '', isHelpKeyword
Long		ilHelpTopicID
Boolean ib_changed
m_report im_menu
n_warehouse i_nwarehouse
n_reports i_nreports
datawindow idw_current
Long	il_method_trans_id


Protected boolean ib_saveasascii
DateTime idt_StartRetrieve, idt_EndRetrieve
end variables

event ue_close;destroy i_nwarehouse
Destroy i_nreports
Close(This)

end event

event ue_print;OpenWithParm(w_dw_print_options,dw_report) 

end event

event ue_file();String	lsOption,ls_name
Str_parms	lstrparms
ulong lu_rtn,lu_pass
integer li_rtn
//Triggered from menu
lu_pass = 300000
ls_name = space(5000)
lsoption = Message.StringParm
Choose Case lsoption
		
	Case "PRINTPREVIEW" /*print preview window*/
		
			OpenwithParm(w_printzoom,dw_report)
		
	Case "SAVEAS" /*Export*/
	//DGM 06/24/05	
	//This process is triggered only if the clag is set in descedant window
	// this process will save a file in the current work directory	
  	IF ib_saveasascii  THEN
		lu_rtn = g.GetCurrentDirectoryA(lu_pass,ls_name)
		ls_name = ls_name + '\' + 'RESULTS.xls'	
		
		IF  FileExists(ls_name) THEN 	FileDelete ( ls_name ) 
		li_rtn=dw_report.Saveas()
		IF li_rtn > 0 THEN li_rtn=dw_report.SaveAsAscii(ls_name)	
	ELSE
		li_rtn=dw_report.Saveas()
	END IF	
		
		
End Choose
end event

event ue_postopen();// 06/00 PCONKL - Posted from Open Event
i_nwarehouse = Create  n_warehouse
i_nreports = Create n_reports
ib_saveasascii = False

end event

event ue_sort;//This Event displays the sor criterial & sorts by the desire criteria
long ll_ret
String str_null
SetNull(str_null)
IF isvalid(idw_current) THEN
	ll_ret=idw_current.Setsort(str_null)
	ll_ret=idw_current.Sort()
	if isnull(ll_ret) then ll_ret=0
END IF	
return ll_ret

end event

event ue_help;Integer	liRC

//Help Topic ID is set in this event and passed to help file

//If you want to open by Topic ID, set the ilHelpTopicID to a valid Map #
// If you want to open by keyword, set the isHelpKeyord variable


If isHelpKeyword > ' ' Then
	lirc = ShowHelp(g.is_helpfile,Keyword!,isHelpKeyword) /*open by Keyword*/
ElseIf ilHelpTopicID > 0 Then
	lirc = ShowHelp(g.is_helpfile,topic!,ilHelpTopicID) /*open by topic ID*/
Else
	liRC = ShowHelp(g.is_HelpFile,Index!)
End If


end event

on w_std_report.create
if this.MenuName = "m_report" then this.MenuID = create m_report
this.dw_select=create dw_select
this.cb_clear=create cb_clear
this.dw_report=create dw_report
this.Control[]={this.dw_select,&
this.cb_clear,&
this.dw_report}
end on

on w_std_report.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_select)
destroy(this.cb_clear)
destroy(this.dw_report)
end on

event open;
// cawikholm - 07/05/11 Added tracking of User
f_method_trace_special( gs_project,this.ClassName() + ' - open','Window Opened ',' ',' ',' ',' ' ) //08-Feb-2013  :Madhu added

// Intitialize
This.X = 0
This.Y = 0


// pvh 08.11.05 
str_parms lstrparms

lstrparms = message.PowerObjectParm
// pvh - 08.12.06
if UpperBound( lstrparms.String_arg ) > 0  then
	is_process = lstrparms.String_arg[1]
end if
is_process = Message.StringParm
// end of mod

//is_title = This.Title
im_menu = This.MenuId
ilHelpTopicID = 506 /*default help topic for reports*/

//04/13 - PCONKL - Check to see if report should be run against the Replication Server instead of Prod DB

if g.uf_is_report_running_on_replication(this.ClassName()) Then
	dw_report.SetTransObject(Replication_SQLCA)
	This.Title = This.Title + " ** Running from Replication Server (" + Replication_SQLCA.servername + "/" + Replication_SQLCA.database + ") **"
Else
	dw_report.SetTransObject(sqlca)	
End If

dw_select.InsertRow(0)

is_title = This.Title

This.PostEvent("ue_postopen") /* 06/00 PCONKL*/
end event

event deactivate;g.POST of_setmenu(TRUE)
end event

event close;
// cawikholm - 07/05/11 Added tracking of User
f_method_trace_special( gs_project,this.ClassName() + ' - close','Window Closed ',' ',' ',' ',' ' ) //08-Feb-2013  :Madhu added
end event

type dw_select from datawindow within w_std_report
integer x = 27
integer y = 12
integer width = 2537
integer height = 164
integer taborder = 10
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;g.of_check_label(this) 
end event

type cb_clear from commandbutton within w_std_report
boolean visible = false
integer x = 2853
integer y = 44
integer width = 453
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;dw_select.Reset()
dw_select.InsertRow(0)
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_report from datawindow within w_std_report
event ue_processenter pbm_dwnprocessenter
integer x = 27
integer y = 192
integer width = 3310
integer height = 1392
integer taborder = 20
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_changed = True
This.SetItem(row, "last_user", gs_userid)

// pvh 02.15.06 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( gs_default_wh ) 
This.SetItem(row, "last_update", ldtToday)


end event

event constructor;idw_current = this
g.of_check_label(this) 
end event

event retrievestart;
//TimA 05/02/14 Added Method trace calls before and after the retrieve of the report to records how log it take to retrieve the report.
idt_StartRetrieve = DateTime(Today( ),Now( ) )
f_method_trace_special( gs_project,This.dataobject ,'Begin Report Retrieve ',' ',' ',' ',' ' ) 
end event

event retrieveend;//TimA 05/02/14 Added Method trace calls before and after the retrieve of the report to records how log it take to retrieve the report.

string ls_Time 

idt_EndRetrieve = DateTime(Today( ),Now( ) )

//New function to calculate time difference between two dates.
ls_Time = f_compare_Dates(idt_StartRetrieve, idt_EndRetrieve )

f_method_trace_special( gs_project,This.dataobject ,'End Report Retrieve ' + is_title,' ',' ',ls_Time ,' ' ) 
end event

