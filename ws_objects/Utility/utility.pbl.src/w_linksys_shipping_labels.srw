$PBExportHeader$w_linksys_shipping_labels.srw
$PBExportComments$Print Generic UCCS Shipping labels
forward
global type w_linksys_shipping_labels from w_main_ancestor
end type
type cb_print from commandbutton within w_linksys_shipping_labels
end type
type dw_label from u_dw_ancestor within w_linksys_shipping_labels
end type
type cb_selectall from commandbutton within w_linksys_shipping_labels
end type
type cb_clear from commandbutton within w_linksys_shipping_labels
end type
type cb_carton from commandbutton within w_linksys_shipping_labels
end type
type cb_partial from commandbutton within w_linksys_shipping_labels
end type
end forward

global type w_linksys_shipping_labels from w_main_ancestor
integer width = 3191
integer height = 1788
string title = "Shipping Labels"
boolean clientedge = true
event ue_print ( string arg_type )
event ue_print_dotmatrix ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_clear cb_clear
cb_carton cb_carton
cb_partial cb_partial
end type
global w_linksys_shipping_labels w_linksys_shipping_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels

String	isUCCSCompanyPrefix, isUCCSWHPrefix

String	isDONO, isCustNo

datastore idsPickingDetail
datastore idsItemMaster
datastore idsPacking

end variables

forward prototypes
public function string getpartialmixedlabeltext (string assku, string asdono, string ascarton)
public function long getskucount (string assku)
end prototypes

event ue_print(string arg_type);Str_Parms	lstrparms, lstrparms2

string ls_Cust_Code 
string ls_label
Long	llQty, llRowCount, llRowPos, ll_rtn, ll_alloc_qty, llRowPos1, llLabelCount, llLabelOf
Any	lsAny
String	lsCityStateZip, lsSKU, ls_format, ls_old_carton_no,ls_carton_no,ls_old_carton_no1,ls_carton_no1,	&
			lsDONO, lsCartonHold
Boolean lb_generic,lb_print_mixed ,lb_duplicate_carton,lb_print
long ll_tot_metrics_weight,ll_tot_english_weight,ll_cnt,ll_cnt1,ll_carton_cnt,ll_count,ll_count_prev
//dts - moved the following declarations from below...
string ls_sku, ls_supp_code, ls_do_no, ls_country_id, ls_country
string ls_desc
//decimal ld_packaged_weight
decimal ld_weight_1 // 7/19/04 - grabbing weight_1 now instead of packaged_weight
string ls_Part_UPC_Code
integer li_Qty_2
long ll_Alloc_Qty_Partial
integer li_mod
integer li_idx, li_RowCount

long arow

// pvh - 10/05/05
datastore 				ldsUccsShip
ldsUccsShip 			= f_datastoreFactory( 'd_linksys_uccs_ship' )
idsItemMaster 		= f_datastoreFactory('d_item_master')
idsPickingDetail 	= f_datastoreFactory('d_dono_picking_detail_by_dono_sku')
idsPacking		 	= f_datastoreFactory('d_pack_detail_by_dono_carton')

n_warehouse l_nwarehouse 
n_cst_common_tables ln_common_tables

Dw_Label.AcceptText()

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 AND arg_type <> 'SHIP' Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

IF arg_type = 'SHIP' then
	IF dw_label.RowCount() <= 0 THEN
		MessageBox ('Labels', " There are no labels to print.")
		RETURN
	END IF
	llRowPos = 1
END IF


//Count the total unique Cartons
FOR ll_count= 1 TO dw_label.RowCount()
	
//	IF dw_label.object.c_print_ind[ll_count] <> 'Y' THEN Continue
	IF ll_count > 1 THEN 
		ll_count_prev=ll_count - 1
	ELSE
		ll_count_prev=1
		ll_carton_cnt ++
		Continue
	END IF	
	
	IF	dw_label.object.delivery_packing_carton_no[ll_count_prev] <> dw_label.object.delivery_packing_carton_no[ll_count] THEN
		ll_carton_cnt ++
	END IF
	
NEXT

lStrParms.String_arg[1] = 'UCCS Ship - Zebra'

OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then Return 

//We need the distinct carton count for "box x of y" count - we may have more than 1 row per packing

lsDoNo = dw_label.GetITemString(1,'delivery_Master_do_no')
lscartonHold = ''

