HA$PBExportHeader$w_eta_maint.srw
$PBExportComments$Maintain eta calculation data.
forward
global type w_eta_maint from w_std_master_detail
end type
type cb_add_tt_row from commandbutton within tabpage_main
end type
type cb_deleterow from commandbutton within tabpage_main
end type
type dw_detail from u_dw_ancestor within tabpage_main
end type
type cb_owner from commandbutton within tabpage_main
end type
type dw_main from u_dw_ancestor within tabpage_main
end type
type cb_search from commandbutton within tabpage_search
end type
type cb_1 from commandbutton within tabpage_search
end type
type dw_query from u_dw_ancestor within tabpage_search
end type
type dw_search from u_dw_ancestor within tabpage_search
end type
type cb_fix_data from commandbutton within tabpage_search
end type
end forward

global type w_eta_maint from w_std_master_detail
boolean visible = false
integer width = 3232
integer height = 2244
string title = "Transit Time Maintenance"
boolean resizable = false
end type
global w_eta_maint w_eta_maint

type variables
Datawindow idw_main, idw_search, idw_query
//, idw_sku 
DataWindow	idw_Detail

//, idw_component_child,  idw_storage_Rule

//Boolean	ibSupplierUpdate,ibSupplierChanged
boolean ibInserting

//Private Boolean ib_dimentions
//n_warehouse i_nwarehouse
string i_sql, is_origSQL, isOriqSqlDropdown//, isUpdateSql[]
//w_maintenance_itemmaster iw_window
w_eta_maint iw_window
//Long	ilDedLocRow

string is_wh, is_carrier, is_country
end variables

forward prototypes
public function integer wf_validation ()
end prototypes

public function integer wf_validation ();integer liCnt, i, liTransitTime
string lsWH, lsCar, lsCntry, lsZipStart, lsZipEnd, lsColumn

If idw_main.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	Return -1
End If
If idw_detail.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_detail.SetFocus()
	Return -1
End If
  
 // Check if all required fields are filled
If f_check_required(is_title, idw_main) = -1 Then
	tab_main.SelectTab(1) 
	Return -1
End If

If f_check_required(is_title, idw_detail) = -1 Then
	tab_main.SelectTab(1) 
	Return -1
End If

if idw_main.GetItemString(1, 'Depart_Sunday') = "N" and &
	idw_main.GetItemString(1, 'Depart_Monday') = "N" and &
	idw_main.GetItemString(1, 'Depart_Tuesday') = "N" and &
	idw_main.GetItemString(1, 'Depart_Wednesday') = "N" and &
	idw_main.GetItemString(1, 'Depart_Thursday') = "N" and &
	idw_main.GetItemString(1, 'Depart_Friday') = "N" and &
	idw_main.GetItemString(1, 'Depart_Saturday') = "N"  then
		messagebox (is_title, "Warning: You have no departure days defined for this Carrier-Country.", Exclamation!)
end if


if ibInserting then
	lsWH = idw_main.GetItemString(1, 'WH_Code')
	lsCar = idw_main.GetItemString(1, 'Carrier_Code')
	lsCntry = idw_main.GetItemString(1, 'Country_Code')
	
	select count(project_id) into :liCnt
	from carrier_country
	where project_id = :gs_project
	and wh_code = :lsWH
	and carrier_code = :lsCar
	and country_code = :lsCntry
	using sqlca;
	
	if liCnt > 0 then
		messagebox (is_title, "Can not insert duplicate Carrier-Country record.", Exclamation!)
		return -1
	end if
	
end if

/*
//Other Required Fields
If isnull(idw_main.GetITemString(1,'wh_code')) or idw_main.GetITemString(1,'wh_code') = '' Then
	messagebox(is_title, 'Warehouse is Required')
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	idw_main.SetColumn('wh_Code')
	Return -1
End If
*/

//scroll through detail and delete any blank lines (or prompt if any single field is blank)

