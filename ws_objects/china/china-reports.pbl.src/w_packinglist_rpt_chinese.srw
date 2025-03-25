$PBExportHeader$w_packinglist_rpt_chinese.srw
forward
global type w_packinglist_rpt_chinese from w_std_report
end type
end forward

global type w_packinglist_rpt_chinese from w_std_report
integer width = 3790
integer height = 2220
string title = "Sears-Consolidated Packing List"
end type
global w_packinglist_rpt_chinese w_packinglist_rpt_chinese

on w_packinglist_rpt_chinese.create
call super::create
end on

on w_packinglist_rpt_chinese.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;//Sears-Fix packing list report 03/31/04 wason

string ls_do_no
string ls_cust_code,ls_cust_order_no
int li_count,li_rtn,k
boolean lb_selection
string ls_remark,ls_allremark, ls_order_status
string ls_carrier
datetime ld_ord_date,ld_complete_date
Datastore   ds_detail,ds_pack,ds_dolist
integer p
boolean ib_found

datastore lds_po, lds_po_multi
integer li_rtn2, li_idx, li_rtn3, li_idx2
string ls_po, ls_po_list
boolean lb_multi_run
string ls_bol, ls_last_bol

string ls_po_temp[], ls_reset_po_temp[]


lb_selection = FALSE
If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()
dw_report.setredraw(false)

ls_do_no = w_do.idw_main.getitemstring(1,"DO_NO")

select cust_code,cust_order_no into :ls_cust_code,:ls_cust_order_no from delivery_master where do_no = :ls_do_no and project_id = :gs_project;

select count(*) into :li_count from delivery_master where project_id = :gs_project and cust_code = :ls_cust_code and cust_order_no = :ls_cust_order_no and ord_status in ('N','P') ;


if li_count>0 then
	li_rtn = messagebox(is_title,"Order found in New or Picking status,Coutinue?",Exclamation!,YesNo!,2)
	if li_rtn = 2 then
	 return 
	end if
end if



ds_detail = create datastore
ds_pack = create datastore
ds_dolist = create datastore
ds_detail.Dataobject = 'd_do_detail_sears'
ds_pack.Dataobject = 'd_do_packing_grid'
ds_dolist.Dataobject = 'd_do_list_sears_packing'

ds_detail.settransobject(sqlca)
ds_pack.settransobject(sqlca)
ds_dolist.settransobject(sqlca)

li_rtn = ds_dolist.retrieve(gs_project,ls_cust_order_no,ls_cust_code) 

string ls_bad_order[]   // Bad... Bad order..
string ls_bar_order_status[]
string ls_bad_str

for li_idx = 1 to li_rtn
	
	ls_order_status = Upper(ds_dolist.GetItemString( li_idx, "ord_status"))

	if ls_order_status = 'N' OR ls_order_status = 'P' OR ls_order_status = 'I' then

		ls_bad_order[UpperBound(ls_bad_order)+1] = ds_dolist.GetItemString( li_idx, "cust_order_no")
		ls_bar_order_status[UpperBound(ls_bad_order)] = ls_order_status

	end if

next

if Upperbound(ls_bad_order) > 0 then
	
	for li_idx = 1 to UpperBound(ls_bad_order)
		
		if li_idx > 1 then ls_bad_str = ls_bad_str + " - "
		
		ls_bad_str = ls_bad_str + " Order: " + ls_bad_order[li_idx] + " Status: " + ls_bar_order_status[li_idx]
		
	next
	
	Messagebox ("Unable to open packing list.", "The following orders have a status where the packing list can not be printed. ")
	
	Post Function Close (this)
	
	return
	
end if

Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos
Decimal	ld_weight
String ls_address,lsfind,ls_text[], lscusttype, lscustcode
String ls_project_id , ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT
Datastore	ldsHazmat


SetPointer(HourGlass!)
If w_do.idw_pack.AcceptText() = -1 Then
	w_do.tab_main.SelectTab(3) 
//	w_do.idw_pack.SetFocus()
	Return 
End If

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return
End If

////No row means no Print
//ll_cnt = w_do.idw_pack.rowcount()
//If ll_cnt = 0 Then
//	MessageBox("Print Packing List"," No records to print!")
//	Return
//End If

