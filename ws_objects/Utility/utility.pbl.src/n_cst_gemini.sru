$PBExportHeader$n_cst_gemini.sru
forward
global type n_cst_gemini from nonvisualobject
end type
end forward

global type n_cst_gemini from nonvisualobject
end type
global n_cst_gemini n_cst_gemini

type variables
Public:

OLEObject iole_gem_db
OLEObject iole_gem_obj
OLEObject iole_gem_Base64

DataWindowChild idwc_service,idwc_product,idwc_payment
DataWindow idw_returnXML

long il_Ship_acno
any ia_labeldata

end variables

forward prototypes
public function any of_parselabel (any la_xml)
public function integer of_showxml (any la_returnxml, datawindow adw_returnxml)
public subroutine of_error ()
public subroutine of_gemini_menu (boolean onoff)
public function string of_get_country (ref string as_country)
public function integer of_getcitylist (ref string as_contry_code, ref string as_city)
public function integer of_init (ref datawindow adw_gemini)
public subroutine of_dbdisconnect ()
public function integer of_dbconnect ()
public function any of_ordersubmit (ref datawindow adw_gemini, ref datawindow adw_main, ref datawindow adw_other, ref datawindow adw_pack)
public function any of_ordercancel (ref datawindow adw_gemini)
public function any of_printlabel (any la_xml, string ls_case, ref datawindow adw_gemini, ref datawindow adw_gemini_label)
public function long of_createlabel ()
public function string of_read_xml_template (string as_xml_template_name)
end prototypes

public function any of_parselabel (any la_xml);//GAP1003 parse out print label data
long ll_pos1, ll_pos2
	ll_pos1 = pos(la_XML, "<label>")
	If ll_pos1 = 0 then //get out if it cannot find a label tag in XML
		la_XML = "-1" + la_XML  // add return code -1 to XML
		return la_XML
	end if
	ll_pos2 = pos(la_XML, "</label>")
	ll_pos1 += len("<label>")
	ll_pos2 =  ll_pos2 - ll_pos1
	ia_labeldata = Mid(la_XML, ll_pos1,ll_pos2)
	return ia_labeldata
end function

public function integer of_showxml (any la_returnxml, datawindow adw_returnxml);		//Write display XML file
		adw_returnXML.DataObject = "d_gemini_returnXML" //GAP 10-03
		adw_returnXML.reset() 
		adw_returnXML.insertrow(1)
		adw_returnXML.setitem(1, "returnXML", la_returnXML)
		
		return adw_returnXML.rowcount()

end function

public subroutine of_error ();/*
//This is object populated when there is an error..
oleobject obj_err
obj_err=iole_gem_obj.ErrorObj[]
IF ISValid(obj_err)  THEN
	Messagebox("Gemini Error",String(obj_err.errordetail))
ELSE
	Messagebox("Error","Invalid Error Object...")
END IF	
	*/
end subroutine

public subroutine of_gemini_menu (boolean onoff);//GAP1003 Turn Gemini Menu items on/off

m_simple_edit_gemini.m_gemini.enabled = onoff
m_simple_edit_gemini.m_gemini.m_submit.enabled = onoff
m_simple_edit_gemini.m_gemini.m_cancel.enabled = onoff
m_simple_edit_gemini.m_gemini.m_printlabel.enabled = onoff
m_simple_edit_gemini.m_gemini.m_previewlabel.enabled = onoff
m_simple_edit_gemini.m_gemini.m_viewxml.enabled = onoff
m_simple_edit_gemini.m_gemini.m_webtracking.enabled = onoff
m_simple_edit_gemini.m_gemini.m_startgemini.enabled = onoff
m_simple_edit_gemini.m_gemini.m_clearreset.enabled = onoff
m_simple_edit_gemini.m_gemini.m_connect.enabled = onoff 
end subroutine

