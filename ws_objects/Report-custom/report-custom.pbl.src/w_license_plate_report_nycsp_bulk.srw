$PBExportHeader$w_license_plate_report_nycsp_bulk.srw
forward
global type w_license_plate_report_nycsp_bulk from w_std_report
end type
end forward

global type w_license_plate_report_nycsp_bulk from w_std_report
integer width = 3488
integer height = 2044
string title = "License Plate Report Bulk"
end type
global w_license_plate_report_nycsp_bulk w_license_plate_report_nycsp_bulk

type variables
DataWindowChild idwc_warehouse,idwc_supp

boolean ib_movement_from_first
boolean ib_movement_to_first
boolean ib_select_sku
boolean ib_select_date_start
boolean ib_select_date_end

String	isoriqsqldropdown
end variables

on w_license_plate_report_nycsp_bulk.create
call super::create
end on

on w_license_plate_report_nycsp_bulk.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;// Begin - Dinesh - 31/08/2021- S53676-NYCSP -SIMS - NYCSP License Plate Report – BULK
String ls_whcode, ls_sku, ls_supp,ls_floc,ls_tloc,ls_cont
long ll_cnt


If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

//Remove filter if any thing already there
dw_report.SetFilter("")
dw_report.Filter()

ls_whcode = dw_select.GetItemString(1, "wh_code")
//ls_sku = dw_select.GetItemString(1, "sku")
//ls_supp = '%' + dw_select.GetItemString(1, "supp_code") + '%' //01-Apr-2014 :Madhu commented
ls_floc = dw_select.GetItemString(1, "f_loc")
ls_tloc = dw_select.GetItemString(1, "t_loc")
ls_cont = '%' + dw_select.GetItemString(1, "cont") + '%'
//
////Check if sku has been entered
//if  isnull(ls_sku) or len (ls_sku) <= 0 then
//	Messagebox(is_title,"Please enter a valid SKU...")
//	Return 
////else 
////	IF isnull(ls_supp) or ls_supp = "" then 
////		Messagebox(is_title,"Please enter a Supplier...")
////		Return 
////	END IF	
//END IF

if  isnull(ls_floc) or len (ls_floc) <= 0 then ls_floc = '0'
if  isnull(ls_tloc) or len (ls_tloc) <= 0 then ls_tloc = 'z'
if  isnull(ls_cont) or len (ls_cont) <= 0 then ls_cont = '%'
//if  isnull(ls_supp) or len (ls_supp) <= 0 then ls_supp = '%' //01-Apr-2014 :Madhu -commented


//ll_cnt = dw_report.Retrieve(gs_project, ls_sku,ls_whcode, ls_supp,ls_cont,ls_floc,ls_tloc) //01-Apr-2014 :Madhu- commented
ll_cnt = dw_report.Retrieve(gs_project,ls_whcode,ls_cont,ls_floc,ls_tloc)  //01-Apr-2014 :Madhu - added

ll_cnt=dw_report.Rowcount()

If ll_cnt > 0 Then
	dw_report.modify('DataWindow.Print.Preview ="yes"')
	im_menu.m_file.m_print.Enabled = True
	
	dw_report.SetRedraw(True)
end if

// End - Dinesh - 31/08/2021- S53676-NYCSP -SIMS - NYCSP License Plate Report – BULK
end event

event ue_clear;dw_select.Reset()
dw_report.Reset()
dw_select.InsertRow(0)
If idwc_warehouse.RowCount() > 0 Then
	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
End If

end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_postopen;call super::ue_postopen;// Begin - Dinesh - 31/08/2021- S53676-NYCSP -SIMS - NYCSP License Plate Report – BULK
string	lsFilter
DatawindowCHild	ldwc

dw_select.GetChild('supp_code', idwc_supp)
dw_select.GetChild('wh_code', idwc_warehouse)

