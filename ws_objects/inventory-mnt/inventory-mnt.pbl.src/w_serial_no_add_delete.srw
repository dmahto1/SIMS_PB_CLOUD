$PBExportHeader$w_serial_no_add_delete.srw
forward
global type w_serial_no_add_delete from window
end type
type cb_delete_row from commandbutton within w_serial_no_add_delete
end type
type cb_close from commandbutton within w_serial_no_add_delete
end type
type cb_exec_db_action from commandbutton within w_serial_no_add_delete
end type
type cb_insert_row from commandbutton within w_serial_no_add_delete
end type
type st_header from statictext within w_serial_no_add_delete
end type
type dw_serial_no_add_delete from datawindow within w_serial_no_add_delete
end type
end forward

global type w_serial_no_add_delete from window
integer width = 5806
integer height = 1876
boolean titlebar = true
boolean controlmenu = true
boolean resizable = true
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_delete_row cb_delete_row
cb_close cb_close
cb_exec_db_action cb_exec_db_action
cb_insert_row cb_insert_row
st_header st_header
dw_serial_no_add_delete dw_serial_no_add_delete
end type
global w_serial_no_add_delete w_serial_no_add_delete

type variables
DataWindowChild idwcWh, idwcOwner

boolean ib_rows_valid

long il_current_row

String is_current_window

Str_parms istr_parms

Str_parms istr_srno_parms   // 01/03/2011 ujh: S/N_P: 

Boolean ib_is_pandora_single_project_location_rule_on	// LTK 20160121
end variables

on w_serial_no_add_delete.create
this.cb_delete_row=create cb_delete_row
this.cb_close=create cb_close
this.cb_exec_db_action=create cb_exec_db_action
this.cb_insert_row=create cb_insert_row
this.st_header=create st_header
this.dw_serial_no_add_delete=create dw_serial_no_add_delete
this.Control[]={this.cb_delete_row,&
this.cb_close,&
this.cb_exec_db_action,&
this.cb_insert_row,&
this.st_header,&
this.dw_serial_no_add_delete}
end on

on w_serial_no_add_delete.destroy
destroy(this.cb_delete_row)
destroy(this.cb_close)
destroy(this.cb_exec_db_action)
destroy(this.cb_insert_row)
destroy(this.st_header)
destroy(this.dw_serial_no_add_delete)
end on

event open;
// 08/23/2010 ujhall: 01 of ?? Full Circle Fix: Serial_number_inventory Maintenance
String ls_FromCode
// 11/08/2010 ujh: (SNRE)  Serial Number Report Enhancements
istr_parms = message.PowerobjectParm    // 11/08/2010 ujh: (SNRE) change  needed to pass more values
// ls_FromCode = Message.StringParm
ls_FromCode = istr_parms.String_arg[1]   //  Get the From Code

IF Upper(gs_project) <> 'PANDORA' THEN 
	dw_serial_no_add_delete.Object.Owner_cd.dddw.Name = "d_dddw_owner_supplier"
	dw_serial_no_add_delete.Object.Owner_cd.dddw.DisplayColumn	 = "owner_owner_cd"
	dw_serial_no_add_delete.Object.Owner_cd.dddw.DataColumn	 = "owner_owner_cd"
	dw_serial_no_add_delete.Object.Owner_cd.dddw.UseAsBorder  = "yes"	
	dw_serial_no_add_delete.Object.Owner_cd.dddw.VScrollBar  = "yes"
	dw_serial_no_add_delete.Object.Owner_cd.dddw.AutoRetrieve = "yes"
END IF

// LTK 20150121  Pandora #1002  Make location code and project visible for Pandora
ib_is_pandora_single_project_location_rule_on = ( f_retrieve_parm("PANDORA", "FLAG", "SOC_SERIAL_GPN_TRACK_ON") = 'Y' )
if gs_project = 'PANDORA' and ib_is_pandora_single_project_location_rule_on then
	dw_serial_no_add_delete.Object.Po_No.Visible = TRUE
	dw_serial_no_add_delete.Object.L_Code.Visible = TRUE
//	dw_serial_no_add_delete.Object.lot_no.Visible = TRUE			// LTK 20160129  Per Roy, don't display the extra lot-able fields
//	dw_serial_no_add_delete.Object.po_no2.Visible = TRUE
//	dw_serial_no_add_delete.Object.inventory_type.Visible = TRUE
//	dw_serial_no_add_delete.Object.exp_dt.Visible = TRUE
	dw_serial_no_add_delete.Object.component_ind.Visible = FALSE	// LTK 20160129  Roy no long wants this field displayed for Pandora
end if



Choose Case upper(ls_FromCode)
	Case "ADD"
//		st_header.text = 'Serial_Number_Inventory INSERT'
		st_header.text = 'Serial_Number_Inventory ADD'  // 01/03/2011 ujh: S/N_P:  change for ops viewing consistency
		is_current_window = 'ADD'
		cb_insert_row.visible = true
//		cb_exec_db_action.Text = 'Exec Db INSERT'
		ib_rows_valid = false
		dw_serial_no_add_delete.insertRow(0) 
		
	Case "DELETE"
		st_header.text = 'Serial_Number_Inventory DELETE'
		is_current_window = 'DELETE'
		cb_insert_row.visible = false
		cb_exec_db_action.Text = 'Execute DELETE'
		ib_rows_valid = true
		w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("po_no",0)		// LTK 20160205
		w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("l_code",0)
//		dw_serial_no_add_delete.insertRow(0)
	End Choose

		dw_serial_no_add_delete.GetChild("wh_code", idwcWh)
		dw_serial_no_add_delete.GetChild("Owner_cd",idwcOwner)
					
		
//		dw_serial_no_add_delete.insertRow(0)
		
		/*  This is set to zero because in rowfucus changed zero is the exception.  The exception is neeed, as that event 
		      is called  someplace along the way before the window gives control to the user.  The exception is to avoid
			 preventing access to the row.*/
		il_current_row = 0 //////////////////////////////////////////////  
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("row",0)      // ujh 08/31/2010
		w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("status",0)   // ujh 08/31/2010
		
		idwcWh.SetTransObject(sqlca)
		//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...
		// ET3 2012-06-14: Implement generic test
		//if g.ibSNchainofcustody then
		if g.ibSNchainofcustody or ib_is_pandora_single_project_location_rule_on then	// LTK 20160127  Added the Pandora boolean

