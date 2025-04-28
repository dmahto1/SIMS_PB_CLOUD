$PBExportHeader$w_maintenance_hs_code.srw
$PBExportComments$- customer modify
forward
global type w_maintenance_hs_code from w_std_simple_list
end type
end forward

global type w_maintenance_hs_code from w_std_simple_list
integer width = 2405
integer height = 1036
string title = "HS Code Profile"
end type
global w_maintenance_hs_code w_maintenance_hs_code

type variables
w_maintenance_hs_code iw_window

end variables

on w_maintenance_hs_code.create
call super::create
end on

on w_maintenance_hs_code.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_new;call super::ue_new;dw_list.Object.project_id[ dw_list.Getrow() ] = gs_project
dw_list.SetColumn('hs_code')


	
end event

event ue_save;String ls_code, ls_prev_code
Long ll_rowcnt, ll_row

// Purpose : To update the datawindow

If f_check_access( is_process,"S") = 0 THEN Return -1

If dw_list.AcceptText() = -1 Then Return -1

dw_list.Sort()

ll_rowcnt = dw_list.RowCount()

// Jxlim 01/11/2011 When updating setting the current user & date
dw_list.SetItem(1,'last_update',Today()) 
dw_list.SetItem(1,'last_user',gs_userid)

// Deleting the blank Rows
FOR ll_row = ll_rowcnt to 1 Step -1
	ls_code = dw_list.GetItemString(ll_row, "hs_code")
	IF IsNull(ls_code) THEN
		Messagebox(is_title, "Code id is blank please check!")
		Return -1
	ElseIF IsNull(ls_code) THEN		
		dw_list.DeleteRow(ll_row)
	END IF
NEXT

// Detect duplicate rows in Datawindow
dw_list.Sort()                                       
ll_rowcnt = dw_list.RowCount()
For ll_row = ll_rowcnt To 1 Step -1
	ls_code = dw_list.GetItemString(ll_row,"hs_code")
	IF ls_code = ls_prev_code THEN
		MessageBox(is_title, "Duplicate record found, please check!",StopSign!)
		f_setfocus(dw_list,ll_row,"hs_code")
		dw_list.SetFocus()
		Return 0
	ELSE
		ls_prev_code = ls_code
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

event open;call super::open;//Jxlim filter by project_id
String lsFilter
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
dw_list.SetFilter(lsFilter)
dw_list.Filter()

iw_window = This

end event

event ue_retrieve;call super::ue_retrieve;//Jxlim 01/11/2011 Filter by project ID since this datawindow deos not have query by project id
String lsFilter
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
dw_list.SetFilter(lsFilter)
dw_list.Filter()
ilHelpTopicID = 538 /*set help topic ID*/

//iw_window = This

//// 03/03 - Pconkl - Overriding ancestor script so we can retrive by Project
//// Purpose : To Retrieve the records from database
//
//Integer li_return
//
//IF ib_changed THEN
//	Choose Case MessageBox(is_title,"Save Changes?",Question!,YesNoCancel!,3)
//	   Case 1
//		   li_return = Trigger Event ue_save()
//			IF li_return = 0 THEN 
//				dw_list.Retrieve()
//				ib_changed = False
//			END IF
//   	Case 2 
//			dw_list.Retrieve(gs_project)
//			ib_changed = False
//	End Choose 		
//ELSE
//	dw_list.Retrieve(gs_project)
//	ib_changed = False
//END IF
//
end event

event resize;call super::resize;dw_list.Resize(workspacewidth() - 40,workspaceHeight() - 40)
end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_hs_code
integer width = 2249
integer height = 728
string dataobject = "d_hs_code_profile"
boolean hscrollbar = true
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event dw_list::itemchanged;call super::itemchanged;//Jxlim 01/11/2011 W & S
//overide Extended 
ib_changed = True
// If last row & Column then insert new row
IF dwo.name = "Hs_code" THEN
	IF This.GetRow() = This.RowCount() THEN
		w_maintenance_hs_code.PostEvent("ue_new")			
	End if
End if


end event

