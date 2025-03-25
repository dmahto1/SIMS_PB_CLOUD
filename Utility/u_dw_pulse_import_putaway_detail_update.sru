HA$PBExportHeader$u_dw_pulse_import_putaway_detail_update.sru
$PBExportComments$Import Pulse Pull (Delivery) Order
forward
global type u_dw_pulse_import_putaway_detail_update from u_dw_import
end type
end forward

global type u_dw_pulse_import_putaway_detail_update from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_pulse_import_putaway_update"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_pulse_import_putaway_detail_update u_dw_pulse_import_putaway_detail_update

forward prototypes
public function integer wf_save ()
public function string wf_get_supplier (string assku, long alowner)
public function string wf_validate (long al_row)
public function integer uf_update_db (string as_dw_column, string as_db_column, string as_type)
end prototypes

public function integer wf_save ();Long	llRowCount, llRowPos, llUpdate, llNew,	llOwner,	llLineItem,	llCount
		
String lsrono
String ls_order_nbr
String ls_sku
String ls_po2_no
String ls_inbound_customer_declaration_no
String ls_customer_declaration_line_no
String ls_chang_yun_record_item_no
String ls_hs_code
String ls_chinese_name
String ls_qty_for_customer_declaration
String ls_chinese_desc
String ls_uom_of_chang_yun_record
String ls_unit_price_for_custom_declaration
String ls_inbound_date
String ls_coo2
String ls_comingleflag
String ls_supplier
String ls_owner
String ls_location
String ls_grn_num
Datetime ldt_expiration_date
Decimal ld_container_length
Decimal ld_container_width
Decimal ld_container_height
Decimal ld_continaer_gross_wt
String ls_Container
Decimal ld_quantiy
datastore lds_dw


lds_dw = CREATE datastore 

lds_dw.dataobject = "d_pulse_import_putaway_detail"
lds_dw.SetTransObject(SQLCA)

SetPointer(Hourglass!)

llRowCount = This.RowCount()

