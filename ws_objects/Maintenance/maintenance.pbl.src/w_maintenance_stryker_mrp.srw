$PBExportHeader$w_maintenance_stryker_mrp.srw
$PBExportComments$BCR - UOM Maintenance window
forward
global type w_maintenance_stryker_mrp from w_std_simple_list
end type
end forward

global type w_maintenance_stryker_mrp from w_std_simple_list
integer width = 3643
integer height = 1648
string title = "Stryker Sku MRP"
end type
global w_maintenance_stryker_mrp w_maintenance_stryker_mrp

type variables

//w_maintenance_nike_citrix_mapping

window iw_window

end variables

on w_maintenance_stryker_mrp.create
call super::create
end on

on w_maintenance_stryker_mrp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_save;String ls_code, ls_prev_code
Long ll_rowcnt, ll_row

// Purpose : To update the datawindow


If dw_list.AcceptText() = -1 Then Return -1


// After validation updating the datawindow
Execute Immediate "Begin Transaction" using SQLCA;  // Turned Autocommit on, requiring 'Begin Transaction'
SQLCA.DBParm = "disablebind =0"
IF dw_list.Update(FALSE, FALSE) > 0 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.SqlCode = 0 THEN
		dw_list.ResetUpdate()
		ib_changed = False
		SQLCA.DBParm = "disablebind =1"
		Return 0
	ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
		SQLCA.DBParm = "disablebind =1"
		MessageBox(is_title,Sqlca.SqlErrText, Exclamation!, Ok!, 1)
		Return -1
	END IF
ELSE
	Execute Immediate "ROLLBACK" using SQLCA;
	SQLCA.DBParm = "disablebind =1"
	MessageBox(is_title,"Error while saving record!")
	Return -1
END IF						

end event

event ue_new;
//Ancestor Override

window lw_maintenance_stryker_mrp_edit

OpenWithParm (lw_maintenance_stryker_mrp_edit, 0, "w_maintenance_stryker_mrp_edit")

if message.DoubleParm = 1 then
	SetPointer(Hourglass!)
	dw_list.Retrieve()
end if

////Inserts default values
//string ls_ctype,ls_proj
//
//
//ls_ctype=dw_list.Getitemstring(dw_list.Getrow(),'code_type')
//ls_proj=dw_list.Getitemstring(dw_list.Getrow(),'project_id')
//
//IF isnull(ls_ctype) THEN dw_list.Setitem(dw_list.Getrow(),'code_type','STRWH')
//IF isnull(ls_proj) THEN dw_list.Setitem(dw_list.Getrow(),'project_id',gs_project)
//
//dw_list.SetColumn('code_id')
end event

event open;call super::open;datawindowchild ldw_child
String lsFilter
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
dw_list.SetFilter(lsFilter)
dw_list.Filter()
//ilHelpTopicID = 538 /*set help topic ID*/

SetPointer(Hourglass!)

iw_window = This

dw_list.GetChild("user_field1", ldw_child)

ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(gs_project)
end event

event ue_retrieve;call super::ue_retrieve;String lsFilter

//Filter
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
dw_list.SetFilter(lsFilter)
dw_list.Filter()
end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_stryker_mrp
integer x = 37
integer y = 32
integer width = 3534
string dataobject = "d_maintenance_stryker_mrp_sku"
boolean hscrollbar = true
end type

event dw_list::process_enter;// If last row & Column then insert new row
IF This.GetColumnName() = "code_descript" THEN
	IF This.GetRow() = This.RowCount() THEN
		iw_window.PostEvent("ue_new")
	Else
		Send(Handle(This),256,9,Long(0,0))
		Return 1		
	END IF
ELSE
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If

end event

event dw_list::itemchanged;//overide
ib_changed = True
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;
this.SelectRow ( 0, false ) 
this.SelectRow ( currentrow, true ) 
end event

event dw_list::doubleclicked;call super::doubleclicked;
window lw_maintenance_stryker_mrp_edit
long ll_id

if row > 0 then

	ll_id = dw_list.GetItemNumber( row, "id_no")

	OpenWithParm (lw_maintenance_stryker_mrp_edit, ll_id, "w_maintenance_stryker_mrp_edit")
	
	if message.DoubleParm = 1 then
		SetPointer(Hourglass!)
		dw_list.Retrieve()
	end if
	
end if
end event