Select Count(distinct Carton_NO) Into :llLabelCount
From Delivery_Packing
Where do_no = :lsDONO;


//Delivery_Master.Cust_Code

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' AND arg_type <> 'SHIP' THEN Continue
	
	ls_carton_no = dw_label.object.delivery_packing_carton_no[llRowPos]
	llQty = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
	Lstrparms.Long_arg[1] = llQty

	ls_Cust_Code = dw_label.object.delivery_master_cust_code[llRowPos]
	
	//User_Field1 is used to define which label to use. 
	
	if arg_type = 'FULL' then
		
		SELECT USER_FIELD3 INTO :ls_label
			FROM Customer
			WHERE CUST_CODE = :ls_cust_code AND
					PROJECT_ID = :gs_project USING SQLCA;

	else  
  
  		ls_label = arg_type
  
	end if
  
	//LstrParms.String_arg[1] = dw_label.object.customer_user_field2[llRowPos] +".DWN"// **Change Later
	//Lstrparms.String_arg[2] = dw_label.GetItemString(llRowPos,'warehouse_wh_name')
	Lstrparms.String_arg[3] = dw_label.GetItemString(llRowPos,'warehouse_address_1')
	Lstrparms.String_arg[4] = dw_label.GetItemString(llRowPos,'warehouse_address_2')
	Lstrparms.String_arg[5] = dw_label.GetItemString(llRowPos,'warehouse_address_3')
	Lstrparms.String_arg[31] = dw_label.GetItemString(llRowPos,'Warehouse_address_4')
		
	//Compute FROM City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_city')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'warehouse_city') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_state')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_state') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_zip') + ' '

	
	Lstrparms.String_arg[6] = lsCityStateZip
			
	Lstrparms.String_arg[7] = dw_label.GetItemString(llRowPos,'delivery_master_Cust_name')
	Lstrparms.String_arg[8] = dw_label.GetItemString(llRowPos,'delivery_master_address_1')
	Lstrparms.String_arg[9] = dw_label.GetItemString(llRowPos,'delivery_master_address_2')
	Lstrparms.String_arg[10] = dw_label.GetItemString(llRowPos,'delivery_master_address_3')
	Lstrparms.String_arg[32] = dw_label.GetItemString(llRowPos,'delivery_master_address_4')
	Lstrparms.String_arg[33] = dw_label.GetItemString(llRowPos,'delivery_master_Zip') /* 12/03 - PCONKL - for UCCS Ship to Zip */

		
	//Compute TO City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_City')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'delivery_master_City') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_State')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_State') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_Zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_Zip') + ' '
	Lstrparms.String_arg[11] = lsCityStateZip
	
	If isnumber(dw_label.object.delivery_packing_carton_no[llRowPos]) Then
		Lstrparms.String_arg[12] = String(Long(dw_label.object.delivery_packing_carton_no[llRowPos]),'000000000')
	Else
		dw_label.object.delivery_packing_carton_no[llRowPos]
	End If
	
	Lstrparms.String_arg[36] = dw_label.GetItemString(llRowPos,'user_field6') /* PRO */
	
	Lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'delivery_master_cust_order_no') 
	//Lstrparms.String_arg[15] = String(Round(dw_label.object.delivery_packing_quantity[llRowPos],0))
	Lstrparms.String_arg[17] = dw_label.object.delivery_master_invoice_no[llRowPos]
	Lstrparms.String_arg[21] = dw_label.object.delivery_master_do_no[llRowPos]
	
	string ls_carrier_code, ls_carrier_name
	
	ls_carrier_code = dw_label.object.delivery_master_carrier[llRowPos]
	
	
	SELECT carrier_name INTO :ls_carrier_name
		from carrier_master
		where carrier_code = :ls_carrier_code AND project_id = 'LINKSYS' USING SQLCA;

	Lstrparms.String_arg[25] = ls_carrier_name
	Lstrparms.String_arg[27] = dw_label.GetItemString(llRowPos,'user_field5') 
	Lstrparms.String_arg[34] = dw_label.GetItemString(llRowPos,'user_field2') 
	Lstrparms.String_arg[36] = dw_label.GetItemString(llRowPos,'user_field6') 
	Lstrparms.String_arg[37] = string(ll_carton_cnt)
	Lstrparms.String_arg[38] = dw_label.GetItemString(llRowPos,'user_field4') 
	Lstrparms.String_Arg[50] = string(dw_label.GetItemDateTime(llRowPos,'pick_complete'), "MM/DD/YYYY") 
	Lstrparms.String_arg[39] = string(dw_label.GetItemDateTime(llRowPos,'complete_date'), "MM/DD/YYYY") 
