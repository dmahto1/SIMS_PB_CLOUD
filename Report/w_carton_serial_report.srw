HA$PBExportHeader$w_carton_serial_report.srw
forward
global type w_carton_serial_report from w_std_query_window
end type
end forward

global type w_carton_serial_report from w_std_query_window
string title = "- Carton Serial Report"
end type
global w_carton_serial_report w_carton_serial_report

on w_carton_serial_report.create
call super::create
end on

on w_carton_serial_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;// OVERRIDE

// w_carton_serial_report

// Intitialize

// In your inherited version..... copy this ENTIRE BLOCK of code into your open event
// and add your two datasources to string arg 1 and two.
//
// NOTE:  string_arg[1] is the QUERY interface and
//			  string_arg[2] is the Report

	This.X = 0
	This.Y = 0
	
	str_parms lstrparms
	
	lstrparms = message.PowerObjectParm
	
	lstrparms.string_arg[1] = 'd_carton_serial_select'
	lstrparms.string_arg[2] = 'd_carton_serial_report'
	
	setredraw( false )
	
	openuserobjectwithparm( u_query, lstrparms)
	u_query.width = this.width -50
	u_query.height = this.height - 50
	u_query.setTitle( gs_project + " " + this.title )
	this.title = u_query.getTitle()
// 
// 	If you want to add the project to the where clause sent the following true
// 	if your datawindow already has a where with the project, send false
//
   	u_query.setAddProjectToWhere( true )
	iWindow = this	
	u_query.initialize( iWindow )
 	setCriteriaDW()
	 
	setredraw( true )
	
	is_title = this.title 
	im_menu = This.MenuId
	ilHelpTopicID = 506 /*default help topic for reports*/
	dw_report.SetTransObject(sqlca)
	dw_select.InsertRow(0)
	
	This.PostEvent("ue_postopen") /* 06/00 PCONKL*/




end event

event ue_retrievereport;call super::ue_retrievereport;// ue_retrieveReport()

// manipulate the select and retrieve the report

long rows

if u_query.sqlutil.CreateWhereFromDW( u_query.dw_select ) = -1 then return 

u_query.dw_report.SetSQlSelect( u_query.sqlutil.getSQL() )
rows = u_query.dw_report.retrieve()
choose case rows
	case is < 0
		messagebox(u_query.GetTitle(), 'Database Error!' + string( sqlca.sqlcode) + " : " + sqlca.sqlerrtext , exclamation! )
		return
	case 0
		messagebox( u_query.GetTitle(),  'No Records Found!', exclamation! )
		return
end choose

end event

event ue_retrieve;call super::ue_retrieve;event ue_retrieveReport()
end event

type dw_select from w_std_query_window`dw_select within w_carton_serial_report
end type

type cb_clear from w_std_query_window`cb_clear within w_carton_serial_report
end type

type dw_report from w_std_query_window`dw_report within w_carton_serial_report
end type

