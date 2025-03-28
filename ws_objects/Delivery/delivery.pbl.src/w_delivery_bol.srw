$PBExportHeader$w_delivery_bol.srw
$PBExportComments$+ TMS Bill Of Lading
forward
global type w_delivery_bol from window
end type
type dw_2 from datawindow within w_delivery_bol
end type
type dw_1 from datawindow within w_delivery_bol
end type
type rb_1 from radiobutton within w_delivery_bol
end type
type dw_bol_prt from datawindow within w_delivery_bol
end type
type rb_cbol from radiobutton within w_delivery_bol
end type
type rb_mbol from radiobutton within w_delivery_bol
end type
type st_2 from statictext within w_delivery_bol
end type
type cb_print from commandbutton within w_delivery_bol
end type
type cb_generate from commandbutton within w_delivery_bol
end type
type sle_load_id from singlelineedit within w_delivery_bol
end type
type st_text from statictext within w_delivery_bol
end type
end forward

global type w_delivery_bol from window
integer width = 4338
integer height = 1984
boolean titlebar = true
string title = "Bill Of Lading"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
event ue_process_bol ( )
event ue_print_bol ( )
event ue_retrieve ( )
event ue_cmr_print ( )
dw_2 dw_2
dw_1 dw_1
rb_1 rb_1
dw_bol_prt dw_bol_prt
rb_cbol rb_cbol
rb_mbol rb_mbol
st_2 st_2
cb_print cb_print
cb_generate cb_generate
sle_load_id sle_load_id
st_text st_text
end type
global w_delivery_bol w_delivery_bol

type variables
w_delivery_bol iw_window
Datawindow idw_do_bol
string is_dono,is_shipment,ls_user_field16
end variables

event ue_process_bol();
//29-AUG-2018 :Madhu S23059 - Process BOL
string ls_load_shipment, ls_text,ls_dono
long ll_count, ll_row,ll_ordercount,ll_count_carton

u_nvo_custom_bol 	lu_bol
lu_bol = Create u_nvo_custom_bol

SetPointer(HourGlass!)

ls_load_shipment = sle_load_id.text
//Begin - Dinesh - 09/07/2021 - S57453	- Google - SIMS - Bill of Lading Changes
select count(*) into :ll_ordercount From delivery_master Where Project_Id=:gs_project and Shipment_Id =:ls_load_shipment;
select count(*) into :ll_count_carton from Delivery_Packing dp, Delivery_Master dm where dp.DO_No=dm.DO_No
and dm.Project_Id=:gs_project and dm.shipment_id = :ls_load_shipment;

//End - Dinesh - 09/07/2021 - S57453	- Google - SIMS - Bill of Lading Changes
//get checked value (MBOL /CBOL)
CHOOSE CASE upper(gs_project)
	CASE 'PANDORA'
		IF rb_mbol.checked=True THEN
			this.dw_bol_prt.dataobject='d_vics_mbol_prt_pandora' 
		
			If isnull(ls_load_shipment) or ls_load_shipment ='' Then
				MessageBox("BOL Generate", "Please provide Load Id to generate MBOL")
				Return
			end If
			
			//get orders count against Load Id.
			select count(*) into :ll_count from Delivery_Master with(nolock)
			where Project_Id =:gs_project and Load_Id =:ls_load_shipment
			and  ord_status in ('I', 'A', 'C', 'D','L'); // Dinesh - 04/20/2023- SIMS-53- Google - SIMS - Load Lock and New Loading Status - Added 'L'
			
			ls_text = "Outbound Order is not available to generate MBOL against Load Id: "+ls_load_shipment
		ELSEIF rb_cbol.checked=True THEN
			ls_text ="CBOL"
		    
			If isnull(ls_load_shipment) or ls_load_shipment ='' Then
				MessageBox("BOL Generate", "Please provide Shipment Id to generate CBOL")
				Return
			end If

			//get orders count against Shipment Id.
			select count(*) into :ll_count from Delivery_Master with(nolock)
			where Project_Id =:gs_project and Shipment_Id =:ls_load_shipment
			and  ord_status in ('I', 'A', 'C', 'D','L'); // Dinesh - 04/20/2023- SIMS-53- Google - SIMS - Load Lock and New Loading Status - Added 'L'
			
			ls_text = "Outbound Order is not available to generate CBOL against Shipment Id: "+ls_load_shipment
	//Date -11-24-2021----Dhirendra-S63594-Google Change: CMR documen--Start
           ELSEIF rb_1.checked=True THEN
			ls_text ="Generate CMR"
		    
			If isnull(ls_load_shipment) or ls_load_shipment ='' Then
				MessageBox("BOL Generate", "Please provide Shipment Id to generate CMR")
				Return
			end If

			//get orders count against Shipment Id.
			select count(*) into :ll_count from Delivery_Master with(nolock)
			where Project_Id =:gs_project and Shipment_Id =:ls_load_shipment
			and  ord_status in ('I', 'A', 'C', 'D','L'); // Dinesh - 04/20/2023- SIMS-53- Google - SIMS - Load Lock and New Loading Status - Added 'L'
		     IF ll_count > 0 then 
			     select do_no into :is_dono from Delivery_Master with(nolock)
			    where Project_Id =:gs_project and Shipment_Id =:ls_load_shipment
			    and  ord_status in ('I', 'A', 'C', 'D','L'); // Dinesh - 04/20/2023- SIMS-53- Google - SIMS - Load Lock and New Loading Status - Added 'L'
			end if 
			IF is_dono >'' then 
			 is_shipment =ls_load_shipment 
				this.triggerevent('ue_retrieve')
			 return
			end if 
			ls_text = "Outbound order is not available to generate CMR against shipment id:"+ls_load_shipment
	
	//Date -11-24-2021----Dhirendra-S63594-Google Change: CMR documen--END 
        END IF
