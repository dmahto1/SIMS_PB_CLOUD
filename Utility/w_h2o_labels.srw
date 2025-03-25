HA$PBExportHeader$w_h2o_labels.srw
$PBExportComments$Print H2O Shipping labels
forward
global type w_h2o_labels from w_main_ancestor
end type
type cb_label_print from commandbutton within w_h2o_labels
end type
type dw_label from u_dw_ancestor within w_h2o_labels
end type
type cb_label_selectall from commandbutton within w_h2o_labels
end type
type cb_label_clear from commandbutton within w_h2o_labels
end type
type cbx_part_labels from checkbox within w_h2o_labels
end type
end forward

global type w_h2o_labels from w_main_ancestor
integer width = 3191
integer height = 1788
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
global w_h2o_labels w_h2o_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels

Datastore idw_content_label

String	isUCCSCompanyPrefix, isUCCSWHPrefix

String	isDONO, is_sql

integer ii_total_qty_cartons, ilCartonCount
end variables

forward prototypes
protected function string uf_get_scc (readonly string ascartonno, string asdono)
end prototypes

event ue_print_carton();

Str_Parms	lstrparms

Long	llPackCopies, llCopyCount, llRowCount, llRowPos, ll_rtn, llLabelCount, llLabelOf,ll_carton_of
Long  ll_rowcount,ll_Findrow,ll_Nextrow,ll_sumQty,ll_carton_count,ll_count
Any	lsAny
String	lsCityStateZip, lsSKU, ls_format, ls_carton_no,	lsDONO,  ls_CustName,ls_find,lsCartonNo, lsConsolNo, lsPrinter, lsDONOPrev
String lsFind, lscustOrder

Dw_Label.AcceptText()

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

//  If we have a default printer for H2O Invoice, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','H2OLABELS','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)
 	
OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then Return 

lsDoNo = dw_label.GetITemString(1,'delivery_Master_do_no')
lsConsolNo = dw_label.GetITemString(1,'Consolidation_no')
ls_CustName = dw_label.GetItemString(1,'delivery_master_cust_name') 

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	lsDoNo = dw_label.GetITemString(llRowPos,'delivery_Master_do_no')
	
	//Reset "Box Of" For each new order
	If lsDONO <> lsDONOPrev Then
		ll_carton_of = 1
	Else
		ll_carton_of ++
	End If
	
	lsDONOPrev = lsDONO
	
	
	lsConsolNo = dw_label.GetITemString(llRowPos,'Consolidation_no')
	ls_CustName = dw_label.GetItemString(llRowPos,'delivery_master_cust_name') 

	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	ls_carton_no= dw_label.object.delivery_packing_carton_no[llRowPos]
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
	Lstrparms.String_arg[30] = dw_label.GetItemString(llRowPos,'delivery_master_Cust_code')
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
	
	Lstrparms.String_arg[10] = dw_label.GetItemString(llRowPos,'awb_bol_no') /* AWB*/
	Lstrparms.String_arg[11] = dw_label.GetItemString(llRowPos,'client_cust_po_nbr') /* PO NBR*/
	Lstrparms.String_arg[22] = dw_label.GetItemString(llRowPos,'department_name') /*Department Name*/
	Lstrparms.String_arg[23] = dw_label.GetItemString(llRowPos,'User_Field1') /* Mark For Name/Store  */
//	Lstrparms.String_arg[23] = dw_label.GetItemString(llRowPos,'delivery_detail_mark_for_Name') /* Mark For Name/Store  */
	Lstrparms.String_arg[24] = dw_label.GetItemString(llRowPos,'delivery_master_carrier') /* Carrier*/
	Lstrparms.String_arg[26] = dw_label.GetItemString(llRowPos,'carrier_pro_no') 
	Lstrparms.String_arg[20] = dw_label.GetItemString(llRowPos,'sku') /* Sku*/
	Lstrparms.String_arg[21] = dw_label.GetItemString(llRowPos,'part_upc_Code') /*UPC*/
	Lstrparms.String_arg[27] = dw_label.GetItemString(llRowPos,'description') /* 02/16 - PCONKL - Added Description for ULTA label*/
	Lstrparms.String_arg[28] = dw_label.GetItemString(llRowPos,'delivery_detail_mark_for_name') /* 02/16 - PCONKL - Added mark For Name for ULTA label*/
	Lstrparms.String_arg[60] = dw_label.GetItemString(llRowPos,'scac_code' )  /* 11/17 - Gailm - Added for Walgreens label */
	Lstrparms.String_arg[61] = dw_label.GetItemString(llRowPos,'user_field10' ) /* 11/17 - Gailm - Added for Walgreens label - Market Vendor is DM user_field10 */
	Lstrparms.String_arg[62] = String(dw_label.GetItemNumber(llRowPos,'Quantity'))
		
	// 12/03 - PCONKL - We need to pass the UCCS Prefix (Location + Company)
	//lstrparms.String_arg[35] = isuccswhprefix + isuccscompanyprefix	
	lstrparms.String_arg[35] = isuccscompanyprefix

	// sscc carton number
	lsCartonNo = trim(dw_label.GetItemString(llRowPos,'delivery_packing_carton_no')) 
	lstrparms.String_arg[48] = uf_get_scc( lsCartonNo, lsDoNo)
			
	//Carton X of Y
	
