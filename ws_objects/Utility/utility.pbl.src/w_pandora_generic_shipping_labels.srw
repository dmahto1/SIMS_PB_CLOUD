$PBExportHeader$w_pandora_generic_shipping_labels.srw
$PBExportComments$Print Pandora Generic Shipping labels
forward
global type w_pandora_generic_shipping_labels from w_main_ancestor
end type
type cb_label_print from commandbutton within w_pandora_generic_shipping_labels
end type
type dw_label from u_dw_ancestor within w_pandora_generic_shipping_labels
end type
type cb_label_selectall from commandbutton within w_pandora_generic_shipping_labels
end type
type cb_label_clear from commandbutton within w_pandora_generic_shipping_labels
end type
type cbx_1 from checkbox within w_pandora_generic_shipping_labels
end type
type cbx_2 from checkbox within w_pandora_generic_shipping_labels
end type
type cbx_4 from checkbox within w_pandora_generic_shipping_labels
end type
type cbx_5 from checkbox within w_pandora_generic_shipping_labels
end type
type cbx_6 from checkbox within w_pandora_generic_shipping_labels
end type
type cbx_3 from checkbox within w_pandora_generic_shipping_labels
end type
type rb_1 from radiobutton within w_pandora_generic_shipping_labels
end type
type rb_2 from radiobutton within w_pandora_generic_shipping_labels
end type
type gb_1 from groupbox within w_pandora_generic_shipping_labels
end type
end forward

global type w_pandora_generic_shipping_labels from w_main_ancestor
integer width = 3191
integer height = 2044
string title = "Shipping Labels"
event ue_print ( )
event ue_print_2d_pallet_label ( )
event ue_print_2d_carton_label ( )
event ue_print_generic_address_label ( )
event ue_print_google_shipping_label ( )
event ue_print_include_pallet_label ( )
event ue_print_pallet_container_label ( )
event ue_print_google_shipping_label_picklist ( )
cb_label_print cb_label_print
dw_label dw_label
cb_label_selectall cb_label_selectall
cb_label_clear cb_label_clear
cbx_1 cbx_1
cbx_2 cbx_2
cbx_4 cbx_4
cbx_5 cbx_5
cbx_6 cbx_6
cbx_3 cbx_3
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_pandora_generic_shipping_labels w_pandora_generic_shipping_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
n_labels_pandora invo_labels_pandora

String	isUCCSCompanyPrefix, isUCCSWHPrefix, is_ucc_prefix

String	isDONO

inet	linit   //26-Sep-2014 :Madhu- KLN B2B SPS Conversion
u_nvo_websphere_post	iuoWebsphere  //26-Sep-2014 :Madhu- KLN B2B SPS Conversion
string is_status // 02-23-2021- Dinesh - Shipping label picklist

end variables

forward prototypes
public function boolean wf_find_non_footprint_items ()
end prototypes

event ue_print();Str_Parms	lstrparms

Long	llQty, llRowCount, llRowPos, ll_rtn, ll_alloc_qty, llRowPos1, llLabelCount, llLabelOf
		
Any	lsAny

String	lsCityStateZip, lsSKU, ls_format, ls_old_carton_no,ls_carton_no,ls_old_carton_no1,ls_carton_no1,	&
			lsDONO, lsCartonHold
String   ls_user_field21,lsXML,lsXMLResponse,lsReturnCode,lsReturnDesc,lsPrintText,lsReturnlabelData //26-Sep-2014 :Madhu -KLN B2B Conversion to SPS
Boolean lb_generic,lb_print_mixed ,lb_duplicate_carton,lb_print
long ll_tot_metrics_weight,ll_tot_english_weight,ll_cnt,ll_cnt1,ll_carton_cnt,ll_count,ll_count_prev,llPrintJob

n_warehouse l_nwarehouse 
n_cst_common_tables ln_common_tables

Dw_Label.AcceptText()

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

OpenWithParm(w_label_print_options,lstrparms)
lstrparms = Message.PowerObjectParm		  
If lstrparms.Cancelled Then Return 

//We need the disticnt carton count for "box x of y" count - we may have more than 1 row per packing

lsDoNo = dw_label.GetITemString(1,'delivery_Master_do_no')
lscartonHold = ''

Select Count(distinct Carton_NO) Into :llLabelCount
From Delivery_PAcking
Where do_no = :lsDONO
And Carton_No > 0;//BCR 07-SEP-2011: RUN-WORLD saves a 0 carton number row into Delivery_Packing

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]
	llQty = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
	lstrparms.Long_arg[1] = llQty
			
		  
	//lstrparms.String_arg[1] = dw_label.object.customer_user_field2[llRowPos] +".DWN"// **Change Later
	lstrparms.String_arg[2] = dw_label.GetItemString(llRowPos,'warehouse_wh_name')
	lstrparms.String_arg[3] = dw_label.GetItemString(llRowPos,'warehouse_address_1')
	lstrparms.String_arg[4] = dw_label.GetItemString(llRowPos,'warehouse_address_2')
	lstrparms.String_arg[5] = dw_label.GetItemString(llRowPos,'warehouse_address_3')
	lstrparms.String_arg[31] = dw_label.GetItemString(llRowPos,'Warehouse_address_4')
		
	//Compute FROM City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_city')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'warehouse_city') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_state')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_state') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_zip') + ' '
	lstrparms.String_arg[6] = lsCityStateZip
			
	lstrparms.String_arg[7] = dw_label.GetItemString(llRowPos,'delivery_master_Cust_name')
	lstrparms.String_arg[8] = dw_label.GetItemString(llRowPos,'delivery_master_address_1')
	lstrparms.String_arg[9] = dw_label.GetItemString(llRowPos,'delivery_master_address_2')
	lstrparms.String_arg[10] = dw_label.GetItemString(llRowPos,'delivery_master_address_3')
	lstrparms.String_arg[32] = dw_label.GetItemString(llRowPos,'delivery_master_address_4')
	lstrparms.String_arg[33] = dw_label.GetItemString(llRowPos,'delivery_master_Zip') /* 12/03 - PCONKL - for UCCS Ship to Zip */
			
	//Compute TO City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_City')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'delivery_master_City') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_State')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_State') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_Zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_Zip') + ' '
	lstrparms.String_arg[11] = lsCityStateZip
	
	If isnumber(dw_label.object.delivery_packing_carton_no[llRowPos]) Then
		lstrparms.String_arg[12] = String(Long(dw_label.object.delivery_packing_carton_no[llRowPos]),'000000000')
	Else
		dw_label.object.delivery_packing_carton_no[llRowPos]
	End If
	
	lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'delivery_master_cust_order_no') /* PO NBR*/
	lstrparms.String_arg[36] = Trim(dw_label.GetItemString(llRowPos,'user_field14')) /*Ecommerce ID*/  // Jxlim 09/10/2014 Anki use dm.user_field14 as Ecommerce ID. Cust_order_no not enough lenght
	//lstrparms.String_arg[15] = String(Round(dw_label.object.delivery_packing_quantity[llRowPos],0))
	lstrparms.String_arg[17] = dw_label.object.delivery_master_invoice_no[llRowPos]
	lstrparms.String_arg[21] = dw_label.object.delivery_master_do_no[llRowPos]
	lstrparms.String_arg[25] = dw_label.object.delivery_master_carrier[llRowPos]
	lstrparms.String_arg[27] = dw_label.object.Delivery_Packing_Shipper_Tracking_ID[llRowPos]
	lstrparms.String_arg[34] = dw_label.GetItemString(llRowPos,'awb_bol_no') /* 12/03 - PCONKL */
	lstrparms.String_arg[45] = dw_label.GetItemString(llRowPos,'client_cust_po_nbr')
	
	//19-AUG-2018 :Madhu S22720 - TMS Load Plan Details
	lstrparms.String_arg[37] = dw_label.GetItemString(llRowPos,'Load_Id')
	lstrparms.Long_arg[7] = dw_label.GetItemNumber(llRowPos,'Stop_Id')
	lstrparms.Long_arg[8] = dw_label.GetItemNumber(llRowPos,'Load_Sequence')

	lstrparms.Long_arg[1] = llQty /*Qty of labels to print*/
	lstrparms.Long_arg[3] = dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross')/*carton weight */
	
	IF dw_label.object.delivery_packing_standard_of_measure[llRowPos] = 'M' THEN			
		lstrparms.Long_arg[3]= round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross'),"KG","PO"),2)
		lstrparms.Long_arg[4] = dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross')/*carton qty */
	ELSE	
		lstrparms.Long_arg[4]= round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross'),"PO","KG"),2)		
	END IF

		
	//Exclusively for calculating total weight only
	ls_old_carton_no1 = dw_label.object.delivery_packing_carton_no[llRowPos]
	For llRowPos1 = llRowPos to llRowCount /*each detail row */
		
		IF dw_label.object.c_print_ind[llRowPos1] <> 'Y' THEN Continue
		ls_carton_no1= dw_label.object.delivery_packing_carton_no[llRowPos1]
		IF ls_old_carton_no1 <>  ls_carton_no1 THEN Exit
		 //It is a duplicate carton number
		 ll_cnt1++
		 
			IF dw_label.object.delivery_packing_standard_of_measure[llRowPos1] = 'M' THEN			
				ll_tot_english_weight = ll_tot_english_weight + round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross'),"KG","PO"),2)
				ll_tot_metrics_weight = ll_tot_metrics_weight + dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross')/*carton qty */
			ELSE
				ll_tot_english_weight = ll_tot_english_weight + dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross')/*carton qty */
				ll_tot_metrics_weight = ll_tot_metrics_weight + round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross'),"PO","KG"),2)		
			END IF
		lstrparms.Long_arg[5]=ll_tot_english_weight	
		lstrparms.Long_arg[6]=ll_tot_metrics_weight	
		ls_old_carton_no1= ls_carton_no1
		
	 Next			 

	//Label x of y should be generated from Unique carton count instead of Number of packing rows
	//since multiple packing rows may be consolidated to 1 label. (SQL is distinct but if weights are different on packing, we'll have multiple rows)
	
	If lscartonHold <> ls_carton_no Then
		llLabelof ++
	End If
	
	lscartonHold = ls_carton_no
	
	lstrparms.String_Arg[28] = String(llLabelof) +" of " + String(llLabelCount)
	ll_tot_metrics_weight =0;ll_tot_english_weight =0
	
	// 12/03 - PCONKL - We need to pass the UCCS Prefix (Location + Company)
	lstrparms.String_arg[35] = isuccswhprefix + isuccscompanyprefix
	
	//BCR 12-OCT-2011: For RUN-WORLD, Ship Date on Label should be Request Date on w_do...
	lstrparms.datetime_arg[1] = w_do.idw_main.GetItemDateTime(1, 'request_date')
	//END
	
	lsAny=lstrparms	
	
