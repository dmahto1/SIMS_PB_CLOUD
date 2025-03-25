$PBExportHeader$w_comcast_sik_batch_report.srw
forward
global type w_comcast_sik_batch_report from w_std_report
end type
end forward

global type w_comcast_sik_batch_report from w_std_report
integer width = 3515
integer height = 2240
string title = "SIK Batch Report"
end type
global w_comcast_sik_batch_report w_comcast_sik_batch_report

on w_comcast_sik_batch_report.create
call super::create
end on

on w_comcast_sik_batch_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;call super::resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-30)
end event

event ue_retrieve;call super::ue_retrieve;//Jxlim 11/22/2010 w_sik_batch
Long ll_batchid, ll_ordercount, i, ll_newrow
string ls_batchnbr, ls_ordernbr, ls_pick, ls_serial, ls_uf2, ls_trax, lsDONO
String ls_SKU, ls_supp, ls_UF4, ls_serialized_ind, ls_ThisSKU
Long llfindrow, ll_qty, ll_serial_qty
String lsfind, ls_value

ls_SKU = ""		// Get new IM data when SKU changes

If Isvalid(w_batch_pick) Then
	ll_batchId 		 = w_batch_pick.idw_master.GetitemNumber(1, "batch_pick_id")
	ls_batchnbr	 = w_batch_pick.idw_master.GetitemString(1, "batch_ref_nbr")
End IF

SetPointer(HourGlass!)
dw_report.Reset()

dw_report.SetRedraw(False)


