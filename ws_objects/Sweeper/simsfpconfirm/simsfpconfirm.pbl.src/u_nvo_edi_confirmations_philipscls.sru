$PBExportHeader$u_nvo_edi_confirmations_philipscls.sru
$PBExportComments$Process outbound edi confirmation transactions for Philips
forward
global type u_nvo_edi_confirmations_philipscls from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_philipscls from nonvisualobject
end type
global u_nvo_edi_confirmations_philipscls u_nvo_edi_confirmations_philipscls

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsPOExpansion, idsDOExpansion, idsDoSerial, idsDOBOM
				
u_nvo_proc_philips_cls	iuo_proc_philips_cls
string isBhDa

				
	
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_gr (string asproject, string asrono)
public function string getphilipsinvtype (string asinvtype)
public function integer uf_rd_sd_change (string asproject, string asdono, string astranstype)
public function integer uf_product_picked (string asproject, string asdono)
public function integer uf_adjustment (string asproject, long aladjustid, long altransid)
public function integer uf_event_status_delivery_date (string asproject, string asdono)
public function integer uf_event_status (string asproject, string asdono, string astranstype, string astransparm)
end prototypes

public function integer uf_gi (string asproject, string asdono);//25-FEB-2019 :Madhu S29940 PhilipsBlueHeart Goods Loaded

String lsLogOut, lsOutString, ls_uom, lsFileName, ls_invoice_no, lsFind, ls_uom_level, ls_Pack_SSCC_No
Long llRowPos, llNewRow, ll_Pick_Count, ll_Pack_Count, ll_Serial_Count, ll_Exp_Count, ll_line_seq, ll_Find_Row, ll_carton_count
Integer liRC
Decimal ldBatchSeq
string lsFilePrefix  //dts - 11/24/2020 - S51540 (cont'd) - Different file prefix for PHILIPS-DA

Str_Parms lstr_Parms

//Create the Proc Philips NVO so we can use the existing function for converting Inventory Types and Disp codes
If not isvalid(iuo_proc_philips_cls) Then
	iuo_proc_philips_cls = Create u_nvo_proc_philips_cls
End If

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create u_ds_datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDODetail) Then
	idsDODetail = Create u_ds_datastore
	idsDODetail.Dataobject = 'd_do_detail'
	idsDODetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsDOPick) Then
	idsDOPick = Create u_ds_datastore
	idsDOPick.Dataobject = 'd_do_picking_gi_philipscls'
	idsDOPick.SetTransObject(SQLCA)
End If

If Not isvalid(idsDOPack) Then
	idsDOPack = Create u_ds_datastore
	idsDOPack.Dataobject = 'd_do_packing_philips'
	idsDOPack.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoSerial) Then
	idsDoSerial = Create u_ds_datastore
	idsDoSerial.Dataobject ='d_do_serial'
	idsDoSerial.SetTransObject(SQLCA)
End If

If Not isvalid(idsDOExpansion) Then
	idsDOExpansion = Create u_ds_datastore
	idsDOExpansion.Dataobject = 'd_edi_outbound_expansion'
	idsDOExpansion.SetTransObject(SQLCA)
End If

idsOut.Reset()

//dts - 11/24/2020 - S51540 (cont'd) - Different file prefix for PHILIPS-DA
if asproject = 'PHILIPSCLS' then
	lsFilePrefix = 'GI'
else //PHILIPS-DA
	lsFilePrefix = 'GIDA'
end if 

lsLogOut = "        Creating GI For DONO: " + asdono
FileWrite(gilogFileNo,lsLogOut)

//Retreive Delivery Master and Detail  records for this DONO
If idsDOMain.Retrieve(asdono) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asdono
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// 03/07 - PCONKL - If not received elctronically, don't send a confirmation
If idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no'))    Then Return 0

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Philips!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

ls_invoice_no = idsDOMain.getItemString(1, 'Invoice_No')

//retrieve detail records
idsDoDetail.retrieve( asdono)

//retrieve Pick records
ll_Pick_Count = idsDoPick.retrieve( asdono)

//retrieve Pack records
ll_Pack_Count = idsDoPack.retrieve( asproject, asdono)

//get distinct carton count
select count(distinct carton_no) into :ll_carton_count 
from delivery_packing with(nolock)
where do_no =:asdono;

//A. build GI Records
FOR llRowPos = 1 to ll_Pick_Count
	llNewRow = idsOut.insertrow(0)
	lsOutString ='GI|'
	lsOutString += asproject + '|'
	lsOutString += idsDoMain.getItemString( 1, 'Wh_Code') +'|'
	lsOutString += ls_invoice_no + '|'
	lsOutString += String(idsDoPick.getItemNumber( llRowPos, 'Line_Item_No')) +'|'
	lsOutString += idsDoPick.getItemString(llRowPos, 'Sku') +'|'
	lsOutString += String(idsDoPick.getItemNumber( llRowPos, 'Quantity')) +'|'

//TAM 2019/03/04 - Use A new table to create the Translation - Start
//	lsOutString += iuo_proc_philips_cls.getphilipsinvtype(idsDoPick.getItemString(llRowPos, 'Inventory_Type')) +'|'	 /* PCONKL - convert to Philips Inv Type */
	lstr_Parms = iuo_proc_philips_cls.getphilipssuppliertranslations( asProject, idsDoMain.getItemString( 1, 'User_field3'), idsDoPick.getItemString(llRowPos, 'Inventory_Type'))
	lsOutString += 	lstr_Parms.string_arg[1] + '|' //Translated Inventory Type
//TAM 2019/03/04 - Use A new table to create the Translation - End

w_main.SetMicroHelp("Processing delivery GI report - Picklist retrievedil - RowCount " + String(idsDoPick.RowCount()) + ' - now at row: '+ String(llRowPos))

	//lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Lot_No'), '') +'|'	
	//lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Po_No'), '') +'|'	
	//lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Po_No2'), '') +'|'
	//lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Serial_No'), '') +'|'
	//lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Container_Id'), '') +'|'
	//lsOutString += String(idsDoPick.getItemDateTime(llRowPos, 'Expiration_Date'), 'YYYYMMDD') +'|'	
	
	lsOutString +='|' //Lot No
	lsOutString +='|' //Po No
	lsOutString +='|' //Po No2
	lsOutString +='|' //Serial No
	lsOutString +='|' //Container Id
	lsOutString +='|' //Expiration Date
	
	lsOutString += nz(String(idsDoPick.getItemNumber( llRowPos, 'Price')) ,'') +'|'
	lsOutString +=String(idsDoMain.getItemDateTime( 1, 'Complete_Date'),'YYYYMMDDHHMMSS') + '|' //Ship Date
	lsOutString += string(ll_carton_count) + '|' //Package Count
		
	lsFind ="sku ='"+ idsDoPick.getItemString(llRowPos, 'Sku')+"' and Line_Item_No ="+String(idsDoPick.getItemNumber( llRowPos, 'Line_Item_No'))
	ll_Find_Row = idsDoPack.find( lsFind, 1, idsDoPack.rowcount())
	
	IF ll_Find_Row > 0 THEN
		lsOutString += nz(idsDoPack.getItemString( ll_Find_Row, 'delivery_packing_shipper_tracking_id'),'') + '|'
		ls_Pack_SSCC_No = idsDoPack.getItemString( ll_Find_Row, 'delivery_packing_pack_sscc_no')
	ELSE
		lsOutString +='|' //Ship Tracking Number	
	END IF
	
	lsOutString += nz(idsDoMain.getItemString( 1, 'Carrier'), '') +'|'
	lsOutString += nz(String(idsDoMain.getItemNumber( 1, 'Freight_Cost')),'') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'Freight_Terms'), '') +'|'
	
	lsOutString +=nz(String(idsDoPack.getItemNumber( 1, 'total_weight')),'') + '|'	//Total Weight

	lsOutString += nz(idsDoMain.getItemString( 1, 'Transport_Mode'),'') +'|'
	lsOutString += String(idsDoMain.getItemDateTime( 1, 'Delivery_Date'),'YYYYMMDD') +'|'
	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'User_Field1'),'') +'|'	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'User_Field2'),'') +'|'	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'User_Field3'),'') +'|'	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'User_Field4'),'') +'|'	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'User_Field5'),'') +'|'	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'User_Field6'),'') +'|'	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'User_Field7'),'') +'|'	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'User_Field8'),'') +'|'	

	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field2'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field3'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field4'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field5'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field6'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field7'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field8'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field9'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field10'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field11'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field12'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field13'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field14'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field15'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field16'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field17'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field18'), '') +'|'
	
	lsOutString += nz(idsDoMain.getItemString( 1, 'Cust_Code'), '') +'|'	
	lsOutString += nz(idsDoMain.getItemString( 1, 'Cust_Name'), '') +'|'	
	lsOutString += nz(idsDoMain.getItemString( 1, 'Address_1'), '') +'|'	
	lsOutString += nz(idsDoMain.getItemString( 1, 'Address_2'), '') +'|'	
	lsOutString += nz(idsDoMain.getItemString( 1, 'Address_3'), '') +'|'	
	lsOutString += nz(idsDoMain.getItemString( 1, 'Address_4'), '') +'|'	
	lsOutString += nz(idsDoMain.getItemString( 1, 'City'), '') +'|'	
	lsOutString += nz(idsDoMain.getItemString( 1, 'State'), '') +'|'	
	lsOutString += nz(idsDoMain.getItemString( 1, 'Zip'), '') +'|'	
	lsOutString += nz(idsDoMain.getItemString( 1, 'Country'), '') +'|'	
	lsOutString += nz(idsDoMain.getItemString( 1, 'Tel'), '') +'|'	

	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'UOM'),'') +'|'	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Country_Of_Origin'),'') +'|'	

	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field19'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field20'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field21'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'User_Field22'), '') +'|'
	
	lsOutString += nz(idsDoMain.getItemString( 1, 'Department_code'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'Department_name'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'Division'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'Vendor'), '') +'|'
	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Buyer_Part'),'') +'|'	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Vendor_Part'),'') +'|'	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'UPC'),'') +'|'	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'im_user_field3'),'') +'|'	 //EAN = Item_Master.User_Field3
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'im_user_field4'),'') +'|'	//GTIN = Item_Master.User_Field4
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Department_Name'),'') +'|'	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Division'),'') +'|'	
	
	lsOutString +=nz(ls_Pack_SSCC_No, '') + '|'  //SSCC No
	
	lsOutString += nz(idsDoMain.getItemString( 1, 'Account_Nbr'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'ASN_Number'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'Client_Cust_PO_Nbr'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'Client_Cust_SO_Nbr'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'Container_Nbr'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'Dock_Code'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'Document_Codes'), '') +'|'
	lsOutString += nz(String(idsDoMain.getItemNumber( 1, 'Equipment_Nbr'),''), '') +'|'
	
	lsOutString += nz(idsDoMain.getItemString( 1, 'FOB'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'FOB_Bill_Duty_Acct'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'FOB_Bill_Duty_Party'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'FOB_Bill_Freight_Party'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'FOB_Bill_Freight_To_Acct'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'From_Wh_Loc'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'Routing_Nbr'), '') +'|'
	lsOutString += nz(idsDoMain.getItemString( 1, 'Seal_Nbr'), '') +'|'	
	lsOutString += nz(idsDoMain.getItemString( 1, 'Shipping_Route'), '') +'|'	
	lsOutString += nz(idsDoMain.getItemString( 1, 'SLI_Nbr'), '') +'|'
	
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'client_cust_line_no'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'vat_identifier'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'CI_Value'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Currency'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Cust_Line_Nbr'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Client_Cust_Invoice'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Cust_PO_Nbr'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Delivery_Nbr'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Internal_Price'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Client_Inv_Type'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Permit_Nbr'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Supp_Code'),'') +'|'				
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'User_Line_Item_No'),'') +'|'	

	lsOutString += nz(idsDoMain.getItemString( 1, 'Ord_Type'), '') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Customer_Sku'),'') +'|'
	lsOutString += nz(idsDoMain.getItemString(1, 'Cust_Order_No'),'') +'|'

	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Mark_For_Name'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Mark_For_Address_1'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Mark_For_Address_2'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Mark_For_Address_3'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Mark_For_Address_4'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Mark_For_City'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Mark_For_State'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Mark_For_Zip'),'') +'|'
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Mark_For_Country'),'') +'|'
										
	lsOutString += nz(idsDoPick.getItemString(llRowPos, 'Do_No'),'') +'|'	
	lsOutString += nz(idsDoMain.getItemString(1, 'Consolidation_No'),'') +'|'
	lsOutString += nz(idsDoMain.getItemString(1, 'AWB_BOL_No'),'')
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//dts - 11/24/2020 - S51540 (cont'd)  lsFileName = 'GI' + String(ldBatchSeq,'00000000') + '.dat'
	lsFileName = lsFilePrefix + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
