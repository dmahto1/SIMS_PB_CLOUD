HA$PBExportHeader$w_maintenance_project.srw
$PBExportComments$- project modify
forward
global type w_maintenance_project from w_std_master_detail
end type
type dw_pick_sort from datawindow within tabpage_main
end type
type cb_pick_sort from commandbutton within tabpage_main
end type
type st_project_id from statictext within tabpage_main
end type
type sle_project from singlelineedit within tabpage_main
end type
type dw_warehouse from u_dw_ancestor within tabpage_main
end type
type dw_project from datawindow within tabpage_main
end type
type dw_search from datawindow within tabpage_search
end type
type cb_project_search from commandbutton within tabpage_search
end type
type tabpage_reports from userobject within tab_main
end type
type uo_report_select from u_select_available_report within tabpage_reports
end type
type tabpage_reports from userobject within tab_main
uo_report_select uo_report_select
end type
type tabpage_label from userobject within tab_main
end type
type cb_col_sort from commandbutton within tabpage_label
end type
type cb_project_create_new_template from commandbutton within tabpage_label
end type
type dw_template_select from datawindow within tabpage_label
end type
type cb_project_delete_label from commandbutton within tabpage_label
end type
type cb_project_insert_label from commandbutton within tabpage_label
end type
type dw_label from u_dw_ancestor within tabpage_label
end type
type tabpage_label from userobject within tab_main
cb_col_sort cb_col_sort
cb_project_create_new_template cb_project_create_new_template
dw_template_select dw_template_select
cb_project_delete_label cb_project_delete_label
cb_project_insert_label cb_project_insert_label
dw_label dw_label
end type
end forward

global type w_maintenance_project from w_std_master_detail
integer width = 4969
integer height = 2368
string title = "Project"
event ue_set_pick_sort ( )
end type
global w_maintenance_project w_maintenance_project

type variables
Datawindow   idw_main, idw_search,idw_warehouse
Datawindow idw_label
Datastore ids_custom_label   //28-Jul-2014 :Madhu- Added "ids_custom_label"
String ids_dwname //28-Jul-2014 : Madhu- Store selected DW Name
long il_dwno  //28-Jul-2014 : Madhu- store custom DW No
SingleLineEdit isle_whcode
Boolean  ibWarehouseChg,ib_etohChg
long ii_row = 0 //get datawindow(search) current rows
end variables

forward prototypes
public subroutine wf_convert (ref string as_measure, ref integer ai_row)
end prototypes

event ue_set_pick_sort;String	lsSortString,ls_sort_order

// 04/02 - Pconkl - set the default sort order for the Pick List

Integer	liRC

//Load the current Sort Order
ls_sort_order = idw_main.GetITemString(1,'delivery_pick_sort_order')
If Not isnull(ls_sort_order) Then
	tab_main.tabpage_main.dw_pick_sort.SetSort(ls_sort_order)
	liRC = tab_main.tabpage_main.dw_pick_sort.Sort()
End If

//Open the sort window
SetNull(lsSortString)
tab_main.tabpage_main.dw_pick_sort.SetSort(lsSortString)
liRC = tab_main.tabpage_main.dw_pick_sort.Sort()

//Get the new sort Order
lsSortString = tab_main.tabpage_main.dw_pick_sort.Describe('datawindow.table.Sort')
If lsSortString = '?' Then lsSortString = ''

idw_main.SetItem(1,'delivery_pick_sort_order',lsSortString)

//If this is the current Project, update the global variable
If idw_main.GetITemString(1,'project_id') = gs_project Then
	g.is_pick_sort_order = lsSortString
End If

ib_changed = True
	
	




end event

public subroutine wf_convert (ref string as_measure, ref integer ai_row);
//This function is used for converting English to Matrics conversion 
//called from itemchange event dw_main

Real lr_length1,lr_length2,lr_length3,lr_length4
real lr_width1,lr_width2,lr_width3,lr_width4
Real lr_height1,lr_height2,lr_height3,lr_height4 
Real lr_weight1,lr_weight2,lr_weight3,lr_weight4
long ll_row
ll_row = ai_row
lr_length1 = real(g.i_nwarehouse.ids_any.object.length_1[ll_row])
lr_length2 = real(g.i_nwarehouse.ids_any.object.length_2[ll_row])
lr_length3 = real(g.i_nwarehouse.ids_any.object.length_3[ll_row])
lr_length4 = real(g.i_nwarehouse.ids_any.object.length_4[ll_row])
lr_width1 = real(g.i_nwarehouse.ids_any.object.width_1[ll_row])
lr_width2 = real(g.i_nwarehouse.ids_any.object.width_2[ll_row])
lr_width3 = real(g.i_nwarehouse.ids_any.object.width_3[ll_row])
lr_width4 = real(g.i_nwarehouse.ids_any.object.width_4[ll_row])
lr_height1 = real(g.i_nwarehouse.ids_any.object.height_1[ll_row])
lr_height2 = real(g.i_nwarehouse.ids_any.object.height_2[ll_row])
lr_height3 = real(g.i_nwarehouse.ids_any.object.height_3[ll_row])
lr_height4 = real(g.i_nwarehouse.ids_any.object.height_4[ll_row])
lr_weight1 = real(g.i_nwarehouse.ids_any.object.weight_1[ll_row])
lr_weight2 = real(g.i_nwarehouse.ids_any.object.weight_2[ll_row])
lr_weight3 = real(g.i_nwarehouse.ids_any.object.weight_3[ll_row])
lr_weight4 = real(g.i_nwarehouse.ids_any.object.weight_4[ll_row])

