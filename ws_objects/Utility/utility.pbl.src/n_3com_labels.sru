$PBExportHeader$n_3com_labels.sru
$PBExportComments$3COM label functions
forward
global type n_3com_labels from nonvisualobject
end type
end forward

global type n_3com_labels from nonvisualobject
end type
global n_3com_labels n_3com_labels

type variables
n_labels	invo_labels

String	isLabels[]
Long		ilLabelNumber
end variables

forward prototypes
public function integer uf_3com_zebra_ship (ref any as_array, datawindow adw, boolean ab_duplicate_carton)
public function integer uf_3com_mixed_sku (any aa_array, datawindow adw)
public function integer uf_3com_bundled_part (any aa_array, datawindow adw)
public function integer uf_3com_pallet_label (any as_array, datawindow adw)
end prototypes

public function integer uf_3com_zebra_ship (ref any as_array, datawindow adw, boolean ab_duplicate_carton); //This function will print  3COM Shipping labels

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,	&
			lsUCCCarton, lsLabels[]

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck

// 01/05 - PCONKL - Writing all labels to array and spooling together at end

isLabels[] =  lsLabels[] /*initialize label array*/

FOR j=1 TO 3 /*Each Label Choice (Mixed Carton, Shipment, OEM) */

	lstrparms = as_array
	CHOOSE CASE j
			
		CASE 1
		
			// 01/05 - PCONKL - We may have bundled and non-bundled parts in the same carton which will have seperate labels
			//							Each routine will fall thru if none to print. We need to call both since we are only processing
			//							Once per carton.
			
			IF Not ab_duplicate_carton THEN
				uf_3com_mixed_sku( as_array, adw)	/*Non bundled*/
				uf_3com_Bundled_part( as_array, adw) /*Bundled*/
			End If
			
			Continue
			
		CASE 2
			
			IF ab_duplicate_carton THEN Continue
			
			//lsFormat = invo_labels.uf_read_label_Format('3COM_zebra_shipment.txt')
			ilLabelNumber ++
			isLabels[ilLabelNumber] = invo_labels.uf_read_label_Format('3COM_zebra_ship_UCC.txt') /* 12/03 - PCONKL - Switched to UCCS */
		
		Case 3
		
			IF ab_duplicate_carton THEN Continue
			
			//Check for user feild 5 in deliver master has any data marked to 
			//print for conditional labels.
			IF Upper(lstrparms.String_Arg[22]) <> 'OEM'  or ISNULL(lstrParms.String_arg[1]) or lstrParms.String_arg[1] = '' THEN 
				EXIT
			ELSE			
				ilLabelNumber ++
				isLabels[ilLabelNumber] = invo_labels.uf_read_label_Format(lstrParms.String_arg[1])			
			END IF	
		
	END CHOOSE

	lsPrintText = '3COM zebra Common'

	lsTemp = isLabels[ilLabelNumber]
	IF (j=1 or j= 2) and ab_duplicate_carton THEN continue


	////Format not loaded
	//If isLabels[ilLabelNumber] = '' Then Return -1

	//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
	//The rest of the fields are static through the batch so only need to be replaced once - otherwise we would have to load the format each time

	//Replace placeholders in Format with Field Values

	//From Address - Roll up addresses if not all present
	
	llAddrPos = 0

	If lstrparms.String_Arg[2] > ' ' Then
		llAddrPos ++
		lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,Left(lstrparms.String_Arg[2],60))
	End If
	
	If lstrparms.String_Arg[3] > ' ' Then
		llAddrPos ++
		lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,Left(lstrparms.String_Arg[3],60))
	End If

	If lstrparms.String_Arg[4] > ' ' Then
		llAddrPos ++
		lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,Left(lstrparms.String_Arg[4],60))
	End If

	If lstrparms.String_Arg[5] > ' ' Then
		llAddrPos ++
		lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,Left(lstrparms.String_Arg[5],60))
	End If
	
	If lstrparms.String_Arg[31] > ' ' Then
		llAddrPos ++
		lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,left(lstrparms.String_Arg[31],45))
	End If
	
	If lstrparms.String_Arg[6] > ' ' Then
		llAddrPos ++
		lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,left(lstrparms.String_Arg[6],30))
	End If

	If lstrparms.String_Arg[29] > ' ' Then 
		llAddrPos ++
		lsAddr = "~~from_addr" + String(llAddrPos) + "~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,left(lstrparms.String_Arg[29],45))
	End If

	//To Address - Roll up addresses if not all present

	llAddrPos = 0

	If lstrparms.String_Arg[7] > ' ' Then
		llAddrPos ++
		lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Customer Name
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,Left(lstrparms.String_Arg[7],60))
	End If

	If lstrparms.String_Arg[8] > ' ' Then
		llAddrPos ++
		lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address1
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,Left(lstrparms.String_Arg[8],60))
	End If

	If lstrparms.String_Arg[9] > ' ' Then
		llAddrPos ++
		lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address2
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,left(lstrparms.String_Arg[9],60))
	End If

	If lstrparms.String_Arg[10] > ' ' Then
		llAddrPos ++
		lsAddr = "~~to_addr" + String(llAddrPos) + "~~" //Address3
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,Left(lstrparms.String_Arg[10],60))
	End If

	If lstrparms.String_Arg[32] > ' ' Then //Address4
		llAddrPos ++
		lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,left(lstrparms.String_Arg[32],60))
	End If

	If lstrparms.String_Arg[11] > ' ' Then //City,state,zip
		llAddrPos ++
		lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,left(lstrparms.String_Arg[11],45))
	End If

	If lstrparms.String_Arg[30] > ' ' Then //To Country
		llAddrPos ++
		lsAddr = "~~to_addr" + String(llAddrPos) + "~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],lsAddr,left(lstrparms.String_Arg[30],45))
	End If

	//Ship To Post Code
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~ship_to_zip~~",left(lstrparms.String_Arg[33],12)) /* 12/03 - PCONKL - For UCCS Label */
	
	//Ship To Post Code (BARCODE)	
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~ship_to_zip_BC~~",left(lstrparms.String_Arg[33],8)) /* 12/03 - PCONKL - For UCCS Label */
	
	//AWB
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~bol_nbr~~",left(lstrparms.String_Arg[34],12)) /* 12/03 - PCONKL - For UCCS Label */
	
	//Carton no
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~carton_no,0030~~",left(lstrparms.String_Arg[12],30))
	
	//Carton no (UCCS Label) - 
	If  lstrparms.String_Arg[35] > '' Then
		lsUCCCarton = "0" + lstrparms.String_Arg[35] + Right(String(Long(lstrparms.String_Arg[12]),'000000000'),9) /*Prepend UCCS Info - 0 (futire use) + Warehouse Prefix + Company Prefix) */		
		liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
		If liCheck >=0 Then
			lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
		Else
			lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
		End If
	Else
		lsUccCarton = String(Long(lstrparms.String_Arg[12]),'00000000000000000000')
	End If
	
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~carton_no_BC~~",lsUCCCarton)
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~carton_no_readable~~",Right(lsUCCCarton,18)) /* 00 already on label as text field but included in barcode*/
	
	//for Barcode Cartons
	lstrparms.String_Arg[12] ='3S'+lstrparms.String_Arg[12]
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~carton_no,0015~~",left(lstrparms.String_Arg[12],15))

	//Po No
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~po_nbr~~",left(lstrparms.String_Arg[13],30))

	//For Barcode POs
	lstrparms.String_Arg[13] ='K'+lstrparms.String_Arg[13]
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~po_nbr,0015~~",left(lstrparms.String_Arg[13],15))

	//Cust No
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~sku_no,0030~~",left(lstrparms.String_Arg[14],30))//Alternate sku

	//For Barcode Cust
	lstrparms.String_Arg[14] ='P'+lstrparms.String_Arg[14]
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~sku_no,0015~~",left(lstrparms.String_Arg[14],30))

	//Ship QTY
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~qty,0030~~",String(lstrparms.String_Arg[15]))
	
	//For Bar code ship qty
	lstrparms.String_Arg[15] ='Q'+lstrparms.String_Arg[15]
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~qty,0008~~",String(lstrparms.String_Arg[15]))
	
	IF j=2 THEN //For shipping labels print the total only
		//ls_weight = String(lstrparms.Long_Arg[5]) + "/" + String(lstrparms.Long_Arg[6])
		ls_weight = String(lstrparms.Decimal_Arg[1],'#######.##') + "/" + String(lstrparms.Decimal_Arg[2],'#######.##')
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~weight,0008~~",ls_weight )
//		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~weight_lbs_no,0030~~",String(lstrparms.Long_Arg[5]))
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~weight_lbs_no,0030~~",String(lstrparms.Decimal_Arg[1],'#######.##'))
//		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~weight_kgs_no,0030~~",String(lstrparms.Long_Arg[6]))
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~weight_kgs_no,0030~~",String(lstrparms.Decimal_arg[2],'#######.##'))
//		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~weight,0030~~",String(lstrparms.Long_Arg[5]) + "LBs / " + String(lstrparms.Long_Arg[6]) + "KGs") /* 12/03 - PCONKL - Weight for UCCS */
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~weight~~",String(lstrparms.Decimal_arg[1],'#######.##') + "LBs / " + String(lstrparms.Decimal_Arg[2],'#######.##') + "KGs") /* 12/03 - PCONKL - Weight for UCCS */
	ELSE	
		ls_weight = String(lstrparms.Long_Arg[3]) + "/" + String(lstrparms.Long_Arg[4])
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~weight,0008~~",ls_weight )
	
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~weight_lbs_no,0030~~",String(lstrparms.Long_Arg[3]))
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~weight_kgs_no,0030~~",String(lstrparms.Long_Arg[4]))
	END IF	

	//Country Name
	//Country Name for Compaq Labels only
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~country_name,0030~~",Left(lstrparms.String_Arg[16],45))	
	

	//Invoice NO
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~invoice_no~~",Left(lstrparms.String_Arg[17],20))	

	//Barcode scanning for invoice
	lstrparms.String_Arg[17] ='IA'+lstrparms.String_Arg[17]
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~invoice_no,0015~~",Left(lstrparms.String_Arg[17],20))
	
	//Sku
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~sku_act_no,0030~~",left(lstrparms.String_Arg[18],30)) //real sku
	
	//barcode sku 
	lstrparms.String_Arg[18] ='P'+lstrparms.String_Arg[18]
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~sku_act_no,0015~~",left(lstrparms.String_Arg[18],30))

	//Item master sku description
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~item_desc,0030~~",left(lstrparms.String_Arg[19],50))
	
	//Countru Of origin
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~coo,0030~~",left(lstrparms.String_Arg[20],30))
	
	//Do no number
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~ord_no,0030~~",left(lstrparms.String_Arg[21],30))

	//Delivery Order Number
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~dn_no~~",left(lstrparms.String_Arg[23],30))
	
	//Barcode Delivery Order Number
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~dn_no,0015~~",left(lstrparms.String_Arg[23],30))

	//upc code
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~upc_code,0030~~",left(lstrparms.String_Arg[24],30))

	//Barcode upc code
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~upc_code,0015~~",left(lstrparms.String_Arg[24],30))

	//Today's date 
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~today~~",string(today(),"dd-mmm-yyyy"))
	
	//Carrier Name
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~carrier_name~~",left(lstrparms.String_Arg[25],30))
	
	//Sales Order No
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~sales_order,0030~~",left(lstrparms.String_Arg[26],30))

	//Bar Code Sales Order 
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~sales_order,0015~~",left(lstrparms.String_Arg[26],30))

	//Tracking shipper No
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~tracker_id~~",left(lstrparms.String_Arg[27],30))

	//Bar Code Tracking shipper No
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~tracker_id,0015~~",left(lstrparms.String_Arg[27],30))
	
	//dts 3/18/05, 'Pallet' or 'Box' for Shipping label
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~box_or_pallet~~",left(lstrparms.String_Arg[37],30))
	
	//Box count (for Pallet label)
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~box_count~~",left(lstrparms.String_Arg[38],30))

	//These labels need to print for all carriers except UPS (SHIP015932 & SHIP015933).

	IF Upper( lstrparms.String_arg[42] ) <> 'SHIP015932' AND &
		Upper( lstrparms.String_arg[42] ) <> 'SHIP015933' THEN
	
		string ls_space
	
		ilLabelNumber ++
		isLabels[ilLabelNumber] = invo_labels.uf_read_label_Format('3COM_Extra_Label_Zebra.txt')

		if len(lstrparms.String_Arg[7]) > 0 then
			ls_space = space((int((35 - len(lstrparms.String_Arg[7]))/2)))
		else
			ls_space = ""
		end if

		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~customer_name~~",left(lstrparms.String_Arg[7],35) + ls_space)

		if len(lstrparms.String_Arg[39]) > 0 then
			ls_space = space((int((35 - len(lstrparms.String_Arg[39]))/2)))
		else
			ls_space = ""
		end if	
		
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~country_code~~",left(lstrparms.String_Arg[39],35) + ls_space)

		if len(lstrparms.String_Arg[40]) > 0 then
			ls_space = space((int((35 - len(lstrparms.String_Arg[40]))/2)))
		else
			ls_space = ""
		end if
		
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~freight_terms~~",left(lstrparms.String_Arg[40],35) + ls_space)

		if len(lstrparms.String_Arg[41]) > 0 then
			ls_space = space((int((35 - len(lstrparms.String_Arg[41]))/2)))
		else
			ls_space = ""
		end if
		
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~shipment_ref~~",left(lstrparms.String_Arg[41],35) + ls_space)		

				
		
		
	END IF