NEXT

//B. build PK records
FOR llRowPos = 1 to ll_Pack_Count
	llNewRow = idsOut.insertrow( 0)
	lsOutString ='PK|'
	lsOutString += asproject +'|'
	lsOutString += idsDoMain.getItemString(1, 'Invoice_No') + '|'
	lsOutString += nz(idsDoPack.getItemString( llRowPos, 'delivery_packing_carton_no'),'') + '|'
	lsOutString += String(idsDoPack.getItemNumber( llRowPos, 'delivery_packing_line_item_no')) + '|'
	lsOutString += idsDoPack.getItemString( llRowPos, 'delivery_packing_sku') + '|'
	lsOutString += String(idsDoPack.getItemNumber( llRowPos, 'delivery_packing_quantity')) + '|'
	lsOutString += nz(String(idsDoPack.getItemNumber( llRowPos, 'total_weight')),'') + '|'
	
w_main.SetMicroHelp("Processing delivery GI report - Packlist retrievedil - RowCount " + String(idsDoPack.RowCount()) + ' - now at row: '+ String(llRowPos))

	IF idsDoPack.getItemString( llRowPos, 'delivery_packing_standard_of_measure') ='E' THEN
		ls_uom='LB'
	ELSE
		ls_uom ='KG'
	END IF
	
	lsOutString += ls_uom + '|' //KG/LB
	lsOutString += nz(idsDoPack.getItemString( llRowPos, 'delivery_packing_standard_of_measure'),'') + '|' //UOM
	
	lsOutString += nz(String(idsDoPack.getItemNumber( llRowPos, 'delivery_packing_length')),'') + '|'
	lsOutString += nz(String(idsDoPack.getItemNumber( llRowPos, 'delivery_packing_width')),'') + '|'
	lsOutString += nz(String(idsDoPack.getItemNumber( llRowPos, 'delivery_packing_height')),'') + '|'
	
	//Carton DIMS
	IF ls_uom ='LB' THEN
		lsOutString +=  'IN|' //Inches
	ELSE
		lsOutString += 'CM|' //Centimeters
	END IF

	lsOutString += nz(idsDoPack.getItemString( llRowPos, 'delivery_packing_shipper_tracking_id'),'') + '|'
	lsOutString += nz(idsDoPack.getItemString( llRowPos, 'delivery_packing_user_field1'),'') + '|'
	lsOutString += nz(idsDoPack.getItemString( llRowPos, 'delivery_packing_user_field2'),'') + '|'
	lsOutString += nz(idsDoPack.getItemString( llRowPos, 'delivery_packing_interpack_count'),'') + '|'
	lsOutString += nz(idsDoPack.getItemString( llRowPos, 'delivery_packing_interpack_type'),'') + '|'
	lsOutString += nz(idsDoPack.getItemString( llRowPos, 'delivery_packing_pack_sscc_no'),'') + '|'
	
	lsOutString += nz(idsDoPack.getItemString( llRowPos, 'delivery_packing_pack_lot_no'),'') + '|'
	lsOutString += nz(idsDoPack.getItemString( llRowPos, 'delivery_packing_pack_po_no'),'') + '|'
	lsOutString += nz(idsDoPack.getItemString( llRowPos, 'delivery_packing_pack_po_no2'),'') + '|'
	lsOutString += nz(idsDoPack.getItemString( llRowPos, 'delivery_packing_outerpack_sscc_no'),'') + '|'
	
	lsOutString += '3' +'|' //PackageLevelCode (3)

	//TAM 2019/03/08 - use Packing Carton Type instead of Item Master UF3
	ls_uom_level = nz(idsDoPack.getItemString( llRowPos, 'delivery_packing_carton_type'),'')
//	ls_uom_level = idsDoPack.getItemString( llRowPos, 'item_master_uom_3')
//	IF IsNull(ls_uom_level) OR ls_uom_level='' OR ls_uom_level=' ' THEN
//		ls_uom_level = idsDoPack.getItemString( llRowPos, 'item_master_uom_2')	
//			IF IsNull(ls_uom_level) OR ls_uom_level='' OR ls_uom_level=' ' THEN
//					ls_uom_level = idsDoPack.getItemString( llRowPos, 'item_master_uom_1')	
//			END IF
//	END IF
	
	lsOutString += nz(ls_uom_level, '') +'|' //PackageTypeCode  (uom)
	lsOutString += nz(String(idsDoPack.getItemNumber( llRowPos, 'delivery_packing_weight_net')),'') + '|'//Package Net Weight 
	
	//Quantity/Planned
	lsFind ="sku ='"+idsDoPack.getItemString( llRowPos, 'delivery_packing_sku')+"'"
	ll_Find_Row = idsDoDetail.find( lsFind, 1, idsDoDetail.rowcount())
	IF ll_Find_Row > 0 THEN
		lsOutString += String(idsDoDetail.getItemNumber( ll_Find_Row, 'req_qty'))
	END IF
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//dts - 11/24/2020 - S51540 (cont'd)  lsFileName = 'GI' + String(ldBatchSeq,'00000000') + '.dat'
	lsFileName = lsFilePrefix + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
NEXT //Package Records

// retrieve Serial No Records
ll_Serial_Count = idsDoSerial.retrieve( asdono)

