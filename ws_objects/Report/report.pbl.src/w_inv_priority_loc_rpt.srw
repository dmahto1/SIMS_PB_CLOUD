$PBExportHeader$w_inv_priority_loc_rpt.srw
$PBExportComments$Window used for Location Master Report
forward
global type w_inv_priority_loc_rpt from w_std_report
end type
end forward

global type w_inv_priority_loc_rpt from w_std_report
integer width = 3584
integer height = 2116
string title = "Location Master Report"
end type
global w_inv_priority_loc_rpt w_inv_priority_loc_rpt

type variables
string is_select
String	is_OrigSql
string       is_groupby
string       is_warehouse_code
string      is_warehouse_name
boolean  ib_first_time
datastore ids_find_warehouse
end variables

event open;call super::open;//messagebox("gs project id", gs_project)
//messagebox("gs warehouse",gs_default_wh)

//12/07 - PCONKL - made changes for GM - pretty sure they wre the only ones using the report but just in case, seperate DW for them
if gs_project = 'GM_MI_DAT' Then
	dw_report.dataobject = 'd_gm_inv_priority_location_rpt'
	dw_report.SetTransObject(SQLCA)
End If

is_select = dw_report.getsqlselect()

end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-175)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_retrieve;
String ls_Where
String ls_NewSql
string ls_value
string ls_warehouse_name

Long i
long ll_cnt
long ll_find_row

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()



//Process Warehouse Number
IF ib_first_time  = TRUE THEN
  	is_warehouse_code = dw_select.GetItemString(1,"warehouse")
	  
	ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
	IF ll_find_row > 0 THEN
		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
		
	ELSE
		ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN													
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
		
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
					
	else
		ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			
		END IF
	END IF
END IF

IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
	MessageBox("ERROR", "Please select a warehouse",stopsign!)
ELSE

	ll_cnt = dw_report.Retrieve(gs_project, is_warehouse_code)
	dw_report.object.t_warehouse.Text = is_warehouse_code
	If ll_cnt > 0 Then
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
	Else
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
	End If
	is_warehouse_code = " "

END IF



end event

on w_inv_priority_loc_rpt.create
call super::create
end on

on w_inv_priority_loc_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_postopen;call super::ue_postopen;
DatawindowChild	ldwc_warehouse
String	lsFilter

dw_report.object.t_project.text = gs_project


//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(Sqlca)
//ldwc_warehouse.Retrieve(gs_project)

//ldwc_warehouse.InsertRow(0)
g.of_set_warehouse_dropdown(ldwc_warehouse)

If gs_default_WH > '' Then
	dw_select.SetITem(1,'warehouse',gs_default_WH) /* 04/04 - PCONKL - Warehouse now reauired field on search to keep users within their domain*/
End IF
end event

type dw_select from w_std_report`dw_select within w_inv_priority_loc_rpt
integer x = 32
integer height = 108
string dataobject = "d_warehouse"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;long		ll_row
long		ll_find_row

string 	ls_value
string	ls_warehouse_name


//Create the locating warehouse name datastore
ids_find_warehouse = CREATE Datastore 
ids_find_warehouse.dataobject = 'd_find_warehouse'
ids_find_warehouse.SetTransObject(SQLCA)
ids_find_warehouse.Retrieve()

ll_row = This.insertrow(0)
ib_first_time = true


dw_select.SetItem(ll_row,"warehouse",gs_default_wh)
ls_value = dw_select.GetItemString(ll_row,"warehouse")

ll_find_row = ids_find_warehouse.Find ("wh_code = '" + ls_value + "'",&
																1,ids_find_warehouse.RowCount())
IF ll_find_row > 0 THEN
	is_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
	is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
	dw_select.SetItem(ll_row,"warehouse",is_warehouse_name)
	
END IF

end event

type cb_clear from w_std_report`cb_clear within w_inv_priority_loc_rpt
end type

type dw_report from w_std_report`dw_report within w_inv_priority_loc_rpt
integer x = 23
integer y = 116
integer width = 3502
integer height = 1800
string dataobject = "d_inv_priority_location_rpt"
boolean hscrollbar = true
end type

