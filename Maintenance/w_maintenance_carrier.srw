HA$PBExportHeader$w_maintenance_carrier.srw
$PBExportComments$- Carrier Maintenance
forward
global type w_maintenance_carrier from w_std_master_detail
end type
type st_carrier_code from statictext within tabpage_main
end type
type sle_carrier from singlelineedit within tabpage_main
end type
type dw_project from u_dw_ancestor within tabpage_main
end type
type cb_carrier_search from commandbutton within tabpage_search
end type
type dw_select from datawindow within tabpage_search
end type
type dw_search from u_dw_ancestor within tabpage_search
end type
type cb_carrier_clear from commandbutton within tabpage_search
end type
type tabpage_defaults from userobject within tab_main
end type
type tabpage_defaults from userobject within tab_main
end type
type tabpage_warehouse from userobject within tab_main
end type
type cb_do_det_insert from commandbutton within tabpage_warehouse
end type
type cb_do_det_delete from commandbutton within tabpage_warehouse
end type
type dw_pro_warehouse from u_dw_ancestor within tabpage_warehouse
end type
type tabpage_warehouse from userobject within tab_main
cb_do_det_insert cb_do_det_insert
cb_do_det_delete cb_do_det_delete
dw_pro_warehouse dw_pro_warehouse
end type
end forward

global type w_maintenance_carrier from w_std_master_detail
integer width = 3625
integer height = 2532
string title = "Carrier Maintenance"
end type
global w_maintenance_carrier w_maintenance_carrier

type variables
Datawindow   idw_main, idw_search
Datawindow idw_pro_warehouse
Datawindow idw_project
DataWindowChild idwc_warehouse
DataWindowChild idwc_algorithm
Datawindowchild idwc_carrier_Group
SingleLineEdit isle_carrier
w_maintenance_carrier iw_window

String	isOrigSql
String isCurrentCarrierGroup
Boolean ib_UpdateProWarehouse
end variables

event open;call super::open;Integer i, li_ret
Datawindowchild ldwc_carrier_Group

// Intialize

is_title = This.Title
iw_window = This
ilHelpTopicID = 537 /*set help topic ID*/
im_menu = This.Menuid
ib_edit = True
ib_changed = False
is_process = Message.StringParm
DataWindowChild ldwc
// Storing into variables
idw_main = tab_main.tabpage_main.dw_project
idw_search = tab_main.tabpage_search.dw_search
isle_carrier = tab_main.tabpage_main.sle_carrier
//Transport Mode dropdown loaded by project

idw_main.getChild('transport_mode',ldwc)
ldwc.SetTransObject(sqlca)
If ldwc.Retrieve(gs_Project) = 0 Then
	ldwc.InsertRow(0)
End IF

idw_main.GetChild("carrier_group", idwc_carrier_Group )
idwc_carrier_Group.SetTransObject(sqlca )
idwc_carrier_Group.SetTransObject(sqlca )
If idwc_carrier_Group.retrieve(gs_project ) = 0 Then
	idwc_carrier_Group.InsertRow(0)
End if

// 05/00 - pconkl - capture original sql
isOrigSql = idw_search.getsqlselect()

// change the style of datawindow object
//f_datawindow_change (idw_main)

tab_main.tabpage_search.dw_select.Insertrow(0)

// Default into edit mode
This.TriggerEvent("ue_edit")

//TimA 05/11/15 made the defaults tab non visiable because nobody knew what it was for.
//Instead of deleting it we changed the visible property to see if someone complains.
tab_main.tabpage_defaults.visible = false

//3COM_Nash - LMS Rating Flags