//C. build SN records
FOR llRowPos = 1 to ll_Serial_Count
	llNewRow = idsOut.insertrow( 0)
	
	lsOutString ='SN|'
	lsOutString += asproject + '|'
	lsOutString += ls_invoice_no + '|'
	lsOutString += nz(idsDoSerial.getItemString( llRowPos, 'carton_no'),'') + '|'
	lsOutString += String(idsDoSerial.getItemNumber( llRowPos, 'line_item_no')) +'|'
	lsOutString += idsDoSerial.getItemString( llRowPos, 'sku') +'|'
	lsOutString += String(idsDoSerial.getItemNumber( llRowPos, 'quantity')) +'|'
	lsOutString += idsDoSerial.getItemString( llRowPos, 'serial_no')
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//dts - 11/24/2020 - S51540 (cont'd)  lsFileName = 'GI' + String(ldBatchSeq,'00000000') + '.dat'
	lsFileName = lsFilePrefix + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
NEXT

//retrieve expansion records
ll_Exp_Count = idsDOExpansion.retrieve(asproject, ls_invoice_no, idsDOMain.GetItemNumber(1,'edi_batch_seq_no'))
idsDOExpansion.setsort( "order_line_no A")
idsDOExpansion.sort( )

//D. build EX records
FOR llRowPos = 1 to ll_Exp_Count
	llNewRow = idsOut.insertrow( 0)
	ll_line_seq++
	
	lsOutString ='EX|'
	//lsOutString += string(ll_line_seq)
	lsOutString += idsDOExpansion.getItemString(llRowPos,'User_Line_Item_No') +  '|' 
	lsOutString += nz(idsDOExpansion.getItemString(llRowPos, 'field_name'),'')+'|'
	lsOutString += nz(idsDOExpansion.getItemString(llRowPos, 'field_data'),'')
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//dts - 11/24/2020 - S51540 (cont'd)  lsFileName = 'GI' + String(ldBatchSeq,'00000000') + '.dat'
	lsFileName = lsFilePrefix + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
NEXT //Expansion Records

w_main.SetMicroHelp("Ready")

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, asproject)

destroy idsOut
destroy idsDOExpansion
destroy idsDoSerial
destroy idsDoPack
destroy idsDOPick
destroy idsDODetail
destroy idsDOMain

Return 0
end function

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Philips for the order that was just confirmed

/* TAM 2019/03/01 - F14358 -  Add a serial number segment to the output.  This significantly changed the looping.  
To prevent a bunch of commented code The changes were made without commenting obsolete lines */


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llDetailFindRow, llExpansionRowPos, llPutawayRowCount, llPutawayRowPos
String			lsFind, lsOutString,lsSuppCode, lsSku, lsMessage, lsLogOut, lsFileName, lsCOO2, lsCOO3, lsWarehouse,  lsSerialized, lsFilter, lsExpirationDt
String			lsOrderType, lsInvType, lsOrderNo //TAM 2019/03/05
Decimal		ldBatchSeq, ld_edi_batch_seq_no
Integer		liRC
Str_Parms  	lstr_Parms

if asproject='PHILIPSCLS' then // Dinesh - 11/10/2020
	isBhDa= 'BH'
else
	isBhDa='DA'
end if

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsromain) Then
	idsromain = Create Datastore
	idsromain.Dataobject = 'd_ro_master'
	idsroMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsroDetail) Then
	idsroDetail = Create Datastore
	idsroDetail.Dataobject = 'd_ro_Detail'
	idsroDetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransObject(SQLCA)
End If

If Not isvalid(idsPOExpansion) Then
	idsPOExpansion = Create Datastore
	idsPOExpansion.Dataobject = 'd_ro_expansion'
	idsPOExpansion.SetTransObject(SQLCA)
End If

If not isvalid(iuo_proc_philips_cls) Then
	iuo_proc_philips_cls = Create u_nvo_proc_philips_cls
End If

idsOut.Reset()

lsLogOut = "      Creating GR For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header, Detail and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//  If not received elctronically don't send a confirmation
If idsROMain.getItemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsROMain.getItemNumber(1,'edi_batch_seq_no'))  Then Return 0
ld_edi_batch_seq_no = idsROMain.getItemNumber(1,'edi_batch_seq_no')

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to PhilipsCLS!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


idsroDetail.Retrieve(asRONO)
idsroPutaway.Retrieve(asRONO)
idsPOExpansion.Retrieve(asProject,idsROMain.getItemNumber(1,'edi_batch_seq_no'),idsROMain.getItemString(1,'supp_invoice_no') ) 

// TAM 2019/03/05 - S13782 - Create different Data and file for Customer Return 
lsOrderType = idsROMain.getItemString(1,'ord_type') 
lsOrderNo = idsROMain.getItemString(1,'supp_invoice_no')

// Write the Header Record to Output File
llNewRow = idsOut.insertRow(0)
	
// TAM 2019/03/05 - S13782 - Create different Data and file for Customer Return 
If lsOrderType = 'X' Then 
	lsOutString = 'RTH|' /*rec type = Customer Return header*/
Else
	lsOutString = 'GRH|' /*rec type = goods receipt header*/
End If
	
lsOutString += idsROMain.getItemString(1,'supp_invoice_no') + '|' /*Shipping Notification Number*/
lsOutString += String(idsROMain.getItemString(1,'supp_code')) + '|'
lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyymmddhhmm') + '|'
If Not IsNull(idsROMain.getItemString(1,'AWB_BOL_No')) then 	lsOutString += String(idsROMain.getItemString(1,'AWB_BOL_No')) 
		
idsOut.SetItem(llNewRow,'Project_id', asproject) // Dinesh - S50900 - Philips-da - 11/05/2020
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)

// TAM 2019/03/05 - S13782 - Create different Data and file for Customer Return 
If lsOrderType = 'X' Then 
	lsFileName = 'RT'+ isBhDa+ String(ldBatchSeq,'00000000') + '.dat' //TAM DE8905  // Dinesh - S50900 - PHILIPS-DA
Else
	lsFileName = 'GR'+ isBhDa + String(ldBatchSeq,'00000000') + '.dat' //TAM DE8905  // Dinesh - S50900 - PHILIPS-DA
End If
idsOut.SetItem(llNewRow,'file_name', lsFileName)

long expansionrc,edibatchno
string invoice
expansionrc = idsPOExpansion.rowcount( )
edibatchno = idsROMain.getItemNumber(1,'edi_batch_seq_no')
invoice = idsROMain.getItemString(1,'supp_invoice_no')

//Filter the Header Expansion Records(Line Item No = 0)  
idsPOExpansion.SetFilter( "User_Line_Item_No = '0'")  //Filter Header expansion records
idsPOExpansion.filter( )

expansionrc = idsPOExpansion.rowcount( )

// Write Header Expansion Records to Output file
For llExpansionRowPos = 1 to expansionrc
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = 'EX|' /*rec type = Expansion*/
	lsOutString +=  '0|' /*Line No - 0 for header*/
	lsOutString += idsPOExpansion.getItemString(llExpansionRowPos,'Field_Name') + '|' /*Field Name*/
	lsOutString += idsPOExpansion.getItemString(llExpansionRowPos,'Field_Data')  /*Field Data*/
		
	idsOut.SetItem(llNewRow,'Project_id', asproject) // Dinesh- S50900 - Philips-DA - 11/05/2020
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	// TAM 2019/03/05 - S13782 - Create different Data and file for Customer Return 
	If lsOrderType = 'X' Then 
		lsFileName = 'RT'+ isBhDa+ String(ldBatchSeq,'00000000') + '.dat' //TAM DE8905  // Dinesh - S50900 - PHILIPS-DA
	Else
		lsFileName = 'GR'+ isBhDa + String(ldBatchSeq,'00000000') + '.dat' //TAM DE8905 // Dinesh - S50900 - PHILIPS-DA
	End If
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
Next

//remove filter
idsPOExpansion.setfilter( "")
idsPOExpansion.filter( )
idsPOExpansion.rowcount( )

//For each Detail Line Write Detail Lines to the Outfile
llRowCOunt = idsroDetail.RowCount()

