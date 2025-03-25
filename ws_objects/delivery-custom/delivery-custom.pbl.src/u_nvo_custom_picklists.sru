$PBExportHeader$u_nvo_custom_picklists.sru
$PBExportComments$Project Specific Pick list logic
forward
global type u_nvo_custom_picklists from nonvisualobject
end type
end forward

global type u_nvo_custom_picklists from nonvisualobject
end type
global u_nvo_custom_picklists u_nvo_custom_picklists

type variables
Datawindow idw_print, idw_pick, idw_other, &
				 idw_detail, idw_main
String is_title
Boolean ib_changed

w_do iw_window
end variables

forward prototypes
public function integer uf_pickprint_warner ()
public function integer uf_pickprint_3com ()
public function integer uf_pickprint_philips ()
public function integer uf_pickprint_runnersworld ()
public function integer uf_pickprint_eut ()
public function integer uf_pickprint_lam ()
public function integer uf_pickprint_pandora ()
public function integer uf_pickprint_pulse ()
public function integer uf_pickprint_franke ()
public function integer uf_picklist_ws_muser ()
public function integer uf_pickprint_babycare ()
public function integer uf_pickprint_nike ()
public function integer uf_pickprint_riverbed ()
public function integer uf_pickprint_kinderdijk ()
end prototypes

public function integer uf_pickprint_warner ();// This event prints the Picking List which is currently visible on the screen 
// and not from the database

// 11/09 - PCONKL - Removed logic for loading temp DW and copying to Print DW. This required all custom Pick Lists to be in sync and wasnt really buying us anything.


Long ll_cnt, i,j, llline_item_no
String lsSUpplier, lsSupplierHold
String ls_project_id , ls_sku , lsSKUHold, ls_description, lsUPC
 
string ls_do_no
 
w_do.tab_main.tabpage_pick.dw_print.dataobject = 'd_picking_prt_warner'	 /* assign custom print DW */
 
ls_do_no = w_do.idw_main.GetItemString(1, "do_no")
 
ll_cnt = w_do.idw_pick.rowcount()
  
w_do.idw_print.Reset()
 
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")

For i = 1 to ll_cnt /*each Pick Row */
 
        w_do.SetMicroHelp('Printing pick list for item ' + String(i) + ' of ' + String(ll_cnt))
        
        ls_sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
		                  
        // 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
        If w_do.idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
        	  
        //08/04 - PCONKL - Don't print Components that are just placeholders for children being picked
        If w_do.idw_pick.getitemstring(i,"Component_ind") = 'Y'  and w_do.idw_pick.getitemstring(i,"component_type") = 'D' and w_do.idw_pick.getitemNumber(i,"Component_No") = 0 and w_do.idw_pick.getitemstring(i,"l_code") = 'N/A' Then Continue
        If w_do.idw_pick.getitemstring(i,"Component_ind") = '*' Then Continue
        
        j = w_do.idw_print.InsertRow(0)
		  
	   	w_do.idw_print.setitem(j,"invoice_no",w_do.idw_main.GetItemString(1,"invoice_no"))
		w_do.idw_print.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
		
		w_do.idw_print.setitem(j,"line_item_no",llline_item_no)
		w_do.idw_print.setitem(j,"sku",ls_sku)
		 w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemString(i,"l_code"))
        w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
                          
        If ls_SKU <> lsSKUHold or lsSupplier <> lsSupplierHold Then
                
                select native_description, part_upc_Code
                into     :ls_description, :lsUPC
                from item_master
                where  item_master.project_id = :ls_project_id and sku = :ls_sku and item_master.supp_code = :lsSupplier;
        
        End If
 
        ls_description = trim(ls_description)
        
        w_do.idw_print.setitem(j,"description",ls_description)
		   w_do.idw_print.setitem(j,"upc_code",lsUPC)
		 
        lsSKUHold = ls_SKU
        lsSupplierHold = lsSupplier
        
Next /*pick Rec*/
 
w_do.idw_pick.Filter()
 
w_do.idw_print.Sort()
w_do.idw_print.GroupCalc()
 
OpenWithParm(w_dw_print_options,w_do.idw_print) 
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
                w_do.idw_main.SetItem(1,"ord_status","I")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If


Return 0
end function

public function integer uf_pickprint_3com ();
 
Long ll_cnt, i, j, llFind, llline_item_no, llDetailFind, llCount, llNotesCount, llNotesPos
String ls_address, lsSUpplier, lsSupplierHold, lsfind, ls_alt_sku, lsNotes
String ls_project_id , ls_sku , lsSKUHold, ls_description, lsCarrier, lsSchedCode, lsSchedDesc
String ls_inventory_type , ls_inventory_type_desc, lsClientName, lsIMUser9,  lsSuppName, lsDONO, lsIMUser13
String lsSaveInvoice, lsSaveCustOrdNo, ls_order_type, ls_order_type_desc
String lsIsHPOrder, lsCustCode
string ls_delivery_note_number
dec{3} ld_weight_1
string lsWH, lsCarPriority //for 3COM Carrier Prioritized Picking routing call
Str_parms       lstrParms
DataStore  ldsInvType,  ldsBOMPrint, ldsContractPrint, ldsOrdType, ldsNotes, ldsExtraPage
datawindowChild ldwc
datastore ldsDeliveryReport
integer li_idx
 
string ls_do_no, ls_pick_list_printed
boolean lb_printed_before
 
//Set the Print DW
w_do.tab_main.tabpage_pick.dw_print.dataobject =  'd_picking_prt_3com'

ls_do_no = w_do.idw_main.GetItemString(1, "do_no")
 
 
// 01/03 - PCONKL - Retrieve Inventory Type descriptions for printed report - only need to do once
ldsInvType = Create Datastore
ldsInvType.DataObject = 'dddw_inventory_Type_by_Project'
ldsInvType.SetTransObject(SQLCA)
ldsInvType.Retrieve(gs_Project)
 
ldsOrdType = Create Datastore
ldsOrdType.DataObject = 'dddw_delivery_order_type'
ldsOrdType.SetTransObject(SQLCA)
ldsOrdType.Retrieve(gs_Project)
  
w_do.idw_print.Reset()
 
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// 08/00 PCONKL Show Client Name on Pick Ticket
Select Client_name into :lsClientName
From    Project
Where project_id = :ls_project_id
Using SQLCA;
 
//For GM_MI_DAT, we want to concatonate Schedule Code (desc) to carrier
lsCarrier = w_do.idw_main.getitemstring(1,"Carrier")
If isnull(LsCarrier) Then lsCarrier = ''
 
// dts - 2/10/06 - make Socket call to LMS for carrier if Carrier Prioritized picking is turned on
 lsWH = w_do.idw_main.getitemstring(1, "wh_code")
select Car_Priority_Pick_Ind
into :lsCarPriority
from warehouse
where wh_code = :lsWH;
        
if lsCarPriority = 'Y' then
	
	//make routing call...  (if uf13 isn't already populated, per requirements)
    //if isnull(w_do.idw_other.GetItemString(1, "user_field13")) or w_do.idw_other.GetItemString(1, "user_field13") = '' then
    lstrParms.String_Arg[1] = "Routing"
    lstrParms.String_Arg[2] = "UF13" //update UF13 (instead of UF8) if making Routing call from here
    lstrParms.String_Arg[3] = w_do.idw_other.GetItemString(1, "user_field14")  //storing Wgt from previous call
    OpenWithParm(w_dssocket, lstrParms)
               
    //now, UF13 may have been populated by socket call to LMS...
    if w_do.idw_other.GetItemString(1, "user_field13") <> '' then
   		lsCarrier = w_do.idw_other.GetItemString(1, "user_field13")
         select carrier_name 
         into :lsCarrier
         from carrier_master
         where project_id = :gs_Project
         and carrier_code = :lsCarrier;
  	end if
	  
 End If
        
//TAM 03/30/2006 Set saved invoice and Cust Order Number to Blank
lsSaveInvoice = ''
lsSaveCustOrdNo = ''
 
ll_cnt = w_do.idw_pick.rowcount()
For i = 1 to ll_cnt /*each Pick Row */
 
        w_do.SetMicroHelp('Printing pick list for item ' + String(i) + ' of ' + String(ll_cnt))
        
        ls_sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
        
        ls_inventory_type = w_do.idw_pick.getitemstring(i,"inventory_type")
 
        // 01/03 - PCONKL - Load from datastore instead of retriveing every time (move row function doesn't load DDDW)
        llFind = ldsInvType.Find("Inv_Type = '" + ls_inventory_type + "'",1,ldsInvType.RowCount())
        If llFind > 0 Then
                ls_inventory_type_desc = ldsInvType.GetITemString(llFind,'inv_type_desc')
        Else
                ls_inventory_type_desc = ls_inventory_type
        End If
        
        ls_order_type = w_do.idw_main.getitemstring(1,"ord_type")
        
 
        llFind = ldsOrdType.Find("ord_type = '" + ls_order_type + "'",1,ldsOrdType.RowCount())
        If llFind > 0 Then
                ls_order_type_desc = ldsOrdType.GetITemString(llFind,'ord_type_desc')
        Else
                ls_order_type_desc = ls_order_type
        End If  
                
        
        
        // 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
        If w_do.idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
        
        //08/04 - PCONKL - Don't print Components that are just placeholders for children being picked
        If w_do.idw_pick.getitemstring(i,"Component_ind") = 'Y'  and w_do.idw_pick.getitemstring(i,"component_type") = 'D' and w_do.idw_pick.getitemNumber(i,"Component_No") = 0 and w_do.idw_pick.getitemstring(i,"l_code") = 'N/A' Then Continue
        If w_do.idw_pick.getitemstring(i,"Component_ind") = '*' Then Continue
        
        //12/05 - PCONKL - for 3COM, We will rollup pick rows to sku, supplier, lot, location and Inv Type and Order Number (3com has order number at the line level)
    
                
        lsFind = "upper(sku) = '" + Upper(ls_sku) + "' and upper(supp_code) = '" + Upper(lsSupplier) + "'"
        lsFind += " and Upper(lot_no) = '" + Upper(w_do.idw_pick.getitemstring(i,"lot_no")) + "'"
        lsFind += " and Upper(l_code) = '" + Upper(w_do.idw_pick.getitemstring(i,"l_code")) + "'"
        lsFind += " and Upper(inventory_type) = '" + Upper(ls_inventory_type_desc) + "'"
        lsFind += " and component_no = " + string(w_do.idw_pick.getitemNumber(i,"Component_no"))
                
        // pvh - 01/11/06
        //We need the Order Number from Detail user Field 4
        If w_do.idw_main.getitemstring(1,"wh_code") <> "3COM-NL" Then
        		llDetailfind = w_do.idw_detail.Find("line_item_no = " + string(llLine_Item_No),1,w_do.idw_detail.RowCount())
              If lLDetailFind > 0 Then
                       lsFind += " and Upper(Invoice_No) = '" + Upper(w_do.idw_detail.GetItemString(llDetailFind,'User_Field4')) + "'"
              End If
 		End If
                //We need the Order Number from Detail user Field 4
//              llDetailfind = w_do.idw_detail.Find("line_item_no = " + string(llLine_Item_No),1,w_do.idw_detail.RowCount())
//              If lLDetailFind > 0 Then
//                      lsFind += " and Upper(Invoice_No) = '" + Upper(w_do.idw_detail.GetItemString(llDetailFind,'User_Field4')) + "'"
//              End If
                
        llFind = w_do.idw_print.Find(lsFind,1,w_do.idw_print.RowCount())
        If llFind > 0 Then
                        
                     j = llFind
                      w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity") + w_do.idw_print.GetItemNumber(llFind,'Quantity'))
                      continue
                        
        Else /* new row */
                        
                    j = w_do.idw_print.InsertRow(0)
                    w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
                      
        End If
               
        w_do.idw_print.setitem(j,"project_id",gs_project) /* 07/02 - Pconkl - some fields may be visible or invisible based on project*/
        w_do.idw_print.setitem(j,"client_name",lsClientName) /* 08/00 PCONKL -show project name instead of code (customer sees the pick ticket)*/
        w_do.idw_print.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        w_do.idw_print.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code"))
        w_do.idw_print.setitem(j,"carrier",lscarrier) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"Priority",String(w_do.idw_main.getitemNumber(1,"Priority"),'####')) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"dm_user_field1",w_do.idw_main.getitemstring(1,"user_field1")) /* 09/03 - PCONKL - 3COM Freight Terms Code */
        w_do.idw_print.setitem(j,"dm_user_field2",w_do.idw_main.getitemstring(1,"user_field2")) /* 09/03 - PCONKL - 3COM Cust Sold TO ID */
        w_do.idw_print.setitem(j,"dm_user_field6",w_do.idw_main.getitemstring(1,"user_field6")) /* 08/04 - PCONKL - 3COM Delivery Note */
        w_do.idw_print.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        w_do.idw_print.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        w_do.idw_print.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        w_do.idw_print.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        w_do.idw_print.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
        w_do.idw_print.setitem(j,"state",w_do.idw_main.getitemstring(1,"state"))
        w_do.idw_print.setitem(j,"zip_code",w_do.idw_main.getitemstring(1,"zip"))
        w_do.idw_print.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
        w_do.idw_print.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
  		  w_do.idw_print.setitem(j,"request_date",w_do.idw_main.getitemdatetime(1,"request_date"))
        w_do.idw_print.setitem(j,"wh_code",w_do.idw_main.getitemstring(1,"wh_code"))
        w_do.idw_print.setitem(j,"sku",w_do.idw_pick.getitemstring(i,"sku"))
        w_do.idw_print.setitem(j,"sku_parent",w_do.idw_pick.getitemstring(i,"sku_Parent"))
        w_do.idw_print.setitem(j,"supp_code",w_do.idw_pick.getitemstring(i,"supp_code"))
        w_do.idw_print.setitem(j,"serial_no",w_do.idw_pick.getitemstring(i,"serial_no"))
        w_do.idw_print.setitem(j,"lot_no",w_do.idw_pick.getitemstring(i,"lot_no"))
        w_do.idw_print.setitem(j,"po_no",w_do.idw_pick.getitemstring(i,"po_no"))
        w_do.idw_print.setitem(j,"po_no2",w_do.idw_pick.getitemstring(i,"po_no2")) /* 01/02 PCONKL */
        w_do.idw_print.setitem(j,"container_ID",w_do.idw_pick.getitemstring(i,"container_ID")) /* 11/02 PCONKL */
        w_do.idw_print.setitem(j,"expiration_Date",w_do.idw_pick.getitemDateTime(i,"expiration_Date")) /* 11/02 PCONKL */
        
        //MA 02/08 - Added ord_type to picking list for 3com
        
        w_do.idw_print.setitem(j,"ord_type_desc", ls_order_type_desc)         
        
        // 11/06 - PCONKL - If Component parent placeholder, print "* NO PICK *" instead of "N/A"
        If w_do.idw_pick.getitemstring(i,"Component_Ind") = "Y" and w_do.idw_pick.getitemstring(i,"l_code") = "N/A" Then
                w_do.idw_print.setitem(j,"l_code","* NO PICK *")
        Else
                w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemstring(i,"l_code"))
        End If
        
        w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemdecimal(i,"picking_seq"))
               
        //12/05 - PCONKL - quantity now set above - we may be rolling up rows
        //w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        
        w_do.idw_print.setitem(j,"component_no",w_do.idw_pick.getitemnumber(i,"component_no"))
        w_do.idw_print.setitem(j,"component_ind",w_do.idw_pick.getitemstring(i,"Component_Ind")) /* 08/04 - PCONKL */
        w_do.idw_print.setitem(j,"pick_as",w_do.idw_pick.getitemstring(i,"user_field2")) /* 11/00 PCONKL - show pick iterations*/
        w_do.idw_print.setitem(j,"ship_ref_nbr",w_do.idw_other.getitemstring(1,"ship_ref"))
        w_do.idw_print.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
               
        /* 07/02 - Pconkl - User Field 9 is commodity code for Saltillo - shown on printed Pick LIst (Visible property for fields on Print)*/
        // 01/03 - PCONKL - Only retrieve when SKU has changed
        // 04/04 - TAMCCLANAHAN - Add retrieve when Supplier has changed
        // 12/06 - PCONKL - Added join to supplier for Supplier Name - commented out seperate SQL below
        If ls_SKU <> lsSKUHold or lsSupplier <> lsSupplierHold Then
                
                select description, user_field9, weight_1, user_field13, supp_name
                into     :ls_description , :lsIMUser9, :ld_weight_1, :lsIMUser13, :lsSuppname  //TAM 2006/06/26 added UF13 
                from item_master, Supplier 
                where item_master.Project_id = Supplier.Project_id and Item_master.Supp_Code = Supplier.Supp_Code and
                                item_master.project_id = :ls_project_id and sku = :ls_sku and item_master.supp_code = :lsSupplier;
        
        End If
 
        ls_description = trim(ls_description)
                
        w_do.idw_print.setitem(j,"weight_1",ld_weight_1) /*09/02 - gap */
        w_do.idw_print.setitem(j,"description",ls_description)
        w_do.idw_print.setitem(j,"im_user_field9",lsimUser9) /*07/02 - Pconkl */
        
        w_do.idw_print.setitem(j,"im_user_field13",lsimUser13)  // TAM - 2006/06/26 Added UF13 
        w_do.idw_print.setitem(j,"supplier_name",lsSuppName)
        w_do.idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
        
        // 01/05 - PCONKL - for 3COM, the Order and Cust Order Numbers should be at the Line Level instead of header
                 
        //Get from Detail Rec
        //lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        lsFind = "line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
        if llfind > 0 Then
                        
                        If w_do.idw_detail.GetItemString(llFind,'User_Field4') > '' Then
                                w_do.idw_print.setitem(j,"invoice_no",w_do.idw_detail.GetItemString(llFind,'User_Field4'))
                        Else
                                w_do.idw_print.setitem(j,"invoice_no",w_do.is_bolno)
                        End If
                        
                        If w_do.idw_detail.GetItemString(llFind,'User_Field5') > '' Then
                                w_do.idw_print.setitem(j,"cust_ord_no",w_do.idw_detail.GetItemString(llFind,'User_Field5'))
                        Else
                                w_do.idw_print.SetITem(j,"cust_ord_no",w_do.idw_main.GetItemString(1,"cust_order_no")) 
                        End If
                        
      else
                        
                        w_do.idw_print.setitem(j,"invoice_no",w_do.is_bolno)
                        w_do.idw_print.SetItem(j,"cust_ord_no",w_do.idw_main.GetItemString(1,"cust_order_no")) 
                        
      end if
                
      w_do.idw_print.setitem(j,"bol_no",w_do.idw_main.GetItemString(1,'invoice_no'))
 
      // TAM 2006/31/01 We Need to see if the Order Number or Cust Order Number changes.  
      //      If it Does we write various on the pick list
        
       If lsSaveCustOrdNo = '' or lsSaveCUstOrdNo = w_do.idw_print.GetItemString(j,'cust_ord_no') then
                lsSaveCustOrdNo = w_do.idw_print.GetItemString(j,'cust_ord_no')
       Else
                 lsSaveCustOrdNo = "VARIOUS" // only if it changes
       End If
                        
       If lsSaveInvoice = '' or lsSaveInvoice = w_do.idw_print.GetItemString(j,'invoice_no') then
                 lsSaveInvoice = w_do.idw_print.GetItemString(j,'invoice_no')
       Else
                 lsSaveInvoice = "VARIOUS"       // only if it changes
       End If
                        
       // 09/07 - PCONKL - For GLS Warehouses, we want to print the Turnaround time from DD UF7, loading it into IM UF9 since only used by GMM and don't want to modify all the other Print DW's by adding a new column
       If Upper(Left(w_do.idw_Main.GetITemString(1,'wh_Code'),5)) = '3CGLS' and llFind > 0 Then
               w_do.idw_print.setitem(j,"im_user_field9",w_do.idw_detail.GetItemString(llFind,'User_Field7'))
       End If
                
      
     //   End If
        
//TAM 12/13/04 load alt sku from order detail
        
        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
        if llfind > 0 Then
                ls_alt_sku = w_do.idw_detail.getitemString(llFind,"alternate_sku")
        else
                ls_alt_sku = ''
        end if
 
        if ls_alt_sku <> ls_sku Then
                w_do.idw_print.setitem(j,"alt_sku",ls_alt_sku)
        else
                w_do.idw_print.setitem(j,"alt_sku",'')
        end if
        
        w_do.idw_print.setitem(j,"Shipping_Instructions",w_do.idw_main.getitemstring(1,"Shipping_Instructions")) /* 11/03 - PCONKL */
              
        lsSKUHold = ls_SKU
        lsSupplierHold = lsSupplier
        
Next /*pick Rec*/
 
 
// Loop Back through the print rows an update the Ivoice and Cust Order Number

   ll_cnt = w_do.idw_print.rowcount()
    For i = 1 to ll_cnt /*each Print Row */
            w_do.idw_print.setitem(i,"invoice_no",lsSaveInvoice)
            w_do.idw_print.setitem(i,"cust_ord_no",lsSaveCustOrdNo)
    Next    

// 02/01 PCONKL - Filter Pick list to not show components if box is not checked
If w_do.tab_main.tabpage_pick.cbx_show_comp.Checked Then
        w_do.idw_print.SetFilter('')
Else
        w_do.idw_print.SetFilter('sku=sku_parent')   
End If
 
w_do.idw_pick.Filter()
 
w_do.idw_print.Sort()
w_do.idw_print.GroupCalc()
 
OpenWithParm(w_dw_print_options,w_do.idw_print) 
 
 
if NOT lb_printed_before and message.doubleparm <> -1 then
 
//      UPDATE Delivery_Master SET Pick_List_Printed = 'Y'
//              WHERE do_no = :ls_do_no USING SQLCA;
                        
end if
 
 
  //HP Extra Page - MEA - 04/10
 
 If Upper(gs_project) = '3COM_NASH' THEN 
	
		lsCustCode = w_do.idw_main.getitemstring(1,"cust_code")


       Select User_Field3 into :lsIsHPOrder
		From    Customer
		Where Cust_Code = :lsCustCode AND project_id = '3COM_NASH'  
		Using SQLCA;

  
  	   If upper(left(lsIsHPOrder,1)) = 'Y' then
  
			 ldsExtraPage = Create Datastore
			 ldsExtraPage.dataobject = 'd_picking_prt_3com_extrapage_hp'
			
			ldsExtraPage.Reset()
			
			ldsExtraPage.InsertRow(0)
					
				
			ls_delivery_note_number = 	w_do.idw_main.getitemstring(1,"user_field6")
			
			If IsNull(ls_delivery_note_number) THEN ls_delivery_note_number = ''
				
			  ldsExtraPage.setitem(1,"delivery_note_number", ls_delivery_note_number) /*  3COM Delivery Note */
			 
			if w_do.idw_print.RowCount() > 0 then
			
				ldsExtraPage.setitem(1,"order_number", w_do.idw_print.GetItemString(1, "bol_no")) /*  3COM Delivery Note */
	
			end if
	 
//	 			MessageBox ("ok", ldsExtraPage.RowCount())
	 
			 ldsExtraPage.Print()
			 
			 Destroy ldsExtraPage;
			
		End If	
 
End If /* HP Extra Page 04/10*/
 
 
// 08/04 - PCONKL - If any Components were blown out to children on Pick List, print BOM Report
If w_do.idw_Pick.Find("Component_Ind = 'W'",1,w_do.idw_Pick.RowCount()) > 0 Then
        
        If Messagebox(w_do.is_title, 'Do you want to print the "Pick list Bill of Materials Report"?',Question!,YesNo!,1) = 1 Then
                ldsBomPrint = Create DataStore
                ldsBomPrint.DataObject = 'd_do_bom_report'
                ldsBomPrint.SetTransObject(sqlca)
                lsDONO = w_do.idw_main.GetITemString(1,'do_no')
                If      ldsBomPrint.Retrieve(lsDONO) > 0 Then
                        ldsBomPrint.Print()
                End If
        End If
        
End If
 
//08/07 - PCONKL - 3COM RMA warehouses need a placeholder to print for Contract kits if any of the items are contract
If Upper(gs_project) = '3COM_NASH' and upper(Left(w_do.idw_main.GetITemString(1,'wh_code'),5)) = '3CGLS' then
        
        If w_do.idw_Detail.Find("Upper(Left(user_field6,2)) = 'Z3' or Upper(Left(user_field6,2)) = 'Z4'",1,w_do.idw_Detail.RowCount()) > 0 Then /* COntract */
        
                ldsContractPrint = Create Datastore
                ldsContractPrint.dataobject = 'd_3com_rma_contract_Notice'
                ldsContractPrint.Modify("order_number_t.Text = '" + w_do.idw_main.GetItemString(1,"invoice_no") + "'")
                ldsContractPrint.Modify("delivery_note_t.Text = '" + w_do.idw_main.GetItemString(1,"User_Field6") + "'")
                ldsContractPrint.Print()
        
        End If
 
End If /* 3COM RMA*/
  
 
 
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
                w_do.idw_main.SetItem(1,"ord_status","I")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If

REturn 0
end function

public function integer uf_pickprint_philips ();// This event prints the Picking List which is currently visible on the screen 
// and not from the database

// 11/09 - PCONKL - Removed logic for loading temp DW and copying to Print DW. This required all custom Pick Lists to be in sync and wasnt really buying us anything.
 
Long ll_cnt, i, j, llFind, llline_item_no, llDetailFind, llCount, llNotesCount, llNotesPos
String ls_address, lsSUpplier, lsSupplierHold, lsfind, ls_alt_sku, lsNotes
String ls_project_id , ls_sku , lsSKUHold, ls_description, lsCarrier, lsSchedCode, lsSchedDesc
String ls_inventory_type , ls_inventory_type_desc, lsClientName, lsIMUser9,  lsSuppName, lsDONO, lsIMUser13
String lsSaveInvoice, lsSaveCustOrdNo, ls_order_type, ls_order_type_desc
dec{3} ld_weight_1
string lsWH, lsCarPriority //for 3COM Carrier Prioritized Picking routing call
Str_parms       lstrParms
DataStore  ldsInvType,  ldsBOMPrint, ldsContractPrint, ldsOrdType, ldsNotes, ldsBT
datawindowChild ldwc
datastore ldsDeliveryReport
integer li_idx
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText
integer liNotePos
Long ll_Line_Item_No, llDetailFindRow
String		ls_hazard_cd, ls_hazard_class, lsDetailUF5
String lsPlantCode, lsUltConsigneeCode		//S35929
 
string ls_do_no, ls_pick_list_printed
boolean lb_printed_before
 
IF  gs_project = 'PHILIPS-TH' then
	
	 w_do.tab_main.tabpage_pick.dw_print.dataobject = 'd_picking_prt_philips_th'	 /*Assign custom Print DW */

	
ELSE
	
 	w_do.tab_main.tabpage_pick.dw_print.dataobject = 'd_picking_prt_philips'	 /*Assign custom Print DW */

END IF

ls_do_no = w_do.idw_main.GetItemString(1, "do_no")

//GailM 7/25/2019 - S35929 F17329 PhilipsCLS Picking List - MY01 only
lsPlantCode  = w_do.idw_main.GetItemString(1, "user_field3")		
lsUltConsigneeCode = w_do.idw_main.GetItemString(1, "user_field19")
//Bill To 
ldsBT = Create Datastore
ldsBT.DataObject = "d_do_address_alt"
ldsBT.SetTransObject(SQLCA)

llCount = ldsBT.Retrieve(ls_do_no, 'BT')


//Notes
ldsNotes = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select Note_seq_No, Note_Text, Line_Item_No from Delivery_Notes Where do_no = '" + ls_do_no + "'"
dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsNotes.Create( dwsyntax_str, lsErrText)
ldsNotes.SetTransObject(SQLCA)

ldsNotes.Retrieve()

ldsNotes.SetSort("Line_Item_No A, Note_Seq_No A")
ldsNotes.Sort() 
 
 
// 01/03 - PCONKL - Retrieve Inventory Type descriptions for printed report - only need to do once
ldsInvType = Create Datastore
ldsInvType.DataObject = 'dddw_inventory_Type_by_Project'
ldsInvType.SetTransObject(SQLCA)
ldsInvType.Retrieve(gs_Project)
 
