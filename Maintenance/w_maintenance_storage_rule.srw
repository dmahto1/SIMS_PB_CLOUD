HA$PBExportHeader$w_maintenance_storage_rule.srw
$PBExportComments$Storage Rule Maintenance
forward
global type w_maintenance_storage_rule from w_std_master_detail
end type
type cb_storage_rule_delete from commandbutton within tabpage_main
end type
type cb_storage_rule_insert from commandbutton within tabpage_main
end type
type dw_detail from u_dw_ancestor within tabpage_main
end type
type sle_storage_rule from singlelineedit within tabpage_main
end type
type st_stoage_rule_code from statictext within tabpage_main
end type
type dw_header from u_dw_ancestor within tabpage_main
end type
type cb_storage_rule_search from commandbutton within tabpage_search
end type
type dw_select from datawindow within tabpage_search
end type
type dw_search from u_dw_ancestor within tabpage_search
end type
end forward

global type w_maintenance_storage_rule from w_std_master_detail
integer width = 2651
integer height = 1392
string title = "Storage Rule Maintenance"
end type
global w_maintenance_storage_rule w_maintenance_storage_rule

type variables
Datawindow   idw_main, idw_Detail, idw_search
SingleLineEdit isle_whcode,isle_storage_Rule
CommandButton	icbInsert, icbDelete
w_maintenance_storage_rule iw_window
String	isOrigSql
end variables

forward prototypes
public function integer wf_validate ()
end prototypes

public function integer wf_validate ();
Long	llRowPos, llRowCount

If idw_Main.RowCount() < 1 Then return 0

//warehouse required
if isnull(idw_Main.GetITEmstring(1,'wh_code')) or idw_Main.GetITEmstring(1,'wh_code') = "" Then
	MessageBox("Storage Rule Mnt",'Warehouse is Required.')
	idw_Main.Setfocus()
	idw_Main.SetRow(1)
	idw_Main.SetColumn('wh_code')
	return -1
End If


If idw_detail.AcceptText() < 0 Then return -1

llRowCount = idw_detail.RowCount()
If llRowCount> 1 Then
	
	For llRowPos = 1 to (llRowCount - 1)
		
		//Check for dup Zone and Consol type
		If idw_Detail.Find("zone_id = '" + idw_detail.GetITemString(llRowPOs,'zone_id') + "' and consolidate_ind = '" + &
			idw_detail.GetITemString(llRowPOs,'consolidate_ind') + "'", llRowPos + 1, llRowCount) > 0 Then
			
			MessageBox("Storage Rule Mnt",'Duplicate Zone/Consolidation Type found.')
			idw_detail.Setfocus()
			idw_Detail.SetRow(llRowPos)
			idw_Detail.SetColumn('zone_id')
			return -1
			
		End If
		
	Next
	
End If

//Delete any empty detail rows
For llRowPos = llRowCount to 1
	If isNull(idw_detail.GetITemNumber(llRowPos,'seq_id')) or idw_detail.GetITemNumber(llRowPos,'seq_id') = 0 Then
		idw_Detail.DeleteRow(llRowPos)
	End If
Next

Return 0
end function

event open;call super::open;Integer i, li_ret
DatawindowChild	ldwc, ldwc2, ldwc_inv_type
// Intialize

is_title = This.Title
iw_window = This


im_menu = This.Menuid
ib_edit = True
ib_changed = False
//is_process = Message.StringParm

// Storing into variables
idw_main = tab_main.tabpage_main.dw_header
idw_Detail = tab_main.tabpage_main.dw_detail
idw_search = tab_main.tabpage_search.dw_search
isle_storage_rule = tab_main.tabpage_main.sle_storage_rule
icbInsert = tab_main.tabpage_main.cb_storage_rule_insert
icbDelete = tab_main.tabpage_main.cb_storage_rule_Delete



// 05/00 - pconkl - capture original sql
isOrigSql = idw_search.getsqlselect()

