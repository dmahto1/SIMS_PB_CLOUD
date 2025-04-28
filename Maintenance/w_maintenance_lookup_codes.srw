HA$PBExportHeader$w_maintenance_lookup_codes.srw
$PBExportComments$- Maintain Look-up Codes
forward
global type w_maintenance_lookup_codes from w_std_simple_list
end type
type st_1 from statictext within w_maintenance_lookup_codes
end type
end forward

global type w_maintenance_lookup_codes from w_std_simple_list
integer width = 3086
string title = "Look Up Code List"
st_1 st_1
end type
global w_maintenance_lookup_codes w_maintenance_lookup_codes

on w_maintenance_lookup_codes.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_maintenance_lookup_codes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_new;call super::ue_new;//Inserts default values
string ls_ctype,ls_proj
//ls_ctype=dw_list.Getitemstring(dw_list.Getrow(),'code_type')
//IF isnull(ls_ctype) THEN dw_list.Setitem(dw_list.Getrow(),'code_type','SCHCD')
ls_proj=dw_list.Getitemstring(dw_list.Getrow(),'project_id')
IF isnull(ls_proj) THEN dw_list.Setitem(dw_list.Getrow(),'project_id',gs_project)
dw_list.SetColumn('code_type')

	
end event

event ue_save;String ls_code, ls_prev_code
Long ll_rowcnt, ll_row

// Purpose : To update the datawindow

If f_check_access( is_process,"S") = 0 THEN Return -1

If dw_list.AcceptText() = -1 Then Return -1

dw_list.Sort()

ll_rowcnt = dw_list.RowCount()

//FOR ll_row = ll_rowcnt to 1 Step -1
//	ls_code = dw_list.GetItemString(ll_row, "code_id")
//	IF IsNull(ls_code) THEN
//		dw_list.DeleteRow(ll_row)
//	END IF
//NEXT

// Deleting the blank Rows
FOR ll_row = ll_rowcnt to 1 Step -1
	ls_code = dw_list.GetItemString(ll_row, "code_id")
	IF IsNull(ls_code) and not isnull(dw_list.GetItemString(ll_row,'code_descript'))  THEN
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
	ls_code = dw_list.GetItemString(ll_row,"code_id")
	IF ls_code = ls_prev_code THEN
		MessageBox(is_title, "Duplicate record found, please check!",StopSign!)
		f_setfocus(dw_list,ll_row,"code_id")
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

event ue_retrieve;// ancestor being overridden

Integer li_return

IF ib_changed THEN
	Choose Case MessageBox(is_title,"Save Changes?",Question!,YesNoCancel!,3)
	   Case 1
		   li_return = Trigger Event ue_save()
			IF li_return = 0 THEN 
				dw_list.Retrieve(gs_project)
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

event open;// ancestor being overridden

This.X = 0
This.Y = 0
is_process = Message.StringParm
is_title = This.Title

dw_list.SetTransObject(sqlca)
dw_list.Retrieve(gs_project)


ilHelpTopicID = 538 /*set help topic ID*/
end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_lookup_codes
integer y = 120
integer width = 2921
integer height = 1304
string dataobject = "d_maintenance_lookup_codes"
boolean hscrollbar = true
end type

event dw_list::itemchanged;//overide
ib_changed = True
// If last row & Column then insert new row
IF dwo.name = "code_descript" THEN
	IF This.GetRow() = This.RowCount() THEN
		PArent.PostEvent("ue_new")		
	end if
end if
end event

type st_1 from statictext within w_maintenance_lookup_codes
integer x = 50
integer y = 16
integer width = 2418
integer height = 96
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Look-Up Codes"
alignment alignment = center!
boolean focusrectangle = false
end type