ldsOrdType = Create Datastore
ldsOrdType.DataObject = 'dddw_delivery_order_type'
ldsOrdType.SetTransObject(SQLCA)
ldsOrdType.Retrieve(gs_Project)
 
 
 
w_do.idw_print.Reset()
 
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// 08/00 PCONKL Show Client Name on Pick Ticket
Select Client_name into :lsClientName
From    Project
Where project_id = :ls_project_id
Using SQLCA;
 
//For GM_MI_DAT, we want to concatonate Schedule Code (desc) to carrier
lsCarrier = w_do.idw_main.getitemstring(1,"Carrier")
If isnull(LsCarrier) Then lsCarrier = ''
 


 
// 05/09 - PCONKL - For Philips, we want to show Delivery Notes
    
w_do.idw_print.Modify("delivery_notes_t.text = ''")

// 11/14 - PCONKL - For TH, if mobbile enabled, show text on bottom
IF  gs_project = 'PHILIPS-TH' and w_do.idw_Main.GetITemString(1,'mobile_enabled_ind') = 'Y'  then
	w_do.idw_print.Modify("picked_by_mobile_t.visible=true")
Else
	w_do.idw_print.Modify("picked_by_mobile_t.visible=false")
End If
        
ldsNotes = Create DataStore
ldsNotes.dataobject = 'd_dono_notes'
ldsNotes.SetTransObject(SQLCA)
        
lsDONO = w_do.idw_Main.GetItemString(1,'do_no')
lsNotes = ""
                
llNotesCount = ldsNotes.Retrieve(gs_project,lsDONO)
For llNotesPos = 1 to llNotesCount
                        
	//Only want header notes
     If ldsNotes.GetItemNumber(llNotesPos,'line_item_No') = 0 Then
              lsNotes += ldsNotes.GetITemString(llNotesPos,'note_text') + " "
      End If
                                
 Next
        
 If lsNotes > '' Then
           w_do.idw_print.Modify("delivery_notes_t.text = '" + lsNotes + "'")
 End If
        
        
//TAM 03/30/2006 Set saved invoice and Cust Order Number to Blank
lsSaveInvoice = ''
lsSaveCustOrdNo = ''
 
ll_cnt = w_do.idw_pick.rowcount()
For i = 1 to ll_cnt /*each Pick Row */
 
        w_do.SetMicroHelp('Printing pick list for item ' + String(i) + ' of ' + String(ll_cnt))
        
        ls_sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
        ls_inventory_type = w_do.idw_pick.getitemstring(i,"inventory_type")
 
 		//23-APR-2019 :Madhu S32603  Philips BlueHeart Don't Include NONPIC on Pick List - START
		//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
		 IF upper(gs_project) ='PHILIPSCLS' OR upper(gs_project) ='PHILIPS-DA' THEN
			 llDetailFindRow = w_do.idw_detail.find( "sku ='"+ls_sku+"' and line_item_no ="+string(llline_item_no), 1, w_do.idw_detail.rowcount())
			 lsDetailUF5 = w_do.idw_detail.getItemString( llDetailFindRow, 'User_Field5')
			 IF lsDetailUF5 ='NONPIC' THEN Continue
		END IF
 		//23-APR-2019 :Madhu S32603  Philips BlueHeart Don't Include NONPIC on Pick List - END
		 
        // 01/03 - PCONKL - Load from datastore instead of retriveing every time (move row function doesn't load DDDW)
        llFind = ldsInvType.Find("Inv_Type = '" + ls_inventory_type + "'",1,ldsInvType.RowCount())
        If llFind > 0 Then
                ls_inventory_type_desc = ldsInvType.GetITemString(llFind,'inv_type_desc')
        Else
                ls_inventory_type_desc = ls_inventory_type
        End If
        
        ls_order_type = w_do.idw_main.getitemstring(1,"ord_type")
        
 
        llFind = ldsOrdType.Find("ord_type = '" + ls_order_type + "'",1,ldsOrdType.RowCount())
        If llFind > 0 Then
                ls_order_type_desc = ldsOrdType.GetITemString(llFind,'ord_type_desc')
        Else
                ls_order_type_desc = ls_order_type
        End If  
                
		//Line Notes (up to 4 rows - into a single line of text) 
		
		 ll_Line_Item_No = w_do.idw_pick.getitemnumber(i,"line_item_no")
        
		
		liNotePos = 0
		lsNoteText = ""
		llFind = ldsNotes.Find("Line_Item_No = " + string(ll_Line_Item_No),1,ldsNotes.RowCount()) 
		Do While llFind > 0
			
			liNotePos ++
			if not(trim(ldsNotes.GetITemString(llFind,"note_Text")) = '' or isnull(ldsNotes.GetITemString(llFind,"note_Text"))) then
								
				lsNoteText += ldsNotes.GetITemString(llFind,"note_Text") +  char(10)
			
			end if
			
			llFind ++
			If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
				llFind = 0
			Else
				llFind = ldsNotes.Find("Line_Item_No = " + string(ll_Line_Item_No),llFind,ldsNotes.RowCount())
			End If
			
		Loop
		
		
		  
        
        // 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
        If w_do.idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
        
        //08/04 - PCONKL - Don't print Components that are just placeholders for children being picked
       If w_do.idw_pick.getitemstring(i,"Component_ind") = 'Y'  and w_do.idw_pick.getitemstring(i,"component_type") = 'D' and w_do.idw_pick.getitemNumber(i,"Component_No") = 0 and w_do.idw_pick.getitemstring(i,"l_code") = 'N/A' Then Continue
       If w_do.idw_pick.getitemstring(i,"Component_ind") = '*' Then Continue
                    
       j = w_do.idw_print.InsertRow(0)
	  w_do.idw_print.SetItem(j,"Line_Remarks",lsNoteText)
       w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
       w_do.idw_print.setitem(j,"project_id",gs_project) /* 07/02 - Pconkl - some fields may be visible or invisible based on project*/
        w_do.idw_print.setitem(j,"client_name",lsClientName) /* 08/00 PCONKL -show project name instead of code (customer sees the pick ticket)*/
        w_do.idw_print.setitem(j,"carrier",lscarrier) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"Priority",String(w_do.idw_main.getitemNumber(1,"Priority"),'####')) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"dm_user_field1",w_do.idw_main.getitemstring(1,"user_field1")) /* 09/03 - PCONKL - 3COM Freight Terms Code */
        w_do.idw_print.setitem(j,"dm_user_field2",w_do.idw_main.getitemstring(1,"user_field2")) /* 09/03 - PCONKL - 3COM Cust Sold TO ID */
        w_do.idw_print.setitem(j,"dm_user_field6",w_do.idw_main.getitemstring(1,"user_field6")) /* 08/04 - PCONKL - 3COM Delivery Note */
		  
	//GailM 7/25/2019 - S35929 F17329 PhilipsCLS Picking List - MY01 only

			// With the change in S37372, The ShipTo name and address will be the same as non-MY01.
			// The lsConsigneeCode will be posted in place of the Cust Order Nbr and BillTo Name will be placed at Ship Ref Nbr: 
			//        w_do.idw_print.setitem(j,"cust_name",ldsBT.getitemstring(1,"name"))
			//        w_do.idw_print.setitem(j,"cust_code",lsUltConsigneeCode)
			//        w_do.idw_print.setitem(j,"delivery_address1",ldsBT.getitemstring(1,"address_1"))
			//        w_do.idw_print.setitem(j,"delivery_address2",ldsBT.getitemstring(1,"address_2"))
			//        w_do.idw_print.setitem(j,"delivery_address3",ldsBT.getitemstring(1,"address_3"))
			//        w_do.idw_print.setitem(j,"delivery_address4",ldsBT.getitemstring(1,"address_4"))
			//        w_do.idw_print.setitem(j,"city",ldsBT.getitemstring(1,"city"))
			//        w_do.idw_print.setitem(j,"state",ldsBT.getitemstring(1,"state"))
			//        w_do.idw_print.setitem(j,"zip_code",ldsBT.getitemstring(1,"zip"))
			//        w_do.idw_print.setitem(j,"country",ldsBT.getitemstring(1,"country"))

        w_do.idw_print.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        w_do.idw_print.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code"))
        w_do.idw_print.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        w_do.idw_print.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        w_do.idw_print.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        w_do.idw_print.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        w_do.idw_print.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
        w_do.idw_print.setitem(j,"state",w_do.idw_main.getitemstring(1,"state"))
        w_do.idw_print.setitem(j,"zip_code",w_do.idw_main.getitemstring(1,"zip"))
        w_do.idw_print.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))

        w_do.idw_print.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
		  
        //OCT 2019 - MikeA F18464 S38759 Philips Blueheart - SIMS changes for Outbound Order  
	   //Chage the Ship Date to use User Field20 (planned delivery)
		
	   string ls_user_field20
	  
	  ls_user_field20 = w_do.idw_other.getitemstring(1,"user_field20")
	  
	  //MikeA - JAN-2020 - DE14149 	  
	  //Removed Upper(gs_Project) ='PHILIPS-SG' OR
	  //GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
	  IF  Upper(gs_Project) ='PHILIPSCLS' OR Upper(gs_Project) ='PHILIPS-DA' Then
	  	  w_do.idw_print.setitem(j,"request_date", datetime(date(left(ls_user_field20,4)+"/"+mid(ls_user_field20,5,2)+"/"+mid(ls_user_field20,7)),time("00:00:00")))
	  Else
		  w_do.idw_print.setitem(j,"request_date",w_do.idw_main.getitemdatetime(1,"request_date"))		
	  End If
	
	
        w_do.idw_print.setitem(j,"wh_code",w_do.idw_main.getitemstring(1,"wh_code"))
        w_do.idw_print.setitem(j,"sku",w_do.idw_pick.getitemstring(i,"sku"))
        w_do.idw_print.setitem(j,"sku_parent",w_do.idw_pick.getitemstring(i,"sku_Parent"))
        w_do.idw_print.setitem(j,"supp_code",w_do.idw_pick.getitemstring(i,"supp_code"))
        w_do.idw_print.setitem(j,"serial_no",w_do.idw_pick.getitemstring(i,"serial_no"))
        w_do.idw_print.setitem(j,"lot_no",w_do.idw_pick.getitemstring(i,"lot_no"))
        w_do.idw_print.setitem(j,"po_no",w_do.idw_pick.getitemstring(i,"po_no"))
        w_do.idw_print.setitem(j,"po_no2",w_do.idw_pick.getitemstring(i,"po_no2")) /* 01/02 PCONKL */
        w_do.idw_print.setitem(j,"container_ID",w_do.idw_pick.getitemstring(i,"container_ID")) /* 11/02 PCONKL */
        w_do.idw_print.setitem(j,"expiration_Date",w_do.idw_pick.getitemDateTime(i,"expiration_Date")) /* 11/02 PCONKL */
        
        //MA 02/08 - Added ord_type to picking list for 3com
        
        w_do.idw_print.setitem(j,"ord_type_desc", ls_order_type_desc)         
        
        // 11/06 - PCONKL - If Component parent placeholder, print "* NO PICK *" instead of "N/A"
        If w_do.idw_pick.getitemstring(i,"Component_Ind") = "Y" and w_do.idw_pick.getitemstring(i,"l_code") = "N/A" Then
                w_do.idw_print.setitem(j,"l_code","* NO PICK *")
        Else
                w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemstring(i,"l_code"))
        End If
        
        // 11/08 - For Diebold CO133 (Slob), we want to sort by Line ITem. Since it it is not already on the printed report, store in picking_seq field.
        If gs_Project = 'DB-CO133' Then
                w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemNumber(i,"Line_Item_No"))
        Else
                w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemdecimal(i,"picking_seq"))
        End If
        
        //12/05 - PCONKL - quantity now set above - we may be rolling up rows
        //w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        
        w_do.idw_print.setitem(j,"component_no",w_do.idw_pick.getitemnumber(i,"component_no"))
        w_do.idw_print.setitem(j,"component_ind",w_do.idw_pick.getitemstring(i,"Component_Ind")) /* 08/04 - PCONKL */
        w_do.idw_print.setitem(j,"pick_as",w_do.idw_pick.getitemstring(i,"user_field2")) /* 11/00 PCONKL - show pick iterations*/
        w_do.idw_print.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
        w_do.idw_print.setitem(j,"cust_ord_no",w_do.idw_main.GetItemString(1,"cust_order_no")) /* 08/00 PCONKL */
		  
	//GailM 9/4/2019 S37372/F17992/I2552 Philips MY01 Picking List Ultimate Consignee
	If lsPlantCode = "MY01" and not isNull(lsUltConsigneeCode) and lsUltConsigneeCode <> "" and llCount > 0 Then
     	w_do.idw_print.setitem(j,"ship_ref_nbr", ldsBT.getitemstring(1,"name"))
	Else
     	w_do.idw_print.setitem(j,"ship_ref_nbr",w_do.idw_other.getitemstring(1,"ship_ref"))
	End If
               
        /* 07/02 - Pconkl - User Field 9 is commodity code for Saltillo - shown on printed Pick LIst (Visible property for fields on Print)*/
        // 01/03 - PCONKL - Only retrieve when SKU has changed
        // 04/04 - TAMCCLANAHAN - Add retrieve when Supplier has changed
        // 12/06 - PCONKL - Added join to supplier for Supplier Name - commented out seperate SQL below
        If ls_SKU <> lsSKUHold or lsSupplier <> lsSupplierHold Then
                
                select description, user_field9, weight_1, user_field13, supp_name, Hazard_Cd, Hazard_Class
                into     :ls_description , :lsIMUser9, :ld_weight_1, :lsIMUser13, :lsSuppname,  //TAM 2006/06/26 added UF13 
					 :ls_hazard_cd, :ls_hazard_class		//cawikholm - 06/20/11 Added hazard class and code
                from item_master, Supplier 
                where item_master.Project_id = Supplier.Project_id and Item_master.Supp_Code = Supplier.Supp_Code and
                                item_master.project_id = :ls_project_id and sku = :ls_sku and item_master.supp_code = :lsSupplier;
        
        End If
 
	   IF lsSupplier = 'SG03' THEN
			
			w_do.idw_print.setitem(j,"hazard_cd",ls_hazard_cd)		// 04/27/11	cawikholm
			w_do.idw_print.setitem(j,"hazard_class",ls_hazard_class)		// 04/27/11	cawikholm
 
	   END IF
 
        ls_description = trim(ls_description)
                
        w_do.idw_print.setitem(j,"weight_1",ld_weight_1) /*09/02 - gap */
        w_do.idw_print.setitem(j,"description",ls_description)
        w_do.idw_print.setitem(j,"im_user_field9",lsimUser9) /*07/02 - Pconkl */
        
        w_do.idw_print.setitem(j,"im_user_field13",lsimUser13)  // TAM - 2006/06/26 Added UF13 
        w_do.idw_print.setitem(j,"supplier_name",lsSuppName)
        w_do.idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
      
		//w_do.idw_print.setitem(j,"invoice_no",is_bolno)
         w_do.idw_print.setitem(j,"invoice_no",w_do.idw_main.GetItemString(1,"invoice_no"))
 
 	//TAM 12/13/04 load alt sku from order detail
        
        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
        if llfind > 0 Then
                ls_alt_sku = w_do.idw_detail.getitemString(llFind,"alternate_sku")
        else
                ls_alt_sku = ''
        end if
 
        if ls_alt_sku <> ls_sku Then
                w_do.idw_print.setitem(j,"alt_sku",ls_alt_sku)
        else
                w_do.idw_print.setitem(j,"alt_sku",'')
        end if
      
 
        w_do.idw_print.setitem(j,"Shipping_Instructions",w_do.idw_main.getitemstring(1,"Shipping_Instructions")) /* 11/03 - PCONKL */
           
        lsSKUHold = ls_SKU
        lsSupplierHold = lsSupplier
        
Next /*pick Rec*/

// 02/01 PCONKL - Filter Pick list to not show components if box is not checked
If w_do.tab_main.tabpage_pick.cbx_show_comp.Checked Then
        w_do.idw_print.SetFilter('')
Else
        w_do.idw_print.SetFilter('sku=sku_parent')   
End If
 
w_do.idw_pick.Filter()
 
w_do.idw_print.Sort()
w_do.idw_print.GroupCalc()
 
// 01/08 - PCONKL - show reprint on picklist if already printed
long	llPrintCount
lsDONO = w_do.idw_main.GetITemString(1,'do_no')

Select pick_list_print_Count Into :llPrintCount From delivery_master Where do_no = :lsDONO;
If IsNull(llPrintCount) Then llPrintCount = 0

if llPrintCount > 0 Then
	w_do.idw_print.modify("t_reprint.visible=true")
else
	w_do.idw_print.modify("t_reprint.visible=false")
End If


OpenWithParm(w_dw_print_options,w_do.idw_print) 
 
 
if NOT lb_printed_before and message.doubleparm <> -1 then
 

end if
 
// 08/04 - PCONKL - If any Components were blown out to children on Pick List, print BOM Report
If w_do.idw_Pick.Find("Component_Ind = 'W'",1,w_do.idw_Pick.RowCount()) > 0 Then
        
        If Messagebox(w_do.is_title, 'Do you want to print the "Pick list Bill of Materials Report"?',Question!,YesNo!,1) = 1 Then
                ldsBomPrint = Create DataStore
                ldsBomPrint.DataObject = 'd_do_bom_report'
                ldsBomPrint.SetTransObject(sqlca)
                lsDONO = w_do.idw_main.GetITemString(1,'do_no')
                If      ldsBomPrint.Retrieve(lsDONO) > 0 Then
                        ldsBomPrint.Print()
                End If
        End If
        
End If
 
If message.doubleparm = 1 then
	
	// 01/14 - PCONKL - update print count
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Delivery_master
	Set pick_list_print_Count = ( :llPrintCount + 1 ) where Do_no = :lsDONO;
	
	Execute Immediate "COMMIT" using SQLCA;
	
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
                w_do.idw_main.SetItem(1,"ord_status","I")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If


Return 0
end function

public function integer uf_pickprint_runnersworld ();// This event prints the Picking List which is currently visible on the screen 
// and not from the database

// 11/09 - PCONKL - Removed logic for loading temp DW and copying to Print DW. This required all custom Pick Lists to be in sync and wasnt really buying us anything.

 
Long ll_cnt, i, j, llFind, llline_item_no, llDetailFind, llCount, llNotesCount, llNotesPos
String ls_address, lsSUpplier, lsSupplierHold, lsfind, ls_alt_sku, lsNotes
String ls_project_id , ls_sku , lsSKUHold, ls_description, lsCarrier, lsSchedCode, lsSchedDesc
String ls_inventory_type , ls_inventory_type_desc, lsClientName, lsIMUser9,  lsSuppName, lsDONO, lsIMUser13
String lsSaveInvoice, lsSaveCustOrdNo, ls_order_type, ls_order_type_desc
dec{3} ld_weight_1
string lsWH, lsCarPriority //for 3COM Carrier Prioritized Picking routing call
Str_parms       lstrParms
DataStore  ldsInvType,  ldsBOMPrint, ldsContractPrint, ldsOrdType, ldsNotes
datawindowChild ldwc
datastore ldsDeliveryReport
integer li_idx
string ls_do_no, ls_pick_list_printed
boolean lb_printed_before
 
 
w_do.tab_main.tabpage_pick.dw_print.dataobject = 'd_picking_prt_rw'	 /*assign custom print DW */
 
ls_do_no = w_do.idw_main.GetItemString(1, "do_no")
 

ll_cnt = w_do.idw_pick.rowcount()
 
// 01/03 - PCONKL - Retrieve Inventory Type descriptions for printed report - only need to do once
ldsInvType = Create Datastore
ldsInvType.DataObject = 'dddw_inventory_Type_by_Project'
ldsInvType.SetTransObject(SQLCA)
ldsInvType.Retrieve(gs_Project)
 
ldsOrdType = Create Datastore
ldsOrdType.DataObject = 'dddw_delivery_order_type'
ldsOrdType.SetTransObject(SQLCA)
ldsOrdType.Retrieve(gs_Project)
 
 
 
w_do.idw_print.Reset()
 
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// 08/00 PCONKL Show Client Name on Pick Ticket
Select Client_name into :lsClientName
From    Project
Where project_id = :ls_project_id
Using SQLCA;
 
//For GM_MI_DAT, we want to concatonate Schedule Code (desc) to carrier
lsCarrier = w_do.idw_main.getitemstring(1,"Carrier")
If isnull(LsCarrier) Then lsCarrier = ''
 

//TAM 03/30/2006 Set saved invoice and Cust Order Number to Blank
lsSaveInvoice = ''
lsSaveCustOrdNo = ''
 
For i = 1 to ll_cnt /*each Pick Row */
 
        w_do.SetMicroHelp('Printing pick list for item ' + String(i) + ' of ' + String(ll_cnt))
        
        ls_sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
        
        ls_inventory_type = w_do.idw_pick.getitemstring(i,"inventory_type")
 
        // 01/03 - PCONKL - Load from datastore instead of retriveing every time (move row function doesn't load DDDW)
        llFind = ldsInvType.Find("Inv_Type = '" + ls_inventory_type + "'",1,ldsInvType.RowCount())
        If llFind > 0 Then
                ls_inventory_type_desc = ldsInvType.GetITemString(llFind,'inv_type_desc')
        Else
                ls_inventory_type_desc = ls_inventory_type
        End If
        
        ls_order_type = w_do.idw_main.getitemstring(1,"ord_type")
        
 
        llFind = ldsOrdType.Find("ord_type = '" + ls_order_type + "'",1,ldsOrdType.RowCount())
        If llFind > 0 Then
                ls_order_type_desc = ldsOrdType.GetITemString(llFind,'ord_type_desc')
        Else
                ls_order_type_desc = ls_order_type
        End If  
                
        
        
        // 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
        If w_do.idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
        
        //08/04 - PCONKL - Don't print Components that are just placeholders for children being picked
        If w_do.idw_pick.getitemstring(i,"Component_ind") = 'Y'  and w_do.idw_pick.getitemstring(i,"component_type") = 'D' and w_do.idw_pick.getitemNumber(i,"Component_No") = 0 and w_do.idw_pick.getitemstring(i,"l_code") = 'N/A' Then Continue
        If w_do.idw_pick.getitemstring(i,"Component_ind") = '*' Then Continue
        
        j = w_do.idw_print.InsertRow(0)
       w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
       w_do.idw_print.setitem(j,"project_id",gs_project) /* 07/02 - Pconkl - some fields may be visible or invisible based on project*/
        w_do.idw_print.setitem(j,"client_name",lsClientName) /* 08/00 PCONKL -show project name instead of code (customer sees the pick ticket)*/
        w_do.idw_print.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        w_do.idw_print.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code"))
        w_do.idw_print.setitem(j,"carrier",lscarrier) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"Priority",String(w_do.idw_main.getitemNumber(1,"Priority"),'####')) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"dm_user_field1",w_do.idw_main.getitemstring(1,"user_field1")) /* 09/03 - PCONKL - 3COM Freight Terms Code */
        w_do.idw_print.setitem(j,"dm_user_field2",w_do.idw_main.getitemstring(1,"user_field2")) /* 09/03 - PCONKL - 3COM Cust Sold TO ID */
        w_do.idw_print.setitem(j,"dm_user_field6",w_do.idw_main.getitemstring(1,"user_field6")) /* 08/04 - PCONKL - 3COM Delivery Note */
        w_do.idw_print.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        w_do.idw_print.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        w_do.idw_print.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        w_do.idw_print.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        w_do.idw_print.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
        w_do.idw_print.setitem(j,"state",w_do.idw_main.getitemstring(1,"state"))
        w_do.idw_print.setitem(j,"zip_code",w_do.idw_main.getitemstring(1,"zip"))
        w_do.idw_print.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
        w_do.idw_print.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
  		  w_do.idw_print.setitem(j,"request_date",w_do.idw_main.getitemdatetime(1,"request_date"))
        w_do.idw_print.setitem(j,"wh_code",w_do.idw_main.getitemstring(1,"wh_code"))
        w_do.idw_print.setitem(j,"sku",w_do.idw_pick.getitemstring(i,"sku"))
        w_do.idw_print.setitem(j,"sku_parent",w_do.idw_pick.getitemstring(i,"sku_Parent"))
        w_do.idw_print.setitem(j,"supp_code",w_do.idw_pick.getitemstring(i,"supp_code"))
        w_do.idw_print.setitem(j,"serial_no",w_do.idw_pick.getitemstring(i,"serial_no"))
        w_do.idw_print.setitem(j,"lot_no",w_do.idw_pick.getitemstring(i,"lot_no"))
        w_do.idw_print.setitem(j,"po_no",w_do.idw_pick.getitemstring(i,"po_no"))
        w_do.idw_print.setitem(j,"po_no2",w_do.idw_pick.getitemstring(i,"po_no2")) /* 01/02 PCONKL */
        w_do.idw_print.setitem(j,"container_ID",w_do.idw_pick.getitemstring(i,"container_ID")) /* 11/02 PCONKL */
        w_do.idw_print.setitem(j,"expiration_Date",w_do.idw_pick.getitemDateTime(i,"expiration_Date")) /* 11/02 PCONKL */
        
        //MA 02/08 - Added ord_type to picking list for 3com
        
        w_do.idw_print.setitem(j,"ord_type_desc", ls_order_type_desc)         
        
        // 11/06 - PCONKL - If Component parent placeholder, print "* NO PICK *" instead of "N/A"
        If w_do.idw_pick.getitemstring(i,"Component_Ind") = "Y" and w_do.idw_pick.getitemstring(i,"l_code") = "N/A" Then
                w_do.idw_print.setitem(j,"l_code","* NO PICK *")
        Else
                w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemstring(i,"l_code"))
        End If
              
        //12/05 - PCONKL - quantity now set above - we may be rolling up rows
        //w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        
        w_do.idw_print.setitem(j,"component_no",w_do.idw_pick.getitemnumber(i,"component_no"))
        w_do.idw_print.setitem(j,"component_ind",w_do.idw_pick.getitemstring(i,"Component_Ind")) /* 08/04 - PCONKL */
        w_do.idw_print.setitem(j,"pick_as",w_do.idw_pick.getitemstring(i,"user_field2")) /* 11/00 PCONKL - show pick iterations*/
        w_do.idw_print.setitem(j,"ship_ref_nbr",w_do.idw_other.getitemstring(1,"ship_ref"))
        w_do.idw_print.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
               
        /* 07/02 - Pconkl - User Field 9 is commodity code for Saltillo - shown on printed Pick LIst (Visible property for fields on Print)*/
        // 01/03 - PCONKL - Only retrieve when SKU has changed
        // 04/04 - TAMCCLANAHAN - Add retrieve when Supplier has changed
        // 12/06 - PCONKL - Added join to supplier for Supplier Name - commented out seperate SQL below
        If ls_SKU <> lsSKUHold or lsSupplier <> lsSupplierHold Then
                
                select description, user_field9, weight_1, user_field13, supp_name
                into     :ls_description , :lsIMUser9, :ld_weight_1, :lsIMUser13, :lsSuppname  //TAM 2006/06/26 added UF13 
                from item_master, Supplier 
                where item_master.Project_id = Supplier.Project_id and Item_master.Supp_Code = Supplier.Supp_Code and
                                item_master.project_id = :ls_project_id and sku = :ls_sku and item_master.supp_code = :lsSupplier;
        
        End If
 
        ls_description = trim(ls_description)
                
        w_do.idw_print.setitem(j,"weight_1",ld_weight_1) /*09/02 - gap */
        w_do.idw_print.setitem(j,"description",ls_description)
        w_do.idw_print.setitem(j,"im_user_field9",lsimUser9) /*07/02 - Pconkl */
        
        w_do.idw_print.setitem(j,"im_user_field13",lsimUser13)  // TAM - 2006/06/26 Added UF13 
        w_do.idw_print.setitem(j,"supplier_name",lsSuppName)
        w_do.idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
        //w_do.idw_print.setitem(j,"invoice_no",is_bolno)
         w_do.idw_print.setitem(j,"invoice_no",w_do.idw_main.GetItemString(1,"invoice_no"))
         w_do.idw_print.SetITem(j,"cust_ord_no",w_do.idw_main.GetItemString(1,"cust_order_no")) /* 08/00 PCONKL */
             