//		IF Upper(gs_project) = 'PANDORA' THEN
//			If idwcWh.Retrieve("PANDORA") < 1 Then 
//				idwcWh.InsertRow(0) 
//			end if
//		ELSEIF  Upper(gs_project) = 'BLUECOAT' THEN
//			If idwcWh.Retrieve("BLUECOAT") < 1 Then 
//				idwcWh.InsertRow(0) 
//			end if
			
			IF idwcWh.Retrieve(UPPER(TRIM(gs_project))) < 1 THEN idwcWh.Insertrow(0)
			
		END IF
		
		idwcWh.Sort()
		
		idwcOwner.SetTransObject(sqlca)
		//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...
		// ET3 2012-06-14: Implement generic test
		//if g.ibSNchainofcustody then
		if g.ibSNchainofcustody or ib_is_pandora_single_project_location_rule_on then	// LTK 20160127  Added the Pandora boolean

//		IF Upper(gs_project) = 'PANDORA' THEN
//			If idwcOwner.Retrieve("PANDORA") < 1 Then 
//				idwcOwner.InsertRow(0) 
//			end if
//		ELSEIF  Upper(gs_project) = 'BLUECOAT' THEN
//			If idwcOwner.Retrieve("BLUECOAT") < 1 Then 
//				idwcOwner.InsertRow(0) 
//			end if
			
			IF idwcOwner.Retrieve(UPPER(TRIM(gs_project))) < 1 THEN  idwcOwner.InsertRow(0)

		END IF
		
		idwcOwner.Sort()
		idwcOwner.InsertRow(1) 


end event

event closequery;

//w_serial_no_add_delete.cb_close.TriggerEvent('clicked')


String ls_status
integer il_msg
long ll_indx 
boolean lb_done
lb_done =true

For ll_indx = 1 to dw_serial_no_add_delete.RowCount()
	ls_status = dw_serial_no_add_delete.GetItemString(ll_indx, 'Status') 
	if   isnull(ls_status ) or not( ls_status = 'INSERTED' or ls_status = 'DELETED' or ls_status = 'FAIL' ) then
		lb_done = false
		continue
	end if
	
next

if not lb_done then
	 il_msg =  messagebox('Check Done','Some rows have not been processed. Do you want to close anyway', Question!,YesNo! ,2)
	if il_msg = 2 then
		
		return 1
	end if
end if
//TimA Remove the call to the search button.  After an Add or Delete the is no reason to search again.
//This causes a very long search it no criteria is on the original search
//w_sn_change_parent.cb_search.TriggerEvent("clicked")
w_sn_change_parent.cb_Add.enabled = true
//w_sn_change_parent.cb_Delete.enabled = true
//close(w_serial_no_add_delete)
return 0
end event

type cb_delete_row from commandbutton within w_serial_no_add_delete
integer x = 1687
integer y = 236
integer width = 576
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Remove Row"
end type

event clicked;


long ll_row, ll_msg, ll_row_pointer
boolean  ib_valid_hold

ll_row = dw_serial_no_add_delete.Getrow()
ll_row_pointer = dw_serial_no_add_delete.GetItemNumber(ll_row,'row')

ll_msg = messagebox('Infor', 'You are about to delete row '+string(ll_row_pointer,'0')+ ':  Continue?',Question!,YesNO!,2)
ib_valid_hold = ib_rows_valid
ib_rows_valid = true  //  If Delete is accepted, the only row that could be invalid is the current. After deletion all left are valid
if ll_msg = 1 then
	dw_serial_no_add_delete.DeleteRow(ll_row)
//	ib_rows_valid = true  /// ujj this was not in the 8:30 build on 08/31
	return
else
	ib_rows_valid = ib_valid_hold
end if

end event

type cb_close from commandbutton within w_serial_no_add_delete
integer x = 3031
integer y = 236
integer width = 576
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
end type

event clicked;
//String ls_status
//integer il_msg
//long ll_indx 
//boolean lb_done
//lb_done =true
//
//For ll_indx = 1 to dw_serial_no_add_delete.RowCount()
//	ls_status = dw_serial_no_add_delete.GetItemString(ll_indx, 'Status') 
//	if   isnull(ls_status ) or not( ls_status = 'INSERTED' or ls_status = 'DELETED' or ls_status = 'FAIL' ) then
//		lb_done = false
//		continue
//	end if
//	
//next
//
//if not lb_done then
//	 il_msg =  messagebox('Check Done','Some rows have not been processed. Do you want to close anyway', Question!,YesNo! ,2)
//	if il_msg = 2 then
//		return
//	end if
//end if


////w_sn_change_parent.cb_1.TriggerEvent("clicked")
//w_sn_change_parent.cb_search.TriggerEvent("clicked")
//w_sn_change_parent.cb_Add.enabled = true
////w_sn_change_parent.cb_Delete.enabled = true
//close(w_serial_no_add_delete)


//long ll_return
//ll_return = w_serial_no_add_delete.triggerevent("closequery")
//If ll_return = 1 then
	close(w_serial_no_add_delete)
//end if
end event

type cb_exec_db_action from commandbutton within w_serial_no_add_delete
integer x = 2359
integer y = 236
integer width = 576
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save"
end type

event clicked;
long il_indx, ll_rows, ll_owner_id, ll_found
string ls_wh_code, ls_owner_cd, ls_sku, ls_serial_no, ls_err, ls_status, ls_status_template,sErrText
string ls_carton_id // 06/10/2013 GailM 608
string ls_component_ind  // 01/03/2011 ujh: S/N_P
long ll_component_no  // 01/03/2011 ujh: S/N_P
datetime ldtToday
String ls_lot_no, ls_po_no2, ls_inventory_type, ls_po_no, ls_l_code	// LTK 20160127
DateTime ldt_exp_dt																// LTK 20160127
Long i																					// LTK 20160127
ll_rows = dw_serial_no_add_delete.RowCount()

If dw_serial_no_add_delete.AcceptText() = -1 Then Return -1

// Set the status that will be placed in the status column based on ADD window versus Delete window
if is_current_window = 'ADD' then
	ls_status_template = 'INSERTED'
else
	ls_status_template = 'DELETED'
end if
if not ib_rows_valid then
	messagebox('Row Validation Error', 'Please Validate all rows before insterting to database.')
	return
end if

