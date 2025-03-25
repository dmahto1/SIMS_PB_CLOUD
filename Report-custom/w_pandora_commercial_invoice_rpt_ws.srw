HA$PBExportHeader$w_pandora_commercial_invoice_rpt_ws.srw
$PBExportComments$Powerwave Commercial Invoice Report
forward
global type w_pandora_commercial_invoice_rpt_ws from window
end type
type st_curtain from statictext within w_pandora_commercial_invoice_rpt_ws
end type
type mle_error_results from multilineedit within w_pandora_commercial_invoice_rpt_ws
end type
type ole_1 from olecustomcontrol within w_pandora_commercial_invoice_rpt_ws
end type
end forward

global type w_pandora_commercial_invoice_rpt_ws from window
integer width = 3616
integer height = 2044
boolean titlebar = true
string title = "Pandora Commercial Invoice"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 134217750
string icon = "sims.ico"
event ue_mousemove pbm_mousemove
event ue_postopen ( )
event ue_update_successful_ci ( )
st_curtain st_curtain
mle_error_results mle_error_results
ole_1 ole_1
end type
global w_pandora_commercial_invoice_rpt_ws w_pandora_commercial_invoice_rpt_ws

type variables
PROTECTED:

String is_DONo, &
          is_OrdNo

m_report im_Menu

// LTK 20120120	The login and password below are for the production environment.  However, since we are populating the 
//						"Credentials:" in the header, these Menlo webservice tier login and password values will be ignored.
//18-Oct-2016 : Madhu- Removed "credentials" tag from XML ["<credentials><login>webservice</login><password>!pty58zgg</password></credentials>" + &]
Constant String PARAMS_XML = "<?xml version=~"1.0~" encoding=~"UTF-8~"?>" + &
										  "<MenloWebServices><CommercialInvoiceRequest>" + &
                                               "<criteria><Invoice>%s</Invoice><https>true</https></criteria></CommercialInvoiceRequest>" + &
                                               "</MenloWebServices>"

Constant String VERTICAL_POSITIONING = 	"~r~n~r~n~r~n~r~n"

Boolean ib_prior_successful_CI
String is_null
Boolean ib_uf22_nullable		// LTK 20120621 	Pandora #438  Flag to indicate that DM.UF22 was set to 'Y' upon this instance of the CI
									//						and can be nulled out upon an exception.
end variables
forward prototypes
public function long of_parsetoarray (string as_source, string as_delimiter, ref string as_array[])
public function boolean of_check_successful_ci ()
public function long of_update_ci_ind_field (string as_ci_ind)
end prototypes

event ue_postopen();/////////////////////////////////////////////////////////////////////////////////////////
//
//	Event:         ue_postopen
//
//  Author:       David Cervenan
//
//	Access:       Public
//
//	Arguments: None
//
//	Returns:      None
//
//	Description: Attempts to get the Commercial Invoice PDF document from
//                    the web service using the connection info obtained from the
//                    database.
//
//
//	Modification History: 
//
//	LTK 20110330	Modified the XML parameter message sent the server to 
//						include credentials.  Modified the display message of a
//						CI which has not been generated to display a user friendly
//						message, as opposed to the raw XML.  Suppressed the
//						"navigation canceled" page upon retrieving a valid CI.
//
//////////////////////////////////////////////////////////////////////////////////////////
String ls_URLString, &
          ls_URLArray[], &
          ls_Temp1, &
          ls_Temp2, &
          ls_ParamsXML, &
          ls_Credentials, &
          ls_Header, &
          ls_Result, &
          ls_Status, &
          ls_Message

Long   ll_UpperBound, &
          ll_Pos1, &
          ll_Pos2

Blob    lblb_PostData, &
          lblb_Result

SetNull(is_null)
//n_cst_encoder lnv_Encoder		// LTK 20110330  No longer needed

//n_cst_httphandler lnv_HTTP		// LTK 20110330  No longer needed