For llRowPos = 1 to llRowCount
	//GailM 03/14/2019 DE9385 Do not send zero quantity in GRD
	//21-MAR-2019 :Madhu S31437 Add '0' quantity records for Customer Return Orders
	If idsroDetail.getItemNumber(llRowPos, 'Damage_Qty') + idsroDetail.getItemNumber(llRowPos, 'Alloc_Qty') > 0  OR lsOrderType = 'X'  Then
		  lsSku = idsroDetail.getItemString(llRowPos,'sku')
		  lsSuppCode = idsroDetail.getItemString(llRowPos,'Supp_Code')
		  
	//	Get Item Serilized_ind (from Item Master)
		Select serialized_ind INTO :lsSerialized From Item_Master with(nolock)
		Where sku = :lsSku and supp_code = :lsSuppCode and project_id = :asproject
		USING SQLCA;
	
		//Filter the Putaway to only the user line No 
		lsFilter = "SKU = '" + lsSKU + "' and line_item_no = " + string(idsroDetail.getItemNumber(llRowPos,'line_item_no')) 
		idsroputaway.SetFilter(lsFilter)  //Filter Header expansion records
		idsroputaway.filter( )
	
		llPutawayRowCount = idsroPutaway.RowCount()
			
		//Add the Detail Row			
		llNewRow = idsOut.insertRow(0)
			
		// TAM 2019/03/05 - S13782 - Create different Data and file for Customer Return 
		If lsOrderType = 'X' Then 
			lsOutString = 'RTD|' /*rec type = Customer Return detail*/
		Else
			lsOutString = 'GRD|' /*rec type = goods receipt detail*/
		End If
		
		lsOutString += nz(idsROMain.getItemString(1,'supp_invoice_no'),'') + '|' 
		lsOutString += nz(idsroDetail.getItemString(llRowPos,'user_line_item_no'),'') + '|'
		lsOutString += nz(idsroDetail.getItemString(llRowPos,'sku'),'') + '|'
		
		//13-MAR-2019 :Madhu S30969 Add Damage Qty > 0
		IF idsroDetail.getItemNumber(llRowPos,'Damage_Qty') > 0 THEN
			lsOutString += String(idsroDetail.getItemNumber(llRowPos, 'Damage_Qty')) + '|'
		ELSE
			lsOutString += String(idsroDetail.getItemNumber(llRowPos, 'Alloc_Qty')) + '|'
		END IF
		
		lsOutString += nz(idsroDetail.getItemString(llRowPos,'Supp_Code'),'') + '|'
		lsOutString += nz(idsroDetail.getItemString(llRowPos,'UOM'),'') + '|'
		If Not IsNull(idsroDetail.getItemString(llRowPos,'User_field6')) Then
			lsOutString += idsroDetail.getItemString(llRowPos,'User_field6') + '|'
		Else
			lsOutString += '|'
		End If
		lsOutString +=  '|' /*Serial Number - NA on Detail Line -  We now add a serial section below*/
	
		if idsroputaway.rowcount() > 0 then 
			
			//TAM 2019/02/21 - DE8906 - If expiration Date = 299912310000 then set to blank
			lsExpirationDt = String(idsroPutaway.GetITemDateTime(1,'expiration_date'),'yyyymmddhhmm') //Get the 1st one.  Detail line cannot handle multiple Expiry Dates
			if lsExpirationDt = '299912310000' then
				lsOutString += '|'	
			Else
				lsOutString += lsExpirationDt + '|'
			End If
			
			//13-MAR-2019 :Madhu S30969 Add Inventory type
			IF idsroDetail.getItemNumber(llRowPos,'Damage_Qty') > 0 THEN
				lstr_Parms = iuo_proc_philips_cls.getphilipssuppliertranslations( asproject, lsSuppCode, 'D') //Pass Inv Type as 'D'
			ELSE
				lstr_Parms = iuo_proc_philips_cls.getphilipssuppliertranslations( asproject, lsSuppCode, idsroPutaway.getItemString(1,'inventory_type'))
			END IF
			
			lsInvType = lstr_Parms.string_arg[1]
				
		Else //No Putaway row for this line
			lsOutString += '|'
			
			//21-MAR-2019 :Madhu S31437 get Inventory Type for 0 qty records
			SELECT Inventory_Type into :lsInvType FROM edi_inbound_detail with(nolock)
			WHERE Project_Id= :asproject and EDI_Batch_Seq_No=:ld_edi_batch_seq_no 
			and Sku = :lsSku and supp_code = :lsSuppCode and Order_No=:lsOrderNo
			USING SQLCA;
			
			lstr_Parms = iuo_proc_philips_cls.getphilipssuppliertranslations( asproject, lsSuppCode, lsInvType)
			lsInvType = lstr_Parms.string_arg[1]
		End If
	
		lsOutString += nz(idsroDetail.getItemString(llRowPos,'Country_of_origin' ),'') + '|'
		lsOutString += String(idsroDetail.getItemNumber(llRowPos,'Req_Qty')) +'|' //TAM S29709 - Added Req_Qty
		lsOutString += 	nz(lsInvType, '') //13-MAR-2019 :Madhu S30969 Translated Inventory Type
				
		idsOut.SetItem(llNewRow,'Project_id', asproject) // Dinesh -S50900 - Philips- DA - 11/05/2020
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		
		// TAM 2019/03/05 - S13782 - Create different Data and file for Customer Return 
		If lsOrderType = 'X' Then 
			lsFileName = 'RT'+isBhDa+ String(ldBatchSeq,'00000000') + '.dat' //TAM DE8905  // Dinesh - S50900 - PHILIPS-DA
		Else
			lsFileName = 'GR'+ isBhDa+ String(ldBatchSeq,'00000000') + '.dat' //TAM DE8905  // Dinesh - S50900 - PHILIPS-DA
		End If
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
		if (lsSerialized = "B") Then //Get the serial numbers from putaway and create a SN row for each serial number
	
			For llPutawayRowPos = 1 to llPutawayRowCount
	
				llNewRow = idsOut.insertRow(0)
			
				lsOutString = 'SN|' /*rec type = goods receipt detail*/
				lsOutString += nz(idsroDetail.getItemString(llRowPos,'user_line_item_no'),'') + '|'
				lsOutString += nz(idsroputaway.getItemString(llPutawayRowPos,'Serial_No'),'')
			
				idsOut.SetItem(llNewRow,'Project_id', asproject) // Dinesh -S50900 - Philips- DA - 11/05/2020
				idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
				idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
				idsOut.SetItem(llNewRow,'batch_data', lsOutString)
				
				// TAM 2019/03/05 - S13782 - Create different Data and file for Customer Return 
				If lsOrderType = 'X' Then 
					lsFileName = 'RTBH' + String(ldBatchSeq,'00000000') + '.dat' //TAM DE8905 
				Else
					lsFileName = 'GRBH' + String(ldBatchSeq,'00000000') + '.dat' //TAM DE8905 
				End If
				
				idsOut.SetItem(llNewRow,'file_name', lsFileName)
			Next /* Next Putaway Serial record */
			
		End If		
	
		//Filter the Expansion Records(User Line Item No = Detail User Line Item Number)  
		lsFilter = "User_Line_Item_No = '" + trim(idsroDetail.getItemString(llRowPos,'User_Line_Item_No'))+"'"
		idsPOExpansion.SetFilter(lsFilter)  //Filter Detail expansion records
		idsPOExpansion.filter( )
		expansionrc = idsPOExpansion.rowcount( )
		idsPOExpansion.setsort( "order_line_no A")
		idsPOExpansion.sort( )
	
		// Write Detail Expansion Records to Output file
		For llExpansionRowPos = 1 to expansionrc
			llNewRow = idsOut.insertRow(0)
	
			lsOutString = 'EX|' /*rec type = Expansion*/
			lsOutString += idsPOExpansion.getItemString(llExpansionRowPos,'User_Line_Item_No') +  '|' /*Line No - 0 for detail*/
			lsOutString += idsPOExpansion.getItemString(llExpansionRowPos,'Field_Name') + '|' /*Field Name*/
			lsOutString += idsPOExpansion.getItemString(llExpansionRowPos,'Field_Data')  /*Field Data*/
			
			idsOut.SetItem(llNewRow,'Project_id', asproject) // Dinesh -S50900 - Philips- DA - 11/05/2020
			idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
			idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
			idsOut.SetItem(llNewRow,'batch_data', lsOutString)
			
			// TAM 2019/03/05 - S13782 - Create different Data and file for Customer Return 
			If lsOrderType = 'X' Then 
				lsFileName = 'RT'+ isBhDa+ String(ldBatchSeq,'00000000') + '.dat' //TAM DE8905  // Dinesh - S50900 - PHILIPS-DA
			Else
				lsFileName = 'GR'+ isBhDa + String(ldBatchSeq,'00000000') + '.dat' //TAM DE8905  // Dinesh - S50900 - PHILIPS-DA
			End If
			
			idsOut.SetItem(llNewRow,'file_name', lsFileName)
			
		Next /* Next Expansion record */
			
		//remove filters
		idsPOExpansion.setfilter( "")
		idsPOExpansion.filter( )
		idsPOExpansion.rowcount( )
	
		idsROPutaway.setfilter( "")
		idsROPutaway.filter( )
		idsROPutaway.rowcount( )
	End If

Next /* Next Detail record */

If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asproject) // Dinesh -S50900 - Philips- DA - 11/05/2020
End If

Return 0
end function

public function string getphilipsinvtype (string asinvtype);//Convert the Menlo Inventory Type into the Phillips code

String    lsPhilipsInvType
Choose case upper(asInvType)
                                
	 Case 'B'
		lsPhilipsInvType = 'B'
	 Case 'C'
		lsPhilipsInvType = 'C'
	 Case 'D'
		lsPhilipsInvType = 'DAM'
	 Case 'K'
		lsPhilipsInvType = 'BLCK'
	 Case 'L'
		lsPhilipsInvType = 'REBL'
	 Case 'N'
		lsPhilipsInvType = 'WHS'
	 Case 'R'
		lsPhilipsInvType = 'REW'
	 Case 'S'
		lsPhilipsInvType = 'SCRP'
	 Case 'G'
		lsPhilipsInvType = 'BWHS'
	 Case 'J'
		lsPhilipsInvType = 'BOPN'
	 Case 'F'
		lsPhilipsInvType = 'BBLK'
	 Case 'E'
		lsPhilipsInvType = 'BDAM'
	 Case Else
		lsPhilipsInvType = asInvType
End Choose

Return lsPhilipsInvType
end function

public function integer uf_rd_sd_change (string asproject, string asdono, string astranstype);//14-FEB-2019 :Madhu S29511 - Philips BlueHeart OutboundDeliveryUpdateStatus
//generate SDBH*.DAT file, if request date /schedule date changes.