// LTK 20160127
if gs_project = 'PANDORA' and ib_is_pandora_single_project_location_rule_on and ( is_current_window = 'ADD' ) then
	for i = 1 to dw_serial_no_add_delete.RowCount()
		if IsNull( dw_serial_no_add_delete.GetItemString( i, "po_no") ) or Len(Trim( dw_serial_no_add_delete.GetItemString( i, "po_no") )) = 0 then
			MessageBox('Row Validation Error', 'Please enter Project code for all serials numbers.')
			dw_serial_no_add_delete.SetFocus()
			dw_serial_no_add_delete.ScrollToRow( i )
			dw_serial_no_add_delete.SetColumn( "po_no" )
			Return
		end if
		if IsNull( dw_serial_no_add_delete.GetItemString( i, "l_code") ) or Len(Trim( dw_serial_no_add_delete.GetItemString( i, "l_code") )) = 0 then
			MessageBox('Row Validation Error', 'Please enter Location for all serials numbers.')
			dw_serial_no_add_delete.SetFocus()
			dw_serial_no_add_delete.ScrollToRow( i )
			dw_serial_no_add_delete.SetColumn( "l_code" )
			Return
		end if
	next
end if


//Execute Immediate "Begin Transaction" using SQLCA;
For il_indx = 1 to ll_rows
	ls_status = dw_serial_no_add_delete.GetItemString(il_indx,'status') 
	if isnull(ls_status) or ls_status <> ls_status_template then
		//Execute Immediate "Begin Transaction" using SQLCA;  //09/01/2010 ujhall:  
		ls_wh_code = dw_serial_no_add_delete.GetItemString(il_indx, 'wh_code')
		ls_owner_cd = dw_serial_no_add_delete.GetItemString(il_indx, 'owner_cd')
		ls_sku = upper(dw_serial_no_add_delete.GetItemString(il_indx, 'sku'))
		ls_carton_id = upper(dw_serial_no_add_delete.GetItemString(il_indx, 'carton_id'))  // 06/10/2013 Gailm 608
		//BCR - 08-JUN-2011: Prevent leading and trailing spaces in Serial No
		ls_serial_no = TRIM(upper(dw_serial_no_add_delete.GetItemString(il_indx, 'serial_no')))
		ls_component_ind = upper(dw_serial_no_add_delete.GetItemString(il_indx, 'component_ind'))
		if gs_project = 'PANDORA' then ls_component_ind = 'N'	// LTK 20160129  Roy no longer wants component indicator displayed so default it here
		ll_component_no = dw_serial_no_add_delete.GetItemNumber(il_indx, 'component_no')

		// LTK 20160127  Added Pandora fields and defaults
		if ib_is_pandora_single_project_location_rule_on and upper(is_current_window) = 'ADD' then
			ls_po_no = TRIM(dw_serial_no_add_delete.GetItemString(il_indx, 'po_no'))
			ls_l_code = TRIM(dw_serial_no_add_delete.GetItemString(il_indx, 'l_code'))
			ls_lot_no = TRIM(dw_serial_no_add_delete.GetItemString(il_indx, 'lot_no'))
			ls_po_no2 = TRIM(dw_serial_no_add_delete.GetItemString(il_indx, 'po_no2'))
			ls_inventory_type = TRIM(dw_serial_no_add_delete.GetItemString(il_indx, 'inventory_type'))
			ldt_exp_dt = dw_serial_no_add_delete.GetItemDateTime(il_indx, 'exp_dt')
			// Set defaults if absent data
			if Len(Trim( ls_lot_no )) = 0 or IsNull( ls_lot_no ) then ls_lot_no = '-'
			if Len(Trim( ls_po_no2 )) = 0 or IsNull( ls_po_no2 ) then ls_po_no2 = '-'
			if Len(Trim( ls_inventory_type )) = 0 or IsNull( ls_inventory_type ) then ls_inventory_type = 'N'
			if IsNull( ldt_exp_dt ) then ldt_exp_dt = DateTime('2999-12-31')
			if isNull( ll_component_no ) then ll_component_no = 0
			if Len(Trim( ls_carton_id )) = 0 or IsNull( ls_carton_id ) then ls_carton_id = '-'
		end if

//		// 11/08/2010 ujh (SNRE)  Need Owner ID for Serial History insert, though it was previously skipped for Delete
			// NOTE To ujh:  use this way of getting the owner Id where possible
			ll_found = idwcOwner.Find("owner_owner_cd = '" + ls_owner_cd+"'",  1, idwcOwner.RowCount())
			if ll_found > 0 then
				ll_owner_id =  idwcOwner.GetitemNumber(ll_found, 'owner_owner_id')
			else
				// if it is not there, then must go to the database
				SELECT Owner_id
				into :ll_owner_id
				FROM Owner
				WHERE Project_id = :gs_project
				AND Owner_cd = :ls_owner_cd;
				
			end if
//		
	
		Execute Immediate "Begin Transaction" using SQLCA;  // dts - 9/10/10 - moved from above
		ldtToday = DateTime(today(), Now())
		
		if upper(is_current_window) = 'ADD' then
			// LTK 20160127  Added the Pandora single-project-location if condition, which has additional columns
			if ib_is_pandora_single_project_location_rule_on then
				Insert into Serial_Number_inventory 
				(project_id,wh_code, owner_id, owner_cd,sku,carton_id,serial_no,component_ind, component_no,update_date,update_user, lot_no, po_no2, inventory_type, exp_dt, po_no, l_code )
				Values
				(:gs_project,:ls_wh_code, :ll_owner_id, :ls_owner_cd, :ls_sku, :ls_carton_id, :ls_serial_no,&
						:ls_component_ind, :ll_component_no, :ldtToday ,:gs_userid, :ls_lot_no, :ls_po_no2, :ls_inventory_type, :ldt_exp_dt, &
						:ls_po_no, :ls_l_code );
			else
				//01/03/2011 ujh: S/N_P:  add component_ind and component_id to the insert
				Insert into Serial_Number_inventory 
				(project_id,wh_code, owner_id, owner_cd,sku,carton_id,serial_no,component_ind, component_no,update_date,update_user)
				Values
				(:gs_project,:ls_wh_code, :ll_owner_id, :ls_owner_cd, :ls_sku, :ls_carton_id, :ls_serial_no,&
						:ls_component_ind, :ll_component_no, :ldtToday ,:gs_userid);
			end if

		else
			//TimA 08/26/13 because carton id is null we need to change the SQL statement.
			If IsNull(ls_carton_id) then
				Delete  Serial_number_inventory
				where project_id = :gs_project
				and wh_code = :ls_wh_code
				and owner_cd = :ls_owner_cd
				and sku = :ls_sku
				and carton_id Is Null
				and serial_no = :ls_serial_no;				
			Else
				Delete  Serial_number_inventory
				where project_id = :gs_project
				and wh_code = :ls_wh_code
				and owner_cd = :ls_owner_cd
				and sku = :ls_sku
				and carton_id = :ls_carton_id
				and serial_no = :ls_serial_no;
			End if
		end if
		
		
		
		If sqlca.sqlcode <> 0 Then
			ls_Err = 'ERROR'
			Execute Immediate "ROLLBACK" using SQLCA;
			dw_serial_no_add_delete.SetItem(il_indx,'status','FAIL')
		else
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// 11/08/2010 ujh: (SNRE)  Insert into Serial Number History
			ldtToday = f_getLocalWorldTime( ls_Wh_Code ) 
			
			//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...modify code to use gs_project instead of Pandora
			Insert Into Item_Serial_Change_History 
							(project_ID, Wh_Code, Owner_ID, Complete_Date, 
							Po_No, Sku, Supp_Code,  From_Serial_No, To_Serial_No, Transaction_sent, update_user)
