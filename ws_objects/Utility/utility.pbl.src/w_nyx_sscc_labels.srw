$PBExportHeader$w_nyx_sscc_labels.srw
$PBExportComments$Print Generic UCCS Shipping labels
forward
global type w_nyx_sscc_labels from w_main_ancestor
end type
type cb_label_print from commandbutton within w_nyx_sscc_labels
end type
type dw_label from u_dw_ancestor within w_nyx_sscc_labels
end type
type cb_label_selectall from commandbutton within w_nyx_sscc_labels
end type
type cb_label_clear from commandbutton within w_nyx_sscc_labels
end type
end forward

global type w_nyx_sscc_labels from w_main_ancestor
integer width = 3191
integer height = 1788
string title = "Shipping Labels"
event ue_print ( )
event ue_print_ext ( )
cb_label_print cb_label_print
dw_label dw_label
cb_label_selectall cb_label_selectall
cb_label_clear cb_label_clear
end type
global w_nyx_sscc_labels w_nyx_sscc_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels

Datastore idw_content_label

String	isUCCSCompanyPrefix, isUCCSWHPrefix

String	isDONO

integer ii_total_qty_cartons, ilCartonCount
end variables

forward prototypes
public function integer uf_carton_label_dw (long albeginrow, long alendrow, long alprintjob)
end prototypes

event ue_print();Str_Parms	lstrparms

Long	llQty, llRowCount, llRowPos, ll_rtn, ll_alloc_qty, llRowPos1, llLabelCount, llLabelOf
		
Any	lsAny

String	lsCityStateZip, lsSKU, ls_format, ls_old_carton_no,ls_carton_no,ls_old_carton_no1,ls_carton_no1,	&
			lsDONO, lsCartonHold, ls_CustName		
			
Boolean lb_generic,lb_print_mixed ,lb_duplicate_carton,lb_print
long ll_tot_metrics_weight,ll_tot_english_weight,ll_cnt,ll_cnt1,ll_carton_cnt,ll_count,ll_count_prev

n_warehouse l_nwarehouse 
n_cst_common_tables ln_common_tables

Dw_Label.AcceptText()

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then Return 

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
	Lstrparms.Long_arg[1] = llQty
			
	Lstrparms.String_arg[38] =	dw_label.GetITemString(1,'delivery_Master_DO_NO')  //Jxlim 07/10/2013 Add do_no arg for passing n_labels
	
	//LstrParms.String_arg[1] = dw_label.object.customer_user_field2[llRowPos] +".DWN"// **Change Later
	Lstrparms.String_arg[2] = dw_label.GetItemString(llRowPos,'warehouse_wh_name')
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
	
	//Jxlim 07/02/2013
	//Lstrparms.String_arg[7] = dw_label.GetItemString(llRowPos,'delivery_master_Cust_name')
	ls_CustName = dw_label.GetItemString(llRowPos,'delivery_master_Cust_name')
	Lstrparms.String_arg[7] = ls_CustName
	ls_CustName = ls_CustName + ' Order No:' 
	lstrparms.String_arg[37] =ls_CustName
	
	//Jxlim 06/27/2013
	lstrparms.String_arg[36] = dw_label.GetItemString(llRowPos,'User_field2') //Customer store code ie. VST 012
	
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
		
	Lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'delivery_master_cust_order_no') /* PO NBR*/
	Lstrparms.String_arg[15] = String(dw_label.GetItemDecimal(llRowPos,'delivery_packing_packing_list_no')) /*Packing List Number (Lieferscheubnummer)*/
	
		
	//Exclusively for calculating total weight only
	ls_old_carton_no1 = dw_label.object.delivery_packing_carton_no[llRowPos]
	For llRowPos1 = llRowPos to llRowCount /*each detail row */
		
		IF dw_label.object.c_print_ind[llRowPos1] <> 'Y' THEN Continue
		ls_carton_no1= dw_label.object.delivery_packing_carton_no[llRowPos1]
		IF ls_old_carton_no1 <>  ls_carton_no1 THEN Exit
		 //It is a duplicate carton number
		 ll_cnt1++
		 
		 //BCR 14-FEB-2012: I commented out the below line of code because it causes grief if total no of rows > 4.
		 //If commenting it out causes grief in any other project, then we will need to revisit. Ran this by Pete already.
		 