END CHOOSE

If ll_count = 0 Then
	MessageBox("BOL Generate", ls_text)
	Return
End If

//Retrieve data
CHOOSE CASE upper(gs_project)
	CASE 'PANDORA'
	
		If rb_mbol.checked=True Then
            lu_bol.uf_process_master_bol_pandora( ls_load_shipment, idw_do_bol)
			this.dw_bol_prt.scroll( idw_do_bol.rowcount( ))
		else
//			this.dw_bol_prt.dataobject='d_vics_cbol_prt_pandora' // Dinesh - 08/23/2021
//			if ll_ordercount <=5 and ll_count_carton <=5 then
//			lu_bol.uf_process_child_bol_pandora( ls_load_shipment, idw_do_bol)// Dinesh - 08/23/2021- S57453- Google - SIMS - Bill of Lading Changes
//				//lu_bol.uf_process_cbol_combine_pandora( ls_load_shipment, idw_do_bol) // Dinesh - 08/23/2021-S57453-  Google - SIMS - Bill of Lading Changes
//			else 
			     this.dw_bol_prt.dataobject='d_vics_cbol_prt_greater5_composite_rpt_pandora' // Dinesh - 08/23/2021-S57453- Google - SIMS - Bill of Lading Changes
				lu_bol.uf_process_cbol_greater5_combine_pandora( ls_load_shipment, idw_do_bol) // Dinesh - 09/03/2021-S57453-  Google - SIMS - Bill of Lading Changes
			//end if	
			this.dw_bol_prt.scroll( idw_do_bol.rowcount())
		End If
END CHOOSE

destroy lu_bol
end event

event ue_print_bol();OpenWithParm(w_dw_print_options, idw_do_bol)
end event

event ue_retrieve();

//Date -11-24-2021----Dhirendra-S63594-Google Change: CMR documen--Start

Long	ll_numrows, ll_rownum, llNewRow, llWarehouseRow, llBoxCount, llFindRow, ll_whsezip,ls_qty
String	lsWarehouse,lsWarehouse1, lsDONO, lsCarrier, lsCityZip, ls_orderno, ls_sku, ls_owner, ls_whsecity, ls_whsecntry, ls_shipvia, ls_addr_1, ls_whsezip, ls_whsephone, ls_whsefax
String	lsCarrierNAme, lsCarrierAddr1, lsCarrierAddr2, lsCarrierCity, lsCarrierZip, lsCarrierCountry, lsCountryName, lsFind, lsCol, ls_shippinginstructions, ls_lastuser,ls_load_id,ls_cust_id
Int	liRowsPerPAge, liEmptyRows, liMod, liColumnPos
Decimal	ldTotalWeight, ld_length, ld_width, ld_height, ld_volm3, ld_weight
string ls_custcode,ls_custcode1,ls_carrier
DataStore	ldsLookup, lds_packingrow
string ls_cust_name,ls_address_1,ls_address_2,ls_shiptocity,ls_shiptocountry,ls_shiptozip,ls_ship_via,ls_last_user,ls_Carrier_name
string   lsCarrierCountry_city,ls_esd_date
datawindow ldw_detail, ldw_packing, ldw_other, ldw_main
long ll_packlineno, ll_detlineno, ll_numpackrows, ll_numpackages
string ls_cartontype, ls_dims,ls_load_cust_warehouse_id
//TimA
String ls_ship_from_name, ls_addr_2, ls_carton_no
	 