try
	//lnv_HTTP = create n_cst_httphandler		// LTK 20110330  No longer needed


	// LTK 20110505 	Pandora #187  Set instance variable if a prior CI has successfully been viewed.
	//						Udpate successful CI before navigation because the first time CI is run it opens up in a non
	//						powerbuilder window.  The ole documentcomplete event does not fire on this occasion.
	if NOT of_check_successful_ci() then
		of_update_ci_ind_field ('Y')
	end if
	
	// Get the URL string from websphere settings
	select Websphere_Settings.Connection_url_menloweb  
	  into :ls_URLString
	 from Websphere_Settings
	using SQLCA;
	
	// Parse the string to array using "|"
	ll_UpperBound = this.of_ParseToArray ( ls_URLString, "|", ls_URLArray )
	
	// Check if the array has values
	if not IsNull ( ll_UpperBound ) and ll_UpperBound <> 0 then
		// Insert the order number into the XML
		ll_Pos1            = Pos ( PARAMS_XML, "%s" )
		ll_Pos2            = Pos ( PARAMS_XML, "</Invoice>" )
		ls_Temp1        = Left ( PARAMS_XML, ll_Pos1 - 1 )
		ls_Temp2        = Mid ( PARAMS_XML, ll_Pos2 )
		ls_ParamsXML = ls_Temp1 + is_OrdNo + ls_Temp2
		lblb_PostData   = Blob ( ls_ParamsXML, EncodingANSI! )
		
		
		
		// LTK 20110330 	Commented out the call to lnv_HTTP.of_SendURLRequest() as the return value was
		// 						unauthorized access so the message could not be interrogated to determine if a
		//						PDF or XML was returned.
		
		
		
		// Check if array contains credentials
		//if ll_UpperBound > 1 then
		//	if ll_UpperBound = 2 then ls_URLArray[3] = ""
			
			//lnv_Encoder = create n_cst_encoder
			
			// Encrypt user ID and password in Base64
			//ls_Credentials = lnv_Encoder.of_EncodeBase64 ( ls_URLArray[2] + ":" + ls_URLArray[3] )
			
			//destroy lnv_Encoder
			/*
			// Post the request using credentials and post data behind the scenes to catch the error message if there is one
			if lnv_HTTP.of_SendURLRequest ( ls_URLArray[1], "Authorization: BASIC " + ls_Credentials + "~r~n", ls_ParamsXML, 0, 0, ls_Header, lblb_Result ) = -1 then

				MessageBox ( "Commercial Invoice", "An error occurred when attempting to obtain the Commercial Invoice: " + ls_Header, StopSign! )
				
				destroy lnv_HTTP
				
				Return
			else
				ls_Result = String ( lblb_Result, EncodingANSI! )
				
				// Check if we got XML back instead of PDF
				if Pos ( ls_Result, "<CommericalInvoiceRequest>" ) > 0 then
					// Check the success status
					ll_Pos1    = Pos ( ls_Result, "<Success>" )
					ll_Pos2    = Pos ( ls_Result, "</Success>" )
					ls_Status = Mid ( ls_Result, ( ll_Pos1 + 9 ), ( ll_Pos2 - 1 ) - ( ll_Pos1 + 9 ) )
					
					if Lower ( ls_Status ) = "false" then
						// Get the error message
						ll_Pos1       = Pos ( ls_Result, "<Message>" )
						ll_Pos2       = Pos ( ls_Result, "</Message>" )
						ls_Message = Mid ( ls_Result, ( ll_Pos1 + 9 ), ( ll_Pos2 - 1 ) - ( ll_Pos1 + 9 ) )
						
						MessageBox ( "Commercial Invoice", ls_Message, Exclamation! )
						
						destroy lnv_HTTP
						
						Return
					end if
				end if
			end if
			String ls_work
			ls_work = String(lblb_PostData,EncodingANSI!)
			*/
			// Post the request using credentials and post data and display the results in  the OLE
			//ole_1.Object.Navigate ( ls_URLArray[1], 0, "", lblb_PostData, "Authorization: BASIC " + ls_Credentials + "~r~n" )
			
		//else
			// Attemp to post the request with no credentials
		//	ole_1.Object.Navigate ( ls_URLArray[1], 0, "", lblb_PostData, "Content-Type: application/x-www-form-urlencoded~r~n" )
		//end if
		
		// LTK 20110330 	Added this lone post to the server.  This is an asychronous call so the processing of the results
		//						will be coded in the documentcomplete event of the OLE control.
		//ole_1.Object.Navigate ( ls_URLArray[1], 0, "", lblb_PostData, "" )

		// LTK 20111221	CI web call now posting via HTTPS.
		// Determine if we are running in Production.  SIMS has two NT service accounts, a production and a development (also used for the QA environment).
		// SIMS is posting via HTTPS so the service account credentials are being passed (encoded Base 64) in the header.
		String ls_production_env, ls_encoded_credentials

		ls_production_env = f_retrieve_parm('PANDORA','FLAG','CI_USE_PROD_SVC_ACCT')

		if Upper(ls_production_env) = 'Y' then
			ls_encoded_credentials = f_retrieve_parm('PANDORA','PARM','NT_SERVICE_ACCT_PROD')
		else
			ls_encoded_credentials = f_retrieve_parm('PANDORA','PARM','NT_SERVICE_ACCT_DEV')
		end if
				
		// LTK 20120120	Retrieve and send the Menlo Tier WebService credentials in the header if they are present in the database.  The header
		//						will now contain these credentials in addition to the SIMS NT Account authoriztion credentials.  
		//						***NOTE*** if the Credentials: are populated in the header, the Menlo WebService will ignore the id and pw
		//						passed in the XML.  The header will now have the following format (note: a space must exist after the colon):
		//
		//								Authorization: Basic <Base64 encoded id & pw string goes here for the SIMS NT Account used for HTTPS access>
		//								Credentials: <Base64 encoded id & pw string goes here for the Menlo Tier WebService credentials>
		//
		String ls_menlo_tier_credentials
		ls_menlo_tier_credentials = f_retrieve_parm('PANDORA','PARM','MENLO_TIER_WS_CREDS')
		if Len(ls_menlo_tier_credentials) > 0 then
			ls_menlo_tier_credentials = "~r~n" + "Credentials: " + ls_menlo_tier_credentials
		end if

		ole_1.Object.Navigate ( ls_URLArray[1], 0, "", lblb_PostData, "Authorization: Basic " + Trim(ls_encoded_credentials)  + Trim(ls_menlo_tier_credentials))
		// End of the HTTPS changes

	else
		// If we didn't get a URL string from above, then attempt to get the URL from the project_reports_detail table
		 select Project_Reports_Detail.URL
		    into :ls_URLString
		   from Project_Reports_Detail
		 where rtrim(ltrim(Project_Reports_Detail.Report_ID)) = 'PAND-LI'
		  using SQLCA;
		
		if not IsNull ( ls_URLString ) and Len ( ls_URLString ) <> 0 then
			
			ole_1.Object.Navigate ( ls_URLString )
		else
			// If we could not find a URL in either table, blank out the browser and alert user
			ole_1.Object.Navigate ( "about:blank" )
			
			// LTK 20110505 	Pandora #187  Reset the CI successful download indicator if not previously viewed.
			if NOT ib_prior_successful_ci then
				of_update_ci_ind_field (is_null)
			end if
			
			MessageBox ( "Commercial Invoice", "Could not find any connection information configured to obtain the Commercial Invoice.", Exclamation! )
		end if
	end if
	
	//destroy lnv_HTTP		// LTK 20110330  No longer needed
	