//sort data window so we can check for over-lapping ranges.
idw_detail.SetSort("Zip_Range_Start")
idw_detail.sort()
liCnt = idw_detail.RowCount()
For i = 1 to liCnt
	lsZipStart = trim(idw_detail.GetItemString(i, "zip_range_start"))
	if lsZipStart <= lsZipEnd then
		messagebox(is_Title, "Warning: Over-lapping zip ranges!")
	end if
	lsZipEnd = trim(idw_detail.GetItemString(i, "zip_range_end"))
	liTransitTime = idw_detail.GetItemNumber(i, "transit_time")
	if (lsZipStart="" or isnull(lsZipStart)) and (lsZipEnd="" or isnull(lsZipEnd)) and isnull(liTransitTime) then //all are null/empty...
		//delete empty row and decrease counts to get to Invalid Row.
		idw_detail.DeleteRow(i)
		liCnt = liCnt - 1
		i = i - 1
	elseif (lsZipStart="" or isnull(lsZipStart)) or (lsZipEnd="" or isnull(lsZipEnd)) or isnull(liTransitTime) then //at least one is null/empty...
		if lsZipStart="" or isnull(lsZipStart) then
			lsColumn = "Zip_Range_Start"
		elseif lsZipEnd="" or isnull(lsZipEnd) then
			lsColumn = "Zip_Range_End"
		elseif isnull(liTransitTime) then
			lsColumn = "Transit_Time"
		end if
		messagebox (is_title, "Must enter value for '" + lsColumn + "'!")
		idw_detail.ScrollToRow(i)
		idw_detail.SetFocus()
		idw_detail.SetColumn(lsColumn)
		return -1
	elseif lsZipStart > lsZipEnd then
		messagebox(is_title, "'Zip_Range_Start' can not be greater than 'Zip_Range_End'!")
		return -1
	elseif liTransitTime < 0 then //should we allow TransitTime=0 (same day delivery)?
		messagebox(is_title, "'Transit_Time' must be greater than 0!")
		return -1
	end if
Next		

Return 0
end function

on w_eta_maint.create
int iCurrent
call super::create
end on

on w_eta_maint.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_edit;tab_main.SelectTab(2)

/*
// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False
ibSupplierUpdate = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()

idw_main.Reset()
idw_price.Reset()
tab_main.tabpage_price.dw_cust_SKu.Reset()

idw_main.Hide()
idw_price.Hide()
tab_main.tabpage_price.dw_cust_SKu.Hide()

tab_main.tabpage_reorder.Enabled = False /* 07/00 PCONKL */
tab_main.tabpage_component.Enabled = False /* 09/00 PCONKL */
tab_main.tabpage_packaging.Enabled = False /* 08/02 PCONKL */
tab_main.tabpage_price.Enabled = False /* 01/02 PCONKL */

tab_main.tabpage_price.cb_insert_Price.Hide()
tab_main.tabpage_price.cb_delete_Price.Hide()
tab_main.tabpage_price.cb_insert_cust_alt_sku.Hide()
tab_main.tabpage_price.cb_delete_cust_alt_sku.Hide()
tab_main.tabpage_main.cb_owner.Hide() /* 09/00 PCONKL */
tab_main.SelectTab(1) 

// 09/00 PCONKL - using DW instead of SLE's
idw_sku.modify("sku.protect=0 supp_code.Protect=1")
idw_sku.SetItem(1,"sku",'')
idw_sku.SetItem(1,"supp_code",'')
idw_sku.SetFocus()
idw_sku.SetColumn("sku")


*/
end event

event ue_save;Long	llRowPos, llRowCount
//String	lsOrder
Integer	liRC

integer i

// pvh 02.15.06 - gmt
//datetime ldtToday
//ldtToday = f_getLocalWorldTime( gs_default_wh ) 

If idw_main.RowCount() > 0 Then
		
	If wf_validation() = -1 Then
		SetMicroHelp("Save failed!")
		Return -1
	End If
	
//	idw_main.SetItem(1,'last_update', ldtToday ) 
//	idw_main.SetItem(1,'last_user',gs_userid)
	
End If

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If idw_main.RowCount() > 0 Then
	liRC = idw_main.Update()
Else 
	liRC = 1
End If
if liRC = 1 then 
	liRC = idw_detail.Update()
