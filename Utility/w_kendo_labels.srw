HA$PBExportHeader$w_kendo_labels.srw
$PBExportComments$Print kendo Shipping labels
forward
global type w_kendo_labels from w_main_ancestor
end type
type cb_label_print from commandbutton within w_kendo_labels
end type
type dw_label from u_dw_ancestor within w_kendo_labels
end type
type cb_label_selectall from commandbutton within w_kendo_labels
end type
type cb_label_clear from commandbutton within w_kendo_labels
end type
type cbx_part_labels from checkbox within w_kendo_labels
end type
end forward

global type w_kendo_labels from w_main_ancestor
integer width = 3193
integer height = 1789
string title = "Shipping Labels"
event ue_print ( )
event ue_print_carton ( )
event ue_sort ( )
cb_label_print cb_label_print
dw_label dw_label
cb_label_selectall cb_label_selectall
cb_label_clear cb_label_clear
cbx_part_labels cbx_part_labels
end type
global w_kendo_labels w_kendo_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels

Datastore idw_content_label

String	isUCCSCompanyPrefix, isUCCSWHPrefix

String	isDONO, is_sql, is_title

integer ii_total_qty_cartons, ilCartonCount

Boolean	ibUseCalculatedCartonCount, ibUserSecurityChecked


end variables
forward prototypes
protected function string uf_get_scc (readonly string ascartonno, string asdono)
public function any uf_nbr_skus (datastore adscarton)
public function string uf_replace (string asstring, string asrownbr, string assku, string asqty)
public function integer uf_total_nbr_sku (readonly datastore adslabel)
public function integer uf_print_secondary_label (any astrskuparms, any astrprintparms)
end prototypes

event ue_print_carton();Str_Parms	lstrparms
Str_Parms	lstrSkuParms

Long	llPackCopies, llCopyCount, llRowCount, llRowPos, ll_rtn, llLabelCount, llLabelOf,ll_carton_of
Long ll_rowcount,ll_Findrow,ll_Nextrow,ll_sumQty,ll_carton_count, ll_failures, ll_label_quantity
Any	lsAny
String	lsCityStateZip, lsSKU, ls_format, ls_carton_no, lsCartonPrev, 	lsDONO,  ls_CustName,ls_find, lsConsolNo, lsPrinter, lsDONOPrev, lsCustLabel, lsCustCode
String lsFilter
Int liRet, liIdx, liItems, liNbrSKUs, liTotalNbrSKUs
Long llRowPosX

n_warehouse l_nwarehouse 
boolean	lbNewCarton, lbMultipleSKU
datastore ldsThisCarton
long llPrintCount

String lsMessage		//GailM 841
ll_failures = 0



//MikeA 8/2019 S36892 F16645 - I2432 - KDO - Kendo - Supervisor Only to Reprint Carton Labels
//Added check here in case they are printing from this window and not coming from w_do.

if Not ibUserSecurityChecked then

	lsDONO = w_do.idw_Main.GetITEmString(1,'do_no')
	
	//Only ad Admin or Super can re-print if already printed once
	Select carton_label_Print_Count Into :llPrintCount From delivery_master with (NOLOCK) Where do_no = :lsDONO;
	
	If IsNull(llPrintCount) Then llPrintCount = 0
	
	If llPrintCount > 0 Then
		If gs_role = "2" Then
			MessageBox("Labels", "Only an ADMIN or SUPER can re-print labels!",StopSign!)
			Return
		End If
	End If
End If



//GailM 2/1/2019 S28941 F13496 - I2134 - KDO - Kendo - MIXED Term on Labels with Multiple SKUs
ldsThisCarton = Create u_ds_ancestor
ldsThisCarton.dataobject = "d_kendo_ship"
ldsThisCarton.SetTransObject(SQLCA)
dw_label.RowsCopy(1, dw_label.RowCount(), Primary!, ldsThisCarton, 1, Primary!)

//Check the customer master for any customer specific labels. we will only have custer master recrds for these customers
lsCustCode = w_do.idw_Main.GetITemString(1,'cust_Code')

