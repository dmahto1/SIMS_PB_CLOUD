HA$PBExportHeader$n_otm.sru
$PBExportComments$OTM functions
forward
global type n_otm from nonvisualobject
end type
end forward

global type n_otm from nonvisualobject
end type
global n_otm n_otm

forward prototypes
public function integer uf_push_otm_item_master (string as_action_code, string as_project_id, string as_sku, string as_supp_cd, ref string as_server_return_code, ref string as_server_error_message)
public function integer uf_otm_send_order (string as_action_code, string as_project_id, string as_do_no, string as_sku_list[], ref string as_server_return_code, ref string as_server_error_message)
public function boolean uf_item_modified_pandora (ref datawindow adw_main)
public function boolean uf_check_itemmaster_modified (string as_project, ref datawindow adw_main)
public function boolean uf_item_modified_philips_sg (ref datawindow adw_main)
public function integer uf_process_itemmaster (string as_project_id, ref datawindow adw_main, string as_sku, string as_supp_code)
public function integer uf_otm_send_inbound_order (string as_action_code, string as_project_id, string as_ro_no, string as_sku_list[], ref string as_server_return_code, ref string as_server_error_message)
public function boolean uf_check_send_inbound_order (string as_project, ref datawindow adw_main)
public function boolean uf_pandora_outbound_order (ref datawindow adw_main)
public function boolean uf_philips_inbound (ref datawindow adw_main, ref datawindow adw_detail)
public function boolean uf_process_inbound_order (string as_project, ref datawindow idw_main, datawindow idw_detail)
public function boolean uf_philips_outbound (ref datawindow adw_main, ref datawindow adw_detail)
public function boolean uf_process_outbound_order (string as_project, ref datawindow adw_main, ref datawindow adw_detail)
public function boolean uf_item_modified_ariens (ref datawindow adw_main)
public function boolean uf_item_modified_baseline (ref datawindow adw_main)
end prototypes

public function integer uf_push_otm_item_master (string as_action_code, string as_project_id, string as_sku, string as_supp_cd, ref string as_server_return_code, ref string as_server_error_message);// LTK 20111214 Push the Item_Master changes to WebSphere which will send on to OTM via the TIBCO bus

Long ll_return

if Len(as_action_code) > 0 then

	if IsValid(w_main) then
		w_main.setMicroHelp("Updating OTM server...")
	end if

	String lsXML, lsXMLResponse
	u_nvo_websphere_post lu_nvo_websphere_post
	
	lu_nvo_websphere_post = CREATE u_nvo_websphere_post

	lsXML = lu_nvo_websphere_post.uf_request_header("OTMItemSendRequest", "ProjectID='" + as_project_id + "'")
	lsXML += 	'<Project_ID>' + as_project_id +  '</Project_ID>' 
	lsXML += 	'<SKU>' + as_sku +  '</SKU>' 
	lsXML += 	'<Supp_Code>' + as_supp_cd +  '</Supp_Code>' 
	lsXML += 	'<action>' + as_action_code +  '</action>' 
	lsXML = lu_nvo_websphere_post.uf_request_footer(lsXML)

	lsXMLResponse = lu_nvo_websphere_post.uf_post_url(lsXML)

	//Check for Valid Return...
	//If we didn't receive an XML back, there is a fatal exception error
	If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
		Messagebox("Websphere Fatal Exception Error","Unable to send item to OTM/TIBCO bus: ~r~r" + lsXMLResponse,StopSign!)
		as_server_return_code = "-1"
		as_server_error_message = lsXMLResponse
		Return -1
	End If

	// Only the errors with the communication to WebSphere SIMS are trapped here.  The call to the TIBCO bus is asynchronous and will be logged in WebSphere.
	as_server_return_code 		= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"returncode")
	as_server_error_message	= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"errormessage")
	
	Choose Case as_server_return_code
			
		Case "-99" /* Websphere non fatal exception error*/
			
			Messagebox("Websphere Operational Exception Error","Unable to send item to OTM/TIBCO bus: ~r~r" + as_server_error_message,StopSign!)
			Return -1
		
		Case Else
			
			If as_server_error_message > '' Then
				Messagebox("",as_server_error_message)
				Return -1
			End If
				
	End Choose
end if

// LTK 20120201	If we get here then we have made a successful call to WebSphere.  In Test and QA, we may want to indicate this to the testers.
if Upper(Trim(f_retrieve_parm(as_project_id,"FLAG","VERBOSE"))) = 'Y' then
	MessageBox("WebSphere Call Success", "The call to WebSphere was successful! ~r~r" + &
														"Return code: " + as_server_return_code + "~r" + &
														"Error message: " + as_server_error_message)
end if

return ll_return

end function

public function integer uf_otm_send_order (string as_action_code, string as_project_id, string as_do_no, string as_sku_list[], ref string as_server_return_code, ref string as_server_error_message);// LTK 20111227 Send order to WebSphere which will send onto OTM via the TIBCO bus