IF as_measure = 'E' THEN			
	g.i_nwarehouse.ids_any.object.length_1[ll_row]= round(g.i_nwarehouse.of_convert(lr_length1,'CM','IN'),2)
	g.i_nwarehouse.ids_any.object.length_2[ll_row]= round(g.i_nwarehouse.of_convert(lr_length2,'CM','IN'),2)
	g.i_nwarehouse.ids_any.object.length_3[ll_row]= round(g.i_nwarehouse.of_convert(lr_length3,'CM','IN'),2)
	g.i_nwarehouse.ids_any.object.length_4[ll_row]= round(g.i_nwarehouse.of_convert(lr_length4,'CM','IN'),2)
	g.i_nwarehouse.ids_any.object.width_1[ll_row]= round(g.i_nwarehouse.of_convert(lr_width1,'CM','IN'),2)
	g.i_nwarehouse.ids_any.object.width_2[ll_row]= round(g.i_nwarehouse.of_convert(lr_width2,'CM','IN'),2)
	g.i_nwarehouse.ids_any.object.width_3[ll_row]= round(g.i_nwarehouse.of_convert(lr_width3,'CM','IN'),2)
	g.i_nwarehouse.ids_any.object.width_4[ll_row]= round(g.i_nwarehouse.of_convert(lr_width4,'CM','IN'),2)
	g.i_nwarehouse.ids_any.object.height_1[ll_row]= round(g.i_nwarehouse.of_convert(lr_height1,'CM','IN'),2)
	g.i_nwarehouse.ids_any.object.height_2[ll_row]= round(g.i_nwarehouse.of_convert(lr_height2,'CM','IN'),2)
	g.i_nwarehouse.ids_any.object.height_3[ll_row]= round(g.i_nwarehouse.of_convert(lr_height3,'CM','IN'),2)
	g.i_nwarehouse.ids_any.object.height_4[ll_row]= round(g.i_nwarehouse.of_convert(lr_height4,'CM','IN'),2)
	g.i_nwarehouse.ids_any.object.weight_1[ll_row]= round(g.i_nwarehouse.of_convert(lr_weight1,'KG','PO'),2)
	g.i_nwarehouse.ids_any.object.weight_2[ll_row]= round(g.i_nwarehouse.of_convert(lr_weight2,'KG','PO'),2)
	g.i_nwarehouse.ids_any.object.weight_3[ll_row]= round(g.i_nwarehouse.of_convert(lr_weight3,'KG','PO'),2)
	g.i_nwarehouse.ids_any.object.weight_4[ll_row]= round(g.i_nwarehouse.of_convert(lr_weight4,'KG','PO'),2)	
ELSE
	g.i_nwarehouse.ids_any.object.length_1[ll_row]= round(g.i_nwarehouse.of_convert(lr_length1,'IN','CM'),2)
	g.i_nwarehouse.ids_any.object.length_2[ll_row]= round(g.i_nwarehouse.of_convert(lr_length2,'IN','CM'),2)
	g.i_nwarehouse.ids_any.object.length_3[ll_row]= round(g.i_nwarehouse.of_convert(lr_length3,'IN','CM'),2)
	g.i_nwarehouse.ids_any.object.length_4[ll_row]= round(g.i_nwarehouse.of_convert(lr_length4,'IN','CM'),2)
	g.i_nwarehouse.ids_any.object.width_1[ll_row]= round(g.i_nwarehouse.of_convert(lr_width1,'IN','CM'),2)
	g.i_nwarehouse.ids_any.object.width_2[ll_row]= round(g.i_nwarehouse.of_convert(lr_width2,'IN','CM'),2)
	g.i_nwarehouse.ids_any.object.width_3[ll_row]= round(g.i_nwarehouse.of_convert(lr_width3,'IN','CM'),2)
	g.i_nwarehouse.ids_any.object.width_4[ll_row]= round(g.i_nwarehouse.of_convert(lr_width4,'IN','CM'),2)
	g.i_nwarehouse.ids_any.object.height_1[ll_row]= round(g.i_nwarehouse.of_convert(lr_height1,'IN','CM'),2)
	g.i_nwarehouse.ids_any.object.height_2[ll_row]= round(g.i_nwarehouse.of_convert(lr_height2,'IN','CM'),2)
	g.i_nwarehouse.ids_any.object.height_3[ll_row]= round(g.i_nwarehouse.of_convert(lr_height3,'IN','CM'),2)
	g.i_nwarehouse.ids_any.object.height_4[ll_row]= round(g.i_nwarehouse.of_convert(lr_height4,'IN','CM'),2)
	g.i_nwarehouse.ids_any.object.weight_1[ll_row]= round(g.i_nwarehouse.of_convert(lr_weight1,'PO','KG'),2)
	g.i_nwarehouse.ids_any.object.weight_2[ll_row]= round(g.i_nwarehouse.of_convert(lr_weight2,'PO','KG'),2)
	g.i_nwarehouse.ids_any.object.weight_3[ll_row]= round(g.i_nwarehouse.of_convert(lr_weight3,'PO','KG'),2)
	g.i_nwarehouse.ids_any.object.weight_4[ll_row]= round(g.i_nwarehouse.of_convert(lr_weight4,'PO','KG'),2)
END IF	

end subroutine

event open;call super::open;// pvh - 08/17/06
// menu is sending is_process in lstrparms, not message.stringParm
//

string ls_menuname,	&
		lsFilter
		
DatawindowChild	ldwc

// pvh - 08/17/06
//is_process = Message.StringParm
istrparms = Message.PowerObjectParm	
if UpperBound( istrparms.string_arg) > 0 then
	is_process = istrparms.string_arg[1]
end if
//
ls_menuname = this.menuname
ilHelpTopicID = 533 /*set help topic ID*/

tab_main.MoveTab(2,0) /*move search to end*/

// Storing into variables

idw_main = tab_main.tabpage_main.dw_project
idw_search = tab_main.tabpage_search.dw_search
idw_warehouse = tab_main.tabpage_main.dw_warehouse
idw_label = tab_main.tabpage_label.dw_label
//idw_reports = tab_main.tabpage_reports.dw_report_sel
isle_whcode = tab_main.tabpage_main.sle_project

