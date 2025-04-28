HA$PBExportHeader$w_maintenance_hazmat.srw
$PBExportComments$- Maintain Hazmat text info
forward
global type w_maintenance_hazmat from w_std_simple_list
end type
end forward

global type w_maintenance_hazmat from w_std_simple_list
integer width = 2743
integer height = 1892
string title = "Hazardous Material Text"
end type
global w_maintenance_hazmat w_maintenance_hazmat

type variables
w_maintenance_hazmat iw_window

end variables

on w_maintenance_hazmat.create
call super::create
end on

on w_maintenance_hazmat.destroy
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

//// Detect duplicate rows in Datawindow
//dw_list.Sort()                                       
//ll_rowcnt = dw_list.RowCount()
//For ll_row = ll_rowcnt To 1 Step -1
//	ls_code = dw_list.GetItemString(ll_row,"ord_type")
//	IF ls_code = ls_prev_code THEN
//		MessageBox(is_title, "Duplicate record found, please check!")
//		f_setfocus(dw_list, ll_row, "ord_type")
//		Return -1
//	ELSE
//		ls_prev_code = ls_code
//	END IF
//Next

// After validation updating the datawindow
Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
SQLCA.DBParm = "disablebind =0"
IF dw_list.Update(FALSE, FALSE) > 0 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.SqlCode = 0 THEN
		dw_list.ResetUpdate()
		ib_changed = False
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

event ue_new;call super::ue_new;dw_list.SetColumn("hazard_text_cd")

//03/03 - Pconkl - set project for new record
dw_list.SetItem(dw_list.GetRow(),'Project_id',gs_project)
end event

event open;// 03/03 - PConkl - Overriding Ancestor script so we can retrive by Project
DatawindowChild	ldwc

iw_window = This
ilHelpTopicID = 538 /*set help topic ID*/

// Intitialize
This.X = 0
This.Y = 0
is_process = Message.StringParm
is_title = This.Title

//Transport Mode dropdown loaded by project
dw_list.getChild('transport_mode',ldwc)
ldwc.SetTransObject(sqlca)
If ldwc.Retrieve(gs_Project) = 0 Then
	ldwc.InsertRow(0)
End IF

dw_list.SetTransObject(sqlca)
dw_list.Retrieve(gs_project)

end event

event ue_retrieve;// 03/03 - Pconkl - Overriding ancestor script so we can retrive by Project

// Purpose : To Retrieve the records from database

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
			dw_list.Retrieve(gs_project)
			ib_changed = False
	End Choose 		
ELSE
	dw_list.Retrieve(gs_project)
	ib_changed = False
END IF

end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_hazmat
integer y = 32
integer width = 2633
integer height = 1624
string dataobject = "d_maintenance_hazmat"
boolean hscrollbar = true
end type

event dw_list::process_enter;// If last row & Column then insert new row
//IF This.GetColumnName() = "hazard_text" THEN
//	IF This.GetRow() = This.RowCount() THEN
//		iw_window.PostEvent("ue_new")
//	ELSE
//		Send(Handle(This),256,9,Long(0,0))
//		Return 1
//	END IF
//ELSE
//	Send(Handle(This),256,9,Long(0,0))
//	Return 1
//End If

Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event dw_list::itemchanged;//Ancestor being overridden - No last user/update fields
end event