Long ll_return
String ls_sku_list[]
String ls_Invoice_No

if Len(as_action_code) > 0 then
	
	if IsValid(w_main) then
		w_main.setMicroHelp("Sending Order to OTM server...")
	end if

	String lsXML, lsXMLResponse
	u_nvo_websphere_post lu_nvo_websphere_post
	
	lu_nvo_websphere_post = CREATE u_nvo_websphere_post

	lsXML = lu_nvo_websphere_post.uf_request_header("OTMOrderSendRequest", "ProjectID='" + as_project_id + "'")
	lsXML += 	'<Do_No>' + as_do_no +  '</Do_No>' 
	
	//MEA - 7/13 - Added for Delete as Per Trey
	
	if Upper(Trim(as_action_code)) = 'D' then
	
		Select Invoice_No INTO :ls_Invoice_No  From Delivery_Master Where Do_No = :as_do_no;
	
		lsXML += 	'<Invoice_No>' + ls_Invoice_No +  '</Invoice_No>' 
	end if
	
	if Upper(Trim(as_action_code)) = 'D' and NOT IsNull(as_sku_list) then
		// Create the SKU list XML
		long i
		for i = 1 to UpperBound(as_sku_list)
			lsXML += 	'<SKU>' + as_sku_list[i] +  '</SKU>' 
		next
	end if

	lsXML += 	'<action>' + as_action_code +  '</action>' 
	lsXML = lu_nvo_websphere_post.uf_request_footer(lsXML)

	lsXMLResponse = lu_nvo_websphere_post.uf_post_url(lsXML)
	
	//Check for Valid Return...
	//If we didn't receive an XML back, there is a fatal exception error
	If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
		Messagebox("Websphere Fatal Exception Error","Unable to send order to OTM/TIBCO bus: ~r~r" + lsXMLResponse,StopSign!)
		as_server_return_code = "-1"
		as_server_error_message = lsXMLResponse
		Return -1
	End If

	// Only the errors with the communication to WebSphere SIMS are trapped here.  The call to the TIBCO bus is asynchronous and will be logged in WebSphere.
	as_server_return_code 		= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"returncode")
	as_server_error_message	= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"errormessage")
	
	Choose Case as_server_return_code
			
		Case "-99" /* Websphere non fatal exception error*/
			
			Messagebox("Websphere Operational Exception Error","Unable to send order to OTM/TIBCO bus: ~r~r" + as_server_error_message,StopSign!)
			Return -1
		
		Case Else
			
			If as_server_error_message > '' Then
				Messagebox("",as_server_error_message)
				Return -1
			End If
				
	End Choose
end if

// LTK 20120201	If we get here then we have made a successful call to WebSphere.  In Test and QA, we may want to indicate this to the testers.
if Upper(Trim(f_retrieve_parm(as_project_id,"FLAG","VERBOSE"))) = 'Y' then
	MessageBox("WebSphere Call Success", "The call to WebSphere was successful! ~r~r" + &
														"Return code: " + as_server_return_code + "~r" + &
														"Error message: " + as_server_error_message)
end if

return ll_return

end function

public function boolean uf_item_modified_pandora (ref datawindow adw_main);dwItemStatus l_status
Dec ld_length_1, ld_width_1, ld_height_1, ld_weight_1	// LTK 20120427 OTM additions
String ls_hazard_cd // TAM 10/2016 - New Value needed to send to OTM

// LTK 20120427 OTM additions
boolean lb_return = false

if adw_main.RowCount() > 0 then
	
	//Need to pull the original values.

	l_status = adw_main.GetItemStatus( 1, 0, Primary!)
	
	if l_status = New! or l_status = NewModified! then
		
		SetNull(ld_length_1)
		SetNull(ld_width_1)
		SetNull(ld_height_1)
		SetNull(ld_weight_1)
		SetNull(ls_hazard_cd)
		
	else
	
		ld_length_1 = adw_main.GetItemDecimal(1, "length_1", Primary!, true)  // adw_main.Object.length_1[1]
		ld_width_1 = adw_main.GetItemDecimal(1, "width_1", Primary!, true)  // adw_main.Object.width_1[1]
		ld_height_1 = adw_main.GetItemDecimal(1, "height_1", Primary!, true)  // adw_main.Object.height_1[1]
		ld_weight_1 = adw_main.GetItemDecimal(1, "weight_1", Primary!, true)  // adw_main.Object.weight_1[1]
		ls_hazard_cd = adw_main.GetItemString(1, "hazard_cd", Primary!, true)  // adw_main.Object.hazard_cd[1]  // TAM 10/2016 Added for OTM to Send if Changed

	end if


	lb_return = 	( IsNull(ld_length_1) AND NOT IsNull(adw_main.Object.length_1[1]) ) OR &
					( NOT IsNull(ld_length_1) AND IsNull(adw_main.Object.length_1[1]) ) OR &
					( IsNull(ld_width_1) AND NOT IsNull(adw_main.Object.width_1[1]) ) OR &
					( NOT IsNull(ld_width_1) AND IsNull(adw_main.Object.width_1[1]) ) OR &
					( IsNull(ld_height_1) AND NOT IsNull(adw_main.Object.height_1[1]) ) OR &
					( NOT IsNull(ld_height_1) AND IsNull(adw_main.Object.height_1[1]) ) OR &
					( IsNull(ld_weight_1) AND NOT IsNull(adw_main.Object.weight_1[1]) ) OR &
					( NOT IsNull(ld_weight_1) AND IsNull(adw_main.Object.weight_1[1]) ) // OR &