//Clear the Report Window (hidden datawindow)
dw_report.Reset()
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")

//Get The Ship from info for Sears Only (uses Warehouse info)
lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")
Select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
Into	:lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
From warehouse
Where WH_Code = :lsWHCode
Using Sqlca;

lsTransPortMode= w_do.idw_main.GetITemString(1,'transport_Mode') /* used for printing haz mat info*/

For k = 1 to li_rtn
	ls_do_no = ds_dolist.getitemstring(k,"do_no")
   ds_detail.retrieve(ls_do_no)
   ll_cnt=ds_pack.retrieve(ls_do_no)
	
	ls_order_status = Upper(ds_dolist.GetItemString( k, "ord_status"))
	
	ls_bol = ds_dolist.getitemstring(k,"invoice_no")

	if ll_cnt = 0 and (ls_order_status = "C" or ls_order_status = "D") then

		Messagebox ("Can't create packing list.", "This has not gone through packing.")
		
		Post Function Close(this)
		return
		
	end if
	
	if ls_bol <> ls_last_bol then

		ls_po_list = ""
	
		ls_po_temp[] = ls_reset_po_temp[]
		
	end if
	
	//messagebox("",ls_do_no+'and'+string(ll_cnt))
//Loop through each row in Tab pages and grab the coresponding info
   For i = 1 to ll_cnt
	
	 j = dw_report.InsertRow(0)
	
	//Get SKU, Description and Quantities  04/05/00 PCONKL - include user field5 as pdc_whse_loc
	// include hazardous text cd
	  select carrier,ord_date,complete_date,remark 
	    into :ls_carrier, :ld_ord_date,:ld_complete_date,:ls_remark 
     from delivery_master where do_no = :ls_do_no;
	
   	ls_sku = ds_pack.getitemstring(i,"sku")
	   ls_supplier = ds_pack.getitemstring(i,"supp_code")
	   llLineItemNo = ds_pack.GetITemNumber(i,'line_item_no')
	
	   If ls_SKU <> lsSKUHold Then
		
		 select description, weight_1, hazard_text_cd
		 into :ls_description, :ld_weight, :lshazCode
		 from item_master 
		 where project_id = :ls_project_id and sku = :ls_sku and supp_code = :ls_supplier ;
		
	   End If /*Sku Changed*/
	
	   lsSkuHold = ls_SKU

	   ls_description = trim(ls_description)
	

	/* 05/2004 MA - Added Multi-PO Support */
	
	lds_po = create datastore;
	lds_po_multi = create datastore;
	
	
	lds_po.dataobject = "d_sears_bol_po"
	lds_po_multi.dataobject = "d_sears_bol_multipo"
	
	lds_po.SetTransObject(SQLCA)
	lds_po_multi.SetTransObject(SQLCA)
	
	li_rtn2 = lds_po.Retrieve(ls_do_no)
	
	
	if li_rtn2 > 0 then
	
		for li_idx = 1 to li_rtn2
			
			ls_po = lds_po.GetItemString(li_idx, "po_no")
			
			
			if upper(ls_po) = "MULTIPO" then
			
				if not lb_multi_run then
				
					li_rtn3 = lds_po_multi.Retrieve(ls_do_no)
					
				
					if li_rtn3 > 0 then
					
						lb_multi_run = true
						
						for li_idx2 = 1 to li_rtn3
						
							ls_po = trim(lds_po_multi.GetItemString(li_idx2, "receive_xref_po_no"))

							ib_found = false
	
							for p = 1 to UpperBound(ls_po_temp[])
								if ls_po = ls_po_temp[p] then
									ib_found = true
									EXIT
								end if
							next
	
							if Not ib_found then
								
								ls_po_temp[UpperBound(ls_po_temp) + 1] = ls_po
	
								if UpperBound(ls_po_temp) > 1 then
									ls_po_list = ls_po_list + ", "
								end if
							
								ls_po_list = ls_po_list + ls_po
			
							end if
			
						next
			
					end if
		
				end if
	
							
			else
	
	//--
				ib_found = false
	
				for p = 1 to UpperBound(ls_po_temp[])
					if ls_po = ls_po_temp[p] then
						ib_found = true
						EXIT
					end if
				next
	
				if Not ib_found then
								
					ls_po_temp[UpperBound(ls_po_temp) + 1] = ls_po
	
					if UpperBound(ls_po_temp) > 1 then
						ls_po_list = ls_po_list + ", "
					end if
							
					ls_po_list = ls_po_list + ls_po
			
				end if
		
			end if	
				
		next

	else
		
		ls_po_list = ""
	
	end if
	
	destroy lds_po;
	destroy lds_po_multi;

	dw_report.setitem(j,"po_no", ls_po_list)


	//Set all Items on the Report by grabbing info from tab pages