public function string of_get_country (ref string as_country);/*
//This function return two character country code after accepting 3 charter contry code
String ls_table,ls_where

IF upper(as_country) = "UNITED STATES" THEN as_country = "US"
ls_table = "Country"
ls_where = "ISO_Country_Cd = '" + as_country + "' or " +&
"Country_Name = '" + as_country + "' or " + &
"Designating_Code = '" + as_country + "'"
IF ISValid(g.i_nwarehouse) THEN
	IF g.i_nwarehouse.of_anytable(ls_table,ls_where) = 1 THEN 
		Return g.i_nwarehouse.ids_any.object.Designating_Code[1]
	END IF
END IF	*/
Return ""

end function

public function integer of_getcitylist (ref string as_contry_code, ref string as_city);//Validate the right city
Integer li_rtn /*
string ls_city[50],ls_rtd[50]
string ls_city1[50],ls_rtd1[50]

li_rtn=iole_gem_obj.getcitylist(as_contry_code,ref ls_city[],ref ls_rtd[],as_city)
IF li_rtn = 1800 THEN
//	li_rtn=iole_gem_obj.getcitylist(as_contry_code,ref ls_city[],ref ls_rtd[],as_city)
	IF li_rtn <> 0 THEN	Messagebox("Valid City List","Could not find Valid city in the list")
//	Setnull(as_city)
	li_rtn=iole_gem_obj.getcitylist(as_contry_code,ref ls_city1[],ref ls_rtd1[],as_city)
//	//this.of_error()	
ELSEIF li_rtn = 0 THEN
	Messagebox("Valid City List",ls_city[1]+"~n" +ls_city[1])
ELSE	 
   Messagebox("Valid City List","Could not find Valid city in the list")	
	
END IF
MessageBox("ls_city1[]",ls_city1[1])
MessageBox("ls_city2[]",ls_city1[2])
MessageBox("ls_city3[]",ls_city1[3])
MessageBox("ls_city4[]",ls_city1[4])
*/
Return li_rtn
end function

public function integer of_init (ref datawindow adw_gemini);//initializing of datawindow from table Gemini_code_transmission
Integer li_rtn
 
li_rtn=adw_gemini.Getchild('type_of_service',idwc_service)
IF li_rtn = 1 THEN li_rtn=adw_gemini.Getchild('type_of_payment',idwc_payment)
IF li_rtn = 1 THEN li_rtn=adw_gemini.Getchild('type_of_product',idwc_product)
IF li_rtn = 1 THEN li_rtn=idwc_service.SeTtransObject(SQLCA)

li_rtn =idwc_payment.SetFilter("code_type = 'Payment'") //Payment is Common for all 
IF li_rtn = 1 THEN	li_rtn =idwc_payment.Filter() //Filter
		
IF li_rtn = 1 THEN	li_rtn =idwc_service.SetFilter("code_type = 'Service'")
IF li_rtn = 1 THEN	li_rtn =idwc_service.Filter()	

IF li_rtn = 1 THEN	li_rtn =idwc_product.SetFilter("code_type = 'Product'")
IF li_rtn = 1 THEN	li_rtn =idwc_product.Filter()

Return li_rtn
end function

public subroutine of_dbdisconnect ();IF ISValid(iole_gem_db) THEN 
	iole_gem_db.CloseConnection
	DESTROY iole_gem_db
END IF	

IF ISValid(iole_gem_Base64) THEN 
	DESTROY iole_gem_Base64
END IF

end subroutine

public function integer of_dbconnect ();Integer li_rc
//Connecting to the client interface of Gemini
if isvalid(iole_gem_obj) then 
	//Check to see if already connected...
else
	
	iole_gem_obj = CREATE OLEObject
	//	GAP 10-03 Connecting to database
	li_rc = iole_gem_obj.ConnectToNewObject("EWW_GEM_GeminiAPI.cInterface")
	IF li_rc < 0 THEN
	// GAP-1003 
		MessageBox ( "Connect to Gemini Local-API", "Error: " + String(li_rc) + " Contact Menlo WorldWide Support " , StopSign!)
		DESTROY iole_gem_obj
	   Return -1
	END IF

	g.POST of_setwarehouse(TRUE) 

	// gap1003 * get Gemini Shipper Account Number in Project Table
	il_ship_acno = 0 
	SELECT UPPER(gemini_shipper_acct_no)
	INTO :il_ship_acno
	FROM dbo.Project 
	WHERE Project_id = :gs_project;	
	IF il_ship_acno = 0 THEN
		MessageBox ( "Gemini Shipper Account Number", "Missing Shipper Account Number in Project Master - Contact Menlo WorldWide Support " , StopSign!)
		DESTROY iole_gem_obj
   	Return -1	
	end if	