String lsLogOut, lsOutString, lsFileName, ls_InvoiceNo, ls_sql, ls_errors, lsFilePrefix
Integer lirc
Decimal ldBatchSeq
Long llNewRow, llExpRow, llExpCount, llSeqNo, ll_detail_count, ll_row

Datastore lds_do_detail

IF Not isvalid(idsOut) THEN
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
END IF

IF Not isvalid(idsDOExpansion) THEN
	idsDOExpansion = Create Datastore
	idsDOExpansion.Dataobject = 'd_edi_outbound_expansion'
	idsDOExpansion.SetTransObject(SQLCA)
END IF

idsOut.Reset()

//dts - 11/19/2020 - S51583 - Different file prefix for PHILIPS-DA
if asproject = 'PHILIPSCLS' then
	lsFilePrefix = 'SDBH'
else //PHILIPS-DA
	lsFilePrefix = 'SDDA'
end if 

lsLogOut = "        Creating " + lsFilePrefix + " For DONO: " + asdono
FileWrite(gilogFileNo,lsLogOut)

//build datastore
lds_do_detail = create datastore
ls_sql = " select distinct dd.supp_code,dm.invoice_no, dm.request_date, dm.schedule_date, dm.delivery_date, dm.edi_batch_seq_no "
ls_sql +=" from delivery_detail dd with(nolock) "
ls_sql +=" inner join delivery_master dm on dd.do_no = dm.do_no "
ls_sql +=" where dm.project_id='"+asproject+"' and dm.do_no='"+asdono+"'"

lds_do_detail.create( SQLCA.syntaxfromsql( ls_sql, "", ls_errors))
lds_do_detail.settransobject( SQLCA)
ll_detail_count = lds_do_detail.retrieve( )

//Retreive Delivery Master and Detail  records for this DONO
IF ll_detail_count <= 0 THEN
	lsLogOut = "        *** Unable to retreive Delivery Order Header/Detail records For DONO: " + asdono
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
ELSE
	If lds_do_detail.getItemNumber(1, 'edi_batch_seq_no') = 0 or isNull(lds_do_detail.getItemNumber(1, 'edi_batch_seq_no'))    Then Return 0
