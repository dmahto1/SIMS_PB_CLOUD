HA$PBExportHeader$w_friedrich_sscc_labels.srw
$PBExportComments$Print Generic UCCS Shipping labels
forward
global type w_friedrich_sscc_labels from w_main_ancestor
end type
type cb_label_print from commandbutton within w_friedrich_sscc_labels
end type
type dw_label from u_dw_ancestor within w_friedrich_sscc_labels
end type
type cb_label_selectall from commandbutton within w_friedrich_sscc_labels
end type
type cb_label_clear from commandbutton within w_friedrich_sscc_labels
end type
type cbx_part_labels from checkbox within w_friedrich_sscc_labels
end type
type cb_print_carton from commandbutton within w_friedrich_sscc_labels
end type
end forward

global type w_friedrich_sscc_labels from w_main_ancestor
integer width = 3191
integer height = 1788
string title = "Shipping Labels"
event ue_print ( )
event ue_print_carton ( )
cb_label_print cb_label_print
dw_label dw_label
cb_label_selectall cb_label_selectall
cb_label_clear cb_label_clear
cbx_part_labels cbx_part_labels
cb_print_carton cb_print_carton
end type
global w_friedrich_sscc_labels w_friedrich_sscc_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels

Datastore idw_content_label

String	isUCCSCompanyPrefix, isUCCSWHPrefix

String	isDONO

integer ii_total_qty_cartons, ilCartonCount
end variables

forward prototypes
public function string uf_friedrich_get_scc (string ascartonno, string asdono)
end prototypes

event ue_print();Str_Parms	lstrparms

Long	llPackCopies, llCopyCount, llRowCount, llRowPos, ll_rtn, llLabelCount, llLabelOf
Long ll_rowcount,ll_Findrow,ll_Nextrow,ll_clearrow,ll_startPos,ll_sumQty,ll_carton_count
Any	lsAny
String	lsCityStateZip, lsSKU, ls_format, ls_carton_no,	lsDONO,  ls_CustName,ls_find
Boolean	lb_dropship

datastore  lds_st
n_warehouse l_nwarehouse 
n_cst_common_tables ln_common_tables

Dw_Label.AcceptText()

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

//TAM 2013/12/02 Added checkbox to print out customer specific part labels
If This.cbx_part_labels.checked = True then
	// If Ship to name contains Grainger then print the Grainger Part Label
	If  Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'GRAINGER' ) > 0 then
		lstrparms.String_Arg[60] = 'GRAINGER' 
	ElseIf Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'JOHNSTONE' ) > 0 then
		lstrparms.String_Arg[60] = 'JOHNSTONE' 
	ElseIf Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'BLUESTEM' ) > 0 then //10-Sep-2014 :Madhu- Added for BLUESTEM Label
		lstrparms.String_Arg[60] ='BLUESTEM'
	ElseIf Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')),'BED') > 0 then //27-Apr-2015 :Madhu- Added for BED BATH& BEYOND Label
		lstrparms.String_Arg[60]='BEDBATH'
	Else
		MessageBox('Labels',"part labels are not set up for this Customer!")
		Return
	End if
End If
	
OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then Return 

// For box X of Y - "Y" the total number of copies requests.  
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	IF dw_label.object.c_print_ind[llRowPos] = 'Y' THEN 
		llLabelCount = llLabelCount + dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/	
	End If 	
Next

lsDoNo = dw_label.GetITemString(1,'delivery_Master_do_no')
ls_CustName = dw_label.GetItemString(1,'delivery_master_cust_name') //10-Sep-2014 :Madhu- Added for BLUESTEM Label

// Determine if this a Grainger Drop Ship
// Drop ships have Sold to address Containing the string "GRAINGER"  and the Ship To Address does not have "GRAINGER"

lb_dropship =False  //Set to false

// Get Sold To Addesss
lds_st =Create Datastore
lds_st.Dataobject='d_do_address_alt'
lds_st.SetTransObject(SQLCA)
lds_st.Retrieve(lsdono, 'ST')
llRowCount = lds_st.RowCount()
If llRowCount > 0 Then // Compare Sold To to Ship To names
	If  Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'GRAINGER' ) =  0 and  Pos(upper(lds_st.getItemString(1,'Name')), 'GRAINGER' ) > 0 then
		lb_dropship = True
	End If