//			Values(:gs_Project, :ls_Wh_Code, :ll_Owner_id, :ldtToday,"" , :ls_SKU, "PANDORA" , 
			Values(:gs_Project, :ls_Wh_Code, :ll_Owner_id, :ldtToday,"" , :ls_SKU, :gs_project , 

										Case upper(:is_current_window)
											when 'ADD' then ""
											when 'DELETE' then :ls_Serial_No
										end
											, 
										Case upper(:is_current_window)
											when 'ADD' then :ls_Serial_No
											when 'DELETE' then ""
										end
											, 'X' , :gs_userid ) 
			Using SQLCA;
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			If sqlca.sqlcode <> 0 Then
				ls_Err = 'ERROR'
				sErrText = SQLCA.SQLErrText
				Execute Immediate "ROLLBACK" using SQLCA;
				dw_serial_no_add_delete.SetItem(il_indx,'status','FAIL')
			else 
				Execute Immediate "Commit" using SQLCA;
				dw_serial_no_add_delete.SetItem(il_indx,'status',ls_status_template)
			end if
		end if
	end if

next
	
	If upper(ls_err) = 'ERROR' then
			Messagebox('Error',"Some items were not"+ ls_status_template+".  Please check status on each row.  SQL Error: " + sErrText)
	end if
			

	


end event

type cb_insert_row from commandbutton within w_serial_no_add_delete
integer x = 1015
integer y = 236
integer width = 576
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Row"
end type

event clicked;
long ll_row, ll_row_pointer, ll_rowcount
//if ib_rows_valid  then
//	dw_serial_no_add_delete.insertRow(0)
//	ll_row = dw_serial_no_add_delete.RowCount()
//	dw_serial_no_add_delete.SetItem(ll_row,'row', ll_row)
//else
//	messagebox('Insert Row Error', 'Rows cannot be inserted until previous rows have been validated')
//end if
//

If dw_serial_no_add_delete.AcceptText() = -1 Then Return -1

if not ib_rows_valid then
	messagebox('Insert Row Error', 'Rows cannot be inserted until previous rows have been validated')
	return
end if

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ll_row = dw_serial_no_add_delete.insertRow(0)
dw_serial_no_add_delete.ScrollToRow(ll_row)  
/* this must NOT come before the  scroll to row above  because insert row calls the rowfocus changing event  where 
    this flag is tested.  The false being set here is for following situations.*/
ib_rows_valid = false  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//il_current_row = 0   //////////////////////////////////////////////////////////////////////////
il_current_row = ll_row  //ujh test 01


ll_rowcount = dw_serial_no_add_delete.RowCount() - 1    // if row is already inserted and I want the previous row, so -1


if ll_rowcount > 0 then
	// Get row pointer from the last row
	ll_row_pointer = dw_serial_no_add_delete.GetItemNumber(ll_rowcount,'row')
	dw_serial_no_add_delete.SetItem(ll_row,'row', ll_row_pointer+1)  //01/03/2011 ujh put his back
end if

w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("wh_code",110)
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("owner_cd",120)
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("sku",130)
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("serial_no",140)
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("Component_Ind",150)  //01/03/2011 ujh: S/N_P:
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("Component_no",160)    //01/03/2011 ujh: S/N_P:
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("row",0)
w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("status",0)

// LTK 20160128
if ib_is_pandora_single_project_location_rule_on then
	w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("po_no",170)
	w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("l_code",180)
	w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("lot_no",190)
	w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("po_no2",200)
	w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("inventory_type",210)
	w_serial_no_add_delete.dw_serial_no_add_delete.SetTabOrder("exp_dt",220)
end if



end event

type st_header from statictext within w_serial_no_add_delete
integer x = 1669
integer y = 64
integer width = 1669
integer height = 104
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ready"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_serial_no_add_delete from datawindow within w_serial_no_add_delete
integer x = 128
integer y = 340
integer width = 5554
integer height = 988
integer taborder = 10
string title = "none"
string dataobject = "d_sn_add_delete_for_sn_inventory"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;
// 08/23/2010 ujhall: 02 of ?? Full Circle Fix: Serial_number_inventory Maintenance
string ls_name, ls_serial_no_db,  ls_SKU, ls_sku_db,  ls_wh_code,ls_owner_cd
String ls_Component_ind,  ls_serialno_entered, ls_sku_serial, ls_parent_serialNo, ls_Parent_SKU  //01/03/2011 ujh: S/N_P:
long ll_Component_no, ll_Parent_CompNo, ll_return, ll_child_qty_bom, ll_child_qty_sni, ll_null  //01/03/2011 ujh: S/N_P:
long ll_owner_id, ll_found, i_indx
decimal ld_next  // 01/03/2011 ujh: S/N_Pfx1:
ls_name = DWO.NAME
setnull(ll_null)
String lsContainerTracking
String ls_color
Boolean lb_display_only, lb_enabled  
String ls_error_msg
decimal ld_other_owner_qty

Choose Case upper(ls_name)
	case 'WH_CODE'
	     idwcOwner.SetFilter('customer_wh_code = "'+data + '"')
