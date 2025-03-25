$PBExportHeader$w_maintenance_buildlog.srw
$PBExportComments$- supplier modify
forward
global type w_maintenance_buildlog from w_std_master_detail
end type
type st_supplier from statictext within tabpage_main
end type
type sle_sequenceno from singlelineedit within tabpage_main
end type
type dw_project from u_dw_ancestor within tabpage_main
end type
type dw_1 from datawindow within tabpage_search
end type
type cb_supplier_search from commandbutton within tabpage_search
end type
type dw_search from u_dw_ancestor within tabpage_search
end type
end forward

global type w_maintenance_buildlog from w_std_master_detail
integer width = 4503
integer height = 2720
string title = "Build Log Maintenance"
end type
global w_maintenance_buildlog w_maintenance_buildlog

type variables
Datawindow   idw_main, idw_search,idw_filter
SingleLineEdit isle_whcode,isle_suppcode
window iw_window
String	isOrigSql
end variables

event open;call super::open;Integer i, li_ret

// Intialize

is_title = This.Title
iw_window = This
ilHelpTopicID = 535 /*set help topic ID*/

im_menu = This.Menuid
ib_edit = True
ib_changed = False
//is_process = Message.StringParm

// Storing into variables
idw_main = tab_main.tabpage_main.dw_project
idw_filter = tab_main.tabpage_search.dw_1
idw_search = tab_main.tabpage_search.dw_search
isle_suppcode = tab_main.tabpage_main.sle_sequenceNo

// 05/00 - pconkl - in dw ancestor constructor event
//idw_main.SetTransObject(Sqlca)
idw_search.SetTransObject(Sqlca)
idw_filter.settransobject(SQLCA)

// 05/00 - pconkl - capture original sql
isOrigSql = idw_search.getsqlselect()

// change the style of datawindow object
//f_datawindow_change (idw_main)


tab_main.tabpage_main.text =' Build Log'
//ltab_main.tabpage_search.dw_select.Insertrow(0)
tab_main.tabpage_search.dw_1.insertrow(0)

// Default into edit mode
This.TriggerEvent("ue_edit")



end event

on w_maintenance_buildlog.create
int iCurrent
call super::create
end on

on w_maintenance_buildlog.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_edit;
// Acess Rights
//is_process = Message.StringParm
If f_check_access(is_process,"E") = 0 Then
	close(w_maintenance_supplier)
	return
end if

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()

// Tab properties
tab_main.SelectTab(1) 
idw_main.Reset()

idw_main.Hide()


// Reseting the Single line edit
isle_suppcode.DisplayOnly = False
isle_suppcode.TabOrder= 10
isle_suppcode.Text = ""
isle_suppcode.SetFocus()


end event

event ue_save;Integer li_ret
Decimal ld_orgprice, ld_price  

IF f_check_access(is_process,"S") = 0 THEN Return 0

// When updating setting the current user & date
If idw_main.AcceptText() = -1 Then Return -1




//// pvh 02.15.06 - gmt
//datetime ldtToday
//ldtToday = f_getLocalWorldTime( gs_default_wh ) 
//idw_main.SetItem(1,'last_update',ldtToday) 
////idw_main.SetItem(1,'last_update',Today()) 
//idw_main.SetItem(1,'last_user',gs_userid)
//idw_main.SetItem(1,"project_id",gs_project)
//
//If idw_main.RowCount() > 0 Then
//	If isnull(idw_main.GetItemString(1,"supp_code")) Then
//		If isnull(isle_suppcode.Text) or isle_suppcode.Text = '' Then
//			Messagebox(is_title,"Supplier Code is Required!")
//			isle_suppcode.Setfocus()
//			Return - 1
//		Else
//			idw_main.SetItem(1,"supp_code",isle_suppcode.Text)
//		End If
//	End If
//End If
//
// Updating the Datawindow
Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
SQLCA.DBParm = "disablebind =0"
li_ret = idw_main.Update(False, False)
SQLCA.DBParm = "disablebind =1"
IF li_ret = 1 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		idw_main.ResetUpdate()
		SetMicroHelp("Record Saved!")
		ib_changed = False
		// Bringing back to edit mode
		IF ib_edit = False THEN
			ib_edit = True
			This.Title = is_title + " - Edit"
			im_menu.m_file.m_save.Enable()
			im_menu.m_file.m_retrieve.Enable()
			im_menu.m_record.m_delete.Enable()
		END IF
		// pvh 02.17.06
		// update the global datastore with the new info
		g.doRefreshSupplierDs()
		Return 0
   ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
      MessageBox(is_title, SQLCA.SQLErrText)
		Return -1
   END IF