End If

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]

	Lstrparms.String_arg[38] =	dw_label.GetITemString(1,'delivery_Master_DO_NO')  // do_no arg for passing n_labels
	
//Ship From
	// Remove Menlos name on Dropships(Ship_From Name)
	If lb_dropship = True then 
		Lstrparms.String_arg[2] = lds_st.getItemString(1,'Name') 
	Else	
		Lstrparms.String_arg[2] = dw_label.GetItemString(llRowPos,'warehouse_wh_name')
	End If
	Lstrparms.String_arg[3] = dw_label.GetItemString(llRowPos,'warehouse_address_1')
	Lstrparms.String_arg[4] = dw_label.GetItemString(llRowPos,'warehouse_address_2')
	Lstrparms.String_arg[5] = dw_label.GetItemString(llRowPos,'warehouse_address_3')
	Lstrparms.String_arg[6] = dw_label.GetItemString(llRowPos,'Warehouse_address_4')

	//Compute FROM City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_city')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'warehouse_city') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_state')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_state') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_zip') + ' '
	Lstrparms.String_arg[7] = lsCityStateZip

//Ship To
	Lstrparms.String_arg[12] = dw_label.GetItemString(llRowPos,'delivery_master_Cust_name')
	Lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'delivery_master_address_1')
	Lstrparms.String_arg[14] = dw_label.GetItemString(llRowPos,'delivery_master_address_2')
	Lstrparms.String_arg[15] = dw_label.GetItemString(llRowPos,'delivery_master_address_3')
	Lstrparms.String_arg[16] = dw_label.GetItemString(llRowPos,'delivery_master_address_4')
	Lstrparms.String_arg[33] = dw_label.GetItemString(llRowPos,'delivery_master_Zip') /* 12/03 - PCONKL - for UCCS Ship to Zip */
			
	//Compute TO City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_City')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'delivery_master_City') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_State')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_State') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_Zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_Zip') + ' '
	Lstrparms.String_arg[17] = lsCityStateZip
		// sscc carton number
	Lstrparms.String_arg[48] = uf_friedrich_get_scc( dw_label.GetItemString(llRowPos,'delivery_packing_carton_no'), lsDoNo)
	
	Lstrparms.String_arg[10] = dw_label.GetItemString(llRowPos,'awb_bol_no') /* PO NBR*/

// TAM 2013/11/22 If Dropship then Print the DropShipPO(do_address_table) number/else print the Customer code
	If lb_dropship = True then 
		Lstrparms.String_arg[11] = lds_st.getItemString(1,'Alt_Cust_Code') 
	Else	
		Lstrparms.String_arg[11] = dw_label.GetItemString(llRowPos,'delivery_master_cust_order_no') /* PO NBR*/
	End If

	Lstrparms.String_arg[23] = dw_label.GetItemString(llRowPos,'delivery_master_invoice_no') /* Order nbr*/
	Lstrparms.String_arg[24] = dw_label.GetItemString(llRowPos,'delivery_master_carrier') /* Order nbr*/
	Lstrparms.String_arg[26] = dw_label.GetItemString(llRowPos,'carrier_pro_no') /*User_Field7 Pro Jxlim 04/02/2014 Replaced with Carrier_Pro_No name field*/
	// TODO - If more than one SKU the print "MIXED"	
	Lstrparms.String_arg[20] = dw_label.GetItemString(llRowPos,'delivery_packing_sku') /* Sku*/
	Lstrparms.String_arg[21] = dw_label.GetItemString(llRowPos,'alternate_sku') /*ALternate Sku*/
	Lstrparms.String_arg[62] = String(dw_label.GetItemNumber(llRowPos,'Quantity'))
	
