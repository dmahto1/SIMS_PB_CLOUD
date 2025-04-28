HA$PBExportHeader$w_maintenance_customer.srw
$PBExportComments$- customer modify
forward
global type w_maintenance_customer from w_std_master_detail
end type
type st_customer_code from statictext within tabpage_main
end type
type sle_customer from singlelineedit within tabpage_main
end type
type dw_customer from u_dw_ancestor within tabpage_main
end type
type cb_cust_search from commandbutton within tabpage_search
end type
type cb_cust_clear from commandbutton within tabpage_search
end type
type dw_inqury from u_dw_ancestor within tabpage_search
end type
type dw_search from u_dw_ancestor within tabpage_search
end type
type tabpage_location from userobject within tab_main
end type
type cb_insert_row from commandbutton within tabpage_location
end type
type cb_delete_row from commandbutton within tabpage_location
end type
type dw_address from u_dw_ancestor within tabpage_location
end type
type tabpage_location from userobject within tab_main
cb_insert_row cb_insert_row
cb_delete_row cb_delete_row
dw_address dw_address
end type
end forward

global type w_maintenance_customer from w_std_master_detail
integer width = 3507
integer height = 2125
string title = "Customer"
end type
global w_maintenance_customer w_maintenance_customer

type variables
Datawindow   idw_main, idw_search,idw_location,idw_inqury
SingleLineEdit isle_custcode
Boolean          ib_modified, ib_editmode
w_maintenance_customer iw_window
string i_sql
n_warehouse i_nwarehouse
String is_uf5_default_bg_color
end variables

forward prototypes
public function boolean f_setrequired (string as_customertype)
public function boolean f_requireaddress (boolean ab_require)
public function boolean f_requirecostcenterand3dpartyflag (boolean ab_require)
end prototypes

public function boolean f_setrequired (string as_customertype);long ll_weight
boolean lb_require, lb_success, lb_warehouse

// Default weight to 400
ll_weight = 400

Choose case as_customertype
		
	Case "WH"
		lb_require = true
		lb_warehouse = true
	
		// Make the weight 700
		ll_weight = 700
		
	Case "DC", "CU"

		// Derrive lb_iswarehouse
		lb_require = true
	
		// Make the weight 400
		ll_weight = 400
		
	Case "IN"
		lb_require 		= FALSE
		lb_warehouse 	= FALSE
		ll_weight 		= 400
		
End Choose
			
// Make these fields required.
tab_main.tabpage_main.dw_customer.modify("user_field2.Edit.Required=" + string(lb_warehouse)) //Whse
tab_main.tabpage_main.dw_customer.modify("user_field1.Edit.Required=" + string(lb_warehouse)) //Group
tab_main.tabpage_main.dw_customer.modify("user_field3.Edit.Required=" + string(lb_warehouse)) //ORG

// and bold
tab_main.tabpage_main.dw_customer.object.user_field2_t.font.weight = ll_weight //Whse, 
tab_main.tabpage_main.dw_customer.object.user_field1_t.font.weight = ll_weight //Group, 
tab_main.tabpage_main.dw_customer.object.user_field3_t.font.weight = ll_weight //ORG, 

// Require the address info.
f_requireaddress(lb_require)

// Require the 3d party flag and cost center
f_requirecostcenterand3dpartyflag(lb_require)

// return lb_success
return lb_success
end function

public function boolean f_requireaddress (boolean ab_require);long ll_weight
boolean lb_success

// Default ll_weight to 400
ll_weight = 400

// If were requiring the address,
If ab_require then
	
	// Set the weight to 700
	ll_weight = 700
End If