NEXT /*Label Choice*/

ll_no_of_copies = lstrparms.Long_Arg[1]

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If



For llPos = 1 to UpperBound(isLabels[])
		
	FOR i= 1 TO ll_no_of_copies
		isLabels[llPos] = invo_labels.uf_replace(isLabels[llPos],"~~tot_off~~",left(lstrparms.String_Arg[28],30))
		PrintSend(llPrintJob, isLabels[llPos])	
		ls_temp= lstrparms.String_Arg[28]
	NEXT
		
Next
	
	PrintClose(llPrintJob)
	
Return 0


end function

public function integer uf_3com_mixed_sku (any aa_array, datawindow adw);//This function will print  SKU label for 3COM

Str_parms	lStrparms
String	lsFormat,	&
			ls_old_carton_no,	&
			lsTemp,				&
			lsPrintText,		&
			lsAddr,ls_weight,ls_temp,ls_syntax_begin,ls_syntax_end, lsFilter

Long	llPrintJob,	&
		llPos,		&
		llPrintQty,	&
		llPrintPos,	&
		llCartonNo,	&
		llAddrPos,ll_no_of_copies,ll_barcode,ll_no,ll_cnt,ll_start
long  ll_end,ll_diff,ll_pos,li_var,ll_tot_no_sku,ll_tot, llLabelPos, lLStartPos
		
