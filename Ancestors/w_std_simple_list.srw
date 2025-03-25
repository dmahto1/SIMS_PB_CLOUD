HA$PBExportHeader$w_std_simple_list.srw
$PBExportComments$Standard obejct for master detail windows
forward
global type w_std_simple_list from w_master
end type
type dw_list from u_dw_ancestor within w_std_simple_list
end type
end forward

global type w_std_simple_list from w_master
integer width = 2354
integer height = 1636
string title = "Untitle"
string menuname = "m_simple_record"
long backcolor = 79741120
event ue_new ( )
event ue_delete ( )
event ue_retrieve ( )
event ue_close ( )
event type long ue_sort ( )
event ue_help ( )
dw_list dw_list
end type
global w_std_simple_list w_std_simple_list

type variables
String     is_title, is_process = '', isHelpkeyword
Long			ilHelpTopicID
Boolean ib_changed


end variables

event ue_new;// Purpose : To Insert a New row in Datawindow

Long ll_row

IF f_check_access(is_process,"I") = 0 THEN Return

ll_row = dw_list.InsertRow(0)
dw_list.ScrollToRow(ll_row)
dw_list.SetRow(ll_row)
ib_changed = True
end event

event ue_delete;// Purpose   : To Delete the Row from the datawindow
// Arguments : None

Long ll_row

IF f_check_access( is_process,"D") = 0 THEN Return

IF MessageBox(is_title,"Are you sure you want to delete this record",Question!,OkCancel!,2) = 1 THEN
	dw_list.DeleteRow(0)
	IF dw_list.RowCount() = 0 THEN
		ll_row = dw_list.InsertRow(0)
		dw_list.ScrollToRow(ll_row)
	END IF
	ib_changed = True
END IF
end event

event ue_retrieve;// Purpose : To Retrieve the records from database

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
	dw_list.Retrieve()
	ib_changed = False
END IF

end event

event ue_close;Close(This)
end event

event ue_sort;//This Event displays the sor criterial & sorts by the desire criteria
long ll_ret
String str_null
SetNull(str_null)
IF isvalid(dw_list) THEN
	ll_ret=dw_list.Setsort(str_null)
	ll_ret=dw_list.Sort()
	if isnull(ll_ret) then ll_ret=0
END IF	
return ll_ret
end event

event ue_help;Integer	liRC

//Help Topic ID is set in this event and passed to help file

//If you want to open by Topic ID, set the ilHelpTopicID to a valid Map #
// If you want to open by keyword, set the isHelpKeyord variable


If isHelpKeyword > ' ' Then
	lirc = ShowHelp(g.is_helpfile,Keyword!,isHelpKeyword) /*open by Keyword*/
ElseIf ilHelpTopicID > 0 Then
	lirc = ShowHelp(g.is_helpfile,topic!,ilHelpTopicID) /*open by topic ID*/
Else
	liRC = ShowHelp(g.is_HelpFile,Index!)
End If


end event

on w_std_simple_list.create
int iCurrent
call super::create
if this.MenuName = "m_simple_record" then this.MenuID = create m_simple_record
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
end on

on w_std_simple_list.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
end on

event closequery;Integer li_return

// Looking for unsaved changes
IF ib_changed THEN
	Choose Case MessageBox(is_title,"Save Changes?",Question!,YesNoCancel!,3)
		Case 1
		   li_return = Trigger Event ue_save()
			If li_return = -1 Then
				Return 1
			Else
				Return 0
			End If
   	Case 2
			Return 0
		Case 3
			Return 1
	End Choose 		
ELSE
	Return 0
END IF
end event

event deactivate;g.POST of_setmenu(TRUE)
end event

event ue_preopen;call super::ue_preopen;// Intitialize
This.X = 0
This.Y = 0
is_process = Message.StringParm
is_title = This.Title

dw_list.SetTransObject(sqlca)
dw_list.Retrieve()

end event

type dw_list from u_dw_ancestor within w_std_simple_list
integer x = 46
integer y = 36
integer width = 2231
integer height = 1388
integer taborder = 20
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;ib_changed = True
This.SetItem(row, "last_user", gs_userid)
This.SetItem(row, "last_update", Today())
end event