Select User_Field1 into :lsCustLabel
From Customer
Where project_id = 'KENDO' and Cust_Code = :lsCustCode;

If isnull(lsCustCode) Then lsCustCode = ""

//GailM 2/1/2019 S28941 - Need total quantity for order
liTotalNbrSKUs = uf_total_nbr_sku(ldsThisCarton)

ldsThisCarton.Reset()
dw_label.RowsCopy(1, dw_label.RowCount(), Primary!, ldsThisCarton, 1, Primary!)

Dw_Label.AcceptText()

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

//  If we have a default printer for Kendo Labels, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','KENDOLABELS','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)
 	
OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then Return 

lsDoNo = dw_label.GetITemString(1,'delivery_Master_do_no')
lsConsolNo = dw_label.GetITemString(1,'C_Consolidation_no') /* may have "*" in consolidation no if we have split it into multiple shipments*/
ls_CustName = dw_label.GetItemString(1,'delivery_master_cust_name') 

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	lsDoNo = dw_label.GetITemString(llRowPos,'delivery_Master_do_no')
	ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]
	lbNewCarton = False
	lbMultipleSKU = False
	
	//Reset "Box Of" For each new order
	If lsDONO <> lsDONOPrev Then
		ll_carton_of = 1
		lbNewCarton = True
	ElseIf ls_carton_no <> lsCartonPrev Then /*may have multiple rows per carton*/
		lbNewCarton = True
		ll_carton_of ++
	End If
		
	lsConsolNo = dw_label.GetITemString(llRowPos,'C_Consolidation_no')
	ls_CustName = dw_label.GetItemString(llRowPos,'delivery_master_cust_name') 

	lsDONOPrev = lsDONO
	lsCartonPrev = ls_carton_no
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	ll_label_quantity = dw_label.object.c_print_qty[llRowPos]
	If Upperbound(lstrParms.Long_arg) > 0 Then
		lstrParms.Long_arg[1] = ll_label_quantity
	End If
		
	// 12/16 - PCONKL - Print any customer specific labels if necessary - may print both - We may change this to be by cust code instead of name containing
	lstrparms.String_Arg[38] = lsCustLabel
	