Integer	liFileNo
Boolean	lbPrint

String ls_barcode_no = '0015'
string ls_no =  '0030'
String ls_search_barcode,ls_search
Long	 i,j

lbPrint = False

lstrparms = aa_array



lsPrintText = '3COM zebra Common'

ll_barcode = 15
ll_no = 30

//isLabels[ilLabelNumber] = invo_labels.uf_read_label_Format('3COM_zebra_mixed.DWN')
lsPrintText = '3COM zebra Common'
ls_old_carton_no = lstrparms.String_Arg[12]


// 01/05 - changed to just filter current carton instead of looping all
lsFilter = "Upper(delivery_packing_carton_no) = '" + Upper(ls_old_carton_no) + "' and c_print_ind = 'Y' and (grp <> 'B' or isnull(grp))"
adw.SetFilter(lsFilter)
adw.Filter()

If adw.RowCount() = 0 Then
	adw.setfilter('')
	adw.Filter()
	adw.Sort()
	Return 1
End If

lsFormat = invo_labels.uf_read_label_Format('3COM_zebra_mixed.DWN') /*only need to read format once - load from variable for subsequent labels */

//01/08 - PCONKL - If this is a Tipping Point Order, we need to replace '3COM Corp' with Tipping Point
If w_do.idw_main.GetITemString(1,'ord_type') = 'P' /*Tipping Point */ Then
	lsFormat = Replace(lsFormat,Pos(Upper(lsFormat),'3COM CORP.'),10,'TippingPoint')
End If

// 01/05 - PCONKL - storing labels to print in array and will print all together at the end
ilLabelNumber ++
isLabels[ilLabelNumber] = lsFormat	

isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~today,0030~~",string(today(),"mmm dd, yyyy"))

llLabelPos = 0 /*4 to a label for mixed SKU's */

