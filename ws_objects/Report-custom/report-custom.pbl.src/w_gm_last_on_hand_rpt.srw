$PBExportHeader$w_gm_last_on_hand_rpt.srw
forward
global type w_gm_last_on_hand_rpt from w_std_query_window
end type
end forward

global type w_gm_last_on_hand_rpt from w_std_query_window
string title = "Last Day on Hand Report"
end type
global w_gm_last_on_hand_rpt w_gm_last_on_hand_rpt

type variables

end variables

forward prototypes
public subroutine setcriteriadw ()
end prototypes

public subroutine setcriteriadw ();
DatawindowChild	ldwc_warehouse


//populate dropdowns - not done automatically since dw not being retrieved

u_query.dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(Sqlca)
ldwc_warehouse.Retrieve(gs_project)

u_query.dw_select.insertrow( 0 )

end subroutine

on w_gm_last_on_hand_rpt.create
call super::create
end on

on w_gm_last_on_hand_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;// OVERRIDE
// Intitialize

	This.X = 0
	This.Y = 0
	
	str_parms lstrparms
	
	lstrparms = message.PowerObjectParm
	
	lstrparms.string_arg[1] = 'd_gm_lastdayonhand_criteria'
	lstrparms.string_arg[2] = 'd_gm_emptyloc_lastdayonhand'
		
	setredraw( false )
	
	openuserobjectwithparm( u_query, lstrparms)
	u_query.width = this.width -50
	u_query.height = this.height - 50
	u_query.setTitle( this.title )
	u_query.cb_report_reset.visible = false
	u_query.cb_retrieve.visible = false
// 
// 	If you want to add the project to the where clause set the following true
// 	if your datawindow already has a where with the project, send false
//
   	u_query.setAddProjectToWhere( false )
		
	iWindow = this	
	
	u_query.initialize( iWindow )
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
string lsproj = '*project*'
string lsWhere
integer pos
long rows
integer index

im_menu.m_file.m_print.Enabled = false

lsWhere = u_query.sqlUtil.getWhere()

// replace *project* with gs_project
pos = pos( lsWhere, lsproj )
if pos > 0 then
	lsWhere = replace( lsWhere, pos, len( lsproj ), gs_project )
end if
u_query.sqlUtil.setWhere( lsWhere )

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

im_menu.m_file.m_print.Enabled = True

// loop thru the rows and set the dummy column numberofdaysempty 
// equal to the value in the computed field so we can export the data
for index = 1 to rows
	u_query.dw_report.object.numberofdaysempty[ index ] = String( u_query.dw_report.object.dayswithoutcontent[index])
next

end event

event ue_retrieve;call super::ue_retrieve;event ue_retrieveReport()
end event

type dw_select from w_std_query_window`dw_select within w_gm_last_on_hand_rpt
end type

type cb_clear from w_std_query_window`cb_clear within w_gm_last_on_hand_rpt
end type

type dw_report from w_std_query_window`dw_report within w_gm_last_on_hand_rpt
end type

