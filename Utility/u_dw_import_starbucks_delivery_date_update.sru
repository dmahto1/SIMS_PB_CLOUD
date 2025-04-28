HA$PBExportHeader$u_dw_import_starbucks_delivery_date_update.sru
forward
global type u_dw_import_starbucks_delivery_date_update from u_dw_import
end type
end forward

global type u_dw_import_starbucks_delivery_date_update from u_dw_import
integer width = 3506
integer height = 1572
string dataobject = "d_import_starbucks_delivery_date_update"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_starbucks_delivery_date_update u_dw_import_starbucks_delivery_date_update

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

//We need a way to update the delivery dates for the outbound orders of each store. There was a change by Pete to allow us to update the delivery date in batch 
//detail screen. However, since we$$HEX1$$1920$$ENDHEX$$re consolidating multiple orders from multiple stores into 1 batch (stores that are on the same route) and the actual POD for 
//each store can be different, therefore we need an import function with the following fields:
//
//The upload requires the following fields:
//1.	Order number
//OR
//2.	Order info.Order Date (this is the required delivery date on the DN)
//3.	Customer Code (store code)
//UPDATE
//4.	Delivery Date (mmddyyyy hh:mm)
//
//

//string ls_sku, ls_supp_code, ls_License_Number, ls_Country_of_Manufacturer, ls_State
//decimal ld_MRP_price
//
//
long llRow //, llCount
//string lsDoNo
//boolean ib_fail = false
//string lsBatch, lsRegion, lsCartonRemarks, lsRemarks

string ls_order_number, ls_customer_code
datetime ldt_delivery_date
string  ls_order_date


For llRow = 1 to this.RowCount()  
	
	
	ls_order_number = trim(this.GetItemString( llRow, "order_number"))
	
	if IsNull(ls_order_number) then ls_order_number = ""
	
	ls_customer_code = this.GetItemString( llRow, "customer_code")
	ls_order_date =   mid(this.GetItemString( llRow, "order_date"), 5,4) + "/" + left(this.GetItemString( llRow, "order_date"), 2) + "/" + mid(this.GetItemString( llRow, "order_date"), 3,2)   

	ldt_delivery_date = datetime(date(mid(this.GetItemString( llRow, "delivery_date"), 5,4) + "/" +  left(this.GetItemString( llRow, "delivery_date"), 2) + "/" + mid(this.GetItemString( llRow, "delivery_date"), 3,2)  ), time(mid(this.GetItemString( llRow, "delivery_date"), 10))) //mmddyyyy hh:mm

	datetime ldt_last_update

	Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
	
	//Ord_status = 'D',
	//when we upload the POD, please change the last user and last updated in order info with whomever imported the file and the actual date that it was imported.
	
	ldt_last_update = datetime(today(), now())
	
	IF ls_order_number <> "" THEN
	
		Update Delivery_Master
		Set  Delivery_Date = :ldt_delivery_date, Ord_status = 'D', Last_User = :gs_userid, Last_Update= :ldt_last_update
		Where Project_id = :gs_project and invoice_no = :ls_order_number and ord_status = 'C' //and Delivery_Master.Ord_Date = :ld_order_date 
		Using SQLCA;
		
	ELSE	

		
		Update Delivery_Master
		Set  Delivery_Date = :ldt_delivery_date, Ord_status = 'D', Last_User = :gs_userid, Last_Update= :ldt_last_update
		Where Project_id = :gs_project and cust_code = :ls_customer_code and convert(varchar, ord_date, 111)  = :ls_order_date  and ord_status = 'C' //and Delivery_Master.Ord_Date = :ld_order_date 
		Using SQLCA;		
				
		
	END IF

	
	if SQLCA.SQLCode <> 0 then
		MessageBox ("Error DB - Update Delivery Date", SQLCA.SQLErrText )
	end if
	
	Execute Immediate "Commit" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
	
	if SQLCA.SQLCode <> 0 then
		MessageBox ("Error DB - Commit", SQLCA.SQLErrText )
	end if	
	
	
	SetPointer(Arrow!)
	

Next /*Next Import Column*/



MessageBox("Import","Records update.~r~rDelivery Updates Processed.")
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)

Return 0

end function

on u_dw_import_starbucks_delivery_date_update.create
call super::create
end on