//TAM 2016/11/28  Separate the UN Code from the Weights and DIMS so if the UN code is Null the Validation will work
//					( IsNull(ls_hazard_cd) AND NOT IsNull(adw_main.Object.hazard_cd[1]) ) OR &
//					( NOT IsNull(ls_hazard_cd) AND IsNull(adw_main.Object.hazard_cd[1]) )  // TAM 10/2016 Added for OTM to Send if Changed
	if NOT lb_return then
		lb_return = 	( IsNull(ls_hazard_cd) AND NOT IsNull(adw_main.Object.hazard_cd[1]) ) OR &
						( NOT IsNull(ls_hazard_cd) AND IsNull(adw_main.Object.hazard_cd[1]) )  // TAM 10/2016 Added for OTM to Send if Changed
	end if				

	if NOT lb_return then
		lb_return = NOT ( ld_length_1 = adw_main.Object.length_1[1] AND &
								ld_width_1 = adw_main.Object.width_1[1] AND &
								ld_height_1 = adw_main.Object.height_1[1] AND &
								ld_weight_1 = adw_main.Object.weight_1[1]) //AND &
//TAM 2016/11/28  Separate the UN Code from the Weights and DIMS so if the UN code is Null the Validation will work
//								ls_hazard_cd = adw_main.Object.hazard_cd[1]) // TAM 10/2016 Added for OTM to Send if Changed
	end if

	if NOT lb_return then
		lb_return = NOT (ls_hazard_cd = adw_main.Object.hazard_cd[1]) // TAM 10/2016 Added for OTM to Send if Changed
	end if				


end if

if lb_return then
	// All 4 DIM fields must contain data to be sent to OTM
//	lb_return =	adw_main.Object.length_1[1] <> 0 AND NOT IsNull(adw_main.Object.length_1[1])  AND &
//					adw_main.Object.width_1[1] <> 0 AND NOT IsNull(adw_main.Object.width_1[1]) AND &
//					adw_main.Object.height_1[1] <> 0 AND NOT IsNull(adw_main.Object.height_1[1]) AND &
//					adw_main.Object.weight_1[1] <> 0 AND NOT IsNull(adw_main.Object.weight_1[1]) 
//					

	lb_return =	NOT (IsNull(adw_main.Object.length_1[1])  OR &
					IsNull(adw_main.Object.width_1[1]) OR &
					IsNull(adw_main.Object.height_1[1]) OR &
					IsNull(adw_main.Object.weight_1[1])) //OR &
//					IsNull(adw_main.Object.hazard_cd[1]))   // TAM 10/2016 Added for OTM to Send if Changed

	if lb_return then

		lb_return =	adw_main.Object.length_1[1] <> 0 AND &
						adw_main.Object.width_1[1] <> 0 AND &
						adw_main.Object.height_1[1] <> 0 AND &
						adw_main.Object.weight_1[1] <> 0 //AND &
//						adw_main.Object.hazard_cd[1] <> ''// TAM 10/2016 Added for OTM to Send if Changed
	end if
	
end if

return lb_return

end function

public function boolean uf_check_itemmaster_modified (string as_project, ref datawindow adw_main);
//MEA - 3/13 - OTM Modificiation
//There should be a case statement for each OTM project and a $$HEX1$$1c20$$ENDHEX$$Case Else$$HEX2$$1d202000$$ENDHEX$$that returns false.
//3-FEB-2019 :Madhu S28945 Added PHILIPSCLS

CHOOSE CASE upper(as_project)
		
CASE "PANDORA"
	//For CASE Pandora, call a new function $$HEX1$$1c20$$ENDHEX$$uf_Item_modified_Pandora$$HEX2$$1d202000$$ENDHEX$$and move the existing logic from  
	//w_Maintenance_Item_Master.wf_otm_fields_modified$$HEX1$$1d20$$ENDHEX$$. Pass the return code all the way back out of uf_check_itemmaster_modified.

	return uf_item_modified_pandora(adw_main)
	

CASE "PHILIPS-SG" ,"PHILIPSCLS"

	//We will also be checking the DIMS/Weight the same as we are doing for Pandora. We can start with a copy of the same code.
	//We also want to include Description in the list of changed fields
	//for Philips we will only send if the Supplier code from the Item Master record (idw_main passed in) is $$HEX1$$1820$$ENDHEX$$SG00$$HEX1$$1920$$ENDHEX$$, $$HEX1$$1820$$ENDHEX$$SG03$$HEX1$$1920$$ENDHEX$$, $$HEX1$$1820$$ENDHEX$$SG10$$HEX2$$19202000$$ENDHEX$$or $$HEX1$$1820$$ENDHEX$$SG71$$HEX1$$1920$$ENDHEX$$.

	return uf_item_modified_philips_sg(adw_main)