IF Upper(gs_project) = "3COM_NASH" THEN
	
	tab_main.tabpage_main.dw_project.object.user_field1_t.text = "Parcel Rating Flags: AMI:"
	tab_main.tabpage_main.dw_project.object.user_field1_t.x="101" 
	tab_main.tabpage_main.dw_project.object.user_field1_t.y="1625" 
	tab_main.tabpage_main.dw_project.object.user_field1_t.height="64" 
	tab_main.tabpage_main.dw_project.object.user_field1_t.width="731"
	tab_main.tabpage_main.dw_project.object.user_field1_t.font.weight="700"
	
	
	tab_main.tabpage_main.dw_project.Object.user_field1.Values = "P~tP/B~tB/~t(None)~t/"
	tab_main.tabpage_main.dw_project.Object.user_field2.Values = "P~tP/B~tB/~t(None)~t/"
	tab_main.tabpage_main.dw_project.Object.user_field3.Values = "P~tP/B~tB/~t(None)~t/"

	
	tab_main.tabpage_main.dw_project.object.user_field1.x="864" 
	tab_main.tabpage_main.dw_project.object.user_field1.y="1625" 
	tab_main.tabpage_main.dw_project.object.user_field1.height="64" 
	tab_main.tabpage_main.dw_project.object.user_field1.width="272"
	tab_main.tabpage_main.dw_project.object.user_field1.ddlb.limit="0"
	tab_main.tabpage_main.dw_project.object.user_field1.ddlb.allowedit="no" 
	tab_main.tabpage_main.dw_project.object.user_field1.ddlb.case="any" 
	tab_main.tabpage_main.dw_project.object.user_field1.ddlb.nilisnull="yes" 
	tab_main.tabpage_main.dw_project.object.user_field1.ddlb.useasborder="yes"
	tab_main.tabpage_main.dw_project.object.user_field1.ddlb.imemode="0"

	tab_main.tabpage_main.dw_project.object.user_field2_t.text = "APR:"
	tab_main.tabpage_main.dw_project.object.user_field2_t.x="1150" 
	tab_main.tabpage_main.dw_project.object.user_field2_t.y="1625"  
	tab_main.tabpage_main.dw_project.object.user_field2_t.height="64" 
	tab_main.tabpage_main.dw_project.object.user_field2_t.width="160"
	tab_main.tabpage_main.dw_project.object.user_field2_t.font.weight="700"



	tab_main.tabpage_main.dw_project.object.user_field2.x="1350" 
	tab_main.tabpage_main.dw_project.object.user_field2.y="1625"  
	tab_main.tabpage_main.dw_project.object.user_field2.height="64" 
	tab_main.tabpage_main.dw_project.object.user_field2.width="272"
	tab_main.tabpage_main.dw_project.object.user_field2.ddlb.limit="0"
	tab_main.tabpage_main.dw_project.object.user_field2.ddlb.allowedit="no" 
	tab_main.tabpage_main.dw_project.object.user_field2.ddlb.case="any" 
	tab_main.tabpage_main.dw_project.object.user_field2.ddlb.nilisnull="yes" 
	tab_main.tabpage_main.dw_project.object.user_field2.ddlb.useasborder="yes"
	tab_main.tabpage_main.dw_project.object.user_field2.ddlb.imemode="0"

	tab_main.tabpage_main.dw_project.object.user_field3_t.text = "EMEA:"
	tab_main.tabpage_main.dw_project.object.user_field3_t.x="1650" 
	tab_main.tabpage_main.dw_project.object.user_field3_t.y="1625" 
	tab_main.tabpage_main.dw_project.object.user_field3_t.height="64" 
	tab_main.tabpage_main.dw_project.object.user_field3_t.width="192"
	tab_main.tabpage_main.dw_project.object.user_field3_t.font.weight="700"

	tab_main.tabpage_main.dw_project.object.user_field3.x="1875" 
	tab_main.tabpage_main.dw_project.object.user_field3.y="1625"  
	tab_main.tabpage_main.dw_project.object.user_field3.height="64" 
	tab_main.tabpage_main.dw_project.object.user_field3.width="272"
	tab_main.tabpage_main.dw_project.object.user_field3.ddlb.limit="0"
	tab_main.tabpage_main.dw_project.object.user_field3.ddlb.allowedit="no" 
	tab_main.tabpage_main.dw_project.object.user_field3.ddlb.case="any" 
	tab_main.tabpage_main.dw_project.object.user_field3.ddlb.nilisnull="yes" 
	tab_main.tabpage_main.dw_project.object.user_field3.ddlb.useasborder="yes"
	tab_main.tabpage_main.dw_project.object.user_field3.ddlb.imemode="0"

	tab_main.tabpage_main.dw_project.object.user_field4_t.visible="0"
	tab_main.tabpage_main.dw_project.object.user_field5_t.visible="0"

	tab_main.tabpage_main.dw_project.object.user_field4.visible="0"
	tab_main.tabpage_main.dw_project.object.user_field5.visible="0"

	