//	     idwcOwner.SetFilter('customer_wh_code = "'+data + '" , customer_wh_code = " "')
		  
		idwcOwner.Filter( )
		
		idwcwh.SetSort('warehouse_wh_code a')
		idwcOwner.SetSort('owner_owner_cd a')
		idwcOwner.Sort()
		idwcWh.Sort()
		ll_found = idwcOwner.Find("owner_owner_cd  = ' '", 1,  idwcOwner.RowCount())
		idwcWh.ScrollToRow(ll_found)
		
		this.SetItem(row, 'sku', '') // blank thesku as it must be entered after warehouse and owner are selected
		this.SetItem(row, 'Serial_no', '') // blank the serial number as it must be entered after other values
		this.SetItem(row, 'Component_ind',"") // 01/03/2011 ujh: S/N_P:
		this.SetItem(row, 'SKU_Serial',"") // 01/03/2011 ujh: S/N_P:
		this.SetItem(row, 'Component_no', ll_null) // 01/03/2011 ujh: S/N_P:
		this.SetItem(row, 'Owner_cd','')
		this.SetItem(row, 'Status','')
//		idwcOwner.InsertRow(0)	
		ib_rows_valid = false
		il_current_row = row
		return 0
		
	case 'OWNER_CD'
		this.SetItem(row, 'sku', '') // blank thesku as it must be entered after warehouse and owner are selected
		this.SetItem(row, 'Serial_no', '') // blank the serial number as it must be entered after other values
		this.SetItem(row, 'Component_ind',"") // 01/03/2011 ujh: S/N_P:
		this.SetItem(row, 'SKU_Serial',"") // 01/03/2011 ujh: S/N_P:
		this.SetItem(row, 'Component_no', ll_null) // 01/03/2011 ujh: S/N_P:
		this.SetItem(row, 'Status','')
		ib_rows_valid = false  // ujh 08/31/2010: added to stop changing only part of an already validated row  
		il_current_row = row  // ujh 08/31/2010: added to stop changing only part of an already validated row  
		return 0
		
	Case "SKU"
		this.SetItem(row, 'Serial_no', "") // blank the serial number as it must be entered after other values
		this.SetItem(row, 'Component_ind',"") // 01/03/2011 ujh: S/N_P:
		this.SetItem(row, 'SKU_Serial',"") // 01/03/2011 ujh: S/N_P:
		this.SetItem(row, 'Component_no', ll_null) // 01/03/2011 ujh: S/N_P:
		this.SetItem(row, 'Status',"")
		
		ib_rows_valid = false  // ujh 08/31/2010: added to stop changing only part of an already validated row  
		il_current_row = row  // ujh 08/31/2010: added to stop changing only part of an already validated row  

/*dts		ls_owner_cd =  this.getItemString(row, 'owner_cd')
		Select owner_id
		Into :ll_owner_id
		From Owner
		where project_id = 'PANDORA'
		and owner_cd = :ls_owner_cd;
*/	
		//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...modify code to use gs_project instead of Pandora
		
		
		Select sku,Container_Tracking_Ind
		into :ls_sku_db,:lsContainerTracking
		From Item_master
