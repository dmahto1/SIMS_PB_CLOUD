$PBExportHeader$w_rema_labels.srw
$PBExportComments$Print  Rema Shipping labels
forward
global type w_rema_labels from w_main_ancestor
end type
type cb_label_print from commandbutton within w_rema_labels
end type
type dw_label from u_dw_ancestor within w_rema_labels
end type
type cb_label_selectall from commandbutton within w_rema_labels
end type
type cb_label_clear from commandbutton within w_rema_labels
end type
type cbx_part_labels from checkbox within w_rema_labels
end type
end forward

global type w_rema_labels from w_main_ancestor
integer width = 3191
integer height = 1788
string title = "Subway Labels"
event ue_print ( )
event ue_print_carton ( )
event ue_sort ( )
cb_label_print cb_label_print
dw_label dw_label
cb_label_selectall cb_label_selectall
cb_label_clear cb_label_clear
cbx_part_labels cbx_part_labels
end type
global w_rema_labels w_rema_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels

Datastore idw_content_label

String	isUCCSCompanyPrefix, isUCCSWHPrefix

String	isDONO, is_sql, is_title

integer ii_total_qty_cartons, ilCartonCount

Boolean	ibUseCalculatedCartonCount
end variables

forward prototypes
protected function string uf_get_scc (readonly string ascartonno, string asdono)
end prototypes

event ue_print_carton();//02-JULY-2018 :Madhu S20885 F8792 Print Shipping Label

Str_Parms	lstrparms

Long		llRowCount, llRowPos, ll_failures
String		lsCustCode, lsCustLabel, lsPrinter, lsDoNo, ls_CustName, ls_carton_no, lsCityStateZip
String		lsMessage, ls_barcode,  ls_concatenate_bc, lsCustName
boolean	lbNewCarton
Any	lsAny

n_warehouse l_nwarehouse 

ll_failures = 0

//Check the customer master for any customer specific labels. we will only have custer master recrds for these customers
lsCustName = w_do.idw_Main.GetItemString(1,'cust_name')

If Pos(lsCustName, 'SWS') = 0 Then
	MessageBox('Labels', "Subway Labels can't be printed for Customer: "+lsCustName)
	Return
End If

dw_Label.AcceptText()

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

//  If we have a default printer for REMA Labels, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','REMALABELS','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

OpenWithParm(w_label_print_options,lstrparms)
lstrparms = Message.PowerObjectParm		  
If lstrparms.Cancelled Then Return 