// 12/03 - PCONKL - We need to pass the UCCS Prefix (Location + Company)
//lstrparms.String_arg[35] = isuccswhprefix + isuccscompanyprefix	
	lstrparms.String_arg[35] = isuccscompanyprefix

	//10-Sep-2014 :Madhu- Added for BLUESTEM Label - START
	ll_startPos=36 //start from 36th position
	ll_sumQty =0
	ll_carton_count =0
	
	IF ls_Custname ='BLUESTEM' Then
		ls_Find ="delivery_packing_carton_no ='" +ls_carton_no+"'"

		ll_Findrow = dw_label.Find( ls_Find, 0, dw_label.rowcount()) //find row of carton no
		DO WHILE ll_Findrow > 0
			llRowPos =ll_Findrow //set Findrow value to RowPos (since, both are same)
			lstrparms.String_Arg[ll_startPos] = dw_label.GetItemString(llRowPos,'delivery_packing_sku')
			lstrparms.String_arg[ll_startPos+1] =String(dw_label.GetItemNumber(llRowPos,'Quantity'))
			ll_sumQty += dw_label.GetItemNumber(llRowPos,'Quantity') // do sum of qty of same carton no records
			
			ll_Findrow = dw_label.find( ls_Find,ll_Findrow +1, dw_label.rowcount()+1) //get next occurance same carton no.
			
			IF ll_Findrow > 1 THEN //Increment ll_startPos value by 2 and set print_Ind to N for same occurances
				ll_startPos=ll_startPos+2
				dw_label.SetITem(llRowPos,'c_print_ind','N')
				lstrparms.String_arg[59] ='MIXED SKUS '
			END IF
			ll_carton_count++
		LOOP

		lstrparms.String_arg[58] =String(ll_sumQty) //set Total qty of each carton
		IF ll_startPos < 38 THEN lstrparms.String_arg[38] ="" //Override 38th position value for BLUESTEM
		IF ll_startPos < 48 THEN lstrparms.String_arg[48] ="" //Override 48th position value for BLUESTEM
		
		IF ll_carton_count > 10 THEN
			MessageBox('Labels','Label is not setup to print more than 10 parts per carton # ' + ls_carton_no)
			return
		END IF
		
	END IF
	//10-Sep-2014 :Madhu- Added for BLUESTEM Label - END
	
	//27-Apr-2015 :Madhu- Added for BED BATH & BEYOND Label- START
	IF  Pos(ls_Custname,'BED') >0 THEN
		lstrparms.String_Arg[25] = left(dw_label.GetItemString(llRowPos,'shipping_instructions'),3) //First 3 chars of Shipping Instructions
		lstrparms.String_Arg[18] = dw_label.GetItemString(llRowPos,'consolidation_no') //B/L value
		
		IF Pos(ls_CustName,"#") > 0 THEN lstrparms.String_Arg[19] = Mid(ls_CustName,Pos(ls_CustName,"#")+1 ,len(ls_CustName)) //extract store no (1234) from Customer Name:- Bed Bath and Beyond #1234
		lstrparms.String_arg[24] = left(dw_label.GetItemString(llRowPos,'delivery_master_carrier'),4)  //Scac (First 4 chars)
		lstrparms.String_Arg[28] = dw_label.GetItemString(llRowPos,'description')

		//If same carton has multiple SKUS, put description as "Pick and Pack" else Item Master description.
		ls_Find ="delivery_packing_carton_no ='" +ls_carton_no+"'"

		ll_Findrow = dw_label.Find( ls_Find, 0, dw_label.rowcount()) //find row of carton no
		
		DO WHILE ll_Findrow > 0
			llRowPos =ll_Findrow //set Findrow value to RowPos (since, both are same)
			lstrparms.String_Arg[ll_startPos] = dw_label.GetItemString(llRowPos,'delivery_packing_sku')
			lstrparms.String_arg[ll_startPos+1] =String(dw_label.GetItemNumber(llRowPos,'Quantity'))
			ll_sumQty += dw_label.GetItemNumber(llRowPos,'Quantity') // do sum of qty of same carton no records
			
			ll_Findrow = dw_label.find( ls_Find,ll_Findrow +1, dw_label.rowcount()+1) //get next occurance same carton no.
			
			IF ll_Findrow > 1 THEN //Increment ll_startPos value by 2 and set print_Ind to N for same occurances
				ll_startPos=ll_startPos+2
				dw_label.SetITem(llRowPos,'c_print_ind','N')
				lstrparms.String_arg[28] ='Pick and Pack'
				lstrparms.String_arg[21] ='' //make UPC as blank
			END IF
			ll_carton_count++
		LOOP

		lstrparms.String_arg[58] =String(ll_sumQty) //set Total qty of each carton
		
	END IF
	//27-Apr-2015 :Madhu- Added for BED BATH & BEYOND Label- END

	//Use the number of copies from the setup window to increment the X of Y here instead of in the label function
	llPackCopies = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
	For llCopyCOunt = 1 to llPackCopies // For number of Copies

		llLabelof ++  //Increment the "X"
	
		lstrparms.String_Arg[29] = String(llLabelof) +" of  " + String(llLabelCount)

		lsAny=lstrparms		

		invo_labels.uf_friedrich_ucc_128_zebra_ship(lsAny)
		
		//10-Sep-2014 :Madhu- Added for BLUESTEM -START
		//clear the parms from lstrparms for BLUESTEM to store next carton values else it'll append
		IF ls_Custname ='BLUESTEM' THEN
			For  ll_clearrow =36 to 59
				lstrparms.String_Arg[ll_clearrow] =""
			Next
		END IF

		//10-Sep-2014 :Madhu- Added for BLUESTEM -END
		lsAny=lstrparms		
	
	Next //Next Copy					
	dw_label.SetITem(llRowPos,'c_print_ind','N')	 