CASE 'ARIENS'
	
	return uf_item_modified_ariens(adw_main)

CASE Else
	
// TAM 2013/11/26  Added this as Baseline code.
	return uf_item_modified_baseline(adw_main)

//	return false


END CHOOSE
end function

public function boolean uf_item_modified_philips_sg (ref datawindow adw_main);Dec ld_length_1, ld_width_1, ld_height_1, ld_weight_1
String ls_volume
String ls_description, ls_supp_code	// LTK 20120427 OTM additions
dwItemStatus l_status

// LTK 20120427 OTM additions
boolean lb_return = false

if adw_main.RowCount() > 0 then
	
	//Philips we will only send if the Supplier code from the Item Master record (idw_main passed in) is $$HEX1$$1820$$ENDHEX$$SG00$$HEX1$$1920$$ENDHEX$$, $$HEX1$$1820$$ENDHEX$$SG03$$HEX1$$1920$$ENDHEX$$, $$HEX1$$1820$$ENDHEX$$SG10$$HEX2$$19202000$$ENDHEX$$or $$HEX1$$1820$$ENDHEX$$SG71$$HEX1$$1920$$ENDHEX$$.
	
	//Added 	'SG27'  and 'MY10'.
	
	ls_supp_code = adw_main.Object.supp_code[1]
	
	if  NOT(ls_supp_code =  "SG00" or  ls_supp_code =   "SG03" or  ls_supp_code =  "SG10" or  ls_supp_code =  "SG71" or  ls_supp_code =  "SG27" or  ls_supp_code =  "MY10") then
		return false
	end if
	
	//Need to pull the original values
	l_status = adw_main.GetItemStatus( 1, 0, Primary!)
	
	if l_status = New! or l_status = NewModified! then
		
		SetNull(ld_length_1)
		SetNull(ld_width_1)
		SetNull(ld_height_1)
		SetNull(ld_weight_1)
		SetNull(ls_description)
		SetNull(ls_volume)
		
	else
		
		ld_length_1 = adw_main.GetItemDecimal(1, "length_1", Primary!, true)  // adw_main.Object.length_1[1]
		ld_width_1 = adw_main.GetItemDecimal(1, "width_1", Primary!, true)  // adw_main.Object.width_1[1]
		ld_height_1 = adw_main.GetItemDecimal(1, "height_1", Primary!, true)  // adw_main.Object.height_1[1]
		ld_weight_1 = adw_main.GetItemDecimal(1, "weight_1", Primary!, true)  // adw_main.Object.weight_1[1]
		ls_description = adw_main.GetItemString(1, "description", Primary!, true)  // adw_main.Object.description[1]
		ls_volume = adw_main.GetItemString(1, "user_field8", Primary!, true)  // adw_main.Object.user_field8[1]
		
	end if

	lb_return = 	( IsNull(ld_length_1) AND NOT IsNull(adw_main.Object.length_1[1]) ) OR &
					( NOT IsNull(ld_length_1) AND IsNull(adw_main.Object.length_1[1]) ) OR &
					( IsNull(ld_width_1) AND NOT IsNull(adw_main.Object.width_1[1]) ) OR &
					( NOT IsNull(ld_width_1) AND IsNull(adw_main.Object.width_1[1]) ) OR &
					( IsNull(ld_height_1) AND NOT IsNull(adw_main.Object.height_1[1]) ) OR &
					( NOT IsNull(ld_height_1) AND IsNull(adw_main.Object.height_1[1]) ) OR &
					( IsNull(ld_weight_1) AND NOT IsNull(adw_main.Object.weight_1[1]) ) OR &
					( NOT IsNull(ld_weight_1) AND IsNull(adw_main.Object.weight_1[1]) ) OR &
					( IsNull(ls_description) AND NOT IsNull(adw_main.Object.description[1]) ) OR &
					( NOT IsNull(ls_description) AND IsNull(adw_main.Object.description[1]) ) OR &
					( IsNull(ls_volume) AND NOT IsNull(adw_main.Object.user_field8[1]) ) OR &
					( NOT IsNull(ls_volume) AND IsNull(adw_main.Object.user_field8[1]) ) 
					
	if NOT lb_return then
		
		lb_return = NOT ( ld_length_1 = adw_main.Object.length_1[1] AND &
								ld_width_1 = adw_main.Object.width_1[1] AND &
								ld_height_1 = adw_main.Object.height_1[1] AND &
								ld_weight_1 = adw_main.Object.weight_1[1] AND & 
								ls_description = adw_main.Object.description[1]  AND &
								ls_volume = adw_main.Object.user_field8[1] )
	end if
