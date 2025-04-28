HA$PBExportHeader$n_warehouse.sru
$PBExportComments$*+Warehouse business logic functions
forward
global type n_warehouse from nonvisualobject
end type
end forward

global type n_warehouse from nonvisualobject
event ue_open ( )
event ue_hide_unused ( datawindow adw )
end type
global n_warehouse n_warehouse

type variables
u_ds ids
u_ds ids_cont
datastore ids_print_em
datastore ids_coo
datastore ids_sku,ids_any, IdsDefaultLoc, ids_inv_type,ids_tables[]
//TimA 03/01/13 Pandora issue #560
datastore ids_Item_Master_Coo

n_cst_common_tables inv_common_tables
str_parms	istr_pickShort
Long	il3comOwnerID

n_ds_content	ids_Comp_Content
decimal	idExistingQty
end variables

forward prototypes
public function integer of_check_serial_nos (ref datawindow adw, ref str_parms lstr)
public function integer of_getprice (ref datawindow adw_main, ref datawindow adw_detail)
public subroutine of_import_do (ref window aw_window, ref datawindow adw_master, ref datawindow adw_detail)
public function boolean of_sendemail (string email_recipient, string email_subject, string email_text)
public function integer of_sortcolumn (datawindow v_dw, integer ii_sortorder)
public function integer of_item_sku (ref string as_prj_id, ref string as_sku)
public function integer of_settab (ref datawindow adw)
public function integer of_settab (ref datawindow adw, ref str_multiparms astr_multiparms, integer ai_strno)
public function string of_tag (ref datawindow adw, integer al_col)
public function integer of_init_prj_ddw (ref datawindow adw, string as_colname)
public function integer of_init ()
public function string of_assignlocation (string a_sku, string a_supp, string a_whcode, string a_type, long al_owner, decimal ad_qty_to_putaway)
public function integer of_item_master (ref string as_prj_id, ref string as_sku, ref string as_supp_code, ref string as_title)
public function integer of_item_master (ref string as_prj_id, ref string as_sku, ref string as_supplier, ref datawindow adw, ref long al_row)
public function integer of_check_blanks (ref datawindow adw, ref long al_row, string as_columnname, ref string as_title)
public function real of_convert (real ar_data, string as_mesure_from, string as_mesure_to)
public function integer of_init_inv_ddw (ref datawindow adw, boolean ab_ship_ind)
public function integer of_print_empty (ref string as_cc_no, string as_table_name)
public function integer of_msg (ref string as_title, integer ai_msg_num)
public subroutine of_ro_serial_nos (ref datawindow adw, ref long al_row)
public function integer of_init_inv_ddw (ref datawindow adw)
public subroutine of_get_owner (datawindow adw)
public subroutine of_hide_unused (datawindow adw)
public function integer of_item_master (ref string as_prj_id, ref string as_sku, ref string as_supp_code)
public function integer of_get_picking_sel ()
public function integer of_batch_picking (ref datawindow ads_order, ref datawindow adw_pick, string as_pick_sort)
public function integer of_anytable (string as_table, ref string as_where)
public function integer of_any_tables_filter (ref datastore ads_any, ref string as_filter)
public function integer of_waybill_no (string carrier)
public function integer of_width_set (datawindow adw, string as_column[], string as_value[], integer ai_org_width[])
public subroutine of_autopicking (ref window aw_window, ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_pick)
public function integer of_check_multipo (ref datawindow adw, ref str_parms lstr)
public function integer of_any_tables (readonly string as_table[], readonly string as_where[])
public subroutine of_ro_multiplepo (str_parms arg_str_parms)
public function integer of_create_comp_child (long alrow, ref datawindow adw_main, ref datawindow adw_pick, ref window aw_window)
public function decimal of_fwd_pick_sort (decimal adreqqty, decimal adcartonqty, ref datastore adscontent)
public function string of_fwd_pick_replenish (ref datastore adscontent, string aspicksort)
public function long of_val_serial_nos (string as_ord_nbr, string as_ord_type, string as_serial_no_entered, long al_edibatch, string as_sku, string as_user_line_item_no, string as_serialized_ind)
public subroutine of_wo_serial_nos (datawindow adw, long al_row)
public function integer of_do_serial_nos (ref datawindow adw, ref long al_row, string as_wh_code)
public function string of_item_master_coo (ref string as_prj_id, ref string as_sku, ref string as_supp_code)
public function string of_get_sscc_bol (string as_project, string as_type)
public function long of_validate_sscc_digit (string as_sscc_no)
public function long of_error_serial_prior_receipt (string as_project_id, string as_sku, string as_serial_no, string as_owner_cd, string as_component_ind, long al_component_no, boolean ab_error_on_exists, boolean ab_skipcomponent, ref string ab_error_message_title, ref string ab_error_message)
public function long of_error_on_serial_no_exists (string as_project_id, string as_sku, string as_serial_no, string as_owner_cd, string as_component_ind, long al_component_no, boolean ab_error_on_exists, boolean ab_skipcomponent, ref string ab_error_message_title, ref string ab_error_message, ref string as_system_no, ref string as_invoice_no)
public function string of_validate_serial_format (string as_sku, string as_serial_no, string as_supp_code)
public function string of_stripoff_firstcol_serialno (string assku, string assuppcode, string asserialno)
public function string of_stripoff_firstcol_checked (string assku, string assuppcode)
public function str_parms of_parse_2d_barcode (string as_serialno)
public function string of_validate_serial_format_ds (string as_sku, string as_serial_no, string as_supp_code)
end prototypes

event ue_open();if  of_init() < 0 THEN
	Messagebox("Error","Error initialising datastores...")
END IF	
end event

public function integer of_check_serial_nos (ref datawindow adw, ref str_parms lstr);String ls_sku, ls_l_code, ls_lot_no, ls_serial_no_c,ls_serial_no
char ls_inventory_type
integer i,j
long ll_ret= 1,ll_status,ll_upbound, ll_row

str_parms lstrparms

FOR i= 1 TO adw.rowcount()
	IF ll_ret = -1 THEN exit
	ls_serial_no=adw.Getitemstring(i,"serial_no")
	
	FOR j= 1 TO adw.rowcount()
		ls_serial_no_c=adw.Getitemstring(j,"serial_no")
		IF j <> i and ls_serial_no_c = ls_serial_no THEN
			ll_status=Messagebox("Error","Duplicate Serial Number Update Failed ~n Do you wish to "  +&
			"change Serial Number....",StopSign!,YesNo! )
			ll_ret = -1 //change the status to come out of loop
			EXIT //Exit anyway
		End IF
	Next	
NEXT

IF ll_ret = 1 THEN
	FOR i= 1 TO adw.rowcount()
		lstrparms.String_arg[i]=adw.Getitemstring(i,'serial_no')
	Next		
End IF

/* 12/06/2010 ujh: SNQM; preserve no of serial nos from w_ro_serialnos
in w_ro_serialno.sle_sno.modified  lstr.long_arg[2] was set to the number of SNs entered from the
serial_number entry table.  Here, we are preserving that value for later use*/
lstrparms.long_arg[2] = lstr.long_arg[2]  
If upper(gs_project) ='PANDORA' Then lstrparms.DataStore_arg[1] = lstr.DataStore_arg[1] //19-APR-2018 :Madhu DE3883 - Populate only for Pandora

//16-Jan-2018 :Madhu S14839 -Foot Prints
//store scanned SN, PoNo2, Container Id into a datastore.
For i=1 to adw.rowcount( )
	If upperBound(lstrparms.DataStore_arg[]) > 0 Then
	ll_row = lstrparms.DataStore_arg[1].insertrow(0)
	lstrparms.DataStore_arg[1].setItem(ll_row,"serial_no", adw.Getitemstring(i,'serial_no'))
	lstrparms.DataStore_arg[1].setItem(ll_row,"po_no2", adw.Getitemstring(i,'po_no2'))
	lstrparms.DataStore_arg[1].setItem(ll_row,"container_Id", adw.Getitemstring(i,'container_Id'))
end if
Next

//lstrparms.datastore_arg[1] = lds_scan_sn
lstr[]=lstrparms[]

return ll_ret
end function

public function integer of_getprice (ref datawindow adw_main, ref datawindow adw_detail);String ls_tcode, ls_tclass, ls_pclass, ls_sku, ls_cust
Decimal ld_price, ld_tax, ld_discount
Long ll_cnt, i
ls_cust = adw_main.Getitemstring(1, "cust_code")
Select tax_class, price_class, discount Into :ls_tclass, :ls_pclass, :ld_discount
	From customer 
	Where cust_code = :ls_cust and project_id = :gs_project;

If sqlca.sqlcode <> 0 Then Return 0

If IsNull(ld_discount) Then ld_discount = 0

ll_cnt = adw_detail.RowCount()
For i = 1 to ll_cnt
	If adw_detail.getitemnumber(i, "price") = 0 Then
		ls_sku = adw_detail.GetItemString(i, "sku")
		
		//***BCR 20-JUN-2011: SQL 2008 Compatibility Project to convert "*=" to LEFT JOIN
		
//		SELECT Price_Master.Price_1,   
//				(IsNull(Tax_Master.Tax_1,0) + IsNull(Tax_Master.Tax_2,0) +    
//				IsNull(Tax_Master.Tax_3,0) + IsNull(Tax_Master.Tax_4,0) +    
//				IsNull(Tax_Master.Tax_5,0)) Into :ld_price, :ld_tax     
//			FROM Item_Master, Price_Master, Tax_Master  
//			WHERE ( Item_Master.Tax_Code *= Tax_Master.Tax_Code) and  
//				( Price_Master.Project_ID = Item_Master.Project_ID ) and  
//				( Price_Master.SKU = Item_Master.SKU ) and  
//				( ( Price_Master.Project_ID = :gs_project ) AND  
//				( Price_Master.SKU = :ls_sku ) AND  
//				( Price_Master.Price_Class = :ls_pclass ) AND  
//				( Tax_Master.Tax_Class = :ls_tclass ) ) ;

		SELECT PM.Price_1,   
			(IsNull(TM.Tax_1,0) + IsNull(TM.Tax_2,0) +    
			IsNull(TM.Tax_3,0) + IsNull(TM.Tax_4,0) +    
			IsNull(TM.Tax_5,0)) Into :ld_price, :ld_tax  
		FROM Item_Master IM LEFT JOIN Tax_Master TM ON IM.Tax_Code = TM.Tax_Code 
			 INNER JOIN Price_Master PM ON IM.Project_ID = PM.Project_ID
			 AND IM.SKU = PM.SKU
		WHERE PM.Project_ID = :gs_project 
		AND PM.SKU = :ls_sku 
		AND PM.Price_Class = :ls_pclass
		AND TM.Tax_Class = :ls_tclass;
		//**************************************************
		
		If sqlca.sqlcode = 0 Then
			adw_detail.setitem(i, "price", ld_price * (1 - ld_discount))
			adw_detail.setitem(i, "tax", ld_tax)
		End If
	End If
Next

Return 0
end function

public subroutine of_import_do (ref window aw_window, ref datawindow adw_master, ref datawindow adw_detail);
String ls_order, ls_file, ls_do
OLEObject xl, xs
String ls_filename
Long ll_row, ll_new
String ls_id, ls_sku, ls_sku2
Long ll_qty, ll_cnt
Any la_value

// Open Excel file

aw_window.SetMicroHelp("Opening Excel ...")
SetPointer(HourGlass!)
ls_order = adw_master.GetItemString(1, "cust_order_no")
if isnull(ls_order) then ls_order = ''
ls_do = adw_master.GetItemString(1, "do_no")
ls_filename = ProfileString(gs_inifile,"ewms","OrderPath","") + "O" + ls_order + ".xls"
If not fileexists(ls_filename) Then
	MessageBox(aw_window.Title, "File " + ls_filename + " not found!")
	Return
End If

xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(ls_filename,0,True)
xs = xl.application.workbooks(1).worksheets(1)

// Read order details from Excel file

ls_id = 'H'
ll_row = 0
Do while ls_id <> "" and ls_id <> "T" 
	ll_row += 1
	aw_window.SetMicroHelp("Reading row " + String(ll_row))
	ls_id = xs.cells(ll_row,1).Value 
	If ls_id = 'L' Then
		la_value = xs.cells(ll_row,3).Value
		If ClassName(la_value) = 'string' Then 
			ls_sku = la_value
		Else
			ls_sku = String(la_value)
		End If
		ls_sku2 = ls_sku
		ll_cnt = 0
		Do while ll_cnt = 0 and Len(ls_sku2) <= 20
		Select Count(*) into :ll_cnt
			From item_master 
			Where project_id = :gs_project and sku = :ls_sku2 ;			 
			If ll_cnt < 1 Then
				ll_cnt = 0
				ls_sku2 = '0' + ls_sku2
			End If
		Loop
		If ll_cnt > 0 Then ls_sku = ls_sku2
		
		la_value = xs.cells(ll_row,9).Value
		If ClassName(la_value) = 'string' Then 
			ll_qty = long(la_value)
		Else
			ll_qty = la_value
		End If
		ll_new = adw_detail.Find("sku = '" + ls_sku + "'", 1, adw_detail.RowCount())
		If ll_new > 0 Then
			adw_detail.SetItem(ll_new, "req_qty", &
				adw_detail.GetItemNumber(ll_new, "req_qty") + ll_qty)
		Else
			ll_new = adw_detail.InsertRow(0)
			adw_detail.SetItem(ll_new, "do_no", ls_do)
			adw_detail.SetItem(ll_new, "sku", ls_sku)
			adw_detail.SetItem(ll_new, "original_sku", ls_sku)
			adw_detail.SetItem(ll_new, "req_qty", ll_qty)
		End If
	End If
Loop
xl.Workbooks.Close
xl.DisconnectObject()

adw_detail.Sort()
aw_window.SetMicroHelp("Import complete!")

Return
end subroutine

public function boolean of_sendemail (string email_recipient, string email_subject, string email_text);mailSession m_mail_session
mailReturnCode m
mailMessage m_message
 
m_mail_session = CREATE mailSession

m = m_mail_session.MailLogon()

IF m <> mailReturnSuccess! THEN
	DESTROY m_mail_session
	MessageBox('Mail', 'Could not connect to the mail program. Make sure the mail program is running.', StopSign!)
	return FALSE
END IF

// Populate the mailMessage structure

m_message.Recipient[1].name = email_recipient
m_message.Subject = email_subject
m_message.NoteText = email_text

// create the mail message

m = m_mail_session.mailSend(m_message)

IF m <> mailReturnSuccess! THEN
	m_mail_session.MailLogoff()
	DESTROY m_mail_session
	MessageBox('Mail', 'There was an error sending the mail message.', StopSign!)
	return FALSE
END IF

m_mail_session.MailLogoff()

DESTROY m_mail_session

return TRUE  // success
end function

public function integer of_sortcolumn (datawindow v_dw, integer ii_sortorder);Integer li_pos
String lc_str , lc_sort
integer ll_ret
lc_str = v_dw.getobjectatpointer()

li_pos = pos(upper(lc_str),'_T')

IF li_pos > 0 THEN
	lc_sort = mid(lc_str,1,li_pos - 1)

	IF ii_sortorder = 0 THEN
		ii_sortorder = 1
		lc_sort = trim(lc_sort) + ' A'
   ELSE
		ii_sortorder = 0
		lc_sort = trim(lc_sort) + ' D'
   END IF
	v_dw.setsort(lc_sort)
	ll_ret = v_dw.sort()
END IF
IF isnull(ll_ret) THEN ll_ret =0
Return ll_ret
end function

public function integer of_item_sku (ref string as_prj_id, ref string as_sku);integer li_rtn
ids_sku = Create datastore
ids_sku.DataObJect = 'd_item_master_sku'		//SARUN2016FEB10:RO_Open : Object not intitiated 

IF ids_sku.SettransObject(SQLCA)  < 0 THEN
	return -1
END IF	

//This function Checks if sku is not duplicated except the word  'empty'
long ll_ret,ll_row
ll_ret=ids_sku.Retrieve(as_prj_id,as_sku)
// pvh - 06/09/2006 - idiots!
IF ll_ret <= 0 and upper(as_sku) <> 'EMPTY' THEN
//IF ll_ret <= 0 and upper(as_sku) <> 'empty'THEN
//	MessageBox(as_title, "Invalid SKU, please re-enter!")
	ll_ret = -1
END IF	
return ll_ret
end function

public function integer of_settab (ref datawindow adw);//This function assign 0 to tab order for 
//given datawindow

int li_cnt,i
li_cnt=integer(adw.describe("DataWindow.Column.Count"))
FOR i = 1 TO li_cnt
	adw.SetTabOrder(i, 0)
NEXT


return li_cnt
end function

public function integer of_settab (ref datawindow adw, ref str_multiparms astr_multiparms, integer ai_strno);//This function assign 0 to tab order for 
//given datawindow
string ls_null
long li_cnt,i
Setnull(ls_null)

CHOOSE CASE ai_strno
	CASE 1
		li_cnt=UpperBound(astr_multiparms.string_arg1[])
		astr_multiparms.string_arg108[]= astr_multiparms.string_arg1[]
	CASE 2
		li_cnt=UpperBound(astr_multiparms.string_arg2[])
		astr_multiparms.string_arg108[]= astr_multiparms.string_arg2[]	
	CASE 3
		li_cnt=UpperBound(astr_multiparms.string_arg3[])
		astr_multiparms.string_arg108[]= astr_multiparms.string_arg3[]	
	CASE 4
		li_cnt=UpperBound(astr_multiparms.string_arg4[])
		astr_multiparms.string_arg108[]= astr_multiparms.string_arg4[]	
	CASE 5
		li_cnt=UpperBound(astr_multiparms.string_arg5[])
		astr_multiparms.string_arg108[]= astr_multiparms.string_arg5[]		
END CHOOSE
					
FOR i = 1 TO li_cnt 
	adw.SetTabOrder(astr_multiparms.string_arg108[i], i)
	astr_multiparms.string_arg108[i]= ls_null
NEXT


return li_cnt
end function

public function string of_tag (ref datawindow adw, integer al_col);String ls_temp
ls_temp = "#"+string(al_col)+".Tag"
Return lower(string(adw.Describe(ls_temp)))
end function

public function integer of_init_prj_ddw (ref datawindow adw, string as_colname);String lsFilter
integer ll_rtn
DatawindowChild ldwc_inv
ll_rtn=adw.GetChild(as_colname,ldwc_inv)
IF ll_rtn <> 1 THEN Return ll_rtn 
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
ll_rtn=ldwc_inv.SetFilter(lsFilter)
IF ll_rtn <> 1 THEN Return ll_rtn 
ll_rtn=ldwc_inv.Filter()
Return ll_rtn
end function

public function integer of_init ();//TimA 03/01/13 Pandora issue #560 Added ids_Item_Master_Coo
integer li_rtn
ids =create u_ds
ids_cont = Create u_ds
ids_sku = Create datastore
ids_Item_Master_Coo = Create datastore 
ids.DataObject = 'd_item_master'
ids_sku.DataObJect = 'd_item_master_sku'
ids_Item_Master_Coo.DataObJect = 'd_get_item_master_coo'

IF ids.Settransobject(SQLCA) < 0 THEN
	return -1
END IF	
IF ids_sku.SettransObject(SQLCA)  < 0 THEN
	return -1
END IF	
IF ids_Item_Master_Coo.SettransObject(SQLCA)  < 0 THEN
	return -1
END IF	
return li_rtn
end function

public function string of_assignlocation (string a_sku, string a_supp, string a_whcode, string a_type, long al_owner, decimal ad_qty_to_putaway);// 10/31/02 - Pconkl - Qty fields changed to Decimal

// 05/00 PCONKL - Putaway logic modified!
//If default location exists on Item Master, we will check to see if anything is already there.
//If nothing there we will set the default for the item.
//If this item already exists, we will see if there is enough room for the rest - based on total to store (user field2)
//If the qty to store fits, we will set the default, Otherwise we will leave it blank and display the recommendation table
//If no default, we will leave blank and pop the recommendation window.

String ls_loc, lsQty, lsFind, lsOwner
Long llDefaultPos, llFindRow, llDefaultCOunt
Decimal ld_Exist_qty, ldamtToStore
DateTime ldt_complete_date

DatawindowChild	ldwc
//DataStore	idsDefaultLoc

If not isvalid(idsDEfaultLoc) Then
	idsDefaultLoc = Create Datastore
	idsDefaultLoc.dataobject = 'd_putaway_default_locs'
	idsDefaultLoc.SetTransObject(SQLCA)
End If

//Retreive any defaults for the current SKU/Warehouse
llDefaultCount = idsDefaultLoc.Retrieve(gs_project,a_whcode,a_sku, a_supp)

If llDefaultCount <=0 Then /* no defaults*/
	ls_loc = ''
 // TAM 09/04 SEARS-FIX looks at "CONTENT" for existing SKU and gets the location of the most recent completed RO
	If gs_project = 'SEARS-FIX' Then
	  SELECT dbo.Content.L_Code,   
         max(dbo.Receive_Master.Complete_Date )  
	   INTO :ls_loc,   
	        :ldt_complete_date  
  		FROM dbo.Content,   
           dbo.Receive_Master  
     	WHERE ( dbo.Content.RO_No = dbo.Receive_Master.RO_No ) and  
           ( ( dbo.Content.SKU = :a_sku ) AND  
           ( dbo.Content.Project_ID = :gs_project ) AND  
           ( dbo.Receive_Master.Complete_Date <> Null ) )   
		GROUP BY  dbo.Content.L_Code ;

		If IsNull(ls_loc) Then /* no location found */
			ls_loc = ''
		End If
	End If
  
Else /*Defaults exist*/
	
	//We need to retrieve the owner cd from the OWner ID that was passed in (the default list is storing the owner CD)
	SElect Owner_cd into :lsOwner 
	From Owner
	Where Project_id = :gs_Project and owner_id = :al_owner;
	
	if isNull(lsOwner) then lsOwner = ''
	
	//See if we have an exact match (Owner and Inv Type)
	lsFind = "default_column_1 = '" + lsOwner + "' and default_column_2 = '" + a_type + "'"
	llFindRow = idsDefaultLoc.Find(lsFind,1,llDefaultCOunt)
	
	If llFindRow > 0 Then /*we have a match, grab the Location and Amt to Store*/
	
		ls_loc = idsDefaultLoc.GetITemString(llFindRow,'l_code')
		ldAmtToStore = idsDefaultLoc.GetITemNumber(llFindRow,'amt_for_loc')
		
	Else /*we dont have a match on all, try a match on Just Owner*/
		
		lsFind = "default_column_1 = '" + lsOwner  + "' and default_column_2 = '*'"
		llFindRow = idsDefaultLoc.Find(lsFind,1,llDefaultCOunt)
		
		If llFindRow > 0 Then /*match on Owner, grab the loc and amt*/
			
			ls_loc = idsDefaultLoc.GetITemString(llFindRow,'l_code')
			ldAmtToStore = idsDefaultLoc.GetITemNumber(llFindRow,'amt_for_loc')
			
		Else /* No match on owner, try Inv Type */
			
			lsFind = "default_column_2 = '" + a_type  + "' and default_column_1 = '*'"
			llFindRow = idsDefaultLoc.Find(lsFind,1,llDefaultCOunt)
			
			If llFindROw > 0 Then /*We have a match on Inv Type, grab Loc and amt*/
				ls_loc = idsDefaultLoc.GetITemString(llFindRow,'l_code')
				ldAmtToStore = idsDefaultLoc.GetITemNumber(llFindRow,'amt_for_loc')
			Else /*We have only a match to the warehouse level - see if it for all defaults (* for both owner/inv type)*/
				If idsDefaultLoc.GetITemString(1,'default_column_1') = '*' and idsDefaultLoc.GetITemString(1,'default_column_2') = '*' Then
					ls_loc = idsDefaultLoc.GetITemString(1,'l_code')
					ldAmtToStore = idsDefaultLoc.GetITemNumber(1,'amt_for_loc')
				End If
			End If
			
		End If
		
	End If /*match on all */
	
End If /*defaults exist*/

//If we still don't have a default location, see if we have one on Item MAster MAintenance screen
If isNUll(ls_loc) or ls_loc = '' Then

	SELECT L_Code, user_field3 Into :ls_loc, :lsQty
	FROM Item_Master
   WHERE Project_ID = :gs_project AND  SKU = :a_sku and supp_code = :a_supp;
	
	ldAmtToStore = Dec(lsQty) /*user field is char, but masked to only accept a number*/
	
End If
	
//If there is an Amt to store for this item, check to see how many are already stored there
If ldAmtToStore > 0 Then
	
	//check for content at this location
	Select sum(avail_qty) into :ld_exist_qty
	From Content
	Where Project_ID = :gs_project AND
			wh_code = :a_whcode and
			l_code = :ls_loc;
			
		if isNull(ld_exist_qty) Then ld_exist_qty = 0 
			
		If (ld_exist_qty + ad_qty_to_Putaway) > ldAmttoStore Then /*current + what's being putaway > space available*/
			ls_loc = '***'
		End If
				
End If /*amt to store exists */

If isNull(ls_loc) Then ls_Loc = ''
				
Return ls_loc

end function

public function integer of_item_master (ref string as_prj_id, ref string as_sku, ref string as_supp_code, ref string as_title);//This function Checks if sku is not duplicated except the word  'empty'
long ll_ret,ll_row
ll_ret=ids.Retrieve(as_prj_id,as_sku,as_supp_code)
IF ll_ret <= 0 and upper(as_sku) <> 'empty'THEN
	MessageBox(as_title, "Invalid SKU, please re-enter!")
	ll_ret = -1
END IF	
return ll_ret
end function

public function integer of_item_master (ref string as_prj_id, ref string as_sku, ref string as_supplier, ref datawindow adw, ref long al_row);//u_ds ids
long ll_ret,ll_row
string ls_serilized_ind,ls_lot_ind,ls_po_ind,ls_po2_ind,lsComponent, lsOrigSQL, lsNewSQL, lsWhere
Integer	liRC

//ids =create u_ds
//ids.DataObject = 'd_item_master'
//ids.Settransobject(SQLCA)

ll_ret=ids.Retrieve(as_prj_id,as_sku,as_supplier)

IF ll_ret > 0 THEN
	ll_row =ids.Getrow()
   ls_serilized_ind=ids.Getitemstring(ll_row,'serialized_ind')
	ls_lot_ind=ids.Getitemstring(ll_row,'lot_controlled_ind')
	ls_po_ind=ids.Getitemstring(ll_row,'po_controlled_ind')
	ls_po2_ind=ids.Getitemstring(ll_row,'po_no2_controlled_ind')
	lscomponent=ids.Getitemstring(ll_row,'component_ind')
	adw.Setitem(al_row,'serialized_ind',ls_serilized_ind)
	adw.Setitem(al_row,'lot_controlled_ind',ls_lot_ind)
	adw.Setitem(al_row,'po_controlled_ind',ls_po_ind)
	adw.Setitem(al_row,'po_no2_controlled_ind',ls_po2_ind)
	adw.Setitem(al_row,'component_ind',lscomponent)
	adw.Setitem(al_row,'container_Tracking_Ind',ids.Getitemstring(ll_row,'container_Tracking_ind')) /* 11/02 - PCONKL */
	adw.Setitem(al_row,'expiration_controlled_ind',ids.Getitemstring(ll_row,'expiration_controlled_ind')) /* 11/02 - PCONKL */
END IF
return ll_ret

end function

public function integer of_check_blanks (ref datawindow adw, ref long al_row, string as_columnname, ref string as_title);

 //Check the blank column which has '-' give error

String ls_data 
string ls_header
ls_data =adw.Getitemstring(al_row,as_columnname)
ls_header=adw.describe(as_columnname + "_t.text")	
 IF trim(ls_data) = '-' or isnull(ls_data) or trim(ls_data) = "0"  or &
   trim(ls_data) = '' THEN
			 MessageBox(adw.Title,"Please enter data in "+ls_header,StopSign!)
			 adw.Setfocus()
			 adw.ScrolltoROW(al_row)
			 adw.SetColumn(as_columnname)
			 Return -1
		 ELSE	
			 return 1
 END IF 


end function

public function real of_convert (real ar_data, string as_mesure_from, string as_mesure_to);//Check the value if it is null
//CM - Centimeters
//IN - Inches
//M - Meters

real lr_rtn
IF isnull(ar_data)  or ar_data = 0 THEN return 0

CHOOSE CASE as_mesure_from
	CASE 'CM'
		IF as_mesure_to = 'IN' THEN lr_rtn = round(ar_data * 0.39370078,2)		
  CASE  'IN'
		IF as_mesure_to = 'CM' THEN  lr_rtn = round(ar_data * 2.54,2)
  CASE  'PO'
	   IF as_mesure_to = 'KG' THEN  lr_rtn = round(ar_data * 0.454 ,2)
  CASE  'KG'
	   IF as_mesure_to = 'PO' THEN  lr_rtn = round(ar_data * 2.2026432,2)
  CASE  'M'
	   IF as_mesure_to = 'FT' THEN  lr_rtn = round(ar_data * 3.2808399,2)
  CASE  'FT'
	   IF as_mesure_to = 'M' THEN  lr_rtn = round(ar_data * 0.3048,2 )
  CASE ELSE
	    return -1