Next /*detail row to Print*/

end event

event ue_print_carton();//3-June-2015 :Madhu- Added to print carton labels.

Str_Parms	lstrparms

Long	llPackCopies, llCopyCount, llRowCount, llRowPos, ll_rtn, llLabelCount, llLabelOf,ll_carton_off
Long ll_rowcount,ll_Findrow,ll_Nextrow,ll_clearrow,ll_startPos,ll_sumQty,ll_carton_count
Any	lsAny
String	lsCityStateZip, lsSKU, ls_format, ls_carton_no,	lsDONO,  ls_CustName,ls_find,lsCartonNo
Boolean	lb_dropship

datastore  lds_st
n_warehouse l_nwarehouse 
n_cst_common_tables ln_common_tables

Dw_Label.AcceptText()

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

//TAM 2013/12/02 Added checkbox to print out customer specific part labels
If This.cbx_part_labels.checked = True then
	// If Ship to name contains Grainger then print the Grainger Part Label
	If  Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'GRAINGER' ) > 0 then
		lstrparms.String_Arg[60] = 'GRAINGER' 
	ElseIf Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'JOHNSTONE' ) > 0 then
		lstrparms.String_Arg[60] = 'JOHNSTONE' 
	ElseIf Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'BLUESTEM' ) > 0 then //10-Sep-2014 :Madhu- Added for BLUESTEM Label
		lstrparms.String_Arg[60] ='BLUESTEM'
	ElseIf Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')),'BED') > 0 then //27-Apr-2015 :Madhu- Added for BED BATH& BEYOND Label
		lstrparms.String_Arg[60]='BEDBATH'
	Else
		MessageBox('Labels',"part labels are not set up for this Customer!")
		Return
	End if
End If
	
OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then Return 

// For box X of Y - "Y" the total number of copies requests.  
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	IF dw_label.object.c_print_ind[llRowPos] = 'Y' THEN 
		llLabelCount = llLabelCount + dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/	
	End If 	
Next

lsDoNo = dw_label.GetITemString(1,'delivery_Master_do_no')
ls_CustName = dw_label.GetItemString(1,'delivery_master_cust_name') //10-Sep-2014 :Madhu- Added for BLUESTEM Label

// Determine if this a Grainger Drop Ship
// Drop ships have Sold to address Containing the string "GRAINGER"  and the Ship To Address does not have "GRAINGER"

lb_dropship =False  //Set to false

// Get Sold To Addesss
lds_st =Create Datastore
lds_st.Dataobject='d_do_address_alt'
lds_st.SetTransObject(SQLCA)
lds_st.Retrieve(lsdono, 'ST')
llRowCount = lds_st.RowCount()
If llRowCount > 0 Then // Compare Sold To to Ship To names
	If  Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'GRAINGER' ) =  0 and  Pos(upper(lds_st.getItemString(1,'Name')), 'GRAINGER' ) > 0 then
		lb_dropship = True
	End If
End If

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]

	Lstrparms.String_arg[38] =	dw_label.GetITemString(1,'delivery_Master_DO_NO')  // do_no arg for passing n_labels
	
//Ship From
	// Remove Menlos name on Dropships(Ship_From Name)
	If lb_dropship = True then 
		Lstrparms.String_arg[2] = lds_st.getItemString(1,'Name') 
	Else	
		Lstrparms.String_arg[2] = dw_label.GetItemString(llRowPos,'warehouse_wh_name')
	End If
	Lstrparms.String_arg[3] = dw_label.GetItemString(llRowPos,'warehouse_address_1')
	Lstrparms.String_arg[4] = dw_label.GetItemString(llRowPos,'warehouse_address_2')
	Lstrparms.String_arg[5] = dw_label.GetItemString(llRowPos,'warehouse_address_3')
	Lstrparms.String_arg[6] = dw_label.GetItemString(llRowPos,'Warehouse_address_4')

	//Compute FROM City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_city')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'warehouse_city') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_state')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_state') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_zip') + ' '
	Lstrparms.String_arg[7] = lsCityStateZip