//TAM 12/13/04 load alt sku from order detail
        
        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
        if llfind > 0 Then
                ls_alt_sku = w_do.idw_detail.getitemString(llFind,"alternate_sku")
        else
                ls_alt_sku = ''
        end if
 
        if ls_alt_sku <> ls_sku Then
                w_do.idw_print.setitem(j,"alt_sku",ls_alt_sku)
        else
                w_do.idw_print.setitem(j,"alt_sku",'')
        end if
         
        w_do.idw_print.setitem(j,"Shipping_Instructions",w_do.idw_main.getitemstring(1,"Shipping_Instructions")) /* 11/03 - PCONKL */
        string sku
      
        sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
       
        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
        if llfind > 0 Then
                 w_do.idw_print.SetItem( i,  "price", w_do.idw_detail.getitemDecimal(llFind,"price"))
        end if
                
       w_do.idw_print.SetItem( i,  "awb_bol_nbr",w_do.idw_other.getitemstring(1,"awb_bol_no"))
                
        
 	  
        
        lsSKUHold = ls_SKU
        lsSupplierHold = lsSupplier
        
Next /*pick Rec*/
 

// 02/01 PCONKL - Filter Pick list to not show components if box is not checked
If w_do.tab_main.tabpage_pick.cbx_show_comp.Checked Then
        w_do.idw_print.SetFilter('')
Else
        w_do.idw_print.SetFilter('sku=sku_parent')   
End If
 
w_do.idw_pick.Filter()
 
w_do.idw_print.Sort()
w_do.idw_print.GroupCalc()
 
OpenWithParm(w_dw_print_options,w_do.idw_print) 
 
 
if NOT lb_printed_before and message.doubleparm <> -1 then
 
//      UPDATE Delivery_Master SET Pick_List_Printed = 'Y'
//              WHERE do_no = :ls_do_no USING SQLCA;
                        
end if
 
// 08/04 - PCONKL - If any Components were blown out to children on Pick List, print BOM Report
If w_do.idw_Pick.Find("Component_Ind = 'W'",1,w_do.idw_Pick.RowCount()) > 0 Then
        
        If Messagebox(w_do.is_title, 'Do you want to print the "Pick list Bill of Materials Report"?',Question!,YesNo!,1) = 1 Then
                ldsBomPrint = Create DataStore
                ldsBomPrint.DataObject = 'd_do_bom_report'
                ldsBomPrint.SetTransObject(sqlca)
                lsDONO = w_do.idw_main.GetITemString(1,'do_no')
                If      ldsBomPrint.Retrieve(lsDONO) > 0 Then
                        ldsBomPrint.Print()
                End If
        End If
        
End If
 

 
// print pro forma invoice for Runners World
// 07/09 - PCONKL - Only print for Warehouse "RUN-WORLD" (not GIGA)
// 08/26/2009 - TAM - Check upper case warehouse.  Had some coming in Mixed Case.
If Upper(gs_project) = 'RUN-WORLD' and Upper(w_do.idw_main.GetITemString(1,'wh_code')) = 'RUN-WORLD' THEN
        
                ldsDeliveryReport = Create DataStore
                ldsDeliveryReport.DataObject = 'd_rw_performa_invoice'
                ldsDeliveryReport.SetTransObject(sqlca)
                lsDONO = w_do.idw_main.GetITemString(1,'do_no')
                If      ldsDeliveryReport.Retrieve(lsDONO) > 0 Then
 
                        string ls_supp_code
					  boolean lb_format_logo = false
        							
                        ls_supp_code = Trim(Upper(ldsDeliveryReport.GetItemString( 1, "supp_code")))
                        CHOOSE CASE ls_supp_code
                                CASE "CATALOGS"
                                        ldsDeliveryReport.Modify("p_1.Filename='CATALOGS-LOGO.JPG'")
									lb_format_logo = true
                                CASE "RUNNERS-WORLD"
                                        ldsDeliveryReport.Modify("p_1.Filename='RW-Logo.JPG'")
									lb_format_logo = true
                                CASE "SPORTIVTECH"
                                        ldsDeliveryReport.Modify("p_1.Filename='SportivTech-Logo.jpg'")
                                CASE "TRENDZ360"
                                        ldsDeliveryReport.Modify("p_1.Filename='Trendz360-Logo.bmp'")													
									lb_format_logo = true
							 CASE	 "OUTDOOR360"	
                                        ldsDeliveryReport.Modify("p_1.Filename='OUTDR360-Logo.jpg'")	
									lb_format_logo = true
							 CASE	 "NIPPONVISION"	
                                        ldsDeliveryReport.Modify("p_1.Filename='NipponVision.bmp'")	
									ldsDeliveryReport.object.p_1.width = 2752
									lb_format_logo = true
							 CASE	 "KIDS360"	
                                        ldsDeliveryReport.Modify("p_1.Filename='kids-360-logos-1.jpg'")	
									ldsDeliveryReport.object.p_1.width = 416
									ldsDeliveryReport.object.p_1.height = 340
									lb_format_logo = true
								

                                END CHOOSE
									
									
							IF lb_format_logo = true then 		
								 ldsDeliveryReport.object.p_1.x = 59
								 ldsDeliveryReport.object.p_1.y = 100  //225	
								 
								 ldsDeliveryReport.object.t_1.y = 430
								 
								 ldsDeliveryReport.object.delivery_master_invoice_no.y = long(ldsDeliveryReport.object.delivery_master_invoice_no.y) + 200
								 ldsDeliveryReport.object.delivery_master_carrier_t.y =  long(ldsDeliveryReport.object.delivery_master_carrier_t.y) + 200
								 
								 ldsDeliveryReport.object.compute_7.width = 416
								 ldsDeliveryReport.object.compute_7.x = 2930
								 ldsDeliveryReport.object.compute_7.y = 4
	
								 ldsDeliveryReport.object.compute_6.width = 416
								 ldsDeliveryReport.object.compute_6.x = 2930
								 ldsDeliveryReport.object.compute_6.y = 48
	
								ldsDeliveryReport.Object.DataWindow.Header.Height = Long(ldsDeliveryReport.Object.DataWindow.Header.Height) + 200
								
								
								ldsDeliveryReport.object.t_2.y = Long(ldsDeliveryReport.Object.t_2.y) + 200
								ldsDeliveryReport.object.t_3.y = Long(ldsDeliveryReport.Object.t_3.y) + 200
								ldsDeliveryReport.object.t_4.y = Long(ldsDeliveryReport.Object.t_4.y) + 200
								ldsDeliveryReport.object.t_5.y = Long(ldsDeliveryReport.Object.t_5.y) + 200
								ldsDeliveryReport.object.t_6.y = Long(ldsDeliveryReport.Object.t_6.y) + 200
								ldsDeliveryReport.object.t_7.y = Long(ldsDeliveryReport.Object.t_7.y) + 200
								ldsDeliveryReport.object.t_8.y = Long(ldsDeliveryReport.Object.t_8.y) + 200
								ldsDeliveryReport.object.t_9.y = Long(ldsDeliveryReport.Object.t_9.y) + 200
								ldsDeliveryReport.object.t_10.y = Long(ldsDeliveryReport.Object.t_10.y) + 200
								ldsDeliveryReport.object.t_11.y = Long(ldsDeliveryReport.Object.t_11.y) + 200
								ldsDeliveryReport.object.t_12.y = Long(ldsDeliveryReport.Object.t_12.y) + 200
								ldsDeliveryReport.object.t_13.y = Long(ldsDeliveryReport.Object.t_13.y) + 200
								ldsDeliveryReport.object.t_14.y = Long(ldsDeliveryReport.Object.t_14.y) + 200
								ldsDeliveryReport.object.t_15.y = Long(ldsDeliveryReport.Object.t_15.y) + 200
								ldsDeliveryReport.object.t_17.y = Long(ldsDeliveryReport.Object.t_17.y) + 200
									  
							End IF		  
										  
                
                               ldsDeliveryReport.Print()
                End If
                
END IF
 
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
                w_do.idw_main.SetItem(1,"ord_status","I")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If

Return 0
end function

public function integer uf_pickprint_eut ();// This event prints the Picking List which is currently visible on the screen 
// and not from the database

// 11/09 - PCONKL - Removed logic for loading temp DW and copying to Print DW. This required all custom Pick Lists to be in sync and wasnt really buying us anything.
 
Long ll_cnt, i, j, llFind, llline_item_no, llDetailFind, llCount, llNotesCount, llNotesPos
String ls_address, lsSUpplier, lsSupplierHold, lsfind, ls_alt_sku, lsNotes
String ls_project_id , ls_sku , lsSKUHold, ls_description, lsCarrier, lsSchedCode, lsSchedDesc
String ls_inventory_type , ls_inventory_type_desc, lsClientName, lsIMUser9,  lsSuppName, lsDONO, lsIMUser13
String lsSaveInvoice, lsSaveCustOrdNo, ls_order_type, ls_order_type_desc
dec{3} ld_weight_1
string lsWH, lsCarPriority //for 3COM Carrier Prioritized Picking routing call
Str_parms       lstrParms
DataStore  ldsInvType,  ldsBOMPrint, ldsContractPrint, ldsOrdType, ldsNotes
datawindowChild ldwc
datastore ldsDeliveryReport
integer li_idx

string ls_do_no, ls_pick_list_printed
boolean lb_printed_before
 
w_do.tab_main.tabpage_pick.dw_print.dataobject = 'd_picking_prt_eut' /* assign custom print DW */

ls_do_no = w_do.idw_main.GetItemString(1, "do_no")
 
// 01/03 - PCONKL - Retrieve Inventory Type descriptions for printed report - only need to do once
ldsInvType = Create Datastore
ldsInvType.DataObject = 'dddw_inventory_Type_by_Project'
ldsInvType.SetTransObject(SQLCA)
ldsInvType.Retrieve(gs_Project)
 
ldsOrdType = Create Datastore
ldsOrdType.DataObject = 'dddw_delivery_order_type'
ldsOrdType.SetTransObject(SQLCA)
ldsOrdType.Retrieve(gs_Project)
 
w_do.idw_print.Reset()
 
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// 08/00 PCONKL Show Client Name on Pick Ticket
Select Client_name into :lsClientName
From    Project
Where project_id = :ls_project_id
Using SQLCA;
 
//For GM_MI_DAT, we want to concatonate Schedule Code (desc) to carrier
lsCarrier = w_do.idw_main.getitemstring(1,"Carrier")
If isnull(LsCarrier) Then lsCarrier = ''
        
//TAM 03/30/2006 Set saved invoice and Cust Order Number to Blank
lsSaveInvoice = ''
lsSaveCustOrdNo = ''
 
ll_cnt = w_do.idw_pick.rowcount()
For i = 1 to ll_cnt /*each Pick Row */
 
        w_do.SetMicroHelp('Printing pick list for item ' + String(i) + ' of ' + String(ll_cnt))
        
        ls_sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
        
        ls_inventory_type = w_do.idw_pick.getitemstring(i,"inventory_type")
 
        // 01/03 - PCONKL - Load from datastore instead of retriveing every time (move row function doesn't load DDDW)
        llFind = ldsInvType.Find("Inv_Type = '" + ls_inventory_type + "'",1,ldsInvType.RowCount())
        If llFind > 0 Then
                ls_inventory_type_desc = ldsInvType.GetITemString(llFind,'inv_type_desc')
        Else
                ls_inventory_type_desc = ls_inventory_type
        End If
        
        ls_order_type = w_do.idw_main.getitemstring(1,"ord_type")
        
 
        llFind = ldsOrdType.Find("ord_type = '" + ls_order_type + "'",1,ldsOrdType.RowCount())
        If llFind > 0 Then
                ls_order_type_desc = ldsOrdType.GetITemString(llFind,'ord_type_desc')
        Else
                ls_order_type_desc = ls_order_type
        End If  
                
        
        
        // 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
        If w_do.idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
        
        //08/04 - PCONKL - Don't print Components that are just placeholders for children being picked
        If w_do.idw_pick.getitemstring(i,"Component_ind") = 'Y'  and w_do.idw_pick.getitemstring(i,"component_type") = 'D' and w_do.idw_pick.getitemNumber(i,"Component_No") = 0 and w_do.idw_pick.getitemstring(i,"l_code") = 'N/A' Then Continue
        If w_do.idw_pick.getitemstring(i,"Component_ind") = '*' Then Continue
        
        j = w_do.idw_print.InsertRow(0)
        w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        w_do.idw_print.setitem(j,"project_id",gs_project) /* 07/02 - Pconkl - some fields may be visible or invisible based on project*/
        w_do.idw_print.setitem(j,"client_name",lsClientName) /* 08/00 PCONKL -show project name instead of code (customer sees the pick ticket)*/
        w_do.idw_print.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        w_do.idw_print.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code"))
        w_do.idw_print.setitem(j,"carrier",lscarrier) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"Priority",String(w_do.idw_main.getitemNumber(1,"Priority"),'####')) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"dm_user_field1",w_do.idw_main.getitemstring(1,"user_field1")) /* 09/03 - PCONKL - 3COM Freight Terms Code */
        w_do.idw_print.setitem(j,"dm_user_field2",w_do.idw_main.getitemstring(1,"user_field2")) /* 09/03 - PCONKL - 3COM Cust Sold TO ID */
        w_do.idw_print.setitem(j,"dm_user_field6",w_do.idw_main.getitemstring(1,"user_field6")) /* 08/04 - PCONKL - 3COM Delivery Note */
        w_do.idw_print.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        w_do.idw_print.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        w_do.idw_print.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        w_do.idw_print.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        w_do.idw_print.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
        w_do.idw_print.setitem(j,"state",w_do.idw_main.getitemstring(1,"state"))
        w_do.idw_print.setitem(j,"zip_code",w_do.idw_main.getitemstring(1,"zip"))
        w_do.idw_print.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
        w_do.idw_print.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
  		  w_do.idw_print.setitem(j,"request_date",w_do.idw_main.getitemdatetime(1,"request_date"))
        w_do.idw_print.setitem(j,"wh_code",w_do.idw_main.getitemstring(1,"wh_code"))
        w_do.idw_print.setitem(j,"sku",w_do.idw_pick.getitemstring(i,"sku"))
        w_do.idw_print.setitem(j,"sku_parent",w_do.idw_pick.getitemstring(i,"sku_Parent"))
        w_do.idw_print.setitem(j,"supp_code",w_do.idw_pick.getitemstring(i,"supp_code"))
        w_do.idw_print.setitem(j,"serial_no",w_do.idw_pick.getitemstring(i,"serial_no"))
        w_do.idw_print.setitem(j,"lot_no",w_do.idw_pick.getitemstring(i,"lot_no"))
        w_do.idw_print.setitem(j,"po_no",w_do.idw_pick.getitemstring(i,"po_no"))
        w_do.idw_print.setitem(j,"po_no2",w_do.idw_pick.getitemstring(i,"po_no2")) /* 01/02 PCONKL */
        w_do.idw_print.setitem(j,"container_ID",w_do.idw_pick.getitemstring(i,"container_ID")) /* 11/02 PCONKL */
        w_do.idw_print.setitem(j,"expiration_Date",w_do.idw_pick.getitemDateTime(i,"expiration_Date")) /* 11/02 PCONKL */
        
        //MA 02/08 - Added ord_type to picking list for 3com
        
        w_do.idw_print.setitem(j,"ord_type_desc", ls_order_type_desc)         
        
        // 11/06 - PCONKL - If Component parent placeholder, print "* NO PICK *" instead of "N/A"
        If w_do.idw_pick.getitemstring(i,"Component_Ind") = "Y" and w_do.idw_pick.getitemstring(i,"l_code") = "N/A" Then
                w_do.idw_print.setitem(j,"l_code","* NO PICK *")
        Else
                w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemstring(i,"l_code"))
        End If
               
        //12/05 - PCONKL - quantity now set above - we may be rolling up rows
        //w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        
        w_do.idw_print.setitem(j,"component_no",w_do.idw_pick.getitemnumber(i,"component_no"))
        w_do.idw_print.setitem(j,"component_ind",w_do.idw_pick.getitemstring(i,"Component_Ind")) /* 08/04 - PCONKL */
        w_do.idw_print.setitem(j,"pick_as",w_do.idw_pick.getitemstring(i,"user_field2")) /* 11/00 PCONKL - show pick iterations*/
        w_do.idw_print.setitem(j,"ship_ref_nbr",w_do.idw_other.getitemstring(1,"ship_ref"))
        w_do.idw_print.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
               
        /* 07/02 - Pconkl - User Field 9 is commodity code for Saltillo - shown on printed Pick LIst (Visible property for fields on Print)*/
        // 01/03 - PCONKL - Only retrieve when SKU has changed
        // 04/04 - TAMCCLANAHAN - Add retrieve when Supplier has changed
        // 12/06 - PCONKL - Added join to supplier for Supplier Name - commented out seperate SQL below
        If ls_SKU <> lsSKUHold or lsSupplier <> lsSupplierHold Then
                
                select description, user_field9, weight_1, user_field13, supp_name
                into     :ls_description , :lsIMUser9, :ld_weight_1, :lsIMUser13, :lsSuppname  //TAM 2006/06/26 added UF13 
                from item_master, Supplier 
                where item_master.Project_id = Supplier.Project_id and Item_master.Supp_Code = Supplier.Supp_Code and
                                item_master.project_id = :ls_project_id and sku = :ls_sku and item_master.supp_code = :lsSupplier;
        
        End If
 
        ls_description = trim(ls_description)
                
        w_do.idw_print.setitem(j,"weight_1",ld_weight_1) /*09/02 - gap */
        w_do.idw_print.setitem(j,"description",ls_description)
        w_do.idw_print.setitem(j,"im_user_field9",lsimUser9) /*07/02 - Pconkl */
        
        w_do.idw_print.setitem(j,"im_user_field13",lsimUser13)  // TAM - 2006/06/26 Added UF13 
        w_do.idw_print.setitem(j,"supplier_name",lsSuppName)
        w_do.idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
        
        //w_do.idw_print.setitem(j,"invoice_no",is_bolno)
        w_do.idw_print.setitem(j,"invoice_no",w_do.idw_main.GetItemString(1,"invoice_no"))
        w_do.idw_print.SetITem(j,"cust_ord_no",w_do.idw_main.GetItemString(1,"cust_order_no")) /* 08/00 PCONKL */
            
        
//TAM 12/13/04 load alt sku from order detail
        
        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
        if llfind > 0 Then
                ls_alt_sku = w_do.idw_detail.getitemString(llFind,"alternate_sku")
        else
                ls_alt_sku = ''
        end if
 
        if ls_alt_sku <> ls_sku Then
                w_do.idw_print.setitem(j,"alt_sku",ls_alt_sku)
        else
                w_do.idw_print.setitem(j,"alt_sku",'')
        end if
              
 
        w_do.idw_print.setitem(j,"Shipping_Instructions",w_do.idw_main.getitemstring(1,"Shipping_Instructions")) /* 11/03 - PCONKL */
        string sku
        
       sku = w_do.idw_pick.getitemstring(i,"sku")
       lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
       llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
        
       lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
       llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
       if llfind > 0 Then
               w_do.idw_print.SetItem( i,  "price", w_do.idw_detail.getitemDecimal(llFind,"price"))
       end if
            
        lsSKUHold = ls_SKU
        lsSupplierHold = lsSupplier
        
Next /*pick Rec*/

// 02/01 PCONKL - Filter Pick list to not show components if box is not checked
If w_do.tab_main.tabpage_pick.cbx_show_comp.Checked Then
        w_do.idw_print.SetFilter('')
Else
        w_do.idw_print.SetFilter('sku=sku_parent')   
End If
 
w_do.idw_pick.Filter()
 
w_do.idw_print.Sort()
w_do.idw_print.GroupCalc()
 
OpenWithParm(w_dw_print_options,w_do.idw_print) 
 
 
if NOT lb_printed_before and message.doubleparm <> -1 then
 
//      UPDATE Delivery_Master SET Pick_List_Printed = 'Y'
//              WHERE do_no = :ls_do_no USING SQLCA;
                        
end if
 
// 08/04 - PCONKL - If any Components were blown out to children on Pick List, print BOM Report
If w_do.idw_Pick.Find("Component_Ind = 'W'",1,w_do.idw_Pick.RowCount()) > 0 Then
        
        If Messagebox(w_do.is_title, 'Do you want to print the "Pick list Bill of Materials Report"?',Question!,YesNo!,1) = 1 Then
                ldsBomPrint = Create DataStore
                ldsBomPrint.DataObject = 'd_do_bom_report'
                ldsBomPrint.SetTransObject(sqlca)
                lsDONO = w_do.idw_main.GetITemString(1,'do_no')
                If      ldsBomPrint.Retrieve(lsDONO) > 0 Then
                        ldsBomPrint.Print()
                End If
        End If
        
End If
 
//If Upper(gs_project) = 'EUT' THEN
        
                ldsDeliveryReport = Create DataStore
                ldsDeliveryReport.DataObject = 'd_eut_performa_invoice'
                ldsDeliveryReport.SetTransObject(sqlca)
                lsDONO = w_do.idw_main.GetITemString(1,'do_no')
                If      ldsDeliveryReport.Retrieve(lsDONO) > 0 Then
                                ldsDeliveryReport.Print()
                End If
//END IF



If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
                w_do.idw_main.SetItem(1,"ord_status","I")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If

Return 0
end function

public function integer uf_pickprint_lam ();// This event prints the Picking List which is currently visible on the screen 
// and not from the database

// 11/09 - PCONKL - Removed logic for loading temp DW and copying to Print DW. This required all custom Pick Lists to be in sync and wasnt really buying us anything.


Long ll_cnt, i, j, llFind, llline_item_no, llDetailFind, llCount, llNotesCount, llNotesPos
String ls_address, lsSUpplier, lsSupplierHold, lsfind, ls_alt_sku, lsNotes
String ls_project_id , ls_sku , lsSKUHold, ls_description, lsCarrier, lsSchedCode, lsSchedDesc
String ls_inventory_type , ls_inventory_type_desc, lsClientName, lsIMUser9,  lsSuppName, lsDONO, lsIMUser13
String lsSaveInvoice, lsSaveCustOrdNo, ls_order_type, ls_order_type_desc, ls_receive_order_no
dec{3} ld_weight_1
string lsWH, lsCarPriority //for 3COM Carrier Prioritized Picking routing call
Str_parms       lstrParms
DataStore  ldsInvType,  ldsBOMPrint, ldsContractPrint, ldsOrdType, ldsNotes
datawindowChild ldwc
datastore ldsDeliveryReport
integer li_idx

 
string ls_do_no, ls_pick_list_printed
boolean lb_printed_before
 
w_do.tab_main.tabpage_pick.dw_print.dataobject = 'd_picking_prt_lam'	 /* assign custom print DW */
 
ls_do_no = w_do.idw_main.GetItemString(1, "do_no")
 
ll_cnt = w_do.idw_pick.rowcount()
 
// 01/03 - PCONKL - Retrieve Inventory Type descriptions for printed report - only need to do once
ldsInvType = Create Datastore
ldsInvType.DataObject = 'dddw_inventory_Type_by_Project'
ldsInvType.SetTransObject(SQLCA)
ldsInvType.Retrieve(gs_Project)
 
ldsOrdType = Create Datastore
ldsOrdType.DataObject = 'dddw_delivery_order_type'
ldsOrdType.SetTransObject(SQLCA)
ldsOrdType.Retrieve(gs_Project)
 
w_do.idw_print.Reset()
 
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// 08/00 PCONKL Show Client Name on Pick Ticket
Select Client_name into :lsClientName
From    Project
Where project_id = :ls_project_id
Using SQLCA;
 
//For GM_MI_DAT, we want to concatonate Schedule Code (desc) to carrier
lsCarrier = w_do.idw_main.getitemstring(1,"Carrier")
If isnull(LsCarrier) Then lsCarrier = ''
        
//TAM 03/30/2006 Set saved invoice and Cust Order Number to Blank
lsSaveInvoice = ''
lsSaveCustOrdNo = ''
 