//		 IF ll_cnt1 > 4 THEN Exit

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
	
	lstrparms.String_Arg[28] = String(llLabelof) +" /  " + String(llLabelCount)
	ll_tot_metrics_weight =0;ll_tot_english_weight =0
	
	// 12/03 - PCONKL - We need to pass the UCCS Prefix (Location + Company)
	//lstrparms.String_arg[35] = isuccswhprefix + isuccscompanyprefix	
	lstrparms.String_arg[35] = isuccscompanyprefix						//Jxlim 06/28/2013 NYX company prefix 7 digits
	
	//BCR 12-OCT-2011: For RUN-WORLD, Ship Date on Label should be Request Date on w_do...
	lstrparms.datetime_arg[1] = w_do.idw_main.GetItemDateTime(1, 'request_date')
	//END
	
	lsAny=lstrparms		

	invo_labels.uf_nyx_sscc_ship_label(lsAny)
	
	ls_old_carton_no =  ls_carton_no					
	 
Next /*detail row to Print*/

end event

event ue_print_ext();Str_Parms	lstrparms
n_labels	lu_labels

Long	llRowCount, llRowPos, 	llPrintJob,  llLabelPos, llBeginRow, llEndRow

String	lsPrintText, lsShipFormat, lsSKUFormat, lsCarton, lsCartonSave, lsOEMFormat, lsCustomer, lsNullLabel[]

lu_labels = Create n_labels

Dw_Label.AcceptText()

idw_content_label = CREATE datastore;
idw_content_label.dataobject = "d_nyx_sscc_ship_label_unicode_ext"
idw_content_label.Modify("DataWindow.Print.quality=1")

OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then
	Return
End If
				
lsPrintText = 'NYX SSCC Shiping Labels '

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return
End If
	
	
//Print each detail Row
llRowCount = dw_label.RowCount()
llBeginRow = 1 /*starting row of ccurent carton forcarton content labels*/

For llRowPos = 1 to llRowCount /*each detail row */
			
	If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
	
	lsCarton = dw_label.GetITEmString(llRowPos,'delivery_packing_carton_no')
	
	//If new carton, print shipping label and carton contents label (for all rows in carton)
	If lsCarton <> lsCartonSave Then
		
		llEndRow = llRowPos -1 /*ending Row of last carton*/
		
		If llEndRow > 0 Then /*carton content label for previous carton*/
		
			uf_carton_label_dw(llBeginRow, llEndRow, llPrintJob )			
			
		End If
				
	
		llBeginRow = llRowPos /*starting Row row of current carton*/
		
	End If
	
	lsCartonSave = lsCarton
			
Next /*detail row to Print*/


//Print carton content label for last/only carton
If llRowCount > 0 Then
	
	uf_carton_label_dw(llBeginRow, llRowCount, llPrintJob ) /*carton contents label*/	
			
End If	

PrintClose(llPrintJob)
		

DESTROY idw_content_label;


	


		

end event

public function integer uf_carton_label_dw (long albeginrow, long alendrow, long alprintjob);//Jxlim 07/11/2013	NYX label
String	 lsLit, lsShipDate, lsSKU, lsFromcitystatezip, lsTocitystatezip, ls_companyPref, lsCarton_no, lsUccCarton, lsUccCarton_space, lsDoNo, lsNoOfCarton
String lscartonhold, ls_carton_no
Long	llRowPos, llLabelPos, llFindRow, llpos, llBeginPos, llEndPos, llLabelcount, lllabelof
Int	liCurPos, liRowDisplayNumber, licheck, li_cur_row, liRowNumber

idw_content_label.Reset()

lsDoNo = dw_label.GetITemString(1,'delivery_Master_do_no')
lscartonHold= ''

Select Count(distinct Carton_NO) Into :llLabelCount
From Delivery_PAcking
Where do_no = :lsDONO
And Carton_No > 0
Using SQLCA;


liCurPos = 0
liRowDisplayNumber = 0