idw_main.SetTransObject(Sqlca)
idw_search.SetTransObject(Sqlca)


//28-Jul-2014 : Madhu - Initially set Column Sort button disable - START
String lsSql,lsError
long ll_rowcount

IF gs_role ='-1' Then
	ids_custom_label = Create Datastore
	lsSql ="select DataWindow from Custom_Datawindow where Project_Id ='"+ gs_project +"'"
	ids_custom_label.create( SQLCA.SyntaxFromSQL(lsSql," ",lsError))
	
	If len(lsError) > 0 Then
		Return -1
	ELSE
		ids_custom_label.SetTransobject( SQLCA);
		ll_rowcount=ids_custom_label.retrieve( )
		tab_main.tabpage_label.cb_col_sort.enabled =FALSE
	END IF
ELSE
	tab_main.tabpage_label.cb_col_sort.visible =FALSE
END IF
//28-Jul-2014 : Madhu - Initially set Column Sort button disable - END

end event

on w_maintenance_project.create
int iCurrent
call super::create
end on

on w_maintenance_project.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_edit;// Acess Rights

// pvh - 08/16/06
// is_process is set in the open event, no need to do it here.
//is_process = Message.StringParm
//If f_check_access(is_process,"E") = 0 Then
//	//close(w_maintenance_project)
//	return
//end if

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()

// Tab properties
tab_main.SelectTab(1) 
idw_main.Reset()
idw_main.Hide()
idw_warehouse.Hide()
tab_main.tabpage_reports.Enabled = False /* 12/00 PCONKL */
tab_main.tabpage_label.Enabled = False
// Reseting the Single line edit
isle_whcode.Text = ""
isle_whcode.SetFocus()
isle_whcode.DisplayOnly = False /* 08/00 pconkl */
tab_main.tabpage_main.cb_pick_sort.visible=False

end event

event ue_save;Integer li_ret,i
long ll_cnt,ll_row
Decimal ld_orgprice, ld_price  
String ls_std_measure,ls_std_measure_org,ls_where,ls_project,ls_wh_code
li_ret = 1
SetPointer(HourGlass!)
DECLARE get_conversion PROCEDURE FOR 
	sp_measure @project_id = :ls_project,@std_of_measure=:ls_std_measure using SQLCA;
// pvh - 08/17/06
//IF f_check_access(is_process,"S") = 0 THEN Return 0
If idw_main.RowCount() <= 0 Then Return 0

//	
// When updating setting the current user & date
idw_main.AcceptText()

// pvh 02.15.06 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( gs_default_wh ) 
idw_main.SetItem(1,'last_update',ldtToday)
//idw_main.SetItem(1,'last_update',Today())
idw_main.SetItem(1,'last_user',gs_userid)
ls_project=idw_main.Getitemstring(1,'project_id')
ls_std_measure_org=idw_main.Getitemstring(1,'standard_of_measure_default',Primary!,True)
ls_std_measure=idw_main.Getitemstring(1,'standard_of_measure_default')

//If user changes the Eng. to metrics then we give user option to conver the entire
//Item Master table E TO M field as well as all dimention fields in the item master 
//Can be changed We also give an option to cahnge all defaults of Warehouse e to M fields

//Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'

IF ls_std_measure <> ls_std_measure_org THEN
	
	IF MessageBox(is_title,"Do you want to change all the standard_of_measure values for "+&
	           "all Records of Item master",Question!,YesNo!,1) = 1 THEN				  

			Execute get_conversion;
			If SQLCA.sqlcode <> 0 then
				MessageBox(is_title,"Could Not update Item master table...")
				Return -1
			END IF	
			CLOSE get_conversion;

			//For converting Warehouse Defaults.
			IF MessageBox(is_title,"Do you wish to change warehouse/s default values of standard_of_measure " &
        		,Question!,YesNo!,1) = 1 THEN
				i=1
				FOR i = 1 TO idw_warehouse.RowCount()
					ls_project = idw_main.object.project_id[1]
					ls_wh_code = idw_warehouse.object.wh_code[i]
					//Filter
					ll_row = g.of_project_warehouse(ls_project,ls_wh_code) //Finds the right row 
					IF ll_row > 0 THEN g.ids_project_warehouse.object.standard_of_measure[ll_row]=ls_std_measure
					
				NEXT
				
				ibwarehousechg = True
							
			END IF	
			
	END IF			  
	 			  
END IF


// 07/00 PCONKL - Save available warehouse DW - seperate begin/commit
if li_ret = 1 then
	idw_warehouse.TriggerEvent("ue_save")
End If

// 12/00 - PCONKL - save Reports by Project - seperate begin/commit
if li_ret = 1 then
	// pvh - 08/11/05
	tab_main.tabpage_reports.uo_report_select.event ue_save()
	//idw_reports.TriggerEvent("ue_save")
End If



Execute Immediate "Begin Transaction" using SQLCA;

// Updating the Datawindow
SQLCA.DBParm = "disablebind =0"
IF li_ret = 1 THEN li_ret = idw_main.Update(False, False)
SQLCA.DBParm = "disablebind =1"

//IF li_ret = 1 THEN li_ret=g.ids_project_warehouse.Update(false,false)

//if li_ret = 1 then idw_label.Update(False, False)
if li_ret = 1 then
	idw_label.TriggerEvent("ue_save")
End If