END IF

end event

on w_maintenance_carrier.create
int iCurrent
call super::create
end on

on w_maintenance_carrier.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_edit;
// Acess Rights
is_process = Message.StringParm
If f_check_access(is_process,"E") = 0 Then
	close(w_maintenance_carrier)
	return
end if

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit " + isle_carrier.Text
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
isle_carrier.DisplayOnly = False
isle_carrier.TabOrder= 10
isle_carrier.Text = ""
isle_carrier.SetFocus()


end event

event ue_save;Integer li_ret, llProRow, llRow
Decimal ld_orgprice, ld_price  
STRING ls_User_Field,ls_wh_code, lsProject, ls_carriercode
String lsWhCode, lsProAlgorithm,lsCarrierGroup
dwItemStatus l_dwMainStatus

//Modified By TimA 05/21/15 added new table Carrier Pro Warehouse
//TimA 09/07/15 Updated the save to include carrier groups. 
IF f_check_access(is_process,"S") = 0 THEN Return 0
//tab_main.Selectedtab = 1
//tab_main.tabpage_main.SelectedTab = 1

// When updating setting the current user & date
If idw_main.AcceptText() = -1 Then Return -1
If idw_pro_warehouse.AcceptText() = -1 Then Return -1
l_dwMainStatus = idw_main.GetItemStatus(1, "carrier_group", Primary!)		
lsCarrierGroup = idw_main.GetItemString(1,'carrier_group' )

idw_main.SetItem(1,'carrier_group',Upper(lsCarrierGroup ) ) 

If l_dwMainStatus <> DataModified! Then
	
	llProRow = idw_pro_warehouse.rowcount( )
	//TimA 09/09/15 This is needed when only saving the main screen.  There maybe a records in the pro number tab but that is only for it's first input record if needed.
	If llProRow <> 1 and (lsCarrierGroup = '' or Isnull(lsCarrierGroup ) ) then
		
		If llProRow > 0 then
			For llRow = 1 to  idw_pro_warehouse.rowcount( )
				lsWhCode = idw_pro_warehouse.GetItemString(llRow,'Wh_Code')
				
				If lsWhCode = '' or Isnull(lsWhCode)then
					MessageBox(is_title, "You must provice a Wh_Code")
				Return -1
				End if
				lsProAlgorithm = idw_pro_warehouse.GetItemString(llRow,'Pro_Algorithm')
				If lsProAlgorithm = '' or Isnull(lsProAlgorithm)then
					MessageBox(is_title, "You must proviced a Pro Algorithm calculation")
					Return -1
				End if
			Next
		End if
	End if
End if
idw_main.SetItem(1,'last_update',Today( ) ) 
idw_main.SetItem(1,'last_user',gs_userid )
idw_main.SetItem(1,"project_id",gs_project )



If idw_main.RowCount() > 0 Then
	If isnull(idw_main.GetItemString(1,"carrier_code")) Then
		If isnull(isle_carrier.Text) or isle_carrier.Text = '' Then
			Messagebox(is_title,"Carrier Code is Required!")
			isle_carrier.Setfocus()
			Return - 1
		Else
			idw_main.SetItem(1,"carrier_code",isle_carrier.Text)
		End If
	End If
	

	
End If

// Updating the Datawindow
Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
SQLCA.DBParm = "disablebind =0"
li_ret = idw_main.Update(False, False)
//If l_dwMainStatus <> DataModified! Then //Only the carrier group was changed
	//TimA 05/21/15 new DW added for Carrier Pro Warehouse  
	If ib_UpdateProWarehouse = True Then //Don't update this DW if no changes are made.
		if li_ret = 1 then li_ret =idw_pro_warehouse.Update(False, False)
	End if
//End if
SQLCA.DBParm = "disablebind =1"
IF li_ret = 1 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		idw_main.ResetUpdate()
		idw_pro_warehouse.ResetUpdate()
		SetMicroHelp("Record Saved!")
		ib_changed = False
		ib_UpdateProWarehouse = False
		// Bringing back to edit mode
		IF ib_edit = False THEN
			ib_edit = True
			This.Title = is_title + " - Edit"
			im_menu.m_file.m_save.Enable()
			im_menu.m_file.m_retrieve.Enable()
			im_menu.m_record.m_delete.Enable()
		END IF
		tab_main.tabpage_main.sle_carrier.Trigger Event modified()
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