catch ( Throwable t )
	
	// LTK 20110505 	Pandora #187  Reset the CI successful download indicator if not previously viewed.
	if NOT ib_prior_successful_ci then
		of_update_ci_ind_field (is_null)
	end if

	MessageBox ( "Commercial Invoice", "An error occurred when attempting to obtain the Commercial Invoice: " + t.GetMessage ( ), StopSign! )
	
	//if IsValid ( lnv_Encoder ) then destroy lnv_Encoder		// LTK 20110330  No longer needed
	//if IsValid ( lnv_HTTP ) then destroy lnv_HTTP				// LTK 20110330  No longer needed
	
end try

end event

public function long of_parsetoarray (string as_source, string as_delimiter, ref string as_array[]);/////////////////////////////////////////////////////////////////////////////////////////
//
//	Function:     of_ParseToArray
//
//	Access:       Public
//
//	Arguments: String as_source
//	                  String as_delimiter
//	                  String as_array[] (By reference)
//
//	Returns:      Long
//
//	Description: Parse a string into array elements using a delimeter string.
//
//////////////////////////////////////////////////////////////////////////////////////////
Long   ll_DelLen, &
          ll_Pos, &
          ll_Count, &
          ll_Start, &
          ll_Length, &
          ll_Null

String ls_Holder, &
          ls_EmptyArray[]

