HA$PBExportHeader$w_sn_change_parent.srw
$PBExportComments$-Stock Adjustment Program
forward
global type w_sn_change_parent from w_std_simple_list
end type
type dw_select from u_dw_ancestor within w_sn_change_parent
end type
type cb_search from commandbutton within w_sn_change_parent
end type
type cb_1 from commandbutton within w_sn_change_parent
end type
type cb_add from commandbutton within w_sn_change_parent
end type
type cb_delete from commandbutton within w_sn_change_parent
end type
type st_delete_info from statictext within w_sn_change_parent
end type
type cb_test from commandbutton within w_sn_change_parent
end type
type cb_remove_sku from commandbutton within w_sn_change_parent
end type
end forward

global type w_sn_change_parent from w_std_simple_list
integer width = 4123
integer height = 2100
string title = "Serial Number Changes"
event ue_unlock ( )
event mykeypress pbm_syscommand
event mysyskeyup pbm_syskeyup
event mysyscommand pbm_syscommand
dw_select dw_select
cb_search cb_search
cb_1 cb_1
cb_add cb_add
cb_delete cb_delete
st_delete_info st_delete_info
cb_test cb_test
cb_remove_sku cb_remove_sku
end type
global w_sn_change_parent w_sn_change_parent

type prototypes

end prototypes

type variables
w_sn_change_parent iw_window

string i_sql,is_origSQL,isUpdateSql[]
string is_sku

Boolean    ib_AltPressed
string is_PassedString = 'no change'

Boolean ib_is_pandora_single_project_location_rule_on

end variables

forward prototypes
public function boolean of_getsubmenu (menu am_menu_root, string as_menu_name, ref menu am_found)
end prototypes

event ue_unlock();// GailM - 03/26/2014 - Remove restriction for Operator access to window.
//If f_check_access(is_process,"D") = 0 Then Return


	//If gs_role = '1' or gs_role = '2' Then
		
	//	MessageBox("Security Check", "You have no access to this function!",StopSign!)
	//	return 
		
	//End If


//Toggle remove sku SNs off/on
IF gs_project = 'PANDORA' THEN
	If gs_role = '1' or gs_role = '2' Then
			cb_remove_sku.enabled = FALSE
	else
		IF cb_remove_sku.enabled = false THEN
			cb_remove_sku.enabled = TRUE
		ELSE
			cb_remove_sku.enabled = FALSE
		END IF
	end if
END IF

end event

event mysyskeyup;If key = KeyAlt! Then
   ib_AltPressed = True
Else
   ib_AltPressed = False
End If

end event

event mysyscommand;/*
IF message.wordparm = 61696 THEN //F10
		is_PassedString = string(message.wordparm)

        message.processed = TRUE
        message.returnvalue = 1
END IF

CONSTANT unsignedlong SC_KEYMENU = 61696

IF commandType = SC_KEYMENU THEN
	this.st_1.text = 'processed'
        message.processed = TRUE
        message.returnvalue = 1
ELSE
	this.st_1.text = 'not SC_KEYMENU'
        message.processed = TRUE
        message.returnvalue = 1
		
END IF
*/
/*
IF message.wordparm = 61488 THEN // Maximize Button
        message.processed = TRUE
        message.returnvalue = 1
END IF
IF message.wordparm = 61472 THEN // Minimize button
        message.processed = TRUE
        message.returnvalue = 1
END IF
IF message.wordparm = 61536 THEN // Close the Window
        message.processed = TRUE
        message.returnvalue = 1
END IF
 */



end event

public function boolean of_getsubmenu (menu am_menu_root, string as_menu_name, ref menu am_found);//////////////////////////////////////////////////////////////////////////////
//
// Function: of_GetSubMenu
//
// Access: Public
//
// Description: Find and return a menu reference in a reference variable to the menu
//              which name's matches the passed menu name string.  Start looking at
//              the passed menu, and if it is not found, look at its submenus.
//
//              This is a recursive function
//
// Arguments: menu   am_menu_root
//            string as_menu_name
//            menu   am_found       ref
//
// Returns:   boolean lb_found
//
//////////////////////////////////////////////////////////////////////////////
 
boolean         lb_found = FALSE
integer         li_ndx, li_sz
string          ls_root_menu_name
 
ls_root_menu_name = am_menu_root.ClassName()
as_menu_name      = Trim(Lower(as_menu_name))
if ls_root_menu_name = as_menu_name then
   am_found = am_menu_root
   lb_found = TRUE
end if
 
li_ndx = 0
li_sz = UpperBound(am_menu_root.item)
do while li_ndx < li_sz and NOT lb_found
   li_ndx ++
   lb_found = of_GetSubMenu(am_menu_root.item[li_ndx], as_menu_name, am_found)
loop
 
Return lb_found
end function

on w_sn_change_parent.create
int iCurrent
call super::create
this.dw_select=create dw_select
this.cb_search=create cb_search
this.cb_1=create cb_1
this.cb_add=create cb_add
this.cb_delete=create cb_delete
this.st_delete_info=create st_delete_info
this.cb_test=create cb_test
this.cb_remove_sku=create cb_remove_sku
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_select
this.Control[iCurrent+2]=this.cb_search
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_add
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.st_delete_info
this.Control[iCurrent+7]=this.cb_test
this.Control[iCurrent+8]=this.cb_remove_sku
end on

on w_sn_change_parent.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_select)
destroy(this.cb_search)
destroy(this.cb_1)
destroy(this.cb_add)
destroy(this.cb_delete)
destroy(this.st_delete_info)
destroy(this.cb_test)
destroy(this.cb_remove_sku)
end on

event ue_save;String ls_serial_no, ls_prev_serial_no, ls_old_serial_no, ls_ro_no, ls_sku, ls_supp_code, ls_wh_Code , ls_inventory_type, ls_po_no, ls_sql_error
String ls_SqlErrMsg, lsPrevSku, lsPndser, lsTmp
String ls_component_ind  // 01/03/2011 ujh: S/N_P
Long ll_rowcnt, ll_row,  ll_owner_id, ll_sql_code, li_sentZ
Boolean ib_Error, lb_batch_added
DateTime ldtToday
// Purpose : To update the datawindow

ib_error = False
lb_batch_added = False

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
	ls_serial_no = dw_list.GetItemString(ll_row,"serial_no")
	IF ls_serial_no = ls_prev_serial_no THEN
		MessageBox(is_title, "Duplicate record found, please check!")
		f_setfocus(dw_list, ll_row, "serial_no")
		Return 0
	ELSE
		ls_prev_serial_no = ls_serial_no
	END IF
Next

