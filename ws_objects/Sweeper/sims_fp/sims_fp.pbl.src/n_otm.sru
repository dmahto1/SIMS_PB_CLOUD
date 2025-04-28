$PBExportHeader$n_otm.sru
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
public function integer uf_otm_send_inbound_order (string as_action_code, string as_project_id, string as_ro_no, string as_sku_list[], ref string as_server_return_code, ref string as_server_error_message)
public function boolean uf_process_outbound_order (string as_project, string as_dono, ref datastore ads_doheader, long al_headerpos, ref datastore ads_delivery_master, string as_deleted_sku[])
public function boolean uf_philips_outbound (string as_project, string as_dono, ref datastore ads_doheader, long al_headerpos, ref datastore ads_delivery_master, string as_deleted_sku[])
public function boolean uf_philips_inbound (string as_project, string as_rono, ref datastore ads_poheader, integer al_headerpos, ref datastore ads_receive_master, string as_deleted_skus[])
public function boolean uf_process_inbound_order (string as_project, string as_rono, ref datastore ads_poheader, long al_headerpos, ref datastore ads_receive_master, string as_deleted_skus[])
private function boolean uf_pandora_outbound (string as_project, string as_dono, ref datastore ads_doheader, long al_headerpos, ref datastore ads_delivery_master, string as_delete_skus[])
end prototypes

public function integer uf_push_otm_item_master (string as_action_code, string as_project_id, string as_sku, string as_supp_cd, ref string as_server_return_code, ref string as_server_error_message);// LTK 20111214 Push the Item_Master changes to WebSphere which will send on to OTM

Long ll_return
String lsLogOut

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

	if IsValid(w_main) then
		w_main.setMicroHelp("")
	end if

	//Check for Valid Return...
	//If we didn't receive an XML back, there is a fatal exception error
	If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
		lsLogOut = "-       Websphere Fatal Exception Error sending item to OTM/TIBCO bus.  Item: " 
		lsLogOut += " [project_id=" + as_project_id + "   sku=" + as_sku + "   supp_code=" + as_supp_cd + "]  Error message:  " + lsXMLResponse
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

		as_server_return_code = "-1"
		as_server_error_message = lsXMLResponse
		Return -1
	Else
		
		lsLogOut = '              Made OTM call for Item Master  (' + as_action_code + ')  : ' + "   sku=" + as_sku + "   supp_code=" + as_supp_cd 
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/				
		
	End If

	// Only the errors with the communication to WebSphere SIMS are trapped here.  The call to the TIBCO bus is asynchronous and will be logged in WebSphere.
	as_server_return_code 		= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"returncode")
	as_server_error_message	= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"errormessage")
	
	Choose Case as_server_return_code
			
		Case "-99" /* Websphere non fatal exception error*/
			
			lsLogOut = "-       Websphere Operational Exception Error sending item to OTM/TIBCO bus.  Item: " 
			lsLogOut += " [project_id=" + as_project_id + "   sku=" + as_sku + "   supp_code=" + as_supp_cd + "]  Error message:  " + as_server_error_message
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			Return -1
		
		Case Else
			
			If as_server_error_message > '' Then
				lsLogOut = "-       Websphere Error sending item to OTM/TIBCO bus.  Item: " 
				lsLogOut += " [projectid=" + as_project_id + "   sku=" + as_sku + "   supp_code=" + as_supp_cd + "]  Error message:  " + as_server_error_message
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

				Return -1
			End If
				
	End Choose
end if

return ll_return

end function

public function integer uf_otm_send_order (string as_action_code, string as_project_id, string as_do_no, string as_sku_list[], ref string as_server_return_code, ref string as_server_error_message);// LTK 20111227 Send order to WebSphere which will send onto OTM 

Long ll_return
String ls_sku_list[]
String lsLogOut