// Check for NULL
if IsNull ( as_source ) or IsNull ( as_delimiter ) then
	SetNull ( ll_Null )
	
	Return ll_Null
end if

as_array = ls_EmptyArray

// Check for at least one entry
if Trim ( as_source ) = "" then
	Return 0
end if

// Get the length of the delimeter
ll_DelLen = Len ( as_delimiter )

ll_Pos = Pos ( Upper ( as_source ), Upper ( as_delimiter ) )

// Only one entry was found
if ll_Pos = 0 then
	as_array[1] = as_source

	Return 1
end if

// More than one entry was found - loop to get all of them
ll_Count = 0
ll_Start  = 1

do while ll_Pos > 0
	// Set current entry
	ll_Length = ll_Pos - ll_Start
	ls_Holder = Mid ( as_source, ll_Start, ll_Length )

	// Update array and counter
	ll_Count++
	as_array[ll_Count] = ls_Holder
	
	// Set the new starting position
	ll_Start = ll_Pos + ll_DelLen

	ll_Pos =  Pos ( Upper ( as_source ), Upper ( as_delimiter ), ll_Start )
loop

// Set last entry
ls_Holder = Mid ( as_source, ll_Start, Len ( as_source ) )

// Update array and counter if necessary
if Len ( ls_Holder ) > 0 then
	ll_Count++
	as_array[ll_Count] = ls_Holder
end if

// Return the number of entries found
Return ll_Count
end function

public function boolean of_check_successful_ci ();if NOT ib_prior_successful_CI then

	String ls_user_field22
	
	select user_field22
	into :ls_user_field22
	from delivery_master
	where do_no = :is_dono
	using sqlca;
	
	if sqlca.sqlcode = 0 then
		if Upper(Trim(ls_user_field22)) = 'Y' then
			ib_prior_successful_CI = TRUE
		end if
	end if
end if

return ib_prior_successful_CI

end function

public function long of_update_ci_ind_field (string as_ci_ind);// LTK 20120621  Pandora #438 comment out all of original function
//
//update delivery_master
//set user_field22 = :as_ci_ind
//where do_no = :is_dono
//using sqlca;		// autocommit is on
//
//if sqlca.sqlcode <> 0 then
//	Messagebox("Commercial Invoice","Unable to update delivery_master.user_field22!~r~r" + sqlca.sqlerrtext)
//end if
//
//return sqlca.sqlcode
//
// Pandora #438 end of original function


// LTK 20120621  Pandora #438 only set DM.UF22 to 'Y' if it does not contain a value or if DM.UF22 <> DM.awb_bol_no
String ls_user_field22, ls_awb_bol_no

select user_field22, awb_bol_no
into :ls_user_field22, :ls_awb_bol_no
from delivery_master
where do_no = :is_dono
using sqlca;

if sqlca.sqlcode = 0 then
	// DM.UF22 setting to 'Y' 		- Business rules indicate that DM.UF22 can be set to 'Y' if it does not contain a value or if DM.UF22 <> DM.awb_bol_no
	// DM.UF22 setting to NULL	- Ensure that the field was previously set to 'Y' upon this window instance
	if ( as_ci_ind = 'Y' and ( IsNull(ls_user_field22) or Trim(ls_user_field22) = "" or Upper(Trim(ls_user_field22)) <> Upper(Trim(ls_awb_bol_no))) )  &
		OR  ( IsNull(as_ci_ind) and ib_uf22_nullable = TRUE )  then

		update delivery_master
		set user_field22 = :as_ci_ind
		where do_no = :is_dono
		using sqlca;		// autocommit is on
		
		if sqlca.sqlcode <> 0 then
			Messagebox("Commercial Invoice","Unable to update delivery_master.user_field22!~r~r" + sqlca.sqlerrtext)
		else
			if as_ci_ind = 'Y' then
				ib_uf22_nullable = TRUE
			end if
		end if
		
	end if
else
	Messagebox("Commercial Invoice","Unable to retrieve CI w/AWB Printed and AWB/BOL Nbr!~r~r" + sqlca.sqlerrtext)
