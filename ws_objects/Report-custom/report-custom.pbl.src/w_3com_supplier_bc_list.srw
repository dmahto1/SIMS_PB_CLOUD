$PBExportHeader$w_3com_supplier_bc_list.srw
forward
global type w_3com_supplier_bc_list from w_std_query_window
end type
end forward

global type w_3com_supplier_bc_list from w_std_query_window
end type
global w_3com_supplier_bc_list w_3com_supplier_bc_list

forward prototypes
public subroutine setcriteriadw ()
end prototypes

public subroutine setcriteriadw ();// setCriteriaDW()

// manipulate the criteria dw here

u_query.dw_select.insertrow(0)

end subroutine

on w_3com_supplier_bc_list.create
call super::create
end on

on w_3com_supplier_bc_list.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;// w_3com_supplier_bc_list
//// OVERRIDE
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
	This.X = 0
	This.Y = 0
	
	str_parms lstrparms
	
	lstrparms = message.PowerObjectParm
	
	lstrparms.string_arg[1] = 'd_no_criteria'
	lstrparms.string_arg[2] = 'd_supplier_bc_list'
	
	setredraw( false )
	
	openuserobjectwithparm( u_query, lstrparms)
	u_query.width = this.width -50
	u_query.height = this.height - 50
	u_query.setTitle( this.title )
//// 
//// 	If you want to add the project to the where clause sent the following true
//// 	if your datawindow already has a where with the project, send false
////
   u_query.setAddProjectToWhere( false )
    iWindow = this
    u_query.initialize( iWindow )
 
// manipulate the criteria here
	 setCriteriaDW()

	setredraw( true )
	
	is_title = This.Title
	im_menu = This.MenuId
	ilHelpTopicID = 506 /*default help topic for reports*/
	dw_report.SetTransObject(sqlca)
	dw_select.InsertRow(0)
	
	This.PostEvent("ue_postopen") /* 06/00 PCONKL*/




end event

event ue_retrievereport;call super::ue_retrievereport;// ue_retrieveReport()

// manipulate the select and retrieve the report

long rows

rows = u_query.dw_report.retrieve( gs_project )
choose case rows
	case is < 0
		messagebox(u_query.GetTitle(), 'Database Error!' + string( sqlca.sqlcode) + " : " + sqlca.sqlerrtext , exclamation! )
		return
	case 0
		im_menu.m_file.m_print.Enabled = False	
		messagebox( u_query.GetTitle(),  'No Records Found!', exclamation! )
		return
	case is > 0
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
end choose

end event

event ue_retrieve;call super::ue_retrieve;this.event ue_retrieveReport()

end event

type dw_select from w_std_query_window`dw_select within w_3com_supplier_bc_list
end type

type cb_clear from w_std_query_window`cb_clear within w_3com_supplier_bc_list
end type

type dw_report from w_std_query_window`dw_report within w_3com_supplier_bc_list
end type