end if

If idw_main.RowCount() = 0 and liRC = 1 Then liRC = idw_main.Update()

IF (liRC = 1) THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		If idw_main.RowCount() > 0 Then 
			ib_changed = False
			ib_edit = True

			ibInserting = False
			tab_main.tabpage_main.cb_add_tt_row.visible = true
			tab_main.tabpage_main.cb_deleterow.visible = true

			This.Title = is_title  + " - Edit"
			//wf_check_status()
			SetMicroHelp("Record Saved!")
		End If
		Return 0
   ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
      MessageBox(is_title, SQLCA.SQLErrText)
		Return -1
   END IF
ELSE
   Execute Immediate "ROLLBACK" using SQLCA;
	SetMicroHelp("Save failed!")
	MessageBox(is_title, "System error, record save failed!")
	Return -1
END IF

SetPointer(Arrow!)

end event

event ue_delete;call super::ue_delete;// Haven't implemented deleting at idw_Main level (carrier-country record level)

Long i, ll_cnt

// Prompting for deletion
If MessageBox(is_title, "Are you sure you want to delete this Carrier-Country record?", Question!, YesNo!, 2) = 2 Then
	Return
End If

SetPointer(HourGlass!)

ib_changed = False

tab_main.SelectTab(1)

ll_cnt = idw_detail.RowCount()
For i = ll_cnt to 1 step -1
	idw_detail.DeleteRow(i)
Next

idw_main.DeleteRow(1)

If This.Trigger Event ue_save() = 0 Then
	SetMicroHelp("Record Deleted!")
Else
	SetMicroHelp("Record delete failed!")
End If
This.Trigger Event ue_edit()

end event

event ue_new;//messagebox("TEMP", "ue_new")
If wf_save_changes() = -1 Then 
	messagebox("save", "changes")
	Return
end if
idw_main.reset()
idw_detail.reset()
idw_main.InsertRow(0)
ibInserting = True
idw_main.show()
tab_main.SelectTab(1)
//tab_main.TabPage_main.tab_main.show()

idw_main.SetItem(1, "project_id", gs_project)
idw_main.SetItem(1, "Depart_Sunday", 'N')
idw_main.SetItem(1, "Depart_Monday", 'N')
idw_main.SetItem(1, "Depart_Tuesday", 'N')
idw_main.SetItem(1, "Depart_Wednesday", 'N')
idw_main.SetItem(1, "Depart_Thursday", 'N')
idw_main.SetItem(1, "Depart_Friday", 'N')
idw_main.SetItem(1, "Depart_Saturday", 'N')
//idw_main.SetItem(1,'Create_user_date',Today()) 
//idw_main.SetItem(1,'Create_user',gs_userid)

/*
DatawindowChild	ldwc
String	lsEmptyArray[]

// Acess Rights
If f_check_access(is_process,"N") = 0 Then Return
//g.of_getuserid()
// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

isUpdateSql = lsEmptyArray /*Reset Array of pending SQL changes*/

This.Title = is_title + " - New"
ib_edit = False
ib_changed = False
ibSupplierUpdate = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()

// Tab properties
tab_main.SelectTab(1)

idw_main.Reset()
idw_price.Reset()
idw_component_child.Reset()
idw_component_parent.Reset()
idw_packaging_child.REset()
idw_packaging_parent.REset()
//idw_putaway_loc.Reset()
idw_reorder.REset()
tab_main.tabpage_price.dw_cust_SKu.REset()

idw_main.InsertRow(0)
idw_main.Show()
idw_main.Object.DataWindow.ReadOnly=True
tab_main.tabpage_main.cb_owner.Show() /* 09/00 PCONKL */
//idw_main.Hide()
//idw_price.Hide()
tab_main.tabpage_price.cb_insert_Price.Hide()
tab_main.tabpage_price.cb_delete_Price.Hide()
tab_main.tabpage_price.cb_insert_cust_alt_sku.Hide()
tab_main.tabpage_price.cb_delete_cust_alt_sku.Hide()