// Make the modifications
lb_success = tab_main.tabpage_main.dw_customer.modify("address_1.Edit.Required=" + string(ab_require)) = ""
tab_main.tabpage_main.dw_customer.modify("city.Edit.Required=" + string(ab_require))
//tab_main.tabpage_main.dw_customer.modify("state.Edit.Required=" + string(ab_require))
//tab_main.tabpage_main.dw_customer.modify("zip.Edit.Required=" + string(ab_require))
tab_main.tabpage_main.dw_customer.modify("country.Edit.Required=" + string(ab_require))
//tab_main.tabpage_main.dw_customer.modify("tel.Edit.Required=" + string(ab_require))
tab_main.tabpage_main.dw_customer.object.address1_t.font.weight = ll_weight
tab_main.tabpage_main.dw_customer.object.city_t.font.weight = ll_weight
//tab_main.tabpage_main.dw_customer.object.t_4.font.weight = ll_weight
//tab_main.tabpage_main.dw_customer.object.t_6.font.weight = ll_weight
tab_main.tabpage_main.dw_customer.object.country_t.font.weight = ll_weight
//tab_main.tabpage_main.dw_customer.object.tel_t.font.weight = ll_weight

// Return lb_success
return lb_success
end function

public function boolean f_requirecostcenterand3dpartyflag (boolean ab_require);long ll_weight
boolean lb_success

// Default ll_weight to 400
ll_weight = 400

// If were requiring the address,
If ab_require then
	
	// Set the weight to 700
	ll_weight = 700
Else
	
	// Set the weight to 400
	ll_weight = 400
	
End If

// Make the modifications
tab_main.tabpage_main.dw_customer.modify("user_field7.Edit.Required=" + string(ab_require)) //Cost Center
//tab_main.tabpage_main.dw_customer.modify("user_field8.Edit.Required=" + string(ab_require)) //3rd Party Flag
tab_main.tabpage_main.dw_customer.object.user_field7_t.font.weight = ll_weight //Cost Center, 
//tab_main.tabpage_main.dw_customer.object.user_field8_t.font.weight = ll_weight //3rd Party Flag, 

// Return lb_success
return lb_success
end function

event open;call super::open;ib_changed = False
ib_edit = True
tab_main.MoveTab(3, 2)
i_nwarehouse = create n_warehouse

ilHelpTopicID = 536 /*set help file topic ID*/

// Storing into variables

//// KRZ If this is Pandora, show the 3rd Party Flag and default to 'NO'.
//If gs_project = 'PANDORA' then
//	tab_main.tabpage_main.dw_customer.dataobject = "d_customer_maintenance_pandora"
//	tab_main.tabpage_main.dw_customer.settransobject(sqlca)
////If gs_project = 'PANDORA' then
//////tab_main.tabpage_main.dw_customer.object.user_field8.dddw.name='dddw_pandora_sub_inv_locs'
//////tab_main.tabpage_main.dw_customer.object.user_field8.dddw.displaycolumn='cust_name'
//////tab_main.tabpage_main.dw_customer.object.user_field8.dddw.datacolumn='cust_code'
//////tab_main.tabpage_main.dw_customer.object.user_field8.ddlb.initial='no'
////tab_main.tabpage_main.dw_customer.object.user_field8.ddlb.values='Yes	Yes/No	No/'
////tab_main.tabpage_main.dw_customer.object.user_field8.ddlb.useasborder='yes'
////tab_main.tabpage_main.dw_customer.object.user_field8.ddlb.useasborder='yes'
////tab_main.tabpage_main.dw_customer.object.user_field8.ddlb.allowedit='no'
////tab_main.tabpage_main.dw_customer.object.user_field8.ddlb.vscrollbar='yes'
////tab_main.tabpage_main.dw_customer.object.user_field8.width="650"
////tab_main.tabpage_main.dw_customer.object.user_field8.ddlb.percentwidth="200"
////tab_main.tabpage_main.dw_customer.object.user_field8_t.width="380"
////tab_main.tabpage_main.dw_customer.object.user_field8_t.x="2339"             
////
//////	tab_main.tabpage_main.dw_customer.dataobject = "d_customer_maintenance_pandora"
//////	tab_main.tabpage_main.dw_customer.settransobject(sqlca)
////////	tab_main.tabpage_main.dw_customer.object.user_field8.visible="1"
////End IF
//End IF