//		where project_id = 'PANDORA'
		where project_id = :gs_project
		and upper(sku) = upper(:data)
		and upper(serialized_ind) = 'B';
		
		//TimA 07/03/13 Lock or unlock the Field
		If lsContainerTracking = 'Y' then
			ls_color = string(RGB(255, 255, 255))
			lb_display_only = false
			lb_enabled = true
		Else
			ls_color = This.object.datawindow.color
			lb_display_only = true
			lb_enabled = false

		End if
		
		This.Object.Carton_Id.Protect = lb_display_only
		This.Modify("Carton_Id.Background.Color = '" +  ls_color + "'")
		
		if  upper(ls_sku_db) <> upper(data)  then
			messagebox('SKU Error', 'SKU  ' +upper(data) + ' not found in the database')
			this.SelectText(1,len(data))
			return 1   
		end if
		
		
	Case 'L_CODE'

		// LTK 20150122  Pandora #1002 - The following block was copied from w_ro and slightly modified
		// NOTE: if implementation flag (ib_is_pandora_single_project_location_rule_on) is not turned on, L_Code is not visible
		if gs_project = 'PANDORA' then

			String lsWarehouse, lsProject, ls_LocType, lsInvTyp, lsSku, ls_serial_ind, ls_po_no, ls_find, ls_empty_str, ls_uf18, ls_owner_code, ls_oracle_integrated
			Long llOwnerID, ll_found_row

			if isnull(data) or Trim( data ) = '' then Return

			lsWarehouse = this.GetItemString(row, "wh_code")
			if Len( lsWarehouse ) > 0 then
			else
				MessageBox("Add Serial","Please enter a warehouse first.",StopSign!)
				//f_setFocus( dw_serial_no_add_delete, row, 'Wh_Code' )
				Return 1
			end if

			ls_owner_code = String( this.Object.Owner_Cd[ row ] )
			if Len( ls_owner_code ) > 0 then
			else
				MessageBox("Add Serial","Please enter a Owner Code first.",StopSign!)
				//f_setFocus( dw_serial_no_add_delete, row, 'Owner_Cd' )
				Return 1
			end if

			ls_sku = Upper( Trim( this.GetItemString( row, 'sku' ) ))
			if Len( ls_sku ) > 0 then
			else
				MessageBox("Add Serial","Please enter a SKU first.",StopSign!)
				//f_setFocus( dw_serial_no_add_delete, row, 'sku' )
				Return 1
			end if

			ls_po_no = Upper( Trim( this.GetItemString( row, 'Po_No' ) ))
			if Len( ls_po_no ) > 0 then
			else
				MessageBox("Add Serial","Please enter a Project first.",StopSign!)
				//f_setFocus( dw_serial_no_add_delete, row, 'po_no' )
				This.SelectText(1, Len(this.GetText()))
				Return 1
			end if

			SELECT project_reserved, l_type
			INTO :lsProject, :ls_LocType
			FROM	location
			WHERE wh_code = :lsWarehouse 
			AND l_code = :data
			USING SQLCA;
			if sqlca.sqlcode = 100 then
				MessageBox("Add Serial","Location not found in warehouse: " + String( nz(lsWarehouse, ls_empty_str) ) + "~rPlease enter a valid location.",StopSign!)
				f_setFocus( dw_serial_no_add_delete, row, 'L_Code' )
				Return 1
			elseif sqlca.sqlcode = 0 Then
				//Check for project being reserved for a specific project
				If isnull(lsProject) or lsProject = '' Then
				Else
					If lsProject <> gs_project Then
						MessageBox("Add Serial","This Location is reserved by another project!",StopSign!)
						Return 1
					End If
				End If
				//TimA 02/12/14
				//Pandora #698 New MIX OWNER location type 6 to save multiple owners in one location
				//if gs_Project = 'PANDORA' and ( ls_LocType <> '9' and  ls_LocType <> '6' ) then
				// LTK 20150122  Added the IsNull() check so that nulls would drop into the "if" condition
				if gs_Project = 'PANDORA' and ( IsNull( ls_LocType ) or ( ls_LocType <> '9' and  ls_LocType <> '6' ) ) then
					// dts - 2010-08-19, allowing multiple owners for cross-dock locations (where l_type = '9')
					/* NOTE!!! 
					What if a Pick is generated (emptying location of certain owner/inv_typ), 
					then a Put-away succeeds (because material of different owner has been picked)
					then the pick is un-done, placing the inventory back in content???  */
	
					//ls_owner_code = String( this.Object.Owner_Cd[ row ] )
					SELECT owner_id
					INTO :llOwnerID
					FROM owner
					WHERE project_id = :gs_project
					AND owner_cd = :ls_owner_code
					USING SQLCA;

					if llOwnerID <= 0 then
						MessageBox( "Add Serial", "Owner ID could not be retrieved.", StopSign! )
						Return 1
					end if

					//check that location is either empty or contains only material of like Owner and Inventory Type
					//llOwnerID = this.getItemNumber(row, "owner_id", primary!, true)		// LTK getting this from above select
					//lsInvTyp = this.getItemString(row, "inventory_type", primary!, true)
					Select max(sku) into :lsSKU
					From	content
					Where project_id = 'PANDORA'
					and wh_code = :lsWarehouse and l_code = :data
					//and (owner_id <> :llOwnerID or Inventory_Type <> :lsInvTyp)
					and owner_id <> :llOwnerID
					Using SQLCA;
					
					If isnull(lsSKU) or lsSKU = '' Then
						//nothing in selected location that is a different Owner/InvType
					Else
						messagebox("Add Serial", "This Location already has material of a different Owner or Inventory Type!",StopSign!)
						Return 1
					End If					

					// LTK 20150122  Pandora #1002  SOC and GPN serial tracked inventory segregation by project
					if ib_is_pandora_single_project_location_rule_on then
						//ls_sku = Upper( Trim( this.GetItemString( row, 'sku' ) ))
						//ls_serial_ind = Upper( Trim( this.GetItemString( row, 'Serialized_Ind' ) ))
						//ls_po_no = Upper( Trim( this.GetItemString( row, 'Po_No' ) ))

						// Retrieve Serialized Ind as it's not contained in the serial table
						SELECT serialized_ind, user_field18
						INTO :ls_serial_ind, :ls_uf18
						FROM Item_Master	
						WHERE Project_Id = 'PANDORA'
						AND SKU = :ls_sku
						AND Supp_Code = 'PANDORA'
						USING SQLCA;

						if ls_serial_ind = 'B' or ls_serial_ind = 'O' or ls_serial_ind = 'Y' then

							// LTK 20150122  Added check that customer is Oracle Integrated
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
										// Copied validation from owner change window, Dave's code
										//For a Serialized SKU, need to limit location to single Project but allow other Projects for other SKUs.
										//  So, there can't be inventory for another OWNER (regardless of GPN), or another PROJECT (for the given GPN)
										select sum(avail_qty + tfr_in + alloc_qty) into :ld_other_owner_qty
										from content_summary
										where project_id = :gs_project
										and wh_code = :lsWarehouse 
										and l_code = :data
										and (owner_id <> :llOwnerID or (po_no <> :ls_po_no and sku = :ls_sku))
										Using SQLCA;

										If ld_other_owner_qty > 0 Then
											ls_error_msg = "Location (" +  data + ") contains inventory for a different Owner or Project.  Please move to a different location!"
											MessageBox("Add Serial", ls_error_msg, StopSign!)
											Return 1
										End If

										// LTK 20150122  Pandora #1002  SOC and GPN serial tracked inventory segregation by project
										//ls_find = "sku = '" + ls_sku + "' and l_code = '" + data + "' and owner_id = " + String( llOwnerID ) + " and po_no <> '" + ls_po_no + "'"
										//ls_find = "l_code = '" + data + "' and owner_id = " + String( llOwnerID ) + " and po_no <> '" + ls_po_no + "'"
										//ls_find = "l_code = '" + data + "' and po_no <> '" + ls_po_no + "'"
										ls_find = "wh_code = '" + lsWarehouse + "' and l_code = '" + data + "' and (owner_cd <> '" + ls_owner_code + "' or ( po_no <> '" + ls_po_no + "' and sku = '" + ls_sku + "' )) "
										
										ll_found_row = this.Find( ls_find, 1, this.RowCount() + 1 )
										if ll_found_row > 0 then
											MessageBox( "Add Serial", "This GPN is serialized and the Location entered already contains inventory for this GPN with a different Project within this window!", StopSign! )
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
		ib_rows_valid = TRUE
		Return 0

	CASE "SERIAL_NO"
		// blank remaining columns as they  must be entered after other values
		this.SetItem(row, 'Component_ind',"") // 01/03/2011 ujh: S/N_P:
		this.SetItem(row, 'SKU_Serial',"") // 01/03/2011 ujh: S/N_P:
		this.SetItem(row, 'Component_no', ll_null) // 01/03/2011 ujh: S/N_P:
		this.SetItem(row, 'Status',"")
//		if isnull(data)  or data = ''  or data = '-' then
//			messagebox('SN Error', 'Serial Number must not be null, blank or dash.  Please re-enter')
//			this.SelectText(1,len(data))     // ujh 09/01/2010
//			return 1
			ll_return = pos(Trim(data), ' ', 1)
			If Not len(trim(data)) > 0 or ll_return <> 0 then
				messagebox('SN Validation', 'Serial Numbers must not be null, blank or contain spaces')
				This.SetFocus()
				This.SelectText(1, Len(this.GetText()))
				return 1
			elseif data = '-' then
				messagebox('SN Validation', 'Dash is an not valid')
			else
				data = upper(data)  // Set to all caps
			end if
			
			