end if	
Return 1




end function

public function any of_ordersubmit (ref datawindow adw_gemini, ref datawindow adw_main, ref datawindow adw_other, ref datawindow adw_pack);//GAP 1003 This function will Submit an order to Gemini 6 Database
any 	la_XML
long ll_pos ,  ll_pos1,ll_pos2, ll_len
integer li_rc, li_rowcount, i
string ls_filename,ls_ref, ls_ship_acno ,  ls_shipdate, ls_items[]

if adw_gemini.object.delivery_confirm_ind[1] = 'Y' then 
	messagebox("GEMINI ORDER SUBMIT", "This order has already been submitted!")
	la_XML = "-1"
	return la_XML
end if

//check Gemini connection
li_rc = this.of_dbconnect()
if li_rc < 0 then 
		la_XML = "-1"  // -1 return XML with a leading return code
		Return la_XML
end if

//Load the XML Template
la_XML = of_read_xml_template("OrderSubmit.xml")

IF IsNull(la_XML) THEN								
	MessageBox("GEMINI XML TEMPLATE", "CANNOT LOAD XML TEMPLATE") 
	Return la_XML
else //Replace placeholders in XML Template with Field Values
	
	//<shipper_account_number>
	if not Isnull(il_ship_acno) then 
		ls_ref = "<shipper_account_number>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)
		ls_ref += string(il_ship_acno)
		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if

	//<ship_date> 
	if not Isnull(adw_gemini.object.export_date[1]) then 
		ls_ref = "<ship_date>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)
		ls_ref += string(date(adw_gemini.object.export_date[1])) 
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if
	 	
	//Consignee <id> 
	if not Isnull(adw_main.object.cust_code[1])  then 
		ls_ref = "<id>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_main.object.cust_code[1]) 
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if

	//Consignee  <name> 
	if not Isnull(adw_main.object.cust_name[1]) then 
		ls_ref = "<name>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_main.object.cust_name[1]) 
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if
	 
	//Consignee  <address_one> 
	if not Isnull(adw_main.object.address_1[1])then 
		ls_ref = "<address_one>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_main.object.address_1[1]) 
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 	
	end if

	//Consignee  <address_two> 
	if not Isnull(adw_main.object.address_2[1]) then 
		ls_ref = "<address_two>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_main.object.address_2[1])
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 	
	end if
	 	 
	//Consignee  <address_three> 
	if not Isnull(adw_main.object.address_3[1])then 
		ls_ref = "<address_three>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_main.object.address_3[1])
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if
	 
	//Consignee <city>
	if not Isnull(adw_main.object.city[1]) then 
		ls_ref = "<city>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_main.object.city[1])
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if
	 
	//Consignee <state_code>
	if not Isnull(adw_main.object.state[1]) then 
		ls_ref = "<state_code>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_main.object.state[1])
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if
	 
	//Consignee  <postal_code>
	if not Isnull(adw_main.object.zip[1]) then 
		ls_ref = "<postal_code>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_main.object.zip[1])
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 	
	end if

	//Consignee  <country_code>
	if not Isnull(adw_main.object.country[1]) then 
		ls_ref = "<country_code>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_main.object.country[1])
 		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 	
	end if
	 
	//Consignee  <service_center_code> - Must have for International Shipment no logic yet
	//ls_ref = "<service_center_code>"
	//ll_len = len(ls_ref)
	//ll_pos = pos(la_XML, ls_ref)	
	//ls_ref += ""
 	//if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 		 
	 
	//Consignee  <contact_phone>
	if not Isnull(adw_main.object.tel[1]) then 
		ls_ref = "<contact_phone>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_main.object.tel[1])
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if
	 
	//Consignee  <contact_name> 
	if not Isnull(adw_main.object.contact_person[1]) then
		ls_ref = "<contact_name>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
	 	ls_ref += string(adw_main.object.contact_person[1])
 		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if
	 
	//Consignee  <consignee_reference> - Delivery Cust Order Number for now
	if not Isnull(adw_main.object.cust_order_no[1]) then
		ls_ref = "<consignee_reference>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
	 	ls_ref += string(adw_main.object.cust_order_no[1])
 		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if
	 
	//Ship Reference  <shipper_reference> - Delivery Order Other for now
	if not Isnull(adw_other.object.Ship_Ref[1]) then 
		ls_ref = "<shipper_reference>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_other.object.Ship_Ref[1])
 		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if
	 
	//Shipment <service> 
	if not Isnull(adw_gemini.object.type_of_service[1]) then
		ls_ref = "<service>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
	 	ls_ref += string(adw_gemini.object.type_of_service[1])
 		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if
	 
	//Shipment <product> 
	if not Isnull(adw_gemini.object.type_of_product[1]) then
		ls_ref = "<product>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
	 	ls_ref += string(adw_gemini.object.type_of_product[1])
 		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if

	//Shipment <payment> 
	if not Isnull(adw_gemini.object.type_of_payment[1]) then 
		ls_ref = "<payment>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_gemini.object.type_of_payment[1])
 		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if

	//Shipment  <third_party_billing_acct> - not logic yet
	//ls_ref = "<third_party_billing_acct>"
	//ll_len = len(ls_ref)
	//ll_pos = pos(la_XML, ls_ref)	
	//ls_ref += ""
 	//if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 	   

	//Shipment <description> 
	if not Isnull(adw_gemini.object.description[1]) then 
		ls_ref = "<description>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_gemini.object.description[1])
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if
	
	//check for line items in pack list......................
	li_rowcount = adw_pack.rowcount() 
	if li_rowcount > 0 then 
		i =1
		
		// item <items><weight> - // ...need to ask bill about decimal Weights
		if not Isnull(adw_pack.object.c_weight[1]) then 
			ls_ref = "<items><weight>"
			ll_len = len(ls_ref)
			ll_pos = pos(la_XML, ls_ref)	
			if adw_pack.object.c_weight[1] > integer(adw_pack.object.c_weight[1]) then 
				ls_ref += string(integer(adw_pack.object.c_weight[1]) + 1)
			else
				ls_ref += string(integer(adw_pack.object.c_weight[1]))
			end if
		 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
		 end if

		// item <uom_metric>     ....need logic to get UOM
		//if not Isnull(adw_pack.object.cbm[1]) then 
			ls_ref = "<uom_metric>"
			ll_len = len(ls_ref)
			ll_pos = pos(la_XML, ls_ref)	
			//ls_ref += string(adw_pack.object.cbm[1])
			ls_ref += "0" // (0 = inches)
	 		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref)
		//end if
	
	  FOR i = 1 TO li_rowcount //loop - create pack item(s) record array in xml format 
	
	   ls_items[i] = "<item><piece_count></piece_count><length></length><width></width><height></height><weight></weight></item>"
	
		// item <piece_count>  // according to Steve johnson we always round up on decimals (ie: 1.1 = 2)
		if not Isnull(adw_pack.object.quantity[i]) then
			ls_ref = "<piece_count>"
			ll_len = len(ls_ref)
			ll_pos = pos(ls_items[i], ls_ref)	
			if adw_pack.object.quantity[i] > integer(adw_pack.object.quantity[i]) then 
				ls_ref += string(integer(adw_pack.object.quantity[i]) + 1)
			else
				ls_ref += string(integer(adw_pack.object.quantity[i]))
			end if
	 		if ll_pos > 0  then ls_items[i] = Replace(ls_items[i],ll_pos,ll_len,ls_ref) 	
		end if	 
		
		// item <weight>
		if not Isnull(adw_pack.object.weight_gross[i]) then 
			ls_ref = "<weight>"
			ll_len = len(ls_ref)
			ll_pos = pos(ls_items[i], ls_ref)	

			if adw_pack.object.weight_gross[i] > integer(adw_pack.object.weight_gross[i]) then 
				ls_ref += string(integer(adw_pack.object.weight_gross[i]) + 1)
			else
				ls_ref += string(integer(adw_pack.object.weight_gross[i]))
			end if
 			if ll_pos > 0  then ls_items[i] = Replace(ls_items[i],ll_pos,ll_len,ls_ref) 	 
		end if
		
		// item <length>
		if not Isnull(adw_pack.object.length[i]) then 
			ls_ref = "<length>"
			ll_len = len(ls_ref)
			ll_pos = pos(ls_items[i], ls_ref)
			if adw_pack.object.length[i] > integer(adw_pack.object.length[i]) then 
				ls_ref += string(integer(adw_pack.object.length[i]) + 1)
			else
				ls_ref += string(integer(adw_pack.object.length[i]))
			end if
		 	if ll_pos > 0  then ls_items[i] = Replace(ls_items[i],ll_pos,ll_len,ls_ref) 		
		end if	
		
		// item <width>
		if not Isnull(adw_pack.object.width[i]) then
			ls_ref = "<width>"
			ll_len = len(ls_ref)
			ll_pos = pos(ls_items[i], ls_ref)
			if adw_pack.object.width[i] > integer(adw_pack.object.width[i]) then 
				ls_ref += string(integer(adw_pack.object.width[i]) + 1)
			else
				ls_ref += string(integer(adw_pack.object.width[i]))
			end if
	 	if ll_pos > 0  then ls_items[i] = Replace(ls_items[i],ll_pos,ll_len,ls_ref) 		
		end if	
	 
		// item <height>
		if not Isnull(adw_pack.object.height[i]) then 
			ls_ref = "<height>"
			ll_len = len(ls_ref)
			ll_pos = pos(ls_items[i], ls_ref)
			if adw_pack.object.height[i] > integer(adw_pack.object.height[i]) then 
				ls_ref += string(integer(adw_pack.object.height[i]) + 1)
			else
				ls_ref += string(integer(adw_pack.object.height[i]))
			end if 
	 		if ll_pos > 0  then ls_items[i] = Replace(ls_items[i],ll_pos,ll_len,ls_ref) 	 	
		end if
		
	  next // next item in pack list

		// parse la_XML with ls_items[] array
  		ls_ref = "<item><piece_count></piece_count><length></length><width></width><height></height><weight></weight></item>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref = "" // Clear reference field
		FOR i = 1 TO li_rowcount //loop - concatenate item(s) for xml parsing 
			ls_ref += ls_items[i]
		Next
 		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if   //End of check for line items in pack list......................
	
	//Shipment <currency_code> 
	if not Isnull(adw_gemini.object.currency_code[1]) then
		ls_ref = string(adw_gemini.object.currency_code[1])
		ll_pos = len(ls_ref)
		do while ll_pos > 0
			ls_ref = "<currency_code></currency_code>"
			ll_len = len(ls_ref)
			ll_pos = pos(la_XML, ls_ref)			
			ls_ref = "<currency_code>" + string(adw_gemini.object.currency_code[1]) + "</currency_code>"
 			if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
		loop
	end if
	
	//Shipment <declared_value><amount>
	if not Isnull(adw_gemini.object.declared_value[1]) then 
		ls_ref = "<declared_value><amount>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_gemini.object.declared_value[1])
 		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if 
	
	 //Shipment <insured_value><amount>
	if not Isnull(adw_gemini.object.insured_value[1]) then 
		ls_ref = "<insured_value><amount>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_gemini.object.insured_value[1])
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if
	 
	//Shipment <customs_value><amount>
	if not Isnull(adw_gemini.object.custom_value[1]) then 
		ls_ref = "<customs_value><amount>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_gemini.object.custom_value[1])
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref) 
	end if
	 
	 //Shipment <cts><amount> 
	if not Isnull(adw_gemini.object.cts_value[1]) then 
		ls_ref = "<cts><amount>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)	
		ls_ref += string(adw_gemini.object.cts_value[1])
	 	if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref)
	end if
	 
	//Send/Execute XML to Gemini
	if isvalid(iole_gem_obj) then  
		la_XML = iole_gem_obj.GEminiExecute(la_XML)
	else
		MessageBox ( "GEMINI SUBMIT ERROR", "Gemini API not connected, call Menlo Support!" , StopSign!)
		la_XML = "-1"  // -1 return XML with a leading return code
		Return la_XML
	end if

	//Parse out Label data from XML
	ia_labeldata = of_parselabel(la_XML) 
 	
	if left(ia_labeldata,2) = "-1" then  
		MessageBox ( "GEMINI SUBMIT ERROR", "See XML for error message!" , StopSign!)
		Return ia_labeldata
	else 
		// IF there are no error returned in XML then get SHIP/ORDER no from XML
		ll_pos1 = pos(la_XML, "<shipment_number>")
		ll_pos2 = pos(la_XML, "</shipment_number>")
		ll_pos1 += len("<shipment_number>")
		ll_pos2 =  ll_pos2 - ll_pos1
		ls_ref = Mid(la_XML, ll_pos1,ll_pos2)
		adw_gemini.setitem(1, "shipment_no", ls_ref )

		ll_pos1 = pos(la_XML, "<order_number>")
		ll_pos2 = pos(la_XML, "</order_number>")
		ll_pos1 += len("<order_number>")
		ll_pos2 =  ll_pos2 - ll_pos1
		ls_ref = Mid(la_XML, ll_pos1,ll_pos2)
		adw_gemini.setitem(1, "order_no", ls_ref)
		
		adw_gemini.object.delivery_confirm_ind[1] = 'Y'
		
		//Create GIF label image for viewing
 		li_rc = of_createlabel() 
		if li_rc < 0 then 
			MessageBox ( "CREATE GEMINI LABEL GIF", "Error: Could not create a label view" + " See XML for error message!")
			la_XML = "-1" + la_XML  // -1 return XML with a leading return code
		end if
	End IF
 	Return la_XML
