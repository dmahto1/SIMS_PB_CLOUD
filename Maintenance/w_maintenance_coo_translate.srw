HA$PBExportHeader$w_maintenance_coo_translate.srw
$PBExportComments$-
forward
global type w_maintenance_coo_translate from w_std_simple_list
end type
end forward

global type w_maintenance_coo_translate from w_std_simple_list
integer width = 2542
string title = "Country of Origin Translate List"
end type
global w_maintenance_coo_translate w_maintenance_coo_translate

type variables
w_maintenance_coo_translate iw_window
n_warehouse i_nwarehouse

end variables

on w_maintenance_coo_translate.create
call super::create
end on

on w_maintenance_coo_translate.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_save;String ls_serial
Long ll_rowcnt, ll_row

// Purpose : To update the datawindow

If f_check_access(is_process,"S") = 0 THEN Return -1

If dw_list.AcceptText() = -1 Then Return -1



ll_rowcnt = dw_list.RowCount()

// Deleting the blank Rows
FOR ll_row = ll_rowcnt to 1 Step -1
	ls_serial = dw_list.object.serial_division[ll_row]
	IF IsNull(ls_serial) THEN
		dw_list.DeleteRow(ll_row)
	END IF
NEXT

// Detect duplicate rows in Datawindow
                                     

Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
IF dw_list.Update(FALSE, FALSE) > 0 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.SqlCode = 0 THEN
		dw_list.Sort()
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

event ue_new;call super::ue_new;
dw_list.SetColumn("serial_division")
dw_list.object.project_id[dw_list.Getrow()]= gs_project
end event

event ue_postopen;call super::ue_postopen;iw_window = This
end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_coo_translate
integer y = 32
integer width = 2414
string dataobject = "d_coo_translate_grid"
end type

event dw_list::process_enter;// If last row & Column then insert new row
IF This.GetColumnName() = "designating_code" THEN
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

event dw_list::ue_postitemchanged;call super::ue_postitemchanged;String ls_serial, ls_prev_serial,ls_supplier,ls_prev_supplier,ls_syntax
Long ll_rowcnt,ll_find
IF row = 1 THEN Return
CHOOSE CASE dwo.Name
	CASE 'serial_division','serial_supplier'
		ls_serial   = dw_list.object.serial_division[row]
		ls_supplier = dw_list.object.serial_supplier[row]
		ls_syntax = "serial_division = '" +ls_serial + "' and serial_supplier = '"+ls_supplier+ "'"
		ll_find = dw_list.Find(ls_syntax,1, row - 1)
		IF ll_find > 0 THEN
			MessageBox(is_title, "Duplicate record found, please check!")
			Post Setcolumn("serial_division")			
		END IF	
END CHOOSE

	
end event

event dw_list::ue_tabout;call super::ue_tabout;IF This.Rowcount() = This.Getrow() THEN  Parent.Event ue_new()
end event