END CHOOSE
return lr_rtn
end function

public function integer of_init_inv_ddw (ref datawindow adw, boolean ab_ship_ind);String lsFilter
integer ll_rtn
DatawindowChild ldwc_inv
ll_rtn=adw.GetChild("inventory_type",ldwc_inv)
IF ll_rtn <> 1 THEN Return ll_rtn 
IF ab_ship_ind THEN
	lsFilter = "project_id = '" + gs_project + "' and Inventory_Shippable_Ind <> 'N'"
ELSE
	lsFilter = "project_id = '" + gs_project + "'"
END IF

// 03/02 - PCONKL - Retrieving by Project before filtering
ldwc_Inv.SetTransObject(SQLCA)
ldwc_Inv.Retrieve(gs_project)

ll_rtn=ldwc_inv.SetFilter(lsFilter)
IF ll_rtn <> 1 THEN Return ll_rtn 
ll_rtn=ldwc_inv.Filter()
Return ll_rtn
end function

public function integer of_print_empty (ref string as_cc_no, string as_table_name);string ERRORS, sql_syntax
string presentation_str, dwsyntax_str

ids_print_em = Create Datastore

sql_syntax = "SELECT l_code from " + as_table_name + & 
" where SKU = 'EMPTY' and CC_NO = '" + as_cc_no + "'"

presentation_str = "style(type=grid)"

dwsyntax_str = SQLCA.SyntaxFromSQL(sql_syntax, &
	presentation_str, ERRORS)

IF Len(ERRORS) > 0 THEN
	MessageBox("Caution", &
	"SyntaxFromSQL caused these errors: " + ERRORS)
	RETURN -1

END IF

ids_print_em.Create( dwsyntax_str, ERRORS)
ids_print_em.SetTransObject(SQLCA)
IF Len(ERRORS) > 0 THEN
	MessageBox("Caution", &
	"Create cause these errors: " + ERRORS)
	RETURN -1

END IF

return ids_print_em.Retrieve()

end function

public function integer of_msg (ref string as_title, integer ai_msg_num);//This function will be helpful for writing a Messagebox that appears at many places.
CHOOSE CASE ai_msg_num
	CASE 1
		Return Messagebox(as_title,"Not entering any search criteria will return all rows which may slow down retrieval process~n~n"+&
		"~t~t      Do you wish to continue.. ?",Question!,YesNo! )
	CASE 2	
		 //Write new messagbox
		 Return 1
END CHOOSE
end function

public subroutine of_ro_serial_nos (ref datawindow adw, ref long al_row);str_parms	lstrparms
String		ls_sku,ls_inventory_type,ls_ro_no,ls_lot_no,ls_l_code,ls_po_no, ls_user_field1, lsFind
String		ls_serialised_ind,ls_lot_controlled_ind,ls_po_controlled_ind, lsGRP, ls_owner_cd

long		ll_upbound,ll_old_row,ll_curr, ll_owner_id, llFindRow
long		ll_received_qty,  ll_entered_qty, ll_display_quantity  //12/06/2010 ujh: SNQM; 
integer i

// Calling w_serial no windows
//16-Jan-2018 :Madhu S14839 Foot Print
Datastore lds_scan_serial
lds_scan_serial =create Datastore
lds_scan_serial.dataobject ='d_ro_scan_serialno'

ll_old_row=al_row

lstrparms.String_arg[1] = adw.getItemString(al_row,"sku")
lstrparms.String_arg[2] = adw.GetITemString(al_row,"l_code") 
lstrparms.String_arg[6] = adw.getitemstring(al_row,'serial_no')
lstrparms.String_arg[7] = adw.getitemstring(al_row,'supp_code')
lstrparms.datastore_arg[1] = lds_scan_serial //16-Jan-2018 :Madhu S14839 Foot Print

lstrparms.String_arg[11] = adw.getItemString(al_row,"po_no2_controlled_Ind")
lstrparms.String_arg[12] = adw.getItemString(al_row,"container_Tracking_Ind")

lstrparms.String_arg[13] = adw.getItemString(al_row,"Po_No2")
lstrparms.String_arg[14] = adw.getItemString(al_row,"Container_Id")

// 07/14/2010 ujhall: 02 of 06    Validate Serial # DoubleClick   Get values required to access serial numbers to validate against
//12/02/2010 ujh: When user_line_item_no is null use line_item_no
if isnull(adw.getItemString(al_row,'user_line_item_no')) or adw.getItemString(al_row,'user_line_item_no') = '' then
	lstrparms.String_arg[8] = String(adw.getItemNumber(al_row,'line_item_no'), '0')  
else
	lstrparms.String_arg[8] = adw.getItemString(al_row,'user_line_item_no')
end if
lstrparms.String_arg[9] = adw.getItemString(al_row,'serialized_ind')

//Jxlim 08/08/2012 Cr06 Physio Copy user_field to putaway for multiple serials
lstrparms.String_arg[10] = adw.getitemstring(al_row,'user_field1')
ls_user_field1 = adw.getitemstring(al_row,'user_field1')

lstrparms.Long_arg[1] = adw.getItemNumber(al_row,"quantity")
ls_serialised_ind =adw.getitemstring(al_row,'serialized_ind')
ls_lot_controlled_ind =adw.getitemstring(al_row,'lot_controlled_ind')
ls_po_controlled_ind =adw.getitemstring(al_row,'po_controlled_ind')
ls_ro_no =adw.getitemstring(al_row,'ro_no')
ls_sku=lstrparms.String_arg[1]
ls_l_code =lstrparms.String_arg[2]  
ls_inventory_type= adw.getitemstring(al_row,'inventory_type')
ls_lot_no =adw.getitemstring(al_row,'lot_no')
ls_po_no = adw.getitemstring(al_row,'po_no')

lsGRP= adw.getitemstring(al_row,'GRP') //TimA 05/26/2011 #223 Get the GRP field
lstrparms.Long_arg[3]  = al_row // 12/06/2010 ujh: SNQM; determine row double clicked

//Jxlim 08/15/2012 Physio cause
String lsString
lsString = lstrparms.String_arg[1] + lstrparms.String_arg[2] +  lstrparms.String_arg[4] +  lstrparms.String_arg[5]
If  Left(gs_project, 6) ='PHYSIO'  and Not isnull(lstrparms.String_arg[10] ) Then  //03-Apr-2013 -Madhu Added  a condition to show serial no screen
	lsstring += lstrparms.String_arg[10]
End If

If Not isnull(lsString) Then	
			openwithParm(w_ro_serialno,lstrparms)
			lstrparms = message.PowerobjectParm
			ll_upbound=UpperBound(lstrparms.String_arg[])
			ll_curr =al_row
			FOR i= 1 TO ll_upbound
				IF ll_curr <> ll_old_row or i > 1 THEN  
					ll_curr++
					adw.insertrow(ll_curr)		
					ll_old_row=ll_curr
				End IF	
				///////////////////////////////////////////////////////////////////////////////////////////////////////////
				// 08/11/2010 ujhall: 02 of 09 Full Circle Fix: need owner_cd
				// may be able to get owner_cd from the datawindow, but right now, don't have time to make
				//	every place that calls this function will send a datawindow where owner_cd is available. Fix when there is time.
				ll_owner_id = adw.getItemnumber(al_row,"owner_id")
				SELECT owner_cd
				Into :ls_owner_cd
				From Owner
				where project_id = :gs_project
				and owner_id = :ll_owner_id
				using sqlca;
				
				adw.Setitem(ll_old_row,"sku",ls_sku)
				adw.Setitem(ll_old_row,"sku_parent",adw.getItemString(al_row,"sku_parent")) /* 09/00 PCONKL*/
				adw.Setitem(ll_old_row,"supp_code",adw.getItemString(al_row,"supp_code")) /* 09/00 PCONKL*/
				adw.Setitem(ll_old_row,"component_ind",adw.getItemString(al_row,"component_ind")) /* 09/00 PCONKL*/
				adw.Setitem(ll_old_row,"country_of_origin",adw.getItemString(al_row,"country_of_origin")) /* 09/00 PCONKL*/
				adw.Setitem(ll_old_row,"owner_id",adw.getItemnumber(al_row,"owner_id")) /* 09/00 PCONKL*/
				
				adw.Setitem(ll_old_row,"owner_cd",ls_owner_cd) /*08/2010 ujhall*/
				
				adw.Setitem(ll_old_row,"line_item_no",adw.getItemnumber(al_row,"line_item_no")) /* 12/01 PCONKL*/
				adw.Setitem(ll_old_row,"user_line_item_no",adw.getItemString(al_row,"user_line_item_no")) /* 2009/11 TAM */
				adw.Setitem(ll_old_row,"component_no",adw.getItemnumber(al_row,"component_no")) /* 09/00 PCONKL*/
				adw.Setitem(ll_old_row,"c_owner_name",adw.getItemString(al_row,"c_owner_name")) /* 09/00 PCONKL*/
				adw.Setitem(ll_old_row,"l_code",ls_l_code)
				adw.Setitem(ll_old_row,"ro_no",ls_ro_no)
				adw.Setitem(ll_old_row,"inventory_type",ls_inventory_type)
				adw.Setitem(ll_old_row,"lot_no",ls_lot_no)			

				// 12/06/2010 ujh: SNQM; Determine what qty to display on the lines posted back to main window
				ll_entered_qty =  lstrparms.Long_arg[2]  //Get the number of SNs entered on the SN entery window
				ll_received_qty = adw.getItemNumber(al_row,"quantity")  // Get the QTY show on main window

				/* 12/06/2010 ujh: SNQM;  When the # of SNs entered is less than the received qty, set the
				main window display qty (column = QTY) to one more than the difference for the first row  
				and to one for all other rows.  This is done so the QTY sum
				of all lines for this item remain the same through out the entry of serial number whether
				all numbers are entered at one time or a few at a time.*/
				if ll_entered_qty < ll_received_qty and i = 1 then
						ll_display_quantity = ll_received_qty - ll_entered_qty + 1
				else
						ll_display_quantity = 1	
				end if
				
				adw.Setitem(ll_old_row,"quantity",ll_display_quantity)
				adw.Setitem(ll_old_row,"serial_no",lstrparms.String_arg[i])
				adw.Setitem(ll_old_row,"po_no",ls_po_no)
				
				//16-Jan-2018 :Madhu S14839 - FootPrint - START
				//Assign respective values of scanned SN and PoNo2, Container Id onto Putaway list
				If upper(gs_project) ='PANDORA' Then
					lds_scan_serial = lstrparms.datastore_arg[1]
					
					If lds_scan_serial.rowcount( ) > 0 Then //Returned datastore count should be > 0.
						lsFind ="serial_no ='"+lstrparms.String_arg[i]+"'"
						llFindRow = lds_scan_serial.find( lsFind, 1, lds_scan_serial.rowcount())
	
						If llFindRow > 0 Then
							adw.Setitem(ll_old_row,"po_no2",lds_scan_serial.getItemString(llFindRow,"po_no2"))
							adw.Setitem(ll_old_row,"container_ID",lds_scan_serial.getItemString(llFindRow,"container_ID"))
						End If
					else
						adw.Setitem(ll_old_row,"po_no2",adw.getItemString(al_row,"po_no2"))
						adw.Setitem(ll_old_row,"container_ID",adw.getItemString(al_row,"container_ID"))
					End If
				else
					adw.Setitem(ll_old_row,"po_no2",adw.getItemString(al_row,"po_no2")) /* 09/00 PCONKL*/
					adw.Setitem(ll_old_row,"container_ID",adw.getItemString(al_row,"container_ID")) /* 11/02 PCONKL*/
				End If
				//16-Jan-2018 :Madhu S14839 - FootPrint - END
							
				adw.Setitem(ll_old_row,"expiration_date",adw.getItemDateTime(al_row,"expiration_Date")) /* 11/02 PCONKL*/
				adw.SetItem(ll_old_row,'serialized_ind',ls_serialised_ind)
				adw.SetItem(ll_old_row,'lot_controlled_ind',ls_lot_controlled_ind)
				adw.SetItem(ll_old_row,'po_controlled_ind',ls_po_controlled_ind)
				adw.Setitem(ll_old_row,"po_no2_controlled_Ind",adw.getItemString(al_row,"po_no2_controlled_Ind")) /* 11/02 PCONKL*/
				adw.Setitem(ll_old_row,"expiration_controlled_Ind",adw.getItemString(al_row,"expiration_controlled_Ind")) /* 11/02 PCONKL*/
				adw.Setitem(ll_old_row,"container_tracking_Ind",adw.getItemString(al_row,"container_Tracking_Ind")) /* 11/02 PCONKL*/
				adw.Setitem(ll_old_row,"GRP",lsGRP) //TimA 05/26/2011		

				//Jxlim 08/08/2012 Added for Physio on multiple serials on putaway list
				If Upper(gs_project) ='PHYSIO-XD' or Upper(gs_project) ='PHYSIO-MAA' Then
					adw.Setitem(ll_old_row,"user_field1",ls_user_field1)
				End If
				
			NEXT 
		IF ll_upbound > 1 THEN	
//			adw.SetSort("sku A, serial_no A")
//			adw.Sort( )
		END IF	
END IF

adw.Sort()
adw.GroupCalc()

destroy lds_scan_serial
end subroutine

public function integer of_init_inv_ddw (ref datawindow adw);String lsFilter
integer ll_rtn
DatawindowChild ldwc_inv
ll_rtn=adw.GetChild("inventory_type",ldwc_inv)
IF ll_rtn <> 1 THEN Return ll_rtn 

ldwc_Inv.SetTransObject(SQLCA)
ldwc_inv.Retrieve(gs_project)

Return ll_rtn
end function

public subroutine of_get_owner (datawindow adw);//This function gets the owner name & assigns it to the calling datawindow which must have
//a compute column called cf_owner_name
Integer i
long ll_owner
IF adw.rowcount() > 0  and Upper(g.is_owner_ind) = 'Y' THEN
	For i = 1 to adw.rowcount()
		ll_owner=adw.GetItemNumber(i,"owner_id")
		IF not isnull(ll_owner) or ll_owner <> 0 THEN
			adw.object.cf_owner_name[ i ] = g.of_get_owner_name(ll_owner)
		ENd IF	
	Next
END IF	
end subroutine

public subroutine of_hide_unused (datawindow adw);// GAP 11/02 -  copied from "PConkl: Hide Serial, Lot, etc if not used anywhere"

//Jxlim 01/03/2011 Added logic to the Workorder Screen (W_Workorder) 
//to capture serial Numbers at Inbound when Item Master tracking (Serialized_Ind) is set to $$HEX1$$1820$$ENDHEX$$Both$$HEX1$$1920$$ENDHEX$$. 
//Serial
If   adw.Find("serialized_Ind = 'Y'",1,adw.RowCOunt()) > 0 or +&
     adw.Find("serialized_Ind = 'B'",1,adw.RowCOunt()) > 0  Then
	adw.Modify("serial_no.width=600 serial_no_t.width=600")
Else /*Hide*/
	adw.Modify("serial_no.width=0 serial_no_t.width=0")
End If

//Lot
If adw.Find("lot_controlled_Ind = 'Y'",1,adw.RowCOunt()) > 0 Then
	adw.Modify("lot_no.width=600 lot_no_t.width=600")
Else /*Hide*/
	adw.Modify("lot_no.width=0 lot_no_t.width=0")
End If

//PO NO
If adw.Find("po_controlled_Ind = 'Y'",1,adw.RowCOunt()) > 0 Then
	adw.Modify("po_no.width=600 po_no_t.width=600")
Else /*Hide*/
	adw.Modify("po_no.width=0 po_no_t.width=0")
End If

//PO NO 2
If adw.Find("po_no2_controlled_Ind = 'Y'",1,adw.RowCOunt()) > 0 Then
	adw.Modify("po_no2.width=600 po_no2_t.width=600")
Else /*Hide*/
	adw.Modify("po_no2.width=0 po_no2_t.width=0")
End If

//Container ID
If adw.Find("container_tracking_Ind = 'Y'",1,adw.RowCOunt()) > 0 Then
	adw.Modify("container_id.width=600 container_id_t.width=600")
Else /*Hide*/
	adw.Modify("container_id.width=0 container_Id_t.width=0")
End If

//Expiration Date
If adw.Find("expiration_controlled_Ind = 'Y'",1,adw.RowCOunt()) > 0 Then
	adw.Modify("expiration_date.width=600 expiration_date_t.width=600")
Else /*Hide*/
	adw.Modify("expiration_date.width=0 expiration_date_t.width=0")
End If

end subroutine

public function integer of_item_master (ref string as_prj_id, ref string as_sku, ref string as_supp_code);//This function Checks if sku is not duplicated except the word  'empty'
long ll_ret,ll_row
ll_ret=ids.Retrieve(as_prj_id,as_sku,as_supp_code)
IF ll_ret <= 0 and upper(as_sku) <> 'empty'THEN
//	MessageBox(as_title, "Invalid SKU, please re-enter!")
	ll_ret = -1
END IF	
return ll_ret
end function

public function integer of_get_picking_sel ();

Return 1
end function

public function integer of_batch_picking (ref datawindow ads_order, ref datawindow adw_pick, string as_pick_sort);// 11/02 - PConkl - Changed QTY to Decimal Fields and added Container ID and EXP Date

string	ls_sku, ls_psku, ls_itype,ls_whcode, ls_dono,ls_supp_code, ls_psupp_code, lsRONO,lsUOM,lsDefaultUOM,lsDefCOO, lsDefCompInd
String	lsOwnerCode, lsOwnerType, lsSupplier_Alloc, lsOrigSupplier, lsOrigSQL, lsNewSQL, lsrc, lsShipInv, lsReplenSKU
String	lsEDIINvType, lsEDILot, lsEDIPO, lsEDIPO2, lsCustOrderNo,  lsOrderNo, lsFilter, lsSkuPickableInd, lsLoc, lsZone, lsErrText, lsModify
String   ls_loc_code, lsFind, lsTempSQL
long llFindInd, ll_once,i, j,ll_crow, ll_cnt,llArrayPos,ll_owner_id, ll_orig_owner, llLineItemNo, llEDIBatchSeq, llBatchPickID, llContentCount
Long	llFindRow
Integer	liRC, li_Cartons
Decimal{5}	ldreqqty,ldavailqty, ld_Carton_rmdr,  ld_Carton_qty, ldPartialQty, ldSetQty
Boolean	lbPartialFwdPick, lbAltSkuPicked
datastore lds_content


llArrayPos = 0
ll_once = 0

//GAP 12/02 -  retrieving inventory types and shipping indicators. 
IF IsValid(ids_inv_type) = FALSE THEN
	ids_inv_type = Create datastore
	ids_inv_type.Dataobject = 'd_inv_type'
	ids_inv_type.SetTransObject(sqlca)
	ids_inv_type.Retrieve(gs_project)
	//ll_rtn = ids_inv_type.rowcount()
end if

lds_content = create datastore
lds_content.dataobject = 'd_do_auto_pick'
lds_content.settransobject(sqlca)

// pvh for pconkl - 11/07/05
lsOrigSQl = lds_content.Describe("DataWindow.Table.Select") //Get original sql so we can modify (remove paramters)
lsNewSQL = lsOrigSQL

// 07/02 - PCONKL - If we are allowing Alt SUpplier Picking (Project Level), we want to retrieve for all suppliers to allow
// picking by altenate supplier (same SKU) 
// 07/03 - PCONKL - A = We're allowing all suppliers equally (not primary first)
If g.is_allow_alt_supplier_pick = 'Y' or g.is_allow_alt_supplier_pick = 'A' Then
	
	//Modify SQL to remove retrieval based on Supplier/Owner
	lsNewSql = Replace(lsOrigSQl,Pos(lsOrigSQl,'Content.Supp_Code = :a_supp_code  AND'),38,'') /*remove Supplier*/
	lsNewSql = Replace(lsNewSql,Pos(lsNewSql,'content.owner_id = :a_owner_id AND'),35,'') /*remove owner*/
	lsModify = 'DataWindow.Table.Select="' + lsNewSql + '"'
	lsRC = lds_content.Modify(lsModify)
		
End If /*Allow alt supplier Pick*/
//// 07/02 - PCONKL - If we are allowing Alt SUpplier Picking (Project Level), we want to retrieve for all suppliers to allow
//// picking by altenate supplier (same SKU) 
//// 07/03 - PCONKL - A = We're allowing all suppliers equally (not primary first)
//If g.is_allow_alt_supplier_pick = 'Y' or g.is_allow_alt_supplier_pick = 'A' Then
//
//	lsOrigSQl = lds_content.Describe("DataWindow.Table.Select") //Get original sql so we can modify (remove paramters)
//	//Modify SQL to remove retrieval based on Supplier/Owner
//	lsNewSql = Replace(lsOrigSQl,Pos(lsOrigSQl,'Content.Supp_Code = :a_supp_code  AND'),38,'') /*remove Supplier*/
//	lsNewSql = Replace(lsNewSql,Pos(lsNewSql,'content.owner_id = :a_owner_id AND'),35,'') /*remove owner*/
//	lsModify = 'DataWindow.Table.Select="' + lsNewSql + '"'
//	lsRC = lds_content.Modify(lsModify)
//		
//End If /*Allow alt supplier Pick*/
//
// pvh for pconkl - eom

//Sort Order coming from the Batch Picking screen
// 04/05 - PCONKL Set Sort on Content - c_sort may be set below to sort Forward Pick Location to Top - (defaults to 5 in the DW)
If as_Pick_Sort > ' ' Then
	liRC = lds_Content.SetSort("c_Sort D, " + as_Pick_Sort)
Else
	liRC = lds_Content.SetSort("c_Sort D, Complete_Date A")
End If

//Resort detail by SKU so we don't try and allocate multiple orders to the same stock
ads_order.SetSort("SKU A, SUPP_CODE A, INVOICE_NO A")
ads_order.Sort()
ll_cnt = ads_order.rowcount()

for i = 1 to ll_cnt /* For each Detail Row*/
	
	// 07/05 - PCONKL - Reset the SQL to possibly remove supplier/Owner as above - we might have temporarily removed them to pick an alternate sku (line level only)
	lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
	lsRC = lds_content.Modify(lsModify)
	
	ll_once = 0	
	lbPartialFwdPick = FALse
	lbAltSkuPicked = False
	
	w_main.SetMicrohelp('Generating Pick information for Line ' + String(i) + ' of ' + String(ll_cnt))
	
	If as_Pick_Sort > ' ' Then
		liRC = lds_Content.SetSort("c_Sort D, " + as_Pick_Sort)
	Else
		liRC = lds_Content.SetSort("c_Sort D, Complete_Date A")
	End If
	
	// 08/02 - Pconkl - We are showing neg qty's on Order detail for GEMS, don't try and pick here 
	If ads_order.getitemnumber(i,'req_qty') <=0 Then Continue
	
	//remove a specific EDI pick filter for previous row
	lds_content.SetFIlter('')
	lds_content.Filter()
	
	//If this order isn't in a new status, don't pick (Don't batch Pick any order that is already being Picked manually)
	If ads_order.GetITemString(i,'ord_status') <> 'N' Then Continue	
		
	//header
	llEdiBatchSeq = ads_order.GetITemNumber(i,'edi_batch_seq_no')
	ls_itype = ads_order.getitemstring(i,'inventory_type')
	ls_whcode = ads_order.getitemstring(i,'wh_code')
	ls_dono = ads_order.getitemstring(i,'do_no')
	lsOrderNo = ads_order.getitemstring(i,'invoice_no')
	lsCustOrderNo = ads_order.getitemstring(i,'cust_order_no')
	
	//detail
	ls_sku = ads_order.getitemstring(i,'sku')
	ls_supp_code = ads_order.getitemstring(i,'supp_code')
	lsOrigSupplier = ads_order.getitemstring(i,'supp_code')
	lsSupplier_Alloc = ''
	ll_owner_id = ads_order.getitemnumber(i,'owner_id')
	ll_orig_Owner = ads_order.getitemnumber(i,'owner_id')
	llLineItemNo = ads_order.getitemnumber(i,'line_Item_No') 
	llBatchPickID = ads_order.getitemnumber(i,'batch_Pick_ID')
	lsSKUPickableInd = 'Y'
	
	//GAP 12-02  logic to skip records where the inventory_shippable_ind is set to "N"
	llFindInd = ids_inv_type.RowCount()
	llFindInd = ids_inv_type.Find( &
   						            "inv_type = '" + ls_itype + "'", 1, ids_inv_type.RowCount())
	lsShipInv =  ids_inv_type.GetItemString(llFindInd, 'inventory_shippable_ind') 
	If lsShipInv = "N" Then Continue /*next rec */	
	
	// 09/01 PCONKL - If this order was received electronically, we may be directed to pick a specific inv type, lot, po or po2
	If llEdiBatchSeq  > 0 Then /*received EDI */
	
		//Retrive the specifics for this line Item
		Select Lot_no, po_no, Po_no2, Inventory_Type, sku_pickable_ind
		Into	:lsEDILot, :lsEDIPO, :lsEDIPO2, :lsEDIInvType, :lsSKuPickableInd
		From EDI_Outbound_Detail
		Where edi_batch_seq_no = :llEdiBatchSeq and invoice_no = :lsOrderNo and Sku = :ls_Sku and
				supp_code = :ls_supp_code and line_item_no = :llLineItemNo
		Using SQLCA;
		
		If lsEDIInvType > '' Then ls_itype = lsEDIInvType /*override inv type from header if need to pick specific*/
		
	End If /*EDI Order*/
	
	//09/01 - PCONKL - The only time we will set the pickable ind to N is if it is specifically set that way in the EDI file. Otherwise it will always be Y
	If lsSkuPickableInd <> 'N' then lsSKuPickableInd = 'Y' 
	
	// 11/00 PCONKL - Get the default UOM for Level 1
	Select uom_1, Country_of_origin_default, component_ind, Qty_2 
	into :lsDefaultUOM, :lsDefCOO, :lsDefCompInd, :ld_Carton_qty
	From Item_Master
	Where project_id = :gs_project and
			sku = :ls_sku and
			supp_code = :ls_supp_code
	Using SQLCA;
	
	If isnull(lsDefaultUOM) or lsDefaultUOM = '' Then
		lsDefaultUOM = 'EA'
	End If
	
	If isNull(lsDefCompInd) or lsDefCompInd = '' Then lsDefCompInd = 'N';
	
	//Retrive the content records if the SKU/Supplier changes - If we are allowing Alternate Supplier picking, we only need to retrive
	//when the SKU changes - otherwise we may double allocate stock
	if ls_sku <> ls_psku  or ls_supp_code <> ls_pSupp_code Then
		If (g.is_allow_alt_supplier_pick = 'N') or isnull(g.is_allow_alt_supplier_pick) Then /* not allowing supplier subsitutions */
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
		ElseIf ls_sku <> ls_psku Then /*allowing supplier subsitutions */
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
		End If
	end if
	
	//Filter for primary Supplier First
	// 07/03 - PCONKL - If picking all suppliers equally, we don't want to filter for primary supplier first
	If g.is_allow_alt_supplier_pick = 'Y' Then /*primary first */
	
		lsFilter = "supp_code = '" + ls_Supp_code + "' and avail_qty > 0"
		lds_Content.SetFilter(lsFilter)
		lds_Content.Filter()
		
		//If none for primary supplier, unfilter (we will only have the current supplier if we aren't allowing substitutions)
		If lds_content.RowCOunt() <=0 Then
			lds_Content.SetFilter('')
			lds_Content.Filter()
		End If
		
	End If /*Picking primary first (if picking equally, we don't want to filter for primary only) */
	
	// 04/05 - PCONKL - Forward Pick Logic - We may want to either sort the FP location first or last depending on the Qty being picked
	ldreqqty = ads_order.getitemnumber(i,'req_qty')
	ldPartialQty =	of_fwd_pick_sort(ldReqQty, ld_Carton_qty, lds_Content)
	If ldPartialQty > 0 Then
		lbPartialFwdPick = True
	End If
			
	lds_content.Sort() /*default sort order may be changed*/
	llContentCount = lds_Content.RowCount()
	
	//For GM_M, if not enough available, we will first try and allocate from a different supplier and then
	//we will try and allocate out of 'Hold/CYCLE/Raw/Quar/Scrap materials' if not available in 'Normal'
	If Upper(Left(gs_project,4)) = 'GM_M'   and  llContentCount <=   0 Then 
		
		If llContentCount <= 0 and ll_once < 1	  Then
			ls_itype = 'H' /*Hold MAterials */
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
			ll_once = 1	
		end if
		If llContentCount <= 0 and ll_once < 2	  Then
			ls_itype = 'C' /*Cycle-Count */			
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
			ll_once = 2	 
		end if
		If llContentCount <= 0 and ll_once < 3	  Then
			ls_itype = 'M' /*Raw MAterials */			
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
			ll_once = 3	 
		end if
		If llContentCount <= 0  and ll_once < 4	 Then
			ls_itype = 'Q' /*Quar MAterials */
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)	
			ll_once = 4	 
		end if
		If llContentCount <= 0 and ll_once < 5	  Then
			ls_itype = 'S' /*Scrap MAterials */
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)	
			ll_once = 5	 
		end if
		ls_itype = ads_order.getitemstring(i,'inventory_type')
		
	End If /*GM_M and no inventory*/
	
	// 07/05 - PCONKL - If allowed, pick the alternate sku if none of the primary is available
	If g.is_allow_alt_sku_Pick = 'Y' and llContentCount <= 0 Then
		
		// pick all owners and suppliers for Alt SKU (we don't know who the primary supplier or owner is)
		lsTempSQl = lds_content.Describe("DataWindow.Table.Select") //Get original sql so we can modify (remove paramters)
	
		If Pos(lsTempSQl,'Content.Supp_Code = :a_supp_code  AND') > 0 Then /*remove Supplier if present*/
			lsTempSQl = Replace(lsTempSQl,Pos(lsTempSQl,'Content.Supp_Code = :a_supp_code  AND'),38,'') 
		End If
			
		If Pos(lsTempSQl,'content.owner_id = :a_owner_id AND') > 0 Then /*remove owner if present*/
			lsTempSQl = Replace(lsTempSQl,Pos(lsTempSQl,'content.owner_id = :a_owner_id AND'),35,'') 
		End If
				
		lsModify = 'DataWindow.Table.Select="' + lsTempSQl + '"'
		lsRC = lds_content.Modify(lsModify)
		
		//retrieve the Content records for the ALternate SKU
		ls_sku = ads_order.getitemstring(i,'alternate_sku')
		llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id) /*supp code and owner not affecting result set*/
		ll_once = 0
		lbAltSkuPicked = True /*only want to loop through alt sku once */
		
	End If /* Picking by Alternate SKU when primary not available at all */
	
	// 09/01 - PCONKL - If it's a non pickable SKU, reset content, this will stop the allocation process and we willc create a pick row with a 0 qty
	If lsSKUPickableInd = 'N' Then lds_Content.Reset()
	
	//If this is an EDI order and we need to pick specific, filter for the appropriate columns to force a pick
	If llEdiBatchSeq  > 0 Then /*received EDI */
	
		lsFilter = ''
		If lsEDILot > '' Then lsFilter += "and Upper(Lot_no) = '" + Upper(lsEDILot) + "' "
		If lsEDIPO > '' Then lsFilter += "and Upper(PO_no) = '" + Upper(lsEDIPO) + "' "
		If lsEDIPO2 > '' Then lsFilter += "and Upper(Po_no2) = '" + Upper(lsEDIPO2) + "' "
		
		If lsFilter > ' ' Then lsFilter = Right(lsFilter, (len(lsFilter) - 3)) /*remove first and*/
		
		//filter content to only show what we want to pick - will still pick FIFO within 
		lds_Content.SetFilter(lsFilter)
		lds_Content.Filter()
		
	End If /*filter for DI line Item*/
		
	ldreqqty = ads_order.getitemnumber(i,'req_qty')
	ads_order.setitem(i,'alloc_qty',0)			
	