//For each row of current carton
For llRowPos = alBeginRow to alEndRow
	
	If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
	
	liCurPos ++

	li_cur_row = idw_content_label.InsertRow(0)	
	
	liRowDisplayNumber++
		
	//idw_content_label.SetItem( li_cur_row, "row_number", liRowDisplayNumber)	
	
	//Ship From
	idw_content_label.SetItem( li_cur_row, "Wh_name", dw_label.GetITemString(llRowPos,'warehouse_wh_name')) 
	idw_content_label.SetItem( li_cur_row, "from_addr1", dw_label.GetITemString(llRowPos,'warehouse_address_1'))
	idw_content_label.SetItem( li_cur_row, "from_addr2", dw_label.GetITemString(llRowPos,'warehouse_address_2'))
	idw_content_label.SetItem( li_cur_row, "from_addr3", dw_label.GetITemString(llRowPos,'warehouse_address_3'))
	idw_content_label.SetItem( li_cur_row, "from_addr4", dw_label.GetITemString(llRowPos,'warehouse_address_4'))//Compute FROM City,State & Zip
	lsFromCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_city')) Then lsFromCityStateZip = dw_label.GetItemString(llRowPos,'warehouse_city') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_state')) Then lsFromCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_state') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_zip')) Then lsFromCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_zip') + ' '	
	idw_content_label.SetItem( li_cur_row, "from_CityStateZip", lsFromCityStateZip)
	idw_content_label.SetItem( li_cur_row, "from_country", dw_label.GetITemString(llRowPos,'warehouse_country'))  
	//idw_content_label.SetItem( li_cur_row, "from_city", dw_label.GetITemString(llRowPos,'warehouse_city'))  
	//idw_content_label.SetItem( li_cur_row, "from_State", dw_label.GetITemString(llRowPos,'warehouse_state'))  
	//idw_content_label.SetItem( li_cur_row, "from_zip", dw_label.GetITemString(llRowPos,'warehouse_zip'))  		
	
	//Ship to 
	idw_content_label.SetItem( li_cur_row, "cust_name", dw_label.GetITemString(llRowPos,'delivery_master_Cust_name'))
	idw_content_label.SetItem( li_cur_row, "user_field2", dw_label.GetITemString(llRowPos,'User_field2'))
	idw_content_label.SetItem( li_cur_row, "to_addr1", dw_label.GetITemString(llRowPos,'Delivery_Master_Address_1'))  
	idw_content_label.SetItem( li_cur_row, "to_addr2", dw_label.GetITemString(llRowPos,'Delivery_Master_Address_2'))  
	idw_content_label.SetItem( li_cur_row, "to_addr3", dw_label.GetITemString(llRowPos,'Delivery_Master_Address_3'))  
	idw_content_label.SetItem( li_cur_row, "to_addr4", dw_label.GetITemString(llRowPos,'Delivery_Master_Address_4'))  				
	//Compute TO City,State & Zip
	lsToCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_City')) Then lsToCityStateZip = dw_label.GetItemString(llRowPos,'delivery_master_City') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_State')) Then lsToCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_State') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_Zip')) Then lsToCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_Zip') + ' '	
	idw_content_label.SetItem( li_cur_row, "to_CityStateZip", lsToCityStateZip)
	idw_content_label.SetItem( li_cur_row, "to_country", dw_label.GetITemString(llRowPos,'delivery_master_country'))  	
	//idw_content_label.SetItem( li_cur_row, "to_city", dw_label.GetITemString(llRowPos,'delivery_master_city'))  
	//idw_content_label.SetItem( li_cur_row, "to_state", dw_label.GetITemString(llRowPos,'delivery_master_state'))  
	//idw_content_label.SetItem( li_cur_row, "to_zip", dw_label.GetITemString(llRowPos,'delivery_master_zip'))  
	
	//idw_content_label.SetItem( li_cur_row, "Invoice_no", dw_label.GetITemString(llRowPos,'delivery_master_Invoice_no'))	
	idw_content_label.SetItem( li_cur_row, "cust_name_1", dw_label.GetITemString(llRowPos,'delivery_master_Cust_name')) //Jxlim 07/17/2013
	idw_content_label.SetItem( li_cur_row, "po_no", dw_label.GetITemString(llRowPos,'delivery_master_cust_order_no'))
	idw_content_label.SetItem( li_cur_row, "packing_list_no", dw_label.GetITemString(llRowPos,'delivery_packing_packing_list_no'))	
	
		
	//Passing the UCCS Prefix (Location + Company)
	//ls_companyPref= Trim(isuccswhprefix + isuccscompanyprefix)	
	ls_companyPref = isuccscompanyprefix	//Jxlim 06/28/2013 NYX company prefix 7 digits and without location prefix
	lsUCCCarton= Trim(ls_companyPref)

	//Carton no (SSCC-18 Label) - NYX  00 + 3 + 7 digits company prefix+9digits serial+1 digit check=18 (exclude 00)
	lsCarton_no= Trim(dw_label.GetITemString(llRowPos,'delivery_packing_carton_no'))	
	If  lsUCCCarton > '' Then		//Jxlim 06/28/2013 NYX 7 digits company prefix
		lsUCCCarton = "3" + lsUCCCarton + Right(String(Long(lsCarton_no),'000000000'),9) /*Prepend UCCS Info - 0 (future use) + Warehouse Prefix + Company Prefix) */		
		liCheck = f_calc_uccs_check_Digit(lsUCCCarton) /*calculate the check digit*/
		If liCheck >=0 Then
			lsuccCarton = "00" + lsUccCarton + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */		
		Else
			lsUccCarton = String(Long(lsCarton_no),'00000000000000000000')
		End If
	Else
		lsUccCarton = String(Long(lsCarton_no),'00000000000000000000')
	End If
	
	//SSCC  barcode
	idw_content_label.SetItem(li_cur_row, "sscc_barcode", lsUCCCarton)	//Print the SSCC-18 original 18 
	idw_content_label.SetItem( li_cur_row, "sscc", lsUCCCarton)  //Print the SSCC-18 with 00 prefix below barcode
	
	//SSCC field adding space 18 digit + space
	lsUCCCarton = Right(lsUCCCarton,18)  //18 digit
	lsUCCCarton_space = Left(lsUCCCarton,1) + " " + Mid(lsUCCCarton,2,7) + " " + Mid(lsUCCCarton,9,9) + " " + Mid(lsUCCCarton,18,1) 
	idw_content_label.SetItem( li_cur_row,"carton_no", lsUCCCarton_space)		//Print the SSCC-18 with space	

	//GWM - 5/22/2015 - Save the SSCC No to the pack list Pack_SSCC_No field.  Reported on confirmation file and shown on packlist tab
	Execute Immediate "Begin Transaction" using SQLCA;
	
		Update Delivery_Packing 
		Set Pack_SSCC_NO = :lsUccCarton
		Where DO_No = :lsDoNo and carton_no = :lsCarton_no 
		Using SQLCA;
	
	Execute Immediate "COMMIT" using SQLCA;

	//No of carton
	//Label x of y should be generated from Unique carton count instead of Number of packing rows
	//since multiple packing rows may be consolidated to 1 label. (SQL is distinct but if weights are different on packing, we'll have multiple rows)
	
	If lscartonHold <> ls_carton_no Then
		llLabelof ++
	End If
	
	lscartonHold = ls_carton_no		
	
	lsnoofCarton = String(llRowPos) +" /  " + String(llLabelCount)
	idw_content_label.SetItem( li_cur_row, "noofcarton", lsnoofcarton)

	if liCurPos >= 19 and  llRowPos < alEndRow then
		
		IF idw_content_label.RowCount() > 0 THEN
		
			PrintDataWindow ( alPrintJob, idw_content_label )
		
		END IF
	
		idw_content_label.Reset()
		liCurPos = 0
		
		
	end if	