iw_window = This
//is_process = Message.StringParm
idw_main = tab_main.tabpage_main.dw_customer
idw_inqury = tab_main.tabpage_search.dw_inqury
idw_search = tab_main.tabpage_search.dw_search
isle_custcode = tab_main.tabpage_main.sle_customer
idw_location = tab_main.tabpage_location.dw_address

idw_main.SetTransObject(Sqlca)
idw_search.SetTransObject(Sqlca)
idw_inqury.SetTransObject(Sqlca)
idw_location.SetTransObject(Sqlca)
idw_inqury.insertrow(0)

//f_datawindow_change(idw_location)
//f_datawindow_change(idw_main)
//f_datawindow_change(idw_search)
//f_datawindow_change(idw_inqury)

is_uf5_default_bg_color = idw_main.object.user_field5.Background.Color

i_sql = idw_search.getsqlselect()
i_nwarehouse.of_init_prj_ddw(idw_main,'customer_type')
i_nwarehouse.of_init_prj_ddw(idw_inqury,'user_field2') /*04/01 PCONKL*/
// Default into edit mode
This.TriggerEvent("ue_edit")
end event

on w_maintenance_customer.create
int iCurrent
call super::create
end on

on w_maintenance_customer.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_edit;

// Acess Rights
//is_process = Message.StringParm
If f_check_access(is_process,"E") = 0 Then
	close(w_maintenance_customer)
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
tab_main.tabpage_location.enabled = False

idw_main.Reset()
idw_location.reset()
idw_main.Hide()

tab_main.SelectTab(1) 

// Reseting the Single line edit
isle_custcode.DisplayOnly = False
isle_custcode.TabOrder = 10
isle_custcode.Text = ""
isle_custcode.SetFocus()

idw_main.object.user_field5.protect = TRUE
idw_main.Modify("user_field5.Background.Color = '" +  is_uf5_default_bg_color + "'")

//TimA 03/26/13 Pandora issue #595
if gs_project = 'PANDORA' then
idw_main.object.user_field6.protect = TRUE
idw_main.Modify("user_field6.Background.Color = '" +  is_uf5_default_bg_color + "'")
End if
end event

event ue_save;Integer li_ret
String ls_loc, ls_ploc, ls_custtype, ls_Customer_Code
Long ll_cnt, i, ll_Content_Amount
boolean lb_soldto

IF f_check_access(is_process,"S") = 0 THEN Return 0

// If this is the Pandora project,
If 	gs_project = "PANDORA" then
	If idw_Main.RowCount() > 0 then
		If tab_main.tabpage_main.dw_customer.GetItemString(1,"Customer_Type")  = 'IN' Then
									
			If 	ISNull(  tab_main.tabpage_main.sle_customer.text ) Then
				MessageBox("Error", "Customer Code CANNOT Be Blank or NULL!")
				 tab_main.tabpage_main.sle_customer.SetFocus()
				 tab_main.tabpage_main.sle_customer.SelectText(1,Len(tab_main.tabpage_main.sle_customer.Text))
				return -1
			Else
				ls_Customer_Code  = tab_main.tabpage_main.sle_customer.text
				ll_Content_Amount  = 0	
					
				SELECT Sum(Avail_Qty) as AVAIL_QTY
				INTO     :ll_Content_Amount
					FROM 	Content, Owner
					WHERE ( Content.Project_ID = 'PANDORA' ) and 
							Content.Owner_id = owner.Owner_id and 
							Content.Avail_Qty > 0 and 
							Owner.Owner_cd =:ls_Customer_Code;
				If isnull(ll_Content_Amount) or	ll_Content_Amount <= 0 Then
					// Set warehouse required fields.
					f_setrequired('IN')
				Else
					MessageBox( "Error", "A Customer with Inventory CANNOT be placed in INACTIVE Status!")
					tab_main.tabpage_main.dw_customer.SetColumn("Customer_Type")
					tab_main.tabpage_main.dw_customer.SelectText(1,len( tab_main.tabpage_main.dw_customer.GetItemString(1,"Customer_Type")))
					return -1
				End If	
			End If	
		end if
	End If
End If

If idw_main.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	Return -1
End If