//Load warehouse dropdowns
tab_main.tabpage_search.dw_select.GetChild("warehouse",ldwc)
ldwc.SetTransObject(SQLCA)
g.of_set_warehouse_dropdown(ldwc)

idw_main.GetChild('wh_code',ldwc2)
ldwc2.SetTransObject(sqlca)
ldwc.ShareData(ldwc2)

idw_detail.GetChild('inventory_type',ldwc_inv_type)
ldwc_inv_type.SetTransObject(sqlca)
ldwc_inv_type.Retrieve(gs_Project) 
ldwc_inv_type.insertrow(1)

tab_main.tabpage_search.dw_select.Insertrow(0)

// Default into edit mode
This.TriggerEvent("ue_edit")



end event

on w_maintenance_storage_rule.create
int iCurrent
call super::create
end on

on w_maintenance_storage_rule.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_edit;


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
idw_Detail.Reset()

idw_main.Hide()
idw_Detail.Hide()
icbInsert.Visible = False
icbDelete.Visible = False

// Reseting the Single line edit
isle_storage_rule.DisplayOnly = False
isle_storage_rule.TabOrder= 10
isle_storage_rule.Text = ""
isle_storage_rule.SetFocus()


end event

event ue_save;Integer li_ret
Decimal ld_orgprice, ld_price  
Long	llID, llRowPos
String	lsSRID

IF f_check_access(is_process,"S") = 0 THEN Return 0

// When updating setting the current user & date
If idw_main.AcceptText() = -1 Then Return -1

//Validate
If wf_validate() < 0 Then return - 1

//Set the SRID for new records
If idw_Main.RowCount() > 0 Then
	
	If idw_Main.GetItemString(1,'sr_id') = "" or isnull(idw_Main.GetItemString(1,'sr_id')) Then
	
		// Assign order no. for new order
		llID = g.of_next_db_seq(gs_project,'Storage_rule_Header','SR_No')
	
		If llID <= 0 Then
			messagebox(is_title,"Unable to retrieve the next available ID Number!")
			Return -1
		End If
		
		lsSRID = Trim(gs_project) + String(llID,"000000")
	
		idw_main.SetItem(1,'sr_id',lsSRID)
	
	End If

	lsSRID = idw_main.GetITemString(1,'sr_id')

	For llRowPos = 1 to idw_detail.RowCount()
		idw_detail.SetITem(llRowPos,'sr_id',lsSRID)
	Next

End If

// Updating the Datawindow
Execute Immediate "Begin Transaction" using SQLCA;  
SQLCA.DBParm = "disablebind =0"
li_ret = idw_main.Update()
IF li_ret = 1 THEN idw_Detail.Update()
SQLCA.DBParm = "disablebind =1"
IF li_ret = 1 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
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

Return 0
end event

event ue_delete;call super::ue_delete;Long	llRowCount, llRowPos

If f_check_access(is_process,"D") = 0 Then Return

// Prompting for deletion
If MessageBox(is_title, "Are you sure you want to delete this Storage Rule record",Question!,YesNo!,2) = 2 Then
	Return
End If

SetPointer(HourGlass!)

ib_changed = False

tab_main.SelectTab(1)

idw_main.DeleteRow(1)

llRowCount = idw_Detail.RowCount()
For llRowPos = lLRowCOunt to 1
	idw_Detail.DeleteRow(llRowPos)
Next

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
idw_detail.Reset()
idw_main.InsertRow(0)
idw_Detail.insertRow(0)
idw_detail.SetITem(1,'seq_id',1)
idw_main.Show()

idw_main.SetItem(1,'project_id',gs_project)

// Reseting the Single line edit
isle_storage_rule.DisplayOnly = False
isle_storage_rule.BringToTop = True
isle_storage_rule.TabOrder= 10
isle_storage_rule.text = ""
isle_storage_rule.SetFocus()

end event

event ue_clear;tab_main.tabpage_search.dw_select.Reset()
tab_main.tabpage_search.dw_select.InsertRow(0)
tab_main.tabpage_search.dw_select.Setfocus()