idw_sku.Reset()
idw_sku.InsertRow(0)
idw_sku.GetChild("supp_code",ldwc)
//reset doesn't seem to clear previous dddw entries, retrieve with crap to clear
//ldwc.SetTransObject(SQLCA)
//ldwc.Retrieve('xxxxx','xxxxx')
					
idw_sku.Modify("sku.Protect=0 supp_code.Protect=0")
idw_sku.SetFocus()
idw_sku.SetColumn("sku")
idw_main.object.standard_of_measure[1]=g.is_std_mesure
*/
end event

event ue_retrieve;call super::ue_retrieve;Long	llCount

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

//Retrieve the Header
idw_Main.Retrieve(gs_Project, is_WH, is_Carrier, is_Country)

If idw_main.RowCount() <> 1 Then
	MessageBox(is_title, "Unable to Retrieve Carrier-Country record!", Exclamation!)
	//isle_awb.SetFocus()
	//isle_awb.SelectText(1,Len(lsAwb))
	RETURN
End If

//idw_Origin.Retrieve(isSHipNo,'O') /* Origin Address*/
//If idw_origin.RowCOunt() = 0 Then
//	idw_origin.InsertRow(0)
//End If

//idw_detail.Retrieve(isShipNo) /*detail records*/
idw_detail.Retrieve(gs_Project, is_WH, is_Carrier, is_Country)
//idw_Status.Retrieve(isShipNo) /*Status Records*/

idw_main.Show()
//tab_main.tabpage_main.tab_locations.Show()
//tab_main.tabpage_detail.Enabled = True

//wf_check_status()
tab_main.tabpage_main.cb_add_tt_row.visible = true
tab_main.tabpage_main.cb_DeleteRow.visible = true

tab_main.SelectTab(1)
idw_Main.SetFocus()

ibInserting = False
end event

event ue_postopen;call super::ue_postopen;
DataWindowChild ldwc_grp1, ldwc_grp2,ldwc, ldwc2

String	lsFilter

iw_window  = This

tab_main.movetab(2,999) /*always move search to the end*/

// Storing into variables
idw_main = tab_main.tabpage_main.dw_main
idw_detail = tab_main.tabpage_main.dw_detail
idw_query = tab_main.tabpage_search.dw_query
idw_search = tab_main.tabpage_search.dw_search

idw_main.SetTransObject(Sqlca)
idw_detail.SetTransObject(Sqlca)
idw_query.SetTransObject(Sqlca)
idw_search.SetTransObject(Sqlca)

//Warehouse
idw_main.GetChild("wh_code", ldwc)
ldwc.SetTransObject(SQLCA)
g.of_set_warehouse_dropdown(ldwc) /* load from User Warehouse DS */

idw_Query.GetChild("wh_code", ldwc2)
ldwc.ShareData(ldwc2)

//Carrier - no need to retrieve until needed
idw_Query.GetChild("Carrier",ldwc)
ldwc.SetTransObject(SQLCA)

idw_Main.GetChild("Carrier_Code",ldwc2)
ldwc.ShareData(ldwc2)

//Share carrier dropdowns with DS Loaded in Project Open
g.ids_dddw_carrier.ShareData(ldwc)
g.ids_dddw_carrier.ShareData(ldwc2)

