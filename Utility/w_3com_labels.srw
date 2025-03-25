HA$PBExportHeader$w_3com_labels.srw
$PBExportComments$Shipping labels for Nike Golf
forward
global type w_3com_labels from w_main_ancestor
end type
type cb_print from commandbutton within w_3com_labels
end type
type dw_label from u_dw_ancestor within w_3com_labels
end type
type cb_selectall from commandbutton within w_3com_labels
end type
type cb_clear from commandbutton within w_3com_labels
end type
end forward

global type w_3com_labels from w_main_ancestor
boolean visible = false
integer width = 3552
integer height = 1960
string title = "3Com Shipping Labels"
string menuname = ""
event ue_print ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_clear cb_clear
end type
global w_3com_labels w_3com_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
n_3com_labels	invo_3com_labels

String	isUCCSCompanyPrefix, isUCCSWHPrefix

String	isDONO

Boolean	ibReady

string isChangedColumn
integer iiChangedRow
boolean ibNotNumber
end variables

event ue_print();Str_Parms	lstrparms

Long	llQty,	&
		llRowCount,	&
		llRowPos, &
		ll_rtn, &
		ll_alloc_qty,llRowPos1
		
Any	lsAny

String	lsCityStateZip, ls_format, ls_old_carton_no,ls_carton_no,ls_old_carton_no1,ls_carton_no1, lsPrinter,	&
			lsFind, lsBoxCount, lsWHName
			
Boolean lb_generic,lb_print_mixed ,lb_duplicate_carton,lb_print
long ll_cnt,ll_cnt1,ll_carton_cnt,ll_count,ll_count_prev, llFindRow, llCartonpos, llCartonCount
Decimal	ld_tot_metrics_weight,ld_tot_english_weight

integer liRow

n_warehouse l_nwarehouse 
n_cst_common_tables ln_common_tables

dw_label.Setredraw(False)
Dw_Label.AcceptText()

// 09/04 - PCONKL - Don't prompt for printer if coming from routine to print all docs behind the scenes
If g.ibNoPromptPrint = True Then lb_print = True

//// 09/04 - PCONKL - See if we have a default label printer stored in the .ini file
//lsPrinter = ProfileString(gs_iniFile,'PRINTERS','SHIPLABEL','')
//If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

//Count the total unique Cartons
FOR ll_count= 1 TO dw_label.RowCount()
	
	IF dw_label.object.c_print_ind[ll_count] <> 'Y' THEN Continue
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

//Print each detail Row
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	ll_alloc_qty = dw_label.GetItemNumber(llRowPos,'delivery_detail_alloc_qty')
	
	If ll_alloc_qty = 0 Then Continue
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]
	llQty = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
	Lstrparms.Long_arg[1] = llQty
	IF ls_old_carton_no=  ls_carton_no THEN 
		lb_duplicate_carton = TRUE			
	ELSE
		lb_duplicate_carton = False
		ll_cnt++
//		IF ll_cnt > 4 THEN Continue
	END IF	
