$PBExportHeader$w_std_query_window.srw
forward
global type w_std_query_window from w_std_report
end type
end forward

global type w_std_query_window from w_std_report
string title = ""
event ue_retrievereport ( )
end type
global w_std_query_window w_std_query_window

type variables
u_std_tab_query u_query
window iWindow
long		il_method_trans_id



end variables

forward prototypes
public subroutine setcriteriadw ()
end prototypes

event ue_retrievereport();// ue_retrieveReport()

// manipulate the select and retrieve the report

//long rows
//
//if u_query.sqlutil.CreateWhereFromDW( u_query.dw_select ) = -1 then return 
//
//u_query.dw_report.SetSQlSelect( u_query.sqlutil.getSQL() )
//rows = u_query.dw_report.retrieve()
//choose case rows
//	case is < 0
//		messagebox(u_query.GetTitle(), 'Database Error!' + string( sqlca.sqlcode) + " : " + sqlca.sqlerrtext , exclamation! )
//		return
//	case 0
//		im_menu.m_file.m_print.Enabled = False	
//		messagebox( u_query.GetTitle(),  'No Records Found!', exclamation! )
//		return
//	case is > 0
//		im_menu.m_file.m_print.Enabled = True
//		dw_report.Setfocus()
//end choose

end event

public subroutine setcriteriadw ();// setCriteriaDW()

// manipulate the criteria dw here

u_query.dw_select.insertrow(0)

end subroutine

on w_std_query_window.create
call super::create
end on

on w_std_query_window.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;//// OVERRIDE
//
//
//// Intitialize
//
//// In your inherited version..... copy this ENTIRE BLOCK of code into your open event
//// and add your two datasources to string arg 1 and two.
////
//// NOTE:  string_arg[1] is the QUERY interface and
////			  string_arg[2] is the Report
//
// 	LAWS...
//				The search criteria MUST be table driven the sql parser uses the dbname of the column. Externals do not work
//
//				From/to date ranges...
//					The column names must be unique and you need two, a from and to.
//
//					make the column name xSomedate ie  ( Fcomplete_date )  
//					add 'from' to the tag value for the column
//					make the column name ySomedate ie ( Tcomplete_date )
//					add 'to' to  the tag value for the column.
//
//					example....
//						Select complete_date as Fcomplete_date,
//								   complete_date as Tcomplete_date
//
//
//  if you need to do some child manipulation in the query window...put the code in setCriteriaDW()
//
//  you can manipulate and muck with the report sql in the u_retrieveReport() event.
// 
//	see w_gm_last_on_hand_rpt for an example of this.
//
//	This.X = 0
//	This.Y = 0
//	
//	str_parms lstrparms
//	
//	lstrparms = message.PowerObjectParm
//	
//	lstrparms.string_arg[1] = 'd_YOUR_select_DATAWINDOW'
//	lstrparms.string_arg[2] = 'd_YOUR_reportt_DATAWINDOW'
//	
//	setredraw( false )
//	
//	openuserobjectwithparm( u_query, lstrparms)
//	u_query.width = this.width -50
//	u_query.height = this.height - 50
//	u_query.setTitle( this.title )
//// 
//// 	If you want to add the project to the where clause set the following true
//// 	if your datawindow already has a where with the project, send false
////
//	u_query.setProjectColumnName( "your project dbname")
//   u_query.setAddProjectToWhere( true/false )
//	iWindow = this
//	u_query.initialize( iWindow )
// 
// manipulate the criteria here
// setCriteriaDW()
//
//	setredraw( true )
//	
//	is_title = This.Title
//	im_menu = This.MenuId
//	ilHelpTopicID = 506 /*default help topic for reports*/
//	dw_report.SetTransObject(sqlca)
//	dw_select.InsertRow(0)
//	
//	This.PostEvent("ue_postopen") /* 06/00 PCONKL*/
//

// cawikholm - 07/05/11 Added call to track user
SetNull( il_method_trans_id )
//f_method_trace( il_method_trans_id, this.ClassName(), 'Window Opened' ) //08-Feb-2013  :Madhu commented
f_method_trace_special( gs_project,this.ClassName() + ' - open','Window Opened ',' ',' ',' ',' ' ) //08-Feb-2013  :Madhu added

end event

event resize;call super::resize;// Initialize()
int max
int index
windowobject aobj


max = UpperBound( control )
for index = 1 to max
	
	choose case TypeOf( control[ index ] )
		case Datawindow!

		case UserObject!
			aobj = control[index]
			aobj.event dynamic ue_resize()
	end Choose

next

end event

event ue_file;// OVERRIDE
String	lsOption
Str_parms	lstrparms

lsoption = Message.StringParm
Choose Case lsoption
		
	Case "PRINTPREVIEW" /*print preview window*/
		
		u_query.event ue_printPreview()
		
	Case "SAVEAS" /*Export*/
		
		u_query.event ue_saveas()
		
End Choose


end event

event ue_sort;call super::ue_sort;// Override

return u_query.event ue_sort()



end event

event ue_clear;call super::ue_clear;u_query.event ue_reset()

end event

event ue_print;OpenWithParm(w_dw_print_options,u_query.dw_report) 


end event

event close;call super::close;
//f_method_trace( il_method_trans_id, this.ClassName(), 'Window Closed' ) //08-Feb-2013  :Madhu commented
f_method_trace_special( gs_project,this.ClassName() + ' - close','Window Closed ',' ',' ',' ',' ' ) //08-Feb-2013  :Madhu added
end event

type dw_select from w_std_report`dw_select within w_std_query_window
boolean visible = false
integer x = 3067
integer y = 1496
integer width = 78
integer height = 76
boolean enabled = false
end type

type cb_clear from w_std_report`cb_clear within w_std_query_window
end type

type dw_report from w_std_report`dw_report within w_std_query_window
boolean visible = false
integer x = 3177
integer y = 1504
integer width = 87
integer height = 60
boolean enabled = false
end type