// pvh 10/04/05
	if dw_label.dataobject = "d_linksys_uccs_ship_gen" then
		arow = ldsUccsShip.retrieve( gs_project, dw_label.object.delivery_master_do_no[llRowPos] )
		Lstrparms.String_arg[40] = ldsUccsShip.object.sku[ arow ]
// eom
	else

		Lstrparms.String_arg[40] = dw_label.GetItemString(llRowPos,'sku')

	end if

	Lstrparms.String_arg[45] = dw_label.GetItemString(llRowPos,'awb_bol_no')

	boolean lb_carton

	if Upper(dw_label.GetItemString(llRowPos,'carton_type')) = 'CARTON' then
		lb_carton = true
	else
		lb_carton = false
	end if
	
	Lstrparms.String_arg[48] = f_linksys_create_ucc(lb_carton,dw_label.GetItemString(llRowPos,'carton_no'))

	Lstrparms.Long_arg[1] = llQty /*Qty of labels to print*/
	lstrparms.Long_arg[3] = dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross')/*carton weight */
	
	IF dw_label.object.delivery_packing_standard_of_measure[llRowPos] = 'M' THEN			
		lstrparms.Long_arg[3]= round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross'),"KG","PO"),2)
		lstrparms.Long_arg[4] = dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross')/*carton qty */
	ELSE	
		lstrparms.Long_arg[4]= round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross'),"PO","KG"),2)		
	END IF	
	
	if dw_label.dataobject = "d_linksys_uccs_ship_gen" then
	else
		ls_do_no =  dw_label.GetItemString(llRowPos,'delivery_master_do_no')	
		ls_sku =  dw_label.GetItemString(llRowPos,'sku')	
		ls_supp_code =  dw_label.GetItemString(llRowPos,'supp_code')			
	end if	
		
	ls_country_id =  dw_label.GetItemString(llRowPos,'country_of_origin')		

	if Upper(ls_country_id) = 'TWN' OR Upper(ls_country_id) = 'TW' then
		ls_country = 'Taiwan, ROC'
	else	
		ls_country = f_get_country_name(ls_country_id)
	end if

	Lstrparms.String_arg[41] = ls_country
	 
	if dw_label.dataobject = "d_linksys_uccs_ship_gen" then
		
	else
				 
		ll_Alloc_Qty_Partial = dw_label.GetItemNumber(llRowPos,'quantity')
	
		ls_sku =  dw_label.GetItemString(llRowPos,'sku')	
		ls_supp_code =  dw_label.GetItemString(llRowPos,'supp_code')
	
		/* SELECT Item_Master.Description, Packaged_Weight, Part_UPC_Code, Qty_2 
			INTO :ls_desc, :ld_packaged_weight, :ls_Part_UPC_Code, :li_Qty_2 */
		SELECT Item_Master.Description, Weight_1, Part_UPC_Code, Qty_2
		INTO :ls_desc, :ld_weight_1, :ls_Part_UPC_Code, :li_Qty_2
			FROM Item_Master
			WHERE Item_Master.Project_ID = :gs_project AND
					sku = :ls_sku and
					supp_code = :ls_supp_code
			USING SQLCA;
	
		if sqlca.sqlcode <> 0 then		
			Messagebox ("Item Master", SQLCA.SQLErrText )
		end if	
	
		//integer li_mod
	
		IF arg_type <> 'SHIP' then
	
			if isnull(li_qty_2) then li_qty_2 = 0
			//if isnull(ld_packaged_weight) then ld_packaged_weight = 0
			if isnull(ld_weight_1) then ld_weight_1 = 0
			if isnull(ls_Part_UPC_Code) then ls_Part_UPC_Code = ''
			if isnull(ls_desc)  then ls_desc = ""
		
	//		MessageBox (ls_sku, ls_desc)
		
			Lstrparms.String_arg[42] = ls_desc
			
			if li_qty_2 > 0 then	
				li_mod = Mod ( ll_Alloc_Qty_Partial, li_Qty_2 )		
			else			
				li_mod = 0		
			end if
			
			if li_mod <> 0 or li_qty_2 = 0 then			
				if ll_Alloc_Qty_Partial < li_Qty_2 then				
					lstrparms.Long_arg[10] = ll_Alloc_Qty_Partial				
				else				
					lstrparms.Long_arg[10] = li_mod				
				end if			
				//lstrparms.Long_arg[11] = lstrparms.Long_arg[10] * ld_packaged_weight
				lstrparms.Long_arg[11] = lstrparms.Long_arg[10] * ld_weight_1	
				lstrparms.cancelled = false
				lstrparms2 = lstrparms
				
				OpenWithParm(w_linksys_partial_print, lstrparms2)
				
				lstrparms2 = message.PowerObjectParm		
				if not lstrparms2.cancelled then	
					lstrparms.Long_arg[10] = lstrparms2.Long_arg[10] 
					lstrparms.Long_arg[11] = lstrparms2.Long_arg[11] 
					Lstrparms.String_arg[43] = ls_Part_UPC_Code	
					lsAny=lstrparms				
					IF ls_label <> 'PARTIAL' then
						invo_labels.uf_linksys_zebra_ship(lsAny, "PARTIAL")
					END IF
				end if
			else
				IF ls_label = 'PARTIAL' THEN
					lstrparms.Long_arg[10] = 0
					lstrparms.Long_arg[11] = 0		
					lstrparms.cancelled = false
					lstrparms2 = lstrparms
					OpenWithParm(w_linksys_partial_print, lstrparms2)
					lstrparms2 = message.PowerObjectParm
					if not lstrparms2.cancelled then
						lstrparms.Long_arg[10] = lstrparms2.Long_arg[10] 
						lstrparms.Long_arg[11] = lstrparms2.Long_arg[11] 
						Lstrparms.String_arg[43] = ls_Part_UPC_Code
					END IF
				END IF
			end if

		end if

	end if			
	
	If lscartonHold <> ls_carton_no Then
		llLabelof ++
	End If
	
	lsCartonHold = ls_carton_no
	
	lstrparms.String_Arg[28] = String(llLabelof) + " of " + String(llLabelCount)
	ll_tot_metrics_weight = 0; ll_tot_english_weight = 0
	
	// 12/03 - PCONKL - We need to pass the UCCS Prefix (Location + Company)
	lstrparms.String_arg[35] = isuccswhprefix + isuccscompanyprefix

	// pvh - 10/07/05
	Lstrparms.String_arg[61]  = getPartialMixedLabelText( Lstrparms.String_arg[40], &  
												dw_label.object.delivery_master_do_no[llRowPos] ,ls_carton_no ) 
	
	IF arg_type = "SHIP" THEN
		datastore lds_ds
		lds_ds = CREATE datastore
		lds_ds.dataobject = "d_linksys_bol_item_list"
		lds_ds.SetTransObject(SQLCA)
		li_RowCount = lds_ds.Retrieve( isDONO, gs_Project)
		//total_carton_count
		if li_RowCount <= 0 then RETURN
		llLabelCount = lds_ds.GetItemNumber( 1, "total_carton_count") 
	
		FOR li_idx = 1 TO llLabelCount
			lstrparms.String_Arg[28] = String(li_idx) + " of " + String(llLabelCount)
			lsAny=lstrparms		
			invo_labels.uf_linksys_zebra_ship(lsAny, ls_label)
		NEXT
	
		RETURN
	ELSE
		lsAny=lstrparms		
		invo_labels.uf_linksys_zebra_ship(lsAny, ls_label)
	END IF
		
	ls_old_carton_no =  ls_carton_no		
	 
