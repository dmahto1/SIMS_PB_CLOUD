$PBExportHeader$u_dw_import_update_klonelab_3rd_global_edit.sru
$PBExportComments$EUT (Outbound Orders) file
forward
global type u_dw_import_update_klonelab_3rd_global_edit from u_dw_import
end type
end forward

global type u_dw_import_update_klonelab_3rd_global_edit from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_update_klonelab_3rd_global_edit"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_update_klonelab_3rd_global_edit u_dw_import_update_klonelab_3rd_global_edit

type variables

Datastore	idsItem

string is_dw_name[]
end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);
return ''

end function

public function integer wf_save ();

long llRow
string lsDoNo
boolean ib_fail = false
integer liCount


string	lsTraxName, lsTraxAddress, lsTraxCity, lsTraxZip, lsTraxState, lsTraxCountry,	lsTraxTelephone, lsPlanner, lsPickedBy, lsTraxAccountNumber, lsCarrier, lsUccLabelReq,	lsBol,	lsUserfield11

For llRow = 1 to this.RowCount()  


	lsDoNo = this.GetItemString( llRow, "do_no") 
	
	lsTraxName  = this.GetItemString( llRow, "trax_name") 
	lsTraxAddress  = this.GetItemString( llRow, "trax_address") 
	lsTraxCity  = this.GetItemString( llRow, "trax_city") 
	lsTraxZip = this.GetItemString( llRow, "trax_zip") 
	lsTraxState = this.GetItemString( llRow, "trax_state") 
	lsTraxCountry = this.GetItemString( llRow, "trax_country") 
	lsTraxTelephone = this.GetItemString( llRow, "trax_telephone") 
	lsPlanner = this.GetItemString( llRow, "planner") 
	lsPickedBy = this.GetItemString( llRow, "picked_by") 
	lsTraxAccountNumber = this.GetItemString( llRow, "trax_account_number") 
	lsCarrier = this.GetItemString( llRow, "carrier") 
	lsUccLabelReq = this.GetItemString( llRow, "ucc_label_req") 
	lsBol = this.GetItemString( llRow, "bol") 
	lsUserfield11 = this.GetItemString( llRow, "user_field11") 
	
	
		If (Not IsNull(lsTraxName) and trim(lsTraxName) <> '') OR &
		   (Not IsNull(lsTraxAddress) and trim(lsTraxAddress) <> '') OR &
		   (Not IsNull(lsTraxCity) and trim(lsTraxCity) <> '') OR &
		   (Not IsNull(lsTraxZip) and trim(lsTraxZip) <> '') OR &
		   (Not IsNull(lsTraxState) and trim(lsTraxState) <> '') OR &
		   (Not IsNull(lsTraxCountry) and trim(lsTraxCountry) <> '') OR &
		   (Not IsNull(lsTraxTelephone) and trim(lsTraxTelephone) <> '')  then
			
		
			
			select count(do_no) into :liCount from delivery_alt_address where do_no = :lsDoNo and Address_Type = '3P' USING SQLCA;
			
			if liCount > 0 then
				
				//1.1.1.1	Name 

				If Not IsNull(lsTraxName) and trim(lsTraxName) <> '' then
							
					UPDATE Delivery_Alt_Address 
						Set Name = :lsTraxName Where Do_No = :lsDoNo and Address_Type = '3P' USING SQLCA;
					
					If sqlca.sqlcode <> 0 Then
						MessageBox("Import","Unable to Update Trax Name - " + SQLCA.SQLErrText)
						Return -1
					End If		
				
				End If
	
				//1.1.1.2	Address
				
				If Not IsNull(lsTraxAddress) and trim(lsTraxAddress) <> '' then
							
					UPDATE Delivery_Alt_Address 
						Set Address_1 = :lsTraxAddress Where Do_No = :lsDoNo and Address_Type = '3P' USING SQLCA;
					
					If sqlca.sqlcode <> 0 Then
						MessageBox("Import","Unable to Update Trax Address - " + SQLCA.SQLErrText)
						Return -1
					End If		
				
				End If			
			
				//1.1.1.3	City
				
				If Not IsNull(lsTraxCity) and trim(lsTraxCity) <> '' then
							
					UPDATE Delivery_Alt_Address 
						Set City = :lsTraxCity Where Do_No = :lsDoNo and Address_Type = '3P' USING SQLCA;
					
					If sqlca.sqlcode <> 0 Then
						MessageBox("Import","Unable to Update Trax City - " + SQLCA.SQLErrText)
						Return -1
					End If		
				
				End If	
				
				//1.1.1.4	
				
				If Not IsNull(lsTraxZip) and trim(lsTraxZip) <> '' then
							
					UPDATE Delivery_Alt_Address 
						Set Zip = :lsTraxZip Where Do_No = :lsDoNo and Address_Type = '3P' USING SQLCA;
					
					If sqlca.sqlcode <> 0 Then
						MessageBox("Import","Unable to Update Trax Zip - " + SQLCA.SQLErrText)
						Return -1
					End If		
				
				End If	
				
				
				//1.1.1.5	State
				
				If Not IsNull(lsTraxState) and trim(lsTraxState) <> '' then
							
					UPDATE Delivery_Alt_Address 
						Set State = :lsTraxState Where Do_No = :lsDoNo and Address_Type = '3P' USING SQLCA;
					
					If sqlca.sqlcode <> 0 Then
						MessageBox("Import","Unable to Update Trax State - " + SQLCA.SQLErrText)
						Return -1
					End If		
				
				End If					
				
				
				//1.1.1.6	Country
				
				If Not IsNull(lsTraxCountry) and trim(lsTraxCountry) <> '' then
							
					UPDATE Delivery_Alt_Address 
						Set Country = :lsTraxCountry Where Do_No = :lsDoNo and Address_Type = '3P' USING SQLCA;
					
					If sqlca.sqlcode <> 0 Then
						MessageBox("Import","Unable to Update Trax Country - " + SQLCA.SQLErrText)
						Return -1
					End If		
				
				End If					
				
				
				//1.1.1.7	Telephone

				If Not IsNull(lsTraxTelephone) and trim(lsTraxTelephone) <> '' then
							
					UPDATE Delivery_Alt_Address 
						Set tel = :lsTraxTelephone Where Do_No = :lsDoNo and Address_Type = '3P' USING SQLCA;
					
					If sqlca.sqlcode <> 0 Then
						MessageBox("Import","Unable to Update Trax Telephone - " + SQLCA.SQLErrText) // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
						// MessageBox("Import","Unable to Update Trax Telephone - " + SQLCA.SQLErrText)
						Return -1
					End If		
				
				End If		
			
			else
				
				//No Trax Address
				//Create
				
				insert into delivery_alt_address (do_no, project_id, Address_Type, Name, Address_1, City, Zip, State, Country, Tel )
				values (:lsDoNo, :gs_project, '3P', :lsTraxName, :lsTraxAddress, :lsTraxCity, :lsTraxZip, :lsTraxState, :lsTraxCountry,	:lsTraxTelephone) USING SQLCA;
				
				If sqlca.sqlcode <> 0 Then
					//MessageBox("Import","Unable to Insert Trax Address - " + SQLCA.SQLErrText)
					MessageBox("Import","Unable to Insert ConnectShip Address - " + SQLCA.SQLErrText) // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
					Return -1
				End If		

				
				
			end if
			
		end if
	
	
		//1.2.1	Input our Planner
		
		If Not IsNull(lsPlanner) and trim(lsPlanner) <> '' then
					
			UPDATE Delivery_Master 
				Set User_Field16 = :lsPlanner Where Do_No = :lsDoNo USING SQLCA;
			
			If sqlca.sqlcode <> 0 Then
				MessageBox("Import","Unable to Update Planner - " + SQLCA.SQLErrText)
				Return -1
			End If		
	
		End If		
		
		
		//1.2.2	Picked by
		
		If Not IsNull(lsPickedBy) and trim(lsPickedBy) <> '' then
					
			UPDATE Delivery_Master 
				Set User_Field18 = :lsPickedBy Where Do_No = :lsDoNo USING SQLCA;
			
			If sqlca.sqlcode <> 0 Then
				MessageBox("Import","Unable to Update Picked By - " + SQLCA.SQLErrText)
				Return -1
			End If		
	
		End If			
		
		//1.2.3	Trax Acct No
		
		If Not IsNull(lsTraxAccountNumber) and trim(lsTraxAccountNumber) <> '' then
					
			UPDATE Delivery_Master 
				Set trax_acct_no = :lsTraxAccountNumber Where Do_No = :lsDoNo USING SQLCA;
			
			If sqlca.sqlcode <> 0 Then
				MessageBox("Import","Unable to Update ConnectShip Acct No - " + SQLCA.SQLErrText) // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
				//MessageBox("Import","Unable to Update Trax Acct No - " + SQLCA.SQLErrTe
				Return -1
			End If		
	
		End If				
		
		//1.2.4	Carrier 
		
		If Not IsNull(lsCarrier) and trim(lsCarrier) <> '' then
					
			UPDATE Delivery_Master 
				Set carrier = :lsCarrier Where Do_No = :lsDoNo USING SQLCA;
			
			If sqlca.sqlcode <> 0 Then
				MessageBox("Import","Unable to Update Carrier - " + SQLCA.SQLErrText)
				Return -1
			End If		
	
		End If						
		
		//1.2.5	UCC Label Req
		
		If Not IsNull(lsUccLabelReq) and trim(lsUccLabelReq) <> '' then
					
			UPDATE Delivery_Master 
				Set User_Field13 = :lsUccLabelReq Where Do_No = :lsDoNo USING SQLCA;
			
			If sqlca.sqlcode <> 0 Then
				MessageBox("Import","Unable to Update UCC Label Required - " + SQLCA.SQLErrText)
				Return -1
			End If		
	
		End If		
		
		//1.2.6	BOL
		
		If Not IsNull(lsBol) and trim(lsBol) <> '' then
					
			UPDATE Delivery_Master 
				Set User_Field19 = :lsBol Where Do_No = :lsDoNo USING SQLCA;
			
			If sqlca.sqlcode <> 0 Then
				MessageBox("Import","Unable to Update UCC Label Required - " + SQLCA.SQLErrText)
				Return -1
			End If		
	
		End If			
		
		//1.2.7	User Code Field 11:  
		//1.2.7.1	if the store # starts with a 9 we use ACCT Code 2RV702
		//1.2.7.2	if the store # starts with a 5 we use ACCT Code 2RV705
		
		If Not IsNull(lsUserfield11) and trim(lsUserfield11) <> '' then
					
			UPDATE Delivery_Master 
				Set User_Field11 = :lsUserfield11 Where Do_No = :lsDoNo USING SQLCA;
			
			If sqlca.sqlcode <> 0 Then
				MessageBox("Import","Unable to Update User Field 11 - " + SQLCA.SQLErrText)
				Return -1
			End If		
	
		End If				
		
		
					
		UPDATE Delivery_Master 
			Set Freight_Terms = 'THIRDPARTY'  Where Do_No = :lsDoNo USING SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			MessageBox("Import","Unable to Update Freight_Terms to 'THIRDPARTY' - " + SQLCA.SQLErrText)
			Return -1
		End If		
	
	
		

		
	COMMIT using SQLCA;