//	// GAP 05-03 bump reqqty to ship full cartons - valeo only
//	If upper(gs_Project) = 'VALEOD' and ldreqqty > 0 and ld_Carton_qty > 0 then 
//			if ldreqqty <= ld_Carton_qty then 
//			ldreqqty = ld_Carton_qty
//		else
//			ld_Carton_rmdr = ldreqqty / ld_Carton_qty
//			li_Cartons = ld_Carton_rmdr
//			ld_Carton_rmdr = ld_Carton_rmdr - li_Cartons
//			if ld_Carton_rmdr > 0 then li_Cartons = li_Cartons + 1
//			ldreqqty = ld_Carton_qty * li_Cartons
//		end if
//	end IF 
	
	j = 0
	ldavailqty = 0

	Do while ldreqqty > 0 and j < lds_content.RowCount() and lds_Content.RowCount() > 0
		
		j += 1
		ldavailqty = lds_content.getitemnumber(j,'avail_qty')
				
		if ldavailqty <= 0 Then continue
		
		// 04/05 - PCONKL -  If we have a partial carton qty to pick on a FWD Pick, pick only the partial QTY from the FWD Pick
		//							location on the first pass. If not all picked in the first pass, we will have a second pass
		If lbPartialFwdPick and lds_Content.GetItemString(j,'l_code') = lds_Content.GetItemString(j,'fwd_pick_location') and &
			ldPartialQty = 0 Then Continue
				
		// 04/05 - PCONKL - With the addition of FWD pick and multiple passes, we may be updating an existing Pick Row instead
		//						  of creating a new one.
		lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and Upper(Supp_code) = '" + Upper(lds_content.getitemstring(j,'supp_code')) + "' and line_item_no = " +  String(llLineItemNo)
		lsFind += " and l_code = '" + lds_content.getitemstring(j,'l_code') + "' and component_no = " + String(lds_content.getitemNumber(j,'component_no'))
		lsFind += " and Owner_ID = " + String(lds_content.getitemNumber(j,'owner_id'))
		lsFind += " and Country_Of_Origin = '" + lds_content.getitemstring(j,'country_of_origin') + "'"
		lsFind += " and Lot_no = '" + lds_content.getitemstring(j,'lot_no') + "'"
		lsFind += " and po_no = '" + lds_content.getitemstring(j,'po_no') + "'"
		lsFind += " and po_no2 = '" + lds_content.getitemstring(j,'po_no2')+ "'"
		lsFind += " and Container_Id = '" + lds_content.getitemstring(j,'container_ID') + "'"
		lsFind += " and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(lds_content.getitemDateTime(j,'expiration_Date'),'mm/dd/yyyy hh:mm') + "'" 
		lsFind += " and invoice_no = '" + lsOrderNo + "'"
		
		llFindRow = adw_Pick.Find(lsFind,1,adw_Pick.RowCount())
		If llFindRow > 0 Then
			ll_crow = llFindRow
			idExistingQty = adw_Pick.GetITemNumber(llFindRow,'quantity') /* we'll want to add to existing qty below - using instance var because componenets may be involved to*/
		Else
			ll_crow = adw_pick.insertrow(0)
			idExistingQty = 0
		End If
		
		//ll_crow = adw_pick.insertrow(0)
		
		adw_pick.setitem(ll_crow,'do_no',ls_dono)
		adw_pick.setitem(ll_crow,'sku',ls_sku)
		adw_pick.setitem(ll_crow,'sku_parent',ls_sku)
		adw_pick.setitem(ll_crow,'supp_code',lds_content.getitemstring(j,'supp_code'))
		adw_pick.setitem(ll_crow,'inventory_type',lds_content.getitemstring(j,'inventory_type'))
		adw_pick.setitem(ll_crow,'wh_code',ls_whCode)
		adw_pick.setitem(ll_crow,'l_code',lds_content.getitemstring(j,'l_code'))				
		adw_pick.setitem(ll_crow,'serial_no',lds_content.getitemstring(j,'serial_no'))				
		adw_pick.setitem(ll_crow,'lot_no',lds_content.getitemstring(j,'lot_no'))				
		adw_pick.setitem(ll_crow,'po_no',lds_content.getitemstring(j,'po_no')) /* 07/00 PCONKL */
		adw_pick.setitem(ll_crow,'po_no2',lds_content.getitemstring(j,'po_no2'))/*DGM  Added new fields*/
		adw_pick.setitem(ll_crow,'container_ID',lds_content.getitemstring(j,'container_ID')) /* 11/02 - PCONKL */
		adw_pick.setitem(ll_crow,'expiration_date',lds_content.getitemDateTime(j,'expiration_date')) /* 11/02 - PCONKL */
		//adw_pick.setitem(ll_crow,'owner_id',ll_Owner_ID)
		adw_pick.setitem(ll_crow,'owner_id',lds_content.getitemNumber(j,'owner_id'))
		adw_pick.setitem(ll_crow,'line_item_no',llLineItemNo) /* 09/01 PConkl */
		adw_pick.setitem(ll_crow,'country_of_origin',lds_content.getitemstring(j,'country_of_origin'))
		adw_pick.setitem(ll_crow,'component_no',lds_content.getitemNumber(j,'component_no')) /* 10/00 PCONKL */
		adw_pick.setitem(ll_crow,'component_ind',lsDefCompInd)
		adw_pick.setitem(ll_crow,'sku_pickable_ind',lsSkuPickableInd) /*09/01 PCONKL - only set to no if set that way in EDI file*/
		adw_pick.setitem(ll_crow,'batch_Pick_ID',llbatchPickID)
		adw_pick.setitem(ll_crow,'Invoice_no',lsOrderNo)
		adw_pick.setitem(ll_crow,'cust_order_no',lsCustOrderNo)
		adw_pick.setitem(ll_crow,'ord_status','N')
		
		// 07/05 - PCONKL - Set Ind on Pick list if picking Alt SKU
		If lbAltSkuPicked Then
			adw_pick.setitem(ll_crow,'alt_sku_Pick_Ind','Y')
		Else
			adw_pick.setitem(ll_crow,'alt_sku_Pick_Ind','N')
		End If
		
		//Get the picking sequence Number. 
		ls_loc_code = lds_content.getitemstring(j,'l_code')
		IF inv_common_tables.of_select_location(ls_whCode,ls_loc_code) = 1 THEN
			adw_pick.setitem(ll_crow,'picking_seq',inv_common_tables.id_picking_seq)
		END IF
			
		//Get the owner name
		Select owner_cd, Owner_type
		Into	:lsOwnerCode, :lsOwnerType
		From Owner
		Where project_id = :gs_project and owner_id = :ll_owner_id;
		
		adw_pick.setitem(ll_crow,'owner_cd',lsOwnerCode)
		adw_pick.setitem(ll_crow,'owner_type',lsOwnerType)
		
		//Retrieve ItemMaster Values
		this.of_item_master(gs_project,ls_sku,ls_supp_code,adw_pick,ll_crow)
		
		//Get the Zone for this Location
		lsLoc = adw_pick.GetItemString(ll_crow,'l_code')
		Select Zone_id
		Into	:lsZone
		From Location
		Where wh_code = :ls_whCode and l_code = :lsLoc;
		
		adw_pick.setitem(ll_crow,'zone_id',lsZone)

		//04/05 - PCONKL - Fwd Pick - If we have a partial qty to pick and this is the fwd pick loc, only pick that amt. 
		If ldPartialQty > 0 and lds_Content.GetItemString(j,'l_code') = lds_Content.GetItemString(j,'fwd_pick_location') Then
			ldSetQty = ldPartialQty
		Else
			ldSetQty = ldReqQty
		End If
		
		//if ldavailqty >= ldreqqty then
		if ldavailqty >= ldSetQty then
			
			adw_pick.setitem(ll_crow,'quantity',ldSetQty + idExistingQty) /* if updating existing row, we need to add existing qty, otherwise for a new row, it will be 0*/		
			lsUOM = String(ldSetQty,'#######.#####') + ' ' + lsDefaultUOM
			ads_order.setitem(i,'alloc_qty', ads_order.getitemnumber(i,'alloc_qty') + ldSetQty)				
			lds_content.setitem(j,'avail_qty',ldavailqty - ldSetQty)	
			//ldreqqty = 0
			ldReqQty = ldReqQty - ldSetQty
			ldPartialQty = 0
			
		Else
			
			adw_pick.setitem(ll_crow,'quantity',ldavailqty + idExistingQty)	
			lsUOM = String(ldavailqty,'#######.#####') + ' ' + lsDefaultUOM
			ads_order.setitem(i,'alloc_qty', ads_order.getitemnumber(i,'alloc_qty') + ldavailqty)				
			lds_content.setitem(j,'avail_qty', 0)	
			ldreqqty = ldreqqty - ldavailqty
			ldPartialQty = ldPartialQty - ldAvailQty
			
		End If
		
//		if ldavailqty >= ldreqqty then
//			adw_pick.setitem(ll_crow,'quantity',ldreqqty)		
//			lsUOM = String(ldreqqty,'#######.#####') + ' ' + lsDefaultUOM
//			ads_order.setitem(i,'alloc_qty', ads_order.getitemnumber(i,'alloc_qty') + ldreqqty)				
//			lds_content.setitem(j,'avail_qty',ldavailqty - ldreqqty)	
//			ldreqqty = 0
//		Else
//			adw_pick.setitem(ll_crow,'quantity',ldavailqty)	
//			lsUOM = String(ldavailqty,'#######.#####') + ' ' + lsDefaultUOM
//			ads_order.setitem(i,'alloc_qty', ads_order.getitemnumber(i,'alloc_qty') + ldavailqty)				
//			lds_content.setitem(j,'avail_qty', 0)	
//			ldreqqty = ldreqqty - ldavailqty
//		End If
				
		// 11/00 PCONKL - Default UOM text to Each (using User Field 2)
		adw_pick.SetItem(ll_crow,"user_field2",lsUOM)
		
		//If we are allowing picking from Alt Supplier and we still don't have enough from Primary, unfilter to show all (we want to pick primary first)
		If  (j = lds_content.RowCount()) and (ldreqqty > 0) 	and ll_once < 5	 Then /*it's the last row and we still have more to Pick*/
			
			If g.is_allow_alt_supplier_pick = 'Y' Then /*allowing pick from Alt Supplier */
				lds_Content.SetFilter('avail_qty > 0')
				lds_Content.Filter()
				j = 0
			End If /*allow alt supplier Pick*/
			
			// 04/05 - PCONKL - If partial pick wasn't able to get everything from the non FWD Pick loc, try again from the FWD Pick Loc
			If lbPartialFwdPick Then
				j = 0
				ldPartialQty = 0
				lbPartialFwdPick = False
			End If
			
			// 07/05 - PCONKL - If allowed, pick the alternate sku if none of the primary is available
			If g.is_allow_alt_sku_Pick = 'Y' and not lbAltSkuPicked Then
		
				// pick all owners and suppliers for Alt SKU (we don't know who the primary supplier or owner is)
				lsTempSQl = lds_content.Describe("DataWindow.Table.Select") //Get original sql so we can modify (remove paramters)
	
				If Pos(lsTempSQl,'Content.Supp_Code = :a_supp_code  AND') > 0 Then /*remove Supplier if present*/
					lsTempSQl = Replace(lsTempSQl,Pos(lsTempSQl,'Content.Supp_Code = :a_supp_code  AND'),38,'') 
				End If
			
				If Pos(lsTempSQl,'content.owner_id = :a_owner_id AND') > 0 Then /*remove owner if present*/
					lsTempSQl = Replace(lsTempSQl,Pos(lsTempSQl,'content.owner_id = :a_owner_id AND'),35,'') 
				End If
				
				lsModify = 'DataWindow.Table.Select="' + lsTempSQl + '"'
				lsRC = lds_content.Modify(lsModify)
		
				//retrieve the Content records for the ALternate SKU
				ls_sku = ads_order.getitemstring(i,'alternate_sku')
				llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id) /*supp code and owner not affecting result set*/
				ll_once = 0
				j = 0
				lbAltSkuPicked = True /*only want to loop through alt sku once */
		
			End If /* Picking by Alternate SKU when primary not enough available  */
			
			llContentCount = lds_Content.RowCount()
			
			//For GM_M, if still not enough available, we will try and allocate out of 'Hold/CYCLE/Raw/Quar/Scrap materials'
			If Upper(Left(gs_project,4)) = 'GM_M' and  llContentCount <=   0 Then
				If llContentCount <= 0 and ll_once < 1	  Then
					ls_itype = 'H' /*Hold MAterials */
					llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
					ll_once = 1	
				end if
				If llContentCount <= 0 and ll_once < 2	  Then
					ls_itype = 'C' /*Cycle-Count */			
					llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
					ll_once = 2	 
				end if
				If llContentCount <= 0 and ll_once < 3	  Then
					ls_itype = 'M' /*Raw MAterials */			
					llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
					ll_once = 3	 
				end if
				If llContentCount <= 0  and ll_once < 4	 Then
					ls_itype = 'Q' /*Quar MAterials */
					llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)	
					ll_once = 4	 
				end if
				If llContentCount <= 0 and ll_once < 5	  Then
					ls_itype = 'S' /*Scrap MAterials */
					llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)	
					ll_once = 5	 
				end if
				
				ls_itype = ads_order.getitemstring(i,'inventory_type')
				
				If llContentCount > 0 Then
					j = 0
				End If
				
			End If /*GM Mexico */
			
		End If /*last row and not all picked*/
	
	LOOP /*Next Content record */
	
	ls_psku = ls_sku
	ls_pSupp_code = ls_Supp_code /* 04/01 PCONKL */
	
	// 04/05 - PCONKL - We may need to generate a replenishment (Stock transfer) to FWD Pick Locations
	lsRC = of_fwd_pick_replenish(lds_Content, as_Pick_Sort)
	
	If lsRC <> "-1" Then
		If Trim(lsRC) > '' Then
			lsReplenSKU += ", " + lsRC
		End If
	End If
			
next	/*Next Detail Row*/

destroy lds_content

//Resort detail by Invoice and Line Item Number
ads_order.SetSort("Invoice_No A Line_Item_no A")
ads_order.Sort()

//Sort the Pick dw
adw_pick.Sort()

lsReplenSKU = Trim(lsReplenSKU)
//Notify user if any SKU's were replenished
If Left(lsreplenSKU,1) = "," Then lsReplenSKU = Mid(lsReplenSKU,2,999999999) /* drop first comma*/

If Trim(lsReplenSKu) > '' Then
	Messagebox("FWD Pick Replenishment", "Based on this pick, the following SKU(s) will be at or below~rthe minimum level in the Forward Pick Locations:~r~r" + lsReplenSKU + "~r~rA Replenishment Stock transfer record has been created/updated.")
End If

w_main.SetMicrohelp('Ready')

Return 0
end function

public function integer of_anytable (string as_table, ref string as_where);//This function is called to retrieve the values from any table for any where clause.
//You also have to mention which project_id in where clause parameter.
String ERRORS, sql_syntax
string presentation_str, dwsyntax_str

ids_any = Create Datastore

sql_syntax = "Select * from  "+ "dbo." + trim(as_table) 
IF not isnull(as_where) and as_where <> "" THEN sql_syntax = sql_syntax + " where " + as_where
//" where project_id = '" + gs_project + "'"

presentation_str = "style(type=grid)"

dwsyntax_str = SQLCA.SyntaxFromSQL(sql_syntax, &
	presentation_str, ERRORS)

IF Len(ERRORS) > 0 THEN
	MessageBox("Caution", &
	"SyntaxFromSQL caused these errors: " + ERRORS)
	RETURN -1

END IF

ids_any.Create( dwsyntax_str, ERRORS)
ids_any.SetTransObject(SQLCA)
IF Len(ERRORS) > 0 THEN
	MessageBox("Caution", &
	"Create cause these errors: " + ERRORS)
	RETURN -1

END IF

return ids_any.Retrieve()

end function

public function integer of_any_tables_filter (ref datastore ads_any, ref string as_filter);//This is used with conjuction of of_any_tables fuction to filter out the data
long ll_rowcont,ll_rtn
IF as_filter = '' THEN Return -1
ll_rowcont=ads_any.RowCount()
IF ll_rowcont <= 0 THEN Return -1
ll_rtn = ads_any.find(as_filter,1,ll_rowcont)
Return ll_rtn

end function

public function integer of_waybill_no (string carrier);/* GAP 05/2002 this function is used to calculate the next waybill number for any carrier
	It will also replace the waybill_low with the next (current) waybill number available */

integer li_rtn, li_waybill,  li_step2, li_step3
decimal{1} ld_step1
string ls_step4, ls_waybill_low, ls_waybill_high

// retrieve the current waybill no
SELECT WayBill_No_Low, WayBill_No_High
		INTO :ls_waybill_low, :ls_waybill_high
		FROM carrier_master
		WHERE Project_ID = :gs_project and Carrier_Code = :carrier;

CHOOSE CASE carrier

	CASE "BAX"
	/* The following is the algorithm used to generate mod 7 BAX house waybill
		(HWB) numbers.  This approach creates a check digit using the original
		number to form a full mod 7 HWB number.
   1. Divide the original number by 7.
   2. Round the result to the nearest whole number using standard rounding
      (5 or less, round down; 6 or higher, round up).  Multiply the result
      by 7.
   3. Subtract the rounded result from the original number.  The difference
      will be a single digit integer that is then used as the Mod 7 check
      digit.
   4. Place the check digit to the right of the original number to complete
      the HWB number.
	Example:
   	Original number                     = 12345678
   	Divide 12345678 by 7                = 1763668.2
   	Round the result to the nearest whole number = 1763668
   	Multiply 1763668 by 7               = 12345676
   	Subtract 12345676 from 12345678     = 2
   	Mod 7 number                        = 123456782
	*/
	li_waybill = Integer ( ls_waybill_low )
	ld_step1 = li_waybill / 7
	li_step2 = Round (ld_step1 , 0) * 7
	li_step3 = li_waybill - li_step2
	ls_step4 = String(li_waybill) + String(li_step3)
	li_rtn = Integer ( ls_step4  )

	CASE "EWW"
	/* Shipment numbers are assigned sequentially.  They consist of a 9 digit number plus a one digit check digit.  
		The check digit is selected from the string "0123456789T" using a modulo of the 9 digit number 
		and the number 11 as a zero-based offset into the string of possible check digits.
			Example: 8674398414
						Base Number
						Check Digit
		8 6 7 4 3 9 8 4 1 + 4
			Complete Shipment Number
			CALCULATING THE CHECK DIGIT
			867439841 / 11 = 78858164 with a remainder of 4.  This remainder becomes the check digit leaving a shipment number as shown above of 8674398414.
			The next shipment number will be:
			867439842 /11 = 78858167 with a remainder of 5. This leaves a shipment number of 8674398425.
			Sample shipment number list:
			8400000213
			8400000224
			8400000235
			8400000246
			8400000257
			8400000268
			8400000279
			840000028T  <<====== Note that if the remainder is 10, the check digit is "T"
			
	IMPORTANT!
	Each shipper using your system must be supplied with a block of shipment numbers for their use exclusively. 
	This block of numbers MUST be assigned by Emery Worldwide.*/
	li_waybill = Integer ( ls_waybill_low )
	ld_step1 = li_waybill / 11
	li_step2 = ld_step1
	li_step3 = (ld_step1 - li_step2) * 10
	ls_step4 = String(li_waybill) + String(li_step3)
	if li_step3 = 0 then ls_step4 = String(li_waybill) + "T"
	li_rtn = Integer ( ls_step4  )
	
	CASE ELSE
	Messagebox("Waybill Number WARNING!"," We could not generate a Waybill number becasue of an invalid carrier id:"+ carrier, Exclamation!)	
	return 0
END CHOOSE

// increment for new waybill number
li_waybill = li_waybill + 1 
ls_step4 = String(li_waybill)

// test new waybill number against ls_waybill_hi
li_waybill = li_waybill + 99 
if li_waybill > Integer (ls_waybill_high)  then 
	Messagebox("Waybill Number WARNING!"," We have reached the top of the waybill number range provided by " + carrier + ". Please contact " + carrier + " BAX and update the carrier record with a new range of waybill numbers.", Exclamation!)
end if

// replace with "NEW" current waybill no
UPDATE carrier_master
		SET WayBill_No_Low = :ls_step4
		WHERE Project_ID = :gs_project and Carrier_Code = :carrier;

return li_rtn // return waybill number
end function

public function integer of_width_set (datawindow adw, string as_column[], string as_value[], integer ai_org_width[]);//This Procedure trims the width base on cetain values
Integer li_rtn,i
string ls_syntax,ls_width,ls_type
li_rtn = 1
IF adw.Rowcount() = 0 THEN li_rtn = -1
IF li_rtn > 0 THEN
	FOR i=1 TO UpperBound(as_column)
		   ls_syntax = as_column[i] +".Coltype"
			ls_type= adw.Describe(ls_syntax)
			ls_type= mid(ls_type,1,5)
			CHOOSE CASE lower(ls_type)
				CASE 'char('
					ls_syntax = as_column[i] +" <> '" + as_value[i] + "'"	
				CASE 'numbe','decim'
					ls_syntax = as_column[i] +" <> " + as_value[i] + ""
				CASE 'datet'
//					  expiration_date <> date('12/31/2999')   
                 ls_syntax = as_column[i] +" <> date('" + as_value[i] + "')"	
				END CHOOSE	
			li_rtn=adw.Find(ls_syntax,1,adw.Rowcount())	
			IF  li_rtn > 0 THEN
//				ls_syntax = as_column[i] +".width"
//				ls_width=adw.Describe(ls_syntax)
				ls_syntax = as_column[i] + ".width = " + String(ai_org_width[i])
			ELSE
				ls_syntax = as_column[i] + ".width = 0"
//				ls_syntax = as_column[i] + ".visible = 0"								
			END IF	
				ls_syntax=adw.Modify(ls_syntax)
				IF isnumber(ls_syntax) THEN li_rtn = integer(ls_syntax)				
			NEXT		
END IF	
Return li_rtn
end function

public subroutine of_autopicking (ref window aw_window, ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_pick);string	ls_sku, ls_psku, ls_itype,ls_whcode, ls_dono,ls_supp_code, ls_psupp_code, lsRONO,lsUOM,lsDefaultUOM,lsDefCOO, lsDefCompInd, lsCompType
String	lsEDIINvType, lsEDILot, lsEDIPO, lsEDIPO2, lsOrderNo, lsFilter, lsSkuPickableInd, lsPickSuppCode 
String	lsNewSQL, lsModify, lsRC, ls_once , lsShipInv,lsSKU_a, lsQTY1_a, lsQTY2_a,ls_l_code, lsItemGroup, lsFwdPickLoc, lsFind,	&
			lsReplenSKU, lsOrigSQL, lsTempSql
long 		llFindRow, ll_once,ll_doonce, i, j,ll_crow, ll_cnt,llArrayPos,ll_owner_id, llLineItemNo, llEDIBatchSeq, llContentCount, llPickOwnerId
Long		llContentPos, ll_Qty_2
Integer	liRC, li_Cartons, li_req_qty, li_find
Decimal{5}	ldreqqty,ldavailqty, ld_Carton_rmdr,  ld_Carton_qty, ldOrigPickQty, ldPickedQty, ldMaxFwdPickQty, ldPartialQty,	&
				ldSetQty
Boolean	lbNotified, lbPartialFwdPick, lbAltSkuPicked
string ls_lot_no, ls_UOM_2

datastore lds_content
str_parms	lstrparms

istr_pickshort = LstrParms

// 08/04 - PCONKL - Components need an instance variable with retrivestart=2 so that multiple parents won't allocate the same instance of children in of_creat_comp_Child
If NOt isvalid(ids_Comp_content) THen
	ids_Comp_content = create n_ds_Content
	ids_Comp_Content.dataobject = 'd_do_auto_pick'
	ids_Comp_Content.settransobject(sqlca)
End If

ids_Comp_content.Reset()

SetPointer(HourGlass!)
adw_pick.setRedraw(false)

llArrayPos = 0

ls_whcode = adw_main.getitemstring(1,'wh_code')
ls_dono = adw_main.getitemstring(1,'do_no')
lsOrderNo = adw_main.getitemstring(1,'invoice_no')

lds_content = create datastore
lds_content.dataobject = 'd_do_auto_pick'
lds_content.settransobject(sqlca)

lsOrigSQl = lds_content.Describe("DataWindow.Table.Select") //Get original sql so we can modify (remove paramters)
lsNewSQL = lsOrigSQL

// 07/02 - PCONKL - If we are allowing Alt SUpplier Picking (Project Level), we want to retrieve for all suppliers to allow
// picking by altenate supplier (same SKU) 
// 07/03 - PCONKL - A = We're allowing all suppliers equally (not primary first)
If g.is_allow_alt_supplier_pick = 'Y' or g.is_allow_alt_supplier_pick = 'A' Then
	
	//Modify SQL to remove retrieval based on Supplier/Owner
	lsNewSql = Replace(lsOrigSQl,Pos(lsOrigSQl,'Content.Supp_Code = :a_supp_code  AND'),38,'') /*remove Supplier*/
	
	/* dts - 12/04 - Philips MIT (Merge In Transit) picks all inventory for a specific
	    Sales Order (where Content.lot_no = DM.Invoice_No)
	*/
	if upper(gs_project) = 'PMS-MIT' then
		ls_lot_no = adw_main.GetItemString(1, 'invoice_no')
		lsNewSql = Replace(lsNewSql, Pos(lsNewSql,'content.owner_id = :a_owner_id AND'),35,'content.lot_no = ' +Char(39) + ls_lot_no + Char(39) + ' AND') /* replace Owner with lot_no */
	else
		lsNewSql = Replace(lsNewSql,Pos(lsNewSql,'content.owner_id = :a_owner_id AND'),35,'') /*remove owner*/
	end if
		
	lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
	lsRC = lds_content.Modify(lsModify)
		
