$PBExportHeader$w_ibm_pondicherry_invoice_rpt.srw
$PBExportComments$This window is used for reporting the invoice information
forward
global type w_ibm_pondicherry_invoice_rpt from w_std_report
end type
end forward

global type w_ibm_pondicherry_invoice_rpt from w_std_report
integer width = 3607
integer height = 2116
string title = "IBM Pondicherry Invoice Rpt"
end type
global w_ibm_pondicherry_invoice_rpt w_ibm_pondicherry_invoice_rpt

type variables
Datastore ids_find_warehouse
boolean ib_first_time
string is_warehouse_code
string is_warehouse_name
string is_origsql, isDoNo
end variables

on w_ibm_pondicherry_invoice_rpt.create
call super::create
end on

on w_ibm_pondicherry_invoice_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
is_OrigSql = dw_report.getsqlselect()
//messagebox("is origsql",is_origsql)





end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-50)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_postopen;call super::ue_postopen;//We can only print based on DO_NO - User must have valid order open to pass DO_NO in from w_DO
If isVAlid(w_do) Then
	if w_do.idw_main.RowCOunt() > 0 Then
		isDoNo = w_do.idw_main.GetITemString(1,'do_no')
	End If
End If

//If Parm passed in for High Seas version, change dataobject
If is_process = 'H' Then /*High Seas*/
	dw_report.dataobject = 'd_ibm_pondicherry_invoice_highSea_master'
	dw_report.SetTransObject(SQLCA)
End If

If isNUll(isDONO) or  isDoNO = '' Then
	Messagebox('Invoice','You must have an order retrieved in the Delivery Order Window~rbefore you can print the Invoice!')
Else
	This.TriggerEvent('ue_retrieve')
End If


end event

event ue_retrieve;
string ls_do_no, lsInvAmt
Decimal	ldAmt

DataWindowChild state_child
Long ll_balance
Long i
long ll_cnt,ll_newrow
long ll_find_row
long ll_number
int li_rowcount
str_parms	lstrParms
datastore lds_lookuptable,lds_order_detail

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()
//dw_report.SetRedraw(false)

//check the 'po_no' and calculate invoice total so we can pass in the total in words as a parm instead of trying to access fields in nested report
lds_order_detail =create datastore
lds_order_detail.dataobject = 'd_ibm_pondicherry_invoice_detail'
lds_order_detail.settransobject(sqlca)
li_rowcount=lds_order_detail.retrieve(isDONO,'','')

ldAmt = 0

for i=1 to li_rowcount
	
	if dec(lds_order_detail.getitemstring(i,"po_no"))=0 then
	 messagebox("Error","Rate/Unit must be numeric,pls check before printing invoice")
	 dw_report.SetRedraw(True)
	 return
   end if
	
	ldAmt = ldAmt + Round((lds_order_detail.GetITemNumber(i,'quantity') * dec(lds_order_detail.getitemstring(i,"po_no"))),2)
	
next

//If not High Seas, add tax
If is_process = 'H' Then /*High Seas*/
Else
	//multuply line items by .01 for tax)
	ldAmt += (ldAmt * .01)
End IF

ldAmt = round(ldAmt,0) /* round to 0 decimals*/

//Convert to words - Prompt user to enter the correct amount in words instead of us generating the text
//lsInvAmt = g.uf_num_to_words(ldAmt)

If ldAmt > 0 Then
	
	lstrParms.Long_arg[1] = ldAmt
	OpenWithParm(w_ibm_pondicherry_invoice_rpt_Prompt,lstrparms)
	lstrparms = message.PowerObjectparm
	If lstrparms.Cancelled Then Return
	lsInvAmt = lstrparms.String_arg[1]
End If

ll_cnt = dw_report.Retrieve(isDoNo, gs_userID, lsInvAmt) /* userid and invoice amt in words passed to nested report for 'prepared by' and Amount in Words fields */
	
If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found, or order status not in 'Complete' or 'Delivered'!")
	dw_report.SetRedraw(True)
	return 
	dw_select.Setfocus()
			
END IF
	




//



//*get the data from lookup table by project and code id
lds_lookuptable = create datastore
lds_lookuptable.dataobject = 'd_lookup_table'
lds_lookuptable.settransobject(sqlca)
li_rowcount=lds_lookuptable.retrieve(gs_project,'INV')

if li_rowcount>0 then
	
   
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV1'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv1.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV2'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv2.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV3'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv3.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV4'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv4.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV5'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv5.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV6'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv6.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV7'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv7.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV8'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv8.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV9'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv9.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV10'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv10.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV11'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv11.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV12'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv12.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV13'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv13.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV14'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv14.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV15'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv15.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV16'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv16.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV17'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv17.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV18'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv18.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
  ll_find_row = lds_lookuptable.Find ("code_id = 'INV19'",1,lds_lookuptable.RowCount())
  if ll_find_row >0 then
   dw_report.object.t_inv19.text=lds_lookuptable.getitemstring(ll_find_row,'code_descript')
  end if
  
end if


//dw_report.SetRedraw(True)

is_warehouse_code = " "



end event

type dw_select from w_std_report`dw_select within w_ibm_pondicherry_invoice_rpt
boolean visible = false
integer y = 28
integer width = 2688
integer height = 80
string dataobject = "d_invoice_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;long		ll_row
long		ll_find_row

string 	ls_value
string	ls_warehouse_name


//Create the locating warehouse name datastore
ids_find_warehouse = CREATE Datastore 
ids_find_warehouse.dataobject = 'd_find_warehouse'
ids_find_warehouse.SetTransObject(SQLCA)
ids_find_warehouse.Retrieve()

//ll_row = This.insertrow(0)
ib_first_time = true


//dw_select.SetItem(ll_row,"warehouse",gs_default_wh)
//ls_value = dw_select.GetItemString(1,"warehouse")
//
//ll_find_row = ids_find_warehouse.Find ("wh_code = '" + ls_value + "'",&
//																1,ids_find_warehouse.RowCount())
//IF ll_find_row > 0 THEN
//	is_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
//	is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
//	dw_select.SetItem(1,"warehouse",is_warehouse_name)
//	
//END IF


end event

type cb_clear from w_std_report`cb_clear within w_ibm_pondicherry_invoice_rpt
end type

type dw_report from w_std_report`dw_report within w_ibm_pondicherry_invoice_rpt
integer y = 24
integer width = 3520
integer height = 1792
string dataobject = "d_ibm_pondicherry_invoice_master"
boolean hscrollbar = true
end type

