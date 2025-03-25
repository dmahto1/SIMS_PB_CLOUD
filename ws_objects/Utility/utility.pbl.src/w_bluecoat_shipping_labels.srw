$PBExportHeader$w_bluecoat_shipping_labels.srw
$PBExportComments$Bluecoat Shipping labels
forward
global type w_bluecoat_shipping_labels from w_main_ancestor
end type
type cb_print from commandbutton within w_bluecoat_shipping_labels
end type
type dw_label from u_dw_ancestor within w_bluecoat_shipping_labels
end type
type cb_selectall from commandbutton within w_bluecoat_shipping_labels
end type
type cb_clear from commandbutton within w_bluecoat_shipping_labels
end type
end forward

global type w_bluecoat_shipping_labels from w_main_ancestor
integer width = 3191
integer height = 1788
string title = "Shipping Labels"
event ue_print ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_clear cb_clear
end type
global w_bluecoat_shipping_labels w_bluecoat_shipping_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels

String	isUCCSCompanyPrefix, isUCCSWHPrefix

String	isDONO
end variables

event ue_print();Str_Parms	lstrparms

Long	llQty, llRowCount, llRowPos, ll_rtn, ll_alloc_qty, llRowPos1, llLabelCount, llLabelOf
		
Any	lsAny

String	lsCityStateZip, lsSKU, ls_format, ls_old_carton_no,ls_carton_no,ls_old_carton_no1,ls_carton_no1,	&
			lsDONO, lsCartonHold
			
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
Where do_no = :lsDONO;

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]
	llQty = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
	Lstrparms.Long_arg[1] = llQty
			
		  
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
	
	
	Lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'delivery_master_cust_order_no') /* PO NBR*/
	//Lstrparms.String_arg[15] = String(Round(dw_label.object.delivery_packing_quantity[llRowPos],0))
	Lstrparms.String_arg[17] = dw_label.object.delivery_master_invoice_no[llRowPos]
	Lstrparms.String_arg[21] = dw_label.object.delivery_master_do_no[llRowPos]
	Lstrparms.String_arg[25] = dw_label.object.delivery_master_carrier[llRowPos]
	Lstrparms.String_arg[27] = dw_label.object.Delivery_Packing_Shipper_Tracking_ID[llRowPos]
	Lstrparms.String_arg[34] = dw_label.GetItemString(llRowPos,'awb_bol_no') /* 12/03 - PCONKL */
	Lstrparms.Long_arg[1] = llQty /*Qty of labels to print*/
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
		 IF ll_cnt1 > 4 THEN Exit
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
	
	lsAny=lstrparms		
	invo_labels.uf_bluecoat_shipping_intermec(lsAny)
	
	ls_old_carton_no =  ls_carton_no					
	 
Next /*detail row to Print*/

end event

on w_bluecoat_shipping_labels.create
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

on w_bluecoat_shipping_labels.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_selectall)
destroy(this.cb_clear)
end on

event ue_postopen;call super::ue_postopen;

invo_labels = Create n_labels
i_nwarehouse = Create n_warehouse

cb_print.Enabled = False

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

cb_print.Enabled = False

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_bluecoat_shipping_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_bluecoat_shipping_labels
integer x = 1769
integer y = 24
integer height = 80
boolean default = false
end type

type cb_print from commandbutton within w_bluecoat_shipping_labels
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

type dw_label from u_dw_ancestor within w_bluecoat_shipping_labels
integer x = 9
integer y = 136
integer width = 3127
integer height = 1456
boolean bringtotop = true
string dataobject = "d_generic_uccs_ship"
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
If upper(dwo.Name) = 'C_PRINT_IND' and data = 'Y' Then cb_print.Enabled = True
end event

type cb_selectall from commandbutton within w_bluecoat_shipping_labels
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

type cb_clear from commandbutton within w_bluecoat_shipping_labels
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

