$PBExportHeader$w_maintenance_tax.srw
$PBExportComments$-
forward
global type w_maintenance_tax from w_std_simple_list
end type
end forward

global type w_maintenance_tax from w_std_simple_list
integer width = 3401
integer height = 1960
string title = "Tax Table"
end type
global w_maintenance_tax w_maintenance_tax

type variables
w_maintenance_tax iw_window

end variables

on w_maintenance_tax.create
call super::create
end on

on w_maintenance_tax.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_save;String ls_code, ls_class, ls_prev_code, ls_prev_class
Long ll_rowcnt, ll_row

// Purpose : To update the datawindow

If f_check_access( is_process,"S") = 0 THEN Return -1

If dw_list.AcceptText() = -1 Then Return -1

dw_list.Sort()

ll_rowcnt = dw_list.RowCount()

// Deleting the blank Rows
FOR ll_row = ll_rowcnt to 1 Step -1
	ls_code = dw_list.GetItemString(ll_row, "tax_code")
	ls_code = dw_list.GetItemString(ll_row, "tax_class")
	IF IsNull(ls_code) or IsNull(ls_class) THEN 
		dw_list.DeleteRow(ll_row)
	END IF
NEXT

// Detect duplicate rows in Datawindow
dw_list.Sort()                                       
ll_rowcnt = dw_list.RowCount()
For ll_row = ll_rowcnt To 1 Step -1
	ls_code = dw_list.GetItemString(ll_row,"tax_code")
	ls_code = dw_list.GetItemString(ll_row, "tax_class")
	IF ls_code = ls_prev_code and ls_class = ls_prev_class THEN
		MessageBox(is_title, "Duplicate record found, please check!")
		f_setfocus(dw_list, ll_row, "tax_code")
		Return -1
	ELSE
		ls_prev_code = ls_code
		ls_prev_class = ls_class
	END IF
Next

// After validation updating the datawindow
Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
IF dw_list.Update(FALSE, FALSE) > 0 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.SqlCode = 0 THEN
		dw_list.ResetUpdate()
		ib_changed = False
		Return 0
	ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox(is_title,Sqlca.SqlErrText, Exclamation!, Ok!, 1)
		Return -1
	END IF
ELSE
	Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox(is_title,"Error while saving record!")
	Return -1
END IF						

end event

event ue_new;call super::ue_new;dw_list.SetColumn("tax_code")
end event

event open;call super::open;iw_window = This
end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_tax
integer x = 32
integer y = 16
integer width = 3296
integer height = 1732
string dataobject = "d_maintenance_tax"
end type

event dw_list::process_enter;// If last row & Column then insert new row
IF This.GetColumnName() = "tax_type" THEN
	IF This.GetRow() = This.RowCount() THEN
		iw_window.PostEvent("ue_new")
	ELSE
		Send(Handle(This),256,9,Long(0,0))
		Return 1
	END IF
ELSE
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If

end event