// Reseting the Single line edit
isle_carrier.DisplayOnly = False
isle_carrier.TabOrder= 10
isle_carrier.text = ""
isle_carrier.SetFocus()

end event

event ue_clear;tab_main.tabpage_search.dw_select.Reset()
tab_main.tabpage_search.dw_select.InsertRow(0)
tab_main.tabpage_search.dw_select.Setfocus()

end event

event ue_postopen;call super::ue_postopen;
DataWindowChild ldwc_warehouse
Long llNEwRow
idw_pro_warehouse = tab_main.tabpage_warehouse.dw_pro_warehouse

idw_project = tab_main.tabpage_main.dw_project

idw_pro_warehouse.GetChild("wh_code", idwc_warehouse)
idwc_algorithm.GetChild("pro_algorithm", idwc_algorithm)
idwc_warehouse.SetTransObject(sqlca)
idwc_algorithm.SetTransObject(sqlca)
idwc_algorithm.retrieve( )

//TimA 05/21/15 new DDDW added
g.of_set_warehouse_dropdown(idwc_warehouse)
	llNEwRow = ldwc_warehouse.InsertRow(0)
	idwc_warehouse.SetITem(llNewRow,'wh_Code', 'ALL') //ALL is the default
	idwc_warehouse.SetITem(llNewRow,'wh_Name', 'ALL Warehouses')
	idwc_warehouse.SetITem(llNewRow,'Project_id',gs_project)
	idwc_warehouse.SetSort ( 'wh_Code a' )
	idwc_warehouse.Sort()
	

end event

event resize;call super::resize;tab_main.Resize(workspacewidth(),workspaceHeight())
tab_main.tabpage_warehouse.dw_pro_warehouse.Resize(workspacewidth() - 80,workspaceHeight()-250 )

end event

event ue_retrieve;call super::ue_retrieve;tab_main.tabpage_main.sle_carrier.Trigger Event modified()

end event