FOR j = 1 TO adw.Rowcount()		
		
	//IF ls_old_carton_no = adw.object.delivery_packing_carton_no[j] THEN
		
	//	IF adw.object.c_print_ind[j] <> 'Y' THEN COntinue
				
		lbPrint = True /* it's possible (Probable) that all SKU's in carton are bundled and we don't want to print a blank label*/
			
		// 04/05 - PCONKL - Add logic to support more than 1 label's worth of SKU's (currently 4 to a page)
		llLabelPos ++
		If llLabelPos > 4 Then /*need a new label */
			
			ilLabelNumber ++
			isLabels[ilLabelNumber] = lsFormat
			isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~today,0030~~",string(today(),"mmm dd, yyyy"))
			
			ll_barcode = 15
			ll_no = 30
			ls_barcode_no = '0015'
			ls_no =  '0030'
			
			ll_cnt = 0
			
			llLabelPos = 1
			
		End If /*need a new label */
		
		//Assign Values
		ls_search_barcode = "~~dn_no,"+ls_no +"~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],ls_search,adw.object.delivery_master_user_field6[j])
		ls_search = "~~sku_act_no,"+ls_no +"~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],ls_search,adw.object.item_master_sku[j])
		ls_search = "~~~qty,"+ls_no +"~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],ls_search,String(round(adw.object.delivery_packing_quantity[j],0)))
		ls_search = "~~uom,"+ls_no +"~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],ls_search,adw.object.delivery_detail_uom[j])
		ls_search = "~~upc_code,"+ls_no +"~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],ls_search,string(adw.object.item_master_part_upc_code[j]))
		ls_old_carton_no = adw.object.delivery_packing_carton_no[j]		
		
		//Assign BarCodes
		ls_search_barcode = "~~dn_no,"+ls_barcode_no +"~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],ls_search_barcode,adw.object.delivery_master_user_field6[j])
		ls_search_barcode = "~~sku_act_no,"+ls_barcode_no +"~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],ls_search_barcode,'P'+adw.object.item_master_sku[j])
		ls_search_barcode = "~~~qty,"+ ls_barcode_no +"~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],ls_search_barcode,'Q'+String(round(adw.object.delivery_packing_quantity[j],0)))
		ls_search_barcode = "~~uom,"+ls_barcode_no +"~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],ls_search_barcode,adw.object.delivery_detail_uom[j])
		ls_search_barcode = "~~upc_code,"+ls_barcode_no+"~~"
		isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],ls_search_barcode,string(adw.object.item_master_part_upc_code[j]))
		
		// 03/07 - PCONKL - If Length of UPC is 13, we need to change 'UPC' literal to 'EAN' and change UPC Barcode to EAN Barcode
		If Len(Trim(string(adw.object.item_master_part_upc_code[j]))) = 13 Then
			
			//Change UPC LIteral to EAN Literal - If first set, there is no beginning tag, use the ending tag of the second. Otherwise, use the beginning tag
			If llLabelPos = 1 Then
				ls_syntax_begin = "~~end product2~~"
			Else
				ls_syntax_begin = "~~begin upc_code"+String(llLabelPos) +"~~"
			End If
			
			lLStartPos = POs(isLabels[ilLabelNumber],ls_syntax_begin)
			isLabels[ilLabelNumber] = Replace(isLabels[ilLabelNumber],Pos(isLabels[ilLabelNumber],"^FDUPC^",POs(isLabels[ilLabelNumber],ls_syntax_begin)),7,"^FDEAN^")
			
			//Change Barcode Type from UPC to EAN
			If llLabelPos = 1 Then
				ls_syntax_begin = "~~end upc_code2~~"
			Else
				ls_syntax_begin = "~~begin upc_code"+String(llLabelPos) +"~~"
			End If
			
			lLStartPos = POs(isLabels[ilLabelNumber],ls_syntax_begin)
			isLabels[ilLabelNumber] = Replace(isLabels[ilLabelNumber],Pos(isLabels[ilLabelNumber],"^BUN",LastPOs(isLabels[ilLabelNumber],ls_syntax_begin)),7,"^BEN")
		End If
		
		
		ll_no ++
		ll_barcode ++
		ll_cnt ++
		ls_no = "00" + string(ll_no)
		ls_barcode_no = "00"+ string(ll_barcode)
		ls_old_carton_no = adw.object.delivery_packing_carton_no[j]	
		
//	ENd IF
	
 Next /*pack row for current carton */
 
adw.SetFilter('')
adw.Filter()
adw.Sort()

ll_tot = 4
//No of times sku should be printed is ll_ tot_no_of_skus
FOR ll_tot_no_sku = 1 TO 4
 //Check if how many skus is carton  ll_cnt 	
  IF ll_tot_no_sku = ll_cnt THEN
	   //Start formatting from next number if tot is 1 then 2 to 4
		//should be blank
		ll_pos = ll_cnt +1
		FOR ll_pos = ll_pos TO ll_tot
			FOR li_var = 1 to 5
				CHOOSE CASE li_var
				CASE 1,4
					ls_syntax_begin = "~~begin upc_code"+String(ll_pos) +"~~"
					ls_syntax_end = "~~end upc_code"+string(ll_pos) +"~~"
				CASE 2
					ls_syntax_begin = "~~begin product"+String(ll_pos) +"~~"
					ls_syntax_end = "~~end product"+String(ll_pos) +"~~"
				CASE 3
					ls_syntax_begin = "~~begin qty"+String(ll_pos) +"~~"
					ls_syntax_end = "~~end qty"+String(ll_pos) +"~~"
				CASE 5
					ls_syntax_begin = "~~begin line"+String(ll_pos) +"~~"
					ls_syntax_end = "~~end line"+String(ll_pos) +"~~"
				END CHOOSE
				
					ll_start=pos(isLabels[ilLabelNumber],ls_syntax_begin)
					IF ll_start = 0 THEN Continue								
					ll_end=pos(isLabels[ilLabelNumber],ls_syntax_end)
					IF ll_end = 0 THEN Continue
					ll_diff= (ll_end - ll_start ) + len(ls_syntax_end) + 2
					isLabels[ilLabelNumber] = replace(isLabels[ilLabelNumber],ll_start,ll_diff,"")
			Next	
			
		NEXT
		
	END IF	
	
NEXT	

//If no un-bundled sku's, don't print a blank label
If Not lbPrint then return 1

////Open Printer File 
//llPrintJob = PrintOpen(lsPrintText)
//
//If llPrintJob <0 Then 
//	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
//	Return -1
//End If
//	 
////No of copies
//ll_no_of_copies = lstrparms.Long_Arg[1]
//FOR i= 1 TO ll_no_of_copies
//	PrintSend(llPrintJob, isLabels[ilLabelNumber])		
//NEXT
//
//PrintClose(llPrintJob)

Return 1

end function