on u_dw_import_starbucks_delivery_date_update.destroy
call super::destroy
end on

event ue_pre_validate;call super::ue_pre_validate;
Long	llRowPos, llRowCount, llFindRow
string  lsSku

boolean ib_Fail = false
integer li_count

string ls_order_number, ls_customer_code, ls_order_date
datetime ldt_delivery_date
date ld_order_date

//Loop thru Items and preload into DS
lLRowCount = This.RowCount()

For llRowPOs = 1 to llRowCount
	
	ls_order_number = this.GetItemString( llRowPOs, "order_number")
	ld_order_date =  date( mid(this.GetItemString( llRowPOs, "order_date"), 5,4) + "/" + left(this.GetItemString( llRowPOs, "order_date"), 2) + "/" + mid(this.GetItemString( llRowPOs, "order_date"), 3,2)   )
	ls_order_date =   mid(this.GetItemString( llRowPOs, "order_date"), 5,4) + "/" + left(this.GetItemString( llRowPOs, "order_date"), 2) + "/" + mid(this.GetItemString( llRowPOs, "order_date"), 3,2)   

	
	ls_customer_code = this.GetItemString( llRowPOs, "customer_code")
		
	ldt_delivery_date = datetime(date(mid(this.GetItemString( llRowPOs, "delivery_date"), 5,4) + "/" +  left(this.GetItemString( llRowPOs, "delivery_date"), 2) + "/" + mid(this.GetItemString( llRowPOs, "delivery_date"), 3,2)  ), time(mid(this.GetItemString( llRowPOs, "delivery_date"), 10))) //mmddyyyy hh:mm


	
	IF not isdate(mid(this.GetItemString( llRowPOs, "delivery_date"), 5,4) + "/" +  left(this.GetItemString( llRowPOs, "delivery_date"), 2) + "/" + mid(this.GetItemString( llRowPOs, "delivery_date"), 3,2) ) then
		
		ib_fail = true

		MessageBox ("Error", "Row: " + string(llRowPOs) + " date not valid." )
	
		
		
	end if
	

	IF not istime(mid(this.GetItemString( llRowPOs, "delivery_date"), 10)) then
		
		ib_fail = true

		MessageBox ("Error", "Row: " + string(llRowPOs) + " time not valid." )

		
		
	end if

// MEA - 8/13 - Comment out as per BoonHee.	
	
//	li_count = 0
//	
//	IF ls_order_number <> "" THEN
//	
//
//		//validate that the delivery date cannot be earlier than completed date
//
//
//		Select Count(*) INTO :li_count 
//			FROM  Delivery_Master
//		Where Project_id = :gs_project and invoice_no = :ls_order_number and ord_status = 'C' AND   :ldt_delivery_date < Delivery_Master.Complete_Date
//		Using SQLCA;
//		
//	ELSE	
//
//		Select Count(*) INTO :li_count 
//			FROM  Delivery_Master
//		Where Project_id = :gs_project and cust_code = :ls_customer_code and convert(varchar, ord_date, 111)  = :ls_order_date  and ord_status = 'C'  AND   :ldt_delivery_date < Delivery_Master.Complete_Date//and Delivery_Master.Ord_Date = :ld_order_date 
//		Using SQLCA;			
//
//		
//	END IF
//
//	If IsNull(li_count) then li_count = 0
//	
//	IF li_count > 0 then
//		
//		ib_fail = true
//
//		MessageBox ("Error", "Row: " + string(llRowPOs) + " - Delivery Date cannot be earlier than Complete Date." )
//	
//	end if	
	
// MEA - End Validation Comment out
	
		
//	SELECT  Count(*) into :li_count
//        FROM Delivery_Master   
//	Where Project_id = :gs_project and invoice_no = :ls_order_number and ord_status = 'C' //and Delivery_Master.Ord_Date = :ld_order_date  
//	Using SQLCA;
//
//	
//	if li_count = 0 then
//		
//		ib_fail = true
//
//		MessageBox ("Error", "Row: " + string(llRowPOs) + " There are no orders  with the order number (" + ls_order_number + ")  that are in completed status ." )
//
//	end if
//	

	
Next


w_main.SetMicroHelp("Ready")

IF ib_fail = true THEN
	
	RETURN -1
	
END IF


Return 0
end event