For i = 1 to ll_cnt /*each Pick Row */
 
        w_do.SetMicroHelp('Printing pick list for item ' + String(i) + ' of ' + String(ll_cnt))
        
        ls_sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
        
        ls_inventory_type = w_do.idw_pick.getitemstring(i,"inventory_type")
 
        // 01/03 - PCONKL - Load from datastore instead of retriveing every time (move row function doesn't load DDDW)
        llFind = ldsInvType.Find("Inv_Type = '" + ls_inventory_type + "'",1,ldsInvType.RowCount())
        If llFind > 0 Then
                ls_inventory_type_desc = ldsInvType.GetITemString(llFind,'inv_type_desc')
        Else
                ls_inventory_type_desc = ls_inventory_type
        End If
        
        ls_order_type = w_do.idw_main.getitemstring(1,"ord_type")
        
 
        llFind = ldsOrdType.Find("ord_type = '" + ls_order_type + "'",1,ldsOrdType.RowCount())
        If llFind > 0 Then
                ls_order_type_desc = ldsOrdType.GetITemString(llFind,'ord_type_desc')
        Else
                ls_order_type_desc = ls_order_type
        End If  
                
        
        
        // 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
        If w_do.idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
        
        //08/04 - PCONKL - Don't print Components that are just placeholders for children being picked
        If w_do.idw_pick.getitemstring(i,"Component_ind") = 'Y'  and w_do.idw_pick.getitemstring(i,"component_type") = 'D' and w_do.idw_pick.getitemNumber(i,"Component_No") = 0 and w_do.idw_pick.getitemstring(i,"l_code") = 'N/A' Then Continue
        If w_do.idw_pick.getitemstring(i,"Component_ind") = '*' Then Continue
        
        j = w_do.idw_print.InsertRow(0)
        w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        w_do.idw_print.setitem(j,"project_id",gs_project) /* 07/02 - Pconkl - some fields may be visible or invisible based on project*/
        w_do.idw_print.setitem(j,"client_name",lsClientName) /* 08/00 PCONKL -show project name instead of code (customer sees the pick ticket)*/
        w_do.idw_print.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        w_do.idw_print.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code"))
        w_do.idw_print.setitem(j,"carrier",lscarrier) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"Priority",String(w_do.idw_main.getitemNumber(1,"Priority"),'####')) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"dm_user_field1",w_do.idw_main.getitemstring(1,"user_field1")) /* 09/03 - PCONKL - 3COM Freight Terms Code */
        w_do.idw_print.setitem(j,"dm_user_field2",w_do.idw_main.getitemstring(1,"user_field2")) /* 09/03 - PCONKL - 3COM Cust Sold TO ID */
        w_do.idw_print.setitem(j,"dm_user_field6",w_do.idw_main.getitemstring(1,"user_field6")) /* 08/04 - PCONKL - 3COM Delivery Note */
        w_do.idw_print.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        w_do.idw_print.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        w_do.idw_print.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        w_do.idw_print.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        w_do.idw_print.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
        w_do.idw_print.setitem(j,"state",w_do.idw_main.getitemstring(1,"state"))
        w_do.idw_print.setitem(j,"zip_code",w_do.idw_main.getitemstring(1,"zip"))
        w_do.idw_print.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
        w_do.idw_print.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
  		  w_do.idw_print.setitem(j,"request_date",w_do.idw_main.getitemdatetime(1,"request_date"))
        w_do.idw_print.setitem(j,"wh_code",w_do.idw_main.getitemstring(1,"wh_code"))
        w_do.idw_print.setitem(j,"sku",w_do.idw_pick.getitemstring(i,"sku"))
        w_do.idw_print.setitem(j,"sku_parent",w_do.idw_pick.getitemstring(i,"sku_Parent"))
        w_do.idw_print.setitem(j,"supp_code",w_do.idw_pick.getitemstring(i,"supp_code"))
        w_do.idw_print.setitem(j,"serial_no",w_do.idw_pick.getitemstring(i,"serial_no"))
        w_do.idw_print.setitem(j,"lot_no",w_do.idw_pick.getitemstring(i,"lot_no"))
        w_do.idw_print.setitem(j,"po_no",w_do.idw_pick.getitemstring(i,"po_no"))
        w_do.idw_print.setitem(j,"po_no2",w_do.idw_pick.getitemstring(i,"po_no2")) /* 01/02 PCONKL */
        w_do.idw_print.setitem(j,"container_ID",w_do.idw_pick.getitemstring(i,"container_ID")) /* 11/02 PCONKL */
        w_do.idw_print.setitem(j,"expiration_Date",w_do.idw_pick.getitemDateTime(i,"expiration_Date")) /* 11/02 PCONKL */
        
        //MA 02/08 - Added ord_type to picking list for 3com
        
        w_do.idw_print.setitem(j,"ord_type_desc", ls_order_type_desc)         
        
        // 11/06 - PCONKL - If Component parent placeholder, print "* NO PICK *" instead of "N/A"
        If w_do.idw_pick.getitemstring(i,"Component_Ind") = "Y" and w_do.idw_pick.getitemstring(i,"l_code") = "N/A" Then
                w_do.idw_print.setitem(j,"l_code","* NO PICK *")
        Else
                w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemstring(i,"l_code"))
        End If
        
        // 11/08 - For Diebold CO133 (Slob), we want to sort by Line ITem. Since it it is not already on the printed report, store in picking_seq field.
        If gs_Project = 'DB-CO133' Then
                w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemNumber(i,"Line_Item_No"))
        Else
                w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemdecimal(i,"picking_seq"))
        End If
        
        //12/05 - PCONKL - quantity now set above - we may be rolling up rows
        //w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        
        w_do.idw_print.setitem(j,"component_no",w_do.idw_pick.getitemnumber(i,"component_no"))
        w_do.idw_print.setitem(j,"component_ind",w_do.idw_pick.getitemstring(i,"Component_Ind")) /* 08/04 - PCONKL */
        w_do.idw_print.setitem(j,"pick_as",w_do.idw_pick.getitemstring(i,"user_field2")) /* 11/00 PCONKL - show pick iterations*/
        w_do.idw_print.setitem(j,"ship_ref_nbr",w_do.idw_other.getitemstring(1,"ship_ref"))
        w_do.idw_print.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
               
        /* 07/02 - Pconkl - User Field 9 is commodity code for Saltillo - shown on printed Pick LIst (Visible property for fields on Print)*/
        // 01/03 - PCONKL - Only retrieve when SKU has changed
        // 04/04 - TAMCCLANAHAN - Add retrieve when Supplier has changed
        // 12/06 - PCONKL - Added join to supplier for Supplier Name - commented out seperate SQL below
        If ls_SKU <> lsSKUHold or lsSupplier <> lsSupplierHold Then
                
                select description, user_field9, weight_1, user_field13, supp_name
                into     :ls_description , :lsIMUser9, :ld_weight_1, :lsIMUser13, :lsSuppname  //TAM 2006/06/26 added UF13 
                from item_master, Supplier 
                where item_master.Project_id = Supplier.Project_id and Item_master.Supp_Code = Supplier.Supp_Code and
                                item_master.project_id = :ls_project_id and sku = :ls_sku and item_master.supp_code = :lsSupplier;
        
        End If
 
        ls_description = trim(ls_description)
                
        w_do.idw_print.setitem(j,"weight_1",ld_weight_1) /*09/02 - gap */
        w_do.idw_print.setitem(j,"description",ls_description)
        w_do.idw_print.setitem(j,"im_user_field9",lsimUser9) /*07/02 - Pconkl */
        
        w_do.idw_print.setitem(j,"im_user_field13",lsimUser13)  // TAM - 2006/06/26 Added UF13 
        w_do.idw_print.setitem(j,"supplier_name",lsSuppName)
        w_do.idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
        
        //w_do.idw_print.setitem(j,"invoice_no",is_bolno)
        w_do.idw_print.setitem(j,"invoice_no",w_do.idw_main.GetItemString(1,"invoice_no"))
        w_do.idw_print.SetITem(j,"cust_ord_no",w_do.idw_main.GetItemString(1,"cust_order_no")) /* 08/00 PCONKL */
            
        
//TAM 12/13/04 load alt sku from order detail
        
        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
        if llfind > 0 Then
                ls_alt_sku = w_do.idw_detail.getitemString(llFind,"alternate_sku")
        else
                ls_alt_sku = ''
        end if
 
        if ls_alt_sku <> ls_sku Then
                w_do.idw_print.setitem(j,"alt_sku",ls_alt_sku)
        else
                w_do.idw_print.setitem(j,"alt_sku",'')
        end if
        
        w_do.idw_print.setitem(j,"Shipping_Instructions",w_do.idw_main.getitemstring(1,"Shipping_Instructions")) /* 11/03 - PCONKL */
        string sku
         
                
		If Upper(gs_project) = 'LAM-SG' THEN   
		
			string lsSerialNo, lsLotNo, lsPoNo, lsPoNo2, lsContainerID, lsLCode, LsCountryOfOrigin
			datetime ldtExpirationDate
			string lsRoNo
			datetime ld_receipt_date
		
			 lsDONO = w_do.idw_Main.GetItemString(1,'do_no')
			 llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
			 ls_sku = w_do.idw_pick.getitemstring(i,"sku")
       	      lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
     		 lsSerialNo = w_do.idw_pick.getitemstring(i,"serial_no")
    			  lsLotNo = w_do.idw_pick.getitemstring(i,"lot_no")
		      lsPoNo =   w_do.idw_pick.getitemstring(i,"po_no")
  		      lsPoNo2 =     w_do.idw_pick.getitemstring(i,"po_no2")
  			 lsContainerID  =   w_do.idw_pick.getitemstring(i,"container_ID")
		      ldtExpirationDate =   w_do.idw_pick.getitemDateTime(i,"expiration_Date")
  			 ls_inventory_type = w_do.idw_pick.getitemstring(i,"inventory_type")
  			 lsLCode = w_do.idw_pick.getitemstring(i,"l_code")
			LsCountryOfOrigin = w_do.idw_pick.getitemstring(i,"country_of_origin")
			  
			select ro_no INTO :lsRoNo
			 from Delivery_Picking_Detail
              Where do_no = :lsDONO and Line_Item_No = :llline_item_no  and
				   Sku = :ls_sku and Supp_Code = :lsSupplier and
				   Serial_No = :lsSerialNo and  Lot_No = :lsLotNo AND
					Po_No = :lsPoNo and Po_No2 = :lsPoNo2 AND
					Container_ID = :lsContainerID and  Expiration_Date = :ldtExpirationDate AND
					Inventory_Type = :ls_inventory_type AND L_Code = :lsLCode  AND
					Country_of_Origin = :LsCountryOfOrigin
			USING SQLCA;
 
	
	
			IF SQLCA.SQLCode <> 0 THEN
				
				MessageBox ("DB Error 1", SQLCA.SQLErrText )
				
			END IF

			IF NOT IsNull(lsRoNo)  and Trim(lsRoNo) <> '' THEN
			
// TAM 2010/10/15 Added Receive Order Number
//				select complete_date INTO :ld_receipt_date
				select complete_date, supp_invoice_no INTO :ld_receipt_date, :ls_receive_order_no
				 from Receive_Master
        		      Where ro_no = :lsRoNo USING SQLCA;
						  
				IF SQLCA.SQLCode <> 0 THEN
					
					MessageBox ("DB Error 2", SQLCA.SQLErrText )
					
				END IF
							
				 w_do.idw_print.setitem(j,"receipt_date"	, ld_receipt_date)
				 w_do.idw_print.setitem(j,"receive_order_no"	, ls_receive_order_no) // TAM 2010/10/15 
			
			END IF

		END IF /*LAM*/
 	  
        
        lsSKUHold = ls_SKU
        lsSupplierHold = lsSupplier
        
Next /*pick Rec*/

// 02/01 PCONKL - Filter Pick list to not show components if box is not checked
If w_do.tab_main.tabpage_pick.cbx_show_comp.Checked Then
        w_do.idw_print.SetFilter('')
Else
        w_do.idw_print.SetFilter('sku=sku_parent')   
End If
 
w_do.idw_pick.Filter()
 
w_do.idw_print.Sort()
w_do.idw_print.GroupCalc()
 
OpenWithParm(w_dw_print_options,w_do.idw_print) 
 
 
if NOT lb_printed_before and message.doubleparm <> -1 then
 
//      UPDATE Delivery_Master SET Pick_List_Printed = 'Y'
//              WHERE do_no = :ls_do_no USING SQLCA;
                        
end if
 
// 08/04 - PCONKL - If any Components were blown out to children on Pick List, print BOM Report
If w_do.idw_Pick.Find("Component_Ind = 'W'",1,w_do.idw_Pick.RowCount()) > 0 Then
        
        If Messagebox(w_do.is_title, 'Do you want to print the "Pick list Bill of Materials Report"?',Question!,YesNo!,1) = 1 Then
                ldsBomPrint = Create DataStore
                ldsBomPrint.DataObject = 'd_do_bom_report'
                ldsBomPrint.SetTransObject(sqlca)
                lsDONO = w_do.idw_main.GetITemString(1,'do_no')
                If      ldsBomPrint.Retrieve(lsDONO) > 0 Then
                        ldsBomPrint.Print()
                End If
        End If
        
End If
 
 If Upper(gs_project) = 'LAM-SG' THEN
        
                ldsDeliveryReport = Create DataStore
                ldsDeliveryReport.DataObject = 'd_lam_performa_invoice'
                ldsDeliveryReport.SetTransObject(sqlca)
                lsDONO = w_do.idw_main.GetITemString(1,'do_no')
                If      ldsDeliveryReport.Retrieve(lsDONO) > 0 Then
                                ldsDeliveryReport.Print()
                End If
END IF
 

If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
                w_do.idw_main.SetItem(1,"ord_status","I")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If


Return 0
end function

public function integer uf_pickprint_pandora ();//copied from baseline pick print
//for pandora (kitty hawk), we don't want to show serial #s so we'll roll up by other lot-ables....

Long ll_cnt, i, j, llFind, llline_item_no, llDetailFind, llCount, llNotesCount, llNotesPos
String ls_address, lsSUpplier, lsSupplierHold, lsfind, ls_alt_sku, lsNotes
String ls_project_id , ls_sku , lsSKUHold, ls_description, lsCarrier, lsSchedCode, lsSchedDesc
String ls_inventory_type , ls_inventory_type_desc, lsClientName, lsIMUser9,  lsSuppName, lsDONO, lsIMUser13
String lsSaveInvoice, lsSaveCustOrdNo, ls_order_type, ls_order_type_desc
dec{3} ld_weight_1
Str_parms       lstrParms
DataStore  ldsInvType,  ldsBOMPrint, ldsContractPrint, ldsOrdType, ldsNotes
datawindowChild ldwc
datastore ldsDeliveryReport
integer li_idx
 
string ls_do_no, ls_pick_list_printed
boolean lb_printed_before
 
 String ls_user_field14
 
//Set the Print DW
w_do.tab_main.tabpage_pick.dw_print.dataobject =  'd_picking_prt_pandora'

ls_do_no = w_do.idw_main.GetItemString(1, "do_no")
 
 
// 01/03 - PCONKL - Retrieve Inventory Type descriptions for printed report - only need to do once
ldsInvType = Create Datastore
ldsInvType.DataObject = 'dddw_inventory_Type_by_Project'
ldsInvType.SetTransObject(SQLCA)
ldsInvType.Retrieve(gs_Project)
 
ldsOrdType = Create Datastore
ldsOrdType.DataObject = 'dddw_delivery_order_type'
ldsOrdType.SetTransObject(SQLCA)
ldsOrdType.Retrieve(gs_Project)
  
w_do.idw_print.Reset()
 
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// 08/00 PCONKL Show Client Name on Pick Ticket
Select Client_name into :lsClientName
From    Project
Where project_id = :ls_project_id
Using SQLCA;
 
//For GM_MI_DAT, we want to concatonate Schedule Code (desc) to carrier
lsCarrier = w_do.idw_main.getitemstring(1,"Carrier")
If isnull(LsCarrier) Then lsCarrier = ''
         
//TAM 03/30/2006 Set saved invoice and Cust Order Number to Blank
lsSaveInvoice = ''
lsSaveCustOrdNo = ''
 
ll_cnt = w_do.idw_pick.rowcount()
For i = 1 to ll_cnt /*each Pick Row */
 
        w_do.SetMicroHelp('Printing pick list for item ' + String(i) + ' of ' + String(ll_cnt))
        
        ls_sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
        
        ls_inventory_type = w_do.idw_pick.getitemstring(i,"inventory_type")
 
        // 01/03 - PCONKL - Load from datastore instead of retriveing every time (move row function doesn't load DDDW)
        llFind = ldsInvType.Find("Inv_Type = '" + ls_inventory_type + "'",1,ldsInvType.RowCount())
        If llFind > 0 Then
                ls_inventory_type_desc = ldsInvType.GetITemString(llFind,'inv_type_desc')
        Else
                ls_inventory_type_desc = ls_inventory_type
        End If
        
        ls_order_type = w_do.idw_main.getitemstring(1,"ord_type")
        
 
        llFind = ldsOrdType.Find("ord_type = '" + ls_order_type + "'",1,ldsOrdType.RowCount())
        If llFind > 0 Then
                ls_order_type_desc = ldsOrdType.GetITemString(llFind,'ord_type_desc')
        Else
                ls_order_type_desc = ls_order_type
        End If  
                
        
        // 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
        If w_do.idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
        
        //08/04 - PCONKL - Don't print Components that are just placeholders for children being picked
        If w_do.idw_pick.getitemstring(i,"Component_ind") = 'Y'  and w_do.idw_pick.getitemstring(i,"component_type") = 'D' and w_do.idw_pick.getitemNumber(i,"Component_No") = 0 and w_do.idw_pick.getitemstring(i,"l_code") = 'N/A' Then Continue
        If w_do.idw_pick.getitemstring(i,"Component_ind") = '*' Then Continue
        
        //12/05 - PCONKL - for 3COM, We will rollup pick rows to sku, supplier, lot, location and Inv Type and Order Number (3com has order number at the line level)
        //03/28/2010 - dts - for pandora - kitty hawk, We will rollup pick rows to sku, supplier (should always be 'pandora'), po_no, po_no2, lot, container_id, location and Inv Type (not printing separate line for serial #s)
    
        lsFind = "upper(sku) = '" + Upper(ls_sku) + "' and upper(supp_code) = '" + Upper(lsSupplier) + "'"
        lsFind += " and Upper(po_no) = '" + Upper(w_do.idw_pick.getitemstring(i,"po_no")) + "'"
        lsFind += " and Upper(po_no2) = '" + Upper(w_do.idw_pick.getitemstring(i,"po_no2")) + "'"
        lsFind += " and Upper(lot_no) = '" + Upper(w_do.idw_pick.getitemstring(i,"lot_no")) + "'"
        lsFind += " and Upper(container_id) = '" + Upper(w_do.idw_pick.getitemstring(i,"container_id")) + "'"
        lsFind += " and Upper(l_code) = '" + Upper(w_do.idw_pick.getitemstring(i,"l_code")) + "'"
        lsFind += " and Upper(inventory_type) = '" + Upper(ls_inventory_type_desc) + "'"
        lsFind += " and component_no = " + string(w_do.idw_pick.getitemNumber(i,"Component_no"))
                
                
        llFind = w_do.idw_print.Find(lsFind,1,w_do.idw_print.RowCount())
        If llFind > 0 Then
                        
                     j = llFind
                      w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity") + w_do.idw_print.GetItemNumber(llFind,'Quantity'))
                      continue
                        
        Else /* new row */
                        
                    j = w_do.idw_print.InsertRow(0)
                    w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
                      
        End If
               
        w_do.idw_print.setitem(j,"project_id",gs_project) /* 07/02 - Pconkl - some fields may be visible or invisible based on project*/
        w_do.idw_print.setitem(j,"client_name",lsClientName) /* 08/00 PCONKL -show project name instead of code (customer sees the pick ticket)*/
        w_do.idw_print.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        w_do.idw_print.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code"))
        w_do.idw_print.setitem(j,"carrier",lscarrier) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"Priority",String(w_do.idw_main.getitemNumber(1,"Priority"),'####')) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"dm_user_field1",w_do.idw_main.getitemstring(1,"user_field1")) /* 09/03 - PCONKL - 3COM Freight Terms Code */
        w_do.idw_print.setitem(j,"dm_user_field2",w_do.idw_main.getitemstring(1,"user_field2")) /* 09/03 - PCONKL - 3COM Cust Sold TO ID */
        w_do.idw_print.setitem(j,"dm_user_field6",w_do.idw_main.getitemstring(1,"user_field6")) /* 08/04 - PCONKL - 3COM Delivery Note */
        w_do.idw_print.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        w_do.idw_print.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        w_do.idw_print.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        w_do.idw_print.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        w_do.idw_print.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
        w_do.idw_print.setitem(j,"state",w_do.idw_main.getitemstring(1,"state"))
        w_do.idw_print.setitem(j,"zip_code",w_do.idw_main.getitemstring(1,"zip"))
        w_do.idw_print.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
        w_do.idw_print.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
        w_do.idw_print.setitem(j,"request_date",w_do.idw_main.getitemdatetime(1,"request_date"))
        w_do.idw_print.setitem(j,"wh_code",w_do.idw_main.getitemstring(1,"wh_code"))
        w_do.idw_print.setitem(j,"sku",w_do.idw_pick.getitemstring(i,"sku"))
        w_do.idw_print.setitem(j,"sku_parent",w_do.idw_pick.getitemstring(i,"sku_Parent"))
        w_do.idw_print.setitem(j,"supp_code",w_do.idw_pick.getitemstring(i,"supp_code"))
        w_do.idw_print.setitem(j,"serial_no",w_do.idw_pick.getitemstring(i,"serial_no"))
        w_do.idw_print.setitem(j,"lot_no",w_do.idw_pick.getitemstring(i,"lot_no"))
        w_do.idw_print.setitem(j,"po_no",w_do.idw_pick.getitemstring(i,"po_no"))
        w_do.idw_print.setitem(j,"po_no2",w_do.idw_pick.getitemstring(i,"po_no2")) /* 01/02 PCONKL */
        w_do.idw_print.setitem(j,"container_ID",w_do.idw_pick.getitemstring(i,"container_ID")) /* 11/02 PCONKL */
        w_do.idw_print.setitem(j,"expiration_Date",w_do.idw_pick.getitemDateTime(i,"expiration_Date")) /* 11/02 PCONKL */
      
		//TimA 04/26/13 Pandora issue #560 add country of origin
		If gs_Project = 'PANDORA' then
			w_do.idw_print.setitem(j,"country_of_origin",w_do.idw_pick.getitemstring(i,"country_of_origin"))
		End if
		
        //MA 02/08 - Added ord_type to picking list for 3com
        
        w_do.idw_print.setitem(j,"ord_type_desc", ls_order_type_desc)         
        
        // 11/06 - PCONKL - If Component parent placeholder, print "* NO PICK *" instead of "N/A"
        If w_do.idw_pick.getitemstring(i,"Component_Ind") = "Y" and w_do.idw_pick.getitemstring(i,"l_code") = "N/A" Then
                w_do.idw_print.setitem(j,"l_code","* NO PICK *")
        Else
                w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemstring(i,"l_code"))
        End If
        
        w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemdecimal(i,"picking_seq"))
               
        //12/05 - PCONKL - quantity now set above - we may be rolling up rows
        //w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        
        w_do.idw_print.setitem(j,"component_no",w_do.idw_pick.getitemnumber(i,"component_no"))
        w_do.idw_print.setitem(j,"component_ind",w_do.idw_pick.getitemstring(i,"Component_Ind")) /* 08/04 - PCONKL */
        w_do.idw_print.setitem(j,"pick_as",w_do.idw_pick.getitemstring(i,"user_field2")) /* 11/00 PCONKL - show pick iterations*/
        w_do.idw_print.setitem(j,"ship_ref_nbr",w_do.idw_other.getitemstring(1,"ship_ref"))
        w_do.idw_print.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
               
        /* 07/02 - Pconkl - User Field 9 is commodity code for Saltillo - shown on printed Pick LIst (Visible property for fields on Print)*/
        // 01/03 - PCONKL - Only retrieve when SKU has changed
        // 04/04 - TAMCCLANAHAN - Add retrieve when Supplier has changed
        // 12/06 - PCONKL - Added join to supplier for Supplier Name - commented out seperate SQL below
        If ls_SKU <> lsSKUHold or lsSupplier <> lsSupplierHold Then
                
                select description, user_field9, weight_1, user_field13, supp_name, Item_Master.user_field14 
                into     :ls_description , :lsIMUser9, :ld_weight_1, :lsIMUser13, :lsSuppname, :ls_user_field14  //TAM 2006/06/26 added UF13 
                from item_master, Supplier 
                where item_master.Project_id = Supplier.Project_id and Item_master.Supp_Code = Supplier.Supp_Code and
                                item_master.project_id = :ls_project_id and sku = :ls_sku and item_master.supp_code = :lsSupplier;
        
        End If
 
        w_do.idw_print.setitem(j,"weight_1",ld_weight_1) /*09/02 - gap */
       // w_do.idw_print.setitem(j,"description",ls_description)
	   w_do.idw_print.setitem(j,"description", nz( Trim( ls_description ), '') + nz( Trim( ls_user_field14 ), '' ) )	// LTK 20150624  Pandora #973, added ls_user_field14
        w_do.idw_print.setitem(j,"im_user_field9",lsimUser9) /*07/02 - Pconkl */
        
        w_do.idw_print.setitem(j,"im_user_field13",lsimUser13)  // TAM - 2006/06/26 Added UF13 
        w_do.idw_print.setitem(j,"supplier_name",lsSuppName)
        w_do.idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
        
        // 01/05 - PCONKL - for 3COM, the Order and Cust Order Numbers should be at the Line Level instead of header
                 
        //Get from Detail Rec
        //lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        lsFind = "line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
        if llfind > 0 Then
                        
                        If w_do.idw_detail.GetItemString(llFind,'User_Field4') > '' Then
                                w_do.idw_print.setitem(j,"invoice_no",w_do.idw_detail.GetItemString(llFind,'User_Field4'))
                        Else
                                w_do.idw_print.setitem(j,"invoice_no",w_do.is_bolno)
                        End If
                        
                        If w_do.idw_detail.GetItemString(llFind,'User_Field5') > '' Then
                                w_do.idw_print.setitem(j,"cust_ord_no",w_do.idw_detail.GetItemString(llFind,'User_Field5'))
                        Else
                                w_do.idw_print.SetITem(j,"cust_ord_no",w_do.idw_main.GetItemString(1,"cust_order_no")) 
                        End If
                        
      else
                        
                        w_do.idw_print.setitem(j,"invoice_no",w_do.is_bolno)
                        w_do.idw_print.SetItem(j,"cust_ord_no",w_do.idw_main.GetItemString(1,"cust_order_no")) 
                        
      end if
                
      w_do.idw_print.setitem(j,"bol_no",w_do.idw_main.GetItemString(1,'invoice_no'))
 
      // TAM 2006/31/01 We Need to see if the Order Number or Cust Order Number changes.  
      //      If it Does we write various on the pick list
        
       If lsSaveCustOrdNo = '' or lsSaveCUstOrdNo = w_do.idw_print.GetItemString(j,'cust_ord_no') then
                lsSaveCustOrdNo = w_do.idw_print.GetItemString(j,'cust_ord_no')
       Else
                 lsSaveCustOrdNo = "VARIOUS" // only if it changes
       End If
                        
       If lsSaveInvoice = '' or lsSaveInvoice = w_do.idw_print.GetItemString(j,'invoice_no') then
                 lsSaveInvoice = w_do.idw_print.GetItemString(j,'invoice_no')
       Else
                 lsSaveInvoice = "VARIOUS"       // only if it changes
       End If
                        
       // 09/07 - PCONKL - For GLS Warehouses, we want to print the Turnaround time from DD UF7, loading it into IM UF9 since only used by GMM and don't want to modify all the other Print DW's by adding a new column
       If Upper(Left(w_do.idw_Main.GetITemString(1,'wh_Code'),5)) = '3CGLS' and llFind > 0 Then
               w_do.idw_print.setitem(j,"im_user_field9",w_do.idw_detail.GetItemString(llFind,'User_Field7'))
       End If
                
      
     //   End If
        
//TAM 12/13/04 load alt sku from order detail
        
        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
        if llfind > 0 Then
                ls_alt_sku = w_do.idw_detail.getitemString(llFind,"alternate_sku")
        else
                ls_alt_sku = ''
        end if
 
        if ls_alt_sku <> ls_sku Then
                w_do.idw_print.setitem(j,"alt_sku",ls_alt_sku)
        else
                w_do.idw_print.setitem(j,"alt_sku",'')
        end if
        
        w_do.idw_print.setitem(j,"Shipping_Instructions",w_do.idw_main.getitemstring(1,"Shipping_Instructions")) /* 11/03 - PCONKL */
              
        lsSKUHold = ls_SKU
        lsSupplierHold = lsSupplier
        
Next /*pick Rec*/
 
 
// Loop Back through the print rows an update the Ivoice and Cust Order Number

   ll_cnt = w_do.idw_print.rowcount()
    For i = 1 to ll_cnt /*each Print Row */
            w_do.idw_print.setitem(i,"invoice_no",lsSaveInvoice)
            w_do.idw_print.setitem(i,"cust_ord_no",lsSaveCustOrdNo)
    Next    

// 02/01 PCONKL - Filter Pick list to not show components if box is not checked
If w_do.tab_main.tabpage_pick.cbx_show_comp.Checked Then
        w_do.idw_print.SetFilter('')
Else
        w_do.idw_print.SetFilter('sku=sku_parent')   
End If
 
w_do.idw_pick.Filter()
 
w_do.idw_print.Sort()
w_do.idw_print.GroupCalc()
 
OpenWithParm(w_dw_print_options,w_do.idw_print) 

 
if NOT lb_printed_before and message.doubleparm <> -1 then
 
//      UPDATE Delivery_Master SET Pick_List_Printed = 'Y'
//              WHERE do_no = :ls_do_no USING SQLCA;
                        
end if
 
// 08/04 - PCONKL - If any Components were blown out to children on Pick List, print BOM Report
If w_do.idw_Pick.Find("Component_Ind = 'W'",1,w_do.idw_Pick.RowCount()) > 0 Then
        
        If Messagebox(w_do.is_title, 'Do you want to print the "Pick list Bill of Materials Report"?',Question!,YesNo!,1) = 1 Then
                ldsBomPrint = Create DataStore
                ldsBomPrint.DataObject = 'd_do_bom_report'
                ldsBomPrint.SetTransObject(sqlca)
                lsDONO = w_do.idw_main.GetITemString(1,'do_no')
                If      ldsBomPrint.Retrieve(lsDONO) > 0 Then
                        ldsBomPrint.Print()
                End If
        End If
        
End If
 
//08/07 - PCONKL - 3COM RMA warehouses need a placeholder to print for Contract kits if any of the items are contract
If Upper(gs_project) = '3COM_NASH' and upper(Left(w_do.idw_main.GetITemString(1,'wh_code'),5)) = '3CGLS' then
        
        If w_do.idw_Detail.Find("Upper(Left(user_field6,2)) = 'Z3' or Upper(Left(user_field6,2)) = 'Z4'",1,w_do.idw_Detail.RowCount()) > 0 Then /* COntract */
        
                ldsContractPrint = Create Datastore
                ldsContractPrint.dataobject = 'd_3com_rma_contract_Notice'
                ldsContractPrint.Modify("order_number_t.Text = '" + w_do.idw_main.GetItemString(1,"invoice_no") + "'")
                ldsContractPrint.Modify("delivery_note_t.Text = '" + w_do.idw_main.GetItemString(1,"User_Field6") + "'")
                ldsContractPrint.Print()
        
        End If
 