//		lstrparms.Long_arg[1] = llQty/*default qty on print options*/
		
	IF Not lb_print THEN /*only need to prompt once*/
		
		OpenWithParm(w_label_print_options,lStrParms)
		Lstrparms = Message.PowerObjectParm		  
		If lstrParms.Cancelled Then Exit
		lb_print = True			
		 
	END IF
		  
	LstrParms.String_arg[1] = dw_label.object.customer_user_field2[llRowPos] +".DWN"// **Change Later
	
	// 04/04 - PCONKL - Changed Ship From to Warehouse Table instead of Project Table
	//01/08 - PCONKL - If Tipping Point, need to replace 3COM with Tipping Point in Warehouse Name
	
	lsWHName = dw_label.GetItemString(llRowPos,'warehouse_wh_name')
	If w_do.idw_main.GetITemString(1,'ord_type') = 'P' /*Tipping Point */ Then
		If Pos(Upper(lsWhName),'3COM') > 0 Then
			lsWhName = Replace(lsWhName,Pos(Upper(lsWhName),'3COM'),4,'TippingPoint')
		End If
	End If
		
	//Lstrparms.String_arg[2] = dw_label.GetItemString(llRowPos,'warehouse_wh_name')
	Lstrparms.String_arg[2] = lsWHName
	
	Lstrparms.String_arg[3] = dw_label.GetItemString(llRowPos,'warehouse_address_1')
	Lstrparms.String_arg[4] = dw_label.GetItemString(llRowPos,'warehouse_address_2')
	Lstrparms.String_arg[5] = dw_label.GetItemString(llRowPos,'warehouse_address_3')
	Lstrparms.String_arg[31] = dw_label.GetItemString(llRowPos,'warehouse_address_4')
		
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
		//Lstrparms.String_arg[12] = String(Long(dw_label.object.delivery_packing_carton_no[llRowPos]),'000000000')
		/* dts - 8/06/04 - 8-char Cartons were being formatted to 9 chars, and then
		    comparison in n_labels.of_mixed_skus was failing.
			 Not sure why the 'String' of the 'Long' conversion was in place, but removing it 
			 appears to work.  */
		Lstrparms.String_arg[12] = dw_label.object.delivery_packing_carton_no[llRowPos]
	Else
		dw_label.object.delivery_packing_carton_no[llRowPos]
	End If
	
	// 01/05 - PCONKL - Cust PO should be coming at the detail (UF5) level now, set from header if not present on Detail
	If dw_label.object.dd_user_field5[llRowPos] > '' Then
		Lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'dd_user_field5')
	Else
		Lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'delivery_master_cust_order_no') /* PO NBR*/
	End If
		
	Lstrparms.String_arg[14] = dw_label.object.delivery_detail_alternate_sku[llRowPos] 
	Lstrparms.String_arg[15] = String(Round(dw_label.object.delivery_packing_quantity[llRowPos],0))
	IF ln_common_tables.of_select_contry_master( dw_label.object.delivery_master_country[llRowPos]) = 1 THEN
		Lstrparms.String_arg[16] = ln_common_tables.is_country_name
	END IF	
	
	// 02/05 - PCONK - Invoice # on label is really Sales Order Number - now set below since it should be coming from deltail level isntead of header
	//Lstrparms.String_arg[17] = dw_label.object.delivery_master_invoice_no[llRowPos]
	
	Lstrparms.String_arg[18] = dw_label.object.item_master_sku[llRowPos] 
	Lstrparms.String_arg[19] = dw_label.object.item_master_description[llRowPos] 
	Lstrparms.String_arg[20] = dw_label.object.delivery_packing_country_of_origin[llRowPos]
	Lstrparms.String_arg[21] = dw_label.object.delivery_master_do_no[llRowPos]
	Lstrparms.String_arg[22] = dw_label.object.delivery_master_user_field5[llRowPos]// To check OEM Labels or not
	Lstrparms.String_arg[23] = dw_label.object.delivery_master_user_field6[llRowPos] //delivery Order
	Lstrparms.String_arg[24] = String(dw_label.object.item_master_part_upc_code[llRowPos]) //upc Code
	IF ln_common_tables.of_select_carrier_master(dw_label.object.delivery_master_carrier[llRowPos]) = 1 THEN
		Lstrparms.String_arg[25] = ln_common_tables.is_carrier_name //Carrier Name
	END IF	
	
	// 01/05 - PCONKL - Sales Order should be coming at the detail (UF4) level now, set from header if not present on Detail
	If dw_label.object.dd_user_field4[llRowPos] > '' Then
		Lstrparms.String_arg[26] = dw_label.object.dd_user_field4[llRowPos] //Sales Order No
		Lstrparms.String_arg[17] = dw_label.object.dd_user_field4[llRowPos]
	Else
		Lstrparms.String_arg[26] = dw_label.object.delivery_master_user_field4[llRowPos] //Sales Order No
		Lstrparms.String_arg[17] = dw_label.object.delivery_master_user_field4[llRowPos] 
	End If
	
	Lstrparms.String_arg[27] = dw_label.object.delivery_packing_shipper_tracking_id[llRowPos] //Tracking No.
	Lstrparms.String_arg[29] = dw_label.object.Warehouse_country[llRowPos] //Country From.
	Lstrparms.String_arg[30] = dw_label.object.delivery_master_country[llRowPos] //Country To.
	
	Lstrparms.String_arg[34] = dw_label.GetItemString(llRowPos,'awb_bol_no') /* 12/03 - PCONKL */
	
	//dts 3/18/05 Box Count is entered in dw_label and stored in DP.User_Field1
	lsBoxCount = dw_label.GetItemString(llRowPos,'BoxCount')
			
	Lstrparms.Long_arg[1] = llQty /*Qty of labels to print*/
	lstrparms.Long_arg[2] = round(dw_label.GetItemnumber(llRowPos,'delivery_packing_quantity'),0)/*carton qty */
	lstrparms.Long_arg[3] = dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross')/*carton weight */
	
	IF dw_label.object.delivery_packing_standard_of_measure[llRowPos] = 'M' THEN			
		lstrparms.Long_arg[3]= round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross'),"KG","PO"),2)
		lstrparms.Long_arg[4] = dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross')/*carton qty */
	ELSE	
		lstrparms.Long_arg[4]= round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross'),"PO","KG"),2)		
	END IF

		
	//Exclusively for calculating total weight only
	IF dw_label.object.delivery_packing_standard_of_measure[llRowPos] = 'M' THEN		
		ld_tot_english_weight = ld_tot_english_weight + round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross'),"KG","PO"),2)
		ld_tot_metrics_weight = ld_tot_metrics_weight + dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross')/*carton qty */
	ELSE
		ld_tot_english_weight = ld_tot_english_weight + dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross')/*carton qty */
		ld_tot_metrics_weight = ld_tot_metrics_weight + round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos,'delivery_packing_weight_gross'),"PO","KG"),2)		
	END IF
	
	lstrparms.Long_arg[5]=ld_tot_english_weight	
	lstrparms.Long_arg[6]=ld_tot_metrics_weight	
		
	// 04/04 - PCONKL - should have been decimal to begin - don't want to figure out of used elsewhere right now
	lstrparms.Decimal_arg[1]=ld_tot_english_weight	
	lstrparms.Decimal_arg[2]=ld_tot_metrics_weight	
	
	//dts 3/18/05 - If these are Pallet labels, use 'Pallet' (insead of 'Box') and indicate Box Count
	lstrparms.String_Arg[28] = String(ll_cnt) +" of " + String(ll_carton_cnt)
	if lsBoxCount > '' then
		//lstrparms.String_Arg[28] += ", Contains " + lsBoxCount + " Boxes"
		lstrparms.String_Arg[37] = 'Pallet'
		lstrparms.String_Arg[38] = "Contains " + lsBoxCount + " Boxes"
		//Update UF1 in Delivery Packing with Box Count...
		//lsPallet = dw_label.GetItemString(llRowPos, 'Carton_no')
		//End point of search (w_do.idw_pack.RowCount() + 1) is one more than row count to avoid infinite loop
		liRow = w_do.idw_pack.find("carton_no = '" + ls_carton_no + "'", 1, w_do.idw_pack.RowCount() + 1)
		do while lirow > 0
			w_do.idw_pack.SetItem(liRow, 'User_Field1', lsBoxCount)
			liRow = w_do.idw_pack.find("carton_no = '" + ls_carton_no + "'", liRow + 1, w_do.idw_pack.RowCount() + 1)
			w_do.ib_changed = true
		loop
	else
		lstrparms.String_Arg[37] = 'Box'
		lstrparms.String_Arg[38] = ' '
	end if
	ld_tot_metrics_weight =0;ld_tot_english_weight =0
	
	// 12/03 - PCONKL - We need to pass the UCCS Prefix (Location + Company)
	lstrparms.String_arg[35] = isuccswhprefix + isuccscompanyprefix
	
	Lstrparms.String_arg[36] = dw_label.object.grp[llRowPos] /* 01/05 - PCONKL - group to determine normal vs bundled part label*/
 
	//Extra Label
	Lstrparms.String_arg[39] = string(dw_label.object.delivery_master_country[llRowPos] ) 
	Lstrparms.String_arg[40] = string(dw_label.object.delivery_master_freight_terms[llRowPos])
	Lstrparms.String_arg[41] = string(dw_label.object.delivery_master_ship_ref[llRowPos])
	Lstrparms.String_arg[42] = string(dw_label.object.delivery_master_carrier[llRowPos])
	
	 
	
	
	lsAny=lstrparms		
	invo_3com_labels.uf_3com_zebra_ship(lsAny,dw_label,lb_duplicate_carton)
	
	ls_old_carton_no =  ls_carton_no					