//	If dw_label.Find("delivery_packing_carton_no = 'MASTER'",1, dw_label.RowCount()) > 0 Then /* Don't include master label in count */
//		lstrparms.String_Arg[34] = String(llRowPos) +" OF " + String(llRowCount - 1)
//	Else
//		lstrparms.String_Arg[34] = String(llRowPos) +" OF " + String(llRowCount)
//	End If
		
	lstrparms.String_Arg[34] = String(ll_carton_of) +" OF " + String(dw_label.GetItemNumber(llRowPos,'c_group_count'))
	
	//09-Mar-2017 :Madhu -PEVS -504 - Kohl's -Label -START
	ll_count =i_nwarehouse.of_item_sku( gs_project, Lstrparms.String_arg[20])
	If ll_count > 0 Then
		lstrparms.String_Arg[40] =	i_nwarehouse.ids_sku.getItemstring( ll_count,"Style")
		lstrparms.String_Arg[41] =	i_nwarehouse.ids_sku.getItemstring( ll_count,"Color")
		lstrparms.String_Arg[42] =	i_nwarehouse.ids_sku.getItemstring( ll_count,"Size")
	End If
	
	lscustOrder = trim(dw_label.GetItemString(llRowPos,'delivery_master_cust_order_no'))
	
	//based on following value, making invisible columns on label
	If Pos(upper(lstrparms.String_Arg[12]),'KOHL') > 0 Then
		If (Right(lscustOrder,4) = Right(Lstrparms.String_arg[23],4)) Then
			lstrparms.String_Arg[45] = "BulkLabel"
		else
			lstrparms.String_Arg[45] = "MarkForLabel"
		End If
	End If
	//09-Mar-2017 :Madhu -PEVS -504 - Kohl's -Label -END
	
	//Either Master or Carton level label
	
	//Kohl's Master label
	If ls_carton_no = 'MASTER' Then
		
		lsAny=lstrparms		
		invo_labels.setparms( lsAny )
		invo_labels.uf_h2o_kohls_master(lsAny)
			
	Else
		
		//invo_labels.setLabelSequence( llRowPos )
		lsAny=lstrparms		
		invo_labels.setparms( lsAny )
		invo_labels.uf_h2o_ucc_labels(lsAny)
		
	End IF
	
		
	dw_label.SetITem(llRowPos,'c_print_ind','N')	 
	
Next /*detail row to Print*/

// We want to store the last printer used for Printing the H2O Invoice for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','H2OLABELS',lsPrinter)

end event

event ue_sort();
String	lsSort

setNull(lsSort)

dw_label.SetSort(lsSort)
dw_label.Sort()
end event

protected function string uf_get_scc (readonly string ascartonno, string asdono);String lsCartonNo ,lsUCCS,lsDONO,lsOutString,lsDelimitChar
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
    liCartonNo = long(lsCartonNo)
  // lsCartonNo = right(lsDONO, 5) + string(liCartonNo, '00000') 
   lsCartonNo =string(liCartonNo, '000000000') 
   lsUCCS =  trim((isUCCSCompanyPrefix +  lsCartonNo))
	
   //From BaseLine
   liCheck = f_calc_uccs_check_Digit(lsUCCS) 
	
 //09-Mar-2017 :Madhu -PEVS -504 - Kohl's -Label - Removed Prefix "00" from lsUCCS
	If liCheck >=0 Then
   		lsUCCS = lsUCCS + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
   Else
     	lsUCCS = String(lsUCCS, '00000000000000000') + "0" //09-Mar-2017 :Madhu -PEVS -504 - Kohl's -Label -Reduced length to 18 digits
   End IF
   
	lsOutString += lsUCCS  + lsDelimitChar
	
end if

Return lsOutString
end function

on w_h2o_labels.create
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

on w_h2o_labels.destroy
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

event ue_retrieve;call super::ue_retrieve;String	lsDONO,	&
			lsCartonNo, lsSKU, lsUPC, lsWhere, lsModify, lsNewSql, lsDesc
			
String		lsSCACCode	, lsCarrier, lsVendor	/* Walgreens label (H2O) */

Long		llRowCount,	&
			llRowPos, llCount, llPos
Decimal	ldPackQty
boolean	lbSortBySku

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

dw_label.SetRedraw(False)

dw_label.Retrieve()

//If isdono > '' Then
//	dw_label.Retrieve(gs_project,isdono)
//End If

setpointer(hourglass!)


If dw_label.RowCount() > 0 Then
Else
	Messagebox('Labels','Order Not found or Packing List not yet generated!')
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


