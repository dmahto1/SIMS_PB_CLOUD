$PBExportHeader$w_maintenance_item_group.srw
$PBExportComments$-
forward
global type w_maintenance_item_group from w_std_simple_list
end type
end forward

global type w_maintenance_item_group from w_std_simple_list
integer width = 2999
string title = "Item Group"
end type
global w_maintenance_item_group w_maintenance_item_group

type variables
w_maintenance_item_group iw_window
end variables

on w_maintenance_item_group.create
call super::create
end on

on w_maintenance_item_group.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_save;String ls_code, ls_prev_code
Long ll_rowcnt, ll_row

// Purpose : To update the datawindow

If f_check_access(is_process,"S") = 0 THEN Return -1

If dw_list.AcceptText() = -1 Then Return -1

dw_list.Sort()

ll_rowcnt = dw_list.RowCount()

// Deleting the blank Rows
FOR ll_row = ll_rowcnt to 1 Step -1
	ls_code = dw_list.GetItemString(ll_row, "grp")
	IF IsNull(ls_code) THEN
		dw_list.DeleteRow(ll_row)
	END IF
NEXT

// Detect duplicate rows in Datawindow
dw_list.Sort()                                       
ll_rowcnt = dw_list.RowCount()
For ll_row = ll_rowcnt To 1 Step -1
	ls_code = dw_list.GetItemString(ll_row,"grp")
	IF ls_code = ls_prev_code THEN
		MessageBox(is_title, "Duplicate record found, please check!")
		f_setfocus(dw_list, ll_row,"grp")
		Return 0
	ELSE
		ls_prev_code = ls_code
	END IF
Next


// After validation updating the datawindow
Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
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

event ue_new;call super::ue_new;
// 07/00 PCONKL - Default to current project
dw_list.SetItem(dw_list.GetRow(),"project_id",gs_project)

dw_list.SetColumn("grp")
end event

event open;call super::open;String	lsFilter

iw_window = This

// 07/00 PCONKL - Only sho for current Project - Filter is case specific
lsFilter = "Upper(Project_id) = '" + Upper(gs_project) + "'"
dw_list.SetFilter(lsFilter)
dw_list.Filter()
ilHelpTopicID = 538 /*set help topic ID*/
end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_item_group
integer width = 2862
string dataobject = "d_maintanence_item_group"
end type

event dw_list::process_enter;// If last row & Column then insert new row
IF This.GetColumnName() = "grp_desc" THEN
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

