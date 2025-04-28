$PBExportHeader$w_empty_location_rpt.srw
$PBExportComments$Window used for processing the empty location report
forward
global type w_empty_location_rpt from w_std_report
end type
end forward

global type w_empty_location_rpt from w_std_report
boolean visible = false
integer width = 3653
integer height = 2108
string title = "Empty Location Report"
boolean clientedge = true
event ue_not_show_alloc ( )
end type
global w_empty_location_rpt w_empty_location_rpt

type variables
string is_origsql, is_where
string is_groupby
string is_select, isNewSQL
string       is_warehouse_code
string       is_warehouse_name
boolean ib_first_time
datastore ids_find_warehouse


boolean ib_show_allocated = false

end variables

event open;call super::open;Integer  li_pos
integer  li_pos2, li_where_pos

is_OrigSql = dw_report.getsqlselect()

//li_pos = pos(is_origsql,"GROUP BY",1)
//messagebox("li pos", li_pos)

is_groupby = mid(is_origsql,473)
//messagebox("is groupby", is_groupby)


is_select = mid(is_origsql,1,473)
//messagebox("is_select", is_select)




end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc_warehouse


//populate dropdowns - not done automatically since dw not being retrieved

//dw_select.GetChild('warehouse', ldwc_warehouse)
//ldwc_warehouse.SetTransObject(Sqlca)
//ldwc_warehouse.Retrieve(gs_project)
//dw_report.Object.project.text = gs_project
// PANDORA #999  LTK 20150916  Comment out above code as this is duplicate logic from the search DW constructor

//Filter Warehouse dropdown by Current Project
//lsFilter = "project_id = '" + gs_project + "'"
//ldwc_warehouse.SetFilter(lsFilter)
//ldwc_warehouse.Filter()
end event

event ue_retrieve;String ls_Where, ls_group
String ls_NewSql
string ls_warehouse
string ls_warehouse_name
string ls_sloc
string ls_eloc,ls_syntax
string ls_selection
String ls_lcode, ls_sku
integer li_find_endwhere_pos, li_find_group_pos
long ll_row
long ll_find_row
long ll_number
long ll_cnt,ll_priority
Long ll_alloc_rowfind, ll_alloc_qty, ll_pick, ll_pack

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)

integer li_show_allocated

li_show_allocated = dw_select.GetItemNumber( 1, "show_allocated")

If IsNull(li_show_allocated) then li_show_allocated = 0

dw_report.Object.show_allocated.Expression = string(li_show_allocated)

if li_show_allocated = 1  then
	ib_show_allocated = true
	dw_report.DataObject = 'd_empty_location_rpt_show_alloc'
	dw_report.SetTransObject(SQLCA)
	dw_report.Object.show_allocated.Expression = string(li_show_allocated)	
else
	ib_show_allocated = false
	dw_report.DataObject = 'd_empty_location_rpt_not_show_alloc'
	dw_report.SetTransObject(SQLCA)
	dw_report.Object.show_allocated.Expression = string(li_show_allocated)	
end if

dw_report.Reset()

//Process Warehouse Number
is_warehouse_code = dw_select.GetItemString(1,"warehouse")
ls_sloc = dw_select.GetItemString(1,"sloc")
ls_eloc = dw_select.GetItemString(1,"eloc")
IF ib_first_time  = TRUE THEN
  	
	//is_warehouse_code = dw_select.GetItemString(1,"warehouse")  
	ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
	IF ll_find_row > 0 THEN
		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
		dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
	ELSE
		ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_name + "'",&
																1,ids_find_warehouse.RowCount())		
		IF ll_find_row > 0 THEN
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
		END IF
					
	END IF
	ib_first_time = false
	
ELSE
  	is_warehouse_code = dw_select.GetItemString(1,"warehouse")
	ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
																
	IF ll_find_row > 0 THEN
		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
		dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)				
		
	ELSE
		ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)	
			
		END IF
	END IF
END IF

// 07/00 PCONKL - Only show locations that are unreserved or reserved for current project
// 07/25 LKMAY  - Added this logic in Main SQL of Datawindow
//ls_where += " and (project_reserved = null or project_reserved = '" + gs_project + "') "
IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
	MessageBox("ERROR", "Please select a warehouse",stopsign!)
ELSE
	//DGM Changes madefor adding priority as selection criteria
	dw_report.SetRedraw(False)
	dw_report.SetFilter("")
	ll_cnt = dw_report.Retrieve(gs_project,is_warehouse_code, ls_sloc, ls_eloc)
	ll_priority = dw_select.object.priority[1]
	IF ll_cnt > 0 and ll_priority > 0 THEN
		
		ls_syntax = "priority = " + string(ll_priority) 
		dw_report.SetFilter(ls_syntax)
		dw_report.Filter()
		ll_cnt= dw_report.RowCount()
	END IF
	dw_report.SetRedraw(True)

	IF ll_cnt > 0 Then
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
	Else
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
	End If
END IF