end if

if lb_return then
	// All 4 DIM fields must contain data to be sent to OTM
//	lb_return =	adw_main.Object.length_1[1] <> 0 AND NOT IsNull(adw_main.Object.length_1[1])  AND &
//					adw_main.Object.width_1[1] <> 0 AND NOT IsNull(adw_main.Object.width_1[1]) AND &
//					adw_main.Object.height_1[1] <> 0 AND NOT IsNull(adw_main.Object.height_1[1]) AND &
//					adw_main.Object.weight_1[1] <> 0 AND NOT IsNull(adw_main.Object.weight_1[1]) 
//					

	lb_return =	NOT (IsNull(adw_main.Object.length_1[1])  OR &
					IsNull(adw_main.Object.width_1[1]) OR &
					IsNull(adw_main.Object.height_1[1]) OR &
					IsNull(adw_main.Object.weight_1[1]) OR &
					IsNull(adw_main.Object.description[1])  OR &
					IsNull(adw_main.Object.user_field8[1]))

	if lb_return then

		lb_return =	adw_main.Object.length_1[1] <> 0 AND &
						adw_main.Object.width_1[1] <> 0 AND &
						adw_main.Object.height_1[1] <> 0 AND &
						adw_main.Object.weight_1[1] <> 0 AND &
						trim(adw_main.Object.description[1])  <> "" AND &
						trim(adw_main.Object.user_field8[1])  <> ""
	end if
	
end if

return lb_return

end function

public function integer uf_process_itemmaster (string as_project_id, ref datawindow adw_main, string as_sku, string as_supp_code);
string ls_action
string ls_return_cd, ls_error_message
boolean lb_otm_field_changes
string 	ls_delete_sku, ls_delete_supp_cd


if adw_main.RowCount() > 0 then
	choose case adw_main.GetItemStatus(1,0,Primary!)
		case New!, NewModified!
			ls_action = 'I'
		case DataModified!
			ls_action = 'U'

	end choose
else
	ls_action = 'D'
end if


lb_otm_field_changes = uf_check_itemmaster_modified(as_project_id, adw_main)


if ls_action = 'D'  then
	// Action is Delete.  Send the stored IM keys to OTM via a WebSphere call.
	
	//Ugh
	//Can't get sku from delete buffer for some reason.
	//Had to pass this in.
	
//	ls_delete_sku = adw_main.GetItemString( 1, "sku", Delete!, true)
//	ls_delete_supp_cd = adw_main.GetItemString( 1, "supp_code", Delete!, true)
//	

	//Need to talk about better way to disable delete than project code.
	//Just did this for temp fix until better one talked about.
	//3-FEB-2019 :Madhu S28945 Added PHILIPSCLS
	If gs_project <> 'PHILIPS-SG' or gs_project <> 'PHILIPSCLS' then

		uf_push_otm_item_master(ls_action, gs_project, as_sku, as_supp_code, ls_return_cd, ls_error_message)
		
	End IF
	
elseif (ls_action = 'I' or ls_action = 'U') and lb_otm_field_changes and adw_main.RowCount() > 0 then
	// If data has been modified in the OTM fields, send the IM keys to OTM via a WebSphere call.
	uf_push_otm_item_master(ls_action, adw_main.Object.project_id[1], adw_main.Object.sku[1], adw_main.Object.Supp_Code[1], ls_return_cd, ls_error_message)
	
//	wf_set_otm_dims()	// LTK 20120427 OTM additions 
end if

return 0
end function

public function integer uf_otm_send_inbound_order (string as_action_code, string as_project_id, string as_ro_no, string as_sku_list[], ref string as_server_return_code, ref string as_server_error_message);// MEA - 4/13 -  Send inbound order to WebSphere which will send onto OTM via the TIBCO bus

Long ll_return
String ls_sku_list[]
String ls_Supp_Invoice_No

