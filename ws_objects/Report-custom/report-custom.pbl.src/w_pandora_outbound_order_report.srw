$PBExportHeader$w_pandora_outbound_order_report.srw
$PBExportComments$AMS LAM Outbound Orders
forward
global type w_pandora_outbound_order_report from w_std_query_window
end type
end forward

global type w_pandora_outbound_order_report from w_std_query_window
string title = "PANDORA OUTBOUND ORDER REPORT"
end type
global w_pandora_outbound_order_report w_pandora_outbound_order_report

type variables
uo_multi_select_search StatusSelect

end variables

forward prototypes
public subroutine setcriteriadw ()
end prototypes

public subroutine setcriteriadw ();long insertrow
datawindowchild adwc

// manipulate the criteria dw here

//u_query.dw_select.getchild( "wh_code", adwc )
//adwc.settransobject( sqlca )
//adwc.retrieve( gs_project )

// LTK 20150908  Commented out block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
u_query.dw_select.GetChild("wh_code", adwc)
adwc.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(adwc)

//u_query.dw_select.getchild( "ord_type", adwc )		// LTK 20150916  I commented out the following 3 lines because there is no 
//adwc.settransobject( sqlca )								// "ord_type" column and the call is failing.
//adwc.retrieve( gs_project )
insertrow = adwc.insertrow(0)
adwc.setitem( insertrow , 'wh_name', '- All -' )
adwc.setitem( insertrow , 'wh_code', 'All' )
adwc.setsort( 'wh_name A' )
adwc.sort()

u_query.dw_select.insertrow(0)

u_query.setFromDateCol( 'fcomplete_date')
u_query.setToDateCol( 'tcomplete_date')


// LTK 20150908  
if Len( Trim( gs_default_wh )) > 0 and u_query.dw_select.RowCount() > 0 then
	u_query.dw_select.SetItem(1, "wh_code", gs_default_wh)
end if

end subroutine

on w_pandora_outbound_order_report.create
call super::create
end on

on w_pandora_outbound_order_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;// OVERRIDE

// Intitialize
//
// In your inherited version..... copy this ENTIRE BLOCK of code into your open event
// and add your two datasources to string arg 1 and two.
//
// NOTE:  string_arg[1] is the QUERY interface and
//			  string_arg[2] is the Report
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
	
	lstrparms.string_arg[1] = 'd_pandora_outbound_order_search'
	lstrparms.string_arg[2] = 'd_pandora_outbound_order_report'
	
	setredraw( false )
	
	openuserobjectwithparm( u_query, lstrparms)
	
	u_query.width = this.width -50
	u_query.height = this.height - 50
	u_query.dw_select.x = 0
	u_query.dw_select.y = 0
	u_query.dw_select.height = 500
	u_query.dw_report.y = (dw_select.height + 200 )
	u_query.dw_report.width = u_query.width
	
	u_query.setTitle( this.title )
	
	// Search shared with report but we don;t want supplier as part of criteria on this report
	u_query.dw_select.modify("delivery_detail_supp_code.visible=false supp_code_t.visible=false")
// 
// 	If you want to add the project to the where clause sent the following true
// 	if your datawindow already has a where with the project, send false
//
	u_query.setAddProjectToWhere( FALSE )
	iWindow = this
	u_query.initialize( iWindow )

// manipulate the criteria here
	 setCriteriaDW()
	
// open the status multi select object
	openuserobject( StatusSelect,2325,0 )
	StatusSelect.height = 265
	StatusSelect.uf_init("d_ord_status_search_list", "delivery_master.Ord_Status", "ord_status")
	StatusSelect.bringtotop= true

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
string StatusSelectSQL
long rows

if u_query.sqlutil.CreateWhereFromDW( u_query.dw_select ) = -1 then return 

StatusSelectSQL =  StatusSelect.uf_build_search(true)
if not isNull( StatusSelectSQL ) and len( StatusSelectSQL ) > 0 then
	StatusSelectSQL = right( StatusSelectSQL, len( StatusSelectSQL) -5 ) // strip off the AND
	u_query.sqlutil.setNewWhere( StatusSelectSQL )
end if
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

event ue_clear;call super::ue_clear;StatusSelect.uf_clear_list()



end event

type dw_select from w_std_query_window`dw_select within w_pandora_outbound_order_report
end type

type cb_clear from w_std_query_window`cb_clear within w_pandora_outbound_order_report
end type

type dw_report from w_std_query_window`dw_report within w_pandora_outbound_order_report
end type