Next /*detail row to Print*/

Destroy idsItemMaster 		
Destroy idsPickingDetail 
Destroy idsPacking



end event

event ue_print_dotmatrix();datastore ld_ds

SetPointer(Hourglass!)

Str_Parms	lstrparms

OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then Return 


ld_ds = Create datastore	

ld_ds.dataobject = "d_linksys_carton_ship_label"

long ll_count, ll_count_prev, ll_carton_cnt

//Count the total unique Cartons
FOR ll_count= 1 TO dw_label.RowCount()
	
//	IF dw_label.object.c_print_ind[ll_count] <> 'Y' THEN Continue
	IF ll_count > 1 THEN 
		ll_count_prev=ll_count - 1
	ELSE
		ll_count_prev=1
		ll_carton_cnt ++
		Continue
	END IF	
	
	IF	dw_label.object.delivery_packing_carton_no[ll_count_prev] <> dw_label.object.delivery_packing_carton_no[ll_count] THEN
		ll_carton_cnt ++
	END IF
	
NEXT


integer li_idx, li_Row

FOR ll_count= 1 TO dw_label.RowCount()
	
	IF dw_label.object.c_print_ind[ll_count] <> 'Y' THEN Continue


	li_row = ld_ds.InsertRow(0)

	Lstrparms.String_arg[1] = dw_label.GetItemString(ll_count,'warehouse_wh_name')
	Lstrparms.String_arg[2] = dw_label.GetItemString(ll_count,'warehouse_address_1')
	Lstrparms.String_arg[3] = dw_label.GetItemString(ll_count,'warehouse_address_2')
	Lstrparms.String_arg[4] = dw_label.GetItemString(ll_count,'warehouse_address_3')
	Lstrparms.String_arg[5] = dw_label.GetItemString(ll_count,'Warehouse_address_4')
	Lstrparms.String_arg[6] = dw_label.GetItemString(ll_count,'warehouse_city')
	Lstrparms.String_arg[7] = dw_label.GetItemString(ll_count,'warehouse_state')
	Lstrparms.String_arg[8] = dw_label.GetItemString(ll_count,'warehouse_zip')
	Lstrparms.String_arg[9] = dw_label.GetItemString(ll_count,'warehouse_country')
			
	Lstrparms.String_arg[10] = dw_label.GetItemString(ll_count,'delivery_master_Cust_name')
	Lstrparms.String_arg[11] = dw_label.GetItemString(ll_count,'delivery_master_address_1')
	Lstrparms.String_arg[12] = dw_label.GetItemString(ll_count,'delivery_master_address_2')
	Lstrparms.String_arg[13] = dw_label.GetItemString(ll_count,'delivery_master_address_3')
	Lstrparms.String_arg[14] = dw_label.GetItemString(ll_count,'delivery_master_address_4')
	Lstrparms.String_arg[15] = dw_label.GetItemString(ll_count,'delivery_master_City') 
	Lstrparms.String_arg[16] = dw_label.GetItemString(ll_count,'delivery_master_State') 
	Lstrparms.String_arg[17] = dw_label.GetItemString(ll_count,'delivery_master_Zip') 
	Lstrparms.String_arg[18] = dw_label.GetItemString(ll_count,'delivery_master_country') 

	Lstrparms.String_arg[19] = dw_label.GetItemString(ll_count,'delivery_packing_carton_no') 


	Lstrparms.String_arg[20] = dw_label.GetItemString(ll_count,'delivery_master_cust_order_no') 
	Lstrparms.String_arg[21] = dw_label.GetItemString(ll_count,'delivery_master_invoice_no') 

	Lstrparms.String_arg[22] = dw_label.GetItemString(ll_count,'tel') 


	if IsNull(Lstrparms.String_arg[6]) then Lstrparms.String_arg[6] = ""
	if IsNull(Lstrparms.String_arg[7]) then Lstrparms.String_arg[7] = ""
	if IsNull(Lstrparms.String_arg[8]) then Lstrparms.String_arg[8] = ""
	if IsNull(Lstrparms.String_arg[9]) then Lstrparms.String_arg[9] = ""
	
	ld_ds.SetItem(li_row, "warehouse_address_1", Lstrparms.String_arg[2])
	ld_ds.SetItem(li_row, "warehouse_address_2", Lstrparms.String_arg[3])
	ld_ds.SetItem(li_row, "warehouse_city", Lstrparms.String_arg[6])
	ld_ds.SetItem(li_row, "warehouse_state", Lstrparms.String_arg[7])
	ld_ds.SetItem(li_row, "warehouse_zip", Lstrparms.String_arg[8])
	ld_ds.SetItem(li_row, "warehouse_country", Lstrparms.String_arg[9])	
	ld_ds.SetItem(li_row, "warehouse_phone", Lstrparms.String_arg[22])	

	if IsNull(Lstrparms.String_arg[15]) then Lstrparms.String_arg[15] = ""
	if IsNull(Lstrparms.String_arg[16]) then Lstrparms.String_arg[16] = ""
	if IsNull(Lstrparms.String_arg[17]) then Lstrparms.String_arg[17] = ""	
	if IsNull(Lstrparms.String_arg[18]) then Lstrparms.String_arg[18] = ""	
	if IsNull(Lstrparms.String_arg[19]) then Lstrparms.String_arg[19] = ""	
	
	ld_ds.SetItem(li_row, "cust_name",  Lstrparms.String_arg[10])
	ld_ds.SetItem(li_row, "address_1",  Lstrparms.String_arg[11])	
	ld_ds.SetItem(li_row, "address_2",  Lstrparms.String_arg[12])
	ld_ds.SetItem(li_row, "address_3",  Lstrparms.String_arg[13])
	ld_ds.SetItem(li_row, "address_4",  Lstrparms.String_arg[14])
	ld_ds.SetItem(li_row, "city",  Lstrparms.String_arg[15])
	ld_ds.SetItem(li_row, "state",  Lstrparms.String_arg[16])
	ld_ds.SetItem(li_row, "zip",  Lstrparms.String_arg[17])	
	ld_ds.SetItem(li_row, "country",  Lstrparms.String_arg[18])	

	ld_ds.SetItem(li_row, "cust_order_no",  Lstrparms.String_arg[20])	
	ld_ds.SetItem(li_row, "invoice_no",  Lstrparms.String_arg[21])
	
	ld_ds.SetItem(li_row, "carton_text", "Carton " + Lstrparms.String_arg[19] + " of " + string(ll_carton_cnt))	
	
	
