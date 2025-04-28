$PBExportHeader$u_dw_import_powerwave_ord_ship_status.sru
$PBExportComments$Pallet/Serial Import format for Bluecoat
forward
global type u_dw_import_powerwave_ord_ship_status from u_dw_import
end type
end forward

global type u_dw_import_powerwave_ord_ship_status from u_dw_import
integer width = 4384
integer height = 1700
string dataobject = "d_import_powerwave_ord_shp_status"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_powerwave_ord_ship_status u_dw_import_powerwave_ord_ship_status

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);string		ls_status_cd
string		ls_status_desc

SetNull( ls_status_desc )

// Confirm order status is in shipment_status_code table

ls_status_cd = this.GetItemString( al_row, 'status_code' )

SELECT DESCRIPTION
   INTO :ls_status_desc
  FROM SHIPMENT_STATUS_CODE
WHERE STATUS_CODE = :ls_status_cd
USING SQLCA;

If sqlca.sqlcode < 0 Then
	
	Messagebox("Import","Unable to verify status code ~r~r" + sqlca.sqlerrtext)
	SetPointer(Arrow!)
	RETURN 'Status Code validation error'

End If

IF IsNull( ls_status_desc ) = TRUE THEN
	
	RETURN 'Invalid Status Code - ' + ls_status_cd
	
END IF

return ''

end function

public function integer wf_save ();Long	llRowCount,	&
		llRowPos,	&
		llNew		
		
String	lsSku,		&
			lsStatusCode,	&
			lsShipNo,	&
			lsCarton,	&
			lsSerial,	&
			lsErrText,	&
			lsSQL
			
String		ls_ship_status_line_no
Long		ll_ship_status_line_no
date		ldt_status_date


Datetime		ldToday

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( gs_default_wh ) 
//ldToday = Today()

llRowCount = This.RowCount()

llNew = 0

SetPointer(Hourglass!)

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

//Update or Insert for each Row...
For llRowPos = 1 to llRowCount
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsShipNo = This.GetItemString(llRowPos, "ship_no")
	lsStatusCode = This.GetItemString(llrowPos, "status_code")
	
	IF IsDate( This.GetItemString(llrowPos,"status_date") ) THEN
		
		ldt_status_date = Date(This.GetItemString(llrowPos,"status_date") )
	
	ELSE
		
		ldt_status_date = Today()
	
	END IF
	
	ll_ship_status_line_no = 0
	
	SELECT MAX(CONVERT(INT,SHIP_STATUS_LINE_NO))
		INTO :ll_ship_status_line_no
	  FROM SHIPMENT_STATUS
	WHERE SHIP_NO = :lsShipNo
	USING SQLCA;
	
	IF IsNull( ll_ship_status_line_no ) THEN ll_ship_status_line_no = 0
	
	//Add 1 for adding a new status line below
	ll_ship_status_line_no = ll_ship_status_line_no + 1
		
	//Convert line number back to string for database update
	ls_ship_status_line_no = String( ll_ship_status_line_no )

	// Add a new record to Shipment_Status
	// If ll_ship_status_line_no = 1 THEN build new record with just the status code and status date - all other columns default 
	IF ll_ship_status_line_no = 1 THEN
		
		INSERT INTO SHIPMENT_STATUS
		( Ship_No          
			,Ship_Status_Line_No 
			,Status_Code 
			,Status_Date )
		VALUES ( :lsShipNo, :ls_ship_status_line_no, :lsStatusCode, :ldt_status_date )
		USING SQLCA;
		
	ELSE
		
		INSERT INTO SHIPMENT_STATUS
		( Ship_No          
			,Ship_Status_Line_No 
			,Status_Code 
			,Status_Modifier 
			,Status_Date             
			,Status_Source 
			,Pro_No                 
			,City                           
			,State                                    
			,ISO_Country_Code 
			,Over_Qty                                
			,Short_Qty                               
			,Damaged_Qty                             
			,Container_ID 
			,Ctn_Cnt                                 
			,Remark                                                                                                                                                                                                                                                     
			,Last_User  
			,Last_Update             
			,Create_User 
			,Create_User_Date        
			,Time_Zone_ID )
		SELECT Ship_No          
			,:ls_ship_status_line_no
			,:lsStatusCode
			,Status_Modifier 
			,:ldt_status_date             
			,Status_Source 
			,Pro_No                 
			,City                           
			,State                                    
			,ISO_Country_Code 
			,Over_Qty                                
			,Short_Qty                               
			,Damaged_Qty                             
			,Container_ID 
			,Ctn_Cnt                                 
			,Remark                                                                                                                                                                                                                                                     
			,Last_User  
			,Last_Update             
			,Create_User 
			,Create_User_Date        
			,Time_Zone_ID
		FROM SHIPMENT_STATUS
		WHERE SHIP_NO = :lsShipNo
			 AND SHIP_STATUS_LINE_NO = :ll_ship_status_line_no - 1
		 USING SQLCA;

	END IF

	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	Else
		llnew ++
	End If
	
	// Update Shipment table with new status
	UPDATE Shipment
	      SET Ord_Status = :lsStatusCode
				,Ord_Status_Date = GETDATE()
	 WHERE Ship_No = :lsShipNo
	     AND Project_ID = :gs_project
       USING SQLCA; 
	
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Unable to update Shipment table!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	End If
	
Next

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

MessageBox("Import","Records Updated: " + String(llNew))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

on u_dw_import_powerwave_ord_ship_status.create
call super::create
end on

on u_dw_import_powerwave_ord_ship_status.destroy
call super::destroy
end on

event ue_pre_validate;call super::ue_pre_validate;//May need to add validation of order status here?
RETURN 0
end event