END IF

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Philips!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
For ll_row = 1 to ll_detail_count
	
	ls_InvoiceNo = lds_do_detail.getItemString(ll_row,'invoice_no')
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'SS|' //SD001 - Record Id
	lsOutString += asproject + '|' //SD002 - Project Id
	lsOutString += lds_do_detail.getItemString(ll_row,'supp_code') + '|' //SD003 - Supplier (Plant)
	lsOutString += ls_InvoiceNo + '|' //SD004 - Invoice No
	lsOutString += String(lds_do_detail.getItemDateTime(ll_row, 'delivery_date'), 'yyyymmddhhmm') + '|' //SD005 - Delivery Date
	
	IF upper(astranstype) ='RD' THEN
		lsOutString += String(lds_do_detail.getItemDateTime(ll_row, 'request_date'), 'yyyymmddhhmm') //SD006 - Request Date
		lsOutString += '|' //SD007 - Schedule Date
	ELSEIF upper(astranstype) ='SD' THEN
		lsOutString += '|' //SD006 - Request Date
		lsOutString += String(lds_do_detail.getItemDateTime(ll_row, 'schedule_date'), 'yyyymmddhhmm')  //SD007 - Schedule Date
	END IF
		
	idsOut.SetItem(llNewRow,'Project_Id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//dts - 11/19/2020 - S51583  lsFileName = 'SDBH' + String(ldBatchSeq,'00000000') + '.dat'
	lsFileName = lsFilePrefix + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
Next

//retrieve expansion records
llExpCount = idsDOExpansion.retrieve( asproject, ls_InvoiceNo, lds_do_detail.getItemNumber(1, 'edi_batch_seq_no'))

FOR llExpRow = 1 to llExpCount
	llNewRow = idsOut.insertRow(0)

	llSeqNo++
	lsOutString = 'EX|' //Rec ID
	lsOutString += idsDOExpansion.getItemString(llExpRow,'Order_No') +  '|'  //Order No
	lsOutString += string(llSeqNo) + '|' //Line Sequence No
	lsOutString += idsDOExpansion.getItemString(llExpRow,'Field_Name') + '|'  //Field Name
	lsOutString += idsDOExpansion.getItemString(llExpRow,'Field_Data')  //Field Data

	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//dts - 11/19/2020 - S51583  lsFileName = 'SDBH' + String(ldBatchSeq,'00000000') + '.dat'
	lsFileName = lsFilePrefix + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
NEXT /* Next Expansion record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, asproject)

destroy idsDOExpansion
destroy lds_do_detail
destroy idsOut

Return 0
end function

public function integer uf_product_picked (string asproject, string asdono);//19-Feb-2019 :Madhu S29714 PhilipsBlueHeart Product Picked

Long		llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
Long		llExpRowPos, llExpCount, ll_Serial_Count, llBOMCount, llBOMPos
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String		ls_Invoice_No, lsNonPic, lsSKU, lsTemp, lsFilter, lsuf6// TAM  2019/07/13 - DE11661 
Decimal	ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer	liRC
Boolean	lbFound
string		lsFilePrefix //dts - 11/18/2020 - S51259 (cont'd) - Different file prefix for PHILIPS-DA

IF Not isvalid(idsOut) THEN
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransObject(sqlca)
END IF

IF Not isvalid(idsDOMain) THEN
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
END IF

IF Not isvalid(idsDODetail) THEN
	idsDODetail = Create Datastore
	idsDODetail.Dataobject = 'd_do_detail'
	idsDODetail.SetTransObject(SQLCA)
END IF

If Not isvalid(idsDoSerial) Then
	idsDoSerial = Create u_ds_datastore
	idsDoSerial.Dataobject ='d_do_serial'
	idsDoSerial.SetTransObject(SQLCA)
End If

IF Not isvalid(idsDOExpansion) THEN
	idsDOExpansion = Create Datastore
	idsDOExpansion.Dataobject = 'd_edi_outbound_expansion'
	idsDOExpansion.SetTransObject(SQLCA)
END IF

//TAM 2019/04/22 - S32624 - Added Soft Bundle logic(NonPick)
IF Not isvalid(idsDOBOM) THEN
	idsDOBOM = Create Datastore
	idsDOBOM.Dataobject = 'd_do_bom'
	idsDOBOM.SetTransObject(SQLCA)
END IF


idsOut.Reset()

lsLogOut = "        Creating Product Picked For DONO: " + asdono
FileWrite(gilogFileNo,lsLogOut)

//retrieve master records
IF idsDOMain.Retrieve(asDoNo) <> 1 THEN
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asdono
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
END IF

IF idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no')) THEN Return 0

//retrieve detail records
idsDODetail.Retrieve(asdono)

//TAM 2019/04/22 - S32624 retrieve BOM records
idsDOBOM.Retrieve(asdono)

llBOMCount= idsDOBOM.rowcount( ) //debug

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	//lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Product Picked.~r~rConfirmation will not be sent to PhilipsCLS!'"
	//dts - 11/18/2020 - S51259 (cont'd) - use asproject instead of hard-coded 'PhilipsCLS'
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Product Picked.~r~rConfirmation will not be sent to " + asproject + "!"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

ls_Invoice_No = idsDoMain.getItemString(1, 'Invoice_No')

//A. build Order Header records
llNewRow = idsOut.insertrow( 0)
lsOutString ='PPH|'
lsOutString += asproject + '|'  //Project Id
lsOutString += trim(ls_Invoice_No) +'|' //Order No
lsOutString += nz(idsDoMain.getItemString(1, 'User_Field3'),'') +'|' //Plant Code

// TAM 2019/03/08 use picked complete date
//IF IsNull(idsDoMain.getItemdatetime( 1, 'Complete_Date')) THEN //Complete Date
//	lsOutString += '|'
//ELSE
//	lsOutString += string(idsDoMain.getItemdatetime( 1, 'Complete_Date'), 'YYYYMMDDHHMMSS') +'|'
//END IF
IF IsNull(idsDoMain.getItemdatetime( 1, 'Pick_Complete')) THEN //Pick Complete Date
	lsOutString += String(today(),'yyyymmddhhmm') + '|'  
ELSE
	lsOutString += String( idsDoMain.getItemDateTime(1, 'Pick_Complete'), 'YYYYMMDDHHMM') +'|'
END IF

lsOutString += nz(idsDoMain.getItemString(1,'Awb_Bol_No'),'')

idsOut.setItem(llNewRow,'Project_id', asproject)
idsOut.setItem(llNewRow,'EDI_Batch_Seq_No', Long(ldBatchSeq))
idsOut.setItem(llNewRow,'Line_Seq_No', llNewRow)
idsOut.setItem(llNewRow,'Batch_Data', lsOutString)
//dts - 11/18/2020 - S51259 (cont'd) - Different file prefix for PHILIPS-DA
if asproject = 'PHILIPSCLS' then
	lsFilePrefix = 'PPBH'
else //PHILIPS-DA
	lsFilePrefix = 'PPDA'
end if 
//lsFileName = 'PPBH' + String(ldBatchSeq,'00000000') + '.dat'
lsFileName = lsFilePrefix + String(ldBatchSeq,'00000000') + '.dat'
idsOut.setItem(llNewRow,'file_name', lsFileName)

//Expansion Header Records
idsDOExpansion.retrieve( asproject, ls_Invoice_No, idsDOMain.GetItemNumber(1,'edi_batch_seq_no'))

//Filter the Header Expansion Records(Line Item No = 0) and 
idsDOExpansion.SetFilter( "Order_Table = 'Delivery_Master'")  //Filter Header expansion records
idsDOExpansion.filter( )
llExpCount = idsDOExpansion.rowcount( )
idsDOExpansion.setsort( "order_line_no A")
idsDOExpansion.sort( )

// B. build Expansion Header Records
For llExpRowPos = 1 to llExpCount
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = 'EX|' 
	lsOutString +=  '0|'
	lsOutString += idsDOExpansion.GetItemString(llExpRowPos, 'Field_Name') + '|' 
	lsOutString += idsDOExpansion.GetItemString(llExpRowPos, 'Field_Data')
		
	idsOut.setItem(llNewRow,'Project_id', asproject)
	idsOut.setItem(llNewRow,'EDI_Batch_Seq_No', Long(ldBatchSeq))
	idsOut.setItem(llNewRow,'Line_Seq_No', llNewRow)
	idsOut.setItem(llNewRow,'Batch_Data', lsOutString)
	//dts - S51259 lsFileName = 'PPBH' + String(ldBatchSeq,'00000000') + '.dat'
	lsFileName = lsFilePrefix + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.setItem(llNewRow,'file_name', lsFileName)
Next

//remove filter
idsDOExpansion.setfilter( "")
idsDOExpansion.filter( )
idsDOExpansion.rowcount( )


//C. build Order Detail records
llRowCount = idsDODetail.RowCount()
FOR llRowPos = 1 to llRowCOunt
	//GailM 04/10/2019 DE9978 - Do not show NONPIC rows
	lsNonPic = idsDODetail.getItemString(llRowPos, 'User_Field5')
	lsSKU = idsDODetail.getItemString(llRowPos, 'SKU')
	lsUF6 = idsDODetail.getItemString(llRowPos, 'User_Field6') // TAM  2019/07/13 - DE11662 

	If Upper(lsNonPic) <> 'NONPIC' Then
		llNewRow = idsOut.insertRow(0)
		lsOutString = 'PPD|'
		lsOutString += trim(ls_Invoice_No) + '|'
		lsOutString += String(idsDODetail.getItemNumber(llRowPos, 'Line_item_No')) + "|"
		lsOutString += idsDODetail.getItemString(llRowPos, 'SKU') + "|"
		lsOutString += String( idsDODetail.getItemNumber(llRowPos, 'Req_Qty')) + "|"
		lsOutString += idsDODetail.getItemString(llRowPos, 'Supp_Code')  + "|"
		
		//EAN - should be pulled from Item_Master.UF4
		If Not isnull( idsDODetail.getItemString(llRowPos, 'im_user_field4')) Then
			lsOutString += nz(idsDODetail.getItemString(llRowPos, 'im_user_field4'), '') + "|"
		Else
			lsOutString += "|"
		End if
		
		//User_Field6
		If Not isnull( idsDODetail.getItemString(llRowPos, 'User_Field6')) Then
			lsOutString += idsDODetail.getItemString(llRowPos, 'User_Field6') + "|"
		Else
			lsOutString += "|"
		End if
	
		//Serial No
		lsOutString += "|"
			
		lsOutString += String( idsDODetail.getItemNumber(llRowPos, 'Alloc_Qty')) + "|"
		lsOutString += String( idsDoMain.getItemDateTime(1, 'Pick_Complete'), 'YYYYMMDDHHMM')
				
		idsOut.setItem(llNewRow,'Project_id', asproject)
		idsOut.setItem(llNewRow,'EDI_Batch_Seq_No', Long(ldBatchSeq))
		idsOut.setItem(llNewRow,'Line_Seq_No', llNewRow)
		idsOut.setItem(llNewRow,'Batch_Data', lsOutString)
		//dts - S51259 lsFileName = 'PPBH' + String(ldBatchSeq,'00000000') + '.dat'
		lsFileName = lsFilePrefix + String(ldBatchSeq,'00000000') + '.dat'
		idsOut.setItem(llNewRow,'file_name', lsFileName)
		
	//TAM 2019/04/22 - S32624 - Added Soft Bundle logic(NonPic)
	//If SKU lenth = 7 (remove the leading 0's first) then for each BOM row create a detail record
	Else
		//remove leading zeros from SKU
		lsTemp = lsSKU
		Do While Left(lsTemp,1) = "0"
			lsTemp = Mid(lsTemp,2)
		Loop
		// If Length = 7 then get Delivery BOM
		if Len(lsTemp) = 7 then
			//Filter the BOM Records on SKU
// TAM  2019/07/13 - DE11661 - 	multiple lines with Zero qty in PPD records	
// TAM  2019/07/13 - DE11662 - 	Duplicated PPD with wrong Qty		
//			idsDOBOM.SetFilter("Parent_SKU = '"+ lsSKU +"'")  
			lsFilter = "SKU_Parent = '"+ lsSKU +"' and User_Field6 = '" + lsUF6 + "'"		
			idsDOBOM.SetFilter(lsFilter)  
		
			idsDOBOM.filter( )
			llBOMCount = idsDOBOM.rowcount( )
			//Build a detail Row for each record in the BOM
			For llBOMPos = 1 to llBOMCount
				llNewRow = idsOut.insertRow(0)
				lsOutString = 'PPD|'
				lsOutString += trim(ls_Invoice_No) + '|'
				lsOutString += String(idsDOBOM.getItemNumber(llBOMPos, 'Child_Line_item_No')) + "|"
				lsOutString += idsDOBOM.getItemString(llBOMPos, 'SKU_Child') + "|"
				lsOutString += String( idsDODetail.getItemNumber(llRowPos, 'Req_Qty') * idsDOBOM.getItemNumber(llBOMPos, 'Child_Qty') ) + "|"
				lsOutString += idsDOBOM.getItemString(llBOMPos, 'Supp_Code_Child')  + "|"
		
				//EAN - should be pulled from Item_Master.UF4
				If Not isnull( idsDODetail.getItemString(llRowPos, 'im_user_field4')) Then
					lsOutString += nz(idsDODetail.getItemString(llRowPos, 'im_user_field4'), '') + "|"
				Else
					lsOutString += "|"
				End if
		
				//User_Field6
				If Not isnull( idsDODetail.getItemString(llRowPos, 'User_Field6')) Then
					lsOutString += idsDODetail.getItemString(llRowPos, 'User_Field6') + "|"
				Else
					lsOutString += "|"
				End if
	
				//Serial No
				lsOutString += "|"
			
				lsOutString += String( idsDODetail.getItemNumber(llRowPos, 'Alloc_Qty') * idsDOBOM.getItemNumber(llBOMPos, 'Child_Qty')) + "|"
				lsOutString += String( idsDoMain.getItemDateTime(1, 'Pick_Complete'), 'YYYYMMDDHHMM')
				
				idsOut.setItem(llNewRow,'Project_id', asproject)
				idsOut.setItem(llNewRow,'EDI_Batch_Seq_No', Long(ldBatchSeq))
				idsOut.setItem(llNewRow,'Line_Seq_No', llNewRow)
				idsOut.setItem(llNewRow,'Batch_Data', lsOutString)
				//dts - S51259 lsFileName = 'PPBH' + String(ldBatchSeq,'00000000') + '.dat'
				lsFileName = lsFilePrefix + String(ldBatchSeq,'00000000') + '.dat'
				idsOut.setItem(llNewRow,'file_name', lsFileName)				
			Next
		end if // Sku length 7
		
	End If
NEXT /*next Delivery Detail record */

ll_Serial_Count = idsDoSerial.retrieve( asdono)
//D. build SN records
FOR llRowPos = 1 to ll_Serial_Count
	llNewRow = idsOut.insertrow( 0)
	
	lsOutString ='PPS|'
	lsOutString += String(idsDoSerial.getItemNumber( llRowPos, 'line_item_no')) +'|'
	lsOutString += idsDoSerial.getItemString( llRowPos, 'serial_no')
	
	idsOut.setItem(llNewRow,'Project_id', asproject)
	idsOut.setItem(llNewRow,'EDI_Batch_Seq_No', Long(ldBatchSeq))
	idsOut.setItem(llNewRow,'Line_Seq_No', llNewRow)
	idsOut.setItem(llNewRow,'Batch_Data', lsOutString)
	//dts - S51259 lsFileName = 'PPBH' + String(ldBatchSeq,'00000000') + '.dat'
	lsFileName = lsFilePrefix + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.setItem(llNewRow,'file_name', lsFileName)
NEXT

//E. build Expansion Detail records
idsDOExpansion.SetFilter( "Order_Table = 'Delivery_Detail'")
idsDOExpansion.filter( )
llExpCount = idsDOExpansion.rowcount( )
idsDOExpansion.setsort( "order_line_no A")
idsDOExpansion.sort( )

// B. build Expansion Header Records
For llExpRowPos = 1 to llExpCount
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = 'EX|'
	lsOutString += idsDOExpansion.GetItemString(llExpRowPos, 'User_Line_Item_No') +'|'
	lsOutString += idsDOExpansion.GetItemString(llExpRowPos, 'Field_Name') + '|'
	lsOutString += idsDOExpansion.GetItemString(llExpRowPos, 'Field_Data')
		
	idsOut.setItem(llNewRow,'Project_id', asproject)
	idsOut.setItem(llNewRow,'EDI_Batch_Seq_No', Long(ldBatchSeq))
	idsOut.setItem(llNewRow,'Line_Seq_No', llNewRow)
	idsOut.setItem(llNewRow,'Batch_Data', lsOutString)
	//dts - S51259 lsFileName = 'PPBH' + String(ldBatchSeq,'00000000') + '.dat'
	lsFileName = lsFilePrefix + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.setItem(llNewRow,'file_name', lsFileName)
Next

//remove filter
idsDOExpansion.setfilter( "")
idsDOExpansion.filter( )
idsDOExpansion.rowcount( )

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, asproject)