if Len(as_action_code) > 0 then

	if IsValid(w_main) then
		w_main.setMicroHelp("Sending Order to OTM server...")
	end if

	String lsXML, lsXMLResponse
	u_nvo_websphere_post lu_nvo_websphere_post
	
	lu_nvo_websphere_post = CREATE u_nvo_websphere_post

	lsXML = lu_nvo_websphere_post.uf_request_header("OTMOrderSendRequest", "ProjectID='" + as_project_id + "'")
	lsXML += 	'<Do_No>' + as_do_no +  '</Do_No>' 
	
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

	if IsValid(w_main) then
		w_main.setMicroHelp("")
	end if

	//Check for Valid Return...
	//If we didn't receive an XML back, there is a fatal exception error
	If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
		lsLogOut = "-       Websphere Fatal Exception Error sending order to OTM/TIBCO bus.  Order: " 
		lsLogOut += " [project_id=" + as_project_id + "   do_no=" + as_do_no + "]  Error message:  " + lsXMLResponse
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

		as_server_return_code = "-1"
		as_server_error_message = lsXMLResponse
		Return -1
	End If

	// Only the errors with the communication to WebSphere SIMS are trapped here.  The call to the TIBCO bus is asynchronous and will be logged in WebSphere.
	as_server_return_code 		= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"returncode")
	as_server_error_message	= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"errormessage")
	
	Choose Case as_server_return_code
			
		Case "-99" /* Websphere non fatal exception error*/
			
			lsLogOut = "-       Websphere Operational Exception Error sending order to OTM/TIBCO bus.  Order: " 
			lsLogOut += " [project_id=" + as_project_id + "   do_no=" + as_do_no + "]  Error message:  " + as_server_error_message
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			Return -1
		
		Case Else
			
			If as_server_error_message > '' Then
				lsLogOut = "-       Websphere Error sending order to OTM/TIBCO bus.  Order: " 
				lsLogOut += " [project_id=" + as_project_id + "   do_no=" + as_do_no + "]  Error message:  " + as_server_error_message
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

				Return -1
			End If
	End Choose
end if

return ll_return

end function

public function integer uf_otm_send_inbound_order (string as_action_code, string as_project_id, string as_ro_no, string as_sku_list[], ref string as_server_return_code, ref string as_server_error_message);// LTK 20111227 Send order to WebSphere which will send onto OTM 

Long ll_return
String ls_sku_list[]
String lsLogOut

if Len(as_action_code) > 0 then

	if IsValid(w_main) then
		w_main.setMicroHelp("Sending Order to OTM server...")
	end if


	String lsXML, lsXMLResponse
	u_nvo_websphere_post lu_nvo_websphere_post
	
	lu_nvo_websphere_post = CREATE u_nvo_websphere_post

	lsXML = lu_nvo_websphere_post.uf_request_header("OTMInboundOrderSendRequest", "ProjectID='" + as_project_id + "'")
	lsXML += 	'<Ro_No>' + as_ro_no +  '</Ro_No>' 
	
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

	if IsValid(w_main) then
		w_main.setMicroHelp("")
	end if

	//Check for Valid Return...
	//If we didn't receive an XML back, there is a fatal exception error
	If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
		lsLogOut = "-       Websphere Fatal Exception Error sending order to OTM/TIBCO bus.  Order: " 
		lsLogOut += " [project_id=" + as_project_id + "   do_no=" + as_ro_no + "]  Error message:  " + lsXMLResponse
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

		as_server_return_code = "-1"
		as_server_error_message = lsXMLResponse
		Return -1
	End If

	// Only the errors with the communication to WebSphere SIMS are trapped here.  The call to the TIBCO bus is asynchronous and will be logged in WebSphere.
	as_server_return_code 		= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"returncode")
	as_server_error_message	= lu_nvo_websphere_post.uf_get_xml_single_Element(lsXMLResponse,"errormessage")
	
	Choose Case as_server_return_code
			
		Case "-99" /* Websphere non fatal exception error*/
			
			lsLogOut = "-       Websphere Operational Exception Error sending order to OTM/TIBCO bus.  Order: " 
			lsLogOut += " [project_id=" + as_project_id + "   do_no=" + as_ro_no + "]  Error message:  " + as_server_error_message
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			Return -1
		
		Case Else
			
			If as_server_error_message > '' Then
				lsLogOut = "-       Websphere Error sending order to OTM/TIBCO bus.  Order: " 
				lsLogOut += " [project_id=" + as_project_id + "   do_no=" + as_ro_no + "]  Error message:  " + as_server_error_message
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

				Return -1
			End If
	End Choose
end if

return ll_return

end function

public function boolean uf_process_outbound_order (string as_project, string as_dono, ref datastore ads_doheader, long al_headerpos, ref datastore ads_delivery_master, string as_deleted_sku[]);