// LTK 20151222  Pandora #1002 - For any modified rows, ensure location is set
if gs_project = 'PANDORA' and ib_is_pandora_single_project_location_rule_on then
	for ll_row = 1 to dw_list.RowCount()
		if dw_list.getitemstatus( ll_row, 0, Primary! ) = New! or dw_list.getitemstatus( ll_row, 0, Primary! ) = NewModified! or dw_list.getitemstatus( ll_row, 0, Primary! ) = DataModified! then 
			if Trim( dw_list.GetItemString( ll_row, 'L_Code' ) ) = '' or IsNull( dw_list.GetItemString( ll_row, 'L_Code' ) ) then
				MessageBox(is_title, "Row has been modified, Location must be entered.")
				f_setfocus(dw_list, ll_row, "L_Code")
				Return 0
			end if
		end if
	next
end if
		
// For each changed serial look for SOCs that need to be changed.
// For each changed serial send a 4C1 to Pandora

// After validation updating the datawindow
Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'

// For each changed serial number change the current Putaway.
For ll_row = 1 to ll_rowcnt 
	ls_serial_no = dw_list.GetItemString(ll_row,"serial_no")
	ls_SKU = dw_list.GetItemString(ll_row,"sku")
	ls_old_serial_no = dw_list.GetItemString(ll_row,"original_serial_number")
	ls_wh_code = dw_list.GetItemString(ll_row,"wh_code")
	ll_owner_id = dw_list.GetItemNumber(ll_row,"owner_id")
	ls_component_ind = dw_list.GetItemString(ll_row,"component_ind")  // 01/03/2011 ujh: S/N_P:

	If ls_serial_no <> ls_old_serial_no Then  	//This condition only check when serial change.	
					//Jxlim 03/30/2011 If SKU is Pandora serial; (Pnd Serial#) Item_master.User_field18 is 'Y' then send serial# otherwise.
					//Step 1. Checking Pandora Serial		 	
					If 	 ls_Sku <> lsPrevSku Then
						//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...modify code to use gs_project instead of Pandora
						 Select     User_field18 into :lsPndSer
						 From       Item_Master
//						 where     project_id = 'PANDORA' and sku = :ls_Sku
						 where     project_id = :gs_project and sku = :ls_Sku
						 Using SQLCA;       
					End If
					lsPrevSku = ls_Sku
				     //Jxim 03/30/2011 End of code
					  
		//Select latest Ro_No with this serial number on it
		
		//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...modify code to use gs_project instead of Pandora
		SELECT Top 1 dbo.Receive_Master.RO_No, dbo.Receive_Putaway.inventory_type, dbo.Receive_putaway.po_no, dbo.Receive_Putaway.Supp_Code
  		INTO :ls_ro_no, :ls_inventory_type, :ls_po_no, :ls_supp_code
		FROM Receive_Master WITH (NOLOCK),
				Receive_Putaway WITH (NOLOCK)
		WHERE 	Receive_Putaway.Serial_No = :ls_old_serial_no and
				Receive_Master.RO_NO      			= Receive_Putaway.RO_NO and
//				Receive_Master.Project_ID 			= 'PANDORA'
				Receive_Master.Project_ID 			= :gs_project
		ORDER BY Receive_Master.RO_No DESC;
		
//		//Jxlim 04/11/2011 No longer need to update Receie_putaway since now we have serial_number_inventory table to manage inventory full cycle.
//		If not isnull(ls_ro_no) and ls_ro_no <> '' Then
//			UPDATE dbo.Receive_Putaway  
//			SET Serial_No = :ls_serial_no  
// 			WHERE ( dbo.Receive_Putaway.RO_No = :ls_Ro_No ) AND  
//			( dbo.Receive_Putaway.Serial_No = :ls_old_serial_no )   
//			USING SQLCA;
//		End If

		IF SQLCA.SQLCode = -1 THEN 
//      		MessageBox("SQL error", SQLCA.SQLErrText)  //09/10/2010 ujh  Removing message inside a Transaction
			ls_SqlErrMsg = SQLCA.SQLErrText  //09/10/2010 ujh  Removing message inside a Transaction
			ib_error = TRUE
			continue  //09/10/2010 ujh  Removing message inside a Transaction
		End If
		
		//Jxlim 03/31/2011 When SKU is not Pandora serial, set transation_send to 'Z'
		//Step 2 Insert into the item_serial_change_history
		 If IsNull(lsPndSer) or Upper(Trim(lsPndSer)) <> 'Y' Then				
			li_sentZ = 1
		End If

		// LTK 20160205  Always send 4C1s for Pandora so set below flag so that Item_Serial_Change_History.Transaction_sent will be populated with NULL
		if gs_project = 'PANDORA' then
			li_sentZ = 0			
		end if

		//Save Changes to a history table to generate the 4c1 
		/* 11/30/2010 ujh: Adding  userid and specifically NOT populating transaction_sent that should have been part 
				of 11/08/2010 ujh: (SNRE)  to put userid in table */
		ldtToday = f_getLocalWorldTime( ls_Wh_Code ) 
						Insert Into Item_Serial_Change_History (project_ID, Wh_Code, Owner_ID, 
								Complete_Date, Sku, Supp_Code,Po_No, 
								From_Serial_No,To_Serial_No,  Transaction_sent, update_user)
						Values(:gs_Project, :ls_Wh_Code, :ll_Owner_id, 
								:ldtToday, :ls_SKU, :ls_supp_code, :ls_Po_No, 
								:ls_old_Serial_No, :ls_Serial_No,  			
								Case (:li_sentZ)  When 1 Then 'Z'  // Step 3 Jxlim 03/31/2011 When SKU is not Pandora serial, set transation_send to 'Z'
								Else Null End,  // Step 3 Jxlim 03/31/2011 When SKU is Pandora serial, set transation_send to ''
								:gs_userid ) 
						Using SQLCA;
						

		IF SQLCA.SQLCode = -1 THEN 
//      		MessageBox("SQL error", SQLCA.SQLErrText)   //09/10/2010 ujh  Removing message inside a Transaction
			ls_SqlErrMsg = SQLCA.SQLErrText  //09/10/2010 ujh  Removing message inside a Transaction
			ib_error = TRUE
			continue  //09/10/2010 ujh  Removing message inside a Transaction
		End If

		//Add a 4C1 Owner Change to Batch Transaction (only once)
		
		If lb_batch_added = False and ls_component_ind <> '*' Then  // 01/03/2011 ujh: S/N_P  no 4C1 for components
			Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
			Values(:gs_Project, 'SN', '1', 'N', :ldtToday, '')
			Using SQLCA;
			lb_batch_added = True

			IF SQLCA.SQLCode = -1 THEN 
//     	 		MessageBox("SQL error", SQLCA.SQLErrText)  //09/10/2010 ujh  Removing message inside a Transaction
				ls_SqlErrMsg = SQLCA.SQLErrText  //09/10/2010 ujh  Removing message inside a Transaction
				ib_error = TRUE
				continue
			End If

		End If // batch trans 

		//Select SOC with this serial number on it
		
		// ET3 2012-06-14: Implement generic test
		IF g.ibSNchainofcustody THEN