public function integer uf_3com_bundled_part (any aa_array, datawindow adw);//This function will print  Bundled part SKU label for 3COM

Str_parms	lStrparms
String	lsFormat, lsCarton, lsPrintText, lsFilter, lsField, ls, lsDesc, lsPickFind, lsPackFind, lsChildSKU,	&
			lsLabel[], lsSKU, lsSupplier, lsCOO, lsDONO, lsCartonNo, lsSerial, lsSKUHold, lsSerialbc

Long	llPrintJob,	llCartonPos,  llCartonNo, llLineItemno,	llSerialPos, llSerialRow,	&
		llPickFindRow, llPackFindRow, llLabelPos, llRowPos, llRowCount, i, j, llSerialCount, llLabelPosSer, li_idx
		
Integer	liFileNo, liRow
Boolean	lbPrint, ib_serialbc

DataStore	ldsSerial	 
DataStore ldsTempSerailbc


//Carton Serial Numbers
ldsSerial = Create Datastore
ldsSerial.Dataobject = 'd_do_carton_serial' /* 01/05 - PConkl - Retrieve for all suppliers but by COO */
ldsSerial.SetTransobject(sqlca)

ldsTempSerailbc = Create Datastore
ldsTempSerailbc.Dataobject = 'd_3com_temp_bundle_serialbc' /* 01/05 - PConkl - Retrieve for all suppliers but by COO */



lbPrint = False

lstrparms = aa_array

//lsFormat = invo_labels.uf_read_label_Format('3com_zebra_bundle_part.txt')

//01/08 - PCONKL - If this is a Tipping Point Order, we need to replace '3COM Corp' with Tipping Point
If w_do.idw_main.GetITemString(1,'ord_type') = 'P' /*Tipping Point */ Then
	lsFormat = Replace(lsFormat,Pos(Upper(lsFormat),'3COM CORP'),9,'TippingPoint')
End If

lsPrintText = '3COM zebra Bundled SKU'

lsCarton = lstrparms.String_Arg[12]
lsDoNO = w_do.idw_main.GetITemString(1,'do_no')

//Make sure pick and pack lists are showing components
w_do.wf_set_pick_filter('REMOVE')
w_do.wf_set_pack_filter('REMOVE')

//Only show rows for current Carton
lsFilter = "Upper(delivery_packing_carton_no) = '" + Upper(lsCarton) + "' and grp = 'B' and c_print_ind = 'Y'"
adw.SetFilter(lsFilter)
adw.Filter()

llRowCount = adw.RowCount()
FOR llRowPos = 1 TO llRowCount	
	
	//Added Barcodes for Serial Numbers
	
	IF Not IsNull(adw.GetITemString(llRowPos,'item_master_user_field15')) AND Upper(adw.GetITemString(llRowPos,'item_master_user_field15')) = 'Y' THEN

		lsFormat = invo_labels.uf_read_label_Format('3com_zebra_bundle_part_serialbc.txt')			
		
		ib_serialbc = true
		
		ldsTempSerailbc.Reset()
		
	ELSE

		lsFormat = invo_labels.uf_read_label_Format('3com_zebra_bundle_part.txt')		

		
		ib_serialbc = false
		
	END IF	
	
			
	llCartonPos = 99 /*will trigger new label on first loop */
			
	//For Each bundled Parent, we need the children in that carton. Get the list of the Children from Delivery Picking
	// and then get the child info from packing
	
	lsPickFind = "Upper(sku_parent) = '" + adw.GetITemString(llRowPos,'Item_Master_SKU') + "' and Line_Item_No = " + String(adw.GetITemNumber(llRowPos,'Delivery_PAcking_Line_Item_No'))
	lsPickFind += " and Upper(sku_parent) <> Upper(SKU)" /*dont want to include parent*/
	llPickFindRow = w_do.idw_Pick.Find(lsPickFind,1,w_do.idw_Pick.RowCount())
	lsSKUHold = ''
	
	Do While llPickFindRow > 0 /*Each child for current parent (from pack List)*/
		
		//Find Children for this carton in Packing
		lsChildSKU = w_do.idw_Pick.GetITEmString(llPickFindRow,'SKU')
		
		//We only want the first instance of the SKU (it may have been picked from multiple locations
		If lsChildSku = lsSKUHold Then Goto Findnextpickchild /* I know... */
		
		lsSKUHold = lsChildSKU
		
		lsPackFind = "Upper(carton_no) = '" + Upper(lsCarton) + "' and Upper(SKU) = '" + Upper(lsChildSKU) + "'"
		llPackFindRow = w_do.idw_Pack.Find(lsPackFind,1, w_do.idw_pack.RowCount())

		
		if ib_serialbc then   /*Serial Number */
		
			
			Do While llPackFindRow > 0 /*Each instance of child in this carton */
				
		
				lsSKU = w_do.idw_Pack.GetITemString(llPackFindRow,'SKU')
				lsSupplier = w_do.idw_Pack.GetITemString(llPackFindRow,'Supp_Code')
				lsCOO = w_do.idw_Pack.GetITemString(llPackFindRow,'Country_of_Origin')
				lsCartonNo = w_do.idw_Pack.GetITemString(llPackFindRow,'Carton_No')
				llLineItemNo = w_do.idw_Pack.GetITemNumber(llPackFindRow,'Line_ITem_No')
				
				//Description - From Item MAster
				Select Description into :lsDesc
				From ITem_Master
				Where Project_id = :gs_Project and SKU = :lsSKU and Supp_Code = :lsSupplier;
				
				//We need the Serial Numbers for this Carton, SKU, COO
				llSerialCount = ldsSerial.Retrieve(lsdono, lsCartonNo, lsSKU, lsCOO, llLineItemNo)
								
				IF llSerialCount > 0 THEN

								
					For llSerialPos = 1 to llSerialCount		
	

						liRow = ldsTempSerailbc.InsertRow(0)
					
						ldsTempSerailbc.SetItem(liRow, "SKU",  lsSKU)
						ldsTempSerailbc.SetItem(liRow, "QTY",  String(w_do.idw_Pack.GetITemNumber(llPackFindRow,'Quantity')) + ' EA')					
						ldsTempSerailbc.SetItem(liRow, "COO","Country of Origin " + lsCOO)
						ldsTempSerailbc.SetItem(liRow, "DESC", lsDesc)	
						ldsTempSerailbc.SetItem(liRow, "SERIAL", ldsSerial.GetITemString(lLSerialPos,'serial_no'))	
						
					Next /*serial Row */		
					
				ELSE
				
					
					liRow = ldsTempSerailbc.InsertRow(0)
					
					ldsTempSerailbc.SetItem(liRow, "SKU",  lsSKU)
					ldsTempSerailbc.SetItem(liRow, "QTY",  String(w_do.idw_Pack.GetITemNumber(llPackFindRow,'Quantity')) + ' EA')					
					ldsTempSerailbc.SetItem(liRow, "COO","Country of Origin " + lsCOO)
					ldsTempSerailbc.SetItem(liRow, "DESC", lsDesc)
					
				END IF


				//Find the Next Child in Carton
				llPackFindRow ++
				If llPackFindRow > w_do.idw_pack.RowCount() Then
					llPAckFindRow = 0
				Else
					llPackFindRow = w_do.idw_Pack.Find(lsPackFind,llPAckFindRow, w_do.idw_pack.RowCount())
				End If
							
			Loop /*Next Pack Row for current child*/



			
			

