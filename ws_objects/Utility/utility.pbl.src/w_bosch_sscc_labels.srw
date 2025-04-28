$PBExportHeader$w_bosch_sscc_labels.srw
$PBExportComments$Print Generic UCCS Shipping labels
forward
global type w_bosch_sscc_labels from w_main_ancestor
end type
type cb_label_print from commandbutton within w_bosch_sscc_labels
end type
type dw_label from u_dw_ancestor within w_bosch_sscc_labels
end type
type cb_label_selectall from commandbutton within w_bosch_sscc_labels
end type
type cb_label_clear from commandbutton within w_bosch_sscc_labels
end type
type cbx_part_labels from checkbox within w_bosch_sscc_labels
end type
end forward

global type w_bosch_sscc_labels from w_main_ancestor
integer width = 3771
integer height = 1789
string title = "Shipping Labels"
event ue_print ( )
cb_label_print cb_label_print
dw_label dw_label
cb_label_selectall cb_label_selectall
cb_label_clear cb_label_clear
cbx_part_labels cbx_part_labels
end type
global w_bosch_sscc_labels w_bosch_sscc_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels

Datastore idw_content_label

String	isUCCSCompanyPrefix, isUCCSWHPrefix

String	isDONO

integer ii_total_qty_cartons, ilCartonCount
end variables

forward prototypes
public function string uf_bosch_get_scc (string ascartonno, string asdono)
end prototypes

event ue_print();Str_Parms	lstrparms

Long	llPackCopies, llCopyCount, llRowCount, llRowPos, ll_rtn, llLabelCount, llLabelOf, llStRowCount //TAM - 2018/07 - S20380
Any	lsAny
String	lsCityStateZip, lsSKU, ls_format, ls_carton_no,	lsDONO,  ls_CustName,lsinvoiceno	
String lsPrintText
Boolean	lb_dropship
Long llPrintJob

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
	If  Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'SEARS' ) > 0 then
			lstrparms.String_Arg[60] = 'SEARSPART' 
//	ElseIf Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'BestBuy' ) > 0 then
//		If This.cbx_part_labels.checked = True Then
//			lstrparms.String_Arg[60] = 'BESTBUY_GS1' 
	Else
		MessageBox('Labels',"part labels are not set up for this Customer!")
		Return
	End if
Else
	// If Ship to name contains Grainger then print the Grainger Part Label
	//GailM 4/1/2020 S44399/F22114/I2902 BOL  Bosch takes on Wayfair as they do HomeDepot 
	If  Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'SEARS' ) > 0 then
			lstrparms.String_Arg[60] = 'SEARS_UCC'
	ElseIf Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'BESTBUY' ) > 0 then
			lstrparms.String_Arg[60] = 'BESTBUY_UCC' 
	ElseIf Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'LOWE' ) > 0 then
		lstrparms.String_Arg[60] = 'LOWES_UCC' 
	ElseIf Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'THD-' ) > 0 then
		lstrparms.String_Arg[60] = 'THD_UCC' 
	ElseIf Pos(upper(dw_label.GetItemString(1,'delivery_master_cust_name')), 'WAY-' ) > 0 then
		lstrparms.String_Arg[60] = 'THD_UCC' 
	Else
		lstrparms.String_Arg[60] = '' 
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
lsinvoiceno = dw_label.GetItemString(1,'delivery_Master_invoice_no') //15-Oct-2014 :Madhu- Added Invoice No

// Get Sold To Addesss
lds_st =Create Datastore
lds_st.Dataobject='d_do_address_alt'
lds_st.SetTransObject(SQLCA)
lds_st.Retrieve(lsdono, 'ST')
llStRowCount = lds_st.RowCount()