End If /* 3COM RMA*/
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
                w_do.idw_main.SetItem(1,"ord_status","I")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If

REturn 0
end function

public function integer uf_pickprint_pulse ();Long ll_cnt, i, j, llFind, llline_item_no, llDetailFind, llCount, llNotesCount, llNotesPos
String ls_address, lsSUpplier, lsSupplierHold, lsfind, ls_alt_sku, lsNotes
String ls_project_id , ls_sku , lsSKUHold, ls_description, lsCarrier, lsSchedCode, lsSchedDesc
String ls_inventory_type , ls_inventory_type_desc, lsClientName, lsIMUser9,  lsSuppName, lsDONO, lsIMUser13
String lsSaveInvoice, lsSaveCustOrdNo, ls_order_type, ls_order_type_desc
dec{3} ld_weight_1
string lsWH, lsCarPriority //for 3COM Carrier Prioritized Picking routing call
Str_parms       lstrParms
DataStore  ldsInvType,  ldsBOMPrint, ldsContractPrint, ldsOrdType, ldsNotes
datawindowChild ldwc
datastore ldsDeliveryReport
integer li_idx
decimal ld_costcenter
string lsserialno, lslotno, lspono, lspono2, lscontainerid
datetime ldtExpirationDate
string lsLCode, LsCountryOfOrigin, lsRoNo
datetime ld_receipt_date
string ls_Native_Description
string ls_cc3
string ls_user_field3, ls_user_field4, ls_user_field5, ls_user_field6, ls_user_field7, ls_user_field8, ls_user_field9
string ls_user_field10, ls_user_field11, ls_user_field12, ls_user_field13
 
 w_do.tab_main.tabpage_pick.dw_print.dataobject = 'd_picking_prt_pulse' /* assign custom print DW */


// 01/03 - PCONKL - Retrieve Inventory Type descriptions for printed report - only need to do once
ldsInvType = Create Datastore
ldsInvType.DataObject = 'dddw_inventory_Type_by_Project'
ldsInvType.SetTransObject(SQLCA)
ldsInvType.Retrieve(gs_Project)
 
ldsOrdType = Create Datastore
ldsOrdType.DataObject = 'dddw_delivery_order_type'
ldsOrdType.SetTransObject(SQLCA)
ldsOrdType.Retrieve(gs_Project)
 
w_do.idw_print.Reset()
 
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// 08/00 PCONKL Show Client Name on Pick Ticket
Select Client_name into :lsClientName
From    Project
Where project_id = :ls_project_id
Using SQLCA;
 
//For GM_MI_DAT, we want to concatonate Schedule Code (desc) to carrier
lsCarrier = w_do.idw_main.getitemstring(1,"Carrier")
If isnull(LsCarrier) Then lsCarrier = ''
        
//TAM 03/30/2006 Set saved invoice and Cust Order Number to Blank
lsSaveInvoice = ''
lsSaveCustOrdNo = ''

w_do.idw_print.Object.t_costcenter.Y= long(w_do.idw_print.Describe("costcenter.y"))
 
ll_cnt = w_do.idw_pick.rowcount() 
 
For i = 1 to ll_cnt /*each Pick Row */
 
        w_do.SetMicroHelp('Printing pick list for item ' + String(i) + ' of ' + String(ll_cnt))
        
        ls_sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
        
        ls_inventory_type = w_do.idw_pick.getitemstring(i,"inventory_type")
 
        // 01/03 - PCONKL - Load from datastore instead of retriveing every time (move row function doesn't load DDDW)
        llFind = ldsInvType.Find("Inv_Type = '" + ls_inventory_type + "'",1,ldsInvType.RowCount())
        If llFind > 0 Then
                ls_inventory_type_desc = ldsInvType.GetITemString(llFind,'inv_type_desc')
        Else
                ls_inventory_type_desc = ls_inventory_type
        End If
        
        ls_order_type = w_do.idw_main.getitemstring(1,"ord_type")
        
 
        llFind = ldsOrdType.Find("ord_type = '" + ls_order_type + "'",1,ldsOrdType.RowCount())
        If llFind > 0 Then
                ls_order_type_desc = ldsOrdType.GetITemString(llFind,'ord_type_desc')
        Else
                ls_order_type_desc = ls_order_type
        End If  
                
        
        
        // 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
        If w_do.idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
        
        //08/04 - PCONKL - Don't print Components that are just placeholders for children being picked
        If w_do.idw_pick.getitemstring(i,"Component_ind") = 'Y'  and w_do.idw_pick.getitemstring(i,"component_type") = 'D' and w_do.idw_pick.getitemNumber(i,"Component_No") = 0 and w_do.idw_pick.getitemstring(i,"l_code") = 'N/A' Then Continue
        If w_do.idw_pick.getitemstring(i,"Component_ind") = '*' Then Continue
        //
        j = w_do.idw_print.InsertRow(0)
        w_do.idw_print.setitem(j,"costcenter", string(ld_costcenter))
        w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        w_do.idw_print.setitem(j,"project_id",gs_project) /* 07/02 - Pconkl - some fields may be visible or invisible based on project*/
        w_do.idw_print.setitem(j,"client_name",lsClientName) /* 08/00 PCONKL -show project name instead of code (customer sees the pick ticket)*/
        w_do.idw_print.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        w_do.idw_print.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code"))
        w_do.idw_print.setitem(j,"carrier",lscarrier) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"Priority",String(w_do.idw_main.getitemNumber(1,"Priority"),'####')) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"dm_user_field1",w_do.idw_main.getitemstring(1,"user_field1")) /* 09/03 - PCONKL - 3COM Freight Terms Code */
        w_do.idw_print.setitem(j,"dm_user_field2",w_do.idw_main.getitemstring(1,"user_field2")) /* 09/03 - PCONKL - 3COM Cust Sold TO ID */
        w_do.idw_print.setitem(j,"dm_user_field6",w_do.idw_main.getitemstring(1,"user_field6")) /* 08/04 - PCONKL - 3COM Delivery Note */
        w_do.idw_print.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        w_do.idw_print.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        w_do.idw_print.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        w_do.idw_print.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        w_do.idw_print.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
        w_do.idw_print.setitem(j,"state",w_do.idw_main.getitemstring(1,"state"))
        w_do.idw_print.setitem(j,"zip_code",w_do.idw_main.getitemstring(1,"zip"))
        w_do.idw_print.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
        w_do.idw_print.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
  		  w_do.idw_print.setitem(j,"request_date",w_do.idw_main.getitemdatetime(1,"request_date"))
        w_do.idw_print.setitem(j,"wh_code",w_do.idw_main.getitemstring(1,"wh_code"))
        w_do.idw_print.setitem(j,"sku",w_do.idw_pick.getitemstring(i,"sku"))
        w_do.idw_print.setitem(j,"sku_parent",w_do.idw_pick.getitemstring(i,"sku_Parent"))
        w_do.idw_print.setitem(j,"supp_code",w_do.idw_pick.getitemstring(i,"supp_code"))
        w_do.idw_print.setitem(j,"serial_no",w_do.idw_pick.getitemstring(i,"serial_no"))
        w_do.idw_print.setitem(j,"lot_no",w_do.idw_pick.getitemstring(i,"lot_no"))
        w_do.idw_print.setitem(j,"po_no",w_do.idw_pick.getitemstring(i,"po_no"))
        w_do.idw_print.setitem(j,"po_no2",w_do.idw_pick.getitemstring(i,"po_no2")) /* 01/02 PCONKL */
        w_do.idw_print.setitem(j,"container_ID",w_do.idw_pick.getitemstring(i,"container_ID")) /* 11/02 PCONKL */
        w_do.idw_print.setitem(j,"expiration_Date",w_do.idw_pick.getitemDateTime(i,"expiration_Date")) /* 11/02 PCONKL */
        
        //MA 02/08 - Added ord_type to picking list for 3com
        
        w_do.idw_print.setitem(j,"ord_type_desc", ls_order_type_desc)         
        
        // 11/06 - PCONKL - If Component parent placeholder, print "* NO PICK *" instead of "N/A"
        If w_do.idw_pick.getitemstring(i,"Component_Ind") = "Y" and w_do.idw_pick.getitemstring(i,"l_code") = "N/A" Then
                w_do.idw_print.setitem(j,"l_code","* NO PICK *")
        Else
                w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemstring(i,"l_code"))
        End If
        
        // 11/08 - For Diebold CO133 (Slob), we want to sort by Line ITem. Since it it is not already on the printed report, store in picking_seq field.
        If gs_Project = 'DB-CO133' Then
                w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemNumber(i,"Line_Item_No"))
        Else
                w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemdecimal(i,"picking_seq"))
        End If
        
        //12/05 - PCONKL - quantity now set above - we may be rolling up rows
        //w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        
        w_do.idw_print.setitem(j,"component_no",w_do.idw_pick.getitemnumber(i,"component_no"))
        w_do.idw_print.setitem(j,"component_ind",w_do.idw_pick.getitemstring(i,"Component_Ind")) /* 08/04 - PCONKL */
        w_do.idw_print.setitem(j,"pick_as",w_do.idw_pick.getitemstring(i,"user_field2")) /* 11/00 PCONKL - show pick iterations*/
        w_do.idw_print.setitem(j,"ship_ref_nbr",w_do.idw_other.getitemstring(1,"ship_ref"))
        w_do.idw_print.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
               
        /* 07/02 - Pconkl - User Field 9 is commodity code for Saltillo - shown on printed Pick LIst (Visible property for fields on Print)*/
        // 01/03 - PCONKL - Only retrieve when SKU has changed
        // 04/04 - TAMCCLANAHAN - Add retrieve when Supplier has changed
        // 12/06 - PCONKL - Added join to supplier for Supplier Name - commented out seperate SQL below
        If ls_SKU <> lsSKUHold or lsSupplier <> lsSupplierHold Then
                
                select description, user_field9, weight_1, user_field13, supp_name, Native_Description
                into     :ls_description , :lsIMUser9, :ld_weight_1, :lsIMUser13, :lsSuppname, :ls_Native_Description  //TAM 2006/06/26 added UF13 
                from item_master, Supplier 
                where item_master.Project_id = Supplier.Project_id and Item_master.Supp_Code = Supplier.Supp_Code and
                                item_master.project_id = :ls_project_id and sku = :ls_sku and item_master.supp_code = :lsSupplier;
        
        End If
 
        ls_description = trim(ls_description)
                
        w_do.idw_print.setitem(j,"weight_1",ld_weight_1) /*09/02 - gap */
        w_do.idw_print.setitem(j,"description",ls_description)
        w_do.idw_print.setitem(j,"im_user_field9",lsimUser9) /*07/02 - Pconkl */
        
        w_do.idw_print.setitem(j,"im_user_field13",lsimUser13)  // TAM - 2006/06/26 Added UF13 
        w_do.idw_print.setitem(j,"supplier_name",lsSuppName)
        w_do.idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
        
        //w_do.idw_print.setitem(j,"invoice_no",is_bolno)
        w_do.idw_print.setitem(j,"invoice_no",w_do.idw_main.GetItemString(1,"invoice_no"))
        w_do.idw_print.SetITem(j,"cust_ord_no",w_do.idw_main.GetItemString(1,"cust_order_no")) /* 08/00 PCONKL */


        lsDONO = w_do.idw_Main.GetItemString(1,'do_no')
	    llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
	    ls_sku = w_do.idw_pick.getitemstring(i,"sku")
       	lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
         lsSerialNo = w_do.idw_pick.getitemstring(i,"serial_no")
    		lsLotNo = w_do.idw_pick.getitemstring(i,"lot_no")
		lsPoNo =   w_do.idw_pick.getitemstring(i,"po_no")
  		lsPoNo2 =     w_do.idw_pick.getitemstring(i,"po_no2")
  		lsContainerID  =   w_do.idw_pick.getitemstring(i,"container_ID")
		ldtExpirationDate =   w_do.idw_pick.getitemDateTime(i,"expiration_Date")
  		 ls_inventory_type = w_do.idw_pick.getitemstring(i,"inventory_type")
  		 lsLCode = w_do.idw_pick.getitemstring(i,"l_code")
	    	 LsCountryOfOrigin = w_do.idw_pick.getitemstring(i,"country_of_origin")
		

		select ro_no INTO :lsRoNo
		 from Delivery_Picking_Detail
			  Where do_no = :lsDONO and Line_Item_No = :llline_item_no  and
				Sku = :ls_sku and Supp_Code = :lsSupplier and
				Serial_No = :lsSerialNo and  Lot_No = :lsLotNo AND
				Po_No = :lsPoNo and Po_No2 = :lsPoNo2 AND
				Container_ID = :lsContainerID and  Expiration_Date = :ldtExpirationDate AND
				Inventory_Type = :ls_inventory_type AND L_Code = :lsLCode  AND
				Country_of_Origin = :LsCountryOfOrigin
		USING SQLCA;

		IF SQLCA.SQLCode <> 0 THEN
			
			MessageBox ("DB Error 1", SQLCA.SQLErrText )
			
		END IF

		IF NOT IsNull(lsRoNo)  and Trim(lsRoNo) <> '' THEN
		
			select complete_date INTO :ld_receipt_date
			 from Receive_Master
					Where ro_no = :lsRoNo USING SQLCA;
					  
			IF SQLCA.SQLCode <> 0 THEN
				
				MessageBox ("DB Error 2", SQLCA.SQLErrText )
				
			END IF
						
//			 w_do.idw_print.setitem(j,"inbound_date"	, ld_receipt_date)
		
		
			//Get CC3 Number
	
			select top 1 user_field4  INTO :ls_cc3
			 from Receive_Detail
			  Where ro_no = :lsRoNo and 
				Sku = :ls_sku and Supp_Code = :lsSupplier 
			
			USING SQLCA;
	
//	and
//				Country_of_Origin = :LsCountryOfOrigin
//	
	

			IF SQLCA.SQLCode <> 0 THEN
				
				MessageBox ("DB Error 3", SQLCA.SQLErrText )
		
				
			END IF
	
			 w_do.idw_print.setitem(j,"cc3",  ls_cc3)	
			
	
			select top 1 user_field3, user_field4, user_field5, user_field6, user_field7, user_field8,
							user_field9, user_field10, user_field11, user_field12, user_field13
					INTO :ls_user_field3, :ls_user_field4, :ls_user_field5, :ls_user_field6, :ls_user_field7, :ls_user_field8,
							:ls_user_field9, :ls_user_field10, :ls_user_field11, :ls_user_field12, :ls_user_field13
			 from Receive_Putaway
			  Where ro_no = :lsRoNo and 
				Sku = :ls_sku and Supp_Code = :lsSupplier and
				Serial_No = :lsSerialNo and  Lot_No = :lsLotNo AND
				Po_No = :lsPoNo and Po_No2 = :lsPoNo2 AND
				Container_ID = :lsContainerID and  Expiration_Date = :ldtExpirationDate AND
				Inventory_Type = :ls_inventory_type AND L_Code = :lsLCode  AND
				Country_of_Origin = :LsCountryOfOrigin
			USING SQLCA;

			IF SQLCA.SQLCode <> 0 THEN
				
				MessageBox ("DB Error4", SQLCA.SQLErrText )
		
				
			END IF	
	
			w_do.idw_print.setitem(j,"user_field3"	, ls_user_field3)
			w_do.idw_print.setitem(j,"user_field4"	, ls_user_field4)
			w_do.idw_print.setitem(j,"user_field5"	, ls_user_field5)
			w_do.idw_print.setitem(j,"user_field6"	, ls_user_field6)
			w_do.idw_print.setitem(j,"user_field7"	, ls_user_field7)
			w_do.idw_print.setitem(j,"user_field8"	, ls_user_field8)
			w_do.idw_print.setitem(j,"user_field9"	, ls_user_field9)
			w_do.idw_print.setitem(j,"user_field10"	, ls_user_field10)
			w_do.idw_print.setitem(j,"user_field11"	, ls_user_field11)			
			w_do.idw_print.setitem(j,"user_field12"	, ls_user_field12)				
			w_do.idw_print.setitem(j,"user_field13"	, ls_user_field13)	
			
		END IF
				

	

//inbound_custom_declaration_no
//custom_declaration_line_no
//chang_yun_record_item_no
//hs_code

//qty_for_custom_declaration
//uom_of_chang_yun_record
//unit_price_for_custom_declaration				
        
//TAM 12/13/04 load alt sku from order detail
        
        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
        if llfind > 0 Then
                ls_alt_sku = w_do.idw_detail.getitemString(llFind,"alternate_sku")
		
        else
                ls_alt_sku = ''
        end if
 
        if ls_alt_sku <> ls_sku Then
                w_do.idw_print.setitem(j,"alt_sku",ls_alt_sku)
        else
                w_do.idw_print.setitem(j,"alt_sku",'')
        end if
        
        // pvh - 01/12/2006 - amd 
        if gs_project = 'AMS-MUSER' Then
                w_do.idw_print.object.alt_sku[ j ] = w_do.idw_detail.getitemString(llFind,"user_field1")
        end if
        //
 
        w_do.idw_print.setitem(j,"Shipping_Instructions",w_do.idw_main.getitemstring(1,"Shipping_Instructions")) /* 11/03 - PCONKL */
             
        lsSKUHold = ls_SKU
        lsSupplierHold = lsSupplier
        
Next /*pick Rec*/

//// 02/01 PCONKL - Filter Pick list to not show components if box is not checked
//If tab_main.tabpage_pick.cbx_show_comp.Checked Then
//        w_do.idw_print.SetFilter('')
//Else
//        w_do.idw_print.SetFilter('sku=sku_parent')   	
//End If





 
w_do.idw_pick.Filter()
 
w_do.idw_print.Sort()
w_do.idw_print.GroupCalc()

w_do.idw_print.Object.t_costcenter.Y= long(w_do.idw_print.Describe("costcenter.y"))
 
OpenWithParm(w_dw_print_options,w_do.idw_print) 
 
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
                w_do.idw_main.SetItem(1,"ord_status","I")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If


Return 0
end function

public function integer uf_pickprint_franke ();Long ll_cnt, i, j, llFind, llline_item_no, llDetailFind, llCount, llNotesCount, llNotesPos
String ls_address, lsSUpplier, lsSupplierHold, lsfind, ls_alt_sku, lsNotes
String ls_project_id , ls_sku , lsSKUHold, ls_description, lsCarrier, lsSchedCode, lsSchedDesc
String ls_inventory_type , ls_inventory_type_desc, lsClientName, lsIMUser9,  lsSuppName, lsDONO, lsIMUser13
String lsSaveInvoice, lsSaveCustOrdNo, ls_order_type, ls_order_type_desc
dec{3} ld_weight_1
string lsWH, lsCarPriority //for 3COM Carrier Prioritized Picking routing call
Str_parms       lstrParms
DataStore  ldsInvType,  ldsBOMPrint, ldsContractPrint, ldsOrdType, ldsNotes
datawindowChild ldwc
datastore ldsDeliveryReport
integer li_idx
//decimal ld_costcenter
string lsserialno, lslotno, lspono, lspono2, lscontainerid
datetime ldtExpirationDate
string lsLCode, LsCountryOfOrigin, lsRoNo
datetime ld_receipt_date
string ls_Native_Description
string ls_cc3
string ls_user_field3, ls_user_field4, ls_user_field5, ls_user_field6, ls_user_field7, ls_user_field8, ls_user_field9
string ls_user_field10, ls_user_field11, ls_user_field12, lsIMUser17



 w_do.tab_main.tabpage_pick.dw_print.dataobject = 'd_picking_prt_franke' /* assign custom print DW */


//Copied Baseline

// 01/03 - PCONKL - Retrieve Inventory Type descriptions for printed report - only need to do once
ldsInvType = Create Datastore
ldsInvType.DataObject = 'dddw_inventory_Type_by_Project'
ldsInvType.SetTransObject(SQLCA)
ldsInvType.Retrieve(gs_Project)
 
ldsOrdType = Create Datastore
ldsOrdType.DataObject = 'dddw_delivery_order_type'
ldsOrdType.SetTransObject(SQLCA)
ldsOrdType.Retrieve(gs_Project)
 
w_do.idw_print.Reset()
 
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// 08/00 PCONKL Show Client Name on Pick Ticket
Select Client_name into :lsClientName
From    Project
Where project_id = :ls_project_id
Using SQLCA;
 
//For GM_MI_DAT, we want to concatonate Schedule Code (desc) to carrier
lsCarrier = w_do.idw_main.getitemstring(1,"Carrier")
If isnull(LsCarrier) Then lsCarrier = ''
        
//TAM 03/30/2006 Set saved invoice and Cust Order Number to Blank
lsSaveInvoice = ''
lsSaveCustOrdNo = ''

//w_do.idw_print.Object.t_costcenter.Y= long(w_do.idw_print.Describe("costcenter.y"))

ll_cnt = w_do.idw_pick.rowcount() 
 
For i = 1 to ll_cnt /*each Pick Row */
 
        w_do.SetMicroHelp('Printing pick list for item ' + String(i) + ' of ' + String(ll_cnt))
        
        ls_sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
        
        ls_inventory_type = w_do.idw_pick.getitemstring(i,"inventory_type")
 
        // 01/03 - PCONKL - Load from datastore instead of retriveing every time (move row function doesn't load DDDW)
        llFind = ldsInvType.Find("Inv_Type = '" + ls_inventory_type + "'",1,ldsInvType.RowCount())
        If llFind > 0 Then
                ls_inventory_type_desc = ldsInvType.GetITemString(llFind,'inv_type_desc')
        Else
                ls_inventory_type_desc = ls_inventory_type
        End If
        
        ls_order_type = w_do.idw_main.getitemstring(1,"ord_type")
        
 
        llFind = ldsOrdType.Find("ord_type = '" + ls_order_type + "'",1,ldsOrdType.RowCount())
        If llFind > 0 Then
                ls_order_type_desc = ldsOrdType.GetITemString(llFind,'ord_type_desc')
        Else
                ls_order_type_desc = ls_order_type
        End If  
                
        
        
        // 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
        If w_do.idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
        
        //08/04 - PCONKL - Don't print Components that are just placeholders for children being picked
        If w_do.idw_pick.getitemstring(i,"Component_ind") = 'Y'  and w_do.idw_pick.getitemstring(i,"component_type") = 'D' and w_do.idw_pick.getitemNumber(i,"Component_No") = 0 and w_do.idw_pick.getitemstring(i,"l_code") = 'N/A' Then Continue
        If w_do.idw_pick.getitemstring(i,"Component_ind") = '*' Then Continue
        //
        j = w_do.idw_print.InsertRow(0)
//        w_do.idw_print.setitem(j,"costcenter", string(ld_costcenter))
        w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        w_do.idw_print.setitem(j,"project_id",gs_project) /* 07/02 - Pconkl - some fields may be visible or invisible based on project*/
        w_do.idw_print.setitem(j,"client_name",lsClientName) /* 08/00 PCONKL -show project name instead of code (customer sees the pick ticket)*/
        w_do.idw_print.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        w_do.idw_print.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code"))
        w_do.idw_print.setitem(j,"carrier",lscarrier) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"Priority",String(w_do.idw_main.getitemNumber(1,"Priority"),'####')) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"dm_user_field1",w_do.idw_main.getitemstring(1,"user_field1")) /* 09/03 - PCONKL - 3COM Freight Terms Code */
        w_do.idw_print.setitem(j,"dm_user_field2",w_do.idw_main.getitemstring(1,"user_field2")) /* 09/03 - PCONKL - 3COM Cust Sold TO ID */
        w_do.idw_print.setitem(j,"dm_user_field6",w_do.idw_main.getitemstring(1,"user_field6")) /* 08/04 - PCONKL - 3COM Delivery Note */
        w_do.idw_print.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        w_do.idw_print.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        w_do.idw_print.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        w_do.idw_print.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        w_do.idw_print.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
        w_do.idw_print.setitem(j,"state",w_do.idw_main.getitemstring(1,"state"))
        w_do.idw_print.setitem(j,"zip_code",w_do.idw_main.getitemstring(1,"zip"))
        w_do.idw_print.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
        w_do.idw_print.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
  	   w_do.idw_print.setitem(j,"request_date",w_do.idw_main.getitemdatetime(1,"request_date"))
        w_do.idw_print.setitem(j,"wh_code",w_do.idw_main.getitemstring(1,"wh_code"))
        w_do.idw_print.setitem(j,"sku",w_do.idw_pick.getitemstring(i,"sku"))
        w_do.idw_print.setitem(j,"sku_parent",w_do.idw_pick.getitemstring(i,"sku_Parent"))
        w_do.idw_print.setitem(j,"supp_code",w_do.idw_pick.getitemstring(i,"supp_code"))
        w_do.idw_print.setitem(j,"serial_no",w_do.idw_pick.getitemstring(i,"serial_no"))
        w_do.idw_print.setitem(j,"lot_no",w_do.idw_pick.getitemstring(i,"lot_no"))
        w_do.idw_print.setitem(j,"po_no",w_do.idw_pick.getitemstring(i,"po_no"))
        w_do.idw_print.setitem(j,"po_no2",w_do.idw_pick.getitemstring(i,"po_no2")) /* 01/02 PCONKL */
        w_do.idw_print.setitem(j,"container_ID",w_do.idw_pick.getitemstring(i,"container_ID")) /* 11/02 PCONKL */
        w_do.idw_print.setitem(j,"expiration_Date",w_do.idw_pick.getitemDateTime(i,"expiration_Date")) /* 11/02 PCONKL */
	   
		///XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		// BCR 22-SEP-2011: Franke_TH/Baseline modification for Serial No Capture
		CHOOSE CASE w_do.idw_pick.getitemString(i,"serialized_ind") 
			CASE 'Y', 'B'
				w_do.idw_print.setitem(j,"sn_scan", 'Y')
			CASE ELSE
				w_do.idw_print.setitem(j,"sn_scan", 'N')
		END CHOOSE
		///XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        
        //MA 02/08 - Added ord_type to picking list for 3com
        
        w_do.idw_print.setitem(j,"ord_type_desc", ls_order_type_desc)         
        
        // 11/06 - PCONKL - If Component parent placeholder, print "* NO PICK *" instead of "N/A"
        If w_do.idw_pick.getitemstring(i,"Component_Ind") = "Y" and w_do.idw_pick.getitemstring(i,"l_code") = "N/A" Then
                w_do.idw_print.setitem(j,"l_code","* NO PICK *")
        Else
                w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemstring(i,"l_code"))
        End If
        		  
	  //Jxlim 10/08/2010 Changed from request_date to Schedule date on Ship Date field on Picking List report for Phoenix Brands
  	  If gs_Project = 'PHXBRANDS' Then
	 	 w_do.idw_print.setitem(j,"schedule_date",w_do.idw_main.getitemdatetime(1,"schedule_date"))		 
	  End if
	  //Jxlim 10/08/2010 End of Phxbrands changed.
	  
        // 11/08 - For Diebold CO133 (Slob), we want to sort by Line ITem. Since it it is not already on the printed report, store in picking_seq field.
        If gs_Project = 'DB-CO133' Then
                w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemNumber(i,"Line_Item_No"))
        Else
                w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemdecimal(i,"picking_seq"))
        End If
        
        //12/05 - PCONKL - quantity now set above - we may be rolling up rows
        //idw_print.setitem(j,"quantity",idw_pick.getitemnumber(i,"quantity"))
        
        w_do.idw_print.setitem(j,"component_no",w_do.idw_pick.getitemnumber(i,"component_no"))
        w_do.idw_print.setitem(j,"component_ind",w_do.idw_pick.getitemstring(i,"Component_Ind")) /* 08/04 - PCONKL */
        w_do.idw_print.setitem(j,"pick_as",w_do.idw_pick.getitemstring(i,"user_field2")) /* 11/00 PCONKL - show pick iterations*/
        w_do.idw_print.setitem(j,"ship_ref_nbr",w_do.idw_other.getitemstring(1,"ship_ref"))
        w_do.idw_print.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
               
        /* 07/02 - Pconkl - User Field 9 is commodity code for Saltillo - shown on printed Pick LIst (Visible property for fields on Print)*/
        // 01/03 - PCONKL - Only retrieve when SKU has changed
        // 04/04 - TAMCCLANAHAN - Add retrieve when Supplier has changed
        // 12/06 - PCONKL - Added join to supplier for Supplier Name - commented out seperate SQL below
      //  If ls_SKU <> lsSKUHold or lsSupplier <> lsSupplierHold Then
                
					
					 
                select description, user_field9, weight_1, user_field13, supp_name, user_field17
                into     :ls_description , :lsIMUser9, :ld_weight_1, :lsIMUser13, :lsSuppname, :lsIMUser17 //TAM 2006/06/26 added UF13 
                from item_master, Supplier 
                where item_master.Project_id = Supplier.Project_id and Item_master.Supp_Code = Supplier.Supp_Code and
                                item_master.project_id = :ls_project_id and sku = :ls_sku and item_master.supp_code = :lsSupplier;
        
		  	
    //    End If
 
        ls_description = trim(ls_description)
                
        w_do.idw_print.setitem(j,"weight_1",ld_weight_1) /*09/02 - gap */
        w_do.idw_print.setitem(j,"description",ls_description)
        w_do.idw_print.setitem(j,"im_user_field9",lsimUser9) /*07/02 - Pconkl */
        w_do.idw_print.setitem(j,"im_user_field17",lsimUser17) /*07/02 - Pconkl */

        
        w_do.idw_print.setitem(j,"im_user_field13",lsimUser13)  // TAM - 2006/06/26 Added UF13 
        w_do.idw_print.setitem(j,"supplier_name",lsSuppName)
        w_do.idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
        
        //idw_print.setitem(j,"invoice_no",is_bolno)
        w_do.idw_print.setitem(j,"invoice_no",w_do.idw_main.GetItemString(1,"invoice_no"))
        w_do.idw_print.SetITem(j,"cust_ord_no",w_do.idw_main.GetItemString(1,"cust_order_no")) /* 08/00 PCONKL */
            
        