end if

return sqlca.sqlcode

end function

event resize;if sizetype = 0 or sizetype = 2 then
	ole_1.Width  = newwidth - 1
	ole_1.Height = newheight - 5
	
	st_curtain.Width  = newwidth - 1				// LTK 20110330  Added
	st_curtain.Height = newheight - 5				// LTK 20110330  Added
	
	mle_error_results.Width  = newwidth - 1	// LTK 20110330  Added
	mle_error_results.Height = newheight - 5	// LTK 20110330  Added
	
end if
end event

event open;//Jxlim 01/27/2012 Pandora-Otm BRD #337
Str_Parms	lStrparms
lstrparms = message.PowerobjectParm

If Not IsValid(w_do) And IsValid(w_Shipments)  Then		
			If UpperBound(lstrparms.String_arg) > 1 Then //Pass from shipment screen
				If Left(lstrparms.String_arg[2],6) = '*DONO*' Then /*DO_NO passed*/
					is_Dono = Mid(lstrparms.String_arg[2],7)	
					//Need order no to generate the CI from Pandora
					Select Invoice_no Into :is_OrdNo
					From Delivery_Master
					Where Do_no = :is_Dono
					Using SQLCA;
				End If	
			End If 
Else		//Jxlim 01/27/2012 Pandora-Otm BRD #337
	
			// We can only print based on DO_NO - User must have valid order open to pass DO_NO in from w_DO
			if IsValid ( w_do ) then
				if w_do.idw_main.RowCount ( ) > 0 then
					is_DONo = w_do.idw_main.GetItemString ( 1, "do_no" )
				end if
			end if
			
			if IsNull ( is_DONo ) or is_DONO = "" then
				Messagebox ( "Commercial Invoice", "You must have an order retrieved in the Delivery Order Window before you can print the Invoice.", Exclamation! )	
				Close ( this )	
				Return
			end if
			
			// Pack list must be generated
			if w_do.idw_pack.RowCount ( ) = 0 then
				Messagebox ( "Commercial Invoice", "You must generate the Pack List before you can print the Invoice.", Exclamation! )
				Close ( this )	
				Return
			end if

			is_OrdNo = w_do.tab_main.tabpage_main.sle_order.Text			
End If

this.event post ue_postopen ( )
end event

on w_pandora_commercial_invoice_rpt_ws.create
this.st_curtain=create st_curtain
this.mle_error_results=create mle_error_results
this.ole_1=create ole_1
this.Control[]={this.st_curtain,&
this.mle_error_results,&
this.ole_1}
end on

on w_pandora_commercial_invoice_rpt_ws.destroy
destroy(this.st_curtain)
destroy(this.mle_error_results)
destroy(this.ole_1)
end on

type st_curtain from statictext within w_pandora_commercial_invoice_rpt_ws
integer width = 3547
integer height = 1912
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please wait, the Commercial Invoice is being retrieved from server..."
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;this.text =	VERTICAL_POSITIONING + &
				"Please wait, the Commercial Invoice is being retrieved from server..." + &
				"~r~n(You may be required to enter your NT login credentials)"
end event

type mle_error_results from multilineedit within w_pandora_commercial_invoice_rpt_ws
integer width = 3547
integer height = 1912
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = center!
end type