//JXLIM 04/23/2010
//For show allocation, after the datawindow has been retrieved, 
//we will want to populate the “pick_qty” and “pack_qty’ fields only if the “Show Allocated” Checkbox is checked on the search screen. 
//Loop through each report row and rows where the “alloc_Qty” field is > 0,
//we will want to perform 2 inline SQL statements to populate the fields
IF ib_show_allocated THEN	
		IF ll_cnt > 0 THEN
			For ll_alloc_rowfind = 1 to ll_cnt
				IF  ll_alloc_rowfind > ll_cnt THEN EXIT			
				ll_alloc_rowfind = dw_report.Find ("alloc_qty > 0", ll_alloc_rowfind ,  ll_cnt)
					IF ll_alloc_rowfind <= 0 THEN EXIT	
					//if alloc_qty field > 0 then get the total of the alloc_qty
					IF ll_alloc_rowfind > 0 THEN						    
									ls_lcode = dw_report.Getitemstring(ll_alloc_rowfind , "l_code")
									ls_sku    = dw_report.Getitemstring(ll_alloc_rowfind , "sku")
									// put it into pick_qty so it an populated on the report for pick_qty field
									Select Sum(quantity) Into :ll_pick
									From Delivery_Master, Delivery_Picking
									Where delivery_master.Project_id = :gs_project 
									And Delivery_Master.do_no = Delivery_Picking.do_no								
									And ord_status IN ('P', 'I')								
									And Delivery_Picking.l_code = :ls_lcode
									And Delivery_Picking.sku_parent = :ls_sku;									
									//Populate Pick_qty
										IF ll_pick > 0 THEN
											dw_report.SetItem(ll_alloc_rowfind, "pick_qty", ll_pick)										
										END IF						
									  
									// put it into pack_qty so it an populated on the report for pack_qty field
									Select Sum(quantity) INTO: ll_pack
									From Delivery_Master, Delivery_Picking
									Where delivery_master.Project_id = :gs_project 
									And Delivery_Master.do_no = Delivery_Picking.do_no
									And ord_status = 'A'									
									And Delivery_Picking.l_code = :ls_lcode
									And Delivery_Picking.sku_parent = :ls_sku;						
									
									//Populate pack qty							
										IF ll_pack > 0 THEN
											dw_report.SetItem(ll_alloc_rowfind, "pack_qty", ll_pack)									
										END IF																							
					END IF
				NEXT				
			END IF			
END IF

//JXLIM 04/23/2010 the end of code.
end event

on w_empty_location_rpt.create
call super::create
end on

on w_empty_location_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-175)
end event

type dw_select from w_std_report`dw_select within w_empty_location_rpt
integer x = 32
integer y = 4
integer width = 3525
integer height = 144
string dataobject = "d_warehouse_emptyloc"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;long		ll_row
long		ll_find_row

string 	ls_value



//Create the locating warehouse name datastore
ids_find_warehouse = CREATE Datastore 
ids_find_warehouse.dataobject = 'd_find_warehouse'
ids_find_warehouse.SetTransObject(SQLCA)
ids_find_warehouse.Retrieve()

ll_row = This.insertrow(0)
ib_first_time = true


//dw_select.SetItem(ll_row,"warehouse",gs_default_wh)
//ls_value = dw_select.GetItemString(ll_row,"warehouse")
//
//ll_find_row = ids_find_warehouse.Find ("wh_code = '" + ls_value + "'",&
//																1,ids_find_warehouse.RowCount())
//IF ll_find_row > 0 THEN
//	is_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
//	is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
//	dw_select.SetItem(ll_row,"warehouse",is_warehouse_name)
//	
//END IF

// LTK 20150908  Commented out block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
DataWindowChild ldwc_warehouse
dw_select.GetChild("warehouse", ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_warehouse)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "warehouse", gs_default_wh)
end if
end event

type cb_clear from w_std_report`cb_clear within w_empty_location_rpt
integer x = 3141
integer y = 240
end type

type dw_report from w_std_report`dw_report within w_empty_location_rpt
integer x = 14
integer y = 156
integer width = 3534
integer height = 1712
string dataobject = "d_empty_location_rpt_show_alloc"
boolean maxbox = true
boolean hscrollbar = true
end type

event dw_report::sqlpreview;call super::sqlpreview;//JXLIM 04/22/2010 Commented out all of the code in the “sqlpreview” event. This is redundant since the SQL in the datawindow is now using Content_Summary instead of Content.
//
//String ls_syntax, lsNewSQL
//ls_syntax = sqlsyntax
//integer li_Pos
//
//integer li_find_priority_pos, li_find_from_pos
//
//
////Make SQL changes to include new columns - only change SQL if show allocated is checked.
////Please be careful when changing SQL.
////I did this to prevent creating two datawindows.
////This was a special change for PHX-BRANDS.
//
//if ib_show_allocated then
//	
//	lsNewSQL = sqlsyntax
//	
//	li_pos = 0
//	
//	//Loop through and use content_summary instead of content.
//	
//	do
//		
//		li_pos = Pos(upper(lsNewSQL), "CONTENT",  li_pos + 15)
//		
//		if li_Pos > 0 then
//			
//			lsNewSQL = left(lsNewSQL, li_pos + 6) + "_summary" + mid(lsNewSQL, li_pos + 7)
//			
//		end if
//		
//	loop until li_pos <= 0
//	
//	//Include content_summary alloc_qty and sku
//	
//	li_find_priority_pos = Pos(lsNewSQL, "Location.Priority,", 1) + Len("Location.Priority,") + 1
//	li_find_from_pos = Pos(lsNewSQL, "FROM", 1) - 1
//
//	
//	lsNewSQL = left( lsNewSQL, li_find_priority_pos) + &
//				"			alloc_qty = content_summary.alloc_qty, sku = content_summary.sku " + &
//				mid( lsNewSQL, li_find_from_pos) 
//	
//	//Add these two columns to the GROUP BY
//	
//	li_Pos = Pos(Upper(lsNewSQL), "HAVING") - 1
//	
//	lsNewSQL = left( lsNewSQL, li_Pos) + &
//				" , content_summary.alloc_qty, content_summary.sku " + &
//				mid( lsNewSQL, li_Pos + li_Pos ) 	
//	
//	
//	
//	this.SetSQLPreview( lsNewSQL)
//	
//	
//
//end if

//messagebox("", sqlsyntax)
//clipboard(sqlsyntax)
end event