next	



long job

job = PrintOpen( )

// Each DataWindow starts printing on a new page.

PrintDataWindow(job, ld_ds)

PrintClose(job)


destroy ld_ds;
end event

public function string getpartialmixedlabeltext (string assku, string asdono, string ascarton);// string = getPartialMixedLabelText( string asSKU, string asdono, string asCarton )
constant string Partial = "Partial"
constant string Both = "Partial/Mixed"
constant string Mixed = "Mixed"

decimal{5} level2Qty
decimal{5} pickQty

int 			index
int 			max
long 			pickRows
long 			packRows
long 			itemRow
boolean 	lbpartial
boolean 	lbmixed
string 		supplierCode
string 		returnValue = ' '
string 		lsSKU

// datastores are created in the calling event ue_print
pickRows = idsPickingDetail.retrieve( asDono, asSku )
packRows = idsPacking.retrieve( asDono, asCarton )

// if the picking list contains a quantity less than the level 2 inventory quantity then
// the cartond is partial

// If the packing list contains more than one sku for the carton, it's mixed.

lbpartial = false
lbmixed = false

if packRows > 0 then
	max = idsPacking.rowcount()
	for index = 1 to max
		lsSku = idsPacking.object.sku[ index ]
		SupplierCode = idsPacking.object.supp_code[ index ]
		pickRows = idsPickingDetail.retrieve( asDono, lsSku )
		if pickRows > 0 then
			itemRow = idsItemMaster.retrieve( gs_project, lsSku, SupplierCode )
			Level2Qty = idsItemMaster.Object.qty_2[ itemRow ]
			pickQty = dec( idsPickingDetail.object.sumqty[1] )
			if pickQty < level2Qty then lbpartial = true
		end if	
		if getSKUCount( lsSku ) > 1 then
			lbmixed = true
		end if
	next