lsDoNo = dw_label.GetItemString(1,'delivery_Master_do_no')
ls_CustName = dw_label.GetItemString(1,'delivery_master_cust_name') 

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */

	lsDoNo = dw_label.GetItemString(llRowPos,'delivery_Master_do_no')
	ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]
	
	ls_CustName = dw_label.GetItemString(llRowPos,'delivery_master_cust_name') 
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	// Print any customer specific labels
	
	If dw_label.GetItemString(llRowPos,'delivery_packing_pack_sscc_no')  > '' Then
		lstrparms.String_arg[36] = dw_label.GetItemString(llRowPos,'delivery_packing_pack_sscc_no')
	Else
		lstrparms.String_arg[36] = uf_get_scc(ls_carton_no,lsDoNo)
	End If
	
	//Update Delivery Packing with SSCC No
	If lstrparms.String_arg[36] > '' Then
	
		Execute Immediate "Begin Transaction" using SQLCA;
		
		Update Delivery_Packing
		Set Pack_sscc_no = :lstrparms.String_arg[36]
		Where do_no = :lsDoNo and Carton_no = :ls_carton_no
		Using SQLCA;
		
		If SQLCA.SQLCode = 0 Then
			Execute Immediate "COMMIT" using SQLCA;
			lsMessage = "SSCC No " + lstrparms.String_arg[36] + " inserted into pack list for carton No: " + ls_carton_no + "."
			f_method_trace_special( gs_project, this.ClassName() + ' - ue_print_carton',lsMessage ,lsDoNo, ' ',' ',lsDoNo)
		Else
			Execute Immediate "ROLLBACK" using SQLCA;
			lsMessage = "Unable to save SSCC No " +  lstrparms.String_arg[36] +  " to Packing List for carton No " + ls_carton_no + " : ~n~rError: " + SQLCA.SQLErrText
			f_method_trace_special( gs_project, this.ClassName() + ' - ue_print_carton',lsMessage ,lsDoNo, ' ',' ',lsDoNo)
			ll_failures ++
		End If
	
	End If
	
	dw_label.SetItem(llRowPos,'Delivery_Packing_Pack_sscc_No',lstrparms.String_arg[36])
	
	lstrparms.String_arg[37] = ls_carton_no
	lstrparms.String_arg[18] =	lsDoNo
	
	//Ship From
	lstrparms.String_arg[2] = dw_label.GetItemString(llRowPos,'warehouse_wh_name')
	lstrparms.String_arg[3] = dw_label.GetItemString(llRowPos,'warehouse_address_1')
	lstrparms.String_arg[4] = dw_label.GetItemString(llRowPos,'warehouse_address_2')
	lstrparms.String_arg[5] = dw_label.GetItemString(llRowPos,'warehouse_address_3')
	lstrparms.String_arg[6] = dw_label.GetItemString(llRowPos,'Warehouse_address_4')
	
	//Compute FROM City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_city')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'warehouse_city') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_state')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_state') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'warehouse_zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'warehouse_zip') + ' '
	lstrparms.String_arg[7] = lsCityStateZip
	
	//Ship To
	lstrparms.String_arg[12] = dw_label.GetItemString(llRowPos,'delivery_master_Cust_name')
	lstrparms.String_arg[13] = dw_label.GetItemString(llRowPos,'delivery_master_address_1')
	lstrparms.String_arg[14] = dw_label.GetItemString(llRowPos,'delivery_master_address_2')
	lstrparms.String_arg[15] = dw_label.GetItemString(llRowPos,'delivery_master_address_3')
	lstrparms.String_arg[16] = dw_label.GetItemString(llRowPos,'delivery_master_address_4')
	lstrparms.String_arg[33] = dw_label.GetItemString(llRowPos,'delivery_master_Zip')
	
	//Compute TO City,State & Zip
	lsCityStateZip = ''
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_City')) Then lsCityStateZip = dw_label.GetItemString(llRowPos,'delivery_master_City') + ', '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_State')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_State') + ' '
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_master_Zip')) Then lsCityStateZip += dw_label.GetItemString(llRowPos,'delivery_master_Zip') + ' '
	lstrparms.String_arg[17] = lsCityStateZip
	
	lstrparms.String_arg[19] = dw_label.GetItemString(llRowPos,'Delivery_detail_gtin') //GTIN
	lstrparms.String_arg[20] = dw_label.GetItemString(llRowPos,'Delivery_detail_sku') //SKU
	lstrparms.String_arg[21] = dw_label.GetItemString(llRowPos,'delivery_packing_pack_lot_no') //Pack Lot No
	lstrparms.String_arg[22] = String(dw_label.GetItemDateTime(llRowPos,'delivery_packing_pack_expiration_date'),'MM/DD/YYYY') // Exp Date
	lstrparms.String_arg[23] = String(dw_label.GetItemNumber(llRowPos,'quantity'))
	lstrparms.String_arg[24] = dw_label.GetItemString(llRowPos,'item_master_description') //Description
	lstrparms.String_arg[25] = dw_label.GetItemString(llRowPos,'delivery_packing_Pack_sscc_no') //Pack SSCC No
	
	
	//Barcode with combination of GTIN + ExpDate + Qty + Lot No
	If Not isnull(dw_label.GetItemString(llRowPos,'Delivery_detail_gtin')) Then ls_barcode = "(01) "+trim(dw_label.GetItemString(llRowPos,'Delivery_detail_gtin'))
	If Not isnull(String(dw_label.GetItemDateTime(llRowPos,'delivery_packing_pack_expiration_date'),'YYMMDD')) Then ls_barcode += "(17) "+trim(String(dw_label.GetItemDateTime(llRowPos,'delivery_packing_pack_expiration_date'),'YYMMDD'))
	If Not isnull(String(dw_label.GetItemNumber(llRowPos,'quantity'))) Then ls_barcode += "(37) "+String(dw_label.GetItemNumber(llRowPos,'quantity'))
	If Not isnull(dw_label.GetItemString(llRowPos,'delivery_packing_pack_lot_no')) Then ls_barcode += "(10) "+trim(dw_label.GetItemString(llRowPos,'delivery_packing_pack_lot_no'))
	
	lstrparms.String_arg[26] = ls_barcode //First Barcode
	
	ls_concatenate_bc = trim(dw_label.GetItemString(llRowPos,'Delivery_detail_gtin'))
	ls_concatenate_bc += String(dw_label.GetItemDateTime(llRowPos,'delivery_packing_pack_expiration_date'),'YYMMDD')
	ls_concatenate_bc += String(dw_label.GetItemNumber(llRowPos,'quantity'))
	ls_concatenate_bc += dw_label.GetItemString(llRowPos,'delivery_packing_pack_lot_no')

	lstrparms.String_arg[27] = ls_concatenate_bc //First Barcode
	
	lsAny=lstrparms		
	invo_labels.setparms( lsAny )
	
	//Print label
	invo_labels.uf_rema_ship(lsAny)
	
	dw_label.SetItem(llRowPos,'c_print_ind','N')	 