IF li_ret = 1 THEN
	
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		idw_main.ResetUpdate()
		idw_label.ResetUpdate()
		g.ids_project_warehouse.ResetUpdate()
		IF Isvalid(g.i_nwarehouse.ids_any) THEN g.i_nwarehouse.ids_any.ResetUpdate()
		SetMicroHelp("Record Saved!")
		g.ids_columnlabel.Retrieve(gs_project)
		g.ids_project_warehouse.Retrieve()
		ib_changed = False
		// Bringing back to edit mode
		IF ib_edit = False THEN
			ib_edit = True
			isle_whcode.DisplayOnly = True /* 08/00 pconkl */
			This.Title = is_title + " - Edit"
			im_menu.m_file.m_save.Enable()
			im_menu.m_file.m_retrieve.Enable()
			If gs_role = '0' or gs_project = '-1' Then /* 07/00 pconkl - only super can delete a project, 02/08 - PCONKL - Added Super Duper User*/
				im_menu.m_record.m_delete.Enable()
			End If
		END IF
		Return 1
   ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
      MessageBox(is_title, SQLCA.SQLErrText)
		Return 0
   END IF
	
ELSE
	
   Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox(is_title, "System error, record save failed!: " + sqlca.SQLErrText)
	Return 0
	
END IF

ib_changed = False

end event

event ue_delete;call super::ue_delete;Integer li_ret
String ls_code

// pvh - 08/17/06
//If f_check_access(is_process,"D") = 0 Then Return

// 07/00 PCONKl - Cant delete current Project!!
If idw_main.GetItemString(1,"project_id") = gs_project Then
	messagebox(is_title,"You can not delete the current project!",StopSign!)
	Return
End If

// Prompting for deletion
li_ret = MessageBox(is_title, "Are you sure you want to delete this record",Question!,YesNo!,2)
IF li_ret = 2 THEN Return
	
	// Deleting proceed with updation
	ls_code = idw_main.GetItemString(1,"project_id")

	Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
	// 08/00 PCONKL - Delete project warehouse records first
	Delete project_warehouse where project_id = :ls_code;
	
	// 12/00 PCONKL - delete sequence number table and reports
	Delete next_sequence_no where project_id = :ls_code;
	
	Delete project_reports where project_id = :ls_code;
	
	// 01/01 Delete column labels
	Delete column_label where project_id = :ls_code;
	
	
	Delete project Where project_id = :ls_code;
	IF Sqlca.Sqlcode = 0 THEN
		Execute Immediate "COMMIT" using SQLCA;
		SetMicroHelp("Record Deleted!")
		idw_search.retrieve()
		This.TriggerEvent("ue_edit")
		Return
	ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox(is_title, "System error, record delete failed!")
	END IF


end event

event ue_new;// Acess Rights
// pvh - 08/17/06
//If f_check_access(is_process,"N") = 0 Then Return

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

//Added by DGM
//if idw_current = idw_label THEN 
//	idw_current.Insertrow(idw_current.GetROw()) 
//	Return
//END IF	

This.Title = is_title + " - New"
ib_edit = False
ib_changed = False

isle_whcode.DisplayOnly = False /* 08/00 pconkl */

// Changing menu properties
im_menu.m_file.m_save.Enable()
im_menu.m_file.m_retrieve.Disable()
im_menu.m_record.m_delete.Disable()

// Tab properties
tab_main.SelectTab(1)
idw_main.Reset()
idw_main.Hide()
idw_warehouse.Hide()
tab_main.tabpage_reports.Enabled = False /* 12/00 PCONKL */
tab_main.tabpage_label.Enabled = False
idw_label.Reset()
// Reseting the Single line edit
isle_whcode.Text = ""
isle_whcode.SetFocus()

tab_main.tabpage_main.cb_pick_sort.visible=False

end event

event ue_retrieve;call super::ue_retrieve;isle_whcode.TriggerEvent(Modified!)
end event

event ue_postopen;
g.of_setwarehouse(TRUE)
idw_warehouse.Retrieve() /*load available warehouses*/

// Default into edit mode
This.TriggerEvent("ue_edit")

// pvh - 08/18/06
// only a superuser can edit here, all others may view only.
//
// 07/00 PCONKL
//Only a super user can see project availibility and insert or delete a project
//Only Super user can update other projects, disable search screen
// 02/08 - PCONKL - Added Super Duper user

//If gs_role <> '0' Then
If gs_role = '0' or gs_role = '-1' Then
Else
	idw_warehouse.visible = False
	im_menu.m_record.m_new.Enabled = False
	im_menu.m_record.m_delete.Enabled = False
	tab_main.tabpage_search.Enabled = False
	tab_main.tabpage_label.Enabled = False
	tab_main.tabpage_reports.Enabled = False
	im_menu.m_record.m_new.Disable()
	
//	//Default to editing current project
//	isle_whcode.Text = gs_project
	isle_whcode.Enabled = False
//	isle_whcode.TriggerEvent("modified")
	
	// 07/04 - PCONKL - Only super users can add/delete labels
	tab_main.tabpage_label.cb_project_insert_label.visible = False
	tab_main.tabpage_label.cb_project_delete_label.visible = False
	tab_main.tabpage_label.dw_label.Modify("screen_name.Protect=1 datawindow_1.Protect=1 column_name.Protect=1")
	
	// pvh - 08/18/06
	idw_main.enabled = false
	idw_search.enabled = false
	idw_warehouse.enabled = false
	tab_main.tabpage_label.dw_label.enabled = false
	tab_main.tabpage_reports.uo_report_select.enabled = false
	// 
	
End If

// pvh - 08/11/05
tab_main.tabpage_reports.uo_report_select.setProject( gs_project )
tab_main.tabpage_reports.uo_report_select.doAvailableRetrieve()
tab_main.tabpage_reports.uo_report_select.doSelectedRetrieve()
// eom

//Default to editing current project
isle_whcode.Text = gs_project
isle_whcode.TriggerEvent("modified")
end event

event close;call super::close;g.of_setwarehouse(False)
end event

event closequery;call super::closequery;
// 11/01 - PCONKL - If we changed the current project, reload the project level defaults
If idw_main.RowCount() > 0 Then
	If idw_main.GetItemString(1,'project_id') = gs_project Then
		g.of_get_project_ind()
	End If
End If
end event

