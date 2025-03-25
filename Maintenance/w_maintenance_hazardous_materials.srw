HA$PBExportHeader$w_maintenance_hazardous_materials.srw
$PBExportComments$Hazardous Materials Maintenance Screen
forward
global type w_maintenance_hazardous_materials from w_std_simple_list
end type
end forward

global type w_maintenance_hazardous_materials from w_std_simple_list
string title = "Hazardous Materials Maintenance"
end type
global w_maintenance_hazardous_materials w_maintenance_hazardous_materials

type variables
w_maintenance_hazardous_materials iw_window
end variables

on w_maintenance_hazardous_materials.create
call super::create
end on

on w_maintenance_hazardous_materials.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_new;call super::ue_new;
dw_list.SetColumn('proper_shipping_name')

end event

event ue_save;call super::ue_save;String ls_code, ls_prev_code
Long ll_rowcnt, ll_row

// Purpose : To update the datawindow

If f_check_access(is_process,"S") = 0 THEN Return -1

If dw_list.AcceptText() = -1 Then Return -1

//dw_list.Sort()

ll_rowcnt = dw_list.RowCount()

// After validation updating the datawindow
Execute Immediate "Begin Transaction" using SQLCA;  // Turned Autocommit on, requiring 'Begin Transaction'
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

event resize;call super::resize;dw_list.Resize(workspacewidth() - 40,workspaceHeight() - 40)
end event

event open;call super::open;iw_window = This
end event

event ue_retrieve;call super::ue_retrieve;String lsFilter

//Filter
//lsFilter = "Upper(symbols) = 'G'"
//dw_list.SetFilter(lsFilter)
//dw_list.Filter()

This.Event ue_sort()
end event

event ue_preopen;call super::ue_preopen;// Intitialize
This.X = 0
This.Y = 0
is_process = Message.StringParm
is_title = This.Title

This.Event ue_sort()

end event

event ue_sort;//Override ancestor script to sort by proper shipping name
//This Event displays the sor criterial & sorts by the desire criteria
long ll_ret
String str_null

str_null = "proper_shipping_name asc, symbols desc"

IF isvalid(dw_list) THEN
	ll_ret=dw_list.Setsort(str_null)
	ll_ret=dw_list.Sort()
	if isnull(ll_ret) then ll_ret=0
END IF	
return ll_ret
end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_hazardous_materials
integer x = 37
integer y = 32
string dataobject = "d_maintenance_hazardous_materials"
boolean hscrollbar = true
boolean resizable = true
end type

event dw_list::itemchanged;
ib_changed = True
end event