end if
	
// If the picking list is partial and mixed then its both
if lbpartial then returnValue = partial
if lbmixed then returnValue = mixed
if lbpartial and lbmixed then returnValue = Both

return returnValue


end function

public function long getskucount (string assku);// integer = getSKUCount( string asSKU )

string sBegin = "sku = ~'"
string FilterFor
Long returnValue

filterFor = sBegin + asSKU + "~'"

idsPacking.setfilter( filterFor )
idsPacking.filter()

returnValue = idsPacking.rowcount()

idsPacking.setfilter( "" )
idsPacking.filter()

return returnValue

end function

on w_linksys_shipping_labels.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_label=create dw_label
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
this.cb_carton=create cb_carton
this.cb_partial=create cb_partial
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_clear
this.Control[iCurrent+5]=this.cb_carton
this.Control[iCurrent+6]=this.cb_partial
end on

on w_linksys_shipping_labels.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_selectall)
destroy(this.cb_clear)
destroy(this.cb_carton)
destroy(this.cb_partial)
end on

event ue_postopen;call super::ue_postopen;

invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

cb_print.Enabled = False
//cb_carton.enabled = false
cb_partial.enabled = false

//We can only print based on DO_NO - User must have valid order open to pass DO_NO in from w_DO
If isValid(w_do) Then
	if w_do.idw_main.RowCOunt() > 0 Then
		isDoNo = w_do.idw_main.GetItemString(1,'do_no')
		isCustNo = w_do.idw_main.GetItemString(1,'cust_code')
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