type tab_main from w_std_master_detail`tab_main within w_maintenance_project
integer x = 73
integer y = 0
integer width = 4837
integer height = 2176
tabpage_reports tabpage_reports
tabpage_label tabpage_label
end type

on tab_main.create
this.tabpage_reports=create tabpage_reports
this.tabpage_label=create tabpage_label
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_reports
this.Control[iCurrent+2]=this.tabpage_label
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_reports)
destroy(this.tabpage_label)
end on

event tab_main::selectionchanged;wf_check_menu(TRUE,'sort')
CHOOSE CASE newindex
	CASE 1
		wf_check_menu(FALSE,'sort')
		idw_current = idw_main
//	CASE 2
//		idw_current = idw_reports
   CASE 3
		idw_current = idw_label
	CASE 4
		idw_current = idw_search	
END CHOOSE



end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer width = 4800
integer height = 2048
string text = " Project Information "
dw_pick_sort dw_pick_sort
cb_pick_sort cb_pick_sort
st_project_id st_project_id
sle_project sle_project
dw_warehouse dw_warehouse
dw_project dw_project
end type

on tabpage_main.create
this.dw_pick_sort=create dw_pick_sort
this.cb_pick_sort=create cb_pick_sort
this.st_project_id=create st_project_id
this.sle_project=create sle_project
this.dw_warehouse=create dw_warehouse
this.dw_project=create dw_project
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pick_sort
this.Control[iCurrent+2]=this.cb_pick_sort
this.Control[iCurrent+3]=this.st_project_id
this.Control[iCurrent+4]=this.sle_project
this.Control[iCurrent+5]=this.dw_warehouse
this.Control[iCurrent+6]=this.dw_project
end on

on tabpage_main.destroy
call super::destroy
destroy(this.dw_pick_sort)
destroy(this.cb_pick_sort)
destroy(this.st_project_id)
destroy(this.sle_project)
destroy(this.dw_warehouse)
destroy(this.dw_project)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer width = 4800
integer height = 2048
dw_search dw_search
cb_project_search cb_project_search
end type

on tabpage_search.create
this.dw_search=create dw_search
this.cb_project_search=create cb_project_search
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_search
this.Control[iCurrent+2]=this.cb_project_search
end on

on tabpage_search.destroy
call super::destroy
destroy(this.dw_search)
destroy(this.cb_project_search)
end on

type dw_pick_sort from datawindow within tabpage_main
boolean visible = false
integer x = 3191
integer y = 1680
integer width = 178
integer height = 92
integer taborder = 50
string title = "none"
string dataobject = "d_do_auto_pick"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_pick_sort from commandbutton within tabpage_main
integer x = 2066
integer y = 1180
integer width = 466
integer height = 76
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Pick Sort Order:"
end type

event clicked;w_maintenance_project.TriggerEvent('ue_set_pick_sort')
end event

event constructor;
g.of_check_label_button(this)
end event

type st_project_id from statictext within tabpage_main
integer x = 96
integer y = 32
integer width = 315
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Project ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_project from singlelineedit within tabpage_main
integer x = 425
integer y = 16
integer width = 585
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_code
Long   ll_rows


ls_code = This.Text

IF NOT IsNull(ls_code) Or ls_code <> '' THEN
	ll_rows = idw_main.Retrieve(ls_code)       // Retrieving the entry datawindow
	
	IF ib_edit THEN								 // Edit Mode
		IF ll_rows > 0 THEN
			idw_main.Show()
			tab_main.tabpage_main.cb_pick_sort.visible=True
			tab_main.tabpage_main.cb_pick_sort.bringtoTop=True
			
			// pvh - 09/29/05
			tab_main.tabpage_reports.uo_report_select.setProject( ls_code )
			tab_main.tabpage_reports.uo_report_select.doAvailableRetrieve()
			tab_main.tabpage_reports.uo_report_select.doSelectedRetrieve()
			// eom
		
			// 08/00 - PCONKL - Can not change Project ID for Existing Project!!!!
			This.DisplayOnly = True
			
			If gs_role = '0' or gs_role = '-1' Then /*only super user can see project assignments, 02/08 - PCONKL - Added Super Duper User*/
				idw_warehouse.Show()
			End If
			tab_main.tabpage_reports.Enabled = True /* 12/00 PCONKL */
			tab_main.tabpage_label.Enabled = TRUE
			idw_warehouse.TriggerEvent("ue_load") /*load available and default warehouses for project*/
			//idw_reports.TriggerEvent("ue_load") /*load available and default reports for project*/
			
			
			//--
			
			datawindowchild ldw_child

			tab_main.tabpage_label.dw_template_select.InsertRow(0)
			
			tab_main.tabpage_label.dw_template_select.GetChild( "template_name", ldw_child)
			ldw_child.SetTransObject(SQLCA)
			ldw_child.Retrieve(ls_code)
			
			string ls_str, ls_template
			
			ls_str = "TEMPLATE:" + gs_userid
			
			ls_template = ProfileString(gs_inifile,gs_project, ls_str,"")
			
			if IsNull(ls_template) or trim(ls_template) = '' then
				ls_template = "BASELINE"
			end if
			
			tab_main.tabpage_label.dw_template_select.SetItem( 1, "template_name", ls_template )
			
			//--
			
			
			idw_label.TriggerEvent("ue_retrieve")
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
			If gs_role = '0' or gs_role = '-1' Then /* 07/00 pconkl - only super can delete a project*/
				im_menu.m_record.m_delete.Enable()
			End If
		ELSE
			MessageBox(is_title, "Record not found, please enter again!", Exclamation!)
			isle_whcode.SetFocus()
			isle_whcode.SelectText(1,Len(ls_code))
  		END IF
			
	ELSE													  // New Mode
		IF ll_rows > 0 THEN
			MessageBox(is_title, "Record already exist, please enter again", Exclamation!)
			isle_whcode.SetFocus()
			isle_whcode.SelectText(1,Len(ls_code))		
		ELSE
			idw_main.InsertRow(0)
			idw_main.SetItem(1,"project_id",ls_code)

			// pvh - 09/29/05
			tab_main.tabpage_reports.uo_report_select.setProject( ls_code )
			tab_main.tabpage_reports.uo_report_select.doAvailableRetrieve()
			tab_main.tabpage_reports.uo_report_select.doSelectedRetrieve()
			// eom
		
			// 08/00 pconkl - set prefixes
			idw_main.Show()
			tab_main.tabpage_main.cb_pick_sort.visible=True
			tab_main.tabpage_main.cb_pick_sort.bringtoTop=True
			If gs_role = '0' or gs_role = '1' Then /*only super user can see project assignments*/
				idw_warehouse.Show()
			End If
			tab_main.tabpage_reports.Enabled = True /* 12/00 PCONKL */
			tab_main.tabpage_label.Enabled = TRUE
			idw_warehouse.TriggerEvent("ue_load") /*load available warehouses for project*/
			//idw_reports.TriggerEvent("ue_load") /*load available and default reports for project*/
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
		END IF
	END IF
ELSE
	MessageBox(is_title, "Please enter the Project ID!", Exclamation!)
	isle_whcode.SetFocus()
END IF	

end event

type dw_warehouse from u_dw_ancestor within tabpage_main
event ue_load ( )
event ue_save ( )
integer x = 2414
integer y = 476
integer width = 946
integer height = 444
integer taborder = 20
string dataobject = "d_project_warehouse_list"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_load();Long			llRowCount,	llRowPos, llCount,i, llWhCount, llwhPos, llFind
		
String		lsProject,	lswarehouse, lsSom, sql_syntax, ERRORS
DataStore 	ldsProjectWarehouse

This.SetRedraw(false)
SetPointer(Hourglass!)

llRowCount = This.rowCount()	

//Reset (might have switched projects)
For llRowPos = 1 to llRowCount
	This.SetItem(llRowPos,"c_avail",'N')
	This.SetItem(llRowPos,"c_default",'N')
	This.SetItem(llRowPos,"c_etom",'')
Next

If idw_main.RowCount() > 0 Then
	
	ldsProjectWarehouse = Create DataStore

	sql_syntax = "Select wh_code, Standard_of_Measure "
	sql_syntax += " from Project_Warehouse "
	sql_syntax += " Where Project_id = '" + idw_main.getItemString(1,"project_id") + "';"

	ldsProjectWarehouse.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
	ldsProjectWarehouse.SetTransObject(SQLCA)

	llWhCount = ldsProjectWarehouse.Retrieve()
	
	//For each warehouse, check the box in the list
	For llwhPos = 1 to llwhCount
		
		lsWarehouse = ldsProjectWarehouse.GetItemString(llwhPos,"wh_code")
		llFind = This.Find("Upper(wh_code) = '" + lsWarehouse + "'",1, this.RowCount())
		
		If llFind > 0 Then
			This.SetItem(llFind,"c_avail",'Y')
			This.SetItem(llFind,"c_orig_value",'Y')
			This.SetItem(llFind,"c_etom",ldsProjectWarehouse.GetItemString(llwhPos,"standard_of_measure"))
		End If
		
		//Might be default
		If lsWarehouse = idw_Main.GetITemstring(1,'wh_code') Then
			This.SetItem(llFind,"c_default",'Y')
		End If
		
	Next
	
End If

//Scroll to the first avail
llFind = This.Find("c_Avail = 'Y'",1,This.RowCount())
If llFind > 0 Then
	This.ScrollToRow(llFind)
End If

This.SetRedraw(True)
SetPointer(Arrow!)

	

end event

event ue_save;String	lsProject,	&
			lsWarehouse,ls_measure, lsErrText
Long		llRowCount,	&
			llRowPos
Date	ldtToday
String ls_cc_blindknown_flag, ls_cc_blindknown_prt_flag, ls_count_differences //TimA 04/06/11 Issue #183

ldtToday = today()

lsProject = idw_main.GetItemString(1,"project_id")

If not ibWarehouseChg Then Return /*get out if no warehouses have changed*/

//09/09 - PCONKL - Don't delete and rebuild each time, we are losing other data in the record when we do that.
//						Only delete a Project/Warehouse Record if the warehouse

llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	
	lsWarehouse = This.GetITemString(llRowPOs,"wh_code")
	ls_measure = This.GetITemString(llRowPOs,"c_etom")
	ls_cc_blindknown_flag = "B"
	ls_cc_blindknown_prt_flag = "B"
	ls_count_differences = "N"

	If This.GetITemString(llRowPos,'c_avail') = This.GetITemString(llRowPos,'c_orig_value') Then Continue /*unchanged*/
	
	If This.GetITemString(llRowPos,'c_avail') = 'Y' Then /*added */
		
		Insert into Project_warehouse (project_id, wh_code,last_user,last_update,standard_of_measure,cc_blindknown_flag, cc_blindknown_prt_flag, count_differences) &
		Values (:lsProject,:lsWarehouse,:gs_userid,:ldtToday,:ls_measure, :ls_cc_blindknown_flag, :ls_cc_blindknown_prt_flag, :ls_count_differences);
		
		//Insert into Project_warehouse (project_id, wh_code,last_user,last_update,standard_of_measure) &
		//Values (:lsProject,:lsWarehouse,:gs_userid,:ldtToday,:ls_measure)
		//Using SQLCA;
		//Execute Immediate "COMMIT" using SQLCA;
		//TimA 05/03/11  Removed the Execute Immediate .... per code review discussion
	
	Else /*removed */
		
		//TimA 05/03/11  Removed the Execute Immediate .... per code review discussion
		//Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
		Delete from project_warehouse where project_id = :lsProject and wh_code = :lsWarehouse;
		//Using SQLCA;
		///Execute Immediate "COMMIT" using SQLCA;
		
	End If
	
Next

////Delete and rebuild where avail set to Y
//
//lsProject = idw_main.GetItemString(1,"project_id")
//Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
//Delete from project_warehouse where project_id = :lsProject;
//
//llRowCount = This.RowCount()
//For llRowPos = 1 to llRowCount
//	
//	If This.GetItemString(llRowPos,"c_avail") = 'Y' Then
//		lsWarehouse = This.GetITemString(llRowPOs,"wh_code")
//		ls_measure = This.GetITemString(llRowPOs,"c_etom")
//		Insert into Project_warehouse (project_id, wh_code,last_user,last_update,standard_of_measure) &
//		Values (:lsProject,:lsWarehouse,:gs_userid,:ldtToday,:ls_measure)
//		Using SQLCA;
//	End If
//	
//Next
//
//Execute Immediate "COMMIT" using SQLCA;

ibWarehouseChg = False
end event

event itemchanged;Long	lLRowCount,	&
		llRowPos,ll_row
string ls_temp,ls_wh_code,ls_project
ib_changed = True
		
ibWarehouseChg = True /*we will only rebuild if changed*/

Choose Case dwo.name
		
	Case "c_default" /*update default warehouse on main DW*/
						
		If Data = 'Y' Then
			Idw_main.SetItem(1,"wh_code",This.GetItemString(row,"wh_code"))
			//Reset any other checked defaults
			llRowCount = This.RowCOunt()
			For llRowPos = 1 to llRowCount
				If llRowPOS <> row then
					This.SetItem(llRowPos,"c_default",'N')
				End If
			Next
		Else /*no default Set anymore*/
			Idw_main.SetItem(1,"wh_code",'')
		End If
		
	Case "c_avail"
				
		//un-check default if not available
		If data = 'N' Then
			If This.GetItemString(row,"c_default") = 'Y' Then
				This.SetItem(row,"c_default",'N')
				Idw_main.SetItem(1,"wh_code",'')
			End If
			This.SetItem(row,"c_etom",'')
		End If			
		
	Case 'c_etom'
		
		//To assign the value in data store of Project Warehouse....
		ib_etohChg = TRUE		
      ls_project = idw_main.object.project_id[1]
		ls_wh_code = this.object.wh_code[row]
		//Filter
      ll_row = g.of_project_warehouse(ls_project,ls_wh_code) 
	   IF ll_row > 0 THEN g.ids_project_warehouse.object.standard_of_measure[ll_row]=data 			
End Choose
end event

event constructor;call super::constructor;ib_etohChg = FALSE

g.of_check_label(this) 
end event

type dw_project from datawindow within tabpage_main
event process_enter pbm_dwnprocessenter
integer y = 112
integer width = 4686
integer height = 1928
integer taborder = 20
string dataobject = "d_maintenance_project"
boolean border = false
boolean livescroll = true
end type

event process_enter;If This.GetColumnName() <> "remark" Then
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If
end event

event itemchanged;ib_changed = True
end event

event constructor;
g.of_check_label(this) 
end event

type dw_search from datawindow within tabpage_search
integer x = 27
integer y = 148
integer width = 3214
integer height = 1608
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_maintenance_project_search"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;// Pasting the record to the main entry datawindow
IF Row > 0 THEN
	w_maintenance_project.TriggerEvent("ue_edit")
	IF NOT ib_changed THEN
		isle_whcode.Text = This.GetItemString(row,"project_id")
		isle_whcode.TriggerEvent("modified")
	END IF
END IF
end event

event constructor;g.of_check_label(this) 
end event

type cb_project_search from commandbutton within tabpage_search
integer x = 27
integer y = 28
integer width = 357
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
end type

event clicked;SetPointer(Hourglass!)

dw_search.SetRedraw(False)
dw_search.Reset()
ii_row = dw_search.Retrieve()
IF ii_row < 1 THEN 
	MessageBox(is_title,"No record found!")
END IF
dw_search.SetRedraw(True)
SetPointer(Arrow!)

end event

event constructor;
g.of_check_label_button(this)
end event

type tabpage_reports from userobject within tab_main
integer x = 18
integer y = 112
integer width = 4800
integer height = 2048
long backcolor = 79741120
string text = "Reports"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
uo_report_select uo_report_select
end type

on tabpage_reports.create
this.uo_report_select=create uo_report_select
this.Control[]={this.uo_report_select}
end on

on tabpage_reports.destroy
destroy(this.uo_report_select)
end on

event constructor;
if Upper(gs_project) = 'CHINASIMS' then
	uo_report_select.cb_select_avail_report_baseline_report.visible = false
end if
end event

type uo_report_select from u_select_available_report within tabpage_reports
integer x = 9
integer y = 44
integer width = 3442
integer height = 1904
integer taborder = 30
end type

on uo_report_select.destroy
call u_select_available_report::destroy
end on

type tabpage_label from userobject within tab_main
integer x = 18
integer y = 112
integer width = 4800
integer height = 2048
long backcolor = 79741120
string text = "Screen Labels"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_col_sort cb_col_sort
cb_project_create_new_template cb_project_create_new_template
dw_template_select dw_template_select
cb_project_delete_label cb_project_delete_label
cb_project_insert_label cb_project_insert_label
dw_label dw_label
end type

on tabpage_label.create
this.cb_col_sort=create cb_col_sort
this.cb_project_create_new_template=create cb_project_create_new_template
this.dw_template_select=create dw_template_select
this.cb_project_delete_label=create cb_project_delete_label
this.cb_project_insert_label=create cb_project_insert_label
this.dw_label=create dw_label
this.Control[]={this.cb_col_sort,&
this.cb_project_create_new_template,&
this.dw_template_select,&
this.cb_project_delete_label,&
this.cb_project_insert_label,&
this.dw_label}
end on

on tabpage_label.destroy
destroy(this.cb_col_sort)
destroy(this.cb_project_create_new_template)
destroy(this.dw_template_select)
destroy(this.cb_project_delete_label)
destroy(this.cb_project_insert_label)
destroy(this.dw_label)
end on

type cb_col_sort from commandbutton within tabpage_label
integer x = 3447
integer y = 44
integer width = 567
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Column Sort Order"
end type

event clicked;//28-Jul-2014 : Madhu- Added code to open custom DW to sort column

str_parms lstrparms
lstrparms.integer_arg[1] = il_dwno

OpenwithParm(w_custom_dw_sort,lstrparms)
end event

type cb_project_create_new_template from commandbutton within tabpage_label
integer x = 2807
integer y = 44
integer width = 590
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create New Template"
end type

event clicked;
Open(w_create_template)

datawindowchild ldw_child

string ls_template 

ls_template = dw_template_select.GetItemString( 1, "template_name")

dw_template_select.GetChild( "template_name", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve( gs_project)

dw_template_select.SetItem(1, "template_name", ls_template)
end event

event constructor;g.of_check_label_button(this)
end event

type dw_template_select from datawindow within tabpage_label
integer x = 1266
integer y = 40
integer width = 1495
integer height = 124
integer taborder = 40
string title = "none"
string dataobject = "d_template_select"
boolean border = false
boolean livescroll = true
end type

event itemchanged;
idw_label.TriggerEvent("ue_retrieve")
end event

event constructor;
g.of_check_label(this) 
end event

type cb_project_delete_label from commandbutton within tabpage_label
integer x = 494
integer y = 44
integer width = 279
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;dw_label.TriggerEvent('ue_delete')
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_project_insert_label from commandbutton within tabpage_label
integer x = 59
integer y = 44
integer width = 279
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert"
end type

event clicked;
dw_label.TriggerEvent('ue_insert')
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_label from u_dw_ancestor within tabpage_label
integer y = 168
integer width = 4430
integer height = 1736
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_column_labels"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_retrieve;//
string ls_template

SetPointer(Hourglass!)

dw_template_select.AcceptText()
			
ls_template = dw_template_select.GetItemString( 1, "template_name")


This.Retrieve(idw_main.GetItemString(1,"project_id"), ls_template)



end event

event ue_save;integer li_rtn
SQLCA.DBParm = "disablebind =0"
li_rtn = This.Update(TRUE,False)
SQLCA.DBParm = "disablebind =1"

end event

event itemchanged;call super::itemchanged;ib_changed = TRUE
end event

event ue_insert;call super::ue_insert;Long	llRow, llNewRow
String ls_template

dw_template_select.AcceptText()
			
ls_template = dw_template_select.GetItemString( 1, "template_name")


llRow = This.GetRow()

If llRow > 0 Then
	llNewRow = This.InsertRow(llRow)
Else
	llNewRow = This.InsertRow(0)
End If

This.SetItem(llNewROw,'project_id',gs_project)
This.SetItem(llNewROw,'Template_Name',ls_template)

This.SetRow(llNewRow)
This.ScrolltoRow(llNewRow)


end event

event ue_delete;call super::ue_delete;
If this.GetRow() > 0 Then
	This.DEleteRow(this.GetRow())
	ib_changed = True
End If
end event

event ue_postitemchanged;call super::ue_postitemchanged;
String	lsLabel, lsColumn, lsFind
Long	llFindRow, llCount
// if a column label was modifed, see if the users want to update all other of the same column name to the same label

If dwo.name = 'column_label' Then
		
	lscolumn = this.GetITemString(row,'column_name')
	lslabel = this.GetITemString(row,'column_label')
	llCount = 0
	
	//If a user field, don't update all since they are not relevent across tables
	If Upper(left(lsColumn,4)) = 'USER' Then Return
	
	//get a count of rows with this column Name
	lsFind = "column_name = '" + lsColumn + "'"
	llFindRow = This.Find(lsFind,1,This.RowCOunt())
	Do While llFindRow > 0
		llCount ++
		llFindRow ++
		If llFindRow > This.RowCount() or llCount > 1 Then Exit
		llFindRow = This.Find(lsFind,llFindRow,This.RowCOunt())
	Loop
	
	If llCount > 1 Then
		If Messagebox(is_title,'Would you like to set all of the instances of ' + lsColumn + ' to ' + lsLabel + '?',Question!,yesNo!,1) = 1 then
			llFindRow = This.Find(lsFind,1,This.RowCOunt())
			Do While llFindRow > 0
				This.SetItem(llFindRow,'column_label',lsLabel)
				llFindRow ++
				If llFindRow > This.RowCount()  Then Exit
				llFindRow = This.Find(lsFind,llFindRow,This.RowCOunt())
			Loop
		End If
	End If
	
End IF /*column label changed*/
end event

event clicked;call super::clicked;//28-Jul-2014 :Madhu- Added code to enable, cb_custom_label, if DW name present in Custom_Datawindow table.

String lsdwname,lsFind
long llFindRow

lsdwname = this.GetITemString(row,'DataWindow')
lsFind = "DataWindow='" + lsdwname+"'"

IF gs_role ='-1' Then
   llFindRow=ids_custom_label.Find( lsFind, 1 , ids_custom_label.rowcount())
	IF llFindRow > 0 Then
		tab_main.tabpage_label.cb_col_sort.Enabled =TRUE
	ELSE
		tab_main.tabpage_label.cb_col_sort.Enabled =FALSE
	END IF
END IF

//21-Apr-2015 Madhu- Retrieve columns based on Project + Selected DW and custom datawindow no is unique
IF llFindRow > 0 THEN
	SELECT Custom_Datawindow_No into :il_dwno
	FROM dbo.Custom_Datawindow with (nolock) 
	WHERE Project_ID=:gs_project
	AND DataWindow=:lsdwname;
END IF

ids_dwname =lsdwname
//il_dwno =llFindRow
end event