dw_report.GetChild('inv_type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)

idwc_warehouse.SetTransObject(sqlca)
idwc_supp.SetTransObject(sqlca)

idwc_supp.Insertrow(0)

If idwc_warehouse.Retrieve(gs_Project) > 0 Then
	
//	//Filter Warehouse dropdown by Current Project
//	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
//	idwc_warehouse.SetFilter(lsFilter)
//	idwc_warehouse.Filter()

	dw_select.SetItem(1, "wh_code" , gs_default_wh)
	
End If

isoriqsqldropdown = idwc_supp.GetSqlselect()

 //TAM 04/29/2011  For Wine and Spirit they want All supplier codes
string lsddsql
	If Left(gs_project,3) = 'WS-' Then
		lsDDSQl = Replace(isoriqsqldropdown,pos(isoriqsqldropdown,"xxxxxxxxxx' ) AND"),17,gs_project + "'))")
		lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,"( Item_Master.SKU = 'zzzzzzzzzz' ) )"),36,'')
		lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,"SELECT"),6,'Select Distinct')
		idwc_supp.SetSqlSelect(lsDDSQL)
		idwc_supp.Retrieve()
	END IF	
// End - Dinesh - 31/08/2021- S53676-NYCSP -SIMS - NYCSP License Plate Report – BULK
end event

type dw_select from w_std_report`dw_select within w_license_plate_report_nycsp_bulk
integer x = 18
integer width = 3319
string dataobject = "d_license_plate_search_nycsp_bulk"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;ib_movement_from_first 	= TRUE
ib_movement_to_first 	= TRUE
ib_select_sku 				= FALSE
ib_select_date_start 	= FALSE
ib_select_date_end   	= FALSE
end event

event dw_select::clicked;// Begin - Dinesh - 31/08/2021- S53676-NYCSP -SIMS - NYCSP License Plate Report – BULK
string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "s_date"
		
		IF ib_movement_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("s_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_movement_from_first = FALSE
			
		END IF
		
	CASE "e_date"
		
		IF ib_movement_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("e_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_movement_to_first = FALSE
			
		END IF
		
	CASE ELSE
		
END CHOOSE
// End - Dinesh - 31/08/2021- S53676-NYCSP -SIMS - NYCSP License Plate Report – BULK

end event

event dw_select::itemchanged;//long ll_rtn
//String	lsDDSQl
//
//IF dwo.name = 'sku' THEN
//	ll_rtn=i_nwarehouse.of_item_sku(gs_project,data)
//	IF ll_rtn = 1 THEN 
//		this.object.supp_code[row] = i_nwarehouse.ids_sku.object.supp_code[1]
//		post f_setfocus(dw_select,row,'supp_code')
//	ELSEIF ll_rtn > 1 THEN
//		lsDDSQl = Replace(isoriqsqldropdown,pos(isoriqsqldropdown,'xxxxxxxxxx'),10,gs_project)
//		lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,'zzzzzzzzzz'),10,data)
//		idwc_supp.SetSqlSelect(lsDDSQL)
//		idwc_supp.Retrieve()
//		
//	ELSE
//		Messagebox(is_title,"Invalid Sku please Re-enter")
//		post f_setfocus(dw_select,row,'sku')
//		Return 2
//	END IF	
//END IF	
//
////IF dwo.name = 'supp_code' THEN  //TAM 04/29/2011  For Wine and Spirit they want All supplier codes
////	If Left(gs_project,3) = 'WS-)' Then
////		lsDDSQl = Replace(isoriqsqldropdown,pos(isoriqsqldropdown,"xxxxxxxxxx' ) AND"),17,gs_project)
////		lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,"( Item_Master.SKU = 'zzzzzzzzzz' ) )"),36,'')
////		idwc_supp.SetSqlSelect(lsDDSQL)
////		idwc_supp.Retrieve()
////	END IF	
////END IF	
////
end event

type cb_clear from w_std_report`cb_clear within w_license_plate_report_nycsp_bulk
integer x = 3154
integer y = 12
integer width = 270
end type

event cb_clear::clicked;call super::clicked;If idwc_warehouse.RowCount() > 0 Then
	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
End If

end event

type dw_report from w_std_report`dw_report within w_license_plate_report_nycsp_bulk
integer y = 188
integer width = 3401
integer height = 1704
string dataobject = "d_license_plate_report_nycsp_bulk"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