//---
			

		else
		
			Do While llPackFindRow > 0 /*Each instance of child in this carton */
				
				llCartonPos ++
					
				//We can only get 4 children on a label, if more or it's a new parent, split to a new carton
				If llCartonPos > 4 Then
					
					lllabelpos ++
					lslabel[lllabelpos] = lsFormat /* labels to print stored in array so we can set the label count when we're done and print all together*/
					
					//Set Parent Level fields on Label...
					
					//Print Date
					lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~print_date~~",string(today(),"mmm dd, yyyy"))
					
					//Parent SKU
					lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~sku~~",adw.GetITemString(llRowPos,'Item_master_SKU'))
					lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~sku_bc~~",'P' + adw.GetITemString(llRowPos,'Item_master_SKU'))
					
					//Delivery Note (MN Number)
					lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~dn_no_bc~~",Lstrparms.String_arg[23])
					
					//Parent QTY
					lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~qty~~",String(round(adw.GetItemnumber(llRowPos,'delivery_packing_quantity'),0)) + ' EA')
					
					
					//UPC
					lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~upc_bc~~",String(adw.object.item_master_part_upc_code[llRowPos]))
					
					// 03/07 - PCONKL - If Length of UPC = 13, then change to EAN barcode and change 'UPC' leteral to 'EAN'
					If Len(Trim(String(adw.object.item_master_part_upc_code[llRowPos]))) = 13 Then /*EAN*/
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"^FDUPC^","^FDEAN^") /*literal above barcode*/
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"^BUN","^^BEN") /*barcode type U=UPC, E=EAN*/
					End If  
					
					//Carton X of Y
					lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~carton_of~~","Carton " + String(adw.GetITemNumber(llRowPos,'c_carton_of')) + " of " + String(adw.GetITemNumber(llRowPos,'c_carton_count')))
					
					llCartonPos = 1
									
				End IF /* New label Header */
				
				lsSKU = w_do.idw_Pack.GetITemString(llPackFindRow,'SKU')
				lsSupplier = w_do.idw_Pack.GetITemString(llPackFindRow,'Supp_Code')
				lsCOO = w_do.idw_Pack.GetITemString(llPackFindRow,'Country_of_Origin')
				lsCartonNo = w_do.idw_Pack.GetITemString(llPackFindRow,'Carton_No')
				llLineItemNo = w_do.idw_Pack.GetITemNumber(llPackFindRow,'Line_ITem_No')
				
				//Set Child SKU info on Current Label
				lsField = "~~child_sku_" + String(llCartonPos) + "~~"
				lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,lsSKU)
				
				//Qty
				lsField = "~~qty_" + String(llCartonPos) + "~~"
				lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,String(w_do.idw_Pack.GetITemNumber(llPackFindRow,'Quantity')) + ' EA')
				
				//COO
				lsField = "~~coo_" + String(llCartonPos) + "~~"
				lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,"Country of Origin " + lsCOO)
				
				//Description - From Item MAster
				Select Description into :lsDesc
				From ITem_Master
				Where Project_id = :gs_Project and SKU = :lsSKU and Supp_Code = :lsSupplier;
				
				lsField = "~~desc_" + String(llCartonPos) + "~~"
				lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,lsdesc)
										
				//We need the Serial Numbers for this Carton, SKU, COO
				llSerialCount = ldsSerial.Retrieve(lsdono, lsCartonNo, lsSKU, lsCOO, llLineItemNo)
				
				//We currently have 5 rows of 2 each serial numbers for a total of 10
				lLSerialRow = 1
				
				lsField = "~~serial_" + String(llCartonPos) + "1~~" /*first serial row */
				lsSerial = ""
				
				For llSerialPos = 1 to llSerialCount
					
					If lLSerialPos = 3 or llSerialPos = 5 or llSerialPos = 7 or llSerialPos = 9 Then /* new serial row*/
									
						If llSerialrow = 1 Then lsSerial = "S/N: " + lsSerial /*need field label on first row */
						
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,lsserial)
						lsSerial = ''
						lLSerialRow ++
						lsField = "~~serial_" + String(llCartonPos) + String(llSerialRow) + "~~"
						
					End If
					
					lsSerial +=  ldsSerial.GetITemString(lLSerialPos,'serial_no') + ', '
					
				Next /*serial Row */
				
				//Set last/only
				If lsSerial > '' Then
					If Right(lsSerial,1) = ',' Then lsSerial = Left(lsSerial,(len(lsSerial) - 1))
					If llSerialrow = 1 Then lsSerial = "S/N: " + lsSerial /*need field label on first row */
					lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,lsserial)
				End If
		
				
				//Find the Next Child in Carton
				llPackFindRow ++
				If llPackFindRow > w_do.idw_pack.RowCount() Then
					llPAckFindRow = 0
				Else
					llPackFindRow = w_do.idw_Pack.Find(lsPackFind,llPAckFindRow, w_do.idw_pack.RowCount())
				End If
							
			Loop /*Next Pack Row for current child*/

		end if  /*Serial Number */
		
		
	FINDNEXTPICKCHILD:
		//Find the Next Child for Current parent
		llPickFindRow ++
		If llPickFindRow > w_do.idw_Pick.RowCount() Then
			lLPickFindRow = 0
		Else
			llPickFindRow = w_do.idw_Pick.Find(lsPickFind,llPickFindRow,w_do.idw_Pick.RowCount())
		End If
		
	Loop /*Next Child for current parent*/
		


	
	if ib_serialbc then //serial bc
		
			//Build Label
			
			

			
			lllabelpos = 0
			
			string ls_last_sku, ls_last_desc, ls_last_qty, ls_last_coo
				
				
		    FOR li_idx = 1 to  ldsTempSerailbc.RowCount()
					
					llLabelPosSer++
					
					
					IF li_idx = 1 OR llLabelPosSer > 4 THEN
												
						lllabelpos ++
						lslabel[lllabelpos] = lsFormat /* labels to print stored in array so we can set the label count when we're done and print all together*/


						//Set Parent Level fields on Label...
						
						//Print Date
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~print_date~~",string(today(),"mmm dd, yyyy"))
						
						//Parent SKU
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~sku~~",adw.GetITemString(llRowPos,'Item_master_SKU'))
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~sku_bc~~",'P' + adw.GetITemString(llRowPos,'Item_master_SKU'))
						
						//Delivery Note (MN Number)
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~dn_no_bc~~",Lstrparms.String_arg[23])
						
						//Parent QTY
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~qty~~",String(round(adw.GetItemnumber(llRowPos,'delivery_packing_quantity'),0)) + ' EA')
						
						
						//UPC
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~upc_bc~~",String(adw.object.item_master_part_upc_code[llRowPos]))
						
						// 03/07 - PCONKL - If Length of UPC = 13, then change to EAN barcode and change 'UPC' leteral to 'EAN'
						If Len(Trim(String(adw.object.item_master_part_upc_code[llRowPos]))) = 13 Then /*EAN*/
							lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"^FDUPC^","^FDEAN^") /*literal above barcode*/
							lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"^BUN","^^BEN") /*barcode type U=UPC, E=EAN*/
						End If  
						
						//Carton X of Y
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],"~~carton_of~~","Carton " + String(adw.GetITemNumber(llRowPos,'c_carton_of')) + " of " + String(adw.GetITemNumber(llRowPos,'c_carton_count')))
						
						llLabelPosSer = 1
										
					End IF /* New label Header */
		
					
					if llLabelPosSer <> 1 AND ls_last_sku = ldsTempSerailbc.GetItemString(li_idx, "SKU") AND &
					  ls_last_desc = ldsTempSerailbc.GetItemString(li_idx, "DESC") AND &
					  ls_last_coo = ldsTempSerailbc.GetItemString(li_idx, "COO") THEN

						//Set Child SKU info on Current Label
						lsField = "~~child_sku_" + String(llLabelPosSer) + "~~"
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,"")
						
						//Qty
						lsField = "~~qty_" + String(llLabelPosSer) + "~~"
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField, "")
						
						//COO
						lsField = "~~coo_" + String(llLabelPosSer) + "~~"
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,"")
						
						//DESC
						lsField = "~~desc_" + String(llLabelPosSer) + "~~"
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,"")
	

					else
					
						//Set Child SKU info on Current Label
						lsField = "~~child_sku_" + String(llLabelPosSer) + "~~"
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,ldsTempSerailbc.GetItemString(li_idx, "SKU"))

						string lsTempSerial, lsTempQty 
						long li_used_qty

						 lsTempSerial = ldsTempSerailbc.GetItemString(li_idx, "SERIAL")
						 lsTempQty  = ldsTempSerailbc.GetItemString(li_idx, "QTY")
						 
						 

						if ((integer(lsTempQty) + llLabelPosSer - 1) > 4) AND (Not IsNull(lsTempSerial) AND Trim(lsTempSerial) <>"") THEN
						
							li_used_qty = (4 - llLabelPosSer + 1 )
						
							//Qty
							lsField = "~~qty_" + String(llLabelPosSer) + "~~"
							lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,String(li_used_qty))
						
						    ldsTempSerailbc.SetItem((li_idx +li_used_qty) , "QTY", String(Integer(lsTempQty) - li_used_qty))
						
						
						else

							//Qty
							lsField = "~~qty_" + String(llLabelPosSer) + "~~"
							lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField, ldsTempSerailbc.GetItemString(li_idx, "QTY"))
						
					   end if
						
						
						//COO
						lsField = "~~coo_" + String(llLabelPosSer) + "~~"
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,ldsTempSerailbc.GetItemString(li_idx, "COO"))
						
					
						lsField = "~~desc_" + String(llLabelPosSer) + "~~"
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,ldsTempSerailbc.GetItemString(li_idx, "DESC"))
	
	
	
						ls_last_sku = ldsTempSerailbc.GetItemString(li_idx, "SKU")
						ls_last_desc =  ldsTempSerailbc.GetItemString(li_idx, "DESC")
						ls_last_qty = ldsTempSerailbc.GetItemString(li_idx, "QTY")
						ls_last_coo = ldsTempSerailbc.GetItemString(li_idx, "COO")
						
					end if


					if not isnull( ldsTempSerailbc.GetItemString(li_idx, "SERIAL")) and trim( ldsTempSerailbc.GetItemString(li_idx, "SERIAL")) <> "" then

						lsField = "~~serial_" + String(llLabelPosSer) + "~~" 
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField, "S/N: " + ldsTempSerailbc.GetItemString(li_idx, "SERIAL"))					
						
						lsField = "~~serial_" + String(llLabelPosSer) + "bc~~" 
						lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,ldsTempSerailbc.GetItemString(li_idx, "SERIAL"))					

					end if					
					
			NEXT 
		
		
			for li_idx = 1 to 4
			
				CHOOSE CASE li_idx
				
				CASE 1
					lsField = "^FO25,599^BY3,2.3,76^B3N,N,76,N,N^FD~~serial_1bc~~^FS"
				CASE 2
					lsField = "^FO25,775^BY3,2.3,76^B3N,N,76,N,N^FD~~serial_2bc~~^FS"					
				CASE 3
					lsField = "^FO25,946^BY3,2.3,76^B3N,N,76,N,N^FD~~serial_3bc~~^FS"											
				CAsE 4
					lsField = "^FO25,1120^BY3,2.3,76^B3N,N,76,N,N^FD~~serial_4bc~~^FS"					
				END CHOOSE	

					
				lslabel[lllabelpos] = invo_labels.uf_replace(lslabel[lllabelpos],lsField,"")					

					
			next
				

		
		
	end if //serial bc
	

	
	
	