//MEA - 4/13 - OTM Modificiation
//There should be a case statement for each OTM project and a “Case Else” that returns false.

CHOOSE CASE upper(as_project)
		
CASE "PANDORA"
	
 	uf_Pandora_Outbound(as_project, as_DoNo, ads_doheader, al_headerpos, ads_delivery_master, as_deleted_sku) 

CASE "PHILIPS-SG"

	uf_Philips_Outbound(as_project, as_DoNo, ads_doheader, al_headerpos, ads_delivery_master, as_deleted_sku) 
	
CASE Else
	
	return false


END CHOOSE
end function

public function boolean uf_philips_outbound (string as_project, string as_dono, ref datastore ads_doheader, long al_headerpos, ref datastore ads_delivery_master, string as_deleted_sku[]);

// MEA - 4/13 OTM additions
boolean lb_return = false

string lsDeleteSkus[]

string ls_return_cd, ls_error_message, lsLogOut

string ls_action
string ls_plant_codes, ls_shipping_route

//	We will only send to OTM where Delivery_Master.User_Field is ‘SG00’ or ‘SG10’
//delivery_master.user_field3
//	We will only send for new orders (I don’t believe we get updates anyway)



ls_action = ads_DOHeader.GetItemString( al_HeaderPos, "action_cd")

ls_plant_codes =  ads_DOHeader.GetItemString( al_HeaderPos, "user_field3")
ls_shipping_route =  ads_DOHeader.GetItemString( al_HeaderPos, "user_field2")

If IsNull(ls_plant_codes) then ls_plant_codes = ''
If IsNull(ls_shipping_route) then ls_shipping_route = ''

if ls_action = 'A' AND &
   (ls_plant_codes = 'SG00' OR ls_plant_codes = 'SG10') AND &
   NOT (ls_shipping_route = 'SGM9' OR ls_shipping_route = 'SG9999') then    

	uf_otm_send_order('I', as_Project, as_DONO, lsDeleteSkus, ls_return_cd, ls_error_message)
	
	If ls_return_cd = '-1' then
		
			//OTM Error
		
			Update delivery_master
				Set OTM_Status = 'E'
				where project_id = :as_project
				and do_no = :as_dono;
		
		
		lsLogOut = '       ***OTM System Error! Unable to request OTM call for Do_No: ' + as_DONO 
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/				
		
	Else
		
		//OTM Success
	
		Update delivery_master
			Set OTM_Status = 'S'
			where project_id = :as_project
			and do_no = :as_dono;		
	
	
		lsLogOut = '              Made OTM call for Do_No: ' + as_DONO + " at " + String(Today(), "mm/dd/yyyy hh:mm:ss") 
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/				
	end if
	
end if

return lb_return

end function

public function boolean uf_philips_inbound (string as_project, string as_rono, ref datastore ads_poheader, integer al_headerpos, ref datastore ads_receive_master, string as_deleted_skus[]);

// MEA - 4/13 OTM additions
boolean lb_return = false

string lsDeleteSkus[]

string ls_return_cd, ls_error_message, lsLogOut
string ls_action, ls_order_type

//Need to move all code

ls_action = ads_Poheader.GetItemString( al_Headerpos, "action_cd")
ls_order_type = ads_Poheader.GetItemString( al_Headerpos, "order_type")


//Only send Adds

if ls_action = 'A' and ls_order_type = 'X' then

	uf_otm_send_inbound_order('I', as_Project, as_RONO, lsDeleteSkus, ls_return_cd, ls_error_message)
	
	If ls_return_cd = '-1' then
		
		//OTM Error
		
		Update receive_master
			Set OTM_Status = 'E'
			where project_id = :as_project
			and ro_no = :as_rono;	
		
		
		lsLogOut = '       ***OTM System Error! Unable to request OTM call for Ro_No: ' + as_RONO 
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/				
		
	Else
		
		//OTM Success
	
		Update receive_master
			Set OTM_Status = 'S'
			where project_id = :as_project
			and ro_no = :as_rono;	
		
	
		lsLogOut = '              Made OTM call for Ro_No: ' + as_RONO + " at " + String(Today(), "mm/dd/yyyy hh:mm:ss") 
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/				
	end if
	
end if