//	If pos(Upper(dw_label.GetItemString(llRowPos,'delivery_master_cust_name')),'NEIMAN') > 0 Then
//		lstrparms.String_Arg[38] = "NM"
//	ElseIf pos(Upper(dw_label.GetItemString(llRowPos,'delivery_master_cust_name')),'JCP') > 0 Then
//		lstrparms.String_Arg[38] = "JCP"
//	ElseIf pos(Upper(dw_label.GetItemString(llRowPos,'delivery_master_cust_name')),'SEPHORA') > 0 Then
//		lstrparms.String_Arg[38] = "SEP"
//	End If
	
	
	//If printing a customer SSCC label and SSCC Number not generated, generate now - should only be generated if re-printing
	//For Kendo, not being generated based on existing carton nbr since they be assigning a random carton number on the mobile device
	
	If lstrparms.String_Arg[38] > "" and lbNewCarton Then /* Customer SSCC label being printed*/
		
		If dw_label.GetItemString(llRowPos,'delivery_packing_pack_sscc_no')  > '' Then
			Lstrparms.String_arg[36] = dw_label.GetItemString(llRowPos,'delivery_packing_pack_sscc_no')
		Else
			Lstrparms.String_arg[36] = uf_get_scc(ls_carton_no,lsDONO)
		End If
	
		//Update Delivery Packing with SSCC No
		If Lstrparms.String_arg[36] > '' Then
			
			Execute Immediate "Begin Transaction" using SQLCA;
		
			Update Delivery_Packing
			Set Pack_sscc_no = :Lstrparms.String_arg[36]
			Where do_no = :lsDONO and Carton_no = :ls_carton_no
			Using SQLCA;
		
   			If SQLCA.SQLCode = 0 Then	//GailM - 09/15/2017 - SIMSPEVS-841 - KDO not all SSCC numbers are being processed successfully
				Execute Immediate "COMMIT" using SQLCA;
				lsMessage = "SSCC No " + Lstrparms.String_arg[36] + " inserted into pack list for carton No: " + ls_carton_no + "."
				f_method_trace_special( gs_project, this.ClassName() + ' - ue_print_carton',lsMessage ,lsDONO, ' ',' ',lsDONO)  //21-Sep-2017  :GailM added
   			Else /*commit failed*/
				Execute Immediate "ROLLBACK" using SQLCA;
				lsMessage = "Unable to save SSCC No " +  Lstrparms.String_arg[36] +  " to Packing List for carton No " + ls_carton_no + " : ~n~rError: " + SQLCA.SQLErrText
				f_method_trace_special( gs_project, this.ClassName() + ' - ue_print_carton',lsMessage ,lsDONO, ' ',' ',lsDONO)  //21-Sep-2017  :GailM added
				ll_failures ++		// Capture number of failures to report to user.  Save all failures to method trace log.
			End If

		End If
		
		dw_label.SetItem(llRowPos,'Delivery_Packing_Pack_sscc_No',Lstrparms.String_arg[36])
		
	End If /* Customer SSCC label being printed*/
	
	//GailM 2/1/2019 S28941 F13496 - I2134 - KDO - Kendo - MIXED Term on Labels with Multiple SKUs
	lsFilter = "delivery_packing_carton_no = '" + ls_carton_no + "' "
	ldsThisCarton.SetFilter( lsFilter )
	liRet = ldsThisCarton.Filter()
	If liRet = 1 Then
		liItems = ldsThisCarton.rowcount()
		If liItems > 1 Then
			lstrSkuParms = uf_nbr_skus(ldsThisCarton) 
			liNbrSKUs = Upperbound(lstrSkuParms.String_Arg)
			If liNbrSKUs > 1 Then
				liRet = uf_print_secondary_label(lstrSkuParms, lstrParms)
				lbMultipleSKU = TRUE
			End If
			llRowPosX = llRowPos + liItems - 1		//Skip all rows for this carton and process the carton with two labels
		End If
	Else
		MessageBox("Filter Error","Could not filter this carton")
	End If
	
	Lstrparms.String_arg[37] = ls_carton_no
	
	Lstrparms.String_arg[18] =	lsDONO
	Lstrparms.String_arg[19] =	lsConsolNo
	
	//Ship From
	Lstrparms.String_arg[2] = dw_label.GetItemString(llRowPos,'warehouse_wh_name')
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
	
	Lstrparms.String_arg[11] = dw_label.GetItemString(llRowPos,'delivery_master_cust_order_no') /* PO NBR*/
	
	//GailM 2/1/2019 S28941 F13496 - I2134 - KDO - Kendo - MIXED Term on Labels with Multiple SKUs
	//GailM 4/16/2019 S32180 - Added new requirements - BatchNo, MTF Date MIXED and remove EXP Date
	If lbMultipleSKU Then
		Lstrparms.String_arg[20] = "MIXED"	 	/* Sku */
		Lstrparms.String_arg[27] = "MIXED"	 	/* Description */
		Lstrparms.String_arg[21] = "   MIXED"	/* UPC  (move to the right for proper placement*/
		Lstrparms.String_arg[18] = "MIXED"	 	/* MTF Date */
		Lstrparms.String_arg[19] = "          "		/* EXP Date */
		Lstrparms.String_arg[28] = "MIXED"		/* Lot No (Batch Code)*/
		Lstrparms.String_arg[62] = String(liTotalNbrSKUs)	/* Number of SKUs in the Pick List (dw_label) */
	Else
		Lstrparms.String_arg[20] = dw_label.GetItemString(llRowPos,'sku') /* Sku*/
		Lstrparms.String_arg[27] = dw_label.GetItemString(llRowPos,'description') /*Description*/
		Lstrparms.String_arg[21] = String(dw_label.GetItemNumber(llRowPos,'part_upc_Code')) /*UPC*/
		Lstrparms.String_arg[18] = String(dw_label.GetItemDateTime(llRowPos,'lot_control_manufacture_date'),'MM/DD/YYYY') /* Manufacture Date*/
		Lstrparms.String_arg[19] = String(dw_label.GetItemDateTime(llRowPos,'delivery_packing_pack_expiration_date'),'MM/DD/YYYY') /* Exp Date*/
		Lstrparms.String_arg[28] = dw_label.GetItemString(llRowPos,'delivery_packing_pack_lot_no') /* Lot No (Batch Code)*/
		Lstrparms.String_arg[62] = String(dw_label.GetItemNumber(llRowPos,'Quantity'))
	End if
	
	Lstrparms.String_arg[23] = dw_label.GetItemString(llRowPos,'c_consolidation_no') /* Sales Order  */
		
	// 12/16 - PCONKL - Added new fields for NM, JCP and Sephora SSCC labels
	Lstrparms.String_arg[24] = dw_label.GetItemString(llRowPos,'delivery_Detail_department_name') /*  Department*/
	Lstrparms.String_arg[25] = dw_label.GetItemString(llRowPos,'delivery_Detail_division') /*  Division*/
	Lstrparms.String_arg[26] = dw_label.GetItemString(llRowPos,'delivery_Detail_mark_for_name') /*  Store*/
	Lstrparms.String_arg[29] = dw_label.GetItemString(llRowPos,'delivery_Detail_vendor_part') /*  Vendor part*/
	Lstrparms.String_arg[30] = dw_label.GetItemString(llRowPos,'delivery_packing_Pack_sscc_no') /*  Vendor part*/
	Lstrparms.String_arg[31] = dw_label.GetItemString(llRowPos,'delivery_master_awb_bol_no') /*  BOL*/
	Lstrparms.String_arg[32] = dw_label.GetItemString(llRowPos,'delivery_master_carrier_pro_no') /*  Carrier Pro*/
	Lstrparms.String_arg[35] = dw_label.GetItemString(llRowPos,'delivery_master_carrier') /*  Carrier */
	Lstrparms.String_arg[39] = dw_label.GetItemString(llRowPos,'delivery_detail_user_field7') /*  Size */
	Lstrparms.String_arg[40] = dw_label.GetItemString(llRowPos,'delivery_detail_user_field8') /*  Color */
	Lstrparms.String_arg[41] = dw_label.GetItemString(llRowPos,'delivery_detail_supp_code') /*  18-JUNE-2017 :Madhu PEVS-651 Added Supp Code  */
			
	//Carton X of Y
	