Next /*detail row to Print*/


dw_label.Setredraw(True)

////09/04 - PCONKL - Store the last label printer used in the .ini file
//lsPrinter = PrintGetPrinter()
//SetProfileString(gs_inifile,'PRINTERS','SHIPLABEL',lsPrinter)









end event

on w_3com_labels.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_label=create dw_label
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_clear
end on

on w_3com_labels.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_selectall)
destroy(this.cb_clear)
end on

event ue_postopen;call super::ue_postopen;
// 09/04 - PCONKL - Being triggered from whip docs window, don't want to re-post
If dw_label.RowCount() > 0 Then Return

invo_labels = Create n_labels
invo_3com_labels = Create n_3com_labels
i_nwarehouse = Create n_warehouse

cb_print.Enabled = False

//We can only print based on DO_NO - User must have valid order open to pass DO_NO in from w_DO
If isVAlid(w_do) Then
	if w_do.idw_main.RowCOunt() > 0 Then
		isDoNo = w_do.idw_main.GetITemString(1,'do_no')
		This.Title = This.Title + " [ " + w_do.idw_main.GetITemString(1,'invoice_no') + "]"
	End If
End If

If isNUll(isDONO) or  isDoNO = '' Then
	Messagebox('Labels','You must have an order retrieved in the Delivery Order Window~rbefore you can print labels!')