return lb_return

end function

public function boolean uf_process_inbound_order (string as_project, string as_rono, ref datastore ads_poheader, long al_headerpos, ref datastore ads_receive_master, string as_deleted_skus[]);

//MEA - 4/13 - OTM Modificiation
//There should be a case statement for each OTM project and a “Case Else” that returns false.

CHOOSE CASE upper(as_project)

CASE "PHILIPS-SG"

	uf_Philips_Inbound(as_project, as_RoNo, ads_poheader, al_headerpos, ads_receive_master, as_deleted_skus) 
	
CASE Else
	
	return false


END CHOOSE
end function

private function boolean uf_pandora_outbound (string as_project, string as_dono, ref datastore ads_doheader, long al_headerpos, ref datastore ads_delivery_master, string as_delete_skus[]);

boolean lb_return

//string lsScheduleCode, lsfromwh, lsoutboundtype

//TimA 01/12/12 OTM Project
String ls_return_cd, ls_error_message,  lsScheduleCode,  ls_Country,ls_Code_Descript, lsProcessOTM, lsGroupCode, lsFromWH, lsOutboundType
Long ll_ShuttleFlag  //To Determine is a the order is Shuttle or not. 1 = Yes shuttle, 0 = non shuttle
//TimA 04/13/12 Pandora issue #396
Long ll_Skip_OTM, ll_SkipOTMFlag //Sometime we need to skip a call to OTM for Enterprise orders.
Long llShuttleLookupCount
Integer li_OTM_Return  //Return code for OTM calls
String lsMultiStageStatus //Used on Multi Stage orders being set in u_nvo_proc_pandora
String ls_cust_code
String  ls_to_customer_UF1
integer liSkipOTMCount

//TimA 08/07/12 Pandora issue #440
String lsEDI_OTM_Status
//TimA 08/10/12
String ls_transport_mode, ls_ship_ref,ls_ship_via, ls_ship_to_override_flag
Long llCustCodeOverride
String ls_ship_to_override_UF1
String lsLogOut
String lsOTM_Y_N //TimA 07/18/13 this was moved from u_nvo_process_files 1.55.1.0

String lsWH_Code, ls_action

Datetime ldtWhTime

//TimA 08/07/12 Pandora issue #440.  The OTM Status for this is being set in u_nvo_process-so_rose.  If the EDI Outbound has a status of X then this is an update to an
//existing order that was in "Ready" status.
lsEDI_OTM_Status = ads_doheader.GetITemString(al_headerpos,'OTM_Status')
//TimA 05/24/13 Pandora issue #606 the OTM_Y_N is set in Pandora_so_rose.  This is a flag for RTV-RMA skipping OTM

//TimA 07/18/13 this was moved from u_nvo_process_files 1.55.1.0
lsOTM_Y_N = ads_doheader.GetITemString(al_headerpos,'OTM_Y_N')

lsWH_Code = ads_doheader.GetITemString(al_headerpos,'wh_code')
ldtWhTime = f_getLocalWorldTime(lsWh_Code)
ls_action = ads_doheader.GetItemString( al_HeaderPos, "action_cd")

If ads_doheader.GetItemString(al_HeaderPos,'User_field1') > ' ' Then
	ads_delivery_master.SetItem(1,'User_field1',ads_doheader.GetITemString(al_headerpos,'User_field1'))
	//TimA 01/24/12 OTM Project
	lsScheduleCode 	= ads_doheader.GetItemString(al_HeaderPos,'User_field1')
End If

If ads_doheader.GetItemString(al_headerpos,'User_field2') > ' ' Then
		ads_delivery_master.SetItem(1,'User_field2',ads_doheader.GetITemString(al_headerpos,'User_field2'))
		//TimA 04/16/12 Pandora issue #396 Get the From Loc:
		lsFromWH = ads_doheader.GetItemString(al_headerpos,'User_field2')
End If

ls_cust_code =ads_delivery_master.GetItemString(1,'Cust_code')
//lsMultiStageStatus = ads_delivery_master.GetITemString(1,'Ord_Status')

//TimA 01/25/12 OTM Project.  Need the country of the warehouse.
//Look for the new global_warhouse flag in the lookup table