//Number of rows per page - we will want to insert enough rows on the last page so the sumamry is at the bottom
liRowsPerPage = 19
liRowsPerPage = 3



Select cust_code,user_field2,load_id,cust_name,address_1,address_2,city,country,zip,ship_via,last_user,Carrier,schedule_date,last_user,user_field16
    into :ls_custcode1,:ls_custcode,:ls_load_id,:ls_cust_name,:ls_address_1,:ls_address_2,:ls_shiptocity,:ls_shiptocountry,:ls_shiptozip,:ls_ship_via,:ls_last_user,:ls_Carrier_name,:ls_esd_date,:ls_lastuser,:ls_user_field16
    From delivery_master  with(nolock)
    Where Project_id = :gs_project and shipment_id = :sle_load_id.text using Sqlca;
	 
 Select Cust_name, Address_1, Address_2, Zip, City,Country,user_field4
 into :lsCarrierNAme, :lsCarrierAddr1, :lsCarrierAddr2, :lsCarrierZip, :lsCarrierCity, :lsCarrierCountry, :lsWarehouse
 From customer  with(nolock)
 Where Project_id = :gs_project and cust_code = :ls_custcode using Sqlca;
	

//lsDoNO = ldw_Main.GetITEmString(1,'do_no')
lds_packingrow = create datastore
lds_packingrow.dataobject='d_packingrow_group_by_crtn_plt'
lds_packingrow.settransobject(sqlca)
lds_packingrow.retrieve(sle_load_id.text)


Select user_field4
into  :lsWarehouse1
From customer with(nolock)
Where Project_id = :gs_project and cust_code = :ls_custcode1 using Sqlca;

// Create the lookup datastore.
ldsLookup = Create Datastore
ldsLookup.dataobject = 'dddw_lookup'
ldsLookup.SetTransObject(SQLCA)
ldsLookup.Retrieve(gs_project,'CMR')


	//Ship From Name based on Supplier Code (first row only)
	//17-Nov-2015 :Madhu- Replaced MenloWorldWide by XPO -START
dw_bol_prt.dataobject='d_pandora_cmr_report'
llNewRow = dw_bol_prt.InsertRow(0)

			ls_ship_from_name = g.ids_project_warehouse.GetITemString(llWarehouseRow,'wh_name')			
					
	
	//17-Nov-2015 :Madhu- Replaced MenloWorldWide by XPO -END
		
		IF isnull(ls_addr_1) then ls_addr_1 = ""
		IF isnull(ls_addr_2) then ls_addr_2 = ""
		IF isnull(ls_whsecity) then ls_whsecity = ""
		IF isnull(ls_whsecntry) then ls_whsecntry = ""
		IF isnull(ls_whsezip) then ls_whsezip = ""
//		IF isnull(ls_whsephone) then ls_whsephone = ""
		IF isnull(ls_whsefax) then ls_whsefax = ""
		

		
		//TimA 08/16/12 Pandora issue 491.
			
			dw_bol_prt.Modify("t_shipfromname.text =  '" + lsCarrierNAme + "'")
				
		ls_load_cust_warehouse_id = ls_load_id+lsWarehouse+lsWarehouse1
		dw_bol_prt.SetITem(1,'load_ware_cust_id', ls_load_cust_warehouse_id)
		dw_bol_prt.Modify("t_shipfromaddress.text = '" + lsCarrierAddr1 + "'")
		dw_bol_prt.Modify("t_shipfromaddress_2.text = '" + lsCarrierAddr2 + "'")			
		dw_bol_prt.Modify("t_shipfromzipcity.text = '" + lsCarrierzip + "   " + lsCarriercity + "'")
		dw_bol_prt.Modify("t_shipfromcountry.text = '" + lsCarriercountry + "'")

	//Ship To Address
		//next
	llFindRow = ldsLookup.Find("Code_ID = 'CMR.Section4.1'",1,ldsLookup.RowCount())
	If llFindRow > 0 Then
		dw_bol_prt.SetITem(llNewRow,'lookup_41',ldsLookup.GetITEmString(llFindRow,'code_descript'))
	End If

	// Set the shipping instructions.

    dw_bol_prt.Modify("t_1.text = 'SEAL NUMBER:'")