//	invo_labels.uf_generic_uccs_zebra(lsAny)
	invo_labels.uf_pandora_generic_shipping_label(lsAny)

	ls_old_carton_no =  ls_carton_no					
	 
Next /*detail row to Print*/



end event

event ue_print_2d_pallet_label();//07-SEP-2018 :Madhu S23255 Shipping Labels
//Print 2D Pallet Label

Str_Parms	lstrparms, lstrParms_palletId, lstr_serialList, ls_str_serial_data, ls_str_empty
String ls_sku, ls_coo, ls_prev_pallet_Id , ls_pallet_Id
string ls_carton_type, ls_wh, ls_sql, ls_errors, lsLabelPrint, ls_sscc, ls_max_limit

long  llRowPos, llRowCount, ll_pick_find_row, ll_serial_row, ll_find_row
long	ll_row, ll_cont_row, ll_New_row, ll_Return, ll_max_limit, llQty

Any	lsAny

Datastore lds_label_data, ldsSerial
lds_label_data =create Datastore
lds_label_data.dataobject ='d_pandora_2d_barcode_label_data'

dw_label.accepttext( )

//get MAX Limit of QR Barcode from Look Up Table
ls_max_limit =f_retrieve_parm(gs_project, 'QRBARCODE','MAX')
If IsNumber(ls_max_limit) Then ll_max_limit =long(ls_max_limit)

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

OpenWithParm(w_label_print_options,lstrparms)
lstrparms = Message.PowerObjectParm		  
If lstrparms.Cancelled Then Return

lstrparms.boolean_arg[1] =rb_1.checked //200 DPI
lstrparms.boolean_arg[2] =rb_2.checked //300 DPI

ls_wh = w_do.idw_main.getItemString(1, 'wh_code') //wh code

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos =1 to llRowCount
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	//get pallet Id
	ls_pallet_Id = dw_label.getItemString( llRowPos, 'delivery_packing_carton_no')
	ls_carton_type = dw_label.getItemString( llRowPos, 'carton_type')
	
	//Foot Print Pallet Id - find a matching record on Delivery_Picking.Po_No2
	ll_pick_find_row = w_do.idw_pick.find("po_no2='"+ls_pallet_Id+"'", 1, w_do.idw_pick.rowcount())
	
	IF ll_pick_find_row > 0 and (upper(ls_carton_type) ='PALLET' or upper(ls_carton_type) ='CARTON') Then
		IF ( ls_prev_pallet_Id <> ls_pallet_Id) THEN
			lstrParms_palletId.string_arg[UpperBound(lstrParms_palletId.string_arg) +1] = ls_pallet_Id
		END IF
	End IF
	
	ls_prev_pallet_Id = ls_pallet_Id
Next

//get each pallet Id records from dw_label and loop through.
IF UpperBound(lstrParms_palletId.string_arg[]) > 0 THEN
	
	FOR ll_cont_row =1 to UpperBound(lstrParms_palletId.string_arg[])
		ls_pallet_Id =	lstrParms_palletId.string_arg[ll_cont_row]
		
		//get serial no's from Serial Number Inventory Table
		ldsSerial = create Datastore
		ls_sql = " select * from Serial_Number_Inventory with(nolock) "
		ls_sql += " where Project_Id ='"+gs_project+"' and wh_code ='"+ls_wh+"'"
		ls_sql += " and Po_No2 ='"+ls_pallet_Id+"'"
		ldsSerial.create( SQLCA.syntaxfromsql( ls_sql, "", ls_errors))
		ldsSerial.settransobject( SQLCA)
		ldsSerial.retrieve( )
		
		If (len(ls_errors) > 0 or ldsSerial.rowcount( ) =0) Then
			MessageBox("Labels", "Unable to retrieve Serial No Inventory Records against Pallet Id# "+ls_pallet_Id)
			Return
		End If

		For ll_serial_row = 1 to ldsSerial.rowcount( )
			lstr_serialList.string_arg[ll_serial_row] = ldsSerial.getItemString( ll_serial_row, 'serial_no')
		Next
		
		//split SN's against size of QR Barcode limit and return required labels count
		ls_str_serial_data = invo_labels_pandora.uf_split_serialno_by_length( lstr_serialList , ll_max_limit)
		
		//get sku and coo
		ll_find_row = dw_label.find( "delivery_packing_carton_no ='"+ls_pallet_Id+"'", 1, dw_label.rowcount())
		IF ll_find_row > 0 THEN
			ls_sku = dw_label.getItemString( ll_find_row, 'delivery_packing_sku')
			ls_coo = dw_label.getItemString( ll_find_row, 'country_of_origin')
		END IF

		For ll_row =1 to UpperBound(ls_str_serial_data.String_arg[])
			ll_New_row =lds_label_data.insertrow( 0)
			lds_label_data.setItem( ll_New_row, 'sku', ls_sku)
			lds_label_data.setItem( ll_New_row, 'pallet_id', ls_pallet_Id)
			lds_label_data.setItem( ll_New_row, 'label_text', "PALLET LABEL")
			lds_label_data.setItem( ll_New_row, 'serial_no', ls_str_serial_data.String_arg[ll_row])
			lds_label_data.setItem( ll_New_row, 'sscc_no', ls_pallet_Id)
			lds_label_data.setItem( ll_New_row, 'coo', ls_coo)
			lds_label_data.setItem( ll_New_row, 'print_x', string(ll_row))
			lds_label_data.setItem( ll_New_row, 'print_y', string(UpperBound(ls_str_serial_data.String_arg[])))
		NEXT
		
		//empty str_parms
		lstr_serialList =ls_str_empty
		ls_str_serial_data = ls_str_empty
	NEXT
END IF

//15-FEB-2019 :Madhu S29684 /DE8841 2D Carton Serial Label for Non Foot Print Items.
IF wf_find_non_footprint_items() and cbx_5.checked =FALSE THEN
	MessageBox('Labels', "Please select 2D Carton Serial Label to print Non-Foot Print Serialized SKU's")
	Return
ELSEIF UpperBound(lstrParms_palletId.string_arg[]) = 0 THEN
	MessageBox('Labels',"Pallets are not available for label printing!")
	Return
END IF

//Preparing print Label Data against above created data store.
llRowCount =lds_label_data.rowcount( )
IF llRowCount =0 Then
	MessageBox('Labels',"Pallet associated serial numbers are not available for label printing!")
	Return
End IF

For llRowPos = 1 to llRowCount
	
	ll_find_row = dw_label.find( "delivery_packing_carton_no ='"+lds_label_data.getItemString( llRowPos, 'sscc_no')+"'", 1, dw_label.rowcount())
	IF ll_find_row > 0 THEN
		llQty = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
		lstrparms.Long_arg[1] = llQty
	END IF

	lstrparms.string_arg[1] = lds_label_data.getItemString( llRowPos, 'label_text')
	lstrparms.string_arg[2] = lds_label_data.getItemString( llRowPos, 'serial_no')
	lstrparms.string_arg[3] = lds_label_data.getItemString( llRowPos, 'sscc_no')
	lstrparms.string_arg[4] = lds_label_data.getItemString( llRowPos, 'print_x') +' OF '+ lds_label_data.getItemString( llRowPos, 'print_y')
	
	lsAny=lstrparms
	invo_labels_pandora.uf_print_qr_barcode_label( lsAny)
NEXT


destroy lds_label_data
destroy ldsSerial
end event

event ue_print_2d_carton_label();//07-SEP-2018 :Madhu S23255 Shipping Labels
//Print 2D Carton Serial Label

Str_Parms	lstrparms, lstrParms_containerId, lstr_serialList, ls_str_serial_data, ls_str_empty
long  llRowPos, llRowCount, ll_pick_find_row, ll_pack_find_row, ll_serial_row, ll_find_row
string ls_carton_type, ls_wh, ls_sql, ls_errors, lsLabelPrint, ls_sscc, ls_max_limit