SELECT 	Code_Descript 	INTO :ls_Code_Descript FROM Lookup_Table   
Where 	project_id = :as_project and Code_type = 'OTM' and Code_ID = 'global_warhouse';

	
SELECT dbo.Warehouse.country
INTO :ls_Country
FROM dbo.Warehouse
WHERE wh_code = :lsWH_Code;

If ls_Code_Descript = 'Y' Then
	lsProcessOTM = 'Y'
Else
	//We still want to do US warehouses
	If ls_Country = 'US' then 
		lsProcessOTM = 'Y'
	else		
		lsProcessOTM = 'N'
	end if
End if

// MEA 8/2018 - S22722
//At roughly line 70, there is logic that sets “lsProcessOTM”. 
//After this IF statement, add logic to retrieve the table entry above based on the warehouse for the current order. 
//If a record is found, set “lsProcessOTM” = “N”.

SELECT 	Count(*) INTO :liSkipOTMCount FROM Lookup_Table   
Where 	project_id = :as_project and Code_type = 'SKIP_OTM' and Code_ID = :lsWH_Code;

IF liSkipOTMCount >= 1 THEN
	lsProcessOTM = 'N'
END IF


//write to screen
lsLogOut = '       processing OTM Order - uf_pandora_outbound() for Do_No: ' + as_dono +' - Scheduled Code: '+nz(lsScheduleCode,'-') + ' -cust code: '+nz(ls_cust_code, '-')
lsLogOut += '       code Description: '+nz(ls_Code_Descript, '-') + ' Process OTM: '+nz(lsProcessOTM ,'-')
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) 
			
//Delete
If ls_action = "D" then
					
	//TimA 08/09/12 Pandora issue #440.  An order in New status and OTM Ready don't delete the OTM record.
	If lsEDI_OTM_Status = 'Q' Then  //This is being set in u_nvo_process_so_roses
			lsLogOut = '       Do_No ' + as_dono +  '  was an updated order in Ready status.  Do not delete from OTM.'
			FileWrite(gilogFileNo,lsLogOut)		
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/								
	Else
		li_OTM_Return = uf_otm_send_order('D', as_project, as_dono, as_delete_skus, ls_return_cd, ls_error_message)		

		If li_OTM_Return = -1 then 
			lsLogOut = '       ***OTM System Error! Unable to request OTM delete call for Do_No: ' + as_dono 
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		Else
			lsLogOut = '       Do_No ' + as_dono +  '  was sent to OTM for a successfull delete.'
			FileWrite(gilogFileNo,lsLogOut)		
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		end if
	End if

	// ET3  2012-05-01: per 389, set OTM status to 'V' as well
	Update delivery_master
	Set ord_status = 'V', otm_status = 'V'
	where project_id = :as_project
	and do_no = :as_dono;
							