//Country drop-down (after carrier selected?)
idw_Query.GetChild("Country", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve()

i_sql = idw_search.getsqlselect()
is_origSQL = idw_main.GetSQLSelect()

idw_query.InsertRow(0)

tab_main.tabpage_main.cb_add_tt_row.visible = false
tab_main.tabpage_main.cb_deleterow.visible = false

// Default into edit mode
idw_main.Show()
This.TriggerEvent("ue_edit")

end event

event close;call super::close;//Destroy i_nwarehouse
end event

event open;call super::open;
//ilHelpTopicID = 532 /*set help topic ID*/
end event

type tab_main from w_std_master_detail`tab_main within w_eta_maint
integer x = 5
integer y = 16
integer width = 3072
integer height = 2016
integer textsize = -9
integer weight = 700
boolean fixedwidth = false
end type

event tab_main::selectionchanged;//For updating sort option
CHOOSE CASE newindex
	CASE 6
		wf_check_menu(TRUE,'sort')
		idw_current = idw_search
	Case Else		
		wf_check_menu(FALSE,'sort')
END CHOOSE
end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer y = 108
integer width = 3035
integer height = 1892
string text = "Transit Time"
cb_add_tt_row cb_add_tt_row
cb_deleterow cb_deleterow
dw_detail dw_detail
cb_owner cb_owner
dw_main dw_main
end type

on tabpage_main.create
this.cb_add_tt_row=create cb_add_tt_row
this.cb_deleterow=create cb_deleterow
this.dw_detail=create dw_detail
this.cb_owner=create cb_owner
this.dw_main=create dw_main
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add_tt_row
this.Control[iCurrent+2]=this.cb_deleterow
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.cb_owner
this.Control[iCurrent+5]=this.dw_main
end on

on tabpage_main.destroy
call super::destroy
destroy(this.cb_add_tt_row)
destroy(this.cb_deleterow)
destroy(this.dw_detail)
destroy(this.cb_owner)
destroy(this.dw_main)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer y = 108
integer width = 3035
integer height = 1892
cb_search cb_search
cb_1 cb_1
dw_query dw_query
dw_search dw_search
cb_fix_data cb_fix_data
end type

on tabpage_search.create
this.cb_search=create cb_search
this.cb_1=create cb_1
this.dw_query=create dw_query
this.dw_search=create dw_search
this.cb_fix_data=create cb_fix_data
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_search
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_query
this.Control[iCurrent+4]=this.dw_search
this.Control[iCurrent+5]=this.cb_fix_data
end on

on tabpage_search.destroy
call super::destroy
destroy(this.cb_search)
destroy(this.cb_1)
destroy(this.dw_query)
destroy(this.dw_search)
destroy(this.cb_fix_data)
end on

type cb_add_tt_row from commandbutton within tabpage_main
integer x = 443
integer y = 780
integer width = 402
integer height = 76
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insert Row"
end type

event clicked;dw_detail.TriggerEvent('ue_Insert')
end event

type cb_deleterow from commandbutton within tabpage_main
integer x = 873
integer y = 780
integer width = 402
integer height = 76
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Row"
end type

event clicked;//Long ll_row, ll_crow
//string ls_zip_start, ls_zip_end

//ll_crow = idw_detail.GetRow()

//If ll_crow > 0 Then
	ib_changed = True
//	ls_zip_start = idw_detail.GetItemString(ll_crow, "zip_range_start")
//	ls_zip_end = idw_detail.GetItemString(ll_crow, "zip_range_end")
	
	idw_detail.DeleteRow(0)
//End If
end event

event constructor;this.visible = false
end event

type dw_detail from u_dw_ancestor within tabpage_main
integer x = 14
integer y = 768
integer width = 2985
integer height = 1088
integer taborder = 60
boolean titlebar = true
string title = "Transit Times"
string dataobject = "d_transit_time_detail"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;
If dwo.name <> 'c_select_ind' Then	ib_changed = True
end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event ue_postitemchanged;call super::ue_postitemchanged;/*
If Upper(dwo.name) = 'C_SELECT_IND' Then
	If This.Find("Upper(c_select_Ind) = 'Y'",1,This.RowCOunt()) > 0 Then
		cb_delete_orders.Enabled = True
	Else
		cb_delete_orders.Enabled = False
	End If
End If
*/
end event

event ue_insert;call super::ue_insert;Long	llNewRow
//DateTime	ldtToday

// pvh 02.15.06 - gmt
//ldtToday = f_getLocalWorldTime( gs_default_wh ) 


llNewRow = This.InsertRow(0)
This.ScrolltoRow(llNewRow)

This.SetItem(llNewRow, 'project_id', gs_project)
This.SetItem(llNewRow, 'wh_code', idw_Main.GetItemString(1, 'wh_code'))
This.SetItem(llNewRow, 'carrier_code', idw_Main.GetItemString(1, 'carrier_code'))
This.SetItem(llNewRow, 'country_code', idw_Main.GetItemString(1, 'country_code'))
This.SetFocus()
This.SetColumn("Zip_Range_Start")
//This.SetItem(llNewRow,'last_user', gs_userid)
//This.SetItem(llNewRow,'Create_user', gs_userid)
//This.SetItem(llNewRow,'last_update', ldtToday)
//This.SetItem(llNewRow,'Create_user_date', ldtToday)

//default to 'N' so it will save
//This.SetItem(llNewRow,'c_delete_ind', 'N')
end event

type cb_owner from commandbutton within tabpage_main
boolean visible = false
integer x = 2597
integer y = 836
integer width = 215
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Owner:"
end type

event clicked;//iw_window.TriggerEvent("ue_select_owner")
end event

type dw_main from u_dw_ancestor within tabpage_main
integer y = 8
integer width = 2994
integer height = 736
integer taborder = 20
boolean titlebar = true
string title = "Carrier-Country"
string dataobject = "d_carrier_country"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event getfocus;call super::getfocus;
//sku and/or supplier may not be validated if a field has been clicked instead of tabbing
//idw_sku.AcceptText()
end event

event itemchanged;
ib_changed = True

end event

event process_enter;//Send(Handle(This),256,9,Long(0,0))
//Return 1

end event

event retrieveend;call super::retrieveend;// pvh - 06/27/06

// tired of the please supply a value for! message
//if idw_main.rowcount() <= 0 then return
//if IsNull( idw_main.object.qa_check_ind[ 1 ] ) or Trim( idw_main.object.qa_check_ind[ 1 ] ) = '' then
//	idw_main.object.qa_check_ind[ 1 ]  = 'N'
//end if
// eom


// pvh - 06/27/06
//doFilterClassColumn( idw_main.object.cc_group_code[ 1 ] )


datawindowchild ldwc

idw_Main.GetChild("Carrier", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_project)

end event

type cb_search from commandbutton within tabpage_search
integer x = 2711
integer y = 12
integer width = 297
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;
string lsWH, lsCarrier, lsCountry
string ls_where, ls_sql
Boolean lb_where
dw_search.reset()
lb_where = False

If dw_query.accepttext() = -1 Then Return

lsWH = idw_query.getitemstring(1,"WH_Code")
lsCarrier = idw_query.getitemstring(1,"Carrier")
lsCountry = idw_query.getitemstring(1,"Country")

ls_where = "Where project_id = '" + gs_project + "' "  

if  not isnull(lsWH) then
	ls_where += " and wh_code = '" + lsWH + "' "
	lb_where = True
end if

if not isnull(lsCarrier) then
	ls_where += " and Carrier_Code = '" + lsCarrier + "' "
	lb_where = True
end if

if not isnull(lsCountry) then
	ls_where += " and Country_Code = '" + lsCountry + "' "
	lb_where = True
end if

ls_sql = i_sql + ls_where
dw_search.setsqlselect(ls_sql)

//For giving warning for all no search criteria
//if not lb_where then
//	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
//END IF

if dw_search.retrieve() = 0 then
	messagebox(is_title,"No records found!")
end if
end event

type cb_1 from commandbutton within tabpage_search
integer x = 2711
integer y = 128
integer width = 297
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;dw_search.Reset()
dw_query.Reset()
dw_query.InsertRow(0)
end event

type dw_query from u_dw_ancestor within tabpage_search
integer y = 8
integer width = 2501
integer height = 260
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_car_cntry_search_entry"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;//overide
//This.SetTransObject(Sqlca)
g.of_check_label(this) 

This.Modify('warehouse.visible=0 warehouse_t.visible=0')


end event

type dw_search from u_dw_ancestor within tabpage_search
integer x = 5
integer y = 256
integer width = 3013
integer height = 1532
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_car_cntry_search_result"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

event doubleclicked;/*
// Pasting the record to the main entry datawindow
IF Row > 0 THEN
//	iw_window.TriggerEvent("ue_edit")
	IF NOT ib_changed THEN
		idw_sku.SetItem(1,"sku",This.GetItemString(row,"sku"))
		idw_sku.SetItem(1,"supp_code",This.GetItemString(row,"supp_code"))
//		iw_window.TriggerEvent("ue_retrieve")
	END IF
END IF
*/

If Row > 0 Then
	is_wh = This.GetItemString(row, 'wh_code')
	is_carrier = This.GetItemString(row, 'carrier_code')
	is_country = This.GetItemString(row, 'country_code')
	iw_window.TriggerEvent('ue_retrieve')	
End If
end event

type cb_fix_data from commandbutton within tabpage_search
integer x = 2235
integer y = 16
integer width = 402
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Fix Data"
end type

event clicked;/* run through shipments and get Weight, Ctn_cnt, ETA/ETD data based on Order(s)
ETD: StartDate, project, wh, carrier, country
ETA: DepartureDate, project, wh, carrier, country, Zip
*/
/*
- get datastore of shipments
- scroll through shipments
	find latest DM.complete_date for awb_bol_no
	if powerwave, calculate ETD and ETA?
	sum weights and carton counts for each distinct rodo_no
	update shipment for current ship_no
*/

String	lsAWB, lsCarrier, lsZip, lsDoNo, lsShipNo, lsErrText, lsWH, lsToCountry
string lsProject, lsUOM
Long	llCount, llRowCount, llRowPos, llShipLineNo, llOrderLineNo, llID, llCartons, llExistCartonCount, llFindRow
Decimal	ldShipQty, ldPrice, ldWgt, ldExistWeight
DateTime	ldtToday, ldtETD
Date ldtETA, ldtCreateDt, ldtTemp, ldateETD
datastore ldsShipments
integer iRet, Increment, iPeriod, iStart, iEnd
u_nvo_shipments lu_ship

if messagebox("Choose Project!", "Hit 'OK' for Powerwave and 'Cancel' for 3COM.", StopSign!, OkCancel!) = 1 then
	lsProject = 'POWERWAVE'
	lu_ship = create u_nvo_shipments
else
	lsProject = '3com_nash'
end if

if messagebox("Choose Period Length!", "Hit 'OK' for 30-days and 'Cancel' for 60-days.", StopSign!, OkCancel!) = 1 then
	iPeriod = 30
else
	iPeriod = 60
end if

do while iRet <> 1
	iStart = Increment * iPeriod
	iEnd = iStart + iPeriod
	iRet = messagebox(string(iPeriod) + "-Day Increments", "Start at day " + string(iStart) + " (moves backwards from start day)", Question!, YesNo!)
	Increment ++
loop

ldsShipments = Create Datastore
ldsShipments.dataobject = 'd_shipment'
ldsShipments.SetTransObject(SQLCA)

string old_select, new_select, where_clause
old_select = ldsShipments.GetSQLSelect()
//TEMPO!! where_clause = "WHERE ord_type = 'O' and project_id = '" + lsProject + "'"
where_clause = "WHERE ord_type = 'O' and project_id = '" + lsProject + "'"
if not IsNull(idw_query.GetItemString(1, "Carrier")) then
	where_clause = where_clause + " and carrier_code = '" + idw_query.GetItemString(1, "Carrier") + "'"
end if
//where_clause = where_clause + " and ord_date<GetDate()"
where_clause = where_clause + " and ord_date<GetDate() - " + string(iStart)
where_clause = where_clause + " and ord_date>=GetDate() - " + string(iEnd)
new_select = old_select + where_clause + " Order by ship_no desc"
//messagebox("TEMPO", new_select)
ldsShipments.SetSQLSelect(new_select)

llRowCount = ldsShipments.Retrieve()
//llRowCount = ldsShipments.RowCount()
//w_main.SetMicroHelp("Ready")
SetMicroHelp(string(llRowCount) + " Records.")
if messagebox("TEMPO", string(llRowCount) + ' rows for ' + where_clause, Question!, OkCancel!) = 2 then
	return
end if
//if llrowcount > 200 then llRowCount = 200 //TEMPO!!!
For llRowPos = 1 to llRowCount
//	messagebox("TEMPO - Count", string(llRowPos) +" of " + string(llRowCount))
	if mod(llRowPos, 20) = 0 then
		SetMicroHelp (string(llRowPos) + " of " + string(llRowCount))
	end if
	if mod(llRowPos, 500) = 0 then
		if messagebox("Continue?", string(llRowPos) +" of " + string(llRowCount) + ". Continue?", Question!, OkCancel!) = 2 then
			return
		end if
	end if
	lsAWB = ldsShipments.GetItemString(llRowPos, "awb_bol_no")
	lsShipNo = ldsShipments.GetItemString(llRowPos, "Ship_No")
	ldtCreateDt = date(ldsShipments.GetItemDateTime(llRowPos, "Create_User_Date"))
	
	ldtETA = date(ldsShipments.GetItemDateTime(llRowPos, "freight_eta"))
	
	lsWH = ldsShipments.GetItemString(llRowPos, "WH_Code")
	lsCarrier = ldsShipments.GetItemString(llRowPos, "Carrier_Code")
	
	Select Max(complete_date) into :ldtETD
	from delivery_master 
	Where project_id = :lsProject
	and awb_bol_no = :lsAWB
	Using SQLCA;
	
	if isnull(ldtETD) then
		ldtETD = ldsShipments.GetItemDateTime(llRowPos, "ord_date")
	end if

	//messagebox("TEMPO", "AWB: " + lsAWB + ", Complete: " + string(ldtETD))

	//if ldtETA > ldtTemp then
	if isnull(ldtETD) then
		ldtTemp = RelativeDate(date(ldtCreateDt), 15)
		//if ETA is more than 15 days after create or more than 2 days before create, reset it
		if ldtETA > RelativeDate(date(ldtCreateDt), 15) or ldtETA < RelativeDate(date(ldtCreateDt), -2) then SetNull(ldtETA)
	else
		if lsProject = 'POWERWAVE'	then
			select zip, country 
			into :lsZip, :lsToCountry
			from shipment_location
			Where Ship_No = :lsShipNo
			using SQLCA;
			ldateETD = lu_ship.uf_get_ETD(date(ldtETD), lsProject, lsWH, lsCarrier, lsToCountry)
			ldtETD = DateTime(ldateETD)
			ldtETA = lu_ship.uf_get_ETA(ldateETD, lsProject, lsWH, lsCarrier, lsToCountry, lsZip)
		end if
		//if ETA is more than 15 days after ETD or before ETD, reset it
		if ldtETA > RelativeDate(date(ldtEtd), 15) or ldtETA < date(ldtETD) then SetNull(ldtETA)
	end if
	//messagebox("TEMPO", "AWB: " + lsAWB + ", ETA: " + string(ldtETA))

	Select Sum(weight_gross), Count(distinct Carton_no), Min(standard_of_measure) 
	Into :ldWgt, :llCartons, :lsUOM
	from delivery_packing
	Where do_no in(
		Select distinct rodo_no
		from Shipment_line_item 
		Where Ship_No = :lsShipNo)
	Using SQLCA;

	//messagebox("TEMPO", "AWB: " + lsAWB + ", Weight: " + string(ldWgt) + ", Crtns: " + string(llCartons) +", UOM: " +lsUOM)

	Update Shipment
	Set Weight = :ldWgt, Est_weight = :ldWgt, Ctn_Cnt = :llCartons,
			Est_ctn_cnt = :llCartons, freight_etd = :ldtETD, Freight_ETA = :ldtETA
	Where Ship_no = :lsShipNo			// 03/28/07
	Using SQLCA;

	/*If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox('Shipments',"Unable to save Shipment Detail record to database!~r~r" + lsErrtext)
	End If
	*/

Next /* Next Shipment */
SetMicroHelp (string(llRowPos - 1) + " of " + string(llRowCount))
messagebox("TEMPO", "DONE")
SetMicroHelp ("Ready (or not)")

end event

event constructor;//if gs_userid = 'DTS' or gs_userid = 'BOB' then
if gs_userid = 'DTS' then
	messagebox(is_title, "Hi " + gs_userid + ". I'm enabling the 'Fix Data' button. Use it to reset Freight_ETD, Weight and Carton Counts.")
	this.visible = true
else
	this.visible = false
end if

end event