if Len(as_action_code) > 0 then
	
	if IsValid(w_main) then
		w_main.setMicroHelp("Sending Order to OTM server...")
	end if

	String lsXML, lsXMLResponse
	u_nvo_websphere_post lu_nvo_websphere_post
	
	lu_nvo_websphere_post = CREATE u_nvo_websphere_post

	lsXML = lu_nvo_websphere_post.uf_request_header("OTMInboundOrderSendRequest", "ProjectID='" + as_project_id + "'")
	lsXML += 	'<Ro_No>' + as_ro_no +  '</Ro_No>' 
	
	//MEA - 7/13 - Added for Delete as Per Trey
	
	if Upper(Trim(as_action_code)) = 'D' then
	
		Select Supp_Invoice_No INTO :ls_Supp_Invoice_No  From Receive_Master Where Ro_No = :as_ro_no;
	
		lsXML += 	'<Supp_Invoice_No>' + ls_Supp_Invoice_No +  '</Supp_Invoice_No>' 
	end if	
	
	
	if Upper(Trim(as_action_code)) = 'D' and NOT IsNull(as_sku_list) then
		// Create the SKU list XML
		long i
		for i = 1 to UpperBound(as_sku_list)
			lsXML += 	'<SKU>' + as_sku_list[i] +  '</SKU>' 
		next
	end if

	lsXML += 	'<action>' + as_action_code +  '</action>' 
	lsXML = lu_nvo_websphere_post.uf_request_footer(lsXML)

	lsXMLResponse = lu_nvo_websphere_post.uf_post_url(lsXML)
	
	//Check for Valid Return...
	//If we didn't receive an XML back, there is a fatal exception error
	If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
		Messagebox("Websphere Fatal Exception Error","Unable to send order to OTM/TIBCO bus: ~r~r" + lsXMLResponse,StopSign!)
		as_server_return_code = "-1"
		as_server_error_message = lsXMLResponse
		Return -1
	End If

	// Only the errors with the communication to WebSphere SIMS are trapped here.  The call to the TIBCO bus is asynchronous and will be logged in WebSphere.
	as_server_return_code 		= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"returncode")
	as_server_error_message	= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"errormessage")
	
	Choose Case as_server_return_code
			
		Case "-99" /* Websphere non fatal exception error*/
			
			Messagebox("Websphere Operational Exception Error","Unable to send order to OTM/TIBCO bus: ~r~r" + as_server_error_message,StopSign!)
			Return -1
		
		Case Else
			
			If as_server_error_message > '' Then
				Messagebox("",as_server_error_message)
				Return -1
			End If
				
	End Choose
end if

// LTK 20120201	If we get here then we have made a successful call to WebSphere.  In Test and QA, we may want to indicate this to the testers.
if Upper(Trim(f_retrieve_parm(as_project_id,"FLAG","VERBOSE"))) = 'Y' then
	MessageBox("WebSphere Call Success", "The call to WebSphere was successful! ~r~r" + &
														"Return code: " + as_server_return_code + "~r" + &
														"Error message: " + as_server_error_message)
end if

return ll_return

end function

public function boolean uf_check_send_inbound_order (string as_project, ref datawindow adw_main);
//MEA - 4/13 - OTM Modificiation
//There should be a case statement for each OTM project and a $$HEX1$$1c20$$ENDHEX$$Case Else$$HEX2$$1d202000$$ENDHEX$$that returns false.
//3-FEB-2019 :Madhu S28945 Added PHILIPSCLS
CHOOSE CASE upper(as_project)

CASE "PHILIPS-SG" ,"PHILIPSCLS"

	//We will also be checking the DIMS/Weight the same as we are doing for Pandora. We can start with a copy of the same code.
	//We also want to include Description in the list of changed fields
	//for Philips we will only send if the Supplier code from the Item Master record (idw_main passed in) is $$HEX1$$1820$$ENDHEX$$SG00$$HEX1$$1920$$ENDHEX$$, $$HEX1$$1820$$ENDHEX$$SG03$$HEX1$$1920$$ENDHEX$$, $$HEX1$$1820$$ENDHEX$$SG10$$HEX2$$19202000$$ENDHEX$$or $$HEX1$$1820$$ENDHEX$$SG71$$HEX1$$1920$$ENDHEX$$.

//	return uf_item_modified_philips_sg(adw_main)

CASE Else
	
	return false


END CHOOSE
end function

public function boolean uf_pandora_outbound_order (ref datawindow adw_main);
// LTK 20120427 OTM additions
boolean lb_return = false

//Need to move all code

return lb_return

end function

public function boolean uf_philips_inbound (ref datawindow adw_main, ref datawindow adw_detail);
// MEA - 4/13 - Philips OTM additions
boolean lb_return = false

string ls_action
integer li_OTM_Return
string lsSetOTM
string ls_return_cd
string ls_error_message
string lsRONO
String lsDeleteSkus[]

If adw_main.GetItemString(1,'ord_status') = 'V' AND adw_main.GetItemString(1,'ord_type') = 'X' Then
	
	lsRONO = adw_main.GetItemString(1,'ro_no')
	ls_action = 'D'
	
	//MikeA 04/13 OTM Project
	//Populates an array of Sku's that need to be sent to OTM on the delete

	Long llRowCount, llRowPos
	
	llRowCount =  adw_detail.Rowcount()
	For llRowPos = 1 to llRowCount
		lsDeleteSkus[llRowPos] = adw_detail.GEtItemString(llRowPOs,'sku')

	Next	
	
	
	li_OTM_Return = uf_otm_send_inbound_order(ls_action, gs_project, lsRONO, lsDeleteSkus, ls_return_cd, ls_error_message)
		
	If li_OTM_Return = -1 then
		//Error OTM
		Messagebox('OTM Error Call','Unable to delete order from OTM')
		return false
	
	End if

End if

return true

end function