Else

	ll_SkipOTMFlag = 0
	
	If  IsNull(lsScheduleCode) or lsScheduleCode = '' Then
		//TimA 01/17/12 OTM Project
		//Per Ian if there is nothing in the Remarks column or 'OTH'  then it is a non Shuttle				
		ll_ShuttleFlag = 0 //Non Shuttle
	
		//TimA 04/13/12 Pandora issue #396 Check if Enterprise order
		Select User_Field1 INTO :lsGroupCode from Customer
		where project_id = :as_project and Cust_Code = :lsFromWH;  //From Loc:
			
		select count(1) INTO :ll_Skip_OTM from lookup_table
		where project_id = :as_project and code_type = 'OTM'
		and code_ID = :lsGroupCode and code_descript = Upper('SKIP_OTM');
	
		If ll_Skip_OTM > 0 Then
			//Record found in the Lookup table for group code to Skip OTM Calls
			ll_SkipOTMFlag = 1
		End if
		
		//write to screen
		lsLogOut = '       processing OTM Order - uf_pandora_outbound() for Do_No: ' + as_dono +' - Group Code: '+nz(lsGroupCode,'-') + ' -SKIP OTM count: '+nz(string(ll_Skip_OTM), '-')
		lsLogOut += '       SKIP OTM Flag: '+string(ll_SkipOTMFlag) + '- ShuttleFlag: ' +string(ll_ShuttleFlag)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) 

	Else
		If lsScheduleCode = Upper('OTH') then //Code for Non Shuttle comes from shopping card
			ll_ShuttleFlag = 0  
		Else
			//This is for those special occations that someone say if its a curtain code then non shuttle
			//Note:  There shouldn't be anything in the lookup table.  This is only for exceptions to the rule.
			
			//TimA 04/12/12 Changed the where clause because the first three columns are primary key and only one could be entered
			select count(1) INTO :llShuttleLookupCount from lookup_table
			where project_id = :as_project and code_type = 'OTM'
			and code_ID = :lsScheduleCode and code_descript = Upper('CALL_OTM');
			
			//and code_ID = 'CALL_OTM' and code_descript = :lsScheduleCode;
			
			If llShuttleLookupCount > 0 then
				ll_ShuttleFlag = 0
			Else
				ll_ShuttleFlag = 1  //Shuttle order.  
			End if
			
		//write to screen
		lsLogOut = '       processing OTM Order - uf_pandora_outbound() for Do_No: ' + as_dono +' - Shuttle LookUp Count: '+nz(string(llShuttleLookupCount),'-')
		lsLogOut += '       SKIP OTM Flag: '+string(ll_SkipOTMFlag) + ' - ShuttleFlag: '+string(ll_ShuttleFlag)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) 
		
		end if
	End if
	
	lsMultiStageStatus =ads_delivery_master.GetITemString(1,'Ord_Status')
	//TimA 08/06/12 Pandora issue #440
	//This is a new order that was created but the OTM Status was set to "Ready" .  On this new record set the Ord_Status to New and OTM Status to NON OTM.
	//Don't call OTM
	If lsEDI_OTM_Status = 'Q' Then  //This is being set in u_nvo_process_so_roses
		ads_delivery_master.SetItem(1,'ord_status','N')
		ads_delivery_master.SetItem(1,'otm_status','N')
		ll_ShuttleFlag = 1 //Using this flag because it skip the OTM Process
	Else
		If ll_ShuttleFlag = 1 then
			//TimA 03/28/12 OTM Project
			//If the order status is 'M' it is a multi stage order.  This flag is being set in u_nvo_proc_pandora - uf_process_so_rose
			//Should only be ord status of 'M' for the current sweep.  Should never stay 'M'
			//Ifads_delivery_masterGetITemString(1,'Ord_Status') = 'M' then
			If lsMultiStageStatus = 'M' then //TimA 04/26/12 Change to using a varable instead of the Getitemstring
				ads_delivery_master.SetItem(1,'ord_status','H')
				ads_delivery_master.SetItem(1,'OTM_status','M')
			else	
				ads_delivery_master.SetItem(1,'ord_status','N')
			End if
			
			//Ifads_delivery_masterGetITemString(1,'Ord_Status') = 'M' then
			If lsMultiStageStatus = 'M' then //TimA 04/26/12 Change to using a varable instead of the Getitemstring
				ads_delivery_master.SetItem(1,'OTM_status','M')		//Non OTM
			Else
				ads_delivery_master.SetItem(1,'OTM_status','N')		//Non OTM
			End if
		Else
			If lsMultiStageStatus = 'M' then 
				ads_delivery_master.SetItem(1,'ord_status','H')
				ads_delivery_master.SetItem(1,'OTM_status','M')
			End if
		End if
	End if
//		End if

