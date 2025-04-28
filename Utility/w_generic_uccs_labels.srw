HA$PBExportHeader$w_generic_uccs_labels.srw
$PBExportComments$Print Generic UCCS Shipping labels
forward
global type w_generic_uccs_labels from w_main_ancestor
end type
type cb_label_print from commandbutton within w_generic_uccs_labels
end type
type dw_label from u_dw_ancestor within w_generic_uccs_labels
end type
type cb_label_selectall from commandbutton within w_generic_uccs_labels
end type
type cb_label_clear from commandbutton within w_generic_uccs_labels
end type
end forward

global type w_generic_uccs_labels from w_main_ancestor
integer width = 3191
integer height = 1788
string title = "Shipping Labels"
event ue_print ( )
cb_label_print cb_label_print
dw_label dw_label
cb_label_selectall cb_label_selectall
cb_label_clear cb_label_clear
end type
global w_generic_uccs_labels w_generic_uccs_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels

String	isUCCSCompanyPrefix, isUCCSWHPrefix

String	isDONO

inet	linit   //26-Sep-2014 :Madhu- KLN B2B SPS Conversion
u_nvo_websphere_post	iuoWebsphere  //26-Sep-2014 :Madhu- KLN B2B SPS Conversion

end variables

event ue_print();Str_Parms	lstrparms

Long	llQty, llRowCount, llRowPos, ll_rtn, ll_alloc_qty, llRowPos1, llLabelCount, llLabelOf
		
Any	lsAny

String	lsCityStateZip, lsSKU, ls_format, ls_old_carton_no,ls_carton_no,ls_old_carton_no1,ls_carton_no1,	&
			lsDONO, lsCartonHold
String   ls_user_field21,lsXML,lsXMLResponse,lsReturnCode,lsReturnDesc,lsPrintText,lsReturnlabelData //26-Sep-2014 :Madhu -KLN B2B Conversion to SPS
Boolean lb_generic,lb_print_mixed ,lb_duplicate_carton,lb_print
long ll_tot_metrics_weight,ll_tot_english_weight,ll_cnt,ll_cnt1,ll_carton_cnt,ll_count,ll_count_prev,llPrintJob

String ls_TraxAcctNo, ls_logo, lsName, lsAddr1, lsAddr2, lsAddr3, lsAddr4, lsCity, lsState, lsZip, lsCountry	//SIMSPEVS-644

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

//26-Sep-2014 :Madhu- KLN B2B Conversion to SPS -START
Select user_field21 into :ls_user_field21
From Delivery_Master
Where Do_No=:lsDoNo;

//GailM - 8/28/2017 - SIMSPEVS-644 Aspen Medical Modify the current Packing List generated from SIMS 
Select Trax_Acct_No into :ls_TraxAcctNo
From Delivery_Master
Where Do_No=:lsDoNo;

iuoWebsphere = CREATE u_nvo_websphere_post
linit = Create Inet
lsXML = iuoWebsphere.uf_request_header("SpsLabelRequest", "ProjectID='" + gs_Project + "'")
lsXML += 	'<DONO>' + lsDoNo +  '</DONO>' 
//26-Sep-2014 :Madhu- KLN B2B Conversion to SPS -END

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]
	llQty = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
	Lstrparms.Long_arg[1] = llQty
			
	//GailM - 8/28/2017 - SIMSPEVS-644 Aspen Medical Modify the current Packing List generated from SIMS 
	//GailM - 9/14/2017 - TraxAcctNo changed from 97167YA to 9716YA 
	IF NOT isNull( ls_TraxAcctNo ) THEN
				
			SELECT user_field10 INTO :ls_logo FROM customer 
			WHERE project_id = 'ASPEN' and customer_type = 'DS' and cust_code = :ls_TraxAcctNo USING SQLCA;
			
			If Not isNull( ls_logo ) And ls_logo <> ''  Then
				
				SELECT cust_name, address_1, address_2, address_3, address_4, city, state, zip, country
				INTO :lsName, :lsAddr1, :lsAddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry
				FROM customer
				WHERE project_id = 'ASPEN' and customer_type = 'DS' and cust_code = :ls_TraxAcctNo
				USING SQLCA;
				
				SELECT country_name INTO :lsCountry FROM country WHERE designating_code = :lsCountry USING SQLCA;
			
			End If
				
			Lstrparms.String_arg[2] = lsName
			Lstrparms.String_arg[3] = lsAddr1
			Lstrparms.String_arg[4] = lsAddr2
			Lstrparms.String_arg[5] = lsAddr3
			Lstrparms.String_arg[6] = lsCity + ', ' + lsState + ' ' + lsZip		
		
	ELSE
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
	END IF
	
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
	Lstrparms.String_arg[36] = Trim(dw_label.GetItemString(llRowPos,'user_field14')) /*Ecommerce ID*/  // Jxlim 09/10/2014 Anki use dm.user_field14 as Ecommerce ID. Cust_order_no not enough lenght
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
		 
		 //BCR 14-FEB-2012: I commented out the below line of code because it causes grief if total no of rows > 4.
		 //If commenting it out causes grief in any other project, then we will need to revisit. Ran this by Pete already.
		 