Next /*pack row for current carton */

 
adw.SetFilter('')
adw.Filter()
adw.Sort()

//Loop through and set Carton x of y in each format - Copy to instance array - all labels will be printed together at the end
For i = 1 to Upperbound(lsLabel[])
	lsField = "~~label_of~~"
	lslabel[i] = invo_labels.uf_replace(lslabel[i],lsField,"Label  " + String(i) + " of " + String(Upperbound(lslabel[])))
	ilLabelNumber ++
	islabels[ilLabelnumber] = lsLabel[i]
Next


DESTROY ldsTempSerailbc

Return 1

end function

public function integer uf_3com_pallet_label (any as_array, datawindow adw);//This function will print 3COM Pallet labels

Str_parms	lStrparms
String	lsFormat,	&
			lsCartonBarcode,	&
			lsPrintText//,		&
//			lsAddr,ls_weight,ls_temp,	&
//			lsUCCCarton //dts, lsLabels[]
			//lsTemp,				&
			
Long	llPrintJob,	llPos, i, ll_no_of_copies
//		llPrintQty,	&
//		llPrintPos,	&
//		llCartonNo,	&
//		llAddrPos,i,j,ll_no_of_copies
		
Integer	liFileNo, liCheck

	lstrparms = as_array
	lsFormat = invo_labels.uf_read_label_Format("3COM_Zebra_Pallet.txt")
	lsPrintText = '3COM zebra Pallet'

	//lsTemp = isLabels[ilLabelNumber]

	////Format not loaded
	//If isLabels[ilLabelNumber] = '' Then Return -1

	//We are looping once for each Qty of label being printed - The carton number is changing so we need to bump after each one.
	//The rest of the fields are static through the batch so only need to be replaced once - otherwise we would have to load the format each time

	//Replace placeholders in Format with Field Values

	//BoxCount
	If lstrparms.String_Arg[1] > ' ' Then
		lsFormat = invo_labels.uf_Replace(lsFormat,"~~BoxCount~~",string(lstrparms.String_Arg[1]))
	else
		lsFormat = invo_labels.uf_Replace(lsFormat,"~~BoxCount~~",space(1))
	end if
	
	//PalletNum
	If lstrparms.String_Arg[2] > ' ' Then
		lsFormat = invo_labels.uf_Replace(lsFormat,"~~PalletNum~~",string(lstrparms.String_Arg[2]))
	else
		lsFormat = invo_labels.uf_Replace(lsFormat,"~~PalletNum~~",space(1))
	end if
	
	//PalletCount
	If lstrparms.String_Arg[3] > ' ' Then
		lsFormat = invo_labels.uf_Replace(lsFormat,"~~PalletCount~~",string(lstrparms.String_Arg[3]))
	else
		lsFormat = invo_labels.uf_Replace(lsFormat,"~~PalletCount~~",space(1))
	end if

	//Order Number
	If lstrparms.String_Arg[4] > ' ' Then
		lsFormat = invo_labels.uf_Replace(lsFormat,"~~Order~~",string(lstrparms.String_Arg[4]))
	else
		lsFormat = invo_labels.uf_Replace(lsFormat,"~~Order~~",space(1))
	end if

