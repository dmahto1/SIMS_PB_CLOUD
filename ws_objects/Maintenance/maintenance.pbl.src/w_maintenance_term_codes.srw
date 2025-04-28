$PBExportHeader$w_maintenance_term_codes.srw
$PBExportComments$Term Codes Maintenance
forward
global type w_maintenance_term_codes from w_std_simple_list
end type
type dw_select from u_dw_ancestor within w_maintenance_term_codes
end type
end forward

global type w_maintenance_term_codes from w_std_simple_list
integer width = 3881
integer height = 1968
string title = "Terms Code Maintenance"
dw_select dw_select
end type
global w_maintenance_term_codes w_maintenance_term_codes

type variables
w_maintenance_term_codes iw_window

end variables

on w_maintenance_term_codes.create
int iCurrent
call super::create
this.dw_select=create dw_select
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_select
end on

on w_maintenance_term_codes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_select)
end on

event ue_save;String ls_code, ls_prev_code
Long ll_rowcnt, ll_row

// Purpose : To update the datawindow

If f_check_access(is_process,"S") = 0 THEN Return -1

If dw_list.AcceptText() = -1 Then Return -1

If f_check_required(is_title, dw_list) = -1 Then
	return -1
End If

dw_list.Sort()

ll_rowcnt = dw_list.RowCount()

// Detect duplicate rows in Datawindow
dw_list.Sort()                                       
ll_rowcnt = dw_list.RowCount()
For ll_row = ll_rowcnt To 1 Step -1
	ls_code = dw_list.GetItemString(ll_row,"terms_code")
	IF ls_code = ls_prev_code THEN
		MessageBox(is_title, "Duplicate record found, please check!")
		f_setfocus(dw_list, ll_row, "terms_code")
		Return 0
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

event ue_new;call super::ue_new;
dw_list.SetFocus()
dw_list.SetColumn("terms_code")
dw_list.Object.project_id[ dw_list.Getrow() ] = gs_project
dw_list.Object.wh_code[ dw_list.Getrow() ] = dw_select.getITemString(1,'warehouse')

dw_list.Object.create_user[ dw_list.Getrow() ] = gs_userid
dw_list.Object.create_time[ dw_list.Getrow() ] = datetime(today(),now())
end event

event open;call super::open;

iw_window = This
end event

event ue_postopen;call super::ue_postopen;
DatawindowChild	ldwc


dw_select.GetChild("warehouse", ldwc)
ldwc.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc)

dw_select.InsertRow(0)

If gs_default_WH > '' Then
	dw_select.SetITem(1,'warehouse',gs_default_WH) /* 04/04 - PCONKL - Warehouse now reauired field on search to keep users within their domain*/
End IF

This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;//Ancestor being overridden

String	lsWarehouse

SetPointer(Hourglass!)
lsWarehouse = dw_select.GetItemString(1,'warehouse')
dw_list.Retrieve(gs_Project, lsWarehouse)
SetPointer(Arrow!)

ib_changed = False

end event

event ue_preopen;
//Ancestor being overridden

// Intitialize
This.X = 0
This.Y = 0
is_process = Message.StringParm
is_title = This.Title
end event

event resize;call super::resize;dw_list.Resize(workspacewidth() - 20,workspaceHeight()-130)
end event

event ue_delete;
//Ancestor being overridden

Long ll_row

IF f_check_access( is_process,"D") = 0 THEN Return

//Only super users can delete existing rows...
If gs_role <> "0" and (dw_list.GetItemStatus(dw_list.getRow(),0,Primary!) <> New! and dw_list.GetItemStatus(dw_list.getRow(),0,Primary!) <> NewModified!) Then
	Messagebox(is_title,"You can not delete existing rows",StopSign!)
	Return
End If

IF MessageBox(is_title,"Are you sure you want to delete this record",Question!,OkCancel!,2) = 1 THEN
	dw_list.DeleteRow(0)
	ib_changed = True
END IF
end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_term_codes
integer x = 27
integer y = 124
integer width = 3758
integer height = 1632
string dataobject = "d_terms_code_maintenance"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_list::process_enter;//// If last row & Column then insert new row
//IF This.GetColumnName() = "inv_type_desc" THEN
//	IF This.GetRow() = This.RowCount() THEN
//		iw_window.PostEvent("ue_new")
//	Else
//		Send(Handle(This),256,9,Long(0,0))
//		Return 1		
//	END IF
//ELSE
//	Send(Handle(This),256,9,Long(0,0))
//	Return 1
//End If
//
end event

event dw_list::itemerror;call super::itemerror;
return 2	
end event

type dw_select from u_dw_ancestor within w_maintenance_term_codes
integer x = 37
integer y = 16
integer width = 2071
integer height = 104
boolean bringtotop = true
string dataobject = "d_warehouse"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;
iw_window.PostEvent('ue_retrieve')
end event

event getfocus;call super::getfocus;
If ib_changed = True Then
	This.modify("warehouse.protect=1")
Else
	this.Modify("warehouse.protect=0")
End If
end event