Next /*Next Import Column*/



MessageBox("Import","Records saved.~r~rDelivery Orders Updated : " + String( this.RowCount() ))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)

Return 0

end function

on u_dw_import_update_klonelab_3rd_global_edit.create
call super::create
end on

on u_dw_import_update_klonelab_3rd_global_edit.destroy
call super::destroy
end on

event ue_pre_validate;call super::ue_pre_validate;
Long	llRowPos, llRowCount, llFindRow
string lsOrderNo, lsOrdStatus, lsDoNo

boolean ib_Fail = false
integer li_count

//At process of uploading , system to perform validation 
//a)	the records  lines to ensure order No (SHP) specified exist in SIMS. 
//b)	Order status <> VOID or COMPLETED.
//System will reject the file if the above condition occur and user will be prompted on this.
//Do not perform update until all the record in the file pass validation.



//Loop thru Items and preload into DS
lLRowCount = This.RowCount()

For llRowPOs = 1 to llRowCount
	
	w_main.SetMicroHelp("Retrieving ItemMaster information for row: " + String(lLRowPos))
	
	
	lsOrderNo = this.GetItemString( llRowPOs, "order_no") 
		
	IF Not IsNull(lsOrderNo) AND trim(lsOrderNo) <> "" THEN	
		
	
	   SELECT  Delivery_Master.Ord_Status, do_no  INTO :lsOrdStatus, :lsDoNo
          FROM Delivery_Master With (NoLock)  
			Where Project_id = :gs_project AND Delivery_Master.Invoice_No = :lsOrderNo and Ord_Status not in ('C','V')  USING SQLCA;
			
		IF SQLCA.SQLCode <> 0 THEN
			
					SELECT  Top 1 Delivery_Master.Ord_Status, do_no  INTO :lsOrdStatus, :lsDoNo
   				     FROM Delivery_Master With (NoLock)  
					Where Project_id = :gs_project AND Delivery_Master.Invoice_No = :lsOrderNo and Ord_Status  in ('C','V')  USING SQLCA;

			
					IF SQLCA.SQLCode <> 0 THEN			
						
						ib_fail = true

						MessageBox ("Error", "Order No: " + lsOrderNo + " is not a valid order number.")
			
					ELSE	
					
						
						IF lsOrdStatus = 'C' OR lsOrdStatus = 'V' THEN
						
							ib_fail = true
			
							MessageBox ("Error", "Order No: " + lsOrderNo + "  cannot be 'Completed' or 'Voided'.")
						
						
						END IF	
					
				END IF
		ELSE		
		
			this.SetItem( llRowPOs, "do_no", lsDoNo) 
		
		END IF
	
	END IF
	

	
Next


w_main.SetMicroHelp("Ready")

IF ib_fail = true THEN
	
	RETURN -1
	
END IF


Return 0
end event