//Ship To
	Lstrparms.String_arg[12] = dw_label.GetItemString(llRowPos,'delivery_master_Cust_name')
	Lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'delivery_master_address_1')
	Lstrparms.String_arg[14] = dw_label.GetItemString(llRowPos,'delivery_master_address_2')
	Lstrparms.String_arg[15] = dw_label.GetItemString(llRowPos,'delivery_master_address_3')
	Lstrparms.String_arg[16] = dw_label.GetItemString(llRowPos,'delivery_master_address_4')
	Lstrparms.String_arg[33] = dw_label.GetItemString(llRowPos,'delivery_master_Zip') /* 12/03 - PCONKL - for UCCS Ship to Zip */
			
	//Compute TO City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_City')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'delivery_master_City') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_State')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_State') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_Zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_Zip') + ' '
	Lstrparms.String_arg[17] = lsCityStateZip

	
	Lstrparms.String_arg[10] = dw_label.GetItemString(llRowPos,'awb_bol_no') /* PO NBR*/

// TAM 2013/11/22 If Dropship then Print the DropShipPO(do_address_table) number/else print the Customer code
	If lb_dropship = True then 
		Lstrparms.String_arg[11] = lds_st.getItemString(1,'Alt_Cust_Code') 
	Else	
		Lstrparms.String_arg[11] = dw_label.GetItemString(llRowPos,'delivery_master_cust_order_no') /* PO NBR*/
	End If

	Lstrparms.String_arg[23] = dw_label.GetItemString(llRowPos,'delivery_master_invoice_no') /* Order nbr*/
	Lstrparms.String_arg[24] = dw_label.GetItemString(llRowPos,'delivery_master_carrier') /* Order nbr*/
	Lstrparms.String_arg[26] = dw_label.GetItemString(llRowPos,'carrier_pro_no') /*User_Field7 Pro Jxlim 04/02/2014 Replaced with Carrier_Pro_No name field*/
	// TODO - If more than one SKU the print "MIXED"	
	Lstrparms.String_arg[20] = dw_label.GetItemString(llRowPos,'delivery_packing_sku') /* Sku*/
	Lstrparms.String_arg[21] = dw_label.GetItemString(llRowPos,'alternate_sku') /*ALternate Sku*/
	Lstrparms.String_arg[62] = String(dw_label.GetItemNumber(llRowPos,'Quantity'))
	