End If /*Allow alt supplier Pick*/

// 11/01 - PCONKL - we may re-sort the pick DW to something other than FIFO (LIFO, location priority, etc.) depending on Project Default
// 04/02 - Pconkl - Sort order can be changed in Project Maintenance to any available fields on d_autoPick

// 04/05 - PCONKL Set Sort on Content - c_sort may be set below to sort Forward Pick Location to Top - (defaults to 5 in the DW)
If g.is_pick_sort_order > ' ' Then
	liRC = lds_Content.SetSort("c_Sort D, " + g.is_pick_sort_order)
Else
	liRC = lds_Content.SetSort("c_Sort D, Complete_Date A")
End If

//07/04 - PCONKL - We may have a custom sort for a project
Choose Case Upper(gs_Project)
		
	Case 'LOGITECH' /* 07/04 - PCONKL*/
		
		//For order type of 'P' override project default to be Location type of IP (Z descending), FIFO, Least QTY 
		If adw_main.GetITemString(1,'ord_type')  = 'P' Then
			
			liRC = lds_content.SetSort("c_Sort D, L_Type D, Complete_Date A, Avail_Qty A")
			
		End If
		
End Choose

llEdiBatchSeq = adw_main.GetITemNumber(1,'edi_batch_seq_no')

//02/02 - Pconkl - Detail tab needs to be sorted by SKU before we can allocate.
//						Since we can now have (w/addition of line item) multiple rows with same SKU, the must be allocated at the same time since are not updating content
//						and we can allocate multiple detail rows against the same stock if they are not processed together
// 07/03 - PCONKL - Include supplier in sort - we may have same sku with different suppliers being picked

lirc = adw_detail.SetSort("Upper(SKU) A, Upper(SUPP_CODE) A")
liRC = adw_Detail.Sort()

ll_cnt = adw_detail.rowcount()

for i = 1 to ll_cnt /* For each Detail Row*/
	
	// 07/05 - PCONKL - Reset the SQL to possibly remove supplier/Owner as above - we might have temporarily removed them to pick an alternate sku (line level only)
	lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
	lsRC = lds_content.Modify(lsModify)
	
	// 04/05 - PCONKL Set Sort on Content - c_sort may be set below to sort Forward Pick Location to Top - (defaults to 5 in the DW)
	If g.is_pick_sort_order > ' ' Then
		liRC = lds_Content.SetSort("c_Sort D, " + g.is_pick_sort_order)
	Else
		liRC = lds_Content.SetSort("c_Sort D, Complete_Date A")
	End If
	
	ll_once = 0
	ldPartialQty = 0
	lbNotified = False /*don't want to double report unfull picks*/
	lbPartialFwdPick = False
	lbAltSkuPicked = False
	
	aw_window.SetMicroHelp('Generating pick list for item ' + String(i) + ' of ' + String(ll_cnt))
	
	If adw_detail.getitemnumber(i,'req_qty') <=0 Then Continue
	
	//remove a specific EDI pick filter for previous row
	lds_content.SetFIlter('')
	lds_content.Filter()
	
	ls_itype = adw_main.getitemstring(1,'inventory_type')
	ls_sku = adw_detail.getitemstring(i,'sku')
	ls_supp_code = adw_detail.getitemstring(i,'supp_code')
	ll_owner_id = adw_detail.getitemnumber(i,'owner_id')
	llLineItemNo = adw_detail.getitemnumber(i,'line_Item_No') /*09/01 Pconkl*/
	lsSKUPickableInd = 'Y'
		
	// 09/01 PCONKL - If this order was received electronically, we may be directed to pick a specific inv type, lot, po or po2
	If llEdiBatchSeq  > 0 Then /*received EDI */
	
		//Retrive the specifics for this line Item
		Select Lot_no, po_no, Po_no2, Inventory_Type, sku_pickable_ind
		Into	:lsEDILot, :lsEDIPO, :lsEDIPO2, :lsEDIInvType, :lsSKuPickableInd
		From EDI_Outbound_Detail
		Where edi_batch_seq_no = :llEdiBatchSeq and invoice_no = :lsOrderNo and Sku = :ls_Sku and
				supp_code = :ls_supp_code and line_item_no = :llLineItemNo
		Using SQLCA;
		
		If lsEDIInvType > '' Then ls_itype = lsEDIInvType /*override inv type from header if need to pick specific*/
		
	End If /*EDI Order*/
	
	//09/01 - PCONKL - The only time we will set the pickable ind to N is if it is specifically set that way in the EDI file. Otherwise it will always be Y
	If lsSkuPickableInd <> 'N' then lsSKuPickableInd = 'Y' 
	
	// 11/00 PCONKL - Get the default UOM for Level 1
	Select uom_1, Country_of_origin_default, component_ind, Component_Type, Qty_2, grp
	into :lsDefaultUOM, :lsDefCOO, :lsDefCompInd, :lsCompType, :ld_Carton_qty, :lsitemGroup
	From Item_Master
	Where project_id = :gs_project and
			sku = :ls_sku and
			supp_code = :ls_supp_code
	Using SQLCA;
	
	If isnull(lsDefaultUOM) or lsDefaultUOM = '' Then
		lsDefaultUOM = 'EA'
	End If
	
	If isnull(lsDefCompInd) or lsDefCompInd = '' Then
		lsDefCompInd = 'N'
	End If
	
	// 07/02 - PCONKL - Retrieve the content records if the SKU/Supplier changes - If we are allowing Alternate Supplier picking, we only need to retrive
	//when the SKU changes - otherwise we may double allocate stock
	if Upper(ls_sku) <> Upper(ls_psku)  or Upper(ls_supp_code) <> Upper(ls_pSupp_code) Then
		//ll_once = 0
		If (g.is_allow_alt_supplier_pick = 'N') or isnull(g.is_allow_alt_supplier_pick) Then /* not allowing supplier subsitutions */
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
		ElseIf ls_sku <> ls_psku Then /*allowing supplier subsitutions */
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
		End If
	end if
	
	//Filter for primary Supplier First
	// 07/03 - PCONKL - If picking all suppliers equally, we don't want to filter for primary supplier first
	// 09/03 - PCONKL - Include Primary Owner in initial pick - 
	
	//09/03 - PCONKL - For 3COM_NAsh, we only care about picking primary Owner first, not Supplier
	If Upper(gs_Project) = '3COM_NASH' Then
		
		lsFilter = "owner_id = " + String(ll_owner_id) + " and avail_qty > 0"
		lds_Content.SetFilter(lsFilter)
		lds_Content.Filter()
		
		//If none for primary owner, unfilter (we will only have the current supplier if we aren't allowing substitutions)
		// If it is a bundled order (Inventory TYpe = 'L' and 9th char of order nbr = Z) Then we only want to allow 3COm Owned material, dont unfilter
		If Mid(adw_main.GetITemString(1,'invoice_no'),9,1) = 'Z' and adw_main.GetITemString(1,'Inventory_Type') = 'L' Then
		Else
			If lds_content.RowCOunt() <=0 Then
				lsFilter = ""
				lds_Content.SetFilter(lsFilter)
				lds_Content.Filter()
			End If
		End If
		
	ElseIf g.is_allow_alt_supplier_pick = 'Y' Then /*primary first */
	
		lsFilter = "Upper(supp_code) = '" + Upper(ls_Supp_code) + "' and owner_id = " + String(ll_owner_id) + " and avail_qty > 0"
		lds_Content.SetFilter(lsFilter)
		lds_Content.Filter()
		
		//If none for primary supplier, unfilter (we will only have the current supplier if we aren't allowing substitutions)
		If lds_content.RowCOunt() <=0 Then
			lsFilter = ""
			lds_Content.SetFilter(lsFilter)
			lds_Content.Filter()
		End If
		
	End If /*picking primary Supplier First */
			
	// 04/05 - PCONKL - Forward Pick Logic - We may want to either sort the FP location first or last depending on the Qty being picked
	ldreqqty = adw_detail.getitemnumber(i,'req_qty')
	ldPartialQty =	of_fwd_pick_sort(ldReqQty, ld_Carton_qty, lds_Content)
	If ldPartialQty > 0 Then
		lbPartialFwdPick = True
	End If
		
	lds_content.Sort() /*default sort order may be changed*/
		
	// 09/01 - PCONKL - If it's a non pickable SKU, reset content, this will stop the allocation process and we willc create a pick row with a 0 qty
	If lsSKUPickableInd = 'N' Then lds_Content.Reset()
	
	llContentCount = lds_Content.RowCount()
	
	//For GM_M, if not enough available, we will first try and allocate from a different supplier and then
	//we will try and allocate out of 'Hold/CYCLE/Raw/Quar/Scrap materials' if not available in 'Normal'
	If Upper(Left(gs_project,4)) = 'GM_M'  and  llContentCount <=   0 Then
		
		If llContentCount <=   0  and ll_once < 1 then 
			ls_itype = 'H' /*Hold MAterials */
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)	
			ll_once = 1	
		end if
		If llContentCount <= 0 and ll_once < 2 then 
			ls_itype = 'C' /* Cycle-Count */
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
			ll_once = 2	
		end if
		If llContentCount <= 0 and ll_once < 3 then 
			ls_itype = 'M' /*Raw MAterials */
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
			ll_once = 3	
		end if
		If llContentCount <= 0 and ll_once < 4 then 
			ls_itype = 'Q' /*Quar MAterials */
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
			ll_once = 4	
		end if
		If llContentCount <= 0 and ll_once < 5 then 
			ls_itype = 'S' /*Scrap MAterials */
			llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
			ll_once = 5	
		end if
		ls_itype = adw_main.getitemstring(1,'inventory_type')
		
	End If
	
	// 07/05 - PCONKL - If allowed, pick the alternate sku if none of the primary is available
	If g.is_allow_alt_sku_Pick = 'Y' and llContentCount <= 0 Then
		
		// pick all owners and suppliers for Alt SKU (we don't know who the primary supplier or owner is)
		lsTempSQl = lds_content.Describe("DataWindow.Table.Select") //Get original sql so we can modify (remove paramters)
	
		If Pos(lsTempSQl,'Content.Supp_Code = :a_supp_code  AND') > 0 Then /*remove Supplier if present*/
			lsTempSQl = Replace(lsTempSQl,Pos(lsTempSQl,'Content.Supp_Code = :a_supp_code  AND'),38,'') 
		End If
			
		If Pos(lsTempSQl,'content.owner_id = :a_owner_id AND') > 0 Then /*remove owner if present*/
			lsTempSQl = Replace(lsTempSQl,Pos(lsTempSQl,'content.owner_id = :a_owner_id AND'),35,'') 
		End If
				
		lsModify = 'DataWindow.Table.Select="' + lsTempSQl + '"'
		lsRC = lds_content.Modify(lsModify)
		
		//retrieve the Content records for the ALternate SKU
		ls_sku = adw_detail.getitemstring(i,'alternate_sku')
		llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id) /*supp code and owner not affecting result set*/
		ll_once = 0
		lbAltSkuPicked = True /*only want to loop through alt sku once */
		
	End If /* Picking by Alternate SKU when primary not available at all */
	
	//If this is an EDI order and we need to pick specific, filter for the appropriate columns to force a pick
	If llEdiBatchSeq  > 0 Then /*received EDI */
	
		//lsFilter = ''
		If lsEDILot > '' Then lsFilter += "and Upper(Lot_no) = '" + Upper(lsEDILot) + "' "
		If lsEDIPO > '' Then lsFilter += "and Upper(PO_no) = '" + Upper(lsEDIPO) + "' "
		If lsEDIPO2 > '' Then lsFilter += "and Upper(Po_no2) = '" + Upper(lsEDIPO2) + "' "
		
		If lsFilter > "" Then 
			If left(lsFilter,3) = 'and' Then
				lsFilter = Right(lsFilter, (len(lsFilter) - 3)) /*remove first and*/
			End If
		End If
		
		//filter content to only show what we want to pick - will still pick FIFO within 
		lirc = lds_Content.SetFilter(lsFilter)
		lirc = lds_Content.Filter()
		if gs_project = 'AMS-MUSER' THEN lsFilter = '' // pvh 01/13/06 - wasn't working without this
	End If /*filter for DI line Item*/
	
	// 06/28/00 PCONKL - If no Content and it's a pickable SKU, we want to tell user!
	llContentCount = lds_Content.RowCount()
	If llContentCount = 0 Then
		
		//Only report if it's a pickable SKU - 08/04 - PCONKL - And not component
		If lsSKUPickableInd = 'Y' and (lsDefCompInd = 'N' or lsDefCompInd = '' or isnull(lsDefCompInd)) Then
			llArrayPos = Upperbound(istr_Pickshort.String_arg)
			llArrayPos ++
			lbNotified = True /*don't want to double report unfull picks*/
						
			//GAP 12-02 changes code to send a complete string seperated by |'s 
			lsSKU_a = ls_sku 
			lsQTY1_a = string(adw_detail.getitemnumber(i,'req_qty')) /*requested*/
			lsQTY2_a = string(0) /*none available - no content record*/
			istr_Pickshort.String_arg[llArrayPos] = lsSKU_a + '|' + lsQTY1_a + '|' +  lsQTY2_a 
					
		End If /*pickable SKU*/
		
		// 02/01 PCONKL - We want to insert a pick Row for this SKU/Supplier with a 0 qty. This will allow them to choose diff inv type, etc.
		ll_crow = adw_pick.insertrow(0)
		adw_pick.setitem(ll_crow,'do_no',ls_dono)
		adw_pick.setitem(ll_crow,'sku',ls_sku)
		adw_pick.setitem(ll_crow,'sku_parent',ls_sku)
		adw_pick.setitem(ll_crow,'supp_code',ls_supp_code)
		adw_pick.setitem(ll_crow,'inventory_type',ls_itype)
		adw_pick.setitem(ll_crow,'owner_id',ll_owner_id)
		adw_pick.setitem(ll_crow,'country_of_origin',lsDefCOO)
		adw_pick.object.cf_owner_name[ ll_crow ] = g.of_get_owner_name(ll_owner_id)
		adw_pick.setitem(ll_crow,'quantity',0)
		adw_pick.setitem(ll_crow,'component_no',0)
		adw_pick.setitem(ll_crow,'component_ind',lsDefCompInd)
		adw_pick.setitem(ll_crow,'component_type',lsCompType)
		adw_pick.setitem(ll_crow,'sku_pickable_ind',lsSkuPickableInd)
		adw_pick.setitem(ll_crow,'grp',lsItemGroup)
		adw_pick.setitem(ll_crow,'line_item_no',llLineItemNo) 
		
		//Retrieve ItemMaster Values
		this.of_item_master(gs_project,ls_sku,ls_supp_code,adw_pick,ll_crow)
		
		If lsSKuPickableInd = 'N' Then adw_pick.setitem(ll_crow,'l_code','N/A') /*location is non applicable if sku is non pickable*/
		
		//If picking specific from EDI, also set Lot, PO and PO2
		If llEdiBatchSeq  > 0 Then
			If lsEDILot > '' Then
				adw_pick.setitem(ll_crow,'lot_no',lsEDILot)
			Else
				adw_pick.setitem(ll_crow,'lot_no','-')
			End If
			If lsEDIPO > '' Then
				adw_pick.setitem(ll_crow,'po_no',lsEDIpo)
			Else
				adw_pick.setitem(ll_crow,'po_no','-')
			End If
			If lsEDIPO2 > '' Then
				adw_pick.setitem(ll_crow,'po_no2',lsEDIPO2)
			Else
				adw_pick.setitem(ll_crow,'po_no2','-')
			End If
		End If
		
		adw_pick.setitem(ll_crow,'serial_no','-')
		
	End If /* Content count = 0 */
	
	ldreqqty = adw_detail.getitemnumber(i,'req_qty')
	//dts - 12/04 - Philips MIT wants ALL content matching selection (content.lot_no = DM.Invoice_no)
	if upper(gs_project) = 'PMS-MIT' then
		ldReqQty = 10000  //Setting qty sufficiently large to ensure picking all content for selected Sales Order
	end if
	adw_detail.setitem(i,'alloc_qty',0)	

	j = 0
	ldavailqty = 0
	ldPickedQty = 0 //dts - 12/04 (PMS-MIT)
	
	Do while ldreqqty > 0 and j < lds_content.RowCount() and lds_content.RowCount() > 0
		
		j += 1
		
		ldavailqty = lds_content.getitemnumber(j,'avail_qty')
		
		// dts - 12/04 - Philips MIT - Counting up total Picked to set req_qty at the end
		ldPickedQty += ldAvailQty
				
		if ldavailqty <= 0 Then continue
		
		// 04/05 - PCONKL -  If we have a partial carton qty to pick on a FWD Pick, pick only the partial QTY from the FWD Pick
		//							location on the first pass. If not all picked in the first pass, we will have a second pass
		If lbPartialFwdPick and lds_Content.GetItemString(j,'l_code') = lds_Content.GetItemString(j,'fwd_pick_location') and &
			ldPartialQty = 0 Then Continue
				
		// 04/05 - PCONKL - With the addition of FWD pick and multiple passes, we may be updating an existing Pick Row instead
		//						  of creating a new one.
		lsFind = "Upper(sku) = '" + Upper(ls_sku) + "' and Upper(Supp_code) = '" + Upper(lds_content.getitemstring(j,'supp_code')) + "' and line_item_no = " +  String(llLineItemNo)
		lsFind += " and l_code = '" + lds_content.getitemstring(j,'l_code') + "' and component_no = " + String(lds_content.getitemNumber(j,'component_no'))
		lsFind += " and Owner_ID = " + String(lds_content.getitemNumber(j,'owner_id'))
		lsFind += " and Country_Of_Origin = '" + lds_content.getitemstring(j,'country_of_origin') + "'"
		lsFind += " and Lot_no = '" + lds_content.getitemstring(j,'lot_no') + "'"
		lsFind += " and po_no = '" + lds_content.getitemstring(j,'po_no') + "'"
		lsFind += " and po_no2 = '" + lds_content.getitemstring(j,'po_no2')+ "'"
		lsFind += " and Container_Id = '" + lds_content.getitemstring(j,'container_ID') + "'"
		lsFind += " and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(lds_content.getitemDateTime(j,'expiration_Date'),'mm/dd/yyyy hh:mm') + "'" 
			
		llFindRow = adw_Pick.Find(lsFind,1,adw_Pick.RowCount())
		If llFindRow > 0 Then
			ll_crow = llFindRow
			idExistingQty = adw_Pick.GetITemNumber(llFindRow,'quantity') /* we'll want to add to existing qty below - using instance var because componenets may be involved to*/
		Else
			ll_crow = adw_pick.insertrow(0)
			idExistingQty = 0
		End If
		
		ls_l_code = lds_content.getitemstring(j,'l_code')
		adw_pick.setitem(ll_crow,'do_no',ls_dono)
		adw_pick.setitem(ll_crow,'sku',ls_sku)
		adw_pick.setitem(ll_crow,'sku_parent',ls_sku)
		adw_pick.setitem(ll_crow,'supp_code',lds_content.getitemstring(j,'supp_code'))
		adw_pick.setitem(ll_crow,'inventory_type',lds_content.getitemstring(j,'inventory_type'))
		adw_pick.setitem(ll_crow,'l_code',ls_l_code)	
		//Added DGM for reieving values from Location table 
		IF this.inv_common_tables.of_select_location( ls_Whcode,ls_l_code) > 0 THEN
				adw_pick.object.picking_seq[ll_crow] = This.inv_common_tables.id_picking_seq
		END IF		
		adw_pick.setitem(ll_crow,'serial_no',lds_content.getitemstring(j,'serial_no'))				
		adw_pick.setitem(ll_crow,'lot_no',lds_content.getitemstring(j,'lot_no'))				
		adw_pick.setitem(ll_crow,'po_no',lds_content.getitemstring(j,'po_no')) /* 07/00 PCONKL */
		adw_pick.setitem(ll_crow,'po_no2',lds_content.getitemstring(j,'po_no2'))/*DGM  Added new fields*/
		adw_pick.setitem(ll_crow,'container_ID',lds_content.getitemstring(j,'container_ID'))/* 11/02 - PCONKL*/
		adw_pick.setitem(ll_crow,'expiration_Date',lds_content.getitemDateTime(j,'expiration_Date'))/* 11/02 - PCONKL*/
		adw_pick.setitem(ll_crow,'owner_id',lds_content.getitemNumber(j,'owner_id')) /* 05/02 - PConkl*/
		adw_pick.setitem(ll_crow,'line_item_no',llLineItemNo) /* 09/01 PConkl */
		adw_pick.setitem(ll_crow,'country_of_origin',lds_content.getitemstring(j,'country_of_origin'))
		adw_pick.setitem(ll_crow,'component_no',lds_content.getitemNumber(j,'component_no')) /* 10/00 PCONKL */
		adw_pick.setitem(ll_crow,'sku_pickable_ind',lsSkuPickableInd) /*09/01 PCONKL - only set to no if set that way in EDI file*/
		adw_pick.setitem(ll_crow,'cntnr_Length',lds_content.getitemNumber(j,'cntnr_Length')) /* 01/03 - PConkl*/
		adw_pick.setitem(ll_crow,'cntnr_Width',lds_content.getitemNumber(j,'cntnr_Width')) /* 01/03 - PConkl*/
		adw_pick.setitem(ll_crow,'cntnr_Height',lds_content.getitemNumber(j,'cntnr_height')) /* 01/03 - PConkl*/
		adw_pick.setitem(ll_crow,'cntnr_Weight',lds_content.getitemNumber(j,'cntnr_Weight')) /* 01/03 - PConkl*/
		adw_pick.setitem(ll_crow,'component_type',lsCompType)
		adw_pick.setitem(ll_crow,'grp',lsITemGroup)
		//adw_pick.object.cf_owner_name[ ll_crow ] = g.of_get_owner_name(ll_owner_id) //Get the owner name
		adw_pick.object.cf_owner_name[ ll_crow ] = g.of_get_owner_name(lds_content.getitemNumber(j,'owner_id')) //Get the owner name
		
		// 07/05 - PCONKL - Set Ind on Pick list if picking Alt SKU
		If lbAltSkuPicked Then
			adw_pick.setitem(ll_crow,'alt_sku_Pick_Ind','Y')
		Else
			adw_pick.setitem(ll_crow,'alt_sku_Pick_Ind','N')
		End If
		
		//Retrieve ItemMaster Values
		lsPickSuppCode = adw_pick.GetITemString(ll_crow,'supp_code') /* 11/04 - PCONKL - make sure we get the item maste values for the supplier on the pick row - may be different than order detail*/
		this.of_item_master(gs_project,ls_sku,lsPickSuppCode,adw_pick,ll_crow)

		//04/05 - PCONKL - Fwd Pick - If we have a partial qty to pick and this is the fwd pick loc, only pick that amt. 
		If ldPartialQty > 0 and lds_Content.GetItemString(j,'l_code') = lds_Content.GetItemString(j,'fwd_pick_location') Then
			ldSetQty = ldPartialQty
		Else
			ldSetQty = ldReqQty /*pick them all if available*/
		End If
		
		//if ldavailqty >= ldreqqty then
		if ldavailqty >= ldSetQty then
			
			adw_pick.setitem(ll_crow,'quantity',ldSetQty + idExistingQty) /* if updating existing row, we need to add existing qty, otherwise for a new row, it will be 0*/		
			lsUOM = String(ldSetQty,'#######.#####') + ' ' + lsDefaultUOM
			adw_detail.setitem(i,'alloc_qty', adw_detail.getitemnumber(i,'alloc_qty') + ldSetQty)				
			lds_content.setitem(j,'avail_qty',ldavailqty - ldSetQty)	
			//ldreqqty = 0
			ldReqQty = ldReqQty - ldSetQty
			ldPartialQty = 0
			
		Else
			
			adw_pick.setitem(ll_crow,'quantity',ldavailqty + idExistingQty)	
			lsUOM = String(ldavailqty,'#######.#####') + ' ' + lsDefaultUOM
			adw_detail.setitem(i,'alloc_qty', adw_detail.getitemnumber(i,'alloc_qty') + ldavailqty)				
			lds_content.setitem(j,'avail_qty', 0)	
			ldreqqty = ldreqqty - ldavailqty
			ldPartialQty = ldPartialQty - ldAvailQty
			
		End If
						
		// 11/00 PCONKL - Default UOM text to Each (using User Field 2)
		adw_pick.SetItem(ll_crow,"user_field2",lsUOM)
				
		//10/01/2004 - MA - Changed Pick As to use Item_Master.Qty_2 is avail.
		if gs_project = "LINKSYS" or gs_project = 'GM-BATTERY' then
				
			Select Qty_2, UOM_2
			Into	:ll_Qty_2, :ls_UOM_2
			From Item_Master
			Where	(  dbo.Item_Master.Supp_Code = :ls_supp_code ) and  
					(  dbo.Item_Master.SKU = :ls_sku ) and  
					( dbo.Item_Master.Project_ID = :gs_project )  
			Using SQLCA;  
		
			li_req_qty = adw_pick.GetItemNumber(ll_crow,'quantity')	

			if Not IsNull(ll_Qty_2) and ll_qty_2 > 0 then
				adw_pick.SetItem(ll_crow,"user_field2",String((li_req_qty/ll_qty_2),'#######.#####') + ' ' + ls_UOM_2)
			end if

		end if				
				
				
		// 10/00 PCONKL - If this row is a component, build child pick rows
		// 08/04 - PCONKL - We may build components from free stock (workorders) as well as components received built (Kits)
		//							We will build components below after any available kits have been picked
		//							Component parents received in full will have component Number > 0, Component parents built from free stock here will have component Number = 0
		
		If adw_pick.GetITemString(ll_crow,'component_ind') = 'Y' and adw_pick.GetITemNumber(ll_crow,'component_no') > 0 Then
			of_create_comp_child(ll_crow,adw_main,adw_pick, aw_window)
		End If /*Component parent Row*/
		
		// 07/02 - PCONKL - If we are allowing picking from Alt Supplier and we still don't have enough from Primary, unfilter to show all (we want to pick primary first)
		If  (j = lds_content.RowCount()) and (ldreqqty > 0) and ll_once < 5	 Then /*it's the last row and we still have more to Pick*/

			If g.is_allow_alt_supplier_pick = 'Y' Then /*allowing pick from Alt Supplier */
				lds_Content.SetFilter('avail_qty > 0')
				lds_Content.Filter()
				j = 0
			End If /*allow alt supplier Pick*/
			
			// 04/05 - PCONKL - If partial pick wasn't able to get everything from the non FWD Pick loc, try again from the FWD Pick Loc
			If lbPartialFwdPick Then
				j = 0
				ldPartialQty = 0
				lbPartialFwdPick = False
				Continue /* for GM, we will want to try and pick from FWD Pick Loc before moving on to other Inv Types (below)*/
			End If
					
			// 07/05 - PCONKL - If allowed, pick the alternate sku if none of the primary is available
			If g.is_allow_alt_sku_Pick = 'Y' and not lbAltSkuPicked Then
		
				// pick all owners and suppliers for Alt SKU (we don't know who the primary supplier or owner is)
				lsTempSQl = lds_content.Describe("DataWindow.Table.Select") //Get original sql so we can modify (remove paramters)
	
				If Pos(lsTempSQl,'Content.Supp_Code = :a_supp_code  AND') > 0 Then /*remove Supplier if present*/
					lsTempSQl = Replace(lsTempSQl,Pos(lsTempSQl,'Content.Supp_Code = :a_supp_code  AND'),38,'') 
				End If
			
				If Pos(lsTempSQl,'content.owner_id = :a_owner_id AND') > 0 Then /*remove owner if present*/
					lsTempSQl = Replace(lsTempSQl,Pos(lsTempSQl,'content.owner_id = :a_owner_id AND'),35,'') 
				End If
				
				lsModify = 'DataWindow.Table.Select="' + lsTempSQl + '"'
				lsRC = lds_content.Modify(lsModify)
		
				//retrieve the Content records for the ALternate SKU
				ls_sku = adw_detail.getitemstring(i,'alternate_sku')
				llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id) /*supp code and owner not affecting result set*/
				ll_once = 0
				j = 0
				lbAltSkuPicked = True /*only want to loop through alt sku once */
		
			End If /* Picking by Alternate SKU when primary not enough available  */
			
		//	llContentCount = lds_Content.RowCount()
			
			//For GM_M, if still not enough available, we will try and allocate out of 'Hold/CYCLE/Raw/Quar/Scrap materials'
			If Upper(Left(gs_project,4)) = 'GM_M'  Then
				
				lds_Content.SetFilter('avail_qty > 0')
				lds_Content.Filter()
				llContentCount = lds_Content.RowCount()
				
				If llContentCount <=   0  and ll_once < 1 then 
					ls_itype = 'H' /*Hold MAterials */
					llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)	
					ll_once = 1	
				end if
				If llContentCount <= 0 and ll_once < 2 then 
					ls_itype = 'C' /* Cycle-Count */
					llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
					ll_once = 2	
				end if
				If llContentCount <= 0 and ll_once < 3 then 
					ls_itype = 'M' /*Raw MAterials */
					llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
					ll_once = 3	
				end if
				If llContentCount <= 0 and ll_once < 4 then 
					ls_itype = 'Q' /*Quar MAterials */
					llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
					ll_once = 4	
				end if
				If llContentCount <= 0 and ll_once < 5 then 
					ls_itype = 'S' /*Scrap MAterials */
					llContentCount = lds_content.Retrieve(gs_project, ls_whcode, ls_sku, ls_itype,ls_supp_code,ll_owner_id)
					ll_once = 5	
				end if
				
				ls_itype = adw_main.getitemstring(1,'inventory_type')
				
				If llContentCount > 0 Then
					j = 0
				End If
						
			End If /* GM_M */
									
		End If /*last row and not all picked*/
		
	LOOP /*Next Content Record */
	
	//dts 12/04 - Philips MIT...
	if upper(gs_project) = 'PMS-MIT' then
		ldReqQty = 0 //Temp!!
		messagebox ("Picked Qty", "Total Qty Picked: " + string(ldPickedQty, "#") + " boxes.  Requested Qty has been set accordingly.")
		adw_detail.SetItem(1, 'req_qty', ldPickedQty)
	end if
	
	// 06/28/00 PCONKL - Notify if not enough qty available to Pick
	//If ldreqqty > 0  and not lbNotified and (adw_pick.GetITemString(ll_crow,'component_ind') = 'N' or (adw_pick.GetITemNumber(ll_crow,'component_no') > 0 and adw_pick.GetITemString(ll_crow,'component_type') <> 'D')) Then /*if lbNotified, we already reported it earlier*/
	If ldreqqty > 0  and not lbNotified and lsDefCompInd = 'N'  Then /*if lbNotified, we already reported it earlier*/
		llArrayPos = Upperbound(istr_Pickshort.String_arg)
		llArrayPos ++

		//GAP 12-02 changes code to send a complete string seperated by |'s 
		lsSKU_a = ls_sku + '/' + ls_Supp_code
		lsQTY1_a = string(adw_detail.getitemnumber(i,'req_qty')) /*requested*/
		lsQTY2_a = string(adw_detail.getitemnumber(i,'req_qty') - ldreqqty )
		istr_Pickshort.String_arg[llArrayPos] = lsSKU_a + '|' + lsQTY1_a + '|' +  lsQTY2_a 
		
	End If
	
	//If it's a component and we haven't been able to pick all, build from free stock - if designated on Item Master, otherwise it will be created from a WO
	// We may be picking a combination of components and non components for the same sku (different suppliers)
	// See if we have a component version of this SKU for any supplier
	
	lsPickSuppCode = ''
	lsCompType = ''
	