end if

end function

public function any of_ordercancel (ref datawindow adw_gemini);//GAP1003 Send a Cancel Order Command to Gemini
any la_XML
long ll_len,ll_pos, ll_rc
string ls_ref

if adw_gemini.object.delivery_confirm_ind[1] <> 'Y' then 
	messagebox("GEMINI ORDER CANCEL", "CANNOT Cancel, This order has NOT been submitted!")
	la_XML = "-1"
	return la_XML
end if

//check Gemini connection
ll_rc = this.of_dbconnect()
if ll_rc < 0 then 
		la_XML = "-1"  // -1 return XML with a leading return code
		Return la_XML
end if

//Load the XML Template
la_XML = of_read_xml_template("OrderCancel.xml")

IF IsNull(la_XML) THEN								
	MessageBox("GEMINI XML TEMPLATE", "CANNOT LOAD XML TEMPLATE") 
	return la_XML
else 
	//Replace placeholders in XML Template with Field Values
	//<shipper_account_number>
	if not Isnull(il_ship_acno) then 
		ls_ref = "<shipper_account_number>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)
		ls_ref += string(il_ship_acno)
		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref)
	end if
	
	//<order_number>
	if not Isnull(adw_gemini.getitemstring(1, "order_no")) then 
		ls_ref = "<order_number>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)
		ls_ref += adw_gemini.getitemstring(1, "order_no")
		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref)
	end if
	 
	 // send XML to Gemini
	if isvalid(iole_gem_obj) then 
		la_XML = iole_gem_obj.GEminiExecute(la_XML)
	else
		MessageBox ( "GEMINI SUBMIT ERROR", "Gemini API not connected, call Menlo Support!" , StopSign!)
		la_XML = "-1"  // -1 return XML with a leading return code
		Return la_XML
	end if
	 
	// Check XML for result code of zero
	ll_pos = pos(la_XML, "<result>0</result>")
	if ll_pos = 0 then  
		MessageBox ( "CANCEL GEMINI ORDER", "Error: See XML for error message!" , StopSign!)
		la_XML = "-1" + la_XML
	else 
		//add CNCLD to ORDERNO and reset indicator
		ls_ref = adw_gemini.getitemstring(1, "order_no") + "(CNCLD)"
		adw_gemini.setitem(1, "order_no", ls_ref)
		adw_gemini.object.delivery_confirm_ind[1] = 'N'
	end if
	