//	ls_sku = ds_pack.getitemstring(i,"sku")
	   ls_supplier = ds_pack.getitemstring(i,"supp_code")
	   llLineItemNo = ds_pack.GetITemNumber(i,'line_item_no')

	    string ls_lot_no

	  	 select lot_no
		 into :ls_lot_no
		 from delivery_picking_detail 
		 where do_no = :ls_do_no and sku = :ls_sku and Line_Item_No = :llLineItemNo ;
		
 
	  dw_report.setitem(j,"lot_no", ls_lot_no) 
	  
	  dw_report.setitem(j,"carton_no",ds_pack.getitemString(i,"carton_no")) /*Printed report should show carton # from screen instead of row #*/
	  dw_report.setitem(j,"bol_no", ls_bol ) //w_do.is_bolno)
	  dw_report.setitem(j,"ord_no",ls_cust_order_no)
	  dw_report.setitem(j,"freight_terms",w_do.idw_other.getitemstring(1,"freight_terms"))	
	  dw_report.setitem(j,"cust_code",ls_cust_code)
	  dw_report.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
	  dw_report.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
	  dw_report.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
	  dw_report.setitem(j,"complete_date",w_do.idw_main.getitemdatetime(1,"complete_date"))
	  dw_report.setitem(j,"sku",ls_sku)
	  //dw_report.setitem(j,"alt_sku",ls_alt_sku)  
	  dw_report.setitem(j,"description",ls_description)
	  dw_report.setitem(j,"unit_weight",ds_pack.getitemDecimal(i,"weight_net")) /*take from displayed pask list instead of DB*/
	  dw_report.setitem(j,"standard_of_measure",ds_pack.getitemString(i,"standard_of_measure"))
	  dw_report.setitem(j,"carrier",w_do.idw_other.getitemString(1,"carrier"))
	  dw_report.setitem(j,"ship_via",w_do.idw_other.getitemString(1,"ship_via"))
	  dw_report.setitem(j,"sch_cd",w_do.idw_other.getitemString(1,"user_field1"))
	  dw_report.setitem(j,"packlist_notes",w_do.idw_main.getitemString(1,"packlist_notes"))
	  dw_report.setitem(j,"project_id",gs_project) 
	  dw_report.setitem(j,"HazText",lshazText) 
	  //For English to Metrtics changes added L or K based on E or M
	  ls_etom=dw_report.getitemString(j,"standard_of_measure")
	  IF ls_etom <> "" and not isnull(ls_etom) and j=1 THEN
		IF ls_etom = 'E' THEN
			ls_text[1]="unit_w_t.Text='"+w_do.is_text[1]+"L'"			
			ls_text[2]="ext_w_t.Text='"+w_do.is_text[2]+"L'"
			ls_text[3]="etom_t.Text='INCHES'"
		ELSE
			ls_text[1]="unit_w_t.Text='"+w_do.is_text[1]+"K'"
			ls_text[2]="ext_w_t.Text='"+w_do.is_text[2]+"K'"
			ls_text[3]="etom_t.Text='CENTIMETERS'"
		END IF
	  END IF	
	
   //                  we may have multiple pack rows that match to a single detail row. THis will cause the Order qty
	//                  to be wrong if we simply copy it for each row (it will be multiplied by each additional row). 
	//						  If the ordered qty on the order detail = the shipped qty, we will just set the ord qty = shipped qty
	//						  If Ord Qty > shipped qty, we will set the difference on the last row for the sku, the rest will be equal
	//						This assumes that the Shipped QTY on Packing List = Alloc QTY on DEtail. This will be validated before allowing to print (wf_val)
	
	 lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLineItemNo)
	 llRow = ds_detail.Find(lsFind,1,ds_detail.RowCount())
	
	
	
