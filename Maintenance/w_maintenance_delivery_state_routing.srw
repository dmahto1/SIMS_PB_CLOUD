HA$PBExportHeader$w_maintenance_delivery_state_routing.srw
$PBExportComments$- customer modify
forward
global type w_maintenance_delivery_state_routing from w_std_simple_list
end type
end forward

global type w_maintenance_delivery_state_routing from w_std_simple_list
integer width = 2697
integer height = 2292
string title = "Delivery State Routing"
end type
global w_maintenance_delivery_state_routing w_maintenance_delivery_state_routing

type variables
Long ll_CurRow
string ls_state, ls_Wh, ls_msg
integer li_priority
datastore lds_dupe

end variables

forward prototypes
public function integer of_get_nbr_state_rows (string as_code)
public function integer of_check_for_duplicates ()
end prototypes

public function integer of_get_nbr_state_rows (string as_code);integer li_return = 0
integer li_line
long ll_rows, ll_row

lds_dupe.Reset()

ll_rows = dw_list.RowCount()
For ll_row = 1 to ll_rows
	if dw_list.GetItemString(ll_row,"state_cd") = as_code then
		li_line = lds_dupe.InsertRow(0)
		lds_dupe.SetItem(li_line, 'priority', dw_list.GetItemNumber(ll_row,"priority"))
		lds_dupe.SetItem(li_line,'wh_code', dw_list.GetItemString(ll_row,"wh_code"))
		li_return = li_return + 1
	end if
Next
ll_rows = lds_dupe.RowCount()

return li_return

end function

public function integer of_check_for_duplicates ();integer li_return = 0
integer li_line, li_dupe_row, li_state_priority, li_next_priority
long ll_rowcnt, ll_row, ll_result
string ls_thismsg, ls_priority, ls_curr_WH, ls_next_WH

ll_rowcnt = dw_list.RowCount()
For ll_row = 1 to ll_rowcnt
	ls_state = dw_list.GetItemString(ll_row,"state_cd")
	ll_result = of_get_nbr_state_rows(ls_state)		// Get rows for this state code
	if ll_result = 1 then
		if dw_list.GetItemNumber(ll_row,"priority") <> 1 then
			ll_CurRow = ll_row
			return -101
		end if
	else
		// Check priority
		lds_dupe.SetSort('priority')
		lds_dupe.Sort()
		ll_CurRow = ll_row
		li_state_priority = lds_dupe.GetItemNumber(1,'priority')
		if li_state_priority <> 1 then return -101
		for li_line = 2 to ll_result
			li_next_priority = lds_dupe.GetItemNumber(li_line,'priority')
			if li_next_priority = li_state_priority then
				ll_CurRow = ll_row + li_line - 1
				return -102
			end if
			li_state_priority = li_next_priority
		next
		// Check for duplicate warehouse
		lds_dupe.SetSort('wh_code')
		lds_dupe.Sort()
		ls_curr_WH = lds_dupe.GetItemString(1,'wh_code')
		for li_line = 2 to ll_result
			ls_next_WH = lds_dupe.GetItemString(li_line,'wh_code')
			if ls_next_WH = ls_curr_WH then
				ll_CurRow = ll_row + li_line -1
				return -103
			end if
			ls_curr_WH = ls_next_WH
		next
	end if		
Next

return li_return
end function

on w_maintenance_delivery_state_routing.create
call super::create
end on

on w_maintenance_delivery_state_routing.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_new;call super::ue_new;dw_list.Object.project_id[ dw_list.Getrow() ] = gs_project
dw_list.SetColumn('state_cd')

	
end event

event ue_save;String ls_state_name
Long ll_rowcnt, ll_row
integer  li_result

// Purpose : To update the datawindow

If f_check_access( is_process,"S") = 0 THEN Return -1

If dw_list.AcceptText() = -1 Then Return -1

dw_list.Sort()

ll_rowcnt = dw_list.RowCount()

// Deleting the blank Rows
FOR ll_row = ll_rowcnt to 1 Step -1
	ls_state = dw_list.GetItemString(ll_row, "state_cd")
	IF IsNull(ls_state) THEN
		Messagebox(is_title, "Code id is blank please check!")
		Return -1
	ElseIF IsNull(ls_state) THEN		
		dw_list.DeleteRow(ll_row)
	END IF
NEXT

// Detect duplicate rows in Datawindow
dw_list.Sort()                                       
li_result = of_check_for_duplicates()
if li_result < 0 then
	ls_state = dw_list.GetItemString(ll_CurRow,'state_cd')
	choose case li_result
		case -101
			ls_msg = 'Must have a priority 1 for State: ' + ls_state
		case -102
			ls_msg = 'Duplicate priority detected for State: ' + ls_state
		case -103
			ls_msg = 'Duplicate warehouse detected for State: ' + ls_state
	End Choose		
	dw_list.ScrollToRow(ll_CurRow)
	
	ls_msg += "~n~nPlease correct and resubmit"
	MessageBox(is_title, ls_msg, StopSign!)
	Return -1
else
	MessageBox(is_title,"Changes have been saved")
end if

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

event open;call super::open;DatawindowChild ldwc
lds_dupe = Create datastore
lds_dupe.DataObject = 'd_delivery_state_routing'

lds_dupe.Reset()

//populate warehouse dropdown
dw_list.GetChild('wh_code', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)
This.Event ue_Preopen()
This.Post Event ue_postopen()





end event

event ue_retrieve;call super::ue_retrieve;String lsFilter

lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
dw_list.SetFilter(lsFilter)
dw_list.Filter()
ilHelpTopicID = 538 /*set help topic ID*/
end event

event resize;call super::resize;dw_list.Resize(workspacewidth() - 40,workspaceHeight() - 10)
end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_delivery_state_routing
integer x = 18
integer y = 44
integer width = 2299
integer height = 2040
string dataobject = "d_delivery_state_routing"
boolean hscrollbar = true
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event dw_list::itemchanged;//overide
ib_changed = True
// If last row & Column then insert new row
IF dwo.name = "code_descript" THEN
	IF This.GetRow() = This.RowCount() THEN
		w_maintenance_customer_type.PostEvent("ue_new")		
	end if
end if
//RETURN 1
//	Else
//		Send(Handle(This),256,9,Long(0,0))
//		Return 1
//	END IF
//ELSE
//	Send(Handle(This),256,9,Long(0,0))
//	Return 1
//End If

end event

event dw_list::rowfocuschanging;call super::rowfocuschanging;//integer ii_NbrRows
//ll_CurRow = currentrow
//
//if ll_CurRow = 0 then return
//
//ls_state = dw_list.GetItemString(ll_CurRow, "state_cd")
//ls_wh = dw_list.GetItemString(ll_CurRow, "wh_code")
//li_priority = dw_list.GetItemNumber(ll_CurRow, "priority")
//
//ii_NbrRows = of_get_nbr_state_rows(ls_state)
//if ii_NbrRows = 1 then
//	if li_priority <> 1 then
//		messagebox("Validation Error","Priority for this state record must be 1")
//		dw_list.SetItem(ll_CurRow,"priority",1)
//	end if
//else
//	// Check for duplicates
//	ii_NbrRows = of_check_for_duplicates(ls_state)
//end if
//





end event

