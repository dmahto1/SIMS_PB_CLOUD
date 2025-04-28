HA$PBExportHeader$u_dw_import_update_nike_order.sru
$PBExportComments$EUT (Outbound Orders) file
forward
global type u_dw_import_update_nike_order from u_dw_import
end type
end forward

global type u_dw_import_update_nike_order from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_nike_update_ship_lob_region"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_update_nike_order u_dw_import_update_nike_order

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

public function integer wf_save ();//
////Upon validation pass ,  for each SHP (order no) update the corresponding fields in SIMS with those data found in the excel file $$HEX1$$1320$$ENDHEX$$Batch No (LOB) , Region, Carton Remarks and Remarks.
////If the SHP (order no) contain batch no, ship date, region, carton remark and remarks fields in the excel file contain blank, do not update blank to the corresponding  field in SIMS. Remain the corresponding field in SIMS as it is.
////System will prompt status of posting successful upon completion of the upload.
////
//
//
////$$HEX1$$1320$$ENDHEX$$Batch No (LOB) , Region, Carton Remarks and Remarks.
//

long llRow
string lsDoNo
boolean ib_fail = false
string lsBatch, lsRegion, lsCartonRemarks, lsRemarks

For llRow = 1 to this.RowCount()  


	lsDoNo = this.GetItemString( llRow, "do_no") 
	
	lsBatch = this.GetItemString( llRow, "batch_no") 
	lsRegion = this.GetItemString( llRow, "region") 
	lsCartonRemarks = this.GetItemString( llRow, "carton_remarks") 
	lsRemarks = this.GetItemString( llRow, "remarks") 

	//LOB
	
	If Not IsNull(lsBatch) and trim(lsBatch) <> '' then
				
		UPDATE Delivery_Master 
			Set line_of_business = :lsBatch Where Do_No = :lsDoNo USING SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			MessageBox("Import","Unable to Update LOB - " + SQLCA.SQLErrText)
			Return -1
		End If		
		

	End If
		
		
	//Region
	
	If Not IsNull(lsRegion) and trim(lsRegion) <> '' then
				
		UPDATE Delivery_Master 
			Set user_field13 = :lsRegion Where Do_No = :lsDoNo USING SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			MessageBox("Import","Unable to Update Region - " + SQLCA.SQLErrText)
			Return -1
		End If		
		

	End If		
		
		
	//remark
	
	If Not IsNull(lsRemarks) and trim(lsRemarks) <> '' then
				
		UPDATE Delivery_Master 
			Set remark = :lsRemarks Where Do_No = :lsDoNo USING SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			MessageBox("Import","Unable to Update Remark - " + SQLCA.SQLErrText)
			Return -1
		End If		
		

	End If	


	//Carton Remarks
	
	If Not IsNull(lsCartonRemarks) and trim(lsCartonRemarks) <> '' then
				
		UPDATE Delivery_Master 
			Set User_Field20 = :lsCartonRemarks Where Do_No = :lsDoNo USING SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			MessageBox("Import","Unable to Update Carton Remarks - " + SQLCA.SQLErrText)
			Return -1
		End If		
		

	End If
		
	COMMIT using SQLCA;

Next /*Next Import Column*/



MessageBox("Import","Records saved.~r~rDelivery Orders Updated : " + String( this.RowCount() ))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)

Return 0

end function

on u_dw_import_update_nike_order.create
call super::create
end on

on u_dw_import_update_nike_order.destroy
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
        FROM Delivery_Master   
			Where Project_id = :gs_project AND Delivery_Master.Invoice_No = :lsOrderNo USING SQLCA;
			
		IF SQLCA.SQLCode <> 0 THEN
			
			ib_fail = true

			MessageBox ("Error", "Order No: " + lsOrderNo + " is not a valid order number.")
			
			
		ELSE	
			
			this.SetItem( llRowPOs, "do_no", lsDoNo) 
			
			IF lsOrdStatus = 'C' OR lsOrdStatus = 'V' THEN
			
				ib_fail = true

				MessageBox ("Error", "Order No: " + lsOrderNo + "  cannot be 'Completed' or 'Voided'.")
			
			
			END IF	
		
			
		END IF
		
		

	
	
	END IF
	

	
Next


w_main.SetMicroHelp("Ready")

IF ib_fail = true THEN
	
	RETURN -1
	
END IF


Return 0
end event