/*	
	//Cust No
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~sku_no,0030~~",left(lstrparms.String_Arg[14],30))//Alternate sku

	//Do no number
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~ord_no,0030~~",left(lstrparms.String_Arg[21],30))

	//Delivery Order Number
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~dn_no,0030~~",left(lstrparms.String_Arg[23],30))
	
	//Today's date 
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~today,0030~~",string(today(),"dd-mmm-yyyy"))
	
	//Carrier Name
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~carrier_name,0030~~",left(lstrparms.String_Arg[25],30))
	
	//Sales Order No
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~sales_order,0030~~",left(lstrparms.String_Arg[26],30))

	//Tracking shipper No
	isLabels[ilLabelNumber] = invo_labels.uf_replace(isLabels[ilLabelNumber],"~~tracker_id,0030~~",left(lstrparms.String_Arg[27],30))
*/
ll_no_of_copies = lstrparms.Long_Arg[1]

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return -1
End If

/*dts
	FOR i= 1 TO ll_no_of_copies
		isLabels[llPos] = invo_labels.uf_replace(isLabels[llPos],"~~tot_off,0030~~",left(lstrparms.String_Arg[28],30))
		PrintSend(llPrintJob, isLabels[llPos])	
		ls_temp= lstrparms.String_Arg[28]
	NEXT
*/
//Send to Printer 
PrintSend(llPrintJob, lsformat)

PrintClose(llPrintJob)
	
Return 0
end function

on n_3com_labels.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_3com_labels.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_labels = Create n_labels
end event