//		else
			
			ls_wh_code = this.getItemString(row,'wh_code')
			ls_owner_cd =  this.getItemString(row, 'owner_cd')
			ls_sku = this.getItemString(row, 'sku')
			
			if isnull(ls_wh_code) or ls_wh_code = '' or isnull(ls_owner_cd) or ls_owner_cd = '' or isnull(ls_sku) or ls_sku = ''  then
				messagebox('Serial No Error', 'Please enter Wh_code, Owner_ID, and SKU before entering Serial Number')
				This.SetItem(row, 'Serial_no', '')  // ujh 09/01/2010
				this.SelectText(1,1)   // ujh 09/01/2010
				return 2
			end if
			
			// Determin whether the serial no already in this list
			
			For i_indx = 1 to this.RowCount()
				if this.GetItemString(i_indx, 'Serial_no') = data then
					MessageBox('Serial No Error', 'This serial number already used in row '+ string(i_indx,'0'))
					this.SelectText(1,len(data))     // ujh 09/01/2010
					ib_rows_valid = false
					return 1
				end if
				
			next
			
			//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...modify code to use gs_project instead of Pandora
			Select Serial_no 
			Into :ls_serial_no_db
			From Serial_number_inventory
//			Where Project_id = 'PANDORA'
			Where Project_id = :gs_project
			and serial_no = :data;
			
			
			if upper(is_current_window) = 'ADD' then
				if not(isnull(ls_serial_no_db) or ls_serial_no_db = '') then  // Serial number existed on Data base and can't be used
					messagebox('Serial No Error', 'Serial No = '+data+' already exists in the database.')
					this.SelectText(1,len(data))     // ujh 09/01/2010
					ib_rows_valid = false
					return 1
				end if	
				
			// LTK 20160401  Serial number mask validation
			if gs_project = 'PANDORA' then
				String ls_return
				n_warehouse ln_nwarehouse
				ln_nwarehouse = CREATE n_warehouse
		
				ls_return = ln_nwarehouse.of_validate_serial_format( ls_SKU, data, 'PANDORA' )
				DESTROY ln_nwarehouse
				if ls_return <> "" then
					Messagebox( 'Serial No Error',ls_return )
					This.SetItem(row, 'new_serial_number', '')  // blank out the scanned data
					return 1
				end if
			end if
				
			else
					if (isnull(ls_serial_no_db) or ls_serial_no_db = '') then  // Serial number did not exist on Data base and can't be deleted
					messagebox('Serial No Error', 'Serial No = '+data+' DOES NOT exist in the database.')
//					This.SetItem(row, 'Serial_no', '-')   // ujh 09/01/2010
					this.SelectText(1,len(data))  // ujh 09/01/2010
					ib_rows_valid = false
					return 1
				else
//					il_current_row = 0   //Zero is just a release to work in conjunction with ib_rows_valid for RowFocusChanging. needs better name
					il_current_row = row   // ujh 08/31/2010 Fix  getting message after delete row on append row
					ib_rows_valid = true
//					return 0
				end if	
				
			end if
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				/* 01/03/2011 ujh: S/N_P: WATCH  Removed this whole section because we now have additional columns.  
					If the last column validates, then the row can be set to valid. and status cleared*/
//			this.SetItem(row, 'Status','')
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			return 0
//		end if
/////////////////////////////    End Serial no    ////////////////////////////////////////////////////////////////////////////

		
		// 01/03/2011 ujh: S/N_P  All of Case Component_ind is new
		Case "COMPONENT_IND"   //01/03/2011 ujh: S/N/_P:  Validate Component Ind
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/*01/03/2011 ujh: S/N_P:  
   		NOTE:  No validation to force components to add/delete parts in serial_number_inventory according to the BOM
			has been done.  It is therefore possible to delete a single component without forcing the deletion of the other
			components for a parent and it is possible to ADD disproportinate component quantities for a given parent.  
			Dave agreed that we would not put this in at this time.
			Code does exist to prevent deletion of a parent until all its children have been deleted. */	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			// blank remaining columns as they  must be entered after other values
			this.SetItem(row, 'Component_no', ll_null) // 01/03/2011 ujh: S/N_P:
			this.SetItem(row, 'Status',"")
			
			ls_wh_code = this.getItemString(row,'wh_code')
			ls_owner_cd =  this.getItemString(row, 'owner_cd')
			ls_sku = this.getItemString(row, 'sku')
			ls_Serialno_entered = this.getItemString(row, 'Serial_no')
			
			
			if isnull(ls_wh_code) or ls_wh_code = '' or isnull(ls_owner_cd) or ls_owner_cd = ''&
				or isnull(ls_sku) or ls_sku = ''  or ls_serialno_entered = '' then
				messagebox('Component Ind Error', 'Please enter Wh_code, Owner_CD, SKU, and Serial No before entering Component_Ind')
				This.SetItem(row, 'Component_Ind', '')  
				this.SelectText(1,1)   
				return 2
			end if

			Choose Case upper(data)  
				case ''   // ujh:  a way to cancel and tab to other columns on this current row.
					/* 01/03/2011 ujh: S/N_P:  Return zero to allow tabbing away while the data remains blank.  
					If the user closes without writing to the database, no problem.  But if insert is attempted an error 
					will occur, as ther row is not valid*/
					Messagebox('Component Ind Error', 'This row will not be valid with any value other than *,Y, or N')
					 ib_rows_valid = false
					return 0 
				case '*'   // Component Part
					//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...modify code to use gs_project instead of Pandora
					Select Count(*) into :ll_return from Item_Component
//					where project_id = 'Pandora'
					where project_id = :gs_project
					and SKU_Child = :ls_sku;

					if not(ll_return > 0) then 
						messagebox('Component_Ind Error', 'This item has no parent')
						return 1
					end if
					
					istr_srno_parms.String_arg[1] = ls_owner_cd
					istr_srno_parms.String_arg[2] = ls_sku
					
					/*There could be multiple possibilites, so the operator will  have to determine to which parent 
						this component belongs */
					OpenWithParm(w_sku_serialno_select, istr_srno_parms)
					istr_srno_parms = message.PowerobjectParm 
					ll_return = long(istr_srno_parms.String_arg[3])
					
					/* check the return codes from the operator's selection
						0 = a selection was made
						1 = operator cancelled 
						2 = the item is already in the table */
					choose case ll_return
						case 0
						ls_sku_serial = istr_srno_parms.String_arg[4]
						ls_Parent_SKU =  istr_srno_parms.String_arg[5]   // 01/03/2011 ujh: S/N_Pd  force component to  match bom
						ll_Parent_CompNo = long(istr_srno_parms.String_arg[7])