end if
	
return la_XML
end function

public function any of_printlabel (any la_xml, string ls_case, ref datawindow adw_gemini, ref datawindow adw_gemini_label);//GAP1003 Print Labels depending on the Format chosen in Gemini Tab (also used to display label in dw)

long ll_rc, ll_len,ll_pos, ll_pos1, ll_pos2, ll_pjob
string ls_ref
any la_printXML

if adw_gemini.object.delivery_confirm_ind[1] <> 'Y' then 
	messagebox("GEMINI PRINT/PREVIEW LABEL", "NO LABEL CREATED!, This order has NOT been submitted!")
	la_XML = "-1"
	return la_XML
end if

//check Gemini connection
ll_rc = of_dbconnect()
if ll_rc < 0 then 
		la_XML = "-1"  // -1 return XML with a leading return code
		Return la_XML
end if

//Load the XML Template
la_XML = of_read_xml_template("PrintLabel.xml")

IF IsNull(la_XML) THEN								
	MessageBox("GEMINI XML TEMPLATE", "CANNOT LOAD XML TEMPLATE") 
	Return -1
else 
	//Replace placeholders in XML Template with Field Values

	//<shipper_account_number>
	if not Isnull(il_ship_acno) then 
		ls_ref = "<shipper_account_number>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)
		ls_ref += string(il_ship_acno)
		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref)
	end if
	
	//<order_number>
	if not Isnull(adw_gemini.getitemstring(1, "order_no")) then 
		ls_ref = "<order_number>"
		ll_len = len(ls_ref)
		ll_pos = pos(la_XML, ls_ref)
		ls_ref += adw_gemini.getitemstring(1, "order_no")
		if ll_pos > 0  then la_XML = Replace(la_XML,ll_pos,ll_len,ls_ref)
	end if
	
	//Copy XML for printing buffer
	la_printXML = la_XML
	
	//Send/Execute XML to Gemini
	if isvalid(iole_gem_obj) then 
		la_XML = iole_gem_obj.GEminiExecute(la_XML)
	else
		MessageBox ( "GEMINI SUBMIT ERROR", "Gemini API not connected, call Menlo Support!" , StopSign!)
		la_XML = "-1"  // -1 return XML with a leading return code
		Return la_XML
	end if

	// parse label data and create: ia_labeldata
	ia_labeldata = of_parselabel(la_XML)	
	
	// IF there are no errorr returned in XML then get SHIP/ORDER no from XML
	if len(string(ia_labeldata)) <= 0 then  
		MessageBox ( "CREATE/PRINT LABEL", "Error: " + String(ll_rc) + " See XML for error message!" , StopSign!)
		return la_XML
	elseif left(ia_labeldata,2) = "-1"  then  
		MessageBox ( "CREATE/PRINT LABEL", "Error: " + String(ll_rc) + " See XML for error message!" , StopSign!)
		return ia_labeldata
	end if
	
	// create a gif image of the label - (D)efault  
	adw_gemini_label.reset()
	ll_rc = of_createlabel() 		 
	if ll_rc < 0 then 
			MessageBox ( "CREATE GEMINI LABEL GIF", "Error: " + String(ll_rc) + " See XML for error message!" , StopSign!)
			return la_XML
	end if
	adw_gemini_label.insertrow(0)
	
  if ls_case <> "SHOW" then  // Show is used to create a view of the label, but we don't want to print it yet.

	ll_pjob = PrintOpen( ) 		
	CHOOSE CASE Upper(left(ls_case, 1))

		CASE "D"  // send GIF Image to Default printer 
 			PrintDataWindow(ll_pjob, adw_gemini_label)

		CASE "B" // send Cognitive Blaster Format (9")
			// <label_format>
			ls_ref = "<label_format>GIF"
			ll_len = len(ls_ref)
			ll_pos = pos(la_printXML, ls_ref)
			ls_ref = "<label_format>COGNITIVE"
			if ll_pos > 0  then la_printXML = Replace(la_printXML,ll_pos,ll_len,ls_ref)
			//Send/Execute XML to Gemini
			la_XML = iole_gem_obj.GEminiExecute(la_printXML)
			// parse label data and create: ia_labeldata
			ia_labeldata = of_parselabel(la_XML)	
		 	PrintSend ( ll_pjob, ia_labeldata )
		 
		CASE "I" // send Intermec Format 
			MessageBox ( "PRINT GEMINI LABEL", "Error: Intermec Format not available -  Call Menlo Support!" , StopSign!)
		CASE "Z" // send Zebra Format 
			MessageBox ( "PRINT GEMINI LABEL", "Error: Zebra Format not available - Call Menlo Support!" , StopSign!)
		CASE "P"  // send PDF document 
			MessageBox ( "PRINT GEMINI LABEL", "Error: PDF Format not available - Call Menlo Support!" , StopSign!)
		CASE ELSE
			MessageBox ( "PRINT GEMINI LABEL", "Error: Format not available - Please select a printer format" , StopSign!)
			la_XML = "-1" + la_XML
	END CHOOSE
	PrintClose(ll_pjob)
  end if
  return la_XML