// Get the number of packing rows.
//For each Detail Record
ll_numrows = lds_packingrow.RowCount()

// Loop through the detail rows.
For ll_rownum = 1 to ll_numrows
	
	// Set the order number.
	dw_bol_prt.SetITem(llNewRow,'order_no',  lds_packingrow.getitemstring(llNewRow, "invoice_no"))
	
	// Get and set the number of packages for this line item.
	//TimA 08/16/12 Pandora issue 491.

		ls_qty = lds_packingrow.getitemnumber(ll_rownum, "Qty")		
		dw_bol_prt.SetITem(ll_rownum,'carton_no', ls_qty)
	     dw_bol_prt.object.l_2.visible=false
          			

			 if isnull(ls_load_id)  then ls_load_id=''
			 if isnull(lsWarehouse) then lsWarehouse=""
			 if isnull(lsWarehouse1) or lsWarehouse1 = '' then
				lsWarehouse1=ls_custcode1 
			end if 
		dw_bol_prt.SetITem(llNewRow,'ship_from_name',lsCarrierNAme)	
		dw_bol_prt.SetITem(llNewRow,'ship_from_addr1', lsCarrieraddr1)
		dw_bol_prt.SetITem(llNewRow,'ship_from_addr2', lsCarrieraddr2)		
		dw_bol_prt.SetITem(llNewRow,'ship_from_city',lsCarrierCity)
		dw_bol_prt.SetITem(llNewRow,'ship_from_country',lsCarrierCountry)
		dw_bol_prt.SetITem(llNewRow,'ship_from_zip', lsCarrierzip)
		
		//Ship To Address
		dw_bol_prt.SetITem(llNewRow,'ship_to_name',ls_cust_name)
		dw_bol_prt.SetITem(llNewRow,'ship_to_addr1',ls_address_1)
		dw_bol_prt.SetITem(llNewRow,'ship_to_addr2',ls_address_2)
		dw_bol_prt.SetITem(llNewRow,'ship_to_city',ls_shiptocity)
		dw_bol_prt.SetITem(llNewRow,'ship_to_country',ls_shiptocountry)
		dw_bol_prt.SetITem(llNewRow,'ship_to_zip',ls_shiptozip)
	
	//Convert Country Code to Country Name if present
	dw_bol_prt.SetITem(llNewRow,'Carrier_name',ls_Carrier_name)

	
	lsCountryName = f_get_country_name(lsCarrierCountry)
	If lsCountryName > "" Then
		dw_bol_prt.SetITem(llNewRow,'Carrier_Country',lsCountryName)
	Else
		dw_bol_prt.SetITem(llNewRow,'Carrier_Country',lsCarrierCountry)
	End If
				 
			ls_load_cust_warehouse_id = ls_load_id+'-'+lsWarehouse+'-'+lsWarehouse1
		
			dw_bol_prt.SetITem(llNewRow,'load_ware_cust_id', ls_load_cust_warehouse_id)
	
			dw_bol_prt.SetITem(llNewRow,'numcartons', ls_qty)		

	
	
	// Get and set the package type for this line item.
	ls_cartontype = lds_packingrow.getitemstring(llNewRow, "carton_type")
	dw_bol_prt.SetITem(llNewRow,'carton_type', ls_cartontype)
	
	// Set the description to 'Electronics'.
	
	// Get and set the dimensions for this line item.
	ld_length = lds_packingrow.getitemnumber(llNewRow, "length")
	If isnull(ld_length) then ld_length = 0
	dw_bol_prt.SetITem(llNewRow,'length', ld_length)
	ld_width = lds_packingrow.getitemnumber(llNewRow, "width")
	If isnull(ld_width) then ld_width = 0
	dw_bol_prt.SetITem(llNewRow,'width', ld_width)
	ld_height = lds_packingrow.getitemnumber(llNewRow, "height")
	dw_bol_prt.SetITem(llNewRow,'height', ld_height)
	If isnull(ld_height) then ld_height = 0
	
	// Get and set the volume for this line item.
	ld_volm3 = lds_packingrow.getitemnumber(llNewRow, "volume")
	//ld_volm3 = ld_volm3 * .00001638706
	dw_bol_prt.SetITem(llNewRow,'volm3', ld_volm3)
	
	// Get and set the gross weight for this line.
	ld_weight = dec(lds_packingrow.GetITemdecimal(llNewRow,'wtg_aspercrtn'))
	dw_bol_prt.SetITem(llNewRow,'gross_weight', ld_weight)

     if llNewRow <= ll_numrows  then
	llNewRow = dw_bol_prt.InsertRow(0)