long	ll_row, ll_cont_row, ll_New_row, ll_Return, ll_max_limit, llQty
long	ll_filter_sn_count, ll_start_pos
String ls_sku, ls_coo, ls_prev_container_Id , ls_container_Id, lsFind, ls_carton_no

Any	lsAny

Datastore lds_label_data, ldsSerial
lds_label_data =create Datastore
lds_label_data.dataobject ='d_pandora_2d_barcode_label_data'

dw_label.accepttext( )

//get MAX Limit of QR Barcode from Look Up Table
ls_max_limit =f_retrieve_parm(gs_project, 'QRBARCODE','MAX')
If IsNumber(ls_max_limit) Then ll_max_limit =long(ls_max_limit)

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

OpenWithParm(w_label_print_options,lstrparms)
lstrparms = Message.PowerObjectParm		  
If lstrparms.Cancelled Then Return

lstrparms.boolean_arg[1] =rb_1.checked //200 DPI
lstrparms.boolean_arg[2] =rb_2.checked //300 DPI

ls_wh = w_do.idw_main.getItemString(1, 'wh_code') //wh code

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos =1 to llRowCount
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	//get container Id
	ls_container_Id = dw_label.getItemString( llRowPos, 'pack_container_id')
	ls_carton_type = dw_label.getItemString( llRowPos, 'carton_type') //19-Feb-2019 :Madhu DE8839 Added Carton Type
	
	IF not IsNull(ls_container_Id) and ls_container_Id <> '-' and ( ls_prev_container_Id <> ls_container_Id) and (upper(ls_carton_type) = 'PALLET' or upper(ls_carton_type) = 'CARTON') THEN
		lstrParms_containerId.string_arg[UpperBound(lstrParms_containerId.string_arg) +1] = ls_container_Id
	END IF
	
	ls_prev_container_Id = ls_container_Id
Next

//get each pallet Id records from dw_label and loop through.
IF UpperBound(lstrParms_containerId.string_arg[]) > 0 THEN
	
	FOR ll_cont_row =1 to UpperBound(lstrParms_containerId.string_arg[])
		ls_container_Id =	lstrParms_containerId.string_arg[ll_cont_row]
		
		//get serial no's from Serial Number Inventory Table
		ldsSerial = create Datastore
		ls_sql = " select * from Serial_Number_Inventory with(nolock) "
		ls_sql += " where Project_Id ='"+gs_project+"' and wh_code ='"+ls_wh+"'"
		ls_sql += " and carton_ID ='"+ls_container_Id+"'"
		ldsSerial.create( SQLCA.syntaxfromsql( ls_sql, "", ls_errors))
		ldsSerial.settransobject( SQLCA)
		ldsSerial.retrieve( )
		
		If (len(ls_errors) > 0 or ldsSerial.rowcount( ) =0) Then
			MessageBox("Labels", "Unable to retrieve Serial No Inventory Records against Container Id# "+ls_container_Id)
			Return
		End If

		For ll_serial_row = 1 to ldsSerial.rowcount( )
			lstr_serialList.string_arg[ll_serial_row] = ldsSerial.getItemString( ll_serial_row, 'serial_no')
		Next
		
		//split SN's against size of QR Barcode limit and return required labels count
		ls_str_serial_data = invo_labels_pandora.uf_split_serialno_by_length( lstr_serialList , ll_max_limit)
		
		//get sku and coo
		ll_find_row = dw_label.find( "pack_container_id ='"+ls_container_Id+"'", 1, dw_label.rowcount())
		IF ll_find_row > 0 THEN
			ls_sku = dw_label.getItemString( ll_find_row, 'delivery_packing_sku')
			ls_coo = dw_label.getItemString( ll_find_row, 'country_of_origin')
		END IF

		For ll_row =1 to UpperBound(ls_str_serial_data.String_arg[])
			ll_New_row =lds_label_data.insertrow( 0)
			lds_label_data.setItem( ll_New_row, 'sku', ls_sku)
			lds_label_data.setItem( ll_New_row, 'pallet_id', ls_container_Id)
			lds_label_data.setItem( ll_New_row, 'label_text', "CARTON LABEL")
			lds_label_data.setItem( ll_New_row, 'serial_no', ls_str_serial_data.String_arg[ll_row])
			lds_label_data.setItem( ll_New_row, 'sscc_no', ls_container_Id)
			lds_label_data.setItem( ll_New_row, 'coo', ls_coo)
			lds_label_data.setItem( ll_New_row, 'print_x', string(ll_row))
			lds_label_data.setItem( ll_New_row, 'print_y', string(UpperBound(ls_str_serial_data.String_arg[])))
		NEXT
		
		//empty str_parms
		lstr_serialList =ls_str_empty
		ls_str_serial_data = ls_str_empty
	NEXT
END IF

//15-FEB-2019 :Madhu S29684 2D Carton Serial Label for Non Foot Print Items. - START
IF wf_find_non_footprint_items() THEN

	//loop through each carton No.
	lsFind =" c_print_ind = 'Y' and pack_container_id='-' and serialized_ind <>'N'"
	ll_find_row = dw_label.find( lsFind, 0 , dw_label.rowcount())
	
	DO WHILE ll_find_row > 0
	
		ll_start_pos = ll_find_row
		
		//get carton No, sku, do_no
		ls_carton_no = dw_label.getItemString(ll_find_row, 'delivery_packing_carton_no')
		ls_sku = dw_label.getItemString( ll_find_row, 'delivery_packing_sku')
		ls_coo = dw_label.getItemString( ll_find_row, 'country_of_origin')
		
		//get serial No's from Delivery Serial Detail Tab		
		//apply filter
		w_do.idw_serial.setfilter("sku ='"+ls_sku+"' and carton_no='"+ls_carton_no+"'")
		w_do.idw_serial.filter()
		ll_filter_sn_count = w_do.idw_serial.rowcount()
		
		For ll_serial_row = 1 to ll_filter_sn_count
			lstr_serialList.string_arg[ll_serial_row] = w_do.idw_serial.getItemString(ll_serial_row, 'serial_no')
		Next
		
		//clear filter
		w_do.idw_serial.setfilter("")
		w_do.idw_serial.filter()
		w_do.idw_serial.rowcount()			
		
		//split SN's against size of QR Barcode limit and return required labels count
		ls_str_serial_data = invo_labels_pandora.uf_split_serialno_by_length( lstr_serialList , ll_max_limit)
		
		For ll_row =1 to UpperBound(ls_str_serial_data.String_arg[])
			ll_New_row =lds_label_data.insertrow( 0)
			lds_label_data.setItem( ll_New_row, 'sku', ls_sku)
			lds_label_data.setItem( ll_New_row, 'pallet_id', ls_carton_no)
			lds_label_data.setItem( ll_New_row, 'label_text', "CARTON LABEL")
			lds_label_data.setItem( ll_New_row, 'serial_no', ls_str_serial_data.String_arg[ll_row])
			lds_label_data.setItem( ll_New_row, 'sscc_no', ls_carton_no)
			lds_label_data.setItem( ll_New_row, 'coo', ls_coo)
			lds_label_data.setItem( ll_New_row, 'print_x', string(ll_row))
			lds_label_data.setItem( ll_New_row, 'print_y', string(UpperBound(ls_str_serial_data.String_arg[])))
		NEXT
		
		//empty str_parms
		lstr_serialList =ls_str_empty
		ls_str_serial_data = ls_str_empty
		
		//find next occurance
		ll_find_row = dw_label.find( lsFind, ll_start_pos +1 , dw_label.rowcount()+1)
	LOOP
		
END IF
//15-FEB-2019 :Madhu S29684 2D Carton Serial Label for Non Foot Print Items. - END
	
IF UpperBound(lstrParms_containerId.string_arg[]) = 0 and wf_find_non_footprint_items() =FALSE THEN
	MessageBox('Labels',"Containers are not available for printing 2D Carton Label!")
	Return
END IF

//Preparing print Label Data against above created data store.
llRowCount =lds_label_data.rowcount( )
IF llRowCount =0 Then
	MessageBox('Labels',"Container associated serial numbers are not available for label printing!")
	Return
End IF

For llRowPos = 1 to llRowCount
	
	ll_find_row = dw_label.find( "pack_container_id ='"+lds_label_data.getItemString( llRowPos, 'sscc_no')+"'", 1, dw_label.rowcount())
	IF ll_find_row > 0 THEN
		llQty = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
		lstrparms.Long_arg[1] = llQty
	END IF

	lstrparms.string_arg[1] = lds_label_data.getItemString( llRowPos, 'label_text')
	lstrparms.string_arg[2] = lds_label_data.getItemString( llRowPos, 'serial_no')
	lstrparms.string_arg[3] = lds_label_data.getItemString( llRowPos, 'sscc_no')
	lstrparms.string_arg[4] = lds_label_data.getItemString( llRowPos, 'print_x') +' OF '+ lds_label_data.getItemString( llRowPos, 'print_y')
	
	lsAny=lstrparms
	invo_labels_pandora.uf_print_qr_barcode_label( lsAny)
NEXT


destroy lds_label_data
destroy ldsSerial
end event

event ue_print_generic_address_label();//07-SEP-2018 :Madhu S23255 Shipping Labels
//Print Generic Address Label

Str_Parms	lstrparms
string	lsCityStateZip, ls_old_carton_no,ls_carton_no,ls_old_carton_no1,ls_carton_no1,lsDONO, lsCartonHold
long ll_tot_metrics_weight,ll_tot_english_weight,ll_cnt1
long	llQty, llRowCount, llRowPos, ll_rtn, ll_alloc_qty, llRowPos1, llLabelCount, llLabelOf
Any	lsAny