For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
		
	ls_order_nbr = This.GetITemString(llRowPos,'order_nbr')
	ls_sku = This.GetITemString(llRowPos,'sku')
	ls_Container = This.GetITemString(llRowPos,'container_id')

	ls_po2_no = This.GetITemString(llRowPos,'po2_no')

	ls_inbound_customer_declaration_no = This.GetITemString(llRowPos,'inbound_custom_declaration_no')
	ls_customer_declaration_line_no = This.GetITemString(llRowPos,'custom_declaration_line_no')
	ls_chang_yun_record_item_no = This.GetITemString(llRowPos,'chang_yun_record_item_no')
	ls_hs_code = This.GetITemString(llRowPos,'hs_code')
	ls_chinese_name = This.GetITemString(llRowPos,'chinese_name')
	ls_qty_for_customer_declaration = This.GetITemString(llRowPos,'qty_for_custom_declaration')
	ls_uom_of_chang_yun_record = This.GetITemString(llRowPos,'uom_of_chang_yun_record')
	ls_unit_price_for_custom_declaration = This.GetITemString(llRowPos,'unit_price_for_custom_declaration')
	ls_inbound_date = This.GetITemString(llRowPos,'inbound_date')
	ls_coo2 = This.GetITemString(llRowPos,'coo2')
	ls_comingleflag = This.GetITemString(llRowPos,'comingleflag')

	ld_container_length = dec(This.GetITemString(llRowPos,'container_length'))
	ld_container_width =  dec(This.GetITemString(llRowPos,'container_width'))
	ld_container_height = dec(This.GetITemString(llRowPos,'container_height'))
	ld_continaer_gross_wt = dec(This.GetITemString(llRowPos,'container_gross_wt'))
	ls_grn_num = This.GetITemString(llRowPos,'grn_num')
	ls_location = This.GetITemString(llRowPos,'location')
	ldt_expiration_date =  datetime(This.GetITemString(llRowPos,'expiration_date'))

	ld_quantiy = dec(This.GetITemString(llRowPos,'quantity'))

	ls_supplier = This.GetITemString(llRowPos,'supplier')
	ls_owner = This.GetITemString(llRowPos,'owner')


	//See if this Order already exists (in a non completed status)
	Select Max(Receive_Master.ro_no)
	Into	:lsRoNo
	From Receive_Master, Receive_Putaway
	Where Receive_Master.ro_no =  Receive_Putaway.ro_no and Project_id = :gs_project and supp_invoice_no = :ls_order_nbr and ord_status Not In( 'C', 'D', 'V')
			and Receive_Putaway.sku = :ls_sku and Receive_Putaway.Container_ID = :ls_Container;

	
	integer li_idx
	
	If lsRoNo > '' Then /*order exists - update detail*/
	
	llCount = lds_dw.Retrieve(lsRoNo, ls_sku, ls_Container)
	
	If llCount > 0 Then /*Row Exists*/

		//inbound_customer_declaration_no
		
		if Not IsNull(ls_inbound_customer_declaration_no) and trim(ls_inbound_customer_declaration_no) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "user_field3", ls_inbound_customer_declaration_no)
			next
		end if
	
		//customer_declaration_line_no
	
		if Not IsNull(ls_customer_declaration_line_no) and trim(ls_customer_declaration_line_no) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "user_field4", ls_customer_declaration_line_no)
			next
		end if	
	
		//chang_yun_record_item_no	
	
		if Not IsNull(ls_chang_yun_record_item_no) and trim(ls_chang_yun_record_item_no) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "user_field5", ls_chang_yun_record_item_no)
			next
		end if
	
		//hs_code
		
		if Not IsNull(ls_hs_code) and trim(ls_hs_code) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "user_field6", ls_hs_code)
			next
		end if	
	
		//chinese_name
		
		if Not IsNull(ls_chinese_name) and trim(ls_chinese_name) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "user_field7", ls_chinese_name)
			next		
		end if	
	
		//qty_for_customer_declaration
	
		if Not IsNull(ls_qty_for_customer_declaration) and trim(ls_qty_for_customer_declaration) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "user_field8", ls_qty_for_customer_declaration)
			next		
		end if	
	
		//uom_of_chang_yun_record
		
		if Not IsNull(ls_uom_of_chang_yun_record) and trim(ls_uom_of_chang_yun_record) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "user_field9", ls_uom_of_chang_yun_record)
			next		
		end if	
	
		//unit_price_for_custom_declaration
		
		if Not IsNull(ls_unit_price_for_custom_declaration) and trim(ls_unit_price_for_custom_declaration) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "user_field10", ls_unit_price_for_custom_declaration)
			next	
		end if	
	
		//ls_inbound_date
		
		if Not IsNull(ls_inbound_date) and trim(ls_inbound_date) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "user_field11", ls_inbound_date)
			next	
		end if	
	
		//ls_coo2
		
		if Not IsNull(ls_coo2) and trim(ls_coo2) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "user_field12", ls_coo2)
			next	
		end if	
	
		//comingleflag
	
		if Not IsNull(ls_comingleflag) and trim(ls_comingleflag) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "user_field13", ls_comingleflag)
			next	
		end if	
	
		
		//po2_no
	
		if Not IsNull(ls_po2_no) and trim(ls_po2_no) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "po_no2", ls_po2_no)
			next				
		end if	
		
		
		//grn_num
	
		if Not IsNull(ls_grn_num) and trim(ls_grn_num) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "po_no", ls_grn_num)
			next
		end if		
		
		//container_length
	
		if Not IsNull(ld_container_length) and trim(string(ld_container_length)) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "length", ld_container_length)
			next
		end if			
	
		//container_width
	
		if Not IsNull(ld_container_width) and trim(string(ld_container_width)) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "width", ld_container_width)
			next
		end if		
	
		//container_height
	
		if Not IsNull(ld_container_height) and trim(string(ld_container_height)) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "height", ld_container_height)
			next
		end if		
		
		//Weight_Gross
	
		if Not IsNull(ld_continaer_gross_wt) and trim(string(ld_continaer_gross_wt)) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "Weight_Gross", ld_continaer_gross_wt)
			next
		end if		
	

		//quantity
	
		if Not IsNull(ld_quantiy) and trim(string(ld_quantiy)) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "Quantity", ld_quantiy)
			next
		end if	


		//location
	
		if Not IsNull(ls_location) and trim(ls_location) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "l_code", ls_location)
			next			
		end if	
		
		//supplier
	
		if Not IsNull(ls_supplier) and trim(ls_supplier) <> '' then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "supp_code", ls_supplier)
			next		
		end if		
	

		if Not IsNull(ldt_expiration_date) then 
			for li_idx = 1 to llCount 	
				lds_dw.SetItem( li_idx, "expiration_date", ldt_expiration_date)
			next			
		end if		
		
		// ,
	//		  dbo.Receive_Putaway.owner_id  = :l_owner 
	
		SQLCA.DBParm = "disablebind =0"	
	
		lds_dw.Update()
	
		SQLCA.DBParm = "disablebind =1"
		
		
		llUpdate ++

		

	Else /*add a new detail row for this sku/Line Item*/

			
		MessageBox ("1Not found", "sku/container no found")
			
	End If
		

	
	Else /*create a new header/detail*/
		
		
		MessageBox ("2Order Not found/Sku/Container", "not found")
		

	End If
	
Next /*Next Import Row*/


MessageBox("Import","Records updated.")
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

public function string wf_get_supplier (string assku, long alowner);
String	lsSupplier

//either return the first supplier for this sku/OWner that has inventory, or if no inventory, the first supplier for this SKU

Select Min(supp_code) into :lsSupplier
from Content
Where Project_id = :gs_project and SKU = :asSKU and owner_id = :alOwner
Using SQLCA;

If lsSUpplier > ' ' Then
	
Else /*No Inventory*/
	
	Select Min(supp_code) into :lsSupplier
	From Item_MAster
	Where Project_id = :gs_project and SKU = :asSKU
	Using SQLCA;