//		//-----
//		
		
	//TimA 05/01/12 Don't call OTM Yet.  This is a multi stage order
	If lsMultiStageStatus = 'M' then
		ll_SkipOTMFlag = 1
	End if

	//TimA 05/24/13 Pandora issue #606  this flag is set in pandora_so_rose
	//TimA 07/18/13 this was moved from u_nvo_process_files 1.55.1.0
	If lsOTM_Y_N = 'N' then
		ll_SkipOTMFlag = 1
	End if
	
	// LTK 20120511  	Pandora #417 For *SHIP TO* customers, exclude CB & VNDR PD Shipments from OTM and set DM.UF1 accordingly
	//						The Ship To customer code list is stored in the Lookup_Table so it is data driven.

	// DM.UF1 is set based on the Ship *FROM* Customer up above.  If the following flag is set to 'Y', DM.UF1 is overridden and will be based on the Ship *TO* Customer setting
	llCustCodeOverride = 0

	select code_descript 
	into :ls_ship_to_override_flag
	from lookup_table
	where project_id = :as_project 
	and code_type = 'FLAG'
	and code_ID = 'OTM_ST_OVERRIDE';
	
	if ll_SkipOTMFlag = 0 or Upper(Trim(ls_ship_to_override_flag)) = 'Y' then
	
		ls_cust_code =ads_delivery_master.GetItemString(1,'Cust_code')
		if Len(ls_cust_code) > 0 then

			Select User_Field1 
			into :ls_to_customer_UF1
			from Customer
			where project_id = :as_project 
			and Cust_Code = :ls_cust_code;  // Customer code of To Customer

			select code_descript 
			into :ls_ship_to_override_UF1 
			from lookup_table 
			where project_id = :as_project
			and code_type = 'OTMST' 
			and code_ID = :ls_to_customer_UF1;
		
			if Len(ls_ship_to_override_UF1) > 0 then
				//TimA 08/02/12 Pandora fix.  If the order is already flagged at DOS or Shuttle reset the flag here
				//So the logic in the next step dosen't fail
				If ll_ShuttleFlag = 1 then
					ll_ShuttleFlag = 0
				End if
				String ls_UF1 = 'SCH'
			

				select transport_mode, ship_ref, ship_via
				into :ls_transport_mode, :ls_ship_ref, :ls_ship_via
				from carrier_master
				where project_id = 'PANDORA'
				and carrier_code = :ls_to_customer_UF1;
			
				ll_SkipOTMFlag = 1
				llCustCodeOverride = 1
			
				//write to screen
				lsLogOut = '       processing OTM Order - uf_pandora_outbound() for Do_No: ' + as_dono +' - Cust code: '+nz(ls_cust_code,'-') + ' -Shuttle Flag: ' +string(ll_ShuttleFlag)
				lsLogOut += '      Cust UF1: '+ls_to_customer_UF1 + ' -ShipTo Override: '+nz(ls_ship_to_override_UF1,'-') +' -SKIP OTM Flag: '+string(ll_SkipOTMFlag)
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) 

			end if

		end if
	end if
	// End of #417 block

	//TAM 2019/04/12 - S25773 -DE9566 - For TMS enabled warehouses we Need to set OMS status(Set from EDI Value)
	String lsTmsFlag = 'N'
	String lsTmsWHFlag = ''
	String lsOTMStatus = ''

	select code_descript	into :lsTmsFlag from lookup_table	where project_id = 'PANDORA' and code_type = 'FLAG' and code_id = 'TMS';
	select code_descript	into :lsTmsWHFlag from lookup_table	where project_id = 'PANDORA' and code_type = 'SKIP_TMS' and code_id = :lsWh_code; //Return blank means this warehouse is participating in TMS

	if lsTmsFlag = "Y" and lsTmsWHFlag = '' Then
		lsProcessOTM = 'N'
		lsOTMStatus = lsEDI_OTM_Status		
		ads_delivery_master.SetItem(1,'otm_status',lsOTMStatus)
		//write to screen
		lsLogOut = '       processing OTM Order - uf_pandora_outbound() for Do_No: ' + as_dono + '    -TmsFlag: ' + lsTmsFlag
		lsLogOut += '   -TmsWHFlag: ' + lsTmsWHFlag + '   -OTMStatus: ' + lsOTMStatus 
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) 

	End If
		
	
	//TimA 01/16/12 OTM Project

	If lsProcessOTM = 'Y' Then  //This flag is determine by the country flag in the lookup table.  See further above in this code
		If ll_ShuttleFlag = 0 Then  //Only send to OTM if Non Shuttle order
			If ll_SkipOTMFlag = 0 then //Skip some Enterprise orders.  This info is in the Lookup table
				uf_otm_send_order('I', as_project, as_dono, as_delete_skus, ls_return_cd, ls_error_message)
				If ls_return_cd = '-1' then
					lsLogOut = '       ***OTM System Error! Unable to request OTM call for Do_No: ' + as_dono + ' OTM Status set to Sweeper Hold'
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/				
					
					//Error Set OTM Status to Sweeper status for the next sweep
					Update Delivery_master
					Set OTM_Status = 'S'
					Where project_id = :as_project and Do_No = :as_dono ;
					Commit;
				Else
					//Change to Ord_status of New 02/28/12
					//This way the order can be edited if needed because of bad data.
					//Set ord_status = 'N', OTM_Status = 'H', OTM_Call_Date = getdate()	
					//TimA 03/20/12 Use the local WH time
					//TimA 04/26/12 Multi Stage orders are still net to HOLD Status
