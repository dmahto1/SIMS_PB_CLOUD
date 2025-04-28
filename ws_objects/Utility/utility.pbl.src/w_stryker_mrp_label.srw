$PBExportHeader$w_stryker_mrp_label.srw
$PBExportComments$Print Generic UCCS Shipping labels
forward
global type w_stryker_mrp_label from w_main_ancestor
end type
type cb_label_print from commandbutton within w_stryker_mrp_label
end type
type dw_label from u_dw_ancestor within w_stryker_mrp_label
end type
type cb_label_selectall from commandbutton within w_stryker_mrp_label
end type
type cb_label_clear from commandbutton within w_stryker_mrp_label
end type
end forward

global type w_stryker_mrp_label from w_main_ancestor
integer width = 4462
integer height = 1788
string title = "Stryker MRP Label"
long backcolor = 67108864
event ue_print ( )
cb_label_print cb_label_print
dw_label dw_label
cb_label_selectall cb_label_selectall
cb_label_clear cb_label_clear
end type
global w_stryker_mrp_label w_stryker_mrp_label

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels

String	isUCCSCompanyPrefix, isUCCSWHPrefix

String	isRONO
end variables

event ue_print();Str_Parms	lstrparms

Long	llQty, llRowCount, llRowPos, ll_rtn, ll_alloc_qty, llRowPos1, llLabelCount, llLabelOf, liCurrentRow, ll_no_of_copies, i
		
Any	lsAny

String	lsCityStateZip, lsSKU, ls_format, ls_old_carton_no,ls_carton_no,ls_old_carton_no1,ls_carton_no1,	&
			lsDONO, lsCartonHold, lsPrintText
			
Boolean lb_generic,lb_print_mixed ,lb_duplicate_carton,lb_print
long ll_tot_metrics_weight,ll_tot_english_weight,ll_cnt,ll_cnt1,ll_carton_cnt,ll_count,ll_count_prev, llPrintJob

n_warehouse l_nwarehouse 
n_cst_common_tables ln_common_tables

Dw_Label.AcceptText()

datastore lds_label

lds_label = create datastore;
lds_label.dataobject = "d_stryker_label"
lds_label.SetTransObject(SQLCA)

If dw_label.Find("c_print_ind = 'Y'",1,dw_label.RowCount()) = 0 Then
	MessageBox('Labels',"at least one row must be selected for printing!")
	Return
End If

OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then Return 

lsPrintText = 'Stryker MRP'

////Open Printer File 
llPrintJob = PrintOpen(lsPrintText)
	
If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to Print. Labels will not be printed')
	Return
End If


//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	
	lds_label.Reset()
	
	liCurrentRow = lds_label.InsertRow(1)
	
	llQty = dw_label.object.c_qty_per_carton[llRowPos] /*Number of copies from Setup window*/
//	Lstrparms.Long_arg[1] = llQty
			
			
	//Sku
	lds_label.SetItem( liCurrentRow, "sku", dw_label.GetItemString(llRowPos,'sku'))
	
	//Location
	lds_label.SetItem( liCurrentRow, "location",  dw_label.GetItemString(llRowPos,'l_code'))	
	
	//License No
	lds_label.SetItem( liCurrentRow, "license_no", dw_label.GetItemString(llRowPos,'license_no'))	


	//Date of Import
	lds_label.SetItem( liCurrentRow, "date_of_import", string(dw_label.GetItemDateTime(llRowPos,'complete_date'), "MMM-yyyy"))	


	//MRP
	
	lds_label.SetItem( liCurrentRow, "mrp", String(dw_label.GetItemNumber(llRowPos,'mrp_price')))			


	
//No of copies
ll_no_of_copies = lstrparms.Long_Arg[1]
FOR i= 1 TO llQty
//	PrintSend(llPrintJob, lsformat)	
	PrintDatawindow(llPrintJob, lds_label)	
NEXT

			
	 
Next /*detail row to Print*/

PrintClose(llPrintJob)


end event

on w_stryker_mrp_label.create
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

on w_stryker_mrp_label.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_label_print)
destroy(this.dw_label)
destroy(this.cb_label_selectall)
destroy(this.cb_label_clear)
end on

event ue_postopen;call super::ue_postopen;

invo_labels = Create n_labels
//i_nwarehouse = Create n_warehouse

cb_label_print.Enabled = False

//We can only print based on RO_NO - User must have valid order open to pass RO_NO in from w_RO
If isVAlid(w_ro) Then
	if w_ro.idw_main.RowCOunt() > 0 Then
		isRoNo = w_ro.idw_main.GetITemString(1,'ro_no')
	End If
End If

If isNUll(isRoNo) or  isRoNo = '' Then
	Messagebox('Labels','You must have an order retrieved in the Receive Order Window~rbefore you can print labels!')
Else
	This.TriggerEvent('ue_retrieve')
End If



end event

event ue_retrieve;call super::ue_retrieve;String		lsRONO,	&
			lsCartonNo

Long		llRowCount,	&
			llRowPos


cb_label_print.Enabled = False

If isrono > '' Then
	dw_label.Retrieve(isrono)
End If

//BCR 07-SEP-2011: RUN-WORLD saves a 0 carton number row into Delivery_Packing. Need to filter it out.


