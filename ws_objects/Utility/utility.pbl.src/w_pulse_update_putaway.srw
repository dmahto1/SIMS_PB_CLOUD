$PBExportHeader$w_pulse_update_putaway.srw
forward
global type w_pulse_update_putaway from window
end type
type cb_clear from commandbutton within w_pulse_update_putaway
end type
type cb_update from commandbutton within w_pulse_update_putaway
end type
type dw_1 from datawindow within w_pulse_update_putaway
end type
end forward

global type w_pulse_update_putaway from window
integer width = 4146
integer height = 1476
boolean titlebar = true
string title = "Pulse Update Putaway"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_clear cb_clear
cb_update cb_update
dw_1 dw_1
end type
global w_pulse_update_putaway w_pulse_update_putaway

on w_pulse_update_putaway.create
this.cb_clear=create cb_clear
this.cb_update=create cb_update
this.dw_1=create dw_1
this.Control[]={this.cb_clear,&
this.cb_update,&
this.dw_1}
end on

on w_pulse_update_putaway.destroy
destroy(this.cb_clear)
destroy(this.cb_update)
destroy(this.dw_1)
end on

event open;
dw_1.insertrow(0)

dw_1.SetColumn("order_nbr")
dw_1.SetFocus()
end event

type cb_clear from commandbutton within w_pulse_update_putaway
integer x = 3557
integer y = 200
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;
dw_1.Reset()

dw_1.InsertRow(0)

dw_1.SetColumn("order_nbr")
dw_1.SetFocus()
end event

type cb_update from commandbutton within w_pulse_update_putaway
integer x = 3557
integer y = 52
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update"
boolean default = true
end type

event clicked;
SetPointer(Hourglass!)

dw_1.AcceptText()

//Validate

string lsInvoice, lsSku, lsRoNo, ls_Container
long llCount

//Order Number is Required
lsInvoice = dw_1.GetITemString(1,'order_nbr')
If Isnull(lsInvoice) or lsInvoice = '' Then
	dw_1.SetFocus()
	dw_1.SetRow(1)
	dw_1.SetColumn('order_nbr')
	MessageBox("Error",  "Order Number is Required")
	return -1
End If


//Order Number must be valid 
Select Count(*) into :llCount
From Receive_MASter
Where project_id = :gs_Project and supp_invoice_no = :lsInvoice;

If llCount < 1 Then
	dw_1.SetFocus()
	dw_1.SetRow(1)
	dw_1.SetColumn('order_nbr')
	MessageBox ("Error", "Order Number is Invalid. ")
	return -1
End If



//SKU is Required
lsSKU = dw_1.GetITemString(1,'SKU')
If len(lsSKU) < 1 or lsSKU = '' Then
	dw_1.SetFocus()
	dw_1.SetRow(1)
	dw_1.SetColumn('SKU')
	MessageBox("Error", "SKU' is Required")
	return -1
End If

//SKU must be valid 
Select Count(*) into :llCount
From Item_MASter
Where project_id = :gs_Project and sku = :lsSKU;

If llCount < 1 Then
	dw_1.SetFocus()
	dw_1.SetRow(1)
	dw_1.SetColumn('SKU')
	MessageBox("Error", "SKU is Invalid. ")
	return -1
End If
//

//Container is Required
ls_Container = dw_1.GetITemString(1,'container_id')
If len(ls_Container) < 1 or ls_Container = '' Then
	dw_1.SetFocus()
	dw_1.SetRow(1)
	dw_1.SetColumn('container_id')
	MessageBox ("Error",  "'Container ID' is Required.")
	return -1
End If




string ls_inbound_customer_declaration_no, ls_customer_declaration_line_no
string ls_chang_yun_record_item_no, ls_hs_code, ls_chinese_name, ls_qty_for_customer_declaration
string ls_uom_of_chang_yun_record, ls_unit_price_for_custom_declaration, ls_inbound_date
string ls_coo2, ls_comingleflag