end if
end function

public function long of_createlabel ();//GAP 1003 This function will Create a GIF file using  Base64.DecodeToFile
integer li_rc, li_value, li_file
any la_return
string  ls_filename
boolean  lb_value


ls_filename = "geminilabel.gif"

// Delete existing GIF file
lb_value = FileExists ( ls_filename )
IF lb_value = True THEN  FileDelete(ls_filename)

//Connecting to Write the GIF file out using the Gemini base64 library
 	if isvalid(iole_gem_Base64) = false then iole_gem_Base64   = CREATE OLEObject
	li_rc = iole_gem_Base64.ConnectToNewObject("Base64Lib.Base64")
	IF li_rc < 0  THEN
		MessageBox ( "Connect to Gemini Base64 LIB", "Error: " + String(li_rc) + " Contact Menlo WorldWide Support " , StopSign!)
		DESTROY iole_gem_Base64
   	Return -1
	else
		la_return = iole_gem_Base64.DecodeToFile(ia_labeldata, ls_filename) //check path probably should be in \XML directory
  		IF len(string(la_return)) <= 0  THEN   Return -1
		Return 0
	END If

end function

public function string of_read_xml_template (string as_xml_template_name);//GAP1003 FIND XML TEMPLATE IN XML SUBDIRECTORY
String	lsXMLTemplate,	&
			lsFile
			
Integer	liFileNo

//Look in the XML sub-directory within the SIMS directory

If gs_SysPath > '' Then
	lsFile = gs_syspath + 'XML\' + as_XML_Template_name
Else
	lsFile = 'XML\' + as_XML_Template_name
End If

If Not FileExists(lsFile) Then
	Messagebox('Labels', 'Unable to load necessary XML Template!')
 	Return ''
End If

//Open the File - streammode will read entire file into 1 variable
liFileNo = FileOpen(lsFile,StreamMode!,Read!)

If liFileNo < 0 Then
	Messagebox('Labels', 'Unable to load necessary XML Template!')
 	Return ''
End If

FileRead(lifileNo, lsXMLTemplate)
FileClose(liFileNo)

//Messagebox('before',lsXMLTemplate)

 Return lsXMLTemplate
end function

on n_cst_gemini.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_gemini.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