If idw_location.AcceptText() = -1 Then 
	tab_main.SelectTab(2) 
	idw_location.SetFocus()
	Return -1
End If

// Check for required values

// 12/09 - PCONKL - Only validate if record not deleted...
If idw_Main.RowCount() > 0 Then

	idw_location.Sort()

	If f_check_required(is_title, idw_main) = -1 Then
		tab_main.SelectTab(1) 
		Return -1
	End If

	If f_check_required(is_title, idw_location) = -1 Then
		tab_main.SelectTab(2) 
		Return -1
	End If

	// Check for duplicate records

	ll_cnt = idw_location.RowCount()
	ls_ploc = "XXXXXXXXXX"

	// Get the customer type
	ls_custtype = tab_main.tabpage_main.dw_customer.getitemstring(1, "customer_type")

	For i = 1 to ll_cnt 
		SetMicroHelp("Checking location record " + String(i) + " of " + String(ll_cnt))
		ls_loc = idw_location.GetItemString(i, "address_code")
	
		// If we havn't found the 'soldto' address yet,
		If not lb_soldto then
		
			// Derrive soldto for this address.
			lb_soldto = lower(ls_loc) = "st"
		End If
	
		If ls_loc = ls_ploc Then
			Messagebox(is_title,"Found duplicate address record, please check!",StopSign!)
			tab_main.selecttab(2)
			f_setfocus(idw_location, i, "address_code")
			return -1
		End If
		
		If IsNull(idw_location.GetItemString(i, "cust_code")) Then
			idw_location.setitem(i,'cust_code', idw_main.GetItemString(1, "cust_code"))
			idw_location.setitem(i,'project_id', idw_main.GetItemString(1, "project_id"))
		End If
		ls_ploc = ls_loc
		
	Next
	
	// If project is pandora and customer type is 'wh',
	If gs_project = "PANDORA" and (ls_custtype = "WH" or ls_custtype = "CU" or ls_custtype = "DC") then
	
		// If we didn't find a 'sold to' address,
		If not lb_soldto then
		
			// Open the address tab,
			tab_main.selecttab("tabpage_location")
		
			// Show error message and return a -1
			messagebox(is_title, "You must input a 'sold to' address for PANDORA WH, CU and DC customer types.")
			Return -1
		
		// End If we didn't find a 'sold to' address,
		End If	
	
	// end If project is pandora and customer type is 'wh',
	End If

	// When updating setting the current user & date
	
	idw_main.SetItem(1,'last_update',Today()) 
	idw_main.SetItem(1,'last_user',gs_userid)
	
End If /* Record note deleted*/

// Updating the Datawindow

Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'

If idw_main.RowCount() > 0 Then	
	SQLCA.DBParm = "disablebind =0"
	li_ret = idw_main.Update(False, False)
	SQLCA.DBParm = "disablebind =1"
Else
	li_ret = 1
End If

If li_ret = 1 Then li_ret = idw_location.Update(False, False)
If li_ret = 1 and idw_main.RowCount() = 0 Then li_ret = idw_main.Update(False, False)

IF li_ret = 1 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		idw_location.ResetUpdate()
		idw_main.ResetUpdate()
		SetMicroHelp("Record Saved!")
		ib_changed = False
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

event ue_delete;call super::ue_delete;Long i, ll_cnt

If f_check_access(is_process,"D") = 0 Then Return

// Prompting for deletion
If MessageBox(is_title, "Are you sure you want to delete this record",Question!,YesNo!,2) = 2 Then
	Return
End If

SetPointer(HourGlass!)

ib_changed = False

tab_main.SelectTab(1)

ll_cnt = idw_location.RowCount()
For i = ll_cnt to 1 Step -1
	idw_location.DeleteRow(i)
Next

idw_main.DeleteRow(1)

If This.Trigger Event ue_save() = 0 Then
	SetMicroHelp("Record deleted!")
Else
	SetMicroHelp("Record delete failed!")
End If
This.Trigger Event ue_edit()


end event

event ue_new;

// Acess Rights
If f_check_access(is_process,"N") = 0 Then Return

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - New"
ib_edit = False
ib_changed = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()
tab_main.tabpage_location.enabled = False