dw_Label.AcceptText()

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

OpenWithParm(w_label_print_options,lstrparms)
lstrparms = Message.PowerObjectParm		  
If lstrparms.Cancelled Then Return

lsDoNo = dw_label.GetITemString(1,'delivery_Master_do_no')
lscartonHold = ''

lstrparms.boolean_arg[1] =rb_1.checked //200 DPI
lstrparms.boolean_arg[2] =rb_2.checked //300 DPI

Select Count(distinct Carton_NO) Into :llLabelCount
From Delivery_Packing with(nolock)
Where do_no = :lsDONO
And Carton_No > 0;

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]
	llQty = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
	lstrparms.Long_arg[1] = llQty
			
	lstrparms.String_arg[2] = dw_label.GetItemString(llRowPos,'warehouse_wh_name')
	lstrparms.String_arg[3] = dw_label.GetItemString(llRowPos,'warehouse_address_1')
	lstrparms.String_arg[4] = dw_label.GetItemString(llRowPos,'warehouse_address_2')
	lstrparms.String_arg[5] = dw_label.GetItemString(llRowPos,'warehouse_address_3')
	lstrparms.String_arg[6] = dw_label.GetItemString(llRowPos,'Warehouse_address_4')
		
	//Compute FROM City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_city')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'warehouse_city') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_state')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_state') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_zip') + ' '
	lstrparms.String_arg[7] = lsCityStateZip
			
	lstrparms.String_arg[8] = dw_label.GetItemString(llRowPos,'delivery_master_Cust_name')
	lstrparms.String_arg[9] = dw_label.GetItemString(llRowPos,'delivery_master_address_1')
	lstrparms.String_arg[10] = dw_label.GetItemString(llRowPos,'delivery_master_address_2')
	lstrparms.String_arg[11] = dw_label.GetItemString(llRowPos,'delivery_master_address_3')
	lstrparms.String_arg[12] = dw_label.GetItemString(llRowPos,'delivery_master_address_4')
	lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'delivery_master_Zip')
			
	//Compute TO City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_City')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'delivery_master_City') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_State')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_State') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_Zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_Zip') + ' '
	lstrparms.String_arg[14] = lsCityStateZip
	
	lstrparms.String_arg[15] = dw_label.object.delivery_master_carrier[llRowPos] //Carrier
	lstrparms.String_arg[16] = dw_label.GetItemString(llRowPos,'awb_bol_no') //Bol Nbr
	lstrparms.String_arg[17] = dw_label.GetItemString(llRowPos,'Load_Id') //Load Id
	lstrparms.Long_arg[7] = dw_label.GetItemNumber(llRowPos,'Stop_Id') //Stop Id
	lstrparms.Long_arg[8] = dw_label.GetItemNumber(llRowPos,'Load_Sequence') //Load Sequence
	
	lstrparms.String_arg[18] = dw_label.object.delivery_master_invoice_no[llRowPos] //Order No
	lstrparms.String_arg[19] = dw_label.GetItemString(llRowPos,'delivery_master_cust_order_no') //Cust Order No
	lstrparms.String_arg[20] = dw_label.object.delivery_master_do_no[llRowPos] //Shipment Id
	lstrparms.String_arg[21] = dw_label.object.Delivery_Packing_Shipper_Tracking_ID[llRowPos] //Shipper Tracking Id
	lstrparms.String_arg[22] = dw_label.GetItemString(llRowPos,'client_cust_po_nbr') //Vendor Order No
	
	If isnumber(dw_label.object.delivery_packing_carton_no[llRowPos]) Then
		lstrparms.String_arg[23] = String(Double(dw_label.object.delivery_packing_carton_no[llRowPos]),'000000000')
	Else
		dw_label.object.delivery_packing_carton_no[llRowPos]
	End If
	
	lstrparms.String_arg[26] = Trim(dw_label.GetItemString(llRowPos,'user_field14')) /*Ecommerce ID*/
	
	lstrparms.Long_arg[1] = llQty /*Qty of labels to print*/
	lstrparms.Long_arg[3] = dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross')/*carton weight */
	
	IF dw_label.object.delivery_packing_standard_of_measure[llRowPos] = 'M' THEN			
		lstrparms.Long_arg[3]= round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross'),"KG","PO"),2)
		lstrparms.Long_arg[4] = dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross')/*carton qty */
	ELSE	
		lstrparms.Long_arg[4]= round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross'),"PO","KG"),2)		
	END IF

		
	//Exclusively for calculating total weight only
	ls_old_carton_no1 = dw_label.object.delivery_packing_carton_no[llRowPos]
	For llRowPos1 = llRowPos to llRowCount /*each detail row */
		
		IF dw_label.object.c_print_ind[llRowPos1] <> 'Y' THEN Continue
		ls_carton_no1= dw_label.object.delivery_packing_carton_no[llRowPos1]
		IF ls_old_carton_no1 <>  ls_carton_no1 THEN Exit
		 //It is a duplicate carton number
		 ll_cnt1++
		 
			IF dw_label.object.delivery_packing_standard_of_measure[llRowPos1] = 'M' THEN			
				ll_tot_english_weight = ll_tot_english_weight + round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross'),"KG","PO"),2)
				ll_tot_metrics_weight = ll_tot_metrics_weight + dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross')/*carton qty */
			ELSE
				ll_tot_english_weight = ll_tot_english_weight + dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross')/*carton qty */
				ll_tot_metrics_weight = ll_tot_metrics_weight + round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross'),"PO","KG"),2)		
			END IF
		lstrparms.Long_arg[5]=ll_tot_english_weight	
		lstrparms.Long_arg[6]=ll_tot_metrics_weight	
		ls_old_carton_no1= ls_carton_no1
		
	 Next			 

	If lscartonHold <> ls_carton_no Then
		llLabelof ++
		lstrparms.String_Arg[24] = String(llLabelof) +" of " + String(llLabelCount)
		ll_tot_metrics_weight =0;ll_tot_english_weight =0
		
		lstrparms.String_arg[25] = is_ucc_prefix
		lstrparms.datetime_arg[1] = w_do.idw_main.GetItemDateTime(1, 'request_date')
		lsAny=lstrparms	
		
		invo_labels_pandora.uf_print_generic_address_label(lsAny)
	End If
	
	lscartonHold = ls_carton_no
 
Next /*detail row to Print*/
end event

event ue_print_google_shipping_label();//07-SEP-2018 :Madhu S23255 Shipping Labels
//Print Google Shipping Label

Str_Parms	lstrparms

string ls_sku_desc, ls_uf14, ls_complete_description, ls_description, ls_pack_container_id, ls_pack_sscc_no
string ls_description1, ls_description2, ls_description3, ls_description4, ls_temp
string lsdono, ls_carton_no, lscitystatezip, ls_old_carton_no
Long	llQty, llRowCount, llRowPos, ll_rtn, ll_alloc_qty, llRowPos1, llLabelCount, llLabelOf
long   ll_row, ll_remain_length, ll_count
		
Any	lsAny

dw_Label.accepttext( )

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

OpenWithParm(w_label_print_options,lstrparms)
lstrparms = Message.PowerObjectParm		  
If lstrparms.Cancelled Then Return 

lsDoNo = dw_label.GetITemString(1,'delivery_Master_do_no')

llLabelCount = dw_label.RowCount() //Total Label Count

