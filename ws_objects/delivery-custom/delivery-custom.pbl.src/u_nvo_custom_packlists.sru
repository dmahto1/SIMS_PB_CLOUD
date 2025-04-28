$PBExportHeader$u_nvo_custom_packlists.sru
$PBExportComments$Project Specific Packing list logic
forward
global type u_nvo_custom_packlists from nonvisualobject
end type
end forward

global type u_nvo_custom_packlists from nonvisualobject
end type
global u_nvo_custom_packlists u_nvo_custom_packlists

type variables

end variables

forward prototypes
public function integer uf_packprint_sears ()
public function integer uf_packing_print_3com ()
public function integer uf_packingslip_gm ()
public function integer uf_batch_pack_print_gm ()
public function integer uf_packing_slip_linksys ()
public function integer uf_packing_slip_logitech ()
public function integer uf_packprint_gmbattery ()
public function string uf_replacequotes (string asstring)
public function integer uf_packprint_maquet ()
public function integer uf_packprint_powerwave ()
public function integer uf_packprint_scitex ()
public function integer uf_packprint_netapp ()
public function integer uf_packprint_sika ()
public function integer uf_packprint_lmc ()
public function integer uf_packprint_hillman_homedepot ()
public function string uf_convert_date_to_spanish (date addatetoconvert)
public function integer uf_packprint_epson ()
public function integer uf_packprint_phxbrands ()
public function integer uf_packprint_riverbed ()
public function integer uf_packprint_geistlich ()
public function integer uf_packprint_nike ()
public function integer uf_packprint_karcher ()
public function integer uf_packprint_stryker ()
public function integer uf_packprint_ariens ()
public function integer uf_process_packprint_ariens ()
public function integer uf_generate_pack_klonelab ()
public function integer uf_generate_pack_klonelab_musicalrun ()
public function integer uf_packprint_friedrich ()
public function integer uf_packprint_friedrich_grainger ()
public function integer uf_process_packprint_friedrich ()
public function integer uf_packprint_petha ()
public function integer uf_packprint_garmin ()
public function integer uf_packprint_bosch ()
public function integer uf_packprint_puma ()
public function integer uf_packprint_friedrich_grainger_dropship (string as_packlist_type)
public function integer uf_packprint_kendo ()
public function integer uf_packprint_kendo_batch ()
public function integer uf_save_packlist_pdf (string asdono)
public function integer uf_packprint_hagersg ()
public function string numtoword (integer ai_nbr)
end prototypes

public function integer uf_packprint_sears ();// 11/02 - PCONKL - QTY fields changed to Decimal

// This event prints the Packing List which is currently visible on the screen 
// and not from the database - JC

Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos
Decimal	ld_weight
String ls_address,lsfind,ls_text[], lscusttype, lscustcode
String ls_project_id , ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT
Datastore	ldsHazmat

//Set Packing List object
w_do.idw_packPrint.Dataobject = 'd_sears_packing_prt'


SetPointer(HourGlass!)
If w_do.idw_pack.AcceptText() = -1 Then
	w_do.tab_main.SelectTab(3) 
	w_do.idw_pack.SetFocus()
	Return 0 
End If

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print
ll_cnt = w_do.idw_pack.rowcount()
If ll_cnt = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

//Clear the Report Window (hidden datawindow)
w_do.idw_packprint.Reset()
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")

//gap 5/2003 Get The Ship from info for Sears Only (uses Warehouse info)
lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")
Select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
Into	:lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
From warehouse
Where WH_Code = :lsWHCode
Using Sqlca;

lsTransPortMode= w_do.idw_main.GetITemString(1,'transport_Mode') /* used for printing haz mat info*/

//Loop through each row in Tab pages and grab the coresponding info
For i = 1 to ll_cnt
	
	j = w_do.idw_packprint.InsertRow(0)
	
	//Get SKU, Description and Quantities  04/05/00 PCONKL - include user field5 as pdc_whse_loc
	// 02/02 - PConkl - include hazardous text cd
	
	ls_sku = w_do.idw_pack.getitemstring(i,"sku")
	ls_supplier = w_do.idw_pack.getitemstring(i,"supp_code")
	llLineItemNo = w_do.idw_pack.GetITemNumber(i,'line_item_no')
	
	If ls_SKU <> lsSKUHold Then
		
		select description, weight_1, hazard_text_cd
		into :ls_description, :ld_weight, :lshazCode
		from item_master 
		where project_id = :ls_project_id and sku = :ls_sku and supp_code = :ls_supplier ;
		
	End If /*Sku Changed*/
	
	lsSkuHold = ls_SKU

	ls_description = trim(ls_description)
	

	//Set all Items on the Report by grabbing info from tab pages
	w_do.idw_packprint.setitem(j,"carton_no",w_do.idw_pack.getitemString(i,"carton_no")) /*Printed report should show carton # from screen instead of row #*/
	w_do.idw_packprint.setitem(j,"bol_no",w_do.is_bolno)
	w_do.idw_packprint.setitem(j,"ord_no",w_do.idw_main.getitemstring(1,"cust_order_no"))
	w_do.idw_packprint.setitem(j,"freight_terms",w_do.idw_other.getitemstring(1,"freight_terms"))	
	w_do.idw_packprint.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code")) /* 5/3/00 PCONKL*/
	w_do.idw_packprint.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
	w_do.idw_packprint.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
	w_do.idw_packprint.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
	w_do.idw_packprint.setitem(j,"complete_date",w_do.idw_main.getitemdatetime(1,"complete_date"))
	w_do.idw_packprint.setitem(j,"sku",ls_sku)
	//w_do.idw_packprint.setitem(j,"alt_sku",ls_alt_sku)  //08/09/00 DGM
	w_do.idw_packprint.setitem(j,"description",ls_description)
	w_do.idw_packprint.setitem(j,"unit_weight",w_do.idw_pack.getitemDecimal(i,"weight_net")) /*take from displayed pask list instead of DB*/
	w_do.idw_packprint.setitem(j,"standard_of_measure",w_do.idw_pack.getitemString(i,"standard_of_measure"))
	w_do.idw_packprint.setitem(j,"carrier",w_do.idw_other.getitemString(1,"carrier"))
	w_do.idw_packprint.setitem(j,"ship_via",w_do.idw_other.getitemString(1,"ship_via")) /* 5/3/00 PCONKL */
	w_do.idw_packprint.setitem(j,"sch_cd",w_do.idw_other.getitemString(1,"user_field1")) /* 5/3/00 PCONKL */
	w_do.idw_packprint.setitem(j,"packlist_notes",w_do.idw_main.getitemString(1,"packlist_notes")) /* 09/01 PCONKL */
	w_do.idw_packprint.setitem(j,"project_id",gs_project) /* 12/01 PCONKL */
	w_do.idw_packprint.setitem(j,"HazText",lshazText) /* 02/02 PCONKL */
	//For English to Metrtics changes added L or K based on E or M
	ls_etom=w_do.idw_packprint.getitemString(j,"standard_of_measure")
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
	
	// 5/4/00 PCONKL - find matching row in detail to get ordered quantity and CNTL Number
	
	// 09/01 - PCONKL - we may have multiple pack rows that match to a single detail row. THis will cause the Order qty
	//                  to be wrong if we simply copy it for each row (it will be multiplied by each additional row). 
	//						  If the ordered qty on the order detail = the shipped qty, we will just set the ord qty = shipped qty
	//						  If Ord Qty > shipped qty, we will set the difference on the last row for the sku, the rest will be equal
	//						This assumes that the Shipped QTY on Packing List = Alloc QTY on DEtail. This will be validated before allowing to print (wf_val)
	
	lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLineItemNo)
	llRow = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
	
	if llRow > 0 Then
		w_do.idw_packprint.setitem(j,"cntl_number",w_do.idw_detail.getitemString(llRow,"user_field1")) /* Cntrl num // detail Weight for Sears*/
		w_do.idw_packprint.setitem(j,"user_field2",w_do.idw_detail.getitemString(llRow,"user_field2")) /* 12/01 for Saltillo*/
		w_do.idw_packprint.setitem(j,"alt_sku",w_do.idw_detail.getitemString(llRow,"alternate_sku"))
	
		If w_do.idw_detail.getitemnumber(llRow,"req_qty") = w_do.idw_detail.getitemnumber(llRow,"alloc_qty") Then
			w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_pack.getitemNumber(i,"quantity"))
		Else /*ord qty <> Alloc, if it's the last carton row for this sku, show the difference here, otherwise set to alloc*/
			If (i = ll_cnt) or (w_do.idw_pack.Find(lsFind,(i + 1),(ll_cnt + 1)) = 0) Then /*last row for the sku*/
				//set order qty = shipped qty for row + (order - alloc) from detail. This assumes that the Shipped QTY on Packing List = Alloc QTY on DEtail. This will be validated before allowing to print (wf_val)
				w_do.idw_packprint.setitem(j,"ord_qty",(w_do.idw_pack.getitemNumber(i,"quantity") + (w_do.idw_detail.getitemnumber(llRow,"req_qty") - w_do.idw_detail.getitemnumber(llRow,"alloc_qty"))))
			Else /* not last row for sku*/
				w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_pack.getitemNumber(i,"quantity"))
			End If
		End If
		
	Else /*row not found (should never happen), set req qty to 0*/
		w_do.idw_packprint.setitem(j,"cntl_number",'')
	End If
	
	w_do.idw_packprint.setitem(j,"picked_quantity",w_do.idw_pack.getitemNumber(i,"quantity")) /* 5/4/00 - PCONKL*/
	w_do.idw_packprint.setitem(j,"volume",w_do.idw_pack.getitemDecimal(i,"cbm")) /* 02/01 - PCONKL*/
	If w_do.idw_pack.getitemDecimal(i,"cbm") > 0 Then
		w_do.idw_packprint.setitem(j,'dimensions',string(w_do.idw_pack.getitemDecimal(i,"length")) + ' x ' + string(w_do.idw_pack.getitemDecimal(i,"width")) + ' x ' + string(w_do.idw_pack.getitemDecimal(i,"height"))) /* 02/01 - PCONKL*/
	End If
	w_do.idw_packprint.setitem(j,"country_of_origin",w_do.idw_pack.getitemstring(i,"country_of_origin")) /* 10/00 - PCONKL*/
	w_do.idw_packprint.setitem(j,"supp_code",w_do.idw_pack.getitemstring(i,"supp_code")) /* 10/00 - PCONKL*/
	w_do.idw_packprint.setitem(j,"serial_no",w_do.idw_pack.getitemstring(i,"free_form_serial_no")) /* 02/01 - PCONKL*/
	w_do.idw_packprint.setitem(j,"component_ind",w_do.idw_pack.getitemstring(i,"component_ind")) /* 02/01 - PCONKL - sort component master to top*/
		
	w_do.idw_packprint.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
	w_do.idw_packprint.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
	w_do.idw_packprint.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
	w_do.idw_packprint.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
	w_do.idw_packprint.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
	w_do.idw_packprint.setitem(j,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
	w_do.idw_packprint.setitem(j,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
	w_do.idw_packprint.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
	
	// 07/00 PCONKL - Ship from info is coming from Project Table  
		/*Gap 5/2003 "SEARS uses Warehouse info"*/
	w_do.idw_packprint.setitem(j,"ship_from_name",lsName)
	w_do.idw_packprint.setitem(j,"ship_from_address1",lsaddr1)
	w_do.idw_packprint.setitem(j,"ship_from_address2",lsaddr2)
	w_do.idw_packprint.setitem(j,"ship_from_address3",lsaddr3)
	w_do.idw_packprint.setitem(j,"ship_from_address4",lsaddr4)
	w_do.idw_packprint.setitem(j,"ship_from_city",lsCity)
	w_do.idw_packprint.setitem(j,"ship_from_state",lsstate)
	w_do.idw_packprint.setitem(j,"ship_from_zip",lszip)
	w_do.idw_packprint.setitem(j,"ship_from_country",lscountry)
	
	//07/03 - PCONKL - Adding Supplier Name to Sears Packing LIst
	Select Supp_name into :lsSupplierName
	From Supplier
	Where PRoject_id = :gs_project and supp_code = :ls_Supplier;
		
	w_do.idw_packprint.setitem(j,"supplier_Name",lsSupplierName)
			
Next

i=1
FOR i = 1 TO UpperBound(ls_text[])
	w_do.idw_packprint.Modify(ls_text[i])
	ls_text[i]=""
NEXT


//Send the report to the Print report window
w_do.idw_packprint.Sort()
w_do.idw_packprint.GroupCalc()

OpenWithParm(w_dw_print_options,w_do.idw_packprint) 

If message.doubleparm = 1 then
	If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
		w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
		w_do.idw_main.SetItem(1,"ord_status","I")
		w_do.ib_changed = TRUE
		w_do.iw_window.trigger event ue_save()
	End If
End If

end function

public function integer uf_packing_print_3com ();

string ls_name,ls_address1,ls_address2,ls_address3,ls_address4,ls_city,ls_state,ls_zip,lscountry, lsCityStateZip, &
		ls_carrier, ls_carrier_code, lsCartonNo, lsSKU, lsSuppCode, lsDoNo, lsSerialNo, lsNotes, lsPrinter, lsCopies,	&
		lsFind, lsParentSKU, lsDesc, lsCOO, lsHTS_Nash, lsHTS_ERSL, lsHTS_SIN, lsHTS_HKG, lsWarehouse, lsSerialSku, lsSoldTo, lsGroup
		
Long	llRowPos, llLineItemNo, llSerialCount, llRowCount, llSerialPos, llHeight, llNOteCount, llCopies, llRC,	&
		llFindRow, llNewRow, llQty
		
Boolean	lbHighEncrypt, lbNoPrompt, lbMissingBoxes

string lsPrevCarton, lsNewCarton, lsPallets, lsBoxCount, lsComma, lsWarehouseCounty
integer liPallets, liBoxes

datastore ld_packprint, ldsSerial, ldsNotes, ld_enrypt_print, ld_warranty_page, ld_discount_page, ld_contract

// pvh 03.07.06 - eq Notes
long index
long rows
string lEQNotes
datastore ldsEQNotes
ldsEQNotes = f_datastoreFactory('d_3com_packing_eq_notes')


lsDoNo = w_do.idw_main.GetItemString(1,'do_no')

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//The Pack List may not be showing components, make sure children aren't filtered out
w_do.wf_set_Pack_filter("REMOVE")

//No row means no Print
llRowCount = w_do.idw_pack.rowcount()
If llRowCount = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

SetPointer(Hourglass!)

ld_packprint = Create Datastore

// 01/08 - PCONKL - If tipping Point Order, we need custom PL
If w_do.idw_main.GetITemString(1,'ord_type') = 'P' /*Tipping Point */ Then
	ld_packprint.dataobject ='d_3com_tp_packing_d_prt'
Else
	ld_packprint.dataobject ='d_3com_packing_d_prt'
End If

ld_packprint.settransobject(sqlca)

//Carton Serial Numbers
ldsSerial = Create Datastore
ldsSerial.Dataobject = 'd_do_carton_serial' /* 01/05 - PConkl - Retrieve for all suppliers but by COO */
ldsSerial.SetTransobject(sqlca)

llRowCount=ld_packprint.retrieve(lsDONO)

//If printing from doc print window, we may set the number of copies
If g.ilPrintCopies > 0 Then /* print ship docs window may set number of copies*/
	llCopies = g.ilPrintCopies
Else
	llCopies = 1
End If

//Delivery Notes - add first 5 to beginning of special instructions
ldsNotes = Create Datastore
ldsNotes.Dataobject = 'd_delivery_Notes'
ldsNotes.SetTransObject(SQLCA)

llNoteCount = ldsNotes.Retrieve(gs_project, lsDONO, 'DI')
lsNotes = ''
For llRowPos = 1 to llNoteCount
	lsNotes += ldsNotes.GetItemString(llRowPOs,'note_text')
	//we have room for 5 lines of notes. If more than 5 rows coming from DB, concatonate to use available space, otherwise keep in same format as DB
	If llNoteCount > 5 Then
		lsNotes += ' '
	Else
		lsNotes += '~r'
	End If
Next

//double quotes will cause the settext to fail - replace with single quotes
Do While Pos(lsNotes,'"') > 0
	lsNotes = Replace(lsNotes,Pos(lsNotes,'"'),1,"'")
Loop

ld_packprint.object.Instructions_t.text= lsNotes

// 04/04 - PCONKL - If any Highly encrypted items (UF1), we will print placeholder below
If ld_packprint.Find("Upper(im_user_field1) = 'H'",1,ld_packPrint.RowCOunt()) > 0 Then
	lbHighEncrypt = True
End IF

// Bill To Address
select name,address_1,address_2,address_3,address_4,city,state,zip,country 
into :ls_name,:ls_address1,:ls_address2,:ls_address3,:ls_ADdress4,:ls_city,:ls_state,:ls_zip,:lscountry 
from delivery_alt_address 
where project_id=:gs_project and address_type='BT' and do_no = :lsDONO
Using Sqlca;

//Quotes in address_4 will crash.  Replacing them with apostrophes in uf_ReplaceQuotes.
ld_packprint.object.t_name.text= ls_name
//ld_packprint.object.t_address_1.text=ls_address1
ld_packprint.object.t_address_1.text=uf_ReplaceQuotes(ls_address1)
ld_packprint.object.t_address_2.text=uf_ReplaceQuotes(ls_address2)
ld_packprint.object.t_address_3.text=uf_ReplaceQuotes(ls_address3)
ld_packprint.object.t_address_4.text=uf_ReplaceQuotes(ls_address4)

// format city, state and zip into 1 row
lsCityStateZip = ''
If Not isnull(ls_city) and ls_city > '' Then lsCityStateZip = ls_City + ', '
If NOt isNull(ls_state) Then lsCityStateZip += ls_state + ' '
If NOt isNull(ls_zip) Then lsCityStateZip += ls_zip

ld_packprint.object.t_city.text=lsCityStateZip

// apparently we can't set an object text to "NO" - Bombs when country is Norway!
If lsCountry = "NO" Then
	ld_packPrint.object.country_t.text="NOR"
Else
	ld_packPrint.object.country_t.text=lsCountry
End If

// 07/04 - PCONKL - Add Intermediary Address
ls_name = ''
ls_address1 = ''
ls_address2 = ''
ls_address3 = ''
ls_address4 = ''
ls_city = ''
ls_state = ''
ls_zip = ''
lsCountry = ''

select name,address_1,address_2,address_3,address_4,city,state,zip,country 
into :ls_name,:ls_address1,:ls_address2,:ls_address3,:ls_ADdress4,:ls_city,:ls_state,:ls_zip,:lscountry 
from delivery_alt_address 
where project_id=:gs_project and address_type='IT' and do_no = :lsDONO
Using Sqlca;

ld_packprint.object.it_name.text= ls_name
ld_packprint.object.it_address_1.text=ls_address1
ld_packprint.object.it_address_2.text=ls_address2
ld_packprint.object.it_address_3.text=ls_address3
ld_packprint.object.it_address_4.text=ls_address4

// format city, state and zip into 1 row
lsCityStateZip = ''
If Not isnull(ls_city) and ls_city > '' Then lsCityStateZip = ls_City + ', '
If NOt isNull(ls_state) Then lsCityStateZip += ls_state + ' '
If NOt isNull(ls_zip) Then lsCityStateZip += ls_zip

ld_packprint.object.it_city.text=lsCityStateZip

// apparently we can't set an object text to "NO" - Bombs when country is Norway!
If lsCountry = "NO" Then
	ld_packPrint.object.it_country.text="NOR"
Else
	ld_packPrint.object.it_country.text=lsCountry
End If

//gap 9/29/03 get Carrier Name from Carrier table
ls_carrier_code = w_do.idw_main.GetItemString(1,"carrier")         
SELECT carrier_name
into :ls_carrier
FROM carrier_master
WHERE 	( carrier_master.project_id = :gs_project )    AND  
     		( carrier_master.carrier_code = :ls_carrier_code )
Using Sqlca;
//ll_return = SQLCA.sqlcode
	if SQLCA.sqlcode <> 0 then ls_carrier = ls_carrier_code
ld_packprint.setitem( 1,"carrier_master_carrier_name", string(ls_carrier)) 
//end gap 9/29/03

// 01/05 - PCONKL - Adding support for Bundled Items
//							We want to include all children where the parent group = 'B' (Bundled)
//							these rows have been included on the Packing Tab but are not rerieved in this report due to inner join to
//							Delivery_detail. Manually insert any Packing rows that have not been found on the Pack List.


//8/2008 - Change shipping point to grab from warehouse.

lsWarehouse = w_do.idw_main.GetItemString(1,'wh_Code')

SELECT Country INTO :lsWarehouseCounty
	FROM Warehouse
	WHERE WH_Code = :lsWarehouse  USING SQLCA;


ld_packprint.Modify("t_shipping_point.text = '"+lsWarehouseCounty+"'")


llRowCount = w_do.idw_pack.rowcount()
For llRowPos = 1 to llRowCount
					
	lsFind = "Upper(delivery_Packing_Carton_no) = '" + Upper(w_do.idw_pack.GetItemString(llRowPos,'Carton_No')) + "'"
	lsFind += " and delivery_Packing_Line_Item_no = " + String(w_do.idw_pack.getITemNumber(llRowPos,'Line_Item_No')) 
	lsFind += " and Upper(delivery_Packing_SKU) = '" + Upper(w_do.idw_pack.GetItemString(llRowPos,'SKU')) + "'"
//	lsFind += " and Upper(Supp_code) = '" + Upper(w_do.idw_pack.GetItemString(llRowPos,'Supp_Code')) + "'"
	lsFind += " and Upper(Delivery_Packing_Country_Of_Origin) = '" + Upper(w_do.idw_pack.GetItemString(llRowPos,'Country_of_Origin')) + "'"
	
	llFindRow = ld_PackPrint.Find(lsFind,1,ld_packPrint.RowCount())
	
	//If it's found, we need to determine whether this is a bundled parent or not - It may also be a child that we need to add new qty to existing amount
	If llFindRow > 0 Then
		
		If ld_packPrint.GetItemString(llFindRow,'c_bundled_Ind') = 'C' Then /*existing Child, Add to total*/
		
			ld_packPrint.SetITem(llFindRow,'delivery_Packing_Quantity',ld_packPrint.GetITemNumber(llFindRow,'delivery_Packing_Quantity') + w_do.idw_pack.getITemNumber(llRowPos,'Quantity'))
		
		Else /* Parent - bundled or Not? */
		
			If ld_packPrint.GetItemString(llFindRow,'grp') = 'B' Then
			
				ld_packPrint.SetItem(llFindrow,'c_bundled_ind','P')
				
			Else
			
				ld_packPrint.SetItem(llFindrow,'c_bundled_ind','N')
			
			End If
			
		End IF
		
	Else /* a child, add a new pack row */
		
		lsSKU = w_do.idw_pack.GetItemString(llRowPos,'SKU')
	//	lsParentSKU = w_do.idw_pack.GetItemString(llRowPos,'SKU')
		lsSuppCode = w_do.idw_pack.GetItemString(llRowPos,'Supp_Code')
		lsDONO = w_do.idw_pack.GetItemString(llRowPos,'do_no')
		lsCartonno = w_do.idw_pack.GetItemString(llRowPos,'carton_No')
		lsCoo = w_do.idw_pack.GetItemString(llRowPos,'Country_of_Origin')
		lsWarehouse = w_do.idw_main.GetItemString(1,'wh_Code')
		llLineItemNo = w_do.idw_pack.getITemNumber(llRowPos,'Line_item_no')
		
		//We need the PArent SKU and grp from the Pick List
		lsFind = "Line_Item_No = " + String(w_do.idw_pack.getITemNumber(llRowPos,'Line_Item_No'))
		lsFind += " and Upper(SKU) = '" +  Upper(w_do.idw_pack.GetItemString(llRowPos,'SKU')) + "'"
		lsFind += " and Upper(Supp_code) = '" + Upper(w_do.idw_pack.GetItemString(llRowPos,'Supp_Code')) + "'"
		llFindRow = w_do.idw_Pick.Find(lsFind,1,w_do.idw_Pick.RowCOunt())
		If llFindRow > 0 Then
			lsParentSKU = w_do.idw_Pick.GetItemString(llFindRow,'sku_parent')
			lsGroup = w_do.idw_Pick.GetItemString(llFindRow,'grp')
		else
			lsParentSKU = lsSKU
			lsGroup = ''
		End If
		
		llNewRow = ld_PackPrint.InsertRow(0)
		ld_packPrint.SetItem(llNewRow,'c_bundled_ind','C')
		ld_packPrint.SetItem(llNewRow,'delivery_Master_do_no',lsDONO)
		ld_packPrint.SetItem(llNewRow,'delivery_Packing_Line_Item_no',llLineItemNo)
		ld_packPrint.SetItem(llNewRow,'delivery_Packing_Quantity',w_do.idw_pack.getITemNumber(llRowPos,'Quantity'))
		ld_packPrint.SetItem(llNewRow,'delivery_Packing_SKU',lsSKU)
		ld_packPrint.SetItem(llNewRow,'c_parent_sku',lsParentSKU) /*need to sort parent first before children*/
		//ld_packPrint.SetItem(llNewRow,'Supp_code',lsSuppCode)
		ld_packPrint.SetItem(llNewRow,'delivery_Packing_Carton_no',lsCartonno)
		ld_packPrint.SetItem(llNewRow,'delivery_Packing_Country_Of_Origin',lsCOO)
		ld_packPrint.SetItem(llNewRow,'grp',lsGroup)
		ld_packPrint.SetItem(llNewRow,'delivery_Packing_standard_of_measure',w_do.idw_pack.GetItemString(llRowPos,'standard_of_measure'))
		
		//Sales Order (UF4) and Cust PO (UF5) need to come from Detail
		lsFind = "Line_Item_No = " + String(w_do.idw_pack.getITemNumber(llRowPos,'Line_Item_No'))
		llFindRow = w_do.idw_Detail.Find(lsFind,1,w_do.idw_detail.RowCOunt())
		If llFindRow > 0 Then
			ld_packPrint.SetItem(llNewRow,'dd_user_field4',w_do.idw_detail.GetItemString(llFindRow,'user_field4'))
			ld_packPrint.SetItem(llNewRow,'dd_user_field5',w_do.idw_detail.GetItemString(llFindRow,'user_field5'))
		Else
			ld_packPrint.SetItem(llNewRow,'dd_user_field4',w_do.idw_Main.GetItemString(1,'User_field4'))
			ld_packPrint.SetItem(llNewRow,'dd_user_field5',w_do.idw_Main.GetItemString(1,'cust_order_no'))
		End If
				
		// We need the Item Description and HTS Codes (stored in UF's per warehouse)
		lsHTS_NASH = ''
		lsHTS_SIN = ''
		lsHTS_ERSL = ''
		lsHTS_HKG = ''
		
		Select Description, USer_field7, User_Field8, User_Field10, User_Field11
		into 	:lsDesc, :lsHTS_NASH, :lsHTS_ERSL, :lsHTS_SIN, :lsHTS_HKG
		From Item_Master
		Where Project_id = :gs_project and sku = :lsSKU and Supp_Code = :lsSuppCode;
		
		ld_packPrint.SetItem(llNewRow,'item_master_description',lsDesc)
		
		//Set HTS Code based on Warehouse
		Choose Case Upper(lsWarehouse)
			Case 'NASHVILLE'
				ld_packPrint.SetItem(llNewRow,'delivery_detail_user_field1',lsHTS_NASH)
			Case '3COM-SIN'
				ld_packPrint.SetItem(llNewRow,'delivery_detail_user_field1',lsHTS_SIN)
			Case '3COM-NL'
				ld_packPrint.SetItem(llNewRow,'delivery_detail_user_field1',lsHTS_ERSL)
		End Choose
		
		//We need the shipped qty for this line/sku/supplier/coo
		Select Sum(Quantity) Into :llQty
		From Delivery_PAcking
		Where do_no = :lsDoNo and line_item_no = :llLineITemNo and Sku = :lsSKU and supp_Code = :lsSuppCode and 
							carton_no = :lsCartonNo and Country_Of_Origin = :lsCOO;
		
		ld_packPrint.SetItem(llNewRow,'delivery_detail_alloc_qty',llQTY)
		
	End IF
	
	//dts 05/05/05 adding Pallet box count info to Pack List
	//is datastore in Carton order? (and same order as Shipping Label!?!?)
	//print weight by pallet as well?
	//messagebox("Temp!", "Weight: " + string(ld_packPrint.GetItemNumber(llRowPos,'delivery_Packing_weight_gross')))
	lsNewCarton = w_do.idw_pack.GetItemString(llRowPos,'Carton_no')
	lsBoxCount = w_do.idw_pack.GetItemString(llRowPos,'User_Field1')
	if upper(w_do.idw_pack.GetItemString(llRowPos,'Carton_type')) = 'PALLET' then
		if lsNewCarton <> lsPrevCarton then
			if isnumber(lsBoxCount) then
				liBoxes += integer(lsBoxCount)
				liPallets += 1
				//lsPallets += 'Pallet ' + string(liPalletNum) + ' contains ' + ld_packPrint.GetItemString(llRowPos,'BoxCount') + ' boxes. '
				//lsPallets += 'Pallet ' + string(liPalletNum) + ': ' + ld_packPrint.GetItemString(llRowPos,'BoxCount') + ' boxes. '
				if liPallets > 1 then lsComma = ', '
				if integer(lsBoxCount) = 1 then
					lsPallets += lsComma + string(liPallets) + ': ' + lsBoxCount + ' box'
				else
					lsPallets += lsComma + string(liPallets) + ': ' + lsBoxCount + ' boxes'
				end if
			else
				lbMissingBoxes = true
			end if
		end if
	end if
	lsPrevCarton = lsNewCarton

Next /* W_DO Packing Row*/

//pallet info for packing list...
if lbMissingBoxes = true then
	if messagebox("Missing Boxes", "Pallet Box count is missing for one or more pallets. Print anyway?", Question!, YesNo!) = 2 then
		return 0
	end if
end if
if liBoxes > 0 then
	if liPallets = 1 then
		if liBoxes = 1 then
			lsPallets = '1 Pallet; 1 box.'
		else
			lsPallets = '1 Pallet; ' + string(liBoxes) + ' boxes.'
		end if
	else
		lsPallets = string(liPallets) + ' Pallets; ' + lsPallets + '.'
	end if
	//messagebox ("TEMP!", lsPallets)
	ld_packprint.object.t_BoxCount.text = lsPallets
end if

// 10/03 - PCONKL - Need to retrieve and format Serial NUmbers from Delivery_Serial Table

ld_packprint.Sort()
ld_packprint.GroupCalc()
llRowCount = ld_packprint.rowcount()
For llRowPos = 1 to llRowCount
	
	lsDONO = ld_packprint.GetItemString(llRowPos,'delivery_Master_do_no')
	lsCartonno = ld_packprint.GetItemString(llRowPos,'delivery_Packing_Carton_no')
	lsSKU = ld_packprint.GetItemString(llRowPos,'delivery_Packing_SKU')
//	lsSuppCode = ld_packprint.GetItemString(llRowPos,'Supp_code')
	lsCOO = ld_packprint.GetItemString(llRowPos,'delivery_Packing_Country_Of_Origin')
	llLineItemNo = ld_packprint.GetItemNumber(llRowPos,'delivery_Packing_Line_Item_no')
	
	// pvh - 03.07.06 EQ notes
	rows = ldsEQNotes.retrieve( gs_project, lsDONO, llLineItemNo )
	lEQNotes = ''
	for index = 1 to rows
		lEQNotes +=   ldsEQNotes.object.note_text[ index ] + ", "
	next
	if NOT IsNull( lEQNotes ) or len( lEQNotes ) > 0 then
		lEQNotes = left( lEQNotes, (len( lEQNotes ) -2 )) // remove trailing formatting
		ld_packprint.object.eqNotes[ llRowPos ] = lEQNotes
	end if
	// eom
	
	lsSerialNo = ''
	
	//Serial Numbers are being retrieved from Delivey_Serial_Detail// 01/05 - PCONKL - Changed to include all supplier but retrieve by COO
	//llSerialCount = ldsSerial.Retrieve(lsdono, lsCartonNo, lsSKU, lsSuppCode, llLineItemNo)
	llSerialCount = ldsSerial.Retrieve(lsdono, lsCartonNo, lsSKU, lsCOO, llLineItemNo)
		
	For llSerialPos = 1 to llSerialCount
		lsSerialNo += ', ' + ldsSerial.GetItemString(llSerialPos,'serial_no')
	Next
	
	//If this is a non bundled parent, only the parent is printed on the PAck List but we need to include serial numbers for the children
	If ld_packprint.GetItemString(llRowPos,'c_bundled_ind') = 'N' Then
		
		lsFind = "Line_Item_No = " + String(llLineItemNO) + " and (component_ind = 'W' or Component_ind = '*')"
		llFindRow = w_do.idw_Pick.Find(lsFind,1,w_do.idw_Pick.RowCOunt())
		lsSerialSKu = ''
		
		Do While llFindRow > 0 /* each child of the current parent*/
							
			lsSKU = w_do.idw_Pick.GetItemString(llFindRow,'SKU')
			lsCOO = w_do.idw_Pick.GetItemString(llFindRow,'Country_of_Origin')
			
			// If a child sku/Coo is present more than once (picked from multiple locations, etc), only process serial numbers once
			If Pos(lsSerialSKU,Upper(lsSKU) + '/' + Upper(lsCOO)) = 0 Then
				
				lsSerialSKU += Upper(lsSKU) + '/' + Upper(lsCOO)
				
				llSerialCount = ldsSerial.Retrieve(lsdono, lsCartonNo, lsSKU, lsCOO, llLineItemNo)
		
				For llSerialPos = 1 to llSerialCount
					lsSerialNo += ', ' + ldsSerial.GetItemString(llSerialPos,'serial_no')
				Next
				
			End If
			
			llFindRow ++
			If llFindRow > w_do.idw_Pick.RowCOunt() Then
				llFindRow = 0
			Else
				llFindRow = w_do.idw_Pick.Find(lsFind,llFindRow,w_do.idw_Pick.RowCOunt())
			End If
			
		Loop
		
	End If
	
	lsSerialNo = Mid(lsSerialNo,3,9999999)
	
	//parse out into 250 char placeholders on PL
	ld_packprint.SetItem(llRowPos,'c_serial_1',Mid(lsSerialNo,1,250))
	ld_packprint.SetItem(llRowPos,'c_serial_2',Mid(lsSerialNo,251,250))
	ld_packprint.SetItem(llRowPos,'c_serial_3',Mid(lsSerialNo,501,250))
	ld_packprint.SetItem(llRowPos,'c_serial_4',Mid(lsSerialNo,751,250))
	ld_packprint.SetItem(llRowPos,'c_serial_5',Mid(lsSerialNo,1001,250))
	ld_packprint.SetItem(llRowPos,'c_serial_6',Mid(lsSerialNo,1251,250))
	ld_packprint.SetItem(llRowPos,'c_serial_7',Mid(lsSerialNo,1501,250))
	ld_packprint.SetItem(llRowPos,'c_serial_8',Mid(lsSerialNo,1751,250))
	ld_packprint.SetItem(llRowPos,'c_serial_9',Mid(lsSerialNo,2001,250))
	ld_packprint.SetItem(llRowPos,'c_serial_10',Mid(lsSerialNo,2251,250))
	ld_packprint.SetItem(llRowPos,'c_serial_11',Mid(lsSerialNo,2501,250))
	ld_packprint.SetItem(llRowPos,'c_serial_12',Mid(lsSerialNo,2751,250))
	ld_packprint.SetItem(llRowPos,'c_serial_13',Mid(lsSerialNo,3001,250))
		
Next /* Packing Row */

llRC = 0

// 04/04 - PCONKL - If any Highly encrypted product Item Master UF1), print placeholder page
IF lbHighEncrypt Then
	ld_enrypt_print = Create Datastore
	ld_enrypt_print.dataobject = 'd_3com_packing_encrypt_Notice'
	ld_enrypt_print.Modify("order_number_t.Text = '" + w_do.idw_main.GetItemString(1,"invoice_no") + "'")
	ld_enrypt_print.Modify("delivery_note_t.Text = '" + w_do.idw_main.GetItemString(1,"User_Field6") + "'")
	
	If g.ibNoPromptPrint Then
		ld_enrypt_print.Object.DataWindow.Print.Copies = llCOpies
		ld_enrypt_print.Print()
	Else
		OpenWithParm(w_dw_print_options,ld_enrypt_print) 
		llRC = Message.DoubleParm /* -1 if cancelled - don't print below*/
		lbNoPrompt = True /* we won't need to reprompt for other 2 packlists - use paramters set here*/
		llCOpies = Long(ld_enrypt_print.Object.DataWindow.Print.Copies)
	End If
	
End If

// 09/04 - PCONKL - We may want to print without prompting (if coming from Print Shipment Docs, etc. or prompted above)
If llRC < 0 Then /*cancelled in dialog box above*/
Else
	If g.ibNoPromptPrint or lbNoPrompt Then
		ld_packPrint.Object.DataWindow.Print.Copies = llCOpies
		Print(ld_packPrint)
	Else
		OpenWithParm(w_dw_print_options,ld_packprint) 
		llRC = Message.DoubleParm /* -1 if cancelled - don't print below*/
		llCOpies = Long(ld_packPrint.Object.DataWindow.Print.Copies)
	End If
End If

//second page of pack list - no need to prompt with dialog box (removed 09/04)
If llRC < 0 Then /*cancelled in dialog box above*/
Else
	
	// 05/05 - PCONKL - For Tipping Point software items, we need to include cstomer sold to code and the serial number
	//						  Passed as parameters to summary report
	
	lsSoldTo = ''
	lsSerialNo = ''
	
	//Check for Bundled Parent and Tipping Point Child
	If ld_packprint.Find("Upper(grp) = 'B'",1,ld_packPrint.RowCount()) > 0 and ld_packprint.Find("Upper(grp) = 'TP'",1,ld_packPrint.RowCount()) > 0 Then
		
		llFindRow = ld_packprint.Find("Upper(grp) = 'TP'",1,ld_packPrint.RowCount())
		lsSKU = ld_packPrint.GetItemString(llFindRow,'delivery_packing_SKU')
		llLineItemNo = ld_PAckPrint.GetItemNumber(llFindROw,'delivery_packing_line_item_no')
		lsDONO = w_do.idw_main.GetItemString(1,'do_no')
		
		//Get the Serial Number
		Select Min(delivery_serial_detail.Serial_no) into :lsSerialNo
		From Delivery_Picking_Detail, Delivery_Serial_Detail
		Where Delivery_Picking_Detail.Id_NO = Delivery_serial_detail.Id_NO and
				Delivery_Picking_Detail.do_no = :lsDONO and
				Delivery_Picking_Detail.Line_Item_No = :llLineItemNo and
				Delivery_Picking_Detail.Sku = :lsSku;
				
		//Get the sold to - either from Alt_address table if present or Delivery master cust_Code if not
		Select Name into :lsSoldTo
		From Delivery_Alt_Address
		where project_id=:gs_project and address_type='ST' and do_no = :lsDONO;
		
		If isnull(lsSOldto) or lsSoldTo = '' Then
			lsSoldTo = w_do.idw_main.GetItemString(1,'Cust_Code')
		End If
		
	End If /*Bundled parent and Tipping point child */
	
//	ld_packprint.dataobject ='d_3com_packing_s_prt'
	// 01/08 - PCONKL - If tipping Point Order, we need custom PL
	If w_do.idw_main.GetITemString(1,'ord_type') = 'P' /*Tipping Point */ Then
		ld_packprint.dataobject ='d_3com_tp_packing_s_prt'
	Else
		ld_packprint.dataobject ='d_3com_packing_s_prt'
	End If

	ld_packprint.settransobject(sqlca)
	
	llRowCount=ld_packprint.retrieve(lsDONO, lsSoldTo, lsSerialNo) /* 05/05 - PCONKL - Sold to and Serial Number passed in for printing purposes only*/
	
	ld_packprint.setitem( 1,"carrier_master_carrier_name", string(ls_carrier)) 

	ld_packprint.Modify("t_shipping_point.text = '"+lsWarehouseCounty+"'")

	ld_packPrint.Object.DataWindow.Print.Copies = llCOpies
	Print(ld_packPrint)
	
End IF



//--------------
//Extra Page
//--------------


integer li_contract_count, li_warranty_count

//Will only have one or the other - contract count or warrenty_count

SELECT Count(*) INTO :li_contract_count 
		FROM delivery_detail
		WHERE do_no = :lsDONO AND (delivery_detail.User_Field6 = 'Z3' OR delivery_detail.User_Field6 = 'Z4') USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN
	
	MessageBox ("DB Error", SQLCA.SQLErrText )
	
END IF

IF li_contract_count = 0 THEN

	SELECT Count(*) INTO :li_warranty_count 
			FROM delivery_detail
			WHERE do_no = :lsDONO AND (delivery_detail.User_Field6 IS NOT NULL) AND (delivery_detail.User_Field6 <> 'Z3' AND delivery_detail.User_Field6 <> 'Z4') USING SQLCA;
	
	IF SQLCA.SQLCode <> 0 THEN
		
		MessageBox ("DB Error", SQLCA.SQLErrText )
		
	END IF
	
END IF




string ls_war_address[]
string ls_country
integer li_row
string ls_instr

// 10/09 - PCONKL - The extra pages should only be printing for Eersel

IF li_warranty_count > 0 and (w_do.idw_main.GetItemString(1,'wh_Code') = '3CGLSEMEA' or w_do.idw_main.GetItemString(1,'wh_Code') = '3COM-NL') THEN // PRINT EXTRA PAGE

	ld_warranty_page = CREATE datastore
	
	ld_warranty_page.dataobject = "d_3com_warranty_return_instructions"
	
	li_row = ld_warranty_page.InsertRow(0)
	
	
	SELECT delivery_master.country INTO :ls_country 
		FROM delivery_master
		WHERE do_no = :lsDONO  USING SQLCA;
	
	
	CHOOSE CASE Upper(Trim(ls_country))
	
	CASE 'ES' //Spain 

	
		ls_instr = "3C ship Spain.jpg"
	
//		ls_war_address[1] = "3Com C/O"
//		ls_war_address[2] = "VIVA XPRESS LOGISTICS SPAIN"
//		ls_war_address[3] = "Senda Galiana, C/A Nave 5"
//		ls_war_address[4] = "28820 Coslada Madrid"
//		ls_war_address[5] = "SPAIN"
//		ls_war_address[6] = ""
	 
	CASE 'CZ' //Czech Republic 

		ls_instr = "3C ship Czech.jpg"	
	
//		ls_war_address[1] ="3Com C/O"
//		ls_war_address[2] ="GO! Express & Logistics, s.r.o."
//		ls_war_address[3] ="U Prioru 1076/5"
//		ls_war_address[4] ="160 00 Praha 6"
//		ls_war_address[5] ="CZECH REPUBLIC"
//		ls_war_address[6] = ""
	
	
	CASE 'ZA' //South Africa 
		
		ls_instr = "3C ship SAfrica.jpg"
		
//		ls_war_address[1] ="3Com C/O"
//		ls_war_address[2] ="Globefight Worldwide Express (SA) PTY LTD"
//		ls_war_address[3] ="Unit 1,2, Loper Avenue, Spartan Ext2 Aeroport"
//		ls_war_address[4] ="Industrial Estate"
//		ls_war_address[5] ="Isando"
//		ls_war_address[6] ="South Africa"
//	
	
	CASE 'PL' //- Poland 
	
		ls_instr = "3C ship Poland.jpg"
	
	
//		ls_war_address[1] ="3Com C/O"
//		ls_war_address[2] ="GO! Express & Logistics Polska Sp. Z.o.o"
//		ls_war_address[3] ="Ul.17 Stycznia 45 b"
//		ls_war_address[4] ="02-146 Warszawa"
//		ls_war_address[5] ="POLAND"
//		ls_war_address[6] = ""
//	
	CASE 'GR' //- Greece

		ls_instr = "3C ship Greece.jpg"	
	
//		ls_war_address[1] ="3Com C/O  W.F.F LTD"
//		ls_war_address[2] ="World Freight Forwarders International Transports LTD"
//		ls_war_address[3] ="Vakhou 1-3"
//		ls_war_address[4] ="Vari 16672"
//		ls_war_address[5] ="Athens"
//		ls_war_address[6] = "Greece"
	
	
	CASE ELSE
	
		ls_instr = "3C ship Netherlands.jpg"	
	
//	
//		ls_war_address[1] ="3Com GLS Returns"
//		ls_war_address[2] ="c/o Menlo Worldwide Logistics B.V"
//		ls_war_address[3] ="Meerheide 29-35"
//		ls_war_address[4] ="Dock Doors 17/18"
//		ls_war_address[5] ="5521 DZ Eersel"
//		ls_war_address[6] ="The Netherlands"
	
	END CHOOSE
	
//	ld_warranty_page.SetItem( li_row, "address_line_1", ls_war_address[1])
//	ld_warranty_page.SetItem( li_row, "address_line_2", ls_war_address[2])
//	ld_warranty_page.SetItem( li_row, "address_line_3", ls_war_address[3])
//	ld_warranty_page.SetItem( li_row, "address_line_4", ls_war_address[4])
//	ld_warranty_page.SetItem( li_row, "address_line_5", ls_war_address[5])
//	ld_warranty_page.SetItem( li_row, "address_line_6", ls_war_address[6])
//	

	
	ld_warranty_page.Object.p_instr.Filename = ls_instr
	
	
	Print(ld_warranty_page)
	
	//w_do.ole_1.object.Print()
	//Discount
//	ld_discount_page = CREATE datastore;
//	ld_discount_page.dataobject = "d_3com_discount"
//	ld_discount_page.InsertRow(0)
//	Print(ld_discount_page)
	
END IF /* Eersel GLS*/

IF li_contract_count > 0 and (w_do.idw_main.GetItemString(1,'wh_Code') = '3CGLSEMEA' or w_do.idw_main.GetItemString(1,'wh_Code') = '3COM-NL')  THEN 


	ld_contract = CREATE datastore;
	
	ld_contract.dataobject = "d_3com_warranty_return_instructions"
	
	li_row = ld_contract.InsertRow(0)
	
	
	ls_instr = "3C ship Netherlands.jpg"	

	ld_contract.Object.p_instr.Filename = ls_instr
	
	Print(ld_contract)


//	
	//Contract
	

	ld_contract.dataobject = "d_3com_contract_instructions"
	li_row = ld_contract.InsertRow(0)
//	
//	ls_war_address[1] ="3Com GLS Returns"
//	ls_war_address[2] ="c/o Menlo Worldwide Logistics B.V"
//	ls_war_address[3] ="Meerheide 29-35"
//	ls_war_address[4] ="Dock Doors 17/18"
//	ls_war_address[5] ="5521 DZ Eersel"
//	ls_war_address[6] ="The Netherlands"
//
//	ld_contract.SetItem( li_row, "address_line_1", ls_war_address[1])
//	ld_contract.SetItem( li_row, "address_line_2", ls_war_address[2])
//	ld_contract.SetItem( li_row, "address_line_3", ls_war_address[3])
//	ld_contract.SetItem( li_row, "address_line_4", ls_war_address[4])
//	ld_contract.SetItem( li_row, "address_line_5", ls_war_address[5])
//	ld_contract.SetItem( li_row, "address_line_6", ls_war_address[6])
//	
//	Print(ld_contract)
//	
	//Customer Service Number
	ld_contract.dataobject = "d_3com_dhl_customer_service"
	
	Print(ld_contract)

END IF

SetPointer(Arrow!)

REturn 0
end function

public function integer uf_packingslip_gm ();string ls_customer, lsAltSKU
int li_rtn,li_rtn_h,li_rtn_d,li_rtn_e,li_rtn_dn
Long	i,j,k,l, llFindRow
int li_row, li_line_item_no,li_req_qty, liDetailLine
Decimal	ld_alloc_qty, ldPickQty
string ls_invoice_no,ls_user_field6,ls_user_field8,ls_user_field6_m,ls_user_field3,ls_user_field1,ls_user_field5,ls_user_field4
string ls_note_h,ls_note_d,ls_note_e,ls_sku, lsDONO, lsSchedCode, lsFind

datastore ld_packlist_gm,ld_pack_detail
datastore ld_delivery_notes,ld_note_detail
If w_do.ib_changed then
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

SetPointer(HourGlass!)

lsDONO = w_do.idw_main.GetITemString(1,'do_no')

select user_field7, User_Field1
into :ls_customer, :lsSchedCode 
from delivery_master
where project_id=:gs_project and do_no = :lsDONO

Using Sqlca;

ld_packlist_gm = create datastore
ld_pack_detail = create datastore

ld_delivery_notes = create datastore
ld_delivery_notes.dataobject = 'd_delivery_notes'
ld_delivery_notes.settransobject(sqlca)

ld_note_detail = create datastore
ld_note_detail.dataobject = 'd_note_detail'
ld_note_detail.settransobject(sqlca)

if ls_customer = 'ACD' then
	ld_packlist_gm.dataobject ='d_packinglist_acd'
else 
	ld_packlist_gm.dataobject ='d_packinglist_dealer'
end if

ld_packlist_gm.settransobject(sqlca)
  
li_rtn = ld_packlist_gm.retrieve(lsDONO)
	
//header level A0 Notes
li_rtn_h = ld_delivery_notes.retrieve(gs_project,lsDONO,'A0')
for j=1 to li_rtn_h 
	
	ls_note_h = ld_delivery_notes.getitemstring(j,"note_text")
	
	//Add Sched Code to A rec if present
	If Not isnull(lsSchedCode) and lsSchedCode > '' Then
		ls_Note_h += "  Schd CD: " + lsSChedCode
	End If
	
	li_row =ld_packlist_gm.rowcount()
	ld_packlist_gm.setitem(li_row,"note",ls_note_h)
	
	if j< li_rtn_h then
		ld_packlist_gm.insertrow(0)
   End if
	
next
	
//header level O0 Notes
li_rtn_h = ld_delivery_notes.retrieve(gs_project,lsDONO,'O0')
for j=1 to li_rtn_h 
	
	ld_packlist_gm.insertrow(0)
	
	ls_note_h = ld_delivery_notes.getitemstring(j,"note_text")
	li_row =ld_packlist_gm.rowcount()
	ld_packlist_gm.setitem(li_row,"note",ls_note_h)
	
next
		
ld_pack_detail.dataobject = 'd_pack_detail'
ld_pack_detail.settransobject(sqlca)
	
li_rtn_d =ld_pack_detail.retrieve(lsDONO)

for k = 1 to li_rtn_d /*Each Delivery Detail REcord */
		
		li_line_item_no = ld_pack_detail.getitemnumber(k,"delivery_detail_line_item_no")
		ls_sku = ld_pack_detail.getitemstring(k,"delivery_detail_sku")
		lsAltSKU = ld_pack_detail.getitemstring(k,"alternate_sku")
		li_req_qty = ld_pack_detail.getitemnumber(k,"delivery_detail_req_qty")
		ld_alloc_qty = ld_pack_detail.getitemnumber(k,"delivery_detail_alloc_qty")
		ls_invoice_no = ld_pack_detail.getitemstring(k,"delivery_master_invoice_no")
		ls_user_field4 = ld_pack_detail.getitemstring(k,"delivery_detail_user_field4")
		ls_user_field5 = ld_pack_detail.getitemstring(k,"delivery_detail_user_field5")
		ls_user_field6 = ld_pack_detail.getitemstring(k,"delivery_detail_user_field6")
		ls_user_field8 = ld_pack_detail.getitemstring(k,"delivery_detail_user_field8")
		ls_user_field6_m = ld_pack_detail.getitemstring(k,"delivery_master_user_field6")
		ls_user_field3 = ld_pack_detail.getitemstring(k,"delivery_detail_user_field3")
		ls_user_field1 = Left(ld_pack_detail.getitemstring(k,"delivery_detail_user_field1"),4) /* 04/04 - PCONKL - PEr GM, only left 4 of CNTL # */
		

		//Detail Level O0 Notes
		li_rtn_dn = ld_note_detail.retrieve(gs_project,lsDONO,li_line_item_no,"O0")
		
	   for l=1 to li_rtn_dn 
		  ls_note_d = ld_note_detail.getitemstring(l,"note_text")
		  li_row = ld_packlist_gm.insertrow(0)
			ld_packlist_gm.setitem(li_row,"note",ls_note_d)
	   next
		
		//Detail Level W0 Notes
		li_rtn_dn = ld_note_detail.retrieve(gs_project,lsDONO,li_line_item_no,"W0")
		
	   for l=1 to li_rtn_dn 
		  ls_note_d = ld_note_detail.getitemstring(l,"note_text")
		  li_row = ld_packlist_gm.insertrow(0)
			ld_packlist_gm.setitem(li_row,"note",ls_note_d)
	   next
				
	   li_row = ld_packlist_gm.insertrow(0) /*detail row*/
		liDetailLine = li_Row /* we may need to adjust the detail row below after the notes have been printed*/
		
		If ls_customer = 'ACD' then		
			
			ld_packlist_gm.setitem(li_row,"v66",ls_sku)
			ld_packlist_gm.setitem(li_row,"v84",li_line_item_no)
			ld_packlist_gm.setitem(li_row,"v68",li_req_qty)
     	 	ld_packlist_gm.setitem(li_row,"v181",ld_alloc_qty)	
			ld_packlist_gm.setitem(li_row,"v155",ls_user_field6_m)
			ld_packlist_gm.setitem(li_row,"v183",ls_user_field4)
			ld_packlist_gm.setitem(li_row,"v154",ls_user_field3)
			ld_packlist_gm.setitem(li_row,"v105",ls_user_field8)
			ld_packlist_gm.setitem(li_row,"v182",ls_user_field5)
			ld_packlist_gm.setitem(li_row,"v9",ls_invoice_no) //dts 3/16/05 - added to print barcoded Invoice_No
			
		else
			
	   	ld_packlist_gm.setitem(li_row,"v66",ls_sku)
			ld_packlist_gm.setitem(li_row,"v84",li_line_item_no)
			ld_packlist_gm.setitem(li_row,"v68",li_req_qty)
      	ld_packlist_gm.setitem(li_row,"v181",ld_alloc_qty)	
			ld_packlist_gm.setitem(li_row,"v155",ls_user_field6_m)
			ld_packlist_gm.setitem(li_row,"v154",ls_user_field3)
			ld_packlist_gm.setitem(li_row,"v105",ls_user_field8)
			ld_packlist_gm.setitem(li_row,"v9",ls_invoice_no)
			ld_packlist_gm.setitem(li_row,"v92",ls_user_field6)
			ld_packlist_gm.setitem(li_row,"v94",ls_user_field1)
			
   	end if
	
		// T0 level detail Notes
      li_rtn_dn = ld_note_detail.retrieve(gs_Project,lsDONO,li_line_item_no,"T0")
	   for l=1 to li_rtn_dn 
		  	ls_note_d = ld_note_detail.getitemstring(l,"note_text")
		  	li_row = ld_packlist_gm.insertrow(0)
			ld_packlist_gm.setitem(li_row,"note",ls_note_d)
	   next

		// 07/05 - PCONKL - If we are shipping an alternate SKU, we need to add the line item and a T0 note showing the replacement.
	
		//Compare what Detail shows as allocated to what was really picked. Detail alloc_qty will include Alternate SKU's picked
		ldPickQty = 0
		lsFind = "Line_Item_No = " + String(li_line_item_no) + " and Upper(sku) = '" + Upper(ls_sku) + "'"
		llFindRow = w_do.idw_pick.Find(lsFind,1,w_do.idw_pick.RowCount())
		Do While llFindRow > 0
			ldPickQty += w_do.idw_pick.getItemNumber(llFindrow,'Quantity')
			llFindRow ++
			If llFindRow > w_do.idw_pick.RowCount() Then
				llFindRow = 0
			Else
				llFindRow = w_do.idw_pick.Find(lsFind,llFindRow,w_do.idw_pick.RowCount())
			End If
		Loop
		
		//If summed pick qty is less than alloc qty on detail, we shipped a substitution and need to note it on the PL
		If ldPickQty < ld_alloc_qty and g.is_allow_alt_sku_Pick = 'Y' Then
			
			//If none picked for primary SKU, delete the row
			If ldPickQty = 0 Then
				ld_packlist_gm.DeleteRow(liDetailLine)
			Else
				ld_packlist_gm.setitem(liDetailLine,"v68",ldPickQty) /* req Qty for primary is same as Picked*/
				ld_packlist_gm.setitem(liDetailLine,"v181",ldPickQty)	/*set the alloc qty on the current detail row to the real picked qty*/
			End If
			
			//Insert a row for the alternate
			li_row = ld_packlist_gm.insertrow(0) /*detail row*/
			ld_packlist_gm.setitem(li_row,"v66",lsAltsku)
			ld_packlist_gm.setitem(li_row,"v84",li_line_item_no)
			ld_packlist_gm.setitem(li_row,"v68",li_req_qty - ldPickQty) /* req qty for Alt SKU is Total Req Qty - Primary SKU picked */
     	 	ld_packlist_gm.setitem(li_row,"v181",ld_alloc_qty - ldPickQty)	
			ld_packlist_gm.setitem(li_row,"v9",ls_invoice_no)
			
			//Insert a T0 Note to show replacement
			li_row = ld_packlist_gm.insertrow(0)
			ld_packlist_gm.setitem(li_row,"note","**** ORD ITEM NOTE:   " + String(li_line_item_no) + "  " + ls_sku + "   REPLACED BY " + lsAltSKU)
			
		End If
		
		// E0 level detail notes (maybe summary level instead)
		li_rtn_dn = ld_note_detail.retrieve(gs_Project,lsDONO,li_line_item_no,"E0")
	   for l=1 to li_rtn_dn 
		  	ls_note_d = ld_note_detail.getitemstring(l,"note_text")
		  	li_row = ld_packlist_gm.insertrow(0)
			ld_packlist_gm.setitem(li_row,"note",ls_note_d)
	   next

next /*Detail record */
	
OpenWithParm(w_dw_print_options,ld_packlist_gm) 

SetPointer(Arrow!)
	
DESTROY ld_packlist_gm
DESTROY ld_pack_detail
DESTROY ld_note_detail

Return 0

end function

public function integer uf_batch_pack_print_gm ();string ls_customer, lsFind, lsAltSKU
int li_rtn,li_rtn_h,li_rtn_d,li_rtn_e,li_rtn_dn,i,j,k,l
int li_row, liDetailLine
int li_line_item_no,li_req_qty
string ls_invoice_no,ls_user_field6,ls_user_field8,ls_user_field6_m,ls_user_field3,ls_user_field1,ls_user_field5,ls_user_field4
string ls_note_h,ls_note_d,ls_note_e,ls_sku, lsDONO, lsSchedCode, lsDONOHold, lsrc
Long	llRowPos, llRowCount, llCopies, llFindRow
decimal	ldPickQty, ld_alloc_Qty
datastore ld_packlist_gm,ld_pack_detail
datastore ld_delivery_notes,ld_note_detail

If w_batch_Pick.ib_changed then
	Messagebox(w_batch_Pick.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

SetPointer(HourGlass!)

ld_packlist_gm = create datastore
ld_pack_detail = create datastore

ld_delivery_notes = create datastore
ld_delivery_notes.dataobject = 'd_delivery_notes'
ld_delivery_notes.settransobject(sqlca)

ld_note_detail = create datastore
ld_note_detail.dataobject = 'd_note_detail'
ld_note_detail.settransobject(sqlca)

ld_pack_detail.dataobject = 'd_pack_detail'
ld_pack_detail.settransobject(sqlca)

//We want to print a pack list for Each Order - The detail tab may have multiple lines per order
llRowCount =  w_batch_Pick.idw_detail.RowCOunt()

For llRowPos = 1 to llRowCount /*each Order*/

	lsDONO = w_batch_Pick.idw_detail.GetItemString(llRowPos,'do_no')
	
	If lsDoNoHold = lsDoNo Then COntinue
	
	lsDONoHold = lsDONO

	select user_field7, User_Field1
	into :ls_customer, :lsSchedCode 
	from delivery_master
	where project_id=:gs_project and do_no = :lsDONO

	Using Sqlca;

	if ls_customer = 'ACD' then
		ld_packlist_gm.dataobject ='d_packinglist_acd'
	else 
		ld_packlist_gm.dataobject ='d_packinglist_dealer'
	end if
	
   ld_packlist_gm.settransobject(sqlca)
	li_rtn = ld_packlist_gm.retrieve(lsDONO)
	
	//header level A0 Notes
	li_rtn_h = ld_delivery_notes.retrieve(gs_project,lsDONO,'A0')
	for j=1 to li_rtn_h 
		
		ls_note_h = ld_delivery_notes.getitemstring(j,"note_text")
		
		//Add Sched Code to A rec if present
		If Not isnull(lsSchedCode) and lsSchedCode > '' Then
			ls_Note_h += "  Schd CD: " + lsSChedCode
		End If
		
		li_row =ld_packlist_gm.rowcount()
		ld_packlist_gm.setitem(li_row,"note",ls_note_h)
		if j< li_rtn_h then
			ld_packlist_gm.insertrow(0)
	   End if
		
	next
	
	//header level O0 Notes
	li_rtn_h = ld_delivery_notes.retrieve(gs_project,lsDONO,'O0')
	for j=1 to li_rtn_h 
		
		ld_packlist_gm.insertrow(0)
		
		ls_note_h = ld_delivery_notes.getitemstring(j,"note_text")
		li_row =ld_packlist_gm.rowcount()
		ld_packlist_gm.setitem(li_row,"note",ls_note_h)
		
	next
		
	li_rtn_d =ld_pack_detail.retrieve(lsDONO)

	for k = 1 to li_rtn_d /*Each Detail */
		
		li_line_item_no = ld_pack_detail.getitemnumber(k,"delivery_detail_line_item_no")
		ls_sku = ld_pack_detail.getitemstring(k,"delivery_detail_sku")
		lsAltSKU = ld_pack_detail.getitemstring(k,"alternate_Sku")
		li_req_qty = ld_pack_detail.getitemnumber(k,"delivery_detail_req_qty")
		ld_alloc_qty = ld_pack_detail.getitemnumber(k,"delivery_detail_alloc_qty")
		ls_invoice_no = ld_pack_detail.getitemstring(k,"delivery_master_invoice_no")
		ls_user_field4 = ld_pack_detail.getitemstring(k,"delivery_detail_user_field4")
		ls_user_field5 = ld_pack_detail.getitemstring(k,"delivery_detail_user_field5")
		ls_user_field6 = ld_pack_detail.getitemstring(k,"delivery_detail_user_field6")
		ls_user_field8 = ld_pack_detail.getitemstring(k,"delivery_detail_user_field8")
		ls_user_field6_m = ld_pack_detail.getitemstring(k,"delivery_master_user_field6")
		ls_user_field3 = ld_pack_detail.getitemstring(k,"delivery_detail_user_field3")
		ls_user_field1 = Left(ld_pack_detail.getitemstring(k,"delivery_detail_user_field1"),4) /* 04/04 - PCONKL - PEr GM, only left 4 of CNTL # */
		
		//Detail Level O0 Notes
		li_rtn_dn = ld_note_detail.retrieve(gs_project,lsDONO,li_line_item_no,"O0")
		
	   for l=1 to li_rtn_dn 
		  ls_note_d = ld_note_detail.getitemstring(l,"note_text")
		  li_row = ld_packlist_gm.insertrow(0)
			ld_packlist_gm.setitem(li_row,"note",ls_note_d)
	   next
		
		//Detail Level W0 Notes
		li_rtn_dn = ld_note_detail.retrieve(gs_project,lsDONO,li_line_item_no,"W0")
		
	   for l=1 to li_rtn_dn 
		  ls_note_d = ld_note_detail.getitemstring(l,"note_text")
		  li_row = ld_packlist_gm.insertrow(0)
			ld_packlist_gm.setitem(li_row,"note",ls_note_d)
	   next
				
	   li_row = ld_packlist_gm.insertrow(0)
		liDetailLine = li_Row /* we may need to adjust the detail row below after the notes have been printed*/
		
	 	if ls_customer = 'ACD' then		
		
			ld_packlist_gm.setitem(li_row,"v66",ls_sku)
			ld_packlist_gm.setitem(li_row,"v84",li_line_item_no)
			ld_packlist_gm.setitem(li_row,"v68",li_req_qty)
     		ld_packlist_gm.setitem(li_row,"v181",ld_alloc_qty)	
			ld_packlist_gm.setitem(li_row,"v155",ls_user_field6_m)
			ld_packlist_gm.setitem(li_row,"v183",ls_user_field4)
			ld_packlist_gm.setitem(li_row,"v154",ls_user_field3)
			ld_packlist_gm.setitem(li_row,"v105",ls_user_field8)
			ld_packlist_gm.setitem(li_row,"v182",ls_user_field5)
			ld_packlist_gm.setitem(li_row,"v9",ls_invoice_no) //07/07 - PCONKL - added to print barcoded Invoice_No (was missing)
		
		else
		
	  		ld_packlist_gm.setitem(li_row,"v66",ls_sku)
			ld_packlist_gm.setitem(li_row,"v84",li_line_item_no)
			ld_packlist_gm.setitem(li_row,"v68",li_req_qty)
     	 	ld_packlist_gm.setitem(li_row,"v181",ld_alloc_qty)	
			ld_packlist_gm.setitem(li_row,"v155",ls_user_field6_m)
			ld_packlist_gm.setitem(li_row,"v154",ls_user_field3)
			ld_packlist_gm.setitem(li_row,"v105",ls_user_field8)
			ld_packlist_gm.setitem(li_row,"v9",ls_invoice_no)
			ld_packlist_gm.setitem(li_row,"v92",ls_user_field6)
			ld_packlist_gm.setitem(li_row,"v94",ls_user_field1)
		
  		end if
	
		// T0 level detail Notes
   	li_rtn_dn = ld_note_detail.retrieve(gs_Project,lsDONO,li_line_item_no,"T0")
		for l=1 to li_rtn_dn 
		
	 	 ls_note_d = ld_note_detail.getitemstring(l,"note_text")
	 	 li_row = ld_packlist_gm.insertrow(0)
	 	 ld_packlist_gm.setitem(li_row,"note",ls_note_d)
		  
		next
	
		// 07/05 - PCONKL - If we are shipping an alternate SKU, we need to add the line item and a T0 note showing the replacement.
	
		//Compare what Detail shows as allocated to what was really picked. Detail alloc_qty will include Alternate SKU's picked
		ldPickQty = 0
		lsFind = "Upper(Invoice_No) = '" + Upper(ls_invoice_no) + "' and Line_Item_No = " + String(li_line_item_no) + " and Upper(sku) = '" + Upper(ls_sku) + "'"
		llFindRow = w_batch_Pick.idw_pick.Find(lsFind,1,w_batch_Pick.idw_pick.RowCount())
		Do While llFindRow > 0
			ldPickQty += w_batch_Pick.idw_pick.getItemNumber(llFindrow,'Quantity')
			llFindRow ++
			If llFindRow > w_batch_Pick.idw_pick.RowCount() Then
				llFindRow = 0
			Else
				llFindRow = w_batch_Pick.idw_pick.Find(lsFind,llFindRow,w_batch_Pick.idw_pick.RowCount())
			End If
		Loop
		
		//If summed pick qty is less than alloc qty on detail, we shipped a substitution and need to note it on the PL
		If ldPickQty < ld_alloc_qty and g.is_allow_alt_sku_Pick = 'Y' Then
		
			//If we didn't pick any of the Primary SKU, Delete the primary row
			If ldPickQty = 0 Then
				ld_packlist_gm.DeleteRow(liDetailLine)
			Else
				//set the qty on the current detail row to the real picked qty
				ld_packlist_gm.setitem(liDetailLine,"v68",ldPickQty) /* req Qty for primary is same as Picked*/
				ld_packlist_gm.setitem(liDetailLine,"v181",ldPickQty)	/*set the alloc qty on the current detail row to the real picked qty*/
			End If
							
			//Insert a row for the alternate
			li_row = ld_packlist_gm.insertrow(0) /*detail row*/
			ld_packlist_gm.setitem(li_row,"v66",lsAltsku)
			ld_packlist_gm.setitem(li_row,"v84",li_line_item_no)
			ld_packlist_gm.setitem(li_row,"v68",li_req_qty - ldPickQty) /* req qty = total req qty - picked qty for primary SKU */
    	 	ld_packlist_gm.setitem(li_row,"v181",ld_alloc_qty - ldPickQty)	
			ld_packlist_gm.setitem(li_row,"v9",ls_invoice_no)
		
			//Insert a T0 Note to show replacement
			li_row = ld_packlist_gm.insertrow(0)
			ld_packlist_gm.setitem(li_row,"note","**** ORD ITEM NOTE:   " + String(li_line_item_no) + "  " + ls_sku + "   REPLACED BY " + lsAltSKU)
			
		End If

		// E0 level detail notes (maybe summary level instead)
		li_rtn_dn = ld_note_detail.retrieve(gs_Project,lsDONO,li_line_item_no,"E0")
		for l=1 to li_rtn_dn 
		 	 ls_note_d = ld_note_detail.getitemstring(l,"note_text")
			  li_row = ld_packlist_gm.insertrow(0)
		  	ld_packlist_gm.setitem(li_row,"note",ls_note_d)
		next

	next /*Detail Record */
	

	//Only open dialog box for first one, otherwise print with current settings
	If llRowPos = 1 Then
		OpenWithParm(w_dw_print_options,ld_packlist_gm) 
		llCopies = Long(ld_packlist_gm.Describe("datawindow.print.copies"))
	Else
		lsrc = ld_packlist_gm.Modify("datawindow.print.copies=" + String(llcopies))
		ld_packlist_gm.Print()
	End If
	
Next /* Order */

SetPointer(Arrow!)
	
DESTROY ld_packlist_gm
DESTROY ld_pack_detail
DESTROY ld_note_detail

Return 0

end function

public function integer uf_packing_slip_linksys ();// This event prints the Packing List which is currently visible on the screen 
// and not from the database - 

Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos
Decimal	ld_weight
String ls_address,lsfind,ls_text[], lscusttype, lscustcode
String ls_project_id , ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT,lsdono, lsNotes
Datastore	ld_packprint

////Set Packing List object
//w_do.idw_packPrint.Dataobject = 'd_linksys_packing_slip_prt'
//
lsDONO = w_do.idw_main.GetITemString(1,'do_no')

string ls_Freight_Code

ls_freight_code = Upper(w_do.idw_other.GetITemString(1,"freight_terms"))
lsNotes = Upper(w_do.idw_other.GetITemString(1,"packlist_notes"))


boolean ib_no_fterm = false

if IsNull(ls_freight_code) then 
	ib_no_fterm = true
	ls_freight_code = "DEFAULT"
end if

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print
ll_cnt = w_do.idw_pack.rowcount()
If ll_cnt = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

SetPointer(Hourglass!)

ld_packprint = Create Datastore
ld_packprint.dataobject ='d_linksys_packing_slip_prt'

ld_packprint.settransobject(sqlca)
ll_cnt=ld_packprint.retrieve(lsDONO)

string  ls_carton[]
integer li_carton_count[], li_add_carton_count
long ll_row_per_page = 11, ll_num_total_rows, li_add_rows, li_idx, li_idx2
boolean lb_group_by_carton = false

string ls_cust_code, ls_Packlist_By_Container

ls_cust_code = w_do.idw_main.GetITemString(1,'cust_code')

SELECT USER_FIELD5 INTO :ls_Packlist_By_Container
	FROM Customer
	WHERE CUST_CODE = :ls_cust_code AND
		PROJECT_ID = :gs_project USING SQLCA;

IF Trim(Upper(ls_Packlist_By_Container)) = 'Y' then
	lb_group_by_carton = true
else
	
	ld_packprint.Modify("delivery_packing_carton_no.visible='0'")
	
end if

//lb_group_by_carton = true

string ls_current_carton

boolean lb_found = false
integer  li_found_carton_idx

for li_idx = 1 to ll_cnt


	ld_packprint.SetItem( li_idx, "delivery_master_freight_terms", ls_freight_code)
	ld_packprint.SetItem( li_idx, "delivery_master_packlist_notes", lsNotes)


	ls_current_carton = trim(ld_packprint.GetItemString(li_idx, "delivery_packing_carton_no"))

	if lb_group_by_carton then
		ld_packprint.SetItem(li_idx, "sort_group", ls_current_carton)
	end if

	lb_found = false
	
	for li_idx2 = 1 to UpperBound(ls_carton[])

		if ls_current_carton = ls_carton[li_idx2] then
			
			lb_found = true
			li_found_carton_idx = li_idx2
			EXIT
	
		end if
			
		
	next
	
	if not lb_found then
		
		ls_carton[UpperBound(ls_carton)+1] = ls_current_carton

		li_carton_count[UpperBound(ls_carton)] = 1

	else	
		
		li_carton_count[li_found_carton_idx] = li_carton_count[li_found_carton_idx] + 1

		
	end if
	
next

//MessageBox (string(ls_carton[UpperBound(ls_carton)]), li_carton_count[1])

integer li_row 

if lb_group_by_carton then

	for li_idx = 1 to UpperBound(ls_carton)

		ll_num_total_rows = (1 + (integer((li_carton_count[li_idx]/ll_row_per_page)))) * ll_row_per_page
		
		li_add_rows = ll_num_total_rows - li_carton_count[li_idx]
	
	
		if li_add_rows > 0 then
			
			for li_idx2 = 1 to li_add_rows
		
				li_row = ld_packprint.InsertRow(ld_packprint.RowCount() + 1)
			
				ld_packprint.SetItem(li_row, "filler", 1)
				ld_packprint.SetItem(li_row, "sort_group", ls_carton[li_idx])
				ld_packprint.SetItem(li_row, "delivery_packing_carton_no", ls_carton[li_idx])				
				ld_packprint.SetItem( li_row, "delivery_master_freight_terms", ls_freight_code)
				ld_packprint.SetItem( li_row, "delivery_master_packlist_notes", lsNotes)
				
			next
		end if
	next
else

	ld_packprint.Modify("delivery_packing_carton_no.visible='0'")

	ld_packprint.Sort()

	ls_current_carton =  ld_packprint.GetItemString( ld_packprint.RowCount(), "delivery_packing_carton_no")

	ll_num_total_rows = (1 + (integer((ll_cnt/ll_row_per_page)))) * ll_row_per_page
	
	li_add_rows = ll_num_total_rows - ll_cnt
	
	if li_add_rows > 0 then
		
		for li_idx = 1 to li_add_rows
	
			li_row = ld_packprint.InsertRow(ld_packprint.RowCount() + 1)
		
			ld_packprint.SetItem(li_row, "filler", 1)
			ld_packprint.SetItem(li_row, "delivery_packing_carton_no", ls_current_carton)				
			ld_packprint.SetItem( li_row, "delivery_master_freight_terms", ls_freight_code)
			ld_packprint.SetItem( li_row, "delivery_master_packlist_notes", lsNotes)
					
	
		
		next
	end if

	for li_idx = 1 to ld_packprint.RowCount()

		ld_packprint.SetItem(li_idx, "sort_group", "XX")				
		

	next	

	


end if

integer li_rowcount

li_rowcount = w_do.idw_detail.RowCount()

integer li_req_qty[], li_alloc_qty[], li_bo, li_find, li_bo_idx, li_sku_count
string ls_bo_sku[], ls_bo_sku_1
boolean lb_sku_found

for li_idx = 1 to li_rowcount
	//req_qty
	//alloc_qty
//	li_req_qty = w_do.idw_detail.GetItemNumber( li_idx, "req_qty")
//	li_alloc_qty = w_do.idw_detail.GetItemNumber( li_idx, "alloc_qty")
	ls_bo_sku_1 = trim(w_do.idw_detail.GetItemString( li_idx, "sku"))

	lb_sku_found = false
	
	for li_bo_idx = 1 to UpperBound(ls_bo_sku[])	
	
		if ls_bo_sku_1 = ls_bo_sku[li_bo_idx] then
			lb_sku_found = true
			li_sku_count = li_bo_idx
			exit
		end if
	
	next
	
	if not lb_sku_found then
		
		li_sku_count = Upperbound(ls_bo_sku)		
		
		li_sku_count = li_sku_count + 1
		
		ls_bo_sku[li_sku_count] = ls_bo_sku_1
		li_req_qty[li_sku_count] = w_do.idw_detail.GetItemNumber( li_idx, "req_qty")
		li_alloc_qty[li_sku_count] = w_do.idw_detail.GetItemNumber( li_idx, "alloc_qty")
		
	else
		
		li_req_qty[li_sku_count] = li_req_qty[li_sku_count] + w_do.idw_detail.GetItemNumber( li_idx, "req_qty")
		li_alloc_qty[li_sku_count] = li_alloc_qty[li_sku_count] + w_do.idw_detail.GetItemNumber( li_idx, "alloc_qty")
		
		
	end if
	
next

for li_bo_idx = 1 to UpperBound(ls_bo_sku[])	

	if li_alloc_qty[li_bo_idx] < li_req_qty[li_bo_idx] then

		li_bo = li_req_qty[li_bo_idx] - li_alloc_qty[li_bo_idx]

		li_find = ld_packprint.Find("delivery_packing_sku='"+ls_bo_sku[li_bo_idx]+"'", 1, ld_packprint.RowCount())
	
		if li_find > 0 then
			ld_packprint.SetItem(li_find, "backorder",  li_bo)
		end if
	end if
next


//lookup_table_code_descript

ld_packprint.Sort()
ld_packprint.GroupCalc()

OpenWithParm(w_dw_print_options,ld_packprint) 

If message.doubleparm = 1 then
	If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
		w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
		w_do.idw_main.SetItem(1,"ord_status","I")
		w_do.ib_changed = TRUE
		w_do.iw_window.trigger event ue_save()
	End If
End If

SetPointer(Arrow!)

REturn 0
end function

public function integer uf_packing_slip_logitech ();// This event prints the Packing List which is currently visible on the screen 
// and not from the database - 


Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos
Decimal	ld_weight
String ls_address,lsfind,ls_text[], lscusttype, lscustcode
String ls_project_id , ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT,lsdono
datastore	ld_packprint
datawindow ldw_dw

////Set Packing List object
//w_do.idw_packPrint.Dataobject = 'd_linksys_packing_slip_prt'
//
lsDONO = w_do.idw_main.GetITemString(1,'do_no')

Clipboard( lsDONO)

//string ls_Freight_Code
//
//ls_freight_code = Upper(w_do.idw_other.GetITemString(1,"freight_terms"))
//

//boolean ib_no_fterm = false
//
//if IsNull(ls_freight_code) then 
//	ib_no_fterm = true
//	ls_freight_code = "DEFAULT"
//end if

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print
ll_cnt = w_do.idw_pack.rowcount()
If ll_cnt = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

OpenWithParm(w_logitech_packing_list_print_preview, lsDONO )


REturn 0
end function

public function integer uf_packprint_gmbattery ();
//GM Battery Packlist Print - Includes lines from order detail that were not shiped at all

Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos
Decimal	ld_weight
String ls_address,lsfind,ls_text[], lscusttype, lscustcode
String ls_project_id , ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT, lsUPC, lsPrinter

w_do.idw_packPrint.Dataobject = 'd_gmbattery_packing_prt'


SetPointer(HourGlass!)
If w_do.idw_pack.AcceptText() = -1 Then
	w_do.tab_main.SelectTab(3) 
	w_do.idw_pack.SetFocus()
	Return -1
End If

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return -1
End If

//No row means no Print
ll_cnt = w_do.idw_pack.rowcount()
If ll_cnt = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return -1
End If

//Clear the Report Window (hidden datawindow)
w_do.idw_packprint.Reset()
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")

lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")
	
//Ship from address from Warehouse Table
Select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
Into	:lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
From warehouse
Where WH_Code = :lsWHCode
Using Sqlca;

lsTransPortMode= w_do.idw_main.GetITemString(1,'transport_Mode') /* used for printing haz mat info*/

//Loop through each row in Tab pages and grab the coresponding info
For i = 1 to ll_cnt
	
	j = w_do.idw_packprint.InsertRow(0)
	
	//Get SKU, Description and Quantities  04/05/00 PCONKL - include user field5 as pdc_whse_loc
	// 02/02 - PConkl - include hazardous text cd
	
	ls_sku = w_do.idw_pack.getitemstring(i,"sku")
	ls_supplier = w_do.idw_pack.getitemstring(i,"supp_code")
	llLineItemNo = w_do.idw_pack.GetITemNumber(i,'line_item_no')
	
	If ls_SKU <> lsSKUHold Then
		
		select description, weight_1, hazard_text_cd, part_upc_Code
		into :ls_description, :ld_weight, :lshazCode, :lsUPC
		from item_master 
		where project_id = :ls_project_id and sku = :ls_sku and supp_code = :ls_supplier ;
		
	End If /*Sku Changed*/
	
	lsSkuHold = ls_SKU

	ls_description = trim(ls_description)
	
	//Set all Items on the Report by grabbing info from tab pages
	w_do.idw_packprint.setitem(j,"carton_no",w_do.idw_pack.getitemString(i,"carton_no")) /*Printed report should show carton # from screen instead of row #*/
	w_do.idw_packprint.setitem(j,"bol_no",w_do.is_bolno)
	w_do.idw_packprint.setitem(j,"ord_no",w_do.idw_main.getitemstring(1,"cust_order_no"))
	w_do.idw_packprint.setitem(j,"freight_terms",w_do.idw_other.getitemstring(1,"freight_terms"))	
	w_do.idw_packprint.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code")) /* 5/3/00 PCONKL*/
	w_do.idw_packprint.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
	w_do.idw_packprint.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
	w_do.idw_packprint.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
	w_do.idw_packprint.setitem(j,"complete_date",w_do.idw_main.getitemdatetime(1,"complete_date"))
	w_do.idw_packprint.setitem(j,"sku",ls_sku)
	w_do.idw_packprint.setitem(j,"description",ls_description)
	w_do.idw_packprint.setitem(j,"unit_weight",w_do.idw_pack.getitemDecimal(i,"weight_net")) /*take from displayed pask list instead of DB*/
	w_do.idw_packprint.setitem(j,"standard_of_measure",w_do.idw_pack.getitemString(i,"standard_of_measure"))
	w_do.idw_packprint.setitem(j,"carrier",w_do.idw_other.getitemString(1,"carrier"))
	w_do.idw_packprint.setitem(j,"ship_via",w_do.idw_other.getitemString(1,"ship_via")) /* 5/3/00 PCONKL */
	w_do.idw_packprint.setitem(j,"sch_cd",w_do.idw_other.getitemString(1,"user_field1")) /* 5/3/00 PCONKL */
	w_do.idw_packprint.setitem(j,"packlist_notes",w_do.idw_main.getitemString(1,"packlist_notes")) /* 09/01 PCONKL */
	w_do.idw_packprint.setitem(j,"upc_Code",lsUPC) /* 04/04 PCONKL */
	w_do.idw_packprint.setitem(j,"project_id",gs_project) /* 12/01 PCONKL */
	w_do.idw_packprint.setitem(j,"HazText",lshazText) /* 02/02 PCONKL */
	//For English to Metrtics changes added L or K based on E or M
	ls_etom=w_do.idw_packprint.getitemString(j,"standard_of_measure")
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
	
	// 5/4/00 PCONKL - find matching row in detail to get ordered quantity and CNTL Number
	
	// 09/01 - PCONKL - we may have multiple pack rows that match to a single detail row. THis will cause the Order qty
	//                  to be wrong if we simply copy it for each row (it will be multiplied by each additional row). 
	//						  If the ordered qty on the order detail = the shipped qty, we will just set the ord qty = shipped qty
	//						  If Ord Qty > shipped qty, we will set the difference on the last row for the sku, the rest will be equal
	//						This assumes that the Shipped QTY on Packing List = Alloc QTY on DEtail. This will be validated before allowing to print (wf_val)
	
	lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLineItemNo)
	llRow = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
	
	if llRow > 0 Then
		w_do.idw_packprint.setitem(j,"cntl_number",w_do.idw_detail.getitemString(llRow,"user_field1")) /* Cntrl num // detail Weight for Sears*/
		w_do.idw_packprint.setitem(j,"user_field2",w_do.idw_detail.getitemString(llRow,"user_field2")) /* 12/01 for Saltillo*/
		w_do.idw_packprint.setitem(j,"alt_sku",w_do.idw_detail.getitemString(llRow,"alternate_sku"))
		w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_detail.getitemnumber(llRow,"req_qty"))
		
	Else /*row not found (should never happen), set req qty to 0*/
		w_do.idw_packprint.setitem(j,"cntl_number",'')
	End If
	
	w_do.idw_packprint.setitem(j,"picked_quantity",w_do.idw_pack.getitemNumber(i,"quantity")) /* 5/4/00 - PCONKL*/
	w_do.idw_packprint.setitem(j,"volume",w_do.idw_pack.getitemDecimal(i,"cbm")) /* 02/01 - PCONKL*/
	If w_do.idw_pack.getitemDecimal(i,"cbm") > 0 Then
		w_do.idw_packprint.setitem(j,'dimensions',string(w_do.idw_pack.getitemDecimal(i,"length")) + ' x ' + string(w_do.idw_pack.getitemDecimal(i,"width")) + ' x ' + string(w_do.idw_pack.getitemDecimal(i,"height"))) /* 02/01 - PCONKL*/
	End If
	w_do.idw_packprint.setitem(j,"country_of_origin",w_do.idw_pack.getitemstring(i,"country_of_origin")) /* 10/00 - PCONKL*/
	w_do.idw_packprint.setitem(j,"supp_code",w_do.idw_pack.getitemstring(i,"supp_code")) /* 10/00 - PCONKL*/
	w_do.idw_packprint.setitem(j,"serial_no",w_do.idw_pack.getitemstring(i,"free_form_serial_no")) /* 02/01 - PCONKL*/
	w_do.idw_packprint.setitem(j,"component_ind",w_do.idw_pack.getitemstring(i,"component_ind")) /* 02/01 - PCONKL - sort component master to top*/
		
	w_do.idw_packprint.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
	w_do.idw_packprint.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
	w_do.idw_packprint.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
	w_do.idw_packprint.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
	w_do.idw_packprint.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
	w_do.idw_packprint.setitem(j,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
	w_do.idw_packprint.setitem(j,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
	w_do.idw_packprint.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
	
	// 07/00 PCONKL - Ship from info is coming from Project Table  
	w_do.idw_packprint.setitem(j,"ship_from_name",lsName)
	w_do.idw_packprint.setitem(j,"ship_from_address1",lsaddr1)
	w_do.idw_packprint.setitem(j,"ship_from_address2",lsaddr2)
	w_do.idw_packprint.setitem(j,"ship_from_address3",lsaddr3)
	w_do.idw_packprint.setitem(j,"ship_from_address4",lsaddr4)
	w_do.idw_packprint.setitem(j,"ship_from_city",lsCity)
	w_do.idw_packprint.setitem(j,"ship_from_state",lsstate)
	w_do.idw_packprint.setitem(j,"ship_from_zip",lszip)
	w_do.idw_packprint.setitem(j,"ship_from_country",lscountry)
		
Next /*Packing Row*/

//We also want to include rows from Delivery Detail where nothing was shipped to show back order
ll_cnt = w_do.idw_Detail.rowcount()
For i = 1 to ll_Cnt

	If w_do.idw_detail.GetITemNumber(i,'alloc_qty') > 0 Then Continue /* only want completely unshipped rows*/
	
	j = w_do.idw_packprint.InsertRow(0)
		
	ls_sku = w_do.idw_detail.getitemstring(i,"sku")
	ls_supplier = w_do.idw_detail.getitemstring(i,"supp_code")
	llLineItemNo = w_do.idw_detail.GetITemNumber(i,'line_item_no')
	
	select description, weight_1, part_upc_Code
	into :ls_description, :ld_weight, :lsUPC
	from item_master 
	where project_id = :ls_project_id and sku = :ls_sku and supp_code = :ls_supplier ;
	
	ls_description = trim(ls_description)
	
	//Set all Items on the Report by grabbing info from tab pages
	w_do.idw_packprint.setitem(j,"carton_no",'') 
	w_do.idw_packprint.setitem(j,"bol_no",w_do.is_bolno)
	w_do.idw_packprint.setitem(j,"ord_no",w_do.idw_main.getitemstring(1,"cust_order_no"))
	w_do.idw_packprint.setitem(j,"freight_terms",w_do.idw_other.getitemstring(1,"freight_terms"))	
	w_do.idw_packprint.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code")) /* 5/3/00 PCONKL*/
	w_do.idw_packprint.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
	w_do.idw_packprint.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
	w_do.idw_packprint.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
	w_do.idw_packprint.setitem(j,"complete_date",w_do.idw_main.getitemdatetime(1,"complete_date"))
	w_do.idw_packprint.setitem(j,"sku",ls_sku)
	w_do.idw_packprint.setitem(j,"supp_code",ls_supplier)
	w_do.idw_packprint.setitem(j,"description",ls_description)
	w_do.idw_packprint.setitem(j,"unit_weight",0) 
	w_do.idw_packprint.setitem(j,"standard_of_measure",'')
	w_do.idw_packprint.setitem(j,"carrier",w_do.idw_other.getitemString(1,"carrier"))
	w_do.idw_packprint.setitem(j,"ship_via",w_do.idw_other.getitemString(1,"ship_via")) /* 5/3/00 PCONKL */
	w_do.idw_packprint.setitem(j,"sch_cd",w_do.idw_other.getitemString(1,"user_field1")) /* 5/3/00 PCONKL */
	w_do.idw_packprint.setitem(j,"packlist_notes",w_do.idw_main.getitemString(1,"packlist_notes")) /* 09/01 PCONKL */
	w_do.idw_packprint.setitem(j,"upc_Code",lsUPC) /* 04/04 PCONKL */
	w_do.idw_packprint.setitem(j,"project_id",gs_project) /* 12/01 PCONKL */
	w_do.idw_packprint.setitem(j,"cntl_number",w_do.idw_detail.getitemString(i,"user_field1")) /* Cntrl num // detail Weight for Sears*/
	w_do.idw_packprint.setitem(j,"user_field2",w_do.idw_detail.getitemString(i,"user_field2")) /* 12/01 for Saltillo*/
	w_do.idw_packprint.setitem(j,"alt_sku",w_do.idw_detail.getitemString(i,"alternate_sku"))
	w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_detail.getitemnumber(i,"req_qty"))
	w_do.idw_packprint.setitem(j,"picked_quantity",0) 
	w_do.idw_packprint.setitem(j,"volume",0) /* 02/01 - PCONKL*/
		
	w_do.idw_packprint.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
	w_do.idw_packprint.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
	w_do.idw_packprint.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
	w_do.idw_packprint.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
	w_do.idw_packprint.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
	w_do.idw_packprint.setitem(j,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
	w_do.idw_packprint.setitem(j,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
	w_do.idw_packprint.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
	
	w_do.idw_packprint.setitem(j,"ship_from_name",lsName)
	w_do.idw_packprint.setitem(j,"ship_from_address1",lsaddr1)
	w_do.idw_packprint.setitem(j,"ship_from_address2",lsaddr2)
	w_do.idw_packprint.setitem(j,"ship_from_address3",lsaddr3)
	w_do.idw_packprint.setitem(j,"ship_from_address4",lsaddr4)
	w_do.idw_packprint.setitem(j,"ship_from_city",lsCity)
	w_do.idw_packprint.setitem(j,"ship_from_state",lsstate)
	w_do.idw_packprint.setitem(j,"ship_from_zip",lszip)
	w_do.idw_packprint.setitem(j,"ship_from_country",lscountry)
	
	
next /*Detail Row */


i=1
FOR i = 1 TO UpperBound(ls_text[])
	w_do.idw_packprint.Modify(ls_text[i])
	ls_text[i]=""
NEXT

w_do.idw_packprint.Sort()
w_do.idw_packprint.GroupCalc()

// 09/04 - PCONKL - If we have a default printer for PackList, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','PACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

//Send the report to the Print report window
OpenWithParm(w_dw_print_options,w_do.idw_packprint) 

// 09/04 - PCONKL - We want to store the last printer used for Printing the Pack List for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','PACKLIST',lsPrinter)

If message.doubleparm = 1 then
	If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
		w_do.idw_main.GetItemString(1,"ord_status") = "P" or &
		w_do.idw_main.GetItemString(1,"ord_status") = "I" Then 
		w_do.idw_main.SetItem(1,"ord_status","A")
		w_do.ib_changed = TRUE
		w_do.trigger event ue_save()
	End If
End If

Return 0
end function

public function string uf_replacequotes (string asstring);//Replaces quote(") with apostrophe(')
Do While Pos(asString,'"') > 0
	asString = Replace(asString, Pos(asString,'"'), 1, "'")
Loop
Return asString

end function

public function integer uf_packprint_maquet ();//Print the Maquet packing slip

Long	llRowCount, llRowPos, llNewRow, llFindRow, llLineItemNo
String	lsSKU, lsSupplier, lsDesc, lsSerial, lsWHCode, lsaddr1, lsaddr2, lsaddr3, lsaddr4, lsCity, lsState, lsZip, lsCountry
Datastore	ld_packprint

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print (the data is coming from deliveryy Detail but we want to make sure the pack list is generated first)
llRowCount = w_do.idw_pack.rowcount()
If llRowCount = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

SetPointer(Hourglass!)

ld_packprint = Create Datastore
ld_packprint.dataobject ='d_maquet_packing_prt'

lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")
	
//Ship from address from Warehouse Table
Select Address_1, Address_2, Address_3, Address_4, city, state, zip, country
Into	 :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
From warehouse
Where WH_Code = :lsWHCode
Using Sqlca;


//For each detail row, gernete the pack data
llRowCount = w_do.idw_detail.RowCount()
For llRowPOs = 1 to llRowCount
	
	llNewRow = ld_packprint.InsertRow(0)
	
	lsSKU = w_do.idw_detail.getitemstring(llRowPos,"sku")
	lsSupplier = w_do.idw_detail.getitemstring(llRowPos,"supp_code")
	llLineItemNo = w_do.idw_detail.getitemNumber(llRowPos,"Line_Item_No")
	
	ld_packprint.setitem(llNewRow,"bol_no",w_do.idw_main.getitemstring(1,"Invoice_no"))
	ld_packprint.setitem(llNewRow,"ord_no",w_do.idw_main.getitemstring(1,"cust_order_no"))
	ld_packprint.setitem(llNewRow,"carrier",w_do.idw_main.getitemstring(1,"user_field1"))
	
	ld_packprint.setitem(llNewRow,"ship_from_address1",lsAddr1)
	ld_packprint.setitem(llNewRow,"ship_from_address2",lsAddr2)
	ld_packprint.setitem(llNewRow,"ship_from_address3",lsAddr3)
	ld_packprint.setitem(llNewRow,"ship_from_address4",lsAddr4)
	ld_packprint.setitem(llNewRow,"ship_from_state",lsState)
	ld_packprint.setitem(llNewRow,"ship_from_city",lsCity)
	ld_packprint.setitem(llNewRow,"ship_from_zip",lsZip)
	ld_packprint.setitem(llNewRow,"ship_from_country",lsCountry)
	
	ld_packprint.setitem(llNewRow,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
	ld_packprint.setitem(llNewRow,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
	ld_packprint.setitem(llNewRow,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
	ld_packprint.setitem(llNewRow,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
	ld_packprint.setitem(llNewRow,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
	ld_packprint.setitem(llNewRow,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
	ld_packprint.setitem(llNewRow,"city",w_do.idw_main.getitemstring(1,"city"))
	ld_packprint.setitem(llNewRow,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
	ld_packprint.setitem(llNewRow,"country",w_do.idw_main.getitemstring(1,"country"))
	
	If w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.RowCount() > 0 Then
		
		ld_packprint.setitem(llNewRow,"sold_to_name",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"name"))
		ld_packprint.setitem(llNewRow,"sold_to_address1",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"address_1"))
		ld_packprint.setitem(llNewRow,"sold_to_address2",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"address_2"))
		ld_packprint.setitem(llNewRow,"sold_to_address3",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"address_3"))
		ld_packprint.setitem(llNewRow,"sold_to_address4",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"address_4"))
		ld_packprint.setitem(llNewRow,"sold_to_state",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"state"))
		ld_packprint.setitem(llNewRow,"sold_to_city",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"city"))
		ld_packprint.setitem(llNewRow,"sold_to_zip",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"zip"))
		
	End If
		
	ld_packprint.setitem(llNewRow,"Line_item_no",llLineItemNo)
	ld_packprint.setitem(llNewRow,"sku",lsSKU)
	ld_packprint.setitem(llNewRow,"uom",w_do.idw_detail.getitemstring(llRowPos,"uom"))
	ld_packprint.setitem(llNewRow,"ord_qty",w_do.idw_detail.getitemNumber(llRowPos,"req_qty"))
	ld_packprint.setitem(llNewRow,"picked_quantity",w_do.idw_detail.getitemNumber(llRowPos,"alloc_qty"))
	
	//We need the Decription from Item MAster
	Select Description into :lsDesc
	From Item_Master
	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
	
	ld_packprint.setitem(llNewRow,"description",lsDesc)
	
	//There may be serial numbers on picking...
	lsSerial = ""
	llFindRow = w_do.idw_Pick.Find("Line_Item_No = " + String(llLineItemNO) + " and Upper(sku) = '" + Upper(lsSKU) + "'",1,w_do.idw_Pick.rowCount())
	Do While llFindRow > 0
		
		If w_do.idw_Pick.GetITemString(llFindROw,'serial_no') <> '-' Then
			lsSerial += ", " + w_do.idw_Pick.GetITemString(llFindROw,'serial_no')
		End IF
		
		llFindRow ++
		If llFindRow > w_do.idw_Pick.rowCount() Then
			llFindRow = 0
		Else
			llFindRow = w_do.idw_Pick.Find("Line_Item_No = " + String(llLineItemNO) + " and Upper(sku) = '" + Upper(lsSKU) + "'",llFindRow,w_do.idw_Pick.rowCount())
		End If
				
	Loop
	
	If lsSerial > "" Then
		lsSerial = Mid(lsSerial,3,99999) /*strip off first comma*/
	End If
	
	ld_packprint.setitem(llNewRow,"serial_no",lsSerial)
	
Next /*Detail row*/

OpenWithParm(w_dw_print_options,ld_packprint) 

Return 0
end function

public function integer uf_packprint_powerwave ();
Long	lLRowCount, llRowPos, llNewRow, llPickPos, llPickCount, llcartonCount, llPalletCount, lLDetailFindRow, llLineItem, llFind,	llwarehouseRow, &
		llSerialPos, llSerialCount, llBandHeight, llTotalHeight, llArrayPos, llArrayCount, llNotesCount, llNotesPos, llheaderCount, llSerialHeight, llCount
String	lsWarehouse, lsCityState, lsContact, lsSKU, lsSupplier, lsDONO, lsDesc, lsHTS, lsECCN, lsCOO, lsSerialNo, lsNotify, lsCityStateZip, lsCountry
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsCarton, lsCartonSave, lsDim, lsHeaderNotes, lsLineNotes, lsPlainDesc, lsCOO3,lsSpecialInstructions
String	lsCarrier, lsCarrierName, lsVersion
DataStore	ldpackprint, ldsSerial, ldsBillToAddress, ldsNotes, ldsImporterAddress, ldsDeliveryBOM, ldsChildSerial
Int	liRowsPerPAge, liEmptyRows, liMod, liRC
String	lsDimsArray[]
Long		llQtyArray[], llPickFindRow, llComponentCount, llComponentPos, llChildQty, llParentQty, llChildSerialCount, llChildSerialPos
Boolean	lbFound, lbLongRow

long ll_start, ll_place_hold, llTotalQty, llTemp
string ls_find, FirstToken,  EndToken, lsChildSKU, lsChildCOO

SetPointer(Hourglass!)

lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')

//01/08 - PCONKL - Ship From Address needs to come from Warehouse table
llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

ldpackprint = Create Datastore

// 05/07 - HCL has custom packing List 
// 12/07 - PCONKL - Custom PAcking list for Nokia orders out of SUZ to barcode serial numbers
If Pos(upper(w_do.idw_Main.GetITEmString(1,'cust_name')),'HCL') > 0 and  Upper(w_do.idw_Main.GetITemString(1,'country')) = "IN" Then
	ldpackprint.dataobject ='d_powerwave_packing_prt_hcl'
Elseif  Pos(upper(w_do.idw_Main.GetITEmString(1,'cust_name')),'NOKIA') > 0  and w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
	ldpackprint.dataobject ='d_powerwave_packing_prt_nokia_suz'
Elseif  w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then // 03/08 - PCONKL - Seperate PL (Generic) for Suzhou warehouse
	ldpackprint.dataobject ='d_powerwave_packing_prt_suz'
Else
	ldpackprint.dataobject ='d_powerwave_packing_prt'
End If

//BCR 23-FEB-2012: Child Components
ldsDeliveryBOM = Create Datastore
ldsDeliveryBOM.Dataobject = 'd_delivery_bom'
ldsDeliveryBOM.SetTransobject(sqlca)

//BCR 23-FEB-2012: Child Carton Serial Numbers
ldsChildSerial = Create Datastore
ldsChildSerial.Dataobject = 'd_do_carton_serial'
ldsChildSerial.SetTransobject(sqlca)
////////////

//Carton Serial Numbers
ldsSerial = Create Datastore
ldsSerial.Dataobject = 'd_do_carton_serial'
ldsSerial.SetTransobject(sqlca)

//Bill To Address
ldsBillToAddress = Create DataStore
ldsBillToAddress.dataObject = 'd_do_address_alt'
ldsBillToAddress.SetTransObject(sqlca)

//Delivery Notes
ldsNotes = Create Datastore
presentation_str = "style(type=grid)"

//Retrieve and Set NOtify (Importer address)
ldsImporterAddress = Create DataStore
ldsImporterAddress.dataObject = 'd_do_address_alt'
ldsImporterAddress.SetTransObject(sqlca)
ldsImporterAddress.Retrieve(lsdono, 'IM') 

If ldsImporterAddress.RowCount() > 0 Then
	
	If ldsImporterAddress.GetItemString(1,"name") > "" Then
		lsNotify = ldsImporterAddress.GetItemString(1,"name") + "~r"
	End If
	
	If ldsImporterAddress.GetItemString(1,"address_1") > "" Then
		lsNotify += ldsImporterAddress.GetItemString(1,"address_1") + "~r"
	End If
	
	If ldsImporterAddress.GetItemString(1,"address_2") > "" Then
		lsNotify += ldsImporterAddress.GetItemString(1,"address_2") + "~r"
	End If
	
	If ldsImporterAddress.GetItemString(1,"tel") > "" Then
		lsNotify += "tel: " + ldsImporterAddress.GetItemString(1,"tel") 
	End If
		
End If

// 03/08 - PCONKL - For Suzhou warehouse, we might be adding a static VAT # to the end of the NOtify info based on particluar customer or ship to Country
//If Importer (lsNotify) not sent on DM record (lsnotify = '' before adding static vat), add static text here as well

lsVersion = 'A1'

If  w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
	
	//If  w_do.idw_Main.GetITEmString(1,'cust_code') = '1880' and Upper(w_do.idw_Main.GetITEmString(1,'cust_name')) = 'RAYCOM'  Then /*A2*/
	If  w_do.idw_Main.GetITEmString(1,'cust_code') = '1880' and Upper(w_do.idw_Main.GetITEmString(1,'country')) = 'SE'  Then /*A2 - 12/08 - PCONKL*/
	
		lsVersion = 'A2'
		//If no importer address, set static text
		If lsNotify = '' Then
			lsNotify = "POWERWAVE TECHNOLOGIES SWEDEN AB"
		End If
		
		lsNotify += "~r" +  'VAT # SE556458086701'
		//lsSpecialInstructions = "FREIGHT BILL: POSW01 WCC"
		
	ElseIf  w_do.idw_Main.GetITEmString(1,'cust_code') = '1031' and Upper(w_do.idw_Main.GetITEmString(1,'City')) = 'EERSEL'  Then /*A4*/
		
		lsVersion = 'A4'
		//If no importer address, set static text
//		If lsNotify = '' Then
//			lsNotify = "POWERWAVE TECHNOLOGIES SWEDEN AB"
//		End If
		
		lsNotify += "~r" +  'POWERWAVE TECHNOLOGIES, INC.~rVAT # NL8171.80.424.B.01' /* 12/08 - PCONKL */
		lsNotify += "~r" +  '1801 E. ST ANDREW PLACE' /* 03/09 - PCONKL */
		lsNotify += "~r" +  'SANTA ANA, CA 92705 USA' /* 03/09 - PCONKL */
		
		//lsSpecialInstructions = "ROUTE SHIPMENT THRU AMS UTI FISCAL REP, ON-FORWARD TO ULTIMATE CONSIGNEE. SERVICE TYPE; WCC-POSW01"
		lsSpecialInstructions = "ROUTE SHIPMENT THRU AMS CEVA FISCAL REP, ON-FORWARD TO ULTIMATE CONSIGNEE."
		
		ldPAckPrint.modify("on_behalf_of_t.text='ON BEHALF OF/SELLER'") /* 12/08 - PCONKL - modify header*/
		
	ElseIf  w_do.idw_Main.GetITEmString(1,'cust_code') = '1031' and (Upper(w_do.idw_Main.GetITEmString(1,'City')) = 'CARSON' or Upper(w_do.idw_Main.GetITEmString(1,'City')) = 'SANTA ANA')  Then /*A7*/
		
		lsVersion = 'A7'
		//If no importer address, set static text
		If lsNotify = '' Then
			lsNotify = "POWERWAVE TECHNOLOGIES, INC. C/O CEVA"
		End If
		
		lsSpecialInstructions = "BILL TO POTE03 WCC" 
		
	ElseIf  w_do.idw_Main.GetITEmString(1,'cust_code') = '9380' Then /*A8*/
		
		lsVersion = 'A8'
		//If no importer address, set static text
		If lsNotify = '' Then
			lsNotify = "SYMBOL TECHNOLOGIES, INC."
		End If
		
	ElseIf  w_do.idw_Main.GetITEmString(1,'cust_code') = '6240' Then /*A9 */
		
		lsVersion = 'A9'
		//If no importer address, set static text
		If lsNotify = '' Then
			lsNotify = "SYRMA TECHNOLOGY PRIVATE LIMITED"
		End If
		
		lsSpecialInstructions = "WCC"
		
	ElseIf  w_do.idw_Main.GetITEmString(1,'cust_code') = '1174' Then /*A10*/
		
		lsVersion = 'A10'
		//If no importer address, set static text
		If lsNotify = '' Then
			lsNotify = "BROKER GONDRAND AT DIEPPE"
		End If
		
		lsNotify += "~r" +  'VAT # FR55338966385' 
		
		//lsSpecialInstructions = "FREIGHT BILL: POSW01" 
		
	ElseIf  w_do.idw_Main.GetITEmString(1,'cust_code') = '1150' Then /*A11*/
		
		lsVersion = 'A11'
		//If no importer address, set static text
		If lsNotify = '' Then
			lsNotify = "FLEXTRONICS-ENTREPOT TELIS"
		End If
		
		lsNotify += "~r" +  'VAT # FR32479733230' 
	//	lsSpecialInstructions = "DOC SWAP REQUIRED - SERVICE TYPE: WOCC - POSW01" 
		
	Else /*Check if in European Union 12/08 - PCONKL - Exclude GB, DE, FI, SE and EE */
		
		lsCountry = w_do.idw_Main.GetITEmString(1,'country')
		Choose Case Len(lsCountry) /* 2 or 3 char country code */
				
			Case 2
				
				Select Count(*) into : llCount
				From Country
				Where designating_Code = :lsCountry and eu_country_Ind = 'Y' and designating_code Not in ('GB', 'DE', 'FI', 'SE', 'EE');
				
			Case 3
				
				Select Count(*) into : llCount
				From Country
				Where iso_Country_cd = :lsCountry and eu_country_Ind = 'Y' and designating_code Not in ('GBR', 'DEU', 'FIN', 'SWE', 'EST');
				
			Case Else
				
				llCount = 0
				
		End Choose
		
	End If
	
	If llCount > 0 and Left(Upper(w_do.idw_Main.GetITEmString(1,'user_field7')),3) = "DDP" Then /*EU Country - A3 */ //12/08 - PCONKL - Only A3 if Incoterms (UF7) begins with "DDP"
	
		lsVersion = 'A3'
		//If no importer address, set static text
//		If lsNotify = '' Then
//			lsNotify = "POWERWAVE TECHNOLOGIES SWEDEN AB"
//		End If
		
		lsNotify += "~r" +  'POWERWAVE TECHNOLOGIES, INC.~rVAT # NL8171.80.424.B.01' 
		//lsSpecialInstructions = "ROUTE SHIPMENT THRU AMS UTI FISCAL REP, ON-FORWARD TO ULTIMATE CONSIGNEE. SERVICE TYPE: WCC-POSW01" 
		lsSpecialInstructions = "ROUTE SHIPMENT THRU AMS CEVA FISCAL REP, ON-FORWARD TO ULTIMATE CONSIGNEE." 
		
		ldPAckPrint.modify("on_behalf_of_t.text='ON BEHALF OF/SELLER'") /* 12/08 - PCONKL - modify header*/
		
	End If
	
//	//If A1 and no importer, set static text
//	If lsNotify = '' Then
//		lsNotify = "CHECK FOR ‘SHIPPING INSTRUCTIONS"
//	End If

	//12/08 - PCONKL - If A1, modify Heading
	If lsversion = 'A1' or lsversion = 'A3' or lsversion = 'A4' Then
		ldPackPrint.modify("ultimate_consignee_t.text='ULTIMATE CONSIGNEE/SHIP TO CUSTOMER:'") 
	End If
	
End If /* Suzhou Warehouse*/

lsSQl = "Select note_type, Note_seq_No, Note_Text, Line_Item_No from Delivery_Notes Where do_no = '" + w_do.idw_Main.GetITEmString(1,'do_no') + "'"
lsSql += " and note_type in ('H', 'L')"

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsNotes.Create( dwsyntax_str, lsErrText)
ldsNotes.SetTransObject(SQLCA)
llNotesCount = ldsNotes.Retrieve()
ldsNotes.SetSort("Note_type A, Note_Seq_No A")
ldsNotes.Sort()

//Extract header Notes...

//Need the header count to determine if we need to not add a CR/LF (only room for 5 lines...).
//Also want to not add CR/LF if any rows are longer than what will fit on a single line (~ 65 char)

llheaderCount = 0
lbLongRow = False
For llNotesPos = 1 to llNotesCount
	
	If ldsNotes.GetITemString(llNotesPos,'Note_type') = 'H' Then /*header */
		llheaderCount ++
	End If
	
	If Len(ldsNotes.GetITemString(llNotesPos,'Note_text')) > 65 Then
		lbLongRow = True
	End If
	
Next

For llNotesPos = 1 to llNotesCount
	
	If ldsNotes.GetITemString(llNotesPos,'Note_type') = 'H' Then /*header */
		lsheaderNotes += ldsNotes.GetITemString(llNotesPos,'Note_text') 
		
		//If more than 5 rows or any row > 65 characters , don't add a CR/LF, just a space
		If llheaderCount > 5  or lbLongRow Then
			lsHeaderNotes += "   "
		Else
			lsheaderNotes += "~r"
		End If
		
	End If
	
Next

//12/08 - PCONKL -For SUZ  WE are only taking from Special Instructions on DO
If  w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
	lsHeaderNOtes = w_do.idw_Main.GetITemString(1,'shipping_instructions')
	If isnull(lsHeaderNotes) Then lsHeaderNotes = ''
End If

//For Suzhou, include any static special instructions formatted above
If  w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
	lsHeaderNotes += ' ' + lsSpecialInstructions
End If

//MAS 030711 - when printing " DON'T SEND ANY DOCS TOGETHER WITH THE SHIPMENT "
//" DON' " is what gets printed...everyhing after the Apostrophe is truncated by Modify
ll_start = 1
ll_place_hold = 0
ls_find = "'"

DO
	ll_place_hold = Pos(lsheaderNotes, ls_find, ll_start)
	
	If ll_place_hold > 0 Then
		
		//place holder for 1st part of string before Asterisk
		FirstToken = Mid(lsheaderNotes, (1 ), ((ll_place_hold - 1)))
		
		//place holder for 2nd part of string after Asterisk
		EndToken = Mid(lsheaderNotes, (ll_place_hold + 1 ))
		
		//add tilde before Asterisk to prevent Modify from Truncating the string
		lsheaderNotes = FirstToken + '~~~''+ EndToken
			 
		//account for the insert of tilde, so we add 2 to the place holder
		ll_start = ll_place_hold + 2
		
	End If
LOOP WHILE ll_place_hold > 0
//**********************END OF MAS CHANGES***************************


ldPackPrint.Modify("special_instructions_t.Text='" + lsheaderNotes + "'")

//Number of rows per page - we will want to insert enough rows on the last page so the sumamry is at the bottom
liRowsPerPage = 17 /* testing with standard - production on A4 in Europe (probably 20) */


// 05/08 - PCONKL - For Suzhou, We really want the On Behalf Of Address record
If  w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
	ldsBillToAddress.Retrieve(lsdono, 'OB') /*On Behalf of Address*/
Else
	ldsBillToAddress.Retrieve(lsdono, 'BT') /*Bill To Address*/
End If

//ldsBillToAddress.Retrieve(lsdono, 'BT') /*Bill To Address*/


//12/08 - For Suz, Want Carrier Name instead of Code
If  w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
	
	lsCarrier = w_do.idw_Main.GetITemString(1,'carrier')
	
	Select Carrier_Name into :lscarrierName
	From Carrier_Master
	Where Project_id = 'POWERWAVE' and carrier_Code = :lscarrier;
	
	If lsCarrierName = '' or isnull(lsCarrierName) Then lsCarrierName = lsCarrier
	
Else
	lsCarrierName = w_do.idw_Main.GetITemString(1,'carrier')
End If

//For each Packing Row
llRowCount = w_do.idw_Pack.RowCount()
For llRowPos = 1 to llRowCount
	
	llBandHeight = 1 /*We need to modify the column seperator heights to match variable size descriptions */
	
	lsSKU = w_do.idw_Pack.GEtITEmString(llRowPos,'sku')
	lsSupplier = w_do.idw_Pack.GEtITEmString(llRowPos,'supp_code')
	lsCarton = w_do.idw_Pack.GEtITEmString(llRowPos,'Carton_no')
	llLineItem = w_do.idw_Pack.GEtITEmNumber(llRowPos,'line_item_no')
	
	//If 3 char COO, convert to 2 char
	lsCOO = w_do.idw_Pack.GEtITEmString(llRowPos,'Country_of_Origin')
	lsCOO3 = lsCOO /* 12/07 - PCONKL - retrieve serial numbers against original*/
	
/*  dts 07/18/07 - Why are we converting? Can't find serial #s if converted...
- if we must convert, either look up serial #s first or use original COO in look-up*/
	If len(lsCOO) = 3 Then
		llFind = g.ids_Country.Find("Upper(iso_country_cd) = '" + upper(lsCOO) + "'",1,g.ids_Country.RowCOunt())
		If llFind > 0 Then
			lsCOO = g.ids_Country.getITemString(llFind,'designating_code')
		End If
	Else
		lsCOO = w_do.idw_Pack.GEtITEmString(llRowPos,'Country_of_Origin')
	End If

	llNewRow = ldpackprint.InsertRow(0)
	
	//Header fields
	ldpackprint.SetITem(llNewRow,'invoice_no', w_do.idw_Main.GetITemString(1,'invoice_no'))
	ldpackprint.SetITem(llNewRow,'do_no', w_do.idw_Main.GetITemString(1,'do_no'))
	ldpackprint.SetITem(llNewRow,'sales_order_no', w_do.idw_Main.GetITemString(1,'user_Field6')) /*powerwave Sales ORder NUmber -> User Field6*/
	ldpackprint.SetITem(llNewRow,'cust_order_No', w_do.idw_Main.GetITemString(1,'cust_order_no'))
	//ldpackprint.SetITem(llNewRow,'carrier', w_do.idw_Main.GetITemString(1,'carrier'))
	ldpackprint.SetITem(llNewRow,'carrier', lsCarrierName)
	ldpackprint.SetITem(llNewRow,'hawb', w_do.idw_Main.GetITemString(1,'awb_bol_no'))
	ldpackprint.SetITem(llNewRow,'mawb', w_do.idw_Main.GetITemString(1,'user_field2')) /*master AWB -> User Field 2*/
	ldpackprint.SetITem(llNewRow,'notify_party', lsNotify) /*Notify Party/Importer*/
	
	//01/08 - PCONKL - Ship From Address needs to come from Warehouse table
	If llwarehouseRow > 0 Then /*warehouse row exists*/
	
		ldpackprint.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
		
		// For Suzhou, users mayu need to override the first line of the SHip from - If UF 11 is present, use that instead of Warehouse Name
		If w_do.idw_Main.GetItemString(1,'User_Field11') > '' and w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
			ldpackprint.SetITem(llNewRow,'ship_from_name',w_do.idw_Main.GetItemString(1,'User_Field11'))
		End If
		
		ldpackprint.setitem(llNewRow,"ship_from_addr1",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
		ldpackprint.setitem(llNewRow,"ship_from_addr2",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
		ldpackprint.setitem(llNewRow,"ship_from_addr3",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
		ldpackprint.setitem(llNewRow,"ship_from_addr4",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
		
		//Format City/State/Zip
		lsCityStateZip = ""
		
		If g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') > "" Then
			lsCityStateZip = g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') + ", "
		End If
		
		If g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') > "" Then
			lsCityStateZip += g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') + " "
		End If
		
		If g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip') > "" Then
			lsCityStateZip += g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip')
		End If
		
		ldpackprint.setitem(llNewRow,"ship_from_addr5",lsCityStateZip)
		
		ldpackprint.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
			
	End If
	
	ldpackprint.SetITem(llNewRow,'gross_Weight', w_do.idw_Main.GetITemNumber(1,'weight')) 
	
	//Complete Date if completed or current date if not...
	If not isnull(w_do.idw_Main.GetITemDateTime(1,'complete_date')) Then
		ldpackprint.SetITem(llNewRow,'complete_Date', w_do.idw_Main.GetITemDateTime(1,'complete_date')) 
	Else
		ldpackprint.SetITem(llNewRow,'complete_Date',Today())
	End If
		
	//Customer Address -> Consignee
	ldpackprint.SetITem(llNewRow,'consignee_name',w_do.idw_Main.GetITemString(1,'cust_Name'))
	ldpackprint.SetITem(llNewRow,'consignee_addr1',w_do.idw_Main.GetITemString(1,'address_1'))
	ldpackprint.SetITem(llNewRow,'consignee_addr2',w_do.idw_Main.GetITemString(1,'address_2'))
	ldpackprint.SetITem(llNewRow,'consignee_addr3',w_do.idw_Main.GetITemString(1,'address_3'))
	ldpackprint.SetITem(llNewRow,'consignee_addr4',w_do.idw_Main.GetITemString(1,'address_4'))
		
	//City State Zip combined
	lsCityState = ""
	If w_do.idw_Main.GetITemString(1,'city') > "" Then
		lsCityState = w_do.idw_Main.GetITemString(1,'city') + ", "
	End If
	
	If w_do.idw_Main.GetITemString(1,'state') > "" Then
		lsCityState += w_do.idw_Main.GetITemString(1,'state') + " "
	End If
		
	If w_do.idw_Main.GetITemString(1,'zip') > "" Then
		lsCityState += w_do.idw_Main.GetITemString(1,'zip') 
	End If
		
	ldpackprint.SetITem(llNewRow,'consignee_city_state',lsCityState)
		
	//Contact + Phone NUmber in same field
	lsContact = ""
	If w_do.idw_Main.GetITemString(1,'contact_person') > "" Then
		lsContact = w_do.idw_Main.GetITemString(1,'contact_person') + " "
	End If
	
	If w_do.idw_Main.GetITemString(1,'tel') > "" Then
		lsContact += "tel: " + w_do.idw_Main.GetITemString(1,'tel') + " "
	End If
		
	ldpackprint.SetITem(llNewRow,'consignee_contact',lsContact)
		
	ldpackprint.SetITem(llNewRow,'consignee_country',w_do.idw_Main.GetITemString(1,'country'))
	
	If ldsBillToAddress.RowCount() > 0 Then
		
		ldpackprint.SetITem(llNewRow,'shipper_name',ldsBillToAddress.GetItemString(1,"name"))
		ldpackprint.SetITem(llNewRow,'shipper_addr1',ldsBillToAddress.GetItemString(1,"address_1"))
		ldpackprint.SetITem(llNewRow,'shipper_addr2',ldsBillToAddress.GetItemString(1,"address_2"))
		ldpackprint.SetITem(llNewRow,'shipper_addr3',ldsBillToAddress.GetItemString(1,"address_3"))
		ldpackprint.SetITem(llNewRow,'shipper_addr4',ldsBillToAddress.GetItemString(1,"address_4"))
		
		
		//City, Stae Zip in a single field
		If ldsBillToAddress.GetItemString(1,"city") > "" Then
			lsCityState = ldsBillToAddress.GetItemString(1,"City") + ", "
		End IF
	
		If ldsBillToAddress.GetItemString(1,"state") > "" Then
			lsCityState += ldsBillToAddress.GetItemString(1,"state")+ " "
		End If
	
		If ldsBillToAddress.GetItemString(1,"zip") > "" Then
			lsCityState += ldsBillToAddress.GetItemString(1,"zip")
		End If
	
		ldpackprint.SetITem(llNewRow,'shipper_city_state',lsCityState)

		//Contact + Phone NUmber in same field
		lsContact = ''
		If ldsBillToAddress.GetItemString(1,"contact_person") > "" Then
			lsContact = ldsBillToAddress.GetItemString(1,"contact_Person") + "   "
		End IF
	
		//Contact + Phone NUmber in same field
		If ldsBillToAddress.GetItemString(1,"tel") > "" Then
			lsContact += "tel: " + ldsBillToAddress.GetItemString(1,"tel") 
		End IF
	
		ldpackprint.SetITem(llNewRow,'shipper_contact',lsContact)
		
	End If /*Bill To Address exists*/
		
	//Packing level fields...
	ldpackprint.SetITem(llNewRow,'sku',lsSKU) /*probably overridden below by Legacy SKU if present on the DD UF4*/
	ldpackprint.SetITem(llNewRow,'line_item_No', llLineItem) 
	ldpackprint.SetITem(llNewRow,'carton_nbr', lsCarton)
	ldpackprint.SetITem(llNewRow,'qty', w_do.idw_Pack.GetITemNUmber(llRowPos,'quantity'))
	ldpackprint.SetITem(llNewRow,'net_weight', w_do.idw_Pack.GetITemNUmber(llRowPos,'weight_net'))
	ldpackprint.SetITem(llNewRow,'gross_weight', w_do.idw_Pack.GetITemNUmber(llRowPos,'weight_gross')) 
	
	If Pos(Upper(lsCoo),'XX') = 0  Then
		ldpackprint.SetITem(llNewRow,'coo', lsCOO)
	End If
	
	//Dimensions
	lsDim = String(w_do.idw_Pack.GetItemNUmber(lLRowPos,'Length')) + ' x ' + String(w_do.idw_Pack.GetItemNUmber(lLRowPos,'width')) + ' x ' + String(w_do.idw_Pack.GetItemNUmber(lLRowPos,'Height'))
	ldpackprint.SetITem(llNewRow,'dimensions',lsDim)
	
	//Description is Description + Plain Level Description (UF14) + Primary part (if differnet from Legacy SKU) + Customer SKU (UF1) + Serial Numbers + Line Item Level Notes
	lsDesc = ""
	
	Select Description, User_field14 into :lsDesc, :lsPlainDesc
	From ITem_Master
	Where Project_id = :gs_Project and sku = :lsSKU and supp_Code = :lsSupplier;
	
	If lsPlainDesc > "" Then
		lsDesc +="~r" + lsPlainDesc
		llBandHeight ++
	End If
	
	lLDetailFindRow = w_do.idw_Detail.Find("Line_item_No = " + String(llLineItem) + " and upper(sku) = '" + upper(lsSKU) + "'",1, w_do.idw_Detail.rowCount())
		
	//Get Cust SKU (UF1) and Legacy SKU (UF4) from Detail 
	If llDetailFindRow > 0 Then
		
		//BCR 21-FEB-2012: Comment thess next blocks out per Pete Conklin (PID L12P137)...Change PackList Request.
		
//		//If Primary SKU <> Legacy SKU, show primary in Description field (Legacy SKU will be in SKU field)
//		If w_do.Idw_detail.GetITemString(llDetailFindRow,'User_Field4') > "" Then
//			If  w_do.Idw_detail.GetITemString(llDetailFindRow,'User_Field4') <> lsSKU Then
//				lsDesc +="~r" + lsSKU
//				llBandHeight ++
//			End If
//		End If
//		
//		If w_do.Idw_detail.GetITemString(llDetailFindRow,'User_Field1') > "" Then
//			lsDesc += "~rCust SKU: " + w_do.Idw_detail.GetITemString(llDetailFindRow,'User_Field1')
//			llBandHeight ++
//		End If
		
//		If w_do.Idw_detail.GetITemString(llDetailFindRow,'User_Field4') > "" Then
//			ldpackprint.SetITem(llNewRow,'sku',w_do.Idw_detail.GetITemString(llDetailFindRow,'User_Field4')) /*override from primary sku if present*/
//		End If
		
		//Oracle Line Item from UF5
		If w_do.Idw_detail.GetITemString(llDetailFindRow,'User_Field5') > "" and isNumber(w_do.Idw_detail.GetITemString(llDetailFindRow,'User_Field5'))Then
			ldpackprint.SetITem(llNewRow,'oracle_line',Long(w_do.Idw_detail.GetITemString(llDetailFindRow,'User_Field5')))
		Else
			ldpackprint.SetITem(llNewRow,'oracle_line', llLineItem)
		End If
		
	End If
	
	//Line Level Notes...
	llSerialHeight = 0 /*used for calculating detail band height when printing serial numbers in band (notes printed in foirst row of detail for Nokis SUZ) */
	lsLineNotes = ""
	For llNotesPos = 1 to llNotesCount
		
		If ldsNotes.GetITemString(llNotesPos,'Note_type') = 'L' and ldsNotes.GetITemNumber(llNotesPos,'line_item_No') = llLineItem Then /*current Line */
		
			lsLineNotes += ldsNotes.GetITemString(llNotesPos,'Note_text') + "~r" 
			llBandHeight ++ 
			llSerialHeight ++
			
			If Len(ldsNotes.GetITemString(llNotesPos,'Note_text')) > 35 Then /* line will wrap, need to account in band height*/
				llBandHeight ++
				llSerialHeight ++
			End If
			
		End If
		
	Next
	
	If lsLineNotes > "" Then
		
		//For Nokia SUz, we will print in Detail band to accomodate serial numbers (need in detail band to allow for auto height)
		If ldpackprint.dataobject <> 'd_powerwave_packing_prt_nokia_suz' Then
			
			lsDesc += "~r~rNotes: " + lsLineNotes
			llBandHeight ++
			
		Else /*Nokia Suz */
			
			ldPAckPrint.SetITem(llNewRow,'line_notes',lsLineNotes)
			
			//Set NOtes LIteral
			If lsLineNOtes > "" Then
				ldPAckPrint.SetITem(llNewRow,'note_text',"Notes:")
			End If
			
		End If
		
	End If
	
	//Serial NUmbers...
	lsSerialNo = ''
	
	
	//Serial Numbers are being retrieved from Delivey_Serial_Detail
	llSerialCount = ldsSerial.Retrieve(lsdono, lsCarton, lsSKU, lsCOO3, llLineItem)

		
	// 12/07 - PCONKL - Nokia SUZ will load serial numbers as seperate rows so we can barcode them
	If ldpackprint.dataobject <> 'd_powerwave_packing_prt_nokia_suz' Then
			
		// 05/08 - PCONKL - DOn't show Serial Numbers for Suzhou warehouse
		If  w_do.idw_Main.GetITEmString(1,'wh_code') <> 'PWAVE-SUZ' Then
			
			//BCR 22-FEB-2012: L12P137 - KPE Change PackList Request xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
			//Determine if the SKU for the current Pack Row is a Parent Item... 
			If w_do.idw_pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and component_ind = 'Y'",1,w_do.idw_pick.RowCOunt()) > 0 Then
				//This is a Parent Item. Load up the Component details in datastore
				llComponentCount = ldsDeliveryBOM.Retrieve(gs_Project, lsdono, llLineItem, lsSKU)
				//Obtain Parent Qty 
				llParentQty = w_do.idw_Pack.GetITemNUmber(llRowPos,'quantity')
				
				FOR llComponentPos = 1 TO llComponentCount
					//Obtain Child SKU and Qty
					lsChildSKU = ldsDeliveryBOM.GetITemString(llComponentPos,'sku_child')
					llChildQty   = ldsDeliveryBOM.GetITemNUmber(llComponentPos,'child_qty')
					//Calculate Total Qty for this Component
					llTotalQty = llChildQty * llParentQty
					//Add Child SKU and Qty to Description
					lsDesc +="~r~r" + '- ' + lsChildSKU + ' / ' + string(llTotalQty) + ' PCS'
					llBandHeight ++
					//Obtain Child COO from Pick List
					ls_Find = "Upper(SKU) = '" + Upper(lsChildSKU) + "' and Line_Item_no =  " + String(llLineItem) /*Need line item in case child SKU is part of multiple parents on the order*/
					llTemp = w_do.idw_Pick.Find(ls_Find,1,w_do.idw_pick.RowCount())
					lsChildCOO = w_do.idw_pick.GetItemString(llTemp, 'country_of_origin')
					//Obtain Child Serial Numbers from Delivey_Serial_Detail
					llChildSerialCount = ldsChildSerial.Retrieve(lsdono, lsCarton, lsChildSKU, lsChildCOO, llLineItem)
					//Reset Serial No
					lsSerialNo = ''
					For llChildSerialPos = 1 to llChildSerialCount
						lsSerialNo += ', ' + ldsChildSerial.GetItemString(llChildSerialPos,'serial_no')
						If Mod(llChildSerialPos,2) = 0 Then /*2 serials per line - or 1 if > 19 characters*/
							llBandHeight ++ 
						elseif Len(ldsChildSerial.GetItemString(llChildSerialPos,'serial_no')) > 19 Then
							llBandHeight ++
						End IF
						
					NEXT//For each Serial No	
					
					If llChildserialCount = 1 then llBandHeight ++
		
					If lsSerialNo > "" Then
						
						lsSerialNo = Right(lsSerialNo,Len(lsSerialNo) - 1)
						lsDesc += "~r" + '- - -' + " Serial Nbrs: " + lsSerialNo
						llBandHeight ++
					
					End If
					
				NEXT//For each Child Component
						
			END IF
			
			//Reset Serial No
			lsSerialNo = ''
			//BCR End Modification xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
		
			For llSerialPos = 1 to llSerialCount
		
				lsSerialNo += ', ' + ldsSerial.GetItemString(llSerialPos,'serial_no')
				If Mod(llSerialPos,2) = 0 Then /*2 serials per line - or 1 if > 19 characters*/
					llBandHeight ++ 
				elseif Len(ldsSerial.GetItemString(llSerialPos,'serial_no')) > 19 Then
					llBandHeight ++
				End IF
		
			Next
	
			If llserialCount = 1 then llBandHeight ++
		
			If lsSerialNo > "" Then
				
				lsSerialNo = Right(lsSerialNo,Len(lsSerialNo) - 1)
				lsDesc += "~r~rSerial Nbrs: " + lsSerialNo
				llBandHeight ++
			
			End If
			
		End If /*Not Suzou*/
		
	End If /* Not NOkia Suz*/
			
	
	ldpackprint.SetITem(llNewRow,'description',lsDesc)
	
	//12/07 - PCONKL - For Nokia SUZ, each serial number is a seperated detail row so we can barcode them
	If ldpackprint.dataobject = 'd_powerwave_packing_prt_nokia_suz' Then
		
		For llSerialPos = 1 to llSerialCount
		
			If llSerialPos = 1 Then /*set in existing detail*/
			
				ldPackPrint.SetITem(llNewRow,'serial_barcode', '*' + ldsSerial.GetItemString(llSerialPos,'serial_no') + '*')
				ldPackPrint.SetITem(llNewRow,'serial_no', ldsSerial.GetItemString(llSerialPos,'serial_no'))
				
				//Need to calculate height for first row if notes are present*/
				ldPackPrint.SetITem(llNewRow,'serial_height',112 + (llSerialHeight * 50)) /* 112 for Serial NUmber and 50 for each note */
				
				//Set Serial LIteral
				ldPackPrint.SetITem(llNewRow,'serial_text',"S/N's:")
				
			Else /*insert new detail rows */
				
				ldPackPrint.RowsCopy(llNewRow,llNewRow,Primary!,ldPAckPrint,999999,Primary!)
				ldPAckPrint.SetITem(ldPAckPrint.RowCount(),'line_notes','') /*only want to print the notes once */
				ldPackPrint.SetITem(ldPAckPrint.RowCount(),'serial_barcode', '*' + ldsSerial.GetItemString(llSerialPos,'serial_no') + '*')
				ldPackPrint.SetITem(ldPAckPrint.RowCount(),'serial_no', ldsSerial.GetItemString(llSerialPos,'serial_no') )
				
				ldPackPrint.SetITem(ldPAckPrint.RowCount(),'serial_height',112) /* entire height for just serial number record */
				
				ldPackPrint.SetITem(ldPAckPrint.RowCount(),'serial_text',"") /* only show lieterals on first row*/
				ldPackPrint.SetITem(ldPAckPrint.RowCount(),'note_text',"") /* only show lieterals on first row*/
				
			End If
		
			llBandHeight += 2 /*Double height*/
			
		Next
		
	End If
	
	lLTotAlHeight += llBandHeight /*need to calc empty space at bottom of page to keep sumamry at bottom*/
	
	llBandHeight = 124 + ((llBandHeight - 1) * 50)
	ldpackprint.SetItem(llRowPos,'band_HEight',llBandHeight)
		
	//Either a Pallet or a carton...
	If lsCarton <> lsCartonSave Then
		
		If Pos(Upper(w_do.idw_Pack.GetITemString(llRowPos,'carton_type')),'PALLET') > 0 Then
			llPalletCount ++
		Else
			llCartonCount ++
		End If
		
	End If
	
	lsCartonSave = lsCarton
	
Next /*PAcking Row*/

//Add empty lines if necessary to drop summary to bottom
liEmptyRows = 0
If lLTotAlHeight < liRowsPerPage Then
	liEmptyRows = liRowsPerPage - lLTotAlHeight
ElseIf ldpackprint.RowCount() > liRowsPerPage Then
	liMod = Mod(lLTotAlHeight, liRowsPerPage)
	If liMod > 0 Then
		liEmptyRows = liRowsPerPage - liMod
	End IF
End If

If liEmptyRows > 0 Then
	For llRowPos = 1 to liEmptyRows
		ldpackprint.InsertRow(0)
	Next
End If


// 05/08 - PCONKL - Suzhou wants carton count to come from Other Info Tab
If  w_do.idw_Main.GetITEmString(1,'wh_code') = 'PWAVE-SUZ' Then
	ldPackPrint.Modify("carton_count_t.text = '" + String(w_do.idw_Other.GetItemNumber(1,'ctn_cnt')) + "'")
Else
	ldPackPrint.Modify("carton_count_t.text = '" + String(llCartonCount) + "'")
End If


ldPackPrint.Modify("pallet_count_t.text = '" + String(llPalletCount) + "'")

//Build Pallet Size Listing
lsCartonSave = ""
llRowCount = w_do.idw_Pack.RowCount()
For llRowPos = 1 to llRowCount
	
	lsCarton = w_do.idw_pack.GetITemString(llRowPos,'carton_no')
	
	If lsCarton <> lscartonSave Then
		
		// ??? What do we do with loose cartons ???
		// 05/08 - PCONKL - For Suzhou, we want to include all, not just Pallets
		If  w_do.idw_Main.GetITEmString(1,'wh_code') <> 'PWAVE-SUZ' and (isNull(w_do.idw_pack.GetITemString(llRowPos,'carton_type')) or Pos(Upper(w_do.idw_pack.GetITemString(llRowPos,'carton_type')),'PALLET') = 0) Then Continue
		
		lsDim = String(w_do.idw_Pack.GetItemNUmber(lLRowPos,'Length')) + ' x ' + String(w_do.idw_Pack.GetItemNUmber(lLRowPos,'width')) + ' x ' + String(w_do.idw_Pack.GetItemNUmber(lLRowPos,'Height'))
		
		If UpperBound(lsDimsArray) > 0 Then

			//look for an existing entry
			lbFound = False
			For llArrayPos = 1 to UpperBound(lsDimsArray)
				
				If lsDimsArray[llArrayPos] = lsDim Then
					llQtyArray[llArrayPos] ++
					lbFound = True
					Exit
				End If
				
			Next
			
			If Not lbFound Then
				llArrayCount ++
				lsDimsArray[llArrayCount] = lsDim
				llQtyArray[llARrayCount] = 1
			End IF
			
		Else
			
			llArrayCount ++
			lsDimsArray[llArrayCount] = lsDim
			llQtyArray[llARrayCount] = 1
			
		End If
			
	End If
	
	lscartonSave = lsCarton
	
Next

For llArrayPos = 1 to UpperBound(lsDimsArray)
	
	ldPackPrint.Modify("pallet_qty" + String(llArrayPos) + "_t.Text = '" + String(llQtyArray[llArrayPos]) + "'")
	ldPackPrint.Modify("pallet_dims" + String(llArrayPos) + "_t.Text = '" + lsDimsArray[llArrayPos] + "'")
	
Next

ldPackPrint.GroupCalc()

SetPointer(Arrow!)

OpenWithParm(w_dw_print_options,ldpackprint) 

Return 0
end function

public function integer uf_packprint_scitex ();
Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llPickPos, llPickCount,  lLDetailFindRow, llLineItem,	&
		llSerialPos, llSerialCount, llBandHeight, llTotalHeight, llordqty
String	lsWarehouse, lsSKU, lsSupplier, lsDONO, lsDesc
String	lsCarton, lsCartonSave, lsFind
DataStore	ldpackprint
Int	liRowsPerPAge, liEmptyRows, liMod


ldpackprint = Create Datastore
ldpackprint.dataobject ='d_scitex_packing_prt'


//Number of rows per page - we will want to insert enough rows on the last page so the sumamry is at the bottom
liRowsPerPage = 17 /* testing with standard - production on A4 in Europe (probably 20) */

//Warehouse (Shipper) info retreived in Warehouse DS
lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')
llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())



//For each Packing Row
llRowCount = w_do.idw_Pack.RowCount()
For llRowPos = 1 to llRowCount
	
//	llBandHeight = 1 /*We need to modify the column seperator heights to match variable size descriptions */
	
	lsSKU = w_do.idw_Pack.GEtITEmString(llRowPos,'sku')
	lsSupplier = w_do.idw_Pack.GEtITEmString(llRowPos,'supp_code')
	lsCarton = w_do.idw_Pack.GEtITEmString(llRowPos,'Carton_no')
//	lsCOO = w_do.idw_Pack.GEtITEmString(llRowPos,'Country_of_Origin')
	llLineItem = w_do.idw_Pack.GEtITEmNumber(llRowPos,'line_item_no')
	
	llNewRow = ldpackprint.InsertRow(0)
	
	//Set Shipper Info from Warehouse table
	If llwarehouseRow > 0 Then /*warehouse row exists*/
	
 		ldpackprint.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
		ldpackprint.SetITem(llNewRow,'ship_from_address1',g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
		ldpackprint.SetITem(llNewRow,'ship_from_address2',g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
		ldpackprint.SetITem(llNewRow,'ship_from_address3',g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
		ldpackprint.SetITem(llNewRow,'ship_from_address4',g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
		
		//City, State Zip in a single field
		If g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') > "" Then
			ldpackprint.SetITem(llNewRow,'ship_from_city',g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
		End IF
	
		If g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') > "" Then
			ldpackprint.SetITem(llNewRow,'ship_from_state',g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
		End If
	
		If g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip') > "" Then
			ldpackprint.SetITem(llNewRow,'ship_from_zip',g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
		End If
	
	End If /*warehouse exists*/
	
	//Header fields
	ldpackprint.SetITem(llNewRow,'cust_order_No', w_do.idw_Main.GetITemString(1,'cust_order_no'))
	ldpackprint.SetITem(llNewRow,'invoice_no', w_do.idw_Main.GetITemString(1,'invoice_no'))
	ldpackprint.SetITem(llNewRow,'user_field2', w_do.idw_Main.GetITemString(1,'user_field2')) /*master AWB -> User Field 2*/
	ldpackprint.SetITem(llNewRow,'carrier', w_do.idw_Main.GetITemString(1,'carrier'))
	ldpackprint.SetITem(llNewRow,'Agent_info', w_do.idw_Main.GetITemString(1,'agent_info'))
	ldpackprint.SetITem(llNewRow,'shipping_instructions', w_do.idw_Main.GetITemString(1,'shipping_instructions')) 
	ldpackprint.SetITem(llNewRow,'remark', w_do.idw_Main.GetITemString(1,'remark')) 
	
		
	//Customer Address -> Delivery
	ldpackprint.SetITem(llNewRow,'cust_name',w_do.idw_Main.GetITemString(1,'cust_Name'))
	ldpackprint.SetITem(llNewRow,'delivery_address1',w_do.idw_Main.GetITemString(1,'address_1'))
	ldpackprint.SetITem(llNewRow,'delivery_address2',w_do.idw_Main.GetITemString(1,'address_2'))
	ldpackprint.SetITem(llNewRow,'delivery_address3',w_do.idw_Main.GetITemString(1,'address_3'))
	ldpackprint.SetITem(llNewRow,'delivery_address4',w_do.idw_Main.GetITemString(1,'address_4'))
	ldpackprint.SetITem(llNewRow,'city',w_do.idw_Main.GetITemString(1,'city'))
	ldpackprint.SetITem(llNewRow,'delivery_state',w_do.idw_Main.GetITemString(1,'state'))
	ldpackprint.SetITem(llNewRow,'delivery_zip',w_do.idw_Main.GetITemString(1,'zip'))
	ldpackprint.SetITem(llNewRow,'country',w_do.idw_Main.GetITemString(1,'country'))
	
	//Packing level fields...
	ldpackprint.SetITem(llNewRow,'sku',lsSKU)
	ldpackprint.SetITem(llNewRow,'line_item_No', llLineItem)
	ldpackprint.SetITem(llNewRow,'carton_no', lsCarton)
	ldpackprint.SetITem(llNewRow,'picked_quantity', w_do.idw_Pack.GetITemNUmber(llRowPos,'quantity'))
	
	lsDesc = ""
	
	Select Description into :lsDesc
	From ITem_Master
	Where Project_id = :gs_Project and sku = :lsSKU and supp_Code = :lsSupplier;
	
	//Get Cust SKU from Detail (UF1)
	lLDetailFindRow = w_do.idw_Detail.Find("Line_item_No = " + String(llLineItem) + " and upper(sku) = '" + upper(lsSKU) + "' and upper(Supp_Code) = '" + Upper(lsSUpplier) + "'",1, w_do.idw_Detail.rowCount())
	If llDetailFindRow > 0 Then
		llordqty = w_do.idw_detail.getitemnumber(llDetailFindRow,"req_qty")
		ldpackprint.setitem(llNewRow,"ordered_quantity",w_do.idw_detail.getitemnumber(llDetailFindRow,"req_qty"))
		ldpackprint.SetITem(llNewRow,'ordered_uom', w_do.idw_detail.getitemstring(llDetailFindRow,"uom"))
		ldpackprint.SetITem(llNewRow,'picked_uom', w_do.idw_detail.getitemstring(llDetailFindRow,"uom"))//		llBandHeight ++
	End If
	
	ldpackprint.SetITem(llNewRow,'description',lsDesc)
	
	
Next /*PAcking Row*/

OpenWithParm(w_dw_print_options,ldpackprint) 

Return 0
end function

public function integer uf_packprint_netapp ();String		dwsyntax_str, lsSQL, presentation_str, lsErrText,  lsWHCode, lsSOM, lsSerialNo,	&
				lsSKU, lsSupplier, lsDesc, lsCityStateZip, lsdono, lsCartonSave, lsSubLine, lsSubItem, lsSubDesc, lsSubUOM, lsNoteText,	&
				lsPickFind, lsPackFind
Long			llLineITemNo, llRowCount, llRowPOs, llNewRow, llwarehouseRow, llNotesPos, llNotesCount, llSubQty, llPickFindRow, llPAckFindRow, &
				llBomFindRow, llSerialPos, llSerialCount
Dec			ldGrossWeight, ldNetWeight, ldVolume
Int			liCartonCount
Datastore	ldsNotes, ld_PackPrint, ldsBillToAddress, ldsBOM, ldsSerial


//No row means no Print (the data is coming from delivery Detail but we want to make sure the pack list is generated first)
llRowCount = w_do.idw_pack.rowcount()
If llRowCount = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

SetPointer(Hourglass!)

lsDONO = w_do.idw_main.getitemstring(1,"do_no")
lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")


ld_packprint = Create Datastore
ld_packprint.dataobject ='d_netapp_packing_prt'

w_main.SetMicroHelp("Retrieving Packing information...")

//Sort Order Detail by User Field 2 which is the SO line Number
w_do.Idw_Detail.SetSort("User_Field2 A")
w_do.idw_Detail.Sort()

//Notes
lsSQl = "Select note_type, Note_seq_No, Note_Text, Line_Item_No from Delivery_Notes Where do_no = '" + lsDONO + "'"
lsSql += " and note_type in ('OP', 'SN')"

ldsNotes = Create Datastore
presentation_str = "style(type=grid)"
dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsNotes.Create( dwsyntax_str, lsErrText)
ldsNotes.SetTransObject(SQLCA)
ldsNotes.Retrieve()
ldsNotes.SetSort("Note_type A, Note_Seq_No A")
ldsNotes.Sort()


//Bill To Address
ldsBillToAddress = Create DataStore
ldsBillToAddress.dataObject = 'd_do_address_alt'
ldsBillToAddress.SetTransObject(SQLCA)
ldsBillToAddress.Retrieve(lsdono, 'BT') /*Bill To Address*/

// Children components for Child Req Qty and Item Desc
ldsBOM = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select Line_Item_No, sku_child, child_qty, Description from Delivery_Bom, Item_MAster " 
lsSQL += " Where do_no = '" + lsDONO + "' and Delivery_Bom.Project_ID = Item_master.Project_ID and sku_child = sku and supp_code_Child = supp_code "

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsBOM.Create( dwsyntax_str, lsErrText)
ldsBOM.SetTransObject(SQLCA)
ldsBom.Retrieve()


//Retrieve Serial Numbers for Order - Will Filter for child SKU and Line below
ldsSerial = Create Datastore
presentation_str = "style(type=grid)"
lsSQL = "Select LIne_Item_No, SKU, Delivery_Serial_Detail.Serial_No as 'serial_no' from Delivery_Picking_Detail, Delivery_Serial_Detail "
lsSQL += " Where Delivery_Picking_Detail.do_no = '" + lsDONO + "' and delivery_Picking_Detail.id_no = Delivery_Serial_Detail.ID_NO "

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsSerial.Create( dwsyntax_str, lsErrText)
ldsSerial.SetTransObject(SQLCA)
ldsSerial.Retrieve()

llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWHCode) + "'",1,g.ids_project_warehouse.rowCount())


//For each detail row, generate the pack data
llRowCount = w_do.idw_detail.RowCount()
For llRowPOs = 1 to llRowCount
	
	w_main.SetMicroHelp("Printing Packing row " + String(llRowPOs) + " of " + String(llRowCount) + "...")
	
	llNewRow = ld_packprint.InsertRow(0)
	
	lsSKU = w_do.idw_detail.getitemstring(llRowPos,"sku")
	lsSupplier = w_do.idw_detail.getitemstring(llRowPos,"supp_code")
	llLineItemNo = w_do.idw_detail.getitemNumber(llRowPos,"Line_Item_No")
	
	//Header level fields
	
	//SO Should be in UF 6, If not, take it from the invoice (Which also has take appended*/
	If w_do.idw_main.getitemstring(1,"User_Field6") > "" Then
		ld_packprint.setitem(llNewRow,"order_nbr",w_do.idw_main.getitemstring(1,"User_Field6"))
	Else
		ld_packprint.setitem(llNewRow,"order_nbr",w_do.idw_main.getitemstring(1,"Invoice_no"))
	End If
	
	ld_packprint.setitem(llNewRow,'do_no', lsDONO)
	ld_packprint.setitem(llNewRow,"customer_po",w_do.idw_main.getitemstring(1,"cust_order_no"))
	ld_packprint.setitem(llNewRow,"way_bill",w_do.idw_main.getitemstring(1,"awb_bol_no"))
	ld_packprint.setitem(llNewRow,"ship_method",w_do.idw_main.getitemstring(1,"Carrier")) /* is this the right field*/
	ld_packprint.setitem(llNewRow,"freight_terms",w_do.idw_main.getitemstring(1,"freight_terms"))
	ld_packprint.setitem(llNewRow,"fob",w_do.idw_main.getitemstring(1,"user_Field8")) /*Incoterms = UF8 */
	ld_packprint.setitem(llNewRow,"order_Date",Date(w_do.idw_main.getitemDateTime(1,"ord_date")))
	
	
	//Set Shipper Info from Warehouse table
	If llwarehouseRow > 0 Then /*warehouse row exists*/
	
		ld_packprint.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
		ld_packprint.setitem(llNewRow,"ship_from_addr1",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
		ld_packprint.setitem(llNewRow,"ship_from_addr2",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
		ld_packprint.setitem(llNewRow,"ship_from_addr3",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
		ld_packprint.setitem(llNewRow,"ship_from_addr4",g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
		
		//Format City/State/Zip
		lsCityStateZip = ""
		
		If g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') > "" Then
			lsCityStateZip = g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') + ", "
		End If
		
		If g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') > "" Then
			lsCityStateZip += g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') + " "
		End If
		
		If g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip') > "" Then
			lsCityStateZip += g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip')
		End If
		
		ld_packprint.setitem(llNewRow,"ship_from_addr5",lsCityStateZip)
		
		ld_packprint.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
			
	End If
	
	
	ld_packprint.setitem(llNewRow,"ship_to_name",w_do.idw_main.getitemstring(1,"cust_name"))
	ld_packprint.setitem(llNewRow,"ship_to_addr1",w_do.idw_main.getitemstring(1,"address_1"))
	ld_packprint.setitem(llNewRow,"ship_to_addr2",w_do.idw_main.getitemstring(1,"address_2"))
	ld_packprint.setitem(llNewRow,"ship_to_addr3",w_do.idw_main.getitemstring(1,"address_3"))
	ld_packprint.setitem(llNewRow,"ship_to_addr4",w_do.idw_main.getitemstring(1,"address_4"))
	
	//rollup City/State/Zip
	lsCityStateZip = ""
		
	If w_do.idw_main.getitemstring(1,"city") > "" Then
		lsCityStateZip = w_do.idw_main.getitemstring(1,"city") + ", "
	End If
		
	If w_do.idw_main.getitemstring(1,"state")> "" Then
		lsCityStateZip += w_do.idw_main.getitemstring(1,"state") + " "
	End If
		
	If w_do.idw_main.getitemstring(1,"zip") > "" Then
		lsCityStateZip += w_do.idw_main.getitemstring(1,"zip")
	End If
		
	ld_packprint.setitem(llNewRow,"ship_to_addr5",lsCityStateZip)
	
	ld_packprint.setitem(llNewRow,"ship_to_country",w_do.idw_main.getitemstring(1,"country"))

	
	//Bill TO Addr
	If ldsBillToAddress.RowCount() > 0 Then
		
		ld_packprint.setitem(llNewRow,"Bill_to_name",ldsBillToAddress.getitemstring(1,"name"))
		ld_packprint.setitem(llNewRow,"Bill_to_Addr1",ldsBillToAddress.getitemstring(1,"address_1"))
		ld_packprint.setitem(llNewRow,"Bill_to_Addr2",ldsBillToAddress.getitemstring(1,"address_2"))
		ld_packprint.setitem(llNewRow,"Bill_to_Addr3",ldsBillToAddress.getitemstring(1,"address_3"))
		ld_packprint.setitem(llNewRow,"Bill_to_Addr4",ldsBillToAddress.getitemstring(1,"address_4"))
		
		//rollup City/State/Zip
		lsCityStateZip = ""
		
		If ldsBillToAddress.getitemstring(1,"city") > "" Then
			lsCityStateZip = ldsBillToAddress.getitemstring(1,"city") + ", "
		End If
		
		If ldsBillToAddress.getitemstring(1,"state") > "" Then
			lsCityStateZip += ldsBillToAddress.getitemstring(1,"state")+ " "
		End If
		
		If ldsBillToAddress.getitemstring(1,"zip")> "" Then
			lsCityStateZip += ldsBillToAddress.getitemstring(1,"zip")
		End If
		
		ld_packprint.setitem(llNewRow,"bill_to_addr5",lsCityStateZip)
			
	End If
		
	//Detail Level Fields
	
	ld_packprint.setitem(llNewRow,"Detail_Line_item_no",llLineITemNo) /*Grouping on SIMS line item (extra space between detail records*/
	ld_packprint.setitem(llNewRow,"Line_item_no",w_do.idw_detail.getitemstring(llRowPos,"user_Field2")) /*NetApps SO Line from user field 2*/
	ld_packprint.setitem(llNewRow,"sku",lsSKU)
	ld_packprint.setitem(llNewRow,"uom",w_do.idw_detail.getitemstring(llRowPos,"uom"))
	ld_packprint.setitem(llNewRow,"line_Type",w_do.idw_detail.getitemstring(llRowPos,"User_Field1")) /*want serial label to say 'Master ID' if ATO */
	ld_packprint.setitem(llNewRow,"req_qty",w_do.idw_detail.getitemNumber(llRowPos,"req_qty"))
	ld_packprint.setitem(llNewRow,"ship_qty",w_do.idw_detail.getitemNumber(llRowPos,"alloc_qty"))
	
	//We need the Decription from Item MAster
	Select Description into :lsDesc
	From Item_Master
	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
	
	ld_packprint.setitem(llNewRow,"description",lsDesc)
	
	//Add any serial numbers from serial table (this would be only for Pickable LInes - no children)
	lsSerialNo = ""
			
	//Filter for Line/SKU
	ldsSerial.SetFilter("Line_Item_No = " + String(llLineItemNo) + " and sku = '" + lsSKU + "'")
	ldsSerial.Filter()
	llSerialCOunt = ldsSerial.RowCount()
			
	If lLSerialCount > 0 Then
			
		For llSerialPos = 1 to lLSerialCount
			lsSerialNo += ldsSerial.GetITemString(llSerialPOs,'serial_No') + ", "
		Next/*Next serial*/
				
		ld_packPrint.SetITem(llNewRow, 'serial_no',Left(lsSerialNo,Len(lsSerialNo) - 2)) /*strip off last comma*/
		
	End If /*Serials exist*/
	
	//If we have any OPtion level Notes (Non pickable children lines), add a new detail row and parse detail level info from notes record
	//Add any OPtion Level non pickable children and serial numbers - process in Order of how received so Serial numbers are linked to the proper OPtion
	
	ldsNotes.SetFilter("Line_Item_No = " + String(llLineItemNo))
	ldsNotes.Filter()
	llNotesCount = ldsNotes.RowCount()
	ldsNOtes.SetSort("Note_seq_No A")
	ldsNotes.Sort()
	
	If llNOtesCount > 0 Then
		
		lsSerialNo = ""
		
		For llNotesPos = 1 to llNotesCount
						
			If Upper(ldsNOtes.GetITEmSTring(llNotesPos,'Note_type')) = 'OP' Then /*Option */
				
				//IF there are any serial NUmbers for the previous line, print them before we start the next subline
				If lsSerialNo > "" Then
					ld_packPrint.SetITem(llNewRow, 'serial_no',Left(lsSerialNo,Len(lsSerialNo) - 2)) /*strip off last comma*/
				End If
				
				lsSerialNo = ""
			
				lsNoteText = ldsNotes.GeTItemString(llNotesPos,'Note_Text')
				If Pos(lsNoteText,"~~") = 0 Then Continue
			
				//Subline
				If Left(lsNoteText,2) = "~~~~" Then /* No Subline*/
					lsSubline = ""
					lsNoteText = Mid(lsNOteText,3,999)
				Else
					lsSubLine = Left(lsNoteText, Pos(lsNoteText,"~~~~") - 1) /*~~ = ~, ~~~~ = ~~ */
					lsNoteText = Mid(lsNoteText,Pos(lsNoteText,"~~~~") + 2,999)
				End If
			
				//Sub Item
				If Left(lsNoteText,2) = "~~~~" Then /* No desc*/
					lsSubItem = ""
					lsNoteText = Mid(lsNOteText,3,999)
				Else
					lsSubItem = Left(lsNoteText, Pos(lsNoteText,"~~~~") - 1)
					lsNoteText = Mid(lsNoteText,Pos(lsNoteText,"~~~~") + 2,999)
				End If
			
				//Sub Desc 
				If Left(lsNoteText,2) = "~~~~" Then /* No desc*/
					lsSubDesc = ""
					lsNoteText = Mid(lsNOteText,3,999)
				Else
					lsSubDesc = Left(lsNoteText, Pos(lsNoteText,"~~~~") - 1) 
					lsNoteText = Mid(lsNoteText,Pos(lsNoteText,"~~~~") + 2,999)
				End If
			
				//Sub Qty
				If Left(lsNoteText,2) = "~~~~" Then /* No Qty*/
					llSubQty = 0
					lsNoteText = Mid(lsNOteText,3,999)
				Else
					llSubQty = Long(Left(lsNoteText, Pos(lsNoteText,"~~~~") - 1))
					lsNoteText = Mid(lsNoteText,Pos(lsNoteText,"~~~~") + 2,999)
				End If
			
				//Sub UOM
				lsSubUom = lsNoteText
			
			
				//Add a new packing row for the sub item info - Copy parent row
				ld_packPrint.RowsCopy(llNewRow,llNewRow,Primary!,ld_packPrint,999999,Primary!)
				lLNEwRow = ld_PAckPrint.RowCount()
			
				ld_packprint.setitem(llNewRow,"serial_no","")
				ld_packprint.setitem(llNewRow,"line_Type","")
				//ld_packprint.setitem(llNewRow,"Line_item_no",lsSubLIne) /* 07/07 per Keith Owens - don't show sub line number */
				ld_packprint.setitem(llNewRow,"sku",lsSubItem)
				ld_packprint.setitem(llNewRow,"Description",lsSubDesc)
				ld_packprint.setitem(llNewRow,"uom",lsSubUOM)
				ld_packprint.setitem(llNewRow,"req_qty",llSubQty)
				ld_packprint.setitem(llNewRow,"ship_qty",llSubQty)
				
			Elseif ldsNotes.GetITEmString(llNotesPos,'Note_Type') = 'SN' Then /* Serial NUmber */
			
				//Append all serial numbers for this subline. We will either print when the subline changes or after all notes have been prcessed for the line
				lsSerialNo += 	ldsNotes.GeTItemString(llNotesPos,'Note_Text') + ", "
				
			End If /*Note Type*/
			
		Next /*Note REcord  */
	
	End If /*Notes Exist*/
		
	//IF there are any serial NUmbers for the Last line, print them before we start the next subline
	If lsSerialNo > "" Then
		ld_packPrint.SetITem(llNewRow, 'serial_no',Left(lsSerialNo,Len(lsSerialNo) - 2)) /*strip off last comma*/
	End If
		
	
	//Add any pickable children items if this is a parent - This should be exclusive from being printed as notes above
	lsPickFind = "Line_Item_no = " + String(llLineItemNo) + " and sku_parent <> sku"
	llPickFindRow = w_do.idw_Pick.Find(lsPickFind,1,w_do.idw_Pick.RowCount())
	Do While llPickFindRow > 0
		
		//We need to roll up to a single child (might have been picked from multiple locs, inv types, etc.)
		lsPAckFind = "line_item_no = '" + w_do.idw_detail.getitemstring(llRowPos,"user_Field2") 
		lsPAckFind += "' and Upper(sku) = '" + Upper(w_do.idw_Pick.GetITEmString(llPickFindRow,'sku')) + "'"
		llPackFindRow = ld_PackPrint.Find(lsPAckFind,1,ld_packPrint.RowCount())
		
		If llPAckFindRow > 0 Then /*add Qty*/
		
			ld_packPrint.SetITem(llPAckFindRow,'ship_qty',ld_PackPrint.GetITemNUmber(llPackFindRow,'ship_qty') + w_do.idw_Pick.GetITemNUmber(llPickFindRow,'quantity'))
			
		Else /*Add a new row for the child */
			
			ld_packPrint.RowsCopy(llNewRow,llNewRow,Primary!,ld_packPrint,999999,Primary!)
			llNewRow = ld_packPrint.RowCount()
			
			ld_packprint.setitem(llNewRow,"serial_no","")
			ld_packprint.setitem(llNewRow,"Line_item_no",w_do.idw_detail.getitemstring(llRowPos,"user_Field2"))
			ld_packprint.setitem(llNewRow,"sku",w_do.idw_pick.GetITemString(llPickFindRow,'sku'))
			ld_packprint.setitem(llNewRow,"uom",w_do.idw_detail.getitemstring(llRowPos,"UOM"))
			ld_packprint.setitem(llNewRow,"ship_qty",w_do.idw_Pick.GetITemNUmber(llPickFindRow,'quantity'))
			
			//Req Qty and Desc from Delivery BOM DS
			llBomFindRow = ldsBom.Find("Line_Item_no = " + String(llLineItemNo) + " and sku_child = '" + w_do.idw_pick.GetITemString(llPickFindRow,'sku') + "'",1,ldsBom.RowCount())
			If llBomFindRow > 0 Then
				ld_packprint.setitem(llNewRow,"req_qty",ldsBom.GetITemNumber(llBomFindRow,'child_Qty'))
				ld_packprint.setitem(llNewRow,"Description",ldsBom.GetITemString(llBomFindRow,'Description'))
			Else
				ld_packprint.setitem(llNewRow,"req_qty",0)
				ld_packprint.setitem(llNewRow,"Description","")
			End If
						
			//TODO - add serial numbers for child */
			lsSerialNo = ""
			
			//Filter for Line/SKU
			ldsSerial.SetFilter("Line_Item_No = " + String(llLineItemNo) + " and sku = '" + w_do.idw_pick.GetITemString(llPickFindRow,'sku') + "'")
			ldsSerial.Filter()
			llSerialCOunt = ldsSerial.RowCount()
			
			If lLSerialCount > 0 Then
				
				For llSerialPos = 1 to lLSerialCount
					lsSerialNo += ldsSerial.GetITemString(llSerialPOs,'serial_No') + ", "
				Next/*Next serial*/
				
				ld_packPrint.SetITem(llNewRow, 'serial_no',Left(lsSerialNo,Len(lsSerialNo) - 2))
				
			End If /*Serials exist*/
			
		End If /*new/Updated pack row */
		
		//Find next child Picking row
		If llPickFindRow = w_do.idw_pick.RowCount() Then
			llPickFindRow = 0
		Else
			llPickFindRow ++
			llPickFindRow = w_do.idw_Pick.Find(lsPickFind,llPickFindRow,w_do.idw_Pick.RowCount())
		End If
		
	Loop /*Next child Picking record for parent*/
	
Next /*Detail row*/

//Resort the detail tab back to default
w_do.Idw_Detail.SetSort("Line_Item_No A, SKU A")
w_do.idw_Detail.Sort()

//Add any Shipping and PAcking Instructions
ld_packPrint.Modify("shipping_ins_t.text = '" + w_do.idw_Main.GetITEmString(1,'shipping_instructions') + "'")
ld_packPrint.Modify("pack_ins_t.text = '" + w_do.idw_Main.GetITEmString(1,'packlist_notes') + "'")

//Set Gross Wt, Net Wt, volume and carton count
llRowCount = w_do.idw_Pack.RowCount()
For llRowPOs = 1 to llRowCount

	ldNetWeight += (w_do.idw_Pack.GetITemNumber(lLRowPOs,'weight_net') * w_do.idw_Pack.GetITemNumber(lLRowPOs,'quantity'))
	
	If w_do.idw_Pack.GetITemString(lLRowPOs,'carton_no') <> lscartonSave Then
		
		liCartonCount ++
		
		If w_do.idw_Pack.GetITemNumber(lLRowPOs,'weight_gross') > 0 and not isnull(w_do.idw_Pack.GetITemNumber(lLRowPOs,'weight_gross')) Then
			ldGrossWeight += w_do.idw_Pack.GetITemNumber(lLRowPOs,'weight_gross')
		End If
		
		If w_do.idw_Pack.GetITemNumber(lLRowPOs,'length') > 0 and w_do.idw_Pack.GetITemNumber(lLRowPOs,'width') > 0 and w_do.idw_Pack.GetITemNumber(lLRowPOs,'height') > 0 Then
			ldVolume += (w_do.idw_Pack.GetITemNumber(lLRowPOs,'length') * w_do.idw_Pack.GetITemNumber(lLRowPOs,'width') * w_do.idw_Pack.GetITemNumber(lLRowPOs,'height'))
		End If
		
	End If

	lsCartonSave = w_do.idw_Pack.GetITemString(lLRowPOs,'carton_no')

Next /*PAcking Row */

// Carton Count may also be represented in Delivery Picking
// Box Count is entered in po_no2. A Single Line ITem may be a qty of 1 (or more) but have multiple cartons that need to be included in the total here 
// (but can't be included as seperate cartons on the PAcking List since a qty of 1 can't be split across multiple cartons 
llRowCount = w_do.idw_pick.RowCount()
For llRowPOs = 1 to llRowCount
	
	If isnumber(w_do.idw_Pick.GetITemString(llRowPOs,'po_no2')) Then
		liCartonCount += Long(w_do.idw_Pick.GetITemString(llRowPOs,'po_no2')) - 1 /*first carton is already counted in Packing Count */
	End If
	
Next /*Picking Row */


If w_do.idw_Pack.GetITemString(1,'standard_of_measure') = 'E' Then
	lsSOM = ' LB'
Else
	lsSOM = ' KG'
End If

ld_packPrint.Modify("gross_Weight_t.text = '" + String(ldGrossWeight,"#########.00") + lsSOM + "'")
ld_packPrint.Modify("net_Weight_t.text = '" + String(ldNetWeight,"#########.00") + lsSOM +  "'")
ld_packPrint.Modify("volume_t.text = '" + String(ldVolume,"#########.00") + "'")
ld_packPrint.Modify("total_cartons_t.text = '" + String(liCartonCount,"########0") + "'")

OpenWithParm(w_dw_print_options,ld_packprint) 

REturn 0
end function

public function integer uf_packprint_sika ();String		dwsyntax_str, lsSQL, presentation_str, lsErrText,  lsWHCode, lsSOM, &
				lsSKU, lsSupplier, lsDesc, lsCityStateZip, lsdono, lsCartonSave, lsSubLine, lsSubItem, lsSubDesc, lsSubUOM, lsNoteText,	&
				lsPickFind, lsPackFind
Long			llLineItemNo, llRowCount, llRowPOs, llNewRow, llwarehouseRow, llNotesPos, llNotesCount, llSubQty, llPickFindRow, llPackFindRow, &
				llBomFindRow, llTotalPieces
Dec			ldGrossWeight, ldNetWeight, ldVolume, ldAllocQty, ldPieces_Per_Unit
Int			liCartonCount, liMaxLines
Datastore	ldsNotes, ld_PackPrint, ldsBillToAddress, ldsBOM
string lsTemp, lsCarrier, lsInvoice, lsPieces_Per_Unit, lsWeight, lsPrinter

int liNotes, liFind, i, liLastSpace
string lsNotes, lsNote, lsNotes2, lsBorder

//No row means no Print (the data is coming from delivery Detail but we want to make sure the pack list is generated first)
llRowCount = w_do.idw_pack.rowcount()
If llRowCount = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

SetPointer(Hourglass!)

lsDONO = w_do.idw_main.GetItemstring(1,"do_no")
lsWHCode = w_do.idw_main.GetItemstring(1,"wh_code")

ld_packprint = Create Datastore
ld_packprint.dataobject ='d_sika_packing_prt'

w_main.SetMicroHelp("Retrieving Packing information...")

// Children components for Child Req Qty and Item Desc
ldsBOM = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select Line_Item_No, sku_child, child_qty, Description from Delivery_Bom, Item_Master " 
lsSQL += " Where do_no = '" + lsDONO + "' and Delivery_Bom.Project_ID = Item_master.Project_ID and sku_child = sku and supp_code_Child = supp_code "

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsBOM.Create( dwsyntax_str, lsErrText)
ldsBOM.SetTransObject(SQLCA)
ldsBom.Retrieve()

llWarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWHCode) + "'",1,g.ids_project_warehouse.rowCount())

/* grab all of the Packlist notes for this order...
   - Notes can be associated to a line, or to the Order (line_item_no = 0)
   - Note Types: PL-Packlist, PB-Both Packlist and BOL */
ldsNotes = Create Datastore
lsSQl = "Select line_item_no, note_text from delivery_notes " 
lsSQL += " Where do_no = '" + lsDONO + "' and note_type in ('PL', 'PB')" 
dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsNotes.Create(dwsyntax_str, lsErrText)
ldsNotes.SetTransObject(SQLCA)
liNotes = ldsNotes.Retrieve()

//For each detail row, generate the pack data
llRowCount = w_do.idw_detail.RowCount()
lsBorder = '     **********************************************************************'
For llRowPos = 1 to llRowCount
	w_main.SetMicroHelp("Printing Packing row " + String(llRowPOs) + " of " + String(llRowCount) + "...")
	llNewRow = ld_packprint.InsertRow(0)
	lsSKU = w_do.idw_detail.GetItemstring(llRowPos,"sku")
	lsSupplier = w_do.idw_detail.GetItemstring(llRowPos,"supp_code")
	
	//Header level fields...
/* dts - (commented out)
	//SO Should be in UF 6, If not, take it from the invoice (Which also has take appended /
	If w_do.idw_main.GetItemstring(1,"User_Field6") > "" Then
		ld_packprint.setitem(llNewRow,"order_nbr",w_do.idw_main.GetItemstring(1,"User_Field6"))
	Else
		ld_packprint.setitem(llNewRow,"order_nbr",w_do.idw_main.GetItemstring(1,"Invoice_no"))
	End If
*/
	ld_packprint.SetItem(llNewRow,"pro_number", w_do.idw_main.GetItemString(1, "User_Field6"))
	// 12-character Invoice_No is comprised of Order no (1st 6 chars) and Picker No (chars 7-12)
	lsInvoice = w_do.idw_main.GetItemString(1, "invoice_no")
	ld_packprint.setitem(llNewRow,"order_nbr", left(lsInvoice, 6))
	ld_packprint.SetItem(llNewRow,"sika_order", left(lsInvoice, 6))
	ld_packprint.SetItem(llNewRow,"picker_number", right(lsInvoice, 6))
	ld_packprint.setitem(llNewRow,'do_no', lsDONO)
	ld_packprint.setitem(llNewRow,"customer_po",w_do.idw_main.GetItemstring(1,"cust_order_no"))
	ld_packprint.setitem(llNewRow,"freight_terms",w_do.idw_main.GetItemstring(1,"freight_terms"))
	ld_packprint.setitem(llNewRow,"order_Date",Date(w_do.idw_main.GetItemDateTime(1,"ord_date")))
	//Complete Date if completed or Schedule date if not...
	If not IsNull(w_do.idw_Main.GetItemDateTime(1, "complete_date")) Then
		ld_packprint.SetItem(llNewRow, "ship_Date", Date(w_do.idw_main.GetItemDateTime(1, "complete_date")))
	Else
		ld_packprint.SetItem(llNewRow, "ship_Date", Date(w_do.idw_main.GetItemDateTime(1, "Schedule_date")))
		//ldpackprint.SetITem(llNewRow,'complete_Date',Today())
	End If
	
	//ld_packprint.setitem(llNewRow,"carrier",w_do.idw_other.GetItemString(1,'carrier'))
	//look up carrier name based on DM.Carrier
	lsTemp = w_do.idw_other.GetItemString(1,'carrier')
	select carrier_name into :lsCarrier
	from Carrier_Master
	where project_id = 'SIKA'
	and carrier_code = :lsTemp;
	if isnull(lsCarrier) or lsCarrier = '' then lsCarrier = lsTemp
	ld_packprint.setitem(llNewRow, "carrier", lsCarrier)
	
	//Set Shipper Info from Warehouse table
	If llwarehouseRow > 0 Then /*warehouse row exists*/
		ld_packprint.SetItem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetItemString(llWarehouseRow,'wh_name'))
		ld_packprint.setitem(llNewRow,"ship_from_addr1",g.ids_project_warehouse.GetItemString(llWarehouseRow,'address_1'))
		ld_packprint.setitem(llNewRow,"ship_from_addr2",g.ids_project_warehouse.GetItemString(llWarehouseRow,'address_2'))
		ld_packprint.setitem(llNewRow,"ship_from_addr3",g.ids_project_warehouse.GetItemString(llWarehouseRow,'address_3'))
		ld_packprint.setitem(llNewRow,"ship_from_addr4",g.ids_project_warehouse.GetItemString(llWarehouseRow,'address_4'))
		//Format City/State/Zip
		lsCityStateZip = ""
		If g.ids_project_warehouse.GetItemString(llWarehouseRow,'city') > "" Then
			lsCityStateZip = g.ids_project_warehouse.GetItemString(llWarehouseRow,'city') + ", "
		End If
		If g.ids_project_warehouse.GetItemString(llWarehouseRow,'state') > "" Then
			lsCityStateZip += g.ids_project_warehouse.GetItemString(llWarehouseRow,'state') + " "
		End If
		If g.ids_project_warehouse.GetItemString(llWarehouseRow,'zip') > "" Then
			lsCityStateZip += g.ids_project_warehouse.GetItemString(llWarehouseRow,'zip')
		End If
		ld_packprint.setitem(llNewRow,"ship_from_addr5",lsCityStateZip)
		ld_packprint.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetItemString(llWarehouseRow,'country'))
	End If

	ld_packprint.setitem(llNewRow,"ship_to_name", w_do.idw_main.GetItemstring(1, "cust_name"))
	ld_packprint.setitem(llNewRow,"ship_to_addr1",w_do.idw_main.GetItemstring(1,"address_1"))
	ld_packprint.setitem(llNewRow,"ship_to_addr2",w_do.idw_main.GetItemstring(1,"address_2"))
	ld_packprint.setitem(llNewRow,"ship_to_addr3",w_do.idw_main.GetItemstring(1,"address_3"))
	ld_packprint.setitem(llNewRow,"ship_to_addr4",w_do.idw_main.GetItemstring(1,"address_4"))
	//rollup City/State/Zip
	lsCityStateZip = ""
	If w_do.idw_main.GetItemstring(1,"city") > "" Then
		lsCityStateZip = w_do.idw_main.GetItemstring(1,"city") + ", "
	End If
	If w_do.idw_main.GetItemstring(1,"state")> "" Then
		lsCityStateZip += w_do.idw_main.GetItemstring(1,"state") + " "
	End If
	If w_do.idw_main.GetItemstring(1,"zip") > "" Then
		lsCityStateZip += w_do.idw_main.GetItemstring(1,"zip")
	End If
	ld_packprint.setitem(llNewRow,"ship_to_addr5",lsCityStateZip)
	ld_packprint.setitem(llNewRow,"ship_to_country",w_do.idw_main.GetItemstring(1,"country"))
	
	//Bill TO Addr
//	If ldsBillToAddress.RowCount() > 0 Then
//		
//		ld_packprint.setitem(llNewRow,"Bill_to_name",ldsBillToAddress.GetItemstring(1,"name"))
//		ld_packprint.setitem(llNewRow,"Bill_to_Addr1",ldsBillToAddress.GetItemstring(1,"address_1"))
//		ld_packprint.setitem(llNewRow,"Bill_to_Addr2",ldsBillToAddress.GetItemstring(1,"address_2"))
//		ld_packprint.setitem(llNewRow,"Bill_to_Addr3",ldsBillToAddress.GetItemstring(1,"address_3"))
//		ld_packprint.setitem(llNewRow,"Bill_to_Addr4",ldsBillToAddress.GetItemstring(1,"address_4"))
//		
//		//rollup City/State/Zip
//		lsCityStateZip = ""
//		
//		If ldsBillToAddress.GetItemstring(1,"city") > "" Then
//			lsCityStateZip = ldsBillToAddress.GetItemstring(1,"city") + ", "
//		End If
//		
//		If ldsBillToAddress.GetItemstring(1,"state") > "" Then
//			lsCityStateZip += ldsBillToAddress.GetItemstring(1,"state")+ " "
//		End If
//		
//		If ldsBillToAddress.GetItemstring(1,"zip")> "" Then
//			lsCityStateZip += ldsBillToAddress.GetItemstring(1,"zip")
//		End If
//		
//		ld_packprint.setitem(llNewRow,"bill_to_addr5",lsCityStateZip)
//			
//	End If
		
	//Detail Level Fields...
	ld_packprint.setitem(llNewRow,"Detail_Line_item_no",llLineItemNo) /*Grouping on SIMS line item (extra space between detail records*/
	ld_packprint.setitem(llNewRow,"Line_item_no",w_do.idw_detail.GetItemNumber(llRowPos,"Line_Item_no")) 
	ld_packprint.setitem(llNewRow,"sku",lsSKU)
	ld_packprint.setitem(llNewRow,"uom",w_do.idw_detail.GetItemstring(llRowPos,"uom"))
	ld_packprint.setitem(llNewRow,"cust_sku",w_do.idw_detail.GetItemstring(llRowPos,"user_field3"))
	ld_packprint.setitem(llNewRow,"upc_code",w_do.idw_detail.GetItemstring(llRowPos,"user_field4"))

	//We need the Decription from Item Master
	//Select Description into :lsDesc
	//From Item_Master
	//Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
//	ld_packprint.setitem(llNewRow,"line_Type",w_do.idw_detail.GetItemstring(llRowPos,"User_Field1")) /*want serial label to say 'Master ID' if ATO */

// Sika has a Stock UOM and a 'Units per StockUOM'. They order/ship based on stock uom but also show total pieces on P/L...
	ldAllocQty = w_do.idw_detail.GetItemNumber(llRowPos, "alloc_qty")
	select description, weight_1, user_field1 
	into :lsDesc, :lsWeight, :lsPieces_Per_Unit
	from Item_Master
	where project_id = 'SIKA'
	and sku = :lsSKU and supp_code = :lsSupplier;
	if isnumber(lsPieces_Per_Unit) then
		if lsPieces_Per_Unit = '0' then 
			ldPieces_Per_Unit = 1
		else
			ldPieces_Per_Unit = dec(lsPieces_Per_Unit)
		end if
	else
		ldPieces_Per_Unit = 1
	end if
	
	ld_packprint.setitem(llNewRow, "description",lsDesc)
	ld_packprint.setitem(llNewRow, "Cartons_Shipped", ldAllocQty)
	ld_packprint.setitem(llNewRow, "req_qty", ldAllocQty * ldPieces_Per_Unit)
	ld_packprint.setitem(llNewRow, "ship_qty", ldAllocQty * ldPieces_Per_Unit)
	ld_packprint.setitem(llNewRow, "unit_weight", dec(lsWeight))
	
	llLineItemNo = w_do.idw_detail.GetItemNumber(llRowPos,"Line_Item_no")
	
	//Add any pickable children items if this is a parent - This should be exclusive from being printed as notes above
	lsPickFind = "Line_Item_no = " + String(llLineItemNo) + " and sku = '" + lsSKU + "'"

	llPickFindRow = w_do.idw_Pick.Find(lsPickFind,1,w_do.idw_Pick.RowCount())
	
	Do While llPickFindRow > 0
//		ld_packPrint.SetItem(llPackFindRow,'ship_qty',ld_PackPrint.GetItemNumber(llPackFindRow,'ship_qty') + w_do.idw_Pick.GetItemNUmber(llPickFindRow,'quantity'))
		//ld_packprint.setitem(llNewRow,"l_code",w_do.idw_pick.GetItemString(llPickFindRow,'l_code'))
		ld_packprint.SetItem(llNewRow,"l_code", "LO")
		ld_packprint.setitem(llNewRow,"lot_no",w_do.idw_pick.GetItemString(llPickFindRow,'lot_no'))

		//Find next child Picking row
		If llPickFindRow = w_do.idw_pick.RowCount() Then
			llPickFindRow = 0
		Else
			llPickFindRow ++
			llPickFindRow = w_do.idw_Pick.Find(lsPickFind,llPickFindRow,w_do.idw_Pick.RowCount())
		End If
	Loop /*Next child Picking record for parent*/

	//Build Notes block for this line...
	liFind = ldsNotes.Find("line_item_no = " + string(llLineItemNo), 1, liNotes+1) //liDetailLines)
	i = 0	
	do while liFind > 0
		// - may not want to create the *-box for line notes...
		lsNote = ldsNotes.GetItemString(liFind, "Note_Text")
		if i = 0 then
			lsNotes = lsBorder + '~r' + lsNote
		else
			//if it's not the first note, put a space in between...
			lsNotes += ' ' + lsNote
		end if
		liFind = ldsNotes.Find("line_item_no = " + string(llLineItemNo), liFind+1, liNotes+1) //liDetailLines)
		i++
		if i > 5 then
			liFind = 0
		end if
	loop //finding all P/L notes for current line
	if i > 0 then
		lsNotes += '~r' + lsBorder
	end if
	//ld_packPrint.Modify("Header_Notes_T.text = '" + lsNotes + "'")
	ld_packprint.SetItem(llNewRow, "pl_notes_line", lsNotes)
	lsNotes = ''
	
	IF lsSKU = 'A221201' THEN
		
		ld_packprint.RowsCopy(llNewRow, llNewRow, Primary!, ld_packprint, llNewRow + 1, Primary!)

 		ld_packprint.SetItem( llNewRow, "ship_qty", 100)
 		ld_packprint.SetItem( llNewRow + 1, "ship_qty", 50)

	 		ld_packprint.SetItem( llNewRow, "cartons_shipped", 100)
 		ld_packprint.SetItem( llNewRow + 1, "cartons_shipped", 50)
	
	
	
	 	ld_packprint.SetItem( llNewRow + 1, "lot_no", "093010037L")
	
	END IF

Next /*Detail row*/

llRowCount = llRowCount + 1

// Force the summary to the bottom of the page. Find out how many rows on a page and how many have been used.
//??? What about multi-page P/Ls?
liMaxLines = 17 //temporary! 
For llRowPos = 1 to (liMaxLines - llRowCount)
	llNewRow = ld_packprint.InsertRow(0)
next
//Resort the detail tab back to default
//w_do.Idw_Detail.SetSort("Line_Item_No A, SKU A")
//w_do.idw_Detail.Sort()
//

//Set Gross Wt, Net Wt, volume and carton count
llRowCount = w_do.idw_Pack.RowCount()
For llRowPos = 1 to llRowCount
	ldNetWeight += (w_do.idw_Pack.GetItemNumber(lLRowPos,'weight_net') * w_do.idw_Pack.GetItemNumber(lLRowPOs,'quantity'))
	llTotalPieces += (w_do.idw_Pack.GetItemNumber(lLRowPos, 'quantity'))
	
	If w_do.idw_Pack.GetItemString(llRowPos,'carton_no') <> lsCartonSave Then
		liCartonCount ++
		If w_do.idw_Pack.GetItemNumber(llRowPos,'weight_gross') > 0 and not isnull(w_do.idw_Pack.GetItemNumber(lLRowPOs,'weight_gross')) Then
			ldGrossWeight += w_do.idw_Pack.GetItemNumber(lLRowPOs,'weight_gross')
		End If
		If w_do.idw_Pack.GetItemNumber(llRowPos,'length') > 0 and w_do.idw_Pack.GetItemNumber(llRowPos,'width') > 0 and w_do.idw_Pack.GetItemNumber(llRowPos,'height') > 0 Then
			ldVolume += (w_do.idw_Pack.GetItemNumber(llRowPos,'length') * w_do.idw_Pack.GetItemNumber(llRowPos,'width') * w_do.idw_Pack.GetItemNumber(llRowPos,'height'))
		End If
	End If
	lsCartonSave = w_do.idw_Pack.GetItemString(llRowPos,'carton_no')
Next /*Packing Row */

// Carton Count may also be represented in Delivery Picking
// Box Count is entered in po_no2. A Single Line ITem may be a qty of 1 (or more) but have multiple cartons that need to be included in the total here 
// (but can't be included as seperate cartons on the PAcking List since a qty of 1 can't be split across multiple cartons 
llRowCount = w_do.idw_pick.RowCount()
For llRowPos = 1 to llRowCount
	If isnumber(w_do.idw_Pick.GetItemString(llRowPos,'po_no2')) Then
		liCartonCount += Long(w_do.idw_Pick.GetItemString(llRowPos,'po_no2')) - 1 /*first carton is already counted in Packing Count */
	End If
Next /*Picking Row */

If w_do.idw_Pack.GetItemString(1,'standard_of_measure') = 'E' Then
	lsSOM = ' LB'
Else
	lsSOM = ' KG'
End If

//ld_packPrint.Modify("gross_Weight_t.text = '" + String(ldGrossWeight,"#########.00") + lsSOM + "'")
ld_packPrint.Modify("gross_Weight_t.text = '" + String(ldGrossWeight,"#########") + "'")
//ld_packPrint.Modify("net_Weight_t.text = '" + String(ldNetWeight,"#########.00") + lsSOM +  "'")
ld_packPrint.Modify("total_pieces_t.text = '" + String(llTotalPieces, "#########") + "'")
//ld_packPrint.Modify("volume_t.text = '" + String(ldVolume,"#########.00") + "'")
ld_packPrint.Modify("total_cartons_t.text = '" + String(liCartonCount,"########0") + "'")

//Build Notes block for Order...
liFind = ldsNotes.Find("line_item_no = 0", 1, liNotes+1) //liDetailLines)
i = 0
//lsBorder = '**************************************************'
lsBorder = '****************************************************************************************************'
lsNotes2 = ''
do while liFind > 0
	lsNote = ldsNotes.GetItemString(liFind, "Note_Text")
	if i = 0 then
		lsNotes = lsBorder
		lsNotes += '~r*' + lsNote
	else
		//if it's not the first note, add a space between the notes
		lsNotes += ' ' + lsNote
	end if
	liFind = ldsNotes.Find("line_item_no = 0", liFind+1, liNotes+1) //liDetailLines)
	i++
	if len(lsNotes) > 900 then
		liFind = 0
	end if
loop //finding all Order Header BOL notes (where line_item_no = 0)

if i > 0 then //len(lsNotes) > 0 then
	if len(lsNotes) > 490 - len(lsBorder) then //should we not include length of Border here (and if it's barely over the limit, just skip the bottom border)
		//split on last space before note 1 is full (need to allow for bottom border)....
		liLastSpace = LastPos(lsNotes, ' ', 490 - len(lsBorder))
		if liLastSpace = 0 then liLastSpace = 490 - len(lsBorder)
		lsNotes2 = mid(lsNotes, liLastSpace) + '~r' + lsBorder
		lsNotes = left(lsNotes, liLastSpace)
	else
		lsNotes = left(lsNotes, liLastSpace) + '~r' + lsBorder
	end if
//	//messagebox("TEMPO-header notes: i:" +string(i), "Notes: " + string(len(lsNotes)) + ", Notes2: " + string(len(lsNotes2)) + ", LastSpace: " + string(liLastSpace))
//	if len(lsNotes2) = 0 then
//		//place closing block in the 2nd note...
//		lsNotes2 = lsBorder
//	else
//		//add a new line if there's notes in lsNotes2
//		lsNotes2 += '~r' +lsBorder
//	end if
end if

ld_packPrint.Modify("Header_Notes_T.text = '" + lsNotes + "'")
if len(lsNotes2) > 0 then
	//messagebox("TEMPO-setting c_notes2", string(liBOLRow) + lsnotes2)
	ld_packPrint.Modify("Header_Notes2_T.text = '" + lsNotes2 + "'")
end if

// If we have a default printer for PackList, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','PACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

OpenWithParm(w_dw_print_options, ld_packprint) 

Return 0
end function

public function integer uf_packprint_lmc ();
Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llPos, llPickCount,  lLDetailFindRow, llLineItem,	&
		llSerialPos, llSerialCount, llPAckQty, llPAckFindRow, llSerialQty
String	lsWarehouse, lsSKU, lsSupplier, lsDONO, lsDesc, lsLot, lsLotsave, lsSKUSave, lsTempSerial
String	lsCarton, lsCartonSave, lsFind, lsSerial, lsNextSerial, lsSQl, presentation_str, dwsyntax_str, lsErrText
DataStore	ldpackprint, ldsSerial


ldpackprint = Create Datastore
ldpackprint.dataobject ='d_lmc_packing_prt'

If w_do.ib_changed then
	Messagebox(w_do.is_title,"Please save your changes first.")
	Return -1
End IF

lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')

Setpointer(hourglass!)

//Carton Serial Numbers - Retrieve all for Order, Sorted by Carton, SKU, Lot (MAC_ID), Starting Serial (Serial_NO) and Qty for starting Serial (Quantity)
ldsSerial = Create Datastore
presentation_str = "style(type=grid)"

lsSQl = "Select Delivery_serial_detail.Carton_No, Delivery_serial_detail.Mac_ID, Delivery_serial_detail.Serial_No, Delivery_serial_detail.Quantity, "
lsSQL += " Delivery_Picking_Detail.SKU, Delivery_Picking_Detail.Supp_Code "
lsSQL += " From Delivery_Picking_Detail, Delivery_Serial_Detail "
lsSQL += " Where Delivery_Picking_Detail.ID_NO = Delivery_Serial_Detail.ID_NO "
lsSQL += " and Delivery_Picking_Detail.do_no = '" + lsDONO + "'"
lsSQl += " Order by Carton_no, SKU, MAc_ID "

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsSerial.Create( dwsyntax_str, lsErrText)
ldsSerial.SetTransobject(sqlca)
ldsSerial.Retrieve()

//Make sure we have all the Serial Numbers entered (serial Qty = PAck Qty) or the PAckList will print incomplete
Select Sum(quantity) into :llPackQty 
from delivery_PAcking
Where do_no = :lsDoNo;

Select Sum(quantity) into :llSerialQty
from delivery_serial_detail
Where Id_no in (select id_no from delivery_picking_detail where do_no = :lsDONO);

If llPackQty <> llSerialQty Then
	MessageBox(w_do.is_title,"PackList Qty <> Serial scanned Qty. Please check.",Stopsign!)
	Setpointer(arrow!)
	Return -1
End If

//Warehouse (Shipper) info retreived in Warehouse DS
lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())


//For each Serial Row (by Carton, SKU, Lot and Starting Serial Number), add a PAcking Row when the Carton, SKU or Lot changes)
//We are looping through Serial rows instead of PAcking Rows since we need a seperate Packing row for each lot (Stored in MAC_ID in serial_Detail)

llRowCount = ldsSerial.RowCount()
For llRowPos = 1 to llRowCount
	
	lsSKU = ldsSerial.GEtITEmString(llRowPos,'sku')
	lsCarton = ldsSerial.GEtITEmString(llRowPos,'Carton_no')
	lsLot = ldsSerial.GEtITEmString(llRowPos,'MAC_ID')
	lsSupplier = ldsSerial.GEtITEmString(llRowPos,'supp_code')
	lsSerial = ldsSerial.GEtITEmString(llRowPos,'serial_no')
	llPAckQty = ldsSerial.GEtITEmNumber(llRowPos,'quantity')
	
	//If Carton, SKU or Lot has changed, create a new Packing Row
	If lsSKU <> lsSKUSave or lsCarton <> lsCartonSave or lsLot <> lsLotsave Then
	
		llNewRow = ldpackprint.InsertRow(0)
	
		//Set Shipper Info from Warehouse table
		If llwarehouseRow > 0 Then /*warehouse row exists*/
	
 			ldpackprint.SetITem(llNewRow,'ship_from_name',g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name'))
			ldpackprint.SetITem(llNewRow,'ship_from_address1',g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1'))
			ldpackprint.SetITem(llNewRow,'ship_from_address2',g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2'))
			ldpackprint.SetITem(llNewRow,'ship_from_address3',g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3'))
			ldpackprint.SetITem(llNewRow,'ship_from_address4',g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4'))
		
			//City, State Zip in a single field
			If g.ids_project_warehouse.GetITemString(llWarehouseRow,'city') > "" Then
				ldpackprint.SetITem(llNewRow,'ship_from_city',g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
			End IF
	
			If g.ids_project_warehouse.GetITemString(llWarehouseRow,'state') > "" Then
				ldpackprint.SetITem(llNewRow,'ship_from_state',g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
			End If
	
			If g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip') > "" Then
				ldpackprint.SetITem(llNewRow,'ship_from_zip',g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
			End If
	
		End If /*warehouse exists*/
	
		//Header fields
		ldpackprint.SetITem(llNewRow,'cust_order_No', w_do.idw_Main.GetITemString(1,'cust_order_no'))
		ldpackprint.SetITem(llNewRow,'invoice_no', w_do.idw_Main.GetITemString(1,'invoice_no'))
		ldpackprint.SetITem(llNewRow,'carrier', w_do.idw_Main.GetITemString(1,'carrier'))
		ldpackprint.setitem(llNewRow,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
		ldpackprint.setitem(llNewRow,"complete_date",w_do.idw_main.getitemdatetime(1,"complete_date"))
		ldpackprint.SetITem(llNewRow,'remark', w_do.idw_Main.GetITemString(1,'remark')) 
		ldpackprint.SetITem(llNewRow,'cust_code', w_do.idw_Main.GetITemString(1,'cust_code')) 
		ldpackprint.SetITem(llNewRow,'ship_via', w_do.idw_Main.GetITemString(1,'ship_via')) 
		ldpackprint.SetITem(llNewRow,'Freight_terms', w_do.idw_Main.GetITemString(1,'Freight_terms')) 
		ldpackprint.SetITem(llNewRow,'sch_cd', w_do.idw_Main.GetITemString(1,'User_field1')) 
		ldpackprint.SetITem(llNewRow,'sales_order_nbr', w_do.idw_Main.GetITemString(1,'User_field5'))
		ldpackprint.SetITem(llNewRow,'packlist_notes', w_do.idw_Main.GetITemString(1,'packlist_notes'))
	
		
		//Customer Address -> Delivery
		ldpackprint.SetITem(llNewRow,'cust_name',w_do.idw_Main.GetITemString(1,'cust_Name'))
		ldpackprint.SetITem(llNewRow,'delivery_address1',w_do.idw_Main.GetITemString(1,'address_1'))
		ldpackprint.SetITem(llNewRow,'delivery_address2',w_do.idw_Main.GetITemString(1,'address_2'))
		ldpackprint.SetITem(llNewRow,'delivery_address3',w_do.idw_Main.GetITemString(1,'address_3'))
		ldpackprint.SetITem(llNewRow,'delivery_address4',w_do.idw_Main.GetITemString(1,'address_4'))
		ldpackprint.SetITem(llNewRow,'city',w_do.idw_Main.GetITemString(1,'city'))
		ldpackprint.SetITem(llNewRow,'delivery_state',w_do.idw_Main.GetITemString(1,'state'))
		ldpackprint.SetITem(llNewRow,'delivery_zip',w_do.idw_Main.GetITemString(1,'zip'))
		ldpackprint.SetITem(llNewRow,'country',w_do.idw_Main.GetITemString(1,'country'))
	
		//Packing level fields...We need the Packing Row for this carton/SKU
		lsFind = "Carton_No = '" + lsCarton + "' and Upper(SKU) = '" + upper(lsSKU) + "'"
		llPackFindRow = w_do.idw_Pack.Find(lsFind,1, w_do.idw_Pack.RowCOunt())
		
		If llPackFindRow > 0 Then
			
			ldpackprint.SetITem(llNewRow,'sku',lsSKU)
			ldpackprint.SetITem(llNewRow,'carton_no', lsCarton)
			ldpackprint.SetITem(llNewRow,'lot_no', lsLot)
			ldpackprint.SetITem(llNewRow,'picked_quantity', llPAckQty) /* this is the quantity scanned on the label */
	
			lsDesc = ""
	
			Select Description into :lsDesc
			From ITem_Master
			Where Project_id = :gs_Project and sku = :lsSKU and supp_Code = :lsSupplier;
		
			ldpackprint.SetITem(llNewRow,'description',lsDesc)
			ldpackprint.setitem(llNewRow,"supp_code",w_do.idw_Pack.GetITemString(llPackFindRow,"supp_code")) 
			
			//If new carton, set the Gross WEight, DIMS and Volume only on the first row of the carton . We don't want to sum it multiple times for a single carton
			If lsCarton <> lsCartonsave Then
				
				ldpackprint.setitem(llNewRow,'gross_weight',w_do.idw_pack.getitemDecimal(llPackFindRow,"weight_gross"))
				
				//Only show volume and DIMS on first row of carton
				ldpackprint.setitem(llNewRow,"volume",w_do.idw_Pack.GetITemDecimal(llPackFindRow,"cbm")) 
				
				If w_do.idw_Pack.GetITemDecimal(llPackFindRow,"cbm") > 0 Then
					ldpackprint.setitem(llNewRow,'dimensions',string(w_do.idw_pack.getitemDecimal(llPackFindRow,"length")) + ' x ' + string(w_do.idw_pack.getitemDecimal(llPackFindRow,"width")) + ' x ' + string(w_do.idw_pack.getitemDecimal(llPackFindRow,"height"))) 
				End If
			
			End If
			
		End If
	
	Else /* Add Qty and sesrials to existing row for carton/sku/lot */
		
		//Add Scanned Qty to existing row
		ldpackprint.SetITem(llNewRow,'picked_quantity', ldPackPrint.GetITemNumber(llNewRow,'picked_quantity') + llPackQty)
			
	End If /* New Carton/SKU/Lot */
	
	//Add serial Numbers. If Qty is 1, there is only 1 serial. If Qty > 1, this is the starting Serial Number and we need to generate the rest
	//If Serial Number begins with "N/A" Then it isn't a serialized part and we don't have to print
	If left(lsSerial,3) <> 'N/A' Then
		
		lsTempSerial = ldPAckPrint.GetITemString(llNewRow,'Serial_No') 
		If isNull(lsTempSerial) then lsTempSerial = ''
		If lsTempSerial > '' Then lsTempSerial += ", "
		
		//Calculate necessary Serials
		If llPackQty > 1 Then
			
			lsNextSerial = lsSerial
			
			//Generate PackQty - 1 next serial numbers
			For llPos = 1 to (llPAckQty - 1)
				
				lsNextSerial = w_do.iuo_check_digit_validations.uf_lmc_generate_next_serial_no(lsNextSerial)
				lsSerial += ", " + lsNextSerial
				
			Next
			
			
		End If
		
		ldPackPrint.SetItem(llNewRow,'Serial_No', lsTempSerial + lsSerial)
		
	End If
	
	
	lsSKUsave = lsSKU
	lsCartonSave = lsCarton
	lsLotSave = lsLot
	
Next /*Serial Detail Row*/

Setpointer(arrow!)

OpenWithParm(w_dw_print_options,ldpackprint) 

Return 0
end function

public function integer uf_packprint_hillman_homedepot ();
// 07/09 - PCONKL - Hillman Packing List for Home DEpot Orders
Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llPalletOf,	&
		 llPAckQty, llPAckFindRow, llSerialQty,  llPalletCount, llFolioCount
String	lsWarehouse, lsSKU, lsSupplier,  lsDesc, lsCarton, lsCartonSave, lsFind, lsCityStateZip, lsStoreNbr, lsStoreName, &
			lsCustCode, lsOrder, lsAltSKU, lsFolio, lsDONO
DateTime	lDTFreightETA
DataStore	ldpackprint, ldLabelPrint, ldsFolio

str_parms	lstrparms
String lsPart_UPC_Code


ldpackprint = Create Datastore
ldpackprint.dataobject ='d_hillman_packing_prt_homedepot'

ldLabelPrint = Create Datastore
ldLabelPrint.dataobject ='d_hillman_pallet_label_homedepot'

ldsFolio = Create Datastore
ldsFolio.dataobject ='d_hillman_select_folio'
ldsFolio.SetTransObject(SQLCA)

w_do.idw_main.AcceptText()
w_do.idw_other.AcceptText()
w_do.idw_Pack.AcceptText()

If w_do.ib_changed then
	Messagebox(w_do.is_title,"Please save your changes first.")
	Return -1
End IF

//Validate that the Estimated Ship/Arrival Dates have been entered
If isnull(w_do.idw_main.getitemdatetime(1,"freight_etd")) or isnull(w_do.idw_main.getitemdatetime(1,"freight_eta")) Then
	Messagebox(w_do.is_title,"Freight ETD (Fecha de Envío) and Freight ETA (Fecha Estimada de Llegada)~rmust be entered before printing the Packing List and Pallet Labels.",Stopsign!)
	w_do.tab_main.selecttab(2)
	w_do.idw_other.SetFocus()
	w_do.idw_other.SetColumn('freight_etd')
	Return -1
End If

//Vendor Name (UF6) required)
If isnull(w_do.idw_main.getitemString(1,"User_field6")) or w_do.idw_main.getitemString(1,"User_field6") = '' Then
	Messagebox(w_do.is_title,"Vendor Name must be entered before printing the Packing List and Pallet Labels.",Stopsign!)
	w_do.tab_main.selecttab(2)
	w_do.idw_other.SetFocus()
	w_do.idw_other.SetColumn('User_field6')
	Return -1
End If

//ASN (UF7) required)
If isnull(w_do.idw_main.getitemString(1,"User_field7")) or w_do.idw_main.getitemString(1,"User_field7") = '' Then
	Messagebox(w_do.is_title,"ASN Number must be entered before printing the Packing List and Pallet Labels.",Stopsign!)
	w_do.tab_main.selecttab(2)
	w_do.idw_other.SetFocus()
	w_do.idw_other.SetColumn('User_field7')
	Return -1
End If

//Truck Seq (UF8) required to determine which Folio Nbr to Use
If isnull(w_do.idw_main.getitemString(1,"User_field8")) or w_do.idw_main.getitemString(1,"User_field8") = '' Then
	Messagebox(w_do.is_title,"Truck Seq must be entered before printing the Packing List and Pallet Labels.",Stopsign!)
	w_do.tab_main.selecttab(2)
	w_do.idw_other.SetFocus()
	w_do.idw_other.SetColumn('User_field8')
	Return -1
End If

//Box Count (UF1) is also required and must be numeric for the Pallet Labels
llRowCount = w_do.idw_Pack.RowCount()
For llRowPos = 1 to llRowCount
	
	If isnull(w_do.idw_Pack.GetITemString(llRowPos,'user_field1')) or w_do.idw_Pack.GetITemString(llRowPos,'user_field1') = '' Then
		Messagebox(w_do.is_title,"Box Count must be entered before printing the Packing List and Pallet Labels.",Stopsign!)
		w_do.tab_main.selecttab(5)
		w_do.idw_PAck.SetFocus()
		w_do.idw_Pack.SetColumn('User_Field1')
		w_do.idw_Pack.SetRow(llRowPos)
		Return -1
	Else
		If not isnumber(w_do.idw_Pack.GetITemString(llRowPos,'user_field1')) Then
			Messagebox(w_do.is_title,"Box Count must be numeric.",Stopsign!)
			w_do.tab_main.selecttab(5)
			w_do.idw_PAck.SetFocus()
			w_do.idw_Pack.SetColumn('User_Field1')
			w_do.idw_Pack.SetRow(llRowPos)
			Return -1
		End If
	End If
	
	//Carton Number (Pallet ID) must be 1 or 2 char
	If isnull(w_do.idw_Pack.GetITemString(llRowPos,'carton_no')) or w_do.idw_Pack.GetITemString(llRowPos,'carton_no') = '' or Len(w_do.idw_Pack.GetITemString(llRowPos,'carton_no')) > 2 or Not isnumber(w_do.idw_Pack.GetITemString(llRowPos,'carton_no')) Then
		Messagebox(w_do.is_title,"Carton Number must be present, numeric and 1 or 2 characters.",Stopsign!)
		w_do.tab_main.selecttab(5)
		w_do.idw_PAck.SetFocus()
		w_do.idw_Pack.SetColumn('carton_no')
		w_do.idw_Pack.SetRow(llRowPos)
		Return -1
	End If
	
Next

Setpointer(hourglass!)

//We need the Store Number and Name (UF1 & UF3) from the Customer Master
lsCustCode = w_do.idw_Main.GetITemString(1,'Cust_Code')

Select User_Field1, User_Field3 into :lsStoreNbr, :lsStoreName
From Customer
Where Project_id = 'HILLMAN' and Cust_Code = :lsCustCOde;

If isnull(lsStoreNbr) Then lsStoreNbr = ''
If isnull(lsStoreName) Then lsStoreName = ''

llPalletCount = 0

//We need to use the same folio number for all orders with the same expected delivery date and Truck Sequence (UF8)
// The Folio Number is the last 4 of the DO_NO
//If multiple Truck Sequences found for the Delivery Date, prompt user for which one to use.
If isnull(w_do.idw_main.getitemString(1,"User_field10")) or w_do.idw_main.getitemString(1,"User_field10") = '' Then
	
	lDTFreightETA = w_do.idw_main.getitemdatetime(1,"freight_eta")
	llFolioCount = ldsFolio.Retrieve(gs_project, ldtFreightETA, lsDONO)
	
	Choose Case llFolioCount
			
		Case 0
			lsFolio = Right(w_do.idw_Main.GetITemString(1,'do_no'),4) /* First Folio, Use the right 4 of the DONO for the unique number*/
		Case 1 /* Only 1 truck Sequence for the ETA date, use Folio previously assigned*/
			If ldsFolio.GetITemString(1,'User_Field10') > '' Then
				lsFolio = ldsFolio.GetITemString(1,'User_Field10')
			Else
				lsFolio = Right(w_do.idw_Main.GetITemString(1,'do_no'),4)
			End If
		Case Else /* multiple truck seq/folios assigned for ETA date. display popup and let user decid which folio to use*/
			lstrparms.Datastore_arg[1] = ldsFolio
			OpenWithParm(w_hillman_select_folio,lstrparms)
			lstrparms = message.PowerObjectParm
			If Upperbound(lstrparms.String_arg) > 0 Then
				lsFolio = lstrParms.String_arg[1]
			End If
	End Choose
	
Else /*use Folio Number already entered*/
	lsFolio = w_do.idw_main.getitemString(1,"User_field10")
End If

If isnull(lsFolio) or lsFOlio = '' Then
	lsFolio = Right(w_do.idw_Main.GetITemString(1,'do_no'),4)
End If

w_do.idw_main.SetITem(1,'User_Field10',lsFolio) /*set the folio on the order */

//For each Packing Row, roll up to Pallet (carton_no)/SKU
llRowCount = w_do.idw_Pack.RowCount()
For llRowPos = 1 to llRowCount
	
	lsSKU = w_do.idw_Pack.GEtITEmString(llRowPos,'sku')
	lsSupplier = w_do.idw_Pack.GEtITEmString(llRowPos,'supp_code')
	lsCarton = w_do.idw_Pack.GEtITEmString(llRowPos,'Carton_no')
	llPAckQty = w_do.idw_Pack.GEtITEmNumber(llRowPos,'quantity')
	
	//Get the Pallet Count for the next step (labels)
	If lsCarton <> lsCartonSave Then 
		llPalletCount ++
		lsCartonSave = lsCarton
	End If

	//Need description and Alt SKU from Itemmaster
	lsDesc = ''
	lsAltSku = ''
	Select Description, Alternate_SKU, Part_UPC_Code into :lsDesc, :lsAltSKU, :lsPart_UPC_Code
	From ITem_Master
	Where Project_id = 'Hillman' and sku = :lsSKU and Supp_Code = :lsSupplier;
		
//	//Use Alt SKU if PResent
//	If lsAltSKU > '' Then
//		lsSKU = lsAltSKU
//	End If
//	
	//Update Existing or Insert new row based on Carton/SKU
	lsFind = "Carton_No = '" + lsCarton + "' and Upper(SKU) = '" + upper(lsSKU) + "'"
	llPackFindRow = ldpackprint.Find(lsFind,1, ldpackprint.RowCOunt())
		
	If llPackFindRow > 0  Then
		
		ldpackprint.SetITem(llPackFindRow,'qty', ldPackPrint.GetITemNumber(llPackFindRow,'qty') + llPackQty)
		
	Else
	
		llNewRow = ldpackprint.InsertRow(0)
		
		//Hardcoded for now...
		//ldpackprint.SetITem(llNewRow,'vendor_id','598880-' + Right(w_do.idw_Main.GetITemString(1,'do_no'),4)) /* Folio de Envio (Vendor ID) */
		ldpackprint.SetITem(llNewRow,'vendor_id','598880-' + lsFolio) /* Folio de Envio (Vendor ID) */
		
		ldpackprint.SetITem(llNewRow,'ship_from','USE GUIA DE EMBARQUE') /* Enviar por (Ship VIA) */
		ldpackprint.SetITem(llNewRow,'lead_time',7) /* Tiempo de Entrega*/
		ldpackprint.SetITem(llNewRow,'Freight_terms', 'PREPAID') 
		
		//Header fields
		ldpackprint.SetITem(llNewRow,'cust_order_No', w_do.idw_Main.GetITemString(1,'cust_order_no'))
		
		//ldpackprint.SetITem(llNewRow,'provider', "(598880-01) " + w_do.idw_Main.GetITemString(1,'User_field6')) /* Supplier Name (provider) - Should be sent in file, may need to hardcode */
		ldpackprint.SetITem(llNewRow,'provider', "(598880-01) SUNSOURCE INTEGRATED SERVICES DE ME") /* S09/09 - PCONKL - Now HArdcoded */
		ldpackprint.SetITem(llNewRow,'asn_number', w_do.idw_Main.GetITemString(1,'User_field7'))
				
		ldpackprint.setitem(llNewRow,"ship_date",uf_convert_date_to_Spanish(Date(w_do.idw_main.getitemdatetime(1,"freight_etd")))) /*estimated ship date being mapped to "Fecha de Envio and Fecha de Embarque - may need to change - Convert month to Spanish */
		ldpackprint.setitem(llNewRow,"est_delivery_date",uf_convert_date_to_Spanish(Date(w_do.idw_main.getitemdatetime(1,"freight_eta")))) /*Fecha Estimada de Llegada - Estimated Arrival Date*/
		ldpackprint.setitem(llNewRow,"print_date",uf_convert_date_to_Spanish(today())) /* Print Date*/
		
		ldpackprint.setitem(llNewRow,"store",lsStoreNbr + ' ' + lsStoreName)
		
		If w_do.idw_Main.GetITemString(1,'ord_type') = 'B' Then /*BAckorder */
			ldpackprint.SetITem(llNewRow,'backorder_ind','Yes')
		Else
			ldpackprint.SetITem(llNewRow,'backorder_ind','No')
		End If
		
		//Customer Address - Hardcoded for now
//		ldpackprint.SetITem(llNewRow,'cust_name',w_do.idw_Main.GetITemString(1,'cust_Name'))
//		ldpackprint.SetITem(llNewRow,'address_1',w_do.idw_Main.GetITemString(1,'address_1'))
//		ldpackprint.SetITem(llNewRow,'address_2',w_do.idw_Main.GetITemString(1,'address_2'))
//		ldpackprint.SetITem(llNewRow,'address_3',w_do.idw_Main.GetITemString(1,'address_3'))
//		ldpackprint.SetITem(llNewRow,'address_4',w_do.idw_Main.GetITemString(1,'address_4'))
		
		ldpackprint.SetITem(llNewRow,'cust_name','MDC MONTERREY')
		ldpackprint.SetITem(llNewRow,'address_1','CALLE TEXAS S/N DENTRO DEL PARQUE')
		ldpackprint.SetITem(llNewRow,'address_2','INDUSTRIAL EL NACIONAL')
		ldpackprint.SetITem(llNewRow,'address_3','CIENEGA DE FLORES')
		ldpackprint.SetITem(llNewRow,'address_4','NL, 65550')
		
		//City, State, Zip in Single Field
//		lsCityStateZip = ''
//		
//		If w_do.idw_Main.GetITemString(1,'city') > '' Then
//			lsCityStateZip = w_do.idw_Main.GetITemString(1,'city') + ", "
//		End If
//		
//		If w_do.idw_Main.GetITemString(1,'state') > '' Then
//			lsCityStateZip += w_do.idw_Main.GetITemString(1,'state') + " "
//		End If
//		
//		If w_do.idw_Main.GetITemString(1,'zip') > '' Then
//			lsCityStateZip += w_do.idw_Main.GetITemString(1,'zip') 
//		End If
				
//		ldpackprint.SetITem(llNewRow,'city_state_zip',lsCityStateZip)
		
		//Detail Fields
		ldpackprint.setitem(llNewRow,"sku",lsSku)
		ldpackprint.setitem(llNewRow,"model",lsAltSKU)
		ldpackprint.setitem(llNewRow,"upc",lsPart_UPC_Code)		
		ldpackprint.setitem(llNewRow,"pallet_id",w_do.idw_Main.GetITemString(1,'User_field7') + String(long(lsCarton),'00')) /*Pallet is ASN + carton Number */
		ldpackprint.setitem(llNewRow,"qty",llPAckQty)
		ldpackprint.setitem(llNewRow,"Description",lsDesc)
			
	End If /* New Carton/SKU */
	
	
Next /*Packing Row*/

//Create the Pallet ID Labels and print at the same time
llRowCount = w_do.idw_Pack.RowCount()
lsCartonSave = ""
llPalletOf = 0

For llRowPos = 1 to llRowCount
	
	lsCarton = String(long(w_do.idw_Pack.GEtITEmString(llRowPos,'Carton_no')),'00') /* pad it to "00" if not already */
	
	// Only 1 label per Pallet
	If lsCarton <> lsCartonSave Then
		
		llNewRow = ldlabelprint.InsertRow(0)
		llPalletOf ++
		ldlabelprint.SetITem(llNewRow,'cust_order_No', w_do.idw_Main.GetITemString(1,'cust_order_no'))
		
		//barcoded Order Number is prefixed with "A" and does not include the dash
		lsOrder = w_do.idw_Main.GetITemString(1,'cust_order_no')
		Do While Pos(lsOrder,'-') > 0
			lsOrder = Replace(lsOrder,Pos(lsOrder,'-'),1,"")
		Loop
		
		ldlabelprint.SetITem(llNewRow,'cust_order_No_barcode',"A" + lsOrder)
		ldlabelprint.SetITem(llNewRow,'asn_number', w_do.idw_Main.GetITemString(1,'User_field7'))
		ldlabelprint.setitem(llNewRow,"store_number",lsStoreNbr)
		ldlabelprint.setitem(llNewRow,"store_name",Upper(lsStoreName))
		ldlabelprint.setitem(llNewRow,"supplier_code","598880") /*hardocded for now */
	//	ldlabelprint.SetITem(llNewRow,'supplier_name',  w_do.idw_Main.GetITemString(1,'User_field6')) /* Supplier Name (provider) - Should be sent in file, may need to hardcode */
	//	ldlabelprint.SetITem(llNewRow,'supplier_name', "SUNSOURCE INTEGRATED SERVICES DE ME") /* 09/09 - PCONKL - Hardcoded now */
		ldlabelprint.setitem(llNewRow,"pallet_id","M" + w_do.idw_Main.GetITemString(1,'User_field7') + lsCarton) /*Prefix of "M" + Pallet is ASN + carton Number */
		ldlabelprint.setitem(llNewRow,"pallet_of", String(llPalletOf) + "/" + String(llPalletCount))
		ldlabelprint.setitem(llNewRow,"box_count", Long(w_do.idw_Pack.GetITemString(llRowPos,'User_Field1')))
		ldlabelprint.setitem(llNewRow,"print_date",uf_convert_date_to_Spanish(today())) /* Print Date*/
		
		//Create a second copy (so they are collated)
		ldLabelPrint.RowsCopy(llNewRow,llNewRow,Primary!,ldLabelPrint,9999999,Primary!)
		
		lsCartonSave = lsCarton
		
	End If /*Carton changed */
	
next

ldPackPrint.Sort()

Setpointer(arrow!)

OpenWithParm(w_dw_print_options,ldpackprint) 
If message.DoubleParm >= 0 Then
	//Nxjain:12162016 user does not wann to print Home label.
//	Print(ldLabelPrint) 
//nxjain12162016 end
	w_do.TriggerEvent('ue_save') /*save the folio back to the order */
End If

Return 0
end function

public function string uf_convert_date_to_spanish (date addatetoconvert);

Int	liMonth
String	lsMonth

liMonth = Month(adDateToConvert)

Choose Case liMonth
	Case 1
		lsMonth = "Ene"
	Case 2
		lsMonth = "Feb"
	Case 3
		lsMonth = "Mar"
	Case 4
		lsMonth = "Abr"
	Case 5
		lsMonth = "May"
	Case 6
		lsMonth = "Jun"
	Case 7
		lsMonth = "Jul"
	Case 8
		lsMonth = "Ago"
	Case 9
		lsMonth = "Sep"
	Case 10
		lsMonth = "Oct"
	Case 11
		lsMonth = "Nov"
	Case 12
		lsMonth = "Dic"
End Choose


Return String(Day(adDateToConvert)) + "-" + lsMonth + "-" + String(Year(adDateToConvert))
end function

public function integer uf_packprint_epson ();// This event prints the Packing List which is currently visible on the screen 
// and not from the database - JC
 
// Any custom Pack Print routines are called from the clicked event of the print button
 
string trackingids = 'Tracking Ids: '
string acomma = ", "
string ls_user_field3
 
Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos, llNotesCount, llNotesPos
Decimal ld_weight, ld_costcenter
String ls_address,lsfind,ls_text[], lscusttype, lscustcode, lsSerial, lsNotes_Summary
String ls_project_id , ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName, lsDONO
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT, lsUPC, lsPrinter, lsVol, lsNativeDesc, lsGrp
String ls_d_packing_prt
Datastore       ldsHazmat, ldsNotes
 
string ls_dono, lsUOM

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//10/11/2010 ujh: part of Extending the description field in packing list for pandora (supplier removed in this object)
if upper(gs_project) = 'PANDORA' then
	ls_d_packing_prt = 'd_packing_prt_Pandora'
else
	ls_d_packing_prt = 'd_packing_prt'
end if
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
// pvh - 09/18/06 - Added packing print do to project table.
string PackDo
PackDo = g.getPackPrintDo()
w_do.idw_packPrint.Dataobject = ls_d_packing_prt   //10/11/2010 ujh allow for dataobject with supplier column removed
if PackDo > '' then w_do.idw_packPrint.Dataobject = PackDo
// eom


w_do.idw_packPrint.Dataobject = 'd_epson_packing_prt'  		  

	 
  
SetPointer(HourGlass!)
If w_do.idw_pack.AcceptText() = -1 Then
        w_do.tab_main.SelectTab(3) 
        w_do.idw_pack.SetFocus()
        Return 0
End If
 
If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
        Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
        Return 0 
End If
 
//No row means no Print
ll_cnt = w_do.idw_pack.rowcount()
If ll_cnt = 0 Then
        MessageBox("Print Packing List"," No records to print!")
        Return 0 
End If
 
//Clear the Report Window (hidden datawindow)
w_do.idw_packprint.Reset()
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// 07/00 PCONKL - Get The Ship from info from the Project Table
// 04/04 - PCONKL - Some projects using standard PL are using Warehouse Address instead of Project Address
// 09/08 - PCONKL - Added 'DIEBOLD'
// 05/09 - PCONKL - Added Philips and Pandora
 
// *** 07/09 - PCONKL - All baseline Packing Lists now pulling Ship From address fom Warehouse table.
//      ***                                             For those projects that were pulling from Project, the address info has been copied over to the Warehouse table. This should be transparent to the users
 
// If Upper(gs_Project) = 'PHXBRANDS'  or Upper(gs_Project) = 'PHILIPS-SG' or Upper(gs_Project) = 'PANDORA'  Then
        
        lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")
        
        Select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
        Into    :lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
        From warehouse
        Where WH_Code = :lsWHCode
        Using Sqlca;
 
//Else
        
//      Select Client_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country, vat_id
//      Into    :lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry, :lsVat
//      From Project
//      Where Project_id = :gs_project
//      Using Sqlca;
        
//End If
 
       
 ldsNotes = Create DataStore
ldsNotes.dataobject = 'd_dono_notes'
ldsNotes.SetTransObject(SQLCA)
	  
lsDONO = w_do.idw_Main.GetItemString(1,'do_no')
lsNotes_Summary = ""
				 
  llNotesCount = ldsNotes.Retrieve(gs_project,lsDONO)
  
  For llNotesPos = 1 to llNotesCount
						
	 //Only want header notes
//	 If ldsNotes.GetItemNumber(llNotesPos,'line_item_No') = 0 Then
		lsNotes_Summary += ldsNotes.GetITemString(llNotesPos,'note_text') +  char(10)
//	 End If
						  
  Next
  

        

//summary_note
 
 
//02/02 - PCONKL - Hazardous material stuff for GM hahn
ldsHazmat = Create Datastore
ldshazmat.dataobject = 'd_hazard_text'
ldshazmat.SetTransObject(SQLCA)
 
lsTransPortMode= w_do.idw_main.GetITemString(1,'transport_Mode') /* used for printing haz mat info*/
	
	// Get the cost center.
	nvo_order lnvo_order
	lnvo_order = Create nvo_order
	lnvo_order.f_getcostcenter(1, ld_costcenter)
	Destroy lnvo_order
 
//Loop through each row in Tab pages and grab the coresponding info
For i = 1 to w_do.idw_detail.rowcount()
        
        j = w_do.idw_packprint.InsertRow(0)
        
 
        //Get SKU, Description and Quantities  04/05/00 PCONKL - include user field5 as pdc_whse_loc
        // 02/02 - PConkl - include hazardous text cd
        
        ls_sku = w_do.idw_detail.getitemstring(i,"sku")
        ls_supplier = w_do.idw_detail.getitemstring(i,"supp_code")
        llLineItemNo = w_do.idw_detail.GetITemNumber(i,'line_item_no')
        
        If ls_SKU <> lsSKUHold Then
                
                select description, weight_1, hazard_text_cd, part_upc_Code, user_field8, native_description, grp, UOM_1    /* 05/09 - PCONKL - UF8 = Volume for Philips */
                into :ls_description, :ld_weight, :lshazCode, :lsUPC, :lsVol, :lsnativeDesc, :lsGrp, :lsUOM
                from item_master 
                where project_id = :ls_project_id and sku = :ls_sku and supp_code = :ls_supplier ;
                
        End If /*Sku Changed*/
        
        lsSkuHold = ls_SKU
 
    	  ls_description = trim(ls_description)
        
        // 02/02 PCONKL - If there is hazardous material text for this SKU/Ship Method, retrieve the text for the report
        lshazText = ''
        If lshazCode > '' Then /*haz text exists for this sku*/
                llhazCount = ldsHazmat.Retrieve(gs_project,lshazCode,lsTransportMode)
                If llHazCount > 0 Then
                        For llHazPos = 1 to llHazCount
                                lsHazText += ldshazMat.GetItemString(llHazPos,'hazard_text') + '~r'
                        Next
                End If
        End If /*haz text exists*/
 
      
	   w_do.idw_packprint.setitem(j,"ord_no",w_do.idw_main.getitemstring(1,"cust_order_no"))

	   w_do.idw_packprint.setitem(j,"um",lsUOM)
	
	
	
        w_do.idw_packprint.setitem(j,"bol_no",w_do.is_bolno)
        w_do.idw_packprint.setitem(j,"freight_terms",w_do.idw_other.getitemstring(1,"freight_terms"))     
        w_do.idw_packprint.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"user_field10")) /* 5/3/00 PCONKL*/
        w_do.idw_packprint.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
        w_do.idw_packprint.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
        w_do.idw_packprint.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
        w_do.idw_packprint.setitem(j,"complete_date",w_do.idw_main.getitemdatetime(1,"complete_date"))
		  
	    w_do.idw_packprint.setitem(j,"schedule_date", w_do.idw_main.getitemdatetime(1,"schedule_date"))			
	
		  
        w_do.idw_packprint.setitem(j,"sku",ls_sku)
        //idw_packprint.setitem(j,"alt_sku",ls_alt_sku)  //08/09/00 DGM
        w_do.idw_packprint.setitem(j,"description",ls_description)
 
 		decimal ld_weight_gross, ld_picked_quantity, ld_carton_num
 
 		select sum(weight_gross), sum(quantity), count(carton_no) into :ld_weight_gross, :ld_picked_quantity, :ld_carton_num from delivery_packing where do_no = :lsDONO and line_item_no = :llLineItemNo;
 
 		if IsNull(ld_weight_gross) then ld_weight_gross = 0
 		if IsNull(ld_picked_quantity) then ld_picked_quantity = 0
 		if IsNull(ld_carton_num) then ld_carton_num = 0

 
        w_do.idw_packprint.setitem(j,"unit_weight", ld_weight_gross) /*take from displayed pask list instead of DB*/
	w_do.idw_packprint.setitem(j,"picked_quantity",ld_picked_quantity) 
	w_do.idw_packprint.setitem(j,"carton_num",ld_carton_num) 


        w_do.idw_packprint.setitem(j,"carrier", w_do.idw_other.getitemString(1,"carrier") )
        w_do.idw_packprint.setitem(j,"ship_via",w_do.idw_other.getitemString(1,"ship_via")) /* 5/3/00 PCONKL */
        w_do.idw_packprint.setitem(j,"sch_cd",w_do.idw_other.getitemString(1,"user_field1")) /* 5/3/00 PCONKL */
        w_do.idw_packprint.setitem(j,"packlist_notes",w_do.idw_main.getitemString(1,"packlist_notes")) /* 09/01 PCONKL */
        w_do.idw_packprint.setitem(j,"upc_Code",lsUPC) /* 04/04 PCONKL */
        w_do.idw_packprint.setitem(j,"project_id",gs_project) /* 12/01 PCONKL */
        w_do.idw_packprint.setitem(j,"HazText",lshazText) /* 02/02 PCONKL */
		  
	    ls_user_field3 = w_do.idw_detail.getitemString(i,"user_field3")		 
					 
		If IsNull(ls_user_field3) then ls_user_field3 = ""		 
					 
         w_do.idw_packprint.setitem(j,"cntl_number",w_do.idw_detail.getitemString(i,"user_field1")) /* Cntrl num // detail Weight for Sears*/
         w_do.idw_packprint.setitem(j,"cust_part_number","CUST PART# " + ls_user_field3 )
         w_do.idw_packprint.setitem(j,"alt_sku",w_do.idw_detail.getitemString(i,"alternate_sku"))
         w_do.idw_packprint.setitem(j,"line_number", String(w_do.idw_detail.GetItemNumber(i,"line_item_no"),"000"))
						  
		w_do.idw_packprint.setitem(j,"ordered_quantity",w_do.idw_detail.getitemnumber(i,"req_qty"))		  
		  
		  
        //For English to Metrtics changes added L or K based on E or M
//        ls_etom=w_do.idw_packprint.getitemString(j,"standard_of_measure")
//        IF ls_etom <> "" and not isnull(ls_etom) and j=1 THEN
//                IF ls_etom = 'E' THEN
//                        ls_text[1]="unit_w_t.Text='"+w_do.is_text[1]+"L'"                    
//                        ls_text[2]="ext_w_t.Text='"+w_do.is_text[2]+"L'"
//                        ls_text[3]="etom_t.Text='INCHES'"
//                ELSE
//                        ls_text[1]="unit_w_t.Text='"+w_do.is_text[1]+"K'"
//                        ls_text[2]="ext_w_t.Text='"+w_do.is_text[2]+"K'"
//						//Jxlim 08/24/2010 Modified for Chinese report		
//						 If w_do.idw_packPrint.Dataobject = 'd_packing_prt_chinese' Then	
//                       		ls_text[3]="etom_t.Text='厘米'"
//						Else
//							ls_text[3]="etom_t.Text='CENTIMETERS'"
//						End if
//						//Jxlim 08/24/2010 End of modified for Chinese report
//                END IF
//        END IF  
        
        // 5/4/00 PCONKL - find matching row in detail to get ordered quantity and CNTL Number
        

//        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLineItemNo)
//        llRow = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
//        
//        if llRow > 0 Then
//                
//		 
//	        
//                If Upper(gs_project) <> 'GM_MONTRY'  or (Upper(gs_project) = 'GM_MONTRY'  and (lscusttype  = "PDC" or lscusttype = "ACDELCOPDC")) Then /* 08/02 - Pconkl - GAP 9/02 added satillo PDCs */
//                        If w_do.idw_detail.getitemnumber(llRow,"req_qty") = w_do.idw_detail.getitemnumber(llRow,"alloc_qty") Then
//                               w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_pack.getitemNumber(i,"quantity"))
//                        Else /*ord qty <> Alloc, if it's the last carton row for this sku, show the difference here, otherwise set to alloc*/
//                                If (i = ll_cnt) or (w_do.idw_pack.Find(lsFind,(i + 1),(ll_cnt + 1)) = 0) Then /*last row for the sku*/
//                                        //set order qty = shipped qty for row + (order - alloc) from detail. This assumes that the Shipped QTY on Packing List = Alloc QTY on DEtail. This will be validated before allowing to print (wf_val)
//                                        w_do.idw_packprint.setitem(j,"ord_qty",(w_do.idw_pack.getitemNumber(i,"quantity") + (w_do.idw_detail.getitemnumber(llRow,"req_qty") - w_do.idw_detail.getitemnumber(llRow,"alloc_qty"))))
//                                Else /* not last row for sku*/
//                                        w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_pack.getitemNumber(i,"quantity"))
//                                End If
//                        End If
//                Else /* ord qty will be set properly for Saltillo since only one qty per page */
//                        w_do.idw_packprint.setitem(j,"ord_qty", w_do.idw_detail.getitemnumber(llRow,"req_qty"))
//                End If
//                
//        Else /*row not found (should never happen), set req qty to 0*/
//                w_do.idw_packprint.setitem(j,"cntl_number",'')
//        End If
        
//        w_do.idw_packprint.setitem(j,"picked_quantity",w_do.idw_pack.getitemNumber(i,"quantity")) 
//	w_do.idw_packprint.setitem(j,"ordered_quantity",w_do.idw_detail.getitemnumber(llRow,"req_qty"))		  
//        
//     w_do.idw_packprint.setitem(j,"volume",w_do.idw_pack.getitemDecimal(i,"cbm")) 
//
//        
//        If w_do.idw_pack.getitemDecimal(i,"cbm") > 0 Then
//                w_do.idw_packprint.setitem(j,'dimensions',string(w_do.idw_pack.getitemDecimal(i,"length")) + ' x ' + string(w_do.idw_pack.getitemDecimal(i,"width")) + ' x ' + string(w_do.idw_pack.getitemDecimal(i,"height"))) /* 02/01 - PCONKL*/
//        End If
//        w_do.idw_packprint.setitem(j,"country_of_origin",w_do.idw_pack.getitemstring(i,"country_of_origin")) 
//        w_do.idw_packprint.setitem(j,"supp_code",w_do.idw_pack.getitemstring(i,"supp_code")) 
//        
//        // 10/07 - PCONKL - Get Serial Numbers from serial tab(Outbound)
//        If w_do.idw_serial.RowCount() > 0 Then
//                
//                lsSerial = ""
//                lsFind = "Upper(Carton_No) = '" + Upper(w_do.idw_Pack.GetItemString(i,'carton_no')) + "' and line_item_No = " + String(w_do.idw_Pack.GetITemNumber(i,'line_item_No'))
//                llFindRow = w_do.idw_serial.Find(lsFind,1,w_do.idw_serial.RowCOunt())
//                Do While llFindRow > 0
//                
//                        lsSerial += ", " + w_do.idw_serial.GetItemString(llFindRow,'serial_no')
//                
//                        llFindRow ++
//                        If llFindRow > w_do.idw_serial.RowCount() Then
//                                lLFindRow = 0
//                        Else
//                                llFindRow = w_do.idw_serial.Find(lsFind,llFindRow,w_do.idw_serial.RowCOunt())
//                        End If
//                
//                Loop
//                
//                If Left(lsSerial,2) = ', ' Then lsSerial = mid(lsSerial,3,999999999)
//                w_do.idw_packprint.setitem(j,"serial_no",lsSerial)
//        
//        End If /*serial numbers exist*/
//                
//        //idw_packprint.setitem(j,"serial_no",idw_pack.getitemstring(i,"free_form_serial_no")) /* 02/01 - PCONKL*/
//        
//        w_do.idw_packprint.setitem(j,"component_ind",w_do.idw_pack.getitemstring(i,"component_ind")) /* 02/01 - PCONKL - sort component master to top*/
//                
        w_do.idw_packprint.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        w_do.idw_packprint.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        w_do.idw_packprint.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        w_do.idw_packprint.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        w_do.idw_packprint.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        w_do.idw_packprint.setitem(j,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
        w_do.idw_packprint.setitem(j,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
        w_do.idw_packprint.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))

        w_do.idw_packprint.setitem(j,"payment_terms",w_do.idw_main.getitemstring(1,"shipping_instructions"))
      
		  
        // 07/00 PCONKL - Ship from info is coming from Project Table  
        w_do.idw_packprint.setitem(j,"ship_from_name",lsName)
        w_do.idw_packprint.setitem(j,"ship_from_address1",lsaddr1)
        w_do.idw_packprint.setitem(j,"ship_from_address2",lsaddr2)
        w_do.idw_packprint.setitem(j,"ship_from_address3",lsaddr3)
        w_do.idw_packprint.setitem(j,"ship_from_address4",lsaddr4)
        w_do.idw_packprint.setitem(j,"ship_from_city",lsCity)
        w_do.idw_packprint.setitem(j,"ship_from_state",lsstate)
        w_do.idw_packprint.setitem(j,"ship_from_zip",lszip)
        w_do.idw_packprint.setitem(j,"ship_from_country",lscountry)
		  
	
 
	     If lsNotes_Summary > '' Then
		  	 w_do.idw_packprint.setitem(j,"summary_note",lsNotes_Summary)
 		 End If      
				
				
Next /*PAcking Row */
 
i=1
FOR i = 1 TO UpperBound(ls_text[])
        w_do.idw_packprint.Modify(ls_text[i])
        ls_text[i]=""
NEXT

w_do.idw_packprint.SetSort("line_number A")
w_do.idw_packprint.Sort()
w_do.idw_packprint.GroupCalc()
 

 
// 09/04 - PCONKL - If we have a default printer for PackList, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','PACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

//Send the report to the Print report window
OpenWithParm(w_dw_print_options,w_do.idw_packprint) 
 
// 09/04 - PCONKL - We want to store the last printer used for Printing the Pack List for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','PACKLIST',lsPrinter)
 
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "I" Then 
                w_do.idw_main.SetItem(1,"ord_status","A")
                w_do.ib_changed = TRUE
                w_do.iw_window.trigger event ue_save()
        End If
End If
 
RETURN 0
end function

public function integer uf_packprint_phxbrands ();//BCR 18-AUG-2011: Customized print fxn for Rite Aid Packing List
//ET3 03-Apr-2012: Added customer Hancock to logic for Rite Aid

//// This function prints the Packing List for PhxBrands which is currently visible on the screen 
//// and not from the database 

 
Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos, llNotesCount, llNotesPos, ll_picked_qty, ll_ord_qty, llim_qty2
Decimal ld_weight, ld_costcenter
String ls_address,lsfind,ls_text[], lscusttype, lscustcode, lsSerial, lsNotes, ls_dono, lsim_uf11
String ls_project_id , ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName, lsDONO
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT, lsUPC, lsPrinter, lsVol, lsNativeDesc, lsGrp
String ls_d_packing_prt, ls_cust_name

Datastore       ldsHazmat, ldsNotes


//DataObject...
ls_d_packing_prt = 'd_packing_prt'

// pvh - 09/18/06 - Added packing print do to project table.
string PackDo
PackDo = g.getPackPrintDo()
w_do.idw_packprint.Dataobject = ls_d_packing_prt   //10/11/2010 ujh allow for dataobject with supplier column removed
if PackDo > '' then w_do.idw_packprint.Dataobject = PackDo

//Any Custom Packing Lists without custom logic (just logos, etc.)
IF Upper(gs_project) = 'PHXBRANDS' AND (Trim(w_do.idw_main.GetItemstring(1,"cust_code")) = "1021000002" OR Trim(w_do.idw_main.GetItemstring(1,"cust_code")) = "1021000004") THEN
	w_do.idw_packPrint.Dataobject = 'd_phxbrands_canadian_tire_packing_prt'
END IF

SetPointer(HourGlass!)
If w_do.idw_pack.AcceptText() = -1 Then
        w_do.tab_main.SelectTab(3) 
        w_do.idw_pack.SetFocus()
        Return 0
End If
 
If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
        Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
        Return 0
End If
 
//No row means no Print
ll_cnt = w_do.idw_pack.rowcount()
If ll_cnt = 0 Then
        MessageBox("Print Packing List"," No records to print!")
        Return 0
End If
 
//Clear the Report Window (hidden datawindow)
w_do.idw_packprint.Reset()
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// *** 07/09 - PCONKL - All baseline Packing Lists now pulling Ship From address fom Warehouse table.
// For those projects that were pulling from Project, the address info has been copied over 
// to the Warehouse table. This should be transparent to the users
       
lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")

Select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
Into    :lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
From warehouse
Where WH_Code = :lsWHCode
Using Sqlca;
 
// Get the cost center.
nvo_order lnvo_order
lnvo_order = Create nvo_order
lnvo_order.f_getcostcenter(1, ld_costcenter)
Destroy lnvo_order
 
//Loop through each row in Tab pages and grab the corresponding info
For i = 1 to ll_cnt
	
	ls_sku = w_do.idw_pack.getitemstring(i,"sku")
	ls_supplier = w_do.idw_pack.getitemstring(i,"supp_code")
	llLineItemNo = w_do.idw_pack.GetITemNumber(i,'line_item_no')
	
	//Is Customer Rite Aid?
	ls_cust_name = w_do.idw_main.getitemstring(1,"cust_name")
	
	IF ( Pos(UPPER(ls_cust_name), "RITE AID") = 0 ) AND (Pos(UPPER(ls_cust_name), "HANCOCK") = 0 ) THEN
		//Customer is NOT Rite Aid or Hancock. Insert new row
    	j = w_do.idw_packprint.InsertRow(0)
		w_do.idw_packprint.setitem(j,"picked_quantity",w_do.idw_pack.getitemNumber(i,"quantity"))
		w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_pack.getitemNumber(i,"quantity"))
		w_do.idw_packprint.setitem(j,"carton_no",w_do.idw_pack.getitemString(i,"carton_no"))
		w_do.idw_packprint.setitem(j,"volume",w_do.idw_pack.getitemDecimal(i,"cbm"))
		If w_do.idw_pack.getitemDecimal(i,"cbm") > 0 Then
      	w_do.idw_packprint.setitem(j,'dimensions',string(w_do.idw_pack.getitemDecimal(i,"length")) + ' x ' + string(w_do.idw_pack.getitemDecimal(i,"width")) + ' x ' + string(w_do.idw_pack.getitemDecimal(i,"height"))) 
      End If
	ELSE
		//Customer is either Rite Aid or Hancock. See if there's a row for this SKU already...
		lsFind = "Upper(sku) = '" + Upper(ls_sku) + "'"
      llRow = w_do.idw_packprint.Find(lsFind,1,w_do.idw_packprint.RowCount())
        
      IF llRow > 0 THEN
			//There is a row. Add to Picked and Order Qty...
			j = llRow
			ll_picked_qty = w_do.idw_packprint.getitemNumber(j,"picked_quantity")
			ll_ord_qty = w_do.idw_packprint.getitemNumber(j,"ord_qty")
			w_do.idw_packprint.setitem(j,"picked_quantity",w_do.idw_pack.getitemNumber(i,"quantity") + ll_picked_qty)
			w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_pack.getitemNumber(i,"quantity") + ll_ord_qty)
			w_do.idw_packprint.setitem(j,"carton_no",'') 
			w_do.idw_packprint.setitem(j,"volume",'0')
			w_do.idw_packprint.setitem(j,'dimensions','')
		ELSE
			//Insert new row for this SKU
    		j = w_do.idw_packprint.InsertRow(0)
			w_do.idw_packprint.setitem(j,"picked_quantity",w_do.idw_pack.getitemNumber(i,"quantity"))
			w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_pack.getitemNumber(i,"quantity"))
			w_do.idw_packprint.setitem(j,"carton_no",'') 
			w_do.idw_packprint.setitem(j,"volume",'0')
			w_do.idw_packprint.setitem(j,'dimensions','')
		END IF
	END IF
			
	//Get SKU, Description and Quantities  04/05/00 PCONKL - include user field5 as pdc_whse_loc
    // 02/02 - PConkl - include hazardous text cd
 
	If ls_SKU <> lsSKUHold Then
				 
				 select description, weight_1, hazard_text_cd, part_upc_Code, user_field8, native_description, grp, qty_2, user_field11    /* 05/09 - PCONKL - UF8 = Volume for Philips */ /* TAM W&S 2011/03 added qty2 and uf11 */
				 into :ls_description, :ld_weight, :lshazCode, :lsUPC, :lsVol, :lsnativeDesc, :lsGrp, :llim_qty2, :lsim_uf11
				 from item_master 
				 where project_id = :ls_project_id and sku = :ls_sku and supp_code = :ls_supplier ;
				 
	End If /*Sku Changed*/
	  
	lsSkuHold = ls_SKU

	ls_description = trim(ls_description)
      
	  // 02/02 PCONKL - If there is hazardous material text for this SKU/Ship Method, retrieve the text for the report
	  lshazText = ''
	  If lshazCode > '' Then /*haz text exists for this sku*/
				 llhazCount = ldsHazmat.Retrieve(gs_project,lshazCode,lsTransportMode)
				 If llHazCount > 0 Then
							For llHazPos = 1 to llHazCount
									  lsHazText += ldshazMat.GetItemString(llHazPos,'hazard_text') + '~r'
							Next
				 End If
	  End If /*haz text exists*/
	
	 w_do.idw_packprint.setitem(j,"ord_no",w_do.idw_main.getitemstring(1,"cust_order_no"))
	
	  w_do.idw_packprint.setitem(j,"costcenter", string(ld_costcenter))
	  w_do.idw_packprint.setitem(j,"bol_no",w_do.is_bolno)
	  w_do.idw_packprint.setitem(j,"freight_terms",w_do.idw_other.getitemstring(1,"freight_terms"))     
	  w_do.idw_packprint.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code")) 
	  w_do.idw_packprint.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
	  w_do.idw_packprint.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
	  w_do.idw_packprint.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
	  w_do.idw_packprint.setitem(j,"complete_date",w_do.idw_main.getitemdatetime(1,"complete_date"))
	  
	  //10/11/2010 ujh use variable to allow for dataobject with supplier column removed
	IF w_do.idw_packprint.Dataobject = ls_d_packing_prt THEN
			w_do.idw_packprint.setitem(j,"schedule_date",w_do.idw_main.getitemdatetime(1,"schedule_date"))			
	END IF
	  
	  w_do.idw_packprint.setitem(j,"sku",ls_sku)
	  w_do.idw_packprint.setitem(j,"description",ls_description)
	
	  w_do.idw_packprint.setitem(j,"standard_of_measure",w_do.idw_pack.getitemString(i,"standard_of_measure"))
	  
	//	  w_do.idw_packprint.setitem(j,"carrier", w_do.idw_other.getitemString(1,"carrier") )
	//nxjain Add hardcode value for WICO -020160503
	IF w_do.idw_other.getitemString(1,"carrier") = 'WICO' Then
    			 w_do.idw_packprint.setitem(j,"carrier", w_do.idw_other.getitemString(1,"carrier") + space(1)+"- CUST PKUP ") 
	Else
              w_do.idw_packprint.setitem(j,"carrier", w_do.idw_other.getitemString(1,"carrier"))
	End If

	//end Nxjain.
	  
	  w_do.idw_packprint.setitem(j,"ship_via",w_do.idw_other.getitemString(1,"ship_via")) 
	  w_do.idw_packprint.setitem(j,"sch_cd",w_do.idw_other.getitemString(1,"user_field1")) 
	  w_do.idw_packprint.setitem(j,"packlist_notes",w_do.idw_main.getitemString(1,"packlist_notes")) 
	  w_do.idw_packprint.setitem(j,"upc_Code",lsUPC) 
	  w_do.idw_packprint.setitem(j,"project_id",gs_project) 
	  w_do.idw_packprint.setitem(j,"HazText",lshazText) 
	
	  
	  //For English to Metrtics changes added L or K based on E or M
	  ls_etom=w_do.idw_packprint.getitemString(j,"standard_of_measure")
	  IF ls_etom <> "" and not isnull(ls_etom) and j=1 THEN
				 IF ls_etom = 'E' THEN
							ls_text[1]="unit_w_t.Text='"+w_do.is_text[1]+"L'"                    
							ls_text[2]="ext_w_t.Text='"+w_do.is_text[2]+"L'"
							ls_text[3]="etom_t.Text='INCHES'"
				 ELSE
							ls_text[1]="unit_w_t.Text='"+w_do.is_text[1]+"K'"
							ls_text[2]="ext_w_t.Text='"+w_do.is_text[2]+"K'"
					//Jxlim 08/24/2010 Modified for Chinese report		
					 If w_do.idw_packprint.Dataobject = 'd_packing_prt_chinese' Then	
								ls_text[3]="etom_t.Text='??'"
					Else
						ls_text[3]="etom_t.Text='CENTIMETERS'"
					End if
					//Jxlim 08/24/2010 End of modified for Chinese report
				 END IF
	  END IF  
	  
	  //BCR 23-AUG-2011: Not sure of the relevance/applicability of this whole code block...
	  
	  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	   // 5/4/00 PCONKL - find matching row in detail to get ordered quantity and CNTL Number
//        
//        // 09/01 - PCONKL - we may have multiple pack rows that match to a single detail row. THis will cause the Order qty
//        //                  to be wrong if we simply copy it for each row (it will be multiplied by each additional row). 
//        //                                                If the ordered qty on the order detail = the shipped qty, we will just set the ord qty = shipped qty
//        //                                                If Ord Qty > shipped qty, we will set the difference on the last row for the sku, the rest will be equal
//        //                                              This assumes that the Shipped QTY on Packing List = Alloc QTY on DEtail. This will be validated before allowing to print (wf_val)
//        
//        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLineItemNo)
//        llRow = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
//        
//        IF llRow > 0 THEN
//                
//             w_do.idw_packprint.setitem(j,"cntl_number",w_do.idw_detail.getitemString(llRow,"user_field1")) 
//             w_do.idw_packprint.setitem(j,"user_field2",w_do.idw_detail.getitemString(llRow,"user_field2")) 
//             w_do.idw_packprint.setitem(j,"alt_sku",w_do.idw_detail.getitemString(llRow,"alternate_sku"))
//   		     	
//			IF w_do.idw_detail.getitemnumber(llRow,"req_qty") = w_do.idw_detail.getitemnumber(llRow,"alloc_qty") THEN
//                  w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_pack.getitemNumber(i,"quantity"))
//			ELSE /*ord qty <> Alloc, if it's the last carton row for this sku, show the difference here, otherwise set to alloc*/
//				  If (i = ll_cnt) or (w_do.idw_pack.Find(lsFind,(i + 1),(ll_cnt + 1)) = 0) Then /*last row for the sku*/
//							 //set order qty = shipped qty for row + (order - alloc) from detail. This assumes that the Shipped QTY on Packing List = Alloc QTY on DEtail. This will be validated before allowing to print (wf_val)
//							 w_do.idw_packprint.setitem(j,"ord_qty",(w_do.idw_pack.getitemNumber(i,"quantity") + (w_do.idw_detail.getitemnumber(llRow,"req_qty") - w_do.idw_detail.getitemnumber(llRow,"alloc_qty"))))
//				  Else /* not last row for sku*/
//							 w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_pack.getitemNumber(i,"quantity"))
//				  End If
//			END IF
//                               
//	   ELSE /*row not found (should never happen), set req qty to 0*/
//                w_do.idw_packprint.setitem(j,"cntl_number",'')
//	   END IF
	  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	  
	  lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLineItemNo)
	  llRow = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
	  
	  if llRow > 0 Then
			 w_do.idw_packprint.setitem(j,"alt_sku",w_do.idw_detail.getitemString(llRow,"alternate_sku"))
	  End If 
	  
	  w_do.idw_packprint.setitem(j,"country_of_origin",w_do.idw_pack.getitemstring(i,"country_of_origin")) 
	  w_do.idw_packprint.setitem(j,"supp_code",w_do.idw_pack.getitemstring(i,"supp_code")) 
	  
	  // 10/07 - PCONKL - Get Serial Numbers from serial tab(Outbound)
	  If w_do.idw_serial.RowCount() > 0 Then
				 
				 lsSerial = ""
				 lsFind = "Upper(Carton_No) = '" + Upper(w_do.idw_Pack.GetItemString(i,'carton_no')) + "' and line_item_No = " + String(w_do.idw_Pack.GetITemNumber(i,'line_item_No'))
				 llFindRow = w_do.idw_serial.Find(lsFind,1,w_do.idw_serial.RowCOunt())
				 Do While llFindRow > 0
				 
							lsSerial += ", " + w_do.idw_serial.GetItemString(llFindRow,'serial_no')
				 
							llFindRow ++
							If llFindRow > w_do.idw_serial.RowCount() Then
									  lLFindRow = 0
							Else
									  llFindRow = w_do.idw_serial.Find(lsFind,llFindRow,w_do.idw_serial.RowCOunt())
							End If
				 
				 Loop
				 
				 If Left(lsSerial,2) = ', ' Then lsSerial = mid(lsSerial,3,999999999)
				 w_do.idw_packprint.setitem(j,"serial_no",lsSerial)
	  
	  End If /*serial numbers exist*/
				 
	  w_do.idw_packprint.setitem(j,"serial_no",w_do.idw_pack.getitemstring(i,"free_form_serial_no")) /* 02/01 - PCONKL*/
	  
	  w_do.idw_packprint.setitem(j,"component_ind",w_do.idw_pack.getitemstring(i,"component_ind")) /* 02/01 - PCONKL - sort component master to top*/
	  
	  w_do.idw_packprint.setitem(j,"unit_weight",w_do.idw_pack.getitemDecimal(i,"weight_net"))
	  w_do.idw_packprint.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
	  w_do.idw_packprint.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
	  w_do.idw_packprint.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
	  w_do.idw_packprint.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
	  w_do.idw_packprint.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
	  w_do.idw_packprint.setitem(j,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
	  w_do.idw_packprint.setitem(j,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
	  w_do.idw_packprint.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
	  
	  // 07/00 PCONKL - Ship from info is coming from Project Table  
	  w_do.idw_packprint.setitem(j,"ship_from_name",lsName)
	  w_do.idw_packprint.setitem(j,"ship_from_address1",lsaddr1)
	  w_do.idw_packprint.setitem(j,"ship_from_address2",lsaddr2)
	  w_do.idw_packprint.setitem(j,"ship_from_address3",lsaddr3)
	  w_do.idw_packprint.setitem(j,"ship_from_address4",lsaddr4)
	  w_do.idw_packprint.setitem(j,"ship_from_city",lsCity)
	  w_do.idw_packprint.setitem(j,"ship_from_state",lsstate)
	  w_do.idw_packprint.setitem(j,"ship_from_zip",lszip)
	  w_do.idw_packprint.setitem(j,"ship_from_country",lscountry)
	
	  w_do.idw_packprint.setitem(j,"staging_location",w_do.idw_pick.getitemstring(1,"staging_location"))
	  
	  IF w_do.idw_packprint.Dataobject = 'd_phxbrands_canadian_tire_packing_prt' THEN
	  
				 select alternate_sku
				 into :ls_alt_sku
				 from item_master 
				 where project_id = :ls_project_id and sku = :ls_sku and supp_code = :ls_supplier ;
	  
				 w_do.idw_packprint.setitem(j,"alt_sku",ls_alt_sku)
	
				 w_do.idw_packprint.setitem(j,"ship_ref", w_do.idw_other.getitemString(1,"ship_ref") )
				 w_do.idw_packprint.setitem(j,"User_Field7", w_do.idw_other.getitemString(1,"User_Field7") )
				 w_do.idw_packprint.setitem(j,"po_no", w_do.idw_pick.getitemString(1,"po_no") )

	 END IF
		         
Next /*PAcking Row */
 
i=1
FOR i = 1 TO UpperBound(ls_text[])
        w_do.idw_packprint.Modify(ls_text[i])
        ls_text[i]=""
NEXT
 
w_do.idw_packprint.Sort()
w_do.idw_packprint.GroupCalc()
 
//If we have a default printer for PackList, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','PACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

w_do.idw_packprint.Object.t_costcenter.Y= long(w_do.idw_packprint.Describe("costcenter.y")) 
 
//Send the report to the Print report window
OpenWithParm(w_dw_print_options,w_do.idw_packprint) 
 
//We want to store the last printer used for Printing the Pack List for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','PACKLIST',lsPrinter)
 
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "I" Then 
                w_do.idw_main.SetItem(1,"ord_status","A")
                w_do.ib_changed = TRUE
                w_do.iw_window.trigger event ue_save()
        End If
End If
 
RETURN 0


end function

public function integer uf_packprint_riverbed ();//Print the Riverbed packing slip

String                    dwsyntax_str, lsSQL, presentation_str, lsErrText,  lsWHCode, lsSOM, lsSerialNoSW,         lsSerialNoHW,&
                                                                lsSKU, lsSupplier, lsDesc, lsCityStateZip, lsdono, lsCartonSave, lsSubLine, lsSubItem, lsSubDesc, lsSubUOM, lsNoteText,          &
                                                                lsPickFind, lsPackFind, lsPrinter, lsPickFlag, lsDtlFind, lscartonno, lsSerialFilter, lsBOMFind, lsShipToCountry
String 				lsShip_from_address1, lsShip_from_address2, lsShip_from_address3, lsShip_from_address4
																 
Long                                      llLineITemNo, llRowCount, llRowPOs, llNewRow, llwarehouseRow, llNotesPos, llNotesCount, llSubQty, llPickFindRow, llPAckFindRow, &
                                                                llBomFindRow, llSerialPos, llSerialCount, llDtlFindRow, llchildqty, llBomCount
Dec                                        ldGrossWeight, ldNetWeight, ldVolume
Int                                          liCartonCount, liTotalSerialCount
Datastore            ldsNotes, ld_PackPrint, ldsBillToAddress, ldsBOM, ldsSerial
String lsTempSW, lsTempHW

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print (the data is coming from delivery Detail but we want to make sure the pack list is generated first)
llRowCount = w_do.idw_pack.rowcount()
If llRowCount = 0 Then
                MessageBox("Print Packing List"," No records to print!")
                Return 0
End If

SetPointer(Hourglass!)

lsDONO = w_do.idw_main.getitemstring(1,"do_no")
lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")

ld_packprint = Create Datastore
ld_packprint.dataobject ='d_riverbed_packing_prt'

w_main.SetMicroHelp("Retrieving Packing information...")

//Sort Order Detail by User Field 2 which is the SO line Number
w_do.Idw_Detail.SetSort("User_Field3 A")
w_do.idw_Detail.Sort()


//Bill To Address
ldsBillToAddress = Create DataStore
ldsBillToAddress.dataObject = 'd_do_address_alt'
ldsBillToAddress.SetTransObject(SQLCA)
ldsBillToAddress.Retrieve(lsdono, 'BT') /*Bill To Address*/

// Children components for Child Req Qty and Item Desc
ldsBOM = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select Line_Item_No, sku_parent, sku_child, child_qty, Delivery_Bom.user_field3, Delivery_Bom.user_field2, Description, Delivery_Bom.user_field4, Delivery_Bom.user_field5 from Delivery_Bom, Item_MAster " 
lsSQL += " Where do_no = '" + lsDONO + "' and Delivery_Bom.Project_ID = Item_master.Project_ID and sku_child = sku and supp_code_Child = supp_code "

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsBOM.Create( dwsyntax_str, lsErrText)
ldsBOM.SetTransObject(SQLCA)
ldsBom.Retrieve()
llBomCount =ldsBom.RowCount()

//Retrieve Serial Numbers for Order - Will Filter for child SKU and Line below
ldsSerial = Create Datastore
presentation_str = "style(type=grid)"
lsSQL = "Select LIne_Item_No, SKU, Delivery_Serial_Detail.Serial_No as 'serial_no_sw',Delivery_Serial_Detail.Mac_Id as 'serial_no_hw',  Delivery_Serial_Detail.Carton_No from Delivery_Picking_Detail, Delivery_Serial_Detail "
lsSQL += " Where Delivery_Picking_Detail.do_no = '" + lsDONO + "' and delivery_Picking_Detail.id_no = Delivery_Serial_Detail.ID_NO "

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsSerial.Create( dwsyntax_str, lsErrText)
ldsSerial.SetTransObject(SQLCA)
ldsSerial.Retrieve()

llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWHCode) + "'",1,g.ids_project_warehouse.rowCount())

//MikeA - JAN20 - S40930 - F20178 Riverbed Packing List Changes (Origin address for AU shipments)

lsShipToCountry = UPPER(TRIM( w_do.tab_main.tabpage_main.tab_address.tabpage_shipto.dw_shipto.GetItemString(1, "Country")))

IF lsShipToCountry = "AU" THEN

	lsShip_from_address1 = "Riverbed Technology Australia Pty Ltd"
	lsShip_from_address2 = "c/o Riverbed Technology Pte. Ltd"
	lsShip_from_address3 = "C/O GXO SG LOGISTICS"
	lsShip_from_address4 = "60 ALPS AVE"
	
ELSE
	
	lsShip_from_address1 = g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_1')
	lsShip_from_address2 = g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_2')
	lsShip_from_address3 = g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_3')
	lsShip_from_address4 = g.ids_project_warehouse.GetITemString(llWarehouseRow,'address_4')

END IF



//For each pack row, generate the pack data
llRowCount = w_do.idw_pack.RowCount()
////For each detail row, generate the pack data
//llRowCount = w_do.idw_detail.RowCount()
For llRowPOs = 1 to llRowCount
                
                w_main.SetMicroHelp("Printing Packing row " + String(llRowPOs) + " of " + String(llRowCount) + "...")

                lsSKU = w_do.idw_pack.getitemstring(llRowPos,"sku")
                lsSupplier = w_do.idw_pack.getitemstring(llRowPos,"supp_code")
                llLineItemNo = w_do.idw_pack.getitemNumber(llRowPos,"Line_Item_No")
                lscartonno = w_do.idw_pack.getitemString(llRowPos,"carton_no")
                                
                
                //Get The detail row for this pack row
                lsDtlFind = "Line_Item_no = " + String(llLineItemNo) + " and sku = '" + lsSku + "'"
                llDtlFindRow = w_do.idw_detail.Find(lsDtlFind,1,w_do.idw_detail.RowCount())
                If llDtlFindRow > 0 Then

                // Riverbed send a "shippable" flag stored in Detail Line Item Notes or BOM User Field3.  If this flag is "N" then we do not want to send this line
                // If found in Detail

                //            If POS(Trim(w_do.idw_detail.getitemstring(llRowPOs, "line_item_notes")), "IsPrintPackSlip:N") > 0 Then
                                //Skip Print if Detail not printable
                                If POS(Trim(w_do.idw_detail.getitemstring(llDtlFindRow, "line_item_notes")), "IsPrintPackingSlip:Y") > 0 Then
                
                                                llNewRow = ld_packprint.InsertRow(0)

                                //            If POS(Trim(w_do.idw_detail.getitemstring(llRowPOs, "line_item_notes")), "IsShippable:N") > 0 Then
                                                If POS(Trim(w_do.idw_detail.getitemstring(llDtlFindRow, "line_item_notes")), "IsShippable:N") > 0 Then
                                                                lsPickFlag='N'
                                                Else
                                                                lsPickFlag='Y'
                                                End If


                                                //Header level fields
				//Set Shipper Info from Warehouse table
	
										//MikeA - JAN20 - S40930 - F20178 Riverbed Packing List Changes (Origin address for AU shipments)	
										// Use the above variables
	
										ld_packprint.setitem(llNewRow,"ship_from_address1",lsShip_from_address1)
										ld_packprint.setitem(llNewRow,"ship_from_address2",lsShip_from_address2)
										ld_packprint.setitem(llNewRow,"ship_from_address3",lsShip_from_address3)
										ld_packprint.setitem(llNewRow,"ship_from_address4",lsShip_from_address4)
									
                                                ld_packprint.setitem(llNewRow,"ship_from_state", g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
                                                ld_packprint.setitem(llNewRow,"ship_from_city",g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
                                                ld_packprint.setitem(llNewRow,"ship_from_zip",g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
                                                ld_packprint.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
                                                ld_packprint.setitem(llNewRow,"cust_order_no",w_do.idw_main.getitemstring(1,"cust_order_no"))
                                                ld_packprint.setitem(llNewRow,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
                                                ld_packprint.setitem(llNewRow,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
                                                ld_packprint.setitem(llNewRow,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
                                                ld_packprint.setitem(llNewRow,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
                                                ld_packprint.setitem(llNewRow,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
                                                ld_packprint.setitem(llNewRow,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
                                                ld_packprint.setitem(llNewRow,"city",w_do.idw_main.getitemstring(1,"city"))
                                                ld_packprint.setitem(llNewRow,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
                                                ld_packprint.setitem(llNewRow,"country",w_do.idw_main.getitemstring(1,"country"))
                                                ld_packprint.setitem(llNewRow,"complete_date",w_do.idw_main.getitemDateTime(1,"complete_date"))
                                                ld_packprint.setitem(llNewRow,"ship_id",w_do.idw_other.getitemString(1,"user_field9"))
                                                ld_packprint.setitem(llNewRow,"transport_mode",w_do.idw_main.GetITemString(1,'ship_ref'))
                                                ld_packprint.setitem(llNewRow,'packlist_notes', w_do.idw_Main.GetITemString(1,'packlist_notes'))
                                                ld_packprint.setitem(llNewRow,"order_number",w_do.idw_main.getitemstring(1,"Invoice_no"))
                                                ld_packprint.setitem(llNewRow,'awb_bol_no', w_do.idw_Main.GetITemString(1,'awb_bol_no'))
                                                ld_packprint.setitem(llNewRow,'contact_person', w_do.idw_Main.GetITemString(1,'contact_person'))
                                                ld_packprint.setitem(llNewRow,'tel', w_do.idw_Main.GetITemString(1,'tel'))
											//SARUN2014June30 : Added tax for Riverbed PackList
							                ld_packprint.setitem(llNewRow,'pack_instruction', "Riverbed renamed our products to reinforce their inter-relatedness as part of an interoperable portfolio of products we call the Riverbed Application Performance Platform. Please use the product SKU numbers (rather than product names) to verify that the hardware and/or software you purchase and receive is accurate. To learn more - visit http://www.riverbed.com/products/#Product_List.")

                                                //Details Info...
                                                ld_packprint.setitem(llNewRow,"delivery_packing_line_item_no",llLineItemNo)
                                                ld_packprint.setitem(llNewRow,"sku",lsSKU)
                                //                ld_packprint.setitem(llNewRow,"alt_sku",w_do.idw_detail.GetITemString(llRowPos,'alternate_sku'))
                                //            ld_packprint.setitem(llNewRow,"uom",w_do.idw_detail.getitemstring(llRowPos,"uom"))
                                //                ld_packprint.setitem(llNewRow,"qty_shipped",w_do.idw_detail.getitemNumber(llRowPos,"req_qty"))
                                                ld_packprint.setitem(llNewRow,"alt_sku",w_do.idw_detail.GetITemString(llDtlFindRow,'alternate_sku'))
                                                ld_packprint.setitem(llNewRow,"uom",w_do.idw_detail.getitemstring(llDtlFindRow,"uom"))
                //                            ld_packprint.setitem(llNewRow,"qty_shipped",w_do.idw_detail.getitemNumber(llDtlFindRow,"req_qty"))
                                                ld_packprint.setitem(llNewRow,"qty_shipped",w_do.idw_pack.getitemNumber(llRowPos,"quantity"))
                                                ld_packprint.setitem(llNewRow,"pick_flag",lsPickFlag)  
                                                ld_packprint.setitem(llNewRow,"carton",w_do.idw_pack.getitemString(llRowPos,"carton_no"))
                                                ld_packprint.setitem(llNewRow,"user_field2",w_do.idw_detail.getitemstring(llDtlFindRow,"user_Field2"))
                
                                                //We need the Decription from Item MAster
                                                Select Description into :lsDesc
                                                From Item_Master
                                                Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
                                
                                                ld_packprint.setitem(llNewRow,"description",lsDesc)
                                

                                                //Add any serial numbers from serial table (this would be only for Pickable LInes - no children)
                                                lsSerialNoSW = ""
                                                lsSerialNoHW = ""
                                                
                                                //Filter for Line/SKU
                                                lsSerialFilter = "Line_Item_No = " + String(llLineItemNo) + " and sku = '" + lsSKU + "' and carton_no = '" + lscartonno + "'"
                //                            ldsSerial.SetFilter("Line_Item_No = " + String(llLineItemNo) + " and sku = '" + lsSKU + "' and carton_no = '" + lscartonno + "'")
                                                ldsSerial.SetFilter(lsSerialFilter)
                                                ldsSerial.Filter()
                                                llSerialCOunt = ldsSerial.RowCount()
                                                
                                                If lLSerialCount > 0 Then
                                           									
													liTotalSerialCount = 0										 
																							 
                                                                For llSerialPos = 1 to lLSerialCount
																		
																   liTotalSerialCount = liTotalSerialCount + 1
																  
																   IF liTotalSerialCount > 5 then
																	
																	liTotalSerialCount = 1
																	
																	lsSerialNoSW += char(13) + char(10) + "                  "
																	lsSerialNoHW += char(13) + char(10) + "                  "
																	
																   End IF
																		
                                                                                lsSerialNoSW += ldsSerial.GetITemString(llSerialPOs,'serial_No_sw') + ", "
                                                                                lsSerialNoHW += ldsSerial.GetITemString(llSerialPOs,'serial_No_hw') + ", "           

                                                                Next/*Next serial*/
                                                                
													//Sept 18 - MEA - F10763 - I1596 - RVS - Increase serial number height								 
																					 
                                                                ld_packPrint.SetITem(llNewRow, 'serial_no_sw', "SW Serial: " + Left(lsSerialNoSW,Len(lsSerialNoSW) - 2)) /*strip off last comma*/
                                                                ld_packPrint.SetITem(llNewRow, 'serial_no_hw', "HW Serial: " + Left(lsSerialNoHW,Len(lsSerialNoHW) - 2)) /*strip off last comma*/
																					 
														lsTempSW = ld_packprint.getitemstring(llNewRow,'serial_no_sw')
  														lsTempHW = ld_packprint.getitemstring(llNewRow,'serial_no_hw')
                              
										Else
										  
//										  	ld_packPrint.SetITem(llNewRow, 'serial_no_sw', "SW Serial:") 
//                                                 	ld_packPrint.SetITem(llNewRow, 'serial_no_hw', "HW Serial: ") 
                                	
										  
                                                End If /*Serials exist*/
											
																
                                //Skip Print if Detail not printable
                                End If                    
                
                                //Add any pickable children items if this is a parent - This should be exclusive from being printed as notes above
                                lsPickFind = "Line_Item_no = " + String(llLineItemNo) + " and sku_parent <> sku"
                                llPickFindRow = w_do.idw_Pick.Find(lsPickFind,1,w_do.idw_Pick.RowCount())
//                            lsBomFind = "Line_Item_no = " + String(llLineItemNo) + " and sku_parent = '" + w_do.idw_pack.GetITemString(llRowPos,'sku') + "'"
//                            llBomFindRow = ldsBom.Find(lsBomFind,1,ldsBom.RowCount())
//                            llBomFindRow = ldsBom.Find("Line_Item_no = " + String(llLineItemNo) + " and sku_parent = '" + w_do.idw_pack.GetITemString(llRowPos,'sku') + "'",1,ldsBom.RowCount())
                                Do While llPickFindRow > 0
//                            Do While llBOMFindRow > 0
                                
  // TAM 2012/02/03  - Look if Pick row was already printed for this carton.  If it was then we need to skip it.  There may be more than one location picked which yeilds more than pick row
  // and consequently mor than one line on the picklist for this sku.
                                      lsPackFind = "delivery_packing_Line_item_no = " + String(llLineItemNo) + " and sku = '" + w_do.idw_pick.GetITemString(llPickFindRow,'sku') + "' and carton = '" + lscartonno + "'"
									string			  lsfindsku
									lsfindsku = w_do.idw_pick.GetITemString(llPickFindRow,'sku')
                                      llPackFindRow = ld_packprint.Find(lsPackFind,1,ld_packprint.RowCount())
                                      // If Pack row is found for this cartin then skip printing
                                      If llPackFindRow < 1  Then

																
										   lsBomFind = "Line_Item_no = " + String(llLineItemNo) + " and sku_child = '" + w_do.idw_pick.GetITemString(llPickFindRow,'sku') + "'"
                                                llBomFindRow = ldsBom.Find(lsBomFind,1,ldsBom.RowCount())
                                                // BOM is Printable
                                                If llBomFindRow > 0 and POS(Trim(ldsBOM.getitemstring(llBomFindRow, "user_field3")), "IsPrintPackingSlip:Y") > 0 Then
                                                
                                                //Header level fields
                
                                                //Set Shipper Info from Warehouse table
                                                                llNewRow = ld_packprint.InsertRow(0)

													//MikeA - JAN20 - S40930 - F20178 Riverbed Packing List Changes (Origin address for AU shipments)	
													// Use the above variables

													ld_packprint.setitem(llNewRow,"ship_from_address1",lsShip_from_address1)
													ld_packprint.setitem(llNewRow,"ship_from_address2",lsShip_from_address2)
													ld_packprint.setitem(llNewRow,"ship_from_address3",lsShip_from_address3)
													ld_packprint.setitem(llNewRow,"ship_from_address4",lsShip_from_address4)
														
                                                                ld_packprint.setitem(llNewRow,"ship_from_state",g.ids_project_warehouse.GetITemString(llWarehouseRow,'state'))
                                                                ld_packprint.setitem(llNewRow,"ship_from_city",g.ids_project_warehouse.GetITemString(llWarehouseRow,'city'))
                                                                ld_packprint.setitem(llNewRow,"ship_from_zip",g.ids_project_warehouse.GetITemString(llWarehouseRow,'zip'))
                                                                ld_packprint.setitem(llNewRow,"ship_from_country",g.ids_project_warehouse.GetITemString(llWarehouseRow,'country'))
                                                                ld_packprint.setitem(llNewRow,"cust_order_no",w_do.idw_main.getitemstring(1,"cust_order_no"))
                                                                ld_packprint.setitem(llNewRow,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
                                                                ld_packprint.setitem(llNewRow,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
                                                                ld_packprint.setitem(llNewRow,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
                                                                ld_packprint.setitem(llNewRow,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
                                                                ld_packprint.setitem(llNewRow,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
                                                                ld_packprint.setitem(llNewRow,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
                                                                ld_packprint.setitem(llNewRow,"city",w_do.idw_main.getitemstring(1,"city"))
                                                                ld_packprint.setitem(llNewRow,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
                                                                ld_packprint.setitem(llNewRow,"country",w_do.idw_main.getitemstring(1,"country"))
                                                                ld_packprint.setitem(llNewRow,"complete_date",w_do.idw_main.getitemDateTime(1,"complete_date"))
                                                                ld_packprint.setitem(llNewRow,"ship_id",w_do.idw_other.getitemString(1,"user_field9"))
                                                                ld_packprint.setitem(llNewRow,"transport_mode",w_do.idw_main.GetITemString(1,'ship_ref'))
                                                                ld_packprint.setitem(llNewRow,'packlist_notes', w_do.idw_Main.GetITemString(1,'packlist_notes'))
                                                                ld_packprint.setitem(llNewRow,"order_number",w_do.idw_main.getitemstring(1,"Invoice_no"))
                                                                ld_packprint.setitem(llNewRow,'awb_bol_no', w_do.idw_Main.GetITemString(1,'awb_bol_no'))
                                             				 ld_packprint.setitem(llNewRow,'contact_person', w_do.idw_Main.GetITemString(1,'contact_person'))
                                        					    	 ld_packprint.setitem(llNewRow,'tel', w_do.idw_Main.GetITemString(1,'tel'))
														//SARUN2014June30 : Added tax for Riverbed PackList																					
														 ld_packprint.setitem(llNewRow,'pack_instruction', "Riverbed renamed our products to reinforce their inter-relatedness as part of an interoperable portfolio of products we call the Riverbed Application Performance Platform. Please use the product SKU numbers (rather than product names) to verify that the hardware and/or software you purchase and receive is accurate. To learn more - visit http://www.riverbed.com/products/#Product_List.")																																										
//                                                            ld_packPrint.RowsCopy(llNewRow,llNewRow,Primary!,ld_packPrint,999999,Primary!)
//                                                            llNewRow = ld_packPrint.RowCount()
                                                
                                                                ld_packprint.setitem(llNewRow,"serial_no_sw","")
                                                                ld_packprint.setitem(llNewRow,"serial_no_hw","")
                                                                ld_packprint.setitem(llNewRow,"delivery_packing_Line_item_no",llLineItemNo)
                                                                ld_packprint.setitem(llNewRow,"sku",w_do.idw_pick.GetITemString(llPickFindRow,'sku'))
//                                                                ld_packprint.setitem(llNewRow,"alt_sku",w_do.idw_pick.GetITemString(llPickFindRow,'sku'))
                                                                ld_packprint.setitem(llNewRow,"alt_sku",ldsBom.GetITemString(llBomFindRow,'user_field5'))
                                                                ld_packprint.setitem(llNewRow,"uom",w_do.idw_detail.getitemstring(llDtlFindRow,"UOM"))
                                                                llchildqty = ldsBom.GetITemNumber(llBomFindRow,'child_Qty') * w_do.idw_pack.GetITemNUmber(llRowPos,'quantity')
                                                                ld_packprint.setitem(llNewRow,"qty_shipped",llchildqty)
                                                                ld_packprint.setitem(llNewRow,"Description",ldsBom.GetITemString(llBomFindRow,'Description'))
                                                                If POS(Trim(ldsBOM.getitemstring(llBomFindRow, "user_field3")), "IsShippable:N") > 0 Then
                                                                                lsPickFlag = 'N'
                                                                Else
                                                                                lsPickFlag = 'Y'
                                                                End If
                                                                ld_packprint.setitem(llNewRow,"pick_flag",lspickflag)
                                                                ld_packprint.setitem(llNewRow,"carton",w_do.idw_pack.getitemString(llRowPos,"carton_no"))
                                                                ld_packprint.setitem(llNewRow,"user_field2",ldsBOM.GetItemString(llBOMFindRow,"user_Field4"))
                
                                                                                                
                                                                //TODO - add serial numbers for child */
                                                                lsSerialNoSW = ""
                                                                lsSerialNoHW = ""
                                                
                                                                //Filter for Line/SKU
                                                                ldsSerial.SetFilter("Line_Item_No = " + String(llLineItemNo) + " and sku = '" + w_do.idw_pick.GetITemString(llPickFindRow,'sku') + "' and carton_no = '" + lscartonno + "'")
                                                                ldsSerial.Filter()
                                                                llSerialCOunt = ldsSerial.RowCount()
                                                
                                                                If lLSerialCount > 0 Then
                                                                
                                                                                For llSerialPos = 1 to lLSerialCount
                                                                                                lsSerialNoSW += ldsSerial.GetITemString(llSerialPOs,'serial_No_sw') + ", "
                                                                                                lsSerialNoHW += ldsSerial.GetITemString(llSerialPOs,'serial_No_hw') + ", "
                                                                                Next/*Next serial*/
                                                                
                                                                                ld_packPrint.SetITem(llNewRow, 'serial_no_sw',Left(lsSerialNoSW,Len(lsSerialNoSW) - 2)) /*strip off last comma*/
                                                                                ld_packPrint.SetITem(llNewRow, 'serial_no_hw',Left(lsSerialNoHW,Len(lsSerialNoHW) - 2)) /*strip off last comma*/

                                                                
                                                                End If /*Serials exist*/
                                
                                                // BOM is Printable
                                                End If
//TAM 2012/02/03
                           			// Pick Row already printed
									End If

                                                //Find next child Picking row
                                                If llPickFindRow = w_do.idw_pick.RowCount() Then
                                                                llPickFindRow = 0
                                                Else
                                                                llPickFindRow ++
                                                                llPickFindRow = w_do.idw_Pick.Find(lsPickFind,llPickFindRow,w_do.idw_Pick.RowCount())
                                                End If
                                                //Find next child Picking row
//                                            If llBOMFindRow = ldsBOM.RowCount() Then
//                                                            llBOMFindRow = 0
//                                            Else
//                                                            llBOMFindRow ++
//                                                            llBOMFindRow = ldsBOM.Find(lsBOMFind,llBOMFindRow,ldsBOM.RowCount())
//                                            End If

                                
                                Loop /*Next child Picking record for parent*/
                End If
                
Next /*Pack row*/

//Sort report by pickable
ld_packPrint.SetSort("carton A, pick_flag D, user_field2 A" )
ld_packPrint.Sort()

//Because this is an External DW, need to do a GroupCalc to enable grouping to work well (unlike if it were a dw with Retrieve)...
ld_packprint.GroupCalc()

//Resort the detail tab back to default
w_do.Idw_Detail.SetSort("Line_Item_No A, SKU A")
w_do.idw_Detail.Sort()

OpenWithParm(w_dw_print_options,ld_packprint) 

//We want to store the last printer used for Printing the Pack List for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','PACKLIST',lsPrinter)

Return 0

end function

public function integer uf_packprint_geistlich ();//BCR 21-NOV-2011: Print the Geistlich packing slip


Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos, llNotesCount, llNotesPos
Decimal ld_weight, ld_costcenter
String ls_address,lsfind,ls_text[], lscusttype, lscustcode, lsSerial, lsNotes
String ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName, lsDONO
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT, lsUPC, lsPrinter, lsVol, lsNativeDesc, lsGrp
String ls_d_packing_prt, lsim_uf11, ls_dono,ls_Serialized_Ind
Long llim_qty2, llRowCount, llRowPOs, llNewRow,llRowserial

Datastore       ldsHazmat, ld_packprint


If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print (the data is coming from deliveryy Detail but we want to make sure the pack list is generated first)
llRowCount = w_do.idw_pack.rowcount()
If llRowCount = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

SetPointer(Hourglass!)

ld_packprint = Create Datastore
ld_packprint.dataobject ='d_geistlich_packing_prt'

//Get Ship From info from Warehouse table...
lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")

If upper(lsWHCode) ='GEIST-SPA' Then lsWHCode ='GEIST-DAY' //03-May-2017 :Madhu PEVS-535 -Print Pack List with Dayton Address.
 
        
        Select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
        Into    :lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
        From warehouse
        Where WH_Code = :lsWHCode
        Using Sqlca;

//For each detail row, generate the pack data

//llRowCount = w_do.idw_detail.RowCount() //5-Dec-2016 Madhu - commented to get rowcount from pack list.

For llRowPOs = 1 to llRowCount
	
	llNewRow = ld_packprint.InsertRow(0)
	
        //Get SKU, Description and Quantities  
        
        ls_sku = w_do.idw_pack.getitemstring(llRowPOs,"sku")
        ls_supplier = w_do.idw_pack.getitemstring(llRowPOs,"supp_code")
        llLineItemNo = w_do.idw_pack.GetITemNumber(llRowPOs,'line_item_no')
        
        If ls_SKU <> lsSKUHold Then
                
                select description, weight_1, hazard_text_cd, part_upc_Code, user_field8, native_description, grp, qty_2, user_field11    /* 05/09 - PCONKL - UF8 = Volume for Philips */ /* TAM W&S 2011/03 added qty2 and uf11 */
                into :ls_description, :ld_weight, :lshazCode, :lsUPC, :lsVol, :lsnativeDesc, :lsGrp, :llim_qty2, :lsim_uf11
                from item_master 
                where project_id = :gs_project and sku = :ls_sku and supp_code = :ls_supplier 
			   using Sqlca;
                
        End If /*Sku Changed*/
        
        lsSkuHold = ls_SKU
	    
	   ls_description = trim(ls_description)
			
        // 02/02 PCONKL - If there is hazardous material text for this SKU/Ship Method, retrieve the text for the report
        lshazText = ''
        If lshazCode > '' Then /*haz text exists for this sku*/
                llhazCount = ldsHazmat.Retrieve(gs_project,lshazCode,lsTransportMode)
                If llHazCount > 0 Then
                        For llHazPos = 1 to llHazCount
                                lsHazText += ldshazMat.GetItemString(llHazPos,'hazard_text') + '~r'
                        Next
                End If
        End If /*haz text exists*/
        
        //Set all Items on the Report by grabbing info from tab pages
		
	   ld_packprint.setitem(llNewRow,"ord_no",w_do.idw_main.getitemstring(1,"cust_order_no"))	
        ld_packprint.setitem(llNewRow,"costcenter", string(ld_costcenter))
        ld_packprint.setitem(llNewRow,"carton_no",w_do.idw_pack.getitemString(llRowPOs,"carton_no")) 
        ld_packprint.setitem(llNewRow,"bol_no",w_do.is_bolno)
        ld_packprint.setitem(llNewRow,"freight_terms",w_do.idw_other.getitemstring(1,"freight_terms"))     
        ld_packprint.setitem(llNewRow,"cust_code",w_do.idw_main.getitemstring(1,"cust_code")) 
        ld_packprint.setitem(llNewRow,"city",w_do.idw_main.getitemstring(1,"city"))
        ld_packprint.setitem(llNewRow,"country",w_do.idw_main.getitemstring(1,"country"))
        ld_packprint.setitem(llNewRow,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
        ld_packprint.setitem(llNewRow,"complete_date",w_do.idw_main.getitemdatetime(1,"complete_date"))  
	   ld_packprint.setitem(llNewRow,"schedule_date",w_do.idw_main.getitemdatetime(1,"schedule_date"))			
        ld_packprint.setitem(llNewRow,"sku",ls_sku)
        ld_packprint.setitem(llNewRow,"description",ls_description)
 	   ld_packprint.setitem(llNewRow,"net_wgt",w_do.idw_pack.getitemDecimal(llRowPOs,"weight_net")) 
	   ld_packprint.setitem(llNewRow,"gross_wgt",w_do.idw_pack.getitemDecimal(llRowPOs,"weight_gross"))
        ld_packprint.setitem(llNewRow,"standard_of_measure",w_do.idw_pack.getitemString(llRowPOs,"standard_of_measure"))
        ld_packprint.setitem(llNewRow,"carrier", w_do.idw_other.getitemString(1,"carrier") )
        ld_packprint.setitem(llNewRow,"ship_via",w_do.idw_other.getitemString(1,"ship_via")) 
        ld_packprint.setitem(llNewRow,"sch_cd",w_do.idw_other.getitemString(1,"user_field1")) 
        ld_packprint.setitem(llNewRow,"packlist_notes",w_do.idw_main.getitemString(1,"packlist_notes"))
        ld_packprint.setitem(llNewRow,"project_id",gs_project)
        ld_packprint.setitem(llNewRow,"HazText",lshazText) 
        ld_packprint.setitem(llNewRow,"user_field8",w_do.idw_other.getitemString(1,"user_field8")) //TAM 04/2013
	//  ld_packprint.setitem(llNewRow,"user_field18",w_do.idw_other.getitemString(1,"user_field18")) //TAM 04/2013

        ld_packprint.setitem(llNewRow,"user_field19",w_do.idw_other.getitemString(1,"user_field19"))



        //For English to Metrtics changes added L or K based on E or M
        ls_etom=ld_packprint.getitemString(llNewRow,"standard_of_measure")
        IF ls_etom <> "" and not isnull(ls_etom) and llNewRow=1 THEN
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
             
		//ld_packprint.setitem(llNewRow,"lot_nbr",w_do.idw_pack.getitemstring(llRowPOs,"user_field1")) //28-Oct-2016 Madhu- commented & use PackLotNo instead UF1
		ld_packprint.setitem(llNewRow,"lot_nbr",w_do.idw_pack.getitemstring(llRowPOs,"pack_lot_no")) //28-Oct-2016 Madhu- Populate LotNo value from PackLotNo
		ld_packprint.setitem(llNewRow,"picked_quantity",w_do.idw_pack.getitemNumber(llRowPOs,"quantity")) 
		ld_packprint.setitem(llNewRow,"volume",w_do.idw_pack.getitemDecimal(llRowPOs,"cbm")) 
		ld_packprint.setitem(llNewRow,"uom",w_do.idw_detail.getitemString(llRowPOs,"uom"))
       
        If w_do.idw_pack.getitemDecimal(llRowPOs,"cbm") > 0 Then
                ld_packprint.setitem(llNewRow,'pack_size',string(w_do.idw_pack.getitemDecimal(llRowPOs,"length")) + ' x ' + string(w_do.idw_pack.getitemDecimal(llRowPOs,"width")) + ' x ' + string(w_do.idw_pack.getitemDecimal(llRowPOs,"height"))) /* 02/01 - PCONKL*/
        End If
        ld_packprint.setitem(llNewRow,"country_of_origin",w_do.idw_pack.getitemstring(llRowPOs,"country_of_origin")) 
        ld_packprint.setitem(llNewRow,"supp_code",w_do.idw_pack.getitemstring(llRowPOs,"supp_code")) 
        
		  
		//select Serialized_Ind into :ls_Serialized_Ind from Item_Master where Project_Id=:gs_project and SKU=:ls_sku;
		
	//if ls_Serialized_Ind= 'B' then 
		
        // 10/07 - PCONKL - Get Serial Numbers from serial tab(Outbound)
        If w_do.idw_serial.RowCount() > 0 Then
                
                lsSerial = ""
                lsFind = "Upper(Carton_No) = '" + Upper(w_do.idw_Pack.GetItemString(llRowPOs,'carton_no')) + "' and line_item_No = " + String(w_do.idw_Pack.GetITemNumber(llRowPOs,'line_item_No'))
                llFindRow = w_do.idw_serial.Find(lsFind,1,w_do.idw_serial.RowCOunt())
                Do While llFindRow > 0
                
                        lsSerial += ", " + w_do.idw_serial.GetItemString(llFindRow,'serial_no')
                
                        llFindRow ++
                        If llFindRow > w_do.idw_serial.RowCount() Then
                                lLFindRow = 0
                        Else
                                llFindRow = w_do.idw_serial.Find(lsFind,llFindRow,w_do.idw_serial.RowCOunt())
                        End If
                
                Loop
                
                If Left(lsSerial,2) = ', ' Then lsSerial = mid(lsSerial,3,999999999)
                ld_packprint.setitem(llNewRow,"serial_no",lsSerial)
        
        End If /*serial numbers exist*/
		  
	//elseif ls_Serialized_Ind= 'Y' then

		// Begin - 07/27/2022 - Dinesh - SIMS-34- Get Serial Numbers from pick tab(Outbound)
		
		
        //  Get Serial Numbers from inbound tab(Outbound)
        If w_do.idw_pick.RowCount() > 0 Then
                
                lsSerial = ""
                lsFind = "line_item_No = " + String(w_do.idw_Pack.GetITemNumber(llRowPOs,'line_item_No'))
                llFindRow = w_do.idw_pick.Find(lsFind,1,w_do.idw_pick.RowCOunt())
                Do While llFindRow > 0
                
                        lsSerial += ", " + w_do.idw_pick.GetItemString(llFindRow,'serial_no')
                
                        llFindRow ++
                        If llFindRow > w_do.idw_pick.RowCount() Then
                                lLFindRow = 0
                        Else
                                llFindRow = w_do.idw_pick.Find(lsFind,llFindRow,w_do.idw_pick.RowCOunt())
                        End If
                
                Loop
                
                If Left(lsSerial,2) = ', ' Then lsSerial = mid(lsSerial,3,999999999)
                ld_packprint.setitem(llNewRow,"serial_no",lsSerial)
        
        End If /*serial numbers exist*/
		  
	//End if
							
//			 lsSerial =  w_do.idw_pick.GetItemString(llRowPOs,'serial_no')               
//			 ld_packprint.setitem(llNewRow,"serial_no",lsSerial)  

		// End - 07/27/2022 - Dinesh -SIMS-34- Get Serial Numbers from pick tab(Outbound)
       
        ld_packprint.setitem(llNewRow,"component_ind",w_do.idw_pack.getitemstring(llRowPOs,"component_ind")) /* 02/01 - PCONKL - sort component master to top*/
                
        ld_packprint.setitem(llNewRow,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        ld_packprint.setitem(llNewRow,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        ld_packprint.setitem(llNewRow,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        ld_packprint.setitem(llNewRow,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        ld_packprint.setitem(llNewRow,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        ld_packprint.setitem(llNewRow,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
        ld_packprint.setitem(llNewRow,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
        ld_packprint.setitem(llNewRow,"remark",w_do.idw_main.getitemstring(1,"remark"))
        
        // 07/00 PCONKL - Ship from info is coming from Project Table  
        ld_packprint.setitem(llNewRow,"ship_from_name",lsName)
        ld_packprint.setitem(llNewRow,"ship_from_address1",lsaddr1)
        ld_packprint.setitem(llNewRow,"ship_from_address2",lsaddr2)
        ld_packprint.setitem(llNewRow,"ship_from_address3",lsaddr3)
        ld_packprint.setitem(llNewRow,"ship_from_address4",lsaddr4)
        ld_packprint.setitem(llNewRow,"ship_from_city",lsCity)
        ld_packprint.setitem(llNewRow,"ship_from_state",lsstate)
        ld_packprint.setitem(llNewRow,"ship_from_zip",lszip)
        ld_packprint.setitem(llNewRow,"ship_from_country",lscountry)
		  
		
 	         
Next /*PAcking Row */
 
i=1
FOR i = 1 TO UpperBound(ls_text[])
        ld_packprint.Modify(ls_text[i])
        ls_text[i]=""
NEXT
 
ld_packprint.Sort()
ld_packprint.GroupCalc()
 
// 09/04 - PCONKL - If we have a default printer for PackList, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','PACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

ld_packprint.Object.t_costcenter.Y= long(ld_packprint.Describe("costcenter.y"))
 
//Send the report to the Print report window
OpenWithParm(w_dw_print_options,ld_packprint) 
 
// 09/04 - PCONKL - We want to store the last printer used for Printing the Pack List for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','PACKLIST',lsPrinter)
 
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "I" Then 
                w_do.idw_main.SetItem(1,"ord_status","A")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If
 
Return 0
end function

public function integer uf_packprint_nike ();
// 12/11 - PCONKL - Plageurized from Nike EWMS

Long i, j, ll_row, ll_cnt, ll_item, ll_qty, ll_ctn_row, ll_tot_qty, col
long max_size_col,ll_coocnt
String ls_sku, ls_size, ls_style, ls_prev_style, lsSuppCode, lsOrderNbr
String ls_cust_name, ls_cust_add1, ls_cust_add2, ls_cust_add3, ls_cust_add4, ls_remark
String ls_dono,ls_division,ls_address_2,ls_address_3
string ls_ctn_no ,ls_prev_ctn_no,ls_coo

String ls_whcode
String ls_do_no
OLEObject xl, xs
String filename
String lineout[1 to 11]
Long pos

ls_whcode = w_do.idw_Main.GetItemString(1, "wh_code")
ls_do_no =   w_do.idw_Main.GetItemString(1, "do_no")
lsOrderNbr =   w_do.idw_Main.GetItemString(1, "invoice_no")

                      
//  Retrieve Packing list 
ll_cnt = w_do.idw_Pack.Retrieve(ls_do_no,ls_whcode)
If ll_cnt < 1 Then 
	MessageBox("Pack List", "No records found!")
	Return 0
End If
         
//If w_do.idw_Pack.AcceptText() = -1 Then Return
w_do.idw_Pack.Sort()


//SELECT ship_to_name,name_or_address,addresss,city,postal_code,remark,address_2,address_3
//		Into :ls_cust_name,:ls_cust_add1,:ls_cust_add2,:ls_cust_add3,:ls_cust_add4,:ls_remark,:ls_address_2,:ls_address_3 
//    	FROM Delivery_Master
//   	WHERE ( Delivery_Master.WH_Code = :ls_whcode ) AND  
//         	( Delivery_Master.do_no = :ls_do_no );   

ls_cust_name = w_do.idw_Main.GetITemString(1,'cust_name')
ls_cust_add1= w_do.idw_Main.GetITemString(1,'address_1')
ls_cust_add2= w_do.idw_Main.GetITemString(1,'address_2')
ls_cust_add3= w_do.idw_Main.GetITemString(1,'city')
ls_cust_add4= w_do.idw_Main.GetITemString(1,'zip')
ls_remark = w_do.idw_Main.GetITemString(1,'remark')
ls_address_2= w_do.idw_Main.GetITemString(1,'address_3')
ls_address_3= w_do.idw_Main.GetITemString(1,'address_4')

If IsNull(ls_cust_name) Then ls_cust_name = ""

SetPointer(HourGlass!)

w_do.SetMicroHelp("Opening Excel ...")
filename = ProfileString(gs_inifile,"sims3","syspath","") + "Reports\packlist_do.xls"

If Not FileExists(fileName) Then
	messagebox("Packing List","Unable to find Excel Spreadsheet for Packlist: " + fileName,StopSign!)
	Return -1
End If
	
xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(filename,0,True)
xs = xl.application.workbooks(1).worksheets(1)

w_do.SetMicroHelp("Printing report heading...")

xs.cells(2,2).value = "Packing List for "+upper(lsOrderNbr)
xs.cells(3,12).Value = String(Today(),"mm/dd/yyyy hh:mm")
xs.cells(4,2).Value = ls_cust_name
xs.cells(5,2).Value = ls_cust_add1
xs.cells(6,2).Value = ls_cust_add2
xs.cells(7,2).Value = ls_address_2
xs.cells(8,2).Value = ls_address_3
xs.cells(9,2).Value = ls_cust_add3
xs.cells(10,2).Value = ls_cust_add4
xs.cells(11,2).Value = ls_remark

ll_item = 1
ll_tot_qty = 0
ll_cnt = w_do.idw_Pack.RowCount()
max_size_col = 5*2+2+1 // ( +1 for addition of division column)



col=2+1    // (+1 for addition of division column )  
ll_row = 12
// Ver : EWMS 2.0 20070814
// Insert New Rows for the address
For i = 1 to ll_cnt

	w_do.SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
	
	ls_ctn_no = w_do.idw_Pack.GetItemString(i, "carton_no")
	//ls_division = w_do.idw_Pack.GetItemString(i, "division")
	ls_sku = w_do.idw_Pack.GetItemString(i, "sku")
	lsSuppCode = w_do.idw_Pack.GetItemString(i, "supp_code")
	ls_style = Left(ls_sku, 10)
	ls_size = Trim(Mid(ls_sku, 12, 5))
 	ll_qty = w_do.idw_Pack.GetItemNumber(i,"quantity")
	
	//'Division' comes from Item_MASter.Grp
	Select GRP_Desc into :ls_division
	From Item_Group, Item_Master
	Where Item_Master.Project_id = :gs_Project and 
	Item_Group.Project_ID = Item_Master.Project_ID  and
	Item_Group.GRP = Item_Master.GRP  and
	sku = :ls_Sku and supp_Code = :lsSuppCode;
	
	
	If ll_qty = 0 Then Continue
	
	If ls_ctn_no<>ls_prev_ctn_no or ls_style <> ls_prev_style or col = max_size_col Then
		
		If ((ls_ctn_no<>ls_prev_ctn_no) or (ls_style <> ls_prev_style)) and ll_tot_qty > 0 Then

			xs.cells(ll_row,max_size_col).value = ll_tot_qty
			ll_tot_qty = 0
			ll_item += 1
			
		End If
		
		ll_row += 1
		xs.rows(ll_row+1).insert
		if ls_style <> ls_prev_style or ls_ctn_no <> ls_prev_ctn_no then 
 		xs.cells(ll_row,1).value = ls_style
		end if
		xs.cells(ll_row,max_size_col+1).value = ls_ctn_no
		col=3
		
	End If

//	ll_coocnt = dw_coo.Retrieve(ls_do_no,ls_sku)
//	If ll_coocnt > 0 then
//		ls_coo = dw_coo.GetItemstring(1,'coo')
		ls_coo = w_do.idw_Pack.GetItemString(i, "country_of_Origin")
	   	xs.cells(ll_row,max_size_col+2).value = ls_coo
//	end if
	
	ll_tot_qty += ll_qty
	xs.cells(ll_row,col).value = ls_size
	xs.cells(ll_row,col+1).value = ll_qty
	xs.cells(ll_row,2).value = ls_division
	col = col + 2
	
	ls_prev_ctn_no= ls_ctn_no   
	ls_prev_style = ls_style
	
Next

xs.cells(ll_row,max_size_col).value = ll_tot_qty



w_do.SetMicroHelp("Complete!")
xl.Visible = True
xl.DisconnectObject()


Return 0
end function

public function integer uf_packprint_karcher ();// This event prints the Packing List which is currently visible on the screen 
// and not from the database - 


Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos
Decimal	ld_weight
String ls_address,lsfind,ls_text[], lscusttype, lscustcode
String ls_project_id , ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT,lsdono
datastore	ld_packprint
datawindow ldw_dw

//Set Packing List object
lsDONO = w_do.idw_main.GetITemString(1,'do_no')

Clipboard( lsDONO)



If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print
ll_cnt = w_do.idw_pack.rowcount()
If ll_cnt = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

OpenWithParm(w_karcher_packing_list_print_preview, lsDONO )


REturn 0
end function

public function integer uf_packprint_stryker ();//MEA 06/12 - Stryker


Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos, llNotesCount, llNotesPos
Decimal ld_weight, ld_costcenter
String ls_address,lsfind,ls_text[], lscusttype, lscustcode, lsSerial, lsNotes
String ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName, lsDONO
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT, lsUPC, lsPrinter, lsVol, lsNativeDesc, lsGrp
String ls_d_packing_prt, lsim_uf11, ls_dono
Long llim_qty2, llRowCount, llRowPOs, llNewRow

Datastore       ldsHazmat, ld_packprint


If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print (the data is coming from deliveryy Detail but we want to make sure the pack list is generated first)
llRowCount = w_do.idw_pack.rowcount()
If llRowCount = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

SetPointer(Hourglass!)

ld_packprint = Create Datastore
ld_packprint.dataobject ='d_stryker_packing_prt'

//08-Jan-2014 :Madhu- Assigning d/w to ldsHazmat -START
ldsHazmat = Create Datastore
ldshazmat.dataobject = 'd_hazard_text'
ldshazmat.SetTransObject(SQLCA)
//08-Jan-2014 :Madhu- Assigning d/w to ldsHazmat -END

//Get Ship From info from Warehouse table...
lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")
        
        Select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
        Into    :lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
        From warehouse
        Where WH_Code = :lsWHCode
        Using Sqlca;

//For each detail row, generate the pack data

llRowCount = w_do.idw_pack.RowCount()
For llRowPOs = 1 to llRowCount
	
	llNewRow = ld_packprint.InsertRow(0)
	
        //Get SKU, Description and Quantities  
        
        ls_sku = w_do.idw_pack.getitemstring(llRowPOs,"sku")
        ls_supplier = w_do.idw_pack.getitemstring(llRowPOs,"supp_code")
        llLineItemNo = w_do.idw_pack.GetITemNumber(llRowPOs,'line_item_no')
        
        If ls_SKU <> lsSKUHold Then
                
                select description, weight_1, hazard_text_cd, part_upc_Code, user_field8, native_description, grp, qty_2, user_field11    /* 05/09 - PCONKL - UF8 = Volume for Philips */ /* TAM W&S 2011/03 added qty2 and uf11 */
                into :ls_description, :ld_weight, :lshazCode, :lsUPC, :lsVol, :lsnativeDesc, :lsGrp, :llim_qty2, :lsim_uf11
                from item_master 
                where project_id = :gs_project and sku = :ls_sku and supp_code = :ls_supplier 
			   using Sqlca;
                
        End If /*Sku Changed*/
        
        lsSkuHold = ls_SKU
	    
	   ls_description = trim(ls_description)
			
        // 02/02 PCONKL - If there is hazardous material text for this SKU/Ship Method, retrieve the text for the report
        lshazText = ''
        If lshazCode > '' Then /*haz text exists for this sku*/
                llhazCount = ldsHazmat.Retrieve(gs_project,lshazCode,lsTransportMode)
                If llHazCount > 0 Then
                        For llHazPos = 1 to llHazCount
                                lsHazText += ldshazMat.GetItemString(llHazPos,'hazard_text') + '~r'
                        Next
                End If
        End If /*haz text exists*/
        
       // ld_packprint.setitem(llNewRow,"ord_no",w_do.idw_main.getitemstring(1,"cust_order_no"))	
	  //User request to change the Cust order number field with User field12 20161102 nxjain
	   ld_packprint.setitem(llNewRow,"ord_no",w_do.idw_main.getitemstring(1,"user_field12"))			
        ld_packprint.setitem(llNewRow,"costcenter", string(ld_costcenter))
        ld_packprint.setitem(llNewRow,"carton_no",w_do.idw_pack.getitemString(llRowPOs,"carton_no")) 
        ld_packprint.setitem(llNewRow,"bol_no",w_do.is_bolno)
        ld_packprint.setitem(llNewRow,"freight_terms",w_do.idw_other.getitemstring(1,"freight_terms"))     
        ld_packprint.setitem(llNewRow,"cust_code",w_do.idw_main.getitemstring(1,"cust_code")) 
        ld_packprint.setitem(llNewRow,"city",w_do.idw_main.getitemstring(1,"city"))
        ld_packprint.setitem(llNewRow,"country",w_do.idw_main.getitemstring(1,"country"))
        ld_packprint.setitem(llNewRow,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
        ld_packprint.setitem(llNewRow,"complete_date",w_do.idw_main.getitemdatetime(1,"complete_date"))  
	   ld_packprint.setitem(llNewRow,"schedule_date",w_do.idw_main.getitemdatetime(1,"schedule_date"))			
        ld_packprint.setitem(llNewRow,"sku",ls_sku)
        ld_packprint.setitem(llNewRow,"description",ls_description)
// 	   ld_packprint.setitem(llNewRow,"net_wgt",w_do.idw_pack.getitemDecimal(llRowPOs,"weight_net")) 
//	   ld_packprint.setitem(llNewRow,"gross_wgt",w_do.idw_pack.getitemDecimal(llRowPOs,"weight_gross"))
        ld_packprint.setitem(llNewRow,"standard_of_measure",w_do.idw_pack.getitemString(llRowPOs,"standard_of_measure"))
        ld_packprint.setitem(llNewRow,"carrier", w_do.idw_other.getitemString(1,"carrier") )
        ld_packprint.setitem(llNewRow,"ship_via",w_do.idw_other.getitemString(1,"ship_via")) 
        ld_packprint.setitem(llNewRow,"sch_cd",w_do.idw_other.getitemString(1,"user_field1")) 
        ld_packprint.setitem(llNewRow,"packlist_notes",w_do.idw_main.getitemString(1,"packlist_notes"))
        ld_packprint.setitem(llNewRow,"project_id",gs_project)
        ld_packprint.setitem(llNewRow,"HazText",lshazText) 

        //For English to Metrtics changes added L or K based on E or M
        ls_etom=ld_packprint.getitemString(llNewRow,"standard_of_measure")
        IF ls_etom <> "" and not isnull(ls_etom) and llNewRow=1 THEN
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
             
//	   ld_packprint.setitem(llNewRow,"lot_nbr",w_do.idw_pack.getitemstring(llRowPOs,"user_field1")) 
        ld_packprint.setitem(llNewRow,"picked_quantity",w_do.idw_pack.getitemNumber(llRowPOs,"quantity")) 
        ld_packprint.setitem(llNewRow,"volume",w_do.idw_pack.getitemDecimal(llRowPOs,"cbm")) 
//	   ld_packprint.setitem(llNewRow,"uom",w_do.idw_detail.getitemString(llRowPOs,"uom"))
       
	 	If w_do.idw_pack.getitemDecimal(llRowPOs,"cbm") > 0 Then
                ld_packprint.setitem(llNewRow,'dimensions',string(w_do.idw_pack.getitemDecimal(llRowPOs,"length")) + ' x ' + string(w_do.idw_pack.getitemDecimal(llRowPOs,"width")) + ' x ' + string(w_do.idw_pack.getitemDecimal(llRowPOs,"height"))) /* 02/01 - PCONKL*/
        End If
		  
        ld_packprint.setitem(llNewRow,"country_of_origin",w_do.idw_pack.getitemstring(llRowPOs,"country_of_origin")) 
        ld_packprint.setitem(llNewRow,"supp_code",w_do.idw_pack.getitemstring(llRowPOs,"supp_code")) 
        
        // 10/07 - PCONKL - Get Serial Numbers from serial tab(Outbound)
        If w_do.idw_serial.RowCount() > 0 Then
                
                lsSerial = ""
                lsFind = "Upper(Carton_No) = '" + Upper(w_do.idw_Pack.GetItemString(llRowPOs,'carton_no')) + "' and line_item_No = " + String(w_do.idw_Pack.GetITemNumber(llRowPOs,'line_item_No'))
                llFindRow = w_do.idw_serial.Find(lsFind,1,w_do.idw_serial.RowCOunt())
                Do While llFindRow > 0
                
                        lsSerial += ", " + w_do.idw_serial.GetItemString(llFindRow,'serial_no')
                
                        llFindRow ++
                        If llFindRow > w_do.idw_serial.RowCount() Then
                                lLFindRow = 0
                        Else
                                llFindRow = w_do.idw_serial.Find(lsFind,llFindRow,w_do.idw_serial.RowCOunt())
                        End If
                
                Loop
                
                If Left(lsSerial,2) = ', ' Then lsSerial = mid(lsSerial,3,999999999)
                ld_packprint.setitem(llNewRow,"serial_no",lsSerial)
        
        End If /*serial numbers exist*/
                
        ld_packprint.setitem(llNewRow,"component_ind",w_do.idw_pack.getitemstring(llRowPOs,"component_ind")) /* 02/01 - PCONKL - sort component master to top*/
                
        ld_packprint.setitem(llNewRow,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        ld_packprint.setitem(llNewRow,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        ld_packprint.setitem(llNewRow,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        ld_packprint.setitem(llNewRow,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        ld_packprint.setitem(llNewRow,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        ld_packprint.setitem(llNewRow,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
        ld_packprint.setitem(llNewRow,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
        ld_packprint.setitem(llNewRow,"remark",w_do.idw_main.getitemstring(1,"remark"))
        
	   ld_packprint.setitem(llNewRow,"contact",w_do.idw_main.getitemstring(1,"contact_person"))	  
	   ld_packprint.setitem(llNewRow,"tel",w_do.idw_main.getitemstring(1,"tel"))	
		  
		  
        // 07/00 PCONKL - Ship from info is coming from Project Table  
        ld_packprint.setitem(llNewRow,"ship_from_name",lsName)
        ld_packprint.setitem(llNewRow,"ship_from_address1",lsaddr1)
        ld_packprint.setitem(llNewRow,"ship_from_address2",lsaddr2)
        ld_packprint.setitem(llNewRow,"ship_from_address3",lsaddr3)
        ld_packprint.setitem(llNewRow,"ship_from_address4",lsaddr4)
        ld_packprint.setitem(llNewRow,"ship_from_city",lsCity)
        ld_packprint.setitem(llNewRow,"ship_from_state",lsstate)
        ld_packprint.setitem(llNewRow,"ship_from_zip",lszip)
        ld_packprint.setitem(llNewRow,"ship_from_country",lscountry)
		  
		lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLineItemNo)
         llRow = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
		
		ld_packprint.setitem(llNewRow,"ord_qty",  w_do.idw_pack.getitemNumber(llRowPOs,"quantity")) //w_do.idw_detail.getitemnumber(llRow,"req_qty"))
		
		 ld_packprint.setitem(llNewRow,"unit_weight",w_do.idw_pack.getitemDecimal(llRowPos,"weight_net"))
		
		llLineItemNo = w_do.idw_pack.GetItemNumber(llRowPos,"Line_Item_no")
	
		string lsPickFind
		long llPickFindRow
	
		//Add any pickable children items if this is a parent - This should be exclusive from being printed as notes above
		lsPickFind = "Line_Item_no = " + String(llLineItemNo) + " and sku = '" + ls_sku + "'"
	
		llPickFindRow = w_do.idw_Pick.Find(lsPickFind,1,w_do.idw_Pick.RowCount())
		
		IF llPickFindRow > 0 Then
			
			ld_packprint.setitem(llNewRow,"serial_no",w_do.idw_pick.GetItemString(llPickFindRow,'serial_no'))
			
		End If
		
		ld_packprint.setitem(llNewRow,"lot_no", w_do.idw_Pack.GetItemString(llRowPOs,'pack_lot_no'))
		ld_packprint.setitem(llNewRow,"expiry_date", w_do.idw_Pack.GetItemDatetime(llRowPOs,'pack_expiration_date'))
		
		
	
		  
		  
		  
 	         
Next /*PAcking Row */
 
i=1
FOR i = 1 TO UpperBound(ls_text[])
        ld_packprint.Modify(ls_text[i])
        ls_text[i]=""
NEXT
 
ld_packprint.Sort()
ld_packprint.GroupCalc()
 
// 09/04 - PCONKL - If we have a default printer for PackList, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','PACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

ld_packprint.Object.t_costcenter.Y= long(ld_packprint.Describe("costcenter.y"))
 
//Send the report to the Print report window
OpenWithParm(w_dw_print_options,ld_packprint) 
 
// 09/04 - PCONKL - We want to store the last printer used for Printing the Pack List for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','PACKLIST',lsPrinter)
 
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "I" Then 
                w_do.idw_main.SetItem(1,"ord_status","A")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If
 
Return 0
end function

public function integer uf_packprint_ariens ();//Print the Ariens packing slips (home depot us/canada)

Long	llRowCount, llRowPos, llNewRow, llFindRow, llLineItemNo
String	lsSKU, lsSupplier, lsDesc, lsSerial, lsWHCode, lsaddr1, lsaddr2, lsaddr3, lsaddr4, lsCity, lsState, lsZip, lsCountry
String lsSku1,lsSku2,lsSku3,lsSku4,lsSku5,lsDesc1,lsDesc2,lsDesc3,lsDesc4,lsDesc5, lsModify, lsDocType, lsTemp, lsDocPrint, lsaltSku
String lsaSku1,lsaSku2,lsaSku3,lsaSku4,lsaSku5, lsacustcode, lsDono
String ls_st_cust_code, ls_st_name, ls_st_addr1, ls_st_addr2, ls_st_addr3, ls_st_addr4,  ls_st_state,  ls_st_city, ls_st_zip,  ls_st_country, ls_st_tel
Datastore	lds_st, ld_packprint

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print (the data is coming from deliveryy Detail but we want to make sure the pack list is generated first)
llRowCount = w_do.idw_pack.rowcount()
If llRowCount = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

//Jxlim 08/26/2013 Ariens Force rtrieve sold to here because sold info didn't retrieve without clicking on sold to tab.
lsdono= w_do.idw_main.GetitemString(1,'Do_No')
lds_st =Create Datastore
lds_st.Dataobject='d_do_address_alt'
lds_st.SetTransObject(SQLCA)
lds_st.Retrieve(lsdono, 'ST')

SetPointer(Hourglass!)

ld_packprint = Create Datastore
	//Jxlim 08/07/2013 Print Doc Type depending on doc type code pass to delivery_master.user_field7
	lsDocType = Trim(w_do.idw_main.getitemstring(1,"user_field7"))
	//Jxlim 08/28/2013 Only cycle thru the colon (:)  if  HomeDepot Packling USA (PK2) or HomeDepot Packlist Canada (PK3) doc is indicated on Doc type outbound order other info tab
	If lsDocType > '' Then
	   If Pos(lsDocType, "PK2") > 0 or Pos(lsDocType, "PK3") > 0  Then	
		Do While lsDocType > ''		
				If  Pos(lsDocType,':') > 0	 Then
					lsDocPrint = Left(lsDocType,(pos(lsDocType,':') - 1))
				Else
					lsDocPrint = Left(lsDocType ,3)
				End If
				
				//Identify doc type
				Choose Case Upper(lsDocPrint )			
					//Print HomeDepot custom Packing List
					Case 'PK2' /* //Print HomeDepot US Custom Packing List	 */			
						ld_packprint.dataobject ='d_ariens_packing_prt_homedepot_us'						
					Case 'PK3' /* //Print HomeDepot Canada Custom Packing List */
						ld_packprint.dataobject ='d_ariens_packing_prt_homedepot_ca'
					Case Else
						//nothing
				End Choose		
				lsDocType = Right(lsDocType,(len(lsDocType) -(Len(lsDocPrint) + 1))) /*strip off to first column after colon */
			Loop			
			//Jxlim 08/07/2013 Print Doc Type depending on doc type code pass to delivery_master.user_field7
		End If
	End if
	
lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")
	
//Ship from address from Warehouse Table
Select Address_1, Address_2, Address_3, Address_4, city, state, zip, country
Into	 :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
From warehouse
Where WH_Code = :lsWHCode
Using Sqlca;

//For each detail row, gernete the pack data
llRowCount = w_do.idw_detail.RowCount()
For llRowPOs = 1 to llRowCount
	
	llNewRow = ld_packprint.InsertRow(0)
	
	lsSKU = w_do.idw_detail.getitemstring(llRowPos,"sku")
	lsaltSKU = w_do.idw_detail.getitemstring(llRowPos,"alternate_sku")	//Jxlim 08/16/2013 Areis; Internet nbr=alt_sku
	lsSupplier = w_do.idw_detail.getitemstring(llRowPos,"supp_code")
	llLineItemNo = w_do.idw_detail.getitemNumber(llRowPos,"Line_Item_No")
		
	
	//Jxlim 08/16/2013 Ariens Internet nbr=alt_sku, Ship_via=ship_via, Customer ord nbr=home depot cust_ord_no
	ld_packprint.setitem(llNewRow,"cust_order_no",w_do.idw_main.getitemstring(1,"cust_order_no"))	
	//ld_packprint.setitem(llNewRow,"carrier",w_do.idw_main.getitemstring(1,"user_field1"))
	ld_packprint.setitem(llNewRow,"Ship_via",w_do.idw_main.getitemstring(1,"ship_via"))
	
	ld_packprint.setitem(llNewRow,"ship_from_address1",lsAddr1)
	ld_packprint.setitem(llNewRow,"ship_from_address2",lsAddr2)
	ld_packprint.setitem(llNewRow,"ship_from_address3",lsAddr3)
	ld_packprint.setitem(llNewRow,"ship_from_address4",lsAddr4)
	ld_packprint.setitem(llNewRow,"ship_from_state",lsState)
	ld_packprint.setitem(llNewRow,"ship_from_city",lsCity)
	ld_packprint.setitem(llNewRow,"ship_from_zip",lsZip)
	ld_packprint.setitem(llNewRow,"ship_from_country",lsCountry)
	
	//Jxlim 08/20/2013 Ariens; Ship to; use Sold To tab info (alt_address)as HomeDepot Ship to End customer address(sold to)
	
//	ld_packprint.setitem(llNewRow,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))  //Ordered by //Jxlim 08/30/2013 Ariens; Uses sold to name
//	ld_packprint.setitem(llNewRow,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
//	ld_packprint.setitem(llNewRow,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
//	ld_packprint.setitem(llNewRow,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
//	ld_packprint.setitem(llNewRow,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
//	ld_packprint.setitem(llNewRow,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
//	ld_packprint.setitem(llNewRow,"city",w_do.idw_main.getitemstring(1,"city"))
//	ld_packprint.setitem(llNewRow,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
//	ld_packprint.setitem(llNewRow,"country",w_do.idw_main.getitemstring(1,"country"))


	//If w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.RowCount() > 0 Then
//		lsacustcode =w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"alt_cust_code")
//		ld_packprint.setitem(llNewRow,"alt_cust_code",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"alt_cust_code"))
//		ld_packprint.setitem(llNewRow,"sold_to_name",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"name"))		
//		ld_packprint.setitem(llNewRow,"sold_to_address1",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"address_1"))
//		ld_packprint.setitem(llNewRow,"sold_to_address2",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"address_2"))
//		ld_packprint.setitem(llNewRow,"sold_to_address3",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"address_3"))
//		ld_packprint.setitem(llNewRow,"sold_to_address4",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"address_4"))
//		ld_packprint.setitem(llNewRow,"sold_to_state",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"state"))
//		ld_packprint.setitem(llNewRow,"sold_to_city",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"city"))
//		ld_packprint.setitem(llNewRow,"sold_to_zip",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"zip"))
//		ld_packprint.setitem(llNewRow,"sold_to_country",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"country"))		
	//End If

		//Jxlim 08/26/2013 Ariens Sold to Dropship (delivery_alt_address)	
		ls_st_cust_code= lds_st.getitemstring(1,"alt_cust_code")
		ls_st_name= lds_st.getitemstring(1,"name")
		ls_st_addr1= lds_st.getitemstring(1,"address_1")
		ls_st_addr2= lds_st.getitemstring(1,"address_2")
		ls_st_addr3= lds_st.getitemstring(1,"address_3")
		ls_st_addr4= lds_st.getitemstring(1,"address_4")
		ls_st_state= lds_st.getitemstring(1,"state")
		ls_st_city= lds_st.getitemstring(1,"city")
		ls_st_zip= lds_st.getitemstring(1,"zip")
		ls_st_country= lds_st.getitemstring(1,"country")
		ls_st_tel= lds_st.getitemstring(1,"tel")

		ld_packprint.setitem(llNewRow,"alt_cust_code",ls_st_cust_code)
		ld_packprint.setitem(llNewRow,"sold_to_name",ls_st_name)
		ld_packprint.setitem(llNewRow,"sold_to_address1",ls_st_addr1)
		ld_packprint.setitem(llNewRow,"sold_to_address2",ls_st_addr2)
		ld_packprint.setitem(llNewRow,"sold_to_address3",ls_st_addr3)
		ld_packprint.setitem(llNewRow,"sold_to_address4",ls_st_addr4)
		ld_packprint.setitem(llNewRow,"sold_to_state",ls_st_state)
		ld_packprint.setitem(llNewRow,"sold_to_city",ls_st_city)
		ld_packprint.setitem(llNewRow,"sold_to_zip",ls_st_zip)
		ld_packprint.setitem(llNewRow,"sold_to_country",ls_st_country)
		ld_packprint.setitem(llNewRow,"sold_to_tel",ls_st_tel)
		//Jxlim end if sold to info
					
	ld_packprint.setitem(llNewRow,"Line_item_no",llLineItemNo)
	ld_packprint.setitem(llNewRow,"sku",lsSKU)
	ld_packprint.setitem(llNewRow,"alt_sku",lsaltSku)  //Internet nbr		
	
	ld_packprint.setitem(llNewRow,"uom",w_do.idw_detail.getitemstring(llRowPos,"uom"))
	ld_packprint.setitem(llNewRow,"ord_qty",w_do.idw_detail.getitemNumber(llRowPos,"req_qty"))
	ld_packprint.setitem(llNewRow,"picked_quantity",w_do.idw_detail.getitemNumber(llRowPos,"alloc_qty"))
	
	//We need the Decription from Item MAster
	Select Description into :lsDesc
	From Item_Master
	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
	
	ld_packprint.setitem(llNewRow,"description",lsDesc)
		
	//There may be serial numbers on picking...
	lsSerial = ""
	llFindRow = w_do.idw_Pick.Find("Line_Item_No = " + String(llLineItemNO) + " and Upper(sku) = '" + Upper(lsSKU) + "'",1,w_do.idw_Pick.rowCount())
	Do While llFindRow > 0
		
		If w_do.idw_Pick.GetITemString(llFindROw,'serial_no') <> '-' Then
			lsSerial += ", " + w_do.idw_Pick.GetITemString(llFindROw,'serial_no')
		End IF
		
		llFindRow ++
		If llFindRow > w_do.idw_Pick.rowCount() Then
			llFindRow = 0
		Else
			llFindRow = w_do.idw_Pick.Find("Line_Item_No = " + String(llLineItemNO) + " and Upper(sku) = '" + Upper(lsSKU) + "'",llFindRow,w_do.idw_Pick.rowCount())
		End If
				
	Loop
	
	If lsSerial > "" Then
		lsSerial = Mid(lsSerial,3,99999) /*strip off first comma*/
	End If
	
	ld_packprint.setitem(llNewRow,"serial_no",lsSerial)
	
Next /*Detail row*/

		//Jxlim 08/07/2013 Ariens Print SKU/Description for the first 5 rows on return section
		lsSku1 =	ld_packprint.getitemstring(1,"sku")
		lsSku2 =	ld_packprint.getitemstring(2,"sku")
		lsSku3 =	ld_packprint.getitemstring(3,"sku")
		lsSku4 =	ld_packprint.getitemstring(4,"sku")
		lsSku5 =	ld_packprint.getitemstring(5,"sku")
		
		lsaSku1 =	ld_packprint.getitemstring(1,"alt_sku")
		lsaSku2 =	ld_packprint.getitemstring(2,"alt_sku")
		lsaSku3 =	ld_packprint.getitemstring(3,"alt_sku")
		lsaSku4 =	ld_packprint.getitemstring(4,"alt_sku")
		lsaSku5 =	ld_packprint.getitemstring(5,"alt_sku")
		
		lsDesc1 =ld_packprint.getitemstring(1,"description")
		lsDesc2 =ld_packprint.getitemstring(2,"description")
		lsDesc3 =ld_packprint.getitemstring(3,"description")
		lsDesc4 =ld_packprint.getitemstring(4,"description")
		lsDesc5 =ld_packprint.getitemstring(5,"description")
		
		lsModify += "sku_t1.text= '" + lsSku1 + "'"		
		lsModify += "sku_t2.text= '" + lsSku2 + "'"		
		lsModify += "sku_t3.text= '" + lsSku3 + "'"		
		lsModify += "sku_t4.text= '" + lsSku4 + "'"		
		lsModify += "sku_t5.text= '" + lsSku5 + "'"		
		
		lsModify += "alt_sku_t1.text= '" + lsaSku1 + "'"		
		lsModify += "alt_sku_t2.text= '" + lsaSku2 + "'"		
		lsModify += "alt_sku_t3.text= '" + lsaSku3 + "'"		
		lsModify += "alt_sku_t4.text= '" + lsaSku4 + "'"		
		lsModify += "alt_sku_t5.text= '" + lsaSku5 + "'"				
		
		lsModify += "desc_t1.text= '" + lsDesc1 + "'"		
		lsModify += "desc_t2.text= '" + lsDesc2 + "'"		
		lsModify += "desc_t3.text= '" + lsDesc3 + "'"		
		lsModify += "desc_t4.text= '" + lsDesc4 + "'"		
		lsModify += "desc_t5.text= '" + lsDesc5 + "'"		
		
		ld_packprint.Modify(lsModify)

//Jxlim 08/29/2013 Only print when dataobject is not blank
//Jxlim 08/12/2013 Only print pack list when doc type is indicated on dm.user_field7
//If 	lsDocPrint > ''  Then
If	ld_packprint.dataobject > ''  Then
	OpenWithParm(w_dw_print_options,ld_packprint) 
End If

Return 0
end function

public function integer uf_process_packprint_ariens ();//arien pack list 

Long	llRowCount, llRowPos, llNewRow, llFindRow, llLineItemNo ,llalloc_qty ,ll_len, llCount
String	lsSKU, lsSupplier, lsDesc, lsSerial, lsWHCode, lsaddr1, lsaddr2, lsaddr3, lsaddr4, lsCity, lsState, lsZip, lsCountry,ls_whname
string lsSerial_org ,lsSKU_org, lsdono
Datastore	ld_bolprint
int counter =0
int sequence =0

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print (the data is coming from deliveryy Detail but we want to make sure the pack list is generated first)
llRowCount = w_do.idw_pack.rowcount()
If llRowCount = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

// 01/14 - PCONKL - Don't allow printing if serial numbers haven't been entered.

lsdono = w_do.idw_main.getITemString(1,'do_no')

select Count(*) into :llCount
FRom Item_MASter
Where project_id = 'Ariens' and serialized_ind = 'B' and sku in (select sku from delivery_detail where do_no = :lsdono);

If llCount > 0 and w_do.idw_serial.RowCount() = 0 Then
	MessageBox("Print Packing List"," Serial numbers must be entered before printing the Pack List!",Stopsign!)
	Return 0
End If

SetPointer(Hourglass!)

ld_bolprint = Create Datastore
ld_bolprint.dataobject ='d_ariens_bol_sheet'

lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")
	
//Ship from address from Warehouse Table
Select Address_1, Address_2, Address_3, Address_4, city, state, zip, country,wh_name
Into	 :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry,:ls_whname
From warehouse
Where WH_Code = :lsWHCode
Using Sqlca;


//For each detail row, gernete the pack data


llRowCount =w_do.idw_detail.rowCount()


For llRowPOs = 1 to llRowCount
		
	lsSKU = w_do.idw_detail.getitemstring(llRowPos,"sku")
	lsSupplier = w_do.idw_detail.getitemstring(llRowPos,"supp_code")
	llLineItemNo = w_do.idw_detail.getitemNumber(llRowPos,"Line_Item_No")
	llalloc_qty = w_do.idw_detail.getitemNumber(llRowPos,"alloc_qty")
	
	if (llalloc_qty =0 ) then 
		continue
	else 	
	
		llNewRow = ld_bolprint.InsertRow(0)
		ld_bolprint.Modify("p_1.Filename='Ariens_logo.bmp'")
 		ld_bolprint.setitem(llNewRow,"delivery_master_cust_code",w_do.idw_main.getitemstring(1,"cust_code"))
		ld_bolprint.setitem(llNewRow,"delivery_master_awb_bol_no",w_do.idw_main.getitemstring(1,"awb_bol_no"))
		ld_bolprint.setitem(llNewRow,"delivery_master_invoiceno",w_do.idw_main.getitemstring(1,"Invoice_no"))
		ld_bolprint.setitem(llNewRow,"delivery_master_cust_ord_no",w_do.idw_main.getitemstring(1,"cust_order_no"))
		ld_bolprint.setitem(llNewRow,"Consolidation_No",w_do.idw_main.getitemstring(1,"Consolidation_No"))
	
		ld_bolprint.setitem(llNewRow,"seal_number",w_do.idw_main.getitemstring(1,"User_Field2"))
		ld_bolprint.setitem(llNewRow,"Trailer_no",w_do.idw_main.getitemstring(1,"User_Field4"))
		ld_bolprint.setitem(llNewRow,"delivery_master_cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
	
		ld_bolprint.setitem(llNewRow,"wh_address1",lsAddr1)
		ld_bolprint.setitem(llNewRow,"wh_address2",lsAddr2)
		ld_bolprint.setitem(llNewRow,"wh_address3",lsAddr3)
		ld_bolprint.setitem(llNewRow,"wh_address4",lsAddr4)
		ld_bolprint.setitem(llNewRow,"wh_state",lsState)
		ld_bolprint.setitem(llNewRow,"wh_city",lsCity)
		ld_bolprint.setitem(llNewRow,"wh_zip",lsZip)
		ld_bolprint.setitem(llNewRow,"wh_country",lsCountry)
		ld_bolprint.setitem(llNewRow,"wh_name",ls_whname)
	
		//ld_bolprint.setitem(llNewRow,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
		ld_bolprint.setitem(llNewRow,"delivery_master_ship_address1",w_do.idw_main.getitemstring(1,"address_1"))
		ld_bolprint.setitem(llNewRow,"delivery_master_ship_address2",w_do.idw_main.getitemstring(1,"address_2"))
		ld_bolprint.setitem(llNewRow,"delivery_master_ship_address3",w_do.idw_main.getitemstring(1,"address_3"))
		ld_bolprint.setitem(llNewRow,"delivery_master_ship_address4",w_do.idw_main.getitemstring(1,"address_4"))
		ld_bolprint.setitem(llNewRow,"delivery_master_state",w_do.idw_main.getitemstring(1,"state"))
		ld_bolprint.setitem(llNewRow,"delivery_master_city",w_do.idw_main.getitemstring(1,"city"))
		ld_bolprint.setitem(llNewRow,"delivery_master_zip",w_do.idw_main.getitemstring(1,"zip"))
		ld_bolprint.setitem(llNewRow,"delivery_master_country",w_do.idw_main.getitemstring(1,"country"))
		ld_bolprint.setitem(llNewRow,"delivery_master_ord_date",w_do.idw_main.getitemDateTime(1,"Ord_Date"))
		ld_bolprint.setitem(llNewRow,"carrier",w_do.idw_main.getitemstring(1,"carrier"))
	//	ld_bolprint.setitem(llNewRow,"carriertrackingno",w_do.idw_main.getitemstring(1,"User_Field4"))
	
		ld_bolprint.setitem(llNewRow,"delivery_detail_sku",lsSKU)
		ld_bolprint.setitem(llNewRow,"alloc_qty",w_do.idw_detail.getitemNumber(llRowPos,"alloc_qty"))


		//There may be serial numbers on picking...
		// 09/13 - PCONKL - Switching to serial both instead of Inbound so serial numbers coming from serial tab instead of picking. We need to accomdate both during conversion period
		
		lsSerial = ""
		counter =counter +1
		sequence =sequence +1

		llFindRow = w_do.idw_Pick.Find("Line_Item_No = " + String(llLineItemNO) + " and Upper(sku) = '" + Upper(lsSKU) + "' and serial_no <> '-' ",1,w_do.idw_Pick.rowCount())
			
		Do While llFindRow > 0
			
			lsSerial = w_do.idw_Pick.GetITemString(llFindROw,'serial_no')
			lsSerial_org= lsSerial
			lsSKU_org=  lsSKU
		
			lsSKU_org =Trim(Mid(lsSKU_org,1,6))
			lsSerial_org=Trim(Mid(lsSerial_org,1,6))
		
		
			If IsNull(lsSerial) then
				lsSerial = "-"
			elseif   (lsSKU_org = lsSerial_org )then 
				//lsSerial_org	=Trim(Mid(lsSerial,6,25)) 
				lsSerial_org	=Trim(Mid(lsSerial,7,25)) /* 09/13 - PCONKL - Serial should be starting in 7th, not 6th pos)*/
				lsSerial =lsSerial_org 
			end if
		
			choose case counter
				case 1
					ld_bolprint.setitem(llNewRow,"serial1",lsSerial)
					ld_bolprint.setitem(llNewRow,"lineno1",sequence)
				case 2
					ld_bolprint.setitem(llNewRow,"serial2",lsSerial)
					ld_bolprint.setitem(llNewRow,"lineno2",sequence)
				case 3
					ld_bolprint.setitem(llNewRow,"serial3",lsSerial)
					ld_bolprint.setitem(llNewRow,"lineno3",sequence)
				case 4
					ld_bolprint.setitem(llNewRow,"serial4",lsSerial)
					ld_bolprint.setitem(llNewRow,"lineno4",sequence)
				case 5
					ld_bolprint.setitem(llNewRow,"serial5",lsSerial)
					ld_bolprint.setitem(llNewRow,"lineno5",sequence)
			end choose
		
			
			llFindRow ++
			counter =counter+1
			sequence =sequence+1
		
			If llFindRow > w_do.idw_Pick.rowCount() Then
				llFindRow = 0
			Else
				llFindRow = w_do.idw_Pick.Find("Line_Item_No = " + String(llLineItemNO) + " and Upper(sku) = '" + Upper(lsSKU) + "'",llFindRow,w_do.idw_Pick.rowCount())
			End If
		
			IF llFindRow =0 THEN 
				counter =0
				sequence =sequence -1
			END IF
		
			IF llFindRow > 0 and counter > 5 THEN
				counter =1
				llNewRow = ld_bolprint.InsertRow(0)
			end if

		Loop /*Picking Tab*/
		
		// 09/13 - PCONKL - Include serial froms erial tab
		llFindRow = w_do.idw_Serial.Find("Line_Item_No = " + String(llLineItemNO) + " and Upper(sku) = '" + Upper(lsSKU) + "'",1,w_do.idw_Serial.rowCount())
			
		Do While llFindRow > 0
			
			lsSerial = w_do.idw_Serial.GetITemString(llFindROw,'serial_no')
			lsSerial_org= lsSerial
			lsSKU_org=  lsSKU
		
			lsSKU_org =Trim(Mid(lsSKU_org,1,6))
			lsSerial_org=Trim(Mid(lsSerial_org,1,6))
		
		
			If IsNull(lsSerial) then
				lsSerial = "-"
			elseif   (lsSKU_org = lsSerial_org )then 
				//lsSerial_org	=Trim(Mid(lsSerial,6,25)) 
				lsSerial_org	=Trim(Mid(lsSerial,7,25)) /* 09/13 - PCONKL - Serial should be starting in 7th, not 6th pos)*/
				lsSerial =lsSerial_org 
			end if
		
			choose case counter
				case 1
					ld_bolprint.setitem(llNewRow,"serial1",lsSerial)
					ld_bolprint.setitem(llNewRow,"lineno1",sequence)
				case 2
					ld_bolprint.setitem(llNewRow,"serial2",lsSerial)
					ld_bolprint.setitem(llNewRow,"lineno2",sequence)
				case 3
					ld_bolprint.setitem(llNewRow,"serial3",lsSerial)
					ld_bolprint.setitem(llNewRow,"lineno3",sequence)
				case 4
					ld_bolprint.setitem(llNewRow,"serial4",lsSerial)
					ld_bolprint.setitem(llNewRow,"lineno4",sequence)
				case 5
					ld_bolprint.setitem(llNewRow,"serial5",lsSerial)
					ld_bolprint.setitem(llNewRow,"lineno5",sequence)
			end choose
		
			
			llFindRow ++
			counter =counter+1
			sequence =sequence+1
		
			If llFindRow > w_do.idw_Serial.rowCount() Then
				llFindRow = 0
			Else
				llFindRow = w_do.idw_Serial.Find("Line_Item_No = " + String(llLineItemNO) + " and Upper(sku) = '" + Upper(lsSKU) + "'",llFindRow,w_do.idw_Serial.rowCount())
			End If
		
			IF llFindRow =0 THEN 
				counter =0
				sequence =0
				END IF
		
			IF llFindRow > 0 and counter > 5 THEN
				counter =1
				llNewRow = ld_bolprint.InsertRow(0)
			end if

		Loop /* serial tab*/
		

	end if //alloc end 

Next /*Detail row*/

OpenWithParm(w_dw_print_options,ld_bolprint) 

Return 1

end function

public function integer uf_generate_pack_klonelab ();//Generate a PAckList for KloneLab

Long ll_cnt, ll_row, i,llImportFindRow,  llLoopCount, llLoopPos,llLineITemNo,  llCarton, llPickFindRow, ll_owner_id
Decimal ld_gross_weight, ld_weight , ld_length, ld_width, ld_height,ld_qty, ldSetQty, ldCartonQty, ldAllocQty, ldRemainQty, ld_Carton_length, ld_Carton_width, ld_Carton_Height
integer  j,  li_indx, liRC
STRING lsSKU, lsSkuParent, lsSupplier,  lsFind, ls_std_measure ,  lsOwnerName, lsCartonType, lsCartonTypeSave
String  ls_wh_code,ls_std_measure_w,   lscarton
str_parms	lstrparms
Datastore	ldsImport

// 09/05 - PCONKL - If there are packages shipped by TRAX, they must be voided before regenerating (can't delete shipped rows)
If w_do.idw_Pack.Find("Tracking_Id_type='T'",1, w_do.idw_Pack.RowCount()) > 0 Then
	messagebox(w_do.is_title,'One or more cartons on the current Packing List were shipped by ConnectShip.~rThese cartons must be voided before you can re-generate the Packing List.',StopSign!) // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
	//messagebox(w_do.is_title,'One or more cartons on the current Packing List were shipped by TRAX.~rThese cartons must be voided before you can re-generate the Packing List.',StopSign!)
	return - 1
End If

If w_do.ib_changed Then
	messagebox(w_do.is_title,'Please save changes before generating Packing list!')
	return -1
End If

If w_do.idw_pack.RowCount() > 0 Then
	
	If MessageBox(w_do.is_title, "Delete current packing list?", Question!, YesNo!,2) = 1 Then
		
		ll_cnt = w_do.idw_pack.RowCount()
		w_do.idw_pack.Setredraw(false) /*pconkl 5/3/00*/
		
		For i = ll_cnt To 1 Step - 1
			w_do.idw_pack.DeleteRow(i)
		Next
		
		w_do.idw_pack.Setredraw(True) /*pconkl 5/3/00*/
		
		// 5/4/00 PCONKL - deleted rows must be saved back to DB (deleted from) to avoid PK integrity violation
		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
		If w_do.idw_pack.Update(False, False) = 1 Then
			Execute Immediate "COMMIT" using SQLCA;
   		If SQLCA.SQLCode = 0 Then
   			w_do.idw_pack.ResetUpdate()
			Else /*commit failed*/
				Execute Immediate "ROLLBACK" using SQLCA;
     			MessageBox(w_do.is_title, "Unable to delete Packing List Rows! " + SQLCA.SQLErrText)
				w_do.SetMicroHelp("Save failed!")
				return - 1
			End If
		Else /*update failed*/
			Execute Immediate "ROLLBACK" using SQLCA;
     			MessageBox(w_do.is_title, "Unable to delete Packing List Rows! " + SQLCA.SQLErrText)
				w_do.SetMicroHelp("Save failed!")
				return -1
		End If /*end process of delete*/
	Else
		Return -1
	End If
	
End If


// 02/01 PCONKL - remove filter on pick list to pick up component children
w_do.wf_set_pick_filter('Remove')

//see if they want to override the default number of units per carton
OpenWithParm(w_imort_musicalrun,lstrparms)
lstrparms = Message.PowerObjectParm
If lstrParms.Cancelled THen Return 0


ldsImport = Create Datastore
ldsImport.dataobject = 'd_generate_musical_run'

if UpperBound(lstrparms.datastore_arg[]) > 0 Then
	//ldsImport = lstrparms.DataStore_arg[1]
	liRC = lstrparms.DataStore_arg[1].RowsCopy(1,999999,Primary!,ldsImport,1,Primary!)
End If


w_do.idw_pack.SetColumn ("carton_no")

// 09/03 - PCONKL - If we are assigning unique carton numbers, we will start with the numeric (last 6) of DO_NO + 3 digit sequential number,
// otherwise we'll start with 1 for each order
If g.is_unique_pack_cartonnumbers = 'Y' Then
	lsCarton = Right(Mid(w_do.idw_main.GetITemString(1,'do_no'),(len(gs_project) + 1),7),6) /* right 6 of everything after project*/
End If

// pvh - 11/16/06
w_do.setCartonNo( 0 )

ls_wh_code = w_do.idw_main.object.wh_code[1]

SetPointer(Hourglass!)
w_do.idw_pack.Setredraw(false) /*pconkl 10/00*/

ll_cnt = w_do.idw_Detail.RowCount()
For i = 1 to ll_cnt /*each DETAIL Row*/
	
	w_do.SetMicroHelp('Generating Pack list for Detail Row ' + String(i) + ' of ' + String(ll_cnt))

	lsSku = Upper(w_do.idw_detail.GetITemString(i,'Sku'))
	lsSkuParent = Upper(w_do.idw_detail.GetITemString(i,'Sku'))
	lsSupplier = upper(w_do.idw_detail.GetItemString(i,"supp_code"))
	llLineItemNo = w_do.idw_detail.GetITemNumber(i,'line_item_no')
		
	//Select SKU from Item_Master and Check row count
	SELECT Length_1, Width_1, Height_1, Weight_1,standard_of_measure, qty_2
	INTO :ld_length, :ld_width, :ld_height, :ld_weight,:ls_std_measure, :ldCartonQty
	FROM Item_Master 
	WHERE Project_id = :gs_project and SKU = :lsSKU and supp_code = :lsSupplier;
			
	//If they set the Carton Qty on the import screen, use that instead of the Item MAster level 2 qty
	llImportFindRow = ldsImport.find("Upper(SKU) = '" + upper(lsSKU) + "'",1, ldsImport.RowCount())
	
	If llImportFindRow > 0 Then
		
		If ldsImport.GetITemNumber(llImportFindRow,'qty_per_Case') > 0 THen
			ldCartonQty = ldsImport.GetITemNumber(llImportFindRow,'qty_per_Case') 
		End If
		
		lsCartonType = ldsImport.GetITemString(llImportFindRow,'carton_type')
		If lsCartonType > '' and lsCartonType <> lsCartonTypeSave Then
				
			ls_wh_code = w_do.idw_Main.GetITemString(1,'wh_code')
				
			ld_Carton_length = 0
			ld_Carton_Width = 0
			ld_Carton_Height = 0
				
			Select Length, Width, height
			Into	:ld_Carton_length, :ld_Carton_Width, :ld_Carton_Height
			FRom Carton_Master
			Where (Project_id = :gs_project or Project_id = "*ALL") and wh_code = :ls_wh_code and carton_type = :lsCartonType
			Using SQLCA;
			
			lsCartonTypeSave = lsCartonType
			
		End If
		
	Else
		
		lsCartonType = ''
		ld_Carton_length = 0
		ld_Carton_Width = 0
		ld_Carton_Height = 0
		
	End If
		
	ldallocQty = w_do.idw_detail.GetItemnumber(i,'alloc_Qty') 
		
	ldRemainQty = ldAllocQty	
		
	If ldCartonQty = 0 or isnull(ldCartonQty) Then
		ldCartonQty = ldRemainQty
	End If
		
	Do While ldRemainQty > 0 
		
		ll_row = w_do.idw_pack.InsertRow(0)
		llCarton = w_do.getCartonNo()
		llCarton++
		w_do.setCartonNo( llCarton )
		
		w_do.idw_pack.SetItem(ll_row,"carton_no",w_do.wf_set_Pack_carton(ll_row))
				
		w_do.idw_pack.SetItem(ll_row,"component_ind","N")
		w_do.idw_pack.SetItem(ll_row,"c_first_carton_row","Y")
		w_do.idw_pack.SetItem(ll_row,"do_no", w_do.idw_main.GetItemString(1,"do_no"))
		w_do.idw_pack.SetItem(ll_row,"sku", lsSku)
		w_do.idw_pack.SetItem(ll_row,"supp_code", lsSupplier)
		w_do.idw_pack.SetITem(ll_row,'line_item_No',llLIneItemNo) /* 09/01 Pconkl */
		W_do.idw_pack.SetItem(ll_row,"Project_Id",w_do.idw_pick.GetItemString(i,'project_id'))
		w_do.idw_pack.SetItem(ll_row,"qa_check_ind","")
			
		If 	ldCartonQty <= ldRemainQty Then
			w_do.idw_pack.SetItem(ll_row,"quantity",ldCartonQty ) 
			ldRemainQty = ldRemainQty - ldCartonQty
		Else
			w_do.idw_pack.SetItem(ll_row,"quantity",ldRemainQty ) 
			ldRemainQty = 0
		End If

		//Take weights from carton type if present, otherwise from Item MAster
		If ld_Carton_length > 0 and ld_Carton_width > 0 and ld_carton_Height > 0 Then
			
			w_do.idw_pack.SetItem ( ll_row, 'length', ld_carton_length)
			w_do.idw_pack.SetItem ( ll_row, 'width', ld_carton_width )
			w_do.idw_pack.SetItem ( ll_row, 'height', ld_carton_height)
			w_do.idw_pack.SetItem ( ll_row, 'weight_net',ld_weight )
			w_do.idw_pack.SetItem ( ll_row, 'weight_gross', ld_weight )
			w_do.idw_pack.SetItem ( ll_row, 'cbm', (Round(ld_carton_length,0)*Round(ld_carton_width,0)*Round(ld_carton_height,0))) 
						
		Else
			
			w_do.idw_pack.SetItem ( ll_row, 'length', ld_length)
			w_do.idw_pack.SetItem ( ll_row, 'width', ld_width )
			w_do.idw_pack.SetItem ( ll_row, 'height', ld_height)
			w_do.idw_pack.SetItem ( ll_row, 'weight_net',ld_weight )
			w_do.idw_pack.SetItem ( ll_row, 'weight_gross', ld_weight )
			w_do.idw_pack.SetItem ( ll_row, 'cbm', (Round(ld_length,0)*Round(ld_width,0)*Round(ld_height,0))) 
			
		End If
				
		//Dgm ETOM default is assign from Wharehouse if Item Master default is different.
		ls_std_measure_w = g.ids_project_warehouse.object.standard_of_measure[g.of_project_warehouse(gs_project,ls_wh_code)]
		
		IF ls_std_measure = ls_std_measure_w THEN
			w_do.idw_pack.Setitem(ll_row,"standard_of_measure",ls_std_measure)			
		ELSE
			w_do.idw_pack.Setitem(ll_row,"standard_of_measure",ls_std_measure_w)
			w_do.wf_convert(ls_std_measure_w, 1, ll_Row)//convert the Dimentions 
		END IF

		llPickFindRow = w_do.idw_Pick.Find("Line_Item_No = " + String(llLineItemNo), 1, w_do.idw_Pick.RowCount())
		If llPickFindRow > 0 Then
			w_do.idw_pack.setitem(ll_row,'country_of_origin',w_do.idw_pick.getitemstring(llPickFindRow,'country_of_origin'))
		Else
			w_do.idw_pack.setitem(ll_row,'country_of_origin','XXX')
		End If
		
			
		//Gross weight may come from the import
		IF llImportFIndRow > 0 Then
			If ldsImport.GetITEmNumber(llImportFindRow,'gross_Weight') > 0 Then
				w_do.idw_pack.SetItem ( ll_row, 'weight_gross', ldsImport.GetITEmDecimal(llImportFindRow,'gross_Weight'))
			Else
				w_do.idw_pack.SetItem ( ll_row, 'weight_gross', (w_do.idw_pack.GetITemNumber(ll_row,'weight_net') * w_do.idw_pack.GetITemNumber(ll_row,'Quantity')))
			End If
		Else
			w_do.idw_pack.SetItem ( ll_row, 'weight_gross', (w_do.idw_pack.GetITemNumber(ll_row,'weight_net') * w_do.idw_pack.GetITemNumber(ll_row,'Quantity')))
		end if	
					
		
	Loop /*remaining Qty*/
		
Next /* Next DETAIL Row*/
	


//MEA 03/08 - Moved out of loop to prevent out of memory during save.
w_do.wf_assignetom(2) //Assigning value of Standard_of Mesure to Radio Button	

w_do.idw_pack.Sort()
w_do.idw_pack.GroupCalc()

w_do.tab_main.tabpage_pack.cbx_show_comp_pack.Enabled = False
w_do.tab_main.tabpage_pack.cbx_show_comp_pack.Checked = False

// 02/01 PCONKL - reset filter on Pick LIst based on showing components
w_do.wf_set_pick_filter('Set')

//03/07 - PONKL - Enable/Disable DIMS on PAcking List - Only want to enable first row for a carton
//w_do.uf_enable_first_carton_row(0,"")
	
w_do.idw_pack.Setredraw(True) /*pconkl 10/00*/

SetPointer(Arrow!)
w_do.idw_pack.SetFocus()

w_do.ib_changed = True


end function

public function integer uf_generate_pack_klonelab_musicalrun ();
Str_parms	lstrparms
Long	ll_cnt, i, ll_row, llLineItemNo, llFindRow
long	llSeqPos, llSeq, llSeqPrev, llCartonPos, llCartonCount, llSKUPos, llDetailPos, llDEtailCount, llDe
Boolean	lbFirstRow
String	lsCarton, ls_wh_code, ls_std_Measure_w,  ls_std_Measure, lsCOO, lsSKU, lsCartonType, lsCartonTypeSave
Decimal	ld_length, ld_width, ld_Height, ld_weight, ld_Carton_length, ld_Carton_Width, ld_Carton_Height, ldQty1, ldQty2
Datastore	ldsImport, ldsDetail
Integer	liRC

// 09/05 - PCONKL - If there are packages shipped by TRAX, they must be voided before regenerating (can't delete shipped rows)
If w_do.idw_Pack.Find("Tracking_Id_type='T'",1, w_do.idw_Pack.RowCount()) > 0 Then
	messagebox(w_do.is_title,'One or more cartons on the current Packing List were shipped by ConnectShip.~rThese cartons must be voided before you can re-generate the Packing List.',StopSign!) // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
	//messagebox(w_do.is_title,'One or more cartons on the current Packing List were shipped by TRAX.~rThese cartons must be voided before you can re-generate the Packing List.',StopSign!)
	return - 1
End If

If w_do.ib_changed Then
	messagebox(w_do.is_title,'Please save changes before generating Packing list!')
	return -1
End If

If w_do.idw_pack.RowCount() > 0 Then
	
	If MessageBox(w_do.is_title, "Delete current packing list?", Question!, YesNo!,2) = 1 Then
		
		ll_cnt = w_do.idw_pack.RowCount()
		w_do.idw_pack.Setredraw(false) /*pconkl 5/3/00*/
		
		For i = ll_cnt To 1 Step - 1
			w_do.idw_pack.DeleteRow(i)
		Next
		
		w_do.idw_pack.Setredraw(True) /*pconkl 5/3/00*/
		
		// 5/4/00 PCONKL - deleted rows must be saved back to DB (deleted from) to avoid PK integrity violation
		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
		If w_do.idw_pack.Update(False, False) = 1 Then
			Execute Immediate "COMMIT" using SQLCA;
   		If SQLCA.SQLCode = 0 Then
   			w_do.idw_pack.ResetUpdate()
			Else /*commit failed*/
				Execute Immediate "ROLLBACK" using SQLCA;
     			MessageBox(w_do.is_title, "Unable to delete Packing List Rows! " + SQLCA.SQLErrText)
				w_do.SetMicroHelp("Save failed!")
				return - 1
			End If
		Else /*update failed*/
			Execute Immediate "ROLLBACK" using SQLCA;
     			MessageBox(w_do.is_title, "Unable to delete Packing List Rows! " + SQLCA.SQLErrText)
				w_do.SetMicroHelp("Save failed!")
				return -1
		End If /*end process of delete*/
	Else
		Return -1
	End If
	
End If

//We need a place to store quantities across line numbers if a SKU exists on multiple lines - 
ldsDetail = Create Datastore
ldsDetail.dataobject = 'd_do_detail'

llDetailCount = w_do.idw_Detail.RowCount()
For llDEtailPOs = 1 to llDetailCount
	ll_row = ldsDetail.InsertRow(0)
	ldsDetail.SetITEm(ll_row,'line_item_no',w_do.idw_DEtail.GEtITemNumber(llDetailPos,'line_item_no'))
	ldsDetail.SetITEm(ll_row,'SKU',w_do.idw_DEtail.GEtITemString(llDetailPos,'SKU'))
	ldsDetail.SetITEm(ll_row,'req_qty',w_do.idw_DEtail.GEtITemNumber(llDetailPos,'req_qty'))
	ldsDetail.SetITEm(ll_row,'alloc_qty',0) /* packing qty will be stored in Alloc_Qty */
Next


// 02/01 PCONKL - remove filter on pick list to pick up component children
w_do.wf_set_pick_filter('Remove')

OpenWithParm(w_imort_musicalrun,lstrparms)
lstrparms = Message.PowerObjectParm
If lstrParms.Cancelled THen Return 0


//Build a set of pack rows for each Segment in the musical run
//For each Segment, build cartons (based on the num cases field) for each SKU in the segment

ldsImport = Create Datastore
ldsImport.dataobject = 'd_generate_musical_run'

if UpperBound(lstrparms.datastore_arg[]) > 0 Then
	//ldsImport = lstrparms.DataStore_arg[1]
	liRC = lstrparms.DataStore_arg[1].RowsCopy(1,999999,Primary!,ldsImport,1,Primary!)
End If

If ldsImport.RowCount() = 0 Then Return 0

w_do.idw_pack.Setredraw(False) 

llSeqPrev = 0

For llSeqPos = 1 to ldsImport.RowCount()  /* Loop once per Sequence*/
	
	llSeq = ldsImport.GetItemNumber(llSeqPos,'seq')
	
	If llSeq = llSeqPrev Then Continue /* Loop once per Sequence*/
	
	llSeqPrev = llSeq
	
	//Loop once for each carton being created for the sequence (all items for the seqeuence will have the same number of cartons)
	llCartonCount = ldsImport.GetItemNumber(llSeqPos,'num_cases')
	
	For llCartonPos = 1 to llCartonCount
		
		lbFirstRow = True /*only want new carton for first row of carton*/
		
		//Create a new carton and create a packing row for that carton for all of the SKUs in the current Seqeunce
		For llSKUPos = 1 to ldsImport.RowCount()
			
			If ldsImport.GetItemNumber(llSKUPos,'seq') <> llSeq Then Continue /* not in current Sequence */
			
			//Retreive Carton DIMS if carton type exists
			lsCartonType = ldsImport.GetITemString(llSkuPos,'carton_type')
			If lsCartonType > '' and lsCartonType <> lsCartonTypeSave Then
				
				ls_wh_code = w_do.idw_Main.GetITemString(1,'wh_code')
				
				ld_Carton_length = 0
				ld_Carton_Width = 0
				ld_Carton_Height = 0
				
				Select Length, Width, height
				Into	:ld_Carton_length, :ld_Carton_Width, :ld_Carton_Height
				FRom Carton_Master
				Where (Project_id = :gs_project or Project_id = "*ALL") and wh_code = :ls_wh_code and carton_type = :lsCartonType
				Using SQLCA;
				
				lsCartonTypeSave = lsCartonType
				
			End If
			
			If lbFirstRow Then
				ll_row = w_do.idw_pack.InsertRow(0)
				w_do.idw_pack.SetItem(ll_row,"carton_no",w_do.wf_set_Pack_carton(ll_row))
				lsCarton = w_do.idw_Pack.GetITemString(ll_row,'carton_no')
				lbFirstRow = False
			Else
				ll_row = w_do.idw_pack.InsertRow(0)
				w_do.idw_pack.SetItem(ll_row,"carton_no",lsCarton)
			End If
			
			// If Item Master values found on a previous row, copy from there, otherwise retrieve Item Master
			llFindRow = w_do.idw_Pack.Find("Upper(SKU) = '" + Upper(ldsImport.GetItemString(llSKUPos,'sku')) + "'",1, w_do.idw_Pack.RowCount())
			
			If llFindRow > 0 Then
				
				If ld_Carton_length > 0 and ld_Carton_width > 0 and ld_Carton_Height > 0 Then  /*take from Carton default*/
					w_do.idw_pack.SetItem ( ll_row, 'length', ld_Carton_length)
					w_do.idw_pack.SetItem ( ll_row, 'width', ld_Carton_width)
					w_do.idw_pack.SetItem ( ll_row, 'height', ld_Carton_height)
				Else /*take from Item MAster */
					w_do.idw_pack.SetItem ( ll_row, 'length', w_do.idw_Pack.GetITemNumber(llFindRow,'length'))
					w_do.idw_pack.SetItem ( ll_row, 'width', w_do.idw_Pack.GetITemNumber(llFindRow,'width') )
					w_do.idw_pack.SetItem ( ll_row, 'height', w_do.idw_Pack.GetITemNumber(llFindRow,'height'))
				End If
				
				w_do.idw_pack.SetItem ( ll_row, 'weight_net',w_do.idw_Pack.GetITemNumber(llFindRow,'weight_net') )
				w_do.idw_pack.SetItem ( ll_row, 'weight_gross', w_do.idw_Pack.GetITemNumber(llFindRow,'weight_gross') )
				w_do.idw_pack.SetItem ( ll_row, 'cbm', (Round(w_do.idw_Pack.GetITemNumber(llFindRow,'length'),0)*Round(w_do.idw_Pack.GetITemNumber(llFindRow,'width'),0)*Round(w_do.idw_Pack.GetITemNumber(llFindRow,'height'),0)))
				w_do.idw_pack.setitem(ll_row,'country_of_origin',lsCOO)
				w_do.idw_pack.Setitem(ll_row,"standard_of_measure",ls_std_measure)	
				
			Else
			
				lsSKU = ldsImport.GetItemString(llSKUPos,'sku')
				
				SELECT Length_1, Width_1, Height_1, Weight_1,standard_of_measure,  Country_of_Origin_Default
				INTO :ld_length, :ld_width, :ld_height, :ld_weight,:ls_std_measure,  :lsCOO
				FROM Item_Master 
				WHERE Project_id = :gs_project and SKU = :lsSKU and supp_code = 'KLONELAB';
				
				If ld_Carton_length > 0 and ld_Carton_width > 0 and ld_Carton_Height > 0 Then /*take from Carton default*/
					w_do.idw_pack.SetItem ( ll_row, 'length', ld_Carton_length)
					w_do.idw_pack.SetItem ( ll_row, 'width', ld_Carton_width)
					w_do.idw_pack.SetItem ( ll_row, 'height', ld_Carton_height)
					w_do.idw_pack.SetItem ( ll_row, 'cbm', (Round(ld_Carton_length,0)*Round(ld_Carton_width,0)*Round(ld_Carton_height,0)))
				Else /*take from Item MAster */
					w_do.idw_pack.SetItem ( ll_row, 'length', ld_length)
					w_do.idw_pack.SetItem ( ll_row, 'width', ld_width )
					w_do.idw_pack.SetItem ( ll_row, 'height', ld_height)
					w_do.idw_pack.SetItem ( ll_row, 'cbm', (Round(ld_length,0)*Round(ld_width,0)*Round(ld_height,0)))
				End If
				
				w_do.idw_pack.SetItem ( ll_row, 'weight_net',ld_weight )
				w_do.idw_pack.SetItem ( ll_row, 'weight_gross', ld_weight )
				w_do.idw_pack.setitem(ll_row,'country_of_origin',lsCOO)
				w_do.idw_pack.Setitem(ll_row,"standard_of_measure",ls_std_measure)	
	
			End If
						
			w_do.idw_pack.SetItem(ll_row,"supp_code", 'KLONELAB')
			w_do.idw_pack.SetItem(ll_row,"component_ind","N")
			w_do.idw_pack.SetItem(ll_row,"c_first_carton_row","Y")
			w_do.idw_pack.SetItem(ll_row,"do_no", w_do.idw_main.GetItemString(1,"do_no"))
			w_do.idw_pack.SetItem(ll_row,"sku", ldsImport.GetItemString(llSKUPos,'sku'))
			W_do.idw_pack.SetItem(ll_row,"Project_Id",w_do.idw_Main.GetItemString(1,'project_id'))
			w_do.idw_pack.SetItem(ll_row,"qa_check_ind","")
						
//			IF NOT IsNull (w_do.idw_pack.GetITemNumber(ll_row,'Quantity')) THEN /*set gross wt*/
//				w_do.idw_pack.SetItem ( ll_row, 'weight_gross', (w_do.idw_pack.GetITemNumber(ll_row,'weight_net') * w_do.idw_pack.GetITemNumber(ll_row,'Quantity')))
//			end if	
			
			//Might override gross weight from import file
			If ldsImport.GetItemNumber(llSeqPos,'gross_weight') > 0 Then
				w_do.idw_pack.SetItem ( ll_row, 'weight_gross', ldsImport.GetItemDecimal(llSeqPos,'gross_weight') )
			End If
			
			w_do.idw_Pack.SetItem(ll_row,'carton_type',ldsImport.GetItemString(llSeqPos,'carton_type'))
			
			//w_do.idw_pack.SetItem(ll_row,"quantity",ldsImport.GetITemNumber(llSKUPos,'qty_per_Case') ) 
			//We may have the same SKU across line items and will need to balance if necessary. WE may need to split a row into multiple line items. In theory there could be many, we are going to assume for now that we won;t have to split across more than 2
			
			//Find the first line item that has room to allocate
			llFindRow = ldsDetail.Find("Upper(SKU) = '" + upper(ldsImport.GetItemString(llSKUPos,'sku')) + "' and alloc_qty < req_qty ",1, ldsDetail.RowCOunt())
			If llFindRow > 0 Then
				
				//If it will all fit, just write the record and update the line qty and line item number
				If ldsDEtail.GetITemNumber(llFindRow,'alloc_qty') + ldsImport.GetITemNumber(llSKUPos,'qty_per_Case') <= ldsDEtail.GetITemNumber(llFindRow,'req_qty') Then
					
					w_do.idw_Pack.SetITem(ll_row,'line_item_No',ldsDetail.GetItemNumber(llFindRow,'line_item_No'))
					ldsDEtail.SetITem(llFindRow,'alloc_qty', ldsDEtail.GetITemNumber(llFindRow,'alloc_qty') +  ldsImport.GetITemNumber(llSKUPos,'qty_per_Case'))
					w_do.idw_pack.SetItem(ll_row,"quantity",ldsImport.GetITemNumber(llSKUPos,'qty_per_Case') ) 
					
				Else /* need to split rows across line items */
					
					ldQty1 = ldsDEtail.GetITemNumber(llFindRow,'req_qty') - ldsDEtail.GetITemNumber(llFindRow,'alloc_qty') 
					w_do.idw_pack.SetItem(ll_row,"quantity",ldQty1)
					w_do.idw_Pack.SetITem(ll_row,'line_item_No',ldsDetail.GetItemNumber(llFindRow,'line_item_No'))
					ldsDEtail.SetITem(llFindRow,'alloc_qty', ldsDEtail.GetITemNumber(llFindRow,'req_qty'))
					
					ldQty2 =  ldsImport.GetITemNumber(llSKUPos,'qty_per_Case') - ldQty1 /*remaining to set */
					
					//Split the row
					w_do.idw_pack.RowsCopy(ll_row,ll_row,Primary!,w_do.idw_pack,9999999,Primary!)
					w_do.idw_Pack.SetITem(w_do.idw_pack.rowCount(),'quantity',ldQty2)
					
					//Find the next detail line to add qty 2
					If llFindRow < ldsDetail.RowCount() Then
						
						llFindRow = ldsDetail.Find("Upper(SKU) = '" + upper(ldsImport.GetItemString(llSKUPos,'sku')) + "' and alloc_qty < req_qty ",llFindRow + 1, ldsDetail.RowCOunt())
						
						If llFindRow > 0 Then
							ldsDEtail.SetITem(llFindRow,'alloc_qty', ldsDEtail.GetITemNumber(llFindRow,'alloc_qty') +  ldQty2)
							w_do.idw_Pack.SetITem(w_do.idw_pack.rowCount(),'line_item_No',ldsDetail.GetItemNumber(llFindRow,'line_item_No'))
						else
							w_do.idw_Pack.SetITem(w_do.idw_pack.rowCount(),'line_item_No',0)
						End If
																
					End If
						
				End If
				
			Else /* all allocated, just use first one*/
				
				llFindRow = w_do.idw_Detail.Find("Upper(SKU) = '" + Upper(ldsImport.GetItemString(llSKUPos,'sku')) + "'",1, w_do.idw_Detail.RowCount())
				If llFindRow > 0 Then
					w_do.idw_pack.SetITem(ll_row,'line_item_No',w_do.idw_detail.GetITemNUmber(llFindRow,'line_item_no'))
				Else
					w_do.idw_pack.SetITem(ll_row,'line_item_No',0)
				End If
				
			End If
			
			
			
		Next /* Sku in current carton*/
		
	Next /* Carton within Sequence*/
		
Next /* Sequence*/


w_do.wf_assignetom(2) //Assigning value of Standard_of Mesure to Radio Button	

w_do.idw_pack.Sort()
w_do.idw_pack.GroupCalc()

w_do.tab_main.tabpage_pack.cbx_show_comp_pack.Enabled = False
w_do.tab_main.tabpage_pack.cbx_show_comp_pack.Checked = False

// 02/01 PCONKL - reset filter on Pick LIst based on showing components
w_do.wf_set_pick_filter('Set')

w_do.idw_pack.Setredraw(True) /*pconkl 10/00*/

SetPointer(Arrow!)
w_do.idw_pack.SetFocus()

w_do.ib_changed = True

Return 0
end function

public function integer uf_packprint_friedrich ();//// This function prints the Packing List for Friedrich which is currently visible on the screen 
//// and not from the database 

 
Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos, llNotesCount, llNotesPos, ll_picked_qty, ll_ord_qty, llim_qty2
Decimal ld_weight, ld_costcenter
String ls_address,lsfind,ls_text[], lscusttype, lscustcode, lsSerial, lsNotes, ls_dono, lsim_uf11
String ls_project_id , ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName, lsDONO
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT, lsUPC, lsPrinter, lsVol, lsNativeDesc, lsGrp
String ls_d_packing_prt, ls_cust_name
Long 	llpackqty,llscannedqty ,llserialcnt,lleligiblecnt  //03-Jan-2014 :Madhu- Added

Datastore       ldsHazmat, ldsNotes


//DataObject...  // 09/2014 change to custom layout modled after baseline
ls_d_packing_prt = 'd_friedrich_packing_prt'

// pvh - 09/18/06 - Added packing print do to project table.
string PackDo
PackDo = g.getPackPrintDo()
w_do.idw_packprint.Dataobject = ls_d_packing_prt   //10/11/2010 ujh allow for dataobject with supplier column removed
if PackDo > '' then w_do.idw_packprint.Dataobject = PackDo

SetPointer(HourGlass!)
If w_do.idw_pack.AcceptText() = -1 Then
        w_do.tab_main.SelectTab(3) 
        w_do.idw_pack.SetFocus()
        Return 0
End If
 
If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
        Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
        Return 0
End If
 
 //03-Jan-2014 :Madhu -Added code to verify whether all serial no's are scanned? -START
lsDONO =w_do.idw_main.GetItemString(1,"Do_No")

//get eligible records for scanning
// TAM 2014/01/15 - Changed from Count to Sum.  Not all items are scannable and we only want to compare the number of Scannable with the number of serials
//select count(*) into :lleligiblecnt from Delivery_Packing,Item_Master
select sum(Quantity) into :lleligiblecnt from Delivery_Packing,Item_Master
where Delivery_Packing.SKU = Item_Master.SKU
and Delivery_Packing.Supp_Code= Item_Master.Supp_code
and Delivery_Packing.DO_No= :lsDONO
and Item_Master.Serialized_Ind in ('Y','B')
using SQLCA;

If lleligiblecnt >0 Then
//TAM	Select sum(Quantity) into :llpackqty from Delivery_Packing where Do_No =:lsDONO using SQLCA;
	Select Sum(quantity) into :llScannedQty from delivery_serial_detail Where Id_no in (select id_no from delivery_picking_detail where do_no = :lsDONO) using SQLCA;
	
	If IsNull(llScannedQty) then 
		llScannedQty =0 
	end if
	
//TAM	If llpackqty <> llScannedQty Then
	If lleligiblecnt <> llScannedQty Then
		MessageBox(w_do.is_title,"All Serial no's are not being scanned. Please check.",Stopsign!)
		Return 0
	End if 
End if 

//03-Jan-2014 :Madhu - Added code to verify whether all serial no's are scanned? -END

//No row means no Print
ll_cnt = w_do.idw_pack.rowcount()
If ll_cnt = 0 Then
        MessageBox("Print Packing List"," No records to print!")
        Return 0
End If
 
//Clear the Report Window (hidden datawindow)
w_do.idw_packprint.Reset()
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// *** 07/09 - PCONKL - All baseline Packing Lists now pulling Ship From address fom Warehouse table.
// For those projects that were pulling from Project, the address info has been copied over 
// to the Warehouse table. This should be transparent to the users
       
lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")

Select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
Into    :lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
From warehouse
Where WH_Code = :lsWHCode
Using Sqlca;
 
// Get the cost center.
nvo_order lnvo_order
lnvo_order = Create nvo_order
lnvo_order.f_getcostcenter(1, ld_costcenter)
Destroy lnvo_order
 
//Loop through each row in Tab pages and grab the corresponding info
For i = 1 to ll_cnt
	
	ls_sku = w_do.idw_pack.getitemstring(i,"sku")
	ls_supplier = w_do.idw_pack.getitemstring(i,"supp_code")
	llLineItemNo = w_do.idw_pack.GetITemNumber(i,'line_item_no')
	
	//Is Customer Rite Aid?
	ls_cust_name = w_do.idw_main.getitemstring(1,"cust_name")
	
 	j = w_do.idw_packprint.InsertRow(0)
	w_do.idw_packprint.setitem(j,"picked_quantity",w_do.idw_pack.getitemNumber(i,"quantity"))
	w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_pack.getitemNumber(i,"quantity"))
	w_do.idw_packprint.setitem(j,"carton_no",w_do.idw_pack.getitemString(i,"carton_no"))
	w_do.idw_packprint.setitem(j,"volume",w_do.idw_pack.getitemDecimal(i,"cbm"))
	If w_do.idw_pack.getitemDecimal(i,"cbm") > 0 Then
    		  w_do.idw_packprint.setitem(j,'dimensions',string(w_do.idw_pack.getitemDecimal(i,"length")) + ' x ' + string(w_do.idw_pack.getitemDecimal(i,"width")) + ' x ' + string(w_do.idw_pack.getitemDecimal(i,"height"))) 
	End If
			
	//Get SKU, Description and Quantities  04/05/00 PCONKL - include user field5 as pdc_whse_loc
    // 02/02 - PConkl - include hazardous text cd
 
	If ls_SKU <> lsSKUHold Then
				 
				 select description, weight_1, hazard_text_cd, part_upc_Code, user_field8, native_description, grp, qty_2, user_field11    /* 05/09 - PCONKL - UF8 = Volume for Philips */ /* TAM W&S 2011/03 added qty2 and uf11 */
				 into :ls_description, :ld_weight, :lshazCode, :lsUPC, :lsVol, :lsnativeDesc, :lsGrp, :llim_qty2, :lsim_uf11
				 from item_master 
				 where project_id = :ls_project_id and sku = :ls_sku and supp_code = :ls_supplier ;
				 
	End If /*Sku Changed*/
	  
	lsSkuHold = ls_SKU

	ls_description = trim(ls_description)
      
	  // 02/02 PCONKL - If there is hazardous material text for this SKU/Ship Method, retrieve the text for the report
	  lshazText = ''
	  If lshazCode > '' Then /*haz text exists for this sku*/
				 llhazCount = ldsHazmat.Retrieve(gs_project,lshazCode,lsTransportMode)
				 If llHazCount > 0 Then
							For llHazPos = 1 to llHazCount
									  lsHazText += ldshazMat.GetItemString(llHazPos,'hazard_text') + '~r'
							Next
				 End If
	  End If /*haz text exists*/
	
	 w_do.idw_packprint.setitem(j,"ord_no",w_do.idw_main.getitemstring(1,"cust_order_no"))
	
	  w_do.idw_packprint.setitem(j,"costcenter", string(ld_costcenter))
	  w_do.idw_packprint.setitem(j,"bol_no",w_do.is_bolno)
	  w_do.idw_packprint.setitem(j,"freight_terms",w_do.idw_other.getitemstring(1,"freight_terms"))     
	  w_do.idw_packprint.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code")) 
	  w_do.idw_packprint.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
	  w_do.idw_packprint.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
	  w_do.idw_packprint.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
	  w_do.idw_packprint.setitem(j,"complete_date",w_do.idw_main.getitemdatetime(1,"complete_date"))
	  
	  //10/11/2010 ujh use variable to allow for dataobject with supplier column removed
	IF w_do.idw_packprint.Dataobject = ls_d_packing_prt THEN
			w_do.idw_packprint.setitem(j,"schedule_date",w_do.idw_main.getitemdatetime(1,"schedule_date"))			
	END IF
	  
	  w_do.idw_packprint.setitem(j,"sku",ls_sku)
	  w_do.idw_packprint.setitem(j,"description",ls_description)
	
	  w_do.idw_packprint.setitem(j,"standard_of_measure",w_do.idw_pack.getitemString(i,"standard_of_measure"))
	  w_do.idw_packprint.setitem(j,"carrier", w_do.idw_other.getitemString(1,"carrier") )
	  w_do.idw_packprint.setitem(j,"ship_via",w_do.idw_other.getitemString(1,"ship_via")) 
	  w_do.idw_packprint.setitem(j,"sch_cd",w_do.idw_other.getitemString(1,"user_field1")) 
	  w_do.idw_packprint.setitem(j,"packlist_notes",w_do.idw_main.getitemString(1,"packlist_notes")) 
	  w_do.idw_packprint.setitem(j,"upc_Code",lsUPC) 
	  w_do.idw_packprint.setitem(j,"project_id",gs_project) 
	  w_do.idw_packprint.setitem(j,"HazText",lshazText) 
	
	  
	  //For English to Metrtics changes added L or K based on E or M
	  ls_etom=w_do.idw_packprint.getitemString(j,"standard_of_measure")
	  IF ls_etom <> "" and not isnull(ls_etom) and j=1 THEN
				 IF ls_etom = 'E' THEN
							ls_text[1]="unit_w_t.Text='"+w_do.is_text[1]+"L'"                    
							ls_text[2]="ext_w_t.Text='"+w_do.is_text[2]+"L'"
							ls_text[3]="etom_t.Text='INCHES'"
				 ELSE
							ls_text[1]="unit_w_t.Text='"+w_do.is_text[1]+"K'"
							ls_text[2]="ext_w_t.Text='"+w_do.is_text[2]+"K'"
					//Jxlim 08/24/2010 Modified for Chinese report		
					 If w_do.idw_packprint.Dataobject = 'd_packing_prt_chinese' Then	
								ls_text[3]="etom_t.Text='??'"
					Else
						ls_text[3]="etom_t.Text='CENTIMETERS'"
					End if
					//Jxlim 08/24/2010 End of modified for Chinese report
				 END IF
	  END IF  
	  
	  lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLineItemNo)
	  llRow = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
	  
	  if llRow > 0 Then
			 w_do.idw_packprint.setitem(j,"alt_sku",w_do.idw_detail.getitemString(llRow,"alternate_sku"))
	  End If 
	  
	  w_do.idw_packprint.setitem(j,"country_of_origin",w_do.idw_pack.getitemstring(i,"country_of_origin")) 
	  w_do.idw_packprint.setitem(j,"supp_code",w_do.idw_pack.getitemstring(i,"supp_code")) 
	  
	  // 10/07 - PCONKL - Get Serial Numbers from serial tab(Outbound)
	  If w_do.idw_serial.RowCount() > 0 Then
				 
				 lsSerial = ""
				 lsFind = "Upper(Carton_No) = '" + Upper(w_do.idw_Pack.GetItemString(i,'carton_no')) + "' and line_item_No = " + String(w_do.idw_Pack.GetITemNumber(i,'line_item_No'))
				 llFindRow = w_do.idw_serial.Find(lsFind,1,w_do.idw_serial.RowCOunt())
				 Do While llFindRow > 0
				 
							lsSerial += ", " + w_do.idw_serial.GetItemString(llFindRow,'serial_no')
				 
							llFindRow ++
							If llFindRow > w_do.idw_serial.RowCount() Then
									  lLFindRow = 0
							Else
									  llFindRow = w_do.idw_serial.Find(lsFind,llFindRow,w_do.idw_serial.RowCOunt())
							End If
				 
				 Loop
				 
				 If Left(lsSerial,2) = ', ' Then lsSerial = mid(lsSerial,3,999999999)
				 w_do.idw_packprint.setitem(j,"serial_no",lsSerial)
	  
	  End If /*serial numbers exist*/
				 
	  w_do.idw_packprint.setitem(j,"serial_no",w_do.idw_pack.getitemstring(i,"free_form_serial_no")) /* 02/01 - PCONKL*/
	  
	  w_do.idw_packprint.setitem(j,"component_ind",w_do.idw_pack.getitemstring(i,"component_ind")) /* 02/01 - PCONKL - sort component master to top*/
	  
	  w_do.idw_packprint.setitem(j,"unit_weight",w_do.idw_pack.getitemDecimal(i,"weight_net"))
	  w_do.idw_packprint.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
	  w_do.idw_packprint.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
	  w_do.idw_packprint.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
	  w_do.idw_packprint.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
	  w_do.idw_packprint.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
	  w_do.idw_packprint.setitem(j,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
	  w_do.idw_packprint.setitem(j,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
	  w_do.idw_packprint.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
	  
	  // 07/00 PCONKL - Ship from info is coming from Project Table  
	  w_do.idw_packprint.setitem(j,"ship_from_name",lsName)
	  w_do.idw_packprint.setitem(j,"ship_from_address1",lsaddr1)
	  w_do.idw_packprint.setitem(j,"ship_from_address2",lsaddr2)
	  w_do.idw_packprint.setitem(j,"ship_from_address3",lsaddr3)
	  w_do.idw_packprint.setitem(j,"ship_from_address4",lsaddr4)
	  w_do.idw_packprint.setitem(j,"ship_from_city",lsCity)
	  w_do.idw_packprint.setitem(j,"ship_from_state",lsstate)
	  w_do.idw_packprint.setitem(j,"ship_from_zip",lszip)
	  w_do.idw_packprint.setitem(j,"ship_from_country",lscountry)
	
	  w_do.idw_packprint.setitem(j,"staging_location",w_do.idw_pick.getitemstring(1,"staging_location"))
	  
		         
Next /*PAcking Row */
 
i=1
FOR i = 1 TO UpperBound(ls_text[])
        w_do.idw_packprint.Modify(ls_text[i])
        ls_text[i]=""
NEXT
 
w_do.idw_packprint.Sort()
w_do.idw_packprint.GroupCalc()
 
//If we have a default printer for PackList, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','PACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

w_do.idw_packprint.Object.t_costcenter.Y= long(w_do.idw_packprint.Describe("costcenter.y")) 
 
//Send the report to the Print report window
OpenWithParm(w_dw_print_options,w_do.idw_packprint) 
 
//We want to store the last printer used for Printing the Pack List for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','PACKLIST',lsPrinter)
 
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "I" Then 
                w_do.idw_main.SetItem(1,"ord_status","A")
                w_do.ib_changed = TRUE
                w_do.iw_window.trigger event ue_save()
        End If
End If
 
RETURN 0
end function

public function integer uf_packprint_friedrich_grainger ();//// This function prints the Packing List for Friedrich which is currently visible on the screen 
//// and not from the database 

 
Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos, llNotesCount, llNotesPos, ll_picked_qty, ll_ord_qty, llim_qty2
Decimal ld_weight, ld_costcenter
String ls_address,lsfind,ls_text[], lscusttype, lscustcode, lsSerial, lsNotes, ls_dono, lsim_uf11, ls_uf1, ls_uf2
String ls_project_id , ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName, lsDONO
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT, lsUPC, lsPrinter, lsVol, lsNativeDesc, lsGrp
String ls_d_packing_prt, ls_cust_name

Datastore       ldsHazmat, ldsNotes


//DataObject...
ls_d_packing_prt = 'd_friedrich_grainger_packing_prt'

// pvh - 09/18/06 - Added packing print do to project table.
string PackDo
PackDo = g.getPackPrintDo()
w_do.idw_packprint.Dataobject = ls_d_packing_prt   //10/11/2010 ujh allow for dataobject with supplier column removed
if PackDo > '' then w_do.idw_packprint.Dataobject = PackDo


SetPointer(HourGlass!)
If w_do.idw_pack.AcceptText() = -1 Then
        w_do.tab_main.SelectTab(3) 
        w_do.idw_pack.SetFocus()
        Return 0
End If
 
If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
        Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
        Return 0
End If
 
//No row means no Print
ll_cnt = w_do.idw_pack.rowcount()
If ll_cnt = 0 Then
        MessageBox("Print Packing List"," No records to print!")
        Return 0
End If
 
//Clear the Report Window (hidden datawindow)
w_do.idw_packprint.Reset()
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// *** 07/09 - PCONKL - All baseline Packing Lists now pulling Ship From address fom Warehouse table.
// For those projects that were pulling from Project, the address info has been copied over 
// to the Warehouse table. This should be transparent to the users
       
lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")

Select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
Into    :lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
From warehouse
Where WH_Code = :lsWHCode
Using Sqlca;
 
// Get the cost center.
nvo_order lnvo_order
lnvo_order = Create nvo_order
lnvo_order.f_getcostcenter(1, ld_costcenter)
Destroy lnvo_order
 
//Loop through each row in Tab pages and grab the corresponding info
For i = 1 to ll_cnt
	
	ls_sku = w_do.idw_pack.getitemstring(i,"sku")
	ls_supplier = w_do.idw_pack.getitemstring(i,"supp_code")
	llLineItemNo = w_do.idw_pack.GetITemNumber(i,'line_item_no')
	ls_uf1 = w_do.idw_pack.getitemstring(i,"user_field1")
//	ls_uf2 = w_do.idw_pack.getitemstring(i,"user_field2")
	If IsNull(ls_uf1) 	then ls_uf1 = ''
//	If IsNull(ls_uf2) 	then ls_uf2 = ''
	
	//Is Customer Rite Aid?
	ls_cust_name = w_do.idw_main.getitemstring(1,"cust_name")

// TAM 2014/03 Added delivery_packing/user_field1	
//	w_do.idw_packprint.setitem(j,"delivery_packing_uf1",w_do.idw_pack.getitemString(i,"user_field1"))

	llFindRow = 0
	If ls_uf1 > '' Then
		lsfind ="Carton_No = '" + w_do.idw_pack.getitemString(i,"carton_no") + "' and Upper(sku) = '" + Upper(ls_uf1) + "'"
		llFindRow = w_do.idw_packPrint.Find(lsfind,llFindRow,w_do.idw_PackPrint.rowCount())
	End if		

	If llFindRow = 0 Then 
	
 		j = w_do.idw_packprint.InsertRow(0)

	
		w_do.idw_packprint.setitem(j,"picked_quantity",w_do.idw_pack.getitemNumber(i,"quantity"))
	//	w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_pack.getitemNumber(i,"quantity"))
		w_do.idw_packprint.setitem(j,"carton_no",w_do.idw_pack.getitemString(i,"carton_no"))
		w_do.idw_packprint.setitem(j,"volume",w_do.idw_pack.getitemDecimal(i,"cbm"))
		If w_do.idw_pack.getitemDecimal(i,"cbm") > 0 Then
	    		  w_do.idw_packprint.setitem(j,'dimensions',string(w_do.idw_pack.getitemDecimal(i,"length")) + ' x ' + string(w_do.idw_pack.getitemDecimal(i,"width")) + ' x ' + string(w_do.idw_pack.getitemDecimal(i,"height"))) 
		End If

	// TAM 2014/03 Added delivery_packing/user_field1	and 2
		w_do.idw_packprint.setitem(j,"delivery_packing_uf1",w_do.idw_pack.getitemString(i,"user_field1"))
		w_do.idw_packprint.setitem(j,"delivery_packing_uf2",w_do.idw_pack.getitemString(i,"user_field2"))
		
		//Get SKU, Description and Quantities  04/05/00 PCONKL - include user field5 as pdc_whse_loc
	    // 02/02 - PConkl - include hazardous text cd
 
		If ls_SKU <> lsSKUHold Then
				 
			 select description, weight_1, hazard_text_cd, part_upc_Code, user_field8, native_description, grp, qty_2, user_field11    /* 05/09 - PCONKL - UF8 = Volume for Philips */ /* TAM W&S 2011/03 added qty2 and uf11 */
			 into :ls_description, :ld_weight, :lshazCode, :lsUPC, :lsVol, :lsnativeDesc, :lsGrp, :llim_qty2, :lsim_uf11
			 from item_master 
			 where project_id = :ls_project_id and sku = :ls_sku and supp_code = :ls_supplier ;
				 
		End If /*Sku Changed*/
	  
		lsSkuHold = ls_SKU

		ls_description = trim(ls_description)
      
		 // 02/02 PCONKL - If there is hazardous material text for this SKU/Ship Method, retrieve the text for the report
		lshazText = ''
		 If lshazCode > '' Then /*haz text exists for this sku*/
			llhazCount = ldsHazmat.Retrieve(gs_project,lshazCode,lsTransportMode)
			If llHazCount > 0 Then
				For llHazPos = 1 to llHazCount
					  lsHazText += ldshazMat.GetItemString(llHazPos,'hazard_text') + '~r'
				Next
			 End If
		End If /*haz text exists*/
	
		w_do.idw_packprint.setitem(j,"ord_no",w_do.idw_main.getitemstring(1,"cust_order_no"))
	
		w_do.idw_packprint.setitem(j,"costcenter", string(ld_costcenter))
		w_do.idw_packprint.setitem(j,"bol_no",w_do.is_bolno)
		w_do.idw_packprint.setitem(j,"freight_terms",w_do.idw_other.getitemstring(1,"freight_terms"))     
		w_do.idw_packprint.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code")) 
		w_do.idw_packprint.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
		w_do.idw_packprint.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
		w_do.idw_packprint.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
		w_do.idw_packprint.setitem(j,"complete_date",w_do.idw_main.getitemdatetime(1,"complete_date"))
	  
		//10/11/2010 ujh use variable to allow for dataobject with supplier column removed
		IF w_do.idw_packprint.Dataobject = ls_d_packing_prt THEN
			w_do.idw_packprint.setitem(j,"schedule_date",w_do.idw_main.getitemdatetime(1,"schedule_date"))			
		END IF
	  
		w_do.idw_packprint.setitem(j,"sku",ls_sku)
		w_do.idw_packprint.setitem(j,"description",ls_description)
	
		w_do.idw_packprint.setitem(j,"standard_of_measure",w_do.idw_pack.getitemString(i,"standard_of_measure"))
		w_do.idw_packprint.setitem(j,"carrier", w_do.idw_other.getitemString(1,"carrier") )
		w_do.idw_packprint.setitem(j,"ship_via",w_do.idw_other.getitemString(1,"ship_via")) 
		w_do.idw_packprint.setitem(j,"sch_cd",w_do.idw_other.getitemString(1,"user_field1")) 
		w_do.idw_packprint.setitem(j,"packlist_notes",w_do.idw_main.getitemString(1,"packlist_notes")) 
		w_do.idw_packprint.setitem(j,"upc_Code",lsUPC) 
		w_do.idw_packprint.setitem(j,"project_id",gs_project) 
		w_do.idw_packprint.setitem(j,"HazText",lshazText) 
		w_do.idw_packprint.setitem(j,"carrier_pro_no", w_do.idw_other.getitemString(1,"carrier_pro_no"))    //Jxlim 04/06/2014 Added Carrier_pro_no
	
	  
		//For English to Metrtics changes added L or K based on E or M
		ls_etom=w_do.idw_packprint.getitemString(j,"standard_of_measure")
		IF ls_etom <> "" and not isnull(ls_etom) and j=1 THEN
			IF ls_etom = 'E' THEN
				ls_text[1]="unit_w_t.Text='"+w_do.is_text[1]+"L'"                    
				ls_text[2]="ext_w_t.Text='"+w_do.is_text[2]+"L'"
				ls_text[3]="etom_t.Text='INCHES'"
			ELSE
				ls_text[1]="unit_w_t.Text='"+w_do.is_text[1]+"K'"
				ls_text[2]="ext_w_t.Text='"+w_do.is_text[2]+"K'"
				//Jxlim 08/24/2010 Modified for Chinese report		
				If w_do.idw_packprint.Dataobject = 'd_packing_prt_chinese' Then	
					ls_text[3]="etom_t.Text='??'"
				Else
					ls_text[3]="etom_t.Text='CENTIMETERS'"
				End if
				//Jxlim 08/24/2010 End of modified for Chinese report
			END IF
		END IF  
	END IF  
	  
	  lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLineItemNo)
	  llRow = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
	  
	  if llRow > 0 Then
			w_do.idw_packprint.setitem(j,"alt_sku",w_do.idw_detail.getitemString(llRow,"alternate_sku"))
			w_do.idw_packprint.setitem(j,"ord_qty",w_do.idw_detail.getitemNumber(llRow,"req_qty"))
	  End If 

	// TAM 2014/03 Added delivery_packing/user_field1	
		If ls_uf1 > '' Then
			w_do.idw_packprint.setitem(j,"delivery_packing_uf1",ls_uf1)
//			w_do.idw_packprint.setitem(j,"delivery_packing_uf2",ls_uf2)
			w_do.idw_packprint.setitem(j,"sku",ls_uf1)
			w_do.idw_packprint.setitem(j,"description","SINGLE ZONE")
			w_do.idw_packprint.setitem(j,"upc_Code",'') 
			w_do.idw_packprint.setitem(j,"Alt_Sku",'') 
		End If
	  
	  w_do.idw_packprint.setitem(j,"country_of_origin",w_do.idw_pack.getitemstring(i,"country_of_origin")) 
	  w_do.idw_packprint.setitem(j,"supp_code",w_do.idw_pack.getitemstring(i,"supp_code")) 
	  
	  // 10/07 - PCONKL - Get Serial Numbers from serial tab(Outbound)
	  If w_do.idw_serial.RowCount() > 0 Then
				 
				 lsSerial = ""
				 lsFind = "Upper(Carton_No) = '" + Upper(w_do.idw_Pack.GetItemString(i,'carton_no')) + "' and line_item_No = " + String(w_do.idw_Pack.GetITemNumber(i,'line_item_No'))
				 llFindRow = w_do.idw_serial.Find(lsFind,1,w_do.idw_serial.RowCOunt())
				 Do While llFindRow > 0
				 
							lsSerial += ", " + w_do.idw_serial.GetItemString(llFindRow,'serial_no')
				 
							llFindRow ++
							If llFindRow > w_do.idw_serial.RowCount() Then
									  lLFindRow = 0
							Else
									  llFindRow = w_do.idw_serial.Find(lsFind,llFindRow,w_do.idw_serial.RowCOunt())
							End If
				 
				 Loop
				 
				 If Left(lsSerial,2) = ', ' Then lsSerial = mid(lsSerial,3,999999999)
				 w_do.idw_packprint.setitem(j,"serial_no",lsSerial)
	  
	  End If /*serial numbers exist*/
				 
	  w_do.idw_packprint.setitem(j,"serial_no",w_do.idw_pack.getitemstring(i,"free_form_serial_no")) /* 02/01 - PCONKL*/
	  
	  w_do.idw_packprint.setitem(j,"component_ind",w_do.idw_pack.getitemstring(i,"component_ind")) /* 02/01 - PCONKL - sort component master to top*/
	  
	  w_do.idw_packprint.setitem(j,"unit_weight",w_do.idw_pack.getitemDecimal(i,"weight_net"))
	  w_do.idw_packprint.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
	  w_do.idw_packprint.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
	  w_do.idw_packprint.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
	  w_do.idw_packprint.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
	  w_do.idw_packprint.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
	  w_do.idw_packprint.setitem(j,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
	  w_do.idw_packprint.setitem(j,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
	  w_do.idw_packprint.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
	  
	  // 07/00 PCONKL - Ship from info is coming from Project Table  
	  w_do.idw_packprint.setitem(j,"ship_from_name",lsName)
	  w_do.idw_packprint.setitem(j,"ship_from_address1",lsaddr1)
	  w_do.idw_packprint.setitem(j,"ship_from_address2",lsaddr2)
	  w_do.idw_packprint.setitem(j,"ship_from_address3",lsaddr3)
	  w_do.idw_packprint.setitem(j,"ship_from_address4",lsaddr4)
	  w_do.idw_packprint.setitem(j,"ship_from_city",lsCity)
	  w_do.idw_packprint.setitem(j,"ship_from_state",lsstate)
	  w_do.idw_packprint.setitem(j,"ship_from_zip",lszip)
	  w_do.idw_packprint.setitem(j,"ship_from_country",lscountry)
	
	  w_do.idw_packprint.setitem(j,"staging_location",w_do.idw_pick.getitemstring(1,"staging_location"))
	  
Next /*PAcking Row */
 
i=1
FOR i = 1 TO UpperBound(ls_text[])
        w_do.idw_packprint.Modify(ls_text[i])
        ls_text[i]=""
NEXT
 
w_do.idw_packprint.Sort()
w_do.idw_packprint.GroupCalc()
 
//If we have a default printer for PackList, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','PACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

w_do.idw_packprint.Object.t_costcenter.Y= long(w_do.idw_packprint.Describe("costcenter.y")) 
 
//Send the report to the Print report window
OpenWithParm(w_dw_print_options,w_do.idw_packprint) 
 
//We want to store the last printer used for Printing the Pack List for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','PACKLIST',lsPrinter)
 
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "I" Then 
                w_do.idw_main.SetItem(1,"ord_status","A")
                w_do.ib_changed = TRUE
                w_do.iw_window.trigger event ue_save()
        End If
End If
 
RETURN 0
end function

public function integer uf_process_packprint_friedrich ();Long	llRowCount
String lsDono, lsShipToName
Datastore	lds_st
integer li_return

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print (the data is coming from deliveryy Detail but we want to make sure the pack list is generated first)
llRowCount = w_do.idw_pack.rowcount()
If llRowCount = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

lsdono= w_do.idw_main.GetitemString(1,'Do_No')
lsShipToName = w_do.idw_main.GetitemString(1,'Cust_Name')

// Get Sold To Addess
lds_st =Create Datastore
lds_st.Dataobject='d_do_address_alt'
lds_st.SetTransObject(SQLCA)
lds_st.Retrieve(lsdono, 'ST')


SetPointer(Hourglass!)

// Determin Which packlist to print

//If Ship To Contains Grainger then print Grainger Packing List
If  Pos(upper(lsShipToName), 'GRAINGER' ) > 0 then
// TAM 2015/05/14 - Print the grainger Dropship Packing list for all of Grainger.  The format is identical.  The only difference is which number to use as the Custom PO.
//	li_return = this.uf_packprint_friedrich_grainger( )
	li_return = this.uf_packprint_friedrich_grainger_dropship('N' )
	Return li_return
Else
	//If Sold To Contains Grainger then it is a Grainger DropShip
	llRowCount = lds_st.rowcount()
	If llRowCount > 0 Then
		If  Pos(upper(lds_st.getItemString(1,'Name')), 'GRAINGER' ) > 0 then
			li_return = this.uf_packprint_friedrich_grainger_dropship('D' )
			Return li_return
		End If
	End If
End If

// Not Grainger print Friedrich Packilist
li_return = this.uf_packprint_friedrich( )
Return li_return
end function

public function integer uf_packprint_petha ();//BCR 21-NOV-2011: Print the Geistlich packing slip


Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llFindRow, llhazCount, llHazPos, llNotesCount, llNotesPos
Decimal ld_weight, ld_costcenter
String ls_address,lsfind,ls_text[], lscusttype, lscustcode, lsSerial, lsNotes
String ls_sku ,lsSKUHold,  ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode
String ls_inventory_type_desc,ls_etom, lsSupplierName, lsDONO
String lsWHCode,lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,lsVAT, lsUPC, lsPrinter, lsVol, lsNativeDesc, lsGrp
String ls_d_packing_prt, lsim_uf11, ls_dono
Long llim_qty2, llRowCount, llRowPOs, llNewRow

Datastore       ldsHazmat, ld_packprint


If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print (the data is coming from deliveryy Detail but we want to make sure the pack list is generated first)
llRowCount = w_do.idw_pack.rowcount()
If llRowCount = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

SetPointer(Hourglass!)

ld_packprint = Create Datastore
ld_packprint.dataobject ='d_petha_packing_prt'

//Get Ship From info from Warehouse table...
lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")
        
        Select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
        Into    :lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
        From warehouse
        Where WH_Code = :lsWHCode
        Using Sqlca;

//For each detail row, generate the pack data

llRowCount = w_do.idw_detail.RowCount()
For llRowPOs = 1 to llRowCount
	
	llNewRow = ld_packprint.InsertRow(0)
	
        //Get SKU, Description and Quantities  
        
        ls_sku = w_do.idw_pack.getitemstring(llRowPOs,"sku")
        ls_supplier = w_do.idw_pack.getitemstring(llRowPOs,"supp_code")
        llLineItemNo = w_do.idw_pack.GetITemNumber(llRowPOs,'line_item_no')
        
        If ls_SKU <> lsSKUHold Then
                
                select description, weight_1, hazard_text_cd, part_upc_Code, user_field8, native_description, grp, qty_2, user_field11  , Alternate_Sku /* 05/09 - PCONKL - UF8 = Volume for Philips */ /* TAM W&S 2011/03 added qty2 and uf11 */
                into :ls_description, :ld_weight, :lshazCode, :lsUPC, :lsVol, :lsnativeDesc, :lsGrp, :llim_qty2, :lsim_uf11 , :ls_alt_sku 
                from item_master 
                where project_id = :gs_project and sku = :ls_sku and supp_code = :ls_supplier 
			   using Sqlca;
                
        End If /*Sku Changed*/
        
        lsSkuHold = ls_SKU
	    
	   ls_description = trim(ls_description)
			
        // 02/02 PCONKL - If there is hazardous material text for this SKU/Ship Method, retrieve the text for the report
        lshazText = ''
        If lshazCode > '' Then /*haz text exists for this sku*/
                llhazCount = ldsHazmat.Retrieve(gs_project,lshazCode,lsTransportMode)
                If llHazCount > 0 Then
                        For llHazPos = 1 to llHazCount
                                lsHazText += ldshazMat.GetItemString(llHazPos,'hazard_text') + '~r'
                        Next
                End If
        End If /*haz text exists*/
        
        //Set all Items on the Report by grabbing info from tab pages
		
	  	//	   ld_packprint.setitem(llNewRow,"ord_no",w_do.idw_main.getitemstring(1,"cust_order_no"))	
	   //User request to change the Cust order number field with User field12 20161102 nxjain
	   ld_packprint.setitem(llNewRow,"ord_no",w_do.idw_main.getitemstring(1,"user_field12"))		
	    ld_packprint.setitem(llNewRow,"System_no",w_do.idw_other.getitemString(1,"Do_no")) 
        ld_packprint.setitem(llNewRow,"costcenter", string(ld_costcenter))
        ld_packprint.setitem(llNewRow,"carton_no",w_do.idw_pack.getitemString(llRowPOs,"carton_no")) 
        ld_packprint.setitem(llNewRow,"bol_no",w_do.is_bolno)
        ld_packprint.setitem(llNewRow,"freight_terms",w_do.idw_other.getitemstring(1,"freight_terms"))     
        ld_packprint.setitem(llNewRow,"cust_code",w_do.idw_main.getitemstring(1,"cust_code")) 
        ld_packprint.setitem(llNewRow,"city",w_do.idw_main.getitemstring(1,"city"))
        ld_packprint.setitem(llNewRow,"country",w_do.idw_main.getitemstring(1,"country"))
        ld_packprint.setitem(llNewRow,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
        ld_packprint.setitem(llNewRow,"complete_date",w_do.idw_main.getitemdatetime(1,"complete_date"))  
	   ld_packprint.setitem(llNewRow,"schedule_date",w_do.idw_main.getitemdatetime(1,"schedule_date"))			
        ld_packprint.setitem(llNewRow,"sku",ls_sku)
        ld_packprint.setitem(llNewRow,"description",ls_description)
 	   ld_packprint.setitem(llNewRow,"net_wgt",w_do.idw_pack.getitemDecimal(llRowPOs,"weight_net")) 
	   ld_packprint.setitem(llNewRow,"gross_wgt",w_do.idw_pack.getitemDecimal(llRowPOs,"weight_gross"))
        ld_packprint.setitem(llNewRow,"standard_of_measure",w_do.idw_pack.getitemString(llRowPOs,"standard_of_measure"))
        ld_packprint.setitem(llNewRow,"carrier", w_do.idw_other.getitemString(1,"carrier") )
        ld_packprint.setitem(llNewRow,"ship_via",w_do.idw_other.getitemString(1,"ship_via")) 
        ld_packprint.setitem(llNewRow,"sch_cd",w_do.idw_other.getitemString(1,"user_field1")) 
        ld_packprint.setitem(llNewRow,"packlist_notes",w_do.idw_main.getitemString(1,"packlist_notes"))
        ld_packprint.setitem(llNewRow,"project_id",gs_project)
	  ld_packprint.setitem(llNewRow,"alt_sku",ls_alt_sku)
        ld_packprint.setitem(llNewRow,"HazText",lshazText) 
        ld_packprint.setitem(llNewRow,"user_field8",w_do.idw_other.getitemString(1,"user_field8")) //TAM 04/2013





        //For English to Metrtics changes added L or K based on E or M
        ls_etom=ld_packprint.getitemString(llNewRow,"standard_of_measure")
        IF ls_etom <> "" and not isnull(ls_etom) and llNewRow=1 THEN
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
             
	   ld_packprint.setitem(llNewRow,"lot_nbr",w_do.idw_pack.getitemstring(llRowPOs,"user_field1")) 
        ld_packprint.setitem(llNewRow,"picked_quantity",w_do.idw_pack.getitemNumber(llRowPOs,"quantity")) 
        ld_packprint.setitem(llNewRow,"volume",w_do.idw_pack.getitemDecimal(llRowPOs,"cbm")) 
	   ld_packprint.setitem(llNewRow,"uom",w_do.idw_detail.getitemString(llRowPOs,"uom"))
       
        If w_do.idw_pack.getitemDecimal(llRowPOs,"cbm") > 0 Then
                ld_packprint.setitem(llNewRow,'pack_size',string(w_do.idw_pack.getitemDecimal(llRowPOs,"length")) + ' x ' + string(w_do.idw_pack.getitemDecimal(llRowPOs,"width")) + ' x ' + string(w_do.idw_pack.getitemDecimal(llRowPOs,"height"))) /* 02/01 - PCONKL*/
        End If
        ld_packprint.setitem(llNewRow,"country_of_origin",w_do.idw_pack.getitemstring(llRowPOs,"country_of_origin")) 
        ld_packprint.setitem(llNewRow,"supp_code",w_do.idw_pack.getitemstring(llRowPOs,"supp_code")) 
        
        // 10/07 - PCONKL - Get Serial Numbers from serial tab(Outbound)
        If w_do.idw_serial.RowCount() > 0 Then
                
                lsSerial = ""
                lsFind = "Upper(Carton_No) = '" + Upper(w_do.idw_Pack.GetItemString(llRowPOs,'carton_no')) + "' and line_item_No = " + String(w_do.idw_Pack.GetITemNumber(llRowPOs,'line_item_No'))
                llFindRow = w_do.idw_serial.Find(lsFind,1,w_do.idw_serial.RowCOunt())
                Do While llFindRow > 0
                
                        lsSerial += ", " + w_do.idw_serial.GetItemString(llFindRow,'serial_no')
                
                        llFindRow ++
                        If llFindRow > w_do.idw_serial.RowCount() Then
                                lLFindRow = 0
                        Else
                                llFindRow = w_do.idw_serial.Find(lsFind,llFindRow,w_do.idw_serial.RowCOunt())
                        End If
                
                Loop
                
                If Left(lsSerial,2) = ', ' Then lsSerial = mid(lsSerial,3,999999999)
                ld_packprint.setitem(llNewRow,"serial_no",lsSerial)
        
        End If /*serial numbers exist*/
                
        ld_packprint.setitem(llNewRow,"component_ind",w_do.idw_pack.getitemstring(llRowPOs,"component_ind")) /* 02/01 - PCONKL - sort component master to top*/
                
        ld_packprint.setitem(llNewRow,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        ld_packprint.setitem(llNewRow,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        ld_packprint.setitem(llNewRow,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        ld_packprint.setitem(llNewRow,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        ld_packprint.setitem(llNewRow,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        ld_packprint.setitem(llNewRow,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
        ld_packprint.setitem(llNewRow,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))
        ld_packprint.setitem(llNewRow,"remark",w_do.idw_main.getitemstring(1,"remark"))
        
        // 07/00 PCONKL - Ship from info is coming from Project Table  
        ld_packprint.setitem(llNewRow,"ship_from_name",lsName)
        ld_packprint.setitem(llNewRow,"ship_from_address1",lsaddr1)
        ld_packprint.setitem(llNewRow,"ship_from_address2",lsaddr2)
        ld_packprint.setitem(llNewRow,"ship_from_address3",lsaddr3)
        ld_packprint.setitem(llNewRow,"ship_from_address4",lsaddr4)
        ld_packprint.setitem(llNewRow,"ship_from_city",lsCity)
        ld_packprint.setitem(llNewRow,"ship_from_state",lsstate)
        ld_packprint.setitem(llNewRow,"ship_from_zip",lszip)
        ld_packprint.setitem(llNewRow,"ship_from_country",lscountry)
 	         
Next /*PAcking Row */
 
i=1
FOR i = 1 TO UpperBound(ls_text[])
        ld_packprint.Modify(ls_text[i])
        ls_text[i]=""
NEXT
 
ld_packprint.Sort()
ld_packprint.GroupCalc()
 
// 09/04 - PCONKL - If we have a default printer for PackList, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','PACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

//ld_packprint.Object.t_costcenter.Y= long(ld_packprint.Describe("costcenter.y"))
 
//Send the report to the Print report window
OpenWithParm(w_dw_print_options,ld_packprint) 
 
// 09/04 - PCONKL - We want to store the last printer used for Printing the Pack List for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','PACKLIST',lsPrinter)
 
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "I" Then 
                w_do.idw_main.SetItem(1,"ord_status","A")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If
 
Return 0
end function

public function integer uf_packprint_garmin ();//Jxlim 05/20/2014 Garmin Pack print in spanish
Long	llRowCount, llRowPos, llNewRow, llFindRow, llLineItemNo, llRow, llUpc
Decimal ldUPC
String	lsSKU, lsSupplier, lsDesc, lsSerial, lsWHCode, lsaddr1, lsaddr2, lsaddr3, lsaddr4, lsCity, lsState, lsZip, lsCountry
String lsSku1,lsSku2,lsSku3,lsSku4,lsSku5,lsDesc1,lsDesc2,lsDesc3,lsDesc4,lsDesc5, lsModify, lsDocType, lsTemp, lsDocPrint, lsaltSku
String lsaSku1,lsaSku2,lsaSku3,lsaSku4,lsaSku5, lsacustcode, lsDono
String ls_st_cust_code, ls_st_name, ls_st_addr1, ls_st_addr2, ls_st_addr3, ls_st_addr4,  ls_st_state,  ls_st_city, ls_st_zip,  ls_st_country, ls_st_tel
String lsPart_UPC_Code, lsFind, lscarton, ls_carriercode, ls_carrier, ls_carton, lsUPC
	
Datastore	lds_st, ldw_packprint

w_do.idw_main.AcceptText()
w_do.idw_other.AcceptText()
w_do.idw_Pack.AcceptText()
w_do.idw_serial.AcceptText()

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print (the data is coming from deliveryy Detail but we want to make sure the pack list is generated first)
llRowCount = w_do.idw_pack.rowcount()
If llRowCount = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

//Jxlim 08/26/2013 Ariens Force retrieve sold to here because sold info didn't retrieve without clicking on sold to tab.
lsdono= w_do.idw_main.GetitemString(1,'Do_No')
lds_st =Create Datastore
lds_st.Dataobject='d_do_address_alt'
lds_st.SetTransObject(SQLCA)
lds_st.Retrieve(lsdono, 'BT')

SetPointer(Hourglass!)

ldw_packprint = Create Datastore
ldw_packprint.dataobject ='d_garmin_packing_prt'

lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")
	
//Ship from address from Warehouse Table
Select Address_1, Address_2, Address_3, Address_4, city, state, zip, country
Into	 :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
From warehouse
Where WH_Code = :lsWHCode
Using Sqlca;

ls_carriercode= w_do.idw_main.getitemstring(1,"carrier")  //Portador
Select Carrier_name Into :ls_Carrier
From Carrier_master
Where Project_id =:gs_Project and Carrier_code =:ls_Carriercode
Using SQLCA;

//For each detail row, generate the pack data
//llRowCount = w_do.idw_detail.RowCount() // use idw_pack
For llRowPOs = 1 to llRowCount
	
	llNewRow = ldw_packprint.InsertRow(0)
	
	ldw_packprint.setitem(llNewRow,"shipper_tracking_id",w_do.idw_main.getitemstring(1,"awb_bol_no"))  //# De Rastreo since Garmin is not using Trax, uses awb_bol_no to for shipper tracking numbe
	ldw_packprint.setitem(llNewRow,"delivery_order_id",w_do.idw_main.getitemstring(1,"user_field2"))  //# De Entrega Delivery order id is from dm.uf2 sent by customer (SO-944) and required to send back
	ldw_packprint.setitem(llNewRow,"bol_no",w_do.idw_main.getitemstring(1,"awb_bol_no"))  //# De BOL
	ldw_packprint.setitem(llNewRow,"carrier_pro_no",w_do.idw_main.getitemstring(1,"carrier_pro_no"))  //# De Pro
	ldw_packprint.setitem(llNewRow,"invoice_no",w_do.idw_main.getitemstring(1,"invoice_no"))	//# De Orden
	ldw_packprint.setitem(llNewRow,"cust_code",w_do.idw_main.getitemstring(1,"cust_code"))	//# De Cliente
	ldw_packprint.setitem(llNewRow,"cust_order_no",w_do.idw_main.getitemstring(1,"cust_order_no"))	//# De Po
	
	//ldw_packprint.setitem(llNewRow,"carrier",w_do.idw_main.getitemstring(1,"carrier"))  //Portador carrier code
	ldw_packprint.setitem(llNewRow,"carrier",ls_Carrier)  //Portador  Carrier name
	ldw_packprint.setitem(llNewRow,"Ship_via",w_do.idw_main.getitemstring(1,"ship_via"))  //Metodo De Envio
	ldw_packprint.setitem(llNewRow,"Freight_terms",w_do.idw_main.getitemstring(1,"freight_terms"))  //Metodo De Envio
	
	ldw_packprint.setitem(llNewRow,"ord_date",w_do.idw_main.getitemDatetime(1,"ord_date"))	//Fecha de Orden
	ldw_packprint.setitem(llNewRow,"schedule_date",w_do.idw_main.getitemDatetime(1,"schedule_date"))	//Fecha de Envio	
	
	ldw_packprint.setitem(llNewRow,"ship_from_name",lsWHCode)
	ldw_packprint.setitem(llNewRow,"ship_from_addr1",lsAddr1)
	ldw_packprint.setitem(llNewRow,"ship_from_addr2",lsAddr2)
	ldw_packprint.setitem(llNewRow,"ship_from_addr3",lsAddr3)
	ldw_packprint.setitem(llNewRow,"ship_from_addr4",lsAddr4)
	ldw_packprint.setitem(llNewRow,"ship_from_state",lsState)
	ldw_packprint.setitem(llNewRow,"ship_from_city",lsCity)
	ldw_packprint.setitem(llNewRow,"ship_from_zip",lsZip)
	ldw_packprint.setitem(llNewRow,"ship_from_country",lsCountry)
	
	//Jxlim 08/20/2013 ship to	
	ldw_packprint.setitem(llNewRow,"ship_to_name",w_do.idw_main.getitemstring(1,"cust_name"))  
	ldw_packprint.setitem(llNewRow,"ship_to_addr1",w_do.idw_main.getitemstring(1,"address_1"))
	ldw_packprint.setitem(llNewRow,"ship_to_addr2",w_do.idw_main.getitemstring(1,"address_2"))
	ldw_packprint.setitem(llNewRow,"ship_to_addr3",w_do.idw_main.getitemstring(1,"address_3"))
	ldw_packprint.setitem(llNewRow,"ship_to_addr4",w_do.idw_main.getitemstring(1,"address_4"))
	ldw_packprint.setitem(llNewRow,"ship_to_state",w_do.idw_main.getitemstring(1,"state"))
	ldw_packprint.setitem(llNewRow,"ship_to_city",w_do.idw_main.getitemstring(1,"city"))
	ldw_packprint.setitem(llNewRow,"ship_to_zip",w_do.idw_main.getitemstring(1,"zip"))
	ldw_packprint.setitem(llNewRow,"ship_to_country",w_do.idw_main.getitemstring(1,"country"))


	//If w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.RowCount() > 0 Then
//		lsacustcode =w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"alt_cust_code")
//		ldw_packprint.setitem(llNewRow,"alt_cust_code",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"alt_cust_code"))
//		ldw_packprint.setitem(llNewRow,"sold_to_name",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"name"))		
//		ldw_packprint.setitem(llNewRow,"sold_to_address1",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"address_1"))
//		ldw_packprint.setitem(llNewRow,"sold_to_address2",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"address_2"))
//		ldw_packprint.setitem(llNewRow,"sold_to_address3",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"address_3"))
//		ldw_packprint.setitem(llNewRow,"sold_to_address4",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"address_4"))
//		ldw_packprint.setitem(llNewRow,"sold_to_state",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"state"))
//		ldw_packprint.setitem(llNewRow,"sold_to_city",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"city"))
//		ldw_packprint.setitem(llNewRow,"sold_to_zip",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"zip"))
//		ldw_packprint.setitem(llNewRow,"sold_to_country",w_do.tab_main.tabpage_main.tab_address.tabpage_st.dw_st.getitemstring(1,"country"))		
	//End If

		//Jxlim 05/21/2014 Garmin (delivery_alt_address)	//Get Bill TO(BT)
		ls_st_cust_code= lds_st.getitemstring(1,"alt_cust_code")
		ls_st_name= lds_st.getitemstring(1,"name")
		ls_st_addr1= lds_st.getitemstring(1,"address_1")
		ls_st_addr2= lds_st.getitemstring(1,"address_2")
		ls_st_addr3= lds_st.getitemstring(1,"address_3")
		ls_st_addr4= lds_st.getitemstring(1,"address_4")
		ls_st_state= lds_st.getitemstring(1,"state")
		ls_st_city= lds_st.getitemstring(1,"city")
		ls_st_zip= lds_st.getitemstring(1,"zip")
		ls_st_country= lds_st.getitemstring(1,"country")
		ls_st_tel= lds_st.getitemstring(1,"tel")

		//Set Bill TO(BT)
		ldw_packprint.setitem(llNewRow,"bill_to_name",ls_st_name)
		ldw_packprint.setitem(llNewRow,"bill_to_addr1",ls_st_addr1)
		ldw_packprint.setitem(llNewRow,"bill_to_addr2",ls_st_addr2)
		ldw_packprint.setitem(llNewRow,"bill_to_addr3",ls_st_addr3)
		ldw_packprint.setitem(llNewRow,"bill_to_addr4",ls_st_addr4)
		ldw_packprint.setitem(llNewRow,"bill_to_state",ls_st_state)
		ldw_packprint.setitem(llNewRow,"bill_to_city",ls_st_city)
		ldw_packprint.setitem(llNewRow,"bill_to_zip",ls_st_zip)
		ldw_packprint.setitem(llNewRow,"bill_to_country",ls_st_country)
		//ldw_packprint.setitem(llNewRow,"sold_to_tel",ls_st_tel)
		//Jxlim end if Bill To info
	//************************************************************** Header  End**************************************************************/			
	ldw_packprint.setitem(llNewRow,"ship_instr",w_do.idw_main.getitemstring(1,"shipping_instructions"))  //# Notas - shipping instruction
   	ldw_packprint.setitem(llNewRow,"packlist_notes",w_do.idw_main.getitemString(1,"packlist_notes")) //Notas Al Almacen - Packing Notes
	ldw_packprint.setitem(llNewRow,"remark",w_do.idw_main.getitemstring(1,"remark"))  //# Notas - Internal notes (there won't be DN section) 
		
    //Detail
		lsSKU = w_do.idw_pack.getitemstring(llRowPos,"sku")
		//lsaltSKU = w_do.idw_pack.getitemstring(llRowPos,"alternate_sku")	
		lsSupplier = w_do.idw_pack.getitemstring(llRowPos,"supp_code")
		llLineItemNo = w_do.idw_pack.getitemNumber(llRowPos,"Line_Item_No")
						
		ldw_packprint.setitem(llNewRow,"sku",lsSKU)
		//ldw_packprint.setitem(llNewRow,"alt_sku",lsaltSku) 		
		//ldw_packprint.setitem(llNewRow,"Line_item_no",llLineItemNo)
		
		//altenate sku
		  lsFind = "Upper(sku) = '" + Upper(lsSku) + "' and line_item_no = " + string(llLineItemNo)
		  llRow = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
		  
		  if llRow > 0 Then
				 ldw_packprint.setitem(llNewRow,"uom",w_do.idw_detail.getitemstring(llRow,"uom"))
				 ldw_packprint.setitem(llNewRow,"alt_sku",w_do.idw_detail.getitemString(llRow,"alternate_sku"))					
				 ldw_packprint.setitem(llNewRow,"description",w_do.idw_detail.getitemString(llRow,"description"))		
				 ldUPC= w_do.idw_detail.getitemDecimal(llRow,"part_upc_code") 	//Jxlim 06/13/2014 In the database part_upc_code is number type
				 //not sure why datawindow uses it decimal. because of that need to convert to decimal to get the correct return value.
				 ldw_packprint.setitem(llNewRow,"UPC_Code",String(ldUPC))
		  End If 
		
	//	ldw_packprint.setitem(llNewRow,"uom",w_do.idw_detail.getitemstring(llRowPos,"uom"))
	//	ldw_packprint.setitem(llNewRow,"ord_qty",w_do.idw_detail.getitemNumber(llRowPos,"req_qty"))
	//	ldw_packprint.setitem(llNewRow,"picked_quantity",w_do.idw_detail.getitemNumber(llRowPos,"alloc_qty"))
		
		ldw_packprint.setitem(llNewRow,"picked_quantity",w_do.idw_pack.getitemNumber(llRowPos,"quantity"))
		ldw_packprint.setitem(llNewRow,"ord_qty",w_do.idw_pack.getitemNumber(llRowPos,"quantity"))
		 ldw_packprint.setitem(llNewRow,"unit_weight",w_do.idw_pack.getitemDecimal(llRowPos,"weight_gross")) //Madhu added
		
//		Jxlim 06/13/2014 Used dw.getitem to avoid requesting query.
		//Need description and Alt SKU from Itemmaster
//		lsAltSku=''
//		lsDesc = ''		
//		Select Alternate_sku, Description, Part_UPC_Code into :lsAltSku, :lsDesc,:lsPart_UPC_Code
//		From ITem_Master
//		Where Project_id = :gs_project and sku = :lsSKU and Supp_Code = :lsSupplier
//		Using SQLCA;
//				
//		ldw_packprint.setitem(llNewRow,"description",lsDesc)			
//		ldw_packprint.setitem(llNewRow,"UPC_Code",lsPart_UPC_Code)
//		ldw_packprint.setitem(llNewRow,"alt_sku",lsAltSku) 		
		
		ldw_packprint.setitem(llNewRow,"carton_no",w_do.idw_pack.getitemString(llRowPos,"carton_no")) /*Printed report should show carton # from screen instead of row #*/
	
		If w_do.idw_pack.getitemDecimal(llRowPos,"cbm") > 0 Then
			ldw_packprint.setitem(llNewRow,'dimensions',string(w_do.idw_pack.getitemDecimal(llRowPos,"length")) + ' x ' + string(w_do.idw_pack.getitemDecimal(llRowPos,"width")) + ' x ' + string(w_do.idw_pack.getitemDecimal(llRowPos,"height"))) /* 02/01 - PCONKL*/
		End if 
	
		
//		//Serial No
//		lsSerial = w_do.idw_serial.GetItemString(llRowPos,'serial_no')		 
//		ldw_packprint.setitem(llNewRow,"serial_no",lsSerial)
		
			// 10/07 - PCONKL - Get Serial Numbers from serial tab(Outbound)
			  If w_do.idw_serial.RowCount() > 0 Then
						 
						 lsSerial = ""
						 lsFind = "Upper(Carton_No) = '" + Upper(w_do.idw_Pack.GetItemString(llrowPos,'carton_no')) + "' and line_item_No = " + String(w_do.idw_Pack.GetITemNumber(llRowPos,'line_item_No'))
						 llFindRow = w_do.idw_serial.Find(lsFind,1,w_do.idw_serial.RowCOunt())
						 Do While llFindRow > 0
						 
									lsSerial += ", " + w_do.idw_serial.GetItemString(llFindRow,'serial_no')
						 
									llFindRow ++
									If llFindRow > w_do.idw_serial.RowCount() Then
											  lLFindRow = 0
									Else
											  llFindRow =w_do.idw_serial.Find(lsFind,llFindRow,w_do.idw_serial.RowCOunt())
									End If
						 
						 Loop
						 
						 If Left(lsSerial,2) = ', ' Then lsSerial = mid(lsSerial,3,999999999)
						 ldw_packprint.setitem(llNewRow,"serial_no",lsSerial)
			  
			  End If /*serial numbers exist*/
			
			
Next /*Packing Row*/

ldw_packprint.Sort()
ldw_packprint.GroupCalc()  //Jxlim without this footer would not be printed

//Setpointer(arrow!)

OpenWithParm(w_dw_print_options,ldw_packprint) 

Return 0
end function

public function integer uf_packprint_bosch ();//09-Sep-2014 : Madhu- Customize Pack List for BOSCH

String ls_dono,ls_whcode,ls_sku,ls_supplier,ls_carton,ls_sku_desc,ls_detail_Find
String dwsyntax_str,presentation_str,lsSQL,lsErrText,ls_Find_serial,ls_serial_no
string ls_city,ls_state,ls_zip,ls_address5
long ll_NewRow,ll_rowcount,ll_RowPos,ll_warehouserow,ll_LineItemNo
long ll_detail_FindRow,ll_Serial_count,llSerialPos,ll_Find_row, lsIdNo
long llScannedQty, lleligiblecnt, llOrigLen, llAddLen, llTotLen, llSerLen
Decimal ll_volume, ll_net_weight,ll_gross_weight

Datastore lds_packprint,lds_serial

SetPointer(Hourglass!)

//create a datastore and assign datawindow
lds_packprint = CREATE Datastore
lds_packprint.dataobject ='d_bosch_packing_prt'

ls_dono = w_do.idw_main.GetItemString(1,'Do_No')
ls_whcode = w_do.idw_main.GetItemString(1,'wh_code')

 //12-Nov-2014 :TAM -Added code to verify whether all serial no's are scanned? -START
//get eligible records for scanning
select sum(Quantity) into :lleligiblecnt from Delivery_Packing,Item_Master
where Delivery_Packing.SKU = Item_Master.SKU
and Delivery_Packing.DO_No= :ls_DONO
and Item_Master.Serialized_Ind in ('Y','B')
using SQLCA;

If lleligiblecnt >0 Then
	Select Sum(quantity) into :llScannedQty from delivery_serial_detail Where Id_no in (select id_no from delivery_picking_detail where do_no = :ls_DONO) using SQLCA;
	If IsNull(llScannedQty) then 
		llScannedQty =0 
	end if
	If lleligiblecnt <> llScannedQty Then
		MessageBox(w_do.is_title,"All Serial no's are not being scanned. Please check.",Stopsign!)
		Return 0
	End if 
End if 

//12-Nov-2014 :TAM - Added code to verify whether all serial no's are scanned? -END


select sum(CBM),sum(Weight_Net),sum(Weight_Gross) into :ll_volume, :ll_net_weight,:ll_gross_weight
from Delivery_Packing
where Do_No=:ls_dono
using sqlca;

//Get warehouse details
ll_warehouserow = g.ids_project_warehouse.Find("Upper(wh_code) ='"+ ls_whcode +"'",1,g.ids_project_warehouse.rowcount( ))

//create a datastore for SN
lds_serial =CREATE datastore
presentation_str = "style(type=grid)"
lsSQL = "Select dpd.Line_Item_No, dpd.SKU, dsd.Serial_No as 'serial_no', dsd.Carton_No "
lsSQL += "from Delivery_Picking_Detail dpd with (nolock), Delivery_Serial_Detail dsd with (nolock) "
lsSQL += "Where dpd.do_no = '" + ls_dono + "' and dpd.id_no = dsd.id_no "

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
lds_serial.Create( dwsyntax_str, lsErrText)
lds_serial.SetTransObject(SQLCA)
lds_serial.Retrieve()


ll_rowcount =w_do.idw_pack.rowcount()

For ll_RowPos =1 to ll_rowcount
	
	ll_NewRow = lds_packprint.insertrow( 0)

	//Set Warehouse Address information to Pack List Print
	lds_packprint.setItem( ll_NewRow,'wh_name',g.ids_project_warehouse.getItemString(ll_warehouserow,'wh_name'))
	lds_packprint.setItem( ll_NewRow,'wh_addr1',g.ids_project_warehouse.getItemString(ll_warehouserow,'address_1'))
	lds_packprint.setItem( ll_NewRow,'wh_addr2',g.ids_project_warehouse.getItemString(ll_warehouserow,'address_2'))
	lds_packprint.setItem( ll_NewRow,'wh_addr3',g.ids_project_warehouse.getItemString(ll_warehouserow,'address_3'))
	lds_packprint.setItem( ll_NewRow,'wh_addr4',g.ids_project_warehouse.getItemString(ll_warehouserow,'address_4'))
//	lds_packprint.setItem( ll_NewRow,'wh_city',g.ids_project_warehouse.getItemString(ll_warehouserow,'city'))
//	lds_packprint.setItem( ll_NewRow,'wh_state',g.ids_project_warehouse.getItemString(ll_warehouserow,'state'))
//	lds_packprint.setItem( ll_NewRow,'wh_zip',g.ids_project_warehouse.getItemString(ll_warehouserow,'zip'))
//	
	ls_city =g.ids_project_warehouse.getItemString(ll_warehouserow,'city')
	ls_state =g.ids_project_warehouse.getItemString(ll_warehouserow,'state')
	ls_zip=g.ids_project_warehouse.getItemString(ll_warehouserow,'zip')
	
	ls_address5 = ls_city +", "+ls_state +", "+ls_zip
	
	lds_packprint.setItem(ll_NewRow,'wh_city',ls_address5)

	//Set Ship To information on Pack List Print
	lds_packprint.SetItem( ll_NewRow, 'shipto_custname',w_do.idw_main.getItemString(1,'cust_name'))
	lds_packprint.SetItem( ll_NewRow, 'shipto_addr1',w_do.idw_main.getItemString(1,'address_1'))
	lds_packprint.SetItem( ll_NewRow, 'shipto_addr2',w_do.idw_main.getItemString(1,'address_2'))
	lds_packprint.SetItem( ll_NewRow, 'shipto_addr3',w_do.idw_main.getItemString(1,'address_3'))
	lds_packprint.SetItem( ll_NewRow, 'shipto_addr4',w_do.idw_main.getItemString(1,'address_4'))
	lds_packprint.SetItem( ll_NewRow, 'shipto_city',w_do.idw_main.getItemString(1,'city'))
	lds_packprint.SetItem( ll_NewRow, 'shipto_state',w_do.idw_main.getItemString(1,'state'))
	lds_packprint.SetItem( ll_NewRow, 'shipto_zip',w_do.idw_main.getItemString(1,'zip'))
	lds_packprint.SetItem( ll_NewRow, 'shipto_tel',w_do.idw_main.getItemString(1,'Tel'))

	lds_packprint.SetItem(ll_NewRow,'invoice_no',w_do.idw_main.getItemString(1,'invoice_no'))
	lds_packprint.setitem(ll_NewRow,"complete_date",w_do.idw_main.getItemDateTime(1,'complete_date'))
	lds_packprint.SetItem(ll_NewRow,'cust_ord_no',w_do.idw_main.getItemString(1,'cust_order_no'))
	lds_packprint.SetItem(ll_NewRow,'cust_code',w_do.idw_main.getItemString(1,'cust_code')) //TAM 2014/10/08
	lds_packprint.SetItem(ll_NewRow,'ship_instructions',w_do.idw_main.getItemString(1,'shipping_instructions'))
	lds_packprint.SetItem(ll_NewRow,'freight_terms',w_do.idw_main.getItemString(1,'freight_terms'))
	lds_packprint.SetItem(ll_NewRow,'user_field5',w_do.idw_main.getItemString(1,'user_field5'))// TAM 2018/7/25 S21848
	
	//Set Total volume from pack list
	lds_packprint.SetItem(ll_NewRow,'gross_weight',ll_gross_weight)
	lds_packprint.SetItem(ll_NewRow,'net_weight',ll_net_weight)
	lds_packprint.SetItem(ll_NewRow,'volume',ll_volume)

	//Set shipping Details
	ls_sku = w_do.idw_pack.getItemString(ll_RowPos,'sku')
	ls_supplier = w_do.idw_pack.getitemstring(ll_RowPos,"supp_code")
	ll_LineItemNo = w_do.idw_pack.getitemNumber(ll_RowPos,"Line_Item_No")
	ls_carton = w_do.idw_pack.getitemString(ll_RowPos,"carton_no")
		
	select Description into :ls_sku_desc from Item_Master where Project_Id=:gs_project and sku=:ls_sku
	using sqlca;
	
	lds_packprint.SetItem(ll_NewRow,'sku',ls_sku)
	lds_packprint.SetItem(ll_NewRow,'sku_desc',ls_sku_desc)
	
	//Get Detail records
	ls_detail_Find = "Line_Item_no = " + String(ll_LineItemNo) + " and sku = '" + ls_sku + "'"
	ll_detail_FindRow = w_do.idw_detail.Find(ls_detail_Find,1,w_do.idw_detail.RowCount())
	
	If ll_detail_FindRow > 0 Then
		lds_packprint.SetItem(ll_NewRow,'delivery_detail_uf1',w_do.idw_detail.getItemString(ll_detail_FindRow,'user_field1'))
		lds_packprint.SetItem(ll_NewRow,'delivery_detail_uf2',Trim(w_do.idw_detail.getItemString(ll_detail_FindRow,'user_field2')))//TAM 2014/10/08
	End If


	lds_packprint.SetItem(ll_NewRow,'qty',w_do.idw_pack.getItemNumber(ll_RowPos,'quantity'))
	lds_packprint.SetItem(ll_NewRow,'weight',w_do.idw_pack.getItemDecimal(ll_rowPos,'weight_gross'))
	
	//Get the associated SN for SKU
	ls_Find_serial =  "Line_Item_no = " + String(ll_LineItemNo) + " and sku = '" + ls_sku + "'"
	lds_serial.SetFilter(ls_Find_serial)
	lds_serial.Filter()
	lds_serial.setsort('serial_no A') //sort SN ascending order
	lds_serial.sort()
	ll_Serial_count = lds_serial.RowCount()

	ls_serial_no =""
	//GailM 4/2/2020 S43613/F21699/I2878 Bosch Expand Packing Slip to Show All Details
	llOrigLen = 280
	llSerLen = round(ll_Serial_count / 2, 1)
	llAddLen =   llSerLen * 50
	llTotLen = llOrigLen + llAddLen
	lds_packprint.SetItem(ll_NewRow,'len',llTotLen)
	
	If ll_Serial_count > 0 Then
		For llSerialPos = 1 to ll_Serial_count
			ls_serial_no += lds_serial.GetITemString(llSerialPOs,'serial_No') + ", "
		Next
		
		lds_packprint.SetItem(ll_NewRow, 'serial_no',left(ls_serial_no,len(ls_serial_no) - 2))

	End If 

Next

OpenWithParm(w_dw_print_options,lds_packprint) 

Return 1
end function

public function integer uf_packprint_puma ();//26-Dec-2014 Madhu- Added custom pack list for PUMA

String ls_whcode,ls_whname,ls_whaddr1,ls_whaddr2,ls_whaddr3,ls_whaddr4,ls_whcity,ls_whstate,ls_whzip,ls_whcountry
String ls_sku,ls_suppcode,ls_description,lshazCode,lsUPC,ls_etom,ls_text[],lsTransportMode,lshazText,ls_find,lsPrinter
Long ll_row,llRowCount,ll_lineno,ll_newrow,llhazCount,llHazPos,ll_findrow,ll_finddetailrow
Decimal ld_costcenter

Datastore lds_packprint,ldsHazmat

SetPointer(HourGlass!)
IF w_do.idw_pack.AcceptText() = -1 Then
	w_do.tab_main.SelectTab(3) 
	w_do.idw_pack.SetFocus()
	Return 0
END IF

IF w_do.ib_changed Then
	MessageBox(w_do.is_title,'Please save changes before printing Pack list.')
	Return 0
END IF

llRowCount =w_do.idw_pack.rowcount()
IF llRowCount =0 Then
	MessageBox("Printing Pack List","No records to print!")
	Return 0
END IF

//creating datastore
lds_packprint =CREATE Datastore
lds_packprint.DataObject='d_packing_prt_puma'

ldsHazmat = Create Datastore
ldshazmat.dataobject = 'd_hazard_text'
ldshazmat.SetTransObject(SQLCA)

ls_whcode = w_do.idw_main.getitemstring(1,'wh_code')

//Get warehouse Address
select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
into :ls_whname,:ls_whaddr1,:ls_whaddr2,:ls_whaddr3,:ls_whaddr4,:ls_whcity,:ls_whstate,:ls_whzip,:ls_whcountry
from Warehouse 
where wh_code=:ls_whcode;

// Get the cost center.
nvo_order lnvo_order
lnvo_order = Create nvo_order
lnvo_order.f_getcostcenter(1, ld_costcenter)
Destroy lnvo_order

//lds_packprint.reset() //clear the report window.

For ll_row=1 to llRowCount

	ls_sku=w_do.idw_pack.getitemstring(ll_row,'sku')
	ls_suppcode= w_do.idw_pack.getitemstring(ll_row,'supp_code')
	ll_lineno= w_do.idw_pack.getItemNumber(ll_row,'line_item_no')
	
	ll_newrow = lds_packprint.insertrow( 0)
	//Set WH address as Ship From
	lds_packprint.setitem(ll_newrow,'ship_from_name',ls_whname)
	lds_packprint.setitem(ll_newrow,'ship_from_address1',ls_whaddr1)
	lds_packprint.setitem(ll_newrow,'ship_from_address2',ls_whaddr2)
	lds_packprint.setitem(ll_newrow,'ship_from_address3',ls_whaddr3)
	lds_packprint.setitem(ll_newrow,'ship_from_address4',ls_whaddr4)
	lds_packprint.setitem(ll_newrow,'ship_from_city',ls_whcity)
	lds_packprint.setitem(ll_newrow,'ship_from_state',ls_whstate)
	lds_packprint.setitem(ll_newrow,'ship_from_zip',ls_whzip)
	lds_packprint.setitem(ll_newrow,'ship_from_country',ls_whcountry)
	
	//Set Ship To address
	lds_packprint.setitem(ll_newrow,'cust_name',w_do.idw_main.getitemstring(1,'Cust_Name'))
	lds_packprint.setitem(ll_newrow,'delivery_address1',w_do.idw_main.getitemstring(1,"Address_1"))
	lds_packprint.setitem(ll_newrow,'delivery_address2',w_do.idw_main.getitemstring(1,"Address_2"))
	lds_packprint.setitem(ll_newrow,'delivery_address3',w_do.idw_main.getitemstring(1,"Address_3"))
	lds_packprint.setitem(ll_newrow,'delivery_address4',w_do.idw_main.getitemstring(1,"Address_4"))
	lds_packprint.setitem(ll_newrow,'delivery_state',w_do.idw_main.getitemstring(1,"State"))
	lds_packprint.setitem(ll_newrow,'delivery_zip',w_do.idw_main.getitemstring(1,"Zip"))
	
	lds_packprint.setitem(ll_newrow,'city',w_do.idw_main.getitemstring(1,"City"))
	lds_packprint.setitem(ll_newrow,'country',w_do.idw_main.getitemstring(1,"Country"))
	
	lds_packprint.setitem(ll_newrow,"costcenter",string(ld_costcenter))	
	
	lds_packprint.setitem(ll_newrow,'bol_no',w_do.is_bolno)
	lds_packprint.setitem(ll_newrow,'cust_code',w_do.idw_main.getitemstring(1,"Cust_Code"))
	lds_packprint.setitem(ll_newrow,'ord_no',w_do.idw_main.getitemstring(1,"Cust_Order_No"))
	
	lds_packprint.setitem(ll_newrow,'carrier',w_do.idw_other.getitemstring(1,"Carrier"))
	lds_packprint.setitem(ll_newrow,'ship_via',w_do.idw_other.getitemstring(1,"Ship_Via"))
	lds_packprint.setitem(ll_newrow,'sch_cd',w_do.idw_other.getitemstring(1,"User_Field1"))
	lds_packprint.setitem(ll_newrow,'freight_terms',w_do.idw_main.getitemstring(1,"Freight_Terms"))

	lsTransportMode= w_do.idw_other.getitemstring(1,"Transport_Mode")
	
	lds_packprint.setitem(ll_newrow,'ord_date',w_do.idw_main.getitemdatetime(1,"Ord_Date"))
	lds_packprint.setitem(ll_newrow,'complete_date',w_do.idw_main.getitemdatetime(1,"Complete_Date"))
	lds_packprint.setitem(ll_newrow,'schedule_date',w_do.idw_main.getitemdatetime(1,"Schedule_Date"))
	lds_packprint.setitem(ll_newrow,'remark',w_do.idw_main.getitemstring(1,"Remark"))
	
	lds_packprint.setitem(ll_newrow,'carton_no', w_do.idw_pack.getitemstring(ll_row,"Carton_No"))
	lds_packprint.setitem(ll_newrow,'carton_id', string(w_do.is_bolno) +'-'+string(w_do.idw_pack.getitemstring(ll_row,"Carton_No")))
	
	Select description, hazard_text_cd, part_upc_Code into :ls_description, :lshazCode, :lsUPC
	From item_master 
	Where project_id = :gs_project and sku = :ls_sku and supp_code = :ls_suppcode;
	
	ls_description =trim(ls_description)
	
	lds_packprint.setitem(ll_newrow,'sku',ls_sku)
	lds_packprint.setitem(ll_newrow,'upc_code',lsUPC)
	lds_packprint.setitem(ll_newrow,"country_of_origin",w_do.idw_pack.getitemstring(ll_row,"country_of_origin")) 
	lds_packprint.setitem(ll_newrow,"supp_code",w_do.idw_pack.getitemstring(ll_row,"supp_code")) 
	lds_packprint.setitem(ll_newrow,'description',ls_description)
	
	//Get Hazard Material Text
	lshazText = ''
	If lshazCode > '' Then
		llhazCount = ldsHazmat.Retrieve(gs_project,lshazCode,lsTransportMode)
		If llHazCount > 0 Then
			For llHazPos = 1 to llHazCount
				lsHazText += ldshazMat.GetItemString(llHazPos,'hazard_text') + '~r'
			Next
		End If
	End If
	
	lds_packprint.setitem(ll_newrow,'haztext',lsHazText)
	
	lds_packprint.setitem(ll_newrow,'picked_quantity',w_do.idw_pack.getitemnumber(ll_row,"Quantity"))
	lds_packprint.setitem(ll_newrow,'ord_qty',w_do.idw_pack.getitemnumber(ll_row,"Quantity"))
	lds_packprint.setitem(ll_newrow,'volume',w_do.idw_pack.getitemdecimal(ll_row,"cbm"))
	
	If w_do.idw_pack.getitemDecimal(ll_row,"cbm") > 0 Then
		lds_packprint.setitem(ll_newrow,'dimensions',string(w_do.idw_pack.getitemDecimal(ll_row,"length")) + ' x ' + string(w_do.idw_pack.getitemDecimal(ll_row,"width")) + ' x ' + string(w_do.idw_pack.getitemDecimal(ll_row,"height"))) 
	End If
	
	lds_packprint.setitem(ll_newrow,"standard_of_measure",w_do.idw_pack.getitemString(ll_row,"standard_of_measure"))
	lds_packprint.setitem(ll_newrow,"packlist_notes",w_do.idw_main.getitemString(1,"packlist_notes")) 
	
	lds_packprint.setitem(ll_newrow,"unit_weight",w_do.idw_pack.getitemDecimal(ll_row,"weight_net"))

	//For English to Metrtics changes added L or K based on E or M
	ls_etom=w_do.idw_packprint.getitemString(ll_row,"standard_of_measure")
	IF ls_etom <> "" and not isnull(ls_etom) and ll_row=1 THEN
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
	
	ls_find ="Sku ='"+ls_sku+"' and Line_Item_No ="+string(ll_lineno)+""
	ll_findrow = w_do.idw_pick.find(ls_find,0,w_do.idw_pick.rowcount()) //Get pick row
	ll_finddetailrow =w_do.idw_detail.find(ls_find,0,w_do.idw_detail.rowcount()) //Get Detail row
	
	IF ll_findrow > 0 THEN
		lds_packprint.setitem(ll_newrow,'po_no2',w_do.idw_pick.getitemstring(ll_findrow,"Po_No2"))
	END IF
	
	IF ll_finddetailrow > 0 THEN
		lds_packprint.setitem(ll_newrow,'user_field2',w_do.idw_detail.getitemstring(ll_finddetailrow,"user_field2"))
	END IF
	
	lds_packprint.setitem(ll_newrow,"staging_location",w_do.idw_pick.getitemstring(1,"staging_location"))

NEXT

ll_row=1
FOR ll_row = 1 TO UpperBound(ls_text[])
w_do.idw_packprint.Modify(ls_text[ll_row])
ls_text[ll_row]=""
NEXT

lds_packprint.Sort()
lds_packprint.GroupCalc()

//If we have a default printer for PackList, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','PACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

lds_packprint.Object.t_costcenter.Y= long(lds_packprint.Describe("costcenter.y")) 

//Send the report to the Print report window
OpenWithParm(w_dw_print_options,lds_packprint) 

//We want to store the last printer used for Printing the Pack List for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','PACKLIST',lsPrinter)


If message.doubleparm = 1 then
If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
w_do.idw_main.GetItemString(1,"ord_status") = "P" or &
w_do.idw_main.GetItemString(1,"ord_status") = "I" Then 
w_do.idw_main.SetItem(1,"ord_status","A")
w_do.ib_changed = TRUE
w_do.iw_window.trigger event ue_save()
End If
End If

RETURN 0
end function

public function integer uf_packprint_friedrich_grainger_dropship (string as_packlist_type);//Print the Friedrich packing slips 

Long	llRowCount, llRowPos, llNewRow, llFindRow, llLineItemNo
String	lsSKU, lsSupplier, lsDesc, lsSerial, lsWHCode, lsaddr1, lsaddr2, lsaddr3, lsaddr4, lsCity, lsState, lsZip, lsCountry
String lsSku1,lsSku2,lsSku3,lsSku4,lsSku5,lsDesc1,lsDesc2,lsDesc3,lsDesc4,lsDesc5, lsModify, lsDocType, lsTemp, lsDocPrint, lsaltSku
String lsaSku1,lsaSku2,lsaSku3,lsaSku4,lsaSku5, lsacustcode, lsDono
String ls_st_cust_code, ls_st_name, ls_st_addr1, ls_st_addr2, ls_st_addr3, ls_st_addr4,  ls_st_state,  ls_st_city, ls_st_zip,  ls_st_country, ls_st_tel, ls_cust_name
integer li_len
Datastore	lds_st, ld_packprint

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

//No row means no Print (the data is coming from deliveryy Detail but we want to make sure the pack list is generated first)
llRowCount = w_do.idw_pack.rowcount()
If llRowCount = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

//Jxlim 08/26/2013 Friedrich Force rtrieve sold to here because sold info didn't retrieve without clicking on sold to tab.
lsdono= w_do.idw_main.GetitemString(1,'Do_No')
lds_st =Create Datastore
lds_st.Dataobject='d_do_address_alt'
lds_st.SetTransObject(SQLCA)
lds_st.Retrieve(lsdono, 'ST')

SetPointer(Hourglass!)

ld_packprint = Create Datastore

ld_packprint.dataobject ='d_friedrich_grainger_dropship_packing_prt'						
	
lsWHCode = w_do.idw_main.getitemstring(1,"wh_code")
	
//Ship from address from Warehouse Table
Select Address_1, Address_2, Address_3, Address_4, city, state, zip, country
Into	 :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
From warehouse
Where WH_Code = :lsWHCode
Using Sqlca;

//For each detail row, gernete the pack data
llRowCount = w_do.idw_detail.RowCount()
For llRowPOs = 1 to llRowCount
	
	llNewRow = ld_packprint.InsertRow(0)
	
	lsSKU = w_do.idw_detail.getitemstring(llRowPos,"sku")
	lsaltSKU = w_do.idw_detail.getitemstring(llRowPos,"alternate_sku")	//Jxlim 08/16/2013 Areis; Internet nbr=alt_sku
	lsSupplier = w_do.idw_detail.getitemstring(llRowPos,"supp_code")
	llLineItemNo = w_do.idw_detail.getitemNumber(llRowPos,"Line_Item_No")
		
	
	ld_packprint.setitem(llNewRow,"cust_order_no",w_do.idw_main.getitemstring(1,"cust_order_no"))	
	ld_packprint.setitem(llNewRow,"Ship_via",w_do.idw_main.getitemstring(1,"ship_via"))
	ld_packprint.setitem(llNewRow,"ord_no",w_do.idw_main.getitemstring(1,"invoice_no"))	
	ld_packprint.setitem(llNewRow,"Carrier",w_do.idw_main.getitemstring(1,"carrier"))
	ld_packprint.setitem(llNewRow,"awbbol",w_do.idw_main.getitemstring(1,"awb_bol_no"))
	
	ld_packprint.setitem(llNewRow,"ship_from_address1",lsAddr1)
	ld_packprint.setitem(llNewRow,"ship_from_address2",lsAddr2)
	ld_packprint.setitem(llNewRow,"ship_from_address3",lsAddr3)
	ld_packprint.setitem(llNewRow,"ship_from_address4",lsAddr4)
	ld_packprint.setitem(llNewRow,"ship_from_state",lsState)
	ld_packprint.setitem(llNewRow,"ship_from_city",lsCity)
	ld_packprint.setitem(llNewRow,"ship_from_zip",lsZip)
	ld_packprint.setitem(llNewRow,"ship_from_country",lsCountry)
	
//Ship To	
String ls_shipto_name, ls_shipto_addr1
	ld_packprint.setitem(llNewRow,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))  
	ls_shipto_name= w_do.idw_main.getitemstring(1,"cust_name")
	ld_packprint.setitem(llNewRow,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
	ls_shipto_addr1= w_do.idw_main.getitemstring(1,"address_1")
	ld_packprint.setitem(llNewRow,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
	ld_packprint.setitem(llNewRow,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
	ld_packprint.setitem(llNewRow,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
	ld_packprint.setitem(llNewRow,"delivery_state",w_do.idw_main.getitemstring(1,"state"))
	ld_packprint.setitem(llNewRow,"city",w_do.idw_main.getitemstring(1,"city"))
	ld_packprint.setitem(llNewRow,"delivery_zip",w_do.idw_main.getitemstring(1,"zip"))

	//Friedrich Sold to Dropship (delivery_alt_address)	
	ls_st_cust_code= lds_st.getitemstring(1,"alt_cust_code")
	ls_st_name= lds_st.getitemstring(1,"name")
	ls_st_addr1= lds_st.getitemstring(1,"address_1")
	ls_st_addr2= lds_st.getitemstring(1,"address_2")
	ls_st_addr3= lds_st.getitemstring(1,"address_3")
	ls_st_addr4= lds_st.getitemstring(1,"address_4")
	ls_st_state= lds_st.getitemstring(1,"state")
	ls_st_city= lds_st.getitemstring(1,"city")
	ls_st_zip= lds_st.getitemstring(1,"zip")
	ls_st_country= lds_st.getitemstring(1,"country")
	ls_st_tel= lds_st.getitemstring(1,"tel")

	/*TAM 2015/05/13 -  Getting the Alt Cust Code(Customer PO) from a substring in the Shipping instructions instead of the ST Address.
		Also, Combinded the Grainger Packlist and Grainger DropShip Packlist  into one document using the Dropship PL as the base since all Grainger Packlists look the same.
		The only difference is the customer PO,  The DropShip Packlist has additional verbaige which is visible on the DW(Visible when the Dropship Flag = 'D').
	*/ 
	ld_packprint.setitem(llNewRow,"drop_ship_flag",as_packlist_type)
	ld_packprint.setitem(llNewRow,"order_date",w_do.idw_main.getitemdatetime(1,"ord_date"))	

	If as_packlist_type = 'D' Then
		If pos( w_do.idw_main.getitemstring(1,"shipping_instructions"),'BOL:') >= 1 Then
			ls_st_cust_code = Mid(w_do.idw_main.getitemstring(1,'shipping_instructions' ),pos( w_do.idw_main.getitemstring(1,"shipping_instructions"),'BOL:') +4,10)
		Else 
			ls_st_cust_code = ''
		End If	
		ld_packprint.setitem(llNewRow,"cust_order_no",'')	// Blank Customer PO for Drop Ships
	Else
		ls_st_cust_code = w_do.idw_main.getitemstring(1,'cust_order_no' )
	End If
		
	ld_packprint.setitem(llNewRow,"alt_cust_code",ls_st_cust_code)
	ld_packprint.setitem(llNewRow,"sold_to_name",ls_st_name)
	ld_packprint.setitem(llNewRow,"sold_to_address1",ls_st_addr1)
	ld_packprint.setitem(llNewRow,"sold_to_address2",ls_st_addr2)
	ld_packprint.setitem(llNewRow,"sold_to_address3",ls_st_addr3)
	ld_packprint.setitem(llNewRow,"sold_to_address4",ls_st_addr4)
	ld_packprint.setitem(llNewRow,"sold_to_state",ls_st_state)
	ld_packprint.setitem(llNewRow,"sold_to_city",ls_st_city)
	ld_packprint.setitem(llNewRow,"sold_to_zip",ls_st_zip)
	ld_packprint.setitem(llNewRow,"sold_to_country",ls_st_country)
	ld_packprint.setitem(llNewRow,"sold_to_tel",ls_st_tel)
	// end if sold to info
					
	ld_packprint.setitem(llNewRow,"Line_item_no",llLineItemNo)
	ld_packprint.setitem(llNewRow,"sku",lsSKU)
	ld_packprint.setitem(llNewRow,"alt_sku",lsaltSku)  		
	
	ld_packprint.setitem(llNewRow,"uom",w_do.idw_detail.getitemstring(llRowPos,"uom"))
	ld_packprint.setitem(llNewRow,"ord_qty",w_do.idw_detail.getitemNumber(llRowPos,"req_qty"))
	ld_packprint.setitem(llNewRow,"picked_quantity",w_do.idw_detail.getitemNumber(llRowPos,"alloc_qty"))
	
	//We need the Decription from Item MAster
	Select Description into :lsDesc
	From Item_Master
	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
	
	ld_packprint.setitem(llNewRow,"description",lsDesc)
		
	//There may be serial numbers on picking...
	lsSerial = ""
	llFindRow = w_do.idw_Pick.Find("Line_Item_No = " + String(llLineItemNO) + " and Upper(sku) = '" + Upper(lsSKU) + "'",1,w_do.idw_Pick.rowCount())
	Do While llFindRow > 0
		
		If w_do.idw_Pick.GetITemString(llFindROw,'serial_no') <> '-' Then
			lsSerial += ", " + w_do.idw_Pick.GetITemString(llFindROw,'serial_no')
		End IF
		
		llFindRow ++
		If llFindRow > w_do.idw_Pick.rowCount() Then
			llFindRow = 0
		Else
			llFindRow = w_do.idw_Pick.Find("Line_Item_No = " + String(llLineItemNO) + " and Upper(sku) = '" + Upper(lsSKU) + "'",llFindRow,w_do.idw_Pick.rowCount())
		End If
				
	Loop
	
	If lsSerial > "" Then
		lsSerial = Mid(lsSerial,3,99999) /*strip off first comma*/
	End If
	
	ld_packprint.setitem(llNewRow,"serial_no",lsSerial)
	
Next /*Detail row*/

If	ld_packprint.dataobject > ''  Then
	OpenWithParm(w_dw_print_options,ld_packprint) 
End If



Return 0
end function

public function integer uf_packprint_kendo ();
String	lsdono, lsPrinter, lsSql,  lsConSolNo


w_do.idw_packPrint.Dataobject = 'd_packing_prt_kendo_consolidated' 
w_do.idw_packPrint.SetTransObject(SQLCA)
lsSql = w_do.idw_packPrint.GetSQLSelect()

w_do.idw_main.AcceptText()
w_do.idw_other.AcceptText()
w_do.idw_Pack.AcceptText()
w_do.idw_serial.AcceptText()

If w_do.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_do.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

If  w_do.idw_pack.rowcount() = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

lsdono= w_do.idw_main.GetitemString(1,'Do_No')
lsConSolNo= w_do.idw_main.GetitemString(1,'Consolidation_No')

// in W_DO, we are retreiving by Consolidation_No to print all orders on the shipment, make sure all are in at least packing status
if w_do.idw_shipments.RowCount() > 0 Then
	
	If w_do.idw_shipments.Find("Ord_status in ('N', 'P','I','V')", 1, w_do.idw_shipments.rowcount()) > 0 Then
		MessageBox("Print Packing List"," All orders on the shipment must be in at least packing status to print the consolidated Pack List!")
		Return 0
	End If
	
End If

//TAM 2017/09/27 - SIMSPEVS-813 - Add Validation to not print the packlist if the pallent count(DM.UF9 is not filled in. 
string lsuf9
lsuf9 = trim(w_do.idw_main.GetitemString(1,'user_field9'))
if lsuf9 = '' or isNull(lsuf9) or not isNumber(lsuf9) Then
	MessageBox("Print Packing List"," A numeric Pallet count must be entered on the Other Info tab to print the consolidated Pack List!")
	Return 0
End If
	
//Add Consolidation No to the Where Clause if present, otherwise DO_NO
If lsConsolNo > '' Then
	lsSQl +=   " And Consolidation_No = '" + lsConsolNo + "'"
Else
	lsSQl += " And Delivery_Master.DO_NO = '" + lsdono + "'"
End If


w_do.idw_packPrint.SetSqlSelect(lssql)
w_do.idw_packPrint.Retrieve()

//  If we have a default printer for Kendo PackList, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','KENDOPACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

OpenWithParm(w_dw_print_options,w_do.idw_packPrint) 

//GailM 07/02/2019 DE11263 KDO - Kendo: 'Unable to Post PDF' Error Message - Disabling the entire call to save PDF.  
//Kendo not using this functionality.  Want error to go but do not miss PDF
//uf_save_packlist_pdf(lsdono) //20-Feb-2017 :Madhu -PEVS-467 -KDO Save PackList to PDF

// We want to store the last printer used for Printing the Kendo PackList for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','KENDOPACKLIST',lsPrinter)

REturn 0
end function

public function integer uf_packprint_kendo_batch ();
String	lsdono, lsPrinter, lsSql,  lsConSolNo
Long	llbatchPickID

w_batch_pick.idw_packPrint.Dataobject = 'd_packing_prt_kendo_consolidated' 
w_batch_pick.idw_packPrint.SetTransObject(SQLCA)
lsSql = w_batch_pick.idw_packPrint.GetSQLSelect()

w_batch_pick.idw_Pack.AcceptText()


If w_batch_pick.ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(w_batch_pick.is_title,'Please save changes before printing Pack List.')
	Return 0
End If

If  w_batch_pick.idw_pack.rowcount() = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return 0
End If

//Add Batch Pick ID to the Where Clause - Printing for all orders in Batch - will break on Shipment ID (Consolidation_NO)
llbatchPickID = w_batch_pick.idw_Master.GetITemNumber(1,'batch_pick_ID')
lsSQl += " And Delivery_Master.Batch_Pick_ID = " + String(llbatchPickID)

w_batch_pick.idw_packPrint.SetSqlSelect(lssql)
w_batch_pick.idw_packPrint.Retrieve()

//  If we have a default printer for Kendo PackList, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','KENDOPACKLIST','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)

OpenWithParm(w_dw_print_options,w_batch_pick.idw_packPrint) 

// We want to store the last printer used for Printing the Kendo PackList for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','KENDOPACKLIST',lsPrinter)

REturn 0
end function

public function integer uf_save_packlist_pdf (string asdono);//20-Feb-2017 :Madhu -PEVS-467 -KDO Save PackList to PDF and Post XML Request to Websphere

int li_FileNo,li_ret
long ll_bytes
string ls_pack_pdf,ls_encoded, lsXMLReq, lsXMLRes,lsreturncode,lsreturndesc
Blob blob_pack_pdf

//PDF file location
ls_pack_pdf=gs_pdfpath+asDono+"_PackList"+".PDF"

//If File already exists, delete the previous file
If FileExists(ls_pack_pdf) Then
	FileDelete(ls_pack_pdf)
End If

//save datawindow into PDF File
w_do.idw_packPrint.Object.DataWindow.Export.PDF.Method = Distill!
w_do.idw_packPrint.Object.DataWindow.Printer = "Sybase DataWindow PS"
w_do.idw_packPrint.Object.DataWindow.Export.PDF.Distill.CustomPostScript="Yes"
li_ret = w_do.idw_packPrint.SaveAs(ls_pack_pdf, PDF!, true)

//write PDF file into Blob
li_FileNo = FileOpen(ls_pack_pdf,StreamMode!)
ll_bytes = FileReadEx(li_FileNo, blob_pack_pdf)
FileClose(li_FileNo)

//call the encode function
n_cryptoapi ln_crypto  
ls_encoded =ln_crypto.of_encode64(blob_pack_pdf)

//build XML request

u_nvo_websphere_post  lu_websphere
lu_websphere =create u_nvo_websphere_post

lsXMLReq =lu_websphere.uf_request_header( "PushPDFFileToDMSRequest", "Project_Id ='"+gs_project+"'")
lsXMLReq += "<Do_No>"+ asdono +"</Do_No>"
lsXMLReq += "<EncodedData>"+ ls_encoded +"</EncodedData>"
lsXMLReq =lu_websphere.uf_request_footer( lsXMLReq)

lsXMLRes = lu_websphere.uf_post_url( lsXMLReq)

if Pos(upper(lsXMLRes),"SIMSRESPONSE")=0 Then
	f_method_trace_special( gs_project, this.ClassName() + ' - uf_save_packlist_pdf', 'Websphere Fatal Exception Error:  ',asdono, ' ',lsXMLRes,asdono) 
	//GailM 07/02/2019 DE11263 KDO - Kendo: 'Unable to Post PDF' Error Message - Will also not return error condition 
	//Messagebox("Websphere Fatal Exception Error","Unable to send PDF Encoded data: ~r~r" + lsXMLRes,StopSign!)
	//Return -1
End If

//Check the return code and return description for any trapped errors
lsreturncode = lu_websphere.uf_get_xml_single_element( lsXMLRes, "returncode")
lsreturndesc = lu_websphere.uf_get_xml_single_element( lsXMLRes, "errormessage")

choose case lsreturncode
	case "-99"
			Messagebox("Websphere Operational Exception Error","Unable to post PDF encoded data to Websphere: ~r~r" + lsreturndesc,StopSign!)
			return -1

	case else
		If lsreturndesc > '' Then
			Messagebox("PushPDFFileToDMS",lsreturndesc)
		End If

End choose

return 0
end function

public function integer uf_packprint_hagersg ();
//GailM 09/28/2017 HAGER-SG customized packing list
//  Cloned from uf_packprint_scitex
Long	lLRowCount, llRowPos, llWarehouseRow, llNewRow, llPickPos, llPickCount,  lLDetailFindRow, llLineItem,	&
		llSerialPos, llSerialCount, llBandHeight, llTotalHeight, llordqty, llNbrPallets, llPallet, llPalletPrev
String	lsWarehouse, lsSKU, lsSKUPrev, lsSupplier, lsDONO, lsDesc, lsDimensions, lsLength, lsWidth, lsHeight
String	lsCarton, lsCartonPrev, lsFind, lsPallets
String ShipFromName, ShipFromAddr1, ShipFromAddr2, ShipFromAddr3, ShipFromAddr4
String ShipFromCity, ShipFromState, ShipFromZip, ShipFromCountry, ShipFromTel, ShipFromFax
String CustName, CustAddr1, CustAddr2, CustAddr3, CustAddr4
String CustCity, CustState, CustZip, CustCountry, CustTel, CustFax
DataStore	ldpackprint
Int	liRowsPerPAge, liEmptyRows, liMod, liXPos1, liXPos2, liLength, liWidth, liHeight, liNbrCartons
Datetime ldtToday
Decimal ldVolume, ldWeight
Dec ldGrossWeight, ldQuantity

ldpackprint = Create Datastore
ldpackprint.dataobject ='d_packing_prt_hagersg'


//Number of rows per page - we will want to insert enough rows on the last page so the sumamry is at the bottom
liRowsPerPage = 17 /* testing with standard - production on A4 in Europe (probably 20) */

//Warehouse (Shipper) info retreived in Warehouse DS
lsWarehouse = w_do.idw_Main.GetITEmString(1,'wh_Code')
lsDoNO = w_do.idw_Main.GetITEmString(1,'do_no')
llwarehouseRow = g.ids_project_warehouse.Find("Upper(wh_Code) = '" + Upper(lsWarehouse) + "'",1,g.ids_project_warehouse.rowCount())

ShipFromName =  g.ids_project_warehouse.Describe( "Evaluate('WordCap(~"" +  g.ids_project_warehouse.GetItemString( llwarehouseRow, 'WH_Name' ) + "~")'," + string(llwarehouserow) + ")" )
ShipFromAddr1 =  g.ids_project_warehouse.Describe( "Evaluate('WordCap(~"" +  g.ids_project_warehouse.GetItemString( llwarehouseRow, 'Address_1' ) + "~")'," + string(llwarehouserow) + ")" )
ShipFromAddr2 =  g.ids_project_warehouse.Describe( "Evaluate('WordCap(~"" +  g.ids_project_warehouse.GetItemString( llwarehouseRow, 'Address_2' ) + "~")'," + string(llwarehouserow) + ")" )
ShipFromAddr3 =  g.ids_project_warehouse.Describe( "Evaluate('WordCap(~"" +  g.ids_project_warehouse.GetItemString( llwarehouseRow, 'Address_3' ) + "~")'," + string(llwarehouserow) + ")" )
ShipFromAddr4 =  g.ids_project_warehouse.Describe( "Evaluate('WordCap(~"" +  g.ids_project_warehouse.GetItemString( llwarehouseRow, 'Address_4' ) + "~")'," + string(llwarehouserow) + ")" )
ShipFromCity    =  Trim( g.ids_project_warehouse.Describe( "Evaluate('WordCap(~"" +  g.ids_project_warehouse.GetItemString( llwarehouseRow, 'City' ) + "~")'," + string(llwarehouserow) + ")" ) )
ShipFromState = g.ids_project_warehouse.GetItemString( llwarehouseRow, 'State' )
ShipFromZip     = g.ids_project_warehouse.GetItemString( llwarehouseRow, 'Zip'  )
ShipFromCountry = g.ids_project_warehouse.GetItemString( llwarehouseRow, 'Country' )
ShipFromTel = g.ids_project_warehouse.GetItemString( llwarehouseRow, 'Tel' )
ShipFromFax = g.ids_project_warehouse.GetItemString( llwarehouseRow, 'Fax' )

CustName =  w_do.idw_main.Describe( "Evaluate('WordCap(~"" + w_do.idw_main.GetItemString(1, 'cust_Name' ) + "~")'," + string(1) + ")" )
CustAddr1 =  w_do.idw_main.Describe( "Evaluate('WordCap(~"" + w_do.idw_main.GetItemString(1, 'Address_1' ) + "~")'," + string(1) + ")" )
CustAddr2 =  w_do.idw_main.Describe( "Evaluate('WordCap(~"" + w_do.idw_main.GetItemString(1, 'Address_2' ) + "~")'," + string(1) + ")" )
CustAddr3 =  w_do.idw_main.Describe( "Evaluate('WordCap(~"" + w_do.idw_main.GetItemString(1, 'Address_3' ) + "~")'," + string(1) + ")" )
CustAddr4 =  w_do.idw_main.Describe( "Evaluate('WordCap(~"" + w_do.idw_main.GetItemString(1, 'Address_4' ) + "~")'," + string(1) + ")" )
CustCity    =  w_do.idw_main.Describe( "Evaluate('WordCap(~"" + w_do.idw_main.GetItemString(1, 'City' ) + "~")'," + string(1) + ")" )
CustState =w_do.idw_main.GetItemString(1, 'State' )
CustZip     =w_do.idw_main.GetItemString(1, 'Zip'  )
CustCountry =w_do.idw_main.GetItemString(1, 'Country' )

ldtToday = f_getLocalWorldTime ( lsWarehouse ) 			// Pack List report date
llPallet = 0
llPalletPrev = 0
llNbrPallets = 0
lsCartonPrev = ''		//Initialize CartonPrev
lsSKUPrev = ''			//Initialize SKUPrev
ldGrossWeight = 0
ldQuantity = 0

//For each Packing Row
llRowCount = w_do.idw_Pack.RowCount()

//Sort by outerpack_id and sku
//w_do.idw_Pack.SetSort('outerpack_id A, sku A')
//w_do.idw_Pack.Sort( )

For llRowPos = 1 to llRowCount
	lsLength = ''
	lsWidth = ''
	lsHeight = ''
	liLength = 0
	liWidth = 0
	liHeight = 0
	
	llPallet = w_do.idw_Pack.GetITemNUmber(llRowPos,'outerpack_id')
	//The pallet changes - Dimensions of pallet
	If llPallet <> llPalletPrev Then
		llNbrPallets ++
		//Dimensions
		lsDimensions = Lower(w_do.idw_Pack.GetItemString(llRowPos, 'user_field1'))
		liXPos1 = pos( lsDimensions, 'x' )
		If liXPos1 > 0 Then 
			lsLength = Left( lsDimensions, liXPos1 - 1 )
			if isNumber( lsLength ) Then
				liLength = Integer( lsLength)
				liXPos2 = pos( lsDimensions, 'x', liXPos1 +1 ) 
				If liXPos2 > 0 Then
					lsWidth = mid( lsDimensions, liXPos1 +1,  liXPos2 - liXPos1 - 1 )		
					If isNumber( lsWidth ) Then
						liWidth = Integer( lsWidth )
						lsHeight = right( lsDimensions, len( lsDimensions ) - liXPos2 ) 
						If isNumber( lsHeight ) Then
							liHeight = Integer( lsHeight ) 
						End If
					End If
				End If
			End If
		End If	
		llPalletPrev = llPallet
	End If
	
	lsSKU = w_do.idw_Pack.GEtITEmString(llRowPos,'sku')
	If lsSKU <> lsSKUPrev Then
		liNbrCartons = 0
		lsCartonPrev = ''
		ldGrossWeight = 0
		ldQuantity = 0
		lsSKUPrev = lsSKU
		llNewRow = ldpackprint.InsertRow(0)	
	End If
	
	lsCarton = w_do.idw_Pack.GEtITEmString(llRowPos,'Carton_no')
	If lsCarton <> lsCartonPrev Then
		liNbrCartons ++
		lsCartonPrev = lsCarton
	End If

	ldGrossWeight += (w_do.idw_Pack.GetITemNumber(llRowPos,'weight_gross') )
	ldQuantity += w_do.idw_Pack.GetITemNumber(llRowPos,'quantity' )
	
	//Display only one per pallet
	If liLength > 0 Then
		ldpackprint.SetITem(llNewRow,'length', liLength )
		ldpackprint.SetITem(llNewRow,'width', liWidth )
		ldpackprint.SetITem(llNewRow,'height', liHeight )
		ldVolume = (liLength * liWidth * liHeight) / 1000000
		ldpackprint.SetITem( llNewRow, 'volume', ldVolume )
	End If

	//Packing level fields...
	ldpackprint.SetITem(llNewRow,'outerpack_id', llPallet )
	ldpackprint.SetITem(llNewRow,'sku',lsSKU)
	ldpackprint.SetITem(llNewRow,'carton_no', lsCarton)
	ldpackprint.SetITem(llNewRow,'unit_weight', ldGrossWeight )
	ldpackprint.SetITem(llNewRow,'picked_quantity', ldQuantity )
	ldpackprint.SetITem(llNewRow,'nbr_cartons', liNbrCartons )
	
	ldpackprint.SetITem(llNewRow,'line_item_No',  w_do.idw_Pack.GEtITEmNumber(llRowPos,'line_item_no') )
	ldpackprint.SetITem(llNewRow,'supp_code',  w_do.idw_Pack.GEtITEmString(llRowPos,'supp_code') )

	//Header fields
	ldpackprint.SetITem(llNewRow,'cust_order_No', w_do.idw_Main.GetITemString(1,'cust_order_no') )
	ldpackprint.SetITem(llNewRow,'invoice_no', w_do.idw_Main.GetITemString(1,'invoice_no') )
	ldpackprint.SetITem(llNewRow,'complete_date', ldtToday )		// This may change to today's date - ToDo
	ldpackprint.SetITem(llNewRow,'ship_via', w_do.idw_Main.GetITemString( 1, "ship_via" ) )
	
	//Gailm 11/08/2017 - SIMSPEVS-924 -  Hager-SG - Packing List Customer Co Name & Address Extract from Warehouse Code	
	//Ship from company
	ldpackprint.SetITem(llNewRow,'ship_from_name', ShipFromName  ) 
	ldpackprint.SetITem(llNewRow,'ship_from_address1' ,ShipFromAddr1 )
	ldpackprint.SetITem(llNewRow,'ship_from_address2', ShipFromAddr2 )
	ldpackprint.SetITem(llNewRow,'ship_from_address3', ShipFromAddr3 )
	ldpackprint.SetITem(llNewRow,'ship_from_address4', ShipFromAddr4 )
	ldpackprint.SetItem(llNewRow, 'ship_from_city', ShipFromCity )
	ldpackprint.SetItem(llNewRow, 'ship_from_state', ShipFromState )
	ldpackprint.SetItem(llNewRow, 'ship_from_zip', ShipFromZip )
	ldpackprint.SetItem(llNewRow, 'ship_from_tel', ShipFromTel )
	ldpackprint.SetITem(llNewRow,'ship_from_fax', ShipFromFax )

	//Customer Address -> Delivery
	ldpackprint.SetITem(llNewRow,'cust_name', CustName )
	ldpackprint.SetITem(llNewRow,'delivery_address1', CustAddr1 )
	ldpackprint.SetITem(llNewRow,'delivery_address2', CustAddr2 )
	ldpackprint.SetITem(llNewRow,'delivery_address3', CustAddr3 )
	ldpackprint.SetITem(llNewRow,'delivery_address4', CustAddr4)
	ldpackprint.SetITem(llNewRow,'city', CustCity )
	ldpackprint.SetITem(llNewRow,'delivery_state', CustState )
	ldpackprint.SetITem(llNewRow,'delivery_zip', CustZip )
	ldpackprint.SetITem(llNewRow,'country', CustCountry )
	
Next /*PAcking Row*/

lsPallets = NumToWord( llNbrPallets )
lsPallets = lsPallets + " (" + String( llNbrPallets ) + ")"
ldPackprint.setitem( 1, 'name_2', lsPallets )		// Save the number of pallets in word format to name_2 first row

//w_do.idw_Pack.SetSort( '' )
//w_do.idw_Pack.Sort( )

OpenWithParm(w_dw_print_options,ldpackprint) 

Return 0
end function

public function string numtoword (integer ai_nbr);/* SIMSPEVS-846 */

String ls_Single[], ls_Ten[], ls_Teen[], ls_Mega[]
String ls_Hundred, ls_Word, ls_Char, ls_Temp,ls_Cents, ls_Nbr
Integer li_Point
Long ll_Position
ls_Single = { ' ONE',' TWO',' THREE',' FOUR',' FIVE','SIX',' SEVEN','EIGHT',' NINE' }
ls_Ten = { ' TEN',' TWENTY',' THIRTY',' FORTY',' FIFTY','SIXTY','SEVENTY',' EIGHTY',' NINETY' }
ls_Teen = { ' TEN', ' ELEVEN',' TWELVE',' THIRTEEN','FOURTEEN','FIFTEEN',' SIXTEEN',' SEVENTEEN',' EIGHTEEN',' NINETEEN' }
ls_Mega = { '','THOUSAND','MILLION','BILLION'}
ls_Hundred = 'HUNDRED'
li_Point = 1

ls_Nbr = String( ai_Nbr )
ls_Word = ''
ls_Temp = Right( ls_Nbr,3 )
Do While Len(ls_Temp) > 0
	CHOOSE CASE Len( ls_Temp )
		CASE 3
		ls_Char = Mid(ls_Temp,1,1)
		If ls_Char <> '0' THEN
			ls_Word += ls_Single[Integer(ls_Char)] + ' ' +ls_Hundred
		END IF
			ls_Temp = Mid(ls_Temp,2)
		CASE 2
			ls_Char = Mid(ls_Temp,1,1)
			If ls_Char = '0' THEN
				ls_Temp = Mid(ls_Temp,2,1)
			Else
				If ls_Char = '1' THEN 
					ls_Word += ls_Teen[Integer(Mid(ls_Temp,2,1))+1]
					ls_Temp = ''
				Else
					ls_Word += ls_Ten[Integer(ls_Char)]
					ls_Temp = Mid(ls_Temp,2,1)
				END IF
			END IF
		CASE 1
			ls_Char = Mid(ls_Temp,1,1)
			If ls_Char <> '0' THEN
				ls_Word += ls_Single[Integer(ls_Char)]
			END IF
			ls_Temp = ''
	END CHOOSE
LOOP


Return ls_Word
end function

on u_nvo_custom_packlists.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_custom_packlists.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