ELSE
   Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox(is_title, "System error, record save failed!")
	Return -1
END IF

end event

event ue_delete;call super::ue_delete;If f_check_access(is_process,"D") = 0 Then Return

// Prompting for deletion
If MessageBox(is_title, "Are you sure you want to delete this record",Question!,YesNo!,2) = 2 Then
	Return
End If

SetPointer(HourGlass!)

ib_changed = False

tab_main.SelectTab(1)

idw_main.DeleteRow(1)

If This.Trigger Event ue_save() = 0 Then
	SetMicroHelp("Record deleted!")
Else
	SetMicroHelp("Record delete failed!")
End If
This.Trigger Event ue_edit()


end event

event ue_new;// Acess Rights
If f_check_access(is_process,"N") = 0 Then Return



// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - New"
ib_edit = False
ib_changed = False

// Changing menu properties
im_menu.m_file.m_save.Enable()
im_menu.m_file.m_retrieve.Disable()
im_menu.m_record.m_delete.Disable()





// Tab properties
tab_main.SelectTab(1)
idw_main.Reset()
idw_main.InsertRow(0)
//idw_main.Hide()
idw_main.Show()

string ls_SQN 
long ll_row, ll_rowcount
select MAX(sequenceno) into :ll_row   from build_log using SQLCA;
ll_row = ll_row + 1
idw_main.modify("sequenceno.taborder =0")
 ls_SQN =string (ll_row)
idw_main.SetItem(1,'sequenceno',ls_SQN) 



// Reseting the Single line edit
isle_suppcode.DisplayOnly = False
isle_suppcode.TabOrder= 10
isle_suppcode.text = ls_SQN
isle_suppcode.SetFocus()

end event

event ue_clear;//tab_main.tabpage_search.dw_select.Reset()
//tab_main.tabpage_search.dw_select.InsertRow(0)
//tab_main.tabpage_search.dw_select.Setfocus()

end event