lstrparms.boolean_arg[1] =rb_1.checked //200 DPI
lstrparms.boolean_arg[2] =rb_2.checked //300 DPI

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]
	llQty = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
	lstrparms.Long_arg[1] = llQty
			
	lstrparms.String_arg[2] = dw_label.GetItemString(llRowPos,'warehouse_wh_name')
	lstrparms.String_arg[3] = dw_label.GetItemString(llRowPos,'warehouse_address_1')
	lstrparms.String_arg[4] = dw_label.GetItemString(llRowPos,'warehouse_address_2')
	lstrparms.String_arg[5] = dw_label.GetItemString(llRowPos,'warehouse_address_3')
	lstrparms.String_arg[6] = dw_label.GetItemString(llRowPos,'Warehouse_address_4')
		
	//Compute FROM City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_city')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'warehouse_city') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_state')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_state') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_zip') + ' '
	lstrparms.String_arg[7] = lsCityStateZip
			
	lstrparms.String_arg[8] = dw_label.GetItemString(llRowPos,'delivery_master_Cust_name')
	lstrparms.String_arg[9] = dw_label.GetItemString(llRowPos,'delivery_master_address_1')
	lstrparms.String_arg[10] = dw_label.GetItemString(llRowPos,'delivery_master_address_2')
	lstrparms.String_arg[11] = dw_label.GetItemString(llRowPos,'delivery_master_address_3')
	lstrparms.String_arg[12] = dw_label.GetItemString(llRowPos,'delivery_master_address_4')
	lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'delivery_master_Zip')
			
	//Compute TO City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_City')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'delivery_master_City') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_State')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_State') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_Zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_Zip') + ' '
	lstrparms.String_arg[14] = lsCityStateZip
	
	lstrparms.String_arg[15] = dw_label.GetItemString(llRowPos, 'item_master_serialized_ind') //IM Serialized Ind

	lstrparms.String_arg[17] = dw_label.GetItemString(llRowPos,'delivery_packing_sku') //DP Sku
	lstrparms.datetime_arg[1] = dw_label.GetItemDateTime(llRowPos, 'delivery_packing_pack_expiration_date') //DP Exp Date
	lstrparms.String_arg[18] = dw_label.GetItemString(llRowPos,'item_master_alternate_sku') //IM Alt Sku
	lstrparms.String_arg[19] = dw_label.GetItemString(llRowPos,'delivery_packing_country_of_origin') //DP COO

	ls_sku_desc = dw_label.GetItemString(llRowPos,'item_master_description') //IM Description
	ls_uf14 = dw_label.getItemString( llRowPos, 'item_master_user_field14') //User Field14		
	
	If (not isnull(ls_sku_desc) and len(ls_sku_desc) > 0 ) Then ls_complete_description = ls_sku_desc
	If (not isnull(ls_uf14) and len(ls_uf14) > 0 ) Then ls_complete_description += ls_uf14
	
	//split the description into multiple fields. Each field can hold upto 50 chars.
	ll_count =0
	ll_remain_length = len(ls_complete_description)
	
	DO WHILE ll_remain_length > 0
		ll_count++
		
		CHOOSE CASE ll_count
		
		CASE 1  //1-50
			IF ll_remain_length > 50 Then
				ls_description = left(ls_complete_description, 50)
				ll_remain_length = ll_remain_length -50
				lstrparms.String_arg[20] = ls_description //SKU Description
			ELSE
				ls_description = left(ls_complete_description, ll_remain_length)
				lstrparms.String_arg[20] = ls_description //SKU Description
				ll_remain_length = 0
			END IF
		
		CASE 2 //51-100
			IF ll_remain_length > 50 Then
				ls_description1 = Mid(ls_complete_description, 51, 50)
				ll_remain_length = ll_remain_length -50
				lstrparms.String_arg[21] = ls_description1 //SKU Description1
			ELSE
				ls_description1 = Mid(ls_complete_description, 51, ll_remain_length)
				lstrparms.String_arg[21] = ls_description1 //SKU Description1
				ll_remain_length = 0
			END IF
		
		CASE 3 //101-150
			IF ll_remain_length > 50 Then
				ls_description2 = Mid(ls_complete_description, 101, 50)
				ll_remain_length = ll_remain_length -50
				lstrparms.String_arg[22] = ls_description2 //SKU Description2
			ELSE
				ls_description2 = Mid(ls_complete_description, 101, ll_remain_length)
				lstrparms.String_arg[22] = ls_description2 //SKU Description2
				ll_remain_length = 0
			END IF
		
		CASE 4 //151-200
			IF ll_remain_length > 50 Then
				ls_description3 = Mid(ls_complete_description, 151, 50)
				ll_remain_length = ll_remain_length -50
				lstrparms.String_arg[23] = ls_description3 //SKU Description3
			ELSE
				ls_description3 = Mid(ls_complete_description, 151, ll_remain_length)
				lstrparms.String_arg[23] = ls_description3 //SKU Description3
				ll_remain_length = 0
			END IF
		
		CASE 5 //201-250
			IF ll_remain_length > 50 Then
				ls_description4 = Mid(ls_complete_description, 201, 50)
				ll_remain_length = ll_remain_length -50
				lstrparms.String_arg[24] = ls_description4 //SKU Description4
			ELSE
				ls_description4 = Mid(ls_complete_description, 201, ll_remain_length)
				lstrparms.String_arg[24] = ls_description4 //SKU Description4
				ll_remain_length = 0
			END IF
		END CHOOSE
	LOOP

	lstrparms.Long_arg[2] = dw_label.GetItemNumber(llRowPos,'delivery_packing_quantity') //DP Qty
	lstrparms.String_arg[25] = dw_label.GetItemString(llRowPos,'delivery_master_cust_order_no') //DM Cust Order No
	lstrparms.Long_arg[3] = dw_label.GetItemNumber(llRowPos,'delivery_packing_line_item_no') //DP Line Item No
	lstrparms.String_arg[26] = dw_label.GetItemString(llRowPos,'client_cust_po_nbr') //DM Client Cust Po Nbr
	
	ls_pack_container_id = dw_label.GetItemString(llRowPos,'delivery_packing_pack_container_id') //DP Pack Container Id	
	ls_pack_sscc_no = dw_label.GetItemString(llRowPos,'delivery_packing_pack_sscc_no') //DP Pack SSCC No
	
	//Pack SSCC No
	If not IsNull(ls_pack_container_id) and ls_pack_container_id <> '-' Then
		lstrparms.String_arg[27] = ls_pack_container_id
		
	elseIf not IsNull(ls_pack_sscc_no) and ls_pack_sscc_no <> '-' Then
		lstrparms.String_arg[27] = ls_pack_sscc_no
		
	elseIf isnumber(dw_label.object.delivery_packing_carton_no[llRowPos]) Then
		ls_temp = String(Long(dw_label.object.delivery_packing_carton_no[llRowPos]),'000000000')
		lstrparms.String_arg[27] = 	invo_labels_pandora.uf_generate_sscc( ls_temp)
		dw_label.setItem( llRowPos, 'delivery_packing_pack_sscc_no', lstrparms.String_arg[27])
		
	else
		ls_temp = dw_label.object.delivery_packing_carton_no[llRowPos]
		lstrparms.String_arg[27] = 	invo_labels_pandora.uf_generate_sscc( ls_temp)
		dw_label.setItem( llRowPos, 'delivery_packing_pack_sscc_no', lstrparms.String_arg[27])
	End If
	
	lstrparms.String_arg[28] = dw_label.GetItemString(llRowPos,'item_master_qa_check_ind') //IM QA Check Ind
	
	llLabelof ++
	lstrparms.String_Arg[29] = String(llLabelof) +" of " + String(llLabelCount)
	lstrparms.String_arg[30] = is_ucc_prefix
	
	lsAny=lstrparms	
	invo_labels_pandora.uf_print_google_shipping_label(lsAny)
	 
Next /*detail row to Print*/
end event

event ue_print_include_pallet_label();//07-SEP-2018 :Madhu S23255 Shipping Labels
//Print Include Pallet SSCC Label

Str_Parms	lstrparms

string	lsCityStateZip, ls_old_carton_no,ls_carton_no,	lsDONO
string	ls_sscc_no, ls_outerpack_sscc_no, ls_prev_outerpack_sscc_no
string	ls_old_carton_no1, ls_carton_no1, ls_pack_sscc_no, ls_pallet_Id

long	ll_outerpack_sscc_no_count, ll_seq, ll_check, ll_pick_find_row
long	llQty, llRowCount, llRowPos, llLabelOf, llRowPos1
long	ll_cnt1, ll_tot_english_weight, ll_tot_metrics_weight

Any	lsAny

dw_label.AcceptText()

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

OpenWithParm(w_label_print_options,lstrparms)
lstrparms = Message.PowerObjectParm		  
If lstrparms.Cancelled Then Return 

lsDoNo = dw_label.GetITemString(1,'delivery_Master_do_no')
lstrparms.boolean_arg[1] =rb_1.checked //200 DPI
lstrparms.boolean_arg[2] =rb_2.checked //300 DPI

//get distinct outerpack sscc no's
For llRowPos = 1 to dw_label.RowCount()

	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	ls_outerpack_sscc_no =dw_label.getItemString( llRowPos, 'outerpack_sscc_no')
	If IsNull(ls_outerpack_sscc_no) Then ls_outerpack_sscc_no ='-'
	
	If ls_prev_outerpack_sscc_no <> ls_outerpack_sscc_no Then
		ll_outerpack_sscc_no_count++
	End If
	ls_prev_outerpack_sscc_no = ls_outerpack_sscc_no
Next

ll_seq =900 //start sequence with 900
ls_prev_outerpack_sscc_no =""