//TAM 12/13/04 load alt sku from order detail
        
        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
        if llfind > 0 Then
                ls_alt_sku = w_do.idw_detail.getitemString(llFind,"alternate_sku")
        else
                ls_alt_sku = ''
        end if
 
        if ls_alt_sku <> ls_sku Then
                w_do.idw_print.setitem(j,"alt_sku",ls_alt_sku)
        else
                w_do.idw_print.setitem(j,"alt_sku",'')
        end if
        
 
        w_do.idw_print.setitem(j,"Shipping_Instructions",w_do.idw_main.getitemstring(1,"Shipping_Instructions")) /* 11/03 - PCONKL */
             
        lsSKUHold = ls_SKU
        lsSupplierHold = lsSupplier
        
Next /*pick Rec*/

// 02/01 PCONKL - Filter Pick list to not show components if box is not checked
If w_do.tab_main.tabpage_pick.cbx_show_comp.Checked Then
        w_do.idw_print.SetFilter('')
Else
        w_do.idw_print.SetFilter('sku=sku_parent')   	
End If





 
w_do.idw_pick.Filter()
 
w_do.idw_print.Sort()
w_do.idw_print.GroupCalc()

//w_do.idw_print.Object.t_costcenter.Y= long(w_do.idw_print.Describe("costcenter.y"))

// 01/08 - PCONKL - show reprint on picklist if already printed
long	llPrintCount
lsDONO = w_do.idw_main.GetITemString(1,'do_no')

Select pick_list_print_Count Into :llPrintCount From delivery_master Where do_no = :lsDONO;
If IsNull(llPrintCount) Then llPrintCount = 0

if llPrintCount > 0 Then
	w_do.idw_print.modify("t_reprint.visible=true")
else
	w_do.idw_print.modify("t_reprint.visible=false")
End If
 
 
OpenWithParm(w_dw_print_options,w_do.idw_print) 
 
 
// 08/04 - PCONKL - If any Components were blown out to children on Pick List, print BOM Report
If w_do.idw_Pick.Find("Component_Ind = 'W'",1,w_do.idw_Pick.RowCount()) > 0 Then
        
        If Messagebox(w_do.is_title, 'Do you want to print the "Pick list Bill of Materials Report"?',Question!,YesNo!,1) = 1 Then
                ldsBomPrint = Create DataStore
                ldsBomPrint.DataObject = 'd_do_bom_report'
                ldsBomPrint.SetTransObject(sqlca)
                lsDONO = w_do.idw_main.GetITemString(1,'do_no')
                If      ldsBomPrint.Retrieve(lsDONO) > 0 Then
                        ldsBomPrint.Print()
                End If
        End If
        
End If
 


If message.doubleparm = 1 then
	
	// 01/14 - PCONKL - update print count
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Delivery_master
	Set pick_list_print_Count = ( :llPrintCount + 1 ) where Do_no = :lsDONO;
	
	Execute Immediate "COMMIT" using SQLCA;
	
	
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
                w_do.idw_main.SetItem(1,"ord_status","I")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If


RETURN 0
end function

public function integer uf_picklist_ws_muser ();Long ll_cnt, i, j, llFind, llline_item_no, llDetailFind, llCount, llNotesCount, llNotesPos
String ls_address, lsSUpplier, lsSupplierHold, lsfind, ls_alt_sku, lsNotes
String ls_project_id , ls_sku , lsSKUHold, ls_description, lsCarrier, lsSchedCode, lsSchedDesc
String ls_inventory_type , ls_inventory_type_desc, lsClientName, lsIMUser9,  lsSuppName, lsDONO, lsIMUser13
String lsSaveInvoice, lsSaveCustOrdNo, ls_order_type, ls_order_type_desc, lsIMUser11, lsIMQty2
dec{3} ld_weight_1
Str_parms       lstrParms
DataStore  ldsInvType,  ldsBOMPrint, ldsContractPrint, ldsOrdType, ldsNotes
datawindowChild ldwc
datastore ldsDeliveryReport
integer li_idx
decimal ld_costcenter
boolean lb_printed_before 
String ls_do_no //MAS - 012811 - ws-muser 
 
   //MAS - 012811 - ws-muser
	
	 w_do.tab_main.tabpage_pick.dw_print.dataobject = 'd_ws_muser_picking_prt' /* assign custom print DW */
	 

     //MAS - 013111 - ws-muser
	//modify visible property for picklist report datawindow - d_picking_prt_ws-muser 
	w_do.tab_main.tabpage_pick.dw_print.Modify("po_no_t.visible=0 po_no.visible=0")
	w_do.tab_main.tabpage_pick.dw_print.Modify("im_user_field9.visible=0")
	w_do.tab_main.tabpage_pick.dw_print.Modify("t_9.visible=0 container_id.visible=0")
	w_do.tab_main.tabpage_pick.dw_print.Modify("t_5.visible=0 t_16.visible=0 t_28.visible=0 pick_as.visible=0")

	//modify x and y property for picklist report datawindow - d_picking_prt_ws-muser
	//ALCOHOL% label and data fields
	w_do.tab_main.tabpage_pick.dw_print.Modify("po_no2_t.visible=1 po_no2.visible=1")		
	w_do.tab_main.tabpage_pick.dw_print.Modify("po_no2_t.x=2194 po_no2_t.y=672'") //changed from 2309 to 2194
	w_do.tab_main.tabpage_pick.dw_print.Modify("po_no2_t.Text='ALCOHOL%/'")
	w_do.tab_main.tabpage_pick.dw_print.Modify("po_no2.x=2194 po_no2.y=8") //changed from 2309 to 2194
    //w_do.tab_main.tabpage_pick.dw_print.Modify("po_no2.Alignment='1'")

	//'EXP. DATE label and data fields
	w_do.tab_main.tabpage_pick.dw_print.Modify("t_10.visible=1 expiration_date.visible=1")
	w_do.tab_main.tabpage_pick.dw_print.Modify("t_10.x=2194 t_10.y=728'") //changed from 2309 to 2194
	w_do.tab_main.tabpage_pick.dw_print.Modify("t_10.Text = 'EXP. DATE'")
	w_do.tab_main.tabpage_pick.dw_print.Modify("expiration_date.x=2194 expiration_date.y=72") //changed from 2309 to 2194	
	
	w_do.tab_main.tabpage_pick.dw_print.Modify("t_12.x=2514 t_12.y=672'") //changed from 2889 to 2514
	w_do.tab_main.tabpage_pick.dw_print.Modify("l_code.x=2514 l_code.y=8'")
	
	w_do.tab_main.tabpage_pick.dw_print.Modify("t_13.x=2514 t_13.y=728'")//changed from 2889 to 2514
	w_do.tab_main.tabpage_pick.dw_print.Modify("inventory_type.x=2889 inventory_type.y=72'")
	
	w_do.tab_main.tabpage_pick.dw_print.Modify("t_14.x=3392 t_14.y=672'")
	w_do.tab_main.tabpage_pick.dw_print.Modify("quantity.x=3392 quantity.y=8'")
	
	w_do.tab_main.tabpage_pick.dw_print.Modify("t_pack_size.x=3200 t_pack_size.y=672'")

	//MAS 022310 - im_user_field11 is uom conversion
    //	1CTN X 6BOT, 1CTN X 12B, 24, 36 etc.
//	w_do.tab_main.tabpage_pick.dw_print.Modify("im_user_field11.x=3237 im_user_field11.y=8'")  
// TAM W&S 2011/06 Increated Size a bit
	w_do.tab_main.tabpage_pick.dw_print.Modify("im_user_field11.x=3150 im_user_field11.y=8'")  
	
	w_do.tab_main.tabpage_pick.dw_print.Modify("qty1_t.x=3689 qty1_t.y=672'")
	w_do.tab_main.tabpage_pick.dw_print.Modify("qty_1.x=3689 qty_1.y=8'")
	w_do.tab_main.tabpage_pick.dw_print.Modify("uom1_t.x=3870 uom1_t.y=672'")
	w_do.tab_main.tabpage_pick.dw_print.Modify("uom_1.x=3870 uom_1.y=8'")
	
	w_do.tab_main.tabpage_pick.dw_print.Modify("qty2_t.x=4100 qty2_t.y=672'")
	w_do.tab_main.tabpage_pick.dw_print.Modify("qty_2.x=4100 qty_2.y=8'")
	w_do.tab_main.tabpage_pick.dw_print.Modify("uom2_t.x=4300 uom2_t.y=672'")
	w_do.tab_main.tabpage_pick.dw_print.Modify("uom_2.x=4300 uom_2.y=8'")
	
	//total label
	w_do.tab_main.tabpage_pick.dw_print.Modify("t_29.x=3300 t_29.y=4'")
	//qty 1 and 2 totals
	w_do.tab_main.tabpage_pick.dw_print.Modify("sum_qty_1.x=3689 sum_qty_1.y=4'")
	w_do.tab_main.tabpage_pick.dw_print.Modify("sum_qty_2.x=4100 sum_qty_2.y=4'")
	//totals	
	w_do.tab_main.tabpage_pick.dw_print.Modify("compute_4.visible=0 compute_6.visible=0")
    //w_do.tab_main.tabpage_pick.dw_print.Modify("compute_4.x=3063 compute_4.y=4'")
 
	ls_do_no = w_do.idw_main.GetItemString(1, "do_no")
 
	ll_cnt = w_do.idw_pick.rowcount()

   //******************************************
	//END MAS - 012811 - ws-muser
  //*******************************************
 

 
 
 
 //*** BASELINE PICK LOGIC ***//
 //***MAS - 012811 - COPIED from w_do located in the delivery.pbl  ***//
 
 
// 01/03 - PCONKL - Retrieve Inventory Type descriptions for printed report - only need to do once
ldsInvType = Create Datastore
ldsInvType.DataObject = 'dddw_inventory_Type_by_Project'
ldsInvType.SetTransObject(SQLCA)
ldsInvType.Retrieve(gs_Project)
 
ldsOrdType = Create Datastore
ldsOrdType.DataObject = 'dddw_delivery_order_type'
ldsOrdType.SetTransObject(SQLCA)
ldsOrdType.Retrieve(gs_Project)
 
w_do.idw_print.Reset()
 
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// 08/00 PCONKL Show Client Name on Pick Ticket
Select Client_name into :lsClientName
From    Project
Where project_id = :ls_project_id
Using SQLCA;
 
//For GM_MI_DAT, we want to concatonate Schedule Code (desc) to carrier
lsCarrier = w_do.idw_main.getitemstring(1,"Carrier")
If isnull(LsCarrier) Then lsCarrier = ''
        
//TAM 03/30/2006 Set saved invoice and Cust Order Number to Blank
lsSaveInvoice = ''
lsSaveCustOrdNo = ''

//MAS - 020111 - ws-muser
//added w_do
w_do.idw_print.Object.t_costcenter.Y= long(w_do.idw_print.Describe("costcenter.y"))


 ll_cnt = w_do.idw_pick.rowcount()
For i = 1 to ll_cnt /*each Pick Row */
 
	//MAS 012811 - ws-muser - added w_do to SetMicroHelp
	w_do.SetMicroHelp('Printing pick list for item ' + String(i) + ' of ' + String(ll_cnt))
        
        ls_sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
        
        ls_inventory_type = w_do.idw_pick.getitemstring(i,"inventory_type")
 
        // 01/03 - PCONKL - Load from datastore instead of retriveing every time (move row function doesn't load DDDW)
        llFind = ldsInvType.Find("Inv_Type = '" + ls_inventory_type + "'",1,ldsInvType.RowCount())
        If llFind > 0 Then
                ls_inventory_type_desc = ldsInvType.GetITemString(llFind,'inv_type_desc')
        Else
                ls_inventory_type_desc = ls_inventory_type
        End If
        
        ls_order_type = w_do.idw_main.getitemstring(1,"ord_type")
        
 
        llFind = ldsOrdType.Find("ord_type = '" + ls_order_type + "'",1,ldsOrdType.RowCount())
        If llFind > 0 Then
                ls_order_type_desc = ldsOrdType.GetITemString(llFind,'ord_type_desc')
        Else
                ls_order_type_desc = ls_order_type
        End If  
                
        // 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
        If w_do.idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
        
        //08/04 - PCONKL - Don't print Components that are just placeholders for children being picked
        If w_do.idw_pick.getitemstring(i,"Component_ind") = 'Y'  and w_do.idw_pick.getitemstring(i,"component_type") = 'D' and w_do.idw_pick.getitemNumber(i,"Component_No") = 0 and w_do.idw_pick.getitemstring(i,"l_code") = 'N/A' Then Continue
        If w_do.idw_pick.getitemstring(i,"Component_ind") = '*' Then Continue
        //
        j = w_do.idw_print.InsertRow(0)
        w_do.idw_print.setitem(j,"costcenter", string(ld_costcenter))
        w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        w_do.idw_print.setitem(j,"project_id",gs_project) /* 07/02 - Pconkl - some fields may be visible or invisible based on project*/
        w_do.idw_print.setitem(j,"client_name",lsClientName) /* 08/00 PCONKL -show project name instead of code (customer sees the pick ticket)*/
        w_do.idw_print.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        w_do.idw_print.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code"))
        w_do.idw_print.setitem(j,"carrier",lscarrier) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"Priority",String(w_do.idw_main.getitemNumber(1,"Priority"),'####')) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"dm_user_field1",w_do.idw_main.getitemstring(1,"user_field1")) /* 09/03 - PCONKL - 3COM Freight Terms Code */
        w_do.idw_print.setitem(j,"dm_user_field2",w_do.idw_main.getitemstring(1,"user_field2")) /* 09/03 - PCONKL - 3COM Cust Sold TO ID */
        w_do.idw_print.setitem(j,"dm_user_field6",w_do.idw_main.getitemstring(1,"user_field6")) /* 08/04 - PCONKL - 3COM Delivery Note */
        w_do.idw_print.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        w_do.idw_print.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        w_do.idw_print.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        w_do.idw_print.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        w_do.idw_print.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
        w_do.idw_print.setitem(j,"state",w_do.idw_main.getitemstring(1,"state"))
        w_do.idw_print.setitem(j,"zip_code",w_do.idw_main.getitemstring(1,"zip"))
        w_do.idw_print.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
        w_do.idw_print.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
  	   w_do.idw_print.setitem(j,"request_date",w_do.idw_main.getitemdatetime(1,"request_date"))
        w_do.idw_print.setitem(j,"wh_code",w_do.idw_main.getitemstring(1,"wh_code"))
        w_do.idw_print.setitem(j,"sku",w_do.idw_pick.getitemstring(i,"sku"))
        w_do.idw_print.setitem(j,"sku_parent",w_do.idw_pick.getitemstring(i,"sku_Parent"))
        w_do.idw_print.setitem(j,"supp_code",w_do.idw_pick.getitemstring(i,"supp_code"))
        w_do.idw_print.setitem(j,"serial_no",w_do.idw_pick.getitemstring(i,"serial_no"))
        w_do.idw_print.setitem(j,"lot_no",w_do.idw_pick.getitemstring(i,"lot_no"))
        w_do.idw_print.setitem(j,"po_no",w_do.idw_pick.getitemstring(i,"po_no"))
  
		/* 01/02 PCONKL */
		//MAS 020311 - ws-muser
		string ls_test
         w_do.idw_print.setitem(j,"po_no2",w_do.idw_pick.getitemstring(i,"po_no2"))
		  ls_test = w_do.idw_pick.getitemstring(i,"po_no2")
		  ls_test = string(ls_test + '%')
		  w_do.idw_print.setitem(j,"po_no2", ls_test)
		  
        w_do.idw_print.setitem(j,"container_ID",w_do.idw_pick.getitemstring(i,"container_ID")) /* 11/02 PCONKL */
        w_do.idw_print.setitem(j,"expiration_Date",w_do.idw_pick.getitemDateTime(i,"expiration_Date")) /* 11/02 PCONKL */
        
        //MA 02/08 - Added ord_type to picking list for 3com
        //MAS - 012811 - added w_do
        w_do.idw_print.setitem(j,"ord_type_desc", ls_order_type_desc)         
        
        // 11/06 - PCONKL - If Component parent placeholder, print "* NO PICK *" instead of "N/A"
	   //MAS - 012810 - added w_do
        If w_do.idw_pick.getitemstring(i,"Component_Ind") = "Y" and w_do.idw_pick.getitemstring(i,"l_code") = "N/A" Then
                w_do.idw_print.setitem(j,"l_code","* NO PICK *")        
		Else
                w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemstring(i,"l_code"))
        End If
        		  
	  //Jxlim 10/08/2010 Changed from request_date to Schedule date on Ship Date field on Picking List report for Phoenix Brands
  	  If gs_Project = 'PHXBRANDS' Then
	 	 w_do.idw_print.setitem(j,"schedule_date",idw_main.getitemdatetime(1,"schedule_date"))		 
	  End if
	  //Jxlim 10/08/2010 End of Phxbrands changed.
	  
        // 2012/06 - we want to sort by Line ITem. Since it it is not already on the printed report, store in picking_seq field.
                w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemNumber(i,"Line_Item_No"))
        
        //12/05 - PCONKL - quantity now set above - we may be rolling up rows
        //w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        
	   //MAS - 012811 - added w_do
        w_do.idw_print.setitem(j,"component_no",w_do.idw_pick.getitemnumber(i,"component_no"))
        w_do.idw_print.setitem(j,"component_ind",w_do.idw_pick.getitemstring(i,"Component_Ind")) /* 08/04 - PCONKL */
        w_do.idw_print.setitem(j,"pick_as",w_do.idw_pick.getitemstring(i,"user_field2")) /* 11/00 PCONKL - show pick iterations*/
        w_do.idw_print.setitem(j,"ship_ref_nbr",w_do.idw_other.getitemstring(1,"ship_ref"))
        w_do.idw_print.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))


        /* 07/02 - Pconkl - User Field 9 is commodity code for Saltillo - shown on printed Pick LIst (Visible property for fields on Print)*/
        // 01/03 - PCONKL - Only retrieve when SKU has changed
        // 04/04 - TAMCCLANAHAN - Add retrieve when Supplier has changed
	   //TAM 2006/06/26 added UF13
       // 12/06 - PCONKL - Added join to supplier for Supplier Name - commented out seperate SQL below	  
       //MAS - 020311 - ws-muser - added user_field11 to select
        If ls_SKU <> lsSKUHold or lsSupplier <> lsSupplierHold Then
                
                select description, user_field9, weight_1, user_field13, supp_name, item_master.user_field11, item_master.qty_2
                into     :ls_description , :lsIMUser9, :ld_weight_1, :lsIMUser13, :lsSuppname, :lsIMUser11, :lsIMQty2   
                from item_master, Supplier
                where item_master.Project_id = Supplier.Project_id and Item_master.Supp_Code = Supplier.Supp_Code and
                                item_master.project_id = :ls_project_id and sku = :ls_sku and item_master.supp_code = :lsSupplier;
        
        End If
		  
        ls_description = trim(ls_description)
                
        w_do.idw_print.setitem(j,"weight_1",ld_weight_1) /*09/02 - gap */
        w_do.idw_print.setitem(j,"description",ls_description)
        w_do.idw_print.setitem(j,"im_user_field9",lsimUser9) /*07/02 - Pconkl */
        
        w_do.idw_print.setitem(j,"im_user_field13",lsimUser13)  // TAM - 2006/06/26 Added UF13 
        w_do.idw_print.setitem(j,"supplier_name",lsSuppName)
        w_do.idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
       //MAS -020311 - ws-muser
	   w_do.idw_print.setitem(j,"im_user_field11", lsIMUser11 )
	   //MAS - 020311 - ws-muser
        w_do.idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
		
        //w_do.idw_print.setitem(j,"invoice_no",is_bolno)
        w_do.idw_print.setitem(j,"invoice_no",w_do.idw_main.GetItemString(1,"invoice_no"))
        w_do.idw_print.SetITem(j,"cust_ord_no",w_do.idw_main.GetItemString(1,"cust_order_no")) /* 08/00 PCONKL */
        
		//TAM 12/13/04 load alt sku from order detail
        
        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
        if llfind > 0 Then
                ls_alt_sku = w_do.idw_detail.getitemString(llFind,"alternate_sku")
        else
                ls_alt_sku = ''
        end if
 
        if ls_alt_sku <> ls_sku Then
                w_do.idw_print.setitem(j,"alt_sku",ls_alt_sku)
        else
                w_do.idw_print.setitem(j,"alt_sku",'')
        end if
        
        // pvh - 01/12/2006 - amd 
        if gs_project = 'AMS-MUSER' Then
                w_do.idw_print.object.alt_sku[ j ] = w_do.idw_detail.getitemString(llFind,"user_field1")
        end if
        //
 
        w_do.idw_print.setitem(j,"Shipping_Instructions",w_do.idw_main.getitemstring(1,"Shipping_Instructions")) /* 11/03 - PCONKL */
       

     //********************BEGIN*********************************************	
	//MAS - 020811 - ws-muser changes for picking report...	
	string ls_ord_qty, ls_ord_uom, ls_qty2, ls_uom2, ls_qty1, ls_uom1, ls_req_qty, ls_uom, ls_delpick_qty
	dec ld_qty2, ld_req_qty,ld_delpick_qty
	int li_ret
	string mod_string, err
	
		
	  lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
if llfind > 0 Then
	
	//MAS 021711 - changed from i to llfind, picking can have more rows then detail due to muliple locations
	// for picking item i.e. 1 detail spaws 2 picking locations
	//correct fields
	ld_req_qty = w_do.idw_detail.getitemdecimal(llfind,"req_qty")
	ls_uom = w_do.idw_detail.getitemstring(llfind,"uom")
	
	ls_ord_qty = w_do.idw_detail.getitemstring(llfind,"user_field1")
	ls_ord_uom = w_do.idw_detail.getitemstring(llfind,"user_field2")
	
	ld_delpick_qty = w_do.idw_pick.getitemdecimal(i,"quantity")

end if

If ls_ord_uom = ls_uom Then
	
	w_do.idw_print.setitem(j,"qty_1", (ld_delpick_qty))			
	w_do.idw_print.setitem(j,"uom_1", ls_ord_uom)

	w_do.idw_print.setitem(j,"qty_2", 0)			
	w_do.idw_print.setitem(j,"uom_2", 'N/A')	
	
	
ElseIf	ls_ord_uom <> ls_uom Then
	//set qty2
	ld_qty2 = ld_delpick_qty / dec(LsIMQty2)
		
	w_do.idw_print.setitem(j,"qty_2", (ld_qty2))	
	w_do.idw_print.setitem(j,"uom_2", ls_ord_uom)	
	
	w_do.idw_print.setitem(j,"qty_1", 0)		
	w_do.idw_print.setitem(j,"uom_1", 'N/A')		
	
End If	
		
//	check values
//	w_do.idw_print.setitem(j,"req_qty",w_do.idw_pick.getitemstring(i,"user_field1"))
	
//*******************END************************************************


		 
////MAS - 012811 - added from uf_pickprint_runnersworld//
//	string sku
//		
//	sku = w_do.w_do.idw_pick.getitemstring(i,"sku")
//     lsSupplier = w_do.w_do.idw_pick.getitemstring(i,"supp_code")
//     llline_item_no = w_do.w_do.idw_pick.getitemnumber(i,"line_item_no")
//       
//     lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
//   	 llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
// 
//        if llfind > 0 Then
//                 w_do.w_do.idw_print.SetItem( i,  "price", w_do.idw_detail.getitemDecimal(llFind,"price"))
//        end if
//                
//       w_do.w_do.idw_print.SetItem( i,  "awb_bol_nbr",w_do.idw_other.getitemstring(1,"awb_bol_no"))
//		 
////***END*** MAS - 012811 - added from uf_pickprint_runnersworld****//	 
		 
		 
		 
        lsSKUHold = ls_SKU
        lsSupplierHold = lsSupplier
        
Next /*pick Rec*/

// 02/01 PCONKL - Filter Pick list to not show components if box is not checked
//MAS - 012811 - ws-muser	added iw_window
If w_do.tab_main.tabpage_pick.cbx_show_comp.Checked Then
        w_do.idw_print.SetFilter('')
Else
        w_do.idw_print.SetFilter('sku=sku_parent')   	
End If
 
w_do.idw_pick.Filter()
 
w_do.idw_print.Sort()
w_do.idw_print.GroupCalc()

// 01/08 - PCONKL - show reprint on picklist if already printed
long	llPrintCount
lsDONO = w_do.idw_main.GetITemString(1,'do_no')

Select pick_list_print_Count Into :llPrintCount From delivery_master Where do_no = :lsDONO;
If IsNull(llPrintCount) Then llPrintCount = 0

if llPrintCount > 0 Then
	w_do.idw_print.modify("t_reprint.visible=true")
else
	w_do.idw_print.modify("t_reprint.visible=false")
End If
 
 
OpenWithParm(w_dw_print_options,w_do.idw_print) 
 
 
if NOT lb_printed_before and message.doubleparm <> -1 then
 
                        
end if
 
// 08/04 - PCONKL - If any Components were blown out to children on Pick List, print BOM Report
If w_do.idw_pick.Find("Component_Ind = 'W'",1,w_do.idw_pick.RowCount()) > 0 Then
        
        If Messagebox(is_title, 'Do you want to print the "Pick list Bill of Materials Report"?',Question!,YesNo!,1) = 1 Then
                ldsBomPrint = Create DataStore
                ldsBomPrint.DataObject = 'd_do_bom_report'
                ldsBomPrint.SetTransObject(sqlca)
                lsDONO = w_do.idw_main.GetITemString(1,'do_no')
                If      ldsBomPrint.Retrieve(lsDONO) > 0 Then
                        ldsBomPrint.Print()
                End If
        End If
        
End If
 

If message.doubleparm = 1 then
	
	// 01/14 - PCONKL - update print count
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Delivery_master
	Set pick_list_print_Count = ( :llPrintCount + 1 ) where Do_no = :lsDONO;
	
	Execute Immediate "COMMIT" using SQLCA;
	
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
                w_do.idw_main.SetItem(1,"ord_status","I")
                ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If


Return 1
end function