//Order Detail
ll_ordercount = w_batch_pick.idw_detail.RowCount()		
For i = 1 to ll_ordercount
						
		   //1. Order number
		   ls_ordernbr   	= w_batch_pick.idw_detail.GetitemString(i, "invoice_no")
		   ls_uf2			= w_batch_pick.idw_detail.GetitemString(i, "dm_user_field2")
		   lsDONO		= w_batch_pick.idw_detail.GetitemString(i, "do_no")
		 
		  	/* 3/13/2012 - GXMOR - Add code for SIK Modem/Remotes */
			//1.5 Get SKU data to use OMS Document and Serialized elements			
			ls_ThisSKU = w_batch_pick.idw_detail.GetItemString(i, 'SKU')
			ls_supp = w_batch_pick.idw_detail.GetItemString(i, 'supp_code')
			If (ls_ThisSKU <> ls_SKU) Then
				ls_SKU = ls_ThisSKU
										
				Select user_field4,serialized_ind 
				Into :ls_UF4, :ls_serialized_ind
				From Item_Master 
				Where SKU = :ls_SKU and supp_code = :ls_supp
				Using SQLCA;
											
			End If
									
				//If we already have a record for the order, continue
				//Take out....  we can have multiple SKUs on an order...  GXMOR 6/15/2012
		//	If dw_Report.Find("order_nbr = '" + ls_ordernbr + "'",1,ll_ordercount) > 0 Then Continue			
			
		   //2. Letter Gen //If Delivery_Master.User_Field2 = ‘Y’ (See above), Then set ‘Letter Gen’ to ‘Y’. Otherwise set to ‘N’. 									
				// If SKU 
				IF Trim(ls_UF4) = "" or IsNull(ls_UF4) Then
					ls_uf2 = 'NA'
				Else
					If   ls_uf2 = "Y" Then
						ls_uf2 = "Y"
					Else
						ls_uf2 = 'N'
					End If	
				End If
		   //3. Pick //If there are delivery_Picking Records for the order (Records on the Pick list tab for that order number), Set ‘Picked’ to ‘Y’. Otherwise, set to ‘N’
					lsFind = "Upper(invoice_no) = '" + upper(ls_ordernbr) + "'"
					llFindRow = w_batch_pick.idw_pick.Find(lsFind,1,w_batch_pick.idw_pick.RowCount())	
					If llFindRow > 0 then
						ls_pick = 'Y'
					Else
						ls_pick = 'N'
					End If
								
		  //4. UPS Lbl //If Delivery_Packing.Trax_Ship_Ref_Nbr > ‘’ Then set ‘ UPS Lbl’ to ‘Y’, otherwise set to ‘N’. This field can be found on the TRAX tab (Do a find on Order Nummber)
					lsFind = "Upper(invoice_no) = '" + upper(ls_ordernbr) + "' and Upper(trax_ship_ref_nbr) > ''"
					llFindRow = w_batch_pick.idw_trax.Find(lsFind,1,w_batch_pick.idw_trax.RowCount())								
					If llfindRow > 0 Then
						ls_trax = 'Y'
					Else
						ls_trax = 'N'
					End If
								
		//5. Serial # Scanned	
		//If There are Delivery_Serial_Detail records and the number of serial Numbers = The Picked Qty, set ‘ Ser # Scanned’ to ‘Y’. Otherwise set to ‘N’. 
		//This will need to be pulled from the database. 
		//Compare the Sum of the picked Qty (Select Sum(quantity) from delivery_Picking where do_no = <order nbr from detail tab> “ to 
		//the sum of the serial qty (select sum(delivery_Serial_detailquantity) from Delivery_Picking_Detail,Delivery_serial_Detail 
		//where delivery_picking_detail.id_no = delivery_Serial_Detail.id_no and delivery_picking_Detail.do_no = <do_no from detail tab>). 
		//If they equal, set to ‘Y’. Otherwise set to ‘N’.
		
			/* 3/13/2012 - GXMOR - The quantities will not be match if the serialized indicator for the SKU is not set */
			If ls_serialized_ind = 'N' Then
				ls_serial = 'NA'
			else
				Select Sum(quantity) Into :ll_qty
				From Delivery_Picking 
				Where do_no = :lsDONO and sku = :ls_ThisSKU
				Using SQLCA;
									
				Select sum(delivery_Serial_detail.quantity) Into :ll_serial_qty
				From Delivery_Picking_Detail,Delivery_serial_Detail 
				Where delivery_picking_detail.id_no = delivery_Serial_Detail.id_no 
				And delivery_picking_Detail.do_no = :lsDONO 
				And delivery_picking_Detail.sku = :ls_ThisSKU
				Using SQLCA;
									
				If ll_qty = ll_serial_qty Then
					ls_serial = 'Y'
				Else
					ls_serial = 'N'
				End If			
			End If
													
								//Setitem to report						
								ll_newrow = dw_report.InsertRow(0)
								dw_report.SetItem(ll_newrow, "batch_id", ll_batchid)
								dw_report.SetItem(ll_newrow, "batch_nbr", ls_batchnbr)
								dw_report.SetItem(ll_newrow, "order_nbr", ls_ordernbr)
								dw_report.SetItem(ll_newrow, "pick", ls_pick)	
								dw_report.SetItem(ll_newrow, "serial_scanned", ls_serial)	
								dw_report.SetItem(ll_newrow, "letter_gen", ls_uf2)
								dw_report.SetItem(ll_newrow, "Ups_lbl", ls_trax)
								//If all Y then Green background
//								If ls_pick = 'Y' and ls_serial = 'Y' and ls_uf2 = 'Y' and ls_trax = 'Y' Then									
//									dw_report.Modify("color_t.Background.Color='65280'")									
//									//If all N then Red background
//								Elseif ls_pick = 'N' and ls_serial = 'N' and ls_uf2 = 'N' and ls_trax = 'N' Then
//									dw_report.Modify("color_t.Background.Color='255'")
//								Else							
//								// Yellow
//								//	dw_report.Modify("color_t.Background.Color='255'")		      //Red
//								//	dw_report.Modify("color_t.Background.Color='32768'")         //Green
//								//	dw_report.Modify("color_t.Background.Color='16777215'")  //Yellow
//								End If
Next

dw_report.Sort()
dw_report.SetRedraw(True)

im_menu.m_file.m_print.Enabled = True

end event

event ue_postopen;call super::ue_postopen;
TriggerEvent("ue_retrieve")
end event

type dw_select from w_std_report`dw_select within w_comcast_sik_batch_report
boolean visible = false
integer height = 56
boolean enabled = false
end type

type cb_clear from w_std_report`cb_clear within w_comcast_sik_batch_report
end type

type dw_report from w_std_report`dw_report within w_comcast_sik_batch_report
integer y = 28
integer width = 3342
integer height = 1924
string dataobject = "d_comcast_sik_batch_report"
boolean hscrollbar = true
end type