End If

If isNull(lsSupplier) Then lsSupplier = ''

Return lsSupplier
end function

public function string wf_validate (long al_row);// 12/02 PCONKL - Validate Pull order for Pulse

String	lsPlant,	&
			lsSKU,		&
			lsInvoice,	&
			lsQTY, lsID, &
			lsSContainer
			
Long		llCount

//Order Number is Required
lsInvoice = This.GetITemString(al_row,'order_nbr')
If Isnull(lsInvoice) or lsInvoice = '' Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('order_nbr')
	return "'Order Number' is Required"
End If


//Order Number must be valid 
Select Count(*) into :llCount
From Receive_MASter
Where project_id = :gs_Project and supp_invoice_no = :lsInvoice;

If llCount < 1 Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('order_nbr')
	return "'Order Number is Invalid. "
End If



////Customer ID (Plant) must be present and valid*/
//lsPlant = This.GetITemString(al_row,'plant')
//If Isnull(lsPlant)  or lsPlant = '' Then
//	This.SetFocus()
//	This.SetRow(al_row)
//	This.SetColumn('plant')
//	return "'Plant' is Required"
//End If
//
//Select Count(*) into :llCount
//From Customer
//Where project_id = :gs_Project and cust_code = :lsPlant;
//
//If llCount < 1 Then
//	This.SetFocus()
//	This.SetRow(al_row)
//	This.SetColumn('plant')
//	return "'Plant' is Invalid."
//End If

//SKU is Required
lsSKU = This.GetITemString(al_row,'SKU')
If len(lsSKU) < 1 or lsSKU = '' Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('SKU')
	return "'SKU' is Required"
End If

//SKU must be valid 
Select Count(*) into :llCount
From Item_MASter
Where project_id = :gs_Project and sku = :lsSKU;

If llCount < 1 Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('SKU')
	return "'SKU is Invalid. "
End If


//Container is Required
lsSContainer = This.GetITemString(al_row,'container_id')
If len(lsSContainer) < 1 or lsSContainer = '' Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('container_id')
	return "'Container ID' is Required"
End If





////Qty must be present and Numeric
//lsQTY =  This.GetITemString(al_row,'QTY')
//If lsQTY > '' Then
//	If Not isNumber(lsQTY) Then
//		This.SetFocus()
//		This.SetRow(al_row)
//		This.SetColumn('qty')
//		return "'QTY' must be numeric"
//	End If
//Else /* Not present*/
//	This.SetFocus()
//	This.SetRow(al_row)
//	This.SetColumn('qty')
//	return "'QTY' is Required."
//End If
//
//// 12/03 - PCONKL - CCC fields are required
//
////Trader ID must be present and Numeric
//lsID =  This.GetITemString(al_row,'Trader_ID')
//If lsID > '' Then
//	If Not isNumber(lsID) Then
//		This.SetFocus()
//		This.SetRow(al_row)
//		This.SetColumn('Trader_ID')
//		return "'Trader ID' must be numeric"
//	End If
//Else /* Not present*/
////	This.SetFocus()
////	This.SetRow(al_row)
////	This.SetColumn('Trader_ID')
////	return "'Trader ID' is Required."
//End If
//
////Contract Owner ID must be present and Numeric
//lsID =  This.GetITemString(al_row,'Contract_Owner_ID')
//If lsID > '' Then
//	If Not isNumber(lsID) Then
//		This.SetFocus()
//		This.SetRow(al_row)
//		This.SetColumn('Contract_Owner_ID')
//		return "'Contract Owner ID' must be numeric"
//	End If
//Else /* Not present*/
////	This.SetFocus()
////	This.SetRow(al_row)
////	This.SetColumn('Contract_Owner_ID')
////	return "'Contract Owner ID' is Required."
//End If
//
////Factory ID must be present and Numeric
//lsID =  This.GetITemString(al_row,'Factory_ID')
//If lsID > '' Then
//	If Not isNumber(lsID) Then
//		This.SetFocus()
//		This.SetRow(al_row)
//		This.SetColumn('Factory_ID')
//		return "'Factory ID' must be numeric"
//	End If
//Else /* Not present*/
////	This.SetFocus()
////	This.SetRow(al_row)
////	This.SetColumn('Factory_ID')
////	return "'Factory ID' is Required."
//End If
//

iscurrvalcolumn = ''
return ''

end function

public function integer uf_update_db (string as_dw_column, string as_db_column, string as_type);
//string  Mysql
//
//Mysql = "CREATE TABLE Trainees "&
//
//        +"(emp_id integer not null,"&
//
//        +"emp_fname char(10) not null, "&
//
//        +"emp_lname char(20) not null)"
//
//EXECUTE IMMEDIATE :Mysql ;
//

RETURN 1

end function

on u_dw_pulse_import_putaway_detail_update.create
call super::create
end on

on u_dw_pulse_import_putaway_detail_update.destroy
call super::destroy
end on