destroy idsOut
destroy idsDOExpansion
destroy idsDoSerial
destroy idsDODetail
destroy idsDOMain

Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid, long altransid);// 02/19 - PCONKL (I know, WTF?) - Prepare a Stock Adjustment Transaction for Philips for the Stock Adjustment just made

Long		llNewRow, llNewQty, lloldQty, llRowCount,	llAdjustID, llAbsQty
				
String		lsOutString,	lsSKU, lsOldInvType,	lsNewInvType, lsFileName,		&
			lsReason, 	lsTranType, lsSupplier,  lsUOM, lsUPC, lsLogOut, lsTransParm, lsOldDispCode, lsNewDispCode
String		lsReasonDesc, lsSAPMovementType, lsStepCode, lsInvReasonCode, ls_uf4, lsSerialNo

Decimal	ldBatchSeq
Integer	liRC

String 	lsNewInvTypeTranslated, lsOldInvTypeTranslated

Str_Parms 	lstr_Parms

Datastore ldsAdjustment

lsLogOut = "      Creating MM For AdjustID: " + String(alAdjustID)
FileWrite(gilogFileNo,lsLogOut)

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(ldsAdjustment) Then
	ldsAdjustment = Create Datastore
	ldsAdjustment.Dataobject = 'd_adjustment'
	ldsAdjustment.SetTransObject(SQLCA)
End If

//Create the Proc Philips NVO so we can use the existing function for converting Inventory Types and Disp codes
If not isvalid(iuo_proc_philips_cls) Then
	iuo_proc_philips_cls = Create u_nvo_proc_philips_cls
End If

//We need the Parm from the Batch Transaction to possibly connect a multiple record Inv Type change
Select Trans_parm into :lsTransParm
From Batch_Transaction with(nolock)
Where Trans_id = :alTransID;

If isnull(lsTransParm) then lsTransParm = ''

//If Trans parm = SKIP then return (the non relevent half of a partial bucket change - part of baseline logic on client)
If lsTransParm = 'SKIP' Then Return 0

//Retreive the adjustment record
If ldsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//We are only processing Inv Type and Qty changes
If ldsAdjustment.GetITemString(1,"adjustment_type") <> 'I' and  ldsAdjustment.GetITemString(1,"adjustment_type") <> 'Q' Then Return 0

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsSku = ldsAdjustment.GetITemString(1,'sku')
lsSupplier = ldsAdjustment.GetITemString(1,'supp_code')

//We need the Level one UOM and UPC (GTIN)  from Item Master
Select uom_1, part_upc_Code, user_field4 into :lsUOM, :lsUPC, :ls_uf4
From Item_Master with(nolock)
Where project_id = :asProject and sku = :lsSKU and supp_code = :lsSupplier
Using SQLCA;

If isNull(lsUOM) Then lsUOM = ""
If isNull(lsUPC) Then lsUPC = ""

lsReason = ldsAdjustment.GetITemString(1,'reason')
If isnull(lsReason) then lsReason = ''

//We need to parse the SAP Reason Code, Movement Type and Step Code from the Reason description - retrieve from lookup table
If lsReason > '' Then
	
	Select Code_descript into :lsReasonDesc
	From Lookup_table with(nolock)
	Where Project_id = :asProject and Code_type = 'IA' and code_id = :lsreason
	Using SQLCA;
	
	If lsReasonDesc > '' Then /* Parse into Movement Type|Event(not needed)|Step Code */
	
		lsSAPMovementType =  Left(lsReasonDesc,(pos(lsReasonDesc,'|') - 1))
		lsReasonDesc = Right(lsReasonDesc,(len(lsReasonDesc) - (Len(lsSAPMovementType) + 1)))
		lsInvReasonCode =  Left(lsReasonDesc,(pos(lsReasonDesc,'|') - 1))
		lsReasonDesc = Right(lsReasonDesc,(len(lsReasonDesc) - (Len(lsInvReasonCode) + 1)))
		lsStepCode = lsReasonDesc
		
	End If
	
End If

llAdjustID = ldsAdjustment.GetITemNumber(1,"adjust_no")

llNewQty = ldsAdjustment.GetITemNumber(1,"quantity")
lloldQty = ldsAdjustment.GetITemNumber(1,"old_quantity")

lsOldInvType = ldsAdjustment.GetITemString(1,"old_inventory_type") /*original value before update! - may be overridden below if this is a multiple record Inv Type change*/
lsNewInvType = ldsAdjustment.GetITemString(1,"inventory_type")

lsSerialNo = ldsAdjustment.GetITemString(1,"serial_no") //12-MAR-2019 :Madhu S30950 Add Serial No record
If IsNull(lsSerialNo) Then lsSerialNo='-'

//TAM 2019/03/04 - Use A new table to create the Translation for Inventory Types and Disposition Codes - Start
lstr_Parms = iuo_proc_philips_cls.getphilipssuppliertranslations( asProject, lsSupplier, lsOldInvType)

lsOldInvTypeTranslated = 	lstr_Parms.string_arg[1]  //Translated Old Inventory Type
lsOldDispCode = 	lstr_Parms.string_arg[2]  //Translated Old Disposition Code

lstr_Parms = iuo_proc_philips_cls.getphilipssuppliertranslations( asProject, lsSupplier, lsNewInvType)

lsNewInvTypeTranslated = 	lstr_Parms.string_arg[1]  //Translated Old Inventory Type
lsNewDispCode = 	lstr_Parms.string_arg[2]  //Translated Old Disposition Code
//TAM 2019/03/04 - Use A new table to create the Translation - End
		
// Qty is the absolute value of either the qty being changed or the qty of the Inv Type being changed. The Increase/Decrease will be noted in the Detail record
If ldsAdjustment.GetITemString(1,"adjustment_type") = 'Q' Then /*Qty Adjustment*/

	llAbsQty = Abs(llNewQty - llOldQty)
	
Else /*Inv Type Change*/
	
	//We may have one or 2 records for an inv Type change depending on whether a whole bucket was changed or a partial (split or updated 2 existing content records)
	If llOldQty = llNewQty Then /*the entire bucket was swapped*/
		llAbsQty = llNewQty
	Else /* this is either the increment or decrement but we don't care - the other half will be skipped, we just need the ABS of the difference*/
		llAbsQty = Abs(llNewQty - llOldQty)
	End If
	
End If

// Get The Disposition Codes for Old/New Inv Types.  
// For a Qty Chg, they will be the same. 
// For an Inv Type we need to determine if this was a single or multiple record Adjustment to determine where the Old/New Inv type is coming from.
If ldsAdjustment.GetITemString(1,"adjustment_type") = 'Q' Then /*Qty Adjustment*/

//TAM 2019/03/04 - Values Loaded above Use A new table to create the Translation for Inventory Types and Disposition Codes 
//	lsOldDispCode =  iuo_proc_philips_cls.getphilipsdisposition(lsOldInvType) /*either will work*/
//	lsNewDispCode =  iuo_proc_philips_cls.getphilipsdisposition(lsNewInvType) /*either will work*/
	
Else /*Inv Type Change*/
	
	If llOldQty = llNewQty Then /*the entire bucket was swapped*/
	
//TAM 2019/03/04 - Values Loded AboveUse A new table to create the Translation for Inventory Types and Disposition Codes - Start
		//lsOldDispCode =  iuo_proc_philips_cls.getphilipsdisposition(lsOldInvType) /*Original Inv Type*/
		//lsNewDispCode =  iuo_proc_philips_cls.getphilipsdisposition(lsNewInvType) /*New Inv Type*/
		
	Else /* Multiple bucket swap/Split*/
		
//TAM 2019/03/04 - Calues Loaded AboveUse A new table to create the Translation for Inventory Types and Disposition Codes - Start
//		lsNewDispCode =  iuo_proc_philips_cls.getphilipsdisposition(lsNewInvType)
				
		//If the Old/New Inv Type are the same, this is a new record created from a split and the Trans Parm will contain the Original value (Existing baseline logic)  e.g "OLD_INVENTORY_TYPE=R"
		//Otherwise, it is the the bucket being adjusted to (the other is skipped) and will contain both the original and new values
		If lsOldInvType = lsNewInvType Then
			
			//Begin Dinesh - 05/18/21- DE21469 - SIMS - PHILIPSCLS GOODSMOVEMENT MISSING DATA
			if lsTransParm='' or isnull(lsTransParm) then // Dinesh
				
				lsOldInvType=lsNewInvType
				
			else
		
				lsOldInvType = Right(Trim(lsTransParm),1)
			
			end if
			
			//End Dinesh - 05/18/21- DE21469 - SIMS - PHILIPSCLS GOODSMOVEMENT MISSING DATA
			//lsOldInvType = Right(Trim(lsTransParm),1) // Dinesh - 08/18/2021- DE22739 -SIMS - PHILIPSCLS GOODSMOVEMENT MISSING DATA