type tab_main from w_std_master_detail`tab_main within w_maintenance_buildlog
integer y = 0
integer width = 4411
integer height = 2416
end type

event tab_main::selectionchanged;//For updating sort option
tab_main.tabpage_search.dw_1.visible = true

CHOOSE CASE newindex
	CASE 2
		wf_check_menu(TRUE,'sort')
		idw_current = idw_search
//
	
	Case Else		
		wf_check_menu(FALSE,'sort')
//		im_menu.m_file.m_sort.Enabled = FALSE
END CHOOSE

end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer width = 4375
integer height = 2288
string text = " Supplier "
st_supplier st_supplier
sle_sequenceno sle_sequenceno
dw_project dw_project
end type

on tabpage_main.create
this.st_supplier=create st_supplier
this.sle_sequenceno=create sle_sequenceno
this.dw_project=create dw_project
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_supplier
this.Control[iCurrent+2]=this.sle_sequenceno
this.Control[iCurrent+3]=this.dw_project
end on

on tabpage_main.destroy
call super::destroy
destroy(this.st_supplier)
destroy(this.sle_sequenceno)
destroy(this.dw_project)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer width = 4375
integer height = 2288
dw_1 dw_1
cb_supplier_search cb_supplier_search
dw_search dw_search
end type

on tabpage_search.create
this.dw_1=create dw_1
this.cb_supplier_search=create cb_supplier_search
this.dw_search=create dw_search
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_supplier_search
this.Control[iCurrent+3]=this.dw_search
end on

on tabpage_search.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.cb_supplier_search)
destroy(this.dw_search)
end on

type st_supplier from statictext within tabpage_main
integer x = 32
integer y = 68
integer width = 553
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Sequence NBR"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_sequenceno from singlelineedit within tabpage_main
integer x = 667
integer y = 60
integer width = 485
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_code,ls_suppcode

Long   ll_rows

//ls_code = sle_project.Text
ls_suppcode = This.Text



//IF NOT IsNull(ls_code) Or ls_code <> '' then
//		ll_rows = idw_main.Retrieve(ls_suppcode)       // Retrieving the entry datawindow

	IF ib_edit THEN								 // Edit Mode
		IF ll_rows > 0 THEN
			idw_main.Show()
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
			im_menu.m_record.m_delete.Enable()
			This.DisplayOnly = True
			idw_main.TabOrder = 0			
		ELSE
			MessageBox(is_title, "Record not found, please enter again!", Exclamation!)
			This.SetFocus()
			This.SelectText(1,Len(ls_code))
  		END IF
			
	ELSE													  // New Mode
		IF ll_rows > 0 THEN
			MessageBox(is_title, "Record already exist, please enter again", Exclamation!)
			This.SetFocus()
			This.SelectText(1,Len(ls_code))		
		ELSE
			idw_main.InsertRow(0)
			//idw_main.SetItem(1,"project_id",gs_project)
//			idw_main.SetItem(1,"supp_code",ls_suppcode)
			idw_main.Show()
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
			This.DisplayOnly = True
			This.TabOrder = 0			
		END IF
	END IF
//ELSE
//	MessageBox(is_title, "Please enter the Project Code", Exclamation!)
//	This.SetFocus()
//END IF	
//
end event

type dw_project from u_dw_ancestor within tabpage_main
integer x = 101
integer y = 152
integer width = 4274
integer height = 1164
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_buillog_formnew"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;ib_changed = True
end event

event process_enter;If This.GetColumnName() <> "remark" Then
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If
end event

type dw_1 from datawindow within tabpage_search
integer x = 297
integer y = 44
integer width = 3602
integer height = 280
integer taborder = 30
string title = "none"
string dataobject = "dw_buildlog_search"
boolean border = false
boolean livescroll = true
end type

event itemchanged;this.show()
end event

type cb_supplier_search from commandbutton within tabpage_search
integer x = 3776
integer y = 568
integer width = 357
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;
//dw_search.TriggerEvent("ue_retrieve")
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_search from u_dw_ancestor within tabpage_search
integer x = 261
integer y = 544
integer width = 3415
integer height = 1388
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_search_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event doubleclicked;// Pasting the record to the main entry datawindow

IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	IF NOT ib_changed THEN
		isle_suppcode.Text = This.GetItemString(row,"supp_code")
		isle_suppcode.TriggerEvent("modified")
	END IF
END IF
end event

event ue_retrieve;//String	lsWhere
//
//SetPointer(Hourglass!)
//
//dw_select.AcceptText()
//
//This.dbCancel() /*retrive as needed must cancel first*/
//This.SetRedraw(False)
//This.Reset()
//
////always tackon project,Tackon  supplier name if present
//lswhere = "Where supplier.project_id = '" + gs_project + "' " 
//
//If not isnull(dw_select.GetItemString(1,"supplier_name")) Then
//	lsWhere += " and Supplier.Supp_Name like '" + dw_select.GetItemString(1,"supplier_name") + "%' "
//End If
//
//dw_search.setsqlselect(isOrigSql + lsWhere)
//
//IF This.Retrieve() < 1 THEN 
//	MessageBox(is_title,"No records found!")
//END IF
//
//This.SetRedraw(True)
//SetPointer(Arrow!)
//
end event