Next /*detail row to Print*/


If ll_failures > 0 Then
	lsMessage = "There have been " + String(ll_failures) + " SSCC numbers that did not save to the database. ~n~rInformation has been captured.  Please report this to System Administrator for action."  
	MessageBox( is_title, lsMessage )
End If

// We want to store the last printer used for Printing the Kendo label for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','REMALABELS',lsPrinter)

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
	SELECT Left( WH.ucc_location_prefix,1 )
	INTO :lsWHuccPrefix 
	FROM warehouse WH
	WHERE WH.wh_code = :lsWHCode USING SQLCA;
	
	If IsNull( lsWHuccPrefix ) or NOT IsNumber( lsWHuccPrefix) Then lsWHuccPrefix = '0'

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
	lsCartonNo = right(lsDONO, 4 ) + "0001"
	
Else /* bump up sequential portion and format new SSCC */
	
	lsCartonSSCC = Mid(lsMaxSSCC,12,8 ) /* strip off company prefix and check digit*/
	llCartonNo = long(lsCartonSSCC)
	llCartonNo ++
	lsCartonNo =string(llCartonNo, '00000000' ) 	//Reduced from 9 to 8 when using warehouse prefix  11/17
		 
End If

lsUCCS =  trim((isUCCSCompanyPrefix +  lsCartonNo))
liCheck = f_calc_uccs_check_Digit(lsUCCS) 															

If liCheck >=0 Then
   		lsUCCS = "00" + lsUCCS + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
Else
	lsUCCS = "00" + String(lsUCCS, '00000000000000000000') + "0"
End IF
	
	/* per Ariens, The base is ‘0000751058000000000N‘ where N is the check digit.
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

on w_rema_labels.create
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

on w_rema_labels.destroy
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

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

event open;
// Ancestor overriden - Need to trigger the retrieval instead of post

This.TriggerEvent("ue_postOpen") 
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_rema_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_rema_labels
integer x = 1874
integer y = 28
integer height = 80
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_label_print from commandbutton within w_rema_labels
integer x = 946
integer y = 28
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

type dw_label from u_dw_ancestor within w_rema_labels
integer x = 9
integer y = 140
integer width = 3127
integer height = 1456
boolean bringtotop = true
string dataobject = "d_rema_ship"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;
If upper(dwo.Name) = 'C_PRINT_IND' and data = 'Y' Then cb_label_print.Enabled = True
end event

type cb_label_selectall from commandbutton within w_rema_labels
integer x = 32
integer y = 28
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

type cb_label_clear from commandbutton within w_rema_labels
integer x = 393
integer y = 28
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

type cbx_part_labels from checkbox within w_rema_labels
boolean visible = false
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

