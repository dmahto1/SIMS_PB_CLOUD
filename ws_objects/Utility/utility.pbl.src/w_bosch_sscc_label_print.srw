$PBExportHeader$w_bosch_sscc_label_print.srw
$PBExportComments$+ ANKI SSCC Carton Label
forward
global type w_bosch_sscc_label_print from w_main_ancestor
end type
type cb_print from commandbutton within w_bosch_sscc_label_print
end type
type cb_selectall from commandbutton within w_bosch_sscc_label_print
end type
type cb_clear from commandbutton within w_bosch_sscc_label_print
end type
type dw_label from u_dw_ancestor within w_bosch_sscc_label_print
end type
type cb_print_carton_labels from commandbutton within w_bosch_sscc_label_print
end type
end forward

global type w_bosch_sscc_label_print from w_main_ancestor
boolean visible = false
integer width = 3913
integer height = 1752
string title = "BOSCH SSCC Labels"
string menuname = ""
event ue_print ( )
event ue_print_carton ( )
cb_print cb_print
cb_selectall cb_selectall
cb_clear cb_clear
dw_label dw_label
cb_print_carton_labels cb_print_carton_labels
end type
global w_bosch_sscc_label_print w_bosch_sscc_label_print

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
n_3com_labels	invo_3com_labels
String	isUCCSCompanyPrefix, isUCCSWHPrefix

String isCustName,isAddress_1, isAddress_2 ,isAddress_3 ,isAddress_4 ,isCity ,isState ,isZip,isCountry
String isWHName, isWHAddress_1, isWHAddress_2 , isWHAddress_3 , isWHAddress_4 , isWHCity , isWHState , isWHZip

String	isOrigSql


String isOrderType
String isLabelName
String is_dono
end variables

forward prototypes
public subroutine uf_fromcustomer (string as_from)
public subroutine uf_towarehouse (string as_to)
public function string uf_getsscc (string asdono)
end prototypes

event ue_print();Str_Parms	lstrparms
n_labels	lu_labels

Long	llRowCount, llRowPos,llLabelcount,ll_carton_total,ll_Tot_Qty,ll_Qty
long ll_sumQty,ll_carton_count,ll_Findrow,ll_carton_off
String ls_wh_code,ls_custname,lsDoNo, lsCityStateZip
String  ls_Find,ls_carton_no,ls_pono,ls_prevpono,ls_nextpono,ls_pack_sscc_no,lsSupplier,ls_carton_num
Any	lsAny


n_warehouse l_nwarehouse 
n_cst_common_tables ln_common_tables
lu_labels 		= Create n_labels

Dw_Label.AcceptText()

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

lstrparms.String_Arg[60] = dw_label.GetItemString(1,'Cust_Name') //store customer name

////TAM 08/15 - If Customer is "TOYS R US" and Country is "US" or "CA" then print the Toys R US label otherwise print the "TOYS R US EU" lebel(New Label added)
//If Upper(dw_label.GetItemString(1,'Cust_Name')) = "TOYS R US" and  left(dw_label.GetItemString(1,'Country'),2) <> 'US'  Then
//	lstrparms.String_Arg[60] = 	"TOYS R US EU" 
//End If

OpenWithParm(w_label_print_options,lstrparms)
lstrparms = Message.Powerobjectparm
If lstrparms.cancelled Then Return

//Get total no copies to be printed
llRowCount = dw_label.RowCount()
For llRowPos =1 to llRowCount 
	IF dw_label.object.c_print_ind[llRowPos] ='Y' Then
		llLabelcount = llLabelcount + dw_label.object.c_print_qty[llRowPos]
	END IF
Next

lsDoNo = dw_label.GetItemString(1,'Do_No')

//Get distinct carton count#