ls_inbound_customer_declaration_no = dw_1.GetITemString(1,'user_field3')
ls_customer_declaration_line_no = dw_1.GetITemString(1,'user_field4')
ls_chang_yun_record_item_no = dw_1.GetITemString(1,'user_field5')
ls_hs_code = dw_1.GetITemString(1,'user_field6')
ls_chinese_name = dw_1.GetITemString(1,'user_field7')
ls_qty_for_customer_declaration = dw_1.GetITemString(1,'user_field8')
ls_uom_of_chang_yun_record = dw_1.GetITemString(1,'user_field9')
ls_unit_price_for_custom_declaration = dw_1.GetITemString(1,'user_field10')
ls_inbound_date = dw_1.GetITemString(1,'user_field11')
ls_coo2 = dw_1.GetITemString(1,'user_field12')
ls_comingleflag = dw_1.GetITemString(1,'user_field13')


//See if dw_1 Order already exists (in a non completed status)
Select Max(Receive_Master.ro_no)
Into	:lsRoNo
From Receive_Master, Receive_Putaway
Where Receive_Master.ro_no =  Receive_Putaway.ro_no and Project_id = :gs_project and supp_invoice_no = :lsInvoice and ord_status Not In(  'D', 'V')
			and Receive_Putaway.sku = :lsSku and Receive_Putaway.Container_ID = :ls_Container;

if sqlca.SQLCode <> 0 then
	MEssageBox ("DB Error", SQLCA.SQLErrText )
end if