public function boolean uf_process_inbound_order (string as_project, ref datawindow idw_main, datawindow idw_detail);
//MEA - 4/13 - OTM Modificiation
//There should be a case statement for each OTM project and a $$HEX1$$1c20$$ENDHEX$$Case Else$$HEX2$$1d202000$$ENDHEX$$that returns false.
//3-FEB-2019 :Madhu S28945 Added PHILIPSCLS
CHOOSE CASE upper(as_project)

CASE "PHILIPS-SG" ,"PHILIPSCLS"

	uf_Philips_Inbound(idw_main, idw_detail)
	
CASE Else
	
	return false


END CHOOSE
end function

public function boolean uf_philips_outbound (ref datawindow adw_main, ref datawindow adw_detail);
// MEA - 4/13 - Philips OTM additions
boolean lb_return = false

string ls_action
integer li_OTM_Return
string lsSetOTM
string ls_return_cd
string ls_error_message
string lsDONO
String lsDeleteSkus[]

If adw_main.GetItemString(1,'ord_status') = 'V'  AND (adw_main.GetItemString(1,'ord_type') = 'R' OR adw_main.GetItemString(1,'ord_type') = 'S') THEN
	
	lsDONO = adw_main.GetItemString(1,'do_no')
	ls_action = 'D'
	
	//MikeA 04/13 OTM Project
	//Populates an array of Sku's that need to be sent to OTM on the delete

	Long llRowCount, llRowPos
	
	llRowCount =  adw_detail.Rowcount()
	For llRowPos = 1 to llRowCount
		lsDeleteSkus[llRowPos] = adw_detail.GEtItemString(llRowPOs,'sku')

	Next	
	
	
	li_OTM_Return = uf_otm_send_order(ls_action, gs_project, lsDONO, lsDeleteSkus, ls_return_cd, ls_error_message)
		
	If li_OTM_Return = -1 then
		//Error OTM
		Messagebox('OTM Error Call','Unable to delete order from OTM')
		return false
	
	End if

End if

return true

end function

public function boolean uf_process_outbound_order (string as_project, ref datawindow adw_main, ref datawindow adw_detail);
//MEA - 4/13 - OTM Modificiation
//There should be a case statement for each OTM project and a $$HEX1$$1c20$$ENDHEX$$Case Else$$HEX2$$1d202000$$ENDHEX$$that returns false.
//3-FEB-2019 :Madhu S28945 Added PHILIPSCLS
CHOOSE CASE upper(as_project)
		
CASE "PANDORA"
	
	uf_Pandora_Outbound_Order(adw_main)

CASE "PHILIPS-SG" ,"PHILIPSCLS"

	uf_Philips_Outbound(adw_main, adw_detail)
	
CASE Else
	
	return false


END CHOOSE
end function

public function boolean uf_item_modified_ariens (ref datawindow adw_main);dwItemStatus l_status
Dec ld_length_1, ld_width_1, ld_height_1, ld_weight_1	// LTK 20120427 OTM additions

// LTK 20120427 OTM additions
boolean lb_return = false

if adw_main.RowCount() > 0 then
	
	//Need to pull the original values.

	l_status = adw_main.GetItemStatus( 1, 0, Primary!)
	
	if l_status = New! or l_status = NewModified! then
		
		SetNull(ld_length_1)
		SetNull(ld_width_1)
		SetNull(ld_height_1)
		SetNull(ld_weight_1)
		
	else
	
		ld_length_1 = adw_main.GetItemDecimal(1, "length_1", Primary!, true)  // adw_main.Object.length_1[1]
		ld_width_1 = adw_main.GetItemDecimal(1, "width_1", Primary!, true)  // adw_main.Object.width_1[1]
		ld_height_1 = adw_main.GetItemDecimal(1, "height_1", Primary!, true)  // adw_main.Object.height_1[1]
		ld_weight_1 = adw_main.GetItemDecimal(1, "weight_1", Primary!, true)  // adw_main.Object.weight_1[1]

	end if


	lb_return = 	( IsNull(ld_length_1) AND NOT IsNull(adw_main.Object.length_1[1]) ) OR &
					( NOT IsNull(ld_length_1) AND IsNull(adw_main.Object.length_1[1]) ) OR &
					( IsNull(ld_width_1) AND NOT IsNull(adw_main.Object.width_1[1]) ) OR &
					( NOT IsNull(ld_width_1) AND IsNull(adw_main.Object.width_1[1]) ) OR &
					( IsNull(ld_height_1) AND NOT IsNull(adw_main.Object.height_1[1]) ) OR &
					( NOT IsNull(ld_height_1) AND IsNull(adw_main.Object.height_1[1]) ) OR &
					( IsNull(ld_weight_1) AND NOT IsNull(adw_main.Object.weight_1[1]) ) OR &
					( NOT IsNull(ld_weight_1) AND IsNull(adw_main.Object.weight_1[1]) ) 

	if NOT lb_return then
		lb_return = NOT ( ld_length_1 = adw_main.Object.length_1[1] AND &
								ld_width_1 = adw_main.Object.width_1[1] AND &
								ld_height_1 = adw_main.Object.height_1[1] AND &
								ld_weight_1 = adw_main.Object.weight_1[1] )
	end if