//SKU/UPC only needed on certain labels - If more than 1 SKU in the carton, set to 'Mixed'
//02/16 - PCONKL - Added Ulta 
//GailM 11/09/2017 SIMSPEVS-896 - HCL h2o Plus - New UCC128/GS1 label for Walgreens

If Pos(upper(dw_label.getItemString(1,'delivery_Master_cust_name')),'MCX') > 0 or Pos(upper(dw_label.getItemString(1,'delivery_Master_cust_name')),'MARINE CORPS EXCHANGE') > 0  or &
	Pos(upper(dw_label.getItemString(1,'delivery_Master_cust_name')),'ULTA') > 0 or dw_label.getItemString(1,'delivery_Master_cust_code') = '20325' or & 
	Pos(upper(dw_label.getItemString(1,'delivery_Master_cust_name')),'KOHLS') > 0 or dw_label.getItemString(1,'delivery_Master_cust_code') = '20425' or & 
	dw_label.getItemString(1,'delivery_Master_cust_code') = '05062' or &
	Pos(upper(dw_label.getItemString(1,'delivery_Master_cust_name')),'WALGREENS') > 0 or dw_label.getItemString(1,'delivery_Master_cust_code') = '20435' OR & 
	Pos(upper(dw_label.getItemString(1,'delivery_Master_cust_name')),'DUANE READE' ) > 0 or dw_label.getItemString(1,'delivery_Master_cust_code') = '20340' & 
	Then 				/*Customer name contains MCX or ULTA*/

	For llRowPos = 1 to llRowCount /* 1 row per carton*/
	
		lsCartonNo = dw_label.GetITemString(llRowPos,'delivery_packing_carton_no')
	
		Select Count(Distinct SKU) into :llCount
		From Delivery_Packing
		Where do_no = :lsdono and carton_no = :lsCartonNo
		Using SQLCA;

		If llCount > 1 then
			lsSKU = 'Mixed'
			lsUPC = 'Mixed'
		Else
	
			Select Min(SKU) into :lsSKU
			From Delivery_Packing
			Where do_no = :lsdono and carton_no = :lsCartonNo
			Using SQLCA;
		
			Select Min(part_upc_Code), Min(description) into :lsUPC, :lsDesc
			From Item_Master
			Where Project_id = :gs_Project and sku = :lsSKU
			Using SQLCA;
	
		End If
	
		dw_label.SetItem(llRowPos, 'sku',lsSKU)
		dw_label.SetItem(llRowPos,'part_upc_Code',lsUPC)
		dw_label.SetItem(llRowPos,'description',lsDesc)
	
	next
	
	lbSortBySku = True


End If /*MCX Customer*/

//Kohl's needs a MAster label. Insert a row so user can select if they want to print
If Pos(upper(dw_label.getItemString(1,'delivery_Master_cust_name')),'KOHL') > 0 Then /*Customer name contains KOHL*/

	dw_label.rowsCopy(1,1,Primary!,dw_label,999999,Primary!)
	dw_label.SetITem(dw_label.RowCount(),'delivery_packing_carton_no','MASTER')
	dw_label.SetITem(dw_label.RowCount(),'c_print_qty',1)
	dw_label.SetItem(dw_label.RowCount(), 'sku','')
	dw_label.SetItem(dw_label.RowCount(),'part_upc_Code','')
	dw_label.SetItem(dw_label.RowCount(),'User_field1','')
	//dw_label.SetItem(dw_label.RowCount(),'delivery_Detail_mark_for_Name','')
	
	//Get Order Qty for Qty field
	Select Sum(Quantity) into :ldPackQty
	From Delivery_Packing
	Where do_no = :isdono;

	dw_label.SetItem(dw_label.RowCount(),'quantity',ldPackQty)

End If

//If retrieving by SKU, Sort by SKU
// 06/16 - PCONKL - Changed sort to SKU, Qty, Carton for all orders per Fred Somers/Scott Foss
//if lbSortBySku Then
	dw_label.SetSort("sku A, Quantity A, delivery_packing_carton_no A")
	dw_label.Sort()
//End If

setpointer(arrow!)
dw_label.SetRedraw(True)

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

type cb_cancel from w_main_ancestor`cb_cancel within w_h2o_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_h2o_labels
integer x = 1874
integer y = 28
integer height = 80
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_label_print from commandbutton within w_h2o_labels
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

type dw_label from u_dw_ancestor within w_h2o_labels
integer x = 9
integer y = 140
integer width = 3127
integer height = 1456
boolean bringtotop = true
string dataobject = "d_h2o_uccs_ship"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;
If upper(dwo.Name) = 'C_PRINT_IND' and data = 'Y' Then cb_label_print.Enabled = True
end event

type cb_label_selectall from commandbutton within w_h2o_labels
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

type cb_label_clear from commandbutton within w_h2o_labels
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

type cbx_part_labels from checkbox within w_h2o_labels
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