//Print each detail Row
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount

	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]
	llQty = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
	lstrparms.Long_arg[1] = llQty
	
	lstrparms.String_arg[2] = dw_label.GetItemString(llRowPos,'warehouse_wh_name')
	lstrparms.String_arg[3] = dw_label.GetItemString(llRowPos,'warehouse_address_1')
	lstrparms.String_arg[4] = dw_label.GetItemString(llRowPos,'warehouse_address_2')
	lstrparms.String_arg[5] = dw_label.GetItemString(llRowPos,'warehouse_address_3')
	lstrparms.String_arg[6] = dw_label.GetItemString(llRowPos,'Warehouse_address_4')
	
	//Compute FROM City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_city')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'warehouse_city') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_state')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_state') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_zip') + ' '
	lstrparms.String_arg[7] = lsCityStateZip
	
	lstrparms.String_arg[8] = dw_label.GetItemString(llRowPos,'delivery_master_Cust_name')
	lstrparms.String_arg[9] = dw_label.GetItemString(llRowPos,'delivery_master_address_1')
	lstrparms.String_arg[10] = dw_label.GetItemString(llRowPos,'delivery_master_address_2')
	lstrparms.String_arg[11] = dw_label.GetItemString(llRowPos,'delivery_master_address_3')
	lstrparms.String_arg[12] = dw_label.GetItemString(llRowPos,'delivery_master_address_4')
	lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'delivery_master_Zip')
	
	//Compute TO City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_City')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'delivery_master_City') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_State')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_State') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_Zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_Zip') + ' '
	lstrparms.String_arg[14] = lsCityStateZip
	
	lstrparms.String_arg[15] = dw_label.object.delivery_master_carrier[llRowPos] //Carrier
	lstrparms.String_arg[16] = dw_label.GetItemString(llRowPos,'awb_bol_no') //Bol Nbr
	lstrparms.String_arg[17] = dw_label.GetItemString(llRowPos,'Load_Id') //Load Id
	lstrparms.Long_arg[7] = dw_label.GetItemNumber(llRowPos,'Stop_Id') //Stop Id
	lstrparms.Long_arg[8] = dw_label.GetItemNumber(llRowPos,'Load_Sequence') //Load Sequence
	
	lstrparms.String_arg[18] = dw_label.object.delivery_master_invoice_no[llRowPos] //Order No
	lstrparms.String_arg[19] = dw_label.GetItemString(llRowPos,'delivery_master_cust_order_no') //Cust Order No
	lstrparms.String_arg[20] = dw_label.object.delivery_master_do_no[llRowPos] //Shipment Id
	lstrparms.String_arg[21] = dw_label.object.Delivery_Packing_Shipper_Tracking_ID[llRowPos] //Shipper Tracking Id
	lstrparms.String_arg[22] = dw_label.GetItemString(llRowPos,'client_cust_po_nbr') //Vendor Order No
	
	
	lstrparms.Long_arg[1] = llQty /*Qty of labels to print*/
	lstrparms.Long_arg[3] = dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross')/*carton weight */
	
	IF dw_label.object.delivery_packing_standard_of_measure[llRowPos] = 'M' THEN			
		lstrparms.Long_arg[3]= round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross'),"KG","PO"),2)
		lstrparms.Long_arg[4] = dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross')/*carton qty */
	ELSE	
		lstrparms.Long_arg[4]= round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross'),"PO","KG"),2)		
	END IF
	
	//Exclusively for calculating total weight only
	ls_old_carton_no1 = dw_label.object.delivery_packing_carton_no[llRowPos]
	For llRowPos1 = llRowPos to llRowCount /*each detail row */
		
		IF dw_label.object.c_print_ind[llRowPos1] <> 'Y' THEN Continue
		ls_carton_no1= dw_label.object.delivery_packing_carton_no[llRowPos1]
		IF ls_old_carton_no1 <>  ls_carton_no1 THEN Exit
		//It is a duplicate carton number
		ll_cnt1++
		
		IF dw_label.object.delivery_packing_standard_of_measure[llRowPos1] = 'M' THEN			
			ll_tot_english_weight = ll_tot_english_weight + round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross'),"KG","PO"),2)
			ll_tot_metrics_weight = ll_tot_metrics_weight + dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross')/*carton qty */
		ELSE
			ll_tot_english_weight = ll_tot_english_weight + dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross')/*carton qty */
			ll_tot_metrics_weight = ll_tot_metrics_weight + round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross'),"PO","KG"),2)		
		END IF

		lstrparms.Long_arg[5]=ll_tot_english_weight	
		lstrparms.Long_arg[6]=ll_tot_metrics_weight	
		ls_old_carton_no1= ls_carton_no1
	Next
	
	//generate SSCC No
	//If it is a Foot Print Item, store Delivery_Picking.Po_No2 as SSCC No else generate
	ls_pallet_Id = dw_label.getItemString( llRowPos, 'delivery_packing_carton_no') 	//get pallet Id
	
	//Foot Print Pallet Id - find a matching record on Delivery_Picking.Po_No2
	ll_pick_find_row = w_do.idw_pick.find("po_no2='"+ls_pallet_Id+"'", 1, w_do.idw_pick.rowcount())
	
	//27-SEP-2018 :Madhu DE6537 - UCC Company prefix should be 8 digits.
	IF ll_pick_find_row > 0 THEN
		ls_pack_sscc_no = ls_pallet_Id
	ELSE
		ls_sscc_no = string(long(is_ucc_prefix), '00000000')+Right(lsDoNo ,6)+string(ll_seq)
		
		ll_check = f_calc_uccs_check_Digit(ls_sscc_no) /*calculate the check digit*/
		If ll_check >=0 Then
			ls_pack_sscc_no = "00" + ls_sscc_no + String(ll_check)
		Else
			ls_pack_sscc_no = String(ls_sscc_no,'00000000000000000000')
		End If		
	END IF
	
	
	lstrparms.String_Arg[23] = ls_pack_sscc_no //OuterPack SSCC No
	ll_seq++
	
	//count 'x' of 'y'
	ls_outerpack_sscc_no =dw_label.getItemString( llRowPos, 'outerpack_sscc_no')
	If IsNull(ls_outerpack_sscc_no) Then ls_outerpack_sscc_no ='-'
	
	If ls_prev_outerpack_sscc_no <> ls_outerpack_sscc_no Then
		llLabelof++
		
		lstrparms.String_Arg[24] = String(llLabelof) +" of " + String(ll_outerpack_sscc_no_count)
		lstrparms.String_arg[25] = is_ucc_prefix
		lstrparms.datetime_arg[1] = w_do.idw_main.GetItemDateTime(1, 'request_date')
		
		lsAny=lstrparms	
		invo_labels_pandora.ue_print_include_pallet_sscc_label( lsAny)
	End If
	
	ls_prev_outerpack_sscc_no = ls_outerpack_sscc_no

Next /*detail row to Print*/
end event

event ue_print_pallet_container_label();//07-SEP-2018 :Madhu S23255 Shipping Labels
//Print Pallet Container Label

Any lsAny

Str_Parms lstrParms, lstrPalletIdList, lstrContainerdList, ls_str_empty
string ls_carton_no, ls_pack_container_id, ls_carton_type
string ls_pallet_Id, ls_prev_pallet_Id, ls_prev_pack_container_id, ls_filter
long ll_Row, ll_Find_Row, ll_label_count, ll_cont_id, ll_print_x, ll_remain_count
long ll_cont_row, llQty
boolean lbPrint

dw_label.accepttext( )

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

OpenWithParm(w_label_print_options,lstrparms)
lstrparms = Message.PowerObjectParm		  
If lstrparms.Cancelled Then Return 

lstrParms.boolean_arg[1] = rb_1.checked //200 DPI
lstrParms.boolean_arg[2] = rb_2.checked //300 DPI

//get disctinct Pallet Id's
FOR ll_Row =1 to dw_label.rowcount( )
	
	IF dw_label.object.c_print_ind[ll_Row] <> 'Y' THEN Continue
	
	llQty = dw_label.object.c_qty_per_carton[ll_Row] /*Number of copies from Setup window*/
	lstrparms.Long_arg[1] = llQty
	
	ls_pallet_Id = dw_label.getItemString( ll_Row, 'delivery_packing_carton_no')
	ls_pack_container_id = dw_label.getItemString( ll_Row, 'pack_container_id')
	ls_carton_type = dw_label.getItemString( ll_Row, 'carton_type')
	
	IF not IsNull(ls_pack_container_id) and ls_pack_container_id <> '-' and upper(ls_carton_type) = 'PALLET' THEN
		IF ls_prev_pallet_Id <> ls_pallet_Id THEN lstrPalletIdList.string_arg[UpperBound(lstrPalletIdList.string_arg)+1] = ls_pallet_Id
		ls_prev_pallet_Id = ls_pallet_Id
	END IF
NEXT	


//Loop through each pallet
IF UpperBound(lstrPalletIdList.string_arg[]) > 0 THEN
	FOR ll_Row =1 to UpperBound(lstrPalletIdList.string_arg[])
		ls_pallet_Id = lstrPalletIdList.string_arg[ll_Row] //get pallet Id
		
		ls_filter ="c_print_ind = 'Y' and delivery_packing_carton_no ='"+ls_pallet_Id+"'"
		ll_Find_Row = dw_label.find( ls_filter, 1, dw_label.rowcount())
		
		//get pallet associated container Ids'
		DO WHILE ll_Find_Row > 0 
			ls_pack_container_id = dw_label.getItemString(ll_Find_Row, 'pack_container_id')
			
			IF ls_prev_pack_container_id <> ls_pack_container_id THEN lstrContainerdList.string_arg[UpperBound(lstrContainerdList.string_arg)+1] = ls_pack_container_id
			ls_prev_pack_container_id = ls_pack_container_id
			
			ll_Find_Row = dw_label.find( ls_filter, ll_Find_Row+1, dw_label.rowcount()+1)
		LOOP
		
		//determine how many labels are required (x of y)
		ll_label_count =0
		ll_cont_id = 0
		ll_print_x = 1
		ll_remain_count = UpperBound(lstrContainerdList.string_arg[])
			
		DO WHILE ll_remain_count > 0 
			ll_label_count++
			ll_remain_count = ll_remain_count -7
		LOOP
			
		FOR ll_cont_row = 1 to UpperBound(lstrContainerdList.string_arg[])
		
			//each label print only 7 carton No's, If it exceeds push to next label.
			If ll_cont_id > 6  then 
				lsAny = lstrParms
				invo_labels_pandora.uf_print_pallet_container_label(lsAny)
				
				ll_cont_id = 1
				ll_print_x++
				lbPrint = True
			else
				ll_cont_id++
				lbPrint = False
			end If
			
			lstrParms.string_arg[ll_cont_id] = lstrContainerdList.string_arg[ll_cont_row]
			lstrParms.string_arg[8] =ls_pallet_Id
			lstrParms.string_arg[9] =string(ll_print_x) +' OF '+ string(ll_label_count)
			
		NEXT
	
		IF lbPrint = False THEN
			lsAny = lstrParms
			invo_labels_pandora.uf_print_pallet_container_label(lsAny)
		END IF
	
		lstrContainerdList = ls_str_empty //19-Feb-2019 :Madhu DE8837 clear container Id List
	NEXT
