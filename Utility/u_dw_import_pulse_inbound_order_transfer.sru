HA$PBExportHeader$u_dw_import_pulse_inbound_order_transfer.sru
$PBExportComments$Generic UO for server based imports
forward
global type u_dw_import_pulse_inbound_order_transfer from u_dw_import
end type
end forward

global type u_dw_import_pulse_inbound_order_transfer from u_dw_import
event ue_after_save ( )
end type
global u_dw_import_pulse_inbound_order_transfer u_dw_import_pulse_inbound_order_transfer

event ue_after_save();


//Add $$HEX1$$1c20$$ENDHEX$$Container ID$$HEX2$$1d202000$$ENDHEX$$column which will be displayed under Putaway screen.  
//Add 3 columns for $$HEX1$$1c20$$ENDHEX$$Length$$HEX1$$1d20$$ENDHEX$$, $$HEX1$$1c20$$ENDHEX$$Width$$HEX2$$1d202000$$ENDHEX$$and $$HEX1$$1c20$$ENDHEX$$Height$$HEX2$$1d202000$$ENDHEX$$which will be displayed under Putaway screen
//During inbound order import, allow to overwrite the $$HEX1$$1c20$$ENDHEX$$Container ID$$HEX2$$1d202000$$ENDHEX$$and $$HEX1$$1c20$$ENDHEX$$IMI #$$HEX2$$1d202000$$ENDHEX$$(Lot_no) algorithm when order types are $$HEX1$$1c20$$ENDHEX$$I$$HEX2$$1d202000$$ENDHEX$$(Item Transfer to Liaobu) and $$HEX1$$1c20$$ENDHEX$$T$$HEX2$$1d202000$$ENDHEX$$(Trail Shipment to Liaobu) 
// 


//warehouse
//project
//order_date

//line_number
//sku

//length
//width
//height

//MessageBox ("ok", "test")

integer li_idx
string ls_order_type 
string ls_order_number, ls_warehouse
decimal ld_EDI_Batch_Seq_No
integer li_line_number
string ls_sku
string ls_length, ls_width, ls_height, ls_gross_weight
string ls_container_id
string ls_lot_no
string ls_supp_code
string ls_uom
string ls_ro_no

FOR li_idx = 1 TO RowCount()

	ls_order_number =  this.GetItemString( li_idx, "order_number")
//	ls_warehouse =  this.GetItemString( li_idx, "warehouse")

	li_line_number =  Integer(this.GetItemString( li_idx, "line_number"))
	ls_sku =  this.GetItemString( li_idx, "sku")
	ls_supp_code  =  this.GetItemString( li_idx, "supplier")

	ls_order_type = this.GetItemString( li_idx, "order_type")


	ls_length =  this.GetItemString( li_idx, "length")
	ls_width =  this.GetItemString( li_idx, "width")
	ls_height =  this.GetItemString( li_idx, "height")
	ls_gross_weight = this.GetItemString( li_idx, "gross_weight")

	
	
	SELECT max(EDI_Batch_Seq_No) INTO :ld_EDI_Batch_Seq_No
		FROM EDI_Inbound_Detail 
		WHERE Order_Line_No = :li_line_number and project_id = 'PULSE' AND
				 	sku = :ls_sku  and order_no = :ls_order_number
		;
	
	IF SQLCA.SQLCode = 100 THEN
		MessageBox ("Error", "RO No not found for line -" + string(li_idx))
		CONTINUE
	END IF

	IF SQLCA.SQLCode < 0  THEN
		MessageBox ("Error", SQLCA.SQLErrText)
	END IF

	UPDATE EDI_Inbound_Detail
		SET user_field4 = :ls_length,
			  user_field5 = :ls_width, 
			  user_field6 = :ls_height,
			  user_field2 = :ls_gross_weight
		WHERE Order_Line_No = :li_line_number and project_id = 'PULSE' AND
				 	sku = :ls_sku  and order_no = :ls_order_number USING SQLCA;
	
	
	IF SQLCA.SQLCode <> 0  THEN
		MessageBox ("Error", SQLCA.SQLErrText)
	END IF


//UOM

	SELECT ro_no INTO :ls_ro_no FROM receive_master
		WHERE supp_invoice_no = :ls_order_number and project_id = 'PULSE' USING SQLCA;

	
	IF SQLCA.SQLCode <> 0  THEN
		MessageBox ("Error", SQLCA.SQLErrText)
	END IF


	SELECT uom_1 INTO :ls_uom
		FROM Item_Master 
		WHERE project_id = 'PULSE' AND
				 	sku = :ls_sku  and supp_code = :ls_supp_code;
	
	IF SQLCA.SQLCode = 0 THEN
		UPDATE Receive_Detail
			SET uom = :ls_uom
			WHERE Line_Item_No = :li_line_number AND
						sku = :ls_sku  and ro_no = :ls_ro_no USING SQLCA;
	ELSE
		MessageBox ("Not Found", String(li_idx) + " rows - sku not found in item master.")
	END IF
	
	IF SQLCA.SQLCode < 0 THEN
		MessageBox ("Error", SQLCA.SQLErrText)
	END IF



	IF Trim(ls_order_type) = 'I' OR Trim(ls_order_type) = 'T' THEN

		ls_container_id =  this.GetItemString( li_idx, "container_id")
//		ls_lot_no =  this.GetItemString( li_idx, "lot_number")

		UPDATE EDI_Inbound_Detail
			SET  container_id = :ls_container_id
		WHERE Order_Line_No = :li_line_number and project_id = 'PULSE' AND
				 	sku = :ls_sku  and order_no = :ls_order_number USING SQLCA;

		IF SQLCA.SQLCode <> 0  THEN
			MessageBox ("Error", SQLCA.SQLErrText)
		END IF	
			
		
		
	END IF
	
NEXT



//lot_number
//container_id


end event

on u_dw_import_pulse_inbound_order_transfer.create
call super::create
end on

on u_dw_import_pulse_inbound_order_transfer.destroy
call super::destroy
end on