// 12/03 - PCONKL - We need to pass the UCCS Prefix (Location + Company)
//lstrparms.String_arg[35] = isuccswhprefix + isuccscompanyprefix	
	lstrparms.String_arg[35] = isuccscompanyprefix

	//10-Sep-2014 :Madhu- Added for BLUESTEM Label - START
	ll_startPos=36 //start from 36th position
	ll_sumQty =0
	ll_carton_count =0
	
	IF ls_Custname ='BLUESTEM' Then
		ls_Find ="delivery_packing_carton_no ='" +ls_carton_no+"'"

		ll_Findrow = dw_label.Find( ls_Find, 0, dw_label.rowcount()) //find row of carton no
		DO WHILE ll_Findrow > 0
			llRowPos =ll_Findrow //set Findrow value to RowPos (since, both are same)
			lstrparms.String_Arg[ll_startPos] = dw_label.GetItemString(llRowPos,'delivery_packing_sku')
			lstrparms.String_arg[ll_startPos+1] =String(dw_label.GetItemNumber(llRowPos,'Quantity'))
			ll_sumQty += dw_label.GetItemNumber(llRowPos,'Quantity') // do sum of qty of same carton no records
			
			ll_Findrow = dw_label.find( ls_Find,ll_Findrow +1, dw_label.rowcount()+1) //get next occurance same carton no.
			
			IF ll_Findrow > 1 THEN //Increment ll_startPos value by 2 and set print_Ind to N for same occurances
				ll_startPos=ll_startPos+2
				dw_label.SetITem(llRowPos,'c_print_ind','N')
				lstrparms.String_arg[59] ='MIXED SKUS '
			END IF
			ll_carton_count++
		LOOP

		lstrparms.String_arg[58] =String(ll_sumQty) //set Total qty of each carton
		IF ll_startPos < 38 THEN lstrparms.String_arg[38] ="" //Override 38th position value for BLUESTEM
		IF ll_startPos < 48 THEN lstrparms.String_arg[48] ="" //Override 48th position value for BLUESTEM
		
		IF ll_carton_count > 10 THEN
			MessageBox('Labels','Label is not setup to print more than 10 parts per carton # ' + ls_carton_no)
			return
		END IF
		
	END IF
	//10-Sep-2014 :Madhu- Added for BLUESTEM Label - END
	
	//27-Apr-2015 :Madhu- Added for BED BATH & BEYOND Label- START
	IF  Pos(ls_Custname,'BED') >0 THEN
		lstrparms.String_Arg[25] = left(dw_label.GetItemString(llRowPos,'shipping_instructions'),3) //First 3 chars of Shipping Instructions
		lstrparms.String_Arg[18] = dw_label.GetItemString(llRowPos,'consolidation_no') //B/L value
		
		IF Pos(ls_CustName,"#") > 0 THEN lstrparms.String_Arg[19] = Mid(ls_CustName,Pos(ls_CustName,"#")+1 ,len(ls_CustName)) //extract store no (1234) from Customer Name:- Bed Bath and Beyond #1234
		lstrparms.String_arg[24] = left(dw_label.GetItemString(llRowPos,'delivery_master_carrier'),4)  //Scac (First 4 chars)
		lstrparms.String_Arg[28] = dw_label.GetItemString(llRowPos,'description')

		//If same carton has multiple SKUS, put description as "Pick and Pack" else Item Master description.
		ls_Find ="delivery_packing_carton_no ='" +ls_carton_no+"'"

		ll_Findrow = dw_label.Find( ls_Find, 0, dw_label.rowcount()) //find row of carton no
		
		DO WHILE ll_Findrow > 0
			llRowPos =ll_Findrow //set Findrow value to RowPos (since, both are same)
			lstrparms.String_Arg[ll_startPos] = dw_label.GetItemString(llRowPos,'delivery_packing_sku')
			lstrparms.String_arg[ll_startPos+1] =String(dw_label.GetItemNumber(llRowPos,'Quantity'))
			ll_sumQty += dw_label.GetItemNumber(llRowPos,'Quantity') // do sum of qty of same carton no records
			
			ll_Findrow = dw_label.find( ls_Find,ll_Findrow +1, dw_label.rowcount()+1) //get next occurance same carton no.
			
			IF ll_Findrow > 1 THEN //Increment ll_startPos value by 2 and set print_Ind to N for same occurances
				ll_startPos=ll_startPos+2
				dw_label.SetITem(llRowPos,'c_print_ind','N')
				lstrparms.String_arg[28] ='Pick and Pack'
				lstrparms.String_arg[21] ='' //make UPC as blank
			END IF
			ll_carton_count++
		LOOP

		lstrparms.String_arg[58] =String(ll_sumQty) //set Total qty of each carton
		
	END IF
	//27-Apr-2015 :Madhu- Added for BED BATH & BEYOND Label- END

//Print carton label X of Y
For ll_carton_off = 1 to ll_sumQty /*each detail row */
		
			// sscc carton number
			lsCartonNo = trim(dw_label.GetItemString(llRowPos,'delivery_packing_carton_no')) + String(ll_carton_off)
			lstrparms.String_arg[48] = uf_friedrich_get_scc( lsCartonNo, lsDoNo)
			
			//Carton X of Y
			lstrparms.String_Arg[34] = String(ll_carton_off) +"  OF  " + String(ll_sumQty)
			invo_labels.setLabelSequence( llRowPos )
			lsAny=lstrparms		
			invo_labels.setparms( lsAny )
			invo_labels.uf_friedrich_ucc_128_zebra_ship(lsAny)
Next // Carton Label to print
		
	dw_label.SetITem(llRowPos,'c_print_ind','N')	 
Next /*detail row to Print*/

end event

public function string uf_friedrich_get_scc (string ascartonno, string asdono);String lsCartonNo ,lsUCCS,lsDONO,lsOutString,lsDelimitChar
Long liCartonNo,liCheck