//	if llRow > 0 Then
//		dw_report.setitem(j,"user_field2",ds_detail.getitemString(llRow,"user_field2")) /* 12/01 for Saltillo*/
//		dw_report.setitem(j,"alt_sku",ds_detail.getitemString(llRow,"alternate_sku"))
//	
//		If ds_detail.getitemnumber(llRow,"req_qty") = ds_detail.getitemnumber(llRow,"alloc_qty") Then
//			dw_report.setitem(j,"ord_qty",ds_pack.getitemNumber(i,"quantity"))
//		Else /*ord qty <> Alloc, if it's the last carton row for this sku, show the difference here, otherwise set to alloc*/
//			If (i = ll_cnt) or (ds_pack.Find(lsFind,(i + 1),(ll_cnt + 1)) = 0) Then /*last row for the sku*/
//				//set order qty = shipped qty for row + (order - alloc) from detail. This assumes that the Shipped QTY on Packing List = Alloc QTY on DEtail. This will be validated before allowing to print (wf_val)
//				dw_report.setitem(j,"ord_qty",(ds_pack.getitemNumber(i,"quantity") + (ds_detail.getitemnumber(llRow,"req_qty") - ds_detail.getitemnumber(llRow,"alloc_qty"))))
//			Else /* not last row for sku*/
//				dw_report.setitem(j,"ord_qty",ds_pack.getitemNumber(i,"quantity"))
//			End If
//		End If
//		
//	Else /*row not found (should never happen), set req qty to 0*/
//		dw_report.setitem(j,"cntl_number",'')
//	End If
	  if llRow > 0 then
	
	  	dw_report.setitem(j,"cntl_number",ds_detail.getitemString(llRow,"user_field1")) /* Cntrl num // detail Weight for Sears*/
		
	  end if

	  dw_report.setitem(j,"picked_quantity",ds_pack.getitemNumber(i,"quantity"))
	  dw_report.setitem(j,"volume",ds_pack.getitemDecimal(i,"cbm"))
	  If ds_pack.getitemDecimal(i,"cbm") > 0 Then
	   	dw_report.setitem(j,'dimensions',string(ds_pack.getitemDecimal(i,"length")) + ' x ' + string(ds_pack.getitemDecimal(i,"width")) + ' x ' + string(ds_pack.getitemDecimal(i,"height"))) /* 02/01 - PCONKL*/
	  End If
	  
	  
	  
	  dw_report.setitem(j,"country_of_origin",ds_pack.getitemstring(i,"country_of_origin"))
	  dw_report.setitem(j,"supp_code",ds_pack.getitemstring(i,"supp_code"))
	  dw_report.setitem(j,"serial_no",ds_pack.getitemstring(i,"free_form_serial_no"))
	  dw_report.setitem(j,"component_ind",ds_pack.getitemstring(i,"component_ind")) 
		
	  dw_report.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
	  dw_report.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
	  dw_report.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
	  dw_report.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
	  dw_report.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
	  dw_report.setitem(j,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
	  dw_report.setitem(j,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
	
	
	  dw_report.setitem(j,"remark",ls_remark)
	  //ls_allremark = ls_allremark+' '+ls_remark
	  
	  dw_report.setitem(j,"name_5",w_do.idw_main.getitemstring(1,"cust_name")+"  "+w_do.idw_main.getitemstring(1,"cust_code"))
	  dw_report.setitem(j,"name_6",w_do.idw_main.getitemstring(1,"address_1"))
	  dw_report.setitem(j,"name_7",w_do.idw_main.getitemstring(1,"city")+"  "+w_do.idw_main.getitemstring(1,"state")+","+w_do.idw_main.getitemstring(1,"zip"))

	
	
	//Ship from info is coming from Project Table  
		//"SEARS uses Warehouse info"*/
	  dw_report.setitem(j,"ship_from_name",lsName)
	  dw_report.setitem(j,"ship_from_address1",lsaddr1)
	  dw_report.setitem(j,"ship_from_address2",lsaddr2)
	  dw_report.setitem(j,"ship_from_address3",lsaddr3)
	  dw_report.setitem(j,"ship_from_address4",lsaddr4)
	  dw_report.setitem(j,"ship_from_city",lsCity)
	  dw_report.setitem(j,"ship_from_state",lsstate)
	  dw_report.setitem(j,"ship_from_zip",lszip)
	  dw_report.setitem(j,"ship_from_country",lscountry)
	
	  dw_report.setitem(j,"name_9",lsName)
	  dw_report.setitem(j,"name_10",lsaddr1)
	
	
	
	//Adding Supplier Name to Sears Packing LIst
   	Select Supp_name into :lsSupplierName
   	From Supplier
   	Where PRoject_id = :gs_project and supp_code = :ls_Supplier;
		
	  dw_report.setitem(j,"supplier_Name",lsSupplierName)
			
  Next
     if ls_allremark<>'' then
	    ls_allremark = ls_allremark+''+ls_remark
	  else
		 ls_allremark = ls_remark
	  end if
     
NEXT

i=1
FOR i = 1 TO UpperBound(ls_text[])
	dw_report.Modify(ls_text[i])
	ls_text[i]=""
NEXT

//dw_report.setitem(dw_report.rowcount(),"name_11",ls_allremark)
dw_report.object.t_po_number.text = ls_allremark
//Send the report to the Print report window
dw_report.Sort()
dw_report.GroupCalc()
dw_report.modify('DataWindow.Print.Preview ="yes"')
im_menu.m_file.m_print.Enabled = TRUE
dw_report.setredraw(true)


//OpenWithParm(w_dw_print_options,dw_report) 

//If message.doubleparm = 1 then
//	If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
//		w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
//		w_do.idw_main.SetItem(1,"ord_status","I")
//		w_do.ib_changed = TRUE
//		w_do.iw_window.trigger event ue_save()
//	End If
//End If


//ll_cnt = dw_report.Retrieve(gs_project,ls_cust_code,ls_cust_order_no)
//
//IF ll_cnt > 0  THEN
//	im_menu.m_file.m_print.Enabled = TRUE
//	dw_report.modify('DataWindow.Print.Preview ="yes"')
//	dw_report.Setfocus()
//	if mod(ll_cnt,10)<>0 then
//		for i=mod(ll_cnt,10) to 11 
//			dw_report.insertrow(0)
//		next
//	end if
//ELSE
//	im_menu.m_file.m_print.Enabled = FALSE	
//	MessageBox(is_title, "Orders found in New or Picking status!")
//	close(this)
////	dw_select.Setfocus()
////	dw_select.SetColumn('order_no')
//END IF
//		
//
//
end event

event ue_postopen;call super::ue_postopen;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-200)
//If Delivery Order is Open, default the Order to the current Delivery Order Number
If isVAlid(w_do) Then
	if w_do.idw_main.RowCOunt() > 0 Then
      if w_do.idw_main.getitemstring(1,'ord_status')='A' or w_do.idw_main.getitemstring(1,'ord_status')='C' or w_do.idw_main.getitemstring(1,'ord_status')='D' then
		 This.TriggerEvent('ue_retrieve')
	   else
		  //JXLIM 07/08/2010 Modified code for Chinese report
		  //messagebox("SEARS-FIX","The delivery must be in Packing,Complete,or delivery")
		  messagebox("Packing List","The delivery must be in Packing,Complete,or delivery")
	    close(this)
	   end if
	End If
Else
	  //JXLIM 07/08/2010 Modified code for Chinese report	
	  //messagebox("SEARS-FIX packing list","You must open a Delivery Order before you can print packing list!")
	  messagebox("Packing List","You must open a Delivery Order before you can print packing list!")
	close(this)
End If
end event

event resize;call super::resize;dw_report.Resize(workspacewidth() - 5,workspaceHeight() - 10)
end event

type dw_select from w_std_report`dw_select within w_packinglist_rpt_chinese
boolean visible = false
integer x = 5
integer width = 2994
integer height = 64
boolean enabled = false
string dataobject = "d_kn_invoice_srch"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_packinglist_rpt_chinese
integer x = 3035
integer y = 36
end type

type dw_report from w_std_report`dw_report within w_packinglist_rpt_chinese
integer x = 0
integer y = 0
integer width = 3703
integer height = 2032
string dataobject = "d_packing_prt_chinese"
boolean hscrollbar = true
boolean livescroll = false
end type