//	If dw_label.Find("delivery_packing_carton_no = 'MASTER'",1, dw_label.RowCount()) > 0 Then /* Don't include master label in count */
//		lstrparms.String_Arg[34] = String(llRowPos) +" OF " + String(llRowCount - 1)
//	Else
//		lstrparms.String_Arg[34] = String(llRowPos) +" OF " + String(llRowCount)
//	End If
		
	// 08/16 - PCONKL - If we are printing as inserting rows in W_DO, we have to use a calculated carton count since we don't have a complete Pack List yet
	//						If we use a generated Pack and all are there, use the generated (Computed field) count
	//						W_DO will set ibUseCalculatedCartonCount to true when printing as inserting pack lines
	
	If ibUseCalculatedCartonCount Then
		lstrparms.String_Arg[34] = String(ll_carton_of) +" OF " + String(w_do.idw_main.GetITemNumber(1,'ctn_cnt'))
	Else
		lstrparms.String_Arg[34] = String(ll_carton_of) +" OF " + String(dw_label.GetItemNumber(llRowPos,'c_carton_count'))
	End If
	
	lsAny=lstrparms		
	invo_labels.setparms( lsAny )

	if lstrparms.String_Arg[38]  > "" and lbNewCarton Then /*Only one per carton...*/
		invo_labels.uf_kendo_customer_ucc(lsAny)
	End If
	
	//TODO - We may not print the generic label if we are printing a customer one
	invo_labels.uf_kendo_ship(lsAny)
				
	If lbMultipleSKU Then
		For liIdx = llRowPos to llRowPosX
			dw_label.SetITem(liIdx,'c_print_ind','N')	 
		Next
		llRowPos = llRowPosX		//Skip to next carton
	Else
		dw_label.SetITem(llRowPos,'c_print_ind','N')	 
	End If
		