type ole_1 from olecustomcontrol within w_pandora_commercial_invoice_rpt_ws
event statustextchange ( string text )
event progresschange ( long progress,  long progressmax )
event commandstatechange ( long command,  boolean enable )
event downloadbegin ( )
event downloadcomplete ( )
event titlechange ( string text )
event propertychange ( string szproperty )
event beforenavigate2 ( oleobject pdisp,  any url,  any flags,  any targetframename,  any postdata,  any headers,  ref boolean cancel )
event newwindow2 ( ref oleobject ppdisp,  ref boolean cancel )
event navigatecomplete2 ( oleobject pdisp,  any url )
event documentcomplete ( oleobject pdisp,  any url )
event onquit ( )
event onvisible ( boolean ocx_visible )
event ontoolbar ( boolean toolbar )
event onmenubar ( boolean menubar )
event onstatusbar ( boolean statusbar )
event onfullscreen ( boolean fullscreen )
event ontheatermode ( boolean theatermode )
event windowsetresizable ( boolean resizable )
event windowsetleft ( long left )
event windowsettop ( long top )
event windowsetwidth ( long ocx_width )
event windowsetheight ( long ocx_height )
event windowclosing ( boolean ischildwindow,  ref boolean cancel )
event clienttohostwindow ( ref long cx,  ref long cy )
event setsecurelockicon ( long securelockicon )
event filedownload ( ref boolean cancel )
event navigateerror ( oleobject pdisp,  any url,  any frame,  any statuscode,  ref boolean cancel )
event printtemplateinstantiation ( oleobject pdisp )
event printtemplateteardown ( oleobject pdisp )
event updatepagestatus ( oleobject pdisp,  any npage,  any fdone )
event privacyimpactedstatechange ( boolean bimpacted )
integer width = 3547
integer height = 1912
integer taborder = 20
boolean focusrectangle = false
string binarykey = "w_pandora_commercial_invoice_rpt_ws.win"
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

event downloadbegin();this.event ProgressChange ( 50, 100 )
end event

event downloadcomplete();this.event ProgressChange ( 100, 100 )
end event

event documentcomplete(oleobject pdisp, any url);// LTK 20110330 	Coded this event to handle the asynchronous processing.


try

	oleobject ole_2
	string ls_string

	Throwable lt_ex	

	//	ole_2 = ole_1.object.Document
	//	ls_string = ole_2.body.outerhtml

	if IsNull(ole_1.object.Document) then
		lt_ex = CREATE Throwable
		lt_ex.text = "Cannot process CI pdf because the following object is not valid:  ole_2.body.outerhtml ~r"
		lt_ex.text += "Please check the CI tool for status.~r~r"
		lt_ex.text += 'Escalations - pandoraonsiteit@con-way.com   '
		
		Throw lt_ex
	else
		ole_2 = ole_1.object.Document
	end if

	if IsNull(ole_2.body.outerhtml) then
		lt_ex = CREATE Throwable
		lt_ex.text = "Cannot process CI pdf because the following object is not valid:  ole_2.body.outerhtml ~r"
		lt_ex.text += "Please check the CI tool for status.~r~r"
		lt_ex.text += 'Escalations - pandoraonsiteit@con-way.com   '

		Throw lt_ex
	else
		ls_string = ole_2.body.outerhtml
	end if


	boolean lb_system_error

//	if Pos(ls_string, "unexpected run time error") > 0 then
//	
//		if Pos(ls_string, "not generated") > 0 then
//
//			mle_error_results.text = VERTICAL_POSITIONING + "Commercial Invoice not generated for order number: " + is_OrdNo
//			
//		elseif Pos(ls_string, "not found") > 0 then
//	
//			mle_error_results.text = VERTICAL_POSITIONING + "Commercial Invoice not found for order number: " + is_OrdNo
//
//		else
//			// Other CI errors
//
//			mle_error_results.text = VERTICAL_POSITIONING + "Error retrieving Commercial Invoice for order number: " + is_OrdNo
//			
//		end if
//		
//		mle_error_results.BringToTop = TRUE
//		mle_error_results.SetRedraw( TRUE )
//		parent.SetRedraw( TRUE )
//		
//	end if

	String ls_parsed_error, ls_string_lower
	Long ll_error_pos, ll_message_pos, ll_end_of_message

	ls_string_lower = lower(ls_string)		// use this string for searching
	ll_error_pos = Pos(ls_string_lower, "unexpected run time error")

	if 	ll_error_pos = 0 then
		ll_error_pos = Pos(ls_string_lower, "unexcepted runtime error")	// Menlo tier spelling issues
	end if

	// Menlo tier error messages are volatile in content and spelling so pull one from DB so that client does not need rebuilt due to this issue.
	if 	ll_error_pos = 0 then
		String ls_server_error_message
		ls_server_error_message = f_retrieve_parm('PANDORA','PARM','CI_SERVER_ERROR_MSG')
		if Len(ls_server_error_message) > 0 then
			ll_error_pos = Pos(ls_string_lower, ls_server_error_message)
		end if
	end if

	// Also look for excpetions and HTTP 500 errors
	if 	ll_error_pos = 0 then
		ll_error_pos = Pos(ls_string_lower, "exception")

		if ll_error_pos = 0 then
			ll_error_pos = Pos(ls_string_lower, "http 500")
		end if

		if ll_error_pos > 0 then
			lb_system_error = TRUE
		end if
	end if

	if ll_error_pos > 0 then

		// LTK 20111222	Pandora HTTPS changes.  Users no longer wish to display the Pandora's message.  They wish to display a more
		//						user friendly message.
		