// TAM 2005/03/04 added owner id to SQL to be used in combination of components and children	
	Select Min(supp_code), Min(component_Type), Min(owner_id) Into :lsPickSuppCode, :lsCompType, :llpickOwnerId
	From Item_Master 
	Where Project_id = :gs_Project and sku = :ls_Sku and Component_Ind = 'Y' and component_type = 'D';
		
	//If ldreqqty > 0 and adw_pick.GetITemString(ll_crow,'component_ind') = 'Y' and adw_pick.GetITemString(ll_crow,'component_type') = 'D' Then
	If ldreqqty > 0 and lsPickSuppCode > '' and lsCompType = 'D' Then
		
		//If we didn't pick any, we'll build the children off of this record, if we picked some, we'll add a new row for the rest
		If adw_pick.GetITemNumber(ll_crow,'quantity') = 0 or isnull(adw_pick.GetITemNumber(ll_crow,'quantity')) Then
			
			adw_pick.SetITem(ll_crow,'quantity',ldReqQty) /*qty to be blown out in children*/
			adw_pick.SetITem(ll_crow,'l_Code', 'N/A')
			adw_pick.SetITem(ll_crow,'supp_Code', lsPickSuppCode)
			adw_pick.SetITem(ll_crow,'component_Type', lsCompType)
			adw_pick.SetITem(ll_crow,'component_Ind', 'Y')
			
			//Capture the original qty so we can notify if picked short - we will reduce the qty to that of child availability
			ldOrigPickQty = adw_pick.GetItemNumber(ll_crow,'quantity')
			
			of_create_comp_child(ll_crow,adw_main,adw_pick, aw_window)
			
		Else
			
			//copy to new row	
			adw_pick.RowsCopy(ll_Crow,ll_Crow,Primary!,adw_Pick,999999,Primary!)
			adw_Pick.SetITem(adw_pick.RowCOunt(), 'Component_no',0)
			adw_Pick.SetITem(adw_pick.RowCOunt(), 'l_code','N/A')
			adw_Pick.SetITem(adw_pick.RowCount(), 'Quantity',ldReqQty) /* set qty on new row to remaining required*/
			adw_pick.SetITem(adw_pick.RowCount(),'l_Code', 'N/A')
			adw_pick.SetITem(adw_pick.RowCount(),'supp_Code', lsPickSuppCode)
			adw_pick.SetITem(adw_pick.RowCount(),'owner_id', llPickOwnerId)  //TAM 2005/03/04 added for combo of components/non components
			adw_pick.object.cf_owner_name[ adw_pick.RowCount() ] = g.of_get_owner_name(llPickOwnerId)
			adw_pick.SetITem(adw_pick.RowCount(),'component_Type', lsCompType)
			adw_pick.SetITem(adw_pick.RowCount(),'component_Ind', 'Y')
			
			of_create_comp_child(adw_pick.RowCount(),adw_main,adw_pick, aw_Window)
			
		End If
		
		//If picked short, notify user
		If ldOrigPickQty > adw_pick.GetItemNumber(ll_crow,'quantity') Then
			
			llArrayPos = Upperbound(istr_Pickshort.String_arg)
			llArrayPos ++

			lsSKU_a = ls_sku + '/' + ls_Supp_code
			lsQTY1_a = string(ldOrigPickQty) /*requested*/
			lsQTY2_a = string(adw_pick.GetItemNumber(ll_crow,'quantity'))
			istr_Pickshort.String_arg[llArrayPos] = lsSKU_a + '|' + lsQTY1_a + '|' +  lsQTY2_a 
			
		End If /*Picked Short*/
				
	End If /*Component parent Row*/
		
	ls_psku = ls_sku
	ls_pSupp_code = ls_Supp_code /* 04/01 PCONKL */
	
	// 04/05 - PCONKL - We may need to generate a replenishment (Stock transfer) to FWD Pick Locations
	lsRC = of_fwd_pick_replenish(lds_Content, g.is_pick_sort_order)
	
	If lsRC <> "-1" Then
		If Trim(lsRC) > '' Then
			lsReplenSKU += ", " + lsRC
		End If
	End If
	
next	/*Next Detail Row*/

// 02/02 - Pconkl - Resort detail by Line Item Number
adw_detail.SetSort("Line_Item_no A")
adw_Detail.Sort()

aw_window.SetMicroHelp('Pick list generation complete!')
SetPointer(Arrow!)
adw_pick.setRedraw(True)

//06/28/00 PCONKL - display any existing pick exceptions
If Upperbound(istr_pickshort.string_arg) > 0 Then
	OpenWithParm(w_pick_exception,istr_Pickshort)
End If

// 04/05 - PCONKL - We may need to generate a replenishment (Stock transfer) to FWD Pick Locations - For any Children records
lsRC = of_fwd_pick_replenish(ids_Comp_content, g.is_pick_sort_order)

If lsRC <> "-1" Then
	If Trim(lsRC) > '' Then
		lsReplenSKU += ", " + lsRC
	End If
End If

lsReplenSKU = Trim(lsReplenSKU)
//Notify user if any SKU's were replenished
If Left(lsreplenSKU,1) = "," Then lsReplenSKU = Mid(lsReplenSKU,2,999999999) /* drop first comma*/

If Trim(lsReplenSKu) > '' Then
	Messagebox("FWD Pick Replenishment", "Based on this pick, the following SKU(s) will be at or below~rthe minimum level in the Forward Pick Locations:~r~r" + lsReplenSKU + "~r~rA Replenishment Stock transfer record has been created/updated.")
End If

Destroy ids_Comp_content 
destroy lds_content

Return
end subroutine

public function integer of_check_multipo (ref datawindow adw, ref str_parms lstr);String ls_sku
String ls_l_code
char ls_inventory_type
String ls_lot_no
String ls_po_no_c,ls_po_no
integer i,j
long ll_ret= 1,ll_status,ll_upbound
str_parms lstrparms

	
	FOR i= 1 TO adw.rowcount()
		IF ll_ret = -1 THEN exit
  	ls_po_no=adw.Getitemstring(i,"po_no")
		FOR j= 1 TO adw.rowcount()
			ls_po_no_c=adw.Getitemstring(j,"po_no")
			IF j <> i and ls_po_no_c = ls_po_no THEN
				ll_status=Messagebox("Error","Duplicate PO Number Update Failed ~n Do you wish to "  +&
				         "change PO Number....",StopSign!,YesNo! )
				ll_ret = -1 //change the status to come out of loop
				EXIT //Exit anyway
			End IF
		Next	
		
	NEXT

		
IF ll_ret = 1 THEN
	FOR i= 1 TO adw.rowcount()
		lstrparms.String_arg[i]=adw.Getitemstring(i,'po_no')
		lstrparms.Long_arg[i]=adw.GetitemNumber(i,'line_item_no')		
	Next		
End IF
lstr[]=lstrparms[]
return ll_ret

end function

public function integer of_any_tables (readonly string as_table[], readonly string as_where[]);//This function is called to retrieve the values from any table for any where clause.
//You also have to mention which project_id in where clause parameter.
String ERRORS, sql_syntax
string presentation_str, dwsyntax_str
Integer i
long ll_rtn
ll_rtn = 1
FOR i=1 TO upperbound(as_table)
	ids_tables[i] = Create Datastore
	sql_syntax = "Select * from  "+ "dbo." + trim(as_table[i]) 
IF not isnull(as_where[i]) and as_where[i] <> "" THEN sql_syntax = sql_syntax + " where " + as_where[i]
//" where project_id = '" + gs_project + "'"

presentation_str = "style(type=grid)"

dwsyntax_str = SQLCA.SyntaxFromSQL(sql_syntax, &
	presentation_str, ERRORS)

IF Len(ERRORS) > 0 THEN
	MessageBox("Caution", &
	"SyntaxFromSQL caused these errors: " + ERRORS)
	ll_rtn = -1
	exit
END IF
	sql_syntax = "Select * from  "+ "dbo." + trim(as_table[i]) 
	IF not isnull(as_where[i]) and as_where[i] <> "" THEN 
		//This will take care of a where cluase having 'where' or wothout 'where' clause word
		if mid(trim(lower(as_where[i])),1,5) <>  'where' THEN 
			sql_syntax = sql_syntax + " where " + as_where[i]		
		ELSE
			sql_syntax = sql_syntax + as_where[i]	
		END IF	
	END IF	
	//" where project_id = '" + gs_project + "'"
	
	presentation_str = "style(type=grid)"
	
	dwsyntax_str = SQLCA.SyntaxFromSQL(sql_syntax, &
		presentation_str, ERRORS)
	IF Len(ERRORS) > 0 THEN
	MessageBox("Caution", &
	"SyntaxFromSQL caused these errors: " + ERRORS)
	ll_rtn = -1
	Exit
END IF	
	ids_tables[i].Create( dwsyntax_str, ERRORS)
	ids_tables[i].SetTransObject(SQLCA)
	IF Len(ERRORS) > 0 THEN
		MessageBox("Caution", &
		"Create cause these errors: " + ERRORS)
		ll_rtn = -1
		Exit
	ELSE
		ids_tables[i].Retrieve()
END IF
NEXT
return ll_rtn

end function

public subroutine of_ro_multiplepo (str_parms arg_str_parms);str_parms	lstrparms, lstroldparms
String ls_sku,ls_inventory_type,ls_ro_no,ls_lot_no,ls_l_code,ls_po_no, lsErrText
String ls_serialised_ind,ls_lot_controlled_ind,ls_po_controlled_ind
long ll_upbound,ll_old_row,ll_curr
integer i
long ll_Line_Item_No
// Calling w_serial no windows




lstrparms = arg_str_parms


lstrparms.String_arg[4] = "MODIFY"

lstroldparms = lstrparms

IF NOT isnull(lstrparms.Long_arg[1]) and &
   NOT isnull(lstrparms.String_arg[1]) and &
	NOT isnull(lstrparms.String_arg[2]) and &
	NOT isnull(lstrparms.String_arg[3])  THEN
	
			openwithParm(w_ro_multipo,lstrparms)
			
			lstrparms = message.PowerobjectParm
			
			
			//Send back a -1 if they cancel
			
			if UpperBound(lstrparms.String_arg[]) > 0 then
				if lstrparms.String_arg[1] = "-1" then RETURN 
			end if
	
			Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

			ll_upbound=UpperBound(lstrparms.String_arg[])

			//lstroldparms.Long_arg[1]  - Line_Item_No
			//lstroldparms.String_arg[1] - SKU
			//lstroldparms.String_arg[2] - Supp Code
			//lstroldparms.String_arg[3] = RO NO

			if lstroldparms.Long_arg[1] > 0 then

				  DELETE FROM Receive_XRef
							WHERE sku = :lstroldparms.String_arg[1] AND 
									line_item_no = :lstroldparms.Long_arg[1] AND 
									ro_no = :lstroldparms.String_arg[3]
									USING SQLCA;
								
			else

				  DELETE FROM Receive_XRef
							WHERE sku = :lstroldparms.String_arg[1] AND 
									ro_no = :lstroldparms.String_arg[3]
									USING SQLCA;								
							
			end if
		
				If sqlca.sqlcode <> 0 Then
					lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
					Execute Immediate "ROLLBACK" using SQLCA;
					Messagebox("DB Update"," Unable to save new Multi PO record to database!~r~r" + lsErrText)
					SetPointer(Arrow!)
					RETURN
				End If			
	
			
			if ll_upbound > 0 then
			
				FOR i= 1 TO ll_upbound
	
	
					//Is It OK to wipe them and then re-add them?
					
//					ll_Line_Item_No = 
	
					Insert Into Receive_XRef
						(po_no, project_id, ro_no, line_item_no, sku, supp_code)
						VALUES (:lstrparms.String_arg[i], :gs_Project, :lstroldparms.String_arg[3], :lstrparms.Long_arg[i], :lstroldparms.String_arg[1], :lstroldparms.String_arg[2] )
						USING SQLCA;
	
					If sqlca.sqlcode <> 0 Then
						lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
						Execute Immediate "ROLLBACK" using SQLCA;
						Messagebox("DB Update","Error saving PO: " +lstrparms.String_arg[i]  + " Unable to save new Multi PO record to database!~r~r" + lsErrText)
						SetPointer(Arrow!)
						RETURN
					End If	


				NEXT 
				
			
			END IF
			
			Execute Immediate "COMMIT" using SQLCA;

END IF


end subroutine

public function integer of_create_comp_child (long alrow, ref datawindow adw_main, ref datawindow adw_pick, ref window aw_window);// 10/00 PCONKL - This function will create the child component pic Rows for a parent component picking row

u_ds	lds_item_component
n_ds_content	ldsContent
Long	llChildCount, llChildPos, llContentCount,	llContentPos, llCompRow, llOwner,		&
		llComponentNo,	llFindRow, llCompFindRow, llArrayPos, llNewRow
		
DECIMAL	ldReqQty, ldAvailQty, ldParentQty , ldTotReqQty, ldTotAvailQty, ldTotAvailParentQty, ldlevel2Qty, ldPartialQty,	&
			ldSetQty
			
String	lsSku, lsSupplier, lsSerial, lsLot, lsPO, lsPO2, lsChildSku, lsChildSupplier,	lsWarehouse,lsItemGroup,		&
			lsInvType, lsFilter,	lsLoc, lsCompInd,	lsFind, lsSQL, lsModify, lsRC, lsOwnerCD, lsOwnerType, lssku_a,	&
			lsQty1, lsQty2, lsCompType
	
Integer	liRC

Boolean	lbOK, lbPickShort, lbPartialfwdPick, lbSecondPass

SetPointer(HourGlass!)

lds_item_component = Create u_ds
lds_item_component.dataobject = 'd_item_component_parent'
lds_item_component.SetTransObject(SQLCA)

// 08/04 - PCONKL - Components need an instance variable with retrivestart=2 so that multiple parents won't allocate the same instance of children in of_creat_comp_Child
If NOt isvalid(ids_Comp_content) THen
	ids_Comp_content = create n_ds_Content
	ids_Comp_Content.dataobject = 'd_do_auto_pick'
	ids_Comp_Content.settransobject(sqlca)
End If

lsWarehouse = adw_main.GetItemString(1,"wh_code")
lsSku = adw_pick.GetItemString(alRow,"sku")
lsSupplier = adw_pick.GetItemString(alRow,"supp_code")
lsLoc = adw_pick.GetItemString(alRow,"l_code")
lsInvType = adw_pick.GetItemString(alRow,"inventory_type")
llOwner = adw_pick.GetItemNumber(alRow,"Owner_id")
llComponentNo = adw_pick.GetItemNumber(alRow,"component_no")

//If we are picking the children for a parent that was received in full (Component_no > 0), Then we only want to pick the
//children based on the sku and component_No. The owner or Inv Type of the parent might have been changed in a stock adjustment
// and the children would not have been updated.

//Refrenece to COntent will either be to instance variable for non pre-kitted components or to Content which only has the children (component_no > 0)
// for the given component

If llComponentNo > 0 Then
	ldsContent = create n_ds_Content
	ldsContent.dataobject = 'd_do_auto_pick_component'
	ldsContent.settransobject(sqlca)
Else
	ldsContent = ids_Comp_Content /*existing instance variable for shared content*/
End If

//Remove any previous filter
ldsContent.SetFilter('')
ldsContent.Filter()

lsSQl = ldsContent.Describe("DataWindow.Table.Select") //Get original sql so we can modify (remove paramters)

//If allowing Alt Supplier, remove from where clause on COntent datastore
If g.is_allow_alt_supplier_pick = 'Y' or g.is_allow_alt_supplier_pick = 'A' Then

	//Modify SQL to remove retrieval based on Supplier/Owner
// TAM 2012/10/03  SQL is not same as the replace string, Supplier code is last in the where clause. The "AND" needs to be in front
//	If Pos(lsSQl,'Content.Supp_Code = :a_supp_code  AND') > 0 Then
//		lsSql = Replace(lsSQl,Pos(lsSQl,'Content.Supp_Code = :a_supp_code  AND'),38,'') /*remove Supplier*/
	If Pos(lsSQl,'AND Content.Supp_Code = :a_supp_code') > 0 Then
		lsSql = Replace(lsSQl,Pos(lsSQl,'AND Content.Supp_Code = :a_supp_code'),38,'') /*remove Supplier*/
	End If
		
End If /*Allow alt supplier Pick*/
	
//Always remove Owner - child may not have same owner as parents*/
If Pos(lsSQl,'content.owner_id = :a_owner_id AND') > 0 Then
	lsSql = Replace(lsSQl,Pos(lsSQl,'content.owner_id = :a_owner_id AND'),35,'') /*remove owner*/
End If
				
lsModify = 'DataWindow.Table.Select="' + lsSQL + '"'
lsRC = ldsContent.Modify(lsModify)
	
//Set Sort on Content - c_sort may be set below to sort owner to top (3com)
If g.is_pick_sort_order > ' ' Then
	liRC = ldsContent.SetSort("c_Sort D, " + g.is_pick_sort_order)
Else
	liRC = ldsContent.SetSort("c_Sort D, Complete_Date A")
End If

lds_item_component.Retrieve(gs_project,lssku,lsSupplier, "C") /* 08/02 - PCONKL - default component type to 'C' (DW/DB Table also being used for Packaging*/

llChildCount = lds_item_component.RowCount()
llCompRow = alRow
 
//get out if no children
If llChildCount = 0 Then REturn 0
 
//First pass, Retrieve the content records for all children if not already retrieved - we may need to pick the same children across multiple parents - don't want to allocate smae instance of stock more than once
For llChildPos = 1 to llChildCount /*each Component Child Row*/
	
	aw_window.SetMicroHelp('Generating pick list for item ' + String(alrow) +  " (Child " + String(llChildPos) + " of " + String(llchildCount) + ") (first pass - retrieving inventory records)")
	
	lsChildSku = lds_item_component.GetItemString(llChildPos,"sku_child")
	lsChildSupplier = lds_item_component.GetItemString(llChildPos,"supp_code_child")
	
	//If the child SKU is the same as the Parent SKU - Continue,otherwise we'll loop (parent can't include itself in the child list)
	If lsSKU = lsChildSKU Then Continue
	
	lsFind = "Upper(SKU) = '" + Upper(lsChildSku) + "'" 
	If g.is_allow_alt_supplier_pick = 'N' Then 
		lsFind += " and Upper(supp_code) = '" + Upper(lsChildSupplier) + "'"
	End If
	
	llCompFindRow = ldsContent.Find(lsFind,1,ldsContent.RowCOunt())
	If llCompFindRow = 0 Then
		//Retrievestart=2 - adding records to existing
		If llComponentno > 0 Then
			llContentCount = ldsContent.Retrieve(gs_project, lsWarehouse, lsChildSku, lsChildSupplier,llComponentNo) /*only retreivn for current component number) */
		Else
			llContentCount = ldsContent.Retrieve(gs_project, lsWarehouse, lsChildSku, lsInvType,lsChildSupplier,llOwner) /*owner and supplier not included in Where if removed above*/
		End If
	End If
	
Next /*Child Record */

//Second Pass - Make sure we have enough children to make the necessary parent before we actually build the records
//						we may have enough of one but not all - reduce parent qty to the least available of the children

//	If Checkbox on Delivery order set to allow partial BOM Pick, by-pass this step
// If component No > 0 then this is the first pass to build from pre-kitted parents. We can allow partials to be picked
// here because we will call this function again at the end to build from free stock

If w_do.tab_main.tabpage_pick.cbx_partial_bom.checked or llcomponentNo > 0 Then
	lbOK = True
Else
	lbOK = False
End If

Do Until lbOK
	
	ldParentQty = adw_pick.GetItemNumber(alRow,"quantity")
	
	// 04/05 - PCONKL - due to FWD Picking, we may be adding to existing Parent Picking rows during multiple passes
	//				Each pass will build the children so we only want to build for the additional qty each time
	
	ldParentQty = ldParentQty - idexistingqty /*existing qty is what was existing on existing row*/
	
	//Once Parent qty has been reduced to zero, no need to continue trying to allocate children
	If ldParentQty = 0 Then
		lbOk = True
		Exit
	End If
	
	For llChildPos = 1 to llChildCount /*each Component Child Row*/
			
		aw_window.SetMicroHelp('Generating pick list for item ' + String(alrow) +  " (Child " + String(llChildPos) + " of " + String(llchildCount) + ") (second pass - checking availability)")
	
		//Sum available for this SKU
		lsChildSku = lds_item_component.GetItemString(llChildPos,"sku_child")
		lsChildSupplier = lds_item_component.GetItemString(llChildPos,"supp_code_child")
		
		//If the child SKU is the same as the Parent SKU - Continue,otherwiase we'll loop (parent can't include itself in the child list)
		If lsSKU = lsChildSKU Then Continue
		
		lsFilter = "Upper(SKU) = '" + Upper(lsChildSku) + "'" 
		
		If g.is_allow_alt_supplier_pick = 'N' Then /*ony allow for primary child supplier to be picked */
			lsFilter += " and Upper(supp_code) = '" + Upper(lsChildSupplier) + "'"
		End If
		
		ldsContent.SetFilter(lsFilter)
		ldsContent.Filter()
		
		llContentCount = ldsContent.RowCount()
		ldAvailQty = 0
		
		For llContentPos = 1 to llContentCount
			
			If isNull(llComponentNO) or llComponentNO = 0 Then /* not received as a completed kit, build from free stock*/
				ldAvailQty += ldsContent.GetItemNumber(llContentPos,"avail_qty")
			Else
				ldAvailQty += ldsContent.GetItemNumber(llContentPos,"component_qty")
			End If
			
		Next /*content record */
		
		//Do we have enough children for all the required Parents?
		If Truncate((ldAvailQty / lds_item_component.GetItemNumber(llChildPos,"child_qty")),0) < ldParentQty Then /* not enough*/
		
			//If this child is also a parent, then ignore shortage for now, we'll blow out children
			Select Component_ind, Component_Type
			Into	:lsCompInd, :lsCompType
			From ITem_master
			Where Project_id = :gs_Project and sku = :lsChildSKU and supp_Code = :LsChildSupplier;
			
			If lsCompInd = 'Y' and lsCompType = 'D' Then
				lbOK = True
			Else
				
				//REduce the parent pick qty and add back any existing qty from previous pass
				adw_pick.SetItem(alRow,'Quantity',Truncate((ldAvailQty / lds_item_component.GetItemNumber(llChildPos,"child_qty")),0) + idExistingQty)

				//Start the process over with the reduced amount
				lbOK = False
				Exit
				
			End IF
			
		Else /*enough*/
			lbOK = True
		End If
		
	Next /*Child - second pass */

Loop /* OK? */

//Third pass - Build each Component Row, all should be available after 2nd pass above (unless we are allowing for a partial BOM to be picked)

ldParentQty = adw_pick.GetItemNumber(alRow,"quantity") /* May have been reduced above in stage 2*/
ldParentQty = ldParentQty - idexistingqty /*existing qty is what was existing on existing row*/

//If Parent QTY has been reduced to zero, no need to build empty child rows here
If ldParentQty = 0 Then Return 0