Next /*detail row to Print*/



//GailM 08/08/2017 SIMSPEVS-537 - SIMS to provide advance ESD cutoff configuration via GUI  Cut_Off_Time
If ll_failures > 0 Then
	lsMessage = "There have been " + String(ll_failures) + " SSCC numbers that did not save to the database. ~n~rInformation has been captured.  Please report this to System Administrator for action."  
	MessageBox( is_title, lsMessage )
End If


//MikeA 8/2019 S36892 F16645 - I2432 - KDO - Kendo - Supervisor Only to Reprint Carton Labels
//Set when their session is done if they have printed labels.

if Not ibUserSecurityChecked  then
	
	lsDONO = w_do.idw_Main.GetITEmString(1,'do_no')
	
	Execute Immediate "Begin Transaction" using SQLCA; 
	
	Update Delivery_master
	Set carton_label_Print_Count = ( :llPrintCount + 1 ) where Do_no = :lsDONO;
	
	Execute Immediate "COMMIT" using SQLCA;
	
End IF

// We want to store the last printer used for Printing the Kendo label for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','KENDOLABELS',lsPrinter)

end event

event ue_sort();String	lsSort

SetNull(lsSort)
dw_label.SetSort(lsSort)
dw_label.Sort()
end event

protected function string uf_get_scc (readonly string ascartonno, string asdono);//For Kendo, not basing SSCC on carton number since they might be assigning a random value on the mobile device
//We will just the current Max and bump it up
//GailM - 11/24/2017 - Add WH UCC Prefix to 8 digit project ucc company prefix to have a 9-digit prefix

String lsCartonNo ,lsUCCS,lsDONO,lsOutString,lsDelimitChar, lsMaxSSCC, lsCartonSSCC
String lsWhCode, lsWHuccPrefix
Long llCartonNo,liCheck

//lsCartonNo = asCartonNo 
lsDONO = asDono
lsDelimitChar = char(9)

//                                                lsCartonNo = idsdoPack.GetItemString(llRowPos, 'Carton_No')
IF IsNull(isUCCSCompanyPrefix) or isUCCSCompanyPrefix = '' Then
	SELECT Project.UCC_Company_Prefix 
	INTO :isUCCSCompanyPrefix 
	FROM Project 
	WHERE Project_ID = :gs_project USING SQLCA;
	
End If

IF IsNull(isUCCSCompanyPrefix) Then isUCCSCompanyPrefix = '00000000'

IF len( isUCCSCompanyPrefix ) = 8 Then
	
	SELECT DM.wh_code
	INTO :lsWhCode 
	FROM delivery_master DM with ( NOLOCK )
	WHERE DM.do_no = :lsDONO USING SQLCA;
	
	//Prefix can be 1 to 3 characters.  At his point, we will only use the first digit.  (11/17)
	//GailM 11/30/2017 - Use 2 character from ucc_location_prefix to provide for 10-digit company prefix
	SELECT WH.ucc_location_prefix
	INTO :lsWHuccPrefix 
	FROM warehouse WH
	WHERE WH.wh_code = :lsWHCode USING SQLCA;
	
	If IsNull( lsWHuccPrefix ) or NOT IsNumber( lsWHuccPrefix) Then lsWHuccPrefix = '00'
	If Len( lsWHuccPrefix ) = 1 Then lsWHuccPrefix += "0"

	isUCCSCompanyPrefix = isUCCSCompanyPrefix + lsWHuccPrefix
	
End If