If lsRoNo > '' Then /*order exists - update detail*/

	//If the detail row already exists, add the new qty to the existing qty -
	Select Count(*)
	Into	:llCount
	From Receive_Putaway
	Where ro_no = :lsRoNo and sku = :lsSku and Container_ID = :ls_Container ;
	

	If llCount > 0 Then /*Row Exists*/

	
	SQLCA.DBParm = "disablebind =0"	
		
	//inbound_customer_declaration_no
	
	if Not IsNull(ls_inbound_customer_declaration_no) and trim(ls_inbound_customer_declaration_no) <> '' then 
		UPDATE 	dbo.Receive_Putaway
			 SET dbo.Receive_Putaway.user_field3 = :ls_inbound_customer_declaration_no 
			 Where ro_no = :lsRoNo and sku = :lssku and Container_ID = :ls_Container using SQLCA;
		if SQLCA.SQLCode <> 0 then
			MessageBox("DB Error", SQLCA.SQLErrText)
		end if
	end if

	//customer_declaration_line_no

	if Not IsNull(ls_customer_declaration_line_no) and trim(ls_customer_declaration_line_no) <> '' then 
		UPDATE 	dbo.Receive_Putaway
			 SET dbo.Receive_Putaway.user_field4 = :ls_customer_declaration_line_no
			 Where ro_no = :lsRoNo and sku = :lssku and Container_ID = :ls_Container using SQLCA;

		if SQLCA.SQLCode <> 0 then
			MessageBox("DB Error", SQLCA.SQLErrText)
		end if
	end if	

	//chang_yun_record_item_no	

	if Not IsNull(ls_chang_yun_record_item_no) and trim(ls_chang_yun_record_item_no) <> '' then 
		UPDATE 	dbo.Receive_Putaway
			 SET dbo.Receive_Putaway.user_field5 = :ls_chang_yun_record_item_no
			 Where ro_no = :lsRoNo and sku = :lssku and Container_ID = :ls_Container using SQLCA;

		if SQLCA.SQLCode <> 0 then
			MessageBox("DB Error", SQLCA.SQLErrText)
		end if
	end if

	//hs_code
	
	if Not IsNull(ls_hs_code) and trim(ls_hs_code) <> '' then 
		UPDATE 	dbo.Receive_Putaway
			 SET dbo.Receive_Putaway.user_field6 = :ls_hs_code
			 Where ro_no = :lsRoNo and sku = :lssku and Container_ID = :ls_Container using SQLCA;

		if SQLCA.SQLCode <> 0 then
			MessageBox("DB Error", SQLCA.SQLErrText)
		end if
	end if	

	//chinese_name
	
	if Not IsNull(ls_chinese_name) and trim(ls_chinese_name) <> '' then 
		UPDATE 	dbo.Receive_Putaway
			 SET dbo.Receive_Putaway.user_field7 = :ls_chinese_name
			 Where ro_no = :lsRoNo and sku = :lssku and Container_ID = :ls_Container using SQLCA;

		if SQLCA.SQLCode <> 0 then
			MessageBox("DB Error", SQLCA.SQLErrText)
		end if
	end if	

	//qty_for_customer_declaration

	if Not IsNull(ls_qty_for_customer_declaration) and trim(ls_qty_for_customer_declaration) <> '' then 
		UPDATE 	dbo.Receive_Putaway
			 SET dbo.Receive_Putaway.user_field8 = :ls_qty_for_customer_declaration
			 Where ro_no = :lsRoNo and sku = :lssku and Container_ID = :ls_Container using SQLCA;

		if SQLCA.SQLCode <> 0 then
			MessageBox("DB Error", SQLCA.SQLErrText)
		end if
	end if	

	//uom_of_chang_yun_record
	
	if Not IsNull(ls_uom_of_chang_yun_record) and trim(ls_uom_of_chang_yun_record) <> '' then 
		UPDATE 	dbo.Receive_Putaway
			 SET dbo.Receive_Putaway.user_field9 = :ls_uom_of_chang_yun_record
			 Where ro_no = :lsRoNo and sku = :lssku and Container_ID = :ls_Container using SQLCA;

		if SQLCA.SQLCode <> 0 then
			MessageBox("DB Error", SQLCA.SQLErrText)
		end if
	end if	

	//unit_price_for_custom_declaration
	
	if Not IsNull(ls_unit_price_for_custom_declaration) and trim(ls_unit_price_for_custom_declaration) <> '' then 
		UPDATE 	dbo.Receive_Putaway
			 SET dbo.Receive_Putaway.user_field10 = :ls_unit_price_for_custom_declaration
			 Where ro_no = :lsRoNo and sku = :lssku and Container_ID = :ls_Container using SQLCA;

		if SQLCA.SQLCode <> 0 then
			MessageBox("DB Error", SQLCA.SQLErrText)
		end if
	end if	

	//ls_inbound_date
	
	if Not IsNull(ls_inbound_date) and trim(ls_inbound_date) <> '' then 
		UPDATE 	dbo.Receive_Putaway
			 SET dbo.Receive_Putaway.user_field11 = :ls_inbound_date
			 Where ro_no = :lsRoNo and sku = :lssku and Container_ID = :ls_Container using SQLCA;

		if SQLCA.SQLCode <> 0 then
			MessageBox("DB Error", SQLCA.SQLErrText)
		end if
	end if	

	//ls_coo2
	
	if Not IsNull(ls_coo2) and trim(ls_coo2) <> '' then 
		UPDATE 	dbo.Receive_Putaway
			 SET dbo.Receive_Putaway.user_field12 = :ls_coo2
			 Where ro_no = :lsRoNo and sku = :lssku and Container_ID = :ls_Container using SQLCA;

		if SQLCA.SQLCode <> 0 then
			MessageBox("DB Error", SQLCA.SQLErrText)
		end if
	end if	

	//comingleflag

	if Not IsNull(ls_comingleflag) and trim(ls_comingleflag) <> '' then 
		UPDATE 	dbo.Receive_Putaway
			 SET dbo.Receive_Putaway.user_field13 = :ls_comingleflag
			 Where ro_no = :lsRoNo and sku = :lssku and Container_ID = :ls_Container using SQLCA;

		if SQLCA.SQLCode <> 0 then
			MessageBox("DB Error", SQLCA.SQLErrText)
		end if
	end if	

	


	SQLCA.DBParm = "disablebind =1"
	
	


	

Else /*add a new detail row for dw_1 sku/Line Item*/

		
	MessageBox ("Not found", "sku/container on putaway not found")
	return -1
End If
	

Else /*create a new header/detail*/
	
	
	MessageBox ("Order Not found", "Not found - Putaway List must be generated and order not In Delete or Void status.")
	return -1

End If
	

MessageBox("Import","Records updated.")
SetPointer(Arrow!)

end event

type dw_1 from datawindow within w_pulse_update_putaway
integer x = 23
integer y = 36
integer width = 4050
integer height = 1308
integer taborder = 20
string title = "none"
string dataobject = "d_pulse_putaway_update"
boolean border = false
boolean livescroll = true
end type