public function integer uf_pickprint_babycare ();// This event prints the Picking List which is currently visible on the screen 
// and not from the database

Long ll_cnt, i,j, llline_item_no, x
String lsSUpplier, lsSupplierHold
String ls_project_id , ls_sku , lsSKUHold, ls_description, lsUPC
string ls_l_code, ls_invoice_no, ls_wh_code
String ls_dd_user_field1 
Long  ll_dd_req_qty
string ls_native_description, ls_user_field5, ls_user_field9, ls_user_field4, ls_tel, ls_address_1
string ls_user_field11, ls_user_field13, ls_user_field1, ls_user_field12
date ld_ord_date

string ls_do_no
 
w_do.tab_main.tabpage_pick.dw_print.dataobject = 'd_picking_prt_babycare'	 /* assign custom print DW */
 
ls_do_no = w_do.idw_main.GetItemString(1, "do_no")
 
ll_cnt = w_do.idw_detail.rowcount()
  
w_do.idw_print.Reset()
 
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")

For x = 1 to ll_cnt /*each Detail Row */
 
 	 ls_sku = w_do.idw_detail.getitemstring(x,"sku")
	 lsSupplier = w_do.idw_detail.getitemstring(x,"supp_code") 
  
 	  // Find this sku on the pick list dw - set variable i to this value	
	  i = w_do.idw_pick.Find( 'sku = "' + ls_sku + '" and supp_code = "' + lsSupplier + '"', 1, w_do.idw_pick.RowCount() )
 
 	  IF i = 0 THEN continue  // This should never happen - we should always find the sku on the pick list
 	  
        w_do.SetMicroHelp('Printing pick list for item ' + String(i) + ' of ' + String(ll_cnt))
        
        ls_sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
		 		                  
        // 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
        If w_do.idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
        	  
        //08/04 - PCONKL - Don't print Components that are just placeholders for children being picked
        If w_do.idw_pick.getitemstring(i,"Component_ind") = 'Y'  and w_do.idw_pick.getitemstring(i,"component_type") = 'D' and w_do.idw_pick.getitemNumber(i,"Component_No") = 0 and w_do.idw_pick.getitemstring(i,"l_code") = 'N/A' Then Continue
        If w_do.idw_pick.getitemstring(i,"Component_ind") = '*' Then Continue
        
        j = w_do.idw_print.InsertRow(0)
		  
		ls_invoice_no = w_do.idw_main.GetItemString(1,"invoice_no")
					  
	   	w_do.idw_print.setitem(j,"invoice_no",w_do.idw_main.GetItemString(1,"invoice_no"))
		w_do.idw_print.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
		
		w_do.idw_print.setitem(j,"line_item_no",llline_item_no)
		w_do.idw_print.setitem(j,"sku",ls_sku)
		
		w_do.idw_print.setitem(j,"city",w_do.idw_main.GetItemString(1,"city"))
		w_do.idw_print.setitem(j,"state",w_do.idw_main.GetItemString(1,"state"))
		w_do.idw_print.setitem(j,"address_1",w_do.idw_main.GetItemString(1,"address_1"))
		w_do.idw_print.setitem(j,"user_field4",w_do.idw_main.GetItemString(1,"user_field4"))
		w_do.idw_print.setitem(j,"user_field3",w_do.idw_main.GetItemString(1,"user_field3"))
		w_do.idw_print.setitem(j,"tel",w_do.idw_main.GetItemString(1,"tel"))
		w_do.idw_print.setitem(j,"ord_date",w_do.idw_main.GetItemDateTime(1,"ord_date"))
		w_do.idw_print.setitem(j,"user_field11",w_do.idw_main.GetItemString(1,"user_field11"))
		w_do.idw_print.setitem(j,"user_field13",w_do.idw_main.GetItemString(1,"user_field13"))
		w_do.idw_print.setitem(j,"user_field12",w_do.idw_main.GetItemString(1,"user_field12"))
	//	w_do.idw_print.setitem(j,"user_field1",w_do.idw_main.GetItemString(1,"user_field1"))
		
		// 08/04/11 cawikholm - Get user field 1 and req_qty (quantity) from Delivery Detail - idw_main is getting this value from delivery_master - 
		SELECT user_field1
					,req_qty
		 INTO :ls_dd_user_field1
			    ,:ll_dd_req_qty
		   FROM delivery_detail
		 WHERE do_no = :ls_do_no
		     AND sku = :ls_sku
			AND supp_code = :lsSupplier
			AND line_item_no = :llline_item_no
		 USING SQLCA;
		
		w_do.idw_print.setitem(j,"user_field1",ls_dd_user_field1)
		
		// 08/03/11 cawikholm - Get User Fields & other fields from Delivery Master
		SELECT A.User_Field11
				,A.User_Field13
				,A.User_Field1
				,A.User_field12
				,A.User_Field5
				,A.User_Field9
				,A.User_Field4
				,A.tel
				,A.ord_date
				,A.Address_1
		 INTO :ls_user_field11
		 		,:ls_user_field13
				,:ls_user_field1
				,:ls_user_field12
				,:ls_user_field5
				,:ls_user_field9
				,:ls_user_field4
				,:ls_tel
				,:ld_ord_date
				,:ls_address_1
		  FROM Delivery_Master				A
		 WHERE A.Project_ID = :ls_project_id
			AND A.DO_No = :ls_do_no
		 USING SQLCA;
		
		 // set user fileds on babycare batch picking dw
		 w_do.idw_print.setitem(j,"user_field11",ls_user_field11)
		 w_do.idw_print.setitem(j,"user_field13",ls_user_field13)
 		 w_do.idw_print.setitem(j,"user_field12",ls_user_field12)
		 w_do.idw_print.setitem(j,"user_field5",ls_user_field5)
		 w_do.idw_print.setitem(j,"user_field9",ls_user_field9)
		 w_do.idw_print.setitem(j,"user_field4",ls_user_field4)
			 
		 // set other fields on babycare batch picking dw
		  w_do.idw_print.setitem(j,"tel",ls_tel)
		  w_do.idw_print.setitem(j,"ord_date",ld_ord_date)
		  w_do.idw_print.setitem(j,"address_1",ls_address_1)
				
		// w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemString(i,"l_code"))
		// 08/01/2011 cawikholm - Babycare would like to display the forward pick in the location column.
		// Get this value from the item_forward_pick table.  Also get price of sku.
		// Do not use item_forward_pick table to get location - changed to below  08/03/11
//		SELECT IFP.L_Code
//		  INTO :ls_l_code
//		  FROM ITEM_MASTER				IM
//		 INNER JOIN Delivery_Master		DM
//			 ON IM.Project_ID = DM.Project_ID
//		 INNER JOIN Delivery_Detail		DD
//			 ON DM.DO_No = DD.DO_NO
//			AND IM.SKU = DD.SKU
//			AND IM.Supp_Code = DD.Supp_code
//		  LEFT OUTER JOIN Item_Forward_Pick		IFP
//			 ON IM.Project_ID = IFP.Project_ID
//			AND DD.SKU = IFP.SKU
//			AND DD.Supp_Code = IFP.Supp_Code
//			AND DM.WH_Code = IFP.WH_Code
//		 WHERE IM.Project_ID = :ls_project_id 
//			AND IM.SKU = :ls_SKU
//			AND IM.SUPP_CODE = :lsSupplier
//			AND DM.Invoice_No = :ls_invoice_no
//			AND DD.Line_Item_No = :llline_item_no
//			AND DM.Do_no = :ls_do_no
//		  USING SQLCA;

		ls_wh_code = w_do.idw_main.GetItemString(1,"wh_code")

		// Changed to get foward pick location from location table.  cawikholm 08/03/11
		select l_code
		   into :ls_l_code
		  from location  
		 where WH_Code = :ls_wh_code
			and SKU_Reserved =  :ls_sku
		  using SQLCA;

		// Use forward pick location if not null from above query.  If null then use original value
		IF IsNull( ls_l_code) OR ls_l_code = '' THEN
			
			w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemString(i,"l_code"))
			
		ELSE
			
			w_do.idw_print.setitem(j,"l_code",ls_l_code)
			
		END IF
		
      	w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
			
		//w_do.idw_print.setitem(j,"quantity",ll_dd_req_qty) nxjain commneted 2012-sep-26
                          
        //If ls_SKU <> lsSKUHold or lsSupplier <> lsSupplierHold Then
                
                select native_description, part_upc_Code
                into     :ls_description, :lsUPC
                from item_master
                where  item_master.project_id = :ls_project_id and sku = :ls_sku and item_master.supp_code = :lsSupplier;
        
        //End If
 
        ls_description = trim(ls_description)
        
        w_do.idw_print.setitem(j,"description",ls_description)
		   w_do.idw_print.setitem(j,"upc_code",lsUPC)
		 
        lsSKUHold = ls_SKU
        lsSupplierHold = lsSupplier
        
Next /*pick Rec*/
 
w_do.idw_pick.Filter()
 
w_do.idw_print.Sort()
w_do.idw_print.GroupCalc()
 
OpenWithParm(w_dw_print_options,w_do.idw_print) 
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
                w_do.idw_main.SetItem(1,"ord_status","I")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If


Return 0
end function

public function integer uf_pickprint_nike ();// 12/11 - PCONKL - plageurized from Nike EWMS

Long ll_rowcnt, ll_row, l_quantity, i, update_result,ll_coocnt,ll_rowcoo, llFindRow
DateTime  l_ord_date, ld_need_date,ld_receipt, ldOrdReceiptDate
String l_sku, l_wh_code, l_remark, l_location, lsDONO, l_inv_type, sql_syntax, Errors, lsBatch, lsRONO, lsRONOSave
Long ll_pl_print, j
String ls_plprint, ls_ppl
String ls_coo,ls_deliveryno,ls_sizeline,ls_sizebatch,ls_category,lsGPC,lsuom, lsOrderNbr
String lsmcoo,ls_temp
Boolean lbcoo
String lsrtn
Datastore	ldsPick

lbcoo = False
lsmcoo="Multiple COO for "

lsDONO = w_do.idw_Main.getitemstring(1, "do_no")

// Access Rights
ll_pl_print = 0

Select pick_list_print_Count Into :ll_pl_print From delivery_master Where do_no = :lsDONO;
If IsNull(ll_pl_print) Then ll_pl_print = 0

If ll_pl_print > 0 Then
	If gs_role = "2" Then
		MessageBox("Print PickList", "Only an Admin or Super can reprint the Pick List!",StopSign!)
		Return - 1
	End If
End If

w_do.idw_Print.Dataobject = 'd_picking_prt_nike'

//need Pick Detail instead of Pick so we can get the receipt date (ro_no)
ldsPick = Create Datastore
sql_syntax = " Select  Line_Item_No, Delivery_Picking_Detail.SKU as SKU,delivery_Picking_Detail.l_Code as l_code,  Quantity,  Delivery_Picking_Detail.Inventory_Type as Inventory_Type, Country_of_Origin, ro_no, Expiration_date, Item_Master.Grp as Grp, delivery_picking_detail.lot_no as Stock_cat "
sql_syntax += " FRom delivery_picking_detail, Item_MAster "
sql_Syntax += " Where ITem_Master.Project_id = '" + gs_project + "'  and Delivery_picking_Detail.SKU = Item_MAster.SKU "
sql_syntax += " and Delivery_Picking_Detail.supp_Code = Item_Master.supp_Code and do_no = '" + lsDONO + "'"
sql_Syntax += " Order by  DElivery_Picking_Detail.Line_Item_No;"

ldsPick.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
	messagebox("Print PickList", "Unable to retrieve Picking information. Unable to print PickList")
     RETURN - 1
END IF

ldsPick.SetTransObject(SQLCA)
ll_rowcnt = ldsPick.retrieve()

If ll_rowcnt = 0 Then
	MessageBox("Print PickList"," No records to print!")
	Return -1
End If

SetPointer(HourGlass!)
w_do.idw_Print.Reset()

If ll_pl_print <= 0 Then
	ls_plprint = ""
Else
	ls_plprint = "(Re-print #" + trim(string(ll_pl_print)) + ")"
End If

lsOrderNbr = w_do.idw_Main.getitemstring(1, "invoice_no")
l_ord_date = w_do.idw_Main.getitemdatetime(1, "ord_date")
l_wh_code = w_do.idw_Main.getitemstring(1, "wh_code")
lsBatch = w_do.idw_Main.getitemString(1, "Line_Of_Business") /* really Batch Nbr*/
ld_need_date = w_do.idw_Main.GetItemDatetime(1, "request_date")

//We need to loop through Delivery_Picking_Detail so we can get the Receipt Date (by ro_no)

For i = 1 to ll_rowcnt /* Each Pick Detail Row */

	l_sku = ldsPick.getitemstring(i,"sku")
	l_location = ldsPick.getitemstring(i,"l_code")
	l_quantity = ldsPick.getitemnumber(i,"quantity")
	l_inv_type = ldsPick.getitemstring(i,"inventory_type")
//	ls_sizeline = ldsPick.getitemstring(i,"size_line")
//	ls_sizebatch = ldsPick.getitemstring(i,"size_batch")
	ls_category = ldsPick.getitemstring(i,"Stock_cat") /* lot_no */
	ls_coo = ldsPick.getitemstring(i,"country_of_Origin")
	lsGPC = ldsPick.getitemstring(i,"Grp") /* Item_Master.GRP */
	lsRONO = ldsPick.getitemstring(i,"ro_no") 
	
	// Receipt date will either be stored in Expiration Date for existing EWMS inventory loaded in SIMS (no Receive Master record) or from Receive_Master.Complete_Date for Inventory received in SIMS
	ld_receipt = ldsPick.getitemdatetime(i,"expiration_date") /* Expiration DT will contain the original Receipt date for stock converted from EWMS since there won't be a Receive_Master to get the Receipt Date from*/
	If ld_receipt < DateTime("12/31/2999") Then
	Else
		
		If lsRONO <> lsRONOSave Then
			
			Select complete_Date into :ldOrdReceiptDate
			From Receive_Master
			Where ro_no = :lsRONO;
			
			lsRONOSave = lsRONO
			
		End If
		
		ld_receipt = ldOrdReceiptDate
		
	End If
	
	//From Delivery Detail...
	llFindRow = w_do.idw_Detail.Find("Line_Item_No = " + String(ldsPIck.GetITemNUmber(i,"line_Item_No")) + " and upper(SKU) = '" + upper(l_sku) + "'",1, w_do.idw_Detail.RowCount())
	If llFindRow > 0 Then
		ls_deliveryno = w_do.idw_detail.getitemstring(llFindRow,"User_Field1")
		lsuom = w_do.idw_detail.getitemstring(llFindRow,"UOM")
	End If
	
//	select count(distinct coo) into :ll_coocnt from content where sku=:l_sku;
//	
//	If ll_coocnt > 1 then
//		lbcoo = True
//		 Messagebox(win_title, "Multiple COO for SKU :" + l_sku)
//		 ll_rowcoo = dw_coo.retrieve(l_sku)
//		 For j = 1 to ll_rowcoo
//			 ls_temp = ls_temp + dw_coo.getitemstring(j,"coo")+ " "
//		 Next
//		 lsmcoo = lsmcoo + l_sku +": " + ls_temp + ";"
//	end if
//	
//	select GPC,unit_2 into :lsGPC, :lsuom from item_master where sku=:l_sku;
	
	ll_row = w_do.idw_Print.InsertRow(0)
	w_do.idw_Print.SetItem(ll_row, "PL_Print", ls_plprint)
	w_do.idw_Print.setitem(ll_row, "do_no",lsOrderNbr) /* This is really the Order Nbr, not the do_no*/
	w_do.idw_Print.Setitem(ll_row, "need_date", ld_need_date)
	w_do.idw_Print.setitem(ll_row,"ord_date",l_ord_date)
	w_do.idw_Print.setitem(ll_row,"wh_code",l_wh_code)
	w_do.idw_Print.setitem(ll_row,"ship_cost",lsBatch)
	w_do.idw_Print.setitem(ll_row,"sku",l_sku)
	w_do.idw_Print.setitem(ll_row,"l_code",l_location)
	w_do.idw_Print.setitem(ll_row,"quantity",l_quantity)
	w_do.idw_Print.setitem(ll_row,"delivery_no",ls_deliveryno)
//	w_do.idw_Print.setitem(ll_row,"size_line",ls_sizeline)
//	w_do.idw_Print.setitem(ll_row,"size_batch",ls_sizebatch)
	w_do.idw_Print.setitem(ll_row,"stock_category",ls_category)
	w_do.idw_Print.setitem(ll_row,"coo",ls_coo)
	w_do.idw_Print.setitem(ll_row,"Receipt_date",ld_receipt)
	w_do.idw_Print.setitem(ll_row,"div",lsGPC)
	w_do.idw_Print.setitem(ll_row,"uom",lsuom)
	w_do.idw_Print.setitem(ll_row,"cust_code",w_do.idw_Main.getitemstring(1,"cust_code"))
	w_do.idw_Print.setitem(ll_row,"cust_name",w_do.idw_Main.getitemstring(1,"cust_name"))
	
	w_do.idw_Print.setitem(ll_row,"delivery_address",w_do.idw_Main.getitemstring(1,"address_1"))
	w_do.idw_Print.setitem(ll_row,"delivery_address1",w_do.idw_Main.getitemstring(1,"address_2"))
	w_do.idw_Print.setitem(ll_row,"delivery_address2",w_do.idw_Main.getitemstring(1,"address_3"))
	w_do.idw_Print.setitem(ll_row,"delivery_address3",w_do.idw_Main.getitemstring(1,"address_4"))
   w_do.idw_Print.setitem(ll_row,"city",w_do.idw_Main.getitemstring(1,"city"))

	w_do.idw_Print.setitem(ll_row,"inventory_type", l_inv_type)
	
	If lbcoo = True Then
		w_do.idw_Print.setitem(ll_row,"remark",w_do.idw_Main.getitemstring(1,"remark")+ " / " + lsmcoo)
	else
		w_do.idw_Print.setitem(ll_row,"remark",w_do.idw_Main.getitemstring(1,"remark"))
	end if
	
//	w_do.idw_Print.setitem(ll_row,"batch_no",w_do.idw_Main.getitemstring(1,"batch_no"))
	w_do.idw_Print.setitem(ll_row,"goodsissuedate",w_do.idw_Main.getitemdatetime(1,"schedule_date"))
	
Next /* Next Pick Detail Row*/

Open(w_nike_pick_sort_option)

lsrtn =  message.StringParm 

CHOOSE CASE lsrtn
	CASE "S"
		w_do.idw_Print.setsort("div a, sku a, l_code a")
	CASE "L"
		w_do.idw_Print.setsort("div a, l_code  a, sku a")
	CASE ELSE
		Return -1
END CHOOSE
	


w_do.idw_Print.Sort()
w_do.idw_Print.GroupCalc ( )

//MessageBox ("ok", w_do.idw_Print.Describe("Datawindow.Table.sort"))

//Ver :	EWMS 2.0 090326 Start

Long ll_sum_ap = 0 ,ll_sum_ft = 0 ,ll_sum_eq = 0 ,ll_sum_pop = 0 ,ll_rwcnt
String ls_div
ll_rwcnt = w_do.idw_Print.rowcount()
For i = 1 to ll_rwcnt
	ls_div = w_do.idw_Print.getitemstring(i,'div')
	l_quantity = w_do.idw_Print.getitemnumber(i,'quantity')
	Choose Case ls_div
		Case '10'
		ll_sum_ap=ll_sum_ap + l_quantity
		Case '20'
		ll_sum_ft=ll_sum_ft + l_quantity
		Case '30'
		ll_sum_eq=ll_sum_eq + l_quantity
		Case '40'
		ll_sum_pop=ll_sum_pop + l_quantity
	End Choose
next

w_do.idw_Print.setitem(1,"sum_ap",ll_sum_ap)
w_do.idw_Print.setitem(1,"sum_ft",ll_sum_ft)
w_do.idw_Print.setitem(1,"sum_eq",ll_sum_eq)
w_do.idw_Print.setitem(1,"sum_pop",ll_sum_pop)
w_do.idw_Print.setitem(1,"sum_tot",ll_sum_ap + ll_sum_ft + ll_sum_eq + ll_sum_pop)

//Ver :	EWMS 2.0 090326 End

OpenWithParm(w_dw_print_options,w_do.idw_Print)

If message.doubleparm = 1 then
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Delivery_master
	Set pick_list_print_Count = ( :ll_pl_print + 1 ) where Do_no = :lsDONO;
	
	Execute Immediate "COMMIT" using SQLCA;
	
	If w_do.idw_Main.GetItemString(1,"ord_status") = "N" or &
		w_do.idw_Main.GetItemString(1,"ord_status") = "P" 			Then 
		
			w_do.idw_Main.SetItem(1,"ord_status","I")
			ib_changed = True
			w_do.trigger event ue_save()
			
	End If
	
End If

Return 0
end function

public function integer uf_pickprint_riverbed ();Long ll_cnt, i, j, llFind, llline_item_no, llDetailFind, llCount, llNotesCount, llNotesPos, llBomFindRow, llBomCount

String ls_address, lsSUpplier, lsSupplierHold, lsfind, ls_alt_sku, lsNotes
String ls_project_id , ls_sku , lsSKUHold, ls_description, lsCarrier, lsSchedCode, lsSchedDesc
String ls_inventory_type , ls_inventory_type_desc, lsClientName, lsIMUser9,  lsSuppName, lsDONO, lsIMUser13
String lsSaveInvoice, lsSaveCustOrdNo, ls_order_type, ls_order_type_desc, lsBomFind,ls_line_item_notes, dwsyntax_str, lsSQL, presentation_str, lsErrText
dec{3} ld_weight_1
string lsWH, lsCarPriority //for 3COM Carrier Prioritized Picking routing call
Str_parms       lstrParms
DataStore  ldsInvType,  ldsBOMPrint, ldsContractPrint, ldsOrdType, ldsNotes
datawindowChild ldwc
datastore ldsDeliveryReport, ldsBOM
integer li_idx



 w_do.tab_main.tabpage_pick.dw_print.dataobject = 'd_picking_prt_riverbed' /* assign custom print DW */


//Copied Baseline

// 01/03 - PCONKL - Retrieve Inventory Type descriptions for printed report - only need to do once
ldsInvType = Create Datastore
ldsInvType.DataObject = 'dddw_inventory_Type_by_Project'
ldsInvType.SetTransObject(SQLCA)
ldsInvType.Retrieve(gs_Project)
 
ldsOrdType = Create Datastore
ldsOrdType.DataObject = 'dddw_delivery_order_type'
ldsOrdType.SetTransObject(SQLCA)
ldsOrdType.Retrieve(gs_Project)
 
lsDONO = w_do.idw_main.GetITemString(1,'do_no')
 
// Children components for Child Req Qty and Item Desc
ldsBOM = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select Line_Item_No, sku_parent, sku_child, child_qty, Delivery_Bom.user_field3, Delivery_Bom.user_field2, Description from Delivery_Bom, Item_MAster " 
lsSQL += " Where do_no = '" + lsDONO + "' and Delivery_Bom.Project_ID = Item_master.Project_ID and sku_child = sku and supp_code_Child = supp_code "

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsBOM.Create( dwsyntax_str, lsErrText)
ldsBOM.SetTransObject(SQLCA)
ldsBom.Retrieve()
llBomCount =ldsBom.RowCount()

w_do.idw_print.Reset()
 
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// 08/00 PCONKL Show Client Name on Pick Ticket
Select Client_name into :lsClientName
From    Project
Where project_id = :ls_project_id
Using SQLCA;
 
lsCarrier = w_do.idw_main.getitemstring(1,"Ship_ref")
If isnull(LsCarrier) Then lsCarrier = ''
        
//TAM 03/30/2006 Set saved invoice and Cust Order Number to Blank
lsSaveInvoice = ''
lsSaveCustOrdNo = ''


ll_cnt = w_do.idw_pick.rowcount() 
 