//Get the Current Max SSCC 
Select Max(pack_sscc_no) into :lsMaxSSCC
From Delivery_Packing
Where do_no = :lsDONO
using SQLCA;

If isNull(lsMaxSSCC) Then lsMaxSSCC = ""

If lsMaxSSCC = "" Then
	
	//First SSCC for Order, calculate as last 5 of do_no + 4 Char Sequence
	//Changed 11/17 Use right 4 characters from lsDONO and 4 characters for sequence numer
	//GailM 11/30/2017 - Use right 4 characters from lsDONO to allow 9999 unique SSCC for year and 3 character sequence no for 999 unique SSCC per order
	lsCartonNo = right(lsDONO, 4 ) + "001"
	
Else /* bump up sequential portion and format new SSCC */
	
	lsCartonSSCC = Mid(lsMaxSSCC,13,7 ) /* strip off company prefix and check digit*/
	llCartonNo = long(lsCartonSSCC)
	llCartonNo ++
	lsCartonNo =string(llCartonNo, '0000000' ) 	//Reduced from 9 to 7 when using warehouse 2-digit prefix  11/17
		 
End If

lsUCCS =  trim((isUCCSCompanyPrefix +  lsCartonNo))
liCheck = f_calc_uccs_check_Digit(lsUCCS) 															

If liCheck >=0 Then
   		lsUCCS = "00" + lsUCCS + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
Else
	lsUCCS = "00" + String(lsUCCS, '00000000000000000000') + "0"
End IF
	
	/* per Ariens, The base is $$HEX1$$1820$$ENDHEX$$0000751058000000000N$$HEX2$$18202000$$ENDHEX$$where N is the check digit.
     lsUCCS must be 17 digits long....
    using 00751058 for Company code, preceding that by '00' so need 10 digits for serial of carton
    using last 5 of do_no and then carton numbers, formatted to 4 digits
    */
	 
//    //the string function to pad 0's for the carton number doesn't work (returning only '0000')
//    liCartonNo = long(lsCartonNo)
//  // lsCartonNo = right(lsDONO, 5) + string(liCartonNo, '00000') 
//   lsCartonNo =string(liCartonNo, '000000000') 
//   lsUCCS =  trim((isUCCSCompanyPrefix +  lsCartonNo))
//	
//   //From BaseLine
//   liCheck = f_calc_uccs_check_Digit(lsUCCS) 
//   If liCheck >=0 Then
//   		lsUCCS = "00" + lsUCCS + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
//   Else
//     	lsUCCS = "00" + String(lsUCCS, '00000000000000000000') + "0"
//   End IF
//   
//	lsOutString += lsUCCS  + lsDelimitChar
	
//end if

Return lsUCCS
end function

public function any uf_nbr_skus (datastore adscarton);Int liNbrSkus = 0
Int liRows, liRow, liCtrlRow
Long llQty
String lsSKU, lsPrevSKU, lsSort
Str_parms	lStrparms

lsSort = "SKU A"
adsCarton.SetSort(lsSort)
adsCarton.Sort()

liRows = adsCarton.RowCount()
For liRow = 1 to liRows
	lsSKU = adsCarton.GetItemString(liRow, "SKU")
	llQty = adsCarton.GetItemNumber(liRow,'quantity')
	If lsSKU <> lsPrevSKU Then
		liNbrSkus ++
		liCtrlRow = liRow
		lStrparms.String_arg[liRow] = lsSKU
		lStrparms.Integer_arg[liRow] = llQty
		lsPrevSKU = lsSKU
	Else
		lStrparms.Integer_arg[liCtrlRow] = lStrparms.Integer_arg[liCtrlRow] + llQty
	End If
Next

Return lStrparms
end function

public function string uf_replace (string asstring, string asrownbr, string assku, string asqty);String lsString, lsRow, lsSku, lsQty
Long llPos

If isNull(asRowNbr) Then Return asString

lsRow = "xrowx"
lsSku = "xskux"
lsQty = "xqtyx"