END IF

//15-FEB-2019 :Madhu S29684/DE8841 2D Carton Serial Label for Non Foot Print Items.
IF wf_find_non_footprint_items() and cbx_5.checked =FALSE THEN
	MessageBox('Labels', "Please select 2D Carton Serial Label to print Non-Foot Print Serialized SKU's")
	Return
ELSEIF UpperBound(lstrPalletIdList.string_arg[]) = 0 THEN
	MessageBox('Labels',"Pallet and associated Containers are not available for printing Pallet Container Label!")
	Return
END IF


end event

event ue_print_google_shipping_label_picklist();//Feb-23-2021 :Dinesh S53992 - Google -  SIMS - Outbound shipping Labels at Picking
//Print Google Shipping Label

Str_Parms	lstrparms

string ls_sku_desc, ls_uf14, ls_complete_description, ls_description, ls_container_id, ls_pack_sscc_no
string ls_description1, ls_description2, ls_description3, ls_description4, ls_temp
string lsdono, ls_carton_no, lscitystatezip, ls_old_carton_no
Long	llQty, llRowCount, llRowPos, ll_rtn, ll_alloc_qty, llRowPos1, llLabelCount, llLabelOf
long   ll_row, ll_remain_length, ll_count
		
Any	lsAny

dw_Label.accepttext( )

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

OpenWithParm(w_label_print_options,lstrparms)
lstrparms = Message.PowerObjectParm		  
If lstrparms.Cancelled Then Return 

lsDoNo = dw_label.GetITemString(1,'delivery_Master_do_no')

llLabelCount = dw_label.RowCount() //Total Label Count

lstrparms.boolean_arg[1] =rb_1.checked //200 DPI
lstrparms.boolean_arg[2] =rb_2.checked //300 DPI

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	//ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]
	llQty = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
	lstrparms.Long_arg[1] = llQty
			
	lstrparms.String_arg[2] = dw_label.GetItemString(llRowPos,'warehouse_wh_name')
	lstrparms.String_arg[3] = dw_label.GetItemString(llRowPos,'warehouse_address_1')
	lstrparms.String_arg[4] = dw_label.GetItemString(llRowPos,'warehouse_address_2')
	lstrparms.String_arg[5] = dw_label.GetItemString(llRowPos,'warehouse_address_3')
	lstrparms.String_arg[6] = dw_label.GetItemString(llRowPos,'Warehouse_address_4')
		
	//Compute FROM City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_city')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'warehouse_city') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_state')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_state') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_zip') + ' '
	lstrparms.String_arg[7] = lsCityStateZip
			
	lstrparms.String_arg[8] = dw_label.GetItemString(llRowPos,'delivery_master_Cust_name')
	lstrparms.String_arg[9] = dw_label.GetItemString(llRowPos,'delivery_master_address_1')
	lstrparms.String_arg[10] = dw_label.GetItemString(llRowPos,'delivery_master_address_2')
	lstrparms.String_arg[11] = dw_label.GetItemString(llRowPos,'delivery_master_address_3')
	lstrparms.String_arg[12] = dw_label.GetItemString(llRowPos,'delivery_master_address_4')
	lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'delivery_master_Zip')
			
	//Compute TO City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_City')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'delivery_master_City') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_State')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_State') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_Zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_Zip') + ' '
	lstrparms.String_arg[14] = lsCityStateZip
	
	lstrparms.String_arg[15] = dw_label.GetItemString(llRowPos, 'item_master_serialized_ind') //IM Serialized Ind

	lstrparms.String_arg[17] = dw_label.GetItemString(llRowPos,'delivery_picking_sku') //DP Sku
	lstrparms.datetime_arg[1] = dw_label.GetItemDateTime(llRowPos, 'expiration_date') //DP Exp Date
	lstrparms.String_arg[18] = dw_label.GetItemString(llRowPos,'item_master_alternate_sku') //IM Alt Sku
	lstrparms.String_arg[19] = dw_label.GetItemString(llRowPos,'delivery_picking_country_of_origin') //DP COO

	ls_sku_desc = dw_label.GetItemString(llRowPos,'item_master_description') //IM Description
	ls_uf14 = dw_label.getItemString( llRowPos, 'item_master_user_field14') //User Field14		
	
	If (not isnull(ls_sku_desc) and len(ls_sku_desc) > 0 ) Then ls_complete_description = ls_sku_desc
	If (not isnull(ls_uf14) and len(ls_uf14) > 0 ) Then ls_complete_description += ls_uf14
	
	//split the description into multiple fields. Each field can hold upto 50 chars.
	ll_count =0
	ll_remain_length = len(ls_complete_description)
	
	DO WHILE ll_remain_length > 0
		ll_count++
		
		CHOOSE CASE ll_count
		
		CASE 1  //1-50
			IF ll_remain_length > 50 Then
				ls_description = left(ls_complete_description, 50)
				ll_remain_length = ll_remain_length -50
				lstrparms.String_arg[20] = ls_description //SKU Description
			ELSE
				ls_description = left(ls_complete_description, ll_remain_length)
				lstrparms.String_arg[20] = ls_description //SKU Description
				ll_remain_length = 0
			END IF
		
		CASE 2 //51-100
			IF ll_remain_length > 50 Then
				ls_description1 = Mid(ls_complete_description, 51, 50)
				ll_remain_length = ll_remain_length -50
				lstrparms.String_arg[21] = ls_description1 //SKU Description1
			ELSE
				ls_description1 = Mid(ls_complete_description, 51, ll_remain_length)
				lstrparms.String_arg[21] = ls_description1 //SKU Description1
				ll_remain_length = 0
			END IF
		
		CASE 3 //101-150
			IF ll_remain_length > 50 Then
				ls_description2 = Mid(ls_complete_description, 101, 50)
				ll_remain_length = ll_remain_length -50
				lstrparms.String_arg[22] = ls_description2 //SKU Description2
			ELSE
				ls_description2 = Mid(ls_complete_description, 101, ll_remain_length)
				lstrparms.String_arg[22] = ls_description2 //SKU Description2
				ll_remain_length = 0
			END IF
		
		CASE 4 //151-200
			IF ll_remain_length > 50 Then
				ls_description3 = Mid(ls_complete_description, 151, 50)
				ll_remain_length = ll_remain_length -50
				lstrparms.String_arg[23] = ls_description3 //SKU Description3
			ELSE
				ls_description3 = Mid(ls_complete_description, 151, ll_remain_length)
				lstrparms.String_arg[23] = ls_description3 //SKU Description3
				ll_remain_length = 0
			END IF
		
		CASE 5 //201-250
			IF ll_remain_length > 50 Then
				ls_description4 = Mid(ls_complete_description, 201, 50)
				ll_remain_length = ll_remain_length -50
				lstrparms.String_arg[24] = ls_description4 //SKU Description4
			ELSE
				ls_description4 = Mid(ls_complete_description, 201, ll_remain_length)
				lstrparms.String_arg[24] = ls_description4 //SKU Description4
				ll_remain_length = 0
			END IF
		END CHOOSE
	LOOP

	lstrparms.Long_arg[2] = dw_label.GetItemNumber(llRowPos,'delivery_picking_quantity') //DP Qty
	lstrparms.String_arg[25] = dw_label.GetItemString(llRowPos,'delivery_master_cust_order_no') //DM Cust Order No
	lstrparms.Long_arg[3] = dw_label.GetItemNumber(llRowPos,'delivery_picking_line_item_no') //DP Line Item No
	lstrparms.String_arg[26] = dw_label.GetItemString(llRowPos,'client_cust_po_nbr') //DM Client Cust Po Nbr
	
	ls_container_id = dw_label.GetItemString(llRowPos,'container_id') //DP Pick Container Id	
	//ls_pack_sscc_no = dw_label.GetItemString(llRowPos,'delivery_packing_pack_sscc_no') //DP Pack SSCC No
	
	//Pack SSCC No
	If not IsNull(ls_container_id) and ls_container_id <> '-' Then
		lstrparms.String_arg[27] = ls_container_id
		
//	elseIf not IsNull(ls_pack_sscc_no) and ls_pack_sscc_no <> '-' Then
//		lstrparms.String_arg[27] = ls_pack_sscc_no
//		
//	elseIf isnumber(dw_label.object.delivery_packing_carton_no[llRowPos]) Then
//		ls_temp = String(Long(dw_label.object.delivery_packing_carton_no[llRowPos]),'000000000')
//		lstrparms.String_arg[27] = 	invo_labels_pandora.uf_generate_sscc( ls_temp)
//		dw_label.setItem( llRowPos, 'delivery_packing_pack_sscc_no', lstrparms.String_arg[27])
//		
//	else
//		ls_temp = dw_label.object.delivery_packing_carton_no[llRowPos]
//		lstrparms.String_arg[27] = 	invo_labels_pandora.uf_generate_sscc( ls_temp)
//		dw_label.setItem( llRowPos, 'delivery_packing_pack_sscc_no', lstrparms.String_arg[27])
	End If
	
	lstrparms.String_arg[28] = dw_label.GetItemString(llRowPos,'item_master_qa_check_ind') //IM QA Check Ind
	
	llLabelof ++
	lstrparms.String_Arg[29] = String(llLabelof) +" of " + String(llLabelCount)
	lstrparms.String_arg[30] = is_ucc_prefix
	
	lsAny=lstrparms	
	invo_labels_pandora.uf_print_google_shipping_label(lsAny)
	 