//		 IF ll_cnt1 > 4 THEN Exit

			IF dw_label.object.delivery_packing_standard_of_measure[llRowPos1] = 'M' THEN			
				ll_tot_english_weight = ll_tot_english_weight + round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross'),"KG","PO"),2)
				ll_tot_metrics_weight = ll_tot_metrics_weight + dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross')/*carton qty */
			ELSE
				ll_tot_english_weight = ll_tot_english_weight + dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross')/*carton qty */
				ll_tot_metrics_weight = ll_tot_metrics_weight + round(i_nwarehouse.of_convert(dw_label.GetItemnumber(llRowPos1,'delivery_packing_weight_gross'),"PO","KG"),2)		
			//nxjain: As per Requested while convert of KG and LB ; if we had been received less than 1 value thus will update by 1 for Riverbed 26-02-2016
				If gs_project ='RIVERBED'  and ll_tot_metrics_weight =0 then
						ll_tot_metrics_weight =1
				end if 
				//nxjain-26-02-2016
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
	
	//BCR 12-OCT-2011: For RUN-WORLD, Ship Date on Label should be Request Date on w_do...
	lstrparms.datetime_arg[1] = w_do.idw_main.GetItemDateTime(1, 'request_date')
	//END
	
	lsAny=lstrparms	
	
	//BCR 7-SEP-2011: Run-World calls a different function
	IF Upper(gs_project) = 'RUN-WORLD' THEN
		invo_labels.uf_runworld_zebra_ship(lsAny)
	//Jxlim 09/11/2014 Anki Shipping label -Madhu commented
//	Elseif Upper(gs_project) = 'ANKI' THEN
//		invo_labels.uf_anki_uccs_zebra(lsAny)
	ELSE
		//26-Sep-2014 :Madhu- KLN B2B Conversion to SPS, prepare an XML for all records -START	
		IF Upper(gs_project) ='KLONELAB' and ls_user_field21 ='SPS' Then
			//append carton to XML for all rows.
			lsXML += 	'<Carton_No>' + nz(ls_carton_no,'') +  '</Carton_No>' 
		ELSE   //26-Sep-2014 :Madhu- KLN B2B Conversion to SPS, prepare an XML  for all records -END
			invo_labels.uf_generic_uccs_zebra(lsAny)
		END IF //26-Sep-2014 :Madhu- KLN B2B Conversion to SPS, prepare an XML and send to websphere 
	END IF

	ls_old_carton_no =  ls_carton_no					
	 
Next /*detail row to Print*/


//26-Sep-2014 :Madhu- KLN B2B Conversion to SPS- Send XML to websphere -START
//get response back from XML and print
IF Upper(gs_project) ='KLONELAB' and ls_user_field21 ='SPS' Then

	lsXML += '</SpsLabelRequest>'
	lsXML += '</SIMSRequest>'
	lsXML += '</SIMSMessage>'
	//lsXML = iuoWebsphere.uf_request_footer(lsXML)
	w_main.setMicroHelp("Putaway List generation complete")
	w_main.setMicroHelp("SPS Label request to Application Server...")
	
	lsXMLResponse = iuoWebsphere.uf_post_url(lsXML)
	
	//Check for Valid Return...
	//If we didn't receive an XML back, there is a fatal exception error
	If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
		Messagebox("Websphere Fatal Exception Error","Unable to get Response from Websphere: ~r~r" + lsXMLResponse,StopSign!)
		Return 
	End If
	
	//Check the return code and return description for any trapped errors
	lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
	lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")
	
	Choose Case lsReturnCode
			
		Case "-1" /* Websphere non fatal exception error*/
			Messagebox("Websphere Operational Exception Error","Unable to get Response from SPS service, please contact TSG: ~r~r" + lsReturnDesc,StopSign!)
			Return 
		Case Else
			
			If lsReturnDesc > '' Then
				Messagebox("",lsReturnDesc)
			End If
	End Choose
	
	lsReturnlabelData = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"Labels")

	//Send response XML to label Printer
	lsPrintText ='UCCS Ship - Zebra'

	//Open printer file
	llPrintJob = PrintOpen(lsPrintText)
	If llPrintJob <0 Then
		Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
		Return
	END IF

	//print label
	PrintSend(llPrintJob, lsReturnlabelData)
	PrintClose(llPrintJob)
	
	UPDATE Delivery_Master Set DWG_UPLOAD = 'Y' Where Do_no = :lsDoNo;	 //17-Jun-2015 :Madhu- Added for KLN B2B SPS.

END IF
//26-Sep-2014 :Madhu- KLN B2B Conversion to SPS- Send XML to websphere -END

end event

on w_generic_uccs_labels.create
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

on w_generic_uccs_labels.destroy
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

type cb_cancel from w_main_ancestor`cb_cancel within w_generic_uccs_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_generic_uccs_labels
integer x = 1769
integer y = 24
integer height = 80
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_label_print from commandbutton within w_generic_uccs_labels
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

event constructor;
g.of_check_label_button(this)
end event

type dw_label from u_dw_ancestor within w_generic_uccs_labels
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
If upper(dwo.Name) = 'C_PRINT_IND' and data = 'Y' Then cb_label_print.Enabled = True
end event

type cb_label_selectall from commandbutton within w_generic_uccs_labels
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

type cb_label_clear from commandbutton within w_generic_uccs_labels
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