For llChildPos = 1 to llChildCount /*each Component Child Row*/
	
	lbSecondPass = False
	
	aw_window.SetMicroHelp('Generating pick list for item ' + String(alrow) +  " (Child " + String(llChildPos) + " of " + String(llchildCount) + ") (Third pass - creating pick)")

	//Get serialized ind - 
	lsChildSku = lds_item_component.GetItemString(llChildPos,"sku_child")
	lsChildSupplier = lds_item_component.GetItemString(llChildPos,"supp_code_child")
	
	//If the child SKU is the same as the Parent SKU - Continue,otherwise we'll loop (parent can't include itself in the child list)
	If lsSKU = lsChildSKU Then Continue
	
	Select serialized_ind, Component_ind, Component_Type, lot_controlled_ind, po_controlled_Ind, po_no2_Controlled_Ind, Grp, qty_2
	Into :lsSerial, :lsCompInd, :lsCompType, :lsLot, :lsPO, :lsPO2, :lsItemGroup, :ldLevel2Qty
	From Item_master
	Where project_id = :gs_project and sku = :lsChildSku and supp_code = :lsChildSupplier
	Using SQLCA;
		
		
	// 08/04 - PCONKL - If building from free stock (not received as a kit), don't filter by location or component # - take any stock
	If llComponentNO > 0 Then /* Received as a completed kit*/
		lsFilter = "Upper(SKU) = '" + Upper(lsChildSku) + "' and component_no = " + String(llComponentNO) 
	Else 
		lsFilter = "Upper(SKU) = '" + Upper(lsChildSku) + "' and avail_qty > 0" /* COntent always filtered by at least current sku*/
	End If /* not recived as a completed kit */
	
	ldsContent.SetFilter(lsFilter)
	ldsContent.Filter()
	
	llContentCount = ldsContent.RowCount()
	
	// 04/05- PCONKL - For Fwd Pick we will either sort the FWD Pick location to the top or bottom
	If llComponentNO = 0 Then /*no need to sort if children are attached to parent*/
		
		ldPartialQty =	of_fwd_pick_sort(ldParentQty, ldLevel2Qty, ldsContent)
		If ldPartialQty > 0 Then
			lbPartialFwdPick = True
		End If
		
	End If
	
	// For 3COM, we want to always pick 3COM owned first
	If upper(gs_Project) = '3COM_NASH' Then
		
		//only need to retrieve 3COM owner ID once
		If isnull(il3comOwnerID) or il3comOwnerID = 0 Then
			
			Select Owner_id into :il3comOwnerID
			From Owner 
			where Project_id = :gs_project and Owner_cd = '3Com' and owner_type = 'S';
			
		End If
		
		//Sort 3COM to top of the heap - setting c_sort to 10 will sort to top (sorted descending)
		If llComponentNo = 0 Then
			For llContentPos = 1 to llContentCount
				If ldsContent.GetITemNumber(llContentPos,'owner_id') = il3comOwnerID Then
					//We still want to sort the FWD Pick loc to the of the 3com owned pile
					If ldsContent.GetITemString(llContentPos,'l_code') = ldsContent.GetITemString(llContentPos,'fwd_pick_location') and lbPartialFwdPick Then
						ldsContent.SetItem(llContentPos,'c_sort',10)
					Else
						ldsContent.SetItem(llContentPos,'c_sort',5)
					End If
				Else
					ldsContent.SetItem(llContentPos,'c_sort',0)
				End IF
			Next
		End If
				
	End If /* 3com */
	
	ldsContent.Sort()
	
	//Required Qty = Pick Qty for Parent * extended QTY for Child
	ldReqQty = ldParentQty * (lds_item_component.GetItemNumber(llChildPos,"child_qty"))
	ldTotReqQty = ldReqQty
	ldTotAvailQty = 0 /*will be sum of all child QTY - used to reduce parent qty if not enough to satisfy need*/
	
	//If no avialbale Inventory, we still want to build an empty row
	If llContentCount = 0 Then
		
		llCompRow ++
		adw_pick.InsertRow(llCompRow)
		adw_pick.SetItem(llComprow,"line_item_no",adw_pick.GetITemNumber(alRow,"line_Item_no"))
		adw_pick.SetItem(llComprow,"component_no",adw_pick.GetITemNumber(alRow,"Component_no"))
				
		// 08/04 - Pconkl - If parent Component # is 0, it isn't really a component, we're just blowing out on Pick List, children are real
		//If adw_pick.GetITemNumber(alRow,"Component_no") > 0 Then
		//	adw_pick.SetItem(llComprow,"sku_parent",adw_pick.GetItemString(alRow,"SKU"))
			adw_pick.SetItem(llComprow,"sku_parent",adw_pick.GetItemString(alRow,"SKU_Parent"))
		//Else
			//adw_pick.SetItem(llComprow,"sku_parent", lds_item_component.GetItemString(llChildPos,"sku_child"))	
		//End If
				
		adw_pick.setitem(llComprow,'do_no', adw_pick.GetItemString(alRow,"do_no"))
		adw_pick.SetItem(llComprow,"inventory_type",lsInvType)	
		adw_pick.SetItem(llCompRow,"sku",lds_item_component.GetItemString(llChildPos,"sku_child"))
		adw_pick.SetItem(llCompRow,"supp_code",lds_item_component.GetItemString(llChildPos,"supp_code_child"))
		adw_pick.SetItem(llCompRow,"quantity",0)
		
		If isNull(llComponentNO) or llComponentNO = 0 Then /* not received as a completed kit, build from free stock*/
			adw_pick.SetItem(llComprow,"component_ind", 'W') /* picked from free stock - we'll allow the users to override the Pick*/
		Else
			adw_pick.SetItem(llComprow,"component_ind", '*')	/*it's only a child - part of a finished Kit*/
		End If
		
		//Notify User of shortage if not a component itself (we will continue to blow out until just children)
		If lsCompInd <> 'Y' and lsCompType <> 'D' Then
			
			llArrayPos = Upperbound(istr_Pickshort.String_arg)
			llArrayPos ++

			lsSKU_a = lsChildSku + '/' + lsChildSupplier
			lsQTY1 = string(ldTotReqQty) /*requested*/
			lsQTY2 = "0"
			istr_Pickshort.String_arg[llArrayPos] = lsSKU_a + '|' + lsQTY1 + '|' +  lsQTY2
			
		End If
		
	End If /* No inventory at all */
	
	//build a pick record For each Content record needed to match qty
	llContentCount = ldsContent.RowCount()
	llContentPos = 0
//	For llContentPos = 1 to llContentCount
	Do While llContentPos < llContentCount
				
		llContentPos ++
		
		// 08/04 - PCONKL If building from free stock, use available qty, else use component qty
		If isNull(llComponentNO) or llComponentNO = 0 Then /* not received as a completed kit, build from free stock*/
			ldAvailQty = ldsContent.GetItemNumber(llContentPos,"avail_qty")
		Else
			ldAvailQty = ldsContent.GetItemNumber(llContentPos,"component_qty")
		End If
		
		ldTotAvailQty += ldAvailQty /* sum of qty in all child content records*/
		
		If ldAvailQty <= 0 or ldReqQty <= 0 Then Continue
		
		// 04/05 - PCONKL -  If we have a partial carton qty to pick on a FWD Pick, pick only the partial QTY from the FWD Pick
		//							location on the first pass. If not all picked in the first pass, we will have a second pass
		If lbPartialFwdPick and ldsContent.GetItemString(llContentPos,'l_code') = ldsContent.GetItemString(llContentPos,'fwd_pick_location') and &
			ldPartialQty = 0 and not lbSecondPass Then Continue
		
		//09/02 - Pconkl - We may need to combine child Picking rows if we are multiple componenet levels deep and mid level components have the same children
		lsFind = "sku = '" + lds_item_component.GetItemString(llChildPos,"sku_child") + "' and Supp_code = '" + ldsContent.GetItemString(llContentPos,"supp_code") + "' and line_item_no = " +  String(adw_pick.GetITemNumber(alRow,"line_Item_no"))
		lsFind += " and l_code = '" + ldsContent.GetItemString(llContentPos,"l_code") + "' and component_no = " + String(ldsContent.GetITemNumber(llContentPos,"component_no"))
		lsFind += " and Owner_ID = " + String(ldsContent.GetItemNumber(llContentPos,"owner_ID"))
		lsFind += " and Country_Of_Origin = '" + ldsContent.GetItemString(llContentPos,"Country_Of_Origin") + "'"
		lsFind += " and Lot_no = '" + ldsContent.GetItemString(llContentPos,"Lot_no") + "'"
		lsFind += " and po_no = '" + ldsContent.GetItemString(llContentPos,"po_no") + "'"
		lsFind += " and po_no2 = '" + ldsContent.GetItemString(llContentPos,"po_no2") + "'"
		lsFind += " and Container_Id = '" + ldsContent.GetItemString(llContentPos,"Container_ID") + "'"
		lsFind += " and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldsContent.GetItemDateTime(llContentPos,"Expiration_date"),'mm/dd/yyyy hh:mm') + "'" 
		lsFind += " and zone_id = '" + lds_item_component.GetItemString(llChildPos,"bom_Group") + "'" /* 05/05 - PCONKL */
			
		llFindRow = adw_pick.Find(lsFind,1,adw_pick.RowCOunt())
		
		If llFindRow > 0 Then /*update existing child row */
		
			//04/05 - PCONKL - Fwd Pick - If we have a partial qty to pick and this is the fwd pick loc, only pick that amt. 
			If ldPartialQty > 0 and ldsContent.GetItemString(llContentPos,'l_code') = ldsContent.GetItemString(llContentPos,'fwd_pick_location') and not lbSecondPass Then
				ldSetQty = ldPartialQty
			Else
				ldSetQty = ldReqQty
			End If
		
			//If ldAvailQty >=ldReqQty Then
			If ldAvailQty >=ldSetQty Then
				
				adw_pick.SetItem(llFindRow,"quantity",(adw_pick.GetITemNUmber(llFindRow,"quantity") + ldSetQty))
				
				//08/04 - PCONKL - If building from free stock, update available qty, otherwise component qty
				If isNull(llComponentNO) or llComponentNO = 0 Then /* not received as a completed kit, build from free stock*/
					ldsContent.SetItem(llContentPos,"Avail_qty",(ldAvailQty - ldSetQty))
				Else
					ldsContent.SetItem(llContentPos,"component_qty",(ldAvailQty - ldsetQty))
				End If
				
				ldReqQty = ldReqQty - ldSetQty
				ldpartialQty = 0
				
			Else
				
				adw_pick.SetItem(llFindRow,"quantity",(adw_pick.GetITemNUmber(llFindRow,"quantity") + ldAvailQty))
				
				//08/04 - PCONKL - If building from free stock, update available qty, otherwise component qty
				If isNull(llComponentNO) or llComponentNO = 0 Then /* not received as a completed kit, build from free stock*/
					ldsContent.SetItem(llContentPos,"Avail_qty",0)
				Else
					ldsContent.SetItem(llContentPos,"component_qty",0)
				End IF
				
				ldReqQty = ldReqQty - ldAvailQty
				ldPartialQty = ldPartialQty - ldAvailQty
				
			End If
				
			// 03/05 - Bobcat is storing BOM Group (Workstation) in Zone_ID on Pick
		//	If gs_Project = 'BOBCAT' and adw_pick.GetITemString(llFindRow,"User_Field1") <> '-' Then
		//		adw_pick.SetItem(llFindRow,"Zone_ID",  lds_item_component.GetItemString(llChildPos,"bom_Group"))
		//	End If
				
		Else /*insert a new child row*/
			
			llCompRow ++
			adw_pick.InsertRow(llCompRow)
			adw_pick.SetItem(llComprow,"line_item_no",adw_pick.GetITemNumber(alRow,"line_Item_no"))
			adw_pick.SetItem(llComprow,"component_no",ldsContent.GetItemNumber(llContentPos,"component_no"))	
			adw_pick.SetItem(llComprow,"sku_parent",adw_pick.GetItemString(alRow,"SKU_Parent"))
			adw_pick.setitem(llComprow,'do_no', adw_pick.GetItemString(alRow,"do_no"))
			adw_pick.SetItem(llComprow,"inventory_type",ldsContent.GetItemString(llContentPos,"inventory_type"))	
			adw_pick.SetItem(llComprow,"owner_id", ldsContent.GetItemNumber(llContentPos,"owner_ID"))	
			adw_pick.SetItem(llComprow,"l_code", ldsContent.GetItemString(llContentPos,"l_code"))
			adw_pick.SetItem(llComprow,"lot_no", ldsContent.GetItemString(llContentPos,"lot_no"))
			adw_pick.SetItem(llComprow,"po_no", ldsContent.GetItemString(llContentPos,"po_no"))
			adw_pick.SetItem(llComprow,"po_no2", ldsContent.GetItemString(llContentPos,"po_no2"))
			adw_pick.SetItem(llComprow,"country_of_origin", ldsContent.GetItemString(llContentPos,"country_of_origin"))
			adw_pick.SetItem(llCompRow,"sku",lds_item_component.GetItemString(llChildPos,"sku_child"))
			adw_pick.SetItem(llCompRow,"supp_code",ldsContent.GetItemString(llContentPos,"supp_code"))
			adw_pick.SetItem(llCompRow,"expiration_date",ldsContent.GetItemDateTime(llContentPos,"expiration_date"))
			adw_pick.SetItem(llCompRow,"container_id",ldsContent.GetItemString(llContentPos,"container_id"))
			adw_pick.SetItem(llCompRow,"lot_controlled_ind",lsLot)
			adw_pick.SetItem(llCompRow,"po_controlled_ind",lsPO)
			adw_pick.SetItem(llCompRow,"po_no2_controlled_ind",lsPO2)
			adw_pick.SetItem(llCompRow,"serialized_ind",lsSerial)
			adw_pick.SetItem(llCompRow,"grp",lsItemGroup)
			adw_pick.SetItem(llCompRow,"Zone_id",lds_item_component.GetItemString(llChildPos,"bom_Group")) /* 05/05 - PCONKL */
			
//			// 03/05 - PCONKL - Bobcat displaying BOM Group (Workstation) on the Picking list)
//			If gs_project = 'BOBCAT' and lds_item_component.GetItemString(llChildPos,"bom_Group") <> '-' Then
//				adw_pick.SetItem(llCompRow,"User_Field1",lds_item_component.GetItemString(llChildPos,"bom_Group") + ',')
//			End If
			
			//retrieve the owner Code/Type for Owner ID
				
			llOwner = ldsContent.GetItemNumber(llContentPos,"owner_ID")
				
			Select Owner_cd, owner_type into :lsOwnerCD, :lsOwnerType
			From Owner
			Where Owner_id = :llOwner;
		
			adw_pick.SetItem(llComprow,"cf_owner_name", lsOwnerCd + '(' + lsOwnerType + ')')	
				
			//04/05 - PCONKL - Fwd Pick - If we have a partial qty to pick and this is the fwd pick loc, only pick that amt. 
			If ldPartialQty > 0 and ldsContent.GetItemString(llContentPos,'l_code') = ldsContent.GetItemString(llContentPos,'fwd_pick_location') and not lbSecondPass Then
				ldSetQty = ldPartialQty
			Else
				ldSetQty = ldReqQty
			End If
			
			//Set Qty
			//If ldAvailQty >=ldReqQty Then
			If ldAvailQty >=ldSetQty Then
					
				adw_pick.SetItem(llCompRow,"quantity",ldSetQty)
					
				//08/04 - PCONKL - If building from free stock, update available qty, otherwise component qty
				If isNull(llComponentNO) or llComponentNO = 0 Then /* not received as a completed kit, build from free stock*/
					ldsContent.SetItem(llContentPos,"avail_qty",(ldAvailQty - ldSetQty))
				Else
					ldsContent.SetItem(llContentPos,"component_qty",(ldAvailQty - ldSetQty))
				End If
					
			//	ldReqQty = 0
				ldReqQty = ldreqQty - ldSetQty
				ldPartialQty = 0
					
			Else
					
				adw_pick.SetItem(llCompRow,"quantity",ldAvailQty)
					
				//08/04 - PCONKL - If building from free stock, update available qty, otherwise component qty
				If isNull(llComponentNO) or llComponentNO = 0 Then /* not received as a completed kit, build from free stock*/
					ldsContent.SetItem(llContentPos,"Avail_qty",0)
				Else
					ldsContent.SetItem(llContentPos,"component_qty",0)
				End If
					
				ldReqQty = ldReqQty - ldAvailQty
				ldPartialQty = ldpartialQty - ldAvailQty
					
			End If
			
			If lsCompInd = 'Y' Then 
					
				adw_pick.SetItem(llComprow,"component_ind", 'W') /*Both*/
				of_create_comp_child(llCompRow,adw_main,adw_pick, aw_window)
				
			Else
					
				// 08/04 - PCONKL - If picked from free stock, label a 'W' (workorder and changeable), otherwise an * (part of a kit and not changeable)
				If isNull(llComponentNO) or llComponentNO = 0 Then /* not received as a completed kit, build from free stock*/
					adw_pick.SetItem(llComprow,"component_ind", 'W') /* pciked from free stock - we'll allow the users to override the Pick*/
				Else
					adw_pick.SetItem(llComprow,"component_ind", '*')	/*it's only a child - part of a finished Kit*/
				End If
					
			End If
	
		End If /*insert/update child row */
		
		// 04/05 - PCONKL - FWD Pick - we may need a second pass to pick any nrecessary remaining from the FWD Pick location
		//						if that is the only location remaining with Inventory
		If (llContentPos = llContentCount and lbPartialfwdPick) and (not lbSecondPass) Then
			
			lbSecondPAss = True
			llContentPos = 0
			Continue
			
		End If
						
	Loop /*Next Content Record*/
	
	If ldReqQty > 0 Then
				
		//If nested componenet and we didn't have enough of finsihed componenets, blow out children
		If lsCompType = 'D' Then
			
			If adw_pick.GetITemNumber(llCompRow,'quantity') = 0 or isnull(adw_pick.GetITemNumber(llCompRow,'quantity')) Then
			
				adw_pick.SetITem(llCompRow,'quantity',ldReqQty) /*qty to be blown out in children*/
				adw_pick.SetITem(llCompRow,'l_Code', 'N/A')
//				adw_pick.SetITem(llCompRow,'supp_Code', lsPickSuppCode)
				adw_pick.SetITem(llCompRow,'component_Type', lsCompType)
				adw_pick.SetITem(llCompRow,'component_Ind', 'Y')
			
				//Capture the original qty so we can notify if picked short - we will reduce the qty to that of child availability
//				ldOrigPickQty = adw_pick.GetItemNumber(llCompRow,'quantity')
			
				of_create_comp_child(llCompRow,adw_main,adw_pick, aw_window)
				
				//Report shortage if children picked short
				If adw_pick.GetITemNumber(llCompRow,'quantity') < ldReqQty Then
					lbPickShort = True
				End If
				
				adw_Pick.DeleteRow(llCompRow) /*no need to keep the parent placeholder*/
							
			Else
			
				//copy to new row	
				adw_pick.RowsCopy(llCompRow,llCompRow,Primary!,adw_Pick,999999,Primary!)
				llNewRow = adw_pick.RowCount()
				adw_Pick.SetITem(llNewRow, 'Component_no',0)
				adw_Pick.SetITem(llNewRow, 'l_code','N/A')
				adw_Pick.SetITem(llNewRow, 'Quantity',ldReqQty) /* set qty on new row to remaining required*/
				adw_pick.SetITem(llNewRow,'l_Code', 'N/A')
//				adw_pick.SetITem(llNewRow,'supp_Code', lsPickSuppCode)
//				adw_pick.SetITem(llNewRow,'owner_id', llPickOwnerId)  //TAM 2005/03/04 added for combo of components/non components
//				adw_pick.object.cf_owner_name[ llNewRow ] = g.of_get_owner_name(llPickOwnerId)
				adw_pick.SetITem(llNewRow,'component_Type', lsCompType)
				adw_pick.SetITem(llNewRow,'component_Ind', 'B')
			
				of_create_comp_child(llNewRow,adw_main,adw_pick, aw_Window)
				
				//Report shortage if children picked short
				If adw_pick.GetITemNumber(llNewRow,'quantity') < ldReqQty Then
					lbPickShort = True
				End If
				
				adw_pick.DeleteRow(llNewRow) /*no need to keep the parent placeholder*/
				
				//Instance datastore would have been refiltered in recursive call - reset here
				ldsContent.SetFilter(lsFilter)
				ldsContent.Filter()
						
			End If /*partially or non picked row */
			
			If lbPickShort Then
				
				//Notify User of shortage
				llArrayPos = Upperbound(istr_Pickshort.String_arg)
				llArrayPos ++
				lsSKU_a = lsChildSku + '/' + lsChildSupplier
				lsQTY1 = string(ldTotReqQty) /*requested*/
				lsQTY2 = string(ldTotAvailQty)
				istr_Pickshort.String_arg[llArrayPos] = lsSKU_a + '|' + lsQTY1 + '|' +  lsQTY2
				
			End If
				
		End If /*compponent built on DO */
		
	End IF /*Req Qty > 0 */
	
next /* Next Child Row*/
		
SetPointer(Arrow!)

//Remove any previous filter - we may be calling this function recursively
ldsContent.SetFilter('')
ldsContent.Filter()

Return 0
end function

public function decimal of_fwd_pick_sort (decimal adreqqty, decimal adcartonqty, ref datastore adscontent);
String	lsFwdPickLoc
Long	llFindRow
Decimal	ldPartialQty, ldMaxFwdPickQty

ldPartialQty = 0

// 04/05 - PCONKL - Forward Pick Logic - We may want to either sort the FP location first or last depending on the Qty being picked
If g.ibForwardPickEnabled and adsContent.RowCount() > 0 Then
		
	ldMaxFwdPickQty = adsContent.GetITemNumber(1,'max_qty_to_Pick') /* max amt to pick from the forward Pic Location*/
	lsFwdPickLoc = adsContent.GetITEmString(1,'fwd_pick_location')
		
	If ldMaxFwdPickQty > 0 and lsFwdPickLoc > '' Then /*setup to fwd pick this SKU */
					
		If adReqQty <= ldMaxFwdPickQty Then /* Pick all from FWD Pick Loc first (Sort to top) */
				
			llFindRow = adsContent.Find("Upper(l_Code) = Upper(fwd_pick_Location)",1,adsContent.RowCount()) /*This is the forwad pick location in Content*/
			Do While llFindRow > 0
				adsContent.SetItem(llFindRow,'c_sort',9) /* this will sort FWD Pick Loc to the top */
				llFindRow ++
				If llFindRow > adsContent.RowCount() Then
					llFindRow = 0
				Else
					llFindRow = adsContent.Find("Upper(l_Code) = Upper(fwd_pick_Location)",llFindRow,adsContent.RowCount())
				End If
			Loop
						
		Else /* Not going to pick all from Fwd Pick Loc*/
				
			//If the partial Pick indicates that we will pick the remainder after full carton picks from the FWD Pick loc,
			// Sort to the top and pick the balance, pick the rest from other locs. If we are not picking partials from the FWD Pick loc,
			//sort to the bottom so we pick from it last.
			
			If adsContent.GetITEmString(1,'partial_Pick_Ind') = 'Y' Then /* Pick Partials from FP area */
			
				//Determine what the partial (remainder) is
				If adcartonqty > 0 Then /* level 2 qty exists */
					ldPartialQty = Mod(adReqQty,adCartonqty) /*this is the partial pick Amt*/
				Else /*no carton qty for Item Master */
					ldPartialQty = 0
				End If
				
				If ldPartialQty > ldMaxFwdPickQty Then ldPartialQty = 0 /*If partial qty > Max, don't pick from FWD Pick Loc */
			
			Else /*Partial cartons picked from Bulk area along with full cartons*/
			
				ldPartialQty = 0
			
			End If /* Partial Pick? */
			
			If ldPartialQty > 0 Then
				
				llFindRow = adsContent.Find("Upper(l_Code) = Upper(fwd_pick_Location)",1,adsContent.RowCount()) /*This is the forwad pick location in Content*/
				Do While llFindRow > 0
					adsContent.SetItem(llFindRow,'c_sort',9) /* this will sort FWD Pick Loc to the top */
					llFindRow ++
					If llFindRow > adsContent.RowCount() Then
						llFindRow = 0
					Else
						llFindRow = adsContent.Find("Upper(l_Code) = Upper(fwd_pick_Location)",llFindRow,adsContent.RowCount())
					End If
				Loop
				
			Else /*No partial pick */
									
				llFindRow = adsContent.Find("Upper(l_Code) = Upper(fwd_pick_Location)",1,adsContent.RowCount()) /*This is the forwad pick location in Content*/
				Do While llFindRow > 0
					adsContent.SetItem(llFindRow,'c_sort',1) /* this will sort FWD Pick Loc to the bottom - pick last */
					llFindRow ++
					If llFindRow > adsContent.RowCount() Then
						llFindRow = 0
					Else
						llFindRow = adsContent.Find("Upper(l_Code) = Upper(fwd_pick_Location)",llFindRow,adsContent.RowCount())
					End If
				Loop
				
			End If /*Partial Pick qty > 0*/
			
		End If /*Req Qty < Max FWD Pick Qty? */
			
	End If /*setup to fwd pick this SKU */
	
End If /* Forward Pick Enabled*/

Return ldPartialQty
end function

public function string of_fwd_pick_replenish (ref datastore adscontent, string aspicksort);
// Filter Content to only show rows where the Content Location is the same as the FWD Pick Loc
// For those SKU's, we will want to replenish the FWD Pick Location from other available content
// based on normal picking rules. We will either create a new stock transfer or add rows to an existing
// Transfer that has not been executed yet (New status)

Long	llContentCount, llContentPos, llArrayPos, llArrayCount, llTONO, llCount, llOwner
String	lsSKU, lsSKUHold, lsSuppCode, lsSuppCodeHold, lsSKUArray[], lsSupplierArray[], lsFilter,	&
			lsWarehouse, lsProject, lsToNo, lsCOO, lsSerial, lsLot, lsPONO, lsPONO2, lsFromLoc, lsToLoc, lsInvType, &
			lsContainer, lsEmail, lstext, lsRC
Decimal	ldAvailQty, ldReqQty, ldTransferQty
DateTime	ldtToday, ldtExpDate

// pvh - 08/25/05 - GMT
//ldtToday = DateTime(today(),Now())

If Not g.ibForwardPickEnabled Then Return ""

llContentCount = adsContent.RowCount()

//Filter to show only content with a fwd pick loc
adsContent.SetFilter("Upper(l_Code) = Upper(fwd_pick_location)")
adsContent.Filter()

llContentCount = adsContent.RowCount()

If llContentCount = 0 Then Return ""

//Sort by SKU so we can sum at SKU level to determine if we are short - there may be multiple content records for each FWD Pick Loc
adsContent.SetSort("SKU A, Supp_code A")
adsContent.Sort()

ldAvailQty = 0
llArrayPos = 0

For llContentPos = 1 to llContentCount
	
	lsSKU = adsContent.getITemString(lLContentPos,'SKU')
	lsSuppCode = adsContent.getITemString(lLContentPos,'Supp_Code')
	
	If (lsSKU <> lsSKUHold or lsSuppCode <> lsSuppCodeHold) and llContentPos <> 1 then /*Sku changed, compare sum to Min FWD Pick Qty */
	
		If ldAvailQty <= adsContent.GetITemNumber(llContentPos,'min_fp_qty') Then /*replenishment needed*/
		
			//Array will be used to generate replenishment picks (stock transfers) against remaining content
			llArrayPos ++
			lsSKUArray[llArrayPos] = adsContent.getITemString((lLContentPos - 1),'SKU')
			lsSupplierArray[llArrayPos] = adsContent.getITemString((lLContentPos - 1),'Supp_Code')
		
		End If /* replenishment needed */
	
		ldAvailQty = 0
		
	End If /*Sku changed */
	
	ldAvailQty += adsContent.GetITemNumber(llContentPos,'avail_qty')
	
	lsSKUHold = lsSKU
	lsSuppCodeHold = lsSuppCode
	
Next /*Content Record */

//Process last/only sku
If ldAvailQty <= adsContent.GetITemNumber(llContentCount,'min_fp_qty') Then /*replenishment needed*/
	llArrayPos ++
	lsSKUArray[llArrayPos] = adsContent.getITemString((llContentCount),'SKU')
	lsSupplierArray[llArrayPos] = adsContent.getITemString((llContentCount),'Supp_Code')
End If /*replenishment needed */


//Any entries in the array need replenishment - Create/Update transfer records for the replenish qty

llArrayCount = UpperBound(lsSKuArray)
If llArrayCount = 0 Then Return ''

//See if we have a new relenishment order already. If not, create a new one.
lsProject = adsContent.GetITemString(1,'project_id')
lsWarehouse = adsContent.GetITemString(1,'wh_Code')
// pvh - 08/25/05 - GMT
//g.setCurrentWarehouse( lsWarehouse )

lsToNo = ''

select Max(to_no) into :lsTONO
From Transfer_master
Where Project_id = :lsProject and s_warehouse = :lsWarehouse and Ord_type = 'R' and Ord_status = 'X';

If isNull(lsToNo) or lsToNo = '' Then /* No open Transfer */

	//Create a new Transfer Master
	llTONO = g.of_next_db_seq(gs_project,'Transfer_Master','TO_No') /*next available Transfer Number*/
	If llToNo < 0 Then Return "-1"
	lsTONO = Trim(Left(lsproject,9)) + String(llTONO,"000000")
	// pvh - 08/25/05 - GMT
	//ldtToday = g.of_getWorldTime()
	ldtToday = datetime( today(), now() )

	Execute Immediate "Begin Transaction" using SQLCA;
	
	Insert Into Transfer_master(to_no, project_id, Ord_date, ord_status, Ord_type, s_warehouse, d_warehouse, last_user, Last_Update)
	Values							(:lstoNo, :lsProject, :ldtToday, "X", "R", :lswarehouse, :lswarehouse, :gs_userID, :ldttoday)
	using SQLCA;
	
	If SQLCA.SqlCode <> 0 Then
		Execute Immediate "ROLLBACK" using SQLCA;
		Return "-1"
	Else
		Execute Immediate "COMMIT" using SQLCA;
	End If

	//Alert Email DL that a new transfer has been created
	Select fwd_pick_email_notification into :lsEmail
	From Warehouse
	Where wh_Code = :lswarehouse;
	
	If lsEmail > '' Then
		lsText = "A new Forward Pick replenishment Stock Transfer has been created - " + lsProject + "/" + lsWarehouse + "/" + lsTONO
		g.uf_send_email(lsEmail, lsText, lsText,'')
	End If
	
End If /* no open Transfer*/