//GailM 12/14/2017 - DE2330 - BSH Utility Shipping Label Print Order - Collect all rows in one print job before sending to printer
//Open Printer File - GailM 12/14/2017 - DE2330 - BSH Utility Shipping Label Print Order Moved print
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
Else
	//Print each detail Row 
	llRowCount = dw_label.RowCount()
	For llRowPos = 1 to llRowCount /*each detail row */
		
		IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
		
		ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]
	
		Lstrparms.String_arg[38] =	dw_label.GetITemString(1,'delivery_Master_DO_NO')  // do_no arg for passing n_labels
		
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
			// sscc carton number
		Lstrparms.String_arg[48] = uf_bosch_get_scc( dw_label.GetItemString(llRowPos,'delivery_packing_carton_no'), lsDoNo)
		
		Lstrparms.String_arg[10] = dw_label.GetItemString(llRowPos,'awb_bol_no') /* PO NBR*/
	
		Lstrparms.String_arg[11] = trim(dw_label.GetItemString(llRowPos,'delivery_detail_user_field1')) /* PO NBR*/
	
		Lstrparms.String_arg[39] = trim(dw_label.GetItemString(llRowPos,'delivery_detail_user_field2')) /* Customer Line No*/
		Lstrparms.String_arg[40] = trim(dw_label.GetItemString(llRowPos,'delivery_detail_user_field3')) /* Department*/
		Lstrparms.String_arg[41] = trim(dw_label.GetItemString(llRowPos,'delivery_detail_user_field4')) /* Consignee*/
		Lstrparms.String_arg[42] = trim(dw_label.GetItemString(llRowPos,'delivery_detail_user_field5')) /* Store*/
		Lstrparms.String_arg[43] = trim(dw_label.GetItemString(llRowPos,'delivery_detail_user_field6')) /* Catagory*/
		Lstrparms.String_arg[44] = trim(dw_label.GetItemString(llRowPos,'delivery_detail_user_field7')) /* Event*/
		
		
		Lstrparms.String_arg[23] = dw_label.GetItemString(llRowPos,'delivery_master_invoice_no') /* Order nbr*/
		Lstrparms.String_arg[25] = uf_bosch_get_scc( dw_label.GetItemString(llRowPos,'delivery_packing_carton_no'), lsinvoiceno) //15-Oct-2014 :Madhu- Generate SSCCNo for InvoiceNo
		Lstrparms.String_arg[24] = dw_label.GetItemString(llRowPos,'delivery_master_carrier') /* Order nbr*/
		Lstrparms.String_arg[26] = dw_label.GetItemString(llRowPos,'carrier_pro_no') /*User_Field7 Pro Jxlim 04/02/2014 Replaced with Carrier_Pro_No name field*/
		// TODO - If more than one SKU the print "MIXED"	
		Lstrparms.String_arg[20] = dw_label.GetItemString(llRowPos,'delivery_packing_sku') /* Sku*/
		Lstrparms.String_arg[21] = dw_label.GetItemString(llRowPos,'alternate_sku') /*ALternate Sku*/

		//TAM 2018/07 - S20380 - BSH - Bosch - The Home Depot Ship Label - Start
		Lstrparms.String_arg[45] = dw_label.GetItemString(llRowPos,'serial_no') /*Serial Number (Min)*/
		Lstrparms.String_arg[46] = dw_label.GetItemString(llRowPos,'user_field5') /*MS#*/
		string lsRDDMonth, lsRDDDay,lsRDDYear
		lsRDDMonth = left(dw_label.GetItemString(llRowPos,'user_field6'),2)
		lsRDDDay = mid(dw_label.GetItemString(llRowPos,'user_field6'),3,2)
		lsRDDYear = mid(dw_label.GetItemString(llRowPos,'user_field6'),5,4)
