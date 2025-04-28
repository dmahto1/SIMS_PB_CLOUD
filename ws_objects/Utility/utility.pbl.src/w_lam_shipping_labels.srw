$PBExportHeader$w_lam_shipping_labels.srw
$PBExportComments$Print Scitex Shipping labels
forward
global type w_lam_shipping_labels from w_main_ancestor
end type
type cb_print from commandbutton within w_lam_shipping_labels
end type
type dw_label from u_dw_ancestor within w_lam_shipping_labels
end type
type cb_selectall from commandbutton within w_lam_shipping_labels
end type
type cb_clear from commandbutton within w_lam_shipping_labels
end type
type cb_copy_row from commandbutton within w_lam_shipping_labels
end type
end forward

global type w_lam_shipping_labels from w_main_ancestor
integer width = 3977
integer height = 1796
string title = " LAM-SG Shipping Labels"
event ue_print ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_clear cb_clear
cb_copy_row cb_copy_row
end type
global w_lam_shipping_labels w_lam_shipping_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels


String	isDONO
end variables

event ue_print();Str_Parms	lstrparms

Long	llQty, llRowCount, llRowPos, ll_rtn, ll_alloc_qty, llRowPos1, llLabelCount, llLabelOf
		
Any	lsAny

String	lsCityStateZip, lsSKU, ls_format, ls_old_carton_no,ls_carton_no,ls_old_carton_no1,ls_carton_no1,	&
			lsDONO
			
Boolean lb_generic,lb_print_mixed ,lb_duplicate_carton,lb_print

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


//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
	IF dw_label.object.c_print_ind[llRowPos] <> 'Y' THEN Continue
	

	//2 = qty
	//3 = sku
	//4 = cust_part
	//5 = do_no
	//6 = po_no
	//7 = delivery_date		
			
		  
	//LstrParms.String_arg[1] = dw_label.object.customer_user_field2[llRowPos] +".DWN"// **Change Later
	Lstrparms.String_arg[2] = String(dw_label.GetItemNumber(llRowPos,'alloc_qty'))
	Lstrparms.String_arg[3] = dw_label.GetItemString(llRowPos,'sku')
	Lstrparms.String_arg[4] = dw_label.GetItemString(llRowPos,'c_cust_sku')
	Lstrparms.String_arg[5] = dw_label.GetItemString(llRowPos,'Invoice_No')
	Lstrparms.String_arg[6] = dw_label.GetItemString(llRowPos,'Cust_Order_No')
	Lstrparms.String_arg[7] = string(dw_label.GetItemDatetime(llRowPos,'request_Date'), 'MM/DD/YY')
	Lstrparms.String_arg[8] = dw_label.GetItemString(llRowPos,'ord_type')
	Lstrparms.String_arg[9] = string(dw_label.GetItemNumber(llRowPos,'line_item_no'))
	Lstrparms.Long_Arg[1] = dw_label.GetItemNumber(llRowPos,'c_print_qty')


	lsAny=lstrparms		
	invo_labels.uf_lam_zebra_ship(lsAny)
	
 
Next /*detail row to Print*/

end event

on w_lam_shipping_labels.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_label=create dw_label
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
this.cb_copy_row=create cb_copy_row
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_clear
this.Control[iCurrent+5]=this.cb_copy_row
end on

on w_lam_shipping_labels.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_selectall)
destroy(this.cb_clear)
destroy(this.cb_copy_row)
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




string lsCust, lsSku, lsSupplier, lsSKUPrev, lsCustSKU
integer liRowPos
	
//Load any customer SKUS


For liRowPos = 1 to dw_label.RowCOunt()

	lsCust = dw_label.GetITemString(liRowPos,'cust_code')
	
	lsSKU = dw_label.GetITEmString(liRowPos,'sku')
	lsSupplier = dw_label.GetITEmString(liRowPos,'supp_code')
	
	If lsSKU <> lsSKUPrev Then
		
		lsCustSKU = ''
		
		Select cust_alt_Sku into :lsCustSKU
		From item_cust_sku
		Where Project_id = :gs_project and cust_Code = :lsCust and primary_sku = :lsSKU and primary_Supp_Code = :lsSupplier;
		
		lsSKUPrev = lsSKU
		
	End IF
	
	dw_label.SetITem(liRowPos,'c_cust_sku',lsCustSKU)
	
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

cb_print.Enabled = False

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_lam_shipping_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_lam_shipping_labels
integer x = 2149
integer y = 24
integer height = 80
boolean default = false
end type

type cb_print from commandbutton within w_lam_shipping_labels
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

type dw_label from u_dw_ancestor within w_lam_shipping_labels
integer x = 9
integer y = 136
integer width = 3913
integer height = 1456
boolean bringtotop = true
string dataobject = "d_lam_shipping_label"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;
If upper(dwo.Name) = 'C_PRINT_IND' and data = 'Y' Then cb_print.Enabled = True
end event

type cb_selectall from commandbutton within w_lam_shipping_labels
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

type cb_clear from commandbutton within w_lam_shipping_labels
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

type cb_copy_row from commandbutton within w_lam_shipping_labels
integer x = 1527
integer y = 24
integer width = 389
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Copy Row"
end type

event clicked;
if dw_label.GetRow() > 0 then
	
	dw_label.RowsCopy(dw_label.GetRow(),  dw_label.GetRow(), Primary!, dw_label, dw_label.GetRow(), Primary!)
	
else
	
	MessageBox ("Error", "No Row Selected")
end if
end event