//		//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...split code in this case.
//		IF Upper(gs_project) = 'PANDORA' THEN
//			UPDATE dbo.Alternate_Serial_Capture  
//			SET Serial_no_Parent = :ls_serial_no  
//			WHERE ( dbo.Alternate_Serial_Capture.Serial_no_Parent = :ls_old_serial_no ) AND  
//				( dbo.Alternate_Serial_Capture.TO_NO like 'PANDORA%' ) AND  
//				( dbo.Alternate_Serial_Capture.SKU_Parent = :ls_sku )  
//			USING SQLCA ;
//		ELSEIF Upper(gs_project) = 'BLUECOAT' THEN
//			UPDATE dbo.Alternate_Serial_Capture  
//			SET Serial_no_Parent = :ls_serial_no  
//			WHERE ( dbo.Alternate_Serial_Capture.Serial_no_Parent = :ls_old_serial_no ) AND  
//				( dbo.Alternate_Serial_Capture.TO_NO like 'BLUECOAT%' ) AND  
//				( dbo.Alternate_Serial_Capture.SKU_Parent = :ls_sku )  
//			USING SQLCA ;
//		END IF

			lsTmp = "'" + UPPER(gs_project) + "%'"
			
			UPDATE dbo.Alternate_Serial_Capture  
			SET Serial_no_Parent = :ls_serial_no  
			WHERE ( dbo.Alternate_Serial_Capture.Serial_no_Parent = :ls_old_serial_no ) AND  
				( dbo.Alternate_Serial_Capture.TO_NO like :lsTmp ) AND  
				( dbo.Alternate_Serial_Capture.SKU_Parent = :ls_sku )  
			USING SQLCA ;

		END IF

		IF SQLCA.SQLCode = -1 THEN 
//      		MessageBox("SQL error", SQLCA.SQLErrText)
			ls_SqlErrMsg = SQLCA.SQLErrText  //09/10/2010 ujh  Removing message inside a Transaction
			ib_error = TRUE
			continue
		End If

	End If

Next


If	ib_error = False Then
	IF dw_list.Update(FALSE, FALSE) > 0 THEN
		Execute Immediate "COMMIT" using SQLCA;
		IF Sqlca.SqlCode = 0 THEN
	//		dw_list.ResetUpdate()
			dw_list.Reset()
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
ELSE	
	Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox(is_title,"Error while saving record! " + ls_SqlErrMsg) //09/10/2010 ujh  Removing message to outside Transaction
	Return -1
End If


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
/*
menu lm_edit
boolean lb_found

lb_found = of_GetSubMenu(this.menuid, "m_edit", lm_edit)

if lb_found then
	lm_edit.item[3].visible = true
	lm_edit.item[3].enabled = true
else
	messagebox("Edit Menu Item","The menu was not found:")
end if
*/

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

is_origSQL = dw_list.GetSQLSelect()

// LTK 20151221  Pandora #1002  Make location code and project visible for Pandora
if gs_project = 'PANDORA' then

	ib_is_pandora_single_project_location_rule_on = ( f_retrieve_parm("PANDORA", "FLAG", "SOC_SERIAL_GPN_TRACK_ON") = 'Y' )

	if ib_is_pandora_single_project_location_rule_on then
		dw_list.Object.L_Code.Visible = TRUE
		//dw_list.Object.L_Code.Edit.Required = TRUE
		dw_list.Object.Po_No.Visible = TRUE
		dw_select.Object.Po_No.Visible = TRUE
		dw_select.Object.T_Po_No.Visible = TRUE
	end if
	
end if


This.TriggerEvent('ue_retrieve')

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/* 09/30/2010 ujh:  Access to this window now governed by user rights on the menu, not access level.  
	Any user with access to the window has full access to all functionality now. There for the message
	given by st_delet_info is visible all the time.*/

// 08/23/2010 ujhall: 01 of ?? Full Circle Fix: Serial_number_inventory Maintenance
// Make add and delete buttons visible based on user level.

//long ll_access_level
//
//Select Access_level 
//into :ll_access_level
//From UserTable
//where userid = :gs_userId;
//
//if ll_access_level <= 1 then
//	cb_add.visible = true
////	cb_delete.visible = true
	st_delete_info.visible = true
//else
//	cb_add.visible = false
////	cb_delete.visible = false
//st_delete_info.visible = false
//end if
///////////////////////////////////////////////////////////////////////////////////////////////////////////
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
Str_parms	lStrParms
lStrParms = Message.PowerObjectParm

// Intitialize
This.X = 0
This.Y = 0
//is_process = Message.StringParm
is_process = lStrParms.String_Arg[1]
is_title = This.Title
end event

event resize;call super::resize;//dw_list.Resize(workspacewidth() - 20,workspaceHeight()-130)
//dw_list.Resize(workspacewidth() - 20,workspaceHeight()-400)  // 01/03/2011 ujh: S/N:  allow datawindow to fit on page
dw_list.Resize( newwidth - 70, newheight - 524 )  	// LTK 20151222

end event

event ue_delete;
//Ancestor being overridden

//Long ll_row
//
//IF f_check_access( is_process,"D") = 0 THEN Return
//
////Only super users can delete existing rows...
//If gs_role <> "0" and (dw_list.GetItemStatus(dw_list.getRow(),0,Primary!) <> New! and dw_list.GetItemStatus(dw_list.getRow(),0,Primary!) <> NewModified!) Then
//	Messagebox(is_title,"You can not delete existing rows",StopSign!)
//	Return
//End If
//
//IF MessageBox(is_title,"Are you sure you want to delete this record",Question!,OkCancel!,2) = 1 THEN
//	dw_list.DeleteRow(0)
//	ib_changed = True
//END IF
end event