lsString = asString
llPos = Pos(lsString, lsRow)
  Do While llPos > 0 
	lsString = Replace(lsString,llPos, len(lsRow), asRowNbr) 
	llPos = Pos(lsString,lsRow)
Loop

llPos = Pos(lsString, lsSku)
lsString = Replace( lsString, llPos, len(lsSku), asSku)
llPos = Pos(lsString, lsQty)
lsString = Replace( lsString, llPos, len(lsQty), asQty)

Return lsString
end function

public function integer uf_total_nbr_sku (readonly datastore adslabel);Int liNbrSkus, liRow, liRows
String lsSort, lsSKU, lsPrevSKU
datastore lds

lds = adsLabel

lsSort = "SKU A"
lds.SetSort(lsSort)
lds.Sort()

liRows = lds.RowCount()
For liRow = 1 to liRows
	lsSKU = lds.GetItemString(liRow, "SKU")
	If lsSKU <> lsPrevSKU Then
		liNbrSkus ++
		lsPrevSKU = lsSKU
	End If
Next

lds.SetSort("")
lds.Sort()
//destroy lds

Return liNbrSkus
end function

public function integer uf_print_secondary_label (any astrskuparms, any astrprintparms);Int liRet, liNbrSKUs, liRow, liLabelRow, liThisRow, i
Str_Parms	lstrSkuParms, lstrPrintParms
Long llPrintJob, llRowsPerLabel, llNbrOfCopies
String lsLabel, lsLabelHeader, lsLabelBody, lsLabelFooter, lsPrintText
String lsLabelRow, lsLabelSku, lsLabelQty, lsLabelText

llRowsPerLabel = 25
liThisRow = 0
lsLabelHeader = "^XA^CI0^LL203^MD0^PMN^JZY^PR2^FO75,76^A0N,28,34^FDSKU Number          Quantity^FS"

//lsLabelHeader = "^XA^JMA^FS^CON^XZ^XA^IDR:*.*^XZ^XA^MCY^XZ^XA^CI0^LL203^MD0^PMN^JZY^PR2^FO31,76^A0N,28,34^FDSKU Number         Quantity^FS"
lsLabelBody = "^FO76,xrowx^A0N,25,30^FDxskux^FS^FO350,xrowx^A0N,25,30^FDxqtyx^FS"
lsLabelFooter = "^FO^AA^FD ^FS^PQ1,0,1,Y^XZ"

lsLabel = lsLabelHeader
liLabelRow = 85
lstrSkuParms = astrSkuParms
lstrPrintParms = astrPrintParms
liNbrSKUs = Upperbound(lstrSkuParms.String_Arg)
For liRow = 1 to liNbrSKUs
	liThisRow ++
	liLabelRow = liLabelRow + 40
	lsLabelRow = String(liLabelRow)
	lsLabelSku = lstrSkuParms.String_arg[liRow]
	lsLabelQty = String(lstrSkuParms.Integer_arg[liRow])
	
	lsLabelText = uf_replace( lsLabelBody, lsLabelRow, lsLabelSku, lsLabelQty )
	lsLabel = lsLabel + lsLabelText
	
	If liThisRow = llRowsPerLabel Or liRow = liNbrSKUs Then
		lsLabel = lsLabel + lsLabelFooter
		llPrintJob = PrintOpen(lsPrintText)
		If llPrintJob <0 Then 
			Messagebox('Kendo Secondary Labels', 'Unable to open Printer file. Labels will not be printed')
			Return -1
		End If
		
		//No of copies
		llNbrOfCopies = lstrPrintParms.Long_Arg[1]
		FOR i= 1 TO llNbrOfCopies
			PrintSend(llPrintJob, lsLabel)	
		NEXT
		
		PrintClose(llPrintJob)
		lsLabel = lsLabelHeader
		liLabelRow = 85
		liThisRow = 0
	End If
	
Next

Return liRet
end function

