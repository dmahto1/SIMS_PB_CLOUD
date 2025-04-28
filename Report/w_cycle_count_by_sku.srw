HA$PBExportHeader$w_cycle_count_by_sku.srw
forward
global type w_cycle_count_by_sku from w_std_query_window
end type
end forward

global type w_cycle_count_by_sku from w_std_query_window
string title = "Cycle Count By SKU"
end type
global w_cycle_count_by_sku w_cycle_count_by_sku

forward prototypes
public subroutine setcriteriadw ()
end prototypes

public subroutine setcriteriadw ();long insertrow
datawindowchild adwc

// manipulate the criteria dw here

u_query.dw_select.getchild( "cc_group_code", adwc )
adwc.settransobject( sqlca )
if adwc.retrieve( gs_project ) <= 0 then	adwc.insertrow(0)

u_query.dw_select.getchild( "cc_class_code", adwc )
adwc.settransobject( sqlca )
if adwc.retrieve( gs_project ) <= 0 then	adwc.insertrow(0)

u_query.dw_select.insertrow(0)



end subroutine

on w_cycle_count_by_sku.create
call super::create
end on

on w_cycle_count_by_sku.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;// w_cycle_count_by_sku

// OVERRIDE

// Intitialize

// In your inherited version..... copy this ENTIRE BLOCK of code into your open event
// and add your two datasources to string arg 1 and two.
//
// NOTE:  string_arg[1] is the QUERY interface and
//			  string_arg[2] is the Report

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
	
	lstrparms.string_arg[1] = 'd_cc_report_by_sku_select'
	lstrparms.string_arg[2] = 'd_cc_report_by_sku'
	
	setredraw( false )
	
	openuserobjectwithparm( u_query, lstrparms)
	u_query.width = this.width -50
	u_query.height = this.height - 50
	u_query.setTitle( this.title )
// 
// 	If you want to add the project to the where clause sent the following true
// 	if your datawindow already has a where with the project, send false
//
	u_query.setProjectColumnName( " Item_Master.project_id ")
  	u_query.setAddProjectToWhere( true )
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

event ue_retrieve;call super::ue_retrieve;event ue_retrieveReport()

end event

event ue_retrievereport;call super::ue_retrievereport;// ue_retrieveReport()

// manipulate the select and retrieve the report

long rows
datawindowchild adwc

if u_query.sqlutil.CreateWhereFromDW( u_query.dw_select ) = -1 then return 

// if the list past due only is checked then....
if  u_query.dw_select.object.list_past_due[ 1] = 1 then
   u_query.sqlutil.setNewWhere( "(( DATEDIFF(day, Item_Master.Last_Cycle_Cnt_Date,getDate()) - cc_group_class_code.count_frequency ) > 0 )" )
end if

u_query.dw_report.SetSQlSelect( u_query.sqlutil.getSQL() )

u_query.dw_report.getchild( "cc_group_code", adwc )
adwc.settransobject( sqlca )
adwc.retrieve( gs_project )
rows = u_query.dw_report.retrieve()
choose case rows
	case is < 0
		messagebox(u_query.GetTitle(), 'Database Error!' + string( sqlca.sqlcode) + " : " + sqlca.sqlerrtext , exclamation! )
		return
	case 0
		im_menu.m_file.m_print.Enabled = False	
		messagebox( u_query.GetTitle(),  'No Records Found!', exclamation! )
		return
	case is > 0
		u_query.dw_report.object.list_past_due.primary.current[] =  u_query.dw_select.object.list_past_due[ 1]
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()

end choose

end event

type dw_select from w_std_query_window`dw_select within w_cycle_count_by_sku
end type

type cb_clear from w_std_query_window`cb_clear within w_cycle_count_by_sku
end type

type dw_report from w_std_query_window`dw_report within w_cycle_count_by_sku
end type