//						this.SetItem(row, 'Sku_Serial',ls_sku_serial )
//						this.SetItem(row, 'Component_no', ll_Parent_CompNo)
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////					
						 // 01/03/2011 ujh: S/N_Pd   Begin force component to  match bom
						// Determine whether adding this component will break the proportionate qty for this parent
						// Get the child qty from the bom
						Select Child_qty
						Into :ll_child_qty_bom
						from Item_component 
						where sku_child = :ls_sku
						and sku_parent = :ls_Parent_SKU;
						
						// Now determin the number of Component parts for this parent are already in serial_number_inventory
						Select count(*) 
						into :ll_child_qty_sni
						from
						(select distinct snic.Serial_no
						from Serial_Number_inventory snip
						join Serial_number_inventory snic on snic.component_no = snip.component_no
						and snic.component_ind = '*'
						and snic.Sku = :ls_sku
						and snic.component_no = :ll_Parent_CompNo) rec_count;
						
						if ll_child_qty_bom <= ll_child_qty_sni then
							messagebox('Component Qty Error', 'The number of components for this parent already reached')
						 	ib_rows_valid = false
							return 1
						end if
						// 01/03/2011 ujh: S/N_Pd   End force component to  match bom
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////					
						
						 il_current_row =  row  
						 ib_rows_valid = true
						case 1   // cancel
							this.SetItem(row, 'Component_ind',"") 
							messagebox('Entry Info', 'Action Canceled.  Please reselect')
							ib_rows_valid = false
							return 2
						case 2
						messagebox('Entry Error', 'This item already in table or No db record matches Serial No SKU combo')
						 ib_rows_valid = false
						return 1
				end choose  // End ll_return cases
					this.SetItem(row, 'Sku_Serial',ls_sku_serial )
					this.SetItem(row, 'Component_no', ll_Parent_CompNo)
					this.SetItem(row, 'Status','')
					return 0
				case 'N'  // Stand alone parts
						 ib_rows_valid = true
						return 0
				Case 'Y'    // Parent parts
					Select  Count(*) into :ll_return  from Item_Component
					where upper(project_id) =  upper(:gs_project)
					and SKU_Parent = :ls_sku;
					if not (ll_return > 0) then 
						messagebox('Component_Ind Error', 'This item has no children')
						return 1
					end if
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////				
//					 01/03/2011 ujh: S/N_P: Get Component No for this parent where this part is not already in the table

					//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...modify code to use gs_project instead of Pandora
					select Distinct   rpParent.Component_no, ic.SKU_Parent , rpParent.Serial_no 
					INTO  :ll_Parent_CompNo,  :ls_Parent_SKU, :ls_Parent_Serialno
					from Item_component as ic
					join Receive_Putaway rpParent on rpParent.SKU = ic.SKU_parent
					join owner o on o.owner_id = rpParent.owner_id  /*linking child owner to parent recieve putaway record*/
//					and o.Project_id = 'PANDORA'
					and o.Project_id = :gs_project
					and rpParent.SKU = ic.SKU_Parent   /* linking parent to receive putaway parent */
					and rpParent.Component_ind = 'Y'
					and ic.SKU_Parent not in (Select SKU from Serial_number_inventory where Sku = :ls_sku and Serial_no = :ls_Serialno_entered)
					and o.Owner_cd = :ls_owner_cd  /* using the child owner_cd because by rule it is the same as its parent's.*/
					and ic.SKU_Parent = :ls_sku
					and rpParent.Serial_no = :ls_Serialno_entered
					USING SQLCA;
					
	
					/*  If not found,
						it means that the info was not correctly copied into this line or the part has not been received*/
					// if found skip not found processing use the component_no found.
					if not (ll_Parent_CompNo > 0)  then  
						// not found so create the component_no after making sure the item is in item_master
	
						Select Count(*)
						into :ll_return
						From Item_master 
						where  upper(Project_id) =  upper(:gs_project)
						and sku = :ls_sku
						USING SQLCA;
	
	
						If ll_return = 0 then
							messagebox('Entry Error', 'This item not in Item_master')
							 ib_rows_valid = false
							return 1
						elseif ll_return > 1 then
							messagebox('Entry Error', 'There are more than one in Item Master')
							ib_rows_valid =false
							return 1
						else
							// Get the next sequence for component_no
							sqlca.sp_next_avail_seq_no(gs_project,"Content","Component_No" ,ld_next) //get the next available RO_NO
							IF SQLCA.SQLCode = -1 THEN 
						        MessageBox("SQL error", SQLCA.SQLErrText)
								  return 1
							END IF
							 ll_Parent_CompNo = long(ld_next)

						end if
					end if
					// Component_no was found or was created
					this.SetItem(row, 'Component_no', ll_Parent_CompNo)
					this.SetItem(row, 'Sku_Serial', ls_Parent_SKU+ ' -- ' +ls_Parent_Serialno)
					il_current_row =  row   // ujh 08/31/2010 Fix  getting message after delete row on append row
					ib_rows_valid = true
					this.SetItem(row, 'Status','')
					// Post saving this item to  the end of the event que.
					if  cb_exec_db_action.PostEvent(Clicked!) then
						return 0
					else 
						messagebox('Save Error', 'could not insert this item into database')
						return 1
					end if
			End choose   // end upper(data) cases
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////				

Case Else   //01/03/2011 ujh: S/N/_P
			return 0
	
End Choose   // end upper(ls_name) cases for various columns




end event

event rowfocuschanging;
// If the row being serviced is not valid  or is not the first row, then error
If not ( ib_rows_valid or il_current_row = 0) then
	messagebox('Incomplete Row Error', 'Please complete current row before changing to other rows')
	return 1
else
	// 01/03/2011 ujh: S/N:  set valid rows sku and serial number to upper case
	if il_current_row > 0 then
		this.SetItem(currentrow, 'SKU',upper(this.GetitemString(currentrow, 'SKU')))
		this.SetItem(currentrow, 'Serial_no',upper(this.GetitemString(currentrow, 'Serial_no')))
	end if
	return 0
end if
end event

event constructor;
//BCR 06-JAN-2012: Use different dw for Bluecoat ...
IF Upper(gs_project) = 'BLUECOAT' THEN
	THIS.dataObject = 'd_sn_add_delete_for_sn_inventory_nonpandora'
END IF
end event