on w_kendo_labels.create
int iCurrent
call super::create
this.cb_label_print=create cb_label_print
this.dw_label=create dw_label
this.cb_label_selectall=create cb_label_selectall
this.cb_label_clear=create cb_label_clear
this.cbx_part_labels=create cbx_part_labels
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_label_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_label_selectall
this.Control[iCurrent+4]=this.cb_label_clear
this.Control[iCurrent+5]=this.cbx_part_labels
end on

on w_kendo_labels.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_label_print)
destroy(this.dw_label)
destroy(this.cb_label_selectall)
destroy(this.cb_label_clear)
destroy(this.cbx_part_labels)
end on

event ue_postopen;call super::ue_postopen;

invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

is_sql = dw_label.GetSQLSelect()

cb_label_print.Enabled = False
cbx_part_labels.checked = False

is_title = This.title

//We will either print from W_DO or W_Batch_Pick
//If isVAlid(w_do) Then
//	if w_do.idw_main.RowCOunt() > 0 Then
//		isDoNo = w_do.idw_main.GetITemString(1,'do_no')
//	End If
// If

//If isNUll(isDONO) or  isDoNO = '' Then
//	Messagebox('Labels','You must have an order retrieved in the Delivery Order Window~rbefore you can print labels!')
//Else
//	This.TriggerEvent('ue_retrieve')
//End If

If isValid(w_do) or isvalid(w_batch_Pick) Then
	This.TriggerEvent('ue_retrieve')
Else
	Messagebox('Labels','You must have an order retrieved in the Delivery Order Window or Batch Pick Window~rbefore you can print labels!')
end If



end event

event ue_retrieve;call super::ue_retrieve;String		lsWhere, lsModify, lsNewSql
Long		llPos



cb_label_print.Enabled = False

//If coming from W_DO, retrieve for DO_NO, If coming from batch_pick, retrieve for all DO_No's for BAtch Pick ID
If isValid(W_DO) Then
	lsWhere = " and Delivery_Master.do_no = '" + w_do.idw_main.GetITemString(1,'do_no') + "' "
Else /* batch Pick*/
	lsWhere = " and Delivery_Master.do_no in (select do_no from Delivery_Master where Project_id = '" + gs_Project + "'  and batch_pick_id = " + String(w_batch_Pick.idw_Master.GetItemNumber(1,'batch_pick_id')) + ") "
End If

lsNewSql  = is_sql

llPos = Pos(lsNewSql,'Group By')

If llPos > 0 Then
	lsNewSql = replace(lsNewSql,llPos - 1,1,lsWhere)
End If

lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
dw_label.Modify(lsModify)	

dw_label.Retrieve()

//If isdono > '' Then
//	dw_label.Retrieve(gs_project,isdono)
//End If


If dw_label.RowCOunt() > 0 Then
Else
	Messagebox('Labels','Order Not found or Packing List not yet generated!')
	Return
End If



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

event close;call super::close;long llPrintCount
string lsDONO

IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)


end event

event open;
// Ancestor overriden - Need to trigger the retrieval instead of post

This.TriggerEvent("ue_postOpen") 
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_kendo_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_kendo_labels
integer x = 1872
integer y = 29
integer height = 80
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_label_print from commandbutton within w_kendo_labels
integer x = 947
integer y = 29
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

event clicked;Parent.Triggerevent( 'ue_print_carton')
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_label from u_dw_ancestor within w_kendo_labels
integer x = 7
integer y = 141
integer width = 3127
integer height = 1456
boolean bringtotop = true
string dataobject = "d_kendo_ship"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;
If upper(dwo.Name) = 'C_PRINT_IND' and data = 'Y' Then cb_label_print.Enabled = True
end event

type cb_label_selectall from commandbutton within w_kendo_labels
integer x = 33
integer y = 29
integer width = 336
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

type cb_label_clear from commandbutton within w_kendo_labels
integer x = 391
integer y = 29
integer width = 336
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

type cbx_part_labels from checkbox within w_kendo_labels
boolean visible = false
integer x = 2373
integer y = 29
integer width = 647
integer height = 77
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

