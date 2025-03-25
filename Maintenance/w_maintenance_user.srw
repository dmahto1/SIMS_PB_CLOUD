HA$PBExportHeader$w_maintenance_user.srw
$PBExportComments$-
forward
global type w_maintenance_user from w_std_master_detail
end type
type st_1 from statictext within tabpage_main
end type
type sle_id from singlelineedit within tabpage_main
end type
type dw_main from u_dw_ancestor within tabpage_main
end type
type st_4 from statictext within tabpage_search
end type
type cb_clear from commandbutton within tabpage_search
end type
type st_3 from statictext within tabpage_search
end type
type sle_display_name from singlelineedit within tabpage_search
end type
type st_2 from statictext within tabpage_search
end type
type sle_userid from singlelineedit within tabpage_search
end type
type dw_search from u_dw_ancestor within tabpage_search
end type
type cb_search from commandbutton within tabpage_search
end type
type ddlb_accesslevel from dropdownlistbox within tabpage_search
end type
type tabpage_rights from userobject within tab_main
end type
type dw_warehouse_assign from u_dw_ancestor within tabpage_rights
end type
type dw_rights from u_dw_ancestor within tabpage_rights
end type
type dw_project_display from u_dw_ancestor within tabpage_rights
end type
type dw_project_assign from u_dw_ancestor within tabpage_rights
end type
type tabpage_rights from userobject within tab_main
dw_warehouse_assign dw_warehouse_assign
dw_rights dw_rights
dw_project_display dw_project_display
dw_project_assign dw_project_assign
end type
end forward

global type w_maintenance_user from w_std_master_detail
integer width = 3666
integer height = 2264
string title = "User Maintenance"
end type
global w_maintenance_user w_maintenance_user

type variables
Datawindow   idw_main, idw_search,idw_project,idw_right
SingleLineEdit isle_whcode,isle_code
w_maintenance_user iw_window
String	isOrigSQL
Boolean	ibWarehouseChanged

inet	linit
u_nvo_websphere_post	iuoWebsphere
end variables

forward prototypes
public subroutine wf_ ()
public subroutine wf_protect_function_rights (string as_child_id)
public function integer wf_remove_filter ()
end prototypes

public subroutine wf_ ();
end subroutine

public subroutine wf_protect_function_rights (string as_child_id);//04-APR-2018 :Madhu S17619 -Item Master Edit Access
//set "selected =Y" on current DW and apply protect through DW.column.Property

string lsFilter
long ll_row, llFindRow

IF ( gs_role ='0' OR gs_role ='1' OR gs_role ='2' ) THEN
	lsFilter ="Function_Rights.Child_ID ='"+as_child_id+"'"
	llFindRow =idw_right.find( lsFilter, 1, idw_right.rowcount())
	
	If llFindRow > 0 Then
		For ll_row =1 to idw_right.rowcount( )
			IF ll_row = llFindRow THEN
				idw_right.setItem( ll_row, 'selected', 'Y')
			else
				idw_right.setItem( ll_row, 'selected', 'N')
			END IF
		Next
	END IF
END IF

idw_right.setredraw( true)
end subroutine

public function integer wf_remove_filter ();//04-June-2018 :Madhu DE4541 - Remove filter

idw_right.setfilter( "")
idw_right.filter( )
idw_right.rowcount( )

Return 0
end function

on w_maintenance_user.create
int iCurrent
call super::create
end on

on w_maintenance_user.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datawindowChild	ldwc

tab_main.MoveTab(3, 2)

// Storing into variables
ib_changed = False
ib_edit = True
iw_window = This
ilHelpTopicID = 539 /*set help topic ID*/
is_process = Message.StringParm
idw_main = tab_main.tabpage_main.dw_main
idw_search = tab_main.tabpage_search.dw_search
isle_code = tab_main.tabpage_main.sle_id
idw_project = tab_main.tabpage_rights.dw_project_display
idw_right = tab_main.tabpage_rights.dw_rights

// 07/00 PCONKL - Only a Super User will be able to assign Project Rights or assign rights to another project
//02/08 - PCONKL - Added Super Duper USer
If gs_role = '0' or gs_role = '-1' Then
	Tab_main.tabpage_rights.dw_project_assign.Visible = True
	Tab_main.tabpage_rights.dw_project_display.Visible = True
	idw_main.modify("commodity_authorized_user.protect=0")	//02-Jun-2016 :Madhu- Restricted to Super /Developers only
Else
	Tab_main.tabpage_rights.dw_project_assign.Visible = False
	Tab_main.tabpage_rights.dw_project_display.Visible = False
	idw_main.modify("commodity_authorized_user.protect=1")	//02-Jun-2016 :Madhu- Restricted to Super /Developers only
