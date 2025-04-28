$PBExportHeader$w_maintenance_holiday.srw
$PBExportComments$Term Codes Maintenance
forward
global type w_maintenance_holiday from w_std_simple_list
end type
type dw_select from u_dw_ancestor within w_maintenance_holiday
end type
type cb_import from commandbutton within w_maintenance_holiday
end type
end forward

global type w_maintenance_holiday from w_std_simple_list
integer width = 2915
integer height = 1942
string title = "Holiday Maintenance"
dw_select dw_select
cb_import cb_import
end type
global w_maintenance_holiday w_maintenance_holiday

type variables
w_maintenance_holiday iw_window

end variables

on w_maintenance_holiday.create
int iCurrent
call super::create
this.dw_select=create dw_select
this.cb_import=create cb_import
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_select
this.Control[iCurrent+2]=this.cb_import
end on

on w_maintenance_holiday.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_select)
destroy(this.cb_import)
end on

event ue_save;Date ld_date, ld_prev_date
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
	ld_date = dw_list.GetItemDate(ll_row,"holiday_date")
	
	if Not IsDate(string(ld_date)) then
		MessageBox(is_title, "Invalid Date, please check!")
		f_setfocus(dw_list, ll_row, "holiday_date")
		Return 0
	end IF
	
	if year(ld_date) <>  Integer(dw_select.GetItemString(1,'year')) then
		MessageBox(is_title, "Invalid Year, please check!")
		f_setfocus(dw_list, ll_row, "holiday_date")
		Return 0		
	end if
	
	IF ld_date = ld_prev_date THEN
		MessageBox(is_title, "Duplicate holiday date found, please check!")
		f_setfocus(dw_list, ll_row, "holiday_date")
		Return 0
	ELSE
		ld_prev_date = ld_date
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

This.TriggerEvent('ue_retrieve')
end event

event ue_new;call super::ue_new;
dw_list.SetFocus()
dw_list.SetColumn("holiday_name")
dw_list.Object.project_id[ dw_list.Getrow() ] = gs_project
dw_list.Object.holiday_country[ dw_list.Getrow() ] = dw_select.getITemString(1,'country_code')

end event

event open;call super::open;

iw_window = This
end event

event ue_postopen;call super::ue_postopen;
DatawindowChild	ldwc, ldwc_country

dw_select.InsertRow(0)

dw_select.GetChild("country_code", ldwc_country)
ldwc_country.SetTransObject(SQLCA)
if ldwc_country.Retrieve(gs_Project) > 0 then
	dw_select.SetItem(1, "country_code", ldwc_country.GetItemString(1,"country"))
end if



dw_select.GetChild("year", ldwc)


integer li_x, li_add_year, li_row

li_add_year = year(today()) - 1



For li_x = 1 to 5
	
	li_row = ldwc.InsertRow(0)
	
	ldwc.SetItem( li_row, "display_name" , string(li_add_year))
	ldwc.SetItem( li_row, "column_name" , string(li_add_year))
	
	li_add_year = li_add_year + 1

	
	Next
	
	dw_select.SetItem(1, "year", string(year(today())))
	


This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;//Ancestor being overridden

Integer	li_Year
String 	ls_Country

dw_select.AcceptText()

ls_Country = dw_select.GetItemString(1, "country_code")

SetPointer(Hourglass!)
li_Year = Integer(dw_select.GetItemString(1,'year'))
dw_list.Retrieve(gs_Project,ls_Country, li_Year)
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

////Only super users can delete existing rows...
//If gs_role <> "0" and (dw_list.GetItemStatus(dw_list.getRow(),0,Primary!) <> New! and dw_list.GetItemStatus(dw_list.getRow(),0,Primary!) <> NewModified!) Then
//	Messagebox(is_title,"You can not delete existing rows",StopSign!)
//	Return
//End If

IF MessageBox(is_title,"Are you sure you want to delete this record",Question!,OkCancel!,2) = 1 THEN
	dw_list.DeleteRow(0)
	ib_changed = True
END IF
end event

type dw_list from w_std_simple_list`dw_list within w_maintenance_holiday
integer x = 26
integer y = 160
integer width = 2809
integer height = 1597
string dataobject = "d_maintenance_holiday"
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

type dw_select from u_dw_ancestor within w_maintenance_holiday
integer x = 37
integer y = 16
integer width = 2333
integer height = 106
boolean bringtotop = true
string dataobject = "d_maintenance_holiday_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;
iw_window.PostEvent('ue_retrieve')
end event

type cb_import from commandbutton within w_maintenance_holiday
integer x = 2410
integer y = 19
integer width = 413
integer height = 102
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Import"
end type

event clicked;string is_filename, is_fullname
long i, rows
string lsCC_No
string ls_Country

If ib_changed Then
	messagebox(is_title,'Please save changes before importing Holidays!')
	return
End If


//dw_serial_numbers.Reset()

GetFileOpenName("Select File", is_filename, is_fullname, "txt","TXT","Text Files (*.*),*.*,CSV Files(*.*),*.*,")

If FileExists(is_filename) Then

	SetPointer(hourglass!)

	rows = dw_list.Rowcount()
	If rows > 0 Then
		Choose Case MessageBox(is_title, "Delete existing records?", Question!, YesNoCancel!,3)
			Case 3
				Return
			Case 1
				dw_list.Setredraw(False)
				For i = rows to 1 Step -1
					dw_list.DeleteRow( i )
				Next
				dw_list.Setredraw(True)
		End Choose
	End If

	dw_list.ImportFile(is_filename)
	
	rows = dw_list.Rowcount()
	For i = 1 to rows
		
		ls_Country = dw_list.GetItemString( i, "holiday_country" )
		
		if isNull(ls_Country) OR trim(ls_Country) = ''  then
				dw_list.Object.project_id[ i  ] = gs_project
				dw_list.Object.holiday_country[ i  ] = dw_select.getITemString(1,'country_code')
		end if
	Next
	


	dw_list.SetRedraw(True)
	ib_changed = true
	MessageBox ("Import Success", "Complete upload")

End If


end event