Next

IF idw_content_label.RowCount() > 0 THEN
	PrintDataWindow ( alPrintJob, idw_content_label )
END IF

Return 0
end function

on w_nyx_sscc_labels.create
int iCurrent
call super::create
this.cb_label_print=create cb_label_print
this.dw_label=create dw_label
this.cb_label_selectall=create cb_label_selectall
this.cb_label_clear=create cb_label_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_label_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_label_selectall
this.Control[iCurrent+4]=this.cb_label_clear
end on

on w_nyx_sscc_labels.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_label_print)
destroy(this.dw_label)
destroy(this.cb_label_selectall)
destroy(this.cb_label_clear)
end on

event ue_postopen;call super::ue_postopen;

invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

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


cb_label_print.Enabled = False

If isdono > '' Then
	dw_label.Retrieve(gs_project,isdono)
End If

//BCR 07-SEP-2011: RUN-WORLD saves a 0 carton number row into Delivery_Packing. Need to filter it out.
IF gs_project  = 'RUN-WORLD' THEN
	dw_label.SetFilter("delivery_packing_carton_no > '0'")       
	dw_label.Filter()
END IF

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

type cb_cancel from w_main_ancestor`cb_cancel within w_nyx_sscc_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_nyx_sscc_labels
integer x = 1769
integer y = 24
integer height = 80
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_label_print from commandbutton within w_nyx_sscc_labels
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
//Parent.TriggerEvent('ue_Print')
Parent.TriggerEvent('ue_Print_ext')  
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_label from u_dw_ancestor within w_nyx_sscc_labels
integer x = 9
integer y = 136
integer width = 3127
integer height = 1456
boolean bringtotop = true
string dataobject = "d_nyx_sscc_ship"
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

type cb_label_selectall from commandbutton within w_nyx_sscc_labels
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

type cb_label_clear from commandbutton within w_nyx_sscc_labels
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

