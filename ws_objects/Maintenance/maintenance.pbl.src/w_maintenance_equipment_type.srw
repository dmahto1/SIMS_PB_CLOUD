$PBExportHeader$w_maintenance_equipment_type.srw
$PBExportComments$Equipment type maintenance
forward
global type w_maintenance_equipment_type from w_std_simple_list
end type
end forward

global type w_maintenance_equipment_type from w_std_simple_list
integer width = 2217
integer height = 1668
string title = "Equipment Type List"
end type
global w_maintenance_equipment_type w_maintenance_equipment_type

type variables
w_maintenance_equipment_type iw_window
end variables

on w_maintenance_equipment_type.create
call super::create
end on

on w_maintenance_equipment_type.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_save;String ls_code, ls_prev_code
Long ll_rowcnt, ll_row

// Purpose : To update the datawindow

If f_check_access( is_process,"S") = 0 THEN Return -1

If dw_list.AcceptText() = -1 Then Return -1

dw_list.Sort()

ll_rowcnt = dw_list.RowCount()

// Deleting the blank Rows
FOR ll_row = ll_rowcnt to 1 Step -1
	ls_code = dw_list.GetItemString(ll_row, "equipment_type_cd")
	IF IsNull(ls_code) THEN
		dw_list.DeleteRow(ll_row)
	END IF
NEXT

// Detect duplicate rows in Datawindow
dw_list.Sort()                                       
ll_rowcnt = dw_list.RowCount()
For ll_row = ll_rowcnt To 1 Step -1
	ls_code = dw_list.GetItemString(ll_row,"equipment_type_cd")
	IF ls_code = ls_prev_code THEN
		MessageBox(is_title, "Duplicate record found, please check!")
		f_setfocus(dw_list, ll_row,"equipment_type_cd")
		Return -1
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

event ue_new;call super::ue_new;dw_list.SetITem(dw_list.Rowcount(),'project_id',gs_project)
dw_list.SetColumn("equipment_type_cd")
end event

event open;call super::open;iw_window = This

end event

event ue_preopen;
// Intitialize
This.X = 0
This.Y = 0
is_process = Message.StringParm
is_title = This.Title


end event

event ue_retrieve;
//Ancestor overridden

Integer li_return

IF ib_changed THEN
	Choose Case MessageBox(is_title,"Save Changes?",Question!,YesNoCancel!,3)
	   Case 1
		   li_return = Trigger Event ue_save()
			IF li_return = 0 THEN 
				dw_list.Retrieve()
				ib_changed = False
			END IF
   	Case 2 
			dw_list.Retrieve()
			ib_changed = False
	End Choose 		
ELSE
	dw_list.Retrieve(gs_project)
	ib_changed = False
END IF
end event

event ue_postopen;call super::ue_postopen;
dw_list.SetTransObject(sqlca)
This.triggerEvent('ue_retrieve')
end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_equipment_type
integer width = 2089
string dataobject = "d_maintenance_equipment_type"
end type

event dw_list::process_enter;// If last row & Column then insert new row
IF This.GetColumnName() = "equipment_type_desc" THEN
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

event dw_list::itemchanged;

//ancestor overridden

ib_changed = True
end event

