HA$PBExportHeader$w_maintenance_carton_master.srw
$PBExportComments$-
forward
global type w_maintenance_carton_master from w_std_simple_list
end type
end forward

global type w_maintenance_carton_master from w_std_simple_list
integer width = 2962
integer height = 1660
string title = "Carton Type List"
end type
global w_maintenance_carton_master w_maintenance_carton_master

on w_maintenance_carton_master.create
call super::create
end on

on w_maintenance_carton_master.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_save;call super::ue_save;String ls_code, ls_prev_code
Long ll_rowcnt, ll_row

// Purpose : To update the datawindow

If f_check_access(is_process,"S") = 0 THEN Return -1

If dw_list.AcceptText() = -1 Then Return -1

dw_list.Sort()

ll_rowcnt = dw_list.RowCount()

// Deleting the blank Rows
FOR ll_row = ll_rowcnt to 1 Step -1
	ls_code = dw_list.GetItemString(ll_row, "wh_code")
	IF IsNull(ls_code) THEN
		dw_list.DeleteRow(ll_row)
	END IF
NEXT
ll_rowcnt=  dw_list.RowCount()
	FOR ll_row = 1 to ll_rowcnt
		IF IsNull(dw_list.object.seq_no[ll_row]) THEN
			dw_list.ScrollTORow(ll_row)
			MessageBox(This.Title,"Seqence Number can't be empty")
			dw_list.SetFocus()		
			dw_list.Setcolumn('seq_no')
			Return -1
		ELSEIF IsNull(dw_list.object.carton_type[ll_row]) THEN 
					dw_list.ScrollTORow(ll_row)
					MessageBox(This.Title,"Carton type can't be empty")
					dw_list.SetFocus()		
					dw_list.Setcolumn('carton_type')
					Return -1				
		END IF
	NEXT

// Detect duplicate rows in Datawindow
//dw_list.Sort()                                       
//ll_rowcnt = dw_list.RowCount()
//For ll_row = ll_rowcnt To 1 Step -1
//	ls_code = dw_list.GetItemString(ll_row,"wh_code")
//	IF ls_code = ls_prev_code THEN
//		MessageBox(is_title, "Duplicate record found, please check!")
//		f_setfocus(dw_list, ll_row, "inv_type")
//		Return 0
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

event ue_new;call super::ue_new;dw_list.SetColumn("wh_code")
dw_list.Object.project_id[ dw_list.Getrow() ] = gs_project
dw_list.Object.wh_code[ dw_list.Getrow() ] = gs_default_wh




end event

event open;String lsFilter
DatawindowChild ldwc

lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
dw_list.SetFilter(lsFilter)
dw_list.Filter()
ilHelpTopicID = 538 /*set help topic ID*/

//populate warehouse dropdown
dw_list.GetChild('wh_code', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)
This.Event ue_Preopen()
This.Post Event ue_postopen()

end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_carton_master
integer width = 2816
string dataobject = "d_carton_master_detail"
end type

event dw_list::process_enter;call super::process_enter;// If last row & Column then insert new row
IF lower(This.GetColumnName()) = "height" THEN
	IF This.GetRow() = This.RowCount() THEN
		parent.PostEvent("ue_new")
	Else
		Send(Handle(This),256,9,Long(0,0))
		Return 1		
	END IF
ELSE
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If



end event

event dw_list::itemerror;call super::itemerror;
IF dwo.name = 'carton_type' THEN
	IF isnull(data) or data = '' THEN
		Messagebox(Parent.Title,"Please enter the value for Carton type...")
		Return 1
	ELSE	
		Messagebox(Parent.Title,"Duplicate Carton Type Found Please Check...")
		Return 1
	END IF	
End IF	
end event

event dw_list::itemchanged;call super::itemchanged;long ll_row,ll_rowcnt,ll_seq_no
String ls_code,ls_wh_code,ls_curr_wh
ll_rowcnt = dw_list.RowCount()
IF dwo.Name = 'carton_type' THEN		
	For ll_row = 1 to  ll_rowcnt
		IF ll_row <> row  THEN
			ls_wh_code = dw_list.object.wh_code[ll_row]
			ls_curr_wh = dw_list.object.wh_code[row]
			ls_code = dw_list.object.carton_type[ll_row]
			IF ls_code = data and ls_wh_code = ls_curr_wh THEN	Return 1
		END IF
	Next
ELSEIF dwo.Name = 'seq_no' THEN
	For ll_row = 1 to  ll_rowcnt
		IF ll_row <> row THEN
			ll_seq_no  = dw_list.object.seq_no[ll_row]
			ls_wh_code = dw_list.object.wh_code[ll_row]
			ls_curr_wh = dw_list.object.wh_code[row]
			IF ll_seq_no = long(data) and ls_wh_code = ls_curr_wh THEN
				Messagebox(Parent.Title,"Duplicate sequence Number Found Please Check...")
				Post Setcolumn('seq_no')
				Return 2
			END IF	
		END IF
	Next
END IF	
end event