//For each Sku/Supplier, Generate Pick (transfer)
For llArrayPos = 1 to llArrayCount
	
	lsRC += lsSKUArray[llArrayPos] + ", " /*We want to report as needing relenishment even if it is already on an order (moved from below)*/
	
	//Filter content for available inventory for this sku excluding the FWD Pick Loc
	lsFilter = "Sku = '" + lsSKUArray[llArrayPos] + "'"
	
	//Include Supplier if not allowing pick from Alternate Supplier
	If g.is_allow_alt_supplier_pick = 'N' Then
		lsFilter += "and Supp_code = '" + lsSupplierArray[llArrayPos] + "'"
	End If
	
	//Only include rows with available inventory and is not the FWD Pick Loc
	lsFilter += " and avail_qty > 0 and l_code <> fwd_pick_location"
	
	adsContent.SetFilter(lsFilter)
	adsContent.Filter()
	
	llContentCount = adsContent.RowCount()
	
	If llContentCount = 0 Then Continue /*Next Sku */
	
	//If we already have this sku on the transfer, continue
	Select Count(*) into :llCount
	From transfer_Detail
	Where to_no = :lstONO and sku = :lsSKUArray[llArrayPos];
	
	If llCount > 0 Then Continue
		
	// Try to aquire enough qty from available content
	
	//Sort Content by default pick sort for project (FIFO, etc.)
	adsContent.SetSort(aspicksort)
	adsContent.Sort()
		
	ldReqQty = adsContent.GetITemNumber(1,'replenish_qty')
	llContentPos = 0
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Do While ldReqQty > 0 and llContentPos < llContentCount
		
		llContentPos ++
		
		ldAvailQty = adsContent.GetITemNumber(llContentPos,'Avail_Qty')
		If ldAvailQty <=0 Then Continue
		
		//build detail record
		llOwner = adsContent.getITemNumber(llContentPos,'owner_id')
		lsCOO = adsContent.getITemString(llContentPos,'Country_of_Origin')
		lsLot = adsContent.getITemString(llContentPos,'Lot_no')
		lsSerial = adsContent.getITemString(llContentPos,'Serial_No')
		lsPONO = adsContent.getITemString(llContentPos,'po_no')
		lsPONO2 = adsContent.getITemString(llContentPos,'po_No2')
		lsFromLoc = adsContent.getITemString(llContentPos,'l_Code')
		lsToLoc = adsContent.getITemString(llContentPos,'fwd_pick_Location')
		lsInvType = adsContent.getITemString(llContentPos,'Inventory_type')
		lsContainer = adsContent.getITemString(llContentPos,'Container_ID')
		ldtExpDate = adsContent.getITemdateTime(llContentPos,'expiration_Date')
		
		If ldAvailQty >= ldReqQty Then
			ldTransferQty = ldReqQty
			ldReqQty = 0
			adsContent.SetItem(llContentPos,'Avail_Qty',ldAvailQty - ldReqQty)
		Else
			ldTransferQty = ldAvailQty
			ldReqQty = ldReqQty - ldAvailQty
			adsContent.SetItem(llContentPos,'Avail_Qty',0)
		End If
		
		Insert Into Transfer_Detail(to_no, sku, supp_code, owner_id, country_of_Origin, serial_no, lot_no, po_no, po_no2,
											 s_Location, d_Location, Inventory_Type, Quantity, Container_ID, Expiration_Date)
		Values							(:lsTONO, :lsSKUArray[llArrayPos], :lsSupplierArray[llArrayPos], :llOwner, :lsCOO, :lsSerial, :lsLot, :lsPONO, :lsPONO2,
											:lsFromLoc, :lsToLoc, :lsInvType, :ldtransferQty, :lsContainer, :ldtExpDate)
		Using SQLCA;
		
		If SQLCA.SqlCode <> 0 Then
			Execute Immediate "ROLLBACK" using SQLCA;
			Return "-1"
		End If
				
	Loop /*Content record*/
	
	//lsRC += lsSKUArray[llArrayPos] + ", "
	
	Execute Immediate "COMMIT" using SQLCA;
	
Next /* Sku to replenish*/

//Return the list of SKUs that we generated a transfer request for
lsRC = Trim(lsRC)
If Right(lsRC,1) = "," then
	lsRC = Left(lsRC,(len(lsRC) - 1)) /*remove last comma*/
End If

Return lsRC
end function

public function long of_val_serial_nos (string as_ord_nbr, string as_ord_type, string as_serial_no_entered, long al_edibatch, string as_sku, string as_user_line_item_no, string as_serialized_ind);


// 07/14/2010 ujh: 03 of ???    Validate Serial # DoubleClick   Function that validates
String ls_serial_no, ls_serial_no_sent

	// 03/01/2011 ujh: Fix I-155  Serialized_ind = 'Y' not being validated.
	// Try to get serial no to validate against based on order type and serial capture indicator
	If upper(as_ord_type) = 'Z' and upper(as_serialized_ind) = 'B'  Then   
					// if warehouse xfer and serial capture both inbound and outbound get serial no from Delivery_Serial_detail
					SELECT TOP 1 ds.Serial_no 
					INTO :ls_Serial_no
					FROM Delivery_Picking_Detail dp
					JOIN Delivery_Master dm on dm.DO_no = dp.DO_no
					JOIN Delivery_Serial_Detail ds on ds.ID_NO = dp.ID_No
							and dm.project_id = :gs_project
							and dm.Invoice_NO = :as_Ord_Nbr
							and ds.Serial_no = :as_serial_no_entered
							and dp.SKU = :as_sku                                            // 11/10/2010 ujh:  Making sure serial no on inbound same as outbound
							and dp.line_item_no = :as_user_line_item_no;			// 11/10/2010 ujh:  Making sure serial no on inbound same as outbound
	
	elseIf 		upper(as_ord_type) = 'Z' and upper(as_serialized_ind) = 'Y'  then   // IF warehouse xfer and serial capture inbound
					// if warehouse xfer and serial capture 'Y' inbound  get serial no from Delivery_Picking
					//Get serial_no from delivery_picking
					SELECT TOP 1 dp.Serial_no 
					INTO :ls_Serial_no
					FROM Delivery_Picking_Detail dpd
					JOIN Delivery_Master dm on dm.DO_no = dpd.DO_no
					join Delivery_Picking dp on dp.Do_no = dpd.Do_no
							and dm.Project_id = :gs_project
							and dp.line_item_no = dpd.Line_item_no
							and dm.Invoice_NO = :as_Ord_Nbr
							and dp.Serial_no = :as_serial_no_entered
							and dpd.SKU = :as_sku                                            // 11/10/2010 ujh:  Making sure serial no on inbound same as outbound
							and dpd.line_item_no = :as_user_line_item_no;			// 11/10/2010 ujh:  Making sure serial no on inbound same as outbound
				
	else
					// Get Serial number from EDI_BAtch_Inbound_Detail
					// Was at least one serial number sent?
					SELECT TOP 1 Serial_no 
					INTO :ls_Serial_no_sent
					FROM EDI_Inbound_Detail
					WHERE  Project_ID = :gs_project
							and EDI_Batch_Seq_no = :al_EDIBatch
							and SKU = :as_SKU
							and Serial_no <> '-' and Serial_no <> '' ;
					// If at least one serial number was sent, then it will be used to validate
					if not isnull (ls_Serial_no_sent) and (ls_Serial_no_sent <> '') Then
							SELECT TOP 1 Serial_no 
							INTO :ls_Serial_no
							FROM EDI_Inbound_Detail
							WHERE  Project_ID = :gs_project
									and EDI_Batch_Seq_no = :al_EDIBatch
									and SKU = :as_SKU
									and Serial_no = :as_serial_no_entered;
						else
							// NO serial number was sent
							Return 0
						End if
	 End if  // End trying to get serial no to validate against based on order type and serial capture indicator
	// end 07/10/2010 ujhall:
									
				// If at least one "sent" serial number does not match the one just scanned (entered), there is a missmatich
				if upper(ls_Serial_no) <> upper(as_serial_no_entered) then
//					li_Message = messagebox(is_title, 'Serial No Missmatch! Do you want to keep serial number = '+as_serial_no,Question!, YesNo!,2)
//					if li_Message = 2 then
//						This.SetItem(row, 'Serial_no', '')  // blank out the scanned data
						return 1
					else
						return 0
					end if  // checking liMessage
				


end function

public subroutine of_wo_serial_nos (datawindow adw, long al_row);//Jxlim 01/05/2011 Clone from of_ro_serial_nos
str_parms	lstrparms
String ls_sku,ls_inventory_type,ls_wo_no,ls_lot_no,ls_l_code,ls_po_no
String ls_serialised_ind,ls_lot_controlled_ind,ls_po_controlled_ind
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 08/11/2010 ujhall: 01 of 09 Full Circle Fix: need owner_cd
String ls_owner_cd  , lsFind
long ll_owner_id, llFindRow
long ll_upbound,ll_old_row,ll_curr
long ll_received_qty,  ll_entered_qty, ll_display_quantity  //12/06/2010 ujh: SNQM; 
integer i
// Calling w_serial no windows

ll_old_row=al_row
//Messagebox("",al_row)

//16-Jan-2018 :Madhu S14839 Foot Print
Datastore lds_scan_serial
lds_scan_serial =create Datastore
lds_scan_serial.dataobject ='d_ro_scan_serialno'

lstrparms.String_arg[1] = adw.getItemString(al_row,"sku")
lstrparms.String_arg[2] = adw.GetITemString(al_row,"l_code") 
lstrparms.String_arg[6] = adw.getitemstring(al_row,'serial_no')
lstrparms.String_arg[7] = adw.getitemstring(al_row,'supp_code')

lstrparms.datastore_arg[1] = lds_scan_serial //16-Jan-2018 :Madhu S14839 Foot Print

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// 07/14/2010 ujhall: 02 of 06    Validate Serial # DoubleClick   Get values required to access serial numbers to validate against
////12/02/2010 ujh: When user_line_item_no is null use line_item_no
//if isnull(adw.getItemString(al_row,'user_line_item_no')) or adw.getItemString(al_row,'user_line_item_no') = '' then
	lstrparms.String_arg[8] = String(adw.getItemNumber(al_row,'line_item_no'), '0')  
//else
//	lstrparms.String_arg[8] = adw.getItemString(al_row,'user_line_item_no')
//end if
lstrparms.String_arg[9] = adw.getItemString(al_row,'serialized_ind')

//19-APR-2018 :Madhu DE3883 - Pass the required parameters
lstrparms.String_arg[11] = adw.getItemString(al_row,"po_no2_controlled_Ind")
lstrparms.String_arg[12] = adw.getItemString(al_row,"container_Tracking_Ind")

lstrparms.String_arg[13] = adw.getItemString(al_row,"Po_No2")
lstrparms.String_arg[14] = adw.getItemString(al_row,"Container_Id")
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

lstrparms.Long_arg[1] = adw.getItemNumber(al_row,"quantity")
ls_serialised_ind =adw.getitemstring(al_row,'serialized_ind')
ls_lot_controlled_ind =adw.getitemstring(al_row,'lot_controlled_ind')
ls_po_controlled_ind =adw.getitemstring(al_row,'po_controlled_ind')
//ls_ro_no =adw.getitemstring(al_row,'ro_no')
ls_wo_no =adw.getitemstring(al_row,'wo_no')
ls_sku=lstrparms.String_arg[1]
ls_l_code =lstrparms.String_arg[2]  
ls_inventory_type= adw.getitemstring(al_row,'inventory_type')
ls_lot_no =adw.getitemstring(al_row,'lot_no')
ls_po_no = adw.getitemstring(al_row,'po_no')
lstrparms.Long_arg[3]  = al_row // 12/06/2010 ujh: SNQM; determine row double clicked

IF NOT isnull(lstrparms.String_arg[1]) and &
   NOT isnull(lstrparms.String_arg[2]) and &
	NOT isnull(lstrparms.String_arg[4]) and &
	NOT isnull(lstrparms.String_arg[5])  THEN
			openwithParm(w_ro_serialno,lstrparms)
			lstrparms = message.PowerobjectParm
			ll_upbound=UpperBound(lstrparms.String_arg[])
			ll_curr =al_row
			FOR i= 1 TO ll_upbound
//				ll_curr =adw.Getrow()
				IF ll_curr <> ll_old_row or i > 1 THEN  
					ll_curr++
					adw.insertrow(ll_curr)		
//					ll_old_row=adw.rowcount()//all additional rows assign last row
               ll_old_row=ll_curr
				End IF	
				///////////////////////////////////////////////////////////////////////////////////////////////////////////
				// 08/11/2010 ujhall: 02 of 09 Full Circle Fix: need owner_cd
				// may be able to get owner_cd from the datawindow, but right now, don't have time to make
				//	every place that calls this function will send a datawindow where owner_cd is available. Fix when there is time.
				ll_owner_id = adw.getItemnumber(al_row,"owner_id")
				SELECT owner_cd
				Into :ls_owner_cd
				From Owner
				where project_id = :gs_project
				and owner_id = :ll_owner_id;
				///////////////////////////////////////////////////////////////////////////////////////////////////////////
				adw.Setitem(ll_old_row,"sku",ls_sku)
				adw.Setitem(ll_old_row,"sku_parent",adw.getItemString(al_row,"sku_parent")) /* 09/00 PCONKL*/
				adw.Setitem(ll_old_row,"supp_code",adw.getItemString(al_row,"supp_code")) /* 09/00 PCONKL*/
				adw.Setitem(ll_old_row,"component_ind",adw.getItemString(al_row,"component_ind")) /* 09/00 PCONKL*/
				adw.Setitem(ll_old_row,"country_of_origin",adw.getItemString(al_row,"country_of_origin")) /* 09/00 PCONKL*/
				adw.Setitem(ll_old_row,"owner_id",adw.getItemnumber(al_row,"owner_id")) /* 09/00 PCONKL*/
				
				//adw.Setitem(ll_old_row,"owner_cd",ls_owner_cd) /*08/2010 ujhall*/
				
				adw.Setitem(ll_old_row,"line_item_no",adw.getItemnumber(al_row,"line_item_no")) /* 12/01 PCONKL*/
			//	adw.Setitem(ll_old_row,"user_line_item_no",adw.getItemString(al_row,"user_line_item_no")) /* 2009/11 TAM */
				adw.Setitem(ll_old_row,"component_no",adw.getItemnumber(al_row,"component_no")) /* 09/00 PCONKL*/
				//adw.Setitem(ll_old_row,"c_owner_name",adw.getItemString(al_row,"c_owner_name")) /* 09/00 PCONKL*/
				adw.Setitem(ll_old_row,"l_code",ls_l_code)
				//adw.Setitem(ll_old_row,"ro_no",ls_ro_no)
				adw.Setitem(ll_old_row,"wo_no",ls_wo_no)
				adw.Setitem(ll_old_row,"inventory_type",ls_inventory_type)
				adw.Setitem(ll_old_row,"lot_no",ls_lot_no)
///////////////////////////////////////////////////////////////////////////////////////////////////////////
				// 12/06/2010 ujh: SNQM; Determine what qty to display on the lines posted back to main window
				ll_entered_qty =  lstrparms.Long_arg[2]  //Get the number of SNs entered on the SN entery window
				ll_received_qty = adw.getItemNumber(al_row,"quantity")  // Get the QTY show on main window

				/* 12/06/2010 ujh: SNQM;  When the # of SNs entered is less than the received qty, set the
				main window display qty (column = QTY) to one more than the difference for the first row  
				and to one for all other rows.  This is done so the QTY sum
				of all lines for this item remain the same through out the entry of serial number whether
				all numbers are entered at one time or a few at a time.*/
				if ll_entered_qty < ll_received_qty and i = 1 then
						ll_display_quantity = ll_received_qty - ll_entered_qty + 1
				else
						ll_display_quantity = 1	
				end if
				adw.Setitem(ll_old_row,"quantity",ll_display_quantity)
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//				adw.Setitem(ll_old_row,"quantity",1)
				adw.Setitem(ll_old_row,"serial_no",lstrparms.String_arg[i])
				adw.Setitem(ll_old_row,"po_no",ls_po_no)
				
				//16-Jan-2018 :Madhu S14839 - FootPrint - START
				//Assign respective values of scanned SN and PoNo2, Container Id onto Putaway list
				If upper(gs_project) ='PANDORA' Then
					lds_scan_serial = lstrparms.datastore_arg[1]
					
					If lds_scan_serial.rowcount( ) > 0 Then //Returned datastore count should be > 0.
						lsFind ="serial_no ='"+lstrparms.String_arg[i]+"'"
						llFindRow = lds_scan_serial.find( lsFind, 1, lds_scan_serial.rowcount())
	
						If llFindRow > 0 Then
							adw.Setitem(ll_old_row,"po_no2",lds_scan_serial.getItemString(llFindRow,"po_no2"))
							adw.Setitem(ll_old_row,"container_ID",lds_scan_serial.getItemString(llFindRow,"container_ID"))
						End If
					else
						adw.Setitem(ll_old_row,"po_no2",adw.getItemString(al_row,"po_no2"))
						adw.Setitem(ll_old_row,"container_ID",adw.getItemString(al_row,"container_ID"))
					End If
				else
					adw.Setitem(ll_old_row,"po_no2",adw.getItemString(al_row,"po_no2")) /* 09/00 PCONKL*/
					adw.Setitem(ll_old_row,"container_ID",adw.getItemString(al_row,"container_ID")) /* 11/02 PCONKL*/
				End If
				//16-Jan-2018 :Madhu S14839 - FootPrint - END
				
				adw.Setitem(ll_old_row,"expiration_date",adw.getItemDateTime(al_row,"expiration_Date")) /* 11/02 PCONKL*/
				adw.SetItem(ll_old_row,'serialized_ind',ls_serialised_ind)
				adw.SetItem(ll_old_row,'lot_controlled_ind',ls_lot_controlled_ind)
				adw.SetItem(ll_old_row,'po_controlled_ind',ls_po_controlled_ind)
				adw.Setitem(ll_old_row,"po_no2_controlled_Ind",adw.getItemString(al_row,"po_no2_controlled_Ind")) /* 11/02 PCONKL*/
				adw.Setitem(ll_old_row,"expiration_controlled_Ind",adw.getItemString(al_row,"expiration_controlled_Ind")) /* 11/02 PCONKL*/
				adw.Setitem(ll_old_row,"container_tracking_Ind",adw.getItemString(al_row,"container_Tracking_Ind")) /* 11/02 PCONKL*/
			NEXT 
		IF ll_upbound > 1 THEN	
//			adw.SetSort("sku A, serial_no A")
//			adw.Sort( )
		END IF	
END IF

adw.Sort()
adw.GroupCalc()

destroy lds_scan_serial
end subroutine

public function integer of_do_serial_nos (ref datawindow adw, ref long al_row, string as_wh_code);str_parms	lstrparms
str_multiparms	lstrmultiparms
//string ls_sku,ls_sku_current
//long ll_data
long ll_old_row,ll_upbound,i,ll_curr
string ls_sku,ls_l_code,ls_lot_no,ls_do_no,ls_inventory_type

//TimA 08/11/11 Pandora issue #261
//Added new parameter for WH_Code
String lsWHCode
String ls_ShipType,ls_Serial_No,is_title

IF al_row <> 0 THEN
   ll_old_row=adw.GetRow()
	lstrparms.String_arg[1]=adw.getItemString(al_row,"sku")
  	lstrparms.String_arg[2]=adw.getItemString(al_row,"l_code")
	lstrparms.String_arg[3]=adw.getItemString(al_row,"supp_code") /* 10/00 PCONKL */
  	lstrparms.Long_arg[1] = adw.getItemNumber(al_row,"quantity")
//	ls_inventory_type=adw.getItemString(al_row,"inventory_type")
	ls_do_no=adw.getItemString(al_row,"do_no")
//	ls_lot_no=adw.getItemString(al_row,"lot_no")

	lsWhCode = as_wh_Code //TimA 08/11/11
	
   OpenWithparm(w_do_serialno,lstrparms)			
			lstrmultiparms = message.PowerobjectParm
			ll_upbound=UpperBound(lstrmultiparms.string_arg1[])
		IF ll_upbound > 0 THEN	
 			ll_curr =adw.Getrow()
			FOR i= 1 TO ll_upbound
				IF ll_curr <> ll_old_row or i > 1 THEN  
					ll_curr ++
					adw.insertrow(ll_curr)
					ll_old_row= ll_curr
				End IF
				
				If gs_project = 'PANDORA' then
					//TimA 08/11/11 Pandora #261
					//******************
					ls_Serial_No = lstrmultiparms.string_arg1[i]
					select 
					Inventory_Type.Inventory_Shippable_Ind
					INTO :ls_ShipType
					from Content,Inventory_Type 
					where Content.Inventory_Type = Inventory_Type.Inv_Type and content.Project_ID = :gs_project
					and Inventory_Type.Project_ID = :gs_project
					and Content.WH_Code = :lsWhCode
					and Content.SKU = :lstrparms.String_arg[1]
					and Serial_No = :ls_Serial_No
					Using SQLCA;
		
					If ls_ShipType ="" then
						Messagebox(is_title,"'" + ls_Serial_No + "' INVALID SERIAL NUMBER:",StopSign!)
						Return -1
					End if
			
					If ls_ShipType <> 'Y' then
						Messagebox(is_title,"THIS SERIAL NUMBER '" + ls_Serial_No +"' HAS A NON-SHIPPABLE INVENTORY TYPE",StopSign!)
					Return -1
					end if
				End If
				//**************************				
				
				adw.Setitem(ll_old_row,"sku",lstrparms.String_arg[1])
				adw.Setitem(ll_old_row,"supp_code",lstrparms.String_arg[3])
				adw.Setitem(ll_old_row,"serial_no",lstrmultiparms.string_arg1[i])
				adw.Setitem(ll_old_row,"l_code",lstrmultiparms.string_arg2[i])
				adw.Setitem(ll_old_row,"do_no",ls_do_no)
				adw.Setitem(ll_old_row,"inventory_type",lstrmultiparms.string_arg5[i])
				adw.Setitem(ll_old_row,"lot_no",lstrmultiparms.string_arg3[i])
				adw.Setitem(ll_old_row,"po_no",lstrmultiparms.string_arg4[i])		
				adw.Setitem(ll_old_row,"country_of_origin",lstrmultiparms.string_arg6[i]) /* 12/00 PCONKL */
				adw.Setitem(ll_old_row,"owner_id",lstrmultiparms.long_arg1[i]) /* 12/00 PCONKL */
				adw.Setitem(ll_old_row,"quantity",1)

			   	this.of_item_master(gs_project,lstrparms.String_arg[1],lstrparms.String_arg[3],adw,ll_old_row)
			NEXT 
		End IF
		Return 1
END IF

return 1
end function

public function string of_item_master_coo (ref string as_prj_id, ref string as_sku, ref string as_supp_code);//TimA 03/01/13 Pandora issue #560

long ll_ret,ll_row
String lsCoo
ll_ret=ids_Item_Master_Coo.Retrieve(as_prj_id,as_sku,as_supp_code)
If ll_ret > 1 then
	//Look in the new Item_Master_Coo table if you find more that one record then return a blank
	//The user needs to choose a COO
	lsCoo = ''
Else
	If IsNull(ids_Item_Master_Coo.GetItemString(1, 'item_master_coo_country_of_origin')) Then
		//Nothing found in IM Coo table return the default from IM
		lsCoo = ids_Item_Master_Coo.GetItemString(1, 'item_master_country_of_origin_default')
	Else
		//One record found the the COO is populated return this
		lsCoo = ids_Item_Master_Coo.GetItemString(1, 'item_master_coo_country_of_origin')
	end if
End if

return lsCoo
end function

public function string of_get_sscc_bol (string as_project, string as_type);// TimA Pandora issue #608
// Get the SSCC or BOL calculated value
//  As or 07/01/13 the only acceptable parameters for as_type are 
//  SSCC_No
//  BOL_No

String lsDigitCalc
string lsProAlgorithm //TimA 05/21/15 Added this paramater for the Carrier Pro number in w_do.  Not needed in the SSCO_No or BOL_No calculations.
sqlca.sp_check_digit_build(as_project,as_type,lsProAlgorithm,0,lsDigitCalc)

If SQLca.SQLCode < 0 Then
	Return lsDigitCalc
End If

//Return the 18 digit code retruned from the Stored Procedure
Return lsDigitCalc
end function

public function long of_validate_sscc_digit (string as_sscc_no);// TimA Pandora issue #608
// Validate the SSCC digit. 


Long llDigit
//Pass the SSCC number
sqlca.sp_check_digit_calc(as_sscc_no, llDigit)

If SQLca.SQLCode < 0 Then
	Return -1
End If

//Return the 18 digit code retruned from the Stored Procedure
Return llDigit
end function

public function long of_error_serial_prior_receipt (string as_project_id, string as_sku, string as_serial_no, string as_owner_cd, string as_component_ind, long al_component_no, boolean ab_error_on_exists, boolean ab_skipcomponent, ref string ab_error_message_title, ref string ab_error_message);
//TAM 2013/11 -  Added a check of previous orders to see if this serial number has ever been received.  If it has present a descision window to override.	(Currently Friedrich Only)			