end event

type tab_main from w_std_master_detail`tab_main within w_maintenance_storage_rule
integer x = 0
integer y = 4
integer width = 2601
integer height = 1192
end type

event tab_main::selectionchanged;//For updating sort option
CHOOSE CASE newindex
	CASE 2
		wf_check_menu(TRUE,'sort')
		idw_current = idw_search
	Case Else		
		wf_check_menu(FALSE,'sort')
//		im_menu.m_file.m_sort.Enabled = FALSE
END CHOOSE

end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer width = 2565
integer height = 1064
string text = "Store Rule"
cb_storage_rule_delete cb_storage_rule_delete
cb_storage_rule_insert cb_storage_rule_insert
dw_detail dw_detail
sle_storage_rule sle_storage_rule
st_stoage_rule_code st_stoage_rule_code
dw_header dw_header
end type

on tabpage_main.create
this.cb_storage_rule_delete=create cb_storage_rule_delete
this.cb_storage_rule_insert=create cb_storage_rule_insert
this.dw_detail=create dw_detail
this.sle_storage_rule=create sle_storage_rule
this.st_stoage_rule_code=create st_stoage_rule_code
this.dw_header=create dw_header
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_storage_rule_delete
this.Control[iCurrent+2]=this.cb_storage_rule_insert
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.sle_storage_rule
this.Control[iCurrent+5]=this.st_stoage_rule_code
this.Control[iCurrent+6]=this.dw_header
end on

on tabpage_main.destroy
call super::destroy
destroy(this.cb_storage_rule_delete)
destroy(this.cb_storage_rule_insert)
destroy(this.dw_detail)
destroy(this.sle_storage_rule)
destroy(this.st_stoage_rule_code)
destroy(this.dw_header)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer width = 2565
integer height = 1064
cb_storage_rule_search cb_storage_rule_search
dw_select dw_select
dw_search dw_search
end type

on tabpage_search.create
this.cb_storage_rule_search=create cb_storage_rule_search
this.dw_select=create dw_select
this.dw_search=create dw_search
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_storage_rule_search
this.Control[iCurrent+2]=this.dw_select
this.Control[iCurrent+3]=this.dw_search
end on

on tabpage_search.destroy
call super::destroy
destroy(this.cb_storage_rule_search)
destroy(this.dw_select)
destroy(this.dw_search)
end on

type cb_storage_rule_delete from commandbutton within tabpage_main
integer x = 2139
integer y = 604
integer width = 293
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;
If dw_Detail.getRow() > 0 Then
	dw_Detail.Deleterow(dw_detail.getRow())
End If
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_storage_rule_insert from commandbutton within tabpage_main
integer x = 2139
integer y = 484
integer width = 293
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert"
end type

event clicked;Long	llNewRow

dw_detail.SetFocus()
llNewRow = dw_Detail.InsertRow(0)
dw_detail.ScrollToRow(llNewRow)
dw_detail.SetRow(llNewRow)
dw_Detail.SetItem(llnewRow,'seq_id',llnewRow)
dw_detail.setColumn("zone_id")
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_detail from u_dw_ancestor within tabpage_main
integer y = 292
integer width = 1970
integer height = 696
integer taborder = 30
string dataobject = "d_storage_rule_mnt_detail"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;
ib_changed = True
end event

type sle_storage_rule from singlelineedit within tabpage_main
integer x = 594
integer y = 44
integer width = 549
integer height = 92
integer taborder = 30
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

event modified;String ls_code,lsStorageCd, lsID
Long   ll_rows, llCount

//ls_code = sle_project.Text
lsStorageCd = This.Text

IF NOT IsNull(lsStorageCd) Or lsStorageCd <> '' then
	
		ll_rows = idw_main.Retrieve(gs_project,lsStorageCd)       // Retrieving the entry datawindow

	IF ib_edit THEN								 // Edit Mode
		IF ll_rows > 0 THEN
			idw_main.Show()
			idw_detail.Show()
			lsID = idw_main.getITemString(1,'sr_id')
			llCount = idw_Detail.Retrieve(lsID)
			icbinsert.Visible = True
			icbDelete.visible = True
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
			im_menu.m_record.m_delete.Enable()
			This.DisplayOnly = True
			This.TabOrder = 0			
		ELSE
			MessageBox(is_title, "Record not found, please enter again!", Exclamation!)
			This.SetFocus()
			This.SelectText(1,Len(ls_code))
  		END IF
			
	ELSE													  // New Mode
		IF ll_rows > 0 THEN
			idw_detail.Show()
			lsID = idw_main.getITemString(1,'sr_id')
			llCount = idw_Detail.Retrieve(lsID)
			MessageBox(is_title, "Record already exists, please enter again", Exclamation!)
			This.SetFocus()
			This.SelectText(1,Len(ls_code))		
		ELSE
			idw_main.InsertRow(0)
			idw_main.SetItem(1,"project_id",gs_project)
			idw_main.SetItem(1,"storage_rule_cd",lsStorageCd)
			idw_main.Show()
			idw_detail.Show()
			icbinsert.Visible = True
			icbDelete.visible = True
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
			This.DisplayOnly = True
			This.TabOrder = 0			
		END IF
	END IF
ELSE
	MessageBox(is_title, "Please enter the Storage Rule Code", Exclamation!)
	This.SetFocus()
END IF	

end event

type st_stoage_rule_code from statictext within tabpage_main
integer x = 9
integer y = 52
integer width = 562
integer height = 76
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
string text = "Storage Rule Code"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type dw_header from u_dw_ancestor within tabpage_main
integer x = 9
integer y = 40
integer width = 2149
integer height = 212
integer taborder = 20
string dataobject = "d_storage_rule_mnt_header"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;ib_changed = True
end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1

end event

type cb_storage_rule_search from commandbutton within tabpage_search
integer x = 27
integer y = 20
integer width = 297
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;
dw_search.TriggerEvent("ue_retrieve")
end event

event constructor;
g.of_check_label_button(this)

end event

type dw_select from datawindow within tabpage_search
integer x = 352
integer y = 24
integer width = 2194
integer height = 112
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_maintenance_storage_rule_search"
boolean border = false
boolean livescroll = true
end type

event constructor;
g.of_check_label(this)
end event

type dw_search from u_dw_ancestor within tabpage_search
integer x = 247
integer y = 140
integer width = 2075
integer height = 896
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_storage_rule_search_results"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;// Pasting the record to the main entry datawindow

IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	IF NOT ib_changed THEN
		isle_storage_rule.Text = This.GetItemString(row,"storage_rule_cd")
		isle_storage_rule.TriggerEvent("modified")
	END IF
END IF
end event

event ue_retrieve;String	lsWhere

SetPointer(Hourglass!)

dw_select.AcceptText()

This.dbCancel() /*retrive as needed must cancel first*/
This.SetRedraw(False)
This.Reset()

//always tackon project,Tackon  supplier name if present
lswhere = "Where storage_rule_header.project_id = '" + gs_project + "' " 

If not isnull(dw_select.GetItemString(1,"warehouse")) Then
	lsWhere += " and storage_rule_header.wh_code =  '" + dw_select.GetItemString(1,"warehouse") + "' "
End If

If not isnull(dw_select.GetItemString(1,"code")) Then
	lsWhere += " and storage_rule_header.storage_rule_cd =  '" + dw_select.GetItemString(1,"code") + "' "
End If

If not isnull(dw_select.GetItemString(1,"desc")) Then
	lsWhere += " and storage_rule_header.storage_rule_desc like  '%" + dw_select.GetItemString(1,"desc") + "%' "
End If

dw_search.setsqlselect(isOrigSql + lsWhere)

IF This.Retrieve() < 1 THEN 
	MessageBox(is_title,"No records found!")
END IF

This.SetRedraw(True)
SetPointer(Arrow!)

end event

event clicked;call super::clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