// Tab properties
tab_main.SelectTab(1)
idw_main.Reset()
idw_main.InsertRow(0)
idw_main.Show()
//idw_main.Hide()

// Reseting the Single line edit
isle_custcode.DisplayOnly = False
isle_custcode.TabOrder = 10
isle_custcode.Text = ""
isle_custcode.SetFocus()

// KRZ Clear out the addresses on the location tab.
tab_main.tabpage_location.dw_address.reset()

If gs_project = "PANDORA" THEN
	
	// Default user field 8 to NO for Pandora.
	tab_main.tabpage_main.dw_customer.setitem(1, "user_field8", "No")
End If
end event

event ue_retrieve;call super::ue_retrieve;isle_custcode.TriggerEvent(Modified!)
end event

event closequery;call super::closequery;Long ll_status

If ib_changed Then
	Choose Case Messagebox(is_title,"Save changes?",Question!,yesnocancel!,3)
		Case 1
			ll_status = Triggerevent("ue_save")
			Return ll_status
		Case 2
			Return 0
		Case 3
			Return -1
	End Choose
Else
	Return 0
End If
end event

event close;call super::close;Destroy i_nwarehouse
end event

event ue_unlock;call super::ue_unlock;// LTK 20111111 Oracle integrated changes
long ll_count

if gs_project = 'PANDORA' then

	select count(*)
	into :ll_count
	from lookup_table
	where project_id = 'PANDORA'
	and code_type = 'USER'
	and code_id = :gs_userid;
	
	if ll_count > 0 then
		idw_main.object.user_field5.protect = FALSE
		idw_main.Modify("user_field5.Background.Color = '" +  string(RGB(255, 255, 255)) + "'")
		//TimA 03/26/13 Pandora issue #595
		idw_main.object.user_field6.protect = FALSE
		idw_main.Modify("user_field6.Background.Color = '" +  string(RGB(255, 255, 255)) + "'")		
	end if

end if

end event

event ue_postopen;call super::ue_postopen;
//09/2019 - MikeA - S36893 - F17464 - Google - SIMS - Container IDs in 945 EDI
// 'Allow Containers' should only be editable by Super Users (and above) 

If gs_role = '-1' or gs_role = '0' Then
	idw_main.SetTabOrder ("allow_containers_ind", 265 )
End If 

IF gs_project = 'PANDORA' THEN
	idw_main.object.allow_containers_ind.Visible = true
ELSE
	idw_main.object.allow_containers_ind.Visible = false
END IF

tab_main.tabpage_main.dw_customer.modify("allow_containers_ind.Edit.Required=" + string(false))
end event