//		// An error was returned, attempt to parse out the error message sent from Pandora.
//
//		ll_end_of_message = Pos(ls_string_lower,"</", ll_error_pos)
//
//		ll_message_pos = Pos(ls_string_lower, "commerical invoice", ll_error_pos)		// Menlo tier code spelling error
//		if ll_message_pos = 0 then
//			ll_message_pos = Pos(ls_string_lower, "commercial invoice", ll_error_pos)	// when spelling improves
//		end if
//		
//		if ll_message_pos > 0 then
//			
//			// Process the message here
//
//			if ll_end_of_message > 0 then
//				ls_parsed_error = Mid(ls_string, ll_message_pos, ll_end_of_message - ll_message_pos)
//			else 
//				ls_parsed_error = Right(ls_string, Len(ls_string) - ll_message_pos + 1)
//			end if
//
//		else
//			
//			// Have an unexpected error, but cannot parse it so just dislay the raw message.
//
//			if ll_end_of_message > 0 then
//				ls_parsed_error = Mid(ls_string, ll_error_pos, ll_end_of_message - ll_error_pos)
//			else
//				ls_parsed_error = Right(ls_string, Len(ls_string) - ll_error_pos + 1)
//			end if
//
//		end if
//
//		mle_error_results.text = VERTICAL_POSITIONING + ls_parsed_error

		// LTK 20111222	Pandora HTTPS changes.  The more user friendly message the users now want to display.
		//TimA 08/29/12 Pandora issue #461  Change the Escalations link
		if lb_system_error then
			// System error
			mle_error_results.text = VERTICAL_POSITIONING +	'System error retrieving Commercial Invoice    ~r~n' + &
																				'Please check the CI tool for status                  ~r~n' + &
																				'    Escalations - logistics-compliance@google.com   '

//																				'Escalations - pandoraonsiteit@con-way.com   '
		else
			// Pandora error
			mle_error_results.text = VERTICAL_POSITIONING +	'Commercial Invoice not Generated/Not found ~r~n' + &
																				'Please check the CI tool for status                  ~r~n' + &
																				'    Escalations - logistics-compliance@google.com   '

//																				'Escalations - pandoraonsiteit@con-way.com   '
																				
		end if
		// End of HTTPS error message change

		mle_error_results.BringToTop = TRUE
		mle_error_results.SetRedraw( TRUE )
		parent.SetRedraw( TRUE )
		
		// LTK 20110505 	Pandora #187  Reset the CI successful download indicator if not previously viewed.
		if NOT ib_prior_successful_ci then
			of_update_ci_ind_field (is_null)
		end if

	end if

catch ( Throwable t )

	if Left( t.GetMessage(),40 ) = "Name not found accessing external object" then

		// This is an expected exception upon a valid CI

	else
		// Unexpected exception
		
		// LTK 20110505 	Pandora #187  Reset the CI successful download indicator if not previously viewed.
		if NOT ib_prior_successful_ci then
			of_update_ci_ind_field (is_null)
		end if

		MessageBox ( "Commercial Invoice", "An error occurred when attempting to obtain the Commercial Invoice: " + t.GetMessage ( ), StopSign! )
		return
	end if

	ole_1.BringToTop = TRUE
	ole_1.SetRedraw( TRUE )
	parent.SetRedraw( TRUE )
	
finally

	st_curtain.visible = FALSE
	
end try

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
07w_pandora_commercial_invoice_rpt_ws.bin 
2B00000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff000000010000000000000000000000000000000000000000000000000000000050656a5001d2362100000003000001800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f0000000050656a5001d2362150656a5001d23621000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000030000009c000000000000000100000002fffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c00005034000031670000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c00005034000031670000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17w_pandora_commercial_invoice_rpt_ws.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