Else
	This.TriggerEvent('ue_retrieve')
End If


end event

event ue_retrieve;call super::ue_retrieve;String	lsDONO, lsCartonNo, lsFind

Long		llRowCount,	llRowPos, llCartonCount, llCartonPos, llFindRow


cb_print.Enabled = False

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


cb_print.Enabled = True

// 12/03 - PCONKL - WE need the Project level UCCS Company prefix and the Warehouse level prefix
Select ucc_Company_Prefix into :isuccscompanyprefix
FRom Project
Where Project_ID = :gs_Project;

SElect ucc_location_Prefix into :isuccswhprefix
From Warehouse
Where wh_Code = (select wh_Code from Delivery_MASter where Project_ID = :gs_Project and do_no = :isdono);

//Set the carton x of y for Bundled parts
FOR llRowPos = 1 TO dw_label.RowCount()
	
	If Isnull(dw_label.GetITemString(llRowPos,'grp')) or dw_label.GetITemString(llRowPos,'grp') <> 'B' Then Continue
	
	//get a count of all the rows for this line item, SKU
	lsFind = "delivery_packing_line_item_no = " + String(dw_label.GetITemNumber(llRowPos,'delivery_packing_line_item_no'))
	lsFind += " and Upper(item_master_sku) = '" + dw_label.GetITemString(llRowPos,'item_master_sku') + "' and c_processed_ind = 'N'"
	
	//First pass, count the cartons
	llCartonCount = 0
	llFindRow = dw_label.Find(lsFind,1, dw_label.RowCount())
	Do While llFindRow > 0
		llCartonCount ++
		llFindRow ++
		If llFindRow > dw_label.RowCount() Then
			llFindRow = 0
		Else
			llFindRow = dw_label.Find(lsFind,llFindRow, dw_label.RowCount())
		End If
	Loop

	//Second Pass - update DW with position and total count
	llCartonPos = 0
	llFindRow = dw_label.Find(lsFind,1, dw_label.RowCount())
	Do While lLFindRow > 0
		
		lLCartonPos ++
		dw_label.SetItem(llFindRow,'c_carton_of',llCartonPos)
		dw_label.SetItem(llFindRow,'c_carton_count',llCartonCount)
		dw_label.SetItem(llfindRow,'c_processed_ind','Y')
		
		If llFindRow > dw_label.RowCount() Then
			llFindRow = 0
		Else
			llFindRow = dw_label.Find(lsFind,llFindRow, dw_label.RowCount())
		End If
		
	Loop
	
