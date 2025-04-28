$PBExportHeader$w_pandora_serials_in_bins.srw
$PBExportComments$Pandora Intransit report
forward
global type w_pandora_serials_in_bins from w_std_report
end type
end forward

global type w_pandora_serials_in_bins from w_std_report
integer width = 4128
integer height = 2080
string title = "Pandora Serials in BINS report"
end type
global w_pandora_serials_in_bins w_pandora_serials_in_bins

type variables
//inet	linit
//u_nvo_websphere_post	iuoWebsphere
String		is_OrigSql
string   	is_select
string   	is_groupby
string   	is_warehouse_code
string   	is_warehouse_name
datastore 	ids_find_warehouse
datastore	ids_owner
boolean 		ib_first_time, ib_from_date_first, ib_to_date_first

end variables

on w_pandora_serials_in_bins.create
call super::create
end on

on w_pandora_serials_in_bins.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() - 130, workspaceHeight() - 400)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

// Per Dave - clear out results set
is_warehouse_code = '%'
dw_report.Reset()

end event

event ue_retrieve;long llRtn


w_main.setMicroHelp('Retrieving report ...')

IF IsNull(is_warehouse_code) or TRIM(is_warehouse_code) = '' THEN 
	is_warehouse_code = '%'   // Force code to be 'everything'
END IF

llRtn = dw_report.retrieve( gs_project, is_warehouse_code )

w_main.setMicroHelp( string(llRtn) + ' records retrieved')

end event

event ue_postopen;DatawindowChild	ldwc_warehouse, ldwc, ldwc_owner_cd
string	lsFilter
LONG     l_owner_cd_rows, l_owner_rowcount 

idw_current = dw_Report

// populate an instance ds of owner ids and codes

ids_owner = CREATE datastore
ids_owner.DataObject = 'd_ds_owner'
ids_owner.SetTransObject(SQLCA)
l_owner_rowcount = ids_owner.retrieve(gs_project)

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)

dw_select.GetChild('owner_cd', ldwc_owner_cd)
ldwc_owner_cd.SetTransObject(sqlca)

//If ldwc_warehouse.Retrieve(gs_project) > 0 Then
//	
//	//Filter Warehouse dropdown by Current Project
//	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
//	ldwc_warehouse.SetFilter(lsFilter)
//	ldwc_warehouse.Filter()
//	
//	is_warehouse_code = ldwc_warehouse.GetItemString( 1, 'wh_code' )
//	
//	//Wait to retrieve the owner - dependent upon warehouse selected	
//	
//Else
//	// shouldn't be possible to get here but - 
//	is_warehouse_code = '%'
//
//End If

// LTK 20150908  Commented out block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
dw_select.GetChild("warehouse", ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_warehouse)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "warehouse", gs_default_wh)
end if

long ll_current_row
ll_current_row = ldwc_warehouse.GetRow()
if ll_current_row = 0 then
	ll_current_row = 1
end if
is_warehouse_code = ldwc_warehouse.GetItemString( ll_current_row, 'wh_code' )


//This.TriggerEvent('ue_retrieve')    // Per Roy & Dave - don't do the auto-retrieve

end event

event ue_print;call super::ue_print;dw_report.print( )
end event

event open;call super::open;Integer  li_pos

is_OrigSql = dw_report.getsqlselect()


end event

type dw_select from w_std_report`dw_select within w_pandora_serials_in_bins
string tag = "Warehouse"
integer x = 59
integer y = 4
integer width = 1847
integer height = 204
string dataobject = "d_pandora_warehouse_owner_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::itemchanged;call super::itemchanged;// based upon selection filter the dw_report window

DatawindowChild ldwc_owner_cd
string lsWhsCode
string lsGrp = 'CB%'  // hardcoded to CityBlock at this time
LONG   l_owner_id
LONG   lRow
LONG	 lRtn

dw_select.GetChild('owner_cd', ldwc_owner_cd)

CHOOSE CASE dwo.name 
		
	CASE 'owner_cd'
		
		lsWhsCode = this.Getitemstring( row, 'warehouse')
		lRow = ids_owner.Find("owner_cd = '" + data + "'", 1, ids_owner.RowCount() )

		IF lRow >= 1 THEN
			l_owner_id = ids_owner.GetItemNumber( lRow, 'owner_id')
			
			dw_report.Setredraw( FALSE )
			// dw_report.SetFilter("rp_owner_id = " + string(l_owner_id) + " ")
			dw_report.SetFilter("owner_cd = '" + data + "'" )
			dw_report.Filter( )
			dw_report.SetRedraw( TRUE )
			
		END IF
		
		
	CASE 'warehouse'
		lsWhsCode = TRIM(data)
		IF IsNull(lsWhsCode) or (lsWhsCode = '') THEN lsWhsCode = '%'
		
		is_warehouse_code = lsWhsCode

		// need to cause a retrieve on the owner_cd (cust_cd) dddw
		lRtn = ldwc_owner_cd.reset()
		lRtn = ldwc_owner_cd.retrieve(lsWhsCode, lsGrp )
		
		// change from filter to retrieve per Dave		
//		dw_report.Setredraw( FALSE )
//		dw_report.SetFilter("rm_wh_code = '" + lsWhsCode + "' ")
//		dw_report.Filter( )
//		dw_report.SetRedraw( TRUE )

		dw_report.reset()
		// clear any existing filter
		dw_report.SetFilter('')
		dw_report.Filter()
		Parent.TriggerEvent('ue_retrieve')		//dw_report.retrieve( 'PANDORA', lsWhsCode )
		
END CHOOSE

return 0



end event

type cb_clear from w_std_report`cb_clear within w_pandora_serials_in_bins
integer x = 4279
integer y = 8
integer width = 261
integer taborder = 20
end type

event cb_clear::clicked;call super::clicked;// clear the warehouse and owner codes
is_warehouse_code = '%'

end event

type dw_report from w_std_report`dw_report within w_pandora_serials_in_bins
integer y = 240
integer width = 3977
integer height = 1572
integer taborder = 30
string dataobject = "d_pandora_serials_in_bins_rpt"
boolean hscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
end type