//Print each detail Row 
ll_Qty =1 
For llRowPos = 1 to llRowCount /*each detail row */
				lstrparms.string_arg[34] =String(ll_Qty) //qty_count
				lstrparms.string_arg[35] =String(llRowCount) //qty_total
				//lstrparms.String_arg[30] = f_get_sscc_number( gs_project, lsSupplier)// 02/21/2023
				lstrparms.String_arg[30]=dw_label.GetItemString(llRowPos,'pack_sscc_no')  // Dinesh - 03/27/2023- SIMS-151- BOSCH Label print
			
	IF dw_label.object.c_print_ind[llRowPos] = 'Y' THEN 

		ls_custname =dw_label.GetItemString(llRowPos,'cust_name')
		
		//Get Ship From Address - Warehouse Address
		ls_wh_code = dw_label.object.wh_code[ llRowPos] 
		
		If Len(ls_wh_code) > 0 then
			
			uf_FromCustomer(ls_wh_code) //Get warehouse address

			If isCustName = '' or IsNull(isCustName) then
				isCustName = ls_wh_code
			End if

			lstrparms.String_arg[2] = isCustName
			lstrparms.String_arg[3] = isAddress_1
			lstrparms.String_arg[4] = isAddress_2
			lstrparms.String_arg[5] = isAddress_3
			lstrparms.String_arg[6] = isAddress_4
			If Not isnull(isCity) Then lsCityStateZip = isCity + ', '
			If Not isnull(isState) Then lsCityStateZip += isState + ' '
			If Not isnull(isZip) Then lsCityStateZip += isZip + ' '
			//nxjain	09/16 Add Country Code Ship Form add
			If Not isnull(isCountry) Then lsCityStateZip += isCountry + ' '
			//end nxjain
			lstrparms.String_arg[7] = 	lsCityStateZip		
		End if				
		
		//Ship To Address
		lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'Cust_name')
		lstrparms.String_arg[14] = dw_label.GetItemString(llRowPos,'address_1')
		lstrparms.String_arg[15] = dw_label.GetItemString(llRowPos,'address_2')
		lstrparms.String_arg[16] = dw_label.GetItemString(llRowPos,'address_3')
		lstrparms.String_arg[17] = dw_label.GetItemString(llRowPos,'address_4')
		
		//Compute TO City,State & Zip
		lsCityStateZip = ''
		If Not isnull(dw_label.GetItemString(llRowPos,'City')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'City') + ', '
		If Not isnull(dw_label.GetItemString(llRowPos,'State')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'State') + ' '
		If Not isnull(dw_label.GetItemString(llRowPos,'Zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'Zip') + ' '
		//nxjain	09/16 Add Country Code in Ship to address
		If Not isnull(dw_label.GetItemString(llRowPos,'Country')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'Country') + ' '
		//End nxjain	
		lstrparms.String_arg[18] = lsCityStateZip
		
		//Required values		
		lstrparms.String_arg[10]  = dw_label.GetItemString(llRowPos,'awb_bol_no') //AWB BOL No
		lstrparms.String_arg[11]  = dw_label.GetItemString(llRowPos,'Carrier_Pro_No') //Carrier Pro No
		lstrparms.String_arg[20] = dw_label.GetItemString(llRowPos,'SKU') //SKU
		lstrparms.String_arg[21] = String(dw_label.GetItemNumber(llRowPos,'Part_UPC_Code')) //UPC Code
		lstrparms.String_arg[23] = dw_label.GetItemString(llRowPos,'Invoice_No') //Invoice No
		lstrparms.String_arg[24] = dw_label.GetItemString(llRowPos,'carrier') //Carrier Name
		lstrparms.String_arg[25] = dw_label.GetItemString(llRowPos,'Alternate_SKU') //Alternate SKU delivery detail - Dinesh - 07/21/2023- SIMS-168- BOSCH SSCC Label Costco
		lstrparms.String_arg[26] = dw_label.GetItemString(llRowPos,'user_field21')  //Alternate SKU delivery detail - Dinesh - 07/24/2023- SIMS-168- BOSCH SSCC Label Costco
		lstrparms.String_arg[33]=	dw_label.GetItemString(llRowPos,'Zip') //Add ShipTo Zip code
		lstrparms.String_Arg[36] = dw_label.GetItemString(llRowPos,'user_field15') //Location
		

		//Carton 1 of 1
		Lstrparms.String_arg[27] = String(llRowPos) //carton_count
		Lstrparms.String_arg[28] = String(llRowCount) //carton_total
		Lstrparms.Long_arg[1] = dw_label.GetItemNumber(llRowPos,'c_print_qty') //set DW no of copies

		lstrparms.String_arg[29] = lsDoNo //Do No
		//lstrparms.String_arg[32] = dw_label.GetItemString(llRowPos,'Alternate_SKU') // Dinesh - 07/24/2023- SIMS-168- SIMS - BOSCH COSTCO SSCC LABEL
		lstrparms.String_arg[22] = dw_label.GetItemString(1,'Cust_Order_No') 
		
		//lstrparms.string_arg[34] = dw_label.getitemString(llRowPos,"user_field1")  // Dinesh - 03/28/2023- SIMS-168- SIMS - BOSCH COSTCO SSCC LABEL

		//Generate SSCCNo
		
		//lstrparms.String_arg[30] = f_get_sscc_number( gs_project, lsSupplier)// 02/21/2023
		//lstrparms.String_arg[30] = dw_label.GetItemString(llRowPos,'pack_sscc_no')  // Dinesh - 02/08/2023- SIMS-107 - SIMS BOSCH SSCC Label
//		dw_label.SetItem(llRowPos, "pack_sscc_no", lstrparms.String_arg[30])
		
			//Do the sum (quantity) for same carton no records.
				//ls_Find = "Carton_No ='"+ dw_label.GetItemString(llRowPos,'Carton_No') + "'"
//				ll_Findrow =dw_label.Find(ls_Find,0,dw_label.rowcount( )) //find row of carton no
//				DO WHILE ll_findrow > 0
//					llRowPos =ll_Findrow //set Findrow value to RowPos, since both are same
//					ll_sumQty += dw_label.GetItemNumber(llRowPos,'Quantity') // do sum of qty of same carton no records
//					
//					ls_nextpono = dw_label.GetItemString(llRowPos,'Pick_Po_No')
//					
//					If ls_nextpono <> ls_prevpono THEN
//					//Get multiple PoNo from Label against duplicate carton no#
//					ls_pono += dw_label.GetItemString(llRowPos,'Pick_Po_No') + ', ' //Po No
//					END IF
//	
//					ls_prevpono =ls_nextpono
//					
//					ll_Findrow = dw_label.find(ls_find,ll_Findrow +1,dw_label.rowcount() +1)
//					IF ll_Findrow > 1 THEN
//						dw_label.SetItem(llRowPos,'c_print_ind','N')
//					END IF
//					ll_carton_count++
//				LOOP
//				
				// Dinesh - 02/27/2023
				//ll_Qty=1
//				ll_Tot_Qty = dw_label.GetItemNumber(llRowPos,'Quantity') 
//				if ll_Qty <= ll_Tot_Qty then
//					//lstrparms.String_arg[31] =String(ll_sumQty) //set Total qty of each carton
//					lstrparms.string_arg[34] =String(ll_Qty) //carton_count
//					lstrparms.string_arg[35] =String(ll_Tot_Qty) //distinct carton_total
//				end if
				//loop
		
				//IF duplicate carton is > 1 then set MIXED SKUS.
//				IF ll_carton_count > 1 THEN
//					lstrparms.String_arg[31] =String(ll_sumQty) //set Total qty of each carton
//					lstrparms.String_arg[32] ='MIXED SKUS'
//					ll_carton_off++
//				ELSE
//					lstrparms.String_arg[31] = String(ll_sumQty)
//					lstrparms.String_arg[32] = String(dw_label.GetItemNumber(llRowPos,'Part_UPC_Code'))
//					ll_carton_off++
//				END IF
				
				//Set PoNo
//TAM PO should be customer order number
//				lstrparms.String_arg[22] = Left(ls_pono, (len(ls_pono) - 2)) //By stripping off comma
	//	lstrparms.String_arg[22] =  dw_label.GetItemNumber(llRowPos,'alternate_sku')
				
		//Carton 1 of 1
	
		//lstrparms.string_arg[35] =String(ll_carton_total) //distinct carton_total
		
        //Dinesh - 10/20/2022 - Added New Fields- SIMS- 107 -SIMS BOSCH SSCC LABEL
		//If  Not IsNull(dw_label.GetItemString(llRowPos,'Cust_Code')) then lstrparms.String_Arg[37] = dw_label.GetItemString(llRowPos,'cust_code')
		//If  Not IsNull(dw_label.GetItemString(llRowPos,'user_field1')) then lstrparms.String_Arg[38] = dw_label.GetItemString(llRowPos,'user_field1') 
		
//		If  Not IsNull(dw_label.GetItemString(llRowPos,'user_field3')) then lstrparms.String_Arg[37] = dw_label.GetItemString(llRowPos,'user_field3') //Mfg Part No
//		If  Not IsNull(dw_label.GetItemString(llRowPos,'user_field4')) then lstrparms.String_Arg[38] = dw_label.GetItemString(llRowPos,'user_field4') //Stock Keeping No
		
		//If  Not IsNull(dw_label.GetItemString(llRowPos,'user_field1')) then 
		lstrparms.String_Arg[37] = dw_label.GetItemString(llRowPos,'user_field1') 
		//If  Not IsNull(dw_label.GetItemString(llRowPos,'cust_code')) then 
		lstrparms.String_Arg[38] = dw_label.GetItemString(llRowPos,'cust_code') //Stock Keeping No // Dinesh 10/25/2022- SIMS-107- SIMS BOSCH SSCC LABEL
		
		lu_labels.setLabelSequence( llRowPos )
		lsAny=lstrparms		
		lu_labels.setparms( lsAny )
		lu_Labels.uf_bosch_sscc_zebra(lsAny)

		//clear pono value
		ls_pono =''	
		
	//loop
	End if	 //End if for 'Y' to print
	ll_Qty++  // Dinesh - 02/27/2023- sims-107-SIMS BOSCH SSCC LABEL
//loop
	
	dw_label.SetItem(llRowPos,'c_print_ind','N')
Next /*detail row to Print*/		



end event

event ue_print_carton();//Str_Parms	lstrparms
//n_labels	lu_labels
//
//Long	llRowCount, llRowPos,llLabelcount,ll_carton_total
//long ll_sumQty,ll_carton_count,ll_Findrow,ll_carton_off
//String ls_wh_code,ls_custname,lsDoNo, lsCityStateZip
//String  ls_Find,ls_pono,ls_prevpono,ls_nextpono,lscartonno
//Any	lsAny
//
//
//n_warehouse l_nwarehouse 
//n_cst_common_tables ln_common_tables
//lu_labels 		= Create n_labels
//
//Dw_Label.AcceptText()
//
//If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
//	MessageBox('Labels',"at least one row must be selected for printing!")
//	Return
//End If
//
//lstrparms.String_Arg[60] = dw_label.GetItemString(1,'Cust_Name') //store customer name
////TAM 08/15 - If Customer is "TOYS R US" and Country is "US" or "CA" then print the Toys R US label otherwise print the "TOYS R US EU" lebel(New Label added)
//If Upper(dw_label.GetItemString(1,'Cust_Name')) = "TOYS R US" and  left(dw_label.GetItemString(1,'Country'),2) <> 'US'  Then
//	lstrparms.String_Arg[60] = 	"TOYS R US EU" 
//End If
//
//OpenWithParm(w_label_print_options,lstrparms)
//lstrparms = Message.Powerobjectparm
//If lstrparms.cancelled Then Return
//
////Get total no copies to be printed
//llRowCount = dw_label.RowCount()
//For llRowPos =1 to llRowCount 
//	IF dw_label.object.c_print_ind[llRowPos] ='Y' Then
//		llLabelcount = llLabelcount + dw_label.object.c_print_qty[llRowPos]
//	END IF
//Next
//
//lsDoNo = dw_label.GetItemString(1,'Do_No')
//
//
//
////Print each detail Row 
//For llRowPos = 1 to llRowCount /*each detail row */
//	IF dw_label.object.c_print_ind[llRowPos] = 'Y' THEN 
//
//		ll_sumQty =0
//		ll_carton_count =0
//
//	//Get Quantity
////TAM 2015/09 - Get the carton quantity from the entered value
////		ll_carton_total =  dw_label.GetItemNumber(llRowPos,'Quantity') ;
//		ll_carton_total =  dw_label.GetItemNumber(llRowPos,'c_print_carton_qty') ;
//
//		ls_custname =dw_label.GetItemString(llRowPos,'Cust_name')
//		
//		//Get Ship From Address - Warehouse Address
//		ls_wh_code = dw_label.object.wh_code[ llRowPos] 
//		
//		If Len(ls_wh_code) > 0 then
//			
//			uf_FromCustomer(ls_wh_code) //Get warehouse address
//
//			If isCustName = '' or IsNull(isCustName) then
//				isCustName = ls_wh_code
//			End if
//
//			lstrparms.String_arg[2] = isCustName
//			lstrparms.String_arg[3] = isAddress_1
//			lstrparms.String_arg[4] = isAddress_2
//			lstrparms.String_arg[5] = isAddress_3
//			lstrparms.String_arg[6] = isAddress_4
//			If Not isnull(isCity) Then lsCityStateZip = isCity + ', '
//			If Not isnull(isState) Then lsCityStateZip += isState + ' '
//			If Not isnull(isZip) Then lsCityStateZip += isZip + ' '
//			lstrparms.String_arg[7] = lsCityStateZip			
//		End if				
//		
//		//Ship To Address
//		lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'Cust_name')
//		lstrparms.String_arg[14] = dw_label.GetItemString(llRowPos,'address_1')
//		lstrparms.String_arg[15] = dw_label.GetItemString(llRowPos,'address_2')
//		lstrparms.String_arg[16] = dw_label.GetItemString(llRowPos,'address_3')
//		lstrparms.String_arg[17] = dw_label.GetItemString(llRowPos,'address_4')
//		
//		//Compute TO City,State & Zip
//		lsCityStateZip = ''
//		If Not isnull(dw_label.GetItemString(llRowPos,'City')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'City') + ', '
//		If Not isnull(dw_label.GetItemString(llRowPos,'State')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'State') + ' '
//		If Not isnull(dw_label.GetItemString(llRowPos,'Zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'Zip') + ' '
//		lstrparms.String_arg[18] = lsCityStateZip					
//		
//		//Required values		
//		lstrparms.String_arg[10]  = dw_label.GetItemString(llRowPos,'awb_bol_no') //AWB BOL No
//		lstrparms.String_arg[11]  = dw_label.GetItemString(llRowPos,'Carrier_Pro_No') //Carrier Pro No
//		lstrparms.String_arg[20] = dw_label.GetItemString(llRowPos,'SKU') //SKU
//// TAM 2015/07 Changed Part upc to Numeric and arg [22] to Cust_order_no
//		lstrparms.String_arg[21] = String(dw_label.GetItemNumber(llRowPos,'Part_UPC_Code')) //UPC Code
//		lstrparms.String_arg[22] = dw_label.GetItemString(1,'Cust_Order_No') 
////		lstrparms.String_arg[22] = dw_label.GetItemString(llRowPos,'Pick_Po_No') //PO_NO
//		lstrparms.String_arg[23] = dw_label.GetItemString(llRowPos,'Invoice_No') //Invoice No
//		lstrparms.String_arg[24] = dw_label.GetItemString(llRowPos,'carrier') //Carrier Name
////TAM 2015/09 - Get the carton quantity from the entered value
////		lstrparms.String_arg[25] = String(dw_label.GetItemNumber(llRowPos,'quantity')) //Qty
//		lstrparms.String_arg[25] = String(dw_label.GetItemNumber(llRowPos,'c_print_carton_qty')) //Qty
//		lstrparms.String_arg[26] = dw_label.GetItemString(llRowPos,'Carton_No') //Carton No
//		lstrparms.String_arg[29] = lsDoNo //Do No
////TAM 2015/09 - Get the carton quantity from the entered value
////		lstrparms.String_arg[31] = String(dw_label.GetItemNumber(llRowPos,'quantity')) //Qty
//		lstrparms.String_arg[31] = String(dw_label.GetItemNumber(llRowPos,'c_print_carton_qty')) //Qty
//		lstrparms.String_arg[32] = String(dw_label.GetItemNumber(llRowPos,'Part_UPC_Code'))
//		lstrparms.String_arg[33]=	dw_label.GetItemString(llRowPos,'Zip') //Add ShipTo Zip code
//		lstrparms.String_Arg[36] = dw_label.GetItemString(llRowPos,'user_field15') //Location
//		Lstrparms.Long_arg[1] = dw_label.GetItemNumber(llRowPos,'c_print_qty') //set DW no of copies
//
////TAM 08/15 - Added New Fields
//		If  Not IsNull(dw_label.GetItemString(llRowPos,'user_field3')) then lstrparms.String_Arg[37] = dw_label.GetItemString(llRowPos,'user_field3') //Mfg Part No
//		If  Not IsNull(dw_label.GetItemString(llRowPos,'user_field4')) then lstrparms.String_Arg[38] = dw_label.GetItemString(llRowPos,'user_field4') //Stock Keeping No
//		
////TAM 2015/09 - Get the carton count from the entered value
////		For ll_carton_off = 1 to dw_label.GetItemNumber(llRowPos,'quantity') /*each detail row */
//		For ll_carton_off = 1 to dw_label.GetItemNumber(llRowPos,'c_print_carton_copies') /*each detail row */
//		
//			//Generate SSCCNo
//			lsCartonNo = trim(dw_label.GetItemString(llRowPos,'Carton_No')) + String(ll_carton_off)
//			lstrparms.String_arg[30] = uf_getsscc( lsCartonNo, lsDoNo)
//		
//			//Carton X of Y
//			lstrparms.string_arg[34] =String(ll_carton_off) //carton_count
////TAM 2015/09 - Get the carton count from the entered value
////			lstrparms.string_arg[35] =String(dw_label.GetItemNumber(llRowPos,'quantity')) //distinct carton_total
//			lstrparms.string_arg[35] =String(dw_label.GetItemNumber(llRowPos,'c_print_carton_copies')) //distinct carton_total
//			
//			lu_labels.setLabelSequence( llRowPos )
//			lsAny=lstrparms		
//			lu_labels.setparms( lsAny )
//			//lu_Labels.uf_anki_ucc_128_zebra_carton_label( )
//			lu_Labels.uf_anki_uccs_zebra(lsAny)
//		Next // Carton Label to print
//
//	End if	 //End if for 'Y' to print
//	dw_label.SetItem(llRowPos,'c_print_ind','N')
//Next /*detail row to Print*/		
//
//
//
end event

public subroutine uf_fromcustomer (string as_from);SELECT  wh_name,Address_1,Address_2,Address_3,Address_4,City,State,Zip,Country 
INTO :isCustName, :isAddress_1 ,:isAddress_2,:isAddress_3 ,:isAddress_4 ,:isCity ,:isState ,:isZip, :isCountry
FROM Warehouse 
where  wh_Code = :as_From;

end subroutine

public subroutine uf_towarehouse (string as_to);SELECT   WH_Name ,Address_1,Address_2,Address_3,Address_4,City ,State ,Zip
INTO :isWHName, :isWHAddress_1 , :isWHAddress_2 , :isWHAddress_3 , :isWHAddress_4 , :isWHCity , :isWHState , :isWHZip		
FROM Warehouse 
where WH_Code = :as_to;


end subroutine

public function string uf_getsscc (string asdono);// 10/26/2022- Dinesh - SIMS-107- SIMS BOSCH SSCC LABEL
String lsCartonNo ,lsUCCS,lsDONO,lsUCCCompanyPrefix,lsOutString,lsDelimitChar
Long ldStartingssccnbr,liCheck


//lsCartonNo = as_ssccno
lsDONO = asDono
lsDelimitChar = char(9)


SELECT Project.UCC_Company_Prefix INTO :lsUCCCompanyPrefix FROM Project WHERE Project_ID = :gs_project USING SQLCA;

IF IsNull(lsUCCCompanyPrefix) Then lsUCCCompanyPrefix = ''
//IF IsNull(lsCartonNo) Then lsCartonNo = ''
//IF lsCartonNo <> '' Then
	/* per Ariens, The base is ‘0000751058000000000N‘ where N is the check digit.
	lsUCCS must be 17 digits long....
	using 00751058 for Company code, preceding that by '00' so need 9 digits for serial of carton
	using last 5 of do_no and then carton numbers, formatted to 4 digits
	*/
	//the string function to pad 0's for the carton number doesn't work (returning only '0000')
	//TAM - 2015/07/22  -  Changed integer to long
//	liCartonNo = intger(lsCartonNo)
	//liCartonNo = long(Right(lsCartonNo,9)) //18-Aug-2015 :Madhu- As discussed with Trey consider Right 9 chars of Carton No.
	//TAM - 2015/07/23  -  Just use 9 CHaracter Carton number
//	lsCartonNo = right(lsDONO, 5) + string(liCartonNo, '0000')

	Select next_avail_Seq_No into :ldStartingssccnbr
	From Next_Sequence_no
	Where Project_id = :gs_project and Table_Name= 'Delivery_Packing' and column_Name = 'SSCC_No' ;

	lsCartonNo = string(ldStartingssccnbr, '000000000')
	lsUCCS =  trim((lsUCCCompanyPrefix +  lsCartonNo))
	
	//From BaseLine
	liCheck = f_calc_uccs_check_Digit(lsUCCS) 
	//If liCheck >=0 Then
		//lsUCCS = "00" + lsUCCS + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
	//Else
		lsUCCS = "00" + String(lsUCCS, '00000000000000000000 ') + "0"
	//End IF
	
	lsOutString += lsUCCS  + ' ' + lsDelimitChar
//END IF

Return lsOutString
end function

on w_bosch_sscc_label_print.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
this.dw_label=create dw_label
this.cb_print_carton_labels=create cb_print_carton_labels
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_selectall
this.Control[iCurrent+3]=this.cb_clear
this.Control[iCurrent+4]=this.dw_label
this.Control[iCurrent+5]=this.cb_print_carton_labels
end on

on w_bosch_sscc_label_print.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_selectall)
destroy(this.cb_clear)
destroy(this.dw_label)
destroy(this.cb_print_carton_labels)
end on

event ue_postopen;call super::ue_postopen;// 10/26/2022- Dinesh - SIMS-107- SIMS BOSCH SSCC LABEL
invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

cb_print.Enabled = False

isOrigSql = dw_label.GetSqlSelect()

IstrParms = message.powerobjectparm
If IsValid(message.powerobjectparm) then
	is_dono = IstrParms.String_arg[1]
End if
Choose case gs_ActiveWindow
	Case  'OUT'
		This.Title = 'SSCC Carton/Pallet Labels Outbound'
		isOrderType = 'OUTBOUND'
	Case Else
		Messagebox("Labels","You must have the Outbound Order screen open to print SSCC Carton/Pallet labels.")
		Return
End Choose


This.TriggerEvent('ue_retrieve')


end event

event ue_retrieve;call super::ue_retrieve;// 10/26/2022- Dinesh - SIMS-107- SIMS BOSCH SSCC LABEL
Choose case isOrderType 
	Case 'OUTBOUND'
		If not isvalid(w_do) Then Return
			dw_label.DataObject = 'd_bosch_sscc_label_print'
			dw_label.SetTransObject(sqlca)
			If w_do.idw_main.RowCount() < 1 then return
			dw_label.Retrieve(w_do.idw_main.GetITemString(1,'Do_no')) 
			
End Choose

cb_print.Enabled = True


end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount
		
String ls_SKU, ls_SKU_Parent
		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()

If llRowCount > 0 Then

	For llRowPos = 1 to llRowCount
	
		 ls_SKU				= dw_label.GetItemString( llRowPos , "SKU"			) 
	 
		If IsNull(  ls_SKU ) or Trim( ls_SKU ) = ''  Then  ls_SKU = ''
	   	If  ls_SKU <> ''   Then dw_label.SetITem(llRowPos,'c_print_ind','Y')
	Next
	
End If

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

event ue_unselectall;call super::ue_unselectall;Long	llRowPos,	&
		llRowCount
		
String   ls_SKU,  ls_SKU_Parent
		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()

If llRowCount > 0 Then

	For llRowPos = 1 to llRowCount
	
		ls_SKU				= dw_label.GetItemString( llRowPos , "SKU"			) 
		If IsNull(  ls_SKU ) 			or Trim( ls_SKU ) = '' 			Then  ls_SKU = ''
		If  ls_SKU <> ''  Then dw_label.SetITem(llRowPos,'c_print_ind','N')

	Next
	
End If

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_bosch_sscc_label_print
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_bosch_sscc_label_print
boolean visible = false
integer x = 1371
integer y = 32
integer height = 80
integer textsize = -9
boolean default = false
end type

type cb_print from commandbutton within w_bosch_sscc_label_print
integer x = 891
integer y = 32
integer width = 329
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;Parent.TriggerEvent('ue_Print')
end event

type cb_selectall from commandbutton within w_bosch_sscc_label_print
integer x = 37
integer y = 32
integer width = 338
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;Parent.Event ue_selectall()

end event

type cb_clear from commandbutton within w_bosch_sscc_label_print
integer x = 393
integer y = 32
integer width = 338
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;Parent.Event ue_unselectall()
end event

type dw_label from u_dw_ancestor within w_bosch_sscc_label_print
integer y = 148
integer width = 3877
integer height = 1384
string dataobject = "d_bosch_sscc_label_print"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;
Choose Case Upper(dwo.name)
		
	Case "COUNTRY_OF_ORIGIN_DEFAULT"
		
		If data > "" Then
			
			If f_get_country_name(data) = "" Then
				Messagebox("Labels", "Invalid Country of Origin")
				Return 1
			End If
			
		End If
		
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event constructor;call super::constructor;//
//DatawindowChild	ldwc
//
//This.GetChild('user_field11',ldwc)
//
//ldwc.SetTransObject(SQLCA)
//
//ldwc.Retrieve(gs_project,'PTLBL')
//
end event

event process_enter;call super::process_enter;
Send(Handle(This),256,9,Long(0,0))
end event

type cb_print_carton_labels from commandbutton within w_bosch_sscc_label_print
boolean visible = false
integer x = 1326
integer y = 32
integer width = 407
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print Carton"
end type

event clicked;Parent.TriggerEvent('ue_Print_carton')
end event