Next

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

end event

event ue_unselectall;call super::ue_unselectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','N')
Next

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

event open;call super::open;
If NOt isvalid(w_print_ship_docs) Then this.visible = True
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_3com_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_3com_labels
integer x = 1769
integer y = 24
integer height = 80
boolean default = false
end type

type cb_print from commandbutton within w_3com_labels
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

event clicked;Parent.TriggerEvent('ue_Print')
end event

type dw_label from u_dw_ancestor within w_3com_labels
integer x = 9
integer y = 136
integer width = 3488
integer height = 1448
boolean bringtotop = true
string dataobject = "d_3com_lable_grid"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event retrieveend;call super::retrieveend;//As this is compute column needs to be assigned value 
// DGM 09/22/03
integer i

//dts 3/23/05 - added code for Box Count (user_field1)
//string lsPrevPallet

this.object.boxcount.width = 0
FOR i = 1 TO rowcount
 This.object.c_qty_per_carton[i]=1
 if This.object.boxcount[i]="" then This.object.boxcount[i]="60"
 if This.object.carton_type[i]="Pallet" then this.object.boxcount.width = 200
// if This.object.Delivery_Packing_Carton_no[i] = lsPrevPallet then This.object.boxcount[i].protect = false
// lsPrevPallet = This.object.Delivery_Packing_Carton_no[i]
NEXT
//this.object.boxcount_t.visible = false


end event

event itemchanged;call super::itemchanged;iiChangedRow = Row
isChangedColumn = this.GetColumnName()
if isChangedColumn = 'boxcount' then
	if not isNumber(data) then
		messagebox (gstitle, "Box Count must be a number.")
		ibNotNumber = true
	else
		ibNotNumber = false
	end if
end if
end event

event ue_postitemchanged;call super::ue_postitemchanged;integer liButton, i
string lsBoxCount

//messagebox ("Column", string(this.getcolumnName()))
if isChangedColumn = 'boxcount' then 
	if ibNotNumber then  //not necessary with mask on data window's BoxCount field
		this.SetColumn(12)
		this.SetRow(row)
	else
		this.SetItem(row, 'c_print_ind', 'Y')
//		lsPallet = This.object.Delivery_Packing_Carton_no[row]
		// may want to modify code below to copy entered box count to all rows (or at least all rows with same carton_no)
		/*if row = 1  and this.RowCount() > 3 then
			lsBoxCount = this.GetItemString(row, 'boxcount')
			//liButton = messagebox(gstitle, 'Copy ' + lsBoxCount + ' to other rows?',,YesNo!)
			liButton = messagebox(gstitle, 'Copy Box Count "' + lsBoxCount + '" to other rows?',Question!,YesNo!)
			if liButton = 1 then
				for i = 2 to this.RowCount()
					this.SetItem(i, 'boxcount', lsBoxCount)
					this.SetItem(i, 'c_print_ind', 'Y')
				next
			end if
		end if
		*/
	end if
end if

end event

type cb_selectall from commandbutton within w_3com_labels
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

type cb_clear from commandbutton within w_3com_labels
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

