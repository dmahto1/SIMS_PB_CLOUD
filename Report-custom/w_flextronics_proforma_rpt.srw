HA$PBExportHeader$w_flextronics_proforma_rpt.srw
$PBExportComments$Delivery Report
forward
global type w_flextronics_proforma_rpt from w_std_report
end type
type sle_order from singlelineedit within w_flextronics_proforma_rpt
end type
type st_1 from statictext within w_flextronics_proforma_rpt
end type
end forward

global type w_flextronics_proforma_rpt from w_std_report
integer width = 3506
integer height = 2268
string title = "Flextronics Proforma Invoice"
sle_order sle_order
st_1 st_1
end type
global w_flextronics_proforma_rpt w_flextronics_proforma_rpt

type variables
String isOrigSql
Datastore ids_packing_carton

end variables

event ue_retrieve;call super::ue_retrieve;//Jxlim 08/30/2010
String  ls_order, ls_dono, lsmodify, ls_carton, ls_length, ls_width, ls_height, ls_ctn_type, ls_gweight, ls_dim		
Long    ll_cnt, ll_carton_row, i, ll_tweight

If dw_select.AcceptText() = -1 Then Return

//Traking Order
ls_order = sle_order.Text

SetPointer(HourGlass!)
dw_report.Reset()
dw_report.setredraw(False)

ids_packing_carton = Create Datastore
ids_packing_carton.DataObject = 'd_flextronics_packing_carton_no'
ids_packing_carton.SetTransObject(Sqlca)

				If  ls_order <> '' then
					ls_order = Trim(ls_order)
						
					Select  do_no into :ls_dono 
					From   delivery_master
					Where delivery_master.Project_id = :gs_project
					And	 delivery_master.invoice_no = :ls_order 
					Using   SQLCA;
					
					dw_report.Retrieve(ls_dono)
					ll_cnt = dw_report.RowCount()	
					
								If ll_cnt > 0 Then						
									//Jxlim 09/30/2010 Datastore for getting packing carton and dim information
									ids_packing_carton.Retrieve(ls_dono)	
									ll_carton_row = ids_packing_carton.rowCount()
									For i =1 to ll_carton_row
										ls_carton     += ids_packing_carton.getItemString(i, "carton_no") + "~r" 
										ls_dim 		  += string(ids_packing_carton.getitemDecimal(i,"length")) + ' x ' + string(ids_packing_carton.getitemDecimal(i,"width")) + ' x ' + string(ids_packing_carton.getitemDecimal(i,"height")) + "~r" 
								     	ls_gweight  += String(ids_packing_carton.getItemDecimal(i, "weight_gross")) + "~r" 	
										ls_ctn_type += ids_packing_carton.getItemString(i, "Carton_Type") + "~r" 
										//Get Total Weight	
										ll_tweight  += ids_packing_carton.getItemDecimal(i, "weight_gross")
									Next	
											//Clear out existing Carton																		
//												lsmodify = "carton_t.Text = '' "
//												lsmodify = "dim_t.Text = '' "													
//												lsmodify = "gweight_t.Text = '' "	
//												lsmodify = "ctntype_t.Text= '' "		
												
												lsModify += "carton_t.text= '" + ls_carton + "'"											
												lsModify += "dim_t.text= '" + ls_dim+ "'"														
												lsModify += "gweight_t.text= '" + ls_gweight + "'"		
												
												//Set null value to empty string to prevent froem Null at lsModify which cause the final lsModify to be null.
												If IsNull(ls_ctn_type) Then
													ls_ctn_type = ""
												End if
												lsModify += "ctntype_t.text= '" + ls_ctn_type + "'"			
												
								End If									
								
					//Get # of carton rows			
					lsModify += "carton_rows_t.text= '" + String(ll_carton_row) + "'"						
					
					//Get Total Weight	
					lsModify += "tweight_t.text= '" + string(ll_tweight ) + '.00000' + "'"			
										
					dw_report.Modify(lsModify)	
										
					If ll_cnt > 0 Then
						im_menu.m_file.m_print.Enabled = True
						dw_report.Setfocus()				
										
					Else /*null*/
						im_menu.m_file.m_print.Enabled = False	
						MessageBox(is_title, "Order not found!")
						sle_order.SetFocus()
						Return						
					End If
					
				End If
				
//Jxlim 09/28/2010 Line item no and user
//DO Supplier Code is from Delivey Picking Detail table, Lot_no field/
//Lot_no field is made up from supplier_code + '-' + Delivey_Picking_Detail.line_item_no
//Example: XT6920-00000100001
//Line item from Sims doesn't mean the same for Flextronic.
//For Flextronic, it used receive_detail.user_field3 as Line Item No, hence we can't join the line item to DO directly.
//We have to get the partial of lot_no (the Delivey_Picking_Detail.line_item_no portion) to get the line item,
//then join with the receive_detail.user_field3

dw_report.setredraw(True)
end event

event ue_postopen;call super::ue_postopen;//Jxlim 08/30/2010
dw_report.Resize(workspacewidth() - 40,workspaceHeight()-200)
end event

event resize;call super::resize;//Jxlim 08/30/2010
dw_report.Resize(workspacewidth() - 30,workspaceHeight()-270)
end event

on w_flextronics_proforma_rpt.create
int iCurrent
call super::create
this.sle_order=create sle_order
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_order
this.Control[iCurrent+2]=this.st_1
end on

on w_flextronics_proforma_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_order)
destroy(this.st_1)
end on

event open;call super::open;isOrigSql = dw_report.getsqlselect()
end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

type dw_select from w_std_report`dw_select within w_flextronics_proforma_rpt
boolean visible = false
integer x = 64
integer y = 1728
integer width = 3209
integer height = 136
integer taborder = 0
boolean enabled = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_flextronics_proforma_rpt
integer x = 2761
integer y = 1736
integer taborder = 0
end type

type dw_report from w_std_report`dw_report within w_flextronics_proforma_rpt
string tag = "Flextronic Proforma Invoice"
integer x = 46
integer y = 176
integer width = 3401
integer height = 1804
integer taborder = 0
string title = "Flextronic Proforma Invoice"
string dataobject = "d_flextronics_proforma_invoice_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type sle_order from singlelineedit within w_flextronics_proforma_rpt
integer x = 453
integer y = 40
integer width = 805
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

event modified;Parent.TriggerEvent('ue_retrieve')
end event

type st_1 from statictext within w_flextronics_proforma_rpt
integer x = 105
integer y = 52
integer width = 338
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Order Nbr:"
boolean focusrectangle = false
end type

