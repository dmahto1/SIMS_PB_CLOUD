$PBExportHeader$w_maintenance_nike_serial_prefix.srw
$PBExportComments$BCR - UOM Maintenance window
forward
global type w_maintenance_nike_serial_prefix from w_std_simple_list
end type
end forward

global type w_maintenance_nike_serial_prefix from w_std_simple_list
integer width = 2793
integer height = 1648
string title = "Serial PreFix List"
end type
global w_maintenance_nike_serial_prefix w_maintenance_nike_serial_prefix

type variables

w_maintenance_nike_serial_prefix iw_window

end variables

on w_maintenance_nike_serial_prefix.create
call super::create
end on

on w_maintenance_nike_serial_prefix.destroy
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
	ls_code = dw_list.GetItemString(ll_row, "code_id")
	IF IsNull(ls_code) THEN
		dw_list.DeleteRow(ll_row)
	END IF
NEXT

// Detect duplicate rows in Datawindow
dw_list.Sort()                                       
ll_rowcnt = dw_list.RowCount()
For ll_row = ll_rowcnt To 1 Step -1
	ls_code = dw_list.GetItemString(ll_row,"code_id")
	IF ls_code = ls_prev_code THEN
		MessageBox(is_title, "Duplicate ID record found, please check!")
		f_setfocus(dw_list, ll_row, "code_id")
		Return 0
	ELSE
		ls_prev_code = ls_code
	END IF
Next


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

event ue_new;call super::ue_new;//Inserts default values
string ls_ctype,ls_proj


ls_ctype=dw_list.Getitemstring(dw_list.Getrow(),'code_type')
ls_proj=dw_list.Getitemstring(dw_list.Getrow(),'project_id')

IF isnull(ls_ctype) THEN dw_list.Setitem(dw_list.Getrow(),'code_type','SERPF')
IF isnull(ls_proj) THEN dw_list.Setitem(dw_list.Getrow(),'project_id',gs_project)

dw_list.SetColumn('code_id')
end event

event open;call super::open;String lsFilter
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
dw_list.SetFilter(lsFilter)
dw_list.Filter()
//ilHelpTopicID = 538 /*set help topic ID*/

iw_window = This
end event

event ue_retrieve;call super::ue_retrieve;String lsFilter

//Filter
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
dw_list.SetFilter(lsFilter)
dw_list.Filter()
end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_nike_serial_prefix
integer x = 37
integer y = 32
integer width = 2688
string dataobject = "d_maintenance_nike_serial_prefix"
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