end if

if lb_return then
	// All 4 DIM fields must contain data to be sent to OTM
//	lb_return =	adw_main.Object.length_1[1] <> 0 AND NOT IsNull(adw_main.Object.length_1[1])  AND &
//					adw_main.Object.width_1[1] <> 0 AND NOT IsNull(adw_main.Object.width_1[1]) AND &
//					adw_main.Object.height_1[1] <> 0 AND NOT IsNull(adw_main.Object.height_1[1]) AND &
//					adw_main.Object.weight_1[1] <> 0 AND NOT IsNull(adw_main.Object.weight_1[1]) 
//					

	lb_return =	NOT (IsNull(adw_main.Object.length_1[1])  OR &
					IsNull(adw_main.Object.width_1[1]) OR &
					IsNull(adw_main.Object.height_1[1]) OR &
					IsNull(adw_main.Object.weight_1[1]) )

	if lb_return then

		lb_return =	adw_main.Object.length_1[1] <> 0 AND &
						adw_main.Object.width_1[1] <> 0 AND &
						adw_main.Object.height_1[1] <> 0 AND &
						adw_main.Object.weight_1[1] <> 0 
	end if
	
end if

return lb_return

end function

public function boolean uf_item_modified_baseline (ref datawindow adw_main);dwItemStatus l_status
Dec ld_length_1, ld_width_1, ld_height_1, ld_weight_1	// LTK 20120427 OTM additions

// LTK 20120427 OTM additions
boolean lb_return = false

if adw_main.RowCount() > 0 then
	
	//Need to pull the original values.

	l_status = adw_main.GetItemStatus( 1, 0, Primary!)
	
	if l_status = New! or l_status = NewModified! then
		
		SetNull(ld_length_1)
		SetNull(ld_width_1)
		SetNull(ld_height_1)
		SetNull(ld_weight_1)
		
	else
	
		ld_length_1 = adw_main.GetItemDecimal(1, "length_1", Primary!, true)  // adw_main.Object.length_1[1]
		ld_width_1 = adw_main.GetItemDecimal(1, "width_1", Primary!, true)  // adw_main.Object.width_1[1]
		ld_height_1 = adw_main.GetItemDecimal(1, "height_1", Primary!, true)  // adw_main.Object.height_1[1]
		ld_weight_1 = adw_main.GetItemDecimal(1, "weight_1", Primary!, true)  // adw_main.Object.weight_1[1]

	end if


	lb_return = 	( IsNull(ld_length_1) AND NOT IsNull(adw_main.Object.length_1[1]) ) OR &
					( NOT IsNull(ld_length_1) AND IsNull(adw_main.Object.length_1[1]) ) OR &
					( IsNull(ld_width_1) AND NOT IsNull(adw_main.Object.width_1[1]) ) OR &
					( NOT IsNull(ld_width_1) AND IsNull(adw_main.Object.width_1[1]) ) OR &
					( IsNull(ld_height_1) AND NOT IsNull(adw_main.Object.height_1[1]) ) OR &
					( NOT IsNull(ld_height_1) AND IsNull(adw_main.Object.height_1[1]) ) OR &
					( IsNull(ld_weight_1) AND NOT IsNull(adw_main.Object.weight_1[1]) ) OR &
					( NOT IsNull(ld_weight_1) AND IsNull(adw_main.Object.weight_1[1]) ) 

	if NOT lb_return then
		lb_return = NOT ( ld_length_1 = adw_main.Object.length_1[1] AND &
								ld_width_1 = adw_main.Object.width_1[1] AND &
								ld_height_1 = adw_main.Object.height_1[1] AND &
								ld_weight_1 = adw_main.Object.weight_1[1] )
	end if
end if

if lb_return then
	// All 4 DIM fields must contain data to be sent to OTM
//	lb_return =	adw_main.Object.length_1[1] <> 0 AND NOT IsNull(adw_main.Object.length_1[1])  AND &
//					adw_main.Object.width_1[1] <> 0 AND NOT IsNull(adw_main.Object.width_1[1]) AND &
//					adw_main.Object.height_1[1] <> 0 AND NOT IsNull(adw_main.Object.height_1[1]) AND &
//					adw_main.Object.weight_1[1] <> 0 AND NOT IsNull(adw_main.Object.weight_1[1]) 
//					

	lb_return =	NOT (IsNull(adw_main.Object.length_1[1])  OR &
					IsNull(adw_main.Object.width_1[1]) OR &
					IsNull(adw_main.Object.height_1[1]) OR &
					IsNull(adw_main.Object.weight_1[1]) )

	if lb_return then

		lb_return =	adw_main.Object.length_1[1] <> 0 AND &
						adw_main.Object.width_1[1] <> 0 AND &
						adw_main.Object.height_1[1] <> 0 AND &
						adw_main.Object.weight_1[1] <> 0 
	end if
	
end if

return lb_return

end function

on n_otm.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_otm.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