cb_print.Enabled = False

If isdono > '' Then
	
	String ls_label, ls_type

	//User_Field1 is used to define which label to use. 
	
	SELECT USER_FIELD3 INTO :ls_label
		FROM Customer
		WHERE CUST_CODE = :isCustNo AND
				PROJECT_ID = :gs_project USING SQLCA;

	CHOOSE CASE upper(trim(ls_label))
					
	CASE 'CUST1'
		ls_type = "OFFICE"
	CASE ELSE
		ls_type = "GENERIC"
	END CHOOSE

	if ls_type = "GENERIC" then
		
		dw_label.dataobject = "d_linksys_uccs_ship_gen"
		dw_label.SetTransObject(SQLCA)
		
	end if
	


	dw_label.Retrieve(gs_project,isdono)
End If

If dw_label.RowCount() > 0 Then
Else
	Messagebox('Labels','Order Not found!')
	Return
End If

lsDoNo = dw_label.GetItemString(1,'delivery_Master_DO_NO')

//Default the Label Format and Starting Carton Number
llRowCount = dw_label.RowCount()

//cb_print.Enabled = True

// 12/03 - PCONKL - WE need the Project level UCCS Company prefix and the Warehouse level prefix
Select ucc_Company_Prefix into :isuccscompanyprefix
FRom Project
Where Project_ID = :gs_Project;

Select ucc_location_Prefix into :isuccswhprefix
From Warehouse
Where wh_Code = (select wh_Code from Delivery_MASter where Project_ID = :gs_Project and do_no = :isdono);


end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','Y')
Next

dw_label.SetRedraw(True)

cb_print.Enabled = True
//cb_carton.Enabled = True
cb_partial.Enabled = True
end event

event ue_unselectall;call super::ue_unselectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','N')
Next

dw_label.SetRedraw(True)

cb_print.Enabled = False
//cb_carton.Enabled = False
cb_partial.Enabled = False

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_linksys_shipping_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_linksys_shipping_labels
integer x = 2779
integer y = 24
integer height = 80
boolean default = false
end type

type cb_print from commandbutton within w_linksys_shipping_labels
integer x = 777
integer y = 24
integer width = 585
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print UPC Labels"
boolean default = true
end type

event clicked;parent.Trigger Event ue_Print("FULL")


end event

type dw_label from u_dw_ancestor within w_linksys_shipping_labels
integer x = 9
integer y = 136
integer width = 3127
integer height = 1456
boolean bringtotop = true
string dataobject = "d_linksys_uccs_ship"
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
If upper(dwo.Name) = 'C_PRINT_IND' and data = 'Y' Then
	cb_print.Enabled = True
//	cb_carton.enabled = true
	cb_partial.enabled = true
		
END IF
end event

type cb_selectall from commandbutton within w_linksys_shipping_labels
integer x = 32
integer y = 24
integer width = 338
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

type cb_clear from commandbutton within w_linksys_shipping_labels
integer x = 393
integer y = 24
integer width = 338
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

type cb_carton from commandbutton within w_linksys_shipping_labels
integer x = 1408
integer y = 24
integer width = 613
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print Carton Labels"
end type

event clicked;
parent.Trigger Event ue_Print("SHIP")


//Parent.TriggerEvent('ue_print_dotmatrix')


end event

type cb_partial from commandbutton within w_linksys_shipping_labels
integer x = 2066
integer y = 24
integer width = 585
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print Partial Label"
end type

event clicked;
parent.Trigger Event ue_Print("PARTIAL")

end event