//		Lstrparms.String_arg[47] = string(left(dw_label.GetItemString(llRowPos,'user_field6'),8),'xx/xx/xxxx') /*RDD*/
		Lstrparms.String_arg[47] = lsRDDMonth + '/' + lsRDDDay + '/' + lsRDDYear /*RDD*/
		//Sold To
		If llStRowCount = 1 then 
			Lstrparms.String_arg[48] = lds_st.GetItemString(1,'name')
			Lstrparms.String_arg[49] = lds_st.GetItemString(1,'address_1')
			Lstrparms.String_arg[50] = lds_st.GetItemString(1,'address_2')
			Lstrparms.String_arg[51] = lds_st.GetItemString(1,'address_3')
			Lstrparms.String_arg[52] = lds_st.GetItemString(1,'address_4')
			//Compute TO City,State & Zip
			lsCityStateZip = ''
			If Not isnull(lds_st.GetItemString(1,'City')) Then lsCityStateZip = lds_st.GetItemString(1,'City') + ', '
			If Not isnull(lds_st.GetItemString(1,'State')) Then lsCityStateZip += lds_st.GetItemString(1,'State') + ' '
			If Not isnull(lds_st.GetItemString(1,'Zip')) Then lsCityStateZip += lds_st.GetItemString(1,'Zip') + ' '
			Lstrparms.String_arg[53] = lsCityStateZip
		End If	
		//TAM 2018/07 - S20380 - BSH - Bosch - The Home Depot Ship Label - End

		Lstrparms.String_arg[62] = String(dw_label.GetItemNumber(llRowPos,'Quantity'))
		
	// 12/03 - PCONKL - We need to pass the UCCS Prefix (Location + Company)
	//lstrparms.String_arg[35] = isuccswhprefix + isuccscompanyprefix	
		lstrparms.String_arg[35] = isuccscompanyprefix						
			
		//GailM 12/14/2017 - DE2330 - BSH Utility Shipping Label Print Order
		//Use the number of copies from the setup window to increment the X of Y here instead of in the label function
		llPackCopies = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
		For llCopyCOunt = 1 to llPackCopies // For number of Copies
	
			llLabelof ++  //Increment the "X"
		
			lstrparms.String_Arg[29] = String(llLabelof) +" of  " + String(llLabelCount)
	
			lsAny=lstrparms		
	
			lstrparms = invo_labels.uf_bosch_ucc_128_zebra_ship(lsAny)
			lsAny=lstrparms	
			
			lsPrintText =  lstrparms.String_Arg[58]
			PrintSend(llPrintJob, lsPrintText)
			lstrparms.String_Arg[58] = ''
			
			If lstrparms.String_Arg[59] <> '' Then
				PrintSend(llPrintJob, lstrparms.String_Arg[59] )
				lstrparms.String_Arg[59] = ''
			End If
		
		Next //Next Copy					
		dw_label.SetITem(llRowPos,'c_print_ind','N')	 
	Next /*detail row to Print*/
End If

PrintClose(llPrintJob)		// After collecting all into one print job,  Print all.



end event

public function string uf_bosch_get_scc (string ascartonno, string asdono);String lsCartonNo ,lsUCCS,lsDONO,lsOutString,lsDelimitChar
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
	
	/* per Ariens, The base is ‘0000751058000000000N‘ where N is the check digit.
     lsUCCS must be 17 digits long....
    using 00751058 for Company code, preceding that by '00' so need 10 digits for serial of carton
    using last 5 of do_no and then carton numbers, formatted to 4 digits
    */
	 
    //the string function to pad 0's for the carton number doesn't work (returning only '0000')
    liCartonNo = integer(lsCartonNo)
   lsCartonNo = right(lsDONO, 5) + string(liCartonNo, '00000')
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

on w_bosch_sscc_labels.create
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

on w_bosch_sscc_labels.destroy
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

type cb_cancel from w_main_ancestor`cb_cancel within w_bosch_sscc_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_bosch_sscc_labels
integer x = 1770
integer y = 26
integer height = 80
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_label_print from commandbutton within w_bosch_sscc_labels
integer x = 947
integer y = 26
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

type dw_label from u_dw_ancestor within w_bosch_sscc_labels
integer x = 7
integer y = 138
integer width = 3127
integer height = 1456
boolean bringtotop = true
string dataobject = "d_bosch_uccs_ship"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event retrieveend;call super::retrieveend;//As this is compute column needs to be assigned value 
integer i
FOR i = 1 TO rowcount
// TAM 2014/10/28 - Use QTY at the print count
// This.object.c_qty_per_carton[i]=1
 This.setItem(i,'c_qty_per_carton',this.getitemnumber(i,'quantity' ))
long tstqty, tstctn

NEXT


end event

event itemchanged;call super::itemchanged;
If upper(dwo.Name) = 'C_PRINT_IND' and data = 'Y' Then cb_label_print.Enabled = True
end event

type cb_label_selectall from commandbutton within w_bosch_sscc_labels
integer x = 33
integer y = 26
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

type cb_label_clear from commandbutton within w_bosch_sscc_labels
integer x = 391
integer y = 26
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

type cbx_part_labels from checkbox within w_bosch_sscc_labels
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