If dw_label.RowCOunt() > 0 Then
Else
	Messagebox('Labels','No Skus with MRP on this order!')
	Return
End If

lsRoNo = dw_label.GetITemString(1,'ro_no')

//Default the Label Format and Starting Carton Number
llRowCount = dw_label.RowCount()

integer li_idx, li_RowCount

string ls_sku, ls_supp_code

long ld_mrp_price
string ls_country, ls_state, ls_license_no

datawindowchild ldw_child

dw_label.GetChild( "license_no", ldw_child)

ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(isRoNo)


datastore lds_stryker_sku_mrp_list

lds_stryker_sku_mrp_list = create datastore
lds_stryker_sku_mrp_list.dataobject = 'd_stryker_sku_mrp_list'
lds_stryker_sku_mrp_list.SetTransObject(SQLCA)

lds_stryker_sku_mrp_list.Retrieve(isRoNo)





for li_idx = 1 to llRowCount
	
	ls_sku = dw_label.GetItemString( li_idx, "sku" )
	ls_supp_code = dw_label.GetItemString( li_idx, "supp_code" )
	
	 lds_stryker_sku_mrp_list.SetFilter("sku='"+ls_sku+"' and supp_code = '"+ls_supp_code+"'")
	lds_stryker_sku_mrp_list.Filter()
	
	
	
	li_RowCount = lds_stryker_sku_mrp_list.RowCount()
	

	
	if li_RowCount = 1 then
		
		dw_label.SetItem( li_idx, "license_no", lds_stryker_sku_mrp_list.GetItemString( 1, "License_Number"))
		dw_label.SetItem( li_idx, "country", lds_stryker_sku_mrp_list.GetItemString( 1, "country_of_manufacturer"))
		dw_label.SetItem( li_idx, "state", lds_stryker_sku_mrp_list.GetItemString( 1, "state"))
		dw_label.SetItem( li_idx, "mrp_price", lds_stryker_sku_mrp_list.GetItemNumber( 1, "mrp_price"))
		
	end if
	
	if li_RowCount > 0 then
		
	end if
		
next



end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','Y')
	dw_label	.SetItem( llRowPos, "c_qty_per_carton", 1)
		

Next

dw_label.SetRedraw(True)

cb_label_print.Enabled = True

end event

event ue_unselectall;call super::ue_unselectall;Long	llRowPos,	&
		llRowCount, ll_null
		
SetNull(ll_null)

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','N')
	dw_label.SetItem( llRowPos, "c_qty_per_carton", ll_null)
Next

dw_label.SetRedraw(True)

cb_label_print.Enabled = False

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_stryker_mrp_label
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_stryker_mrp_label
integer x = 1769
integer y = 24
integer height = 80
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_label_print from commandbutton within w_stryker_mrp_label
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

type dw_label from u_dw_ancestor within w_stryker_mrp_label
event ue_dropdown pbm_dwndropdown
integer x = 9
integer y = 136
integer width = 4398
integer height = 1456
boolean bringtotop = true
string dataobject = "d_stryker_label_mrp_list"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_dropdown;
datawindowchild ldw_child
	
string ls_sku, ls_supp_code	
integer li_idx
	
dw_label.GetChild( "license_no", ldw_child)	
	
ls_sku = dw_label.GetItemString( dw_label.GetRow(), "sku" )
ls_supp_code = dw_label.GetItemString( dw_label.GetRow(), "supp_code" )

 ldw_child.SetFilter("sku='"+ls_sku+"' and supp_code = '"+ls_supp_code+"'")
ldw_child.Filter()
	
end event

event itemchanged;call super::itemchanged;
long ll_null

SetNull(ll_null)

Choose CASE upper(dwo.Name) 
	
Case 'C_PRINT_IND' 

	If data = 'Y' Then 
		cb_label_print.Enabled = True
		
		SetItem( row, "c_qty_per_carton", 1)
		
	Else
		
		SetItem( row, "c_qty_per_carton", ll_null)
		
	End IF
	
Case 'LICENSE_NO'
	
	
	datawindowchild ldw_child
	dw_label.GetChild( "license_no", ldw_child)	
	
	dw_label.SetItem( row, "license_no", ldw_child.GetItemString( ldw_child.GetRow(), "License_Number"))
	dw_label.SetItem( row, "country", ldw_child.GetItemString( ldw_child.GetRow(), "country_of_manufacturer"))
	dw_label.SetItem( row, "state", ldw_child.GetItemString( ldw_child.GetRow(), "state"))
	dw_label.SetItem( row, "mrp_price", ldw_child.GetItemNumber( ldw_child.GetRow(), "mrp_price"))
		
//string ls_sku, ls_supp_code	
//integer li_idx
//
//	
//ls_sku = dw_label.GetItemString( dw_label.GetRow(), "sku" )
//ls_supp_code = dw_label.GetItemString( dw_label.GetRow(), "supp_code" )
//
// ldw_child.SetFilter("sku='"+ls_sku+"' and supp_code = '"+ls_supp_code+"'")
//ldw_child.Filter()
	
	
End Choose
end event

type cb_label_selectall from commandbutton within w_stryker_mrp_label
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

type cb_label_clear from commandbutton within w_stryker_mrp_label
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