//					If lsMultiStageStatus = 'M' then
//						Update Delivery_master
//						Set ord_status = 'H', OTM_Status = 'H', OTM_Call_Date = :ldtWhTime 
//						//Set ord_status = 'H', OTM_Status = 'H', OTM_Call_Date = getdate()
//						Where project_id = :lsProject and Do_No = :lsDONO ;
//						Commit;										
//					Else
					//write to screen
					lsLogOut = '       processing OTM Order - uf_pandora_outbound() for Do_No: ' + as_dono +' - Shuttle Flag: ' +string(ll_ShuttleFlag)
					lsLogOut += '       -SKIP OTM Flag: '+string(ll_SkipOTMFlag)
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) 

						Update Delivery_master
						Set ord_status = 'N', OTM_Status = 'H', OTM_Call_Date = :ldtWhTime 
						//Set ord_status = 'H', OTM_Status = 'H', OTM_Call_Date = getdate()
						Where project_id = :as_project and Do_No = :as_dono ;
						Commit;				
//					End if
					lsLogOut = '              Made OTM call for Do_No: ' + as_dono + " at " + String(Today(), "mm/dd/yyyy hh:mm:ss") +  ' OTM Status set was to OTM Hold ' 
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/				
				end if
			Else //SkipOTM
					//TimA 05/01/12
					If lsMultiStageStatus = 'M' then
						//Multi Stage Skip OTM
						lsLogOut = '              OTM Skipped for Do_No: ' + as_dono + " at " + String(Today(), "mm/dd/yyyy hh:mm:ss") +  ' Because this is an MTR Transfer Order ' 
						FileWrite(giLogFileNo,lsLogOut)
						gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/								
					Else
							//TimA 07/18/13 this was moved from u_nvo_process_files 1.55.1.0
							If lsOTM_Y_N = 'N' then
								Update Delivery_master
								Set ord_status = 'N', OTM_Status = 'N', User_Field1 = 'PIU', carrier = 'VNDRPIUSTD', transport_mode = 'GROUND',  ship_via = 'VENDOR PAID SHIPMENT'
								Where project_id = :as_project and Do_No = :as_dono ;
								Commit;
								lsLogOut = '              OTM Skipped for Do_No: ' + as_dono + " at " + String(Today(), "mm/dd/yyyy hh:mm:ss") +  ' Because this is an RTV-RMA' 
								FileWrite(giLogFileNo,lsLogOut)
								gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
							Else
		
								// LTK 20120511	Pandora #417 If *SHIP TO* Customer has Customer.UF1 in ('CB CUST','VNDRPIUSTD'), set DM.UF1 to 'SCH' or 'PIU' respectively.
								//						UF1 was already being set to 'SCH', check if there is a ship to customer override for UF1.
								if Len(ls_ship_to_override_UF1) > 0 then
									ls_UF1 = ls_ship_to_override_UF1
								end if
								ls_ship_to_override_UF1 = ""
		
								//TimA Pandora #396 skip the call to OTM and set the Schedule Code to "SCH"
								// LTK 20120511  Pandora #417 Changed value below for user_field1 from 'SCH' to :ls_UF1
								Update Delivery_master
								Set ord_status = 'N', OTM_Status = 'N', User_Field1 = :ls_UF1, carrier = :ls_to_customer_UF1, transport_mode = :ls_transport_mode, ship_ref = :ls_ship_ref, ship_via = :ls_ship_via
								Where project_id = :as_project and Do_No = :as_dono ;
								Commit;
								lsLogOut = '              OTM Skipped for Do_No: ' + as_dono + " at " + String(Today(), "mm/dd/yyyy hh:mm:ss") +  ' Because this is an Enterprise order ' 
								FileWrite(giLogFileNo,lsLogOut)
								gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/								
							End if
					End if
			End if  //Skip OTM
		End if  //If Shuttle
	Else  //Process OTM

		Update Delivery_master
		Set OTM_Status = :lsOTMStatus
		Where project_id = :as_project and Do_No = :as_dono ;
		Commit;
	End if //Process OTM

End If
ads_delivery_master.update()

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