lsCartonNo = asCartonNo
lsDONO = asDono
lsDelimitChar = char(9)

//                                                lsCartonNo = idsdoPack.GetItemString(llRowPos, 'Carton_No')

IF IsNull(isUCCSCompanyPrefix) or isUCCSCompanyPrefix = '' Then
	SELECT Project.UCC_Company_Prefix 
	INTO :isUCCSCompanyPrefix 
	FROM Project 
	WHERE Project_ID = :gs_project USING SQLCA;
	
End If

IF IsNull(isUCCSCompanyPrefix) Then isUCCSCompanyPrefix = ''

																
If IsNull(lsCartonNo) then lsCartonNo = ''
If lsCartonNo <> '' Then
	
	/* per Ariens, The base is $$HEX1$$1820$$ENDHEX$$0000751058000000000N$$HEX2$$18202000$$ENDHEX$$where N is the check digit.
     lsUCCS must be 17 digits long....
    using 00751058 for Company code, preceding that by '00' so need 10 digits for serial of carton
    using last 5 of do_no and then carton numbers, formatted to 4 digits
    */
	 
    //the string function to pad 0's for the carton number doesn't work (returning only '0000')
    liCartonNo = integer(lsCartonNo)
   lsCartonNo = right(lsDONO, 5) + string(liCartonNo, '00000') //23-Jun-2015 :Madhu- Removed comments
   //lsCartonNo =string(liCartonNo, '0000000000') //23-Jun-2015 :Madhu- Commented
   lsUCCS =  trim((isUCCSCompanyPrefix +  lsCartonNo))
	
   //From BaseLine
   liCheck = f_calc_uccs_check_Digit(lsUCCS) 
   If liCheck >=0 Then
   		lsUCCS = "00" + lsUCCS + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
   Else
     	lsUCCS = "00" + String(lsUCCS, '00000000000000000000') + "0"
   End IF
   
	lsOutString += lsUCCS  + lsDelimitChar
	
end if

Return lsOutString
end function

on w_friedrich_sscc_labels.create
int iCurrent
call super::create
this.cb_label_print=create cb_label_print
this.dw_label=create dw_label
this.cb_label_selectall=create cb_label_selectall
this.cb_label_clear=create cb_label_clear
this.cbx_part_labels=create cbx_part_labels
this.cb_print_carton=create cb_print_carton
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_label_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_label_selectall
this.Control[iCurrent+4]=this.cb_label_clear
this.Control[iCurrent+5]=this.cbx_part_labels
this.Control[iCurrent+6]=this.cb_print_carton
end on

on w_friedrich_sscc_labels.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_label_print)
destroy(this.dw_label)
destroy(this.cb_label_selectall)
destroy(this.cb_label_clear)
destroy(this.cbx_part_labels)
destroy(this.cb_print_carton)
end on

event ue_postopen;call super::ue_postopen;

invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

cb_label_print.Enabled = False
cbx_part_labels.checked = False

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

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_friedrich_sscc_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_friedrich_sscc_labels
integer x = 1874
integer y = 24
integer height = 80
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_label_print from commandbutton within w_friedrich_sscc_labels
integer x = 946
integer y = 24
integer width = 329
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

event clicked;//Jxlim 07/11/2013 NYX Print dw
Parent.TriggerEvent('ue_Print')
//Parent.TriggerEvent('ue_Print_ext')  
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_label from u_dw_ancestor within w_friedrich_sscc_labels
integer x = 9
integer y = 136
integer width = 3127
integer height = 1456
boolean bringtotop = true
string dataobject = "d_friedrich_uccs_ship"
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

type cb_label_selectall from commandbutton within w_friedrich_sscc_labels
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

event constructor;
g.of_check_label_button(this)
end event

type cb_label_clear from commandbutton within w_friedrich_sscc_labels
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

event constructor;
g.of_check_label_button(this)
end event

type cbx_part_labels from checkbox within w_friedrich_sscc_labels
integer x = 2373
integer y = 28
integer width = 649
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Print Part Labels"
boolean thirdstate = true
end type

type cb_print_carton from commandbutton within w_friedrich_sscc_labels
integer x = 1358
integer y = 24
integer width = 407
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print Carton"
end type

event clicked;Parent.Triggerevent( 'ue_print_carton')
end event