For i = 1 to ll_cnt /*each Pick Row */
 
        w_do.SetMicroHelp('Printing pick list for item ' + String(i) + ' of ' + String(ll_cnt))
        
        ls_sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
        
        ls_inventory_type = w_do.idw_pick.getitemstring(i,"inventory_type")
 
        // 01/03 - PCONKL - Load from datastore instead of retriveing every time (move row function doesn't load DDDW)
        llFind = ldsInvType.Find("Inv_Type = '" + ls_inventory_type + "'",1,ldsInvType.RowCount())
        If llFind > 0 Then
                ls_inventory_type_desc = ldsInvType.GetITemString(llFind,'inv_type_desc')
        Else
                ls_inventory_type_desc = ls_inventory_type
        End If
        
        ls_order_type = w_do.idw_main.getitemstring(1,"ord_type")
        
 
        llFind = ldsOrdType.Find("ord_type = '" + ls_order_type + "'",1,ldsOrdType.RowCount())
        If llFind > 0 Then
                ls_order_type_desc = ldsOrdType.GetITemString(llFind,'ord_type_desc')
        Else
                ls_order_type_desc = ls_order_type
        End If  
                
        
        
        // 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
        If w_do.idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
        
        //08/04 - PCONKL - Don't print Components that are just placeholders for children being picked
        If w_do.idw_pick.getitemstring(i,"Component_ind") = 'Y'  and w_do.idw_pick.getitemstring(i,"component_type") = 'D' and w_do.idw_pick.getitemNumber(i,"Component_No") = 0 and w_do.idw_pick.getitemstring(i,"l_code") = 'N/A' Then Continue
        If w_do.idw_pick.getitemstring(i,"Component_ind") = '*' Then Continue
        //
        j = w_do.idw_print.InsertRow(0)
        w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        w_do.idw_print.setitem(j,"project_id",gs_project) /* 07/02 - Pconkl - some fields may be visible or invisible based on project*/
        w_do.idw_print.setitem(j,"client_name",lsClientName) /* 08/00 PCONKL -show project name instead of code (customer sees the pick ticket)*/
        w_do.idw_print.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        w_do.idw_print.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code"))
        w_do.idw_print.setitem(j,"carrier",lscarrier) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"Priority",String(w_do.idw_main.getitemNumber(1,"Priority"),'####')) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"dm_user_field1",w_do.idw_main.getitemstring(1,"user_field1")) /* 09/03 - PCONKL - 3COM Freight Terms Code */
        w_do.idw_print.setitem(j,"dm_user_field2",w_do.idw_main.getitemstring(1,"user_field2")) /* 09/03 - PCONKL - 3COM Cust Sold TO ID */
        w_do.idw_print.setitem(j,"dm_user_field4",w_do.idw_main.getitemstring(1,"user_field4")) /* 08/04 - PCONKL - 3COM Delivery Note */
        w_do.idw_print.setitem(j,"dm_user_field5",w_do.idw_main.getitemstring(1,"user_field5")) /* 08/04 - PCONKL - 3COM Delivery Note */
        w_do.idw_print.setitem(j,"dm_user_field6",w_do.idw_main.getitemstring(1,"user_field6")) /* 08/04 - PCONKL - 3COM Delivery Note */
        w_do.idw_print.setitem(j,"dm_user_field7",w_do.idw_main.getitemstring(1,"user_field7")) /* 08/04 - PCONKL - 3COM Delivery Note */
        w_do.idw_print.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        w_do.idw_print.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        w_do.idw_print.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        w_do.idw_print.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        w_do.idw_print.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
        w_do.idw_print.setitem(j,"state",w_do.idw_main.getitemstring(1,"state"))
        w_do.idw_print.setitem(j,"zip_code",w_do.idw_main.getitemstring(1,"zip"))
        w_do.idw_print.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
        w_do.idw_print.setitem(j,"contact_person",w_do.idw_main.getitemstring(1,"contact_person"))
        w_do.idw_print.setitem(j,"tel",w_do.idw_main.getitemstring(1,"tel"))
        w_do.idw_print.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
  	   w_do.idw_print.setitem(j,"request_date",w_do.idw_main.getitemdatetime(1,"request_date"))
        w_do.idw_print.setitem(j,"wh_code",w_do.idw_main.getitemstring(1,"wh_code"))
        w_do.idw_print.setitem(j,"sku",w_do.idw_pick.getitemstring(i,"sku"))
        w_do.idw_print.setitem(j,"sku_parent",w_do.idw_pick.getitemstring(i,"sku_Parent"))
        w_do.idw_print.setitem(j,"supp_code",w_do.idw_pick.getitemstring(i,"supp_code"))
        w_do.idw_print.setitem(j,"serial_no",w_do.idw_pick.getitemstring(i,"serial_no"))
        w_do.idw_print.setitem(j,"lot_no",w_do.idw_pick.getitemstring(i,"lot_no"))
        w_do.idw_print.setitem(j,"po_no",w_do.idw_pick.getitemstring(i,"po_no"))
        w_do.idw_print.setitem(j,"po_no2",w_do.idw_pick.getitemstring(i,"po_no2")) /* 01/02 PCONKL */
        w_do.idw_print.setitem(j,"container_ID",w_do.idw_pick.getitemstring(i,"container_ID")) /* 11/02 PCONKL */
        w_do.idw_print.setitem(j,"expiration_Date",w_do.idw_pick.getitemDateTime(i,"expiration_Date")) /* 11/02 PCONKL */
	   
		///XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		// BCR 22-SEP-2011: Franke_TH/Baseline modification for Serial No Capture
		CHOOSE CASE w_do.idw_pick.getitemString(i,"serialized_ind") 
			CASE 'O', 'B'
				w_do.idw_print.setitem(j,"sn_scan", 'Y')
			CASE ELSE
				w_do.idw_print.setitem(j,"sn_scan", 'N')
		END CHOOSE
		///XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        
        //MA 02/08 - Added ord_type to picking list for 3com
        
        w_do.idw_print.setitem(j,"ord_type_desc", ls_order_type_desc)         
        
        // 11/06 - PCONKL - If Component parent placeholder, print "* NO PICK *" instead of "N/A"
        If w_do.idw_pick.getitemstring(i,"Component_Ind") = "Y" and w_do.idw_pick.getitemstring(i,"l_code") = "N/A" Then
                w_do.idw_print.setitem(j,"l_code","* NO PICK *")
        Else
                w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemstring(i,"l_code"))
        End If
        		  
	  //Jxlim 10/08/2010 Changed from request_date to Schedule date on Ship Date field on Picking List report for Phoenix Brands
  	  If gs_Project = 'PHXBRANDS' Then
	 	 w_do.idw_print.setitem(j,"schedule_date",w_do.idw_main.getitemdatetime(1,"schedule_date"))		 
	  End if
	  //Jxlim 10/08/2010 End of Phxbrands changed.
	  
        // 11/08 - For Diebold CO133 (Slob), we want to sort by Line ITem. Since it it is not already on the printed report, store in picking_seq field.
        If gs_Project = 'DB-CO133' Then
                w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemNumber(i,"Line_Item_No"))
        Else
                w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemdecimal(i,"picking_seq"))
        End If
        
        //12/05 - PCONKL - quantity now set above - we may be rolling up rows
        //idw_print.setitem(j,"quantity",idw_pick.getitemnumber(i,"quantity"))
        
        w_do.idw_print.setitem(j,"component_no",w_do.idw_pick.getitemnumber(i,"component_no"))
        w_do.idw_print.setitem(j,"component_ind",w_do.idw_pick.getitemstring(i,"Component_Ind")) /* 08/04 - PCONKL */
        w_do.idw_print.setitem(j,"pick_as",w_do.idw_pick.getitemstring(i,"user_field2")) /* 11/00 PCONKL - show pick iterations*/
        w_do.idw_print.setitem(j,"ship_ref_nbr",w_do.idw_other.getitemstring(1,"ship_ref"))
        w_do.idw_print.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
        w_do.idw_print.setitem(j,"line_no",w_do.idw_pick.getitemnumber(i,"line_item_no"))
               
        // 04/04 - TAMCCLANAHAN - Add retrieve when Supplier has changed
        // 12/06 - PCONKL - Added join to supplier for Supplier Name - commented out seperate SQL below
					 
		select description, user_field9, weight_1, user_field13
		into     :ls_description , :lsIMUser9, :ld_weight_1, :lsIMUser13
		from item_master
		where item_master.project_id = :ls_project_id and sku = :ls_sku and item_master.supp_code = :lsSupplier;
 
        ls_description = trim(ls_description)
                
        w_do.idw_print.setitem(j,"weight_1",ld_weight_1) /*09/02 - gap */
        w_do.idw_print.setitem(j,"description",ls_description)
        w_do.idw_print.setitem(j,"im_user_field9",lsimUser9) /*07/02 - Pconkl */

        
        w_do.idw_print.setitem(j,"im_user_field13",lsimUser13)  // TAM - 2006/06/26 Added UF13 
        w_do.idw_print.setitem(j,"supplier_name",lsSuppName)
        w_do.idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
        
        //idw_print.setitem(j,"invoice_no",is_bolno)
        w_do.idw_print.setitem(j,"invoice_no",w_do.idw_main.GetItemString(1,"invoice_no"))
        w_do.idw_print.SetITem(j,"cust_ord_no",w_do.idw_main.GetItemString(1,"cust_order_no")) /* 08/00 PCONKL */
            
        
//TAM 12/13/04 load alt sku from order detail
        
        lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
		if llfind > 0 Then
              ls_alt_sku = w_do.idw_detail.getitemString(llFind,"alternate_sku")
			// If detail found then look for the printing instructions in detail line item notes
			ls_line_item_notes = Trim(w_do.idw_detail.getitemstring(llFind, "line_item_notes"))
           	If POS(ls_line_item_notes, "IsShippable:N") > 0 Then
             		w_do.idw_print.setitem(j,"l_code","* NO PICK *")
			End If
           	If POS(ls_line_item_notes, "PreConfigIdent:") > 0 and POS(ls_line_item_notes, "PreConfigIdent:X") <= 0 Then
				 w_do.idw_print.setitem(j,"preconfig",mid(ls_line_item_notes,POS(ls_line_item_notes, "PreConfigIdent:")+15,POS(ls_line_item_notes, ";") - POS(ls_line_item_notes, ":") - 1))
			End If
           	If POS(ls_line_item_notes, "PRINT_PICKSLIP:") > 0 Then
             		w_do.idw_print.setitem(j,"cust_description",mid(ls_line_item_notes,POS(ls_line_item_notes, "PRINT_PICKSLIP:")+15))
//             		w_do.idw_print.setitem(j,"preconfig",mid(ls_line_item_notes,POS(ls_line_item_notes, "PRINT_PICKSLIP:")+15))
			End If

		else
                ls_alt_sku = ''
			// If detail not found then look for the printing instructions in Delivery bom user_field3
         	lsBomFind = "Line_Item_no = " + String(llLine_Item_No) + " and sku_child = '" + ls_sku + "'"
			llBomFindRow = ldsBom.Find(lsBomFind,1,ldsBom.RowCount())
			if llBOMFindRow > 0 Then
			
  				ls_line_item_notes = Trim(ldsBOM.getitemstring(llBomFindRow, "user_field3"))
        		   	If POS(ls_line_item_notes, "IsShippable:N") > 0 Then
        	     		w_do.idw_print.setitem(j,"l_code","* NO PICK *")
				End If
	           	If POS(ls_line_item_notes, "PreConfigIdent:") > 0 and POS(ls_line_item_notes, "PreConfigIdent:X") <= 0 Then
				 w_do.idw_print.setitem(j,"preconfig",mid(ls_line_item_notes,POS(ls_line_item_notes, "PreConfigIdent:")+15,POS(ls_line_item_notes, ";") - POS(ls_line_item_notes, ":") - 1))
				End If
       	   	 	If POS(ls_line_item_notes, "PRINT_PICKSLIP:") > 0 Then
       	      		w_do.idw_print.setitem(j,"cust_description",mid(ls_line_item_notes,POS(ls_line_item_notes, "PRINT_PICKSLIP:")+15))
				End If
			End If
		end if


        if ls_alt_sku <> ls_sku Then
                w_do.idw_print.setitem(j,"alt_sku",ls_alt_sku)
        else
                w_do.idw_print.setitem(j,"alt_sku",'')
        end if
        

  
 
        w_do.idw_print.setitem(j,"Shipping_Instructions",w_do.idw_main.getitemstring(1,"Shipping_Instructions")) /* 11/03 - PCONKL */
             
        lsSKUHold = ls_SKU
        lsSupplierHold = lsSupplier
        
Next /*pick Rec*/

// 02/01 PCONKL - Filter Pick list to not show components if box is not checked
If w_do.tab_main.tabpage_pick.cbx_show_comp.Checked Then
        w_do.idw_print.SetFilter('')
Else
        w_do.idw_print.SetFilter('sku=sku_parent')   	
End If

 
w_do.idw_pick.Filter()
 
w_do.idw_print.Sort()
w_do.idw_print.GroupCalc()


 
OpenWithParm(w_dw_print_options,w_do.idw_print) 
 
 
//// 08/04 - PCONKL - If any Components were blown out to children on Pick List, print BOM Report
//If w_do.idw_Pick.Find("Component_Ind = 'W'",1,w_do.idw_Pick.RowCount()) > 0 Then
//        
//        If Messagebox(w_do.is_title, 'Do you want to print the "Pick list Bill of Materials Report"?',Question!,YesNo!,1) = 1 Then
//                ldsBomPrint = Create DataStore
//                ldsBomPrint.DataObject = 'd_do_bom_report'
//                ldsBomPrint.SetTransObject(sqlca)
//                lsDONO = w_do.idw_main.GetITemString(1,'do_no')
//                If      ldsBomPrint.Retrieve(lsDONO) > 0 Then
//                        ldsBomPrint.Print()
//                End If
//        End If
//        
//End If
 


If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
                w_do.idw_main.SetItem(1,"ord_status","I")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If


RETURN 0
end function

public function integer uf_pickprint_kinderdijk ();// This event prints the Picking List which is currently visible on the screen 
// and not from the database

// 11/09 - PCONKL - Removed logic for loading temp DW and copying to Print DW. This required all custom Pick Lists to be in sync and wasnt really buying us anything.
 
Long ll_cnt, i, j, llFind, llline_item_no, llDetailFind, llCount, llNotesCount, llNotesPos
String ls_address, lsSUpplier, lsSupplierHold, lsfind, ls_alt_sku, lsNotes
String ls_project_id , ls_sku , lsSKUHold, ls_description, lsCarrier, lsSchedCode, lsSchedDesc
String ls_inventory_type , ls_inventory_type_desc, lsClientName, lsIMUser9,  lsSuppName, lsDONO, lsIMUser13
String lsSaveInvoice, lsSaveCustOrdNo, ls_order_type, ls_order_type_desc
dec{3} ld_weight_1
string lsWH, lsCarPriority //for 3COM Carrier Prioritized Picking routing call
Str_parms       lstrParms
DataStore  ldsInvType,  ldsBOMPrint, ldsContractPrint, ldsOrdType, ldsNotes
datawindowChild ldwc
datastore ldsDeliveryReport
integer li_idx
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsNotePos, lsNoteText
integer liNotePos
Long ll_Line_Item_No
String		ls_hazard_cd, ls_hazard_class

 
string ls_do_no, ls_pick_list_printed
boolean lb_printed_before
 

	
w_do.tab_main.tabpage_pick.dw_print.dataobject = 'd_picking_prt_kinderdijk'	 /*Assign custom Print DW */


ls_do_no = w_do.idw_main.GetItemString(1, "do_no")
 
//Notes
ldsNotes = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select Note_seq_No, Note_Text, Line_Item_No from Delivery_Notes Where do_no = '" + ls_do_no + "'"
dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsNotes.Create( dwsyntax_str, lsErrText)
ldsNotes.SetTransObject(SQLCA)

ldsNotes.Retrieve()

ldsNotes.SetSort("Line_Item_No A, Note_Seq_No A")
ldsNotes.Sort() 
 
 
// 01/03 - PCONKL - Retrieve Inventory Type descriptions for printed report - only need to do once
ldsInvType = Create Datastore
ldsInvType.DataObject = 'dddw_inventory_Type_by_Project'
ldsInvType.SetTransObject(SQLCA)
ldsInvType.Retrieve(gs_Project)
 
ldsOrdType = Create Datastore
ldsOrdType.DataObject = 'dddw_delivery_order_type'
ldsOrdType.SetTransObject(SQLCA)
ldsOrdType.Retrieve(gs_Project)
 
 
 
w_do.idw_print.Reset()
 
ls_project_id = w_do.idw_main.getitemstring(1,"project_id")
 
// 08/00 PCONKL Show Client Name on Pick Ticket
Select Client_name into :lsClientName
From    Project
Where project_id = :ls_project_id
Using SQLCA;
 
//For GM_MI_DAT, we want to concatonate Schedule Code (desc) to carrier
lsCarrier = w_do.idw_main.getitemstring(1,"Carrier")
If isnull(LsCarrier) Then lsCarrier = ''
 


 
// 05/09 - PCONKL - For Philips, we want to show Delivery Notes
    
w_do.idw_print.Modify("delivery_notes_t.text = ''")
        
ldsNotes = Create DataStore
ldsNotes.dataobject = 'd_dono_notes'
ldsNotes.SetTransObject(SQLCA)
        
lsDONO = w_do.idw_Main.GetItemString(1,'do_no')
lsNotes = ""
                
llNotesCount = ldsNotes.Retrieve(gs_project,lsDONO)
For llNotesPos = 1 to llNotesCount
                        
	//Only want header notes
     If ldsNotes.GetItemNumber(llNotesPos,'line_item_No') = 0 Then
              lsNotes += ldsNotes.GetITemString(llNotesPos,'note_text') + " "
      End If
                                
 Next
        
 If lsNotes > '' Then
           w_do.idw_print.Modify("delivery_notes_t.text = '" + lsNotes + "'")
 End If
        
        
//TAM 03/30/2006 Set saved invoice and Cust Order Number to Blank
lsSaveInvoice = ''
lsSaveCustOrdNo = ''
 
ll_cnt = w_do.idw_pick.rowcount()
For i = 1 to ll_cnt /*each Pick Row */
 
        w_do.SetMicroHelp('Printing pick list for item ' + String(i) + ' of ' + String(ll_cnt))
        
        ls_sku = w_do.idw_pick.getitemstring(i,"sku")
        lsSupplier = w_do.idw_pick.getitemstring(i,"supp_code")
        llline_item_no = w_do.idw_pick.getitemnumber(i,"line_item_no")
        
        ls_inventory_type = w_do.idw_pick.getitemstring(i,"inventory_type")
 
        // 01/03 - PCONKL - Load from datastore instead of retriveing every time (move row function doesn't load DDDW)
        llFind = ldsInvType.Find("Inv_Type = '" + ls_inventory_type + "'",1,ldsInvType.RowCount())
        If llFind > 0 Then
                ls_inventory_type_desc = ldsInvType.GetITemString(llFind,'inv_type_desc')
        Else
                ls_inventory_type_desc = ls_inventory_type
        End If
        
        ls_order_type = w_do.idw_main.getitemstring(1,"ord_type")
        
 
        llFind = ldsOrdType.Find("ord_type = '" + ls_order_type + "'",1,ldsOrdType.RowCount())
        If llFind > 0 Then
                ls_order_type_desc = ldsOrdType.GetITemString(llFind,'ord_type_desc')
        Else
                ls_order_type_desc = ls_order_type
        End If  
                
		//Line Notes (up to 4 rows - into a single line of text) 
		
		 ll_Line_Item_No = w_do.idw_pick.getitemnumber(i,"line_item_no")
        
		
		liNotePos = 0
		lsNoteText = ""
		llFind = ldsNotes.Find("Line_Item_No = " + string(ll_Line_Item_No),1,ldsNotes.RowCount()) 
		Do While llFind > 0
			
			liNotePos ++
			if not(trim(ldsNotes.GetITemString(llFind,"note_Text")) = '' or isnull(ldsNotes.GetITemString(llFind,"note_Text"))) then
								
				lsNoteText += ldsNotes.GetITemString(llFind,"note_Text") +  char(10)
			
			end if
			
			llFind ++
			If llFind > ldsNotes.RowCount() or liNotePos = 4 Then 
				llFind = 0
			Else
				llFind = ldsNotes.Find("Line_Item_No = " + string(ll_Line_Item_No),llFind,ldsNotes.RowCount())
			End If
			
		Loop
		
		
		  
        
        // 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
        If w_do.idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
        
        //08/04 - PCONKL - Don't print Components that are just placeholders for children being picked
       If w_do.idw_pick.getitemstring(i,"Component_ind") = 'Y'  and w_do.idw_pick.getitemstring(i,"component_type") = 'D' and w_do.idw_pick.getitemNumber(i,"Component_No") = 0 and w_do.idw_pick.getitemstring(i,"l_code") = 'N/A' Then Continue
       If w_do.idw_pick.getitemstring(i,"Component_ind") = '*' Then Continue
                    
       j = w_do.idw_print.InsertRow(0)
	  w_do.idw_print.SetItem(j,"Line_Remarks",lsNoteText)
       w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
       w_do.idw_print.setitem(j,"project_id",gs_project) /* 07/02 - Pconkl - some fields may be visible or invisible based on project*/
        w_do.idw_print.setitem(j,"client_name",lsClientName) /* 08/00 PCONKL -show project name instead of code (customer sees the pick ticket)*/
        w_do.idw_print.setitem(j,"cust_name",w_do.idw_main.getitemstring(1,"cust_name"))
        w_do.idw_print.setitem(j,"cust_code",w_do.idw_main.getitemstring(1,"cust_code"))
        w_do.idw_print.setitem(j,"carrier",lscarrier) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"Priority",String(w_do.idw_main.getitemNumber(1,"Priority"),'####')) /* 09/03 - PCONKL*/
        w_do.idw_print.setitem(j,"dm_user_field1",w_do.idw_main.getitemstring(1,"user_field1")) /* 09/03 - PCONKL - 3COM Freight Terms Code */
        w_do.idw_print.setitem(j,"dm_user_field2",w_do.idw_main.getitemstring(1,"user_field2")) /* 09/03 - PCONKL - 3COM Cust Sold TO ID */
        w_do.idw_print.setitem(j,"dm_user_field6",w_do.idw_main.getitemstring(1,"user_field6")) /* 08/04 - PCONKL - 3COM Delivery Note */
        w_do.idw_print.setitem(j,"delivery_address1",w_do.idw_main.getitemstring(1,"address_1"))
        w_do.idw_print.setitem(j,"delivery_address2",w_do.idw_main.getitemstring(1,"address_2"))
        w_do.idw_print.setitem(j,"delivery_address3",w_do.idw_main.getitemstring(1,"address_3"))
        w_do.idw_print.setitem(j,"delivery_address4",w_do.idw_main.getitemstring(1,"address_4"))
        w_do.idw_print.setitem(j,"city",w_do.idw_main.getitemstring(1,"city"))
        w_do.idw_print.setitem(j,"state",w_do.idw_main.getitemstring(1,"state"))
        w_do.idw_print.setitem(j,"zip_code",w_do.idw_main.getitemstring(1,"zip"))
        w_do.idw_print.setitem(j,"country",w_do.idw_main.getitemstring(1,"country"))
        w_do.idw_print.setitem(j,"ord_date",w_do.idw_main.getitemdatetime(1,"ord_date"))
  	   w_do.idw_print.setitem(j,"request_date",w_do.idw_main.getitemdatetime(1,"request_date"))
        w_do.idw_print.setitem(j,"wh_code",w_do.idw_main.getitemstring(1,"wh_code"))
        w_do.idw_print.setitem(j,"sku",w_do.idw_pick.getitemstring(i,"sku"))
        w_do.idw_print.setitem(j,"sku_parent",w_do.idw_pick.getitemstring(i,"sku_Parent"))
        w_do.idw_print.setitem(j,"supp_code",w_do.idw_pick.getitemstring(i,"supp_code"))
        w_do.idw_print.setitem(j,"serial_no",w_do.idw_pick.getitemstring(i,"serial_no"))
        w_do.idw_print.setitem(j,"lot_no",w_do.idw_pick.getitemstring(i,"lot_no"))
        w_do.idw_print.setitem(j,"po_no",w_do.idw_pick.getitemstring(i,"po_no"))
        w_do.idw_print.setitem(j,"po_no2",w_do.idw_pick.getitemstring(i,"po_no2")) /* 01/02 PCONKL */
        w_do.idw_print.setitem(j,"container_ID",w_do.idw_pick.getitemstring(i,"container_ID")) /* 11/02 PCONKL */
        w_do.idw_print.setitem(j,"expiration_Date",w_do.idw_pick.getitemDateTime(i,"expiration_Date")) /* 11/02 PCONKL */

	// Added alternet sku for Kinderjk project 05/18/2013 nxjain	
		select Alternate_Sku  into :ls_alt_sku from Item_Master
		where SKU = : ls_sku and Project_Id = :gs_project ; 
		
		If not isnull(ls_alt_sku) then 
			w_do.idw_print.setitem(j,"alt_sku",ls_alt_sku)	
		end if 

//End nxjain
        
        //MA 02/08 - Added ord_type to picking list for 3com
        
        w_do.idw_print.setitem(j,"ord_type_desc", ls_order_type_desc)         
        
        // 11/06 - PCONKL - If Component parent placeholder, print "* NO PICK *" instead of "N/A"
        If w_do.idw_pick.getitemstring(i,"Component_Ind") = "Y" and w_do.idw_pick.getitemstring(i,"l_code") = "N/A" Then
                w_do.idw_print.setitem(j,"l_code","* NO PICK *")
        Else
                w_do.idw_print.setitem(j,"l_code",w_do.idw_pick.getitemstring(i,"l_code"))
        End If
        
        // 11/08 - For Diebold CO133 (Slob), we want to sort by Line ITem. Since it it is not already on the printed report, store in picking_seq field.
       // If gs_Project = 'DB-CO133' Then
       //       w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemNumber(i,"Line_Item_No"))
        //Else
                w_do.idw_print.setitem(j,"picking_seq",w_do.idw_pick.getitemdecimal(i,"picking_seq"))
        //End If
        
        //12/05 - PCONKL - quantity now set above - we may be rolling up rows
        //w_do.idw_print.setitem(j,"quantity",w_do.idw_pick.getitemnumber(i,"quantity"))
        
        w_do.idw_print.setitem(j,"component_no",w_do.idw_pick.getitemnumber(i,"component_no"))
        w_do.idw_print.setitem(j,"component_ind",w_do.idw_pick.getitemstring(i,"Component_Ind")) /* 08/04 - PCONKL */
        w_do.idw_print.setitem(j,"pick_as",w_do.idw_pick.getitemstring(i,"user_field2")) /* 11/00 PCONKL - show pick iterations*/
        w_do.idw_print.setitem(j,"ship_ref_nbr",w_do.idw_other.getitemstring(1,"ship_ref"))
        w_do.idw_print.setitem(j,"remark",w_do.idw_main.getitemstring(1,"remark"))
               
        /* 07/02 - Pconkl - User Field 9 is commodity code for Saltillo - shown on printed Pick LIst (Visible property for fields on Print)*/
        // 01/03 - PCONKL - Only retrieve when SKU has changed
        // 04/04 - TAMCCLANAHAN - Add retrieve when Supplier has changed
        // 12/06 - PCONKL - Added join to supplier for Supplier Name - commented out seperate SQL below
        If ls_SKU <> lsSKUHold or lsSupplier <> lsSupplierHold Then
                
                select description, user_field9, weight_1, user_field13, supp_name, Hazard_Cd, Hazard_Class
                into     :ls_description , :lsIMUser9, :ld_weight_1, :lsIMUser13, :lsSuppname,  //TAM 2006/06/26 added UF13 
					 :ls_hazard_cd, :ls_hazard_class		//cawikholm - 06/20/11 Added hazard class and code
                from item_master, Supplier 
                where item_master.Project_id = Supplier.Project_id and Item_master.Supp_Code = Supplier.Supp_Code and
                                item_master.project_id = :ls_project_id and sku = :ls_sku and item_master.supp_code = :lsSupplier;
        
        End If
 
//	   IF lsSupplier = 'SG03' THEN
//			
//			w_do.idw_print.setitem(j,"hazard_cd",ls_hazard_cd)		// 04/27/11	cawikholm
//			w_do.idw_print.setitem(j,"hazard_class",ls_hazard_class)		// 04/27/11	cawikholm
// 
//	   END IF
// 
        ls_description = trim(ls_description)
                
        w_do.idw_print.setitem(j,"weight_1",ld_weight_1) /*09/02 - gap */
        w_do.idw_print.setitem(j,"description",ls_description)
        w_do.idw_print.setitem(j,"im_user_field9",lsimUser9) /*07/02 - Pconkl */
        
        w_do.idw_print.setitem(j,"im_user_field13",lsimUser13)  // TAM - 2006/06/26 Added UF13 
        w_do.idw_print.setitem(j,"supplier_name",lsSuppName)
        w_do.idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
      
		//w_do.idw_print.setitem(j,"invoice_no",is_bolno)
         w_do.idw_print.setitem(j,"invoice_no",w_do.idw_main.GetItemString(1,"invoice_no"))
         w_do.idw_print.SetITem(j,"cust_ord_no",w_do.idw_main.GetItemString(1,"cust_order_no")) /* 08/00 PCONKL */
 
 	//TAM 12/13/04 load alt sku from order detail
   //Alternate SKU 
	
   /*
	lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLine_Item_No)
        llfind = w_do.idw_detail.Find(lsFind,1,w_do.idw_detail.RowCount())
 
        if llfind > 0 Then
                ls_alt_sku = w_do.idw_detail.getitemString(llFind,"alternate_sku")
        else
                ls_alt_sku = ''
        end if   */
   		
			

 
 /*
     if ls_alt_sku <> ls_sku Then
                w_do.idw_print.setitem(j,"alt_sku",ls_alt_sku)
        else
                w_do.idw_print.setitem(j,"alt_sku",'')
        end if
      */
 
        w_do.idw_print.setitem(j,"Shipping_Instructions",w_do.idw_main.getitemstring(1,"Shipping_Instructions")) /* 11/03 - PCONKL */
           
        lsSKUHold = ls_SKU
        lsSupplierHold = lsSupplier
        
Next /*pick Rec*/

// 02/01 PCONKL - Filter Pick list to not show components if box is not checked
If w_do.tab_main.tabpage_pick.cbx_show_comp.Checked Then
        w_do.idw_print.SetFilter('')
Else
        w_do.idw_print.SetFilter('sku=sku_parent')   
End If
 
w_do.idw_pick.Filter()
 
w_do.idw_print.Sort()
w_do.idw_print.GroupCalc()
 
OpenWithParm(w_dw_print_options,w_do.idw_print) 
 
 
if NOT lb_printed_before and message.doubleparm <> -1 then
 
//      UPDATE Delivery_Master SET Pick_List_Printed = 'Y'
//              WHERE do_no = :ls_do_no USING SQLCA;
                        
end if
 
// 08/04 - PCONKL - If any Components were blown out to children on Pick List, print BOM Report
If w_do.idw_Pick.Find("Component_Ind = 'W'",1,w_do.idw_Pick.RowCount()) > 0 Then
        
        If Messagebox(w_do.is_title, 'Do you want to print the "Pick list Bill of Materials Report"?',Question!,YesNo!,1) = 1 Then
                ldsBomPrint = Create DataStore
                ldsBomPrint.DataObject = 'd_do_bom_report'
                ldsBomPrint.SetTransObject(sqlca)
                lsDONO = w_do.idw_main.GetITemString(1,'do_no')
                If      ldsBomPrint.Retrieve(lsDONO) > 0 Then
                        ldsBomPrint.Print()
                End If
        End If
        
End If
 
If message.doubleparm = 1 then
        If w_do.idw_main.GetItemString(1,"ord_status") = "N" or &
                w_do.idw_main.GetItemString(1,"ord_status") = "P" Then 
                w_do.idw_main.SetItem(1,"ord_status","I")
                w_do.ib_changed = TRUE
                w_do.trigger event ue_save()
        End If
End If


Return 0
end function

on u_nvo_custom_picklists.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_custom_picklists.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

