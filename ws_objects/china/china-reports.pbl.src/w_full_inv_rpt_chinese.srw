$PBExportHeader$w_full_inv_rpt_chinese.srw
forward
global type w_full_inv_rpt_chinese from w_std_query_window
end type
end forward

global type w_full_inv_rpt_chinese from w_std_query_window
integer width = 3401
integer height = 1792
boolean titlebar = true
string title = "全部库存报表"
string menuname = "m_report"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
end type
global w_full_inv_rpt_chinese w_full_inv_rpt_chinese

on w_full_inv_rpt_chinese.create
call super::create
if this.MenuName = "m_report" then this.MenuID = create m_report
end on

on w_full_inv_rpt_chinese.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;// OVERRIDE


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

//  if you need to do some child manipulation in the query window...put the code in setCriteriaDW()
//
//  you can manipulate and muck with the report sql in the u_retrieveReport() event.
// 
//	see w_gm_last_on_hand_rpt for an example of this.

	This.X = 0
	This.Y = 0
	
	str_parms lstrparms
	
	lstrparms = message.PowerObjectParm
	//JXLIM 07/07/2010 Modified code for Chinese report
	lstrparms.string_arg[1] = 'd_hillman_full_inventory_rpt_select'
//	lstrparms.string_arg[2] = 'd_hillman_full_inventory_rpt'	
	lstrparms.string_arg[2] = 'd_full_inventory_rpt_chinese'
	
	setredraw( false )
	
	openuserobjectwithparm( u_query, lstrparms)
	u_query.width = this.width -50
	u_query.height = this.height - 50
	u_query.setTitle( this.title )
// 
// 	If you want to add the project to the where clause set the following true
// 	if your datawindow already has a where with the project, send false
//
	u_query.setProjectColumnName( " dbo.Item_Master.project_id" )
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
		im_menu.m_file.m_print.Enabled = False	
		messagebox( u_query.GetTitle(),  'No Records Found!', exclamation! )
		return
	case is > 0
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
end choose

end event

event ue_retrieve;call super::ue_retrieve;event ue_retrieveReport()

end event

event ue_file;// OVERRIDE

String	lsOption
Str_parms	lstrparms

lsoption = Message.StringParm
Choose Case lsoption
		
	Case "PRINTPREVIEW" /*print preview window*/
		
		u_query.event ue_printPreview()
		
	Case "SAVEAS" /*Export*/
		
		u_query.dw_report.Saveas()
		
End Choose




		



end event

type dw_select from w_std_query_window`dw_select within w_full_inv_rpt_chinese
integer taborder = 10
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_clear from w_std_query_window`cb_clear within w_full_inv_rpt_chinese
integer x = 2853
integer y = 44
integer width = 453
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

type dw_report from w_std_query_window`dw_report within w_full_inv_rpt_chinese
integer taborder = 20
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

