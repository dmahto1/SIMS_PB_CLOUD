$PBExportHeader$w_gm_mi_dat_last_on_hand_rpt.srw
forward
global type w_gm_mi_dat_last_on_hand_rpt from w_std_report
end type
end forward

global type w_gm_mi_dat_last_on_hand_rpt from w_std_report
integer width = 3397
integer height = 1516
string title = "last On Hand Report"
end type
global w_gm_mi_dat_last_on_hand_rpt w_gm_mi_dat_last_on_hand_rpt

type variables
datastore idsskureserved
datastore idsMaxPick
datastore ids_find_warehouse

boolean ib_first_time

string isselect
string is_warehouse_name
string is_warehouse_code


end variables

forward prototypes
public subroutine setselect (string asselect)
public function string getselect ()
public subroutine doexcelexport ()
end prototypes

public subroutine setselect (string asselect);// setSelect( string asSelect )
isSelect = asSelect 

end subroutine

public function string getselect ();// string = getSelect()
return isSelect

end function

public subroutine doexcelexport ();// doExcelExport()
long rows

u_dwexporter exportr

rows = dw_report.rowcount()
if rows > 0 then 
	exportr.initialize()
	exportr.doExcelExport( dw_report, rows, true  )	
	exportr.cleanup()
end if



end subroutine

on w_gm_mi_dat_last_on_hand_rpt.create
call super::create
end on

on w_gm_mi_dat_last_on_hand_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;

idsskureserved = f_datastoreFactory( 'd_gm_mi_dat_sku_reserved_no_content' )
idsmaxpick = f_datastoreFactory( 'd_max_completion_date_by_proj_loc' )

setSelect(  idsskureserved.getsqlselect() )

end event

event ue_retrieve;call super::ue_retrieve;long rows
long index
long maxDateRows
long newRow
Long i
long ll_cnt
long ll_find_row

string sLocation
string sSKU
String ls_Where
String ls_NewSql
string ls_value
string ls_warehouse_name
datetime dtMaxDate
setPointer( Hourglass! )

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
	return
end if

dw_report.setredraw( false )

rows = idsSkuReserved.retrieve( gs_project, is_warehouse_code )

for index = 1 to rows
	sLocation = idsSkuReserved.object.l_code[ index ]
	sSKU = idsSkuReserved.object.location_sku_reserved[ index ]
	maxDateRows = idsmaxpick.retrieve( gs_project, sSKU )
	if maxDateRows <= 0 then continue
	dtMaxDate = idsMaxPick.object.max_complete_date[ 1 ]
	newRow = dw_report.insertrow(0)
	dw_report.object.location[ newRow ] = sLocation
	dw_report.object.reserved_sku[ newRow ] = sSKU
	dw_report.object.last_pick_date[ newRow ] = dtMaxDate
	dw_report.object.days_without_content[ newRow ] = DaysAfter( date( dtMaxDate ), today() )
next

dw_report.object.t_proj.text = gs_project
dw_report.object.t_warehouse.text = is_warehouse_code

ll_cnt = dw_report.rowcount()

If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If
is_warehouse_code = " "

dw_report.setredraw( true )


end event

event ue_close;call super::ue_close;
if isvalid ( idsskureserved ) then destroy idsskureserved
if isvalid ( idsmaxpick ) then destroy idsmaxpick

end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event resize;call super::resize;dw_report.event ue_resize()

end event

event ue_file;String	lsOption

lsoption = Message.StringParm

Choose Case lsoption
		

	Case "PRINTPREVIEW" /*print preview window*/
		
		OpenwithParm(w_printzoom,dw_report)
			
	// pvh - 09/06/05				
	Case "SAVEAS" /*Export*/
		if messagebox( "Save As", "Export to Excel?",question!,yesno!) = 1 then
			doExcelExport(  )
		else
			dw_report.Saveas()
		end if
	// eom	
		
End Choose
end event

type dw_select from w_std_report`dw_select within w_gm_mi_dat_last_on_hand_rpt
integer x = 0
integer width = 3305
integer height = 88
string dataobject = "d_gm_mi_dat_warehouse"
boolean border = false
end type

event dw_select::constructor;call super::constructor;long		ll_row
long		ll_find_row

string 	ls_value
string	ls_warehouse_name


//Create the locating warehouse name datastore
ids_find_warehouse =  f_datastoreFactory( 'd_find_warehouse')
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

type cb_clear from w_std_report`cb_clear within w_gm_mi_dat_last_on_hand_rpt
integer x = 3570
integer y = 760
integer width = 78
integer height = 56
end type

type dw_report from w_std_report`dw_report within w_gm_mi_dat_last_on_hand_rpt
event ue_resize ( )
integer x = 0
integer y = 104
integer height = 1196
string dataobject = "d_gm_mi_dat_sku_reserved_ext_rpt"
end type

event dw_report::ue_resize();this.width = (parent.width - 50)
this.height = ( parent.height - ( dw_select.height + 192 ) )

end event