type dw_list from w_std_simple_list`dw_list within w_sn_change_parent
integer x = 27
integer y = 496
integer width = 3977
integer height = 1380
string dataobject = "d_sn_change_for_sn_inventory"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_list::process_enter;IF This.GetColumnName() = "serial_no" THEN
		Send(Handle(This),256,9,Long(0,0))
		Return 1		
End If

end event

event dw_list::itemerror;call super::itemerror;
return 2	
end event

event dw_list::itemchanged;//Ancestor being overridden
String ls_sku, ls_serial_no, ls_dup_serial_no, ls_orig_serial_no
String ls_find_string
long ll_pos_return //01/03/2011 ujh: S/N_P:
String ls_uf18, ls_owner_code, ls_oracle_integrated	// LTK 20151230  Pandora #1002
datetime ldtToday //TAM 2016/02/24

Choose Case Upper(dwo.Name)
	/* 01/03/2011 ujh: S/N_P:  Create a blank New_serial_number column and preserve code for current 
		by moving the entered datat to Serial_no as soon as it is changed.*/
	// CASE 'SERIAL_NO'
	Case 'NEW_SERIAL_NUMBER'
		ls_sku = This.GetITemString(row,'sku')
		ls_serial_no = upper(trim(data))
				
		ls_orig_serial_no = This.GetITemString(row,'original_serial_number')
		ls_find_string = "Upper(SERIAL_NO) = '" + upper(data) + "' And Upper(SKU) = '" + upper(ls_sku) +  "'"
/////////////////////////////////////////Begin////////////////////////////////////////////////////////////////////////////////////////////			
		//01/03/2011 ujh: S/N_P: No blank, No Null Serial Nos AND no space in the serial_no string.  Must be all caps
		ll_pos_return = pos(Trim(data), ' ', 1)  // check for embedded spaces
		long ujhtest
		ujhtest = len(data)
		// Error if blank or embedded spaces
		If Not len(trim(data)) > 0 or ll_pos_return <> 0  then
			messagebox('SN Validation', 'Serial Numbers must not be null, blank or contain spaces')
			This.SetFocus()
			This.SelectText(1, Len(this.GetText()))
			return 1
		end if
//////////////01/03/2011 ujh: S/N_ P/////END////////////////////////////////////////////////////////////////////////////////////////////	

		BOOLEAN lb_SN_cleaned = FALSE
		LONG    ll_Rtn = 0

		// ET3 - 2012-07-05 Pandora 447 - cleanup SN's by removing leading/trailing '.' and '-'
		IF UPPER(gs_project) = 'PANDORA' THEN
					
			If len(ls_serial_no) > 1 Then
				// strip extraneous Trailing chars
				DO WHILE MATCH( ls_serial_no, "[-\.]$" )
					ls_serial_no = MID(ls_serial_no, 1, len(ls_serial_no) - 1 )
					lb_SN_cleaned = TRUE
				LOOP
				
				// strip extraneous Leading chars
				DO WHILE MATCH( ls_serial_no, "^[-\.]")
					ls_serial_no = MID(ls_serial_no, 2, len(ls_serial_no) - 1 )
					lb_SN_cleaned = TRUE
				LOOP
				
			End If
			
		END IF  // Pandora
		
		/*01/03/2011 ujh: S/N_P:  Change to serach for sku/serial_no combination not just serial_no */
		If this.Find(ls_find_string,1, this.rowCount()) > 0 then
			messagebox(is_title,'This SKU/Serial Number combination has already been used',Stopsign!)
//			This.SetItem(row, 'Serial_no', ls_orig_serial_no)  // blank out the scanned data
			This.SetItem(row, 'New_Serial_number', "")  // blank out the scanned data (01/03/2011 ujh:
			Return 1
		End If

		// LTK 20160401  Serial number mask validation
		if gs_project = 'PANDORA' then
			String ls_return
			n_warehouse ln_nwarehouse
			ln_nwarehouse = CREATE n_warehouse
	
			ls_return = ln_nwarehouse.of_validate_serial_format( ls_SKU, data, 'PANDORA' )
			DESTROY ln_nwarehouse
			if ls_return <> "" then
				Messagebox( is_title,ls_return )
				This.SetItem(row, 'new_serial_number', '')  // blank out the scanned data
				//this.SelectText(1,1)
				return 1
			end if
		end if
			
	// 01/03/2011 ujh: S/N_P: 
		This.SetItem(row, 'Serial_no', ls_serial_no) 
	// 7/21/2010 TAM: Validate Serial Number DOesn't already exist.
	
		//BCR 15-DEC-2011: Treat Bluecoat same as Pandora
//		IF upper(gs_project) = 'PANDORA' OR  upper(gs_project) = 'BLUECOAT' Then
		// ET3 2012-06-14: Implement generic test
		IF g.ibSNchainofcustody THEN

//			ls_sku = This.GetITemString(row,'sku')
//			ls_serial_no = data
//			ls_orig_serial_no = This.GetITemString(row,'original_serial_number')
//			
			SELECT  Serial_No
			INTO :ls_dup_serial_no
			FROM Serial_Number_Inventory  
			WHERE ( Serial_No = :ls_serial_no ) AND (project_id =  :gs_project)  AND (Sku = :ls_Sku)				
			USING SQLCA;


			// Serial number exists 
			If SQLCA.SQLCode = 0 THEN 

				Messagebox(is_title," Serial Number " + ls_serial_no + " already exists in SIMS!   Please verify serial number was entered correctly and if so please contact your Site Manager/Supervisor determine what needs to be corrected.")
				This.SetItem(row, 'Serial_no', ls_orig_serial_no)  //reset updatable column
				return 1

			End If //Serial Exist
	
			ib_changed = true
		End if // checking if the project is Pandora or Bluecoat or has the SNChainOfCustody flag
		
		Case 'L_CODE'
			
			// LTK 20151221  Pandora #1002 - The following block was copied from w_ro and slightly modified
			// NOTE: if implementation flag (ib_is_pandora_single_project_location_rule_on) is not turned on, L_Code is not visible
			if gs_project = 'PANDORA' then

				String lsWarehouse, lsProject, ls_LocType, lsInvTyp, lsSku, ls_serial_ind, ls_po_no, ls_find, ls_empty_str
				Long llOwnerID, ll_found_row

				if isnull(data) or Trim( data ) = '' then Return
				
				lsWarehouse = this.GetItemString(row, "wh_code")

				SELECT project_reserved, l_type
				INTO :lsProject, :ls_LocType
				FROM	location
				WHERE wh_code = :lsWarehouse 
				AND l_code = :data
				USING SQLCA;
				if sqlca.sqlcode = 100 then
					MessageBox(is_title,"Location not found in warehouse: " + String( nz(lsWarehouse, ls_empty_str) ) + "~rPlease enter a valid location.",StopSign!)
					f_setFocus( dw_list, row, 'L_Code' )
					Return 1
				elseif sqlca.sqlcode = 0 Then
					//Check for project being reserved for a specific project
					If isnull(lsProject) or lsProject = '' Then
					Else
						If lsProject <> gs_project Then
							MessageBox(is_title,"This Location is reserved by another project!",StopSign!)
							Return 1
						End If
					End If
					//TimA 02/12/14
					//Pandora #698 New MIX OWNER location type 6 to save multiple owners in one location
					//if gs_Project = 'PANDORA' and ( ls_LocType <> '9' and  ls_LocType <> '6' ) then
					// LTK 20151214  Added the IsNull() check so that nulls would drop into the "if" condition
					if gs_Project = 'PANDORA' and ( IsNull( ls_LocType ) or ( ls_LocType <> '9' and  ls_LocType <> '6' ) ) then
						// dts - 2010-08-19, allowing multiple owners for cross-dock locations (where l_type = '9')
						/* NOTE!!! 
						What if a Pick is generated (emptying location of certain owner/inv_typ), 
						then a Put-away succeeds (because material of different owner has been picked)
						then the pick is un-done, placing the inventory back in content???  */
		
						//check that location is either empty or contains only material of like Owner and Inventory Type
						llOwnerID = this.getItemNumber(row, "owner_id", primary!, true)
						lsInvTyp = this.getItemString(row, "inventory_type", primary!, true)
						Select max(sku) into :lsSKU
						From	content
						Where project_id = 'PANDORA'
						and wh_code = :lsWarehouse and l_code = :data
						and (owner_id <> :llOwnerID or Inventory_Type <> :lsInvTyp)
						Using SQLCA;
						
						If isnull(lsSKU) or lsSKU = '' Then
							//nothing in selected location that is a different Owner/InvType
						Else
							messagebox(is_title, "This Location already has material of a different Owner or Inventory Type!",StopSign!)
							Return 1
						End If					
		
						// LTK 20151215  Pandora #1002  SOC and GPN serial tracked inventory segregation by project
						if f_retrieve_parm("PANDORA", "FLAG", "SOC_SERIAL_GPN_TRACK_ON") = 'Y' then
							ls_sku = Upper( Trim( this.GetItemString( row, 'sku' ) ))
							//ls_serial_ind = Upper( Trim( this.GetItemString( row, 'Serialized_Ind' ) ))
							ls_po_no = Upper( Trim( this.GetItemString( row, 'Po_No' ) ))

							// Retrieve Serialized Ind as it's not contained in the serial table
							SELECT serialized_ind, user_field18
							INTO :ls_serial_ind, :ls_uf18
							FROM Item_Master	
							WHERE Project_Id = 'PANDORA'
							AND SKU = :ls_sku
							AND Supp_Code = 'PANDORA'
							USING SQLCA;

							if ls_serial_ind = 'B' or ls_serial_ind = 'O' or ls_serial_ind = 'Y' then

								// LTK 20151229  Added check that customer is Oracle Integrated
								ls_owner_code = String( this.Object.Owner_Cd[ row ] )

								if NOT IsNull( ls_owner_code ) then		// shouldn't be null but let's check
			
									SELECT user_field5
									INTO :ls_oracle_integrated
									FROM Customer
									WHERE Project_ID = :gs_project
									AND Cust_Code = :ls_owner_code
									USING SQLCA;

									if Upper( Trim( ls_oracle_integrated )) = 'Y' then

										// Check the PND Serial indicator to determine if this rule is exercised
										if Upper( Trim( ls_uf18 )) = 'N' then
											// Skip this rule
										else

											SELECT MAX(sku) 
											INTO :lsSKU
											FROM Content
											WHERE  project_id = :gs_project
											AND wh_code = :lsWarehouse
											AND l_code = :data
											AND sku = :ls_sku
											AND po_no <> :ls_po_no
											Using SQLCA;
					
											if Len( lsSKU ) > 0 then
												MessageBox( is_title, "This GPN is serialized and the Location entered already contains inventory for this GPN with a different Project!", StopSign! )
												Return 1
											end if
											
											// LTK 20151215  Pandora #1002  SOC and GPN serial tracked inventory segregation by project
											ls_find = "sku = '" + ls_sku + "' and l_code = '" + data + "' and owner_id = " + String( llOwnerID ) + " and po_no <> '" + ls_po_no + "'"
											ll_found_row = this.Find( ls_find, 1, this.RowCount() + 1 )
											if ll_found_row > 0 then
												MessageBox( is_title, "This GPN is serialized and the Location entered already contains inventory for this GPN with a different Project!", StopSign! )
												Return 1
											end if
										end if
									end if		
								end if
							end if
						end if
					end if
				end if
			end if

	End Choose
	
IF lb_SN_cleaned THEN
	ll_Rtn = 2
	this.setitem( row, dwo.name, ls_serial_no )
	ib_changed = true
ELSE
	ll_Rtn = 0

END IF

//TAM 2016/02/24 - If Row is changed then update the last Update data.
IF ib_changed THEN
	ldtToday = f_getLocalWorldTime( g.getCurrentWarehouse(  ) ) 
	this.setitem( row,'update_date', ldtToday )
	this.setitem( row,'update_user', gs_userid )
End If

RETURN ll_Rtn

	
	
	

end event

event dw_list::clicked;call super::clicked;//If row is clicked then highlight the row

This.SetFocus()

IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF

Parent.SetRedraw(TRUE)
end event

event dw_list::doubleclicked;call super::doubleclicked;// 08/23/2010 ujhall: 01 of ?? Full Circle Fix: Serial_number_inventory Maintenance
// 06/10/2013 GailM: Pandora Issue #608 - License Plate Project
string  ls_serial_no,  ls_SKU, ls_wh_code,ls_owner_cd,ls_carton_id
string ls_Component_ind  //01/03/2011 ujh: S/N_P;
long ll_Component_no, ll_FoundChild  //01/03/2011 ujh: S/N_P;
long ll_row, il_indx, ll_access_level
Str_parms lstr_parms   // 11/08/2010 ujh: (SNRE)  Need to pass more values for the Serial table report
String ls_po_no, ls_l_code	// LTK 20160205

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/* 09/30/2010 ujh:  Access to this window now governed by user rights on the menu, not access level.  
	Any user with access to the window has full access to all functionality now.*/
//		// user must be ADMIN or greater to access this functionality.
//		Select Access_level 
//		into :ll_access_level
//		From UserTable
//		where userid = :gs_userId;
//		
//		if not  ll_access_level <= 1 then
//			return
//		end if
////////////////////////////////////////////////////////////////////////////////

// For user who are ADMINs or greater
if not  isvalid(w_serial_no_add_delete) then
	lstr_parms.String_arg[1] = 'DELETE'   // 11/08/2010 ujh: (SNRE) change to use a str_parm
	OpenWithParm(w_serial_no_add_delete, lstr_parms)   // 11/08/2010 ujh: (SNRE) change to use a str_parm
	cb_Add.enabled = false
//	cb_delete.enabled = false
end if

//if  upper(w_serial_no_add_delete.st_header.text) <> 'SERIAL_NUMBER_INVENTORY DELETE' then
if  upper(w_serial_no_add_delete.is_current_window) <> 'DELETE' then
//	Messagebox('Open Delete Error', 'Please touch Delete button to open the delete window')
	Messagebox('Open Delete Error', 'Please close the ' + w_serial_no_add_delete.is_current_window &
			+ ' window before opening the delete window')  // 01/03/2011 ujh: S/N_P: change to define what is actually open
	return
end if

if not w_serial_no_add_delete.ib_rows_valid then
	messagebox('Insert Row Error', 'Rows cannot be inserted until previous rows have been validated')
	return
end if


ls_wh_code = this.GetItemString(row,'wh_code')	
ls_owner_cd =  this.GetItemString(row,'owner_cd')	
ls_sku =  this.GetItemString(row,'sku')	
ls_carton_id = this.GetItemString(row,'carton_id')
ls_serial_no =  this.GetItemString(row,'serial_no')	
ls_Component_ind =  this.GetItemString(row,'component_ind')	  //01/03/2011 ujh: S/N_P;
ll_Component_no =  this.GetItemNumber(row,'Component_no')	 //01/03/2011 ujh: S/N_P;

ls_po_no = this.GetItemString(row,'po_no')	// LTK 20160205
ls_l_code = this.GetItemString(row,'l_code')	// LTK 20160205

//03-Sep-2014 :Madhu- Added code to don't delete the SN, if it is associated with any open orders -START
string lsInvoiceNo,lsDoNo,lsOrdStatus
long llIdNo,llcount

select DM.Invoice_No,DM.DO_No,DPD.Id_No,DM.Ord_Status,count(*) into :lsInvoiceNo,:lsDoNo,:llIdNo,:lsOrdStatus,:llcount
from delivery_picking_Detail DPD with (nolock) LEFT OUTER JOIN  Delivery_Master DM  with (nolock) ON DPD.DO_No =DM.DO_No
LEFT OUTER JOIN  Delivery_Serial_Detail DSD  with (nolock) ON DPD.Id_No =DSD.Id_No
and DPD.SKU =DSD.SKU_Substitute
where DSD.SKU_Substitute =:ls_sku
and DSD.Serial_No =:ls_serial_no
group by DM.Invoice_No,DM.DO_No,DPD.Id_No,DM.Ord_Status
using sqlca;

IF llcount >0 and (lsOrdStatus = 'I' or lsOrdStatus = 'A' or lsOrdStatus ='P' or lsOrdStatus ='R') Then
	MessageBox("Serial No Error","The following Serial No # " + ls_serial_no + " has been associated with Delivery Order No # " + lsInvoiceNo + " and can't be deleted")
	return 
END IF
//03-Sep-2014 :Madhu- Added code to don't delete the SN, if it is associated with any open orders -END

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/* 01/03/2011 ujh: S/N_Pd:  Don't delete parents until all children have been deleted */
If upper(ls_component_ind) = 'Y' then
	Select Component_no into :ll_FoundChild 
	From Serial_number_inventory
	where Component_ind = '*'
	and Component_no = :ll_component_no;

	If ll_component_no = ll_FoundChild then
		Messagebox('Serial No Error', 'All Children must be deleted before their parent is deleted')
		return
	end if
end if  // end check for parents to determine if they can be deleted.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			// Determin whether the serial no already in this list
			For il_indx = 1 to w_serial_no_add_delete.dw_serial_no_add_delete.RowCount()
				if w_serial_no_add_delete.dw_serial_no_add_delete.GetItemString(il_indx, 'Serial_no') = ls_serial_no then
					MessageBox('Serial No Error', 'This serial number already used in row '+ string(il_indx,'0'))
					w_serial_no_add_delete.ib_rows_valid = true
					return 
				end if
				
			next

w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("wh_code",0)
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("owner_cd",0)
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("sku",0)
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("carton_id",0)	//06/10/2013 GailM  608
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("serial_no",0)
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("Component_ind",0)  //01/03/2011 ujh: S/N:
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("Component_no",0)   //01/03/2011 ujh: S/N:
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("row",0)
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("status",0)


ll_row = w_serial_no_add_delete.dw_serial_no_add_delete.insertrow(0)
w_serial_no_add_delete.dw_serial_no_add_delete.SetItem(ll_row,"wh_code",ls_wh_code)
w_serial_no_add_delete.dw_serial_no_add_delete.SetItem(ll_row,"owner_cd",ls_owner_cd)
w_serial_no_add_delete.dw_serial_no_add_delete.SetItem(ll_row,"sku",ls_sku)
w_serial_no_add_delete.dw_serial_no_add_delete.SetItem(ll_row,"carton_id",ls_carton_id)	//06/10/2013 GailM 608
w_serial_no_add_delete.dw_serial_no_add_delete.SetItem(ll_row,"serial_no",ls_serial_no)
w_serial_no_add_delete.dw_serial_no_add_delete.SetItem(ll_row,"Component_Ind",ls_Component_ind) //01/03/2011 ujh: S/N:
w_serial_no_add_delete.dw_serial_no_add_delete.SetItem(ll_row,"Component_no",ll_Component_no)  //01/03/2011 ujh: S/N:
w_serial_no_add_delete.dw_serial_no_add_delete.SetItem(ll_row,"row",ll_row)

w_serial_no_add_delete.dw_serial_no_add_delete.SetItem(ll_row,"po_no", ls_po_no)
w_serial_no_add_delete.dw_serial_no_add_delete.SetItem(ll_row,"l_code", ls_l_code)

w_serial_no_add_delete.ib_rows_valid = true

end event

event dw_list::resize;call super::resize;//dw_list.height = this.height - 15  // 01/03/2011 ujh: S/N_P:  the datawindow was too big for the window, so no bottom controls

end event

type dw_select from u_dw_ancestor within w_sn_change_parent
integer x = 37
integer y = 4
integer width = 2587
integer height = 396
boolean bringtotop = true
string dataobject = "d_sn_change_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;

//iw_window.PostEvent('ue_retrieve')


//  Optional routine to cleanup SN's ...

/*
BOOLEAN lb_SN_cleaned = FALSE
LONG    ll_Rtn = 0

CHOOSE CASE dwo.name
		
	CASE 'serial_no'
		IF UPPER(gs_project) = 'PANDORA' THEN
					
			// ET3 - 2012-07-05 Pandora 447 - cleanup SN's by removing leading/trailing '.' and '-'
			data = TRIM(data)
			If len(data) > 1 Then
				// strip extraneous Trailing chars
				DO WHILE MATCH( data, "[-\.]$" )
					data = MID(data, 1, len(data) - 1 )
					lb_SN_cleaned = TRUE
				LOOP
				
				// strip extraneous Leading chars
				DO WHILE MATCH( data, "^[-\.]")
					data = MID(data, 2, len(data) - 1 )
					lb_SN_cleaned = TRUE
				LOOP
				
			End If
			
		END IF  // Pandora

END CHOOSE


IF lb_SN_cleaned THEN
	ll_Rtn = 2
	this.setitem( row, dwo.name, data )
ELSE
	ll_Rtn = 0

END IF

RETURN ll_Rtn
*/


end event

event getfocus;call super::getfocus;
If ib_changed = True Then
	This.modify("warehouse.protect=1")
	This.modify("sku.protect=1")
	This.modify("serial_no.protect=1")
Else
	this.Modify("warehouse.protect=0")
	This.modify("sku.protect=0")
	This.modify("serial_no.protect=0")
End If




end event

type cb_search from commandbutton within w_sn_change_parent
integer x = 2683
integer y = 56
integer width = 297
integer height = 104
integer taborder = 40
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
string ls_sku,ls_warehouse,ls_Serial_No, ls_po_no
string ls_where,ls_sql , ls_l_code, ls_owner_cd, ls_carton_id
string ls_union_single, ls_union_parent, ls_union_child , ls_select_StandAlone, ls_select_ParentChild, ls_join // 01/03/2011 ujh: S/N:
Boolean lb_where
Boolean lb_NoCriteria

lb_where = False
If dw_select.accepttext() = -1 Then Return

If ib_changed Then
	messagebox(is_title,'Please save changes first!',StopSign!)
	return
End If

dw_list.reset()

long llrow 
llrow = 0
ls_Warehouse = dw_select.GetItemString(1,"warehouse")
ls_sku = dw_select.GetItemString(1,"sku")
ls_serial_no = dw_select.GetItemString(1,"serial_no")
ls_po_no = dw_select.GetItemString(1,"po_no")
ls_l_code	 = dw_select.getItemString(1, "l_code") //18-Dec-2017 :Madhu -S14305- Added Location
ls_owner_cd = dw_select.getItemString(1, "owner_cd")
ls_carton_id = dw_select.getItemString(1, "carton_id")

//TimA 08/22/12  Fixed a problem where if you deleted a search criteria it would not work because all the code looks for IsNull values.
If ls_Warehouse = '' then
	SetNull(ls_Warehouse)
End if
If ls_sku = '' then
	SetNull(ls_sku)
End if
If ls_serial_no = '' then
	SetNull(ls_serial_no)
End if
if ls_po_no = '' then
	SetNull( ls_po_no )
end if
If ls_l_code ='' Then SetNull(ls_l_code) //18-Dec-2017 :Madhu -S14305- Added Location

If IsNull(ls_Warehouse) and IsNull(ls_sku) and IsNull(ls_serial_no)  and IsNull(ls_l_code) then
	lb_NoCriteria = True
End if
//TimA 08/22/12 Don't allow search with now criteria.  Too much data is returned.
If 	lb_NoCriteria = True then
	messagebox(is_title,'You must have at least 1 of the search criterias filled in.',StopSign!)
	Return
End if

ls_sql = is_origSQL 

// 01/03/2011 ujh: S/N_Pc:  REMEMBER with these that the pos function is CASE SENSITIVE
ls_where = " Serial_Number_Inventory.project_id = '" + gs_project + "' "  
ls_join = " join Serial_number_inventory si2 on si2.Component_no = si1.Component_no "
ls_union_single = ''
ls_union_parent = ''
ls_union_child = ''
if  not isnull(ls_sku) then
	 // 01/03/2011 ujh: S/N_Pc  replace ls_where so parents and children appear when either is sought
	 // Get the stand alone parts
	ls_union_single    += " and serial_number_inventory.sku like '" + ls_sku + "%' " 
	ls_union_single    += " and serial_number_inventory.Component_ind not in ('Y','*') " 
	
	// Get the Parent parts
	ls_union_parent   += " and si1.sku like '" + ls_sku + "%' "   
	ls_union_parent   += " and si2.Component_ind = 'Y'"   

	// Get the component parts
	ls_union_child      += " and si1.sku like '" + ls_sku + "%' "
	ls_union_child      +=  " and si2.Component_ind = '*'"  
	lb_where = True
end if

// 01/03/2011 ujh: S/N_Pc  replace ls_where so parents and children appear when either is sought. Now add warehouse
if not isnull(ls_warehouse) then
	//	ls_where += " and serial_number_inventory.wh_code like '" + ls_warehouse + "%' "
	// get parts for the stand alone union
	ls_union_single +=   " and serial_number_inventory.wh_code like '" + ls_warehouse + "%' "
	// 01/03/2011 ujh: S/N_Pfx2  add si2.wh_code.... as both need to be in where clause
	// Get parts for the parent union
	ls_union_parent +=  " and si1.wh_code like '" + ls_warehouse + "%' " +  " and si2.wh_code like '" + ls_warehouse + "%' "
	// Get parts for he compoent union
	ls_union_child   +=   " and si1.wh_code like '" + ls_warehouse + "%' " +  " and si2.wh_code like '" + ls_warehouse + "%' "
	lb_where = True
end if

if not isnull(ls_serial_no) then
//	ls_where += " and serial_number_inventory.serial_no = '" + ls_serial_No + "' "
	ls_union_single +=    " and serial_number_inventory.serial_no = '" + ls_serial_No + "' "
	
	ls_union_parent +=  " and si1.serial_no like '" +  ls_serial_No + "%' "   
	ls_union_parent   += " and si2.Component_ind = 'Y'"  
	/*01/03/2001 ujh: S/N_Pz  Because the sub select cannot only return one value must use equal not like.  This changes the
		search for serial numbers to an exact search.  comment out this line in parent and child union to go back to serial number
		entries such as "test......."  When that is done, component serial number search will bring back multiple parents of which it is
		a child.*/
		if isnull(ls_sku) then // when sku is not null skip the following so sku search is not limited to an exact search and allows sku like "abc%"
//			ls_union_parent   +=  " and si2.component_no =  (Select Component_no from Serial_number_inventory where serial_no = '" +  ls_serial_No + "')"
			ls_union_parent   += " and si2.component_no = case when si1.serial_no = '" +  ls_serial_No + "' then si1.component_no else -1 end "
	end if
		
	ls_union_child   +=   " and si1.serial_no like '" +  ls_serial_No + "%' " 
	ls_union_child      +=  " and si2.Component_ind = '*'"  
	/*01/03/2001 ujh: S/N_Pz  Because the sub select cannot only return one value must use equal not like.  This changes the
		search for serial numbers to an exact search.  comment out this line in parent and child union to go back to serial number
		entries such as "test......."  When that is done, component serial number search will bring back multiple parents of which it is
		a child.*/
		if isnull(ls_sku) then  // when sku is not null skip the following so sku search is not limited to an exact search and allows sku like "abc%"
//			ls_union_child      +=  " and si2.component_no =  (Select Component_no from Serial_number_inventory where serial_no = '" +  ls_serial_No + "')"
			ls_union_child   += " and si2.component_no = case when si1.serial_no = '" +  ls_serial_No + "' then si1.component_no  else -1 end "
		end if
	lb_where = True
	
end if

// LTK 20151222 Pandora #1002 - Added Project (po_no) which is only displayed for Pandora
if not isnull(ls_po_no) then
	ls_union_single +=   " and serial_number_inventory.po_no =  '" + ls_po_no + "' "
	ls_union_parent +=  " and si1.po_no = '" + ls_po_no + "' " +  " and si2.po_no = '" + ls_po_no + "' "
	ls_union_child   +=   " and si1.po_no = '" + ls_po_no + "' " +  " and si2.po_no = '" + ls_po_no + "' "
	lb_where = True
end if

//18-Dec-2017 :Madhu -S14305 - Added Location as Search Criteria - START
if not isnull(ls_l_code) then
	ls_union_single +=   " and serial_number_inventory.l_code =  '" + ls_l_code + "' "
	ls_union_parent +=  " and si1.l_code = '" + ls_l_code + "' " +  " and si2.l_code = '" + ls_l_code + "' "
	ls_union_child   +=   " and si1.l_code = '" + ls_l_code + "' " +  " and si2.l_code = '" + ls_l_code + "' "
	lb_where = True
end if

if not isnull(ls_owner_cd) then
	ls_union_single +=   " and serial_number_inventory.Owner_cd =  '" + ls_owner_cd + "' "
	ls_union_parent +=  " and si1.Owner_cd = '" + ls_owner_cd + "' " +  " and si2.Owner_cd = '" + ls_owner_cd + "' "
	ls_union_child   +=   " and si1.Owner_cd = '" + ls_owner_cd + "' " +  " and si2.Owner_cd = '" + ls_owner_cd + "' "
	lb_where = True
end if

if not isnull(ls_carton_id) then
	ls_union_single +=   " and serial_number_inventory.Carton_Id =  '" + ls_carton_id + "' "
	ls_union_parent +=  " and si1.Carton_Id = '" + ls_carton_id + "' " +  " and si2.Carton_Id = '" + ls_carton_id + "' "
	ls_union_child   +=   " and si1.Carton_Id = '" + ls_carton_id + "' " +  " and si2.Carton_Id = '" + ls_carton_id + "' "
	lb_where = True
end if
//18-Dec-2017 :Madhu -S14305 - Added Location as Search Criteria - END

// Replace 'PROJECT' with the current project.  (ujh: code found this way when joins were created--not sure why it was done like this)
ls_sql = Replace (ls_sql, pos( ls_sql,"Serial_Number_Inventory.Project_Id = 'PROJECT'",1), Len("Serial_Number_Inventory.Project_Id = 'PROJECT'"), ls_where )

// 01/03/2011 ujh: S/N_Pc:  Create correct Select for the unions
ls_select_StandAlone = ls_sql
ls_select_ParentChild = ls_sql
// 01/03/2011 ujh: S/N_P:  Note that 'as si1 '  was added to give an alias to the table before the join
ls_select_ParentChild =  Replace(ls_select_ParentChild, pos(ls_select_ParentChild,"WHERE ",1), Len("Where "), ' as si1 ' +ls_join + ' And ')
// Replace name with alias
Do while pos(ls_select_ParentChild,"Serial_Number_Inventory.", 1)  <> 0
	ls_select_ParentChild =  Replace(ls_select_ParentChild, pos(ls_select_ParentChild,"Serial_Number_Inventory.",1), Len("Serial_Number_Inventory."), "si2.")
Loop 

ls_sql = ls_select_StandAlone + ls_union_single
ls_sql += 'UNION ' + ls_select_ParentChild + ls_union_Parent
ls_sql += 'UNION ' + ls_select_ParentChild + ls_union_Child
//ls_sql += ' order by  Component_no, component_ind desc, SKU' 
ls_sql += ' order by  WH_Code, owner_cd,  Component_no, component_ind desc, SKU'  //01/03/2011 ujh: S/N_Pza  Fix so order by wh_code

//ls_sql = i_sql + ls_where
dw_list.setsqlselect(ls_sql)

////DGM For giving warning for all no search criteria
//if not lb_where then
//	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
//END IF

if dw_list.retrieve() = 0 then
	messagebox(is_title,"No records found!")
end if
dw_list.object.Serial_no.visible = false
end event

type cb_1 from commandbutton within w_sn_change_parent
integer x = 2683
integer y = 216
integer width = 297
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;dw_list.Reset()
dw_select.Reset()
dw_select.InsertRow(0)
ib_changed = false


end event

type cb_add from commandbutton within w_sn_change_parent
integer x = 3026
integer y = 56
integer width = 549
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Open Add Window"
end type

event clicked;// 08/23/2010 ujhall: 01 of ?? Full Circle Fix: Serial_number_inventory Maintenance
//If MessageBox(is_title, "Continuing may result in clearing all rows without saving. Do you want to contintue", Question!, YesNo!,2) = 1 Then
	
	// 11/08/2010 ujh: (SNRE)  Serial Number Report Enhancements  need to pass more values
	Str_parms lstr_parms
	lstr_parms.String_arg[1] = 'ADD'
//	OpenWithParm(w_serial_no_add_delete, "ADD")
	OpenWithParm(w_serial_no_add_delete, lstr_parms)
	cb_Add.enabled = false
//	cb_delete.enabled = false
//End if






end event

type cb_delete from commandbutton within w_sn_change_parent
boolean visible = false
integer x = 3611
integer y = 216
integer width = 297
integer height = 104
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Delete"
end type

event clicked;// 08/23/2010 ujhall: 01 of ?? Full Circle Fix: Serial_number_inventory Maintenance

If MessageBox(is_title, "Continuing may result in clearing all rows without saving. Do you want to contintue", Question!, YesNo!,2) = 1 Then
	OpenWithParm(w_serial_no_add_delete, "DELETE")
	cb_Add.enabled = false
	cb_delete.enabled = false
	
	

End if

end event

type st_delete_info from statictext within w_sn_change_parent
integer x = 1294
integer y = 400
integer width = 1385
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Doubleclick rows to Delete"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_test from commandbutton within w_sn_change_parent
boolean visible = false
integer x = 3611
integer y = 64
integer width = 297
integer height = 104
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Test"
end type

event clicked;

datastore  lds_list_clone
long ll_next_start
 lds_list_clone = CREATE datastore
 lds_list_clone.DataObject = "d_sn_change_for_sn_inventory"

dw_select.SetItem(1, 'SKU', '07003911')

Parent.cb_search.TriggerEvent(clicked!)
//string ls_ujh
//ls_ujh = string(dw_list.RowCount(), '0')
//messagebox('uh', 'row count = ' + ls_ujh)

dw_list.SelectRow(1, true)
 dw_list.RowsCopy( dw_list.GetRow(), &
         dw_list.RowCount(), Primary!, lds_list_clone, 1, Primary!)
ll_next_start = lds_list_clone.rowcount() + 1			
dw_list.SelectRow(1, true)
 dw_list.RowsCopy( dw_list.GetRow(), &
         dw_list.RowCount(), Primary!, lds_list_clone, ll_next_start, Primary!)
dw_list.reset()

lds_list_clone.SelectRow(1, true)
 lds_list_clone.RowsCopy( lds_list_clone.GetRow(), &
         lds_list_clone.RowCount(), Primary!, dw_list, 1, Primary!)
			
//			ls_ujh = string(dw_list.RowCount(), '0')
//messagebox('uh', 'row count = ' + ls_ujh)

end event

type cb_remove_sku from commandbutton within w_sn_change_parent
integer x = 3026
integer y = 216
integer width = 549
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "SKU SN Delete"
end type

event clicked;int li_rows, li_row, li_result
long ll_deleted
string ls_sku

li_rows = dw_list.RowCount()
ls_sku = dw_select.GetItemString(1,'sku')

If f_check_access(is_process,"D") = 2 Then Return

If upper(gs_project) = 'PANDORA' Then

	If gs_role = '1' or gs_role = '2' Then
		
		MessageBox("Security Check", "You have no access to this function!",StopSign!)
		return 
		
	End If
	
End If

// Prompting for deletion
If MessageBox(is_title, "Are you sure you want to delete the " + string(li_rows) + " serial numbers for this SKU?" ,Question!,YesNo!,2) = 2 Then
	Return
End If

for li_row = 1 to li_rows	
	 li_result = dw_list.deleterow(1)
	 ll_deleted = dw_list.deletedcount( )
next
	
If ll_deleted = li_Rows Then
	dw_list.update()
	messagebox('is_title','Serial Numbers have been deleted!')
Else	
	MessageBox('Error in delete','Not all SNs have been deleted.  Please rerun request.')
End If


end event