End If

idw_main.SetTransObject(Sqlca)
idw_search.SetTransObject(Sqlca)
idw_project.SetTransObject(Sqlca)
idw_right.SetTransObject(Sqlca)

//f_datawindow_change(idw_main)

//idw_project.Retrieve()
idw_project.InsertRow(0)
idw_project.GetChild('project_id',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve()
idw_project.SetITem(1,'project_id',gs_project)

// load initial Warehouse assigned DW
Tab_main.tabpage_rights.dw_warehouse_assign.Retrieve(gs_project)

// 0/12 - PCONKL - need websphere access for validating new users
iuoWebsphere = CREATE u_nvo_websphere_post
linit = Create Inet

// Default into edit mode
This.TriggerEvent("ue_edit")

end event

event ue_edit;// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()
tab_main.tabpage_rights.enabled = false

// Tab properties
idw_right.reset()

tab_main.SelectTab(1) 
idw_main.Reset()

idw_main.Hide()



// Reseting the Single line edit
isle_code.Text = ""
isle_code.SetFocus()



end event

event ue_new;// Acess Rights
If f_check_access(is_process,"N") = 0 Then Return

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - New"
ib_edit = False
ib_changed = False

//ib_editmode = False
//ib_modified = False

// Changing menu properties
im_menu.m_file.m_save.Enable()
im_menu.m_file.m_retrieve.Disable()
im_menu.m_record.m_delete.Disable()
tab_main.tabpage_rights.enabled = true

// Tab properties
tab_main.SelectTab(1)
idw_main.Reset()
idw_main.Hide()

// Reseting the Single line edit
isle_code.Text = ""
isle_code.SetFocus()

end event

event ue_retrieve;call super::ue_retrieve;isle_code.TriggerEvent(Modified!)
end event

event ue_save;Long ll_ret, ll_cnt, i

IF f_check_access(is_process,"S") = 0 THEN Return -1

If idw_main.AcceptText() = -1 Then Return -1

//tab_main.SelectTab(1) 

// When updating setting the current user & date

idw_main.SetItem(1,'last_update',Today()) 
idw_main.SetItem(1,'last_user',gs_userid)

// Set keys for new function right rows

idw_right.SetFilter("")
idw_right.Filter()
ll_cnt = idw_right.RowCount()
For i = 1 to ll_cnt
	If idw_right.GetItemStatus ( i, 0, Primary! ) = DataModified! and &
		IsNull(idw_right.GetItemString(i, 'f_userid')) Then		
		idw_right.SetItem(i, 'f_userid', idw_main.GetItemString(1, 'userid'))
		idw_right.SetItem(i, 'f_project_id', idw_right.GetItemString(i, 'project_id'))
		idw_right.SetItem(i, 'f_child_id', idw_right.GetItemString(i, 'child_id'))
		idw_right.SetItemStatus ( i, 0, Primary!, NewModified! )
	End If
	
	
	string li_mail 
	li_mail = idw_Main.GetITEmstring(1,'email_address')
	
	//added Email address is required  nxjain 2013/13/03
	if isnull(idw_Main.GetITEmstring(1,'email_address')) or idw_Main.GetITEmstring(1,'email_address') = "" Then
		MessageBox(is_title,'Email Address is Required.')
		idw_Main.Setfocus()
		idw_Main.SetRow(1)
		idw_Main.SetColumn('email_address')
		Return -1 
	End If	
	//Ended nxjain 2013/13/03
	
Next
i = idw_project.GetRow()
idw_right.SetFilter("project_id = '" + idw_project.getitemstring(i,'project_id') + "'")
idw_right.Filter()		

// Updating the Datawindow
Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
ll_ret = idw_main.Update(False, False)
If ll_ret = 1 Then idw_right.Update(False, False)

//Save Project and Warehouse  Assignments
Tab_main.tabpage_rights.dw_project_assign.TriggerEvent("ue_save_access")
Tab_main.tabpage_rights.dw_warehouse_assign.TriggerEvent("ue_save_access")

IF ll_ret = 1 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		idw_right.ResetUpdate()
		idw_main.ResetUpdate()
		SetMicroHelp("Record Saved!")
		// pvh - 08/25/06 - security mod
		g.doFunctionRightsRetrieve() // update the application datastore
		// 
		ib_changed = False
		ibWarehousechanged = False
		// Bringing back to edit mode
		IF ib_edit = False THEN
			ib_edit = True
			This.Title = is_title + " - Edit"
			im_menu.m_file.m_save.Enable()
			im_menu.m_file.m_retrieve.Enable()
			im_menu.m_record.m_delete.Enable()
		END IF
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

event ue_delete;call super::ue_delete;Integer li_ret
String ls_code

If f_check_access(is_process,"D") = 0 Then Return

// Prompting for deletion
li_ret = MessageBox(is_title, "Are you sure you want to delete this record",Question!,YesNo!,2)
IF li_ret = 2 THEN Return

// Deleting proceed with updation
ls_code = idw_main.GetItemString(1,"userid")

Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
// delete foreign key first
Delete function_rights where userid = :ls_code;
Delete user_project where userid = :ls_code; 
Delete user_warehouse where userid = :ls_code; 
Delete usertable Where userid = :ls_code;

IF Sqlca.Sqlcode = 0 THEN
	Execute Immediate "COMMIT" using SQLCA;
	SetMicroHelp("Record Deleted!")
	This.TriggerEvent("ue_edit")
	Return
ELSE
	Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox(is_title, "System error, record delete failed!")
END IF
end event

event ue_postopen;call super::ue_postopen;
// 07/00 PCONKL - Project list only retrievd once, check valid projects
Tab_main.tabpage_rights.dw_project_assign.Retrieve()

//get original sql
isOrigSQl = idw_search.GetSqlSelect()

end event

event resize;call super::resize;
tab_main.Resize(workspacewidth(),workspaceHeight())
tab_main.tabpage_search.dw_search.Resize(workspacewidth() - 80,workspaceHeight()-650)
tab_main.tabpage_rights.dw_rights.Resize(workspacewidth() - 80,workspaceHeight()-650)
end event

type tab_main from w_std_master_detail`tab_main within w_maintenance_user
integer x = 5
integer y = 28
integer width = 3593
integer height = 2020
tabpage_rights tabpage_rights
end type

on tab_main.create
this.tabpage_rights=create tabpage_rights
call super::create
this.Control[]={this.tabpage_main,&
this.tabpage_search,&
this.tabpage_rights}
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_rights)
end on

event tab_main::selectionchanged;call super::selectionchanged;//03-03-2017 Madhu -PEVS-503 Added to Export User Search List
wf_check_menu(TRUE,'sort')
CHOOSE CASE newindex
	CASE 1
		wf_check_menu(FALSE,'sort')
		idw_current = idw_main
	CASE 2
		idw_current = idw_right
	CASE 3
		idw_current =idw_search
END CHOOSE
end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer width = 3557
integer height = 1892
string text = " User Information "
st_1 st_1
sle_id sle_id
dw_main dw_main
end type

on tabpage_main.create
this.st_1=create st_1
this.sle_id=create sle_id
this.dw_main=create dw_main
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_id
this.Control[iCurrent+3]=this.dw_main
end on

on tabpage_main.destroy
call super::destroy
destroy(this.st_1)
destroy(this.sle_id)
destroy(this.dw_main)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer width = 3557
integer height = 1892
st_4 st_4
cb_clear cb_clear
st_3 st_3
sle_display_name sle_display_name
st_2 st_2
sle_userid sle_userid
dw_search dw_search
cb_search cb_search
ddlb_accesslevel ddlb_accesslevel
end type

on tabpage_search.create
this.st_4=create st_4
this.cb_clear=create cb_clear
this.st_3=create st_3
this.sle_display_name=create sle_display_name
this.st_2=create st_2
this.sle_userid=create sle_userid
this.dw_search=create dw_search
this.cb_search=create cb_search
this.ddlb_accesslevel=create ddlb_accesslevel
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.cb_clear
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.sle_display_name
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_userid
this.Control[iCurrent+7]=this.dw_search
this.Control[iCurrent+8]=this.cb_search
this.Control[iCurrent+9]=this.ddlb_accesslevel
end on

on tabpage_search.destroy
call super::destroy
destroy(this.st_4)
destroy(this.cb_clear)
destroy(this.st_3)
destroy(this.sle_display_name)
destroy(this.st_2)
destroy(this.sle_userid)
destroy(this.dw_search)
destroy(this.cb_search)
destroy(this.ddlb_accesslevel)
end on

type st_1 from statictext within tabpage_main
integer x = 247
integer y = 88
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "User ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_id from singlelineedit within tabpage_main
integer x = 503
integer y = 80
integer width = 864
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
integer limit = 25
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_code,ls_custcode, ls_pid, lsAttributes, lsXML, lsXMLResponse,  lsReturnCode, lsReturnDesc, lsFilter
Long   ll_rows, llCount, llFindRow
Long ll_Reports_Found

ls_code = this.Text

IF NOT IsNull(ls_code) Or ls_code <> '' THEN
	ll_rows = idw_main.Retrieve(ls_code)       // Retrieving the entry datawindow
	IF ib_edit THEN								    // Edit Mode
		IF ll_rows > 0 THEN
			
			// 07/00 PCONKL - Dont allow someone to access abouve their security level!
			// 02/08 - PCONKL - Added Super Duper User
			if gs_role = '-1' Then
			//ElseIf string(idw_Main.GetItemNumber(1,"access_level")) < gs_role  Then
			ElseIf idw_Main.GetItemNumber(1,"access_level") < long(gs_role)  Then
				Messagebox(is_title,"You can not access this User with your security Role")
				isle_code.SetFocus()
				isle_code.SelectText(1,Len(ls_code))
				Return
			End If
	
			// 08/00 PCONKL - Only Super can access Users from other projects
			//02/08 - PCONKL - Added Super Duper User
			//If gs_role <> '0' Then
			If gs_role = '0' or gs_role = '-1' Then
				
				//04-APR-2018 :Madhu S17619 -Item Master Edit Access - clear filter, if any exist
				wf_remove_filter()
				
				idw_right.Retrieve(ls_code, gs_project)
				
				IF upper(gs_project) ='PANDORA'  Then wf_protect_function_rights ('M_ITEM') //04-APR-2018 :Madhu S17619 -Item Master Edit Access
			
			Else
				
				Select Count(*) into :llCount
				From	user_project with(nolock)
				Where UserID = :ls_code and Project_id = :gs_project
				Using SQLCA;
				
				If Not llCount > 0 Then
					Messagebox(is_title,"You can not access this User from this Project!")
					isle_code.SetFocus()
					isle_code.SelectText(1,Len(ls_code))
					Return
				End If
				
			End If
	
			idw_main.Show()
			
			//04-APR-2018 :Madhu S17619 -Item Master Edit Access - clear filter, if any exist
			wf_remove_filter()
			
			idw_right.Retrieve(ls_code, gs_project)
			
			IF upper(gs_project) ='PANDORA'  Then wf_protect_function_rights ('M_ITEM') //04-APR-2018 :Madhu S17619 -Item Master Edit Access
			
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
			im_menu.m_record.m_delete.Enable()
			tab_main.tabpage_rights.enabled = true
			idw_project.SetRow(1)
			
			//TimA 07/16/15 Filter out the reports section that require permissions.
			idw_right.SetFilter("process_id_group_seq = 20 and process_id_Function_Seq > 40")
			idw_right.Filter()
			ll_Reports_Found = idw_right.rowcount( )
			
			ls_pid = idw_project.getitemstring(1,'project_id')
			idw_right.SetFilter("project_id = '" + ls_pid + "'")
			
			
			idw_right.Filter()		
			
			// 07/00 PCONKL - If Access level for user being edited is super, then we dont need to show project assignments - super has all access
			// 06/12 - PConkl - show for Super but not Super Duper - Super is now being explictely being assigned projects
			
			If idw_main.GetItemNumber(1,"access_level") =  -1 Then
				tab_main.tabpage_rights.dw_project_assign.visible = False
			Else /*only a super user (current logged in user) can see*/
				If gs_role = '0' or gs_role = '-1' Then
						Tab_main.tabpage_rights.dw_project_assign.Visible = True
				Else
					Tab_main.tabpage_rights.dw_project_assign.Visible = False
				End If
			End If
				
			Tab_main.tabpage_rights.dw_project_assign.TriggerEvent("ue_set_access") /*set project Access table*/
			Tab_main.tabpage_rights.dw_warehouse_assign.TriggerEvent("ue_set_access") /*set Warehouse Access table*/
				
			// 04/04 - PCONKL - Rights are only assigned for Operator, others are irrelevent
			If idw_main.GetItemNumber(1,'access_level') = 2 Then
				idw_right.Visible = True
			Else /* admin or Super*/
				If idw_main.GetItemNumber(1,'access_level') = 1  Then
					//TimA 07/16/15 For Admin accounts only show the reports that need permissions to run.
					If ll_Reports_Found > 0 Then
						idw_right.SetFilter("process_id_group_seq = 20 and process_id_Function_Seq > 40")
						idw_right.Filter()				
						idw_right.Visible = True
					Else
						idw_right.Visible = False
					End if
				Else
					idw_right.Visible = False
				End if
			End If
			
			
		ELSE
			MessageBox(is_title, "Record not found, please enter again!", Exclamation!)
			isle_code.SetFocus()
			isle_code.SelectText(1,Len(ls_code))
  		END IF
		  
	ELSE				// New Mode
	
		IF ll_rows > 0 THEN
			
			MessageBox(is_title, "Record already exist, please enter again", Exclamation!)
			isle_code.SetFocus()
			isle_code.SelectText(1,Len(ls_code))		
			
		ELSE
			
			// 07/12 - PCONKL - validate that it is a valid NT or Tivio User ID
			lsAttributes = ' UserID = "' + ls_code  + '"'
			lsXML = iuoWebsphere.uf_request_header("ValidateUserExistsRequest", lsAttributes)
			lsXML = iuoWebsphere.uf_request_footer(lsXML)

			lsXMLResponse = iuoWebsphere.uf_post_url(lsXML)

			//If we didn't receive an XML back, there is a fatal exception error
			If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
				Messagebox("Websphere Fatal Exception Error","Unable to Validate User: ~r~r" + lsXMLResponse,StopSign!)
				Return 
			End If

			lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
			lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

			If lsReturnCode<> "0"  Then
				MessageBox("Authentication Error",lsReturnDesc,StopSign!)
				REturn
			End If
						
			idw_right.Retrieve(ls_code, gs_project)
			IF upper(gs_project) ='PANDORA'  Then wf_protect_function_rights ('M_ITEM') //04-APR-2018 :Madhu S17619 -Item Master Edit Access
			
			idw_main.InsertRow(0)
			idw_main.SetItem(1,"userid",ls_code)
			idw_main.Show()
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
			idw_project.SetRow(1)
			ls_pid = idw_project.getitemstring(1,'project_id')
			idw_right.SetFilter("project_id = '" + ls_pid + "'")
			idw_right.Filter()		
			Tab_main.tabpage_rights.dw_project_assign.TriggerEvent("ue_set_new") /*default new user to access for current project*/
			
		END IF
		
	END IF
	
ELSE
	MessageBox(is_title, "Please enter the User ID", Exclamation!)
	isle_code.SetFocus()
END IF	

end event

type dw_main from u_dw_ancestor within tabpage_main
integer x = 23
integer y = 196
integer width = 2848
integer height = 1572
boolean bringtotop = true
string dataobject = "d_maintenance_user"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;ib_changed = True

// 07/00 PCONKL - Only Super can create/modify Super Access
// 08/02 - PCONKL - Added Super Duper User
If dwo.name = 'access_level' Then
	
	// If Access level is super, then we dont need to show project assignments - super has all access
	If data = '0' Then
		tab_main.tabpage_rights.dw_project_assign.visible = False
	Else
		tab_main.tabpage_rights.dw_project_assign.visible = True
	End If
	
	Choose Case gs_role
			
		Case '-1' /* 02/08 - PCONKL - Super Duper can do all */
			
		Case '0' /* Super can change Admin or Oper but can not create a new Super*/
			
			If data = '0' Then /*trying to create super*/
				Messagebox(is_title,"A Super User can not Create or Modify a 'Super' user!",StopSign!)
				Return 1
			End If
			
		Case '1' /*Admin can change admin or Operator*/
			If data = '0' Then /*trying to create super*/
				Messagebox(is_title,"An Administrator can not Create or Modify a 'Super' user!",StopSign!)
				Return 1
			End If
			
		Case '2' /*Oper cant change shit!*/
			If data = '0' or data = '-1' Then /*trying to create super*/
				Messagebox(is_title,"An Operator can not Create or Modify a 'Super' user!",StopSign!)
				Return 1
			ElseIf data = '1' Then
				Messagebox(is_title,"An Operator can not Create or Modify an 'Administrator' user!",StopSign!)
				Return 1
			End If
			
	End Choose		
	
End If /*modifying Role*/
end event

event itemerror;
if dwo.name = 'access_level' Then return 1
end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1

end event

event constructor;call super::constructor;
// 04/06 - PCONKL - GM IMS logon/password only visible for GM_MI_DAT
If gs_project = "GM_MI_DAT" Then
	this.modify("gm_ims_logonid.visible=True gm_ims_loginid_t.visible=True gm_ims_password.visible=True gm_ims_password_t.visible=True")
End If
end event

type st_4 from statictext within tabpage_search
integer x = 2190
integer y = 24
integer width = 480
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Access Level"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_clear from commandbutton within tabpage_search
integer x = 3104
integer y = 92
integer width = 402
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;
//TimA 07/13/15
tab_main.tabpage_search.sle_userid.text = ''
tab_main.tabpage_search.sle_display_name.text = ''
tab_main.tabpage_search.ddlb_AccessLevel.text = ''
tab_main.tabpage_search.ddlb_AccessLevel.SelectItem(0)
tab_main.tabpage_search.dw_search.reset( )
end event

type st_3 from statictext within tabpage_search
integer x = 1317
integer y = 24
integer width = 768
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Display Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_display_name from singlelineedit within tabpage_search
integer x = 1317
integer y = 92
integer width = 768
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
integer limit = 25
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within tabpage_search
integer x = 471
integer y = 24
integer width = 768
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "User ID"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_userid from singlelineedit within tabpage_search
integer x = 471
integer y = 92
integer width = 768
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
integer limit = 25
borderstyle borderstyle = stylelowered!
end type

type dw_search from u_dw_ancestor within tabpage_search
integer x = 37
integer y = 196
integer width = 3488
integer height = 1684
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_maintenance_user_search"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event doubleclicked;// Pasting the record to the main entry datawindow
IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	IF NOT ib_changed THEN
		isle_code.Text = This.GetItemString(row,"userid")
		isle_code.TriggerEvent("modified")
	END IF
END IF
end event

type cb_search from commandbutton within tabpage_search
integer x = 37
integer y = 92
integer width = 389
integer height = 92
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

event clicked;String	lsWhere
String ls_string
String ls_UserIDWhere
String ls_DisplayWhere
String ls_AccessLevelWhere
String lstest
Long llAccessLevel
SetPointer(Hourglass!)

dw_search.SetRedraw(False)
dw_search.Reset()

// 01/01 PCONKL - If Not a Super User, only include users that have access to the current project
// 02/08 - PCONKL - Added Super Duper User
// 06/12 - PCONKL - Only Super can see users outside of authorized projects...

//TimA 07/13/15 Added Searching by UserID or Name, and Access Level
ls_string =   tab_main.tabpage_search.sle_userid.text
if not isNull(ls_string) and ls_string <> '' then
	ls_UserIDWhere += " userID Like '%" + ls_string + "%' " 
end if

ls_string =   tab_main.tabpage_search.sle_display_name.text
if not isNull(ls_string) and ls_string <> '' then
	ls_DisplayWhere += " display_name Like '%" + ls_string + "%' " 
end if

ls_string =   tab_main.tabpage_search.ddlb_AccessLevel.text
if not isNull(ls_string) and ls_string <> '' then
	Choose case ls_string
		Case 'Super'
			llAccessLevel = 0
		Case 'Admin'
			llAccessLevel = 1
		Case 'Operator'
			llAccessLevel = 2
	End Choose
	ls_AccessLevelWhere += " access_level = " + String(llAccessLevel )
End if


If gs_role =  '-1' Then
	//TimA 07/13/15 Super Users can search by name also
	If ls_UserIDWhere <> '' Then
		lsWhere = ' Where ' + ls_UserIDWhere
	End if

	If ls_DisplayWhere <> '' Then
		If ls_UserIDWhere <> '' Then
			lsWhere = lsWhere + ' and ' + ls_DisplayWhere
		Else
			lsWhere = ' Where ' + ls_DisplayWhere
		End if
	End if

	If ls_AccessLevelWhere <> '' Then
		If ls_UserIDWhere <> '' or ls_DisplayWhere <> '' Then
			lsWhere = lsWhere + ' and ' + ls_AccessLevelWhere
		Else
			lsWhere = ' Where ' + ls_AccessLevelWhere
		End if
	End if
	
	If lsWhere <> '' then
		idw_search.SetSqlSelect(isOrigSql + LsWhere)
	Else
		idw_search.SetSqlSelect(isOrigSql)
	End if
Else
	lsWhere = " Where userID in (select Userid from user_project where project_id = '" + gs_project + "') " 
	If ls_UserIDWhere <> '' Then
		lsWhere = lsWhere + ' and ' + ls_UserIDWhere
	End if

	If ls_DisplayWhere <> '' Then
		lsWhere = lsWhere + ' and ' + ls_DisplayWhere
	End if

	If ls_AccessLevelWhere <> '' Then
		lsWhere = lsWhere + ' and ' + ls_AccessLevelWhere
	End if
	
	idw_search.SetSqlSelect(isOrigSql + LsWhere)
End If

IF dw_search.Retrieve() < 1 THEN 
	MessageBox(is_title,"No record found!")
END IF
dw_search.SetRedraw(True)

end event

type ddlb_accesslevel from dropdownlistbox within tabpage_search
integer x = 2190
integer y = 92
integer width = 480
integer height = 324
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"Super","Admin","Operator"}
borderstyle borderstyle = stylelowered!
end type

type tabpage_rights from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3557
integer height = 1892
long backcolor = 79741120
string text = " Access Rights "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_warehouse_assign dw_warehouse_assign
dw_rights dw_rights
dw_project_display dw_project_display
dw_project_assign dw_project_assign
end type

on tabpage_rights.create
this.dw_warehouse_assign=create dw_warehouse_assign
this.dw_rights=create dw_rights
this.dw_project_display=create dw_project_display
this.dw_project_assign=create dw_project_assign
this.Control[]={this.dw_warehouse_assign,&
this.dw_rights,&
this.dw_project_display,&
this.dw_project_assign}
end on

on tabpage_rights.destroy
destroy(this.dw_warehouse_assign)
destroy(this.dw_rights)
destroy(this.dw_project_display)
destroy(this.dw_project_assign)
end on

type dw_warehouse_assign from u_dw_ancestor within tabpage_rights
event ue_set_access ( )
event ue_save_access ( )
integer x = 1394
integer y = 20
integer width = 978
integer height = 540
integer taborder = 20
string dataobject = "d_assign_user_warehouse"
boolean vscrollbar = true
end type

event ue_set_access;Long	lLRowCount,	&
		llRowPos,	&
		llCount
		
String	lsProject,	&
			lsUser,		&
			lsWarehouse,	&
			lsDef
			

If this.RowCount() = 0 Then This.Retrieve()

lsUser = isle_code.text
llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	
	lsProject = This.GetItemString(llRowPos,"project_id")
	lswarehouse = This.GetItemString(llRowPos,"wh_Code")
	
	Select Count(*) into :llCount
	From user_warehouse
	Where Userid = :lsUser and project_id = :lsProject and wh_Code = :lsWarehouse
	Using SQLCA;
	
	If llCount = 1 Then
		
		This.SetItem(llRowPos,"c_select_ind",'Y')
		
		lsDef = ''
		
		Select default_wh_ind into :lsDef
		From user_warehouse
		Where Userid = :lsUser and project_id = :lsProject and wh_Code = :lsWarehouse
		Using SQLCA;
		
		If lsDef = 'Y' Then
			This.SetItem(llRowPos,"c_default_ind",'Y')
		Else
			This.SetItem(llRowPos,"c_default_ind",'N')
		End If
	
	Else
		This.SetItem(llRowPos,"c_select_ind",'N')
	End If
Next
end event

event ue_save_access;String	lsUser, lsProject, lsWarehouse, lsDef

long		llRowCOunt,	&
			llRowPos
Date		ldToday

ldToday = Today()

//Save a record in the user_Warehouse table for each checked record.

//Delete and rebuild - Commit occurs in ue_save
lsUser = isle_code.Text
lsProject = This.GetITemString(1,'project_id')

Delete from user_warehouse
Where UserID = :lsUser and Project_id = :lsProject
using SQLCA;

llRowCOunt = This.RowCount()
For llRowPos = 1 to llRowCount
	
	If This.getItemString(llRowPos,'c_select_ind') = 'Y' Then
		
		If This.GetItemString(llRowPos,"c_default_ind") = 'Y' Then
			lsDef = 'Y'
		Else
			lsDef = 'N'
		End IF
		
		lsProject = This.GetItemString(llRowPos,"project_id")
		lsWarehouse = This.GetItemString(llRowPos,"wh_Code")
		
		Insert Into user_Warehouse (UserID,Project_ID,wh_Code, default_wh_Ind, LASt_user,Last_update) Values(:lsUser,:lsProject, :lsWarehouse, :lsDef, :gs_UserID,:ldToday)
		Using SQLCA;
		
	End If
	
Next
	



end event

event itemchanged;call super::itemchanged;Long	llRowCOunt, llRowPos

ibWarehouseChanged = True
ib_changed = True

Choose Case dwo.name
		
	Case "c_default_ind" /*update default warehouse on main DW*/
		
		If Data = 'Y' Then
			
			//Reset any other checked defaults
			llRowCount = This.RowCOunt()
			For llRowPos = 1 to llRowCount
				If llRowPOS <> row then
					This.SetItem(llRowPos,"c_default_ind",'N')
				End If
			Next
		End If
		
	Case "c_select_ind"
		
		If Data = 'N' Then
			This.SetItem(Row,"c_default_ind",'N')
		End If
		
End Choose	
end event

type dw_rights from u_dw_ancestor within tabpage_rights
integer x = 27
integer y = 608
integer width = 3186
integer height = 1188
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_maintenance_function_right"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;String lsName
Long llRow
Long ll_Group, ll_Function

//TimA 07/13/15 Pandora only wants Super users and above to be able to change permissions for selecting reports.

If gs_Project = 'PANDORA' Then
	dwItemStatus l_status
	If gs_role <> '0' and gs_role <> '-1' Then //Super and Super Dupers are excluded
		llRow = Row
		ll_Group = This.GetItemNumber(Row,'process_id_group_seq')
		ll_Function = This.GetItemNumber(Row,'process_id_Function_Seq')
		lsName = dwo.name
		If ll_Group = 20 and ll_Function > 40 and  lsName = 'p_edit' then //This is only for reports and reports that require permissions based on Project Report Flag
			MessageBox(is_title,'You do not have permissions to update this Function Right.  Only Super users can update')
			Return 2
		End if
	End if
end if		
ib_changed = True


end event

type dw_project_display from u_dw_ancestor within tabpage_rights
event ue_post_itemchanged ( )
integer x = 325
integer y = 200
integer width = 1024
integer height = 96
boolean bringtotop = true
string dataobject = "d_select_project"
boolean border = false
end type

event ue_post_itemchanged();String ls_pid

ls_pid = This.GetITemString(1,'project_id')

//Save any warehouse assignments for current project before retrieving new project
If ibWarehouseChanged Then
	Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
	Tab_main.tabpage_rights.dw_warehouse_assign.TriggerEvent('ue_save_access')
	Execute Immediate "COMMIT" using SQLCA;
	ibWarehouseChanged = False
End If

idw_right.SetFilter("project_id = '" + ls_pid + "'")
idw_right.Filter()

Tab_main.tabpage_rights.dw_warehouse_assign.Retrieve(ls_pid)
Tab_main.tabpage_rights.dw_warehouse_assign.TriggerEvent('ue_set_access')


end event

event rowfocuschanged;String ls_pid

//ls_pid = This.getitemstring(currentrow,'project_id')
//idw_right.SetFilter("project_id = '" + ls_pid + "'")
//idw_right.Filter()
end event

event itemchanged;//String ls_pid
//
//ls_pid = Data
//idw_right.SetFilter("project_id = '" + ls_pid + "'")
//idw_right.Filter()
//
////Save any warehouse assignments for current project before retrieving new project
//If ibWarehouseChanged Then
//	Tab_main.tabpage_rights.dw_warehouse_assign.TriggerEvent('ue_save_access')
//	Execute Immediate "COMMIT" using SQLCA;
//	ibWarehouseChanged = False
//End If
//
//Tab_main.tabpage_rights.dw_warehouse_assign.Retrieve(ls_pid)

This.PostEvent('ue_post_itemchanged')
end event

type dw_project_assign from u_dw_ancestor within tabpage_rights
event ue_set_access ( )
event ue_set_new ( )
event ue_save_access ( )
integer x = 2459
integer y = 20
integer width = 736
integer height = 540
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_assign_user_project"
boolean vscrollbar = true
end type

event ue_set_access();Long	lLRowCount,	&
		llRowPos,	&
		llCount
		
String	lsProject,	&
			lsUser

If this.RowCount() = 0 Then This.Retrieve()

lsUser = isle_code.text
llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	
	lsProject = This.GetItemString(llRowPos,"project_id")
	
	// 06/12 - PCONKL - If the current logged in user doesn't have access to particular projects, don't show them in the list. Only a super duper user will see all projects - we don't want to allow somebody to assign access to a project that they don;t have access to themselves
	If gs_role <> "-1" then /*Not super duper*/
		
		Select Count(*) into :llCount
		From user_project
		Where Userid = :gs_userid and project_id = :lsProject
		Using SQLCA;
	
		If llCount = 1 Then
			This.SetItem(llRowPos,"c_protect",'N')
		Else
			This.SetItem(llRowPos,"c_protect",'Y')
		End If
		
		
	End If /*not Super*/
	
	Select Count(*) into :llCount
	From user_project
	Where Userid = :lsUser and project_id = :lsProject
	Using SQLCA;
	
	If llCount = 1 Then
		This.SetItem(llRowPos,"c_select",'Y')
	Else
		This.SetItem(llRowPos,"c_select",'N')
	End If
	
Next
end event

event ue_set_new;Long	llFindRow
String	lsFind

//Default user to current project - Only Super user will be able to see dw to change
This.Reset()
This.Retrieve()

//Set current project to Selected
lsFind = "project_id = '" + gs_project + "'"
llFindRow = This.Find(lsFind,1,This.RowCount())
If llFindRow > 0 Then
	This.SetItem(llFindRow,'c_select','Y')
End If
end event

event ue_save_access;String	lsUser,	&
			lsProject
long		llRowCOunt,	&
			llRowPos
Date		ldToday

ldToday = Today()

//Save a record in the user_project table for each checked record.

//Delete and rebuild - Commit occurs in ue_save
lsUser = isle_code.Text

Delete from user_project
Where UserID = :lsUser
using SQLCA;

llRowCOunt = This.RowCount()
For llRowPos = 1 to llRowCount
	
	If This.getItemString(llRowPos,'c_select') = 'Y' Then
		lsProject = This.GetItemString(llRowPos,"project_id")
		Insert Into user_project (UserID,Project_ID,LASt_user,Last_update) Values(:lsUser,:lsProject,:gs_UserID,:ldToday)
		Using SQLCA;
	End If
	
Next
	



end event

event itemchanged;ib_changed = True
end event