string ls_serial_no_db
f_method_trace_special( gs_project, this.ClassName() + ' -of_error_serial_prior_receipt','Start of_error_serial_prior_receipt: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd," "), ' ', ' ', ' ' ,' ') //08-Feb-2013  :Madhu added
		
If gs_project = 'FRIEDRICH' Then
	SELECT serial_no INTO :ls_serial_no_db 
	FROM Receive_Master RM inner join Receive_Putaway RP on RM.RO_No=RP.ro_no
		WHERE Project_Id = :as_project_id and sku = :as_Sku and serial_no = :as_serial_no  ;

	If ls_serial_no_db <> "" then
		If Messagebox('Serial # Error', "Serial Number already exists in a previous receive order." &
		+'~r~r'+"Ignore Duplicate?", StopSign!, YesNo!, 2 ) = 2 then
			f_method_trace_special( gs_project, this.ClassName() + ' -of_error_on_serial_no_exists','Error The serial number already exists internally in SIMS: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,""), ' ', ' ', ' ' ,' ') //08-Feb-2013  :Madhu added						
			Return 1
		End If
	End if
End if

			
f_method_trace_special( gs_project, this.ClassName() + ' -of_error_serial_prior_receipt','Error Return without error as the serial number did not exist in a prior receive order or the was overridden: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,""), ' ', ' ', ' ',' ' ) //08-Feb-2013  :Madhu added
return 0  // return without error as the serial number did not exist in the table nor in SIMS.

end function

public function long of_error_on_serial_no_exists (string as_project_id, string as_sku, string as_serial_no, string as_owner_cd, string as_component_ind, long al_component_no, boolean ab_error_on_exists, boolean ab_skipcomponent, ref string ab_error_message_title, ref string ab_error_message, ref string as_system_no, ref string as_invoice_no);


// 08/11/2010 ujhall: 03 of 09 Full Circle Fix:  Check DB for serial number.  If there return 1, elser return 0
string ls_serial_no_db, ls_owner_cd_db, lsInvShipable, lsInvType
string ls_error_on_exists //01/03/2011 ujh: S/N_Pb
long ll_Component_no_db //01/03/2011 ujh: S/N_Pb
ls_error_on_exists = upper(string(ab_error_on_exists, "0"))  //01/03/2011 ujh: S/N_Pb
ls_serial_no_db = ''
ls_owner_cd_db = ''
ll_component_no_db = 0
string lsMsg
Long	ll_method_trace_id

SetNull( ll_method_trace_id )
//f_method_trace( ll_method_trace_id, this.ClassName(), 'Start of_error_on_serial_no_exists: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,"")  ) //08-Feb-2013  :Madhu commented
f_method_trace_special( gs_project, this.ClassName() + ' -of_error_on_serial_no_exists','Start of_error_on_serial_no_exists: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd," "), as_system_no, ' ', ' ' ,as_invoice_no) //08-Feb-2013  :Madhu added

/* 01/03/2011 ujh: S/N_P:  Make sure component's serial numbers match what is in the database. */
/*01/03/2011 ujh: S/N_Pb	AND if the part is a component, it must be for its specific parent.  This code 
	is used when the item should be in the table and when it should not, also parents and children .  
	Note that the case statement handles this by concatenating  to component_ind the flag that 
	determines whether component_no is part of the selection criteria.  Parents will select any
	serial no - sku combo that fits.  Children require the addition of component number so they are matched 
	to the correct parent.*/
	// 02/08/2011 ujh:  S/N_P  Fix case statement to include parent else they will validate incorrctly when there are multiples

/* 2/19 dts - why are we including component_no here (on receipt)? It should be enough that it's in the table - we shouldn't be able to receive it.
  - changing it to skip the component condition when called from w_ro... 
     - added a new parameter, ab_SkipComponent */
//TimA 09/04/12 Added Nolock on selects below

// 04/02/14 - PCONKL - Added outer join to Inventory_Type so that we can not allow non-shipable Inventory types to be scanned

if ab_SkipComponent then
	
	Select Serial_no , Owner_cd, Component_no, Inventory_Shippable_Ind, Serial_Number_Inventory.Inventory_Type
	into :ls_serial_no_db, :ls_owner_cd_db, :ll_component_no_db, :lsInvShipable, :lsInvType
	From Serial_Number_Inventory with (nolock)  LEFT OUTER JOIN Inventory_Type with (nolock) ON Serial_Number_Inventory.Project_Id = Inventory_Type.Project_Id AND Serial_Number_Inventory.Inventory_Type = Inventory_Type.Inv_Type
	where Serial_Number_Inventory.Project_ID = :as_Project_ID
	and SKU = :as_SKU
	and Serial_no = :as_serial_no; //dts - 2/18/11 skipping the component part of the condition
	
	f_method_trace_special( gs_project, this.ClassName() + ' -of_error_on_serial_no_exists','Skipping the component part of the condition: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,"") ,  as_system_no, ' ', ' ' ,as_invoice_no) //08-Feb-2013  :Madhu added
	
else
	
	Select Serial_no , Owner_cd, Component_no, Inventory_Shippable_Ind, Serial_Number_Inventory.Inventory_Type
	into :ls_serial_no_db, :ls_owner_cd_db, :ll_component_no_db, :lsInvShipable, :lsInvType
	From Serial_Number_Inventory with (nolock)  LEFT OUTER JOIN Inventory_Type with (nolock) ON Serial_Number_Inventory.Project_Id = Inventory_Type.Project_Id AND Serial_Number_Inventory.Inventory_Type = Inventory_Type.Inv_Type
	where Serial_Number_Inventory.Project_ID = :as_Project_ID
	and SKU = :as_SKU
	and Serial_no = :as_serial_no
	and Component_no = case upper( :as_Component_ind) + :ls_error_on_exists &
							when '*0' then :al_Component_no &
							else Component_no &
							end ;  // Check against component number when the part is a component or parent and num should be in db	
	//f_method_trace( ll_method_trace_id, this.ClassName(), 'Check against component number when the part is a component or parent and num should be in db: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,"")  )		//08-Feb-2013  :Madhu commented
	f_method_trace_special( gs_project, this.ClassName() + ' -of_error_on_serial_no_exists','Check against component number when the part is a component or parent and num should be in db: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,""), as_system_no, ' ', ' ' ,as_invoice_no) //08-Feb-2013  :Madhu added					
	
end if

// Because the previous where clause will fail when component no is null, need this
/*If the previous returned nothing and the previous was not a component while error_on_exists was true, then need to check again 
   this time when component_no is null */
If (isnull( ls_serial_no_db) or ls_serial_no_db = "") and not (as_Component_ind + ls_error_on_exists = '*0') then				
	
	Select Serial_no , Owner_cd, Component_no, Inventory_Shippable_Ind, Serial_Number_Inventory.Inventory_Type
	into :ls_serial_no_db, :ls_owner_cd_db, :ll_component_no_db, :lsInvShipable, :lsInvType
	From Serial_Number_Inventory with (nolock) LEFT OUTER JOIN Inventory_Type with (nolock) ON Serial_Number_Inventory.Project_Id = Inventory_Type.Project_Id AND Serial_Number_Inventory.Inventory_Type = Inventory_Type.Inv_Type
	where Serial_Number_Inventory.Project_ID = :as_Project_ID
	and SKU = :as_SKU
	and Serial_no = :as_serial_no
	and Component_no is  null;
	
end if
					
If ab_Error_On_Exists then
	
	If isnull( ls_serial_no_db) or ls_serial_no_db = "" then
		
			/* 01/03/2011 ujh: S/N_P: The serial no / SKU combo is not in the Serial_number_inventory table, 
			but now check for it internally in SIMS. */
			// 04/14 - PCONKL - Added outer join on Inventory Type table to determine if Inv Type is shipable
	// if a record is found where all the qtys are not zero, then the record is active.
		Select Serial_no, Inventory_Shippable_Ind, Content_Summary.Inventory_Type
		into :ls_serial_no_db, :lsInvShipable, :lsInvType
		From Content_Summary with (nolock) LEFT OUTER JOIN Inventory_Type with (nolock) ON Content_Summary.Project_Id = Inventory_Type.Project_Id AND Content_Summary.Inventory_Type = Inventory_Type.Inv_Type
		where Content_Summary.Project_ID = :as_Project_ID
		and SKU = :as_SKU
		and Serial_no = :as_serial_no
		and abs(avail_qty) + abs(alloc_qty) + abs(sit_qty) + abs(tfr_in) + abs(tfr_out) 
		+ abs(wip_qty)  > 0;  // per Dave, sum QTY of zero means the item is no longer in inventory.
		
		//TimA 03/22/11 removed abs(new_qty) per conversation with Bob
		//		+ abs(new_qty) > 0;  // per Dave, sum QTY of zero means the item is no longer in inventory.
		
		If isnull( ls_serial_no_db) or ls_serial_no_db = "" then

			//f_method_trace( ll_method_trace_id, this.ClassName(), 'Error Return without error as the serial number did not exist in the table: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,"")  )	//08-Feb-2013  :Madhu commented
			f_method_trace_special( gs_project, this.ClassName() + ' -of_error_on_serial_no_exists','Error Return without error as the serial number did not exist in the table: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,""), as_system_no, ' ', ' ' ,as_invoice_no) //08-Feb-2013  :Madhu added
			return 0  // return without error as the serial number did not exist in the table nor in SIMS.
		else
			ab_error_message_title = 'Serial # Error'
			ab_error_message = 'The serial number already exists internally in SIMS: SKU = '+as_SKU + '; Serial Number = '+ as_serial_no + '.'
			//f_method_trace( ll_method_trace_id, this.ClassName(), 'Error The serial number already exists internally in SIMS: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,"")  )	 //08-Feb-2013  :Madhu commented
			f_method_trace_special( gs_project, this.ClassName() + ' -of_error_on_serial_no_exists','Error The serial number already exists internally in SIMS: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,""), as_system_no, ' ', ' ' ,as_invoice_no) //08-Feb-2013  :Madhu added						
			//messagebox('Serial # Error', 'The serial number already exists internally in SIMS: SKU = '+as_SKU + '; Serial Number = '+ as_serial_no + '.')
			return 1
		end if
		
	else
		
		//messagebox('Serial # Error', 'The serial number already exists in Serial_Number_Inventory: SKU = '+as_SKU + '; Serial Number = '+ as_serial_no +'; Owner Code = '+as_owner_cd+ '.')
		ab_error_message_title = 'Serial # Error'
		ab_error_message = 'The serial number already exists in Serial_Number_Inventory: SKU = '+as_SKU + '; Serial Number = '+ as_serial_no +'; Owner Code = '+ ls_owner_cd_db + '.'
		//f_method_trace( ll_method_trace_id, this.ClassName(), 'Error The serial number already exists in Serial_Number_Inventory: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,"")  )		//08-Feb-2013  :Madhu commented
		f_method_trace_special( gs_project, this.ClassName() + ' -of_error_on_serial_no_exists','Error The serial number already exists in Serial_Number_Inventory: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,""),  as_system_no, ' ', ' ' ,as_invoice_no) //08-Feb-2013  :Madhu added							
		//messagebox('Serial # Error', 'The serial number already exists in Serial_Number_Inventory: SKU = '+as_SKU + '; Serial Number = '+ as_serial_no +'; Owner Code = '+ ls_owner_cd_db + '.')
		return 1
		
	end if
	
else
	
	/* It is an error when the serial no / SKU combination is NOT in serial_number_inventory or when the owner does not match 
			or when the part is a component and the component number does not match*/
	If isNull(ls_serial_no_db) or ls_serial_no_db = "" then
		
		lsMsg = 'The serial number does NOT exist in serial_number_inventory table: SKU = '+as_SKU + '; Serial Number = '+ as_serial_no + '; Owner Code = '+ as_owner_cd
		if al_Component_no > 0 then lsMsg += '; Assembly No = ' + string(al_component_no)
		
		ab_error_message_title = 'Serial # Error'
		ab_error_message =  lsMsg + '.'
		//f_method_trace( ll_method_trace_id, this.ClassName(), 'Error The serial number does NOT exist: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,"")  ) //08-Feb-2013  :Madhu commented
		f_method_trace_special( gs_project, this.ClassName() + ' -of_error_on_serial_no_exists','Error The serial number does NOT exist: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,""), as_system_no, ' ', ' ' ,as_invoice_no) //08-Feb-2013  :Madhu added
		//messagebox('Serial # Error', lsMsg + '.')
		return 1
		
	elseif  ls_owner_cd_db <> as_owner_cd then
		
		ab_error_message_title = 'Serial # Error'

		ab_error_message = 'Serial number exists in serial number inventory table, but line item owner ' &
			+ as_owner_cd + 'does not match serial number inventory records for this SKU = '+as_SKU + '; and this Serial Number = ' &
			+ as_serial_no+ '; Table Owner Code = '+ ls_owner_cd_db + '.'
		//f_method_trace( ll_method_trace_id, this.ClassName(), 'Error Serial number exists in serial number inventory table, but line item owner does not match serial number: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,"")  )	//08-Feb-2013  :Madhu commented
		f_method_trace_special( gs_project, this.ClassName() + ' -of_error_on_serial_no_exists','Error Serial number exists in serial number inventory table, but line item owner does not match serial number: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,""), as_system_no, ' ', ' ' ,as_invoice_no) //08-Feb-2013  :Madhu added								
		//messagebox('Serial # Error', 'Serial number exists in serial number inventory table, but line item owner ' &
		//	+ as_owner_cd + 'does not match serial number inventory records for this SKU = '+as_SKU + '; and this Serial Number = ' &
		//	+ as_serial_no+ '; Table Owner Code = '+ ls_owner_cd_db + '.')	
		return 1		
		
	ElseIf lsInvShipable = 'N' Then /* 04/14 - PCONKL - If serial Number in a non shipable Inventory Type, don't allow to be scanned */
		
		ab_error_message_title = 'Serial # Error'
		ab_error_message = "This Serial Nummber is in a non-shipbale Inventory Type and cannot be shipped!~r SKU = '" +as_SKU + "'; Serial Number = '" + as_serial_no + "';Inventory Type = '" + lsInvType + "'"
		f_method_trace_special( gs_project, this.ClassName() + ' -of_error_on_serial_no_exists','Non Shipable Inventory Type: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") ,as_system_no, ' ', ' ' ,as_invoice_no) 
		return 1
		
	else
		
		w_do.ilComponent_no = ll_component_no_db
		return 0
		
	end if
	
end if

//f_method_trace( ll_method_trace_id, this.ClassName(), 'End of_error_on_serial_no_exists: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,"")  ) //08-Feb-2013  :Madhu commented
f_method_trace_special( gs_project, this.ClassName() + ' -of_error_on_serial_no_exists','End of_error_on_serial_no_exists: for Project: ' + nz(as_project_id,"") + " SKU: " + nz(as_sku,"")  + " Serial No: " + nz(as_serial_no,"") + " Owner: " + nz(as_owner_cd,""), as_system_no, ' ', ' ' ,as_invoice_no) //08-Feb-2013  :Madhu added


end function

public function string of_validate_serial_format (string as_sku, string as_serial_no, string as_supp_code);String ls_return, ls_serial_masks, ls_mask_list[], ls_work, ls_mask_char, ls_serial_char, ls_mask, ls_validation_error
long i, j, k, ll_masks, llseriallength
boolean  lbliteral

//select user_field19
//into :ls_serial_masks
//from item_master
//where project_id = :gs_project
//and sku = :as_sku
//and supp_code = :as_supp_code;

//ls_serial_masks = Trim( ls_serial_masks )

//if Len( ls_serial_masks ) > 0 then

//	// Multiples masks allowed, separated by semicolons.  Parse out all masks here.
//	ls_work = ls_serial_masks	// leave masks string as is, for error reporting purposes
//	ls_mask = f_get_token( ls_work, ";" )
//	i = 1
//	do until ls_mask = ""
//		ls_mask_list[i] = ls_mask
//		ls_mask = f_get_token( ls_work, ";" )
//		i++
//	loop


	// LTK 20140412  Retrieve the serial masks from Item_Serial_Prefix
	datastore lds_masks
	lds_masks = create datastore
	String ls_sql_syntax, ERRORS

	ls_sql_syntax = "SELECT prefix from Item_Serial_Prefix "
	ls_sql_syntax += " WHERE project_id = '" + gs_project + "' "
	ls_sql_syntax += " AND sku = '" + as_sku + "' "	
	ls_sql_syntax += " AND supp_code = '" + as_supp_code + "' ;"	

	lds_masks.Create(SQLCA.SyntaxFromSQL(ls_sql_syntax,"", ERRORS))
	if Len(ERRORS) > 0 then
		return "Unable to create serial mask datastore.~r~r" + Errors
	end if

	if lds_masks.SetTransObject(SQLCA) <> 1 then
		return "Error setting serial mask datastore's transaction object."
	end if

	// Populate array since code below was already written using an array
	ll_masks = lds_masks.Retrieve()
	for i = 1 to ll_masks
		ls_mask_list[i] = Trim( String( lds_masks.Object.prefix[ i ] ))
		ls_serial_masks += " " + Trim( String( lds_masks.Object.prefix[ i ] )) + ';'
	next


	for j = 1 to UpperBound( ls_mask_list )

		ls_mask = Trim(ls_mask_list[ j ])

		// TAM 06/04/2016 - Get the length of the mask without the quotes
		llseriallength = 0
		for i = 1 to Len( ls_mask )
			ls_mask_char = Upper( Mid( ls_mask, i, 1 ) )
			if Match( ls_mask_char, "[A-Za-z0-9]") then
				llseriallength ++
			end if
		next
		
		// TAM 06/04/2016 - Check the length of the "Unquoted" mask.
//		if Len( as_serial_no ) < Len( ls_mask ) then
		if Len( as_serial_no ) <  llseriallength then
			ls_validation_error = "Serial numer format is invalid compared to its mask(s)."  + "~r~nSerial number: " + Trim( as_serial_no ) + "~r~nSerial number mask(s): " + Trim( ls_serial_masks ) + "~r~n~r~nThree reasons for failure are ~r~n1. The serial number is shorter than the defined mask.~r~n2.  Quotes identify a literal value that must match exactly~r~n3.  Serial mask character N represents numeric, C represents character, X represents either character or number."
		end if

		// Compare each character of the serial mask against each character of the serial number
		k = 0
		for i = 1 to Len( ls_mask )

		//TAM 06/04/2016 Need a separate counter fi Serial Numbers since the mask may contain quotes
			k++
			ls_mask_char = Upper( Mid( ls_mask, i, 1 ) )
//			ls_serial_char = Mid( as_serial_no, i, 1 )
			ls_serial_char = Mid( as_serial_no, k, 1 )
			ls_validation_error = ""	

		/* TAM 06/04/2016 - We are now allowing Litereral characters to be entered into the Mask.  If a literal is entered then the value of the serial position must = the literal.
				Example of the Mask is as follows
				$$HEX2$$22200900$$ENDHEX$$Mask = $$HEX1$$1820$$ENDHEX$$C$$HEX2$$19201920$$ENDHEX$$X$$HEX1$$1920$$ENDHEX$$CN$$HEX1$$1920$$ENDHEX$$1$$HEX1$$1920$$ENDHEX$$NNNNNN 
						Position 1 must = C, 
						Position 2 must = X, 
						Position 3 Must = {char}, 
						Position 4 Must = {Number},
						Position 5 Must = 1
						Positions 6 $$HEX2$$13202000$$ENDHEX$$11 Must = {Number}

		*/
		
			if Not Match( ls_mask_char, "[A-Za-z0-9]") then
				ls_mask_char = Upper( Mid( ls_mask, i +1, 1 ) )
				i = i+2
				lbLiteral = True
			Else
				lbliteral= False
			End If

			If lbliteral = True Then
				if ls_mask_char <> ls_serial_char then
					ls_validation_error = "Serial numer format is invalid compared to its mask(s)."  + "~r~nSerial number: " + Trim( as_serial_no ) + "~r~nSerial number mask(s): " + Trim( ls_serial_masks ) + "~r~n~r~nThree reasons for failure are ~r~n1. The serial number is shorter than the defined mask.~r~n2.  Quotes identify a literal value that must match exactly~r~n3.  Serial mask character N represents numeric, C represents character, X represents either character or number."
					exit
				end if
			Else // Original check of 'N', 'C', 'X'
			
				choose case ls_mask_char
	
					case "N"
						if NOT IsNumber( ls_serial_char )	 then
//							ls_validation_error = "Serial numer format is invalid compared to its mask(s)."  + "~r~nSerial number: " + Trim( as_serial_no ) + "~r~nSerial number mask(s): " + Trim( ls_serial_masks ) + "~r~n~r~nSerial mask character N represents numeric, C represents character, X represents either character or number.~r~nSerial mask characters in Quotes represent literials and the value of the Serial must match the literal exactly"
							ls_validation_error = "Serial numer format is invalid compared to its mask(s)."  + "~r~nSerial number: " + Trim( as_serial_no ) + "~r~nSerial number mask(s): " + Trim( ls_serial_masks ) + "~r~n~r~nThree reasons for failure are ~r~n1. The serial number is shorter than the defined mask.~r~n2.  Quotes identify a literal value that must match exactly~r~n3.  Serial mask character N represents numeric, C represents character, X represents either character or number."
							exit
						end if
	
					case "C"
						if NOT Match( ls_serial_char, "[A-Za-z]") then
//							ls_validation_error = "Serial numer format is invalid compared to its mask(s)."  + "~r~nSerial number: " + Trim( as_serial_no ) + "~r~nSerial number mask(s): " + Trim( ls_serial_masks ) + "~r~n~r~nSerial mask character N represents numeric, C represents character, X represents either character or number.~r~nSerial mask characters in Quotes represent literials and the value of the Serial must match the literal exactly"
							ls_validation_error = "Serial numer format is invalid compared to its mask(s)."  + "~r~nSerial number: " + Trim( as_serial_no ) + "~r~nSerial number mask(s): " + Trim( ls_serial_masks ) + "~r~n~r~nThree reasons for failure are ~r~n1. The serial number is shorter than the defined mask.~r~n2.  Quotes identify a literal value that must match exactly~r~n3.  Serial mask character N represents numeric, C represents character, X represents either character or number."
							exit
						end if

					case "X"
						if NOT Match( ls_serial_char, "[A-Za-z0-9]") then
//							ls_validation_error = "Serial numer format is invalid compared to its mask(s)."  + "~r~nSerial number: " + Trim( as_serial_no ) + "~r~nSerial number mask(s): " + Trim( ls_serial_masks ) + "~r~n~r~nSerial mask character N represents numeric, C represents character, X represents either character or number.~r~nSerial mask characters in Quotes represent literials and the value of the Serial must match the literal exactly"
							ls_validation_error = "Serial numer format is invalid compared to its mask(s)."  + "~r~nSerial number: " + Trim( as_serial_no ) + "~r~nSerial number mask(s): " + Trim( ls_serial_masks ) + "~r~n~r~nThree reasons for failure are ~r~n1. The serial number is shorter than the defined mask.~r~n2.  Quotes identify a literal value that must match exactly~r~n3.  Serial mask character N represents numeric, C represents character, X represents either character or number."
							exit
						end if

					case else
	
						ls_validation_error = "Unrecognized mask character in serial mask(s): " + ls_serial_masks + "~r~rValid mask characters: N, C, X"
						exit
						
				end choose
			End If
			
		next

		if ls_validation_error = "" then
			return ""
		else
			if j < UpperBound( ls_mask_list ) then
				// Validate next mask
			else
				return ls_validation_error
			end if
		end if
	next	
	
//end if

return ls_return


end function

public function string of_stripoff_firstcol_serialno (string assku, string assuppcode, string asserialno);//07-JUNE-2017 :Madhu -PEVS-554 - TCIF Linked Code39 "TLC39" SerialBarcodes
//StripOff First column of scanned Serial No

String lsSerialNo, lsFind, lsstripoff
long llFindrow

lsFind = " sku ='"+upper(assku)+"' and supp_code='"+upper(assuppcode)+"'"

llFindrow =g.ids_item_serial_prefix.find( lsFind, 1, g.ids_item_serial_prefix.rowcount())

If llFindrow > 0 Then
	lsstripoff = g.ids_item_serial_prefix.getitemstring( llFindrow, 'StripOff_First_Col')
End If

//If stripoff set to Y then remove 1st value and return serial No
If upper(lsstripoff) ='Y' Then
	
	lsSerialNo = Right(asserialno, len(asserialno) - 1)
else
	lsSerialNo = asserialno
	
End IF


Return lsSerialNo
end function

public function string of_stripoff_firstcol_checked (string assku, string assuppcode);//07-JUNE-2017 :Madhu -PEVS-554 - TCIF Linked Code39 "TLC39" SerialBarcodes
//check - whether SKU is enabled for StripOff First char

String lsSerialNo, lsFind, lsstripoff
long llFindrow

lsFind = " sku ='"+upper(assku)+"' and supp_code='"+upper(assuppcode)+"'"

llFindrow =g.ids_item_serial_prefix.find( lsFind, 1, g.ids_item_serial_prefix.rowcount())

If llFindrow > 0 Then
	lsstripoff = g.ids_item_serial_prefix.getitemstring( llFindrow, 'StripOff_First_Col')
else
	lsstripoff ='N'
End If

Return lsstripoff
end function

public function str_parms of_parse_2d_barcode (string as_serialno);/**************************************************/
/*					Change History Details										*/
/*	30-OCT-2017 :Madhu PEVS-654 -2D Barcode for Pandora			*/
/**************************************************/
Str_Parms ls_str_parms
long ll_count, ll_Pos

//scanned 2D Barcode is separated by comma for Pandora
IF upper(gs_project) = 'PANDORA'  and Pos(as_serialno,',') >0 THEN
	
	DO WHILE Pos(as_serialno,',') > 0
		ll_count++
		ll_Pos = Pos(as_serialno,',')
		ls_str_parms.string_arg[ll_count] = Mid(as_serialno, 0, ll_Pos -1)
		as_serialno = Mid(as_serialno, ll_Pos+1, len(as_serialno))
	LOOP
	
	If len(as_serialno) > 0 Then ls_str_parms.string_arg[ll_count +1] = as_serialno //store last serial No.
	
ELSE
	ls_str_parms.string_arg[1] =as_serialno
END IF

Return ls_str_parms
end function

public function string of_validate_serial_format_ds (string as_sku, string as_serial_no, string as_supp_code);// TAM - 2018/01/04 - Rewrote to use global datastore g.ids_item_serial_prefix instead of rebuilding each time.

String ls_return, ls_serial_masks, ls_mask_list[], ls_work, ls_mask_char, ls_serial_char, ls_mask, ls_validation_error, ls_filter
long i, j, k, ll_masks, llseriallength
boolean  lbliteral


//	// LTK 20140412  Retrieve the serial masks from Item_Serial_Prefix
//	datastore lds_masks
//	lds_masks = create datastore
//	String ls_sql_syntax, ERRORS
//
//	ls_sql_syntax = "SELECT prefix from Item_Serial_Prefix "
//	ls_sql_syntax += " WHERE project_id = '" + gs_project + "' "
//	ls_sql_syntax += " AND sku = '" + as_sku + "' "	
//	ls_sql_syntax += " AND supp_code = '" + as_supp_code + "' ;"	
//
//	lds_masks.Create(SQLCA.SyntaxFromSQL(ls_sql_syntax,"", ERRORS))
//	if Len(ERRORS) > 0 then
//		return "Unable to create serial mask datastore.~r~r" + Errors
//	end if
//
//	if lds_masks.SetTransObject(SQLCA) <> 1 then
//		return "Error setting serial mask datastore's transaction object."
//	end if

ls_filter =  "SKU='" + trim(as_sku) + "' and supp_code='" + trim(as_supp_code) + "'"

g.ids_item_serial_prefix.SetFilter(ls_filter)
g.ids_item_serial_prefix.Filter()
	
// Populate array since code below was already written using an array
	ll_masks = g.ids_item_serial_prefix.Rowcount()

IF ll_masks <= 0 	THEN 	return ''

	for i = 1 to ll_masks
		ls_mask_list[i] = Trim(g.ids_item_serial_prefix.getitemstring(i,'prefix'))
		ls_serial_masks += " " + Trim(g.ids_item_serial_prefix.getitemstring(i,'prefix')) + ';'
	next


	for j = 1 to UpperBound( ls_mask_list )

		ls_mask = Trim(ls_mask_list[ j ])

		// TAM 06/04/2016 - Get the length of the mask without the quotes
		llseriallength = 0
		for i = 1 to Len( ls_mask )
			ls_mask_char = Upper( Mid( ls_mask, i, 1 ) )
			if Match( ls_mask_char, "[A-Za-z0-9]") then
				llseriallength ++
			end if
		next
		
		// TAM 06/04/2016 - Check the length of the "Unquoted" mask.
		if Len( as_serial_no ) <  llseriallength then
			ls_validation_error = "Serial numer format is invalid compared to its mask(s)."  + "~r~nSerial number: " + Trim( as_serial_no ) + "~r~nSerial number mask(s): " + Trim( ls_serial_masks ) + "~r~n~r~nThree reasons for failure are ~r~n1. The serial number is shorter than the defined mask.~r~n2.  Quotes identify a literal value that must match exactly~r~n3.  Serial mask character N represents numeric, C represents character, X represents either character or number."
		end if

		// Compare each character of the serial mask against each character of the serial number
		k = 0
		for i = 1 to Len( ls_mask )

		//TAM 06/04/2016 Need a separate counter fi Serial Numbers since the mask may contain quotes
			k++
			ls_mask_char = Upper( Mid( ls_mask, i, 1 ) )
			ls_serial_char = Mid( as_serial_no, k, 1 )
			ls_validation_error = ""	

			if Not Match( ls_mask_char, "[A-Za-z0-9]") then
				ls_mask_char = Upper( Mid( ls_mask, i +1, 1 ) )
				i = i+2
				lbLiteral = True
			Else
				lbliteral= False
			End If

			If lbliteral = True Then
				if ls_mask_char <> ls_serial_char then
					ls_validation_error = "Serial numer format is invalid compared to its mask(s)."  + "~r~nSerial number: " + Trim( as_serial_no ) + "~r~nSerial number mask(s): " + Trim( ls_serial_masks ) + "~r~n~r~nThree reasons for failure are ~r~n1. The serial number is shorter than the defined mask.~r~n2.  Quotes identify a literal value that must match exactly~r~n3.  Serial mask character N represents numeric, C represents character, X represents either character or number."
					exit
				end if
			Else // Original check of 'N', 'C', 'X'
			
				choose case ls_mask_char
	
					case "N"
						if NOT IsNumber( ls_serial_char )	 then
							ls_validation_error = "Serial numer format is invalid compared to its mask(s)."  + "~r~nSerial number: " + Trim( as_serial_no ) + "~r~nSerial number mask(s): " + Trim( ls_serial_masks ) + "~r~n~r~nThree reasons for failure are ~r~n1. The serial number is shorter than the defined mask.~r~n2.  Quotes identify a literal value that must match exactly~r~n3.  Serial mask character N represents numeric, C represents character, X represents either character or number."
							exit
						end if
	
					case "C"
						if NOT Match( ls_serial_char, "[A-Za-z]") then
							ls_validation_error = "Serial numer format is invalid compared to its mask(s)."  + "~r~nSerial number: " + Trim( as_serial_no ) + "~r~nSerial number mask(s): " + Trim( ls_serial_masks ) + "~r~n~r~nThree reasons for failure are ~r~n1. The serial number is shorter than the defined mask.~r~n2.  Quotes identify a literal value that must match exactly~r~n3.  Serial mask character N represents numeric, C represents character, X represents either character or number."
							exit
						end if

					case "X"
						if NOT Match( ls_serial_char, "[A-Za-z0-9]") then
							ls_validation_error = "Serial numer format is invalid compared to its mask(s)."  + "~r~nSerial number: " + Trim( as_serial_no ) + "~r~nSerial number mask(s): " + Trim( ls_serial_masks ) + "~r~n~r~nThree reasons for failure are ~r~n1. The serial number is shorter than the defined mask.~r~n2.  Quotes identify a literal value that must match exactly~r~n3.  Serial mask character N represents numeric, C represents character, X represents either character or number."
							exit
						end if

					case else
	
						ls_validation_error = "Unrecognized mask character in serial mask(s): " + ls_serial_masks + "~r~rValid mask characters: N, C, X"
						exit
						
				end choose
			End If
			
		next

		g.ids_item_serial_prefix.SetFilter("")
		g.ids_item_serial_prefix.Filter()

		if ls_validation_error = "" then
			return ""
		else
			if j < UpperBound( ls_mask_list ) then
				// Validate next mask
			else
				return ls_validation_error
			end if
		end if
	next	
	
//end if

return ls_return


end function

on n_warehouse.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_warehouse.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;destroy u_ds
destroy ids_cont
destroy ids_sku
end event

event constructor;post event ue_open()
end event