type tab_main from w_std_master_detail`tab_main within w_maintenance_carrier
integer x = 9
integer y = 0
integer width = 3557
integer height = 2304
tabpage_defaults tabpage_defaults
tabpage_warehouse tabpage_warehouse
end type

event tab_main::selectionchanged;//For updating sort option
String lsCarrierGroup
CHOOSE CASE newindex
	CASE 2
		wf_check_menu(TRUE,'sort')
		idw_current = idw_search
	Case Else		
		wf_check_menu(FALSE,'sort')
END CHOOSE

end event

on tab_main.create
this.tabpage_defaults=create tabpage_defaults
this.tabpage_warehouse=create tabpage_warehouse
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_defaults
this.Control[iCurrent+2]=this.tabpage_warehouse
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_defaults)
destroy(this.tabpage_warehouse)
end on

event tab_main::selectionchanging;call super::selectionchanging;String lsCarrierGroup
If ib_changed Then
	messagebox(is_title,'Please save changes first')
	return 1
End If
CHOOSE CASE newindex

	Case 4
		lsCarrierGroup = idw_Main.GetItemString(1,'Carrier_Group' )
 		If Isnull(lsCarrierGroup) or lsCarrierGroup = '' then
			messagebox(is_Title,'There must be a Carrier Group ~r either selecte one or create a new group by entering in a name' )
			return 1
		 End if
	End Choose
end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer width = 3520
integer height = 2176
string text = "Carrier"
st_carrier_code st_carrier_code
sle_carrier sle_carrier
dw_project dw_project
end type

on tabpage_main.create
this.st_carrier_code=create st_carrier_code
this.sle_carrier=create sle_carrier
this.dw_project=create dw_project
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_carrier_code
this.Control[iCurrent+2]=this.sle_carrier
this.Control[iCurrent+3]=this.dw_project
end on

on tabpage_main.destroy
call super::destroy
destroy(this.st_carrier_code)
destroy(this.sle_carrier)
destroy(this.dw_project)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer width = 3520
integer height = 2176
cb_carrier_search cb_carrier_search
dw_select dw_select
dw_search dw_search
cb_carrier_clear cb_carrier_clear
end type

on tabpage_search.create
this.cb_carrier_search=create cb_carrier_search
this.dw_select=create dw_select
this.dw_search=create dw_search
this.cb_carrier_clear=create cb_carrier_clear
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_carrier_search
this.Control[iCurrent+2]=this.dw_select
this.Control[iCurrent+3]=this.dw_search
this.Control[iCurrent+4]=this.cb_carrier_clear
end on

on tabpage_search.destroy
call super::destroy
destroy(this.cb_carrier_search)
destroy(this.dw_select)
destroy(this.dw_search)
destroy(this.cb_carrier_clear)
end on

type st_carrier_code from statictext within tabpage_main
integer x = 119
integer y = 68
integer width = 421
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
string text = "Carrier Code:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_carrier from singlelineedit within tabpage_main
integer x = 549
integer y = 60
integer width = 827
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
textcase textcase = upper!
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event modified;String lsCarrier, lsCarrierGroup
Long   ll_rows, ll_Pro_Rows

lsCarrier = This.Text


ll_rows = idw_main.Retrieve(gs_project,lsCarrier)       // Retrieving the entry datawindow
lsCarrierGroup = RightTrim(idw_main.GetItemString(ll_rows,'carrier_group' ))

If IsNull(lsCarrierGroup ) or lsCarrierGroup = '' Then
	lsCarrierGroup = lsCarrier
End if

IF ib_edit THEN /* Edit Mode */

	IF ll_rows > 0 THEN
		iw_window.Title = is_title + " - Carrier: " + lsCarrier
		ll_Pro_Rows = idw_pro_warehouse.Retrieve(gs_project,lsCarrierGroup )
//		ll_Pro_Rows = idw_pro_warehouse.Retrieve(gs_project,lsCarrier)
		idw_main.Show()
		idw_main.SetFocus()
		im_menu.m_file.m_save.Enable()
		im_menu.m_record.m_delete.Enable()
		This.DisplayOnly = True
		This.TabOrder = 0			
		If ll_pro_rows = 0 then
			idw_pro_warehouse.InsertRow(0)
			idw_pro_warehouse.SetITem(1,'wh_Code', 'ALL' )
			idw_pro_warehouse.SetItem(1,"project_id",gs_project )
			idw_pro_warehouse.SetItem(1,"carrier_group",Upper(lsCarrierGroup ) )
			//idw_pro_warehouse.SetItem(1,"carrier_code",lsCarrier )
			isCurrentCarrierGroup = ''
		Else
			isCurrentCarrierGroup = idw_pro_warehouse.GetItemString(idw_pro_warehouse.getrow(),'carrier_group' )
			
		end if
	ELSE
		
		MessageBox(is_title, "Carrier not found, please enter again!", Exclamation!)
		This.SetFocus()
		This.SelectText(1,Len(lsCarrier))
		
	END IF
			
ELSE /*New Mode */
	
	IF ll_rows > 0 THEN
		
		MessageBox(is_title, "Carrier already exist, please enter again", Exclamation!)
		This.SetFocus()
		This.SelectText(1,Len(lsCarrier))		
		
	ELSE
		
		idw_main.InsertRow(0)
		idw_main.SetItem(1,"project_id",gs_project)
		idw_main.SetItem(1,"carrier_code",lsCarrier)
		idw_main.Show()
		idw_main.SetFocus()
		im_menu.m_file.m_save.Enable()
		This.DisplayOnly = True
		This.TabOrder = 0			
		
	END IF
	
END IF


end event

type dw_project from u_dw_ancestor within tabpage_main
event itemchange pbm_dwnitemchange
integer x = 101
integer y = 168
integer width = 3109
integer height = 2000
boolean bringtotop = true
string dataobject = "d_maintenance_carrier"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;//TimA 09/08/15 Added in new carrier group.
//This is needed to group carrier codes into on pro number calculation if needed.

String lsCarrier,lsCarrierGroup, lsCarrierChanged, lsGetPrefixSufix
Long llRows,i, llGetValues, llChangedRow, llCountOfGroupsFound
Int liReplace
ib_changed = True
ib_UpdateProWarehouse = False
llGetValues = 0
lsGetPrefixSufix = ''
llChangedRow = idwc_carrier_Group.Getrow()
If Upper(dwo.name) = 'CARRIER_GROUP' then
	If Not Isnull(data) then
		ib_changed = True
		lsCarrierGroup = Upper(data )
		This.setitem( row, dwo.name,lsCarrierGroup )
		This.accepttext( )
		lsCarrierChanged = idwc_carrier_Group.GetItemString(llChangedRow,'project_id' )
		//Count how many carrier master records are associated to a group
		SELECT COUNT(*) Into :llCountOfGroupsFound FROM Carrier_Master
		WHERE Project_Id = :gs_Project
		AND Carrier_Group = :isCurrentCarrierGroup
		USING SQLCA;
		
		llRows = idw_pro_warehouse.rowcount( )	
		For i =1 to llRows
			lsGetPrefixSufix = Nz(idw_pro_warehouse.GetItemString(i,'pro_nbr_prefix' ),'' )
			lsGetPrefixSufix = lsGetPrefixSufix + Nz(idw_pro_warehouse.GetItemString(i,'pro_nbr_prefix' ),'' )
			llGetValues = llGetValues + Nz(idw_pro_warehouse.GetItemNumber(i,'pro_nbr_current_range_start' ), 0 )
			llGetValues = llGetValues + Nz(idw_pro_warehouse.GetItemNumber(i,'pro_nbr_current_range_end' ), 0 )
			llGetValues = llGetValues + Nz(idw_pro_warehouse.GetItemNumber(i,'pro_nbr_next_range_start' ), 0 )
			llGetValues = llGetValues + Nz(idw_pro_warehouse.GetItemNumber(i,'pro_nbr_next_range_end' ), 0 )
		Next
		i=0
		If lsGetPrefixSufix <> '' or llGetValues <> 0 Then
			liReplace = MessageBox(is_Title,'There are currently start and end ranges associated with this group.  This will delete these values if there are no other groups associated. ',StopSign!,YesNo!  )
			If liReplace = 2 Then //No
				Return 
			Else
				If llCountOfGroupsFound = 1 Then //This is to prevent deleting the row if it is found on another carrier master group
					If 	llRows = 1 Then //Just 1 record to change and there is now values.
						ib_UpdateProWarehouse = True
						idw_pro_warehouse.DeleteRow(0 )
					Else
						For i =1 to llRows
							ib_UpdateProWarehouse = True
							idw_pro_warehouse.DeleteRow(i )
						next
					End if
				End if
			End if
		Else
			If lsCarrierChanged = 'NEW' then //New group is being greated
				idw_pro_warehouse.SetItem(1,"carrier_group",RightTrim(lsCarrierGroup ))
				
			Else
				For i =1 to llRows
					ib_UpdateProWarehouse = True
					idw_pro_warehouse.DeleteRow(i )
				next
			End if		
		End if
	End if
End if
end event

event process_enter;If This.GetColumnName() <> "remark" Then
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If
end event

type cb_carrier_search from commandbutton within tabpage_search
integer x = 32
integer y = 140
integer width = 297
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
dw_search.TriggerEvent("ue_retrieve")
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_select from datawindow within tabpage_search
integer x = 448
integer y = 16
integer width = 2409
integer height = 112
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_maintenance_carrier_search"
boolean border = false
boolean livescroll = true
end type

event constructor;
g.of_check_label(this) 
end event

type dw_search from u_dw_ancestor within tabpage_search
string tag = "\Sortoption=Y"
integer x = 347
integer y = 140
integer width = 3067
integer height = 1388
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_maintenace_carrier_results"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;// Pasting the record to the main entry datawindow

IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	IF NOT ib_changed THEN
		isle_carrier.Text = This.GetItemString(row,"carrier_code")
		isle_carrier.TriggerEvent("modified")
		iw_window.Title = is_title + " - Carrier: " + isle_carrier.Text
	END IF
END IF
end event

event ue_retrieve;String	lsWhere

SetPointer(Hourglass!)

dw_select.AcceptText()

This.dbCancel() /*retrive as needed must cancel first*/
This.SetRedraw(False)
This.Reset()

//always tackon project,Tackon  Carrier name if present
lswhere = "Where carrier_master.project_id = '" + gs_project + "' " 

If not isnull(dw_select.GetItemString(1,"carrier_name")) Then
	lsWhere += " and carrier_master.carrier_Name like '%" + dw_select.GetItemString(1,"carrier_name") + "%' "
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

event constructor;call super::constructor;idw_current = this
end event

type cb_carrier_clear from commandbutton within tabpage_search
integer x = 32
integer y = 308
integer width = 297
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;
dw_select.Reset()
dw_search.Reset()
dw_select.InsertRow(0)
dw_select.SetFocus()
end event

event constructor;
g.of_check_label_button(this)
end event

type tabpage_defaults from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3520
integer height = 2176
long backcolor = 79741120
string text = "Defaults"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_warehouse from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3520
integer height = 2176
long backcolor = 79741120
string text = "Pro No"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_do_det_insert cb_do_det_insert
cb_do_det_delete cb_do_det_delete
dw_pro_warehouse dw_pro_warehouse
end type

on tabpage_warehouse.create
this.cb_do_det_insert=create cb_do_det_insert
this.cb_do_det_delete=create cb_do_det_delete
this.dw_pro_warehouse=create dw_pro_warehouse
this.Control[]={this.cb_do_det_insert,&
this.cb_do_det_delete,&
this.dw_pro_warehouse}
end on

on tabpage_warehouse.destroy
destroy(this.cb_do_det_insert)
destroy(this.cb_do_det_delete)
destroy(this.dw_pro_warehouse)
end on

type cb_do_det_insert from commandbutton within tabpage_warehouse
integer x = 23
integer y = 16
integer width = 402
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert Row"
end type

event clicked;Long ll_row,  ll_trial_line_Item_no, ll_found_row
String lsFromLoc

If idw_pro_warehouse.AcceptText() = -1 Then Return

ll_row = idw_pro_warehouse.InsertRow(0)
idw_pro_warehouse.SetItem(ll_row,"wh_Code",'ALL') //Default Value
idw_pro_warehouse.SetItem(ll_row,"project_id",gs_project)
//idw_pro_warehouse.SetItem(ll_row,"carrier_code",idw_project.getitemstring(1,'carrier_code'))
idw_pro_warehouse.SetItem(ll_row,"carrier_group",RightTrim(idw_project.getitemstring(1,'carrier_group')))
idw_pro_warehouse.SetItem(ll_row,'last_update',Today()) 
idw_pro_warehouse.SetItem(ll_row,'last_user',gs_userid)

ll_row = idw_pro_warehouse.GetRow()


end event

event constructor;
g.of_check_label_button(this)
end event

type cb_do_det_delete from commandbutton within tabpage_warehouse
integer x = 434
integer y = 16
integer width = 402
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Row"
end type

event clicked;Long ll_row

ll_row = idw_pro_warehouse.GetRow()

If ll_row > 0 Then
	ib_changed = True

	idw_pro_warehouse.DeleteRow(0 )
End If

end event

event constructor;
g.of_check_label_button(this)
end event

type dw_pro_warehouse from u_dw_ancestor within tabpage_warehouse
integer x = 41
integer y = 188
integer width = 3383
integer height = 1968
integer taborder = 20
string dataobject = "d_maintenance_carrier_pro_warehouse"
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;String ls_wh_code
Long llRowCount

ib_changed = True
ib_UpdateProWarehouse = True
Choose Case Upper(dwo.Name)

CASE 'WH_CODE'	
			
			llRowCount = idw_pro_warehouse.Rowcount()
			//ls_wh_code = data
			idw_pro_warehouse.setitem(row,'WH_CODE',data)

Case 'pro_algorithm'
		
			llRowCount = idw_pro_warehouse.Rowcount()
			//ls_wh_code = data
			idw_pro_warehouse.setitem(row,'pro_algorithm',data)

End choose
idw_pro_warehouse.SetItem(row,'last_update',Today()) 
idw_pro_warehouse.SetItem(row,'last_user',gs_userid)
idw_pro_warehouse.SetItem(row,"project_id",gs_project)

end event