end if

Next

//Add any necessary empty rows so sumamry is at bottom of last page
liEmptyRows = 0
If dw_bol_prt.RowCount() < liRowsPerPage Then
	liEmptyRows = liRowsPerPage - dw_bol_prt.RowCount()
ElseIf dw_bol_prt.RowCount() > liRowsPerPage Then
	liMod = Mod(dw_bol_prt.RowCount(), liRowsPerPage)
	If liMod > 0 Then
		liEmptyRows = liRowsPerPage - liMod
	End IF
End If

If liEmptyRows > 0 Then
	For ll_rownum = 1 to liEmptyRows
		dw_bol_prt.InsertRow(0)
	Next
End If

// Set the warehouse city.
//dw_bol_prt.SetITem(llNewRow,'warehouse_city', ls_whsecity)
lsCarrierCountry_city =  lsCarriercity +','+lsCarrierCountry
dw_bol_prt.Modify("t_whsecity.text = '" + lsCarrierCountry_city + "'")
dw_bol_prt.Modify("t_4.text = '" + string(date(ls_esd_date)) + "'")
dw_bol_prt.Modify("lookup_231_t.text = '" + ls_shipvia + "'")

// Set the last user
//TimA 08/16/12 Pandora issue 491..


Select display_name
into :ls_lastuser
from UserTable
Where UserId = :ls_lastuser;

dw_bol_prt.Modify("t_lastuser.text = '" + ls_lastuser + "'")

//Add any necessary empty rows so sumamry is at bottom of last page
liEmptyRows = 0
If dw_bol_prt.RowCount() < liRowsPerPage Then
	liEmptyRows = liRowsPerPage - dw_bol_prt.RowCount()
ElseIf dw_bol_prt.RowCount() > liRowsPerPage Then
	liMod = Mod(dw_bol_prt.RowCount(), liRowsPerPage)
	If liMod > 0 Then
		liEmptyRows = liRowsPerPage - liMod
	End IF
End If

If liEmptyRows > 0 Then
	For ll_rownum = 1 to liEmptyRows
		dw_bol_prt.InsertRow(0)
	Next
End If

string Var1
Var1 = ""
dw_bol_prt.SetFilter("order_no <> '"+ Var1 +" '")

dw_bol_prt.filter()



dw_bol_prt.SetRedraw(True)

string newsort
newsort = "order_no as"
dw_bol_prt.SetSort(newsort)
dw_bol_prt.Sort( )

//Date -11-24-2021----Dhirendra-S63594-Google Change: CMR documen--END 









end event

event ue_cmr_print();//Date -11-24-2021----Dhirendra-S63594-Google Change: CMR documen--Start
//Ancestor overriden
// ET3 2012/06/20: issue 430 - prefix the P; change to user_field16 from user_field15
dec 	ldSeqNo
Boolean	lbNew

//Get the Sequence Number before printing
// 10/07 - PCONKL - If we have already retreived the CMR for this order, re-treive it instead of getting a new one - stored in UF15
If ls_user_field16 > '' Then
	ldSeqNo = dec(ls_user_field16)// Converted ls_user_field16 string to dec for the story S63594 CMR-- Dhirendra
Else
	/* 06/07/10 ujh:  This has been cloned from w_ams_cmr_report,   In general PANDORA
		replaces "AMS" whereever found, as seen below
		The following required making an entry in the next_sequence_no table to support
		the following function call. */
	ldSeqNo =g.of_next_db_seq(gs_project,'PANDORA_CMR_RPT','SEQ_No')
	lbNew = True /* only need to save when new */
End If

If ldSeqNo > 0 Then
	
	// ET3 2012/06/20: issue 430 - prefix the P; change to user_field16 from user_field15
	dw_bol_prt.modify("Seq_no_t.text='" + 'P' + String(ldSeqNo,'#######') + "' datawindow.print.copies =4 ") /*default to 4 copies*/
	
	//  10/07 - PCONKL - We want to save this number in DO for re-prints
	If lbNew Then
		update delivery_master set user_field16= :ls_user_field16 where shipment_id  = :sle_load_id.text using sqlca;
		//w_do.ib_changed = True
	End If
	
	OpenWithParm(w_dw_print_options,dw_bol_prt) 
		
Else
	Messagebox('CMR Report','Unable to retrieve the Report Sequence Number!',StopSign!)