//			lsOldDispCode =  iuo_proc_philips_cls.getphilipsdisposition(lsOldInvType)
			lstr_Parms = iuo_proc_philips_cls.getphilipssuppliertranslations( asProject, lsSupplier, lsOldInvType)

			lsOldInvTypeTranslated = 	lstr_Parms.string_arg[1]  //Translated Old Inventory Type
			lsOldDispCode = 	lstr_Parms.string_arg[2]  //Translated Old Disposition Code
		Else
//			lsOldDispCode =  iuo_proc_philips_cls.getphilipsdisposition(lsOldInvType)
		End If

	
	End If

End IF

//File Name 
lsFileName = 'GM' + lsSupplier + String(ldBatchSeq,'00000000') + '.DAT'
		
//Write a Header record
lsOutString = 'GMH' + '|' 
lsOutString += String(today(),'yyyymmddhhmmss') + '|'  
lsOutString += nz(lsSupplier,'') + '|' /* Plant Code*/
lsOutString += String(alAdjustID) + '|' /* Adjustment ID*/
lsOutString += nz(ls_uf4,'') + '|' /* GTIN (UF4)*/
lsOutString += nz(lsSku,'') + '|' 
lsOutString += String(llAbsQty) + '|'
lsOutString += nz(lsUOM,'') + '|'
lsOutString += nz(lsOldDispCode,'')

llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id', asproject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
//Write one or 2 (if Inv Type change) records
lsOutString = 'GMD' + '|'
lsOutString += nz(lsStepCode,'') + '|'

//If a Qty Change, Set Movement type To Increase/Decrease based on qty diff, otherwise there will be 2 rows and first will alwayys be Decreased
If ldsAdjustment.GetITemString(1,"adjustment_type") = 'Q' Then /*Qty Adjustment*/
	If llnewQty > llOldQty Then
		lsOutString +=  'INCREASE|'
	Else
		lsOutString +=  'DECREASE|'
	End If
Else /* Inv Type change */
	lsOutString +=  'DECREASE|'
End If

lsOutString += nz(Left(lsReason,4),'') + '|' /* we may need to add a 5th char to differentiate different values with the same reason code */
// 
//lsOutString += iuo_proc_philips_cls.getphilipsinvtype(lsOldInvType) + '|' /* From Storage Location (Inv Type) */
lsOutString += nz(lsOldInvTypeTranslated,'') + '|' /* From Storage Location (Inv Type) */
lsOutString += nz(lsOldDispCode,'') + '|'
lsOutString += nz(lsInvReasonCode, '') //10-MAR-2019 :Madhu Added GS1 InventoryEvent Reason Code

llNewRow = idsOut.insertRow(0)
	
idsOut.SetItem(llNewRow,'Project_id', asproject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
//If this is an Inv Type Change, we need to write a second detail record
If ldsAdjustment.GetITemString(1,"adjustment_type") = 'I' Then
	
	lsOutString = 'GMD' + '|'
	lsOutString += nz(lsStepCode,'') + '|'
	lsOutString +=  'INCREASE|'
	lsOutString += nz(lsReason,'') + '|'

//TAM 2019/03/04 - Loaded Above Use A new table to create the Translation 
//	lsOutString += iuo_proc_philips_cls.getphilipsinvtype(lsNewInvType) + '|' /* To Storage Location (Inv Type) */
	lsOutString += nz(lsNewInvTypeTranslated,'') +'|'
	lsOutString += nz(lsNewDispCode,'') +'|'
	lsOutString += nz(lsInvReasonCode, '') //10-MAR-2019 :Madhu Added GS1 InventoryEvent Reason Code
		
	llNewRow = idsOut.insertRow(0)
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
End If

//12-MAR-2019 :Madhu S30950 Add Serial No Records
IF lsSerialNo <> '-' THEN
	
	lsOutString ='GMS'+'|'
	lsOutString += nz(lsSerialNo,'')
	
	llNewRow = idsOut.insertRow(0)
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
END IF

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	

Return 0
end function

public function integer uf_event_status_delivery_date (string asproject, string asdono);//TAM 2019/02/28 - Philips BlueHeart OutboundShipmentUpdateStatus
//generate SHD*.DAT file When a Delivery Date Transation file(COD) is recieved.

String lsLogOut, lsOutString, lsFileName, ls_InvoiceNo, ls_sql, ls_errors
Integer lirc
Decimal ldBatchSeq
Long llNewRow, llExpRow, llExpCount, ll_do_count

Datastore lds_do

IF Not isvalid(idsOut) THEN
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
END IF

IF Not isvalid(idsDOExpansion) THEN
	idsDOExpansion = Create Datastore
	idsDOExpansion.Dataobject = 'd_edi_outbound_expansion'
	idsDOExpansion.SetTransObject(SQLCA)
END IF

idsOut.Reset()

lsLogOut = "        Creating SHD For DONO: " + asdono
FileWrite(gilogFileNo,lsLogOut)

//build datastore
lds_do = create datastore
ls_sql = " select dm.invoice_no, dm.user_field3, dm.schedule_date, dm.delivery_date, dm.edi_batch_seq_no, dm.user_field4 "
ls_sql +=" from delivery_master dm with(nolock) "
ls_sql +=" where dm.project_id='"+asproject+"' and dm.do_no='"+asdono+"'" 

lds_do.create( SQLCA.syntaxfromsql( ls_sql, "", ls_errors))
lds_do.settransobject( SQLCA)
ll_do_count = lds_do.retrieve( )

//Retreive Delivery Master and Detail  records for this DONO
IF ll_do_count <= 0 THEN
	lsLogOut = "        *** Unable to retreive Delivery Order Header records For DONO: " + asdono
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
ELSE
	If lds_do.getItemNumber(1, 'edi_batch_seq_no') = 0 or isNull(lds_do.getItemNumber(1, 'edi_batch_seq_no'))    Then Return 0
END IF

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Shipment Status Update.~r~rStatus will not be sent to Philips!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
ls_InvoiceNo = lds_do.getItemString(1,'invoice_no')
	
llNewRow = idsOut.insertRow(0)

lsOutString = 'SH|' //SH001 - Record Id
lsOutString += String(lds_do.getItemDateTime(1, 'delivery_date'), 'yyyymmddhhmmss') + '|' //SD002 - Delivery Date
lsOutString += nz(ls_InvoiceNo, '')  + '|' //SD004 - Invoice No
lsOutString += nz(lds_do.getItemString(1,'user_field3'), '') + '|' //SH003 - Supplier (Plant)
lsOutString += nz(lds_do.getItemString(1,'user_field4'), '') //SH005 - GTIN  //TAM 2019/03/07  - added 
	
idsOut.SetItem(llNewRow,'Project_Id', asproject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
lsFileName = 'SHD' + String(ldBatchSeq,'00000000') + '.dat'
idsOut.SetItem(llNewRow,'file_name', lsFileName)

//retrieve expansion records
idsDOExpansion.retrieve( asproject, ls_InvoiceNo, lds_do.getItemNumber(1, 'edi_batch_seq_no'))
//Filter the Header Expansion Records(User Line Item No = 0) and 
idsDOExpansion.SetFilter( "User_Line_Item_No = '0'")  //Filter Header expansion records
idsDOExpansion.filter( )
llExpCount = idsDOExpansion.rowcount( )

FOR llExpRow = 1 to llExpCount
	llNewRow = idsOut.insertRow(0)

	lsOutString = 'EX|' //Rec ID
	lsOutString += '0|' //Line Number 0 = Header Expansion Record
	lsOutString += nz(idsDOExpansion.getItemString(llExpRow,'Field_Name'), '') + '|'  //Field Name
	lsOutString += nz(idsDOExpansion.getItemString(llExpRow,'Field_Data'), '')  //Field Data

	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'SHD' + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
NEXT /* Next Expansion record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, asproject)

destroy idsDOExpansion
destroy lds_do
destroy idsOut

Return 0
end function

public function integer uf_event_status (string asproject, string asdono, string astranstype, string astransparm);//TAM 2019/02/28 - Philips BlueHeart OutboundShipmentUpdateStatus
//Process Batch Transaction file for type 'ES' Event Status.
//Made this Generic Enough to use Trans Type 'ES' for future Status Files.  The Type of Status will be sent in the 'asTransParm'

Integer lirc
String lsLogOut

lsLogOut = "        Creating Transaction file for DONO: " + asdono + "event type: " + astransparm
FileWrite(gilogFileNo,lsLogOut)

If Upper(astransParm) = 'DELIVEREDDATE' Then
	lirc = uf_event_status_delivery_date(asproject, asdono)
Else
	lirc = 99
END IF

Return lirc
end function

on u_nvo_edi_confirmations_philipscls.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_philipscls.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