Next /*detail row to Print*/
end event

public function boolean wf_find_non_footprint_items ();//15-FEB-2019 :Madhu S29684 - 2D Serial Label for Non-Foot Print Serialized Items
//find any non-foot print items.

String lsFind

lsFind ="c_print_ind = 'Y' and pack_container_id='-' and serialized_ind <>'N'"

IF dw_label.Find(lsFind, 0, dw_label.RowCount()) > 0 Then
	Return TRUE
else
	Return FALSE
END IF
end function

on w_pandora_generic_shipping_labels.create
int iCurrent
call super::create
this.cb_label_print=create cb_label_print
this.dw_label=create dw_label
this.cb_label_selectall=create cb_label_selectall
this.cb_label_clear=create cb_label_clear
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cbx_4=create cbx_4
this.cbx_5=create cbx_5
this.cbx_6=create cbx_6
this.cbx_3=create cbx_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_label_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_label_selectall
this.Control[iCurrent+4]=this.cb_label_clear
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.cbx_2
this.Control[iCurrent+7]=this.cbx_4
this.Control[iCurrent+8]=this.cbx_5
this.Control[iCurrent+9]=this.cbx_6
this.Control[iCurrent+10]=this.cbx_3
this.Control[iCurrent+11]=this.rb_1
this.Control[iCurrent+12]=this.rb_2
this.Control[iCurrent+13]=this.gb_1
end on

on w_pandora_generic_shipping_labels.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_label_print)
destroy(this.dw_label)
destroy(this.cb_label_selectall)
destroy(this.cb_label_clear)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cbx_4)
destroy(this.cbx_5)
destroy(this.cbx_6)
destroy(this.cbx_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event ue_postopen;call super::ue_postopen;

invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse
invo_labels_pandora = create n_labels_pandora

cb_label_print.Enabled = False

//We can only print based on DO_NO - User must have valid order open to pass DO_NO in from w_DO
If isVAlid(w_do) Then
	if w_do.idw_main.RowCOunt() > 0 Then
		isDoNo = w_do.idw_main.GetITemString(1,'do_no')
	End If
End If

If isNUll(isDONO) or  isDoNO = '' Then
	Messagebox('Labels','You must have an order retrieved in the Delivery Order Window~rbefore you can print labels!')
Else
	This.TriggerEvent('ue_retrieve')
End If



end event

event ue_retrieve;call super::ue_retrieve;String	lsDONO,	&
			lsCartonNo

Long		llRowCount,	&
			llRowPos
// Dinesh - Begin - 22/02/2021 - S53992- Google -  SIMS - Outbound shipping Labels at Picking
select Ord_Status into : is_status from Delivery_Master where do_no=:isdono and project_id='PANDORA' using sqlca;
//if is_status = 'A' then
//	dw_label.dataobject = 'd_pandora_generic_shipping_label'
//	dw_label.settrans(sqlca)
if is_status = 'I' then
	cbx_1.enabled= False
	cbx_3.enabled= False
	cbx_4.enabled= False
	cbx_5.enabled= False
	cbx_6.enabled= False
	dw_label.dataobject = 'd_pandora_generic_shipping_label_picklist'
	dw_label.settrans(sqlca)
end if
// Dinesh - End - 22/02/2021 - S53992- Google -  SIMS - Outbound shipping Labels at Picking
cb_label_print.Enabled = False

If isdono > '' Then
	dw_label.Retrieve(gs_project,isdono)
End If

If dw_label.RowCOunt() > 0 Then
Else
	Messagebox('Labels','Order Not found!')
	Return
End If

lsDoNo = dw_label.GetITemString(1,'delivery_Master_DO_NO')

//Default the Label Format and Starting Carton Number
llRowCount = dw_label.RowCount()


//cb_print.Enabled = True

// 12/03 - PCONKL - WE need the Project level UCCS Company prefix and the Warehouse level prefix
Select ucc_Company_Prefix into :isuccscompanyprefix
FRom Project
Where Project_ID = :gs_Project;

SElect ucc_location_Prefix into :isuccswhprefix
From Warehouse
Where wh_Code = (select wh_Code from Delivery_MASter where Project_ID = :gs_Project and do_no = :isdono);

//14-SEP-2018 :Madhu S23255 Pandora Shipping Label
If not Isnull(isuccswhprefix) Then is_ucc_prefix = isuccswhprefix
If not Isnull(isuccscompanyprefix) Then is_ucc_prefix += isuccscompanyprefix


end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','Y')
Next

dw_label.SetRedraw(True)

cb_label_print.Enabled = True

end event

event ue_unselectall;call super::ue_unselectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','N')
Next

dw_label.SetRedraw(True)

cb_label_print.Enabled = False

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-350) //07-SEP-2018 :Madhu S23255 Shipping Label
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_pandora_generic_shipping_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_pandora_generic_shipping_labels
integer x = 517
integer y = 128
integer width = 306
integer height = 80
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_label_print from commandbutton within w_pandora_generic_shipping_labels
integer x = 517
integer y = 20
integer width = 306
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;//07-SEP-2018 :Madhu S23255 Shipping Label
//call appropriate method based on Label type selection

IF cbx_1.checked THEN Parent.TriggerEvent('ue_print_generic_address_label') //Generic Address Label
//IF cbx_2.checked THEN Parent.TriggerEvent('ue_print_google_shipping_label') //Google Shipping Label // Dinesh - 22/02/2021 - S53992- Google -  SIMS - Outbound shipping Labels
//if is_status = 'A' then // Dinesh - Begin - 22/02/2021 - S53992- Google -  SIMS - Outbound shipping Labels at Picking
if is_status='I' then
	IF cbx_2.checked THEN Parent.TriggerEvent('ue_print_google_shipping_label_picklist') //Google Shipping Label
else
	IF cbx_2.checked THEN Parent.TriggerEvent('ue_print_google_shipping_label') //Google Shipping Label
End if
//if is_status = 'A' then // Dinesh - End - 22/02/2021 - S53992- Google -  SIMS - Outbound shipping Labels at Picking
IF cbx_3.checked THEN Parent.TriggerEvent('ue_print_include_pallet_label') //Include Pallet SSCC Label
IF cbx_4.checked THEN Parent.TriggerEvent('ue_print_2d_pallet_label') //2D Pallet Serial Label
IF cbx_5.checked THEN Parent.TriggerEvent('ue_print_2d_carton_label') //2D Carton Serial Label
IF cbx_6.checked THEN Parent.TriggerEvent('ue_print_pallet_container_label') //Pallet Container Label

end event

event constructor;
g.of_check_label_button(this)
end event

type dw_label from u_dw_ancestor within w_pandora_generic_shipping_labels
integer x = 9
integer y = 284
integer width = 3127
integer height = 1456
boolean bringtotop = true
string dataobject = "d_pandora_generic_shipping_label"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event retrieveend;call super::retrieveend;//As this is compute column needs to be assigned value 
// DGM 09/22/03
integer i
FOR i = 1 TO rowcount
 This.object.c_qty_per_carton[i]=1
NEXT


end event

event itemchanged;call super::itemchanged;
If upper(dwo.Name) = 'C_PRINT_IND' and data = 'Y' Then cb_label_print.Enabled = True
end event

type cb_label_selectall from commandbutton within w_pandora_generic_shipping_labels
integer x = 69
integer y = 20
integer width = 352
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;Parent.Event ue_selectall()

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_label_clear from commandbutton within w_pandora_generic_shipping_labels
integer x = 69
integer y = 128
integer width = 352
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;Parent.Event ue_unselectall()
end event

event constructor;
g.of_check_label_button(this)
end event

type cbx_1 from checkbox within w_pandora_generic_shipping_labels
integer x = 1719
integer y = 52
integer width = 763
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generic Address Label"
end type

type cbx_2 from checkbox within w_pandora_generic_shipping_labels
integer x = 1719
integer y = 124
integer width = 763
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Google Shipping Label"
end type

type cbx_4 from checkbox within w_pandora_generic_shipping_labels
integer x = 2482
integer y = 52
integer width = 635
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "2D Pallet Serial Label"
end type

type cbx_5 from checkbox within w_pandora_generic_shipping_labels
integer x = 2487
integer y = 124
integer width = 635
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "2D Carton Serial Label"
end type

type cbx_6 from checkbox within w_pandora_generic_shipping_labels
integer x = 2487
integer y = 188
integer width = 635
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pallet Container Label"
end type

type cbx_3 from checkbox within w_pandora_generic_shipping_labels
integer x = 1719
integer y = 188
integer width = 763
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Include Pallet SSCC Label"
end type

type rb_1 from radiobutton within w_pandora_generic_shipping_labels
integer x = 1344
integer y = 76
integer width = 283
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "200 DPI"
boolean checked = true
end type

type rb_2 from radiobutton within w_pandora_generic_shipping_labels
integer x = 1344
integer y = 156
integer width = 283
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "300 DPI"
end type

type gb_1 from groupbox within w_pandora_generic_shipping_labels
integer x = 1280
integer width = 1870
integer height = 284
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Label Resolution && Types"
end type