End If
//Date -11-24-2021----Dhirendra-S63594-Google Change: CMR documen--END 

end event

on w_delivery_bol.create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rb_1=create rb_1
this.dw_bol_prt=create dw_bol_prt
this.rb_cbol=create rb_cbol
this.rb_mbol=create rb_mbol
this.st_2=create st_2
this.cb_print=create cb_print
this.cb_generate=create cb_generate
this.sle_load_id=create sle_load_id
this.st_text=create st_text
this.Control[]={this.dw_2,&
this.dw_1,&
this.rb_1,&
this.dw_bol_prt,&
this.rb_cbol,&
this.rb_mbol,&
this.st_2,&
this.cb_print,&
this.cb_generate,&
this.sle_load_id,&
this.st_text}
end on

on w_delivery_bol.destroy
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.dw_bol_prt)
destroy(this.rb_cbol)
destroy(this.rb_mbol)
destroy(this.st_2)
destroy(this.cb_print)
destroy(this.cb_generate)
destroy(this.sle_load_id)
destroy(this.st_text)
end on

event open;iw_window = this
string ls_shipmentid
//Date -11-24-2021----Dhirendra-S63594-Google Change: CMR documen--Start
 IF gs_project ='PANDORA' then
	rb_1.visible = true 
END IF 
//Date -11-24-2021----Dhirendra-S63594-Google Change: CMR documen--END 
idw_do_bol = this.dw_bol_prt
idw_do_bol.settransobject( sqlca)
//Begin - 02/21/2024 - Dinesh - SIMS-378- Google - SIMS – Shuttle Consolidation and BOL Printing (368)
ls_shipmentid= Message.StringParm
sle_load_id.text= ls_shipmentid
//End - 02/21/2024 - Dinesh - SIMS-378- Google - SIMS – Shuttle Consolidation and BOL Printing (368)

end event

event resize;this.dw_bol_prt.Resize(workspacewidth() - 80,workspaceHeight()-360)
end event

type dw_2 from datawindow within w_delivery_bol
boolean visible = false
integer x = 2080
integer y = 236
integer width = 686
integer height = 400
integer taborder = 30
string title = "none"
string dataobject = "d_do_master2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_delivery_bol
boolean visible = false
integer x = 2395
integer y = 88
integer width = 686
integer height = 400
integer taborder = 10
string title = "none"
string dataobject = "d_do_master"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_delivery_bol
boolean visible = false
integer x = 2162
integer y = 156
integer width = 475
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generate CMR"
end type

event clicked;//Date -11-24-2021----Dhirendra-S63594-Google Change: CMR documen--START 
st_text.text ="Shipment Id:"
//Date -11-24-2021----Dhirendra-S63594-Google Change: CMR documen--END
end event

type dw_bol_prt from datawindow within w_delivery_bol
integer x = 32
integer y = 288
integer width = 4224
integer height = 1544
integer taborder = 30
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_cbol from radiobutton within w_delivery_bol
integer x = 1847
integer y = 152
integer width = 297
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "CBOL"
end type

event clicked;st_text.text ="Shipment Id:"
end event

type rb_mbol from radiobutton within w_delivery_bol
integer x = 1563
integer y = 152
integer width = 329
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "MBOL"
boolean checked = true
end type

event clicked;st_text.text ="Load Id:"
end event

type st_2 from statictext within w_delivery_bol
integer x = 827
integer y = 28
integer width = 1449
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217856
long backcolor = 67108864
string text = "BILL OF LADING"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_print from commandbutton within w_delivery_bol
event ue_cmr_print ( )
integer x = 3131
integer y = 136
integer width = 311
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;//IF statment added for cmr doc printing in case of generate cmr checheked checked//Date -11-24-2021----Dhirendra-S63594-Google Change: CMR document-END
IF gs_project ='PANDORA' and rb_1.checked=True then 
	iw_window.TriggerEvent("ue_cmr_print")
else 
	iw_window.TriggerEvent("ue_print_bol")
end if 
//Date -11-24-2021----Dhirendra-S63594-Google Change: CMR document-END
end event

type cb_generate from commandbutton within w_delivery_bol
integer x = 2706
integer y = 136
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;iw_window.TriggerEvent("ue_process_bol")
end event

type sle_load_id from singlelineedit within w_delivery_bol
integer x = 411
integer y = 148
integer width = 1115
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_text from statictext within w_delivery_bol
integer x = 91
integer y = 152
integer width = 293
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Load Id:"
alignment alignment = right!
boolean focusrectangle = false
end type