type tab_main from w_std_master_detail`tab_main within w_maintenance_customer
event create ( )
event destroy ( )
integer x = 7
integer y = 13
integer width = 3423
integer height = 1875
tabpage_location tabpage_location
end type

on tab_main.create
this.tabpage_location=create tabpage_location
call super::create
this.Control[]={this.tabpage_main,&
this.tabpage_search,&
this.tabpage_location}
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_location)
end on

event tab_main::selectionchanged;//For updating sort option
CHOOSE CASE newindex
	CASE 3
		wf_check_menu(TRUE,'sort')
		idw_current = idw_search
	Case Else		
		wf_check_menu(FALSE,'sort')
END CHOOSE
end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer x = 15
integer y = 99
integer width = 3394
integer height = 1763
string text = "Customer"
st_customer_code st_customer_code
sle_customer sle_customer
dw_customer dw_customer
end type

on tabpage_main.create
this.st_customer_code=create st_customer_code
this.sle_customer=create sle_customer
this.dw_customer=create dw_customer
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_customer_code
this.Control[iCurrent+2]=this.sle_customer
this.Control[iCurrent+3]=this.dw_customer
end on

on tabpage_main.destroy
call super::destroy
destroy(this.st_customer_code)
destroy(this.sle_customer)
destroy(this.dw_customer)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer x = 15
integer y = 99
integer width = 3394
integer height = 1763
cb_cust_search cb_cust_search
cb_cust_clear cb_cust_clear
dw_inqury dw_inqury
dw_search dw_search
end type

on tabpage_search.create
this.cb_cust_search=create cb_cust_search
this.cb_cust_clear=create cb_cust_clear
this.dw_inqury=create dw_inqury
this.dw_search=create dw_search
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cust_search
this.Control[iCurrent+2]=this.cb_cust_clear
this.Control[iCurrent+3]=this.dw_inqury
this.Control[iCurrent+4]=this.dw_search
end on

on tabpage_search.destroy
call super::destroy
destroy(this.cb_cust_search)
destroy(this.cb_cust_clear)
destroy(this.dw_inqury)
destroy(this.dw_search)
end on

type st_customer_code from statictext within tabpage_main
integer x = 154
integer y = 19
integer width = 486
integer height = 77
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
string text = "Customer Code:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_customer from singlelineedit within tabpage_main
integer x = 647
integer y = 13
integer width = 955
integer height = 93
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
textcase textcase = upper!
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_code
Long   ll_rows

ls_code = This.Text

IF NOT IsNull(ls_code) Or ls_code <> '' THEN
	ll_rows = idw_main.Retrieve( gs_project , ls_code)       // Retrieving the entry datawindow	
	IF ib_edit THEN								    // Edit Mode
		IF ll_rows > 0 THEN
			This.DisplayOnly = True
			This.TabOrder = 0			
			ll_rows = idw_location.Retrieve(gs_project, ls_code)      
			idw_main.Show()
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
			im_menu.m_record.m_delete.Enable()
			tab_main.tabpage_location.enabled = true
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
			This.DisplayOnly = True
			This.TabOrder = 0			
			idw_main.InsertRow(0)
			idw_main.SetItem(1,"project_id",gs_project)			
			idw_main.SetItem(1,"cust_code",ls_code)
			idw_main.Show()
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
			tab_main.tabpage_location.enabled = TRUE
		END IF
	END IF
ELSE
	MessageBox(is_title, "Please enter the customer code!", Exclamation!)
	This.SetFocus()
END IF	

end event

type dw_customer from u_dw_ancestor within tabpage_main
integer x = 128
integer y = 106
integer width = 3240
integer height = 1616
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_customer_maintenance"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;string ls_countrycode, ls_codeexchange, lscoo, ls_Customer_Code
long ll_Content_Amount
nvo_country lnvo_country

// What object changed?
Choose Case dwo.name
		
	Case "user_field8"

		// If this is the Pandora project,
		If gs_project = "PANDORA" then
			
			// What is the value
			Choose Case lower(data)
					
				Case "yes", "no"
					
				Case Else
					
					messagebox(is_title, "You must enter either 'yes' or 'no' for 3rd Party Flag")
					
					return 1
			End Choose
		
		// End if this is the Pandora Project.
		End If
		
	Case "customer_type"

		// If this is the Pandora project,
		If gs_project = "PANDORA" then
			
			If data = 'IN' Then
								
				This.AcceptText()				
								
				If ISNull( sle_customer.text ) Then
					MessageBox("Error", "Customer Code CANNOT Be Blank or NULL!")
					sle_customer.SetFocus()
					sle_customer.SelectText(1,Len(sle_customer.Text))
				    return 1
				Else
					
				  	ls_Customer_Code  = sle_customer.text
					ll_Content_Amount  = 0	
				
				 	SELECT Sum(Avail_Qty) as AVAIL_QTY
				 	INTO     :ll_Content_Amount
    					FROM 	Content, Owner
   					WHERE ( Content.Project_ID = 'PANDORA' ) and 
								Content.Owner_id = owner.Owner_id and 
								Content.Avail_Qty > 0 and 
								Owner.Owner_cd =:ls_Customer_Code;
			
					If 	isnull(ll_Content_Amount) or ll_Content_Amount <= 0 Then
					
						// Set warehouse required fields.
						f_setrequired('IN')
					
					Else
						MessageBox( "Error", "A Customer with Inventory CANNOT be placed in INACTIVE Status!")
						tab_main.tabpage_main.dw_customer.SetColumn("Customer_Type")
						tab_main.tabpage_main.dw_customer.SelectText(1,len( tab_main.tabpage_main.dw_customer.GetItemString(1,"Customer_Type")))
					
					End If
				End If
			Else
									
				// Set warehouse required fields.
				f_setrequired(data)
	
			End If
		// End if this is the Pandora Project.
		End If
		
	Case "country" /*Validate COO*/
		
		// If this is a Pandora project,
		If gs_project = "PANDORA" then
		
			// Set ls_countrycode to the data value
			ls_countrycode = data
			
			// Create the country object
			lnvo_country = Create nvo_country
			
			// If the user typed a 3 char code,
			If len(data) = 3 then
				
				// If we can replace the 3 char code with the 2 char code.
				If lnvo_country.f_exchangecodes(ls_countrycode, ls_codeexchange) then
				
					// Set the 2 char code instead.
					Post setitem(row, dwo.name, ls_codeexchange)
					
				// Otherwise, if we can't exchange the codes,
				Else
					
					if gs_project <> 'CHINASIMS' then
						
						// Show Error.
						MessageBox(is_title, "Invalid Country, please re-enter!")
						
						// Prevent the data from taking.
						return 1
						
					end if
					
				// End If
				End If
			End If
		End If
		
		//02/02 - PCONKL - we will now allow 2,3 char or 3 numeric COO and validate agianst Country Table
		// pvh - itemchanged error if not pandora.
		if NOT isvalid( lnvo_country ) then
			// Create the country object
			lnvo_country = Create nvo_country
		end if
		// pvh - end itemchanged error if not pandora.
		If not lnvo_country.f_getnameforcode(data, lsCOO) Then
			if gs_project <> 'CHINASIMS' then
				MessageBox(is_title, "Invalid Country, please re-enter!")
				Return 1
			end if
		End If
		
		// Destroy the country object.
		Destroy lnvo_country
	
// End what object changed.
End Choose

// Set the item changed flag.
ib_changed = True
end event

event itemerror;//DGM This event shows the column name 
	string ls_name

	if trim(data) <> "" THEN return 0
	ls_name = dwo.name
	ls_name=this.describe(ls_name+"_t"+".text")
	ls_name = mid(ls_name,1,pos(ls_name,':') - 1)	//trims the : at end	
	MessageBox("DataWindow Error","Value required for " + ls_name)
	return 1

end event

event process_enter;If This.GetColumnName() <> "remark" Then
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If
end event

event constructor;call super::constructor;
If NOt g.ibCCCEnabled Then
	This.Modify("ccc_enabled_ind.visible=false")
End IF
end event

type cb_cust_search from commandbutton within tabpage_search
integer x = 2816
integer y = 16
integer width = 358
integer height = 109
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

event clicked;string ls_cust_name,ls_city,ls_uf1,ls_uf2,ls_contact_person,ls_tel
string ls_where,ls_sql, ls_cust_code
Boolean lb_where
idw_search.DBCancel() /*retrieve as needed*/
idw_search.reset()
//idw_inqury.insertrow(0)

If idw_inqury.accepttext() = -1 Then Return
lb_where = False
ls_cust_name = idw_inqury.getitemstring(1,"custom_name")
ls_cust_code = idw_inqury.getitemstring(1,"custom_code")
ls_city = idw_inqury.getitemstring(1,"city")
ls_tel = idw_inqury.getitemstring(1,"tel")
ls_uf1 = idw_inqury.getitemstring(1,"user_field1")
ls_uf2 = idw_inqury.getitemstring(1,"user_field2")
ls_contact_person = idw_inqury.getitemstring(1,"contact_person")

ls_where = "Where customer.project_id = '" + gs_project + "' "  

if  not isnull(ls_cust_name) then
	ls_where += " and customer.cust_name like '" + ls_cust_name + "%' "
	lb_where = True
end if

if  not isnull(ls_cust_code) then
	ls_where += " and customer.cust_code like '" + ls_cust_code + "%' "
	lb_where = True
end if

if not isnull(ls_contact_person) then
	ls_where += " and customer.contact_person like '%" + ls_contact_person + "%' "
	lb_where = True
end if

if not isnull(ls_city) then
	ls_where += " and customer.city = '" + ls_city + "' "
	lb_where = True
end if

if not isnull(ls_uf1) then
	ls_where += " and customer.user_field1 = '" + ls_uf1 + "' "
	lb_where = True
end if

// 07/00 PCONKL - Customer type is real field in DB, not USer 2 anymore
if not isnull(ls_uf2) then
	ls_where += " and customer.customer_type = '" + ls_uf2 + "'  "
	lb_where = True
end if

if not isnull(ls_tel) then
	ls_where += " and customer.tel = '" + ls_tel+ "'  "
	lb_where = True
end if


//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF

ls_sql = i_sql + ls_where
idw_search.setsqlselect(ls_sql)

if idw_search.retrieve() = 0 then
	messagebox(is_title,"No records found!")
end if


end event

event constructor;
g.of_check_label_button(this)
end event

type cb_cust_clear from commandbutton within tabpage_search
integer x = 2816
integer y = 141
integer width = 358
integer height = 109
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;idw_search.Reset()
idw_inqury.Reset()
idw_inqury.InsertRow(0)
idw_inqury.setfocus()
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_inqury from u_dw_ancestor within tabpage_search
integer x = 40
integer y = 3
integer width = 2761
integer height = 384
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_maintenance_custom_inquire"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type dw_search from u_dw_ancestor within tabpage_search
integer x = 59
integer y = 410
integer width = 3109
integer height = 1200
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_maintenance_customer_search"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;// Pasting the record to the main entry datawindow
IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	IF NOT ib_changed THEN
		isle_custcode.Text = This.GetItemString(row,"cust_code")
		isle_custcode.TriggerEvent("modified")
	END IF
END IF
end event

event constructor;call super::constructor;idw_current = this
end event

type tabpage_location from userobject within tab_main
event create ( )
event destroy ( )
integer x = 15
integer y = 99
integer width = 3394
integer height = 1763
long backcolor = 79741120
string text = "Address"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 553648127
cb_insert_row cb_insert_row
cb_delete_row cb_delete_row
dw_address dw_address
end type

on tabpage_location.create
this.cb_insert_row=create cb_insert_row
this.cb_delete_row=create cb_delete_row
this.dw_address=create dw_address
this.Control[]={this.cb_insert_row,&
this.cb_delete_row,&
this.dw_address}
end on

on tabpage_location.destroy
destroy(this.cb_insert_row)
destroy(this.cb_delete_row)
destroy(this.dw_address)
end on

type cb_insert_row from commandbutton within tabpage_location
integer x = 40
integer y = 26
integer width = 377
integer height = 109
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert Row"
end type

event clicked;Long ll_row

idw_location.SetFocus()

If idw_location.AcceptText() = -1 Then Return

idw_location.setcolumn('address_code')

ll_row = idw_location.GetRow()
If ll_row > 0 Then
	ll_row = idw_location.InsertRow(ll_row + 1)
	idw_location.ScrollToRow(ll_row)
Else
	ll_row = idw_location.InsertRow(0)
End If

// 01/01 PCONKL
idw_location.SetItem(ll_row,'Last_user',gs_userid)
idw_location.SetItem(ll_row,'Last_update',today())
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_delete_row from commandbutton within tabpage_location
integer x = 435
integer y = 26
integer width = 377
integer height = 109
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Row"
end type

event clicked;Long curr_row

curr_row = idw_location.GetRow()
if curr_row > 0 then
	idw_location.deleterow(0)
	ib_changed = True
end if
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_address from u_dw_ancestor within tabpage_location
integer y = 170
integer width = 3240
integer height = 1373
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_maintenance_customer_address"
boolean vscrollbar = true
end type

event itemchanged;ib_changed = True

end event

event process_enter;If This.GetColumnName() <> "remark" Then
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If
end event

